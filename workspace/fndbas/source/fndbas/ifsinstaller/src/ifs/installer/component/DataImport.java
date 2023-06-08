package ifs.installer.component;

import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import ifs.installer.logging.InstallerLogger;
import ifs.installer.util.Helper;
import ifs.installer.util.ProcessResult;

public class DataImport {

   private String deliveryPath = "";
   private String userName = "";
   private String password = "";
   private String connectString = "";
   private String logFilePath = "";
   private String transRuntime = "";
   private String transImportAttributes = "";
   private String transImportTranslations = ""; 
   
   private static final Logger logger = InstallerLogger.getLogger();
   
   public DataImport(Map<String, Object> properties) throws IOException {
      setParams(properties);
   }

   private void setParams(Map<String, Object> properties) throws IOException {
      deliveryPath = "deliveryPath=".concat((String) properties.getOrDefault("dbInstaller.deliveryPath", Helper.getDefaultDeliveryDir()));
      userName = "userName=".concat((String) properties.getOrDefault("ifscore.users.ifsappUser.data", "ifsapp"));
      password = !properties.containsKey("dbInstaller.ifsappPassword") ? 
                             !properties.containsKey("ifscore.passwords.ifsappPassword.data") ? ""
            : "password=".concat((String) properties.get("ifscore.passwords.ifsappPassword.data"))
            : "password=".concat((String) properties.get("dbInstaller.ifsappPassword"));   
      connectString = !properties.containsKey("dbInstaller.jdbcUrl") ? 
                             !properties.containsKey("ifscore.secrets.jdbcUrl.data") ? ""
            : "connectString=".concat((String) properties.get("ifscore.secrets.jdbcUrl.data"))
            : "connectString=".concat((String) properties.get("dbInstaller.jdbcUrl"));
      logFilePath = "logFilePath=".concat(InstallerLogger.getLogfileLocation());
      transRuntime = !properties.containsKey("dbInstaller.transRuntime") ? ""
            : "transRuntime=".concat((String) properties.get("dbInstaller.transRuntime"));
      transImportAttributes = !properties.containsKey("dbInstaller.transImportAttributes") ? ""
            : "transImportAttributes=".concat((String) properties.get("dbInstaller.transImportAttributes"));
      transImportTranslations = !properties.containsKey("dbInstaller.transImportTranslations") ? ""
            : "transImportTranslations=".concat((String) properties.get("dbInstaller.transImportTranslations"));    
      
   }

   public boolean runDataImport() {
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
      script = new File("installers/db-import-data." + (Helper.IS_WINDOWS ? "cmd" : "sh"));
      logger.fine("calling db-import-data");
      try {
         logger.info("Running data import, logs location: "+ logFilePath.substring("logFilePath=".length()).trim());
         ProcessResult result = Helper.runProcessWithResult("installers", directive, extra, script.getAbsolutePath(), deliveryPath, userName,
               password, connectString, logFilePath, transRuntime, transImportAttributes, transImportTranslations);
         if (result.getProcess().exitValue() == 0) {
            logger.fine("successfully exited db-import-data");
            return true;
         } else {
            logger.severe("Failed to run data import " + result.getResult());
         }
      } catch (IOException | InterruptedException e) {
         logger.severe("Exception caught when running data import " + e);
      }
      return false;      
   }
}
