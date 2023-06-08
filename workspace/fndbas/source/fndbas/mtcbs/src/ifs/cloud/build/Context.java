package ifs.cloud.build;

import java.io.File;
import java.nio.file.CopyOption;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;

public final class Context {

   enum Mode {
      Undefined, CreateBuildHome, CreateDelivery, DeleteFiles
   }

   final static String buildHomeArg = "buildhome";
   final static String deliveryArg = "delivery";
   final static String componentsArg = "components";
   final static String custComponentsArg = "custcomponents";
   final static String fileListNameArg = "filelistname";
   final static String overwriteArg = "overwrite";
   final static String deleteArg = "delete";
   final static String createArg = "create";
   final static String dryRunArg = "dryrun";
   
   private File source;
   private File custSource;
   private File target;
   private Mode mode = Mode.Undefined;
   private boolean update = false;
   private boolean overwrite = false;
   private boolean delete = false;
   private boolean create = true;
   private boolean dryRun = false;
   private String fileList = null;
   
   private HashMap<String, List<String>> fileNamesList = new HashMap<>();
   
   Context(String[] args) throws ParamException {      
      String componentsPath = null, custComponentsPath = null, buildHomePath = null, deliveryPath = null;
      String logFile = null;
      for (int i = 0; i < args.length; i++) {
         if ((createArg).equals(args[i]) && i == 0) {
            this.create = true;
            this.delete = false;
         }
         else if ((deleteArg).equals(args[i]) && i == 0) {
            this.create = false;
            this.delete = true;
         }            
         else if (("--" + componentsArg).equals(args[i])) {
            i++;
            if (i < args.length) {
               componentsPath = args[i];
            }
         }
         else if (("--" + custComponentsArg).equals(args[i])) {
            i++;
            if (i < args.length) {
               custComponentsPath = args[i];
            }
         }         
         else if (("--" + fileListNameArg).equals(args[i])) {
            i++;
            if (i < args.length) {
               this.fileList = args[i];
            }
         }         
         else if (("--" + buildHomeArg).equals(args[i])) {
            i++;
            if (i < args.length) {
               buildHomePath = args[i];
            }
         }
         else if (("--" + deliveryArg).equals(args[i])) {
            i++;
            if (i < args.length) {
               deliveryPath = args[i];
            }
         }
         else if (("--" + overwriteArg).equals(args[i])) {
            this.overwrite = true;
         }
         else if (("--" + dryRunArg).equals(args[i])) {
            this.dryRun = true;
         }         
         else if (("--logfile").equals(args[i])) {
            //internal for script
            i++;
            if (i < args.length) {
               logFile = args[i];
            }
         }         
         else if (("--help").equals(args[i])) {
            throw new HelpException();
         }
         else {
            throw new ParamException("Unknown argument: " + args[i]);
         }
      }
      if (Log.DEBUG) {
         Log.debug("current folder: %s", new File("").getAbsoluteFile());
      }
                   
      if (create && deliveryPath != null) {
         mode = Mode.CreateDelivery;
         this.target = new File(deliveryPath);
         if (logFile == null) {
            logFile = target + File.separator + "build-files.log";
            Log.setLogFile(new File(logFile));
         }
         //Destination can exist and can contain e.g core code when copying cust code
         boolean isTargetEmpty = overwrite || checkTargetEmpty(target, logFile);
         if (!isTargetEmpty) {
            throw new ParamException(mode + ": folder path '" + deliveryArg + "' (" + target + ") already exists and not empty.");
         }
         if (componentsPath == null) {
            throw new ParamException(mode + ": argument '" + componentsArg + "' is mandatory in delivery mode.");
         }
         this.source = new File(componentsPath);
         validateSourceFolder(componentsArg);
         
         if (fileList != null) {
            File tmp = new File(fileList);
            if (!tmp.exists() || !tmp.isFile()) {
               throw new ParamException(fileList + " is not a valid file list file.");
            }
         }
      }
      else if (create && buildHomePath != null) {
         mode = Mode.CreateBuildHome;
         this.target = new File(buildHomePath);
         if (logFile == null) {
            logFile = target + File.separator + "build-files.log";
            Log.setLogFile(new File(logFile));
         }         
         //Destination can exist and can contain e.g core code when copying cust code
         boolean isTargetEmpty = overwrite || checkTargetEmpty(target, logFile);
         if (!isTargetEmpty) {
            throw new ParamException(mode + ": folder path '" + buildHomeArg + "' (" + target + ") already exists and not empty.");
         }
         if (Log.DEBUG) Log.debug("buildHomePath: %s", buildHomePath);
         fileList = null;
         update = false;
         this.source = (componentsPath == null) ? constructPathToComponents() : new File(componentsPath);
         validateSourceFolder(componentsArg);
      }      
      else if (delete && buildHomePath != null && fileList != null && componentsPath != null) {
         mode = Mode.DeleteFiles;
         this.target = new File(buildHomePath);
         if (logFile == null) {
            logFile = target + File.separator + "delete-files.log";
            Log.setLogFile(new File(logFile));
         }
         if (Log.DEBUG) Log.debug("buildHomePath: %s", buildHomePath);
         this.source = new File(componentsPath);
         validateFolder(this.source, componentsArg);
         if (custComponentsPath != null) {
            this.custSource = new File(custComponentsPath);
            validateFolder(this.custSource, custComponentsPath);
         }         
         this.target = new File(buildHomePath);
         validateFolder(this.target, buildHomeArg);
         File tmp = new File(fileList);
         if (!tmp.exists() || !tmp.isFile()) {
           throw new ParamException(fileList + " is not a valid file list file.");
         }
      }
      else {
         if (create)
            throw new ParamException("One of '" + buildHomeArg + "' or '" + deliveryArg + "' must be supplied.");
         else
            throw new ParamException("Arguments '" + buildHomeArg + "', '" + fileListNameArg + "' and '" + componentsArg + "' must be supplied.");
      }
      Log.printf(Level.INFO, "Mode: %s", mode);
      if (this.source != null)
         Log.printf(Level.INFO, "Source: %s", source.getAbsolutePath());
      if (this.custSource != null)
         Log.printf(Level.INFO, "Cust Source: %s", custSource.getAbsolutePath());      
      if (this.fileList != null)
         Log.printf(Level.INFO, "File List: %s", this.fileList);      
      Log.printf(Level.INFO, "Target: %s", target.getAbsolutePath());
   }

   private boolean checkTargetEmpty(File target, String logFile) {
      Log.printf(Level.INFO, "Validating target folder: %s", target.getAbsolutePath());
      if (target.exists()) {
         File[] files = target.listFiles();
         int fileCount = files.length;
         if (fileCount > 0 && logFile != null) {
            File lf = new File(logFile);
            if (lf.getParentFile().equals(target)) {
               String lfname = lf.getAbsolutePath().toLowerCase();
               for (int i = 0; i < files.length; i++) {
                  if (files[i].getAbsolutePath().toLowerCase().startsWith(lfname)) {
                     fileCount--;
                  }
               }
            }
         }
         Log.printf(Level.INFO, "Target folder already contains %d files.", fileCount);
         return fileCount <= 0;
      }
      return true;
   }

   protected void validateSourceFolder(String msg) throws ParamException {
      Log.printf(Level.INFO, "Validating folder: %s", source.getAbsolutePath());
      if (!this.source.exists() || !this.source.isDirectory()) {
         throw new ParamException(mode + ": path supplied for '" + msg + "' (" + source + ") does not exist or not a folder.");
      }
   }

   protected void validateFolder(File folder, String msg) throws ParamException {
      Log.printf(Level.INFO, "Validating folder: %s", folder.getAbsolutePath());
      if (!folder.exists() || !folder.isDirectory()) {
         throw new ParamException(mode + ": path supplied for '" + msg + "' (" + folder + ") does not exist or not a folder.");
      }
   }   

   private File constructPathToComponents() throws ParamException {
      return new File("").getAbsoluteFile().getParentFile().getParentFile();
   }

   File getSourcePath() {
      return source;
   }
   
   File getCustSourcePath() {
      return custSource;
   }   

   String getFileList() {
      return fileList;
   }   
   
   File getTargetPath() {
      return target;
   }
   
   Mode getMode() {
      return mode;
   }
   
   boolean isDryRun() {
      return dryRun;
   }   

   public void setFileNamesList(HashMap<String, List<String>> fileNamesList) {
      this.fileNamesList = fileNamesList;
   }

   HashMap<String, List<String>> getFileNamesList() {
      return fileNamesList;
   }
   
   boolean isCreateBuildHome() {
      return mode == Mode.CreateBuildHome;
   }
   
   boolean isDeleteFromBuildHome() {
      return mode == Mode.DeleteFiles;
   }   

   boolean tryUpdate() {
      return update;
   }

   String modeToString() {
      switch (this.mode) {
      case CreateBuildHome:
         return "build home";
      case CreateDelivery:
         return "delivery";
      default:
         return "Unknown";
      }
   }

   static String getArgsHelp() {
      StringBuilder sb = new StringBuilder();
      sb.append('\n');
      sb.append("Available arguments:\n");
      sb.append("--").append(buildHomeArg).append(" path\n");
      sb.append("--").append(deliveryArg).append(" path\n");
      sb.append("--").append(componentsArg).append(" path\n");
      sb.append("--").append(fileListNameArg).append(" path\n");
      sb.append("--").append(overwriteArg).append('\n');     
      sb.append("Notes:\n");
      sb.append(" * When the argument '").append(deliveryArg).append("' is supplied, the folder structure is created for a delivery.\n");
      sb.append("   --").append(deliveryArg).append(" valid empty folder with write permission.\n");
      sb.append("   --").append(componentsArg).append(" valid folder containing the delivery checkout.\n");
      sb.append("   --").append(fileListNameArg).append(" optional. If supplied, only listed files will be copied from ").append(componentsArg).append(".\n");
      sb.append("   --").append(overwriteArg).append(" optional flag. If supplied, existing files in target will be overwritten, default false.\n");     
      sb.append("   --logfile optional. Defaults to --").append(deliveryArg).append("/build-files.log.\n");
      sb.append(" * When argument '").append(buildHomeArg).append("' is supplied without the argument '").append(deliveryArg).append("', fresh build home is created.\n");
      sb.append("   --").append(buildHomeArg).append(" valid empty folder with write permission.\n");
      sb.append("   --").append(componentsArg).append(" optional. If supplied, it should be a valid components checkout.\n");
      sb.append("   --").append(overwriteArg).append(" optional flag. If supplied, existing files in target will be overwritten, default false.\n");
      sb.append("   --logfile optional. Defaults to --").append(buildHomeArg).append("/build-files.log.\n");      
      
      return sb.toString();
   }
   
   static String getDeleteArgsHelp() {
      StringBuilder sb = new StringBuilder();
      sb.append('\n');
      sb.append("Available arguments:\n");
      sb.append("--").append(buildHomeArg).append(" path\n");
      sb.append("--").append(componentsArg).append(" path\n");
      sb.append("--").append(custComponentsArg).append(" path\n");
      sb.append("--").append(fileListNameArg).append(" path\n");
      sb.append("--").append(dryRunArg).append("\n");
      sb.append("Notes:\n");
      sb.append(" * Deletion of files according to given filelist will be performed in given build home.\n");
      sb.append("   --").append(buildHomeArg).append(" mandatory. Valid folder containing files to be deleted.\n");         
      sb.append("   --").append(componentsArg).append(" mandatory. Used to validate deleted filelist, are files really deleted.\n");
      sb.append("   --").append(custComponentsArg).append(" optional. Additional validation, are files really deleted.\n");  
      sb.append("   --").append(fileListNameArg).append(" mandatory. A list of files to be deleted from the given build home.\n");      
      sb.append("   --logfile optional. Defaults to --").append(buildHomeArg).append("/delete-files.log.\n");
      sb.append("   --").append(dryRunArg).append(" optional flag. If supplied, no delete will occur, only logging.\n");
      
      return sb.toString();
   }   
   
   class ParamException extends Exception {
      private static final long serialVersionUID = -5335208496067576425L;

      public ParamException(String msg) {
         super(msg);
      }
      
      ParamException() {}
   }
   
   class HelpException extends ParamException {
      private static final long serialVersionUID = -5335208496067243425L;

      public HelpException() {
      }
   }

   public CopyOption [] GetCopyOptions() {
      CopyOption [] options;
      if (overwrite) {
         options = new CopyOption[2];
         options[0] = StandardCopyOption.COPY_ATTRIBUTES;
         options[1] = StandardCopyOption.REPLACE_EXISTING;
      } else {
         options = new CopyOption[1];
         options[0] = StandardCopyOption.COPY_ATTRIBUTES;
      }
      return options;
   }
}
