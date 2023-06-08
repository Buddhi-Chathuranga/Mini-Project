-----------------------------------------------------------------------------
--
--  Logical unit: ReportApplicationMessage
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
PROCEDURE New (
   newrec_ IN OUT NOCOPY report_application_message_tab%ROWTYPE )
IS
BEGIN
   New___(newrec_);
END New;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Validate_State_Transition___ (
   old_state_  IN     VARCHAR2,
   newrec_     IN OUT report_application_message_tab%ROWTYPE)
IS
   old_ VARCHAR2(100) := old_state_;
   new_ VARCHAR2(100) := newrec_.state;
BEGIN
   IF old_ IS NULL OR old_ <> new_ THEN
      newrec_.state_date := sysdate;
   END IF;

   IF new_ = Report_Message_State_Types_API.DB_RELEASED THEN
      newrec_.error_text := NULL;
   END IF;

   IF old_ = Report_Message_State_Types_API.DB_PROCESSING THEN
      newrec_.finished_timestamp := systimestamp;
   END IF;

   IF newrec_.tag = 'BATCH' AND newrec_.message_function IN ('PrintAgent', 'Connectivity') THEN
      IF old_ IS NULL AND new_ IN (Report_Message_State_Types_API.DB_SUSPENDED) THEN
         RETURN;
      ELSIF old_ = new_ THEN
         RETURN;
      END IF;
      Error_SYS.Appl_General(lu_name_, 'REP_TEMPLATE_STATETRANSITION: Invalid state transition from [:P1] to [:P2] on report application message template [:P3]', old_, new_, newrec_.application_message_id);
   END IF;

   IF old_ IS NULL AND new_ IN (Report_Message_State_Types_API.DB_RELEASED, Report_Message_State_Types_API.DB_SUSPENDED, Report_Message_State_Types_API.DB_FAILED, Report_Message_State_Types_API.DB_WAITING, Report_Message_State_Types_API.DB_FINISHED) THEN
      RETURN;
   ELSIF old_ = new_ THEN
      RETURN;
   ELSIF old_ = Report_Message_State_Types_API.DB_RELEASED   AND new_ IN (Report_Message_State_Types_API.DB_SUSPENDED, Report_Message_State_Types_API.DB_PROCESSING, Report_Message_State_Types_API.DB_FAILED) THEN
      RETURN;
   ELSIF old_ = Report_Message_State_Types_API.DB_PROCESSING AND new_ IN (Report_Message_State_Types_API.DB_FINISHED, Report_Message_State_Types_API.DB_FAILED, Report_Message_State_Types_API.DB_WAITING, Report_Message_State_Types_API.DB_SUSPENDED) THEN
      RETURN;
   ELSIF old_ = Report_Message_State_Types_API.DB_FAILED     AND new_ IN (Report_Message_State_Types_API.DB_RELEASED, Report_Message_State_Types_API.DB_CANCELLED) THEN
      RETURN;
   ELSIF old_ = Report_Message_State_Types_API.DB_WAITING    AND new_ IN (Report_Message_State_Types_API.DB_RELEASED, Report_Message_State_Types_API.DB_SUSPENDED, Report_Message_State_Types_API.DB_CANCELLED) THEN
      RETURN;
   ELSIF old_ = Report_Message_State_Types_API.DB_CANCELLED  AND new_ IN (Report_Message_State_Types_API.DB_RELEASED) THEN
      RETURN;
   ELSIF old_ = Report_Message_State_Types_API.DB_SUSPENDED  AND new_ IN (Report_Message_State_Types_API.DB_RELEASED, Report_Message_State_Types_API.DB_CANCELLED) THEN
      RETURN;
   END IF;
   Error_SYS.Appl_General(lu_name_, 'REPSTATETRANSITION: Invalid state transition from [:P1] to [:P2] on report application message [:P3]', old_, new_, newrec_.application_message_id);
END Validate_State_Transition___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT report_application_message_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.created_by   := Fnd_Session_API.Get_Fnd_User;
   newrec_.created_date := sysdate;
   newrec_.created_timestamp := systimestamp;
   -- compare EXECUTE_AS value with DB value
   IF (newrec_.execute_as = 'Initiator') THEN
     IF (newrec_.initiated_by IS NULL) THEN
       newrec_.initiated_by := newrec_.created_by;
     END IF;
   END IF;
   Validate_State_Transition___(NULL, newrec_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     report_application_message_tab%ROWTYPE,
   newrec_     IN OUT report_application_message_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   execution_mode_ VARCHAR2(4000);
   parameters_ CLOB;
   failed_callback_fn_ VARCHAR2(500);
   fail_notify_   VARCHAR2(50) := 'FALSE';
   attr_for_job_       VARCHAR2(2000);
   job_id_     NUMBER;
BEGIN
   -- compare EXECUTE_AS value with DB value
   IF (newrec_.execute_as = 'Initiator') THEN
     IF (newrec_.initiated_by IS NULL) THEN
       newrec_.initiated_by := newrec_.created_by;
     END IF;
   END IF;
   Validate_State_Transition___(oldrec_.state, newrec_);
   --
   -- Suspend Processing message moved to another queue
   --
   IF oldrec_.state = Report_Message_State_Types_API.DB_PROCESSING AND newrec_.state = Report_Message_State_Types_API.DB_PROCESSING AND oldrec_.queue <> newrec_.queue THEN
      newrec_.state := Report_Message_State_Types_API.DB_SUSPENDED;
   --
   -- Suspend Waiting message moved from an InOrder queue to another queue. Send JMS message to wake up the InOrder queue.
   --
   ELSIF oldrec_.state = Report_Message_State_Types_API.DB_WAITING AND newrec_.state = Report_Message_State_Types_API.DB_WAITING AND oldrec_.queue <> newrec_.queue THEN
      SELECT parameter_value
        INTO execution_mode_
        FROM report_config_inst_param_tab
       WHERE group_name = 'MessageQueues'
         AND instance_name = oldrec_.queue
         AND parameter_name = 'EXECUTION_MODE';
      IF lower(execution_mode_) = 'inorder' THEN
         newrec_.state := Report_Message_State_Types_API.DB_SUSPENDED;
         Report_Message_Processing_API.Release_Suspended_Messages_(oldrec_.queue);
      END IF;
   END IF;

   IF newrec_.state = Message_State_Types_API.DB_FAILED THEN
      BEGIN 
         SELECT t.parameters
         INTO   parameters_
         FROM   report_message_body_tab t
         WHERE  t.application_message_id = newrec_.application_message_id AND t.seq_no=1;
      EXCEPTION
         WHEN no_data_found THEN
            Trace_SYS.Message('Application messages created by Reporting and Application server tasks have message bodies started from sequence no = 0');
            Trace_SYS.Message('All other messages should have message bodies started from sequence no = 1');
         WHEN OTHERS THEN
            RAISE;
      END;

      --*********** DO WE NEED THIS ******************
      /*Trace_SYS.Message('This validation is only applicable for REST messages');
      IF(parameters_ IS NOT NULL) THEN
         failed_callback_fn_ := Plsql_Rest_Sender_API.Get_Value__(parameters_,'<FAILED_CALLBACK_FUNC>');
         fail_notify_  := Plsql_Rest_Sender_API.Get_Value__(parameters_,'<FAIL_NOTIFY>');
      END IF;

      IF fail_notify_ = 'TRUE' THEN
         Client_SYS.Add_To_Attr('ERROR_TEXT_', newrec_.error_text, attr_for_job_);
         Client_SYS.Add_To_Attr('APP_MSG_ID_', newrec_.application_message_id, attr_for_job_);
         Transaction_SYS.Deferred_Call(job_id_,failed_callback_fn_,'PARAMETER',attr_for_job_, 'Call for the Failed App Message (' || newrec_.application_message_id || ') Callback Function');
     END IF;*/
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;

@Override
PROCEDURE Raise_Record_Modified___ (
   rec_ report_application_message_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Record_Modified(Report_Application_Message_API.lu_name_, p1_ => rec_.application_message_id);
   super(rec_);
END Raise_Record_Modified___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE New_App_Server_Task__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT NOCOPY VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   app_msg_attr_      VARCHAR2(32767);
   message_body_attr_ VARCHAR2(32767);
   address_line_attr_ VARCHAR2(32767);
   name_       VARCHAR2(100);
   value_      VARCHAR2(32767);
   ptr_        NUMBER := NULL;
   app_msg_id_ NUMBER := Fndcn_Message_Seq.NEXTVAL;
BEGIN
   Client_SYS.Add_To_Attr('APPLICATION_MESSAGE_ID', app_msg_id_, app_msg_attr_);
   Client_SYS.Add_To_Attr('SEQ_NO', app_msg_id_, app_msg_attr_);
   Client_SYS.Add_To_Attr('APPLICATION_MESSAGE_ID', app_msg_id_, message_body_attr_);
   Client_SYS.Add_To_Attr('SEQ_NO', 0, message_body_attr_);
   Client_SYS.Add_To_Attr('APPLICATION_MESSAGE_ID', app_msg_id_, address_line_attr_);
   Client_SYS.Add_To_Attr('SEQ_NO', 0, address_line_attr_);
   WHILE Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_) LOOP
      IF substr(name_, 1, 2) = 'B_' THEN
         Client_SYS.Add_To_Attr(substr(name_, 3), value_, message_body_attr_);
      ELSIF substr(name_, 1, 2) = 'L_' THEN
         Client_SYS.Add_To_Attr(substr(name_, 3), value_, address_line_attr_);
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, app_msg_attr_);
      END IF;
   END LOOP;
   New__(info_, objid_, objversion_, app_msg_attr_, action_);
   Report_Address_Label_API.New__(info_, objid_, objversion_, address_line_attr_, action_);
   Report_Message_Body_API.New__(info_, objid_, objversion_, message_body_attr_, action_);
END New_App_Server_Task__;


/*PROCEDURE Write_B_Message_Value__ (
   objversion_ IN OUT NOCOPY VARCHAR2,
   rowid_      IN     ROWID,
   lob_loc_    IN     BLOB ) IS
BEGIN
   Report_Message_Body_API.Write_Message_Value__(objversion_, rowid_, lob_loc_);
END Write_B_Message_Value__;*/

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

