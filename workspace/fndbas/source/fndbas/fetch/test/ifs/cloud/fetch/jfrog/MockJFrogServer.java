package ifs.cloud.fetch.jfrog;

import static org.junit.Assert.fail;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import ifs.cloud.fetch.jfrog.JFrogClient.JFrogFileInfo;

public class MockJFrogServer {

   public final static String HOST = "localhost";
   public final static String PROTOCOL = "http";
   public final static int LISTEN_PORT = 7573;
   public final static String REPO = "repo";
   public final static String PATH = "/fndbas/ifsinstaller/ifsinstaller-1.0.1.zip";
   public final static String BAD_PATH = "/fndbas/ifsinstaller/badfile.zip";
   public final static int FILE_SIZE = 4431617;
   public final static String MIME_TYPE = "application/zip";
   private final static String RESPONSE = "{\r\n"
         + "\"repo\": \"binaryartifacts\",\r\n"
         + "\"path\": \"" + PATH + "\",\r\n"
         + "\"created\": \"2021-05-24T10:30:54.796Z\",\r\n"
         + "\"createdBy\": \"appf_release_user\",\r\n"
         + "\"lastModified\": \"2021-05-24T10:30:54.409Z\",\r\n"
         + "\"modifiedBy\": \"appf_release_user\",\r\n"
         + "\"lastUpdated\": \"2021-05-24T10:30:54.798Z\",\r\n"
         + "\"downloadUri\": \"https://ifsclouddev.jfrog.io/artifactory/binaryartifacts" + PATH + "\",\r\n"
         + "\"mimeType\": \"" + MIME_TYPE + "\",\r\n"
         + "\"size\": \"" + FILE_SIZE + "\",\r\n"
         + "\"checksums\": {\r\n"
         + "\"sha1\": \"d2b4c84614e6b2c31c016039f7a2afe49c4e1a6d\",\r\n"
         + "\"md5\": \"e04ffa47d40c0510c68abe2eea54ca92\",\r\n"
         + "\"sha256\": \"a72e2372b8141feb70bea57f785b35e340a8ad4b338657aa46b433c69bbb0688\"\r\n"
         + "},\r\n"
         + "\"originalChecksums\": {\r\n"
         + "\"sha256\": \"a72e2372b8141feb70bea57f785b35e340a8ad4b338657aa46b433c69bbb0688\"\r\n"
         + "},\r\n"
         + "\"uri\": \"https://ifsclouddev.jfrog.io/artifactory/api/storage/binaryartifacts" + PATH + "\"\r\n"
         + "}";
   public final static String FILE_CONTENT = "-content-of-zip-";
   
   public static class MockFileInfo extends JFrogFileInfo {
      MockFileInfo() {
         super(RESPONSE);
      }
      
      MockFileInfo(String path) {
         this();
         setPath(path);
      }
   }

   MockJFrogServer() {
   }

   void start() {
      try {
         HttpServer server = HttpServer.create(new InetSocketAddress(HOST, LISTEN_PORT), 0);
         server.createContext("/artifactory/api/storage/" + REPO + "/file", new FileInfoHandler());
         server.createContext("/artifactory/" + REPO + PATH, new FileDownloadHandler());
         server.createContext("/artifactory/" + REPO + BAD_PATH, new InvalidFileDownloadHandler());
         server.setExecutor((ThreadPoolExecutor) Executors.newFixedThreadPool(2));
         server.start();
      }
      catch (IOException e) {
         fail(e.toString());
      }
   }

   private class FileInfoHandler implements HttpHandler {

      
      @Override
      public void handle(HttpExchange httpExchange) throws IOException {
         if ("GET".equals(httpExchange.getRequestMethod())) {
            OutputStream outputStream = httpExchange.getResponseBody();
            httpExchange.sendResponseHeaders(200, RESPONSE.length());
            outputStream.write(RESPONSE.getBytes());
            outputStream.flush();
            outputStream.close();
         }
      }
   }
   
   private class FileDownloadHandler implements HttpHandler {
      @Override
      public void handle(HttpExchange httpExchange) throws IOException {
         if ("GET".equals(httpExchange.getRequestMethod())) {
            Headers headers = httpExchange.getResponseHeaders();
            headers.add("Content-Type", MIME_TYPE);
            byte[] response = FILE_CONTENT.getBytes();
            OutputStream outputStream = httpExchange.getResponseBody();
            httpExchange.sendResponseHeaders(200, response.length);
            outputStream.write(response);
            outputStream.flush();
            outputStream.close();
         }
      }
   }
   
   private class InvalidFileDownloadHandler implements HttpHandler {
      @Override
      public void handle(HttpExchange httpExchange) throws IOException {
         if ("GET".equals(httpExchange.getRequestMethod())) {
            Headers headers = httpExchange.getResponseHeaders();
            headers.add("Content-Type", MIME_TYPE);
            httpExchange.sendResponseHeaders(404, -1);
         }
      }
   }
}
