-----------------------------------------------------------------------------
--
--  Logical unit: FndProjEntActionGrant
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
FUNCTION Is_Available___(
   projection_name_  IN VARCHAR2,
   entity_name_      IN VARCHAR2,
   action_name_      IN VARCHAR2,
   fnd_user_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ NUMBER;
BEGIN
   IF NOT (fnd_user_ = Fnd_Session_API.Get_App_Owner) THEN
      SELECT 1 INTO temp_ FROM dual
      WHERE EXISTS ( SELECT 1 FROM fnd_user_role_runtime_tab t, fnd_proj_ent_action_grant_tab s 
                     WHERE s.projection = projection_name_ 
                     AND s.entity = entity_name_
                     AND s.action = action_name_
               and t.identity = fnd_user_ 
               and t.role = s.role);
   END IF;
   RETURN 'TRUE';
EXCEPTION 
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Is_Available___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Do_Grant (projection_ IN VARCHAR2, entity_ IN VARCHAR2, action_ IN VARCHAR2, role_ IN VARCHAR2)
IS
    rec_ fnd_proj_ent_action_grant_tab%ROWTYPE;
BEGIN
   IF NOT Check_Exist___(projection_,entity_,action_,role_) THEN
      rec_.projection := projection_;
      rec_.entity := entity_;
      rec_.action := action_;
      rec_.role := role_;
      New___(rec_);
   END IF;
END Do_Grant;

PROCEDURE Do_Revoke (projection_ IN VARCHAR2, entity_ IN VARCHAR2, action_ IN VARCHAR2, role_ IN VARCHAR2)
IS
    rec_ fnd_proj_ent_action_grant_tab%ROWTYPE;
BEGIN
   IF Check_Exist___(projection_,entity_,action_,role_) THEN
      rec_.projection := projection_;
      rec_.entity := entity_;
      rec_.action := action_;
      rec_.role := role_;
      Remove___(rec_);
   END IF;
END Do_Revoke;

@UncheckedAccess
FUNCTION Is_Available(
   projection_name_ IN VARCHAR2,
   entity_name_ IN VARCHAR2,
   action_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   fnd_user_ fnd_user_tab.identity%TYPE := Fnd_Session_API.Get_Fnd_User;
BEGIN
   RETURN Is_Available___(projection_name_, entity_name_, action_name_, fnd_user_);
END Is_Available;

@UncheckedAccess
FUNCTION Is_Available(
   projection_name_  IN VARCHAR2,
   entity_name_      IN VARCHAR2,
   action_name_      IN VARCHAR2,
   fnd_user_         IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Is_Available___(projection_name_, entity_name_, action_name_, fnd_user_);
END Is_Available;

@UncheckedAccess
PROCEDURE Check_Available(
   projection_name_ IN VARCHAR2,
   entity_name_ IN VARCHAR2,
   action_name_ IN VARCHAR2 )
IS
BEGIN
   IF Is_Available(projection_name_, entity_name_, action_name_) = 'FALSE' THEN
      Error_SYS.Odata_Provider_Access_(lu_name_, 'METHOD_NOT_ACCESS: You are not allowed to execute the action :P1.:P2.:P3', projection_name_, entity_name_, action_name_);
   END IF;
END Check_Available;

@UncheckedAccess
FUNCTION  Get_Proj_Ent_Act_Grant_Status(
   projection_name_ IN VARCHAR2,
   entity_name_ IN VARCHAR2,
   action_name_ IN VARCHAR2,
   role_ IN VARCHAR2) RETURN VARCHAR2
IS
   proj_ent_action_grant_count_ NUMBER;
BEGIN
  select count(*) INTO proj_ent_action_grant_count_
  from fnd_proj_ent_action_grant_tab a
  where a.projection = projection_name_ and a.entity = entity_name_ and a.action = action_name_ and a.role = role_;
  
   IF proj_ent_action_grant_count_ = 0 THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Get_Proj_Ent_Act_Grant_Status;