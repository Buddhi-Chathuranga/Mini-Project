package ifs.fnd.printingnode.socketspooler;

/*
 * Spooler.java
 *
 * Modified:
 *    dasvse  2015-11-23 - 125692 - Improved Socket Spooler. Locked spoolfiles
 */


import ifs.fnd.log.LogMgr;
import ifs.fnd.log.Logger;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.lang.reflect.Field;
import java.util.HashMap;
import javax.swing.JDialog;

/**
 *
 * @author dasvse
 */
public class Spooler extends JDialog {

   /**
    * @param args the command line arguments
    */
   static String port = "";
   static String path = "";
   static String printer = ""; 
   HashMap configMap = new HashMap();
   static HashMap semaphore = new HashMap();
   
   public static void main(String[] args) throws IOException {
      new Spooler().run();
   }
   
   public void run ()throws IOException{
      Logger log  = LogMgr.getFrameworkLogger();
      File config = new File("ifs-spooler-config.properties");
      if(log.info){
         log.info("Reading spooler configuration from " + config.getAbsolutePath());
      }
      if(config.exists()){
            BufferedReader cw = new BufferedReader(new FileReader(config));
            String currentLine;
            while ((currentLine = cw.readLine()) != null) {
               currentLine = currentLine.toLowerCase().trim();
               if(currentLine.startsWith("#") || !currentLine.contains(".")){
                  continue;
               }
               try {
                  String name = currentLine.substring(0,currentLine.indexOf("."));
                  String property = currentLine.substring(currentLine.indexOf(".")+1);
                  String[] propInfo = property.split("=");
                  if(propInfo.length<2){
                     continue;
                  }
                  String prop = propInfo[0];
                  String value = propInfo[1];

                  if(!configMap.containsKey(name)){
                     if(name.startsWith("listener")){
                        configMap.put(name, new SocketListener());
                     } else if(name.startsWith("queue-processor")) {
                        configMap.put(name, new QueueProcessor(this));
                     } else if(name.startsWith("file-processor")) {
                        configMap.put(name, new FileProcessor(this));
                     }
                  }


                  Object inst = configMap.get(name);
                  final Field field = inst.getClass().getDeclaredField(prop);
                  field.setAccessible(true);
                  field.set(inst, value);
               } catch (Exception ex) {
                   log.error("Configuration Error: Could not set property " + ex.getMessage());
               } 
            }
            cw.close();
            for(Object inst:configMap.values()){
               try {
                  inst.getClass().getMethod("start").invoke(inst);
               } catch (Exception ex) {
                      log.error("Configuration Error: Could not start " + ex.getMessage());
               }
            }
      } else {
        log.error("Could not find config file: " + config.getAbsolutePath());
      }     
   }
   
}
