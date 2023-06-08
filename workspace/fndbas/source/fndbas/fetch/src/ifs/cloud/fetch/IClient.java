package ifs.cloud.fetch;

import java.io.Closeable;
import java.io.File;

public interface IClient extends Closeable {

   public void setRepoName(String repoName);

   public void setHost(String host);

   public void setUserName(String user);

   public void setPassword(String pass);

   public FileInfo getFileInfo(String file) throws FetchException;

   public boolean isFileChanged(FileInfo file);

   public void downloadFile(FileInfo file, final IBytesReceiver receiver) throws FetchException;

   public void setCachePath(File path);
}
