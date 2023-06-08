-----------------------------------------------------------------------------
--
--  Logical unit: DataSubjectConsentOper
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171221  Piwrpl  Created, LCS 139441, GDPR implemented 
--  181119  thjilk  Bug 145282, Removed method Get_Erased_Categories
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Consent_Action (
   operation_date_  IN OUT DATE,
   data_key_ref_    IN VARCHAR2,
   data_subject_    IN VARCHAR2,
   update_date_     IN DATE,
   action_          IN VARCHAR2,
   remark_          IN VARCHAR2)
IS
   newrec_       DATA_SUBJECT_CONSENT_OPER_TAB%ROWTYPE;
BEGIN
   IF NOT Data_Subject_Consent_API.Exists(data_key_ref_) THEN
      Data_Subject_Consent_API.New(data_key_ref_, data_subject_);
   END IF;
   newrec_.key_ref := data_key_ref_;
   IF operation_date_ IS NULL THEN
      operation_date_ := sysdate;
   END IF;
   newrec_.operation_date := operation_date_;
   newrec_.update_date := update_date_;
   newrec_.action := action_;
   newrec_.remark := remark_;
   newrec_.performed_by := Fnd_Session_API.Get_Fnd_User;
   New___(newrec_);
END Consent_Action;

PROCEDURE Erase_Action (   
   key_ref_         IN VARCHAR2,
   operation_date_  IN DATE,
   update_date_     IN DATE)
IS
   data_subject_ DATA_SUBJECT_CONSENT_TAB.data_subject%TYPE;
   newrec_       DATA_SUBJECT_CONSENT_OPER_TAB%ROWTYPE;
   TYPE temp_process_purpose_ IS TABLE OF VARCHAR2(200)
                 INDEX BY BINARY_INTEGER;   
   temp_process_purpose_tab_ temp_process_purpose_;   
   CURSOR get_purpose_erase IS
   SELECT process_purpose_id
   FROM data_subject_consent_purp_tab dsp
   WHERE dsp.key_ref = key_ref_
   AND (dsp.valid = 'FALSE' OR (trunc(sysdate) NOT BETWEEN NVL(dsp.effective_on, Database_Sys.Get_First_Calendar_Date()) AND NVL(dsp.effective_until, Database_Sys.Get_Last_Calendar_Date())))
   AND dsp.operation_date = (SELECT MAX(operation_date) 
                             FROM   data_subject_consent_oper_tab x
                             WHERE  x.key_ref = dsp.key_ref
                             AND    x.action != Data_Sub_Consent_Action_API.DB_DATA_ERASED);
BEGIN
   data_subject_ := Data_Subject_Consent_API.Get_Data_Subject_Db(key_ref_);
   IF update_date_ <= trunc(sysdate) THEN
      OPEN get_purpose_erase;
      FETCH get_purpose_erase BULK COLLECT INTO temp_process_purpose_tab_;
      IF (temp_process_purpose_tab_.count > 0 OR Pers_Data_Man_Proc_Purpose_API.Any_Not_Connected_Data_Exists(data_subject_) = 'TRUE') THEN
         newrec_.key_ref := key_ref_;
         newrec_.operation_date := operation_date_;
         newrec_.update_date := update_date_;
         newrec_.action := Data_Sub_Consent_Action_API.DB_DATA_ERASED;
         newrec_.performed_by := Fnd_Session_API.Get_Fnd_User;
         New___(newrec_);
         Personal_Data_Man_Util_API.Execute_Data_Subject_Cleanup(key_ref_, data_subject_, operation_date_);
         IF temp_process_purpose_tab_.count > 0 THEN
            FOR i_ IN temp_process_purpose_tab_.FIRST..temp_process_purpose_tab_.LAST LOOP
                  Data_Subject_Consent_Purp_API.Consent_Action_Purpose(key_ref_, operation_date_, Data_Sub_Consent_Action_API.DB_DATA_ERASED, temp_process_purpose_tab_(i_), 'TRUE', NULL, NULL);
            END LOOP;
         END IF;
      END IF;
      CLOSE get_purpose_erase;
   END IF;
END Erase_Action;

PROCEDURE Erase_Action_Check_Log (
   erased_categories_ IN OUT VARCHAR2,
   key_ref_           IN     VARCHAR2,
   operation_date_    IN     DATE,
   statement_date_    IN     DATE )
IS
   CURSOR find_erased_categories IS
      SELECT DISTINCT pers_data_management_id
        FROM PERSONAL_DATA_CLEANUP_LOG_TAB
       WHERE key_ref = key_ref_
         AND operation_date = operation_date_
         AND action = 'DATA_ERASED';
   personal_data_      VARCHAR2(2000);
BEGIN
   Erase_Action(key_ref_,operation_date_,statement_date_);
   
   erased_categories_ := NULL;
   FOR rec_ IN find_erased_categories LOOP
      personal_data_ := Personal_Data_Management_API.Get_Personal_Data(rec_.pers_data_management_id);
      IF erased_categories_ IS NOT NULL THEN
         erased_categories_ := erased_categories_ || ', ' || personal_data_;
      ELSE
         erased_categories_ := personal_data_;
      END IF;
   END LOOP;
END Erase_Action_Check_Log;

PROCEDURE No_Consent_With_Erase_Action (
   key_ref_         IN VARCHAR2,
   data_subject_    IN VARCHAR2,
   update_date_     IN DATE,
   remark_          IN VARCHAR2)
IS
   temp_operation_date_ DATE;
   CURSOR get_purposes IS
   SELECT DISTINCT purpose_id
   FROM pers_data_man_proc_purpose_tab
   WHERE data_subject = data_subject_;   
BEGIN
   temp_operation_date_ := sysdate;
   Consent_Action(temp_operation_date_, key_ref_, data_subject_, update_date_, Data_Sub_Consent_Action_API.DB_PURPOSES_WITHDRAWN, remark_);
   FOR rec IN get_purposes LOOP
      Data_Subject_Consent_Purp_API.Consent_Action_Purpose(key_ref_, temp_operation_date_, Data_Sub_Consent_Action_API.DB_PURPOSES_WITHDRAWN, rec.purpose_id, 'FALSE', NULL, NULL);
   END LOOP;
   Erase_Action(key_ref_, temp_operation_date_, update_date_);
END No_Consent_With_Erase_Action;

@UncheckedAccess
FUNCTION Is_Last_Update_Action (
   key_ref_        IN VARCHAR2,
   operation_date_ IN DATE,
   action_         IN VARCHAR2) RETURN VARCHAR2
IS
   tmp_ NUMBER;
   CURSOR check_last IS
   SELECT 1
   FROM data_subject_consent_oper_tab
   WHERE key_ref = key_ref_
   AND operation_date > operation_date_
   AND action != Data_Sub_Consent_Action_API.DB_DATA_ERASED;
BEGIN
   IF action_ = Data_Sub_Consent_Action_API.DB_DATA_ERASED THEN
      RETURN 'FALSE';
   ELSE
      OPEN check_last;
      FETCH check_last INTO tmp_;
      IF check_last%FOUND THEN
         CLOSE check_last;
         RETURN 'FALSE';
      ELSE
         CLOSE check_last;
         RETURN 'TRUE';
      END IF;
   END IF;
END Is_Last_Update_Action;