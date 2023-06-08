-----------------------------------------------------------------------------
--
--  Logical unit: ReportBatchPrQueue
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
PROCEDURE Trace___ (
   text_ IN VARCHAR2) IS
BEGIN
   --Log_SYS.Fnd_Trace_(Log_SYS.info_, text_);
   Dbms_Output.Put_Line(text_);
END Trace___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
FUNCTION Lock_Message_ (
   message_seq_no_ IN NUMBER) RETURN VARCHAR2
IS
   resource_busy_ EXCEPTION;
   PRAGMA EXCEPTION_INIT(resource_busy_, -54);
   tmp_ NUMBER;
BEGIN
   SELECT NULL
     INTO tmp_
     FROM report_batch_pr_queue_tab
    WHERE message_seq_no = message_seq_no_
   FOR UPDATE NOWAIT;
   Trace___('Locked Batch Processor message ' || message_seq_no_);
   RETURN 'TRUE';
EXCEPTION
   WHEN resource_busy_ THEN
      Trace___('Failed to lock Batch Processor message ' || message_seq_no_);
      RETURN 'FALSE';
   WHEN no_data_found THEN
      Trace___('Failed to lock non-existent Batch Processor message ' || message_seq_no_);
      RETURN 'FALSE';
END Lock_Message_;


--
-- Remove Batch Processor master message and all sent messages.
-- Called from MDB and Cleanup_Topic_Messages_ after successful call to Lock_Message_.
--
PROCEDURE Remove_Message_ (
   message_seq_no_ IN NUMBER) IS
BEGIN
   Trace___('Deleting Batch Processor message ' || message_seq_no_);
   DELETE report_batch_pr_queue_tab
    WHERE message_seq_no = message_seq_no_;
   Trace___('Deleting Batch Processor messages sent: ' || message_seq_no_);
   DELETE report_batch_pr_queue_sent_tab
    WHERE message_seq_no = message_seq_no_;
END Remove_Message_;


--
-- Insert database row corresponding to local JMS message sent by a node.
--
PROCEDURE Message_Sent_ (
   node_id_        IN VARCHAR2,
   message_seq_no_ IN NUMBER) IS
BEGIN
   Trace___('Inserting Batch Processor message sent: ' || node_id_ || ':' || message_seq_no_);
   IF node_id_ = '*' THEN
      Error_SYS.Appl_General(lu_name_, 'SENT_NODE_ID: Invalid node ID [:P1] passed to Batch_Processor_Queue_API.Message_Sent_', node_id_);
   ELSE
      INSERT INTO report_batch_pr_queue_sent_tab(node_id, message_seq_no)
      VALUES (node_id_, message_seq_no_);
   END IF;
END Message_Sent_;


--
-- Remove old Batch Processor topic messages. Called from Cleanup Timer.
--
PROCEDURE Cleanup_Topic_Messages_ (
   age_in_seconds_ IN NUMBER) IS
BEGIN
   Trace___('Cleaning up old Batch Processor topic messages');
   FOR msg_ IN (SELECT message_seq_no
                  FROM report_batch_pr_queue
                 WHERE node_id = '*'
                   AND age_in_seconds > age_in_seconds_
                 ORDER BY message_seq_no)
   LOOP
      IF Lock_Message_(msg_.message_seq_no) = 'TRUE' THEN
         Remove_Message_(msg_.message_seq_no);
      END IF;
   END LOOP;
END Cleanup_Topic_Messages_;


--
-- Remove old Batch Processor sent messages. Called from Cleanup Timer.
-- Sent message may be missed by Remove_Message_ if Forwarder timer is slower than Fallback timer.
--
PROCEDURE Cleanup_Sent_Messages_ IS
BEGIN
   Trace___('Cleaning up old Batch Processor sent messages');
   DELETE report_batch_pr_queue_sent_tab S
    WHERE message_seq_no IN (SELECT S.message_seq_no FROM report_batch_pr_queue_sent_tab S
                             MINUS
                             SELECT Q.message_seq_no FROM report_batch_pr_queue_tab Q);
   Trace___('Deleted ' || SQL%ROWCOUNT || ' rows from batch_processor_queue_sent_tab');
END Cleanup_Sent_Messages_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
--
-- Check if Batch Processor message is locked by MDB
--
@UncheckedAccess
FUNCTION Is_Locked (
   message_seq_no_ IN NUMBER) RETURN VARCHAR2
IS
   PRAGMA autonomous_transaction;

   is_locked_ VARCHAR2(5);

   FUNCTION Try_Lock RETURN VARCHAR2 IS
      resource_busy_ EXCEPTION;
      PRAGMA EXCEPTION_INIT(resource_busy_, -54);

      tmp_    NUMBER;
   BEGIN
      SELECT NULL
        INTO tmp_
        FROM report_batch_pr_queue_tab
       WHERE message_seq_no = message_seq_no_
      FOR UPDATE NOWAIT;
      RETURN 'FALSE';
   EXCEPTION
      WHEN resource_busy_ THEN
         RETURN 'TRUE';
      WHEN no_data_found THEN
         RETURN 'FALSE';
   END Try_Lock;
BEGIN
   is_locked_ := Try_Lock;
   @ApproveTransactionStatement(2019-07-15,madrse)
   COMMIT;
   RETURN is_locked_;
END Is_Locked;

