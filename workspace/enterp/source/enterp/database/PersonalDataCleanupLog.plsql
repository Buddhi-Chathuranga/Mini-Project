-----------------------------------------------------------------------------
--
--  Logical unit: PersonalDataCleanupLog
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171221  Piwrpl  Created, LCS 139441, GDPR implemented 
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
   Client_SYS.Add_To_Attr('SEQ_NO', Get_Next_Pers_Clean_Seq_id___(), attr_);   
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Get_Next_Pers_Clean_Seq_id___ RETURN NUMBER
IS
   personal_data_clean_log_seq_  NUMBER;
BEGIN   
   SELECT personal_data_clean_log_seq.NEXTVAL INTO personal_data_clean_log_seq_ FROM dual;
   RETURN personal_data_clean_log_seq_;
END Get_Next_Pers_Clean_Seq_id___;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Data_Cleanup_Error (
   key_ref_        IN VARCHAR2,
   operation_date_ IN DATE,
   action_db_      IN VARCHAR2) RETURN VARCHAR2
IS
   errors_found_ VARCHAR2(5) := 'FALSE';
   temp_ NUMBER;
   CURSOR get_not_completed IS
      SELECT 1
      FROM  personal_data_cleanup_log_tab
      WHERE key_ref = key_ref_
      AND   operation_date = operation_date_
      AND   action = action_db_
      AND   completed = 'FALSE';
BEGIN
   IF (action_db_ = Data_Sub_Consent_Action_API.DB_DATA_ERASED) THEN
      OPEN get_not_completed;
      FETCH get_not_completed INTO temp_;
      IF get_not_completed%FOUND THEN
         errors_found_ := 'TRUE';
      END IF;
      CLOSE get_not_completed;
   END IF;
   RETURN errors_found_;
END Data_Cleanup_Error;      
      
PROCEDURE New_Log_Entry (
   key_ref_                 IN VARCHAR2,
   operation_date_          IN DATE,
   action_                  IN VARCHAR2,
   pers_data_management_id_ IN NUMBER,
   completed_               IN VARCHAR2,
   error_message_           IN VARCHAR2)
IS
   newrec_ personal_data_cleanup_log_tab%ROWTYPE;
BEGIN
   newrec_.key_ref := key_ref_;
   newrec_.operation_date := operation_date_;
   newrec_.action := action_;
   newrec_.pers_data_management_id := pers_data_management_id_;
   newrec_.seq_no := Get_Next_Pers_Clean_Seq_id___();
   newrec_.completed := completed_;
   newrec_.error_message := error_message_;
   New___(newrec_);
END New_Log_Entry;

