-----------------------------------------------------------------------------
--
--  Logical unit: MediaReport
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100422  Ajpelk Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  091029  PAWELK Renamed LU InfoObjectReport to MediaReport. Changed the code accordingly. 
--  091029         Modified the module by setting module name from partca to appsrv.
--  090826  PAWELK Added Insert_Or_Update__() and INFO_OBJECT_REPORT_LOCALIZE.
--  090824  PAWELK Created.
--  --------------------------- APPS 9 --------------------------------------
--  130618  heralk  Scalability Changes - removed global variables
--  131122  paskno  Hooks: refactoring and splitting.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Or_Update__
--   Insert or update the basic data.
PROCEDURE Insert_Or_Update__ (
   rec_ IN MEDIA_REPORT_TAB%ROWTYPE )
IS
   dummy_        VARCHAR2(1);
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(32000);
   newrec_       MEDIA_REPORT_TAB%ROWTYPE;
   oldrec_       MEDIA_REPORT_TAB%ROWTYPE;
   indrec_       Indicator_Rec;
   CURSOR exist IS
      SELECT 'X'
      FROM media_report_tab
      WHERE report_id = rec_.report_id;
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   
   OPEN exist;
   FETCH exist INTO dummy_;
   IF (exist%NOTFOUND) THEN
      Client_SYS.Add_To_Attr('REPORT_ID', rec_.report_id, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.report_id);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
   CLOSE exist;
   Basic_Data_Translation_API.Insert_Prog_Translation('APPSRV',
                                                       lu_name_,
                                                       rec_.report_id,
                                                       rec_.description);
END Insert_Or_Update__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   report_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ MEDIA_REPORT_TAB.description%TYPE;
   CURSOR get_attr IS
      SELECT description
      FROM MEDIA_REPORT_TAB
      WHERE report_id = report_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   temp_ := Substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('APPSRV', 'MediaReport', report_id_),temp_),1,250);
   RETURN temp_;
END Get_Description;



