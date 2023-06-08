package ifs.cloud.client.logger;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.util.Date;
import java.util.StringTokenizer;

public class Logger {
   /* default log level */
   private static Level logLevel = Level.L5;

   public enum Level {
      // 9 - allways, 1,2,3 debug 4 info, 5 status, 6 warning, 7 critical
      L1(1), L2(2), L3(3), L4(4), L5(5), L6(6), L7(7), L9(9);

      private final int level;

      Level(int level) {
         this.level = level;
      }

      String asString() {
         return "<" + level + ">";
      }

      /* 
       * > 0 if this is larger than given level * = 0 if this is equals to given
       * level * < 0 if this is smaller than given level *
       */
      int compare(Level level) {
         return this.level == L9.level ? 1 : this.level - level.level;
      }
   }

   public static Level getLogLevel() {
      return logLevel;
   }

   public static void setLogLevel(Level logLevel) {
      Logger.logLevel = logLevel;
   }

   public static void progln(Level level, Object... args) {
      if (level.compare(logLevel) >= 0) {
         synchronized (logLevel) {
            log(level, args);
            logCont(level, "...");
            logEndCont(level);
         }
      }
   }

   public static void logln(Level level, Object... args) {
      logObjects(level, true, args);
   }

   public static void logln(Level level) {
      logObjects(level, true, " ");
   }

   private static String toString(Object... args) {
      StringBuilder sb = new StringBuilder();
      for (Object obj : args) {
         if (sb.length() > 0)
            sb.append(' ');
         if (obj instanceof Object[]) {
            Object[] o = (Object[]) obj;
            for (int i = 0; i < o.length; i++)
               sb.append(toString(o[i]));
         }
         else if (obj instanceof int[]) {
            int[] o = (int[]) obj;
            sb.append('[');
            for (int i = 0; i < o.length; i++)
               sb.append(toString(o[i])).append(',');
            sb.append(']');
         }
         else if (obj instanceof Throwable) {
            sb.append(toString((Throwable) obj));
         }
         else {
            sb.append(obj);
         }
      }
      return sb.toString();
   }

   /* continue printing on the same line */
   public static void logCont(Level level, Object... args) {
      if (level.compare(logLevel) >= 0) {
         print("", toString(args), level == Level.L9 ? System.out : System.err);
      }
   }
   
   /* end the current line */
   public static void logEndCont(Level level) {
      if (level.compare(logLevel) >= 0) {
         (level == Level.L9 ? System.out : System.err).println();
      }
   }

   private static void print(String header, String msg, PrintStream ps) {
      synchronized (logLevel) {
         boolean newline = false;
         StringTokenizer st = new StringTokenizer(msg, "\n\r");
         while (st.hasMoreTokens()) {
            if (newline)
               ps.println();
            newline = true;
            ps.print(header);
            ps.print(st.nextToken());
         }
      }
   }

   public static void log(Level level, Object... args) {
      logObjects(level, false, args);
   }

   private static void logObjects(Level level, boolean newLn, Object... args) {
      if (level.compare(logLevel) >= 0) {
         synchronized (logLevel) {
            String header = level == Level.L9 ? "" : new StringBuilder().append(new Date()).append(' ').append(level).append(" - ").toString();
            PrintStream ps = level == Level.L9 ? System.out : System.err;
            print(header, toString(args), ps);
            if (newLn)
               ps.println();
         }
      }
   }

   private static String toString(Throwable t) {
      ByteArrayOutputStream bos = new ByteArrayOutputStream();
      PrintStream ps = new PrintStream(bos);
      t.printStackTrace(ps);
      return bos.toString();
   }

   public static String toMessage(Throwable t) {
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
}
