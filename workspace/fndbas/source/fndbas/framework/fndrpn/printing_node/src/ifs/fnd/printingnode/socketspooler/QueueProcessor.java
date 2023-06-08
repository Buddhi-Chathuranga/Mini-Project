package ifs.fnd.printingnode.socketspooler;

/*
 * QueueProcessor.java
 *
 * Modified:
 *    dasvse  2015-11-23 - 125692 - Improved Socket Spooler. Locked spoolfiles
 */


import ifs.fnd.log.LogMgr;
import ifs.fnd.log.Logger;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
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
public class QueueProcessor extends Thread {

   String printer = "";
   String path = "";
   JDialog mainframe;
   String delay = "0";
   String polltime = "5000";
   String host = "";
   String port = "";
   String output = "merged";

   public QueueProcessor(JDialog mainframe) {
      this.mainframe = mainframe;
   }
   
   public QueueProcessor(String printer, JDialog mainframe) {
      this.printer = printer;
      this.mainframe = mainframe;
   }

   public QueueProcessor(String printer, String path, JDialog mainframe) {
      this.printer = printer;
      this.path = path;
      this.mainframe = mainframe;
   }
   private File getQueueFile() throws IOException{
         Logger log  = LogMgr.getFrameworkLogger();
         File queueDir = new File(path);
         if (!queueDir.exists()) {
            queueDir.mkdir();
         }
         File queueFile = new File(path + "spool_queue" + ".dat");
         if (!queueFile.exists()) {
            try {
               queueFile.createNewFile();
            } catch (IOException ex) {
               log.error(logDate() +" Processor Failed: Could not create queue. " + ex.getMessage());
               throw ex;
            }
         }
         return queueFile;
   }
        

   @Override
   public void run() {
      Logger log  = LogMgr.getFrameworkLogger();
         if(!path.endsWith(File.separator)){
            path += File.separator;
         }
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
         
         File p = new File(printer);
         boolean isFolder = false;
         if (p.isDirectory()) {
            isFolder = true;
               log.info(logDate() +" Queue Processor ("+path+") started and will send jobs to folder: " + printer);
         }
         else {
               log.info(logDate() +" Queue Processor started for printer: " + printer);
         }
         BufferedReader queue = null;
         OutputStream os = null;
         while (true) {
            try {
               FileReader qfr = new FileReader(getQueueFile());
               queue = new BufferedReader(qfr);
               String spoolfile = queue.readLine();
               queue.close();
               if (spoolfile == null) {
                  if(os!=null){
                     os.close();
                     os = null;
                  }
                  waitABit(polltime);
                  continue;
               }
               log.debug(logDate() +" Printing job: " + spoolfile);
               if (!"Preview".equalsIgnoreCase(printer)){
                  try{
                     File f = new File(spoolfile);
                     if (f.exists()) {
                        String pout = printer;
                        if(isFolder){
                           if(!pout.endsWith("/")){
                              pout+="/";
                           }
                           pout += f.getName();
                        }
                        if(os==null){
                           os = pout.contains("/")?new FileOutputStream(pout):openSocketStream(host,port);
                           if(os==null){
                              continue;
                           }
                        }
                        byte[] buffer = new byte[1024*32];
                        int rb;
                        FileInputStream fis = new FileInputStream(f);
                        while ((rb = fis.read(buffer)) >= 0) {
                           os.write(buffer, 0, rb);
                        }
                        fis.close();
                        os.flush();
                        if(!"merged".equalsIgnoreCase(output)){
                          os.close();
                          os = null; 
                        }
                        f.delete();
                     } else {
                        log.debug(logDate() +" Spool file " + spoolfile +" is missing. Removing it from the queue.");
                     }
                     retries=0;
                     waitABit(delay);
                  }catch(Exception ex){
                        log.error(logDate() +" Printing failed. " + ex.getMessage());
                        if(os!=null){
                          os.flush();
                          os.close();
                          os = null;
                        }
                        waitABit(polltime);
                        continue;
                  }
               }else{
                  /*Preview prev = new Preview(spoolfile);
                  try {           
                     File f = new File(spoolfile);
                     if (f.exists()) {
                        ParseZPL parser = new ParseZPL(new StringReader(getStringFromFile(f)));
                        parser.parse();
                        prev.setScale( "80" );
                        prev.display( parser.getLabels());
                        prev.fitToPage();

                        f.delete();
                     }

                  } catch (Exception ex) {
                      System.out.print(ex.getMessage());
                      return;
                  }


                  prev.show();*/
               }
               synchronized(Spooler.semaphore.get(path)){
               File tempFile = new File(path + "spool_queue" + ".tmp");
               BufferedWriter qwriter = new BufferedWriter(new FileWriter(tempFile));
               String currentLine;
               File queFile = getQueueFile();
               qfr = new FileReader(queFile);
               queue = new BufferedReader(qfr);
               queue.readLine(); // Read over the first to exclude it.              
               while ((currentLine = queue.readLine()) != null) {
                  qwriter.write(currentLine);
                  qwriter.newLine();
               }
               queue.close();
               qwriter.flush();
               qwriter.close();
               if(!tempFile.renameTo(queFile)){
                  queFile.delete();
                  if(!tempFile.renameTo(queFile))
                  {
                     throw new IOException("Could not update Spool Queue. IO Error, file in use.");
                  }
               }
               tempFile.delete();
               }
            } catch (IOException ex) {
               log.error(logDate() +" Processor Failed: " + ex.getMessage());                  
               if(queue!=null){ 
                  try {
                     queue.close();
                  } catch (IOException ex1) {
                     log.error(logDate() +" FATAL ERROR: Can't even close queue to handle error. Remove queue files and restart spooler.");                  
                  }
               }
               waitABit(polltime);
            } 
            
            
         }
   }

   private void waitABit(String time) {
      try {
         Thread.sleep(Integer.parseInt(time));
      } catch (InterruptedException ex) {
         System.out.println(ex.getMessage());
      }
   }
   
   int retries = 0;
   private DataOutputStream openSocketStream(String host, String port) {
      Logger log  = LogMgr.getFrameworkLogger();

      Socket clientSocket;
      while (true) {
         try {
            clientSocket = new Socket(host, Integer.parseInt(port));
            break;
         } catch (IOException io) {
            retries++;
            if (retries > 10) {
               log.info(logDate() +" Failed to connect to " + host +":"+ port + ". Printer is not responding. Will try again in " + Double.parseDouble(polltime)/100.0 + " sec." );
               waitABit(polltime+"0"); // same as *10 :)
               return null; // failed
            }else {
               log.debug(logDate() +" Failed to connect. Retrying... ");
               waitABit(polltime);
            }
            return null;
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
