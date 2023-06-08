/*
 *                 IFS Research & Development
 *
 *  This program is protected by copyright law and by international
 *  conventions. All licensing, renting, lending or copying (including
 *  for private use), and all other use of the program, which is not
 *  expressively permitted by IFS Research & Development (IFS), is a
 *  violation of the rights of IFS. Such violations will be reported to the
 *  appropriate authorities.
 *
 *  VIOLATIONS OF ANY COPYRIGHT IS PUNISHABLE BY LAW AND CAN LEAD
 *  TO UP TO TWO YEARS OF IMPRISONMENT AND LIABILITY TO PAY DAMAGES.
 */
package ifs.cloud.fsmigtool;

import ifs.cloud.fsmigtool.exception.UserException;
import ifs.cloud.fsmigtool.utils.Constants;
import ifs.cloud.fsmigtool.logging.MediaLogManager;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.regex.Pattern;
import javax.json.Json;
import javax.json.JsonObject;
import javax.ws.rs.HttpMethod;

class MediaMigrationHandler {

   private static final String BUCKET_NAME = "mediaitem";

   private Map<String, Object> mediaItemParam;
   private ArrayList<Map<String, Object>> mediaItemParamList;
   private Iterator<Map<String, Object>> mediaItemParamListIterator;

   private final SourceDbConnectionManager dbConnection;
   private final CommandLineHandler cmdHandler;
   private final MediaLogManager mediaLogger;

   private static final String QUERY_BASIC = "SELECT item_id           item_id, "
                                           + "   NVL(media_file, name) file_name "
                                           + "FROM media_item_tab "
                                           + "WHERE media_item_type != 'TEXT' ";

   public MediaMigrationHandler(CommandLineHandler cmdHandler, SourceDbConnectionManager dbConnection) throws SQLException, IOException, UserException {
      this.cmdHandler = cmdHandler;
      this.dbConnection = dbConnection;
      mediaLogger = new MediaLogManager(this.dbConnection, cmdHandler);
      setParamList();
      setParamListIterator();
   }

   private void setParamList() throws SQLException, IOException, UserException {
      mediaItemParamList = new ArrayList<>();

      if (cmdHandler.isAllMedia()) {
         mediaLogger.logCommandLine("Retrieving information of all media in MediaItem...");
         setParamListForAll();
      } else if (cmdHandler.getMediaFromFile() != null) {
         mediaLogger.logCommandLine("Retrieving information of media from file " + cmdHandler.getMediaFromFile() + "...");
         setParamListForFile();
      } else if (cmdHandler.getMediaType() != null) {
         mediaLogger.logCommandLine("Retrieving information of media of types " + cmdHandler.getMediaType() + " in MediaItem...");
         setParamListForTypes();
      } else {
         throw new UserException("Selected migration option is not valid.");
      }
      mediaLogger.logCommandLine("Succesfully retrieved the information.");

      mediaItemParamList.trimToSize();
   }

   private void setParamListIterator() {
      mediaItemParamListIterator = mediaItemParamList.iterator();
   }

   private void setParamListForAll() throws SQLException {
      try (PreparedStatement pstmt = dbConnection.getConnection().prepareStatement(QUERY_BASIC)) {
         ResultSet resultSet = pstmt.executeQuery();
         buildParamList(resultSet);
      } catch (SQLException e) {
         throw new SQLException("Error while retrieving information from MediaItem. " + e.getMessage(), e);
      }
   }

   private void setParamListForFile() throws IOException {
      try {
         BufferedReader br = new BufferedReader(new FileReader(cmdHandler.getMediaFromFile()));
         String line;
         int lineNumber = 1;
         while ((line = br.readLine()) != null) {
            HashMap<String, Object> row = new HashMap<>();
            String[] lineParams = line.split("(?<!\\\\)" + Pattern.quote(","));

            if (lineParams.length < 2) {
               mediaLogger.logCommandLineError("All sufficient params are not set for the line " + lineNumber);
            } else {
               row.put("ITEM_ID", Long.parseLong(lineParams[0]));
               row.put("FILE_NAME", lineParams[1].replaceAll("\\\\,", ","));
            }

            mediaItemParamList.add(row);
            lineNumber++;
         }
         br.close();
      } catch (IOException e) {
         throw new IOException("Error while reading file " + cmdHandler.getMediaFromFile() + ". " + e.getMessage(), e);
      }
   }

   private void setParamListForTypes() throws SQLException {
      String query = QUERY_BASIC + "AND media_item_type IN (?)";
      StringTokenizer st = new StringTokenizer(cmdHandler.getMediaType(), "|");

      while (st.hasMoreTokens()) {
         try (PreparedStatement pstmt = dbConnection.getConnection().prepareStatement(query)) {
            pstmt.setString(1, st.nextToken());
            ResultSet resultSet = pstmt.executeQuery();
            buildParamList(resultSet);
         } catch (SQLException e) {
            throw new SQLException("Error while retrieving information from MediaItem. " + e.getMessage(), e);
         }
      }
   }

   private void buildParamList(ResultSet resultSet) throws SQLException {
      ResultSetMetaData md = resultSet.getMetaData();
      int columns = md.getColumnCount();

      while (resultSet.next()) {
         HashMap<String, Object> row = new HashMap<>();

         for (int i = 1; i <= columns; i++) {
            if ("FILE_NAME".equals(md.getColumnName(i))) {
               row.put(md.getColumnName(i), resultSet.getString(i));
            } else {
               row.put(md.getColumnName(i), resultSet.getLong(i));
            }
         }
         mediaItemParamList.add(row);
      }
   }

   public void migrateToFs() throws SQLException, Exception {
      mediaLogger.logCommandLine(mediaItemParamList.size() + " media selected for migration.");
      int skippedCount = 0;
      int failedCount = 0;
      int successCount = 0;

      if (!dbPkgDeployedInSource()) {
         throw new UserException("FS_MIG_TOOL_API is not deployed in the source database..");
      }

      while (mediaItemParamListIterator.hasNext()) {
         mediaItemParam = mediaItemParamListIterator.next();

         mediaLogger.logMediaInfo(mediaItemParam, "Initialized.");
         if (allowedToMigrate()) {
            try {
               mediaLogger.logMediaInfo(mediaItemParam, "Locking the file record...");
               lockRecord();
               mediaLogger.setMediaTransferStatus(mediaItemParam, Constants.TRANSFER_STATUS_INPROGRESS, "Is locked.");

               if (fsCleanupNeeded()) {
                  mediaLogger.logMediaInfo(mediaItemParam, "Deleting the file from file storage. Reason: " + mediaItemParam.get("REASON") + "...");
                  deleteFromFs();
                  mediaLogger.logMediaInfo(mediaItemParam, "Deleted successfully from file storage.");
               }

               mediaLogger.logMediaInfo(mediaItemParam, "Retrieving file and content length from source...");
               getFileWithSize();
               mediaLogger.logMediaInfo(mediaItemParam, "File and content length retrieved successfully from source.");

               mediaLogger.logMediaInfo(mediaItemParam, "Uploading the file to file storage...");
               uploadToFs();
               mediaLogger.setMediaTransferStatus(mediaItemParam, Constants.TRANSFER_STATUS_DONE, "Uploaded successfully to file storage.");
               successCount++;
               //mediaLogger.logCommandLine("File " + mediaItemParam.get("ITEM_ID") + " Migration completed.");
            } catch (Exception e) {
               mediaLogger.setMediaTransferStatus(mediaItemParam, Constants.TRANSFER_STATUS_FAILED, "Failed to upload. " + e.getMessage());
               //mediaLogger.logCommandLineError("File " + mediaItemParam.get("ITEM_ID") + " Failed to upload.");
               failedCount++;
            } finally {
               try {
                  unlockRecord();
               } catch (SQLException e) {
                  mediaLogger.logMediaInfo(mediaItemParam, "Failed to unlock after upload to file storage.");
               }
            }
         } else {
            mediaLogger.logMediaInfo(mediaItemParam, "Not allowed for migration. Reason: " + mediaItemParam.get("REASON"));
            //mediaLogger.logCommandLine("File " + mediaItemParam.get("ITEM_ID") + " Not allowed for migration. Reason: " + mediaItemParam.get("REASON"));
            skippedCount++;
         }
         mediaLogger.logCommandLineNoLine(successCount + " of " + mediaItemParamList.size() + " migrated. " + failedCount + " failed. " + skippedCount + " skipped.");

         mediaItemParam.clear();
      }
      mediaLogger.logCommandLine("");
      mediaLogger.logFile("Cleaning up FileInfoVirtual at cloud...");
      cleanupFsUploadVrt();
      mediaLogger.logFile("Cleaning up FileInfoVirtual at cloud...");

      mediaLogger.logCommandLine("Ended migration of " + successCount + " media out of " + mediaItemParamList.size() + " to file storage. Check the log file for more information.");
   }

   private boolean dbPkgDeployedInSource() throws SQLException {
      String sql = "SELECT COUNT(1) count FROM user_objects WHERE object_name = 'FS_MIG_TOOL_API'";

      try (PreparedStatement pstmt = dbConnection.getConnection().prepareStatement(sql)) {
         ResultSet resultSet = pstmt.executeQuery();

         while (resultSet.next()) {
            return resultSet.getInt("count") > 0;
         }
      } catch (SQLException e) {
         throw new SQLException("Error while checking db packge installed in soource. " + e.getMessage(), e);
      }
      return false;
   }

   private boolean allowedToMigrate() throws SQLException {
      String query = "{? = call Fs_Mig_Tool_API.Media_Allowed_For_Transfer__(?,?)}";

      try (CallableStatement stmt = dbConnection.getConnection().prepareCall(query)) {
         stmt.registerOutParameter(1, java.sql.Types.VARCHAR);
         stmt.registerOutParameter(2, java.sql.Types.VARCHAR);
         stmt.setLong(3, (long) mediaItemParam.get("ITEM_ID"));
         stmt.executeQuery();
         mediaItemParam.put("ALLOWED", stmt.getString(1));
         mediaItemParam.put("REASON", stmt.getString(2));
      } catch (SQLException e) {
         throw new SQLException("Failed to check if the file is allowed to migrate. " + e.getMessage(), e);
      }
      return !isNullOrEmpty((String) mediaItemParam.get("ALLOWED")) && "TRUE".equals((String) mediaItemParam.get("ALLOWED"));
   }

   private boolean fsCleanupNeeded() {
      return "Media was successfully transferred earlier but the content have changed".equals(mediaItemParam.get("REASON"));
   }

   private void deleteFromFs() throws Exception {
      String requestBody = Json.createObjectBuilder()
              .add(Constants.FILE_ID_PROPERTY, (String.valueOf((long) mediaItemParam.get("ITEM_ID"))))//this postfix should be changed when testing.
              .add(Constants.BUCKET_NAME_PROPERTY, MediaMigrationHandler.BUCKET_NAME)
              .build()
              .toString();
      try {
         postToCloud(false, Constants.FS_DELETE_URL, requestBody);
      } catch (Exception ex) {
         throw new Exception("Error while deleting file from file storage. " + ex.getMessage(), ex);
      }
   }

   private void lockRecord() throws SQLException {
      String query = "SELECT 1 FROM media_item_tab WHERE item_id = ? FOR UPDATE";

      try (PreparedStatement pstmt = dbConnection.getConnection().prepareStatement(query)) {
         pstmt.setLong(1, (long) mediaItemParam.get("ITEM_ID"));
         pstmt.executeQuery();
      } catch (SQLException e) {
         throw new SQLException("Failed to Lock the File. " + e.getMessage());
      }
   }

   private void getFileWithSize() throws SQLException {
      String query = "{? = call Fs_Mig_Tool_API.Get_Media_File_And_Size__(?,?)}";

      try (CallableStatement stmt = dbConnection.getConnection().prepareCall(query)) {
         stmt.registerOutParameter(1, java.sql.Types.BLOB);
         stmt.registerOutParameter(2, java.sql.Types.FLOAT);
         stmt.setLong(3, (long) mediaItemParam.get("ITEM_ID"));
         stmt.executeQuery();

         if (stmt.getBlob(1) != null) {
            mediaItemParam.put("FILE_DATA", stmt.getBlob(1).getBinaryStream());
         }
         mediaItemParam.put("FILE_LENGTH", (long) stmt.getFloat(2));
      } catch (SQLException e) {
         throw new SQLException("Failed to download file from source database. " + e.getMessage(), e);
      }
   }

   private void uploadToFs() throws Exception {
      try {
         initializeUpload(false);
      } catch (Exception e) {
         throw new Exception("Error while creating the vrt record in cloud. " + e.getMessage(), e);
      }

      try {
         executeUpload(false);
      } catch (Exception e) {
         throw new Exception("Error while uploading to file storage. " + e.getMessage(), e);
      }
   }

   private void unlockRecord() throws SQLException {
      String query = "commit";

      try (PreparedStatement pstmt = dbConnection.getConnection().prepareStatement(query)) {
         pstmt.executeQuery();
      } catch (SQLException e) {
         throw new SQLException("Failed to Unlock the File. " + e.getMessage());
      }
   }

   private void cleanupFsUploadVrt() throws Exception {
      String requestBody = Json.createObjectBuilder()
              .build()
              .toString();

      try {
         postToCloud(false, Constants.CLEANUP_FS_UPLOAD_VRT_URL, requestBody);
      } catch (Exception ex) {
         throw new Exception("Error while cleaning up the virtual. " + ex.getMessage(), ex);
      }
   }

   private void initializeUpload(boolean forceRefresh) throws MalformedURLException, IOException, Exception {
      boolean authTokenRefreshed = authTokenRefresh(forceRefresh);
      final String authToken = CloudAuthenticationManager.getInstance(cmdHandler).getAuthorizedRequestToken();

      HashMap<String, String> headersMap = buildHeadersForUploadVrt(authToken);
      final HttpURLConnection httpUrlConnection = (HttpURLConnection) new URL(cmdHandler.getCloudUrl() + Constants.CREATE_FS_UPLOAD_VRT_URL).openConnection();
      setHttpConnectionProperties(httpUrlConnection, headersMap, HttpMethod.POST);

      String requestBody = Json.createObjectBuilder()
              .add(Constants.FILE_ID_PROPERTY, (String.valueOf((long) mediaItemParam.get("ITEM_ID"))))//this postfix should be changed when testing.
              .add(Constants.BUCKET_NAME_PROPERTY, MediaMigrationHandler.BUCKET_NAME)
              .add(Constants.FILE_NAME_PROPERTY, (String) mediaItemParam.get("FILE_NAME"))
              .build()
              .toString();

      try (OutputStream os = httpUrlConnection.getOutputStream()) {
         byte[] input = requestBody.getBytes();
         os.write(input, 0, input.length);
         os.flush();
         os.close();
      }

      int responseCode = httpUrlConnection.getResponseCode();

      if (responseCode < HttpURLConnection.HTTP_BAD_REQUEST) {
         mediaItemParam.put("ETAG", getReponseHeaderValue(httpUrlConnection, Constants.ETAG_HEADER));
         mediaItemParam.put("OBJKEY", getResponse(httpUrlConnection).getString("Objkey"));
      } else if (!authTokenRefreshed && (responseCode == 401 || responseCode == 403)) {
         initializeUpload(true);
      } else {
         validateErrorResponse(httpUrlConnection, responseCode);
      }
   }

   private void executeUpload(boolean forceRefresh) throws IOException, Exception {
      boolean refreshed = authTokenRefresh(forceRefresh);
      final String authToken = CloudAuthenticationManager.getInstance(cmdHandler).getAuthorizedRequestToken();

      HashMap<String, String> headersMap = buildHeadersForUpload(authToken);
      final HttpURLConnection httpUrlConnection = (HttpURLConnection) new URL(cmdHandler.getCloudUrl() + String.format(Constants.FS_UPLOAD_URL, (String) mediaItemParam.get("OBJKEY"))).openConnection();
      setHttpConnectionProperties(httpUrlConnection, headersMap, HttpMethod.PUT);

      try (final DataOutputStream out = new DataOutputStream(httpUrlConnection.getOutputStream());
              InputStream in = new BufferedInputStream((InputStream) mediaItemParam.get("FILE_DATA"))) {
         int bytesRead;
         final byte[] buffer = new byte[1024];

         while ((bytesRead = in.read(buffer)) > 0) {
            out.write(buffer, 0, bytesRead);
            out.flush();
         }

      } catch (Exception ex) {
         throw new Exception("Error while upload the file to file storage. " + ex.getMessage(), ex);
      }

      int responseCode = httpUrlConnection.getResponseCode();

      if (!refreshed && (responseCode == 401 || responseCode == 403)) {
         executeUpload(true);
      } else if (!(responseCode < HttpURLConnection.HTTP_BAD_REQUEST)) {
         validateErrorResponse(httpUrlConnection, responseCode);
      }
   }

   private String getReponseHeaderValue(final HttpURLConnection httpUrlConnection, String header) {
      Map<String, List<String>> map = httpUrlConnection.getHeaderFields();
      List<String> etag = map.get(header);
      String etagString = null;
      for (String head : etag) {
         etagString = head;
      }
      return etagString;
   }

   private void setHttpConnectionProperties(final HttpURLConnection httpUrlConnection, HashMap<String, String> headersMap, String httpMethod) throws ProtocolException {
      httpUrlConnection.setRequestMethod(httpMethod);
      headersMap.forEach(httpUrlConnection::setRequestProperty);

      httpUrlConnection.setDoInput(true);
      httpUrlConnection.setDoOutput(true);
      httpUrlConnection.setUseCaches(false);

      if (headersMap.containsKey(Constants.CONTENT_LENGTH_HEADER)) {
         httpUrlConnection.setChunkedStreamingMode(1024);
      }
   }

   private boolean authTokenRefresh(boolean forceRefresh) throws Exception {
      if (forceRefresh || CloudAuthenticationManager.getInstance(cmdHandler).tokenRefreshNeeded()) {
         try {
            CloudAuthenticationManager.getInstance(cmdHandler).refetchTokens();
         } catch (final Exception e) {
            throw new Exception(e.getMessage());
         }
         return true;
      }
      return false;
   }

   private JsonObject getResponse(final HttpURLConnection conn) throws Exception, IOException {
      StringBuilder responseBuilder;
      try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
         responseBuilder = new StringBuilder();
         String responseLine;
         while ((responseLine = br.readLine()) != null) {
            responseBuilder.append(responseLine);
         }
      }
      JsonObject responseJson = Json.createReader(new StringReader(responseBuilder.toString())).readObject();
      return responseJson;
   }

   private void validateErrorResponse(final HttpURLConnection conn, int responseCode) throws Exception, IOException {
      StringBuilder responseBuilder;
      try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream()))) {
         responseBuilder = new StringBuilder();
         String responseLine;
         while ((responseLine = br.readLine()) != null) {
            responseBuilder.append(responseLine);
         }
      }
      JsonObject responseJson = Json.createReader(new StringReader(responseBuilder.toString())).readObject();

      throw new Exception(
              String.format("%1$s returned %2$s. Error Code: %3$s Error Description: %4$s", conn.getURL(), responseCode, responseJson.getJsonObject("error").getString("code"), responseJson.getJsonObject("error").getString("message")));

   }

   private void postToCloud(boolean forceRefresh, String url, String requestBody) throws IOException, Exception {
      boolean authTokenRefreshed = authTokenRefresh(forceRefresh);
      final String authToken = CloudAuthenticationManager.getInstance(cmdHandler).getAuthorizedRequestToken();

      HashMap<String, String> headersMap = buildHeadersForDelete(authToken);
      final HttpURLConnection httpUrlConnection = (HttpURLConnection) new URL(cmdHandler.getCloudUrl() + url).openConnection();
      setHttpConnectionProperties(httpUrlConnection, headersMap, HttpMethod.POST);

      try (OutputStream os = httpUrlConnection.getOutputStream()) {
         byte[] input = requestBody.getBytes();
         os.write(input, 0, input.length);
         os.flush();
         os.close();
      }

      int responseCode = httpUrlConnection.getResponseCode();

      if (!authTokenRefreshed && (responseCode == 401 || responseCode == 403)) {
         postToCloud(true, url, requestBody);
      } else if (!(responseCode < HttpURLConnection.HTTP_BAD_REQUEST)) {
         validateErrorResponse(httpUrlConnection, responseCode);
      }
   }

   private HashMap<String, String> buildHeadersForUploadVrt(final String authToken) {
      final HashMap<String, String> headersMap = new HashMap<>();
      headersMap.put(Constants.CONTENT_TYPE_HEADER, Constants.CREATE_VRT_CONTENT_TYPE_HEADER_VALUE);
      headersMap.put(Constants.AUTH_HEADER, Constants.AUTH_HEADER_VALUE_PREFIX + authToken);
      headersMap.put(Constants.ACCEPT_TYPE_HEADER, Constants.ACCEPT_TYPE_HEADER_VALUE);
      return headersMap;
   }

   private HashMap<String, String> buildHeadersForDelete(final String authToken) {
      final HashMap<String, String> headersMap = new HashMap<>();
      headersMap.put(Constants.CONTENT_TYPE_HEADER, Constants.FS_DELETE_CONTENT_TYPE_HEADER_VALUE);
      headersMap.put(Constants.AUTH_HEADER, Constants.AUTH_HEADER_VALUE_PREFIX + authToken);
      headersMap.put(Constants.ACCEPT_TYPE_HEADER, Constants.ACCEPT_TYPE_HEADER_VALUE);
      return headersMap;
   }

   private HashMap<String, String> buildHeadersForUpload(final String authToken) {
      final HashMap<String, String> headersMap = new HashMap<>();
      headersMap.put(Constants.IFS_DEPOSITION_HEADER, Constants.DISPOSITION_HEADER_VALUE_PREFIX + Base64.getUrlEncoder().encodeToString(((String) mediaItemParam.get("FILE_NAME")).getBytes(StandardCharsets.UTF_8)));
      headersMap.put(Constants.CONTENT_LENGTH_HEADER, String.valueOf((long) mediaItemParam.get("FILE_LENGTH")));
      headersMap.put(Constants.CONTENT_TYPE_HEADER, Constants.UPLOAD_CONTENT_TYPE_HEADER_VALUE);
      headersMap.put(Constants.IF_MATCH_HEADER, (String) mediaItemParam.get("ETAG"));
      headersMap.put(Constants.ACCEPT_TYPE_HEADER, Constants.ACCEPT_TYPE_HEADER_VALUE);
      headersMap.put(Constants.AUTH_HEADER, Constants.AUTH_HEADER_VALUE_PREFIX + authToken);
      return headersMap;
   }

   private static boolean isNullOrEmpty(String str) {
      return !(str != null && !str.trim().isEmpty());
   }
}
