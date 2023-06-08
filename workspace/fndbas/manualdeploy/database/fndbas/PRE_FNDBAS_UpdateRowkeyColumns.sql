-- =========================================================================================
--
-- File:          PRE_FNDBAS_UpdateRowkeyColumns.sql
--
-- Component:     FNDBAS
--
-- Pre-requisit:  There is no known pre-requisit found.
--
-- Purpose:    This script is executed to update the Rowkey columns with values before an upgrade. From IFS Applications version 8, almost all
--             tables are added with this column for supporting several functionality in the Application, e.g. Custom Objects. However, none of
--             this functionality is able to use before the rowkey columns is fed with values, and this is a rather time consuming process. If
--             you have a very large database, it can be wise to preload the rowkey columns before the atcual upgrade. This method deploy some
--             functionality for filling the rowkey columns, it does not do the actual update. Please, read the documentation how to use this.
--             
--             NOTE! It is not mandatory to fill your rowkey columns with data in IFS Applications 10 even though it is recommended.
--             
--  Usage:     Start the Command Prompt. Move to the directory where this file
--             is located. Issue the command:
--          
--             sqlplus <appowner>/<appowner>@<database> PRE_FNDBAS_UpdateRowkeyColumns.sql
-- 
--             substituting "appowner" with the Application owner and password
--             in your database, and "database" with the name of the database.
--
--             You will be prompted two questions, please give the values for tablespace for data, e.g. IFSAPP_DATA, and for index, e.g. IFSAPP_INDEX
--
--
--  DATE     BY      NOTES
--  ------   -----   ------------------------------------------------------------------------------
--  ===============================================================================================
--

DEFINE IFSAPP_DATA=&IFSAPP_DATA
DEFINE IFSAPP_INDEX=&IFSAPP_INDEX

SET VERIFY OFF
SET SERVEROUTPUT ON

BEGIN
   IF Installation_SYS.Table_Exist('ROWKEY_PREPARE_TAB') THEN
      Dbms_Output.Put_Line('Backing up old version of table ROWKEY_PREPARE_TAB');
      IF Installation_SYS.Table_Exist('ROWKEY_PREPARE_OLD') THEN
         EXECUTE IMMEDIATE 'DROP TABLE rowkey_prepare_old CASCADE CONSTRAINTS';
         Dbms_Output.Put_Line('A backed up version of the table already exists, this will be dropped');
      END IF;
      BEGIN
         EXECUTE IMMEDIATE 'ALTER TABLE rowkey_prepare_tab DROP CONSTRAINT rowkey_prepare_pk';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      EXECUTE IMMEDIATE 'RENAME rowkey_prepare_tab TO rowkey_prepare_old';
      Dbms_Output.Put_Line('Existing table ROWKEY_PREPARE_TAB is renamed to ROWKEY_PREPARE_OLD');
   END IF;
   EXECUTE IMMEDIATE 'CREATE TABLE rowkey_prepare_tab (table_name VARCHAR2(128) NOT NULL, state VARCHAR2(30), where_clause VARCHAR2(2000), comments VARCHAR2(2000), total_num_records NUMBER, records_without_rowkey NUMBER, log_date DATE) TABLESPACE &IFSAPP_DATA';
   EXECUTE IMMEDIATE 'ALTER TABLE rowkey_prepare_tab ADD CONSTRAINT rowkey_prepare_pk PRIMARY KEY (table_name) USING INDEX TABLESPACE &IFSAPP_INDEX';
END;
/

SET SERVEROUTPUT OFF

CREATE OR REPLACE PACKAGE Rowkey_Prepare_API IS

module_                   CONSTANT VARCHAR2(6)      := 'FNDBAS';
service_                  CONSTANT VARCHAR2(30)     := 'RowkeyPrepare';
lu_name_                  CONSTANT VARCHAR2(30)     := 'RowkeyPrepare';
lu_type_                  CONSTANT VARCHAR2(30)     := 'SystemService';

PROCEDURE Rowkey_Stop_Update_;

PROCEDURE Feed_Worktable (
   table_name_   IN VARCHAR2,
   where_clause_ IN VARCHAR2 );

PROCEDURE Rerun_Loaded_Tables;

PROCEDURE Rerun_Ignored_Tables;

PROCEDURE Count_Records (
   table_name_ VARCHAR2 DEFAULT NULL );

PROCEDURE Add_Rowkey;

PROCEDURE Rowkey_Update (
   chunk_size_       IN NUMBER,
   parallel_         IN VARCHAR2,
   exec_time_        IN NUMBER,
   alter_tables_     IN VARCHAR2,
   only_prio_tables_ IN VARCHAR2 );

PROCEDURE Rowkey_Update (
   attr_  IN VARCHAR2 );

END Rowkey_Prepare_API;
/

CREATE OR REPLACE PACKAGE BODY Rowkey_Prepare_API IS

update_rowkey_job_   CONSTANT VARCHAR2(20)   := 'UPDATE_ROWKEY_JOB';
break_rowkey_job_    CONSTANT VARCHAR2(20)   := 'BREAK_ROWKEY_UPDATE_';
true_statement_      CONSTANT VARCHAR2(3)    := '1=1';
state_finished_      CONSTANT VARCHAR2(30)   := 'Finished';
state_loaded_        CONSTANT VARCHAR2(30)   := 'Loaded';
state_to_do_         CONSTANT VARCHAR2(30)   := 'ToDo';
state_add_rowkey_    CONSTANT VARCHAR2(30)   := 'AddRowkey';
state_ignored_       CONSTANT VARCHAR2(30)   := 'Ignored';

FUNCTION Get_Init_Ora_Parameter___ (
   parameter_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_param IS
   SELECT value
     FROM v$parameter
    WHERE name = parameter_;

   value_  v$parameter.value%TYPE;
BEGIN
   OPEN  get_param;
   FETCH get_param INTO value_;
   CLOSE get_param;
   RETURN(value_);
END Get_Init_Ora_Parameter___;

PROCEDURE Log_Status_Info___ (
   info_        IN VARCHAR2,
   status_type_ IN VARCHAR2 DEFAULT 'WARNING' )
IS
   PRAGMA            AUTONOMOUS_TRANSACTION;
BEGIN
   Dbms_OutPut.Put_Line(status_type_||': '||info_);
   Transaction_SYS.Set_Status_Info(SUBSTR(info_, 1, 2000), status_type_);
   COMMIT;
END Log_Status_Info___;

FUNCTION Update_Rowkey_Seriel___ (
   table_name_   IN VARCHAR2,
   where_clause_ IN VARCHAR2,
   chunck_size_  IN NUMBER,
   count_init_   IN NUMBER ) RETURN BOOLEAN 
IS
   count_      NUMBER;
   count_done_ NUMBER;
   sql_error_  VARCHAR2(2000);
   stmt_       VARCHAR2(32000) := 'SELECT count(*) FROM ' || table_name_ || ' WHERE rowkey IS NULL';
BEGIN
   EXECUTE IMMEDIATE 'UPDATE ' || table_name_ || ' SET rowkey = rowid WHERE rowkey IS NULL AND ROWNUM <= '||chunck_size_||' AND '||where_clause_;
   COMMIT;
   RETURN TRUE;
EXCEPTION
   WHEN OTHERS THEN
      sql_error_ := SUBSTR(SQLERRM, 1, 2000);
      Dbms_OutPut.Put_Line(table_name_||' failed. '||sql_error_);
      EXECUTE IMMEDIATE stmt_ INTO count_;
      count_done_ := count_init_-count_;
      Log_Status_Info___('Seriel update of rowkey in table '||table_name_||' failed. '||count_done_||' records have been updated and '||count_||' records reamins. '||sql_error_, 'WARNING');
      UPDATE rowkey_prepare_tab SET log_date = SYSDATE, comments = SUBSTR('Seriel update of rowkey failed. '||count_done_||' records have been updated and '||count_||' records reamins. '||sql_error_, 1, 2000), records_without_rowkey = count_ WHERE table_name = table_name_;
      RETURN FALSE;
END Update_Rowkey_Seriel___;

FUNCTION Update_Rowkey_Parallel___ (
   table_name_     IN VARCHAR2,
   where_clause_   IN VARCHAR2,
   chunk_size_     IN NUMBER,
   parallel_level_ IN NUMBER,
   count_init_     IN NUMBER ) RETURN BOOLEAN
IS
$IF NOT Dbms_Db_Version.ver_le_10 $THEN -- Oracle11 and above
   task_dropped EXCEPTION;
   PRAGMA       EXCEPTION_INIT(task_dropped, -29498);
   sql_error_   VARCHAR2(2000);
   count_       NUMBER;
   count_done_  NUMBER;
   stmt_        VARCHAR2(32000) := 'UPDATE /*+ ROWID (dda) */ ' || table_name_ || ' SET rowkey = rowid WHERE rowkey IS NULL AND '||where_clause_;
   stmt2_       VARCHAR2(32000) := 'SELECT COUNT(*) FROM ' || table_name_ || ' WHERE rowkey IS NULL';
   stmt_where_  VARCHAR2(32000) := stmt2_||' AND '||where_clause_;
   PROCEDURE Drop_Tasks (
      table_name_ IN VARCHAR2 )
   IS
      CURSOR get_task IS
         SELECT task_name
         FROM user_parallel_execute_tasks
         WHERE table_name = upper(table_name_);
   BEGIN
      FOR rec IN get_task LOOP
         Dbms_Parallel_Execute.Drop_Task(rec.task_name);
      END LOOP;
   END Drop_Tasks;
   PROCEDURE Execute_Task (
      table_name_     IN VARCHAR2,
      stmt_           IN VARCHAR2,
      chunk_size_     IN NUMBER,
      parallel_level_ IN NUMBER,
      task_name_      IN VARCHAR2 )
   IS
      status_        NUMBER;
      trg_count_     NUMBER;
      error_message_ VARCHAR2(32000);
      CURSOR get_active_triggers(table_name_ VARCHAR2) IS
         SELECT COUNT(*)
         FROM   user_triggers t
         WHERE  t.table_name = table_name_
         AND    t.status = 'ENABLED';
      CURSOR get_parallel_chunks IS
         SELECT error_message
         FROM   USER_PARALLEL_EXECUTE_CHUNKS t
         WHERE  error_message IS NOT NULL;
   BEGIN
      Drop_Tasks(table_name_);
      Dbms_Parallel_Execute.Create_Task(task_name_);
      Dbms_Parallel_Execute.Create_Chunks_By_Rowid(task_name   => task_name_,
                                                   table_owner => Fnd_Session_API.Get_App_Owner,
                                                   table_name  => table_name_,
                                                   by_row      => TRUE,
                                                   chunk_size  => chunk_size_);
      Dbms_Parallel_Execute.Run_Task(task_name      => task_name_,
                                     sql_stmt       => stmt_,
                                     language_flag  => Dbms_Sql.NATIVE,
                                     parallel_level => parallel_level_);
      status_ := Dbms_Parallel_Execute.Task_Status(task_name_);
      IF (status_ IN (Dbms_Parallel_Execute.FINISHED_WITH_ERROR, Dbms_Parallel_Execute.CRASHED)) THEN
         Dbms_Parallel_Execute.Resume_Task(task_name_);
         status_ := Dbms_Parallel_Execute.Task_Status(task_name_);
      END IF;
      IF (status_ != Dbms_Parallel_Execute.FINISHED) THEN
         OPEN get_parallel_chunks;
         FETCH get_parallel_chunks INTO error_message_;
         IF get_parallel_chunks%FOUND THEN
            CLOSE get_parallel_chunks;
            Raise_Application_Error(-20105, 'RowKey activation on table '||table_name_||' failed due to unexpected error. Please take action on error '||error_message_);
         ELSE
            CLOSE get_parallel_chunks;
            OPEN get_active_triggers(table_name_);
            FETCH get_active_triggers INTO trg_count_;
            CLOSE get_active_triggers;
            IF(trg_count_ > 0) THEN
               Raise_Application_Error(-20105, 'RowKey activation failed probably due to active triggers on table '||table_name_||', please disable triggers.');
            ELSE
               Raise_Application_Error(-20105, 'The task '||task_name_||' finished with an unknown error.');
            END IF;
         END IF;
      END IF;
      IF (status_ = Dbms_Parallel_Execute.FINISHED) THEN
         Dbms_Parallel_Execute.Drop_Task(task_name_);
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         Dbms_Parallel_Execute.Drop_Task(task_name_);
         RAISE;
   END Execute_Task;
$END
BEGIN
$IF NOT Dbms_Db_Version.ver_le_10 $THEN -- Oracle11 and above
   -- Check if there exists rowkey with null
   EXECUTE IMMEDIATE stmt_where_ INTO count_;
   -- Only update if there exists rowkey with null
   IF (count_ > 0) THEN
      stmt_ := stmt_ || ' AND rowid BETWEEN :start_id AND :end_id';
      Execute_Task(table_name_,
                   stmt_,
                   chunk_size_,
                   parallel_level_,
                   update_rowkey_job_);
   END IF;
   RETURN TRUE;
EXCEPTION
   WHEN task_dropped THEN
      EXECUTE IMMEDIATE stmt2_ INTO count_;
      count_done_ := count_init_-count_;
      Log_Status_Info___('Task for update of rowkey in table '||table_name_||' dropped. Probably it run out of time. '||count_done_||' records have been updated and '||count_||' records reamins', 'INFO');
      UPDATE rowkey_prepare_tab SET log_date = SYSDATE, comments = 'Task for update of rowkey dropped. Probably it run out of time. '||count_done_||' records have been updated and '||count_||' records reamins', records_without_rowkey = count_ WHERE table_name = table_name_;
      RETURN FALSE;
   WHEN OTHERS THEN
      sql_error_ := SUBSTR(SQLERRM, 1, 2000);
      Dbms_OutPut.Put_Line(table_name_||' failed. '||sql_error_);
      EXECUTE IMMEDIATE stmt2_ INTO count_;
      count_done_ := count_init_-count_;
      Log_Status_Info___('Parallel update of rowkey in table '||table_name_||' failed. '||count_done_||' records have been updated and '||count_||' records reamins. '||sql_error_, 'WARNING');
      UPDATE rowkey_prepare_tab SET log_date = SYSDATE, comments = SUBSTR('Parallel update of rowkey failed. '||count_done_||' records have been updated and '||count_||' records reamins. '||sql_error_, 1, 2000), records_without_rowkey = count_ WHERE table_name = table_name_;
      RETURN FALSE;
$ELSE
   RETURN FALSE;
$END
END Update_Rowkey_Parallel___;

PROCEDURE Rowkey_Stop_Update_
IS
BEGIN
$IF NOT Dbms_Db_Version.ver_le_10 $THEN -- Oracle11 and above
   DBMS_PARALLEL_EXECUTE.DROP_TASK(update_rowkey_job_);
$ELSE
   NULL;
$END
END Rowkey_Stop_Update_;

PROCEDURE Feed_Worktable (
   table_name_   IN VARCHAR2,
   where_clause_ IN VARCHAR2 )
IS
BEGIN
   INSERT INTO rowkey_prepare_tab
      (table_name, where_clause, state, log_date, total_num_records)
   SELECT table_name_, where_clause_, state_add_rowkey_, SYSDATE, t.num_rows
   FROM user_tables t, user_objects o
   WHERE t.table_name = table_name_
   AND t.table_name = o.object_name
   AND o.object_type = 'TABLE'
   AND t.temporary = 'N'
   AND SUBSTR(t.table_name, -4) = '_TAB'
   AND table_name NOT IN
   (SELECT table_name
    FROM user_tab_columns
    WHERE column_name = 'ROWKEY')
   AND table_name NOT IN
   (SELECT table_name
    FROM rowkey_prepare_tab)
   AND table_name NOT IN
   (SELECT queue_table
      FROM user_queue_tables)
   UNION
   SELECT table_name_, where_clause_, state_to_do_, SYSDATE, t.num_rows
   FROM user_tables t, user_objects o
   WHERE t.table_name = table_name_
   AND t.table_name = o.object_name
   AND o.object_type = 'TABLE'
   AND t.temporary = 'N'
   AND SUBSTR(t.table_name, -4) = '_TAB'
   AND table_name IN
   (SELECT table_name
    FROM user_tab_columns
    WHERE column_name = 'ROWKEY'
    AND nullable = 'Y')
   AND table_name NOT IN
   (SELECT table_name
    FROM rowkey_prepare_tab)
   AND table_name NOT IN
   (SELECT queue_table
      FROM user_queue_tables);
END Feed_Worktable;

PROCEDURE Rerun_Loaded_Tables
IS
BEGIN
   UPDATE rowkey_prepare_tab SET state = state_to_do_, log_date = SYSDATE WHERE state = state_loaded_;
END Rerun_Loaded_Tables;

PROCEDURE Rerun_Ignored_Tables
IS
BEGIN
   UPDATE rowkey_prepare_tab SET state = state_to_do_, log_date = SYSDATE WHERE state = state_ignored_;
END Rerun_Ignored_Tables;

PROCEDURE Count_Records (
   table_name_ VARCHAR2 DEFAULT NULL )
IS
   total_count_   NUMBER;
   with_count_    NUMBER;
   without_count_ NUMBER;
   CURSOR get_tables IS
      SELECT table_name
      FROM rowkey_prepare_tab
      WHERE table_name = NVL(table_name_, table_name);
BEGIN
   FOR rec IN get_tables LOOP
      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM '||rec.table_name INTO total_count_;
      BEGIN
         -- row count with rowkey is not null is fetched to improve the performance
         EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM '||rec.table_name||' WHERE rowkey IS NOT NULL' INTO with_count_;
         without_count_:= total_count_ - with_count_;
      EXCEPTION
         WHEN OTHERS THEN
            IF (SQLCODE = -00904) THEN  -- we are on apps 75, rowkey column is not added to this table
               without_count_ := total_count_;
            ELSE
               RAISE;
            END IF;
      END;
      UPDATE rowkey_prepare_tab SET total_num_records = total_count_, records_without_rowkey = without_count_ WHERE table_name = rec.table_name;
   END LOOP;
END Count_Records;


PROCEDURE Add_Rowkey
IS
   table_name_ VARCHAR2(30);
   CURSOR get_tables IS
      SELECT table_name
      FROM user_tables
      WHERE table_name NOT IN
      (SELECT table_name
       FROM user_tab_columns
       WHERE column_name = 'ROWKEY')
      AND table_name IN
      (SELECT table_name
       FROM rowkey_prepare_tab
       WHERE state = state_add_rowkey_)
      AND table_name NOT IN
      (SELECT queue_table
       FROM user_queue_tables);
BEGIN
   OPEN get_tables;
   FETCH get_tables INTO table_name_;
   WHILE get_tables%FOUND LOOP
      EXECUTE IMMEDIATE 'ALTER TABLE '||table_name_||' ADD rowkey VARCHAR2(50)';
      EXECUTE IMMEDIATE 'ALTER TABLE '||table_name_||' MODIFY rowkey DEFAULT sys_guid()';
      IF Installation_SYS.Mtrl_View_Log_Exist(table_name_) = FALSE THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||table_name_||' ADD CONSTRAINT ' || SUBSTR(table_name_,1, LENGTH(table_name_)-3)||'RK UNIQUE (rowkey) USING INDEX TABLESPACE &IFSAPP_INDEX';
      END IF;
      UPDATE rowkey_prepare_tab SET log_date = SYSDATE, state = state_to_do_ WHERE table_name = table_name_;
      FETCH get_tables INTO table_name_;
   END LOOP;
   CLOSE get_tables;
END Add_Rowkey;

PROCEDURE Rowkey_Update (
   chunk_size_       IN NUMBER,
   parallel_         IN VARCHAR2,
   exec_time_        IN NUMBER,
   alter_tables_     IN VARCHAR2,
   only_prio_tables_ IN VARCHAR2 )
IS
   end_time_     DATE := SYSDATE + (exec_time_ / (60 * 60 * 24));
   processes_    NUMBER;
   version_      VARCHAR2(30);
   ifs_version_  module_tab.version%TYPE;
   table_name_   user_tab_columns.table_name%TYPE;
   trigger_name_ user_triggers.trigger_name%TYPE;
   where_clause_ rowkey_prepare_tab.where_clause%TYPE;
   count_        NUMBER;
   count_done_   NUMBER;
   count_init_   NUMBER;
   tmp_count_    NUMBER;
   stmt_         VARCHAR2(1000);
   schema_       VARCHAR2(128) := USER;
   return_       BOOLEAN;
   first_job_    BOOLEAN := TRUE;
   break_job_    VARCHAR2(128) := break_rowkey_job_;
   CURSOR check_version IS
      SELECT version
      FROM v$instance;
   CURSOR check_ifs_version IS
      SELECT version
      FROM module_tab
      WHERE module = 'FNDBAS';
   CURSOR get_tables IS
      SELECT utc.table_name, NVL(rk.where_clause, true_statement_)
      FROM user_tab_columns utc, user_tables ut, rowkey_prepare_tab rk
      WHERE (state = state_to_do_
      OR alter_tables_ = 'Y' AND state = state_loaded_)
      AND rk.table_name = utc.table_name
      AND column_name = 'ROWKEY'
      AND utc.table_name = ut.table_name
      AND SUBSTR(utc.table_name, -4) = '_TAB'
      AND utc.table_name NOT IN
      (SELECT queue_table
         FROM user_queue_tables)
      UNION ALL
      SELECT utc.table_name, true_statement_
      FROM user_tab_columns utc, user_tables ut
      WHERE only_prio_tables_ = 'N'
      AND column_name = 'ROWKEY'
      AND nullable = 'Y'
      AND utc.table_name = ut.table_name
      AND SUBSTR(utc.table_name, -4) = '_TAB'
      AND utc.table_name NOT IN
      (SELECT table_name
       FROM rowkey_prepare_tab
       WHERE (state = state_to_do_
       OR alter_tables_ = 'Y' AND state = state_loaded_))
      AND utc.table_name NOT IN
      (SELECT queue_table
         FROM user_queue_tables);
   FUNCTION Check_For_Triggers___ (
      table_name_ IN VARCHAR2 ) RETURN VARCHAR2 
   IS
      trigger_name_ user_triggers.trigger_name%TYPE;
      CURSOR check_table IS
         SELECT trigger_name
         FROM user_triggers
         WHERE triggering_event LIKE '%UPDATE%'
         AND (description LIKE '%UPDATE ON%'
         OR   description LIKE '%ROWKEY%')
         AND status = 'ENABLED'
         AND table_name = table_name_;
   BEGIN
      OPEN check_table;
      FETCH check_table INTO trigger_name_;
      IF check_table%FOUND THEN
         CLOSE check_table;
         RETURN trigger_name_;
      ELSE
         CLOSE check_table;
         RETURN NULL;
      END IF;
   END Check_For_Triggers___;
BEGIN
   IF UPPER(SUBSTR(parallel_, 1, 1)) = 'Y' THEN
      OPEN check_ifs_version;
      FETCH check_ifs_version INTO ifs_version_;
      CLOSE check_ifs_version;
      IF ifs_version_ < '5' THEN
         processes_ := 1;
      ELSE
         processes_ := GREATEST(LEAST(CEIL(TO_NUMBER(Get_Init_Ora_Parameter___('job_queue_processes')) / 2), 10), 1);
      END IF;
   ELSE
      processes_ := 1;
   END IF;
   OPEN check_version;
   FETCH check_version INTO version_;
   CLOSE check_version;
   OPEN get_tables;
   FETCH get_tables INTO table_name_, where_clause_;
   IF get_tables%FOUND = FALSE THEN
      Log_Status_Info___('No rowkeys to enable were found', 'INFO');
   END IF;
   WHILE get_tables%FOUND
   AND SYSDATE <= end_time_ LOOP
      IF table_name_ IN ('MODULE_TAB', 'MODULE_DEPENDENCY_TAB', 'MODULE_DB_PATCH_TAB', 'BATCH_SYS_TAB', 'DATABASE_SYS_ORACLE_INDEX_TAB',
                         'DICTIONARY_SYS_TAB', 'DICTIONARY_SYS_VIEW_TAB', 'DICTIONARY_SYS_VIEW_COLUMN_TAB', 'DICTIONARY_SYS_PACKAGE_TAB',
                         'DICTIONARY_SYS_METHOD_TAB', 'DICTIONARY_SYS_DOMAIN_TAB', 'DICTIONARY_SYS_STATE_TAB', 'DICTIONARY_SYS_STATE_EVENT_TAB',
                         'DICTIONARY_SYS_STATE_TRANS_TAB', 'DICTIONARY_SYS_STATE_MACH_TAB', 'SECURITY_SYS_TAB', 'SECURITY_SYS_PRIVS_TAB',
                         'REFERENCE_SYS_TAB', 'TRANSACTION_SYS_LOCAL_TAB', 'TRANSACTION_SYS_STATUS_TAB', 'OBJECT_CONNECTION_SYS_TAB',
                         'LANGUAGE_SYS_TAB', 'LANGUAGE_SYS_IMP_TAB', 'PERFORMANCE_ANALYZE_SOURCE_TAB', 'FND_USER_ROLE_RUNTIME_TAB',
                         'FUNC_AREA_CONFLICT_CACHE_TAB', 'FUNC_AREA_SEC_CACHE_TAB', 'PLSQLAP_ENVIRONMENT_TAB', 'SOD_CACHE_TAB',
                         'USER_PROFILE_SYS_TAB', 'USER_PROFILE_ENTRY_SYS_TAB',
                         'FND_USER_TAB', 'FND_USER_PROPERTY_TAB', 'FND_USER_ROLE_TAB', 'FNDRR_CLIENT_PROFILE_TAB', 'FNDRR_CLIENT_PROFILE_VALUE_TAB', 'FNDRR_USER_CLIENT_PROFILE_TAB',
                         'HISTORY_LOG_TAB', 'HISTORY_LOG_ATTRIBUTE_TAB', 'PART_COST_BUCKET_HISTORY_TAB', 'STANDARD_COST_BUCKET_TAB', 'SERVER_LOG_TAB') THEN
         Log_Status_Info___('Updating rowkey for table '||table_name_||' ignored. This table is not valid for rowkey.', 'INFO');
         UPDATE rowkey_prepare_tab SET log_date = SYSDATE, state = state_ignored_, comments = 'This table is not valid for rowkey.' WHERE table_name = table_name_;
      ELSE
         trigger_name_ := Check_For_Triggers___(table_name_);
         IF trigger_name_ IS NOT NULL THEN
            Log_Status_Info___('Updating rowkey for table '||table_name_||' ignored. The active trigger '||trigger_name_||' is blocking this table from being loaded.', 'INFO');
            UPDATE rowkey_prepare_tab SET log_date = SYSDATE, state = state_ignored_, comments = 'The active trigger '||trigger_name_||' is blocking this table from being loaded.' WHERE table_name = table_name_;
         ELSE
            IF where_clause_ LIKE '%;%' OR where_clause_ LIKE '%/%' THEN
               Log_Status_Info___('Invalid where clause for '||table_name_||'. All records will be updated.', 'WARNING');
               where_clause_ := true_statement_;
            END IF;
            EXECUTE IMMEDIATE 'SELECT count(*) FROM ' || table_name_ || ' WHERE rowkey IS NULL ' INTO count_;
            count_init_ := count_;
            IF count_ > 0 THEN
               IF where_clause_ = true_statement_ THEN
                  Log_Status_Info___('Updating rowkey for table '||table_name_||'. '||count_init_|| ' records in total are missing a rowkey.', 'INFO');
               ELSE
                  Log_Status_Info___('Updating rowkey for table '||table_name_||' where '||where_clause_||'. '||count_init_|| ' records in total are missing a rowkey.', 'INFO');
               END IF;
               UPDATE rowkey_prepare_tab SET log_date = SYSDATE, comments = count_init_|| ' records in total are missing a rowkey.', records_without_rowkey = count_init_ WHERE table_name = table_name_;
            ELSE
               Log_Status_Info___('All records in table '||table_name_||' are already updated with a rowkey', 'INFO');
               IF UPPER(alter_tables_) = 'Y' THEN
                  Log_Status_Info___('Enabling rowkey for table '||table_name_, 'INFO');
                  stmt_ := 'ALTER TABLE '||table_name_||' MODIFY ROWKEY DEFAULT ';
                  IF version_ > '12.' THEN -- Oracle12 and above
                     stmt_ := stmt_ || ' ON NULL ';
                  END IF;
                  stmt_ := stmt_ || ' sys_guid() NOT NULL ';
                  EXECUTE IMMEDIATE stmt_;
                  UPDATE rowkey_prepare_tab SET log_date = SYSDATE, state = state_finished_, comments = 'Rowkey enabled' WHERE table_name = table_name_;
               ELSE
                  UPDATE rowkey_prepare_tab SET log_date = SYSDATE, state = state_loaded_, comments = 'All records are already updated with a rowkey', records_without_rowkey = 0  WHERE table_name = table_name_;
               END IF;
            END IF;
            WHILE count_ > 0
            AND SYSDATE <= end_time_ LOOP
   $IF NOT Dbms_Db_Version.ver_le_10 $THEN -- Oracle 11 and above
               IF processes_ > 1 THEN
                  IF first_job_ THEN
                     first_job_ := FALSE;
                     BEGIN
                        DBMS_Scheduler.Drop_job(break_job_);
                     EXCEPTION
                        WHEN OTHERS THEN
                           NULL;
                     END;
                     DBMS_Scheduler.Create_Job (
                     job_name           =>  break_job_,
                     job_type           => 'STORED_PROCEDURE',
                     job_action         => 'ROWKEY_PREPARE_API.ROWKEY_STOP_UPDATE_',
                     start_date         =>  end_time_,
                     auto_drop          =>  TRUE,
                     comments           => 'Breaks a running Rowkey_Update_ process after the time slot is ended');
                     DBMS_Scheduler.Set_Attribute(
                     name               =>  break_job_,
                     attribute          => 'job_priority',
                     value              =>  2);
                     DBMS_Scheduler.Enable(break_job_);
                     COMMIT;
                  END IF;
                  return_ := Update_Rowkey_Parallel___(table_name_, where_clause_, chunk_size_, processes_, count_init_);
               ELSE
                  return_ := Update_Rowkey_Seriel___(table_name_, where_clause_, chunk_size_, count_init_);
               END IF;
   $ELSE
               return_ := Update_Rowkey_Seriel___(table_name_, where_clause_, chunk_size_, count_init_);
   $END
               IF return_ THEN
                  EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || table_name_ || ' WHERE rowkey IS NULL ' INTO count_;
                  IF (count_ < 1) THEN
                     Log_Status_Info___('All records in table '||table_name_||' are updated with a rowkey', 'INFO');
                     IF UPPER(alter_tables_) = 'Y' THEN
                        Log_Status_Info___('Enabling rowkey for table '||table_name_, 'INFO');
                        stmt_ := 'ALTER TABLE '||table_name_||' MODIFY ROWKEY DEFAULT ';
                        IF version_ > '12.' THEN -- Oracle12 and above
                           stmt_ := stmt_ || ' ON NULL ';
                        END IF;
                        stmt_ := stmt_ || ' sys_guid() NOT NULL ';
                        EXECUTE IMMEDIATE stmt_;
                        UPDATE rowkey_prepare_tab SET log_date = SYSDATE, state = state_finished_, comments = 'Rowkey enabled'  WHERE table_name = table_name_;
                     ELSE
                        UPDATE rowkey_prepare_tab SET log_date = SYSDATE, state = state_loaded_, comments = 'All records are updated with a rowkey', records_without_rowkey = 0 WHERE table_name = table_name_;
                     END IF;
                  ELSE
                     tmp_count_ := count_;
                     count_done_ := count_init_-count_;
                     EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || table_name_ || ' WHERE rowkey IS NULL AND '||where_clause_ INTO count_;
                     IF count_ < 1 THEN
                        Log_Status_Info___(count_done_||' prioitized records in table '||table_name_||' are updated with a rowkey but '||count_||' records remains', 'INFO');
                        UPDATE rowkey_prepare_tab SET log_date = SYSDATE, state = state_loaded_, comments = 'All prioitized records are updated with a rowkey', records_without_rowkey = tmp_count_ WHERE table_name = table_name_;
                     END IF;
                  END IF;
               ELSE
                  count_ := 0;
               END IF;
            END LOOP;
         END IF;
      END IF;
      COMMIT;
      FETCH get_tables INTO table_name_, where_clause_;
   END LOOP;
   CLOSE get_tables;
   IF processes_ > 1 THEN
      BEGIN
         DBMS_Scheduler.Drop_job(break_job_);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END IF;
   IF UPPER(alter_tables_) = 'Y' THEN
      EXECUTE IMMEDIATE 'BEGIN Dbms_Utility.Compile_Schema(:schema_, FALSE, TRUE); END;' USING schema_;
   END IF;
END Rowkey_Update;

PROCEDURE Rowkey_Update (
   attr_  IN VARCHAR2 )
IS
   chunk_size_       NUMBER;
   parallel_         VARCHAR2(1);
   exec_time_        NUMBER;
   alter_tables_     VARCHAR2(1);
   only_prio_tables_ VARCHAR2(1);
BEGIN
   chunk_size_       := TO_NUMBER(Client_SYS.Get_Item_Value('CHUNK_SIZE', attr_));
   parallel_         := NVL(UPPER(SUBSTR(Client_SYS.Get_Item_Value('PARALLEL_LEVEL', attr_), 1, 1)), 'Y');
   exec_time_        := TO_NUMBER(Client_SYS.Get_Item_Value('EXEC_TIME', attr_));
   alter_tables_     := NVL(UPPER(SUBSTR(Client_SYS.Get_Item_Value('ALTER_TABLES', attr_), 1, 1)), 'N');
   only_prio_tables_ := NVL(UPPER(SUBSTR(Client_SYS.Get_Item_Value('ONLY_PRIO_TABLES', attr_), 1, 1)), 'Y');
   Rowkey_Update(chunk_size_, parallel_, exec_time_, alter_tables_, only_prio_tables_);
END Rowkey_Update;


END Rowkey_Prepare_API;
/

SHOW ERROR

PROMPT Register Batch Schedule Method "Rowkey_Prepare_API.Rowkey_Update"
DECLARE
   schedule_method_id_ NUMBER          := NULL;
   seq_no_             NUMBER          := NULL;
   info_msg_           VARCHAR2(32000) := NULL;
BEGIN
-- Construct Main Message
   info_msg_    := Message_SYS.Construct('');
   Message_SYS.Add_Attribute(info_msg_, 'METHOD_NAME', 'ROWKEY_PREPARE_API.ROWKEY_UPDATE');
   Message_SYS.Add_Attribute(info_msg_, 'DESCRIPTION', 'Pre update of rowkey columns');
   Message_SYS.Add_Attribute(info_msg_, 'MODULE', 'FNDBAS');
   Message_SYS.Add_Attribute(info_msg_, 'SINGLE_EXECUTION_DB', 'FALSE');
   Message_SYS.Add_Attribute(info_msg_, 'ARGUMENT_TYPE_DB', 'ATTRIBUTE');
-- Register Batch Schedule Method
   Batch_SYS.Register_Batch_Schedule_Method(schedule_method_id_, info_msg_);
-- Adding parameters
   Batch_SYS.Register_Schedule_Method_Param(seq_no_, schedule_method_id_, 'CHUNK_SIZE', '','TRUE', '100000');
   Batch_SYS.Register_Schedule_Method_Param(seq_no_, schedule_method_id_, 'PARALLEL', '','TRUE', '''Y''');
   Batch_SYS.Register_Schedule_Method_Param(seq_no_, schedule_method_id_, 'EXEC_TIME', '','TRUE', '900');
   Batch_SYS.Register_Schedule_Method_Param(seq_no_, schedule_method_id_, 'ALTER_TABLES', '','TRUE', '''N''');
   Batch_SYS.Register_Schedule_Method_Param(seq_no_, schedule_method_id_, 'ONLY_PRIO_TABLES', '','TRUE', '''Y''');
END;
/

PROMPT Prefill Prioritized Tables

DECLARE
  CURSOR get_column(table_name_ IN VARCHAR2, column_name_ IN VARCHAR2) IS
    SELECT column_name
    FROM user_tab_columns
    WHERE table_name = table_name_
    AND column_name = column_name_;
  
  column_name_ user_tab_columns.COLUMN_NAME%TYPE;
BEGIN
	Rowkey_Prepare_API.Feed_Worktable('MPCCOM_ACCOUNTING_TAB', 'STATUS_CODE = ''3''');
	Rowkey_Prepare_API.Feed_Worktable('GEN_LED_VOUCHER_ROW_TAB', 'year_period_key < (select to_number(to_char(sysdate-60,''YYYYMM'')) from dual)');
	Rowkey_Prepare_API.Feed_Worktable('INVENTORY_PART_PERIOD_HIST_TAB', 'stat_year_no || ''-'' || stat_period_no < TO_CHAR(SYSDATE-365, ''YYYY-MM'')');
	Rowkey_Prepare_API.Feed_Worktable('CUSTOMER_ORDER_LINE_HIST_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('INVENTORY_TRANSACTION_COST_TAB', 'TRANSACTION_ID IN (select TRANSACTION_ID from INVENTORY_TRANSACTION_HIST_TAB where PARTSTAT_FLAG=''Y'' AND VALUESTAT_FLAG=''Y''AND DATE_CREATED < SYSDATE - 100)');
	Rowkey_Prepare_API.Feed_Worktable('INVENTORY_TRANSACTION_HIST_TAB', 'PARTSTAT_FLAG=''Y'' AND VALUESTAT_FLAG=''Y''AND DATE_CREATED < SYSDATE - 100');
	Rowkey_Prepare_API.Feed_Worktable('INV_ACCOUNTING_ROW_TAB', '(company, invoice_id) in (select company, invoice_id from invoice_tab where rowstate in (''Posted'', ''PostedAuth'', ''PaidPosted'', ''PartlyPaidPosted'', ''Cancelled''))');
	Rowkey_Prepare_API.Feed_Worktable('PURCHASE_ORDER_LINE_HIST_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('INTERNAL_VOUCHER_ROW_TAB', 'year_period_key < (select to_number(to_char(sysdate-60,''YYYYMM'')) from dual)');
	Rowkey_Prepare_API.Feed_Worktable('SUPP_INV_HISTORY_LOG_TAB', '(company, invoice_id) in (select company, invoice_id from invoice_tab where rowstate in (''Posted'', ''PostedAuth'', ''PaidPosted'', ''PartlyPaidPosted'', ''Cancelled''))');
	Rowkey_Prepare_API.Feed_Worktable('CUSTOMER_ORDER_HISTORY_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('PART_COST_PRICE_ELASTICITY_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('PART_COST_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('PART_SERIAL_HISTORY_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('INVOICE_ITEM_TAB', '(company, invoice_id) in (select company, invoice_id from invoice_tab where rowstate in (''Posted'', ''PostedAuth'', ''PaidPosted'', ''PartlyPaidPosted'', ''Cancelled''))');
	Rowkey_Prepare_API.Feed_Worktable('GEN_LED_PROJ_VOUCHER_ROW_TAB', 'year_period_key < (select to_number(to_char(sysdate-60,''YYYYMM'')) from dual)');
	Rowkey_Prepare_API.Feed_Worktable('PART_COST_HISTORY_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('EQUIPMENT_STRUCTURE_COST_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('PROJECT_CONNECTION_HISTORY_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('GEN_LED_ARCH_VOUCHER_ROW_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('CONFIG_CHAR_PRICE_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('PROJ_CONN_DETAILS_HISTORY_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('MANUF_PART_COST_DISTRIB_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('TAX_LEDGER_ITEM_TAB', 'year_period_key < (select to_number(to_char(sysdate-60,''YYYYMM'')) from dual)');
	Rowkey_Prepare_API.Feed_Worktable('DOCUMENT_ISSUE_HISTORY_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('TAX_ITEM_TAB', '(company, invoice_id) in (select company, invoice_id from invoice_tab where rowstate in (''Posted'', ''PostedAuth'', ''PaidPosted'', ''PartlyPaidPosted'', ''Cancelled''))');
	Rowkey_Prepare_API.Feed_Worktable('LOT_BATCH_HISTORY_TAB', '');

	OPEN get_column('PROJECT_SNAPSHOT_DATA_TAB', 'PROJECT_ID');
	FETCH get_column INTO column_name_;
	IF get_column%FOUND THEN
		Rowkey_Prepare_API.Feed_Worktable('PROJECT_SNAPSHOT_DATA_TAB', 'exists (select 1 from project_tab where PROJECT_SNAPSHOT_DATA_TAB.project_id = project_tab.project_id and project_tab.rowstate = ''Closed'')');

	ELSE
		Rowkey_Prepare_API.Feed_Worktable('PROJECT_SNAPSHOT_DATA_TAB', 'activity_seq in (select activity_seq from activity_tab where project_id in (select project_id from project_tab where rowstate = ''Closed''))');
	END IF;
	CLOSE get_column;

	Rowkey_Prepare_API.Feed_Worktable('WORK_ORDER_PLANNING_TAB', 'wo_no in (select wo_no from historical_work_order_tab)');
	Rowkey_Prepare_API.Feed_Worktable('PURCHASE_ORDER_RESP_LINE_TAB', '(order_no, line_no, release_no) in (select order_no, line_no, release_no from PURCHASE_ORDER_LINE_TAB t where t.rowstate =''Cancelled'')');
	Rowkey_Prepare_API.Feed_Worktable('INVENT_TRANS_INTERCONNECT_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('IN_MESSAGE_LINE_TAB', 'message_id in (select message_id from in_message_tab where rowstate in (''Acknowledged'', ''Failed''))');
	Rowkey_Prepare_API.Feed_Worktable('INVENTORY_VALUE_PART_TAB', 'stat_year_no || ''-'' || stat_period_no < TO_CHAR(SYSDATE-365, ''YYYY-MM'')');
	Rowkey_Prepare_API.Feed_Worktable('PRE_INVENT_TRANS_AVG_COST_TAB', 'TRANSACTION_ID IN (select TRANSACTION_ID from INVENTORY_TRANSACTION_HIST_TAB where PARTSTAT_FLAG=''Y'' AND VALUESTAT_FLAG=''Y''AND DATE_CREATED < SYSDATE - 100)');
	Rowkey_Prepare_API.Feed_Worktable('EXT_FILE_TRANS_TAB', 'load_file_id in (select load_file_id from ext_file_log_tab where state IN (''4'', ''7''))');
	Rowkey_Prepare_API.Feed_Worktable('PURCHASE_ORDER_HIST_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('PURCHASE_ORDER_LINE_TAB', 'ROWSTATE = ''Cancelled''');
	Rowkey_Prepare_API.Feed_Worktable('PURCH_LINE_REVISION_STATUS_TAB', '(order_no, line_no, release_no) in (select order_no, line_no, release_no from PURCHASE_ORDER_LINE_TAB t where t.rowstate =''Cancelled'')');
	Rowkey_Prepare_API.Feed_Worktable('SHOP_ORDER_COST_BUCKET_TAB', 'order_no in (select order_no from shop_ord_tab where rowstate = ''Closed'')');
	Rowkey_Prepare_API.Feed_Worktable('MATERIAL_HISTORY_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('INVENTORY_PART_CONFIG_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('TAX_PROPOSAL_ITEM_TAB', 'exists (select 1 from tax_proposal_tab b where tax_proposal_item_tab.company = b.company and tax_proposal_item_tab.proposal_id = b.proposal_id and b.rowstate IN (''Reported'', ''ReportedInvalid''))');
	Rowkey_Prepare_API.Feed_Worktable('DOCUMENT_ISSUE_ACCESS_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('CUSTOMER_ORDER_DELIVERY_TAB', '(order_no, line_no, rel_no, line_item_no) in (select order_no, line_no, rel_no, line_item_no FROM customer_order_line_tab c where c.rowstate IN (''Invoiced'', ''Cancelled''))');
	Rowkey_Prepare_API.Feed_Worktable('ACCOUNTING_BALANCE_TAB', 'year_period_key < (select to_number(to_char(sysdate-60,''YYYYMM'')) from dual)');
	Rowkey_Prepare_API.Feed_Worktable('MANUF_STRUCTURE_JOURNAL_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('PURCHASE_QUANTITY_PRICE_TAB', 'rowstate = ''Closed''');
	Rowkey_Prepare_API.Feed_Worktable('PAY_ACCOUNTING_ROW_TAB', 'exists (select 1 from payment_tab b where pay_accounting_row_tab.company = b.company and pay_accounting_row_tab.payment_id = b.payment_id and pay_accounting_row_tab.series_id = b.series_id and b.pay_date < (sysdate-365))');
	Rowkey_Prepare_API.Feed_Worktable('CUST_ORD_INVO_STAT_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('CUSTOMER_ORDER_RESERVATION_TAB', '(order_no, line_no, rel_no, line_item_no) in (select order_no, line_no, rel_no, line_item_no FROM customer_order_line_tab c where c.rowstate IN (''Invoiced'', ''Cancelled''))');
	Rowkey_Prepare_API.Feed_Worktable('OUTSTANDING_SALES_TAB', 'deliv_no in (SELECT deliv_no FROM CUSTOMER_ORDER_DELIVERY_TAB WHERE (order_no, line_no, rel_no, line_item_no) in (select order_no, line_no, rel_no, line_item_no FROM customer_order_line_tab c where c.rowstate IN (''Invoiced'', ''Cancelled'')))');
	Rowkey_Prepare_API.Feed_Worktable('CUST_DELIVERY_INV_REF_TAB', 'deliv_no in (SELECT deliv_no FROM CUSTOMER_ORDER_DELIVERY_TAB WHERE (order_no, line_no, rel_no, line_item_no) in (select order_no, line_no, rel_no, line_item_no FROM customer_order_line_tab c where c.rowstate IN (''Invoiced'', ''Cancelled'')))');
	Rowkey_Prepare_API.Feed_Worktable('CUSTOMER_ORDER_LINE_TAB', 'rowstate IN (''Invoiced'', ''Cancelled'')');
	Rowkey_Prepare_API.Feed_Worktable('CONFIG_SPEC_VALUE_TAB', 'EXISTS (SELECT 1 FROM CONFIGURATION_SPEC_TAB WHERE CONFIGURATION_SPEC_TAB.CONFIGURATION_ID = CONFIG_SPEC_VALUE_TAB.CONFIGURATION_ID AND NVL(COMPLETE_DATE, SYSDATE)  <  SYSDATE-  365)');
	Rowkey_Prepare_API.Feed_Worktable('EQUIPMENT_OBJECT_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('SURVEY_ANSWER_TAB', 'exists (select 1  from survey_tab where survey_answer_tab.survey_id = survey_tab.survey_id and survey_tab.rowstate = ''Closed'')');
	Rowkey_Prepare_API.Feed_Worktable('CUST_SCHED_LINE_TAB', 'exists (select 1 from cust_sched_tab where CUST_SCHED_LINE_TAB.CUSTOMER_NO = cust_sched_tab.CUSTOMER_NO and CUST_SCHED_LINE_TAB.DOC_NO = cust_sched_tab.DOC_NO and CUST_SCHED_LINE_TAB.SHIP_ADDR_NO = cust_sched_tab.SHIP_ADDR_NO and CUST_SCHED_LINE_TAB.CUSTOMER_PART_NO = cust_sched_tab.CUSTOMER_PART_NO and CUST_SCHED_LINE_TAB.SCHEDULE_NO = cust_sched_tab.SCHEDULE_NO and cust_sched_tab.rowstate in (''Cancelled''))');
	Rowkey_Prepare_API.Feed_Worktable('CUSTOMER_ADDRESS_LEADTIME_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('ORDER_QUOTE_LINE_HIST_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('PUR_ORDER_LINE_ADDRESS_TAB', '(order_no, line_no, release_no) in (select order_no, line_no, release_no from PURCHASE_ORDER_LINE_TAB t where t.rowstate =''Cancelled'')');
	Rowkey_Prepare_API.Feed_Worktable('EXT_CUST_SCHED_LINE_TAB', 'rowstate in (''Cancelled'', ''Created'', ''Stopped'')');
	Rowkey_Prepare_API.Feed_Worktable('WORK_ORDER_JOB_TAB', 'wo_no in (select wo_no from historical_work_order_tab)');
	Rowkey_Prepare_API.Feed_Worktable('MAINT_MATERIAL_REQ_LINE_TAB', 'wo_no in (select wo_no from historical_work_order_tab)');
	Rowkey_Prepare_API.Feed_Worktable('INVENT_VALUE_PART_DETAIL_TAB', 'stat_year_no || ''-'' || stat_period_no < TO_CHAR(SYSDATE-365, ''YYYY-MM'')');
	Rowkey_Prepare_API.Feed_Worktable('CODESTRING_COMB_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('FNDCN_ADDRESS_LABEL_TAB', 'application_message_id in (select application_message_id from fndcn_application_message_tab where state = ''Finished'')');
	Rowkey_Prepare_API.Feed_Worktable('DISTRIBUTION_ORDER_HISTORY_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('CUST_SCHED_CHANGE_HIST_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('MATCHING_TRANSACTION_TAB', 'exists (select 1 from payment_tab b where matching_transaction_tab.company = b.company and matching_transaction_tab.payment_id = b.payment_id and matching_transaction_tab.series_id = b.series_id and b.pay_date < (sysdate-365))');
	Rowkey_Prepare_API.Feed_Worktable('ENG_CHAR_SNAPSHOT_TAB', 'exists (select 1 from eng_part_revision_tab where eng_char_snapshot_tab.part_no = eng_part_revision_tab.part_no and eng_part_revision_tab.rowstate = ''Obsolete'')');
	Rowkey_Prepare_API.Feed_Worktable('FNDCN_MESSAGE_BODY_TAB', 'application_message_id in (select application_message_id from fndcn_application_message_tab where state = ''Finished'')');
	Rowkey_Prepare_API.Feed_Worktable('INVENTORY_PART_BARCODE_TAB', '');

	OPEN get_column('OPERATION_HISTORY_TAB', 'TRANSACTION_DATE');
	FETCH get_column INTO column_name_;
	IF get_column%FOUND THEN
		Rowkey_Prepare_API.Feed_Worktable('OPERATION_TRANSACTION_COST_TAB', 'exists (select 1 from operation_history_tab where operation_transaction_cost_tab.transaction_id = operation_history_tab.transaction_id and operation_history_tab.transaction_date < sysdate-365)');
	ELSE
		Rowkey_Prepare_API.Feed_Worktable('OPERATION_TRANSACTION_COST_TAB', 'exists (select 1 from operation_history_tab where operation_transaction_cost_tab.transaction_id = operation_history_tab.transaction_id and operation_history_tab.date_applied < sysdate-365)');
	END IF;
	CLOSE get_column;

	Rowkey_Prepare_API.Feed_Worktable('VOUCHER_ROW_TAB', 'year_period_key < (select to_number(to_char(sysdate-60,''YYYYMM'')) from dual)');
	Rowkey_Prepare_API.Feed_Worktable('FNDCN_APPLICATION_MESSAGE_TAB', 'state = ''Finished''');
	Rowkey_Prepare_API.Feed_Worktable('PAYMENT_TRANSACTION_TAB', 'exists (select 1 from payment_tab b where payment_transaction_tab.company = b.company and payment_transaction_tab.payment_id = b.payment_id and payment_transaction_tab.series_id = b.series_id and b.pay_date < (sysdate-365))');
	Rowkey_Prepare_API.Feed_Worktable('TIME_PERS_DIARY_RESULT_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('WORK_ORDER_BUDGET_TAB', 'wo_no in (select wo_no from historical_work_order_tab)');
	Rowkey_Prepare_API.Feed_Worktable('ENG_PART_STRUCTURE_TAB', 'exists (select 1 from eng_part_revision_tab where eng_part_structure_tab.part_no = eng_part_revision_tab.part_no and eng_part_revision_tab.rowstate = ''Obsolete'')');

	OPEN get_column('OPERATION_HISTORY_TAB', 'TRANSACTION_DATE');
	FETCH get_column INTO column_name_;
	IF get_column%FOUND THEN
		Rowkey_Prepare_API.Feed_Worktable('OPERATION_HISTORY_TAB', 'transaction_date < sysdate-365');
	ELSE
		Rowkey_Prepare_API.Feed_Worktable('OPERATION_HISTORY_TAB', 'date_applied < sysdate-365');
	END IF;
	CLOSE get_column;

	Rowkey_Prepare_API.Feed_Worktable('RESULT_CELL_TAB', 'super_path_id IN  (SELECT g.super_path_id FROM result_grouping_path_tab g, finrep_archive_tab f WHERE  g.company = f.company AND g.report_id = f.report_id AND    g.instance_id = f.instance_id AND f.status = 1 AND  f.finish_date < (sysdate-30))');
	Rowkey_Prepare_API.Feed_Worktable('PROJECT_CONNECTION_TAB', 'activity_seq in (select activity_seq from activity_tab where project_id in (select project_id from project_tab where rowstate = ''Closed''))');
	Rowkey_Prepare_API.Feed_Worktable('CONSOLIDATED_ORDERS_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('CUST_ORDER_INVOICE_HIST_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('GEN_LED_VOUCHER_TAB', 'accounting_year < TO_CHAR(SYSDATE-365, ''YYYY'')');
	Rowkey_Prepare_API.Feed_Worktable('CUST_ORD_BACK_STAT_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('CUST_ORD_PRICE_HIST_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('SHOP_MATERIAL_ALLOC_GUIDE_TAB', 'order_no in (select order_no from shop_ord_tab where rowstate = ''Closed'')');
	Rowkey_Prepare_API.Feed_Worktable('DEPR_PROPOSAL_LOG_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('CUSTOMER_ORDER_PICK_LIST_TAB', 'picking_confirmed = ''PICKED''');

	OPEN get_column('PROJECT_CONNECTION_DETAILS_TAB', 'PROJECT_ID');
	FETCH get_column INTO column_name_;
	IF get_column%FOUND THEN
		Rowkey_Prepare_API.Feed_Worktable('PROJECT_CONNECTION_DETAILS_TAB', 'exists (select 1 from project_tab where PROJECT_CONNECTION_DETAILS_TAB.project_id = project_tab.project_id and project_tab.rowstate = ''Closed'')');
	ELSE
		Rowkey_Prepare_API.Feed_Worktable('PROJECT_CONNECTION_DETAILS_TAB', 'activity_seq in (select activity_seq from activity_tab where project_id in (select project_id from project_tab where rowstate = ''Closed''))');
	END IF;
	CLOSE get_column;

	Rowkey_Prepare_API.Feed_Worktable('SHOP_MATERIAL_ALLOC_TAB', 'order_no in (select order_no from shop_ord_tab where rowstate = ''Closed'')');
	Rowkey_Prepare_API.Feed_Worktable('ALLOWED_TO_VIEW_INVOICE_TAB', '(company, invoice_id) in (select company, invoice_id from invoice_tab where rowstate in (''Posted'', ''PostedAuth'', ''PaidPosted'', ''PartlyPaidPosted'', ''Cancelled''))');
	Rowkey_Prepare_API.Feed_Worktable('LEDGER_ITEM_TAB', '((rowstate = ''Paid'' and fully_paid_voucher_date < (sysdate-365)) OR rowstate = ''Cancelled'')');
	Rowkey_Prepare_API.Feed_Worktable('FA_ACCOUNTING_TRANSACTION_TAB', 'accounting_year < TO_CHAR(SYSDATE-365, ''YYYY'')');
	Rowkey_Prepare_API.Feed_Worktable('CONFIGURATION_SPEC_TAB', 'NVL(COMPLETE_DATE, SYSDATE) < SYSDATE - 365');
	Rowkey_Prepare_API.Feed_Worktable('WORK_ORDER_JOURNAL_TAB', 'wo_no in (select wo_no from historical_work_order_tab)');
	Rowkey_Prepare_API.Feed_Worktable('CUSTOMER_ORDER_CHARGE_TAB', '(order_no, line_no, rel_no, line_item_no) in (select order_no, line_no, rel_no, line_item_no FROM customer_order_line_tab c where c.rowstate IN (''Invoiced'', ''Cancelled''))');
	Rowkey_Prepare_API.Feed_Worktable('ENG_PART_REV_JOURNAL_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('ACTIVITY_HISTORY_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('PROJECT_PRODUCT_JOURNAL_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('CUST_INVOICE_ITEM_DISCOUNT_TAB', '(company, invoice_id) in (select company, invoice_id from invoice_tab where rowstate in (''Posted'', ''PostedAuth'', ''PaidPosted'', ''PartlyPaidPosted'', ''Cancelled''))');
	Rowkey_Prepare_API.Feed_Worktable('FA_OBJECT_TRANSACTION_TAB', 'fa_year < TO_CHAR(SYSDATE-365, ''YYYY'')');
	Rowkey_Prepare_API.Feed_Worktable('CUST_ORDER_LINE_DISCOUNT_TAB', '(order_no, line_no, rel_no, line_item_no) in (select order_no, line_no, rel_no, line_item_no FROM customer_order_line_tab c where c.rowstate IN (''Invoiced'', ''Cancelled''))');
	Rowkey_Prepare_API.Feed_Worktable('TIME_PERS_DIARY_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('SHOP_MATERIAL_ASSIGN_TAB', 'order_no in (select order_no from shop_ord_tab where rowstate = ''Closed'')');
	Rowkey_Prepare_API.Feed_Worktable('DEPR_PROPOSAL_HISTORY_TAB', 'year < TO_CHAR(SYSDATE-365, ''YYYY'')');
	Rowkey_Prepare_API.Feed_Worktable('PROJECT_SNAPSHOT_DETAIL_TAB', 'exists (select 1 from project_tab where PROJECT_SNAPSHOT_DETAIL_TAB.project_id = project_tab.project_id and project_tab.rowstate = ''Closed'')');
	Rowkey_Prepare_API.Feed_Worktable('TIME_PERS_DIARY_CLOCKING_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('MANUF_STRUCT_WORK_GUIDE_TAB', 'exists (select 1 from manuf_structure_tab where MANUF_STRUCT_WORK_GUIDE_TAB.PART_NO = manuf_structure_tab.PART_NO and MANUF_STRUCT_WORK_GUIDE_TAB.CONTRACT = manuf_structure_tab.CONTRACT and MANUF_STRUCT_WORK_GUIDE_TAB.ENG_CHG_LEVEL = manuf_structure_tab.ENG_CHG_LEVEL and MANUF_STRUCT_WORK_GUIDE_TAB.ALTERNATIVE_NO = manuf_structure_tab.ALTERNATIVE_NO and MANUF_STRUCT_WORK_GUIDE_TAB.BOM_TYPE = manuf_structure_tab.BOM_TYPE and MANUF_STRUCT_WORK_GUIDE_TAB.LINE_ITEM_NO = manuf_structure_tab.LINE_ITEM_NO and manuf_structure_tab .eff_phase_out_date < sysdate-365)');
	Rowkey_Prepare_API.Feed_Worktable('OPERATION_STATISTIC_TAB', 'order_no in (select order_no from shop_ord_tab where rowstate = ''Closed'')');
	Rowkey_Prepare_API.Feed_Worktable('OUT_MESSAGE_LINE_TAB', 'exists (select 1 from out_message_tab where out_message_line_tab.message_id = out_message_tab.message_id and out_message_tab.rowstate in (''Accepted'', ''Failed'', ''Rejected''))');
	Rowkey_Prepare_API.Feed_Worktable('SHOP_MATERIAL_PICK_LINE_TAB', 'order_no in (select order_no from shop_ord_tab where rowstate = ''Closed'')');
	Rowkey_Prepare_API.Feed_Worktable('FNDCN_MSG_ARCHIVE_BODY_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('PROJECT_PERS_DIARY_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('FNDCN_MSG_ARCHIVE_ADDR_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('FNDCN_MSG_ARCHIVE_SEARCH_TAB', '');
	Rowkey_Prepare_API.Feed_Worktable('PROJECT_RESOURCE_SPREAD_TAB', 'exists (select 1 from project_tab where PROJECT_RESOURCE_SPREAD_TAB.project_id = project_tab.project_id and project_tab.rowstate = ''Closed'')');

	OPEN get_column('PROJECT_CONNECTION_REVENUE_TAB', 'PROJECT_ID');
	FETCH get_column INTO column_name_;
	IF get_column%FOUND THEN
		Rowkey_Prepare_API.Feed_Worktable('PROJECT_CONNECTION_REVENUE_TAB', 'exists (select 1 from project_tab where PROJECT_CONNECTION_REVENUE_TAB.project_id = project_tab.project_id and project_tab.rowstate = ''Closed'')');
	ELSE
		Rowkey_Prepare_API.Feed_Worktable('PROJECT_CONNECTION_REVENUE_TAB', 'exists (select 1 from activity_tab where project_connection_revenue_tab.activity_seq = activity_tab.activity_seq and project_id in (select project_id from project_tab where rowstate = ''Closed''))');
	END IF;
	CLOSE get_column;

	Rowkey_Prepare_API.Feed_Worktable('BASE_PART_OPTION_VALUE_TAB', 'exists (select 1 from config_part_spec_rev_tab where BASE_PART_OPTION_VALUE_TAB.PART_NO = config_part_spec_rev_tab.PART_NO and BASE_PART_OPTION_VALUE_TAB.SPEC_REVISION_NO = config_part_spec_rev_tab.SPEC_REVISION_NO and config_part_spec_rev_tab.rowstate = ''Obsolete'' or config_part_spec_rev_tab.phase_out_date < sysdate-365)');
	Rowkey_Prepare_API.Feed_Worktable('TIMREP_TRANSACTION_TAB', '');
END;
/

BEGIN
   Rowkey_Prepare_API.Count_Records;
END;
/

COMMIT;

