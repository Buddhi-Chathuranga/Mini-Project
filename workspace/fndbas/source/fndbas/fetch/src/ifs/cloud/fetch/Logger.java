package ifs.cloud.fetch;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.StringTokenizer;
import java.util.logging.ConsoleHandler;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.SimpleFormatter;

public class Logger {
   public static final Details ALLWAYS = new Details();
   private static final String NEW_LINE = "\n";

   private final java.util.logging.Logger logger;

   private final ConsoleHandler consoleHandler;

   Logger() {
      java.util.logging.Logger mainLogger = java.util.logging.Logger.getLogger("ifs-fetch");
      mainLogger.setUseParentHandlers(false);
      mainLogger.setLevel(Level.ALL);
      /* console */
      consoleHandler = new ConsoleHandler();
      consoleHandler.setFormatter(new LogFormatter());
      mainLogger.addHandler(consoleHandler);
      try {
         String fetchLog = System.getenv("FETCH_LOG");
         if (fetchLog != null) {
            File f = new File(fetchLog);
            f.getParentFile().mkdirs();
            FileHandler fHandler = new FileHandler(f.getAbsolutePath(), false);
            fHandler.setFormatter(new LogFormatter());
            fHandler.setLevel(Level.ALL);
            mainLogger.addHandler(fHandler);
         }
      }
      catch (IOException ex) {}
      this.logger = mainLogger;
   }

   void setLogLevel(Level level) {
      consoleHandler.setLevel(level);
   }

   public void log(Level level, Object... objects) {
      StringBuilder sb = new StringBuilder();
      for (int i = 0; i < objects.length; i++) {
         sb.append(toString(objects[i]));
         sb.append(' ');
      }
      StringTokenizer st = new StringTokenizer(sb.toString(), NEW_LINE);
      while (st.hasMoreElements()) {
         logger.log(level, st.nextToken());
      }
   }

   private String toString(Object object) {

      if (object instanceof Throwable) {
         return toString((Throwable) object);
      }
      return object == null ? "<null>" : object.toString();
   }

   private String toString(Throwable t) {

      StringBuilder sb = new StringBuilder().append(t.getClass().getSimpleName());
      String msg = t.getMessage();
      if (msg != null) {
         sb.append(" - Message : ");
         sb.append(msg);
         msg = sb.toString();
      }
      StackTraceElement[] stack = t.getStackTrace();
      if (stack.length > 0) {
         StackTraceElement stackLine = stack[0];
         sb.append(" (").append(stackLine.getFileName()).append(":").append(stackLine.getLineNumber()).append(')').toString();
      }
      if (t.getCause() != null) {

         sb.append(NEW_LINE).append(" ..caused by: ").append(toString(t.getCause())).toString();
      }
      return sb.toString();
   }

   private static class Details extends Level {
      /**
       */
      private static final long serialVersionUID = 7353313578818371565L;

      Details() {
         super("DETAIL", Integer.MAX_VALUE - 1);
      }
   }

   static class LogFormatter extends SimpleFormatter {
      @Override
      public synchronized String format(LogRecord lr) {
         StringBuilder level = new StringBuilder().append(lr.getLevel().getLocalizedName());
         while (level.length() < 7) level.append(' ');         
         StringBuilder sb = new StringBuilder().append(new Date()).append(" [").append(level.toString()).append("] ");
         sb.append(lr.getMessage());
         sb.append(NEW_LINE);
         return sb.toString();
      }
   }
}
