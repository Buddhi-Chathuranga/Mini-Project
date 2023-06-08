-----------------------------------------------------------------------------
--
--  Logical unit: ReportRuleLog
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140219  ASIWLK  TEREPORT-1128 public PLSQL interface for Report Rule Log.
--  161025  ASIWLK Automatically remove RRE logs TEREPORT-2235
--  191007  PABNLK  TSMI-37: 'Clear_All' public method implemented.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
PROCEDURE Log(
   message_      IN VARCHAR2,
   message_type_ IN VARCHAR2,
   print_job_id_ IN NUMBER) 
  IS
  attr_ VARCHAR2(32000);
  info_        VARCHAR2(100);
  objid_       VARCHAR2(100);
  objversion_  VARCHAR2(100);
  get_log_id_  NUMBER;
  BEGIN
      Get_Log_Id___ (get_log_id_);
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('LOG_ID',get_log_id_, attr_);
      Client_SYS.Add_To_Attr('EXECUTED', SYSDATE, attr_);
      Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, attr_);
      Client_SYS.Add_To_Attr('MESSAGE', message_, attr_);
      Client_SYS.Add_To_Attr('MESSAGE_TYPE', message_type_, attr_);

      New__(info_,objid_,objversion_,attr_,'DO');
  END Log;
  
  PROCEDURE Clear_All__
  IS
  BEGIN
      DELETE FROM report_rule_log_tab;
   -- the method should not give any error.
  EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END Clear_All__;
   
PROCEDURE Remove_Expired_Logs__ 
   IS
      days_to_keep_  NUMBER;
      time_stamp_    DATE;

      TYPE log_id_type IS TABLE OF report_rule_log_tab.log_id%TYPE;
      log_ids_    log_id_type;
   
      CURSOR get_table_recs IS
      SELECT t.log_id
      FROM report_rule_log_tab t
      WHERE t.rowversion < time_stamp_;
   
   BEGIN
   
    days_to_keep_:= to_number(fnd_setting_api.Get_Value('REP_RULE_LOG_AGE'));
    time_stamp_ := SYSDATE - days_to_keep_;

    OPEN get_table_recs;
    LOOP
     FETCH get_table_recs BULK COLLECT INTO log_ids_ LIMIT 1000; 
         FORALL i_ IN 1..log_ids_.count
            DELETE
            FROM report_rule_log_tab
            WHERE log_id = log_ids_(i_);
         EXIT WHEN get_table_recs%NOTFOUND;
    END LOOP;
    @ApproveTransactionStatement(2016-10-24,asiwlk)
    COMMIT;
    CLOSE get_table_recs;
    EXCEPTION
    WHEN OTHERS
    THEN
      Log('EXCEPTION When Removing Expired Logs'||SQLCODE||' -ERROR- '||SQLERRM ,'SYSTEM',0);

 END Remove_Expired_Logs__;
 
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Get_Log_Id___ (
   get_log_id_ OUT NUMBER )
IS
BEGIN
   SELECT REPORT_RULE_LOG_SEQ.nextval
      INTO get_log_id_
      FROM dual;
END Get_Log_Id___;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Clear_All
IS
BEGIN
   Clear_All__;
END Clear_All;
