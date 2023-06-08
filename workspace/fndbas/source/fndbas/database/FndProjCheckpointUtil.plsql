-----------------------------------------------------------------------------
--
--  Logical unit: FndProjCheckpointUtil
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

TYPE Metadata_Params IS RECORD (
   has_values      BOOLEAN,
   projection_name VARCHAR2(100),
   action_name       VARCHAR2(100),
   entity_name     VARCHAR2(100));
   
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Extract_Metadata_Params___ (
   json_message_ IN VARCHAR2) RETURN Metadata_Params
IS
   params_ Metadata_Params;
   json_object_ JSON_OBJECT_T;
   
BEGIN
   json_object_ := JSON_OBJECT_T(json_message_);
   
   params_.projection_name := json_object_.get_string('Projection');
   params_.action_name := json_object_.get_string('Action');
   params_.entity_name := json_object_.get_string('Entity');
   
   params_.has_values := TRUE;   
   RETURN params_;
EXCEPTION
   WHEN OTHERS THEN
      params_.has_values := FALSE;
      RETURN params_;
END Extract_Metadata_Params___;

FUNCTION Build_Json___ (
   active_ IN VARCHAR2,
   all_users_ IN VARCHAR2,
   comments_ IN VARCHAR2,
   checkpoint_type_ IN VARCHAR2) RETURN JSON_OBJECT_T
IS
   json_ JSON_OBJECT_T;
BEGIN
   json_ := JSON_OBJECT_T();
   IF (TRUE) THEN
      json_.put('Active', active_);
   END IF;
   IF (TRUE) THEN
      json_.put('AllUsersAllowed', all_users_);
   END IF;
   IF (TRUE) THEN
      json_.put('CommentsRequired', comments_);
   END IF;
   IF (TRUE) THEN
      json_.put('CheckpointType', checkpoint_type_);
   END IF;
   RETURN json_;
END Build_Json___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
FUNCTION Is_Proj_Action_Available__ (
   projection_name_ IN VARCHAR2,
   action_name_     IN VARCHAR2,
   fnd_user_        IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Proj_Action_Grant_API.Is_Available(projection_name_, action_name_, UPPER(fnd_user_));
END Is_Proj_Action_Available__;

FUNCTION Is_Proj_Entity_Act_Available__ (
   projection_name_ IN VARCHAR2,
   entity_name_     IN VARCHAR2,
   action_name_     IN VARCHAR2,
   fnd_user_        IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Proj_Ent_Action_Grant_API.Is_Available(projection_name_, entity_name_, action_name_, UPPER(fnd_user_));
END Is_Proj_Entity_Act_Available__;
   
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Route_Callback_Content_ (
   method_ IN VARCHAR2,
   param_  IN VARCHAR2,
   clob_   OUT NOCOPY CLOB) RETURN BOOLEAN
IS
BEGIN
   CASE method_
      WHEN 'CHECKPOINT_ACTIVE_METADATA' THEN
         clob_ := CHECKPOINT_ACTIVE_METADATA(param_);
      ELSE
         clob_ := '';         
         RETURN FALSE;
      END CASE;
      
   RETURN TRUE;
END Route_Callback_Content_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Clear_Odata_Cache (
   checkpoints_            IN VARCHAR2,
   legacy_                 IN VARCHAR2 DEFAULT 'FALSE')
IS
   checkpoints_list_    VARCHAR2(4000);
   legacy_points_       VARCHAR2(4000);
   
   -- This is a workaround to overcome a developer studio bug mentioned in the below commented cursor.
   CURSOR get_clients IS
      SELECT DISTINCT act.projection_name, client
      FROM FND_PROJ_ACTION_TAB act, FND_PROJECTION_USAGE_TAB usg
      WHERE act.projection_name = usg.projection_name
      AND ((act.checkpoint IN (  SELECT regexp_substr(checkpoints_list_,'[^,]+', 1, level) FROM dual 
                                 CONNECT BY regexp_substr(checkpoints_list_,'[^,]+', 1, level) IS NOT NULL)) 
            OR (act.legacy_checkpoints IN (  SELECT regexp_substr(legacy_points_,'[^,]+', 1, level) FROM dual 
                                             CONNECT BY regexp_substr(legacy_points_,'[^,]+', 1, level) IS NOT NULL)))
      UNION
      SELECT DISTINCT eact.projection_name, client
      FROM FND_PROJ_ENT_ACTION_TAB eact, FND_PROJECTION_USAGE_TAB eusg
      WHERE eact.projection_name = eusg.projection_name
      AND ((eact.checkpoint IN (  SELECT regexp_substr(checkpoints_list_,'[^,]+', 1, level) FROM dual 
                                 CONNECT BY regexp_substr(checkpoints_list_,'[^,]+', 1, level) IS NOT NULL)) 
            OR (eact.legacy_checkpoints IN (  SELECT regexp_substr(legacy_points_,'[^,]+', 1, level) FROM dual 
                                             CONNECT BY regexp_substr(legacy_points_,'[^,]+', 1, level) IS NOT NULL)));
                                             
   /* Following cursor is the right one which will only select clients, where the action related to check point is used
   But this is commented for the moment because due to code generation bug some usages are not generated. When 
   developer studio team fixes those issues following cursor should be used instead of the above one.
   CURSOR get_clients IS
      SELECT act.projection_name, client
      FROM FND_PROJ_ACTION_TAB act, FND_PROJ_ACTION_USAGE_TAB usg
      WHERE act.projection_name = usg.projection_name
      AND act.action_name = usg.action_name
      AND ((act.checkpoint IN (  SELECT regexp_substr(checkpoints_list_,'[^,]+', 1, level) FROM dual 
                                 CONNECT BY regexp_substr(checkpoints_list_,'[^,]+', 1, level) IS NOT NULL)) 
            OR (act.legacy_checkpoints IN (  SELECT regexp_substr(legacy_points_,'[^,]+', 1, level) FROM dual 
                                             CONNECT BY regexp_substr(legacy_points_,'[^,]+', 1, level) IS NOT NULL)))
      UNION
      SELECT eact.projection_name, client
      FROM FND_PROJ_ENT_ACTION_TAB eact, FND_PROJ_ENT_ACTION_USAGE_TAB eusg
      WHERE eact.projection_name = eusg.projection_name
      AND eact.action_name = eusg.action_name
      AND ((eact.checkpoint IN (  SELECT regexp_substr(checkpoints_list_,'[^,]+', 1, level) FROM dual 
                                 CONNECT BY regexp_substr(checkpoints_list_,'[^,]+', 1, level) IS NOT NULL)) 
            OR (eact.legacy_checkpoints IN (  SELECT regexp_substr(legacy_points_,'[^,]+', 1, level) FROM dual 
                                             CONNECT BY regexp_substr(legacy_points_,'[^,]+', 1, level) IS NOT NULL))); */
      
BEGIN
   IF legacy_ = 'TRUE' THEN
      legacy_points_ := checkpoints_;
   ELSE
      checkpoints_list_ := checkpoints_;
   END IF;
   FOR rec_ IN get_clients LOOP      
      Model_Design_SYS.Refresh_Projection_Version(rec_.projection_name);
      Model_Design_SYS.Refresh_Client_Version(rec_.client);
   END LOOP;
END Clear_Odata_Cache;



FUNCTION Are_Checkpoints_Enabled RETURN VARCHAR2
IS
   answer_ VARCHAR2(4000);
   CURSOR checkpoint_globals IS
   SELECT Checkpoints_Enabled FROM fnd_proj_checkpoint_globals;
BEGIN
   OPEN checkpoint_globals;
   FETCH checkpoint_globals INTO answer_;
   CLOSE checkpoint_globals;
   IF answer_ = 'ON' THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Are_Checkpoints_Enabled;


FUNCTION Checkpoint_Active_Metadata (
   params_ IN VARCHAR2 ) RETURN CLOB
IS
   projection_name_ VARCHAR2(100);
   action_name_ VARCHAR2(100);
   entity_name_ VARCHAR2(100);
   checkpoint_ VARCHAR2(100);
   legacy_checkpoints_ VARCHAR2(400);
   chkpt_active_  VARCHAR2(100);
   comments_required_  VARCHAR2(100);
   all_users_valid_ VARCHAR2(100);
   checkpoint_type_ VARCHAR2(100);
   meta_params_ Metadata_Params;
   result_ CLOB := empty_clob();
   
   
   CURSOR get_action_checkpoints IS
         SELECT checkpoint, legacy_checkpoints
         FROM FND_PROJ_ACTION_TAB
         WHERE projection_name = projection_name_
         AND action_name = action_name_;
   
   CURSOR get_entact_checkpoints IS
         SELECT checkpoint, legacy_checkpoints
         FROM FND_PROJ_ENT_ACTION_TAB
         WHERE projection_name = projection_name_
         AND entity_name = entity_name_
         AND action_name = action_name_;
   
   CURSOR get_legacy_chkpts IS
      SELECT regexp_substr(legacy_checkpoints_,'[^^]+', 1, level) chkpt FROM dual
      CONNECT BY regexp_substr(legacy_checkpoints_,'[^^]+', 1, level) IS NOT NULL;
   
BEGIN
   
   meta_params_ := Extract_Metadata_Params___(params_);
   projection_name_ := meta_params_.projection_name;
   entity_name_ := meta_params_.entity_name;
   action_name_ := meta_params_.action_name;
   
   IF (Fnd_Setting_API.Get_Value('AUR_CHKPT_COMMENT') = 'ON') THEN
      comments_required_ := 'true';
   ELSE
      comments_required_ := 'false';
   END IF;
   
   IF (Fnd_Setting_API.Get_Value('AUR_CHKPT_ALLUSERS') = 'ON') THEN
      all_users_valid_ := 'true';
   ELSE
      all_users_valid_ := 'false';
   END IF;
   
   checkpoint_type_ := Fnd_Setting_API.Get_Value('AUR_CHKPT_TYPE');
   
   --Return false if Global checkpoint flag is set to False
   IF (Fnd_Setting_API.Get_Value('AUR_CHKPT_ACTIVE') = 'OFF') THEN
      chkpt_active_ := 'false';
      result_ := Build_Json___(chkpt_active_, all_users_valid_, comments_required_, checkpoint_type_).to_clob();
      RETURN result_;
   END IF;
      
   IF entity_name_ IS NOT NULL THEN
      FOR rec_ IN get_entact_checkpoints LOOP
         checkpoint_ :=  rec_.checkpoint;
         legacy_checkpoints_ := rec_.legacy_checkpoints;
      END LOOP;
   ELSE
      FOR rec_ IN get_action_checkpoints LOOP
         checkpoint_ :=  rec_.checkpoint;
         legacy_checkpoints_ := rec_.legacy_checkpoints;
      END LOOP;
   END IF;
  
   chkpt_active_ := 'false';
   IF Fnd_Proj_Checkpoint_Gate_API.Get_Active_Db(checkpoint_) = 'TRUE' THEN
      chkpt_active_ := 'true';
   ELSE
      FOR rec_ IN get_legacy_chkpts LOOP
         IF Sec_Checkpoint_Gate_API.Get_Active_Db(rec_.chkpt) = 'TRUE' THEN
            chkpt_active_ := 'true';
            EXIT;
         END IF;
      END LOOP;
   END IF;

   result_ :=  Build_Json___(chkpt_active_, all_users_valid_, comments_required_, checkpoint_type_).to_clob();
   RETURN result_;
      
EXCEPTION
   WHEN OTHERS THEN
      Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Security checkpoint status fetch failed with error: '|| SQLERRM);
      RETURN empty_clob();
END Checkpoint_Active_Metadata;

PROCEDURE Clear_OData_Cache_All_Chkpt
IS
   CURSOR checkpoint_list_ IS 
      SELECT GATE_ID 
      FROM FND_PROJ_CHECKPOINT_GATE_TAB;
      
   CURSOR legacy_list_ IS
      SELECT GATE_ID
      FROM SEC_CHECKPOINT_GATE_TAB;
BEGIN
   FOR rec_ IN checkpoint_list_ LOOP
      Fnd_Proj_Checkpoint_Util_API.Clear_Odata_Cache(rec_.GATE_ID, 'FALSE');
   END LOOP;
   FOR rec_ IN legacy_list_ LOOP
      Fnd_Proj_Checkpoint_Util_API.Clear_Odata_Cache(rec_.GATE_ID, 'TRUE');
   END LOOP;
END Clear_OData_Cache_All_Chkpt;
-------------------- LU  NEW METHODS -------------------------------------
