-----------------------------------------------------------------------------
--
--  Logical unit: QuaNonConformance
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201019  NISMLK  MFZ-5662, Removed unused methods Enumerate_Data() and Enumerate_Data_Db().
--  131123  NuKuLK  Hooks: Refactored and splitted code.
--  --------------------------- APPS 9 --------------------------------------
--  141127  TAORSE  Added Enumerate_Data_Db
--  120715  ArAmLk   Added public method Enumerate_Data().
--  120713  LaRelk   Added rowkey to allow custom fields.
--  120404  ArAmLk   Moved from CHNGMT and Renamed from MrbCode as to facilitate both CHMGMT and QUANCR
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------



-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('OBSOLETE_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('SHOW_IN_CHART_DB', Fnd_Boolean_API.DB_TRUE, attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Set_Show_In_Chart__ (
   nonconformance_code_   IN VARCHAR2,
   value_         IN VARCHAR2) 
IS
   newrec_  QUA_NON_CONFORMANCE_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(nonconformance_code_);
   newrec_.show_in_chart := value_;
   Modify___(newrec_);
END Set_Show_In_Chart__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   nonconformance_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   QUA_NON_CONFORMANCE_TAB
      WHERE nonconformance_code = nonconformance_code_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Exist;
