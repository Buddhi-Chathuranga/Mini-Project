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

import ifs.cloud.fsmigtool.utils.Constants;
import ifs.cloud.fsmigtool.logging.FsMigToolLogger;
import javax.json.JsonObject;
import java.io.IOException;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.ProtocolException;
import java.net.URL;
import java.util.Base64;
import javax.json.Json;
import javax.ws.rs.HttpMethod;

/**
 * @author IFS RnD
 */
public class CloudAuthenticationManager {

   private final static Object SYNC_OBJ = new Object();
   private final String CLIENT_ID;
   private final static String TOKEN_ENDPOINT_PROPERTY = "token_endpoint";
   private final String CLIENT_SECRET;
   private final String REALM;
   private final String DISCOVERY_ENDPOINT;

   private static volatile CloudAuthenticationManager singleInstance = null;

   private String authToken = null;
   private String refreshToken = null;
   private JsonObject tokenClaims = JsonObject.EMPTY_JSON_OBJECT;
   private String tokenEndpoint = null;

   private CloudAuthenticationManager(CommandLineHandler cmdHandler) {
      CLIENT_ID = cmdHandler.getCloudClient();
      CLIENT_SECRET = cmdHandler.getCloudSecret();
      REALM = cmdHandler.getCloudRealm();
      DISCOVERY_ENDPOINT = cmdHandler.getCloudUrl() + "/auth/realms/" + REALM + "/.well-known/openid-configuration";
   }

   public static CloudAuthenticationManager getInstance(CommandLineHandler cmdHandler) {
      CloudAuthenticationManager localInstance = singleInstance;
      if (localInstance == null) {
         synchronized (SYNC_OBJ) {
            localInstance = singleInstance;
            if (localInstance == null) {
               singleInstance = localInstance = new CloudAuthenticationManager(cmdHandler);
            }
         }
      }
      return localInstance;
   }

   private void getTokenEndpoint() throws Exception {
      try {
         HttpURLConnection conn = (HttpURLConnection) new URL(DISCOVERY_ENDPOINT).openConnection();
         setConnectionProperties(conn, HttpMethod.GET, 0);
         tokenEndpoint = validateResponse(conn).getString(TOKEN_ENDPOINT_PROPERTY);
      } catch (Exception e) {
         throw new Exception("Error while getting the token end point. " + e.getMessage(), e);
      }
   }

   private void setConnectionProperties(HttpURLConnection conn, String httpMethod, int contentLength) throws ProtocolException {
      conn.setRequestMethod(httpMethod);
      conn.setRequestProperty(Constants.CONTENT_TYPE_HEADER, Constants.GET_AUTH_CONTENT_TYPE_HEADER_VALUE);
      if (contentLength != 0) {
         conn.setRequestProperty(Constants.CONTENT_LENGTH_HEADER, String.valueOf(contentLength));
      }
      if (httpMethod == null ? HttpMethod.POST == null : httpMethod.equals(HttpMethod.POST)) {
         conn.setDoOutput(true);
      }
   }

   private JsonObject validateResponse(HttpURLConnection conn) throws Exception {
      int responseCode = conn.getResponseCode();

      BufferedReader br;
      if (responseCode < HttpURLConnection.HTTP_BAD_REQUEST) {
         br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
      } else {
         br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
      }

      StringBuilder responseBuilder = new StringBuilder();
      String responseLine;
      while ((responseLine = br.readLine()) != null) {
         responseBuilder.append(responseLine);
      }
      br.close();

      final JsonObject responseJson;
      responseJson = Json.createReader(new StringReader(responseBuilder.toString())).readObject();

      if (!(responseCode < HttpURLConnection.HTTP_BAD_REQUEST)) {
         throw new Exception(
                 String.format("%1$s returned %2$s. Error Code: %3$s Error Description: %4$s", conn.getURL(), responseCode, responseJson.getString("error"), responseJson.getString("error_description")));
      }

      return responseJson;
   }

   private void refreshAccessToken(String params) throws Exception {
      getTokenEndpoint();

      byte[] postDataBytes = params.getBytes();

      final URL url = new URL(tokenEndpoint);

      HttpURLConnection conn = (HttpURLConnection) url.openConnection();
      setConnectionProperties(conn, HttpMethod.POST, postDataBytes.length);

      streamPayload(conn, postDataBytes);
      JsonObject jsonResponse = validateResponse(conn);

      authToken = jsonResponse.getString(Constants.ACCESS_TOKEN);
      tokenClaims = Json.createReader(new ByteArrayInputStream(Base64.getDecoder().decode(authToken.split("\\.")[1]))).readObject();

      if (jsonResponse.containsKey(Constants.REFRESH_TOKEN) && !isNullOrEmpty(jsonResponse.getString(Constants.REFRESH_TOKEN))) {
         refreshToken = jsonResponse.getString(Constants.REFRESH_TOKEN);
      } else {
         FsMigToolLogger.getInstance().logFileError("refreshAccessToken() refreshToken is null");
      }

   }

   private void streamPayload(HttpURLConnection conn, byte[] postDataBytes) throws IOException {
      try (OutputStream os = conn.getOutputStream()) {
         os.write(postDataBytes, 0, postDataBytes.length);
         os.flush();
         os.close();
      }
   }

   private boolean refreshAccessTokenByRefreshToken() throws Exception {
      try {
         if (!isNullOrEmpty(refreshToken)) {
            if (isNullOrEmpty(CLIENT_SECRET)) {
               throw new Exception("CLIENT_SECRET is null");
            }

            StringBuilder sb = new StringBuilder("grant_type=client_credentials");
            sb.append("&client_id=").append(CLIENT_ID);
            sb.append("&client_secret=").append(CLIENT_SECRET);
            sb.append("&grant_type=").append("refresh_token");
            sb.append("&refresh_token=").append(refreshToken);

            refreshAccessToken(sb.toString());
            return true;
         }
      } catch (IOException ex) {
         FsMigToolLogger.getInstance().logCommandLineError("Access token refresh has failed. " + ex.getMessage());
      }
      return false;
   }

   public boolean tokenRefreshNeeded() {
      if (authToken != null && tokenClaims != null && tokenClaims.containsKey("exp")) {
         long exp = tokenClaims.getJsonNumber("exp").longValue();
         long now = System.currentTimeMillis() / 1000;
         return now > (exp - 60);
      }
      return true;
   }

   public void refetchTokens() throws IOException, Exception {
      if (!refreshAccessTokenByRefreshToken()) {
         refreshAccessTokenByCredentials();
      }
   }

   public String getAuthorizedRequestToken() {
      return authToken;
   }

   private void refreshAccessTokenByCredentials() throws IOException, Exception {
      if (isNullOrEmpty(CLIENT_SECRET)) {
         throw new Exception("CLIENT_SECRET is null");
      }

      StringBuilder sb = new StringBuilder("grant_type=client_credentials");
      sb.append("&client_id=").append(CLIENT_ID);
      sb.append("&client_secret=").append(CLIENT_SECRET);

      refreshAccessToken(sb.toString());
   }

   public static boolean isNullOrEmpty(String str) {
      return !(str != null && !str.trim().isEmpty());
   }
}
