package ifs.installer;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import ifs.installer.component.DataImport;
import ifs.installer.component.DbDeploy;
import ifs.installer.component.MtInstaller;
import ifs.installer.component.MtxDbInstall;
import ifs.installer.component.MtxDbUpgrade;
import ifs.installer.component.MtxReportDbInstall;
import ifs.installer.logging.InstallerLogger;
import ifs.installer.util.Helper;
import java.util.Arrays;
import java.util.LinkedList;

public class Installer {

   private final String ACTION = "action";
   public final static String INSTALL = "install";
   public final static String MTINSTALLER = "mtinstaller";
   public final static String DELETE = "delete";
   public final static String DBINSTALLER = "dbinstaller";
   public final static String FILEXEC = "fileexec";
   public final static String MTXDBINSTALL = "mtxdbinstall";
   public final static String MTXDBUPGRADE = "mtxdbupgrade";
   public final static String MTXREPORTDBINSTALL = "mtxreportdbinstall";
   public final static String MTXREPORTDBDROP = "mtxreportdbdrop";

   private Map<String, Object> properties;
   private String[] userArgs;

   private List<String> commands = new ArrayList<>();

   private static final Logger logger = InstallerLogger.getLogger();

   private final String tmpDir;
   
   private MtInstaller mtInstaller;
   
   private static boolean breakOnDBError = false;

   public Installer(String[] args) {
      List<String> remoteOutputInfo = new ArrayList<>();;
      String currentDir = System.getProperty("user.dir");
      File ifsRoot = new File(currentDir).getParentFile().getParentFile().getParentFile();
      //running IFS Remote Solution?
      File deliveries = new File(currentDir).getParentFile().getParentFile();
      File mainConfig = new File(ifsRoot + File.separator + "config" + File.separator + "main_config.json");
      if (deliveries.getName().equalsIgnoreCase("deliveries") && mainConfig.exists()) {
         List<String> addedArguments = new LinkedList<>();
         //add default logFileLocation 
         remoteOutputInfo.add("Remote solution logFileLocation added (" + ifsRoot + File.separator + "logs" + File.separator + "ifscloudinstaller)");
         addedArguments.add("--set");
         addedArguments.add("logFileLocation="+ifsRoot + File.separator + "logs" + File.separator + "ifscloudinstaller");

         //add ifscloud_values.yaml, if exist
         File ifscloudValues = new File(ifsRoot + File.separator + "config" + File.separator + "ifscloud-values.yaml");
         if (ifscloudValues.exists()) {
            remoteOutputInfo.add("Remote solution configuration file found and is added (" + ifscloudValues.toString() + ")");
            addedArguments.add("--values");
            addedArguments.add(ifscloudValues.toString());
         }

         //add solutionset.yaml, if exist
         File solutionsetValues = new File(new File(currentDir) + File.separator + "solutionset.yaml");
         if (solutionsetValues.exists()) {
            remoteOutputInfo.add("Remote solution solution set file found and is added " + solutionsetValues.toString() + ")");
            addedArguments.add("--values");
            addedArguments.add(solutionsetValues.toString());
         }
         addedArguments.addAll(Arrays.asList(args));
         args = addedArguments.toArray(new String[addedArguments.size()]);  
         remoteOutputInfo.add("");
      }
     
      userArgs = args;
      // parse arguments and initiate properties
      try {
         properties = ArgumentParser.parse(args);
      } catch (IOException ioe) {
         System.out.println("SEVERE: Unable to parse properties - aborting");
         ioe.printStackTrace();
         System.exit(1);
      }

      breakOnDBError = ((String) properties.getOrDefault("breakOnDBError", "false")).equals("true");
      
      String ns = (String) properties.getOrDefault("global.namespace", "unknown");
      if (ns == null) {
         ns = "unknown";
      }
      // temp dir
      tmpDir = System.getProperty("java.io.tmpdir").concat(File.separator).concat("ifsinstaller_").concat((String) ns);

      // timeout
      System.setProperty("commandTimeout", String.valueOf(properties.getOrDefault("commandTimeout", 36000)));
      setup(args);
      //output if running IFS Remote Solution
      for (String s : remoteOutputInfo)
       logger.info(s);
      logger.fine("Current OS is " + (Helper.IS_WINDOWS ? "Windows" : "nix"));
   }

   private MtInstaller getMtInstaller() throws IOException {
      if (mtInstaller == null) {
         mtInstaller = new MtInstaller(userArgs, properties, tmpDir);
      }
      return mtInstaller;
   }

   private void setup(String[] args) {
      commands.add(INSTALL);
      commands.add(MTINSTALLER);
      commands.add(DBINSTALLER);
      commands.add(FILEXEC);
      commands.add(DELETE);
      commands.add(MTXDBINSTALL);
      commands.add(MTXDBUPGRADE);
      commands.add(MTXREPORTDBINSTALL);
      commands.add(MTXREPORTDBDROP);

      try {
         Level logLvl;
         if (properties.containsKey("logLevel")) {
            try {
               logLvl = Level.parse((String) properties.get("logLevel").toString().toUpperCase());
            } catch (IllegalArgumentException iae) {
               logger.warning("Invalid value for logLevel, default to WARNING");
               logLvl = Level.INFO;
            }
         } else {
            logLvl = Level.INFO;
         }
         if (((String) properties.getOrDefault("disableConsoleLogger", "false")).equalsIgnoreCase("true")) {
            InstallerLogger.disableConsoleLogger();
         }
         InstallerLogger.setLogfileLocation(
               properties.containsKey("logFileLocation") ? (String) properties.get("logFileLocation")
                     : new File(tmpDir).getAbsolutePath());
         InstallerLogger.setLogLevel(logLvl);
         // dump properties to logger once we know where to log
         logger.finest("Properties: \n" + properties.toString() + "\nEnd Properties"); // TODO, logs passwords!
      } catch (IOException e) {
         e.printStackTrace();
      }
   }

   private boolean validate() throws IOException {
      String action = (String) properties.getOrDefault(ACTION, INSTALL);
      boolean validationOk = true;
      Validator v = new Validator();
      
      if (action.equalsIgnoreCase(INSTALL) || action.equalsIgnoreCase(DBINSTALLER)) {
         validationOk = v.validateDeliveryId(properties);         
      }
      
      if (validationOk && (action.equalsIgnoreCase(INSTALL) || action.equalsIgnoreCase(MTINSTALLER))) {
         v.showKubectlConfig(properties);

         if(!Helper.getOrDefaultBoolean(properties, "skipDryRun", false)) {
            validationOk &= getMtInstaller().dryRun();
         } else {
            logger.info("Skipping dry run..");
         }
      }

      return validationOk;
   }
   
   private void install() throws IOException {
      getMtInstaller().stop();
      DbDeploy dbDeploy = new DbDeploy(properties, "");
      dbDeploy.runDbDeploy();
      if (InstallerLogger.loggedSevere() && breakOnDBError) {
         //skip execution
      } else {
         DataImport dataImport = new DataImport(properties);
         dataImport.runDataImport();
         MtxDbInstall mtxDbInstall = new MtxDbInstall(properties);
         mtxDbInstall.runDbInstall();
         MtxReportDbInstall mtxReportDbInstall = new MtxReportDbInstall(properties);
         mtxReportDbInstall.runDbInstall();
         getMtInstaller().install(Boolean.valueOf((boolean) properties.getOrDefault("ifscore.networkpolicy.enabled", false)));
      }
   }

   private void mtinstaller() throws IOException {
      getMtInstaller()
            .install(Boolean.valueOf((boolean) properties.getOrDefault("ifscore.networkpolicy.enabled", false)));
   }

   private void delete() throws IOException {
      getMtInstaller().delete();
   }

   private void dbinstaller(String action) throws IOException {
      DbDeploy dbDeploy = new DbDeploy(properties, action);
      dbDeploy.runDbDeploy();
      if (!action.equalsIgnoreCase(FILEXEC)) {
         if (InstallerLogger.loggedSevere() && breakOnDBError) {
            //skip execution
         } else {
            DataImport dataImport = new DataImport(properties);
            dataImport.runDataImport();
         }
      }
   }

   private void mtxdbinstall() throws IOException {
      MtxDbInstall mtxDbInstall = new MtxDbInstall(properties);
      mtxDbInstall.runDbInstall();
   }

   private void mtxdbupgrade() throws IOException {
      MtxDbUpgrade mtxDbUpgrade = new MtxDbUpgrade(properties);
      mtxDbUpgrade.runDbUpgrade();
   }

   private void mtxreportdbinstall() throws IOException {
      MtxReportDbInstall mtxReportDbInstall = new MtxReportDbInstall(properties);
      mtxReportDbInstall.runDbInstall();
   }
   
   private void mtxreportdbdrop() throws IOException {
      MtxReportDbInstall mtxReportDbInstall = new MtxReportDbInstall(properties);
      mtxReportDbInstall.runDbDrop();
   }

   private void runInstaller() throws IOException {
      String action = (String) properties.getOrDefault(ACTION, INSTALL);

      if (action.equalsIgnoreCase(INSTALL)) {
         install();
      } else if (action.equalsIgnoreCase(MTINSTALLER)) {
         mtinstaller();
      } else if (action.equalsIgnoreCase(DELETE)) {
         delete();
      } else if (action.equalsIgnoreCase(DBINSTALLER) || action.equalsIgnoreCase(FILEXEC)) {
         dbinstaller(action);
      } else if (action.equalsIgnoreCase(MTXDBINSTALL)) {
         mtxdbinstall();
      } else if (action.equalsIgnoreCase(MTXDBUPGRADE)) {
         mtxdbupgrade();
      } else if (action.equalsIgnoreCase(MTXREPORTDBINSTALL)) {
         mtxreportdbinstall();
      } else if (action.equalsIgnoreCase(MTXREPORTDBDROP)) {
         mtxreportdbdrop();
      } else {
         String suggestion = Helper.checkCommand(commands, action);
         logger.warning(
               "Invalid action " + action + (action.equals(suggestion) ? "" : " - Did you mean " + suggestion + "?"));
      }
   }

   public static boolean getBreakOnDBError() {
      return breakOnDBError;
   }
   
   public static void main(String[] args) {
      Installer installer = new Installer(args);
      try {
         if (!installer.validate()) {
            logger.severe("Validation failed.");
            System.exit(1);
         }
      } catch (IOException e) {
         logger.severe("IOException while performing system validation. " + e);
      } catch (IllegalArgumentException e) {
         logger.severe("IllegalArgumentException while performing system validation. " + e.getMessage());      
      }

      try {
         installer.runInstaller();
      } catch (IOException | IllegalArgumentException ioe) {
         logger.severe("Fatal exception during execution: " + ioe);
      }
      
      //depending on message logged level, the exitCode will be set, default 0, for level SEVERE 1
      System.exit(InstallerLogger.loggedSevere() ? 1 : 0);
   }
}
