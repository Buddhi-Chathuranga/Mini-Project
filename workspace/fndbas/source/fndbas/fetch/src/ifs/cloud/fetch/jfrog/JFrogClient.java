package ifs.cloud.fetch.jfrog;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.Authenticator;
import java.net.MalformedURLException;
import java.net.PasswordAuthentication;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpResponse.BodyHandlers;
import java.util.Optional;
import java.util.Properties;
import java.util.function.Consumer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import ifs.cloud.fetch.FetchException;
import ifs.cloud.fetch.FileInfo;
import ifs.cloud.fetch.IBytesReceiver;
import ifs.cloud.fetch.IClient;

public class JFrogClient implements IClient {

   class JFrogAuthenticator extends Authenticator {

      private String user, pass;
      
      JFrogAuthenticator(String user, String pass) {
         System.setProperty("jdk.httpclient.auth.retrylimit", "1");
         this.user = user;
         this.pass = pass;
      }

      @Override
      protected PasswordAuthentication getPasswordAuthentication() {
         return new PasswordAuthentication(user, pass.toCharArray());
      }

      void setUser(String user) {
         this.user = user;
      }

      void setPass(String pass) {
         this.pass = pass;
      }
   }

   private HttpClient client;
   private String repoName;
   private String host;
   private String protocol = "https";
   private int port = -1; // default
   
   private final JFrogAuthenticator auth;
   private JFrogChecksumCache cache;

   public JFrogClient() {

      this.auth = new JFrogAuthenticator(null, null);
      this.client = HttpClient.newBuilder().authenticator(auth).build();
   }
   
   protected JFrogClient(HttpClient client) {
      this.auth = new JFrogAuthenticator(null, null);
      this.client = client;
   }

   public void setRepoName(String repoName) {
      this.repoName = repoName;
   }

   public void setHost(String host) {
      this.host = host;
   }
   
   public void setProtocol(String protocol) {
      this.protocol = protocol;
   }
   
   public void setPort(int port) {
      this.port = port;
   }
   
   public void setUserName(String user) {
      this.auth.setUser(user);
   }

   public void setPassword(String pass) {
      this.auth.setPass(pass);
   }

   private HttpRequest makeRequest(URL url) throws URISyntaxException, MalformedURLException {
      return HttpRequest.newBuilder().version(HttpClient.Version.HTTP_2).uri(url.toURI()).headers("Accept-Enconding", "gzip, deflate").build();
   }

   private String makeFilePath(String... files) {
      StringBuilder sb = new StringBuilder();
      for (int i = 0; i < files.length; i++) {
         String temp = files[i];
         if (temp.startsWith("/"))
            temp = temp.substring(1);
         if (temp.endsWith("/"))
            temp = temp.substring(0, temp.length() - 1);

         sb.append("/").append(temp);
      }
      return sb.toString();
   }

   public FileInfo getFileInfo(String file) throws FetchException {
      try {

         URL url = new URL(protocol, host, port, makeFilePath("artifactory", "api", "storage", repoName, file));
         HttpRequest request = makeRequest(url);

         HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
         if (response.statusCode() == 200) {
            return new JFrogFileInfo(response.body());
         }
         throw new HttpException(response.body(), response.statusCode());
      }
      catch (IOException ex) {
         if (ex.getMessage().indexOf("too many authentication attempts") >= 0) 
         {
            throw new HttpAuthException(ex);
         }
         throw new HttpException(ex);
      }
      catch (InterruptedException | URISyntaxException ex) {
         throw new HttpException(ex);
      }
   }

   public boolean isFileChanged(FileInfo file) {
      return (cache == null || !cache.checksumEquals((JFrogFileInfo) file));
   }

   public void downloadFile(FileInfo file, final IBytesReceiver receiver) throws FetchException {
      try {
         URL url = new URL(protocol, host, port, makeFilePath("artifactory", repoName, file.getPath()));
         HttpRequest request = makeRequest(url);

         HttpResponse<Void> response = client.send(request, BodyHandlers.ofByteArrayConsumer(new Consumer<Optional<byte[]>>() {

            @Override
            public void accept(Optional<byte[]> t) {
               if (t.isPresent()) {
                  receiver.accept(t.get());
               }
            }
         }));
         if (response.statusCode() == 200) {
            if (cache != null)
               cache.add((JFrogFileInfo) file);
            return;
         }
         throw new HttpException("", response.statusCode());
      }
      catch (IOException | InterruptedException | URISyntaxException ex) {

         throw new HttpException(ex);
      }
      catch (Error e) {
         throw e; // system errors like out of memory
      }
      catch (Throwable t) {
         throw new FetchException(t);
      }
   }

   public void setCachePath(File path) {
      this.cache = JFrogChecksumCache.load(new File(path, ".cache"));
   }

   @Override
   public void close() throws IOException {
      if (cache != null) {
         cache.save();
      }
   }
   
   @Override
   public String toString() {
      return "JFROG: " + host;
   }

   public static class JFrogFileInfo extends FileInfo {

      private String checksum;

      private String find(Pattern pattern, String str) {

         Matcher matcher = pattern.matcher(str);
         if (matcher.find()) {
            String value = matcher.group("value");
            return value;
         }
         return null;
      }

      private String findInLines(String[] lines, String key) {

         Pattern pattern = Pattern.compile(new StringBuilder().append("^ *\\\"").append(key).append("\\\" *\\: *\\\"(?<value>.*)\\\",?$").toString(), Pattern.CASE_INSENSITIVE);

         for (int i = 0; i < lines.length; i++) {

            String value = find(pattern, lines[i]);
            if (value != null)
               return value;
         }
         return null;
      }

      JFrogFileInfo(String json) {

         String[] lines = json.split("\n");
         String value = findInLines(lines, "size");
         setSize(value == null ? -1 : Integer.parseInt(value));
         setType(findInLines(lines, "mimeType"));
         setPath(findInLines(lines, "path"));
         checksum = findInLines(lines, "sha256");
      }

      String getChecksum() {

         return checksum;
      }
   }

   public static class JFrogChecksumCache {

      private Properties cache = new Properties();
      private final transient File path;

      JFrogChecksumCache(File path) {
         this.path = path;
      }

      public boolean checksumEquals(JFrogFileInfo file) {

         synchronized (cache) {

            String checksum = (String) cache.get(file.getPath());
            return (checksum != null && checksum.equals(file.getChecksum()));
         }
      }

      void add(JFrogFileInfo file) {

         synchronized (cache) {

            cache.put(file.getPath(), file.getChecksum());
         }
      }

      public void save() throws IOException {

         try (FileOutputStream fos = new FileOutputStream(path)) {

            cache.store(fos, "last download file checksum");
         }
      }

      static JFrogChecksumCache load(File file) {

         JFrogChecksumCache temp = new JFrogChecksumCache(file);
         if (file.exists()) {
            try (FileInputStream fis = new FileInputStream(file)) {

               temp.cache.load(fis);
            }
            catch (IOException ex) {}
         }
         return temp;
      }
   }

}
