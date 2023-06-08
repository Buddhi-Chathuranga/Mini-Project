-----------------------------------------------------------------------------
--
--  Logical unit: MpccomDefaults
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180104  MaAuse  STRSC-15545, Modified Update___ by adding date to newrec_.last_activity_date.
--  171019  SBalLK  Bug 138300, Renamed Insert_Or_Update__() to Insert_Lu_Data_Rec__() and modified method to not update data since user entered values get reset during the upgrade.
--  151223  JoAnSe  STRMF-2144, Added checks for OPERATION_BLOCK_ID_PREFIX.
--  140123  AyAmlk   Bug 113885, Modified Check_Update___() to have a validation to prevent inserting more
--  140123           than 20 characters for the REQUISITIONER_CODE in REQUISITION_HEADER for any transaction.
--  120511  JeLise   Replaced all calls to Module_Translate_Attr_Util_API with calls to Basic_Data_Translation_API
--  120511           in Modify__, Delete___, Insert_Or_Update__ and in the view. 
--  100429  Ajpelk   Merge rose method documentation
-- ----------------------------Eagle------------------------------------------
--  070910  ChBalk Modified method Insert_Or_Update__ to update all the values in a record. 
--  ---------------------------- 13.4.0 -------------------------------------
--  041026  HaPulk Moved methods Modify_Translation from Update___ to Modify__ and
--  041026         removed method Insert_Lu_Translation from Insert___.
--  041018  HaPulk Moved restriction from Insert___ to method New__.
--  041018  HaPulk Added new method Check_Update_From_Client___.
--  040929  HaPulk Renamed Insert_Lu_Data_Rec__ as Insert_Or_Update__ and changed the logic.
--  040303  SaNalk Removed SUBSTRB.
--  040223  SaNalk Removed SUBSTRB.
--  ----------------------------- 13.3.0 --------------------------------------
--  020116  DAMASE IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  011204  CaSt  Added a number of validations.
--  000925  JOHESE  Added undefines.
--  990422  JOHW  General performance improvements.
--  990415  JOHW  Upgraded to performance optimized template.
--  971121  TOOS  Upgrade to F1 2.0
--  970313  CHAN  Changed table name: mpccom_defaults_tab is replace by mpccom_default_tab
--  961209  JOKE  Modified to workbench default template and removed the
--                get_mpccom_defaults_tab procedures and added Get_Char_Value,
--                Get_Date_Value, Get_Number_Value functions instead.
--  961002  JOHNI Removed to_char-functions in definition of objversion.
--  960703  AnAr  Fixed flags on Note_Text.
--  960617  JOKE  Added in unpack_check_update, update that Last_activity_date
--                is assigned sysdate.
--  960517  AnAr  Added purpose comment to file.
--  960425  MPC5  Spec 96-0002 LONG-fields is replaced by VARCHAR2(2000).
--  960301  JOED  Created
--  970226  MAGN  Uses column rowversion as objversion(timestamp)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Update_From_Client___
--   This method check whether update is done by client window.
PROCEDURE Check_Update_From_Client___ (
   oldrec_ IN MPCCOM_DEFAULTS_TAB%ROWTYPE,
   newrec_ IN MPCCOM_DEFAULTS_TAB%ROWTYPE )
IS
BEGIN
   IF oldrec_.create_date <> newrec_.create_date THEN
      Error_SYS.Item_Update(lu_name_, 'CREATE_DATE');
   ELSIF oldrec_.note_text <> newrec_.note_text THEN
      Error_SYS.Item_Update(lu_name_, 'NOTE_TEXT');
   ELSIF oldrec_.data_type <> newrec_.data_type THEN
      Error_SYS.Item_Update(lu_name_, 'DATA_TYPE');
   END IF;
END Check_Update_From_Client___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     MPCCOM_DEFAULTS_TAB%ROWTYPE,
   newrec_     IN OUT MPCCOM_DEFAULTS_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.last_activity_date := trunc(sysdate);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Client_SYS.Add_To_Attr('LAST_ACTIVITY_DATE', newrec_.last_activity_date, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Check_Update___ (
   oldrec_                   IN     mpccom_defaults_tab%ROWTYPE,
   newrec_                   IN OUT mpccom_defaults_tab%ROWTYPE,
   indrec_                   IN OUT Indicator_Rec,
   attr_                     IN OUT VARCHAR2,
   check_update_from_client_ IN     BOOLEAN DEFAULT TRUE )
IS
   name_             VARCHAR2(30);
   value_            VARCHAR2(4000);
   c_                NUMBER;

BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'TABLE_NAME', newrec_.table_name);
   IF (newrec_.data_type = 'CHAR' AND
       newrec_.char_value IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'CHARVALUE: Character value must have a value');
   ELSIF (newrec_.data_type = 'NUMBER' AND
       newrec_.number_value IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NUMBERVALUE: Number value must have a value');
   ELSIF (newrec_.data_type = 'DATE' AND
       newrec_.date_value IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'DATEVALUE: Date value must have a value');
   END IF; 
   IF (oldrec_.char_value != newrec_.char_value) THEN
      IF ((indrec_.char_value) AND (newrec_.table_name = 'REQUISITION_HEADER') AND (newrec_.column_name = 'REQUISITIONER_CODE') AND
          (LENGTH(newrec_.char_value) > 20)) THEN
         Error_SYS.Record_General(lu_name_, 'EXCEEDLENGTH: Character value for REQUISITIONER_CODE cannot exceed 20 characters.');
      END IF;

      IF (newrec_.table_name = 'OPERATION_BLOCK') AND (newrec_.column_name = 'OPERATION_BLOCK_ID_PREFIX') THEN
         IF (LENGTH(newrec_.char_value) > 1) THEN
            Error_SYS.Record_General(lu_name_, 'OP_BLOCK_LEN: Only one character is allowed for OPERATION_BLOCK_ID_PREFIX.');
         ELSE
            c_ := ASCII(newrec_.char_value);
            IF (c_ >= ASCII('0') AND c_ <= ASCII('9')) THEN
               Error_SYS.Record_General(lu_name_, 'OP_BLOCK_VAL: A numeric value is not allowed for OPERATION_BLOCK_ID_PREFIX.');
            END IF;
         END IF;
      END IF;
   END IF;

   IF check_update_from_client_ THEN   
      Check_Update_From_Client___(oldrec_, newrec_);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
-- Insert_Basic_Data__
--   Handles component translations
PROCEDURE Insert_Lu_Data_Rec__(
   rec_ IN MPCCOM_DEFAULTS_TAB%ROWTYPE )
IS
   dummy_        NUMBER;
   key_          VARCHAR2(2000);
   newrec_       MPCCOM_DEFAULTS_TAB%ROWTYPE;
   
   CURSOR Exist IS
      SELECT 1
      FROM MPCCOM_DEFAULTS_TAB
      WHERE transaction = rec_.transaction
      AND table_name = rec_.table_name
      AND column_name = rec_.column_name;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF ( Exist%NOTFOUND ) THEN
      newrec_ := rec_;
      new___(newrec_);
      key_ := rec_.transaction || '^' || rec_.table_name || '^' || rec_.column_name;
      Basic_Data_Translation_API.Insert_Prog_Translation('MPCCOM',
                                                         'MpccomDefaults',
                                                         key_,
                                                         rec_.note_text);
   END IF;
   CLOSE Exist;
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


