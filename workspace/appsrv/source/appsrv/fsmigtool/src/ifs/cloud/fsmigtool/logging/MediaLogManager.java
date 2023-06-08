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
package ifs.cloud.fsmigtool.logging;

import ifs.cloud.fsmigtool.CommandLineHandler;
import ifs.cloud.fsmigtool.SourceDbConnectionManager;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.util.Map;

/**
 * @author IFS RnD
 */
public class MediaLogManager {

   private final SourceDbConnectionManager dbConnection;
   private final FsMigToolLogger fsLogger;
   private final CommandLineHandler cmdHandler;

   public MediaLogManager(SourceDbConnectionManager connection, CommandLineHandler cmdHandler) throws SQLException, IOException {
      this.cmdHandler = cmdHandler;
      fsLogger = FsMigToolLogger.getInstance();
      dbConnection = connection;
   }

   public void setMediaTransferStatus(Map<String, Object> mediaItemParam, String status, String info) throws SQLException {
      logMediaInfo(mediaItemParam, info);
      setMediaTransferStatus(mediaItemParam, status);
   }

   public void logMediaInfo(Map<String, Object> mediaItemParam, String info) throws SQLException {
      if (cmdHandler.isLogMigTable()) {
         String query = "{call Fs_Mig_Tool_API.Log_Media_Info__(?, ?)}";
         CallableStatement stmt = dbConnection.getConnection().prepareCall(query);

         try {
            stmt.setLong(1, (long) mediaItemParam.get("ITEM_ID"));
            stmt.setString(2, info);
            stmt.execute();
         } catch (SQLException e) {
            throw new SQLException("Failed to log media info. " + e.getMessage(), e);
         } finally {
            if (stmt != null) {
               stmt.close();
            }
         }
      }
      logFile("File " + mediaItemParam.get("ITEM_ID") + " " + info);
   }

   private void setMediaTransferStatus(Map<String, Object> mediaItemParam, String status) throws SQLException {
      String query = "{call Fs_Mig_Tool_API.Set_Media_Transfer_Status__(?, ?)}";
      CallableStatement stmt = dbConnection.getConnection().prepareCall(query);

      try {
         stmt.setLong(1, (long) mediaItemParam.get("ITEM_ID"));
         stmt.setString(2, status);
         stmt.execute();
      } catch (SQLException e) {
         throw new SQLException("Failed to log media status info. " + e.getMessage(), e);
      } finally {
         if (stmt != null) {
            stmt.close();
         }
      }
   }

   public void logCommandLineError(String message) {
      fsLogger.logCommandLineError(message);
   }
   public void logCommandLineErrorNoLine(String message) {
      fsLogger.logCommandLineErrorNoLine(message);
   }

   public void logCommandLine(String message) {
      fsLogger.logCommandLine(message);
   }
   public void logCommandLineNoLine(String message) {
      fsLogger.logCommandLineNoLine(message);
   }

   public void logFileError(String message) {
      fsLogger.logFileError(message);
   }

   public void logFile(String message) {
      fsLogger.logFile(message);
   }
}
