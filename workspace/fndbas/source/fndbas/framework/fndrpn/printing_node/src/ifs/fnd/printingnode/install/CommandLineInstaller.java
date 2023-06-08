/*
 * CommandLineInstaller.java
 *
 * Modified:
 *    madrse  2008-Feb-29 - Created
 */

package ifs.fnd.printingnode.install;

import ifs.fnd.log.*;
import ifs.fnd.base.*;
import ifs.fnd.service.*;
import ifs.fnd.util.*;

import java.io.*;
import java.util.*;

/**
 * Command line version of IFS Print Agent Installer.
 */
public class CommandLineInstaller {

   private static final String CANCEL_TIP = "Enter an empty string to cancel this operation.";

   private Logger log = Installation.log;

   private BufferedReader input = new BufferedReader(new InputStreamReader(System.in));

   // List<MenuOption>
   private final ArrayList mainMenu = createMainMenu();

   private Installation inst;

   private void install() throws Exception {

      if(log.info)
         log.info("Starting IFS Print Agent Installer");

      // if the following line fails than the installation process will be aborted
      inst = new Installation();

      try {
         while(true) {
            writeLine();
            writeLine("*** IFS Print Agent Installer Main Menu ***");

            String[] allAgents = inst.allAgens();
            String[] loadedAgents = inst.loadedAgens();

            writeLine("Installed Print Agents: " + Arrays.asList(allAgents));
            //writeLine("Loaded agents:    " + Arrays.asList(loadedAgents));

            showMainMenu();
            MenuOption option = null;
            while(true) {
               String nr = readLine("Enter your choice: ", false);
               option = findMenuOption(nr);
               if(option != null)
                  break;
               if(!Str.isEmpty(nr))
                  writeLine("Invalid choice: '" + nr + "'");
            }

            try {
               if(log.trace)
                  log.trace("Excuting menu option [&1]", option.name);

               if(option.name.equals("exit"))
                  return;
               else if(option.name.equals("create")) {
                  writeLine();
                  writeLine("*** Creating new Print Agent instances ***");
                  writeLine(CANCEL_TIP);
                  writeLine("Enter a list of new agent IDs, using space or comma as a delimiter:");
                  String ids = readLine(" ", false);
                  if(Str.isEmpty(ids))
                  {
                     writeLine("Operation cancelled.");
                  }
                  else
                  {
                     int count = inst.createAgents(ids);
                     writeLine(count + " agent(s) created.");
                  }
               }
               else if(option.name.equals("remove")) {
                  writeLine();
                  writeLine("*** Removing existing Print Agent instances ***");
                  writeLine(CANCEL_TIP);
                  writeLine("Enter a list of existing agent IDs, using space or comma as a delimiter:");
                  String ids = readLine(" ", false);
                  if(Str.isEmpty(ids))
                  {
                     writeLine("Operation cancelled.");
                  }
                  else
                  {
                     int count = inst.removeAgents(ids);
                     writeLine(count + " agent(s) removed.");
                  }
               }

               /*
               else if(option.name.equals("load")) {
                  int count = inst.loadAgents(cmd.param);
                  writeLine(count + " agents loaded.");
               }
               else if(option.name.equals("save"))
                  inst.saveAgents();
               */

               else if(option.name.equals("password")) {
                  ConfigParameter p = new Password();
                  p.begin(option);
                  String pwd1;
                  while(true) {
                     pwd1 = p.readValue(option, "Enter a new password: ");
                     if(Str.isEmpty(pwd1))
                        break;
                     String pwd2 = p.readValue(option, "Verify the new password: ");
                     if(Str.isEmpty(pwd2)) {
                        pwd1 = null;
                        break;
                     }
                     if(pwd1.equals(pwd2))
                        break;
                     else
                        writeLine("Password verification failed.");
                  }
                  p.end(pwd1, "The password has been set.");
               }
               //else if(option.name.equals("user")) {
               //   ConfigParameter p = new User();
               //   p.begin(option);
               //   String user = p.readValue(option, "Enter a new user name: ");
               //   p.end(user, "The user name has been set.");
               //}
               else if(option.name.equals("url")) {
                  ConfigParameter p = new Url();
                  p.begin(option);
                  String url = p.readValue(option, "Enter a new url: ");
                  p.end(url, "The url has been set.");
               }
               else
                  throw new SystemException("Unimplemented option: " + option);
            }
            catch(Exception e) {
               log.error(e, "Failed Command ignored: " + option);
               writeLine("ERROR: " + e.getMessage());
            }
         }
      }
      finally {
         writeLine();
         if(log.info)
            log.info("Exiting IFS Print Agent Installer");
      }
   }

   //========================================================================================
   // XML Config Parameters
   //========================================================================================

   private abstract class ConfigParameter {

      protected abstract String getCurrentValue() throws SystemException;
      protected abstract void setNewValue(String value) throws SystemException;
      protected boolean isHidden() {
         return false;
      }

      void begin(MenuOption option) throws SystemException {
         String operation = "*** " + Str.replace(option.label, "Set ", "Setting ") + " ***";
         String name = option.name;
         int count = inst.loadAgents(null);
         writeLine();
         writeLine(operation);
         writeLine(CANCEL_TIP);
         if(isHidden())
            writeLine("Note! You will not see your input when typing.");
      }

      String readValue(MenuOption option, String prompt) throws SystemException {
         String currentValue = getCurrentValue();
         if(currentValue != null)
            writeLine("The current value is: " + currentValue);
         write(prompt);
         return readLine("", isHidden());
      }

      void end(String newValue, String msg) throws SystemException {
         if(Str.isEmpty(newValue)) {
            inst.unloadAgents();
            writeLine("Operation cancelled.");
         }
         else {
            setNewValue(newValue);
            inst.saveAgents();
            writeLine(msg);
         }
      }
   }

   private class User extends ConfigParameter {
      protected String getCurrentValue() throws SystemException {
         return inst.getUser();
      }
      protected void setNewValue(String value) throws SystemException {
         inst.setUser(value);
      }
   }

   private class Password extends ConfigParameter {
      protected boolean isHidden() {
         return true;
      }
      protected String getCurrentValue() throws SystemException {
         return null; // current value will be not presented to the end user
      }
      protected void setNewValue(String value) throws SystemException {
         inst.setPassword(value);
      }
   }

   private class Url extends ConfigParameter {
      protected String getCurrentValue() throws SystemException {
         return inst.getUrl();
      }
      protected void setNewValue(String value) throws SystemException {
         inst.setUrl(value);
      }
   }

   //========================================================================================
   // Main Menu
   //========================================================================================

   private void showMainMenu() {
      writeLine();
      for(int i = 0; i < mainMenu.size(); i++) {
         MenuOption option = (MenuOption) mainMenu.get(i);
         writeLine(" (" + option.nr + ") " + option.label);
      }
   }

   private ArrayList createMainMenu() {
      ArrayList list = new ArrayList();
      list.add(new MenuOption(1, "create",   "Create new Print Agent instances"));
      list.add(new MenuOption(2, "remove",   "Remove existing Print Agent instances"));
      list.add(new MenuOption(3, "password", "Set Print Server internal user password"));
      list.add(new MenuOption(4, "url",      "Set Application Server url"));
      list.add(new MenuOption(0, "exit",     "Exit the Installer"));
      return list;
   }

   private MenuOption findMenuOption(String nr) {
      for(int i = 0; i < mainMenu.size(); i++) {
         MenuOption option = (MenuOption) mainMenu.get(i);
         if(String.valueOf(option.nr).equals(nr))
            return option;
      }
      return null;
   }

   private static class MenuOption {
      int nr;
      String name, label;
      MenuOption(int nr, String name, String label) {
         this.nr = nr;
         this.name = name;
         this.label = label;
      }

      public String toString() {
         return "[" + nr + "] " + name + "\t" + label;
      }
   }

   //========================================================================================
   // Console input/output
   //========================================================================================

   private String readLine(String prompt, boolean hidden) {
      try {
         write(prompt);
         if(hidden) {
            char[] pwd = PasswordMask.getPassword(System.in, "");
            return pwd == null ? null : new String(pwd).trim();
         }
         else {
            return input.readLine().trim();
         }
      }
      catch(IOException e) {
         log.error(e);
         return "";
      }
   }

   private void writeLine(String line) {
      System.out.println(line);
   }

   private void writeLine() {
      System.out.println("");
   }

   private void write(String text) {
      System.out.print(text);
   }

   //========================================================================================
   // main
   //========================================================================================

   /**
    * @param args command line arguments are ignored
    */
   public static void main(String[] args) throws Exception {
      CommandLineInstaller x = new CommandLineInstaller();
      try {
         x.install();
      }
      catch(Throwable t) {
         if(x.log != null)
            x.log.error(t);
      }
   }
}
