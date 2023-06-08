-----------------------------------------------------------------------------
--
--  Logical unit: FndProjEntityGrant
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
PROCEDURE Revoke___ (projection_ IN VARCHAR2, entity_ IN VARCHAR2, role_ IN VARCHAR2)
IS
   oldrec_     fnd_proj_entity_grant_tab%ROWTYPE;
   newrec_     fnd_proj_entity_grant_tab%ROWTYPE;
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
BEGIN
   IF Check_Exist___(projection_,entity_,role_) THEN
      oldrec_ := Lock_By_Keys___(projection_, entity_, role_);
      newrec_ := oldrec_;
      newrec_.cud_allowed := Fnd_Boolean_API.DB_FALSE;
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Revoke___;

PROCEDURE Revoke_All_Actions___ (projection_ IN VARCHAR2, entity_ IN VARCHAR2, role_ IN VARCHAR2)
IS
   TYPE typ_entity_action_grant IS TABLE OF fnd_proj_ent_action_grant_tab.entity%TYPE;
   entity_action_grants_list_ typ_entity_action_grant;
BEGIN
   select action bulk collect into entity_action_grants_list_ from fnd_proj_ent_action_grant_tab 
      where projection=projection_ and entity=entity_ and role=role_;
   FOR idx_ IN 1..entity_action_grants_list_.COUNT LOOP
      Fnd_Proj_Ent_Action_Grant_API.Do_Revoke(projection_,entity_,entity_action_grants_list_(idx_),role_);
   END LOOP;
END Revoke_All_Actions___;

PROCEDURE Revoke_All___ (projection_ IN VARCHAR2, entity_ IN VARCHAR2, role_ IN VARCHAR2)
IS
BEGIN
   Revoke_All_Actions___(projection_,entity_,role_);
   Revoke___(projection_,entity_,role_);
END Revoke_All___;

PROCEDURE Grant_CUD___ (projection_ IN VARCHAR2, entity_ IN VARCHAR2, role_ IN VARCHAR2)
IS
   rec_        fnd_proj_entity_grant_tab%ROWTYPE;
   oldrec_     fnd_proj_entity_grant_tab%ROWTYPE;
   newrec_     fnd_proj_entity_grant_tab%ROWTYPE;
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
BEGIN
   IF Fnd_Proj_Entity_API.Get_Operations_Allowed(projection_, entity_) = 'R' THEN
      Error_SYS.Record_General(lu_name_, 'CUDOPERATIONSNOTALLOWED: It is not allowed to grant CUD access to projection entity :P1.:P2', projection_, entity_);
   END IF;
   IF Check_Exist___(projection_,entity_,role_) THEN
      oldrec_ := Lock_By_Keys___(projection_, entity_, role_);
      newrec_ := oldrec_;
      newrec_.cud_allowed := Fnd_Boolean_API.DB_TRUE;
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   ELSE
      rec_.projection := projection_;
      rec_.entity := entity_;
      rec_.role := role_;
      rec_.cud_allowed := Fnd_Boolean_API.DB_TRUE;
      New___(rec_);
   END IF;
END Grant_CUD___;

PROCEDURE Grant_Read___ (projection_ IN VARCHAR2, entity_ IN VARCHAR2, role_ IN VARCHAR2)
IS
   rec_        fnd_proj_entity_grant_tab%ROWTYPE;
   oldrec_     fnd_proj_entity_grant_tab%ROWTYPE;
   newrec_     fnd_proj_entity_grant_tab%ROWTYPE;
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
BEGIN
   IF Check_Exist___(projection_,entity_,role_) THEN
      oldrec_ := Lock_By_Keys___(projection_, entity_, role_);
      newrec_ := oldrec_;
      newrec_.cud_allowed := Fnd_Boolean_API.DB_FALSE;
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   ELSE
      rec_.projection := projection_;
      rec_.entity := entity_;
      rec_.role := role_;
      rec_.cud_allowed := Fnd_Boolean_API.DB_FALSE;
      New___(rec_);
   END IF;
END Grant_Read___;

PROCEDURE Grant_All_Actions___ (projection_ IN VARCHAR2, entity_ IN VARCHAR2, role_ IN VARCHAR2)
IS
   TYPE typ_entity_action IS TABLE OF fnd_proj_ent_action_tab.entity_name%TYPE;
   entity_actions_list_ typ_entity_action;
BEGIN
   select action_name bulk collect into entity_actions_list_ from fnd_proj_ent_action_tab 
      where projection_name=projection_ and entity_name=entity_;
   FOR idx_ IN 1..entity_actions_list_.COUNT LOOP
      Fnd_Proj_Ent_Action_Grant_API.Do_Grant(projection_,entity_,entity_actions_list_(idx_),role_);
   END LOOP;
END Grant_All_Actions___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
PROCEDURE Revoke_All_ (projection_ IN VARCHAR2, entity_ IN VARCHAR2, role_ IN VARCHAR2)
IS
BEGIN
   Revoke_All___(projection_,entity_,role_);
END Revoke_All_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Grant_Query (projection_ IN VARCHAR2, entity_ IN VARCHAR2, role_ IN VARCHAR2)
IS
BEGIN
   IF Check_Exist___(projection_,entity_,role_) THEN 
      Revoke_All___(projection_,entity_,role_);
   END IF;
   Grant_Read___(projection_,entity_,role_);
END Grant_Query;

PROCEDURE Grant_CUD (projection_ IN VARCHAR2, entity_ IN VARCHAR2, role_ IN VARCHAR2)
IS
BEGIN 
   IF Check_Exist___(projection_,entity_,role_) THEN 
      Revoke_All___(projection_,entity_,role_);
   END IF;
   Grant_CUD___(projection_,entity_,role_);
END Grant_CUD;

PROCEDURE Grant_All (projection_ IN VARCHAR2, entity_ IN VARCHAR2, role_ IN VARCHAR2)
IS
BEGIN
   IF Check_Exist___(projection_,entity_,role_) THEN 
      Revoke_All___(projection_,entity_,role_);
   END IF;
   IF Fnd_Proj_Entity_API.Get_Operations_Allowed(projection_, entity_) = 'R' THEN
      Grant_Read___(projection_,entity_,role_);
   ELSE
      Grant_CUD___(projection_,entity_,role_);
   END IF;
   
   Grant_All_Actions___(projection_,entity_,role_);
END Grant_All;

PROCEDURE Revoke_CUD (projection_ IN VARCHAR2, entity_ IN VARCHAR2, role_ IN VARCHAR2)
IS
BEGIN 
   IF Check_Exist___(projection_,entity_,role_) THEN 
      Revoke___(projection_,entity_,role_);
   END IF;
END Revoke_CUD;

@UncheckedAccess
FUNCTION Is_CUD_Allowed(
   projection_name_ IN VARCHAR2,
   entity_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   fnd_user_ fnd_user_tab.identity%TYPE := Fnd_Session_API.Get_Fnd_User;
   temp_ NUMBER;
BEGIN
   IF NOT (fnd_user_ = Fnd_Session_API.Get_App_Owner) THEN
      SELECT 1 INTO temp_
      FROM dual
      WHERE EXISTS ( SELECT 1 
                     FROM fnd_user_role_runtime_tab t, fnd_proj_entity_grant_tab s 
                     WHERE s.projection = projection_name_ 
                     AND s.entity = entity_name_
                     AND t.identity = fnd_user_ 
                     AND t.role = s.role
                     AND s.cud_allowed = Fnd_Boolean_API.DB_TRUE);
   END IF;
   RETURN 'TRUE';
EXCEPTION 
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Is_CUD_Allowed;

@UncheckedAccess
PROCEDURE Check_CUD_Allowed(
   projection_name_ IN VARCHAR2,
   entity_name_ IN VARCHAR2 )
IS
BEGIN
   IF Is_CUD_Allowed(projection_name_, entity_name_) = 'FALSE' THEN
      Error_SYS.Odata_Provider_Access_(lu_name_, 'PROJ_ENTITY_NO_WRITE_ACCESS: You do not have write access to :P1.:P2 ', projection_name_, entity_name_);
   END IF;
END Check_CUD_Allowed;