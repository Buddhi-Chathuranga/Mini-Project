-----------------------------------------------------------------------------
--
--  Logical unit: FndProjectionGrant
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

 --Check if editing of role is allowed. This check is done to help not violate the license by mistake.
PROCEDURE Check_Proj_Role_Restricted (
   projection_ IN VARCHAR2,
   role_  IN VARCHAR2)
IS
BEGIN
   IF (Security_Sys.Is_Ltu_Role(role_) OR Security_SYS.Is_Technical_Role(role_)) THEN
      Error_SYS.Appl_General(lu_name_, 'MODIFY_PROJECTION_ON_LTU: Security grants to permission set [:P1] is restricted by license. Grants to Projection [:P2] cannot be modified.', role_,projection_);
   END IF;
END Check_Proj_Role_Restricted;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Grant_Query_Entities___ (projection_ IN VARCHAR2, role_ IN VARCHAR2)
IS
   TYPE typ_entity IS TABLE OF fnd_proj_entity_tab.entity_name%TYPE;
   l_entities_ typ_entity;
BEGIN
      select entity_name bulk collect into l_entities_
         from fnd_proj_entity_tab where projection_name = projection_;
      FOR idx IN 1..l_entities_.COUNT LOOP
         Fnd_Proj_Entity_Grant_API.Grant_Query(projection_,l_entities_(idx),role_);
      END LOOP;
END Grant_Query_Entities___;

PROCEDURE Grant_Entities_All___ (projection_ IN VARCHAR2, role_ IN VARCHAR2)
IS
   TYPE typ_entity IS TABLE OF fnd_proj_entity_tab.entity_name%TYPE;
   l_entities_ typ_entity;
BEGIN
   select entity_name bulk collect into l_entities_
      from fnd_proj_entity_tab where projection_name = projection_;
   FOR idx_ IN 1..l_entities_.COUNT LOOP
      Fnd_Proj_Entity_Grant_API.Grant_All(projection_,l_entities_(idx_),role_);
   END LOOP;
END Grant_Entities_All___;

PROCEDURE Grant_Actions_All___ (projection_ IN VARCHAR2, role_ IN VARCHAR2)
IS
   TYPE typ_action IS TABLE OF fnd_proj_action_tab.action_name%TYPE;
   l_actions_ typ_action;
BEGIN
   select action_name bulk collect into l_actions_
      from fnd_proj_action_tab where projection_name=projection_;
   FOR idx_ IN 1..l_actions_.COUNT LOOP
      Fnd_Proj_Action_Grant_API.Do_Grant(projection_,l_actions_(idx_),role_);
   END LOOP;
END Grant_Actions_All___;

PROCEDURE Revoke_Entities_All___ (projection_ IN VARCHAR2, role_ IN VARCHAR2)
IS
   TYPE typ_entity_grants IS TABLE OF fnd_proj_entity_grant_tab.entity%TYPE;
   entity_grants_list_ typ_entity_grants;
BEGIN
   select entity bulk collect into entity_grants_list_
      from fnd_proj_entity_grant_tab where projection = projection_ and role = role_;
   FOR idx_ IN 1..entity_grants_list_.COUNT LOOP
      Fnd_Proj_Entity_Grant_API.Revoke_All_(projection_,entity_grants_list_(idx_),role_);
   END LOOP;
END Revoke_Entities_All___;

PROCEDURE Revoke_Actions_All___ (projection_ IN VARCHAR2, role_ IN VARCHAR2)
IS
   TYPE typ_action IS TABLE OF fnd_proj_action_grant_tab.action%TYPE;
   action_grants_list_ typ_action;
BEGIN
   select action bulk collect into action_grants_list_
      from fnd_proj_action_grant_tab where projection=projection_ and role=role_;
   FOR idx_ IN 1..action_grants_list_.COUNT LOOP
      Fnd_Proj_Action_Grant_API.Do_Revoke(projection_,action_grants_list_(idx_),role_);
   END LOOP;
END Revoke_Actions_All___;
   
PROCEDURE Revoke___ (projection_ IN VARCHAR2, role_ IN VARCHAR2)
IS
    rec_ fnd_projection_grant_tab%ROWTYPE;
BEGIN
   IF Check_Exist___(projection_,role_) THEN
      rec_.projection := projection_;
      rec_.role := role_;
      Remove___(rec_);
   END IF;
END Revoke___;      
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Grant_Query (projection_ IN VARCHAR2,
   role_ IN VARCHAR2,
   check_role_restricted_ VARCHAR2 DEFAULT 'TRUE')
IS
    rec_ fnd_projection_grant_tab%ROWTYPE;
BEGIN
   IF check_role_restricted_ = 'TRUE' THEN
      Check_Proj_Role_Restricted(projection_,role_);
   END IF;
   IF Check_Exist___(projection_,role_) THEN
      Revoke_All(projection_,role_);
   END IF;
   rec_.projection := projection_;
   rec_.role := role_;
   New___(rec_);
   Grant_Query_Entities___(projection_,role_);
END Grant_Query;

PROCEDURE Grant_All (
   projection_ IN VARCHAR2, 
   role_ IN VARCHAR2,
   check_role_restricted_ VARCHAR2 DEFAULT 'TRUE')
IS
   rec_ fnd_projection_grant_tab%ROWTYPE;
BEGIN
   IF check_role_restricted_ = 'TRUE' THEN
      Check_Proj_Role_Restricted(projection_,role_);
   END IF;
   
   IF Check_Exist___(projection_,role_) THEN
      Revoke_All(projection_,role_,check_role_restricted_);
   END IF;
   rec_.projection := projection_;
   rec_.role := role_;
   New___(rec_);
   Grant_Entities_All___(projection_,role_);
   Grant_Actions_All___(projection_,role_);
END Grant_All;

PROCEDURE Revoke_All (
   projection_ IN VARCHAR2, 
   role_ IN VARCHAR2,
   check_role_restricted_ VARCHAR2 DEFAULT 'TRUE')
IS
BEGIN
   IF check_role_restricted_ = 'TRUE' THEN
      Check_Proj_Role_Restricted(projection_,role_);
   END IF;
   
   Revoke_Entities_All___(projection_,role_);
   Revoke_Actions_All___(projection_,role_);
   Revoke___(projection_,role_);
END Revoke_All;

@UncheckedAccess
PROCEDURE Check_Available(
   projection_name_ IN VARCHAR2 )
IS
BEGIN
   IF Is_Available(projection_name_) = 'FALSE' THEN 
      Error_SYS.Odata_Provider_Access_(lu_name_, 'SRV_NOT_ACCESS: You cannot access the service :P1', projection_name_);
   END IF;
END Check_Available;

@UncheckedAccess
FUNCTION Is_Available(
   projection_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   fnd_user_ fnd_user_tab.identity%TYPE := Fnd_Session_API.Get_Fnd_User;
   temp_ NUMBER;
BEGIN
   IF NOT (fnd_user_ = Fnd_Session_API.Get_App_Owner) THEN 
      SELECT 1 INTO temp_
      FROM dual
      WHERE EXISTS ( SELECT 1 FROM fnd_user_role_runtime_tab t, fnd_projection_grant_tab s 
                     WHERE s.projection = projection_name_ 
                     AND t.identity = fnd_user_ 
                     AND t.role = s.role);
   END IF;
   RETURN 'TRUE';
EXCEPTION 
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Is_Available;

@UncheckedAccess
FUNCTION Get_Grant_Access(
   projection_name_ IN VARCHAR2,
   role_ IN VARCHAR2) RETURN VARCHAR2
IS
   result_ VARCHAR2(100);
   
   projection_is_granted_ BOOLEAN;
   num_entities_ NUMBER;
   num_grantable_entities_ NUMBER;
   num_unbound_actions_ NUMBER;
   
   num_entities_granted_full_ NUMBER;
   num_entities_granted_read_only_ NUMBER;
   num_granted_unbound_actions_ NUMBER;
   
   FUNCTION All_Grantable_Entities_Granted_Full___ RETURN BOOLEAN
   IS
   BEGIN
      RETURN num_grantable_entities_ = num_entities_granted_full_;
   END All_Grantable_Entities_Granted_Full___;
   
   FUNCTION All_Grantable_Entities_Granted_Read_Only___ RETURN BOOLEAN
   IS
   BEGIN
      RETURN num_grantable_entities_ = num_entities_granted_read_only_;
   END All_Grantable_Entities_Granted_Read_Only___;
   
   FUNCTION All_Unbound_Actions_Granted___ RETURN BOOLEAN
   IS
   BEGIN
      RETURN num_unbound_actions_ = num_granted_unbound_actions_;
   END All_Unbound_Actions_Granted___;
   
   FUNCTION No_Unbound_Actions_Granted___ RETURN BOOLEAN
   IS
   BEGIN
      RETURN num_granted_unbound_actions_ = 0;
   END No_Unbound_Actions_Granted___;
BEGIN
   projection_is_granted_ := Fnd_Projection_Grant_API.Exists(projection_name_, role_);
   num_entities_ := Fnd_Projection_API.Get_Num_Entities(projection_name_);
   num_grantable_entities_ := Fnd_Projection_API.Get_Num_Grantable_Entities(projection_name_);
   num_unbound_actions_ := Fnd_Projection_API.Get_Num_Projection_Actions(projection_name_);
   
   num_entities_granted_full_ := Get_Num_Entities_Granted_Full___(projection_name_, role_);
   num_entities_granted_read_only_ := Get_Num_Entities_Granted_Read_Only___(projection_name_, role_);
   num_granted_unbound_actions_ := Get_Num_Granted_Projection_Actions___(projection_name_, role_);

   IF projection_is_granted_ THEN
      IF All_Grantable_Entities_Granted_Full___ AND All_Unbound_Actions_Granted___ THEN
         result_ := Projection_Access_Level_API.DB_FULL;
      ELSIF All_Grantable_Entities_Granted_Read_Only___ AND No_Unbound_Actions_Granted___ THEN
         result_ := Projection_Access_Level_API.DB_READ_ONLY;
      ELSE
         result_ := Projection_Access_Level_API.DB_CUSTOM;
      END IF;
   ELSE
      result_ := Projection_Access_Level_API.DB_NONE;
   END IF;

   RETURN result_;
END Get_Grant_Access;


FUNCTION Get_Num_Entities_Granted_Full___(
   projection_name_ IN VARCHAR2,
   role_ IN VARCHAR2) RETURN VARCHAR2
IS
   num_ NUMBER;
   
   CURSOR get_num IS
      SELECT COUNT(*)
      FROM fnd_proj_entity e, fnd_proj_entity_grant a 
      WHERE e.projection_name = a.projection
      AND e.entity_name = a.entity
      AND Fnd_Proj_Entity_API.Is_Grantable(e.projection_name, e.entity_name) = 'TRUE'
      AND (
         a.cud_allowed_db = 'TRUE'
         OR Fnd_Proj_Entity_API.Get_Num_Actions(e.projection_name, e.entity_name) = (
            SELECT DECODE(count(*), 0, -1, count(*))
            FROM fnd_proj_ent_action_grant_tab eg
            WHERE eg.projection = a.projection
            AND eg.role = a.role        
            AND eg.entity = a.entity
         )
      )
      AND a.projection = projection_name_
      AND a.role = role_;
BEGIN
   OPEN get_num;
   FETCH get_num INTO num_;
   CLOSE get_num;
   RETURN num_;
END Get_Num_Entities_Granted_Full___;

FUNCTION Get_Num_Entities_Granted_Read_Only___(
   projection_name_ IN VARCHAR2,
   role_ IN VARCHAR2) RETURN VARCHAR2
IS
   num_ NUMBER;
   
   CURSOR get_num IS
      SELECT COUNT(*)
      FROM fnd_proj_entity e, fnd_proj_entity_grant a 
      WHERE e.projection_name = a.projection
      AND e.entity_name = a.entity
      AND Fnd_Proj_Entity_API.Is_Grantable(e.projection_name, e.entity_name) = 'TRUE'
      AND (
         a.cud_allowed_db = 'FALSE'
         AND 0 = (
            SELECT count(*)
            FROM fnd_proj_ent_action_grant_tab eg
            WHERE eg.projection = a.projection
            AND eg.role = a.role        
            AND eg.entity = a.entity
         )
      )
      AND a.projection = projection_name_
      AND a.role = role_;
BEGIN
   OPEN get_num;
   FETCH get_num INTO num_;
   CLOSE get_num;
   
   RETURN num_;
END Get_Num_Entities_Granted_Read_Only___;

FUNCTION Get_Num_Granted_Projection_Actions___(
   projection_name_ IN VARCHAR2,
   role_ IN VARCHAR2) RETURN VARCHAR2
IS
   num_ NUMBER;
   
   CURSOR get_num IS
      SELECT COUNT(*)
      FROM fnd_proj_action a 
      WHERE projection_name = projection_name_ AND EXISTS (
         SELECT action 
         FROM fnd_proj_action_grant_tab g 
         WHERE g.projection = projection_name_
         AND g.role = role_          
         AND g.action = a.action_name
      );
BEGIN
   OPEN get_num;
   FETCH get_num INTO num_;
   CLOSE get_num;
   
   RETURN num_;
END Get_Num_Granted_Projection_Actions___;
   
