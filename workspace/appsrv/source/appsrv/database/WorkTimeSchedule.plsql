-----------------------------------------------------------------------------
--
--  Logical unit: WorkTimeSchedule
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130923  chanlk   Corrected Model file errors.
--  100423  Ajpe  Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  040220 DHSELK Removed substrb and changed to substr where needed for Unicode Support
--  9904xx  JoEd  New template. Removed unused methods.
--  990330  JoEd  Call id 11752: Added check on schedule existance in
--                Exist_Numeric_Period.
--  990209  JoEd  Rebuild Check_Correct.
--  981117  JoEd  Added function Exist_Numeric_Period.
--                Added default values.
--  981105  JoEd  Added pragma on Get_Activity_Start_Time and both Get_Activity_End_Time.
--  9810xx  JoEd  Removed state machine. Removed unused methods.
--                Changed error messages.
--  9806xx-
--  980903  JoEd  Create from MchBaseSched
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

period_min_ CONSTANT NUMBER := 1;

period_max_ CONSTANT NUMBER := 999;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Interval___
--   Checks that the user hasn't entered an invalid period length.
PROCEDURE Check_Interval___ (
   newrec_ IN WORK_TIME_SCHEDULE_TAB%ROWTYPE )
IS
BEGIN
   IF (newrec_.period_length < period_min_) THEN
      Error_SYS.Record_General(lu_name_, 'PERIOD_TOO_LOW: Period length must be greater than or equal to :P1!', period_min_);
   END IF;
   IF (newrec_.period_length > period_max_) THEN
      Error_SYS.Record_General(lu_name_, 'PERIOD_TOO_HIGH: Period length must be less than or equal to :P1!', period_max_);
   END IF;
END Check_Interval___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PERIOD_LENGTH', 7, attr_);
   Client_SYS.Add_To_Attr('PERIOD_START_DAY', Work_Time_Week_Day_API.Decode('1'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT WORK_TIME_SCHEDULE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);

   -- Create detail rows without day types
   Work_Time_Schedule_Desc_API.Create_Sched_Period__(newrec_.schedule, newrec_.period_length, newrec_.period_start_day);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     WORK_TIME_SCHEDULE_TAB%ROWTYPE,
   newrec_     IN OUT WORK_TIME_SCHEDULE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   IF ((oldrec_.period_length <> newrec_.period_length) OR
      (oldrec_.period_start_day <> newrec_.period_start_day)) THEN
      Work_Time_Schedule_Desc_API.Delete_Sched_Period__(oldrec_.schedule);
      Work_Time_Schedule_Desc_API.Create_Sched_Period__(newrec_.schedule, newrec_.period_length, newrec_.period_start_day);
      Work_Time_Calendar_Desc_API.Set_Schedule_Pending(newrec_.schedule);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT work_time_schedule_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   Check_Interval___(newrec_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     work_time_schedule_tab%ROWTYPE,
   newrec_ IN OUT work_time_schedule_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Check_Interval___(newrec_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Correct
--   Checks the schedule to see that it isn't empty or contains week days
--   without day types.
PROCEDURE Check_Correct (
   schedule_ IN VARCHAR2 )
IS
   start_date_      DATE;
   curr_date_       DATE;
   end_date_        DATE;
   length_          NUMBER := Get_Period_Length(schedule_);
BEGIN
   IF (length_ = 0) THEN
      Error_SYS.Record_General(lu_name_, 'SCHED_EMPTY: The schedule :P1 is empty!', schedule_);
   ELSE
      start_date_ := SYSDATE;
      curr_date_ := start_date_;
      end_date_ := start_date_ + length_ - 1;
      LOOP
         IF (Work_Time_Schedule_Desc_API.Get_Day_Type(schedule_, start_date_, curr_date_) IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'EMPTY_DAY: The schedule :P1 has a day without a day type defined!', schedule_);
         ELSE
            curr_date_ := curr_date_ + 1;
            EXIT WHEN (curr_date_ > end_date_);
         END IF;
      END LOOP;
   END IF;
END Check_Correct;


-- Get_Activity_Start_Time
--   Returns the date and time when a schedule day starts
@UncheckedAccess
FUNCTION Get_Activity_Start_Time (
   schedule_ IN VARCHAR2,
   schedule_date_ IN DATE ) RETURN DATE
IS
   day_type_ VARCHAR2(8);
BEGIN
   day_type_ := Work_Time_Schedule_Desc_API.Get_Day_Type(schedule_, schedule_date_, schedule_date_);
   RETURN Work_Time_Day_Type_API.Get_Activity_Start_Time(day_type_, schedule_date_);
END Get_Activity_Start_Time;


-- Get_Activity_End_Time
--   Returns the date and time when a schedule day ends
--   Returns the date and time when a schedule day ends using a date.
--   Returns the date and time when a schedule day ends using a date
--   Returns the date and time when a schedule day ends
@UncheckedAccess
FUNCTION Get_Activity_End_Time (
   schedule_ IN VARCHAR2,
   schedule_date_ IN DATE ) RETURN DATE
IS
   end_date_ DATE;
   day_type_ VARCHAR2(8);
BEGIN
   end_date_ := schedule_date_ + Get_Period_Length(schedule_) - 1;
   day_type_ := Work_Time_Schedule_Desc_API.Get_Day_Type(schedule_, schedule_date_, end_date_);
   RETURN Work_Time_Day_Type_API.Get_Activity_End_Time(day_type_, end_date_);
END Get_Activity_End_Time;


-- Get_Activity_End_Time
--   Returns the date and time when a schedule day ends
--   Returns the date and time when a schedule day ends using a date.
--   Returns the date and time when a schedule day ends using a date
--   Returns the date and time when a schedule day ends
@UncheckedAccess
FUNCTION Get_Activity_End_Time (
   schedule_ IN VARCHAR2,
   schedule_date_ IN DATE,
   curr_date_  IN DATE ) RETURN DATE
IS
   end_date_      DATE;
   period_length_ NUMBER;
   day_type_      VARCHAR2(8);
BEGIN
   period_length_ := to_number(curr_date_ - schedule_date_);
   end_date_ := schedule_date_ + mod(period_length_, Get_Period_Length(schedule_));
   day_type_ := Work_Time_Schedule_Desc_API.Get_Day_Type(schedule_, schedule_date_, end_date_);
   RETURN Work_Time_Day_Type_API.Get_Activity_End_Time(day_type_, curr_date_);
END Get_Activity_End_Time;



