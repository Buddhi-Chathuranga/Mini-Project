package ifs.cloud.build;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.util.logging.Level;

import ifs.cloud.build.Log.LogException;

class Component {
   
   static class Worker {
      protected final Context context;

      Worker(Context context) {
         this.context = context;
      }

      WorkingThread[] createThreads() throws IOException {
         File[] components = context.getSourcePath().listFiles(new FilenameFilter() {
            @Override
            public boolean accept(File dir, String name) {
               File tmp = new File(dir, name);
               if (tmp.isDirectory()) {
                  return !name.equals(".git") && !name.equals(".svn");
               }
               return false;
            }
         });

         Log.printf(Level.INFO, "%d component%s found.", components.length, components.length > 1 ? "s": "");
         WorkingThread[] cthreads = new WorkingThread[components.length];
         for (int i = 0; i < components.length; i++) {
            cthreads[i] = new WorkingThread(context, components[i]);
            cthreads[i].start();
         }
         return cthreads;
      }

      int run() throws IOException {
         Log.printf(Level.INFO, "Searching for components...");
         WorkingThread[] cthreads = createThreads();
         if (!context.isDeleteFromBuildHome())
            Log.printf(Level.INFO, "Creating %s structure...", context.modeToString());
         while (true) {
            boolean alive = false;
            for (int i = 0; i < cthreads.length; i++) {
               if (cthreads[i].isAlive()) {
                  alive = true;
                  break;
               }
            }
            if (!alive)
               break;
            try {
               Thread.sleep(5000);
            }
            catch (InterruptedException ex) {}
         }
         int failed = 0, count = 0, countDeleted = 0, countAlreadyDeleted = 0, countProcessed = 0, countWarnings = 0;
         for (int i = 0; i < cthreads.length; i++) {
            if (cthreads[i].failed()) {
               failed++;
               if (cthreads[i].getFailedCount() > 0) {
                  Log.printf(Level.INFO, "%s - %d error%s.", cthreads[i].getName(), cthreads[i].getFailedCount(), (cthreads[i].getFailedCount() > 1 ? "s" : ""));
               }
            }
            count += cthreads[i].getCopiedCount();
            countDeleted += cthreads[i].getDeletedCount();
            countAlreadyDeleted += cthreads[i].getAlreadyDeletedCount();
            countProcessed += cthreads[i].getProcessedCount();
            countWarnings += cthreads[i].getWarningsCount();
         }
         if (failed > 0)
            Log.printf(Level.INFO, "%d component%s failed.", failed, failed > 1 ? "s": "");
         if (context.isDeleteFromBuildHome()) {
            Log.printf(Level.INFO, "%d file%s already deleted.", countAlreadyDeleted, countAlreadyDeleted > 1 ? "s": "");
            Log.printf(Level.INFO, "%d file%s deleted.", countDeleted, countDeleted > 1 ? "s": "");
            if (countWarnings > 0)
               Log.printf(Level.INFO, "%d file%s not deleted.", countWarnings, countWarnings > 1 ? "s": "");
            Log.printf(Level.INFO, "%d file%s processed.", countProcessed, countProcessed > 1 ? "s": "");            
         } else {
            Log.printf(Level.INFO, "%d file%s copied.", count, count > 1 ? "s": "");
         }
         return failed;
      }
   }

   static class WorkingThread extends java.lang.Thread {
      protected final File component;
      protected final Context context;
      protected final CopyOption[] options;
      protected int copied = 0, failed = 0, deleted = 0, alreadyDeleted= 0, processed = 0, warnings = 0; 

      WorkingThread(Context context, File component) {
         this.component = component;
         this.context = context;
         this.options = context.GetCopyOptions();
         super.setName(component.getName());
      }

      @Override
      public void run() {
         copy();
         delete();
         deleteEmptyFoldes();
         createDeployIni();
      }

      boolean failed() {
         return failed > 0;
      }

      int getCopiedCount() {
         return copied;
      }

      int getFailedCount() {
         return failed;
      }

      int getDeletedCount() {
         return deleted;
      }
      
      int getAlreadyDeletedCount() {
         return alreadyDeleted;
      }
      
      int getProcessedCount() {
         return processed;
      }
      
      int getWarningsCount() {
         return warnings;
      }
      
      void copy() {
         File[] files = component.listFiles();
         for (File file : files) {
            if (!excluded(file.getName())) {
               copyToTarget(file, context.getTargetPath());
            }
         }
      }
      
      void delete() {}

      void deleteEmptyFoldes() {}
      
      void createDeployIni() {
         // rename deploy.ini in component to database/{component}.ini
         try {
            File deployIni = new File(component, "deploy.ini");
            if (deployIni.exists()) {
               String name = Util.titleCase(component.getName());
               File targetFile = Util.createFilePath(context.getTargetPath(), "database", name + ".ini");
               targetFile.getParentFile().mkdirs();
               Files.copy(deployIni.toPath(), targetFile.toPath(), options);
            }
         }
         catch (IOException ex) {
            failed++;
         }
      }

      boolean excluded(String file) {
         // folders and files to exclude in component level
         return file.equals("nobuild") || file.equals("deploy.ini");
      }

      private void copyToTarget(File source, File target) {
         String name = source.getName();
         File tmp = new File(target, name);
         if (source.isDirectory()) {
            tmp.mkdirs();
            File[] files = source.listFiles();
            for (File file : files) {
               copyToTarget(file, tmp);
            }
         }
         else {
            try {
               synchronized(context) {
                  Files.copy(source.toPath(), tmp.toPath(), options);
               }               
               copied++;
            }
            catch (IOException ex) {
               Log.printf(Level.WARNING, "Copy error (%s) %s %s", component.getName(), source.getName(), new LogException(ex, true));
               failed++;
            }
         }
      }

      @Override
      public String toString() {
         return component.getName();
      }
   }
}