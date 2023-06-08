/*=====================================================================================
 * ThreadFormatter.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.util.logging.*;

/**
 * Class for formatting log texts
 * @author mabose
 */
public class ThreadFormatter extends Formatter {

/**
 * Method for formatting log texts
 * @param record LogRecord
 * @return String
 */
    @Override
   public String format(LogRecord record) {
      return record.getMessage() + System.getProperty("line.separator", "\n");
   }
}

