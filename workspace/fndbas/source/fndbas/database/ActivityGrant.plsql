-----------------------------------------------------------------------------
--
--  Logical unit: ActivityGrant
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050525  JEHU  Created  
--  050610  UTGULK  F1PR489 Modified Grant_Activity to do nothing on dup_Val_on_index.
--  060927  HAARSE Fixed so that Revoke_Activity used variable instead of column name (Bugg#60830)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Grant_Activity__ (
   role_        IN VARCHAR2,
   activity_name_ IN VARCHAR2 )
IS
BEGIN
   
   Error_SYS.Check_Not_Null(lu_name_, 'ROLE', role_);
   Error_SYS.Check_Not_Null(lu_name_, 'ACTIVITY_NAME', activity_name_);
   
   Fnd_Role_API.Exist(role_);     
   
   INSERT
      INTO activity_grant_tab (
         role,
         activity_name,
         rowversion)
      VALUES (
         role_,
         activity_name_,
         sysdate);
EXCEPTION
   WHEN dup_val_on_index THEN
      NULL;
END Grant_Activity__;


PROCEDURE Revoke_Activity__ (
   role_        IN VARCHAR2,
   activity_name_ IN VARCHAR2 )
IS
BEGIN
    
   Error_SYS.Check_Not_Null(lu_name_, 'ROLE', role_);
   Error_SYS.Check_Not_Null(lu_name_, 'ACTIVITY_NAME', activity_name_);
   
   DELETE
      FROM activity_grant_tab
      WHERE role = role_
      AND   activity_name = activity_name_; 
   
END Revoke_Activity__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------




