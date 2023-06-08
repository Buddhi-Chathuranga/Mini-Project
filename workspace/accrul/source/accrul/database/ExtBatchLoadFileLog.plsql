-----------------------------------------------------------------------------
--
--  Logical unit: ExtBatchLoadFileLog
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
FUNCTION Get_Next_Seq_No___(
   import_message_id_   IN NUMBER) RETURN NUMBER
IS
   seq_no_  NUMBER := 1;
   CURSOR get_max_seq_no IS
      SELECT MAX(seq_no)+1
      FROM ext_batch_load_file_log_tab
      WHERE import_message_id = import_message_id_;
BEGIN
   OPEN get_max_seq_no;
   FETCH get_max_seq_no INTO seq_no_;
   CLOSE get_max_seq_no;
   RETURN NVL(seq_no_,1);
END Get_Next_Seq_No___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT ext_batch_load_file_log_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   newrec_.seq_no := Get_Next_Seq_No___(newrec_.import_message_id);
   newrec_.timestamp := sysdate;
   super(newrec_, indrec_, attr_);
   --Add post-processing code here
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@IgnoreUnitTest DMLOperation
PROCEDURE Insert_Record(
   newrec_  IN ext_batch_load_file_log_tab%ROWTYPE)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;

   newrecx_       ext_batch_load_file_log_tab%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   attr_          VARCHAR2(4000);
BEGIN
   newrecx_ := newrec_;
   newrecx_.rowkey := NULL;
   newrecx_.seq_no := Get_Next_Seq_No___(newrec_.import_message_id);
   newrecx_.timestamp := NVL(newrecx_.timestamp, sysdate);
   Insert___ ( objid_,
               objversion_,
               newrecx_,
               attr_ );
   @ApproveTransactionStatement(2021-07-03,nudilk)
   COMMIT;
END Insert_Record;

@UncheckedAccess
FUNCTION Log_Exist(
   import_message_id_ IN NUMBER) RETURN VARCHAR2
IS
   ndummy_  NUMBER;
   CURSOR get_row_exist IS
      SELECT 1
      FROM ext_batch_load_file_log_tab
      WHERE import_message_id = import_message_id_;
BEGIN
   OPEN get_row_exist;
   FETCH get_row_exist INTO ndummy_;
   CLOSE get_row_exist;
   IF ndummy_ IS NOT NULL THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Log_Exist;

@IgnoreUnitTest DMLOperation
PROCEDURE Cleanup
IS
BEGIN
   DELETE FROM ext_batch_load_file_log_tab;
END Cleanup;