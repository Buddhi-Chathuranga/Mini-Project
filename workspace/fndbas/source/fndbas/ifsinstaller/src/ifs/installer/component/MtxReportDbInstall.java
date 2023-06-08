package ifs.installer.component;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import ifs.installer.logging.InstallerLogger;
import ifs.installer.util.Helper;
import ifs.installer.util.ProcessResult;

public class MtxReportDbInstall {
	   private String deliveryPath = "";
	   private String propertiesFilePath = "";
	   private String schemaUsername = "";
	   private String schemaPassword = "";
	   private String systemUsername = "";
	   private String systemPassword = "";
	   private String connectString = "";
	   private String dbService = "";
	   private String dbPort = "";
	   private String dbHost = "";
	   private String importFilename = "";
	   private String importPath = "";
	   private String importDirectory = "";
	   private String datafileLocation = "";
	   private String datafileSize = "";
	   private String logFilePath = "";
	   
	   private static final Logger logger = InstallerLogger.getLogger();
	   
	   public MtxReportDbInstall(Map<String, Object> properties) throws IOException {
         setParams(properties);
	   }

	   private void setParams(Map<String, Object> properties) throws IOException {
	      deliveryPath = !properties.containsKey("dbInstaller.deliveryPath") ? ""
	            : (String) properties.get("dbInstaller.deliveryPath");
	      propertiesFilePath = deliveryPath.concat(File.separator + "mx-database" + File.separator + "install" + File.separator + "jasper.properties");
	      schemaUsername = (String) properties.getOrDefault("ifsmaintenixreportdb.jasperUser", "jasper");
	      schemaPassword = !properties.containsKey("ifsmaintenixreportdb.jasperPassword") ? ""
	            : (String) properties.get("ifsmaintenixreportdb.jasperPassword");
	      systemUsername = (String) properties.getOrDefault("ifsmaintenixreportdb.systemUser", "system");
	      systemPassword = !properties.containsKey("ifsmaintenixreportdb.systemPassword") ? ""
	            : (String) properties.get("ifsmaintenixreportdb.systemPassword");
	      connectString = !properties.containsKey("dbInstaller.jdbcUrl") ? 
	                             !properties.containsKey("ifscore.secrets.jdbcUrl.data") ? ""
	            : "connectString=".concat((String) properties.get("ifscore.secrets.jdbcUrl.data"))
	            : "connectString=".concat((String) properties.get("dbInstaller.jdbcUrl"));
	      dbService = Helper.parseTns("SERVICE_NAME", connectString);
	      dbPort = Helper.parseTns("PORT", connectString);
	      dbHost = Helper.parseTns("HOST", connectString);
	      importFilename = !properties.containsKey("ifsmaintenixreportdb.import.filename") ? ""
	            : (String) properties.get("ifsmaintenixreportdb.import.filename");
	      importPath = !properties.containsKey("ifsmaintenixreportdb.import.path") ? ""
	            : (String) properties.get("ifsmaintenixreportdb.import.path");
	      importDirectory = !properties.containsKey("ifsmaintenixreportdb.import.directory") ? ""
	            : (String) properties.get("ifsmaintenixreportdb.import.directory");
	      datafileLocation = !properties.containsKey("ifsmaintenixreportdb.oracle.datafile.location") ? ""
	            : (String) properties.get("ifsmaintenixreportdb.oracle.datafile.location");
	      datafileSize = !properties.containsKey("ifsmaintenixreportdb.oracle.datafile.size") ? ""
	            : (String) properties.get("ifsmaintenixreportdb.oracle.datafile.size");
	      logFilePath = InstallerLogger.getLogfileLocation();      
	   }

	   private void updateConfigFile() {

	      if (Helper.isPathValid(propertiesFilePath))  {
	         try {
	            Path path = Paths.get(propertiesFilePath);

	            List<String> fileContent = new ArrayList<>(Files.readAllLines(path, StandardCharsets.UTF_8));

	            String lineContent;
	            for (int i = 0; i < fileContent.size(); i++) {
	               lineContent = fileContent.get(i);
	               if (lineContent.contains("oracle.connect.host")) {
	                  fileContent.set(i, "oracle.connect.host=" + dbHost);
	               }
	               if (lineContent.contains("oracle.connect.port")) {
	                  fileContent.set(i, "oracle.connect.port=" + dbPort);
	               }
	               if (lineContent.contains("oracle.connect.service")) {
	                  fileContent.set(i, "oracle.connect.service=" + dbService);
	               }
	               if (lineContent.contains("jasper.username")) {
	                  fileContent.set(i, "jasper.username=" + schemaUsername);
	               }
	               if (lineContent.contains("jasper.password")) {
	                  fileContent.set(i, "jasper.password=" + schemaPassword);
	               }
	               if (lineContent.contains("system.username")) {
	                  fileContent.set(i, "system.username=" + systemUsername);
	               }
	               if (lineContent.contains("system.password")) {
	                  fileContent.set(i, "system.password=" + systemPassword);
	               }
	               if (lineContent.contains("oracle.datafile.location")) {
	                  fileContent.set(i, "oracle.datafile.location=" + datafileLocation);
	               }
	               if (lineContent.contains("oracle.datafile.size")) {
	                  fileContent.set(i, "oracle.datafile.size=" + datafileSize);
	               }
	               if (lineContent.contains("jasper.import.filename")) {
	                  fileContent.set(i, "jasper.import.filename=" + importFilename);
	               }
	               if (lineContent.contains("jasper.import.path")) {
	                  fileContent.set(i, "jasper.import.path=" + importPath);
	               }
	               if (lineContent.contains("jasper.import.directory")) {
	                  fileContent.set(i, "jasper.import.directory=" + importDirectory);
	               }
	            }

	            Files.write(path, fileContent, StandardCharsets.UTF_8);
	         } catch (IOException ex) {
	            logger.severe("Exception caught when running MtxDbInstall " + ex);
	         }
	      } else {
	         logger.severe("Could not find properties file for install: " + propertiesFilePath);
	      }
	   }
	   
	   public boolean runDbInstall() {
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

	      script = new File(deliveryPath.concat(File.separator + "mx-database" + File.separator + "install" + File.separator + "datapump-create-jasper-user.") + (Helper.IS_WINDOWS ? "bat" : "sh"));

	      if (!Helper.isPathValid(script.getAbsolutePath()) || !script.isFile())  {
	         logger.info("No Maintenix Report DB install to be performed");
	         return false;
	      }

	      try {
	         logger.info("Running Maintenix Report database install, logs location: "+ logFilePath);
	         
	         updateConfigFile();
	         
	         Map<String, String> envs = new HashMap<String, String>();
	         // NOPAUSE is very important to set in the environment as Maintenix installation scrips will 
	         // pause for key entry forever at the end of execution if it is not set.
	         envs.put("_NOPAUSE", "TRUE");
	         ProcessResult result = Helper.runProcessWithResult(envs, deliveryPath.concat(File.separator + "mx-database" + File.separator + "install"), false, directive, extra, script.getAbsolutePath());
	         if (result.getProcess().exitValue() == 0) {
	            return true;
	         } else {
	        	 if(result.getResult() != null && result.getResult().contains("MX: schema exists, error out")) {
	          	   logger.info("User \"" + schemaUsername + "\" already exists, skip Maintenix Report DB install.");
	          	} else {
	               logger.severe("Failed to run Maintenix Report DB installer " + result.getResult());
	          	}
	         }
	      } catch (IOException | InterruptedException e) {
	         logger.severe("Exception caught when running MtxReportDbInstall " + e);
	      }
	      return false;      
	   }
	   
	   public boolean runDbDrop() {
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

         script = new File(deliveryPath.concat(File.separator + "mx-database" + File.separator + "install" + File.separator + "datapump-drop-jasper-user.") + (Helper.IS_WINDOWS ? "bat" : "sh"));

         if (!Helper.isPathValid(script.getAbsolutePath()) || !script.isFile())  {
            logger.info("No Maintenix Report DB drop to be performed");
            return false;
         }

         try {
            logger.info("Running Maintenix Report database drop, logs location: "+ logFilePath);
            
            updateConfigFile();
            
            Map<String, String> envs = new HashMap<String, String>();
            // NOPAUSE is very important to set in the environment as Maintenix installation scrips will 
            // pause for key entry forever at the end of execution if it is not set.
            envs.put("_NOPAUSE", "TRUE");
            ProcessResult result = Helper.runProcessWithResult(envs, deliveryPath.concat(File.separator + "mx-database" + File.separator + "install"), false, directive, extra, script.getAbsolutePath());
            if (result.getProcess().exitValue() == 0) {
               return true;
            } else {
               logger.severe("Failed to run Maintenix Report DB drop " + result.getResult());
            }   
         } catch (IOException | InterruptedException e) {
            logger.severe("Exception caught when running MtxReportDbInstall " + e);
         }
         return false;      
      }
}
