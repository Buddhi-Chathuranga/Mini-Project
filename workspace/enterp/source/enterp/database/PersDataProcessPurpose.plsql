-----------------------------------------------------------------------------
--
--  Logical unit: PersDataProcessPurpose
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171221  Piwrpl  Merged, LCS 139441, GDPR implemented 
--  171020  Krwipl  GDPR-108, Created
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
   Client_SYS.Add_To_Attr('PURPOSE_ID', Get_Next_Purpose_Id___(), attr_);
END Prepare_Insert___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT pers_data_process_purpose_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   user_language_code_    VARCHAR2(5);
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   user_language_code_ := Fnd_Session_API.Get_Language;
   Basic_Data_Translation_API.Insert_Basic_Data_Translation(module_, lu_name_, newrec_.purpose_id || '^PURPOSE_NAME', user_language_code_, newrec_.purpose_name);
   Basic_Data_Translation_API.Insert_Basic_Data_Translation(module_, lu_name_, newrec_.purpose_id || '^DESCRIPTION', user_language_code_, newrec_.description);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     pers_data_process_purpose_tab%ROWTYPE,
   newrec_     IN OUT pers_data_process_purpose_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   user_language_code_    VARCHAR2(5);
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   user_language_code_ := Fnd_Session_API.Get_Language;
   Basic_Data_Translation_API.Insert_Basic_Data_Translation(module_, lu_name_, newrec_.purpose_id || '^PURPOSE_NAME', user_language_code_, newrec_.purpose_name, oldrec_.purpose_name);
   Basic_Data_Translation_API.Insert_Basic_Data_Translation(module_, lu_name_, newrec_.purpose_id || '^DESCRIPTION', user_language_code_, newrec_.description, oldrec_.description);
END Update___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN pers_data_process_purpose_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Basic_Data_Translation_API.Remove_Basic_Data_Translation(module_, lu_name_, remrec_.purpose_id || '^PURPOSE_NAME');
   Basic_Data_Translation_API.Remove_Basic_Data_Translation(module_, lu_name_, remrec_.purpose_id || '^DESCRIPTION');
END Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Get_Next_Purpose_Id___ RETURN NUMBER
IS
   purpose_id_  NUMBER;
BEGIN   
   SELECT PERS_DATA_PROCESS_PURPOSE_SEQ.NEXTVAL INTO purpose_id_ FROM dual;
   RETURN purpose_id_;
END Get_Next_Purpose_Id___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Encode (
   client_value_ IN VARCHAR2 ) RETURN NUMBER
IS
   value_    pers_data_process_purpose_tab.purpose_id%TYPE;
BEGIN
   SELECT purpose_id
      INTO  value_
      FROM  pers_data_process_purpose_tab
      WHERE nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('ENTERP', 'PersDataProcessPurpose', purpose_id||'^PURPOSE_NAME'), purpose_name) = client_value_;
   RETURN value_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, 'Encode');
END Encode;

