-----------------------------------------------------------------------------
--
--  Logical unit: ExternalBatchLoadFile
--  Component:    ACCRUL
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210713  Nudilk  FI21R2-1900, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@IgnoreUnitTest DMLOperation
PROCEDURE Insert_Log_Record___(
   import_message_id_ IN NUMBER,
   log_message_       IN VARCHAR2)
IS
   log_rec_    ext_batch_load_file_log_tab%ROWTYPE;
BEGIN
   log_rec_.import_message_id := import_message_id_;
   log_rec_.log               := SUBSTR(log_message_,1,4000);
   Ext_Batch_Load_File_Log_API.Insert_Record(log_rec_);
END Insert_Log_Record___;

@IgnoreUnitTest DMLOperation
PROCEDURE Log_State_Change___(
   import_message_id_ IN NUMBER,
   state_             IN VARCHAR2)
IS
   log_message_   VARCHAR2(4000);
   state_cl_      VARCHAR2(200):=  Ext_Batch_File_Load_State_API.Decode(state_);
BEGIN
   
   log_message_ := Language_SYS.Translate_Constant(lu_name_, 'LOGUPDSTATE: Loaded batch file status changed to :P1.', NULL, state_cl_);
   Insert_Log_Record___(import_message_id_, log_message_);
END Log_State_Change___;

@IgnoreUnitTest DMLOperation
PROCEDURE Update_State___ (
   message_id_   IN NUMBER,
   state_        IN VARCHAR2)
IS
BEGIN
   UPDATE external_batch_load_file_tab
      SET state = state_
   WHERE import_message_id = message_id_;   
   Log_State_Change___(message_id_, state_);
END Update_State___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Validate_External_File_Load(
   import_message_id_  OUT NUMBER,
   load_file_id_       IN  NUMBER,
   file_name_          IN  VARCHAR2)
IS
   ndummy_                 NUMBER;
   
   CURSOR get_min_app_message_id IS
   SELECT MIN(import_message_id)
      FROM external_batch_load_file_tab
     WHERE load_file_id = load_file_id_
       AND state        = Ext_Batch_File_Load_State_API.DB_TRANSFERRED
       AND file_name    = file_name_;
          
   CURSOR file_data_exist IS
   SELECT 1
      FROM external_batch_load_file_tab
     WHERE import_message_id = import_message_id_
     AND file_data IS NULL;      
BEGIN
   IF load_file_id_ IS NULL OR file_name_ IS NULL THEN
      RETURN;
   END IF;
   OPEN get_min_app_message_id;
   FETCH get_min_app_message_id INTO import_message_id_;
   CLOSE get_min_app_message_id;
   IF import_message_id_ IS NULL THEN
      Error_SYS.Appl_General(lu_name_, 'NOTRANSFERDATAEXIST: File :P1 doesnot exist in the Transferred status.', file_name_);
   ELSE
      OPEN file_data_exist;
      FETCH file_data_exist INTO ndummy_;
      CLOSE file_data_exist;
      IF NVL(ndummy_,0) > 0 THEN
         Error_SYS.Appl_General(lu_name_, 'NODATAINCLOB: No Data found in the Loaded file :P1.', file_name_);        
      END IF;
   END IF;   
END Validate_External_File_Load;

@IgnoreUnitTest DMLOperation
PROCEDURE Insert_Record(
   newrec_  IN external_batch_load_file_tab%rowtype)
IS
   newrecx_       external_batch_load_file_tab%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   attr_          VARCHAR2(4000);
   log_message_   VARCHAR2(4000);
BEGIN
   newrecx_ := newrec_;
   newrecx_.rowkey := NULL;
   Insert___ ( objid_,
               objversion_,
               newrecx_,
               attr_ );
               
   -- Insert Record to the log.
   log_message_ := Language_SYS.Translate_Constant(lu_name_, 'NEWLOGMESSAGE1: File loaded from Application Message');
   log_message_ := SUBSTR(log_message_ || ' - '|| newrec_.created_from, 1, 4000);
   Insert_Log_Record___(newrec_.import_message_id, log_message_);
   Log_State_Change___(newrec_.import_message_id, Ext_Batch_File_Load_State_API.DB_LOADED);
END Insert_Record;

@UncheckedAccess
FUNCTION Check_Matched_Row_Exist(
   load_file_id_  IN NUMBER) RETURN BOOLEAN
IS
   CURSOR get_matched_row IS
      SELECT 1
      FROM external_batch_load_file_tab
      WHERE load_file_id = load_file_id_;
   ndummy_ NUMBER;
BEGIN
   OPEN get_matched_row;
   FETCH get_matched_row INTO ndummy_;
   CLOSE get_matched_row;
   IF NVL(ndummy_,0) = 1 THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Check_Matched_Row_Exist;

@UncheckedAccess
FUNCTION Check_Matched_Message_Id(
   load_file_id_  IN NUMBER) RETURN NUMBER
IS
   CURSOR get_matched_row IS
      SELECT MAX(import_message_id)
      FROM external_batch_load_file_tab
      WHERE load_file_id = load_file_id_;
   message_id_ NUMBER;
BEGIN
   IF load_file_id_ IS NOT NULL THEN
      OPEN get_matched_row;
      FETCH get_matched_row INTO message_id_;
      CLOSE get_matched_row;
   END IF;
   RETURN NVL(message_id_,0);
END Check_Matched_Message_Id;

@UncheckedAccess
FUNCTION Batch_Load_File_Info_Exist(
   load_file_id_  IN NUMBER) RETURN VARCHAR2
IS
BEGIN
   IF Check_Matched_Row_Exist(load_file_id_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Batch_Load_File_Info_Exist;

@IgnoreUnitTest DMLOperation
PROCEDURE Update_State_Load_Id (
   load_file_id_ IN NUMBER,
   state_        IN VARCHAR2)
IS
   message_id_    NUMBER;
BEGIN
   message_id_ := Check_Matched_Message_Id(load_file_id_);
   IF NVL(message_id_, 0) > 0 THEN      
      Update_State___(message_id_, state_);
   END IF;
END Update_State_Load_Id;

@UncheckedAccess
FUNCTION Get_Matched_Message_Id(
   file_name_     IN VARCHAR2) RETURN NUMBER
IS
   message_id_ NUMBER;
   CURSOR get_matched_message_id IS
      SELECT MIN(import_message_id)
      FROM  external_batch_load_file_tab
      WHERE file_name = file_name_
      AND load_file_id IS NULL
      AND state = Ext_Batch_File_Load_State_API.DB_LOADED;
BEGIN
   IF file_name_ IS NOT NULL THEN
      OPEN get_matched_message_id;
      FETCH get_matched_message_id INTO message_id_;
      CLOSE get_matched_message_id;
   END IF;
   RETURN NVL(message_id_,0);
END Get_Matched_Message_Id;

@IgnoreUnitTest DMLOperation
PROCEDURE Set_Loadid_Matched_App_Msg_Row (
   load_file_id_  IN NUMBER,
   file_name_     IN VARCHAR2)
IS
   matched_message_id_    NUMBER;
   log_message_           VARCHAR2(4000);
BEGIN
   matched_message_id_ := Get_Matched_Message_Id(file_name_);
   IF matched_message_id_ != 0 THEN
      UPDATE external_batch_load_file_tab
         SET load_file_id = load_file_id_,
             state        = Ext_Batch_File_Load_State_API.DB_TRANSFERRED
      WHERE file_name = file_name_
      AND load_file_id IS NULL
      AND state =  Ext_Batch_File_Load_State_API.DB_LOADED
      AND import_message_id = matched_message_id_;

      log_message_ := Language_SYS.Translate_Constant(lu_name_, 'LOGUPDLOADID: Updated Load File ID to :P1.', NULL, load_file_id_);
      Insert_Log_Record___(matched_message_id_, log_message_);
      Log_State_Change___(matched_message_id_, Ext_Batch_File_Load_State_API.DB_TRANSFERRED);
   END IF;
END Set_Loadid_Matched_App_Msg_Row;

@IgnoreUnitTest DMLOperation
PROCEDURE Remove_Load_Id_Record(
   load_file_id_  IN NUMBER,
   template_id_   IN VARCHAR2)
IS
BEGIN
   IF NVL(In_Ext_File_Template_Dir_API.Get_Keep_Backup_File_Db(template_id_, File_Direction_API.Decode(File_Direction_API.DB_INPUT_FILE)),'FALSE') = 'FALSE' THEN
      Remove_Load_Id_Record(load_file_id_);
   END IF;
END Remove_Load_Id_Record;

-- Note: This method remove all records.
@IgnoreUnitTest DMLOperation
PROCEDURE Cleanup
IS
BEGIN
   DELETE FROM external_batch_load_file_tab;
   Ext_Batch_Load_File_Log_API.Cleanup;
END Cleanup;

@IgnoreUnitTest DMLOperation
PROCEDURE Remove_Load_Id_Record(
   load_file_id_ IN NUMBER)
IS
   CURSOR get_row IS
      SELECT import_message_id
      FROM external_batch_load_file_tab
      WHERE load_file_id = load_file_id_;     
   
   info_             VARCHAR2(2000);
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
BEGIN
   FOR rec_ IN get_row LOOP
      Get_Id_Version_By_Keys___ (objid_, objversion_, rec_.import_message_id);
      Remove__(info_, objid_, objversion_, 'DO');
   END LOOP;
END Remove_Load_Id_Record;

@IgnoreUnitTest DMLOperation
PROCEDURE Remove_Records_No_Load_Id
IS
   CURSOR get_row IS
      SELECT import_message_id
      FROM external_batch_load_file_tab
      WHERE load_file_id IS NULL;
   
   info_             VARCHAR2(2000);
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
BEGIN
   FOR rec_ IN get_row LOOP
      Get_Id_Version_By_Keys___ (objid_, objversion_, rec_.import_message_id);
      Remove__(info_, objid_, objversion_, 'DO');
   END LOOP;
END Remove_Records_No_Load_Id;