package ifs.fnd.printingnode.socketspooler;

/*
 * FileProcessor.java
 *
 * Modified:
 *    dasvse  2015-11-23 - 125692 - Improved Socket Spooler. Locked spoolfiles
 */


import ifs.fnd.log.LogMgr;
import ifs.fnd.log.Logger;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.swing.JDialog;



/**
 *
 * @author dasvse
 */
public class FileProcessor extends Thread {

   String printer = "";
   String path = "";
   JDialog mainframe;
   String delay = "0";
   String polltime = "5000";
   String host = "";
   String port = "";
   String output = "separated";
   
   public FileProcessor(JDialog mainframe) {
      this.mainframe = mainframe;
   }

   public FileProcessor(String printer, JDialog mainframe) {
      this.printer = printer;
      this.mainframe = mainframe;
   }

   public FileProcessor(String printer, String path, JDialog mainframe) {
      this.printer = printer;
      this.path = path;
      this.mainframe = mainframe;
   }

   @Override
   public void run() {
      Logger log  = LogMgr.getFrameworkLogger();
      if(!path.endsWith(File.separator)){
         path += File.separator;
      }
      try {
         printer = printer.replace('\\','/');
         String[] printerInfo = printer.split(":");
         host = printerInfo.length>0?printerInfo[0]:null;
         port = printerInfo.length>1?printerInfo[1]:null;
         if(printerInfo.length==1){
            if(!printer.contains("/")){
               log.error(logDate() +" Syntax error: Printer is not correctly configured. Its nether a host:port or a path.");
               return; 
            }
         }
         File fileDir = new File(path);
         if (!fileDir.exists()) {
            fileDir.mkdir();
         }
         if(log.info){
            log.info(logDate() +" File Processor ("+ path +") started for printer: " + printer);
         }
         OutputStream os = null;
         File spoolfile = null;
         while (true) {
            try{
               File[] files = fileDir.listFiles();
               if (files.length > 0) {
                  spoolfile = files[0];
                  log.info(logDate() +" Processing file: " + spoolfile.getName());
               } else {
                  //log.debug("No spool jobs found.");
                  if(os!=null){
                     os.close();
                     os = null;
                  }
                  waitABit(polltime);
               }


               if (spoolfile!=null && spoolfile.canRead()) {
                  FileInputStream fis = new FileInputStream(spoolfile);
                  File p = new File(printer);
                  String outFile = printer;
                  if (p.isDirectory()) {
                     if(!outFile.endsWith("/")){
                        outFile+="/";
                     }
                     outFile += spoolfile.getName();
                  }

                  if(os==null){
                     os = outFile.contains("/")?new FileOutputStream(outFile):openSocketStream(host,port);
                  }
                  if(os==null){
                     fis.close();
                     continue;
                  }
                  byte[] buffer = new byte[1024*32];
                  int rd;
                  while ((rd = fis.read(buffer))>=0) {
                     os.write(buffer,0,rd);
                  }
                  fis.close();
                  os.flush();
                  if(!"merged".equalsIgnoreCase(output)){
                     os.close();
                     os = null; 
                  }
                  spoolfile.delete();
               }
               waitABit(delay);
            }catch(IOException ex){
               log.error(logDate() +" Failed to process file: " + ex.getMessage());
               if(os!=null){
                 os.flush();
                 os.close();
                 os = null;
               }
               waitABit(polltime);
            }
          }
     } catch (Exception ex) {
         log.error(logDate() +" Processor Failed: " + ex.getMessage());
     }
   }

   private void waitABit(String time) {
      try {
         Thread.sleep(Integer.parseInt(time));
      } catch (InterruptedException ex) {
         System.out.println(ex.getMessage());
      }
   }

   private DataOutputStream openSocketStream(String host, String port) {
      Logger log  = LogMgr.getFrameworkLogger();
      if(host==null||port==null|host.isEmpty()||port.isEmpty()){
         log.error(logDate() +" Empty host or port, could not connect. Fix your configuration!");
         throw new Error(); 
      }
      int retryCountDown = 10;
      Socket clientSocket;
      while (true) {
         try {
            clientSocket = new Socket(host, Integer.parseInt(port));
            break;
         } catch (IOException io) {
            log.debug(logDate() +" Failed to connect, retrying ...");
            retryCountDown--;
            if (retryCountDown < 0) {
               log.info(logDate() +" Wrong adress or printer not responding. Will try again in " + Double.parseDouble(polltime)/100.0 + " sec." );
               waitABit(polltime+"0");
               return null; // failed
            }
            waitABit(polltime);
         }
      }
      DataOutputStream outToServer;
      try {
         outToServer = new DataOutputStream(clientSocket.getOutputStream());
      } catch (IOException ex) {
         System.out.print(ex.getMessage());
         return null;
      }
      return outToServer;
   }
   private String logDate(){
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      return sdf.format(new Date());
   }
}
