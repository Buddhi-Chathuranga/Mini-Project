package ifs.installer.component;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.yaml.snakeyaml.Yaml;

import ifs.installer.Installer;
import ifs.installer.component.mtinstaller.util.MtInstallerClientCertificate;
import ifs.installer.component.mtinstaller.util.MtInstallerServerCertificate;
import ifs.installer.component.mtinstaller.util.MtInstallerSymmetricKey;
import ifs.installer.logging.InstallerLogger;
import ifs.installer.util.Helper;
import ifs.installer.util.ProcessResult;
import ifs.installer.util.SemVer;

public class MtInstaller {

   private Map<String, String> envs = new HashMap<>();

   private static final Logger logger = InstallerLogger.getLogger();

   public MtInstaller(String[] userArgs, Map<String, Object> properties, String tmpDir) throws IOException {
      setEnvs(userArgs, properties, tmpDir);
   }

   private String makeHelmArgs(Map<String, Object> arguments) {

      if (arguments.containsKey("kubeconfigFlag")) {
         String kConf = (String)arguments.get("kubeconfigFlag");
         return kConf.replace(" --context ", " --kube-context ");
      }
      return "";
   }
   
   private String userArgsToString(String[] userArgs) {
      
      StringBuilder sb = new StringBuilder();
      for (int i = 0; i < userArgs.length; i++) {
         
         String arg = userArgs[i];
         if ("--kubeconfig".equalsIgnoreCase(arg) || "--context".equalsIgnoreCase(arg)) {
            i++;
         } else {
            sb.append(arg).append(' ');
         }
      }
      return sb.toString();
   }
   
   private void setEnvs(String[] userArgs, Map<String, Object> properties, String tmpDir) throws IOException {
      envs.put("namespace", (String) properties.getOrDefault("global.namespace", ""));

      if (((String) properties.getOrDefault("action", "")).equalsIgnoreCase(Installer.DELETE)) {
         // No need for anything more.
         return;
      }

      envs.put("helmRepo", (String) properties.getOrDefault("helmRepo", ""));
      envs.put("helmUser", (String) properties.getOrDefault("helmUser", ""));
      envs.put("helmPwd", (String) properties.getOrDefault("helmPwd", ""));
      envs.put("helmArgs", userArgsToString(userArgs));
      envs.put("kubeconfigFlag", (String) properties.getOrDefault("kubeconfigFlag", ""));
      envs.put("helmConfigFlag", makeHelmArgs(properties));
      envs.put("tmpDir", tmpDir);
      envs.put("depUpEnabled", String.valueOf(Helper.getOrDefaultBoolean(properties, "depUpEnabled", true)));
      File chart = new File((String) properties.getOrDefault("chart", ""));
      File tmpChart = new File(tmpDir.concat(File.separator).concat("chart"));
      if (chart.isDirectory()) {
         // local chart, copy to temp dir and switch location to that
         envs.put("localChart", "true");
         Helper.deleteDir(tmpChart);
         Helper.copyAllToDir(chart, tmpChart, true);
         envs.put("chart", tmpChart.getCanonicalPath());
      } else {
         envs.put("localChart", "false");
         envs.put("chart", (String) properties.getOrDefault("chart", "ifscloud/ifs-cloud"));
         SemVer helmChartVersion = new SemVer((String) properties.getOrDefault("helmChartVersion", ""));
         if (!properties.containsKey("chartVersion")) {
            logger.info("chartVersion not found in properties, using helmChartVersion: " + helmChartVersion.getVersion());
            properties.put("chartVersion", (String) properties.get("helmChartVersion"));
         } else {
            SemVer hotfixVersion = new SemVer((String) properties.get("chartVersion"));
            if (hotfixVersion.satisifesSp(helmChartVersion)) {
               logger.info("Using chartVersion from user input");
            } else {
               logger.warning(
                     "chartVersion found in values list does not match the current version. Ignoring chartVersion argument..");
               properties.put("chartVersion", helmChartVersion.getVersion());
            }
         }
         envs.put("chartVersion", (String) properties.get("chartVersion"));
      }

      // things need to be set goes here;

      // certificate settings
      new MtInstallerServerCertificate().handleServerCertificate(envs, properties, tmpDir);
      new MtInstallerClientCertificate().checkCertificates(envs, properties);
	  
      // encryption keys
      new MtInstallerSymmetricKey().handleSymmetricKey(envs, properties);
      
      // temporary solution for adding global to solution set, if missing
      // this method should be removed when we have correct solution set file from Thor!!
      addGlobalForSolutionSet(envs, properties, tmpDir);
   }
   
   public void addGlobalForSolutionSet(Map<String, String> envs, Map<String, Object> properties, String tmpDir) throws IOException {
      String solutionSetFile = tmpDir + File.separator + "solutionsetTemp.yaml";
      
      String lineSeparator = System.getProperty("line.separator", "\n");
      
      String globalArgs = "# This file is a temporary workaround created by IfsInstaller, a global tag is added, needed by Helm" + lineSeparator +
                          "global:" + lineSeparator;
      String coreComponentsArgs = "  coreComponents:" + lineSeparator;
      String customComponentsArgs = "  customComponents:" + lineSeparator;
      
      String key = "";
      Boolean writeFile = false;
      
      for (Map.Entry<String,Object> entry : properties.entrySet())  {
         key = entry.getKey();
         if (key.startsWith("solutionSetId") || key.startsWith("solutionSetName") || key.startsWith("coreComponents.") || key.startsWith("customComponents.")) {
            if (!properties.containsKey("global." + key)) {
               if (key.contains(".")) {
                  String[] values = key.split("\\.");
                  if (values.length > 1) {
                     if (values[0].equals("coreComponents"))
                        coreComponentsArgs = coreComponentsArgs + "    " + values[1] + ": " + entry.getValue() + lineSeparator;
                     else if (values[0].equals("customComponents")) {
                        customComponentsArgs = customComponentsArgs + "    " + values[1] + ": " + entry.getValue() + lineSeparator;
                     }
                  }
               } else {
                  globalArgs = globalArgs + "  " + key + ": " + entry.getValue() + lineSeparator;
               }
            writeFile = true;
            }
         }
      }
      
      if (writeFile) {
         logger.fine("Incorrect solutionset file without prefix global: loaded, temporary file created in " + tmpDir);
         globalArgs = globalArgs + coreComponentsArgs + customComponentsArgs;

         Helper.overwriteFile(solutionSetFile, globalArgs);
         
         // add call to created solutionset.yaml file
         String setArgs = (String) envs.getOrDefault("helmArgs", "");
         setArgs = setArgs + " --values " +  solutionSetFile;
         envs.put("helmArgs", setArgs);         
      }
   }   

   public boolean stop() {
      return runMtInstaller("stop");
   }

   public boolean install(boolean networkPolicyEnabled) {
      // create namespace unless it exists..
      createNamespace();

      // get networkpolicy stuff here if needed.
      if (networkPolicyEnabled) {
         String ip = getKubernetesIp(envs.getOrDefault("kubeconfigFlag", ""));
         String helmArgs = envs.get("helmArgs");
         helmArgs = "--set ifscore.networkpolicy.allowKubernetes=".concat(ip).concat("/24 ") + helmArgs;
         envs.put("helmArgs", helmArgs);
      }
      return runMtInstaller("");
   }

   public boolean dryRun() {
      return runMtInstaller("dryrun");
   }

   public boolean delete() {
      return runMtInstaller("delete");
   }

   private boolean runMtInstaller(String action) {
      String directive;
      String extra;
      File script;

      if (Helper.IS_WINDOWS) {
         directive = "cmd.exe";
         extra = "/C";
         envs.put("verbose", logger.getLevel() == Level.FINEST ? "on" : "off");
      } else {
         directive = "bash";
         extra = logger.getLevel() == Level.FINEST ? "-x" : "+x";
      }
      script = new File("installers/mt-installer." + (Helper.IS_WINDOWS ? "cmd" : "sh"));
      logger.fine("calling mt-installer");
      try {
         ProcessResult result = Helper.runProcessWithResult(envs, new File("").getAbsolutePath(), false, directive, extra,
               script.getAbsolutePath(), action);
         if (result.getProcess().exitValue() == 0) {
            logger.fine("successfully exited mt-installer");
            return true;
         } else {
            if (result.getResult().contains("Error: UPGRADE FAILED: post-upgrade hooks failed:") || 
                result.getResult().contains("Error: failed post-install: job failed:")) {
               String ns = envs.getOrDefault("namespace", "");
               String log = "";
               if (!"".equals(ns)) {
                  log = Helper.runProcessWithResult(new File("").getCanonicalPath(), "kubectl", "--namespace", ns, "logs", "jobs/ifs-db-init").getResult();
                  if ("".equals(log))
                     log = "No log from ifs-db-init, never started?";
                  logger.info("ifs-db-init log: \n" + log);                  
               } else {
                  logger.severe("Failed to install ifs-cloud. Collected logs from command: \n" + result.getWashedResult());   
               }
            } else {
              logger.severe("Failed to install ifs-cloud. Collected logs from command: \n" + result.getWashedResult()); 
            }
         }
      } catch (IOException | InterruptedException e) {
         logger.severe("Exception caught when installing ifs-cloud: " + e);
      }
      return false;
   }

   private void createNamespace() {
      runMtInstaller("create-namespace");
   }

   @SuppressWarnings("unchecked")
   private String getKubernetesIp(String kubeconfig) {
      String[] kc = splitKubeconfig(kubeconfig);

      try {
         String result = Helper.runProcessWithResult(new File("").getCanonicalPath(), "kubectl", "get", "endpoints",
               "--namespace", "default", "kubernetes", "-o", "yaml", kc[0], kc[1]).getResult();
         Yaml yaml = new Yaml();
         Map<String, Object> values;
         ArrayList<Map<String, Object>> subsets;
         Map<String, Object> addresses;
         ArrayList<Map<String, Object>> ips;
         Map<String, Object> ip;

         values = yaml.load(result);
         subsets = (ArrayList<Map<String, Object>>) values.get("subsets");
         addresses = subsets.get(0);
         ips = (ArrayList<Map<String, Object>>) addresses.get("addresses");
         ip = ips.get(0);
         return (String) ip.get("ip");
      } catch (IOException | InterruptedException e) {
         logger.warning("Failed to get IPs of kubernetes. " + e);
      }
      return "";
   }

   private String[] splitKubeconfig(String kubeconfig) {
      if ("".equals(kubeconfig)) {
// Workaround for PACAPPF-4148
         return new String[] { "-v=0", "-v=0" };
      } else {
         return kubeconfig.split(" ", 2);
      }
   }
}
