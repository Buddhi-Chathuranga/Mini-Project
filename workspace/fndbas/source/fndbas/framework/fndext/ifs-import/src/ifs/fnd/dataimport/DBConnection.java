/*=====================================================================================
 * DBConnection.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * xxxxxx      2010-10-18  Stdafi     Data Import
 * ====================================================================================
 */
package ifs.fnd.dataimport;

import java.sql.*;
import java.util.Properties;

/**
 * Class for establish a connection to an Oracle database
 * @author mabose
 */
public class DBConnection {

    private static String lineSeparator = System.getProperty("line.separator", "\n");

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
    * @throws ifs.fnd.dataimport.ImportException
     */
    public static Connection openConnection(String userName, String passWord, String connectionString) throws ImportException {
        Connection con;
        Properties props = new Properties();

        props.setProperty("user", userName);
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
            throw new ImportException("ERROR:" + excMessage);
        }
        return con;
    }
}
