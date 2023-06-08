-----------------------------------------------------------------------------
--
--  Logical unit: PerformanceAnalyze
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date       Sign     History
--  ------     ------   ---------------------------------------------------------
-- 03/10/2017  CHALLK   EAP_G1837164_	Bad Performance when using "Save Source" in "Performance Analyze Overview" screen
-- 11/10/2017  VIVILK   TEISD-1869: CLONE - Performance Analyzer: "Unit Details" and "Saved Unit Details" behave incorrectly and differently (STRIKE)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Start_Profiler (
	run_id_       OUT NUMBER,
	user_comment_ IN  VARCHAR2,
	app_comment_  IN  VARCHAR2 )
IS
   rid_  NUMBER;
BEGIN
   @ApproveDynamicStatement(2006-02-15,pemase)
   EXECUTE IMMEDIATE 'BEGIN sys.dbms_profiler.start_profiler(:comment, :comment1, :runid); END;' USING nvl(Substrb(user_comment_, 1, 2047), SYSDATE), nvl(Substrb(app_comment_, 1, 2047),''), OUT rid_;
   run_id_ := rid_;
   Fnd_Context_SYS.Set_Value('Performance_Analyze_API.current_status_','Running');
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Appl_General(lu_name_, 'PROFERRSTART: Unable to start performance analyzer. Check installation and run ORACLE_HOME\RDBMS\admin\proftab.sql as APPOWNER.');
END Start_Profiler;

PROCEDURE Stop_Profiler 
IS
BEGIN
   @ApproveDynamicStatement(2006-02-15,pemase)
   EXECUTE IMMEDIATE 'BEGIN sys.dbms_profiler.stop_profiler; END;';
   Fnd_Context_SYS.Set_Value('Performance_Analyze_API.current_status_','Stopped');
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Appl_General(lu_name_, 'PROFERRSTOP: Unable to stop performance analyzer. Check installation');
END Stop_Profiler;

PROCEDURE Pause_Profiler
IS
BEGIN
   @ApproveDynamicStatement(2006-02-15,pemase)
   EXECUTE IMMEDIATE 'BEGIN sys.dbms_profiler.pause_profiler; END;';
   Fnd_Context_SYS.Set_Value('Performance_Analyze_API.current_status_','Paused');
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Appl_General(lu_name_, 'PROFERRPAUSE: Unable to pause performance analyzer. Check installation');
END Pause_Profiler;

PROCEDURE Resume_Profiler
IS
BEGIN
   @ApproveDynamicStatement(2006-02-15,pemase)
   EXECUTE IMMEDIATE 'BEGIN sys.dbms_profiler.resume_profiler; END;';
   Fnd_Context_SYS.Set_Value('Performance_Analyze_API.current_status_','Running');
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Appl_General(lu_name_, 'PROFERRRESUME: Unable to resume performance analyzer. Check installation');
END Resume_Profiler;

@UncheckedAccess
FUNCTION Format_Time (
   time_ IN NUMBER ) RETURN NUMBER DETERMINISTIC
IS
BEGIN
   IF time_ = 0 THEN
      RETURN 0;
   ELSE
      RETURN round(time_/1e9, 12-trunc(log(10,time_)));
   END IF;
END Format_Time;

@UncheckedAccess
PROCEDURE Get_Status (
   status_ OUT VARCHAR2 )
IS
BEGIN
   status_ := Fnd_Context_SYS.Find_Value('Performance_Analyze_API.current_status_','Stopped');
END Get_Status;

@UncheckedAccess
FUNCTION Get_Total_Execution_Time (
   run_id_ IN NUMBER ) RETURN NUMBER
IS
   time_ NUMBER;
BEGIN
   @ApproveDynamicStatement(2006-02-15,pemase)
   EXECUTE IMMEDIATE 'SELECT SUM(total_time) FROM plsql_profiler_data WHERE runid = :run_id' INTO time_ USING run_id_;
   RETURN nvl(time_, 0);
END Get_Total_Execution_Time;

PROCEDURE Rollup_Run (
   run_id_ IN NUMBER,
   save_   IN VARCHAR2 DEFAULT 'FALSE' )
IS
BEGIN
   @ApproveDynamicStatement(2006-02-15,pemase)
   EXECUTE IMMEDIATE 'BEGIN sys.dbms_profiler.rollup_run(:runid); END;' USING run_id_;
   IF save_ = 'TRUE' THEN
      @ApproveDynamicStatement(2006-02-15,pemase)
      EXECUTE IMMEDIATE 'DELETE performance_analyze_source_tab WHERE run_id = :run_id' USING run_id_;
      @ApproveDynamicStatement(2006-02-15,pemase)
      EXECUTE IMMEDIATE '
      INSERT INTO performance_analyze_source_tab (run_id, name, type, line, text, unit_number, total_occur, total_time, min_time, max_time)
      SELECT u.runid,
      u.unit_name object_name,
      DECODE(u.unit_type, ''PACKAGE SPEC'', ''PACKAGE'', u.unit_type) object_type,
      s.line, 
      s.text, 
      d.unit_number, 
      d.total_occur, 
      d.total_time, 
      d.min_time, 
      d.max_time
      FROM plsql_profiler_units u
      INNER JOIN user_source s ON s.name = u.unit_name
      AND s.type = DECODE(u.unit_type, ''PACKAGE SPEC'', ''PACKAGE'', u.unit_type)
      LEFT JOIN plsql_profiler_data d ON d.runid = u.runid
      AND d.unit_number = u.unit_number
      AND d.line# = s.line
      WHERE u.unit_type <> ''ANONYMOUS BLOCK''
      AND u.unit_owner = Fnd_Session_API.Get_App_Owner
      AND u.runid = :runid' USING run_id_;
   END IF;
   @ApproveDynamicStatement(2006-02-15,pemase)
   EXECUTE IMMEDIATE 'UPDATE plsql_profiler_runs SET spare1 = :save WHERE runid = :runid' USING save_, run_id_;
   Fnd_Context_SYS.Set_Value('Performance_Analyze_API.current_status_','Stopped');
   @ApproveTransactionStatement(2015-07-07,ChAlLK)
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Appl_General(lu_name_, 'PROFERRROLLUP: Unable to rollup performance run. Oracle error [:P1]. Check installation', SQLERRM);
END Rollup_Run;

PROCEDURE Remove (
   run_id_ IN NUMBER )
IS
   owner_ VARCHAR2(30);
BEGIN
   @ApproveDynamicStatement(2006-02-15,pemase)
   EXECUTE IMMEDIATE 'SELECT run_owner FROM plsql_profiler_runs WHERE runid = :run_id' INTO owner_ USING run_id_;
   IF (Fnd_Session_API.Get_Fnd_User = owner_ OR
       Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User)) THEN
      BEGIN
         @ApproveDynamicStatement(2006-02-15,pemase)
         EXECUTE IMMEDIATE 'DELETE FROM performance_analyze_source_tab WHERE run_id = :runid' USING run_id_;
         @ApproveDynamicStatement(2006-02-15,pemase)
         EXECUTE IMMEDIATE 'DELETE FROM plsql_profiler_data  WHERE runid = :runid' USING run_id_;
         @ApproveDynamicStatement(2006-02-15,pemase)
         EXECUTE IMMEDIATE 'DELETE FROM plsql_profiler_units WHERE runid = :runid' USING run_id_;
         @ApproveDynamicStatement(2006-02-15,pemase)
         EXECUTE IMMEDIATE 'DELETE FROM plsql_profiler_runs  WHERE runid = :runid' USING run_id_;
      EXCEPTION
         WHEN OTHERS THEN
            Error_SYS.Appl_General(lu_name_, 'PROFERRREMOVE: Unable to remove performance run. Check installation');
      END;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'PROFERRREMPRIV: Performance data can only be removed as application owner or the user executed the run');
   END IF;
END Remove;

PROCEDURE Post_Installation_Object
IS
   stmt_ CLOB;
   eol_  VARCHAR2(2) := chr(13)||chr(10);
BEGIN
   stmt_ := 'CREATE OR REPLACE VIEW PERFORMANCE_ANALYZE_RUNS AS'||eol_;
   stmt_ := stmt_ || 'SELECT'||eol_;
   IF Database_SYS.Get_Object_Type('PLSQL_PROFILER_RUNS') IN ('SYNONYM') THEN
      stmt_ := stmt_ || '    RUNID                          RUN_ID,'||eol_;
      stmt_ := stmt_ || '    RELATED_RUN                    RELATED_RUN,'||eol_;
      stmt_ := stmt_ || '    RUN_OWNER                      RUN_OWNER,'||eol_;
      stmt_ := stmt_ || '    RUN_DATE                       RUN_DATE,'||eol_;
      stmt_ := stmt_ || '    RUN_COMMENT                    USER_COMMENT,'||eol_;
      stmt_ := stmt_ || '    decode(RUN_TOTAL_TIME, 0, 0, round(RUN_TOTAL_TIME/1e9, 12-trunc(log(10,RUN_TOTAL_TIME))))    RUN_TOTAL_TIME,'||eol_;
      stmt_ := stmt_ || '    (SELECT Performance_Analyze_API.Format_Time(SUM(d.total_time)) FROM plsql_profiler_data d WHERE d.runid = runid) RUN_EXECUTION_TIME,'||eol_;
      stmt_ := stmt_ || '    RUN_SYSTEM_INFO                RUN_SYSTEM_INFO,'||eol_;
      stmt_ := stmt_ || '    RUN_COMMENT1                   APP_COMMENT,'||eol_;
      stmt_ := stmt_ || '    SPARE1                         SAVE_SOURCE,'||eol_;
      stmt_ := stmt_ || '    rowid                          objid,'||eol_;
      stmt_ := stmt_ || '    TO_CHAR(run_date,''YYYYMMDDHH24MISS'')                    objversion '||eol_;
      stmt_ := stmt_ || 'FROM   plsql_profiler_runs '||eol_;
      stmt_ := stmt_ || 'WHERE (run_owner = Fnd_Session_API.Get_Fnd_User OR '||eol_;
      stmt_ := stmt_ || '       Security_SYS.Has_System_Privilege(''ADMINISTRATOR'') = ''TRUE'') '||eol_;
   ELSE
      stmt_ := stmt_ || '    NULL                           RUN_ID,'||eol_;
      stmt_ := stmt_ || '    NULL                           RELATED_RUN,'||eol_;
      stmt_ := stmt_ || '    NULL                           RUN_OWNER,'||eol_;
      stmt_ := stmt_ || '    NULL                           RUN_DATE,'||eol_;
      stmt_ := stmt_ || '    NULL                           USER_COMMENT,'||eol_;
      stmt_ := stmt_ || '    NULL                           RUN_TOTAL_TIME,'||eol_;
      stmt_ := stmt_ || '    NULL                           RUN_EXECUTION_TIME,'||eol_;
      stmt_ := stmt_ || '    NULL                           RUN_SYSTEM_INFO,'||eol_;
      stmt_ := stmt_ || '    NULL                           APP_COMMENT,'||eol_;
      stmt_ := stmt_ || '    NULL                           SAVE_SOURCE,'||eol_;
      stmt_ := stmt_ || '    NULL                           objid,'||eol_;
      stmt_ := stmt_ || '    NULL                           objversion '||eol_;
      stmt_ := stmt_ || 'FROM   dual '||eol_;
      stmt_ := stmt_ || 'WHERE 1=2 '||eol_;
   END IF;
   stmt_ := stmt_ || 'WITH READ ONLY';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE stmt_;
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON TABLE PERFORMANCE_ANALYZE_RUNS
   IS ''LU=PerformanceAnalyze^PROMPT=Performance Analyzer^MODULE=FNDBAS^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_RUNS.run_id
   IS ''FLAGS=K---L^DATATYPE=NUMBER^PROMPT=Run Id^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_RUNS.related_run
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Related Run^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_RUNS.run_owner
   IS ''FLAGS=A---L^DATATYPE=STRING(32)^PROMPT=Run Owner^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_RUNS.run_date
   IS ''FLAGS=A---L^DATATYPE=DATE/DATETIME^PROMPT=Run Date^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_RUNS.user_comment
   IS ''FLAGS=A---L^DATATYPE=STRING(2047)^PROMPT=User Comment^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_RUNS.run_total_time
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Elapsed Time^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_RUNS.run_execution_time
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Execution Time^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_RUNS.run_system_info
   IS ''FLAGS=A---L^DATATYPE=STRING(2047)^PROMPT=System Info^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_RUNS.app_comment
   IS ''FLAGS=A---L^DATATYPE=STRING(2047)^PROMPT=Application Comment^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_RUNS.save_source
   IS ''FLAGS=A---L^DATATYPE=STRING(256)^PROMPT=Saved Source^''';


   stmt_ := 'CREATE OR REPLACE VIEW PERFORMANCE_ANALYZE_UNITS AS'||eol_;
   stmt_ := stmt_ || 'SELECT'||eol_;
   IF Database_SYS.Get_Object_Type('PLSQL_PROFILER_UNITS') IN ('SYNONYM') THEN
      stmt_ := stmt_ || '    RUNID                          RUN_ID,'||eol_;
      stmt_ := stmt_ || '    UNIT_NUMBER                    UNIT_NUMBER,'||eol_;
      stmt_ := stmt_ || '    UNIT_TYPE                      UNIT_TYPE,'||eol_;
      stmt_ := stmt_ || '    UNIT_OWNER                     UNIT_OWNER,'||eol_;
      stmt_ := stmt_ || '    UNIT_NAME                      UNIT_NAME,'||eol_;
      stmt_ := stmt_ || '    UNIT_TIMESTAMP                 UNIT_TIMESTAMP,'||eol_;
      stmt_ := stmt_ || '    decode(TOTAL_TIME, 0, 0, round(TOTAL_TIME/1e9, 12-trunc(log(10,TOTAL_TIME)))) TOTAL_TIME,'||eol_;
      stmt_ := stmt_ || '    SPARE1                         SPARE1,'||eol_;
      stmt_ := stmt_ || '    SPARE2                         SPARE2,'||eol_;
      stmt_ := stmt_ || '    rowid                          objid,'||eol_;
      stmt_ := stmt_ || '    TO_CHAR(runid) objversion '||eol_;
      stmt_ := stmt_ || 'FROM   plsql_profiler_units '||eol_;
   ELSE
      stmt_ := stmt_ || '    NULL                           RUN_ID,'||eol_;
      stmt_ := stmt_ || '    NULL                           UNIT_NUMBER,'||eol_;
      stmt_ := stmt_ || '    NULL                           UNIT_TYPE,'||eol_;
      stmt_ := stmt_ || '    NULL                           UNIT_OWNER,'||eol_;
      stmt_ := stmt_ || '    NULL                           UNIT_NAME,'||eol_;
      stmt_ := stmt_ || '    NULL                           UNIT_TIMESTAMP,'||eol_;
      stmt_ := stmt_ || '    NULL                           TOTAL_TIME,'||eol_;
      stmt_ := stmt_ || '    NULL                           SPARE1,'||eol_;
      stmt_ := stmt_ || '    NULL                           SPARE2,'||eol_;
      stmt_ := stmt_ || '    NULL                           objid,'||eol_;
      stmt_ := stmt_ || '    NULL                           objversion '||eol_;
      stmt_ := stmt_ || 'FROM   dual '||eol_;
      stmt_ := stmt_ || 'WHERE 1=2 '||eol_;
   END IF;
   stmt_ := stmt_ || 'WITH READ ONLY';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE stmt_;
   
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON TABLE PERFORMANCE_ANALYZE_UNITS
   IS ''LU=PerformanceAnalyze^PROMPT=Performance Analyzer^MODULE=FNDBAS^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_UNITS.run_id
   IS ''FLAGS=PM--L^DATATYPE=NUMBER^PROMPT=Run Id^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_UNITS.unit_number
   IS ''FLAGS=KM--L^DATATYPE=NUMBER^PROMPT=Unit Number^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_UNITS.unit_type
   IS ''FLAGS=A---L^DATATYPE=STRING(32)^PROMPT=Unit Type^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_UNITS.unit_owner
   IS ''FLAGS=A---L^DATATYPE=STRING(32)^PROMPT=Unit Owner^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_UNITS.unit_name
   IS ''FLAGS=A---L^DATATYPE=STRING(32)^PROMPT=Unit Name^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_UNITS.unit_timestamp
   IS ''FLAGS=A---L^DATATYPE=DATE/DATETIME^PROMPT=Unit Timestamp^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_UNITS.total_time
   IS ''FLAGS=AM--L^DATATYPE=NUMBER^PROMPT=Total Time^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_UNITS.spare1
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Spare One^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_UNITS.spare2
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Spare Two^''';



   stmt_ := 'CREATE OR REPLACE VIEW PERFORMANCE_ANALYZE_DATA AS'||eol_;
   stmt_ := stmt_ || 'SELECT'||eol_;
   IF Database_SYS.Get_Object_Type('PLSQL_PROFILER_DATA') IN ('SYNONYM') THEN
      stmt_ := stmt_ || '    RUNID                          RUN_ID,'||eol_;
      stmt_ := stmt_ || '    UNIT_NUMBER                    UNIT_NUMBER,'||eol_;
      stmt_ := stmt_ || '    LINE#                          LINE#,'||eol_;
      stmt_ := stmt_ || '    TOTAL_OCCUR                    TOTAL_OCCUR,'||eol_;
      stmt_ := stmt_ || '    decode(TOTAL_TIME, 0, 0, round(TOTAL_TIME/1e9, 12-trunc(log(10,TOTAL_TIME))))               TOTAL_TIME,'||eol_;
      stmt_ := stmt_ || '    decode(TOTAL_OCCUR, 0, 0, decode(TOTAL_TIME, 0, 0, round(TOTAL_TIME/1e9/TOTAL_OCCUR, 12-trunc(log(10,decode(TOTAL_TIME, 0, 1, TOTAL_TIME/TOTAL_OCCUR))))))      AVERAGE_TIME,'||eol_;
      stmt_ := stmt_ || '    decode(MIN_TIME, 0, 0, round(MIN_TIME/1e9, 12-trunc(log(10,MIN_TIME))))                 MIN_TIME,'||eol_;
      stmt_ := stmt_ || '    decode(MAX_TIME, 0, 0, round(MAX_TIME/1e9, 12-trunc(log(10,MAX_TIME))))                 MAX_TIME,'||eol_;
      stmt_ := stmt_ || '    SPARE1                         SPARE1,'||eol_;
      stmt_ := stmt_ || '    SPARE2                         SPARE2,'||eol_;
      stmt_ := stmt_ || '    SPARE3                         SPARE3,'||eol_;
      stmt_ := stmt_ || '    SPARE4                         SPARE4,'||eol_;
      stmt_ := stmt_ || '    rowid                          objid,'||eol_;
      stmt_ := stmt_ || '    TO_CHAR(runid) objversion '||eol_;
      stmt_ := stmt_ || 'FROM   plsql_profiler_data '||eol_;
   ELSE
      stmt_ := stmt_ || '    NULL                           RUN_ID,'||eol_;
      stmt_ := stmt_ || '    NULL                           UNIT_NUMBER,'||eol_;
      stmt_ := stmt_ || '    NULL                           LINE#,'||eol_;
      stmt_ := stmt_ || '    NULL                           TOTAL_OCCUR,'||eol_;
      stmt_ := stmt_ || '    NULL                           TOTAL_TIME,'||eol_;
      stmt_ := stmt_ || '    NULL                           AVERAGE_TIME,'||eol_;
      stmt_ := stmt_ || '    NULL                           MIN_TIME,'||eol_;
      stmt_ := stmt_ || '    NULL                           MAX_TIME,'||eol_;
      stmt_ := stmt_ || '    NULL                           SPARE1,'||eol_;
      stmt_ := stmt_ || '    NULL                           SPARE2,'||eol_;
      stmt_ := stmt_ || '    NULL                           SPARE3,'||eol_;
      stmt_ := stmt_ || '    NULL                           SPARE4,'||eol_;
      stmt_ := stmt_ || '    NULL                           objid,'||eol_;
      stmt_ := stmt_ || '    NULL                           objversion '||eol_;
      stmt_ := stmt_ || 'FROM   dual '||eol_;
      stmt_ := stmt_ || 'WHERE 1=2 '||eol_;
   END IF;
   stmt_ := stmt_ || 'WITH READ ONLY';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE stmt_;

   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON TABLE PERFORMANCE_ANALYZE_DATA
   IS ''LU=PerformanceAnalyze^PROMPT=Performance Analyzer^MODULE=FNDBAS^''';

   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_DATA.run_id
   IS ''FLAGS=PM--L^DATATYPE=NUMBER^PROMPT=Run Id^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_DATA.unit_number
   IS ''FLAGS=PM--L^DATATYPE=NUMBER^PROMPT=Unit Number^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_DATA.line#
   IS ''FLAGS=KM--L^DATATYPE=NUMBER^PROMPT=Line Number^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_DATA.total_occur
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Occur^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_DATA.total_time
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Total Time^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_DATA.average_time
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Average Time^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_DATA.min_time
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Min Time^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_DATA.max_time
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Max Time^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_DATA.spare1
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Spare One^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_DATA.spare2
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Spare Two^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_DATA.spare3
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Spare Three^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_DATA.spare4
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Spare Four^''';


   stmt_ := 'CREATE OR REPLACE VIEW PERFORMANCE_ANALYZE_SRC AS'||eol_;
   stmt_ := stmt_ || 'SELECT'||eol_;
   IF Database_SYS.Get_Object_Type('PLSQL_PROFILER_UNITS') IN ('SYNONYM') THEN
      stmt_ := stmt_ || '       pu.RUNID                           RUN_ID,'||eol_;
      stmt_ := stmt_ || '       pu.UNIT_NUMBER                     UNIT_NUMBER,'||eol_;
      stmt_ := stmt_ || '       pu.unit_name                       UNIT_NAME,'||eol_;
      stmt_ := stmt_ || '       s.LINE                             LINE,'||eol_;
      stmt_ := stmt_ || '       s.SOURCE                           TEXT,'||eol_;
      stmt_ := stmt_ || '       d.TOTAL_OCCUR                      TOTAL_OCCUR,'||eol_;
      stmt_ := stmt_ || '       decode(d.TOTAL_TIME, 0, 0, round(d.TOTAL_TIME/1e9, 12-trunc(log(10,d.TOTAL_TIME))))               TOTAL_TIME,'||eol_;
      stmt_ := stmt_ || '       decode(d.TOTAL_OCCUR, 0, 0, decode(d.TOTAL_TIME, 0, 0, round(d.TOTAL_TIME/1e9/d.TOTAL_OCCUR, 12-trunc(log(10,d.TOTAL_TIME/d.TOTAL_OCCUR)))))      AVERAGE_TIME,'||eol_;
      stmt_ := stmt_ || '       decode(d.MIN_TIME, 0, 0, round(d.MIN_TIME/1e9, 12-trunc(log(10,d.MIN_TIME))))                 MIN_TIME,'||eol_;
      stmt_ := stmt_ || '       decode(d.MAX_TIME, 0, 0, round(d.MAX_TIME/1e9, 12-trunc(log(10,d.MAX_TIME))))                 MAX_TIME '||eol_;
      stmt_ := stmt_ || 'FROM   plsql_profiler_units pu, plsql_profiler_data d, user_objects u, sys.source$ s '||eol_;
      stmt_ := stmt_ || 'WHERE  pu.unit_number = d.unit_number '||eol_;
      stmt_ := stmt_ || 'AND    pu.runid = d.runid '||eol_;
      stmt_ := stmt_ || 'AND    pu.unit_name = u.object_name '||eol_;
      stmt_ := stmt_ || 'AND    decode(pu.unit_type,''PACKAGE SPEC'', ''PACKAGE'',pu.unit_type) = u.object_type '||eol_;
      stmt_ := stmt_ || 'AND    u.object_id = s.obj# '||eol_;
      stmt_ := stmt_ || 'AND    d.line# = s.line '||eol_;
      stmt_ := stmt_ || 'AND    d.TOTAL_OCCUR > 0 '||eol_;
   ELSE
      stmt_ := stmt_ || '       NULL                               RUN_ID,'||eol_;
      stmt_ := stmt_ || '       NULL                               UNIT_NUMBER,'||eol_;
      stmt_ := stmt_ || '       NULL                               UNIT_NAME,'||eol_;
      stmt_ := stmt_ || '       NULL                               LINE,'||eol_;
      stmt_ := stmt_ || '       NULL                               TEXT,'||eol_;
      stmt_ := stmt_ || '       NULL                               TOTAL_OCCUR,'||eol_;
      stmt_ := stmt_ || '       NULL                               TOTAL_TIME,'||eol_;
      stmt_ := stmt_ || '       NULL                               AVERAGE_TIME,'||eol_;
      stmt_ := stmt_ || '       NULL                               MIN_TIME,'||eol_;
      stmt_ := stmt_ || '       NULL                               MAX_TIME '||eol_;
      stmt_ := stmt_ || 'FROM   dual '||eol_;
      stmt_ := stmt_ || 'WHERE 1=2 '||eol_;
   END IF;
   stmt_ := stmt_ || 'WITH READ ONLY';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE stmt_;

   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON TABLE PERFORMANCE_ANALYZE_SRC
   IS ''LU=PerformanceAnalyze^PROMPT=Performance Analyzer^MODULE=FNDBAS^''';

   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_SRC.run_id
   IS ''FLAGS=PM--L^DATATYPE=NUMBER^PROMPT=Run Id^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_SRC.unit_number
   IS ''FLAGS=PM--L^DATATYPE=NUMBER^PROMPT=Unit Number^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_SRC.unit_name
   IS ''FLAGS=PM--L^DATATYPE=STRING(128)^PROMPT=Unit Name^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_SRC.line
   IS ''FLAGS=KM--L^DATATYPE=NUMBER^PROMPT=Line^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_SRC.text
   IS ''FLAGS=A---L^DATATYPE=STRING(4000)^PROMPT=Text^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_SRC.total_occur
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Occur^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_SRC.total_time
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Total Time^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_SRC.average_time
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Average Time^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_SRC.min_time
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Min Time^''';
   @ApproveDynamicStatement(2015-07-06,haarse)
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN PERFORMANCE_ANALYZE_SRC.max_time
   IS ''FLAGS=A---L^DATATYPE=NUMBER^PROMPT=Max Time^''';
      
END Post_Installation_Object;
