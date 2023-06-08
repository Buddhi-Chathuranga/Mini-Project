-----------------------------------------------------------------------------
--
--  Logical unit: FunctionalAreaConflict
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  060627  UTGULK Created.(Bug Id 58699 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Is_Accessible_Area (
   functional_area_id_ IN VARCHAR2,
   user_identity_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_activities IS
      SELECT activity_name
      FROM functional_area_activity_tab
      WHERE functional_area_id = functional_area_id_;
   CURSOR get_views IS
      SELECT view_name
      FROM functional_area_view_tab
      WHERE functional_area_id = functional_area_id_ ;
   CURSOR get_methods IS
      SELECT package_name, method_name
      FROM functional_area_method_tab
      WHERE functional_area_id = functional_area_id_ ;
   CURSOR get_projections IS
      SELECT projection_name
      FROM func_area_projection
      WHERE functional_area_id = functional_area_id_;
   CURSOR get_proj_actions IS
      SELECT projection_name,projection_action
      FROM func_area_proj_action
      WHERE functional_area_id = functional_area_id_;
   CURSOR get_proj_entities IS
      SELECT projection_name,projection_entity
      FROM func_area_proj_entity
      WHERE functional_area_id = functional_area_id_;
   CURSOR get_proj_entity_actions IS
      SELECT projection_name,projection_entity,entity_action
      FROM func_area_proj_ent_act
      WHERE functional_area_id = functional_area_id_;
   FUNCTION Activity_Available___ (
   activity_name_ IN VARCHAR2 ) RETURN BOOLEAN
   IS
   CURSOR get_activity IS
      SELECT 1
      FROM   activity_grant_tab
      WHERE  activity_name = activity_name_
      AND    role IN (SELECT role
                      FROM   fnd_user_role_runtime_tab
                      WHERE  identity = user_identity_);
    BEGIN
       FOR rec_ IN get_activity LOOP
          RETURN(TRUE);
       END LOOP;
       RETURN(FALSE);
    END Activity_Available___;
    FUNCTION View_Available___ (
    view_name_ IN VARCHAR2 ) RETURN BOOLEAN
    IS
    CURSOR get_view IS
    SELECT 1
       FROM   security_sys_privs_tab
       WHERE  table_name = upper(view_name_)
       AND    grantee IN (SELECT role
                          FROM   fnd_user_role_runtime_tab
                          WHERE  identity = user_identity_);
    BEGIN
       FOR rec_ IN get_view LOOP
          RETURN TRUE;
       END LOOP;
       RETURN(FALSE);
    END View_Available___;
    FUNCTION Method_Available___ (
    package_name_ IN VARCHAR2,
    method_name_  IN VARCHAR2 ) RETURN BOOLEAN
    IS
    CURSOR get_method IS
    SELECT grantee
       FROM   security_sys_privs_tab
       WHERE  table_name = package_name_
       AND    grantee IN (SELECT role
                          FROM   fnd_user_role_runtime_tab
                          WHERE  identity = user_identity_)
       MINUS
       SELECT role
       FROM   security_sys_tab
       WHERE  package_name = package_name_
       AND    method_name  = method_name_
       AND    role IN (SELECT role
                       FROM   fnd_user_role_runtime_tab
                       WHERE  identity = user_identity_);
    BEGIN
       FOR rec_ IN get_method LOOP
          RETURN TRUE;
       END LOOP;
       RETURN(FALSE);
    END Method_Available___;
    FUNCTION Projection_Available___ (
    proj_name_ IN VARCHAR2 ) RETURN BOOLEAN
    IS
    CURSOR get_projection IS
      SELECT 1
      FROM   Fnd_Projection_Grant_Tab
      WHERE  projection = proj_name_
      AND    role IN (SELECT role
                      FROM   fnd_user_role_runtime_tab
                      WHERE  identity = user_identity_);
    BEGIN
       FOR rec_ IN get_projection LOOP
          RETURN(TRUE);
       END LOOP;
       RETURN(FALSE);
    END Projection_Available___;
    FUNCTION Proj_Action_Available___ (
    proj_name_ IN VARCHAR2,
    act_name_ IN VARCHAR2) RETURN BOOLEAN
    IS
    CURSOR get_proj_action IS
      SELECT 1
      FROM   FND_PROJ_ACTION_GRANT_TAB
      WHERE  projection = proj_name_ AND action = act_name_
      AND    role IN (SELECT role
                      FROM   fnd_user_role_runtime_tab
                      WHERE  identity = user_identity_);
    BEGIN
       FOR rec_ IN get_proj_action LOOP
          RETURN(TRUE);
       END LOOP;
       RETURN(FALSE);
    END Proj_Action_Available___;
    
    FUNCTION Proj_Entity_Available___ (
    proj_name_ IN VARCHAR2,
    entity_ IN VARCHAR2) RETURN BOOLEAN
    IS
    CURSOR get_proj_entity IS
      SELECT 1
      FROM   Fnd_Proj_Entity_Grant_Tab
      WHERE  projection = proj_name_ AND entity = entity_ AND cud_allowed = 'TRUE'
      AND    role IN (SELECT role
                      FROM   fnd_user_role_runtime_tab
                      WHERE  identity = user_identity_);
    BEGIN
       FOR rec_ IN get_proj_entity LOOP
          RETURN(TRUE);
       END LOOP;
       RETURN(FALSE);
    END Proj_Entity_Available___;
   
    FUNCTION Proj_Entity_Act_Available___ (
    proj_name_ IN VARCHAR2,
    entity_ IN VARCHAR2,
    action_ IN VARCHAR2) RETURN BOOLEAN
    IS
    CURSOR get_proj_entity_act IS
      SELECT 1
      FROM   fnd_proj_ent_action_grant_tab
      WHERE  projection = proj_name_ AND entity = entity_ AND action = action_
      AND    role IN (SELECT role
                      FROM   fnd_user_role_runtime_tab
                      WHERE  identity = user_identity_);
    BEGIN
       FOR rec_ IN get_proj_entity_act LOOP
          RETURN(TRUE);
       END LOOP;
       RETURN(FALSE);
    END Proj_Entity_Act_Available___;
    
BEGIN
    FOR activity_ IN get_activities LOOP
       IF Activity_Available___ (activity_.activity_name) THEN
          RETURN 'TRUE' ;
       END IF;
    END LOOP;
    FOR view_ IN get_views LOOP
       IF View_Available___(view_.view_name) THEN
          RETURN 'TRUE' ;
       END IF;
    END LOOP;
    FOR method_ IN get_methods LOOP
       IF Method_Available___(method_.package_name, initcap(method_.method_name)) THEN
          RETURN 'TRUE' ;
       END IF;
    END LOOP;
    FOR projection_ IN get_projections LOOP
      IF Projection_Available___ (projection_.projection_name) THEN
          RETURN 'TRUE' ;
      END IF;
    END LOOP;
    FOR proj_action_ IN get_proj_actions LOOP
      IF Proj_Action_Available___ (proj_action_.projection_name,proj_action_.projection_action) THEN
          RETURN 'TRUE' ;
      END IF;
   END LOOP;
   FOR proj_entity_ IN get_proj_entities LOOP
      IF Proj_Entity_Available___ (proj_entity_.projection_name,proj_entity_.projection_entity) THEN
          RETURN 'TRUE' ;
      END IF;
   END LOOP;
   FOR proj_entity_act_ IN get_proj_entity_actions LOOP
      IF Proj_Entity_Act_Available___ (proj_entity_act_.projection_name,proj_entity_act_.projection_entity,proj_entity_act_.entity_action) THEN
          RETURN 'TRUE' ;
      END IF;
   END LOOP;
   RETURN 'FALSE' ;
END Is_Accessible_Area;


@UncheckedAccess
FUNCTION Get_Permission_Set (
   user_identity_        IN VARCHAR2,
   security_object_      IN VARCHAR2,
   security_object_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   permisssion_set_ VARCHAR2(2000);
   pkg_             VARCHAR2(30);
   method_          VARCHAR2(30);
   proj_            VARCHAR2(100);
   action_          VARCHAR2(100);
   entity_          VARCHAR2(100);
   CURSOR get_activity_permissions IS
      SELECT role
      FROM   activity_grant_tab
      WHERE  activity_name = security_object_
      AND    role IN (SELECT role
                      FROM   fnd_user_role_runtime_tab
                      WHERE  identity = user_identity_);
   CURSOR get_view_permissions IS
      SELECT grantee
      FROM   security_sys_privs_tab
      WHERE  table_name = upper(security_object_)
      AND    grantee IN (SELECT role
                         FROM   fnd_user_role_runtime_tab
                         WHERE  identity = user_identity_);
   CURSOR get_method_permissions(pkg_ IN VARCHAR2, method_ IN VARCHAR2) IS
      SELECT grantee
      FROM   security_sys_privs_tab
      WHERE  table_name = pkg_
      AND    grantee IN (SELECT role
                         FROM   fnd_user_role_runtime_tab
                         WHERE  identity = user_identity_)
      MINUS
      SELECT role
      FROM   security_sys_tab
      WHERE  package_name = pkg_
      AND    method_name  = method_
      AND    role IN (SELECT role
                      FROM   fnd_user_role_runtime_tab
                      WHERE  identity = user_identity_);
   CURSOR get_proj_permissions IS
      SELECT role
      FROM   fnd_projection_grant_tab
      WHERE  projection = security_object_
      AND    role IN (SELECT role
                      FROM   fnd_user_role_runtime_tab
                      WHERE  identity = user_identity_);
   CURSOR get_proj_act_permissions(proj_ IN VARCHAR2, action_ IN VARCHAR2) IS
      SELECT role
      FROM   fnd_proj_action_grant_tab
      WHERE  projection = proj_ AND action = action_
      AND    role IN (SELECT role
                      FROM   fnd_user_role_runtime_tab
                      WHERE  identity = user_identity_);
   CURSOR get_proj_ent_permissions(proj_ IN VARCHAR2, entity_ IN VARCHAR2) IS
      SELECT role
      FROM   fnd_proj_entity_grant_tab
      WHERE  projection = proj_ AND entity = entity_ AND cud_allowed = 'TRUE'
      AND    role IN (SELECT role
                      FROM   fnd_user_role_runtime_tab
                      WHERE  identity = user_identity_);
   CURSOR get_proj_ent_act_permissions(proj_ IN VARCHAR2, entity_ IN VARCHAR2, action_ IN VARCHAR2) IS
      SELECT role
      FROM   fnd_proj_ent_action_grant_tab
      WHERE  projection = proj_ AND entity = entity_ AND action = action_
      AND    role IN (SELECT role
                      FROM   fnd_user_role_runtime_tab
                      WHERE  identity = user_identity_);
BEGIN
   IF security_object_type_ = 'ACTIVITY'  THEN
      FOR rec_ IN get_activity_permissions LOOP
         IF permisssion_set_ IS NULL THEN
            permisssion_set_ := permisssion_set_ || rec_.role;
         ELSE
            permisssion_set_ := permisssion_set_ || '^' || rec_.role;
         END IF;
      END LOOP;
   ELSIF security_object_type_ = 'VIEW' THEN
      FOR rec_ IN get_view_permissions LOOP
         IF permisssion_set_ IS NULL THEN
            permisssion_set_ := permisssion_set_ || rec_.grantee;
         ELSE
            permisssion_set_ := permisssion_set_ || '^' || rec_.grantee;
         END IF;
      END LOOP;
   ELSIF security_object_type_ = 'METHOD'  THEN
      pkg_ := upper(substr(security_object_, 1, instr(security_object_, '.') - 1));
      method_ := initcap(substr(security_object_, instr(security_object_, '.') + 1));
      FOR rec_ IN get_method_permissions(pkg_, method_) LOOP
         IF permisssion_set_ IS NULL THEN
            permisssion_set_ := permisssion_set_ || rec_.grantee;
         ELSE
            permisssion_set_ := permisssion_set_ || '^' || rec_.grantee;
         END IF;
      END LOOP;
   ELSIF security_object_type_ = 'PROJECTION' THEN
      FOR rec_ IN get_proj_permissions LOOP
         IF permisssion_set_ IS NULL THEN
            permisssion_set_ := permisssion_set_ || rec_.role;
         ELSE
            permisssion_set_ := permisssion_set_ || '^' ||  rec_.role;
         END IF;
      END LOOP;
   ELSIF security_object_type_ = 'PROJECTION_ACTION' THEN
      proj_ := substr(security_object_, 1, instr(security_object_, '.') - 1);
      action_ := substr(security_object_, instr(security_object_, '.') + 1);
      FOR rec_ IN get_proj_act_permissions(proj_,action_) LOOP
         IF permisssion_set_ IS NULL THEN
            permisssion_set_ := permisssion_set_ || rec_.role;
         ELSE
            permisssion_set_ := permisssion_set_ || '^' ||  rec_.role;
         END IF;
      END LOOP;
   ELSIF security_object_type_ = 'PROJECTION_ENTITY' THEN
      proj_ := substr(security_object_, 1, instr(security_object_, '.') - 1);
      entity_ := substr(security_object_, instr(security_object_, '.') + 1);      
      FOR rec_ IN get_proj_ent_permissions(proj_,entity_) LOOP
         IF permisssion_set_ IS NULL THEN
            permisssion_set_ := permisssion_set_ || rec_.role;
         ELSE
            permisssion_set_ := permisssion_set_ || '^' ||  rec_.role;
         END IF;
      END LOOP;   
   ELSIF security_object_type_ = 'PROJECTION_ENTITY_ACTION' THEN
      proj_ := substr(security_object_, 1, instr(security_object_, '.') - 1);        
      entity_ := substr(security_object_, instr(security_object_, '.')+1,instr(security_object_, '.',1, 2) - instr(security_object_, '.')-1);
      action_ := substr(security_object_, instr(security_object_, '.',1,2) + 1);
      FOR rec_ IN get_proj_ent_act_permissions(proj_,entity_,action_) LOOP
         IF permisssion_set_ IS NULL THEN
            permisssion_set_ := permisssion_set_ || rec_.role;
         ELSE
            permisssion_set_ := permisssion_set_ || '^' ||  rec_.role;
         END IF;
      END LOOP;
   END IF;
   RETURN permisssion_set_;
END Get_Permission_Set;

FUNCTION Number_Of_Users 
RETURN number IS 
   count_ NUMBER;
   BEGIN      
      SELECT  COUNT(DISTINCT userid) into count_ 
      FROM USER_FUNCTIONAL_AREA_CONFLICTS;  
   RETURN count_; 
   END Number_Of_Users;
   
FUNCTION Number_of_Conflicts 
RETURN number IS 
   user_count_ NUMBER;
   BEGIN      
      SELECT  COUNT(DISTINCT conflict_name) into user_count_ 
      FROM USER_FUNCTIONAL_AREA_CONFLICTS;  
   RETURN user_count_; 
END Number_of_Conflicts;
   
FUNCTION Check_Conf_Existance(func_area_id_ VARCHAR2,conflict_area_id_ VARCHAR2,conf_name_ VARCHAR2)RETURN BOOLEAN 
IS 
   name_of_conf_ functional_area_conflict_tab.conflict_name%TYPE;
   CURSOR get_con_name_ IS 
      SELECT conflict_name 
      FROM  functional_area_conflict_tab
      WHERE conflict_name = conf_name_;
BEGIN 
   OPEN get_con_name_;
   FETCH get_con_name_ INTO name_of_conf_;
   CLOSE get_con_name_;
   IF (functional_area_conflict_api.Exists(func_area_id_,conflict_area_id_) OR functional_area_conflict_api.Exists(conflict_area_id_,func_area_id_)) OR (name_of_conf_ IS NOT NULL ) THEN
      RETURN TRUE;
   ELSE 
      RETURN FALSE;
   END IF;
END Check_Conf_Existance;
