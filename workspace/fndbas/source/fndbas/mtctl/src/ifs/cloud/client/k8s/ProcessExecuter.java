package ifs.cloud.client.k8s;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.ProcessBuilder.Redirect;
import java.util.ArrayList;
import java.util.Scanner;

public class ProcessExecuter {

   private final ArrayList<String> commands;

   private Throwable ex = null;
   private String error = null;
   private String output = null;

   ProcessExecuter(ArrayList<String> commands) {
      this.commands = commands;
   }

   public int run(boolean waitFor) {
      try {
         ProcessBuilder pb = new ProcessBuilder(commands);
         pb.redirectError(Redirect.PIPE);
         pb.redirectOutput(Redirect.PIPE);
         Process p = pb.start();

         IOThreadHandler outputHandler = new IOThreadHandler(p.getInputStream());
         outputHandler.start();
         IOThreadHandler errorHandler = new IOThreadHandler(p.getErrorStream());
         errorHandler.start();

         if (waitFor) {
            p.waitFor();
            int exitValue = p.exitValue();
            outputHandler.waitForBuffers();
            errorHandler.waitForBuffers();
            output = outputHandler.getOutput();
            error = errorHandler.getOutput();
            return exitValue;
         }
      }
      catch (IOException e) {

         this.ex = e;
      }
      catch (InterruptedException e) {

         this.ex = e;
      }

      return Integer.MIN_VALUE;
   }

   public Throwable getExeption() {
      return ex;
   }

   public String getOutput(boolean trimmed) {
      if (trimmed)
         return output.trim().replaceAll("\r", "").replaceAll("\n", "").toString();
      return output;
   }

   public String getError(boolean trimmed) {
      if (trimmed)
         return error.trim().replaceAll("\r", "").replaceAll("\n", "").toString();
      return error;
   }

   private static class IOThreadHandler extends Thread {

      private static final String EOL = System.getProperty("line.separator");

      private InputStream inputStream;
      private StringBuilder output = new StringBuilder();

      IOThreadHandler(InputStream inputStream) {
         this.inputStream = inputStream;
      }

      public void run() {
         Scanner br = null;
         try {
            br = new Scanner(new InputStreamReader(inputStream));
            while (br.hasNextLine()) {
               output.append(br.nextLine());
               output.append(EOL);
            }
         }
         finally {
            br.close();
         }
      }

      public void waitForBuffers() {

         try {
            long t = System.currentTimeMillis() + 30000;
            while (isAlive()) {
               Thread.sleep(500);
               if (t < System.currentTimeMillis())
                  break;
            }
         }
         catch (InterruptedException ex) {}
      }
      
      public String getOutput() {

         return output.toString();
      }
   }
}