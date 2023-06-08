-----------------------------------------------------------------------------
--
--  Logical unit: FndWorkflowConnection
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--   ASWILK   120730   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FND_WORKFLOW_CONNECTION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   SELECT fnd_workflow_connection_seq.NEXTVAL
   INTO newrec_.request_id
   FROM dual;
   newrec_.created_date := sysdate;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


FUNCTION Create_Parameter_Record___(
      name_  IN VARCHAR2,
      value_ IN VARCHAR2 ) RETURN Plsqlap_Record_API.type_record_
IS
   plsqlap_paramater_rec_  Plsqlap_Record_API.type_record_;
BEGIN
   plsqlap_paramater_rec_ := Plsqlap_Record_API.New_Record('WORKFLOW_PARAMETER');
   Plsqlap_Record_API.Set_Value(plsqlap_paramater_rec_,'KEY',name_,Plsqlap_Record_API.dt_Text,FALSE);
   Plsqlap_Record_API.Set_Value(plsqlap_paramater_rec_,'VALUE',value_,Plsqlap_Record_API.dt_Text,FALSE);
   RETURN plsqlap_paramater_rec_;
END Create_Parameter_Record___;


PROCEDURE Workflow_Callback___ (
   rec_ FND_WORKFLOW_CONNECTION_TAB%ROWTYPE,
   response_ VARCHAR2 DEFAULT NULL )
IS
   plsqlap_rec_ Plsqlap_Record_API.type_record_;
   message_id_  NUMBER;

BEGIN

   plsqlap_rec_ := Plsqlap_Record_API.New_record('WORKFLOW_INSTANCE');
   Plsqlap_Record_API.Set_Value(plsqlap_rec_, 'URL',rec_.callback_url, Plsqlap_Record_API.dt_Text, FALSE);
   Plsqlap_Record_API.Set_Value(plsqlap_rec_, 'CORRELATION_ID',rec_.correlation_id, Plsqlap_Record_API.dt_Text, FALSE);
   Plsqlap_Record_API.Set_Value(plsqlap_rec_, 'RESPONSE',response_, Plsqlap_Record_API.dt_Text, FALSE);
   Plsqlap_Record_API.Set_Value(plsqlap_rec_, 'USER_ID',Fnd_Session_API.Get_Fnd_User, Plsqlap_Record_API.dt_Text, FALSE);

   PLSQLAP_Server_API.Post_Outbound_BizAPI(
      bizapi_name_  => 'SEND_WORKFLOW_CALLBACK',
      message_body_ => plsqlap_rec_,
      sender_       => 'CONNECT',
      receiver_     => 'CONNECT',
      message_type_ => 'EVENT_BIZAPI',
      message_id_   => message_id_,
      subject_      => 'Send Workflow Callback');

END Workflow_Callback___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Event_Executed(
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   event_data_    IN VARCHAR2 )
IS
   object_key_    VARCHAR2(100);
   CURSOR get_wf_connections IS
      SELECT *
        FROM FND_WORKFLOW_CONNECTION_TAB
        WHERE event_lu_name = event_lu_name_
        AND   event_id = event_id_
        AND   object_key = object_key_;
   connection_exist_ BOOLEAN := FALSE;
BEGIN


   --Get object key , event parameter can be both ROWKEY and OBJKEY depending on the Event type

   object_key_ := Message_Sys.Find_Attribute(event_data_, 'ROWKEY','_no_object_key_');
   IF object_key_  = '_no_object_key_' THEN
      object_key_ := Message_Sys.Find_Attribute(event_data_, 'OBJKEY','_no_object_key_');
   END IF;

   IF object_key_  <> '_no_object_key_' THEN

      FOR rec_ IN get_wf_connections LOOP
         IF (rec_.item_id IS NOT NULL) THEN
         -- Complete humans task that is defined to be completed automatically by this event
         Todo_Item_Api.Complete_Task(rec_.item_id);
         END IF;
         IF (rec_.callback_url IS NOT NULL AND rec_.correlation_id IS NOT NULL) THEN
           --Resume any workflow
           Workflow_Callback___(rec_);
         END IF;
         connection_exist_ := TRUE;
      END LOOP;

      IF connection_exist_ THEN
              DELETE FROM FND_WORKFLOW_CONNECTION_TAB
              WHERE event_lu_name = event_lu_name_
                AND   event_id = event_id_
                AND   object_key = object_key_;
      END IF;
   END IF;
END Event_Executed;


PROCEDURE Resume_Workflow_For_Task(task_id_ IN VARCHAR2, response_ IN VARCHAR2 DEFAULT NULL)
IS
   CURSOR get_wf_connections IS
      SELECT *
        FROM FND_WORKFLOW_CONNECTION_TAB
        WHERE item_id = task_id_;
BEGIN

   FOR rec_ IN get_wf_connections LOOP
      IF (rec_.callback_url IS NOT NULL AND rec_.correlation_id IS NOT NULL) THEN
         -- Resume any workflow
         Workflow_Callback___(rec_,response_);
      END IF;
   END LOOP;

   DELETE FROM FND_WORKFLOW_CONNECTION_TAB
   WHERE item_id = task_id_;
END Resume_Workflow_For_Task;


PROCEDURE New_Connection(
   attr_ IN OUT VARCHAR2 )
IS
   newrec_      FND_WORKFLOW_CONNECTION_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
   objid_       ROWID;
   objversion_  VARCHAR2(2000);
BEGIN
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New_Connection;


PROCEDURE Remove_Connection (
   correlation_id_      VARCHAR2 )
IS
BEGIN
   DELETE FROM FND_WORKFLOW_CONNECTION_TAB
     WHERE correlation_id = correlation_id_;
END Remove_Connection;


PROCEDURE Start_Workflow (
   workflow_server_url_ IN VARCHAR2,
   web_service_name_    IN VARCHAR2,
   operation_           IN VARCHAR2,
   parameters_attr_     IN VARCHAR2 )
IS
   url_                    VARCHAR2(200) :=  workflow_server_url_;
   plsqlap_rec_            Plsqlap_Record_API.type_record_;
   plsqlap_parameter_rec_  Plsqlap_Record_API.type_record_;

   ptr_   NUMBER;
   name_  VARCHAR2(50);
   value_ VARCHAR2(2000);
   message_id_  NUMBER;
   information_   VARCHAR2(200);

BEGIN
   IF (url_ IS NULL) THEN
      url_ := Get_Default_Workflow_Server;
   END IF;
   IF (url_ IS NULL) THEN
      ERROR_SYS.Appl_General('FndWorkflowConnection','NO_HW_SERVER: No workflow server specified');
   END IF;

   IF (web_service_name_ IS NULL) THEN
      --RAISE ERROR
      ERROR_SYS.Appl_General('FndWorkflowConnection','NO_HW_SERVER_WEB_SERVICE: No workflow web service specified');
   END IF;

   IF (operation_ IS NULL) THEN
      --RAISE ERROR
      ERROR_SYS.Appl_General('FndWorkflowConnection','NO_HW_SERVER_WEB_SERVICE_OPERATION: No workflow webservice operation specified');
   END IF;

   plsqlap_rec_ := Plsqlap_Record_API.New_record('WORKFLOW');
   Plsqlap_Record_API.Set_Value(plsqlap_rec_, 'WORKFLOW_SERVER',url_, Plsqlap_Record_API.dt_Text, FALSE);
   Plsqlap_Record_API.Set_Value(plsqlap_rec_, 'WEB_SERVICE',web_service_name_, Plsqlap_Record_API.dt_Text, FALSE);
   Plsqlap_Record_API.Set_Value(plsqlap_rec_, 'OPERATION',operation_, Plsqlap_Record_API.dt_Text, FALSE);

   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(parameters_attr_, ptr_, name_, value_)) LOOP
      plsqlap_parameter_rec_ := Create_Parameter_Record___(name_,value_);
      plsqlap_Record_API.Add_Array(plsqlap_rec_,'PARAMETERS',plsqlap_parameter_rec_);
   END LOOP;

   information_ := Substr(web_service_name_ ||'/'|| operation_,1,200);

   PLSQLAP_Server_API.Post_Outbound_BizAPI(
      bizapi_name_  => 'START_WORKFLOW',
      message_body_ => plsqlap_rec_,
      sender_       => 'CONNECT',
      receiver_     => 'CONNECT',
      message_type_ => 'EVENT_BIZAPI',
      message_id_   => message_id_,
      subject_      => 'Start Workflow:  ' || information_);

END Start_Workflow;

@UncheckedAccess
FUNCTION Get_Default_Workflow_Server RETURN VARCHAR2
IS
BEGIN
  RETURN Fnd_Workflow_Server_API.Get_Default_Workflow_Server;
END Get_Default_Workflow_Server;


