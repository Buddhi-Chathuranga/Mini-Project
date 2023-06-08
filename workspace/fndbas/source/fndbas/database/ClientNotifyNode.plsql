-----------------------------------------------------------------------------
--
--  Logical unit: ClientNotifyNode
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

FUNCTION Get_Node_Name___ (
   node_id_   IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN 'IFS_CLIENT_NOTIFY_'||node_id_;
END Get_Node_Name___;

PROCEDURE Create_Pipe___ (
   node_id_   IN VARCHAR2)
IS
   pipe_name_ VARCHAR2(128) := Get_Node_Name___(node_id_);
BEGIN
   Trace___('Creating pipe ['||pipe_name_||']');
   Create_Pipe2___(pipe_name_);
END Create_Pipe___;

PROCEDURE Create_Pipe2___ (
   pipe_name_  IN VARCHAR2)
IS
   result_ INTEGER;
BEGIN
   result_ := Dbms_Pipe.Create_Pipe
                (pipename    => pipe_name_,
                 maxpipesize => 1000,
                 private     => TRUE);
END Create_Pipe2___;

PROCEDURE Remove_Pipe___ (
   node_id_   IN VARCHAR2)
IS
   pipe_name_ VARCHAR2(128) := Get_Node_Name___(node_id_);
   result_    INTEGER;
BEGIN
   Trace___('Removing pipe ['||pipe_name_||']');
   result_ := Dbms_Pipe.Remove_Pipe(pipe_name_);
END Remove_Pipe___;


PROCEDURE Create_Node___ (
   node_id_     IN VARCHAR2,
   node_name_   IN VARCHAR2,
   node_group_  IN INTEGER,
   load_factor_ IN NUMBER)
IS
BEGIN
   Trace___('Creating node ['||node_id_||']');
   INSERT INTO client_notify_node_tab (node_id, node_name, node_group, created_timestamp, timestamp, load_factor, rowversion)
   VALUES (node_id_, node_name_, node_group_, SYSDATE, SYSDATE, load_factor_, 1);
   Create_Pipe___(node_id_);
END Create_Node___;

PROCEDURE Remove_Node___ (
   node_id_ IN VARCHAR2) IS
BEGIN
   Trace___('Removing node ['||node_id_ ||']');
   -- cascade delete FK on client_notify_queue_sent_tab will delete sent messages for this node
   DELETE client_notify_node_tab WHERE node_id = node_id_;
   Remove_Pipe___(node_id_);
END Remove_Node___;

FUNCTION Get_Count_ (
   node_group_ IN INTEGER) RETURN INTEGER
IS
   result_ INTEGER;
BEGIN
   SELECT COUNT(*) INTO result_ FROM client_notify_node_tab
    WHERE node_group = node_group_;
   RETURN result_;
END Get_Count_;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

--
-- Called on node startup
--
PROCEDURE Register_Node_ (
   node_id_     IN VARCHAR2,
   node_name_   IN VARCHAR2,
   node_group_  IN INTEGER,
   load_factor_ IN NUMBER) IS
BEGIN
   Trace___('Registering node ['||node_id_||']');
   Remove_Node___(node_id_);
   Create_Node___(node_id_, node_name_, node_group_, load_factor_);
END Register_Node_;

--
-- Called on node shutdown
--
PROCEDURE Unregister_Node_ (
   node_id_ IN VARCHAR2) IS
BEGIN
   Trace___('Unregistering node ['||node_id_||']');
   Remove_Node___(node_id_);
END Unregister_Node_;

--
-- Called from Heartbeat Timer
--
FUNCTION Update_Node_ (
   node_id_      IN VARCHAR2,
   load_factor_  IN NUMBER) RETURN VARCHAR2 IS
BEGIN
   UPDATE client_notify_node_tab
      SET timestamp = SYSDATE, load_factor = load_factor_, rowversion = rowversion + 1
    WHERE node_id = node_id_;
   IF SQL%ROWCOUNT > 0 THEN
      TRACE___('Updated node ['||node_id_||']');
      RETURN 'TRUE';
   ELSE
      TRACE___('No node to update ['||node_id_||']');
      RETURN 'FALSE';
   END IF;
END Update_Node_;

--
-- Called from Cleanup Timer
--
PROCEDURE Cleanup_Nodes_ (
   node_group_     IN INTEGER,
   age_in_seconds_ IN NUMBER,
   node_id_        IN VARCHAR2 := NULL) IS
BEGIN
   Trace___('Cleaning up node group: '||node_group_);
   -- derived column age_in_seconds is only in the view - not the table
   FOR node_ IN (SELECT node_id
                   FROM client_notify_node
                  WHERE node_group = node_group_ AND age_in_seconds > age_in_seconds_
                    AND (node_id_ IS NULL OR node_id <> node_id_)
                  ORDER BY node_id)
      LOOP
         Remove_Node___(node_.node_id);
      END LOOP;
END Cleanup_Nodes_;

--
-- Send Pipe message to node
--
PROCEDURE Send_Pipe_Message_ (
   node_id_   IN VARCHAR2,
   text_      IN VARCHAR2)
IS
   pipe_name_ VARCHAR2(128) := Get_Node_Name___(node_id_);
   result_    INTEGER;
BEGIN
   Trace___('Notifying node ['||node_id_||']');
   Create_Pipe2___(pipe_name_);
   Dbms_Pipe.Reset_Buffer;
   Dbms_Pipe.Pack_Message(text_);
   result_ := Dbms_Pipe.Send_Message(pipe_name_);
END Send_Pipe_Message_;

--
-- Wait for notification about queued Client Notify message
-- On timeout returns FALSE
--
FUNCTION Wait_For_Notification_ (
   node_id_            IN VARCHAR2,
   timeout_in_seconds_ IN NUMBER) RETURN VARCHAR2
IS
   pipe_name_ VARCHAR2(128) := Get_Node_Name___(node_id_);
   result_    INTEGER;
BEGIN
   Trace___('Waiting for notification on node ['||node_id_||']');
   Create_Pipe2___(pipe_name_);
   result_ := Dbms_Pipe.Receive_Message(pipe_name_, timeout_in_seconds_);
   IF result_ = 0 THEN
      Trace___('Node ['||node_id_||'] notified');
      RETURN 'TRUE';
   END IF;
   Trace___('Node ['||node_id_||'] timeout');
   RETURN 'FALSE';
END Wait_For_Notification_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

--
-- Notify all nodes in a group about new Client Notify messages
--
PROCEDURE Notify_All_Nodes_ (
   text_       IN VARCHAR2,
   node_group_ IN INTEGER := 0) IS
BEGIN
   Trace___('Notifying all nodes in group: '||node_group_);
   FOR node_ IN (SELECT node_id
                   FROM client_notify_node_tab
                  WHERE node_group = node_group_
                  ORDER BY node_id)
   LOOP
      Send_Pipe_Message_(node_.node_id, text_);
   END LOOP;
END Notify_All_Nodes_;

