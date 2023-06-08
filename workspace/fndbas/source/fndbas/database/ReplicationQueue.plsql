-----------------------------------------------------------------------------
--
--  Logical unit: ReplicationQueue
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030407  ROOD    Increased business_object_id to 2000 characters (Bug#36679).
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  100108  HAYA    Updated to new server template
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Seq_No___ RETURN NUMBER
IS
   seq_   NUMBER;
   CURSOR repl_seq IS
      SELECT replication_seq.nextval
      FROM   dual;
BEGIN
   OPEN repl_seq;
   FETCH repl_seq INTO seq_;
   CLOSE repl_seq;
   RETURN seq_;
END Get_Next_Seq_No___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REPLICATION_QUEUE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.seq_no := Get_Next_Seq_No___;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT replication_queue_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF ( newrec_.business_object_version IS NULL ) THEN
      newrec_.business_object_version := SYSDATE;
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create_New__ (
   newrec_ IN OUT replication_queue_tab%ROWTYPE )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
BEGIN
   newrec_.business_object_version := sysdate;
   Insert___(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Create_New__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


