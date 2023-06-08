-----------------------------------------------------------------------------
--
--  Logical unit: FndWorkflowIntegration
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120730  AsWiLk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Human_Task (
   callback_url_           VARCHAR2,
   correlation_id_         VARCHAR2,
   subject_                VARCHAR2,
   message_                VARCHAR2,
   receiver_               VARCHAR2,
   url_                    VARCHAR2,
   priority_               VARCHAR2,   
   due_date_               DATE,
   business_object_        VARCHAR2,
   response_options_       VARCHAR2,
   event_lu_               VARCHAR2 DEFAULT NULL,
   event_id_               VARCHAR2 DEFAULT NULL,
   object_key_             VARCHAR2 DEFAULT NULL)
IS
   task_id_          VARCHAR2(200);
   task_attr_			VARCHAR2(4000);
BEGIN
   Fnd_Workflow_Task_Util_API.Create_Human_Task(task_id_,subject_,message_,receiver_,url_,priority_,due_date_,business_object_,response_options_);
   Client_SYS.Clear_Attr(task_attr_);
   Client_SYS.Add_To_Attr( 'EVENT_LU_NAME', event_lu_, task_attr_ );
   Client_SYS.Add_To_Attr( 'EVENT_ID', event_id_, task_attr_ );
   Client_SYS.Add_To_Attr( 'OBJECT_KEY', object_key_, task_attr_ );
   Client_SYS.Add_To_Attr( 'CALLBACK_URL', callback_url_, task_attr_ );
   Client_SYS.Add_To_Attr( 'CORRELATION_ID', correlation_id_, task_attr_ );
   Client_SYS.Add_To_Attr( 'ITEM_ID', task_id_, task_attr_ );
   Fnd_Workflow_Connection_API.New_Connection(task_attr_);
END Create_Human_Task;


PROCEDURE Response_On_Event (
   callback_url_        VARCHAR2,
   correlation_id_      VARCHAR2,
   object_key_          VARCHAR2,
   event_lu_            VARCHAR2,
   event_id_            VARCHAR2 )
IS
   task_attr_			VARCHAR2(4000);
BEGIN
   Client_SYS.Clear_Attr(task_attr_);
   Client_SYS.Add_To_Attr( 'EVENT_LU_NAME', event_lu_, task_attr_ );
   Client_SYS.Add_To_Attr( 'EVENT_ID', event_id_, task_attr_ );
   Client_SYS.Add_To_Attr( 'OBJECT_KEY', object_key_, task_attr_ );
   Client_SYS.Add_To_Attr( 'CALLBACK_URL', callback_url_, task_attr_ );
   Client_SYS.Add_To_Attr( 'CORRELATION_ID', correlation_id_, task_attr_ );
   Fnd_Workflow_Connection_API.New_Connection(task_attr_);
END Response_On_Event;


PROCEDURE Unsubscribe_To_Response (
   correlation_id_      VARCHAR2 )
IS
BEGIN
   Fnd_Workflow_Connection_API.Remove_Connection(correlation_id_);
END Unsubscribe_To_Response;


