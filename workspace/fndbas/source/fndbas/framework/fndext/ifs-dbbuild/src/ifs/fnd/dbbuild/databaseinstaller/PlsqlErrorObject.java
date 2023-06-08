/*=====================================================================================
 * PlsqlErrorObject.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

public class PlsqlErrorObject {

   public PlsqlErrorObject() {
   }

   public String getErrorMsg() {
      return errorMsg;
   }

   public void setErrorMsg(String errorMsg) {
      this.errorMsg = errorMsg;
   }

   public int getLineNumber() {
      return lineNumber;
   }

   public void setLineNumber(int lineNumber) {
      this.lineNumber = lineNumber;
   }

   public int getPosition() {
      return position;
   }

   public void setPosition(int position) {
      this.position = position;
   }

   public String toString() {
      return errorMsg;
   }

   private String errorMsg;
   private int lineNumber;
   private int position;
}
