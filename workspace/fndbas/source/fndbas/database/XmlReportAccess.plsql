-----------------------------------------------------------------------------
--
--  Logical unit: XmlReportAccess
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140715  NaBaLK  Has_Access_From_Id_ to check access rights (TEREPORT-1310)
--  140919  NaBaLK  Added a commit when New__ is completed (TEREPORT-1418)
-----------------------------------------------------------------------------

layer Core;

-------------------- BASE METHODS ------------------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT NOCOPY VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   @ApproveTransactionStatement(2014-09-19,NaBaLK)
   COMMIT;
END New__;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Clear__ (
   result_key_ IN NUMBER,
   id_         IN VARCHAR2)
IS
BEGIN
   DELETE
      FROM XML_REPORT_ACCESS_TAB
      WHERE result_key = result_key_ AND id = id_;
END Clear__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Has_Access_From_Id_ (
   result_key_ IN NUMBER,
   id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ NUMBER := 0;
   CURSOR get_attr IS
      SELECT 1
        FROM XML_REPORT_ACCESS_TAB
       WHERE result_key = result_key_
         AND id = id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF temp_ > 0 THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Has_Access_From_Id_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Clear (
   result_key_ IN NUMBER )
IS
BEGIN
   DELETE
      FROM XML_REPORT_ACCESS_TAB
      WHERE result_key = result_key_;
END Clear;
