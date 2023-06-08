/*
 *                 IFS Research & Development
 *
 *  This program is protected by copyright law and by international
 *  conventions. All licensing, renting, lending or copying (including
 *  for private use), and all other use of the program, which is not
 *  expressively permitted by IFS Research & Development (IFS), is a
 *  violation of the rights of IFS. Such violations will be reported to the
 *  appropriate authorities.
 *
 *  VIOLATIONS OF ANY COPYRIGHT IS PUNISHABLE BY LAW AND CAN LEAD
 *  TO UP TO TWO YEARS OF IMPRISONMENT AND LIABILITY TO PAY DAMAGES.
 */
package ifs.cloud.fsmigtool;

import ifs.cloud.fsmigtool.logging.FsMigToolLogger;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * @author IFS RnD
 */
public class SourceDbConnectionManager {

   private final FsMigToolLogger fsLogger;
   private final String dbConnString;
   private final String dbUserName;
   private final String dbUserpassword;

   private Connection conn;

   public SourceDbConnectionManager(CommandLineHandler cmdHandler) throws SQLException, IOException {
      dbConnString = cmdHandler.getDbConnString();
      dbUserName = cmdHandler.getDbUser();
      dbUserpassword = cmdHandler.getDbPass();
      fsLogger = FsMigToolLogger.getInstance();
      establishConnection();
   }

   private void establishConnection() throws SQLException {
      try {
         fsLogger.logCommandLine("Establishing the connection with source database...");
         conn = DriverManager.getConnection(dbConnString, dbUserName, dbUserpassword);
         fsLogger.logCommandLine("Succesfully established the connection with source database.");
      } catch (SQLException ex) {
         throw new SQLException("Error while establishing the connection with source database. " + ex.getMessage(), ex);
      }
   }

   public void closeConnection() throws SQLException, Exception {
      try {
         if (conn != null) {
            conn.close();
         }
      } catch (SQLException ex) {
         fsLogger.logFileError("Error while closing the connection with source database. " + ex.getMessage());
      }
   }

   public Connection getConnection() throws SQLException {
      return conn;
   }
}
