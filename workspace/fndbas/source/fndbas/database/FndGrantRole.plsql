-----------------------------------------------------------------------------
--
--  Logical unit: FndGrantRole
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110906  DUWI  Createed (Bug#98679)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FND_GRANT_ROLE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (Check_Exist___(newrec_.role, newrec_.granted_role)) THEN
      RETURN;
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Grant_Role_ (
   role_ IN VARCHAR2,
   granted_role_ IN VARCHAR2 )
IS
   newrec_   FND_GRANT_ROLE_TAB%ROWTYPE;
   objid_    VARCHAR2(2000);
   objv_     VARCHAR2(2000);
   attr_     VARCHAR2(2000);
BEGIN
    
   newrec_.role := role_;
   newrec_.granted_role := granted_role_;
    
   insert___(objid_, objv_, newrec_, attr_);  
END Grant_Role_;


PROCEDURE Revoke_Role_ (
   role_ IN VARCHAR2,
   granted_role_ IN VARCHAR2 )
IS
   remrec_ FND_GRANT_ROLE_TAB%ROWTYPE;
   objid_    VARCHAR2(2000);

   CURSOR get_rec IS
      SELECT role, granted_role, objid
      FROM FND_GRANT_ROLE
      WHERE role = role_
      AND granted_role = granted_role_;

BEGIN

   OPEN get_rec;
   FETCH get_rec INTO remrec_.role, remrec_.granted_role, objid_;
   CLOSE get_rec;
   
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);  
END Revoke_Role_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


