-----------------------------------------------------------------------------
--
--  Logical unit: ReportBatchProcessorJms
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
/*PROCEDURE Enqueue_Aq_Message___ (
   message_            IN OUT sys.aq$_jms_bytes_message,
   message_properties_ IN     Dbms_AQ.message_properties_t,
   jms_queue_name_     IN     VARCHAR2)
IS
   agent_           sys.aq$_agent := sys.aq$_agent(' ', NULL, 0);
   id_              PLS_INTEGER;
   enqueue_options_ Dbms_AQ.enqueue_options_t;
   msgid_           RAW(16);
   t1_              NUMBER;
   t2_              NUMBER;
BEGIN
   message_.set_replyto(agent_);

   id_ := message_.clear_body(-1);
   message_.flush(id_);
   sys.aq$_jms_bytes_message.clean_all();

   t1_ := Dbms_Utility.Get_Time;
   Dbms_Aq.Enqueue(queue_name         => jms_queue_name_,     -- IN
                   enqueue_options    => enqueue_options_,    -- IN
                   message_properties => message_properties_, -- IN
                   payload            => message_,            -- IN
                   msgid              => msgid_);             -- OUT
   t2_ := Dbms_Utility.Get_Time;
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Batch_Processor_Jms_API: Dbms_AQ.Enqueue on [' || jms_queue_name_ || '] completed in [' || (t2_ - t1_) / 100 || '] sec');
END Enqueue_Aq_Message___;


PROCEDURE Dequeue_Aq_Message___ (
   message_         IN OUT sys.aq$_jms_bytes_message,
   jms_queue_name_  IN     VARCHAR2,
   correlation_id_  IN     VARCHAR2,
   timeout_         IN     NUMBER )
IS
   dequeue_options_    Dbms_AQ.dequeue_options_t;
   message_properties_ Dbms_AQ.message_properties_t;
   msgid_              RAW(16);
   t1_                 NUMBER;
   t2_                 NUMBER;
BEGIN
   dequeue_options_.dequeue_mode  := Dbms_AQ.REMOVE;
   dequeue_options_.navigation    := Dbms_AQ.FIRST_MESSAGE;
   dequeue_options_.wait          := timeout_;
   dequeue_options_.correlation   := correlation_id_;

   t1_ := Dbms_Utility.Get_Time;
   Dbms_AQ.Dequeue (queue_name         => jms_queue_name_,     -- IN
                    dequeue_options    => dequeue_options_,    -- IN
                    message_properties => message_properties_, -- IN
                    payload            => message_,            -- OUT
                    msgid              => msgid_);             -- OUT
   t2_ := Dbms_Utility.Get_Time;
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Batch_Processor_Jms_API: Dbms_AQ.Dequeue of #'|| msgid_ ||' from [' || jms_queue_name_ || '] completed in [' || (t2_ - t1_) / 100 || '] sec');
END Dequeue_Aq_Message___;*/


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Send_Jms_Message (
   method_                     IN VARCHAR2,
   queue_                      IN VARCHAR2 DEFAULT NULL,
   application_message_id_     IN VARCHAR2 DEFAULT NULL,
   group_name_                 IN VARCHAR2 DEFAULT NULL,
   instance_name_              IN VARCHAR2 DEFAULT NULL,
   parameter_name_             IN VARCHAR2 DEFAULT NULL,
   execution_mode_             IN VARCHAR2 DEFAULT NULL,
   priority_                   IN NUMBER   DEFAULT NULL,
   restricted_queue_thread_no_ IN NUMBER   DEFAULT NULL,
   restricted_queue_check_     IN VARCHAR2 DEFAULT NULL,
   restricted_queue_name_      IN VARCHAR2 DEFAULT NULL,
   restricted_queue_type_      IN VARCHAR2 DEFAULT NULL,
   reader_message_id_          IN VARCHAR2 DEFAULT NULL,
   jms_queue_name_             IN VARCHAR2 DEFAULT NULL,
   jms_delivery_delay_         IN NUMBER   DEFAULT NULL,
   property_group_             IN VARCHAR2 DEFAULT NULL,
   admin_method_               IN VARCHAR2 DEFAULT NULL,
   admin_value_                IN VARCHAR2 DEFAULT NULL,
   chosen_node_id_             IN VARCHAR2 DEFAULT NULL)
IS
   message_seq_no_ NUMBER       := report_batch_pr_queue_seq.NEXTVAL;
   invoke_         BOOLEAN      := execution_mode_ = 'Invoke';
   is_topic_       BOOLEAN;
   node_id_        VARCHAR2(100);
BEGIN
   IF method_ IN ('SynchronizeReaders', 'SynchronizeReader', 'ClearConfigCache', 'ApplyProperties', 'FndAdminTopic') THEN
      is_topic_ := TRUE;
      node_id_  := '*';
   ELSE
      is_topic_ := FALSE;
      node_id_  := CASE chosen_node_id_ IS NOT NULL WHEN TRUE THEN chosen_node_id_ ELSE Report_Node_API.Choose_Node_(invoke_) END;
   END IF;

   INSERT INTO report_batch_pr_queue_tab
     (message_seq_no,
      cluster_name,
      node_id,
      timestamp,
      method,
      queue,
      application_message_id,
      group_name,
      instance_name,
      parameter_name,
      execution_mode,
      priority,
      restricted_queue_thread_no,
      restricted_queue_check,
      restricted_queue_name,
      restricted_queue_type,
      reader_message_id,
      jms_queue_name,
      jms_delivery_delay,
      property_group,
      admin_method,
      admin_value,
      rowversion)
   VALUES
     (message_seq_no_,
      'REP',
      node_id_,
      SYSDATE,
      method_,
      queue_,
      application_message_id_,
      group_name_,
      instance_name_,
      parameter_name_,
      execution_mode_,
      priority_,
      restricted_queue_thread_no_,
      restricted_queue_check_,
      restricted_queue_name_,
      restricted_queue_type_,
      reader_message_id_,
      jms_queue_name_,
      jms_delivery_delay_,
      property_group_,
      admin_method_,
      admin_value_,
      1);

   IF is_topic_ THEN
      Report_Node_API.Notify_All_Nodes_(message_seq_no_);
   ELSIF invoke_ THEN
      NULL; -- For Invoke calls notification is delayed to COMMIT in Plsqlap_Server_API.Invoke_Aq___
   ELSIF node_id_ <> '?' THEN
      Report_Node_API.Notify_Node_(node_id_, message_seq_no_);
   END IF;
END Send_Jms_Message;


/*PROCEDURE Send_Response_Message (
   application_message_id_ IN VARCHAR2,
   state_                  IN VARCHAR2,
   message_body_seq_no_    IN VARCHAR2 )
IS
   message_            sys.aq$_jms_bytes_message;
   message_properties_ Dbms_AQ.message_properties_t;
BEGIN
   message_ := sys.aq$_jms_bytes_message.construct;

   message_.set_string_property('application_message_id', application_message_id_);
   message_.set_string_property('state', state_);
   message_.set_string_property('seq_no', message_body_seq_no_);

   message_properties_.expiration := 60;
   message_properties_.correlation := application_message_id_;

   Enqueue_Aq_Message___ (message_, message_properties_, 'BATCH_PROC_RESP_QUEUE');
END Send_Response_Message;


PROCEDURE Receive_Response_Message (
   state_        OUT VARCHAR2,
   msg_body_seq_ OUT NUMBER,
   message_id_   IN  NUMBER,
   timeout_      IN  NUMBER )
IS
   message_    sys.aq$_jms_bytes_message;
   app_msg_id_ NUMBER;
BEGIN
   Dequeue_Aq_Message___(message_, 'BATCH_PROC_RESP_QUEUE', message_id_, timeout_);
   app_msg_id_ := to_number(message_.get_string_property('application_message_id'));
   IF app_msg_id_ <> message_id_ THEN
      Error_SYS.Appl_General(lu_name_, 'ERRAPPMSGID: Application Message ID is different');
   END IF;
   state_ := message_.get_string_property('state');
   msg_body_seq_ := to_number(message_.get_string_property('seq_no'));
END Receive_Response_Message;*/


-------------------- LU  NEW METHODS -------------------------------------
