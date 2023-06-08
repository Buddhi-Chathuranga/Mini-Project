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
 */
package ifs.cloud.fsmigtool.logging;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

/**
 * @author IFS RnD
 */
public class FsMigToolLogger {
  
   private static Logger LOGGER = Logger.getLogger("FsLog");
   private static FsMigToolLogger singleInstance = null;
   private FileHandler fh;
   
   static {
//      System.setProperty("java.util.logging.SimpleFormatter.format",
//              "[%1$tF %1$tT] [%4$-7s] %5$s %n");
      System.setProperty("java.util.logging.SimpleFormatter.format",
              "[%1$tF %1$tT] [%4$-7s] %5$s %n");
      LOGGER = Logger.getLogger(FsMigToolLogger.class.getName());
   }

   public FsMigToolLogger() throws IOException {
      createLogFile();
   }

   public static FsMigToolLogger getInstance() throws IOException {
      FsMigToolLogger localInstance = singleInstance;
      if (localInstance == null) {
         localInstance = singleInstance;
         if (localInstance == null) {
            singleInstance = localInstance = new FsMigToolLogger();
         }
      }
      return localInstance;
   }

   private void createLogFile() throws IOException {
      try {
         //fh = new FileHandler("FsMigTool - " + new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new java.util.Date()) + ".log", MAX_FILE_BYTES, MAX_FILES, true);
         fh = new FileHandler("FsMigTool - " + new SimpleDateFormat("yyyy.MM.dd.HH.mm").format(new java.util.Date()) + " - %g.log", 6000000, 100000);
         FsMigToolLogger.LOGGER.addHandler(fh);
         SimpleFormatter formatter = new SimpleFormatter();
         fh.setFormatter(formatter);
      } catch (IOException e) {
         throw new IOException("Failed to create log file FsMigTool.log. " + e.getMessage(), e);
      }
   }

   public void logCommandLineError(String message) {
      logCommandLine(message, true);
   }

   public void logCommandLine(String message) {
      logCommandLine(message, false);
   }
   
   public void logCommandLineErrorNoLine(String message) {
      logCommandLineNoLine(message, true);
   }

   public void logCommandLineNoLine(String message) {
      logCommandLineNoLine(message, false);
   }

   public void logFileError(String message) {
      logFile(message, true);
   }

   public void logFile(String message) {
      logFile(message, false);
   }

   private void logCommandLine(String message, boolean isError) {
      if (isError) {
         System.err.println(message);
         logFileError(message);
      } else {
         System.out.println(message);
         logFile(message);
      }
   }
   private void logCommandLineNoLine(String message, boolean isError) {
      if (isError) {
         System.err.print("\r" + message);
         logFileError(message);
      } else {
         System.out.print("\r" + message);
         logFile(message);
      }
   }
   
   private void logFile(String message, boolean isError) {
      LOGGER.setUseParentHandlers(false);
      if (isError) {
         LOGGER.log(Level.WARNING, "Error: {0}", message);
      } else {
         LOGGER.log(Level.INFO, "{0}", message);
      }
   }
}
