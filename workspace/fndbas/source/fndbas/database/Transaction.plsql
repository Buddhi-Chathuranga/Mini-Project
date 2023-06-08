-----------------------------------------------------------------------------
--
--  Logical unit: Transaction
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  951212  STLA  Created.
--  951228  STLA  New terminology using "area" instead of "instance" and
--                added new methods conforming to documentation.
--  960228  ERFO  Rearrangements in the code for internal pre-release for IFS.
--  960228  ERFO  Added method Logical_Unit_Is_Installed for integration tasks.
--  960424  ERFO  Corrected global "service_" contents, added trace calls for
--                methods and corrected commit/rollback in Process_All_Pending__.
--  960426  ERFO  Added method Set_Transaction_Trace for console functionality.
--  960506  STLA  Corrected misspelled savepoint name in Process_All_Pending.
--  960509  ERFO  Removed unecessary UPDATE-statement in Process_All_Pending.
--  960526  ERFO  Added user identity for background processes (Idea #629).
--  960819  ERFO  Improved performance in method Logical_Unit_Is_Installed by
--                using name convention between LU-name and package (Bug #749).
--  960819  ERFO  New method Package_Installed to be used when name convention
--                is not followed between logical units and packages (Idea #789).
--  960911  ERFO  Added timestamp information to trace messages (Idea #586).
--  960913  ERFO  Added logical unit DeferredJobState within this system service
--                to fully support correct attribute handle in logical unit
--                DeferredJob (Idea #795).
--  961117  ERFO  Added method Init_Processing__ to start a number of queues
--                in DBMS_JOB (Idea #862).
--  961117  ERFO  Changed the logic in Process_All_Pending__ to improve
--                transaction processing and to support several processes
--                within DBMS_JOB (Idea #862).
--  961126  ERFO  Added call to method User_profile_SYS.Set_User and added
--                a default parameter to method Init_Processing__.
--  961126  ERFO  Improved error handling for Oracle 7.3.
--  961212  ERFO  Added method Cleanup__ and added parameters to method
--                Init_Processing__ for cleanups in the queue (Bug #899).
--  961212  ERFO  Handle of language code for background processes (Bug #900).
--  970702  ERFO  Corrected background job cleanup problems (Bug #1327).
--  970725  ERFO  Replaced usage of obsolete method Utility_SYS.Get_User
--                with the new Fnd_Session_API.Get_Fnd_User (ToDo #1172).
--  970729  ERFO  Renamed method Execute_Type1__.
--  970822  MANY  Removed installation of cleanup job from Init_Processin_.
--  970825  MANY  Removed possible bug in Process_All_Pending__, exiting with
--                exception
--  970829  MANY  Changes to Init_Processing__(), does not remove
--                old Cleanup__, only initiates processes.
--  971020  ERFO  Solved problem with trace overflow (Bug #1709).
--  971022  MANY  Added method Init_Processes__(), new interface for initiating
--                processes according to FndSetting.
--  971023  ERFO  Removed method Init_Processing__.
--  971205  ERFO  Implementation of new concept queue_id based on logical unit
--                BatchQueue and BatchQueueMethod (ToDo #1712).
--  971212  ERFO  Corrected handle of language setting for background processes
--                in method Process_All_Pending__ (Bug #1880).
--  980116  ERFO  Added methods for progress/status improvements (ToDo #2009).
--  980118  ERFO  Introduced two entries in Event Registry (ToDo #2015).
--  980209  ERFO  Added WHERE-clause on 'State' in Get_Job_Count (Bug #2091).
--  980212  ERFO  Added method Get_Executing_Job_Arguments (ToDo #2120).
--  980223  ERFO  Changes according to Event Registry standards.
--  980301  ERFO  Added public method Is_Session_Deferred (ToDo #2148).
--  980301  ERFO  Added private method Update_Current_Job_Id__ (Bug #2175).
--  980305  ERFO  Added public method Get_Current_Job_Id (ToDo #2148).
--  980318  ERFO  Code rearrangements concerning implementation methods.
--  980319  ERFO  Added parameter 'posted_date_' in Deferred_Call (ToDo #2265).
--                Changes concerning BatchQueue in Init_Processing_ (ToDo #2264).
--  980325  ERFO  Changes in Process_All_Pending to guarantee that the global
--                current_job_id_ includes correct information (Bug #2280).
--  980305  ERFO  Removed length limitation for execution plans (Bug #2319).
--  980831  ERFO  Support background jobs without any parameters (Bug #2516).
--  980915  ERFO  Solve performance problem when changing language (Bug #2685).
--  981214  ERFO  Added lang_code option for batch queues by changing parameter
--                interface in Process_All_Pending__ (ToDo #3017).
--  990103  ERFO  Added parameters for language independency and changed
--                the logic within Process_All_Pending (ToDo #3017).
--  990104  ERFO  Corrected problem when calling method Deferred_Call with
--                parameters of length > 2000 (Bug #3037).
--  990124  ERFO  Another fix for 2k limit problem (Bug #3037).
--  990303  ERFO  Missing value for ERROR_TEXT in Event Registry (Bug #3165).
--  990327  ERFO  Corrected error messages LANGINDEP in Post_Local__ (ToDo #3017).
--  990505  ERFO  Solved language setting for lang-independent jobs (Bug #3349).
--  990601  ERFO  Added language parameter to retrieve default printer (Bug #3402).
--  990804  ERFO  Added column STARTED in method Process_All_Pending__ (ToDo #3480).
--  990818  HAAR  IN/OUT correction in method Execute_Type1__ (Bug #3518).
--  991025  ERFO  Added parameter queue_desc_ in Process_All_Pending__
--                and changed logik in Init_Process__ (ToDo #3668).
--  991027  HAAR  Changed Process_All_Pending so it exits when jobs changing language
--                instead of executing method Language_SYS.Change_Language (ToDo #3672).
--  991102  ERFO  Entries in method Post_Local__ may get language code NULL (Bug #3680).
--  991111  ERFO  A more general solution of the problem above (Bug #3680).
--  000215  ERFO  Corrected syntax in call to Error_SYS in Post_Local__ (Bug #14840).
--  000218  ERFO  Added PRAGMA on Lgical_Unit/Package_Is_Installed (ToDO #3849).
--  000502  ERFO  Added Client_SYS.Clear_Info for job processing (Bug #16004).
--  000809  ROOD  Corrected event checking in Set_Progress_Info (Bug #13972).
--  001127  ROOD  Added Logical_Unit_Is_Installed_Num and Package_Is_Installed_Num
--                to support web-kit. (ToDo #3964).
--  010904  ROOD  Added parameter status_type in Set_Status_Info (ToDo#4038).
--  010918  ROOD  Modified state behaviour in Process_All_Pending__ (ToDo#4038).
--  010924  HAAR  Added Metod_Is_Installed and  ed_Num (ToDo#4045).
--  011122  ROOD  Increased variable length in Get_Status_Lines___ (Bug#26191).
--  020701  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  021219  HAAR  Renamed Procedure_Type to Argument_Type.
--                Changed procedure Execute_Type1 to Execute_Type.
--                Changed Post_Local_, added new Deferred_Call and Dynamic_Call (ToDo#4146).
--  030113  ROOD  Added cleaning of transaction_sys_status_tab in Cleanup__ (Bug#34990).
--  030127  HAAR  Moved all registration of events to a separate file (ToDo#4205).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030220  ROOD  Removed hardcoded subcomponent name in message (ToDo#4149).
--  030324  ROOD  Added view DBA_PENDING_TRANSACTIONS for FNDEXT (ToDo#4241).
--  030623  ROOD  Set Is_Installed-methods depreciated. Replaced by equivalents
--                in Dictionary_SYS and in Database_SYS (ToDo#4162).
--  030815  HAAR  Changed Deferred_Call and Post_Local__ to be able to direct background job
--                to a specified Batch Queue (ToDo#4279).
--  030901  ROOD  Removed the view DBA_PENDING_TRANSACTIONS. The Oracle view is
--                instead granted directly to the role for language users (ToDo#4241).
--  030902  ROOD  Added check for appowner when using dbms_job (ToDo#4196).
--  031004  ROOD  Modified Process_All_Pending__ to better avoid errors in the
--                event handling, and also to be more tolerant to errors (Bug#37931).
--  040225  HAAR  Changed Post_Local___ to check that Batch Queue language
--                matches the background job language (Bug#39376).
--  040316  ASWI  Change NOT IN to NOT EXISTS in Cleanup__ delete statement (Bug#43346).
--  040331  HAAR  Unicode bulk changes, replaced Dbms_Sql with Execute Immediate (F1PR408B).
--  040422  HAAR  Execute_Type_Attribute___ and Execute_Type_Message___
--                changed to handle IN OUT parameter (Call #114272).
--  041119  HAAR  Changed to use Fnd_Setting_API.Set_Language (F1PR413E).
--  050408  JORA  Added assertion for dynamic SQL.  (F1PR481)
--  050523  HAAR  Added Dbms_Application_Info.Set_Session_Longops in Set_Progress_Info (F1PR480).
--  050610  BAMALK Refresh progress_info in Process_All_Pending__.(Bug#50794)
--  050615  HAAR  Changed Init_All_Processes__ and Init_All_Processing__ to use System privileges (F1PR483).
--  051108  ASWILK Improved performance in Cleanup__ using BULK COLLECT, FORALL (Bug#48401).
--  060105  UTGULK Annotated Sql injection.
--  061228  HAAR  Added Log_Started__, Log_Finished__ and Log_Error__ (Bug#62360).
--                Changed Init_Processing so it uses Batch_SYS.New_Job_App_Owner__.
--  070122  UTGULK Modified cursor check_lang_code in Post_Local__ to avoid oracle error.(Bug#61862).
--  070509  HAAR  Added possibility to add State to Cleanup procedure (Bug#65267).
--  070510  HAAR  Added Log_Global_Error_Text__ (Bug#65268).
--  071107  UTGULK  Added error msg in Execute_Type_Parameter___(Bug#67902).
--  071019  HAAR  Added functions Cleanup_Executing__ and Resubmit__ (Bug#68756).
--                Added new methods for Deferred_Call and Update_Schedule_Id__.
--  080312  HAAR  Implement Fnd_Session properties as a context (Bug#68143).
--  081021  DUWI  Added new public method Get_Posted_Job_Arguments.
--  081023  HASP  Corrected table name alias in method Cleanup_Executing__. (Bug#77986)
--  081029  HASP  Removed unnessary character from begining of file. (Bug#78120)
--  081216  HAAR  Added methods to use Autonomous transaction for logging in background jobs.
--                Log_Progress_Info and Log_Status_Info (IID#80009).
--  081229  DUWI  Changed method signature Get_Posted_Job_Arguments (Bug#79532).
--  090210  HAAR  Refactor Cleanup Jobs (IID#80009).
--  090324  SJayLK Bug 79001, Added support for BA Rendering Server Jobs.- Modified Process_All_Pending__
--  100127  HAAR  Changes needed for using Dbms_Scheduler instead of Dbms_Job (EACS-750).
--  091125  UsRaLK Changed method Cleanup_Executing__ to support Oracle RAC environments (Bug#87176).
--  100125  NaBaLk Improved the cursor in method Cleanup_Executing__ (Bug#88370)
--  100216  HAAR   Added support for RAC in Cleanup_Executing__ (Bug#89054).
--  100416  HAAR  Added Last_Execution_Date to Scheduled Tasks (Bug#90019).
--  100728  ChMu  Added Method Is_Scheduled_Task (Bug#92087).
--  110721  ChMu  Modified Set_Progress_Info to avoid string buffer overflow (Bug#94546).
--  110722  UsRa  Modified Process_All_Pending__ to support RAC environments properly (Bug#94618).
--  110722  UsRa  Modified Process_All_Pending__ to locate INST_ID and SERIAL# in a better way (Bug#95489).
--  110804  NaBa  Improved the cursor get_jobs in Get_Executing_Job_Arguments (RDTERUNTIME-685)
--  120213  USRA  Added a new overload of [Get_Posted_Job_Arguments] (Bug#100553/RDTERUNTIME-1911).
--  130410  NaBa  Job running check for initializing batch queues (Bug#109398)
--  130508  MADD  Modified Set_Progress_Info and Process_All_Pending__ to avoid string buffer overflow(Bug#109334)
--  140719  TMAD  Modified Get_Status_Lines___ function to return maximum possible length of characters when it manipulates
--                multi byte characters. (Bug#117811)
--  141030  DOBE  Patch merge (Bug#118868). Modified Process_All_Pending__ procedure to construct the message  
--                BACKGROUND_JOB_IS_PROCESSED without giving error when it manipulates multi byte characters.   
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Arguments_Rec IS RECORD
   (job_id transaction_sys_local_tab.id%TYPE,
    arguments_string transaction_sys_local_tab.arguments_string%TYPE);
TYPE Arguments_Table IS TABLE OF Arguments_Rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------

context_             CONSTANT VARCHAR2(30) := 'FNDSESSION_CTX';
TAG_STREAM_HEADER  CONSTANT VARCHAR2(30) := 'HEADER';
TAG_STREAM_MESSAGE   CONSTANT VARCHAR2(30) := 'MESSAGE';
TAG_STREAM_MESSAGE_PARAM   CONSTANT VARCHAR2(30) := 'MESSAGE_PARAM';
TAG_STREAM_ERR_HEADER  CONSTANT VARCHAR2(30) := 'ERR_HEADER';
TAG_STREAM_ERR_MESSAGE   CONSTANT VARCHAR2(30) := 'ERR_MESSAGE';
TAG_STREAM_ERR_MESSAGE_PARAM   CONSTANT VARCHAR2(30) := 'ERR_MESSAGE_PARAM';
TAG_STREAM_REFERENCE  CONSTANT VARCHAR2(30) := 'REFERENCE';
TAG_STREAM_URL CONSTANT VARCHAR2(30) := 'URL';
TAG_STREAM_NOTES CONSTANT VARCHAR2(30) := 'NOTES';
TAG_STREAM_LU CONSTANT VARCHAR2(30) := 'LU_NAME';
DB_TASK_WEB_SCHED_URL CONSTANT VARCHAR2(200):= 'page/ScheduledDatabaseTasksHandling/DatabaseTaskScheduleDetails;$filter=ScheduleId eq <<<ID>>>';
BACKGROUND_JOBS_WEB_URL CONSTANT VARCHAR2(200):='page/BackgroundJobsHandling/BackgroundJobsDetails;$filter=JobId eq <<<ID>>>';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Cleanup_Executing___(
    method_name_ IN VARCHAR2 DEFAULT NULL)
IS
   TYPE id_set IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
   id_set_         id_set;
   stmt_           VARCHAR2(1000);
   constant_       VARCHAR2(200);
   execute_action_ VARCHAR2(50);
BEGIN
   constant_ := Language_SYS.Translate_Constant(service_, 'STATE_CHANGED: This background job was set to state Error because the executing Oracle process was killed. ( Detected by cleanup process at :P1 )', NULL, TO_CHAR(SYSDATE, Client_SYS.date_format_ ));
   stmt_ := 'SELECT id
              FROM transaction_sys_local_tab t
             WHERE state = ''Executing''
               AND procedure_name NOT LIKE ''Transaction_SYS.Process_All_Pending__%''
               AND NOT EXISTS (SELECT 1
                           FROM gv$session s
                          WHERE t.sid = s.sid
                            AND t.serial# = s.serial#
                            AND nvl(t.inst_id, 1) = s.inst_id )';
   IF method_name_ IS NOT NULL THEN
      stmt_ := stmt_ || 'AND procedure_name = ''Batch_Sys.Fnd_Light_Cleanup_''';
   END IF;
   @ApproveDynamicStatement(2019-11-04,NaBaLK)
   EXECUTE IMMEDIATE stmt_ BULK COLLECT INTO id_set_;
   FOR i_ IN 1..id_set_.COUNT LOOP
      UPDATE transaction_sys_local_tab
         SET state = 'Error',
             error_text = constant_
       WHERE id = id_set_(i_);
   END LOOP;
   
   id_set_.DELETE;
   stmt_ := 'SELECT id
              FROM transaction_sys_local_tab t
             WHERE state = ''Executing''
               AND process_id IS NOT NULL
               AND NOT EXISTS (SELECT 1
                         FROM user_scheduler_running_jobs j
                        WHERE t.process_id = Batch_SYS.Get_Job_Id_(job_name))';
   IF method_name_ IS NOT NULL THEN
      stmt_ := stmt_ || 'AND procedure_name = ''Batch_Sys.Fnd_Light_Cleanup_''';
   END IF;
   @ApproveDynamicStatement(2019-09-27,NaBaLK)
   EXECUTE IMMEDIATE stmt_ BULK COLLECT INTO id_set_;
   FOR i_ IN 1..id_set_.COUNT LOOP
      UPDATE transaction_sys_local_tab
         SET state = 'Error',
             error_text = constant_
       WHERE id = id_set_(i_);
   END LOOP;
   
   id_set_.DELETE;
   execute_action_ := Deferred_Job_API.execute_job_action_;
   stmt_ := 'SELECT id
              FROM transaction_sys_local_tab t, gv$session s
             WHERE t.state = ''Executing''
               AND t.process_id IS NULL 
               AND t.sid = s.sid 
               AND t.serial# = s.serial#
               AND nvl(t.inst_id,1) = s.inst_id 
               AND (s.status = ''INACTIVE'' OR s.action <> '''||execute_action_||''')';
   IF method_name_ IS NOT NULL THEN
      stmt_ := stmt_ || 'AND procedure_name = ''Batch_Sys.Fnd_Light_Cleanup_''';
   END IF;
   @ApproveDynamicStatement(2019-11-04,NaBaLK)
   EXECUTE IMMEDIATE stmt_ BULK COLLECT INTO id_set_;
   FOR i_ IN 1..id_set_.COUNT LOOP
      UPDATE transaction_sys_local_tab
         SET state = 'Error',
             error_text = constant_
       WHERE id = id_set_(i_);
   END LOOP;
END Cleanup_Executing___;

PROCEDURE Execute_Type_Attribute___ (
   procedure_name_ IN VARCHAR2,
   arguments_      IN VARCHAR2 )
IS
   stmt_       VARCHAR2(32000);
   parameters_ VARCHAR2(32767) := arguments_;
   wrong_param EXCEPTION;
   PRAGMA      exception_init(wrong_param, -6550);
BEGIN
   Put_Trace___('Trying to execute: ' || procedure_name_ || '(' || arguments_ || ')');
   Assert_SYS.Assert_Is_Procedure(procedure_name_);
   stmt_ := 'BEGIN ' || procedure_name_ || '(:attr_); END;';
   BEGIN
      -- Use parameters instead of arguments, due to out parameters
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE stmt_ USING IN OUT parameters_;
   EXCEPTION
      WHEN wrong_param THEN
         -- Try to run without any parameters
         IF (arguments_ IS NULL) THEN
            stmt_ := replace(stmt_, '(:attr_)', '');
            @ApproveDynamicStatement(2006-01-05,utgulk)
            EXECUTE IMMEDIATE stmt_;
         ELSE
            RAISE;
         END IF;
   END;
   Put_Trace___('Call to ' || procedure_name_ || ' done');
END Execute_Type_Attribute___;


PROCEDURE Execute_Type_Message___ (
   procedure_name_ IN VARCHAR2,
   arguments_      IN VARCHAR2 )
IS
   stmt_       VARCHAR2(32000);
   parameters_ VARCHAR2(32767) := arguments_;
   wrong_param EXCEPTION;
   PRAGMA      exception_init(wrong_param, -6550);
BEGIN
   IF Message_SYS.Is_Message(arguments_) = FALSE THEN
      -- Arguments is not an IFS Message
      Error_SYS.Appl_General(service_, 'ARG_NOT_MESSAGE: Argument :P1 is not an IFS Message.', arguments_);
   END IF;
   Put_Trace___('Trying to execute: ' || procedure_name_ || '(' || arguments_ || ')');
   Assert_SYS.Assert_Is_Procedure(procedure_name_);
   stmt_ := 'BEGIN ' || procedure_name_ || '(:attr_); END;';
   BEGIN
      -- Use parameters instead of arguments, due to out parameters
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE stmt_ USING IN OUT parameters_;
   EXCEPTION
      WHEN wrong_param THEN
         -- Try to run without any parameters
         IF (arguments_ IS NULL) THEN
            stmt_ := replace(stmt_, '(:attr_)', '');
            @ApproveDynamicStatement(2006-01-05,utgulk)
            EXECUTE IMMEDIATE stmt_;
         ELSE
            RAISE;
         END IF;
   END;
   Put_Trace___('Call to ' || procedure_name_ || ' done');
END Execute_Type_Message___;


PROCEDURE Execute_Type_No___ (
   procedure_name_ IN VARCHAR2 )
IS
   stmt_       VARCHAR2(32000);
   wrong_param EXCEPTION;
   PRAGMA      exception_init(wrong_param, -6550);
BEGIN
   Put_Trace___('Trying to execute: ' || procedure_name_ || ';');
   Assert_SYS.Assert_Is_Procedure(procedure_name_);
   stmt_ := 'BEGIN ' || procedure_name_ || '; END;';
   @ApproveDynamicStatement(2006-01-05,utgulk)
   EXECUTE IMMEDIATE stmt_;
   Put_Trace___('Call to ' || procedure_name_ || ' done');
END Execute_Type_No___;


PROCEDURE Execute_Type_Parameter___ (
   procedure_name_ IN VARCHAR2,
   arguments_      IN VARCHAR2 )
IS
   TYPE varchar2_arr IS TABLE OF VARCHAR2(32730) INDEX BY BINARY_INTEGER;
   TYPE number_arr   IS TABLE OF NUMBER          INDEX BY BINARY_INTEGER;
   TYPE date_arr     IS TABLE OF DATE            INDEX BY BINARY_INTEGER;
   varchar2_ varchar2_arr;
   number_   number_arr;
   date_     date_arr;

   dummy_         dbms_describe.number_table;
   overload_      dbms_describe.number_table;
   position_      dbms_describe.number_table;
   argument_name_ dbms_describe.varchar2_table;
   data_type_     dbms_describe.number_table;
   default_value_ dbms_describe.number_table;
   in_out_        dbms_describe.number_table;

   cursor_       NUMBER;
   stmt_         VARCHAR2(32000);
   cnt_          NUMBER;
   i_            BINARY_INTEGER := 0;

   FUNCTION Get_Value RETURN VARCHAR2 IS
      value_ VARCHAR2(32000);
   BEGIN
      IF Client_SYS.Item_Exist(argument_name_(i_), arguments_) = TRUE THEN
         value_ := Client_SYS.Get_Item_Value(argument_name_(i_), arguments_);
         -- Add argument to statement
         stmt_ := stmt_ || argument_name_(i_)||'=>:arg'||to_char(i_)||',';
         -- Set default value to indicate that argument must have a bind value.
         default_value_(i_) := 0;
      ELSE -- Check if Default Value exists
         IF default_value_(i_) = 0 THEN -- Default Value don't exist
            Error_SYS.Appl_General(service_, 'NO_DEFAULT_VALUE: Argument :P1 must have a value, because default value do not exist.', argument_name_(i_));
         END IF;
      END IF;
      RETURN value_;
   END Get_Value;
BEGIN
   Assert_SYS.Assert_Is_Procedure(procedure_name_);

   IF arguments_ IS NULL THEN
      Error_SYS.Appl_General(service_, 'NOPARAMETER: Procedure [:P1] is defined with argument type [:P2] . But no parameters are defined.', procedure_name_ ,Argument_Type_API.Decode('PARAMETER'));
   END IF;

   stmt_ := 'BEGIN ' || procedure_name_ || '( ';
   cursor_ := dbms_sql.open_cursor;
   -- Describe the procedure
   Dbms_Describe.Describe_Procedure(procedure_name_, NULL, NULL, overload_, position_, dummy_, argument_name_,
                                    data_type_, default_value_, in_out_, dummy_, dummy_, dummy_, dummy_, dummy_);
   -- Loop over arguments to create statement
   BEGIN
      LOOP
         i_ := i_ + 1;
         IF overload_(i_) != 0 THEN
           -- Overloaded procedures not supported
            Error_SYS.Appl_General(service_, 'OVERLOAD: Procedure :P1 is overloaded and overloaded procedure is not supported.', procedure_name_);
         ELSIF in_out_(i_) != 0 THEN
         -- Only in parameters supported
            Error_SYS.Appl_General(service_, 'WRONG_ARGUMENT: Argument :P1 is of type IN/OUT or OUT, which is not supported.', argument_name_(i_));
         END IF;
         -- Check data type of argument
         IF     data_type_(i_) = 1 THEN -- String
            varchar2_(i_) := Get_Value;
         ELSIF (data_type_(i_) IN (2, 3)) THEN -- Number
            number_(i_) := to_number(Get_Value);
         ELSIF data_type_(i_) = 12 THEN -- Date
            date_(i_)   := to_date(Get_Value, Client_SYS.Date_Format_);
         ELSE
         -- Unsupported data_type
            Error_SYS.Appl_General(service_, 'UNSUPPORT_DATATYPE: Argument :P1 is of an unsupported data type.', argument_name_(i_));
         END IF;
      END LOOP;
   EXCEPTION
      -- Continue when no more arguments is found
      WHEN no_data_found THEN
         NULL;
   END;
   -- Remove last comma
   IF i_ > 1 THEN
      stmt_ := substr(stmt_, 1, length(stmt_) - 1);
   END IF;
   stmt_ := stmt_ || '); END;';
   Put_Trace___('Trying to execute: ' || procedure_name_ || '(' || arguments_ || ')');
   BEGIN
      @ApproveDynamicStatement(2006-01-05,utgulk)
      dbms_sql.parse(cursor_, stmt_, dbms_sql.native);
      -- Loop over arguments again to bind values
      i_ := 0;
      BEGIN
         LOOP
            i_ := i_ + 1;
            -- Only bind if not a Default Value
            IF default_value_(i_) = 0 THEN
               -- Check which data type argument is
               IF     data_type_(i_) = 1 THEN
                  dbms_sql.bind_variable(cursor_, 'arg'||to_char(i_), varchar2_(i_), 32730);
               ELSIF (data_type_(i_) IN (2, 3)) THEN
                  dbms_sql.bind_variable(cursor_, 'arg'||to_char(i_), number_(i_));
               ELSIF  data_type_(i_) = 12 THEN
                  dbms_sql.bind_variable(cursor_, 'arg'||to_char(i_), date_(i_));
               ELSE
                  -- Unsupported data_type
                  Error_SYS.Appl_General(service_, 'UNSUPPORT_DATATYPE: Argument :P1 is of an unsupported data type.', argument_name_(i_));
               END IF;
            END IF;
         END LOOP;
      EXCEPTION
         -- Continue when no more arguments is found
         WHEN no_data_found THEN
            NULL;
      END;
      cnt_ := dbms_sql.execute(cursor_);
   END;
   dbms_sql.close_cursor(cursor_);
   Put_Trace___('Call to ' || procedure_name_ || ' done');
EXCEPTION
   WHEN OTHERS THEN
      -- If any error, just raise!
      IF (dbms_sql.is_open(cursor_)) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      RAISE;
END Execute_Type_Parameter___;


FUNCTION Get_Status_Lines___ (
   job_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(32000);
   text_ VARCHAR2(2000);

   CURSOR get_lines IS
      SELECT text
      FROM   transaction_sys_status_tab
      WHERE  id = job_id_
      ORDER BY line;
BEGIN
   FOR rec IN get_lines LOOP
      text_ := rec.text;
      temp_ := temp_||text_||chr(10);
   END LOOP;
   RETURN(temp_);
EXCEPTION
   -- In case of more than 32000 characters, only return maximum characters that is possible...
   WHEN OTHERS THEN
      --'length(substrb(temp_||text_, 1, 31997))' returns length in characters of the string which is 31997 bytes long.
      -- This is important when the string 'temp_||text_' contains multi-byte characters.
      RETURN substr(temp_||text_, 1, length(substrb(temp_||text_, 1, 31997)))||chr(10);
END Get_Status_Lines___;


-- Put_Trace___
--   Method to be used for trace outprints for enhanced debug info.
PROCEDURE Put_Trace___ (
   text_ IN VARCHAR2 )
IS
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'TRANSACTION' || Log_SYS.Get_Separator || ' '||substr(text_, 1, 235)||'('||to_char(dbms_utility.get_time)||')');
END Put_Trace___;


PROCEDURE Set_Status_Info___ (
   info_            IN VARCHAR2,
   status_type_     IN VARCHAR2 DEFAULT 'WARNING',
   write_key_value_ IN BOOLEAN DEFAULT TRUE,
   line_            IN NUMBER DEFAULT NULL )
IS
   new_line_no_    NUMBER;
   current_job_id_ NUMBER := Get_Current_Job_Id;
   key_value_      transaction_sys_status_tab.key_value%TYPE;
   
   CURSOR get_next_line IS
      SELECT nvl(MAX(line), 0) + 1
      FROM  transaction_sys_status_tab
      WHERE id = current_job_id_;
BEGIN
   -- Should only set info on background jobs
   IF (Is_Session_Deferred) THEN
      -- Validate status type
      IF NOT status_type_ IN ('WARNING', 'INFO') THEN
         Error_SYS.Item_General(service_, 'STATUS_TYPE', 'ERRONEOUSTYPE: The status type :P1 is not valid, Only WARNING and INFO is allowed!', status_type_);
      END IF;
      -- Find next line number
      IF (line_ IS NULL) THEN
         OPEN get_next_line;
         FETCH get_next_line INTO new_line_no_;
         CLOSE get_next_line;
      ELSE
         new_line_no_ := line_;
      END IF;
      IF (write_key_value_) THEN
         key_value_ := Substr(Fnd_Context_SYS.Find_Value('ERROR_FORMATTED_KEY'), 1, 2000);
      END IF;	  
      -- Insert the info
      INSERT
         INTO transaction_sys_status_tab
            (id, line, text, status_type, key_value, rowversion)
         VALUES
            (current_job_id_, new_line_no_, info_, status_type_, key_value_, 1);
   END IF;
END Set_Status_Info___;

FUNCTION Replace_Id___ (
   base_url_ IN VARCHAR2,
   id_       IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN REPLACE(base_url_, '<<<ID>>>', id_);
END Replace_Id___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Cleanup__
--   Method to be executed to cleanup the queue from old and ready jobs.
--   This method checks the table transaction_sys_tab and removes entries.
PROCEDURE Cleanup__
IS
   tnum_     NUMBER;
   PRAGMA autonomous_transaction;
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Cleanup__');
   tnum_ := to_number(Fnd_Setting_API.Get_Value('KEEP_DEFJOBS'));
   Transaction_SYS.Cleanup__(tnum_, 'Ready');
   tnum_ := to_number(Fnd_Setting_API.Get_Value('KEEP_DEFJOBS_WARNING'));
   Transaction_SYS.Cleanup__(tnum_, 'Warning');
   tnum_ := to_number(Fnd_Setting_API.Get_Value('KEEP_DEFJOBS_ERROR'));
   Transaction_SYS.Cleanup__(tnum_, 'Error');
   Transaction_SYS.Cleanup_Executing__;
   @ApproveTransactionStatement(2013-11-08,haarse)
   COMMIT;
END Cleanup__;


-- Cleanup__
--   Method to be executed to cleanup the queue from old and ready jobs.
--   This method checks the table transaction_sys_tab and removes entries.
PROCEDURE Cleanup__ (
   cleanup_days_ IN NUMBER,
   state_        IN VARCHAR2 DEFAULT 'Ready')
IS
   PRAGMA autonomous_transaction;
   sysdate_       DATE := SYSDATE;
   TYPE trans_id_type IS TABLE OF transaction_sys_local_tab.id%TYPE;
   trans_id_       trans_id_type;

   CURSOR get_recs IS
      SELECT id
        FROM transaction_sys_local_tab
       WHERE exclude_cleanup = 'FALSE'
         AND state = state_
         AND nvl(executed, started) <= (sysdate_ - cleanup_days_);

BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Cleanup__');
   OPEN get_recs;
   LOOP
      FETCH get_recs BULK COLLECT INTO trans_id_ LIMIT 1000;
      FORALL i_ IN 1..trans_id_.count
         -- Remove old background jobs
         DELETE
            FROM transaction_sys_local_tab
            WHERE id = trans_id_(i_);

      FORALL i_ IN 1..trans_id_.count
         -- Remove status rows
         DELETE
            FROM transaction_sys_status_tab
            WHERE id = trans_id_(i_);
      -- Commit to avoid snapshot too old error
      @ApproveTransactionStatement(2013-11-08,haarse)
      COMMIT;
      EXIT WHEN get_recs%NOTFOUND;
   END LOOP;
   CLOSE get_recs;
   Dbms_Scheduler.Purge_Log(log_history => cleanup_days_);
END Cleanup__;


PROCEDURE Cleanup_Executing__
IS
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Cleanup_Executing__');
   Cleanup_Executing___;
END Cleanup_Executing__;


PROCEDURE Cleanup_Light_Cleanup_Job__
IS
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Cleanup_Light_Cleanup_Job__');
   Cleanup_Executing___('Batch_Sys.Fnd_Light_Cleanup_');
END Cleanup_Light_Cleanup_Job__;


-- Execute_Type__
--   Remote procedure call execution for temporary use from logical
--   unit DeferredJob to able to run job online.
@UncheckedAccess
PROCEDURE Execute_Type__ (
   procedure_name_    IN VARCHAR2,
   arguments_         IN VARCHAR2,
   argument_type_db_  IN VARCHAR2 DEFAULT 'ATTRIBUTE' )
IS
BEGIN
   IF    argument_type_db_ = 'NONE' THEN
      Execute_Type_No___(procedure_name_);
   ELSIF argument_type_db_ = 'ATTRIBUTE' THEN
      Execute_Type_Attribute___(procedure_name_, arguments_);
   ELSIF argument_type_db_ = 'MESSAGE' THEN
      Execute_Type_Message___(procedure_name_, arguments_);
   ELSIF argument_type_db_ = 'PARAMETER' THEN
      Execute_Type_Parameter___(procedure_name_, arguments_);
   ELSE
      Error_SYS.Appl_General(service_, 'UNKNOWN: Unknown argument type :P1', Argument_Type_API.Decode(argument_type_db_));
   END IF;
END Execute_Type__;


-- Init_Processing__
--   Clear the job queue, update status of not completed jobs and
--   load one or several Process_All_Pending-daemons into DBMS_JOB.
--   This method work for one specific queue defined in BatchQueue.
PROCEDURE Init_Processing__ (
   queue_id_ IN NUMBER )
IS
   job_key_     NUMBER;
   queue_count_ NUMBER;
   node_        NUMBER;
   exec_plan_   VARCHAR2(200);
   lang_code_   VARCHAR2(5);
   count_       NUMBER;
   queue_desc_  VARCHAR2(2000);
   job_name_    dba_scheduler_jobs.job_name%TYPE;

   CURSOR get_running IS
      SELECT j.job_name
        FROM dba_scheduler_jobs     j,
             dba_scheduler_job_args a
       WHERE j.owner = Sys_Context('USERENV', 'CURRENT_SCHEMA')
         AND j.owner = a.owner
         AND j.job_name = a.job_name
         AND a.argument_name = 'ACTION_'
         AND j.state = 'RUNNING'
         AND (upper(a.VALUE) LIKE 'TRANSACTION_SYS.PROCESS_ALL_PENDING__(' || queue_id_ || ')%' OR
              upper(a.VALUE) LIKE 'TRANSACTION_SYS.PROCESS_ALL_PENDING__(' || queue_id_ || ',%')
         AND (EXISTS (SELECT 1
                        FROM fnd_user f
                       WHERE f.identity = j.job_creator)
          OR Security_SYS.Has_System_Privilege('ADMINISTRATOR')='TRUE');

   CURSOR get_queue IS
      SELECT description,
             nvl(process_number, 1),
             nvl(execution_plan, 'sysdate + 30/86400'),
             nvl(lang_code, '%'),
             decode(node_attached_db, 'TRUE', node, NULL) node
      FROM   batch_queue
      WHERE  queue_id = queue_id_
      AND    active = 'TRUE';
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Init_Processing__');
   -- Check for system privilege
   Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User);
   
   --
   -- Check for running processes
   --
   OPEN get_running;
   FETCH get_running INTO job_name_;
   CLOSE get_running;
   
   IF job_name_ IS NOT NULL THEN
      Error_SYS.Appl_General(service_, 'ALREADYRUN1: One or more batch jobs are currently running. If you still need to initialize the queue, first break the running jobs from Databases Processes window and retry');
   END IF;
   --
   -- Remove all processes for specified queue
   --
   Batch_SYS.Remove_Job_On_Method_('TRANSACTION_SYS.PROCESS_ALL_PENDING__(' || queue_id_ || ',');
   Batch_SYS.Remove_Job_On_Method_('TRANSACTION_SYS.PROCESS_ALL_PENDING__(' || queue_id_ || ')');
   --
   -- Set number of queues
   -- If queue not active or not found, just return
   --
   OPEN get_queue;
   FETCH get_queue INTO queue_desc_, queue_count_, exec_plan_, lang_code_, node_;
   IF (get_queue%NOTFOUND) THEN
      CLOSE get_queue;
      RETURN;
   END IF;
   CLOSE get_queue;
   --
   -- Set to same environment as for IFS/Client, but don't set language
   --
   Fnd_Session_API.Set_Language(NULL);
   --
   --  Add the correct number of processes for the queue to DBMS_JOB
   --
   count_ := 0;
   WHILE (queue_count_ > count_) LOOP
      Batch_SYS.New_Job_App_Owner__(job_key_, 'Transaction_SYS.Process_All_Pending__('||queue_id_||','''||queue_desc_||''','''||lang_code_||''',job_id_)', exec_plan_, node_);
      count_ := count_ + 1;
   END LOOP;
END Init_Processing__;


-- Init_All_Processing__
--   Initiate background processing for all defined and active queues.
PROCEDURE Init_All_Processing__ (
   dummy_ IN NUMBER )
IS
   job_name_    dba_scheduler_jobs.job_name%TYPE;

   CURSOR get_running IS
      SELECT j.job_name
        FROM dba_scheduler_jobs     j,
            dba_scheduler_job_args a
       WHERE j.owner = Sys_Context('USERENV', 'CURRENT_SCHEMA')
         AND j.owner = a.owner
         AND j.job_name = a.job_name
         AND a.argument_name = 'ACTION_'
         AND j.state = 'RUNNING'
         AND upper(a.VALUE) LIKE 'TRANSACTION_SYS.PROCESS_ALL_PENDING__%'
         AND (EXISTS (SELECT 1
                        FROM fnd_user f
                       WHERE f.identity = j.job_creator)
          OR Security_SYS.Has_System_Privilege('ADMINISTRATOR')='TRUE');

  CURSOR get_jobs IS
     SELECT j.job_name
       FROM dba_scheduler_jobs     j,
            dba_scheduler_job_args a
       WHERE j.owner = Sys_Context('USERENV', 'CURRENT_SCHEMA')
         AND j.owner = a.owner
         AND j.job_name = a.job_name
         AND a.argument_name = 'ACTION_'
         AND upper(a.VALUE) LIKE 'TRANSACTION_SYS.PROCESS_ALL_PENDING__%'
         AND (EXISTS (SELECT 1
                        FROM fnd_user f
                       WHERE f.identity = j.job_creator)
          OR Security_SYS.Has_System_Privilege('ADMINISTRATOR')='TRUE');

   CURSOR get_queue IS
      SELECT queue_id
      FROM batch_queue;
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Init_All_Processing__');
   -- Check for system privilege
   Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User);
   --
   -- Check for running processes
   --
   OPEN get_running;
   FETCH get_running INTO job_name_;
   CLOSE get_running;
   
   IF job_name_ IS NOT NULL THEN
      Error_SYS.Appl_General(service_, 'ALREADYRUN2: One or more batch jobs are currently running. If you still need to initialize the queues, first break the running jobs from Databases Processes window and retry');
   END IF;
   --
   --  Remove all old 1.2.2 / 2.0 processing without any queue tag
   --
   FOR rec IN get_jobs LOOP
      Batch_SYS.Remove_Job_(Batch_SYS.Get_Job_Id_(rec.job_name));
   END LOOP;
   --
   -- For each queue, initiate corresponding processes
   --
   FOR rec IN get_queue LOOP
      Init_Processing__(rec.queue_id);
   END LOOP;
END Init_All_Processing__;


PROCEDURE Stop_Processing__ (
   queue_id_ IN NUMBER )
IS
   job_name_    dba_scheduler_jobs.job_name%TYPE;

   CURSOR get_running IS
      SELECT j.job_name
        FROM dba_scheduler_jobs     j,
             dba_scheduler_job_args a
       WHERE j.owner = Sys_Context('USERENV', 'CURRENT_SCHEMA')
         AND j.owner = a.owner
         AND j.job_name = a.job_name
         AND a.argument_name = 'ACTION_'
         AND j.state = 'RUNNING'
         AND (upper(a.VALUE) LIKE 'TRANSACTION_SYS.PROCESS_ALL_PENDING__(' || queue_id_ || ')%' OR
              upper(a.VALUE) LIKE 'TRANSACTION_SYS.PROCESS_ALL_PENDING__(' || queue_id_ || ',%')
         AND (EXISTS (SELECT 1
                        FROM fnd_user f
                       WHERE f.identity = j.job_creator)
          OR Security_SYS.Has_System_Privilege('ADMINISTRATOR')='TRUE');

   CURSOR get_jobs IS
      SELECT j.job_name
        FROM dba_scheduler_jobs     j,
             dba_scheduler_job_args a
       WHERE j.owner = Sys_Context('USERENV', 'CURRENT_SCHEMA')
         AND j.owner = a.owner
         AND j.job_name = a.job_name
         AND a.argument_name = 'ACTION_'
         AND (upper(a.VALUE) LIKE 'TRANSACTION_SYS.PROCESS_ALL_PENDING__(' || queue_id_ || ')%' OR
              upper(a.VALUE) LIKE 'TRANSACTION_SYS.PROCESS_ALL_PENDING__(' || queue_id_ || ',%')
         AND (EXISTS (SELECT 1
                        FROM fnd_user f
                       WHERE f.identity = j.job_creator)
          OR Security_SYS.Has_System_Privilege('ADMINISTRATOR')='TRUE');

BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Stop_Processing__');
   -- Check for system privilege
   Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User);
   --
   -- Check for running processes
   --
   OPEN get_running;
   FETCH get_running INTO job_name_;
   CLOSE get_running;
   
   IF job_name_ IS NOT NULL THEN
      Error_SYS.Appl_General(service_, 'STOPALREADYRUN: One or more batch jobs are currently running. If you still need to stop the queue, first break the running jobs from Databases Processes window and retry');
   END IF;
   --
   -- Remove all processes for specified queue
   --
   FOR rec IN get_jobs LOOP
      Batch_SYS.Remove_Job_(Batch_SYS.Get_Job_Id_(rec.job_name));
   END LOOP;
END Stop_Processing__;


FUNCTION Log_Started__ (
   job_              IN NUMBER,
   procedure_name_   IN VARCHAR2,
   description_      IN VARCHAR2) RETURN NUMBER
IS
   id_               NUMBER;
   PRAGMA            AUTONOMOUS_TRANSACTION;
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Log_Started__');
   SELECT transaction_sys_seq.nextval
      INTO id_
      FROM dual;
   INSERT
      INTO transaction_sys_local_tab (
         id,
         argument_type,
         procedure_name,
         arguments,
         arguments_string,
         state,
         created,
         posted,
         started,
         username,
         lang_code,
         queue_id,
         description,
         lang_indep,
         process_id,
         exclude_cleanup,
         rowversion)
      VALUES (
         id_,
         'NO',
         Substr(procedure_name_,1, 61),
         NULL,
         NULL,
         'Executing',
         SYSDATE,
         SYSDATE,
         SYSDATE,
         Fnd_Session_API.Get_Fnd_User,
         Fnd_Session_Api.Get_Language,
         NULL,
         description_,
         NULL,
         to_char(job_),
         'FALSE',
         1);
   Put_Trace___('Local post no: '||id_);
   Set_Current_Job_Id(id_);
   @ApproveTransactionStatement(2013-11-08,haarse)
   COMMIT; -- Always commit an autonomous transaction
   RETURN( id_ );
END Log_Started__;


PROCEDURE Log_Finished__ (
   id_               IN NUMBER )
IS
   slno_           BINARY_INTEGER;
   procedure_      VARCHAR2(65);
   long_op_id_     BINARY_INTEGER;
   so_far_         transaction_sys_local_tab.so_far%TYPE;
   total_work_     transaction_sys_local_tab.total_work%TYPE;
   description_    transaction_sys_local_tab.description%TYPE;
   PRAGMA            AUTONOMOUS_TRANSACTION;
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Log_Finished__');
   UPDATE transaction_sys_local_tab
      SET state = 'Ready',
          executed = SYSDATE
      WHERE id = id_
      RETURNING procedure_name, long_op_id, slno, so_far, total_work, description INTO procedure_, long_op_id_, slno_, so_far_, total_work_, description_;
   IF total_work_ IS NOT NULL THEN
      IF so_far_ < total_work_ THEN
         Log_Progress_Longop(long_op_id_, so_far_, slno_, id_, procedure_, total_work_, description_, (total_work_ - so_far_));
      END IF;
   END IF;
   @ApproveTransactionStatement(2013-11-08,haarse)
   COMMIT; -- Always commit an autonomous transaction
END Log_Finished__;


PROCEDURE Log_Error__ (
   id_               IN NUMBER,
   error_text_       IN VARCHAR2 )
IS
   PRAGMA            AUTONOMOUS_TRANSACTION;
BEGIN
   UPDATE transaction_sys_local_tab
      SET state = 'Error',
          executed = SYSDATE,
          error_text = error_text_
--          error_text = error_text_ || ' [' || global_error_text_ || ']'
      WHERE id = id_;
--   global_error_text_ := NULL;
   @ApproveTransactionStatement(2013-11-08,haarse)
   COMMIT; -- Always commit an autonomous transaction
END Log_Error__;


-- Post_Local__
--   Posts a local procedure call for processing.
FUNCTION Post_Local__ (
   procedure_name_   IN VARCHAR2,
   argument_type_db_ IN VARCHAR2,
   arguments_        IN VARCHAR2,
   description_      IN VARCHAR2,
   created_          IN DATE,
   lang_indep_       IN VARCHAR2,
   queue_id_         IN NUMBER DEFAULT NULL,
   total_work_       IN NUMBER DEFAULT NULL,
   stream_msg_on_completion_ IN VARCHAR2 DEFAULT 'FALSE',
   stream_params_ IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   id_           NUMBER;
   lang_code_    VARCHAR2(5)    := Fnd_Session_Api.Get_Language;
   job_queue_id_ NUMBER;
   check_        NUMBER         := 0;
   queue_lang_   VARCHAR2(5);
   method_       VARCHAR2(2000) := procedure_name_;
   arg_temp_     VARCHAR2(2000) := substr(arguments_,1, 2000);
   CURSOR check_lang_code IS
      SELECT 1
      FROM   batch_queue_tab
      WHERE  queue_id = queue_id_
      AND    nvl(lang_code_, '%') LIKE nvl(lang_code, '%');
   CURSOR get_lang_code IS
      SELECT lang_code
      FROM   batch_queue_tab
      WHERE  queue_id = queue_id_;
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Post_Local__');
   -- Get queue if no queue_id included as parameter
   IF (queue_id_ IS NULL) THEN
      job_queue_id_ := Batch_Queue_Method_API.Get_Default_Queue(procedure_name_, lang_code_);
   ELSE
      Batch_Queue_Api.Exist(queue_id_);
      OPEN  check_lang_code;
      FETCH check_lang_code INTO check_;
      CLOSE check_lang_code;
      -- Check that Queue language matches language for the job. Otherwise job can hang forever.
      IF (check_ = 0) THEN -- Failure, no match for language.
         OPEN  get_lang_code;
         FETCH get_lang_code INTO queue_lang_;
         CLOSE get_lang_code;
         Error_SYS.Appl_General(service_,
                                'QUEUE_ID: The language ":P1" of the queue ":P2" does not match the background job language ":P3"',
                                queue_lang_,
                                Batch_Queue_Api.Get_Description(queue_id_),
                                lang_code_);
      END IF;
      job_queue_id_ := queue_id_;
   END IF;
   -- Check if Argument_Type is OK
   Argument_Type_Api.Exist_Db(argument_type_db_);
   IF (lang_indep_ NOT IN ('TRUE','FALSE')) THEN
      Error_SYS.Appl_General(service_, 'LANGINDEP: The value ":P1" is not part of the value domain (TRUE/FALSE)', lang_indep_);
   END IF;
   IF (lang_code_ IS NULL) THEN
      lang_code_ := Fnd_Setting_API.Get_Value('DEFAULT_LANGUAGE');
   END IF;
   method_ := Substr(Replace(Replace(Initcap(Replace(method_, '_', ' ')), ' ', '_'), 'Api', 'API'), 1, 61);
   SELECT transaction_sys_seq.nextval
      INTO id_
      FROM dual;
   INSERT
      INTO transaction_sys_local_tab (
         id,
         argument_type,
         procedure_name,
         arguments,
         arguments_string,
         state,
         created,
         posted,
         username,
         lang_code,
         queue_id,
         description,
         lang_indep,
         total_work,
         exclude_cleanup,
         rowversion,
         stream_msg_on_completion,
         stream_params)
      VALUES (
         id_,
         argument_type_db_,
         method_,
         arguments_,
         arg_temp_,
         'Posted',
         created_,
         sysdate,
         Fnd_Session_API.Get_Fnd_User,
         lang_code_,
         job_queue_id_,
         description_,
         lang_indep_,
         total_work_,
         'FALSE',
         1,
         stream_msg_on_completion_,
         stream_params_);
   Put_Trace___('Local post no: '||id_);
   RETURN( id_ );
END Post_Local__;


-- Post_Local__
--   Posts a local procedure call for processing.
FUNCTION Post_Local__ (
   procedure_name_ IN VARCHAR2,
   arguments_      IN VARCHAR2,
   description_    IN VARCHAR2,
   created_        IN DATE,
   lang_indep_     IN VARCHAR2   
   ) RETURN NUMBER
IS
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Post_Local__');
   RETURN( post_local__(procedure_name_, 'ATTRIBUTE', arguments_, description_, created_, lang_indep_) );
END Post_Local__;


-- Process_All_Pending__
--   Executes all pending procedure calls in creation order. Execution
--   syntax depends on procedure type.
--   type ATTRIBUTE: statement = "BEGIN <procedure>(:attr_); END;"
--   attr_ will contain attribute string in Client_SYS format
PROCEDURE Process_All_Pending__ (
   queue_id_   IN NUMBER,
   queue_desc_ IN VARCHAR2,
   lang_code_  IN VARCHAR2 DEFAULT '%',
   job_        IN NUMBER   DEFAULT NULL )
IS
   CURSOR get_posted_jobs IS
      SELECT *
        FROM transaction_sys_local_tab
       WHERE state = 'Posted'
         AND queue_id = queue_id_
         AND lang_code LIKE lang_code_
       ORDER BY created,id;

   CURSOR find_warnings(id_ IN NUMBER) IS
      SELECT 1
        FROM transaction_sys_status_tab
       WHERE id = id_
         AND status_type = 'WARNING';

   CURSOR get_progress_info(id_ IN NUMBER) IS
      SELECT progress_info
        FROM transaction_sys_local_tab
       WHERE id = id_;
       
   CURSOR check_queue IS
      SELECT enabled
        FROM User_Scheduler_Jobs
       WHERE comments LIKE '<DISABLED_DURING_IFS_INSTALLATION>%Transaction_SYS.Process_All_Pending__('||queue_id_||',%';
   --
   TYPE posted_jobs_type IS TABLE OF get_posted_jobs%ROWTYPE INDEX BY PLS_INTEGER;
   --
   posted_jobs_rec_  posted_jobs_type;
   job_list_size_    NUMBER;
   batch_size_       NUMBER := 100;  -- Number of rows to processs in one major loop iteration
   --
   dummy_            NUMBER;
   error_            VARCHAR2(2000);
   error_message_    VARCHAR2(2000);
   new_state_        VARCHAR2(2000);
   msg_              VARCHAR2(32000);
   status_lines_     VARCHAR2(32000);
   sysdate_          DATE;
   old_lang_code_    VARCHAR2(5) := lang_code_;
   progress_info_    transaction_sys_local_tab.progress_info%TYPE;
   report_id_        VARCHAR2(30);
   report_mode_      VARCHAR2(30);
   attr_             VARCHAR2(2000);
   -- When Business Analytics Execution Server is used, the background job is continued in a nother machine asynchronously
   is_bars_report_   BOOLEAN := FALSE;
   is_error_         BOOLEAN := FALSE;
   clob_holder_      VARCHAR2(32000);
   clob_length_      NUMBER;
   user_env_sid_     NUMBER;
   current_inst_id_  NUMBER;
   current_serial_   NUMBER;
   no_of_lines_      NUMBER;
   slno_             BINARY_INTEGER;
   procedure_        VARCHAR2(65);
   queue_enabled_    User_Scheduler_Jobs.enabled%TYPE := 'TRUE';
   long_op_id_       BINARY_INTEGER;
   so_far_           transaction_sys_local_tab.so_far%TYPE;
   total_work_       transaction_sys_local_tab.total_work%TYPE;
   description_      transaction_sys_local_tab.description%TYPE;  
   stream_params_    transaction_sys_local_tab.stream_params%TYPE;
   stream_notes_     VARCHAR2(1000);
   stream_custom_ref_  VARCHAR2(4000);
   stream_url_       VARCHAR2(4000);
   stream_header_    VARCHAR2(2000);
   stream_message_   VARCHAR2(2000);
   stream_message_param_    VARCHAR2(1000);
   stream_trans_header_lu_  VARCHAR2(30);
   stream_trans_message_lu_ VARCHAR2(30);
   stream_default_msg_param_  VARCHAR2(1000);
   web_url_ VARCHAR2(2000);
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Process_All_Pending__');
   --
   <<all_jobs_loop>>
   LOOP
      OPEN  get_posted_jobs;
      FETCH get_posted_jobs BULK COLLECT INTO posted_jobs_rec_ LIMIT batch_size_;
      CLOSE get_posted_jobs;
      --
      EXIT WHEN posted_jobs_rec_.COUNT = 0 OR queue_enabled_ = 'FALSE';
      --
      job_list_size_ := posted_jobs_rec_.LAST;
      --
      <<current_batch_loop>>
      FOR idx_ IN 1..job_list_size_ LOOP
         OPEN check_queue;
         FETCH check_queue INTO queue_enabled_;
         IF check_queue%NOTFOUND THEN
            queue_enabled_ := 'TRUE';
         END IF;
         CLOSE check_queue;
         IF queue_enabled_ = 'FALSE' THEN
            GOTO end_loop;                   -- Stop processing if queue is disabled...
         END IF;
         BEGIN
            SELECT 1
              INTO dummy_
              FROM transaction_sys_local_tab
             WHERE state = 'Posted'
               AND id = posted_jobs_rec_(idx_).id
               FOR UPDATE NOWAIT;
         EXCEPTION
            WHEN OTHERS THEN
               GOTO end_loop;                   -- Skip job if already removed...
         END;
         BEGIN
            Set_Current_Job_Id(posted_jobs_rec_(idx_).id);
            Fnd_Session_API.Set_Language(posted_jobs_rec_(idx_).lang_code);
            Fnd_Session_API.Impersonate_Fnd_User(posted_jobs_rec_(idx_).username);
            user_env_sid_    := userenv('SID');
            current_inst_id_ := sys_context('USERENV', 'INSTANCE');
            current_serial_  := dbms_debug_jdwp.current_session_serial;
            UPDATE transaction_sys_local_tab
               SET state      = 'Executing',
                   process_id = to_char(job_),
                   started    = sysdate,
                   inst_id    = current_inst_id_,
                   sid        = user_env_sid_,
                   serial#    = current_serial_
             WHERE id = posted_jobs_rec_(idx_).id;
            @ApproveTransactionStatement(2013-05-10,haarse)
            COMMIT;
            Fnd_Context_SYS.Set_Value('CURRENT_SCHEDULE_ID', posted_jobs_rec_(idx_).schedule_id);
            Execute_Type__(posted_jobs_rec_(idx_).procedure_name, posted_jobs_rec_(idx_).arguments, posted_jobs_rec_(idx_).argument_type);
            $IF Component_Biserv_SYS.INSTALLED $THEN
               IF (   ( UPPER('Archive_API.Create_And_Print_Report__') = UPPER(posted_jobs_rec_(idx_).procedure_name) )
                  AND (   ( NVL(Xlr_System_Parameter_Util_API.Get_System_Parameter('BA_EXECUTION_SERVER_AVAILABLE'), 'NO') IN ('FOR_ALL_INFO_SERVICES_REPORTS', 'ONLY_FOR_SCHEDULED_REPORTS')))
                  AND (NOT( NVL(Xlr_System_Parameter_Util_API.Get_System_Parameter_Boolean('ACTIVATE_BR_CONTAINER'), FALSE)))) THEN
                  IF ( posted_jobs_rec_(idx_).argument_type = 'MESSAGE') THEN
                     clob_length_ := Dbms_Lob.getlength(posted_jobs_rec_(idx_).arguments);
                     clob_holder_ := Dbms_Lob.substr(posted_jobs_rec_(idx_).arguments, clob_length_, 1);
                     IF (Message_SYS.Is_Message(clob_holder_)) THEN
                        attr_ := NULL;
                        Message_SYS.Get_Attribute(clob_holder_, 'REPORT_ATTR', attr_);
                        IF (attr_ IS NOT NULL) THEN
                           report_id_   := Client_SYS.Get_Item_Value('REPORT_ID', attr_);
                           report_mode_ := Report_Definition_API.Get_Report_Mode(report_id_);
                           IF (report_mode_ = 'EXCEL1.0') THEN
                              is_bars_report_ := TRUE;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            $END
            --
            -- Set correct status and time
            --
            OPEN  find_warnings(posted_jobs_rec_(idx_).id);
            FETCH find_warnings INTO dummy_;
            IF find_warnings%FOUND THEN
               new_state_ := 'Warning';
            ELSE
               new_state_ := 'Ready';
            END IF;
            CLOSE find_warnings;
            sysdate_ := sysdate;
            -- Only update the status if BA Rendering Server is not used
            IF ( (NOT is_bars_report_) OR (new_state_ != 'Ready')) THEN
               UPDATE transaction_sys_local_tab
                  SET state = new_state_,
                      executed = sysdate_
                  WHERE id = Get_Current_Job_Id
               RETURNING procedure_name, long_op_id, slno, so_far, total_work, description INTO procedure_, long_op_id_, slno_, so_far_, total_work_, description_;
               IF (posted_jobs_rec_(idx_).schedule_id IS NOT NULL) THEN
                  Batch_Schedule_API.Update_Last_Execution_Date_(posted_jobs_rec_(idx_).schedule_id, sysdate_, Get_Execution_Time(Get_Current_Job_Id));
               END IF;
               IF (total_work_ IS NOT NULL AND new_state_ = 'Ready') THEN
                  IF (so_far_ < total_work_) THEN
                     Log_Progress_Longop(long_op_id_, so_far_, slno_, Get_Current_Job_Id, procedure_, total_work_, description_, (total_work_ - so_far_));
                  END IF;
               END IF;
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               IF (Error_SYS.Is_Foundation_Error(sqlcode)) THEN
                  error_message_ := ltrim(substr(sqlerrm, instr(sqlerrm, ':', 1, 2) + 1));
                  -- Return the Foundation1 error message
                  error_ := ltrim(substr(sqlerrm, instr(sqlerrm, ':', 1, 2) + 1))||
                            rpad(' ', 20)||substr(sqlerrm, 1, instr(sqlerrm, ':', 1, 2) - 1);
               ELSE
                  -- Return complete error structure
                  error_ := Substr(Dbms_Utility.Format_Error_Stack || ' '|| Dbms_Utility.Format_Error_Backtrace, 1, 2000);
               END IF;
               @ApproveTransactionStatement(2013-05-10,haarse)
               ROLLBACK;
               new_state_ := 'Error';
               sysdate_ := sysdate;
               UPDATE transaction_sys_local_tab
                  SET state      = new_state_,
                      executed   = sysdate_,
                      error_text = error_,
                      error_key_value = Substr(Fnd_Context_SYS.Find_Value('ERROR_FORMATTED_KEY'), 1, 2000)
                  WHERE id = posted_jobs_rec_(idx_).id;
               IF (posted_jobs_rec_(idx_).schedule_id IS NOT NULL) THEN
                  Batch_Schedule_API.Update_Last_Execution_Date_(posted_jobs_rec_(idx_).schedule_id, sysdate_, Get_Execution_Time(posted_jobs_rec_(idx_).id));
               END IF;
               is_error_ := TRUE;
         END;

         @ApproveTransactionStatement(2013-05-10,haarse)
         COMMIT; -- Commit the actual job



         IF(Deferred_Job_API.Get_Stream_Msg_On_Completio_DB(posted_jobs_rec_(idx_).id)= Fnd_Boolean_API.DB_TRUE AND NOT is_bars_report_) THEN

            stream_params_:= Deferred_Job_API.Get_Stream_Params(posted_jobs_rec_(idx_).id); -- The streams param IFS Message
            --URL
            stream_url_:=  Message_SYS.Find_Attribute(stream_params_, TAG_STREAM_URL, '');
            -- Notes
            stream_notes_ := Message_SYS.Find_Attribute(stream_params_, TAG_STREAM_NOTES, '');

            --CustomRef
            stream_custom_ref_ := Message_SYS.Find_Attribute(stream_params_, TAG_STREAM_REFERENCE, '');

            IF(posted_jobs_rec_(idx_).schedule_id IS NOT NULL) THEN
               web_url_ := Replace_Id___(DB_TASK_WEB_SCHED_URL, posted_jobs_rec_(idx_).schedule_id);
            ELSE
               web_url_ := Replace_Id___(BACKGROUND_JOBS_WEB_URL, posted_jobs_rec_(idx_).id);
            END IF;

            -- LU Name
            stream_trans_header_lu_ := Message_SYS.Find_Attribute(stream_params_, TAG_STREAM_LU, '');
            stream_trans_message_lu_ :=stream_trans_header_lu_;
            -- Message Parameter
            IF(posted_jobs_rec_(idx_).schedule_id IS NOT NULL) THEN
               stream_default_msg_param_ := Batch_Schedule_API.Get_Schedule_Name(posted_jobs_rec_(idx_).schedule_id);
            ELSE
               stream_default_msg_param_ := posted_jobs_rec_(idx_).description;
            END IF;

            IF NOT is_error_ THEN
               stream_header_ := Message_SYS.Find_Attribute(stream_params_,TAG_STREAM_HEADER , '');
               stream_message_ := Message_SYS.Find_Attribute(stream_params_, TAG_STREAM_MESSAGE, '');
               stream_message_param_:= Message_SYS.Find_Attribute(stream_params_, TAG_STREAM_MESSAGE_PARAM, '');

               -- Header
               IF stream_header_ IS NULL THEN
                  IF(posted_jobs_rec_(idx_).schedule_id IS NOT NULL) THEN
                     stream_header_ := Batch_Schedule_API.Get_Schedule_Name(posted_jobs_rec_(idx_).schedule_id);
                  ELSE
                     stream_header_ := posted_jobs_rec_(idx_).description;
                  END IF;
               END IF;

               -- Message
               IF (stream_message_ IS  NULL) THEN
                  stream_trans_message_lu_ :=service_;
                  stream_message_param_ := stream_default_msg_param_;
                  stream_message_ := 'JOBFINISHED: Finished Executing :P1';
               END IF;

           ELSE
               stream_header_ := Message_SYS.Find_Attribute(stream_params_,TAG_STREAM_ERR_HEADER , '');
               stream_message_ := Message_SYS.Find_Attribute(stream_params_, TAG_STREAM_ERR_MESSAGE, '');
               stream_message_param_:= Message_SYS.Find_Attribute(stream_params_, TAG_STREAM_ERR_MESSAGE_PARAM, '');


               -- Error Header
              IF(stream_header_ IS NULL) THEN
                 stream_trans_header_lu_ := service_;
                 stream_header_ := 'JOBERRHEADER: Background Job Error ';
               END IF;

               -- Error Message
               IF(stream_message_ IS NULL) THEN
                  stream_message_param_ := stream_default_msg_param_;
                  IF error_ IS  NOT NULL THEN
                     stream_message_ := error_message_;
                  ELSE
                     stream_trans_message_lu_ :=service_;
                     stream_message_ :=  'JOBERRORMSG: Error Executing Background Job :P1';
                  END IF;
               END IF;

               --Special case for schedules, Default URL Points to the Background Job incase of an error
               IF(stream_url_ IS NULL) THEN --URL has not been set
                  IF (posted_jobs_rec_(idx_).schedule_id IS NOT NULL) THEN -- Is schedule
                     web_url_ := Replace_Id___( BACKGROUND_JOBS_WEB_URL, posted_jobs_rec_(idx_).id);
                  END IF;
               END IF;

            END IF;
            IF(UPPER('Archive_API.Create_And_Print_Report__') = UPPER(posted_jobs_rec_(idx_).procedure_name)) THEN
              Fnd_Stream_API.Create_Reports_Stream(stream_header_,stream_message_,stream_trans_header_lu_,stream_trans_message_lu_,posted_jobs_rec_(idx_).username,stream_custom_ref_,stream_url_,stream_message_param_,stream_notes_,posted_jobs_rec_(idx_).schedule_id,posted_jobs_rec_(idx_).id);
            ELSE
              Fnd_Stream_API.Create_Background_Jobs_Stream(stream_header_,stream_message_,stream_trans_header_lu_,stream_trans_message_lu_,posted_jobs_rec_(idx_).username,stream_custom_ref_,stream_url_,stream_message_param_,stream_notes_,posted_jobs_rec_(idx_).schedule_id,posted_jobs_rec_(idx_).id, web_url_);
            END IF;
         END IF;

         IF (Event_SYS.Event_Enabled( service_, 'BACKGROUND_JOB_IS_PROCESSED' ) AND (NOT is_bars_report_ OR is_error_ OR new_state_ != 'Ready')) THEN
            msg_ := Message_SYS.Construct('BACKGROUND_JOB_IS_PROCESSED');
            --
            -- Standard event parameters
            --
            Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', sysdate );
            Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', posted_jobs_rec_(idx_).username );
            Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(posted_jobs_rec_(idx_).username) );
            Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(posted_jobs_rec_(idx_).username, 'SMTP_MAIL_ADDRESS') );
            Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(posted_jobs_rec_(idx_).username, 'MOBILE_PHONE') );
            --
            -- Primary key for object
            --
            Message_SYS.Add_Attribute( msg_, 'JOB_ID', posted_jobs_rec_(idx_).id );
            --
            -- Other important information
            --
            Message_SYS.Add_Attribute( msg_, 'DESCRIPTION', posted_jobs_rec_(idx_).description );
            Message_SYS.Add_Attribute( msg_, 'QUEUE', Batch_Queue_API.Get_Description(posted_jobs_rec_(idx_).queue_id) );
            Message_SYS.Add_Attribute( msg_, 'PROCEDURE_NAME', posted_jobs_rec_(idx_).procedure_name );
            Message_SYS.Add_Attribute( msg_, 'ARGUMENTS', posted_jobs_rec_(idx_).arguments_string );
            Message_SYS.Add_Attribute( msg_, 'STATE', new_state_ );
            Message_SYS.Add_Attribute( msg_, 'POSTED_DATETIME', posted_jobs_rec_(idx_).posted );
            Message_SYS.Add_Attribute( msg_, 'EXECUTED_DATETIME', sysdate_);
            Message_SYS.Add_Attribute( msg_, 'EXECUTED_DATE', sysdate_ );
            Message_SYS.Add_Attribute( msg_, 'EXECUTED_TIME', sysdate_ );
            Message_SYS.Add_Attribute( msg_, 'ERROR_TEXT', error_ );

            -- refresh progress info
            OPEN  get_progress_info(posted_jobs_rec_(idx_).id);
            FETCH get_progress_info INTO progress_info_;
            CLOSE get_progress_info;

            Message_SYS.Add_Attribute( msg_, 'PROGRESS_INFO', progress_info_ );
            Message_SYS.Add_Attribute( msg_, 'PROCESS_ID', posted_jobs_rec_(idx_).process_id );
            -- Avoid buffer overflow in msg_
            status_lines_ := Get_Status_Lines___(posted_jobs_rec_(idx_).id);
            no_of_lines_  := length(status_lines_) - length(replace(status_lines_,CHR(10)));
            IF (lengthb(msg_) + lengthb(status_lines_) + no_of_lines_) > 27985 THEN -- reserving 4000 characters for other event action information
               -- Deducted 62 characters for appended string below
               status_lines_ := substr(status_lines_, 1, length(substrb(status_lines_, 1, 27923 - lengthb(msg_) - no_of_lines_)))|| '... Buffer overflow, some status information was not included!';
            END IF;
            Message_SYS.Add_Attribute( msg_, 'STATUS_LINES', status_lines_ );
            Event_SYS.Event_Execute( service_, 'BACKGROUND_JOB_IS_PROCESSED', msg_ );
         END IF;
         @ApproveTransactionStatement(2013-05-10,haarse)
         COMMIT;         
         error_          := NULL;
         old_lang_code_  := posted_jobs_rec_(idx_).lang_code;
         Client_SYS.Clear_Info;
         is_bars_report_ := FALSE;
         attr_           := NULL;
         is_error_       := FALSE;
         Fnd_Session_API.Reset_Fnd_User;
         <<end_loop>>
         --Need at least one line of code after the GOTO label <<end_loop>>
         NULL;
      END LOOP current_batch_loop;
   END LOOP all_jobs_loop;
   @ApproveTransactionStatement(2013-05-10,haarse)
   COMMIT; -- Commit locks when exiting the loop due to language changed
EXCEPTION
   WHEN OTHERS THEN
      Fnd_Session_API.Reset_Fnd_User;
      @ApproveTransactionStatement(2013-05-10,haarse)
      ROLLBACK; -- Possible problems in the event handling are trapped here.
                -- Such problems should not stop the background job
      RAISE;
   END Process_All_Pending__;

PROCEDURE Modify_Stream_URL(
      url_ VARCHAR2 DEFAULT NULL)
 IS
 BEGIN
     Modify_Stream_Notification(url_=> url_); 
END Modify_Stream_URL;
      
PROCEDURE Modify_Stream_Reference(  
   reference_ VARCHAR2 DEFAULT NULL
 )
 IS 
 BEGIN
     Modify_Stream_Notification(reference_=> reference_);                         
END Modify_Stream_Reference;

PROCEDURE Modify_Stream_Message(
   trans_lu_name_ VARCHAR2 DEFAULT NULL,
   header_ VARCHAR2 DEFAULT NULL,
   message_ VARCHAR2 DEFAULT NULL,
   message_parameter_ VARCHAR2 DEFAULT NULL
)
IS
BEGIN
   Modify_Stream_Notification(trans_lu_name_=> trans_lu_name_,
                         header_=>header_,
                         message_=>message_,
                         message_parameter_=>message_parameter_);
END Modify_Stream_Message;

PROCEDURE Modify_Stream_Error_Message(
   trans_lu_name_ VARCHAR2 ,
   error_header_ VARCHAR2 DEFAULT NULL,
   error_message_ VARCHAR2 DEFAULT NULL,
   error_msg_parameter_ VARCHAR2 DEFAULT NULL)
IS
BEGIN
   Modify_Stream_Notification(trans_lu_name_=> trans_lu_name_,
                         error_header_=>error_header_,
                         error_message_=>error_message_,
                         error_message_parameter_=>error_msg_parameter_);

END Modify_Stream_Error_Message;

--
-- Used to Modify the Background Jobs Streams Message 
-- REFERENCE - URL of the Form Where the Stream Message Originated. Usually given as an external search. E.g.- ifswin:Ifs.Application.InfoServices.ScheduleReport?external_search=schedule_id=34. Falls back to TaskSchedule or BackgroundJobs forms if left empty. 
-- URL - URL of an Object to be Linked. E.g. - The appropriate Report Archive entry in the case of reports. E.g.- ifswin:Ifs.Application.InfoServices.ReportArchive?key1=10319
-- TRANS_LU_NAME - Required If Translatable Header/Message/ErrorHeader/ErrorMessage is given. Translation constants are looked up using this LU. Leave as NULL if Stream Header/Message does not need to be translated.
-- HEADER- Streams Header as a Translatable Constant E.g.- 'REPOK: Report Ready'
-- MESSAGE- Streams Message as a Translatable Constant E.g. - 'REPOKMSG: Report :P1 Is Now Ready'
-- MESSAGE_PARAMETER - A single parameter to be substributed in the MESSAGE Translatable Constant . This maybe NULL if the MESSAGE Translatable constant is parameterless
-- ERROR_HEADER - A Translatable constant,to be used as the Streams Header in the case of ERROR. 
-- ERROR_MESSAGE - A Translatable constant,to be used as the Streams Message in the case of ERROR. 
-- ERROR_ MSG_PARAMETER - A single parameter to be substributed in the ERROR_MESSAGE Translatable Constant . This maybe NULL if the  ERROR_MESSAGE Translatable constant is parameterless
--
PROCEDURE Modify_Stream_Notification(
   reference_ VARCHAR2 DEFAULT NULL,
   url_ VARCHAR2 DEFAULT NULL,
   trans_lu_name_ VARCHAR2 DEFAULT NULL,
   header_ VARCHAR2 DEFAULT NULL,
   message_ VARCHAR2 DEFAULT NULL,
   message_parameter_ VARCHAR2 DEFAULT NULL,
   error_header_ VARCHAR2 DEFAULT NULL, 
   error_message_ VARCHAR2 DEFAULT NULL, 
   error_message_parameter_ VARCHAR2 DEFAULT NULL)
IS

   PRAGMA autonomous_transaction;
   stream_params_ transaction_sys_local_tab.stream_params%TYPE;
   stream_msg_on_completion_ transaction_sys_local_tab.stream_msg_on_completion%TYPE; 
   job_id_ NUMBER;
BEGIN      
   job_id_ :=Get_Current_Job_Id;
   IF (job_id_ IS NULL) THEN
      RETURN;    
   END IF;
   
   stream_params_:= Deferred_Job_API.Get_Stream_Params(job_id_);  
   stream_msg_on_completion_ := Deferred_Job_API.Get_Stream_Msg_On_Completion(job_id_);   
   

   IF (stream_params_ IS NULL) THEN
      stream_params_:= Message_SYS.Construct('StreamParams');
   END IF;      
   IF(header_ IS NOT NULL) THEN     
      Message_SYS.Set_Attribute(stream_params_, TAG_STREAM_HEADER,header_);
   END IF;
   IF(message_ IS NOT NULL) THEN
      Message_SYS.Set_Attribute(stream_params_, TAG_STREAM_MESSAGE, message_);            
   END IF;
   IF(message_parameter_ IS NOT NULL) THEN
      Message_SYS.Set_Attribute(stream_params_, TAG_STREAM_MESSAGE_PARAM, message_parameter_);   
   END IF;
   IF(error_header_ IS NOT NULL) THEN
      Message_SYS.Set_Attribute(stream_params_, TAG_STREAM_ERR_HEADER,error_header_);
   END IF;
   IF(error_message_ IS NOT NULL) THEN
      Message_SYS.Set_Attribute(stream_params_, TAG_STREAM_ERR_MESSAGE, error_message_);            
   END IF;
   IF(error_message_parameter_ IS NOT NULL) THEN
      Message_SYS.Set_Attribute(stream_params_, TAG_STREAM_ERR_MESSAGE_PARAM, error_message_parameter_);            
   END IF;
   IF (reference_ IS NOT NULL) THEN
      Message_SYS.Set_Attribute(stream_params_, TAG_STREAM_REFERENCE, reference_);
   END IF;
   IF (url_ IS NOT NULL) THEN
      Message_SYS.Set_Attribute(stream_params_, TAG_STREAM_URL, url_);
   END IF;
   IF(trans_lu_name_ IS NOT NULL) THEN
      Message_SYS.Set_Attribute(stream_params_, TAG_STREAM_LU, trans_lu_name_);
   END IF;
   UPDATE transaction_sys_local_tab
   SET stream_params = stream_params_
   WHERE id = job_id_;
   -- Commiting because of autonomous_transaction
   @ApproveTransactionStatement(2016-01-21,hawilk)
   COMMIT;
END Modify_Stream_Notification;

PROCEDURE Resubmit__ (
   id_   IN NUMBER )
IS
   new_id_ NUMBER;
   CURSOR get_id IS
      SELECT *
        FROM transaction_sys_local_tab
       WHERE id = id_;
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Resubmit__');
   FOR rec IN get_id LOOP
      IF rec.state IN ('Error', 'Warning', 'Keep') THEN
         new_id_ := Transaction_SYS.Post_Local__(rec.procedure_name,
                                                 rec.argument_type,
                                                 rec.arguments,
                                                 rec.description,
                                                 SYSDATE,
                                                 CASE rec.lang_code
                                                    WHEN '%' THEN 'TRUE'
                                                    ELSE          'FALSE'
                                                 END);
         Client_SYS.Add_Info('Transaction', 'RESUBMITTED_JOB: The job :P1 has been re-submitted as job :P2.', id_, new_id_);
      ELSE
         -- Arguments is not an IFS Message
         Error_SYS.Appl_General(service_, 'WRONG_STATE: The job :P1 must be in state Keep, Warning and Executing not in state :P2.', id_, rec.state);
      END IF;
   END LOOP;
END Resubmit__;


PROCEDURE Update_Schedule_Id__ (
   id_               IN NUMBER,
   schedule_id_      IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Update_Schedule_Id__');
   UPDATE transaction_sys_local_tab
      SET schedule_id = schedule_id_
      WHERE id = id_;
END Update_Schedule_Id__;


-- Update_Current_Job_Id__
--   Update the flag for current executing job.
PROCEDURE Update_Current_Job_Id__ (
   job_id_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Update_Current_Job_Id__');
   Set_Current_Job_Id(job_id_);
END Update_Current_Job_Id__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Execution_Time (
   id_  IN NUMBER ) RETURN NUMBER 
IS
   execution_time_ NUMBER;
   CURSOR get_jobs IS
      SELECT t.executed - t.started
      FROM transaction_sys_local_tab t
      WHERE t.id = id_;
BEGIN
   OPEN get_jobs;
   FETCH get_jobs INTO execution_time_;
   CLOSE get_jobs;
   RETURN(execution_time_);
END Get_Execution_Time;

PROCEDURE Stop_Job (
   id_ IN NUMBER )
IS
   process_id_     transaction_sys_local_tab.process_id%TYPE;
   process_job_id_ batch_job.job_id%TYPE;
   state_          transaction_sys_local_tab.state%TYPE;   
   error_text_     transaction_sys_local_tab.error_text%TYPE := Language_SYS.Translate_Constant(service_, 'JOB_STOPPED: The job was stopped by user [:P1] when executing.', Fnd_Session_API.Get_Language, Fnd_Session_API.Get_Fnd_User);
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Stop_Job');
   SELECT t.process_id, t.state
   INTO process_id_, state_
   FROM transaction_sys_local_tab t
   WHERE id = id_;
   
   IF (state_ != 'Executing') THEN
      Error_SYS.Appl_General(service_, 'NO_EXECUTING_JOB: The job [:P1] is currently not executing.', id_);
   END IF;
   
   BEGIN
      SELECT t.job_id
      INTO process_job_id_
      FROM BATCH_JOB t
      WHERE t.job_id = process_id_;
   EXCEPTION
      WHEN no_data_found THEN
         process_job_id_ := NULL;
   END;
   
   IF(process_id_ IS NOT NULL AND process_job_id_ IS NOT NULL) THEN
      Batch_Job_API.Break_Job(job_id_ => process_id_);
      Log_Error__(id_, error_text_);
      Batch_Job_API.Reactivate_Job(job_id_ => process_id_);
   ELSE
      Error_SYS.Appl_General(service_, 'NO_PROCESS_ID: The process ID [:P1] does not exist.', process_id_);
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(service_, 'NO_JOB: No job with id [:P1] exists.', id_);
END Stop_Job;


-- Dynamic_Call
--   Processes a procedure call dynamically.
PROCEDURE Dynamic_Call (
   procedure_name_   IN VARCHAR2,
   argument_type_db_ IN VARCHAR2,
   arguments_        IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Dynamic_Call');
   Execute_Type__(procedure_name_, arguments_, argument_type_db_);
END Dynamic_Call;


-- Dynamic_Call
--   Processes a procedure call dynamically.
PROCEDURE Dynamic_Call (
   procedure_name_ IN VARCHAR2,
   arguments_      IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Dynamic_Call');
   Execute_Type__(procedure_name_, arguments_, 'ATTRIBUTE');
END Dynamic_Call;


-- Deferred_Call
--   Puts a procedure call on the local processing queue.
PROCEDURE Deferred_Call (
   id_              OUT NUMBER,
   procedure_name_   IN VARCHAR2,
   argument_type_db_ IN VARCHAR2,
   arguments_        IN VARCHAR2,
   description_      IN VARCHAR2,
   posted_date_      IN DATE DEFAULT sysdate,
   lang_indep_       IN VARCHAR2 DEFAULT 'FALSE',
   queue_id_         IN NUMBER DEFAULT NULL,
   total_work_       IN NUMBER DEFAULT NULL,
   stream_msg_on_completion_ IN VARCHAR2 DEFAULT 'FALSE',
   stream_notes_ IN VARCHAR2 DEFAULT NULL
   )
IS
   stream_params_    transaction_sys_local_tab.stream_params%TYPE;
BEGIN
  
   IF(stream_notes_ IS NOT NULL) THEN
      stream_params_ := Message_SYS.Construct('StreamParams');
      Message_SYS.Add_Attribute(stream_params_, 'NOTES', stream_notes_);
   END IF;   
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Deferred_Call');
   id_ := Post_Local__(procedure_name_, argument_type_db_, arguments_, description_, posted_date_, lang_indep_, queue_id_, total_work_,stream_msg_on_completion_,stream_params_);
END Deferred_Call;


-- Deferred_Call
--   Puts a procedure call on the local processing queue.
PROCEDURE Deferred_Call (
   procedure_name_   IN VARCHAR2,
   argument_type_db_ IN VARCHAR2,
   arguments_        IN VARCHAR2,
   description_      IN VARCHAR2,
   posted_date_      IN DATE DEFAULT sysdate,
   lang_indep_       IN VARCHAR2 DEFAULT 'FALSE',
   queue_id_         IN NUMBER DEFAULT NULL,
   total_work_       IN NUMBER DEFAULT NULL,
   stream_msg_on_completion_ IN VARCHAR2 DEFAULT 'FALSE',
   stream_notes_ IN VARCHAR2 DEFAULT NULL)
IS
   stream_params_ transaction_sys_local_tab.stream_params%TYPE;
   id_ NUMBER;
BEGIN
   IF(stream_notes_ IS NOT NULL) THEN
      stream_params_ := Message_SYS.Construct('StreamParams');
      Message_SYS.Add_Attribute(stream_params_, 'NOTES', stream_notes_);
   END IF;  
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Deferred_Call');
   id_ := Post_Local__(procedure_name_, argument_type_db_, arguments_, description_, posted_date_, lang_indep_, queue_id_, total_work_,stream_msg_on_completion_,stream_params_);
END Deferred_Call;


-- Deferred_Call
--   Puts a procedure call on the local processing queue.
PROCEDURE Deferred_Call (
   procedure_name_ IN VARCHAR2,
   arguments_      IN VARCHAR2,
   description_    IN VARCHAR2 DEFAULT NULL,
   posted_date_    IN DATE DEFAULT sysdate,
   lang_indep_     IN VARCHAR2 DEFAULT 'FALSE',
   stream_msg_on_completion_ IN VARCHAR2 DEFAULT 'FALSE',
   stream_notes_ IN VARCHAR2 DEFAULT NULL)
IS
   stream_params_ transaction_sys_local_tab.stream_params%TYPE;
BEGIN
   IF(stream_notes_ IS NOT NULL) THEN
      stream_params_ := Message_SYS.Construct('StreamParams');
      Message_SYS.Add_Attribute(stream_params_, 'NOTES', stream_notes_);
   END IF;  
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Deferred_Call');
   Deferred_Call(procedure_name_, 'ATTRIBUTE', arguments_, description_, posted_date_, lang_indep_,NULL,NULL,stream_msg_on_completion_,stream_notes_);
END Deferred_Call;


-- Is_Session_Deferred
--   Returns TRUE if the current session is running deferred.
@UncheckedAccess
FUNCTION Is_Session_Deferred RETURN BOOLEAN
IS
BEGIN
   RETURN(Nvl(Get_Current_Job_Id, 0) <> 0);
END Is_Session_Deferred;



@UncheckedAccess
FUNCTION Get_Current_Job_Id RETURN NUMBER
IS
BEGIN
   RETURN(Sys_Context(context_, 'CURRENT_JOB_ID'));
END Get_Current_Job_Id;



PROCEDURE Set_Current_Job_Id (
   job_id_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Set_Current_Job_Id');
   Fnd_Session_Util_API.Set_Current_Job_Id_(job_id_);
END Set_Current_Job_Id;


-- Get_Executing_Job_Arguments
--   Retrieves argument structure of all running instances
--   of a specific background job (package.procedure).
@UncheckedAccess
PROCEDURE Get_Executing_Job_Arguments (
   arguments_msg_  OUT VARCHAR2,
   procedure_name_ IN VARCHAR2 )
IS
   msg_   VARCHAR2(32000);
   found_ BOOLEAN := FALSE;
   CURSOR get_jobs IS
      SELECT
      id job_id, arguments_string
      FROM transaction_sys_local_tab t
      WHERE upper(procedure_name) = upper(procedure_name_)
      AND   state = 'Executing';
BEGIN
   msg_ := Message_SYS.Construct('JOB_ARGUMENTS');
   FOR rec IN get_jobs LOOP
      Message_SYS.Add_Attribute(msg_, to_char(rec.job_id), rec.arguments_string);
      found_ := TRUE;
   END LOOP;
   IF (found_) THEN
      arguments_msg_ := msg_;
   ELSE
      arguments_msg_ := NULL;
   END IF;
END Get_Executing_Job_Arguments;



PROCEDURE Log_Progress_Info (
   info_ IN VARCHAR2,
   to_step_ IN BINARY_INTEGER DEFAULT 0 )
IS
   PRAGMA            AUTONOMOUS_TRANSACTION;
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Log_Progress_Info');
   Set_Progress_Info(info_, to_step_);
   @ApproveTransactionStatement(2013-11-08,haarse)
   COMMIT;
END Log_Progress_Info;


PROCEDURE Log_Progress_Longop (
   long_op_id_  IN OUT BINARY_INTEGER,
   so_far_      IN OUT BINARY_INTEGER,
   slno_        IN OUT BINARY_INTEGER,
   job_id_      IN     NUMBER,
   procedure_   IN     VARCHAR2,
   total_work_  IN     BINARY_INTEGER,
   description_ IN     VARCHAR2,
   steps_       IN     BINARY_INTEGER DEFAULT 1 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Log_Progress_Longop');
   IF total_work_ IS NOT NULL 
   AND NVL(so_far_, -1) < total_work_ THEN
      IF (long_op_id_ IS NULL) THEN
         long_op_id_ := Dbms_Application_Info.Set_Session_Longops_Nohint;
         so_far_ := NVL(so_far_, 0);
      END IF;
      so_far_ := LEAST((NVL(so_far_, 0) + NVL(steps_, 1)), total_work_);
      Dbms_Application_Info.Set_Session_Longops(long_op_id_, slno_, procedure_, 0, job_id_, so_far_, total_work_, Substr(description_, 1, 32));
      UPDATE transaction_sys_local_tab
      SET long_op_id = long_op_id_,
          slno = slno_,
          so_far = so_far_
      WHERE id = job_id_;
   END IF;
END Log_Progress_Longop;


PROCEDURE Log_Progress_Longop (
   steps_ IN BINARY_INTEGER DEFAULT 1 )
IS
   job_id_      NUMBER := Get_Current_Job_Id;
   long_op_id_  BINARY_INTEGER;
   procedure_   transaction_sys_local_tab.procedure_name%TYPE;
   so_far_      transaction_sys_local_tab.so_far%TYPE;
   slno_        transaction_sys_local_tab.slno%TYPE;
   total_work_  transaction_sys_local_tab.total_work%TYPE;
   description_ transaction_sys_local_tab.description%TYPE;
   CURSOR get_rec IS
      SELECT procedure_name, long_op_id, slno, so_far, total_work, description
      FROM transaction_sys_local_tab
      WHERE id = job_id_;
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Log_Progress_Longop');
   OPEN get_rec;
   FETCH get_rec INTO procedure_, long_op_id_, slno_, so_far_, total_work_, description_;
   IF get_rec%FOUND THEN
      CLOSE get_rec;
      Log_Progress_Longop(long_op_id_, so_far_, slno_, job_id_, procedure_, total_work_, description_, steps_);
   ELSE
      CLOSE get_rec;
   END IF;
END Log_Progress_Longop;


PROCEDURE Log_Status_Info (
   info_            IN VARCHAR2,
   status_type_     IN VARCHAR2 DEFAULT 'WARNING',
   write_key_value_ IN BOOLEAN DEFAULT TRUE )
IS
   new_line_no_    NUMBER;
   current_job_id_ NUMBER := Get_Current_Job_Id;
   
   CURSOR get_next_line IS
      SELECT nvl(MAX(line), 0) + 1
      FROM  transaction_sys_status_tab
      WHERE id = current_job_id_;

   PROCEDURE Log_Status_Info___ (
      info_            IN VARCHAR2,
      status_type_     IN VARCHAR2,
      write_key_value_ IN BOOLEAN,
      line_            IN NUMBER )
   IS
      PRAGMA            AUTONOMOUS_TRANSACTION;
   BEGIN
      Set_Status_Info___(info_, status_type_, write_key_value_, line_);
	  @ApproveTransactionStatement(2018-04-02,NaBaLk)
      COMMIT;
   END Log_Status_Info___;
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Log_Status_Info');
   IF (Is_Session_Deferred) THEN
      OPEN get_next_line;
      FETCH get_next_line INTO new_line_no_;
      CLOSE get_next_line;
      Log_Status_Info___(info_, status_type_, write_key_value_, new_line_no_);
   END IF;
END Log_Status_Info;


-- Set_Progress_Info
--   Set progress information for current session.
PROCEDURE Set_Progress_Info (
   info_ IN VARCHAR2,
   to_step_ IN BINARY_INTEGER DEFAULT 0 )
IS
   remcall_        transaction_sys_local_tab%ROWTYPE;
   msg_            VARCHAR2(32000);
   slno_           BINARY_INTEGER;
   procedure_      VARCHAR2(65);
   status_lines_   VARCHAR2(32000);
   no_of_lines_    NUMBER;
   current_job_id_ NUMBER := Get_Current_Job_Id;
   long_op_id_     BINARY_INTEGER;
   so_far_         transaction_sys_local_tab.so_far%TYPE;
   total_work_     transaction_sys_local_tab.total_work%TYPE;
   description_    transaction_sys_local_tab.description%TYPE;
   step_           NUMBER;
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Set_Progress_Info');
   IF (Is_Session_Deferred) THEN
      UPDATE transaction_sys_local_tab
      SET progress_info = substr(info_, 0, 200)
      WHERE id = current_job_id_
      RETURNING procedure_name, long_op_id, slno, so_far, total_work, description INTO procedure_, long_op_id_, slno_, so_far_, total_work_, description_;
      IF total_work_ IS NOT NULL THEN
         -- Set information into v$session_longops
         IF (to_step_ > 0) THEN
            so_far_ := to_step_;
            step_ := 0;
         ELSE
            step_ := 1;
         END IF;
         Log_Progress_Longop(long_op_id_, so_far_, slno_, current_job_id_, procedure_, total_work_, description_, step_);
      END IF;
      -- Execute event
      IF (Event_SYS.Event_Enabled( service_, 'BACKGROUND_JOB_IN_PROGRESS' )) THEN
         SELECT *
            INTO remcall_
            FROM transaction_sys_local_tab
            WHERE id = current_job_id_;
         msg_ := Message_SYS.Construct('BACKGROUND_JOB_IN_PROGRESS');
         --
         -- Standard event parameters
         --
         Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', sysdate );
         Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', remcall_.username );
         Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(remcall_.username) );
         Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(remcall_.username, 'SMTP_MAIL_ADDRESS') );
         Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(remcall_.username, 'MOBILE_PHONE') );
         --
         -- Primary key for object
         --
         Message_SYS.Add_Attribute( msg_, 'JOB_ID', remcall_.id );
         --
         -- Other important information
         --
         Message_SYS.Add_Attribute( msg_, 'DESCRIPTION', remcall_.description );
         Message_SYS.Add_Attribute( msg_, 'QUEUE', Batch_Queue_API.Get_Description(remcall_.queue_id) );
         Message_SYS.Add_Attribute( msg_, 'PROCEDURE_NAME', remcall_.procedure_name );
         Message_SYS.Add_Attribute( msg_, 'ARGUMENTS', remcall_.arguments_string );
         Message_SYS.Add_Attribute( msg_, 'POSTED_DATETIME', remcall_.posted );
         Message_SYS.Add_Attribute( msg_, 'PROGRESS_DATETIME', sysdate );
         Message_SYS.Add_Attribute( msg_, 'PROGRESS_INFO', remcall_.progress_info );
         Message_SYS.Add_Attribute( msg_, 'PROCESS_ID', remcall_.process_id );
         status_lines_ := Get_Status_Lines___(remcall_.id);
         no_of_lines_  := length(status_lines_) - length(replace(status_lines_,CHR(10)));
         IF (length(msg_) + length(status_lines_) + no_of_lines_) > 31985 THEN
            -- Deducted 62 characters for appended string below
            status_lines_ := substr(status_lines_, 1, 31923 - length(msg_) - no_of_lines_) || '... Buffer overflow, some status information was not included!';
         END IF;
         Message_SYS.Add_Attribute( msg_, 'STATUS_LINES', status_lines_ );
         Event_SYS.Event_Execute( service_, 'BACKGROUND_JOB_IN_PROGRESS', msg_ );
      END IF;
   END IF;
END Set_Progress_Info;


-- Set_Status_Info
--   Set status information for current session.
--   Possible types are 'WARNING' and 'INFO'.
PROCEDURE Set_Status_Info (
   info_        IN VARCHAR2,
   status_type_ IN VARCHAR2 DEFAULT 'WARNING',
   write_key_value_   IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Set_Status_Info');
   Set_Status_Info___(info_, status_type_, write_key_value_);
END Set_Status_Info;


PROCEDURE Update_Total_Work (
   id_         IN NUMBER,
   total_work_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Update_Total_Work');
   UPDATE transaction_sys_local_tab
      SET total_work = total_work_,
          so_far = 0
      WHERE id = id_;
END Update_Total_Work;


-- Get_Posted_Job_Arguments
--   This procedure returns the arguments of all posted jobs in a message.
--   Jobs will be filtered procedure name and user name.
--   This function returns the arguments of all posted jobs in a PL/SQL Table.
--   Jobs will be filtered procedure name and user name.
PROCEDURE Get_Posted_Job_Arguments (
   arguments_msg_  OUT VARCHAR2,
   procedure_name_ IN  VARCHAR2,
   user_name_      IN  VARCHAR2 DEFAULT NULL)
IS
   msg_     VARCHAR2(32000);
   results_ Arguments_Table;
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Get_Posted_Job_Arguments');
   results_ := Get_Posted_Job_Arguments(procedure_name_, user_name_);
   IF (results_ IS NOT NULL) AND (results_.COUNT > 0) THEN
      msg_ := Message_SYS.Construct('JOB_ARGUMENTS');
      FOR ix_ IN results_.FIRST..results_.LAST LOOP
         Message_SYS.Add_Attribute(msg_, to_char(results_(ix_).job_id), results_(ix_).arguments_string);
      END LOOP;
      arguments_msg_ := msg_;
   ELSE
      arguments_msg_ := NULL;
   END IF;
END Get_Posted_Job_Arguments;


-- Get_Posted_Job_Arguments
--   This procedure returns the arguments of all posted jobs in a message.
--   Jobs will be filtered procedure name and user name.
--   This function returns the arguments of all posted jobs in a PL/SQL Table.
--   Jobs will be filtered procedure name and user name.
FUNCTION Get_Posted_Job_Arguments (
   procedure_name_ IN VARCHAR2,
   user_name_      IN VARCHAR2 ) RETURN Arguments_Table
IS
   CURSOR get_jobs IS
      SELECT id job_id, arguments_string
        FROM transaction_sys_local_tab
       WHERE UPPER(procedure_name) = UPPER(procedure_name_)
         AND state = 'Posted';

   CURSOR get_user_jobs IS
      SELECT id job_id, arguments_string
        FROM transaction_sys_local_tab
       WHERE UPPER(procedure_name) = UPPER(procedure_name_)
         AND state    = 'Posted'
         AND username = user_name_;

   results_ Arguments_Table;
BEGIN
   General_SYS.Check_Security(service_, 'TRANSACTION_SYS', 'Get_Posted_Job_Arguments');
   IF user_name_ IS NOT NULL THEN
      OPEN  get_user_jobs;
      FETCH get_user_jobs BULK COLLECT INTO results_;
      CLOSE get_user_jobs;
   ELSE
      OPEN  get_jobs;
      FETCH get_jobs BULK COLLECT INTO results_;
      CLOSE get_jobs;
   END IF;
   RETURN results_;
END Get_Posted_Job_Arguments;


-- Is_Scheduled_Task
--   Returns TRUE if an associated scheduled task was
--   found for the current session.
@UncheckedAccess
FUNCTION Is_Scheduled_Task RETURN BOOLEAN
IS
   current_job_id_ NUMBER := Get_Current_Job_Id;

   CURSOR get_schedule IS
      SELECT schedule_id
      FROM transaction_sys_local_tab t
      WHERE t.id = current_job_id_;
   temp_ VARCHAR2(100);
BEGIN
   OPEN get_schedule;
   FETCH get_schedule
      INTO temp_;
   CLOSE get_schedule;

   IF temp_ IS NOT NULL THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Scheduled_Task;


-- Logical_Unit_Is_Installed
--   Check whether a specific logical unit is installed or not. Checks against
--   Oracle dictionary using name convention between Logical Units and their packages.
--   LU: ObjectName, Package: Object_Name_API
@UncheckedAccess
FUNCTION Logical_Unit_Is_Installed (
   lu_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Dictionary_SYS.Logical_Unit_Is_Installed(lu_name_);
END Logical_Unit_Is_Installed;

-- Logical_Unit_Is_Active
--   Check whether a specific logical unit is active or not. Checks against
--   Oracle dictionary using name convention between Logical Units and their packages.
--   LU: ObjectName, Package: Object_Name_API
@UncheckedAccess
FUNCTION Logical_Unit_Is_Active (
   lu_name_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN Dictionary_SYS.Logical_Unit_Is_Active(lu_name_);
END Logical_Unit_Is_Active;



-- Logical_Unit_Is_Installed_Num
--   Same as above, but returns numeric values (1 for TRUE and 0 for FALSE).
@UncheckedAccess
FUNCTION Logical_Unit_Is_Installed_Num (
   lu_name_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Dictionary_SYS.Logical_Unit_Is_Installed_Num(lu_name_);
END Logical_Unit_Is_Installed_Num;

-- Logical_Unit_Is_Active_Num
--   Same as above, but returns numeric values (1 for TRUE and 0 for FALSE).
@UncheckedAccess
FUNCTION Logical_Unit_Is_Active_Num (
   lu_name_ IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Dictionary_SYS.Logical_Unit_Is_Active_Num(lu_name_);
END Logical_Unit_Is_Active_Num;



-- Method_Is_Installed
--   Check whether a specific method is installed or not. Checks against
--   Oracle dictionary, always up-to-date, but with poor performance.
--   Compare with similar method in Dictionary_SYS.
@UncheckedAccess
FUNCTION Method_Is_Installed (
   package_name_   IN VARCHAR2,
   method_name_    IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN Database_SYS.Method_Exist(package_name_, method_name_);
END Method_Is_Installed;

-- Method_Is_Active
--   Check whether a specific method is active or not. Checks against
--   Oracle dictionary, always up-to-date, but with poor performance.
--   Compare with similar method in Dictionary_SYS.
@UncheckedAccess
FUNCTION Method_Is_Active (
   package_name_   IN VARCHAR2,
   method_name_    IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN Database_SYS.Method_Active(package_name_, method_name_);
END Method_Is_Active;


-- Method_Is_Installed_Num
--   Same as above, but returns numeric values (1 for TRUE and 0 for FALSE).
@UncheckedAccess
FUNCTION Method_Is_Installed_Num (
   package_name_   IN VARCHAR2,
   method_name_    IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   IF Database_SYS.Method_Exist(package_name_, method_name_) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Method_Is_Installed_Num;

-- Method_Is_Active_Num
--   Same as above, but returns numeric values (1 for TRUE and 0 for FALSE).
FUNCTION Method_Is_Active_Num (
   package_name_   IN VARCHAR2,
   method_name_    IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   IF Database_SYS.Method_Active(package_name_, method_name_) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Method_Is_Active_Num;



-- Package_Is_Installed
--   Check whether a specific package is installed or not. Checks against
--   Oracle dictionary, always up-to-date, but with poor performance.
--   Compare with similar method in Dictionary_SYS.
@UncheckedAccess
FUNCTION Package_Is_Installed (
   pkg_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
    RETURN Database_SYS.Package_Exist(pkg_);
END Package_Is_Installed;

-- Package_Is_Active
--   Check whether a specific package is active or not. Checks against
--   Oracle dictionary, always up-to-date, but with poor performance.
--   Compare with similar method in Dictionary_SYS.
@UncheckedAccess
FUNCTION Package_Is_Active(
   pkg_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
    RETURN Database_SYS.Package_Active(pkg_);
END Package_Is_Active;


-- Package_Is_Installed_Num
--   Same as above, but returns numeric values (1 for TRUE and 0 for FALSE).
@UncheckedAccess
FUNCTION Package_Is_Installed_Num (
   pkg_ IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   IF Database_SYS.Package_Exist(pkg_) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Package_Is_Installed_Num;

-- Package_Is_Active_Num
--   Same as above, but returns numeric values (1 for TRUE and 0 for FALSE).
FUNCTION Package_Is_Active_Num (
   pkg_ IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   IF Database_SYS.Package_Active(pkg_) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Package_Is_Active_Num;
