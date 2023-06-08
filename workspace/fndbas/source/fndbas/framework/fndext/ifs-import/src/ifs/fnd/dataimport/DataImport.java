/*=====================================================================================
 * DataImport.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * xxxxxx      2020-11-30  StDaFi     Import Data
 * ====================================================================================
 */
package ifs.fnd.dataimport;

import java.io.File;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.Format;
import java.text.SimpleDateFormat;

/**
 * DataImport class for PlSqlFileReader
 * @author mabose
 */
public class DataImport {
   
   /* deliveryPath, path to the build_home or delivery */
   private String deliveryPath = "";   
   /* UserName to application owner */
   private String userName = "";
   /* Password to application owner */
   private String password = "";
   /* ConnectString to access the database */
   private String connectString = "";
   /* Log file path to place log files */
   private String logFilePath = "";
   
   //Location of data to import
   private final String appconfig = "/server/appconfig";
   private final String lobby = "/server/lobby";
   
   private final String translation = "/server/translation";
   private String transRuntime = "Y";
   private String transImportAttributes = "Y";
   private String transImportTranslations = "Y";
            
   private final String lob = "/server/lob";
   private final String reports = "/server/reports";   
   private final String connect_config = "/server/connect_config"; 
   
   /**
    * Creates a new instance of DbMergeFilesTask
   * @param args
    */
   public DataImport(String[] args) {
      parseArgs(args);
   }
   
    /**
     * Main
    * @param args

    * @param args */
   public static void main(String[] args) {    
      if (args.length == 0) {
         System.out.println("ERROR:No parameters defined");
         System.exit(1);
      } 
      DataImport p = new DataImport(args);
      if (p.analyze())     
         p.run();
   }
   
   public void parseArgs(String[] args){
      String key = "";
      String value = "";
      for (String arg : args) {
         if (arg.contains("=")) {
            key = arg.substring(0,arg.indexOf("="));
            value = arg.substring(arg.indexOf("=")+1); 
            switch (key.toLowerCase()) {
               case "deliverypath":
                  deliveryPath = value;
                  break;      
               case "username":
                  userName = value;
                  break;                     
               case "password":
                  password = value;
                  break;   
               case "connectstring":
                  connectString = value;
                  break;
               case "logfilepath":
                  logFilePath = value;
                  break;
               //Translation   
               case "transruntime":
                  transRuntime = value;
                  break; 
               case "transimportattributes":
                  transImportAttributes = value;
                  break; 
               case "transimporttranslations":
                  transImportTranslations = value;
                  break; 
               default:
                 break; 
            }
         }
      }
   }

   public boolean analyze() {
      Boolean run = false;
      if (!"".equals(deliveryPath)) {
         String folder;
         folder = deliveryPath + appconfig;
         if (new File(folder).exists())
            run = true;
         folder = deliveryPath + lobby;
         if (new File(folder).exists()) 
            run = true; 
         folder = deliveryPath + translation;
         if (new File(folder).exists())
            run = true;  
         folder = deliveryPath + lob;
         if (new File(folder).exists())
            run = true;
         folder = deliveryPath + reports;
         if (new File(folder).exists())
            run = true;
         folder = deliveryPath + connect_config;
         if (new File(folder).exists())
            run = true;
      }
	  if (!run)
		  System.out.println("INFO:Nothing found to import from " + deliveryPath);
		  
      return run;
   }
   
   public void run() {
      try {
         if (!"".equals(userName) && !"".equals(password)) {
            checkParameterSet("connectString", connectString);
            checkParameterSet("logFilePath", logFilePath);
      
            //Verifying that connection is successfull. 
            //If this fails, no idea for each import job to try the same.
            System.out.println("INFO:Trying to connect to the database to import data as user " + userName);
            Connection con = null;
            con = DBConnection.openConnection(userName, password, connectString);
            try {
                if (con == null || con.isClosed()) {
                    throw new ImportException("ERROR:No connection to the database could be established (1)! Connect string " + connectString);
                }
            } catch (SQLException e) {
                throw new ImportException("ERROR:No connection to the database could be established (2)! Connect string " + connectString);
            }
            if (con != null) {
               try {
                  con.close();
               } catch (SQLException e) {
                  throw new ImportException("ERROR:" + e.getMessage());
               }
            }         
            System.out.println("INFO:Connection successfull");

            //Create log folder
            String logFolder = logFilePath + "/importData_" + getDbTimestamp();
            new File(logFolder).mkdirs();

            String folder; 
               //AppConfig
            folder = deliveryPath + appconfig;
            if (new File(folder).exists()) {
               System.out.println("INFO:Importing Application Configuration");
               try {
                  AppConfigImport ac = new AppConfigImport(connectString, userName, password, folder, logFolder);
                  ac.execute();
               } catch (ImportException ex) {
                  System.out.println(ex.getMessage());
               }
            } else {
               System.out.println("FINE:No Application Configuration found to import, folder " + folder + " not included.");
            }
               //Lobbies
            folder = deliveryPath + lobby;
            if (new File(folder).exists()) {
               System.out.println("INFO:Importing Lobby items");
               try {
                  CompositePageImport cp = new CompositePageImport(connectString, userName, password, folder, logFolder);
                  cp.execute();
               } catch (ImportException ex) {
                  System.out.println(ex.getMessage());
               }
            } else {
               System.out.println("FINE:No Lobby items found to import, folder " + folder + " not included.");
            }
            //Translations
            folder = deliveryPath + translation;
            if (new File(folder).exists()) {
               System.out.println("INFO:Importing Translations");
               try {
                  ImportTransFiles tf = new  ImportTransFiles(connectString, userName, password, folder, logFolder, transRuntime, transImportAttributes, transImportTranslations);
                  tf.execute();
               } catch (ImportException ex) {
                  System.out.println(ex.getMessage());
               }
            } else {
               System.out.println("FINE:No Translations found to import, folder " + folder + " not included.");
            }
               //Lobbies
            folder = deliveryPath + lob;
            if (new File(folder).exists()) {
               System.out.println("INFO:Importing Lob Files");
               try {
                  ImportLobFiles lf = new ImportLobFiles(connectString, userName, password, folder, logFolder);
                  lf.execute();
               } catch (ImportException ex) {
                  System.out.println(ex.getMessage());
               }
            } else {
               System.out.println("FINE:No Lob Files found to import, folder " + folder + " not included.");
            }
               //Reports
            folder = deliveryPath + reports;
            if (new File(folder).exists()) {
               System.out.println("INFO:Importing report images, signatures and logos");
               try {
                  ImportImages ii = new ImportImages(connectString, userName, password, folder, logFolder);
                  ii.execute();
               } catch (ImportException ex) {
                  System.out.println(ex.getMessage());
               }
               System.out.println("INFO:Configuring Reports");
               try {
                  ImportReports ir = new ImportReports(connectString, userName, password, folder, logFolder);
                  ir.execute();
               } catch (ImportException ex) {
                  System.out.println(ex.getMessage());
               }            
            } else {
               System.out.println("FINE:No Report Files found to import, folder " + folder + " not included.");
            }
               //Connect config
            folder = deliveryPath + connect_config;
            if (new File(folder).exists()) {
               System.out.println("INFO:Importing Connect Configuration files");
               try {
                  ImportConnectConfigs cc = new ImportConnectConfigs(connectString, userName, password, folder, logFolder);
                  cc.execute();
               } catch (ImportException ex) {
                  System.out.println(ex.getMessage());
               }
            } else {
               System.out.println("FINE:No Connect Configuration files found to import, folder " + folder + " not included.");
            }
         } else {
            System.out.println("WARNING:Skip import of data, username or password missing.");  
         }          
      } catch (ImportException ex) {
         System.out.println(ex.getMessage());
         System.exit(1);
      }
   }

   /**
    * Checks that a parameter has a value set.
    * @param   name  the name of the parameter. Used for displaying error message.
    * @param   value the value to check.
    * @throws  DbBuildException if the property has no value.
    */
   private void checkParameterSet(String name, String value) throws ImportException {
      if (value == null || value.length() == 0) {
         throw new ImportException("ERROR:Parameter " + name + " is not set, import of data skipped.");
      }
    } 
   
   private String getDbTimestamp() {
      Format formatter;
      formatter = new SimpleDateFormat("yyyyMMdd_HHmmss");
      java.util.Date date = new java.util.Date();
      return formatter.format(date);
   }
   
}
