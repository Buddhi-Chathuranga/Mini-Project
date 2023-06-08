-----------------------------------------------------------------------------
--
--  Logical unit: BatchSchedule
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  010525  HAAR  ToDo# 4018 - Created for general scheduling framework
--  010810  HAAR  Created new function New_Batch_schedule__, that is a copy of
--                New__ but it takes parameters as a varible not as an attribute string.
--                Parameter action_ is removed.
--                New_Batch_Schedule__ should only be used by BATCH_SYS.New_Batch_Schedule.
--  010822  ROOD  Moved public view BATCH_SCHEDULE_PUB to api-file (ToDo#4018).
--  010906  HAAR  Renamed column Description to Schedule_Name in Batch_Schedule (Todo#4018).
--                Added function Count_Schedule_Name.
--                Added Cleanup__ procedure.
--  010928  ROOD  Modified prompt for Schedule Name. Minor rearrangements (ToDo#4018).
--  020624  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  020808  HAAR  Use Get_Next_Exec_Time instead of Update_Exec_Time in
--                Update_Next_Execution_Date_ (Bug#30396).
--  020809  HAAR  Always return Next_Execution_Date from Insert___ and Update___ (Bug#25924).
--  021024  HAAR  Added Schedule_Method_Id and moved Method and Single_Execution to Batch_Schedule_Method (ToDo#4146).
--                Moved Method_Exist to Batch_Schedule_Method_API.
--  021104  HAAR  Made parameters updatable. Added procedure Modify_Batch_Schedule (ToDo#4146).
--  021213  HAAR  Minor changes in Check_Single_Execution___.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030819  ROOD  Removed access control on Is_Method_Available__ (ToDo#4160).
--  040119  HAAR  Insert___ and Update___ uses client values in comparison (Bug#42118).
--  040119  HAAR  Better checks on parameter parameters_ (Bug#42123).
--  040211  HAAR  Possibility to schedule reports as scheduled tasks (Bug#39376).
--                Run_Batch_Schedule__ for Online execution of Scheduled tasks.
--                Added Lang_Code and Executions.
--  040219  ROOD  Added check so only the owner of the scheduled task can delete it (Bug#39376).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  040429  HAAR  Corrected code in Run_Batch_Schedule__ so IFS Message as parameter works (Bug#44322).
--  040512  HAAR  Removed New_Batch_Schedule_Method__ and Modify_Batch_Schedule_Method__ (F1PR419).
--  040512  HAAR  Removed Parameters (F1PR419).
--  040614  HAAR  Added view Batch_Schedule_Report (F1PR419B).
--  040617  HAAR  Added attribute Installation_Id,
--                changed Count_Schedule_Name__ to Check_Installation_Id__ (F1PR419B).
--  040624  RAKU  Corrected BATCH_SCHEDULE_REPORT definition of Installation_Id (F1PR419B).
--  040929  HAAR  Corrected how to set Fnd_User in Run_Batch_Schedule__ (47195).
--                Added Check_Access___ method.
--  041011  ROOD  Added external_id and modified handling of reports (F1PR419).
--                Updated template and removed some unused variables and cursor.
--  041119  HAAR  Changed to use Fnd_Session_API.Set_Language (F1PR413E).
--  050615  HAAR  Changed Check_Access___ to use System privileges (F1PR483).
--  060726  NiWi  Changed Get_Parameters__ to allow sysdate and it's expressions ad values of format DATE(Bug#58975).
--  060912  NiWi  Changed Get_Parameters__ increased variable lengths.
--  061027  NiWi  'PROG' is not a registered language code and should not be a default(Bug#61340).
--  070122  HAAR  Made public Check_Exist from Check_Exist___ (F1PR458).
--  070125  PEMA  Added a missing annotation (Bug# 63159)
--  070212  NiWi  Modified Date_Check___ (Bug#63435)
--  070510  HAAR  Added logging for Scheduled tasks that will not start (Bug#65268).
--  071019  HAAR  Set Schedule_Id in Transaction_Sys_Local_Tab for tracability (Bug#68756).
--  081126  HASP  Correcetd Get_Parameters__ method to replace SYSDATE in rep_par_attr_ correctly.(Bug #77866)
--  091012  HAAR  Removed Transaction_SYS.Log_Global_Error_Text__ (EACS-193).
--  091025 UsRaLK Increased the support for BATCH_SCHEDULE_PAR_TAB.VALUE from 2000 to 4000. (Bug #86689)
--  100416  HAAR  Added Last_Execution_Date to Scheduled Tasks (Bug#90019).
--  110903  NaBa  Modified the BA report schedule to run offline when BA Execution Server is available (RDTERUNTIME-353)
--  110911  NaBa  Modified Update_Next_Execution_Date_ not to deactivate task when it has a recurring execution plan (RDTERUNTIME-854)
--  120126  MaBo  Added method Remove for deleting records in BatchSchedule on key (RDTERUNTIME-1967)
--  120218  USRA  Changed error message for INACTIVE_SCHEDULE (Bug#100790/RDTERUNTIME-1981).
--  121010  WaWi  Changed Update___ to not to update USERNAME (Bug#104689)
--  130213  DUWI  Called the procedure Validate_Execution_Plan__ (Bug#108116).
--  130312  USRA  Added [BATCH_SCHEDULE_TASK] and [Get_Translated_Execution_Plan] (Bug#107799).
--  130507  MADD  Removed exception in Update_Next_Execution_Date_ (Bug#109630).
--  130822  PGAN  Removed sheduled tasks reffered by SodCache,SearchDomainRuntime from Cleanup__ (Bug#109335).
--  140524  ASWI  Modified Update___ in order to not check Is_Method_Available__ if it is a deactivation of a schedule (Bug#116431 Merge).  
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--  Execution plan:
--                The term execution plan is used to describe when a job will
--                be executed. The execution plan is not case sensitive and time
--                is specified on minute level. Date and time formats are fixed,
--                as is date language (American). Note differences between the
--                format of the execution plan in Batch_SYS and the one used here.
--                To take advantage of the more extensive format available in
--                Batch_SYS, use methods specially dedicated to Batch Schedules
--                within Batch_SYS.
----------------------------------------------------------------------------
--                'ON <date> AT <time>'
--                   ; Execute one time, possibly on <date> at <time>, or if this
--                     time has expired, execute right now.
--                   'ON 1996-03-10 AT 11:30'
--                      ; Execute on mars 10 1996 at 11:30.
--                'WEEKLY ON <days> AT <times>'
--                   ; Feel free to mix days and times, at least one day and
--                     one time. Multipel days or times should be ';' separated
--                     There is a shortcut to every single
--                     day in week (every day, period) called 'DAILY'.
--                   'WEEKLY ON mon;thu AT 11:00;16:00'
--                      ; Execute on monday at 11:00, on monday at 16:00, on
--                        thursday at 11:00 and on thursday at 16:00, then
--                        repeat next week..
--                   'DAILY AT 09:30;12:00'
--                      ; Every day at 09:30 and 12:00.
--                'MONTHLY ON DAY <day number> AT <time>'
--                   ; Execute every month on specified day and time.
--                'EVERY 00:30'
--                   ; Execute every half hour. Time part must be at least one
--                     minute (00:01) and less than 24:00.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     batch_schedule_tab%ROWTYPE,
   newrec_ IN OUT batch_schedule_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (Validate_SYS.Is_Changed(oldrec_.execution_plan, newrec_.execution_plan, indrec_.execution_plan)) THEN
      Batch_SYS.Validate_Execution_Plan__(newrec_.execution_plan);
   END IF;
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
END Check_Common___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ACTIVE_DB', Fnd_Boolean_API.DB_TRUE, attr_);
   Client_SYS.Add_To_Attr('ACTIVE', Fnd_Boolean_API.Decode(Fnd_Boolean_API.DB_TRUE), attr_);
   Client_SYS.Add_To_Attr('NEXT_EXECUTION_DATE', SYSDATE, attr_);
   Client_SYS.Add_To_Attr('START_DATE', SYSDATE, attr_);
   Client_SYS.Add_To_Attr('EXECUTION_PLAN', 'DAILY AT 00:00', attr_);
   Client_SYS.Add_To_Attr('CHECK_EXECUTING_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('CHECK_EXECUTING', Fnd_Boolean_API.Decode(Fnd_Boolean_API.DB_FALSE), attr_);
   Client_SYS.Add_To_Attr('LANG_CODE', Fnd_Session_API.Get_Language, attr_);
   Client_SYS.Add_To_Attr('STREAM_MSG_ON_COMPLETION_DB', Fnd_Boolean_API.DB_FALSE,attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT BATCH_SCHEDULE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   -- Get public record form Batch_Schedule_Method
   batch_schedule_method_rec_   Batch_Schedule_Method_API.Public_Rec;
BEGIN
   --
   -- Add internal schedule id
   --
   IF Installation_SYS.Get_Installation_Mode THEN
      -- Skipping module active check to avoid problems at the installtion time.
      batch_schedule_method_rec_ := Batch_Schedule_Method_API.Get(newrec_.schedule_method_id, TRUE);
   ELSE
      batch_schedule_method_rec_ := Batch_Schedule_Method_API.Get(newrec_.schedule_method_id);
   END IF;
   
   newrec_.schedule_id := schedule_id_seq.nextval;
   Trace_SYS.Field ( 'Schedule Id', newrec_.schedule_id );
   Client_SYS.Add_To_Attr ( 'SCHEDULE_ID', newrec_.schedule_id, attr_ );
   -- Set Installation_Id to schedule_id if Installation_Id is not set.
   IF newrec_.installation_id IS NULL THEN
      newrec_.installation_id := to_char(newrec_.schedule_id);
      Client_SYS.Add_To_Attr ( 'INSTALLATION_ID', newrec_.installation_id, attr_ );
   END IF;
   -- Check_Executing to schedule_id if Installation_Id is not set.
   IF newrec_.check_executing IS NULL THEN
      newrec_.check_executing := Fnd_Boolean_API.DB_FALSE;
      Client_SYS.Add_To_Attr ( 'CHECK_EXECUTING_DB', newrec_.check_executing, attr_ );
   END IF;
   -- Set STREAM_MSG_ON_COMPLETION to DB_FALSE if NULL
   IF newrec_.stream_msg_on_completion IS NULL THEN
      newrec_.stream_msg_on_completion := Fnd_Boolean_API.DB_FALSE;
      Client_SYS.Add_To_Attr ( 'STREAM_MSG_ON_COMPLETION_DB', newrec_.stream_msg_on_completion, attr_ );
   END IF;
   newrec_.username := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr ( 'USERNAME', newrec_.username, attr_ );
   newrec_.modified_date := SYSDATE;
   Client_SYS.Add_To_Attr ( 'MODIFIED_DATE', newrec_.modified_date, attr_ );
   -- Check security for METHOD
   IF (newrec_.batch_schedule_type = 'CHAIN') THEN
      NULL; -- No check for chains
   ELSE
      IF Is_Method_Po_Available__(batch_schedule_method_rec_.method_name, batch_schedule_method_rec_.po_id) = 'FALSE' THEN
         Error_SYS.Record_General('BatchSchedule', 'SEC_INS: Must have the right to execute method [:P1] to be able to create a new batch schedule.', batch_schedule_method_rec_.Method_Name);
      END IF;
      -- Check Single execution
      IF batch_schedule_method_rec_.Single_Execution = 'TRUE' THEN
         IF (NOT Check_Single_Execution___(newrec_.schedule_method_id, NULL)) THEN
            Error_SYS.Record_General('BatchSchedule', 'SINGLEEX: Method [:P1] can not already exist as a scheduled job, when it should execute as a single job.', batch_schedule_method_rec_.Method_Name);
         END IF;
      END IF;
   END IF;
   -- Change start_date
   IF newrec_.start_date IS NULL THEN
      newrec_.start_date := Batch_SYS.Update_Exec_Time__(newrec_.execution_plan);
   END IF;
   -- Change next_execution_date
   IF newrec_.next_execution_date IS NULL THEN
      newrec_.next_execution_date := newrec_.start_date;
   END IF;
   -- Fix stop_date
   IF newrec_.stop_date IS NOT NULL THEN
      newrec_.stop_date := to_date(to_char(newrec_.stop_date, 'YYYY-MM-DD') || ' 23:59:59', 'YYYY-MM-DD HH24:MI:SS');
      -- Check if Stop Date is before Start Date
      IF newrec_.stop_date <= newrec_.start_date THEN
         Error_SYS.Record_General('BatchSchedule', 'STOPINTERR: Stop date must have a date set after the start date.');
      END IF; 
   END IF;
   -- Check date intervals
   IF newrec_.next_execution_date IS NOT NULL THEN
      IF newrec_.next_execution_date NOT BETWEEN nvl(newrec_.start_date, newrec_.next_execution_date - 1) AND
                                                 nvl(newrec_.stop_date,  newrec_.next_execution_date + 1) THEN
         Error_SYS.Record_General('BatchSchedule', 'NEXTINTERR: Next execution date must be between start date and stop date.');
      END IF;
   END IF;
   -- Set next_excution_date to null when schedule is inactive. Must be executed after control of next_execution_date
   IF newrec_.active = 'FALSE' THEN
      newrec_.next_execution_date := NULL;
   END IF;
   --
   Client_SYS.Add_To_Attr ('NEXT_EXECUTION_DATE', newrec_.next_execution_date, attr_ );
   Client_SYS.Add_To_Attr ('START_DATE', newrec_.start_date, attr_ );
   newrec_.executions := 0;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Appl_General(lu_name_, 'DUPINSERT: Scheduled Task with this name already exists [:P1]. Please enter unique name.', newrec_.schedule_name);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     BATCH_SCHEDULE_TAB%ROWTYPE,
   newrec_     IN OUT BATCH_SCHEDULE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   -- Get All public record from Batch_Schedule_Method
   batch_schedule_method_rec_  Batch_Schedule_Method_API.Public_Rec;
BEGIN
   IF Installation_SYS.Get_Installation_Mode THEN
      -- Skipping module active check to avoid problems at the installtion time.
      batch_schedule_method_rec_ := Batch_Schedule_Method_API.Get(newrec_.schedule_method_id, TRUE);
   ELSE
      batch_schedule_method_rec_ := Batch_Schedule_Method_API.Get(newrec_.schedule_method_id);
   END IF;
   -- Check if allowed to do changes
   Check_Access___(newrec_.schedule_id);
    -- Set STREAM_MSG_ON_COMPLETION to DB_FALSE if NULL
   IF newrec_.stream_msg_on_completion IS NULL THEN
      newrec_.stream_msg_on_completion := Fnd_Boolean_API.DB_FALSE;
      Client_SYS.Add_To_Attr ( 'STREAM_MSG_ON_COMPLETION_DB', newrec_.stream_msg_on_completion, attr_ );
   END IF;
   Client_SYS.Add_To_Attr ( 'USERNAME', oldrec_.username, attr_ );
   newrec_.modified_date := SYSDATE;
   Client_SYS.Add_To_Attr ( 'MODIFIED_DATE', newrec_.modified_date, attr_ );
   -- Check security for METHOD
   IF newrec_.batch_schedule_type = 'CHAIN' THEN
      NULL; -- No check for chains
   ELSE
      IF Is_Method_Po_Available__(batch_schedule_method_rec_.method_name, batch_schedule_method_rec_.po_id) = 'FALSE' AND NOT(oldrec_.active = 'TRUE' AND newrec_.active = 'FALSE') THEN
         Error_SYS.Record_General('BatchSchedule', 'SEC_UPD: Must have the right to execute method [:P1] to be able to modify a batch schedule.', batch_schedule_method_rec_.Method_Name);
      END IF;
      -- Check Single execution
      IF batch_schedule_method_rec_.Single_Execution = 'TRUE' THEN
         IF (NOT Check_Single_Execution___(newrec_.schedule_method_id, objid_)) THEN
            Error_SYS.Record_General('BatchSchedule', 'SINGLEEX2: Schedule for Method [:P1] already exist and cannot be added, when it should execute as a single job.', batch_schedule_method_rec_.Method_Name);
         END IF;
      END IF;
   END IF;
   -- Set next_excution_date to null when schedule is inactive.
   IF newrec_.active = 'FALSE' THEN
      newrec_.next_execution_date := NULL;
   ELSE
      -- Change start_date
      IF newrec_.start_date IS NULL THEN
         newrec_.start_date := Batch_SYS.Update_Exec_Time__(newrec_.execution_plan);
      END IF;
      -- Change next_execution_date if execution_plan is changed
      IF (newrec_.next_execution_date IS NULL) AND (newrec_.execution_plan IS NOT NULL) OR
         (newrec_.execution_plan != oldrec_.execution_plan) THEN
         newrec_.next_execution_date := Batch_SYS.Update_Exec_Time__(newrec_.execution_plan);
         IF (newrec_.start_date > newrec_.next_execution_date) THEN
            newrec_.start_date := newrec_.next_execution_date;
         END IF;
      END IF;
      -- Change next_execution_date
      IF newrec_.next_execution_date IS NULL THEN
         newrec_.next_execution_date := newrec_.start_date;
      END IF;
      -- Fix stop_date
      IF newrec_.stop_date IS NOT NULL THEN
         newrec_.stop_date := to_date(to_char(newrec_.stop_date, 'YYYY-MM-DD') || ' 23:59:59', 'YYYY-MM-DD HH24:MI:SS');
         -- Check if Stop Date is before Start Date
         IF newrec_.stop_date <= newrec_.start_date THEN
            Error_SYS.Record_General('BatchSchedule', 'STOPINTERR: Stop date must have a date set after the start date.');
         END IF;       
      END IF;
      -- Check date intervals
      IF newrec_.next_execution_date IS NOT NULL THEN
         IF newrec_.next_execution_date NOT BETWEEN nvl(newrec_.start_date, newrec_.next_execution_date - 1) AND
                                                     nvl(newrec_.stop_date,  newrec_.next_execution_date + 1) THEN
            Error_SYS.Record_General('BatchSchedule', 'NEXTINTERR: Next execution date must be between start date and stop date.');
         END IF;
      END IF;
   END IF;
   Client_SYS.Add_To_Attr ('NEXT_EXECUTION_DATE', newrec_.next_execution_date, attr_ );
   Client_SYS.Add_To_Attr ('START_DATE', newrec_.start_date, attr_ );
   newrec_.executions := nvl(newrec_.executions, 0);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Appl_General(lu_name_, 'DUPINSERT: Scheduled Task with this name already exists [:P1]. Please enter unique name.', newrec_.schedule_name);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN BATCH_SCHEDULE_TAB%ROWTYPE )
IS
BEGIN
   -- Verify that this user actually owns this Batch Schedule
   -- Check if allowed to do changes
   Check_Access___(remrec_.schedule_id);
   -- Warn the user if the task was initiatded upon installation/upgrade.
   IF (Nvl(remrec_.installation_id,to_char(remrec_.schedule_id))  != to_char(remrec_.schedule_id)) THEN
      Client_SYS.Add_Warning('BatchSchedule', 'DELETEWARNING: Deleting a system defined scheduled task might have a severe impact on the system. Are you sure you want to delete the scheduled task?');
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN BATCH_SCHEDULE_TAB%ROWTYPE )
IS
BEGIN
   -- Check if allowed to do changes
   Check_Access___(remrec_.schedule_id);
   super(objid_, remrec_);
END Delete___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Access___ (
   schedule_id_ IN NUMBER )
IS
   CURSOR get_user IS
      SELECT username
      FROM BATCH_SCHEDULE_TAB
      WHERE schedule_id = schedule_id_;

   username_ VARCHAR2(30);
   fnd_user_ CONSTANT VARCHAR2(30):= Fnd_Session_API.Get_Fnd_User;
BEGIN
   OPEN  get_user;
   FETCH get_user INTO username_;
   CLOSE get_user;
   IF (fnd_user_ != username_ AND
       NOT Security_SYS.Has_System_Privilege('ADMINISTRATOR', fnd_user_)) THEN
      Error_SYS.Record_General(lu_name_, 'NOTBYME: You are not allowed change this Scheduled Task [:P1], since it was not scheduled by you.', schedule_id_);
   END IF;
END Check_Access___;

FUNCTION Check_Single_Execution___ (
   schedule_method_id_ IN NUMBER,
   objid_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR get_id IS
   SELECT 1
   FROM   batch_schedule
   WHERE  schedule_method_id = schedule_method_id_;
   CURSOR get_id2 IS
   SELECT 1
   FROM   batch_schedule
   WHERE  schedule_method_id = schedule_method_id_
   AND    objid != objid_;
BEGIN
   IF objid_ IS NULL THEN
      FOR rec IN get_id LOOP
         RETURN(FALSE);
      END LOOP;
   ELSE
      FOR rec IN get_id2 LOOP
         RETURN(FALSE);
      END LOOP;
   END IF;
   RETURN(TRUE);
END Check_Single_Execution___;

PROCEDURE Submit_Report___ (
   report_id_        IN VARCHAR2,
   method_name_      IN VARCHAR2,
   lang_code_        IN VARCHAR2,
   argument_type_db_ IN VARCHAR2,
   parameters_       IN VARCHAR2,
   description_      IN VARCHAR2,
   schedule_id_      IN NUMBER,
  stream_msg_on_completion_  VARCHAR2,
   stream_notes_ VARCHAR2)
IS
   report_method_ VARCHAR2(61);
   queue_id_      NUMBER;
   id_            NUMBER;
BEGIN
   -- Get report method
   report_method_ := Report_Definition_API.Get_Method(report_id_);
   -- Fetch Batch Queue for report
   queue_id_ := Batch_SYS.Get_Batch_Queue_For_Method_(report_method_, lang_code_);
   IF (queue_id_ IS NOT NULL) THEN
      Transaction_SYS.Deferred_Call(id_               => id_,
                                    procedure_name_   => method_name_,
                                    argument_type_db_ => argument_type_db_,
                                    arguments_        => parameters_,
                                    description_      => description_,
                                    queue_id_         => queue_id_,
                                    stream_msg_on_completion_ =>stream_msg_on_completion_,
                                    stream_notes_=> stream_notes_);
   ELSE
      -- If not finding any Batch Queue, submit the job as usual
      Transaction_SYS.Deferred_Call(id_,
                                    method_name_,
                                    argument_type_db_,
                                    parameters_,
                                    description_,
                                    stream_msg_on_completion_ =>stream_msg_on_completion_,
                                    stream_notes_=> stream_notes_);
   END IF;
   Transaction_SYS.Update_Schedule_Id__(id_, schedule_id_);
   Update_Next_Execution_Date_(schedule_id_);
END Submit_Report___;

FUNCTION Is_Excel_Report___ (
   schedule_id_ IN NUMBER) RETURN BOOLEAN
IS
   CURSOR get_parameters IS
      SELECT p.name, p.value
        FROM batch_schedule_par_tab p
       WHERE p.schedule_id = schedule_id_;
   report_attr_ VARCHAR2(2000);
   report_id_ VARCHAR2(100);
BEGIN
   FOR rec_ IN get_parameters LOOP
      IF rec_.name = 'REPORT_ATTR' THEN
        report_attr_ := rec_.value;
        report_id_ := Client_SYS.Get_Item_Value('REPORT_ID',report_attr_);
        IF (Report_Definition_API.Get_Report_Mode(report_id_)= 'EXCEL1.0') THEN
           RETURN TRUE;
        ELSE
           RETURN FALSE;
        END IF;
      END IF;
   END LOOP;
   RETURN FALSE;
END Is_Excel_Report___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Parse_Execution_Plan__ (
   schedule_id_  IN NUMBER,
   attr_ IN OUT VARCHAR2)
IS
   execution_plan_ VARCHAR2(255); 
   new_execution_plan_ VARCHAR2(255);
   schedule_option_ VARCHAR2(255);
   schedule_date_ TIMESTAMP;
   temp_ VARCHAR2(50);
   temp_week_days_ VARCHAR2(100);
   temp_hrs_  NUMBER;
   temp_mins_ NUMBER; 
   
BEGIN
   IF (Client_SYS.Item_Exist('SCHEDULE_OPTION_DB', attr_) OR Client_SYS.Item_Exist('SCHEDULE_TIME', attr_)
      OR Client_SYS.Item_Exist('SCHEDULED_DAYS_DB', attr_) OR Client_SYS.Item_Exist('SCHEDULED_DAY_NUMBER', attr_)
      OR Client_SYS.Item_Exist('SCHEDULE_DATETIME', attr_) OR Client_SYS.Item_Exist('SCHEDULE_INTERVAL', attr_) OR Client_SYS.Item_Exist('EXECUTION_PLAN', attr_)) THEN
      execution_plan_ := Batch_Schedule_API.Get_Execution_Plan(schedule_id_);
       IF (Client_SYS.Item_Exist('SCHEDULE_OPTION_DB', attr_)) THEN
         schedule_option_ := Client_SYS.Get_Item_Value('SCHEDULE_OPTION_DB', attr_);
         attr_ := Client_SYS.Remove_Attr('SCHEDULE_OPTION_DB', attr_);
      ELSE
         schedule_option_ := Batch_Schedule_API.Get_Current_Schedule_Option(execution_plan_);
      END IF;
      -- Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'schedule_option is '|| schedule_option_);
      IF (schedule_option_ = 'DAILY') THEN
         new_execution_plan_ := 'DAILY AT ';
         IF (Client_SYS.Item_Exist('SCHEDULE_TIME', attr_)) THEN
            IF (Client_SYS.Get_Item_Value_To_Date('SCHEDULE_TIME', attr_,'BatchSchedule') IS NULL) THEN
               Error_SYS.Appl_General('BatchSchedule', 'NO_VAL: Schedule is not properly filled');
            END IF;
            new_execution_plan_ := new_execution_plan_ || TO_CHAR(Client_SYS.Get_Item_Value_To_Date('SCHEDULE_TIME', attr_,'BatchSchedule'),'HH24:MI');
            attr_ := Client_SYS.Remove_Attr('SCHEDULE_TIME', attr_);
         ELSE
            IF (Batch_Schedule_API.Get_Schedule_Time(execution_plan_) IS NOT NULL) THEN
               new_execution_plan_ := new_execution_plan_ || TO_CHAR(Batch_Schedule_API.Get_Schedule_Time(execution_plan_), 'HH24:MI');
            ELSE
               Error_SYS.Appl_General('BatchSchedule', 'NO_VAL: Schedule is not properly filled');
            END IF;            
         END IF;
         -- Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'new_execution_plan_ is '|| new_execution_plan_);
      ELSIF (schedule_option_ = 'WEEKLY') THEN
         new_execution_plan_ := 'WEEKLY ON ';
         IF (Client_SYS.Item_Exist('SCHEDULED_DAYS_DB', attr_)) THEN
            temp_week_days_ := Client_SYS.Get_Item_Value('SCHEDULED_DAYS_DB', attr_);
            temp_week_days_:=REPLACE(SUBSTR(temp_week_days_, 1, length(temp_week_days_)-1),'^',';');
            new_execution_plan_ := new_execution_plan_ || temp_week_days_; 
            attr_ := Client_SYS.Remove_Attr('SCHEDULED_DAYS_DB', attr_);
         ELSE
            IF (Batch_Schedule_API.Get_Scheduled_Days(execution_plan_) IS NOT NULL) THEN
               new_execution_plan_ := new_execution_plan_ || Batch_Schedule_API.Get_Scheduled_Days(execution_plan_);
            ELSE
               Error_SYS.Appl_General('BatchSchedule', 'NO_VAL: Schedule is not properly filled');
            END IF;
         END IF;
         
         new_execution_plan_ := new_execution_plan_ || ' AT ';
         IF (Client_SYS.Item_Exist('SCHEDULE_TIME', attr_)) THEN
            new_execution_plan_ := new_execution_plan_ || TO_CHAR(Client_SYS.Get_Item_Value_To_Date('SCHEDULE_TIME', attr_,'BatchSchedule'),'HH24:MI');
            attr_ := Client_SYS.Remove_Attr('SCHEDULE_TIME', attr_);
         ELSE
            IF (Batch_Schedule_API.Get_Schedule_Time(execution_plan_) IS NOT NULL) THEN
               new_execution_plan_ := new_execution_plan_ || TO_CHAR(Batch_Schedule_API.Get_Schedule_Time(execution_plan_),'HH24:MI');
            ELSE
               Error_SYS.Appl_General('BatchSchedule', 'NO_VAL: Schedule is not properly filled');
            END IF;
            
         END IF;
      ELSIF (schedule_option_ = 'MONTHLY') THEN
         new_execution_plan_ := 'MONTHLY ON DAY ';
         IF (Client_SYS.Item_Exist('SCHEDULED_DAY_NUMBER', attr_)) THEN            
            IF (Client_SYS.Get_Item_Value_To_Number('SCHEDULED_DAY_NUMBER', attr_,'BatchSchedule') <= 31 ) THEN
               new_execution_plan_ := new_execution_plan_ || Client_SYS.Get_Item_Value('SCHEDULED_DAY_NUMBER', attr_);
               attr_ := Client_SYS.Remove_Attr('SCHEDULED_DAY_NUMBER', attr_);
            ELSE
               Error_SYS.Appl_General('BatchSchedule', 'INVALID_DAY: Invalid Day number');
            END IF;
         ELSE
            IF (Batch_Schedule_API.Get_Scheduled_Day_Number(execution_plan_) IS NOT NULL) THEN
               new_execution_plan_ := new_execution_plan_ || Batch_Schedule_API.Get_Scheduled_Day_Number(execution_plan_);
            ELSE
               Error_SYS.Appl_General('BatchSchedule', 'NO_VAL: Schedule is not properly filled');
            END IF;            
            
         END IF;
         new_execution_plan_ := new_execution_plan_ || ' AT ';
         IF (Client_SYS.Item_Exist('SCHEDULE_TIME', attr_)) THEN
            new_execution_plan_ := new_execution_plan_ || TO_CHAR(Client_SYS.Get_Item_Value_To_Date('SCHEDULE_TIME', attr_,'BatchSchedule'),'HH24:MI');
            attr_ := Client_SYS.Remove_Attr('SCHEDULE_TIME', attr_);
         ELSE
            IF (Batch_Schedule_API.Get_Schedule_Time(execution_plan_) IS NOT NULL) THEN
               new_execution_plan_ := new_execution_plan_ || TO_CHAR(Batch_Schedule_API.Get_Schedule_Time(execution_plan_), 'HH24:MI');
            ELSE
               Error_SYS.Appl_General('BatchSchedule', 'NO_VAL: Schedule is not properly filled');
            END IF;            
         END IF;
      ELSIF (schedule_option_ = 'SCHEDULED') THEN
         new_execution_plan_ := 'ON ';
         IF (Client_SYS.Item_Exist('SCHEDULE_DATETIME', attr_)) THEN
            IF (Client_SYS.Get_Item_Value_To_Date('SCHEDULE_DATETIME', attr_,'BatchSchedule') IS NULL) THEN
               Error_SYS.Appl_General('BatchSchedule', 'NO_VAL: Schedule is not properly filled');
            END IF;
            schedule_date_ := Client_SYS.Get_Item_Value_To_Date('SCHEDULE_DATETIME', attr_, 'BatchSchedule');
         ELSE
            schedule_date_ := Batch_Schedule_API.Get_Schedule_Time(execution_plan_);
            IF schedule_date_ IS NULL THEN
               Error_SYS.Appl_General('BatchSchedule', 'NO_VAL: Schedule is not properly filled');
            END IF;
         END IF;
         new_execution_plan_ := new_execution_plan_ || TO_CHAR(schedule_date_, 'YYYY-MM-DD');
         new_execution_plan_ := new_execution_plan_ || ' AT ' || TO_CHAR(schedule_date_, 'HH24:MI');
      ELSIF (schedule_option_ = 'INTERVAL') THEN
         new_execution_plan_ := 'EVERY ';
         IF (Client_SYS.Item_Exist('SCHEDULE_INTERVAL', attr_)) THEN
            temp_ := Client_SYS.Get_Item_Value('SCHEDULE_INTERVAL', attr_);
            IF (REGEXP_INSTR (temp_, '([[:digit:]])|([[:digit:]][[:digit:]]):([[:digit:]])|([[:digit:]][[:digit:]])')=1) THEN

               IF (REGEXP_LIKE(SUBSTR(temp_,1,INSTR(temp_,':')-1),'^[[:digit:]]+$') AND REGEXP_LIKE(SUBSTR(temp_,INSTR(temp_,':')+1),'^[[:digit:]]+$')) THEN
                  temp_hrs_ := to_number(SUBSTR(temp_,1,INSTR(temp_,':')-1));
                  temp_mins_ :=to_number(SUBSTR(temp_,INSTR(temp_,':')+1));
                  IF NOT ((temp_hrs_ >= 0 AND temp_hrs_ <= 23) AND (temp_mins_ >= 0 AND temp_mins_ <= 59)) THEN
                     Error_SYS.Appl_General('BatchSchedule', 'INTERVAL_ERROR: Time interval requires a value greater than 00:00 and less than 23:59');
                  END IF;
               ELSE
                  Error_SYS.Appl_General('BatchSchedule', 'FORMAT_ERROR: Schedule interval is invalid.');
               END IF; 
               new_execution_plan_ := new_execution_plan_ || temp_;            
               attr_ := Client_SYS.Remove_Attr('SCHEDULE_INTERVAL', attr_);
            ELSE
              Error_SYS.Appl_General('BatchSchedule', 'FORMAT_ERROR: Schedule interval is invalid.');
            END IF;
         ELSE
            IF (Batch_Schedule_API.Get_Schedule_Interval(execution_plan_) IS NOT NULL) THEN
               new_execution_plan_ := new_execution_plan_ || Batch_Schedule_API.Get_Schedule_Interval(execution_plan_);
            ELSE
               Error_SYS.Appl_General('BatchSchedule', 'NO_VAL: Schedule is not properly filled');
            END IF; 
            
         END IF;
      ELSIF (schedule_option_ = 'CUSTOM') THEN
         new_execution_plan_ := Client_SYS.Get_Item_Value('EXECUTION_PLAN', attr_);
         Batch_sys.Check_Batch_Sched_Cust_Expr__(new_execution_plan_);
         IF (new_execution_plan_ IS NULL) THEN
            Error_SYS.Appl_General('BatchSchedule', 'NO_VAL: Schedule is not properly filled');
         END IF;
      END IF;
      Client_SYS.Set_Item_Value('EXECUTION_PLAN', new_execution_plan_, attr_);
   END IF;
END Parse_Execution_Plan__;

PROCEDURE Activate__ (
   schedule_id_ IN NUMBER )
IS
   info_       VARCHAR2(32000);
   objid_      VARCHAR2(100)  ;
   objversion_ VARCHAR2(100)  ;
   attr_       VARCHAR2(200);
BEGIN
   -- Check if allowed to do changes
   Check_Access___(schedule_id_);
   Get_Id_Version_By_Keys___ (objid_, objversion_, schedule_id_);
   Client_SYS.Add_To_Attr('ACTIVE_DB', 'TRUE', attr_);
   Modify__ (info_, objid_, objversion_, attr_, 'DO');
END Activate__;

PROCEDURE Cleanup__
IS
   cleanup_days_ NUMBER := to_number(Fnd_Setting_API.Get_Value('KEEP_BATCH_SCHEDULE'));
   CURSOR schedule_ids IS
   SELECT schedule_id
     FROM batch_schedule_tab
    WHERE active = 'FALSE'
          AND Nvl(stop_date, modified_date) <= ( SYSDATE - cleanup_days_ )
          AND schedule_id NOT IN (SELECT cache_task_ref AS sched_id
                                    FROM sod_cache_tab);
BEGIN
   FOR schedule_id_rec IN schedule_ids
   LOOP
      Batch_Sys.Remove_Batch_Schedule(schedule_id_rec.schedule_id);
   END LOOP;
END Cleanup__;

@UncheckedAccess
FUNCTION Check_Installation_Id__ (
   installation_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   schedule_id_   NUMBER := 0;

   CURSOR get_schedule_id IS
   SELECT schedule_id
   FROM   batch_schedule_tab
   WHERE  installation_id = installation_id_;
BEGIN
   OPEN  get_schedule_id;
   FETCH get_schedule_id INTO schedule_id_;
   CLOSE get_schedule_id;
   RETURN (schedule_id_);
END Check_Installation_Id__;


PROCEDURE Deactivate__ (
   schedule_id_ IN NUMBER )
IS
   info_       VARCHAR2(32000);
   objid_      VARCHAR2(100)  ;
   objversion_ VARCHAR2(100)  ;
   attr_       VARCHAR2(200);
BEGIN
   -- Check if allowed to do changes
   Check_Access___(schedule_id_);
   Get_Id_Version_By_Keys___ (objid_, objversion_, schedule_id_);
   Client_SYS.Add_To_Attr('ACTIVE_DB', 'FALSE', attr_);
   Modify__ (info_, objid_, objversion_, attr_, 'DO');
END Deactivate__;

FUNCTION Get_Parameters__ (
   schedule_id_      IN NUMBER,
   argument_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_parameters(sched_method_id_ IN NUMBER) IS
      SELECT p.name, p.value, m.data_type
      FROM   batch_schedule_par_tab p, batch_schedule_tab b,
             batch_schedule_method_par_tab m
      WHERE  p.schedule_id = schedule_id_
      AND    p.schedule_id = b.schedule_id
      AND    b.schedule_method_id = m.schedule_method_id
      AND    p.name = m.name
      UNION
      SELECT p.name, p.value, m.data_type
      FROM   batch_schedule_par_tab p, batch_schedule_tab b,
             batch_schedule_method_par_tab m
      WHERE  p.schedule_id = schedule_id_
      AND    p.schedule_id = b.schedule_id
      AND    sched_method_id_ = m.schedule_method_id
      AND    p.name = m.name;

   value_              VARCHAR2(4000);
   parameters_         VARCHAR2(32000);
   rep_par_type_       VARCHAR2(10);
   rep_par_attr_       VARCHAR2(32000);
   ptr_                NUMBER;
   par_name_           VARCHAR2(30);
   par_value_          VARCHAR2(4000);
   new_par_value_      VARCHAR2(4000);
   schedule_method_id_ NUMBER;

   CURSOR get_rep_par_type IS
      SELECT c.column_type
      FROM  batch_schedule_tab a,
            batch_schedule_method_tab b,
            report_sys_column_tab c
      WHERE a.schedule_id = schedule_id_
      AND   a.schedule_method_id = b.schedule_method_id
      AND   UPPER(b.method_name) = 'ARCHIVE_API.CREATE_AND_PRINT_REPORT__'
      AND   a.external_id = c.report_id
      AND   c.column_name = par_name_;

   FUNCTION Date_Check___ (
      value_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      date_        DATE;
      date_format_ VARCHAR2(50) := Client_SYS.date_format_;
      stmt_        VARCHAR2(2000);
   BEGIN
      IF INSTR(UPPER(value_), 'SYSDATE')>0 THEN
         Assert_SYS.Assert_Is_Sysdate_Expression(value_);
         stmt_ := 'BEGIN :date := '||value_||'; END;';
         @ApproveDynamicStatement(2007-01-25,pemase)
         EXECUTE IMMEDIATE stmt_ USING OUT date_;
         RETURN(to_char(date_, date_format_));
      ELSE
         date_ := to_date(value_, date_format_);
         RETURN(to_char(date_, date_format_));
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         Error_SYS.Appl_General(lu_name_, 'INVALID_SYSDATE_EXP: ":P1" is not a valid date expression.', value_ );
   END Date_Check___;

BEGIN
   IF (argument_type_db_ = 'MESSAGE') THEN
      parameters_ := Message_SYS.Construct('');
   END IF;
   schedule_method_id_ := Batch_Schedule_Method_API.Get_Schedule_Method_Id('BATCH_SCHEDULE_CHAIN_API.RUN_BATCH_SCHEDULE_CHAIN__');
   FOR rec IN get_parameters(schedule_method_id_) LOOP
      value_ := Context_Substitution_Var_Api.Replace_Variable(rec.value);
      IF (rec.data_type = 'DATE') THEN
         value_ := Date_Check___(value_);
      ELSIF rec.name = 'PARAMETER_ATTR' THEN
         rep_par_attr_ := value_;
         ptr_ := NULL;
         WHILE Client_SYS.Get_Next_From_Attr(rep_par_attr_, ptr_, par_name_, par_value_) LOOP
            new_par_value_ := NULL;
            IF INSTR(UPPER(par_value_), 'SYSDATE')>0 THEN
               OPEN get_rep_par_type;
               FETCH get_rep_par_type INTO rep_par_type_;
               CLOSE get_rep_par_type;
               IF rep_par_type_ = 'DATE' THEN
                  new_par_value_ := Date_Check___(par_value_);
               END IF;
               IF new_par_value_ <> par_value_ THEN
                  Client_SYS.Set_Item_Value(par_name_, new_par_value_, value_);
               END IF;
            END IF;
         END LOOP;
      END IF;

      IF (argument_type_db_ = 'MESSAGE') THEN
         Message_SYS.Add_Attribute(parameters_, rec.name, value_);
      ELSIF (argument_type_db_ = 'ATTRIBUTE') THEN
         -- Convert to an attribute string
         Client_SYS.Add_To_Attr(rec.name, value_, parameters_);
      ELSIF (argument_type_db_ = 'PARAMETER') THEN
         -- Convert to an attribute string
         Client_SYS.Add_To_Attr(rec.name, value_, parameters_);
      END IF;
   END LOOP;
   RETURN(parameters_);
END Get_Parameters__;

PROCEDURE Register__(
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
   check_executing_        IN     VARCHAR2 DEFAULT NULL
   )
IS
   schedule_method_id_ NUMBER;
   attr_               VARCHAR2(2000);
   info_               VARCHAR2(2000);
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
   error_msg_ CONSTANT VARCHAR2(200) := Language_SYS.Translate_Constant(lu_name_, 'SCHEDULENOTMETHOD: This method can not be used to schedule reports or chains.');
   
   CURSOR get_schedule_info IS
   SELECT schedule_id, start_date
   FROM   batch_schedule_tab
   WHERE  schedule_method_id = schedule_method_id_;  
   
BEGIN
   IF upper(method_) = 'BATCH_SCHEDULE_API.RUN_BATCH_SCHEDULE_CHAIN__' THEN
         Error_SYS.Appl_General(lu_name_, error_msg_);
   END IF;    
   schedule_method_id_ := Batch_Schedule_Method_Api.Get_Schedule_Method_Id(method_);
   IF schedule_method_id_ IS NULL THEN
      Error_SYS.Appl_General(lu_name_, 'METHODNOTEXISTERR: Method [:P1] must be registered as a batch schedule method.', method_);
   END IF;  
   -- Check if installation id already exist
   IF Check_Installation_Id__(installation_id_) = 0 THEN      
      -- Check if schedule with single execution already exist 
      IF Batch_Schedule_Method_API.Get_Single_Execution_Db(schedule_method_id_) = 'TRUE' THEN      
         IF NOT Check_Single_Execution___(schedule_method_id_, NULL) THEN         
            -- Get the out parameters from the existing schedule
            FOR rec_ IN get_schedule_info LOOP
               schedule_id_ := rec_.schedule_id;
               start_date_  := rec_.start_date; 
               -- Exit without any changes         
               RETURN;
            END LOOP;                  
         END IF;       
      END IF;
      Client_SYS.Add_To_Attr('NEXT_EXECUTION_DATE', next_execution_date_, attr_);
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

      New__(info_, objid_, objversion_, attr_, 'DO');

      schedule_id_         := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SCHEDULE_ID', attr_));
      next_execution_date_ := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('NEXT_EXECUTION_DATE', attr_));
      start_date_          := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('START_DATE', attr_));
   ELSE
      -- Get the out parameters from the existing schedule
      FOR rec_ IN get_schedule_info LOOP
         schedule_id_ := rec_.schedule_id;
         start_date_  := rec_.start_date; 
      END LOOP;
   END IF;
END Register__;

@UncheckedAccess
FUNCTION Is_Method_Po_Available__ (
   method_name_      IN VARCHAR2,
   pres_object_id_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Batch_Schedule_Method_API.Is_Method_Po_Available__(method_name_, pres_object_id_));
END Is_Method_Po_Available__;

PROCEDURE Remove_Parameters__ (
   schedule_id_ IN NUMBER )
IS
BEGIN
   -- Check if allowed to do changes
   Check_Access___(schedule_id_);
   DELETE FROM batch_schedule_par_tab
   WHERE  schedule_id = schedule_id_;
END Remove_Parameters__;

PROCEDURE Remove_Chain_Parameters__ (
   schedule_id_ IN NUMBER )
IS
BEGIN
   DELETE FROM batch_schedule_chain_par_tab
      WHERE schedule_id = schedule_id_;
END Remove_Chain_Parameters__;

PROCEDURE Run_Batch_Schedule__ (
   schedule_id_ IN NUMBER,
   online_      IN VARCHAR2 DEFAULT 'TRUE' )
IS
   schedule_method_id_  NUMBER;
   description_         VARCHAR2(200);
   parameters_          VARCHAR2(32000);
   method_name_         VARCHAR2(2000);
   lang_code_           CONSTANT VARCHAR2(5) := Fnd_Session_API.Get_Language;
   id_                  NUMBER;
   run_online_          VARCHAR2(10) := online_;
   execution_time_      NUMBER;
   stream_msg_on_completion_  VARCHAR2(20);  
   stream_notes_ VARCHAR2(2000);
/*
   CURSOR get_batch_schedule IS
      SELECT s.schedule_name, s.lang_code, s.external_id, s.batch_schedule_type, m.method_name, m.argument_type, m.schedule_method_id
      FROM   batch_schedule_tab s, batch_schedule_method_tab m
      WHERE  s.schedule_id = schedule_id_
      AND    s.schedule_method_id = m.schedule_method_id;
*/

   CURSOR get_batch_schedule IS
      SELECT s.schedule_name, s.lang_code, s.external_id, s.batch_schedule_type, s.schedule_method_id,
             s.next_execution_date, s.schedule_id, s.active, s.check_executing, s.queue_id
      FROM   batch_schedule_tab s
      WHERE  s.schedule_id = schedule_id_;
   -- Preferred to lock records, but this can cause ORA-01555 snapshot too old.
   -- FOR UPDATE OF next_date;

   CURSOR get_batch_schedule_method IS -- Reports and Methods
      SELECT m.method_name, m.argument_type, m.schedule_method_id, m.check_day, m.check_executing
      FROM   batch_schedule_method_tab m
      WHERE  m.schedule_method_id = schedule_method_id_
      UNION
      SELECT m.description, 'PARAMETER', NULL, 'FALSE', m.check_executing
      FROM   batch_schedule_chain_tab m
      WHERE  m.schedule_method_id = schedule_method_id_;

   FUNCTION check_day___ (
      check_day_db_        IN VARCHAR2,
      next_execution_date_ IN DATE ) RETURN BOOLEAN
   IS
   BEGIN
      IF (check_day_db_ = 'TRUE') THEN
         IF (trunc(next_execution_date_) != trunc(SYSDATE)) THEN
            RETURN TRUE;
         END IF;
      END IF;
      RETURN FALSE;
   END check_day___;

   FUNCTION check_executing___ (
      check_executing_db_ IN VARCHAR2,
      schedule_id_        IN NUMBER ) RETURN BOOLEAN
   IS
      CURSOR get_executing IS
      SELECT 'TRUE' existing_job
        FROM transaction_sys_local_tab
       WHERE schedule_id = schedule_id_
         AND state IN ('Executing', 'Posted');
   BEGIN
      IF (check_executing_db_ = 'TRUE') THEN
         FOR rec IN get_executing LOOP
            IF (rec.existing_job = 'TRUE') THEN
               RETURN TRUE;
            END IF;
         END LOOP;
      END IF;
      RETURN FALSE;
   END check_executing___;

BEGIN
   -- Check if allowed to do changes
   Check_Access___(schedule_id_);
   FOR rec IN get_batch_schedule LOOP
      -- Don't run if inactive
      IF rec.active = 'FALSE' THEN
         Error_SYS.Appl_General(lu_name_, 'INACTIVE_SCHEDULE: To run the Scheduled Task it must be Active.');
      END IF;
      -- Set schedule_method_id
      schedule_method_id_ := rec.schedule_method_id;
      -- Set users language
      Fnd_Session_API.Set_Language(rec.lang_code);
      parameters_ := NULL;
      FOR rec2 IN get_batch_schedule_method LOOP
         -- Check if next_execution_date is current date
         IF (Check_Day___(rec2.check_day, rec.next_execution_date)  = TRUE) THEN
            Error_SYS.Appl_General(lu_name_, 'CHECK_DAY_INFO: The next execution date is not equal to today''s date.');
         END IF;
         -- Check if job already submitted
         IF (Check_Executing___(rec.check_executing, rec.schedule_id) = TRUE) THEN
            RETURN;
         END IF;
         -- Check if job already submitted
         IF (Check_Executing___(rec2.check_executing, rec.schedule_id) = TRUE) THEN
            RETURN;
         END IF;
         -- Set method_name_
         IF (rec.batch_schedule_type = 'CHAIN') THEN
            -- Special method for chains
            method_name_ := upper('BATCH_SCHEDULE_CHAIN_API.RUN_BATCH_SCHEDULE_CHAIN__');
         ELSE
            method_name_ := rec2.method_name;
         END IF;
         -- Parameters is stored in table
         parameters_ := Batch_Schedule_API.Get_Parameters__(schedule_id_, rec2.argument_type);
         -- Translate description
         description_ := Language_SYS.Translate_Constant(lu_name_, 'SCHEDULE_DESC: Schedule ID :P1 : :P2', Fnd_Session_API.Get_Language, schedule_id_, rec.schedule_name);
         -- Set online_ to FALSE if schedule is a BAES Report
         $IF Component_Biserv_SYS.INSTALLED $THEN
         IF (Is_Excel_Report___(schedule_id_)) THEN
            IF (   (     NVL(Xlr_System_Parameter_Util_API.Get_System_Parameter('BA_EXECUTION_SERVER_AVAILABLE'), 'NO') IN ('FOR_ALL_INFO_SERVICES_REPORTS', 'ONLY_FOR_SCHEDULED_REPORTS'))
               AND (NOT( NVL(Xlr_System_Parameter_Util_API.Get_System_Parameter_Boolean('ACTIVATE_BR_CONTAINER'), FALSE)))) THEN
               run_online_ := 'FALSE';
            END IF;
         END IF;
         $END 
         -- Check if Schedule is run Online or in Background
         IF (rec.batch_schedule_type IN ('TASK', 'CHAIN')) THEN
            IF run_online_ = 'TRUE' THEN
               execution_time_ := Dbms_Utility.Get_Time;
               -- Schedule run online
               Transaction_SYS.Dynamic_Call(method_name_,
                                            rec2.argument_type,
                                            parameters_);
               execution_time_ := Dbms_Utility.Get_Time - execution_time_;
               Update_Next_Execution_Date_ (schedule_id_);
               Update_Last_Execution_Date_ (schedule_id_, sysdate, execution_time_);
            ELSE
               stream_msg_on_completion_:=Batch_Schedule_API.Get_Stream_Msg_On_Completio_Db(schedule_id_);                         
               stream_notes_:=Batch_Schedule_API.Get_Stream_Notes(schedule_id_);                                  
               -- Schedule run in Background
               Transaction_SYS.Deferred_Call(id_,
                                             method_name_,
                                             rec2.argument_type,
                                             parameters_,
                                             description_,
                                             queue_id_ => rec.queue_id,                              
                                             stream_msg_on_completion_ =>stream_msg_on_completion_,
                                             stream_notes_=> stream_notes_);
               Transaction_SYS.Update_Schedule_Id__(id_, schedule_id_);
               Update_Next_Execution_Date_ (schedule_id_);
            END IF;
         ELSIF (rec.batch_schedule_type = 'REPORT') THEN
             stream_msg_on_completion_:=Batch_Schedule_API.Get_Stream_Msg_On_Completio_Db(schedule_id_);                         
               stream_notes_:=Batch_Schedule_API.Get_Stream_Notes(schedule_id_);  
            -- Special treatment for reports
            -- Check which Report method to be run, and submit in that method in the right queue
            -- The external id is here the report id.
            Submit_Report___(rec.external_id,
                             rec2.method_name,
                             rec.lang_code,
                             rec2.argument_type,
                             parameters_,
                             description_,
                             schedule_id_, 
                             stream_msg_on_completion_ =>stream_msg_on_completion_,
                             stream_notes_=> stream_notes_);
         END IF;
      END LOOP;
      -- Set back to original language
      Fnd_Session_API.Set_Language(lang_code_);
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      -- Set back to original language
      Fnd_Session_API.Set_Language(lang_code_);
      RAISE;
END Run_Batch_Schedule__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
PROCEDURE Update_Next_Execution_Date_ (
   schedule_id_ IN NUMBER )
IS
   next_execution_date_ DATE := NULL;
BEGIN
   Update_Get_Next_Exec_Date_ (schedule_id_, next_execution_date_, TRUE);
END Update_Next_Execution_Date_;

PROCEDURE Update_Get_Next_Exec_Date_ (
   schedule_id_ IN NUMBER,
   next_execution_date_ IN OUT DATE,
   server_call_ IN BOOLEAN DEFAULT FALSE)
IS
   active_              VARCHAR2(20) := 'TRUE';
   execution_plan_      VARCHAR2(200);
   prev_execution_date_ DATE := NULL;
   stop_date_           DATE := NULL;

   CURSOR get_batch_schedule IS
   SELECT execution_plan, next_execution_date, stop_date,active
   FROM   batch_schedule_tab
   WHERE  schedule_id = schedule_id_;
BEGIN
   -- Check if allowed to do changes
   Check_Access___(schedule_id_);
   OPEN  get_batch_schedule;
   FETCH get_batch_schedule INTO execution_plan_, prev_execution_date_, stop_date_,active_;
   CLOSE get_batch_schedule;
   -- Calculate new next_execution date
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'execution plan: '|| execution_plan_);
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'prev_execution_date: '|| prev_execution_date_);
   next_execution_date_ := Batch_SYS.Get_Next_Exec_Time__(execution_plan_, prev_execution_date_);
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'next execution is '|| next_execution_date_);
   IF (server_call_) THEN
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'called from server ');
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'called from client ');
   END IF;
   IF (next_execution_date_ IS NULL OR
      (next_execution_date_ = prev_execution_date_ AND
      (execution_plan_ LIKE 'ON %' OR execution_plan_ = 'ASAP') AND server_call_)) THEN
      -- Stop the task only if it does not have a recurring execution plan or next_execution_date_ is NULL
      next_execution_date_ := NULL;
      active_              := 'FALSE';
   ELSE
   -- Accept new next_execution_date only if stop_date has not passed
      IF (nvl(stop_date_, next_execution_date_ + 1) <= next_execution_date_) THEN
      -- Stop the task
         next_execution_date_ := NULL;
         active_              := 'FALSE';
      END IF;
   END IF;
   UPDATE batch_schedule_tab
   SET    next_execution_date = next_execution_date_,
          active              = active_
   WHERE  schedule_id         = schedule_id_;
END Update_Get_Next_Exec_Date_;

PROCEDURE Update_Last_Execution_Date_ (
   schedule_id_ IN NUMBER,
   last_execution_date_ IN DATE,
   execution_time_ IN NUMBER )
IS
BEGIN
   -- Check if allowed to do changes
--   Check_Access___(schedule_id_);
   UPDATE batch_schedule_tab
   SET    last_execution_date = last_execution_date_,
          executions          = executions + 1,
          timed_executions    = nvl(timed_executions, 0) + 1,
          execution_time      = execution_time + execution_time_
   WHERE  schedule_id         = schedule_id_;
END Update_Last_Execution_Date_;

PROCEDURE Remove_ (
   schedule_id_ IN NUMBER )
IS
   remrec_     BATCH_SCHEDULE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR get_batch_schedule IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM   BATCH_SCHEDULE_TAB
      WHERE  schedule_id = schedule_id_;
BEGIN
   OPEN  get_batch_schedule;
   FETCH get_batch_schedule INTO objid_, objversion_;
   CLOSE get_batch_schedule;
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Translated_Execution_Plan (
   schedule_id_ IN NUMBER,
   lang_code_   IN VARCHAR2,
   date_fmt_    IN VARCHAR2,
   time_fmt_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   TYPE Day_Rec_Tab IS TABLE OF VARCHAR2(3) INDEX BY BINARY_INTEGER;

   MONDAY    CONSTANT VARCHAR2(20) := Language_SYS.Translate_Constant(lu_name_, 'WEEKDAY_MONDAY: Monday');
   TUESDAY   CONSTANT VARCHAR2(20) := Language_SYS.Translate_Constant(lu_name_, 'WEEKDAY_TUESDAY: Tuesday');
   WEDNESDAY CONSTANT VARCHAR2(20) := Language_SYS.Translate_Constant(lu_name_, 'WEEKDAY_WEDNESDAY: Wednesday');
   THURSDAY  CONSTANT VARCHAR2(20) := Language_SYS.Translate_Constant(lu_name_, 'WEEKDAY_THURSDAY: Thursday');
   FRIDAY    CONSTANT VARCHAR2(20) := Language_SYS.Translate_Constant(lu_name_, 'WEEKDAY_FRIDAY: Friday');
   SATURDAY  CONSTANT VARCHAR2(20) := Language_SYS.Translate_Constant(lu_name_, 'WEEKDAY_SATURDAY: Saturday');
   SUNDAY    CONSTANT VARCHAR2(20) := Language_SYS.Translate_Constant(lu_name_, 'WEEKDAY_SUNDAY: Sunday');

   weekday_error   EXCEPTION;
   execution_plan_ BATCH_SCHEDULE_TAB.execution_plan%TYPE;
   day_rec_tab_    Day_Rec_Tab;
   text_           VARCHAR2(32000);
   date_time_      VARCHAR2(2000);
   days_str_       VARCHAR2(2000);
   day_str_        VARCHAR2(2000);
   days_abr_str_   VARCHAR2(2000);
   last_comma_pos_ NUMBER;
   exec_plan_len_  NUMBER;
   time_start_at_  NUMBER;
   days_start_at_  NUMBER;
   days_end_at_    NUMBER;
   days_list_len_  NUMBER;
   day_count_len_  NUMBER;
   day_cnt_start_  NUMBER;
   day_cnt_end_    NUMBER;
   days_count_     NUMBER;
   index_          NUMBER;
   hours_          NUMBER;
   mins_           NUMBER;
   time_len_       NUMBER;
   day_ends_at_    NUMBER;
   day_starts_at_  NUMBER;
   day_str_len_    NUMBER;
   start_date_     DATE;
   stop_date_      DATE;

   CURSOR get_attr IS
      SELECT execution_plan, start_date, stop_date
      FROM BATCH_SCHEDULE_TAB
      WHERE schedule_id = schedule_id_;
   ---
   language_      VARCHAR2(5);
   date_format_   VARCHAR2(20);
   time_format_   VARCHAR2(20);
BEGIN
   -- Input validation:
   IF (lang_code_ IS NULL) THEN
      language_ := Fnd_Session_API.Get_Language;
   ELSE
      language_ := lang_code_;
   END IF;
   --
   IF (date_fmt_ IS NULL) THEN
      date_format_ := 'yyyy-MM-dd';
   ELSE
      date_format_ := date_fmt_;
   END IF;
   --
   IF (time_fmt_ IS NULL) THEN
      time_format_ := 'HH:mi AM';
   ELSE
      time_format_ := time_fmt_;
   END IF;

   -- Get the record we are supposed to work on:
   OPEN  get_attr;
   FETCH get_attr INTO execution_plan_, start_date_, stop_date_;
   CLOSE get_attr;

   IF (INSTR(execution_plan_, 'DAILY') = 1) THEN
      -- 9 characters to the start of the time string
      date_time_ := TO_CHAR(TO_DATE(SUBSTR(execution_plan_, 9), 'HH24:mi'), time_format_);
      text_ := Language_SYS.Translate_Constant(lu_name_, 'RESOURCES_DAILY: The job is scheduled to execute every day at :P1', language_, date_time_);
   ELSIF (INSTR(execution_plan_, 'WEEKLY') = 1) THEN
      -- Examples:
      --    WEEKLY ON SUN AT 00:00
      --    WEEKLY ON MON;TUE;WED;THU;FRI;SAT;SUN AT 18:00
      -- -------------------------------------------------
      exec_plan_len_ := LENGTH(execution_plan_);
      days_end_at_   := INSTR(execution_plan_, ' AT ');
      time_start_at_ := days_end_at_ + LENGTH(' AT ');
      days_start_at_ := LENGTH('WEEKLY ON ') + 1;
      days_list_len_ := days_end_at_ - days_start_at_;
      time_len_      := LENGTH('00:00');
      days_abr_str_  := SUBSTR(execution_plan_, days_start_at_, days_list_len_);
      date_time_     := TO_CHAR(TO_DATE(SUBSTR(execution_plan_, time_start_at_, time_len_), 'HH24:mi'), time_format_);

      -- Split the list into a PL/SQL table for easier processing
      SELECT regexp_substr(days_abr_str_, '[^;]+', 1, level)
        BULK COLLECT INTO day_rec_tab_
        FROM dual
        CONNECT BY regexp_substr(days_abr_str_, '[^;]+', 1, level) IS NOT NULL;

      days_str_ := ''; -- Reset the days_str_ before processing
      FOR idx_ IN day_rec_tab_.FIRST..day_rec_tab_.LAST LOOP
         CASE (day_rec_tab_(idx_))
            WHEN 'MON' THEN
               days_str_ := days_str_ || ', ' || MONDAY;
            WHEN 'TUE' THEN
               days_str_ := days_str_ || ', ' || TUESDAY;
            WHEN 'WED' THEN
               days_str_ := days_str_ || ', ' || WEDNESDAY;
            WHEN 'THU' THEN
               days_str_ := days_str_ || ', ' || THURSDAY;
            WHEN 'FRI' THEN
               days_str_ := days_str_ || ', ' || FRIDAY;
            WHEN 'SAT' THEN
               days_str_ := days_str_ || ', ' || SATURDAY;
            WHEN 'SUN' THEN
               days_str_ := days_str_ || ', ' || SUNDAY;
            ELSE
               text_ := Language_SYS.Translate_Constant(lu_name_, 'WEEKDAY_ERROR: Invalid day of week abbreviation [:P1].', language_, day_rec_tab_(idx_));
               RAISE weekday_error;
         END CASE;
      END LOOP;

      days_str_ := SUBSTR(days_str_, 3);  -- Remove the starting comma and leading space
      -- The last comma needs to be converted to an "and" to make it look nice
      IF day_rec_tab_.COUNT > 1 THEN
         last_comma_pos_ := INSTR(days_str_, ',', -1);
         days_str_       := Language_SYS.Translate_Constant(lu_name_, 'WEEK_DAY_AND: :P1 and :P2', language_, SUBSTR(days_str_, 1, last_comma_pos_ - 1), SUBSTR(days_str_, last_comma_pos_ + 2));
      END IF;
      -- All parameters are here, now construct the return string
      text_ := Language_SYS.Translate_Constant(lu_name_, 'RESOURCES_WEEKLY: The job is scheduled to execute every :P1 at :P2', language_, days_str_, date_time_);
      --
   ELSIF (INSTR(execution_plan_, 'MONTHLY') = 1) THEN
      -- Examples:
      -- MONTHLY ON DAY 1 AT 07:00
      -- -------------------------
      day_cnt_end_   := INSTR(execution_plan_, ' AT ');
      time_start_at_ := day_cnt_end_ + LENGTH(' AT ');
      day_cnt_start_ := LENGTH('MONTHLY ON DAY ');
      day_count_len_ := day_cnt_end_ - day_cnt_start_;
      days_count_    := TRIM(substr(execution_plan_, day_cnt_start_, day_count_len_));
      time_len_      := LENGTH('00:00');
      date_time_     := TO_CHAR(TO_DATE(SUBSTR(execution_plan_, time_start_at_, time_len_), 'HH24:mi'), time_format_);
      -- Construct the return string
      text_ := Language_SYS.Translate_Constant(lu_name_, 'RESOURCES_MONTHLY: The job is scheduled to execute day :P1 every month at :P2', language_, days_count_, date_time_);
      --
   ELSIF (INSTR(execution_plan_, 'ON') = 1) THEN
      -- Example:
      --    ON 2013-02-28 AT 15:47
      time_len_      := LENGTH('00:00');
      day_ends_at_   := INSTR(execution_plan_, ' AT ');
      time_start_at_ := day_ends_at_ + length(' AT ');
      day_starts_at_ := length('ON ') + 1;
      day_str_len_   := day_ends_at_ - day_starts_at_;
      day_str_       := TO_CHAR(TO_DATE(SUBSTR(execution_plan_, day_starts_at_, day_str_len_), 'yyyy-MM-dd'), date_format_);
      date_time_     := TO_CHAR(TO_DATE(SUBSTR(execution_plan_, time_start_at_, time_len_), 'HH24:mi'), time_format_);
      --
      text_ := Language_SYS.Translate_Constant(lu_name_, 'RESOURCES_ONCE: The job is scheduled to execute on :P1 at :P2', language_, day_str_, date_time_);
      --
   ELSIF (INSTR(execution_plan_, 'EVERY') = 1) THEN
      -- Example:
      --    EVERY 00:30
      index_ := INSTR(execution_plan_, ':');
      hours_ := TO_NUMBER(SUBSTR(execution_plan_, index_ - 2, 2)); -- xx:00, xx portion
      mins_  := TO_NUMBER(SUBSTR(execution_plan_, index_ + 1, 2)); -- 00:yy, yy portion
      IF (hours_ > 0) THEN
         IF (mins_ > 0) THEN
            text_ := Language_SYS.Translate_Constant(lu_name_, 'EVERYMINHOURS: The job is scheduled to execute every :P1 hours and :P2 minutes', language_, hours_, mins_);
         ELSE
            text_ := Language_SYS.Translate_Constant(lu_name_, 'EVERYHOUR: The job is scheduled to execute every :P1 hours', language_, hours_);
         END IF;
      ELSE
         text_ := Language_SYS.Translate_Constant(lu_name_, 'EVERYMIN: The job is scheduled to execute every :P1 minutes', language_, mins_);
      END IF;
   ELSE
      text_ := Language_SYS.Translate_Constant(lu_name_, 'CUSTOMSCHEDULE: The job is scheduled to execute using a custom expression');
   END IF;

   IF (start_date_ IS NOT NULL) THEN
      IF (stop_date_ IS NOT NULL) THEN
         -- We have a start date and an end date
         text_ := text_ || Language_SYS.Translate_Constant(lu_name_, 'RESOURCES_ENDING: , starting :P1 and ending :P2', language_, TO_CHAR(start_date_, date_format_), TO_CHAR(stop_date_, date_format_));
      ELSE
         -- If we have only a start date
         text_ := text_ || Language_SYS.Translate_Constant(lu_name_, 'RESOURCES_STARTING: , starting :P1', language_, TO_CHAR(start_date_, date_format_));
      END IF;
   END IF;
   --
   RETURN text_;
   --
EXCEPTION
   WHEN weekday_error THEN
      RETURN text_; -- The error message is recorded in the [text_], return it to the client
END Get_Translated_Execution_Plan;

PROCEDURE Modify_Username (
   schedule_id_ IN NUMBER,
   username_    IN VARCHAR2 )
IS
BEGIN
   -- Check if allowed to do changes
   Check_Access___(schedule_id_);
   -- Using direct update so that it isn't possible to change username in any other way
   UPDATE batch_schedule_tab
   SET    username = username_
   WHERE  schedule_id = schedule_id_;
END Modify_Username;

@UncheckedAccess
FUNCTION Get_Schedule_Time (   
   execution_plan_ IN VARCHAR2) RETURN DATE
IS  
   datestr_ VARCHAR2(20);
BEGIN
   IF (SUBSTR(execution_plan_, 1, 3) = 'ON ') THEN
      datestr_ := substr(execution_plan_, 4, 10);
      RETURN TO_DATE(datestr_ || ' ' || REGEXP_SUBSTR(execution_plan_,'\d\d:\d\d'), 'YYYY-MM-DD HH24:MI');
   ELSE
      RETURN NVL(TO_DATE(REGEXP_SUBSTR(execution_plan_,'\d\d:\d\d'),'HH24:Mi'),TO_DATE(REGEXP_SUBSTR(execution_plan_,'\d:\d\d'),'HH24:Mi'));
   END IF;  
END Get_Schedule_Time;


FUNCTION Get_Execution_Plan (   
   schedule_id_ IN NUMBER) RETURN VARCHAR2
IS  
   temp_ batch_schedule_tab.execution_plan%TYPE;
BEGIN
   IF (schedule_id_ IS NULL) THEN
         RETURN NULL;
   END IF;
   
   SELECT execution_plan
   INTO  temp_
   FROM  batch_schedule_tab
   WHERE schedule_id = schedule_id_;
   
   RETURN temp_;
   
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(schedule_id_, 'Get_Execution_Plan');
   END Get_Execution_Plan;
   
@UncheckedAccess   
FUNCTION Get_Current_Schedule_Option (   
   execution_plan_ IN VARCHAR2) RETURN VARCHAR2
IS  
   curr_schedule_option_ VARCHAR2(10);
BEGIN
   IF (execution_plan_ IS NULL) THEN
         RETURN NULL;
   END IF; 
   
   curr_schedule_option_ := REGEXP_SUBSTR(execution_plan_,'\w*');
   
   IF ( curr_schedule_option_ = 'DAILY') THEN
      RETURN 'DAILY';
   ELSIF (curr_schedule_option_ = 'WEEKLY') THEN
       RETURN 'WEEKLY';
   ELSIF (curr_schedule_option_ = 'MONTHLY') THEN
       RETURN 'MONTHLY';
   ELSIF (curr_schedule_option_ = 'ON') THEN
       RETURN 'SCHEDULED';
   ELSIF (curr_schedule_option_ = 'EVERY') THEN
       RETURN 'INTERVAL';
   ELSE
      RETURN 'CUSTOM';
   END IF;  

END Get_Current_Schedule_Option;

@UncheckedAccess
FUNCTION Get_Scheduled_Days (   
   execution_plan_ IN VARCHAR2) RETURN VARCHAR2
IS  
   curr_schedule_option_ VARCHAR2(10);
BEGIN
   IF (execution_plan_ IS NULL) THEN
         RETURN NULL;
   END IF; 
   
   curr_schedule_option_ := REGEXP_SUBSTR(execution_plan_,'\w*');

   IF (curr_schedule_option_ = 'WEEKLY') THEN
       RETURN REPLACE(SUBSTR(execution_plan_,11,INSTR(execution_plan_,' AT ')-11),';','^');
   ELSE
      RETURN NULL;
   END IF;  

END Get_Scheduled_Days;

@UncheckedAccess
FUNCTION Get_Scheduled_Day_Number (   
   execution_plan_ IN VARCHAR2) RETURN INTEGER
IS  
BEGIN
   IF (SUBSTR(execution_plan_, 1, 15) = 'MONTHLY ON DAY ') THEN
     RETURN REGEXP_SUBSTR(SUBSTR(execution_plan_, 16),'[0-9]*');
   ELSE
      RETURN NULL;
   END IF;  

END Get_Scheduled_Day_Number;

@UncheckedAccess
FUNCTION Get_Schedule_Interval (   
   execution_plan_ IN VARCHAR2) RETURN VARCHAR2
IS  
   curr_schedule_option_ VARCHAR2(10);
BEGIN
   IF (execution_plan_ IS NULL) THEN
         RETURN NULL;
   END IF; 
   
   curr_schedule_option_ := REGEXP_SUBSTR(execution_plan_,'\w*');

   IF (curr_schedule_option_ = 'EVERY') THEN
       RETURN SUBSTR(execution_plan_,7);
   ELSE
      RETURN NULL;
   END IF;  

END Get_Schedule_Interval;
