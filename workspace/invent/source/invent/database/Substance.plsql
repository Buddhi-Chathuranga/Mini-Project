-----------------------------------------------------------------------------
--
--  Logical unit: Substance
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170301  WaSalk   Bug 134439, Modified Get_Description() by returning whole value without converting in to a substring.
--  120525  JeLise   Made description private.
--  120508  Matkse   Modified method Get_Description, replaced obsolete method call
--  110526  ShKolk   Added General_SYS for Insert_Lu_Data_Rec().
--  101203  AndDse   BP-3510, Added procedure Insert_Lu_Data_Rec.
--  100930  AndDse   BP-2693, Moved Substance LU from mpccom to invent.
--  100611  JeLise   Added attributes to LOV.
--  100422  UTSWLK   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Cas_Exist___ (
   cas_no_ IN VARCHAR2,
   substance_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SUBSTANCE_TAB
      WHERE cas_no = cas_no_
         AND substance_no <> substance_no_;
BEGIN

   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Cas_Exist___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT substance_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   IF NOT newrec_.cas_no IS NULL THEN
      IF Check_Cas_Exist___(newrec_.cas_no, newrec_.substance_no) THEN
         Error_SYS.Record_General(lu_name_, 'EM_SUBSTANCE_CAS_NO_EXISTS: The CAS No already exists.');
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   substance_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_             SUBSTANCE_TAB.description%TYPE;
   translated_str_   SUBSTANCE_TAB.description%TYPE;

   CURSOR get_attr IS
      SELECT description
      FROM SUBSTANCE_TAB
      WHERE substance_no = substance_no_;
BEGIN
   translated_str_ := Basic_Data_Translation_API.Get_Basic_Data_Translation('INVENT', 'Substance',substance_no_);

   IF translated_str_ IS NULL THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
      RETURN temp_;
   ELSE
      RETURN translated_str_;
   END IF;
END Get_Description;


PROCEDURE Insert_Lu_Data_Rec (
   newrec_ IN OUT SUBSTANCE_TAB%ROWTYPE )
IS
   objid_      SUBSTANCE.objid%TYPE;
   objversion_ SUBSTANCE.objversion%TYPE;
   attr_       VARCHAR2(100);
   
BEGIN
   IF (NOT Check_Exist___(newrec_.substance_no)) THEN
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;

   Basic_Data_Translation_API.Insert_Prog_Translation('INVENT',
                                                      'Substance',
                                                      newrec_.substance_no,
                                                      newrec_.description);
END Insert_Lu_Data_Rec;


@UncheckedAccess
FUNCTION Get_Substance_No_On_Cas (
   cas_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   substance_no_ SUBSTANCE_TAB.substance_no%TYPE;

   CURSOR get_attr IS
      SELECT substance_no
      FROM SUBSTANCE_TAB
      WHERE cas_no = cas_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO substance_no_;
   CLOSE get_attr;
   RETURN substance_no_;
END Get_Substance_No_On_Cas;



