-----------------------------------------------------------------------------
--
--  Logical unit: FndBpaGrant
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
PROCEDURE Check_Bpa_Role_Restricted (
   bpa_ IN VARCHAR2,
   role_  IN VARCHAR2)
IS
BEGIN
   IF (Security_Sys.Is_Ltu_Role(role_) OR Security_SYS.Is_Technical_Role(role_)) THEN
      Error_SYS.Appl_General(lu_name_, 'MODIFY_WORKFLOW_ON_LTU: Security grants to permission set [:P1] is restricted by license. Grants to Workflow [:P2] cannot be modified.', role_, bpa_);
   END IF;
END Check_Bpa_Role_Restricted;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Revoke___ (bpa_ IN VARCHAR2, role_ IN VARCHAR2)
IS
    rec_ fnd_bpa_grant_tab%ROWTYPE;
BEGIN
   IF Check_Exist___(bpa_,role_) THEN
      rec_.bpa_key := bpa_;
      rec_.role := role_;
      Remove___(rec_);
   END IF;
END Revoke___;      


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Grant_All (
   bpa_ IN VARCHAR2, 
   role_ IN VARCHAR2,
   check_role_restricted_ VARCHAR2 DEFAULT 'TRUE')
IS
   rec_ fnd_bpa_grant_tab%ROWTYPE;
BEGIN
   IF check_role_restricted_ = 'TRUE' THEN
      Check_Bpa_Role_Restricted(bpa_,role_);
   END IF;
   
   IF Check_Exist___(bpa_, role_) THEN
      Revoke_All(bpa_,role_,check_role_restricted_);
   END IF;
   rec_.bpa_key := bpa_;
   rec_.role := role_;
   New___(rec_);
END Grant_All;

PROCEDURE Revoke_All (
   bpa_ IN VARCHAR2, 
   role_ IN VARCHAR2,
   check_role_restricted_ VARCHAR2 DEFAULT 'TRUE')
IS
BEGIN
   IF check_role_restricted_ = 'TRUE' THEN
      Check_Bpa_Role_Restricted(bpa_,role_);
   END IF;
   
   Revoke___(bpa_,role_);
END Revoke_All;


FUNCTION Is_Bpa_Available(
   identity_  IN VARCHAR2,
   bpa_key_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ NUMBER;
BEGIN
   $IF Component_Fndwf_SYS.INSTALLED $THEN
      SELECT 1 INTO temp_
      FROM dual
      WHERE EXISTS ( SELECT 1 FROM fnd_bpa_grant bpa_grant
                     INNER JOIN fnd_deployed_bpa bpa_deployed ON 
                        bpa_deployed.id = bpa_grant.bpa_key
                     INNER JOIN fnd_user_role user_role ON
                        bpa_grant.role = user_role.role
                     WHERE user_role.identity = identity_ 
                     AND bpa_deployed.key = bpa_key_);
   $END
   RETURN 'TRUE';
EXCEPTION 
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Is_Bpa_Available;

