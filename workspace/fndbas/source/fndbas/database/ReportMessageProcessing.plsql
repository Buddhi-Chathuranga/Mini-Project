-----------------------------------------------------------------------------
--
--  Logical unit: ReportMessageProcessing
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
group_name_task_templates_     CONSTANT VARCHAR2(20) := 'TaskTemplates';
group_name_message_queues_     CONSTANT VARCHAR2(20) := 'MessageQueues';
instance_type_print_agent_     CONSTANT VARCHAR2(20) := 'PrintAgent';
parameter_name_stop_queue_     CONSTANT VARCHAR2(20) := 'STOP_QUEUE';
parameter_name_execution_mode_ CONSTANT VARCHAR2(20) := 'EXECUTION_MODE';
parameter_name_priority_       CONSTANT VARCHAR2(20) := 'PRIORITY';
parameter_thread_count_        CONSTANT VARCHAR2(20) := 'THREAD_COUNT';
media_code_inet_trans_         CONSTANT VARCHAR2(20) := 'INET_TRANS';
default_report_formatter_      CONSTANT VARCHAR2(30) := 'Default Report Formatter';


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
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
               FROM report_config_inst_param_tab
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
                FROM report_address_label
               WHERE application_message_id = application_message_id_
                 AND (current_state_ IS NULL OR state = current_state_))
   LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('STATE_DB', Report_Address_Label_State_API.DB_RELEASED, attr_);
      Client_SYS.Add_To_Attr('RETRIED_COUNT', '', attr_);
	   Client_SYS.Add_To_Attr('ERROR_TEXT', '', attr_);
      Report_Address_Label_API.Modify__(info_, l_.objid, l_.objversion, attr_, 'DO');
   END LOOP;
END Release_Address_Lines___;

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
        FROM report_config_inst_param_tab D, report_printer_mapping_tab P, report_config_instance_tab I
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
           FROM report_config_inst_param_tab P, report_config_instance_tab I
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
      FROM   report_application_message
      WHERE  application_message_id = application_message_id_;
   EXCEPTION
      WHEN no_data_found THEN
         Error_SYS.Record_Not_Exist(Report_Application_Message_API.lu_name_, p1_ => application_message_id_);
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
      Report_Application_Message_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
END Check_And_Set_Message_State___;

PROCEDURE Remove_Address_Lines___ (
   application_message_id_ IN NUMBER)
IS
   info_       VARCHAR2(2000);
BEGIN
   FOR l_ IN (SELECT objid, objversion
                FROM report_address_label
               WHERE application_message_id = application_message_id_)
   LOOP
      Report_Address_Label_API.Remove__(info_, l_.objid, l_.objversion, 'DO');
   END LOOP;
END Remove_Address_Lines___;

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
   new_id_ NUMBER := report_message_seq.NEXTVAL;
   head_ report_application_message_tab%ROWTYPE;
BEGIN
   SELECT *
     INTO head_
     FROM report_application_message_tab
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
   head_.state                  := Report_Message_State_Types_API.DB_RELEASED;
   head_.created_timestamp      := systimestamp;

   INSERT INTO report_application_message_tab VALUES head_;
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
   new_id_ NUMBER := report_message_seq.NEXTVAL;

   head_ report_application_message_tab%ROWTYPE;
   body_ report_message_body_tab%ROWTYPE;
   line_ report_address_label_tab%ROWTYPE;

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
        FROM report_config_instance_tab
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
                       FROM report_config_inst_param_tab
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
   head_.state                  := Report_Message_State_Types_API.DB_RELEASED;
   head_.receiver               := receiver_;      -- PrintAgent:IFSAPP
   head_.message_type           := message_type_;  -- PrintAgent:REPORTING
   head_.message_function       := instance_type_;
   head_.subject                := subject_;
   head_.inbound                := 0;
   INSERT INTO report_application_message_tab VALUES head_;

   body_.application_message_id := new_id_;
   body_.seq_no                 := 0;
   body_.rowversion             := 1;
   body_.rowkey                 := sys_guid();
   body_.body_type              := 'XML';
   body_.reply                  := 0;
   body_.message_value          := message_body_xml_;
   INSERT INTO report_message_body_tab VALUES body_;

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
   INSERT INTO report_address_label_tab VALUES line_;

   RETURN new_id_;
END Create_App_Server_Task___;

PROCEDURE Send_Config_Param_Jms___ (
   group_name_    IN VARCHAR2,
   instance_name_ IN VARCHAR2,
   jms_method_    IN VARCHAR2) IS
BEGIN
   Report_Batch_Processor_Jms_API.Send_Jms_Message(jms_method_, group_name_ => group_name_, instance_name_ => instance_name_);
END Send_Config_Param_Jms___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Cleanup__
IS
   life_         NUMBER;

  CURSOR get_all_old IS
      SELECT application_message_id
      FROM   report_application_message_tab
      WHERE  state_date < sysdate - life_
      AND    state IN ('Cancelled','Failed', 'Finished'); 
  
  
  TYPE                     report_application_message_type IS TABLE OF report_application_message_tab.application_message_id%TYPE;
  application_message_id_  report_application_message_type;

BEGIN
   life_ := Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('KEEP_PRINTJOBS'));
   OPEN get_all_old;
   LOOP
   FETCH get_all_old BULK COLLECT INTO application_message_id_ LIMIT 1000;
      FORALL i_ IN 1..application_message_id_.count
         DELETE FROM report_application_message_tab
            WHERE application_message_id = application_message_id_(i_);
      FORALL i_ IN 1..application_message_id_.count
         DELETE report_address_label_tab 
            WHERE application_message_id = application_message_id_(i_);
      FORALL i_ IN 1..application_message_id_.count
         DELETE FROM report_message_body_tab
            WHERE application_message_id = application_message_id_(i_);
      @ApproveTransactionStatement(2021-08-07,SJayLK)
      COMMIT;
      EXIT WHEN get_all_old%NOTFOUND;
   END LOOP;     
   CLOSE get_all_old;
END Cleanup__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
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
               FROM report_application_message
              WHERE queue LIKE queue_
                AND state_db = Report_Message_State_Types_API.DB_RELEASED)
   LOOP
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Rereleasing application message [' || a_.application_message_id || '] on queue [' || a_.queue || ']');
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('STATE_DB', Report_Message_State_Types_API.DB_RELEASED, attr_);
      Report_Application_Message_API.Modify__(info_, a_.objid, a_.objversion, attr_, 'DO');
      count_ := count_ + 1;
   END LOOP;
   Log_SYS.Fnd_Trace_(Log_SYS.info_, '[' || count_ || '] messages have been rereleased');
END Release_Application_Messages_;

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
            Report_Batch_Processor_Jms_API.Send_Jms_Message('ProcessMessage', queue_ => queue_, execution_mode_ => execution_mode_, priority_ => priority_);
         ELSE
            --
            -- Send one JMS message per thread accorning to currently configured THREAD_COUNT
            --
            FOR no_ IN 1 .. thread_count_ LOOP
               Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Sending JMS message ProcessMessage to process all released messages on InSequence queue [' || queue_ || ':' || no_ || ']');
               Report_Batch_Processor_Jms_API.Send_Jms_Message('ProcessMessage', queue_ => queue_, execution_mode_ => execution_mode_, restricted_queue_thread_no_ => no_, priority_ => priority_);
            END LOOP;
            --
            -- Send one JMS message per distinct APPLICATION_MESSAGE.QUEUE_THREAD_NO which is NULL or is greater than configured THREAD_COUNT
            --
            FOR am_ IN (SELECT DISTINCT queue_thread_no
                          FROM report_application_message
                         WHERE queue = queue_
                           AND (queue_thread_no IS NULL OR queue_thread_no > thread_count_)
                           AND state_db IN (Report_Message_State_Types_API.DB_RELEASED, Report_Message_State_Types_API.DB_PROCESSING))
            LOOP
               Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Sending JMS message ProcessMessage to process all released messages on InSequence queue [' || queue_ || ':' || am_.queue_thread_no || ']');
               Report_Batch_Processor_Jms_API.Send_Jms_Message('ProcessMessage', queue_ => queue_, execution_mode_ => execution_mode_, restricted_queue_thread_no_ => am_.queue_thread_no, priority_ => priority_);
            END LOOP;
         END IF;

      WHEN 'inorder' THEN
         --
         -- Send one JMS message without restricted_queue_thread_no.
         --
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Sending JMS message ProcessMessage to process all released messages on InOrder queue [' || queue_ || ']');
         Report_Batch_Processor_Jms_API.Send_Jms_Message('ProcessMessage', queue_ => queue_, execution_mode_ => execution_mode_, priority_ => priority_);

      WHEN 'inparallel' THEN
         IF queue_stopped_ THEN
            Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Queue [ ' || queue_ || ' has been stopped. Call to Release_Suspended_Messages_ ignored.');
            RETURN;
         END IF;

         FOR a_ IN (SELECT objid, objversion, state_db, application_message_id
                     FROM report_application_message
                    WHERE queue = queue_
                      AND state_db = Report_Message_State_Types_API.DB_SUSPENDED)
         LOOP
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('STATE_DB', Report_Message_State_Types_API.DB_RELEASED, attr_);
            Report_Application_Message_API.Modify__(info_, a_.objid, a_.objversion, attr_, 'DO');
            Release_Address_Lines___(a_.application_message_id, Report_Address_Label_State_API.DB_RETRY);
            count_ := count_ + 1;
            EXIT WHEN count_ = chunk_;
         END LOOP;
         Log_SYS.Fnd_Trace_(Log_SYS.info_, '[' || count_ || '] suspended messages have been released on queue [' || queue_ || ']');
         IF count_ = chunk_ THEN
            Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Sending JMS message to continue releasing of suspended messages on queue [' || queue_ || '] in another chunk.');
            Report_Batch_Processor_Jms_API.Send_Jms_Message('ReleaseSuspendedMessages', queue_ => queue_);
         END IF;
   END CASE;
END Release_Suspended_Messages_;

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
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'ReportApplicationMessage JMS Trigger: Released application_message [' || application_message_id_ || '] has been ignored, because restricted queue [' || queue_ || '] is stopped.');
      ELSE
         state_ := 'Suspended';
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'ReportApplicationMessage JMS Trigger: Released application_message [' || application_message_id_ || '] has been Suspended, because queue [' || queue_ || '] is stopped.');
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
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'ReportApplicationMessage JMS Trigger: Skipped JMS message for application_message_id [' || application_message_id_ || ']   queue [' || queue_ || ']   execution_mode [' || execution_mode_);
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'ReportApplicationMessage JMS Trigger: application_message_id [' || application_message_id_ || ']   queue [' || queue_ || ']   execution_mode [' || execution_mode_ || ']   restricted_queue_thread_no [' || restricted_queue_thread_no_ || ']   priority [' || priority_ || ']');
      Report_Batch_Processor_Jms_API.Send_Jms_Message('ProcessMessage',
         queue_                      => queue_,
         application_message_id_     => application_message_id_,
         execution_mode_             => execution_mode_,
         restricted_queue_thread_no_ => restricted_queue_thread_no_,
         priority_                   => priority_);
   END IF;
END Application_Message_Released_;

PROCEDURE Config_Parameter_Changed_ (
   group_name_     IN VARCHAR2,
   instance_name_  IN VARCHAR2,
   parameter_name_ IN VARCHAR2) IS
BEGIN      
   Send_Config_Param_Jms___(group_name_, '*', 'ClearConfigCache');
   IF group_name_ = group_name_message_queues_ AND parameter_name_ IN (parameter_name_stop_queue_, parameter_name_execution_mode_) THEN      
      Report_Batch_Processor_Jms_API.Send_Jms_Message('QueueParameterChanged', queue_ => instance_name_, parameter_name_ => parameter_name_);
   END IF;   
END Config_Parameter_Changed_;


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
   Report_Application_Message_API.Modify__(info_, objid_, objver_, attr_, 'DO');
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
   Report_Application_Message_API.Modify__(info_, objid_, objver_, attr_, 'DO');
END Set_Error_;

PROCEDURE Queue_Parameter_Changed_ (
   queue_          IN VARCHAR2,
   parameter_name_ IN VARCHAR2)
IS
   parameter_value_ VARCHAR2(200);
BEGIN
   BEGIN
      SELECT lower(parameter_value)
        INTO parameter_value_
        FROM report_config_inst_param_tab
       WHERE group_name = group_name_message_queues_
         AND instance_name  = queue_
         AND parameter_name = parameter_name_;
   EXCEPTION
      WHEN no_data_found THEN
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Queue [' || queue_ || '] not found. Call to Report_Message_Processing_API.Queue_Parameter_Changed_ ignored.');
         RETURN;
   END;
   IF parameter_name_ = parameter_name_stop_queue_ THEN
      IF parameter_value_ IS NULL OR parameter_value_ ='false' THEN
         Release_Suspended_Messages_(queue_);
      /*ELSIF parameter_value_ = 'true' THEN
         Raise_Queue_Stopped_Event_(queue_);*/
      END IF;
   ELSIF parameter_name_ = parameter_name_execution_mode_ THEN
      IF parameter_value_ = 'inparallel' THEN
         Release_Application_Messages_(queue_);
      END IF;
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Parameter [' || parameter_name_ || '] for Queue [' || queue_ || '] ignored by Report_Message_Processing_API.Queue_Parameter_Changed_.');
   END IF;
END Queue_Parameter_Changed_;

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
     FROM report_reader_timers_tab
    WHERE reader_name = reader_name_
   FOR UPDATE NOWAIT;
   IF timestamp_ - old_ > 29000 THEN
      UPDATE report_reader_timers_tab
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
         INSERT INTO report_reader_timers_tab (reader_name, timestamp, server_name)
         VALUES (reader_name_, timestamp_, server_name_);
         RETURN 'TRUE';
      EXCEPTION
         WHEN dup_val_on_index THEN
            RETURN 'FALSE';
      END;
END Lock_Reader_Timer_;

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
     FROM report_restrcted_queue_key_tab
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
         INSERT INTO report_restrcted_queue_key_tab (queue_type, queue_name, queue_thread_no)
         VALUES (queue_type_, queue_name_, queue_thread_no_);
         RETURN 'TRUE';
      EXCEPTION
         WHEN dup_val_on_index THEN
            RETURN 'FALSE';
      END;
END Lock_Restricted_Queue_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

----------------------------------------------------------------
--
-- Disable Batch Processor triggers
--
PROCEDURE Disable_Triggers IS
BEGIN
   Installation_SYS.Disable_Trigger('Print_Job_TR');
   Installation_SYS.Disable_Trigger('Report_App_Message_Jms_TR');
   Installation_SYS.Disable_Trigger('Report_Config_Param_Jms_TR');
   Installation_SYS.Disable_Trigger('Report_Printer_Mapping_TR');
END Disable_Triggers;


--
-- Enable Batch Processor triggers
--
PROCEDURE Enable_Triggers IS
BEGIN
   Installation_SYS.Enable_Trigger('Print_Job_TR');
   Installation_SYS.Enable_Trigger('Report_App_Message_Jms_TR');
   Installation_SYS.Enable_Trigger('Report_Config_Param_Jms_TR');
   Installation_SYS.Enable_Trigger('Report_Printer_Mapping_TR');
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
   --plsql_block_  => 'Report_Message_Processing_API.Release_Print_Job_(:new.print_job_id, :new.printer_id);',
   
   Installation_SYS.Create_Trigger(
      trigger_name_ => 'Print_Job_TR',
      trigger_type_ => 'BEFORE',
      dml_event_    => 'INSERT OR UPDATE OF status',
      columns_      => empty_,
      table_name_   => 'PRINT_JOB_TAB',
      condition_    => '(nvl(old.status, ''*'') <> ''WAITING'' AND new.status = ''WAITING'')',
      plsql_block_  => 'Report_Message_Processing_API.Release_Print_Job_(:new.print_job_id, :new.printer_id);',
      show_info_    => TRUE,
      disabled_     => disabled_ );
      
--
   -- ApplicationMessage -> Release application message (JMS)
   --
   Installation_SYS.Create_Trigger(
      trigger_name_ => 'Report_App_Message_Jms_TR',
      trigger_type_ => 'BEFORE',
      dml_event_    => 'INSERT OR UPDATE OF state',
      columns_      => empty_,
      table_name_   => 'REPORT_APPLICATION_MESSAGE_TAB',
      condition_    => '(new.state = ''Released'')',
      plsql_block_  => 'Report_Message_Processing_API.Application_Message_Released_(:new.queue, :new.state, :new.queue_thread_no, :new.application_message_id, :new.tag);',
      show_info_    => TRUE,
      disabled_     => disabled_ );
      
   --
   -- ConfigParameter -> Clear memory cache after changed configuration parameter. Release suspended messages on started queue. Notify task template change. (JMS)
   --
   Installation_SYS.Create_Trigger(
      trigger_name_ => 'Report_Config_Param_Jms_TR',
      trigger_type_ => 'AFTER',
      dml_event_    => 'INSERT OR UPDATE OR DELETE',
      columns_      => empty_,
      table_name_   => 'REPORT_CONFIG_INST_PARAM_TAB',
      condition_    => NULL,
      plsql_block_  => 'Report_Message_Processing_API.Config_Parameter_Changed_(nvl(:new.group_name, :old.group_name), nvl(:new.instance_name, :old.instance_name), nvl(:new.parameter_name, :old.parameter_name));',
      show_info_    => TRUE,
      disabled_     => disabled_ );
      
   --
   -- ConfigParameter -> Clear memory cache after changed configuration parameter. Notify task template change. (JMS)
   --
   Installation_SYS.Create_Trigger(
      trigger_name_ => 'Report_Printer_Mapping_TR',
      trigger_type_ => 'AFTER',
      dml_event_    => 'INSERT OR UPDATE OR DELETE',
      columns_      => empty_,
      table_name_   => 'REPORT_PRINTER_MAPPING_TAB',
      condition_    => NULL,
      plsql_block_  => 'Report_Message_Processing_API.Config_Parameter_Changed_(NULL,NULL,NULL);',
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
   -- Do we need this?
   -- Clear_Config_Cache;
   Rerelease_Messages;
END Post_Installation_Data;

PROCEDURE Start_System_Queues IS
BEGIN
   Start_Queue('DEFAULT');
   --Start_Queue('UNROUTED');
END Start_System_Queues;

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
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Starting report message queue [' || queue_ || ']');
   SELECT objid, objversion, upper(stop_queue)
     INTO objid_, objversion_, stopped_
     FROM report_queue
    WHERE instance_name  = queue_;
   IF stopped_ = 'TRUE' THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('STOP_QUEUE', 'FALSE', attr_);
      Report_Queue_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Queue [' || queue_ || '] already started');
   END IF;
EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
END Start_Queue;

/*  
PROCEDURE Clear_Config_Cache IS
BEGIN
   Batch_Processor_Jms_API.Send_Jms_Message('ClearConfigCache');
END Clear_Config_Cache;
*/

PROCEDURE Rerelease_Messages IS
BEGIN
   Release_Application_Messages_;
   Release_Print_Jobs_;
END Rerelease_Messages;

FUNCTION Is_Queue_Stopped_ (
   queue_ VARCHAR2) RETURN VARCHAR2
IS
   value_ VARCHAR2(4000);
BEGIN
   SELECT upper(parameter_value)
     INTO value_
     FROM report_config_inst_param_tab
    WHERE group_name = group_name_message_queues_
      AND instance_name  = queue_
      AND parameter_name = parameter_name_stop_queue_;

     RETURN value_;
END Is_Queue_Stopped_;


PROCEDURE Stop_Queue (
   queue_ IN VARCHAR2)
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   stopped_    VARCHAR2(100);
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Stoping report application message queue [' || queue_ || ']');
   SELECT objid, objversion, upper(stop_queue)
     INTO objid_, objversion_, stopped_
     FROM report_queue
    WHERE instance_name  = queue_;

   IF stopped_ = 'FALSE' THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('STOP_QUEUE', 'TRUE', attr_);
      Report_Queue_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Queue [' || queue_ || '] already stopped');
   END IF;
END Stop_Queue;

PROCEDURE Suspend_Message (
   application_message_id_ IN NUMBER )
IS
BEGIN
   Check_And_Set_Message_State___('Suspend', application_message_id_, Report_Message_State_Types_API.DB_SUSPENDED,
                                                                      Report_Message_State_Types_API.DB_WAITING);
END Suspend_Message;

PROCEDURE Resume_Message (
   application_message_id_ IN NUMBER )
IS
BEGIN
   Check_And_Set_Message_State___('Resume', application_message_id_, Report_Message_State_Types_API.DB_RELEASED,
                                                                     Report_Message_State_Types_API.DB_SUSPENDED);
   Release_Address_Lines___(application_message_id_, Report_Address_Label_State_API.DB_RETRY);
END Resume_Message;

PROCEDURE Cancel_Message (
   application_message_id_ IN NUMBER )
IS
BEGIN
   Check_And_Set_Message_State___('Cancel', application_message_id_, Report_Message_State_Types_API.DB_CANCELLED,
                                                                     Report_Message_State_Types_API.DB_FAILED,
                                                                     Report_Message_State_Types_API.DB_WAITING,
                                                                     Report_Message_State_Types_API.DB_SUSPENDED);
END Cancel_Message;

PROCEDURE Restart_Message_All_Addr (
   application_message_id_ IN NUMBER)
IS
BEGIN
   Check_And_Set_Message_State___('Restart All', application_message_id_, Report_Message_State_Types_API.DB_RELEASED,
                                                                          Report_Message_State_Types_API.DB_FAILED,
                                                                          Report_Message_State_Types_API.DB_CANCELLED);
   Release_Address_Lines___(application_message_id_);
END Restart_Message_All_Addr;


PROCEDURE Restart_Message_Failed_Addr (
   application_message_id_ IN NUMBER)
IS
BEGIN
   Check_And_Set_Message_State___('Restart Failed', application_message_id_, Report_Message_State_Types_API.DB_RELEASED,
                                                                             Report_Message_State_Types_API.DB_FAILED,
                                                                             Report_Message_State_Types_API.DB_CANCELLED);
   Release_Address_Lines___(application_message_id_, Report_Address_Label_State_API.DB_RETRY);
   Release_Address_Lines___(application_message_id_, Report_Address_Label_State_API.DB_FAILED);
END Restart_Message_Failed_Addr;


PROCEDURE Reroute_Message (
   application_message_id_ IN NUMBER)
IS
   message_type_ VARCHAR2(200);
BEGIN
   Check_And_Set_Message_State___('Reroute', application_message_id_, Report_Message_State_Types_API.DB_RELEASED,
                                                                      Report_Message_State_Types_API.DB_FAILED, Report_Message_State_Types_API.DB_RELEASED);
   SELECT message_type
     INTO message_type_
     FROM report_application_message
    WHERE application_message_id = application_message_id_;

   IF message_type_ = 'Background Job' THEN
      Error_SYS.Appl_General(lu_name_, 'REROUTE_BACKGROUND_JOB: Reroute is not allowed for background job [' || application_message_id_ || ']');
   END IF;

   Remove_Address_Lines___(application_message_id_);
END Reroute_Message;

PROCEDURE Duplicate_And_Release_Message (
   application_message_id_ IN OUT NUMBER)
IS
   new_id_ NUMBER;
BEGIN
   Check_And_Set_Message_State___('Duplicate and Release', application_message_id_, NULL, Report_Message_State_Types_API.DB_FINISHED);
   new_id_ := Clone_Message_Header___(application_message_id_);
   FOR body_ IN (SELECT * FROM report_message_body_tab WHERE application_message_id = application_message_id_ AND address_seq_no IS NULL) LOOP
      body_.application_message_id := new_id_;
      body_.rowversion             := 1;
      body_.message_template       := NULL;
      body_.rowkey                 := sys_guid();
      INSERT INTO report_message_body_tab VALUES body_;
   END LOOP;
   application_message_id_ := new_id_;
END Duplicate_And_Release_Message;

@UncheckedAccess
FUNCTION Get_Config_Param (
   queue_      IN VARCHAR2,
   param_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   param_value_ VARCHAR2(4000);
BEGIN
   SELECT lower(parameter_value)
     INTO param_value_
     FROM report_config_inst_param_tab
    WHERE group_name = group_name_message_queues_
      AND instance_name  = queue_
      AND parameter_name = param_name_;

     RETURN param_value_;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN NULL;
END Get_Config_Param;
-------------------- LU  NEW METHODS -------------------------------------
