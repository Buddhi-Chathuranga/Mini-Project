package ifs.installer.component;

import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import ifs.installer.logging.InstallerLogger;
import ifs.installer.util.Helper;
import ifs.installer.util.ProcessResult;

public class DbDeploy {

   private String fileName = "";
   private String deliveryPath = "";
   private String userName = "";
   private String ialOwner = "";
   private String password = "";
   private String syspassword = "";
   private String connectString = "";
   private String logFilePath = "";
   private String extlogging = "";
   private String waitingTime = "";
   private String threadMethod = ""; 
   private String initialPasswords = "";
   
   private static final Logger logger = InstallerLogger.getLogger();
   
   public DbDeploy(Map<String, Object> properties, String action) throws IOException {
      setParams(properties, action);
   }

   private void setParams(Map<String, Object> properties, String action) throws IOException {
      if ("fileexec".equalsIgnoreCase(action)) {
         fileName = !properties.containsKey("dbInstaller.fileName") ? ""
               : "fileName=".concat((String) properties.get("dbInstaller.fileName"));
         userName = "userName=".concat((String) properties.getOrDefault("dbInstaller.userName", "ifsapp"));
         password = !properties.containsKey("dbInstaller.password") ? 
                      !properties.containsKey("dbInstaller.ifsappPassword") ? ""
               : "password=".concat((String) properties.get("dbInstaller.ifsappPassword"))
               : "password=".concat((String) properties.get("dbInstaller.password"));
         //this property should be removed, kind of depricated
         if ("".equals(password)) {
            password = !properties.containsKey("ifscore.passwords.ifsappPassword.data") ? ""
               : "password=".concat((String) properties.get("ifscore.passwords.ifsappPassword.data"));
         }
      } else {
         deliveryPath = "deliveryPath=".concat((String) properties.getOrDefault("dbInstaller.deliveryPath", Helper.getDefaultDeliveryDir()));
         userName = "userName=".concat((String) properties.getOrDefault("ifscore.users.ifsappUser.data", "ifsapp"));
         ialOwner = "ialOwner=".concat((String) properties.getOrDefault("dbInstaller.ialOwner", "ifsinfo"));
         password = !properties.containsKey("dbInstaller.ifsappPassword") ? 
                                !properties.containsKey("ifscore.passwords.ifsappPassword.data") ? ""
               : "password=".concat((String) properties.get("ifscore.passwords.ifsappPassword.data"))
               : "password=".concat((String) properties.get("dbInstaller.ifsappPassword")); 
      }
      syspassword = !properties.containsKey("dbInstaller.sysPassword") ? ""
            : "sysPassword=".concat((String) properties.get("dbInstaller.sysPassword"));
      connectString = !properties.containsKey("dbInstaller.jdbcUrl") ? 
                             !properties.containsKey("ifscore.secrets.jdbcUrl.data") ? ""
            : "connectString=".concat((String) properties.get("ifscore.secrets.jdbcUrl.data"))
            : "connectString=".concat((String) properties.get("dbInstaller.jdbcUrl"));
      logFilePath = "logFilePath=".concat(InstallerLogger.getLogfileLocation());
      extlogging = !properties.containsKey("dbInstaller.extLogging") ? ""
            : "extLogging=".concat((String) properties.get("dbInstaller.extLogging"));
      waitingTime = !properties.containsKey("dbInstaller.waitingTime") ? ""
            : "waitingTime=".concat((String) properties.get("dbInstaller.waitingTime"));
      threadMethod = !properties.containsKey("dbInstaller.threadMethod") ? ""
            : "threadMethod=".concat((String) properties.get("dbInstaller.threadMethod"));   
      
      initialPasswords = !properties.containsKey("dbInstaller.ifsappPassword") ? ""
            : "APPLICATION_OWNER=".concat((String) properties.get("dbInstaller.ifsappPassword")).concat(";");
      initialPasswords = initialPasswords + (!properties.containsKey("ifscore.passwords.ifsiamPassword.data") ? ""
            : "IFSIAMSYS=".concat((String) properties.get("ifscore.passwords.ifsiamPassword.data")).concat(";"));
      initialPasswords = initialPasswords + (!properties.containsKey("ifscore.passwords.ifssysPassword.data") ? ""
            : "IFSSYS=".concat((String) properties.get("ifscore.passwords.ifssysPassword.data")).concat(";"));
      initialPasswords = initialPasswords + (!properties.containsKey("ifscore.passwords.ifsmonPassword.data") ? ""
            : "IFSMONITORING=".concat((String) properties.get("ifscore.passwords.ifsmonPassword.data")).concat(";"));  
      if (!"".equals(initialPasswords))
         initialPasswords = "initialPasswords=" + initialPasswords;
              
   }

   public boolean runDbDeploy() {
      String directive;
      String extra;
      File script;

      if (Helper.IS_WINDOWS) {
         directive = "cmd.exe";
         extra = "/C";
      } else {
         directive = "bash";
         extra = logger.getLevel() == Level.FINEST ? "-x" : "+x";
      }
      script = new File("installers/db-deploy." + (Helper.IS_WINDOWS ? "cmd" : "sh"));
      logger.fine("calling db-deploy");
      try {
         logger.info("Running database installer, logs location: "+ logFilePath.substring("logFilePath=".length()).trim());
         ProcessResult result = Helper.runProcessWithResult("installers", directive, extra, script.getAbsolutePath(), fileName, deliveryPath, userName, ialOwner,
               password, syspassword, connectString, logFilePath, extlogging, waitingTime, threadMethod, initialPasswords);
         if (result.getProcess().exitValue() == 0) {
            logger.fine("successfully exited db-deploy");
             return true;
         } else {
            logger.severe("Failed to run dbInstaller " + result.getResult());
         }
      } catch (IOException | InterruptedException e) {
         logger.severe("Exception caught when running dbInstaller " + e);
      }
      return false;      
   }
}
