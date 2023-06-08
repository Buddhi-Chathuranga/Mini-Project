-----------------------------------------------------------------------------
--
--  Logical unit: WorkTimeCounter
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100113 ChAlLK Bug 87158 Set_Working_Time__ Modified to remove records with '0' periods during calendar generation.
--  030827 Larelk Bug 37332 added Get_Previous_Date,Get_Next_Date changed Get_Begin_Date
--  ------  ----  -----------------------------------------------------------
--  100422 Ajpelk Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  021212 ZAHALK Did the SP3 - Merge for Take-off. And did the decommenting.
--  020328 Dobese Bug 28605, minor performance changes.
--  991103  JoEd  Fixed cursors in Get_Min_Work_Day__ and Get_Max_Work_Day__
--                to use unique index instead of primary key.
--  990517  JoEd  Added function Get_Nearest_Work_Day__.
--  990510  JoEd  Removed Remove_Work_Day__.
--                Completed handling of reserved time.
--  990506  JoEd  Added call to WorkTimeCounterRes to generate reserved time.
--                (not complete...)
--  9904xx  JoEd  New template. Changed primary key and added new attributes
--                and methods.
--  990121  JoEd  Added function Get_Prior_Work_Day.
--  981105  JoEd  Fixed some sql statements.
--  981028  JoEd  Removed Trace message from Recount__ method.
--                Changed error message in Get_Closest_Work_Day__.
--  981022  JoEd  Added derived column day_type to use in client form.
--                Changed error message.
--  980917  JoEd  Changed use of objid and objversion in some private methods.
--  980905  JoEd  Made most of the methods private - only called from WorkTimeCalendar.
--  980825-
--  980903  JoEd  Created.
--  010612  Larelk Bug 22173,Remove last parameter from General_SYS.Init_Method
--                 in Get_Closest_Work_Day__, Remove_Calendar__ ,New_Work_Day__ 
--                 Set_Working_Time__
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Min_Counter__
--   Returns the generated calendar's minimum counter value.
--   If it hasn't been generated 0 is returned. Otherwise it ought to
--   always return 1.
@UncheckedAccess
FUNCTION Get_Min_Counter__ (
   calendar_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   min_  NUMBER;
   CURSOR get_min IS
      SELECT counter
      FROM WORK_TIME_COUNTER_TAB
      WHERE calendar_id = calendar_id_
      ORDER BY counter;
BEGIN
   OPEN get_min;
   FETCH get_min INTO min_;
   IF (get_min%NOTFOUND) THEN
      min_ := 0;
   END IF;
   CLOSE get_min;
   RETURN min_;
END Get_Min_Counter__;


-- Get_Max_Counter__
--   Returns the generated calendar's max counter value.
--   If it hasn't been generated 0 is returned.
@UncheckedAccess
FUNCTION Get_Max_Counter__ (
   calendar_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   max_  NUMBER;
   CURSOR get_max IS
      SELECT counter
      FROM WORK_TIME_COUNTER_TAB
      WHERE calendar_id = calendar_id_
      ORDER BY counter DESC;
BEGIN
   OPEN get_max;
   FETCH get_max INTO max_;
   IF (get_max%NOTFOUND) THEN
      max_ := 0;
   END IF;
   CLOSE get_max;
   RETURN max_;
END Get_Max_Counter__;


-- Get_Min_Work_Day__
--   Returns the generated calendar's minimum date value.
--   If it hasn't been generated NULL is returned.
@UncheckedAccess
FUNCTION Get_Min_Work_Day__ (
   calendar_id_ IN VARCHAR2 ) RETURN DATE
IS
   min_  DATE;

CURSOR get_min IS
      SELECT --+ INDEX_ASC(WORK_TIME_COUNTER_TAB WORK_TIME_COUNTER_UIX)
             MIN(work_day)
      FROM WORK_TIME_COUNTER_TAB
      WHERE calendar_id = calendar_id_;

BEGIN
   OPEN get_min;
   FETCH get_min INTO min_;
   IF (get_min%NOTFOUND) THEN
      min_ := NULL;
   END IF;
   CLOSE get_min;
   RETURN min_;
END Get_Min_Work_Day__;


-- Get_Max_Work_Day__
--   Returns the generated calendars max date.
--   If it hasn't been generated NULL is returned.
@UncheckedAccess
FUNCTION Get_Max_Work_Day__ (
   calendar_id_ IN VARCHAR2 ) RETURN DATE
IS
   max_  DATE;

CURSOR get_max IS
      SELECT --+ INDEX_DESC(WORK_TIME_COUNTER_TAB WORK_TIME_COUNTER_UIX)
             work_day
      FROM WORK_TIME_COUNTER_TAB
      WHERE calendar_id = calendar_id_
      ORDER BY calendar_id DESC, work_day DESC;

BEGIN
   OPEN get_max;
   FETCH get_max INTO max_;
   IF (get_max%NOTFOUND) THEN
      max_ := NULL;
   END IF;
   CLOSE get_max;
   RETURN max_;
END Get_Max_Work_Day__;


-- Get_Next_Work_Day__
--   Returns the working day that comes right after the bypassed counter/
@UncheckedAccess
FUNCTION Get_Next_Work_Day__ (
   calendar_id_ IN VARCHAR2,
   counter_ IN NUMBER,
   work_day_ IN DATE DEFAULT NULL ) RETURN DATE
IS
   next_day_   DATE;

   CURSOR get_workday IS
      SELECT work_day
      FROM   WORK_TIME_COUNTER_TAB
      WHERE work_day > work_day_
      AND calendar_id = calendar_id_
      ORDER BY work_day;

   CURSOR get_workcounter IS
      SELECT work_day
      FROM   WORK_TIME_COUNTER_TAB
      WHERE counter > counter_
      AND calendar_id = calendar_id_
      ORDER BY work_day;
BEGIN
   IF (work_day_ IS NULL) THEN
      OPEN get_workcounter;
      FETCH get_workcounter INTO next_day_;
      IF (get_workcounter%NOTFOUND) THEN
         next_day_ := NULL;
      END IF;
      CLOSE get_workcounter;
   ELSE
      OPEN get_workday;
      FETCH get_workday INTO next_day_;
      IF (get_workday%NOTFOUND) THEN
         next_day_ := NULL;
      END IF;
      CLOSE get_workday;
   END IF;
   RETURN next_day_;
END Get_Next_Work_Day__;


-- Get_Previous_Work_Day__
--   Returns the date that comes before the bypassed counter/date.
@UncheckedAccess
FUNCTION Get_Previous_Work_Day__ (
   calendar_id_ IN VARCHAR2,
   counter_ IN NUMBER,
   work_day_ IN DATE DEFAULT NULL ) RETURN DATE
IS
   prev_day_   DATE;

   CURSOR get_workday IS
      SELECT work_day
      FROM   WORK_TIME_COUNTER_TAB
      WHERE work_day < work_day_
      AND calendar_id = calendar_id_
      ORDER BY work_day DESC;

   CURSOR get_workcounter IS
      SELECT work_day
      FROM   WORK_TIME_COUNTER_TAB
      WHERE counter < counter_
      AND calendar_id = calendar_id_
      ORDER BY work_day DESC;
BEGIN
   IF (work_day_ IS NULL) THEN
      OPEN get_workcounter;
      FETCH get_workcounter INTO prev_day_;
      IF get_workcounter%NOTFOUND THEN
         prev_day_ := NULL;
      END IF;
      CLOSE get_workcounter;
   ELSE
      OPEN get_workday;
      FETCH get_workday INTO prev_day_;
      IF get_workday%NOTFOUND THEN
         prev_day_ := NULL;
      END IF;
      CLOSE get_workday;
   END IF;
   RETURN prev_day_;
END Get_Previous_Work_Day__;


-- Get_Closest_Work_Day__
--   If the bypassed date is a working day, it is returned.
--   Otherwise if the working day after the bypassed date exists that one
--   is returned instead. If the fetch results in going outside the
--   calendar's max date, an error message is displayed.
FUNCTION Get_Closest_Work_Day__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
   counter_   NUMBER;
   next_day_  DATE;
BEGIN
   counter_ := Get_Counter__(calendar_id_, work_day_);
   IF (counter_ IS NULL) THEN
      next_day_ := Get_Next_Work_Day__(calendar_id_, NULL, work_day_);
      IF (next_day_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'DATE_NOT_IN_CAL: Retrieving next work day from :P1 failed. The date is outside the interval of the calendar :P2.', to_char(work_day_, 'YYYY-MM-DD'), calendar_id_);
      END IF;
      RETURN next_day_;
   ELSE
      RETURN work_day_;
   END IF;
END Get_Closest_Work_Day__;


-- Get_Nearest_Work_Day__
--   If the bypassed date is a working day, it is returned.
--   Otherwise if the working day after the bypassed date exists that one
--   is returned instead. If the fetch results in going outside the
--   calendar's max date, NULL is returned.
@UncheckedAccess
FUNCTION Get_Nearest_Work_Day__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
   counter_   NUMBER := Get_Counter__(calendar_id_, work_day_);
BEGIN
   IF (counter_ IS NULL) THEN
      RETURN Get_Next_Work_Day__(calendar_id_, NULL, work_day_);
   ELSE
      RETURN work_day_;
   END IF;
END Get_Nearest_Work_Day__;


-- Get_Prior_Work_Day__
--   If the bypassed counter/date isn't a working day, the prior date is
--   returned. Otherwise the bypassed date is returned.
@UncheckedAccess
FUNCTION Get_Prior_Work_Day__ (
   calendar_id_ IN VARCHAR2,
   counter_ IN NUMBER,
   work_day_ IN DATE DEFAULT NULL ) RETURN DATE
IS
   count_ NUMBER;
   date_  DATE := NULL;
BEGIN
   IF (counter_ IS NOT NULL) THEN
      date_ := Get_Work_Day(calendar_id_, counter_);
      IF (date_ IS NULL) THEN
         date_ := Get_Previous_Work_Day__(calendar_id_, counter_, NULL);
      END IF;
   ELSIF (work_day_ IS NOT NULL) THEN
      count_ := Get_Counter__(calendar_id_, work_day_);
      date_ := work_day_;
      IF (count_ IS NULL) THEN
         date_ := Get_Previous_Work_Day__(calendar_id_, NULL, work_day_);
      END IF;
   END IF;
   RETURN date_;
END Get_Prior_Work_Day__;


-- Get_Counter__
--   Returns the counter connected to a specific date.
@UncheckedAccess
FUNCTION Get_Counter__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN NUMBER
IS
   temp_ WORK_TIME_COUNTER_TAB.counter%TYPE;
   CURSOR get_attr IS
      SELECT counter
      FROM WORK_TIME_COUNTER_TAB
      WHERE work_day = work_day_
      AND calendar_id = calendar_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Counter__;


-- Get_Day_Type__
--   Returns the day type for a specific date.
@UncheckedAccess
FUNCTION Get_Day_Type__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN VARCHAR2
IS
   temp_ WORK_TIME_COUNTER_TAB.day_type%TYPE;
   CURSOR get_attr IS
      SELECT day_type
      FROM WORK_TIME_COUNTER_TAB
      WHERE work_day = work_day_
      AND calendar_id = calendar_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Day_Type__;


-- Get_Working_Time__
--   Returns number of working minutes for a specific date.
@UncheckedAccess
FUNCTION Get_Working_Time__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN NUMBER
IS
   temp_  WORK_TIME_COUNTER_TAB.working_time%TYPE;
   CURSOR get_attr IS
      SELECT working_time
      FROM WORK_TIME_COUNTER_TAB
      WHERE work_day = work_day_
      AND calendar_id = calendar_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN nvl(temp_, 0);
END Get_Working_Time__;


-- Get_Working_Periods__
--   Returns number of periods for a specific date.
@UncheckedAccess
FUNCTION Get_Working_Periods__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN NUMBER
IS
   temp_  WORK_TIME_COUNTER_TAB.working_periods%TYPE;
   CURSOR get_attr IS
      SELECT working_periods
      FROM WORK_TIME_COUNTER_TAB
      WHERE work_day = work_day_
      AND calendar_id = calendar_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN nvl(temp_, 0);
END Get_Working_Periods__;


-- Remove_Calendar__
--   Removes a specific calendar including details.
PROCEDURE Remove_Calendar__ (
   calendar_id_ IN VARCHAR2 )
IS
   CURSOR get_record IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM WORK_TIME_COUNTER_TAB
      WHERE calendar_id = calendar_id_;
   remrec_  WORK_TIME_COUNTER_TAB%ROWTYPE;
BEGIN
   FOR rec_ IN get_record LOOP
      remrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      Check_Delete___(remrec_);
      Delete___(rec_.objid, remrec_);
   END LOOP;
   Work_Time_Counter_Res_API.Remove_Calendar__(calendar_id_);
END Remove_Calendar__;


-- New_Work_Day__
--   Creates a new calendar counter record with details.
--   Called from work day loop in WorkTimeCalendar.
PROCEDURE New_Work_Day__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE,
   day_type_ IN VARCHAR2,
   working_time_ IN NUMBER,
   working_periods_ IN NUMBER )
IS
   attr_       VARCHAR2(2000) := NULL;
   newrec_     WORK_TIME_COUNTER_TAB%ROWTYPE;
   counter_    NUMBER := 0;
   objid_      WORK_TIME_COUNTER.objid%TYPE;
   objversion_ WORK_TIME_COUNTER.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN
-- if the day type only contains reserved time, don't add it as a working/counter day.
   IF (Work_Time_Day_Type_Desc_API.Reserved_Time_Only__(day_type_) = 0) THEN
      Prepare_Insert___(attr_);
      Client_SYS.Add_To_Attr('CALENDAR_ID', calendar_id_, attr_);
      counter_ := Get_Max_Counter__(calendar_id_) + 1;
      Client_SYS.Add_To_Attr('COUNTER', counter_, attr_);
      Client_SYS.Add_To_Attr('WORK_DAY', work_day_, attr_);
      Client_SYS.Add_To_Attr('DAY_TYPE', day_type_, attr_);
      -- NOTE! working time is in minutes!
      Client_SYS.Add_To_Attr('WORKING_TIME', working_time_, attr_);
      Client_SYS.Add_To_Attr('WORKING_PERIODS', working_periods_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
      -- Update the detail rows
      Work_Time_Counter_Desc_API.New_Work_Day__(calendar_id_, counter_, work_day_, day_type_);
   END IF;

   -- Add reserved time if any (if only reserved time for current date, counter is 0).
   Work_Time_Counter_Res_API.New_Day__(calendar_id_, counter_, work_day_, day_type_);
END New_Work_Day__;


-- Set_Working_Time__
--   Recalculates the number of work minutes and periods for the calendar's
--   work day.
PROCEDURE Set_Working_Time__ (
   calendar_id_ IN VARCHAR2,
   counter_ IN NUMBER )
IS
   attr_    VARCHAR2(2000);
   newrec_  WORK_TIME_COUNTER_TAB%ROWTYPE;
   oldrec_  WORK_TIME_COUNTER_TAB%ROWTYPE;
   remrec_  WORK_TIME_COUNTER_TAB%ROWTYPE;
   indrec_  Indicator_Rec;
   minutes_ NUMBER;

   CURSOR get_record IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion, work_day
      FROM WORK_TIME_COUNTER_TAB
      WHERE counter = counter_
      AND calendar_id = calendar_id_;
   rec_     get_record%ROWTYPE;

   CURSOR get_periods IS
      SELECT count(distinct period)
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE counter = counter_
      AND calendar_id = calendar_id_;
   periods_ NUMBER;
BEGIN
   Trace_SYS.Field('calendar_id', calendar_id_);
   Trace_SYS.Field('counter', counter_);
   OPEN get_record;
   FETCH get_record INTO rec_;
   IF (get_record%FOUND) THEN
      CLOSE get_record;
      -- fetch working time for all periods
      minutes_ := Work_Time_Counter_Desc_API.Get_Working_Time__(calendar_id_, rec_.work_day, NULL);
      Trace_SYS.Field('New working time', minutes_);
      Client_SYS.Add_To_Attr('WORKING_TIME', minutes_, attr_);
      oldrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      newrec_ := oldrec_;
      -- fetch new number of periods
      OPEN get_periods;
      FETCH get_periods INTO periods_;
      CLOSE get_periods;
      Trace_SYS.Field('New working periods', nvl(periods_, 0));
      Client_SYS.Add_To_Attr('WORKING_PERIODS', nvl(periods_, 0), attr_);
      IF( nvl(periods_, 0) != 0 ) THEN
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(rec_.objid, oldrec_, newrec_, attr_, rec_.objversion);
      ELSE
         remrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
         Check_Delete___(remrec_);
         Delete___(rec_.objid, remrec_);
      END IF;
   ELSE
      CLOSE get_record;
      Trace_SYS.Message('Counter #' || to_char(counter_) || ' not found for calendar ''' || calendar_id_ || '''!');
   END IF;
END Set_Working_Time__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Begin_Date (
   work_day_ IN DATE ) RETURN DATE
IS
   temp_ WORK_TIME_COUNTER_TAB.work_day%TYPE;
   week_no_     NUMBER;
   max_date_    DATE;

   CURSOR get_attr IS
      SELECT min(work_day)
      FROM WORK_TIME_COUNTER_TAB
      WHERE SUBSTR(TO_CHAR(work_day,'MMDDYY'),5) = SUBSTR(TO_CHAR(work_day_,'MMDDYY'),5);

   CURSOR get_max_date IS
      SELECT work_day
      FROM   WORK_TIME_COUNTER_TAB
      WHERE work_day > temp_;

BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   week_no_:= to_number(to_char(temp_,'IW'),'999');
   IF (week_no_= 1) THEN
      max_date_:= temp_;
   ELSE
      OPEN get_max_date;
      FETCH get_max_date INTO max_date_;
      WHILE (get_max_date%FOUND) LOOP
         week_no_:=to_number(to_char(max_date_,'IW'),'999');
         IF (week_no_=1) THEN
            max_date_:=max_date_;
            EXIT;
         END IF;
         FETCH get_max_date INTO max_date_; 
      END LOOP;
      CLOSE get_max_date;
   END IF;
   RETURN max_date_;
END Get_Begin_Date;


-- Get_Previous_Date
--   Get work_day to create 1st week
@UncheckedAccess
FUNCTION Get_Previous_Date (
   work_day_ IN DATE ) RETURN DATE
IS
   temp_   WORK_TIME_COUNTER_TAB.work_day%TYPE;
   CURSOR get_attr IS
      SELECT max(work_day)
      FROM WORK_TIME_COUNTER_TAB
      WHERE work_day < work_day_ ;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Previous_Date;


-- Get_Next_Date
--   Get the start date relevent to first week.
--   if the last end date is 1/1/2006 start date should be 1/2/2006
@UncheckedAccess
FUNCTION Get_Next_Date (
   begin_date_ IN DATE,
   end_date_ IN DATE ) RETURN DATE
IS
   temp_ WORK_TIME_COUNTER_TAB.work_day%TYPE;
   CURSOR get_attr IS
      SELECT min(work_day)
      FROM WORK_TIME_COUNTER_TAB
      WHERE SUBSTR(TO_CHAR( begin_date_,'MMDDYY'),5) < SUBSTR(TO_CHAR(end_date_,'MMDDYY'),5)
      AND work_day > end_date_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Next_Date;



