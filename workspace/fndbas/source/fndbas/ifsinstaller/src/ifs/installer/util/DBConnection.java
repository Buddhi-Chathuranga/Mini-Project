package ifs.installer.util;

import java.sql.*;
import java.util.Properties;
import java.util.logging.Logger;
import ifs.installer.logging.InstallerLogger;

/**
 * Class for establish a connection to an Oracle database
 * @author mabose
 */
public class DBConnection {

   private static String lineSeparator = System.getProperty("line.separator", "\n");
   
   private static final Logger logger = InstallerLogger.getLogger();

   /**
    * Creates a new instance of DBConnection
    */
   public DBConnection() {
   }

   /**
    * Method for establish a connection to an Oracle database
    * @param userName String
    * @param passWord String
    * @param connectionString String
    * @return Connection
    */
   public static Connection openConnection(String userName, String passWord, String connectionString) {
       Connection con;
       Properties props = new Properties();
       if ("sys".equalsIgnoreCase(userName)) {
         props.setProperty("user", userName + " as sysdba");
       } else {
         props.setProperty("user", userName);
       }
       props.setProperty("password", passWord);

       try {
         con = DriverManager.getConnection(connectionString, props);
       } catch (SQLException ex) {
           String excMessage = ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
           // if first connection fails, give it another try unless it is caused by invalid username or password...
           boolean retry = true;
           int retries = 0;
           if (excMessage.contains("ORA-01017")
                   || excMessage.contains("ORA-12154")) {
               //DbInstallerUtil.logonError = excMessage;
               retry = false;
               return null;
           } else {
               retries++;
           }
           while (retry) {
               if (retries > 0) {
                  try {
                      logger.fine("Database not answering, waiting 5 seconds before retrying " + retries+"/5");
                      Thread.sleep(5000);
                  } catch (InterruptedException e) {
                  }
               }
               excMessage = "";
               retry = false;
               try {
                   con = DriverManager.getConnection(connectionString, props);
                   return con;
               } catch (SQLRecoverableException sqlRecEx) {
                   excMessage = sqlRecEx.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
                   retries++;
                   if (retries < 5) {
                       retry = true;
                   }
               } catch (SQLException sqlEx2) {
                   excMessage = sqlEx2.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
                   retries++;
                   if (retries < 5) {
                       retry = true;
                   } else {
                       sqlEx2.printStackTrace();
                   }
               }
           }
           return null;
       }
       return con;
   }
}
