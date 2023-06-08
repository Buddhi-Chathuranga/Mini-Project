/*=====================================================================================
 * DatabaseInstaller.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild;

import ifs.fnd.dbbuild.databaseinstaller.*;
import java.io.File;
import java.sql.*;
import java.text.Format;
import java.text.SimpleDateFormat;
/**
 * Class for deploying database objects, started from IFS Installer
 * @author mabose
 */
public final class DatabaseInstaller {
   
   /* FileName including path for install file */
   private String fileName = "";
   /* deliveryPath, path to the build_home or delivery */
   private String deliveryPath = "";   
   /* UserName to application owner */
   private String userName = "";
   /* UserName for IAL owner */
   private String ialOwner = "";
   /* Password to application owner */   
   private String password = "";
   /* Password to SYS userr */
   private String syspassword = "";   
   /* ConnectString to access the database */
   private String connectString = "";
   /* Log file path to place log files */
   private String logFilePath = "";
   /* ThreadMethod */
   private String threadMethod = "Y";
   /* WaitingTime if something is locking the process*/
   private String waitingTime = "3600";
   /* ExtLogging */
   private String extLogging = "N";  
   /* Initial passwords used when creating users. */   
   private String initialPasswords = "";   
   
   private final String lineSeparator = System.getProperty("line.separator", "\n");
   
   private boolean error = false;
   
   /**
    * Creates a new instance of DbMergeFilesTask
   * @param args
    */
   public DatabaseInstaller(String[] args) {
      parseArgs(args);
   }
   
    /**
     * Main
    * @param args

    * @param args */
   public static void main(String[] args) {    
      if (args.length == 0) {
         System.out.println("ERROR:No parameters defined");
         System.exit(1);
      } 
      DatabaseInstaller p = new DatabaseInstaller(args);
      p.run();
   }
   
   public void parseArgs(String[] args){
      String key = "";
      String value = "";
      for (String arg : args) {
         if (arg.contains("=")) {
            key = arg.substring(0,arg.indexOf("="));
            value = arg.substring(arg.indexOf("=")+1); 
            switch (key.toLowerCase()) {
               case "filename":
                  fileName = value;
                  break;   
               case "deliverypath":
                  deliveryPath = value;
                  break;      
               case "username":
                  userName = value;
                  break;  
               case "ialowner":
                  ialOwner = value;
                  break;                   
               case "password":
                  password = value;
                  break;   
               case "syspassword":
                  syspassword = value;
                  break;                      
               case "connectstring":
                  connectString = value;
                  break;
               case "logfilepath":
                  logFilePath = value;
                  break; 
               case "waitingtime":
                  waitingTime = value;
                  break;    
               case "extlogging":
                  extLogging = value;
                  break;  
               case "threadmethod":
                  threadMethod = value;
                  break;
               case "initialpasswords":
                  initialPasswords = value;
                  break; 
               default:
                 break; 
            }
         }
      }
   }

   public void run() {
      try {
         if (!"".equals(deliveryPath)) {
            String prepareSql = deliveryPath + "/database/_utils/prepare.sql";
            if (new File(prepareSql).exists()) {
               if (!"".equals(syspassword)) {
                  checkParameterSet("connectString", connectString);
                  checkParameterSet("logFilePath", logFilePath);
                  doRun(prepareSql, "SYS", syspassword, logFilePath + "/prepare_" + getDbTimestamp(), initialPasswords);
               } else {
                  System.out.println("WARNING:Skip execution of file " + prepareSql + ", SYS password missing.");  
               }
            } else {
               System.out.println("FINE:File " + prepareSql + " does not exist."); 
            }
            
            String installTem = deliveryPath + "/database/install.tem";
            if (new File(installTem).exists()) {
               if (!"".equals(userName) && !"".equals(password)) {
                  checkParameterSet("connectString", connectString);
                  checkParameterSet("logFilePath", logFilePath);
                  doRun(installTem, userName, password, logFilePath + "/database_" + getDbTimestamp(), "");
               } else {
                  System.out.println("WARNING:Skip execution of file " + installTem + ", username or password missing.");  
                }
            } else {
                System.out.println("FINE:File " + installTem + " not found."); 
            }
            
            String ialTem = deliveryPath + "/database/ial.tem";
            if (new File(ialTem).exists()) {
               if (!"".equals(userName) && !"".equals(password) && !"".equals(ialOwner)) {
                  checkParameterSet("connectString", connectString);
                  checkParameterSet("logFilePath", logFilePath);
                  doRun(ialTem, userName+"["+ialOwner+"]", password, logFilePath + "/ial_" + getDbTimestamp(), "");
               } else {
                  System.out.println("WARNING:Skip execution of file " + ialTem + ", username, password or IAL Owner missing.");  
                }
            } else {
                System.out.println("FINE:File " + ialTem + " not found."); 
            }            
         }
         
         if (!"".equals(fileName)) {
            if (new File(fileName).exists()) {
               if (!"".equals(userName) && !"".equals(password)) {
                  checkParameterSet("connectString", connectString);
                  checkParameterSet("logFilePath", logFilePath);
                  if ("SYS".equalsIgnoreCase(userName) && new File(fileName).getName().equalsIgnoreCase("prepare.sql")) {
                     doRun(fileName, userName, password, logFilePath + "/fileexecutor_" + getDbTimestamp(), initialPasswords);
                  } else {
                     doRun(fileName, userName, password, logFilePath + "/fileexecutor_" + getDbTimestamp(), "");
                  }
               } else {
                  System.out.println("WARNING:Skip execution of file " + fileName + ", username or password missing.");  
               }
            } else {
              System.out.println("WARNING:" + fileName + " to deploy doesn't exst."); 
            }
         }
         if ("".equals(deliveryPath) && "".equals(fileName))
            System.out.println("INFO:No deliveryPath nor fileName defined, nothing to run. ");
      } catch (DbBuildException ex) {
         System.out.println(ex.getMessage());
         System.exit(1);
      }
      if (error)
         System.exit(1);
   }

   public void doRun(String fileName, String user, String password, String logPath, String initialPasswords) {
      try {
         System.out.println("INFO:Trying to connect to the database to deploy " + fileName + " as user " + user);
         Connection con = null;
         con = DBConnection.openConnection(user, password, connectString);
         try {
             if (con == null || con.isClosed()) {
                 throw new DbBuildException("ERROR:No connection to the database could be established (1)! Connect string " + connectString + " " + DbInstallerUtil.logonError);
             }
         } catch (SQLException e) {
             throw new DbBuildException("ERROR:No connection to the database could be established (2)! Connect string " + connectString + " " + DbInstallerUtil.logonError);
         }
         System.out.println("INFO:Connection successfull");         
         try {
            boolean extendedLogging = ("Y".equalsIgnoreCase(extLogging));
            long waitingTimeInt;
            try {
               waitingTimeInt = Long.parseLong(waitingTime);
            } catch (Exception e) {
               waitingTimeInt = 0;
            }
            PlsqlFileReader p = new PlsqlFileReader(extendedLogging);
            System.out.println("INFO:Start executing " + fileName);
            p.doRun(fileName, logPath, user, password, connectString, logPath, threadMethod, waitingTimeInt, con, initialPasswords);
         } finally {
            try {
               System.out.println("INFO:Finished executing " + fileName);
               System.out.println("INFO:Connection closed"); 
               con.close();
            } catch (SQLException se) {
               throw new DbBuildException("ERROR:Error closing database. " + se.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator));
            }
         }
      } catch (DbBuildException ex) {
         System.out.println(ex.getMessage());
         error = true;
      }
   }
   
   /**
    * Checks that a parameter has a value set.
    * @param   name  the name of the parameter. Used for displaying error message.
    * @param   value the value to check.
    * @throws  DbBuildException if the property has no value.
    */
   private void checkParameterSet(String name, String value) throws DbBuildException {
      if (value == null || value.length() == 0) {
         throw new DbBuildException("ERROR:Parameter " + name + " is not set, deployment of file(s) skipped.");
      }
    } 
   
   private String getDbTimestamp() {
      Format formatter;
      formatter = new SimpleDateFormat("yyyyMMdd_HHmmss");
      java.util.Date date = new java.util.Date();
      return formatter.format(date);
   }
}
