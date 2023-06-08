-----------------------------------------------------------------------------
--
--  Logical unit: QuickReportLog
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140219  MABALK  Created.
--  071120  MABALK  Removed multibyte characters from the SQL statement before truncating at 4000 characters.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------ 
@UncheckedAccess
FUNCTION Get_Title (
   log_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   FUNCTION Base (
      log_id_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      temp_ VARCHAR2(50);
      quick_report_id_ VARCHAR2(20);
   BEGIN
      IF (log_id_ IS NULL) THEN
         RETURN NULL;
      END IF;
      SELECT quick_report_id
         INTO  quick_report_id_
         FROM  quick_report_log_tab
         WHERE log_id = log_id_;
      IF (regexp_like(trim(quick_report_id_), '^[[:digit:]]')) THEN
         SELECT description
            INTO  temp_
            FROM  quick_report_tab
            WHERE quick_report_id = to_number(quick_report_id_);
      ELSE
         SELECT title
            INTO  temp_
            FROM  user_quick_report_tab
            WHERE report_id = quick_report_id_;
      END IF;

      RETURN temp_;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(quick_report_id_, 'Get_Description');
   END Base;

BEGIN
   RETURN Base(log_id_);
END Get_Title;

@UncheckedAccess
FUNCTION Get_Type (
   log_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   FUNCTION Base (
      log_id_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      temp_ quick_report_tab.qr_type%TYPE;
      quick_report_id_ VARCHAR2(20);      
   BEGIN
      IF (log_id_ IS NULL) THEN
         RETURN NULL;
      END IF;
      SELECT quick_report_id
         INTO  quick_report_id_
         FROM  quick_report_log_tab
         WHERE log_id = log_id_;
      IF (regexp_like(trim(quick_report_id_), '^[[:digit:]]')) THEN
         SELECT qr_type
            INTO  temp_
            FROM  quick_report_tab
            WHERE quick_report_id = to_number(quick_report_id_);
         RETURN Quick_Report_Type_API.Decode(temp_);
      ELSE
        RETURN NULL;
      END IF;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(quick_report_id_, 'Get_Qr_Type');
   END Base;

BEGIN
   RETURN Base(log_id_);
END Get_Type;

PROCEDURE Log(
   quick_report_id_ IN VARCHAR2,
   execution_time_  IN NUMBER,
   status_          IN VARCHAR2,
   notes_           IN VARCHAR2)
IS
   attr_        VARCHAR2(32000);
   info_        VARCHAR2(100);
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(100);
   get_log_id_  NUMBER;
BEGIN
   IF (Log_Is_Enabled___) THEN 
      Get_Log_Id___ (get_log_id_);
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('LOG_ID', get_log_id_, attr_);
      Client_SYS.Add_To_Attr('EXECUTED', SYSDATE, attr_);
      Client_SYS.Add_To_Attr('QUICK_REPORT_ID', quick_report_id_, attr_);
      Client_SYS.Add_To_Attr('USER_NAME', Fnd_Session_API.Get_Fnd_User, attr_);
      Client_SYS.Add_To_Attr('EXECUTION_TIME', execution_time_, attr_); -- Time in milliseconds
      Client_SYS.Add_To_Attr('STATUS', status_, attr_);
      Client_SYS.Add_To_Attr('NOTES', SUBSTR(REGEXP_REPLACE(notes_, '[^\r -~]', ''), 1, 4000), attr_);

      New__(info_, objid_, objversion_, attr_, 'DO');
   END IF;      
END Log;
  
PROCEDURE Clear_All__
IS
BEGIN
   DELETE FROM quick_report_log_tab;
   -- the method should not give any error.
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
END Clear_All__;
   
PROCEDURE Remove_Expired_Logs__ 
IS
   days_to_keep_  NUMBER;
   time_stamp_    DATE;

   TYPE log_id_type IS TABLE OF quick_report_log_tab.log_id%TYPE;
   log_ids_    log_id_type;

   CURSOR get_table_recs IS
   SELECT t.log_id
   FROM quick_report_log_tab t
   WHERE t.rowversion < time_stamp_;
BEGIN
   days_to_keep_:= to_number(fnd_setting_api.Get_Value('QUICK_REP_LOG_AGE'));
   time_stamp_ := SYSDATE - days_to_keep_;

   OPEN get_table_recs;
   LOOP
      FETCH get_table_recs BULK COLLECT INTO log_ids_ LIMIT 1000; 
      FORALL i_ IN 1..log_ids_.count
         DELETE
         FROM quick_report_log_tab
         WHERE log_id = log_ids_(i_);
      EXIT WHEN get_table_recs%NOTFOUND;
   END LOOP;
   @ApproveTransactionStatement(2018-11-24, mabalk)
   COMMIT;
   CLOSE get_table_recs;
   EXCEPTION
   WHEN OTHERS
   THEN
   Log(0, 0, 'FAIL', 'EXCEPTION When Removing Expired Logs'||SQLCODE||' -ERROR- '||SQLERRM);
END Remove_Expired_Logs__;
 
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Get_Log_Id___ (
   get_log_id_ OUT NUMBER )
IS
BEGIN
   SELECT QUICK_REPORT_LOG_SEQ.nextval
      INTO get_log_id_
      FROM dual;
END Get_Log_Id___;

FUNCTION Log_Is_Enabled___ RETURN BOOLEAN
IS
BEGIN 
      IF ('OFF' = fnd_setting_api.Get_Value('QUICK_REP_LOG')) THEN
        RETURN FALSE;
      END IF;
   RETURN TRUE;    
END Log_Is_Enabled___;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
