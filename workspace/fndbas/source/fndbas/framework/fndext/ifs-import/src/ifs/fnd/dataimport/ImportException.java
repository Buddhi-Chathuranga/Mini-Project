/*=====================================================================================
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * ToDo xxxxx  2004-0-30   Stdafi     New structure and logic for Montgomery 
 * ====================================================================================
 */

package ifs.fnd.dataimport;

/**
 * An Error class for parameter 
 */
public class ImportException extends Exception {
    public ImportException( Throwable t ) {
        super( t );
    }
    public ImportException( String errMsg ) {
        super( errMsg );
    }

   ImportException(String string, Exception ex) {
      throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
   }

}

