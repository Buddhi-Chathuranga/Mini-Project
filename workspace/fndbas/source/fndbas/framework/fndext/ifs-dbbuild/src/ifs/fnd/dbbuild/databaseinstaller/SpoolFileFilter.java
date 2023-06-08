/*=====================================================================================
 * SpoolFileFilter.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2011-09-14  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.util.logging.*;

/**
 * Class for filter out handlers that log to a file
 * @author mabose
 */
public class SpoolFileFilter implements Filter {
    @Override
    public boolean isLoggable(LogRecord lr) {
        return true;
    }
}

