-----------------------------------------------------------------------------
--
--  Logical unit: IalObject
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990301  MANY  Project Invader for IAL (ToDo #3177).
--  990322  MANY  Implemented partial replication (ToDo #3222)
--  990413  TOWR  Removed call Check_Ial___ from Enumerate(Bug #3264)
--  000906  ROOD  Replaced drop and recreation of table with truncate and
--                insert into in method Do_Replication__ (Bug#17266).
--  010128  MANY  Reimplemented drop and recreation to avoid possible rollback problems
--                Solved the initial problem with Exception handling (Bug#17266).
--  010924  ROOD  Changes in Delete__ to drop cache table (Bug#24597).
--  020626  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030616  ROOD  Modified check for replication in Do_Replication__ (Bug#37923).
--  031015  ROOD  Added grant on view to FND_LANGUAGE_USER in Enable.
--                Removed unused implementation methods and variables.
--  031103  ROOD  Handled single executions by using Batch_SYS.Get_Next_Exec_Time__
--                instead of Batch_SYS.Update_Exec_Time__ (Bug#39757).
--  040331  HAAR  Unicode bulk changes, replaced Dbms_Sql with Execute Immediate (F1PR408B).
--  040621  NIPE  Remove "drop ial view" command from the Disable method (Bug#45552).
--  050329  NiWi  Modified Do_Replication__.(Bug#49197)
--  050404  JORA  Added assertion for dynamic SQL.  (F1PR481)
--  050419  UTGULK  Added columns where_clause,description. Modified update__ to use where_clause.(F1PR488)
--  050503  HAAR  Changed FND_Language_User to IFSSYS in method Enable (F1PR489).
--  050609  ASWILK  Changed the partial replication where clause to objdate >=
--                  Remove duplicate rows from IAL table before inserting new values.(Bug#48682/49376)
--  050609  ASWILK  Check whether the source table exists before dropping the IAL table.(Bug#48788).
--  050815  HAAR  Changed granting from FND_LANGUAGE_USER to IFSSYS (F1PR489).
--  060105  UTGULK Annotated Sql injection.
--  070507  NiWi  Modified Do_Replication__.(Bug#65170)
--  080805  DuWi  Modified Update___to remove next execution schedule for single time replication(Bug#75172).
--  090812  DuWi  Add procedure Check_Ial_Table___ to be used in IAL creation(Bug#85116)
--  091026  NABA  Made the replication more fault tolerant (Bug#86669)
--  100312  NABA Changed the mechanism of Full Replication (Bug#89373)
--  100608  ChMu Changed out_ in Get_Details to CLOB (Bug#91157)
--  100824  NaBa Changes applied to support system parameter IAL_CREATE_EMPTY_TAB
--                 for creating empty table during replication (Bug#92495) 
--  111128  MaBo Removed storage parameters, they are not used anymore when creating tables
--  120112  DuWi Added column failed_executions and Reset_Error_Exec to automate the error replication (RDTERUNTIME-1978).
--  121217  NaBa Modified Deploy_IAL to create PK index (Bug#107063)
--  130426  AsWi Changed Do_Replication__, Post_Replication to stop proceeding if a replication is already in progress (Bug#109731)
--  140129  AsiWLK   Merged LCS-111925
--  140324  NaBa Changed full replication to perform delete/insert instead of drop/recreate (TEREPORT-1080)
--  170103  ShFrlk STRBI-1261, Create BI related views in the IAL schema.
--  171030  MaBa Add check if an IAL exists when calling "Ial_Object_API.Post_Replication" or "Ial_Object_API.Do_Replication".
--  210120  subblk  BR20R1-710, Added Update_Fields method.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Ial___
IS
   info_owner_ VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
BEGIN
   IF (info_owner_ <> '*' AND info_owner_ IS NOT NULL) THEN
      NULL; -- AOK
   ELSE
      Error_SYS.Appl_General(lu_name_, 'NOIALOWNER: Information Access Layer is not enabled');
   END IF;
END Check_Ial___;


PROCEDURE Slave_Exec_Ddl_Statement___ (
   stmt_        IN VARCHAR2 )
IS
   info_owner_ VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
BEGIN
   Check_Ial___;
   -- Call slave method
   Assert_SYS.Assert_Is_User(info_owner_);
   @ApproveDynamicStatement(2006-01-05,utgulk)
   EXECUTE IMMEDIATE 'BEGIN '||info_owner_||'.IAL_Object_Slave_API.Exec_Ddl_Statement(:stmt_); END;' USING stmt_;
   EXCEPTION
      WHEN OTHERS THEN
         Error_SYS.Appl_General(lu_name_, 'ERRDIMSQL: Error when executing statement. Reported error is ":P1"', SQLERRM);
END Slave_Exec_Ddl_Statement___;


FUNCTION Get_Ial_Primary_Key___ (
   name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   columns_          VARCHAR2(32000);
   primary_key_      VARCHAR2(30) := name_ || '_PK';
   info_owner_       VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');

   CURSOR get_pk IS
      SELECT c.column_name
      FROM   dba_indexes i, dba_ind_columns c
      WHERE  i.owner      = c.index_owner
      AND    i.index_name = c.index_name
      AND    i.owner      = info_owner_
      AND    i.index_name = primary_key_;
BEGIN
   FOR rec IN get_pk LOOP
      columns_ := columns_ || rec.column_name || ',';
   END LOOP;
   RETURN(Substr(columns_,1,length(columns_)-1));
END Get_Ial_Primary_Key___;


FUNCTION Check_Ial_Table___(
   table_       IN VARCHAR2)  RETURN BOOLEAN
IS
   info_owner_      VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
BEGIN
   Slave_Exec_Ddl_Statement___('SELECT 1 FROM '|| info_owner_ || '.' || table_);
   RETURN TRUE;
EXCEPTION
   WHEN OTHERS THEN
         RETURN FALSE;
END Check_Ial_Table___;

FUNCTION Check_Ial_View___(
   view_name_       IN VARCHAR2)  RETURN BOOLEAN
IS
   info_owner_      VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
   exists_          NUMBER;
   
   CURSOR ial_view_exists IS
      SELECT 1
      FROM   ALL_VIEWS
      WHERE  owner      = info_owner_
        AND   view_name = view_name_; 
   
BEGIN
   OPEN  ial_view_exists;
   FETCH ial_view_exists INTO exists_;
   CLOSE ial_view_exists;
   RETURN NVL(exists_, 0) = 1;
END Check_Ial_View___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT IAL_OBJECT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Check_Ial___;
   newrec_.failed_executions := 0;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     IAL_OBJECT_TAB%ROWTYPE,
   newrec_     IN OUT IAL_OBJECT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   info_owner_      VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
   stmt_            VARCHAR2(2000);
BEGIN
   Check_Ial___;
   Error_SYS.Check_Not_Null(lu_name_, 'NAME', newrec_.name);

   IF (Get_Ial_Primary_Key___(newrec_.name) IS NULL AND newrec_.replication = 'PARTIAL_REPLICATION') THEN
      Client_SYS.Add_Info(lu_name_, 'NOPRIMARYKEYS: Partial replication without having a primary key on the IAL object may lead to duplicate rows.');
   END IF;

   IF (oldrec_.replication_status = 'WORKING') THEN
      Error_SYS.Appl_General(lu_name_, 'REPINPROGRESS: Replication is currently in progress.');
   END IF;

   IF (newrec_.replication <> oldrec_.replication) THEN
      IF (newrec_.replication = 'LIVE_DATA') THEN
         Slave_Exec_Ddl_Statement___('CREATE OR REPLACE VIEW '||newrec_.name||' AS SELECT * FROM '||info_owner_||'.'||newrec_.name||'_IAL');
      ELSE
         IF Check_Ial_Table___(newrec_.name||'_TAB') THEN
            stmt_ := 'CREATE OR REPLACE VIEW '||newrec_.name||' AS SELECT * FROM '||info_owner_||'.'||newrec_.name||'_TAB';
            IF (newrec_.where_clause IS NOT NULL) THEN
               stmt_ := stmt_ || ' WHERE ' || newrec_.where_clause;
            END IF;
            Slave_Exec_Ddl_Statement___(stmt_);
         ELSE
            -- table was for some reason not there. Has to be fixed in the installation.
            Error_SYS.Appl_General(lu_name_, 'REPTABNOTEXIST: Table not found. Redeploy the scripts manually' );
         END IF;
      END IF;
   END IF;

   IF (newrec_.replication_schedule IS NOT NULL) THEN
      newrec_.next_exec_time := Batch_SYS.Get_Next_Exec_Time__(newrec_.replication_schedule, NULL);
   ELSE
      newrec_.next_exec_time := NULL;
   END IF;

   Client_SYS.Set_Item_Value('NEXT_EXEC_TIME', newrec_.next_exec_time, attr_);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN IAL_OBJECT_TAB%ROWTYPE )
IS
BEGIN
   Check_Ial___;
   IF (remrec_.replication_status = 'WORKING') THEN
      Error_SYS.Appl_General(lu_name_, 'REPINPROGRESS: Replication is currently in progress.');
   END IF;
   IF(Check_Ial_View___(remrec_.name)) THEN
      Slave_Exec_Ddl_Statement___('DROP VIEW '||remrec_.name);
   END IF;
   IF(Check_Ial_View___(remrec_.name||'_IAL')) THEN
      Slave_Exec_Ddl_Statement___('DROP VIEW '||remrec_.name||'_IAL');
   END IF;
   IF (remrec_.replication_avail IN ('FULL_REPLICATION', 'PARTIAL_REPLICATION')) THEN
      IF Check_Ial_Table___(remrec_.name||'_TAB') THEN
         Slave_Exec_Ddl_Statement___('DROP TABLE '||remrec_.name||'_TAB PURGE');
      END IF;
   END IF;
   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     ial_object_tab%ROWTYPE,
   newrec_ IN OUT ial_object_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.replication NOT  IN ('LIVE_DATA','FULL_REPLICATION','PARTIAL_REPLICATION')) THEN
      Error_SYS.Appl_General(lu_name_, 'NOREPSTATE: Replication method [:P1] is not supported.', newrec_.replication);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Do_Replication__ (
   name_ IN VARCHAR2 )
IS
   info_owner_       VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
   rec_              IAL_OBJECT_TAB%ROWTYPE;
   next_exec_time_   DATE;
   index_list_       VARCHAR2(32000);
   from_             NUMBER;
   to_               NUMBER;
   index_            VARCHAR2(32000);
   table_            VARCHAR2(32000);
   empty_table_      VARCHAR2(32000);
   replication_date_ DATE;
   table_exist_      BOOLEAN;
   key_list_         VARCHAR2(2000) := Get_Ial_Primary_Key___(name_);
   date_format_      VARCHAR2(100) := Client_SYS.date_format_;
   view_exist_       BOOLEAN;
   tablespace_       VARCHAR2(100);
   create_empty_tab_ BOOLEAN := Fnd_Setting_API.Get_Value('IAL_CREATE_EMPTY_TAB') = 'YES';
   err_tmp_create_   BOOLEAN := FALSE;
   drop_and_rename_  BOOLEAN := FALSE;
   del_and_ins_      BOOLEAN := FALSE;
   sql_err_          VARCHAR2(1000);
   error_ocurrence_  NUMBER;
   rep_status_       VARCHAR2(100);

   CURSOR get_default_tablespace_ IS
      SELECT default_tablespace
      FROM dba_users
      WHERE username = info_owner_;

   CURSOR get_status IS
      SELECT replication_status
      FROM ial_object_tab
      WHERE Name = name_;

BEGIN
   Check_Ial___;
   IF NOT Check_Exist___(name_) THEN
      Error_SYS.Appl_General(lu_name_, 'IALNOTEXIST: IAL Object with name [:P1] does not exist', name_);
   END IF;
   rec_ := Get_Object_By_Keys___(name_);
   error_ocurrence_ := Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('IAL_ERROR_OCCURENCE'));

   OPEN get_status;
   FETCH get_status INTO rep_status_;
   CLOSE get_status;

   IF rep_status_ = 'WORKING' THEN
      Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'REPLICATIONINPRO: Replication is in progress new replication will not be initiated'));
      Error_SYS.Appl_General(lu_name_, 'REPLICATIONINPRO: Replication is in progress new replication will not be initiated');
   ELSE
      IF (rec_.replication IN ('FULL_REPLICATION', 'PARTIAL_REPLICATION')) THEN
         IF (rec_.replication = 'PARTIAL_REPLICATION' AND rec_.last_exec_time IS NOT NULL) THEN
          -- Enter partial replication
            replication_date_ := sysdate;
            IF rec_.next_exec_time > SYSDATE THEN
               -- next execution time is in future. Current execution must be a manual execution.
               next_exec_time_ := rec_.next_exec_time;
            ELSIF (rec_.replication_schedule IS NOT NULL AND rec_.replication_schedule NOT LIKE 'ON%') THEN
               next_exec_time_ := Batch_SYS.Get_Next_Exec_Time__(rec_.replication_schedule, rec_.next_exec_time);
            ELSE
               next_exec_time_ := NULL;
            END IF;
            UPDATE   ial_object_tab
               SET   last_exec_time = replication_date_,
                     last_exec_time_complete = NULL,
                     next_exec_time = next_exec_time_,
                     replication_status = 'WORKING',
                     rowversion = sysdate
               WHERE Name = name_;
         Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'PARTREPINIT: Partial replication initiated'));
@ApproveTransactionStatement(2013-11-15,mabose)
            COMMIT;
            BEGIN
               -- Is performed by the slave which is owned by the IAL user...
               -- Remove the duplicate rows in the IAL table if it has a unique constraint.
               IF (key_list_ IS NOT NULL) THEN
                  Slave_Exec_Ddl_Statement___('DELETE FROM '||name_||'_TAB '||
                                              'WHERE ('||key_list_||') IN (SELECT '||key_list_||' '||
                                                                          'FROM '||name_||'_IAL '||
                                                                          'WHERE objdate >= to_date('''||to_char(rec_.last_exec_time,date_format_)||''','''||date_format_||'''))');
               END IF;
   
               Slave_Exec_Ddl_Statement___('INSERT INTO '||name_||'_TAB '||
                                           'SELECT * FROM '||name_||'_IAL '||
                                           'WHERE objdate >= to_date('''||to_char(rec_.last_exec_time,date_format_)||''','''||date_format_||''')');
            Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'PARTREPMOVED: Partial replication, data moved complete'));
               IF rec_.next_exec_time > SYSDATE THEN
                  -- next execution time is in future. Current execution must be a manual execution.
                  next_exec_time_ := rec_.next_exec_time;
               ELSIF (rec_.replication_schedule IS NOT NULL AND rec_.replication_schedule NOT LIKE 'ON%') THEN
                  -- in this case rec_.next_exec_time is actually refering to the last calculated time. Important difference to rec_.last_exec_time...
                  next_exec_time_ := Batch_SYS.Get_Next_Exec_Time__(rec_.replication_schedule, rec_.next_exec_time);
               ELSE
                  next_exec_time_ := NULL;
               END IF;
               UPDATE   ial_object_tab
                  SET   next_exec_time = next_exec_time_,
                        last_exec_time_complete = sysdate,
                        replication_status = 'OK',
                        rowversion = sysdate
                  WHERE Name = name_;
            EXCEPTION
               WHEN OTHERS THEN
@ApproveTransactionStatement(2013-11-15,mabose)
                  ROLLBACK;
                  IF (rec_.replication_schedule IS NOT NULL AND rec_.replication_schedule NOT LIKE 'ON%') THEN 
                     IF  error_ocurrence_ < 0 THEN
                        UPDATE   ial_object_tab
                           SET   next_exec_time = next_exec_time_,
                                 last_exec_time = rec_.last_exec_time,
                                 failed_executions = rec_.failed_executions + 1,
                                 replication_status = 'ERROR'
                           WHERE Name = name_;
@ApproveTransactionStatement(2013-11-15,mabose)
                        COMMIT;
                     ELSIF error_ocurrence_ = 0  THEN
                        UPDATE   ial_object_tab
                           SET   next_exec_time = NULL,
                                 last_exec_time = rec_.last_exec_time,
                                 failed_executions = rec_.failed_executions + 1,
                                 replication_status = 'ERROR'
                           WHERE Name = name_;
@ApproveTransactionStatement(2013-11-15,mabose)
                        COMMIT;
                     ELSIF error_ocurrence_ > 0 THEN
                        IF error_ocurrence_ > rec_.failed_executions THEN
                           UPDATE   ial_object_tab
                              SET   next_exec_time = next_exec_time_,
                                    last_exec_time = rec_.last_exec_time,
                                    failed_executions = rec_.failed_executions + 1,
                                    replication_status = 'ERROR'
                              WHERE Name = name_;
@ApproveTransactionStatement(2013-11-15,mabose)
                           COMMIT;
                        END IF;
                     END IF;
                  ELSE
                     UPDATE   ial_object_tab
                        SET   next_exec_time = NULL,
                              last_exec_time = rec_.last_exec_time,
                              failed_executions = rec_.failed_executions + 1,
                              replication_status = 'ERROR'
                        WHERE Name = name_;
@ApproveTransactionStatement(2013-11-15,mabose)
                     COMMIT;
                  END IF;
                  RAISE; -- Raise exception to propagate error
            END;
         Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'PARTREPFINISHED: Partial replication complete'));
@ApproveTransactionStatement(2013-11-15,mabose)
            COMMIT;
         ELSE
            -- Enter full replication
            IF rec_.next_exec_time > SYSDATE THEN
               -- next execution time is in future. Current execution must be a manual execution.
               next_exec_time_ := rec_.next_exec_time;
            ELSIF (rec_.replication_schedule IS NOT NULL AND rec_.replication_schedule NOT LIKE 'ON%') THEN
               next_exec_time_ := Batch_SYS.Get_Next_Exec_Time__(rec_.replication_schedule, rec_.next_exec_time);
            ELSE
               next_exec_time_ := NULL;
            END IF;
            UPDATE   ial_object_tab
               SET   last_exec_time = sysdate,
                     last_exec_time_complete = NULL,
                     next_exec_time = next_exec_time_,
                     replication_status = 'WORKING',
                     rowversion = sysdate
               WHERE Name = name_;
            -- Saving index info
         Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'REPSAVINDEX: Building table and index information'));
@ApproveTransactionStatement(2013-11-15,mabose)
            COMMIT;
            
            -- Check if view exist
            BEGIN
               view_exist_ := FALSE;
               Slave_Exec_Ddl_Statement___('SELECT 1 FROM '|| info_owner_ || '.' || name_||'_IAL');
               view_exist_ := TRUE;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
   
            -- Check if table exist
            BEGIN
               table_exist_ := FALSE;
               Slave_Exec_Ddl_Statement___('SELECT 1 FROM '|| info_owner_ || '.' || name_||'_TAB');
               table_exist_ := TRUE;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
   
            IF ( view_exist_ ) THEN
               Assert_SYS.Assert_Is_User(info_owner_);
               @ApproveDynamicStatement(2006-01-05,utgulk)
               EXECUTE IMMEDIATE 'BEGIN '||info_owner_||'.IAL_Object_Slave_API.Enumerate_Index_Info(:index_list_, :name_); END;' USING IN OUT index_list_, name_;
               IF (table_exist_) THEN
                  Assert_SYS.Assert_Is_User(info_owner_);
                  @ApproveDynamicStatement(2006-01-05,utgulk)
                  EXECUTE IMMEDIATE 'BEGIN '||info_owner_||'.IAL_Object_Slave_API.Get_Table_Info(:table_, :name_); END;' USING IN OUT table_, name_;
               END IF;
   
               BEGIN
                  -- Dropping temp table
               Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'REPDROPTEMPTABLE: Dropping temp table if found'));
                  Slave_Exec_Ddl_Statement___('DROP TABLE '|| info_owner_ || '.' || name_||'_TMP PURGE');
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
   
               replication_date_ := sysdate; -- Save time
               BEGIN
                  IF (table_exist_) THEN
                     BEGIN
                        -- If possible, first try to perform delete/insert operation 
                        Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'REPDELANDINS: Copying data'));
@ApproveTransactionStatement(2014-04-02,mabose)
                        COMMIT;
                        Slave_Exec_Ddl_Statement___('DELETE FROM '||name_||'_TAB');
                        Slave_Exec_Ddl_Statement___('INSERT INTO '||name_||'_TAB '||
                                                    'SELECT * FROM '||name_||'_IAL ');
@ApproveTransactionStatement(2014-04-02,mabose)
                        COMMIT;
                        del_and_ins_ := TRUE;
                     EXCEPTION
                        WHEN OTHERS THEN
                        -- Recreating temp table
                        Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'REPCRETEMPTABLE: Recreating temp table'));
                        table_ := REPLACE(table_,'CREATE TABLE '||name_||'_TAB', 'CREATE TABLE '||name_||'_TMP');
                        Slave_Exec_Ddl_Statement___(table_);
                     END;
                  ELSE
                     Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'CREATETABLE: Creating table'));
                     tablespace_ := Fnd_Setting_API.Get_Value('IAL_TABLESPACE_DATA');
   
                     IF tablespace_ IS NULL OR tablespace_ = '*' THEN
                        OPEN get_default_tablespace_;
                        FETCH get_default_tablespace_ INTO tablespace_;
                        CLOSE get_default_tablespace_;
                     END IF;
   
                     table_ := 'CREATE TABLE '||name_||'_TAB'||
                               '   TABLESPACE '||tablespace_||
                               '   AS ( SELECT * FROM '|| name_||'_IAL)';
                     Slave_Exec_Ddl_Statement___(table_);
                  END IF;
               EXCEPTION
                  WHEN OTHERS THEN 
                     err_tmp_create_ := TRUE;
                     sql_err_ := SQLERRM;
                     IF (create_empty_tab_) THEN
                        -- could not create table with data, recreate without data...
                        empty_table_ := replace(table_, '_IAL)', '_IAL WHERE 1 = 2)');
                        Slave_Exec_Ddl_Statement___(empty_table_); -- Create the table without any data...
                     END IF;
               END;
   
               IF (table_exist_
                   AND NOT del_and_ins_
                   AND (NOT err_tmp_create_ 
                         OR (err_tmp_create_ AND create_empty_tab_))) THEN
                  -- Dropping table
               Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'REPDROPTABLE: Dropping table'));
                  Slave_Exec_Ddl_Statement___('DROP TABLE '|| info_owner_ || '.' || name_||'_TAB PURGE');
                  -- Renaming the temp table
               Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'REPRENAMETEMPTABLE: Renaming temp table to original table name'));
                  Slave_Exec_Ddl_Statement___('RENAME '||name_||'_TMP TO '|| name_||'_TAB');
                  drop_and_rename_ := TRUE;
               END IF;
   
               rec_.last_exec_time := replication_date_; -- Update time in case of rollback, which cannot pass this point.
               -- Recreating indexes
   
               IF (drop_and_rename_ AND NOT err_tmp_create_) THEN
               Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'REPCREINDEX: Recreating all indexes'));
               ELSIF (err_tmp_create_ AND create_empty_tab_) THEN
               Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'REPRESINDEX: Restoring all indexes'));
               END IF;
               
               IF (drop_and_rename_
                   OR (err_tmp_create_ AND create_empty_tab_)) THEN
                  from_ := 1;
                  to_ := instr(index_list_, Client_SYS.field_separator_, from_);
                  WHILE (to_ > 0) LOOP
                     index_ := substr(index_list_, from_, to_ - from_);
                     Slave_Exec_Ddl_Statement___(index_);
                     from_ := to_ + 1;
                  to_ := instr(index_list_, Client_SYS.field_separator_, from_);
                  END LOOP;
               END IF;
   
               IF ((del_and_ins_ OR drop_and_rename_) AND NOT err_tmp_create_) THEN
               Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'REPFINISH: Replication complete.'));
                  IF rec_.next_exec_time > SYSDATE THEN
                     -- next execution time is in future. Current execution must be a manual execution.
                     next_exec_time_ := rec_.next_exec_time;
                  ELSIF (rec_.replication_schedule IS NOT NULL AND rec_.replication_schedule NOT LIKE 'ON%') THEN
                     -- in this case rec_.next_exec_time is actually refering to the last calculated time. Important difference to rec_.last_exec_time...
                     next_exec_time_ := Batch_SYS.Get_Next_Exec_Time__(rec_.replication_schedule, rec_.next_exec_time);
                  ELSE
                     next_exec_time_ := NULL;
                  END IF;
                  UPDATE   ial_object_tab
                     SET   last_exec_time = replication_date_,
                           next_exec_time = next_exec_time_,
                           last_exec_time_complete = sysdate,
                           replication_status = 'OK',
                           rowversion = sysdate
                     WHERE Name = name_;
@ApproveTransactionStatement(2013-11-15,mabose)
                  COMMIT;
               ELSE
                  IF (err_tmp_create_ AND create_empty_tab_) THEN
                  Transaction_SYS.Log_Progress_Info(Language_SYS.Translate_Constant(lu_name_, 'REPINDEXFINISH: Index restoration complete.'));
                     Error_SYS.Appl_General(lu_name_, 'REPTABEMPTY: Table was recreated empty due to error [:P1]. Redo replication manually', sql_err_ );
                  ELSE
                     Error_SYS.Appl_General(lu_name_, 'REPTABOLD: Table not updated due to error [:P1]. Redo replication manually', sql_err_ );
                  END IF;
               END IF;
            ELSE
               -- table was for some reason not there. Has to be fixed in the installation.
               Error_SYS.Appl_General(lu_name_, 'REPTABNOTEXIST: Table not found. Redeploy the scripts manually' );
            END IF;
         END IF;
      END IF;
   END IF;
@ApproveTransactionStatement(2013-11-15,mabose)
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      IF (rec_.replication_schedule IS NOT NULL AND rec_.replication_schedule NOT LIKE 'ON%') THEN 
         IF  error_ocurrence_ < 0 THEN
            UPDATE ial_object_tab
               SET next_exec_time = next_exec_time_,
                   last_exec_time = rec_.last_exec_time,
                   failed_executions = rec_.failed_executions + 1,
                   replication_status = 'ERROR'
             WHERE Name = name_;
@ApproveTransactionStatement(2013-11-15,mabose)
            COMMIT;
         ELSIF error_ocurrence_ = 0  THEN
            UPDATE ial_object_tab
               SET next_exec_time = NULL,
                   last_exec_time = rec_.last_exec_time,
                   failed_executions = rec_.failed_executions + 1,
                   replication_status = 'ERROR'
             WHERE Name = name_;
@ApproveTransactionStatement(2013-11-15,mabose)
            COMMIT;
         ELSIF error_ocurrence_ > 0 THEN
            IF error_ocurrence_ >= rec_.failed_executions THEN
               UPDATE ial_object_tab
                  SET next_exec_time = next_exec_time_,
                      last_exec_time = rec_.last_exec_time,
                      failed_executions = rec_.failed_executions + 1,
                      replication_status = 'ERROR'
                WHERE Name = name_;
@ApproveTransactionStatement(2013-11-15,mabose)
               COMMIT;
            END IF;
         END IF;
      ELSE
         UPDATE ial_object_tab
            SET next_exec_time = NULL,
                last_exec_time = rec_.last_exec_time,
                failed_executions = rec_.failed_executions + 1,
                replication_status = 'ERROR'
          WHERE Name = name_;
@ApproveTransactionStatement(2013-11-15,mabose)
         COMMIT;
      END IF;
      RAISE; -- Raise exception to propagate error
END Do_Replication__;


PROCEDURE Deploy_BI__ (
   bi_view_name_     IN VARCHAR2,   
   description_      IN VARCHAR2,
   select_statement_ IN VARCHAR2)
IS
BEGIN                   
   Slave_Exec_Ddl_Statement___('CREATE OR REPLACE VIEW ' || bi_view_name_ || ' AS ' || select_statement_ || ' WITH read only');         
   Slave_Exec_Ddl_Statement___('GRANT SELECT ON '||bi_view_name_||' TO ' || Fnd_Session_API.Get_App_Owner||' WITH GRANT OPTION');
   -- Grant select on the view to predefined user IFSSYS
   Slave_Exec_Ddl_Statement___('GRANT SELECT ON '||bi_view_name_||' TO IFSSYS');
   -- register the new BI IAL view
   BEGIN
      INSERT INTO ial_object_tab(
         Name, replication, replication_avail, failed_executions, rowversion )
      VALUES (
         bi_view_name_, 'LIVE_DATA', 'LIVE_DATA', 0, sysdate);
   EXCEPTION
      WHEN dup_val_on_index THEN
         UPDATE ial_object_tab
            SET replication_avail = 'LIVE_DATA',
                rowversion = sysdate
          WHERE Name = bi_view_name_;
   END;      
   Add_Description(bi_view_name_, description_);
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Appl_General(lu_name_,'ERRORDEPLOY: Error when deploying BI view in Information Access layer :P1.', bi_view_name_);
END Deploy_BI__;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Get_Details (
   object_details_  OUT VARCHAR2,
   name_            IN VARCHAR2 )
IS
   info_owner_       VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
   out_              CLOB;
   rec_              VARCHAR2(32000);
   rfrom_            NUMBER;
   rto_              NUMBER;
   pos_              NUMBER;
   msg_              VARCHAR2(32000) := Message_SYS.Construct('IAL_OBJECT_DETAILS');
   column_list_msg_  VARCHAR2(32000);
   column_msg_       VARCHAR2(32000);
   item_name_        VARCHAR2(32000);
   item_value_       VARCHAR2(32000);
BEGIN
   Check_Ial___;
   Assert_SYS.Assert_Is_User(info_owner_);
   @ApproveDynamicStatement(2006-01-05,utgulk)
   EXECUTE IMMEDIATE 'BEGIN '||info_owner_||'.IAL_Object_Slave_API.Enumerate_Column_Info(:out_, :name_); END;' USING IN OUT out_, name_;
   rfrom_ := 1;
   rto_ := instr(out_, Client_SYS.group_separator_, rfrom_);
   column_list_msg_ := Message_SYS.Construct('COLUMN_LIST');
   WHILE (rto_ > 0) LOOP
      rec_ := substr(out_, rfrom_, rto_ - rfrom_);
      pos_ := 1;
      column_msg_ := Message_SYS.Construct('COLUMN');
      WHILE (Client_SYS.Get_Next_From_Attr(rec_, pos_, item_name_, item_value_)) LOOP
         Message_SYS.Add_Attribute(column_msg_, item_name_, item_value_);
      END LOOP;
      Message_SYS.Add_Attribute(column_list_msg_, 'COLUMN', column_msg_);
      rfrom_ := rto_ + 1;
      rto_ := instr(out_, Client_SYS.group_separator_, rfrom_);
   END LOOP;
   Message_SYS.Add_Attribute(msg_, 'COLUMN_LIST', column_list_msg_);
   object_details_ := msg_;
END Get_Details;


PROCEDURE Post_Replication (
   name_        IN VARCHAR2 )
IS
   executing_msg_    VARCHAR2(32000);
   posted_msg_       VARCHAR2(32000);
   executing_found_  BOOLEAN;
   posted_found_     BOOLEAN;

   FUNCTION Value_Found___ (message_      VARCHAR2,
                            search_str_   VARCHAR2) RETURN BOOLEAN IS

      attr_name_  Message_SYS.name_table;
      attr_value_ Message_SYS.line_table;
      count_      INTEGER;
   BEGIN
      Message_SYS.Get_Attributes(message_, count_, attr_name_, attr_value_);
      FOR i_ IN 1..count_ LOOP
         IF UPPER(attr_value_(i_)) = UPPER(search_str_) THEN
            RETURN TRUE;
         END IF;
      END LOOP;
      RETURN FALSE;
   END Value_Found___;

BEGIN
   Check_Ial___;
   IF NOT Check_Exist___(name_) THEN
      Error_SYS.Appl_General(lu_name_, 'IALNOTEXIST: IAL Object with name [:P1] does not exist', name_);
   END IF;
   IF (Fnd_Setting_API.Get_Value('IAL_REPLICATION') = 'ON') THEN
      Transaction_SYS.Get_Executing_Job_Arguments(executing_msg_, 'IAL_OBJECT_API.DO_REPLICATION__');
      executing_found_ := Value_Found___(executing_msg_, name_);
      Transaction_SYS.Get_Posted_Job_Arguments(posted_msg_, 'IAL_OBJECT_API.DO_REPLICATION__');
      posted_found_ := Value_Found___(posted_msg_, name_);

      IF (executing_found_ OR posted_found_) THEN
         Error_SYS.Appl_General(lu_name_, 'REPLICATIONINPRO: Replication is in progress new replication will not be initiated');
      ELSE
         Transaction_SYS.Deferred_Call('IAL_Object_API.Do_Replication__', name_, Language_SYS.Translate_Constant(lu_name_, 'IALDOREP: Replicate IAL Object [:P1]', NULL, name_));
      END IF;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'IALREPERR: All replication has been disabled.');
   END IF;
END Post_Replication;


PROCEDURE Enable (
   name_        IN VARCHAR2 )
IS
   info_owner_         VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
   out_                VARCHAR2(32000);
   table_name_         VARCHAR2(100);
   objdate_            VARCHAR2(100);
   replication_avail_  VARCHAR2(100);
BEGIN
   IF (length(name_) > 26) THEN
      Error_SYS.Appl_General(lu_name_, 'IALNAMEERR: Maximum length of object is 26 characters.');
   END IF;
   Check_Ial___;
   -- Create the view
   Slave_Exec_Ddl_Statement___('CREATE OR REPLACE VIEW '||name_||' AS SELECT * FROM '||info_owner_||'.'||name_||'_IAL');
   -- Grant select on the view with admin option to appowner
   Slave_Exec_Ddl_Statement___('GRANT SELECT ON '||name_||' TO '||Fnd_Session_API.Get_App_Owner||' WITH GRANT OPTION');
   -- Grant select on the view to predefined user IFSSYS
   Slave_Exec_Ddl_Statement___('GRANT SELECT ON '||name_||' TO IFSSYS');
   Assert_SYS.Assert_Is_User(info_owner_);
   @ApproveDynamicStatement(2006-01-05,utgulk)
   EXECUTE IMMEDIATE 'BEGIN '||info_owner_||'.IAL_Object_Slave_API.Get_Object_Info(:out_, :name_); END;' USING IN OUT out_, name_;
   table_name_ := Client_SYS.Get_Item_Value( 'TABLE_NAME', out_ );
   objdate_ := Client_SYS.Get_Item_Value( 'OBJDATE', out_ );
   IF (table_name_ IS NOT NULL) THEN
      IF (objdate_ = 'TRUE') THEN
         replication_avail_ := 'PARTIAL_REPLICATION';
      ELSE
         replication_avail_ := 'FULL_REPLICATION';
      END IF;
   ELSE
      replication_avail_ := 'LIVE_DATA';
   END IF;
   BEGIN
      INSERT INTO ial_object_tab(
         Name, replication, replication_avail, failed_executions, rowversion )
      VALUES (
         name_, 'LIVE_DATA', replication_avail_, 0, sysdate);
   EXCEPTION
      WHEN dup_val_on_index THEN
         UPDATE   ial_object_tab
            SET   replication_avail = replication_avail_,
                  rowversion = sysdate
            WHERE Name = name_;
   END;
@ApproveTransactionStatement(2013-11-15,mabose)
   COMMIT;
END Enable;


PROCEDURE Disable (
   name_ IN VARCHAR2 )
IS
   info_owner_ VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
BEGIN
   Check_Ial___;

   BEGIN
      IF Check_Ial_Table___(name_||'_TAB') THEN
         Slave_Exec_Ddl_Statement___('DROP TABLE '|| info_owner_ || '.' || name_||'_TAB  PURGE');
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         Error_SYS.Appl_General(lu_name_, 'REPTABNOTEXIST: Table not found. Redeploy the scripts manually' );
   END;
   DELETE FROM ial_object_tab
      WHERE Name = name_;
END Disable;


PROCEDURE Add_Index (
   name_        IN VARCHAR2,
   column_name_ IN VARCHAR2 )
IS
   info_owner_        VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
   replication_avail_ IAL_OBJECT_TAB.replication_avail%TYPE;
   out_               VARCHAR2(30);
BEGIN
   Check_Ial___;
   replication_avail_ := Get_Replication_Avail(name_);
   IF (replication_avail_ IN ('FULL_REPLICATION', 'PARTIAL_REPLICATION')) THEN
      -- Call slave method
      Assert_SYS.Assert_Is_User(info_owner_);
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE 'BEGIN :out_ := '||info_owner_||'.IAL_Object_Slave_API.Check_Index(:name_, :column_name_); END;' USING OUT out_, name_, column_name_;
      IF (out_ = 'FALSE') THEN
         Error_SYS.Appl_General(lu_name_, 'INDEXEXIST: There already exist a proper index on this object that has been installed by the administrator. No index created.');
      END IF;
      Assert_SYS.Assert_Is_User(info_owner_);
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE 'BEGIN '||info_owner_||'.IAL_Object_Slave_API.Add_Index(:name_, :column_name_); END;' USING name_, column_name_;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'NOREPOPT: Replication option is not enabled for :P1', name_);
   END IF;
END Add_Index;


PROCEDURE Remove_Index (
   name_        IN VARCHAR2,
   column_name_ IN VARCHAR2 )
IS
   info_owner_        VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
   replication_avail_ IAL_OBJECT_TAB.replication_avail%TYPE;
BEGIN
   Check_Ial___;
   replication_avail_ := Get_Replication_Avail(name_);
   IF (replication_avail_ IN ('FULL_REPLICATION', 'PARTIAL_REPLICATION')) THEN
      -- Call slave method
      Assert_SYS.Assert_Is_User(info_owner_);
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE 'BEGIN '||info_owner_||'.IAL_Object_Slave_API.Remove_Index(:name_, :column_name_); END;' USING name_, column_name_;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'NOREPOPT: Replication option is not enabled for :P1', name_);
   END IF;
END Remove_Index;


@UncheckedAccess
PROCEDURE Enumerate (
   object_list_ OUT VARCHAR2 )
IS
   list_       VARCHAR2(32000);
BEGIN
   FOR rec_ IN (SELECT   Name FROM IAL_OBJECT_TAB
                ORDER BY Name ) LOOP
      list_ := list_ || rec_.name || Client_SYS.field_separator_;
   END LOOP;
   object_list_ := list_;
END Enumerate;


PROCEDURE Add_Where_Clause (
   name_ IN VARCHAR2,
   where_clause_ IN VARCHAR2 )
IS
   lu_rec_ IAL_OBJECT_TAB%ROWTYPE;
BEGIN
   lu_rec_ := Lock_By_Keys___(name_);
   UPDATE ial_object_tab
      SET where_clause = where_clause_,
          rowversion = sysdate
      WHERE Name = name_ ;
END Add_Where_Clause;


PROCEDURE Add_Description (
   name_ IN VARCHAR2,
   description_ IN VARCHAR2 )
IS
   lu_rec_ IAL_OBJECT_TAB%ROWTYPE;
BEGIN
   lu_rec_ := Lock_By_Keys___(name_);
   UPDATE ial_object_tab
      SET description = description_,
          rowversion = sysdate
      WHERE Name = name_ ;
END Add_Description;


PROCEDURE Deploy_IAL (
   object_name_ IN VARCHAR2,
   component_name_ IN VARCHAR2,
   description_ IN VARCHAR2,
   live_data_ IN VARCHAR2,
   select_statement_ IN VARCHAR2,
   where_clause_ IN VARCHAR2,
   index_columns_ IN VARCHAR2,
   data_tablespace_ IN VARCHAR2,
   index_tablespace_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
--disable object

   BEGIN
      Disable(object_name_);
   EXCEPTION
      WHEN OTHERS THEN
         Error_SYS.Appl_General(lu_name_,'ERRORDISABLEIAL: Error when deploying IAL :P1. Could not disable the object.',object_name_);
   END;
    
   --ial view
   BEGIN
      Slave_Exec_Ddl_Statement___('CREATE OR REPLACE VIEW '||object_name_||'_IAL AS '||select_statement_ || ' WITH read only');
      
      Slave_Exec_Ddl_Statement___('GRANT SELECT ON '||object_name_||'_IAL TO ' || Fnd_Session_API.Get_App_Owner() || ' WITH GRANT OPTION');
--   EXCEPTION
--      WHEN OTHERS THEN
--         Error_SYS.Appl_General(lu_name_,'Error when deploying IAL :P1. Could not create/replace view or grant select.',object_name_);
   END;
      
    
   --table data for replication
   BEGIN
      IF(live_data_ = 'FALSE') THEN
         Slave_Exec_Ddl_Statement___('CREATE TABLE ' || object_name_||'_TAB TABLESPACE '||data_tablespace_||' AS ( SELECT * FROM ' ||object_name_ || '_IAL WHERE 1=2)');
         -- creating PK index
         BEGIN
            IF ((index_columns_ IS NOT NULL) AND
                (index_tablespace_ IS NOT NULL)) THEN
               Slave_Exec_Ddl_Statement___('ALTER TABLE ' || object_name_|| '_TAB ADD (CONSTRAINT ' || object_name_|| '_PK PRIMARY KEY (' || index_columns_ || ') USING INDEX TABLESPACE ' || index_tablespace_ || ')');
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               Error_SYS.Appl_General(lu_name_,'IAL_IND_ERR: Error when deploying IAL :P1. Could not create PK index :P1_PK for replication in tablespace :P2)',object_name_,index_tablespace_);
         END;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         Error_SYS.Appl_General(lu_name_,'IAL_TAB_ERR: Error when deploying IAL :P1. Could not create table :P1_TAB for replication (tablespace :P2, where clause :P3)',object_name_,data_tablespace_,where_clause_);
   END;
    
   --object registration
   BEGIN
      Enable(object_name_);
      IF (where_clause_ IS NOT NULL) THEN
         Add_Where_Clause(object_name_, where_clause_);
      END IF;
      Add_Description(object_name_, description_);
   EXCEPTION
      WHEN OTHERS THEN
         Error_SYS.Appl_General(lu_name_,'ERRORENABLEIAL: Error when deploying IAL :P1. Could not enable :P1 or add description',object_name_);
   END;
END Deploy_IAL;


PROCEDURE Reset_Error_Exec (
   name_ VARCHAR2)
IS
   lu_rec_ IAL_OBJECT_TAB%ROWTYPE;
BEGIN
    lu_rec_ := Lock_By_Keys___(name_);
    UPDATE ial_object_tab
    SET failed_executions = 0,
        rowversion = sysdate
    WHERE Name = name_;
END Reset_Error_Exec;


PROCEDURE Create_Bia_View_In_Ial(view_name_ IN VARCHAR2)
IS
   info_owner_   VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
   statement_    VARCHAR2(100);
BEGIN
   Assert_SYS.Assert_Is_User(info_owner_);      
   IF (Database_SYS.View_Exist(view_name_)) THEN
      statement_ := 'SELECT * FROM ' || Fnd_Session_API.Get_App_Owner || '.' || view_name_;   
      @ApproveDynamicStatement(2017-01-02,shfrlk)
      EXECUTE IMMEDIATE 'GRANT SELECT ON ' || view_name_ || ' TO ' || info_owner_ || ' WITH GRANT OPTION';
      Ial_Object_API.Deploy_BI__(view_name_, 'Mandatory Non BI Access View in Information Access layer', statement_);
   END IF;
END Create_Bia_View_In_Ial;


PROCEDURE Disable_Bi_View(view_name_ IN VARCHAR2)
IS   
   dummy_n_   NUMBER;   
   CURSOR view_exists IS
      SELECT 1
        FROM ial_object_tab
       WHERE Name = view_name_;       
BEGIN
   OPEN view_exists;
   FETCH view_exists INTO dummy_n_;
   IF (view_exists%FOUND) THEN
      DELETE FROM ial_object_tab WHERE Name = view_name_;
   END IF;
   CLOSE view_exists;
END Disable_Bi_View;

PROCEDURE Update_fields (
   obj_name_         IN VARCHAR2,
   select_statement_ IN VARCHAR2 DEFAULT NULL,
   index_columns_    IN VARCHAR2 DEFAULT NULL,
   rep_schedule_     IN VARCHAR2 DEFAULT NULL)
IS
   info_          VARCHAR2(4000);
   objid_         VARCHAR2(20);
   objversion_    VARCHAR2(100);
   attr_          VARCHAR2(4000);
   select_clob_   CLOB;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, obj_name_);
   Client_SYS.Clear_Attr(attr_);
   IF (index_columns_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INDEX_COLUMNS', index_columns_, attr_);
   END IF;
   IF (rep_schedule_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REPLICATION_SCHEDULE', rep_schedule_, attr_);
   END IF;
   Modify__(info_, objid_, objversion_, attr_, 'DO');
   IF (select_statement_ IS NOT NULL) THEN
      select_clob_ := select_statement_;
      Write_Select_Statement__(objversion_, objid_, select_clob_);
   END IF;
END Update_fields;
