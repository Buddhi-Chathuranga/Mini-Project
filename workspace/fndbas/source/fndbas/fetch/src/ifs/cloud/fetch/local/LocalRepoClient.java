package ifs.cloud.fetch.local;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import ifs.cloud.fetch.FetchException;
import ifs.cloud.fetch.FileInfo;
import ifs.cloud.fetch.IBytesReceiver;
import ifs.cloud.fetch.IClient;

public class LocalRepoClient implements IClient {

   private String folder;
   private String host;
   
   public LocalRepoClient() {
   }

   @Override
   public void close() throws IOException {
   }

   @Override
   public void setRepoName(String repoName) {
      folder = repoName;
   }

   @Override
   public void setHost(String host) {
      if (host.startsWith("local:"))
         host = host.substring(6);
      this.host = host;
   }

   @Override
   public void setUserName(String user) {
   }

   @Override
   public void setPassword(String pass) {
   }

   @Override
   public FileInfo getFileInfo(String file) throws FetchException {
      File f = new File(host, folder);
      File src = new File(f, file);
      if (src.exists()) {
         LocalFileInfo fi = new LocalFileInfo(src);
         return fi;
      }
      throw new FetchException(new FileNotFoundException(src.getAbsolutePath()));
   }

   @Override
   public boolean isFileChanged(FileInfo file) {
      return true;
   }

   @Override
   public void downloadFile(FileInfo file, IBytesReceiver receiver) throws FetchException {
      try (FileInputStream fis = new FileInputStream(file.getPath())) {
         byte [] b = new byte[4096];
         while (fis.read(b) > -1) {
            receiver.accept(b);
         }
      }
      catch (IOException ex) {
         new FetchException(ex);
      }
   }

   @Override
   public void setCachePath(File path) {
   }

   public class LocalFileInfo extends FileInfo {
      LocalFileInfo(File file) {
         super.setPath(file.getAbsolutePath());
         super.setType("Local File");
         super.setSize((int)file.length());
      }
   }
   
   @Override
   public String toString() {
      return "Local Repo: " + host;
   }
}
