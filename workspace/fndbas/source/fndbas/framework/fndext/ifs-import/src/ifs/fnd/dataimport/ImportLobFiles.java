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
 * File        : ImportLobFiles.java
 * Description :
 * Notes       :
 * ----------------------------------------------------------------------------
 * Modified    :
 *    StDafi 2016-Sep-21 - Created.
 * ----------------------------------------------------------------------------
 */
package ifs.fnd.dataimport;

import java.io.*;
import java.text.*;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Blob;
import java.sql.Clob;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Calendar;
import java.util.Properties;
import static java.util.UUID.randomUUID;

/**
 * Ant task for import of Lob files
 */
public class ImportLobFiles
{
   /* Mandatory setting for connection string */
   private String connectstring = null;
   /* Mandatory setting for Application Owner User Name*/
   private String aousername = null;
   /* Mandatory setting for Application Owner Password */
   private String aopassword = null;
   /* Mandatory file path to the lobby directory */
   private String lobFilePath = null;
   /* None mandatory file path to the debug file */
   private String debugFilePath = null;
   
   private int readFiles = 0;
   private long readSize = 0;
   private String rootPath = null;

   private long startTime;
   
   private String lineSeparator = System.getProperty("line.separator", "\n"); 
   private OutputMessageStream logInfoStream = null;

   Connection con = null;
   
   boolean errorOccured = false;
   
   private static final String stmt_IMPORTBLOBFILE =
           "BEGIN \n"
         + "   Lob_File_Import_API.Import_Blob_File(:FileName,:Module,:Category,:FileDate,:TaskId,:File);\n"
         + "END;";

   private static final String stmt_IMPORTCLOBFILE =
           "BEGIN \n"
         + "   Lob_File_Import_API.Import_Clob_File(:FileName,:Module,:Category,:FileDate,:TaskId,:File);\n"
         + "END;";
   
   private static final String stmt_BULKIMPORTLOBBATCH  = 
           "BEGIN \n"
         + "   :result := Lob_File_Import_API.Bulk_Import_(:TaskId); \n"
         + "END;";
   
      /**
    * Creates a new instance of DbMergeFilesTask
    * @param connectstring
    * @param aousername
    * @param aopassword
    * @param lobFilePath
    * @param debugFilePath
    */
   public ImportLobFiles(String connectstring, String aousername, String aopassword, String lobFilePath, String debugFilePath) {
      this.connectstring = connectstring;
      this.aousername = aousername; 
      this.aopassword = aopassword;
      this.lobFilePath = lobFilePath;
      this.debugFilePath = debugFilePath + "/" + "import_lobFiles.log";
   }
   
   /**
     * Checks that a property has a value set.
     * @param   name  the name of the property. Used for displaying error message.
     * @param   value the value to check.
     * @throws  BuildException if the property has no value.
     */
   private void checkPropertySet(String name, String value) throws ImportException {
      if (value == null || value.length() == 0) {
         throw new ImportException("ERROR:Property " + name + " is not set.");
      }
   }
    
   @SuppressWarnings("SleepWhileInLoop")
   private void importDirectory(File dir, String module, String taskId, SimpleDateFormat sdf, int level) throws Exception {
      logInfo("Importing files from: " + dir.getAbsolutePath());
      logNewLine();
      level++;
      File f;
      if(!dir.exists()) {
         logInfo("Directory doesn't exist!");
         return;
      }
      // Loop files in directory
      File[] files = dir.listFiles();
      int noOfFiles=0;
      try {
         while(noOfFiles<files.length) {
            f = files[noOfFiles];
            String folderFileName = f.getName();
            if (f.isDirectory()) {
               importDirectory(f, module, taskId, sdf, level);
            } else {
               // Only read lob_files.
               logInfo("Reading LOB file: " + folderFileName);
               CallableStatement pstmt;
               String filePath = null;
               if (level == 1) {
                  filePath = ".";
               } else {
                  filePath = dir.getAbsolutePath().replace("\\", "/").replace(rootPath+"/"+module+"/", "");
               }
               if(folderFileName.toLowerCase().endsWith(".clob")) {
                  String file = getContentsClob(f);
                  Clob fileClob = con.createClob();
                  fileClob.setString(1, file);
                  pstmt = con.prepareCall(stmt_IMPORTCLOBFILE);
                  pstmt.setString(1, folderFileName);
                  pstmt.setString(2, module.toUpperCase());
                  pstmt.setString(3, filePath);
                  pstmt.setString(4, sdf.format(f.lastModified()));
                  pstmt.setString(5, taskId);
                  pstmt.setClob(6, fileClob);
                  pstmt.execute();          
               } else {
                  byte[] allBytes = getContentsBlob(f);
                  Blob fileBlob = con.createBlob();
                  fileBlob.setBytes(1, allBytes);
                  pstmt = con.prepareCall(stmt_IMPORTBLOBFILE);
                  pstmt.setString(1, folderFileName);
                  pstmt.setString(2, module.toUpperCase());
                  pstmt.setString(3, filePath);
                  pstmt.setString(4, sdf.format(f.lastModified()));
                  pstmt.setString(5, taskId);
                  pstmt.setBlob(6, fileBlob);
                  pstmt.execute();          
               }
               readFiles++;
               readSize = readSize + f.length();
            }
            noOfFiles++;
         }
      } catch(SQLException e) {
         logInfo("Exception caught.\n" + e.toString());
         errorOccured = true;
      }
   }

   @SuppressWarnings("SleepWhileInLoop")
   private void importFiles(String path) throws Exception {
      logInfo("Importing files from: " + path);
      rootPath = path.replace("\\", "/");
      logNewLine();
      File dir = new File(path);
      if(!dir.exists()) {
         logInfo("Directory doesn't exist!");
         return;
      }
      String taskId = randomUUID().toString();
      // Loop files in directory
      File[] components = dir.listFiles();
      int noOfComponenets=0;
      int level=0;
      SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
      try {
         while(noOfComponenets<components.length) {
            level=0;
            String module = components[noOfComponenets].getName();
            logInfo("module " + module.toUpperCase());
            importDirectory(components[noOfComponenets], module, taskId, sdf, level);
            noOfComponenets++;
         }
         
         if (readFiles > 0) {
            logNewLine();
            logInfo("Executing Batch job for transferring lob files! ");
            Statement stm;
            stm = con.createStatement();
            stm.setEscapeProcessing(false);
            stm.executeUpdate("BEGIN Dbms_Output.Enable(buffer_size => NULL); END;");
            stm.close();

            CallableStatement pstmt = con.prepareCall(stmt_BULKIMPORTLOBBATCH);
            pstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
            pstmt.setString(2, taskId);
            pstmt.execute();
            String errorResult = pstmt.getString(1);
            
            if ("TRUE".equals(errorResult)) {
               logNewLine();
               logInfo("Error occurred when executing Batch job for transferring lob files! ");
               errorOccured = true;
            }

            logNewLine();
            String text = "BEGIN DBMS_OUTPUT.GET_LINE(?, ?); END;";
            pstmt = con.prepareCall(text);
            pstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
            pstmt.registerOutParameter(2, java.sql.Types.NUMERIC);
            int status = 0;
            while (status == 0) {
               pstmt.execute();
               String output = pstmt.getString(1);
               status = pstmt.getInt(2);
               if (status == 0) {
                  logInfo(output);
               }
            }
            logNewLine();
            logInfo("Done executing Batch job for transferring lob files! ");
         }         

      } catch(SQLException e) {
         logInfo("Exception caught.\n" + e.toString());
         errorOccured = true;
      } finally {
         try {
            con.close();
         } catch (SQLException se) {
            throw new ImportException("ERROR:Error closing database. " + se.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
         }
         if (errorOccured) {
            throw new ImportException("WARNING: IMPORT: Error encountered during import of Lob Files. Check log file"); 
         }
      }         
   }

//   @Override
   public void execute() throws ImportException {

      startTime = System.currentTimeMillis();
      try {
         
         //-------------------------------------
         //  Validatate prerequisites
         //-------------------------------------
         validateProperties();
         
         createLog(debugFilePath);
         logInfo("### Start LOB Files Import ###");
         logNewLine();

         Properties props = new Properties();
         props.setProperty("user", aousername);
         props.setProperty("password", aopassword);
         con = DriverManager.getConnection(connectstring, props);
         con.setAutoCommit(true);

         try {
             if (con.isClosed()) {
                 throw new ImportException("ERROR:No connection to the database could be established (1)! Connect string " + connectstring);
             }
         } catch (Exception e) {
             throw new ImportException("ERROR:No connection to the database could be established (2)! Connect string " + connectstring);
         }
         
         logInfo("Importing Lob Files");

         logNewLine();

         // Start in lobFilePath directory
         importFiles(lobFilePath);

         con.close();

         // End Log
         NumberFormat form = NumberFormat.getNumberInstance();
         form.setGroupingUsed(true);
         logNewLine();
         logInfo("Totally " + readFiles + " files were read, with total size: " + form.format(readSize) + ".");
         logInfo("Elapsed time: " + formatHMS(System.currentTimeMillis() - startTime));
         logNewLine();
      }

      catch (Exception e) {
         if(con!=null) {
               logInfo("Error while importing LOB files : " + e.getMessage());
         }
         readFiles = 0;
         throw new ImportException(e.getMessage());
      } finally {
         if(con!=null) {
            try {
               con.rollback();
               con.close();
            } catch (Exception e) {}
         }
         closeLog();
      }
   }
   
    /**
     * Validates that necessary properties are set. If not a <code>BuildException</code>
     * is thrown.
     */
   private void validateProperties() throws ImportException {
      checkPropertySet("Connectstring", connectstring);
      checkPropertySet("Application Owner UserName", aousername);
      checkPropertySet("Application Owner Password", aopassword);
      checkPropertySet("Path to LOB files", lobFilePath);
   }
   
   private byte[] getContentsBlob(File f)
   {
      InputStream inputStream = null;
      try {
         inputStream = new FileInputStream(f);
         long fileSize = f.length();
         byte[] allBytes = new byte[(int) fileSize];
         inputStream.read(allBytes);
         return allBytes;
      }
      catch (FileNotFoundException ex) {
          ex.printStackTrace();
      }
      catch (IOException ex) {
         ex.printStackTrace();
      }
      finally {
          try {
              if (inputStream!= null) {
                  inputStream.close();
              }
          }
          catch (IOException ex) {
              ex.printStackTrace();
          }
      }
      return null;
   }

private String getContentsClob(File f)
   {
      StringBuilder contents = new StringBuilder();

      BufferedReader input = null;
      try {
          input = new BufferedReader( new FileReader(f) );
          String line = null;
          while (( line = input.readLine()) != null){
              contents.append(line);
              contents.append(lineSeparator);
          }
      }
      catch (FileNotFoundException ex) {
          ex.printStackTrace();
      }
      catch (IOException ex){
          ex.printStackTrace();
      }

      finally {
          try {
              if (input!= null) {
                  input.close();
              }
          }
          catch (IOException ex) {
              ex.printStackTrace();
          }
      }
      return contents.toString();
   }

   private void createLog(String logInfoFilePath) throws Exception {
      if(logInfoFilePath != null) {
         try {
            File file = new File(logInfoFilePath);
            file.delete();
            file.createNewFile();
            logInfoStream = new OutputMessageStream(new FileOutputStream(file, true));
            System.setErr(logInfoStream);
         } catch(Exception e) {
            throw new Exception(e);
         }         
      }
   }
   
   private void closeLog() {
      if( logInfoStream != null){
         logInfoStream.close();   
      }
   }   
   
   private void logInfo(String msg) {
      if(logInfoStream != null)  {
         logInfoStream.println(msg);
      }
   }

   private void logNewLine() {
      logInfo("------------------------------------------------------------");
   }

   private String formatHMS(long timeInMilliSeconds) {
      int hours, minutes, seconds, timeInSeconds;
      timeInSeconds = new Long(timeInMilliSeconds).intValue() / 1000;
      hours = timeInSeconds / 3600;
      timeInSeconds = timeInSeconds - (hours * 3600);
      minutes = timeInSeconds / 60;
      timeInSeconds = timeInSeconds - (minutes * 60);
      seconds = timeInSeconds;
      return hours + " hour(s) " + minutes + " minute(s) " + seconds + " second(s)";
   }
   
private class  OutputMessageStream extends java.io.PrintStream  {
      public OutputMessageStream(FileOutputStream fos) {
         super(fos);         
      }
      public OutputMessageStream(FileOutputStream fos,boolean autoFlush) {
         super(fos,autoFlush);
      }
      public void print(String msg) {
         super.print(msg);
      }
      public void println(String msg) {
         Calendar calendar = Calendar.getInstance();
         java.util.Date date = calendar.getTime();
         super.println("["+date.toString()+"]  "+msg);
      }
      
      public void newLine() {
         super.println("");
      }
      public void printlogInfo(String msg) {
         Calendar calendar = Calendar.getInstance();
         java.util.Date date = calendar.getTime();
         super.print("["+date.toString()+" ]"+msg+ "\r\n");
      }
   }
}
