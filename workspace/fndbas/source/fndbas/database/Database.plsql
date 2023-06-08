-----------------------------------------------------------------------------
--
--  Logical unit: Database
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  010228  HAAR  Created
--  010425  ROOD  Added parameter object_name_ in Analyze_Object__ (ToDo#4006).
--  010426  ROOD  Added views (ToDo#4006).
--  010518  HAAR  Major rewrite
--                Use Dbms_Stats instead of Dbms_Util.
--                Make IFS specific Analyze_Schema with method_ 'AUTOMATIC'.
--                Removed some irrelevant parameters.
--  010620  ROOD  Renamed to System Service Database_SYS.
--  010807  HAAR  Added Get_Last_Analyzed__ and Get_Buffer_Pool__.
--  010924  HAAR  Added Remove_Indexes, Remove_Constraints, Remove_All_Cons_And_Idx
--                Remove_Table, Remove_View and Remove_Package (ToDo#4045).
--  011024  HAAR  Change Trace_SYS.Message to Dbms_Output.Put_Line in above methods.
--  011204  HAAR  Added lots of new functionality for upgrading (ToDo#4055).
--  020118  HAAR  Added better error handling and better storage parameter support (ToDo#4055).
--  020122  HAAR  Added functionality in Analyze procedures to handle Temporary objects (Bug#28402).
--  020214  HAAR  Added procedure Rename_Table (ToDo#4055).
--  020326  HAAR  Added exception in Create_Index (ToDo#4055).
--  020627  HAAR  Use Dbms_Stats.Auto_Sample_Size when gathering statistics for Oracle9i (ToDo#4116)
--  020627  HAAR  Added Check_System_Privilege (ToDo#4068)
--  020819  HAAR  Changed Format_Columns variable stmt_ from 4000 to 32000 character (Bug#32006).
--  021218  HAAR  Removed Submit_Analyze_Schema__, Submit_Rebuild_Indexes__
--                and Submit_Validate_Indexes__ (ToDo#4146).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030317  ROOD  Added methods Get_Database_Properties and Init_All_Packages_ (ToDo#4143).
--  030512  HAAR  Changed Analyze_Schema___ to loop over PL/SQL table (Bug#37281).
--  030624  ROOD  Added Package_Exist and Method_Exist. These methods replace equivalents
--                in Transaction_SYS. Removed security check on Exist-methods (ToDo#4162).
--  030625  HAAR  Changed Validate_Indexes__ and Rebuild_Indexes__ to handle
--                resource busy (Bug#38164).
--  031013  HAAR  Changed Analyze_Schema___ to loop over indexes in separate
--                loop to increase performance(Bug#39959).
--  031027  HAAR  Error in Gather_Index_Statistics___.
--  040113  HAAR  Added function Get_Bind_Length and Write_Table_DDL to
--                support Unicode changes (F1PR408).
--  040122  HAAR  Added function Get_Time_Offset for use in MicroCache logic (000-1).
--  040315  HAAR  Moved implementation of several methods to Installation_SYS (Bug#43425).
--  040331  HAAR  Unicode bulk changes, Added method Format_Import_File for formatting Import file (F1PR408B).
--  040414  HAAR  Added functions Get_Database_Name, Get_Database_Charset and Get_Database_Version.
--                Get_Database_Properties uses the functions.
--                Corrected Get_Database_Version for Oracle10g.
--  040415  HAAR  Added Format_Import_File, to be used when moving database to Unicode (F1PR408).
--  040420  HAAR  Added Asciistr and Unistr functions used in Localize (F1PR408).
--  040421  HAAR  Added Asciistr_Xml and Unistr_Xml functions used in Localize (F1PR408).
--  040513  HAAR  Moved Format_Import_File and Write_Table_Ddl to Installation_SYS.
--  040630  ROOD  Changed view comments LU -> SERVICE (F1PR413).
--  040810  HAAR  Implementation changes in Get_Time_Offset due to performance (F1PR414).
--  040827  HAAR  Added private variables db_encoding_ and file_encoding_ (F1PR408).
--  040827  HAAR  Added DbToFileEncoding, FileToDbEncoding, DefaultFileEncoding and SetFileEncoding (F1PR408).
--  040923  HAAR  Added Validate_Character_Set and Oracle_Character_Set_LOV (F1PR408).
--  041109  ROOD  Added methods Set_Sql_Trace__ and Set_Commit_In_Procedure__.
--  041223  HAAR  Added method Rename_Column (F1PR480).
--  041128  HAAR  Added method Component_Exist (F1PR480).
--  050111  ROOD  Added methods for db_patch registration (Bug#48184).
--  050209  HAAR  Added usage of Assert methods (F1PR483).
--  050317  HAAR  Added Primary_Key_Constraint_Exist (F1PR483).
--  050508  JORA  Added assertion for dynamic SQL.  (F1PR481)
--  050508  JORA  Changed Gather_Table_Statistics___, Analyze_Schema___
--                and Calculate_Percent___
--  050523  JORA  Changed the Set_Sql_Trace__ to use event 10046.
--                Added identifier to Set_Sql_Trace__ method.
--  050603  HAAR  Added support for LOB columns (F1PR840).
--                Added Add_Lob_Column and Remove_Lob_Column.
--  050607  HAAR  Added Get_Formatted_Date, Get_Formatted_Datetime and Get_Formatted_Time (F1PR413E).
--  050610  JORA  Added Start_SQL_Trace__ function (F1PR480).
--  050628  HAAR  Get_Database_xxx functions misses PRAGMA (123733).
--  050630  STDA  Added methods for component patch registration (Bug#50538)
--  050704  HAAR  Changed views to use Dba_xxx instead of User_xxx. (F1PR843).
--  051014  HAAR  Added gather dictionary statistics to Analyze_Schema___ (F1PR480).
--  060105 UTGULK Annotated Sql injection.
--  060202  HAAR  Do not show LOB indexes in view Oracle_Indexes (F1PR480).
--  060324  HAAR  Changed Asciistr and Unistr, not to handle Oracle9i.
--  060511  HAAR  Assert secured Set_Sql_Trace__ and Start_Sql_Trace_ (Bug#57108).
--  060619  HAAR  Added support for Persian calendar (Bug#58601).
--                Added First and Last Calendar date.
--  060621  HENJ  New methods added: Count_Nodes, Get_Platform_Id, Get_Db_Os and Get_Db_Hardware (Bug#58589)
--  060831  HAAR  Added Get_Initialization_Parameter__ (Bug#60186).
--  060907 DUWILK Changed procedures Analyze_Schema___, Gather_Table_Statistics___ and
--                Gather_Index_Statistics___ in order to get indexes and table from Dba_tables and Dba_Indexes (Bug#59883)
--  060908  HAAR  Added Mtrl_View_Log_Exist, Mtrl_View_Exist, Remove_Materialized_View
--                and Remove_Materialized_View_Log (Bug#59182).
--  060922  NiWi  Modified Validate_Index__. Avoid re-building indexes of type LOB(Bug#60729).
--  070504  HAAR  Added methods Get_First_Character and Get_Last_Character (Bug#65135).
--  070620  HAAR  Added method Alter_Lob_Column (Bug#65912).
--  070711  HAAR  Changed Get_First_Character (Bug#65898).
--  070717 SUMALK added FUNCTION Is_Unicode_Character_Set(Bug#66715)
--  070823  HAAR  Change Get_Last_Calendar_Date to return 9999-12-31 for Gregorian,
--                Change Get_First_Calendar_Date to return 0001-01-01 for Gregorian (Bug#67417).
--  080516  HAAR  Rebuild_Index___ is using REBUILD ONLINE when available (Bug#74127).
--  081013  HAAR  Removing histograms for Oracle10g installations (Bug#77687).
--  081216  HAAR  Changed to use Autonomous transaction for logging in background jobs (IID#80009).
--  081222  DUWI  Changed Validate_Indexes__in order to remove indexes which are in type 'IOT - TOP' (Bug#78839).
--  090105  HAAR  Removing histograms for Oracle10g installations (Bug#77687).
--  090308  HAAR  Added methods for Rising and 7/11 project (Bug#81205).
--  091026 UsRaLK Modified Analyze_Schema___ to exclude IOT_OVERFLOW tables. (Bug#86563)
--  100318  HAAR  Added support for Alert Log errors.(EACS-433).
--  100315  DUWI   Added Get_Physical_Lob_Size and Shrink_Lob_Segments (Bug#87984).
--  100507  NaBa   Added Get_Column_Type (Bug#90473)
--  100615  HAAR  Added Compile_Invalid_Object and Get_Compile_Error (EACS-773).
--  101018  MaBo  Added Grant_All and Grant_All_Objects_Ial
--  101123  MaBo  EACS-1287, we should not consider a component as existing before it is registred, added where version is not null in Component_Exist
--  101208  HAAR  Added Validate_Password for the Installer.
--  110917  NaBa  Changed implementation of Analyze_Schema___ to use Dbms_Stats.Gather_Schema_Stats (RDTERUNTIME-369).
--  111103  HAAR  Alert log view changes (RDTERUNTIME-1456).
--  120918  MaBo  Bug-105288 Always use DatabaseSYS record as method parameters
--  120919  MaBo  Bug-105299 Corrected method names in GeneralSYS.InitMethod for some methods
--  120926  DUWI  Changed Execute_Task___ to indicate active triggers (Bug#104703).
--  120927  MaBo  Bug-105328 Added methods for alter empty views
--  121008  WaWi  changed Execute_Analyze_Schema__ to set appowner or ialowner values (Bug#105724)
--  121107  WaWi  Changed the setting of trace label in Start_Sql_Trace__ and Set_Sql_Trace__(Bug#105240)
--  121123  USRA  Changed procedure [Grant_All] to exclude FNDADM (BUG#106349).
--  130304 KrGuSE Modified Validate_Indexes__ to make a number of attempts with a delay between when encountering
--                locked indexes. This is now decided by the parameters. Improved the logging too. (Bug #108184)
--  130719  WAWI  Changed some invalid column comments (Bug#111390)
--  200923 RAKUSE Added Remove_Inactive_Metadata_ (DXDEV-652).
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

SUBTYPE ColRec         IS Installation_SYS.ColRec;
SUBTYPE ColumnTabType  IS Installation_SYS.ColumnTabType;
SUBTYPE ColViewRec     IS Installation_SYS.ColViewRec;
SUBTYPE ColumnViewType IS Installation_SYS.ColumnViewType;
string_null_         CONSTANT VARCHAR2(15)   := 'STRING_NULL';
update_rowkey_job_   CONSTANT VARCHAR2(20)   := 'UPDATE_ROWKEY_JOB';
ORA_MAX_NAME_LEN            CONSTANT NUMBER :=  dbms_standard.ORA_MAX_NAME_LEN;

-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE oracle_object_type IS TABLE OF VARCHAR2(ORA_MAX_NAME_LEN) INDEX BY BINARY_INTEGER;
xml_start_        CONSTANT VARCHAR2(3) := chr(38)||'#x';
xml_end_          CONSTANT VARCHAR2(1) := ';';
crlf_             CONSTANT VARCHAR2(2) := chr(13)||chr(10);
state_pre_loaded_ CONSTANT VARCHAR2(30)   := 'Pre Loaded';
state_loaded_     CONSTANT VARCHAR2(30)   := 'Loaded';
state_finished_   CONSTANT VARCHAR2(30)   := 'Finished';
state_to_do_      CONSTANT VARCHAR2(30)   := 'ToDo';
state_error_      CONSTANT VARCHAR2(30)   := 'Error';
state_ignored_    CONSTANT VARCHAR2(30)   := 'Ignored';
first_calendar_persian_date_   CONSTANT DATE := to_date('1800-01-01', 'YYYY-MM-DD', 'NLS_CALENDAR=GREGORIAN');
first_calendar_gregorian_date_ CONSTANT DATE := to_date('0001-01-01', 'YYYY-MM-DD', 'NLS_CALENDAR=GREGORIAN');
last_calendar_persian_date_    CONSTANT DATE := to_date('2199-12-31', 'YYYY-MM-DD', 'NLS_CALENDAR=GREGORIAN');
last_calendar_gregorian_date_  CONSTANT DATE := to_date('9999-12-31', 'YYYY-MM-DD', 'NLS_CALENDAR=GREGORIAN');

micro_cache_nls_charset_  nls_database_parameters.value%TYPE;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Analyze_Schema___ (
   schema_           IN VARCHAR2 DEFAULT USER,
   method_           IN VARCHAR2 DEFAULT 'AUTOMATIC',
   estimate_percent_ IN NUMBER   DEFAULT NULL )
IS
   percent_          NUMBER := 0;
BEGIN
   IF method_ = 'DELETE' THEN
      BEGIN
         Transaction_SYS.Log_Progress_Info('Statistics deletion job in progress.');
         Dbms_Stats.Delete_Schema_Stats(schema_);
         Transaction_SYS.Log_Status_Info(Get_job_info___,'INFO');
         Transaction_SYS.Log_Status_Info('Optimizer will use Rule Based Optimization until new statistics are gathered.','INFO');
      EXCEPTION
         WHEN OTHERS THEN
            Transaction_SYS.Log_Status_Info(Substr('Statistics deletion job failed, due to Oracle error ' || SQLERRM || '.',1,2000), 'WARNING');
      END;
   ELSE
      IF method_ = 'AUTOMATIC' THEN
         Calculate_Percent___(percent_);
      ELSIF method_ = 'COMPUTE' THEN
         percent_ := NULL;
      ELSIF method_ = 'ESTIMATE' THEN
         percent_ := estimate_percent_;
      END IF;
      BEGIN
         Transaction_SYS.Log_Progress_Info('Gather statistics job in progress.');
         Dbms_Stats.Gather_Schema_Stats(schema_,percent_);
         Transaction_SYS.Log_Status_Info(Get_job_info___,'INFO');
      EXCEPTION
         WHEN OTHERS THEN
            Transaction_SYS.Log_Status_Info(Substr('Gather statistics job failed, due to Oracle error ' || SQLERRM || '.',1,2000), 'WARNING');
      END;
   END IF;
   Transaction_SYS.Log_Progress_Info(' ');
END Analyze_Schema___;


PROCEDURE Calculate_Percent___ (
   percent_ OUT NUMBER )
IS
BEGIN
   percent_ := Dbms_Stats.Auto_Sample_Size;
END Calculate_Percent___;


PROCEDURE Gather_Index_Statistics___ (
   method_           IN VARCHAR2 DEFAULT 'AUTOMATIC',
   schema_           IN VARCHAR2 DEFAULT USER,
   index_name_       IN VARCHAR2,
   estimate_percent_ IN NUMBER   DEFAULT NULL )
IS
   temporary_        VARCHAR2(10);
   percent_          NUMBER := estimate_percent_;
   CURSOR get_index IS
      SELECT Nvl(temporary, 'N')
      FROM   Dba_indexes
      WHERE  index_name = index_name_;
BEGIN
   OPEN  get_index;
   FETCH get_index INTO temporary_;
   CLOSE get_index;
   IF temporary_ != 'Y' THEN -- Do not gather statistics for temporary tables.
      IF method_ = 'DELETE' THEN
         Dbms_Stats.Delete_Index_Stats(ownname          => schema_,
                                       indname          => index_name_);
      ELSE
         IF method_ IN ('AUTOMATIC', 'COMPUTE') THEN
            percent_ := NULL;
         END IF;
         Dbms_Stats.Gather_Index_Stats(ownname          => schema_,
                                       indname          => index_name_,
                                       estimate_percent => percent_);
      END IF;
   END IF;
END Gather_Index_Statistics___;


PROCEDURE Gather_Table_Statistics___ (
   method_           IN VARCHAR2 DEFAULT 'AUTOMATIC',
   schema_           IN VARCHAR2 DEFAULT USER,
   table_name_       IN VARCHAR2,
   estimate_percent_ IN NUMBER   DEFAULT NULL,
   block_sample_     IN BOOLEAN  DEFAULT FALSE,
   cascade_          IN BOOLEAN  DEFAULT FALSE )
IS
   percent_          NUMBER;
   temporary_        VARCHAR2(10);
   CURSOR get_table IS
      SELECT Nvl(temporary, 'N')
      FROM   Dba_tables
      WHERE  table_name = table_name_;
BEGIN
   OPEN  get_table;
   FETCH get_table INTO temporary_;
   CLOSE get_table;
   IF temporary_ != 'Y' THEN -- Do not gather statistics for temporary tables.
      IF method_ = 'DELETE' THEN
         Dbms_Stats.Delete_Table_Stats(ownname          => schema_,
                                       tabname          => table_name_,
                                       cascade_indexes  => cascade_);
      ELSE
         IF method_ = 'AUTOMATIC' THEN
            Calculate_Percent___(percent_);
         ELSIF method_ = 'COMPUTE' THEN
            percent_ := NULL;
         ELSIF method_ = 'ESTIMATE' THEN
            percent_ := estimate_percent_;
         ELSIF method_ = 'SCHEMA' THEN
            percent_ := estimate_percent_; -- No calculation has to be done, already been taken care of in Analyze_Schema
         END IF;
         Dbms_Stats.Gather_Table_Stats(ownname          => schema_,
                                       tabname          => table_name_,
                                       estimate_percent => percent_,
                                       block_sample     => block_sample_,
                                       cascade          => cascade_);
      END IF;
   END IF;
END Gather_Table_Statistics___;


FUNCTION Get_Oracle_Index_Attr___ (
   index_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   attr_    VARCHAR2(2000);
   CURSOR get_oracle_index IS
      SELECT index_name,
             validation_timestamp,
             validation_date,
             percent_deleted,
             distinctivness,
             allocated_space,
             currently_used_space,
             percent_used,
             recommendation,
             blevel_recommendation
      FROM   oracle_indexes
      WHERE  index_name = index_name_;
BEGIN
   FOR rec IN get_oracle_index LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('INDEX_NAME', rec.index_name, attr_);
      Client_SYS.Add_To_Attr('VALIDATION_TIMESTAMP', rec.validation_timestamp, attr_);
      Client_SYS.Add_To_Attr('VALIDATION_DATE', rec.validation_date, attr_);
      Client_SYS.Add_To_Attr('PERCENT_DELETED', rec.percent_deleted, attr_);
      Client_SYS.Add_To_Attr('DISTINCTIVNESS', rec.distinctivness, attr_);
      Client_SYS.Add_To_Attr('ALLOCATED_SPACE', rec.allocated_space, attr_);
      Client_SYS.Add_To_Attr('CURRENTLY_USED_SPACE', rec.currently_used_space, attr_);
      Client_SYS.Add_To_Attr('RECOMMENDATION', rec.recommendation, attr_);
      Client_SYS.Add_To_Attr('PERCENT_USED', rec.percent_used, attr_);
      Client_SYS.Add_To_Attr('BLEVEL_RECOMMENDATION', rec.blevel_recommendation, attr_);
   END LOOP;
   RETURN(attr_);
END Get_Oracle_Index_Attr___;


FUNCTION Get_Instance_Values___ RETURN sys.v_$instance%ROWTYPE
IS
   instance_rec_                  sys.v_$instance%ROWTYPE;
   CURSOR get_instance IS
      SELECT * --instance_name, host_name, version are the interesting columns right now
      FROM sys.v_$instance;
BEGIN
   OPEN  get_instance;
   FETCH get_instance INTO instance_rec_;
   CLOSE get_instance;
   RETURN(instance_rec_);
END Get_Instance_Values___;


PROCEDURE Rebuild_Index___ (
   attr_       OUT VARCHAR2,
   index_name_ IN  VARCHAR2 )
IS
BEGIN
   Rebuild_Index(index_name_);
   DELETE FROM database_sys_oracle_index_tab WHERE index_name = index_name_;
   attr_ := Get_Oracle_Index_Attr___(index_name_);
END Rebuild_Index___;

PROCEDURE Rebuild_Unusable_Indexes___(
   table_name_  IN VARCHAR2,
   show_info_   IN BOOLEAN  DEFAULT TRUE ) 
IS
   CURSOR get_indexes IS
      SELECT index_name, index_type
      FROM   user_indexes
      WHERE  table_name = table_name_
      AND    status = 'UNUSABLE';
BEGIN
   FOR rec IN get_indexes LOOP 
      IF (rec.index_type = 'DOMAIN') THEN
         -- Maybe submit a rebuild of Search Domain indexes
         NULL;
      ELSE 
         Installation_SYS.Rebuild_Index(rec.index_name, show_info_);
      END IF;
   END LOOP;
END Rebuild_Unusable_Indexes___;
 
PROCEDURE Validate_Character_Set___ (
   character_set_    IN VARCHAR2 )
IS
   temp_ VARCHAR2(100) := 'QwE'; -- Dummy string
BEGIN
   IF character_set_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   temp_ := convert(temp_, character_set_);
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(service_, 'NO_CHARACTER_SET: A valid character set/file encoding must be used, NULL is not an acceptable value.');
   WHEN OTHERS THEN
      Error_SYS.Appl_General(service_, 'CHARACTER_SET: The character set/file encoding :P1 is not supported by Oracle.', character_set_);
END Validate_Character_Set___;


PROCEDURE Validate_Index___ (
   attr_             OUT VARCHAR2,
   index_name_       IN  VARCHAR2,
   validation_date_  IN  DATE DEFAULT SYSDATE )
IS
   recommendation_   VARCHAR2(100);
   CURSOR get_index IS
   SELECT  del_lf_rows*100/decode(lf_rows,0,1,lf_rows)               percent_deleted,
           (lf_rows-distinct_keys)*100/decode(lf_rows,0,1,lf_rows)   distinctiveness,
           btree_space                                               allocated_space,
           used_space                                                currently_used_space,
           pct_used                                                  percent_used
   FROM    SYS.index_stats
   WHERE   name = index_name_;
   ind_    get_index%ROWTYPE;
BEGIN
   Assert_SYS.Assert_Is_Index(index_name_);
   @ApproveDynamicStatement(2006-01-05,utgulk)
   EXECUTE IMMEDIATE 'ANALYZE INDEX '||index_name_||' VALIDATE STRUCTURE';
   --
   DELETE FROM database_sys_oracle_index_tab WHERE index_name = index_name_;
   OPEN  get_index;
   FETCH get_index INTO ind_;
   IF get_index%FOUND THEN
      IF Nvl(ind_.percent_deleted, 0) >= 20  THEN
         recommendation_ := 'Rebuild index.';
      ELSIF Nvl(ind_.percent_deleted, 0) >= 10  THEN
         recommendation_ := 'Index is candidate to rebuild.';
      ELSE
         recommendation_ := 'No rebuild of index needed.';
      END IF;
      INSERT INTO database_sys_oracle_index_tab (
      index_name,
      validation_date,
      validation_timestamp,
      percent_deleted,
      distinctivness,
      allocated_space,
      currently_used_space,
      percent_used,
      recommendation)
      VALUES (
      index_name_,
      validation_date_,
      SYSDATE,
      ind_.percent_deleted,
      ind_.distinctiveness,
      ind_.allocated_space,
      ind_.currently_used_space,
      ind_.percent_used,
      recommendation_);
   END IF;
   CLOSE get_index;
   attr_ := Get_Oracle_Index_Attr___(index_name_);
END Validate_Index___;


FUNCTION Get_Job_Info___ RETURN VARCHAR2
IS
   temp_ VARCHAR2(1000);
   CURSOR get_info IS
      SELECT info
      FROM ( SELECT substr(message,1,1000) AS info
               FROM v$session_longops t,v$session s
              WHERE t.sid=s.sid 
                AND t.serial# = s.serial#
                AND s.audsid = sys_context('USERENV','SESSIONID')
                AND t.units='Objects'
           ORDER BY t.last_update_time DESC )
       WHERE ROWNUM = 1;
BEGIN
   OPEN get_info;
   FETCH get_info INTO temp_;
   CLOSE get_info;
   RETURN nvl(temp_,'Job Completed');
END Get_Job_Info___;


PROCEDURE Execute_Task___ (
   table_name_     IN VARCHAR2,
   stmt_           IN VARCHAR2,
   chunk_size_     IN NUMBER DEFAULT 10000,
   parallel_level_ IN NUMBER DEFAULT 10,
   lu_             IN VARCHAR2,
   task_name_      IN VARCHAR2 DEFAULT NULL,
   comment_        IN VARCHAR2 DEFAULT NULL )
IS
   task_   VARCHAR2(ORA_MAX_NAME_LEN) := NVL(task_name_, Dbms_Parallel_Execute.Generate_Task_Name);
   status_ NUMBER;
   trg_count_     NUMBER;
   error_message_ VARCHAR2(32000);
   CURSOR get_active_triggers(table_name_ VARCHAR2) IS
      SELECT COUNT(*)
      FROM   dba_triggers t
      WHERE  t.table_name = table_name_
      AND    t.status = 'ENABLED'
      AND    t.table_owner = Fnd_Session_API.Get_App_Owner;
   CURSOR get_parallel_chunks IS
      SELECT error_message
      FROM   USER_PARALLEL_EXECUTE_CHUNKS t
      WHERE  error_message IS NOT NULL;

   PROCEDURE Drop_Tasks___ (
      table_name_ IN VARCHAR2 )
   IS
      CURSOR get_task IS
         SELECT task_name
         FROM user_parallel_execute_tasks
         WHERE table_name = upper(table_name_);
         --WHERE status IN
   BEGIN
      FOR rec IN get_task LOOP
         Dbms_Parallel_Execute.Drop_Task(rec.task_name);
      END LOOP;
   END Drop_Tasks___;

BEGIN
   Transaction_SYS.Log_Progress_Info('Dropping old tasks');
   Drop_Tasks___(table_name_);
   Transaction_SYS.Log_Progress_Info('Creating task');
   Dbms_Parallel_Execute.Create_Task(task_name => task_, comment => comment_);
   Transaction_SYS.Log_Progress_Info('Creating chunks');
   Dbms_Parallel_Execute.Create_Chunks_By_Rowid(task_name   => task_,
                                               table_owner => Fnd_Session_API.Get_App_Owner,
                                               table_name  => table_name_,
                                               by_row      => TRUE,
                                               chunk_size  => chunk_size_);
--  stmt_ := 'UPDATE Test_TAB SET rowkey = sys_guid() WHERE rowkey IS NULL AND rowid BETWEEN :start_id AND :end_id';
   Transaction_SYS.Log_Progress_Info('Executing task');
   Dbms_Parallel_Execute.Run_Task(task_name      => task_,
                                  sql_stmt       => stmt_,
                                  language_flag  => Dbms_Sql.NATIVE,
                                  parallel_level => parallel_level_);
   Transaction_SYS.Log_Progress_Info('Checking status');
   status_ := Dbms_Parallel_Execute.Task_Status(task_);
   IF (status_ IN (Dbms_Parallel_Execute.FINISHED_WITH_ERROR, Dbms_Parallel_Execute.CRASHED)) THEN
      Transaction_SYS.Log_Progress_Info('Resume task');
      Dbms_Parallel_Execute.Resume_Task(task_);
      status_ := Dbms_Parallel_Execute.Task_Status(task_);
   END IF;
   IF (status_ != Dbms_Parallel_Execute.FINISHED) THEN
      IF Fnd_Event_API.Check_Custom_Event(table_name_) OR History_Setting_Attribute_API.Check_History_Enable(table_name_) THEN
         Error_SYS.Appl_General(service_, 'TASK_TRGERROR: RowKey activation failed due to active triggers on table :P1, please check for Custom Events or History Log Settings on logical unit :P2.', table_name_, lu_ );
      ELSE
         OPEN get_parallel_chunks;
         FETCH get_parallel_chunks INTO error_message_;
         IF get_parallel_chunks%FOUND THEN
            CLOSE get_parallel_chunks;
            error_message_ := crlf_||error_message_;
            Error_SYS.Appl_General(service_, 'TASK_CHUNKERROR: RowKey activation on table :P1 failed due to unexpected error. Please take action on error :P2', table_name_, error_message_);
         ELSE
            CLOSE get_parallel_chunks;
            OPEN get_active_triggers(table_name_);
            FETCH get_active_triggers INTO trg_count_;
            CLOSE get_active_triggers;
            IF(trg_count_ > 0) THEN
               Error_SYS.Appl_General(service_, 'TASK_TRGERROR2: RowKey activation failed probably due to active triggers on table :P1, please disable triggers.', table_name_);
            ELSE
               Error_SYS.Appl_General(service_, 'TASK_ERROR: The task :P1 finished with an unknown error.', task_);
            END IF;
         END IF;
      END IF;
   END IF;
   IF (status_ = Dbms_Parallel_Execute.FINISHED) THEN
      Transaction_SYS.Log_Progress_Info('Dropping task');
      Dbms_Parallel_Execute.Drop_Task(task_);
      Transaction_SYS.Log_Progress_Info('Finish task');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      Transaction_SYS.Log_Status_Info('Error when executing task');
      Dbms_Parallel_Execute.Drop_Task(task_);
      RAISE;
END Execute_Task___;


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

-- --------------------------------------------------------------------------
-- Grant_All_Hud_Pres_Objects___
--    This procedure grants all the HUD/LOBBY related presentation objects
--    to the given role.
-- --------------------------------------------------------------------------
PROCEDURE Grant_All_Hud_Pres_Objects___ (
   role_  IN VARCHAR2 )
IS
   CURSOR all_hud_pres_objects IS
      SELECT po_id
        FROM pres_object_tab
       WHERE module = 'FNDBAS'
         AND pres_object_type IN ('HUD', 'LOBBY');
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Grant HUD/LOBBY related Presentation Objects to ' || role_);
   -- Grant: EE_HUD_DESIGN/EE_LOBBY_DESIGN
   --        What ever available will be granted and
   --        the other will be ignored.
   Pres_Object_Util_API.Grant_Pres_Object('EE_HUD_DESIGN', role_);
   Pres_Object_Util_API.Grant_Pres_Object('EE_LOBBY_DESIGN', role_);
   Pres_Object_Util_API.Grant_Pres_Object('EE_LOBBY_IN_CONTEXT_EDIT', role_);
   Pres_Object_Util_API.Grant_Pres_Object('EE_LOBBY_IN_CONTEXT_VIEW', role_);
   --
   -- Grant: All the Presentation Objects of type HUD/LOBBY
   BEGIN
      FOR po IN all_hud_pres_objects LOOP
         BEGIN
            IF (Pres_Object_Util_API.Get_Grant_Info(po.po_id, role_) != 'GRANTED') THEN
               Pres_Object_Util_API.Grant_Pres_Object( po.po_id, role_);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Error when trying to grant PO ID: '||po.po_id);
         END;
      END LOOP;
   END;
END Grant_All_Hud_Pres_Objects___;

-- --------------------------------------------------------------------------
-- Grant_All_Projections___
--    This procedure grants all the Projections to the given role.
-- --------------------------------------------------------------------------
PROCEDURE Grant_All_Non_Admin_Projections___ (
   role_  IN VARCHAR2 )
IS
   CURSOR all_projections IS
      SELECT projection_name
      FROM fnd_projection_tab
      WHERE component NOT IN ('FNDADM', 'FNDBAS','FNDCOB');
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Grant Projections to ' || role_);
   
   BEGIN
      FOR projection_ IN all_projections LOOP
         BEGIN
            Fnd_Projection_Grant_API.Grant_All(projection_.projection_name, role_);
         EXCEPTION
            WHEN OTHERS THEN
               Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Error when trying to grant projection '||projection_.projection_name);
         END;
      END LOOP;
   END;
END Grant_All_Non_Admin_Projections___;

PROCEDURE Grant_All_Projections___ (
   role_  IN VARCHAR2 )
IS
   CURSOR all_projections IS
      SELECT projection_name
      FROM fnd_projection_tab;
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Grant Projections to ' || role_);
   
   BEGIN
      FOR projection_ IN all_projections LOOP
         BEGIN
            Fnd_Projection_Grant_API.Grant_All(projection_.projection_name, role_);
         EXCEPTION
            WHEN OTHERS THEN
               Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Error when trying to grant projection '||projection_.projection_name);
         END;
      END LOOP;
   END;
END Grant_All_Projections___;

FUNCTION Has_Domain_Index___ (
   table_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   index_name_ VARCHAR2(ORA_MAX_NAME_LEN);
   CURSOR check_domain_index IS
      SELECT index_name
      FROM   user_indexes
      WHERE  table_name = table_name_
      AND    index_type = 'DOMAIN';
BEGIN
   OPEN check_domain_index;
   FETCH check_domain_index INTO index_name_;
   CLOSE check_domain_index;
   IF (index_name_ IS NOT NULL) THEN 
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Has_Domain_Index___;

FUNCTION Is_Unicode_Character_Set___ (
   character_set_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   --
   CURSOR get_charset IS
   SELECT 1
  FROM v$nls_valid_values t
 WHERE parameter = 'CHARACTERSET'
   AND value LIKE '%UTF%'
   AND isdeprecated = 'FALSE'
   AND value = character_set_;
   dummy_    NUMBER;
BEGIN
   OPEN get_charset;
   FETCH get_charset INTO dummy_;
   CLOSE get_charset;
   IF (dummy_ = 1) THEN
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Is_Unicode_Character_Set___;

FUNCTION Update_Rowkey___ (
   table_name_ IN VARCHAR2,
   lu_         IN VARCHAR2 ) RETURN BOOLEAN
IS
   task_dropped EXCEPTION;
   PRAGMA       EXCEPTION_INIT(task_dropped, -29498);
   msg_text_ VARCHAR2(300);
   count_    NUMBER;
   stmt_     VARCHAR2(32000) := 'UPDATE /*+ ROWID (dda) */ ' || table_name_ || ' SET rowkey = rowid WHERE rowkey IS NULL';
   stmt2_    VARCHAR2(32000) := 'SELECT COUNT(*) FROM ' || table_name_ || ' WHERE rowkey IS NULL AND rownum < 2';
BEGIN
   Assert_SYS.Assert_Is_Table(table_name_);
   -- Check if there exists rowkey with null
   IF Column_Exist(table_name_, 'ROWKEY') THEN
      @ApproveDynamicStatement(2014-06-27,haarse)
      EXECUTE IMMEDIATE stmt2_ INTO count_;
      -- Only update if there exists rowkey with null
      IF (count_ > 0) THEN
         stmt_ := stmt_ || ' AND rowid BETWEEN :start_id AND :end_id';
         Transaction_SYS.Log_Progress_Info('Before executing task');
         Execute_Task___(table_name_ => table_name_,
                         stmt_ => stmt_,
                         chunk_size_ => 10000,
                         lu_ => lu_,
                         comment_ => 'Enable Rowkey');
         Transaction_SYS.Log_Progress_Info('After executing task');
      END IF;
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Cannot update rowkey on table ['||table_name_||']. The column rowkey is missing.');
      RETURN FALSE;
   END IF;
   RETURN TRUE;
EXCEPTION
   WHEN task_dropped THEN
      msg_text_ := 'Task for update of rowkey in table '||table_name_||' dropped.';
      IF Transaction_SYS.Is_Session_Deferred THEN
         Transaction_SYS.Log_Progress_Info(msg_text_);
      ELSE
         Dbms_Output.Put_Line(msg_text_);
      END IF;
      RETURN FALSE;
END Update_Rowkey___;

PROCEDURE Alter_Table_Rowkey___ (
   table_name_ IN VARCHAR2,
   compile_    IN VARCHAR2 )
IS
   column_  Installation_SYS.Colrec;
BEGIN
   Transaction_SYS.Log_Progress_Info('Before ALTERing ROWKEY.');
   column_ := Set_Column_Values('ROWKEY', 'VARCHAR2(50)', 'N', 'sys_guid()', NULL, 'D');
   Alter_Table_Column(table_name_, 'MODIFY', column_);
   UPDATE database_rowkey_update_tab
   SET time_stamp = SYSDATE,
       state = state_finished_
   WHERE table_name = table_name_;
   IF compile_ = 'TRUE' THEN
      Transaction_SYS.Log_Progress_Info('Before compile of invalid objects');
      Database_SYS.Compile_All_Invalid_Objects;
      Transaction_SYS.Log_Progress_Info('After compile of invalid objects');
   END IF;
END Alter_Table_Rowkey___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Change_Index_Buffer_Pool__ (
   index_name_  IN VARCHAR2,
   buffer_pool_ IN VARCHAR2 DEFAULT 'DEFAULT' )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Change_Index_Buffer_Pool__');
   Installation_SYS.Change_Table_Buffer_Pool__(index_name_, buffer_pool_);
END Change_Index_Buffer_Pool__;


PROCEDURE Change_Table_Buffer_Pool__ (
   table_name_  IN VARCHAR2,
   buffer_pool_ IN VARCHAR2 DEFAULT 'DEFAULT' )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Change_Table_Buffer_Pool__');
   Installation_SYS.Change_Table_Buffer_Pool__(table_name_, buffer_pool_);
END Change_Table_Buffer_Pool__;


PROCEDURE Coalesce_Index__ (
   attr_       OUT VARCHAR2,
   index_name_ IN  VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Coalesce_Index__');
   Installation_SYS.Coalesce_Index__(index_name_);
   DELETE FROM database_sys_oracle_index_tab WHERE index_name = index_name_;
   attr_ := Get_Oracle_Index_Attr___(index_name_);
END Coalesce_Index__;


@UncheckedAccess
FUNCTION Get_Buffer_Pool__ (
   object_name_ IN  VARCHAR2,
   object_type_ IN  VARCHAR2 ) RETURN VARCHAR2
IS
   buffer_pool_ VARCHAR2(30);

   CURSOR get_Table IS
SELECT buffer_pool
FROM   user_tables
WHERE  table_name = object_name_;

   CURSOR get_index IS
SELECT buffer_pool
FROM   user_indexes
WHERE  index_name = object_name_;

BEGIN
   IF    (object_type_ = 'TABLE') THEN
      OPEN  get_table;
      FETCH get_table INTO buffer_pool_;
      CLOSE get_table;
   ELSIF (object_type_ = 'INDEX') THEN
      OPEN  get_index;
      FETCH get_index INTO buffer_pool_;
      CLOSE get_index;
   END IF;
   RETURN buffer_pool_;
END Get_Buffer_Pool__;



@UncheckedAccess
FUNCTION Get_Extents__ (
   segment_name_ IN  VARCHAR2,
   segment_type_ IN VARCHAR2 ) RETURN NUMBER
IS
   extents_ NUMBER;

   CURSOR get_extent IS
SELECT extents
FROM   user_segments
WHERE  segment_name = segment_name_
AND    segment_type = segment_type_;

BEGIN
   OPEN  get_extent;
   FETCH get_extent INTO extents_;
   CLOSE get_extent;
   RETURN extents_;
END Get_Extents__;



@UncheckedAccess
FUNCTION Get_Initialization_Parameter__ (
   parameter_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_parameter IS
   SELECT value
     FROM nls_instance_parameters
    WHERE parameter = parameter_;

   value_  nls_instance_parameters.value%TYPE;
BEGIN
   IF parameter_ = 'NLS_CALENDAR' THEN
         value_ := Database_SYS.Get_Database_Calendar;
   ELSE
         OPEN  get_parameter;
         FETCH get_parameter INTO value_;
         CLOSE get_parameter;
   END IF;
   RETURN(value_);
END Get_Initialization_Parameter__;



@UncheckedAccess
FUNCTION Get_Last_Analyzed__ (
   object_name_ IN  VARCHAR2,
   object_type_ IN  VARCHAR2 ) RETURN DATE
IS
   last_analyzed_ DATE;

   CURSOR get_Table IS
SELECT last_analyzed
FROM   user_tables
WHERE  table_name = object_name_;

   CURSOR get_index IS
SELECT last_analyzed
FROM   user_indexes
WHERE  index_name = object_name_;

BEGIN
   IF    (object_type_ = 'TABLE') THEN
      OPEN  get_table;
      FETCH get_table INTO last_analyzed_;
      CLOSE get_table;
   ELSIF (object_type_ = 'INDEX') THEN
      OPEN  get_index;
      FETCH get_index INTO last_analyzed_;
      CLOSE get_index;
   END IF;
   RETURN last_analyzed_;
END Get_Last_Analyzed__;



@UncheckedAccess
FUNCTION Is_Rowkey_Enabled__ (
   lu_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   nullable_          VARCHAR2(1);
BEGIN
   IF (Dictionary_SYS.Get_Objkey_Info(lu_) = 'NONE') THEN
      RETURN(FALSE);
   END IF;
   nullable_ := Installation_SYS.Get_Column_Nullable(Dictionary_SYS.Get_Base_Table_Name(lu_), 'ROWKEY');
   CASE nullable_   
   WHEN 'N' THEN
      RETURN(TRUE);
   WHEN 'Y' THEN
      RETURN(FALSE);
   ELSE
      RETURN(NULL);
   END CASE;
END Is_Rowkey_Enabled__;

PROCEDURE Rebuild_Index__ (
   attr_       OUT VARCHAR2,
   index_name_ IN  VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Rebuild_Index__');
   Rebuild_Index___(attr_, index_name_);
END Rebuild_Index__;


PROCEDURE Rebuild_Indexes__ (
   percent_deleted_ IN NUMBER DEFAULT 20 )
IS
   attr_    VARCHAR2(2000);
   index_names_     oracle_object_type;
   lock_detected    EXCEPTION;
   PRAGMA           EXCEPTION_INIT(lock_detected, -54);
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Rebuild_Indexes__');
   SELECT index_name
   BULK   COLLECT INTO index_names_
   FROM   database_sys_oracle_index_tab
   WHERE  percent_deleted >= percent_deleted_;
   FOR i IN Nvl(index_names_.FIRST,1)..Nvl(index_names_.LAST,-1) LOOP
      Transaction_SYS.Log_Progress_Info('Rebuilding index ' || index_names_(i));
      BEGIN
         Rebuild_Index___(attr_, index_names_(i));
      EXCEPTION
         WHEN lock_detected THEN
            Transaction_SYS.Log_Status_Info('Rebuilding index ' || index_names_(i) || ' failed, due to blocking locks.', 'WARNING');
         WHEN OTHERS THEN
            Transaction_SYS.Log_Status_Info(Substr('Rebuilding index ' || index_names_(i) || ' failed, due to Oracle error ' || SQLERRM || '.',1,2000), 'WARNING');
      END;
   END LOOP;
   Transaction_SYS.Log_Progress_Info(' ');
END Rebuild_Indexes__;


PROCEDURE Validate_Index__ (
   attr_            OUT VARCHAR2,
   index_name_      IN  VARCHAR2,
   validation_date_ IN  DATE DEFAULT SYSDATE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Validate_Index__');
   Validate_Index___(attr_, index_name_, validation_date_);
END Validate_Index__;


PROCEDURE Validate_Indexes__ (
   max_attempts_ IN NUMBER DEFAULT 5,
   sleep_before_retry_seconds_ IN NUMBER DEFAULT 10 )
IS
   attr_            VARCHAR2(2000);
   validation_date_ DATE := SYSDATE;
   index_names_     oracle_object_type;
   index_names_to_retry_ oracle_object_type;   
   lock_detected    EXCEPTION;
   PRAGMA           EXCEPTION_INIT(lock_detected, -54);
   
   total_indexes_to_validate_ NUMBER;
   completely_failed_indexes_ NUMBER := 0;
   attempt_ INTEGER := 1;
   has_indexes_to_validate_ BOOLEAN := TRUE;
   
   --max_attempts_ Number of times to retry validation of a locked index
   --sleep_before_retry_seconds_ Number of seconds to wait between each retry
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Validate_Indexes__');
   --Check the input parameters
   IF(NOT max_attempts_ > 0) THEN
      Error_SYS.Appl_General (service_, 'INVALID_MAX_ATTEMPTS: MAX_ATTEMPTS_ must be set to a number greater than zero, but it was set to :P1. Please change the parameters of the scheduled job and try again.', TO_CHAR(max_attempts_));
   END IF;
   IF (NOT sleep_before_retry_seconds_ >= 0) THEN
      Error_SYS.Appl_General (service_, 'INVALID_SLEEP_BEFORE_RETRY_SECONDS: SLEEP_BEFORE_RETRY_SECONDS_ must be set to a number greater than or equal to zero, but it was set to :P1. Please change the parameters of the scheduled job and try again.', TO_CHAR(max_attempts_));
   END IF;
   
   @ApproveDynamicStatement(2006-02-15,pemase)
   EXECUTE IMMEDIATE 'TRUNCATE TABLE database_sys_oracle_index_tab';
   
   SELECT index_name
   BULK   COLLECT INTO index_names_
   FROM   user_indexes
   WHERE  nvl(temporary, 'N') = 'N'
   AND    index_type NOT IN ('IOT - TOP','LOB');
   
   Transaction_SYS.Log_Status_Info('Total number of indexes to validate: ' || TO_CHAR(index_names_.count) || '. Number of attempts for locked indexes: ' || TO_CHAR(max_attempts_) || '. Wait between attempts: ' || TO_CHAR(sleep_before_retry_seconds_) || ' second(s)', 'INFO');

   WHILE ((attempt_ <= max_attempts_) AND (has_indexes_to_validate_))
   LOOP
      --Clear up the retry index list
      has_indexes_to_validate_ := FALSE;
      index_names_to_retry_.delete();      
      
      total_indexes_to_validate_ := index_names_.count;      
      Transaction_SYS.Log_Status_Info('Starting attempt ' || attempt_ || ' to validate ' || TO_CHAR(total_indexes_to_validate_) || ' indexes.', 'INFO');
      
      FOR current_index_to_validate_ IN index_names_.FIRST..index_names_.LAST LOOP
         Transaction_SYS.Log_Progress_Info ('Validating index ' || index_names_(current_index_to_validate_) || ' (' || TO_CHAR(current_index_to_validate_) || ' of ' || TO_CHAR(total_indexes_to_validate_) || ' indexes)');

         --Try to validate the index and handle any errors
         BEGIN
            Validate_Index___(attr_, index_names_(current_index_to_validate_), validation_date_);
         EXCEPTION
            WHEN lock_detected THEN
               IF (attempt_ < max_attempts_) THEN
                    Transaction_SYS.Log_Status_Info('Validating index ' || index_names_(current_index_to_validate_) || ' failed, due to blocking locks. Another ' || TO_CHAR(max_attempts_ - attempt_) || ' attempt(s) to validate the indexed will be made.', 'INFO');
               ELSE
                    Transaction_SYS.Log_Status_Info('Validating index ' || index_names_(current_index_to_validate_) || ' failed ' || max_attempts_ || ' validation attempts, due to blocking locks. No further validation attempts will be made.', 'WARNING');
                    completely_failed_indexes_ := completely_failed_indexes_ + 1;
               END IF;               
               index_names_to_retry_(index_names_to_retry_.count() + 1) := index_names_(current_index_to_validate_); --add to the retry list
               has_indexes_to_validate_ := TRUE;
            WHEN OTHERS THEN
               Transaction_SYS.Log_Status_Info(Substr('Validating index ' || index_names_(current_index_to_validate_) || ' failed, due to Oracle error ' || SQLERRM || '.',1,2000), 'WARNING');
               completely_failed_indexes_ := completely_failed_indexes_ + 1;
         END;
      END LOOP;
      
      --Update the status and sleep if there are more runs to do
      IF(has_indexes_to_validate_ AND (attempt_ < max_attempts_)) THEN
         Transaction_SYS.Log_Status_Info('Finished attempt ' || attempt_ || ' of ' || max_attempts_ || ' with ' || TO_CHAR(index_names_to_retry_.count()) || ' locked indexes remaining. Waiting for ' || TO_CHAR(sleep_before_retry_seconds_) || ' second(s) before next attempt.', 'INFO');
         DBMS_LOCK.sleep(sleep_before_retry_seconds_);
      END IF;
      
      index_names_ := index_names_to_retry_;
      attempt_ := attempt_ + 1;
   END LOOP;
   
   IF(completely_failed_indexes_ > 0) THEN
      Transaction_SYS.Log_Status_Info('Validation of indexes finished with ' || TO_CHAR(completely_failed_indexes_) || ' indexes failing validation.', 'WARNING');
   ELSE
      Transaction_SYS.Log_Status_Info('Successfully completed validation of all indexes after ' || TO_CHAR(attempt_ - 1) || ' validation attempts', 'INFO');
   END IF;
   Transaction_SYS.Log_Progress_Info (' ');
END Validate_Indexes__;


PROCEDURE Execute_Analyze_Schema__ (
   attr_ IN VARCHAR2 )
IS
   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
   schema_                 VARCHAR2(ORA_MAX_NAME_LEN);
   method_                 VARCHAR2(260);
   appowner_               VARCHAR2(5);
   dictionary_             VARCHAR2(5);
   fixed_objects_          VARCHAR2(5);
   estimate_percent_       NUMBER;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Execute_Analyze_Schema__');
   -- Retrieve parameters from the attribute string
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'SCHEMA') THEN
         schema_ := value_;
      ELSIF (name_ = 'ESTIMATE_PERCENT') THEN
         estimate_percent_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'METHOD') THEN
         method_ := value_;
      ELSIF (name_ = 'APPOWNER') THEN
         appowner_ := value_;
      ELSIF (name_ = 'DICTIONARY') THEN
         dictionary_ := value_;
      ELSIF (name_ = 'FIXED_OBJECTS') THEN
         fixed_objects_ := value_;
      END IF;
   END LOOP;
   IF (schema_ = 'IFSAPPOWNER') THEN
      schema_ := Fnd_Session_API.Get_App_Owner;
   ELSIF (schema_ = 'IFSIALOWNER') THEN
      schema_ := Fnd_Setting_API.Get_Value('IAL_USER');
   END IF;
   IF (Nvl(appowner_, 'TRUE') = 'TRUE') THEN
      Analyze_Schema___(schema_, method_, estimate_percent_);
   END IF;
END Execute_Analyze_Schema__;


PROCEDURE Execute_Analyze_Others__ (
   system_   IN VARCHAR2 DEFAULT 'TRUE',
   static_   IN VARCHAR2 DEFAULT 'TRUE',
   interval_ IN NUMBER   DEFAULT 60 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Execute_Analyze_Others__');
   --
   -- Analyze system statistics
   --
   IF (system_ = 'TRUE') THEN
      Transaction_SYS.Log_Progress_Info ('Analyzing system statistics ');
      BEGIN
         @ApproveDynamicStatement(2005-02-15,pemase)
         EXECUTE IMMEDIATE 'BEGIN sys.Gather_System_Statistics(:interval); END;' USING interval_;
      EXCEPTION
         WHEN OTHERS THEN
            Transaction_SYS.Log_Status_Info(Substr('Analyzing system statistics objects failed, due to Oracle error ' || SQLERRM || '.',1,2000), 'WARNING');
      END;
   END IF;
   --
   -- Analyze static tables statistics
   --
   IF (static_ = 'TRUE') THEN
      Transaction_SYS.Log_Progress_Info ('Analyzing fixed objects ');
      BEGIN
         Dbms_Stats.Gather_Fixed_Objects_Stats;
      EXCEPTION
         WHEN OTHERS THEN
            Transaction_SYS.Log_Status_Info(Substr('Analyzing fixed objects failed, due to Oracle error ' || SQLERRM || '.',1,2000), 'WARNING');
      END;
   END IF;
   Transaction_SYS.Log_Progress_Info(' ');
END Execute_Analyze_Others__;


FUNCTION Start_SQL_Trace__ (
   enable_ IN VARCHAR2,
   identifier_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   value_          v$diag_info.value%TYPE;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Start_SQL_Trace__');
   Set_Sql_Trace__(enable_, identifier_);
   SELECT value
   INTO value_
   FROM   v$diag_info
   WHERE  name = 'Diag Trace';
   RETURN   value_;
END Start_SQL_Trace__;


PROCEDURE Set_Sql_Trace__ (
   enable_ IN VARCHAR2,
   identifier_ IN VARCHAR2 DEFAULT NULL)
IS
   --label_   VARCHAR2(60);
   FUNCTION Check_Allowed___ RETURN BOOLEAN
   IS
      off_ VARCHAR2(3) := 'OFF';
   BEGIN
      RETURN NVL(Fnd_Setting_API.Get_Value('SQL_TRACE'),off_) <> off_;
   END Check_Allowed___;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Set_Sql_Trace__');
   -- Check if SQL trace is allowed
   IF ( Check_Allowed___ ) THEN
      -- Set identifier that could be used with TRCSESS
      Dbms_Session.Set_Identifier(identifier_);
      IF enable_ = 'TRUE' THEN
         @ApproveDynamicStatement(2006-05-11,haarse)
         EXECUTE IMMEDIATE q'[ALTER SESSION SET TRACEFILE_IDENTIFIER = ifs]';
         @ApproveDynamicStatement(2006-02-15,pemase)
         EXECUTE IMMEDIATE 'ALTER SESSION SET TIMED_STATISTICS = TRUE';
         @ApproveDynamicStatement(2006-02-15,pemase)
         EXECUTE IMMEDIATE q'[ALTER SESSION SET EVENTS '10046 trace name context forever, level 12']';
      ELSIF enable_ = 'FALSE' THEN
         @ApproveDynamicStatement(2006-02-15,pemase)
         EXECUTE IMMEDIATE q'[ALTER SESSION SET EVENTS '10046 trace name context off']';
--         @ApproveDynamicStatement(2006-05-11,haarse)
--         EXECUTE IMMEDIATE q'[ALTER SESSION SET TRACEFILE_IDENTIFIER = '']';
      ELSE
         Error_SYS.Appl_General(service_, 'ERRORPARAMSQLTRACE: Incorrect parameter :P1 in call to Set_Sql_Trace__!', enable_);
      END IF;
   END IF;
END Set_Sql_Trace__;


PROCEDURE Set_Commit_In_Procedure__ (
   enable_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Set_Commit_In_Procedure__');
   IF enable_ = 'TRUE' THEN
      @ApproveDynamicStatement(2006-02-15,pemase)
      EXECUTE IMMEDIATE 'ALTER SESSION ENABLE COMMIT IN PROCEDURE';
   ELSIF enable_ = 'FALSE' THEN
      @ApproveDynamicStatement(2006-02-15,pemase)
      EXECUTE IMMEDIATE 'ALTER SESSION DISABLE COMMIT IN PROCEDURE';
   ELSE
      Error_SYS.Appl_General(service_, 'ERRORPARAMCOMMITPROC: Incorrect parameter :P1 in call to Set_Commit_In_Procedure__!', enable_);
   END IF;
END Set_Commit_In_Procedure__;


PROCEDURE Cleanup_Temporary_Data__
IS
   CURSOR get_table IS
      SELECT table_name, column_name, age
      FROM cleanup_temporary_data_tab;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Cleanup_Temporary_Data__');
   FOR rec_ IN get_table LOOP
      BEGIN
         @ApproveDynamicStatement(2014-06-27,haarse)
         EXECUTE IMMEDIATE 'DELETE FROM '||rec_.table_name||' WHERE '||rec_.column_name||' <= SYSDATE - '||rec_.age;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END LOOP;
END Cleanup_Temporary_Data__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Init_All_Packages_
--   Run all package initializations for packages including the
--   method named "Init". This routine is primary meant to be used
--   for performance purposes and to be able to keep the packaged
--   objects in shared pool.
PROCEDURE Init_All_Packages_ (
   dummy_ IN NUMBER )
IS
   stmt_   VARCHAR2(200);
   CURSOR all_init_pkgs IS
      SELECT name
      FROM  user_source
      WHERE type = 'PACKAGE'
      AND   text LIKE '%PROCEDURE%Init;%';
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Init_All_Packages_');
   FOR pkg IN all_init_pkgs LOOP
      BEGIN
         Assert_SYS.Assert_Is_Package(pkg.name);
         stmt_ := 'BEGIN '||pkg.name||'.Init; END;';
         @ApproveDynamicStatement(2006-01-05,utgulk)
         EXECUTE IMMEDIATE stmt_;
      EXCEPTION
         WHEN OTHERS THEN
            -- If any problems, do not raise, but just printout!
            Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Error in statement: '||stmt_);
      END;
   END LOOP;
END Init_All_Packages_;


@UncheckedAccess
FUNCTION First_Calendar_Date_ RETURN DATE DETERMINISTIC
IS
BEGIN
   RETURN(Get_First_Calendar_Date);
END First_Calendar_Date_;



@UncheckedAccess
FUNCTION Last_Calendar_Date_ RETURN DATE DETERMINISTIC
IS
BEGIN
   RETURN(Get_Last_Calendar_Date);
END Last_Calendar_Date_;


PROCEDURE Read_Projection_Snapshot_
IS
   space_    CONSTANT VARCHAR2(4):= '    '; 
   sys_date_          VARCHAR2(100);
   i_        PLS_INTEGER;
   
   CURSOR get_new_modules IS
      SELECT module,
             name 
      FROM   module_tab 
      WHERE  module IN (SELECT component FROM fnd_projection_tab
                        MINUS
                        SELECT component FROM fnd_projection_snap_tab)
      ORDER BY module;
      

   CURSOR get_new_projections IS
      SELECT component module,
             projection_name,
             Fnd_Projection_API.Get_Description(diff.projection_name) projection_description
      FROM   (SELECT projection_name, component FROM fnd_projection_tab
              MINUS
              SELECT projection_name, component FROM fnd_projection_snap_tab) diff
      WHERE  diff.component NOT IN (SELECT component FROM fnd_projection_tab
                                    MINUS
                                    SELECT component FROM fnd_projection_snap_tab)
      ORDER BY diff.component, diff.projection_name;
         
   CURSOR get_new_proj_actions IS
      SELECT component module, projection_name, action_name
      FROM (SELECT p.component, p.projection_name, pa.action_name
            FROM   fnd_proj_action_tab pa, fnd_projection_tab p
            WHERE  pa.projection_name = p.projection_name
            MINUS
            SELECT p.component, p.projection_name, pa.action_name
            FROM   fnd_proj_action_snap_tab pa, fnd_projection_snap_tab p
            WHERE  pa.projection_name = p.projection_name)
      WHERE (component, projection_name) NOT IN (SELECT component, projection_name FROM fnd_projection_tab
                                                 MINUS
                                                 SELECT component, projection_name FROM fnd_projection_snap_tab)
      ORDER BY component, projection_name, action_name;
         
   CURSOR get_new_proj_entities IS
      SELECT component module, projection_name, entity_name
      FROM (SELECT p.component, p.projection_name, pe.entity_name
            FROM   fnd_proj_entity_tab pe, fnd_projection_tab p
            WHERE  pe.projection_name = p.projection_name
            AND    (pe.operations_allowed <> 'R' OR (pe.projection_name, pe.entity_name) IN (SELECT pea.projection_name, pea.entity_name FROM fnd_proj_ent_action_tab pea))
            MINUS
            SELECT p.component, p.projection_name, pe.entity_name
            FROM   fnd_proj_entity_snap_tab pe, fnd_projection_snap_tab p
            WHERE  pe.projection_name = p.projection_name
            AND    (pe.operations_allowed <> 'R' OR (pe.projection_name, pe.entity_name) IN (SELECT pea.projection_name, pea.entity_name FROM fnd_proj_ent_action_snap_tab pea)))
      WHERE (component, projection_name) NOT IN (SELECT component, projection_name FROM fnd_projection_tab
                                                 MINUS
                                                 SELECT component, projection_name FROM fnd_projection_snap_tab)
      ORDER BY component, projection_name, entity_name;
         
   CURSOR get_new_proj_entity_crud_ops IS
      SELECT p.component module, p.projection_name, pe.entity_name, RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRANSLATE(pe.operations_allowed, pes.operations_allowed, RPAD(' ', LENGTH(pes.operations_allowed), ' ')), ' ', ''), 'C', 'Create,'), 'R', 'Read,'), 'U', 'Update,'), 'D', 'Delete,'), ',') new_crud_operations
      FROM   fnd_proj_entity_tab pe, fnd_projection_tab p, fnd_proj_entity_snap_tab pes, fnd_projection_snap_tab ps
      WHERE  pe.projection_name = p.projection_name
      AND    pe.projection_name = pes.projection_name
      AND    pe.entity_name = pes.entity_name
      AND    pes.projection_name = ps.projection_name
      AND    p.component = ps.component
      AND    REPLACE(TRANSLATE(pe.operations_allowed, pes.operations_allowed, RPAD(' ', LENGTH(pes.operations_allowed), ' ')), ' ', '') IS NOT NULL
      AND    (p.component, p.projection_name, pe.entity_name) NOT IN (SELECT fp.component, fp.projection_name, pe.entity_name
                                                                      FROM   fnd_proj_entity_tab pe, fnd_projection_tab fp
                                                                      WHERE  pe.projection_name = fp.projection_name
                                                                      AND    (pe.operations_allowed <> 'R' OR (pe.projection_name, pe.entity_name) IN (SELECT pea.projection_name, pea.entity_name FROM fnd_proj_ent_action_tab pea))
                                                                      MINUS
                                                                      SELECT ps.component, ps.projection_name, pe.entity_name
                                                                      FROM   fnd_proj_entity_snap_tab pe, fnd_projection_snap_tab ps
                                                                      WHERE  pe.projection_name = ps.projection_name
                                                                      AND    (pe.operations_allowed <> 'R' OR (pe.projection_name, pe.entity_name) IN (SELECT pea.projection_name, pea.entity_name FROM fnd_proj_ent_action_snap_tab pea)))
      ORDER BY p.component, p.projection_name, pe.entity_name;
         
         
   CURSOR get_new_proj_ent_actions IS
      SELECT component module, projection_name, entity_name, action_name
      FROM (SELECT p.component, p.projection_name, pe.entity_name, pea.action_name
            FROM   fnd_proj_ent_action_tab pea, fnd_proj_entity_tab pe, fnd_projection_tab p
            WHERE  pea.projection_name = pe.projection_name
            AND    pea.entity_name = pe.entity_name
            AND    pe.projection_name = p.projection_name
            MINUS
            SELECT p.component, p.projection_name, pe.entity_name, pea.action_name
            FROM   fnd_proj_ent_action_snap_tab pea, fnd_proj_entity_snap_tab pe, fnd_projection_snap_tab p
            WHERE  pea.projection_name = pe.projection_name
            AND    pea.entity_name = pe.entity_name
            AND    pe.projection_name = p.projection_name)
      WHERE (component, projection_name, entity_name) NOT IN (SELECT p.component, p.projection_name, pe.entity_name
                                                              FROM   fnd_proj_entity_tab pe, fnd_projection_tab p
                                                              WHERE  pe.projection_name = p.projection_name
                                                              AND    (pe.operations_allowed <> 'R' OR (pe.projection_name, pe.entity_name) IN (SELECT pea.projection_name, pea.entity_name FROM fnd_proj_ent_action_tab pea))
                                                              MINUS
                                                              SELECT p.component, p.projection_name, pe.entity_name
                                                              FROM   fnd_proj_entity_snap_tab pe, fnd_projection_snap_tab p
                                                              WHERE  pe.projection_name = p.projection_name
                                                              AND    (pe.operations_allowed <> 'R' OR (pe.projection_name, pe.entity_name) IN (SELECT pea.projection_name, pea.entity_name FROM fnd_proj_ent_action_snap_tab pea)))
      ORDER BY component, projection_name, entity_name, action_name;
         
         
   CURSOR get_removed_modules IS
      SELECT module,
             name 
      FROM   module_tab 
      WHERE  module IN (SELECT component FROM fnd_projection_snap_tab
                        MINUS
                        SELECT component FROM fnd_projection_tab)
      ORDER BY module;
      
   CURSOR get_removed_projections IS
      SELECT component module,
             projection_name,
             (SELECT x.description FROM fnd_projection_snap_tab x WHERE x.projection_name = diff.projection_name) projection_description
      FROM   (SELECT projection_name, component FROM fnd_projection_snap_tab
              MINUS
              SELECT projection_name, component FROM fnd_projection_tab) diff
      WHERE  diff.component NOT IN (SELECT component FROM fnd_projection_snap_tab
                                    MINUS
                                    SELECT component FROM fnd_projection_tab)
      ORDER BY diff.component, diff.projection_name;
BEGIN
   SELECT To_Char(SYSDATE, value || ' HH24:MI:SS')
     INTO sys_date_
     FROM nls_session_parameters
    WHERE parameter = 'NLS_DATE_FORMAT';
    
   Dbms_Output.Put_Line('Projection changes '||sys_date_);
   Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('New modules');
   Dbms_Output.Put_Line('===========');
   Dbms_Output.Put_Line(' ');

   Dbms_Output.Put_Line('Module' || space_ || 'Name');
   Dbms_Output.Put_Line(RPAD('-', 6, '-') || space_ || RPAD('-', 50, '-'));
   i_ := 0;
   FOR rec_ IN get_new_modules LOOP      
      Dbms_Output.Put_Line(RPAD(rec_.module, 6) || space_ || rec_.name);
      i_ := i_ + 1;
   END LOOP;
   IF (i_ = 0) THEN
      Dbms_Output.Put_Line('0 Rows');
   END IF;
   
   Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('New projections for existing modules');
   Dbms_Output.Put_Line('====================================');
   Dbms_Output.Put_Line(' ');        
   Dbms_Output.Put_Line('Module'          || space_ || RPAD('Projection Name', 65) || space_ || 'Description');
   Dbms_Output.Put_Line(RPAD('-', 6, '-') || space_ || RPAD('-', 65, '-')          || space_ || RPAD('-', 65, '-'));
   i_ := 0;
   FOR rec_ IN get_new_projections LOOP      
      Dbms_Output.Put_Line(RPAD(rec_.module, 6) || space_ || RPAD(rec_.projection_name, 65) || space_ || rec_.projection_description);
      i_ := i_ + 1;
   END LOOP;
   IF (i_ = 0) THEN
      Dbms_Output.Put_Line('0 Rows');
   END IF;
   
   Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('New actions for existing projections');
   Dbms_Output.Put_Line('====================================');
   Dbms_Output.Put_Line(' ');        
   Dbms_Output.Put_Line('Module'          || space_ || RPAD('Projection Name', 65) || space_ || 'Action Name');
   Dbms_Output.Put_Line(RPAD('-', 6, '-') || space_ || RPAD('-', 65, '-')          || space_ || RPAD('-', 65, '-'));
   i_ := 0;
   FOR rec_ IN get_new_proj_actions LOOP
      Dbms_Output.Put_Line(RPAD(rec_.module, 6) || space_ || RPAD(rec_.projection_name, 65) || space_ || rec_.action_name);
      i_ := i_ + 1;
   END LOOP;
   IF (i_ = 0) THEN
      Dbms_Output.Put_Line('0 Rows');
   END IF;
   
   Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('New entities for existing projections');
   Dbms_Output.Put_Line('=====================================');
   Dbms_Output.Put_Line(' ');        
   Dbms_Output.Put_Line('Module'          || space_ || RPAD('Projection Name', 65) || space_ || 'Entity Name');
   Dbms_Output.Put_Line(RPAD('-', 6, '-') || space_ || RPAD('-', 65, '-')          || space_ || RPAD('-', 65, '-'));
   i_ := 0;
   FOR rec_ IN get_new_proj_entities LOOP
      Dbms_Output.Put_Line(RPAD(rec_.module, 6) || space_ || RPAD(rec_.projection_name, 65) || space_ || rec_.entity_name);
      i_ := i_ + 1;
   END LOOP;
   IF (i_ = 0) THEN
      Dbms_Output.Put_Line('0 Rows');
   END IF;
   
   Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('New CRUD operations for existing projection entities');
   Dbms_Output.Put_Line('====================================================');
   Dbms_Output.Put_Line(' ');        
   Dbms_Output.Put_Line('Module'          || space_ || RPAD('Projection Name', 65) || space_ || RPAD('Entity Name', 65) || space_ || 'New CRUD Operation(s)');
   Dbms_Output.Put_Line(RPAD('-', 6, '-') || space_ || RPAD('-', 65, '-')          || space_ || RPAD('-', 65, '-')      || space_ || RPAD('-', 21, '-'));
   i_ := 0;
   FOR rec_ IN get_new_proj_entity_crud_ops LOOP
      Dbms_Output.Put_Line(RPAD(rec_.module, 6) || space_ || RPAD(rec_.projection_name, 65) || space_ || RPAD(rec_.entity_name, 65) || space_ || rec_.new_crud_operations);
      i_ := i_ + 1;
   END LOOP;
   IF (i_ = 0) THEN
      Dbms_Output.Put_Line('0 Rows');
   END IF;
   
   Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('New entity actions for existing projection entities');
   Dbms_Output.Put_Line('===================================================');
   Dbms_Output.Put_Line(' ');        
   Dbms_Output.Put_Line('Module'          || space_ || RPAD('Projection Name', 65) || space_ || RPAD('Entity Name', 65) || space_ || 'Entity Action Name' );
   Dbms_Output.Put_Line(RPAD('-', 6, '-') || space_ || RPAD('-', 65, '-')          || space_ || RPAD('-', 65, '-')      || space_ || RPAD('-', 65, '-'));
   i_ := 0;
   FOR rec_ IN get_new_proj_ent_actions LOOP
      Dbms_Output.Put_Line(RPAD(rec_.module, 6) || space_ || RPAD(rec_.projection_name, 65) || space_ || RPAD(rec_.entity_name, 65) || space_ || rec_.action_name);
      i_ := i_ + 1;
   END LOOP;
   IF (i_ = 0) THEN
      Dbms_Output.Put_Line('0 Rows');
   END IF;
    
   Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('Removed modules');
   Dbms_Output.Put_Line('===============');
   Dbms_Output.Put_Line(' ');

   Dbms_Output.Put_Line('Module' || space_ || 'Name');
   Dbms_Output.Put_Line(RPAD('-', 6, '-') || space_ || RPAD('-', 50, '-'));
   i_ := 0;
   FOR rec_ IN get_removed_modules LOOP      
      Dbms_Output.Put_Line(RPAD(rec_.module, 6) || space_ || rec_.name);
      i_ := i_ + 1;
   END LOOP;
   IF (i_ = 0) THEN
      Dbms_Output.Put_Line('0 Rows');
   END IF;
   
   Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('Removed projections for existing modules');
   Dbms_Output.Put_Line('========================================');
   Dbms_Output.Put_Line(' ');        
   Dbms_Output.Put_Line('Module'          || space_ || RPAD('Projection Name', 65) || space_ || 'Description');
   Dbms_Output.Put_Line(RPAD('-', 6, '-') || space_ || RPAD('-', 65, '-')          || space_ || RPAD('-', 65, '-'));
   i_ := 0;
   FOR rec_ IN get_removed_projections LOOP      
      Dbms_Output.Put_Line(RPAD(rec_.module, 6) || space_ || RPAD(rec_.projection_name, 65) || space_ || rec_.projection_description);
      i_ := i_ + 1;
   END LOOP;
   IF (i_ = 0) THEN
      Dbms_Output.Put_Line('0 Rows');
   END IF;
END Read_Projection_Snapshot_;


PROCEDURE Read_User_Objects_Snapshot_ (
   list_new_invalids_ VARCHAR2 )
IS
   module_   VARCHAR2(30);
   message_  VARCHAR2(2000);
   full_msg_ BOOLEAN := FALSE;
   invalids_ BOOLEAN := FALSE;
   temp_own_ VARCHAR2(120) := 'X#X';
   CURSOR get_snapshot IS
      SELECT us.owner, us.object_name, us.object_type, us.created, us.last_ddl_time, us.timestamp, uo.status
      FROM all_objects uo, user_objects_snapshot_tab us
      WHERE  us.object_name = uo.object_name (+)
      AND    us.object_type = uo.object_type (+)
      AND    us.owner = uo.owner (+)
      ORDER BY us.object_type, us.object_name;
   CURSOR get_invalids IS
      SELECT owner, object_name, object_type, created, last_ddl_time, timestamp
      FROM all_objects
      WHERE status = 'INVALID'
      AND    object_type = (SELECT Compile_This_Object_Type(object_type) FROM dual)
      AND    owner IN (UPPER('&APPLICATION_OWNER'),UPPER('&IAL_OWNER'))
      AND    (object_name, object_type) NOT IN
      (SELECT object_name, object_type
       FROM   user_objects_snapshot_tab)
      ORDER BY owner, DECODE(object_type, 'PACKAGE', '1', 'VIEW', '2', 'PACKAGE BODY', '3', object_type), object_name;
BEGIN
   IF UPPER(SUBSTR(list_new_invalids_, 1, 1)) = 'Y' THEN
      IF Installation_SYS.Get_Show_Info THEN
         FOR snapshot_rec IN get_snapshot LOOP
            IF (snapshot_rec.status = 'VALID') THEN
               Dbms_Output.Put_Line('Invalid_Object_Check: ' || INITCAP(snapshot_rec.object_type) || ' ' || snapshot_rec.owner || '.' || snapshot_rec.object_name|| ' was fixed during deployment.');
            ELSIF (snapshot_rec.status = 'INVALID') THEN
               Dbms_Output.Put_Line('Invalid_Object_Check: ' || INITCAP(snapshot_rec.object_type) || ' ' || snapshot_rec.owner || '.' || snapshot_rec.object_name|| ' is still invalid after deployment.');
            ELSIF (snapshot_rec.status IS NULL) THEN
               Dbms_Output.Put_Line('Invalid_Object_Check: ' || INITCAP(snapshot_rec.object_type) || ' ' || snapshot_rec.owner || '.' || snapshot_rec.object_name|| ' was removed during deployment.');
            END IF;
         END LOOP;
         FOR invalid_rec IN get_invalids LOOP
            Dbms_Output.Put_Line('Invalid_Object_Check: ' || INITCAP(invalid_rec.object_type) || ' ' || invalid_rec.owner || '.' || invalid_rec.object_name|| ' was added during deployment.');
         END LOOP;
      END IF;
      message_ := crlf_ || 'New invalids after deployment:' || crlf_ || crlf_;
      FOR invalid_rec IN get_invalids LOOP
         invalids_ := TRUE;
         IF length(message_) < 1850 THEN
            IF full_msg_ = FALSE THEN
               IF temp_own_ != invalid_rec.owner THEN
                  temp_own_ := invalid_rec.owner;
                  message_ := message_ || 'Schema ' || UPPER(invalid_rec.owner) || crlf_;
               END IF;
               IF invalid_rec.owner = UPPER('&APPLICATION_OWNER') THEN
                  module_ := Dictionary_SYS.Get_Component(invalid_rec.object_name, REPLACE(invalid_rec.object_type, 'PACKAGE BODY', 'PACKAGE'));
               ELSE
                  module_ := NULL;
               END IF;
               IF module_ IS NOT NULL THEN
                  message_ := message_ || module_ || '\';
               END IF;
               message_ := message_  || invalid_rec.object_name  || ' - '|| INITCAP(invalid_rec.object_type) || crlf_;
            ELSE
               full_msg_ := TRUE;
               message_ := message_ || 'more...';
            END IF;
         END IF;
      END LOOP;
      IF invalids_ THEN
         message_ := message_ || crlf_;
         Error_SYS.Appl_General(service_, 'NEW_INVALIDS: :P1', message_);
      END IF;
   END IF;
END Read_User_Objects_Snapshot_;

PROCEDURE Revalidate_Schema_ (
   schema_       IN VARCHAR2 )
IS
   CURSOR check_invalid_objs IS
      SELECT object_id
      FROM   dba_objects o
      WHERE  status = 'INVALID'
      AND    owner = schema_
      AND NOT EXISTS
      (SELECT 1
       FROM all_errors e
       WHERE e.name = o.object_name
       AND e.owner = o.owner
       AND e.type = o.object_type);
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Revalidate_Schema_');
   FOR obj_id IN check_invalid_objs LOOP
      BEGIN
         @ApproveDynamicStatement(2020-02-07,mabose)
         EXECUTE IMMEDIATE 'BEGIN Dbms_Utility.Validate(:object_id); END;' USING obj_id.object_id;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END LOOP;
END Revalidate_Schema_;      
      
PROCEDURE Compile_Schema_ (
   schema_       IN VARCHAR2,
   do_compile_   IN VARCHAR2 DEFAULT 'Y',
   whole_schema_ IN BOOLEAN DEFAULT FALSE )
IS
   stmt_      VARCHAR2(500);
   dummy_     NUMBER;
   CURSOR check_invalid_objects IS
      SELECT 1
      FROM   dba_objects
      WHERE  status = 'INVALID'
      AND    object_type NOT IN ('QUEUE', 'EVALUATION CONTEXT')
      AND    owner = schema_
      FETCH FIRST ROW ONLY;
   CURSOR check_invalid_bodies IS
      SELECT object_id
      FROM   dba_objects o
      WHERE  status = 'INVALID'
      AND    object_type = 'PACKAGE BODY'
      AND    owner = schema_
      AND NOT EXISTS
      (SELECT 1
       FROM all_errors e
       WHERE e.name = o.object_name
       AND e.owner = o.owner
       AND e.type = o.object_type);
   CURSOR get_objects  (obj_type_ VARCHAR2) IS
      SELECT object_name
      FROM  user_objects
      WHERE object_type = obj_type_
      AND   status = 'INVALID'
      ORDER BY object_name;
   CURSOR get_unhandled_invalid_objects IS
      SELECT owner, object_name, object_type
      FROM   dba_objects
      WHERE  object_type IN ('QUEUE', 'EVALUATION CONTEXT')
      AND    status = 'INVALID'
      AND    owner = schema_
      ORDER BY object_type, object_name;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Compile_Schema_');
   IF UPPER(SUBSTR(do_compile_, 1, 1)) = 'Y' THEN
      -- Only execute Utl_Recomp.Recomp_Parallel if there are any objects it can 
      -- recompile as it takes around 3 seconds otherwise even if there is nothing to do
      OPEN check_invalid_objects;
      FETCH check_invalid_objects INTO dummy_;
      IF (check_invalid_objects%FOUND) THEN
         CLOSE check_invalid_objects;
         @ApproveDynamicStatement(2014-12-19,mabose)
         EXECUTE IMMEDIATE 'BEGIN SYS.Utl_Recomp.Recomp_Parallel(8, :schema_); END;' USING schema_;
         -- Utl_Recomp.Recomp_Parallel leaves from time to time invalids after execution.
         -- Calling Dbms_Utility.Validate to cleanup
         FOR body_id IN check_invalid_bodies LOOP
            @ApproveDynamicStatement(2019-09-20,mabose)
            EXECUTE IMMEDIATE 'BEGIN Dbms_Utility.Validate(:object_id); END;' USING body_id.object_id;
         END LOOP;
      ELSE
         CLOSE check_invalid_objects;
      END IF;
   -- Utl_Recomp.Recomp_Parallel internally uses Dbms_Utility.Validate
   -- There are some object types that cannot be recompiled with this method
   -- Handle those in an alternative way
      FOR obj_ IN get_unhandled_invalid_objects LOOP
         BEGIN
            CASE obj_.object_type
               WHEN ('QUEUE') THEN
                  stmt_ := 'BEGIN Dbms_Aqadm.Alter_Queue(''' || obj_.owner || '.' || obj_.object_name || '''); END;';
                  @ApproveDynamicStatement(2018-04-05,haarse)
                  EXECUTE IMMEDIATE stmt_;
               WHEN ('EVALUATION CONTEXT') THEN
                  stmt_ := 'BEGIN Dbms_Rule_Adm.Alter_Evaluation_Context(''' || obj_.owner || '.' || obj_.object_name || '''); END;';
                  @ApproveDynamicStatement(2018-04-05,haarse)
                  EXECUTE IMMEDIATE stmt_;
            END CASE;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END LOOP;
   END IF;
   IF Installation_SYS.Method_Exist('Xlr_Mv_Util_API', 'Compile_All_Invalid_Mviews') 
   AND schema_ = Fnd_Session_API.Get_App_Owner THEN
      dummy_ := 0;
      FOR rec IN get_objects ('MATERIALIZED VIEW') LOOP
         Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Materialized View '||rec.object_name||' will be rebuilt. A refresh might be needed.');
         dummy_ := 1;
      END LOOP;
      IF dummy_ > 0 THEN 
         stmt_ := 'BEGIN Xlr_Mv_Util_API.Compile_All_Invalid_Mviews; END;';
         @ApproveDynamicStatement(2019-09-17,mabose)
         EXECUTE IMMEDIATE stmt_;
         Compile_All_Invalid_Objects('VIEW');
      END IF;
   END IF;
END Compile_Schema_;

PROCEDURE Feed_Rowkey_Worktable (
   table_name_   IN VARCHAR2,
   active_where_clause_ IN VARCHAR2,
   passive_where_clause_ IN VARCHAR2 DEFAULT NULL,
   priority_     IN NUMBER DEFAULT NULL  )
IS
BEGIN
   INSERT INTO database_rowkey_update_tab
      (table_name, active_where_clause, passive_where_clause, state, priority, time_stamp, total_num_records)
   SELECT table_name_, active_where_clause_, passive_where_clause_, state_to_do_, priority_, sysdate, t.num_rows
   FROM user_tables t, user_objects o
   WHERE t.table_name = table_name_
   AND t.table_name = o.object_name
   AND o.object_type = 'TABLE'
   AND t.temporary = 'N'
   AND SUBSTR(t.table_name, -4) = '_TAB'
   AND (table_name IN
   (SELECT table_name
    FROM user_tab_columns
    WHERE column_name = 'ROWKEY'
    AND nullable = 'Y')
   OR NOT EXISTS
   (SELECT 1
    FROM user_tab_columns utc
    WHERE column_name = 'ROWKEY'
    AND utc.table_name = table_name_))
   AND table_name NOT IN
   (SELECT table_name
    FROM database_rowkey_update_tab)
   AND table_name NOT IN
   (SELECT queue_table
      FROM user_queue_tables)
   UNION
   SELECT table_name_, active_where_clause_, passive_where_clause_, state_finished_, priority_, SYSDATE, t.num_rows
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
    AND nullable = 'N')
   AND table_name NOT IN
   (SELECT table_name
    FROM database_rowkey_update_tab)
   AND table_name NOT IN
   (SELECT queue_table
      FROM user_queue_tables);
END Feed_Rowkey_Worktable;


PROCEDURE Count_Rowkey_Records (
   table_name_ VARCHAR2 DEFAULT NULL )
IS
   total_count_   NUMBER;
   without_count_ NUMBER;
   CURSOR get_tables IS
      SELECT table_name
      FROM database_rowkey_update_tab
      WHERE table_name = NVL(table_name_, table_name);
BEGIN
   FOR rec IN get_tables LOOP
      @ApproveDynamicStatement(2018-01-26,MABOSE)
      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM '||rec.table_name INTO total_count_;
      BEGIN
         @ApproveDynamicStatement(2018-01-26,MABOSE)
         EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM '||rec.table_name||' WHERE rowkey IS NULL' INTO without_count_;
      EXCEPTION
         WHEN OTHERS THEN
            IF (SQLCODE = -00904) THEN  -- we are on apps 75, rowkey column is not added to this table
               without_count_ := total_count_;
            ELSE
               RAISE;
            END IF;
      END;
      UPDATE database_rowkey_update_tab SET total_num_records = total_count_, records_without_rowkey = without_count_ WHERE table_name = rec.table_name;
   END LOOP;
END Count_Rowkey_Records;

PROCEDURE Rowkey_Update_ (
   chunk_size_       IN NUMBER,
   parallel_         IN VARCHAR2,
   exec_time_hrs_    IN NUMBER,
   alter_tables_     IN VARCHAR2,
   only_prio_tables_ IN VARCHAR2 )
IS
   end_time_   DATE := SYSDATE + (exec_time_hrs_ / 24);
   processes_  NUMBER;
   table_name_ VARCHAR2(128);
   count_      NUMBER;
   count_temp_ NUMBER;
   count_init_ NUMBER;
   count_done_ NUMBER;
   schema_     VARCHAR2(128) := USER;
   return_     BOOLEAN;
   prio_tbls_  BOOLEAN := TRUE;
   first_job_  BOOLEAN := TRUE;
   tbls_found_ BOOLEAN := TRUE;
   break_job_  VARCHAR2(128) := 'BREAK_ROWKEY_UPDATE_';
   msg_text_   VARCHAR2(2000);
   prev_dummy_ NUMBER := 1;
   sort_dummy_ NUMBER;
   trigger_name_         user_triggers.trigger_name%TYPE;
   installation_mode_    BOOLEAN := Installation_SYS.Get_Installation_Mode;
   nullable_             user_tab_columns.nullable%TYPE;
   priority_             database_rowkey_update_tab.priority%TYPE;
   where_clause_         database_rowkey_update_tab.active_where_clause%TYPE;
   active_where_clause_  database_rowkey_update_tab.active_where_clause%TYPE;
   passive_where_clause_ database_rowkey_update_tab.passive_where_clause%TYPE;
   true_statement_       CONSTANT VARCHAR2(3) := '1=1';
   CURSOR get_tables IS
      SELECT utc.table_name, 1, priority, nullable, NVL(drk.active_where_clause, true_statement_), NVL(drk.passive_where_clause, true_statement_)
      FROM user_tab_columns utc, user_tables ut, database_rowkey_update_tab drk
      WHERE column_name = 'ROWKEY'
      AND utc.table_name = ut.table_name
      AND utc.table_name = drk.table_name
      AND (drk.state = state_to_do_
      OR alter_tables_ = 'Y' AND state = state_loaded_)
      AND utc.table_name NOT IN
      (SELECT queue_table
       FROM user_queue_tables)
      AND SUBSTR(utc.table_name, INSTR(utc.table_name, '_', -1)) = '_TAB'
      UNION ALL
      SELECT utc.table_name, 2, 9999, nullable, true_statement_, true_statement_
      FROM user_tab_columns utc, user_tables ut
      WHERE column_name = 'ROWKEY'
      AND nullable = 'Y'
      AND utc.table_name = ut.table_name
      AND only_prio_tables_ = 'N'
      AND (utc.table_name NOT IN
      (SELECT table_name
       FROM database_rowkey_update_tab)
      OR utc.table_name IN
      (SELECT table_name
       FROM database_rowkey_update_tab
       WHERE state = state_pre_loaded_))
      AND utc.table_name NOT IN
      (SELECT queue_table
       FROM user_queue_tables)
      AND SUBSTR(utc.table_name, INSTR(utc.table_name, '_', -1)) = '_TAB'
      ORDER BY 2, 3;
   PROCEDURE Update_Status___ (
      table_name_             IN VARCHAR2,
      state_                  IN VARCHAR2 DEFAULT NULL,
      comments_               IN VARCHAR2 DEFAULT NULL,
      records_without_rowkey_ IN NUMBER   DEFAULT NULL,
      total_num_records_      IN NUMBER   DEFAULT NULL )
   IS
      insert_ BOOLEAN := FALSE;
      rec_ database_rowkey_update_tab%ROWTYPE;
      PRAGMA      AUTONOMOUS_TRANSACTION;
   BEGIN
      BEGIN
         SELECT *
         INTO rec_
         FROM database_rowkey_update_tab
         WHERE table_name = table_name_;
      EXCEPTION
         WHEN no_data_found THEN
            insert_ := TRUE;
      END;
      rec_.table_name := table_name_;
      rec_.time_stamp := SYSDATE;
      rec_.state := NVL(state_, rec_.state);
      rec_.comments := NVL(SUBSTR(comments_,1,2000), rec_.comments);
      rec_.records_without_rowkey := NVL(records_without_rowkey_, rec_.records_without_rowkey);
      rec_.total_num_records := NVL(total_num_records_, rec_.total_num_records);
      IF insert_ THEN
         INSERT INTO database_rowkey_update_tab
         VALUES rec_;
      ELSE
         UPDATE database_rowkey_update_tab
         SET ROW = rec_
         WHERE table_name = table_name_;
      END IF;
      @ApproveTransactionStatement(2018-01-11,MABOSE)
      COMMIT;
   END Update_Status___;
   
   FUNCTION Check_For_Triggers___ (
      table_name_ IN VARCHAR2 ) RETURN VARCHAR2 
   IS
      trg_name_ user_triggers.trigger_name%TYPE;
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
      FETCH check_table INTO trg_name_;
      IF check_table%FOUND THEN
         CLOSE check_table;
         RETURN trg_name_;
      ELSE
         CLOSE check_table;
         RETURN NULL;
      END IF;
   END Check_For_Triggers___;
   FUNCTION Update_Rowkey_Seriel___ (
      table_name_   IN VARCHAR2,
      where_clause_ IN VARCHAR2,
      chunck_size_  IN NUMBER ) RETURN BOOLEAN
   IS
      cnt_   NUMBER;
      state_ database_rowkey_update_tab.state%TYPE;
      stmt_  VARCHAR2(32000) := 'SELECT count(*) FROM ' || table_name_ || ' WHERE rowkey IS NULL';
   BEGIN
      @ApproveDynamicStatement(2017-10-06,mabose)
      EXECUTE IMMEDIATE 'UPDATE ' || table_name_ || ' SET rowkey = rowid WHERE rowkey IS NULL AND ROWNUM <= '||chunck_size_||' AND '||where_clause_;
      @ApproveTransactionStatement(2017-10-06,mabose)
      COMMIT;
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveDynamicStatement(2017-10-06,mabose)
         EXECUTE IMMEDIATE stmt_ INTO cnt_;
         count_done_ := NVL(count_init_, 0) - NVL(cnt_, 0);
         msg_text_ := 'Seriel update of rowkey in table '||table_name_||' failed. '||count_done_||' records have been updated and '||cnt_||' records remain. '||SQLERRM;
         IF installation_mode_ THEN
            Dbms_Output.Put_Line('WARNING! '||msg_text_);
         ELSE
            Transaction_SYS.Log_Status_Info(SUBSTR(msg_text_, 1, 2000), 'WARNING');
         END IF;
         BEGIN
            SELECT DECODE(state, state_to_do_, state_pre_loaded_, state_error_)
            INTO state_
            FROM database_rowkey_update_tab
            WHERE table_name = table_name_;
         EXCEPTION
            WHEN no_data_found THEN
               state_ := state_error_;
         END;
         Update_Status___(table_name_, state_, msg_text_, cnt_);
         RETURN FALSE;
   END Update_Rowkey_Seriel___;

   FUNCTION Update_Rowkey_Parallel___ (
      table_name_     IN VARCHAR2,
      where_clause_   IN VARCHAR2,
      chunk_size_     IN NUMBER,
      parallel_level_ IN NUMBER ) RETURN BOOLEAN
   IS
      task_dropped EXCEPTION;
      PRAGMA       EXCEPTION_INIT(task_dropped, -29498);
      cnt_         NUMBER;
      state_       database_rowkey_update_tab.state%TYPE;
      stmt_        VARCHAR2(32000) := 'UPDATE /*+ ROWID (dda) */ ' || table_name_ || ' SET rowkey = rowid WHERE rowkey IS NULL  AND '||where_clause_;
      stmt2_       VARCHAR2(32000) := 'SELECT count(*) FROM ' || table_name_ || ' WHERE rowkey IS NULL';
      CURSOR get_task IS
         SELECT task_name
         FROM user_parallel_execute_tasks
         WHERE table_name = upper(table_name_);
   BEGIN
      FOR rec IN get_task LOOP
         Dbms_Parallel_Execute.Drop_Task(rec.task_name);
      END LOOP;
      stmt_ := stmt_ || ' AND rowid BETWEEN :start_id AND :end_id';
      Execute_Task___(table_name_ => table_name_,
                      stmt_ => stmt_,
                      chunk_size_ => chunk_size_,
                      parallel_level_ => parallel_level_,
                      lu_ => service_,
                      task_name_ => update_rowkey_job_,
                      comment_ => 'Enable Rowkey');
      RETURN TRUE;
   EXCEPTION
      WHEN task_dropped THEN
         @ApproveDynamicStatement(2017-10-06,mabose)
         EXECUTE IMMEDIATE stmt2_ INTO cnt_;
         count_done_ := NVL(count_init_, 0) - NVL(cnt_, 0);
         msg_text_ := 'Task for update of rowkey in table '||table_name_||' dropped. Probably it run out of time. '||count_done_||' records have been updated and '||cnt_||' records remain';
         IF installation_mode_ THEN
            Dbms_Output.Put_Line(msg_text_);
         ELSE
            Transaction_SYS.Log_Status_Info(msg_text_, 'INFO');
         END IF;
         RETURN FALSE;
      WHEN OTHERS THEN
         @ApproveDynamicStatement(2017-10-06,mabose)
         EXECUTE IMMEDIATE stmt2_ INTO cnt_;
         count_done_ := NVL(count_init_, 0) - NVL(cnt_, 0);
         msg_text_ := 'Task for update of rowkey in table '||table_name_||' failed. '||count_done_||' records have been updated and '||cnt_||' records remain. '||SQLERRM;
         IF installation_mode_ THEN
            Dbms_Output.Put_Line('WARNING! '||msg_text_);
         ELSE
            Transaction_SYS.Log_Status_Info(SUBSTR(msg_text_, 1, 2000), 'WARNING');
         END IF;
         BEGIN
            SELECT DECODE(state, state_to_do_, state_pre_loaded_, state_error_)
            INTO state_
            FROM database_rowkey_update_tab
            WHERE table_name = table_name_;
         EXCEPTION
            WHEN no_data_found THEN
               state_ := state_error_;
         END;
         Update_Status___(table_name_, state_, msg_text_, cnt_);
         RETURN FALSE;
   END Update_Rowkey_Parallel___;
BEGIN
   IF UPPER(SUBSTR(parallel_, 1, 1)) = 'Y' THEN
      processes_ := GREATEST(LEAST(CEIL(TO_NUMBER(Get_Init_Ora_Parameter___('job_queue_processes') / 2)), 10), 1);
   ELSE
      processes_ := 1;
   END IF;
   WHILE SYSDATE <= end_time_
   AND tbls_found_ LOOP
      OPEN get_tables;
      FETCH get_tables INTO table_name_, sort_dummy_, priority_, nullable_, active_where_clause_, passive_where_clause_;
      tbls_found_ := get_tables%FOUND;
      IF tbls_found_  THEN
         IF prio_tbls_ THEN
            prio_tbls_ := FALSE;
            msg_text_ := 'Start loading prioritized records for optional rowkeys at ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
         END IF;
         IF installation_mode_ THEN
            Dbms_Output.Put_Line(msg_text_);
         ELSE
            Transaction_SYS.Log_Progress_Info(msg_text_);
         END IF;
      ELSE
         msg_text_ := 'No more rowkeys to enable were found';
         IF installation_mode_ THEN
            Dbms_Output.Put_Line(msg_text_);
         ELSE
            Transaction_SYS.Log_Progress_Info(msg_text_);
         END IF;
      END IF;
      WHILE get_tables%FOUND
      AND SYSDATE <= end_time_ LOOP
         IF prev_dummy_ != sort_dummy_ THEN
            msg_text_ := 'Start loading remaining records for optional rowkeys at ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
            IF installation_mode_ THEN
               Dbms_Output.Put_Line(msg_text_);
            ELSE
               Transaction_SYS.Log_Progress_Info(msg_text_);
            END IF;
            prev_dummy_ := sort_dummy_;
         END IF;
         trigger_name_ := Check_For_Triggers___(table_name_);
         IF trigger_name_ IS NOT NULL THEN
            msg_text_ := 'Updating rowkey for table '||table_name_||' ignored. The active trigger '||trigger_name_||' is blocking this table from being loaded.';
            IF installation_mode_ THEN
               Dbms_Output.Put_Line(msg_text_);
            ELSE
               Transaction_SYS.Log_Progress_Info(msg_text_);
            END IF;
            Update_Status___(table_name_, state_ignored_, msg_text_);
         ELSE
            IF installation_mode_ THEN
               where_clause_ := active_where_clause_;
            ELSE
               where_clause_ := passive_where_clause_;
            END IF;
            IF where_clause_ LIKE '%;%' OR where_clause_ LIKE '%/%' THEN
               msg_text_ := 'Invalid where clause for '||table_name_||'. All records will be updated.';
               IF installation_mode_ THEN
                  Dbms_Output.Put_Line('WARNING! '||msg_text_);
               ELSE
                  Transaction_SYS.Log_Status_Info(msg_text_, 'WARNING');
               END IF;
               where_clause_ := true_statement_;
            END IF;
            @ApproveDynamicStatement(2017-10-06,mabose)
            EXECUTE IMMEDIATE 'SELECT count(*) FROM ' || table_name_ || ' WHERE rowkey IS NULL ' INTO count_;
            count_init_ := count_;
            IF count_ > 0 THEN
               msg_text_ := 'Updating rowkey for table '||table_name_;
               IF where_clause_ != true_statement_ THEN
                  msg_text_ := msg_text_ ||' where '||where_clause_;
               END IF;
               msg_text_ := msg_text_ ||'. '||count_init_|| ' records in total are missing a rowkey. ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
               IF installation_mode_ THEN
                  Dbms_Output.Put_Line(msg_text_);
               ELSE
                  Transaction_SYS.Log_Status_Info(msg_text_, 'INFO');
               END IF;
               Update_Status___(table_name_, state_to_do_, comments_ => msg_text_, records_without_rowkey_ => count_);
            ELSE
               msg_text_ := 'All records in table '||table_name_||' are already updated with a rowkey. ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
               IF installation_mode_ THEN
                  Dbms_Output.Put_Line(msg_text_);
               ELSE
                  Transaction_SYS.Log_Status_Info(msg_text_, 'INFO');
               END IF;
               IF nullable_ = 'N' THEN
                  Update_Status___(table_name_, state_finished_, msg_text_, 0);
               ELSE
                  Update_Status___(table_name_, state_loaded_, msg_text_, 0);
               END IF;
               IF UPPER(alter_tables_) = 'Y' THEN
                  msg_text_ := 'Enabling rowkey for table '||table_name_;
                  IF installation_mode_ THEN
                     Dbms_Output.Put_Line(msg_text_);
                  ELSE
                     Transaction_SYS.Log_Status_Info(msg_text_, 'INFO');
                  END IF;
                  Alter_Table_Rowkey___(table_name_, 'FALSE');
               END IF;
            END IF;
            WHILE count_ > 0
            AND SYSDATE <= end_time_ LOOP
               IF processes_ > 1 
               AND count_ > chunk_size_ THEN
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
                     job_action         => 'DATABASE_SYS.ROWKEY_STOP_UPDATE_',
                     start_date         =>  end_time_,
                     auto_drop          =>  TRUE,
                     comments           => 'Breaks a running Rowkey_Update_ process after the time slot is ended');
                     DBMS_Scheduler.Set_Attribute(
                     name               =>  break_job_,
                     attribute          => 'job_priority',
                     value              =>  2);
                     DBMS_Scheduler.Enable(break_job_);
                     @ApproveTransactionStatement(2017-10-06,mabose)
                     COMMIT;
                  END IF;
                  return_ := Update_Rowkey_Parallel___(table_name_, where_clause_, chunk_size_, processes_);
                  IF return_ THEN
                     IF where_clause_ = true_statement_ THEN
                        count_ := 0;
                     ELSE
                        @ApproveDynamicStatement(2017-10-06,mabose)
                        EXECUTE IMMEDIATE 'SELECT count(*) FROM ' || table_name_ || ' WHERE rowkey IS NULL ' INTO count_;
                     END IF;
                  END IF;
               ELSE
                  return_ := Update_Rowkey_Seriel___(table_name_, where_clause_, chunk_size_);
                  IF return_ THEN
                     @ApproveDynamicStatement(2017-10-06,mabose)
                     EXECUTE IMMEDIATE 'SELECT count(*) FROM ' || table_name_ || ' WHERE rowkey IS NULL ' INTO count_;
                  END IF;
               END IF;
               IF return_ THEN
                  IF (count_ < 1) THEN
                     msg_text_ := 'All rowkeys are updated for table '||table_name_||'  at ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
                     IF installation_mode_ THEN
                        Dbms_Output.Put_Line(msg_text_);
                     ELSE
                        Transaction_SYS.Log_Status_Info(msg_text_, 'INFO');
                     END IF;
                     Update_Status___(table_name_, state_loaded_, msg_text_, count_);
                     IF UPPER(alter_tables_) = 'Y' THEN
                        msg_text_ := 'Enabling rowkey for table '||table_name_;
                        IF installation_mode_ THEN
                           Dbms_Output.Put_Line(msg_text_);
                        ELSE
                           Transaction_SYS.Log_Status_Info(msg_text_, 'INFO');
                        END IF;
                        Alter_Table_Rowkey___(table_name_, 'FALSE');
                     END IF;
                  ELSE
                     count_done_ := count_init_-count_;
                     count_temp_ := count_;
                     @ApproveDynamicStatement(2017-10-06,mabose)
                     EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || table_name_ || ' WHERE rowkey IS NULL AND '||where_clause_ INTO count_;
                     IF count_ < 1 THEN
                        msg_text_ := count_done_||' prioritized records in table '||table_name_||' are updated with a rowkey but '||count_temp_||' records remain. ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS');
                        IF installation_mode_ THEN
                           Dbms_Output.Put_Line(msg_text_);
                        ELSE
                           Transaction_SYS.Log_Status_Info(msg_text_, 'INFO');
                        END IF;
                        Update_Status___(table_name_, state_pre_loaded_, msg_text_, count_temp_);
                     END IF;
                  END IF;
               ELSE
                  count_ := 0;
               END IF;
            END LOOP;
         END IF;
         FETCH get_tables INTO table_name_, sort_dummy_, priority_, nullable_, active_where_clause_, passive_where_clause_;
      END LOOP;
      CLOSE get_tables;
   END LOOP;
   IF processes_ > 1 THEN
      BEGIN
         DBMS_Scheduler.Drop_job(break_job_);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END IF;
   IF  installation_mode_ = FALSE
   AND UPPER(alter_tables_) = 'Y' THEN
      Compile_Schema_(schema_, 'Y');
   END IF;
END Rowkey_Update_;

PROCEDURE Rowkey_Update_ (
   attr_  IN VARCHAR2 )
IS
   chunk_size_       NUMBER;
   parallel_         VARCHAR2(1);
   exec_time_hrs_    NUMBER;
   alter_tables_     VARCHAR2(1);
   only_prio_tables_ VARCHAR2(1);
BEGIN
   chunk_size_       := TO_NUMBER(Client_SYS.Get_Item_Value('CHUNK_SIZE', attr_));
   parallel_         := NVL(UPPER(SUBSTR(Client_SYS.Get_Item_Value('PARALLEL_LEVEL', attr_), 1, 1)), 'Y');
   exec_time_hrs_    := TO_NUMBER(Client_SYS.Get_Item_Value('EXEC_TIME_HRS', attr_));
   alter_tables_     := NVL(UPPER(SUBSTR(Client_SYS.Get_Item_Value('ALTER_TABLES', attr_), 1, 1)), 'N');
   only_prio_tables_ := NVL(UPPER(SUBSTR(Client_SYS.Get_Item_Value('ONLY_PRIO_TABLES', attr_), 1, 1)), 'Y');
   Rowkey_Update_(chunk_size_, parallel_, exec_time_hrs_, alter_tables_, only_prio_tables_);
END Rowkey_Update_;

PROCEDURE Rowkey_Stop_Update_
IS
BEGIN
   Dbms_Parallel_Execute.Drop_Task(update_rowkey_job_);
END Rowkey_Stop_Update_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_SQL_Trace_Dir  RETURN VARCHAR2
IS
   value_  v$diag_info.value%TYPE;
BEGIN
   SELECT value
   INTO value_
   FROM   v$diag_info
   WHERE  name = 'Diag Trace';
   RETURN   value_;
END Get_SQL_Trace_Dir;

PROCEDURE List_Lobs_To_Convert (
   convert_lobs_ IN VARCHAR2 )
IS
   table_name_  user_tab_columns.table_name%TYPE;
   column_name_ user_tab_columns.column_name%TYPE;
   CURSOR get_lobs IS
      SELECT c.table_name, c.column_name
        FROM user_objects o, user_tab_columns c, user_lobs l
       WHERE o.object_name = c.table_name
         AND o.object_type = 'TABLE'
         AND o.temporary = 'N'
         AND SUBSTR(o.OBJECT_NAME, INSTR(o.OBJECT_NAME, '_', -1)) != '_OLD'
         AND NOT REGEXP_LIKE(SUBSTR(o.OBJECT_NAME, INSTR(o.OBJECT_NAME, '_', -1)+1),'[0..9]')
         AND c.table_name = l.table_name
         AND c.column_name = l.column_name
         AND (l.securefile = 'NO' OR l.in_row = 'NO')
         AND c.table_name NOT LIKE 'VMO%TAB'
         AND c.table_name NOT LIKE 'DR$%'
         AND NOT EXISTS (SELECT 1
                           FROM ctx_user_indexes t
                          WHERE t.idx_table = c.table_name
                            AND t.idx_text_name = c.column_name)
         AND NOT EXISTS (SELECT 1
                           FROM user_queue_tables q
                          WHERE q.queue_table = c.table_name)
       ORDER BY c.table_name, c.column_name;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'List_Lobs_To_Convert');
   IF UPPER(SUBSTR(convert_lobs_, 1, 1)) != 'Y' THEN
      Dbms_Output.Put_Line('PROMPT Converting LOB columns into securefiles is not selected');
      Dbms_Output.Put_Line('PROMPT');
   END IF;
      OPEN get_lobs;
      FETCH get_lobs INTO table_name_, column_name_;
      WHILE get_lobs%FOUND LOOP
         IF UPPER(SUBSTR(convert_lobs_, 1, 1)) = 'Y' THEN
            Dbms_Output.Put_Line('SET SERVEROUTPUT ON');
            Dbms_Output.Put_Line('EXEC Installation_SYS.Log_Time_Stamp(''LOB to secure file'','''||lower(table_name_)||'.'||lower(column_name_)||''',''Started'');');
            Dbms_Output.Put_Line('PROMPT Converting LOB column '||column_name_||' in table '||table_name_||' into securefiles');
            Dbms_Output.Put_Line('-- [IFS COMPLETE BLOCK BEGINEND]');
            Dbms_Output.Put_Line('BEGIN');
            Dbms_Output.Put_Line('   Installation_SYS.Alter_Lob_To_Securefile('''||table_name_||''', '''||column_name_||''', FALSE);');
            Dbms_Output.Put_Line('END;');
            Dbms_Output.Put_Line('-- [END IFS COMPLETE BLOCK]');
            Dbms_Output.Put_Line('/');
            Dbms_Output.Put_Line('EXEC Installation_SYS.Log_Time_Stamp(''LOB to secure file'','''||lower(table_name_)||'.'||lower(column_name_)||''',''Finished'');');
         ELSE
            Dbms_Output.Put_Line('PROMPT LOB column '||column_name_||' in table '||table_name_||' is not converted into securefiles');
         END IF;
         FETCH get_lobs INTO table_name_, column_name_;
      END LOOP;
      CLOSE get_lobs;
END List_Lobs_To_Convert;

PROCEDURE List_Rowkeys_To_Enable (
   enable_rowkey_ IN VARCHAR2,
   run_hours_     IN VARCHAR2 )
IS
   prev_table_   user_tab_columns.table_name%TYPE;
   table_name_   user_tab_columns.table_name%TYPE;
   log_id_       NUMBER;
   running_time_ NUMBER;
   default_time_ NUMBER := 100;
   tbls_found_   BOOLEAN := FALSE;
   found_        BOOLEAN := FALSE;
   text_         install_tem_sys_tab.text4%TYPE;
   guid_         install_tem_sys_tab.guid%TYPE := Install_Tem_SYS.Get_Installation_Id_;
   CURSOR get_table IS
      SELECT Dictionary_SYS.Get_Base_Table_Name(text1), log_id
      FROM install_tem_sys_tab
      WHERE guid = guid_
      AND   text2 = 'ENABLE_ROWKEY'
      AND   text4 IS NULL
      AND   category = 'LU_INSTALLATION_SUPPORT'
      UNION
      SELECT UPPER(text1), log_id
      FROM install_tem_sys_tab
      WHERE guid = guid_
      AND   text2 = 'ENABLE_ROWKEY_TABLE'
      AND   text4 IS NULL
      AND   category = 'LU_INSTALLATION_SUPPORT'
      UNION
      SELECT table_name, -1 log_id
      FROM user_tab_columns
      WHERE column_name = 'ROWKEY'
      AND  (nullable = 'Y' OR default_on_null = 'NO')
      AND table_name IN (SELECT object_name 
                         FROM user_objects 
                         WHERE object_type = 'TABLE'
                         AND SUBSTR(object_name, -4) = '_TAB')
      ORDER BY 1, 2 DESC;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'List_Rowkeys_To_Enable');
   IF run_hours_ = 'UNLIMITED' THEN
      running_time_ := default_time_;
   ELSE
      BEGIN
         SELECT TO_NUMBER(run_hours_) INTO running_time_ FROM dual;
      EXCEPTION
         WHEN invalid_number THEN
            running_time_ := default_time_;
            Dbms_Output.Put_Line('PROMPT '||run_hours_||' is not a correct time interval! Only keys designed as mandatory will be enabled');
      END;
   END IF;
   IF UPPER(SUBSTR(enable_rowkey_, 1, 1)) != 'Y' 
   OR running_time_ < 1 THEN
      running_time_ := 0;
      Dbms_Output.Put_Line('PROMPT Enabling of all rowkeys is not selected. Only keys designed as mandatory will be enabled.');
      Dbms_Output.Put_Line('PROMPT');
   END IF;
   prev_table_ := 'XyzZyx';
   OPEN get_table;
   FETCH get_table INTO table_name_, log_id_;
   WHILE get_table%FOUND LOOP
      found_ := FALSE;
      IF prev_table_ != table_name_ THEN
         prev_table_ := table_name_;
         IF (((UPPER(SUBSTR(enable_rowkey_, 1, 1)) = 'Y' OR running_time_ < 1) AND log_id_ < 0)
         OR  log_id_ > 0) THEN
            IF log_id_ > 0 THEN
               IF Is_Rowkey_Enabled_Table(table_name_) = Fnd_Boolean_API.DB_TRUE THEN
                  text_ := 'Rowkey already enabled';
                  UPDATE database_rowkey_update_tab
                  SET time_stamp = SYSDATE,
                      state = state_finished_
                  WHERE table_name = table_name_
                  AND state = state_to_do_;
                  found_ := FALSE;
               ELSE
                  text_ := 'Job for enabling of rowkey is posted in queue';
                  found_ := TRUE;
                  tbls_found_ := TRUE;
               END IF;
            ELSE
               found_ := FALSE;
            END IF;
            IF found_ THEN
               Dbms_Output.Put_Line('PROMPT Loading rowkey for '||table_name_);
               Dbms_Output.Put_Line('EXEC Installation_SYS.Log_Time_Stamp(''Enable Rowkey'','''||table_name_||''',''Started'');');
               Dbms_Output.Put_Line('-- [IFS COMPLETE BLOCK BEGINEND]');
               Dbms_Output.Put_Line('BEGIN');
               Dbms_Output.Put_Line('   Database_SYS.Enable_Rowkey_Table('''||table_name_||''');');
               Dbms_Output.Put_Line('END;');
               Dbms_Output.Put_Line('-- [END IFS COMPLETE BLOCK]');
               Dbms_Output.Put_Line('/');
               Dbms_Output.Put_Line('EXEC Installation_SYS.Log_Time_Stamp(''Enable Rowkey'','''||table_name_||''',''Finished'');');
            END IF;
         ELSE
            Dbms_Output.Put_Line('PROMPT Rowkey is not enabled for '||table_name_);
         END IF;
      ELSE
         IF log_id_ > 0 THEN
            IF Is_Rowkey_Enabled_Table(table_name_) = Fnd_Boolean_API.DB_TRUE THEN
               text_ := 'Rowkey already enabled';
            ELSE
               text_ := 'Job for enabling of rowkey is posted in queue';
            END IF;
         END IF;
      END IF;
      IF log_id_ > 0 THEN
         UPDATE install_tem_sys_tab
         SET text4 = text_,
             last_modified = SYSDATE
         WHERE log_id = log_id_;
      END IF;
      FETCH get_table INTO table_name_, log_id_;
   END LOOP;
   CLOSE get_table;
   IF tbls_found_ THEN
      Dbms_Output.Put_Line('PROMPT Loading rowkey for keys designed as mandatory complete.');
   END IF;
   IF running_time_ > 0 THEN
      Dbms_Output.Put_Line('PROMPT Loading rowkey for optional tables. Table DATABASE_ROWKEY_UPDATE_TAB is continuously updated with the progress.');
      Dbms_Output.Put_Line('EXEC Database_SYS.Rowkey_Update_(100000, ''Y'', '||running_time_||', ''N'', ''N'');');
   END IF;
   IF tbls_found_ OR running_time_ > 0 THEN
      Dbms_Output.Put_Line('EXEC Installation_SYS.Log_Time_Stamp(''Enable Rowkey'',''Enabling rowkey for optional tables'',''Started'');');
      Dbms_Output.Put_Line('EXEC Installation_SYS.Alter_Loaded_Rowkeys_;');
      Dbms_Output.Put_Line('EXEC Installation_SYS.Log_Time_Stamp(''Enable Rowkey'',''Enabling rowkey for optional tables'',''Finished'');');
   END IF;
END List_Rowkeys_To_Enable;

PROCEDURE Enable_Rowkey_Table (
   table_name_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Enable_Rowkey_Table');
   IF (Table_Exist(table_name_)) THEN
      IF (Is_Rowkey_Enabled_Table(table_name_) = Fnd_Boolean_API.DB_FALSE) THEN
         IF (NOT (TO_NUMBER(Get_Init_Ora_Parameter___('job_queue_processes')) > 4)) THEN
            Error_SYS.Appl_General(service_, 'INIT_PARAM: Initialization parameter "job_queue_processes" must be set to a value bigger than 4 in order to enable rowkey.');
         ELSE
            IF Update_Rowkey___(table_name_, service_) THEN
               IF Installation_SYS.Get_Installation_Mode THEN
                  UPDATE database_rowkey_update_tab SET time_stamp = SYSDATE, state = state_loaded_ WHERE table_name = table_name_;
                  IF SQL%NOTFOUND THEN
                     INSERT INTO database_rowkey_update_tab
                        (table_name, time_stamp, state)
                     VALUES
                        (table_name_, SYSDATE, state_loaded_);
                  END IF;
               ELSE
                  Alter_Table_Rowkey___(table_name_, 'FALSE');
               END IF;
            END IF;
         END IF;
      END IF;
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Cannot enable rowkey on an unknown table ['||table_name_||']');
   END IF;
END Enable_Rowkey_Table;


PROCEDURE Enable_Rowkey (
   lu_               IN VARCHAR2,
   online_           IN VARCHAR2 DEFAULT 'TRUE',
   execution_date_   IN DATE DEFAULT NULL,
   compile_          IN VARCHAR2 DEFAULT 'TRUE' )
IS
   table_name_ VARCHAR2(ORA_MAX_NAME_LEN) := Dictionary_Sys.Get_Base_Table_Name(lu_);
   
   PROCEDURE Submit_Task___ (
      lu_               IN VARCHAR2,
      execution_date_   IN DATE )
   IS
      schedule_id_   NUMBER;
      start_date_    DATE       := execution_date_;
      seq_no_        NUMBER;
      next_execution_date_ DATE := execution_date_;
   BEGIN
      Batch_SYS.New_Batch_Schedule(schedule_id_,
                                   next_execution_date_,
                                   start_date_,
                                   NULL,
                                   'Enable Rowkey for ' || lu_,
                                   'DATABASE_SYS.ENABLE_ROWKEY',
                                   'TRUE',
                                   'ON '||to_char(execution_date_, 'YYYY-MM-DD')||' AT '||to_char(execution_date_, 'HH24:MI'));
      Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'LU_', lu_);
      Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'ONLINE_', 'TRUE');
      Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'EXECUTION_DATE_', execution_date_);
   END Submit_Task___;

   PROCEDURE Execute_Background___ (
      lu_               IN VARCHAR2 )
   IS
      id_      NUMBER;
      attr_    VARCHAR2(2000);
   BEGIN
      Client_SYS.Add_To_Attr('LU_', lu_, attr_);
      Client_SYS.Add_To_Attr('ONLINE_', 'TRUE', attr_);
      Transaction_SYS.Deferred_Call(id_, 'DATABASE_SYS.ENABLE_ROWKEY', Argument_Type_API.DB_NORMAL_PARAMETER, attr_, 'Enable rowkey for '||lu_);
   END Execute_Background___;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Enable_Rowkey');
   Transaction_SYS.Log_Progress_Info('Starting');
   -- Make possibility to run as background job
      IF (Dictionary_SYS.Get_Objkey_Info(lu_) = 'NONE') THEN
         Error_SYS.Appl_General(service_, 'LU_NO_OBJKEY: LU :P1 is a LU that is designed without any ROWKEY, so the LU cannot be enabled.', lu_);
      END IF;
   IF (table_name_ IS NULL) THEN
      Error_SYS.Appl_General(service_, 'LU_NO_TABLE: LU :P1 is a LU without any table so it cannot be enabled.', lu_);
   END IF;
   -- Check if rowkey column exists
   IF (NOT Column_Exist(table_name_, 'ROWKEY')) THEN
      Error_SYS.Appl_General(service_, 'NO_ROWKEY: LU :P1 has no column ROWKEY so it cannot be enabled.', lu_);
   END IF;
   -- Check if rowkey constraint exists
   IF (NOT Constraint_Exist(substr(table_name_, 1, length(table_name_) - 4 ) || '_RK')) THEN
      Error_SYS.Appl_General(service_, 'NO_CONSTRAINT: LU :P1 has no unique constraint on ROWKEY so it cannot be enabled.', lu_);
   END IF;
   -- Check if rowkey already is enabled
   IF (Is_Rowkey_Enabled__(lu_)) THEN
      Error_SYS.Appl_General(service_, 'LU_ENABLED: LU :P1 is already enabled.', lu_);
      UPDATE database_rowkey_update_tab
      SET time_stamp = SYSDATE,
          state = state_finished_
      WHERE table_name = table_name_
      AND state = state_to_do_;
   ELSE
      IF (online_ = 'TRUE') THEN
      -- Check if job_queue_processes is set to something bigger that 4, this functionality needs a value bigger than 4
         IF (NOT (TO_NUMBER(Get_Init_Ora_Parameter___('job_queue_processes')) > 4)) THEN
            Error_SYS.Appl_General(service_, 'INIT_PARAM: Initialization parameter "job_queue_processes" must be set to a value bigger than 4 in order to enable rowkey.');
         ELSE
            IF Update_Rowkey___(table_name_, lu_) THEN
               Alter_Table_Rowkey___(table_name_, compile_);
            END IF;
         END IF;
      ELSE
         IF (execution_date_ IS NOT NULL) THEN
            Submit_Task___(lu_, execution_date_);
         ELSE
            Execute_Background___(lu_);
         END IF;
      END IF;
   END IF;
   Transaction_SYS.Log_Progress_Info('Finished');
END Enable_Rowkey;


@UncheckedAccess
FUNCTION Is_Rowkey_Enabled (
   lu_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   CASE (Is_Rowkey_Enabled__(lu_))
   WHEN TRUE THEN
      RETURN('TRUE');
   WHEN FALSE THEN
      RETURN('FALSE');
   ELSE
      RETURN(NULL);
   END CASE;
END Is_Rowkey_Enabled;


@UncheckedAccess
FUNCTION Is_Rowmovement_Enabled (
   table_name_   IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Is_Rowmovement_Enabled(table_name_));
END Is_Rowmovement_Enabled;


@UncheckedAccess
FUNCTION Is_Table_Temporary (
   table_name_   IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Is_Table_Temporary(table_name_));
END Is_Table_Temporary;


PROCEDURE Log_Detail_Time_Stamp (
   module_ IN VARCHAR2,
   type_   IN VARCHAR2,
   what_   IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Log_Detail_Time_Stamp');
   Installation_SYS.Log_Detail_Time_Stamp(module_, type_, what_);
END Log_Detail_Time_Stamp;

@UncheckedAccess
FUNCTION Get_Installation_Mode RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Get_Installation_Mode);
END Get_Installation_Mode;
   
PROCEDURE Add_Lob_Column (
   table_name_  IN VARCHAR2,
   column_      IN ColRec,
   show_info_   IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Add_Lob_Column');
   Installation_SYS.Add_Lob_Column(table_name_, column_, show_info_);
END Add_Lob_Column;


PROCEDURE Alter_Lob_Column (
   table_name_  IN VARCHAR2,
   column_      IN ColRec,
   show_info_   IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Add_Lob_Column');
   Installation_SYS.Alter_Lob_Column(table_name_, column_, show_info_);
END Alter_Lob_Column;


PROCEDURE Alter_Long_Column_To_Lob (
   table_name_       IN VARCHAR2,
   column_name_      IN VARCHAR2,
   tablespace_       IN VARCHAR2,
   logging_          IN BOOLEAN DEFAULT TRUE,
   show_info_        IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Alter_Long_Column_To_Lob');
   Installation_SYS.Alter_Long_Column_To_Lob(table_name_, column_name_, tablespace_, logging_, show_info_);
END Alter_Long_Column_To_Lob;


PROCEDURE Alter_Table (
   table_name_    IN VARCHAR2,
   columns_       IN ColumnTabType,
   show_info_     IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Alter_Table');
   Installation_SYS.Alter_Table(table_name_, columns_, show_info_);
END Alter_Table;


PROCEDURE Alter_Table_Rowmovement (
   table_name_    IN VARCHAR2,
   enable_        IN BOOLEAN,
   show_info_     IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Alter_Table_Rowmovement');
   Installation_SYS.Alter_Table_Rowmovement(table_name_, show_info_);
END Alter_Table_Rowmovement;


PROCEDURE Alter_Table_Column (
   table_name_  IN VARCHAR2,
   alter_type_  IN VARCHAR2,
   column_      IN ColRec,
   show_info_   IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Alter_Table_Column');
   Installation_SYS.Alter_Table_Column(table_name_, alter_type_, column_, show_info_);
END Alter_Table_Column;


PROCEDURE Analyze_Object (
   type_             IN VARCHAR2 DEFAULT 'TABLE',
   schema_           IN VARCHAR2 DEFAULT USER,
   object_name_      IN VARCHAR2,
   method_           IN VARCHAR2 DEFAULT 'AUTOMATIC',
   estimate_percent_ IN NUMBER   DEFAULT NULL,
   cascade_          IN VARCHAR2 DEFAULT 'FALSE' )
IS
   cascade_local_ BOOLEAN;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Analyze_Object');
   IF type_ = 'TABLE' THEN
      IF cascade_ = 'TRUE' THEN
         cascade_local_ := TRUE;
      ELSE
         cascade_local_ := FALSE;
      END IF;
      Gather_Table_Statistics___ (method_           => method_,
                                  schema_           => schema_,
                                  table_name_       => object_name_,
                                  estimate_percent_ => estimate_percent_,
                                  cascade_          => cascade_local_);
   ELSE
      Gather_Index_Statistics___ (method_           => method_,
                                  schema_           => schema_,
                                  index_name_       => object_name_,
                                  estimate_percent_ => estimate_percent_);
   END IF;
END Analyze_Object;


FUNCTION Check_System_Privilege (
   privilege_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR check_privilege IS
      SELECT  1
      FROM    user_sys_privs
      WHERE   privilege = UPPER(privilege_);
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Check_System_Privilege');
   OPEN  check_privilege;
   FETCH check_privilege INTO dummy_;
   IF (check_privilege%FOUND) THEN
      CLOSE check_privilege;
      RETURN TRUE;
   ELSE
      CLOSE check_privilege;
      RETURN FALSE;
   END IF;
END Check_System_Privilege;

@UncheckedAccess
FUNCTION Column_Exist (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Column_Exist(table_name_, column_name_));
END Column_Exist;
@UncheckedAccess
FUNCTION Column_Active (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Column_Active(table_name_, column_name_));
END Column_Active;


@UncheckedAccess
FUNCTION Component_Active (
   module_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
        FROM module_tab
       WHERE module = module_
         AND version IS NOT NULL
         AND version NOT IN ('?', '*')
         AND active = 'TRUE';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Component_Active;

@UncheckedAccess
FUNCTION Component_Exist (
   module_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
        FROM module_tab
       WHERE module = module_
         AND version IS NOT NULL
         AND version NOT IN ('?', '*');
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Component_Exist;

@UncheckedAccess
FUNCTION Get_Component_Version (
   module_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Module_API.Get_Version(module_);
END Get_Component_Version;

@UncheckedAccess
FUNCTION Constraint_Exist (
   constraint_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Constraint_Exist(constraint_name_));
END Constraint_Exist;

@UncheckedAccess
FUNCTION Constraint_Active (
   constraint_name_  IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Constraint_Active(constraint_name_));
END Constraint_Active;



@UncheckedAccess
FUNCTION Context_Exist (
   context_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Context_Exist(context_name_, Fnd_Session_API.Get_App_Owner));
END Context_Exist;


PROCEDURE Create_Constraint (
   table_name_      IN VARCHAR2,
   constraint_name_ IN VARCHAR2,
   columns_         IN ColumnTabType,
   type_            IN VARCHAR2 DEFAULT 'P',
   tablespace_      IN VARCHAR2 DEFAULT NULL,
   storage_         IN VARCHAR2 DEFAULT NULL,
   replace_         IN BOOLEAN  DEFAULT TRUE,
   show_info_       IN BOOLEAN  DEFAULT FALSE,
   use_index_        IN BOOLEAN  DEFAULT TRUE,
   reference_clause_ IN VARCHAR2 DEFAULT NULL,
   on_delete_clause_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Constraint');
   Installation_SYS.Create_Constraint(table_name_,
                                      constraint_name_,
                                      columns_,
                                      type_,
                                      tablespace_,
                                      storage_,
                                      replace_,
                                      show_info_,
                                      use_index_,
                                      reference_clause_,
                                      on_delete_clause_);
END Create_Constraint;


PROCEDURE Create_Context (
   context_name_     IN VARCHAR2,
   context_package_  IN VARCHAR2,
   initialized_      IN VARCHAR2 DEFAULT NULL,
   accessed_         IN VARCHAR2 DEFAULT NULL,
   show_info_        IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Context');
   Installation_SYS.Create_Context(context_name_, context_package_, initialized_, accessed_, show_info_);
END Create_Context;


PROCEDURE Create_Directory (
   directory_name_  IN VARCHAR2,
   path_            IN VARCHAR2,
   read_grant_      IN BOOLEAN  DEFAULT TRUE,
   write_grant_     IN BOOLEAN  DEFAULT TRUE,
   show_info_       IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Directory');
   Installation_SYS.Create_Directory(directory_name_, path_, read_grant_, write_grant_, show_info_);
END Create_Directory;


PROCEDURE Create_Index (
   table_name_      IN VARCHAR2,
   index_name_      IN VARCHAR2,
   columns_         IN ColumnTabType,
   type_            IN VARCHAR2 DEFAULT 'N',
   tablespace_      IN VARCHAR2 DEFAULT NULL,
   storage_         IN VARCHAR2 DEFAULT NULL,
   replace_         IN BOOLEAN  DEFAULT TRUE,
   show_info_       IN BOOLEAN  DEFAULT FALSE,
   exception_       IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Index');
   Installation_SYS.Create_Index(table_name_,
                                 index_name_,
                                 columns_,
                                 type_,
                                 tablespace_,
                                 storage_,
                                 replace_,
                                 show_info_,
                                 exception_);
END Create_Index;


PROCEDURE Create_Sequence (
   sequence_     IN VARCHAR2,
   parameters_   IN VARCHAR2,
   show_info_    IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Sequence');
   Installation_SYS.Create_Sequence(sequence_,
                                    parameters_,
                                    show_info_);
END Create_Sequence;


PROCEDURE Create_Table (
   table_name_    IN VARCHAR2,
   columns_       IN ColumnTabType,
   tablespace_    IN VARCHAR2 DEFAULT NULL,
   storage_       IN VARCHAR2 DEFAULT NULL,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Table');
   Installation_SYS.Create_Table(table_name_,
                                 columns_,
                                 tablespace_,
                                 storage_,
                                 show_info_);
END Create_Table;


PROCEDURE Create_Table_Iot (
   table_name_    IN VARCHAR2,
   columns_       IN ColumnTabType,
   primary_key_   IN ColumnTabType,
   tablespace_    IN VARCHAR2 DEFAULT NULL,
   storage_       IN VARCHAR2 DEFAULT NULL,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Table_Iot');
   Installation_SYS.Create_Table_Iot(table_name_,
                                     columns_,
                                     primary_key_,
                                     tablespace_,
                                     storage_,
                                     show_info_);
END Create_Table_Iot;


PROCEDURE Create_Or_Replace_Table (
   table_name_    IN VARCHAR2,
   columns_       IN ColumnTabType,
   tablespace_    IN VARCHAR2 DEFAULT NULL,
   storage_       IN VARCHAR2 DEFAULT NULL,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Or_Replace_Table');
   Installation_SYS.Create_Or_Replace_Table(table_name_,
                                            columns_,
                                            tablespace_,
                                            storage_,
                                            show_info_);
END Create_Or_Replace_Table;

PROCEDURE Create_Or_Replace_Type (
   type_name_     IN VARCHAR2,
   columns_       IN ColumnTabType,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Or_Replace_Type');
   Installation_SYS.Create_Or_Replace_Type(type_name_,
                                           columns_,
                                           show_info_);
END Create_Or_Replace_Type;

PROCEDURE Create_Or_Replace_Type (
   type_name_     IN VARCHAR2,
   type_table_    IN VARCHAR2,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Or_Replace_Type');
   Installation_SYS.Create_Or_Replace_Type(type_name_,
                                           type_table_,
                                           show_info_);
END Create_Or_Replace_Type;

PROCEDURE Create_Type (
   type_name_     IN VARCHAR2,
   columns_       IN ColumnTabType,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Type');
   Installation_SYS.Create_Type(type_name_,
                                columns_,
                                show_info_);
END Create_Type;

PROCEDURE Create_Type (
type_name_     IN VARCHAR2,
type_table_    IN VARCHAR2,
show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Type');
   Installation_SYS.Create_Type(type_name_,
                                type_table_,
                                show_info_);
END Create_Type;
   
PROCEDURE Create_Or_Replace_Empty_View (
   view_name_    IN VARCHAR2,
   columns_      IN ColumnViewType,
   lu_           IN VARCHAR2 DEFAULT NULL,
   module_       IN VARCHAR2 DEFAULT NULL,
   server_only_  IN VARCHAR2 DEFAULT NULL,
   show_info_    IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Or_Replace_Empty_View');
   Installation_SYS.Create_Or_Replace_Empty_View(view_name_, columns_, lu_, module_, server_only_, show_info_);
END Create_Or_Replace_Empty_View;


PROCEDURE Create_Temporary_Table (
   table_name_    IN VARCHAR2,
   columns_       IN ColumnTabType,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Temporary_Table');
   Installation_SYS.Create_Temporary_Table(table_name_, columns_, show_info_);
END Create_Temporary_Table;

PROCEDURE Create_Trigger (
   trigger_name_  IN VARCHAR2,
   trigger_type_  IN VARCHAR2,
   dml_event_     IN VARCHAR2,
   columns_       IN ColumnTabType,
   table_name_    IN VARCHAR2,
   condition_     IN VARCHAR2,
   plsql_block_   IN VARCHAR2,
   show_info_     IN BOOLEAN  DEFAULT FALSE,
   disabled_      IN BOOLEAN  DEFAULT FALSE ) 
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Create_Trigger');
   Installation_SYS.Create_Trigger(trigger_name_, trigger_type_, dml_event_, columns_, table_name_, condition_, plsql_block_, show_info_, disabled_);
END Create_Trigger;

   
FUNCTION Format_Column (
   column_ IN ColRec,
   type_ IN VARCHAR2 DEFAULT 'TABLE' ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Format_Column');
   RETURN(Installation_SYS.Format_Column(column_, type_));
END Format_Column;


FUNCTION Format_Columns (
   columns_ IN ColumnTabType,
   type_    IN VARCHAR2 DEFAULT 'TABLE' ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Format_Columns');
   RETURN(Installation_SYS.Format_Columns(columns_, type_));
END Format_Columns;


@UncheckedAccess
FUNCTION Functionality_Exist (
   functionality_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Installation_SYS.Functionality_Exist (functionality_));
END Functionality_Exist;



FUNCTION Get_Bind_Length (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN NUMBER
IS
   wrong_data_type EXCEPTION;
   CURSOR get_length IS
   SELECT char_col_decl_length, data_type
   FROM   user_tab_columns
   WHERE  table_name  = upper(table_name_)
   AND    column_name = upper(column_name_);
   bind_length_ NUMBER := 0;
   data_type_   VARCHAR2(ORA_MAX_NAME_LEN);
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Bind_Length');
   OPEN  get_length;
   FETCH get_length INTO bind_length_, data_type_;
   CLOSE get_length;
   IF (data_type_ != 'VARCHAR2') THEN
      RAISE wrong_data_type;
   END IF;
   RETURN(bind_length_);
EXCEPTION
   WHEN wrong_data_type THEN
      Error_SYS.Appl_General(service_, 'BIND_ERR: Can not use this function because the column ":P1" in table ":P2" is not of data type VARCHAR2.',
                             column_name_, table_name_);
END Get_Bind_Length;


@UncheckedAccess
FUNCTION Get_First_Calendar_Date RETURN DATE DETERMINISTIC
IS
BEGIN
   RETURN(first_calendar_gregorian_date_);
/*
IF Get_Database_Calendar = 'GREGORIAN' THEN
   ELSE
      RETURN(first_calendar_persian_date_);
   END IF;
*/
END Get_First_Calendar_Date;



@UncheckedAccess
FUNCTION Get_Last_Calendar_Date RETURN DATE DETERMINISTIC
IS
BEGIN
   RETURN(last_calendar_gregorian_date_);
/*
   IF Get_Database_Calendar = 'GREGORIAN' THEN
   ELSE
      RETURN(last_calendar_persian_date_);
   END IF;
*/
END Get_Last_Calendar_Date;



@UncheckedAccess
FUNCTION Get_First_Character RETURN VARCHAR2
IS
BEGIN
   IF (Is_Unicode_Character_Set___(Get_Database_Charset)) THEN
      RETURN(Unistr('\0000'));
   ELSE
      RETURN(chr(0));
   END IF;
END Get_First_Character;



@UncheckedAccess
FUNCTION Get_Last_Character RETURN VARCHAR2
IS
BEGIN
   IF (Is_Unicode_Character_Set___(Get_Database_Charset)) THEN
      RETURN(Unistr('\FFFF'));
   ELSE
      RETURN(chr(255));
   END IF;
END Get_Last_Character;



FUNCTION Get_Column_Nullable (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Column_Nullable');
   RETURN(Installation_SYS.Get_Column_Nullable (table_name_, column_name_));
END Get_Column_Nullable;


FUNCTION Get_Column_Type (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Column_Type');
   RETURN(Installation_SYS.Get_Column_Type (table_name_, column_name_));
END Get_Column_Type;


FUNCTION Get_Object_Type (
   object_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Object_Type');
   RETURN(Installation_SYS.Get_Object_Type (object_name_));
END Get_Object_Type;


FUNCTION Get_Index_Columns (
   index_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Index_Columns');
   RETURN(Installation_SYS.Get_Index_Columns(index_name_));
END Get_Index_Columns;


FUNCTION Get_Index_Columns (
   table_name_  IN VARCHAR2,
   index_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Index_Columns');
   RETURN(Installation_SYS.Get_Index_Columns(table_name_, index_name_));
END Get_Index_Columns;


FUNCTION Get_Index_Uniqueness (
   table_name_  IN VARCHAR2,
   index_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Index_Uniqueness');
   RETURN(Installation_SYS.Get_Index_Uniqueness(table_name_, index_name_));
END Get_Index_Uniqueness;

@UncheckedAccess
FUNCTION Get_Constraint_Columns (
   constraint_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Constraint_Columns');
   RETURN(Installation_SYS.Get_Constraint_Columns(constraint_name_));
END Get_Constraint_Columns;


@UncheckedAccess
FUNCTION Get_Constraint_Columns (
   table_name_      IN VARCHAR2,
   constraint_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Constraint_Columns');
   RETURN(Installation_SYS.Get_Constraint_Columns(table_name_, constraint_name_));
END Get_Constraint_Columns;


@UncheckedAccess
FUNCTION Get_Time_Offset RETURN NUMBER
IS
   -- Returns Julian timestamp in seconds
BEGIN
   RETURN(To_Number(To_Char(SYSDATE, 'JSSSSS')));
END Get_Time_Offset;



@UncheckedAccess
FUNCTION Index_Exist (
   index_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Index_Exist(index_name_));
END Index_Exist;



@UncheckedAccess
FUNCTION Object_Exist (
   object_name_  IN VARCHAR2,
   object_type_  IN VARCHAR2,
   status_       IN VARCHAR2 DEFAULT NULL ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Object_Exist(object_name_, object_type_, status_));
END Object_Exist;



PROCEDURE Rebuild_Index (
   index_name_ IN VARCHAR2,
   show_info_  IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Rebuild_Index');
   Installation_SYS.Rebuild_Index(index_name_,show_info_);
END Rebuild_Index;


PROCEDURE Obsolete_Column (
   module_      IN VARCHAR2,
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2,
   show_info_   IN BOOLEAN DEFAULT FALSE,
   force_drop_  IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Obsolete_Column');
   Installation_SYS.Obsolete_Column(module_, table_name_, column_name_, show_info_, force_drop_);
END Obsolete_Column;


PROCEDURE Obsolete_Table (
   module_     IN VARCHAR2,
   table_name_ IN VARCHAR2,
   show_info_  IN BOOLEAN DEFAULT FALSE,
   force_drop_ IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Obsolete_Table');
   Installation_SYS.Obsolete_Table(module_, table_name_, show_info_,force_drop_);
END Obsolete_Table;


PROCEDURE Remove_All_Cons_And_Idx (
   table_name_ IN VARCHAR2,
   show_info_  IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_All_Cons_And_Idx');
   Installation_SYS.Remove_All_Cons_And_Idx(table_name_,show_info_);
END Remove_All_Cons_And_Idx;


PROCEDURE Remove_Constraints(
   table_name_      IN VARCHAR2,
   constraint_name_ IN VARCHAR2 DEFAULT '%',
   show_info_       IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Constraints');
   Installation_SYS.Remove_Constraints(table_name_, constraint_name_, show_info_);
END Remove_Constraints;


PROCEDURE Remove_Indexes (
   table_name_ IN VARCHAR2,
   index_name_ IN VARCHAR2 DEFAULT '%',
   show_info_  IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Indexes');
   Installation_SYS.Remove_Indexes(table_name_, index_name_, show_info_);
END Remove_Indexes;


PROCEDURE Remove_Lob_Column (
   table_name_  IN VARCHAR2,
   column_      IN ColRec,
   show_info_   IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Lob_Column');
   Installation_SYS.Remove_Lob_Column(table_name_, column_, show_info_);
END Remove_Lob_Column;


PROCEDURE Remove_Materialized_View (
   view_name_ IN VARCHAR2,
   show_info_ IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Materialized_View');
   Installation_SYS.Remove_Materialized_View(view_name_, show_info_);
END Remove_Materialized_View;


PROCEDURE Remove_Materialized_View_Log (
   table_name_ IN VARCHAR2,
   show_info_  IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Materialized_View_Log');
   Installation_SYS.Remove_Materialized_View_Log(table_name_, show_info_);
END Remove_Materialized_View_Log;


PROCEDURE Remove_Package (
   package_name_   IN VARCHAR2,
   show_info_      IN BOOLEAN DEFAULT FALSE,
   remove_context_ IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Package');
   Installation_SYS.Remove_Package(package_name_, show_info_, remove_context_);
END Remove_Package;


PROCEDURE Remove_Sequence (
   sequence_name_ IN VARCHAR2,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Sequence');
   Installation_SYS.Remove_Sequence(sequence_name_, show_info_);
END Remove_Sequence;


PROCEDURE Remove_Table (
   table_name_ IN VARCHAR2,
   show_info_  IN BOOLEAN DEFAULT FALSE,
   purge_      IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Table');
   Installation_SYS.Remove_Table(table_name_, show_info_, purge_);
END Remove_Table;


PROCEDURE Remove_Trigger (
   trigger_name_       IN VARCHAR2,
   show_info_          IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Trigger');
   Installation_SYS.Remove_Trigger(trigger_name_, show_info_);
END Remove_Trigger;


PROCEDURE Remove_Type (
   type_name_       IN VARCHAR2,
   show_info_       IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Type');
   Installation_SYS.Remove_Type(type_name_, show_info_);
END Remove_Type;


PROCEDURE Remove_View (
   view_name_ IN VARCHAR2,
   show_info_ IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_View');
   Installation_SYS.Remove_View(view_name_, show_info_);
END Remove_View;


PROCEDURE Remove_Context (
   context_name_ IN VARCHAR2,
   show_info_    IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Context');
   Installation_SYS.Remove_Context(context_name_, show_info_);
END Remove_Context;


PROCEDURE Remove_Projection (
   projection_name_ IN VARCHAR2,
   show_info_       IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Projection');
   Fnd_Projection_API.Remove_Projection(projection_name_, show_info_);
END Remove_Projection;


PROCEDURE Remove_Client (
   client_name_ IN VARCHAR2,
   show_info_   IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Client');
   Model_Design_SYS.Remove_Client_Metadata(client_name_);
   
   Fnd_Projection_Usage_API.Clear_Client_Refs(client_name_);
   Fnd_Proj_Action_Usage_API.Clear_Client_Refs(client_name_);
   Fnd_Proj_Ent_Action_Usage_API.Clear_Client_Refs(client_name_);

   Navigator_SYS.Clean_Navigation_For_Client(client_name_);
   IF (NOT Get_Installation_Mode) THEN
      Navigator_SYS.Insert_Navigator_Entries();
   END IF;   
END Remove_Client;


PROCEDURE Remove_App (
   app_name_  IN VARCHAR2,
   show_info_ IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_App');
   Model_Design_SYS.Remove_App_Metadata(app_name_);
END Remove_App;


PROCEDURE Remove_Outbound (
   outbound_name_ IN VARCHAR2,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Remove_Outbound');
   Model_Design_SYS.Remove_Outbound_Metadata(outbound_name_);
END Remove_Outbound;


PROCEDURE Remove_Inactive_Metadata_(
   show_info_     IN BOOLEAN DEFAULT FALSE,
   simulate_only_ IN BOOLEAN DEFAULT FALSE,
   force_all_     IN BOOLEAN DEFAULT FALSE)
IS
   count_ NUMBER := 0;
   
   CURSOR inactive_modules IS
      SELECT module, included_in_delivery
         FROM  module_tab
         WHERE active = 'FALSE'
         ORDER BY module;
         
   PROCEDURE Show_Info(
      text_ IN VARCHAR2)
   IS
   BEGIN
      IF (simulate_only_) THEN
         Dbms_Output.Put_Line('(Simulation) ' || text_);     
      ELSIF (show_info_) THEN
         Dbms_Output.Put_Line(text_);     
      END IF;
   END Show_Info;
BEGIN
   Show_Info('-------- START REMOVING INACTIVE METADATA --------');   
   
   FOR rec_ IN inactive_modules LOOP
      IF (force_all_ OR rec_.included_in_delivery = 'TRUE') THEN
         count_ := count_ + 1;
         Model_Design_SYS.Remove_Component_Metadata_(rec_.module, show_info_, simulate_only_);
      END IF;
   END LOOP;
   
   Show_Info('Removed components: ' || count_);
   Show_Info('---------- END REMOVING INACTIVE METADATA --------');   
END Remove_Inactive_Metadata_;


PROCEDURE Rename_Column (
   table_name_       IN VARCHAR2,
   new_column_name_  IN VARCHAR2,
   old_column_name_  IN VARCHAR2,
   show_info_        IN BOOLEAN  DEFAULT FALSE,
   exception_        IN BOOLEAN  DEFAULT TRUE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Rename_Column');
   Installation_SYS.Rename_Column(table_name_,
                                  new_column_name_,
                                  old_column_name_,
                                  show_info_,
                                  exception_);
END Rename_Column;


PROCEDURE Rename_Table (
   source_table_       IN VARCHAR2,
   target_table_       IN VARCHAR2,
   show_info_          IN BOOLEAN DEFAULT FALSE,
   exception_          IN BOOLEAN DEFAULT TRUE,
   remove_indexes_     IN BOOLEAN DEFAULT TRUE,
   remove_constraints_ IN BOOLEAN DEFAULT TRUE,
   remove_triggers_    IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Rename_Table');
   Installation_SYS.Rename_Table (source_table_,
                                  target_table_,
                                  show_info_,
                                  exception_,
                                  remove_indexes_,
                                  remove_constraints_,
                                  remove_triggers_);
END Rename_Table;


PROCEDURE Rename_Sequence (
   source_sequence_  IN VARCHAR2,
   target_sequence_  IN VARCHAR2,
   show_info_        IN BOOLEAN  DEFAULT FALSE,
   exception_        IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Rename_Sequence');
   Installation_SYS.Rename_Sequence(source_sequence_,
                                    target_sequence_,
                                    show_info_,
                                    exception_);
END Rename_Sequence;


PROCEDURE Rename_Constraint (
   table_name_         IN VARCHAR2,
   source_constraint_  IN VARCHAR2,
   target_constraint_  IN VARCHAR2,
   show_info_          IN BOOLEAN  DEFAULT FALSE,
   exception_          IN BOOLEAN  DEFAULT TRUE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Rename_Constraint');
   Installation_SYS.Rename_Constraint(table_name_, source_constraint_, target_constraint_, show_info_, exception_);
END Rename_Constraint;

   
PROCEDURE Rename_Index (
   source_index_       IN VARCHAR2,
   target_index_       IN VARCHAR2,
   show_info_          IN BOOLEAN  DEFAULT FALSE,
   exception_          IN BOOLEAN  DEFAULT TRUE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Rename_Index');
   Installation_SYS.Rename_Index(source_index_, target_index_, show_info_, exception_);
END Rename_Index;

PROCEDURE Reset_Column (
   column_ IN OUT ColRec )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Reset_Column');
   Installation_SYS.Reset_Column(column_);
END Reset_Column;


PROCEDURE Reset_Column_Table (
   columns_ IN OUT ColumnTabType )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Reset_Column_Table');
   Installation_SYS.Reset_Column_Table (columns_);
END Reset_Column_Table;


FUNCTION Set_Column_Values (
   column_name_   IN     VARCHAR2,
   data_type_     IN     VARCHAR2 DEFAULT NULL,
   nullable_      IN     VARCHAR2 DEFAULT NULL,
   default_value_ IN     VARCHAR2 DEFAULT NULL,
   lob_parameter_ IN     VARCHAR2 DEFAULT NULL,
   keep_default_  IN     VARCHAR2 DEFAULT NULL ) RETURN ColRec
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Set_Column_Values');
   RETURN(Installation_SYS.Set_Column_Values(column_name_, data_type_, nullable_, default_value_, lob_parameter_, keep_default_));
END Set_Column_Values;


PROCEDURE Set_Table_Column (
   columns_ IN OUT ColumnTabType,
   column_  IN     ColRec )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Set_Table_Column');
   Installation_SYS.Set_Table_Column(columns_, column_);
END Set_Table_Column;


PROCEDURE Set_Table_Column (
   columns_       IN OUT ColumnTabType,
   column_name_   IN     VARCHAR2,
   data_type_     IN     VARCHAR2 DEFAULT NULL,
   nullable_      IN     VARCHAR2 DEFAULT NULL,
   default_value_ IN     VARCHAR2 DEFAULT NULL,
   lob_parameter_ IN     VARCHAR2 DEFAULT NULL,
   keep_default_  IN     VARCHAR2 DEFAULT NULL )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Set_Table_Column');
   Installation_SYS.Set_Table_Column(columns_, column_name_, data_type_, nullable_, default_value_, lob_parameter_, keep_default_);
END Set_Table_Column;


FUNCTION Set_View_Column_Values (
   column_name_    IN     VARCHAR2,
   column_source_  IN     VARCHAR2,
   column_comment_ IN     VARCHAR2 DEFAULT NULL ) RETURN ColViewRec
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Set_View_Column_Values');
   RETURN Installation_SYS.Set_View_Column_Values(column_name_, column_source_, column_comment_);
END Set_View_Column_Values;


PROCEDURE Set_View_Column (
   columns_ IN OUT ColumnViewType,
   column_  IN     ColViewRec )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Set_View_Column');
   Installation_SYS.Set_View_Column(columns_, column_);
END Set_View_Column;


PROCEDURE Set_View_Column (
   columns_        IN OUT ColumnViewType,
   column_name_    IN     VARCHAR2,
   column_source_  IN     VARCHAR2,
   column_comment_ IN     VARCHAR2 DEFAULT NULL)
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Set_View_Column');
   Installation_SYS.Set_View_Column(columns_, column_name_, column_source_, column_comment_);
END Set_View_Column;

@UncheckedAccess
FUNCTION Table_Exist (
   table_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Table_Exist(table_name_));
END Table_Exist;

@UncheckedAccess
FUNCTION Table_Active (
   table_name_  IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Table_Active(table_name_));
END Table_Active;



@UncheckedAccess
FUNCTION Trigger_Exist (
   trigger_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Trigger_Exist(trigger_name_));
END Trigger_Exist;


@UncheckedAccess
FUNCTION View_Exist (
   view_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.View_Exist(view_name_));
END View_Exist;

@UncheckedAccess
FUNCTION View_Active (
   view_name_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.View_Active(view_name_));
END View_Active;


@UncheckedAccess
FUNCTION Package_Exist (
   package_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Package_Exist(package_name_));
END Package_Exist;

@UncheckedAccess
FUNCTION Package_Active (
   package_name_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Package_Active(package_name_));
END Package_Active;


@UncheckedAccess
FUNCTION Primary_Key_Constraint_Exist (
   table_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Primary_Key_Constraint_Exist(table_name_));
END Primary_Key_Constraint_Exist;

@UncheckedAccess
FUNCTION Primary_Key_Constraint_Active (
   table_name_ IN VARCHAR2) RETURN BOOLEAN

IS
BEGIN
   RETURN(Installation_SYS.Primary_Key_Constraint_Active(table_name_));
END Primary_Key_Constraint_Active;



@UncheckedAccess
FUNCTION Mtrl_View_Exist (
   mtrl_view_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Mtrl_View_Exist(mtrl_view_));
END Mtrl_View_Exist;



@UncheckedAccess
FUNCTION Mtrl_View_Log_Exist (
   mtrl_view_log_tbl_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Mtrl_View_Log_Exist(mtrl_view_log_tbl_));
END Mtrl_View_Log_Exist;


@UncheckedAccess
FUNCTION Method_Exist (
   package_name_ IN VARCHAR2,
   method_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Method_Exist(package_name_, method_name_));
END Method_Exist;

@UncheckedAccess
FUNCTION Method_Active(
   package_name_ IN VARCHAR2,
   method_name_  IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Method_Active(package_name_, method_name_));
END Method_Active;



PROCEDURE Register_Db_Patch (
   module_       IN VARCHAR2,
   patch_number_ IN NUMBER,
   description_  IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Register_Db_Patch');
   Installation_SYS.Register_Db_Patch(module_, patch_number_, description_);
END Register_Db_Patch;


@UncheckedAccess
FUNCTION Is_Db_Patch_Registered (
   module_       IN VARCHAR2,
   patch_number_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Installation_SYS.Is_Db_Patch_Registered(module_, patch_number_);
END Is_Db_Patch_Registered;


PROCEDURE Clear_Db_Patch_Registration (
   module_       IN VARCHAR2,
   patch_number_ IN NUMBER DEFAULT NULL )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Clear_Db_Patch_Registration');
   Installation_SYS.Clear_Db_Patch_Registration(module_, patch_number_);
END Clear_Db_Patch_Registration;

PROCEDURE Disable_Trigger (
   trigger_name_ IN VARCHAR2,
   show_info_    IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Disable_Trigger');
   Installation_SYS.Disable_Trigger(trigger_name_, show_info_);
END Disable_Trigger;

PROCEDURE Enable_Trigger (
   trigger_name_ IN VARCHAR2,
   show_info_    IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Enable_Trigger');
   Installation_SYS.Enable_Trigger(trigger_name_, show_info_);
END Enable_Trigger;

@UncheckedAccess
FUNCTION Get_Database_Calendar RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   --
   -- Get server instance calendar
   --
   RETURN('GREGORIAN');
   --RETURN(Get_Initialization_Parameter__('NLS_CALENDAR'));
END Get_Database_Calendar;



@UncheckedAccess
FUNCTION Get_Database_Host RETURN VARCHAR2
IS
   instance_rec_  sys.v_$instance%ROWTYPE;
BEGIN
   --
   -- Get server host name
   --
   instance_rec_ := Get_Instance_Values___;
   RETURN(instance_rec_.host_name);
END Get_Database_Host;



@UncheckedAccess
FUNCTION Get_Database_Sid RETURN VARCHAR2
IS
   instance_rec_  sys.v_$instance%ROWTYPE;
BEGIN
   --
   -- Get server host name
   --
   instance_rec_ := Get_Instance_Values___;
   RETURN(instance_rec_.instance_name);
END Get_Database_Sid;



@UncheckedAccess
FUNCTION Get_Database_Charset RETURN VARCHAR2
IS
BEGIN
   --
   -- Get server instance character set
   -- NLS_CHARACTERSET cannot be change while the DB is running. Therefore loading once is enough.
   IF micro_cache_nls_charset_ IS NULL THEN
      SELECT value
         INTO micro_cache_nls_charset_
         FROM  nls_database_parameters
         WHERE parameter = 'NLS_CHARACTERSET';
   END IF;
   RETURN micro_cache_nls_charset_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Database_Charset;


@UncheckedAccess
FUNCTION Get_Database_Name RETURN VARCHAR2
IS
   name_ sys.v_$database.name%TYPE;
   CURSOR get_name IS
      SELECT name
         FROM sys.v_$database;
BEGIN
   --
   -- Get server instance name
   --
   OPEN  get_name;
   FETCH get_name INTO name_;
   CLOSE get_name;
   RETURN(name_);
END Get_Database_Name;



@UncheckedAccess
FUNCTION Get_Database_Version RETURN VARCHAR2
IS
   instance_rec_  sys.v_$instance%ROWTYPE;
BEGIN
   --
   -- Get server instance version
   --
   instance_rec_ := Get_Instance_Values___;
   RETURN(instance_rec_.version);
END Get_Database_Version;



PROCEDURE Get_Database_Properties (
   name_    OUT VARCHAR2,
   version_ OUT VARCHAR2,
   charset_ OUT VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Database_Properties');
   --
   -- Get server instance name
   --
   name_ := Get_Database_Name;
   --
   -- Get server instance version
   --
   version_ := Get_Database_Version;
   --
   -- Get server instance character set
   --
   charset_ := Get_Database_Charset;
   --
END Get_Database_Properties;


@UncheckedAccess
FUNCTION Get_Formatted_Date (
   date_ IN DATE DEFAULT Sysdate ) RETURN VARCHAR2
IS
BEGIN
   RETURN to_char(date_, Language_Code_API.Get_Nls_Date_Format(Fnd_Session_Api.Get_Language));
END Get_Formatted_Date;


@UncheckedAccess
FUNCTION Get_Formatted_Datetime (
   date_ IN DATE DEFAULT Sysdate ) RETURN VARCHAR2
IS
BEGIN
   RETURN to_char(date_, Language_Code_API.Get_Nls_Date_Format(Fnd_Session_Api.Get_Language) || ' ' ||
                         Replace(Language_Code_API.Get_Nls_Time_Format(Fnd_Session_Api.Get_Language),'XFF',''));
END Get_Formatted_Datetime;


@UncheckedAccess
FUNCTION Get_Formatted_Time (
   date_ IN DATE DEFAULT Sysdate ) RETURN VARCHAR2
IS
BEGIN
   RETURN to_char(date_, Replace(Language_Code_API.Get_Nls_Time_Format(Fnd_Session_Api.Get_Language),'XFF',''));
END Get_Formatted_Time;


@UncheckedAccess
FUNCTION Get_Formatted_Timestamp (
   date_ IN TIMESTAMP_UNCONSTRAINED DEFAULT SYSTIMESTAMP ) RETURN VARCHAR2
IS
   format_ nls_session_parameters.value%TYPE;
   CURSOR get_attr IS
      SELECT n.value
      FROM nls_session_parameters n
      WHERE n.parameter = 'NLS_TIMESTAMP_FORMAT';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO format_;
   CLOSE get_attr;
   RETURN to_char(date_, format_);
END Get_Formatted_Timestamp;


@UncheckedAccess
FUNCTION Asciistr (
   value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Standard.Asciistr(value_));
END Asciistr;



@UncheckedAccess
FUNCTION Asciistr_Xml (
   value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   return_ VARCHAR2(32767);
   temp_   VARCHAR2(100);
BEGIN
   IF value_ IS NULL THEN
      RETURN(NULL);
   END IF;
   FOR i IN 1..length(value_) LOOP
      temp_ := Substr(value_, i, 1);
      IF ascii(temp_) > 127 THEN
         temp_ := Replace(Database_SYS.Asciistr(temp_), '\', xml_start_)||xml_end_;
      END IF;
      return_ := return_ || temp_;
   END LOOP;
   RETURN(return_);
END Asciistr_Xml;



@UncheckedAccess
FUNCTION Unistr (
   value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Standard.Unistr(value_));
EXCEPTION
   WHEN OTHERS THEN
      RETURN (value_);
END Unistr;



@UncheckedAccess
FUNCTION Unistr_Xml (
   value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   return_ VARCHAR2(32767);
   from_   BINARY_INTEGER := 1;
   end_    BINARY_INTEGER := 1;
   start_  BINARY_INTEGER := instr(value_, xml_start_, from_);
BEGIN
   IF value_ IS NULL THEN
      RETURN(NULL);
   END IF;
   WHILE start_ > 0 LOOP
      end_    := instr(value_, xml_end_, start_);
      return_ := return_ || Substr(value_, from_, start_ - from_);
      return_ := return_ || Database_SYS.Unistr(Replace(Replace(Substr(value_, start_, end_ - start_), xml_start_, '\'), xml_end_, ''));
      from_   := end_ + 1;
      start_  := instr(value_, xml_start_, from_);
   END LOOP;
   return_ := return_ || Substr(value_, from_);
   RETURN(return_);
END Unistr_Xml;



FUNCTION Db_To_File_Encoding (
   string_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Db_To_File_Encoding');
   IF (Get_File_Encoding = Get_Database_Charset) THEN
      RETURN(string_);
   ELSE
      RETURN(Convert(string_, Get_File_Encoding, Get_Database_Charset));
   END IF;
END Db_To_File_Encoding;


FUNCTION File_To_Db_Encoding (
   string_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'File_To_Db_Encoding');
   IF (Get_File_Encoding = Get_Database_Charset) THEN
      RETURN(string_);
   ELSE
      RETURN(Convert(string_, Get_Database_Charset, Get_File_Encoding));
   END IF;
END File_To_Db_Encoding;


FUNCTION Get_Db_Encoding RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Db_Encoding');
   RETURN(Get_Database_Charset);
END Get_Db_Encoding;


FUNCTION Get_Default_File_Encoding RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Change_Index_Buffer_Pool__');
   RETURN(Fnd_Setting_API.Get_Value('DEFAULT_FILEENCODING'));
END Get_Default_File_Encoding;


FUNCTION Get_File_Encoding RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_File_Encoding');
   RETURN(Fnd_Context_SYS.Find_Value('DATABASE_SYS.file_encoding_', Get_Default_File_Encoding));
END Get_File_Encoding;


PROCEDURE Set_Default_File_Encoding
IS
   character_set_ CONSTANT VARCHAR2(100) := Get_Default_File_Encoding;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Set_Default_File_Encoding');
   Set_File_Encoding(character_set_);
END Set_Default_File_Encoding;


PROCEDURE Set_File_Encoding (
   character_set_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Set_File_Encoding');
   Validate_Character_Set___(character_set_);
   Fnd_Context_SYS.Set_Value('DATABASE_SYS.file_encoding_', character_set_);
END Set_File_Encoding;


PROCEDURE Validate_File_Encoding (
   character_set_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Validate_File_Encoding');
   Validate_Character_Set___(character_set_);
END Validate_File_Encoding;


PROCEDURE Comp_Patch_Registration (
   patch_id_     IN NUMBER,
   component_    IN VARCHAR2,
   version_    IN VARCHAR2,
   file_name_    IN VARCHAR2,
   download_    IN DATE,
   description_  IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Comp_Patch_Registration');
   Component_Patch_API.Comp_Patch_Registration_(patch_id_, upper(component_), version_, file_name_, download_, description_);
END Comp_Patch_Registration;


@UncheckedAccess
FUNCTION Comp_Patch_Is_Registered (
   patch_id_     IN NUMBER,
   component_    IN VARCHAR2,
   version_      IN VARCHAR2,
   file_name_    IN VARCHAR2 DEFAULT NULL ) RETURN BOOLEAN
IS
BEGIN
   RETURN Component_Patch_API.Comp_Patch_Is_Registered_(patch_id_, upper(component_), version_, file_name_);
END Comp_Patch_Is_Registered;


PROCEDURE Comp_Patch_Clear_Registration (
   patch_id_     IN NUMBER,
   component_    IN VARCHAR2 DEFAULT '%',
   version_      IN VARCHAR2 DEFAULT '%',
   file_name_    IN VARCHAR2 DEFAULT '%' )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Comp_Patch_Clear_Registration');
   Component_Patch_API.Comp_Patch_Clear_Registration_(patch_id_, upper(component_), version_, file_name_);
END Comp_Patch_Clear_Registration;


PROCEDURE Comp_Patch_Cps_Overwrite (
   component_    IN VARCHAR2,
   version_      IN VARCHAR2,
   patch_id_     IN NUMBER DEFAULT 0 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Comp_Patch_Cps_Overwrite');
   Component_Patch_API.Comp_Patch_Cps_Overwrite_(upper(component_), version_, patch_id_);
END Comp_Patch_Cps_Overwrite;


@UncheckedAccess
FUNCTION Is_Clustered RETURN BOOLEAN
IS
BEGIN
   RETURN dbms_utility.is_cluster_database;
END Is_Clustered;


FUNCTION Get_Compile_Error (
   object_name_  IN VARCHAR2,
   object_type_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   error_ VARCHAR2(32767);

   CURSOR get_error IS
   SELECT line || ' ' || text error
     FROM user_errors
    WHERE name = object_name_
      AND type = object_type_
   ORDER BY sequence;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Compile_Error');
   FOR rec IN get_error LOOP
      error_ := error_ || crlf_ || rec.error;
   END LOOP;
   RETURN(error_);
END Get_Compile_Error;


PROCEDURE Compile_Invalid_Object (
   object_name_  IN VARCHAR2,
   object_type_  IN VARCHAR2,
   chk_invalid_  IN BOOLEAN DEFAULT FALSE )
IS
   stmt_      VARCHAR2(500);
   go_        BOOLEAN := FALSE;
   app_owner_ VARCHAR2(120);
   object_id_ NUMBER;
   compile_error     EXCEPTION;
   PRAGMA            EXCEPTION_INIT(compile_error, -24344);
   CURSOR get_object_id IS
      SELECT object_id
      INTO   object_id_
      FROM   user_objects
      WHERE  object_type = UPPER(object_type_)
      AND    (object_name = object_name_ OR object_name = UPPER(object_name_));   
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Compile_Invalid_Object');
   IF chk_invalid_ THEN
      go_ := Object_Exist(object_name_, object_type_, 'INVALID');
   ELSE
      go_ := Object_Exist(object_name_, object_type_);
   END IF;
   IF go_ THEN
      CASE (object_type_)
         WHEN 'QUEUE' THEN
            -- Same check is done by Object_Exist, removed for performace reasons
            -- Assert_SYS.Assert_Is_User_Object(object_name_ , object_type_);
            app_owner_ := Fnd_Session_API.Get_App_Owner;
            IF (USER = app_owner_ OR app_owner_ IS NULL OR object_name_ LIKE '%.%') THEN
               stmt_ := 'BEGIN Dbms_Aqadm.Alter_Queue(''' || object_name_ || '''); END;';
            ELSE
               stmt_ := 'BEGIN Dbms_Aqadm.Alter_Queue(''' || app_owner_ || '.' || object_name_ || '''); END;';
            END IF;
            Transaction_SYS.Log_Progress_Info(stmt_);
            @ApproveDynamicStatement(2011-05-30,haarse)
            EXECUTE IMMEDIATE stmt_;
         WHEN 'EVALUATION CONTEXT' THEN
            -- Same check is done by Object_Exist, removed for performace reasons
            -- Assert_SYS.Assert_Is_User_Object(object_name_ , object_type_);
            app_owner_ := Fnd_Session_API.Get_App_Owner;
            IF (USER = app_owner_ OR app_owner_ IS NULL OR object_name_ LIKE '%.%') THEN
               stmt_ := 'BEGIN Dbms_Rule_Adm.Alter_Evaluation_Context(''' || object_name_ || '''); END;';
            ELSE
               stmt_ := 'BEGIN Dbms_Rule_Adm.Alter_Evaluation_Context(''' || app_owner_ || '.' || object_name_ || '''); END;';
            END IF;
            Transaction_SYS.Log_Progress_Info(stmt_);
            @ApproveDynamicStatement(2011-05-30,haarse)
            EXECUTE IMMEDIATE stmt_;
         WHEN 'PACKAGE BODY' THEN
            OPEN get_object_id;
            FETCH get_object_id INTO object_id_;
            CLOSE get_object_id;
            IF (object_id_ IS NOT NULL) THEN
               Dbms_Utility.Validate(object_id_);
            ELSE
               Error_SYS.Appl_General(service_, 'INVALID_OBJECT: The object [:P1] of type [:P2] does not exist in the database.', object_name_, object_type_);
            END IF;
         ELSE
            -- Same check is done by Object_Exist, removed for performace reasons
            -- Assert_SYS.Assert_Is_User_Object(object_name_ , object_type_);
            stmt_ := 'ALTER ' || object_type_ || ' ' || object_name_ || ' COMPILE';
            @ApproveDynamicStatement(2021-02-02,mabose)
            EXECUTE IMMEDIATE stmt_;
      END CASE;
   ELSE
      Error_SYS.Appl_General(service_, 'INVALID_OBJECT: The object [:P1] of type [:P2] does not exist in the database.', object_name_, object_type_);
   END IF;
   Transaction_SYS.Log_Progress_Info('');
EXCEPTION
   WHEN compile_error THEN
      NULL;
END Compile_Invalid_Object;


PROCEDURE Compile_All_Invalid_Objects (
   object_type_ IN VARCHAR2 DEFAULT NULL,
   section_     IN NUMBER DEFAULT NULL,
   sections_    IN NUMBER DEFAULT NULL )
IS
   except_message_  VARCHAR2(200);
   module_          dictionary_sys_tab.module%TYPE;
   dummy_           NUMBER;
   offset_          NUMBER := 0;
   amount_          NUMBER := 99999;
   stmt_            VARCHAR2(500);
   CURSOR get_object_types IS
      SELECT object_type,
             SUM(DECODE(status, 'INVALID', 1, 0)) invalid_count
      FROM   user_objects
      WHERE  (object_type IN ('PACKAGE', 'VIEW', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', 'TRIGGER', 'JAVA CLASS', 'MATERIALIZED VIEW')
              OR
              status = 'INVALID')
      AND    object_type = NVL(UPPER(object_type_), object_type)
      GROUP BY object_type
      ORDER BY DECODE(object_type, 'PACKAGE', 1,
                                   'VIEW', 2,
                                   'PACKAGE BODY', 3,
                                   'PROCEDURE', 4,
                                   'FUNCTION', 5,
                                   'TRIGGER', 6,
                                   'JAVA CLASS', 7,
                                   'MATERIALIZED VIEW', 8,
                                   9),
               object_type;
   TYPE invalid_objects_type IS TABLE OF get_object_types%ROWTYPE INDEX BY BINARY_INTEGER;
   inv_obj_         invalid_objects_type;
   
   CURSOR get_objects  (obj_type_ VARCHAR2) IS
      SELECT object_name
      FROM  user_objects
      WHERE object_type = obj_type_
      AND   status = 'INVALID'
      ORDER BY object_name
      OFFSET offset_ ROWS FETCH FIRST amount_ ROWS ONLY;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Compile_All_Invalid_Objects');
   IF object_type_ IS NOT NULL THEN
      OPEN get_object_types;
      FETCH get_object_types BULK COLLECT INTO inv_obj_;
      CLOSE get_object_types;


      FOR row_ IN nvl(inv_obj_.FIRST,0) .. nvl(inv_obj_.LAST,-1) LOOP
         IF (inv_obj_(row_).invalid_count > 0) THEN
            IF (sections_ > 0 AND section_ > 0 AND object_type_ IS NOT NULL) THEN
               offset_ := FLOOR(inv_obj_(row_).invalid_count * (section_-1) / sections_);
               amount_ := CEIL(inv_obj_(row_).invalid_count) / sections_;
            ELSE
               offset_ := 0;
               amount_ := 99999;
            END IF;

            FOR rec IN get_objects (inv_obj_(row_).object_type) LOOP
               BEGIN
                  Compile_Invalid_Object(rec.object_name, inv_obj_(row_).object_type, TRUE);
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            END LOOP;
         END IF;
      END LOOP;
      IF object_type_ = 'MATERIALIZED VIEW' 
      AND section_ IS NULL THEN
         IF Installation_SYS.Method_Exist('Xlr_Mv_Util_API', 'Compile_All_Invalid_Mviews') THEN
            dummy_ := 0;
            FOR rec IN get_objects (object_type_) LOOP
               Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Materialized View '||rec.object_name||' will be rebuilt. A refresh might be needed.');
               dummy_ := 1;
            END LOOP;
            IF dummy_ > 0 THEN 
               stmt_ := 'BEGIN Xlr_Mv_Util_API.Compile_All_Invalid_Mviews; END;';
               @ApproveDynamicStatement(2019-09-17,mabose)
               EXECUTE IMMEDIATE stmt_;
            END IF;
         END IF;
      END IF;
   ELSE
      Compile_Schema_(USER, 'Y');
      inv_obj_.DELETE;      
      OPEN get_object_types;
      FETCH get_object_types BULK COLLECT INTO inv_obj_;
      CLOSE get_object_types;
      FOR row_ IN nvl(inv_obj_.FIRST,0) .. nvl(inv_obj_.LAST,-1) LOOP
         IF (inv_obj_(row_).invalid_count > 0) THEN
            FOR rec IN get_objects (inv_obj_(row_).object_type) LOOP
               except_message_ := inv_obj_(row_).object_type||' '||rec.object_name;
               module_ := Dictionary_SYS.Get_Component(rec.object_name, REPLACE(inv_obj_(row_).object_type, 'PACKAGE BODY', 'PACKAGE'));
               IF module_ IS NOT NULL THEN
                  except_message_ := except_message_ || ' in component ' || module_;
               END IF;
               Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Compile error exists for '||except_message_);
            END LOOP;
         END IF;
      END LOOP;
      inv_obj_.DELETE;      
      OPEN get_object_types;
      FETCH get_object_types BULK COLLECT INTO inv_obj_;
      CLOSE get_object_types;
      Log_SYS.Fnd_Trace_(Log_SYS.error_, 'INVALID OBJECTS AFTER RECOMPILE');
      Log_SYS.Fnd_Trace_(Log_SYS.error_, '-------------------------------');
      FOR row_ IN nvl(inv_obj_.FIRST,0) .. nvl(inv_obj_.LAST,-1) LOOP
         Log_SYS.Fnd_Trace_(Log_SYS.error_, RPAD(inv_obj_(row_).object_Type||':', 25)||LPAD(inv_obj_(row_).invalid_count, 5));
      END LOOP;
      Log_SYS.Fnd_Trace_(Log_SYS.error_, '-------------------------------');
   END IF;
END Compile_All_Invalid_Objects;


@UncheckedAccess
FUNCTION Compile_This_Object_Type (
   object_type_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF object_type_ IN ('PACKAGE BODY', 'JAVA CLASS', 'PACKAGE', 'VIEW', 'TRIGGER', 'PROCEDURE', 'FUNCTION', 'MATERIALIZED VIEW', 'QUEUE', 'INDEX') THEN
      RETURN object_type_;
   ELSE
      RETURN NULL;
   END IF;
END Compile_This_Object_Type;


@UncheckedAccess
FUNCTION Count_Nodes RETURN NUMBER
IS
   nodes_ NUMBER;
   CURSOR get_number_of_nodes IS
      SELECT COUNT(*)
         FROM GV$INSTANCE;
BEGIN
   OPEN  get_number_of_nodes;
      FETCH get_number_of_nodes INTO nodes_;
   CLOSE get_number_of_nodes;
   RETURN nodes_;
END Count_Nodes;


@UncheckedAccess
FUNCTION Get_Platform_Id RETURN NUMBER
IS
   platform_id_ NUMBER;
   CURSOR get_id IS
      SELECT PLATFORM_ID
         FROM V$DATABASE;
BEGIN
   OPEN  get_id;
      FETCH get_id INTO platform_id_;
   CLOSE get_id;
   RETURN platform_id_;
END Get_Platform_Id;

@UncheckedAccess
FUNCTION Get_Platform_Name RETURN VARCHAR2
IS
   platform_name_ VARCHAR2(200);
   CURSOR get_name IS
      SELECT PLATFORM_NAME
         FROM V$DATABASE;
BEGIN
   OPEN  get_name;
      FETCH get_name INTO platform_name_;
   CLOSE get_name;
   RETURN platform_name_;
END Get_Platform_Name;

@UncheckedAccess
FUNCTION Get_Db_Os RETURN VARCHAR2
IS
   db_os_      VARCHAR2(120);
BEGIN
   db_os_ := CASE Get_Platform_Id
             WHEN 1 THEN 'Solaris[tm] OE (32-bit)'
             WHEN 2 THEN 'Solaris[tm] OE (64-bit)'
             WHEN 3 THEN 'HP-UX (64-bit)'
             WHEN 4 THEN 'HP-UX (64-bit)'
             WHEN 5 THEN 'HP Tru64 UNIX'
             WHEN 6 THEN 'AIX-Based Systems (64-bit)'
             WHEN 7 THEN 'Microsoft Windows NT'
             WHEN 8 THEN 'Linux IA (32-bit)'
             WHEN 9 THEN 'Linux IA (64-bit)'
             ELSE        'Other'
        END;
   RETURN db_os_;
END Get_Db_Os;


@UncheckedAccess
FUNCTION Get_Db_Hardware RETURN VARCHAR2
IS
   db_hw_         VARCHAR2(120);
BEGIN
   db_hw_ := CASE Get_Platform_Id()
             WHEN 1 THEN 'SPARC'
             WHEN 2 THEN 'SPARC'
             WHEN 3 THEN 'PA RISC'
             WHEN 4 THEN 'IA RISC'
             WHEN 5 THEN 'DEC Alpha'
             WHEN 6 THEN 'Power PC'
             WHEN 7 THEN 'Intel or AMD X86'
             WHEN 8 THEN 'Intel or AMD X86'
             WHEN 9 THEN 'IA64'
             ELSE        'Other'
             END;

   RETURN db_hw_;
END Get_Db_Hardware;


@UncheckedAccess
FUNCTION Get_Init_Ora_Parameter (
   parameter_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Get_Init_Ora_Parameter___(parameter_));
END Get_Init_Ora_Parameter;


@UncheckedAccess
FUNCTION Is_Unicode_Character_Set RETURN BOOLEAN
IS
BEGIN
   RETURN  Is_Unicode_Character_Set___(Get_Database_Charset);
END Is_Unicode_Character_Set;

@UncheckedAccess
FUNCTION Get_Tablespace_Name(
   object_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN   
   RETURN Installation_SYS.Get_Tablespace_Name(object_);
END Get_Tablespace_Name;

FUNCTION Get_Lob_Freepools (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Lob_Freepools');
   RETURN (Installation_SYS.Get_Lob_Freepools(table_name_, column_name_));
END Get_Lob_Freepools;


FUNCTION Get_Chunk_Lob_Size (
   table_name_   IN VARCHAR2,
   column_name_  IN VARCHAR2 ) RETURN NUMBER
IS
   chunk_size_   NUMBER;
   CURSOR get_chunk_size IS 
      SELECT nvl(round(decode(l.in_row, 'YES', 0, 1)*t.num_rows * l.chunk/1024/1024, 2),0)
        FROM user_lobs l, user_tables t
       WHERE l.table_name = t.table_name
         AND l.table_name = table_name_
         AND l.column_name = column_name_;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Chunk_Lob_Size');
   OPEN  get_chunk_size;
   FETCH get_chunk_size INTO chunk_size_;
   CLOSE get_chunk_size;
   RETURN chunk_size_;
END Get_Chunk_Lob_Size;
   
FUNCTION Get_Physical_Lob_Size (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN NUMBER
IS
   stmt_       VARCHAR2(1000) := 'SELECT Round(Nvl(Sum(Nvl(Dbms_Lob.Getlength(' || column_name_ || '),0)),0)/1024/1024,2) FROM ' || table_name_;
   lob_size_   NUMBER;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Physical_Lob_Size');
   Assert_SYS.Assert_Is_Table_Column(table_name_, column_name_);
   @ApproveDynamicStatement(2010-03-19,haarse)
   EXECUTE IMMEDIATE stmt_ INTO lob_size_;
   RETURN (lob_size_);
END Get_Physical_Lob_Size;


FUNCTION Get_Allocated_Lob_Size (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_length IS 
   SELECT allocated_lob_size
     FROM oracle_lob_extents
    WHERE table_name = table_name_
    and column_name = column_name_;
     
   lob_size_   NUMBER;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Get_Allocated_Lob_Size');
   OPEN  get_length;
   FETCH get_length INTO lob_size_;
   CLOSE get_length;
   RETURN (lob_size_);
END Get_Allocated_Lob_Size;

PROCEDURE Change_All_Clob_Row_Movement (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2, 
   tablespace_  IN VARCHAR2 DEFAULT 'IFSAPP_LOB',
   show_info_   IN BOOLEAN  DEFAULT TRUE )
IS
   CURSOR get_clobs IS 
  SELECT l.table_name, l.column_name
    FROM user_lobs l, user_tab_columns c
   WHERE l.table_name = c.table_name
     AND l.column_name = c.column_name
     AND l.in_row = 'NO'
     AND c.data_type = 'CLOB';
  
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Change_All_Clob_Row_Movement');
   --
   FOR rec IN get_clobs LOOP
      Change_Lob_Row_Movement(rec.table_name, rec.column_name, tablespace_, show_info_);
   END LOOP;
END Change_All_Clob_Row_Movement;

PROCEDURE Change_Lob_Row_Movement (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2, 
   tablespace_  IN VARCHAR2 DEFAULT 'IFSAPP_LOB',
   show_info_   IN BOOLEAN  DEFAULT TRUE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Change_Lob_Row_Movement');
   --
   -- Note! This command locks the table, possibly a long time for a large table, meaning endusers can not use the table during the operation
   --       Enable row movement must be enabled on the table in order to make the shrink command available
   --       May lead to unusable Search Domain indexes
   IF (Has_Domain_Index___(table_name_)) THEN 
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Table '||table_name_||' has a domain index and will not be moved.');
   ELSE
      Installation_SYS.Change_Lob_Row_Movement(table_name_, column_name_, tablespace_, show_info_);
      Rebuild_Unusable_Indexes___(table_name_, show_info_);
   END IF;
END Change_Lob_Row_Movement;

PROCEDURE Move_Lob_Segment (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2, 
   tablespace_  IN VARCHAR2 DEFAULT 'IFSAPP_LOB',
   show_info_   IN BOOLEAN  DEFAULT TRUE )
IS
   changed_ BOOLEAN := FALSE;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Move_Lob_Segment');
   --
   -- Note! This command locks the table, possibly a long time for a large table, meaning endusers can not use the table during the operation
   --       Enable row movement must be enabled on the table in order to make the shrink command available
   --       May lead to unusable Search Domain indexes
   IF (Has_Domain_Index___(table_name_)) THEN 
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Table '||table_name_||' has a domain index and will not be moved.');
   ELSE
      IF NOT Database_SYS.Is_Rowmovement_Enabled(table_name_) THEN 
         Installation_SYS.Alter_Table_Rowmovement(table_name_, TRUE, show_info_);
         changed_ := TRUE;
      END IF;
      Installation_SYS.Move_Lob_Segment(table_name_, column_name_, tablespace_, show_info_);
      Rebuild_Unusable_Indexes___(table_name_, show_info_);
      IF changed_ THEN
         Installation_SYS.Alter_Table_Rowmovement(table_name_, TRUE, show_info_);
      END IF;         
  END IF;
END Move_Lob_Segment;

PROCEDURE Move_Lob_Tablespace(
   temp_tablespace_ IN VARCHAR2 )
IS

   CURSOR get_lobs IS
   SELECT table_name,
          column_name,
          allocated_lob_size,
          secure_file,
          tablespace
     FROM oracle_lob_extents
    WHERE table_name NOT LIKE 'DR$%' -- Dont include Oracle Text objects
      ORDER BY table_name, column_name;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Move_Lob_Tablespace');
   FOR rec IN get_lobs LOOP
      BEGIN
         --
         -- Possibly could the following command make more space available for shrinking (this has never been proven by HAARSE).
         -- "alter table [table_name] modify lob ([lob_column_name]) (freepools X);" where x is the number of freepools seen in USER_LOBS
         --
         -- Note! This command locks the table, possibly a long time for a large table, meaning endusers can not use the table during the operation
         --       Enable row movement must be enabled on the table in order to make the shrink command available
         --
         Installation_SYS.Alter_Lob_Freepools(rec.table_name, rec.column_name, TRUE);
         Database_SYS.Move_Lob_Segment(rec.table_name, rec.column_name, temp_tablespace_, TRUE);
         Log_SYS.Fnd_Trace_(Log_SYS.info_, '   Move the lob '|| rec.column_name || ' in table '|| rec.table_name || ' from ' || rec.tablespace || ' to ' || temp_tablespace_ || '.');
         Database_SYS.Move_Lob_Segment(rec.table_name, rec.column_name, rec.tablespace, TRUE);
         Log_SYS.Fnd_Trace_(Log_SYS.info_, '   Move the lob '|| rec.column_name || ' in table '|| rec.table_name || ' from ' || temp_tablespace_ || ' back to ' || rec.tablespace || '.');
         Transaction_SYS.Log_Progress_Info(' ');
         Transaction_SYS.Log_Status_Info('   Move the lob '|| rec.column_name || ' in table '|| rec.table_name || ' has finished.', 'INFO');
      EXCEPTION
         WHEN OTHERS THEN
            Log_SYS.Fnd_Trace_(Log_SYS.info_, Substr('Error during move of LOB segment ' || rec.column_name || ' in table ' ||rec.table_name || ' failed, due to Oracle error ' || SQLERRM || '.',1,2000) || '.');
            Transaction_SYS.Log_Status_Info(Substr('Error during move of LOB segment ' || rec.column_name || ' in table ' ||rec.table_name || ' failed, due to Oracle error ' || SQLERRM || '.',1,2000) || '.', 'WARNING');
            RAISE;
      END;
   END LOOP;
END Move_Lob_Tablespace;

PROCEDURE Shrink_Lob_Segments(
   allocated_lob_size_ IN NUMBER DEFAULT 1000,
   reclaimed_size_     IN NUMBER DEFAULT 100)
IS
   physical_lob_size_   NUMBER;
   chunk_size_          NUMBER;
   num_errors_          NUMBER;
   app_owner_           VARCHAR2(30) := Fnd_Session_API.Get_App_Owner;
   stmt_                VARCHAR2(500);

   CURSOR count_lobs IS
   SELECT COUNT(*) num_records
     FROM oracle_lob_extents
    WHERE table_name NOT LIKE 'DR$%' -- Dont include Oracle Text objects
      AND table_name NOT IN ('TRANSACTION_SYS_LOCAL_TAB', 'SHRINK_LOB_SEGMENTS_TAB')
      AND allocated_lob_size > allocated_lob_size_;
   CURSOR get_lobs IS
   SELECT table_name,
          column_name,
          allocated_lob_size,
          secure_file,
          tablespace
     FROM oracle_lob_extents
    WHERE table_name NOT LIKE 'DR$%' -- Dont include Oracle Text objects
      AND table_name NOT IN ('TRANSACTION_SYS_LOCAL_TAB', 'SHRINK_LOB_SEGMENTS_TAB')
      AND allocated_lob_size > allocated_lob_size_
      ORDER BY table_name, column_name;
   CURSOR get_size (table_name_ VARCHAR2, column_name_ VARCHAR2) IS
   SELECT allocated_lob_size
     FROM oracle_lob_extents
    WHERE table_name = table_name_
      AND column_name = column_name_;
   CURSOR get_privileges (table_name_ VARCHAR2) IS
      SELECT 'GRANT ' || LISTAGG(t.privilege, ',') WITHIN GROUP (ORDER BY t.privilege) || ' ' ||
             'ON "' || t.table_name || '" ' ||
             'TO "' || t.grantee || '"' || 
             DECODE(t.hierarchy, 'YES', ' WITH HIERARCHY OPTION') ||
             DECODE(t.grantable, 'YES', ' WITH GRANT OPTION') || 
             DECODE(t.common, 'YES', ' CONTAINER=ALL') stmt
      FROM all_tab_privs_made t
      WHERE table_name = table_name_
      AND owner = app_owner_
      GROUP BY t.table_name, t.grantee, t.hierarchy, t.grantable, t.common
      UNION ALL
      SELECT 'GRANT ' || t.privilege || ' (' || LISTAGG('"'||t.column_name||'"', ',') WITHIN GROUP (ORDER BY t.column_name) || ') ' ||
             'ON "' || t.table_name || '" ' ||
             'TO "' || t.grantee || '"' || 
             DECODE(t.grantable, 'YES', ' WITH GRANT OPTION') || 
             DECODE(t.common, 'YES', ' CONTAINER=ALL') stmt
      FROM all_col_privs_made t
      WHERE table_name = table_name_
      AND owner = app_owner_
      GROUP BY t.table_name, t.privilege, t.grantee, t.grantable, t.common;
   TYPE get_privileges_types IS TABLE OF get_privileges%ROWTYPE INDEX BY BINARY_INTEGER;
   get_privileges_type_      get_privileges_types;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Shrink_Lob_Segments');
   FOR count_rec IN count_lobs LOOP
      Transaction_SYS.Update_Total_Work(Transaction_SYS.Get_Current_Job_Id, count_rec.num_records);
      @ApproveTransactionStatement(2019-02-06,MABOSE)
      COMMIT;
   END LOOP;
   FOR rec IN get_lobs LOOP
         -- Checked for assertion before call Installation_SYS
         Assert_SYS.Assert_Is_Table_Column(rec.table_name, rec.column_name);
         physical_lob_size_ := Get_Physical_Lob_Size(rec.table_name, rec.column_name);
         chunk_size_        := Get_Chunk_Lob_Size(rec.table_name, rec.column_name);
         IF  ( rec.allocated_lob_size - Greatest(chunk_size_, physical_lob_size_) >= reclaimed_size_ ) THEN
            Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Shrinking the lob segment ' || rec.column_name || ' in table '|| rec.table_name || '.');
            Log_SYS.Fnd_Trace_(Log_SYS.info_, '   Allocated Lob size: ' || to_char(rec.allocated_lob_size) || ' Mb Physical Lob Size: ' || physical_lob_size_ || 'Mb.');
            Transaction_SYS.Log_Progress_Info('Trying to shrink the lob '|| rec.column_name || ' in table '|| rec.table_name || '.');
            Transaction_SYS.Log_Status_Info('Trying to shrink the lob '|| rec.column_name || ' in table '|| rec.table_name || '. ' || Database_SYS.Get_Formatted_Datetime(SYSDATE), 'INFO');
            Transaction_SYS.Log_Status_Info('   Allocated Lob size: ' || to_char(rec.allocated_lob_size) || ' Mb Physical Lob Size: ' || physical_lob_size_ || ' Mb.', 'INFO');
            IF (rec.secure_file = 'NO') THEN -- Basicdata file LOBs
               BEGIN
                  --
                  -- Possibly could the following command make more space available for shrinking (this has never been proven by HAARSE).
                  -- "alter table [table_name] modify lob ([lob_column_name]) (freepools X);" where x is the number of freepools seen in USER_LOBS
                  --
                  -- Note! This command locks the table, possibly a long time for a large table, meaning endusers can not use the table during the operation
                  --       Enable row movement must be enabled on the table in order to make the shrink command available
                  --
                  Installation_SYS.Alter_Lob_Freepools(rec.table_name, rec.column_name, TRUE);
                  Installation_SYS.Shrink_Lob_Segment(rec.table_name, rec.column_name, TRUE);
                  Transaction_SYS.Log_Status_Info('   Trying to shrink the lob '|| rec.column_name || ' in table '|| rec.table_name || ' has finished.', 'INFO');
               EXCEPTION
                  WHEN OTHERS THEN
                     Transaction_SYS.Log_Status_Info(Substr('Shrinking of lob segment ' || rec.column_name || ' in table ' ||rec.table_name || ' failed, due to Oracle error ' || SQLERRM || '.',1,2000) || '.', 'WARNING');
                     Rebuild_Unusable_Indexes___(rec.table_name, TRUE);
               END;
            ELSE -- Securefile LOBs
               $IF Component_Entedition_SYS.INSTALLED $THEN
               -- SHRINK_LOB_SEGMENTS_TAB can act both as a table and a materialized view in the redefinition process, why we need to clear both types
               BEGIN
                  Installation_SYS.Remove_Table('SHRINK_LOB_SEGMENTS_TAB', FALSE, TRUE);
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;      
               BEGIN
                  Installation_SYS.Remove_Materialized_View('SHRINK_LOB_SEGMENTS_TAB', FALSE);
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;      
               BEGIN
                  OPEN get_privileges(rec.table_name);
                  FETCH get_privileges BULK COLLECT INTO get_privileges_type_;
                  CLOSE get_privileges;
                  DECLARE
                     metadata_handle_  NUMBER;
                     transform_handle_ NUMBER;
                     ddl_handle_       NUMBER;
                     result_array_     sys.ku$_ddls;
                  BEGIN
                     metadata_handle_ := Dbms_Metadata.Open('TABLE');

                     transform_handle_ := Dbms_Metadata.Add_Transform(metadata_handle_, 'MODIFY');
                     Dbms_Metadata.Set_Remap_Param(transform_handle_, 'REMAP_NAME', rec.table_name, 'SHRINK_LOB_SEGMENTS_TAB');

                     ddl_handle_ := Dbms_Metadata.Add_Transform(metadata_handle_, 'DDL');
                     Dbms_Metadata.Set_Transform_Param(ddl_handle_,'CONSTRAINTS', FALSE);  
                     Dbms_Metadata.Set_Transform_Param(ddl_handle_,'STORAGE', FALSE);  

                     Dbms_Metadata.Set_Filter(metadata_handle_, 'NAME', rec.table_name);

                     LOOP
                        result_array_ := Dbms_Metadata.Fetch_Ddl(metadata_handle_);
                        EXIT WHEN result_array_ IS NULL;
                           FOR i_ IN result_array_.first..result_array_.last LOOP
                              --Log_SYS.Fnd_Trace_(Log_SYS.info_, result_array_(i_).ddltext);
                              @ApproveDynamicStatement(2019-02-06,MABOSE)
                              EXECUTE IMMEDIATE result_array_(i_).ddltext;
                           END LOOP;
                     END LOOP; 
                     Dbms_Metadata.Close(metadata_handle_);
                  END;
                  stmt_ := 'BEGIN DBMS_REDEFINITION.CAN_REDEF_TABLE('''||app_owner_||''', '''||rec.table_name||''', DBMS_REDEFINITION.CONS_USE_ROWID); END;';
                  --Log_SYS.Fnd_Trace_(Log_SYS.info_, stmt_);
                  @ApproveDynamicStatement(2019-02-06,MABOSE)
                  EXECUTE IMMEDIATE stmt_;
                  stmt_ := 'BEGIN DBMS_REDEFINITION.START_REDEF_TABLE('''||app_owner_||''', '''||rec.table_name||''', ''SHRINK_LOB_SEGMENTS_TAB'', options_flag => DBMS_REDEFINITION.CONS_USE_ROWID); END;';
                  --Log_SYS.Fnd_Trace_(Log_SYS.info_, stmt_);
                  @ApproveDynamicStatement(2019-02-06,MABOSE)
                  EXECUTE IMMEDIATE stmt_;
                  stmt_ := 'BEGIN DBMS_REDEFINITION.COPY_TABLE_DEPENDENTS('''||app_owner_||''', '''||rec.table_name||''', ''SHRINK_LOB_SEGMENTS_TAB'', copy_privileges => FALSE, num_errors => :num_errors_); END;';
                  --Log_SYS.Fnd_Trace_(Log_SYS.info_, stmt_);
                  @ApproveDynamicStatement(2019-02-06,MABOSE)
                  EXECUTE IMMEDIATE stmt_  USING OUT num_errors_;
                  stmt_ := 'BEGIN DBMS_REDEFINITION.FINISH_REDEF_TABLE('''||app_owner_||''', '''||rec.table_name||''', ''SHRINK_LOB_SEGMENTS_TAB''); END;';
                  --Log_SYS.Fnd_Trace_(Log_SYS.info_, stmt_);
                  @ApproveDynamicStatement(2019-02-06,MABOSE)
                  EXECUTE IMMEDIATE stmt_;

                  FOR row_ IN nvl(get_privileges_type_.FIRST,0) .. nvl(get_privileges_type_.LAST,-1) LOOP
                     --Log_SYS.Fnd_Trace_(Log_SYS.info_, get_privileges_type_(row_).stmt);
                     @ApproveDynamicStatement(2019-08-20,MABOSE)
                     EXECUTE IMMEDIATE get_privileges_type_(row_).stmt;
                  END LOOP;
                  Installation_SYS.Remove_Table('SHRINK_LOB_SEGMENTS_TAB', FALSE, TRUE);
                  FOR tabrec IN get_size(rec.table_name, rec.column_name) LOOP
                     Transaction_SYS.Log_Status_Info('   Allocated Lob size when done: ' || to_char(tabrec.allocated_lob_size) || ' Mb.', 'INFO');
                     Log_SYS.Fnd_Trace_(Log_SYS.info_,'    Allocated Lob size when done: ' || to_char(tabrec.allocated_lob_size) || ' Mb.');
                  END LOOP;
                  Revalidate_Schema_(app_owner_);
               EXCEPTION
                  WHEN OTHERS THEN
                     Log_SYS.Fnd_Trace_(Log_SYS.info_, Substr('Shrinking of lob segment ' || rec.column_name || ' in table ' ||rec.table_name || ' failed, due to Oracle error ' || Dbms_Utility.Format_Error_Stack ||' '|| Dbms_Utility.Format_Error_Backtrace || '.',1,2000) || '.');
                     Transaction_SYS.Log_Status_Info(Substr('Shrinking of lob segment ' || rec.column_name || ' in table ' ||rec.table_name || ' failed, due to Oracle error ' || Dbms_Utility.Format_Error_Stack ||' '|| Dbms_Utility.Format_Error_Backtrace || '.',1,2000) || '.', 'WARNING');
                     -- SHRINK_LOB_SEGMENTS_TAB can act both as a table and a materialized view in the redefinition process, why we need to clear both types
                     BEGIN
                        Installation_SYS.Remove_Table('SHRINK_LOB_SEGMENTS_TAB', FALSE, TRUE);
                     EXCEPTION
                        WHEN OTHERS THEN
                           NULL;
                     END;      
                     BEGIN
                        Installation_SYS.Remove_Materialized_View('SHRINK_LOB_SEGMENTS_TAB', FALSE);
                     EXCEPTION
                        WHEN OTHERS THEN
                           NULL;
                     END;      
               END;
               $ELSE
               Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Shrinking of lob segment ' || rec.column_name || ' in table ' ||rec.table_name || ' was ignored since it is stored in secure files in a Standard Edition database.');
               Transaction_SYS.Log_Status_Info('Shrinking of lob segment ' || rec.column_name || ' in table ' ||rec.table_name || '  was ignored since it is stored in secure files in a Standard Edition database.', 'WARNING');
               $END
            END IF;
         ELSE
            Transaction_SYS.Log_Progress_Info(' ');
            Transaction_SYS.Log_Status_Info('No need in trying to shrink the lob '|| rec.column_name || ' in table '|| rec.table_name || '. ' || Database_SYS.Get_Formatted_Datetime(SYSDATE), 'INFO');
            Transaction_SYS.Log_Status_Info('   Allocated Lob size: ' || to_char(rec.allocated_lob_size) || ' Mb Physical Lob Size: ' || physical_lob_size_ || ' Mb.', 'INFO');
         END IF;
   END LOOP;
   Compile_All_Invalid_Objects;
   Transaction_SYS.Log_Progress_Info('Done!');
END Shrink_Lob_Segments;

PROCEDURE Move_Object (
   object_name_      IN VARCHAR2,    
   tablespace_       IN VARCHAR2 DEFAULT NULL,
   show_info_        IN BOOLEAN  DEFAULT FALSE,
   forced_offline_   IN BOOLEAN  DEFAULT FALSE)
IS
   
BEGIN  
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Move_Object');
   Installation_SYS.Move_Object(object_name_, tablespace_, show_info_,forced_offline_);
END Move_Object;   

PROCEDURE Alter_Tablespace_ (
   text_        OUT CLOB,
   show_info_   IN BOOLEAN  DEFAULT TRUE )
IS
   block_size_ NUMBER;
   
   CURSOR get_blocksize IS
      SELECT value
      FROM   v$parameter
      WHERE  name = 'db_block_size';

   CURSOR get_alter_cmd IS 
   SELECT 'ALTER DATABASE DATAFILE '''||file_name||''' RESIZE ' || ceil( (nvl(hwm,1)*block_size_)/1024/1024 ) || 'M;' command,
          ceil( blocks*block_size_/1024/1024) - ceil( (nvl(hwm,1)*block_size_)/1024/1024 ) savings,
          file_name
   FROM dba_data_files a, ( SELECT file_id, max(block_id+blocks-1) hwm
                            FROM dba_extents
                            GROUP by file_id ) b
   WHERE a.file_id = b.file_id(+)
   AND ceil( blocks*block_size_/1024/1024) - ceil( (nvl(hwm,1)*block_size_)/1024/1024 ) > 0;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Alter_Tablespace_');
   OPEN  get_blocksize;
   FETCH get_blocksize INTO block_size_;
   CLOSE get_blocksize;
   --
   FOR rec IN get_alter_cmd LOOP    
      Log_SYS.Fnd_Trace_(Log_SYS.info_,'-- Savings ' || rec.savings || 'Mb for file ' || rec.file_name || '.');
      Log_SYS.Fnd_Trace_(Log_SYS.info_, rec.command);
      text_ := text_ || '-- Savings ' || rec.savings || 'Mb for file ' || rec.file_name || '.' || chr(10);
      text_ := text_ || rec.command || chr(10);
   END LOOP;
END Alter_Tablespace_;


PROCEDURE Grant_All_Objects_Ial (
   ial_owner_  IN VARCHAR2 )
IS
   stmt_    VARCHAR2(2000);
   setting_ fnd_setting_tab.value%TYPE;
   dummy_   NUMBER;

   CURSOR get_objs IS
      SELECT object_name,
             decode(object_type,
                    'VIEW',    'SELECT',
                    'TABLE',   'SELECT',
                    'PACKAGE', 'EXECUTE', NULL) grant_option
      FROM user_objects
      WHERE  object_type IN ('VIEW', 'TABLE', 'PACKAGE')
      AND object_name NOT LIKE 'SYS_IOT%'
      AND object_name NOT LIKE 'AQ$%'
      AND object_name NOT IN (SELECT table_name FROM user_object_tables)
      AND object_name NOT IN (SELECT table_name FROM user_tables WHERE NESTED = 'YES' OR secondary = 'Y')
         MINUS
      SELECT table_name object_name, privilege
      FROM user_tab_privs_made
      WHERE privilege IN ('SELECT','EXECUTE')
      AND grantee = ial_owner_;

   CURSOR check_user IS
      SELECT 1
      FROM sys.all_users
      WHERE username = upper(ial_owner_);

   CURSOR get_setting IS
      SELECT upper(value)
      FROM fnd_setting_tab
      WHERE parameter = 'IAL_USER';

BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Grant_All_Objects_Ial');
   -- Check that the user is a valid Oracle user
   OPEN check_user;
   FETCH check_user INTO dummy_;
   IF check_user%NOTFOUND THEN
      CLOSE check_user;
      Log_SYS.Fnd_Trace_(Log_SYS.error_, ial_owner_ || ' is not a user, execution failed!');
   ELSE
      CLOSE check_user;
      -- Trace if F1 settings are incorrect
      -- Method Fnd_Setting_API.Get_Value can not be used,
      -- it would lock this package from being granted...
      OPEN get_setting;
      FETCH get_setting INTO setting_;
      CLOSE get_setting;
      IF setting_ IS NULL OR setting_ <> upper(ial_owner_)  THEN
         Log_SYS.Fnd_Trace_(Log_SYS.error_, ial_owner_ ||' is not configured to be the IAL user, check your configuration before proceeding!');
      ELSE
         -- Proceed with the granting
         FOR rec IN get_objs LOOP
            BEGIN
               Assert_SYS.Assert_Is_In_Whitelist(rec.grant_option, 'SELECT,EXECUTE');
               Assert_SYS.Assert_Is_User_Object(rec.object_name);
               Assert_SYS.Assert_Is_User(ial_owner_);
               stmt_ := 'GRANT '||rec.grant_option||' ON '||rec.object_name||' TO '||ial_owner_||' WITH GRANT OPTION';
               @ApproveDynamicStatement(2011-05-30,haarse)
               EXECUTE IMMEDIATE stmt_;
            EXCEPTION
               WHEN OTHERS THEN
                  Log_SYS.Fnd_Trace_(Log_SYS.error_, 'The following statement failed: ' || stmt_);
            END;
         END LOOP;
         Security_SYS.Grant_Role('FND_IAL_ADMIN', ial_owner_);
      END IF;
   END IF;
END Grant_All_Objects_Ial;

PROCEDURE Grant_All_Objects_Read_Only
IS
   stmt_    VARCHAR2(2000);
   dummy_   NUMBER;
   ifsdbro_owner_ VARCHAR2(50) := 'IFSDBREADONLY';
   
   CURSOR get_objs IS
      SELECT object_name,
             decode(object_type,
                    'VIEW',    'SELECT',
                    'TABLE',   'SELECT',
                     'PACKAGE', 'DEBUG',
                    'PACKAGE BODY', 'DEBUG', NULL) grant_option
      FROM user_objects
      WHERE  object_type IN ('VIEW', 'TABLE', 'PACKAGE')
      AND object_name NOT LIKE 'SYS_IOT%'
      AND object_name NOT LIKE 'AQ$%'
      AND object_name NOT IN (SELECT table_name FROM user_object_tables)
      AND object_name NOT IN (SELECT table_name FROM user_tables WHERE NESTED = 'YES' OR secondary = 'Y')
         MINUS
      SELECT table_name object_name, privilege
      FROM user_tab_privs_made
      WHERE privilege IN ('SELECT','DEBUG')
      AND grantee = ifsdbro_owner_;

   CURSOR check_user IS
      SELECT 1
      FROM sys.all_users
      WHERE username = upper(ifsdbro_owner_);

BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Grant_All_Objects_Read_Only');
   -- Check that the user is a valid Oracle user
   OPEN check_user;
   FETCH check_user INTO dummy_;
   IF check_user%NOTFOUND THEN
      CLOSE check_user;
      Log_SYS.Fnd_Trace_(Log_SYS.error_, ifsdbro_owner_ || ' is not a user, execution failed!');
   ELSE
      CLOSE check_user;   
      -- Proceed with the granting
      FOR rec IN get_objs LOOP
         BEGIN
            Assert_SYS.Assert_Is_In_Whitelist(rec.grant_option, 'SELECT,DEBUG');
            Assert_SYS.Assert_Is_User_Object(rec.object_name);
            stmt_ := 'GRANT '||rec.grant_option||' ON '||rec.object_name||' TO '||ifsdbro_owner_;
            @ApproveDynamicStatement(2022-03-07,pweelk)
            EXECUTE IMMEDIATE stmt_;
         EXCEPTION
            WHEN OTHERS THEN
                  Log_SYS.Fnd_Trace_(Log_SYS.error_, 'The following statement failed: ' || stmt_);
         END;
      END LOOP;
   END IF;
END Grant_All_Objects_Read_Only;


PROCEDURE Grant_All (
   role_  IN VARCHAR2,
   skip_admin_ IN BOOLEAN DEFAULT TRUE)
IS    
   CURSOR all_pres_objects IS
      SELECT po_id, module
        FROM pres_object_tab;
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Grant_All');
   IF (Fnd_Role_API.Get_Fnd_Role_Type(role_) IS NULL) THEN
      Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Role: ' || role_ || ' does not exist');
      Error_SYS.Appl_General(service_, 'ROLE_MISSING: Role :P1 does not exist', role_);
   END IF;
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Grant Presentation Objects to ' || role_);
   BEGIN
      FOR po IN all_pres_objects LOOP
         BEGIN
            IF (Pres_Object_Util_API.Get_Grant_Info(po.po_id, role_) != 'GRANTED' AND
               (skip_admin_ = FALSE OR po.module NOT IN ('FNDADM', 'FNDBAS', 'FNDWEB', 'FNDCOB'))) THEN
               Pres_Object_Util_API.Grant_Pres_Object( po.po_id, role_);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Error when trying to grant Po Id: '||po.po_id);
         END;
      END LOOP;
   END;
   --
   Grant_All_Hud_Pres_Objects___(role_);
   IF skip_admin_ = TRUE THEN
      Grant_All_Non_Admin_Projections___(role_);
   ELSE
      Grant_All_Projections___(role_);
   END IF;
   
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'grant role FND_WEBENDUSER_MAIN to ' || role_);
   Security_SYS.Grant_Role( 'FND_WEBENDUSER_MAIN', role_);
   
   Security_SYS.Refresh_Active_List__(1);
END Grant_All;

PROCEDURE Grant_All_Projections_Readonly (
   role_  IN VARCHAR2 )
IS
   CURSOR all_projections IS
      SELECT projection_name
      FROM fnd_projection_tab;
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Grant All Projections as Read-Only to ' || role_);
   
   BEGIN
      FOR projection_ IN all_projections LOOP
         BEGIN
            Fnd_Projection_Grant_API.Grant_Query(projection_.projection_name, role_);
         EXCEPTION
            WHEN OTHERS THEN
               Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Error when trying to grant projection '||projection_.projection_name);
         END;
      END LOOP;
   END;
   Security_SYS.Grant_Role( 'FND_WEBENDUSER_MAIN', role_);
   Security_SYS.Refresh_Active_List__(1);
   
END Grant_All_Projections_Readonly;

@UncheckedAccess
PROCEDURE Validate_Password (
   password_ IN VARCHAR2 )
IS
BEGIN
   Assert_SYS.Assert_Is_Valid_Password(password_);
END Validate_Password;


PROCEDURE Register_Cleanup_Table (
   table_name_ IN VARCHAR2,
   column_name_  IN VARCHAR2,
   age_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Register_Cleanup_Table');
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   INSERT INTO cleanup_temporary_data_tab
   (table_name, column_name, age, user_name, time_stamp)
   VALUES
   (UPPER(table_name_), UPPER(column_name_), age_, Fnd_Session_API.Get_Fnd_User, SYSDATE);
EXCEPTION
   WHEN dup_val_on_index THEN
      UPDATE cleanup_temporary_data_tab
      SET column_name = UPPER(column_name_),
      age = age_,
      user_name = Fnd_Session_API.Get_Fnd_User,
      time_stamp = SYSDATE
      WHERE table_name = UPPER(table_name_);
END Register_Cleanup_Table;

PROCEDURE Installation_Summary
IS
   found_ BOOLEAN := FALSE;
   CURSOR get_invalids IS
      SELECT object_type, COUNT(*) cnt
      FROM user_objects
      WHERE status = 'INVALID'
      GROUP BY object_type
      ORDER BY DECODE(object_type, 'PACKAGE', '1', 'VIEW', '2', 'PACKAGE BODY', '3', object_type );
   CURSOR get_changed_po IS
      SELECT 'New modules' change_info, COUNT(*) cnt, 1
      FROM module_tab
      WHERE active = 'TRUE'
        AND module IN
      (SELECT DISTINCT module
       FROM (SELECT module FROM pres_object_tab
             MINUS
             SELECT module FROM pres_object_snap_tab))
      UNION
      SELECT 'New PO for existing modules' change_info, COUNT(*) cnt, 2
      FROM (SELECT po_id, module, pres_object_type FROM pres_object_tab
            MINUS
            SELECT po_id, module, pres_object_type FROM  pres_object_snap_tab) diff, module_tab m
      WHERE diff.module = m.module
        AND m.active = 'TRUE'
        AND diff.module NOT IN 
      (SELECT DISTINCT module 
       FROM(SELECT module 
            FROM pres_object_tab
            MINUS
            SELECT module 
            FROM pres_object_snap_tab))
      UNION
      SELECT 'New objects for existing PO' change_info, COUNT(*) cnt, 3
      FROM (SELECT po.module, po.pres_object_type, pos.po_id, pos.sec_object, pos.sec_object_type_db 
            FROM pres_object_security_avail pos, pres_object_tab po
            WHERE pos.po_id = po.po_id
            MINUS
            SELECT po.module, po.pres_object_type, pos.po_id, pos.sec_object, pos.sec_object_type
            FROM pres_object_security_snap_tab pos, pres_object_tab po
            WHERE pos.po_id = po.po_id) diff, module_tab m
      WHERE diff.module = m.module
        AND m.active = 'TRUE'
        AND(diff.module,diff.po_id) NOT IN
            (SELECT module, po_id
             FROM  pres_object_tab
             MINUS
             SELECT module,po_id
             FROM  pres_object_snap_tab)
      UNION
      SELECT 'Removed modules' change_info, COUNT(*) cnt, 4
        FROM module_tab 
       WHERE active = 'TRUE'
         AND module IN
            (SELECT DISTINCT module
               FROM (SELECT module
                       FROM pres_object_snap_tab
                      MINUS
                     SELECT module 
                       FROM pres_object_tab))
      UNION
      SELECT 'Removed PO' change_info, COUNT(*) cnt, 5
      FROM (SELECT po_id, module, pres_object_type
            FROM pres_object_snap_tab
            MINUS
            SELECT po_id, module, pres_object_type
            FROM pres_object_tab) diff, module_tab m
      WHERE diff.module = m.module
        AND m.active = 'TRUE'
      ORDER BY 3;
   CURSOR get_changed_projection IS
      SELECT 'New modules' change_info, COUNT(*) cnt, 1
      FROM module_tab 
      WHERE module IN
      (SELECT DISTINCT component
       FROM (SELECT component FROM fnd_projection_tab
             MINUS
             SELECT component FROM fnd_projection_snap_tab))
      UNION
      SELECT 'New projections for existing modules' change_info, COUNT(*) cnt, 2
      FROM   (SELECT projection_name, component FROM fnd_projection_tab
              MINUS
              SELECT projection_name, component FROM fnd_projection_snap_tab) diff
      WHERE  diff.component NOT IN (SELECT component FROM fnd_projection_tab
                                    MINUS
                                    SELECT component FROM fnd_projection_snap_tab)
      UNION
      SELECT 'New actions for existing projections' change_info, COUNT(*) cnt, 3
      FROM (SELECT p.component, p.projection_name, pa.action_name
            FROM   fnd_proj_action_tab pa, fnd_projection_tab p
            WHERE  pa.projection_name = p.projection_name
            MINUS
            SELECT p.component, p.projection_name, pa.action_name
            FROM   fnd_proj_action_snap_tab pa, fnd_projection_snap_tab p
            WHERE  pa.projection_name = p.projection_name)
      WHERE (component, projection_name) NOT IN (SELECT component, projection_name FROM fnd_projection_tab
                                                 MINUS
                                                 SELECT component, projection_name FROM fnd_projection_snap_tab)
      UNION
      SELECT 'New entities for existing projections' change_info, COUNT(*) cnt, 4
      FROM (SELECT p.component, p.projection_name, pe.entity_name
            FROM   fnd_proj_entity_tab pe, fnd_projection_tab p
            WHERE  pe.projection_name = p.projection_name
            MINUS
            SELECT p.component, p.projection_name, pe.entity_name
            FROM   fnd_proj_entity_snap_tab pe, fnd_projection_snap_tab p
            WHERE  pe.projection_name = p.projection_name)
      WHERE (component, projection_name) NOT IN (SELECT component, projection_name FROM fnd_projection_tab
                                                 MINUS
                                                 SELECT component, projection_name FROM fnd_projection_snap_tab)
      UNION
      SELECT 'New CRUD operations for existing projection entities' change_info, COUNT(*) cnt, 5
      FROM (SELECT p.component, p.projection_name, pe.entity_name, RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRANSLATE(pe.operations_allowed, pes.operations_allowed, RPAD(' ', LENGTH(pes.operations_allowed), ' ')), ' ', ''), 'C', 'Create,'), 'R', 'Read,'), 'U', 'Update,'), 'D', 'Delete,'), ',') new_crud_operations
      FROM   fnd_proj_entity_tab pe, fnd_projection_tab p, fnd_proj_entity_snap_tab pes, fnd_projection_snap_tab ps
      WHERE  pe.projection_name = p.projection_name
      AND    pe.projection_name = pes.projection_name
      AND    pe.entity_name = pes.entity_name
      AND    pes.projection_name = ps.projection_name
      AND    p.component = ps.component
      AND    REPLACE(TRANSLATE(pe.operations_allowed, pes.operations_allowed, RPAD(' ', LENGTH(pes.operations_allowed), ' ')), ' ', '') IS NOT NULL)
      WHERE (component, projection_name) NOT IN (SELECT component, projection_name FROM fnd_projection_tab
                                                 MINUS
                                                 SELECT component, projection_name FROM fnd_projection_snap_tab)
      UNION
      SELECT 'New entity actions for existing projections' change_info, COUNT(*) cnt, 6
      FROM (SELECT p.component, p.projection_name, pe.entity_name, pea.action_name
            FROM   fnd_proj_ent_action_tab pea, fnd_proj_entity_tab pe, fnd_projection_tab p
            WHERE  pea.projection_name = pe.projection_name
            AND    pea.entity_name = pe.entity_name
            AND    pe.projection_name = p.projection_name
            MINUS
            SELECT p.component, p.projection_name, pe.entity_name, pea.action_name
            FROM   fnd_proj_ent_action_snap_tab pea, fnd_proj_entity_snap_tab pe, fnd_projection_snap_tab p
            WHERE  pea.projection_name = pe.projection_name
            AND    pea.entity_name = pe.entity_name
            AND    pe.projection_name = p.projection_name)
      WHERE (component, projection_name, entity_name) NOT IN (SELECT p.component, p.projection_name, pe.entity_name
                                                              FROM   fnd_proj_entity_tab pe, fnd_projection_tab p
                                                              WHERE  pe.projection_name = p.projection_name
                                                              MINUS
                                                              SELECT p.component, p.projection_name, pe.entity_name
                                                              FROM   fnd_proj_entity_snap_tab pe, fnd_projection_snap_tab p
                                                              WHERE  pe.projection_name = p.projection_name)
      UNION
      SELECT 'Removed modules' change_info, COUNT(*) cnt, 7
      FROM   module_tab 
      WHERE  module IN (SELECT component FROM fnd_projection_snap_tab
                        MINUS
                        SELECT component FROM fnd_projection_tab)
      UNION
      SELECT 'Removed Projection' change_info, COUNT(*) cnt, 8
      FROM   (SELECT projection_name, component FROM fnd_projection_snap_tab
              MINUS
              SELECT projection_name, component FROM fnd_projection_tab) diff
      WHERE  diff.component NOT IN (SELECT component FROM fnd_projection_snap_tab
                                    MINUS
                                    SELECT component FROM fnd_projection_tab)
      ORDER BY 3;
            
      
BEGIN
   General_SYS.Check_Security(service_, 'DATABASE_SYS', 'Installation_Summary');
   Log_SYS.Fnd_Trace_(Log_SYS.error_, ' ');
   Log_SYS.Fnd_Trace_(Log_SYS.error_, ' ');
   Log_SYS.Fnd_Trace_(Log_SYS.error_, '-----------------------------------');
   Log_SYS.Fnd_Trace_(Log_SYS.error_, 'D E P L O Y M E N T   S U M M A R Y');
   Log_SYS.Fnd_Trace_(Log_SYS.error_, '-----------------------------------');
   Log_SYS.Fnd_Trace_(Log_SYS.error_, ' ');
   Log_SYS.Fnd_Trace_(Log_SYS.error_, 'INVALID OBJECTS');
   Log_SYS.Fnd_Trace_(Log_SYS.error_, '---------------');
   FOR row_inv IN get_invalids LOOP
      Log_SYS.Fnd_Trace_(Log_SYS.error_, RPAD(row_inv.object_type||':', 55)||LPAD(row_inv.cnt, 5));
      found_ := TRUE;
   END LOOP;
   IF NOT found_ THEN
      Log_SYS.Fnd_Trace_(Log_SYS.error_, RPAD('INVALID OBJECTS:', 55)||LPAD('0', 5));
   END IF;
   found_ := FALSE;
   Log_SYS.Fnd_Trace_(Log_SYS.error_, ' ');
   Log_SYS.Fnd_Trace_(Log_SYS.error_, 'PRESENTATION OBJECTS');
   Log_SYS.Fnd_Trace_(Log_SYS.error_, '--------------------');
   FOR row_po IN get_changed_po LOOP
      Log_SYS.Fnd_Trace_(Log_SYS.error_, RPAD(row_po.change_info||':', 55)||LPAD(row_po.cnt, 5));
      found_ := TRUE;
   END LOOP;
   IF NOT found_ THEN
      Log_SYS.Fnd_Trace_(Log_SYS.error_, RPAD('PRESENTATION OBJECTS:', 55)||LPAD('0', 5));
   END IF;
   found_ := FALSE;
   Log_SYS.Fnd_Trace_(Log_SYS.error_, ' ');
   Log_SYS.Fnd_Trace_(Log_SYS.error_, 'PROJECTIONS');
   Log_SYS.Fnd_Trace_(Log_SYS.error_, '-----------');
   FOR row_pr IN get_changed_projection LOOP
      Log_SYS.Fnd_Trace_(Log_SYS.error_, RPAD(row_pr.change_info||':', 55)||LPAD(row_pr.cnt, 5));
      found_ := TRUE;
   END LOOP;
   IF NOT found_ THEN
      Log_SYS.Fnd_Trace_(Log_SYS.error_, RPAD('PROJECTIONS:', 55)||LPAD('0', 5));
   END IF;
   found_ := FALSE;
   Log_SYS.Fnd_Trace_(Log_SYS.error_, ' ');
END Installation_Summary;

@UncheckedAccess
FUNCTION Is_Rowkey_Enabled_Table (
   table_name_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   nullable_          VARCHAR2(1);
BEGIN
   IF (NOT Database_SYS.Column_Exist(table_name_, 'ROWKEY')) THEN
      RETURN(Fnd_Boolean_API.DB_FALSE);
   END IF;
   nullable_ := Installation_SYS.Get_Column_Nullable(table_name_, 'ROWKEY');
   CASE nullable_  
   WHEN 'N' THEN
      CASE Installation_SYS.Get_Column_On_Null(table_name_, 'ROWKEY')   
      WHEN 'YES' THEN
         RETURN(Fnd_Boolean_API.DB_TRUE);
      WHEN 'NO' THEN
         RETURN(Fnd_Boolean_API.DB_FALSE);
      ELSE
         RETURN(NULL);
      END CASE;
   WHEN 'Y' THEN
      RETURN(Fnd_Boolean_API.DB_FALSE);
   ELSE
      RETURN(NULL);
   END CASE;
END Is_Rowkey_Enabled_Table;


-- Handle_Lu_Modification
--   Use this method to update functionalities when ever an LU is modified (Key Rename, Lu Rename or both)
--   This should be called from a script in PostInstallation section of the installation.
--   Parameters:
--    module_name_        : Module the LU belong to
--    old_lu_name_        : Name of the old logical unit
--    old_table_name_     : [Optional] Name of the old table name, Default: will be the Base Table based on LU name
--                          (Must be defined if table was renamed, or no longer exist)
--    new_table_name_     : [Optional] Name of the old table name, Default: will be the Base Table based on new LU name
--    new_lu_name_        : [Optional] Name of the new logical unit. Default: old_lu_name_
--    regenerate_key_ref_ : [Optional] If the key ref needs to be regenerated (Default: TRUE).
--                          If the Key columns have not changed in (all) upgrade paths, set this to FALSE
--    key_ref_map_        : [Optional] Map between the old key column and the new column (Default: NULL)
--                          Format: PK1_OLD=PK1_NEW^PK2_OLD=PK2_NEW
--                          If a value is specified, the can implies that regenerate_key_ref_ = TRUE
--    options_            : [Optional] Future use. NULL
@UncheckedAccess
PROCEDURE Handle_Lu_Modification (
   module_name_           IN VARCHAR2,
   old_lu_name_           IN VARCHAR2,
   in_new_lu_name_        IN VARCHAR2 DEFAULT NULL,
   in_old_table_name_     IN VARCHAR2 DEFAULT NULL,
   in_new_table_name_     IN VARCHAR2 DEFAULT NULL,   
   in_regenerate_key_ref_ IN BOOLEAN  DEFAULT TRUE,
   key_ref_map_           IN VARCHAR2 DEFAULT NULL,
   options_               IN VARCHAR2 DEFAULT NULL )
IS
   new_lu_name_        VARCHAR2(128) := nvl(in_new_lu_name_, old_lu_name_);
   regenerate_key_ref_ BOOLEAN := CASE
                                  WHEN key_ref_map_ IS NOT NULL THEN TRUE
                                  ELSE in_regenerate_key_ref_ END;
   old_table_name_     VARCHAR2(128) := CASE
                                        WHEN in_old_table_name_ IS NOT NULL THEN in_old_table_name_
                                        ELSE Dictionary_SYS.Get_Base_Table_Name(old_lu_name_) END;
   new_table_name_     VARCHAR2(128) := CASE
                                        WHEN in_new_table_name_ IS NOT NULL THEN in_new_table_name_
                                        ELSE Dictionary_SYS.Get_Base_Table_Name(new_lu_name_) END;                                    
BEGIN
   Object_Connection_SYS.Handle_Lu_Modification(old_lu_name_, new_lu_name_, regenerate_key_ref_, key_ref_map_, options_);
   Custom_Objects_SYS.Handle_Lu_Modification(old_lu_name_,new_lu_name_);
   History_Log_Util_API.Handle_Lu_Modification(old_lu_name_,new_lu_name_,old_table_name_,new_table_name_,module_name_,in_regenerate_key_ref_,key_ref_map_);
END Handle_Lu_Modification;

@UncheckedAccess
FUNCTION Get_Solution_Set RETURN VARCHAR2
IS
	CURSOR get_solution_set IS 
	SELECT solution_set, description
	 FROM solution_set_tab;
	 
	solution_set_	solution_set_tab.solution_set%TYPE;
	description_	solution_set_tab.description%TYPE;
BEGIN
	OPEN  get_solution_set;
	FETCH get_solution_set INTO solution_set_, description_;
	CLOSE get_solution_set;
	RETURN (solution_set_||':'||description_);
END Get_Solution_Set;

@UncheckedAccess
FUNCTION Is_Solution_Set_Installed (
   solution_set_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
        FROM solution_set_tab
       WHERE solution_set = solution_set_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Is_Solution_Set_Installed;

FUNCTION Is_Valid_Oracle_Directory (
   directory_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Dbms_Lob.FileExists(BFILENAME(directory_name_, '.')) = 1) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Error occured in Database_SYS.Is_Valid_Oracle_Directory : '||SQLERRM);
      RETURN 'FALSE';
END Is_Valid_Oracle_Directory;