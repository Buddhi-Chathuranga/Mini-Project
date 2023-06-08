-----------------------------------------------------------------------------
--
--  Logical unit: SecCheckpointLog
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  071105  PEMASE  Added User Comments to Log__ (Bug#68906, Project 7.5+).
--                  Also removed edit capabilities by making edit methods
--                  server only. The log is only intended to be possible to
--                  purge using Cleanup__
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
   Client_SYS.Add_To_Attr('TRANSACTION_DATE', SYSDATE, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SEC_CHECKPOINT_LOG_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   log_id_ NUMBER;
BEGIN
   -- Get next log_id from sequence
   SELECT sec_checkpoint_log_seq.NEXTVAL
   INTO log_id_
   FROM dual;
   newrec_.log_id := log_id_;
   newrec_.transaction_date := Nvl(newrec_.transaction_date, SYSDATE);
   newrec_.username := Nvl(newrec_.username, Fnd_Session_API.Get_Fnd_User);
   --
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('LOG_ID', newrec_.log_id, attr_);
   Client_SYS.Add_To_Attr('TRANSACTION_DATE', newrec_.transaction_date, attr_);
   Client_SYS.Add_To_Attr('USERNAME', newrec_.username, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sec_checkpoint_log_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   newrec_.transaction_date := SYSDATE;
   newrec_.username := Fnd_Session_API.Get_Fnd_User;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Cleanup__ 
IS
   cleanup_days_ NUMBER := to_number(Fnd_Setting_API.Get_Value('KEEP_CHECKPOINT'));
BEGIN
   -- Set cleanup_days to eternity if zero so no records will be removed.
   IF nvl(cleanup_days_, 0) = 0 THEN
      cleanup_days_ := 99999;
   END IF;
   DELETE FROM sec_checkpoint_log_tab
      WHERE transaction_date < SYSDATE - cleanup_days_;
END Cleanup__;


PROCEDURE Log__ (
   log_id_  OUT NUMBER,
   gate_id_ IN VARCHAR2,
   param_msg_ IN VARCHAR2,
   user_comment_ IN VARCHAR2,
   fnd_user_ IN VARCHAR2)
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   newrec_     SEC_CHECKPOINT_LOG_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   newrec_.gate_id := gate_id_;
   -- Construct the message
   newrec_.message := Sec_Checkpoint_Gate_API.Create_Message__(gate_id_, param_msg_);
   newrec_.user_comment := user_comment_;
   newrec_.username := fnd_user_;
   Insert___ (objid_, objversion_, newrec_, attr_);
   log_id_ := Client_SYS.Get_Item_Value('LOG_ID', attr_);
END Log__;


PROCEDURE Log_Error__ (
   log_id_  OUT NUMBER,
   gate_id_ IN VARCHAR2,
   user_comment_ IN VARCHAR2,
   fnd_user_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   newrec_     SEC_CHECKPOINT_LOG_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   newrec_.gate_id := gate_id_;
   -- Construct the message
   newrec_.message := user_comment_;
   newrec_.user_comment := user_comment_;
   newrec_.username := fnd_user_;
   Insert___ (objid_, objversion_, newrec_, attr_);
   log_id_ := Client_SYS.Get_Item_Value('LOG_ID', attr_);
END Log_Error__;

PROCEDURE Log_Error_Batch__ (
   -- this is for logging failed legacy checkpoints
   gate_id_ IN VARCHAR2,
   message_ IN VARCHAR2,
   user_comment_ IN VARCHAR2,
   fnd_user_ IN VARCHAR2)
IS
   log_id_  NUMBER;
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   newrec_     SEC_CHECKPOINT_LOG_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   IF (Is_Checkpoint_Active__(gate_id_)) THEN
      newrec_.gate_id := gate_id_;
      newrec_.message := message_;
      newrec_.username := fnd_user_;
      newrec_.user_comment := user_comment_;
      Insert___ (objid_, objversion_, newrec_, attr_);
      log_id_ := Client_SYS.Get_Item_Value('LOG_ID', attr_);
      @ApproveTransactionStatement(2019-11-29,taorse)
      COMMIT;
   END IF;
END Log_Error_Batch__;

FUNCTION Is_Checkpoint_Active__ (
   gate_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
      is_active_ VARCHAR2(10);
   
   CURSOR get_active_status IS
   SELECT active
   FROM SEC_CHECKPOINT_GATE_TAB
   WHERE GATE_ID = gate_id_;
BEGIN
   OPEN get_active_status;
   FETCH get_active_status INTO is_active_;
   CLOSE get_active_status;
   IF is_active_ = 'TRUE' THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;  
END Is_Checkpoint_Active__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

