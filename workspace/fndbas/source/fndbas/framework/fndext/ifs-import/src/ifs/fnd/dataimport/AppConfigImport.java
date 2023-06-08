/*
 *                 IFS Research & Development
 *
 *  This program is protected by copyright law and by international
 *  conventions. All licensing, renting, lending or copying (including
 *  for private use), and all other use of the program, which is not
 *  expressively permitted by IFS Research & Development (IFS), is a
 *  violation of the rights of IFS. Such violations will be reported to the
 *  appropriate authorities.
 *
 *  VIOLATIONS OF ANY COPYRIGHT IS PUNISHABLE BY LAW AND CAN LEAD
 *  TO UP TO TWO YEARS OF IMPRISONMENT AND LIABILITY TO PAY DAMAGES.
 *
 * ==================================================================================
 * File:             AppConfigImport.java
 *
 *
 * ==================================================================================
 *  
 */
package ifs.fnd.dataimport;

//NOTE All stuff in this task could be handled without IFS JSF classes if we just have the appowner password and use java.sql 
import java.io.*;
import java.util.*;
import java.io.File;
import java.io.FileInputStream;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.Element;

import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AppConfigImport {

   /* Mandatory setting for connection string */
   private String connectstring = null;
   /* Mandatory setting for Application Owner User Name*/
   private String aousername = null;
   /* Mandatory setting for Application Owner Password */
   private String aopassword = null;
   /* Mandatory file path which reflect the delivery path */
   private String deliveryDir = null;
   /* None mandatory file path to the debug file */
   private String debugFilePath = null;
   /* Import log from the ACP publish */
   private String importLog;
   
   private OutputMessageStream logInfoStream = null;

   Connection con = null;
   /* Publish set to true as default. All items in the ACP will be published during the installation */
   private boolean publish = true;
   private boolean registeredConfigurationsExist = false;
   private boolean error = false;

   private static final String stmt_ComponentInstalled
           = " SELECT count(*) \n"
           + " FROM  module \n"
           + " WHERE module = :Module";
   //SOLSETFW
   private static final String stmt_InterfaceInstalled
           = "   SELECT count(*) "
           + "   FROM dictionary_sys_method_active \n"
           + "   WHERE package_name  = UPPER(:PackageName) \n"
           + "   AND method_name = INITCAP(:MethodName)";

   private static final String stmt_RegisterPackage
           = "DECLARE \n"
           + "BEGIN \n"
           + "   App_Config_Import_API.Register_Bulk_Import(:ImportId,:BulkImportId,:Xml,:TempPackage);\n"
           + "END;";
   private static final String stmt_RegisterItem
           = "DECLARE \n"
           + "BEGIN \n"
           + "   App_Config_Item_Import_API.Register_Item(:ImportItemId, :ImportId, :ItemType,:Xml, :fileName);\n"
           + "END;";

   private static final String stmt_ImportBulk
           = "DECLARE \n"
           + "BEGIN \n"
           + "   App_Config_Import_API.Import_Bulk(:Log_clob_, :Successful, :BulkImportId,:Publish);\n"
           + "END;";
   
   /**
    * Creates a new instance of DbMergeFilesTask
    * @param connectstring
    * @param aousername
    * @param aopassword
    * @param deliveryDir
    * @param debugFilePath
    */
   public AppConfigImport(String connectstring, String aousername, String aopassword, String deliveryDir, String debugFilePath) {
      this.connectstring = connectstring;
      this.aousername = aousername; 
      this.aopassword = aopassword;
      this.deliveryDir = deliveryDir;
      this.debugFilePath = debugFilePath + "/" + "import_application_configurations.log";
   }      

   public void execute() throws ImportException {
      try {
         /*  Validatate prerequisites */
         validateProperties();

         createLog(debugFilePath);
         logInfo("### Start ACP Import ###");
         logNewLine();

         /*  Conneting to database */
         logInfo("Trying to connect to the database");
         initializeDbConnection();
         logInfo("Connect successfull");

         /*  Validateate DB API */
         validateDbApi();
         
         java.io.File installationDirFile = new java.io.File(deliveryDir);
         if (!installationDirFile.exists()) {
            logInfo("WARNING: " + installationDirFile + " does not exist. No Application Configurations found.");
            return;
         }

         logInfo("### App Config initializing... ###");

         /* Import App Config initialization */
         
         java.io.File itemsDirFile = new java.io.File(installationDirFile, "Items");
         String bulkImportId = java.util.UUID.randomUUID().toString();

         error = readAndRegisterFiles(bulkImportId, installationDirFile, itemsDirFile);
         
         if (!error) {
            logInfo("### Importing... ###");
         }
         if (!error && registeredConfigurationsExist) {
            error = doImport(bulkImportId, publish);
         }

         /* commit/rollback and close the connection */

         if (!error && registeredConfigurationsExist) {
            closeDbConnection(con, true);
         } else {
            closeDbConnection(con, false);
         }

      } catch (Exception e) {
         logInfo("### Import failed ###" + e.getMessage());
         error = true;
         e.printStackTrace(System.out);
         logInfo("### Exception is thrown msg: " + e.getMessage());
         logInfo("### Cause: " + e.getCause().toString());
         throw new ImportException(e.getMessage());
      } finally {
         logNewLine();
         if (error) {
            logInfoFail();
         } else {
            if (registeredConfigurationsExist) {
               logInfoSuccess();
            } else {
               logInfoSkipped();
            }
         }
         logNewLine();
         if (importLog != null && !importLog.isEmpty()) {
            logInfo("### IMPORT DETAILS ### \r\n\r\n" + importLog.replaceAll("\n", "\r\n"));
         }
         if (error) {
            throw new ImportException("WARNING: IMPORT: Error has occurred while importing Application Configuration data (See log file).");
         }
         if (con != null) {
            try {
               con.rollback();
               con.close();
            } catch (SQLException e) {
            }
         }
         closeLog();
      }
   }

   private void validateDbApi() throws Exception {
      if (!isFndcobInstalled()) {
         throw new ImportException("ERROR: Application Extensibility that includes FNDCOB must be installed to import Application Configurations");
      }

      if (!isImportInterfaceInstalled()) {
         throw new ImportException("ERROR: Application Configuration Import is not supported.");
      }
   }

   static void closeDbConnection(Connection con, boolean isCommit) throws Exception {
      if (isCommit) {
         con.commit();
      } else {
         con.close();
      }
   }

   private void initializeDbConnection() throws Exception {
      Properties props = new Properties();
      props.setProperty("user", aousername);
      props.setProperty("password", aopassword);
      try {
         con = DriverManager.getConnection(connectstring, props);
         con.setAutoCommit(false);

         if (con.isClosed()) {
            throw new ImportException("ERROR:No connection to the database could be established (1)! Connect string " + connectstring);
         }
      } catch (Exception e) {
         throw new ImportException("ERROR:No connection to the database could be established (2)! Connect string " + connectstring);
      }
   }

   private boolean isFndcobInstalled() throws SQLException {
      PreparedStatement ps = con.prepareStatement(stmt_ComponentInstalled);
      ps.setString(1, "FNDCOB");

      ResultSet rs = ps.executeQuery();
      return rs.next() && rs.getInt(1) > 0;
   }

   private boolean isImportInterfaceInstalled() throws SQLException {
      String packageName = "APP_CONFIG_IMPORT_API";
      String methodName = "Register_Bulk_Import";

      PreparedStatement ps = con.prepareStatement(stmt_InterfaceInstalled);
      ps.setString(1, packageName);
      ps.setString(2, methodName);

      ResultSet rs = ps.executeQuery();
      return rs.next() && rs.getInt(1) > 0;
   }

   private boolean doImport(String bulkImportId, boolean publish) throws Exception {

      String successful;
      String publishText;

      if (publish) {
         publishText = "TRUE";
      } else {
         publishText = "FALSE";
      }

      CallableStatement pstmt = con.prepareCall(stmt_ImportBulk);
      pstmt.registerOutParameter(1, java.sql.Types.CLOB);
      pstmt.registerOutParameter(2, java.sql.Types.VARCHAR);
      pstmt.setString(3, bulkImportId);
      pstmt.setString(4, publishText);
      pstmt.execute();

      importLog = pstmt.getString(1);
      successful = pstmt.getString(2);
      return !successful.equalsIgnoreCase("TRUE");

   }

   private String registerImport(String bulkImportId, String xmlString) throws Exception {
      String tempPackage;
      if (xmlString == null || xmlString.isEmpty()) {
         tempPackage = "TRUE";
      } else {
         tempPackage = "FALSE";
      }
      Clob fileClob = con.createClob();
      fileClob.setString(1, xmlString);

      CallableStatement pstmt = con.prepareCall(stmt_RegisterPackage);
      pstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
      pstmt.setString(2, bulkImportId);
      pstmt.setClob(3, fileClob);
      pstmt.setString(4, tempPackage);
      pstmt.execute();

      registeredConfigurationsExist = true;
      return pstmt.getString(1);
   }

   private String registerItem(String importId, String xmlString, String itemType, String fileName) throws Exception {

      Clob fileClob = con.createClob();
      fileClob.setString(1, xmlString);

      CallableStatement pstmt = con.prepareCall(stmt_RegisterItem);
      pstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
      pstmt.setString(2, importId);
      pstmt.setString(3, itemType);
      pstmt.setClob(4, fileClob);
      pstmt.setString(5, fileName);
      pstmt.execute();
      return pstmt.getString(1);
   }

   private void registerItems(List importedFiles, Document doc, String tag, File itemsDirFile, String importId) throws Exception {
      NodeList items = doc.getElementsByTagName(tag);
      if (("ITEMS_ROW").equalsIgnoreCase(tag)) {
         logInfo("Package includes " + items.getLength() + " items");
      }
      for (int i = 0; i < items.getLength(); i++) {

         Node nNode = items.item(i);
         if (nNode.getNodeType() == Node.ELEMENT_NODE) {

            Element eElement = (Element) nNode;
            String fileName = eElement.getElementsByTagName("FILENAME").item(0).getTextContent();
            String itemType = eElement.getElementsByTagName("TYPE").item(0).getTextContent();

            try {
               File itemFile = new java.io.File(itemsDirFile, fileName);
               if (itemFile.exists()) {
                  registerItem(importId, readFile(itemFile), itemType, fileName);
               } else {
                  throw new FileNotFoundException("File not found: " + fileName);
               }
            } catch (FileNotFoundException e) {
               logInfo("Error: File not found: " + fileName); //package is not complete in delivery 
               throw new ImportException("ERROR:Application configuration file cannot be found"); //Todo ignore and skip package ??
            } finally {
               importedFiles.add(fileName);
            }
         }
      }
   }

   private void register(List importedFiles, String bulkImportId, File itemsDirFile, String xmlString) throws Exception {

      InputStream is = new ByteArrayInputStream(xmlString.getBytes("UTF-8"));

      //open and parse the package file
      DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
      DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
      Document doc = documentBuilder.parse(is);
      doc.getDocumentElement().normalize();

      String importId = registerImport(bulkImportId, xmlString);

      //Registers all Items
      registerItems(importedFiles, doc, "ITEMS_ROW", itemsDirFile, importId);
      //Registers all additional items , mainly additional views for custom fields 
      registerItems(importedFiles, doc, "ADDITIONAL_ITEM", itemsDirFile, importId);
   }

   private boolean readAndRegisterFiles(String bulkImportId, File installtionDirFile, File itemsDirFile) throws Exception {
      boolean error = false;
      List importedItemFiles = new ArrayList();

      //register packages including items
      String[] suffixtypes = {".XML"};
      java.io.File[] packageFiles = installtionDirFile.listFiles(new SuffixFilters(suffixtypes));
      logInfo("### Found " + packageFiles.length + " packages ###");

      for (File packageFile : packageFiles) {
         try {
            logNewLine();
            logInfo("Reading: " + packageFile.getName());
            register(importedItemFiles, bulkImportId, itemsDirFile, readFile(packageFile));
         } catch (Exception e) {
            logInfo("Error processing : " + packageFile.getName()); //mark as error - nothing will get imported, continue read to get all problems in the log
            logInfo(e.getMessage());
            error = true;
         }
      }

      logNewLine();

      //register items not delivered in a package
      boolean singleImportHeaderCreated = false;
      if (itemsDirFile.exists()) {
         java.io.File[] itemFiles = itemsDirFile.listFiles(new SuffixFilters(suffixtypes));

         String importId = null;
         for (File itemFile : itemFiles) {
            try {
               if (!importedItemFiles.contains(itemFile.getName())) {
                  if (!singleImportHeaderCreated) {
                     //First Single Item Found create header and show message
                     logInfo("### Reading Items not delivered in a package ###"); // show single import message only if something is found
                     importId = registerImport(bulkImportId, null);
                     singleImportHeaderCreated = true;
                  }
                  logInfo("Reading : " + itemFile.getName());
                  String xmlString = readFile(itemFile);
                  String itemType = getItemType(xmlString);
                  registerItem(importId, xmlString, itemType, itemFile.getName());
               }
            } catch (Exception e) {
               logInfo("Error processing : " + itemFile.getName());
               logInfo(e.getMessage());
               error = true;
            }
         }
      }

      return error;
   }

   /* Util Methods */
   
   private void validateProperties() throws ImportException {
      checkPropertySet("Connectstring", connectstring);
      checkPropertySet("Application Owner UserName", aousername);
      checkPropertySet("Application Owner Password", aopassword);
      checkPropertySet("Path to Application Configuration", deliveryDir);
   }

   private void checkPropertySet(String name, String value) throws ImportException {
      if (value == null || value.length() == 0) {
         throw new ImportException("ERROR:Property " + name + " is not set.");
      }
   }

   private String getItemType(String xmlString) throws Exception {
      try {
         InputStream is = new ByteArrayInputStream(xmlString.getBytes("UTF-8"));

         //open and parse the package file        
         DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
         DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
         Document doc = documentBuilder.parse(is);
         doc.getDocumentElement().normalize();

         NodeList nodes = doc.getElementsByTagName("TYPE");
         return nodes.item(0).getTextContent();
      } catch (Exception e) {
         logInfo("Cannot read item type from file");
         throw e;
      }
   }

   private String readFile(File f) throws Exception {
      FileInputStream fi = new FileInputStream(f);
      StringBuilder sb = new StringBuilder();

      while (true) {
         int cnt = fi.available();
         if (cnt == 0) {
            break;
         }
         byte[] b = new byte[cnt];
         int res = fi.read(b);
         String s = new String(b, 0, res, "UTF-8");
         sb.append(s);
         b = null;
         s = null;
      }
      fi.close();
      return (sb.toString());
   }

   /* Logging */
   
   private void createLog(String logInfoFilePath) throws Exception {
      if (logInfoFilePath != null) {
         try {
            File file = new File(logInfoFilePath);
            file.delete();
            file.createNewFile();
            logInfoStream = new OutputMessageStream(new FileOutputStream(file, true));
            System.setErr(logInfoStream);
         } catch (Exception e) {
            throw new Exception(e);
         }
      }
   }

   private void closeLog() {
      if (logInfoStream != null) {
         logInfoStream.close();
      }
   }

   private void logInfo(String msg) {
      if (logInfoStream != null) {
         logInfoStream.println(msg);
      }
   }

   private void logNewLine() {
      logInfo("------------------------------------------------------------");
   }

   private void logInfoSkipped() {
      if (logInfoStream != null) {
         logNewLine();
         logNewLine();
         logInfoStream.printEr("######################################################################################");
         logInfoStream.printEr("#                                                                                    #");
         logInfoStream.printEr("#  No Application Configurations found.                                              #");
         logInfoStream.printEr("#                                                                                    #");
         logInfoStream.printEr("######################################################################################");
         logNewLine();
         logNewLine();
      }
   }

   private void logInfoSuccess() {
      if (logInfoStream != null) {
         logNewLine();
         logNewLine();
         logInfoStream.printEr("###################################################################");
         logInfoStream.printEr("#                                                                 #");
         logInfoStream.printEr("#  All Application Configurations are imported SUCCESSFULLY.      #");
         logInfoStream.printEr("#                                                                 #");
         logInfoStream.printEr("###################################################################");
         logNewLine();
         logNewLine();
      }
   }

   private void logInfoFail() {
      if (logInfoStream != null) {
         logNewLine();
         logNewLine();
         logInfoStream.printEr("######################################################################################");
         logInfoStream.printEr("#                                                                                    #");
         logInfoStream.printEr("#  Failed to import Application Configurations!                                      #");
         logInfoStream.printEr("#                                                                                    #");
         logInfoStream.printEr("######################################################################################");
         logNewLine();
         logNewLine();
      }
   }

   /* Private Classes */
   
   private class SuffixFilters implements FileFilter {

      private String[] suff;
      private boolean match;

      public SuffixFilters(String[] suff) {
         this.suff = suff;
      }

      @Override
      public boolean accept(java.io.File f) {
         if (f.isDirectory()) {
            return false;
         }
         match = false;
         int i = 0;
         do {
            match = f.getPath().toUpperCase().endsWith(suff[i]);
            i++;
         } while (!match && i < suff.length);

         return match;
      }
   }

   private class OutputMessageStream extends java.io.PrintStream {

      public OutputMessageStream(FileOutputStream fos) {
         super(fos);
      }

      public OutputMessageStream(FileOutputStream fos, boolean autoFlush) {
         super(fos, autoFlush);
      }

      public void print(String msg) {
         super.print(msg);
      }

      public void println(String msg) {
         Calendar calendar = Calendar.getInstance();
         java.util.Date date = calendar.getTime();
         super.println("[" + date.toString() + "]  " + msg);
      }

      public void printEr(String msg) {
         super.println(msg);
      }

      public void newLine() {
         super.println("");
      }

      public void printlogInfo(String msg) {
         Calendar calendar = Calendar.getInstance();
         java.util.Date date = calendar.getTime();
         super.print("[" + date.toString() + " ]" + msg + "\r\n");
      }
   }
}
