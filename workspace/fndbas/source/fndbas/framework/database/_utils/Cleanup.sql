--------------------------------------------------------------------------------
--
--  File:         Cleanup.sql
--
--  Component:    FNDBAS
--
--  Purpose:      Remove obsolete objects and grants from previous versions. Only necessary
--                to run when upgrading, not when performing a fresh install.
--
--  Date    Sign    History
--  ------  ------  --------------------------------------------------------------
--  190628  MaBose  Created.
----------------------------------------------------------------------------------
      
SET SERVEROUT ON

ACCEPT username DEFAULT 'IFSAPP' PROMPT 'Enter Application owner (IFSAPP)'
ACCEPT infoowner DEFAULT 'IFSINFO' PROMPT 'Enter IAL owner (IFSINFO)'

PROMPT Drop obsolete SYS objects and grants from previous releases.

SPOOL Cleanup.log

DECLARE
   PROCEDURE Run_Ddl (
      stmt_  IN VARCHAR2 )
   IS
      not_granted1         EXCEPTION;
      PRAGMA               EXCEPTION_INIT(not_granted1, -1927);
      not_granted2         EXCEPTION;
      PRAGMA               EXCEPTION_INIT(not_granted2, -1952);
      not_exist1           EXCEPTION;
      PRAGMA               EXCEPTION_INIT(not_exist1, -942);
      not_exist2           EXCEPTION;
      PRAGMA               EXCEPTION_INIT(not_exist2, -4043);
   BEGIN
      EXECUTE IMMEDIATE stmt_;
      Dbms_Output.Put_Line('SUCCESS: ' || stmt_);
   EXCEPTION
      WHEN not_granted1 OR not_granted2 OR not_exist1 OR not_exist2 THEN
         Dbms_Output.Put_Line('SUCCESS: ' || stmt_);
      WHEN OTHERS THEN
         Dbms_Output.Put_Line('ERROR  : ' || stmt_);
   END Run_Ddl;
   
   PROCEDURE Revoke_Dba_Grant
   IS
      username_ VARCHAR2(120) := '&USERNAME';
	  info_owner_ VARCHAR2(129) := '&INFOOWNER';
   BEGIN
      --
      -- Revoke obsolete Dba grants existed in older versions of IFS Applications
      --
      Dbms_Output.Put_Line('Removed grants in Apps10 UPD6');
      Run_Ddl('REVOKE ANALYZE ANY FROM ' || username_);
      Run_Ddl('REVOKE DELETE ON AUD$ FROM ' || username_);
      Run_Ddl('REVOKE EXECUTE ON DBMS_IJOB FROM ' || username_);
      Run_Ddl('REVOKE EXECUTE ON DBMS_NETWORK_ACL_ADMIN FROM ' || username_);
	  
	  Dbms_Output.Put_Line('Removed grants in Apps20.1');
	  -- Grant unlimited quota to know tablespaces instead
      Run_Ddl('REVOKE UNLIMITED TABLESPACE FROM ' || username_);
      Run_Ddl('REVOKE UNLIMITED TABLESPACE FROM ' || info_owner_);
      Run_Ddl('REVOKE ALTER PROFILE FROM ' || username_);
      Run_Ddl('REVOKE CREATE PROFILE FROM ' || username_);
      Run_Ddl('REVOKE DROP PROFILE FROM ' || username_);
      Run_Ddl('REVOKE CREATE ANY PROCEDURE FROM ' || username_);
      Run_Ddl('GRANT CREATE PROCEDURE TO ' || username_ || ' WITH ADMIN OPTION');
      Run_Ddl('REVOKE CREATE ANY PROCEDURE FROM FND_WEBRUNTIME');
      Run_Ddl('GRANT CREATE PROCEDURE TO FND_WEBRUNTIME');
      Run_Ddl('REVOKE CREATE ANY PROCEDURE FROM FND_DEVELOPER');
      Run_Ddl('GRANT CREATE PROCEDURE TO FND_DEVELOPER');
      Run_Ddl('REVOKE CREATE ANY SYNONYM FROM ' || username_);
      Run_Ddl('GRANT CREATE SYNONYM TO ' || username_);
      Run_Ddl('REVOKE CREATE ANY VIEW FROM ' || username_);
      Run_Ddl('GRANT CREATE VIEW TO ' || username_);
      Run_Ddl('REVOKE GRANT ANY ROLE FROM ' || username_);
      Run_Ddl('REVOKE SELECT ON USER$ FROM ' || username_); -- To remove with admin option
      Run_Ddl('GRANT SELECT ON USER$ TO ' || username_);
      Run_Ddl('REVOKE EXECUTE ON DBMS_SYSTEM FROM ' || username_);
      Run_Ddl('REVOKE EXECUTE ON DBMS_SYSTEM FROM IFSSYS');
      Run_Ddl('REVOKE EXECUTE ON UTL_TCP FROM ' || username_);
      --Run_Ddl('REVOKE SELECT ANY DICTIONARY FROM ' || username_);
      --Run_Ddl('REVOKE MANAGE SCHEDULER FROM ' || username_);
   END Revoke_Dba_Grant;
   
   PROCEDURE Drop_Obsolete_Objects
   IS
   BEGIN
      --
      -- Revoke obsolete Dba grants existed in older versions of IFS Applications
      --
      Dbms_Output.Put_Line('Removed objects in Apps10 UPD6');
	  --
	  -- Drop obsolete procedure for Gathering System Statistics
      --
      Run_Ddl('DROP PROCEDURE Gather_System_Statistics');
	  --
      Dbms_Output.Put_Line('Removed objects in 21R2');
	  --
	  -- Drop obsolete view fnd_alert_log
      --
      Run_Ddl('DROP VIEW fnd_alert_log');
	  --
	  Dbms_Output.Put_Line('Removed objects in 22R1');
	  --
	  -- Drop obsolete view fnd_ora_parameter
      --
      Run_Ddl('DROP VIEW FND_ORA_PARAMETER');
	  
   END Drop_Obsolete_Objects;
BEGIN
   Revoke_Dba_Grant;
   Drop_Obsolete_Objects;
END;
/   
   
   
   
