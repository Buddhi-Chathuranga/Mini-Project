/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *  Logical unit: MediaItem
 *  Type        : Java Utility
 *  Component   : APPSRV
 *
 * ---------------------------------------------------------------------------
 * Date    Sign     Comment
 * ----------------------------------------------------------------------------
 * 210125  DEEKLK   AM2020R1-7316, Created.
 * 220113  DEEKLK   AM21R2-3805, Changed FS implementation to support AV scanner.
 * ---------------------------------------------------------------------------
 */
package com.ifsworld.appsrv.projection.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;
import java.io.*;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.nio.charset.StandardCharsets;
import java.sql.CallableStatement;
import java.util.HashMap;
import javax.imageio.ImageIO;
import net.coobird.thumbnailator.Thumbnails;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.ifsworld.fnd.fss.api.FileHandlerUtil;
import com.ifsworld.fnd.fss.api.FileStorageRequest;
import static com.ifsworld.fnd.fss.api.Constants.FILE_DATA;
import static com.ifsworld.fnd.fss.api.Constants.FILE_LENGTH;
import static com.ifsworld.fnd.fss.api.Constants.IFS_USER;
import static com.ifsworld.fnd.fss.api.Constants.SKIP_FILE_SCAN;
import static com.ifsworld.fnd.fss.api.Constants.RESPONSE_HEADER;
import com.ifsworld.fnd.fss.api.exception.FileStorageApiBaseException;
import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import com.ifsworld.fnd.odp.api.storage.model.StructureValue;
import java.math.BigDecimal;

public class MediaItemUtil {

   private String globalFileName = null;
   private String globalFileExtension = null;
   private String globalMediaType = null;
   private String globalRepository = null;
   private String globalIfsUser = null;
   private String globalSkipFileScan = null;
   private Map<String, Object> fsResponseHeaderParams =  new HashMap<>();

   private long globalItemId = 0;
   private long globalFileLength = 0;
   private static final String LUNAMEFORFSS = "mediaitem"; // Must be in lowercase letters

   public Map<String, Object> readMediaItem(final Map<String, Object> parameters, final Connection connection) throws Exception {
      InputStream returnInputStream = null;
      Map<String, Object> returnMap = new HashMap<>();
      try {
         paramExtractor(parameters);

         globalRepository = getMediaItemRepository(connection);

         if ("FILE_STORAGE".equals(globalRepository)) {
            final Map<String, Object> fileStorageReqParams = getFileStorageReqParams();
            returnInputStream = readMediaObjectFss(fileStorageReqParams);
         } else {
            returnInputStream = readMediaObjectDb(connection);
         }
      } catch (ProjectionException ex) {
         throw new ProjectionException("Error while reading the media item. Details: " + ex.getMessage(), ex, ex.getCustomCode());
      } catch (Exception e) {
         throw new ProjectionException("Error while reading the media item. Details: " + e.getMessage());
      }

      if (returnInputStream != null) {
         returnMap.put("MediaObject", returnInputStream);
      } else {
         returnMap.put("MediaObject", null);
      }

      if (fsResponseHeaderParams != null && !fsResponseHeaderParams.isEmpty()) {
         returnMap.put(RESPONSE_HEADER, fsResponseHeaderParams);
      }

      return returnMap;
   }

   public Map<String, Object> updateMediaItem(final Map<String, Object> parameters, final Connection connection) throws Exception {
      Map<String, Object> returnMap = new HashMap<>();

      try {
         paramExtractor(parameters);

         globalRepository = getMediaItemRepository(connection);

         /* Current Media Handling does not allow users to update the Media Object once uploaded
          * Below check is in place until we get the Access Control Option for Media*/
         isUpdateAllowed(connection);

         InputStream mediaObjectInputStream = (InputStream) parameters.get("MediaObject");
         globalFileExtension = globalFileName.substring(globalFileName.lastIndexOf(".")).toLowerCase();
         globalMediaType = getMediaType();

         /* Save the original content in a byte array.
             * We need this since we need the data two times, once for saving it
             * to the database and once for creating a thumbnail.
             * We do not want to use the temporary image used to create the thumbnail,
             * since that temporary image will be modified (encoded twice, kind of...) compared to the original.*/
         ByteArrayOutputStream os = new ByteArrayOutputStream();
         byte[] buffer = new byte[1024];
         int len;

         while ((len = mediaObjectInputStream.read(buffer)) != -1) {
            os.write(buffer, 0, len);
         }

         byte[] originalImageByteArray = os.toByteArray();
         ByteArrayInputStream originalImageInputStream;

         if (globalMediaType.equals("TEXT")) {
            /* Only UTF-8 is supported.
             * If a text file with another charachter encoding is uploaded, it might not look correct.  */
            updateMediaTextDb(new String(originalImageByteArray, StandardCharsets.UTF_8), connection);
         } else {
            originalImageInputStream = new ByteArrayInputStream(originalImageByteArray);

            if ("FILE_STORAGE".equals(globalRepository)) {
               updateMediaObjectFss(originalImageInputStream);
            } else {
               updateMediaObjectDb(originalImageInputStream, connection);
            }
         }

         setMediaAttributes(connection);

         if (globalMediaType.equals("IMAGE")) {
            originalImageInputStream = new ByteArrayInputStream(originalImageByteArray);

            ByteArrayOutputStream thumbImgOutputStream = new ByteArrayOutputStream();

            /* Thumbnails can always be saved as JPEGs, to keep the size down */
            ImageIO.write(resizeImage(originalImageInputStream), "jpg", thumbImgOutputStream);
            updateMediaThumbDb(new ByteArrayInputStream(thumbImgOutputStream.toByteArray()), connection);
         }
      } catch (ProjectionException ex) {
         throw new ProjectionException("Error while updating the media item. Details: " + ex.getMessage(), ex, ex.getCustomCode());
      } catch (Exception e) {
         throw new Exception("Error while updating the media item. Details: " + e.getMessage());
      }

      if (fsResponseHeaderParams != null && !"".equals(fsResponseHeaderParams)) {
         returnMap.put(RESPONSE_HEADER, fsResponseHeaderParams);
      }

      return returnMap;
   }

   public Map<String, Object> deleteMediaItem(final Map<String, Object> parameters, final Connection connection) throws Exception {
      Map<String, Object> returnMap = new HashMap<>();

      try {
         paramExtractor(parameters);

         globalRepository = getMediaItemRepository(connection);

         deleteMediaItem(connection);
         if ("FILE_STORAGE".equals(globalRepository) && checkFileExistFss()) {
            final Map<String, Object> fileStorageReqParams = getFileStorageReqParams();
            deleteFromFss(fileStorageReqParams);
         }
      } catch (Exception e) {
         connection.rollback();
         throw new Exception("Error while deleting the media item. Details: " + e.getMessage());
      }

      return returnMap;
   }

   private InputStream readMediaObjectDb(Connection connection) throws SQLException {
      InputStream returnInputStream = null;
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Get_Media_Item(?, ?)}");

      try {
         stmt.registerOutParameter(1, java.sql.Types.BLOB);
         stmt.setLong(2, globalItemId);
         stmt.execute();

         /* Check the size of blob before appending to stream */
         if (stmt.getBlob(1) != null) {
            returnInputStream = stmt.getBlob(1).getBinaryStream();
         }
      } catch (SQLException e) {
         throw new SQLException("Failed to read the media object data from Database " + e.getMessage());
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }
      return returnInputStream;
   }

   private InputStream readMediaObjectFss(final Map<String, Object> fileStorageReqParams) throws Exception {
      InputStream returnInputStream = null;
      String errorMsg = "Failed to read the media object data from File Storage. ";
      Map<String, Object> outputParameters = new HashMap();
      FileStorageRequest fileStorageRequest = new FileStorageRequest(Long.toString(globalItemId), LUNAMEFORFSS, fileStorageReqParams);

      try {
         long start = System.currentTimeMillis();
         System.out.println("Downloading media file " + Long.toString(globalItemId) + " from File Storage...");
         outputParameters = FileHandlerUtil.downloadFile(fileStorageRequest);
         System.out.println("Done. Elapsed: " + (System.currentTimeMillis() - start));

         handlePollingUrl(outputParameters);

         returnInputStream = (InputStream) outputParameters.get(FILE_DATA);
      } catch (FileStorageApiBaseException ex) {
         if ("FSS_RESOURCE_NOTFOUND".equals(ex.getErrorCode())) {
            System.out.println("No File exists in File Storage...");
         } else {
            handleFssException(ex, errorMsg);
         }
      } catch (Exception e) {
         System.out.println(errorMsg + e.getMessage());
         throw new Exception(errorMsg, e);
      }

      return returnInputStream;
   }

   private void updateMediaTextDb(String text, Connection connection) throws SQLException {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Write_Media_Text(?, ?)}");

      try {
         stmt.setLong(1, globalItemId);
         stmt.setString(2, text);
         stmt.execute();
      } catch (SQLException e) {
         throw new SQLException("Failed to save the media text data. " + e.getMessage());
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }
   }

   private void updateMediaObjectDb(InputStream stream, Connection connection) throws SQLException {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Write_Media_Object(?, ?)}");

      try {
         stmt.setLong(1, globalItemId);
         stmt.setBinaryStream(2, stream);
         stmt.execute();
      } catch (SQLException e) {
         throw new SQLException("Failed to save the media object data in Database. " + e.getMessage());
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }
   }

   private void updateMediaObjectFss(InputStream stream) throws Exception {
      Map<String, Object> outputParameters = new HashMap<>();
      final Map<String, Object> fileStorageReqParams = getFileStorageReqParams();
      String errorMsg = "Failed to save the media object data in File Storage. ";
      try {
         long start = System.currentTimeMillis();
         System.out.println("Sending media file to File Storage...");
         FileStorageRequest fileStorageRequest = new FileStorageRequest(Long.toString(globalItemId), LUNAMEFORFSS, globalFileName, fileStorageReqParams).setFileData(stream);
         outputParameters = FileHandlerUtil.uploadFile(fileStorageRequest);
         System.out.println("Done. Elapsed: " + (System.currentTimeMillis() - start));

         handlePollingUrl(outputParameters);
      } catch (FileStorageApiBaseException ex) {
         handleFssException(ex, errorMsg);
      } catch (Exception e) {
         System.out.println(errorMsg + e.getMessage());
         throw new Exception(errorMsg, e);
      }
   }

   private void handlePollingUrl(Map<String, Object> outputParameters) {
      if (outputParameters.containsKey(RESPONSE_HEADER) && outputParameters.get(RESPONSE_HEADER) != null) {
         fsResponseHeaderParams = (Map)outputParameters.get(RESPONSE_HEADER);
      }
   }

   private void updateMediaThumbDb(InputStream stream, Connection connection) throws SQLException {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Write_Media_Thumb(?, ?)}");

      try {
         stmt.setLong(1, globalItemId);
         stmt.setBinaryStream(2, stream);
         stmt.execute();
      } catch (SQLException e) {
         throw new SQLException("Failed to save the media thumb data. " + e.getMessage());
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }
   }

   private void deleteMediaItem(Connection connection) throws Exception {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Remove_Media_Item(?)}");

      try {
         stmt.setLong(1, globalItemId);
         stmt.execute();
      } catch (SQLException e) {
         throw new SQLException("Failed to delete the media item. " + e.getMessage());
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }
   }

   private void deleteFromFss(final Map<String, Object> fileStorageReqParams) throws Exception {
      Map<String, Object> outputParameters = new HashMap<>();
      String errorMsg = "Failed to delete the media object data from File Storage. ";

      try {
         long start = System.currentTimeMillis();
         System.out.println("Sending media info to File Storage...");
         FileStorageRequest fileStorageRequest = new FileStorageRequest(Long.toString(globalItemId), LUNAMEFORFSS, fileStorageReqParams);
         outputParameters = FileHandlerUtil.deleteFile(fileStorageRequest);
         System.out.println("Done. Elapsed: " + (System.currentTimeMillis() - start));
      } catch (FileStorageApiBaseException ex) {
         handleFssException(ex, errorMsg);
      } catch (Exception e) {
         System.out.println(errorMsg + e.getMessage());
         throw new Exception(errorMsg, e);
      }
   }

   private void deleteFromDb(Connection connection) throws Exception {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Remove_Media_Object(?)}");

      try {
         stmt.setLong(1, globalItemId);
         stmt.execute();
      } catch (SQLException e) {
         throw new SQLException("Failed to delete the media object data in Database. " + e.getMessage());
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }
   }

   private void isUpdateAllowed(Connection connection) throws Exception {
      boolean flag;
      if ("FILE_STORAGE".equals(globalRepository)) {
         flag = isUpdateAllowedFss();
      } else {
         flag = isUpdateAllowedDb(connection);
      }

      if (!flag) {
         throw new Exception("Updating a media item is not allowed.");
      }
   }

   private boolean isUpdateAllowedDb(Connection connection) throws SQLException, Exception {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Is_Update_Allowed(?, ?)}");
      String flag = null;

      try {
         stmt.registerOutParameter(1, java.sql.Types.VARCHAR);
         stmt.setLong(2, globalItemId);
         stmt.execute();
         flag = stmt.getString(1);
      } catch (SQLException e) {
         throw new SQLException("Failed to check DB media object updatable or not. " + e.getMessage());
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }
      if ("TRUE".equals(flag)) {
         return true;
      }
      return false;
   }

   private boolean isUpdateAllowedFss() throws Exception {
      try {
         return !checkFileExistFss();
      } catch (Exception e) {
         throw new Exception("Failed to check File Storage media object updatable or not. " + e.getMessage());
      }
   }

   private boolean checkFileExistFss() throws Exception {
      final Map<String, Object> outputParameters;
      String errorMsg = "Failed to check the existence of File Storage File. ";

      final Map<String, Object> fileStorageReqParams = getFileStorageReqParams();

      try {
         FileStorageRequest fileStorageRequest = new FileStorageRequest(Long.toString(globalItemId), LUNAMEFORFSS, fileStorageReqParams);
         outputParameters = FileHandlerUtil.getFileProperties(fileStorageRequest);
      } catch (FileStorageApiBaseException ex) {
         if ("FSS_RESOURCE_NOTFOUND".equals(ex.getErrorCode())) {
            System.out.println("No File exists in File Storage...");
            return false;
         } else {
            handleFssException(ex, errorMsg);
         }
      } catch (Exception e) {
         System.out.println(errorMsg + e.getMessage());
         throw new Exception(errorMsg, e);
      }

      return true;
   }

   private String getMediaType() throws Exception {
      if (isImage()) {
         return "IMAGE";
      } else if (isAudio()) {
         return "AUDIO";
      } else if (isVideo()) {
         return "VIDEO";
      } else if (isText()) {
         return "TEXT";
      } else {
         /* Adding this for security, to restrict any other file types in. ex: executable files
          * Client restricts other types but still can be an issue if sent via accessing the projection. */
         throw new Exception("The file extension is not under accepted extensions.");
      }
   }

   private void setMediaAttributes(Connection connection) throws SQLException {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Set_Media_Attributes(?, ?, ?)}");

      try {
         stmt.setLong(1, globalItemId);
         stmt.setString(2, globalMediaType);
         stmt.setString(3, globalFileName);
         stmt.execute();
      } catch (SQLException e) {
         throw new SQLException("Failed to change the media attributes. " + e.getMessage());
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }
   }

   private void setMediaItemType(Connection connection) throws SQLException {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Set_Media_Item_Type(?, ?)}");

      try {
         stmt.setLong(1, globalItemId);
         stmt.setString(2, globalMediaType);
         stmt.execute();
      } catch (SQLException e) {
         throw new SQLException("Failed to change the media item type. " + e.getMessage());
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }
   }

   private void setMediaFile(Connection connection) throws SQLException {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Set_Media_File(?, ?)}");

      try {
         stmt.setLong(1, globalItemId);
         stmt.setString(2, globalFileName);
         stmt.execute();
      } catch (SQLException e) {
         throw new SQLException("Failed to change the media file. " + e.getMessage());
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }
   }

   private boolean isImage() {
      return globalFileExtension.matches("\\.(png|jpg|jpeg|gif|bmp|tif)");
   }

   private boolean isAudio() {
      return globalFileExtension.matches("\\.(mp3|wma|ogg|mid|aac|wav)");
   }

   private boolean isVideo() {
      return globalFileExtension.matches("\\.(mkv|mp4|flv|vob|avi|wmv|mov|mng|amv|mpeg|mpv|m4v|3gp|mxf)");
   }

   private boolean isText() {
      return globalFileExtension.matches("\\.(txt)");
   }

   public BufferedImage resizeImage(InputStream originalImageInputStream) throws IOException {
      /* To fix orientation changes we use Thumbnailtor library... */
      BufferedImage src = Thumbnails.of(originalImageInputStream).scale(1).asBufferedImage();

      /* Resizing the image to keep the correct ratio. */
      float scale = Math.max((float) (src.getWidth() / 100.0), (float) (src.getHeight() / 100.0));
      int width = Math.round(src.getWidth() / scale);
      int height = Math.round(src.getHeight() / scale);

      BufferedImage img = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

      img.createGraphics().drawImage(src.getScaledInstance(width, height, Image.SCALE_SMOOTH), 0, 0, null);

      return img;
   }

   private String getMediaItemRepository(Connection connection) throws Exception {
      String repoInfo = null;
      try ( PreparedStatement pstmt = connection.prepareStatement("SELECT Media_Item_API.Get_Repository_Db(?) RepInfo FROM DUAL")) {
         pstmt.setLong(1, globalItemId);
         ResultSet resultSet = pstmt.executeQuery();
         while (resultSet.next()) {
            repoInfo = resultSet.getString("RepInfo");
         }
      } catch (SQLException e) {
         throw new Exception("Failed to get Media Item Repository Details. " + e.getMessage());
      }
      return repoInfo;
   }

   public void moveFromDbToFss(final Map<String, Object> parameters, final Connection connection) throws Exception {
      globalRepository = "FILE_STORAGE";

      try {
         paramExtractor(parameters);

         InputStream inputStream = readMediaObjectDb(connection);

         if (inputStream != null) {
            updateMediaObjectFss(inputStream);
            deleteFromDb(connection);
         }
         setMediaItemRepository(connection);
      } catch (Exception e) {
         //LOG HERE FAILED DETAILS
         throw new Exception("Failed to move from DB to File Storage. " + e.getMessage());
      }
      //LOG HERE SUCCESS DETAILS
   }

   public void moveFromFssToDb(final Map<String, Object> parameters, final Connection connection) throws Exception {      
      globalRepository = "DATABASE";

      try {
         paramExtractor(parameters);
         final Map<String, Object> fileStorageReqParams = getFileStorageReqParams();
         InputStream inputStream = readMediaObjectFss(fileStorageReqParams);

         if (inputStream != null) {
            updateMediaObjectDb(inputStream, connection);
            deleteFromFss(fileStorageReqParams);
         }
         setMediaItemRepository(connection);
      } catch (Exception e) {
         //LOG HERE FAILED DETAILS
         throw new Exception("Failed to move from File Storage to DB. " + e.getMessage());
      }
   }

   private void setMediaItemRepository(Connection connection) throws SQLException {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Set_Media_Item_Repository(?, ?)}");

      try {
         stmt.setLong(1, globalItemId);
         stmt.setString(2, globalRepository);
         stmt.execute();
      } catch (SQLException e) {
         throw new SQLException("Failed to change the media item repository. " + e.getMessage());
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }
   }

   public static String validateTextObject(String objectName, StructureValue values, Map<String, Object> defaultValues, boolean emptyAllowed) throws ProjectionException {
      String textObject = values.getString(objectName);
      if (!emptyAllowed) {
         if (textObject == null || textObject.length() == 0) {
            if (!defaultValues.containsKey(objectName) || defaultValues.get(objectName) == null || ((String) defaultValues.get(objectName)).length() == 0) {
               throw new ProjectionException("Value for " + objectName + " is missing.");
            } else {
               return (String) defaultValues.get(objectName);
            }
         }
      }
      return textObject;
   }

   public static double validateNumberObject(String objectName, StructureValue values, Map<String, Object> defaultValues, boolean emptyAllowed) throws ProjectionException {
      BigDecimal numObject = values.getDecimal(objectName);
      if (numObject == null) {
         if (!emptyAllowed) {
            if (!defaultValues.containsKey(objectName) || defaultValues.get(objectName) == null || ((String) defaultValues.get(objectName)).length() == 0) {
               throw new ProjectionException("Value for " + objectName + " is missing.");
            } else {
               return (double) defaultValues.get(objectName);
            }
         }
         return 0;
      }
      return numObject.doubleValue();
   }

   private void handleFssException(FileStorageApiBaseException ex, String errorMsg) throws Exception {
      if ("UNHANDLED_EXCEPTION".equals(ex.getErrorCode())) {
         System.out.println(errorMsg + ex.getMessage());
         throw new Exception(errorMsg, ex);
      } else if (ex.getErrorCode().equals("THREAT_DETECTED") || ex.getErrorCode().equals("QUEUED_FOR_SCANNING")) {
         throw new ProjectionException(ex, ex.getErrorCode());
      } else {
         throw new Exception(errorMsg + ex.getMessage());
      }
   }

   private Map<String, Object> getFileStorageReqParams() throws Exception {
      Map<String, Object> fileStorageReqParams = new HashMap<>();
      fileStorageReqParams.put(FILE_LENGTH, globalFileLength);
      if (globalIfsUser != null) {
         fileStorageReqParams.put(IFS_USER, globalIfsUser);
      }
      if (globalSkipFileScan != null) {
         fileStorageReqParams.put(SKIP_FILE_SCAN, globalSkipFileScan);
      }
      return fileStorageReqParams;
   }

   private void paramExtractor(Map<String, Object> keyList) {
      for (String key : keyList.keySet()) {
         if ("ItemId".equals(key)) {
            globalItemId = new Long(keyList.get(key).toString());
         }
         if ("FileName".equals(key)) {
            globalFileName = keyList.get(key).toString();
         }
         if ("FileLength".equals(key)) {
            globalFileLength = new Long(keyList.get(key).toString());
         }
         if (IFS_USER.equals(key)) {
            globalIfsUser = keyList.get(key).toString();
         }
         if (SKIP_FILE_SCAN.equals(key)) {
            globalSkipFileScan = keyList.get(key).toString();
         }
      }
      //for debugging purposes
      keyList.entrySet().forEach(entry -> {
         System.out.println("Checking map parameters " + entry.getKey() + " " + entry.getValue());
      });
   }

}
