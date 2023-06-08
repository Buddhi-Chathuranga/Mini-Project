-----------------------------------------------------------------------------
--
--  Logical unit: Batch
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960304  MANY  Created.
--  960306  MANY  Completed first version, available methods are:
--                Exist_Job(), used to check if a job exist's. Do not confuse
--                   with base functionality Exist().
--                New_Job(), create a new job.
--                Modify_Job(), modify an existing job.
--                Remove_Job(), remove a job.
--                Process_Job(), run this job now using the available process. Does
--                   not release until finished.
--                Modify_Status(), set status to 'ACTIVE' or 'BROKEN'. Activating
--                   a broken job, will try to restore the execution plan.
--                Get_Status(), retrieve status from user_jobs.
--                Get_Action(), retrieve action from user_jobs.
--                Get_Execution_Plan(), retrieve the execution plan.
--                Get_Next_Time(), retrieve next execution time from user_jobs.
--                Nls_Translate_Day(), translate a day in the week from American
--                   to the language specified by 'nls_date_language'.
--  960327  ERFO  Set status system service by adding some package globals.
--  960409  MANY  Added error handling to Process_Job(), should now raise the
--                underlying exception
--                Added method Is_Subscription()
--                Added new status'es, 'Working' and 'Pending', to Get_Status()
--  960426  MANY  Fixed bug in New_Job() and Modify_Job() concerning package-
--                owner.
--  960427  MANY  Fixed Error_SYS calls (service_).
--  960507  MANY  Modified Get_Status() to return a one character description
--                of it's status, instead of a description (suitable for IID's)
--  960527  MANY  Modified Get_Execution_Plan() to extract the execution_plan
--                for every possible user.
--  960818  MANY  Fixed bug (bug#741) in Modify_Job, setting off status 'broken' when
--                modifying broken jobs.
--                Added new option for Modify_Job(), exec_plan_ may now accept
--                'NOW AND ...' which does not modify the existing plan, but
--                sets the job to run ASAP and according to existing plan.
--  961111  MANY  Added version 7.2 compliance, breaking jobs.
--  961116  MANY  Modification to correct bug in dbms_job/user_jobs, concerning
--                privilegies.
--  961120  MANY  Fixed bug in Modify_Status(), reactivating broken jobs.
--  961121  ERFO  Solved problem in Modify_Status when reactivating non
--                Batch_SYS jobs like Transaction_SYS.Process_All_Pending.
--  961212  MANY  Added method Drop_Foundation__ (Bug #898).
--  970121  MANY  Fixed bug #939, WEEKLY option
--  970725  ERFO  Replaced usage of obsolete method Utility_SYS.Get_User
--                with the new Fnd_Session_API.Get_Fnd_User (ToDo #1172).
--  970817  MANY  Added new method New_Job_Schedule(), to support parameterized
--                cleanup of Foundation. Method is public for others to be able
--                to customize scheduler.
--                Added methods Fnd_Heavy_Cleanup_Schedule_() and
--                Fnd_Light_Cleanup_Schedule_ for parameterized scheduling.
--  970911  MANY  Fixed problem in Get_Status() and Modify_Status() concerning
--                states of existing jobs. (Bug #1644)
--  971027  ERFO  Changed names of Fnd_Setting parameters.
--  971028  MANY  Fixed problem with executing batch jobs as FndUser.
--  971212  ERFO  Added support for language properties on each job (ToDo #1850).
--  980306  ERFO  Changes concerning new language configuration (ToDo #2212).
--  980915  ERFO  Solve performance problem when changing language (Bug #2685).
--  990107  ERFO  Corrected public function Nls_Translate_Day to work even
--                for other NLS territories than AMERICA (Bug #3019).
--  991124  TOWR  Changes in New_Properties_, Run_Job__ (2 methods) and Exist_Job
--                to support clients without physical session as the webkit (Bug #3720).
--  000821  ROOD  Added method Format_Times_ to avoid errors in execution plan (Bug #16841).
--  000607  HAAR  Added functionality for 'ON date AT time' in Update_Exec_Time__.
--  010904  ROOD  Corrected comments about syntax for execution plan.
--  010906  HAAR  Removed description_ and parameters_ as paramters from Modify_Batch_Schedule.
--                Renamed column Description to Schedule_Name in Batch_Schedule.
--                Added function Exist_Batch_Schedule.
--  010928  ROOD  Added evaluation of functions in Update_Exec_Time__ and Parse_Execution_Plan_.
--                Added parsing of execution plan for Batch Schedules.
--                Removed Run_Job with 2 params (support for version 7.1 and below).
--                Reorganised. (ToDo#4018).
--  020628  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  020808  HAAR  Added method Get_Next_Exec_Date__ (Bug #30396)
--                This method is intended to be used by Batch schedules.
--                This method is similar to Update_Exec_Time, but takes previous exection time
--                as parameter. Affects only execution plans with type EVERY, which will use
--                previous execution time instead of sysdate to calculate next execution time.
--                Next execution time is always > sysdate.
--  020809  HAAR  Modify_Batch_Schedule doesn't work (Bug#25924).
--  021001  ROOD  Correction in method Get_Next_Exec_Time__ for execution plans of type MONTHLY.
--                Day 29 and above will be last day of the month if the month has less days.
--                Corrected range check in Parse_Execution_Plan___ (Bug#33196).
--  021018  HAAR  Added Register_Batch_Schedule_Method (ToDo#4146).
--                Changed New_Batch_Schedule, Modify_Batch_Schedule and Process_Batch_Schedule.
--  030113  HAAR  Removed Light_Cleanup_Schedule_ and Heavy_Cleanup_Schedule_ (ToDo#4146).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030218  ROOD  Removed hardcoded subcomponent names in messages (ToDo#4149).
--  030225  HAAR  Run_Job__ supresses normal Oracle error handling for background jobs (Bug#35537).
--  030314  ROOD  Moved Fnd_Light_Cleanup and Fnd_Heavy_Cleanup here from General_SYS.
--                Modified implementation some since subcomponents are removed (ToDo#4143).
--  030527  ROOD  Remove jobs that are single executions in Run_Job__. Also modified
--                exception handling in New_Properties___ to avoid inconsistent information
--                for batch jobs (Bug#37043).
--  030814  ROOD  Made New_Batch_Schedule and Modify_Batch_Schedule handle execution plans
--                for single executions (Bug#38691).
--  030815  HAAR  Added New_Batch_Queue, to be able to create a Batch Queue (ToDo#4279).
--  030902  ROOD  Added check for appowner when using dbms_job (ToDo#4196).
--  031023  ROOD  Changes in Get_Next_Exec_Time__, New_Batch_Schedule and Modify_Batch_Schedule
--                to handle one time executions (Bug#38691).
--  040115  HAAR  New_Batch_Schedule_ - start_date is set to null should be sysdate (Bug#42092).
--  040119  BAMALK Added new parameter to New_Properties___.Modified Modify_Status and Get_Execution_Plan
--                 to handle execution plans of ON <date> AT <time> - [Bug#40621]
--  040205  HAAR  Created New_Batch_Queue_Method and Get_Batch_Queue_For_Method_ (Bug#39376).
--  040426  HAAR  Added support for AO and Appowner in Get_Next_Exec_Time__.
--  040427  HAAR  Added Check_Batch_Sched_Cust_Expr__ for validation of custom expression execution plan.
--  040507  HAAR  Added New_Batch_Schedule_Param, Modify_Batch_Schedule_Param,
--                Remove_Batch_Schedule_Param and Register_Schedule_Method_Param.
--                Removed old public interfaces New_Batch_Schedule and Modify_Batch_Schedule.
--                Removed parameter parameters_ from New_Batch_Schedule and Modify_Batch_Schedule (F1PR419).
--  040523  HAAR  Added overloaded methods for date and number values for
--                Modify_Batch_Schedule_Param, New_Batch_Schedule_Param and Register_Schedule_Method_Param (F1PR419).
--  040930  HAAR  Check access rights and set Fnd_User in Process_Batch_Schedule (Bug#47195).
--  041001  ROOD  Modified call to Batch_Schedule_Par_API in Modify_Batch_Schedule_Param and
--                New_Batch_Schedule_Param to avoid problems with attribute strings in attribute strings.
--                Added default parameter external_id in New_Batch_Schedule (F1PR419).
--                Update template version.
--  041014  HAAR  Make it possible for endusers to execute Run_Job__ in the background
--                without being granted (Bug#47413).
--  041126  HAAR  Added Security Checkpoint cleanup in Fnd_Heavy_Cleanup_(F1PR414).
--  041202  HAAR  Added default parameter Default_Expression in Register_Schedule_Method_Par (F1PR419).
--  050615  HAAR  Changed Init_All_Processes_ to use System privileges (F1PR483).
--  051104  RAKU  Added NULL checks in Modify_Batch_Schedule (F1PR419).
--  060726  NiWi  Modified Register_Schedule_Method_Param. Allowed 'sysdate expressions'
--  060829  DuWiLK  Remove the variable user_ from Get_Execution_Plan since it is not used (Bug#58176)
--  061027  NiWiLK  'PROG' is not a registered language code, hence should not be the default(Bug#61340).
--  061228  HAAR  Change so that background jobs can be run when submitted from IFS Extended Server (Bug#62360).
--                Added better logging for Batch Jobs.
--                Added properties to New_Job_Schedule.
--                Init_All_Processes_ uses Batch_SYS.New_Job_App_Owner__.
--  070122  UTGULK Modified Get_Batch_Queue_For_Method_ to return null if no queue is found.(Bug#61862).
--  070509  HAAR  Added cleanup of state Error and Warnings for Background Jobs (Bug#65267).
--  071019  HAAR  Added cleanup of jobs stuck in state Executing in Fnd_Light_Cleanup (Bug#68756).
--  080630  HAAR  Added support for Scheduled Task Sequences (Bug#72846).
--  081216  HAAR  Changed to use Autonomous transaction for logging in background jobs (IID#80009).
--  090121  HAAR  Try to avoid Impersonate User in method called from interactive client (Bug#79937).
--  090226  DUWI  Checked DEFINE SQL privilege in Check_Batch_Sched_Cust_Expr__ (Bug#80700).
--  090317  HAAR  Added Oracle scheduling syntax (IID#80009).
--  090617  HAAR  Changed all public methods regarding Batch_Job to be protected.
--                These methods should only be used by component FNDBAS (IID#80009).
--  090813  NABA  Certified the assert safe for dynamic SQLs (Bug#84218) 
--  091130  DUWI  Added procedure Remove_Batch_Schedule_Method (Bug#85225).
--  100319  UsRa  Added support to cleanup Pres Object Sec Export Orphaned Objects in Fnd_Heavy_Cleanup_ (Bug#84237).
--  100416  HAAR  Added Last_Execution_Date to Scheduled Tasks (Bug#90019).
--  100415  PKULLK Enhanced sizes of days_ and times_ of Get_Next_Exec_Time__ to allow longer execution plans being processed (Bug#90059).
--  100127  HAAR  Changes needed for using Dbms_Scheduler instead of Dbms_Job (EACS-750).
--  110903  NaBa  Enhanced the logic of finding next execution time (RDTERUNTIME-711)
--  120126  MaBo  New method for deleting records in BatchSchedule, changes in Remove_Batch_Schedule (RDTERUNTIME-1967)
--  120814  WaWi  Changed New_Job___ to support previously supported execution plans (Bug# 104507)
--  130123  ChMu  Disable scheduled task/chain for which the user no longer have access to (Bug#102795).
--  130201  DUWI  Added procedure Validate_Execution_Plan__ (Bug#108116).
--  130212  WAWI  Changed Modify_Status_ to support Oracle scheduler jobs. (Bug#108213)
--  130313  DUWI  Changed Get_Next_Exec_Time__ to validate custom execution plan correctly (Bug108846).
--  130710  PGAN  Changed Get_Next_Exec_Time___ to consider Start Date for calculating next execution time (Bug105136).
--  130726  WAWI  Refactoring some parts of Get_Next_Exec_Time___ (Bug#105136)
--  130821  PGAN  Changed Rem_Cascade_Batch_Schedule to remove obsolete methods from batch_queue_method_tab (Bug111810).
--  130911  WAWI  Supplementary corrections for bug#105136 (Bug#112374)
--  150904  WAWI  Deactivate a schedule in Process_Batch_Schedule_ if exception is thrown in trying to queue it (Bug#111990)
--  161025  ASIWLK Automatically remove RRE logs TEREPORT-2235
--  146761  MABALK Added support to cleanup statistics on quick report usage
----------------------------------------------------------------------------
--
--  Dependencies: Error_SYS
--                Oracle package DBMS_SCHEDULER.
--
--  Contents:     Public methods for report processing support
--
--  Execution plan:
--                The term execution plan is used to describe when a job will
--                be executed. The execution plan is not case sensitive and time
--                is specified on minute level. Date and time formats are fixed,
--                as is date language (American).
--                It is used straightforwardly like this:
-----------------------------------------------------------------------------
--                'NOW' or 'ASAP'
--                   ; Execute one time, now.
--                'NOW AND ..' or 'ASAP AND ..'
--                   ; Used in conjunction with subscriptions, does not work
--                     with the onetimers (ON et c).
--                   'NOW AND DAILY AT 14:00'
--                      ; Execute now and every day at 14:00.
--                'TOMORROW AT <time>'
--                   ; Execute one time, tomorrow at <time>.
--                'ON <date> AT <time>'
--                   ; Execute one time, possibly on <date> at <time>, or if this
--                     time has expired, execute right now.
--                   'ON 1996-03-10 AT 11:30'
--                      ; Execute on mars 10 1996 at 11:30.
--                'ON <day> AT <time>'
--                   ; Execute one time, possibly on next <day> at <time>, or
--                     if this time has expired, execute right now.
--                   'ON tue AT 11:30'
--                      ; Execute on tuesday at 11:30 or, if today is tuesday,
--                        execute next tuesday at 11:30.
--                'AT <time>'
--                   ; Execute one time, today at <time>, or if the actual time
--                     has already passed <time>, tomorrow at <time>.
--                'WEEKLY ON <days> AT <times>'
--                   ; Feel free to mix days and times, at least one day and
--                     one time. Multipel days or times should be ';' separated
--                     There is a shortcut for all working days in
--                     the week called 'WEEKDAYS', and used in the same manner
--                     as the days. There is also a shortcut to every single
--                     day in week (every day, period) called 'DAILY'.
--                   'WEEKLY ON mon;thu AT 11:00;16:00'
--                      ; Execute on monday at 11:00, on monday at 16:00, on
--                        thursday at 11:00 and on thursday at 16:00, then
--                        repeat next week..
--                   'WEEKLY ON weekdays'
--                      ; On monday, tuesday, wednesday, thursday and friday
--                        at this time.
--                   'DAILY AT 09:30;12:00'
--                      ; Every day at 09:30 and 12:00.
--                   'WEEKLY'
--                      ; Now and weekly on this day at this time.
--                'MONTHLY ON DAY <day number> AT <time>'
--                   ; Execute every month on specified day and time. If the
--                     current month does not have as many days as <day number>,
--                     the last day of this month will be used.
--                'EVERY 00:30'
--                   ; Execute every half hour. Time part must be at least one
--                     minute (00:01) and less than 24:00. This is primarily
--                     intented for special purpose, server-related task's.
--                If the keyword 'AT' is omitted the time defaults to the
--                actual time of day..
--                   'TOMORROW'
--                      ; Tomorrow at the same time.
--                   'DAILY'
--                      ; Daily at this time.
-----------------------------------------------------------------------------
-- Action:
--                The term <action_> stands for any procedure in the form
--                <package.method> containing only IN-parameters (if any). The
--                special parameter job_id_ is recognized as the job identity
--                of this job (as returned by New_Job). All parameters should
--                be constants.
-----------------------------------------------------------------------------
-- Error handling:
--                If an <action_> is performed successfully (returns in a
--                normal way) the results will be committed. If it returns
--                through an exception it will be rollback'ed and the job will
--                be marked broken.
-----------------------------------------------------------------------------
-- Status:        A job may have two states, 'Active' and 'Broken'. These states
--                may be altere by method Modify_Status(). Jobs that do not
--                complete succsessfully ends up 'Broken'
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Batch_Queue_Rec IS RECORD
   ( queue_id         batch_queue_tab.queue_id%TYPE,
     description      batch_queue_tab.description%TYPE,
     process_number   batch_queue_tab.process_number%TYPE,
     active           batch_queue_tab.active%TYPE,
     execution_plan   batch_queue_tab.execution_plan%TYPE,
     lang_code        batch_queue_tab.lang_code%TYPE,
     node_attached_db batch_queue_tab.node_attached%TYPE,
     node             batch_queue_tab.node%TYPE );

-------------------- PRIVATE DECLARATIONS -----------------------------------

valid_days_       CONSTANT VARCHAR2(29) := '^MON^TUE^WED^THU^FRI^SAT^SUN^';
week_days_        CONSTANT VARCHAR2(19) := 'Mon;Tue;Wed;Thu;Fri';
all_days_         CONSTANT VARCHAR2(27) := 'Mon;Tue;Wed;Thu;Fri;Sat;Sun';
time_format_      CONSTANT VARCHAR2(7)  := 'HH24:MI';
date_format_      CONSTANT VARCHAR2(10) := 'YYYY-MM-DD';
date_time_format_ CONSTANT VARCHAR2(18) := 'YYYY-MM-DD HH24:MI';
job_prefix_       CONSTANT VARCHAR2(6)  := 'F1JOB_';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Validate_Date___ (
   date_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ DATE;
BEGIN
   dummy_ := to_date(date_, date_format_); --is it correct date format..
   RETURN (TRUE); -- obviously..
EXCEPTION
   WHEN OTHERS THEN
      RETURN (FALSE); -- apparently not..
END Validate_Date___;


FUNCTION Validate_Day___ (
   day_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN (instr(valid_days_, '^'||upper(day_)||'^') > 0);
END Validate_Day___;


FUNCTION Validate_Time___ (
   time_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ DATE;
BEGIN
   dummy_ := to_date(time_, time_format_); --is it correct time format..
   RETURN (TRUE); -- obviously..
EXCEPTION
   WHEN OTHERS THEN
      RETURN (FALSE); -- apparently not..
END Validate_Time___;


FUNCTION Validate_Number___ (
   number_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   dummy_ := to_number(number_); --is it correct number format..
   RETURN (TRUE); -- obviously..
EXCEPTION
   WHEN OTHERS THEN
      RETURN (FALSE); -- apparently not..
END Validate_Number___;


FUNCTION Validate_Days___ (
   days_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   from_ NUMBER;
   to_   NUMBER;
   temp_ VARCHAR2(200);
   day_  VARCHAR2(20);
   inside_ BOOLEAN := FALSE;
BEGIN
   temp_ := days_ || ';';
   from_ := 1;
   to_ := instr(temp_, ';', from_);
   WHILE (to_ > 0) LOOP
      day_ := ltrim(rtrim(substr(temp_, from_, to_ - from_)));
      IF (instr(temp_, day_, to_ + 1) > 0 OR NOT Validate_Day___(day_)) THEN
         RETURN (FALSE);
      END IF;
      inside_ := TRUE;
      from_ := to_ + 1;
      to_ := instr(temp_, ';', from_);
   END LOOP;
   RETURN (inside_);
END Validate_Days___;


FUNCTION Validate_Times___ (
   times_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   from_   NUMBER;
   to_     NUMBER;
   temp_   VARCHAR2(200);
   time_   VARCHAR2(20);
   inside_ BOOLEAN := FALSE;
BEGIN
   temp_ := times_ || ';';
   from_ := 1;
   to_ := instr(temp_, ';', from_);
   WHILE (to_ > 0) LOOP
      time_ := ltrim(rtrim(substr(temp_, from_, to_ - from_)));
      IF (instr(temp_, time_, to_ + 1) > 0 OR NOT Validate_Time___(time_)) THEN
         RETURN (FALSE);
      END IF;
      inside_ := TRUE;
      from_ := to_ + 1;
      to_ := instr(temp_, ';', from_);
   END LOOP;
   RETURN (inside_);
END Validate_Times___;


FUNCTION Format_Times___ (
   times_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_   VARCHAR2(200);
   from_   NUMBER;
   to_     NUMBER;
   time_   VARCHAR2(20);
   colon_pos_ NUMBER;
   temp_times_ VARCHAR2(200);
BEGIN
   temp_ := times_ || ';';
   from_ := 1;
   to_ := instr(temp_, ';', from_);
   WHILE (to_ > 0) LOOP
      time_ := ltrim(rtrim(substr(temp_, from_, to_ - from_)));
      colon_pos_ := instr(time_, ':', 1);
      IF (colon_pos_ = 2) THEN
         -- append a leading zero
         time_ := '0' || time_;
      END IF;
      from_ := to_ + 1;
      to_ := instr(temp_, ';', from_);
      IF (to_ > 0) THEN
         temp_times_ := temp_times_ || time_ || ';';
      ELSE
         temp_times_ := temp_times_ || time_;
      END IF;
   END LOOP;
   RETURN temp_times_;
END Format_Times___;


FUNCTION Extract___ (
   string_    IN OUT VARCHAR2,
   key_word_  IN     VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF (substr(string_, 1, length(key_word_)) = key_word_) THEN
      string_ := ltrim(rtrim(substr(string_, length(key_word_))));
      RETURN (TRUE);
   ELSE
      RETURN (FALSE);
   END IF;
END Extract___;


FUNCTION Split___ (
   before_   OUT VARCHAR2,
   after_    OUT VARCHAR2,
   string_   IN  VARCHAR2,
   key_word_ IN  VARCHAR2 ) RETURN BOOLEAN
IS
   pos_ NUMBER;
BEGIN
   pos_ := instr(string_, key_word_);
   IF (pos_ >0) THEN
      before_ := ltrim(rtrim(substr(string_, 1, pos_ - 1)));
      after_ := ltrim(rtrim(substr(string_, pos_ + length(key_word_))));
      RETURN (TRUE);
   ELSE
      RETURN (FALSE);
   END IF;
END Split___;


PROCEDURE Split___ (
   before_   OUT VARCHAR2,
   after_    OUT VARCHAR2,
   string_   IN  VARCHAR2,
   key_word_ IN  VARCHAR2 )
IS
   pos_ NUMBER;
BEGIN
   pos_ := instr(string_, key_word_);
   before_ := ltrim(rtrim(substr(string_, 1, pos_ - 1)));
   after_ := ltrim(rtrim(substr(string_, pos_ + length(key_word_))));
END Split___;


PROCEDURE Parse_Execution_Plan___ (
   first_time_tz_  OUT TIMESTAMP WITH TIME ZONE,
   next_time_      OUT VARCHAR2,
   execution_plan_ IN  VARCHAR2 )
IS
   exec_plan_      VARCHAR2(4000) := rtrim(ltrim(upper(execution_plan_)));
   used_plan_      VARCHAR2(4000);
   the_first_time_ DATE;
   date_           VARCHAR2(20);
   time_           VARCHAR2(20);
   days_           VARCHAR2(100);
   times_          VARCHAR2(100);
   now_            BOOLEAN := FALSE;
   number_         NUMBER;
   first_time_     DATE;
BEGIN
   -- Added Oracle syntax
   IF (upper(exec_plan_) LIKE 'FREQ=%') THEN
      Dbms_Scheduler.Evaluate_Calendar_String(exec_plan_, sysdate, sysdate, first_time_);
      next_time_ := exec_plan_;
      RETURN;
   END IF;
   --
   exec_plan_ := rtrim(ltrim(upper(execution_plan_)));
   exec_plan_ := replace(exec_plan_, 'ASAP', 'NOW');
   -- parse NOW, ASAP ..
   IF (exec_plan_ = 'NOW') THEN
      first_time_ := sysdate;
      next_time_ := 'NULL';
      RETURN;
   END IF;
   IF (exec_plan_ = 'TOMORROW') THEN
      first_time_ := to_date(to_char(sysdate + 1, date_format_)||' '||to_char(sysdate,time_format_), date_time_format_) ;
      next_time_ := 'NULL';
      RETURN;
   END IF;
   -- parse NOW AND .., ASAP AND ..
   IF (Extract___(exec_plan_, 'NOW AND ')) THEN
      now_ := TRUE; -- set now  flag..
   END IF;
   -- parse 'WEEKLY'
   IF (exec_plan_ = 'WEEKLY') THEN
      first_time_ := sysdate;
      next_time_ := 'WEEKLY ON '||to_char(sysdate, 'DY', 'nls_date_language=American')||' AT '||to_char(sysdate, time_format_);
      RETURN;
   END IF;
   -- parse ON ..
   IF (Extract___(exec_plan_, 'ON ')) THEN
      IF (now_) THEN
         Error_SYS.Appl_General(service_, 'NOWERR: Illegal use of NOW [:P1]', execution_plan_);
      END IF;
      IF (Split___(date_, time_, exec_plan_, ' AT ')) THEN
         IF (Validate_Date___(date_)) THEN
            IF (Validate_Time___(time_)) THEN
               first_time_ := to_date(date_||' '||time_, date_time_format_);
               next_time_ := 'NULL';
               RETURN;
            ELSE
               Error_SYS.Appl_General(service_, 'TIMEERR: Illegal time format [:P1]', time_);
            END IF;
         ELSIF (Validate_Day___(date_)) THEN -- is date_ actually a day
            IF (Validate_Time___(time_)) THEN
               first_time_ := to_date(to_char(next_day(sysdate,Nls_Translate_Day_(date_)), date_format_)||' '||time_, date_time_format_);
               next_time_ := 'NULL';
               RETURN;
            ELSE
               Error_SYS.Appl_General(service_, 'TIMEERR: Illegal time format [:P1]', time_);
            END IF;
         ELSE
            Error_SYS.Appl_General(service_, 'DATEERR: Illegal date format [:P1]', date_);
         END IF;
      ELSIF (Validate_Date___(exec_plan_)) THEN
         first_time_ := to_date(exec_plan_, date_format_);
         next_time_ := 'NULL';
         RETURN;
      ELSIF (Validate_Day___(exec_plan_)) THEN -- is date_ actually a day
         first_time_ := to_date(to_char(next_day(sysdate,Nls_Translate_Day_(exec_plan_)), date_format_), date_format_);
         next_time_ := 'NULL';
         RETURN;
      ELSE
         Error_SYS.Appl_General(service_, 'DATEDAYERR: Illegal date or day format [:P1]', exec_plan_);
      END IF;
   END IF;
   -- parse AT ..
   IF (Extract___(exec_plan_, 'AT ')) THEN
      IF (now_) THEN
         Error_SYS.Appl_General(service_, 'NOWERR: Illegal use of NOW [:P1]', execution_plan_);
      END IF;
      IF (Validate_Time___(exec_plan_)) THEN
         the_first_time_ := to_date(to_char(sysdate, date_format_)||' '||exec_plan_, date_time_format_);
         IF (the_first_time_ < sysdate) THEN
            first_time_ := the_first_time_ + 1;
         ELSE
            first_time_ := the_first_time_;
         END IF;
         next_time_ := 'NULL';
         RETURN;
      ELSE
         Error_SYS.Appl_General(service_, 'TIMEERR: Illegal time format [:P1]', exec_plan_);
      END IF;
   END IF;
   -- parse TOMORROW AT ..
   IF (Extract___(exec_plan_, 'TOMORROW AT ')) THEN
      IF (now_) THEN
         Error_SYS.Appl_General(service_, 'NOWERR: Illegal use of NOW [:P1]', execution_plan_);
      END IF;
      IF (Validate_Time___(exec_plan_)) THEN
         first_time_ := to_date(to_char(sysdate + 1, date_format_)||' '||exec_plan_, date_time_format_);
         next_time_ := 'NULL';
         RETURN;
      ELSE
         Error_SYS.Appl_General(service_, 'TIMEERR: Illegal time format [:P1]', exec_plan_);
      END IF;
   END IF;
   -- parse WEEKLY ON ..
   exec_plan_ := replace(exec_plan_, 'DAILY', 'WEEKLY ON '||all_days_);
   IF (Extract___(exec_plan_, 'WEEKLY ON ')) THEN
      exec_plan_ := replace(exec_plan_, 'WEEKDAYS', week_days_);
      IF (Split___(days_, times_, exec_plan_, ' AT ')) THEN
         IF (Validate_Days___(days_)) THEN
            IF (Validate_Times___(times_)) THEN
               used_plan_ := 'WEEKLY ON '||days_||' AT '||Format_Times___(times_);
               IF (now_) THEN
                  first_time_ := sysdate;
               ELSE
                  first_time_ := Update_Exec_Time__(used_plan_);
               END IF;
               next_time_ := used_plan_;
               RETURN;
            ELSE
               Error_SYS.Appl_General(service_, 'TIMEERR: Illegal time format [:P1]', times_);
            END IF;
         ELSE
            Error_SYS.Appl_General(service_, 'DAYERR: Illegal day format [:P1]', days_);
         END IF;
      ELSIF (Validate_Days___(exec_plan_)) THEN
         used_plan_ := 'WEEKLY ON '||days_||' AT '||to_char(sysdate, time_format_);
         IF (now_) THEN
            first_time_ := sysdate;
         ELSE
            first_time_ := Update_Exec_Time__(used_plan_);
         END IF;
         next_time_ := used_plan_;
         RETURN;
      ELSE
         Error_SYS.Appl_General(service_, 'DATEERR: Illegal date format [:P1]', exec_plan_);
      END IF;
   END IF;
   -- parse MONTHLY ON ..
   IF (Extract___(exec_plan_, 'MONTHLY ON ')) THEN
      IF (Extract___(exec_plan_, 'DAY ')) THEN
         IF (Split___(number_, time_, exec_plan_, ' AT ')) THEN
            IF (NOT Validate_Time___(time_)) THEN
               Error_SYS.Appl_General(service_, 'TIMEERR: Illegal time format [:P1]', time_);
            END IF;
         ELSE
            number_ := exec_plan_;
            time_ := to_char(sysdate, time_format_);
         END IF;
         IF (Validate_Number___(number_)) THEN
            IF (number_ >= 1 AND number_ <= 31) THEN
               used_plan_ := 'MONTHLY ON DAY '||number_||' AT '||time_;
               IF (now_) THEN
                  first_time_ := sysdate;
               ELSE
                  first_time_ := Update_Exec_Time__(used_plan_);
               END IF;

               next_time_ := used_plan_;
               RETURN;
            ELSE
               Error_SYS.Appl_General(service_, 'RANGERR: Number out of range [:P1]', number_);
            END IF;
         ELSE
            Error_SYS.Appl_General(service_, 'NUMBERR: Illegal number format [:P1]', number_);
         END IF;
      END IF;
   END IF;
   -- parse EVERY
   IF (Extract___(exec_plan_, 'EVERY ')) THEN
      IF (Validate_Time___(exec_plan_)) THEN
         IF (exec_plan_ > '00:00' AND exec_plan_ < '23:59') THEN
            first_time_ := sysdate; -- always start NOW
            next_time_ := 'EVERY '||exec_plan_;
            RETURN;
         ELSE
            Error_SYS.Appl_General(service_, 'TIMEERR_RANGE: Time range outside of 00:01 and 23:59 [:P1]', exec_plan_);
         END IF;
      ELSE
         Error_SYS.Appl_General(service_, 'TIMEERR: Illegal time format [:P1]', exec_plan_);
      END IF;
   END IF;
   -- finally parse for function call
   first_time_ := Update_Exec_Time__(execution_plan_);
   IF first_time_ IS NOT NULL THEN
      next_time_ := execution_plan_;
      SELECT FROM_TZ(CAST(first_time_ AS TIMESTAMP), TO_CHAR(SYSTIMESTAMP, 'tzr')) INTO first_time_tz_ FROM dual;  
      RETURN;
   END IF;
   -- Raise error if not correct execution plan
   Error_SYS.Appl_General(service_, 'PARSEERR: Illegal execution plan [:P1]', execution_plan_);
END Parse_Execution_Plan___;

FUNCTION Get_Date_From_Str___ (
   date_string_ IN VARCHAR2 ) RETURN DATE
IS
   date_ DATE;
BEGIN
   -- Safe as the value passed to date_string_ is already parsed and asserted inside Parse_Execution_Plan___
   @ApproveDynamicStatement(2012-08-14,wawilk)
   EXECUTE IMMEDIATE 'SELECT '||date_string_||' FROM dual' INTO date_;
   RETURN date_; 
EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
END Get_Date_From_Str___;

PROCEDURE New_Job___ (
   job_id_         OUT NUMBER,
   action_         IN  VARCHAR2,
   execution_plan_ IN  VARCHAR2,
   fnd_user_       IN  VARCHAR2,
   inst_id_        IN  NUMBER )
IS
   subscription_plan_  VARCHAR2(180);
   first_time_tz_      TIMESTAMP WITH TIME ZONE;
   interval_           VARCHAR2(200);
   job_name_           VARCHAR2(30);
   temp_job_id_        NUMBER;
   temp_date_          DATE;
   temp_client_id_     VARCHAR2(64) := Sys_Context('USERENV', 'CLIENT_IDENTIFIER');
--
   FUNCTION get_method___(
      action_ IN VARCHAR2) RETURN VARCHAR2
   IS
      pos_  NUMBER;
   BEGIN
      pos_ := Instr(action_, '(');
      IF pos_ = 0 THEN
         pos_ := length(action_);
      ELSE
         pos_ := pos_ - 1;
      END IF;
      RETURN(Substr(action_, 1, pos_));
   END get_method___;
--
BEGIN
   -- Check security
   IF NOT Security_SYS.Has_System_Privilege('IMPERSONATE USER', Fnd_Session_API.Get_Fnd_User, FALSE) THEN
      Error_SYS.Record_General(service_, 'SYSPRIV: You must be granted system privilege IMPERSONATE USER in order to be able to run background processes.');
   END IF;
   
   -- By pass check for Admin.
   IF Security_SYS.Has_System_Privilege('ADMINISTRATOR') = 'FALSE' THEN
      IF (Security_SYS.Is_Po_Available(Batch_Schedule_Method_API.Get_Po_Id_For_Method(Get_Method___(action_))) = 'FALSE') THEN
         Error_SYS.Record_General(service_, 'SEC_NEW_JOB: Must have the right to execute method [:P1] to be able to create a new batch process.', Get_Method___(action_));
      END IF;
   END IF;   
   
   Parse_Execution_Plan___(first_time_tz_, subscription_plan_, execution_plan_);
   -- Check if the execution plan is in Oracle's Calendering Syntax or directly evaluatable to a DateTime
   temp_date_ := Get_Date_From_Str___(execution_plan_);
   IF((temp_date_ IS NOT NULL) OR (upper(ltrim(execution_plan_)) LIKE 'FREQ=%')) THEN 
      interval_ := execution_plan_;      
   ELSE 
      interval_ := Fnd_Session_Api.Get_App_Owner||'.Batch_SYS.Update_Exec_Time__('''||subscription_plan_||''')';
   END IF;
      
   LOOP
      temp_job_id_ := sys.jobseq.nextval;
      EXIT WHEN NOT (Exist_Job_(temp_job_id_));
   END LOOP;
   
   job_name_ := job_prefix_||to_char(temp_job_id_);
   IF Installation_SYS.Get_Installation_Mode THEN
      Fnd_Session_Util_Api.Set_Client_Id_(INSTALL_TEM_SYS.bkg_client_id_);
   END IF;
   Dbms_Scheduler.Create_Job(job_name => job_name_, program_name => 'RUN_JOB', start_date => first_time_tz_, repeat_interval => interval_, end_date => NULL, comments => action_);
   Dbms_Scheduler.Set_Job_Argument_Value(job_name => job_name_, argument_position => 1, argument_value => to_char(temp_job_id_));
   Dbms_Scheduler.Set_Job_Argument_Value(job_name => job_name_, argument_position => 2, argument_value => action_);

   IF inst_id_ IS NOT NULL THEN
      Dbms_Scheduler.Set_Attribute(name => job_name_, attribute => 'instance_id', value => inst_id_);
   END IF;

   New_Properties___(temp_job_id_, fnd_user_, Fnd_Session_API.Get_Language, execution_plan_);
   IF Installation_SYS.Get_Installation_Mode = FALSE THEN
      Dbms_Scheduler.Enable(name => job_name_);
   END IF;
   IF Installation_SYS.Get_Installation_Mode THEN
      Fnd_Session_Util_Api.Set_Client_Id_(temp_client_id_);
      Install_Tem_Sys.Lu_Installation_Support(action_, 'INIT_PROCESSING', 'BEGIN Dbms_Scheduler.Enable(name => '''||job_name_||'''); END;');
   END IF;
   -- Set OUT-parameter
   job_id_ := temp_job_id_;
END New_Job___;


PROCEDURE New_Properties___ (
   job_id_         IN NUMBER,
   fnd_user_       IN VARCHAR2,
   lang_code_      IN VARCHAR2,
   execution_plan_ IN VARCHAR2 )
IS
   msg_ VARCHAR2(2000);
BEGIN
   msg_ := Message_SYS.Construct('BATCH_PROPERTIES');
   Message_SYS.Add_Attribute(msg_, 'FND_USER', fnd_user_);
   Message_SYS.Add_Attribute(msg_, 'LANGUAGE', lang_code_);
   Message_SYS.Add_Attribute(msg_, 'EXECUTION_PLAN', execution_plan_);
   INSERT INTO batch_sys_tab
      (job_id, properties)
   VALUES
      (job_id_, msg_);
EXCEPTION
   WHEN dup_val_on_index THEN
      UPDATE batch_sys_tab SET properties = msg_
         WHERE job_id = job_id_;
END New_Properties___;


PROCEDURE Remove_Properties___ (
   job_id_ IN NUMBER )
IS
BEGIN
   DELETE FROM batch_sys_tab
      WHERE job_id = job_id_;
END Remove_Properties___;


FUNCTION Get_Properties___ (
   job_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(2000);
   CURSOR get_props IS
      SELECT properties
      FROM batch_sys_tab
      WHERE job_id = job_id_;
BEGIN
   OPEN get_props;
   FETCH get_props INTO temp_;
   CLOSE get_props;
   RETURN(temp_);
END Get_Properties___;


PROCEDURE Register_Schedule_Meth_Par___ (
   seq_no_            OUT NUMBER,
   schedule_method_id_ IN NUMBER,
   name_               IN VARCHAR2,
   value_              IN VARCHAR2,
   mandatory_db_       IN VARCHAR2 DEFAULT 'TRUE',
   default_expression_ IN VARCHAR2 DEFAULT NULL,
   data_type_          IN VARCHAR2 DEFAULT 'STRING' )
IS
   info_              VARCHAR2(2000);
   objid_             VARCHAR2(2000);
   objversion_        VARCHAR2(2000);
   attr_              VARCHAR2(32000);
BEGIN
   Client_SYS.Add_To_Attr('SCHEDULE_METHOD_ID', schedule_method_id_, attr_);
   Client_SYS.Add_To_Attr('NAME', name_, attr_);
   Client_SYS.Add_To_Attr('VALUE', value_, attr_);
   Client_SYS.Add_To_Attr('MANDATORY_DB', mandatory_db_, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_EXPRESSION', default_expression_, attr_);
   Client_SYS.Add_To_Attr('DATA_TYPE', data_type_, attr_);
   Batch_Schedule_Method_Par_API.New__ (info_, objid_, objversion_, attr_, 'DO');
   seq_no_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SEQ_NO', attr_));
END Register_Schedule_Meth_Par___;


FUNCTION Is_Schedule_Method_Granted___ (
   schedule_method_id_  IN NUMBER,
   batch_schedule_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF batch_schedule_type_ = 'CHAIN' THEN
      RETURN Batch_Schedule_Chain_API.Is_Pres_Object_Available__(Batch_Schedule_Chain_API.Get_Po_Id(schedule_method_id_)) = 'TRUE';
   ELSE
      -- TASK , REPORT
      RETURN Batch_Schedule_API.Is_Method_Po_Available__(Batch_Schedule_Method_API.Get_Method_Name(schedule_method_id_), Batch_Schedule_Method_API.Get_Po_Id(schedule_method_id_)) = 'TRUE';
   END IF;
END Is_Schedule_Method_Granted___;


FUNCTION Get_Next_Exec_Time___ (
   execution_plan_       IN VARCHAR2,
   previous_exec_date_   IN DATE,
   scheduled_start_date_ IN DATE ) RETURN DATE
IS
   exec_plan_           VARCHAR2(4000) := execution_plan_;
   next_time_           DATE;
   tmp_next_time_       DATE;
   day_from_            NUMBER;
   day_to_              NUMBER;
   time_from_           NUMBER;
   time_to_             NUMBER;
   date_                VARCHAR2(10);
   time_                VARCHAR2(10);
   next_date_           VARCHAR2(20);
   days_                VARCHAR2(2000);
   times_               VARCHAR2(2000);
   day_                 VARCHAR2(10);
   tmp_next_date_       VARCHAR2(20);
   base_day_            DATE;
   day_of_base_day_     VARCHAR2(10);
   hour_part_           VARCHAR2(2);
   minute_part_         VARCHAR2(2);
   number_              NUMBER;
   base_time_           DATE;
   plan_without_time_   VARCHAR2(4000);
   plan_time_part_      VARCHAR2(10);
   invalid_day_for_month  EXCEPTION;
   PRAGMA EXCEPTION_INIT(invalid_day_for_month, -01839);

BEGIN
   -- Added Oracle syntax
   IF (upper(exec_plan_) LIKE 'FREQ=%') THEN
      Dbms_Scheduler.Evaluate_Calendar_String(exec_plan_, scheduled_start_date_, nvl(previous_exec_date_, sysdate), next_time_);
      IF (next_time_ IS NOT NULL) THEN
         RETURN(next_time_);
      END IF;
   END IF;
   --
   -- When the schedule is to be started in a future date than the date of method execution
   IF(scheduled_start_date_ > SYSDATE) THEN
      -- Special handling for the time 00:00 in a future start date
      Split___(plan_without_time_, plan_time_part_, upper(execution_plan_), ' AT ');
      IF(ltrim(rtrim(plan_time_part_)) = '00:00') THEN
         base_time_ := scheduled_start_date_ - 1 ;
      ELSE
         base_time_ := scheduled_start_date_;
      END IF;
   ELSE
      base_time_ := SYSDATE;
   END IF;
   --
   exec_plan_ := replace(upper(execution_plan_), 'DAILY ', 'WEEKLY ON Mon;Tue;Wed;Thu;Fri;Sat;Sun ');
   IF (exec_plan_ IS NULL OR exec_plan_ = 'NULL') THEN
      RETURN (NULL);
   ELSIF (Extract___(exec_plan_, 'WEEKLY ON ')) THEN
      base_day_ := trunc(base_time_);
      Split___(days_, times_, exec_plan_, ' AT ');
      days_ := days_||';';
      times_ := Format_Times___(times_)||';';
      day_from_ := 1;
      day_to_ := instr(days_, ';', day_from_);
      day_of_base_day_ := to_char(base_day_, 'DY');
      WHILE (day_to_ > 0) LOOP
         day_ := Nls_Translate_Day_(ltrim(rtrim(substr(days_, day_from_ , day_to_ - day_from_))));
         time_from_ := 1;
         time_to_ := instr(times_, ';', time_from_);
         WHILE (time_to_ > 0) LOOP
            time_ := ltrim(rtrim(substr(times_, time_from_, time_to_ - time_from_)));
            IF (day_ = day_of_base_day_) THEN
               IF (time_ > to_char(base_time_, time_format_)) THEN
                  tmp_next_date_ := to_char(base_day_, date_format_) || ' ' || time_;
                  IF (tmp_next_date_ > next_date_) THEN
                     NULL;
                  ELSE
                     next_date_ := tmp_next_date_;
                  END IF;
               END IF;
            END IF;
            tmp_next_date_ := to_char(next_day(base_day_, day_), date_format_) || ' ' || time_;
            IF (tmp_next_date_ > to_char(base_time_, date_time_format_)) THEN
               IF (tmp_next_date_ > next_date_) THEN
                  NULL;
               ELSE
                  next_date_ := tmp_next_date_;
               END IF;
            END IF;
            time_from_ := time_to_ + 1;
            time_to_ := instr(times_, ';', time_from_);
         END LOOP;
         day_from_ := day_to_ + 1;
         day_to_ := instr(days_, ';', day_from_);
      END LOOP;
      next_time_ := to_date(next_date_, date_time_format_);
   ELSIF (Extract___(exec_plan_, 'MONTHLY ON ')) THEN
      IF (Extract___(exec_plan_, 'DAY ')) THEN
         Split___(number_, time_, exec_plan_, ' AT ');
         -- Correct day range if invalid
         IF (number_ < 1) THEN
            number_ := 1;
         ELSIF (number_ > 31) THEN
            number_ := 31;
         END IF;

         BEGIN
            -- Find a temporary next date
            tmp_next_time_ := to_date(to_char(base_time_, 'YYYY-MM') || '-'|| to_char(number_, '00') || ' ' || time_, date_time_format_);
         EXCEPTION
            WHEN invalid_day_for_month THEN
               -- This day number does not exist for this month. Use last day of this month instead.
               tmp_next_time_ := to_date(to_char(last_day(base_time_), 'YYYY-MM-DD') || ' ' || time_, date_time_format_);
         END;

         -- Add a month if the temporary next date has passed already
         IF (tmp_next_time_ <= base_time_) THEN
            BEGIN
               tmp_next_time_ := to_date(to_char(add_months(base_time_, 1), 'YYYY-MM') || '-'|| to_char(number_, '00') || ' ' || time_, date_time_format_);
            EXCEPTION
               WHEN invalid_day_for_month THEN
                  -- This day number does not exist for this month. Use last day of this month instead.
                  tmp_next_time_ := to_date(to_char(last_day(add_months(base_time_, 1)), 'YYYY-MM-DD') || ' ' || time_, date_time_format_);
            END;
         END IF;
         next_time_ := tmp_next_time_;
      ELSE
         next_time_ := NULL; -- for now..
      END IF;
   ELSIF (Extract___(exec_plan_, 'EVERY ')) THEN
      Split___(hour_part_, minute_part_, exec_plan_, ':' );
      next_time_ := round(nvl(previous_exec_date_, base_time_) + (hour_part_ / 24) + (minute_part_ / 1440), 'MI'); -- round off to minute level..
      WHILE (next_time_ < base_time_) LOOP
         next_time_ := round(nvl(next_time_, base_time_) + (hour_part_ / 24) + (minute_part_ / 1440), 'MI'); -- round off to minute level..
      END LOOP;
   ELSIF (Extract___(exec_plan_, 'ON ')) THEN
      Split___(date_, time_, exec_plan_, ' AT ');
      next_time_ := to_date(date_||' '||time_, date_time_format_);
      IF (next_time_ = previous_exec_date_) OR (next_time_ < base_time_) THEN
         -- return no next execution date if the execution has already taken place
         next_time_ := NULL;
      END IF;
   ELSE
      -- Replace chr(38)||AO and chr(38)||Appowner to Appowner
      exec_plan_ := Replace(upper(exec_plan_), chr(38)||'AO.', Fnd_Session_API.Get_App_Owner||'.');
      exec_plan_ := Replace(upper(exec_plan_), chr(38)||'APPOWNER.', Fnd_Session_API.Get_App_Owner||'.');
      -- Try to evaluate if the execution is authorized and valid.
      Check_Batch_Sched_Cust_Expr__(exec_plan_);
      -- Safe due to Security_SYS.Has_System_Privilege check
      @ApproveDynamicStatement(2011-05-30,haarse)
      EXECUTE IMMEDIATE 'SELECT '||exec_plan_||' FROM dual' INTO next_time_;
   END IF;
   RETURN (next_time_);
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL); -- pragma restricted..
END Get_Next_Exec_Time___;


PROCEDURE Remove_Batch_Queue_Method___(
   method_name_ VARCHAR2)
IS
BEGIN
   Batch_Queue_Method_API.Remove_Method__(method_name_);
END Remove_Batch_Queue_Method___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Cleanup__
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Cleanup__');
   DELETE FROM batch_sys_tab b
      WHERE NOT EXISTS (SELECT 1
                          FROM sys.dba_scheduler_jobs j
                         WHERE j.owner = Fnd_Session_API.Get_App_Owner
                           AND b.job_id = Batch_SYS.Get_Job_Id_(j.job_name));
END Cleanup__;


PROCEDURE Check_Batch_Sched_Cust_Expr__ (
   execution_plan_     IN VARCHAR2 )
IS
   exec_plan_  VARCHAR2(4000) := execution_plan_;
   next_time_  DATE;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Check_Batch_Sched_Cust_Expr__');
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   -- Added Oracle syntax
   IF (upper(exec_plan_) LIKE 'FREQ=%') THEN
      Dbms_Scheduler.Evaluate_Calendar_String(exec_plan_, sysdate, sysdate, next_time_);
      RETURN;
   END IF;
   -- Replace chr(38)||AO and chr(38)||Appowner to Appowner
   exec_plan_ := Replace(upper(exec_plan_), chr(38)||'AO.', Fnd_Session_API.Get_App_Owner||'.');
   exec_plan_ := Replace(upper(exec_plan_), chr(38)||'APPOWNER.', Fnd_Session_API.Get_App_Owner||'.');
   -- Try to evaluate if the execution is a function.
   -- Safe due to Security_SYS.Has_System_Privilege check
   BEGIN
      @ApproveDynamicStatement(2009-08-12,nabalk)
      EXECUTE IMMEDIATE 'SELECT '||exec_plan_||' FROM dual' INTO next_time_;
   EXCEPTION
      WHEN OTHERS THEN
         Error_SYS.Appl_General(service_, 'CUSTOM_EXPRESSION: Invalid execution plan, custom expression must return date.');
   END;
END Check_Batch_Sched_Cust_Expr__;


@UncheckedAccess
FUNCTION Get_Next_Exec_Time__ (
   execution_plan_       IN VARCHAR2,
   previous_exec_date_   IN DATE DEFAULT NULL,
   scheduled_start_date_ IN DATE DEFAULT NULL,
   scheduled_end_date_   IN DATE DEFAULT NULL ) RETURN DATE
IS
   next_exec_time_ DATE;
BEGIN
   next_exec_time_ := Get_Next_Exec_Time___(execution_plan_, previous_exec_date_, trunc(scheduled_start_date_));
   IF (scheduled_end_date_ IS NULL) THEN
      RETURN next_exec_time_;
   ELSE
      -- no next_execution time is returned if the calculated time is past end_date
      IF (next_exec_time_ >= trunc(scheduled_end_date_ + 1)) THEN
         RETURN NULL;
      ELSE
         RETURN next_exec_time_;
      END IF;
   END IF;     
END Get_Next_Exec_Time__;



PROCEDURE New_Job__ (
   job_id_         OUT NUMBER,
   action_         IN  VARCHAR2,
   execution_plan_ IN  VARCHAR2,
   inst_id_        IN  NUMBER DEFAULT NULL )
IS
   temp_job_id_        NUMBER;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Job__');
   New_Job___(temp_job_id_, action_, execution_plan_, Fnd_Session_API.Get_Fnd_User, inst_id_);
   -- Set OUT-parameter
   job_id_ := temp_job_id_;
END New_Job__;


PROCEDURE New_Job_App_Owner__ (
   job_id_         OUT NUMBER,
   action_         IN  VARCHAR2,
   execution_plan_ IN  VARCHAR2,
   inst_id_        IN  NUMBER DEFAULT NULL )
IS
   temp_job_id_        NUMBER;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Job_App_Owner__');
   New_Job___(temp_job_id_, action_, execution_plan_, Fnd_Session_API.Get_App_Owner, inst_id_);
   -- Set OUT-parameter
   job_id_ := temp_job_id_;
END New_Job_App_Owner__;


PROCEDURE Run_Job__ (
   job_id_ IN     NUMBER,
   broken_ IN OUT BOOLEAN,
   action_ IN     VARCHAR2 )
IS
   error_status_  VARCHAR2(2000);
   id_            NUMBER;
   fnd_user_      VARCHAR2(30);
   lang_code_     VARCHAR2(5);
   background_    NUMBER := to_number(Sys_Context('USERENV', 'FG_JOB_ID'));
   logging_       VARCHAR2(10) := Fnd_Setting_API.Get_Value('BATCH_PROCESS_LOG');
   desc_          VARCHAR2(200);
BEGIN
   -- Perform security check if run online, do not perform security check if run in background
   IF background_ <= 0 THEN
      General_SYS.Check_Security(service_, 'BATCH_SYS', 'Run_Job__');
   END IF;
   fnd_user_  := Message_SYS.Find_Attribute(Get_Properties___(job_id_), 'FND_USER', Fnd_Session_API.Get_Fnd_User);
   lang_code_ := Message_SYS.Find_Attribute(Get_Properties___(job_id_), 'LANGUAGE', Fnd_Setting_API.Get_Value('DEFAULT_LANGUAGE'));
   Language_SYS.Set_Language(lang_code_);
   Fnd_Session_API.Impersonate_Fnd_User(fnd_user_);
   error_status_ := NULL;
   -- Log job information
   desc_ := Language_SYS.Translate_Constant(service_, 'BG_JOB_DESC: Background job :P1', Fnd_Session_API.Get_Language, to_char(job_id_));
   IF (logging_ = 'ON') THEN
      id_ := Transaction_SYS.Log_Started__(job_id_, action_, desc_);
   END IF;
   $IF Component_Fndwf_SYS.INSTALLED $THEN
      Bpa_Sys.Init_Session(false);
   $END
   -- Safe due to Security_SYS.Has_System_Privilege check in Fnd_Session_API.Impersonate_Fnd_User
   @ApproveDynamicStatement(2009-08-12,nabalk)
   EXECUTE IMMEDIATE 'BEGIN '||replace(action_, 'job_id_', job_id_)||'; END;';
   IF (logging_ = 'ON') THEN
      Transaction_SYS.Log_Finished__(id_);
   END IF;
   Fnd_Session_API.Reset_Fnd_User;
   -- Commit the actual job
   @ApproveTransactionStatement(2013-11-07,haarse)
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      @ApproveTransactionStatement(2013-11-07,haarse)
      ROLLBACK;
      error_status_ := SQLERRM;
      IF (id_ IS NULL) THEN
         id_ := Transaction_SYS.Log_Started__(job_id_, action_, desc_);
      END IF;
      Transaction_SYS.Log_Error__(id_, error_status_);
      Fnd_Session_API.Reset_Fnd_User;
      RAISE;
END Run_Job__;


PROCEDURE Run_Job__ (
   job_id_ IN     NUMBER,
   action_ IN     VARCHAR2 )
IS
   broken_     BOOLEAN := FALSE;
   background_ NUMBER  := to_number(Sys_Context('USERENV', 'FG_JOB_ID'));
BEGIN
   -- Perform security check if run online, do not perform security check if run in background
   IF background_ <= 0 THEN
      General_SYS.Check_Security(service_, 'BATCH_SYS', 'Run_Job__');
   END IF;
   Run_Job__(job_id_,broken_, action_);
END Run_Job__;


PROCEDURE Stop_Job__ (
   job_id_ IN  NUMBER,
   force_  IN  VARCHAR2 DEFAULT 'FALSE')
IS
   force_param_   BOOLEAN;
   not_running    EXCEPTION;
   PRAGMA         EXCEPTION_INIT(not_running, -27366);
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Stop_Job__');
   IF (force_ = 'FALSE') THEN
      force_param_ := FALSE;
   ELSE
      force_param_ := TRUE;
   END IF;
   Dbms_Scheduler.Stop_Job(job_name => Get_Job_Name_(job_id_), force => force_param_);
EXCEPTION
   WHEN not_running THEN
         Error_SYS.Appl_General(service_, 'NOT_RUNNING: You can only stop running jobs, job :P1 is not currently running.', job_id_);
END Stop_Job__;


PROCEDURE Set_Background_Processes__ (
   no_processes_  IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Set_Background_Processes__');
   Dbms_Scheduler.Set_Scheduler_Attribute('MAX_JOB_SLAVE_PROCESSES', no_processes_);
END Set_Background_Processes__;


PROCEDURE Validate_Execution_Plan__(
   exec_plan_ VARCHAR2)
IS
   execution_plan_  VARCHAR2(4000);
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Validate_Execution_Plan__');
   -- This function was introduced for the execution plan interval since Parse_Execution_Plan___ has an upper limit of 23:59
   -- From client side this upper limit is enforced, but from server side when a schedule is registered there was no validation
   -- Due to the reason of defining an upper limit can't be taken in support, only the 00:00 validation was done in here
   -- When such a decision will be taken in the future, usage of this procedure can be decided.
   execution_plan_ := exec_plan_;
   IF (Extract___(execution_plan_, 'EVERY ')) THEN
      IF (Validate_Time___(execution_plan_)) THEN
         IF (execution_plan_ <= '00:00' ) THEN
            Error_SYS.Appl_General(service_, 'TIMEZERO: Time interval requires a value greater than 00:00');
         END IF;
      END IF;
   END IF;
END Validate_Execution_Plan__;


@UncheckedAccess
FUNCTION Update_Exec_Time__ (
   execution_plan_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN Get_Next_Exec_Time__ (execution_plan_, NULL, NULL, NULL);
END Update_Exec_Time__;



PROCEDURE Drop_Foundation__
IS
   appowner_  VARCHAR2(30) := Fnd_Session_API.Get_App_Owner;
   CURSOR get_jobs (owner_ IN VARCHAR2) IS
      SELECT Batch_SYS.Get_Job_Id_(job_name) job_id
        FROM dba_scheduler_jobs
       WHERE owner = owner_
         AND job_name LIKE job_prefix_||'%';
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Drop_Foundation__');
   FOR rec IN get_jobs(appowner_) LOOP
      Batch_SYS.Remove_Job_(rec.job_id);
   END LOOP;
END Drop_Foundation__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Fnd_Heavy_Cleanup_
--   Make a heavy cleanup for Foundation1 data such as: InfoServices archive.
PROCEDURE Fnd_Heavy_Cleanup_
IS
   message_  VARCHAR2(2000);
   err_text_ VARCHAR2(2000);
   nl_       VARCHAR2(2) := chr(13)||chr(10);
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Fnd_Heavy_Cleanup_');
   -- Initiate CLIENT_INFO structure
   Fnd_Session_API.Init;

   -- Cleanup Batch Job
   Transaction_SYS.Log_Progress_Info ('Batch Job Cleanup started.');
   BEGIN
      Batch_SYS.Cleanup__;
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-07,haarse)
         ROLLBACK;
         err_text_ := 'Bach_SYS.Cleanup__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;

   -- Cleanup Print Job
   Transaction_SYS.Log_Progress_Info ('PrintJob Cleanup started.');
   BEGIN
      Print_Job_API.Cleanup__;
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-07,haarse)
         ROLLBACK;
         err_text_ := 'Print_Job_API.Cleanup__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;

   -- Cleanup Archive
   Transaction_SYS.Log_Progress_Info ('Archive cleanup started.');
   BEGIN
      Archive_API.Cleanup__;
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-07,haarse)
         ROLLBACK;
         err_text_ := 'Archive_API.Cleanup__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;

   -- Cleanup History Log
   Transaction_SYS.Log_Progress_Info ('History cleanup started.');
   BEGIN
      History_Log_Util_API.Cleanup__;
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-07,haarse)
         ROLLBACK;
         err_text_ := 'History_Log_Util_API.Cleanup__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;

   -- Cleanup Batch Schedule
   Transaction_SYS.Log_Progress_Info ('Batch Schedule cleanup started.');
   BEGIN
      Batch_Schedule_API.Cleanup__;
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-07,haarse)
         ROLLBACK;
         err_text_ := 'Batch_Schedule_API.Cleanup__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;

   -- Cleanup Security Checkpoint Log
   Transaction_SYS.Log_Progress_Info ('Security Checkpoint cleanup started.');
   BEGIN
      Sec_Checkpoint_Log_API.Cleanup__;
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-07,haarse)
         ROLLBACK;
         err_text_ := 'Sec_Checkpoint_Log_API.Cleanup__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;

   -- Cleanup Server Log Checkpoint Log
   Transaction_SYS.Log_Progress_Info ('Server Log cleanup started.');
   BEGIN
      Server_Log_Utility_API.Cleanup__;
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-07,haarse)
         ROLLBACK;
         err_text_ := 'Server_Log_Utility_API.Cleanup__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;
   -- Cleanup Application Message Statistics
   Transaction_SYS.Log_Progress_Info ('Application Message Statistics cleanup started.');
   BEGIN
      Application_Msg_Statistics_Api.Cleanup;
      @ApproveTransactionStatement(2016-01-19,maddlk)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2016-01-19,maddlk)
         ROLLBACK;
         err_text_ := 'Application_Msg_Statistics_Api.Cleanup failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;
   -- Cleanup Install Tem Sys Log Checkpoint Log
   Transaction_SYS.Log_Progress_Info ('Install Tem Sys Log cleanup started.');
   BEGIN
      Install_Tem_SYS.Cleanup__;
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-07,haarse)
         ROLLBACK;
         err_text_ := 'Install_Tem_SYS.Cleanup__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;

   -- Cleanup Pres Object Sec Export Orphaned Objects
   Transaction_SYS.Log_Progress_Info ('Pres Object Sec Export cleanup started.');
   BEGIN
      Pres_Object_Sec_Export_API.Cleanup__;
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-07,haarse)
         ROLLBACK;
         err_text_ := 'Pres_Object_Sec_Export_API.Cleanup__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;

   Transaction_SYS.Log_Progress_Info ('Security_SYS cleanup started.');
   BEGIN
      Security_SYS.Cleanup__;
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-07,haarse)
         ROLLBACK;
         err_text_ := 'Security_SYS.Cleanup__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;
   
   Transaction_SYS.Log_Progress_Info ('Database_SYS.Cleanup_Temporary_Data__ started.');
   BEGIN
      Database_SYS.Cleanup_Temporary_Data__;
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-07,haarse)
         ROLLBACK;
         err_text_ := 'Database_SYS.Cleanup_Temporary_Data__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;
      
   Transaction_SYS.Log_Progress_Info ('Fnd_Stream_API.Cleanup_Messages_ started.');
   BEGIN
      Fnd_Stream_API.Cleanup_Messages_;
      @ApproveTransactionStatement(2015-01-19,wawilk)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2015-11-19,wawilk)
         ROLLBACK;
         err_text_ := 'Fnd_Stream_API.Cleanup_Messages_ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;
   
   Transaction_SYS.Log_Progress_Info ('Report_Rule_Log_API.Remove_Expired_Logs__ started.');
   BEGIN
      Report_Rule_Log_API.Remove_Expired_Logs__;
      @ApproveTransactionStatement(2016-10-25,asiwlk)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2016-10-25,asiwlk)
         ROLLBACK;
         err_text_ := 'Report_Rule_Log_API.Remove_Expired_Logs__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;

   Transaction_SYS.Log_Progress_Info ('Quick_Report_Log_API.Remove_Expired_Logs__ started.');
   BEGIN
      Quick_Report_Log_API.Remove_Expired_Logs__;
      @ApproveTransactionStatement(2016-10-25,asiwlk)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2018-11-24,mabalk)
         ROLLBACK;
         err_text_ := 'Quick_Report_Log_API.Remove_Expired_Logs__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;
   
   -- Cleanup Light Cleanup job
   Transaction_SYS.Log_Progress_Info ('Light Cleanup job cleanup started.');
   BEGIN
      Transaction_SYS.Cleanup_Light_Cleanup_Job__;
      @ApproveTransactionStatement(2019-11-04,NaBaLK)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2019-11-04,NaBaLK)
         ROLLBACK;
         err_text_ := 'Transaction_SYS.Cleanup_Light_Cleanup_Job__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;
   
   -- Cleanup FND_UNZIPPED_FILE_TEMP_TAB table and FND_ZIP_TEMP_TAB table
   BEGIN
      Fnd_Zip_File_Temp_API.Cleanup_;
      @ApproveTransactionStatement(2020-01-23,AkiRLK)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2020-01-23,AkiRLK)
         ROLLBACK;
         err_text_ := 'Fnd_Zip_File_Temp_API.Cleanup_ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;
   
   -- Notify application owner via email if failure.
   IF (message_ IS NOT NULL) THEN
      message_ := 'Foundation1 Heavy Cleanup failed'||nl_||message_;
      --Command_SYS.Mail(Fnd_Session_API.Get_App_Owner, Fnd_Session_API.Get_App_Owner, message_, subject_ => 'Foundation1 Heavy Cleanup Failure');
      Command_SYS.Mail(NULL, Fnd_Session_API.Get_App_Owner, Fnd_Session_API.Get_App_Owner, NULL, NULL, 'Foundation1 Heavy Cleanup Failure', message_, NULL);
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   END IF;
   Transaction_SYS.Log_Progress_Info ('');
END Fnd_Heavy_Cleanup_;


-- Fnd_Light_Cleanup_
--   Make a ligth cleanup for Foundation1 data such as: Old database sessions,
--   Background processes, Event messages and Print server jobs.
PROCEDURE Fnd_Light_Cleanup_
IS
   message_  VARCHAR2(2000);
   err_text_ VARCHAR2(2000);
   tnum_     NUMBER;
   nl_       VARCHAR2(2) := chr(13)||chr(10);
BEGIN
   -- Initiate CLIENT_INFO structure
   Fnd_Session_API.Init;

   -- Cleanup background jobs
   Transaction_SYS.Log_Progress_Info ('Background Job Cleanup started.');
   BEGIN
      tnum_ := to_number(Fnd_Setting_API.Get_Value('KEEP_DEFJOBS'));
      Transaction_SYS.Cleanup__(tnum_, 'Ready');
      tnum_ := to_number(Fnd_Setting_API.Get_Value('KEEP_DEFJOBS_WARNING'));
      Transaction_SYS.Cleanup__(tnum_, 'Warning');
      tnum_ := to_number(Fnd_Setting_API.Get_Value('KEEP_DEFJOBS_ERROR'));
      Transaction_SYS.Cleanup__(tnum_, 'Error');
      Transaction_SYS.Cleanup_Executing__;
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-07,haarse)
         ROLLBACK;
         err_text_ := 'Transaction_SYS.Cleanup__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;

   -- Cleanup Connectivity
   Transaction_SYS.Log_Progress_Info ('Connectivity Cleanup started.');
   BEGIN
      Connectivity_SYS.Cleanup__;
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-07,haarse)
         ROLLBACK;
         err_text_ := 'Connectivity_SYS.Cleanup__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;

   -- Process scheduled replications
   Transaction_SYS.Log_Progress_Info ('Scheduled IAL Replications started.');
   IF (Fnd_Setting_API.Get_Value('IAL_REPLICATION') = 'ON') THEN
      BEGIN
         IAL_Object_Util_API.Initiate_Replication__;
         @ApproveTransactionStatement(2013-11-07,haarse)
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            @ApproveTransactionStatement(2013-11-07,haarse)
            ROLLBACK;
            err_text_ := 'IAL_Object_API.Initiate_Replication__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
            message_  := message_ || err_text_ || nl_;
            Transaction_SYS.Log_Status_Info (err_text_);
      END;
   END IF;

   -- Recompile invalid Materialized view
   Transaction_SYS.Log_Progress_Info ('Recompile of Materialized views started.');
   BEGIN
      Database_SYS.Compile_All_Invalid_Objects('MATERIALIZED VIEW');
      @ApproveTransactionStatement(2015-09-15,haarse)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2015-09-15,haarse)
         ROLLBACK;
         err_text_ := 'Recompile of Materialized views failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;
   
   -- Cleanup temporary lob store
    Transaction_SYS.Log_Progress_Info ('Cleaning up temporary lob store.');
   BEGIN
      Fnd_Temp_Lob_Store_API.Remove_Old_Temp_Lobs_;
      @ApproveTransactionStatement(2019-02-08,wawilk)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2019-02-08,wawilk)
         ROLLBACK;
         err_text_ := 'Cleaning up temporary lob store failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;

   -- Cleanup Excel parameter cache table
    Transaction_SYS.Log_Progress_Info ('Cleanup export to Excel cache.');
   BEGIN
      Excel_Parameter_Cache_API.Clear_Obsolete_Entries;
      @ApproveTransactionStatement(2022-01-28,sumelk)
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2022-01-28,sumelk)
         ROLLBACK;
         err_text_ := 'Cleanup export to Excel cache failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         message_  := message_ || err_text_ || nl_;
         Transaction_SYS.Log_Status_Info (err_text_);
   END;
   
   -- Notify application owner via email if failure.
   IF (message_ IS NOT NULL) THEN
      message_ := 'Foundation1 Light Cleanup failed'||nl_||message_;
      --Command_SYS.Mail(Fnd_Session_API.Get_App_Owner, Fnd_Session_API.Get_App_Owner, message_, subject_ => 'Foundation1 Light Cleanup Failure');
      Command_SYS.Mail(NULL, Fnd_Session_API.Get_App_Owner, Fnd_Session_API.Get_App_Owner, NULL, NULL, 'Foundation1 Light Cleanup Failure', message_, NULL);
      @ApproveTransactionStatement(2013-11-07,haarse)
      COMMIT;
   END IF;
   Transaction_SYS.Log_Progress_Info ('');
END Fnd_Light_Cleanup_;


-- Init_All_Processes_
--   Initiate all necessary Foundation1 processes.
PROCEDURE Init_All_Processes_ (
   dummy_ IN NUMBER )
IS
   time_         NUMBER;
   job_key_      NUMBER;
   process_      VARCHAR2(30);
   interval_     VARCHAR2(100);
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Init_All_Processes_');
   -- Check for system privileges
   Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User);
   -- Loop over jobs to process
   Remove_Job_On_Method_('BATCH_SYS.PROCESS');
   BEGIN
      process_ := Fnd_Setting_API.Get_Value('BATCH_SCHEDULE', Installation_SYS.Get_Installation_Mode);
   EXCEPTION
      WHEN OTHERS THEN
         process_ := 'OFF';
   END;
   IF (process_ = 'ON') THEN
      BEGIN
         time_ := Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('BATCH_SCHED_STARTUP', Installation_SYS.Get_Installation_Mode));
         IF (time_ IS NULL) THEN
            time_ := 3600;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            time_ := 3600;
      END;
      interval_ := 'sysdate + '||to_char(time_)||'/86400';
      Batch_SYS.New_Job_App_Owner__(job_key_, 'Batch_SYS.Process_Batch_Schedule_(0)', interval_);
   END IF;
END Init_All_Processes_;


@UncheckedAccess
FUNCTION Get_Batch_Queue_For_Method_ (
   method_name_     IN VARCHAR2,
   lang_code_       IN VARCHAR2 ) RETURN NUMBER
IS
   queue_id_ NUMBER;

   CURSOR get_queue IS
      SELECT b.queue_id
      FROM   batch_queue_tab b, batch_queue_method_tab bm
      WHERE  b.queue_id = bm.queue_id
      AND    Upper(method_name) = Upper(method_name_)
      AND    nvl(lang_code_, '%') LIKE nvl(b.lang_code, '%');
BEGIN
   -- Check that method and language matches for specified queue, else return Null
   OPEN  get_queue;
   FETCH get_queue INTO queue_id_;
   CLOSE get_queue;
   RETURN queue_id_;
END Get_Batch_Queue_For_Method_;


-- Process_Batch_Schedule_
--   Process all batch schedules that are due for processing.
PROCEDURE Process_Batch_Schedule_ (
   dummy_ IN NUMBER )
IS
   fnd_user_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   CURSOR get_batch_schedule IS
      SELECT s.schedule_id,
             s.username,
             s.batch_schedule_type,
             s.schedule_method_id
        FROM batch_schedule_tab s,
             (SELECT schedule_method_id
                FROM batch_schedule_method_tab m
              UNION
              SELECT schedule_method_id 
                FROM batch_schedule_chain_tab m) m
       WHERE s.active = 'TRUE'
         AND s.next_execution_date <= SYSDATE
         AND s.schedule_method_id = m.schedule_method_id
            -- Check Access Right
         AND (s.username = fnd_user_ OR
             Security_SYS.Has_System_Privilege('ADMINISTRATOR') = 'TRUE')
       ORDER BY s.next_execution_date, s.schedule_id;
   -- Preferred to lock records, but this can cause ORA-01555 snapshot too old.
   -- FOR UPDATE OF next_date;
   BEGIN
      General_SYS.Check_Security(service_, 'BATCH_SYS', 'Process_Batch_Schedule_');
      FOR rec IN get_batch_schedule LOOP
         BEGIN
            -- Set Fnd_User
            Fnd_Session_API.Impersonate_Fnd_User(rec.username);
            -- Check if the user has permission to execute the schedule
            IF Is_Schedule_Method_Granted___(rec.schedule_method_id, rec.batch_schedule_type) THEN
               Batch_Schedule_API.Run_Batch_Schedule__(rec.schedule_id, 'FALSE');
               Fnd_Session_API.Reset_Fnd_User;
            ELSE
               Fnd_Session_API.Reset_Fnd_User;
               -- Deactivate the batch schedule.
               Deactivate_Batch_Schedule(rec.schedule_id);
            END IF;
            @ApproveTransactionStatement(2013-11-07,haarse)
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
               Deactivate_Batch_Schedule(rec.schedule_id);
               @ApproveTransactionStatement(2015-09-02,wawilk)
               COMMIT;
               Error_SYS.Appl_General(service_, 'SCHEDULEDEACTIVATED: Schedule [:P1] deactivated due to error - [:P2].', rec.schedule_id, SQLERRM);
         END;
      END LOOP;
   EXCEPTION
      WHEN OTHERS THEN
         -- Set Back Fnd_User
         Fnd_Session_API.Reset_Fnd_User;
         RAISE;
   END Process_Batch_Schedule_;


@UncheckedAccess
FUNCTION Exist_Job_ (
   job_id_ IN NUMBER ) RETURN BOOLEAN
IS
   CURSOR exist_job IS
      SELECT 1
      FROM   user_scheduler_jobs
      WHERE  Batch_SYS.Get_Job_Id_(job_name) = job_id_;
   dummy_ NUMBER;
BEGIN
   OPEN exist_job;
   FETCH exist_job INTO dummy_;
   IF (exist_job%FOUND) THEN
      CLOSE exist_job;
      RETURN (TRUE);
   ELSE
      CLOSE exist_job;
      RETURN (FALSE);
   END IF;
END Exist_Job_;



@UncheckedAccess
PROCEDURE Exist_Job_ (
   job_id_ IN NUMBER )
IS
BEGIN
   IF (Exist_Job_(job_id_)) THEN
      NULL;
   ELSE
      Error_SYS.Appl_General(service_, 'JOBNOTEXISTERR: Job [:P1] does not exist.', job_id_);
   END IF;
END Exist_Job_;


PROCEDURE New_Job_ (
   job_id_         OUT NUMBER,
   action_         IN  VARCHAR2,
   execution_plan_ IN  VARCHAR2 )
IS
   temp_job_id_        NUMBER;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Job_');
   New_Job__ (temp_job_id_, action_, execution_plan_);
   -- Set OUT-parameter
   job_id_ := temp_job_id_;
END New_Job_;


PROCEDURE New_Job_Schedule_ (
   job_id_         OUT NUMBER,
   action_         IN  VARCHAR2,
   plan_method_    IN  VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Job_Schedule_');
   New_Job__(job_id_, action_, plan_method_);
END New_Job_Schedule_;


PROCEDURE Modify_Job_ (
   job_id_         IN  NUMBER,
   action_         IN  VARCHAR2,
   execution_plan_ IN  VARCHAR2 )
IS
   temp_date_          DATE;
   first_time_tz_      TIMESTAMP WITH TIME ZONE;
   subscription_plan_  VARCHAR2(180);
   interval_           VARCHAR2(200);
   full_action_        VARCHAR2(2000);

   CURSOR get_full_action IS
      SELECT username||'.Batch_SYS.Run_Job__(job, broken, '''||action_||''');' full_action
      FROM user_users;

   CURSOR get_interval IS
      SELECT username||'.Batch_SYS.Update_Exec_Time__('''||subscription_plan_||''')' interval
      FROM user_users;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Modify_Job_');
   IF (Exist_Job_(job_id_)) THEN
      IF (action_ IS NOT NULL) THEN
         OPEN get_full_action;
         FETCH get_full_action INTO full_action_;
         CLOSE get_full_action;
      ELSE
         full_action_ := NULL; -- will not be modified..
      END IF;
      IF (execution_plan_ IS NOT NULL) THEN
         IF (execution_plan_ = 'NOW AND ...') THEN
            first_time_tz_ := SYSTIMESTAMP;
            interval_ := NULL; -- Do not modify interval
         ELSE
            Parse_Execution_Plan___(first_time_tz_, subscription_plan_, execution_plan_);
            -- Check if the execution plan is in Oracle's Calendering Syntax or directly evaluatable to a DateTime
            temp_date_ := Get_Date_From_Str___(execution_plan_);
            IF((temp_date_ IS NOT NULL) OR (upper(ltrim(execution_plan_)) LIKE 'FREQ=%')) THEN 
               interval_ := execution_plan_;      
            ELSE 
               OPEN get_interval;
               FETCH get_interval INTO interval_;
               CLOSE get_interval;
            END IF;
         END IF;
      ELSE
         first_time_tz_ := NULL;-- will not be modified..
         interval_ := NULL; -- will not be modified..
      END IF;
      IF (full_action_ IS NOT NULL) THEN
         Dbms_Scheduler.Set_Job_Argument_Value(Get_Job_Name_(job_id_), 'ACTION', full_action_);
      END IF;
      IF (interval_ IS NOT NULL) THEN
         Dbms_Scheduler.Set_Attribute(Get_Job_Name_(job_id_), 'REPEAT_INTERVAL', interval_);
      END IF;
      IF (first_time_tz_ IS NOT NULL) THEN
         Dbms_Scheduler.Set_Attribute(Get_Job_Name_(job_id_), 'START_DATE', first_time_tz_);
         IF Installation_SYS.Get_Installation_Mode = FALSE THEN
            Dbms_Scheduler.Enable(Get_Job_Name_(job_id_));
         END IF;
      END IF;
   ELSE
      Error_SYS.Appl_General(service_, 'JOBNOTEXISTERR: Job [:P1] does not exist.', job_id_);
   END IF;
END Modify_Job_;


PROCEDURE Remove_Job_ (
   job_id_ IN  NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Remove_Job_');
   Exist_Job_(job_id_);
   Dbms_Scheduler.Drop_Job(Get_Job_Name_(job_id_));
   Remove_Properties___(job_id_);
END Remove_Job_;

PROCEDURE Remove_Job_On_Method_ (
   method_ IN VARCHAR2 )
IS
   appowner_     VARCHAR2(30) := Fnd_Session_API.Get_App_Owner;
   system_priv_  VARCHAR2(5);
   CURSOR get_jobs (owner_ IN VARCHAR2, system_privilegies_ IN VARCHAR2) IS
      SELECT Batch_SYS.Get_Job_Id_(j.job_name) job_id, j.job_name
        FROM dba_scheduler_jobs     j,
             dba_scheduler_job_args a
       WHERE j.owner = owner_
         AND j.owner = a.owner
         AND j.job_name = a.job_name
         AND a.argument_name = 'ACTION_'
         AND upper(a.VALUE) LIKE UPPER(method_)||'%'
         AND (EXISTS (SELECT 1
                  FROM fnd_user f
                    WHERE f.identity = j.job_creator)
           OR system_privilegies_='TRUE')
      UNION
      SELECT Batch_SYS.Get_Job_Id_(j.job_name) job_id, j.job_name
        FROM dba_scheduler_jobs     j
       WHERE j.owner = owner_
         AND upper(j.COMMENTS) LIKE '%'||UPPER(method_)||'%'
         AND (EXISTS (SELECT 1
                  FROM fnd_user f
                    WHERE f.identity = j.job_creator)
           OR system_privilegies_='TRUE')
         AND NOT EXISTS (SELECT 1
                  FROM dba_scheduler_job_args a
                  WHERE j.owner = a.owner
                  AND j.job_name = a.job_name);
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Process_Job_On_Method_');
   -- Check for system privilege
   Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User);
   system_priv_ := Security_SYS.Has_System_Privilege('ADMINISTRATOR');
   FOR rec_ IN get_jobs(appowner_, system_priv_) LOOP
      Dbms_Scheduler.Drop_Job(rec_.job_name);
      Remove_Properties___(rec_.job_id);
   END LOOP;
END Remove_Job_On_Method_;

PROCEDURE Process_Job_ (
   job_id_ IN  NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Process_Job_');
   IF (Exist_Job_(job_id_)) THEN
      Dbms_Scheduler.Run_Job(Get_Job_Name_(job_id_));
   ELSE
      Error_SYS.Appl_General(service_, 'JOBNOTEXISTERR: Job [:P1] does not exist.', job_id_);
   END IF;
END Process_Job_;


PROCEDURE Enable_Job_ (
   job_id_ IN  NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Enable_Job_');
   Exist_Job_(job_id_);
   Dbms_Scheduler.Enable(Get_Job_Name_(job_id_));
END Enable_Job_;


PROCEDURE Disable_Job_ (
   job_id_ IN  NUMBER )
IS
   status_ VARCHAR2(100);
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Disable_Job_');
   Exist_Job_(job_id_);
   status_ := Get_Status_(job_id_);
   -- Stop the job if it is running
   IF (status_ = 'RUNNING') THEN
      BEGIN
         Dbms_Scheduler.Stop_Job(Get_Job_Name_(job_id_));
      EXCEPTION
         WHEN OTHERS THEN
            Dbms_Scheduler.Stop_Job(Get_Job_Name_(job_id_), TRUE);
      END;
   END IF;
   Dbms_Scheduler.Disable(Get_Job_Name_(job_id_));
END Disable_Job_;


PROCEDURE Modify_Status_ (
   job_id_ IN NUMBER,
   status_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Modify_Status_');
   CASE upper(status_)
      WHEN 'BROKEN' THEN
         Disable_Job_(job_id_);
      WHEN 'ACTIVE' THEN
         Enable_Job_(job_id_);
      ELSE
         Error_SYS.Appl_General(service_, 'STATERR: Unrecognized status [:P1].', status_);
   END CASE;
END Modify_Status_;


@UncheckedAccess
FUNCTION Get_Job_Id_ (
   job_name_  IN  VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN(to_number(REPLACE(job_name_, job_prefix_, '')));
EXCEPTION
   WHEN OTHERS THEN
      RETURN(NULL);
--      Error_SYS.Appl_General(service_, 'NOTF1JOB: Job [:P1] is not an Foundation1 job.', job_name_);
END Get_Job_Id_;



@UncheckedAccess
FUNCTION Get_Job_Name_ (
   job_id_  IN  NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN(job_prefix_||to_char(job_id_));
END Get_Job_Name_;



@UncheckedAccess
FUNCTION Get_Status_ (
   job_id_         IN  NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_status IS
   SELECT state
   FROM   user_scheduler_jobs
   WHERE  job_name = Get_Job_Name_(job_id_);
   state_ VARCHAR2(100);
BEGIN
   OPEN  get_status;
   FETCH get_status INTO state_;
   CLOSE get_status;
   RETURN(state_);
END Get_Status_;



@UncheckedAccess
FUNCTION Get_Action_ (
   job_id_  IN  NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_action IS
   SELECT value
   FROM   user_scheduler_job_args
   WHERE  job_name = Get_Job_Name_(job_id_)
   AND    argument_name = 'ACTION_';
   action_ VARCHAR2(1000);
BEGIN
   OPEN  get_action;
   FETCH get_action INTO action_;
   CLOSE get_action;
   RETURN(action_);
END Get_Action_;



@UncheckedAccess
FUNCTION Get_Execution_Plan_ (
   job_id_         IN  NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_exec_plan IS
   SELECT repeat_interval
   FROM   user_scheduler_jobs
   WHERE  job_name = Get_Job_Name_(job_id_);
   exec_plan_  VARCHAR2(1000);
BEGIN
   OPEN  get_exec_plan;
   FETCH get_exec_plan INTO exec_plan_;
   CLOSE get_exec_plan;
   RETURN(exec_plan_);
END Get_Execution_Plan_;



@UncheckedAccess
FUNCTION Get_Exec_Time_ (
   job_id_         IN  NUMBER ) RETURN DATE
IS
   next_exec_time_     DATE;
BEGIN
   SELECT next_run_date
      INTO  next_exec_time_
      FROM  user_scheduler_jobs
   WHERE  job_name = Get_Job_Name_(job_id_);
   RETURN (next_exec_time_);
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL); -- pragma restricted..
END Get_Exec_Time_;


@UncheckedAccess
FUNCTION Get_Comment_ (
   job_id_         IN  NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_comment IS
   SELECT comments
   FROM   user_scheduler_jobs
   WHERE  job_name = Get_Job_Name_(job_id_);
   comment_  VARCHAR2(1000);
BEGIN
   OPEN  get_comment;
   FETCH get_comment INTO comment_;
   CLOSE get_comment;
   RETURN(comment_);
END Get_Comment_;


@UncheckedAccess
FUNCTION Get_State_ (
   job_id_         IN  NUMBER ) RETURN VARCHAR2
IS
   state_ VARCHAR2(100);
BEGIN
   SELECT state
      INTO  state_
      FROM  user_scheduler_jobs
   WHERE  job_name = Get_Job_Name_(job_id_);
   RETURN (state_);
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL); -- pragma restricted..
END Get_State_;



@UncheckedAccess
FUNCTION Get_Job_Id_From_Action_ (
   action_         IN  VARCHAR2 ) RETURN NUMBER 
IS
   job_id_ NUMBER;
BEGIN
   SELECT  Batch_SYS.Get_Job_Id_(job_name)
      INTO job_id_
      FROM   user_scheduler_job_args
      WHERE  argument_name = 'ACTION_'
      AND    value LIKE action_;
      RETURN (job_id_);
EXCEPTION
   WHEN too_many_rows THEN
      Error_SYS.Appl_General(lu_name_, 'MANYJOBS: More than one job matches this action [:P1].', action_);
   WHEN OTHERS THEN
      RETURN (NULL); -- pragma restricted..
END Get_Job_Id_From_Action_;


@UncheckedAccess
FUNCTION Nls_Translate_Day_ (
   day_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
--    Old code which did not work in other NLS-territories than AMERICA
--    RETURN (to_char(trunc(sysdate,'DY') + ((instr(instr(valid_days_, upper(day_)) - 1) / 4) + 1, 'DY'));

   -- 990201 is a monday...
   RETURN(to_char(to_date('1999020'||to_char((instr(valid_days_, upper(day_)) + 2) / 4)||' '||day_,
                          'YYYYMMDD DY',
                          'NLS_DATE_LANGUAGE=AMERICAN'),
                  'DY'));
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL); -- pragma restricted..
END Nls_Translate_Day_;



@UncheckedAccess
FUNCTION Is_Subscription_ (
   job_id_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   IF (Exist_Job_(job_id_)) THEN
      RETURN(TRUE);
   ELSE
      RETURN (FALSE);
   END IF;
END Is_Subscription_;



-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Nls_Translate_Day (
   day_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Nls_Translate_Day_(day_));
END Nls_Translate_Day;



@UncheckedAccess
FUNCTION Exist_Batch_Schedule (
   installation_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Batch_Schedule_API.Check_Installation_Id__(installation_id_);
END Exist_Batch_Schedule;



PROCEDURE Activate_Batch_Schedule (
   schedule_id_  IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Activate_Batch_Schedule');
   Batch_Schedule_API.Activate__(schedule_id_);
END Activate_Batch_Schedule;


PROCEDURE Deactivate_Batch_Schedule (
   schedule_id_  IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Deactivate_Batch_Schedule');
   Batch_Schedule_API.Deactivate__(schedule_id_);
END Deactivate_Batch_Schedule;


PROCEDURE Modify_Batch_Schedule (
   next_execution_date_ IN OUT DATE,
   start_date_          IN     DATE,
   stop_date_           IN     DATE,
   schedule_id_         IN     NUMBER,
   schedule_name_       IN     VARCHAR2,
   active_db_           IN     VARCHAR2,
   execution_plan_      IN     VARCHAR2,
   lang_code_           IN     VARCHAR2 DEFAULT NULL,
   stream_msg_on_completion_ IN VARCHAR2 DEFAULT 'FALSE',
   stream_notes_ IN VARCHAR2 DEFAULT NULL,
   check_executing_db_ IN VARCHAR2 DEFAULT 'FALSE',
   queue_id_           IN     NUMBER DEFAULT NULL)
IS
   attr_              VARCHAR2(2000);
   info_              VARCHAR2(2000);
   objid_             VARCHAR2(2000);
   objversion_        VARCHAR2(2000);
   CURSOR get_batch_schedule IS
      SELECT objid, objversion
      FROM   batch_schedule
      WHERE  schedule_id = schedule_id_;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Modify_Batch_Schedule');
   OPEN  get_batch_schedule;
   FETCH get_batch_schedule INTO objid_, objversion_;
   CLOSE get_batch_schedule;

   IF (start_date_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('START_DATE', start_date_, attr_);
   END IF;

   IF (stop_date_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STOP_DATE', stop_date_, attr_);
   END IF;

   IF (next_execution_date_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NEXT_EXECUTION_DATE', next_execution_date_, attr_);
   END IF;

   IF (execution_plan_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('EXECUTION_PLAN', execution_plan_, attr_);
   END IF;

   IF (active_db_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ACTIVE_DB', active_db_, attr_);
   END IF;

   IF (schedule_name_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SCHEDULE_NAME', schedule_name_, attr_);
   END IF;

   IF (lang_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LANG_CODE', lang_code_, attr_);
   END IF;
   
   IF(stream_msg_on_completion_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STREAM_MSG_ON_COMPLETION_DB', stream_msg_on_completion_, attr_);
   END IF;
   
   IF(stream_notes_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STREAM_NOTES', stream_notes_, attr_);
   END IF;

   Client_SYS.Add_To_Attr('CHECK_EXECUTING_DB',check_executing_db_,attr_);
   Client_SYS.Add_To_Attr('QUEUE_ID', queue_id_, attr_);
   
   Batch_Schedule_API.Modify__ (info_, objid_, objversion_, attr_, 'DO');
   next_execution_date_ := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('NEXT_EXECUTION_DATE', attr_));
END Modify_Batch_Schedule;


PROCEDURE Modify_Batch_Schedule_Param (
   schedule_id_  IN NUMBER,
   seq_no_       IN NUMBER,
   name_         IN VARCHAR2,
   value_        IN VARCHAR2 )
IS
   newrec_ batch_schedule_par_tab%ROWTYPE;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Modify_Batch_Schedule_Param');
   newrec_.schedule_id := schedule_id_;
   newrec_.seq_no := seq_no_;
   newrec_.name := name_;
   newrec_.value := value_;
   Batch_Schedule_Par_API.Modify__ (newrec_);
END Modify_Batch_Schedule_Param;


PROCEDURE Modify_Batch_Schedule_Param (
   schedule_id_  IN NUMBER,
   seq_no_       IN NUMBER,
   name_         IN VARCHAR2,
   value_        IN DATE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Modify_Batch_Schedule_Param');
   Modify_Batch_Schedule_Param (schedule_id_, seq_no_, name_, to_char(value_, Client_SYS.date_format_));
END Modify_Batch_Schedule_Param;


PROCEDURE Modify_Batch_Schedule_Param (
   schedule_id_  IN NUMBER,
   seq_no_       IN NUMBER,
   name_         IN VARCHAR2,
   value_        IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Modify_Batch_Schedule_Param');
   Modify_Batch_Schedule_Param (schedule_id_, seq_no_, name_, to_char(value_));
END Modify_Batch_Schedule_Param;


PROCEDURE New_Batch_Queue (
   queue_id_            OUT    NUMBER,
   description_         IN     VARCHAR2,
   process_number_      IN     NUMBER,
   active_              IN     VARCHAR2,
   execution_plan_      IN     VARCHAR2,
   lang_code_           IN     VARCHAR2 )
IS
   queue_data_   Batch_Queue_Rec;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Batch_Queue');
   queue_data_.description    := description_;
   queue_data_.process_number := process_number_;
   queue_data_.active         := active_;
   queue_data_.execution_plan := execution_plan_;
   queue_data_.lang_code      := lang_code_;
   --
   New_Batch_Queue(queue_data_);
   -- Return the created Batch Queues QUEUE_ID
   queue_id_ := queue_data_.queue_id;
END New_Batch_Queue;

PROCEDURE New_Batch_Queue (
   queue_data_     IN OUT Batch_Queue_Rec )
IS
   attr_               VARCHAR2(2000);
   info_               VARCHAR2(2000);
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Batch_Queue');
   --
   Client_SYS.Add_To_Attr('DESCRIPTION', queue_data_.description, attr_);
   Client_SYS.Add_To_Attr('PROCESS_NUMBER', queue_data_.process_number, attr_);
   Client_SYS.Add_To_Attr('ACTIVE', queue_data_.active, attr_);
   Client_SYS.Add_To_Attr('EXECUTION_PLAN', queue_data_.execution_plan, attr_);
   Client_SYS.Add_To_Attr('LANG_CODE', queue_data_.lang_code, attr_);
   IF queue_data_.node_attached_db IS NOT NULL THEN
      Client_SYS.Add_To_Attr('NODE_ATTACHED_DB', queue_data_.node_attached_db, attr_);
   END IF;
   IF queue_data_.node IS NOT NULL THEN
      Client_SYS.Add_To_Attr('NODE', queue_data_.node, attr_);
   END IF;
   --
   Batch_Queue_API.Do_New__(info_, objid_, objversion_, attr_);
   -- Fetch the created Batch Queues QUEUE_ID
   queue_data_.queue_id := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('QUEUE_ID', attr_));
END New_Batch_Queue;

PROCEDURE New_Batch_Queue_Method (
   queue_id_            IN    NUMBER,
   method_name_         IN    VARCHAR2 )
IS
   attr_               VARCHAR2(2000);
   info_               VARCHAR2(2000);
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Batch_Queue_Method');
   Client_SYS.Add_To_Attr('QUEUE_ID', queue_id_, attr_);
   Client_SYS.Add_To_Attr('METHOD_NAME', method_name_, attr_);
   Batch_Queue_Method_API.New__(info_, objid_, objversion_, attr_, 'DO');
END New_Batch_Queue_Method;


PROCEDURE New_Batch_Schedule (
   schedule_id_            OUT    NUMBER,
   next_execution_date_    IN OUT DATE,
   start_date_             IN OUT DATE,
   stop_date_              IN     DATE,
   schedule_name_          IN     VARCHAR2,
   method_                 IN     VARCHAR2,
   active_db_              IN     VARCHAR2,
   execution_plan_         IN     VARCHAR2,
   lang_code_              IN     VARCHAR2 DEFAULT Nvl(Fnd_Session_API.Get_Language, 'en'),
   installation_id_        IN     VARCHAR2 DEFAULT NULL,
   external_id_            IN     VARCHAR2 DEFAULT NULL,
   check_executing_        IN     VARCHAR2 DEFAULT NULL, 
   stream_msg_on_completion_ IN VARCHAR2 DEFAULT 'FALSE',
   stream_notes_ IN VARCHAR2 DEFAULT NULL )
IS
   attr_               VARCHAR2(2000);
   info_               VARCHAR2(2000);
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
   schedule_method_id_ NUMBER;
   error_msg_ CONSTANT VARCHAR2(200) := Language_SYS.Translate_Constant(service_, 'SCHEDULENOTMETHOD: This method can not be used to schedule reports or chains.');
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Batch_Schedule');
   CASE upper(method_)
--      WHEN 'ARCHIVE_API.CREATE_AND_PRINT_REPORT__' THEN
--         Error_SYS.Appl_General(service_, error_msg_);
      WHEN 'BATCH_SCHEDULE_API.RUN_BATCH_SCHEDULE_CHAIN__' THEN
         Error_SYS.Appl_General(service_, error_msg_);
      ELSE
         null;
   END CASE;
   -- Get Next_Execution_data and Schedule_Method_Id
   Client_SYS.Add_To_Attr('NEXT_EXECUTION_DATE', nvl(next_execution_date_, Update_Exec_Time__(execution_plan_)), attr_);
   schedule_method_id_ := Batch_Schedule_Method_Api.Get_Schedule_Method_Id(method_);
   IF schedule_method_id_ IS NULL THEN
      Error_SYS.Appl_General(service_, 'METHODNOTEXISTERR: Method [:P1] must be registered as a batch schedule method.', method_);
   END IF;
   Client_SYS.Add_To_Attr('BATCH_SCHEDULE_TYPE_DB', 'TASK', attr_);
   Client_SYS.Add_To_Attr('START_DATE', start_date_, attr_);
   Client_SYS.Add_To_Attr('STOP_DATE', stop_date_, attr_);
   Client_SYS.Add_To_Attr('SCHEDULE_NAME', schedule_name_, attr_);
   Client_SYS.Add_To_Attr('ACTIVE_DB', active_db_, attr_);
   Client_SYS.Add_To_Attr('EXECUTION_PLAN', upper(execution_plan_), attr_);
   Client_SYS.Add_To_Attr('SCHEDULE_METHOD_ID', schedule_method_id_, attr_);
   Client_SYS.Add_To_Attr('LANG_CODE', NVL(lang_code_, NVL(Fnd_Session_API.Get_Language, 'en')), attr_);   
  
 
   IF installation_id_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('INSTALLATION_ID', installation_id_, attr_);
   END IF;
   Client_SYS.Add_To_Attr('CHECK_EXECUTING_DB', Nvl(check_executing_, Batch_Schedule_Method_API.Get_Check_Executing_Db(schedule_method_id_)), attr_);
   IF external_id_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('EXTERNAL_ID', external_id_, attr_);
   END IF;
   Client_SYS.Add_To_Attr('STREAM_MSG_ON_COMPLETION_DB', stream_msg_on_completion_, attr_);
   Client_SYS.Add_To_Attr('STREAM_NOTES', stream_notes_, attr_);
   Batch_Schedule_API.New__(info_, objid_, objversion_, attr_, 'DO');
   schedule_id_         := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SCHEDULE_ID', attr_));
   next_execution_date_ := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('NEXT_EXECUTION_DATE', attr_));
   start_date_          := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('START_DATE', attr_));
END New_Batch_Schedule;


PROCEDURE New_Batch_Schedule_Param (
   seq_no_      OUT NUMBER,
   schedule_id_  IN NUMBER,
   name_         IN VARCHAR2,
   value_        IN VARCHAR2 )
IS
   newrec_ batch_schedule_par_tab%ROWTYPE;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Batch_Schedule_Param');
   newrec_.schedule_id := schedule_id_;
   newrec_.name := name_;
   newrec_.value := value_;
   Batch_Schedule_Par_API.New__ (newrec_);
   seq_no_ := newrec_.seq_no;
END New_Batch_Schedule_Param;


PROCEDURE New_Batch_Schedule_Param (
   seq_no_      OUT NUMBER,
   schedule_id_  IN NUMBER,
   name_         IN VARCHAR2,
   value_        IN DATE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Batch_Schedule_Param');
   New_Batch_Schedule_Param (seq_no_, schedule_id_, name_, to_char(value_, Client_SYS.Date_Format_));
END New_Batch_Schedule_Param;


PROCEDURE New_Batch_Schedule_Param (
   seq_no_      OUT NUMBER,
   schedule_id_  IN NUMBER,
   name_         IN VARCHAR2,
   value_        IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Batch_Schedule_Param');
   New_Batch_Schedule_Param (seq_no_, schedule_id_, name_, to_char(value_));
END New_Batch_Schedule_Param;


PROCEDURE New_Batch_Schedule_Chain (
   schedule_id_            OUT    NUMBER,
   next_execution_date_    IN OUT DATE,
   start_date_             IN OUT DATE,
   stop_date_              IN     DATE,
   schedule_name_          IN     VARCHAR2,
   schedule_method_id_     IN     VARCHAR2,
   active_db_              IN     VARCHAR2,
   execution_plan_         IN     VARCHAR2,
   lang_code_              IN     VARCHAR2 DEFAULT Nvl(Fnd_Session_API.Get_Language, 'en'),
   installation_id_        IN     VARCHAR2 DEFAULT NULL,
   external_id_            IN     VARCHAR2 DEFAULT NULL,
   stream_msg_on_completion_ IN VARCHAR2 DEFAULT 'FALSE',
   stream_notes_ IN VARCHAR2 DEFAULT NULL,
   check_executing_db_ IN VARCHAR2 DEFAULT NULL,
   queue_id_           IN     NUMBER DEFAULT NULL)
IS
   attr_               VARCHAR2(2000);
   info_               VARCHAR2(2000);
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
   seq_no_             NUMBER;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Batch_Schedule_Chain');
   -- Check whether the schedule is a Report, Method or a Chain.
   Batch_Schedule_Chain_API.Exist(schedule_method_id_);
   Client_SYS.Add_To_Attr('BATCH_SCHEDULE_TYPE_DB', 'CHAIN', attr_);
   Client_SYS.Add_To_Attr('NEXT_EXECUTION_DATE', nvl(next_execution_date_, Update_Exec_Time__(execution_plan_)), attr_);
   Client_SYS.Add_To_Attr('START_DATE', start_date_, attr_);
   Client_SYS.Add_To_Attr('STOP_DATE', stop_date_, attr_);
   Client_SYS.Add_To_Attr('SCHEDULE_NAME', schedule_name_, attr_);
   Client_SYS.Add_To_Attr('ACTIVE_DB', active_db_, attr_);
   Client_SYS.Add_To_Attr('EXECUTION_PLAN', upper(execution_plan_), attr_);
   Client_SYS.Add_To_Attr('SCHEDULE_METHOD_ID', schedule_method_id_, attr_);
   Client_SYS.Add_To_Attr('LANG_CODE', lang_code_, attr_);
   Client_SYS.Add_To_Attr('CHECK_EXECUTING_DB', check_executing_db_, attr_);
   Client_SYS.Add_To_Attr('QUEUE_ID', queue_id_, attr_);
   IF installation_id_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('INSTALLATION_ID', installation_id_, attr_);
   END IF;
   IF external_id_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('EXTERNAL_ID', external_id_, attr_);
   END IF;
   Client_SYS.Add_To_Attr('CHECK_EXECUTING_DB',Nvl(check_executing_db_, Batch_Schedule_Chain_API.Get_Check_Executing_Db(schedule_method_id_)), attr_);
   Client_SYS.Add_To_Attr('STREAM_MSG_ON_COMPLETION_DB', stream_msg_on_completion_, attr_);
   Client_SYS.Add_To_Attr('STREAM_NOTES', stream_notes_, attr_);
   Batch_Schedule_API.New__(info_, objid_, objversion_, attr_, 'DO');
   schedule_id_         := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SCHEDULE_ID', attr_));
   next_execution_date_ := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('NEXT_EXECUTION_DATE', attr_));
   start_date_          := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('START_DATE', attr_));
   New_Batch_Schedule_Param(seq_no_, schedule_id_, 'SCHEDULE_ID_', schedule_id_);
END New_Batch_Schedule_Chain;


PROCEDURE New_Batch_Chain_Param (
   seq_no_      OUT NUMBER,
   schedule_id_  IN NUMBER,
   schedule_method_id_ IN NUMBER,
   step_no_      IN NUMBER,
   name_         IN VARCHAR2,
   value_        IN VARCHAR2 )
IS
   newrec_ batch_schedule_chain_par_tab%ROWTYPE;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Batch_Chain_Param');
   newrec_.schedule_id := schedule_id_;
   newrec_.schedule_method_id := schedule_method_id_;
   newrec_.step_no := step_no_;
   newrec_.name := name_;
   newrec_.value := value_;
   Batch_Schedule_Chain_Par_API.New__ (newrec_);
   seq_no_ := newrec_.seq_no;
END New_Batch_Chain_Param;


PROCEDURE New_Batch_Chain_Param (
   seq_no_      OUT NUMBER,
   schedule_id_  IN NUMBER,
   schedule_method_id_ IN NUMBER,
   step_no_      IN NUMBER,
   name_         IN VARCHAR2,
   value_        IN DATE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'New_Batch_Chain_Param');
   New_Batch_Chain_Param(seq_no_, schedule_id_, schedule_method_id_, step_no_, name_, to_char(value_, Client_SYS.Date_Format_));
END New_Batch_Chain_Param;


PROCEDURE New_Batch_Chain_Param (
   seq_no_      OUT NUMBER,
   schedule_id_  IN NUMBER,
   schedule_method_id_ IN NUMBER,
   step_no_      IN NUMBER,
   name_         IN VARCHAR2,
   value_        IN NUMBER )
IS
BEGIN
   New_Batch_Chain_Param(seq_no_, schedule_id_, schedule_method_id_, step_no_, name_, to_char(value_));
END New_Batch_Chain_Param;

PROCEDURE Register_Batch_Schedule (
   schedule_id_            OUT    NUMBER,
   next_execution_date_    IN OUT DATE,
   start_date_             IN OUT DATE,
   stop_date_              IN     DATE,
   schedule_name_          IN     VARCHAR2,
   method_                 IN     VARCHAR2,
   active_db_              IN     VARCHAR2,
   execution_plan_         IN     VARCHAR2,
   lang_code_              IN     VARCHAR2 DEFAULT Nvl(Fnd_Session_API.Get_Language, 'en'),
   installation_id_        IN     VARCHAR2 DEFAULT NULL,
   external_id_            IN     VARCHAR2 DEFAULT NULL,
   check_executing_        IN     VARCHAR2 DEFAULT NULL )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Register_Batch_Schedule');
   -- Register schedule
   next_execution_date_ := Update_Exec_Time__(execution_plan_);
   Batch_Schedule_API.Register__(schedule_id_, next_execution_date_, start_date_, stop_date_, schedule_name_, method_, active_db_, execution_plan_, lang_code_, installation_id_, external_id_, check_executing_);
END Register_Batch_Schedule;

PROCEDURE Register_Batch_Schedule_Param(
   seq_no_      OUT NUMBER,
   schedule_id_  IN NUMBER,
   name_         IN VARCHAR2,
   value_        IN VARCHAR2 )
IS
   newrec_ batch_schedule_par_tab%ROWTYPE;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Register_Batch_Schedule_Param');
   newrec_.schedule_id := schedule_id_;
   newrec_.name := name_;
   newrec_.value := value_;
   Batch_Schedule_Par_API.Register__ (newrec_);
   seq_no_ := newrec_.seq_no;
END Register_Batch_Schedule_Param;

PROCEDURE Register_Batch_Schedule_Method (
   schedule_method_id_ IN OUT NUMBER,
   info_msg_           IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Register_Batch_Schedule_Method');
   -- Register task
   Batch_Schedule_Method_API.Register__(schedule_method_id_, info_msg_);
END Register_Batch_Schedule_Method;


PROCEDURE Register_Schedule_Method_Param (
   seq_no_            OUT NUMBER,
   schedule_method_id_ IN NUMBER,
   name_               IN VARCHAR2,
   value_              IN VARCHAR2,
   mandatory_db_       IN VARCHAR2 DEFAULT 'TRUE',
   default_expression_ IN VARCHAR2 DEFAULT NULL )
IS
   sysdate_exp_prefix_ VARCHAR2(12):= '#SYSDATEEXP#';
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Register_Schedule_Method_Param');
   IF INSTR(value_, sysdate_exp_prefix_) > 0 THEN
      Assert_SYS.Assert_Is_Sysdate_Expression(SUBSTR(value_, 13));
      Register_Schedule_Meth_Par___(seq_no_,
                                    schedule_method_id_,
                                    name_,
                                    SUBSTR(value_, 13),
                                    mandatory_db_,
                                    default_expression_,
                                    'DATE' );
   ELSE
     Register_Schedule_Meth_Par___(seq_no_,
                                   schedule_method_id_,
                                   name_,
                                   value_,
                                   mandatory_db_,
                                   default_expression_,
                                   'STRING' );
   END IF;
END Register_Schedule_Method_Param;


PROCEDURE Register_Schedule_Method_Param (
   seq_no_            OUT NUMBER,
   schedule_method_id_ IN NUMBER,
   name_               IN VARCHAR2,
   value_              IN DATE,
   mandatory_db_       IN VARCHAR2 DEFAULT 'TRUE',
   default_expression_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Register_Schedule_Method_Param');
   Register_Schedule_Meth_Par___(seq_no_,
                                 schedule_method_id_,
                                 name_,
                                 to_char(value_, Client_SYS.Date_Format_),
                                 mandatory_db_,
                                 default_expression_,
                                 'DATE' );
END Register_Schedule_Method_Param;


PROCEDURE Register_Schedule_Method_Param (
   seq_no_            OUT NUMBER,
   schedule_method_id_ IN NUMBER,
   name_               IN VARCHAR2,
   value_              IN NUMBER,
   mandatory_db_       IN VARCHAR2 DEFAULT 'TRUE',
   default_expression_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Register_Schedule_Method_Param');
   Register_Schedule_Meth_Par___(seq_no_,
                                 schedule_method_id_,
                                 name_,
                                 to_char(value_),
                                 mandatory_db_,
                                 default_expression_,
                                 'NUMBER' );
END Register_Schedule_Method_Param;


PROCEDURE Register_Batch_Schedule_Chain (
   schedule_method_id_ IN OUT NUMBER,
   info_msg_           IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Register_Batch_Schedule_Chain');
   -- Register task
   Batch_Schedule_Chain_API.Register__(schedule_method_id_, info_msg_);
END Register_Batch_Schedule_Chain;


PROCEDURE Register_Schedule_Chain_Step (
   schedule_method_id_ IN OUT NUMBER,
   step_no_            IN NUMBER,
   info_msg_           IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Register_Schedule_Chain_Step');
   -- Register task
   Batch_Schedule_Chain_Step_API.Register__(schedule_method_id_, step_no_, info_msg_);
END Register_Schedule_Chain_Step;


PROCEDURE Remove_Batch_Schedule (
   schedule_id_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Remove_Batch_Schedule');
   Batch_Schedule_API.Remove_(schedule_id_);
END Remove_Batch_Schedule;


PROCEDURE Remove_Batch_Schedule_Param (
   schedule_id_  IN NUMBER,
   seq_no_       IN NUMBER )
IS

BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Remove_Batch_Schedule_Param');
   DELETE FROM batch_schedule_par_tab
   WHERE  schedule_id = schedule_id_
   AND    seq_no = seq_no_;
END Remove_Batch_Schedule_Param;


PROCEDURE Remove_Batch_Schedule_Chain (
   schedule_method_id_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR get_batch_schedule_chain IS
      SELECT objid, objversion
      FROM   batch_schedule_chain
      WHERE  schedule_method_id = schedule_method_id_;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Remove_Batch_Schedule_Chain');
   OPEN  get_batch_schedule_chain;
   FETCH get_batch_schedule_chain INTO objid_, objversion_;
   CLOSE get_batch_schedule_chain;
   Batch_Schedule_Chain_API.Remove__(info_, objid_, objversion_, 'DO' );
END Remove_Batch_Schedule_Chain;


PROCEDURE Remove_Batch_Sched_Chain_Step (
   schedule_method_id_ IN NUMBER,
   step_no_            IN NUMBER )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR get_batch_schedule_chain_step IS
      SELECT objid, objversion
      FROM   batch_schedule_chain_step
      WHERE  schedule_method_id = schedule_method_id_
      AND    step_no = step_no_;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Remove_Batch_Sched_Chain_Step');
   OPEN  get_batch_schedule_chain_step;
   FETCH get_batch_schedule_chain_step INTO objid_, objversion_;
   CLOSE get_batch_schedule_chain_step;
   Batch_Schedule_Chain_Step_API.Remove__(info_, objid_, objversion_, 'DO' );
END Remove_Batch_Sched_Chain_Step;

PROCEDURE Remove_Step_F_Batch_Sch_Chain (
   chain_schedule_method_id_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR get_batch_schedule_chain_step IS
      SELECT objid, objversion
      FROM   batch_schedule_chain_step
      WHERE  chain_schedule_method_id = chain_schedule_method_id_;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Remove_Step_F_Batch_Sch_Chain');
   OPEN  get_batch_schedule_chain_step;
   FETCH get_batch_schedule_chain_step INTO objid_, objversion_;
   WHILE get_batch_schedule_chain_step%FOUND LOOP
      Batch_Schedule_Chain_Step_API.Remove__(info_, objid_, objversion_, 'DO' );
      FETCH get_batch_schedule_chain_step INTO objid_, objversion_;
   END LOOP;
   CLOSE get_batch_schedule_chain_step;
END Remove_Step_F_Batch_Sch_Chain;

PROCEDURE Remove_Batch_Sched_Chain_Par (
   schedule_id_         IN NUMBER,
   schedule_method_id_  IN NUMBER,
   step_no_             IN NUMBER,
   seq_no_              IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Remove_Batch_Sched_Chain_Par');
   DELETE FROM batch_schedule_chain_par_tab
   WHERE  schedule_id = schedule_id_
   AND    schedule_method_id = schedule_method_id_
   AND    step_no = step_no_
   AND    seq_no = seq_no_;
END Remove_Batch_Sched_Chain_Par;


PROCEDURE Remove_Batch_Schedule_Method(
   method_name_ VARCHAR2)
IS
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Remove_Batch_Schedule_Method');
   Batch_Schedule_Method_Api.Remove_Method__(method_name_);
END Remove_Batch_Schedule_Method;


PROCEDURE Rem_Cascade_Batch_Schedule(
   schedule_id_ IN NUMBER)
IS
   CURSOR get_param IS
   SELECT s.seq_no
   FROM   batch_schedule_par_tab s
   WHERE  s.schedule_id = schedule_id_;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Rem_Cascade_Batch_Schedule');
   FOR rec_par IN get_param LOOP
      Remove_Batch_Schedule_Param (schedule_id_, rec_par.seq_no);
   END LOOP;
   IF (Batch_Schedule_Type_API.Encode(Batch_Schedule_API.Get_Batch_Schedule_Type(schedule_id_)) = Batch_Schedule_Type_API.DB_CHAIN) THEN
      DELETE FROM batch_schedule_chain_par_tab t WHERE t.schedule_id = schedule_id_;
   END IF;
   Remove_Batch_Schedule(schedule_id_);
END Rem_Cascade_Batch_Schedule;


PROCEDURE Rem_Cascade_Batch_Schedule_Met(
   method_name_ IN VARCHAR2)
IS
   schedule_method_id_  NUMBER := Batch_Schedule_Method_API.Get_Schedule_Method_Id(method_name_);
   
   CURSOR get_batch_schedule IS
   SELECT s.schedule_id, s.schedule_method_id
   FROM   batch_schedule_tab s
   WHERE  s.schedule_method_id = schedule_method_id_;
   
   CURSOR get_chain_step IS 
   SELECT schedule_method_id, step_no
   FROM   batch_schedule_chain_step_tab
   WHERE  chain_schedule_method_id = schedule_method_id_;
BEGIN
   General_SYS.Check_Security(service_, 'BATCH_SYS', 'Rem_Cascade_Batch_Schedule_Met');
   FOR rec IN get_batch_schedule LOOP
      Rem_Cascade_Batch_Schedule(rec.schedule_id);
   END LOOP;
   FOR rec2 IN get_chain_step LOOP
      Remove_Batch_Sched_Chain_Step(rec2.schedule_method_id, rec2.step_no);
   END LOOP;
   Remove_Batch_Schedule_Method(method_name_);
   Remove_Batch_Queue_Method___(method_name_);
END Rem_Cascade_Batch_Schedule_Met;

PROCEDURE Remove_Batch_Scheds_Per_Module(
   module_ IN VARCHAR2)
IS
   CURSOR get_methods IS
      SELECT method_name
      FROM   batch_schedule_method
      WHERE  module = module_;
BEGIN
   FOR rec_ IN get_methods LOOP
      Rem_Cascade_Batch_Schedule_Met(rec_.method_name);
   END LOOP;
END Remove_Batch_Scheds_Per_Module;

