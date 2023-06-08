/*=====================================================================================
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * ToDo xxxxx  2004-0-30   Stdafi     New structure and logic for Montgomery 
 * ====================================================================================
 */

package ifs.fnd.dbbuild.databaseinstaller;

/**
 * An Error class for parameter 
 */
public class DbBuildException extends Exception {
    public DbBuildException( Throwable t ) {
        super( t );
    }
    public DbBuildException( String errMsg ) {
        super( errMsg );
    }

   DbBuildException(String string, Exception ex) {
        super (string, ex);
   }

}

