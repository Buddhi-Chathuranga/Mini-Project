/*
 *  Template:     3.0
 *  Built by:     IFS Developer Studio
 *
 *  Logical unit: MediaPanel
 *  Type:         Entity
 *  Component:    APPSRV
 *
 * ---------------------------------------------------------------------------
 * Date    Sign    Comment
 * ----------------------------------------------------------------------------
 * 200415  MDAHSE  SAXTEND-3383, First version, based on what KRRALK sent me.
 * 200810  MAABSE  TEAURENAFW-3248, Readd this file after its has been renamed to MediaLibraryStream..., will soon be obsolete and removed.
 * 200908  MAABSE  AM2020R1-5888, Remove explicit commit in java projection code.
 * ---------------------------------------------------------------------------
 */

package com.ifsworld.projection;

import com.ifsworld.fnd.odp.api.exception.ProjectionException;
import java.io.InputStream;
import javax.ejb.Stateless;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.io.*;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.nio.charset.StandardCharsets;
import java.sql.CallableStatement;
import javax.imageio.ImageIO;

/*
 * Implementation class that contains Read, Update and Delete methods for Stream type entity attributes
 * which are marked with implementation = "Java" in the MediaPanel projection model.
 */

@Stateless(name="MediaPanelStreamAttributesHandler")
public class MediaPanelStreamAttributesHandlerImpl  implements MediaPanelStreamAttributesHandler {

   @Override
   public Map<String, Object> updateMediaItemMediaObject(final Map<String, Object> parameters, final Connection connection) {

      // MDAHSE, 2020-04-15, It seems we really don't have to return
      // anything, since the data will be retrieved using a database
      // call. So we will return an empty hash map and save some code.

      Map<String, Object> imgMap = new HashMap<>();

      try {


         String fileName = (String)parameters.get("FileName");
         String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();

         InputStream mediaObjectInputStream = (InputStream)parameters.get("MediaObject");

         // Save the original content in a byte array. We need this
         // since we need the data two times, once for saving it
         // to the database and once for creating a thumbnail. We
         // do not want to use the temporary image used to create
         // the thumbnail, since that temporary image will be modified
         // (encoded twice, kind of...) compared to the original.

         ByteArrayOutputStream os = new ByteArrayOutputStream();
         byte[] buffer = new byte[1024];
         int len;
         while ((len = mediaObjectInputStream.read(buffer)) != -1) {
            os.write(buffer, 0, len);
         }
         byte[] originalImageByteArray = os.toByteArray();
        
         long itemId = (new Long(parameters.get("ItemId").toString()));

         ByteArrayInputStream originalImageInputStream;

         if (isText(extension)) {
            // Only UTF-8 is supported. If a text file with another charachter encoding
            // is uploaded, it might not look correct.
            updateMediaText (itemId, new String (originalImageByteArray, StandardCharsets.UTF_8), connection);
         } else {
            // Here is the first use of the original image bytes,
            // where we just use them for saving to the database.
            originalImageInputStream = new ByteArrayInputStream(originalImageByteArray);
            updateMediaObject (itemId, originalImageInputStream, connection);
         }

//         setMediaItemType (itemId, getMediaType (extension), connection);
//         setMediaFile (itemId, fileName, connection);
         setMediaAttributes (itemId, getMediaType (extension), fileName, connection);

         if (isImage(extension)) {

            // Second use. Create a temporary image of the original,
            // in order to create a scaled thumbnail version.

            originalImageInputStream = new ByteArrayInputStream(originalImageByteArray);
            ByteArrayOutputStream thumbImgOutputStream = new ByteArrayOutputStream();

            // Thumbnails can always be saved as JPEGs, to keep the size down
            ImageIO.write(resizeImage(ImageIO.read(originalImageInputStream)), "jpg", thumbImgOutputStream);
            updateMediaThumb (itemId, new ByteArrayInputStream(thumbImgOutputStream.toByteArray()), connection);            
         }

      } catch (SQLException | IOException e) {
         System.out.println ("There was a problem saving the media item. Error: " + e.getMessage());
         throw new ProjectionException("Error when updating image" , e);
      }
      return imgMap;
   }

   public BufferedImage resizeImage(BufferedImage src) throws IOException {
     BufferedImage img = new BufferedImage(100, 100, BufferedImage.TYPE_INT_RGB);
     img.createGraphics().drawImage(src.getScaledInstance(100, 100, Image.SCALE_SMOOTH),0,0,null);
     return img;
   }

   @Override
   public Map<String, Object> readMediaItemMediaObject(final Map<String, Object> parameters, final Connection connection) {
      // This code is not really needed since the media item is fetched from GetMediaFileStream, which uses PL/SQL.
      throw new ProjectionException("Not supported.");
   }

   @Override
   public Map<String, Object> deleteMediaItemMediaObject(final Map<String, Object> parameters, final Connection connection) {
      // We delete attached media items from a separate page
      throw new ProjectionException("Not supported.");
   }
   
   private void updateMediaObject (long itemId, ByteArrayInputStream stream, Connection connection) throws SQLException {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Write_Media_Object(?, ?)}");
      try {
         stmt.setLong(1, itemId);
         stmt.setBinaryStream(2, stream);
         stmt.execute();      
      } 
      catch (SQLException e)
      {
         throw new SQLException("Failed to save the media object data. " + e.getMessage());
      }
      finally 
      {
        if (stmt != null) { stmt.close(); }
      }
   }

   private void updateMediaThumb (long itemId, ByteArrayInputStream stream, Connection connection) throws SQLException {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Write_Media_Thumb(?, ?)}");
      try {
         stmt.setLong(1, itemId);
         stmt.setBinaryStream(2, stream);
         stmt.execute();      
      } 
      catch (SQLException e)
      {
         throw new SQLException("Failed to save the media thumb data. " + e.getMessage());
      }
      finally 
      {
        if (stmt != null) { stmt.close(); }
      }
   }

   private void updateMediaText (long itemId, String text, Connection connection) throws SQLException {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Write_Media_Text(?, ?)}");
      try {
         stmt.setLong(1, itemId);
         stmt.setString(2, text);
         stmt.execute();      
      } 
      catch (SQLException e)
      {
         throw new SQLException("Failed to save the media text data. " + e.getMessage());
      }
      finally 
      {
        if (stmt != null) { stmt.close(); }
      }
   }

   private void setMediaItemType (long itemId, String mediaItemType, Connection connection) throws SQLException {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Set_Media_Item_Type(?, ?)}");
      try {
         stmt.setLong(1, itemId);
         stmt.setString(2, mediaItemType);
         stmt.execute();      
      } 
      catch (SQLException e)
      {
         throw new SQLException("Failed to change the media item type. " + e.getMessage());
      }
      finally 
      {
        if (stmt != null) { stmt.close(); }
      }
   }
        
   private void setMediaFile (long itemId, String mediaFile, Connection connection) throws SQLException {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Set_Media_File(?, ?)}");
      try {
         stmt.setLong(1, itemId);
         stmt.setString(2, mediaFile);
         stmt.execute();      
      } 
      catch (SQLException e)
      {
         throw new SQLException("Failed to change the media file. " + e.getMessage());
      }
      finally 
      {
        if (stmt != null) { stmt.close(); }
      }
   }
        
   private void setMediaAttributes (long itemId, String mediaItemType, String mediaFile, Connection connection) throws SQLException {
      CallableStatement stmt = connection.prepareCall("{call Media_Item_API.Set_Media_Attributes(?, ?, ?)}");
      try {
         stmt.setLong(1, itemId);
         stmt.setString(2, mediaItemType);
         stmt.setString(3, mediaFile);
         stmt.execute();      
      } 
      catch (SQLException e)
      {
         throw new SQLException("Failed to change the media attributes. " + e.getMessage());
      }
      finally 
      {
        if (stmt != null) { stmt.close(); }
      }
   }
        
   private boolean isImage(String extension) {
      return extension.matches("\\.(png|jpg|jpeg|gif|bmp|tif)");
   }

   private boolean isAudio(String extension) {
      return extension.matches("\\.(mp3|wma|ogg|mid|aac|wav)");
   }

   private boolean isVideo(String extension) {
      return extension.matches("\\.(mkv|mp4|flv|vob|avi|wmv|mov|mng|amv|mpeg|mpv|m4v|3gp|mxf)");
   }

   private boolean isText(String extension) {
      return extension.matches("\\.txt");
   }

   private String getMediaType(String extension) {
      if (isImage (extension)) {
         return "IMAGE";
      } else if (isAudio(extension)) {
         return "AUDIO";
      } else if (isVideo(extension)) {
         return "VIDEO";
      } else {
         return "TEXT";
      }
   }
}
