-----------------------------------------------------------------------------
--
--  Logical unit: WorkTimeCalendarDesc
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110314  ILSOLK  Bug 96177,Modified Is_Cal_Expired().
--  110223  ILSOLK  Bug 95498,Added Is_Cal_Expired() method.
--  ----------------------------------APP75 SP8------------------------------
--  081127  CHALLK Procedure Check_Interval___ was modified by adding a new parameter: objid_
--  040513  DHSELK Merged LCS Patched Bug 43460
--                  040329  Gacolk Bug 43460, Changed methods Insert___ and Update___. Commented code that
--                                 limited the check for period start date for first record only. Now it
--                                 performs the check for all records.
--  040310  CHRALK Added public method Get_Valid_Schedule.
--  990526  JoEd  Call id 18301: Removed check on equal dates and objid_ parameter
--                in Check_Interval___.
--  990505  JoEd  Changed behaviour in Insert___ and Update___ when it comes
--                to first date interval's start day.
--  9904xx  JoEd  New template. Removed unused methods.
--  990401  JoEd  Changed check around the WRONG_START_WEEKDAY (prior WARN) message.
--  990202  JoEd  Changed some error messages.
--  981113  JoEd  SID 6864: Changed WARN message to be an error message.
--                Added check that the error will only be displayed when it's
--                the min start date's record.
--  981028  JoEd  Added check on equal dates in Check_Interval___.
--  9810xx  JoEd  Changed behaviour when adding, modifying and removing records.
--                Added method Exist_Calendar__.
--                Changed error messages.
--  9806xx-
--  980903  JoEd  Created from MchSchedDesc
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Interval___
--   Checks the date intervals and that the entered schedules are correct
PROCEDURE Check_Interval___ (
   newrec_ IN   WORK_TIME_CALENDAR_DESC_TAB%ROWTYPE,
   objid_  IN   VARCHAR2)
IS
  CURSOR check_period_on_insert IS
     SELECT 1
     FROM   WORK_TIME_CALENDAR_DESC_TAB
     WHERE  calendar_id = newrec_.calendar_id
     AND    start_date != newrec_.start_date
     AND   (newrec_.start_date BETWEEN start_date AND end_date   OR
            newrec_.end_date   BETWEEN start_date AND end_date   OR
            newrec_.start_date < start_date AND newrec_.end_date > end_date);

  CURSOR check_period_on_update IS
     SELECT 1
     FROM   WORK_TIME_CALENDAR_DESC_TAB
     WHERE  calendar_id = newrec_.calendar_id
     AND    start_date != newrec_.start_date
     AND    rowid != objid_
     AND   (newrec_.start_date BETWEEN start_date AND end_date   OR
            newrec_.end_date   BETWEEN start_date AND end_date   OR
            newrec_.start_date < start_date AND newrec_.end_date > end_date);

  dummy_  NUMBER;

BEGIN

 -- Check date interval
 IF(newrec_.start_date > newrec_.end_date) THEN
    Error_SYS.Record_General(lu_name_, 'START_LATER_END: Start date can not be later then end date.');
 ELSE

   IF(objid_ IS NULL) THEN
      -- Checks overlapping periods on insert
      OPEN  check_period_on_insert;
      FETCH check_period_on_insert INTO dummy_;
      IF check_period_on_insert%found THEN
         CLOSE check_period_on_insert;
         Error_SYS.Record_General(lu_name_, 'WCPERIODOVERLAP: Defined time periods can not overlap.');
      END IF;
      CLOSE check_period_on_insert;

    ELSE
      -- Checks overlapping periods on updates
      OPEN  check_period_on_update;
      FETCH check_period_on_update INTO dummy_;
      IF check_period_on_update%found THEN
         CLOSE check_period_on_update;
         Error_SYS.Record_General(lu_name_, 'WCPERIODOVERLAP: Defined time periods can not overlap.');
      END IF;
      CLOSE check_period_on_update;

    END IF;
    -- Checks the schedule to see that it isn't empty or contains week days without day types.
    Work_Time_Schedule_API.Check_Correct(newrec_.schedule);

 END IF;
END Check_Interval___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('END_DATE', trunc(SYSDATE + 365), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT WORK_TIME_CALENDAR_DESC_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   min_date_      DATE;
   start_day_     WORK_TIME_SCHEDULE.period_start_day%TYPE;
   start_weekday_ WORK_TIME_SCHEDULE.period_start_day%TYPE;
BEGIN
   -- Check period start day if this is the first record in the date interval
   min_date_ := Get_Min_Start_Date(newrec_.calendar_id);
   Trace_SYS.Field('min date_', min_date_);
   IF (newrec_.start_date < (newrec_.start_date + 1)) THEN
      Trace_SYS.Message('First day!');
      start_day_ := Work_Time_Schedule_API.Get_Period_Start_Day(newrec_.schedule);
      start_weekday_ := Work_Time_Calendar_API.Get_Week_Day(newrec_.start_date);
      IF (start_day_ != start_weekday_) THEN
         Error_SYS.Record_General(lu_name_, 'WRONG_START_WEEKDAY: The period start day for the base schedule :P1 is a :P2 but is registered to start on a :P3.',
           newrec_.schedule, start_day_, start_weekday_);
      END IF;
   ELSE
      Trace_SYS.Message('Not first day!');
   END IF;

   super(objid_, objversion_, newrec_, attr_);

   Work_Time_Calendar_API.Set_Calendar_Pending(newrec_.calendar_id);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     WORK_TIME_CALENDAR_DESC_TAB%ROWTYPE,
   newrec_     IN OUT WORK_TIME_CALENDAR_DESC_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   start_day_     WORK_TIME_SCHEDULE.period_start_day%TYPE;
   start_weekday_ WORK_TIME_SCHEDULE.period_start_day%TYPE;
BEGIN
   Check_Interval___(newrec_, objid_);
   Trace_SYS.Message('First day!');
   start_day_ := Work_Time_Schedule_API.Get_Period_Start_Day(newrec_.schedule);
   start_weekday_ := Work_Time_Calendar_API.Get_Week_Day(newrec_.start_date);
   IF (start_day_ != start_weekday_) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_START_WEEKDAY: The period start day for the base schedule :P1 is a :P2 but is registered to start on a :P3.',
        newrec_.schedule, start_day_, start_weekday_);
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   -- Only update state if something has changed
   IF ((newrec_.start_date != oldrec_.start_date) OR
       (newrec_.end_date != oldrec_.end_date) OR
       (newrec_.schedule != oldrec_.schedule)) THEN
      Work_Time_Calendar_API.Set_Calendar_Pending(newrec_.calendar_id);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN WORK_TIME_CALENDAR_DESC_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Work_Time_Calendar_API.Set_Calendar_Pending(remrec_.calendar_id);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT work_time_calendar_desc_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   Check_Interval___(newrec_, NULL);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Exist_Calendar__
--   Called from the Calendar's state machine as a condition method
--   Returns whether or not there are any records for the specific calendar
FUNCTION Exist_Calendar__ (
   calendar_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
  CURSOR exist_control IS
     SELECT 1
     FROM WORK_TIME_CALENDAR_DESC_TAB
     WHERE calendar_id = calendar_id_;
   dummy_ NUMBER;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%NOTFOUND) THEN
      dummy_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN (dummy_ = 1);
END Exist_Calendar__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Min_Start_Date
--   Returns the first date in the calendar's schedules interval
@UncheckedAccess
FUNCTION Get_Min_Start_Date (
   calendar_id_ IN VARCHAR2 ) RETURN DATE
IS
   CURSOR get_min IS
      SELECT start_date
      FROM WORK_TIME_CALENDAR_DESC_TAB
      WHERE calendar_id = calendar_id_
      ORDER BY start_date;
   min_  DATE;
BEGIN
   OPEN get_min;
   FETCH get_min INTO min_;
   IF get_min%NOTFOUND THEN
      min_ := NULL;
   END IF;
   CLOSE get_min;
   RETURN min_;
END Get_Min_Start_Date;


@UncheckedAccess
FUNCTION Get_Max_End_Date (
   calendar_id_ IN VARCHAR2 ) RETURN DATE
IS
   CURSOR get_max IS
      SELECT end_date
      FROM WORK_TIME_CALENDAR_DESC_TAB
      WHERE calendar_id = calendar_id_
      ORDER BY end_date DESC;
   max_  DATE;
BEGIN
   OPEN get_max;
   FETCH get_max INTO max_;
   IF get_max%NOTFOUND THEN
      max_ := NULL;
   END IF;
   CLOSE get_max;
   RETURN max_;
END Get_Max_End_Date;


-- Set_Schedule_Pending
--   Invalidates all calendars using the specific schedule
PROCEDURE Set_Schedule_Pending (
   schedule_ IN VARCHAR2 )
IS
   CURSOR get_calendar IS
      SELECT DISTINCT calendar_id
      FROM WORK_TIME_CALENDAR_DESC_TAB
      WHERE schedule = schedule_;
BEGIN
   FOR rec_ IN get_calendar LOOP
      Work_Time_Calendar_API.Set_Calendar_Pending(rec_.calendar_id);
   END LOOP;
END Set_Schedule_Pending;


@UncheckedAccess
FUNCTION Duration_Exist (
   start_date_ IN DATE ) RETURN VARCHAR2
IS
   temp_   NUMBER;
   CURSOR getrec IS
      SELECT 1
      FROM WORK_TIME_CALENDAR_DESC_TAB
      WHERE  start_date_
      BETWEEN start_date AND end_date;
BEGIN
   OPEN getrec;
   FETCH getrec INTO temp_;
   IF (getrec%NOTFOUND) THEN
      CLOSE getrec;
      RETURN 'FALSE';
   END IF;
   CLOSE getrec;
   RETURN 'TRUE';
END Duration_Exist;


@UncheckedAccess
FUNCTION Min_Next_Cal (
   start_date_ IN DATE ) RETURN DATE
IS
   dummy_   DATE;
   CURSOR getrec IS
      SELECT MIN(start_date)
      FROM WORK_TIME_CALENDAR_DESC_TAB
      WHERE  start_date > start_date_ ;
BEGIN
   OPEN getrec;
   FETCH getrec INTO dummy_;
   IF (getrec%NOTFOUND) THEN
      CLOSE getrec;
   END IF;
   CLOSE getrec;
   RETURN dummy_;
END Min_Next_Cal;


@UncheckedAccess
FUNCTION Max_End_Cal (
   temp_ IN NUMBER ) RETURN DATE
IS
   max_  DATE;
   CURSOR get_max IS
      SELECT MAX(end_date)
      FROM WORK_TIME_CALENDAR_DESC_TAB;

BEGIN
   OPEN get_max;
   FETCH get_max INTO max_;
   CLOSE get_max;
   RETURN max_;
END Max_End_Cal;


@UncheckedAccess
FUNCTION Get_Valid_Schedule (
   calendar_id_ IN VARCHAR2,
   account_date_ IN DATE ) RETURN VARCHAR2
IS
   temp_ WORK_TIME_CALENDAR_DESC_TAB.schedule%TYPE;
   CURSOR get_attr IS
      SELECT schedule
      FROM WORK_TIME_CALENDAR_DESC_TAB
      WHERE calendar_id = calendar_id_
      AND start_date <= account_date_
      AND end_date >= account_date_
      AND calendar_id IN (SELECT calendar_id FROM work_time_calendar
                          WHERE objstate = 'Generated')  ;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Valid_Schedule;


@UncheckedAccess
FUNCTION Is_Cal_Expired (
   calender_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   max_end_date_  DATE;
BEGIN
   max_end_date_  := Get_Max_End_Date(calender_id_);

   IF (max_end_date_ >= trunc(SYSDATE)) THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Is_Cal_Expired;



