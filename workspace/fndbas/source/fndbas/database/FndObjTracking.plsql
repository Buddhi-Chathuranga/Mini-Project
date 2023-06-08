-----------------------------------------------------------------------------
--
--  Logical unit: FndObjTracking
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150906  WAWI    Changed exception handliing in Initialize_Queue method (Bug#124370)
--  150925  WAWI    Avoided reraising errors in plsql notification callback (Bug#124746)
--  150925  WAWI    Make the Initialize_Queue method runnable only as app owner (Bug#124754) 
-----------------------------------------------------------------------------

LAYER Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
tracking_queue_name_ CONSTANT VARCHAR2(30) := 'FND_TRK_LU_DMO_Q';
debug_        CONSTANT BOOLEAN := TRUE;

-------------------- PRIVATE DECLARATIONS -----------------------------------

log_category_ CONSTANT VARCHAR2(100) := 'Server Errors';

callback_procedure_ CONSTANT VARCHAR2(400) := 'CREATE OR REPLACE PROCEDURE fnd_trk_dmo_callback(CONTEXT  RAW,
   reginfo  sys.aq$_reg_info,
   descr    sys.aq$_descriptor,
   payload  VARCHAR2,
   payloadl NUMBER)
IS   
BEGIN
   FND_OBJ_TRACKING_SYS.Tracking_Queue_Callback(CONTEXT, reginfo, descr, payload, payloadl);   
END;';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Correlation_Info___(
   lu_name_ IN VARCHAR2,
   objkey_  IN VARCHAR2) RETURN VARCHAR2
IS
   msg_ VARCHAR2(2000) := Message_SYS.Construct('CORRELATION_INFO');
BEGIN
   Message_SYS.Add_Attribute(msg_,'LU_NAME',lu_name_);
   Message_SYS.Add_Attribute(msg_,'OBJKEY', objkey_);
   Message_SYS.Add_Attribute(msg_,'TRANSACTION_ID', dbms_transaction.local_transaction_id);
   RETURN msg_;
END Get_Correlation_Info___;

PROCEDURE Process_Request___(
   queue_name_    IN VARCHAR2,
   consumer_name_ IN VARCHAR2)
IS
   dequeue_options_    dbms_aq.dequeue_options_t;
   message_properties_ dbms_aq.message_properties_t;
   message_handle_     RAW(16);   
   temp_msg_payload_   fnd_rec_trk_info_type;
   msg_payload_cf_     fnd_rec_trk_info_type;
   msg_payload_lu_     fnd_rec_trk_info_type;

   no_more_messages    EXCEPTION;
   PRAGMA              exception_init(no_more_messages, -25228);
BEGIN
   dequeue_options_.navigation    := dbms_aq.FIRST_MESSAGE;
   dequeue_options_.consumer_name := consumer_name_;
   dequeue_options_.wait := dbms_aq.no_wait;
   
   -- Dequeue one message
   dbms_aq.dequeue(queue_name => queue_name_, 
                   dequeue_options => dequeue_options_, 
                   message_properties => message_properties_, 
                   payload => temp_msg_payload_, 
                   msgid => message_handle_);
   
   IF temp_msg_payload_.table_name LIKE '%/_CFT' ESCAPE '/' THEN
      msg_payload_cf_ := temp_msg_payload_;
   ELSE
      msg_payload_lu_ := temp_msg_payload_;
   END IF;   
      
   BEGIN
      -- Use the correlation information(lu,objkey,tranaction_id) from the dequeued messages
      -- to check if there's another message related to it. Usually
      -- from Custom Field.
      dequeue_options_.correlation := message_properties_.correlation;
      -- Add deq_condition to prevent overriding messages which were dequeue earlier which
      -- caused loss of subscription messages
      dequeue_options_.deq_condition := 'tab.user_data.table_name  != ''' || temp_msg_payload_.table_name || '''';
      dbms_aq.dequeue(queue_name => queue_name_, 
                      dequeue_options => dequeue_options_, 
                      message_properties => message_properties_, 
                      payload => temp_msg_payload_, 
                      msgid => message_handle_);     
      IF temp_msg_payload_.table_name LIKE '%/_CFT' ESCAPE '/' THEN
         msg_payload_cf_ := temp_msg_payload_;
      ELSE
         msg_payload_lu_ := temp_msg_payload_;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         temp_msg_payload_ := NULL;
   END;
   
   Fnd_Obj_Subscription_Util_API.Process_Request_(msg_payload_lu_, msg_payload_cf_);     
   @ApproveTransactionStatement(2014-06-13,chmulk)
   COMMIT;
END Process_Request___;

PROCEDURE Regenerate_Invalid_Triggers___
IS
   CURSOR get_invalid_trigger_lu IS
      SELECT r.lu_name, o.object_name, CASE o.object_name
                                       WHEN r.insert_trigger THEN 'INSERT'
                                       WHEN r.update_trigger THEN 'UPDATE'
                                       WHEN r.delete_trigger THEN 'DELETE'
                                       ELSE NULL 
                                       END trigger_type
        FROM user_objects o, fnd_obj_tracking_runtime_tab r
       WHERE object_type = 'TRIGGER'
         AND status      = 'INVALID'
         AND (o.OBJECT_NAME = r.insert_trigger
              OR o.OBJECT_NAME = r.update_trigger
              OR o.OBJECT_NAME = r.delete_trigger);

   TYPE invalids IS TABLE OF get_invalid_trigger_lu%ROWTYPE;
   invalid_lu_triggers_ invalids;
BEGIN
   OPEN get_invalid_trigger_lu;
   FETCH get_invalid_trigger_lu BULK COLLECT INTO invalid_lu_triggers_;
   CLOSE get_invalid_trigger_lu;
   
   -- Columns which were removed will be handled here
   FOR i_ IN 1..invalid_lu_triggers_.COUNT LOOP
      dbms_output.put_line('Trying to regenerate Object Tracking trigger: '||invalid_lu_triggers_(i_).object_name || ' of LU: '|| invalid_lu_triggers_(i_).lu_name);
      BEGIN
         CASE invalid_lu_triggers_(i_).trigger_type
         WHEN 'INSERT' THEN
            NULL; -- Not implemented
         WHEN 'UPDATE' THEN
            Fnd_Obj_Tracking_Runtime_API.Regenerate_Triggers__(invalid_lu_triggers_(i_).lu_name, update_trigger_ => invalid_lu_triggers_(i_).object_name);
         WHEN 'DELETE' THEN
            Fnd_Obj_Tracking_Runtime_API.Regenerate_Triggers__(invalid_lu_triggers_(i_).lu_name, delete_trigger_ => invalid_lu_triggers_(i_).object_name);
         END CASE;
      
         IF Database_SYS.Get_Compile_Error(invalid_lu_triggers_(i_).object_name, 'TRIGGER') IS NOT NULL THEN
            dbms_output.put_line('Error: Object Tracking trigger '||invalid_lu_triggers_(i_).object_name||' still has errors.');
         ELSE
            dbms_output.put_line('Object Tracking trigger '||invalid_lu_triggers_(i_).object_name||' regenerated successfully.');
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error when regenerating Object Tracking trigger: '||invalid_lu_triggers_(i_).object_name || ' of LU: '|| invalid_lu_triggers_(i_).lu_name);
            dbms_output.put_line('   Error message: '||SQLERRM);
      END;
   END LOOP;
END Regenerate_Invalid_Triggers___;

PROCEDURE Sync_New_Columns___
IS
   CURSOR get_upd_trk_triggers IS
      SELECT lu_name, update_trigger
        FROM fnd_obj_tracking_runtime_tab r
       WHERE running = Fnd_Boolean_API.DB_TRUE;
        
   TYPE upd_triggers IS TABLE OF get_upd_trk_triggers%ROWTYPE;
   upd_triggers_ upd_triggers;
        
   CURSOR get_col_diff_count(trigger_name_ VARCHAR2, table_name_ VARCHAR2) IS   
      SELECT count(*)
        FROM (SELECT column_name
                FROM user_tab_columns
               WHERE table_name = table_name_
                 AND data_type IN ('NUMBER','VARCHAR2','DATE')
                 AND column_name NOT IN ('ROWKEY', 'TEXT_ID$')
               MINUS
              SELECT column_name
                FROM user_trigger_cols
               WHERE trigger_name = trigger_name_
                 AND column_name NOT IN ('ROWKEY', 'TEXT_ID$')
                 AND table_name = table_name_);
       
   col_count_ NUMBER;
   table_name_ VARCHAR2(30);
BEGIN
   OPEN get_upd_trk_triggers;
   FETCH get_upd_trk_triggers BULK COLLECT INTO upd_triggers_;
   CLOSE get_upd_trk_triggers;
       
   FOR i_ in 1..upd_triggers_.COUNT LOOP
      table_name_ := Dictionary_SYS.Get_Base_Table_Name(upd_triggers_(i_).lu_name);
      OPEN get_col_diff_count(upd_triggers_(i_).update_trigger, table_name_);
      FETCH get_col_diff_count INTO col_count_;
      CLOSE get_col_diff_count;
        
      IF col_count_ > 0 THEN
         BEGIN
            Fnd_Obj_Tracking_Runtime_API.Regenerate_Triggers__(upd_triggers_(i_).lu_name, update_trigger_ => upd_triggers_(i_).update_trigger);
     
            IF Database_SYS.Get_Compile_Error(upd_triggers_(i_).update_trigger, 'TRIGGER') IS NOT NULL THEN
               dbms_output.put_line('Error: Object Tracking trigger '||upd_triggers_(i_).update_trigger||' still has errors.');
            ELSE
               dbms_output.put_line('Object Tracking trigger '||upd_triggers_(i_).update_trigger||' regenerated successfully.');
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               dbms_output.put_line('Error when regenerating Object Tracking trigger: '||upd_triggers_(i_).update_trigger || ' of LU: '|| upd_triggers_(i_).lu_name);
               dbms_output.put_line('   Error message: '||SQLERRM);
         END;
      END IF;
   END LOOP; 
END Sync_New_Columns___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
PROCEDURE Tracking_Queue_Callback(
   context_  RAW,
   reginfo_  sys.aq$_reg_info,
   descr_    sys.aq$_descriptor,
   payload_  VARCHAR2,
   payloadl_ NUMBER) 
IS
   no_more_messages    EXCEPTION;
   PRAGMA              exception_init(no_more_messages, -25228);
BEGIN
   BEGIN
      WHILE (TRUE) LOOP
         Process_Request___(descr_.queue_name, descr_.consumer_name);
      END LOOP;
   EXCEPTION
      WHEN no_more_messages THEN
         NULL;
   END;
EXCEPTION
   WHEN OTHERS THEN
      Log_Error_Autonomous(SUBSTR(SQLERRM,1,2000));
END Tracking_Queue_Callback;
   
PROCEDURE Process_Queue(
   queue_name_    IN VARCHAR2,
   consumer_name_ IN VARCHAR2)
IS
   no_more_messages    EXCEPTION;
   PRAGMA              exception_init(no_more_messages, -25228);
BEGIN
   --Process_Request___(queue_name_, consumer_name_);
   BEGIN
      WHILE (TRUE) LOOP
         Process_Request___(queue_name_, consumer_name_);
      END LOOP;
   EXCEPTION
      WHEN no_more_messages THEN
         NULL;
   END;
END Process_Queue;

PROCEDURE Log_Error_Autonomous(
   error_text_ IN VARCHAR2)
IS
   temp_ NUMBER;
BEGIN 
   temp_ := Server_Log_API.Log_Autonomous(NULL, log_category_, 'Object Tracking Error', error_text_);
END Log_Error_Autonomous;

@UncheckedAccess
FUNCTION Is_Lu_Tracked(
   lu_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   temp_ NUMBER;
BEGIN
  select 1 into temp_
     from fnd_obj_tracking_runtime_tab
     where lu_name = lu_name_ and
           running = 'TRUE';
     RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   -- To be implemented
END Is_Lu_Tracked;

@UncheckedAccess
FUNCTION Is_Subscribed_Object(
   objkey_  IN VARCHAR2) RETURN BOOLEAN
IS
   temp_ NUMBER;
BEGIN
   SELECT 1 INTO temp_
   FROM fnd_obj_subscription_tab t
   WHERE t.sub_objkey = objkey_
   FETCH FIRST 1 ROW ONLY;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
END Is_Subscribed_Object;


@UncheckedAccess
FUNCTION Are_Changes_Subscribed_To (
   changed_column_list_ IN     Message_SYS.name_table,
   lu_name_             IN     VARCHAR2) RETURN BOOLEAN
   
IS
   temp_ NUMBER;
BEGIN   
   SELECT 1 INTO temp_ FROM dual
   WHERE EXISTS ( SELECT 1
      FROM fnd_obj_subscrip_column_tab
      WHERE subscription_lu = lu_name_
      AND subscription_column IN (SELECT column_value FROM TABLE(changed_column_list_)));
   
   RETURN TRUE;
EXCEPTION 
   WHEN no_data_found THEN
      RETURN FALSE;
END Are_Changes_Subscribed_To;
   
@UncheckedAccess
FUNCTION Are_Changes_Subscribed_To (
   changed_column_attr_ IN VARCHAR2,
   lu_name_             IN VARCHAR2) RETURN BOOLEAN
   
IS
   changed_column_list_ Message_SYS.name_table;
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(32000);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(changed_column_attr_, ptr_, name_, value_)) LOOP
      changed_column_list_(changed_column_list_.COUNT+1) := name_;
      IF name_ LIKE '%/_DB' ESCAPE '/' THEN
         name_ := SUBSTR(name_, 1, length(name_)- 3);
         changed_column_list_(changed_column_list_.COUNT+1) := name_;
      END IF;
   END LOOP;
   RETURN Are_Changes_Subscribed_To(changed_column_list_, lu_name_);
END Are_Changes_Subscribed_To;
   
FUNCTION Get_Queued_Message_Count RETURN NUMBER
IS
BEGIN
   RETURN Fnd_Ora_Advanced_Queue_API.Get_Queued_Msg_Count(tracking_queue_name_);
END Get_Queued_Message_Count;
   
@UncheckedAccess
PROCEDURE Post_Object_Changes(
   dmo_type_    IN VARCHAR2,
   lu_name_     IN VARCHAR2,   
   view_name_   IN VARCHAR2,
   table_name_  IN VARCHAR2,
   rowkey_      IN VARCHAR2,
   old_values_  IN CLOB,
   new_values_  IN CLOB,
   queue_name_  IN VARCHAR2 
   )
IS
   o_payload_            FND_REC_TRK_INFO_TYPE;
   r_enqueue_options_    DBMS_AQ.ENQUEUE_OPTIONS_T;
   r_message_properties_ DBMS_AQ.MESSAGE_PROPERTIES_T;
   v_message_handle_     RAW(16);
   queue_stopped_err_ EXCEPTION;
   PRAGMA exception_init(queue_stopped_err_, -25207);
BEGIN
   r_message_properties_.correlation := Get_Correlation_Info___(lu_name_, rowkey_);
   o_payload_ := FND_REC_TRK_INFO_TYPE(dmo_type_,table_name_,view_name_ ,lu_name_, rowkey_, old_values_, new_values_, fnd_session_api.Get_Fnd_User);
   DBMS_AQ.ENQUEUE(queue_name => queue_name_, enqueue_options => r_enqueue_options_, message_properties => r_message_properties_, payload => o_payload_, msgid => v_message_handle_);
EXCEPTION
   WHEN queue_stopped_err_ THEN
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Oracle Queue[' || queue_name_ || '] is stopped and needs to be started.');
      Error_SYS.System_General('Oracle Queue[' || queue_name_ || '] is stopped and needs to be started.');
   WHEN OTHERS THEN
      Log_SYS.Fnd_Trace_(Log_SYS.error_, substr('Unable to post object tracking information : '||SQLERRM || dbms_utility.format_error_backtrace,1,2000));  
END Post_Object_Changes;

@UncheckedAccess
PROCEDURE Post_Object_Changes_CF(
   dmo_type_         IN VARCHAR2,
   lu_name_          IN VARCHAR2,   
   view_name_        IN VARCHAR2,
   table_name_       IN VARCHAR2,
   old_values_attr_  IN VARCHAR2,
   new_values_attr_  IN VARCHAR2,
   queue_name_       IN VARCHAR2)
IS
   rowkey_ VARCHAR2(50);
   old_values_ VARCHAR2(32000);
   new_values_ VARCHAR2(32000);
BEGIN
   rowkey_ := Client_SYS.Get_Item_Value('ROWKEY', new_values_attr_);
   old_values_ := Message_SYS.Get_Message_From_Attr(old_values_attr_, 'OLD_VALUES');
   new_values_ := Message_SYS.Get_Message_From_Attr(new_values_attr_, 'NEW_VALUES');
   Post_Object_Changes(dmo_type_, lu_name_, view_name_, table_name_, rowkey_, old_values_, new_values_, queue_name_);
END Post_Object_Changes_CF;


--This procedure should not be run as someone other than appowner because the queue need to have only one subscriber registration
@UncheckedAccess   
PROCEDURE Initialize_Queue
IS
   no_registration EXCEPTION;
   PRAGMA exception_init (no_registration,-24950);
   not_a_subscriber EXCEPTION;
   PRAGMA exception_init (not_a_subscriber,-24035);
BEGIN
   IF (Fnd_Session_API.Get_Fnd_User = Fnd_Session_API.Get_App_Owner) THEN
      @ApproveDynamicStatement(2015-02-12,wawilk)
      EXECUTE IMMEDIATE callback_procedure_;
      
      BEGIN
         Fnd_Ora_Advanced_Queue_API.Unregister_PLSQL_Callback('FND_TRK_LU_DMO_Q','FND_LU_DMO_LISTENER', 'fnd_trk_dmo_callback');  
      EXCEPTION
         WHEN no_registration THEN
            NULL;
      END;
      
      BEGIN
         Fnd_Ora_Advanced_Queue_API.Remove_Subscriber('FND_TRK_LU_DMO_Q','FND_LU_DMO_LISTENER');
      EXCEPTION
         WHEN not_a_subscriber THEN
            NULL;
      END;
      
      Fnd_Ora_Advanced_Queue_API.Add_Subscriber('FND_TRK_LU_DMO_Q','FND_LU_DMO_LISTENER');
      Fnd_Ora_Advanced_Queue_API.Register_PLSQL_Callback('FND_TRK_LU_DMO_Q','FND_LU_DMO_LISTENER', 'fnd_trk_dmo_callback');
      Fnd_Ora_Advanced_Queue_API.Start_Queue('FND_TRK_LU_DMO_Q');
   ELSE 
      Error_SYS.Appl_General(lu_name_, 'ONLYAPPOWNER: You need to log in to the database as the application owner to run this procedure');
   END IF;
END Initialize_Queue;

PROCEDURE Post_Installation_Data
IS
BEGIN
   -- Remove any columns which were removed from the table from the trigger
   Regenerate_Invalid_Triggers___;
   -- Add any new columns which were added to the table to the trigger
   Sync_New_Columns___;
EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line('Error in regenerating Object Tracking Post Install process');
      dbms_output.put_line('   Error message: '||SQLERRM);
END Post_Installation_Data;
