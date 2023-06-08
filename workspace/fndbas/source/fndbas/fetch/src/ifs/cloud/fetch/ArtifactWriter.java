package ifs.cloud.fetch;

import java.io.Closeable;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class ArtifactWriter implements IBytesReceiver, Closeable {

   private FileOutputStream fos;

   private IProgress progress;
   private long total = 0;

   ArtifactWriter(File file) throws FetchException {
      
      try {
         fos = new FileOutputStream(file);
      }
      catch (FileNotFoundException ex) {
         throw new FetchException(ex);
      }
   }

   @Override
   public void accept(byte[] bs) {
      try {
         fos.write(bs);
         total += bs.length;
         if (progress != null) {
            progress.show(total);
         }
      }
      catch (IOException ex) {
         throw new RuntimeException(ex);
      }
   }

   @Override
   public void close() throws IOException {

      if (fos != null)
         fos.close();
   }

   void setProgressIndicator(IProgress progress) {
      this.progress = progress;
   }
}
