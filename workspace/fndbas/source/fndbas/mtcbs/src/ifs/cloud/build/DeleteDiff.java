package ifs.cloud.build;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;

import ifs.cloud.build.Component.WorkingThread;

class DeleteDiff {
   
   private int deletedFolders = 0;
   
   static class Deleter extends Component.Worker {

      Deleter(Context context) {
         super(context);
      }

      private String[] makePathParts(String path) throws IOException {
         // path -> accrul/model/accrul/AccrulUtility.utility
         // 0th element must be the component
         path = path.trim().replace("\\", "/");
         if (path.length() == 0)
            return new String[0];
         if (path.charAt(0) == '/')
            throw new IOException("Invalid path " + path);
         return path.split("/");
      }

      @Override
      WorkingThread[] createThreads() throws IOException {
         HashMap<File, ArrayList<String[]>> componentFiles = new HashMap<>();
         try (BufferedReader input = new BufferedReader(new FileReader(context.getFileList()))) {
            File component = null;
            String line;
            while ((line = input.readLine()) != null) {
               String[] pathParts = makePathParts(line);
               if (pathParts.length > 1) {
                  component = Util.createFilePath(context.getTargetPath(), pathParts[0]);
                  ArrayList<String[]> comp = componentFiles.get(component);
                  if (comp == null) {
                     comp = new ArrayList<>();
                     componentFiles.put(component, comp);
                  }
                  comp.add(pathParts);
               }
            }
         }
         ListDeleteThread[] cthreads = new ListDeleteThread[componentFiles.size()];
         Log.printf(Level.INFO, "%d component%s found.", cthreads.length, cthreads.length > 1 ? "s": "");
         int i = 0;
         for (HashMap.Entry<File, ArrayList<String[]>> entry : componentFiles.entrySet()) {
            cthreads[i] = new ListDeleteThread(context, entry.getKey(), entry.getValue());
            cthreads[i].start();
            i++;
         }
         return cthreads;
      }
   }

   private static class ListDeleteThread extends Component.WorkingThread {

      private final List<String[]> files;

      ListDeleteThread(Context context, File component, List<String[]> files) {
         super(context, component);
         this.files = files;
      }

      private File createTargetPath(File parent, String... paths) {
         File f = parent;
         for (int i = 1; i < paths.length; i++) {
            f = new File(f, paths[i]);
         }
         return f;
      }
      
      private String createStringFromArray(int start, String delimeter, String... paths ) {
         String s ="";
         for (int i = start; i < paths.length; i++) {
            s = s.equals("") ? paths[i] : s + delimeter +  paths[i];
         }
         return s;
      }      
      
      private String createStringFromList(String delimeter, List paths ) {
         String s ="";
         for (int i = 0; i < paths.size(); i++) {
            s = s.equals("") ? paths.get(i).toString() : s + delimeter +  paths.get(i).toString();
         }
         return s;
      } 

      @Override
      void delete() {
         HashMap<String, List<String>> fileNamesList = context.getFileNamesList();
         for (String[] pathParts : files) {
            // pathParts contain more than 2 items, checked before adding
            if (!excluded(pathParts[1]) || "deploy.ini".equals(pathParts[1])) {
               File targetFile = createTargetPath(context.getTargetPath(), pathParts);
               if ("deploy.ini".equals(pathParts[1])) {
                  String name = Util.titleCase(component.getName());
                  targetFile = Util.createFilePath(context.getTargetPath(), "database", name + ".ini");
               }
               if (targetFile.exists()) {
                  String checkPath = createStringFromArray(1, "/", pathParts );
                  if (fileNamesList.containsKey(checkPath) && !"deploy.ini".equals(pathParts[1])) {
                     Log.printf(Level.WARNING, " Deleted file " + createStringFromArray(0, File.separator, pathParts ) + " cannot be deleted from <build_home>\n" +
                    "\tThe file still exist in component%s " + createStringFromList(",", fileNamesList.get(checkPath)), fileNamesList.get(checkPath).size() > 1 ? "s" : "");
                     warnings++;
                  } else if ("deploy.ini".equals(pathParts[1]) && fileNamesList.get("deploy.ini").contains(pathParts[0])) {
                     Log.printf(Level.WARNING, " Deleted file " + createStringFromArray(0, File.separator, pathParts ) + " cannot be deleted from <build_home>\n" +
                    "\tThe file still exist in component " + pathParts[0]);
                     warnings++;   
                  } else {
                     if (Log.DEBUG)
                        Log.debug("File to be deleted: " + targetFile);
                     if (context.isDryRun())
                        Log.printf(Level.INFO, "File to be deleted: " + targetFile);   
                     else {
                        targetFile.delete();
                        Log.printf(Level.INFO, "Deleted file: " + targetFile);
                        deleted++;
                     }
                  }
               } else {
                  if (Log.DEBUG )
                     Log.debug("File already deleted: " + targetFile);
                  if (context.isDryRun())
                     Log.printf(Level.INFO, "File already deleted: " + targetFile); 
                  alreadyDeleted++;
               } 
               processed++;
            }
         }
      }
      
      @Override
      void copy() {
         //Nothing to be done here;
      }   
      
      @Override
      void createDeployIni() {
         //Nothing to be done here;
      }   
   }
   
   public void deleteEmptyFolders(File path, boolean isDryRun) {
      deletedFolders = 0;
      Log.printf(Level.INFO, "Searching for empty folders to delete... ");
      if (isDryRun)
         Log.printf(Level.INFO, "NOTE! Only already empty folders will be listed, no deletion of files has be executed, running --dryrun"); 
      deleteEmptyFoldersRecursively(path, isDryRun);
      Log.printf(Level.INFO, "%d folder%s deleted.", deletedFolders, deletedFolders > 1 ? "s": "");
   }      

   private boolean deleteEmptyFoldersRecursively(File path, boolean isDryRun) {
      if(path.isDirectory()){
         File[] files = path.listFiles();
         if(files.length == 0){ //There is no file in this folder - safe to delete
             return true;
         } else {
             for(File f : files){
                 if(f.isDirectory()){
                     if(deleteEmptyFoldersRecursively(f, isDryRun)){ //safe to delete
                        if (isDryRun) {
                           Log.printf(Level.INFO, "Folder to be deleted: " + f.getAbsolutePath()); 
                        } else {
                           if (f.delete()) {
                              Log.printf(Level.INFO,"Folder deleted: " + f.getAbsolutePath());
                              deletedFolders++;
                           } else
                              Log.printf(Level.INFO,"Folder could not be deleted: " + f.getAbsolutePath());
                        } 
                     }
                 }
             }
            File[] filesCount = path.listFiles();
            if(filesCount.length == 0){ //There is no file in this folder - safe to delete
               return true;
            }             
         }
     }
     return false;
   }  
}