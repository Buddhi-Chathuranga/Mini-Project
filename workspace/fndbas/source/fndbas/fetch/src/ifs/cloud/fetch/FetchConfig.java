package ifs.cloud.fetch;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.logging.Level;

import ifs.cloud.fetch.jfrog.JFrogClient;
import ifs.cloud.fetch.local.LocalRepoClient;

class FetchConfig {

   private static char NEW_LINE = '\n';

   private StringConfigItem repoName = new StringConfigItem("repo-name", 'r', "artifactory.repo", true, "Repository name");
   private StringConfigItem hostName = new StringConfigItem("host", 'h', "artifactory.host", true, "Artifactory server host name");
   private StringConfigItem userName = new StringConfigItem("user", 'u', "artifactory.user", true, "Artifactory server user");
   private StringConfigItem password = new StringConfigItem("password", 'p', "artifactory.pass", true, "Artifactory server password");
   private PathConfigItem buildHome = new PathConfigItem("build-home", "build.home", true, "Path for Build home folder");
   private BooleanConfigItem hideProgress = new BooleanConfigItem("hide-progress", false, false, "Hide progress information while downloading files");
   private BooleanConfigItem forceDownload = new BooleanConfigItem("force-download", false, false, "Force downloading archives even if they are not modified");
   private FlagConfigItem help = new FlagConfigItem("help", "Show this help");
   private FlagConfigItem dumpArgs = new FlagConfigItem("show-conf", "Show configuration and current values");
   private LogLevelConfigItem logLevel = new LogLevelConfigItem("log-level", "Console log level");
   private PathConfigItem workspace = new PathConfigItem("workspace", "workspace", false, "Workspace folder");
   private FlagConfigItem ignoreCaching = new FlagConfigItem("ignore-cache", "Ignore cache");
   
   protected static File makeFilePath(String... paths) {
      File file = null;
      String separator = File.separator;
      for (int i = 0; i < paths.length; i++) {

         String temp = paths[i].replace("\\", separator);
         file = new File(file, temp);
      }
      return file;
   }

   FetchConfig(String[] args) throws FetchException {
      ArrayList<ConfigItem> items = getConfigItems();

      for (ConfigItem item : items) {
         item.init(args);
      }

      if (!help.getValue())
         validate(items);
   }

   public IClient createClient() {
      IClient client;
      String host = getHost();
      if (host.startsWith("local:")) {
         client = new LocalRepoClient();
      } else {
         client = new JFrogClient();
      }
      // initialize artifact fetch client
      client.setUserName(getUser());
      client.setPassword(getPassword());
      client.setRepoName(getRepoName());
      client.setHost(getHost());
      if (!ignoreCaching.getValue())
         client.setCachePath(getArtifactManifestPath());

      return client;
   }
   
   private ArrayList<ConfigItem> getConfigItems() {
      ArrayList<ConfigItem> items = new ArrayList<>();
      items.add(hostName);
      items.add(repoName);
      items.add(userName);
      items.add(password);
      items.add(buildHome);
      items.add(hideProgress);
      items.add(forceDownload);
      items.add(help);
      items.add(dumpArgs);
      items.add(logLevel);
      workspace.internal = true;
      items.add(workspace);
      items.add(ignoreCaching);
      return items;
   }

   private String showHelp(ArrayList<ConfigItem> items) {
      StringBuilder sb = new StringBuilder();

      sb.append("Available command line arguments.").append(NEW_LINE);
      sb.append("NOTE: Arguments with (*) are mandatory.").append(NEW_LINE);
      for (ConfigItem item : items) {
         sb.append(item.help());
         sb.append(NEW_LINE);
      }
      sb.append("It is also possible to define some arguments as environment variables.").append(NEW_LINE);
      sb.append("NOTE: Environment variables are overridden when passed as command line arguments");
      for (ConfigItem item : items) {
         String temp = item.helpEnvVar();
         if (temp != null) {
            sb.append(NEW_LINE);
            sb.append(temp);
         }
      }

      return sb.toString();
   }

   private void validate(ArrayList<ConfigItem> items) throws FetchException {

      StringBuilder sb = new StringBuilder();
      boolean invalid = false;
      for (ConfigItem item : items) {

         if (!item.isValid()) {
            invalid = true;
            sb.append(item.showArgError()).append(NEW_LINE);
         }
      }
      if (invalid) {

         sb.insert(0, NEW_LINE);
         sb.insert(0, "Required arguments are missing.").append(NEW_LINE);
         sb.append(showHelp(items));
      }

      if (invalid) {
         sb.append(NEW_LINE);
         sb.append("Validation failed.");
         throw new FetchException(sb.toString());
      }
   }

   protected String getRepoName() {
      return repoName.getValue();
   }

   protected String getHost() {
      return hostName.getValue();
   }

   protected String getUser() {
      return userName.getValue();
   }

   protected String getPassword() {
      return password.getValue();
   }

   protected String getBuildHome() {
      return buildHome.getValue();
   }

   protected boolean getHideProgress() {
      return hideProgress.getValue();
   }

   protected boolean getForceDownload() {
      return forceDownload.getValue();
   }

   protected boolean getShowHelp() {
      return help.getValue();
   }

   protected boolean getDumpArgs() {
      return dumpArgs.getValue();
   }

   protected String getHelpText() {
      return showHelp(getConfigItems());
   }

   protected File getArtifactManifestPath() {
      return FetchConfig.makeFilePath(this.buildHome.getValue(), "build", "artifact");
   }

   protected Level getLogLevel() {
      return logLevel.getLevel();
   }
   
   protected File[] listManifests() {
      File componentsDir = getArtifactManifestPath();
      File[] manifests = componentsDir.listFiles(new FileFilter() {

         @Override
         public boolean accept(File pathname) {

            return pathname.isFile() && pathname.getName().toLowerCase().endsWith(".xml");
         }
      });
      return manifests;
   }

   @Override
   public String toString() {
      ArrayList<ConfigItem> items = getConfigItems();
      StringBuilder sb = new StringBuilder();

      for (ConfigItem item : items) {
         if (!item.isInternal()) {
            sb.append(item);
            sb.append(NEW_LINE);
         }
      }
      sb.append("Manifest Path=").append(getArtifactManifestPath()).append(NEW_LINE);
      return sb.toString();
   }

   File generateTempFile(String prefix, String ext) throws IOException {
      String ws = workspace.getValue();
      if (ws != null) {
         File f = new File(ws);
         f.mkdirs();
         return File.createTempFile(prefix, ext, f);   
      }
      else {
         return Files.createTempFile(prefix, ext).toFile();
      }
   }
   
   private abstract class ConfigItem {
      protected final String key;
      protected char shortKey;
      protected String envKey;
      protected String help;
      protected boolean mandatory;
      protected boolean internal = false;

      ConfigItem(String key, char shortKey, String envKey, boolean mandatory, String help) {
         this.key = key;
         this.envKey = envKey;
         this.shortKey = shortKey;
         this.mandatory = mandatory;
         this.help = help;
      }

      protected boolean isInternal() {
         return this.internal;
      }
      
      abstract void init(String[] args);

      abstract boolean isValid();

      protected String showArgError() {
         StringBuilder sb = new StringBuilder();
         sb.append("Value required for argument '").append(key).append("'.");
         return sb.toString();
      }

      String help() {
         StringBuilder sb = new StringBuilder();
         sb.append(mandatory ? "(*) " : "    ");
         if (shortKey != 0) {
            sb.append("-").append(shortKey).append(", ");
         }
         else {
            sb.append("    ");
         }
         sb.append("--").append(key);
         sb.append(": ");
         sb.append(help);
         if (!mandatory && getDefaultStr() != null) {
            sb.append(", default:").append(getDefaultStr());
         }

         return sb.toString();
      }

      String getDefaultStr() {
         return null;
      }

      String helpEnvVar() {
         if (envKey != null) {
            StringBuilder sb = new StringBuilder();
            sb.append(" ifs.").append(envKey).append(": ");
            sb.append(help);
            return sb.toString();
         }

         return null;
      }

      protected String loadString(String[] args) {
         String value = null;
         if (envKey != null) {

            String temp = "ifs." + envKey;
            value = System.getProperty(temp);
            if (value == null)
               value = System.getenv(temp);
         }

         String temp = "--" + key;
         String altTemp = temp + "=";
         for (int i = 0; i < args.length; i++) {
            if (temp.equals(args[i]) && i < args.length - 1) {
               value = args[++i];
               return value;
            }
            if (args[i].startsWith(altTemp)) {
               value = args[i].substring(altTemp.length());
               return value;
            }
         }
         if (shortKey != 0) {
            temp = "-" + shortKey;
            for (int i = 0; i < args.length; i++) {
               if (temp.equals(args[i]) && i < args.length - 1) {
                  value = args[++i];
                  return value;
               }
            }
         }
         return value;
      }
   }

   private class PathConfigItem extends StringConfigItem {
      private boolean valid;
      private String path;
      
      PathConfigItem(String key, char shortKey, String envKey, boolean mandatory, String help) {
         super(key, shortKey, envKey, mandatory, help);
      }

      PathConfigItem(String key, String envKey, boolean mandatory, String help) {
         super(key, '\0', envKey, mandatory, help);
      }
      
      @Override
      boolean isValid() {
         return !mandatory || valid;
      }
      
      protected String showArgError() {
         if (!valid) {
            StringBuilder sb = new StringBuilder();
            sb.append("Path for '").append(key).append("' does not exist or invalid");
            sb.append(" (").append(path).append(").");
            return sb.toString();
         } else
            return super.showArgError();
      }
      
      @Override
      protected void init(String[] args) {
         super.init(args);
         valid = false;
         try {
            String value = super.getValue();
            if (value != null) {
               File f = new File(value);
               valid = f.exists();
               path = f.getCanonicalPath();
            }
         }
         catch (IOException ex) {
         }
      }
      
      @Override
      String getValue() {
         return valid ? path : super.getValue();
      }
   }
   
   private class StringConfigItem extends ConfigItem {
      private String value;

      StringConfigItem(String key, char shortKey, String envKey, boolean mandatory, String help) {
         super(key, shortKey, envKey, mandatory, help);
      }

      StringConfigItem(String key, String envKey, boolean mandatory, String help) {
         super(key, '\0', envKey, mandatory, help);
      }

      @Override
      protected void init(String[] args) {
         value = loadString(args);
      }

      String getValue() {
         return this.value;
      }

      @Override
      boolean isValid() {
         return mandatory && value != null && value.length() != 0;
      }

      @Override
      public String toString() {
         return new StringBuilder().append(key).append('=').append(getValue()).toString();
      }
   }

   private class BooleanConfigItem extends ConfigItem {
      private boolean value;
      private final boolean defaultValue;

      BooleanConfigItem(String key, char shortKey, String envKey, boolean mandatory, boolean defaultValue, String help) {
         super(key, shortKey, envKey, mandatory, help);
         this.defaultValue = defaultValue;
      }

      BooleanConfigItem(String key, boolean mandatory, boolean defaultValue, String help) {
         this(key, '\0', null, mandatory, defaultValue, help);
      }

      @Override
      protected void init(String[] args) {
         this.value = envKey == null ? Boolean.getBoolean("ifs." + envKey) : this.defaultValue;

         String temp = "--" + key;
         for (int i = 0; i < args.length; i++) {
            if (temp.equals(args[i])) {
               value = true;
               return;
            }
         }
         
         if (shortKey != 0) {
            temp = "-" + shortKey;
            for (int i = 0; i < args.length; i++) {
               if (temp.equals(args[i])) {
                  value = true;
                  return;
               }
            }
         }
      }

      boolean getValue() {
         return this.value;
      }

      @Override
      boolean isValid() {
         return true;
      }

      @Override
      String getDefaultStr() {
         return Boolean.toString(defaultValue);
      }

      @Override
      public String toString() {
         return new StringBuilder().append(key).append('=').append(value).toString();
      }
   }

   private class FlagConfigItem extends BooleanConfigItem {
      FlagConfigItem(String key, String help) {
         super(key, false, false, help);
      }

      @Override
      String getDefaultStr() {
         return null;
      }

      @Override
      public String toString() {
         return key;
      }
      
      @Override
      protected boolean isInternal() {
         return true;
      }
   }
   
   private class LogLevelConfigItem extends StringConfigItem {
      private Level level = Level.WARNING;
      
      LogLevelConfigItem(String key, String help) {
         super(key, '\0', null, false, help);
      }
      
      @Override
      boolean isValid() {
         return true; /* not mandatory */
      }
      
      @Override
      protected void init(String[] args) {
         super.init(args);
         try {
            String value = super.getValue();
            level = Level.parse(value);
         }
         catch (Exception ex) {
         }
      }

      Level getLevel() {
         return level;
      }
   }
}
