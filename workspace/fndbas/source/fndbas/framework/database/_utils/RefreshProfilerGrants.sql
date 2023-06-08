DECLARE

PROCEDURE DbagrantProfiler (
   username_ IN VARCHAR2,
   refresh_  IN BOOLEAN DEFAULT FALSE )
IS
   count_ NUMBER;
      
   CURSOR check_prof_objects_exist IS
      SELECT COUNT(*)
      FROM   all_objects
      WHERE  owner = 'SYS'
      AND   ((object_type = 'TABLE'
      AND     object_name IN ('PLSQL_PROFILER_RUNS', 'PLSQL_PROFILER_UNITS', 'PLSQL_PROFILER_DATA'))
      OR     (object_type = 'SEQUENCE'
      AND     object_name IN ('PLSQL_PROFILER_RUNNUMBER')));
      
   PROCEDURE Run_Ddl (
      stmt_  IN VARCHAR2,
      debug_ IN BOOLEAN DEFAULT TRUE)
   IS
   BEGIN
      EXECUTE IMMEDIATE stmt_;
      Dbms_Output.Put_Line('SUCCESS: ' || stmt_);
   EXCEPTION
      WHEN OTHERS THEN
         IF (debug_ OR SQLCODE NOT IN (-00942, -01434)) THEN -- Table or Synonym not exist
            Dbms_Output.Put_Line('ERROR  : ' || stmt_);
         END IF;
   END Run_Ddl;
BEGIN
   OPEN check_prof_objects_exist;
   FETCH check_prof_objects_exist INTO count_;
   CLOSE check_prof_objects_exist;

   IF (refresh_ AND count_ != 4) THEN
      Run_Ddl('REVOKE SELECT,INSERT,UPDATE,DELETE ON PLSQL_PROFILER_RUNS FROM '||username_, FALSE);
      Run_Ddl('REVOKE ALL ON PLSQL_PROFILER_UNITS FROM '||username_, FALSE);
      Run_Ddl('REVOKE ALL ON PLSQL_PROFILER_DATA FROM '||username_, FALSE);
      Run_Ddl('REVOKE ALL ON PLSQL_PROFILER_RUNNUMBER FROM '||username_, FALSE);
         
      Run_Ddl('DROP SYNONYM '||username_||'.PLSQL_PROFILER_RUNS', FALSE);
      Run_Ddl('DROP SYNONYM '||username_||'.PLSQL_PROFILER_UNITS', FALSE);
      Run_Ddl('DROP SYNONYM '||username_||'.PLSQL_PROFILER_DATA', FALSE);
      Run_Ddl('DROP SYNONYM '||username_||'.PLSQL_PROFILER_RUNNUMBER', FALSE);
   ELSE
      --
      -- Oracle profiler tables
      --
      Run_Ddl('GRANT SELECT,INSERT,UPDATE,DELETE ON PLSQL_PROFILER_RUNS      TO '||username_||' WITH GRANT OPTION');
      Run_Ddl('GRANT SELECT,INSERT,UPDATE,DELETE ON PLSQL_PROFILER_UNITS     TO '||username_||' WITH GRANT OPTION');
      Run_Ddl('GRANT SELECT,INSERT,UPDATE,DELETE ON PLSQL_PROFILER_DATA      TO '||username_||' WITH GRANT OPTION');
      Run_Ddl('GRANT ALL                         ON PLSQL_PROFILER_RUNNUMBER TO '||username_||' WITH GRANT OPTION');
      --
      -- CREATE SYNONYMS FOR Appowner TO Profiler TABLES
      --
      Run_Ddl('GRANT CREATE SESSION TO ' || username_);
      Run_Ddl('CREATE OR REPLACE SYNONYM '||username_||'.PLSQL_PROFILER_RUNS FOR sys.PLSQL_PROFILER_RUNS');
      Run_Ddl('CREATE OR REPLACE SYNONYM '||username_||'.PLSQL_PROFILER_UNITS FOR sys.PLSQL_PROFILER_UNITS');
      Run_Ddl('CREATE OR REPLACE SYNONYM '||username_||'.PLSQL_PROFILER_DATA FOR sys.PLSQL_PROFILER_DATA');
      Run_Ddl('CREATE OR REPLACE SYNONYM '||username_||'.PLSQL_PROFILER_RUNNUMBER FOR sys.PLSQL_PROFILER_RUNNUMBER');
   END IF;
END DbagrantProfiler;

PROCEDURE Refresh_Profiler_Grants (
   app_owner_ IN VARCHAR2 )
IS
   CURSOR get_profiler_users IS
      SELECT owner grantee
      FROM   all_synonyms
      WHERE  table_owner = 'SYS'
      AND    table_name IN ('PLSQL_PROFILER_RUNS', 'PLSQL_PROFILER_UNITS', 'PLSQL_PROFILER_DATA', 'PLSQL_PROFILER_RUNNUMBER')
      AND    synonym_name IN ('PLSQL_PROFILER_RUNS', 'PLSQL_PROFILER_UNITS', 'PLSQL_PROFILER_DATA', 'PLSQL_PROFILER_RUNNUMBER')
      AND    owner <> app_owner_;
BEGIN
   DbagrantProfiler(app_owner_, TRUE);
   FOR rec_ IN get_profiler_users LOOP
      DbagrantProfiler(rec_.grantee, TRUE);
   END LOOP;
END Refresh_Profiler_Grants;

BEGIN
   Refresh_Profiler_Grants('&APPLICATION_OWNER');
END;
/