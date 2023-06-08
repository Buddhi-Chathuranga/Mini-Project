package ifs.installer;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

import ifs.installer.logging.InstallerLogger;
import ifs.installer.util.DBConnection;
import ifs.installer.util.Helper;
import ifs.installer.util.ProcessResult;
import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedHashMap;

public class Validator {

   private static final Logger logger = InstallerLogger.getLogger();

   public void showKubectlConfig(Map<String, Object> properties) {
      ArrayList<String> command = new ArrayList<>();
      if (Helper.IS_WINDOWS) {
         command.add("cmd.exe");
         command.add("/C");
      } 
      command.add("kubectl");
      String cfg = (String) properties.get("kubeconfigFlag");
      if (cfg != null) {
         String [] temp = cfg.split(" ");
         for (String s : temp) {
            command.add(s);
         }
      }
      command.add("config");
      command.add("view");
      command.add("--minify");

      try {
         logger.finer("Querying kubectl configuration...");
         ProcessResult pr = Helper.runProcessWithResult(new HashMap<String, String>(), new File("").getAbsolutePath(), true, command.toArray(new String[command.size()]));
         if (pr.getProcess().exitValue() == 0) {
            logger.info("======================");
            logger.info("ACTIVE KUBECTL CONFIG");
            String [] temp = pr.getResult().split("\n");
            for (String s : temp) {
               logger.info(s);
            }
            logger.info("======================");
         } 
      } catch (IOException | InterruptedException e) {
         logger.warning(e.toString());
      }
   }
   
   public boolean validateDeliveryId(Map<String, Object> properties) {
      String lineSeparator = System.getProperty("line.separator", "\n");
      String deliveryPath = (String) properties.getOrDefault("dbInstaller.deliveryPath", Helper.getDefaultDeliveryDir());
      String deliveryIdFile = deliveryPath + "/database/deliveryid.txt";
      if (!new File(deliveryIdFile).exists()) { 
        return true;
      }
      
      String deliveryValidationEnabled  = (String) properties.getOrDefault("deliveryValidationEnabled", "true");
      if ("false".equals(deliveryValidationEnabled )) {
         //Validation of the deliveries will be skipped
         logger.info("deliveryValidationEnabled set to false, no validation of deliveryid will be peformed.");
         return true;
      }
      
      String userName = (String) properties.getOrDefault("ifscore.users.ifsappUser.data", "ifsapp");
      String syspassword = !properties.containsKey("dbInstaller.sysPassword") ? ""
            : (String) properties.get("dbInstaller.sysPassword");
      String password = !properties.containsKey("dbInstaller.ifsappPassword") ? 
                             !properties.containsKey("ifscore.passwords.ifsappPassword.data") ? ""
            : (String) properties.get("ifscore.passwords.ifsappPassword.data")
            : (String) properties.get("dbInstaller.ifsappPassword"); 
      String connectString = !properties.containsKey("dbInstaller.jdbcUrl") ? 
                             !properties.containsKey("ifscore.secrets.jdbcUrl.data") ? ""
            : (String) properties.get("ifscore.secrets.jdbcUrl.data")
            : (String) properties.get("dbInstaller.jdbcUrl");      
      
      HashMap<String, String> deliveryIds = new HashMap<>();
      LinkedHashMap<String, String> deliveryIdMulti = new LinkedHashMap<>();
      Statement stmt = null;
      if (!"".equals(password) && !"".equals(connectString)) {
         try {
            logger.fine("Trying to connect to the database");
            Connection con = null;
            con = DBConnection.openConnection(userName, password, connectString);

            if (con == null || con.isClosed() && !"".equalsIgnoreCase(syspassword)) {
               //if fresh install, application user not yet created, prepare.sql not yet run, try verifying connection with SYS if syspassword is given.
               con = DBConnection.openConnection("SYS", syspassword, connectString);
            }

            if (con == null || con.isClosed()) {
               logger.severe("No connection to the database could be established (1)! Connect string " + connectString);
               return false;
            }
            logger.fine("Connection successfull");         
            stmt = con.createStatement();
            for (ResultSet rs = stmt.executeQuery("SELECT delivery_id, baseline_delivery_id FROM delivery_registration_Tab r WHERE r.id = (SELECT MAX(t.id) FROM delivery_registration_tab t)"); rs.next();) {
               deliveryIds.put("DELIVERY_ID", rs.getString("delivery_id"));
               deliveryIds.put("BASELINE_DELIVERY_ID", rs.getString("baseline_delivery_id"));
            }
         } catch (SQLException ex) {
            //Probably error since the table does not exist in an empty database or when veryfing db connection as SYS
         } finally {
            try {
               if (stmt!=null) {
                  stmt.close();
                  logger.fine("Connection closed");
               }
            } catch (SQLException ex) {
                 logger.severe("Error closing database. " + ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
                 return false;
            }
         }
      } 
      
      String line;
      String deliveryId = "";
      String baseLinedeliveryId = "";
      try {
         try (BufferedReader reader = new BufferedReader(new FileReader(deliveryIdFile))) {
            while ((line = reader.readLine()) != null){
               int lineLength = line.length();
               int seperatorIndex = line.indexOf("=");
               if (line.startsWith("deliveryid=")) {
                  deliveryId = line.substring(seperatorIndex+1, lineLength);
               } else if (line.startsWith("baselinedeliveryid=")) {
                  baseLinedeliveryId = line.substring(seperatorIndex+1, lineLength);
                  deliveryIdMulti.put(deliveryId, baseLinedeliveryId);
               }   
            }
         }
      } catch (IOException ex) {
         logger.severe("Error when reading " + deliveryIdFile + lineSeparator + ex.toString());
         return false;
      }
      
      //Check if multi delivery.
      //The check when multidelivery will be skipped for now, but maybe implemented later
      if (deliveryIdMulti.size() > 1) {
         logger.info("Multi delivery, no validation of deliveryids will be peformed!");
         return true;
      }
      
      if ("".equals(baseLinedeliveryId)) {
          logger.info("No base line delivery defined for delivery " + deliveryId);
      } else if (deliveryIds.containsKey("DELIVERY_ID") && !deliveryIds.get("DELIVERY_ID").equalsIgnoreCase(deliveryId) && !deliveryIds.get("DELIVERY_ID").equalsIgnoreCase(baseLinedeliveryId)) {
          logger.severe("The delivery not in sequence! Last delivery installed is " + deliveryIds.get("DELIVERY_ID") + " but expected is " + baseLinedeliveryId);
          return false;
      } 
      
      if (deliveryIds.containsKey("DELIVERY_ID") && deliveryIds.get("DELIVERY_ID").equalsIgnoreCase(deliveryId)) {
         logger.info("Delivery Id " + deliveryId + " will be reinstalled.");          
      } else {
         logger.info("Delivery Id " + deliveryId + " will be installed."); 
      }
      
      return true;
   }    
}
