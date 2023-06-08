/*=====================================================================================
 * DBConnection.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.sql.*;
import java.util.Properties;

/**
 * Class for establish a connection to an Oracle database
 * @author mabose
 */
public class DBConnection {

    private static String connectionString = null;
    private static String userName = null;
    private static String passWord = null;
    private static String lineSeparator = System.getProperty("line.separator", "\n");

    /**
     * Creates a new instance of DBConnection
     */
    public DBConnection() {
    }

    /**
     * Get correct connect string depending on the oracle driver
     * @param dbHost String
     * @param dbPort String
     * @param serviceName String
     * @return String
     */
    public static String getConnectString(String dbHost, String dbPort, String serviceName) {
        return "jdbc:ifsworld:oracle://" + dbHost + ":" + dbPort + ";ServiceName=" + serviceName;
    }

    /**
     * Method for establish a connection to an Oracle database
     * @param userName String
     * @param passWord String
     * @param serviceName String
     * @param dbHost String
     * @param dbPort String
     * @return Connection
     */
    public static Connection openConnection(String userName, String passWord, String dbHost, String dbPort, String serviceName) {
        String myConnectionString = getConnectString(dbHost, dbPort, serviceName);
        return openConnection(userName, passWord, myConnectionString);
    }

    /**
     * Method for establish a connection to an Oracle database
     * @param newUserName String
     * @param newPassWord String
     * @param newConnectionString String
     * @return Connection
     */
    public static Connection openConnection(String newUserName, String newPassWord, String newConnectionString) {
        Connection con;
        connectionString = newConnectionString;
        userName = newUserName;
        passWord = newPassWord;
        Properties props = new Properties();

        if ("sys".equalsIgnoreCase(userName)) {
            if (connectionString.toLowerCase().startsWith("jdbc:ifsworld:oracle")) {
//            if ("true".equalsIgnoreCase(System.getenv("USE_DATADIRECT"))) {
                connectionString = connectionString + ";SysLoginRole=sysdba"; 
            } else {
                userName = userName + " as sysdba";
            }
        }
        props.setProperty("user", userName);
        props.setProperty("password", passWord);

        try {

// To be able to run from Netbeans, add this registration but also include ojdbcX.jar in library
//         DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());


	        con = DriverManager.getConnection(connectionString, props);


// Use this syntax for debugging, works only for Data Direct driver
//          con = DriverManager.getConnection(connectionString+";User="+userName+";Password="+passWord+";SpyAttributes=(log=(file)c:/temp/spy.log)");

        } catch (SQLException ex) {
            String excMessage = ex.getMessage().replace(lineSeparator, "\n").replace("\n", lineSeparator);
            // if first connection fails, give it another try unless it is caused by invalid username or password...
            boolean retry = true;
            int retries = 0;
            if (excMessage.contains("ORA-01017")
                    || excMessage.contains("ORA-12154")) {
                DbInstallerUtil.logonError = excMessage;
                retry = false;
                return null;
            } else {
                retries++;
            }
            while (retry) {
                if (retries > 0) {
                   try {
                       System.out.println("FINE: Database not answering, waiting 5 seconds before retrying " + retries+"/5");
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
            DbInstallerUtil.logonError = excMessage;
            return null;
        }
        return con;
    }

    /**
     * Method that return the current connect string
     * @return String
     */
    public static String getConnectionString() {
        return connectionString;
    }
    /**
     * Method that return the current user name
     * @return String
     */
    public static String getUserName() {
        return userName;
    }
    /**
     * Method that return the current Password
     * @return String
     */
    public static String getPassword() {
        return passWord;
    }
}
