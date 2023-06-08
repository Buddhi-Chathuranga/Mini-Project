-----------------------------------------------------------------------------
--
--  Logical unit: WorkTimeDayTypeDesc
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990608  JoEd  Call id 20333: Check_Period_Order___ call added in Delete___.
--  990607  JoEd  Call id 18945: Removed max_events_ check.
--                Rebuild Check_Period_Order___ from scratch.
--  990520  JoEd  Added day type to exist_control cursor in Check_Period_Order___.
--  990506  JoEd  Added column reserved_time.
--  9904xx  JoEd  Removed the IIDs EventActivity and ValidDate. New template.
--                Call id 5938. Changed period length to 10 characters.
--  990209  JoEd  Added method Check_Period_Order___.
--                Call Id 8330: Added check on working hours in Is_Working_Day.
--                Added check on time interval - not valid if 0 minutes.
--  981113  JoEd  SID 6920: Added calls to ExceptionCode when day type is changed.
--                SID 7035: Added default values on valid from/to and activity.
--  981105  JoEd  Changed union to union all and added day_type in view
--                WORK_TIME_DAY_TYPE_ALL to make it use the primary key.
--  981026  JoEd  Renamed WORK_TIME_DAY_TYPE_PERIOD to WORK_TIME_DAY_TYPE_ALL
--                and added more columns to it.
--  9810xx  JoEd  Changed table modification behaviour. Removed unused methods.
--                Added Get_Working_Hours and Get_Working_Periods.
--                Changed error messages. Added view WORK_TIME_DAY_TYPE_PERIOD
--                to calculate number of work day periods in WorkTimeCalendar.
--  980910  JoEd  Changed view's key order.
--  9806xx-
--  980904  JoEd  Created from MchDayTypeDesc.
--  010612  Larelk Bug 22173,Added General_SYS.Init_Method in Is_Working_Day__, 
--                 Reserved_Time_Only__.
--  040220  DHSELK Removed substrb and changed to substr where needed for Unicode Support 
--  ----------------------------Eagle------------------------------------------
--  100423  Ajpelk Merge rose method documentation
--  130923  chanlk Corrected Model file errors
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE tab_from_time IS TABLE OF DATE INDEX BY BINARY_INTEGER;

TYPE tab_to_time IS TABLE OF DATE INDEX BY BINARY_INTEGER;

TYPE tab_period IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Interval___
--   Checks whether or not a valid time interval has been entered.
PROCEDURE Check_Interval___ (
   newrec_ IN WORK_TIME_DAY_TYPE_DESC_TAB%ROWTYPE,
   objid_  IN VARCHAR2 DEFAULT NULL )
IS
   from_        DATE;
   to_          DATE;
   curr_date_   VARCHAR2(8) := to_char(SYSDATE, 'YYYYMMDD');

   CURSOR get_record IS
      SELECT to_date(curr_date_ || to_char(from_time, 'HH24MI'), 'YYYYMMDDHH24MI') from_time,
             to_date(curr_date_ || to_char(to_time, 'HH24MI'), 'YYYYMMDDHH24MI') to_time,
             rowid objid, reserved_time
      FROM WORK_TIME_DAY_TYPE_DESC_TAB
      WHERE day_type = newrec_.day_type;
BEGIN
   from_ := to_date(curr_date_ || to_char(newrec_.from_time, 'HH24MI'), 'YYYYMMDDHH24MI');
   to_ := to_date(curr_date_ || to_char(newrec_.to_time, 'HH24MI'), 'YYYYMMDDHH24MI');
   -- When end time is midnight it's the next day's midnight.
   IF (to_char(to_, 'HH24:MI') = '00:00') THEN
      to_ := to_ + 1;
   END IF;

   Trace_SYS.Field('FROM', from_);
   Trace_SYS.Field('TO', to_);

   IF (from_ > to_) THEN
      Error_SYS.Record_General(lu_name_, 'START_LATER_END: [From Time] can not be at a later time than [To Time].');
   ELSIF (from_ = to_) THEN
      Error_SYS.Record_General(lu_name_, 'START_EQUAL_END: [From Time] and [To Time] may not be the same.');
   ELSE
      FOR rec_ IN get_record LOOP
         -- Is this a new record or is it all records except the one being updated...
         IF ((objid_ IS NULL) OR (objid_ != rec_.objid)) THEN
            -- When end time is midnight it's the next day's midnight.
            IF (to_char(rec_.to_time, 'HH24:MI') = '00:00') THEN
               rec_.to_time := rec_.to_time + 1;
            END IF;
            IF ((from_ > rec_.from_time) AND (from_ < rec_.to_time)) THEN
               Error_SYS.Record_General(lu_name_, 'INV_START: Invalid start time!');
            ELSIF ((to_ > rec_.from_time) AND (to_ < rec_.to_time)) THEN
               Error_SYS.Record_General(lu_name_, 'INV_END: Invalid end time!');
            ELSIF ((from_ <= rec_.from_time) AND (to_ >= rec_.to_time)) THEN
               Error_SYS.Record_General(lu_name_, 'INV_OVERLAP: Entered time interval is overlapping another.');
            END IF;
         END IF;
      END LOOP;
   END IF;
END Check_Interval___;


-- Check_Period_Order___
--   Checks the entered period order for a certain day type.
--   The user enters a day type with e.g. the following data:
--   From Time    To Time Period
--   ---------    ------- ------
--   08:00     -- 12:00   1
--   13:00     -- 15:00   1
--   This is correct, since the two "working" period values are the same
--   It doesn't handle the break as a period. If the period order is
--   1 and 2 for the working hours and another time interval is added,
--   it's only allowed to set the period to 2 or e.g. 3 -
--   not 1, since 1 is already used in an earlier interval.
--   Except if the to time ends at midnight - then if the first period is 1,
--   the last can also be 1.
--   Example (changes from example above):
--   From Time    To Time Period
--   ---------    ------- ------
--   08:00     -- 12:00   1
--   13:00     -- 15:00   2
--   15:00     -- 17:00   1 (this is only allowed when "to time" = 00:00 !!
--   or there's another record with "to time" = 00:00)
PROCEDURE Check_Period_Order___ (
   day_type_ IN VARCHAR2 )
IS
   curr_date_    VARCHAR2(8) := to_char(SYSDATE, 'YYYYMMDD');
   n_            BINARY_INTEGER := 0;
   records_      BINARY_INTEGER;
   from_arr_     tab_from_time;
   to_arr_       tab_to_time;
   period_arr_   tab_period;
   period_       WORK_TIME_DAY_TYPE_DESC_TAB.period%TYPE;
   date_         DATE;
   sorted_       BOOLEAN := TRUE;

   CURSOR get_record IS
      SELECT to_date(curr_date_ || to_char(from_time, 'HH24MI'), 'YYYYMMDDHH24MI') from_time,
             to_date(curr_date_ || to_char(to_time, 'HH24MI'), 'YYYYMMDDHH24MI') to_time,
             period
      FROM WORK_TIME_DAY_TYPE_DESC_TAB
      WHERE day_type = day_type_
      ORDER BY 1;
BEGIN

   FOR rec_ IN get_record LOOP
      n_ := n_ + 1;
      from_arr_(n_) := rec_.from_time;
      -- if to_time is midnight, set next day's date
      IF (to_char(rec_.to_time, 'HH24:MI') = '00:00') THEN
         rec_.to_time := rec_.to_time + 1;
      END IF;
      to_arr_(n_) := rec_.to_time;
      period_arr_(n_) := rec_.period;
   END LOOP;

   -- store total number of elements in the arrays
   records_ := n_;

   -- only check period order if there are more than two records fetched
   IF (records_ > 2) THEN
      period_ := period_arr_(1);
      -- put first period(s) last in order, but only if the day starts and ends at midnight
      IF ((to_char(from_arr_(1), 'HH24:MI') = '00:00') AND (to_char(to_arr_(records_), 'HH24:MI') = '00:00')) THEN
         FOR n_ IN 1..records_ LOOP
            -- increase time interval with 24 hours as long as it's the same period
            IF (period_arr_(n_) = period_) THEN
               from_arr_(n_) := from_arr_(n_) + 1;
               to_arr_(n_) := to_arr_(n_) + 1;
               sorted_ := FALSE;
            ELSE
               EXIT; -- loop
            END IF;
         END LOOP;
      END IF;
      -- sort by from_time if not already sorted
      WHILE NOT sorted_ LOOP
         sorted_ := TRUE;
         FOR n_ IN 1..(records_ - 1) LOOP
            IF (from_arr_(n_) > from_arr_(n_ + 1)) THEN
               sorted_ := FALSE;
               date_ := from_arr_(n_);
               from_arr_(n_) := from_arr_(n_ + 1);
               from_arr_(n_ + 1) := date_;

               date_ := to_arr_(n_);
               to_arr_(n_) := to_arr_(n_ + 1);
               to_arr_(n_ + 1) := date_;

               period_ := period_arr_(n_);
               period_arr_(n_) := period_arr_(n_ + 1);
               period_arr_(n_ + 1) := period_;
            END IF;
         END LOOP;
      END LOOP;
      -- Display the arrays' contents
      FOR n_ IN 1..records_ LOOP
         Trace_SYS.Message(to_char(from_arr_(n_), 'HH24:MI') || ' -- ' || to_char(to_arr_(n_), 'HH24:MI') || ' - ''' || period_arr_(n_) || '''');
      END LOOP;

      -- Check period order. Start from second "record" in order to be able to use a "previous record".
      FOR n_ IN 2..records_ LOOP
         Trace_SYS.Field('period(' || to_char(n_ - 1) || ')', period_arr_(n_ - 1));
         -- if current period doesn't equal the previous period...
         IF (period_arr_(n_) != period_arr_(n_ - 1)) THEN
            -- if not first lap...
            IF (n_ > 2) THEN
               -- Check prior periods. IF any is the same as current period, raise an error!
               FOR i_ IN REVERSE 1..(n_ - 1) LOOP
                  IF (period_arr_(i_) = period_arr_(n_)) THEN
                     Trace_SYS.Message('Period ''' || period_arr_(n_) || ''' already exists on record #' || to_char(i_));
                     Error_SYS.Record_General(lu_name_, 'INVALIDPERIODORDER: Invalid period order for day type :P1!', day_type_);
                  END IF;
               END LOOP;
            END IF;
         END IF;
      END LOOP;
   END IF;
END Check_Period_Order___;


-- Truncate_Seconds___
--   Returns the bypassed timestamp with truncated seconds.
--   If user happens to enter seconds, remove them.
--   Used in the Unpack_Check_... methods
FUNCTION Truncate_Seconds___ (
   timestamp_ IN DATE ) RETURN DATE
IS
BEGIN
   RETURN to_date(to_char(timestamp_, 'YYYYMMDDHH24MI'), 'YYYYMMDDHH24MI');
END Truncate_Seconds___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('RESERVED_TIME_DB', 'N', attr_);
END Prepare_Insert___;

@Override
PROCEDURE Unpack___ (
   newrec_   IN OUT work_time_day_type_desc_tab%ROWTYPE,
   indrec_   IN OUT Indicator_Rec,
   attr_     IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   IF (indrec_.from_time) THEN
      newrec_.from_time := Truncate_Seconds___(newrec_.from_time);
   END IF;
   IF (indrec_.to_time) THEN
      newrec_.to_time := Truncate_Seconds___(newrec_.to_time);
   END IF;
END Unpack___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT work_time_day_type_desc_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   events_         NUMBER;
   CURSOR get_events(day_type_ VARCHAR2) IS
      SELECT count(*)
      FROM WORK_TIME_DAY_TYPE_DESC_TAB
      WHERE day_type = day_type_;
BEGIN
   super(newrec_, indrec_, attr_);

   -- Check number of events
   -- Split commnent, why is this code here, it seems not to be used.
   OPEN get_events(newrec_.day_type);
   FETCH get_events INTO events_;
   CLOSE get_events;

   Check_Interval___(newrec_);
   
   -- Return the time interval without seconds (if user has typed that)
   Client_SYS.Add_To_Attr('FROM_TIME', newrec_.from_time, attr_);
   Client_SYS.Add_To_Attr('TO_TIME', newrec_.to_time, attr_);
END Check_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT WORK_TIME_DAY_TYPE_DESC_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   -- Check period order after the record has been added to the table
   Check_Period_Order___(newrec_.day_type);

   Work_Time_Schedule_Desc_API.Set_Pending(newrec_.day_type);
   Work_Time_Exception_Code_API.Set_Pending(newrec_.day_type);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     work_time_day_type_desc_tab%ROWTYPE,
   newrec_ IN OUT work_time_day_type_desc_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   -- Return the time interval even though it might not have been updated
   Client_SYS.Add_To_Attr('FROM_TIME', newrec_.from_time, attr_);
   Client_SYS.Add_To_Attr('TO_TIME', newrec_.to_time, attr_);
END Check_Update___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     WORK_TIME_DAY_TYPE_DESC_TAB%ROWTYPE,
   newrec_     IN OUT WORK_TIME_DAY_TYPE_DESC_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Check_Interval___(newrec_, objid_);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   -- Check period order after the record has been stored in the table
   Check_Period_Order___(newrec_.day_type);

   IF ((newrec_.from_time != oldrec_.from_time) OR (newrec_.to_time != oldrec_.to_time) OR
       (newrec_.period != oldrec_.period) OR (newrec_.reserved_time != oldrec_.reserved_time)) THEN
      Work_Time_Schedule_Desc_API.Set_Pending(newrec_.day_type);
      Work_Time_Exception_Code_API.Set_Pending(newrec_.day_type);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN WORK_TIME_DAY_TYPE_DESC_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);

   -- Check period order after the record has been removed from the table
   Check_Period_Order___(remrec_.day_type);

   Work_Time_Schedule_Desc_API.Set_Pending(remrec_.day_type);
   Work_Time_Exception_Code_API.Set_Pending(remrec_.day_type);
END Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Is_Working_Day__
--   Returns 1 (True) if there are any records
--   No records = not a working day
FUNCTION Is_Working_Day__ (
   day_type_ IN VARCHAR2 ) RETURN NUMBER
IS
   exist_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM WORK_TIME_DAY_TYPE_DESC_TAB
      WHERE day_type = day_type_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO exist_;
   IF (exist_control%NOTFOUND) THEN
      exist_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN exist_;
END Is_Working_Day__;


-- Reserved_Time_Only__
--   Returns 1 (true) if there are only reserved time on a certain day type.
FUNCTION Reserved_Time_Only__ (
   day_type_ IN VARCHAR2 ) RETURN NUMBER
IS
   exist_  NUMBER := 0;
   CURSOR exist_normal IS
      SELECT 0
      FROM WORK_TIME_DAY_TYPE_DESC_TAB
      WHERE reserved_time = 'N'
      AND day_type = day_type_;
BEGIN
   IF (Is_Working_Day__(day_type_) = 1) THEN
      -- if day is a working day, check if there are
      -- any records with normal working time. IF found, 
      -- the day has not only reserved time
      OPEN exist_normal;
      FETCH exist_normal INTO exist_;
      IF (exist_normal%NOTFOUND) THEN
         exist_ := 1;
      END IF;
      CLOSE exist_normal;
   END IF;
   RETURN exist_;
END Reserved_Time_Only__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Working_Minutes
--   Returns the number of working hours specified for the day type.
@UncheckedAccess
FUNCTION Get_Working_Minutes (
   day_type_ IN VARCHAR2 ) RETURN NUMBER
IS
   minutes_   NUMBER := 0;
   curr_date_ VARCHAR2(8) := to_char(SYSDATE, 'YYYYMMDD');

   CURSOR get_hours IS
      SELECT to_date(curr_date_ || to_char(from_time, 'HH24MI'), 'YYYYMMDDHH24MI') time_from,
             to_date(curr_date_ || to_char(to_time, 'HH24MI'), 'YYYYMMDDHH24MI') time_to
      FROM WORK_TIME_DAY_TYPE_DESC_TAB
      WHERE reserved_time = 'N'
      AND day_type = day_type_;
BEGIN
   FOR rec_ IN get_hours LOOP
      IF (to_char(rec_.time_to, 'HH24:MI') = '00:00') THEN
         rec_.time_to := rec_.time_to + 1;
      END IF;
      minutes_ := minutes_ + round(to_number(rec_.time_to - rec_.time_from) * 1440);
   END LOOP;
   RETURN minutes_;
END Get_Working_Minutes;


-- Get_Working_Periods
--   Returns the number of working hour periods for the day type
@UncheckedAccess
FUNCTION Get_Working_Periods (
   day_type_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_periods IS
      SELECT nvl(count(distinct period), 0)
      FROM WORK_TIME_DAY_TYPE_DESC_TAB
      WHERE reserved_time = 'N'
      AND day_type = day_type_;
  periods_  NUMBER;
BEGIN
   OPEN get_periods;
   FETCH get_periods INTO periods_;
   IF (get_periods%NOTFOUND) THEN
      periods_ := 0;
   END IF;
   CLOSE get_periods;
   RETURN periods_;
END Get_Working_Periods;



