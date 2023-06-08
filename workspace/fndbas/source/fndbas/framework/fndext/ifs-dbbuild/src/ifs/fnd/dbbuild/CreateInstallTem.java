/*=====================================================================================
 * CreateInstallTem.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =============================================
 * Apps9       2013-04-24  StDafi     Merge of db code and generating all tem files
 * ================================================================================
 */
package ifs.fnd.dbbuild;
import ifs.fnd.dbbuild.databaseinstaller.DBConnection;
import ifs.fnd.dbbuild.databaseinstaller.DbBuildException;
import ifs.fnd.dbbuild.databaseinstaller.DbInstallerUtil;
import ifs.fnd.dbbuild.databaseinstaller.SolutionSet;
import ifs.fnd.dbbuild.databaseinstaller.SolutionSetConfig;
import ifs.fnd.dbbuild.databaseinstaller.SolutionSetYamlDefinition;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.regex.Pattern;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.scanner.ScannerException;
import java.io.FileNotFoundException;
import java.io.FilenameFilter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.Map;

/**
 *
 * @author stdafi
 */
public final class CreateInstallTem{   
   // Names of parameters used by the CreateInstallTem
   private String _executionType = "";
   private String _templatePath = "";
   private String _buildHomePath = "";
   private String _buildHomeDbPath = "";
   private String _deliveryPath = "";
   private String _deliveryDBPath = "";
   private String _component = "";
   private String _extension = "";
   private String _option = "";
   
   /* UserName to application owner */
   private String userName = "";
   /* Password to application owner */
   private String password = "";
   /* ConnectString to access the database */
   private String connectString = "";   
   
   // Boolean merge can be set to false, by setting property option to noMerge.
   // This means only *.tem and *up.xxx files will be (re)created.
   // If _buildHomePath is different from _deliveryPath (delivery defined), the merge will be set to true. (logic in initialize).
   //
   // The boolean merge shall as default be defined as true, all file merge and creation of tem files will be created.
   private boolean merge = true;
   
   // Used for logic if install.ini should be regenerated or not. 
   // True if delivery set AND new db folder/files found on delivery after generating db code.
   // If install.ini is missing in database folder (e.g. manually removed by purpose), the property will be set to true, to regenerate the file.
   private boolean regenerateInstallIni = false;
   
   // Normal creation of install.tem is in "installTemAdvance" mode.
   // Boolean installTemAdvance can be set to false, by setting property option to noAdvance. If installTemAdvance set to false, the install.tem 
   // will be sorted on file type before component, instead of component before file type which would be the normal scenario. 
   // In addition all threading information will be removed from created tem files, meaning that the files will be deployed in one single sequence when using 
   // the IFS Application Installer (i.e no parallell/threaded deployment will occur).   
   private boolean installTemAdvance = true;   
   
   // Normally creation of tem files should be performed.
   // Boolean doCreateInstallTem can be set to false, by setting property option to noInstallTem.
   private boolean doCreateInstallTem = true;
   // Boolean deliverySet will be set to true in startup if buildHomePath differs from deliveryPath.
   private boolean deliverySet = false;
     
   //initialize, start
   //key in lowercase
   private final HashMap<String, String> iniFiles = new HashMap<>();
   private final HashMap<String, List<String>> mergedFiles = new HashMap<>();
   private final HashMap<String, String> temFiles = new HashMap<>();
   private final HashMap<String, String> subDirectories = new HashMap<>();
   private final HashMap<String, String> componentNames = new HashMap<>();
   private final HashMap<String, String> componentShortNames = new HashMap<>();
   private final HashMap<String, String> componentDescriptions = new HashMap<>();
   private final HashMap<String, List<String>> componentDefines = new HashMap<>();
   private final HashMap<String, String> componentVersions = new HashMap<>();
   private final HashMap<String, String> preComponents = new HashMap<>();
   private final HashMap<String, String> componentFreshVersions = new HashMap<>();
   private final HashMap<String, List<String>> componentAllVersions = new HashMap<>();
   private final HashMap<String, List<String>> componentUpgFiles = new HashMap<>();
   //initialize, stop   
   
   //Merging of component files, start
   private static final String lineSeparator = System.getProperty("line.separator", "\n");
   
   //File extensions that will be merged.
   private static final List<String> extensions = Arrays.asList("api", "apn" ,"apv", "apy", "cdb", "cpi", "cre", "ins", "obd", "rdf", "sch", "svc");
    
   // Find files that should be ignored, bootstrapfiles, merged as first or last, merged in as postInstallation.
   private String compDeployIni = "";
   private List<String> ignoreDeployFiles = new ArrayList<>();
   private List<String> preUpgradeFiles = new ArrayList<>();
   private List<String> bootstrapFiles = new ArrayList<>();
   private List<String> capMergeFiles = new ArrayList<>();
   private List<String> capMergeFilesLast = new ArrayList<>();
   private List<String> postInstallationData = new ArrayList<>();
   private List<String> postInstallationDataSeq = new ArrayList<>();
   private List<String> postInstallationObject = new ArrayList<>();  
   private List<String> postInstallationDataVer = new ArrayList<>();
   private List<String> postInstallationDataSeqVer = new ArrayList<>();
   private List<String> postInstallationObjectVer = new ArrayList<>();  
   private List<String> versions = new ArrayList<>();  
   private List<String> upgFiles = new ArrayList<>();
   private List<String> buildOptions = new ArrayList<>();
   
   // Files that has to be manually handled, deployed. These are not included in any merged file.
   private final HashMap<String, List<String>> manualFilesToDeploy = new HashMap<>();
   private final HashMap<String, String> notMergedFiles = new HashMap<>();
   private static final String manualFileName = "Manual_FilesToHandle.txt";
   
   // Tem files that has to be manually handled, deployed.
   private static final String manualTemFileName = "Manual_TemFilesToHandle.txt";
   private static final   String deliveryRegTxtFile = "deliveryid.txt";    
   private static final   String deliveryRegSqlFile = "DeliveryRegistration.sql";
   
   // Registration of version in fnd_setting_tab
   private static final String versionFile = "version.yaml";    
   private static final String versionRegSqlFile = "VersionRegistration.sql";
   //Analyze of tem files in regeneartion
   private final List<String> existingTemFiles = new ArrayList<>();
   private final List<String> createdTemFiles = new ArrayList<>();


   // Output that should be included in merged files.
   private static final String strLine = "--------------------------------------------------------------------------------";
   private static final String setServerOutOn = "SET serverout ON";
   private static final String setServerOutOff = "SET serverout OFF";
   private static final String setVerifyOff = "SET VERIFY OFF";
   private static final String setFeedbackOff = "SET FEEDBACK OFF";
   private static final String exeStart = "exec Installation_SYS.Log_Time_Stamp('%1$s','%2$s','Started');";
   private static final String exeFinished = "exec Installation_SYS.Log_Time_Stamp('%1$s','%2$s','Finished');";
   
   private static final String rowExeStart = strLine + lineSeparator + setServerOutOn + lineSeparator + exeStart + lineSeparator + setServerOutOff + lineSeparator + strLine;
   private static final String rowExeFinished = strLine + lineSeparator + setServerOutOn + lineSeparator + exeFinished + lineSeparator + setServerOutOff + lineSeparator + strLine;
   
   private static final String header = rowExeStart + lineSeparator + setVerifyOff + lineSeparator + setFeedbackOff + lineSeparator;
   private static final String header_mix =  strLine + lineSeparator + setVerifyOff + lineSeparator + setFeedbackOff + lineSeparator + setServerOutOn.toUpperCase() + lineSeparator;   
   
   private static final String footer = rowExeFinished + lineSeparator;
   private static final String footer_mix = strLine + lineSeparator + setServerOutOff.toUpperCase() + lineSeparator;
  
   private static final String strPrompt = "PROMPT %1$s/%2$s";
   private static final String strStart = "START \"%1$s/%2$s\"";

   private static final String strComponent = "-- [Component %1$s]";  
   private static final String strComponentSpool = "SPOOL %1$s.log";
   private static final String strComponentSpoolAppend = "SPOOL %1$s.log APPEND";
   private static final String strComponentPrompt = "PROMPT Installing %1$s, version %2$s";
   
   private static final String strEndComponent = "-- [End Component]";  
   private static final String strSpoolOff = "SPOOL OFF";

   private static final String strSpoolInstallTem = "SPOOL _installtem.log APPEND";
   private static final String strNoDeployLog = "-- [NO DEPLOY LOGGING]";
   private static final String strEndNoDeployLog = "-- [END NO DEPLOY LOGGING]";
   
   //Merged upg file
   private static final String upgHeader =   "--	File: %1$s" + lineSeparator +
                                             "--" + lineSeparator +
                                             "--	Purpose: Script to upgrade database objects up to current version." + lineSeparator +
                                             "--" + lineSeparator +
                                             "--		The script is organized according to:" + lineSeparator +
                                             "--		[x.y.z]  (version to upgrade from)" + lineSeparator +
                                             "--		SQL-statements to upgrade from versions x.y.z to x1.y1.z1" + lineSeparator +
                                             "--		[x1.y1.z1] =(version to upgrade to)" + lineSeparator +
                                             "--		SQL-statements" + lineSeparator +
                                             "--		..." + lineSeparator +
                                             "--		[xn.yn.zn] (last line always states current version)" + lineSeparator +
                                             "--" + lineSeparator +
                                             "-- 	NOTE Folder separator '/' used for compatibility with Unix. Works in Windows.\r\n";   
   private static final String headerUpg =  strLine + lineSeparator + upgHeader + strLine + lineSeparator; 
   private static final String strPromptExecuting = "PROMPT Executing %1$s";
   private static final String strUpgVersion = "[%1$s]";
   //Merging of component files, stop
   
   //Upg file for defined upgrade, start
   private static final String upgHeaderDefined =   "--	File: %1$s" + lineSeparator +
                                             "--" + lineSeparator +
                                             "--	Purpose: Script to upgrade database objects from version [%2$s] up to version [%3$s]." + lineSeparator +
                                             "--" + lineSeparator +
                                             "-- 	NOTE Folder separator '/' used for compatibility with Unix. Works in Windows.";
   private static final String headerUpgDefined =  strLine + lineSeparator + upgHeaderDefined + lineSeparator + strLine + lineSeparator;                      
   //Upg file for defined upgrade, stop
   
   //Merged pre upg file
   private static final String preUpgHeader =   "--	File: %1$s" + lineSeparator +
                                                "--" + lineSeparator +
                                                "--	Purpose: " + lineSeparator + 
                                                "-- 	Script containing pre upgrade files per component version" + lineSeparator +   
                                                "--" + lineSeparator +
                                                "-- 	NOTE Folder separator '/' used for compatibility with Unix.\r\n"; 
   private static final String preUpgrade =  "PreUpgrade";
   private static final String preUpgradeRow = "%1$s=%2$s/%3$s";
   private static final String preHeaderUpg =  strLine + lineSeparator + preUpgHeader + strLine + lineSeparator + "[" + preUpgrade + "]" + lineSeparator; 

   //Merging of component files, stop
   
   //Pre upg file for defined upgrade, start
   private static final String preUpgHeaderDefined =  "--	File: %1$s" + lineSeparator +
                                                      "--" + lineSeparator +
                                                      "--	Purpose: " + lineSeparator + 
                                                      "-- 	Script to be run before upgrading component from version %2$s to %3$s." + lineSeparator +   
                                                      "--" + lineSeparator +
                                                      "-- 	NOTE Folder separator '/' used for compatibility with Unix.";
   private static final String preHeaderUpgDefined =  strLine + lineSeparator + preUpgHeaderDefined; 
   private static final String preStrPrompt = "PROMPT %1$s";
   private static final String preStrStart = "START \"%1$s\"";
   //Pre upg file for defined upgrade, stop   
   
   //Merged post installation files
   private static final String postInstallationHeader =  "--	File: %1$s" + lineSeparator +
                                                         "--" + lineSeparator +
                                                         "--	Purpose: " + lineSeparator + 
                                                         "-- 	Script containing post installation files per component and version" + lineSeparator +   
                                                         "--" + lineSeparator +
                                                         "-- 	NOTE Folder separator '/' used for compatibility with Unix.\r\n"; 
   private static final String postInstallationTxt =  "PostInstallation%2$s";
   private static final String postInstallationRow = "%1$s=%2$s/%3$s";
   private static final String postInstallationUpg =  strLine + lineSeparator + postInstallationHeader + strLine + lineSeparator + "[" + postInstallationTxt + "]" + lineSeparator; 

   //Merging of component files, stop
   
   //Pre upg file for defined upgrade, start
   private static final String postInstallationHeaderDefined = "--	File: %1$s" + lineSeparator +
                                                               "--" + lineSeparator +
                                                               "--	Purpose: " + lineSeparator + 
                                                               "-- 	Script to be run after upgrading component from version %2$s to %3$s." + lineSeparator +   
                                                               "--" + lineSeparator +
                                                               "-- 	NOTE Folder separator '/' used for compatibility with Unix.";
   private static final String headerPostInstallationDefined =  strLine + lineSeparator + postInstallationHeaderDefined; 
   private static final String postInstallationPrompt = "PROMPT %1$s";
   private static final String postInstallationStart = "START \"%1$s\"";
   //Pre upg file for defined upgrade, stop   

   //Creating of tem files, start
   public List<String> installationOrder = new ArrayList<>();
   public List<String> autoGeneratedComponents = new ArrayList<>();
   public String unresolvedConnections = "";
   public String deadlockConnections = "";
   
   private static final String temCompFooter = "SET DEFINE OFF" + lineSeparator +
                                               "PROMPT %2$s (%1$s) is set to version %3$s" + lineSeparator +           
                                               "EXEC Installation_SYS.Create_And_Set_Version( '%1$s', '%2$s', '%3$s', '%4$s' );" + lineSeparator +
                                               "SET DEFINE &";
   //Creating of tem files, stop
   
   //Creating CompRegAndDep sql file, start
   private static final String strPromptPreReg = "PROMPT Pre Register %1$s"+ lineSeparator + "-- [IFS COMPLETE BLOCK BEGINEND]" + lineSeparator + "BEGIN";
   private static final String strExecPreReg = "   Installation_SYS.Pre_Register('%1$s', SUBSTR('PRE-%2$s', 1, 50), '%3$s',  '%4$s');";
   private static final String strExecReg = "   Installation_SYS.Register_Dependency('%1$s', '%2$s', '%3$s');";
   private static final String strEndReg = "END;" + lineSeparator + "-- [END IFS COMPLETE BLOCK]" + lineSeparator + "/";
   //Creating CompRegAndDep sql file, stop   
   
   //Creating sub templates, start
   private static final String strSpool = "SPOOL %1$s_%2$s.log";
   private static final String header_sub_tem_comp = setServerOutOn + lineSeparator + "exec &APPLICATION_OWNER..Installation_SYS.Log_Time_Stamp('%1$s','%2$s','Started');" + lineSeparator + setServerOutOff;
   private static final String footer_sub_tem_comp = setServerOutOn + lineSeparator + "exec &APPLICATION_OWNER..Installation_SYS.Log_Time_Stamp('%1$s','%2$s','Finished');" + lineSeparator + setServerOutOff;
   private static final String biservice_tem_empty = strLine + lineSeparator +
                                                     "--	File: biservices.tem" + lineSeparator +
                                                     "--" + lineSeparator +
                                                     "--	Purpose: Created as dummy template, should always exist" + lineSeparator +
                                                     "--" + lineSeparator +
                                                     strLine;                                             
   private static final String default_sub_tem_header = strLine + lineSeparator +
                                                     "--	File: %1$s.tem" + lineSeparator +
                                                     "--" + lineSeparator +
                                                     "--	Purpose: Script to deploy files into database." + lineSeparator +
                                                     "--" + lineSeparator +
                                                     "--	Define in the beginning of the file variables that is the same for all file(s)." + lineSeparator +
                                                     "--	e.g. DEFINE AO = IFSAPP" + lineSeparator + 
                                                     "--" + lineSeparator +
                                                     "--	NOTE Folder separator '/' used for compatibility with Unix. Works in Windows." + lineSeparator + 
                                                     strLine + lineSeparator + 
                                                     "SPOOL _%1$stem.log" + lineSeparator;
   //Creating sub templates, stop
   //Create ObsoleteComponents.sql, start  
   private static final String obsolete_components_header = strLine + lineSeparator +
                                                   "--	File: ObsoleteComponents.sql" + lineSeparator +
                                                   "--" + lineSeparator +
                                                   "--	Purpose: Call to this file is included in install.tem." + lineSeparator +
                                                   "--		 The file contains components that should be set to obsolete," + lineSeparator +
                                                   "--		 information read from the drop scripts found in database/prifs/ from the build/delivery" + lineSeparator +           
                                                   "--" + lineSeparator + 
                                                   strLine + lineSeparator +
                                                   "-- [IFS COMPLETE BLOCK BEGINEND]" + lineSeparator + 
                                                   "BEGIN"  + lineSeparator;  
   private static final String obsolete_components_empty = strLine + lineSeparator +
                                                   "--	File: ObsoleteComponents.sql" + lineSeparator +
                                                   "--" + lineSeparator +
                                                   "--	Purpose: Call to this file is included in install.tem, therefore this" + lineSeparator +
                                                   "--		 file should always exist. If the file is not created by Developer" + lineSeparator +
                                                   "--		 Studio, the file will be created as dummy template." + lineSeparator +           
                                                   "--" + lineSeparator + 
                                                   strLine; 
   private static final String row_obsolete_component = 
                                                   "  Installation_SYS.Obsolete_Component('%1$s');" + lineSeparator;
   private static final String obsolete_component_footer = 
                                                   "END;" + lineSeparator + 
                                                   "-- [END IFS COMPLETE BLOCK]" + lineSeparator +
                                                   "/";    
   //Creating ObsoleteComponents.sql,stop   
   
   //Create ActivateComponents.sql, start 
   private static final String solutionset_header = strLine + lineSeparator +
                                                   "--	File: ActivateComponents.sql" + lineSeparator +
                                                   "--" + lineSeparator +
                                                   "--	Purpose: Call to this file is included in install.tem." + lineSeparator +
                                                   "--		 The file contains components that should be set to active," + lineSeparator +
                                                   "--		 information read from the solutionset file." + lineSeparator +           
                                                   "--" + lineSeparator + 
                                                   strLine + lineSeparator +
                                                   "-- [IFS COMPLETE BLOCK BEGINEND]" + lineSeparator + 
                                                   "BEGIN"  + lineSeparator;
   
   private static final String solutionset_row_solution_set =
                                                   "  Installation_SYS.Set_Solution_Set('%1$s', '%2$s');" + lineSeparator;
   private static final String solutionset_row_clear_all = 
                                                   "  Installation_SYS.Clear_All_Components();" + lineSeparator;
   private static final String solutionset_row_activate_component = 
                                                   "  Installation_SYS.Activate_Component('%1$s');" + lineSeparator;
   private static final String solutionset_footer = 
                                                   "END;" + lineSeparator + 
                                                   "-- [END IFS COMPLETE BLOCK]" + lineSeparator +
                                                   "/"; 
      
   private static final String solutionset_empty = strLine + lineSeparator +
                                                   "--	File: ActivateComponents.sql" + lineSeparator +
                                                   "--" + lineSeparator +
                                                   "--	Purpose: Call to this file is included in install.tem, therefore this" + lineSeparator +
                                                   "--		 file should always exist. If the file is not created because of " + lineSeparator +
                                                   "--		 missing solutionset file, the file will be created as dummy template." + lineSeparator +           
                                                   "--" + lineSeparator + 
                                                   strLine;    
   
   //Creating ActivateComponents.sql,stop
      
   //Creating main template, start
   String main_tem_header = strLine + lineSeparator +
                           "--	File: %1$s" + lineSeparator +
                           "--" + lineSeparator +
                           "--	Purpose: Script to deploy sub folders %1$s into database." + lineSeparator +
                           "--" + lineSeparator +
                           strLine + lineSeparator + lineSeparator; 
   String master = "-- [%1$sMASTER_TEM]" + lineSeparator + lineSeparator;
   String sub = "-- [%1$s %2$s]" + lineSeparator;
   String prompt = "PROMPT START deploying Folder %1$s" + lineSeparator;
   String start  = "START %1$s" + lineSeparator;
   String execFinalizeReset  = setServerOutOn.toUpperCase() + lineSeparator + "DECLARE" + lineSeparator +
                       "   no_method EXCEPTION;" + lineSeparator +
                       "   PRAGMA exception_init(no_method, -6550);" + lineSeparator +
                       "BEGIN" + lineSeparator +
                       "   EXECUTE IMMEDIATE 'BEGIN Install_Tem_SYS.Finalize_Installation(''RESET''); END;';" + lineSeparator +
                       "EXCEPTION" + lineSeparator +
                       "   WHEN no_method THEN" + lineSeparator +
                       "      NULL;" + lineSeparator +
                       "END;" + lineSeparator +
                       "/" + lineSeparator + setServerOutOff.toUpperCase() + lineSeparator + lineSeparator;   
   String execMulti  = "DECLARE" + lineSeparator +
                       "   no_method EXCEPTION;" + lineSeparator +
                       "   PRAGMA exception_init(no_method, -6550);" + lineSeparator +
                       "BEGIN" + lineSeparator +
                       "   EXECUTE IMMEDIATE 'BEGIN Install_Tem_SYS.Set_Multi_Installation_Mode(%1$s); END;';" + lineSeparator +
                       "EXCEPTION" + lineSeparator +
                       "   WHEN no_method THEN" + lineSeparator +
                       "      NULL;" + lineSeparator +
                       "END;" + lineSeparator +
                       "/" + lineSeparator + lineSeparator;
   String execFinalize  = setServerOutOn + lineSeparator + lineSeparator + "DECLARE" + lineSeparator +
                          "   no_method EXCEPTION;" + lineSeparator +
                          "   PRAGMA exception_init(no_method, -6550);" + lineSeparator +
                          "BEGIN" + lineSeparator +
                          "   EXECUTE IMMEDIATE 'BEGIN Install_Tem_SYS.Finalize_Installation(''MULTI''); END;';" + lineSeparator +
                          "EXCEPTION" + lineSeparator +
                          "   WHEN no_method THEN" + lineSeparator +
                          "      NULL;" + lineSeparator +
                          "END;" + lineSeparator +
                          "/" + lineSeparator + lineSeparator;
   private static final String delivery_reg_empty  = strLine + lineSeparator +
                         "--	File: DeliveryRegistration.sql" + lineSeparator +
                         "--" + lineSeparator +
                         "--	Purpose: Call to this file is inlcuded in install.tem, therefore this file should always exist" + lineSeparator +
                         "--		 If not externally copied deliveryid.txt exists," + lineSeparator +
                         "--		 this file will be created as dummy template" + lineSeparator +           
                         "--" + lineSeparator + 
                         strLine;  
   private static final String strPromptDelReg = "PROMPT Delivery Registration Started."+ lineSeparator + "-- [IFS COMPLETE BLOCK BEGINEND]" + lineSeparator + "BEGIN";
   private static final String strExecDelReg = "   Delivery_Registration_API.New('%1$s', '%2$s', '%3$s', NULL, '%4$s' );" + lineSeparator;
   private static final String strEndDelReg = "END;" + lineSeparator + "-- [END IFS COMPLETE BLOCK]" + lineSeparator + "/"+ lineSeparator + "PROMPT Delivery Registration Finished."+ lineSeparator;
   private static final String invalidDelreg= "PROMPT Invalid values for Delivery Id/Product Version. Delivery Registration FAILED!";
   
   private static final String version_reg_header  = strLine + lineSeparator +
                         "--	File: " + versionRegSqlFile + lineSeparator +
                         "--" + lineSeparator +
                         "--	Purpose: Call to this file is inlcuded in install.tem, therefore this file should always exist" + lineSeparator +
                         "--		 If no version.yaml file exist in ifsinstaller folder," + lineSeparator +
                         "--		 this file will only contain this header" + lineSeparator +           
                         "--" + lineSeparator + 
                         strLine;  
   private static final String strPromptVerReg = "PROMPT Version Registration Started."+ lineSeparator + "-- [IFS COMPLETE BLOCK BEGINEND]" + lineSeparator + "BEGIN";
   private static final String strExecVerReg = "   FND_SETTING_API.Set_Value('%1$s', '%2$s' );";
   private static final String strEndVerReg = "END;" + lineSeparator + "-- [END IFS COMPLETE BLOCK]" + lineSeparator + "/"+ lineSeparator + "PROMPT Version Registration Finished."+ lineSeparator;
   private static final String invalidVerreg= "PROMPT Invalid content in version file. Version Registration FAILED!";                                                  
   //Creating main template, stop
   /**
    * Comparator to sort the files like IFS Configuration Builder
   */
   private static final Comparator<String> sortFiles = new Comparator<String>() {
         @Override
         public int compare(String o1, String o2) {
            final String comp1 = o1.replace("-", "2").replace("_", "1").toLowerCase();
            final String comp2 = o2.replace("_", "1").replace("-", "2").toLowerCase();
            return comp1.compareTo(comp2);
         }
      };

         
   /**
    * Checks that a parameter has a value set.
    * @param   name  the name of the parameter. Used for displaying error message.
    * @param   value the value to check.
    * @throws  DbBuildException if the property has no value.
    */
   //private void checkPropertySet(String name, String value) throws BuildException {
   private void checkParameterSet(String name, String value) throws DbBuildException {
      if (value == null || value.length() == 0) {
         throw new DbBuildException("ERROR:Parameter " + name + " is not set.");
      }
    }

    /**
     * Creates a new instance of DbMergeFilesTask
     */
   public CreateInstallTem() {
   }   
    /**
     * Creates a new instance of DbMergeFilesTask
    * @param args
     */
   public CreateInstallTem(String[] args) {
      parseArgs(args);
   }
   
    /**
//     * Main
//    * @param args
//
    * @param args */
   public static void main(String[] args) {    
      if (args.length == 0) {
         System.out.println("Please specify the command you want to execute...");
         System.exit(1);
      } 
      CreateInstallTem p = new CreateInstallTem(args);
      p.run();
   }
   
   private void run() {
      try {
         validateParameters();
         if ("validate".equals(_executionType)) {
            System.out.println("INFO: Verifying of solution set started.");
            validateSolutionSet(_deliveryDBPath,_buildHomeDbPath);
            System.out.println("INFO: Verifying of solution set finished.");
         } else {
            System.out.println("INFO: Creation of install.tem started.");
            if (!_buildHomePath.equalsIgnoreCase(_deliveryPath))
               deliverySet = true;
            initialize(_buildHomeDbPath, _deliveryDBPath, _templatePath);
            //Update/create install.ini, with database values if credentials given
            installIni(_deliveryDBPath);
            if (merge) {
                createMergedDbFile(_deliveryDBPath, _component, _extension);
                if (!new File(_deliveryDBPath + File.separator + iniFiles.get("install.ini")).exists()) { 
                  regenerateInstallIni = true;
                }
                if (regenerateInstallIni) {
                    regenerateInstallIni(_deliveryDBPath);
                    //Refetch information about actual installation. Install.ini recreated in previous call.
                    if (new File(_deliveryDBPath + File.separator + iniFiles.get("install.ini")).exists()) {
                        List<String> compVersions = iniFileEnumSection(_deliveryDBPath + File.separator + iniFiles.get("install.ini"), "InstalledVersions", false);
                        for (String compVersion : compVersions) {
                            if (!componentVersions.containsKey(compVersion.split("=")[0].toLowerCase())) {
                                componentVersions.put(compVersion.split("=")[0].toLowerCase(), compVersion.split("=")[1]);
                            }
                        }
                    }
                }
            }
            if (doCreateInstallTem) {
               createInstallTem(_deliveryDBPath, _templatePath);
               cleanupOldTemFiles(_deliveryDBPath);
            } else {
               File[] fileList = new File(_deliveryDBPath).listFiles();
               for(File file: fileList) {
                  if (file.isFile() && file.getName().endsWith(".tem")) {            
                     file.delete();
                  }
               }
            } 
            System.out.println("INFO: Creation of install.tem finished.");
         }
      } catch (DbBuildException ex) {
         System.out.println(ex.getMessage());
         if ("validate".equals(_executionType)) 
            System.out.println("INFO: Verifying of solution set failed.");
         else 
            System.out.println("INFO: Creation of install.tem failed.");
         System.exit(1);
      }
      
   }

   public void parseArgs(String[] args){
      String key = "";
      String value = "";
      for (String arg : args) {
         if (arg.contains("=")) {
            key = arg.substring(0,arg.indexOf("="));
            value = arg.substring(arg.indexOf("=")+1);
            switch (key.toLowerCase()) {
               case "type":
                  _executionType = value;
                  break;
               case "deliverypath":
                  _deliveryPath = value;
                  _deliveryDBPath = value + "/database";
                  break;   
               case "buildhomepath":
                  _buildHomePath = value;
                  _buildHomeDbPath = value + "/database";
                  _templatePath = value + "/template/fndbas";
                  break;   
               case "component":
                  _component = value;
                  break;   
               case "extension":
                  _extension = value;
                  break;
               case "option":
                  _option = value;
                  break; 
               case "username":
               case "--username":
                  userName = value;
                  break;    
               case "password":
               case "--password":
                  password = value;
                  break;                   
               case "connectstring":
               case "--connectstring":
                  connectString = value;
                  break;                    
               default:
                 break; 
            }
         }
      }
   }  
    
    /**
     * Executes this task
    * @param databasePath
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException
     */
    public void updateInstallTem(String databasePath) throws DbBuildException{
       initialize(databasePath, databasePath, databasePath);
       createInstallTem(databasePath, databasePath);
       cleanupOldTemFiles(_deliveryDBPath);
    }
    /**
     * Will be used when multiple deliveries have been merged and install.tem and merging db code should be performed.
     * 
     * @param databasePath 
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException 
     */
    public void mergedDelivery(String databasePath) throws DbBuildException{
       merge = true;
       List<String> compFreshVersions = new ArrayList<>();

       File dir = new File(databasePath );
       File[] fileList = dir.listFiles();
       String fileName;
       String extension;
       for(File file: fileList) {
         fileName = file.getName();
         if (file.isFile() && fileName.indexOf(".") > 0 ) {
            extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            if ("ini".equals(extension)) {                  
               iniFiles.put(fileName.toLowerCase(), fileName);
            }  
         }
       }

       if (new File(databasePath + File.separator + iniFiles.get("install.ini")).exists()) {
           compFreshVersions = enumMergedIniFile(databasePath + File.separator + iniFiles.get("install.ini"), "InstalledVersions");
           for (String compVersion : compFreshVersions) {
              if (compVersion.indexOf("=") > 0) {
                  String existingValue = "";
                  String component = compVersion.split("=")[0].toLowerCase();
                  String version = compVersion.split("=")[1];
                  
                  if (componentVersions.containsKey(component)) {
                     existingValue = componentVersions.get(component);
                  }
                  
                  switch (version) {
                     case "FreshInstall":
                        componentVersions.put(component, version);
                        break;
                     case "VersionUpToDate":
                        if (existingValue.equals(""))
                           componentVersions.put(component, version);         
                        break;
                     case "UpdUpgradeOnly":
                        if (existingValue.equals("") || existingValue.equals("VersionUpToDate"))
                           componentVersions.put(component, version);         
                        break;
                     default:
                        if (existingValue.equals("") || existingValue.equals("UpdUpgradeOnly") || existingValue.equals("VersionUpToDate"))
                           componentVersions.put(component, version);
                        break;        
                  }
              }
           }
           
           compFreshVersions.clear();
           for (String key : componentVersions.keySet()) {
               compFreshVersions.add(key.toUpperCase() + "=" + componentVersions.get(key));
           }
           new File(databasePath + File.separator + iniFiles.get("install.ini")).delete();         
           Collections.sort(compFreshVersions, sortFiles);
           IniFileWriteSection(databasePath + File.separator + iniFiles.get("install.ini"), "InstalledVersions", new ArrayList<>(compFreshVersions));   
           
           //Manual_FilesToHandle.txt should be removed. Will be regenerated if needed.
           File outputFile = new File(databasePath + File.separator + manualFileName);
           if (outputFile.exists()) {
                  outputFile.delete();
           }

           initialize(databasePath, databasePath, databasePath);
           createMergedDbFile(databasePath, _component, _extension);
           regenerateInstallIni(databasePath);
       }
       //Refetch information about actual installation. Install.ini recreated in previous call.
       if (new File(databasePath + File.separator + iniFiles.get("install.ini")).exists()) {
           List<String> compVersions = iniFileEnumSection(databasePath + File.separator + iniFiles.get("install.ini"), "InstalledVersions", false);
           for (String compVersion : compVersions) {
               if (!componentVersions.containsKey(compVersion.split("=")[0].toLowerCase())) {
                   componentVersions.put(compVersion.split("=")[0].toLowerCase(), compVersion.split("=")[1]);
               }
           }
           compFreshVersions.clear();
           for (String key : componentVersions.keySet()) {
               compFreshVersions.add(key.toUpperCase() + "=" + componentVersions.get(key));
           }
           IniFileRemoveSection(databasePath + File.separator + iniFiles.get("install.ini"), "InstalledVersions");         
           Collections.sort(compFreshVersions, sortFiles);
           IniFileWriteSection(databasePath + File.separator + iniFiles.get("install.ini"), "InstalledVersions", new ArrayList<>(compFreshVersions));             

           createInstallTem(databasePath, databasePath);
           cleanupOldTemFiles(databasePath);
       }
       iniFiles.clear();
    }
    
   /**
    * Will be used when multiple deliveries have been merged and the install.tem should not be merged, instead a main tem
    * will be created that in turn will call the existing sub install.tem files.
    * 
    * @param path
    * @param deliveries
    * @throws IOException 
    */
   public void createMainTemp(String path, List<String> deliveries) throws IOException {
      HashMap<String, List<String>> temFiles = new HashMap<>();
      List<String> skipTemFiles = Arrays.asList("define.tem", "biservices.tem");
      List<String> distinctTemFiles = new ArrayList<String>();
      String ext;
      for (String delivery : deliveries) {
         File subDir = new File(path + File.separator + delivery);
         if (subDir.exists()) 
         {
            File[] listFile = subDir.listFiles();
            for (File file : listFile) {
               ext = file.getName().substring(file.getName().lastIndexOf(".") + 1).toLowerCase();
               if (ext.equals("tem") && !skipTemFiles.contains(file.getName().toLowerCase())) {
                  if (!temFiles.containsKey(delivery.toLowerCase())) {
                     temFiles.put(delivery.toLowerCase(), new ArrayList<String>());
                  }
                  temFiles.get(delivery.toLowerCase()).add(file.getName());

                  if (!distinctTemFiles.contains(file.getName().toLowerCase()))
                     distinctTemFiles.add(file.getName().toLowerCase());
               }
            }
         }
      }  
      
      for (String distinctTemFile : distinctTemFiles) {
         File outputFile = new File(path + File.separator + distinctTemFile);
         BufferedWriter output = new BufferedWriter(new FileWriter(outputFile));
         output.write(String.format(main_tem_header, distinctTemFile));
         if (distinctTemFile.equals("install.tem"))
            output.write(String.format(execFinalizeReset));
         output.write(String.format(execMulti, "TRUE"));
         output.write(String.format(master, ""));      
       
         for (String delivery : deliveries) {
            if (temFiles.containsKey(delivery.toLowerCase())) {
               List<String> values = new ArrayList<>(temFiles.get(delivery.toLowerCase()));
               for (String value : values) {
                  if (value.toLowerCase().equals(distinctTemFile)) {
                     output.write(String.format(sub, "Folder", delivery)); 
                     output.write("PROMPT" + lineSeparator);
                     output.write(String.format(prompt, delivery)); 
                     output.write("PROMPT" + lineSeparator);
                     output.write(String.format(start, value));     
                     output.write(String.format(sub, "End", "Folder") + lineSeparator); 
                  }
               }
            }
         } 

         output.write(String.format(master, "END "));      
         output.write(String.format(execMulti, "FALSE"));
         output.write(execFinalize);
         output.close();         
      }
   }

   private boolean validateParameters() throws DbBuildException {
      checkParameterSet("buildHomePath", _buildHomePath);
      File folder = new File(_buildHomePath);
      if (!folder.exists()) {
         throw new DbBuildException("ERROR:Folder " + _buildHomePath + " does not exist!");
      }
      checkParameterSet("deliveryPath", _deliveryPath);
      folder = new File(_deliveryPath);
      if (!folder.exists()) {
         throw new DbBuildException("ERROR:Folder " + _deliveryPath + " does not exist!");
      }
      checkParameterSet("templatePath", _templatePath);
      folder = new File(_templatePath);
      if (!folder.exists()) {
         throw new DbBuildException("ERROR:Folder " + _templatePath + " does not exist!");
      } 
      if ("noAdvance".equalsIgnoreCase(_option)) {
         installTemAdvance = false;
      } else if ("noInstallTem".equalsIgnoreCase(_option)) {
         doCreateInstallTem = false;
      } else if ("noMerge".equalsIgnoreCase(_option)) {
         merge = false;
      }

      return true;
   }

   private void installIni(String path) throws DbBuildException {  
      Boolean dbConnectionOk = false;
      Boolean noInstallIni = false;
      Statement stmt = null;
      HashMap<String, String> dbComponentVersions = new HashMap<>();   
      ArrayList<String> installedVersions = new ArrayList<>();
                
      //connect information not given, don't update the install.ini with database values
      if (!"".equals(userName)&&!"".equals(password)&&!"".equals(connectString)) {
         try {
            System.out.println("INFO:Trying to connect to the database");
            Connection connection = null;
            connection = DBConnection.openConnection(userName, password, connectString);   
            try {
                if (connection == null || connection.isClosed()) {
                    throw new DbBuildException("ERROR:No connection to the database could be established (1)! Connect string " + connectString + " " + DbInstallerUtil.logonError);
                }
            } catch (SQLException e) {
                throw new DbBuildException("ERROR:No connection to the database could be established (2)! Connect string " + connectString + " " + DbInstallerUtil.logonError);
            }   
            System.out.println("INFO:Connection successfull");
            dbConnectionOk = true;
            stmt = connection.createStatement();
            for (ResultSet rs = stmt.executeQuery("SELECT module MODULE, max(version) VERSION FROM module_tab where nvl(version,'?') not in ('?','*') GROUP BY module ORDER BY module"); rs.next();) {
               if (!dbComponentVersions.containsKey(rs.getString("MODULE").toLowerCase())) {
                  dbComponentVersions.put(rs.getString("MODULE").toLowerCase(), rs.getString("VERSION"));
               }
            }
         } catch (SQLException s) {
   //       Probably error since the table does not exist in an empty database, should then go as fresh install               
         } finally {
            try {
               if (stmt!=null) {
                  stmt.close();
                  System.out.println("INFO:Connection closed");
               }
            } catch (SQLException ex) {
                 throw new DbBuildException("ERROR:Error closing database. " + ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
            }
         }
      } else {
         System.out.println("INFO:No credentials given, install.ini not updated with information from database");
      }
      
      //Used for writing file
      if (!iniFiles.containsKey("install.ini")) {
         iniFiles.put("install.ini", "Install.ini");
         noInstallIni = true;
      }
      
      //Create database folder if not exist
      new File(path).mkdir();
      
      //ModuleConnections
      List<String> connections = new ArrayList<>();
      HashMap<String, String> installIniFile = new HashMap<>();
      String compConnections;
      String comp;
      for (String deployIni : iniFiles.values()) {
         if ("install.ini".equals(deployIni.toLowerCase())) {
            continue;
         }
         comp = componentNames.get(deployIni.substring(0, deployIni.lastIndexOf(".")).toLowerCase());
         //if for some reason the ini file is not valid component deploy.ini, skip the "component".
         List<String> compVersions = iniFileEnumSection(path + File.separator + deployIni, comp + "Versions", false);
         if (compVersions.isEmpty()) {
            continue;
         }           
         connections = iniFileEnumSection(path + File.separator + deployIni, "Connections", false);
         compConnections = comp + "=";
         if (connections.isEmpty()) {
            List<String> autogenerated = iniFileListSection(path + File.separator + deployIni, "Connections");
            if (autogenerated.size() == 1 && "AUTOGENERATED".equals(autogenerated.get(0))) {
               compConnections += "AUTOGENERATED";
            } else {
               compConnections += "NONE";
            }
         }
         for (String connection : connections) {
            if (connection.indexOf("=") > 0 && !connection.split("=")[1].equals("")) {
               String properName = connection.split("=")[0];
               if (properName.length() > 1) {
                  properName = properName.substring(0,1).toUpperCase() + properName.substring(1).toLowerCase();
               }
               if ("STATIC".equals(connection.split("=")[1].toUpperCase()) && !installIniFile.containsKey(properName.toLowerCase()) && !iniFiles.containsKey(properName.toLowerCase() + ".ini")) {
                  compConnections += properName + ".PRESENT;";
               } else {
                  compConnections += properName + "." + connection.split("=")[1].toUpperCase() + ";";
               }
            }
         }
         installIniFile.put(comp.toLowerCase(), compConnections);
      }

      ArrayList<String> installIniFileValues = new ArrayList<>(installIniFile.values());
      Collections.sort(installIniFileValues, sortFiles);
      IniFileRemoveSection(path + File.separator + iniFiles.get("install.ini"), "ModuleConnections");
      IniFileWriteSection(path + File.separator + iniFiles.get("install.ini"), "ModuleConnections", installIniFileValues);       

      //Installed versions      
      HashMap<String, String> selectedComponentVersions = new HashMap<>();         
      for (String component : componentAllVersions.keySet()) {
         if (dbComponentVersions.size() > 0) {
            //If components fetched from db, set FreshInstall as default, maybe components missing in db.
            selectedComponentVersions.put(component, "FreshInstall");
            String componentRegisterName = componentShortNames.get(component) == null ? component : componentShortNames.get(component).toLowerCase();
            String orgComponentRegisterName = componentRegisterName;
            if (!dbComponentVersions.containsKey(componentRegisterName) && preComponents.containsKey(component)) {
               componentRegisterName = preComponents.get(component).toLowerCase();
            }
            if (dbComponentVersions.containsKey(componentRegisterName)) {
               String dbVersion = dbComponentVersions.get(componentRegisterName);
               String dbVersionNoExt = dbVersion;
               if (dbVersion.contains("-")) {
                  dbVersionNoExt = dbVersion.substring(0, dbVersion.indexOf("-"));
               }
               if (componentFreshVersions.containsKey(component) && componentFreshVersions.get(component).equals(dbVersionNoExt)) {
                  if (componentRegisterName.equals(orgComponentRegisterName)) {
                     if (!dbVersion.equals(dbVersionNoExt)) {
                        System.out.println("WARNING:Component " + component + " is on version " + dbVersion + " in the database, but there is no support in deploy.ini for that specific version! \n\nThe component version in database seems to be an extension. Upgrade state will be Version up to date.");
                     }
                     selectedComponentVersions.put(component, "VersionUpToDate");
                  } else {
                     selectedComponentVersions.put(component, "FreshInstall");
                  }
               } else {
                  if (componentAllVersions.containsKey(component) && (componentAllVersions.get(component).contains(dbVersion) || componentAllVersions.get(component).contains(dbVersionNoExt))) {
                     if (componentAllVersions.get(component).contains(dbVersion)) {
                        selectedComponentVersions.put(component, dbVersion);
                     } else if (!dbVersion.equals(dbVersionNoExt)) {
                        if (componentRegisterName.equals(orgComponentRegisterName)) {
                           System.out.println("WARNING:Component " + component + " is on version " + dbVersion + " in the database, but there is no support in deploy.ini for that specific version! \nThe component version in database seems to be an extension. This will be an upgrade from the core version " + dbVersionNoExt + ".\n");
                        } else {
                          System.out.println("WARNING:Pre Component " + componentRegisterName + " is on version " + dbVersion + " in the database, but there is no support in " + orgComponentRegisterName + " deploy.ini for that specific version! \nThe component version in database seems to be an extension. This will be an upgrade from the core version " + dbVersionNoExt + ".\n");
                        }
                        selectedComponentVersions.put(component, dbVersionNoExt);
                     }
                  } else {
                     if (componentUpgFiles.containsKey(component) && componentUpgFiles.get(component).size() > 0) {
                        if (componentRegisterName.equals(orgComponentRegisterName)) {
                          System.out.println("WARNING:Component " + component + " is on version " + dbVersion + " in the database, but there is no support in deploy.ini for that specific version! \nComponent will be installed as Fresh Install!\n");
                        } else {
                          System.out.println("WARNING:Pre component " + componentRegisterName + " is on version " + dbVersion + " in the database, but there is no support in " + orgComponentRegisterName + " deploy.ini for that specific version! \nComponent will be installed as Fresh Install!\n");
                        }
                     }
                     selectedComponentVersions.put(component, "FreshInstall");
                  }
               }
            }
         //no data in dbComponentVersions, but connection to database was successfull, set FreshInstall for all components.
         //if no install.ini found (deleted manually), set version to FreshInstall
         } else if (dbConnectionOk || noInstallIni) {
           selectedComponentVersions.put(component, "FreshInstall"); 
         }
         if (selectedComponentVersions.containsKey(component)) {
            installedVersions.add(component.toUpperCase() + "=" + selectedComponentVersions.get(component));
         } else {
            if (componentVersions.containsKey(component)) {
               installedVersions.add(component.toUpperCase() + "=" + componentVersions.get(component));
            } else {
               installedVersions.add(component.toUpperCase() + "=" + "VersionUpToDate");
            }
         }
      }

      if (installedVersions.size() > 0) {
         Collections.sort(installedVersions);
         //no install.ini exist on 
         if (!iniFiles.containsKey("install.ini")) {
            regenerateInstallIni(path);
            iniFiles.put("install.ini", "Install.ini");
         }
         IniFileRemoveSection(path + File.separator + iniFiles.get("install.ini"), "InstalledVersions");
         IniFileWriteSection(path + File.separator + iniFiles.get("install.ini"), "InstalledVersions", installedVersions);
         componentVersions.clear();
         for (String installedVersion : installedVersions) {
            if (!componentVersions.containsKey(installedVersion.split("=")[0].toLowerCase())) {
               componentVersions.put(installedVersion.split("=")[0].toLowerCase(), installedVersion.split("=")[1]);
            }
         }
      }  
   }    
   
   /**
   * Method that initialize variables with data.
   * @param buildHomePath
   * @param deliveryPath
   * @param templatePath
   */
    private void initialize(String buildHomePath, String deliveryPath, String templatePath) throws DbBuildException {
      File dir = new File(deliveryPath );
      
      if (dir.canRead()) {
         File[] fileList = dir.listFiles();
         String fileName;
         String component;
         String extension;
         
         //fetch subfolders and ini files.
         HashMap<String, String> iniFilesAutogenerated = new HashMap<>(); 
         for(File file: fileList) {
            fileName = file.getName();
            if (file.isFile() && fileName.indexOf(".") > 0 ) {
               extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
               component = fileName.substring(0,fileName.lastIndexOf(".")).toLowerCase();
               if ("ini".equals(extension)) {                  
                  iniFiles.put(fileName.toLowerCase(), fileName);
               }
               if ("ini_autogenerated".equals(extension)) {
                  iniFilesAutogenerated.put(component, fileName);
               }
               if (extensions.contains(extension)) {
                  if (!mergedFiles.containsKey(component)) {
                     mergedFiles.put(component, new ArrayList<String>());
                  }
                  mergedFiles.get(component).add(fileName);
               }
            } else if (file.isDirectory()) {            
               subDirectories.put(fileName.toLowerCase(),fileName);
            }
         }

         //If deploy.ini not exist in delivery, copy from build home. 
         //Can be the case when generation of db files has added components to delivery
         if (!buildHomePath.equalsIgnoreCase(deliveryPath))
         {
            merge = true;
            dir = new File(buildHomePath );
            if (dir.canRead()) {
               fileList = dir.listFiles();
               for(File file: fileList) {
                  fileName = file.getName();
                  if (file.isFile() && fileName.indexOf(".") > 0  && "ini".equals(fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase())) {               
                     if (!iniFiles.containsKey(fileName.toLowerCase()) && subDirectories.containsKey(fileName.substring(0, fileName.lastIndexOf(".")).toLowerCase())){                  
                        iniFiles.put(fileName.toLowerCase(), fileName);
                        copyFile(file.getAbsolutePath(), deliveryPath + File.separator + fileName);
                        regenerateInstallIni = true;
                     }
                  }
               }      
            }
         }

         //Add autogenerated <component>.ini_autogenerated ini files to include such components in creation of install.tem
         for (String autoDeployInis : iniFilesAutogenerated.keySet()) {
            if (!iniFiles.containsKey(autoDeployInis + ".ini")) {
               iniFiles.put(autoDeployInis + ".ini", iniFilesAutogenerated.get(autoDeployInis));
            }
         } 
         
         //read information about the components
         for (String deployIni : iniFiles.values()) {
            compDeployIni = deliveryPath + File.separator + deployIni;
            String componentName = getComponentName(deployIni.substring(0, deployIni.lastIndexOf(".")).toLowerCase(), compDeployIni);
            componentNames.put(componentName.toLowerCase(), componentName);
            List<String> shortNames = iniFileEnumSection(compDeployIni, "ShortName", true, false);
            if (shortNames.size() == 1) {
               componentShortNames.put(componentName.toLowerCase(), shortNames.get(0).trim());
            }
            List<String> compDescriptions = iniFileEnumSection(compDeployIni, "ComponentName", true, false);
            if (compDescriptions.size() == 1) {
               componentDescriptions.put(componentName.toLowerCase(), compDescriptions.get(0).trim());
            } else {
               componentDescriptions.put(componentName.toLowerCase(), componentName.toUpperCase().trim());
            }             
            
            List<String> defines = iniFileEnumSection(compDeployIni, componentName + "Defines", false);
            for (String define : defines) {
               String name = define.split("=")[0].trim();
               String selection = define.split("=")[1];

               if (!componentDefines.containsKey(componentName.toLowerCase())) {
                  componentDefines.put(componentName.toLowerCase(), new ArrayList<String>());
               }
               componentDefines.get(componentName.toLowerCase()).add(name + "='" + selection.trim() + "'");
            }
            List<String> preComponent = iniFileEnumSection(compDeployIni, "PreComponent", true, false);
            if (preComponent.size() == 1) {
               preComponents.put(componentName.toLowerCase(), preComponent.get(0).trim());
            }
            List<String> compVers = iniFileEnumSection(compDeployIni, componentName + "Versions",  false);
            if (compVers.size() > 0) {
               if (compVers.get(compVers.size() -1).contains("="))
                   componentFreshVersions.put(componentName.toLowerCase(), compVers.get(compVers.size() -1).split("=")[0]);
               if (!componentAllVersions.containsKey(componentName.toLowerCase()))
                  componentAllVersions.put(componentName.toLowerCase(), new ArrayList<String>());
               for (String version : compVers) {
                  if (version.contains("="))
                     componentAllVersions.get(componentName.toLowerCase()).add(version.split("=")[0]);
               }
            }
            if (!componentUpgFiles.containsKey(componentName.toLowerCase()))
               componentUpgFiles.put(componentName.toLowerCase(), new ArrayList<String>());
            List<String> compUpgFiles = iniFileEnumSection(compDeployIni, componentName + "Upgrade", false);
            for (String compUpgFile : compUpgFiles) {
               if (compUpgFile.contains("="))
                  componentUpgFiles.get(componentName.toLowerCase()).add(compUpgFile.split("=")[0]);
            }            
         }

         //Fetch information about actual installation, versions of the components
         if (new File(deliveryPath + File.separator + iniFiles.get("install.ini")).exists()) {
            List<String> compVersions = iniFileEnumSection(deliveryPath + File.separator + iniFiles.get("install.ini"), "InstalledVersions", false);
            for (String compVersion : compVersions) {
               if (!componentVersions.containsKey(compVersion.split("=")[0].toLowerCase())) {
                  componentVersions.put(compVersion.split("=")[0].toLowerCase(), compVersion.split("=")[1]);
               }
            }
         }

         //fetch default tem files. 
         File temDir = new File(templatePath);
         if (temDir.canRead()) {
            File[] temList = temDir.listFiles();
            for(File file: temList) {
               fileName = file.getName();
               if (file.isFile() && fileName.indexOf(".") > 0  && "tem".equals(fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase())) {
                  temFiles.put(fileName.toLowerCase(), fileName);
               }
            }
         }
      }
   }
    
   /**
   * Method that merges files.
   * @param deliveryPath
   * @param component
   * @param extension
   */
    private void createMergedDbFile(String deliveryPath, String component, String extension) throws DbBuildException {
      String componentName;
      boolean addInfo = true;
    
      for (String subDirectory : subDirectories.values()) {
         //component defined but no match.
         if (!"".equals(component) && !component.toLowerCase().equals(subDirectory.toLowerCase())) {            
            continue;
         }
       
         File subDir = new File(deliveryPath + File.separator + subDirectory);
         File[] files = subDir.listFiles();

         HashMap<String, List<String>> filesMap = new HashMap<>();
         HashMap<String, String> fileNamesLower = new HashMap<>();
         notMergedFiles.clear();
        
         for (File file : files) {
            String ext;
            fileNamesLower.put(file.getName().toLowerCase(), file.getName());
            if (file.getName().indexOf(".") > 0 ) {               
               ext = file.getName().substring(file.getName().lastIndexOf(".") + 1).toLowerCase();
               //valid extension
               if (extensions.contains(ext)) {
                  //valid extension and if defined as input, match., or extension defined but no match.
                  if (!"".equals(extension) && !extension.toLowerCase().equals(ext.toLowerCase())){
                     continue;
                  }
                  if (!filesMap.containsKey(ext)) {
                     filesMap.put(ext, new ArrayList<String>());
                  }
                  filesMap.get(ext).add(file.getName());
               } else {
                  if (!file.getName().equalsIgnoreCase(subDirectory+"dr.sql") && !file.getName().equalsIgnoreCase(subDirectory+"cl.sql") 
                  && !(subDirectory.equalsIgnoreCase("prifs") && ext.equalsIgnoreCase("drp")))
                  {
                     notMergedFiles.put(file.getName().toLowerCase(), file.getName());
                  }
               }
            }
         }
         
         compDeployIni = "";
         componentName = "";
         if (files.length > 0) {   
             for (String deployIni : iniFiles.values()) {
               if (deployIni.substring(0, deployIni.lastIndexOf(".")).toLowerCase().equals(subDirectory.toLowerCase())) {                  
                  compDeployIni = deliveryPath + File.separator + deployIni;
                  componentName = componentNames.get(subDirectory.toLowerCase());
                  ignoreDeployFiles = iniFileEnumSection(compDeployIni, "IgnoreDeployFiles");
                  preUpgradeFiles = iniFileEnumSection(compDeployIni, componentName + "PreUpgrade", false);
                  bootstrapFiles = iniFileEnumSection(compDeployIni, "Bootstrap");
                  capMergeFiles = iniFileEnumSection(compDeployIni, "CapMergeFiles");
                  capMergeFilesLast = iniFileEnumSection(compDeployIni, "CapMergeFilesLast");
                  postInstallationData = iniFileEnumSection(compDeployIni, "PostInstallationData");
                  postInstallationDataSeq = iniFileEnumSection(compDeployIni, "PostInstallationDataSeq");
                  postInstallationObject = iniFileEnumSection(compDeployIni, "PostInstallationObject"); 
                  postInstallationDataVer = iniFileEnumSection(compDeployIni, "PostInstallationData", false);
                  postInstallationDataSeqVer = iniFileEnumSection(compDeployIni, "PostInstallationDataSeq", false);
                  postInstallationObjectVer = iniFileEnumSection(compDeployIni, "PostInstallationObject", false); 
                  versions = iniFileEnumSection(compDeployIni, componentName + "Versions", false);
                  upgFiles = iniFileEnumSection(compDeployIni, componentName + "Upgrade", false);
                  break;
               }
            }
         }
         
         if (!"".equals(compDeployIni)) {
            //Create <component>preUpgrade file to be called in PreUpgradeSection.
            if (preUpgradeFiles.size() > 0)
            {
               createPreUpgradeFile(deliveryPath, componentName, subDirectory, fileNamesLower);
            }
            //Merge of boostrapFiles.
            if (bootstrapFiles.size() > 0)
            {
               createBootstrapFiles(deliveryPath, componentName, subDirectory, fileNamesLower);
            }
            
            for (String mergedExtension : extensions) {
               if (!filesMap.containsKey(mergedExtension)) {
                  new File(deliveryPath + File.separator + componentName + "." + mergedExtension).delete();   
               }
            }

            //Merge of api, apn, apv, apy, cdb, cpi, cre, ins, obd, rdf, sch, svc files
            for ( String key : filesMap.keySet() ) {
               createMergedDbFile(deliveryPath, componentName, subDirectory, key, filesMap.get(key));
            }
            
            //Merge of postInstallation Object / Data files.
            if (postInstallationObjectVer.size() > 0 || postInstallationDataVer.size() > 0 || postInstallationDataSeqVer.size() > 0) {
               postInstallation(deliveryPath, componentName, subDirectory, fileNamesLower);
            }
            
            //Merge of upg files
            if (versions.size() > 0 && upgFiles.size() > 0) {
               createUpgFiles(deliveryPath, componentName, subDirectory, fileNamesLower);
            }
            
            //remove files from notMergedFiles, that shouldn't be merge according to definition in deploy.ini
            for (String file : ignoreDeployFiles) {
               notMergedFiles.remove(file.toLowerCase());
            }
            
            if (notMergedFiles.size() > 0) {
               manualFilesToDeploy.put(subDirectory, new ArrayList<>(notMergedFiles.values()));
            }
         } else {
            if (!"_utils".equals(subDirectory.toLowerCase())) {
               if (files.length > 0) {
                  if (addInfo) {
                     manualFilesToDeploy.put("-- ", new ArrayList<String>());
                     manualFilesToDeploy.get("-- ").add("-- Observe these files, not normal component database structure. Check how to deploy!!");
                     addInfo = false;
                  }
                  for (File file : files) {
                     manualFilesToDeploy.get("-- ").addAll(Arrays.asList(subDirectory + File.separator + file.getName()));
                  }
               }
            }
         }
      }
      if (manualFilesToDeploy.size() > 0) {
         createManualHandledFilesList(deliveryPath);
      }
   }
    
   /**
   * Method that creates the tem files.
   * @param deliveryPath
   * @param templatePath
   */
    private void createInstallTem(String deliveryPath, String templatePath) throws DbBuildException {
      boolean readLine = true;
      String currentSection;
      String prevSection = "";
      
      List<String> installTemContents = new ArrayList<>();
      String templateFile = "";
      File dir = new File(deliveryPath );
      File[] fileList = dir.listFiles();
      
      templateFile = "installnorefresh.tem";
      for(File file: fileList) {
         if (file.isDirectory()) {            
            templateFile = "install.tem";
         } else {
            if (file.getName().endsWith(".tem")) {
               existingTemFiles.add(file.getName());
            }
         }
      }
      //Solution sets will be updated, refresh has to be executed, included in install.tem
      if (deliverySet && new File(new File(deliveryPath).getParent() + File.separator + "solutionset.yaml").exists())
         templateFile = "install.tem";
      
      String templateFilePath = templatePath + File.separator + templateFile;
      if (new File(templateFilePath).exists()) {
         loadInstallIni(deliveryPath);
         String line;
         try {
            try (BufferedReader reader = new BufferedReader(new FileReader(templateFilePath))) {
               while ((line = reader.readLine()) != null){
                  if ("-- noInstallTemAdvance".equals(line)) {
                      installTemAdvance = false;
                  }               
                  currentSection = GetSectionStart(line.trim());
                  if ( !"".equals(currentSection) && !currentSection.equals(prevSection) && readLine) {
                     if ("InstallTemType".equals(currentSection) && readLine) {
                        readLine = false;
                        prevSection = currentSection;
                        if (!installTemAdvance) {
                         installTemContents.add("-- noInstallTemAdvance");
                        } else {
                         installTemContents.add("-- installTemAdvance");
                        }                       
                     }                     
                     
                     if (!"InstallTemType".equals(currentSection)) {
                        installTemContents.add(line);
                     }
                     List<String> section = CreateInstallSection(currentSection, deliveryPath);
                     if (section.size() > 0) {
                        readLine = false;
                        installTemContents.addAll(section);
                        prevSection = currentSection;
                     }
                  }

                  if (IsSectionEnd(line.trim(), prevSection) && !readLine) {                            
                     if (!"InstallTemType".equals(prevSection)) {
                        installTemContents.add(line);
                     }                  
                     readLine = true;
                  } else if (readLine) {
                      installTemContents.add(line);
                  }               
               }
            }
         } catch (Exception ex) {
            throw new DbBuildException("ERROR:Error when creating " + templateFile + lineSeparator + ex.toString());
         }
         
         try {
            File outputFile = new File(deliveryPath + File.separator + "install.tem");
            try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
               for (String temLine : installTemContents) {
                  output.write(temLine + lineSeparator);
               }
            }
            createdTemFiles.add("install.tem");
         } catch (IOException ex) {
            throw new DbBuildException("ERROR:Error(s) occurred during creation of installation template" + lineSeparator + ex.toString());
         }

         //Copy of define.tem to database folder, called by the tem files.
         if (!templatePath.equalsIgnoreCase(deliveryPath) && new File(templatePath + File.separator + "define.tem").exists()) {
            copyFile(templatePath + File.separator + "define.tem", deliveryPath + File.separator + "define.tem");
         }
         //add define.tem as always created so it want be deleted in cleaup process.
         createdTemFiles.add("define.tem");
            
         CreateCompReqAndDep(deliveryPath);

         CreateSubTemplates(deliveryPath, templatePath);
      } else {
         throw new DbBuildException("WARNING:Template file " + templateFilePath + " missing, skipping creation of install.tem");
      }
   }

   /**
   * Method that create ini file with preupgrade information per component.
   * @param deliveryPath
   * @param componentName
   * @param subFolder
   * @param fileNamesLower
   */
   private void createPreUpgradeFile(String deliveryPath, String componentName, String subFolder, HashMap<String, String> fileNamesLower) throws DbBuildException {
      try {
         List<String> lines = new ArrayList<>();
         String fileName, fileNameTmp, versions;
         
         File outputFile = new File(deliveryPath + File.separator + componentName + "_pre.upg");
         //Remove old file if exist.
         if (outputFile.exists()) {
            outputFile.delete();
         }
         //Files that could be called in upgrade scenario. 
         for (String preUpgradeFile : preUpgradeFiles) {
            String [] entries = preUpgradeFile.split("=");
            fileNameTmp = preUpgradeFile;
            versions = "Always";
            if (entries.length == 2) {
               fileNameTmp = entries[1].trim();
               while (fileNameTmp.contains("; ")) {
                  fileNameTmp = fileNameTmp.replace("; ", ";");
               }
               while (fileNameTmp.contains(" ;")) {
                  fileNameTmp = fileNameTmp.replace(" ;", ";");
               }
               if (fileNameTmp.contains(" ")) {
                  versions = fileNameTmp.split(" +")[1].replace("{", "").replace("}", "").trim();
                  fileNameTmp = fileNameTmp.split(" +")[0].trim();
               }
            } 
            if (fileNamesLower.containsKey(fileNameTmp.toLowerCase())) {
               fileName = fileNamesLower.get(fileNameTmp.toLowerCase());
               notMergedFiles.remove(fileName.toLowerCase());
               String [] versionsArray = versions.split(";");
               for (String version : versionsArray) {
                  lines.add(String.format(preUpgradeRow, version, subFolder, fileName));
               }
            }
         }
         if (lines.size() > 0) {
            try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
               output.write(String.format(preHeaderUpg, outputFile.getName()));
               for (String line : lines) {
                  output.append(line + lineSeparator);
               }
               output.append(strLine + lineSeparator);
            }
         }          

      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Added rows to sub files in " + componentName + "_pre.upg failed" + lineSeparator + ex.toString());
      }
   }
   
   /**
   * Method that find correct file to be called for specific upgrade version.
   * @param deliveryPath
   * @param componentName
   * @param subFolder
   * @param fileNamesLower
   */
   private void createPreUpgradeFiles(String deliveryPath, String componentName, String subFolder, HashMap<String, String> fileNamesLower) throws DbBuildException {
      try {
         String componentVersion = componentVersions.get(componentName.toLowerCase());
         if (componentVersion == null) {
            componentVersion = "FreshInstall";
         }           
         List<String> lines = new ArrayList<>();
         String fileName;
         
         File outputFile = new File(deliveryPath + File.separator + componentName + "_PreUpgrade.sql");
         //Remove old file if exist.
         if (outputFile.exists()) {
            outputFile.delete();
         }
         //Files that could be called in upgrade scenario. Only one will be selected.
         for (String preUpgradeFile : preUpgradeFiles) {
            String [] entries = preUpgradeFile.split("=");
            if (entries.length == 2 && fileNamesLower.containsKey(entries[1].toLowerCase())) {
               fileName = fileNamesLower.get(entries[1].toLowerCase());
               notMergedFiles.remove(fileName.toLowerCase());
               if (componentVersion.equals(entries[0])) {
                  lines.add(strLine);
                  lines.add(String.format(strPrompt, subFolder, fileName));
                  lines.add(String.format(strStart, subFolder, fileName));
               }
            }
         }
         if (lines.size() > 0) {
            try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
               output.write(header_mix);
               for (String line : lines) {
                  output.append(line + lineSeparator);
               }
               output.write(footer_mix);
            }
         }          

      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Added calls to sub files in " + componentName + "_PreUpgrade failed" + lineSeparator + ex.toString());
      }
   }   
   
   /**
   * Method that merges files declared in bootstrap section for components. Should normally only exist for Foundation1 components (fndbas).
   * @param deliveryPath
   * @param componentName
   * @param subFolder
   * @param fileNamesLower
   */
   private void createBootstrapFiles(String deliveryPath, String componentName, String subFolder, HashMap<String, String> fileNamesLower) throws DbBuildException {
      try {
         List<String> lines = new ArrayList<>();
         
         //ignoreFiles, merged List of files to skip in specific step.
         List<String> ignoreFiles = new ArrayList<>();
         ignoreFiles.addAll(ignoreDeployFiles);

         String fileName;
         //Files that should be merged as bootstrap files.
         for (String boostrapFile : bootstrapFiles) {
            if (fileNamesLower.containsKey(boostrapFile.toLowerCase()) && (ignoreFiles.isEmpty() || !ignoreFiles.contains(boostrapFile))) {
               fileName = fileNamesLower.get(boostrapFile);
               lines.add(strLine);
               lines.add(String.format(strPrompt, subFolder, fileName));
               lines.add(String.format(strStart, subFolder, fileName));
               notMergedFiles.remove(fileName.toLowerCase());
            }
         }
         if (lines.size() > 0) {
            File outputFile = new File(deliveryPath + File.separator + componentName + "_BootStrap.sql");
            try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
               output.write(header_mix);
               for (String line : lines) {
                  output.append(line + lineSeparator);
               }
               output.write(footer_mix);
            }
         }          

      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Added calls to sub files in " + componentName + "_BootStrap.sql failed" + lineSeparator + ex.toString());
      }
   }
    
   /**
   * Method that merges files with extensions api, apn, apv, apy, cdb, cpi, cre, ins, obd, rdf, sch, svc
   * @param deliveryPath
   * @param componentName
   * @param subFolder
   * @param extension
   * @param dbFiles
   */
   private void createMergedDbFile(String deliveryPath, String componentName, String subFolder, String extension, List<String> dbFiles) throws DbBuildException {
      try {
         List<String> lines = new ArrayList<>();
         String mergedFile = deliveryPath + File.separator + componentName + "." + extension;

         //ignoreFiles, merged List of files to skip in specific step.
         List<String> ignoreFiles = new ArrayList<>();

         String fileName;
         List<String> lowerCaseFiles = new ArrayList<>();

         HashMap<String, String> filesMap = new HashMap<>();
         for (String dbFile : dbFiles) {
            filesMap.put(dbFile.toLowerCase(), dbFile);
            lowerCaseFiles.add(dbFile.toLowerCase().substring(0, dbFile.lastIndexOf(".")));
         }

         if (lowerCaseFiles.size() > 0) {

            //Sort files to match CB version of sorting files.
            Collections.sort(lowerCaseFiles, sortFiles);

            //Files that should be ignored
            ignoreFiles.clear();
            ignoreFiles.addAll(ignoreDeployFiles);

            //Files that should be merged first
            for (String capMergeFile : capMergeFiles) {
               if (capMergeFile.contains(".") && capMergeFile.endsWith("." + extension) && filesMap.containsKey(capMergeFile) && 
                       (ignoreFiles.isEmpty() || !ignoreFiles.contains(capMergeFile))) {
                  fileName = filesMap.get(capMergeFile);
                  lines.add(strLine);
                  lines.add(String.format(strPrompt, subFolder, fileName));
                  lines.add(String.format(strStart, subFolder, fileName));
               }
            }

            //Files that should be ignored
            ignoreFiles.clear();
            ignoreFiles.addAll(ignoreDeployFiles);
            ignoreFiles.addAll(bootstrapFiles);
            ignoreFiles.addAll(capMergeFiles);
            ignoreFiles.addAll(capMergeFilesLast);
            ignoreFiles.addAll(postInstallationData);
            ignoreFiles.addAll(postInstallationDataSeq);
            ignoreFiles.addAll(postInstallationObject);

            for (String lowerCaseFile : lowerCaseFiles) {
               fileName = lowerCaseFile + "." + extension;
               if (filesMap.containsKey(fileName) && (ignoreFiles.isEmpty() || !ignoreFiles.contains(fileName))) {
                  fileName = filesMap.get(fileName.toLowerCase());
                  lines.add(strLine);
                  lines.add(String.format(strPrompt, subFolder, fileName));
                  lines.add(String.format(strStart, subFolder, fileName));
               }
            }

            //Files that should be ignored
            ignoreFiles.clear();
            ignoreFiles.addAll(ignoreDeployFiles);

            //Files that should be merged last
            for (String capMergeLastFile : capMergeFilesLast) {
               if (capMergeLastFile.contains(".") && capMergeLastFile.endsWith("." + extension) && filesMap.containsKey(capMergeLastFile) && 
                       (ignoreFiles.isEmpty() || !ignoreFiles.contains(capMergeLastFile))) {
                  lines.add(strLine);
                  fileName = filesMap.get(capMergeLastFile);
                  lines.add(String.format(strPrompt, subFolder, fileName));
                  lines.add(String.format(strStart, subFolder, fileName));
               }
            }

            if (lines.size() > 0) {
               File outputFile = new File(mergedFile);
               try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
                  output.write(String.format(header, componentName, extension));
                  for (String line : lines) {
                     output.append(line + lineSeparator);
                  }
                  output.write(String.format(footer, componentName, extension));
               }
            }            
         }
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Added calls to sub files in " + componentName + "." + extension + " failed" + lineSeparator + ex.toString());
      }
   }
   
   /**
   * Method that merges files that are defined in PostObject, PostData or PostDataSeq sections in deploy.ini
   * @param deliveryPath
   * @param componentName
   * @param subFolder
   * @param fileNamesLower
   */
   private void postInstallation(String deliveryPath, String componentName, String subFolder, HashMap<String, String> fileNamesLower) throws DbBuildException {
      String[] postObjectData = new String[] { "Object", "Data", "DataSeq" };
      List<String> includeFiles = new ArrayList<>();
      String fileName, fileNameTmp, versions;

      for (String postType :  postObjectData) {         

         //ignoreFiles, merged List of files to skip in specific step.
         List<String> ignoreFiles = new ArrayList<>();
         ignoreFiles.addAll(ignoreDeployFiles);

         includeFiles.clear();

         String mergedFileName = "";

         if ("Object".equals(postType) && postInstallationObjectVer.size() > 0) {
            ignoreFiles.addAll(postInstallationData);
            ignoreFiles.addAll(postInstallationDataSeq);
            includeFiles.addAll(postInstallationObjectVer);
            mergedFileName = componentName + "_PostObject.upg";
         } else if ("Data".equals(postType) && postInstallationDataVer.size() > 0) {
            ignoreFiles.addAll(postInstallationObject);
            ignoreFiles.addAll(postInstallationDataSeq);
            includeFiles.addAll(postInstallationDataVer);
            mergedFileName = componentName + "_PostData.upg";
         } else if ("DataSeq".equals(postType) && postInstallationDataSeqVer.size() > 0) {
            ignoreFiles.addAll(postInstallationObject);
            ignoreFiles.addAll(postInstallationData);
            includeFiles.addAll(postInstallationDataSeqVer);
            mergedFileName = componentName + "_PostDataSeq.upg";
         }

         if (!"".equals(mergedFileName)) {
            try {
               List<String> lines = new ArrayList<>();
               for (String includeFile : includeFiles) {
                  String [] entries = includeFile.split("=");
                  fileNameTmp = includeFile;
                  versions = "Always";
                  if (entries.length == 2) {
                     fileNameTmp = entries[1].trim();
                     while (fileNameTmp.contains("; ")) {
                        fileNameTmp = fileNameTmp.replace("; ", ";");
                     }
                     while (fileNameTmp.contains(" ;")) {
                        fileNameTmp = fileNameTmp.replace(" ;", ";");
                     }
                     if (fileNameTmp.contains(" ")) {
                        versions = fileNameTmp.split(" +")[1].replace("{", "").replace("}", "").trim();
                        fileNameTmp = fileNameTmp.split(" +")[0].trim();
                     }
                  }
                  if (fileNamesLower.containsKey(fileNameTmp.toLowerCase()) && (ignoreFiles.isEmpty() || !ignoreFiles.contains(fileNameTmp))) {
                     fileName = fileNamesLower.get(fileNameTmp.toLowerCase());
                     notMergedFiles.remove(fileName.toLowerCase());
                     String [] versionsArray = versions.split(";");
                     for (String version : versionsArray) {
                        lines.add(String.format(postInstallationRow, version, subFolder, fileName));
                     }
                  }
               }
               if (lines.size() > 0) {
                  File outputFile = new File(deliveryPath + File.separator + mergedFileName);
                  if (outputFile.exists()) {
                     outputFile.delete();
                  }
                  try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
                     output.write(String.format(postInstallationUpg, outputFile.getName(), postType));
                     for (String line : lines) {
                        output.append(line + lineSeparator);
                     }
                     output.append(strLine + lineSeparator);
                  }
               }                
            } catch (IOException ex) {
               throw new DbBuildException("ERROR:Added calls to sub files in " + componentName + ".sql failed" + lineSeparator + ex.toString());
            }                    
         }
      }
   }
   
   /**
   * Method that merges upg files
   * @param deliveryPath
   * @param componentName
   * @param subFolder
   */
   private void createUpgFiles(String deliveryPath, String componentName, String subFolder, HashMap<String, String> fileNamesLower) throws DbBuildException {
      try {
         List<String> lines = new ArrayList<>();
         String mergedFileName = componentName + ".upg";
         String fileName;
         for(String ver : versions)
         {
            String version = ver.split("=")[0];
            lines.add(String.format(strUpgVersion, version));
            for (String upgFile : upgFiles) {
               String[] entries = upgFile.split("=");
               if (version.trim().equalsIgnoreCase(entries[0].trim()) && entries.length == 2 && fileNamesLower.containsKey(entries[1].toLowerCase())) {
                  fileName = fileNamesLower.get(entries[1].toLowerCase().trim());
                  lines.add(String.format(strPromptExecuting, fileName));
                  lines.add(String.format(rowExeStart, componentName, fileName));
                  lines.add(String.format(strStart, subFolder, fileName));
                  lines.add(String.format(rowExeFinished, componentName, fileName));
                  notMergedFiles.remove(entries[1].toLowerCase());
                  break;
               }
            }            
         }
         
         if (lines.size() > 0) {
            File outputFile = new File(deliveryPath + File.separator + mergedFileName);
            try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
               output.write(String.format(headerUpg, mergedFileName));
               for (String line : lines) {
                  output.append(line + lineSeparator);
               }
            }
         }             
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Added calls to sub files in " + componentName + ".upg failed" + lineSeparator + ex.toString());
      } 
   }   

   /**
   * Method that creates a file containing all files that are not included in any merged file.
   * These files should be handled manually.
   * @param deliveryPath
   */
   private void createManualHandledFilesList(String deliveryPath) throws DbBuildException {
      try {
         List<String> lines = new ArrayList<>();
         List<String> keys = new ArrayList<>(manualFilesToDeploy.keySet());
         Collections.sort(keys, sortFiles);
         
         for(String subFolder : keys)
         {
            if (subFolder.startsWith("-- ")) {
               continue;
            }
            List<String> values = new ArrayList<>(manualFilesToDeploy.get(subFolder));
            Collections.sort(values, sortFiles);
            for(String file : values)
            {
               lines.add(subFolder + File.separator + file);
            }
         }
         if (keys.contains("-- "))
         {
            List<String> values = new ArrayList<>(manualFilesToDeploy.get("-- "));
            for(String line : values)
            {
               if (line.startsWith("--")) {
                  lines.add("");
                  lines.add(line);
               } else {
                  lines.add(line);
               }
            }
         }
         
         File outputFile = new File(deliveryPath + File.separator + manualFileName);
         if (outputFile.exists()) {
            outputFile.delete();
         }
         if (lines.size() > 0) {
            try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
               for (String line : lines) {
                  output.append(line + lineSeparator);
               }
            }
         }             
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Creation of " + deliveryPath + File.separator + manualFileName + " failed" + lineSeparator + ex.toString());
      } 
   }  
   
   /**
   * Method that copy file from one location to another. Both parameters includes full path.
   * @param sourceFile
   * @param destinationFile
   */
   private void copyFile(String sourceFile, String destinationFile) throws DbBuildException {
      try {
         FileChannel dstChannel;
         try (FileChannel srcChannel = new FileInputStream(sourceFile).getChannel()) {
            dstChannel = new FileOutputStream(destinationFile).getChannel();
            dstChannel.transferFrom(srcChannel, 0, srcChannel.size());
         }
         dstChannel.close();         
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Copy of " + sourceFile + " to " + destinationFile + " failed" + lineSeparator + ex.toString());
      }
   }
   
   /**
   * Method that removes a defined section from file.
    * @param pathToFile
    * @param section
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException
   */
   public static void IniFileRemoveSection(String pathToFile, String section) throws DbBuildException {
      List<String> fileContents = new ArrayList<>();
      boolean foundSection = false;
      boolean endSection = false;
      String line;

      try {
         if (new File(pathToFile).canWrite()) {
            try (BufferedReader input = new BufferedReader(new FileReader(pathToFile))) {
               boolean addLine = true;
               while ((line = input.readLine()) != null) {
                  if (line.trim().toUpperCase().equals("[" + section.toUpperCase() + "]")) {
                     foundSection = true;
                     addLine = false;
                  } else if (foundSection && !endSection && ("".equals(line.trim()) || line.startsWith("["))) {
                     endSection = true;
                     addLine = true;
                  }
                  if (addLine) {
                     fileContents.add(line);
                  }
               }
               input.close();               
            }

            File outputFile = new File(pathToFile);
            try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
               for (String fileContent : fileContents) {
                  output.write(fileContent + lineSeparator);
               }
               output.close();
            }
         }
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Error(s) occurred during recreation of " + new File(pathToFile).getName() + lineSeparator + ex.toString());
      } 
   }   
   
   /**
   * Method that returns a list of strings for a defined section from deploy.ini (only values)
   * @param deployIni
   * @param section
   * @return List
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException
   */
   public static List<String> iniFileEnumSection(String deployIni, String section) throws DbBuildException {
      return iniFileEnumSection(deployIni, section, true, true);
   }

   /**
   * Method that returns a list of strings for a defined section from deploy.ini (values only or full info)
   * @param deployIni
   * @param section
   * @param valuesOnly 
   * @return List
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException
   */
   public static List<String> iniFileEnumSection(String deployIni, String section, boolean valuesOnly) throws DbBuildException {
      return iniFileEnumSection(deployIni, section, valuesOnly, true);
   }
   
   /**
   * Method that returns a list of strings for a defined section from deploy.ini (return in upper or lower case)
   * @param deployIni
   * @param section
   * @param valuesOnly 
   * @param changeCase
   * @return List
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException
   */
   public static List<String> iniFileEnumSection(String deployIni, String section, boolean valuesOnly, boolean changeCase) throws DbBuildException {
      return iniFileEnumSection(deployIni, section, valuesOnly, changeCase, true);
   }

   /**
   * Method that returns a list of strings for a defined section from deploy.ini (return in upper or lower case)
   * @param deployIni
   * @param section
   * @param valuesOnly 
   * @param changeCase
    * @param uniqueKey
   * @return List
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException
   */
   public static List<String> iniFileEnumSection(String deployIni, String section, boolean valuesOnly, boolean changeCase, boolean uniqueKey) throws DbBuildException {
      return iniFileEnumSection(deployIni, section, valuesOnly, changeCase, uniqueKey, false);
   }
   
   /**
   * Method that returns a list of strings for a defined section from deploy.ini (return in upper or lower case)
   * @param deployIni
   * @param section
   * @param valuesOnly 
   * @param changeCase
   * @param uniqueKey
   * @param returnLine
   * @return List
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException
   */
   public static List<String> iniFileEnumSection(String deployIni, String section, boolean valuesOnly, boolean changeCase, boolean uniqueKey, boolean returnLine) throws DbBuildException {
      List<String> entries = new ArrayList<>();
      List<String> keys = new ArrayList<>();
      boolean readNextLine = true;
      boolean foundSection = false;
      String line;
      try {
         try (BufferedReader input = new BufferedReader(new FileReader(deployIni))) {
            Integer counter = 0;
            while ((line = input.readLine()) != null && readNextLine) {
               if (line.trim().toUpperCase().equals("[" + section.toUpperCase() + "]")) {
                  foundSection = true;
               } else if (foundSection && line.trim().startsWith("[")) {
                  readNextLine = false;
               } else if (foundSection && !line.trim().equals("") && line.indexOf("=") > 0 && !line.trim().startsWith(";")) {
                  if (!keys.contains(line.trim().split("=")[0].toLowerCase()) && line.trim().split("=").length > 1 && !"".equals(line.trim().split("=")[1])) {
                     if (changeCase) {
                        if (valuesOnly) {
                           if (line.indexOf("{") > 0) {
                              line = line.substring(0, line.indexOf("{"));
                           }
                           entries.add(line.trim().split("=")[1].toLowerCase());
                        } else {
                           entries.add(line.trim());
                        }
                        if (uniqueKey) {
                           keys.add(line.trim().split("=")[0].toLowerCase());
                        } else {
                           counter++;
                           keys.add(counter.toString());
                        }
                     } else {
                        if (valuesOnly) {
                           if (line.indexOf("{") > 0) {
                              line = line.substring(0, line.indexOf("{"));
                           }
                           entries.add(line.trim().split("=")[1]);
                        } else {
                           entries.add(line.trim());
                        }
                        if (uniqueKey) {
                           keys.add(line.trim().split("=")[0]); 
                        } else {
                           counter++;
                           keys.add(counter.toString());
                        }
                     }
                  }
				} else if (foundSection && !line.trim().equals("") && returnLine && !line.trim().startsWith(";")) {
                  entries.add(line.trim());				  
               }
            }
         }
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Error when reading " + deployIni + lineSeparator + ex.toString());
      }
      return entries;
   }
   
/**
   * Method that returns a list of strings for a defined section from ini file (return in upper or lower case)
   * @param deployIni
   * @param section
   * @return List
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException
   */
   public static List<String> enumMergedIniFile(String deployIni, String section) throws DbBuildException {
      List<String> entries = new ArrayList<>();
      boolean foundSection = false;
      String line;
      try {
         try (BufferedReader input = new BufferedReader(new FileReader(deployIni))) {
            while ((line = input.readLine()) != null) {
               if (line.trim().toUpperCase().equals("[" + section.toUpperCase() + "]")) {
                  foundSection = true;
               } else if (foundSection && line.trim().startsWith("[")) {
                  foundSection = false;
               } else if (foundSection && !line.trim().equals("") && line.indexOf("=") > 0 && !line.trim().startsWith(";")) {
                  if (line.trim().split("=").length > 1 && !"".equals(line.trim().split("=")[1])) {
                     entries.add(line.trim());
                  }
               }
            }
         }
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Error when reading " + deployIni + lineSeparator + ex.toString());
      }
      return entries;
   }   
        
   /**
   * Method that returns a list of strings as is for a defined section from deploy.ini
   * @param deployIni
   * @param section
    * @return 
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException

   */
   public static List<String> iniFileListSection(String deployIni, String section) throws DbBuildException {
      List<String> entries = new ArrayList<>();
      boolean readNextLine = true;
      boolean foundSection = false;
      String line;
      try {
         try (BufferedReader input = new BufferedReader(new FileReader(deployIni))) {
            while ((line = input.readLine()) != null && readNextLine) {
               if (line.trim().toUpperCase().equals("[" + section.toUpperCase() + "]")) {
                  foundSection = true;
               } else if (foundSection && line.trim().startsWith("[")) {
                  readNextLine = false;
               } else if (foundSection && !line.trim().equals("") && !line.trim().startsWith(";")) {
                  entries.add(line.trim());
               }
            }
         }
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Error when reading " + deployIni + lineSeparator + ex.toString());
      }
      return entries;
   }

   /**
   * Method that writes a section and its data to a file
   * @param pathToFile
   * @param section
   * @param entries
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException
   */   
   public static void IniFileWriteSection(String pathToFile, String section, ArrayList<String> entries) throws DbBuildException {
      List<String> modifiedEntries = new ArrayList<>();
      List<String> fileContents = new ArrayList<>();
      boolean foundSection = false;
      boolean endSection = false;
      String line;
      
      try {
         if (new File(pathToFile).canWrite()) {
            try (BufferedReader input = new BufferedReader(new FileReader(pathToFile))) {
               while ((line = input.readLine()) != null) {
                  boolean addLine = true;
                  if (line.trim().toUpperCase().equals("[" + section.toUpperCase() + "]")) {
                     foundSection = true;
                  } else if (foundSection && !endSection && ("".equals(line.trim()) || line.startsWith("["))) {
                     modifiedEntries.addAll(entries);
                     for (String entry : modifiedEntries) {
                        fileContents.add(entry);
                     }
                     endSection = true;
                     addLine = true;
                  } else if (foundSection && !endSection) {
                     addLine = false;
                     boolean found = false;
                     for (String entry : modifiedEntries) {
                        if (entry.split("=")[0].equals(line.split("=")[0])) {
                           found = true;
                           break;
                        }
                     }
                     if (!found) {
                        modifiedEntries.add(line);
                     }
                  }
                  if (addLine) {
                     fileContents.add(line);
                  }
               }
            }
            
            if (foundSection && !endSection) {
               modifiedEntries.addAll(entries);
               for (String entry : modifiedEntries) {
                  fileContents.add(entry);
               }
            }            
         }
         if (!foundSection) {
            fileContents.add("[" + section + "]");
            fileContents.addAll(entries);
         }
            
         File outputFile = new File(pathToFile);
         try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
            for (String fileContent : fileContents) {
               output.write(fileContent + lineSeparator);
            }
            output.close();
         }
            
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Error(s) occurred during recreation of " + new File(pathToFile).getName() + lineSeparator + ex.toString());
      }       
   }

   
   /**
   * Method that fetches the component name from deploy.
   * @param component
   * @param deployIni
   * @return 
   * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException
   */
   public static String getComponentName(String component, String deployIni) throws DbBuildException {
      List<String> temp;
      temp = iniFileEnumSection(deployIni, "Module");
      if (temp.isEmpty()) {
         temp = iniFileEnumSection(deployIni, "Component");
      }

      if (temp.size() == 1) {
         return temp.get(0).substring(0, 1).toUpperCase() + temp.get(0).substring(1).toLowerCase();
      } else {
         return component.substring(0, 1).toUpperCase() + component.substring(1).toLowerCase();
      }
   }   

   /**
   * Method that loads information from Install.ini file
   * @param deliveryPath
    * @return 
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException
   */
   public boolean loadInstallIni(String deliveryPath) throws DbBuildException  {
      //fetch install information from deploy.ini files of each component listed in install.ini
      installationOrder.clear();
      autoGeneratedComponents.clear();
      unresolvedConnections = "";
      //dbInstallComponents.Clear();
      if (new File(deliveryPath + File.separator + iniFiles.get("install.ini")).exists()) {      
         List<String> connections = iniFileEnumSection(deliveryPath + File.separator +  iniFiles.get("install.ini"), "ModuleConnections", false);
         List<String> components = new ArrayList<>();
         for (String connection : connections) {
            String component = connection.split("=")[0].toUpperCase();
            if (iniFiles.containsKey(component.toLowerCase() + ".ini") && !components.contains(component)) {
              components.add(component);   
            }
         }

         if (!ArrangeListInInstalltionOrder(components, connections)) {
            installationOrder.clear();
            autoGeneratedComponents.clear();
            if (!"".equals(deadlockConnections)) {
               throw new DbBuildException("ERROR:STATIC connection definitions exist to components in following list that points to each other and therefore installation order cannot be resolved: " + deadlockConnections + lineSeparator + 
                                        "Correct the components deploy.ini file and recreate the build");
            }
         }
      }
      return true;
   }
   
   /**
   * Method that regenerates the install.ini file
   * @param deliveryPath
    * @return 
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException
   */
   public boolean regenerateInstallIni(String deliveryPath) throws DbBuildException  {
      //ModuleConnections
      List<String> connections = new ArrayList<>();
      if (!iniFiles.containsKey("install.ini")) {
         iniFiles.put("install.ini", "Install.ini");
      }
      if (new File(deliveryPath + File.separator + iniFiles.get("install.ini")).exists()) { 
         connections = iniFileEnumSection(deliveryPath + File.separator +  iniFiles.get("install.ini"), "ModuleConnections", false);
      }
      HashMap<String, String> installIniFile = new HashMap<>();
      for (String connection : connections) {
         if (connection.indexOf("=") > 0 && !installIniFile.containsKey(connection.split("=")[0].toLowerCase())) {
            installIniFile.put(connection.split("=")[0].toLowerCase(), connection);
         }
      }              
      
      String compConnections;
      String component;
      String componentShortName;
      HashMap<String, String> componentState = new HashMap<>();
      for (String deployIni : iniFiles.values()) {
         if ("install.ini".equals(deployIni.toLowerCase())) {
            continue;
         }
         component = componentNames.get(deployIni.substring(0, deployIni.lastIndexOf(".")).toLowerCase());
         //if for some reason the ini file is not valid component deploy.ini, skip the "component".
         List<String> compVersions = iniFileEnumSection(deliveryPath + File.separator + deployIni, component + "Versions", false);
         if (compVersions.isEmpty()) {
            continue;
         }           
         connections = iniFileEnumSection(deliveryPath + File.separator + deployIni, "Connections", false);
         compConnections = component + "=";
         if (connections.isEmpty()) {
            List<String> autogenerated = iniFileListSection(deliveryPath + File.separator + deployIni, "Connections");
            if (autogenerated.size() == 1 && "AUTOGENERATED".equals(autogenerated.get(0))) {
               compConnections += "AUTOGENERATED";
            } else {
               compConnections += "NONE";
            }
         }
         for (String connection : connections) {
            if (connection.indexOf("=") > 0 && !connection.split("=")[1].equals("")) {
               String properName = connection.split("=")[0];
               if (properName.length() > 1) {
                  properName = properName.substring(0,1).toUpperCase() + properName.substring(1).toLowerCase();
               }
               if ("STATIC".equals(connection.split("=")[1].toUpperCase()) && !installIniFile.containsKey(properName.toLowerCase()) && !iniFiles.containsKey(properName.toLowerCase() + ".ini")) {
                  compConnections += properName + ".PRESENT;";
               } else {
                  compConnections += properName + "." + connection.split("=")[1].toUpperCase() + ";";
               }
            }
         }
         if (installIniFile.containsKey(component.toLowerCase())) {
            installIniFile.remove(component.toLowerCase());
            componentState.put(component.toLowerCase(), "FreshInstall");
         } else {
            componentState.put(component.toLowerCase(), "VersionUpToDate");
         }
         installIniFile.put(component.toLowerCase(), compConnections);
         
      }

      ArrayList<String> installIniFileValues = new ArrayList<>(installIniFile.values());
      Collections.sort(installIniFileValues, sortFiles);
      IniFileRemoveSection(deliveryPath + File.separator + iniFiles.get("install.ini"), "ModuleConnections");
      IniFileWriteSection(deliveryPath + File.separator + iniFiles.get("install.ini"), "ModuleConnections", installIniFileValues);         

      
      //InstalledVersion
      installIniFile.clear();
      List<String> compVersions = iniFileEnumSection(deliveryPath + File.separator +  iniFiles.get("install.ini"), "InstalledVersions", false);
      for (String version : compVersions) {
         if (version.indexOf("=") > 0 && !installIniFile.containsKey(version.split("=")[0].toLowerCase())) {
            installIniFile.put(version.split("=")[0].toLowerCase(), version);
         }
      }              
      
      for (String deployIni : iniFiles.values()) {
         if ("install.ini".equals(deployIni.toLowerCase())) {
            continue;
         }
         component = componentNames.get(deployIni.substring(0, deployIni.lastIndexOf(".")).toLowerCase());
         componentShortName =  componentShortNames.get(component.toLowerCase()) == null ? component : componentShortNames.get(component.toLowerCase());
         if ("VersionUpToDate".equals(componentState.get(component.toLowerCase())) && installIniFile.containsKey(componentShortName.toLowerCase())) {
            installIniFile.remove(componentShortName.toLowerCase());
         }
         if (!installIniFile.containsKey(componentShortName.toLowerCase()) && componentState.containsKey(component.toLowerCase())) {
            installIniFile.put(component.toLowerCase(), componentShortName.toUpperCase() + "=" + componentState.get(component.toLowerCase()));
         }         
      }
         
      installIniFileValues = new ArrayList<>(installIniFile.values());
      Collections.sort(installIniFileValues, sortFiles);
      IniFileRemoveSection(deliveryPath + File.separator + iniFiles.get("install.ini"), "InstalledVersions");
      IniFileWriteSection(deliveryPath + File.separator + iniFiles.get("install.ini"), "InstalledVersions", installIniFileValues);         
      
      return true;
      
   }   
   
   /**
   * Method that arrange the order of components depending on STATIC information.
   * @param componentsList
   * @param connectionRules
    * @return 
   */
   public boolean ArrangeListInInstalltionOrder(List<String> componentsList, List<String> connectionRules) {
      boolean noMoreRuleVialations = true;
      deadlockConnections = "";
      int processedComponents = installationOrder.size();
      int autoComponents = autoGeneratedComponents.size();

      for (String connectionRule : connectionRules) {
         String component = connectionRule.split("=")[0].toUpperCase();
         if (iniFiles.containsKey(component.toLowerCase() + ".ini") && !installationOrder.contains(component)) {
            boolean allStaticConnectionsFound = true; 
            String[] dependencies = connectionRule.split("=")[1].split(";");
            if (dependencies.length == 1 && "AUTOGENERATED".equals(dependencies[0])) {
               if (!autoGeneratedComponents.contains(component)) {
                  autoGeneratedComponents.add(component);
               }
               continue;
            }
            if (!(dependencies.length == 1 && ("NONE".equals(dependencies[0]) || "AUTOGENERATED".equals(dependencies[0])))) {
               for (String dependency : dependencies) {
                  String[] dependencyDefinition = dependency.split(Pattern.quote("."));
                  if ("STATIC".equals(dependencyDefinition[1])) {
                     if (!componentsList.contains(dependencyDefinition[0].toUpperCase())) {
                        continue;
                     } else if (!installationOrder.contains(dependencyDefinition[0].toUpperCase()) && !autoGeneratedComponents.contains(dependencyDefinition[0].toUpperCase())) {
                        allStaticConnectionsFound = false;
                        if ((deadlockConnections.toUpperCase() + ",").indexOf(dependencyDefinition[0].toUpperCase() + ",") == -1) {
                           deadlockConnections += "".equals(deadlockConnections) ? dependencyDefinition[0] : "," + dependencyDefinition[0];
                        }
                        break;
                     }
                  }
               }
            }

            if (allStaticConnectionsFound) {
               installationOrder.add(component);
            } else {
               noMoreRuleVialations = false;
            }
          }
      }
      if (noMoreRuleVialations) {
         installationOrder.addAll(autoGeneratedComponents);
         deadlockConnections = "";
         return true;
      } else {
         if (processedComponents == installationOrder.size() && autoComponents == autoGeneratedComponents.size()) {
            return false;
         }
         return ArrangeListInInstalltionOrder(componentsList, connectionRules);
      }
   } 

   /**
   * Method that validates that all needed components (STATIC dependency) are set to true in solutionset.yaml file
   * @param deliveryPath
    * @param buildHomePath
    * @return 
    * @throws ifs.fnd.dbbuild.databaseinstaller.DbBuildException
   */
   public boolean validateSolutionSet(String deliveryPath, String buildHomePath) throws DbBuildException  {
      HashMap<String, List<String>> activeComponentsNotOk = new HashMap<>();
      List<String> components;
      List<String> activeComponents = new ArrayList<>(); 
      List<String> noExistingdeployInis = new ArrayList<>();   
      
      String solutionSetYamlFile = new File(deliveryPath).getParent() + File.separator + "solutionset.yaml";
      //If solutionset.yaml doesn't exist in delivery, read from <build_home>. This to ensure that no changed
      //deploy.ini files in delivery break the solutionset configuration.
	   if (!new File(solutionSetYamlFile).exists())
		  solutionSetYamlFile = new File(buildHomePath).getParent() + File.separator + "solutionset.yaml";      
      if (new File(solutionSetYamlFile).exists()) {
         SolutionSet solutionSet;
         try {
            // Deserialize the file configuration into SolutionSetYamlDefinition.
            InputStream inputStream = new FileInputStream(solutionSetYamlFile);
            try {
               SolutionSetYamlDefinition solutionSetGlobal = (SolutionSetYamlDefinition) new Yaml().loadAs(inputStream, SolutionSetYamlDefinition.class);
               solutionSet = solutionSetGlobal.getGlobal();
            } catch (Exception ex) {
               // this is a temporary solution for backward compability, using depricated syntax.
               // when removed, throw new DbBuildException("ERROR:Error(s) occurred during validation of Solutionset.yaml file" + lineSeparator + ex.getMessage());
               try {
                  inputStream = new FileInputStream(solutionSetYamlFile);
                  SolutionSetConfig solutionSetConfig = (SolutionSetConfig) new Yaml().loadAs(inputStream, SolutionSetConfig.class);
                  solutionSet = new SolutionSet();
                  solutionSet.setSolutionSetId(solutionSetConfig.getSolutionSetId());
                  solutionSet.setSolutionSetName(solutionSetConfig.getSolutionSetName());
                  solutionSet.setCoreComponents(solutionSetConfig.getCoreComponents());
                  solutionSet.setCustomComponents(solutionSetConfig.getCustomComponents());    
               }  catch (Exception ex2) {
                   throw new DbBuildException("ERROR:Error(s) occurred during validation of Solutionset.yaml file" + lineSeparator + ex2.getMessage());
               }
            }   
            Map<String, Boolean> coreComponent = solutionSet.getCoreComponents();
            if (coreComponent != null) {
               for (Map.Entry<String, Boolean> component : coreComponent.entrySet()) {
                  if (component.getValue())
                     activeComponents.add(component.getKey().toLowerCase());
               }            
            }
            Map<String, Boolean> custComponent = solutionSet.getCustomComponents();
            if (custComponent != null) {
               for (Map.Entry<String, Boolean> component : custComponent.entrySet()) {
                  if (component.getValue() && !activeComponents.contains(component.getKey().toLowerCase()))
                     activeComponents.add(component.getKey().toLowerCase());
               }   
            }
         } catch (FileNotFoundException ex) {
            throw new DbBuildException("ERROR:Error(s) occurred during validation of Solutionset.yaml file" + lineSeparator + ex.getMessage());
         }         
      }
      if (activeComponents.size() > 0) {
         String fileName;
         String extension;
         String component;
         List<String> connections = new ArrayList<>();
         HashMap<String, String> deployIniFilesDelivery = new HashMap<>();
         List<String> shortNames = new ArrayList<>();         
         
         //List the *.ini files in deliveryPath
         File dir = new File(deliveryPath );
         if (dir.canRead()) {
            File[] fileList = dir.listFiles();
            //fetch ini files.
            for(File file: fileList) {
               fileName = file.getName();
               if (file.isFile() && fileName.indexOf(".") > 0 ) {
                  extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
                  if ("ini".equals(extension)) {     
                     shortNames = iniFileEnumSection(deliveryPath + File.separator + fileName, "ShortName", true, false);
                     if (shortNames.size() == 1) {
                        component =  shortNames.get(0).trim().toLowerCase();
                     } else {
                        component = fileName.substring(0,fileName.lastIndexOf(".")).toLowerCase();
                     }
                     deployIniFilesDelivery.put(component, fileName);
                  }
               }
            }
            for (String activeComponent : activeComponents) {
               if (deployIniFilesDelivery.containsKey(activeComponent)) {
                  connections = iniFileEnumSection(deliveryPath + File.separator + deployIniFilesDelivery.get(activeComponent), "Connections", false);
                  for (String connection : connections) {
                     if (connection.indexOf("=") > 0 && !connection.split("=")[1].equals("")) {
                        String dependentComponent = connection.split("=")[0].toLowerCase();
                        String dependentType = connection.split("=")[1].toUpperCase();
                        if ("STATIC".equals(dependentType) && !activeComponents.contains(dependentComponent)) {
                           if (!activeComponentsNotOk.containsKey(activeComponent))
                              activeComponentsNotOk.put(activeComponent, new ArrayList<>());
                           activeComponentsNotOk.get(activeComponent).add(dependentComponent);
                        }
                     }
                  }
               }
            }
         }
         //if deliveryPath egual buildHomePath we don't have delivery set.
         HashMap<String, String> deployIniFilesBuildHome = new HashMap<>();
         if (!buildHomePath.equalsIgnoreCase(deliveryPath))
         {
            dir = new File(buildHomePath );
            if (dir.canRead()) {
               File[] fileList = dir.listFiles();

               //fetch ini files.
               for(File file: fileList) {
                  fileName = file.getName();
                  if (file.isFile() && fileName.indexOf(".") > 0 ) {
                     extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
                     if ("ini".equals(extension)) { 
                        shortNames = iniFileEnumSection(buildHomePath + File.separator + fileName, "ShortName", true, false);
                        if (shortNames.size() == 1) {
                           component =  shortNames.get(0).trim().toLowerCase();
                        } else {
                           component = fileName.substring(0,fileName.lastIndexOf(".")).toLowerCase();
                        }                        
                        deployIniFilesBuildHome.put(component, fileName);
                     }
                  }
               }
               for (String activeComponent : activeComponents) {
                  //Check if processed in delivery
                  if (!deployIniFilesDelivery.containsKey(activeComponent)) {
                     if (deployIniFilesBuildHome.containsKey(activeComponent)) {
                        connections = iniFileEnumSection(buildHomePath + File.separator + deployIniFilesBuildHome.get(activeComponent), "Connections", false);
                        for (String connection : connections) {
                           if (connection.indexOf("=") > 0 && !connection.split("=")[1].equals("")) {
                              String dependentComponent = connection.split("=")[0].toLowerCase();
                              String dependentType = connection.split("=")[1].toUpperCase();
                              if ("STATIC".equals(dependentType) && !activeComponents.contains(dependentComponent)) {
                                 if (!activeComponentsNotOk.containsKey(activeComponent))
                                    activeComponentsNotOk.put(activeComponent, new ArrayList<>());
                                 activeComponentsNotOk.get(activeComponent).add(dependentComponent);
                              }
                           }
                        }
                     }
                  }
               }     
            }
         }  
         for (String activeComponent : activeComponents) {
            if (!deployIniFilesDelivery.containsKey(activeComponent) && !deployIniFilesBuildHome.containsKey(activeComponent))
               noExistingdeployInis.add(activeComponent);
         }
   	}
      if (activeComponentsNotOk.size() > 0 || noExistingdeployInis.size() > 0) {
         //activeComponentsNotOk
         String output = lineSeparator + 
                        "Listed active components require following STATIC dependent component(s) to get activated." + lineSeparator + 
                        "(Verify the STATIC definitions in the deploy.ini and the activated components defined in the solutionset file are valid.)";
         for (String activeComponent : activeComponents) {
            if (activeComponentsNotOk.containsKey(activeComponent)) { 
               output += lineSeparator + activeComponent + ": ";
               boolean first = true;
               for (String activeComponentNotOk : activeComponentsNotOk.get(activeComponent)) {
                  output += first ? activeComponentNotOk : ", " + activeComponentNotOk;
                  first = false;
               }
            }
         }
         //noExistingdeployInis
         String output2 = lineSeparator + 
                        "Missing <component>.ini files in <delivery> or <build_home> for components defined as active in the solutionset file:";
         for (String noExistingdeployIni : noExistingdeployInis) {
            output2 += lineSeparator + noExistingdeployIni;
         } 
         if (activeComponentsNotOk.size() > 0 && noExistingdeployInis.size() > 0) {
            throw new DbBuildException("ERROR:" + output + lineSeparator + output2);        
         } else if (activeComponentsNotOk.size() > 0 && noExistingdeployInis.isEmpty()) {
            throw new DbBuildException("ERROR:" + output); 
         } else {
            throw new DbBuildException("ERROR:" + output2);            
         }
      }
      return true;
   }  
   
   /**
   * Method that search for start section and returns the "mode".
   * @param line
    * @return 
   */
   public static String GetSectionStart(String line) {
      String returnStr = "";
      if (line.startsWith("-- [") && line.trim().endsWith("Start]")) {
         returnStr = line.replace("-- [", "").replace("Start]", "");
      }
      return returnStr;
   }

   /**
   * Method that returns true if is end of specified section.
   * @param line
   * @param section
    * @return 
   */
   public static boolean IsSectionEnd(String line, String section){
      return line.equals("-- [" + section + "Stop]");
   }
   
   /**
   * Method that creates the different sections, defined in the template files..
   * @param section
   * @param deliveryPath
   */
   private List<String> CreateInstallSection(String section, String deliveryPath) throws DbBuildException
   {
      List<String> lines = new ArrayList<>();
      switch (section) {
         case "PreUpgradeSection":
            lines = GetPreUpgradeSection(deliveryPath);
            break;
         case "BootstrapSection":
            lines = GetBootstrapSection(deliveryPath);
            break;            
         case "ComponentSectionFndbas":
            lines = GetComponentSectionFndbas(deliveryPath);
            break;  
         case "ComponentSectionBaseServer":
            lines = GetComponentSectionBaseServer(deliveryPath);
            break;  
         case "ComponentSectionBusinessLogic":
            lines = GetComponentSectionBusinessLogic(deliveryPath);
            break;  
         case "ComponentSectionClient":
            lines = GetComponentSectionClient(deliveryPath);
            break;  
         case "ComponentSectionDrop":
            lines = GetComponentSectionDrop(deliveryPath);
            break;  
         case "PostInstallationObject":
            lines = PostInstallationObjectData(deliveryPath, "Object");
            break;
         case "PostInstallationData":
            lines = PostInstallationObjectData(deliveryPath, "Data");
            break;
         case "PostInstallationDataSeq":
            lines = PostInstallationObjectData(deliveryPath, "DataSeq");
            break;
      }
      return lines;
   }
   
/**
   * Method that gather data for section PreUpgrade.
   * @param deliveryPath
   */
   private List<String> GetPreUpgradeSection(String deliveryPath) throws DbBuildException {
      List<String> lines = new ArrayList<>();
      String fileName = "";
      lines.add("-- Pre Installation section");
      boolean preUpgExist = false;
      
      for (String component : installationOrder) {
         String componentName = componentNames.get(component.toLowerCase());
         String componentRegister = componentName;
         if (componentShortNames.containsKey(component.toLowerCase())) {
            componentRegister = componentShortNames.get(component.toLowerCase());
         }  

         String componentVersion = componentVersions.get(componentRegister.toLowerCase());
         if (componentVersion == null) {
            componentVersion = "FreshInstall";
         }           
         List<String> compVersions = new ArrayList<>();
         String version = "";

         compDeployIni = deliveryPath + File.separator + iniFiles.get(component.toLowerCase() + ".ini"); 
         if (new File(compDeployIni).exists()) {

            compVersions = iniFileEnumSection(compDeployIni, componentName + "Versions", false); 
            //if for some reason the ini file is not valid component deploy.ini, skip the "component".
            if (compVersions.isEmpty()) {
               continue;
            }            
            List<String> compVersionsIds = new ArrayList<>();
            for (String compVersion : compVersions) {
                compVersionsIds.add(compVersion.split("=")[0]);
            }
            for (String compVersion : compVersionsIds) {
              fileName = componentName + "_preup." + compVersion.replace(".", "").toLowerCase();
              new File(deliveryPath + File.separator + fileName).delete();
            }
            fileName = componentName + "_preup.freshinstall";
            new File(deliveryPath + File.separator + fileName).delete();
                     
            List<String> compPreUpgradeFiles = iniFileEnumSection(compDeployIni, componentName + "PreUpgrade", false);
            if (compPreUpgradeFiles.isEmpty() || !new File(deliveryPath+ File.separator + componentName + "_pre.upg").exists()) {
               continue;
            }
            
            List<String> preUpgLines = new ArrayList<>();
            version = compVersions.get(compVersions.size() -1).split("=")[0];            
            Boolean versionUpToDate = false;
            if ("VersionUpToDate".equals(componentVersion) || "UpdUpgradeOnly".equals(componentVersion)) {
               componentVersion = version;
               versionUpToDate = true;
            }           
            fileName = componentName + "_preup." + componentVersion.replace(".", "").toLowerCase();
            preUpgLines.add(String.format(preHeaderUpgDefined, fileName, componentVersion, version));
            String preUpgFile = deliveryPath + File.separator +  componentName + "_pre.upg";
            preUpgradeFiles = iniFileEnumSection(preUpgFile, preUpgrade, false, true, false);
            boolean preUpgFileFound = false;

            //Files that could be called in upgrade scenario.
            for (String preUpgradeFile : preUpgradeFiles) {
               String [] entries = preUpgradeFile.split("=");
               if (entries.length == 2 &&
                       (componentVersion.toLowerCase().equals(entries[0].toLowerCase()) || 
                       "always".equals(entries[0].toLowerCase()) ||
                       ("anyupgrade".equals(entries[0].toLowerCase()) &&
                       !"FreshInstall".equals(componentVersion) &&
                       !versionUpToDate))) {
                  preUpgFileFound = true;
                  preUpgLines.add(strLine);
                  preUpgLines.add(String.format(preStrPrompt, entries[1]));
                  preUpgLines.add(String.format(preStrStart, entries[1]));
               }
            }
            
            if (preUpgLines.size() > 0 && preUpgFileFound) {
               try (BufferedWriter output = new BufferedWriter(new FileWriter(deliveryPath + File.separator + fileName))) {
                  
                  for (String line : preUpgLines) {
                     output.append(line + lineSeparator);
                  }
               //output.write(footer_mix);
               } catch (Exception ex) {
                  throw new DbBuildException("ERROR:Error when reading " + preUpgFile + lineSeparator + ex.toString());
               }
               if (!preUpgExist) {
                  lines.add("PROMPT Pre Installation section start");
                  lines.add("");
                  lines.add(strSpoolOff);
                  lines.add("");
                  lines.add(strNoDeployLog);
                  preUpgExist = true;
               } else {
                   lines.add("");
               }
               //Defines
               if (componentDefines.containsKey(componentName.toLowerCase())) { 
                  for (String define : componentDefines.get(componentName.toLowerCase())) {
                     lines.add("DEFINE " + define);
                  }
               }

               lines.add(String.format(strComponentSpool, componentName));
               lines.add("PROMPT " + componentName + " Pre Installation section start");
               lines.add("START " + fileName);
               lines.add("PROMPT " + componentName + " Pre Installation section stop");
               lines.add(strSpoolOff);
               //Undefines
               if (componentDefines.containsKey(componentName.toLowerCase())) {
                  for (String define : componentDefines.get(componentName.toLowerCase())) {
                     lines.add("UNDEFINE " + define.split("=")[0]);
                  }
               }               
            }              
         }
      }
      if (preUpgExist) {
         lines.add(strEndNoDeployLog);
         lines.add("");
         lines.add(strSpoolInstallTem);
         lines.add("");
         lines.add("PROMPT Pre Installation section stop");
         lines.add("PROMPT");
      }
      return lines;   
   }
        
   /**
   * Method that gather data for section Bootstrap.
   * @param deliveryPath
   */
   private List<String> GetBootstrapSection(String deliveryPath) throws DbBuildException {
      List<String> lines = new ArrayList<>();
      lines.add("-- BootStrap section");
      boolean bootStrapExist = false;
      for (String component : installationOrder) {
         String componentName = componentNames.get(component.toLowerCase());
         String deployIni = deliveryPath + File.separator + iniFiles.get(component.toLowerCase() + ".ini");
         List<String> compBootstrapFiles = iniFileEnumSection(deployIni, "Bootstrap");
         if (compBootstrapFiles.isEmpty() || !new File(deliveryPath+ File.separator + componentName + "_BootStrap.sql").exists()) {
            continue;
         }
         if (!bootStrapExist) {
            lines.add("PROMPT BootStrap section start");
            lines.add("");
            lines.add(strSpoolOff);
            lines.add("");
            lines.add(strNoDeployLog);
            bootStrapExist = true;
         } else {
              lines.add("");
         }
         //Defines
         if (componentDefines.containsKey(componentName.toLowerCase())) { 
            for (String define : componentDefines.get(componentName.toLowerCase())) {
               lines.add("DEFINE " + define);
            }
         }

         lines.add(String.format(strComponentSpoolAppend, componentName));
         lines.add("PROMPT " + componentName + " BootStrap section start");
         lines.add("START " + componentName + "_BootStrap.sql");
         lines.add("PROMPT " + componentName + " BootStrap section stop");
         lines.add(strSpoolOff);
         //Undefines
         if (componentDefines.containsKey(componentName.toLowerCase())) {
            for (String define : componentDefines.get(componentName.toLowerCase())) {
               lines.add("UNDEFINE " + define.split("=")[0]);
            }
         }
      }
      if (bootStrapExist) {
         lines.add(strEndNoDeployLog);
         lines.add("");
         lines.add(strSpoolInstallTem);
         lines.add("");
         lines.add("PROMPT BootStrap section stop");
         lines.add("PROMPT");
      }
      return lines;   
   }
    
   /**
   * Method that gather data for section Component.
   * @param deliveryPath
   */
   private List<String> GetComponentSectionFndbas(String deliveryPath) throws DbBuildException {
      
      List<String> lines = new ArrayList<>();
      
      File dir = new File(deliveryPath );
      File[] fileList = dir.listFiles();
      String fileName = "";

      HashMap<String, List<String>> componentFiles = new HashMap<>();
      
      //Gathering all merged files in specified order
      List<String> mergedExtensions = Arrays.asList("cre", "upg", "cdb", "api", "apv", "apy", "rdf");
      for (String extension : mergedExtensions) {
         for (File file: fileList) {
            fileName = file.getName();
            if (file.isFile() && fileName.indexOf(".") > 0) {
               if (extension.equals(fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase())) {
                  String componentName = fileName.substring(0, fileName.lastIndexOf(".")).toUpperCase();
                  if (componentName.equalsIgnoreCase("fndbas")) {
                     if (installationOrder.contains(componentName)) {
                        if (!componentFiles.containsKey(componentName)) {
                           componentFiles.put(componentName, new ArrayList<String>());
                        }
                        componentFiles.get(componentName).add(fileName);
                     }
                  }
               }
            }
         }
      }
      
      if (componentFiles.size() > 0) {
         List<String> compExtensions = new ArrayList<>();
         if (installTemAdvance) {
            compExtensions.add("*");
         } else {
            compExtensions.addAll(mergedExtensions);
         }
         HashMap<String, List<String>> processedComponents = new HashMap<>();      
         HashMap<String, List<String>> compExtensionsToProcess = new HashMap<>();      

         if (!installTemAdvance){
            String component = "FNDBAS";
            if (componentNames.get(component.toLowerCase()).equalsIgnoreCase("fndbas")) {
               compExtensionsToProcess.put(component, new ArrayList<String>());
               if (componentFiles.containsKey(component)) {
                  String componentRegister = componentNames.get(component.toLowerCase());
                  if (componentShortNames.containsKey(component.toLowerCase())) {
                     componentRegister = componentShortNames.get(component.toLowerCase());
                  }
                  String componentVersion = componentVersions.get(componentRegister.toLowerCase());
                  if (componentVersion == null) {
                     componentVersion = "FreshInstall";
                  }  
                  for (String file : componentFiles.get(component)) {
                     if (("FreshInstall".equals(componentVersion)
                             && ("upg".equals(file.split(Pattern.quote("."))[1]) || "cdb".equals(file.split(Pattern.quote("."))[1]))) || 
                             (!"FreshInstall".equals(componentVersion) && "cre".equals(file.split(Pattern.quote("."))[1]))) {
                        continue;
                     }
                     compExtensionsToProcess.get(component).add(file.split(Pattern.quote("."))[1]);
                  }                  
               }
            }
         }      

         if (installTemAdvance) {
            lines.add("-- [Thread packed components]");
         }
         for (String extension : compExtensions) {
            String component = "FNDBAS";
            if (componentNames.get(component.toLowerCase()).equalsIgnoreCase("fndbas")) {
               try {
                  if (!installTemAdvance) {
                     //jump to next component, no files to process
                     if ((compExtensionsToProcess.get(component).isEmpty() && processedComponents.containsKey(component)) || 
                        (compExtensionsToProcess.get(component).size() > 0 && !compExtensionsToProcess.get(component).contains(extension))) {
                           continue;
                     }
                  }
                  String componentName = componentNames.get(component.toLowerCase());

                  String version = "";
                  String versionDesc = "";
                  String upgVersion = "";
                  String componentRegister = componentName;
                  String upd = "";
                  if (componentShortNames.containsKey(component.toLowerCase())) {
                     componentRegister = componentShortNames.get(component.toLowerCase());
                  }
                  String componentDescription = "";
                  if (componentDescriptions.containsKey(component.toLowerCase())) {
                     componentDescription = componentDescriptions.get(component.toLowerCase());
                  }
                  String componentVersion = componentVersions.get(componentRegister.toLowerCase());
                  if (componentVersion == null) {
                     componentVersion = "FreshInstall";
                  }

                  List<String> compVersions = new ArrayList<>();
                  List<String> compVersionsIds = new ArrayList<>();
                  compDeployIni = deliveryPath + File.separator + iniFiles.get(component.toLowerCase() + ".ini"); 
                  if (new File(compDeployIni).exists()) {
                     compVersions = iniFileEnumSection(compDeployIni, componentName + "Versions", false);
                     //if for some reason the ini file is not valid component deploy.ini, skip the "component".
                     if (compVersions.isEmpty()) {
                        continue;
                     }
                     version = compVersions.get(compVersions.size() -1).split("=")[0];
                     versionDesc = compVersions.get(compVersions.size() -1).split("=")[1];
                     buildOptions = iniFileEnumSection(compDeployIni, componentName + "BuildOptions", false);

                  }

                  for (String compVersion : compVersions) {
                      compVersionsIds.add(compVersion.split("=")[0]);
                  }

                  for (String buildOption : buildOptions) {
                     if (buildOption.startsWith("UPD=")) {
                        upd = buildOption.split("=")[1];
                        break;
                     }
                  }

                  String updVersionHeader = "";
                  String updVersionFooter = "";         

                  if (!"".equals(upd) && upd.split(" ").length > 1 && !"VersionUpToDate".equals(componentVersion)) {
                     updVersionHeader = " (UPD: " + upd.replace("CORE", "Core") + ")";
                     updVersionFooter = "', '(UPD: " + upd.replace("CORE", "Core") + ")";
                  }         

                  String lineHeader = updVersionHeader;
                  switch (componentVersion) {
                     case "FreshInstall":
                        lineHeader = "".equals(updVersionHeader) ? ". Fresh install" : ". Fresh install," + updVersionHeader;
                        break;
                     case "VersionUpToDate":
                        upgVersion = version;
                        lineHeader = ". Version up to date";
                        break;
                     case "UpdUpgradeOnly":
                        lineHeader = ". Version up to date, UPD update:" + updVersionHeader;
                        break;
                     default:
                        if (compVersionsIds.contains(componentVersion)) {
                           upgVersion = componentVersion;
                           lineHeader = " (upgrade from version " + upgVersion + ")";
                        }
                        break;
                  }

                  lines.add("");
                  lines.add(String.format(strComponent, componentRegister)); 
                  lines.add(String.format(strComponentSpoolAppend, componentName));
                  lines.add(String.format(strComponentPrompt, componentName, version + lineHeader));

                  if (componentFiles.containsKey(component)) {
                     if (componentDefines.containsKey(componentName.toLowerCase())) {
                        for (String define : componentDefines.get(componentName.toLowerCase())) {
                           lines.add("DEFINE " + define);
                        }
                     }
                     for (String file : componentFiles.get(component)) {
                        //process only the filtype delcared in extension. In advanceMode the extension is '*'
                        if (!installTemAdvance && !extension.equals(file.split(Pattern.quote("."))[1])) {
                           continue;
                        }
                        if ("cre".equals(file.split(Pattern.quote("."))[1]) || "upg".equals(file.split(Pattern.quote("."))[1])) {
                           for (String compVersion : compVersionsIds) {
                             fileName = componentName + "up." + compVersion.replace(".", "").toLowerCase();
                             new File(deliveryPath + File.separator + fileName).delete();
                           }
                        }

                        if ("FreshInstall".equals(componentVersion)
                                && !"upg".equals(file.split(Pattern.quote("."))[1]) && !"cdb".equals(file.split(Pattern.quote("."))[1])) {
                           lines.add("START " + file);
                        }

                        if (!"FreshInstall".equals(componentVersion) && !"cre".equals(file.split(Pattern.quote("."))[1])) {
                           if ("upg".equals(file.split(Pattern.quote("."))[1])) {
                              boolean versionFound = false;
                              List<String> upgLines = new ArrayList<>();
                              fileName = componentName + "up." + upgVersion.replace(".", "");
                              upgLines.add(String.format(headerUpgDefined, fileName, upgVersion, version));
                              String upgFile = deliveryPath + File.separator +  componentName + ".upg";
                              if (new File(upgFile).exists()) {
                                 //String line = "";
                                 try {
                                    String line;
                                    try (BufferedReader reader = new BufferedReader(new FileReader(deliveryPath + File.separator +  componentName + ".upg"))) {
                                       while ((line = reader.readLine()) != null){
                                          if (line.startsWith("[" + upgVersion + "]")) {
                                             versionFound = true;
                                             upgLines.add("-- [" + upgVersion + "]");
                                             continue;
                                           }

                                           if (versionFound) {
                                              if (line.startsWith("[")) {
                                                 upgLines.add("-- " + line);
                                              } else {
                                                 upgLines.add(line);
                                              }
                                           }
                                       }
                                    }
                                 } catch (IOException ex) {
                                    throw new DbBuildException("ERROR:Error when reading " + upgFile + lineSeparator + ex.toString());
                                 }                           

                                 try {
                                    if (upgLines.size() > 0 && versionFound) {
                                       File outputFile = new File(deliveryPath + File.separator + fileName);
                                       try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
                                          for (String line : upgLines) {
                                             output.write(line + lineSeparator);
                                          }
                                          lines.add("START " + fileName);
                                       }
                                    }
                                 } catch (IOException ex) {
                                    throw new DbBuildException("ERROR:Error when reading " + upgFile + lineSeparator + ex.toString());
                                 }
                              }
                           } else {
                              lines.add("START " + file);               
                           }
                        }
                     }
                     if (componentDefines.containsKey(componentName.toLowerCase())) {
                        for (String define : componentDefines.get(componentName.toLowerCase())) {
                           lines.add("UNDEFINE " + define.split("=")[0]);
                        }
                     }            
                  }

                  if (!installTemAdvance) {
                     if (!processedComponents.containsKey(component)) {
                        processedComponents.put(component, new ArrayList<String>());
                     }

                     if (compExtensionsToProcess.get(component).size() > 0) {
                        processedComponents.get(component).add(extension);
                     }
                 }

                  if (!autoGeneratedComponents.contains(component)) {
                     if (installTemAdvance || (!installTemAdvance && compExtensionsToProcess.get(component).size() == processedComponents.get(component).size())) {
                        lines.add(String.format(temCompFooter, componentRegister.toUpperCase(), componentDescription, version, versionDesc + updVersionFooter));
                     }
                  }
                  lines.add(strSpoolOff);
                  lines.add(strEndComponent);
               } catch (DbBuildException ex) {
                  throw new DbBuildException("ERROR:Error when creating install.tem, check info for component: " + component + lineSeparator  + ex.toString());
               }  
            }
         }

         if (installTemAdvance) {
            lines.add("");
            lines.add("-- [End thread]");
         }
      } else {
         lines.add("");
      }
      return lines;
   }
   
   /**
   * Method that gather data for section Component.
   * @param deliveryPath
   */
   private List<String> GetComponentSectionBaseServer(String deliveryPath) throws DbBuildException {
      
      List<String> lines = new ArrayList<>();
      
      File dir = new File(deliveryPath );
      File[] fileList = dir.listFiles();
      String fileName = "";

      HashMap<String, List<String>> componentFiles = new HashMap<>();
      
      //Gathering all merged files in specified order
      List<String> mergedExtensions = Arrays.asList("cre", "upg", "cdb", "api", "apv");
      for (String extension : mergedExtensions) {
         for (File file: fileList) {
            fileName = file.getName();
            if (file.isFile() && fileName.indexOf(".") > 0) {
               if (extension.equals(fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase())) {
                  String componentName = fileName.substring(0, fileName.lastIndexOf(".")).toUpperCase();
                  if (!componentName.equalsIgnoreCase("fndbas")) {
                     if (installationOrder.contains(componentName)) {
                        if (!componentFiles.containsKey(componentName)) {
                           componentFiles.put(componentName, new ArrayList<String>());
                        }
                        componentFiles.get(componentName).add(fileName);
                     }
                  }
               }
            }
         }
      }
      
      List<String> compExtensions = new ArrayList<>();
      if (installTemAdvance) {
         compExtensions.add("*");
      } else {
         compExtensions.addAll(mergedExtensions);
      }
      HashMap<String, List<String>> processedComponents = new HashMap<>();      
      HashMap<String, List<String>> compExtensionsToProcess = new HashMap<>();      
      
      if (!installTemAdvance){
         for (String component : installationOrder) {
            if (!componentNames.get(component.toLowerCase()).equalsIgnoreCase("fndbas")) {
               compExtensionsToProcess.put(component, new ArrayList<String>());
               if (componentFiles.containsKey(component)) {
                  String componentRegister = componentNames.get(component.toLowerCase());
                  if (componentShortNames.containsKey(component.toLowerCase())) {
                     componentRegister = componentShortNames.get(component.toLowerCase());
                  }
                  String componentVersion = componentVersions.get(componentRegister.toLowerCase());
                  if (componentVersion == null) {
                     componentVersion = "FreshInstall";
                  }  
                  for (String file : componentFiles.get(component)) {
                     if (("FreshInstall".equals(componentVersion)
                             && ("upg".equals(file.split(Pattern.quote("."))[1]) || "cdb".equals(file.split(Pattern.quote("."))[1]))) || 
                             (!"FreshInstall".equals(componentVersion) && "cre".equals(file.split(Pattern.quote("."))[1]))) {
                        continue;
                     }
                     compExtensionsToProcess.get(component).add(file.split(Pattern.quote("."))[1]);
                  }                  
               }
            }
         }
      }      
   
      if (installTemAdvance) {
         lines.add("-- [Thread packed components]");
      }
      for (String extension : compExtensions) {
         for(String component : installationOrder) {
            if (!componentNames.get(component.toLowerCase()).equalsIgnoreCase("fndbas")) {
               try {
                  if (!installTemAdvance) {
                     //jump to next component, no files to process
                     if ((compExtensionsToProcess.get(component).isEmpty() && processedComponents.containsKey(component)) || 
                        (compExtensionsToProcess.get(component).size() > 0 && !compExtensionsToProcess.get(component).contains(extension))) {
                           continue;
                     }
                  }
                  String componentName = componentNames.get(component.toLowerCase());

                  String version = "";
                  String versionDesc = "";
                  String upgVersion = "";
                  String componentRegister = componentName;
                  String upd = "";
                  if (componentShortNames.containsKey(component.toLowerCase())) {
                     componentRegister = componentShortNames.get(component.toLowerCase());
                  }
                  String componentDescription = "";
                  if (componentDescriptions.containsKey(component.toLowerCase())) {
                     componentDescription = componentDescriptions.get(component.toLowerCase());
                  }
                  String componentVersion = componentVersions.get(componentRegister.toLowerCase());
                  if (componentVersion == null) {
                     componentVersion = "FreshInstall";
                  }

                  List<String> compVersions = new ArrayList<>();
                  List<String> compVersionsIds = new ArrayList<>();
                  compDeployIni = deliveryPath + File.separator + iniFiles.get(component.toLowerCase() + ".ini"); 
                  if (new File(compDeployIni).exists()) {
                     compVersions = iniFileEnumSection(compDeployIni, componentName + "Versions", false);
                     //if for some reason the ini file is not valid component deploy.ini, skip the "component".
                     if (compVersions.isEmpty()) {
                        continue;
                     }
                     version = compVersions.get(compVersions.size() -1).split("=")[0];
                     versionDesc = compVersions.get(compVersions.size() -1).split("=")[1];
                     buildOptions = iniFileEnumSection(compDeployIni, componentName + "BuildOptions", false);

                  }

                  for (String compVersion : compVersions) {
                      compVersionsIds.add(compVersion.split("=")[0]);
                  }

                  for (String buildOption : buildOptions) {
                     if (buildOption.startsWith("UPD=")) {
                        upd = buildOption.split("=")[1];
                        break;
                     }
                  }

                  String updVersionHeader = "";
                  String updVersionFooter = "";         

                  if (!"".equals(upd) && upd.split(" ").length > 1 && !"VersionUpToDate".equals(componentVersion)) {
                     updVersionHeader = " (UPD: " + upd.replace("CORE", "Core") + ")";
                     updVersionFooter = "', '(UPD: " + upd.replace("CORE", "Core") + ")";
                  }         

                  String lineHeader = updVersionHeader;
                  switch (componentVersion) {
                     case "FreshInstall":
                        lineHeader = "".equals(updVersionHeader) ? ". Fresh install" : ". Fresh install," + updVersionHeader;
                        break;
                     case "VersionUpToDate":
                        upgVersion = version;
                        lineHeader = ". Version up to date";
                        break;
                     case "UpdUpgradeOnly":
                        lineHeader = ". Version up to date, UPD update:" + updVersionHeader;
                        break;
                     default:
                        if (compVersionsIds.contains(componentVersion)) {
                           upgVersion = componentVersion;
                           lineHeader = " (upgrade from version " + upgVersion + ")";
                        }
                        break;
                  }

                  lines.add("");
                  lines.add(String.format(strComponent, componentRegister)); 
                  lines.add(String.format(strComponentSpoolAppend, componentName));
                  lines.add(String.format(strComponentPrompt, componentName, version + lineHeader));

                  if (componentFiles.containsKey(component)) {
                     if (componentDefines.containsKey(componentName.toLowerCase())) {
                        for (String define : componentDefines.get(componentName.toLowerCase())) {
                           lines.add("DEFINE " + define);
                        }
                     }
                     for (String file : componentFiles.get(component)) {
                        //process only the filtype delcared in extension. In advanceMode the extension is '*'
                        if (!installTemAdvance && !extension.equals(file.split(Pattern.quote("."))[1])) {
                           continue;
                        }
                        if ("cre".equals(file.split(Pattern.quote("."))[1]) || "upg".equals(file.split(Pattern.quote("."))[1])) {
                           for (String compVersion : compVersionsIds) {
                             fileName = componentName + "up." + compVersion.replace(".", "").toLowerCase();
                             new File(deliveryPath + File.separator + fileName).delete();
                           }
                        }

                        if ("FreshInstall".equals(componentVersion)
                                && !"upg".equals(file.split(Pattern.quote("."))[1]) && !"cdb".equals(file.split(Pattern.quote("."))[1])) {
                           lines.add("START " + file);
                        }

                        if (!"FreshInstall".equals(componentVersion) && !"cre".equals(file.split(Pattern.quote("."))[1])) {
                           if ("upg".equals(file.split(Pattern.quote("."))[1])) {
                              boolean versionFound = false;
                              List<String> upgLines = new ArrayList<>();
                              fileName = componentName + "up." + upgVersion.replace(".", "");
                              upgLines.add(String.format(headerUpgDefined, fileName, upgVersion, version));
                              String upgFile = deliveryPath + File.separator +  componentName + ".upg";
                              if (new File(upgFile).exists()) {
                                 //String line = "";
                                 try {
                                    String line;
                                    try (BufferedReader reader = new BufferedReader(new FileReader(deliveryPath + File.separator +  componentName + ".upg"))) {
                                       while ((line = reader.readLine()) != null){
                                          if (line.startsWith("[" + upgVersion + "]")) {
                                             versionFound = true;
                                             upgLines.add("-- [" + upgVersion + "]");
                                             continue;
                                           }

                                           if (versionFound) {
                                              if (line.startsWith("[")) {
                                                 upgLines.add("-- " + line);
                                              } else {
                                                 upgLines.add(line);
                                              }
                                           }
                                       }
                                    }
                                 } catch (IOException ex) {
                                    throw new DbBuildException("ERROR:Error when reading " + upgFile + lineSeparator + ex.toString());
                                 }                           

                                 try {
                                    if (upgLines.size() > 0 && versionFound) {
                                       File outputFile = new File(deliveryPath + File.separator + fileName);
                                       try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
                                          for (String line : upgLines) {
                                             output.write(line + lineSeparator);
                                          }
                                          lines.add("START " + fileName);
                                       }
                                    }
                                 } catch (IOException ex) {
                                    throw new DbBuildException("ERROR:Error when reading " + upgFile + lineSeparator + ex.toString());
                                 }
                              }
                           } else {
                              lines.add("START " + file);               
                           }
                        }
                     }
                     if (componentDefines.containsKey(componentName.toLowerCase())) {
                        for (String define : componentDefines.get(componentName.toLowerCase())) {
                           lines.add("UNDEFINE " + define.split("=")[0]);
                        }
                     }            
                  }

                  if (!installTemAdvance) {
                     if (!processedComponents.containsKey(component)) {
                        processedComponents.put(component, new ArrayList<String>());
                     }

                     if (compExtensionsToProcess.get(component).size() > 0) {
                        processedComponents.get(component).add(extension);
                     }
                 }

                  if (!autoGeneratedComponents.contains(component)) {
                     if (installTemAdvance || (!installTemAdvance && compExtensionsToProcess.get(component).size() == processedComponents.get(component).size())) {
                        lines.add(String.format(temCompFooter, componentRegister.toUpperCase(), componentDescription, version, versionDesc + updVersionFooter));
                     }
                  }
                  lines.add(strSpoolOff);
                  lines.add(strEndComponent);
               } catch (DbBuildException ex) {
                  throw new DbBuildException("ERROR:Error when creating install.tem, check info for component: " + component + lineSeparator  + ex.toString());
               }  
            } 
         } 
      }
      
      if (installTemAdvance) {
         lines.add("");
         lines.add("-- [End thread]");
      }
            
      return lines;
   }
   
   /**
   * Method that gather data for section Component.
   * @param deliveryPath
   */
   private List<String> GetComponentSectionBusinessLogic(String deliveryPath) throws DbBuildException {
      
      List<String> lines = new ArrayList<>();
      
      File dir = new File(deliveryPath );
      File[] fileList = dir.listFiles();
      String fileName = "";

      HashMap<String, List<String>> componentFiles = new HashMap<>();
      
      //Gathering all merged files containing business logic in specified order
      List<String> mergedExtensions = Arrays.asList("apy", "rdf");
      for (String extension : mergedExtensions) {
         for (File file: fileList) {
            fileName = file.getName();
            if (file.isFile() && fileName.indexOf(".") > 0) {
               if (extension.equals(fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase())) {
                  String componentName = fileName.substring(0, fileName.lastIndexOf(".")).toUpperCase();
                  if (!componentName.equalsIgnoreCase("fndbas")) {
                     if (installationOrder.contains(componentName)) {
                        if (!componentFiles.containsKey(componentName)) {
                           componentFiles.put(componentName, new ArrayList<String>());
                        }
                        componentFiles.get(componentName).add(fileName);
                     }
                  }
               }
            }
         }
      }
      
      List<String> compExtensions = new ArrayList<>();
      if (installTemAdvance) {
         compExtensions.add("*");
      } else {
         compExtensions.addAll(mergedExtensions);
      }
      HashMap<String, List<String>> processedComponents = new HashMap<>();      
      HashMap<String, List<String>> compExtensionsToProcess = new HashMap<>();      
      if (!installTemAdvance){
         for (String component : installationOrder) {
            if (!componentNames.get(component.toLowerCase()).equalsIgnoreCase("fndbas")) {
               compExtensionsToProcess.put(component, new ArrayList<String>());
               if (componentFiles.containsKey(component)) {
                  String componentRegister = componentNames.get(component.toLowerCase());
                  if (componentShortNames.containsKey(component.toLowerCase())) {
                     componentRegister = componentShortNames.get(component.toLowerCase());
                  }
                  String componentVersion = componentVersions.get(componentRegister.toLowerCase());
                  if (componentVersion == null) {
                     componentVersion = "FreshInstall";
                  }  
                  for (String file : componentFiles.get(component)) {
                     if (("FreshInstall".equals(componentVersion)
                             && ("upg".equals(file.split(Pattern.quote("."))[1]) || "cdb".equals(file.split(Pattern.quote("."))[1]))) || 
                             (!"FreshInstall".equals(componentVersion) && "cre".equals(file.split(Pattern.quote("."))[1]))) {
                        continue;
                     }
                     compExtensionsToProcess.get(component).add(file.split(Pattern.quote("."))[1]);
                  }                  
               }
            }
         }
      }      
      
      if (installTemAdvance) {
         lines.add("-- [Thread packed components]");
      }
      for (String extension : compExtensions) {
         for(String component : installationOrder) {
            if (!componentNames.get(component.toLowerCase()).equalsIgnoreCase("fndbas")) {
               if (componentFiles.containsKey(component)) {
                  try {
                     if (!installTemAdvance) {
                        //jump to next component, no files to process
                        if ((compExtensionsToProcess.get(component).isEmpty() && processedComponents.containsKey(component)) || 
                           (compExtensionsToProcess.get(component).size() > 0 && !compExtensionsToProcess.get(component).contains(extension))) {
                              continue;
                        }
                     }
                     String componentName = componentNames.get(component.toLowerCase());
                     String version = "";
                     String upgVersion = "";
                     String componentRegister = componentName;
                     String upd = "";
                     if (componentShortNames.containsKey(component.toLowerCase())) {
                        componentRegister = componentShortNames.get(component.toLowerCase());
                     }
                     String componentVersion = componentVersions.get(componentRegister.toLowerCase());
                     if (componentVersion == null) {
                        componentVersion = "FreshInstall";
                     }

                     List<String> compVersions = new ArrayList<>();
                     List<String> compVersionsIds = new ArrayList<>();
                     compDeployIni = deliveryPath + File.separator + iniFiles.get(component.toLowerCase() + ".ini"); 
                     if (new File(compDeployIni).exists()) {
                        compVersions = iniFileEnumSection(compDeployIni, componentName + "Versions", false);
                        //if for some reason the ini file is not valid component deploy.ini, skip the "component".
                        if (compVersions.isEmpty()) {
                           continue;
                        }
                        version = compVersions.get(compVersions.size() -1).split("=")[0];
                        buildOptions = iniFileEnumSection(compDeployIni, componentName + "BuildOptions", false);

                     }

                     for (String compVersion : compVersions) {
                         compVersionsIds.add(compVersion.split("=")[0]);
                     }

                     for (String buildOption : buildOptions) {
                        if (buildOption.startsWith("UPD=")) {
                           upd = buildOption.split("=")[1];
                           break;
                        }
                     }

                     String updVersionHeader = "";

                     if (!"".equals(upd) && upd.split(" ").length > 1 && !"VersionUpToDate".equals(componentVersion)) {
                        updVersionHeader = " (UPD: " + upd.replace("CORE", "Core") + ")";
                     }         

                     String lineHeader = updVersionHeader;
                     switch (componentVersion) {
                        case "FreshInstall":
                           lineHeader = "".equals(updVersionHeader) ? ". Fresh install" : ". Fresh install," + updVersionHeader;
                           break;
                        case "VersionUpToDate":
                           upgVersion = version;
                           lineHeader = ". Version up to date";
                           break;
                        case "UpdUpgradeOnly":
                           lineHeader = ". Version up to date, UPD update:" + updVersionHeader;
                           break;
                        default:
                           if (compVersionsIds.contains(componentVersion)) {
                              upgVersion = componentVersion;
                              lineHeader = " (upgrade from version " + upgVersion + ")";
                           }
                           break;
                     }

                     lines.add("");
                     lines.add(String.format(strComponent, componentRegister)); 
                     lines.add(String.format(strComponentSpoolAppend, componentName));
                     lines.add(String.format(strComponentPrompt, componentName, version + lineHeader));

                     if (componentFiles.containsKey(component)) {
                        if (componentDefines.containsKey(componentName.toLowerCase())) {
                           for (String define : componentDefines.get(componentName.toLowerCase())) {
                              lines.add("DEFINE " + define);
                           }
                        }
                        for (String file : componentFiles.get(component)) {
                           //process only the filtype delcared in extension. In advanceMode the extension is '*'
                           if (!installTemAdvance && !extension.equals(file.split(Pattern.quote("."))[1])) {
                              continue;
                           }

                           lines.add("START " + file);
                        }
                        if (componentDefines.containsKey(componentName.toLowerCase())) {
                           for (String define : componentDefines.get(componentName.toLowerCase())) {
                              lines.add("UNDEFINE " + define.split("=")[0]);
                           }
                        }
                     }

                     if (!installTemAdvance) {
                        if (!processedComponents.containsKey(component)) {
                           processedComponents.put(component, new ArrayList<String>());
                        }

                        if (compExtensionsToProcess.get(component).size() > 0) {
                           processedComponents.get(component).add(extension);
                        }
                     }

                     lines.add(strSpoolOff);
                     lines.add(strEndComponent);
                  } catch (DbBuildException ex) {
                     throw new DbBuildException("ERROR:Error when creating install.tem, check info for component: " + component + lineSeparator  + ex.toString());
                  }  
               }  
            }
         }
      }
      
      if (installTemAdvance) {
         lines.add("");
         lines.add("-- [End thread]");
      }
            
      return lines;
   }

   /**
   * Method that gather data for section Component.
   * @param deliveryPath
   */
   private List<String> GetComponentSectionClient(String deliveryPath) throws DbBuildException {
      
      List<String> lines = new ArrayList<>();
      
      File dir = new File(deliveryPath );
      File[] fileList = dir.listFiles();
      String fileName = "";

      HashMap<String, List<String>> componentFiles = new HashMap<>();
      
      //Gathering all merged files containing client setup in specified order
      List<String> mergedExtensions = Arrays.asList("ins", "svc", "obd", "cpi", "sch", "apn");
      for (String extension : mergedExtensions) {
         for (File file: fileList) {
            fileName = file.getName();
            if (file.isFile() && fileName.indexOf(".") > 0) {
               if (extension.equals(fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase())) {
                  String componentName = fileName.substring(0, fileName.lastIndexOf(".")).toUpperCase();
                  if (installationOrder.contains(componentName)) {
                     if (!componentFiles.containsKey(componentName)) {
                        componentFiles.put(componentName, new ArrayList<String>());
                     }
                     componentFiles.get(componentName).add(fileName);
                  }
               }
            }
         }
      }
      
      List<String> compExtensions = new ArrayList<>();
      if (installTemAdvance) {
         compExtensions.add("*");
      } else {
         compExtensions.addAll(mergedExtensions);
      }
      HashMap<String, List<String>> processedComponents = new HashMap<>();      
      HashMap<String, List<String>> compExtensionsToProcess = new HashMap<>();      
      if (!installTemAdvance){
         for (String component : installationOrder) {
            compExtensionsToProcess.put(component, new ArrayList<String>());
            if (componentFiles.containsKey(component)) {
               String componentRegister = componentNames.get(component.toLowerCase());
               if (componentShortNames.containsKey(component.toLowerCase())) {
                  componentRegister = componentShortNames.get(component.toLowerCase());
               }
               String componentVersion = componentVersions.get(componentRegister.toLowerCase());
               if (componentVersion == null) {
                  componentVersion = "FreshInstall";
               }  
               for (String file : componentFiles.get(component)) {
                  if (("FreshInstall".equals(componentVersion)
                          && ("upg".equals(file.split(Pattern.quote("."))[1]) || "cdb".equals(file.split(Pattern.quote("."))[1]))) || 
                          (!"FreshInstall".equals(componentVersion) && "cre".equals(file.split(Pattern.quote("."))[1]))) {
                     continue;
                  }
                  compExtensionsToProcess.get(component).add(file.split(Pattern.quote("."))[1]);
               }                  
            }
         }
      }      
      
      if (installTemAdvance) {
         lines.add("-- [Thread packed components]");
      }
      for (String extension : compExtensions) {
         for(String component : installationOrder) {
            if (componentFiles.containsKey(component)) {
               try {
                  if (!installTemAdvance) {
                     //jump to next component, no files to process
                     if ((compExtensionsToProcess.get(component).isEmpty() && processedComponents.containsKey(component)) || 
                        (compExtensionsToProcess.get(component).size() > 0 && !compExtensionsToProcess.get(component).contains(extension))) {
                           continue;
                     }
                  }
                  String componentName = componentNames.get(component.toLowerCase());
                  String version = "";
                  String upgVersion = "";
                  String componentRegister = componentName;
                  String upd = "";
                  if (componentShortNames.containsKey(component.toLowerCase())) {
                     componentRegister = componentShortNames.get(component.toLowerCase());
                  }
                  String componentVersion = componentVersions.get(componentRegister.toLowerCase());
                  if (componentVersion == null) {
                     componentVersion = "FreshInstall";
                  }

                  List<String> compVersions = new ArrayList<>();
                  List<String> compVersionsIds = new ArrayList<>();
                  compDeployIni = deliveryPath + File.separator + iniFiles.get(component.toLowerCase() + ".ini"); 
                  if (new File(compDeployIni).exists()) {
                     compVersions = iniFileEnumSection(compDeployIni, componentName + "Versions", false);
                     //if for some reason the ini file is not valid component deploy.ini, skip the "component".
                     if (compVersions.isEmpty()) {
                        continue;
                     }
                     version = compVersions.get(compVersions.size() -1).split("=")[0];
                     buildOptions = iniFileEnumSection(compDeployIni, componentName + "BuildOptions", false);

                  }

                  for (String compVersion : compVersions) {
                      compVersionsIds.add(compVersion.split("=")[0]);
                  }

                  for (String buildOption : buildOptions) {
                     if (buildOption.startsWith("UPD=")) {
                        upd = buildOption.split("=")[1];
                        break;
                     }
                  }
                  
                  String updVersionHeader = "";

                  if (!"".equals(upd) && upd.split(" ").length > 1 && !"VersionUpToDate".equals(componentVersion)) {
                     updVersionHeader = " (UPD: " + upd.replace("CORE", "Core") + ")";
                  }         

                  String lineHeader = updVersionHeader;
                  switch (componentVersion) {
                     case "FreshInstall":
                        lineHeader = "".equals(updVersionHeader) ? ". Fresh install" : ". Fresh install," + updVersionHeader;
                        break;
                     case "VersionUpToDate":
                        upgVersion = version;
                        lineHeader = ". Version up to date";
                        break;
                     case "UpdUpgradeOnly":
                        lineHeader = ". Version up to date, UPD update:" + updVersionHeader;
                        break;
                     default:
                        if (compVersionsIds.contains(componentVersion)) {
                           upgVersion = componentVersion;
                           lineHeader = " (upgrade from version " + upgVersion + ")";
                        }
                        break;
                  }

                  lines.add("");
                  lines.add(String.format(strComponent, componentRegister)); 
                  lines.add(String.format(strComponentSpoolAppend, componentName));
                  lines.add(String.format(strComponentPrompt, componentName, version + lineHeader));

                  if (componentFiles.containsKey(component)) {
                     if (componentDefines.containsKey(componentName.toLowerCase())) {
                        for (String define : componentDefines.get(componentName.toLowerCase())) {
                           lines.add("DEFINE " + define);
                        }
                     }
                     for (String file : componentFiles.get(component)) {
                        //process only the filtype delcared in extension. In advanceMode the extension is '*'
                        if (!installTemAdvance && !extension.equals(file.split(Pattern.quote("."))[1])) {
                           continue;
                        }

                        lines.add("START " + file);
                     }
                     if (componentDefines.containsKey(componentName.toLowerCase())) {
                        for (String define : componentDefines.get(componentName.toLowerCase())) {
                           lines.add("UNDEFINE " + define.split("=")[0]);
                        }
                     }
                  }

                  if (!installTemAdvance) {
                     if (!processedComponents.containsKey(component)) {
                        processedComponents.put(component, new ArrayList<String>());
                     }

                     if (compExtensionsToProcess.get(component).size() > 0) {
                        processedComponents.get(component).add(extension);
                     }
                  }

                  lines.add(strSpoolOff);
                  lines.add(strEndComponent);
               } catch (DbBuildException ex) {
                  throw new DbBuildException("ERROR:Error when creating install.tem, check info for component: " + component + lineSeparator  + ex.toString());
               }  
            }  
         } 
      }
      
      if (installTemAdvance) {
         lines.add("");
         lines.add("-- [End thread]");
      }
            
      return lines;
   }
   
/**
   * Method that gather data for section Drop of obsoletes.
   * @param deliveryPath
   */
   private List<String> GetComponentSectionDrop(String deliveryPath) throws DbBuildException {
      List<String> lines = new ArrayList<>();
      lines.add("-- Drop obsoletes section");
      boolean dropScriptExist = false;
      if (new File(new File(deliveryPath).getParent() + File.separator + "database"+File.separator + "prifs").exists()) {
         File directoryPath = new File(new File(deliveryPath).getParent() + File.separator + "database"+File.separator + "prifs");
         FilenameFilter drpFilter = new FilenameFilter() {
            @Override
            public boolean accept(File dir, String name) {
            if (name.toLowerCase().endsWith(".drp")) {
               return true;
            }
               return false;
            }
         };
         File filesList[] = directoryPath.listFiles(drpFilter);
         String componentName ="";
         String fileName ="";
         int fileNameLength = 0;
         for(File file : filesList) {
            fileName = file.getName();
            fileNameLength = fileName.length();
            componentName = fileName.substring(0,fileNameLength - 4).toLowerCase();
            if (!dropScriptExist) {
               lines.add("PROMPT Drop obsolets section start");
               lines.add("");
               dropScriptExist = true;
            } else {
                 lines.add("");
            }

            lines.add("PROMPT Drop of component " + componentName);
            lines.add("START prifs"+ File.separator + fileName);
         }
      }
      if (dropScriptExist) {
         lines.add("");
         lines.add("SET SERVEROUTPUT ON");
         lines.add("");
         lines.add("PROMPT Cleanup caches after drop of  obsolets section stop");
         lines.add("EXEC Dictionary_SYS.Cleanup__;");
         lines.add("");
         lines.add("EXEC Reference_SYS.Cleanup__;");
         lines.add("");
         lines.add("PROMPT Drop obsolets section stop");
      } else {
         lines.add("");
         lines.add("SET SERVEROUTPUT ON");
         lines.add("");
         lines.add("PROMPT No obsolete components to drop");
      }
      return lines;   
   }
   
/**
   * Method that gather data for section Postinstallation - Objects, Data and DataSeq.
   * @param deliveryPath
   * @param mode
   */
   private List<String> PostInstallationObjectData(String deliveryPath, String mode) throws DbBuildException {
      List<String> lines = new ArrayList<>();
      lines.add("-- Post" + mode + " section");
      String fileName = "";
      boolean writeHeader = true;
      boolean postInstallationExist = false;
      
      for (String component : installationOrder) {
         String componentName = componentNames.get(component.toLowerCase());
         String componentRegister = componentName;
         if (componentShortNames.containsKey(component.toLowerCase())) {
            componentRegister = componentShortNames.get(component.toLowerCase());
         }  

         String componentVersion = componentVersions.get(componentRegister.toLowerCase());
         if (componentVersion == null) {
            componentVersion = "FreshInstall";
         }           
         List<String> compVersions = new ArrayList<>();
         String version = "";

         compDeployIni = deliveryPath + File.separator + iniFiles.get(component.toLowerCase() + ".ini"); 
         if (new File(compDeployIni).exists()) {
            List<String> postInstallationFiles = iniFileEnumSection(compDeployIni, "PostInstallation" + mode);
            if (postInstallationFiles.isEmpty() || !new File(deliveryPath + File.separator + componentName + "_Post" + mode + ".upg").exists()) {
               continue;
            }

            compVersions = iniFileEnumSection(compDeployIni, componentName + "Versions", false); 
            //if for some reason the ini file is not valid component deploy.ini, skip the "component".
            if (compVersions.isEmpty()) {
               continue;
            }            
            List<String> compVersionsIds = new ArrayList<>();
            for (String compVersion : compVersions) {
                compVersionsIds.add(compVersion.split("=")[0]);
            }
            for (String compVersion : compVersionsIds) {
              fileName = componentName+ "_Post" + mode + "up." + compVersion.replace(".", "").toLowerCase();
              new File(deliveryPath + File.separator + fileName).delete();
            }
            fileName = componentName+ "_Post" + mode + "up.freshinstall";
            new File(deliveryPath + File.separator + fileName).delete();
                     
            List<String> PostInstallationLines = new ArrayList<>();
            version = compVersions.get(compVersions.size() -1).split("=")[0];
            Boolean versionUpToDate = false;
            if ("VersionUpToDate".equals(componentVersion) || "UpdUpgradeOnly".equals(componentVersion)) {
               componentVersion = version;
               versionUpToDate = true;
            }           
            fileName = componentName+ "_Post" + mode + "up." + componentVersion.replace(".", "").toLowerCase();
            PostInstallationLines.add(String.format(headerPostInstallationDefined, fileName, componentVersion, version));
            PostInstallationLines.add(String.format(header, componentName, "Post" + mode));
            String PostInstallationFile = deliveryPath + File.separator +  componentName + "_Post" + mode + ".upg";
            postInstallationFiles = iniFileEnumSection(PostInstallationFile, "PostInstallation" + mode, false, true, false);
            boolean postInstallationFileFound = false;

            //Files that could be called in upgrade scenario.
            List<String> filesToDeploy = new ArrayList<>();
            for (String postInstallationFile : postInstallationFiles) {
               String [] entries = postInstallationFile.split("=");
               if (entries.length == 2 &&
                       (componentVersion.toLowerCase().equals(entries[0].toLowerCase()) || 
                       "always".equals(entries[0].toLowerCase()) ||
                       ("anyupgrade".equals(entries[0].toLowerCase()) &&
                       !"FreshInstall".equals(componentVersion) &&
                       !versionUpToDate))) {
                  if (writeHeader) {
                     if (!mode.equals("DataSeq")) {
                        lines.add("SPOOL _Post" + mode + ".log");
                        if (installTemAdvance) {
                           lines.add("");
                           lines.add("-- [Thread outlined components]");
                        }
                     }
                     writeHeader = false;
                  }
                  postInstallationFileFound = true;
                  if (!filesToDeploy.contains(entries[1])) {
                     PostInstallationLines.add(strLine);
                     PostInstallationLines.add(String.format(postInstallationPrompt, entries[1]));
                     PostInstallationLines.add(String.format(postInstallationStart, entries[1]));
                     filesToDeploy.add(entries[1]);
                  }
               }
            }
            filesToDeploy.clear();
            
            if (PostInstallationLines.size() > 0 && postInstallationFileFound) {
               try (BufferedWriter output = new BufferedWriter(new FileWriter(deliveryPath + File.separator + fileName))) {
                  for (String line : PostInstallationLines) {
                     output.append(line + lineSeparator);
                  }
                  output.write(String.format(footer, componentName, "Post" + mode));
               } catch (Exception ex) {
                  throw new DbBuildException("ERROR:Error when reading " + PostInstallationFile + lineSeparator + ex.toString());
               }
               if (!postInstallationExist) {
                   lines.add("PROMPT PostInstallation" + mode + " Files start");
                   postInstallationExist = true;
               }
               lines.add("");
               lines.add(String.format(strComponent, componentName));
               //Defines
               if (componentDefines.containsKey(componentName.toLowerCase())) { 
                  for (String define : componentDefines.get(componentName.toLowerCase())) {
                     lines.add("DEFINE " + define);
                  }
               }
               lines.add("SPOOL " + componentName + ".log APPEND");
               lines.add("START " + fileName);
               lines.add(strSpoolOff);
               //Undefines
               if (componentDefines.containsKey(componentName.toLowerCase())) {
                  for (String define : componentDefines.get(componentName.toLowerCase())) {
                     lines.add("UNDEFINE " + define.split("=")[0]);
                  }
               }               
               lines.add(strEndComponent);
            }              
         }
      }
      if (!writeHeader) {
         if (!mode.equals("DataSeq")) {
            if (installTemAdvance) {
               lines.add("");
               lines.add("-- [End thread]");
            }
            lines.add("");
            lines.add(strSpoolOff);
         }
      }
      if (postInstallationExist) {
          lines.add("PROMPT PostInstallation" + mode + " Files stop");
          lines.add("PROMPT");
      }
      return lines;   
   }
   
   /**
   * Method that creates file CompRegAndDep.sql.
   * The file contains registry calls for each component defined dependency.
   * @param deliveryPath
   */
   private void CreateCompReqAndDep(String deliveryPath) throws DbBuildException {
      List<String> connectionRules = new ArrayList<>();
      if (new File(deliveryPath + File.separator + iniFiles.get("install.ini")).exists()) {      
         connectionRules = iniFileEnumSection(deliveryPath + File.separator +  iniFiles.get("install.ini"), "ModuleConnections", false);
      }
      List<String> sqlContents = new ArrayList<>();

      sqlContents.add(setVerifyOff);
      sqlContents.add(setFeedbackOff);
      sqlContents.add(setServerOutOn.toUpperCase());

      String componentName;
      String componentRegister;
      
      List<String> alphaOrder = new ArrayList<>(installationOrder);
      Collections.sort(alphaOrder, sortFiles);
      List<String> includedExtensions = Arrays.asList("cdb", "api", "apv", "apy", "rdf", "ins", "sql");
      List<String> interfaceFiles = Arrays.asList("cdb", "api", "apv");

      for (String component : alphaOrder) {         
         
         if (autoGeneratedComponents.contains(component)) {
            continue;
         }
         componentName = componentNames.get(component.toLowerCase());
         componentRegister = componentName.toUpperCase();
         if (componentShortNames.containsKey(component.toLowerCase())) {
            componentRegister = componentShortNames.get(component.toLowerCase()).toUpperCase();
         }
         String componentDescription = "";
         if (componentDescriptions.containsKey(component.toLowerCase())) {
            componentDescription = componentDescriptions.get(component.toLowerCase()).replace("&", "").replace("  ", " ");
         }
         
         sqlContents.add(strLine);
         sqlContents.add(String.format(strPromptPreReg, componentRegister));

         boolean containIncludedFiles = false;
         boolean containInterfaceFiles = false;
      
         if (new File(deliveryPath + File.separator + subDirectories.get(component.toLowerCase())).exists()) {
            for (File file : new File(deliveryPath + File.separator + subDirectories.get(component.toLowerCase())).listFiles()) {
               String fileName = file.getName();
               if (file.isFile() && fileName.indexOf(".") > 0) {
                  if(includedExtensions.contains(fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase())){
                     containIncludedFiles = true;
                  }
               }
               if (file.isFile() && fileName.indexOf(".") > 0) {
                  if(interfaceFiles.contains(fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase())){
                     containInterfaceFiles = true;
                     break;
                  }
               }
            }
         }

         sqlContents.add(String.format(strExecPreReg, componentRegister, componentDescription, containIncludedFiles ? "TRUE" : "FALSE", containInterfaceFiles ? "TRUE" : "FALSE"));

         for (String connectionRule : connectionRules) {
            if (connectionRule.split("=")[0].equals(componentName)) {
               String[] dependencies = connectionRule.split("=")[1].split(";");               
               if (!(dependencies.length == 1 && "NONE".equals(dependencies[0]))) {
                  Collections.reverse(Arrays.asList(dependencies));
                  //Arrays.sort(dependencies, Collections.reverseOrder());
                  for (String dependency : dependencies) {
                     String[] dependencyDefinition = dependency.split(Pattern.quote("."));
                     sqlContents.add(String.format(strExecReg, componentRegister, dependencyDefinition[0].toUpperCase(), "PRESENT".equals(dependencyDefinition[1]) ? "STATIC" : dependencyDefinition[1]));
                  }
               }
            }
         }
         sqlContents.add(String.format(strEndReg));
      }

      sqlContents.add(strLine);
      sqlContents.add(setServerOutOff.toUpperCase());
  
      try {
         File outputFile = new File(deliveryPath + File.separator + "CompRegAndDep.sql");
         try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
            for (String line : sqlContents) {
               output.write(line + lineSeparator);
            }
         }
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Error(s) occurred during creation of CompRegAndDep.sql" + lineSeparator + ex.toString());
      }      
   }
   private void CreateDeliveryRegDep(String deliveryPath) throws DbBuildException {
      String deliveryId="";
      String productVersion="";
      String baseLinedeliveryId="";
      String deliveryPackageName="";
      List<String> sqlContents = new ArrayList<>();
      sqlContents.add(setVerifyOff);
      sqlContents.add(setFeedbackOff);
      sqlContents.add(setServerOutOn.toUpperCase());    
      sqlContents.add(delivery_reg_empty);
      String deliveryRegFilePath = deliveryPath + File.separator + deliveryRegTxtFile;
      if (!"".equals(deliveryRegFilePath)) {
            String line;
            try {
               try (BufferedReader reader = new BufferedReader(new FileReader(deliveryRegFilePath))) {
                  while ((line = reader.readLine()) != null){
                     int lineLength = line.length();
                     int seperatorIndex = line.indexOf("=");
                        if (line.startsWith("deliveryid=")) {
                           deliveryId = line.substring(seperatorIndex+1, lineLength);
                        }
                        else if (line.startsWith("productversion=")) {
                           productVersion = line.substring(seperatorIndex+1, lineLength);      
                        }
                        else if (line.startsWith("deliverypackagename=")) {
                           deliveryPackageName = line.substring(seperatorIndex+1, lineLength);      
                        }                        
                        else if (line.startsWith("baselinedeliveryid=")) {
                           baseLinedeliveryId = line.substring(seperatorIndex+1, lineLength);
                           if(deliveryId.length() > 0 && productVersion.length() > 0){
                              sqlContents.add(String.format(strPromptDelReg));
                              sqlContents.add(String.format(strExecDelReg, deliveryId, productVersion, baseLinedeliveryId, deliveryPackageName));
                              sqlContents.add(String.format(strEndDelReg)); 
                              //Cleaning the variables, if rows are missing when running merged version (multidelivery)
                              deliveryId="";
                              productVersion="";
                              baseLinedeliveryId="";
                              deliveryPackageName="";
                           }else{
                              sqlContents.add(invalidDelreg);
                           }  
                        }                                 
                  }
               }
            } catch (IOException ex) {
               throw new DbBuildException("ERROR:Error when reading " + deliveryRegTxtFile + lineSeparator + ex.toString());
            }
         } 
      sqlContents.add(setServerOutOff.toUpperCase());
      try {      
         File outputFile = new File(deliveryPath + File.separator + deliveryRegSqlFile);
         try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
            for (String line : sqlContents) {
               output.write(line + lineSeparator);
            }
         }
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Error(s) occurred during creation of "+ deliveryRegSqlFile + lineSeparator + ex.toString());
      }      
   }
   
   private void CreateVersionRegistration(String deliveryPath) throws DbBuildException {
      List<String> sqlContents = new ArrayList<>();
      sqlContents.add(version_reg_header);
      
      Yaml yaml = new Yaml();
      String versionRegFilePath = new File(new File(deliveryPath).getParent() + File.separator + "ifsinstaller" + File.separator + versionFile).toString();
      
      if (new File(versionRegFilePath).exists()) {
         try { 
            InputStream inputStream = new FileInputStream(new File(versionRegFilePath));
            Map<String, Object> values = yaml.load(inputStream);
            if (values.size() > 0 && !"".equals(values.get("release")) && !"".equals(values.get("serviceUpdate"))) {
               sqlContents.add(String.format(strPromptVerReg));
               sqlContents.add(String.format(strExecVerReg, "FEATURE_UPDATE", values.get("release")));
               sqlContents.add(String.format(strExecVerReg, "SERVICE_UPDATE", values.get("serviceUpdate")));
               sqlContents.add(String.format(strEndVerReg)); 
            } else {
               sqlContents.add(invalidVerreg);
            }
         } catch (ScannerException | FileNotFoundException ex ) {   
            throw new DbBuildException("ERROR:Error when reading " + versionFile + lineSeparator + ex.toString());
         }
      }
      try {      
         File outputFile = new File(deliveryPath + File.separator + versionRegSqlFile);
         try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
            for (String line : sqlContents) {
               output.write(line + lineSeparator);
            }
         }
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Error(s) occurred during creation of "+ versionRegSqlFile + lineSeparator + ex.toString());
      } 
      
   }
   
   /**
   * Method that creates sub tem files, for files in components sub folders in database.
   * @param deliveryPath
   * @param templatePath
   */
   private void CreateSubTemplates(String deliveryPath, String templatePath) throws DbBuildException {
      List<String> installSubTemContents = new ArrayList<>();
      HashMap<String, List<String>> installSections = new HashMap<>();
      HashMap<String, List<String>> subTemFiles = new HashMap<>();
      String dirLower;

      for (String component : installationOrder) {
         try {
            if (!subDirectories.containsKey(component.toLowerCase())) {
               continue;
            }

            // Find files that should be ignored,merged as first or last.
            compDeployIni = "";
            for (String deployIni : iniFiles.values()) {
               if (deployIni.substring(0, deployIni.lastIndexOf(".")).toLowerCase().equals(component.toLowerCase())) {                                    
                     compDeployIni = deliveryPath + File.separator + deployIni;
                     String componentName = componentNames.get(component.toLowerCase());
                     ignoreDeployFiles = iniFileEnumSection(compDeployIni, "IgnoreDeployFiles");
                     capMergeFiles = iniFileEnumSection(compDeployIni, "CapMergeFiles");
                     capMergeFilesLast = iniFileEnumSection(compDeployIni, "CapMergeFilesLast");
                     versions = iniFileEnumSection(compDeployIni, componentName + "Versions", false);
                     upgFiles = iniFileEnumSection(compDeployIni, componentName + "Upgrade", false);
                     break;
                  }
            }

            //ignoreFiles, merged List of files to skip in specific step.
            List<String> ignoreFiles = new ArrayList<>();

            //processedFiles, merged List of files to skip when "*" extension is run at last step.
            List<String> processedFiles = new ArrayList<>();

            String componentName = componentNames.get(component.toLowerCase());
            String componentRegister = componentName;
            if (componentShortNames.containsKey(component.toLowerCase())) {
               componentRegister = componentShortNames.get(component.toLowerCase());
            }  

            String componentVersion = componentVersions.get(componentRegister.toLowerCase());
            if (componentVersion == null) {
               componentVersion = "FreshInstall";
            }

            for (File file : new File(deliveryPath + File.separator + subDirectories.get(component.toLowerCase())).listFiles()) {
               if (file.isDirectory() && file.listFiles().length > 0) {
                  dirLower = file.getName().substring(file.getName().lastIndexOf(File.separator) + 1).toLowerCase();
                  if (!installSections.containsKey(dirLower)) {
                     installSections.put(dirLower, new ArrayList<String>());
                     subTemFiles.put(dirLower, new ArrayList<String>());
                  }

                  installSections.get(dirLower).add("");
                  installSections.get(dirLower).add(String.format(strComponent, componentRegister));
                  installSections.get(dirLower).add(String.format(strSpool, componentNames.get(component.toLowerCase()), dirLower));
                  installSections.get(dirLower).add(String.format(header_sub_tem_comp, componentRegister, dirLower));
                  if (componentDefines.containsKey(componentName.toLowerCase())) {
                     for (String define : componentDefines.get(componentName.toLowerCase())) {
                        installSections.get(dirLower).add("DEFINE " + define);
                     }
                  }

                  processedFiles.clear();

                  //merge of db files per extensions.
                  List<String> subFileExt = Arrays.asList("cre", "upg", "cdb", "api", "apn", "apv", "apy", "svc", "cpi", "sch", "obd", "rdf", "ins", "*");
                  HashMap<String, List<String>> filesMap = new HashMap<>();
                  File[] files = file.listFiles();
                  HashMap<String, String> fileNamesLower = new HashMap<>();

                  for (File subFile : files) {
                     String ext;
                     fileNamesLower.put(subFile.getName().toLowerCase(), subFile.getName());
                     if (subFile.getName().indexOf(".") > 0 ) {               
                        ext = subFile.getName().substring(subFile.getName().lastIndexOf(".") + 1).toLowerCase();
                        if (!subFileExt.contains(ext)) {
                           ext = "*";
                        }
                        if (!filesMap.containsKey(ext)) {
                           filesMap.put(ext, new ArrayList<String>());
                        }
                        filesMap.get(ext).add(subFile.getName());
                     }
                  }

                  for ( String extension : subFileExt) {
                     if (!filesMap.containsKey(extension)) {
                        continue;
                     }
                     if ("upg".equals(extension)) {
                        for (String upgFileName : filesMap.get(extension))
                           processedFiles.add(upgFileName.toLowerCase());
                     }
                     //should be skipped if not fresh installation.
                     if (!"FreshInstall".equals(componentVersion) && "cre".equals(extension)) {
                        for (String creFileName : filesMap.get(extension))
                           processedFiles.add(creFileName.toLowerCase());
                        continue;
                     }
                     if (!"upg".equals(extension)) {

                        //Files that should be ignored
                        ignoreFiles.clear();
                        ignoreFiles.addAll(ignoreDeployFiles);

                        if ("*".equals(extension))  {
                           ignoreFiles.addAll(processedFiles);
                        }

                        //Files that should be merged first
                        for (String capMergeFile : capMergeFiles) {
                           if ("*".equals(extension) || (capMergeFile.contains(".") && extension.equals(capMergeFile.split(Pattern.quote("."))[1]))) {
                              if (fileNamesLower.containsKey(capMergeFile) && (ignoreFiles.isEmpty() || !ignoreFiles.contains(capMergeFile))) {
                                 installSections.get(dirLower).add(String.format(strPromptExecuting, fileNamesLower.get(capMergeFile.toLowerCase())));
                                 installSections.get(dirLower).add(String.format(strStart, subDirectories.get(component.toLowerCase()) + "/" + file.getName(), fileNamesLower.get(capMergeFile.toLowerCase())));
                                 processedFiles.add(capMergeFile.toLowerCase());
                                 subTemFiles.get(dirLower).add(fileNamesLower.get(capMergeFile.toLowerCase()));
                              }
                           }
                        }

                        List<String> dbFiles = new ArrayList<>(filesMap.get(extension));
                        ignoreFiles.clear();
                        ignoreFiles.addAll(ignoreDeployFiles);
                        ignoreFiles.addAll(capMergeFiles);
                        ignoreFiles.addAll(capMergeFilesLast);
                        if ("*".equals(extension)) {
                           ignoreFiles.addAll(processedFiles);
                        }

                        //Sort files to match CB version of sorting files.
                        Collections.sort(dbFiles, sortFiles);

                        //Rest of files execept those that should be as last
                        for (String dbFile : dbFiles) {
                           String fileName = dbFile;
                           if (ignoreFiles.isEmpty() || !ignoreFiles.contains(fileName.toLowerCase())) {
                              installSections.get(dirLower).add(String.format(strPromptExecuting, fileName));
                              installSections.get(dirLower).add(String.format(strStart, subDirectories.get(component.toLowerCase()) + "/" + file.getName(), dbFile));
                              processedFiles.add(fileName.toLowerCase());
                              subTemFiles.get(dirLower).add(dbFile);
                           }
                        }

                        //Files that should be ignored
                        ignoreFiles.clear();
                        ignoreFiles.addAll(ignoreDeployFiles);
                        if ("*".equals(extension)) {
                           ignoreFiles.addAll(processedFiles);
                        }

                        //Files that should be merged last
                        for (String capMergeFileLast : capMergeFilesLast) {
                           if ("*".equals(extension) || (capMergeFileLast.contains(".") && extension.equals(capMergeFileLast.split(Pattern.quote("."))[1]))) {
                              if (fileNamesLower.containsKey(capMergeFileLast) && (ignoreFiles.isEmpty() || !ignoreFiles.contains(capMergeFileLast))) {
                                 installSections.get(dirLower).add(String.format(strPromptExecuting, fileNamesLower.get(capMergeFileLast.toLowerCase())));
                                 installSections.get(dirLower).add(String.format(strStart, subDirectories.get(component.toLowerCase()) + "/" + file.getName(), fileNamesLower.get(capMergeFileLast.toLowerCase())));
                                 processedFiles.add(capMergeFileLast.toLowerCase());
                                 subTemFiles.get(dirLower).add(fileNamesLower.get(capMergeFileLast.toLowerCase()));
                              }
                           }
                        }
                     } else {
                        boolean versionFound = false;
                        for (String ver : versions) {
                           String[] version = ver.split("=");
                           if (versionFound || componentVersion.equals(version[0])) {
                              versionFound = true;
                              for (String upgFile : upgFiles) {
                                 String[] entries = upgFile.split("=");
                                 if (entries[0].equals(version[0]) && entries.length == 2 && !"".equals(entries[1])) {
                                    if (fileNamesLower.containsKey(entries[1].toLowerCase())) {
                                       installSections.get(dirLower).add(String.format(strPromptExecuting, fileNamesLower.get(entries[1].toLowerCase())));
                                       installSections.get(dirLower).add(String.format(strStart, subDirectories.get(component.toLowerCase()) + "/" + file.getName(), fileNamesLower.get(entries[1].toLowerCase())));
                                       subTemFiles.get(dirLower).add(fileNamesLower.get(entries[1].toLowerCase()));
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
                  if (componentDefines.containsKey(componentName.toLowerCase())) {
                     for (String define : componentDefines.get(componentName.toLowerCase())) {
                        installSections.get(dirLower).add("UNDEFINE " + define.split("=")[0]);
                     }
                  }
                  installSections.get(dirLower).add(String.format(footer_sub_tem_comp, componentRegister, dirLower));
                  installSections.get(dirLower).add(strSpoolOff);
                  installSections.get(dirLower).add(strEndComponent);
               }
            }
         } 
         catch (DbBuildException ex) {
            throw new DbBuildException("ERROR:Error when creating " + component + lineSeparator + ex.toString());
         }
      }


      boolean readLine = true;
      String currentSection;
      String prevSection;

      for ( String subTem : installSections.keySet() ) {
         installSubTemContents.clear();
         String templateFile = "";
         prevSection = "";
         String templateFilePath = "";

         if (temFiles.containsKey(subTem + ".tem")) {
            templateFilePath = templatePath + File.separator + temFiles.get(subTem + ".tem");
         } else if (temFiles.containsKey("default.tem")) {
            templateFilePath = templatePath + File.separator + temFiles.get("default.tem");
         }
         
         if (!"".equals(templateFilePath)) {
            String line;
            try {
               try (BufferedReader reader = new BufferedReader(new FileReader(templateFilePath))) {
                  while ((line = reader.readLine()) != null){
                     if ("-- noInstallTemAdvance".equals(line)) {
                        installTemAdvance = false;
                     }
                     currentSection = GetSectionStart(line.trim());
                     if ("installtemtype".equals(currentSection.toLowerCase()) && readLine) {
                        readLine = false;
                        prevSection = currentSection;
                        if (!installTemAdvance) {
                         installSubTemContents.add("-- noInstallTemAdvance");
                        } else {
                         installSubTemContents.add("-- installTemAdvance");
                        }                          
                     }

                     if ("componentsection".equals(currentSection.toLowerCase()) && readLine) {
                        installSubTemContents.add(line);
                        readLine = false;
                        prevSection = currentSection;
                        if (installTemAdvance) {
                           installSubTemContents.add("");
                           installSubTemContents.add("-- [Thread outlined components]");
                        }
                        for (String subTemData : installSections.get(subTem)) {
                           installSubTemContents.add(subTemData);
                        }
                        if (installTemAdvance) {
                           installSubTemContents.add("");
                           installSubTemContents.add("-- [End thread]");
                        }
                      }                     

                      if (IsSectionEnd(line.trim(), prevSection) && !readLine) {  
                        if (!"installtemtype".equals(prevSection.toLowerCase())) {
                           installSubTemContents.add(line);
                        } 
                        readLine = true;
                      } else if (readLine) {
                        installSubTemContents.add(line.replace("[default]", subTem));
                      }
                  }
               }
            } catch (IOException ex) {
               throw new DbBuildException("ERROR:Error when creating " + templateFile + lineSeparator + ex.toString());
            }
         } else {
              installSubTemContents.add(String.format(default_sub_tem_header, subTem));
              for (String subTemData : installSections.get(subTem))
              {
                  installSubTemContents.add(subTemData);
              }
         }
         try {
            File outputFile = new File(deliveryPath + File.separator + subTem + ".tem");
            try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
               for (String line : installSubTemContents) {
                  output.write(line + lineSeparator);
               }
            }
            createdTemFiles.add(subTem + ".tem");
         } catch (IOException ex) {
            throw new DbBuildException("ERROR:Error(s) occurred during creation of " + subTem + ".tem" + lineSeparator + ex.toString());
         }
      }

      //biservices.tem should always exist, called from install.tem
      //if no new version created in process, and old merged version exist, overwrite with empty version
      if (!createdTemFiles.contains("biservices.tem"))
      {
         try {
            new File(deliveryPath + File.separator + "biservices.tem").delete();
            File outputFile = new File(deliveryPath + File.separator + "biservices.tem");
            try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
               output.write(biservice_tem_empty + lineSeparator);
            } 
         } catch (IOException ex) {
            throw new DbBuildException("ERROR:Error(s) occurred during creation of biservices.tem" + lineSeparator + ex.toString());
         }
         createdTemFiles.add("biservices.tem");
      }
      //DeliveryRegistration.sql should always exist, called from install.tem 
      //deliveryid.txt should be provided externally to register a delivery. this txt will contain essential
      //attributes to register a delivery. 

      if (!new File(deliveryPath + File.separator + deliveryRegTxtFile).exists()) {       
         try { 

            File outputFile = new File(deliveryPath + File.separator + deliveryRegSqlFile);
            try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
               output.write(delivery_reg_empty + lineSeparator);
            } 
         } catch (IOException ex) {
            throw new DbBuildException("ERROR:Error(s) occurred during creation of "+ deliveryRegSqlFile + lineSeparator + ex.toString());
         } 
      }else{
         CreateDeliveryRegDep(deliveryPath);
      }
      
	 //ActivateComponents.sql should always exist, called from install.tem  
     try {
         File outputFile = new File(deliveryPath + File.separator + "ActivateComponents.sql");
         try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
            String solutionSetYamlFile = new File(deliveryPath).getParent() + File.separator + "solutionset.yaml";
            if (new File(solutionSetYamlFile).exists()) {
               SolutionSet solutionSet;
               try {
               // Deserialize the file configuration into SolutionSetYamlDefinition.
                  InputStream inputStream = new FileInputStream(solutionSetYamlFile);
                  try {
                     SolutionSetYamlDefinition solutionSetGlobal = (SolutionSetYamlDefinition) new Yaml().loadAs(inputStream, SolutionSetYamlDefinition.class);
                     solutionSet = solutionSetGlobal.getGlobal();
                  } catch (Exception ex) {
                     // this is a temporary solution for backward compability, using depricated syntax.
                     // when removed, throw new DbBuildException("ERROR:Error(s) occurred during creation of ActivateComponents.sql" + lineSeparator + ex.getMessage());
                     try {
                        inputStream = new FileInputStream(solutionSetYamlFile);
                        SolutionSetConfig solutionSetConfig = (SolutionSetConfig) new Yaml().loadAs(inputStream, SolutionSetConfig.class);
                        solutionSet = new SolutionSet();
                        solutionSet.setSolutionSetId(solutionSetConfig.getSolutionSetId());
                        solutionSet.setSolutionSetName(solutionSetConfig.getSolutionSetName());
                        solutionSet.setCoreComponents(solutionSetConfig.getCoreComponents());
                        solutionSet.setCustomComponents(solutionSetConfig.getCustomComponents());    
                     }  catch (Exception ex2) {
                         throw new DbBuildException("ERROR:Error(s) occurred during creation of ActivateComponents.sql" + lineSeparator + ex2.getMessage());
                     }
                  }               

                  output.write(solutionset_header + lineSeparator);
                     String solSetId = solutionSet.getSolutionSetId() == null ? "NA" : solutionSet.getSolutionSetId();
                     String solSetName = solutionSet.getSolutionSetName() == null ? "" : solutionSet.getSolutionSetName();

                  output.write(String.format(solutionset_row_solution_set, solSetId, solSetName) + lineSeparator);

                  output.write(solutionset_row_clear_all + lineSeparator);

                  List<String> activeComponents = new ArrayList<>();
                     Map<String, Boolean> coreComponent = solutionSet.getCoreComponents();
                     if (coreComponent != null) {
                        for (Map.Entry<String, Boolean> component : coreComponent.entrySet()) {
                           if (component.getValue())
                              activeComponents.add(component.getKey().toUpperCase());
                        }    
                  }  
                     Map<String, Boolean> custComponent = solutionSet.getCustomComponents();
                     if (custComponent != null) {
                        for (Map.Entry<String, Boolean> component : custComponent.entrySet()) {
                           if (component.getValue() && !activeComponents.contains(component.getKey().toUpperCase()))
                              activeComponents.add(component.getKey().toUpperCase());
                        }       
                     }

                  for (String activeComponent : activeComponents) {
                     output.write(String.format(solutionset_row_activate_component, activeComponent));
                  }
                  output.write(lineSeparator);
                  output.write(solutionset_footer + lineSeparator);                  
               } catch (IOException ex) {
                  throw new DbBuildException("ERROR:Error(s) occurred during creation of ActivateComponents.sql" + lineSeparator + ex.toString());
               }
            } else {          
               output.write(solutionset_empty + lineSeparator);   
            }
         }
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Error(s) occurred during creation of ActivateComponents.sql" + lineSeparator + ex.toString());
      }	  
	  
     //ObsoleteComponents.sql should always exist, called from install.tem 
     try {
         File outputFile = new File(deliveryPath + File.separator + "ObsoleteComponents.sql");
         File directoryPath = new File(new File(deliveryPath).getParent() + File.separator + "database"+File.separator + "prifs");
         FilenameFilter drpFilter = new FilenameFilter() {
            @Override
            public boolean accept(File dir, String name) {
            if (name.toLowerCase().endsWith(".drp")) {
               return true;
            }
               return false;
            }
         };
         File filesList[] = directoryPath.listFiles(drpFilter);
         String componentName ="";
         String fileName ="";
         String scriptTypeExt ="";
         int fileNameLength = 0;
         List<String> obsoleteComponents = new ArrayList<>();

         try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
            if(directoryPath.exists() && filesList.length > 0){
               try {
                  for(File file : filesList) {
                     fileName = file.getName();
                     fileNameLength = fileName.length();
                     if (fileNameLength > 4)
                        scriptTypeExt = fileName.substring(fileNameLength-4,fileNameLength);

                     if(!scriptTypeExt.isEmpty() && scriptTypeExt.equalsIgnoreCase(".drp"))
                        componentName = fileName.substring(0,fileNameLength - 4);

                     if(componentName.length() > 0 && componentName.length() <= 6)
                        obsoleteComponents.add(componentName.toUpperCase());
                  }
                  output.write(obsolete_components_header + lineSeparator);   
                  for (String obsoleteComponent : obsoleteComponents) {
                     output.write(String.format(row_obsolete_component, obsoleteComponent));
                  }

                  output.write(lineSeparator);
                  output.write(obsolete_component_footer + lineSeparator);   

                  } catch (Exception ex) {
                     throw new DbBuildException("Error(s) occurred during creation of ObsoleteComponents.sql" + lineSeparator + ex.toString());
                  }
               } else {
                  output.write(obsolete_components_empty + lineSeparator);
            }
         }
      } catch (IOException ex) {
         throw new DbBuildException("Error(s) occurred during creation of ObsoleteComponents.sql" + lineSeparator + ex.toString());
      }
     
      //List the tem files into manualTemFileName, tem files that should be handled manually
      List<String> manualTemFiles = new ArrayList<>(installSections.keySet());
      if (manualTemFiles.contains("biservices")) {
         manualTemFiles.remove("biservices");
      }
      if (manualTemFiles.contains("ial")) {
         manualTemFiles.remove("ial");
      }
      try {
        File outputFile = new File(deliveryPath + File.separator + manualTemFileName);
        if (outputFile.exists()) {
           outputFile.delete();
        }         
        if (manualTemFiles.size() > 0) {
            try (BufferedWriter output = new BufferedWriter(new FileWriter(outputFile))) {
               for (String line : manualTemFiles) {
                  output.append(line + ".tem" + lineSeparator);
               }
            }
         }             
      } catch (IOException ex) {
         throw new DbBuildException("ERROR:Creation of " + deliveryPath + File.separator + manualTemFileName + " failed" + lineSeparator + ex.toString());
      } 
      
      //VersionRegistration.sql should always exist, called from install.tem 
      CreateVersionRegistration(deliveryPath);     
   }
   
   /**
   * Method that cleanup templates that should not exist anymore.
   * @param deliveryPath
   */
   private void cleanupOldTemFiles(String deliveryPath) {
       for (String temFile : existingTemFiles) {
          if (!createdTemFiles.contains(temFile)) {
             new File(deliveryPath + File.separator + temFile).delete();
          }
       }
      
   }
}
