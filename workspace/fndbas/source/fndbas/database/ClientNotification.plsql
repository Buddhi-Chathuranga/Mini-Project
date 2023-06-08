-----------------------------------------------------------------------------
--
--  Logical unit: ClientNotification
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
  
 PROCEDURE Enqueue___ (
   message_ IN OUT sys.aq$_jms_text_message)
IS
   agent_              sys.aq$_agent := sys.aq$_agent(' ', null, 0);
   enqueue_options_    dbms_aq.enqueue_options_t;
   message_properties_ dbms_aq.message_properties_t;
   msgid_              raw(16);
   jms_queue_name_   VARCHAR2(100):= Fnd_Session_API.Get_App_Owner || '.CLIENT_NOTIF_Q';
   no_recipients_    EXCEPTION;
   PRAGMA exception_init (no_recipients_,-24033);
   queue_stopped_err_  EXCEPTION;
   PRAGMA exception_init(queue_stopped_err_, -25207);
   temp_             NUMBER;
BEGIN
   message_.set_replyto(agent_);
   dbms_aq.enqueue(queue_name => jms_queue_name_,
                   enqueue_options => enqueue_options_,
                   message_properties => message_properties_,
                   payload => message_,
                   msgid => msgid_); 
EXCEPTION 
   WHEN no_recipients_ THEN
      temp_ := Server_Log_API.Log_Autonomous(NULL, 'Server Errors', 'Client Notification Error', 'JMS queue is not configured in MWS');
   WHEN queue_stopped_err_ THEN
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Oracle Queue[' || jms_queue_name_ || '] is stopped and needs to be started.');
      Error_SYS.System_General('Oracle Queue[' || jms_queue_name_ || '] is stopped and needs to be started.');
   WHEN OTHERS THEN
      temp_ := Server_Log_API.Log_Autonomous(NULL, 'Server Errors', 'Client Notification Error', substr(sqlerrm,1,3500));            
END Enqueue___;

PROCEDURE Send_Notification_Impl__(
   message_   IN VARCHAR2,
   user_id_   IN VARCHAR2 DEFAULT NULL,
   notification_type_ IN VARCHAR2 DEFAULT NULL,
   tracking_id_ IN VARCHAR2 DEFAULT NULL)
IS  
   new_msg_      VARCHAR2(2000) := message_;
   reference_    VARCHAR2(2000);
   message_seq_no_ NUMBER;
   is_topic_       BOOLEAN := TRUE; 
BEGIN
   IF(user_id_ IS NULL) THEN
      Error_SYS.System_General( 'CLIENT_NOTIFICATION_FNDUSER_MISSING: FNDUSER must be specified!');
   END IF;
   
   --Replace delimiters in the message
   new_msg_ := REPLACE(new_msg_, '^');
   
   -- Create Client Notify Queue Line
   reference_ := 
      '^MESSAGE='            || new_msg_    ||
      '^TO_FND_USER='        || user_id_    ||
      '^CLIENT_NOTIFICATION_TYPE=' || notification_type_ ||
      '^TRACKING_ID=' || tracking_id_ ;


   message_seq_no_ := Client_Notify_Queue_API.Add_Message('NOTIFICATION', reference_); 
   --client messages should always be topic. should be delivered to all registered nodes
   IF is_topic_ THEN
      Client_Notify_Node_API.Notify_All_Nodes_(message_seq_no_);
   END IF;   
END Send_Notification_Impl__; 

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Send_Notification__(
   message_   IN VARCHAR2,
   user_id_   IN VARCHAR2,
   notification_type_ IN VARCHAR2)
IS
BEGIN
   Send_Notification_Impl__(
         message_    => message_,
         user_id_   => user_id_,
         notification_type_  => notification_type_
   );   
END Send_Notification__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
PROCEDURE Create_Message_ (
   notification_type_ IN VARCHAR2,
   to_fnd_user_ IN VARCHAR2,
   tracking_id_ IN NUMBER,
   message_body_ IN varchar2)
IS
   --message_            sys.aq$_jms_text_message;
   --message2_            sys.aq$_jms_text_message;
BEGIN
   --message_ := sys.aq$_jms_text_message.construct;
   --message_.set_string_property('CLIENT_NOTIFICATION_TYPE',notification_type_);
   --message_.set_string_property('TO_FND_USER',to_fnd_user_);
   --message_.set_long_property('TRACKING_ID',tracking_id_);
   --message_.set_text(message_body_);
   --message2_ := message_;
   --Enqueue___(message_);
   Send_Notification_Impl__(
         message_    => message_body_,
         user_id_   => to_fnd_user_,
         notification_type_  => notification_type_,
         tracking_id_  => tracking_id_
   );   

END Create_Message_;
-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

--
-- Send text notification message to a specific device app.
--
PROCEDURE Remote_Assistance_Notification(
   message_   IN VARCHAR2,
   user_id_   IN VARCHAR2)
IS
BEGIN
   Send_Notification__(message_, user_id_, Client_Notification_Type_API.DB_FND_REMOTE_ASSISTANCE);
END Remote_Assistance_Notification;
