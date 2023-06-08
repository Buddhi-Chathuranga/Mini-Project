-----------------------------------------------------------------------------
--
--  Logical unit: WorkTimeCalendar
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190213  Hasplk  Bug 146893, Added index WORK_TIME_COUNTER_DESC_IX3 as a hint to cursor in method Get_End_Time.
--  140826  NIFRSE  PRSA-2183, Added some Assert_SYS check and annotation.
--  140206  SamGLK  PBSA-4777: Changed the Get_Start_Date().
--  130715  heralk  Scalability Changes - removed global variables.
--  ----------------------------- APPS 9 ------------------------------------
--  110628  INMALK  Bug Id 97803, Added parameter round_off to method Get_Start_Time and Get_End_Time.
--  101207  AndDse  BP-3485, Added procedures Add_Info_On_Pending and Check_Not_Generated.
--  100603  ChAlLk  Get_Start_Time - Removed truncation of seconds in end_time_ to solve a scheduling issue. (Bug#90295).
--  100422  Ajpelk  Merge rose method documentation
-- ----------------------------Eagle------------------------------------------
--  090924  ChAlLk  Modified Get_Day_Info_For_Time. Supplementary fix for Bug80592 (Bug#86124).
--  090312  ChAlLk  Modified Get_Day_Info_For_Time. Now uses Get_Work_Day_For_Time to get date_ (Bug#80592).
--  080711  UsRaLK  Added parameter round_off to method Get_Work_Minutes_Between (Bug#68092).
--  070726  AsWiLk  Parsed 'NLS_CALENDAR=GREGORIAN' for the call to to_date in method Get_Week_Day (Bug#66885).
--  060306  Haunlk  Modofied the EXIT condition at the Get_End_Date().
--  060208  SUKMLK  Bug 55512, patched.
--  060125  MAJO    Introduced Micro Cache concecpt for the method Is_Generated___.
--                  This method is executed very frequently when using Distribution and/or Manufacturing.
--                  With the micro cache concept we reduce the number of trips to database a lot.
--  060104  JoEd    Changed Forward_Changes___ to use "user_arguments" instead of "user_source"
--                  for better and faster query.
--                  Uncommented error message in Is_Generated___.
--  050405  ToBeSe  Bug 49880, Added parameter contract to procedure Calendar_Switched and added it in
--                  the attribute string when calling Forward_Changes__.
--                  Added procedure Add_Calendar_Changed_Error.
--                  Added public declarations for calendar changed errors.
--                  Modified procedure Forward_Changes__ to transfer parameter contract from the attribute string.
--                  Modified procedure Forward_Changes___ to handle exceptions when calling Calendar_Changed methods in other LU's.
--                  Bug merged by UTGULK.
--  040301  ThAblk  Removed substr from views.
--  040220  DHSELK  Removed substrb and changed to substr where needed for Unicode Support
--  040218  Gacolk  UNICODE: Removed the 4th parameter from dbms_sql.bind_variable call in method Forward_Changes___.
--                  Didnt replace it with EXECUTE IMMEDIATE as adivsed by technical experts due to performance problems.
--  -------------------------------------------------------------------------
--  030731  NaSalk  SP4 Merge.
--  021217  Kamtlk  Bug 34747.Modified the variable length from 2000 to 32000 in procedure set_exception_pending.
--  021113  Raselk  Bug 32913,Modified function Get_End_Time  to enable  saving  forward  scheduled  SO,
--                               ,when  an  operation time  is less  than  one minute.
--  -----------------------------------SP4 Merge ----------------------------
--  021212 ZAHALK Did the SP3 - Merge for Take-off. And did the decommenting.
--  020328 Dobese Bug 28605, minor performance changes
--  011001  JOMC  Bug 22026, In Get_Day_Info_For_Time changed a Get_Start_Time__ call to
--                Get_Start_Time_For_Time__ and a Get_End_Time__ to Get_End_Time_For_Time__.
--  010906  JOMC  Bug 22026, Added Get_Work_Day_For_Time, Get_Previous_Work_Day_For_Time,
--                Get_Next_Work_Day_For_Time, Get_Day_Info_For_Time,
--                Is_Working_Time_For_Time, and Get_End_Time_For_Time,
--                Get_Work_Day_Start_For_Time.
--  000315  NiHj  Request Call 23799. Improved error message in method Forward_Changes__ implemented.
--  990712  MATA  Changed substr to substrb in DEFINE OBJEVENTS and STATE
--  990609  JoEd  Call id 11752: Added check on reserved time periods in
--                Exist_Numeric_Period.
--  990531  JoEd  Added LOV view querying only valid calendars.
--  990521  JoEd  Call id 17750: Changed where clause in Get_Day_Type___ to
--                include start date = bypassed date.
--  990517  JoEd  Added function Get_Nearest_Work_Day.
--                Call id 16638: Rebuild Get_Start_Date and Get_End_Date so
--                they return previous and next work day resp. when no working
--                day and duration 0 is passed.
--  990512  JoEd  Commented the error message in Is_Generated__ due to pragma
--                violations in Oracle 7.3.2 (Oracle bug 244014) and replaced
--                it with raise of exception VALUE_ERROR.
--                Moved the method back to impl. level.
--  990511  JoEd  Added forward flag to only call the Calendar_Changed methods
--                when generating from the client forms - not from the install script.
--  990510  JoEd  Made Is_Generated___ private instead of impl.
--  990509  JoEd  Added NULL check on minutes and periods in Get_Day_Info.
--  990508  HERO  Changed NULL condition in Get_Next_Work_Minute to NOT NULL.
--  990507  JoEd  Added method Is_Calendar_Executing___ to check that only
--                one background job at time is running for generating a
--                calendar.
--  990506  JoEd  Changed work_day_iso_week column in VIEWPUB.
--                Changed if statements where Is_Generated___ calls are made.
--  990505  JoEd  Rebuild Get_Start_Time and Get_End_Time, Get_Start_Date and
--                Get_End_Date.
--  9904xx  JoEd  New template and state diagram. Rebuild all the LU's methods.
--                Renamed Calendar_Created___ to Send_Event_Message___.
--  990421  JoEd  Moved Get_Week_Day from WorkTimeUtility.
--  990413  JoEd  Call Id 15458: Added call to day type's Check_Correct in Check_Correct___
--                to avoid getting wrong values when calling the different get methods
--                after the calendar has been recreated.
--  990401  JoEd  Call Id 14720: Added Check_Correct___ call before setting
--                a calendar to Valid. Added check on calendar start date in that
--                method too.
--  990331  JoEd  Call Id 13706: Changed error message SWITCH_INVALID in Calendar_Switched.
--  990330  JoEd  Call Id 11752: Extended check on exception in Exist_Numeric_Period.
--  990322  NINO  Made calendar description required.
--  990302  JoMu  Modified Get_Next_Period to return period when multiple periods.
--  990210  JoEd  Added check on date interval in Get_Work_Days_Between
--                and Get_Work_Minutes_Between.
--                Replaced Get_Activity_..._Time in Get_Next_Work_Minute and
--                Get_Previous_Minutes with Get_..._Time - only fetch Normal activity.
--                Call Id 4963: Rebuild Get_Start_Time and Get_End_Time for better
--                performance (approx 8 sec. instead of 1.5 min. with duration = 1000).
--                Also rebuild Get_Previous_... and Get_Next_Work_Minute due to performance
--  990209  JoEd  Rebuild Get_Work_Days_Between.
--                Changes due to Work_Time_Exception_API.Check_Correct's parameter
--                list has changed.
--  990208  JoEd  Changed Get_Work_Minutes_Between. Added check on negative minute diff.
--                Replaced public cursor work_day_periods with function Get_Next_Period.
--  990203  JoEd  Changed name of public cursor to work_day_periods.
--  990202  JoEd  Replaced public cursor get_work_days with the public view
--                Work_Time_Calendar_Pub.
--                Added Calendar_Created___ method to call the Event server when
--                a calendar has been created/recreated.
--                Added public cursor get_work_day_periods.
--                Moved Check_Correct to implementation level and added call to
--                it (Check_Correct___) in Reset_Counters___.
--                Added progress info for the background job in Calendar_Changed___.
--                Call Id 7427: Added check for date gaps in Check_Correct___.
--  990125  JoEd  Added public cursor get_work_days.
--  990121  JoEd  Added function Get_Prior_Work_Day.
--  990120  JoEd  Call Id 7219: Added method Calendar_Switched and
--                Forward_Changes__.
--  981120  JoEd  SID 7029: In Get_Period_End, when period passes midnight return
--                midnight next day.
--                SID 7659: Rebuilt state machine. Added new method Display_Message___
--                to display recreate message when any calendar is invalidated.
--                Changed SetInvalid call to a Finite_State_Machine___ call to
--                display message in the client.
--  981119  JoEd  SID 7034: Added check on all Get_... functions to return NULL if calendar
--                doesn't exist.
--                SID 7659: Moved info message CAL_INVALID from Exist to Finite_State_Machine___.
--  981117  JoEd  Added function Exist_Numeric_Period.
--                SID 7000: Rebuild Get_Work_Minutes_Between to return correct
--                # minutes and to speed up the method.
--  981116  JoEd  SID 6986: Changed Get_Next_Work_Minute and Get_Previous_Work_Minute.
--                SID 6991: Changed Get_Work_Days_Between.
--                SID 7022: Removed check on working time in Get_Start_Date, Get_End_Date
--                and Get_Start_Time and Get_End_Time.
--  981113  JoEd  SID 7034: Removed counter from Get_Work_Day_Minutes and
--                Get_Work_Day_Periods parameter lists.
--  981105  JoEd  Rebuild the sql statements to use primary keys where possible.
--  981030  JoEd  Changed Get_Start_... and Get_End_... methods to work
--                in a similar way as the old shop calendar.
--  981028  JoEd  Rebuild Calendar_Changed___ method.
--                Added function Get_Closest_Work_Day.
--  981027  JoEd  Changed information message in Exist.
--  981026  JoEd  Rename of view used in Get_Work_Day_Periods.
--                Rebuild Exist_Period, Get_Period..., Is_Working_Time and
--                Reset_Counters___.
--  9810xx  JoEd  Added Get_Description and column comment on state.
--                Removed unused methods. Changed state machine.
--                Added Get_Start_Date, Get_End_Date, Set_Calendar_Valid,
--                Set_Schedule_Invalid, Set_Exception_Invalid and Set_Calendar_Valid__.
--                Rebuild Get_Work_Day_Minutes and Get_Work_Day_Periods.
--  980917  JoEd  Changed parameter list in Enumerate_Days.
--  980908  JoEd  Implemented Is_Working_Time and rebuild most of the
--                calendar interface.
--                Made calls to WorkTimeCounter private.
--  9806xx-
--  980904  JoEd  Created from MchSchedules.
--  010612  Larelk Bug 22173,Added General_SYS.Init_Method in Get_Closest_Work_Day.
--  081021  HAAR  Removed Utility_SYS.Get_User (Bug#77768)
--  170714  MDAHSE  STRSA-27573: Removed Get_Objstate and Get_State since these are now generated automatically.
--  200514  RUMELK AMXTEND-327, Added function Get_Start_Time_For_Time.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE calendar_changed_error_rec IS RECORD
(
   error_text varchar2(2000)
);

CURSOR calendar_changed_error return calendar_changed_error_rec IS
SELECT ''
FROM dual;

TYPE Calendar_Changed_Error_Tab IS TABLE OF Calendar_Changed_error%ROWTYPE
      INDEX BY BINARY_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;

micro_cache_calendar_id_ VARCHAR2(10);
micro_cache_objstate_    WORK_TIME_CALENDAR_TAB.rowstate%TYPE;
micro_cache_time_        NUMBER := 0;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Invalidate_Micro_Cache___
IS
BEGIN
   micro_cache_calendar_id_ := 'DuMmY-99';
   micro_cache_objstate_ := NULL;
END Invalidate_Micro_Cache___;


PROCEDURE Update_Cache___ (
   calendar_id_ IN VARCHAR2 )
IS
   time_       NUMBER;
   CURSOR get_attr IS
      SELECT rowstate
      FROM WORK_TIME_CALENDAR_TAB
      WHERE calendar_id = calendar_id_;
BEGIN
   time_ := Database_SYS.Get_Time_Offset;
   IF ((time_ - micro_cache_time_) < 10) AND (micro_cache_calendar_id_ = calendar_id_) THEN
      NULL;
   ELSE
      OPEN get_attr;
      FETCH get_attr INTO micro_cache_objstate_;
      IF get_attr%NOTFOUND THEN
         micro_cache_objstate_ := NULL;
      END IF;
      CLOSE get_attr;
      micro_cache_calendar_id_ := calendar_id_;
      micro_cache_time_ := time_;
   END IF;
END Update_Cache___;


-- Get_Day_Type___
--   Returns the day type for a specific date.
--   Used when generating the calendar.
FUNCTION Get_Day_Type___ (
   calendar_id_ IN VARCHAR2,
   exception_code_ IN VARCHAR2,
   curr_date_ IN DATE ) RETURN VARCHAR2
IS
   day_type_ WORK_TIME_COUNTER.day_type%TYPE := NULL;
   date_     DATE := trunc(curr_date_);

   CURSOR get_schedule IS
      SELECT schedule, start_date
      FROM WORK_TIME_CALENDAR_DESC_TAB
      WHERE date_ >= start_date
      AND date_ <= end_date
      AND calendar_id = calendar_id_;
   schedrec_  get_schedule%ROWTYPE;
BEGIN
   IF (exception_code_ IS NOT NULL) THEN
      day_type_ := Work_Time_Exception_Code_API.Get_Day_Type(exception_code_, date_);
   END IF;
   IF (day_type_ IS NULL) THEN
      OPEN get_schedule;
      FETCH get_schedule INTO schedrec_;
      IF (get_schedule%NOTFOUND) THEN
         day_type_ := NULL;
      ELSE
         day_type_ := Work_Time_Schedule_Desc_API.Get_Day_Type(schedrec_.schedule, schedrec_.start_date, date_);
      END IF;
      CLOSE get_schedule;
   END IF;
   RETURN day_type_;
END Get_Day_Type___;


-- Reset_Counters___
--   Checks that the calendar is correct and recalculates the calendar's
--   working days by adding them to the WorkTimeCounter LU.
PROCEDURE Reset_Counters___ (
   rec_ IN WORK_TIME_CALENDAR_TAB%ROWTYPE )
IS
   curr_date_      DATE;
   day_type_       VARCHAR2(8);
   calendar_id_    WORK_TIME_CALENDAR_TAB.calendar_id%TYPE;

   CURSOR get_interval IS
      SELECT start_date, end_date
      FROM WORK_TIME_CALENDAR_DESC_TAB
      WHERE calendar_id = calendar_id_;
BEGIN

   calendar_id_ := rec_.calendar_id;

   -- Check to see that the calendar's schedules are correct. Do this here again,
   -- if user gets through the Create Calendar client call somehow.
   Check_Correct___(calendar_id_);

   -- Make a snapshot of the current rules/component tables
   Copy_Rules___;

   -- Prepare the counter for new records by removing the old ones
   Work_Time_Counter_API.Remove_Calendar__(calendar_id_);

   -- get all calendar date intervals
   FOR intrec_ IN get_interval LOOP
      curr_date_ := intrec_.start_date;
      WHILE (curr_date_ <= intrec_.end_date) LOOP
         day_type_ := Get_Day_Type___(rec_.calendar_id, rec_.exception_code, curr_date_);
         IF ((day_type_ IS NOT NULL) AND (Work_Time_Day_Type_Desc_API.Is_Working_Day__(day_type_) = 1)) THEN
            -- IF the current day_type has working time or reserved time, add to "vector"
            Work_Time_Counter_API.New_Work_Day__(rec_.calendar_id, curr_date_, day_type_,
               Work_Time_Day_Type_Desc_API.Get_Working_Minutes(day_type_), Work_Time_Day_Type_Desc_API.Get_Working_Periods(day_type_));
         END IF;
         curr_date_ := curr_date_ + 1;
      END LOOP;
   END LOOP;
END Reset_Counters___;


-- Forward_Changes___
--   Tells other LU's that a specific calendar has been modified/switched.
--   LUs using a calendar must have a method named Calendar_Changed to handle
--   when a calendar's dates are changed.
--   Add a procedure with the following declaration
--   PROCEDURE Calendar_Changed (
--   calendar_id_ IN VARCHAR2,
--   contract_ IN VARCHAR2 DEFAULT NULL )
--   This method is also called when a calendar has been changed from one
--   to another on a site (then contract will have a value).
--   The Calendar_Changed method should only check whether or not the different
--   dates are still working days in the passed calendar.
PROCEDURE Forward_Changes___ (
   calendar_id_ IN VARCHAR2,
   contract_ IN VARCHAR2 DEFAULT NULL )
IS
   stmt_          VARCHAR2(200);
   calendar_error EXCEPTION;
   error_catched_ BOOLEAN := FALSE;
   temp_error_log_             CLOB;
   calendar_changed_errors_    Calendar_Changed_Error_Tab;
   err_rec_                    Work_Time_Calendar_API.calendar_changed_error_rec;
   position_                   NUMBER;  
   separator_                  VARCHAR2(1):=CLIENT_SYS.text_separator_;
   CURSOR get_package IS
      SELECT DISTINCT package_name
      FROM user_arguments
      WHERE object_name = 'CALENDAR_CHANGED';
BEGIN
   
   FOR rec_ IN get_package LOOP
      --            use execute immediate.
      BEGIN
         -- Call package's Calendar_Changed method
         Trace_SYS.Field('Package being called', rec_.package_name);
         stmt_ := 'BEGIN ' || rec_.package_name || '.Calendar_Changed(:temp_error_log,:calendar_id, :contract); END;';
         
         -- rec_.package_name is from user_arguments
         -- Log errors
         Assert_SYS.Assert_Is_Package_Method(rec_.package_name, 'Calendar_Changed');
         
         @ApproveDynamicStatement(2014-08-26,nifrse)
         EXECUTE IMMEDIATE stmt_ USING OUT temp_error_log_,calendar_id_, contract_;
         
         IF temp_error_log_  IS NOT NULL THEN
            error_catched_ := TRUE;
            WHILE  length(temp_error_log_) > 0 LOOP
               position_ := instr(temp_error_log_,separator_);
               err_rec_.error_text := substr(temp_error_log_,1,position_-1);
               calendar_changed_errors_(calendar_changed_errors_.count) := err_rec_;
               temp_error_log_ := substr(temp_error_log_,position_+1);
            END LOOP; 
         END IF;
            
      END;
   END LOOP;
   
   IF (error_catched_) THEN
      RAISE calendar_error;
   END IF;
EXCEPTION
   WHEN calendar_error THEN
      @ApproveTransactionStatement(2014-08-25,nifrse)
      ROLLBACK;
      FOR i IN 0..calendar_changed_errors_.count-1 LOOP
         Transaction_SYS.Log_Status_Info(calendar_changed_errors_(i).error_text);
      END LOOP;
      @ApproveTransactionStatement(2014-08-25,nifrse)
      COMMIT;
      Error_SYS.Appl_General(lu_name_,'CALCHG_ERR: Error while forwarding calendar changes.');
END Forward_Changes___;


-- Send_Event_Message___
--   Creates an Event server message telling user about the newly
--   generated/regenerated calendar.
PROCEDURE Send_Event_Message___ (
   calendar_id_ IN VARCHAR2 )
IS
   msg_  VARCHAR2(2000);
   user_ VARCHAR2(30);
BEGIN
   IF (Event_SYS.Event_Enabled(lu_name_, 'CALENDAR_GENERATED')) THEN
      msg_ := Message_SYS.Construct('CALENDAR_GENERATED');

      -- Standard Event Parameters
      user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute(msg_, 'EVENT_DATETIME', SYSDATE);
      Message_SYS.Add_Attribute(msg_, 'USER_IDENTITY', user_);
      Message_SYS.Add_Attribute(msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(user_));
      Message_SYS.Add_Attribute(msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute(msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute(msg_, 'CALENDAR_ID', calendar_id_);

      -- Other information
      Message_SYS.Add_Attribute(msg_, 'DESCRIPTION', Get_Description(calendar_id_));

      Event_SYS.Event_Execute(lu_name_, 'CALENDAR_GENERATED', msg_);
   END IF;
END Send_Event_Message___;


-- Check_Correct___
--   Checks that the calendar has been setup right.
--   Called from Reset_Counters___.
PROCEDURE Check_Correct___ (
   calendar_id_ IN VARCHAR2 )
IS
   current_start_ DATE;
   previous_end_  DATE;
   old_schedule_  WORK_TIME_CALENDAR_DESC_TAB.schedule%TYPE;
   start_day_     WORK_TIME_SCHEDULE.period_start_day%TYPE;
   start_weekday_ WORK_TIME_SCHEDULE.period_start_day%TYPE;

   CURSOR get_desc IS
      SELECT schedule, start_date, end_date
      FROM WORK_TIME_CALENDAR_DESC_TAB
      WHERE calendar_id = calendar_id_
      ORDER BY start_date;
   descrec_  get_desc%ROWTYPE;
BEGIN

   -- Check all schedules intervals. Fetch first record to use as the "previous" record in the loop
   -- Don't check the exceptions. The are designed not to match the schedules anyway.
   OPEN get_desc;
   FETCH get_desc INTO descrec_;
   IF (get_desc%NOTFOUND) THEN
      CLOSE get_desc;
      Error_SYS.Record_General(lu_name_, 'CAL_EMPTY: The calendar :P1 is empty and can not be generated!', calendar_id_);
   END IF;

   -- Check period start weekday
   Trace_SYS.Field('calendar start date', descrec_.start_date);
   start_day_ := Work_Time_Schedule_API.Get_Period_Start_Day(descrec_.schedule);
   start_weekday_ := Get_Week_Day(descrec_.start_date);
   IF (start_day_ != start_weekday_) THEN
      CLOSE get_desc;
      Error_SYS.Record_General(lu_name_, 'WRONG_START_WEEKDAY: The period start day for the schedule :P1 is a :P2 but is registered to start on a :P3.',
        descrec_.schedule, start_day_, start_weekday_);
   END IF;

   -- loop through all calendar details to check date interval overlaps
   LOOP
      -- store old record's info
      previous_end_ := descrec_.end_date;
      old_schedule_ := descrec_.schedule;
      -- Fetch next record
      FETCH get_desc INTO descrec_;
      EXIT WHEN (get_desc%NOTFOUND);
      -- store current record's info
      current_start_ := descrec_.start_date;
      -- check if the start date/time overlaps the previous record's end date/time
      Trace_SYS.Field('prior end date', previous_end_);
      Trace_SYS.Field('start date', current_start_);
      IF (previous_end_ >= current_start_) THEN
         CLOSE get_desc;
         Error_SYS.Record_General(lu_name_, 'SCHED_OVERLAP: Schedule :P1 overlaps schedule :P2!', descrec_.schedule, old_schedule_);
      END IF;
   END LOOP;
   CLOSE get_desc;
END Check_Correct___;


-- Copy_Rules___
--   Makes a snapshot of the table data used when generating a calendar.
--   The tables contains all rules at the time of the calendar generation.
--   The copy is made with simple SQL insert calls, to be able to copy the
--   whole table at once and not run via any Unpack_Check_Insert___ methods.
--   There are no LU's connected to the WT_%_GEN.. tables. The tables are used
--   primarily by CBS and their calendar GUI.
PROCEDURE Copy_Rules___
IS
BEGIN
   Trace_SYS.Message('Removing old data from the WT_%_GEN_TAB tables.');
   DELETE FROM WT_DAY_TYPE_DESC_GEN_TAB;
   DELETE FROM WT_DAY_TYPE_GEN_TAB;
   DELETE FROM WT_SCHEDULE_DESC_GEN_TAB;
   DELETE FROM WT_SCHEDULE_GEN_TAB;
   DELETE FROM WT_EXCEPTION_CODE_GEN_TAB;
   DELETE FROM WT_EXCEPTION_GEN_TAB;
   DELETE FROM WT_CALENDAR_DESC_GEN_TAB;
   DELETE FROM WT_CALENDAR_GEN_TAB;

   Trace_SYS.Message('Adding new data to the WT_%_GEN_TAB tables.');
   INSERT INTO WT_DAY_TYPE_DESC_GEN_TAB (day_type, from_time, to_time, period, reserved_time)
      SELECT day_type, from_time, to_time, period, reserved_time FROM WORK_TIME_DAY_TYPE_DESC_TAB;

   INSERT INTO WT_DAY_TYPE_GEN_TAB (day_type, description, connect_next)
      SELECT day_type, description, connect_next FROM WORK_TIME_DAY_TYPE_TAB;

   INSERT INTO WT_SCHEDULE_DESC_GEN_TAB (schedule, period_pos, period_day, day_type)
      SELECT schedule, period_pos, period_day, day_type FROM WORK_TIME_SCHEDULE_DESC_TAB;

   INSERT INTO WT_SCHEDULE_GEN_TAB (schedule, description, period_length, period_start_day)
      SELECT schedule, description, period_length, period_start_day FROM WORK_TIME_SCHEDULE_TAB;

   INSERT INTO WT_EXCEPTION_CODE_GEN_TAB (exception_code, exception_date, day_type)
      SELECT exception_code, exception_date, day_type FROM WORK_TIME_EXCEPTION_CODE_TAB;

   INSERT INTO WT_EXCEPTION_GEN_TAB (exception_code, description)
      SELECT exception_code, description FROM WORK_TIME_EXCEPTION_TAB;

   INSERT INTO WT_CALENDAR_DESC_GEN_TAB (calendar_id, start_date, end_date, schedule)
      SELECT calendar_id, start_date, end_date, schedule FROM WORK_TIME_CALENDAR_DESC_TAB;

   INSERT INTO WT_CALENDAR_GEN_TAB (calendar_id, description, exception_code, objstate)
      SELECT calendar_id, description, exception_code, rowstate FROM WORK_TIME_CALENDAR_TAB;
END Copy_Rules___;


-- Truncate_Seconds___
--   Returns the bypassed timestamp with truncated seconds.
--   If user happens to enter seconds, remove them.
--   Used e.g. in the Unpack_Check_... methods
FUNCTION Truncate_Seconds___ (
   timestamp_ IN DATE ) RETURN DATE
IS
BEGIN
   RETURN to_date(to_char(timestamp_, 'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI');
END Truncate_Seconds___;


-- Is_Generated___
--   This method makes an exist control and if calendar isn't generated,
--   an error is raised.
--   The method is used from all methods in the public interface
--   (among others functions with pragma).
FUNCTION Is_Generated___ (
   calendar_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   found_      BOOLEAN := TRUE;
   error_text_ VARCHAR2(2000);
BEGIN
   Update_Cache___ (calendar_id_);
   IF micro_cache_objstate_ = 'NotGenerated' THEN
      found_ := FALSE;
      -- Use the Oracle-method to be able to display the error message from pragma functions.
      -- Format the message as in Error_SYS.Appl_General - <LU name>.<message name constant>: <text>
      error_text_ := Language_SYS.Translate_Constant(lu_name_, 'NOT_GENERATED: The calendar :P1 has not been generated yet!', NULL, calendar_id_);
      raise_application_error(-20105, lu_name_ || '.NOT_GENERATED: ' || error_text_);
   END IF;
   RETURN found_;
END Is_Generated___;


-- Is_Calendar_Executing___
--   Returns whether or not any calendar has been added to the background
--   job queue with status Executing.
--   If "this" job is executing, return if there are any other calendars
--   being generated.
FUNCTION Is_Calendar_Executing___ RETURN BOOLEAN
IS
   executing_      BOOLEAN := FALSE;
   count_          NUMBER;
   this_job_       NUMBER;
   job_id_tab_     Message_SYS.name_table;
   attrib_tab_     Message_SYS.line_table;
   msg_            VARCHAR2(32000);
BEGIN
-- Check if there are any jobs with status Executing
   Transaction_SYS.Get_Executing_Job_Arguments(msg_, 'WORK_TIME_CALENDAR_API.Set_Calendar_Generated__');
   Message_Sys.Get_Attributes(msg_, count_, job_id_tab_, attrib_tab_);
   IF (count_ > 0) THEN
      -- if "this" job hasn't been posted yet, return TRUE...
      IF NOT Transaction_SYS.Is_Session_Deferred THEN
         executing_ := TRUE;
       -- ... otherwise "this" job is executing in the background.
      ELSE
         -- loop through all jobs and if another job is found that
         -- doesn't equal "this" job, return TRUE
         this_job_ := Transaction_SYS.Get_Current_Job_Id;
         WHILE (count_ > 0) LOOP
            IF (this_job_ != job_id_tab_(count_)) THEN
               executing_ := TRUE;
               EXIT; -- loop
            END IF;
            count_ := count_ - 1;
         END LOOP;
      END IF;
   END IF;
   RETURN executing_;
END Is_Calendar_Executing___;


-- Not_Empty___
--   If empty, display an error message.
FUNCTION Not_Empty___ (
   rec_  IN     WORK_TIME_CALENDAR_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   -- A non-empty calendar has one or more detail rows
   IF Work_Time_Calendar_Desc_API.Exist_Calendar__(rec_.calendar_id) THEN
      RETURN TRUE;
   ELSE
      Error_SYS.Record_General(lu_name_, 'CAL_EMPTY: The calendar :P1 is empty and can not be generated!', rec_.calendar_id);
   END IF;
END Not_Empty___;


-- Calendar_Changed___
--   Regenerates the calendar and tells other LU's when it's finished if
--   a calendar isn't already generating - then raise an error.
PROCEDURE Calendar_Changed___ (
   rec_  IN OUT WORK_TIME_CALENDAR_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   forward_changes_ BOOLEAN := (nvl(Client_SYS.Get_Item_Value('FORWARD_CHANGES', attr_), '0') = '1');
BEGIN

   -- Check if any other calendar batch is already running
   IF Is_Calendar_Executing___ THEN
      Error_SYS.Record_General(lu_name_, 'CAL_EXECUTING: A calendar is already being generated. When that job is finished you can restart this one.');
   END IF;

   -- Generate the work day vectors
   Reset_Counters___(rec_);

   -- Tell other LU's that the calendar has been regenerated
   -- (only if it has been generated before - not the first time,
   --  since you cannot connect a calendar before it has been generated).
   -- Also check the forward changes flag. IF FALSE, the call is made from the Default insert script -
   -- then it should not be executed.
   IF ((rec_.rowstate != 'NotGenerated') AND forward_changes_) THEN
      Forward_Changes___(rec_.calendar_id);
   END IF;

   -- Tell the user who started this operation, that the calendar has been generated
   -- (via the Event server).
   Send_Event_Message___(rec_.calendar_id);
END Calendar_Changed___;


-- Display_Message___
--   Displays a message when calendar has been invalidated.
--   Only add message if calendar is not already present in the
--   Client_SYS's info variable. Otherwise the message can be displayed for
--   the same calendar more than once.
PROCEDURE Display_Message___ (
   rec_  IN OUT WORK_TIME_CALENDAR_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   info_        VARCHAR2(2000);
   type_        VARCHAR2(35);
   msg_         VARCHAR2(2000);
   ptr_         NUMBER;
   updmsg_      VARCHAR2(2000);
BEGIN
   -- translate message that will be displayed
   updmsg_ := Language_SYS.Translate_Constant(lu_name_, 'CAL_UPDATED: The calendar :P1 has to be generated to work correctly!', NULL, rec_.calendar_id);
   -- Get all info
   info_ := Client_SYS.Get_All_Info;

   -- Unpack message and add it back to the Client_SYS's info
   IF (info_ IS NOT NULL) THEN
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(info_, ptr_, type_, msg_)) LOOP
         -- add msg_ if it's not the same message as the one being added last in this method
         IF ((type_ = 'INFO') AND (msg_ != updmsg_)) THEN
            Client_SYS.Add_Info(lu_name_, msg_);
         ELSIF (type_ = 'WARNING') THEN
            Client_SYS.Add_Warning(lu_name_, msg_);
         END IF;
      END LOOP;
   END IF;

   -- Add message for this calendar
   Client_SYS.Add_Info(lu_name_, updmsg_);
END Display_Message___;


@Override
PROCEDURE Finite_State_Set___ (
   rec_   IN OUT WORK_TIME_CALENDAR_TAB%ROWTYPE,
   state_ IN     VARCHAR2 )
IS
BEGIN
   super(rec_, state_);
   Invalidate_Micro_Cache___;
END Finite_State_Set___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     WORK_TIME_CALENDAR_TAB%ROWTYPE,
   newrec_     IN OUT WORK_TIME_CALENDAR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   info_ VARCHAR2(2000) := NULL;
   temp_ VARCHAR2(2000);
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   Invalidate_Micro_Cache___;

   -- IF exception code has changed and state is Generated, invalidate calendar.
   IF (nvl(oldrec_.exception_code, ' ') != nvl(newrec_.exception_code, ' ')) THEN
      Set_Pending__(info_, objid_, objversion_, temp_, 'DO');
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Raise_Record_Not_Exist___ (
   calendar_id_ IN VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   Error_SYS.Record_Not_Exist(lu_name_, p1_ => calendar_id_);
   super(calendar_id_);
   --Add post-processing code here
END Raise_Record_Not_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-- Set_Calendar_Generated__
--   Used via Deferred call from public Set_Calendar_Generated to set a
--   calendar to Generated - sets calendar's state to Valid
--   and recalculates the calendar.
PROCEDURE Set_Calendar_Generated__ (
   attr_ IN VARCHAR2 )
IS
   info_        VARCHAR2(2000);
   flag_attr_   VARCHAR2(2000) := NULL;
   objid_       WORK_TIME_CALENDAR.objid%TYPE;
   objversion_  WORK_TIME_CALENDAR.objversion%TYPE;
   calendar_id_ WORK_TIME_CALENDAR_TAB.calendar_id%TYPE := Client_SYS.Get_Item_Value('CALENDAR_ID', attr_);
BEGIN
   -- This method is called via Deferred_Call from Set_Calendar_Generated to recalculate calendar and
   -- tell other LU's using the calendar that it has been changed.
   Get_Id_Version_By_Keys___(objid_, objversion_, calendar_id_);
   IF (objid_ IS NOT NULL) THEN
      -- move the forward flag to the flag attr string
      Client_SYS.Add_To_Attr('FORWARD_CHANGES', Client_SYS.Get_Item_Value('FORWARD_CHANGES', attr_), flag_attr_);
      Set_Generated__(info_, objid_, objversion_, flag_attr_, 'DO');
   END IF;
END Set_Calendar_Generated__;


-- Forward_Changes__
--   This method is called via Deferred_Call from Calendar_Switched to tell
--   other LU's using the calendar that it has been switched on e.g. a site.
PROCEDURE Forward_Changes__ (
   attr_ IN VARCHAR2 )
IS
   calendar_id_ WORK_TIME_CALENDAR_TAB.calendar_id%TYPE := Client_SYS.Get_Item_Value('CALENDAR_ID', attr_);
BEGIN
   Forward_Changes___(calendar_id_, Client_SYS.Get_Item_Value('CONTRACT', attr_));
END Forward_Changes__;


@Override
PROCEDURE Set_Pending__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   tmp_info_ VARCHAR2(32000);
BEGIN
   tmp_info_ := Client_SYS.Get_All_Info;
   super(info_, objid_, objversion_, attr_, action_);
   Client_SYS.Merge_Info(tmp_info_);
END Set_Pending__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------




-- Get_Day_Type
--   Returns the stored work day's day type. If calendar's not generated an
--   error appears.
@UncheckedAccess
FUNCTION Get_Day_Type (
   calendar_id_ IN VARCHAR2,
   curr_date_ IN DATE ) RETURN VARCHAR2
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (curr_date_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_API.Get_Day_Type__(calendar_id_, trunc(curr_date_));
   ELSE
      RETURN NULL;
   END IF;
END Get_Day_Type;


-- Set_Exception_Pending
--   Called from Exception LU to invalidate any calendar using that
--   specific calendar.
PROCEDURE Set_Exception_Pending (
   exception_code_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);

   CURSOR get_calendar IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM WORK_TIME_CALENDAR_TAB
      WHERE exception_code = exception_code_
      AND calendar_id > ' ';
BEGIN
   FOR rec_ IN get_calendar LOOP
      Set_Pending__(info_, rec_.objid, rec_.objversion, attr_, 'DO');
   END LOOP;
END Set_Exception_Pending;


-- Set_Calendar_Generated
--   Called from the client form to recalculate the calendar.
--   Uses deferred call to speed up the process.
PROCEDURE Set_Calendar_Generated (
   calendar_id_ IN VARCHAR2,
   forward_changes_ IN NUMBER DEFAULT 1 )
IS
  description_  VARCHAR2(2000);
  attr_         VARCHAR2(2000) := NULL;
BEGIN
   -- This method is called from Calendar client form to set the calendar as Generated.
   -- Use deferred call to avoid locking the client during execution.

   Exist(calendar_id_);

   -- Check if any calendar batch is already running
   IF Is_Calendar_Executing___ THEN
      Error_SYS.Record_General(lu_name_, 'CAL_EXECUTING: A calendar is already being generated. When that job is finished you can restart this one.');
   END IF;

   -- Before entering batch mode check that the calendar is setup correctly.
   Check_Correct___(calendar_id_);

   description_ := Language_SYS.Translate_Constant(lu_name_, 'GENERATE_CALENDAR: Generate Work Time Calendar');
   Client_SYS.Add_To_Attr('CALENDAR_ID', calendar_id_, attr_);
   -- flag used to check if the Calendar_Changed methods in all packages is to be executed.
   Client_SYS.Add_To_Attr('FORWARD_CHANGES', forward_changes_, attr_);
   Transaction_SYS.Deferred_Call('WORK_TIME_CALENDAR_API.Set_Calendar_Generated__', attr_, description_);
--   WORK_TIME_CALENDAR_API.Set_Calendar_Generated__(attr_);
END Set_Calendar_Generated;


-- Set_Calendar_Pending
--   Invalidates a calendar - when anything has changed in that LU or
--   any of the connected schedules has changed.
--   Called from the WorkTimeCalendarDesc LU.
PROCEDURE Set_Calendar_Pending (
   calendar_id_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   dummy_      VARCHAR2(2000) := NULL;
   objid_      WORK_TIME_CALENDAR.objid%TYPE;
   objversion_ WORK_TIME_CALENDAR.objversion%TYPE;
   CURSOR get_object IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM WORK_TIME_CALENDAR_TAB
      WHERE calendar_id = calendar_id_;
BEGIN
   OPEN get_object;
   FETCH get_object INTO objid_, objversion_;
   CLOSE get_object;
   IF (objid_ IS NOT NULL) THEN
      Set_Pending__(info_, objid_, objversion_, dummy_, 'DO');
   END IF;
END Set_Calendar_Pending;


-- Enumerate_Days
--   Tells the client how to display holidays in calendar GUI component.
--   If bypassed calendar id doesn't exist, it raises an error message.
PROCEDURE Enumerate_Days (
   holidays_ IN OUT VARCHAR2,
   highlight_days_ IN OUT VARCHAR2,
   calendar_id_ IN VARCHAR2,
   year_ IN NUMBER,
   month_ IN NUMBER )
IS
  from_   DATE;
  to_     DATE;
BEGIN
   IF Is_Generated___(calendar_id_) THEN
      holidays_ := NULL;
      highlight_days_ := NULL; -- not used for now
      IF (length(to_char(nvl(year_, 0))) != 4) THEN
         Error_SYS.Record_General(lu_name_, 'NOT_FOUR_DIGITS: Year must be four digits long!');
      ELSIF ((nvl(month_, 0) < 1) OR (nvl(month_, 0) > 12)) THEN
         Error_SYS.Record_General(lu_name_, 'INVALID_MONTH: Not a valid month (:P1)!', nvl(month_, 0));
      END IF;
      from_ := to_date(to_char(year_) || '-' || lpad(to_char(month_), 2, '0') || '-01', Report_SYS.date_format_); -- first of the month
      Trace_SYS.Field('from date', from_);
      to_ := add_months(from_, 1) - 1; -- last of the month
      Trace_SYS.Field('to date', to_);
      -- loop through the whole month
      LOOP
         -- Get_Counter__ returns NULL if not a working day
         IF (Work_Time_Counter_API.Get_Counter__(calendar_id_, trunc(from_)) IS NULL) THEN
            -- the below conversion is to remove the initiated 0 if the day is less than 10
            holidays_ := holidays_ || to_char(to_number(to_char(from_, 'DD'))) || Client_SYS.field_separator_;
         ELSE
            Trace_SYS.Message(to_char(from_, Report_SYS.date_format_) || ' is a working day!');
         END IF;
         EXIT WHEN (from_ = to_);
         from_ := from_ + 1;
      END LOOP;
      IF (holidays_ IS NULL) THEN
         Trace_SYS.Message('No holidays found for month ' || to_char(nvl(month_, 0)) || '!');
      ELSE
         Trace_SYS.Field('holidays_', holidays_);
      END IF;
   ELSE
      Error_SYS.Record_Not_Exist(lu_name_, p1_ => calendar_id_);
   END IF;
END Enumerate_Days;


-- Get_Min_Work_Day_Counter
--   Returns the counter for the first workday in the calendar.
@UncheckedAccess
FUNCTION Get_Min_Work_Day_Counter (
   calendar_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF Is_Generated___(calendar_id_) THEN
      RETURN Work_Time_Counter_API.Get_Min_Counter__(calendar_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Min_Work_Day_Counter;


-- Get_Max_Work_Day_Counter
--   Returns the counter for the last workday in the calendar.
@UncheckedAccess
FUNCTION Get_Max_Work_Day_Counter (
   calendar_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF Is_Generated___(calendar_id_) THEN
      RETURN Work_Time_Counter_API.Get_Max_Counter__(calendar_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Max_Work_Day_Counter;


-- Get_Min_Work_Day
--   Returns the date for the first workday in the calendar.
@UncheckedAccess
FUNCTION Get_Min_Work_Day (
   calendar_id_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   IF Is_Generated___(calendar_id_) THEN
      RETURN Work_Time_Counter_API.Get_Min_Work_Day__(calendar_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Min_Work_Day;


-- Get_Max_Work_Day
--   Returns the date for the last workday in the calendar.
@UncheckedAccess
FUNCTION Get_Max_Work_Day (
   calendar_id_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   IF Is_Generated___(calendar_id_) THEN
      RETURN Work_Time_Counter_API.Get_Max_Work_Day__(calendar_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Max_Work_Day;


-- Get_Next_Work_Day
--   Returns the workday next after a certain date.
@UncheckedAccess
FUNCTION Get_Next_Work_Day (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_API.Get_Next_Work_Day__(calendar_id_, NULL, trunc(work_day_));
   ELSE
      RETURN NULL;
   END IF;
END Get_Next_Work_Day;


-- Get_Work_Day_For_Time
--   Returns the work date for a specific point in time.
@UncheckedAccess
FUNCTION Get_Work_Day_For_Time (
   calendar_id_ IN VARCHAR2,
   date_time_ IN DATE ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (date_time_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_Desc_API.Get_Work_Day_For_Time__(calendar_id_, date_time_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Work_Day_For_Time;


-- Get_Previous_Work_Day_For_Time
--   Returns the workday prior to a specific point in time.
--   If previous work day doesn't exist, NULL is returned.
@UncheckedAccess
FUNCTION Get_Previous_Work_Day_For_Time (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_Desc_API.Get_Prev_Work_Day_For_Time__(calendar_id_, work_day_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Previous_Work_Day_For_Time;


-- Get_Next_Work_Day_For_Time
--   Returns the workday next after a specific point in time.
@UncheckedAccess
FUNCTION Get_Next_Work_Day_For_Time (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_Desc_API.Get_Next_Work_Day_For_Time__(calendar_id_,work_day_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Next_Work_Day_For_Time;


-- Get_Previous_Work_Day
--   Returns the workday prior to a certain date.
--   If previous work day doesn't exist, NULL is returned.
@UncheckedAccess
FUNCTION Get_Previous_Work_Day (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_API.Get_Previous_Work_Day__(calendar_id_, NULL, trunc(work_day_));
   ELSE
      RETURN NULL;
   END IF;
END Get_Previous_Work_Day;


-- Get_Closest_Work_Day
--   If work day doesn't exist, it returns next work day - otherwise work day.
--   If next work day doesn't exist, an error is raised (no pragma method).
FUNCTION Get_Closest_Work_Day (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_API.Get_Closest_Work_Day__(calendar_id_, trunc(work_day_));
   ELSE
      RETURN NULL;
   END IF;
END Get_Closest_Work_Day;


-- Get_Nearest_Work_Day
--   If work day doesn't exist, it returns next work day - otherwise work day.
--   If next work day doesn't exist, NULL is returned.
@UncheckedAccess
FUNCTION Get_Nearest_Work_Day (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_API.Get_Nearest_Work_Day__(calendar_id_, trunc(work_day_));
   ELSE
      RETURN NULL;
   END IF;
END Get_Nearest_Work_Day;


-- Get_Prior_Work_Day
--   If work day doesn't exist, it returns previous work day - otherwise work day.
--   If previous work day doesn't exist, NULL is returned.
@UncheckedAccess
FUNCTION Get_Prior_Work_Day (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_API.Get_Prior_Work_Day__(calendar_id_, NULL, trunc(work_day_));
   ELSE
      RETURN NULL;
   END IF;
END Get_Prior_Work_Day;


-- Get_Prev_Work_Day_And_Counter
--   Returns the workday and counter prior to a certain date.
--   If previous work day doesn't exist, NULL is returned.
--   Requested by MRP.
PROCEDURE Get_Prev_Work_Day_And_Counter (
   counter_ IN OUT NUMBER,
   work_day_ IN OUT DATE,
   calendar_id_ IN VARCHAR2 )
IS
   prev_day_  DATE;
   CURSOR get_previous IS
      SELECT counter, work_day
      FROM WORK_TIME_COUNTER
      WHERE work_day < trunc(work_day_)
      AND calendar_id = calendar_id_
      ORDER BY work_day DESC;
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      OPEN get_previous;
      FETCH get_previous INTO counter_, prev_day_;
      IF get_previous%NOTFOUND THEN
         prev_day_ := NULL;
         counter_ := NULL;
      END IF;
      CLOSE get_previous;
      work_day_ := prev_day_;
   ELSE
      work_day_ := NULL;
      counter_ := NULL;
   END IF;
END Get_Prev_Work_Day_And_Counter;


-- Get_Next_Work_Minute
--   Returns the next work minute closest to a certain date and time.
@UncheckedAccess
FUNCTION Get_Next_Work_Minute (
   calendar_id_ IN VARCHAR2,
   work_time_ IN DATE ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_time_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_Desc_API.Get_Next_Work_Minute__(calendar_id_, Truncate_Seconds___(work_time_));
   ELSE
      RETURN NULL;
   END IF;
END Get_Next_Work_Minute;


-- Get_Previous_Work_Minute
--   Returns the previous work minute closest to a certain date and time.
@UncheckedAccess
FUNCTION Get_Previous_Work_Minute (
   calendar_id_ IN VARCHAR2,
   work_time_ IN DATE ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_time_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_Desc_API.Get_Previous_Work_Minute__(calendar_id_, Truncate_Seconds___(work_time_));
   ELSE
      RETURN NULL;
   END IF;
END Get_Previous_Work_Minute;


-- Get_Work_Day_Counter
--   Returns the counter for a certain workday date.
@UncheckedAccess
FUNCTION Get_Work_Day_Counter (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN NUMBER
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_API.Get_Counter__(calendar_id_, trunc(work_day_));
   ELSE
      RETURN NULL;
   END IF;
END Get_Work_Day_Counter;


-- Get_Work_Day
--   Returns the date from work day counter.
@UncheckedAccess
FUNCTION Get_Work_Day (
   calendar_id_ IN VARCHAR2,
   counter_ IN NUMBER ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (counter_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_API.Get_Work_Day(calendar_id_, counter_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Work_Day;


-- Get_Work_Day_Minutes
--   Returns the number of work minutes for a certain work day date or counter
--   and period (optional).
--   If the optional period parameter is used, only the minutes for that period
--   of the day are returned.The number of work minutes can easily be converted into
--   other time units like hours.
@UncheckedAccess
FUNCTION Get_Work_Day_Minutes (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE,
   period_ IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   minutes_ NUMBER := NULL;
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      IF (period_ IS NULL) THEN
         minutes_ := Work_Time_Counter_API.Get_Working_Time__(calendar_id_, trunc(work_day_));
      ELSE
         minutes_ := Work_Time_Counter_Desc_API.Get_Working_Time__(calendar_id_, trunc(work_day_), period_);
      END IF;
   END IF;
   RETURN minutes_;
END Get_Work_Day_Minutes;


-- Get_Work_Day_Periods
--   Returns the number of working periods for a certain work day date.
@UncheckedAccess
FUNCTION Get_Work_Day_Periods (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN NUMBER
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_API.Get_Working_Periods__(calendar_id_, trunc(work_day_));
   ELSE
      RETURN NULL;
   END IF;
END Get_Work_Day_Periods;


-- Get_Work_Days_Between
--   Returns the number of workdays between two dates.
--   (Workin days are definied with X)
--   Sun Mon Tue Wed Thu Fri Sat
--   --- --- --- --- --- --- ---
--   X   X       X   X
--   If you query # days between Sun and Fri you get 4 days
--   If between Sun and Sat you also get 4 days
--   If between Tue and Thu you get 1 day
--   If between Wed and Sat you get 2 days
--   If between Mon and Fri you get 3 days
@UncheckedAccess
FUNCTION Get_Work_Days_Between (
   calendar_id_ IN VARCHAR2,
   from_date_ IN DATE,
   to_date_ IN DATE ) RETURN NUMBER
IS
   days_  NUMBER := NULL;

   CURSOR get_days IS
      SELECT count(*)
      FROM WORK_TIME_COUNTER_TAB
      WHERE work_day > trunc(from_date_) AND work_day <= trunc(to_date_)
      AND calendar_id = calendar_id_;
BEGIN
   IF Is_Generated___(calendar_id_) THEN
      IF ((from_date_ IS NOT NULL) AND (to_date_ IS NOT NULL) AND (trunc(from_date_) <= trunc(to_date_))) THEN
         OPEN get_days;
         FETCH get_days INTO days_;
         IF (get_days%NOTFOUND) THEN
            days_ := 0;
         END IF;
         CLOSE get_days;
      END IF;
   END IF;
   RETURN days_;
END Get_Work_Days_Between;


-- Get_Work_Minutes_Between
--   Returns the number of work minutes between two timestamps.
@UncheckedAccess
FUNCTION Get_Work_Minutes_Between (
   calendar_id_      IN VARCHAR2,
   from_time_        IN DATE,
   to_time_          IN DATE,
   round_off_        IN VARCHAR2 DEFAULT 'TRUE' ) RETURN NUMBER
IS
   minutes_ NUMBER := NULL;
BEGIN
   IF Is_Generated___(calendar_id_) THEN
      IF ((from_time_ IS NOT NULL) AND (to_time_ IS NOT NULL) AND (from_time_ <= to_time_)) THEN
         IF (round_off_ = 'TRUE') THEN
            minutes_ := Work_Time_Counter_Desc_API.Get_Working_Time_Between__(calendar_id_, Truncate_Seconds___(from_time_), Truncate_Seconds___(to_time_));
         ELSE
            minutes_ := Work_Time_Counter_Desc_API.Get_Working_Time_Between__(calendar_id_, from_time_, to_time_, round_off_);
         END IF;
      END IF;
   END IF;
   RETURN minutes_;
END Get_Work_Minutes_Between;


-- Is_Working_Day
--   Returns true if a certain date is a working day.
--   A working day is defined as a day that has a day type that includes working time.
--   This means that the working time may overlap into the next day or the previous day.
@UncheckedAccess
FUNCTION Is_Working_Day (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN NUMBER
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      IF (Work_Time_Counter_API.Get_Counter__(calendar_id_, trunc(work_day_)) IS NOT NULL) THEN
         RETURN 1;
      ELSE
         RETURN 0;
      END IF;
   ELSE
      RETURN NULL;
   END IF;
END Is_Working_Day;


-- Is_Working_Time
--   Returns 1 (true) if certain date and time is working time.
@UncheckedAccess
FUNCTION Is_Working_Time (
   calendar_id_ IN VARCHAR2,
   work_time_ IN DATE ) RETURN NUMBER
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_time_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_Desc_API.Is_Working_Time__(calendar_id_, Truncate_Seconds___(work_time_));
   ELSE
      RETURN NULL;
   END IF;
END Is_Working_Time;


-- Get_Day_Info_For_Time
--   Returns a calendar day's start time, end time, working time (in minutes)
--   and number of periods for a specific point in time (no trunc of dates as
--   in Get_Day_Info.
PROCEDURE Get_Day_Info_For_Time (
   start_time_ IN OUT DATE,
   end_time_ IN OUT DATE,
   minutes_ IN OUT NUMBER,
   periods_ IN OUT NUMBER,
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE )
IS
   date_        DATE;

   CURSOR get_info IS
      SELECT working_time, working_periods
      FROM WORK_TIME_COUNTER_TAB
      WHERE work_day = trunc(date_)
      AND calendar_id = calendar_id_;
BEGIN
   date_ := work_day_;
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      start_time_ := Work_Time_Counter_Desc_API.Get_Start_Time_For_Time__(calendar_id_, date_);
      end_time_ := Work_Time_Counter_Desc_API.Get_End_Time_For_Time__(calendar_id_, date_);
      date_ := Get_Work_Day_For_Time (calendar_id_, work_day_);
      OPEN get_info;
      FETCH get_info INTO minutes_, periods_;
      CLOSE get_info;
      minutes_ := nvl(minutes_, 0);
      periods_ := nvl(periods_, 0);
   ELSE
      start_time_ := NULL;
      end_time_ := NULL;
      minutes_ := NULL;
      periods_ := NULL;
   END IF;
END Get_Day_Info_For_Time;


-- Is_Working_Time_For_Time
--   Returns true if certain date and time is working time. Unlike Is_Working_Time
--   this method does not trucate seconds, so the whole time slice is validated
--   not just discrete minutes.
@UncheckedAccess
FUNCTION Is_Working_Time_For_Time (
   calendar_id_ IN VARCHAR2,
   work_time_ IN DATE ) RETURN NUMBER
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_time_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_Desc_API.Is_Working_Time_For_Time__(calendar_id_, work_time_);
   ELSE
      RETURN NULL;
   END IF;
END Is_Working_Time_For_Time;


-- Get_End_Time
--   Calculates when some activity will end if it has a certain duration
--   and you start it at a certain date and time, provided the calendar is
--   the only constraint.If anything is wrong, NULL is returned.
@UncheckedAccess
FUNCTION Get_End_Time (
   calendar_id_ IN VARCHAR2,
   start_time_ IN DATE,
   duration_ IN NUMBER,
   round_off_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN DATE
IS
   time_      DATE := NULL;
   left_      NUMBER;
   minutes_   NUMBER;
   first_row_ BOOLEAN := TRUE;

   CURSOR get_record IS
      SELECT --+INDEX(WORK_TIME_COUNTER_DESC_TAB WORK_TIME_COUNTER_DESC_IX3)
           start_time, end_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE end_time >= start_time_
      AND calendar_id = calendar_id_
      ORDER BY end_time;
BEGIN
   IF (Is_Generated___(calendar_id_) AND (start_time_ IS NOT NULL)) THEN
      IF (nvl(duration_, 0) > 0) THEN
         left_ := duration_;
         FOR rec_ IN get_record LOOP
            -- for the first lap, the start time might be less than the bypassed
            -- value. Set start time to that value instead and count from there.
            IF first_row_ THEN
               IF (rec_.start_time < start_time_) THEN
                    rec_.start_time := start_time_;

               END IF;
               first_row_ := FALSE;
            END IF;
            
            IF (round_off_ = 'TRUE') THEN
                minutes_ := round(to_number(rec_.end_time - rec_.start_time) * 1440);
            ELSE
                minutes_ := to_number(rec_.end_time - rec_.start_time) * 1440;
            END IF;
            
            -- if there are more minutes left, than interval's length...
            IF (minutes_ < left_) THEN
               time_ := rec_.start_time + to_number(rec_.end_time - rec_.start_time);
               left_ := left_ - minutes_;
            ELSE
               time_ := rec_.start_time + (left_ / 1440);
               left_ := 0;
            END IF;
            EXIT WHEN (left_ <= 0);
         END LOOP;
      -- if start time is within a working period, return it (duration <= 0)
      ELSIF (Work_Time_Counter_Desc_API.Is_Working_Time__(calendar_id_, Truncate_Seconds___(start_time_)) = 1) THEN
         time_ := start_time_;
      -- Otherwise return next working minute.
      ELSE
         time_ := Work_Time_Counter_Desc_API.Get_Next_Work_Minute__(calendar_id_, Truncate_Seconds___(start_time_));
      END IF;
   END IF;
   RETURN time_;
END Get_End_Time;


-- Get_End_Time_For_Time
--   Calculates when some activity will end if it has a certain duration
--   and you start it at a certain date and time, provided the calendar is
--   the only constraint. If anything is wrong, NULL is returned. This method
--   eliminates problems with the first minute of a time slice.
--   (and also Unlike GetEndTime, this method eliminates problems caused by trunc)
@UncheckedAccess
FUNCTION Get_End_Time_For_Time (
   calendar_id_ IN VARCHAR2,
   start_time_ IN DATE,
   duration_ IN NUMBER ) RETURN DATE
IS
   time_      DATE := NULL;
   left_      NUMBER;
   minutes_   NUMBER;
   first_row_ BOOLEAN := TRUE;

   CURSOR get_record IS
      SELECT start_time, end_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE end_time >= start_time_
      AND calendar_id = calendar_id_
      ORDER BY start_time;
BEGIN
   IF (Is_Generated___(calendar_id_) AND (start_time_ IS NOT NULL)) THEN
      IF (nvl(duration_, 0) > 0) THEN
         left_ := duration_;
         FOR rec_ IN get_record LOOP
            -- for the first lap, the start time might be less than the bypassed
            -- value. Set start time to that value instead and count from there.
            IF first_row_ THEN
               IF (rec_.start_time < start_time_) THEN
                  rec_.start_time := Truncate_Seconds___(start_time_);
               END IF;
               first_row_ := FALSE;
            END IF;
            minutes_ := round(to_number(rec_.end_time - rec_.start_time) * 1440);
            -- if there are more minutes left, than interval's length...
            IF (minutes_ < left_) THEN
               time_ := rec_.start_time + to_number(rec_.end_time - rec_.start_time);
               left_ := left_ - minutes_;
            ELSE
               time_ := rec_.start_time + (left_ / 1440);
               left_ := 0;
            END IF;
            EXIT WHEN (left_ <= 0);
         END LOOP;
      -- if start time is within a working period, return it (duration <= 0)
      ELSIF (Work_Time_Counter_Desc_API.Is_Working_Time_For_Time__(calendar_id_, start_time_) = 1) THEN
         time_ := start_time_;
      -- Otherwise return next working minute.
      ELSE
         time_ := Work_Time_Counter_Desc_API.Get_Next_Work_Minute_By_Time__(calendar_id_, Truncate_Seconds___(start_time_));
      END IF;
   END IF;
   RETURN time_;
END Get_End_Time_For_Time;


-- Get_Work_Day_End_Time
--   Returns the work day's latest timestamp.
--   This may be the day after the bypassed date.
@UncheckedAccess
FUNCTION Get_Work_Day_End_Time (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_Desc_API.Get_End_Time__(calendar_id_, trunc(work_day_));
   ELSE
      RETURN NULL;
   END IF;
END Get_Work_Day_End_Time;


-- Get_End_Date
--   Calculates when some activity will end if it has a certain duration
--   and you start it at a certain date, provided the calendar is the only
@UncheckedAccess
FUNCTION Get_End_Date (
   calendar_id_ IN VARCHAR2,
   start_date_ IN DATE,
   duration_ IN NUMBER ) RETURN DATE
IS
   date_ DATE := NULL;
   left_ NUMBER;

   CURSOR get_record IS
      SELECT work_day
      FROM WORK_TIME_COUNTER_TAB
      WHERE work_day > trunc(start_date_)
      AND calendar_id = calendar_id_
      ORDER BY work_day;
BEGIN
   IF (Is_Generated___(calendar_id_) AND (start_date_ IS NOT NULL)) THEN
      IF (nvl(duration_, 0) > 0) THEN
         left_ := duration_;
         FOR rec_ IN get_record LOOP
            date_ := rec_.work_day;
            left_ := left_ - 1;
            EXIT WHEN (left_ <= 0);
         END LOOP;
      -- if start date is a working date, return it (duration is 0)
      ELSIF (Work_Time_Counter_API.Get_Counter__(calendar_id_, trunc(start_date_)) IS NOT NULL) THEN
         date_ := trunc(start_date_);
      -- otherwise return closest next work day.
      ELSE
         date_ := Get_Next_Work_Day(calendar_id_, start_date_);
      END IF;
   END IF;
   RETURN date_;
END Get_End_Date;


-- Get_Start_Time
--   Calculates when some activity will start if it has a certain duration
--   and you end it at a certain date and time, provided the calendar is
--   the only constraint. If something is wrong, NULL is returned.
@UncheckedAccess
FUNCTION Get_Start_Time (
   calendar_id_ IN VARCHAR2,
   end_time_ IN DATE,
   duration_ IN NUMBER,
   round_off_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN DATE
IS
   time_      DATE := NULL;
   left_      NUMBER;
   minutes_   NUMBER;
   first_row_ BOOLEAN := TRUE;

   CURSOR get_record IS
      SELECT start_time, end_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE start_time <= end_time_
      AND calendar_id = calendar_id_
      ORDER BY start_time DESC;
BEGIN
   IF (Is_Generated___(calendar_id_) AND (end_time_ IS NOT NULL)) THEN
      -- only loop if duration is greater than 0
      IF (nvl(duration_, 0) > 0) THEN
         left_ := duration_;
         FOR rec_ IN get_record LOOP
            -- for the first lap, the end time might be greater than the bypassed
            -- value. Set end time to that value instead and count from there.
            IF first_row_ THEN
               IF (rec_.end_time > end_time_) THEN
                  rec_.end_time := end_time_;
               END IF;
               first_row_ := FALSE;
            END IF;
            
            IF (round_off_ = 'TRUE') THEN
                minutes_ := round(to_number(rec_.end_time - rec_.start_time) * 1440);
            ELSE
                minutes_ := to_number(rec_.end_time - rec_.start_time) * 1440;
            END IF;
                
            -- if there are more minutes left, than interval's length...
            IF (minutes_ < left_) THEN
               time_ := rec_.end_time - to_number(rec_.end_time - rec_.start_time);
               left_ := left_ - minutes_;
            ELSE
               time_ := rec_.end_time - (left_ / 1440);
               left_ := 0;
            END IF;
            EXIT WHEN (left_ <= 0);
         END LOOP;
         RETURN time_;
      -- if end time is within a working period, return it (duration <= 0)
      ELSIF (Work_Time_Counter_Desc_API.Is_Working_Time__(calendar_id_, Truncate_Seconds___(end_time_)) = 1) THEN
         time_ := end_time_;
      -- otherwise return closest previous working minute
      ELSE
         time_ := Work_Time_Counter_Desc_API.Get_Previous_Work_Minute__(calendar_id_, Truncate_Seconds___(end_time_));
      END IF;
   END IF;
   RETURN time_;
END Get_Start_Time;


-- Get_Work_Day_Start_For_Time
--   Returns the work day's earliest timestamp including the first minute of a period.
--   This may be the day before the bypassed date.
--   (Unlike GetWorkDayStartTime, this method recognizes the first minute of a period).
@UncheckedAccess
FUNCTION Get_Work_Day_Start_For_Time (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_Desc_API.Get_Start_Time_For_Time__(calendar_id_, work_day_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Work_Day_Start_For_Time;


-- Get_Work_Day_Start_Time
--   Returns the work day's earliest timestamp.
--   This may be the day before the bypassed date.
@UncheckedAccess
FUNCTION Get_Work_Day_Start_Time (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_Desc_API.Get_Start_Time__(calendar_id_, trunc(work_day_));
   ELSE
      RETURN NULL;
   END IF;
END Get_Work_Day_Start_Time;


-- Get_Start_Date
--   Calculates when some activity will start if it has a certain duration
--   and you end it at a certain date, provided the calendar is the only
@UncheckedAccess
FUNCTION Get_Start_Date (
   calendar_id_ IN VARCHAR2,
   end_date_ IN DATE,
   duration_ IN NUMBER ) RETURN DATE
IS
   date_ DATE := NULL;
   left_ NUMBER;

   CURSOR get_record IS
      SELECT work_day
      FROM WORK_TIME_COUNTER_TAB
      WHERE work_day < trunc(end_date_)
      AND calendar_id = calendar_id_
      ORDER BY work_day DESC;
BEGIN
   IF (Is_Generated___(calendar_id_) AND (end_date_ IS NOT NULL)) THEN
      IF (nvl(duration_, 0) > 0) THEN
         left_ := duration_;
         FOR rec_ IN get_record LOOP
            date_ := rec_.work_day;
            left_ := left_ - 1;
            EXIT WHEN (left_ <= 0);
         END LOOP;
      -- if start date is a working date, return it (duration <= 0)
      ELSIF (Work_Time_Counter_API.Get_Counter__(calendar_id_, trunc(end_date_)) IS NOT NULL) THEN
         date_ := trunc(end_date_);
      -- otherwise return closest prior work day
      ELSE
         date_ := Get_Previous_Work_Day(calendar_id_, end_date_);
      END IF;
   END IF;
   RETURN date_;
END Get_Start_Date;


-- Get_Period
--   Returns the period from a certain date and time.
--   If it's not working time, NULL is returned.
@UncheckedAccess
FUNCTION Get_Period (
   calendar_id_ IN VARCHAR2,
   work_time_ IN DATE ) RETURN VARCHAR2
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_time_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_Desc_API.Get_Period__(calendar_id_, Truncate_Seconds___(work_time_));
   ELSE
      RETURN NULL;
   END IF;
END Get_Period;


-- Get_Period_Start
--   Returns the start date and time of a certain period on a certain date.
--   If period passes midnight the prior day, return that time.
@UncheckedAccess
FUNCTION Get_Period_Start (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE,
   period_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL) AND (period_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_Desc_API.Get_Period_Start__(calendar_id_, trunc(work_day_), period_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Period_Start;


-- Get_Period_End
--   Returns the end date and time of a certain period on a certain date.
--   If period passes midnight the next day, return that time.
@UncheckedAccess
FUNCTION Get_Period_End (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE,
   period_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL) AND (period_ IS NOT NULL)) THEN
      RETURN Work_Time_Counter_Desc_API.Get_Period_End__(calendar_id_, trunc(work_day_), period_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Period_End;


-- Get_Next_Period
--   Returns the next period and it's start and end time on the bypassed
--   working day (using from and to time).
--   If null is passed, the first period and it's time interval
--   is returned. If no more periods or the calendar hasn't been generated or
--   is non-existant, null is returned.
PROCEDURE Get_Next_Period (
   period_ IN OUT VARCHAR2,
   from_time_ IN OUT DATE,
   to_time_ IN OUT DATE,
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE )
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      Work_Time_Counter_Desc_API.Get_Next_Period__(period_, from_time_, to_time_, calendar_id_, trunc(work_day_));
   ELSE
      period_ := NULL;
      from_time_ := NULL;
      to_time_ := NULL;
   END IF;
END Get_Next_Period;


-- Get_Day_Info
--   Returns a calendar day's start time, end time, working time (in minutes)
--   and number of periods.
PROCEDURE Get_Day_Info (
   start_time_ IN OUT DATE,
   end_time_ IN OUT DATE,
   minutes_ IN OUT NUMBER,
   periods_ IN OUT NUMBER,
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE )
IS
   CURSOR get_info IS
      SELECT working_time, working_periods
      FROM WORK_TIME_COUNTER_TAB
      WHERE work_day = trunc(work_day_)
      AND calendar_id = calendar_id_;
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL)) THEN
      start_time_ := Work_Time_Counter_Desc_API.Get_Start_Time__(calendar_id_, trunc(work_day_));
      end_time_ := Work_Time_Counter_Desc_API.Get_End_Time__(calendar_id_, trunc(work_day_));
      OPEN get_info;
      FETCH get_info INTO minutes_, periods_;
      CLOSE get_info;
      minutes_ := nvl(minutes_, 0);
      periods_ := nvl(periods_, 0);
   ELSE
      start_time_ := NULL;
      end_time_ := NULL;
      minutes_ := NULL;
      periods_ := NULL;
   END IF;
END Get_Day_Info;


-- Exist_Period
--   Returns whether or not a certain period exist on a certain workday.
FUNCTION Exist_Period (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE,
   period_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF (Is_Generated___(calendar_id_) AND (work_day_ IS NOT NULL) AND (period_ IS NOT NULL)) THEN
      RETURN (Work_Time_Counter_Desc_API.Exist_Period__(calendar_id_, trunc(work_day_), period_) = 1);
   ELSE
      RETURN NULL;
   END IF;
END Exist_Period;


-- Exist_Numeric_Period
--   If there are only numeric periods (period values 1 through 9) for a
--   certain calendar, this method will return TRUE (1).
--   When calling this method, think the name Exist_Only_Numeric_Periods!
--   Requested by HR.
@UncheckedAccess
FUNCTION Exist_Numeric_Period (
   calendar_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF Is_Generated___(calendar_id_) THEN
      -- IF no other periods than numeric ones, check reserved time periods too
      IF (Work_Time_Counter_Desc_API.Exist_Numeric_Period__(calendar_id_) = 1) THEN
         RETURN Work_Time_Counter_Res_API.Exist_Numeric_Period__(calendar_id_);
      ELSE
         RETURN 0;
      END IF;
   ELSE
      RETURN NULL;
   END IF;
END Exist_Numeric_Period;


-- Calendar_Switched
--   Calls all LU's using the calendar LU to tell them that the user has in
--   some way switched from one calendar to another.
--   E.g. modified the calendar attribute on a site.
PROCEDURE Calendar_Switched (
   calendar_id_ IN VARCHAR2,
   contract_ IN VARCHAR2 DEFAULT NULL )
IS
  description_  VARCHAR2(2000);
  attr_         VARCHAR2(2000) := NULL;
BEGIN
   IF Is_Generated___(calendar_id_) THEN
      -- Use deferred call to avoid locking the client during execution.
      description_ := Language_SYS.Translate_Constant(lu_name_, 'SWITCH_CALENDAR: Switching calendar');
      Client_SYS.Add_To_Attr('CALENDAR_ID', calendar_id_, attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
      Transaction_SYS.Deferred_Call('WORK_TIME_CALENDAR_API.Forward_Changes__', attr_, description_);
   ELSE
      Error_SYS.Record_Not_Exist(lu_name_, p1_ => calendar_id_);
   END IF;
END Calendar_Switched;


-- Get_Week_Day
--   Returns the weekday name (using localized IID) for a specific date
@UncheckedAccess
FUNCTION Get_Week_Day (
   curr_date_ IN DATE ) RETURN VARCHAR2
IS
BEGIN
-- Jan 1st 1900 was a Monday. Use that date to calculate and pass correct DB value to the Decode method.
   RETURN Work_Time_Week_Day_API.Decode(to_char(mod(trunc(curr_date_) - to_date('19000101', 'YYYYMMDD', 'NLS_CALENDAR=GREGORIAN'), 7) + 1));
END Get_Week_Day;


PROCEDURE Add_Info_On_Pending (
   calendar_id_ IN VARCHAR2)
IS 
BEGIN
   IF (calendar_id_ IS NOT NULL) THEN

      Update_Cache___(calendar_id_);

      IF (micro_cache_objstate_ = 'ChangesPending') THEN
         Client_SYS.Add_Info(lu_name_, 'CAL_CHANGESPEND: Calendar :P1 has not been re-generated. Therefore any changes in the calendar will not affect the system.', calendar_id_);
      END IF;
   END IF;
END Add_Info_On_Pending;


PROCEDURE Check_Not_Generated (
   calendar_id_ IN VARCHAR2)
IS 
BEGIN
   IF (calendar_id_ IS NOT NULL) THEN

      Update_Cache___(calendar_id_);

      IF (micro_cache_objstate_ = 'NotGenerated') THEN
         Error_SYS.Record_General(lu_name_, 'CAL_NOTGEN: The calendar :P1 has not been generated and cannot be used.', calendar_id_);
      END IF;
   END IF;
END Check_Not_Generated;


-- Get_Start_Time_For_Time
--    If start time is valid to the calendar, it will return start time, if not, next valid start will be returned.
FUNCTION Get_Start_Time_For_Time(
   calendar_id_ IN VARCHAR2,
   start_time_  IN DATE) RETURN DATE
IS
   new_start_time_   DATE;
BEGIN
   IF (Is_Generated___(calendar_id_) AND (start_time_ IS NOT NULL)) THEN
      IF Work_Time_Counter_Desc_API.Check_Valid_Start_Time(calendar_id_, start_time_) THEN
         new_start_time_ := start_time_;
      ELSE
         new_start_time_ := Work_Time_Counter_Desc_API.Get_New_Start_Time(calendar_id_, start_time_);
      END IF;
   ELSE
      new_start_time_ := start_time_;
   END IF;   
   
   RETURN new_start_time_;
END Get_Start_Time_For_Time;

