-----------------------------------------------------------------------------
--
--  Logical unit: FndUserRole ReplReceive
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


-------------------- REPLICATION RECEIVE IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT fnd_user_role_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   oracle_user_ VARCHAR2(30);
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   oracle_user_ := Fnd_User_API.Get_Oracle_User(newrec_.identity);
   IF (oracle_user_ IS NOT NULL) THEN
      Assert_SYS.Assert_Is_Grantee(newrec_.role);
      Assert_SYS.Assert_Is_Grantee(oracle_user_);
      --@ApproveDynamicStatement(2016-06-08,nadelk)
      EXECUTE IMMEDIATE 'GRANT "'||newrec_.role||'" TO "'||oracle_user_||'"';
   END IF;
   BEGIN
      INSERT
         INTO fnd_user_role_runtime_tab (
            identity,
            role)
         VALUES (
            newrec_.identity,
            newrec_.role);
   EXCEPTION
      WHEN dup_val_on_index THEN
         NULL;
   END;
END Insert___;

@Override
PROCEDURE NewModify (
   warning_      OUT VARCHAR2,
   old_attr_     IN  VARCHAR2,
   new_attr_     IN  VARCHAR2,
   lu_name_      IN  VARCHAR2,
   package_name_ IN  VARCHAR2,
   user_id_      IN  VARCHAR2)
IS
  oldrec_   fnd_user_role_tab%ROWTYPE;
  newrec_   fnd_user_role_tab%ROWTYPE;
BEGIN
   oldrec_.identity := Client_SYS.Get_Item_Value('IDENTITY', old_attr_);
   oldrec_.role := Client_SYS.Get_Item_Value('ROLE', old_attr_);
   
   newrec_.role := Client_SYS.Get_Item_Value('ROLE', new_attr_);
   
   IF ((NOT Check_Exist___(oldrec_.identity,oldrec_.role)) AND (newrec_.role IS NOT NULL) AND (NOT Fnd_Role_API.Exists(newrec_.role))) THEN
         Fnd_Role_API.Create__(newrec_.role, 'A temporary Role. Please synchronize this with HUB.', 'ENDUSERROLE', 'FALSE');
      END IF;
   super(warning_, old_attr_, new_attr_, lu_name_, package_name_, user_id_);
END NewModify;



-------------------- REPLICATION RECEIVE PRIVATE METHODS ----------------------------


-------------------- REPLICATION RECEIVE PROTECTED METHODS --------------------------


-------------------- REPLICATION RECEIVE PUBLIC METHODS -----------------------------


