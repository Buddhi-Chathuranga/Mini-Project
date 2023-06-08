package ifs.cloud.build;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Date;
import java.util.Formatter;
import java.util.logging.ConsoleHandler;
import java.util.logging.FileHandler;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

public class Log {
   public static final boolean DEBUG = false;
   public static final Debug DEBUG_LEVEL = new Debug();
   
   private static final StringBuilder formatBuffer = new StringBuilder();
   private static final Formatter formatter = new Formatter(formatBuffer);
   
   private final static java.util.logging.Logger logger;
   private final static ConsoleHandler consoleHandler;

   static {
      logger = Logger.getLogger("build-files");
      logger.setUseParentHandlers(false);
      logger.setLevel(Level.ALL);
      /* console */
      consoleHandler = new ConsoleHandler();
      consoleHandler.setFormatter(new LogFormatter());
      consoleHandler.setLevel(Level.WARNING);
      logger.addHandler(consoleHandler);
   }
   
   public static void debug(String fmt, Object... objs) {
      if (DEBUG) {
         synchronized (formatter) {
            logger.log(DEBUG_LEVEL, formatter.format(fmt, objs).toString());
            formatBuffer.setLength(0);
         }
      }
   }

   public static void printf(Level level, String fmt, Object... objs) {
      synchronized (formatter) {
         if (logger.isLoggable(level)) {
            logger.log(level, formatter.format(fmt, objs).toString());
            formatBuffer.setLength(0);
         }
      }
   }   
   
   static class LogException {
      private final Throwable t;
      private final boolean shortMsg;
      
      LogException(Throwable t) {
         this(t, false);
      }
      
      LogException(Throwable t, boolean shortMsg) {
         this.t = t;
         this.shortMsg = shortMsg;
      }
      
      @Override
      public String toString() {
         return shortMsg ? toShortMessage(t) : toMessage(t);
      }
      
      private String toMessage(Throwable t) {
         String msg = t.getMessage();
         if (msg == null) {
            msg = t.getClass().getSimpleName();
         }
         StackTraceElement[] stack = t.getStackTrace();
         if (stack != null && stack.length > 0) {
            msg += " (@" + stack[0].getFileName() + ":" + stack[0].getLineNumber() + ")";
         }
         if (t.getCause() != null) {
            msg += " - " + toMessage(t.getCause());
         }
         return msg;
      }
      
      private String toShortMessage(Throwable ex) {
         if (Log.DEBUG) {
            StringBuilder sb = new StringBuilder();
            sb.append(ex.getClass().getSimpleName());
            String msg = ex.getMessage();
            if (msg != null) {
               sb.append(' ');
               sb.append(msg);
            }
            return sb.toString();
         }
         return ex.getClass().getSimpleName();
      }
   }
   
   private static class LogFormatter extends SimpleFormatter {
      
      private boolean logDate = true;
            
      @Override
      public synchronized String format(LogRecord lr) {
         StringBuilder sb = new StringBuilder().append(lr.getLevel().getLocalizedName());
         while (sb.length() < 8) sb.append(' ');
         if (logDate) {
            sb.insert(0, ' ');
            sb.insert(0, new Date());
         }
         sb.append(lr.getMessage());
         sb.append('\n');
         return sb.toString();
      }
   }
   
   private static class Debug extends Level {
      /**
       */
      private static final long serialVersionUID = 7353313578818371565L;

      Debug() {
         super("DEBUG", Integer.MAX_VALUE - 1);
      }
   }
   
   static class LogFile extends FileHandler {
      public LogFile(String pattern) throws IOException, SecurityException {
         super(pattern, false);
      }
   }

   public static void setLogPath(String path) {
      File f = new File(path, logger.getName() + ".log");
      setLogFile(f);
   }
   
   public static void setLogFile(File file) {
      Handler[] handlers = logger.getHandlers();
      for (Handler handler : handlers) {
         if (handler instanceof LogFile)
            logger.removeHandler(handler);
      }
      
      try {
         file.getParentFile().mkdirs();
         FileHandler fHandler = new LogFile(file.getAbsolutePath());
         fHandler.setFormatter(new LogFormatter());
         fHandler.setLevel(Level.ALL);
         logger.addHandler(fHandler);
      }
      catch (IOException ex) {}
   }
   
   public static void setShowTimestamp(boolean set) {
      Handler[] handlers = logger.getHandlers();
      for (Handler handler : handlers) {
         java.util.logging.Formatter fmttr = handler.getFormatter();
         if (fmttr instanceof LogFormatter) {
            ((LogFormatter)fmttr).logDate = set;
         }
      }
   }
}
