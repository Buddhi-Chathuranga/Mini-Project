--PROMPT GRANT DBA PRIVILEGES TO IFS USERS

DECLARE

PROCEDURE Dbagrant (
   username_   IN VARCHAR2 )
IS
   dummy_   dba_sys_privs.privilege%TYPE;
   oracle_version_   NUMBER;
   CURSOR get_alter_user_grants IS
      SELECT privilege
      FROM   dba_sys_privs
      WHERE  grantee = upper(username_)
      AND    privilege = 'ALTER USER';
   CURSOR get_source$_grants IS
      SELECT privilege
      FROM   all_tab_privs
      WHERE  grantee = upper(username_)
      AND    table_name = 'SOURCE$'
      AND    privilege IN ('INSERT', 'UPDATE', 'DELETE');

   PROCEDURE Run_Ddl (stmt_  IN VARCHAR2,
                      type_  IN VARCHAR2 DEFAULT 'NORMAL')
   IS
      no_role              EXCEPTION;
      PRAGMA               EXCEPTION_INIT(no_role, -1951);
   BEGIN
      EXECUTE IMMEDIATE stmt_;
      Dbms_Output.Put_Line('SUCCESS: ' || stmt_);
   EXCEPTION
      WHEN no_role THEN
         NULL;
      WHEN OTHERS THEN
         Dbms_Output.Put_Line('ERROR  : ' || stmt_);
         CASE type_
            WHEN 'NORMAL' THEN
               NULL;
            WHEN 'ORACLETEXT' THEN
               Dbms_Output.Put_Line('CAUSE  : IFS Applications requires Oracle Text.');
               Dbms_Output.Put_Line('CAUSE  : Install Oracle Text if you are going to install IFS Applications.');
            WHEN 'CTXSYS' THEN
               Dbms_Output.Put_Line('CAUSE  : Index CTXSYS.DRX$ERR_KEY already exists. This error is OK.');
            ELSE
               NULL;
         END CASE;
   END Run_Ddl;

   PROCEDURE Revoke_Java_Grant
   IS
      type_name_           VARCHAR2(100);
      name_                VARCHAR2(100);
   --
      CURSOR get_java_grant IS
         SELECT seq
         FROM   Dba_Java_Policy
         WHERE  kind = 'GRANT'
         AND    grantee = upper(username_)
         AND    type_schema = 'SYS'
         AND    type_name = upper(type_name_)
         AND    name = upper(name_);
   --
      PROCEDURE Run_Java(stmt_   IN VARCHAR2,
                         output_ IN BOOLEAN DEFAULT FALSE)
      IS
      BEGIN
         EXECUTE IMMEDIATE stmt_;
         IF output_ THEN
            Dbms_Output.Put_Line('SUCCESS: REVOKE Dbms_Java.Grant_Permission succeded');
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            Dbms_Output.Put_Line('ERROR  : GRANT Dbms_Java.Delete_Permission failed.');
            Dbms_Output.Put_Line('CAUSE  : Make sure that Java_Pool_Size is set to at least 8M.');
      END;

   BEGIN
      --
      -- Run_DDL('REVOKE JAVAUSERPRIV FROM '||username_);
      --
      type_name_ := 'java.util.PropertyPermission';
      name_      := 'ifs.fnd.ap.connectionstring';
      FOR rec IN get_java_grant LOOP
         Run_Java('BEGIN Dbms_Java.Disable_Permission('||to_char(rec.seq)||'); END;');
         Run_Java('BEGIN Dbms_Java.Delete_Permission('||to_char(rec.seq)||'); END;', TRUE);
      END LOOP;
      --
      type_name_ := 'java.util.PropertyPermission';
      name_      := 'ifs.fnd.ap.compression';
      FOR rec IN get_java_grant LOOP
         Run_Java('BEGIN Dbms_Java.Disable_Permission('||to_char(rec.seq)||'); END;');
         Run_Java('BEGIN Dbms_Java.Delete_Permission('||to_char(rec.seq)||'); END;', TRUE);
      END LOOP;
      --
      type_name_ := 'java.util.PropertyPermission';
      name_      := 'SHARED_SECRET';
      FOR rec IN get_java_grant LOOP
         Run_Java('BEGIN Dbms_Java.Disable_Permission('||to_char(rec.seq)||'); END;');
         Run_Java('BEGIN Dbms_Java.Delete_Permission('||to_char(rec.seq)||'); END;', TRUE);
      END LOOP;
      --
      type_name_ := 'java.lang.RuntimePermission';
      name_      := 'setFactory';
      FOR rec IN get_java_grant LOOP
         Run_Java('BEGIN Dbms_Java.Disable_Permission('||to_char(rec.seq)||'); END;');
         Run_Java('BEGIN Dbms_Java.Delete_Permission('||to_char(rec.seq)||'); END;', TRUE);
      END LOOP;
   END Revoke_Java_Grant;
   
   FUNCTION Im_View_Available RETURN BOOLEAN
   IS
      view_installed_ VARCHAR2(5);
   BEGIN
      SELECT 'TRUE'
      INTO   view_installed_
      FROM   dba_views
      WHERE  owner = 'SYS'
      AND    view_name = 'V_$IM_SEGMENTS';

      IF view_installed_ = 'TRUE' THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN FALSE;
   END Im_View_Available;     
   
BEGIN
   --
   -- Oracle install privileges
   --
   Run_Ddl('GRANT ADMINISTER DATABASE TRIGGER TO ' || username_);
   Run_Ddl('GRANT ALTER SYSTEM TO ' || username_);
   Run_Ddl('GRANT ANALYZE ANY DICTIONARY TO ' || username_);
   Run_Ddl('GRANT AUDIT SYSTEM TO ' || username_);
   Run_Ddl('GRANT CREATE ANY DIRECTORY TO ' || username_);
   Run_Ddl('GRANT CREATE ANY CONTEXT TO ' || username_);
   Run_Ddl('GRANT CREATE PROCEDURE TO ' || username_ || ' WITH ADMIN OPTION');
   Run_Ddl('GRANT CREATE SYNONYM TO ' || username_);
   Run_Ddl('GRANT CREATE VIEW TO ' || username_);
   Run_Ddl('GRANT CREATE DATABASE LINK TO ' || username_);
   Run_Ddl('GRANT CREATE JOB TO ' || username_);
   Run_Ddl('GRANT CREATE MATERIALIZED VIEW TO ' || username_);
   Run_Ddl('GRANT CREATE PROCEDURE TO ' || username_);
   Run_Ddl('GRANT CREATE ROLE TO ' || username_);
   Run_Ddl('GRANT CREATE SEQUENCE TO ' || username_);

   -- Required CREATE TABLE to include WITH ADMIN OPTION.
   Run_Ddl('GRANT CREATE TABLE TO ' || username_ || ' WITH ADMIN OPTION');

   Run_Ddl('GRANT CREATE TRIGGER TO ' || username_);
   Run_Ddl('GRANT CREATE TYPE TO ' || username_);
   Run_Ddl('GRANT CREATE USER TO ' || username_);
   Run_Ddl('GRANT CREATE VIEW TO ' || username_);
   Run_Ddl('GRANT DEBUG ANY PROCEDURE TO ' || username_ || ' WITH ADMIN OPTION');
   Run_Ddl('GRANT DEBUG CONNECT SESSION TO ' || username_ || ' WITH ADMIN OPTION');
   Run_Ddl('GRANT DROP ANY CONTEXT TO ' || username_);
   Run_Ddl('GRANT DROP ANY DIRECTORY TO ' || username_);
   Run_Ddl('GRANT DROP ANY ROLE TO ' || username_);
   Run_Ddl('GRANT DROP ANY TYPE TO ' || username_);
   Run_Ddl('GRANT DROP USER TO ' || username_);
   Run_Ddl('GRANT MANAGE SCHEDULER TO ' || username_);
   Run_Ddl('GRANT MERGE ANY VIEW TO ' || username_ || ' WITH ADMIN OPTION');
   --
   -- Grant Alter User privilege
   --
   Run_Ddl('GRANT ALTER USER TO ' || username_);
   --
   -- Oracle session privileges
   --
   Run_Ddl('GRANT CREATE SESSION TO ' || username_ || ' WITH ADMIN OPTION');
   Run_Ddl('GRANT ALTER SESSION TO ' || username_ || ' WITH ADMIN OPTION');
   Run_Ddl('GRANT RESTRICTED SESSION TO ' || username_);
   Run_Ddl('ALTER USER ' || username_ || ' GRANT CONNECT THROUGH IFSSYS');
   --
   -- Oracle Dictionary views
   --
   -- News grants due to changes in how Oracle grants to public
   --
   Run_Ddl('GRANT SELECT ON ALL_ARGUMENTS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON ALL_DB_LINKS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON ALL_ERRORS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON ALL_SOURCE TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON ALL_OBJECTS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON ALL_PROCEDURES TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON ALL_TAB_COLUMNS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON ALL_USERS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON ALL_VIEWS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER_ARGUMENTS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER_COL_COMMENTS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER_CONSTRAINTS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER_CONS_COLUMNS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER_DB_LINKS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER_INDEXES TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER_IND_COLUMNS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER_SOURCE TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER_TAB_COLUMNS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER_TRIGGERS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER_VIEWS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER_PROCEDURES TO ' || username_ || ' WITH GRANT OPTION');
   --   
   Run_Ddl('GRANT SELECT ON DBA_AUDIT_TRAIL TO ' || username_);
   Run_Ddl('GRANT SELECT ON DBA_CONSTRAINTS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_COL_COMMENTS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_CONTEXT TO ' || username_);
   Run_Ddl('GRANT SELECT ON DBA_DB_LINKS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_EXTENTS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_INDEXES TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_IND_COLUMNS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_JOBS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_JOBS_RUNNING TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_LOCKS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBMS_LOCK_ALLOCATED TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_MVIEWS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_MVIEW_LOGS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_OBJECTS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_2PC_PENDING TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_PENDING_TRANSACTIONS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_PLSQL_OBJECT_SETTINGS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_PROFILES TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_ROLES TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_ROLE_PRIVS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_SEGMENTS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_SCHEDULER_JOBS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_SCHEDULER_JOB_ARGS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_SCHEDULER_JOB_LOG TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_SCHEDULER_JOB_RUN_DETAILS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_SCHEDULER_RUNNING_JOBS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_SYS_PRIVS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_TABLES TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_TAB_COLUMNS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_TAB_COMMENTS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_TAB_PRIVS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_TABLESPACES TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_TEMP_FILES TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_TRIGGERS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_USERS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_VIEWS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_DIRECTORIES TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON PROXY_USERS TO ' || username_ || ' WITH GRANT OPTION');
   
   -- PL/SQL Developer
   Run_Ddl('GRANT SELECT ON V_$SESSION TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$SESSTAT TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON GV_$SESSTAT TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$STATNAME TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$OPEN_CURSOR TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$SQLTEXT_WITH_NEWLINES TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$LOCK TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$MYSTAT TO ' || username_ || ' WITH GRANT OPTION');
      --
   Run_Ddl('GRANT SELECT ON GV_$SESSION TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$ACCESS TO ' || username_);
   Run_Ddl('GRANT SELECT ON V_$DATABASE TO ' || username_);
   Run_Ddl('GRANT SELECT ON V_$NLS_VALID_VALUES TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$OPTION TO ' || username_);
   Run_Ddl('GRANT SELECT ON V_$INSTANCE TO ' || username_);
   Run_Ddl('GRANT SELECT ON GV_$INSTANCE TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$PROCESS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$PARAMETER TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$RESERVED_WORDS TO ' || username_);
   Run_Ddl('GRANT SELECT ON V_$BGPROCESS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON GV_$SYSSTAT TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON GV_$PROCESS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON GV_$SGA TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON GV_$SGA_DYNAMIC_COMPONENTS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$SQL TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON GV_$SQL TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$SQL_PLAN TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$SQL_PLAN_STATISTICS_ALL TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$SQL_BIND_CAPTURE TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON GV_$LOCKED_OBJECT TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON GV_$PARAMETER2 TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_FREE_SPACE TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON DBA_DATA_FILES TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON AUDIT_ACTIONS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$IM_SEGMENTS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER_TAB_COMMENTS TO ' || username_ || ' WITH GRANT OPTION');

   --
   -- IFS Monitoring BEGIN
   Run_Ddl('GRANT SELECT ON GV_$LOCK TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON GV_$TRANSACTION TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON GV_$SQLAREA TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON V_$SGAINFO TO ' || username_ );
   Run_Ddl('GRANT SELECT ON V_$SGASTAT TO ' || username_ );
   Run_Ddl('GRANT SELECT ON V_$PGASTAT TO ' || username_ );
   Run_Ddl('GRANT SELECT ON V_$SYSSTAT TO ' || username_ );
   -- END IFS Monitoring
   Run_Ddl('GRANT SELECT ON ARGUMENT$ TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON COM$ TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON COL$ TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON JOBSEQ TO ' || username_);
   Run_Ddl('GRANT SELECT ON OBJ$ TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON USER$ TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON PENDING_TRANS$ TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON SOURCE$ TO ' || username_ || ' WITH GRANT OPTION');
   --
   -- Oracle packages
   --
   Run_Ddl('GRANT EXECUTE ON DBMS_ALERT TO ' || username_);
   Run_Ddl('GRANT EXECUTE ON DBMS_LOCK TO ' || username_);
   Run_Ddl('GRANT EXECUTE ON DBMS_FLASHBACK TO ' || username_);
   Run_Ddl('GRANT EXECUTE ON DBMS_HPROF TO ' || username_);
   Run_Ddl('GRANT EXECUTE ON DBMS_MONITOR TO ' || username_);
   Run_Ddl('GRANT EXECUTE ON DBMS_PIPE TO ' || username_);
   Run_Ddl('GRANT EXECUTE ON UTL_FILE TO ' || username_);
   Run_Ddl('GRANT EXECUTE ON UTL_HTTP TO ' || username_);
   Run_Ddl('GRANT EXECUTE ON UTL_SMTP TO ' || username_);
   Run_Ddl('GRANT EXECUTE ON DBMS_HM TO ' || username_ || ' WITH GRANT OPTION');
   -- Grants needed for Appowner to be able to use encryption
   --
   Run_Ddl('GRANT EXECUTE ON DBMS_CRYPTO TO ' || username_);
   --
   --
   -- Grants needed for Appowner to be able to use parallel re-compilation
   --
   Run_Ddl('GRANT EXECUTE ON UTL_RECOMP TO ' || username_ );
   --
   --
   -- Grants needed for Appowner to be able to shrink lob segments, only available in Enterprise Edition
   --
   SELECT COUNT(*)
   INTO oracle_version_
   FROM v$version
   WHERE UPPER(banner) LIKE '%ENTERPRISE%EDITION%';
   IF (oracle_version_ > 0) THEN
      Run_Ddl('GRANT EXECUTE ON DBMS_REDEFINITION TO ' || username_ );
   END IF;
   --
   --
   -- Grants needed for Appowner to be able to use OracleText
   --
   Run_Ddl('GRANT EXECUTE ON CTXSYS.CTX_DDL TO ' || username_, 'ORACLETEXT');
   Run_Ddl('GRANT SELECT ON CTXSYS.CTX_INDEX_ERRORS TO ' || username_ || ' WITH GRANT OPTION');
   --
   -- Grants required for Oracle Advanced Queuing and Oracle AQ JMS
   --
   Run_Ddl('GRANT AQ_USER_ROLE TO ' || username_ || ' WITH ADMIN OPTION');
   Run_Ddl('GRANT AQ_ADMINISTRATOR_ROLE TO ' || username_ || ' WITH ADMIN OPTION');
   Run_Ddl('GRANT EXECUTE ON DBMS_AQ TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT EXECUTE ON DBMS_AQADM TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT EXECUTE ON DBMS_AQIN TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT EXECUTE ON DBMS_AQJMS TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON gv_$aq TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON dba_queues TO ' || username_ || ' WITH GRANT OPTION');
   Run_Ddl('GRANT SELECT ON dba_queue_subscribers TO ' || username_ || ' WITH GRANT OPTION');
   BEGIN
      dbms_aqadm.grant_type_access(username_);
      dbms_aqadm.grant_system_privilege('ENQUEUE_ANY', username_, TRUE);
      dbms_aqadm.grant_system_privilege('DEQUEUE_ANY', username_, TRUE);
      dbms_aqadm.grant_system_privilege('MANAGE_ANY', username_, TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line('ERROR: '||SQLERRM);
   END;
   --
   -- Index needed for IFS Applications to be able to use OracleText with expected performance
   --
   Run_Ddl('CREATE INDEX CTXSYS.DRX$ERR_KEY ON CTXSYS.DR$INDEX_ERROR (ERR_IDX_ID, ERR_TEXTKEY)', 'CTXSYS');

   --
   -- Revoke grants for installing of old implementation of PL/SQL Access Provider and IFS Extended Server
   --
   Revoke_Java_Grant;
   --
   -- Add java grants for Data Migration
   --
   Run_DDL('GRANT JAVAUSERPRIV TO '||username_);
   Run_DDL('BEGIN Dbms_Java.Grant_Permission('''||username_||''',''SYS:java.io.FilePermission'',''<<ALL FILES>>'',''read,write,delete'');END;');
   --
   -- Remove ddl grants on SOURCE$
   --
   FOR rec IN get_source$_grants LOOP
      Run_Ddl('REVOKE '||rec.privilege||' ON SOURCE$ FROM ' || username_);
   END LOOP;
   --Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('To revoke obsolete privileges, run cleanup.sql as SYS or PDBADMIN user');
   --Dbms_Output.Put_Line('Run cleanup.sql as SYS to revoke obsolete privileges');
   --Dbms_Output.Put_Line(' ');
END Dbagrant;


BEGIN
   Dbagrant('&APPLICATION_OWNER');
END;
/