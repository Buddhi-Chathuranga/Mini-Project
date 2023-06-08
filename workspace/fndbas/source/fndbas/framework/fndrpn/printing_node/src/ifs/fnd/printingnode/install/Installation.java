/*
 * Installation.java
 *
 * Modified:
 *    madrse  2008-Mar-03 - Created
 *    madrse  2008-Apr-28 - Replece &JAVA_HOME in ifs-printagent-service.ifm with current value of JAVA_HOME environment variable
 *    chaalk  2009-May-26 - Fix for bug 82571
 *    chaalk  2017-Dec-11 - Patch merge 138885
 */

package ifs.fnd.printingnode.install;

import ifs.fnd.log.*;
import ifs.fnd.base.*;
import ifs.fnd.service.*;
import ifs.fnd.util.*;

import java.io.*;
import java.util.*;

import ifs.fnd.ap.Server;
import ifs.fnd.record.*;
import ifs.fnd.sf.sta.*;
import ifs.fnd.ap.APException;
import ifs.fnd.service.IfsShutdownHook;
import ifs.fnd.service.ShutdownListener;
import ifs.client.application.remoteprintingnode.*;


/**
 * Class that represents IFS Print Agent installation files.
 * An installation may contain many IFS Print Agent instances.
 */
public class Installation {

   // Characters that cannot be used in a Print Agent ID.
   private static final String INVALID_ID_CHARACTERS = " \\/:*?\"<>,;\t";

   // The platform's line separator sequence.
   private static final String NL = System.getProperty("line.separator");
   
   private PrintJobHandler pjHandler;

   /**
    * The main logger used by the installation proccess.
    */
   public static final Logger log = LogMgr.getFrameworkLogger();

   private File rootDir;
   private File binDir;
   private File templateDir;
   private File agentsDir;

   // temporary directory that is guaranteed to be on the same drive as agentsDir (used when removing agents)
   private File tmpDir;

   private TextFileList templateFiles;

   private ArrayList loadedXmlConfigs; // ArrayList<XmlConfigFile>

   /**
    * Prepares an Installation process.
    * The method assumes that the current working directory is the root directory of the IFS Print Agent installation.
    * If this constructor fails than the installation process should be aborted.
    */
   public Installation() throws Exception {
      rootDir = new File(".").getCanonicalFile();
      if(log.trace)
         log.trace("Setting root directory: &1", rootDir.getAbsolutePath());

      binDir = new File("bin").getCanonicalFile();
      binDir.mkdirs();
      if(log.trace)
         log.trace("Setting bin directory: &1", binDir.getAbsolutePath());

      agentsDir = new File("agents").getCanonicalFile();
      agentsDir.mkdirs();
      if(log.trace)
         log.trace("Setting agents directory: &1", agentsDir.getAbsolutePath());

      templateDir = new File("template").getCanonicalFile();
      if(log.trace)
         log.trace("Reading template files from directory &1", templateDir.getAbsolutePath());
      templateFiles = new TextFileList(templateDir);

      tmpDir = new File("tmp").getCanonicalFile();
      tmpDir.mkdirs();
      if(log.trace)
         log.trace("Setting temporary directory: &1", tmpDir.getAbsolutePath());

      recreateServiceScripts();
   }

   /**
    * Lists all existing Print Agents in the current installation.
    * @return the list of Print Agent ID
    */
   public String[] allAgens() throws IOException {
      String[] dirs = agentsDir.list();
      return dirs;
   }

   /**
    * Lists Print Agents currently loaded into memory for editing.
    * @return the list of Print Agent ID
    */
   public String[] loadedAgens() throws IOException {
      int size = loadedXmlConfigs == null ? 0 : loadedXmlConfigs.size();
      String[] ids = new String[size];
      for(int i = 0; i < size; i++) {
         XmlConfigFile config = (XmlConfigFile) loadedXmlConfigs.get(i);
         ids[i] = config.getId();
      }
      return ids;
   }

   /**
    * Checks existence of a Print Agent instance.
    * @param id a Print Agent ID
    */
   public boolean existAgent(String id) throws IOException, FndException, CommandException {
      File newDir = new File(agentsDir, id);
      return newDir.exists();
   }

   /**
    * Creates new Print Agent instances.
    * @param ids a space-separated list of new Print Agent IDs
    * @return the number of created agents
    */
   public int createAgents(String ids) throws IOException, FndException, CommandException {
      StringTokenizer st = new StringTokenizer(ids, INVALID_ID_CHARACTERS);
      int count = 0;
      while(st.hasMoreTokens()) {
         String id = st.nextToken();
         if(!existAgent(id)) {
            createAgent(id);
            count++;
         }
      }
      recreateServiceScripts();
      return count;
   }

   /**
    * Creates a new Print Agent instance.
    * @param id a new Print Agent IDs
    */
   public void createAgent(String id) throws IOException, FndException, CommandException {
      if(log.trace)
         log.trace("Creating new Print Agent instance [&1]", id);

      File newDir = new File(agentsDir, id);
      if(newDir.exists())
         throw new CommandException("Directory "+newDir.getAbsolutePath()+ " already exists.");
      newDir.mkdir();

      if(log.trace)
         log.trace("Creating instance files for agent [&1]", id);

      String javaHome = System.getenv("JAVA_HOME");
      if(javaHome == null)
         throw new CommandException("JAVA_HOME environment variable is not defined.");

      TextFileList files = (TextFileList) templateFiles.clone();
      files.replace("@ID@", id);
      files.replace("@ROOT@", rootDir.getAbsolutePath());
      files.replace("$SERVICE.CMD_LINE=&JAVA_HOME\\bin\\java.exe", "$SERVICE.CMD_LINE=" + javaHome + "\\bin\\java.exe" + getKeyStore());
      files.replace("\r", "");
      files.replace("\n", "\r\n");

      files.save(newDir);

      if(log.trace)
         log.trace("Installing Windows service for agent [&1]", id);

      execCmd(newDir.getAbsolutePath() + File.separator + "install_printagent_service.cmd");
   }
   
   private String getKeyStore()
   {
      File ksRootDir = new File(rootDir.getAbsolutePath()) ;
      FilenameFilter jksFilter  = new FilenameFilter() {
         @Override
         public boolean accept(File dir, String name) {
            return name.toUpperCase().endsWith(".JKS");
         }
      };
      File[] jksFiles = ksRootDir.listFiles(jksFilter);
      
      return jksFiles.length > 0 ? " -Djavax.net.ssl.trustStore=" + jksFiles[0].getAbsoluteFile() + " -Djavax.net.ssl.trustStorePassword=changeit" : "";
   }

   /**
    * Removes existing Print Agent instances.
    * @param ids a space-separated list of existing Print Agent IDs
    * @return the number of removed agents
    */
   public int removeAgents(String ids) throws IOException, FndException, CommandException {
      StringTokenizer st = new StringTokenizer(ids, INVALID_ID_CHARACTERS);
      int count = 0;
      while(st.hasMoreTokens()) {
         String id = st.nextToken();
         if(removeAgent(id))
            count++;
      }
      recreateServiceScripts();
      return count;
   }

   /**
    * Removes an existing Print Agent instance.
    * @param id of an existing instance
    * @return true if the agent has been removed, false if there was no agent with the specified ID
    */
   public boolean removeAgent(String id) throws IOException, FndException, CommandException {
      if(log.trace)
         log.trace("Removing Print Agent instance [&1]", id);

      File dir = new File(agentsDir, id);
      if(!dir.exists()) {
         if(log.trace)
            log.trace("Cannot remove agent [&1]. Directory [&2] does not exists.", id, dir.getAbsolutePath());
         return false;
      }

      if(log.trace)
         log.trace("Uninstalling Windows service for agent [&1]", id);

      execCmd(dir.getAbsolutePath() + File.separator + "uninstall_printagent_service.cmd");
		  try{
			  int agentCount = loadAgents(id);
		  }  
		  catch (Exception e){
			 if(log.trace)
				log.trace("Error in reading the configuration file for agent [&1]", id);  
		  }

      // try to rename the agent directory to verify that it is not locked, than delete all files in the directory
      File dir2 = new File(tmpDir, id);
      if(dir.renameTo(dir2)){
          boolean isPaNodeDeleted = false;
         String url = null;
         String user = null;
         String password = null;
         
         try{
          url = getUrl();
          user = getUser();
          password = FndEncryption.decrypt(getParameter("PASSWORD"));
         }
         catch (Exception e){
            if(log.trace)
                  log.trace("Error in retrieving the login details for agent [&1]", id);  
         }
         
         isPaNodeDeleted = deleteAll(dir2);
         if ((isPaNodeDeleted) && (url != null) && (user != null) && (password != null)) {
            try{
               if(log.trace)
                  log.trace("Removing the logical printers for agent [&1]", id);
				  
               Server srv;
               srv = new Server();
               srv.setConnectionString(url);
               srv.setCredentials(user, password);
               srv.saveToThread();

               pjHandler = PrintJobHandlerFactory.getHandler();
               pjHandler.removePrintingNode(id);
               
               if(log.trace)
                  log.trace("Logical printers successfully removed for agent [&1]", id);               
            }
            catch (Exception e){
               if(log.trace)
                  log.trace("Could not remove logical printers for agent [&1]", id);               
            }
            finally {
               url = null;
            }
         }
         return isPaNodeDeleted;
      }

      throw new CommandException("Could not delete directory: " + dir.getAbsolutePath());
   }


   /**
    * Deletes a directory and recursively all its files.
    * @param dir a directory to delete
    * @return true if the directory has been deleted, false otherwise
    */
   private boolean deleteAll(File dir) throws IOException, CommandException {
      File[] files = dir.listFiles();
      for(int i = 0; i < files.length; i++) {
         File file = files[i];
         if(file.isDirectory())
            deleteAll(file);
         else
            file.delete();
      }

      if(dir.delete())
         return true;
      else
         throw new CommandException("Could not delete directory: " + dir.getAbsolutePath());
   }

   /**
    * Loads into memory XML configuration files for the specified agent(s).
    * If the specified ID is null (meaning all agents) then the template
    * XML configuration file is also loaded.
    * The loaded files may be modified by calling set-methods.
    * @param id the ID of an existing instance, null menas all existing instances
    * @return the number of agents loaded into memory
    * @see #setUser
    * @see #setPassword
    * @see #setUrl
    * @see #saveAgents
    */
   public int loadAgents(String id) throws SystemException {
      loadedXmlConfigs = new ArrayList();

      // load template XML config file
      if(id == null)
         loadedXmlConfigs.add(new XmlConfigFile(templateDir));

      File[] agentDirs = agentsDir.listFiles();
      for(int i = 0; i < agentDirs.length; i++) {
         File dir = agentDirs[i];
         if(id == null || id.equalsIgnoreCase(dir.getName()))
            loadedXmlConfigs.add(new XmlConfigFile(dir));
      }

      int count = loadedXmlConfigs.size();
      if(log.trace)
         log.trace("&1 Print Agent instances loaded into memory", String.valueOf(count));
      return count;
   }

   /**
    * Unloads previously loaded XML configuration files.
    * @see #loadAgents
    */
   public void unloadAgents() throws SystemException {
      if(log.trace)
         log.trace("Unloading configuration files for &1 Print Agent instances",
                    loadedXmlConfigs == null ? "0" : String.valueOf(loadedXmlConfigs.size()));
      loadedXmlConfigs = null;
   }


   /**
    * Saves previously loaded XML configuration files.
    * @see #loadAgents
    */
   public void saveAgents() throws SystemException {
      if(loadedXmlConfigs == null)
         throw new SystemException("NOAGENTS: No agents are currently loadad into memory");

      for(int i = 0; i < loadedXmlConfigs.size(); i++) {
         XmlConfigFile config = (XmlConfigFile) loadedXmlConfigs.get(i);
         config.save();
      }

      if(log.trace)
         log.trace("Saved configuration for &1 Print Agent instances", String.valueOf(loadedXmlConfigs.size()));

      loadedXmlConfigs = null;
   }

   /**
    * Gets <b>USER</b> configuration parameter.
    * @return the user name common for all loaded configuration files, or null if there is no common value
    * @see #setUser
    */
   public String getUser() throws SystemException {
      return getParameter("USER");
   }

   /**
    * Sets <b>USER</b> parameter in all loaded configuration files.
    * @param user the user name to set
    * @see #loadAgents
    * @see #saveAgents
    * @see #getUser
    */
   public void setUser(String user) throws SystemException {
      setParameter("USER", user);
   }

   /**
    * Encrypts and sets <b>PASSWORD</b> parameter in all loaded configuration files.
    * @param password the password to set
    * @see #loadAgents
    * @see #saveAgents
    */
   public void setPassword(String password) throws SystemException {
      try {
        setParameter("PASSWORD", FndEncryption.encrypt(password));
      }
      catch(Exception e) {
         log.error(e);
         throw new SystemException("PWDENCRYPT: Could not encypt password: &1", e.getMessage());
      }
   }

   /**
    * Gets <b>URL</b> configuration parameter.
    * @return the url value common for all loaded configuration files, or null if there is no common value
    * @see #setUser
    */
   public String getUrl() throws SystemException {
      return getParameter("URL");
   }

   /**
    * Sets <b>URL</b> parameter in all loaded configuration files.
    * @param url the url to set
    * @see #loadAgents
    * @see #saveAgents
    */
   public void setUrl(String url) throws SystemException {
      setParameter("URL", url);
   }

   /**
    * Sets the specified parameter in all loaded configuration files.
    */
   private void setParameter(String name, String value) throws SystemException {
      if(loadedXmlConfigs == null)
         throw new SystemException("NOAGENTS: No agents are currently loadad into memory");

      for(int i = 0; i < loadedXmlConfigs.size(); i++) {
         XmlConfigFile config = (XmlConfigFile) loadedXmlConfigs.get(i);

         if(log.debug)
            log.debug("Setting parameter [&1] to [&2] for Print Agent [&3]", name, value, config.getId());

         config.setParameter(name, value);
      }
   }

   /**
    * Gets the common parameter value from all loaded configuration files.
    * @return not-null value common to all loaded  configuration files, or null if there is no common value
    */
   private String getParameter(String name) throws SystemException {
      if(loadedXmlConfigs == null)
         return null;

      String commonValue = null;

      for(int i = 0; i < loadedXmlConfigs.size(); i++) {
         XmlConfigFile config = (XmlConfigFile) loadedXmlConfigs.get(i);
         String value = config.getParameter(name);

         if(log.debug)
            log.debug("Fetched value [&1] for parameter [&2] for Print Agent [&3]", value, name, config.getId());

         if(commonValue == null)
            commonValue = value;
         else if(!commonValue.equals(value))
            return null;

      }
      if(log.debug)
         log.debug("Found common value [&1] for parameter [&2] in &3 loaded configuration files",
                   commonValue, name, String.valueOf(loadedXmlConfigs.size()));
      return commonValue;
   }

   private static class CommandException extends Exception {
      public CommandException(String msg) {
         super(msg);
      }
   }


   /**
    * Recreate start and stop script for all Print Agent services.
    */
   private void recreateServiceScripts() throws IOException {
      createServiceScript("start_printagent_services.cmd", "start");
      createServiceScript("stop_printagent_services.cmd", "stop");
      //createServiceScript("install_printagent_services.cmd", "install");
      //createServiceScript("uninstall_printagent_services.cmd", "uninstall");
   }

   /**
    * @param action "start", "stop", "install", "uninstall"
    */
   private void createServiceScript(String filename, String action) throws IOException {
      String[] ids = allAgens();
      BufferedWriter writer = new BufferedWriter(new FileWriter(new File(binDir, filename)));
      writer.write("@echo off");
      writer.newLine();
      writer.write("setlocal");
      writer.newLine();
      writer.newLine();
      writer.write("set ROOT=" + rootDir.getAbsolutePath());
      writer.newLine();
      writer.write("set NOPAUSE=Y");
      writer.newLine();
      writer.newLine();
      if(ids.length == 0) {
         writer.write("echo There is no agent to " + action);
         writer.newLine();
      }
      else {
         for(int i = 0; i < ids.length; i++) {
            writer.write("call \"%ROOT%\\agents\\" + ids[i] + "\\" + action + "_printagent_service.cmd\"");
            writer.newLine();
         }
      }
      writer.newLine();
      writer.write("pause");
      writer.newLine();
      writer.write("endlocal");
      writer.newLine();
      writer.close();
   }

   private void execCmd(String cmd) throws IOException {
      if(log.trace)
         log.trace("Executing command &1", cmd);

      Process batch = Runtime.getRuntime().exec(cmd, new String[]{"NOPAUSE=Y"});

      StringBuffer stderr = new StringBuffer();
      String line;
      BufferedReader errout = new BufferedReader(new InputStreamReader(batch.getErrorStream()));
      while((line = errout.readLine()) != null) {
         stderr.append(line);
         stderr.append(NL);
      }

      if(stderr.length() > 0)
         log.error("Command '&1' failed: &2", cmd, stderr.toString());

      /*
      try {
         batch.waitFor();
      }
      catch(InterruptedException e) {
         log.error(e);
         IOException io = new IOException("Command interrupted");
         io.initCause(e);
         throw io;
      }
      */

      int exitCode = batch.exitValue();
      if(exitCode != 0)
         log.warning("Exit code: &1", String.valueOf(exitCode));
      else if(log.trace)
         log.trace("Exit code: &1", String.valueOf(exitCode));
   }

}
