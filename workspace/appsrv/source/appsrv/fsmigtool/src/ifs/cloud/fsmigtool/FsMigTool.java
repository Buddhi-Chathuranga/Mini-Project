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

import ifs.cloud.fsmigtool.exception.UserException;
import ifs.cloud.fsmigtool.logging.FsMigToolLogger;

/**
 * @author IFS RnD
 */
public class FsMigTool {

   public static void main(String[] args) throws Exception {
      
      try {
         CommandLineHandler cmdHandler = new CommandLineHandler(args);
         cmdHandler.parseCommandLine();

         SourceDbConnectionManager connection = new SourceDbConnectionManager(cmdHandler);

         if (cmdHandler.shouldHandleDocuments()) {
            new DocmanMigrationHandler(cmdHandler, connection).migrateToFs();
         }

         if (cmdHandler.shouldHandleMedia()) {
            new MediaMigrationHandler(cmdHandler, connection).migrateToFs();
         }

         connection.closeConnection();
      } catch (UserException ex) {
         FsMigToolLogger.getInstance().logCommandLineError(ex.getMessage());
      } catch (Exception ex) {
         FsMigToolLogger.getInstance().logCommandLineError("Unexpected Exception. Check the log for more information.");
         FsMigToolLogger.getInstance().logFileError(ex.getMessage());
      }

   }
}
