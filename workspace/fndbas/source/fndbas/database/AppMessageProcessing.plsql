-----------------------------------------------------------------------------
--
--  Logical unit: AppMessageProcessing
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  -----------------------------------------------------
--  2014-09-15  madrse  Created
--  2018-11-15  japase  PACDATA-158 - Added support for INVOKE tag and
--                      cleaning of AQ exception queues.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

group_name_task_templates_     CONSTANT VARCHAR2(20) := 'TaskTemplates';
group_name_message_queues_     CONSTANT VARCHAR2(20) := 'MessageQueues';
group_name_connector_readers_  CONSTANT VARCHAR2(20) := 'ConnectorReaders';
instance_type_print_agent_     CONSTANT VARCHAR2(20) := 'PrintAgent';
parameter_name_stop_queue_     CONSTANT VARCHAR2(20) := 'STOP_QUEUE';
parameter_name_execution_mode_ CONSTANT VARCHAR2(20) := 'EXECUTION_MODE';
parameter_name_priority_       CONSTANT VARCHAR2(20) := 'PRIORITY';
parameter_thread_count_        CONSTANT VARCHAR2(20) := 'THREAD_COUNT';
media_code_inet_trans_         CONSTANT VARCHAR2(20) := 'INET_TRANS';
default_report_formatter_      CONSTANT VARCHAR2(30) := 'Default Report Formatter';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Compute_Next_Execution_Time___(schedule_id_ NUMBER) RETURN DATE IS
   execution_plan_      VARCHAR2(255);
   last_execution_date_ DATE;
   start_date_          DATE;
   stop_date_           DATE;
BEGIN
   SELECT execution_plan, last_execution_date, start_date, stop_date
     INTO execution_plan_, last_execution_date_, start_date_, stop_date_
     FROM batch_schedule
    WHERE schedule_id = schedule_id_;

   RETURN Batch_SYS.Get_Next_Exec_Time__
            (execution_plan_       => execution_plan_,
             previous_exec_date_   => last_execution_date_,
             scheduled_start_date_ => start_date_,
             scheduled_end_date_   => stop_date_);
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Record_Not_Exist(Batch_Schedule_API.lu_name_, p1_ => schedule_id_);
END Compute_Next_Execution_Time___;


FUNCTION Create_App_Server_Task_Xml___ (
   document_name_    IN VARCHAR2,
   document_package_ IN VARCHAR2,
   instance_name_    IN VARCHAR2,
   id_name_          IN VARCHAR2 DEFAULT NULL,
   id_value_         IN NUMBER   DEFAULT NULL) RETURN RAW
IS
   nl_  VARCHAR2(1) := chr(10);
   xml_ VARCHAR2(32767);

BEGIN
   xml_ := '<?xml version="1.0" encoding="UTF-8"?>' || nl_ ||
           '<' || document_name_ || ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:ifsworld-com:schemas:' || lower(document_package_) || '_' || lower(document_name_) || '">' || nl_ ||
           '  <CONFIG_INSTANCE_NAME>' || instance_name_ || '</CONFIG_INSTANCE_NAME>' || nl_;
   IF id_value_ IS NOT NULL THEN
      xml_ := xml_ || '  <' || id_name_ || '>' || id_value_ || '</' || id_name_ || '>' || nl_;
   END IF;
   xml_ := xml_ || '</' || document_name_ || '>' || nl_;
   RETURN Utl_Raw.Cast_To_Raw(xml_);
END Create_App_Server_Task_Xml___;


FUNCTION Clone_Message_Header___ (
   application_message_id_ IN NUMBER) RETURN NUMBER
IS
   new_id_ NUMBER := fndcn_message_seq.NEXTVAL;
   head_ fndcn_application_message_tab%ROWTYPE;
BEGIN
   SELECT *
     INTO head_
     FROM fndcn_application_message_tab
    WHERE application_message_id = application_message_id_;

   head_.application_message_id := new_id_;
   head_.seq_no                 := new_id_;
   head_.parent_message_id      := application_message_id_;
   head_.tag                    := NULL;
   head_.rowversion             := 1;
   head_.rowkey                 := sys_guid();
   head_.created_by             := Fnd_Session_API.Get_Fnd_User;
   head_.created_date           := sysdate;
   head_.state_date             := sysdate;
   head_.initiated              := sysdate;
   head_.next_state             := NULL;
   head_.next_execution_time    := NULL;
   head_.error_text             := NULL;
   head_.state                  := Message_State_Types_API.DB_RELEASED;
   head_.created_timestamp      := systimestamp;

   INSERT INTO fndcn_application_message_tab VALUES head_;
   RETURN new_id_;
END Clone_Message_Header___;


FUNCTION Create_App_Server_Task___ (
   instance_name_    IN VARCHAR2,
   instance_type_    IN VARCHAR2,
   message_type_     IN VARCHAR2,
   receiver_         IN VARCHAR2,
   subject_suffix_   IN VARCHAR2,
   message_body_xml_ IN RAW,
   address_data_2_   IN VARCHAR2) RETURN NUMBER
IS
   new_id_ NUMBER := fndcn_message_seq.NEXTVAL;

   head_ fndcn_application_message_tab%ROWTYPE;
   body_ fndcn_message_body_tab%ROWTYPE;
   line_ fndcn_address_label_tab%ROWTYPE;

   subject_   VARCHAR2(2000);
   interface_ VARCHAR2(4000);
   operation_ VARCHAR2(4000);
BEGIN
   --
   -- Create application message subject from config instance description
   --
   IF instance_name_ = default_report_formatter_ THEN
      subject_ := default_report_formatter_;
   ELSE
      SELECT nvl(description, instance_name)
        INTO subject_
        FROM config_instance_tab
       WHERE group_name = group_name_task_templates_
         AND instance_name = instance_name_;
   END IF;
   IF subject_suffix_ IS NOT NULL THEN
      subject_ := subject_ || subject_suffix_;
   END IF;

   IF instance_type_ = instance_type_print_agent_ THEN
      interface_ := 'PrintAgentHandler';
      operation_ := 'ProcessJob';
   END IF;

   --
   -- Copy general task template parameters to application_message header and address line
   --
   IF instance_name_ = default_report_formatter_ THEN
      head_.queue      := 'DEFAULT';
      head_.execute_as := 'System';
      head_.locale     := 'en-US';
   ELSE
      FOR param_ IN (SELECT parameter_name, parameter_value
                       FROM config_instance_param_tab
                      WHERE group_name = group_name_task_templates_
                        AND instance_name = instance_name_
                        AND parameter_name IN ('QUEUE', 'EXECUTE_AS', 'LOCALE', 'DEBUG_URL'))
      LOOP
         IF param_.parameter_name = 'QUEUE' THEN
            head_.queue := param_.parameter_value;
         ELSIF param_.parameter_name = 'EXECUTE_AS' THEN
            head_.execute_as := param_.parameter_value;
         ELSIF param_.parameter_name = 'LOCALE' THEN
            head_.locale := param_.parameter_value;
         ELSIF param_.parameter_name = 'DEBUG_URL' AND instance_type_ = instance_type_print_agent_ AND param_.parameter_value IS NOT NULL THEN
            interface_ := 'ExternalPrintAgent';
         END IF;
      END LOOP;
   END IF;

   head_.application_message_id := new_id_;
   head_.seq_no                 := new_id_;
   head_.rowversion             := 1;
   head_.rowkey                 := sys_guid();
   head_.created_by             := Fnd_Session_API.Get_Fnd_User;
   head_.created_date           := sysdate;
   head_.state_date             := sysdate;
   head_.initiated              := sysdate;
   head_.created_timestamp      := systimestamp;
   head_.state                  := Message_State_Types_API.DB_RELEASED;
   head_.receiver               := receiver_;      -- PrintAgent:IFSAPP
   head_.message_type           := message_type_;  -- PrintAgent:REPORTING
   head_.message_function       := instance_type_;
   head_.subject                := subject_;
   head_.inbound                := 0;
   INSERT INTO fndcn_application_message_tab VALUES head_;

   body_.application_message_id := new_id_;
   body_.seq_no                 := 0;
   body_.rowversion             := 1;
   body_.rowkey                 := sys_guid();
   body_.body_type              := 'XML';
   body_.reply                  := 0;
   body_.message_value          := message_body_xml_;
   INSERT INTO fndcn_message_body_tab VALUES body_;

   line_.application_message_id := new_id_;
   line_.seq_no                 := 0;
   line_.rowversion             := 1;
   line_.rowkey                 := sys_guid();
   line_.state                  := 'Released';
   line_.transport_connector    := 'InternalOperation';
   line_.address_data           := interface_ || ':' || operation_;
   line_.address_data_2         := address_data_2_; -- PrintAgent:fndext
   line_.sub_system             := 'CONNECT';
   line_.receiver               := 'CONNECT';
   line_.response               := 0;
   INSERT INTO fndcn_address_label_tab VALUES line_;

   RETURN new_id_;
END Create_App_Server_Task___;


FUNCTION Create_Print_Agent_Task___ (
   instance_name_ IN VARCHAR2,
   print_job_id_  IN NUMBER) RETURN NUMBER
IS
   xml_ RAW(32767);
BEGIN
   xml_ := Create_App_Server_Task_Xml___
             (document_name_    => 'PRINT_AGENT',
              document_package_ => 'ConnectAdministration',
              instance_name_    => instance_name_,
              id_name_          => 'PRINT_JOB_ID',
              id_value_         => print_job_id_);

   RETURN Create_App_Server_Task___
            (instance_name_    => instance_name_,
             instance_type_    => instance_type_print_agent_,
             message_type_     => 'REPORTING',
             receiver_         => 'IFSAPP',
             subject_suffix_   => ' (Print Job ' || print_job_id_ || ')',
             message_body_xml_ => xml_,
             address_data_2_   => 'fndext');
END Create_Print_Agent_Task___;


--
-- Validate current state and optionally set new state on application message
--
PROCEDURE Check_And_Set_Message_State___ (
   method_name_            IN VARCHAR2,
   application_message_id_ IN NUMBER,
   new_state_              IN VARCHAR2,
   current_state1_         IN VARCHAR2,
   current_state2_         IN VARCHAR2 DEFAULT NULL,
   current_state3_         IN VARCHAR2 DEFAULT NULL)
IS
   info_           VARCHAR2(2000);
   objid_          VARCHAR2(2000);
   objversion_     VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   state_db_       VARCHAR2(100);
   allowed_states_ VARCHAR2(2000);
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Calling operation [' || method_name_ || '] on application message [' || application_message_id_ || ']');
   --
   -- Check current message state
   --
   BEGIN
      SELECT objid, objversion, state_db
      INTO   objid_, objversion_, state_db_
      FROM   application_message
      WHERE  application_message_id = application_message_id_;
   EXCEPTION
      WHEN no_data_found THEN
         Error_SYS.Record_Not_Exist(Application_Message_API.lu_name_, p1_ => application_message_id_);
   END;
   IF state_db_ = current_state1_ OR state_db_ = current_state2_ OR state_db_ = current_state3_ THEN
      NULL;
   ELSE
      allowed_states_ := current_state1_;
      IF current_state2_ IS NOT NULL THEN
         allowed_states_ := allowed_states_ || ', ' || current_state2_;
      END IF;
      IF current_state3_ IS NOT NULL THEN
         allowed_states_ := allowed_states_ || ', ' || current_state3_;
      END IF;
      Error_SYS.Appl_General(lu_name_, 'CHANGESTATE: Operation [' || method_name_ || '] cannot be executed on application message [:P1] in state [:P2]. This operation is allowed only for messages in state [:P3].', application_message_id_, state_db_, allowed_states_);
   END IF;
   --
   -- Set new message state
   --
   IF new_state_ IS NOT NULL THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('STATE_DB', new_state_, attr_);
      Application_Message_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
END Check_And_Set_Message_State___;


--
-- Remove all address lines (and the corresponding message bodies)
--
PROCEDURE Remove_Address_Lines___ (
   application_message_id_ IN NUMBER)
IS
   info_       VARCHAR2(2000);
BEGIN
   FOR l_ IN (SELECT objid, objversion
                FROM address_label
               WHERE application_message_id = application_message_id_)
   LOOP
      Address_Label_API.Remove__(info_, l_.objid, l_.objversion, 'DO');
   END LOOP;
END Remove_Address_Lines___;


--
-- Release address lines beeing in specified current state
--
PROCEDURE Release_Address_Lines___ (
   application_message_id_ IN NUMBER,
   current_state_          IN VARCHAR2 DEFAULT NULL)
IS
   info_ VARCHAR2(2000);
   attr_ VARCHAR2(32000);
BEGIN
   FOR l_ IN (SELECT objid, objversion, state_db
                FROM address_label
               WHERE application_message_id = application_message_id_
                 AND (current_state_ IS NULL OR state = current_state_))
   LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('STATE_DB', Address_Label_State_API.DB_RELEASED, attr_);
      Client_SYS.Add_To_Attr('RETRIED_COUNT', '', attr_);
	  Client_SYS.Add_To_Attr('ERROR_TEXT', '', attr_);
      Address_Label_API.Modify__(info_, l_.objid, l_.objversion, attr_, 'DO');
   END LOOP;
END Release_Address_Lines___;


PROCEDURE Get_Queue_Parameters___ (
   queue_          IN  VARCHAR2,
   execution_mode_ OUT VARCHAR2,
   queue_stopped_  OUT BOOLEAN,
   priority_       OUT NUMBER,
   thread_count_   OUT NUMBER) IS
BEGIN
   execution_mode_ := 'InParallel';
   queue_stopped_  := FALSE;
   priority_       := NULL;
   thread_count_   := NULL;
   FOR p_ IN (SELECT parameter_name, parameter_value
               FROM config_instance_param_tab
              WHERE group_name = group_name_message_queues_
                AND instance_name = queue_
                AND parameter_name IN (parameter_name_execution_mode_, parameter_name_stop_queue_, parameter_name_priority_, parameter_thread_count_))
   LOOP
      IF p_.parameter_name = parameter_name_execution_mode_ THEN
         execution_mode_ := p_.parameter_value;
      ELSIF p_.parameter_name = parameter_name_stop_queue_ THEN
         IF lower(p_.parameter_value) = 'true' THEN
            queue_stopped_ := TRUE;
         END IF;
      ELSIF p_.parameter_name = parameter_name_priority_ THEN
         priority_ := to_number(p_.parameter_value);
      ELSIF p_.parameter_name = parameter_thread_count_ THEN
         thread_count_ := to_number(p_.parameter_value);
      END IF;
   END LOOP;
END Get_Queue_Parameters___;


FUNCTION Find_Report_Formatter___ (
   printer_id_           IN VARCHAR2,
   instance_name_prefix_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   instance_name_ VARCHAR2(50) := NULL;
BEGIN
   DECLARE
      --
      -- Find matching formatter. Prefer internal to external formatter. Choose in alphabetic order if many matches.
      --
      CURSOR c_ IS
      SELECT D.instance_name
        FROM config_instance_param_tab D, printer_mapping_tab P, config_instance_tab I
       WHERE P.logical_printer_id = printer_id_
         AND D.group_name = group_name_task_templates_
         AND D.instance_name = P.template_instance_name
         AND D.parameter_name = 'DEBUG_URL'
         AND I.group_name = D.group_name
         AND I.instance_name = D.instance_name
         AND I.instance_type = instance_type_print_agent_
         AND (instance_name_prefix_ IS NULL OR instr(D.instance_name, instance_name_prefix_) = 1)
      ORDER BY decode(D.parameter_value, NULL, 1, 2), D.instance_name;
   BEGIN
      OPEN c_;
      FETCH c_ INTO instance_name_;
      CLOSE c_;
   END;

   IF instance_name_ IS NULL THEN
      DECLARE
         --
         -- Find first formatter in alphabetic order. Prefer internal to external formatter.
         --
         CURSOR c_ IS
         SELECT P.instance_name
           FROM config_instance_param_tab P, config_instance_tab I
          WHERE P.group_name = group_name_task_templates_
            AND I.group_name = P.group_name
            AND I.instance_name = P.instance_name
            AND I.instance_type = instance_type_print_agent_
            AND P.parameter_name = 'DEBUG_URL'
            AND (instance_name_prefix_ IS NULL OR instr(P.instance_name, instance_name_prefix_) = 1)
         ORDER BY decode(P.parameter_value, NULL, 1, 2), P.instance_name;
      BEGIN
         OPEN c_;
         FETCH c_ INTO instance_name_;
         CLOSE c_;
      END;
   END IF;

   RETURN instance_name_;
END Find_Report_Formatter___;


--
-- Use temporary table to trigger one JMS message per transaction and specified parameters
--
PROCEDURE Send_Config_Param_Jms___ (
   group_name_    IN VARCHAR2,
   instance_name_ IN VARCHAR2,
   jms_method_    IN VARCHAR2) IS
BEGIN
   INSERT INTO config_param_distinct_jms_tab(group_name, instance_name, jms_method, transaction_id)
   VALUES (group_name_, instance_name_, jms_method_, Dbms_Transaction.Local_Transaction_Id);
EXCEPTION
   WHEN dup_val_on_index THEN
      NULL;
END Send_Config_Param_Jms___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

--
-- Generate MESSAGE_QUEUE_STOPPED event
--
PROCEDURE Raise_Queue_Stopped_Event_ (
   queue_ IN VARCHAR2)
IS
   msg_      VARCHAR2(32000);
   fnd_user_ VARCHAR2(30);
BEGIN
   IF (Event_SYS.Event_Enabled(lu_name_, 'MESSAGE_QUEUE_STOPPED')) THEN
       msg_ := Message_SYS.Construct('MESSAGE_QUEUE_STOPPED');
       ---
       --- Standard event parameters
       ---
       fnd_user_ := Fnd_Session_API.Get_Fnd_User;
       Message_SYS.Add_Attribute(msg_, 'EVENT_DATETIME', sysdate);
       Message_SYS.Add_attribute(msg_, 'USER_IDENTITY',  fnd_user_);
       Message_SYS.Add_attribute(msg_, 'USER_DESCRIPTION',  Fnd_User_API.Get_Description(fnd_user_));
       Message_SYS.Add_attribute(msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
       Message_SYS.Add_attribute(msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));
       ---
       --- Event specific parameters
       ---
       Message_SYS.Add_Attribute(msg_, 'QUEUE', queue_);
       --
       -- Generate event
       --
       Event_SYS.Event_Execute(lu_name_, 'MESSAGE_QUEUE_STOPPED', msg_);
    END IF;
END Raise_Queue_Stopped_Event_;


--
-- Generate MISSING_APPLICATION_MESSAGE event
--
PROCEDURE Raise_Missing_App_Msg_Event_ (
   application_message_id_ IN NUMBER)
IS
   msg_      VARCHAR2(32000);
   fnd_user_ VARCHAR2(30);
BEGIN
   IF (Event_SYS.Event_Enabled(lu_name_, 'MISSING_APPLICATION_MESSAGE')) THEN
       msg_ := Message_SYS.Construct('MISSING_APPLICATION_MESSAGE');
       ---
       --- Standard event parameters
       ---
       fnd_user_ := Fnd_Session_API.Get_Fnd_User;
       Message_SYS.Add_Attribute(msg_, 'EVENT_DATETIME', sysdate);
       Message_SYS.Add_attribute(msg_, 'USER_IDENTITY',  fnd_user_);
       Message_SYS.Add_attribute(msg_, 'USER_DESCRIPTION',  Fnd_User_API.Get_Description(fnd_user_));
       Message_SYS.Add_attribute(msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
       Message_SYS.Add_attribute(msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));
       ---
       --- Event specific parameters
       ---
       Message_SYS.Add_Attribute(msg_, 'APPLICATION_MESSAGE_ID', application_message_id_);
       --
       -- Generate event
       --
       Event_SYS.Event_Execute(lu_name_, 'MISSING_APPLICATION_MESSAGE', msg_);
    END IF;
END Raise_Missing_App_Msg_Event_;


--
-- Called from trigger on FNDCN_APPLICATION_MESSAGE_TAB
--
PROCEDURE Application_Message_Released_ (
   queue_                  IN     VARCHAR2,
   state_                  IN OUT VARCHAR2,
   queue_thread_no_        IN OUT NUMBER,
   application_message_id_ IN     NUMBER,
   tag_                    IN     VARCHAR2)
IS
   execution_mode_             VARCHAR2(50);
   queue_stopped_              BOOLEAN;
   priority_                   NUMBER;
   thread_count_               NUMBER;
   restricted_queue_thread_no_ NUMBER := NULL;
   restricted_queue_           BOOLEAN;
BEGIN
   -- Do nothing for system queues ERROR and TRASHCAN
   IF queue_ IN ('ERROR', 'TRASHCAN') THEN
      RETURN;
   END IF;

   -- Read EXECUTION_MODE, STOP_QUEUE, PRIORITY and THREAD_COUNT configuration parameters
   Get_Queue_Parameters___(queue_, execution_mode_, queue_stopped_, priority_, thread_count_);
   IF tag_ = 'INVOKE' THEN
      execution_mode_ := 'Invoke';
   END IF;
   restricted_queue_ := lower(execution_mode_) IN ('inorder', 'insequence');

   IF queue_stopped_ THEN
      IF restricted_queue_ THEN
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'ApplicationMessage JMS Trigger: Released application_message [' || application_message_id_ || '] has been ignored, because restricted queue [' || queue_ || '] is stopped.');
      ELSE
         state_ := 'Suspended';
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'ApplicationMessage JMS Trigger: Released application_message [' || application_message_id_ || '] has been Suspended, because queue [' || queue_ || '] is stopped.');
      END IF;
      RETURN;
   END IF;

   IF restricted_queue_ THEN
      IF lower(execution_mode_) = 'insequence' AND thread_count_ >= 2 THEN
         restricted_queue_thread_no_ := trunc(Dbms_Random.Value(1, thread_count_ + 1));
         queue_thread_no_ := restricted_queue_thread_no_;
      ELSE
         queue_thread_no_ := NULL;
      END IF;
   ELSE
      state_ := 'Processing';
      queue_thread_no_ := NULL;
   END IF;

   IF execution_mode_ = 'Invoke' THEN
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'ApplicationMessage JMS Trigger: Skipped JMS message for application_message_id [' || application_message_id_ || ']   queue [' || queue_ || ']   execution_mode [' || execution_mode_);
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'ApplicationMessage JMS Trigger: application_message_id [' || application_message_id_ || ']   queue [' || queue_ || ']   execution_mode [' || execution_mode_ || ']   restricted_queue_thread_no [' || restricted_queue_thread_no_ || ']   priority [' || priority_ || ']');
      Batch_Processor_Jms_API.Send_Jms_Message('ProcessMessage',
         queue_                      => queue_,
         application_message_id_     => application_message_id_,
         execution_mode_             => execution_mode_,
         restricted_queue_thread_no_ => restricted_queue_thread_no_,
         priority_                   => priority_);
   END IF;
END Application_Message_Released_;


--
-- Called from trigger on CONFIG_INSTANCE_PARAM_TAB
--
PROCEDURE Config_Parameter_Changed_ (
   group_name_     IN VARCHAR2,
   instance_name_  IN VARCHAR2,
   parameter_name_ IN VARCHAR2) IS
BEGIN
   Send_Config_Param_Jms___(group_name_, '*', 'ClearConfigCache');
   IF group_name_ = group_name_message_queues_ AND parameter_name_ IN (parameter_name_stop_queue_, parameter_name_execution_mode_) THEN
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'ConfigParameter JMS Trigger: Parameter [' || parameter_name_ || '] for Queue [' || instance_name_ || '] has been changed. Sending QueueParameterChanged message to Batch Processor JMS queue.');
      Batch_Processor_Jms_API.Send_Jms_Message('QueueParameterChanged', queue_ => instance_name_, parameter_name_ => parameter_name_);
   END IF;
   IF group_name_ = group_name_connector_readers_ AND parameter_name_ = 'ENABLED' THEN
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'ConfigParameter JMS Trigger: Parameter ENABLED changed for Connector Reader [' || instance_name_ || ']. Sending SynchronizeReader message to Batch Processor JMS queue.');
      Batch_Processor_Jms_API.Send_Jms_Message('SynchronizeReader', instance_name_ => instance_name_);
   END IF;
END Config_Parameter_Changed_;


--
-- Performs different actions depending on changed queue parameter: STOP_QUEUE or EXECUTION_MODE. Called from MDB.
--
PROCEDURE Queue_Parameter_Changed_ (
   queue_          IN VARCHAR2,
   parameter_name_ IN VARCHAR2)
IS
   parameter_value_ VARCHAR2(200);
BEGIN
   BEGIN
      SELECT lower(parameter_value)
        INTO parameter_value_
        FROM config_instance_param_tab
       WHERE group_name = group_name_message_queues_
         AND instance_name  = queue_
         AND parameter_name = parameter_name_;
   EXCEPTION
      WHEN no_data_found THEN
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Queue [' || queue_ || '] not found. Call to App_Message_Processing_API.Queue_Parameter_Changed_ ignored.');
         RETURN;
   END;

   IF parameter_name_ = parameter_name_stop_queue_ THEN
      IF parameter_value_ IS NULL OR parameter_value_ ='false' THEN
         Release_Suspended_Messages_(queue_);
      ELSIF parameter_value_ = 'true' THEN
         Raise_Queue_Stopped_Event_(queue_);
      END IF;
   ELSIF parameter_name_ = parameter_name_execution_mode_ THEN
      IF parameter_value_ = 'inparallel' THEN
         Release_Application_Messages_(queue_);
      END IF;
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Parameter [' || parameter_name_ || '] for Queue [' || queue_ || '] ignored by App_Message_Processing_API.Queue_Parameter_Changed_.');
   END IF;
END Queue_Parameter_Changed_;


--
-- Called from trigger on temporary table CONFIG_PARAM_DISTINCT_JMS_TAB
--
PROCEDURE Config_Param_Jms_Changed_ (
   group_name_    IN VARCHAR2,
   instance_name_ IN VARCHAR2,
   jms_method_    IN VARCHAR2)
IS
   send_instance_name_ VARCHAR2(50) := CASE instance_name_ = '*' WHEN TRUE THEN NULL ELSE instance_name_ END;
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'ConfigParamDistinctJms JMS Trigger: Sending message to Batch Processor JMS queue: method [' || jms_method_ || ']   group_name [' || group_name_ || ']   instance_name [' || send_instance_name_ || ']');
   Batch_Processor_Jms_API.Send_Jms_Message(jms_method_, group_name_ => group_name_, instance_name_ => send_instance_name_);
END Config_Param_Jms_Changed_;


--
-- Synchronizes EJB Timers in WebLogic with Connector Readers configuration in Setup IFS Connect.
--
PROCEDURE Synchronize_Connector_Readers IS
   method_ CONSTANT VARCHAR2(50) := 'SynchronizeReaders';
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Sending [' || method_ || '] message to Batch Processor JMS queue.');
   Batch_Processor_Jms_API.Send_Jms_Message(method_);
END Synchronize_Connector_Readers;


--
-- For a restricted (InOrder or InSequence) queue:
--    send JSM message(s) to process all released messages,
-- Otherwise (InParallel):
---   if the queue is started then release suspended messages, in chunks.
--
PROCEDURE Release_Suspended_Messages_ (
   queue_ IN VARCHAR2)
IS
   info_  VARCHAR2(2000);
   attr_  VARCHAR2(32000);
   count_ NUMBER := 0;
   execution_mode_ VARCHAR2(50);
   queue_stopped_  BOOLEAN;
   priority_       NUMBER;
   thread_count_   NUMBER;
   chunk_ CONSTANT NUMBER := 500;
BEGIN
   Get_Queue_Parameters___(queue_, execution_mode_, queue_stopped_, priority_, thread_count_);
   CASE lower(execution_mode_)
      WHEN 'insequence' THEN
         IF thread_count_ IS NULL THEN
            --
            -- Send one JMS message without restricted_queue_thread_no.
            --
            Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Sending JMS message ProcessMessage to process all released messages on InSequence queue [' || queue_ || ']');
            Batch_Processor_Jms_API.Send_Jms_Message('ProcessMessage', queue_ => queue_, execution_mode_ => execution_mode_, priority_ => priority_);
         ELSE
            --
            -- Send one JMS message per thread accorning to currently configured THREAD_COUNT
            --
            FOR no_ IN 1 .. thread_count_ LOOP
               Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Sending JMS message ProcessMessage to process all released messages on InSequence queue [' || queue_ || ':' || no_ || ']');
               Batch_Processor_Jms_API.Send_Jms_Message('ProcessMessage', queue_ => queue_, execution_mode_ => execution_mode_, restricted_queue_thread_no_ => no_, priority_ => priority_);
            END LOOP;
            --
            -- Send one JMS message per distinct APPLICATION_MESSAGE.QUEUE_THREAD_NO which is NULL or is greater than configured THREAD_COUNT
            --
            FOR am_ IN (SELECT DISTINCT queue_thread_no
                          FROM application_message
                         WHERE queue = queue_
                           AND (queue_thread_no IS NULL OR queue_thread_no > thread_count_)
                           AND state_db IN (Message_State_Types_API.DB_RELEASED, Message_State_Types_API.DB_PROCESSING))
            LOOP
               Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Sending JMS message ProcessMessage to process all released messages on InSequence queue [' || queue_ || ':' || am_.queue_thread_no || ']');
               Batch_Processor_Jms_API.Send_Jms_Message('ProcessMessage', queue_ => queue_, execution_mode_ => execution_mode_, restricted_queue_thread_no_ => am_.queue_thread_no, priority_ => priority_);
            END LOOP;
         END IF;

      WHEN 'inorder' THEN
         --
         -- Send one JMS message without restricted_queue_thread_no.
         --
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Sending JMS message ProcessMessage to process all released messages on InOrder queue [' || queue_ || ']');
         Batch_Processor_Jms_API.Send_Jms_Message('ProcessMessage', queue_ => queue_, execution_mode_ => execution_mode_, priority_ => priority_);

      WHEN 'inparallel' THEN
         IF queue_stopped_ THEN
            Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Queue [ ' || queue_ || ' has been stopped. Call to Release_Suspended_Messages_ ignored.');
            RETURN;
         END IF;

         FOR a_ IN (SELECT objid, objversion, state_db, application_message_id
                     FROM application_message
                    WHERE queue = queue_
                      AND state_db = Message_State_Types_API.DB_SUSPENDED)
         LOOP
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('STATE_DB', Message_State_Types_API.DB_RELEASED, attr_);
            Application_Message_API.Modify__(info_, a_.objid, a_.objversion, attr_, 'DO');
            Release_Address_Lines___(a_.application_message_id, Address_Label_State_API.DB_RETRY);
            count_ := count_ + 1;
            EXIT WHEN count_ = chunk_;
         END LOOP;
         Log_SYS.Fnd_Trace_(Log_SYS.info_, '[' || count_ || '] suspended messages have been released on queue [' || queue_ || ']');
         IF count_ = chunk_ THEN
            Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Sending JMS message to continue releasing of suspended messages on queue [' || queue_ || '] in another chunk.');
            Batch_Processor_Jms_API.Send_Jms_Message('ReleaseSuspendedMessages', queue_ => queue_);
         END IF;
   END CASE;
END Release_Suspended_Messages_;


--
-- Release specified print according to report formatter configuration.
-- Called from trigger on PRINT_JOB_TAB.
--
PROCEDURE Release_Print_Job_ (
   print_job_id_       IN NUMBER,
   perform_printer_id_ IN VARCHAR2)
IS
   printer_id_    VARCHAR2(250) := substr(perform_printer_id_, instr(perform_printer_id_, ',', 1, 2) + 1);
   report_title_  VARCHAR2(50)  := Print_Job_Contents_API.Get_Report_Title(print_job_id_);
   new_id_        NUMBER;
   instance_name_ VARCHAR2(50) := NULL;
BEGIN
   IF report_title_ = 'Connect Test' THEN
      instance_name_ := Find_Report_Formatter___(printer_id_, 'CONNTEST_');
   END IF;

   IF instance_name_ IS NULL THEN
      instance_name_ := Find_Report_Formatter___(printer_id_);
   END IF;

   IF instance_name_ IS NULL THEN
      instance_name_ := default_report_formatter_;
   END IF;

   new_id_ := Create_Print_Agent_Task___(instance_name_, print_job_id_);
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Released print job [' || print_job_id_ || '] on printer [' || printer_id_ || '] using application message [' || new_id_ || '] and report formatter [' || instance_name_ || ']');
END Release_Print_Job_;


--
-- Release all print jobs in state WAITING.
--
PROCEDURE Release_Print_Jobs_ IS
BEGIN
   FOR job_ IN (SELECT print_job_id, printer_id FROM print_job WHERE status_db = Print_Job_Status_API.DB_WAITING ORDER BY 1) LOOP
      Release_Print_Job_(job_.print_job_id, job_.printer_id);
   END LOOP;
END Release_Print_Jobs_;


--
-- Re-release application messages that could have been released while Application_Message_Jms_TR was disabled
--
PROCEDURE Release_Application_Messages_ (
   queue_ IN VARCHAR2 DEFAULT '%')
IS
   info_  VARCHAR2(2000);
   attr_  VARCHAR2(32000);
   count_ NUMBER := 0;
BEGIN
   FOR a_ IN (SELECT objid, objversion, application_message_id, queue
               FROM application_message
              WHERE queue LIKE queue_
                AND state_db = Message_State_Types_API.DB_RELEASED)
   LOOP
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Rereleasing application message [' || a_.application_message_id || '] on queue [' || a_.queue || ']');
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('STATE_DB', Message_State_Types_API.DB_RELEASED, attr_);
      Application_Message_API.Modify__(info_, a_.objid, a_.objversion, attr_, 'DO');
      count_ := count_ + 1;
   END LOOP;
   Log_SYS.Fnd_Trace_(Log_SYS.info_, '[' || count_ || '] messages have been rereleased');
END Release_Application_Messages_;


FUNCTION Is_Queue_Stopped_ (
   queue_ VARCHAR2) RETURN VARCHAR2
IS
   value_ VARCHAR2(4000);
BEGIN
   SELECT upper(parameter_value)
     INTO value_
     FROM config_instance_param_tab
    WHERE group_name = group_name_message_queues_
      AND instance_name  = queue_
      AND parameter_name = parameter_name_stop_queue_;

     RETURN value_;
END Is_Queue_Stopped_;


PROCEDURE Set_Processing_ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2)
IS
   info_   VARCHAR2(2000);
   objver_ VARCHAR2(2000) := objversion_;
   attr_   VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('STATE_DB', Message_State_Types_API.DB_PROCESSING, attr_);
   Application_Message_API.Modify__(info_, objid_, objver_, attr_, 'DO');
END Set_Processing_;


PROCEDURE Set_Error_ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2,
   error_text_ IN VARCHAR2)
IS
   info_   VARCHAR2(2000);
   objver_ VARCHAR2(2000) := objversion_;
   attr_   VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('STATE_DB', Message_State_Types_API.DB_FAILED, attr_);
   Client_SYS.Add_To_Attr('ERROR_TEXT', error_text_, attr_);
   Application_Message_API.Modify__(info_, objid_, objver_, attr_, 'DO');
END Set_Error_;


FUNCTION Lock_Restricted_Queue_ (
   queue_type_      IN VARCHAR2,
   queue_name_      IN VARCHAR2,
   queue_thread_no_ IN NUMBER) RETURN VARCHAR2
IS
   resource_busy_ EXCEPTION;
   PRAGMA EXCEPTION_INIT(resource_busy_, -54);
   tmp_ NUMBER;
BEGIN
   SELECT NULL
     INTO tmp_
     FROM fndcn_restricted_queue_key_tab
    WHERE queue_type = queue_type_
      AND queue_name = queue_name_
      AND queue_thread_no = queue_thread_no_
   FOR UPDATE NOWAIT;
   RETURN 'TRUE';
EXCEPTION
   WHEN resource_busy_ THEN
      RETURN 'FALSE';
   WHEN no_data_found THEN
      BEGIN
         INSERT INTO fndcn_restricted_queue_key_tab (queue_type, queue_name, queue_thread_no)
         VALUES (queue_type_, queue_name_, queue_thread_no_);
         RETURN 'TRUE';
      EXCEPTION
         WHEN dup_val_on_index THEN
            RETURN 'FALSE';
      END;
END Lock_Restricted_Queue_;


FUNCTION Lock_Reader_Timer_ (
   reader_name_ IN VARCHAR2,
   timestamp_   IN NUMBER,
   server_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   resource_busy_ EXCEPTION;
   PRAGMA EXCEPTION_INIT(resource_busy_, -54);
   old_ NUMBER;
BEGIN
   SELECT timestamp
     INTO old_
     FROM fndcn_reader_timers_tab
    WHERE reader_name = reader_name_
   FOR UPDATE NOWAIT;
   IF timestamp_ - old_ > 29000 THEN
      UPDATE fndcn_reader_timers_tab
         SET timestamp = timestamp_,
             server_name = server_name_
       WHERE reader_name = reader_name_;
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
EXCEPTION
   WHEN resource_busy_ THEN
      RETURN 'FALSE';
   WHEN no_data_found THEN
      BEGIN
         INSERT INTO fndcn_reader_timers_tab (reader_name, timestamp, server_name)
         VALUES (reader_name_, timestamp_, server_name_);
         RETURN 'TRUE';
      EXCEPTION
         WHEN dup_val_on_index THEN
            RETURN 'FALSE';
      END;
END Lock_Reader_Timer_;


PROCEDURE Routing_Rule_Changed_ (
   rule_name_   IN VARCHAR2,
   enabled_new_ IN NUMBER,
   enabled_old_ IN NUMBER)
IS
BEGIN
   IF nvl(enabled_new_, 0) = 1 OR nvl(enabled_old_, 0) = 1 THEN
      -- clear routing cache, but only if the rule is/was enabled
      Send_Config_Param_Jms___('Routing', '*', 'ClearConfigCache');
   END IF;
END Routing_Rule_Changed_;


PROCEDURE Routing_Rule_Det_Changed_ (
   rule_name_ IN VARCHAR2)
IS
   enabled_ NUMBER;
BEGIN
   SELECT enabled
     INTO enabled_
     FROM routing_rule_tab
    WHERE rule_name = rule_name_;

   IF nvl(enabled_, 0) = 1 THEN
      -- clear routing cache, but only if the rule is enabled
      Send_Config_Param_Jms___('Routing', '*', 'ClearConfigCache');
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      NULL;
END Routing_Rule_Det_Changed_;


PROCEDURE Routing_Addr_Runtime_Changed_ (
   address_name_ IN VARCHAR2)
IS
   rule_name_ VARCHAR2(500);
BEGIN
   SELECT R.rule_name
     INTO rule_name_
     FROM routing_rule_tab R, routing_rule_address_tab A
    WHERE R.rule_name = A.rule_name
      AND A.address_name = address_name_
      AND nvl(R.enabled, 0) = 1
    FETCH FIRST 1 ROW ONLY;

    -- clear routing cache, but only if the address is used by enabled rule(s)
    Send_Config_Param_Jms___('Routing', '*', 'ClearConfigCache');
EXCEPTION
   WHEN no_data_found THEN
      NULL;
END Routing_Addr_Runtime_Changed_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Run_Application_Server_Task (
   application_message_id_ IN NUMBER,
   one_time_task_          IN VARCHAR2)
IS
   info_           VARCHAR2(2000);
   objid_          VARCHAR2(2000);
   objversion_     VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   state_db_       VARCHAR2(100);
   next_state_db_  VARCHAR2(100);
   schedule_id_    NUMBER;
   next_exec_time_ DATE;
BEGIN
   --
   -- Check if application message is in state WAITING
   --
   BEGIN
      SELECT objid, objversion, state_db
      INTO   objid_, objversion_, state_db_
      FROM   application_message
      WHERE  application_message_id = application_message_id_;
   EXCEPTION
      WHEN no_data_found THEN
         Error_SYS.Record_Not_Exist(Application_Message_API.lu_name_, p1_ => application_message_id_);
   END;
   --
   -- Compute next execution time and next state
   --
   IF one_time_task_ = 'TRUE' THEN
      schedule_id_ := Fnd_Context_SYS.Get_Number_Value('CURRENT_SCHEDULE_ID');
   ELSE
      schedule_id_ := Fnd_Context_SYS.Find_Number_Value('CURRENT_SCHEDULE_ID');
   END IF;
   IF schedule_id_ IS NOT NULL THEN
      next_exec_time_ := Compute_Next_Execution_Time___(schedule_id_);
      IF next_exec_time_ IS NULL THEN
         next_state_db_ := Message_State_Types_API.DB_FINISHED;
      ELSE
         next_state_db_ := Message_State_Types_API.DB_WAITING;
      END IF;
   END IF;
   IF state_db_ = Message_State_Types_API.DB_WAITING THEN
      --
      -- Release application message
      --
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('STATE_DB', Message_State_Types_API.DB_RELEASED, attr_);
      IF schedule_id_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('NEXT_STATE_DB', next_state_db_, attr_);
         Client_SYS.Add_To_Attr('NEXT_EXECUTION_TIME', next_exec_time_, attr_);
      END IF;
      Application_Message_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
      --
      -- Release address lines: all lines for ordinary scheduled task, RETRY lines for one-time task
      --
      FOR l_ IN (SELECT objid, objversion, state_db
                   FROM address_label
                  WHERE application_message_id = application_message_id_)
      LOOP
         IF one_time_task_ = 'FALSE' OR l_.state_db = Address_Label_State_API.DB_RETRY THEN
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('STATE_DB', Address_Label_State_API.DB_RELEASED, attr_);
            Address_Label_API.Modify__(info_, l_.objid, l_.objversion, attr_, 'DO');
         END IF;
      END LOOP;
   END IF;
   --
   -- Remove batch schedule for one-time task
   --
   IF one_time_task_ = 'TRUE' THEN
      Batch_SYS.Remove_Batch_Schedule_Param(schedule_id_, 1);
      Batch_SYS.Remove_Batch_Schedule_Param(schedule_id_, 2);
      Batch_SYS.Remove_Batch_Schedule(schedule_id_);
   END IF;
END Run_Application_Server_Task;


PROCEDURE Schedule_One_Time_Task (
   application_message_id_ IN NUMBER,
   execution_time_         IN DATE)
IS
BEGIN
   Schedule_App_Server_Task (
      application_message_id_ => application_message_id_,
      schedule_name_          => 'Retry application message ' || application_message_id_,
      execution_time_         => execution_time_,
      execution_plan_         => 'FREQ=HOURLY;INTERVAL=999',
      stop_date_              => execution_time_,
      one_time_task_          => 'TRUE');
END Schedule_One_Time_Task;


PROCEDURE Schedule_App_Server_Task (
   application_message_id_ IN NUMBER,
   schedule_name_          IN VARCHAR2,
   execution_time_         IN DATE,
   execution_plan_         IN VARCHAR2,
   stop_date_              IN DATE     DEFAULT NULL,
   one_time_task_          IN VARCHAR2 DEFAULT 'FALSE')
IS
   schedule_id_          NUMBER;
   seq_no_               NUMBER;
   next_execution_date_  DATE := execution_time_;
   start_date_           DATE := execution_time_;
BEGIN
   Batch_SYS.New_Batch_Schedule (
      schedule_id_         => schedule_id_,
      next_execution_date_ => next_execution_date_,
      start_date_          => start_date_,
      stop_date_           => stop_date_,
      schedule_name_       => schedule_name_,
      method_              => 'APP_MESSAGE_PROCESSING_API.RUN_APPLICATION_SERVER_TASK',
      active_db_           => 'TRUE',
      execution_plan_      => execution_plan_);
   Batch_SYS.New_Batch_Schedule_Param (
      seq_no_       => seq_no_,
      schedule_id_  => schedule_id_,
      name_         => 'APPLICATION_MESSAGE_ID_',
      value_        => application_message_id_);
   Batch_SYS.New_Batch_Schedule_Param (
      seq_no_       => seq_no_,
      schedule_id_  => schedule_id_,
      name_         => 'ONE_TIME_TASK_',
      value_        => one_time_task_);
END Schedule_App_Server_Task;


--
-- Remove all address lines (with corresponding message bodies) and change application message state from Failed to Released
--
PROCEDURE Reroute_Message (
   application_message_id_ IN NUMBER)
IS
   message_type_ VARCHAR2(200);
BEGIN
   Check_And_Set_Message_State___('Reroute', application_message_id_, Message_State_Types_API.DB_RELEASED,
                                                                      Message_State_Types_API.DB_FAILED, Message_State_Types_API.DB_RELEASED);
   SELECT message_type
     INTO message_type_
     FROM application_message
    WHERE application_message_id = application_message_id_;

   IF message_type_ = 'Background Job' THEN
      Error_SYS.Appl_General(lu_name_, 'REROUTE_BACKGROUND_JOB: Reroute is not allowed for background job [' || application_message_id_ || ']');
   END IF;

   Remove_Address_Lines___(application_message_id_);
END Reroute_Message;


--
-- Release all address lines and change application message state from Failed or Cancelled to Released
--
PROCEDURE Restart_Message_All_Addr (
   application_message_id_ IN NUMBER)
IS
BEGIN
   Check_And_Set_Message_State___('Restart All', application_message_id_, Message_State_Types_API.DB_RELEASED,
                                                                          Message_State_Types_API.DB_FAILED,
                                                                          Message_State_Types_API.DB_CANCELLED);
   Release_Address_Lines___(application_message_id_);
END Restart_Message_All_Addr;


--
-- Release Failed address lines and change application message state from Failed or Cancelled to Released
--
PROCEDURE Restart_Message_Failed_Addr (
   application_message_id_ IN NUMBER)
IS
BEGIN
   Check_And_Set_Message_State___('Restart Failed', application_message_id_, Message_State_Types_API.DB_RELEASED,
                                                                             Message_State_Types_API.DB_FAILED,
                                                                             Message_State_Types_API.DB_CANCELLED);
   Release_Address_Lines___(application_message_id_, Address_Label_State_API.DB_RETRY);
   Release_Address_Lines___(application_message_id_, Address_Label_State_API.DB_FAILED);
END Restart_Message_Failed_Addr;


--
-- Duplicate and release a Finished message without its address lines and reply message bodies
--
PROCEDURE Duplicate_And_Release_Message (
   application_message_id_ IN OUT NUMBER)
IS
   new_id_ NUMBER;
BEGIN
   Check_And_Set_Message_State___('Duplicate and Release', application_message_id_, NULL, Message_State_Types_API.DB_FINISHED);
   new_id_ := Clone_Message_Header___(application_message_id_);
   FOR body_ IN (SELECT * FROM fndcn_message_body_tab WHERE application_message_id = application_message_id_ AND address_seq_no IS NULL) LOOP
      body_.application_message_id := new_id_;
      body_.rowversion             := 1;
      body_.message_template       := NULL;
      body_.rowkey                 := sys_guid();
      INSERT INTO fndcn_message_body_tab VALUES body_;
   END LOOP;
   application_message_id_ := new_id_;
END Duplicate_And_Release_Message;


--
-- Change application message state from Suspended to Released
--
PROCEDURE Resume_Message (
   application_message_id_ IN NUMBER )
IS
BEGIN
   Check_And_Set_Message_State___('Resume', application_message_id_, Message_State_Types_API.DB_RELEASED,
                                                                     Message_State_Types_API.DB_SUSPENDED);
   Release_Address_Lines___(application_message_id_, Address_Label_State_API.DB_RETRY);
END Resume_Message;


--
-- Change application message state from Waiting to Suspended
--
PROCEDURE Suspend_Message (
   application_message_id_ IN NUMBER )
IS
BEGIN
   Check_And_Set_Message_State___('Suspend', application_message_id_, Message_State_Types_API.DB_SUSPENDED,
                                                                      Message_State_Types_API.DB_WAITING);
END Suspend_Message;


--
-- Change application message state from Failed, Waiting or Suspended to Cancelled
--
PROCEDURE Cancel_Message (
   application_message_id_ IN NUMBER )
IS
BEGIN
   Check_And_Set_Message_State___('Cancel', application_message_id_, Message_State_Types_API.DB_CANCELLED,
                                                                     Message_State_Types_API.DB_FAILED,
                                                                     Message_State_Types_API.DB_WAITING,
                                                                     Message_State_Types_API.DB_SUSPENDED);
END Cancel_Message;


--
-- Stop application message queue, if not already stopped.
-- This method is called from RestrictedQueueTask.java (MDB processing InOrder queues).
--
PROCEDURE Stop_Queue (
   queue_ IN VARCHAR2)
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   stopped_    VARCHAR2(100);
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Stoping application message queue [' || queue_ || ']');
   SELECT objid, objversion, upper(stop_queue)
     INTO objid_, objversion_, stopped_
     FROM connect_queue
    WHERE instance_name  = queue_;

   IF stopped_ = 'FALSE' THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('STOP_QUEUE', 'TRUE', attr_);
      Connect_Queue_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Queue [' || queue_ || '] already stopped');
   END IF;
END Stop_Queue;


--
-- Start application message queue.
--
PROCEDURE Start_Queue (
   queue_ IN VARCHAR2)
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   stopped_    VARCHAR2(100);
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Starting application message queue [' || queue_ || ']');
   SELECT objid, objversion, upper(stop_queue)
     INTO objid_, objversion_, stopped_
     FROM connect_queue
    WHERE instance_name  = queue_;
   IF stopped_ = 'TRUE' THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('STOP_QUEUE', 'FALSE', attr_);
      Connect_Queue_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Queue [' || queue_ || '] already started');
   END IF;
EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
END Start_Queue;


PROCEDURE Stop_All_Queues
IS
   info_                 VARCHAR2(2000);
   attr_                 VARCHAR2(32000);
   stopped_list_         VARCHAR2(32000);
   already_stopped_list_ VARCHAR2(32000);

   CURSOR c_ IS
      SELECT objid, objversion, instance_name, upper(stop_queue) stop_queue
        FROM connect_queue;
BEGIN
   FOR rec_ IN c_ LOOP
      Log_SYS.Fnd_Trace_(Log_SYS.trace_, 'Stoping queue [' || rec_.instance_name || ']');
      IF rec_.stop_queue <> 'TRUE' THEN
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('STOP_QUEUE', 'TRUE', attr_);
         Connect_Queue_API.Modify__(info_, rec_.objid, rec_.objversion, attr_, 'DO');
         stopped_list_ := CASE stopped_list_ IS NULL WHEN TRUE THEN '' ELSE stopped_list_ || chr(10) END || '  ' || rec_.instance_name;
      ELSE
         already_stopped_list_ := CASE already_stopped_list_ IS NULL WHEN TRUE THEN '' ELSE already_stopped_list_ || chr(10) END || '  ' || rec_.instance_name;
      END IF;
   END LOOP;
   Log_SYS.Fnd_Trace_(Log_SYS.info_, chr(10)
      || 'Stopped queues:' || chr(10) || stopped_list_ || chr(10)
      || 'Queues that have already been stopped:' || chr(10) || already_stopped_list_);
END Stop_All_Queues;


PROCEDURE Stop_All_Readers
IS
   info_                  VARCHAR2(2000);
   attr_                  VARCHAR2(32000);
   disabled_list_         VARCHAR2(32000);
   already_disabled_list_ VARCHAR2(32000);

   CURSOR c_ IS
      SELECT objid, objversion, instance_name, upper(enabled) enabled
        FROM connect_reader;
BEGIN
   FOR rec_ IN c_ LOOP
      Log_SYS.Fnd_Trace_(Log_SYS.trace_, 'Disabling reader [' || rec_.instance_name || ']');
      IF rec_.enabled <> 'FALSE' THEN
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('ENABLED', 'FALSE', attr_);
         Connect_Reader_API.Modify__(info_, rec_.objid, rec_.objversion, attr_, 'DO');
         disabled_list_ := CASE disabled_list_ IS NULL WHEN TRUE THEN '' ELSE disabled_list_ || chr(10) END || '  ' || rec_.instance_name;
      ELSE
         already_disabled_list_ := CASE already_disabled_list_ IS NULL WHEN TRUE THEN '' ELSE already_disabled_list_ || chr(10) END || '  ' || rec_.instance_name;
      END IF;
   END LOOP;
   Log_SYS.Fnd_Trace_(Log_SYS.info_, chr(10)
      || 'Disabled readers:' || chr(10) || disabled_list_ || chr(10)
      || 'Readers that have already been disabled:' || chr(10) || already_disabled_list_);
END Stop_All_Readers;


PROCEDURE Start_System_Queues IS
BEGIN
   Start_Queue('DEFAULT');
   Start_Queue('UNROUTED');
END Start_System_Queues;


@UncheckedAccess
FUNCTION Get_Config_Param (
   queue_      IN VARCHAR2,
   param_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   param_value_ VARCHAR2(4000);
BEGIN
   SELECT lower(parameter_value)
     INTO param_value_
     FROM config_instance_param_tab
    WHERE group_name = group_name_message_queues_
      AND instance_name  = queue_
      AND parameter_name = param_name_;

     RETURN param_value_;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN NULL;
END Get_Config_Param;


--
-- PROCEDURE Cleanup
--
--   Deletes application messages
--
-- Parameters:
--   list_of_queues_   a queue,                                    ie. 'IN1'
--                     a semicolon separated list of queues or     ie. 'IN1;'OU1;TRASHCAN'
--                     a queuename part followed by % sign         ie. 'REPL%'
--   list_of_states_   a state,                                    ie. 'Finished'
--                     a semicolon separeted list of states or     ie. 'Finished;Failed;'
--                     'Any' meaning all states
--   days_old_         number of days    a message must have been in present state before it can be deleted
--   hours_old_        number of hours   a message must have been in present state before it can be deleted
--   minutes_old_      number of minutes a message must have been in present state before it can be deleted
--   seconds_old_      number of seconds a message must have been in present state before it can be deleted
--   commit_count_     max number of rows in each transaction
--
--   commit_count_ affects memory and rollback space usage - a high value means a more efficient delete process
--   but a to high value may cause the process to fail if it runs out of rollback space or memory space
--
--   NOTE! Messages with TAG = BATCH are never touched
--
PROCEDURE Cleanup (
   list_of_queues_   IN VARCHAR2,
   list_of_states_   IN VARCHAR2,
   days_old_         IN NUMBER := 1,
   hours_old_        IN NUMBER := 0,
   minutes_old_      IN NUMBER := 0,
   seconds_old_      IN NUMBER := 0,
   commit_count_     IN NUMBER := 10000)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;

   CURSOR c_message_ids_ (states_ VARCHAR2,
                          queues_ VARCHAR2,
                          limit_  NUMBER) IS
      SELECT a.application_message_id,
            a.state_date,
             a.rowid
      FROM   fndcn_application_message_tab a
      WHERE  (a.queue IN (SELECT REGEXP_SUBSTR(queues_, '[^,;]+', 1, LEVEL)
                          FROM   dual
                          CONNECT BY REGEXP_SUBSTR(queues_, '[^,;]+', 1, LEVEL) IS NOT NULL)
         OR   a.queue LIKE queues_)
      AND    a.state IN (SELECT REGEXP_SUBSTR(states_, '[^,;]+', 1, LEVEL)
                         FROM   dual
                         CONNECT BY REGEXP_SUBSTR(states_, '[^,;]+', 1, LEVEL) IS NOT NULL)
      AND    (a.tag IS NULL OR a.tag <> 'BATCH')
      AND    a.state_date < SYSDATE - limit_/86400;

   CURSOR c_message_ids_any_state_ (queues_ VARCHAR2,
                                    limit_  NUMBER) IS
      SELECT a.application_message_id,
            a.state_date,
             a.rowid
      FROM   fndcn_application_message_tab a
      WHERE  (a.queue IN (SELECT REGEXP_SUBSTR(queues_, '[^,;]+', 1, LEVEL)
                          FROM   dual
                          CONNECT BY REGEXP_SUBSTR(queues_, '[^,;]+', 1, LEVEL) IS NOT NULL)
         OR   a.queue LIKE queues_)
      AND    (a.tag IS NULL OR a.tag <> 'BATCH')
      AND    a.state_date < SYSDATE - limit_/86400;

   TYPE message_rec_ IS RECORD
   (
      application_message_id_ fndcn_application_message_tab.application_message_id%TYPE,
      state_date_             fndcn_application_message_tab.state_date%TYPE,
      rowid_                  ROWID
   );

   TYPE message_ids_table_ IS TABLE OF message_rec_;
   message_ids_    message_ids_table_;
   count_          NUMBER := 0;
   lobs_deleted_   NUMBER := 0;
   age_in_seconds_ NUMBER := nvl(days_old_,    0) * 60 * 60 * 24 +
                             nvl(hours_old_,   0) * 60 * 60 +
                             nvl(minutes_old_, 0) * 60 +
                             nvl(seconds_old_, 0);

   $IF (Component_Fndrpl_SYS.INSTALLED) $THEN
      skipped_days_old_ NUMBER;
      PROCEDURE Remove_Rows_W_Skipped_Records_(
         ids_              IN OUT NOCOPY message_ids_table_,
         skipped_days_old_ IN NUMBER )
      IS
         application_message_id_ fndcn_application_message_tab.application_message_id%TYPE;
         state_date_             fndcn_application_message_tab.state_date%TYPE;
         count_skipped_msgs_     NUMBER;
      BEGIN
         FOR i_ IN REVERSE 1..ids_.COUNT LOOP
            application_message_id_ := ids_(i_).application_message_id_;
            state_date_             := ids_(i_).state_date_;
            IF (state_date_ < SYSDATE - skipped_days_old_) THEN
               NULL; --OK
            ELSE
               SELECT COUNT(*)
               INTO   count_skipped_msgs_
               FROM   repl_bundle_message_state_tab a
               WHERE  a.application_message_id = application_message_id_
               AND    UPPER(a.state)           <> 'FINISHED';
               IF (count_skipped_msgs_ > 0) THEN
                  ids_.DELETE(i_);
               END IF;
            END IF;
         END LOOP;
      END Remove_Rows_W_Skipped_Records_;
   $END

   PROCEDURE Delete_Rows_ (ids_ IN message_ids_table_) IS
   BEGIN
      --FORALL i_ IN 1..ids_.COUNT SAVE EXCEPTIONS
     FORALL i_ IN INDICES OF ids_ SAVE EXCEPTIONS
         DELETE FROM fndcn_address_label_tab a
         WHERE a.application_message_id = ids_(i_).application_message_id_;
      Trace_SYS.Message('Deleted from fndcn_address_label_tab ' || TO_CHAR(SQL%ROWCOUNT) || ' rows');

      --FORALL i_ IN 1..ids_.COUNT SAVE EXCEPTIONS
     FORALL i_ IN INDICES OF ids_ SAVE EXCEPTIONS
         DELETE FROM fndcn_message_body_tab a
         WHERE a.application_message_id = ids_(i_).application_message_id_;
      lobs_deleted_ := lobs_deleted_ + SQL%ROWCOUNT;
      Trace_SYS.Message('Deleted from fndcn_message_body_tab ' || TO_CHAR(SQL%ROWCOUNT) || ' rows');

     $IF (Component_Fndrpl_SYS.INSTALLED) $THEN
         FORALL i_ IN INDICES OF ids_ SAVE EXCEPTIONS
            DELETE FROM repl_bundle_state_tab a
            WHERE a.application_message_id = ids_(i_).application_message_id_;
         Trace_SYS.Message('Deleted from repl_bundle_state_tab ' || TO_CHAR(SQL%ROWCOUNT) || ' rows');

         FORALL i_ IN INDICES OF ids_ SAVE EXCEPTIONS
            DELETE FROM repl_bundle_message_state_tab a
            WHERE a.application_message_id = ids_(i_).application_message_id_;
         Trace_SYS.Message('Deleted from repl_bundle_message_state_tab ' || TO_CHAR(SQL%ROWCOUNT) || ' rows');

         FORALL i_ IN INDICES OF ids_ SAVE EXCEPTIONS
            DELETE FROM repl_rule_usage_tab a
            WHERE a.appl_message_id = ids_(i_).application_message_id_;
         Trace_SYS.Message('Deleted from repl_rule_usage_tab ' || TO_CHAR(SQL%ROWCOUNT) || ' rows');
      $END

     FORALL i_ IN INDICES OF ids_ SAVE EXCEPTIONS
      --FORALL i_ IN 1..ids_.COUNT SAVE EXCEPTIONS
         DELETE FROM fndcn_application_message_tab a
         WHERE a.rowid = ids_(i_).rowid_;
      Trace_SYS.Message('Deleted from fndcn_application_message_tab ' || TO_CHAR(SQL%ROWCOUNT) || ' rows');
   EXCEPTION
      WHEN OTHERS THEN
         FOR i_ IN 1..SQL%BULK_EXCEPTIONS.COUNT LOOP
            Trace_SYS.Message(SQL%BULK_EXCEPTIONS(i_).ERROR_INDEX || ': ' || SQL%BULK_EXCEPTIONS(i_).ERROR_CODE);
         END LOOP;
         RAISE;
   END Delete_Rows_;

BEGIN
   Trace_SYS.Message('Delete from queues (' || list_of_queues_ || ') where state IN (' || list_of_states_ || ') and age > ' || TO_CHAR(age_in_seconds_) || ' seconds');
   IF (UPPER(list_of_states_) = 'ANY') THEN
      OPEN c_message_ids_any_state_(list_of_queues_, age_in_seconds_);
      LOOP
         FETCH c_message_ids_any_state_
         BULK COLLECT INTO message_ids_
         LIMIT commit_count_;

         EXIT WHEN message_ids_.COUNT = 0;
         $IF (Component_Fndrpl_SYS.INSTALLED) $THEN
            skipped_days_old_ := to_number(NVL(Repl_Property_API.Get_Value('PROCESSING','SKIPPEDDAYSOLD'),'0'));
            IF (skipped_days_old_ > 0) THEN
               Remove_Rows_W_Skipped_Records_(message_ids_, skipped_days_old_);
            END IF;
         $END
         count_ := count_ + message_ids_.COUNT;

         Delete_Rows_(message_ids_);

         message_ids_ := null;
         @ApproveTransactionStatement(2014-11-10,madrse)
         COMMIT;
      END LOOP;
      CLOSE c_message_ids_any_state_;
   ELSE
      OPEN c_message_ids_(list_of_states_, list_of_queues_, age_in_seconds_);
      LOOP
         FETCH c_message_ids_
         BULK COLLECT INTO message_ids_
         LIMIT commit_count_;

         EXIT WHEN message_ids_.COUNT = 0;
         $IF (Component_Fndrpl_SYS.INSTALLED) $THEN
            skipped_days_old_ := to_number(NVL(Repl_Property_API.Get_Value('PROCESSING','SKIPPEDDAYSOLD'),'0'));
            IF (skipped_days_old_ > 0) THEN
               Remove_Rows_W_Skipped_Records_(message_ids_, skipped_days_old_);
            END IF;
         $END
         count_ := count_ + message_ids_.COUNT;

         Delete_Rows_(message_ids_);

         message_ids_ := null;
         @ApproveTransactionStatement(2014-11-10,madrse)
         COMMIT;
      END LOOP;
      CLOSE c_message_ids_;
   END IF;

   Trace_SYS.Message('Total deleted from table FNDCN_APPLICATION_MESSAGE_TAB ' || TO_CHAR(count_) || ' rows');
EXCEPTION
   WHEN OTHERS THEN
      Trace_SYS.Message(sqlerrm);
      @ApproveTransactionStatement(2014-11-10,madrse)
      ROLLBACK;
      RAISE;
END Cleanup;


PROCEDURE Clear_Config_Cache IS
BEGIN
   Batch_Processor_Jms_API.Send_Jms_Message('ClearConfigCache');
END Clear_Config_Cache;


--
PROCEDURE Cleanup_AQ_Exception_Queues (
   days_old_    IN NUMBER := 1,
   hours_old_   IN NUMBER := 0,
   minutes_old_ IN NUMBER := 0)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   time_          TIMESTAMP(6) := systimestamp - days_old_ - hours_old_/24 - minutes_old_/(24*60);
   async_cnt_     NUMBER;
   main_sync_cnt_ NUMBER;
   int_sync_cnt_  NUMBER;
   resp_cnt_      NUMBER;
   main_adm_cnt_  NUMBER;
   int_adm_cnt_   NUMBER;
   msg_           VARCHAR2(32000);
   fnd_user_      VARCHAR2(30);
BEGIN
   DELETE FROM batch_proc_resp_queue_tab WHERE q_name = 'AQ$_BATCH_PROC_RESP_QUEUE_TAB_E' AND enq_time < time_;
   resp_cnt_ := SQL%ROWCOUNT;

   IF Event_SYS.Event_Enabled(lu_name_, 'CLEANUP_AQ_EXCEPTION_QUEUES') THEN
      msg_ := Message_SYS.Construct('CLEANUP_AQ_EXCEPTION_QUEUES');
      ---
      --- Standard event parameters
      ---
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute(msg_, 'EVENT_DATETIME', sysdate);
      Message_SYS.Add_attribute(msg_, 'USER_IDENTITY',  fnd_user_);
      Message_SYS.Add_attribute(msg_, 'USER_DESCRIPTION',  Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_attribute(msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_attribute(msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));
      ---
      --- Event specific parameters
      ---
      Message_SYS.Add_Attribute(msg_, 'DELETED_ASYNCHRONOUS_MESSAGES',     async_cnt_);
      Message_SYS.Add_Attribute(msg_, 'DELETED_SYNCHRONOUS_MESSAGES_MAIN', main_sync_cnt_);
      Message_SYS.Add_Attribute(msg_, 'DELETED_SYNCHRONOUS_MESSAGES_INT',  int_sync_cnt_);
      Message_SYS.Add_Attribute(msg_, 'DELETED_SYNCHRONOUS_RESP_MESSAGES', resp_cnt_);
      Message_SYS.Add_Attribute(msg_, 'DELETED_ADMIN_MESSAGES_MAIN',       main_adm_cnt_);
      Message_SYS.Add_Attribute(msg_, 'DELETED_ADMIN_MESSAGES_INT',        int_adm_cnt_);
      --
      -- Generate event
      --
      Event_SYS.Event_Execute(lu_name_, 'CLEANUP_AQ_EXCEPTION_QUEUES', msg_);
   END IF;
   @ApproveTransactionStatement(2018-11-30,japase)
   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      --Trace_SYS.Message(sqlerrm);
      @ApproveTransactionStatement(2018-11-30,japase)
      ROLLBACK;
      RAISE;
END Cleanup_AQ_Exception_Queues;


--
-- Re-release application messages that could have been released while Batch Processor triggers were disabled
--
PROCEDURE Rerelease_Messages IS
BEGIN
   Release_Application_Messages_;
   Release_Print_Jobs_;
END Rerelease_Messages;


--
-- Disable Batch Processor triggers
--
PROCEDURE Disable_Triggers IS
BEGIN
   --Installation_SYS.Disable_Trigger('Print_Job_TR');
   Installation_SYS.Disable_Trigger('Application_Message_Jms_TR');
   Installation_SYS.Disable_Trigger('Config_Parameter_Jms_TR');
   Installation_SYS.Disable_Trigger('Config_Param_Distinct_Jms_TR');
   Installation_SYS.Disable_Trigger('Routing_Rule_Jms_TR');
   Installation_SYS.Disable_Trigger('Routing_Rule_Condition_Jms_TR');
   Installation_SYS.Disable_Trigger('Routing_Rule_Address_Jms_TR');
   Installation_SYS.Disable_Trigger('Routing_Address_Runtime_Jms_TR');
END Disable_Triggers;


--
-- Enable Batch Processor triggers
--
PROCEDURE Enable_Triggers IS
BEGIN
   --Installation_SYS.Enable_Trigger('Print_Job_TR');
   Installation_SYS.Enable_Trigger('Application_Message_Jms_TR');
   Installation_SYS.Enable_Trigger('Config_Parameter_Jms_TR');
   Installation_SYS.Enable_Trigger('Config_Param_Distinct_Jms_TR');
   Installation_SYS.Enable_Trigger('Routing_Rule_Jms_TR');
   Installation_SYS.Enable_Trigger('Routing_Rule_Condition_Jms_TR');
   Installation_SYS.Enable_Trigger('Routing_Rule_Address_Jms_TR');
   Installation_SYS.Enable_Trigger('Routing_Address_Runtime_Jms_TR');
END Enable_Triggers;


--
-- Create and enable Batch Processor triggers
--
PROCEDURE Create_Triggers IS
   empty_    Installation_SYS.ColumnTabType;
   disabled_ BOOLEAN := Installation_SYS.Get_Installation_Mode;
BEGIN
   --
   -- PrintJob -> Release print job
   --
   /*Installation_SYS.Create_Trigger(
      trigger_name_ => 'Print_Job_TR',
      trigger_type_ => 'BEFORE',
      dml_event_    => 'INSERT OR UPDATE OF status',
      columns_      => empty_,
      table_name_   => 'PRINT_JOB_TAB',
      condition_    => '(nvl(old.status, ''*'') <> ''WAITING'' AND new.status = ''WAITING'')',
      plsql_block_  => 'App_Message_Processing_API.Release_Print_Job_(:new.print_job_id, :new.printer_id);',
      show_info_    => TRUE,
      disabled_     => disabled_ );*/

   --
   -- ApplicationMessage -> Release application message (JMS)
   --
   Installation_SYS.Create_Trigger(
      trigger_name_ => 'Application_Message_Jms_TR',
      trigger_type_ => 'BEFORE',
      dml_event_    => 'INSERT OR UPDATE OF state',
      columns_      => empty_,
      table_name_   => 'FNDCN_APPLICATION_MESSAGE_TAB',
      condition_    => '(new.state = ''Released'')',
      plsql_block_  => 'App_Message_Processing_API.Application_Message_Released_(:new.queue, :new.state, :new.queue_thread_no, :new.application_message_id, :new.tag);',
      show_info_    => TRUE,
      disabled_     => disabled_ );

   --
   -- ConfigParameter -> Clear memory cache after changed configuration parameter. Release suspended messages on started queue. Notify task template change. (JMS)
   --
   Installation_SYS.Create_Trigger(
      trigger_name_ => 'Config_Parameter_Jms_TR',
      trigger_type_ => 'AFTER',
      dml_event_    => 'INSERT OR UPDATE OR DELETE',
      columns_      => empty_,
      table_name_   => 'CONFIG_INSTANCE_PARAM_TAB',
      condition_    => NULL,
      plsql_block_  => 'App_Message_Processing_API.Config_Parameter_Changed_(nvl(:new.group_name, :old.group_name), nvl(:new.instance_name, :old.instance_name), nvl(:new.parameter_name, :old.parameter_name));',
      show_info_    => TRUE,
      disabled_     => disabled_ );

   --
   -- RoutingRule -> Clear routing cache after changed routing parameter. (JMS)
   --
   Installation_SYS.Create_Trigger(
      trigger_name_ => 'Routing_Rule_Jms_TR',
      trigger_type_ => 'AFTER',
      dml_event_    => 'INSERT OR UPDATE OR DELETE',
      columns_      => empty_,
      table_name_   => 'ROUTING_RULE_TAB',
      condition_    => NULL,
      plsql_block_  => 'App_Message_Processing_API.Routing_Rule_Changed_(nvl(:new.rule_name, :old.rule_name), :new.enabled, :old.enabled);',
      show_info_    => TRUE,
      disabled_     => disabled_ );

   --
   -- RoutingRuleCondition -> Clear routing cache after changed routing parameter. (JMS)
   --
   Installation_SYS.Create_Trigger(
      trigger_name_ => 'Routing_Rule_Condition_Jms_TR',
      trigger_type_ => 'AFTER',
      dml_event_    => 'INSERT OR UPDATE OR DELETE',
      columns_      => empty_,
      table_name_   => 'ROUTING_RULE_CONDITION_TAB',
      condition_    => NULL,
      plsql_block_  => 'App_Message_Processing_API.Routing_Rule_Det_Changed_(nvl(:new.rule_name, :old.rule_name));',
      show_info_    => TRUE,
      disabled_     => disabled_ );

   --
   -- RoutingRuleAddress -> Clear routing cache after changed routing parameter. (JMS)
   --
   Installation_SYS.Create_Trigger(
      trigger_name_ => 'Routing_Rule_Address_Jms_TR',
      trigger_type_ => 'AFTER',
      dml_event_    => 'INSERT OR UPDATE OR DELETE',
      columns_      => empty_,
      table_name_   => 'ROUTING_RULE_ADDRESS_TAB',
      condition_    => NULL,
      plsql_block_  => 'App_Message_Processing_API.Routing_Rule_Det_Changed_(nvl(:new.rule_name, :old.rule_name));',
      show_info_    => TRUE,
      disabled_     => disabled_ );

   --
   -- RoutingAddressRuntime -> Clear routing cache after changed routing parameter. (JMS)
   --
   Installation_SYS.Create_Trigger(
      trigger_name_ => 'Routing_Address_Runtime_Jms_TR',
      trigger_type_ => 'AFTER',
      dml_event_    => 'INSERT OR UPDATE OR DELETE',
      columns_      => empty_,
      table_name_   => 'ROUTING_ADDRESS_RUNTIME_TAB',
      condition_    => NULL,
      plsql_block_  => 'App_Message_Processing_API.Routing_Addr_Runtime_Changed_(nvl(:new.address_name, :old.address_name));',
      show_info_    => TRUE,
      disabled_     => disabled_ );

   --
   -- ConfigParamDistinctJms -> Send distinct JMS message per transaction (JMS)
   --
   Installation_SYS.Create_Trigger(
      trigger_name_ => 'Config_Param_Distinct_Jms_TR',
      trigger_type_ => 'AFTER',
      dml_event_    => 'INSERT',
      columns_      => empty_,
      table_name_   => 'CONFIG_PARAM_DISTINCT_JMS_TAB',
      condition_    => NULL,
      plsql_block_  => 'App_Message_Processing_API.Config_Param_Jms_Changed_(:new.group_name, :new.instance_name, :new.jms_method);',
      show_info_    => TRUE,
      disabled_     => disabled_ );
END Create_Triggers;


PROCEDURE Post_Installation_Object IS
BEGIN
   Create_Triggers;
END Post_Installation_Object;


PROCEDURE Post_Installation_Data IS
BEGIN
   Enable_Triggers;
   Start_System_Queues;
   Clear_Config_Cache;
   Rerelease_Messages;
END Post_Installation_Data;


FUNCTION Get_DBID RETURN NUMBER
IS
   dbid_ NUMBER;
BEGIN
   SELECT dbid
     INTO dbid_
   FROM v$database;
   RETURN dbid_;
END Get_DBID;

FUNCTION Get_User_System_Privileges__ RETURN VARCHAR2
IS 
   sp_list_ VARCHAR2(2000);
BEGIN
   Fnd_Session_API.Set_Property('FNDEXT_SESSION', 'TRUE'); 
   Security_SYS.Enum_User_System_Privileges_(sp_list_);
   RETURN sp_list_;
END Get_User_System_Privileges__;