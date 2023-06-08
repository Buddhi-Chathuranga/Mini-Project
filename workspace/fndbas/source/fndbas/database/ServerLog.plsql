-----------------------------------------------------------------------------
--
--  Logical unit: ServerLog
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191121  PABNLK  PACCFW-234: 'Mark_Log_Checked' and 'Mark_Log_Unchecked' public methods added.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

SUBTYPE Log_Rec IS SERVER_LOG_TAB%ROWTYPE;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Session_Info___ (
   rec_ IN SERVER_LOG_TAB%ROWTYPE ) RETURN SERVER_LOG_TAB%ROWTYPE
IS
   job_           NUMBER;
   newrec_        SERVER_LOG_TAB%ROWTYPE;
--
   CURSOR get_session_info IS
SELECT s.username, s.osuser, s.machine, s.program,
       Sys_Context('USERENV', 'IP_ADDRESS') IPAddress,
       Sys_Context('USERENV', 'AUTHENTICATION_METHOD') Authentication_Type,
       Sys_Context('USERENV', 'BG_JOB_ID') Background_Job_Id
FROM   sys.v_$session s
WHERE  s.audsid = Userenv('SESSIONID');
--
   CURSOR get_job IS
SELECT Substr(Batch_SYS.Get_Action_(Batch_SYS.Get_Job_Id_(job_name)), 1, 1000) background_job
FROM   user_scheduler_jobs
WHERE  Batch_SYS.Get_Job_Id_(job_name) = job_;
--
BEGIN
   newrec_ := rec_;
   newrec_.identity    := Fnd_Session_API.Get_Fnd_User;
   newrec_.date_created:= SYSDATE;
   --
   OPEN  get_session_info;
   FETCH get_session_info
      INTO newrec_.oracle_user, newrec_.os_identity, newrec_.machine, newrec_.program,
           newrec_.ipaddress, newrec_.auth_type, newrec_.job_id;
   CLOSE get_session_info;
   IF (newrec_.job_id IS NOT NULL) THEN
      job_ := newrec_.job_id;
      OPEN  get_job;
      FETCH get_job INTO newrec_.job;
      CLOSE get_job;
   END IF;
   RETURN newrec_;
END Get_Session_Info___;


FUNCTION Log___ (
   rec_           IN SERVER_LOG_TAB%ROWTYPE ) RETURN SERVER_LOG_TAB%ROWTYPE
IS
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(100);
   attr_          VARCHAR2(1000);
   newrec_        SERVER_LOG_TAB%ROWTYPE;
   
BEGIN
   newrec_ := rec_;  
   newrec_ := Get_Session_Info___(rec_);
   Insert___ (objid_, objversion_, newrec_, attr_);
   RETURN newrec_;
END Log___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SERVER_LOG_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.log_id  := SERVER_LOG_ID_SEQ.NEXTVAL;
   newrec_.checked := Fnd_Boolean_API.DB_FALSE;
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('LOG_ID', newrec_.log_id, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Mark_Checked__ (
   attr_   OUT VARCHAR2,
   log_id_ IN  NUMBER )
IS
   date_checked_ DATE         := SYSDATE;
   checked_by_   VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   checked_db_   VARCHAR2(20) := 'TRUE';
BEGIN
   UPDATE SERVER_LOG_TAB 
   SET date_checked = date_checked_,
       checked_by   = checked_by_,
       checked      = checked_db_
   WHERE log_id     = log_id_;
   Client_SYS.Add_To_Attr('CHECKED_DB',   checked_db_,   attr_);
   Client_SYS.Add_To_Attr('CHECKED',      Fnd_Boolean_API.Decode(checked_db_),   attr_);
   Client_SYS.Add_To_Attr('DATE_CHECKED', date_checked_, attr_);
   Client_SYS.Add_To_Attr('CHECKED_BY',   checked_by_,   attr_);
END Mark_Checked__;


PROCEDURE Mark_Unchecked__ (
   attr_   OUT VARCHAR2,
   log_id_ IN  NUMBER )
IS
   date_checked_ DATE         := NULL;
   checked_by_   VARCHAR2(30) := NULL;
   checked_db_   VARCHAR2(20) := 'FALSE';
BEGIN
   UPDATE SERVER_LOG_TAB 
   SET date_checked = date_checked_,
       checked_by   = checked_by_,
       checked      = checked_db_
   WHERE log_id     = log_id_;
   Client_SYS.Add_To_Attr('CHECKED_DB',   checked_db_,   attr_);
   Client_SYS.Add_To_Attr('CHECKED',      Fnd_Boolean_API.Decode(checked_db_),   attr_);
   Client_SYS.Add_To_Attr('DATE_CHECKED', date_checked_, attr_);
   Client_SYS.Add_To_Attr('CHECKED_BY',   checked_by_,   attr_);
END Mark_Unchecked__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Log_Server_Error_ (
   sql_text_ IN VARCHAR2 )
IS
   log_id_          NUMBER;
BEGIN
   log_id_ := Log(NULL, 'Server Errors', Dbms_Utility.Format_Error_Stack, sql_text_); 
END Log_Server_Error_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Log (
   parent_log_id_ IN NUMBER,
   category_id_   IN VARCHAR2,
   text1_         IN VARCHAR2,
   text2_         IN VARCHAR2 ) RETURN NUMBER
IS
   rec_           SERVER_LOG_TAB%ROWTYPE;
   category_      Server_Log_Category_API.public_rec;
BEGIN
   Server_Log_Category_API.Exist(category_id_);
   category_ := Server_Log_Category_API.Get(category_id_);
   IF Nvl(category_.enable, 'FALSE') = 'TRUE' THEN
      IF parent_log_id_ IS NOT NULL THEN
         Server_Log_API.Exist(parent_log_id_);
      END IF;
      rec_.parent_log_id := parent_log_id_;
      rec_.category_id   := category_id_;
      rec_.text1         := text1_;
      rec_.text2         := text2_;
      rec_ := Log___(rec_);
   END IF;
   RETURN rec_.log_id;
END Log;


FUNCTION Log_Autonomous (
   parent_log_id_ IN NUMBER,
   category_id_   IN VARCHAR2,
   text1_         IN VARCHAR2,
   text2_         IN VARCHAR2 ) RETURN NUMBER
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   log_id_ NUMBER;
BEGIN
   log_id_ := Log(parent_log_id_, category_id_, text1_, text2_);
   @ApproveTransactionStatement(2013-10-30,haarse)
   COMMIT;
   RETURN log_id_;
END Log_Autonomous;

PROCEDURE Log_Ddl_Audit (
   rec_ IN SERVER_LOG_TAB%ROWTYPE )
IS
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(100);
   attr_          VARCHAR2(1000);
   newrec_        SERVER_LOG_TAB%ROWTYPE;
BEGIN
   Server_Log_Category_API.Exist(rec_.category_id);
   newrec_ := rec_;
   Insert___ (objid_, objversion_, newrec_, attr_);
      
END Log_Ddl_Audit;


PROCEDURE Mark_Log_Checked (
   log_id_ IN NUMBER )
IS
   attr_ VARCHAR2(2000);
BEGIN
   Mark_Checked__(attr_, log_id_);
END Mark_Log_Checked;


PROCEDURE Mark_Log_Unchecked (
   log_id_ IN NUMBER )
IS
   attr_ VARCHAR2(2000);
BEGIN
   Mark_Unchecked__(attr_, log_id_);
END Mark_Log_Unchecked;
