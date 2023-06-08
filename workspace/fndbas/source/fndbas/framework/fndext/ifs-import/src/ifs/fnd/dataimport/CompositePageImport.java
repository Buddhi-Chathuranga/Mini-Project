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
 * File:             CompositePageImport.java
 *
 *
 * ==================================================================================
 *   DAATLK 2014-Mar-21 - Created.
 *   CHAALK 2020-Feb-03 - Modified to remove sta jar useage and make import depending on folder exists rather than selecting from installer
 */
package ifs.fnd.dataimport;

import java.io.*;
import java.util.*;
import org.w3c.dom.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.stream.*;
import javax.xml.transform.dom.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;

public class CompositePageImport {
   /* Mandatory file path witch reflect effective build Root directory */

   private String cpDir = null;
   private boolean importCustomPages = true;
   private boolean importCustomDataSources = true;
   private boolean importCustomElements = true;
   private String loginId;
   private String password;
   private String connectString;
   /* None mandatory file path to the debug file */
   private String debugFilePath = null;
   private OutputMessageStream debugStream = null;
   Connection conn = null;
   
   private static final String stmt_SAVEDATASOURCE =
           "DECLARE \n"
           + "BEGIN \n"
           + "	Composite_Page_Repository_API.Import_Data_Source(:Id,:Datasource);\n"
           + "END;";
   private static final String stmt_SAVEELEMENT =
           "DECLARE \n"
           + "BEGIN \n"
           + "	Composite_Page_Repository_API.Import_Element(:Id,:Element);\n"
           + "END;";
   private static final String stmt_SAVEPAGE =
           "DECLARE \n"
           + "BEGIN \n"
           + "	Composite_Page_Repository_API.Import_Page(:Id,:Page);\n"
           + "END;";

      /**
    * Creates a new instance of DbMergeFilesTask
    * @param connectString
    * @param loginId
    * @param password
    * @param cpDir
    * @param debugFilePath
    */
   public CompositePageImport(String connectString, String loginId, String password, String cpDir, String debugFilePath) {
      this.connectString = connectString;
      this.loginId = loginId; 
      this.password = password;
      this.cpDir = cpDir;
      this.debugFilePath = debugFilePath + "/" + "import_lobbyItems.log";
   }
      
   public void execute() throws ImportException {
      boolean error1 = false;
      boolean error2 = false;
      boolean error3 = false;

      try {
         if (debugFilePath != null) {
            File file = new File(debugFilePath);
            debugStream = new OutputMessageStream(new FileOutputStream(file, true));
            System.setErr(debugStream);
         }
         //-------------------------------------
         //  Validatate prerequisites
         //-------------------------------------
         if (cpDir == null || (cpDir != null && cpDir.length() == 0)) {
            throw new ImportException("WARNING: IMPORT: Mandatory lobby path is null.");
         }
         //---------------------------------------
         //  Create the database application
         //---------------------------------------
         if (debugFilePath != null) {
            File file = new File(debugFilePath);
            debugStream = new OutputMessageStream(new FileOutputStream(file, true));
            System.setErr(debugStream);
            logNewLine();
         }
         java.io.File cpDirFile = new java.io.File(cpDir);
         if (!cpDirFile.exists()) {
            logInfo("WARNING: " + cpDir + " does not exist");
            return;
         }
         //Import items if there are items in the folders
         setImportPages(cpDir);
         setImportElements(cpDir);
         setImportDataSources(cpDir);         
         
         if ((importCustomDataSources)||(importCustomElements)||(importCustomPages)){
            logInfo("Trying to connect to the database");
            Properties props = new Properties();
            props.setProperty("user", loginId);
            props.setProperty("password", password);
            conn = DriverManager.getConnection(connectString, props);
            conn.setAutoCommit(true);
            try {
               if (conn.isClosed()) {
                  throw new ImportException("ERROR:No connection to the database could be established (1)! Connect string " + connectString);
               }
            }
            catch (Exception e) {
               throw new ImportException("ERROR:No connection to the database could be established (2)! Connect string " + connectString);
            }
            logInfo("Connected successfull");
         }

         logInfo("### Lobby initializing... ###");
         //-----------------------------------------
         // Import IFS Lobby data sources
         //-----------------------------------------
         if (importCustomDataSources) {
            error1 = importDataSources();
         }
         //-----------------------------------------
         // Import IFS Lobby elements
         //-----------------------------------------
         if (importCustomElements) {
            error2 = importElements();
         }
         //-----------------------------------------
         // Import IFS Lobby pages
         //-----------------------------------------
         if (importCustomPages) {
            error3 = importPages();
         }
      } catch (Exception e) {
         logInfo("### Import failed ###" + e.toString());
         if(conn!=null) {
            logInfo(e.getCause().getMessage());
         }
         throw new ImportException(e.getMessage());
      } finally {
         if(conn!=null) {
            try {
               conn.close();
               conn = null;
               logNewLine();
               logInfo("Database connection successfull closed");
            }
            catch (Exception e) {
               logInfo("Error closing database connection.");
               logInfo("Error: " + e.getMessage());
            }
         }
         
         if (error1 || error2 || error3) {
            logInfoFail();
            throw new ImportException("WARNING: IMPORT: Error has occurred while importing Lobby data (See log file).");
         } else {
            logInfoSuccess();
         }
         if (debugStream != null) {
            debugStream.close();
         }
      }
   }

   private boolean importElements() {
      boolean error = false;
      logNewLine();
      logInfo("### Importing Elements... ###");
      try {

         java.io.File dirFile = new java.io.File(cpDir + "//elements");
         if (!dirFile.exists()) {
            logInfo("WARNING: " + dirFile + " does not exist");
            error = true;
         } else {
            String[] suffixtypes = {".XML"};
            java.io.File[] files = dirFile.listFiles(new SuffixFilters(suffixtypes));

            logInfo("### Found " + files.length + " element(s) ###");
            for (int i = 0; i < files.length; i++) {
               try {
                  saveElement(readFile(files[i]));
               } catch (Exception e) {
                  logInfo("Error importing: " + files[i].getName());
                  logInfo(e.getMessage());
                  error = true;
               }

            }
         }
      } catch (Exception e) {
         error = true;
      }
      return error;
   }

   private boolean importPages() {
      boolean error = false;
      logNewLine();
      logInfo("### Importing Pages... ###");
      try {

         java.io.File dirFile = new java.io.File(cpDir + "//pages");
         if (!dirFile.exists()) {
            logInfo("WARNING: " + dirFile + " does not exist");
            error = true;
         } else {
            String[] suffixtypes = {".XML"};
            java.io.File[] files = dirFile.listFiles(new SuffixFilters(suffixtypes));

            logInfo("### Found " + files.length + " page(s) ###");
            for (int i = 0; i < files.length; i++) {
               try {
                  savePage(readFile(files[i]));
               } catch (Exception e) {
                  logInfo("Error importing: " + files[i].getName());
                  logInfo(e.getMessage());
                  error = true;
               }

            }
         }
      } catch (Exception e) {
         error = true;
      }
      return error;
   }

   private boolean importDataSources() {
      boolean error = false;
      logNewLine();
      logInfo("### Importing Data Sources... ###");
      try {

         java.io.File dirFile = new java.io.File(cpDir + "//datasources");
         if (!dirFile.exists()) {
            logInfo("WARNING: " + dirFile + " does not exist");
            error = true;
         } else {
            String[] suffixtypes = {".XML"};
            java.io.File[] files = dirFile.listFiles(new SuffixFilters(suffixtypes));

            logInfo("### Found " + files.length + " data source(s) ###");
            for (int i = 0; i < files.length; i++) {
               try {
                  saveDataSource(readFile(files[i]));
               } catch (Exception e) {

                  logInfo("Error importing: " + files[i].getName());
                  logInfo(e.getMessage());
                  error = true;
               }

            }
         }
      } catch (Exception e) {
         error = true;
      }
      return error;
   }

   private void savePage(String pageXML) throws Exception {

      String id = null;
      Document doc = null;

      InputStream is = new ByteArrayInputStream(pageXML.getBytes("UTF-8"));

      try {
         doc = XmlUtil.parseXml(is);
      } catch (ParserConfigurationException e) {
         throw new Exception(e.getMessage(), e);
      }

      Element rootElement = doc.getDocumentElement();
      NodeList list = rootElement.getElementsByTagName("PageId");
      if (list != null && list.getLength() > 0) {
         id = XmlUtil.getNodeText(list.item(0));
      }
      CallableStatement pstmt = null;
      try{
         pstmt = conn.prepareCall(stmt_SAVEPAGE);
         pstmt.setString(1, id);
         pstmt.setClob(2, new StringReader(pageXML));
         pstmt.execute();     
      }
      finally{
         closeStatement(pstmt, "Save Page"); 
      }
   }

   private String removeDeclaration(Document doc) throws TransformerException {
      TransformerFactory tf = TransformerFactory.newInstance();

      Transformer transformer = tf.newTransformer();

      transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");

      StringWriter writer = new StringWriter();

      transformer.transform(new DOMSource(doc), new StreamResult(writer));

      return writer.getBuffer().toString();
   }

   private void saveElement(String elementXML) throws Exception {
      String id =  null;
      Document doc = null;
      InputStream is = new ByteArrayInputStream(elementXML.getBytes("UTF-8"));

      try {
         doc = XmlUtil.parseXml(is);
         elementXML = removeDeclaration(doc);
      } catch (ParserConfigurationException e) {
         throw new Exception(e.getMessage(), e);
      }
      Element rootElement = doc.getDocumentElement();
      NodeList list = rootElement.getElementsByTagName("ID");
      if (list != null && list.getLength() > 0) {
         id = XmlUtil.getNodeText(list.item(0));
      }
      CallableStatement pstmt = null;
      try{
         pstmt = conn.prepareCall(stmt_SAVEELEMENT);
         pstmt.setString(1, id);
         pstmt.setClob(2, new StringReader(elementXML));
         pstmt.execute();    
      }
      finally{
         closeStatement(pstmt, "Save Element"); 
      }
   }

   private void saveDataSource(String dataSourceXML) throws Exception {
      String id = null;
      Document doc = null;
      InputStream is = new ByteArrayInputStream(dataSourceXML.getBytes("UTF-8"));

      try {
         doc = XmlUtil.parseXml(is);
         dataSourceXML = removeDeclaration(doc);
      } catch (ParserConfigurationException e) {
         throw new Exception(e.getMessage(), e);
      }

      Element rootElement = doc.getDocumentElement();
      NodeList list = rootElement.getElementsByTagName("ID");
      if (list != null && list.getLength() > 0) {
         id = XmlUtil.getNodeText(list.item(0));
      }
      CallableStatement pstmt =  null;
      try{
         pstmt = conn.prepareCall(stmt_SAVEDATASOURCE);
         pstmt.setString(1, id);
         pstmt.setClob(2, new StringReader(dataSourceXML));
         pstmt.execute();
      }
      finally{
         closeStatement(pstmt, "Save Data Source");
      }
   }

   private void logNewLine() {
      if (debugStream != null) {
         debugStream.newLine();
      }
   }

   private void logInfoSuccess() {
      if (debugStream != null) {
         logNewLine();
         logNewLine();
         debugStream.printEr("####################################################");
         debugStream.printEr("#                                                  #");
         debugStream.printEr("#  All Lobby items were imported SUCCESSFULLY.     #");
         debugStream.printEr("#                                                  #");
         debugStream.printEr("####################################################");
      }
   }

   private void logInfoFail() {
      if (debugStream != null) {
         logNewLine();
         logNewLine();
         debugStream.printEr("#################################################################");
         debugStream.printEr("#                                                               #");
         debugStream.printEr("#  Some Lobby items FAILED to import. See log for  ERRORS.      #");
         debugStream.printEr("#                                                               #");
         debugStream.printEr("#################################################################");
      }
   }
   
   private void closeStatement(CallableStatement pstmt,String message){
     if (pstmt!=null){
        try{
           pstmt.close();
           pstmt = null;
        }
        catch(Exception e){
           logInfo("Error closing statement at " + message);
           logInfo("Error: " + e.getMessage());                                 
        }
     }
   }

   public void setImportPages(String cpDir) {
      java.io.File dirFile = new java.io.File(cpDir + "//pages");
      if (!dirFile.exists()) {
         this.importCustomPages = false;
         logInfo(cpDir + "/pages folder does not exist");
      }
      else {
         String[] suffixtypes = {".XML"};
         java.io.File[] files = dirFile.listFiles(new SuffixFilters(suffixtypes));
         this.importCustomPages = files.length > 0 ? true : false;
         if (this.importCustomPages == false){
            logInfo("No pages were found to be imported under folder " + cpDir + "/pages"); 
         }
      }
   }

   public void setImportElements(String cpDir) {
      java.io.File dirFile = new java.io.File(cpDir + "//elements");
      if (!dirFile.exists()) {
         this.importCustomElements = false;
         logInfo(cpDir + "/elements folder does not exist");
      }
      else{
         String[] suffixtypes = {".XML"};
         java.io.File[] files = dirFile.listFiles(new SuffixFilters(suffixtypes));
         this.importCustomElements = files.length > 0 ? true : false;
         if (this.importCustomElements == false){
            logInfo("No elements were found to be imported under folder " + cpDir + "/elements"); 
         }
         
      }
   }

   public void setImportDataSources(String cpDir) {
      java.io.File dirFile = new java.io.File(cpDir + "//datasources");
      if (!dirFile.exists()) {
         this.importCustomDataSources = false;
         logInfo(cpDir + "/datasources folder does not exist");
      }
      else{
         String[] suffixtypes = {".XML"};
         java.io.File[] files = dirFile.listFiles(new SuffixFilters(suffixtypes));  
         this.importCustomDataSources = files.length > 0 ? true : false;
         if (this.importCustomDataSources == false){
            logInfo("No data sources were found to be imported under folder " + cpDir + "/datasources"); 
         }
         
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

   private void logInfo(String msg) {
      if (debugStream != null) {
         debugStream.println(msg);
      }
   }

   public void logDebug(String msg) {
      if (debugStream != null) {
         debugStream.printDebug(msg);
      }
   }

   private class XMLFilter implements FileFilter {

      @Override
      public boolean accept(File f) {
         String name = f.getName();
         if (name != null) {
            return name.toLowerCase().endsWith(".xml");
         }
         return false;
      }

      public String getDescription() {
         return "Lobby Pages(*.xml)";
      }
   }

   private class SuffixFilter implements FileFilter {

      private String suff;

      public SuffixFilter(String suff) {
         this.suff = suff;
      }

      @Override
      public boolean accept(java.io.File f) {
         if (f.isDirectory()) {
            return false;
         }
         return (f.getPath().toUpperCase().endsWith(suff));
      }
   }

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

      @Override
      public void print(String msg) {
         super.print(msg);
      }

      @Override
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

      public void printDebug(String msg) {
         Calendar calendar = Calendar.getInstance();
         java.util.Date date = calendar.getTime();
         super.print("[" + date.toString() + " ]" + msg + "\r\n");
      }
   }
}
