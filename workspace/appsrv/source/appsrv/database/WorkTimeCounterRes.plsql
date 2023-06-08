-----------------------------------------------------------------------------
--
--  Logical unit: WorkTimeCounterRes
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990609  JoEd  Call id 11752: Added Exist_Numeric_Period__.
--  990604  JoEd  Call id 18303: Added check on found prior date in Connect_Days___.
--  990526  JoEd  Call id 18303: Changed where clause in Get_Day_Type___ to
--                include start date = bypassed date to fetch correct
--                connect_next value. (See also CID 17750).
--  990517  JoEd  Changed validation of COUNTER atribute due to non
--                working days having counter equals 0.
--  990511  JoEd  Added function Allow_Connect___.
--  990506  JoEd  Created.
--  010612  Larelk Bug 22173 REmove last parameter from General_SYS.Init_Method 
--                 in method New_Day__,Remove_Calendar__ .
--  040220  DHSELK Removed substrb and changed to substr where needed for Unicode Support
--  040301  ThAblk Removed substr from views
--  191021  CLEKLK Bug 145572, Modified Check_Common___().
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Day_Type___
--   Returns the day type for a specific calendar and date.
--   Used in Connect_Days___ to fetch day type whatever it might be.
--   Copy of WorkTimeCalendar's Get_Day_Type___ method.
FUNCTION Get_Day_Type___ (
   calendar_id_ IN VARCHAR2,
   curr_date_ IN DATE ) RETURN VARCHAR2
IS
   exception_code_ WORK_TIME_CALENDAR.exception_code%TYPE;
   day_type_       WORK_TIME_COUNTER.day_type%TYPE := NULL;
   date_           DATE := trunc(curr_date_);

   CURSOR get_schedule IS
      SELECT schedule, start_date
      FROM WORK_TIME_CALENDAR_DESC_TAB
      WHERE date_ >= start_date
      AND date_ <= end_date
      AND calendar_id = calendar_id_;
   schedrec_  get_schedule%ROWTYPE;
BEGIN
   exception_code_ := Work_Time_Calendar_API.Get_Exception_Code(calendar_id_);
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


-- Allow_Connect___
--   Checks if the reserved day is allowed to connect with another date.
FUNCTION Allow_Connect___ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE,
   start_time_ IN DATE,
   start_period_ IN VARCHAR2,
   end_time_ IN DATE,
   day_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR exist_periods IS
      SELECT 1
      FROM WORK_TIME_DAY_TYPE_DESC_TAB
      WHERE reserved_time = 'Y'
      AND period != start_period_
      AND day_type = day_type_;
   work_periods_ NUMBER := Work_Time_Day_Type_Desc_API.Get_Working_Periods(day_type_);
   res_periods_  NUMBER;
BEGIN
   OPEN exist_periods;
   FETCH exist_periods INTO res_periods_;
   IF (exist_periods%NOTFOUND) THEN
      res_periods_ := 0;
   END IF;
   CLOSE exist_periods;
   -- Only allow connecting when day starts at midnight, ends at midnight and there are more than one reserved period and >0 working periods.
   RETURN NOT ((to_char(start_time_, 'HH24:MI') = '00:00') AND (to_char(end_time_, 'HH24:MI') = '00:00') AND
           (res_periods_ = 0) AND (work_periods_ = 0));
END Allow_Connect___;


-- Connect_Days___
--   This method is only called when a day starts at midnight and doesn't end
--   at midnight.
--   First it checks the previous date to check the connect_next flag and
--   connect either the previous day to the bypassed day or the bypassed day
--   to the previous. Finally it increases or decreases the working_time
--   attribute for the two days that are affected.
PROCEDURE Connect_Days___ (
   calendar_id_ IN VARCHAR2,
   counter_ IN NUMBER,
   start_time_ IN DATE,
   period_ IN VARCHAR2,
   end_time_ IN DATE )
IS
   prior_date_    DATE;
   work_day_      DATE;
   attr_          VARCHAR2(2000) := NULL;
   objid_         WORK_TIME_COUNTER_RES.objid%TYPE;
   objversion_    WORK_TIME_COUNTER_RES.objversion%TYPE;
   oldrec_        WORK_TIME_COUNTER_RES_TAB%ROWTYPE;
   newrec_        WORK_TIME_COUNTER_RES_TAB%ROWTYPE;
   indrec_        Indicator_Rec;
   connect_next_  VARCHAR2(5) := 'FALSE';

   -- since counter is 0 when no normal working day, it can't be used
   CURSOR get_prior_header IS
      SELECT counter, work_day
      FROM WORK_TIME_COUNTER_RES_TAB
      WHERE work_day < start_time_
      AND calendar_id = calendar_id_
      ORDER BY work_day DESC;
   headrec_       get_prior_header%ROWTYPE;
   day_type_      VARCHAR2(8);

   CURSOR get_prior_start IS
      SELECT counter, start_time
      FROM WORK_TIME_COUNTER_RES_TAB
      WHERE period = period_
      AND end_time = start_time_
      AND work_day = prior_date_
      AND calendar_id = calendar_id_;
   prior_counter_ WORK_TIME_COUNTER_RES_TAB.counter%TYPE;
   prior_start_   WORK_TIME_COUNTER_RES_TAB.start_time%TYPE;

   -- fetches the time intervals in start time order - ascending
   -- to move forwards in time
   CURSOR get_day_periods_asc(work_day_ IN DATE) IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion,
             start_time, end_time, period, 'Y' reserved_time
      FROM WORK_TIME_COUNTER_RES_TAB
      WHERE work_day = work_day_
      AND calendar_id = calendar_id_
      UNION ALL
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion,
             start_time, end_time, period, 'N' reserved_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE work_day = work_day_
      AND calendar_id = calendar_id_
      ORDER BY 3;

   -- fetches the time intervals in start time order - descending
   -- to move backwards in time
   CURSOR get_day_periods_desc(work_day_ IN DATE) IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion,
             start_time, end_time, period, 'Y' reserved_time
      FROM WORK_TIME_COUNTER_RES_TAB
      WHERE work_day = work_day_
      AND calendar_id = calendar_id_
      UNION ALL
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion,
             start_time, end_time, period, 'N' reserved_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE work_day = work_day_
      AND calendar_id = calendar_id_
      ORDER BY 3 DESC;
BEGIN
   OPEN get_prior_header;
   FETCH get_prior_header INTO headrec_;
   CLOSE get_prior_header;
   prior_date_ := headrec_.work_day;
   work_day_ := prior_date_;
   Trace_SYS.Field('prior date', prior_date_);
   day_type_ := Get_Day_Type___(calendar_id_, prior_date_);
   Trace_SYS.Field('prior day type', day_type_);
   IF (day_type_ IS NOT NULL) THEN
      connect_next_ := nvl(Work_Time_Day_Type_API.Get_Connect_Next(day_type_), 'FALSE');
   END IF;
   Trace_SYS.Field('connect_next', connect_next_);

   -- if the prior date is actually the day before "this" day
   IF ((prior_date_ IS NOT NULL) AND (prior_date_ = (start_time_ - 1))) THEN
      OPEN get_prior_start;
      FETCH get_prior_start INTO prior_counter_, prior_start_;
      Trace_SYS.Field('prior counter', prior_counter_);
      Trace_SYS.Field('prior start time', prior_start_);
      -- did the last time interval for the prior date have the same period as "this" date?
      -- and did it end at midnight? and did it not start at midnight?
      IF (get_prior_start%FOUND) THEN
         IF (prior_start_ != trunc(prior_start_)) THEN
            -- if prior day's period equals "this period" and the record ends at midnight,
            -- remove "this" period interval and update the end time for the prior day.
            Trace_SYS.Field('removing counter', counter_);
            Trace_SYS.Field('=> start_time', start_time_);
            Get_Id_Version_By_Keys___(objid_, objversion_, calendar_id_, counter_, start_time_);
            oldrec_ := Lock_By_Id___(objid_, objversion_);
            Delete___(objid_, oldrec_);

            Trace_SYS.Message('updating previous end time to ''' || to_char(oldrec_.end_time, 'YYYY-MM-DD HH24:MI') || '''');
            Get_Id_Version_By_Keys___(objid_, objversion_, calendar_id_, prior_counter_, prior_start_);
            attr_ := NULL;
            IF (connect_next_ = 'TRUE') THEN
               Client_SYS.Add_To_Attr('COUNTER', counter_, attr_);
               Client_SYS.Add_To_Attr('WORK_DAY', start_time_, attr_);
            END IF;
            Client_SYS.Add_To_Attr('END_TIME', oldrec_.end_time, attr_);
            oldrec_ := Lock_By_Id___(objid_, objversion_);
            newrec_ := oldrec_;
            Unpack___(newrec_, indrec_, attr_);
            Check_Update___(oldrec_, newrec_, indrec_, attr_);
            Update___(objid_, oldrec_, newrec_, attr_, objversion_);
         END IF;
         CLOSE get_prior_start;
         -- if connect to next day, set prior day's work_day to "this" day...
         IF (connect_next_ = 'TRUE') THEN
            Trace_SYS.Message('Moving previous day''s periods to "this" day...');
            -- going backwards in time as long as there are reserved time intervals using prior date instead of prior_counter (can be 0).
            FOR rec_ IN get_day_periods_desc(prior_date_) LOOP
               IF ((rec_.period = period_) AND (rec_.reserved_time = 'Y')) THEN
                  attr_ := NULL;
                  Client_SYS.Add_To_Attr('COUNTER', counter_, attr_);
                  Client_SYS.Add_To_Attr('WORK_DAY', start_time_, attr_);
                  oldrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
                  newrec_ := oldrec_;
                  Unpack___(newrec_, indrec_, attr_);
                  Check_Update___(oldrec_, newrec_, indrec_, attr_);
                  Update___(rec_.objid, oldrec_, newrec_, attr_, rec_.objversion);
               ELSE
                  EXIT; -- loop
               END IF;
            END LOOP;
         -- ...otherwise set "this" day's work_day to prior day using this day instead of counter (can be 0)
         -- as long as there are reserved time intervals.
         ELSE
            Trace_SYS.Message('Moving "this" day''s periods to previous day...');
            -- going forwards in time interval
            FOR rec_ IN get_day_periods_asc(start_time_) LOOP
               IF ((rec_.period = period_) AND (rec_.reserved_time = 'Y')) THEN
                  attr_ := NULL;
                  Client_SYS.Add_To_Attr('COUNTER', prior_counter_, attr_);
                  Client_SYS.Add_To_Attr('WORK_DAY', prior_date_, attr_);
                  oldrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
                  newrec_ := oldrec_;
                  Unpack___(newrec_, indrec_, attr_);
                  Check_Update___(oldrec_, newrec_, indrec_, attr_);
                  Update___(rec_.objid, oldrec_, newrec_, attr_, rec_.objversion);
               ELSE
                  EXIT; -- loop
               END IF;
            END LOOP;
         END IF;
      ELSE
         Trace_SYS.Message('Prior day doesn''t end when "this" day starts!');
      END IF;
   ELSE
      Trace_SYS.Message('Prior day doesn''t exist or is not the day before this date');
   END IF;
END Connect_Days___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     work_time_counter_res_tab%ROWTYPE,
   newrec_ IN OUT work_time_counter_res_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.counter = 0 THEN
      indrec_.counter := FALSE; -- Don't make Exists validate if counter = 0
      indrec_.calendar_id := FALSE;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- New_Day__
--   Searches the day type for reserved time and adds it to the specified
--   calendar. If the date isn't connected to a counter, 0 is used as
--   counter no.
PROCEDURE New_Day__ (
   calendar_id_ IN VARCHAR2,
   counter_ IN NUMBER,
   work_day_ IN DATE,
   day_type_ IN VARCHAR2 )
IS
   curr_date_    VARCHAR2(8) := to_char(work_day_, 'YYYYMMDD');
   first_period_ WORK_TIME_COUNTER_RES_TAB.period%TYPE := NULL;
   first_start_  WORK_TIME_COUNTER_RES_TAB.start_time%TYPE;
   last_end_     WORK_TIME_COUNTER_RES_TAB.end_time%TYPE;
   attr_         VARCHAR2(2000);
   objid_        WORK_TIME_COUNTER_RES.objid%TYPE;
   objversion_   WORK_TIME_COUNTER_RES.objversion%TYPE;
   newrec_       WORK_TIME_COUNTER_RES_TAB%ROWTYPE;
   indrec_       Indicator_Rec;

   CURSOR get_day_type IS
      SELECT to_date(curr_date_ || to_char(from_time, 'HH24MI'), 'YYYYMMDDHH24MI') start_time,
             to_date(curr_date_ || to_char(to_time, 'HH24MI'), 'YYYYMMDDHH24MI') end_time,
             period
      FROM WORK_TIME_DAY_TYPE_DESC_TAB
      WHERE reserved_time = 'Y'
      AND day_type = day_type_
      ORDER BY from_time;
BEGIN
   FOR rec_ IN get_day_type LOOP
      -- store first record's info
      IF (first_period_ IS NULL) THEN
         first_period_ := rec_.period;
         Trace_SYS.Field('First period', first_period_);
         first_start_ := rec_.start_time;
         Trace_SYS.Field('First start', first_start_);
      END IF;
      Prepare_Insert___(attr_);
      Client_SYS.Add_To_Attr('CALENDAR_ID', calendar_id_, attr_);
      Client_SYS.Add_To_Attr('COUNTER', counter_, attr_);
      Client_SYS.Add_To_Attr('START_TIME', rec_.start_time, attr_);
      -- if midnight set next day's midnight
      IF (to_char(rec_.end_time, 'HH24:MI') = '00:00') THEN
         rec_.end_time := rec_.end_time + 1;
      END IF;
      Client_SYS.Add_To_Attr('END_TIME', rec_.end_time, attr_);
      last_end_ := rec_.end_time;
      Client_SYS.Add_To_Attr('WORK_DAY', work_day_, attr_);
      Client_SYS.Add_To_Attr('PERIOD', rec_.period, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
   Trace_SYS.Field('last end', last_end_);

   -- only update if "this" day/period starts at midnight
   IF Allow_Connect___(calendar_id_, work_day_, first_start_, first_period_, last_end_, day_type_) THEN
      Connect_Days___(calendar_id_, counter_, first_start_, first_period_, last_end_);
   END IF;
END New_Day__;


-- Remove_Calendar__
--   Removes all records for a specific calendar.
--   NOCHECK option is set on the comments, since non working days have
--   counter 0, which will not be removed if CASCADE option.
PROCEDURE Remove_Calendar__ (
   calendar_id_ IN VARCHAR2 )
IS
   CURSOR get_record IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM WORK_TIME_COUNTER_RES_TAB
      WHERE calendar_id = calendar_id_;
   remrec_  WORK_TIME_COUNTER_RES_TAB%ROWTYPE;
BEGIN
   FOR rec_ IN get_record LOOP
      remrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      Check_Delete___(remrec_);
      Delete___(rec_.objid, remrec_);
   END LOOP;
END Remove_Calendar__;


-- Exist_Numeric_Period__
--   Returns whether or not there are other periods than numeric ones (i.e.
--   with period values 1 through 9) - read Exist_Only_Numeric_Periods__
@UncheckedAccess
FUNCTION Exist_Numeric_Period__ (
   calendar_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   exist_  NUMBER;
   CURSOR get_period IS
      SELECT 0
      FROM WORK_TIME_COUNTER_RES_TAB
      WHERE period NOT IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
      AND calendar_id = calendar_id_;
BEGIN
   OPEN get_period;
   FETCH get_period INTO exist_;
   -- if no other periods than 1-9 exist, return TRUE
   IF (get_period%NOTFOUND) THEN
      exist_ := 1;
   END IF;
   CLOSE get_period;
   RETURN exist_;
END Exist_Numeric_Period__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


