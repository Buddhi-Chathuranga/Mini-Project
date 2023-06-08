package ifs.cloud.build;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.logging.Level;

import ifs.cloud.build.Context.HelpException;
import ifs.cloud.build.Context.ParamException;
import ifs.cloud.build.Log.LogException;
import java.io.FilenameFilter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Builder {

   protected final Context context;

   public static void main(String[] args) {
      String logFile = null;
      for (int i = 0; i < args.length; i++) {
         if (("--logfile").equals(args[i])) {
            i++;
            if (i < args.length) {
               logFile = args[i];
               if (logFile.contains("%")) {
                  System.out.println("Patterns in log files are not supported, " + logFile);
                  logFile = null;
               }
               else
                  Log.setLogFile(new File(logFile));
            }
         }         
      } 
   
      if (logFile == null) {
         try {
            Log.setLogFile(Files.createTempFile("build-files" ,".log").toFile());
         }
         catch (IOException ex) {}
      }
      String mode = "";
      if (args.length > 0)
         mode = args[0];
      try {
         if (Log.DEBUG)
            Log.debug("args %s", Arrays.toString(args));
         Context ctx = new Context(args);
         System.exit(new Builder(ctx).run());
      }
      catch (HelpException ex) {
         System.out.println("HELP");
         if (mode.equals("create"))
            System.out.println(Context.getArgsHelp());
         else
            System.out.println(Context.getDeleteArgsHelp());
      }
      catch (ParamException | CreateException e) {
         if (mode.equals("create"))
            Log.printf(Level.SEVERE, "%s %s", e.getMessage(), Context.getArgsHelp());
         else
            Log.printf(Level.SEVERE, "%s %s", e.getMessage(), Context.getDeleteArgsHelp());
         System.exit(2);
      }
      catch (IOException e) {
         if (Log.DEBUG)
            Log.debug("%s", new LogException(e));
         Log.printf(Level.SEVERE, "%s", e.getMessage());
         System.exit(1);
      }
   }

   protected Builder(Context context) {
      this.context = context;
   }

   private int run() throws CreateException, IOException {
      File target = context.getTargetPath();
      if (!context.isDeleteFromBuildHome()) {
         target.mkdirs();
         if (target.exists() && target.isDirectory()) {
            Component.Worker cp = context.getFileList() != null ? new CommitDiff.Copier(context) : new Component.Worker(context);
            if (Log.DEBUG) {
               Log.debug("copier %s", cp);
            }
            int failed = cp.run();
            // dump install.ini file
            Util.createFilePath(context.getTargetPath(), "database").mkdirs();
            if (!context.isCreateBuildHome()) {
               Log.printf(Level.INFO, "Creating Install.ini...");
               File targetFile = Util.createFilePath(context.getTargetPath(), "database", "Install.ini");
               try (FileOutputStream fos = new FileOutputStream(targetFile)) {
                  fos.write("[ModuleConnections]\r\n".getBytes());
                  fos.write("[InstalledVersions]\r\n".getBytes());
               }
            }
            Log.printf(Level.INFO, "%s completed.", context.getMode());
            return failed;
         }
         throw new CreateException("Failed creating target folder (" + target.getAbsolutePath() + ")");
      } else {
         context.setFileNamesList(collectFiles(context.getSourcePath(), context.getCustSourcePath()));
         DeleteDiff.Deleter dl = new DeleteDiff.Deleter(context);
         if (Log.DEBUG) {
            Log.debug("deleter %s", dl);
         }
         int failed = dl.run();
         
         DeleteDiff dlef = new DeleteDiff();
         dlef.deleteEmptyFolders(context.getTargetPath(), context.isDryRun());
         
         Log.printf(Level.INFO, "%s completed.", context.getMode());
         return failed;
      }
   }

   class CreateException extends Exception {
      private static final long serialVersionUID = 5438126881638795360L;

      CreateException(String msg) {
         super(msg);
      }
   }
   
   public HashMap<String, List<String>> collectFiles(File directory, File custDirectory) {
      HashMap<String, List<String>> listOfFiles = new HashMap<>();
      List<String> fileNamesList =  new ArrayList<>();
      List<File> componentsList = new ArrayList<> (Arrays.asList(directory.listFiles(new FilenameFilter() {
         @Override
         public boolean accept(File dir, String name) {
            File tmp = new File(dir, name);
            if (tmp.isDirectory()) {
               return !name.equals(".git") && !name.equals(".svn");
            }
            return false;
         }
      })));

      for (File component : componentsList) {
         try (final Stream<Path> walk = Files.walk(Paths.get(component.getAbsolutePath()))) {
            // Filtering the paths by a regualr file and adding into a list.
            fileNamesList = walk.filter(Files::isRegularFile).map(x -> x.toString().replace("\\", "/"))
                    .collect(Collectors.toList());
            for (int j = 0; j < fileNamesList.size(); j++) {
               String fileList = fileNamesList.get(j).replaceAll(directory.toString().replace("\\", "/") + "/" + component.getName() + "/", "");
               List<String> comp = listOfFiles.get(fileList);
               if (comp == null) {
                  comp = new ArrayList<>();
                  listOfFiles.put(fileList, comp);
               }
               comp.add(component.getName());
            }
         }catch (IOException e) {
            e.printStackTrace();
         }            
      }
      
      if (custDirectory != null) {
         List<File> custComponentsList = new ArrayList<> (Arrays.asList(custDirectory.listFiles(new FilenameFilter() {
            @Override
            public boolean accept(File dir, String name) {
               File tmp = new File(dir, name);
               if (tmp.isDirectory()) {
                  return !name.equals(".git") && !name.equals(".svn");
               }
               return false;
            }
         })));      
         for (File component : custComponentsList) {
            try (final Stream<Path> walk = Files.walk(Paths.get(component.getAbsolutePath()))) {
               // Filtering the paths by a regualr file and adding into a list.
               fileNamesList = walk.filter(Files::isRegularFile).map(x -> x.toString().replace("\\", "/"))
                       .collect(Collectors.toList());
               for (int j = 0; j < fileNamesList.size(); j++) {
                  String fileList = fileNamesList.get(j).replaceAll(custDirectory.toString().replace("\\", "/") + "/" + component.getName() + "/", "");
                  List<String> comp = listOfFiles.get(fileList);
                  if (comp == null) {
                     comp = new ArrayList<>();
                     listOfFiles.put(fileList, comp);
                  }
                  if (!comp.contains(component.getName()))
                     comp.add(component.getName());
               }
            }catch (IOException e) {
               e.printStackTrace();
            }            
         }   
      }
      return listOfFiles;
   }   
}


