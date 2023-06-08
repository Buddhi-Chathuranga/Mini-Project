-----------------------------------------------------------------------------
--
--  Logical unit: ConnectNode
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  -------------------------------------------------------
--  2019-07-09  madrse  PACZDATA-588: Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

ACTIVE_NODE_POST_AGE   CONSTANT NUMBER := 30; -- This value (seconds) must be (much) greater than Heartbeat Timer delay defined in ConnectTimerBean EJB
ACTIVE_NODE_INVOKE_AGE CONSTANT NUMBER := 30; -- ToDo: Different values for POST and INVOKE?

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Trace___ (
   text_ IN VARCHAR2) IS
BEGIN
   --Log_SYS.Fnd_Trace_(Log_SYS.info_, text_);
   Dbms_Output.Put_Line(text_);
END Trace___;


--
-- Add prefix to node_id to guarantee unique pipe/lock name.
-- Max length is 128 bytes.
--
FUNCTION Get_Node_Name___ (
   node_id_   IN VARCHAR2,
   is_invoke_ IN BOOLEAN) RETURN VARCHAR2 IS
BEGIN
   RETURN 'IFS_CONNECT' || CASE is_invoke_ WHEN TRUE THEN '_INVOKE' ELSE '' END || '$' || node_id_;
END Get_Node_Name___;


FUNCTION Get_Node_Name___ (
   node_id_   IN VARCHAR2,
   is_invoke_ IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN Get_Node_Name___(node_id_, is_invoke_ = 'TRUE');
END Get_Node_Name___;


PROCEDURE Create_Pipe___ (
   node_id_   IN VARCHAR2,
   is_invoke_ IN BOOLEAN)
IS
   pipe_name_ VARCHAR2(128) := Get_Node_Name___(node_id_, is_invoke_);
   result_    INTEGER;
BEGIN
   Trace___('Creating pipe [' || pipe_name_ || ']');
   result_ := Dbms_Pipe.Create_Pipe
                (pipename    => pipe_name_,
                 maxpipesize => 1000,
                 private     => TRUE);
END Create_Pipe___;


PROCEDURE Remove_Pipe___ (
   node_id_   IN VARCHAR2,
   is_invoke_ IN BOOLEAN)
IS
   pipe_name_ VARCHAR2(128) := Get_Node_Name___(node_id_, is_invoke_);
   result_    INTEGER;
BEGIN
   Trace___('Removing pipe [' || pipe_name_ || ']');
   result_ := Dbms_Pipe.Remove_Pipe(pipe_name_);
END Remove_Pipe___;


PROCEDURE Allocate_Lock_Handle___ (
   lock_name_   IN  VARCHAR2,
   lock_handle_ OUT VARCHAR2)
IS
   PRAGMA autonomous_transaction;
BEGIN
   Dbms_Lock.Allocate_Unique(lock_name_, lock_handle_, expiration_secs => 3600); -- Dbms_Lock.Allocate_Unique performs commit
END Allocate_Lock_Handle___;


PROCEDURE Create_Node___ (
   node_id_      IN VARCHAR2,
   cluster_name_ IN VARCHAR2,
   load_factor_  IN NUMBER)
IS
   lock_handle_        VARCHAR2(128);
   invoke_lock_handle_ VARCHAR2(128);
BEGIN
   Trace___('Creating node [' || node_id_ || ']');

   Allocate_Lock_Handle___(Get_Node_Name___(node_id_, FALSE), lock_handle_);
   Trace___('Allocated lock handle [' || lock_handle_ || '] for node [' || node_id_ || ']');

   Allocate_Lock_Handle___(Get_Node_Name___(node_id_, TRUE), invoke_lock_handle_);
   Trace___('Allocated Invoke lock handle [' || invoke_lock_handle_ || '] for node [' || node_id_ || ']');

   INSERT INTO connect_node_tab (node_id, cluster_name, lock_handle, invoke_lock_handle, created_timestamp, timestamp, load_factor, rowversion)
   VALUES (node_id_, cluster_name_, lock_handle_, invoke_lock_handle_, SYSDATE, SYSDATE, load_factor_, 1);

   Create_Pipe___(node_id_, TRUE);
   Create_Pipe___(node_id_, FALSE);
END Create_Node___;


PROCEDURE Remove_Node___ (
   node_id_ IN VARCHAR2) IS
BEGIN
   Trace___('Removing node [' || node_id_ || ']');

   DELETE connect_node_tab WHERE node_id = node_id_;

   Remove_Pipe___(node_id_, TRUE);
   Remove_Pipe___(node_id_, FALSE);
END Remove_Node___;


--
-- Lock node with specified timeout.
-- Corresponds to SELECT FOR UPDATE NOWAIT or SELECT FOR UPDATE WAIT <seconds>.
--
FUNCTION Lock_Node___ (
   node_id_            IN VARCHAR2,
   is_invoke_          IN VARCHAR2,
   timeout_in_seconds_ IN NUMBER) RETURN BOOLEAN
IS
   lock_handle_ VARCHAR2(128);
   result_      INTEGER;
BEGIN
   BEGIN
      SELECT decode(is_invoke_, 'TRUE', invoke_lock_handle, lock_handle)
        INTO lock_handle_
        FROM connect_node_tab
       WHERE node_id = node_id_;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN FALSE;
   END;

   result_ := Dbms_Lock.Request
               (lockhandle        => lock_handle_,
                lockmode          => Dbms_Lock.X_MODE,
                timeout           => timeout_in_seconds_,
                release_on_commit => TRUE);

   Trace___('Locking node [' || node_id_ || ', ' || is_invoke_ || '] using lock handle [' || lock_handle_ || '] with timeout [' || timeout_in_seconds_ || '] sec. Result = ' || result_);
   --
   --  0 Success
   --  1 Timeout
   --  2 Deadlock
   --  3 Parameter error
   --  4 Already own lock specified by id or lockhandle
   --  5 Illegal lock handle
   --
   RETURN result_ IN (0, 4) ;
END Lock_Node___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

--
-- Called on connect node startup
--
PROCEDURE Register_Node_ (
   node_id_      IN VARCHAR2,
   cluster_name_ IN VARCHAR2,
   load_factor_  IN NUMBER) IS
BEGIN
   Trace___('Registering node [' || node_id_ || ']');
   Remove_Node___(node_id_);
   Create_Node___(node_id_, cluster_name_, load_factor_);
END Register_Node_;


--
-- Called on connect node shutdown
--
PROCEDURE Unregister_Node_ (
   node_id_ IN VARCHAR2) IS
BEGIN
   Trace___('Unregistering node [' || node_id_ || ']');
   Remove_Node___(node_id_);
END Unregister_Node_;


--
-- Called from Heartbeat Timer
--
PROCEDURE Update_Node_ (
   node_id_      IN VARCHAR2,
   cluster_name_ IN VARCHAR2,
   load_factor_  IN NUMBER) IS
BEGIN
   UPDATE connect_node_tab
      SET timestamp = SYSDATE, load_factor = load_factor_, rowversion = rowversion + 1
    WHERE node_id = node_id_;

   IF SQL%ROWCOUNT = 0 THEN
      Trace___('WARNING! Registering node [' || node_id_ || '] from Heartbeat Timer');
      Create_Node___(node_id_, cluster_name_, load_factor_);
   END IF;
END Update_Node_;


--
-- Called from Cleanup Timer
--
PROCEDURE Cleanup_Nodes_ (
   age_in_seconds_ IN NUMBER) IS
BEGIN
   Trace___('Cleaning up inactive nodes');
   FOR node_ IN (SELECT node_id
                   FROM connect_node
                  WHERE age_in_seconds > age_in_seconds_
                  ORDER BY node_id)
   LOOP
      Remove_Node___(node_.node_id);
   END LOOP;
END Cleanup_Nodes_;


--
-- Choose node for processing of Batch Processor message
--
FUNCTION Choose_Node_ (
   invoke_ IN BOOLEAN) RETURN VARCHAR2
IS
   max_age_      NUMBER      := CASE invoke_ WHEN TRUE THEN ACTIVE_NODE_INVOKE_AGE ELSE ACTIVE_NODE_POST_AGE END;
   node_id_      VARCHAR2(100);
   load_factor_  NUMBER;
BEGIN
   SELECT node_id, load_factor
     INTO node_id_, load_factor_
     FROM connect_node
    WHERE cluster_name = 'INT'
      AND age_in_seconds <= max_age_
    ORDER BY load_factor, Dbms_Random.Value
    FETCH FIRST ROW ONLY;

   Trace___('Chose node [' || node_id_ || '] with load_factor [' || load_factor_ || ']');
   RETURN node_id_;
EXCEPTION
   WHEN no_data_found THEN
      Trace___('WARNING! There is no running IFS Connect container');
      RETURN '?'; -- This row will be handled by Fallback Timer
END Choose_Node_;


--
-- Lock node if not already locked by another thread
--
PROCEDURE Lock_Node_No_Wait_ (
   node_id_   IN VARCHAR2,
   is_invoke_ IN VARCHAR2)
IS
   locked_ BOOLEAN;
BEGIN
   locked_ := Lock_Node___(node_id_, is_invoke_, 0); -- LOCK NOWAIT
END Lock_Node_No_Wait_;


--
-- Send Pipe message to node
--
PROCEDURE Send_Pipe_Message_ (
   node_id_   IN VARCHAR2,
   is_invoke_ IN VARCHAR2,
   text_      IN VARCHAR2)
IS
   pipe_name_ VARCHAR2(128) := Get_Node_Name___(node_id_, is_invoke_);
   result_    INTEGER;
BEGIN
   Trace___('Notifying node via pipe [' || pipe_name_ || ']');
   Dbms_Pipe.Reset_Buffer;
   Dbms_Pipe.Pack_Message(text_);
   result_ := Dbms_Pipe.Send_Message(pipe_name_);
END Send_Pipe_Message_;


--
-- Notify node about new Batch Processor non-Invoke queue message to process.
-- Called from Batch_Processor_Jms_API.Send_Jms_Message for asynchronous (not Invoke) messages
--
PROCEDURE Notify_Node_ (
   node_id_ IN VARCHAR2,
   text_    IN VARCHAR2) IS
BEGIN
   Trace___('Notifying node [' || node_id_ || ']');
   Lock_Node_No_Wait_(node_id_, 'FALSE');
   Send_Pipe_Message_(node_id_, 'FALSE', text_);
END Notify_Node_;


--
-- Notify all nodes about new Batch Processor topic message to publish
--
PROCEDURE Notify_All_Nodes_ (
   text_ IN VARCHAR2) IS
BEGIN
   Trace___('Notifying all nodes');
   FOR node_ IN (SELECT node_id
                   FROM connect_node_tab
                  ORDER BY node_id)
   LOOP
      Notify_Node_(node_.node_id, text_);
   END LOOP;
END Notify_All_Nodes_;


--
-- Wait for notification about queued Batch Processor message
--
PROCEDURE Wait_For_Notification_ (
   node_id_            IN VARCHAR2,
   is_invoke_          IN VARCHAR2,
   timeout_in_seconds_ IN NUMBER)
IS
   PRAGMA autonomous_transaction;

   result_ INTEGER;
   locked_ BOOLEAN;
BEGIN
   Trace___('Waiting for notification on node [' || node_id_ || ', ' || is_invoke_ || ']');
   result_ := Dbms_Pipe.Receive_Message(Get_Node_Name___(node_id_, is_invoke_), timeout_in_seconds_);
   IF result_ = 0 THEN
      locked_ := Lock_Node___(node_id_, is_invoke_, timeout_in_seconds_);
   END IF;
   @ApproveTransactionStatement(2019-07-12,madrse)
   COMMIT;
END Wait_For_Notification_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

