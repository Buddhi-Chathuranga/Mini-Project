-----------------------------------------------------------------------------
--
--  Logical unit: ClientNotifyQueue
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
   Dbms_Output.Put_Line(text_);
END Trace___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

--
-- Lock a message.
-- Called from Forwarder to establish exclusive access before
-- adding the message to a JMS Queue or Topic
-- message_seq_no_ and node_id_ are in the opposite order from Message_Sent_
-- This is an unfortunate accident resulting from node_id_ getting added later
-- and needing to retain backwards compatibility with old code that just supplied
-- message_seq_no_ - thst is how inconsistencies in API design arise
-- One requirement (backwards compatibility) trumps another (consistency).
--
FUNCTION Lock_Message_ (
   message_seq_no_ IN NUMBER,
   node_id_        IN VARCHAR2 := NULL) RETURN VARCHAR2
IS
   resource_busy_ EXCEPTION;
   PRAGMA EXCEPTION_INIT(resource_busy_, -54);
   tmp_ NUMBER;
BEGIN
   SELECT NULL INTO tmp_ FROM client_notify_queue_tab
    WHERE message_seq_no = message_seq_no_ FOR UPDATE NOWAIT;
   IF node_id_ IS NOT NULL THEN
      SELECT NULL INTO tmp_ FROM client_notify_node_tab
       WHERE node_id = node_id_ FOR UPDATE NOWAIT;
   END IF;
   Trace___('Locked Client Notify message');
   RETURN 'TRUE';
EXCEPTION
   WHEN resource_busy_ THEN
      Trace___('Failed to lock Client Notify message');
      RETURN 'FALSE';
   WHEN no_data_found THEN
      Trace___('Failed to lock non-existent Client Notify message');
      RETURN 'FALSE';
END Lock_Message_;

--
-- Remove client notify message and all sent messages.
-- Called Cleanup_Topic_Messages_ after successful call to Lock_Message_.
--
PROCEDURE Remove_Message_ (
   message_seq_no_ IN NUMBER) IS
BEGIN
   Trace___('Deleting Client Notify message ' || message_seq_no_);
   DELETE client_notify_queue_tab
    WHERE message_seq_no = message_seq_no_;
   Trace___('Deleting Client Notify message sent: ' || message_seq_no_);
   DELETE client_notify_queue_sent_tab
    WHERE message_seq_no = message_seq_no_;
END Remove_Message_;

--
-- The sent row indicates that a message is now in the JMS queue/topic
-- for a node.
--
PROCEDURE Message_Sent_ (
   node_id_        IN VARCHAR2,
   message_seq_no_ IN INTEGER) IS
BEGIN
   Trace___('Client Notify message queued to ['||node_id_||']');
   INSERT INTO client_notify_queue_sent_tab(node_id, message_seq_no)
   VALUES (node_id_, message_seq_no_);
END Message_Sent_;

--
-- Get one random unsent message, without prerequisites from the Queue
-- The caller must LOCK the message to establish exclusive access
-- before transferring the message to JMS
--
PROCEDURE Get_Next_Message_ (
   message_seq_no_      OUT INTEGER,
   method_              OUT VARCHAR2,
   method_reference_    OUT VARCHAR2,
   message_group_    IN     INTEGER) IS
BEGIN
   SELECT Q.message_seq_no, Q.method, Q.method_reference
   INTO message_seq_no_, method_, method_reference_
   FROM client_notify_queue_tab Q
   LEFT OUTER JOIN client_notify_queue_sent_tab S ON Q.message_seq_no = S.message_seq_no
   LEFT OUTER JOIN client_notify_queue_prereq_tab P ON Q.message_seq_no = P.message_seq_no
   WHERE S.message_seq_no IS NULL AND P.message_seq_no IS NULL AND Q.message_group = message_group_
   ORDER BY Dbms_Random.Value FETCH FIRST ROW ONLY;
   Trace___('Found Client Notify message');
EXCEPTION
   WHEN no_data_found THEN
      Trace___('No Client Notify message');
      message_seq_no_ := 0;
      method_ := NULL;
      method_reference_ := NULL;
END Get_Next_Message_;


--
-- Remove old topic messages. Called from Cleanup Timer.
--
PROCEDURE Cleanup_Topic_Messages_ (
   age_in_seconds_ IN NUMBER) IS
BEGIN
   Trace___('Cleaning up old Client Notify topic messages');
   FOR msg_ IN (SELECT message_seq_no
                  FROM client_notify_queue
                 WHERE age_in_seconds > age_in_seconds_
                 ORDER BY message_seq_no)
   LOOP
      IF Lock_Message_(msg_.message_seq_no) = 'TRUE' THEN
         Remove_Message_(msg_.message_seq_no);
      END IF;
   END LOOP;
END Cleanup_Topic_Messages_;


--
-- Remove old Client Notify sent messages. Called from Cleanup Timer.
-- Sent message may be missed by Remove_Message_.
--
PROCEDURE Cleanup_Sent_Messages_ IS
BEGIN
   Trace___('Cleaning up old Client Nofity sent messages');
   DELETE client_notify_queue_sent_tab S
    WHERE message_seq_no IN (SELECT S.message_seq_no FROM client_notify_queue_sent_tab S
                             MINUS
                             SELECT Q.message_seq_no FROM client_notify_queue_tab Q);
   Trace___('Deleted ' || SQL%ROWCOUNT || ' rows from client_notify_queue_sent_tab');
END Cleanup_Sent_Messages_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

--
-- Check if Client Notify message is locked
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
        FROM client_notify_queue_tab
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
   @ApproveTransactionStatement(2019-10-02,jebegb)
   COMMIT;
   RETURN is_locked_;
END Is_Locked;

--
-- Add message to queue
--
FUNCTION Add_Message (
   method_           IN VARCHAR2,
   method_reference_ IN VARCHAR2,
   message_group_    IN INTEGER := 0) RETURN INTEGER
IS
   message_seq_no_ INTEGER := client_notify_queue_seq.NEXTVAL;
BEGIN
   Trace___('Inserting Client Notify message');
   INSERT INTO client_notify_queue_tab (message_seq_no, timestamp, message_group, method, method_reference, rowversion)
   VALUES (message_seq_no_, SYSDATE, message_group_, method_, method_reference_, 1);
   RETURN message_seq_no_;
END Add_Message;

--
-- Validate refernce and add message to queue
-- Check for same reference exists befor adding to avoid duplicate references
--
FUNCTION Add_Message_If_Not_Exist (
   method_        IN VARCHAR2,
   reference_     IN VARCHAR2,
   message_group_ IN INTEGER := 0) RETURN INTEGER
IS
   message_seq_no_  INTEGER;
BEGIN
   
   IF reference_ IS NULL THEN
      SELECT message_seq_no INTO message_seq_no_
        FROM client_notify_queue_tab
       WHERE method = method_ AND method_reference IS NULL
       ORDER BY message_seq_no DESC
       FETCH FIRST ROW ONLY;
   ELSE
      SELECT message_seq_no INTO message_seq_no_
        FROM client_notify_queue_tab
       WHERE method = method_ AND method_reference = reference_
       ORDER BY message_seq_no DESC
       FETCH FIRST ROW ONLY;
   END IF;
   RETURN message_seq_no_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN Add_Message(method_, reference_, message_group_); 
END Add_Message_If_Not_Exist;


PROCEDURE Add_Prerequisite (
   message_seq_no_ IN INTEGER,
   prereq_seq_no_  IN INTEGER) IS
BEGIN
   IF message_seq_no_ <> prereq_seq_no_ THEN
      Trace___('Inserting Client Notify message prereq');
      INSERT INTO client_notify_queue_prereq_tab(message_seq_no, prereq_seq_no)
      VALUES (message_seq_no_, prereq_seq_no_);
   ELSE
      Trace___('Client Notify - invalid self prerequisite');
   END IF;
END Add_Prerequisite;