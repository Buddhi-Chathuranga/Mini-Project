-----------------------------------------------------------------------------
--
--  Logical unit: TransportHazardClass
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200717  AjShLK   Bug 152999(SCZ-9246), Modified Get_Description method to support language translation for different languages.   
--  120525  JeLise   Made description private.
--  090518  KiSalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Lu_Data_Rec__ (
   rec_ IN TRANSPORT_HAZARD_CLASS_TAB%ROWTYPE )
IS
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(32000);
   newrec_       TRANSPORT_HAZARD_CLASS_TAB%ROWTYPE;
   oldrec_       TRANSPORT_HAZARD_CLASS_TAB%ROWTYPE;
   indrec_       Indicator_Rec;
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);

   IF (Check_Exist___(rec_.hazard_class)) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.hazard_class);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   ELSE
      Client_SYS.Add_To_Attr('HAZARD_CLASS', rec_.hazard_class, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;

   Basic_Data_Translation_API.Insert_Prog_Translation('INVENT',
                                                      lu_name_,
                                                      rec_.hazard_class,
                                                      rec_.description);
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   hazard_class_ IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   temp_ transport_hazard_class_tab.description%TYPE;
BEGIN
   IF (hazard_class_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      hazard_class_, language_code_), 1, 200);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  transport_hazard_class_tab
      WHERE hazard_class = hazard_class_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(hazard_class_, 'Get_Description');
END Get_Description;
