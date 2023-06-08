package ifs.fnd.printingnode.socketspooler;

/*
 * SocketListener.java
 *
 * Modified:
 *    dasvse  2015-11-23 - 125692 - Improved Socket Spooler. Locked spoolfiles
 */


import ifs.fnd.log.LogMgr;
import ifs.fnd.log.Logger;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author dasvse
 */
public class SocketListener extends Thread{

   /**
    * @param args the command line arguments
    */
   String port = "9100";
   String path = "";
   int serial = 0;
   
   public SocketListener(){

   }

   public SocketListener(String port, String path){
     this.port = port;

     this.path = path;
   }
      
   @Override
   public void run() {
      if(!path.endsWith(File.separator)){
         path += File.separator;
      }
      File queueDir = new File(path);
      if (!queueDir.exists()) {
         queueDir.mkdir();
      }
      Spooler.semaphore.put(path, path);

      Logger log  = LogMgr.getFrameworkLogger();
      try {
         ServerSocket welcomeSocket = new ServerSocket(Integer.parseInt(port));
               log.info(logDate() +" Socket listener on port "+port+" started for queue: " + path);
         
         while (true) {
            Socket connectionSocket = welcomeSocket.accept();
            log.debug(logDate() +" New Connection from: " + connectionSocket.getRemoteSocketAddress());
            InputStream in = connectionSocket.getInputStream();
            File file = new File(path + "Spooljob" + System.currentTimeMillis()+ serial + ".spl");
            FileOutputStream fos = new FileOutputStream(file);
            byte[] buffer = new byte[1024*32];
            int rd;
            while ((rd = in.read(buffer))>=0) {
              fos.write(buffer,0, rd);
            }
            fos.flush();
            fos.close();
            
            if(file.exists()){
               log.debug(logDate() +" Spoolfile saved. " + file.getName());
               synchronized(Spooler.semaphore.get(path)){
                  File queueFile = new File(path + "spool_queue" + ".dat");
                  if (!queueFile.exists()) {
                     queueFile.createNewFile();
                  }               
                  FileWriter qfw = new FileWriter(queueFile, true);
                  qfw.append(file.getAbsolutePath());
                  qfw.append(System.getProperty("line.separator"));
                  qfw.flush();
                  qfw.close();
               }
            }
            serial++;
         }
      } catch (IOException ex) {
         log.error(logDate() +" Listener Failed: " + ex.getMessage());
      }
   }
   private String logDate(){
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      return sdf.format(new Date());
   }
}
