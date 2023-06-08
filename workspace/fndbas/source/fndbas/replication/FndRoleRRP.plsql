-----------------------------------------------------------------------------
--
--  Logical unit: FndRole ReplReceive
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
PROCEDURE Grant_Oracle_System_Privs___ (
   role_ IN VARCHAR2 )
IS
 
   PROCEDURE Run_Ddl_Command___ (
      stmt_ IN VARCHAR2)
   IS
   BEGIN
      --@ApproveDynamicStatement(2016-08-06,nadelk)
      EXECUTE IMMEDIATE stmt_;
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END Run_Ddl_Command___;
BEGIN
   Assert_SYS.Assert_Is_Role(role_);
   CASE role_ 
   WHEN 'FND_WEBRUNTIME' THEN 
      Run_Ddl_Command___('GRANT CREATE SESSION TO ' || role_);
      Run_Ddl_Command___('REVOKE ALTER SESSION FROM ' || role_);
      Run_Ddl_Command___('GRANT MERGE ANY VIEW TO ' || role_);
   WHEN 'FND_DEVELOPER' THEN
      Run_Ddl_Command___('GRANT DEBUG ANY PROCEDURE TO ' || role_);
      Run_Ddl_Command___('GRANT DEBUG CONNECT SESSION TO ' || role_);
      --
      -- Oracle system privileges needed for Performance Analyzer as enduser
      --
      Run_Ddl_Command___('GRANT CREATE ANY PROCEDURE TO ' || role_);
      --
      -- Grants access to statistics views
      --
      Run_Ddl_Command___('GRANT SELECT ON V$SESSION TO ' || role_);
      Run_Ddl_Command___('GRANT SELECT ON V$SESSTAT TO ' || role_);
      Run_Ddl_Command___('GRANT SELECT ON V$STATNAME TO ' || role_);
      Run_Ddl_Command___('GRANT SELECT ON V$MYSTAT TO ' || role_);
      Run_Ddl_Command___('GRANT SELECT ON V$OPEN_CURSOR TO ' || role_);
      Run_Ddl_Command___('GRANT SELECT ON V$SQLTEXT_WITH_NEWLINES TO ' || role_);
      Run_Ddl_Command___('GRANT SELECT ON V$LOCK TO ' || role_);
   WHEN 'FND_WEBCONFIG' THEN 
      Run_Ddl_Command___('GRANT MERGE ANY VIEW TO ' || role_);
   ELSE
      NULL;
   END CASE;
END Grant_Oracle_System_Privs___;
   
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT fnd_role_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   app_owner_         VARCHAR2(30) := upper(Fnd_Session_API.Get_App_Owner);
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   -- Create the Oracle role
   Assert_SYS.Assert_Is_Valid_Identifier(newrec_.role);
   --@ApproveDynamicStatement(2016-06-08,nadelk)
   EXECUTE IMMEDIATE 'CREATE ROLE "'||newrec_.role||'"';
   IF (newrec_.role IN ('FND_WEBRUNTIME', 'FND_DEVELOPER', 'FND_WEBCONFIG')) THEN
      Grant_Oracle_System_Privs___(newrec_.role);
   END IF;
   Assert_SYS.Assert_Is_Role(newrec_.role);
   Assert_SYS.Assert_Is_Grantee(app_owner_);
   --@ApproveDynamicStatement(2016-06-08,nadelk)
   EXECUTE IMMEDIATE 'REVOKE "'||newrec_.role||'" FROM "'||app_owner_||'"';
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     fnd_role_tab%ROWTYPE,
   newrec_     IN OUT fnd_role_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (newrec_.role IN ('FND_WEBRUNTIME', 'FND_DEVELOPER', 'FND_WEBCONFIG')) THEN
      Grant_Oracle_System_Privs___(newrec_.role);
   END IF;
END Update___;




-------------------- REPLICATION RECEIVE PRIVATE METHODS ----------------------------


-------------------- REPLICATION RECEIVE PROTECTED METHODS --------------------------


-------------------- REPLICATION RECEIVE PUBLIC METHODS -----------------------------

