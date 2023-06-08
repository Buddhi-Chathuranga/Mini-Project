-----------------------------------------------------------------------------
--
--  Logical unit: FndProjCheckpointLog
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Log__ (
   log_id_       OUT NUMBER,
   gate_id_      IN  VARCHAR2,
   param_msg_    IN  VARCHAR2,
   user_comment_ IN  VARCHAR2,
   fnd_user_     IN  VARCHAR2)
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   newrec_     Fnd_Proj_Checkpoint_Log_Tab%ROWTYPE;
   attr_       VARCHAR2(2000);
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   SELECT Fnd_Proj_Checkpoint_Log_Seq.NEXTVAL INTO log_id_ FROM dual;
   newrec_.log_id := log_id_;
   
   newrec_.gate_id := gate_id_;
   newrec_.message := param_msg_;
   newrec_.user_comment := user_comment_;
   newrec_.username := fnd_user_;
   newrec_.transaction_date := sysdate;
   Insert___(objid_, objversion_, newrec_, attr_);
   @ApproveTransactionStatement(2019-07-16,mjaylk);
   COMMIT;
END Log__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

