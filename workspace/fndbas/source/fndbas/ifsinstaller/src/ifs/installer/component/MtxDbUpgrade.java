package ifs.installer.component;

import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import ifs.installer.logging.InstallerLogger;
import ifs.installer.util.Helper;
import ifs.installer.util.ProcessResult;

public class MtxDbUpgrade {

   private String deliveryPath = "";
   private String bundlePath = "";
   private String schemaUsername = "";
   private String schemaPassword = "";
   private String connectString = "";
   private String dbService = "";
   private String dbPort = "";
   private String dbHost = "";
   private String logFilePath = "";
   
   private static final Logger logger = InstallerLogger.getLogger();
   
   public MtxDbUpgrade(Map<String, Object> properties) throws IOException {
      setParams(properties);
   }

   private void setParams(Map<String, Object> properties) throws IOException {
      deliveryPath = !properties.containsKey("dbInstaller.deliveryPath") ? ""
            : (String) properties.get("dbInstaller.deliveryPath");
      bundlePath = deliveryPath.concat(File.separator + "mx-database" + File.separator + "install" + File.separator + "upgrade" + File.separator + "bundle");
      schemaUsername = "-u ".concat((String) properties.getOrDefault("ifsmaintenixdb.maintenixUser", "maintenix"));
      schemaPassword = !properties.containsKey("ifsmaintenixdb.maintenixPassword") ? ""
            : "-P ".concat((String) properties.get("ifsmaintenixdb.maintenixPassword"));
      connectString = !properties.containsKey("dbInstaller.jdbcUrl") ? 
                             !properties.containsKey("ifscore.secrets.jdbcUrl.data") ? ""
            : "connectString=".concat((String) properties.get("ifscore.secrets.jdbcUrl.data"))
            : "connectString=".concat((String) properties.get("dbInstaller.jdbcUrl"));
      dbService = Helper.parseTns("SERVICE_NAME", connectString);
      dbPort = Helper.parseTns("PORT", connectString);
      dbHost = Helper.parseTns("HOST", connectString);
      logFilePath = InstallerLogger.getLogfileLocation().concat(File.separator + "mtxdbupg.log");
   }

   public boolean runDbUpgrade() {
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
      script = new File("installers/mtx-db-upgrade." + (Helper.IS_WINDOWS ? "cmd" : "sh"));

      // Ensure that the bundle is available.
      if (!Helper.isPathValid(bundlePath) || !(new File(bundlePath)).isDirectory())  {
         logger.info("No Maintenix DB upgrade to be performed");
         return false;
      }

      try {
         logger.info("Running Maintenix database upgrade, logs location: "+ logFilePath);
         ProcessResult result = Helper.runProcessWithResult("installers", directive, extra, script.getAbsolutePath(), 
                 "-f", logFilePath, "-b", bundlePath,
                 "-c", dbHost, "-p", dbPort, "-S", dbService, schemaUsername, schemaPassword);
         if (result.getProcess().exitValue() == 0) {
            return true;
         } else {
            logger.severe("Failed to run Maintenix DB upgrade " + result.getResult());
         }
      } catch (IOException | InterruptedException e) {
         logger.severe("Exception caught when running mtx-db-upgrade " + e);
      }
      return false;      
   }
}
