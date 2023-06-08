package ifs.installer.logging;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.logging.ConsoleHandler;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

public final class InstallerLogger {

   private static final String LOGGER_NAME = "IfsInstallerLogger.log";
   private static final Logger logger = Logger.getLogger(LOGGER_NAME);
   private static FileHandler fileHandler;
   private static ConsoleHandler consoleHandler;
   private static String location = null;
   private static final int LOG_SIZE_LIMIT = 5 * 1024 * 1024;
   private static final int LOG_COUNT_LIMIT = 10;

   private static boolean disableConsoleLogger = false;
   
   private static boolean loggedSevere = false;

   private InstallerLogger() {
   }

   public static Logger getLogger() {
      return logger;
   }

   public static void disableConsoleLogger() {
      disableConsoleLogger = true;
   }

   public static void setLogLevel(final Level lvl) {
      logger.setUseParentHandlers(false);
      logger.setLevel(lvl);

      /* Create default log handler if none exists */
      if (fileHandler == null) {
         try {
            setLogfileLocation("");
         } catch (IOException e) {
            return;
         }
      }
      fileHandler.setLevel(lvl);
      consoleHandler.setLevel(lvl);
      logger.fine("Loglevel set to: " + lvl.toString());
      if (lvl.equals(Level.FINEST)) {
         logger.warning("FINEST LOGLEVEL USED, THIS INSTALLATION LEAKS SENSITIVE INFORMATION!!");
      }
   }

   public static void setLogfileLocation(final String logLocation) throws IOException {
      String result = "";
      if (logLocation == null) {
         // use current dir
         result = new File("").getCanonicalPath();
      } else {
         result = new File(logLocation).getCanonicalPath();
      }
      new File(result).mkdirs();

      // check if logLocation is different from previous
      if (result.equalsIgnoreCase(location)) {
         return;
      }

      // remove previous log handler (handles null silently)
      logger.removeHandler(fileHandler);

      fileHandler = new FileHandler(result + "/" + LOGGER_NAME, LOG_SIZE_LIMIT, LOG_COUNT_LIMIT);
      fileHandler.setFormatter(new LogFormatter());
      logger.addHandler(fileHandler);

      consoleHandler = new ConsoleHandler();
      consoleHandler.setFormatter(new LogFormatter());

      if (!disableConsoleLogger) {
         logger.addHandler(consoleHandler);
      }
      location = result;
   }

   public static String getLogfileLocation() {
      return location;
   }
   
   public static boolean loggedSevere() {
      return loggedSevere;
   }   
   
   public static final class LogFormatter extends SimpleFormatter {
      @Override
      public synchronized String format(final LogRecord record) {
         StringBuilder message;
         message = new StringBuilder();

         if (record.getLevel() == Level.SEVERE)
            loggedSevere = true;

         message.append("[" + new Date(record.getMillis()) + "]");
         message.append(" - " + record.getLevel() + ": ");
         message.append(record.getMessage() + "\n");
         return message.toString();
      }
   }
}