/*=====================================================================================
 * PlsqlExecutableObject.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

import java.util.List;

public class PlsqlExecutableObject {

   public PlsqlExecutableObject() {
   }

   public PlsqlExecutableObject(int startLineNo, String plsqlString, String name, 
           PlsqlExecutableObjectType type, int startOffset, int endOffset) {
      this.startLineNo = startLineNo;
      this.plsqlString = plsqlString;
      this.executableObjName = name;
      this.type = type;
      this.startOffset = startOffset;
      this.endoffset = endOffset;
   }

   public String getPlsqlString() {
      return plsqlString;
   }

   public int getStartLineNo() {
      return startLineNo;
   }

   public PlsqlExecutableObjectType getType() {
      return type;
   }

   public String getExecutableObjName() {
      return executableObjName;
   }

   public List getDocLinesArray() {
      return docLinesArray;
   }

   public void setDocLinesArray(List docLinesArray) {
      this.docLinesArray = docLinesArray;
   }

   public void setOriginalFileName(String originalFileName) {
      this.originalFileName = originalFileName;
   }

   public String getOriginalFileName() {
      return originalFileName;
   }
   
   public int getStartOffset() {
      return startOffset;
   }
   
   public int getEndOffset() {
      return endoffset;
   }
   
   private String plsqlString;
   private int startLineNo;
   private int startOffset;
   private int endoffset;
   private PlsqlExecutableObjectType type;
   private String executableObjName;
   private List docLinesArray;
   private String originalFileName;
}
