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
import ifs.cloud.fsmigtool.logging.DocmanLogManager;
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

/**
 * @author IFS RnD
 */
public class DocmanMigrationHandler {

   private static final String BUCKET_NAME = "docman";

   private final SourceDbConnectionManager dbConnection;
   private final CommandLineHandler cmdHandler;
   private final DocmanLogManager docmanLogger;

   private Map<String, Object> docmanParam;
   private ArrayList<Map<String, Object>> docmanParamList;
   private Iterator<Map<String, Object>> docmanParamListIterator;

   private static final String QUERY_BASIC   = "SELECT e.doc_class  doc_class, "
                                             + "       e.doc_no     doc_no, "
                                             + "       e.doc_sheet  doc_sheet, "
                                             + "       e.doc_rev    doc_rev, "
                                             + "       e.doc_type   doc_type, "
                                             + "       e.file_no    file_no, "
                                             + "       e.file_name  file_name, "
                                             + "       nvl(e.user_file_name, e.file_name) user_file_name "
                                             + "FROM edm_file_tab e "
                                             + "INNER JOIN edm_file_storage_tab t "
                                             + "ON  e.doc_class = t.doc_class "
                                             + "AND e.doc_no = t. doc_no "
                                             + "AND e.doc_sheet = t.doc_sheet "
                                             + "AND e.doc_rev = t.doc_rev "
                                             + "AND e.doc_type = t.doc_type "
                                             + "AND e.file_no = t.file_no "
                                             + "WHERE e.rowstate = 'Checked In' "
                                             + "AND EXISTS (SELECT 1 "
                                             + "            FROM edm_location_tab t "
                                             + "            WHERE e.location_name = t.location_name "
                                             + "            AND t.location_type = '3') ";

   public DocmanMigrationHandler(CommandLineHandler cmdHandler, SourceDbConnectionManager dbConnection) throws SQLException, IOException, UserException {
      this.dbConnection = dbConnection;
      this.cmdHandler = cmdHandler;
      docmanLogger = new DocmanLogManager(this.dbConnection, cmdHandler);
      setParamList();
      setParamListIterator();
   }

   private void setParamList() throws SQLException, IOException, UserException {
      docmanParamList = new ArrayList<>();

      if (cmdHandler.isAllDocs()) {
         docmanLogger.logCommandLine("Retrieving information of all documents in EdmFileStorage...");
         setParamListForAll();
      } else if (cmdHandler.getDocsFromFile() != null) {
         docmanLogger.logCommandLine("Retrieving information of documents from file " + cmdHandler.getDocsFromFile() + "...");
         setParamListForFile();
      } else if (cmdHandler.getDocClasses() != null) {
         docmanLogger.logCommandLine("Retrieving information of documents for classes " + cmdHandler.getDocClasses() + " in EdmFileStorage...");
         setParamListForClasses();
      } else {
         throw new UserException("Selected migration option is not valid.");
      }
      docmanLogger.logCommandLine("Succesfully retrieved the information.");

      docmanParamList.trimToSize();
   }

   private void setParamListIterator() {
      docmanParamListIterator = docmanParamList.iterator();
   }

   private void setParamListForAll() throws SQLException {
      try (PreparedStatement pstmt = dbConnection.getConnection().prepareStatement(QUERY_BASIC)) {
         ResultSet resultSet = pstmt.executeQuery();
         buildParamList(resultSet);
      } catch (SQLException e) {
         throw new SQLException("Error while retrieving information from EdmFileStorage. " + e.getMessage(), e);
      }
   }

   private void setParamListForFile() throws IOException {
      try (BufferedReader br = new BufferedReader(new FileReader(cmdHandler.getDocsFromFile()))) {
         String line;
         int lineNumber = 1;

         while ((line = br.readLine()) != null) {
            HashMap<String, Object> row = new HashMap<>();
            String[] lineParams = line.split("(?<!\\\\)" + Pattern.quote(","));

            if (lineParams.length < 7) {
               docmanLogger.logCommandLine("All sufficient params are not set for the line " + lineNumber + ".");
            } else {
               row.put("DOC_CLASS", lineParams[0].replaceAll("\\\\,", ","));
               row.put("DOC_NO", lineParams[1].replaceAll("\\\\,", ","));
               row.put("DOC_SHEET", lineParams[2].replaceAll("\\\\,", ","));
               row.put("DOC_REV", lineParams[3].replaceAll("\\\\,", ","));
               row.put("DOC_TYPE", lineParams[4].replaceAll("\\\\,", ","));
               row.put("FILE_NO", Long.parseLong(lineParams[5]));
               row.put("FILE_NAME", lineParams[6].replaceAll("\\\\,", ","));
               row.put("USER_FILE_NAME", lineParams[7].replaceAll("\\\\,", ","));
            }

            docmanParamList.add(row);
            lineNumber++;
         }
         br.close();
      } catch (IOException e) {
         throw new IOException("Error while reading file " + cmdHandler.getDocsFromFile() + ". " + e.getMessage(), e);
      }
   }

   private void setParamListForClasses() throws SQLException {
      StringTokenizer st = new StringTokenizer(cmdHandler.getDocClasses(), ",");
      String query = QUERY_BASIC + "AND e.doc_class IN (?)";

      while (st.hasMoreTokens()) {
         try (PreparedStatement pstmt = dbConnection.getConnection().prepareStatement(query)) {
            pstmt.setString(1, st.nextToken());
            ResultSet resultSet = pstmt.executeQuery();
            buildParamList(resultSet);
         } catch (Exception e) {
            throw new SQLException("Error while retrieving information from EdmFileStorage. " + e.getMessage(), e);
         }
      }
   }

   private void buildParamList(ResultSet resultSet) throws SQLException {
      ResultSetMetaData md = resultSet.getMetaData();
      int columns = md.getColumnCount();

      while (resultSet.next()) {
         HashMap<String, Object> row = new HashMap<>();

         for (int i = 1; i <= columns; i++) {
            if ("FILE_NO".equals(md.getColumnName(i))) {
               row.put(md.getColumnName(i), resultSet.getLong(i));
            } else {
               row.put(md.getColumnName(i), resultSet.getString(i));
            }
         }
         docmanParamList.add(row);
      }
   }
      
   public void migrateToFs() throws Exception {
      docmanLogger.logCommandLine(docmanParamList.size() + " documents selected for migration.");
      int skippedCount = 0;
      int failedCount = 0;
      int successCount = 0;

      if (!dbPkgDeployedInSource()) {
         throw new UserException("FS_MIG_TOOL_API is not deployed in the source database.");
      }

      while (docmanParamListIterator.hasNext()) {
         docmanParam = docmanParamListIterator.next();
         String currentFileState = null;

         docmanLogger.logDocumentInfo(docmanParam, "Initialized.");
         if (allowedToMigrate()) {
            try {
               docmanLogger.logDocumentInfo(docmanParam, "Locking the file record...");
               currentFileState = lockRecord();
               docmanLogger.setDocumentTransferStatus(docmanParam, Constants.TRANSFER_STATUS_INPROGRESS, "Is locked.");

               if (fsCleanupNeeded()) {
                  docmanLogger.logDocumentInfo(docmanParam, "Deleting the file from file storage. Reason: " + docmanParam.get("REASON") + "...");
                  deleteFromFs();
                  docmanLogger.logDocumentInfo(docmanParam, "Deleted successfully from file storage.");
               }

               docmanLogger.logDocumentInfo(docmanParam, "Retrieving file and content length from source...");
               getFileWithSize();
               docmanLogger.logDocumentInfo(docmanParam, "File and content length retrieved successfully from source.");

               docmanLogger.logDocumentInfo(docmanParam, "Uploading the file to file storage...");
               uploadToFs();
               docmanLogger.logDocumentInfo(docmanParam, "Uploaded to file storage.");

               docmanLogger.logDocumentInfo(docmanParam, "Unlocking the file...");
               unlockRecord(currentFileState);
               docmanLogger.logDocumentInfo(docmanParam, "Unlocked the file.");

               docmanLogger.setDocumentTransferStatus(docmanParam, Constants.TRANSFER_STATUS_DONE, "Migration successful.");
               successCount++;
            } catch (Exception e) {
               if (currentFileState != null) {
                  docmanLogger.logDocumentInfo(docmanParam, "Unlocking the file...");
                  try {
                     unlockRecord(currentFileState);
                  } catch (SQLException ex) {
                     docmanLogger.logDocumentInfo(docmanParam, "Failed to unlock the file." + ex.getMessage());
                  }
                  docmanLogger.logDocumentInfo(docmanParam, "Unlocked the file.");
               }
               docmanLogger.setDocumentTransferStatus(docmanParam, Constants.TRANSFER_STATUS_FAILED, "Failed to upload. " + e.getMessage());
               failedCount++;
            }
         } else {
            docmanLogger.logDocumentInfo(docmanParam, "Not allowed for migration. Reason: " + docmanParam.get("REASON"));
            skippedCount++;
         }
         docmanLogger.logCommandLineNoLine(successCount + " of " + docmanParamList.size() + " migrated. " + failedCount + " failed. " + skippedCount + " skipped.");

         docmanParam.clear();
      }
      docmanLogger.logCommandLine("");

      docmanLogger.logFile("Cleaning up FileInfoVirtual at cloud...");
      cleanupFsUploadVrt();
      docmanLogger.logFile("Cleaning up FileInfoVirtual at cloud...");

      docmanLogger.logCommandLine("Ended migration of " + successCount + " documents out of " + docmanParamList.size() + " to file storage. Check the log file for more information.");
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
      String query = "{? = call Fs_Mig_Tool_API.Doc_Allowed_For_Transfer__(?,?,?,?,?,?,?)}";

      try (CallableStatement stmt = dbConnection.getConnection().prepareCall(query)) {
         stmt.registerOutParameter(1, java.sql.Types.VARCHAR);
         stmt.registerOutParameter(2, java.sql.Types.VARCHAR);
         stmt.setString(3, (String) docmanParam.get("DOC_CLASS"));
         stmt.setString(4, (String) docmanParam.get("DOC_NO"));
         stmt.setString(5, (String) docmanParam.get("DOC_SHEET"));
         stmt.setString(6, (String) docmanParam.get("DOC_REV"));
         stmt.setString(7, (String) docmanParam.get("DOC_TYPE"));
         stmt.setLong(8, (long) docmanParam.get("FILE_NO"));
         stmt.executeQuery();
         docmanParam.put("ALLOWED", stmt.getString(1));
         docmanParam.put("REASON", stmt.getString(2));
      } catch (SQLException e) {
         throw new SQLException("Failed to check if the file is allowed to migrate. " + e.getMessage(), e);
      }
      return !isNullOrEmpty((String) docmanParam.get("ALLOWED")) && "TRUE".equals((String) docmanParam.get("ALLOWED"));
   }

   private boolean fsCleanupNeeded() {
      return "Document was successfully transferred earlier but the version have changed".equals((String) docmanParam.get("REASON"));
   }

   private void deleteFromFs() throws Exception {
      String requestBody = Json.createObjectBuilder()
              .add(Constants.FILE_ID_PROPERTY, (String) docmanParam.get("FILE_NAME"))//this postfix should be changed when testing.
              .add(Constants.BUCKET_NAME_PROPERTY, BUCKET_NAME)
              .build()
              .toString();
      try {
         postToCloud(false, Constants.FS_DELETE_URL, requestBody);
      } catch (Exception ex) {
         throw new Exception("Error while deleting file from file storage. " + ex.getMessage(), ex);
      }
   }

   private String lockRecord() throws SQLException, UserException {
      CallableStatement stmt = dbConnection.getConnection().prepareCall("{call Edm_File_API.Lock_File(?, ?, ?)}");
      String currentFileState = null;
      String errorMsg = null;

      try {
         stmt.registerOutParameter(1, java.sql.Types.VARCHAR);
         stmt.registerOutParameter(2, java.sql.Types.VARCHAR);
         stmt.setString(3, (String) docmanParam.get("FILE_NAME"));
         stmt.execute();
         currentFileState = stmt.getString(1);
         errorMsg = stmt.getString(2);
      } catch (SQLException e) {
         throw new SQLException("Failed to Lock the File. " + e.getMessage(), e);
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }

      if (errorMsg == null || "".equals(errorMsg)) {
         return currentFileState;
      } else {
         throw new UserException("Failed to Lock the File. " + errorMsg);
      }
   }

   private void getFileWithSize() throws SQLException {
      String query = "{? = call Fs_Mig_Tool_API.Get_Document_File_And_Size__(?,?,?,?,?,?,?)}";

      try (CallableStatement stmt = dbConnection.getConnection().prepareCall(query)) {
         stmt.registerOutParameter(1, java.sql.Types.BLOB);
         stmt.registerOutParameter(2, java.sql.Types.FLOAT);
         stmt.setString(3, (String) docmanParam.get("DOC_CLASS"));
         stmt.setString(4, (String) docmanParam.get("DOC_NO"));
         stmt.setString(5, (String) docmanParam.get("DOC_SHEET"));
         stmt.setString(6, (String) docmanParam.get("DOC_REV"));
         stmt.setString(7, (String) docmanParam.get("DOC_TYPE"));
         stmt.setLong(8, (long) docmanParam.get("FILE_NO"));
         stmt.executeQuery();

         if (stmt.getBlob(1) != null) {
            docmanParam.put("FILE_DATA", stmt.getBlob(1).getBinaryStream());
         }
         docmanParam.put("FILE_LENGTH", (long) stmt.getFloat(2));
      } catch (SQLException e) {
         throw new SQLException("Failed to download file from source database. " + e.getMessage(), e);
      }
   }

   private void uploadToFs() throws MalformedURLException, IOException, Exception {
      initializeUpload(false);
      executeUpload(false);
   }

   private void unlockRecord(String currentFileState) throws SQLException {
      CallableStatement stmt = dbConnection.getConnection().prepareCall("{call Edm_File_API.Unlock_File(?, ?)}");

      try {
         stmt.setString(1, (String) docmanParam.get("FILE_NAME"));
         stmt.setString(2, currentFileState);
         stmt.execute();
      } catch (SQLException e) {
         throw new SQLException("Failed to Unlock the File. " + e.getMessage(), e);
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }
   }

   private void initializeUpload(boolean forceRefresh) throws MalformedURLException, IOException, Exception {
      boolean authTokenRefreshed = authTokenRefresh(forceRefresh);
      final String authToken = CloudAuthenticationManager.getInstance(cmdHandler).getAuthorizedRequestToken();

      HashMap<String, String> headersMap = buildHeadersForUploadVrt(authToken);
      final HttpURLConnection httpUrlConnection = (HttpURLConnection) new URL(cmdHandler.getCloudUrl() + Constants.CREATE_FS_UPLOAD_VRT_URL).openConnection();
      setHttpConnectionProperties(httpUrlConnection, headersMap, HttpMethod.POST);

      String requestBody = Json.createObjectBuilder()
              .add(Constants.FILE_ID_PROPERTY, (String) docmanParam.get("FILE_NAME"))//this postfix should be changed when testing.
              .add(Constants.BUCKET_NAME_PROPERTY, DocmanMigrationHandler.BUCKET_NAME)
              .add(Constants.FILE_NAME_PROPERTY, (String) docmanParam.get("USER_FILE_NAME"))
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
         docmanParam.put("ETAG", getReponseHeaderValue(httpUrlConnection, Constants.ETAG_HEADER));
         docmanParam.put("OBJKEY", getResponse(httpUrlConnection).getString("Objkey"));
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
      final HttpURLConnection httpUrlConnection = (HttpURLConnection) new URL(cmdHandler.getCloudUrl() + String.format(Constants.FS_UPLOAD_URL, (String) docmanParam.get("OBJKEY"))).openConnection();
      setHttpConnectionProperties(httpUrlConnection, headersMap, HttpMethod.PUT);

      try (final DataOutputStream out = new DataOutputStream(httpUrlConnection.getOutputStream());
              InputStream in = new BufferedInputStream((InputStream) docmanParam.get("FILE_DATA"))) {
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

   private HashMap<String, String> buildHeadersForDelete(final String authToken) {
      final HashMap<String, String> headersMap = new HashMap<>();
      headersMap.put(Constants.CONTENT_TYPE_HEADER, Constants.FS_DELETE_CONTENT_TYPE_HEADER_VALUE);
      headersMap.put(Constants.AUTH_HEADER, Constants.AUTH_HEADER_VALUE_PREFIX + authToken);
      headersMap.put(Constants.ACCEPT_TYPE_HEADER, Constants.ACCEPT_TYPE_HEADER_VALUE);
      return headersMap;
   }

   private HashMap<String, String> buildHeadersForUpload(final String authToken) {
      final HashMap<String, String> headersMap = new HashMap<>();
      headersMap.put(Constants.IFS_DEPOSITION_HEADER, Constants.DISPOSITION_HEADER_VALUE_PREFIX + Base64.getUrlEncoder().encodeToString(((String) docmanParam.get("USER_FILE_NAME")).getBytes(StandardCharsets.UTF_8)));
      headersMap.put(Constants.CONTENT_LENGTH_HEADER, String.valueOf((long) docmanParam.get("FILE_LENGTH")));
      headersMap.put(Constants.CONTENT_TYPE_HEADER, Constants.UPLOAD_CONTENT_TYPE_HEADER_VALUE);
      headersMap.put(Constants.IF_MATCH_HEADER, (String) docmanParam.get("ETAG"));
      headersMap.put(Constants.ACCEPT_TYPE_HEADER, Constants.ACCEPT_TYPE_HEADER_VALUE);
      headersMap.put(Constants.AUTH_HEADER, Constants.AUTH_HEADER_VALUE_PREFIX + authToken);
      return headersMap;
   }

   private HashMap<String, String> buildHeadersForUploadVrt(final String authToken) {
      final HashMap<String, String> headersMap = new HashMap<>();
      headersMap.put(Constants.CONTENT_TYPE_HEADER, Constants.CREATE_VRT_CONTENT_TYPE_HEADER_VALUE);
      headersMap.put(Constants.AUTH_HEADER, Constants.AUTH_HEADER_VALUE_PREFIX + authToken);
      headersMap.put(Constants.ACCEPT_TYPE_HEADER, Constants.ACCEPT_TYPE_HEADER_VALUE);
      return headersMap;
   }

   private static boolean isNullOrEmpty(String str) {
      return !(str != null && !str.trim().isEmpty());
   }
}
