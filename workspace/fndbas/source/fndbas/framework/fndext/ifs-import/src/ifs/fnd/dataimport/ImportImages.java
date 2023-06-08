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
 * ----------------------------------------------------------------------------
 * File        : ImportImages.java
 * Description : This will import images, logs and signatures used in report designer layouts in to the database.
 * Notes       :
 * ----------------------------------------------------------------------------
 * Created
 *   CHAALK 2019-OCT-24 - Created
 *   CHAALK 2020-Feb-03 - Close Db connections and make import depending on folder exists rather than selecting from installer
 *                        Remove impersonation as we login as appowner
 * ----------------------------------------------------------------------------
 *
 */
package ifs.fnd.dataimport;

import java.io.*;
import java.util.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;
import java.util.Properties;

public class ImportImages {
   
   private String debugFilePath = null;
   private String imageDir = null;
   /* Default is "false". Setting this to "true" implies setting failonerror to "false" */
   private boolean quiet = false;
   private boolean importRepImages = true;
   private String loginId;
   private String password;
   private String connectString;
   private OutputMessageStream debugStream = null;  
   
   Connection conn = null;
   
   private static final String stmt_IMPORTREPORTIMAGERS(){
      return
      "DECLARE \n"
      + "BEGIN \n"
         + "Report_Images_API.Import_Image_File(:ReportId,:ImageName,:Module,:Image, :PreventOverwrite, :RetValue);\n"
      + "END;";
   }
   
   private static final String stmt_IMPORTIMAGERS(String apiMethod){
      return
      "DECLARE \n"
      + "BEGIN \n"
         + "	" + apiMethod + "(:ImageName, :Image, :PreventOverwrite, :RetValue);\n"
      + "END;";
   }
   
   /**
    * Creates a new instance of DbMergeFilesTask
    * @param connectString
    * @param loginId
    * @param password
    * @param imageDir
    * @param debugFilePath
    */
   public ImportImages(String connectString, String loginId, String password, String imageDir, String debugFilePath) {
      this.connectString = connectString;
      this.loginId = loginId; 
      this.password = password;
      this.imageDir = imageDir;
      this.debugFilePath = debugFilePath + "/" + "import_reportImages.log";
   }   
   
   public void execute() throws ImportException {
      try {
         //  Validatate prerequisites
         if (imageDir == null || (imageDir != null && imageDir.length() == 0)) {
            throw new ImportException("WARNING: IMPORT: Mandatory report image path is Null.");
         }
            
         if (debugFilePath != null) {
            File file = new File(debugFilePath);
            debugStream = new OutputMessageStream(new FileOutputStream(file, true));
            System.setErr(debugStream);
            logNewLine();
         }
         //Import items if there are items in the folders
         setImportImages(imageDir);
         if (importRepImages){
            logInfo("### Report images, signatures, logos initializing... ###");
            logInfo("Trying to connect to the database");
            Properties props = new Properties();
            props.setProperty("user", loginId);
            props.setProperty("password", password);
            conn = DriverManager.getConnection(connectString, props);
            conn.setAutoCommit(true);
            try {
               if (conn.isClosed()) {
                  throw new ImportException("ERROR: No connection to the database could be established (1)! Connect string " + connectString);
               }
            }
            catch (Exception e) {
               throw new ImportException("ERROR: No connection to the database could be established (1)! Connect string " + connectString);
            }
            logInfo("Connected successfull");
            //import images, signatures and logos as appowner
            importImages();
            importSignatures();
            importLogos();
            logInfoSuccess();
         }
      }
      catch (Exception e) {
         if(conn!=null) {
               logInfo(e.getCause().getMessage());
               logInfoFail();
         }
         if (!quiet) {
            logInfo(e.getCause().getMessage());
            throw new ImportException("WARNING: IMPORT: " + e.getMessage());         
         }
      }
      finally {
         if(conn!=null) {
            try {
               conn.close();
               conn = null;
               logNewLine();
               logInfo("Database connection successfull closed");
            }
            catch (Exception e) {
               logInfo("Error closing database connection.");
               logInfo("ERROR: " + e.getMessage());
            }
         }
         if (debugStream != null) {
             debugStream.close();
             debugStream = null;
         }
      }      
   }
   
   private void importImages() throws Exception {
      String curImageDir = imageDir + File.separator + "images";
      File repImgFile = new File(curImageDir);
      if (!repImgFile.exists()) {
         logInfo("Report image folder " + curImageDir + " does not exist");
         return;
      }
      logInfo("==================== Importing Report Imagers ====================");
      logNewLine();
      logInfo("Image Path: " + curImageDir );
      File[] moduleDirs = repImgFile.listFiles();
      int moduleLoop = 0;
      int repIdLoop = 0;
      int imgLoop = 0;
      File moduleDir;
      String module = null;
      String report_id = null;
      String image_name = null;
      InputStream imageFile = null;
      while(moduleLoop<moduleDirs.length) {
         moduleDir = moduleDirs[moduleLoop];
         if (moduleDir.isDirectory()){
            module = moduleDir.getName();
            curImageDir = curImageDir + File.separator +  module;
            repImgFile = new File(curImageDir);
            logNewLine();
            logInfo("Image Module Path: " + curImageDir );
            File[] repIdDirs = repImgFile.listFiles();
            File repIdDir;
            while(repIdLoop<repIdDirs.length) {
               repIdDir = repIdDirs[repIdLoop];
               if (repIdDir.isDirectory()){
                  report_id = repIdDir.getName();
                  curImageDir = curImageDir + File.separator +  report_id;
                  repImgFile = new File(curImageDir);
                  logNewLine();
                  logInfo("Image Report ID Path: " + curImageDir );
                  logNewLine();
                  File[] repImages = repImgFile.listFiles();
                  File repImage;
                  String retValue = null;
                  while(imgLoop<repImages.length) {
                     repImage = repImages[imgLoop];
                     if (repImage.isFile()){
                        image_name = repImage.getName();
                        logInfo("Importing image " + image_name );  
                        imageFile = readImageFile(repImage);
                        CallableStatement pstmt = conn.prepareCall(stmt_IMPORTREPORTIMAGERS());
                        pstmt.setString(1, report_id);
                        pstmt.setString(2, image_name);
                        pstmt.setString(3, module);
                        pstmt.setBlob(4, imageFile);
                        pstmt.setString(5, "FALSE");
                        pstmt.registerOutParameter(6, java.sql.Types.VARCHAR);
                        pstmt.execute();
                        retValue = pstmt.getString(6);
                        closeStatement(pstmt,"Import image " + image_name);
                        logInfoState(retValue, "Image", image_name);
                        if (imageFile != null){
                           imageFile.close();
                        }
                        imgLoop++;
                        image_name = null;
                        imageFile = null;
                        repImage = null;
                        retValue = null;
                     }
                  }
                  curImageDir = imageDir + File.separator + "images" + File.separator + module;
                  repImgFile = null;
                  imgLoop = 0;
                  repIdLoop++;
                  report_id = null;
                  repIdDir = null;
               }
            }
            curImageDir = imageDir + File.separator + "images";
            repImgFile = null;
            repIdLoop = 0;
            moduleLoop++;
            module = null;
            moduleDir = null;
         }
      }
   }
   
   private void importSignatures() throws Exception{
      importImageFiles("signatures", "Signature", "Report_Signatures_API.Import_Image_File");
   }
   
   private void importLogos() throws Exception{
      importImageFiles("stdlogo", "Logo", "Report_Logos_API.Import_Image_File");
   }
   
   private void importImageFiles(String imageFolder, String importingWhat, String apiMethod) throws Exception{
      String curImageDir = imageDir + File.separator + imageFolder;
      File imgDir = new File(curImageDir);
      if (!imgDir.exists()) {
         logInfo("Report image folder " + curImageDir + " does not exist.");
         return;
      }
      logNewLine();
      logInfo("==================== Importing Report " + importingWhat + " ====================");
      logNewLine();
      logInfo("Image Path: " + curImageDir );
      logNewLine();
      File[] images = imgDir.listFiles();
      int imageLoop = 0;
      InputStream imageFile = null;
      File image;
      String image_name = null;
      String retValue = null;
      while(imageLoop<images.length) {
         image = images[imageLoop];
         if (image.isFile()){
            image_name = image.getName();
            logInfo("Importing " + importingWhat + " " + image_name);  
            imageFile = readImageFile(image);
            CallableStatement pstmt = conn.prepareCall(stmt_IMPORTIMAGERS(apiMethod));
            pstmt.setString(1, image_name);
            pstmt.setBlob(2, imageFile);
            pstmt.setString(3, "FALSE");
            pstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
            pstmt.execute();
            retValue = pstmt.getString(4);
            closeStatement(pstmt,"Import image " + image_name);
            logInfoState(retValue, importingWhat, image_name);
            if (imageFile != null){
               imageFile.close();
            }
            image = null;
            image_name = null;
            retValue = null;
         }
         else{
            if (image.isDirectory()){
               importImageFiles( imageFolder + File.separator + image.getName(), importingWhat, apiMethod);
            }
         }
         imageLoop++;
      }
   }
   
   private InputStream readImageFile(File file) throws Exception {
      InputStream inStream = null;
      inStream = new BufferedInputStream(new FileInputStream(file));
      return inStream;
   }

   private void logInfoState(String importState, String importingWhat, String image_name) {
      String msg =  null;
      switch (importState){
         case "IMPORT": 
            msg = importingWhat + " " + image_name + " successfully imported" ;
            break;
         case "MODIFY":
            msg = importingWhat + " " + image_name + " successfully updated" ;
            break;
         case "LOCKED": 
            msg = importingWhat + " " + image_name + " overwriting is prevented, therefore not updated" ;
            break;
         default:
            msg = importingWhat + " " + image_name + " was not imported ot updated due to an error" ;
            break;
      }
      if (debugStream != null) {
         debugStream.println(msg);
      }
   }
   
   private void logInfo(String msg) {
      if (debugStream != null) {
         debugStream.println(msg);
      }
   }

   private void logError(String msg) {
      if (debugStream != null) {
         String[] ms = msg.split("\n");
         for (int i = 0; i < ms.length; i++) {
            debugStream.printEr(ms[i]);
         }
      }
   }

   private void logInfoSuccess() {
      if (debugStream != null) {
         logNewLine();
         logNewLine();
         debugStream.printEr("#############################################################");
         debugStream.printEr("#                                                           #");
         debugStream.printEr("#  All images/signatures/logos were imported SUCCESSFULLY.  #");
         debugStream.printEr("#                                                           #");
         debugStream.printEr("#############################################################");
      }
   }

   private void logInfoFail() {
      if (debugStream != null) {
         logNewLine();
         logNewLine();
         debugStream.printEr("#########################################################################################");
         debugStream.printEr("#                                                                                       #");
         debugStream.printEr("#  Some issues were found when importing images/signatures/logos. See log for details.  #");
         debugStream.printEr("#                                                                                       #");
         debugStream.printEr("#########################################################################################");
      }
   }

   private void logNewLine() {
      if (debugStream != null) {
         debugStream.newLine();
      }
   }
   
   public void setImportImages(String reportDir) {
      java.io.File imgDirFile = new java.io.File(reportDir + "//images");
      if (!imgDirFile.exists()) {
         this.importRepImages = false;
         logInfo(reportDir + "/images folder does not exist. Please ignore this message if you do not have any report images to import in your delivery.");
      }
      else{
         java.io.File[] imgFiles = imgDirFile.listFiles();
         this.importRepImages = imgFiles.length > 0 ? true : false;
         if (imgFiles.length <= 0){
           logInfo("No images were found to be imported under folder " + reportDir + "/images"); 
         }          
      }
      
      imgDirFile = new java.io.File(reportDir + "//signatures");
      if (!imgDirFile.exists()) {
         this.importRepImages = this.importRepImages == false ? false : true;
         logInfo(reportDir + "/signatures folder does not exist. Please ignore this message if you do not have any report signatures images to import in your delivery.");
      }
      else{
         java.io.File[] imgFiles = imgDirFile.listFiles();
         this.importRepImages = imgFiles.length > 0 ? true : this.importRepImages == false ? false : true;
         if (imgFiles.length <= 0){
           logInfo("No signatures were found to be imported under folder " + reportDir + "/signatures"); 
         }          
      }
      
      imgDirFile = new java.io.File(reportDir + "//stdlogo");
      if (!imgDirFile.exists()) {
         this.importRepImages = this.importRepImages == false ? false : true;
         logInfo(reportDir + "/stdlogo folder does not exist. Please ignore this message if you do not have any report logo images to import in your delivery.");
      }
      else{
         java.io.File[] imgFiles = imgDirFile.listFiles();
         this.importRepImages = imgFiles.length > 0 ? true : this.importRepImages == false ? false : true;
         if (imgFiles.length <= 0){
           logInfo("No logos were found to be imported under folder " + reportDir + "/stdlogo"); 
         }          
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
           logInfo("ERROR: " + e.getMessage());                                 
        }
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
