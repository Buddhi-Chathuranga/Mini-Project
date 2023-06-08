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
 * File        : ImportTransFiles.java
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
import java.sql.Clob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Properties;
import static java.util.UUID.randomUUID;

/**
 * Ant task for import of Localize LNG (attributes) and TRS (translations)
 */
public class ImportTransFiles
{
   /* Mandatory setting for connection string */
   private String connectstring = null;
   /* Mandatory setting for Application Owner User Name*/
   private String aousername = null;
   /* Mandatory setting for Application Owner Password */
   private String aopassword = null;
   /* Mandatory file path to the translation directory */
   private String transFilePath = null;
   /* None mandatory file path to the debug file */
   private String debugFilePath = null;
   /* None mandatory setting if production mode */
   private boolean runtime = true;
   /* None mandatory setting if translatable attibutes should be imported */
   private boolean importAttributes = true;        
   /* None mandatory setting if translations should be imported */
   private boolean importTranslations = true;
   /* None mandatory setting if runtime translations should be refreshed */
   private String refresh = "TRUE";
   /* None mandatory setting to set if a build exception is thrown */
   private boolean throwException = true;

   private int readFiles = 0;
   private long readSize = 0;
   private int retryImportCtr = 0;

   private long startTime;
   
   private String lineSeparator = System.getProperty("line.separator", "\n"); 
   private OutputMessageStream logInfoStream = null;
   
   Connection con = null;
   
   private static final String stmt_IMPORTTRANSFILES =
           "DECLARE \n"
           + "BEGIN \n"
           + "	Language_File_Import_API.Import_Trans_Files(:FileName,:FileDate,:TaskId,:File);\n"
           + "END;";
		   
   private static final String stmt_BULKIMPORTLANGUAGEBATCH1  = 
           "BEGIN LANGUAGE_SYS.BULK_IMPORT_BATCH_ (" + 
             ":TASK_ID_," + 
             ":REFRESH_);" +
           "END;";
   
      /**
    * Creates a new instance of DbMergeFilesTask
    * @param connectstring
    * @param aousername
    * @param aopassword
    * @param transFilePath
    * @param debugFilePath
    * @param runtime
    * @param importAttributes
    * @param importTranslations
    */
   public ImportTransFiles(String connectstring, String aousername, String aopassword, String transFilePath, String debugFilePath, String runtime, String importAttributes, String importTranslations) {
      this.connectstring = connectstring;
      this.aousername = aousername; 
      this.aopassword = aopassword;
      this.transFilePath = transFilePath;
      this.debugFilePath = debugFilePath + "/" + "import_transFiles.log";
      this.runtime = runtime.toUpperCase().equals("Y");
      this.importAttributes = importAttributes.toUpperCase().equals("Y");
      this.importTranslations = importTranslations.toUpperCase().equals("Y");
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
   private void importDirectory(String path) throws Exception {
      logInfo("Importing files from: " + path);
      logNewLine();
      boolean errorOccured = false;
      File dir = new File(path);
      File f;
      String typeCheck;
      if(!dir.exists()) {
         logInfo("Directory doesn't exist!");
         return;
      }

      String taskId = randomUUID().toString();
      // Loop files in directory
      File[] files = dir.listFiles();
      int i=0;

      try {
         while(i<files.length) {
            f = files[i];
            // Only read language_files.
            if(!f.getName().endsWith(".lng")&&!f.getName().endsWith(".trs")){
               i++;
               continue;
            }
            //Runtime Environment, files should be imported, except for files unnecessary in runtime db.
            if (runtime) {
                try {
                   typeCheck = f.getName().substring(f.getName().indexOf("_")+1,f.getName().indexOf("-"));        
                   if (typeCheck.equalsIgnoreCase("VC") ||
                       typeCheck.equalsIgnoreCase("VB")) {
                      i++;
                      continue;
                   }
                   if(f.getName().endsWith(".lng") && !importAttributes){
                     i++;
                     continue;
                   }
                   if(f.getName().endsWith(".trs") && !importTranslations){
                     i++;
                     continue;
                  }
                } catch(Exception e) {
                   i++;
                   continue;
                } 
            }

            //Development Environment, all lng files should be installed, but not trs files.
            if (!runtime) {
                if(f.getName().endsWith(".lng") && !importAttributes){
                    i++;
                    continue;
                }
                if(f.getName().endsWith(".trs") && !importTranslations){
                    i++;
                    continue;
                }
            }
            
            logInfo("Reading translation file: " + f.getName());
            String file = getContents(f);
            Clob fileClob = con.createClob();
            fileClob.setString(1, file);

            try (CallableStatement pstmt = con.prepareCall(stmt_IMPORTTRANSFILES)) {
               SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");

               pstmt.setString(1, f.getName());
               pstmt.setString(2, sdf.format(f.lastModified()));
               pstmt.setString(3, taskId);
               pstmt.setClob(4, fileClob);
               pstmt.execute();          
            }

            readFiles++;
            readSize = readSize + f.length();

            i++;
         }
         
         if (readFiles > 0) {
            logNewLine();
            logInfo("Executing Batch job for analyzing translation data! ");
            try (CallableStatement pstmt = con.prepareCall(stmt_BULKIMPORTLANGUAGEBATCH1)) {
               pstmt.setString(1, taskId);
               pstmt.setString(2, refresh);
               pstmt.execute();
            }
         }         
      } catch(SQLException e) {
         i++;
          // Cancel transaction.
         logInfo("Exception caught.\n" + e.toString());
		 errorOccured = true;
		 
      } finally {
         try {
            con.close();
         } catch (SQLException se) {
            throw new ImportException("ERROR:Error closing database. " + se.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
         }
         if (errorOccured) {
            throw new ImportException("WARNING: IMPORT: Error encountered during import of file. Check log file"); 
         }
      }         
   }

   public void execute() throws ImportException {

      startTime = System.currentTimeMillis();
      try {
 
         //-------------------------------------
         //  Validatate prerequisites
         //-------------------------------------
         validateProperties();
         
         createLog(debugFilePath);
         logInfo("### Start Translation Files Import ###");
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
         
         //Runtime Environment, but no files should be imported.
         if (runtime && !importAttributes && !importTranslations ) {
             logInfo("Nothing will be imported, runtime=true, importAttriubutes and importTranslations=false");
         }
         //Development Environment, but no files should be imported.
         if (!runtime && !importAttributes && !importTranslations ) {
             logInfo("Nothing will be imported, runtime=false, importAttriubutes and importTranslations=false");
         }       

         if (runtime && importAttributes && !importTranslations )
            logInfo("Importing Runtime Attributes");
         
         if (runtime && !importAttributes && importTranslations )
            logInfo("Importing Runtime Translations");  
         
         if (runtime && importAttributes && importTranslations ) 
            logInfo("Importing Runtime Attributes and Translations");
         
         if (!runtime && importAttributes && !importTranslations )
            logInfo("Importing Lng Files For Development Environment");
         
         if (!runtime && !importAttributes && importTranslations )
            logInfo("Importing Trs Files For Development Environment");  
         
         if (!runtime && importAttributes && importTranslations ) 
            logInfo("Importing Both Lng And Trs Files For Development Environment");

         logNewLine();

         // Start in transFilePath directory
         importDirectory(transFilePath);

         con.close();

         // End Log
         NumberFormat form = NumberFormat.getNumberInstance();
         form.setGroupingUsed(true);
         logNewLine();
         logInfo("Totally " + readFiles + " files were read, with total size: " + form.format(readSize) + ".");
         logInfo("A total of " + retryImportCtr + " retry import attempt(s) was done.");
         logInfo("Elapsed time: " + formatHMS(System.currentTimeMillis() - startTime));
         logNewLine();
      }

      catch (Exception e) {
         if(con!=null) {
               logInfo("Error while importing Localize files : " + e.getMessage());
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
         if(readFiles > 0 && throwException)
            throw new ImportException("WARNING: A background job Bulk Import of Language Files has started. Do not shutdown the database.");
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
      checkPropertySet("Path to translations", transFilePath);
   }
   
   private String getContents(File f)
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
      if(logInfoStream != null)
         logInfoStream.println(msg);
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
      @Override
      public void print(String msg) {
         super.print(msg);
      }
      @Override
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
