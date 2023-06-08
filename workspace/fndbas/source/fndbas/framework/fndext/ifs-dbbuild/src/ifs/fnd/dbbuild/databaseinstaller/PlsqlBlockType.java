/*=====================================================================================
 * PlsqlBlockType.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

/**
 * Plsql code block types
 */
public enum PlsqlBlockType {

   VIEW,
   TABLE_COMMENT,
   COLUMN_COMMENT,
   PACKAGE,
   PACKAGE_BODY,
   PROCEDURE_DEF,
   FUNCTION_DEF,
   PROCEDURE_IMPL,
   FUNCTION_IMPL,
   CURSOR,
   COMMENT,
   DECLARE_END,
   BEGIN_END,
   TRIGGER,
   IF,
   CASE,
   FOR_LOOP,
   WHILE_LOOP,
   LOOP,
   CUSTOM_FOLD,
   STATEMENT,
   JAVA_SOURCE,
   TYPE,
   TYPE_BODY
}
