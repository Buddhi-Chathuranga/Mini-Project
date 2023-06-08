/*=====================================================================================
 * DeployLogFilter.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * TEINST-364  2016-02-03  MaBose     Turn of deploy log
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.util.logging.*;

/**
 * Class for filter out handlers that log to a file
 * @author mabose
 */
public class DeployLogFilter implements Filter {
    @Override
    public boolean isLoggable(LogRecord lr) {
        return true;
    }
}

