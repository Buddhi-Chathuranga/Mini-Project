-----------------------------------------------------------------------------
--
--  Logical unit: PersonalDataManagement
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200617  machlk  Bug ID 153706 Fixed, Added validation to restrict SSN from Anonymization.
--  171221  Piwrpl  Created, LCS 139441, GDPR implemented
--  210212  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified method New_Pers_Data_Management
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
   Client_SYS.Add_To_Attr('PERS_DATA_MANAGEMENT_ID', Get_Next_Personal_Man_id___(), attr_);
   Client_SYS.Add_To_Attr('DATA_CLEANUP_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SYSTEM_DEFINED_DB', 'FALSE', attr_);   
END Prepare_Insert___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN personal_data_management_tab%ROWTYPE )
IS
BEGIN
   IF (remrec_.system_defined = 'TRUE') THEN
      Error_SYS.Appl_General(lu_name_, 'SYSDEFNOTREM: System Defined Personal Data can not be removed.');
   END IF;
   super(remrec_);   
END Check_Delete___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     personal_data_management_tab%ROWTYPE,
   newrec_ IN OUT personal_data_management_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
    
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (indrec_.data_cleanup_method = TRUE) THEN
      IF (oldrec_.data_cleanup_method = 'REMOVE' AND newrec_.data_cleanup_method = 'ANONYMIZE') THEN
         IF (Personal_Data_Man_Det_Api.Any_Details_Are_Fields(newrec_.pers_data_management_id) = 'FALSE') OR (newrec_.pers_data_management_id = 8)THEN
            Error_SYS.Appl_General(lu_name_, 'ANONOTAVAIL: Anonymization is unavailable for the :P1 personal data.', Get_Personal_Data(newrec_.pers_data_management_id));            
         END IF;
      END IF;
   END IF;   
END Check_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Get_Next_Personal_Man_id___ RETURN NUMBER
IS
   pers_data_management_id_  NUMBER;
BEGIN   
   SELECT pers_data_management_seq.NEXTVAL INTO pers_data_management_id_ FROM dual;
   RETURN pers_data_management_id_;
END Get_Next_Personal_Man_id___;



-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New_Pers_Data_Management (
   pers_data_management_id_ IN OUT NUMBER,
   personal_data_           IN VARCHAR2,
   data_cleanup_            IN VARCHAR2,
   data_cleanup_method_     IN VARCHAR2,
   data_category_           IN VARCHAR2,
   system_defined_          IN VARCHAR2 )
IS
   newrec_                    personal_data_management_tab%ROWTYPE;
BEGIN
   IF pers_data_management_id_ IS NULL THEN
      newrec_.pers_data_management_id  := Get_Next_Personal_Man_id___();
      newrec_.system_defined           := 'FALSE';
      pers_data_management_id_         := newrec_.pers_data_management_id;
   ELSE
      newrec_.pers_data_management_id  := pers_data_management_id_;
   END IF;
   
   IF NOT(Check_Exist___ (pers_data_management_id_)) THEN
      newrec_.personal_data         := personal_data_;
      newrec_.data_cleanup          := data_cleanup_;
      newrec_.data_cleanup_method   := data_cleanup_method_;
      newrec_.data_category         := data_category_;
      newrec_.system_defined        := system_defined_;
      New___(newrec_);
   END IF;
END New_Pers_Data_Management;

PROCEDURE Ins_Pers_Data_Management (
   pers_data_management_id_ IN NUMBER,
   personal_data_           IN VARCHAR2,
   data_cleanup_            IN VARCHAR2,
   data_cleanup_method_     IN VARCHAR2,
   data_category_           IN VARCHAR2,
   system_defined_          IN VARCHAR2 )
IS
   temp_pers_data_man_id_ NUMBER;
BEGIN
   temp_pers_data_man_id_ := pers_data_management_id_;
   New_Pers_Data_Management(temp_pers_data_man_id_, personal_data_, data_cleanup_, data_cleanup_method_, data_category_, system_defined_);
EXCEPTION 
  WHEN OTHERS THEN
    NULL;
END Ins_Pers_Data_Management;

FUNCTION Get_Anonymization (
   pers_data_management_id_ IN NUMBER ) RETURN Anonymization_Setup_Api.Public_Rec 
IS
   rec_ Anonymization_Setup_Api.Public_Rec ;
   method_id_ anonymization_setup_tab.method_id%TYPE;
BEGIN
   method_id_ :=  Get_Anonymization_Method_Id(pers_data_management_id_);   
   rec_ := Anonymization_Setup_Api.Get_Anonimization(method_id_);
   RETURN rec_;   
END Get_Anonymization;

FUNCTION Encode (
   client_value_ IN VARCHAR2 ) RETURN NUMBER
IS
   value_    personal_data_management_tab.pers_data_management_id%TYPE;
BEGIN
   SELECT pers_data_management_id
      INTO  value_
      FROM  personal_data_management_tab
      WHERE substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('ENTERP', 'PersonalDataManagement',
          pers_data_management_id), personal_data), 1, 30) = client_value_;
   RETURN value_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, 'Encode');
END Encode;


