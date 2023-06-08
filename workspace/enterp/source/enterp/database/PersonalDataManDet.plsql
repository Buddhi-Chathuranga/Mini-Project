-----------------------------------------------------------------------------
--
--  Logical unit: PersonalDataManDet
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200911  machlk  HCSPRING20-1613, Implement GDPR after removing BENADM.
--  180620  Piwrpl  LCS 141382, Corrections of the PeDM Configuration
--  171221  Piwrpl  Created, LCS 139441, GDPR implemented 
--  210212  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Added New_Det_Data_Extended_Rec___, Modified New_Personal_Data_Man_Det and New_Property_Code_Det
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE New_Det_Data_Extended_Attr___ (
   attr_                 IN OUT VARCHAR2,
   application_area_id_  IN     VARCHAR2,
   field_name_           IN     VARCHAR2 )
IS 
BEGIN
   IF NOT(Client_Sys.Item_Exist('REFERENCE_DB', attr_) OR Client_Sys.Item_Exist('REFERENCE', attr_))  THEN
      Client_SYS.Add_To_Attr('REFERENCE_DB', Personal_Data_Man_Util_API.Get_Reference(application_area_id_, field_name_), attr_);
   END IF;
   IF NOT(Client_Sys.Item_Exist('MANDATORY_DB', attr_))  THEN
      Client_SYS.Add_To_Attr('MANDATORY_DB', Personal_Data_Man_Util_API.Get_Column_Nullable(application_area_id_, field_name_), attr_);
   END IF;
   IF NOT(Client_Sys.Item_Exist('FIELD_TYPE_DB', attr_) OR Client_Sys.Item_Exist('FIELD_TYPE', attr_)) THEN
      Client_SYS.Add_To_Attr('FIELD_TYPE_DB', Personal_Data_Man_Util_API.Get_Column_Type(application_area_id_, field_name_), attr_);
   END IF;
   IF NOT(Client_Sys.Item_Exist('FIELD_DATA_LENGTH', attr_)) THEN
      Client_SYS.Add_To_Attr('FIELD_DATA_LENGTH', Personal_Data_Man_Util_API.Get_Field_Length(application_area_id_, field_name_), attr_);
   END IF;
END New_Det_Data_Extended_Attr___;


PROCEDURE New_Det_Data_Extended_Rec___ (
   rec_                 IN OUT personal_data_man_det_tab%ROWTYPE,
   application_area_id_ IN     VARCHAR2,
   field_name_          IN     VARCHAR2 )
IS 
BEGIN
   IF rec_.reference IS NULL THEN
      rec_.reference := Personal_Data_Man_Util_API.Get_Reference(application_area_id_, field_name_);
   END IF;
   IF rec_.mandatory IS NULL THEN
      rec_.mandatory := Personal_Data_Man_Util_API.Get_Column_Nullable(application_area_id_, field_name_);
   END IF;
   IF rec_.field_type IS NULL THEN
      rec_.field_type := Personal_Data_Man_Util_API.Get_Column_Type(application_area_id_, field_name_);
   END IF;
   IF rec_.field_data_length IS NULL THEN
      rec_.field_data_length := Personal_Data_Man_Util_API.Get_Field_Length(application_area_id_, field_name_);
   END IF;
END New_Det_Data_Extended_Rec___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Unpack___ (
   newrec_   IN OUT personal_data_man_det_tab%ROWTYPE,
   indrec_   IN OUT Indicator_Rec,
   attr_     IN OUT VARCHAR2 )
IS
   application_area_id_ personal_data_man_det_tab.application_area_id%TYPE;
   field_name_   personal_data_man_det_tab.field_name%TYPE;
   storage_type_  personal_data_man_det_tab.field_name%TYPE;  
BEGIN
   application_area_id_ := Client_Sys.Get_Item_Value('APPLICATION_AREA_ID', attr_);
   field_name_ := Client_Sys.Get_Item_Value('FIELD_NAME', attr_);
   storage_type_ := Storage_Type_API.Encode(Client_Sys.Get_Item_Value('STORAGE_TYPE', attr_));
   IF (storage_type_ = 'FIELD') THEN
      New_Det_Data_Extended_Attr___(attr_, application_area_id_, field_name_);   
   END IF;
   super(newrec_, indrec_, attr_);
END Unpack___;
   
   
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     personal_data_man_det_tab%ROWTYPE,
   newrec_ IN OUT personal_data_man_det_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.match_by IS NULL AND newrec_.condition IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NULLVALUESFORMATCH: Match By or Condition should have a value.');
   END IF;   
   super(oldrec_, newrec_, indrec_, attr_);   
END Check_Common___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('SEQ_NO', Get_Next_Pers_Det_Man_id___(), attr_);
   Client_SYS.Add_To_Attr('SKIP_ANONYMIZE_DB', 'FALSE', attr_); 
   Client_SYS.Add_To_Attr('EXCLUDE_FROM_CLEANUP_DB', 'FALSE', attr_);   
END Prepare_Insert___;

FUNCTION Get_Next_Pers_Det_Man_id___ RETURN NUMBER
IS
   personal_data_man_det_seq_  NUMBER;
BEGIN
   SELECT personal_data_man_det_seq.NEXTVAL INTO personal_data_man_det_seq_ FROM dual;
   RETURN personal_data_man_det_seq_;
END Get_Next_Pers_Det_Man_id___;

FUNCTION Check_Exist_Det___ (
   pers_data_management_id_ IN NUMBER,   
   storage_type_            IN VARCHAR2,            
   data_subject_            IN VARCHAR2,
   application_area_id_     IN VARCHAR2,
   field_name_              IN VARCHAR2,
   field_value_             IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   SELECT 1
      INTO  dummy_
      FROM  personal_data_man_det_tab
      WHERE pers_data_management_id = pers_data_management_id_
      AND   storage_type = storage_type_
      AND   data_subject = data_subject_
      AND   application_area_id = application_area_id_
      AND   nvl(field_name,' ') = nvl(field_name_,' ')
      AND   nvl(field_value,' ') = nvl(field_value_,' ');
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      RETURN TRUE;
END Check_Exist_Det___;

FUNCTION Check_Exist_Seq___ (
   pers_data_management_id_ IN NUMBER,
   seq_no_                  IN NUMBER ) RETURN BOOLEAN 
IS
   dummy_ NUMBER;
BEGIN
   SELECT 1
      INTO  dummy_
      FROM  personal_data_man_det_tab
      WHERE pers_data_management_id = pers_data_management_id_
        AND seq_no                  = seq_no_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      RETURN TRUE;
END Check_Exist_Seq___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT personal_data_man_det_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   IF (newrec_.field_type IS NOT NULL) AND (newrec_.field_type = '1') THEN
      Basic_Data_Translation_API.Insert_Basic_Data_Translation('ENTERP', 'PersonalDataManDet',
         newrec_.pers_data_management_id||'^'||newrec_.seq_no,
         NULL, newrec_.masked_value);
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     personal_data_man_det_tab%ROWTYPE,
   newrec_     IN OUT personal_data_man_det_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS

BEGIN   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF (newrec_.field_type IS NOT NULL) AND (newrec_.field_type = '1') THEN
      IF ((newrec_.masked_value IS NOT NULL)) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ENTERP', 'PersonalDataManDet',
            newrec_.pers_data_management_id||'^'||newrec_.seq_no,
            NULL, newrec_.masked_value, oldrec_.masked_value); 
      ELSE
         Basic_Data_Translation_API.Remove_Basic_Data_Translation('ENTERP', 'PersonalDataManDet',
            newrec_.pers_data_management_id||'^'||newrec_.seq_no);
      END IF;
   END IF;
   
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN personal_data_man_det_tab%ROWTYPE )
IS
   
BEGIN
   super(objid_, remrec_);
   Basic_Data_Translation_API.Remove_Basic_Data_Translation('ENTERP', 'PersonalDataManDet',
         remrec_.pers_data_management_id||'^'||remrec_.seq_no);
END Delete___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Is_Lu_Used_Personal_Data (
   pers_data_management_id_ IN NUMBER,
   application_area_id_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   count_                   NUMBER;
   CURSOR check_lu_used IS
      SELECT count(*)
        FROM personal_data_man_det_tab p
       WHERE p.pers_data_management_id = pers_data_management_id_
         AND p.application_area_id = application_area_id_;
BEGIN
   OPEN  check_lu_used;
   FETCH check_lu_used INTO count_;
   CLOSE check_lu_used;
   
   IF count_ > 0 THEN RETURN 'TRUE';
   END IF;
   RETURN 'FALSE';
END Is_Lu_Used_Personal_Data;

@UncheckedAccess
FUNCTION Any_Details_Are_Fields (
   pers_data_management_id_ IN NUMBER) RETURN VARCHAR2
IS
   temp_ NUMBER;   
BEGIN
   IF (pers_data_management_id_ IS NULL) THEN
      RETURN 'FALSE';
   END IF;
   SELECT 1
      INTO  temp_
      FROM  personal_data_man_det_tab
      WHERE pers_data_management_id = pers_data_management_id_
      AND   storage_type  = Storage_Type_Api.DB_FIELD;
   RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
   WHEN too_many_rows THEN
      RETURN 'TRUE';
END Any_Details_Are_Fields;

@UncheckedAccess
FUNCTION Get_Translated_Masked_Value (
   pers_data_management_id_ IN NUMBER,
   seq_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ personal_data_man_det_tab.masked_value%TYPE;
BEGIN
   IF (pers_data_management_id_ IS NULL OR seq_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('ENTERP', 'PersonalDataManDet',
              pers_data_management_id||'^'||seq_no), masked_value), 1, 200)
      INTO  temp_
      FROM  personal_data_man_det_tab
      WHERE pers_data_management_id = pers_data_management_id_
      AND   seq_no = seq_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(pers_data_management_id_, seq_no_, 'Get_Masked_Value');
END Get_Translated_Masked_Value;

PROCEDURE New_Personal_Data_Man_Det(
   pers_data_management_id_  IN NUMBER,   
   seq_no_                   IN NUMBER,   
   cleanup_order_            IN NUMBER,
   storage_type_             IN VARCHAR2,
   data_subject_             IN VARCHAR2,
   application_area_id_      IN VARCHAR2,
   field_name_               IN VARCHAR2,   
   field_value_              IN VARCHAR2,
   field_type_               IN VARCHAR2,
   field_data_length_        IN NUMBER,
   masked_value_             IN VARCHAR2, 
   match_by_                 IN VARCHAR2,   
   condition_                IN VARCHAR2,
   table_condition_          IN VARCHAR2, 
   skip_anonymize_           IN VARCHAR2,
   mandatory_                IN VARCHAR2,
   reference_                IN VARCHAR2,
   exclude_from_cleanup_     IN VARCHAR2,
   report_order_             IN NUMBER,
   module_                   IN VARCHAR2,
   remarks_                  IN VARCHAR2 DEFAULT NULL)
IS
   loc_seq_no_                NUMBER;
   mode_                      VARCHAR2(20) := 'INSERT';
   newrec_                    personal_data_man_det_tab%ROWTYPE;
BEGIN
   -- NOTE: possible values for 'mode_' variable are: INSERT, UPDATE, SKIP
   IF seq_no_ IS NULL THEN
      IF NOT(Check_Exist_Det___ (pers_data_management_id_, storage_type_, data_subject_, application_area_id_, field_name_, field_value_)) THEN
         mode_ := 'INSERT';
         loc_seq_no_ := Get_Next_Pers_Det_Man_id___();
      ELSE
         mode_ := 'SKIP';
      END IF;
   ELSE        
      -- if seq_no_ IS NOT NULL
      loc_seq_no_ := seq_no_;
      IF (Check_Exist_Seq___(pers_data_management_id_,loc_seq_no_)) THEN
         mode_ := 'UPDATE';
      ELSE
         mode_ := 'INSERT';
      END IF;
   END IF;

   IF mode_ = 'SKIP' THEN RETURN;
   END IF;

   -- Build newrec_
   IF (mode_ = 'INSERT') THEN
      newrec_.pers_data_management_id  := pers_data_management_id_; 
      newrec_.seq_no                   := loc_seq_no_;
      newrec_.skip_anonymize           := skip_anonymize_;
      newrec_.masked_value             := masked_value_;
      IF (mandatory_ IS NOT NULL) THEN
         newrec_.mandatory := mandatory_;
      ELSE
         newrec_.mandatory := 'FALSE';
      END IF;
      newrec_.storage_type := storage_type_;
   ELSE
      newrec_ := Get_Object_By_Keys___(pers_data_management_id_, loc_seq_no_);
   END IF;

   -- values common for both INSERT and UPDATE modes
   newrec_.cleanup_order         := cleanup_order_;
   newrec_.data_subject          := data_subject_;
   newrec_.application_area_id   := application_area_id_;
   newrec_.field_name            := field_name_;
   newrec_.field_value           := field_value_;
   newrec_.match_by              := match_by_;
   newrec_.module                := module_;
   newrec_.condition             := condition_;
   newrec_.table_condition       := table_condition_;
   newrec_.exclude_from_cleanup  := exclude_from_cleanup_;
   
   IF (reference_ IS NOT NULL) THEN
      newrec_.reference := reference_;
   END IF;
   
   IF (report_order_ IS NOT NULL) THEN
      newrec_.report_order := report_order_;
   END IF;

   IF (storage_type_ = 'FIELD') THEN
      New_Det_Data_Extended_Rec___(newrec_, application_area_id_, field_name_);
   ELSE
      IF (reference_ IS NULL) THEN
         newrec_.reference := 'FALSE';
      END IF;
   END IF;
   
   IF (field_type_ IS NOT NULL) THEN
      newrec_.field_type   := field_type_;
   END IF;

   IF (field_data_length_ IS NOT NULL) THEN
      newrec_.field_data_length  := field_data_length_;
   END IF;
   
   IF (remarks_ IS NOT NULL) THEN
      newrec_.remarks   := remarks_;
   END IF;

   -- create or update PDM detail
   IF mode_ = 'INSERT' THEN
      New___(newrec_);
   ELSE            
      -- if mode_ = 'UPDATE'
      Modify___(newrec_);
   END IF;
END New_Personal_Data_Man_Det;
   
PROCEDURE New_Pers_Data_Man_Prop_Code (
   property_code_ IN VARCHAR2)
IS
   property_object_ VARCHAR2(10);
   application_area_id_    personal_data_man_det_tab.application_area_id%TYPE;
   field_name_             personal_data_man_det_tab.field_name%TYPE;   
   storage_type_           personal_data_man_det_tab.storage_type%TYPE;
   data_subject_           personal_data_man_det_tab.data_subject%TYPE;
   match_by_               personal_data_man_det_tab.match_by%TYPE;
   multi_fields_     NUMBER;
   pers_data_management_id_ NUMBER := NULL;
   
BEGIN
   $IF Component_Person_SYS.INSTALLED $THEN
      Personal_Data_Management_API.New_Pers_Data_Management(pers_data_management_id_, property_code_, 'FALSE', 'REMOVE', 'PROPERTY_CODE', 'FALSE');
   
      property_object_  := Property_Rule_Api.Get_Property_Object_Db(property_code_);
      multi_fields_     := Property_Rule_Api.Get_Multiple_Fields(property_code_);
      field_name_       := 'PROPERTY_VALUE';      
      storage_type_     := 'PROPERTY_CODE';

      IF (property_object_ = 5) THEN
         IF (multi_fields_ = 0) THEN
            application_area_id_ := 'CompanyPersProperty';
         ELSE
            application_area_id_ := 'CompPersPropertyField';
         END IF;
         match_by_ := 'PERSON_ID';
         data_subject_ := 'PERSON';
      ELSIF (property_object_ = 4) THEN
         IF (multi_fields_ = 0) THEN
            application_area_id_ := 'CompanyEmployeeProperty';
         ELSE
            application_area_id_ := 'CompanyEmpPropertyField';
         END IF;      
         match_by_ := 'COMPANY_ID,EMP_NO';
         data_subject_ := 'EMPLOYEE';
      END IF;

      New_Property_Code_Det(pers_data_management_id_, storage_type_, data_subject_, 
         application_area_id_, field_name_, property_code_, match_by_);
   $ELSE
      NULL;
   $END
END New_Pers_Data_Man_Prop_Code;

PROCEDURE Remove_Details_For_Module (
   module_ IN VARCHAR2)
IS
   info_ VARCHAR2(2000);
   CURSOR get_details_for_module IS
      SELECT a.rowid, to_char(a.rowversion,'YYYYMMDDHH24MISS') AS rowversion      
      FROM personal_data_man_det_tab a , personal_data_management_tab b
      WHERE a.pers_data_management_id = b.pers_data_management_id
      AND   module = module_
      AND   system_defined = 'TRUE';
BEGIN
   FOR rec_ IN get_details_for_module LOOP
      Remove__(info_, rec_.rowid, rec_.rowversion, 'DO');
   END LOOP;   
END Remove_Details_For_Module;

PROCEDURE New_Property_Code_Det (   
   pers_data_management_id_ IN NUMBER,   
   storage_type_            IN VARCHAR2,            
   data_subject_            IN VARCHAR2,
   application_area_id_     IN VARCHAR2,
   field_name_              IN VARCHAR2,
   field_value_             IN VARCHAR2,        
   match_by_                IN VARCHAR2)   
IS
   cleanup_order_ NUMBER;
   newrec_        personal_data_man_det_tab%ROWTYPE;
   CURSOR get_cleanup_order_max IS
      SELECT NVL(MAX(cleanup_order),0) + 100
      FROM   personal_data_man_det_tab
      WHERE  pers_data_management_id = pers_data_management_id_;
BEGIN
   IF NOT(Check_Exist_Det___ (pers_data_management_id_, storage_type_, data_subject_, application_area_id_, field_name_, field_value_)) THEN      
      OPEN get_cleanup_order_max;
      FETCH get_cleanup_order_max INTO cleanup_order_;
      CLOSE get_cleanup_order_max;

      newrec_.pers_data_management_id  := pers_data_management_id_;
      newrec_.seq_no                   := Get_Next_Pers_Det_Man_id___();
      newrec_.cleanup_order            := cleanup_order_;
      newrec_.storage_type             := storage_type_;
      newrec_.data_subject             := data_subject_;
      newrec_.application_area_id      := application_area_id_;
      newrec_.field_name               := field_name_;
      newrec_.field_value              := field_value_;
      newrec_.match_by                 := match_by_; 
      newrec_.mandatory                := 'TRUE';
      newrec_.reference                := 'FALSE';
      newrec_.report_order             := 1;
      newrec_.module                   := 'PERSON';
      newrec_.skip_anonymize           := 'FALSE';
      newrec_.exclude_from_cleanup     := 'FALSE';
      New_Det_Data_Extended_Rec___(newrec_, application_area_id_, field_name_);
      New___(newrec_);
   END IF;
END New_Property_Code_Det; 

@UncheckedAccess
FUNCTION Data_Subject_Used_On_Details (
   pers_data_management_id_ IN NUMBER,
   data_subject_            IN VARCHAR2) RETURN VARCHAR2
IS
   temp_ NUMBER;
   CURSOR get_get_for_ds IS
   SELECT 1
   FROM personal_data_man_det_tab
   WHERE pers_data_management_id = pers_data_management_id_
   AND   exclude_from_cleanup = 'FALSE'
   AND   Report_Sys.Parse_Parameter(data_subject, Personal_Data_Man_Util_api.Get_Related_Data_Subjects(Data_Subject_API.Encode(data_subject_), 'OBVERSE')) = 'TRUE';
BEGIN
   OPEN get_get_for_ds;
   FETCH get_get_for_ds INTO temp_;
   IF get_get_for_ds%FOUND THEN
      CLOSE get_get_for_ds;
      RETURN 'TRUE';
   END IF;
   CLOSE get_get_for_ds;
   RETURN 'FALSE';   
END Data_Subject_Used_On_Details;
    
   

