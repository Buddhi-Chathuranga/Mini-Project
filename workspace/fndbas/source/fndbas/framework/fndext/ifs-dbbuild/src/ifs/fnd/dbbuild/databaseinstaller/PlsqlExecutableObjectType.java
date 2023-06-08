/*=====================================================================================
 * PlsqlExecutableObjectType.java
 *
 * CHANGE HISTORY
 *
 * Id          Date        Developer  Description
 * =========== =========== ========== =================================================
 * Falcon      2010-10-18  MaBose     One Installer
 * ====================================================================================
 */
package ifs.fnd.dbbuild.databaseinstaller;

public class PlsqlExecutableObjectType {

   String value;

   public PlsqlExecutableObjectType(String txt, int idx) {
      value = txt;
   }
   public static final PlsqlExecutableObjectType VIEW;
   public static final PlsqlExecutableObjectType TABLECOMMENT;
   public static final PlsqlExecutableObjectType COLUMNCOMMENT;
   public static final PlsqlExecutableObjectType PACKAGE;
   public static final PlsqlExecutableObjectType PACKAGEBODY;
   public static final PlsqlExecutableObjectType PROCEDURE;
   public static final PlsqlExecutableObjectType FUNCTION;
   public static final PlsqlExecutableObjectType DECLAREEND;
   public static final PlsqlExecutableObjectType UNKNOWN;
   public static final PlsqlExecutableObjectType COMMENT;
   public static final PlsqlExecutableObjectType BEGINEND;
   public static final PlsqlExecutableObjectType TRIGGER;
   public static final PlsqlExecutableObjectType STATEMENT;
   public static final PlsqlExecutableObjectType JAVASOURCE;
   public static final PlsqlExecutableObjectType TYPE;
   public static final PlsqlExecutableObjectType TYPEBODY;

   static {
      VIEW = new PlsqlExecutableObjectType("VIEW", 0);
      TABLECOMMENT = new PlsqlExecutableObjectType("TABLECOMMENT", 1);
      COLUMNCOMMENT = new PlsqlExecutableObjectType("COLUMNCOMMENT", 2);
      PACKAGE = new PlsqlExecutableObjectType("PACKAGE", 3);
      PACKAGEBODY = new PlsqlExecutableObjectType("PACKAGEBODY", 4);
      PROCEDURE = new PlsqlExecutableObjectType("PROCEDURE", 5);
      FUNCTION = new PlsqlExecutableObjectType("FUNCTION", 6);
      DECLAREEND = new PlsqlExecutableObjectType("DECLARE END", 7);
      UNKNOWN = new PlsqlExecutableObjectType("UNKNOWN", 8);
      COMMENT = new PlsqlExecutableObjectType("COMMENT", 9);
      BEGINEND = new PlsqlExecutableObjectType("BEGIN END", 10);
      TRIGGER = new PlsqlExecutableObjectType("TRIGGER", 11);
      STATEMENT = new PlsqlExecutableObjectType("STATEMENT", 12);
      JAVASOURCE = new PlsqlExecutableObjectType("JAVASOURCE", 13);
      TYPE = new PlsqlExecutableObjectType("TYPE", 14);
      TYPEBODY = new PlsqlExecutableObjectType("TYPEBODY", 15);
   }
}
