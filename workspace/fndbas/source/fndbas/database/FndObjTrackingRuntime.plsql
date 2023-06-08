-----------------------------------------------------------------------------
--
--  Logical unit: FndObjTrackingRuntime
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150907  WAWILK  Changed Activate_Tracking to remove the runtime entry if no active subscriptions available
--                  and refactored Refresh_LU for more clarity(Bug#124389)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
update_trigger_suffix_ CONSTANT VARCHAR2(6) := '_TRK_U';
delete_trigger_suffix_ CONSTANT VARCHAR2(6) := '_TRK_D';
insert_trigger_suffix_ CONSTANT VARCHAR2(6) := '_TRK_I';

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Generate_Update_Trk_Trigger___ (
   lu_name_ IN     VARCHAR2,
   trigger_name_ IN VARCHAR2 )
IS
   code_ CLOB;
   TYPE col_list_typ IS TABLE OF user_tab_columns.column_name%TYPE INDEX BY PLS_INTEGER;
   tab_col_list_ col_list_typ;
   
   tags_       fnd_code_template_api.List_Typ;
   tag_n_vals_ fnd_code_template_api.TwoD_List_Typ;
   tags1_      fnd_code_template_api.List_Typ;
   vals1_      fnd_code_template_api.List_Typ;
   
   base_view_name_ VARCHAR2(50); 
   table_name_ VARCHAR2(50);
   
BEGIN 
   Assert_SYS.Assert_Is_Logical_Unit(lu_name_);
   base_view_name_ := Dictionary_SYS.Get_Base_View(lu_name_);
   table_name_ := Dictionary_SYS.Get_Base_Table_Name(lu_name_);
   code_ := Fnd_Code_Template_API.Get_Template('RecUpdateTrackingTrigger');
   
   tags1_(1):= 'TRIGGER_NAME';
   vals1_(1):= trigger_name_;
   
   tags1_(2):= 'TABLE_NAME';
   vals1_(2):= table_name_;
   
   tags1_(3):= 'LU_NAME';
   vals1_(3):= lu_name_;
   
   tags1_(4):= 'TRK_QUEUE_NAME';
   vals1_(4):= Fnd_Session_API.Get_App_Owner ||'.'||Fnd_Obj_Tracking_SYS.tracking_queue_name_;
   
   tags1_(5):= 'VIEW_NAME';
   vals1_(5):= base_view_name_;
   
   Fnd_Code_Template_API.Replace_Tags(tags1_,vals1_,code_);
   
   --inserting recurring tags 
   SELECT column_name BULK COLLECT INTO tab_col_list_
   FROM user_tab_columns 
   WHERE table_name = table_name_
   AND data_type IN ('NUMBER','VARCHAR2','DATE')
   AND column_name NOT IN ('ROWKEY', 'TEXT_ID$'); -- No need to track these 
   
   tags_(1):= 'COLUMN_NAME';
   
   FOR i IN 1..tab_col_list_.COUNT LOOP
      tag_n_vals_(i)(1):= tab_col_list_(i);
   END LOOP;
   
   Fnd_Code_Template_API.Replace_Recurring_Tags('COL_CHECK_BEGIN','COL_CHECK_END',tags_,tag_n_vals_,(chr(13)||chr(10)),code_);
   --Safe due to lu_name assert check and generated trigger_name
   @ApproveDynamicStatement(2014-07-25,wawilk)
   EXECUTE IMMEDIATE code_;   
END Generate_Update_Trk_Trigger___;

PROCEDURE Generate_Delete_Trk_Trigger___ (
   lu_name_ IN     VARCHAR2,
   trigger_name_ IN VARCHAR2 )
IS
   code_ CLOB;
   tags1_ fnd_code_template_api.List_Typ;
   vals1_ fnd_code_template_api.List_Typ;
   
   base_view_name_ VARCHAR2(50); 
   table_name_ VARCHAR2(50);
   
BEGIN 
   Assert_SYS.Assert_Is_Logical_Unit(lu_name_);
   base_view_name_ := Dictionary_SYS.Get_Base_View(lu_name_);
   table_name_ := Dictionary_SYS.Get_Base_Table_Name(lu_name_);
   code_ := Fnd_Code_Template_API.Get_Template('RecDeleteTrackingTrigger');
   
   tags1_(1):= 'TRIGGER_NAME';
   vals1_(1):= trigger_name_;
   
   tags1_(2):= 'TABLE_NAME';
   vals1_(2):= table_name_;
   
   tags1_(3):= 'LU_NAME';
   vals1_(3):= lu_name_;
   
   tags1_(4):= 'TRK_QUEUE_NAME';
   vals1_(4):= fnd_session_api.Get_App_Owner ||'.'||Fnd_Obj_Tracking_SYS.tracking_queue_name_;
   
   tags1_(5):= 'VIEW_NAME';
   vals1_(5):= base_view_name_;
   
   fnd_code_template_api.Replace_Tags(tags1_,vals1_,code_);
   --Safe due to lu_name assert check and generated trigger_name
   @ApproveDynamicStatement(2014-07-25,wawilk)
   EXECUTE IMMEDIATE code_;   
END Generate_Delete_Trk_Trigger___;

PROCEDURE Remove_Triggers___(
   rec_         IN fnd_obj_tracking_runtime_tab%ROWTYPE )
IS
BEGIN
   Assert_SYS.Assert_Is_Trigger(rec_.update_trigger);
   Assert_SYS.Assert_Is_Trigger(rec_.delete_trigger);
   --Safe as not exposed in the specification
   @ApproveDynamicStatement(2014-07-25,wawilk)
   EXECUTE IMMEDIATE 'DROP TRIGGER ' || rec_.update_trigger ;
   @ApproveDynamicStatement(2014-07-25,wawilk)
   EXECUTE IMMEDIATE 'DROP TRIGGER ' || rec_.delete_trigger ;
END Remove_Triggers___;

PROCEDURE Generate_Triggers___(
   rec_         IN fnd_obj_tracking_runtime_tab%ROWTYPE )
IS
BEGIN
   Generate_Update_Trk_Trigger___(rec_.lu_name,rec_.update_trigger);
   Generate_Delete_Trk_Trigger___(rec_.lu_name,rec_.delete_trigger);
END Generate_Triggers___;

PROCEDURE Generate_Trk_Trigger_Names___(
   lu_name_ IN VARCHAR2,
   update_trigger_ OUT VARCHAR2,
   delete_trigger_ OUT VARCHAR2 )
IS
   base_view_ VARCHAR2(30);
   trigger_name_begin_ VARCHAR2(30);
BEGIN
   base_view_ := Dictionary_SYS.Get_Base_View(lu_name_);
   IF length(base_view_) > 24 THEN
      select ora_hash(base_view_,4294967295) into trigger_name_begin_ from dual;
      trigger_name_begin_ := substr(base_view_,1,14)||trigger_name_begin_;
   ELSE
      trigger_name_begin_ := base_view_; 
   END IF;
   update_trigger_ := CONCAT(trigger_name_begin_,update_trigger_suffix_);
   delete_trigger_ := CONCAT(trigger_name_begin_,delete_trigger_suffix_);
END Generate_Trk_Trigger_Names___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT fnd_obj_tracking_runtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Assert_SYS.Assert_Is_Logical_Unit(newrec_.lu_name);
   super(newrec_, indrec_, attr_);
END Check_Insert___;

PROCEDURE Enable_Triggers___(
   rec_ IN fnd_obj_tracking_runtime_tab%ROWTYPE )
IS
BEGIN
   Assert_SYS.Assert_Is_Trigger(rec_.update_trigger);
   Assert_SYS.Assert_Is_Trigger(rec_.delete_trigger);
   --Safe as not exposed in the specification
   @ApproveDynamicStatement(2014-07-25,wawilk)
   EXECUTE IMMEDIATE 'ALTER TRIGGER ' || rec_.update_trigger || ' ENABLE'; 
   @ApproveDynamicStatement(2014-07-25,wawilk)
   EXECUTE IMMEDIATE 'ALTER TRIGGER ' || rec_.delete_trigger || ' ENABLE';
END Enable_Triggers___;

PROCEDURE Disable_Triggers___(
   rec_ IN fnd_obj_tracking_runtime_tab%ROWTYPE )
IS
BEGIN
   Assert_SYS.Assert_Is_Trigger(rec_.update_trigger);
   Assert_SYS.Assert_Is_Trigger(rec_.delete_trigger);
   --Safe as not exposed in the specification
   @ApproveDynamicStatement(2014-07-25,wawilk)
   EXECUTE IMMEDIATE 'ALTER TRIGGER ' || rec_.update_trigger || ' DISABLE';
   @ApproveDynamicStatement(2014-07-25,wawilk)
   EXECUTE IMMEDIATE 'ALTER TRIGGER ' || rec_.delete_trigger || ' DISABLE';
END Disable_Triggers___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Activate_Tracking__(
   lu_name_ IN     VARCHAR2 )
IS
   rec_ fnd_obj_tracking_runtime_tab%ROWTYPE;
   active_subscriptions_ NUMBER := 0;
BEGIN 
   IF Security_SYS.Has_System_Privilege('ADMINISTRATOR') = 'FALSE' THEN
      Error_SYS.Appl_General(lu_name_, 'NOPRIV: You do not have the priviledge to perform this operation');
   END IF;
   --SOLSETFW
   SELECT COUNT(*) INTO active_subscriptions_ FROM fnd_obj_subscription_tab s,dictionary_sys_tab d, module_tab m 
      WHERE s.lu_name = lu_name_ AND disabled = 'FALSE' AND s.lu_name = d.lu_name AND d.module = m.module AND m.active = 'TRUE'; 
   rec_ := Get_Object_By_Keys___(lu_name_);
   IF active_subscriptions_ > 0 THEN
      Generate_Trk_Trigger_Names___(lu_name_,rec_.update_trigger,rec_.delete_trigger);
      rec_.active := Fnd_Boolean_API.DB_TRUE;
      rec_.running := Fnd_Boolean_API.DB_TRUE;
      Modify___(rec_);
      Generate_Triggers___(rec_);
   ELSE
      Remove___(rec_);         
   END IF;
END Activate_Tracking__;

PROCEDURE Deactivate_Tracking__(
   lu_name_ IN     VARCHAR2 )
IS
   rec_ fnd_obj_tracking_runtime_tab%ROWTYPE;
   oldrec_ fnd_obj_tracking_runtime_tab%ROWTYPE;
BEGIN 
   IF Security_SYS.Has_System_Privilege('ADMINISTRATOR') = 'FALSE' THEN
      Error_SYS.Appl_General(lu_name_, 'NOPRIV: You do not have the priviledge to perform this operation');
   END IF;
   oldrec_ := Get_Object_By_Keys___(lu_name_);
   IF oldrec_.lu_name IS NOT NULL THEN
      rec_ := oldrec_;
      rec_.active := Fnd_Boolean_API.DB_FALSE;
      rec_.update_trigger := NULL;
      rec_.delete_trigger := NULL;
      rec_.running := Fnd_Boolean_API.DB_FALSE;
      Modify___(rec_);
      Remove_Triggers___(oldrec_);
   ELSE
      rec_.lu_name := lu_name_;
      rec_.active := Fnd_Boolean_API.DB_FALSE;
      rec_.running := Fnd_Boolean_API.DB_FALSE;
      New___(rec_);
   END IF;
END Deactivate_Tracking__;

@UncheckedAccess
FUNCTION Get_Trigger_Status__ (
   trigger_name_ IN VARCHAR2 
   ) RETURN VARCHAR2 
IS
   status_ VARCHAR2(20) := NULL;
BEGIN
   select status into status_ from user_objects where object_name = trigger_name_;
   IF (status_ = 'INVALID') THEN
      RETURN status_;
   END IF;
   select status into status_ from user_triggers where trigger_name = trigger_name_;
   RETURN status_;
END Get_Trigger_Status__;

PROCEDURE Regenerate_Triggers__ (
   lu_name_ IN VARCHAR2,
   update_trigger_ IN VARCHAR2 DEFAULT NULL,
   delete_trigger_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   IF Security_SYS.Has_System_Privilege('ADMINISTRATOR') = 'FALSE' THEN
      Error_SYS.Appl_General(lu_name_, 'NOPRIV: You do not have the priviledge to perform this operation');
   END IF;
   IF (update_trigger_ IS NOT NULL) THEN 
      Assert_SYS.Assert_Is_Trigger(update_trigger_);
      Generate_Update_Trk_Trigger___(lu_name_,update_trigger_);
   END IF;
   IF (delete_trigger_ IS NOT NULL) THEN 
      Assert_SYS.Assert_Is_Trigger(delete_trigger_);
      Generate_Delete_Trk_Trigger___(lu_name_,delete_trigger_);
   END IF;
END Regenerate_Triggers__;  
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Refresh_Lu_ (
   lu_name_ IN     VARCHAR2 )
IS
   rec_ Fnd_Obj_Tracking_Runtime_API.Public_Rec;
BEGIN
   rec_ := Get(lu_name_);
   IF rec_.active = Fnd_Boolean_API.DB_TRUE AND rec_.running = Fnd_Boolean_API.DB_TRUE THEN  
      NULL;
   ELSIF rec_.active = Fnd_Boolean_API.DB_TRUE AND rec_.running = Fnd_Boolean_API.DB_FALSE THEN
      Continue_Tracking_(lu_name_);
   ELSIF rec_.active = Fnd_Boolean_API.DB_FALSE THEN
      Error_SYS.Appl_General(lu_name_, 'TRACKINGINACTIVE: Subscriptions are disabled for ":P1". Contact the Administrator', lu_name_);
   ELSIF rec_.lu_name IS NULL THEN
      Register_Lu_(lu_name_);
   ELSE
      Error_SYS.Appl_General(lu_name_, 'RUNTIMECORRUPTED: Runtime information for ":P1" is corrupted', lu_name_);
   END IF;
END Refresh_Lu_;

PROCEDURE Register_Lu_(
   lu_name_ IN     VARCHAR2 )
IS
   newrec_ fnd_obj_tracking_runtime_tab%ROWTYPE;
   
BEGIN   
   newrec_.lu_name := lu_name_;
   newrec_.active := Fnd_Boolean_API.DB_TRUE;
   newrec_.running := Fnd_Boolean_API.DB_TRUE;
   Generate_Trk_Trigger_Names___(lu_name_,newrec_.update_trigger,newrec_.delete_trigger);
   New___(newrec_);
   Generate_Triggers___(newrec_);
END Register_Lu_;

PROCEDURE Discontinue_Tracking_(
   lu_name_ IN VARCHAR2 )
IS
   rec_ fnd_obj_tracking_runtime_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(lu_name_);
   IF rec_.active = Fnd_Boolean_API.DB_TRUE THEN    
      rec_.running := Fnd_Boolean_API.DB_FALSE;
      Modify___(rec_);
      Disable_Triggers___(rec_);
   END IF;
END Discontinue_Tracking_;
 
PROCEDURE Continue_Tracking_(
   lu_name_ IN VARCHAR2 )
IS
   rec_ fnd_obj_tracking_runtime_tab%ROWTYPE;
BEGIN    
   rec_ := Get_Object_By_Keys___(lu_name_);
   IF rec_.active = Fnd_Boolean_API.DB_TRUE THEN 
      rec_.running := Fnd_Boolean_API.DB_TRUE;
      Modify___(rec_);
      Enable_Triggers___(rec_);
   ELSE
      Error_SYS.Appl_General(lu_name_, 'LUDISABLED: Object tracking for this logical unit is disabled by the administrator');
   END IF;
END Continue_Tracking_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

