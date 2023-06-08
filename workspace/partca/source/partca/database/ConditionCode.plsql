-----------------------------------------------------------------------------
--
--  Logical unit: ConditionCode
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200601  SBalLK  Bug 154205(SCZ-10061), Modified Check_Delete___() method by removing restriction on deleting system generated 'NORMAL' condition code.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in calls to Data_Capture_Session_Lov_API.New.
--  190410  ChBnlk  Bug 147902 (SCZ-4050), Modified Create_Data_Capture_Lov() by changing conditional compilation of session_rec_ usage to check for both Mpccom  
--  190410          and Wadaco to avoid build errors.
--  171011  BuRalk  CAM-785, Modified Prepare_Insert___ and Insert_Lu_Data_Rec__ to handle reset_repair_value and reset_overhaul_value.
--  160420  JanWse  STRSC-1741, Added TRUE to also check for blocked in a call to Part_Availability_Control_API.Exist
--  150730  HimRlk  Bug 122030, Added Get_Description_By_Language() to fetch description by language code.
--  150729  BudKlk  Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729          method call in ORDER BY clause to sort string and number values seperately.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.--  141125  DaZase  PRSC-4373, Changed Create_Data_Capture_Lov so it now also have AUTO_PICK handling and changes concerning which cc is the default in both LOV versions.
--  140619  DaZase  PRSC-1207, Changed Create_Data_Capture_Lov so it now only uses ORDER BY ASC.
--  130729  MaIklk  TIBE-1036, Removed inst_PartAvailabilityControl_ global constant and used conditional compilation instead.
--  120827  DaZase  Added method Create_Data_Capture_Lov and constant inst_DataCaptureSessionLov.
--  120525  JeLise  Made description private.
--  120504  JeLise  Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120504          in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120504          was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  100423  KRPELK  Merge Rose Method Documentation.
--  100120  HimRlk  Added Global constant inst_PartAvailabilityControl.
--  090925  HoInlk  Bug 85995, Set default value of condition_code_type to NOT_DEF_COND_CODE on insert.
-- ----------------------------- 13.0.0 --------------------------------------
--  070604  ChJalk  Bug 64872, Modified Get_description() method to fetch the 'Description' if condition_code_ is not null. 
--  070517  IsAnlk  Changed view comments by adding UPPERCASE on condition_code in view CONDITION_CODE.  
--  060727  ThGulk  Added &OBJID instead of rowif in Procedure Insert___
--  060123  JaJalk  Added Assert safe annotation.
--  060110  JoEd    Added method Get_Control_Type_Value_Desc.
--  060110  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  050916  NaLrlk  Removed unused varaibles.
--  040224  LoPrlk  Removed substrb from code. &VIEW.description, &VIEW and Get_Description were altered.
--  -----------------------------12.3.0-------------------------
--  031204  LaBolk  Changed position of Get_Default_Avail_Control_Id. Modified view comments of default_avail_control_id to remove reference.
--  031204          Modified Unpack_Check_Insert___ and Unpack_Check_Update___.
--  -----------------------EDGE - Package Group 2----------------------------
--  031002  ThGulk Changed substr to substrb, instr to instrb, length to lengthb.
--  030806  MaEelk  Call ID 99745, Added a condion in Check_Delete___ to restrict deleteting the Default Condition Code.
--  030327  MaGulk  Added Insert_Lu_Data_Rec__ and modified Insert___, Update___,
--                  Delete___, Get_Description to introduce component translation support
--  020611  PEKR    Made condition_code_type part of ListOfValues.
--  020530  PEKR    Added Get_Default_Condition_Code.
--  020527  PEKR    At least one condition code must be default.
--  020523  PEKR    Created
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
   Client_SYS.Add_To_Attr('CONDITION_CODE_TYPE_DB', 'NOT_DEF_COND_CODE', attr_);
   Client_SYS.Add_To_Attr('RESET_REPAIR_VALUE_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('RESET_OVERHAUL_VALUE_DB', Fnd_Boolean_API.DB_FALSE, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CONDITION_CODE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF Get_Default_Condition_Code IS NOT NULL THEN
      IF (newrec_.condition_code_type = 'DEF_COND_CODE') THEN
         UPDATE condition_code_tab
            SET condition_code_type = 'NOT_DEF_COND_CODE',
                rowversion = sysdate
            WHERE condition_code_type = 'DEF_COND_CODE';
      END IF;
   ELSE
      newrec_.condition_code_type := 'DEF_COND_CODE';
   END IF;

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CONDITION_CODE_TAB%ROWTYPE,
   newrec_     IN OUT CONDITION_CODE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.condition_code_type = 'DEF_COND_CODE') THEN
      UPDATE condition_code_tab
         SET condition_code_type = 'NOT_DEF_COND_CODE',
             rowversion = sysdate
         WHERE condition_code_type = 'DEF_COND_CODE';
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CONDITION_CODE_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   IF (remrec_.condition_code_type = 'DEF_COND_CODE') THEN
      Error_Sys.Record_General(lu_name_, 'CONDCODEDEF: It is not possible to delete the default condition code. Make sure the condition code type is Not Default before deleting.');
   END IF;
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT condition_code_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   newrec_.condition_code_type := 'NOT_DEF_COND_CODE';
   super(newrec_, indrec_, attr_);

   IF (newrec_.default_avail_control_id IS NOT NULL) THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         Part_Availability_Control_API.Exist(newrec_.default_avail_control_id, TRUE);
      $ELSE
         NULL;
      $END
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     condition_code_tab%ROWTYPE,
   newrec_ IN OUT condition_code_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF ((indrec_.condition_code_type) AND (newrec_.condition_code_type = 'NOT_DEF_COND_CODE')) THEN
      Error_SYS.Record_General(lu_name_, 'CONDCODETYPEERR: Point out the condition code that should be the default instead.');
   END IF;

   IF (newrec_.default_avail_control_id IS NOT NULL) THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         Part_Availability_Control_API.Exist(newrec_.default_avail_control_id, TRUE);
      $ELSE
         NULL;
      $END
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     condition_code_tab%ROWTYPE,
   newrec_ IN OUT condition_code_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   IF ((newrec_.reset_overhaul_value = 'TRUE') AND (newrec_.reset_repair_value = 'FALSE')) THEN
      Error_SYS.Record_General(lu_name_, 'RESETVALERR: When an overhaul is performed, value after repair automatically reset. If Reset Value After Overhaul is selected, Reset Value after Repair must also be selected.');
   END IF;
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Lu_Data_Rec__
--   Handles component translations
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN CONDITION_CODE_TAB%ROWTYPE )
IS
   dummy_      VARCHAR2(1);
   CURSOR Exist IS
      SELECT 'X'
      FROM CONDITION_CODE_TAB
      WHERE condition_code = newrec_.condition_code;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO CONDITION_CODE_TAB (
            condition_code,
            description,
            condition_code_type,
            reset_repair_value,
            reset_overhaul_value,
            rowversion)
         VALUES (
            newrec_.condition_code,
            newrec_.description,
            newrec_.condition_code_type,
            Fnd_Boolean_API.DB_FALSE,
            Fnd_Boolean_API.DB_FALSE,
            newrec_.rowversion);
   ELSE
      UPDATE CONDITION_CODE_TAB
         SET description = newrec_.description
       WHERE condition_code = newrec_.condition_code;

   END IF;
   CLOSE Exist;
   Basic_Data_Translation_API.Insert_Prog_Translation('PARTCA',
                                                      'ConditionCode',
                                                      newrec_.condition_code,
                                                      newrec_.description);
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description_By_Language
--   Fetches the Description attribute for a record by the given language code
--   Only difference between this method and the generated Get_description method is the laguage code.
@UncheckedAccess
FUNCTION Get_Description_By_Language (
   condition_code_ IN VARCHAR2,
   language_code_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ condition_code_tab.description%TYPE;
BEGIN
   IF (condition_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('PARTCA', 'ConditionCode',
              condition_code, language_code_), description), 1, 35)
      INTO  temp_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get_Description_By_Language');
END Get_Description_By_Language;
   
@UncheckedAccess
FUNCTION Get_Default_Condition_Code RETURN VARCHAR2
IS
   CURSOR get_default IS
   SELECT condition_code
      FROM  CONDITION_CODE_TAB
      WHERE  condition_code_type = 'DEF_COND_CODE';

   temp_   CONDITION_CODE_TAB.condition_code%TYPE;
BEGIN
   OPEN get_default;
   FETCH get_default INTO temp_;
   CLOSE get_default;
   RETURN temp_;
END Get_Default_Condition_Code;


PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;


-- This method is used by DataCaptureInventUtil and DataCaptRecSoByProd
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   capture_session_id_ IN NUMBER,
   lov_type_db_        IN VARCHAR2 )
IS
   $IF Component_Mpccom_SYS.INSTALLED $THEN
      lov_item_description_ VARCHAR2(200);
      session_rec_          Data_Capture_Common_Util_API.Session_Rec;
      lov_row_limitation_   NUMBER;
      exit_lov_             BOOLEAN := FALSE;
   $END

   CURSOR get_list_of_values IS
      SELECT condition_code, description, condition_code_type, condition_code_type_db
      FROM   CONDITION_CODE
      ORDER BY Utility_SYS.String_To_Number(condition_code) ASC, condition_code ASC;

   CURSOR get_list_of_values_autopick IS
      SELECT condition_code
      FROM   CONDITION_CODE
      WHERE  condition_code_type_db = Condition_Code_Type_API.DB_DEFAULT_CONDITION_CODE;
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED AND Component_Mpccom_SYS.INSTALLED $THEN

      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN  -- Auto Pick LOV
         FOR lov_rec_ IN get_list_of_values_autopick LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.condition_code,
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      ELSE  -- Normal LOV
         FOR lov_rec_ IN get_list_of_values LOOP
            IF (lov_rec_.condition_code_type_db = Condition_Code_Type_API.DB_DEFAULT_CONDITION_CODE) THEN
               lov_item_description_ := lov_rec_.description || '|' || lov_rec_.condition_code_type;    -- only show the default condition type as extra information
            ELSE
               lov_item_description_ := lov_rec_.description;
            END IF;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.condition_code,
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END

END Create_Data_Capture_Lov;


