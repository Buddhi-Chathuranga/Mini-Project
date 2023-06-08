-----------------------------------------------------------------------------
--
--  Logical unit: WorkTimeCounterDesc
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200514  RUMELK AMXTEND-327, Added functions Check_Valid_Start_Time and Get_New_Start_Time.
--  190221  Hasplk Bug 146893, Modified method Get_Working_Time_Between__ by adding new start_time where condition to limit no of records fetch.
--                 Modified cursors in method Is_Working_Time__ and Is_Working_Time_For_Time__ by adding rownum to limit records fetch.
--  160510  NRATLK  Bug 128545, Modified Get_Working_Time_Between__ for a performance improvement.
--  150708  VISHLK  BOULDER-118, Used bulk collect in the method Get_Working_Time_Between__ as a performance improvement.   
--  -------------------------------------------------------------------------
--  130723 VIATLK Bug 109158, Added Get_Period_Start_End, Get_Next_Period_Start_End and Get_Prev_Period_Start_End
--  110208 MAANLK Bug 95664, Modified function Get_Start_Time__() to use index hint for the cursor.
--  -------------------------------------------------------------------------
--  100422 Ajpelk Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  090911 ChAlLk Modified Get_Next_Work_Minute__ to get correct next work minute in all cases (Bug#85847).
--  090312 ChAlLk Modified Get_Work_Day_For_Time__ to check whether time falls within a schedule (Bug#80592).
--  080711 UsRaLK Added parameter round_off to method Get_Working_Time_Between__ (Bug#68092).
--  070719 ASWILK Bug 64688, Modified Connect_Days___ to add the wok hours to previous or bext day only if it span through midnight.
--  040611 MAKULK Merged LCS patch 41491.
--                040512 RuRalk Bug 41491, Modified cursor in Is_working_time
--  040112 Sobjse Bug 41035, Modified cursor in Is_working_time
--  030731 NaSalk SP4 Merge.
--  030114 Dobese Bug 34930, added order by and also some more performance changes in Get_Working_Time_Between__.
--  --------------------------------SP4 Merge -------------------------------
--  021212 ZAHALK Did the SP3 - Merge for Take-off. And did the decommenting.
--  020328 Dobese Bug 28605, minor performance changes
--  020118  JOMC  Bug 27459, Modified the cursor in Get_Working_Time_Between__.
--  011001  JOMC  Bug 22026, In Get_End_Time_For_Time__ and Get_Start_Time_For_Time__
--                modified the get_attr cursors and added calls to Get_Work_Day_For_Time__.
--  010906  JOMC  Bug 22026, Added Get_Work_Day_For_Time__, Get_Prev_Work_Day_For_Time__,
--                Get_Next_Work_Day_For_Time__, Get_End_Time_For_Time__,
--                Get_Start_Time_For_Time__, Is_Working_Time_For_Time__,
--                Get_Next_Work_Minute_By_Time__.
--  991117  JoEd  CID 27962: Changed cursor to work on several days as well
--                as one day time intervals.
--  991115  JoEd  CID 27962: Changed cursor in Get_Working_Time_Between__.
--                No data found when interval was within the same date.
--  990603  JoEd  Call id 19212: Changed where clause in Is_Working_Time__.
--  990517  JoEd  Added fetch of calendar id before insert loop.
--  990510  JoEd  Completed normal work time handling.
--                Renamed method Update_Prior_Day___ to Connect_Days___.
--                Call id 16444: Changed where clause in Get_Next_Work_Minute__.
--  990506  JoEd  Restricted search to normal working time. (not complete...)
--  990505  JoEd  Rebuild Get_Next_Period__, Get_Next_... and
--                Get_Previous_Work_Minute__. Removed Get_Time_Stamp__.
--  9904xx  JoEd  Created.
--  010612  Larelk Bug 22173, Remove last parameter(true) from  General_SYS.Init_Method
--                 in Get_Next_Period__,New_Work_Day__
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

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
   attr_          VARCHAR2(2000) := NULL;
   objid_         WORK_TIME_COUNTER_DESC.objid%TYPE;
   objversion_    WORK_TIME_COUNTER_DESC.objversion%TYPE;
   oldrec_        WORK_TIME_COUNTER_DESC_TAB%ROWTYPE;
   newrec_        WORK_TIME_COUNTER_DESC_TAB%ROWTYPE;
   indrec_        Indicator_Rec;
   connect_next_  VARCHAR2(5) := 'FALSE';
   count_         NUMBER;
   new_count_     NUMBER;

   CURSOR get_prior_header IS
      SELECT work_day, day_type
      FROM WORK_TIME_COUNTER_TAB
      WHERE counter = counter_ - 1
      AND calendar_id = calendar_id_;
   headrec_       get_prior_header%ROWTYPE;

   CURSOR get_prior_start IS
      SELECT start_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE period = period_
      AND end_time = start_time_
      AND counter = counter_ - 1
      AND calendar_id = calendar_id_;
   prior_start_   WORK_TIME_COUNTER_DESC_TAB.start_time%TYPE;

   -- fetches the time intervals in start time order - ascending
   -- to move forwards in time
   CURSOR get_day_periods_asc(counter_ IN NUMBER) IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion,
             start_time, end_time, period
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE counter = counter_
      AND calendar_id = calendar_id_
      ORDER BY start_time;

   -- fetches the time intervals in start time order - descending
   -- to move backwards in time
   CURSOR get_day_periods_desc(counter_ IN NUMBER) IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion,
             start_time, end_time, period
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE counter = counter_
      AND calendar_id = calendar_id_
      ORDER BY start_time DESC;
BEGIN
   OPEN get_prior_header;
   FETCH get_prior_header INTO headrec_;
   CLOSE get_prior_header;
   prior_date_ := headrec_.work_day;
   Trace_SYS.Field('prior date', prior_date_);
   IF (headrec_.day_type IS NOT NULL) THEN
      connect_next_ := nvl(Work_Time_Day_Type_API.Get_Connect_Next(headrec_.day_type), 'FALSE');
   END IF;
   Trace_SYS.Field('connect_next', connect_next_);

   -- if the prior date is actually the day before "this" day
   IF ((prior_date_ IS NOT NULL) AND (prior_date_ = (start_time_ - 1))) THEN
      OPEN get_prior_start;
      FETCH get_prior_start INTO prior_start_;
      -- did the last time interval for the prior date have the same period as "this" date?
      -- and did it end at midnight? and did it not start at midnight?
      IF get_prior_start%FOUND THEN
         Trace_SYS.Field('prior start time', prior_start_);
         IF (prior_start_ != trunc(prior_start_)) THEN
            -- if prior day's period equals "this period" and the record ends at midnight,
            -- remove "this" period interval and update the end time for the prior work day.
            Trace_SYS.Field('removing counter', counter_);
            Trace_SYS.Field('=> start_time', start_time_);
            Get_Id_Version_By_Keys___(objid_, objversion_, calendar_id_, counter_, start_time_);
            oldrec_ := Lock_By_Id___(objid_, objversion_);
            Delete___(objid_, oldrec_);

            Trace_SYS.Message('updating previous end time to ''' || to_char(oldrec_.end_time, 'YYYY-MM-DD HH24:MI') || '''');
            Get_Id_Version_By_Keys___(objid_, objversion_, calendar_id_, counter_ - 1, prior_start_);
            attr_ := NULL;
            Client_SYS.Add_To_Attr('END_TIME', oldrec_.end_time, attr_);
            oldrec_ := Lock_By_Id___(objid_, objversion_);
            newrec_ := oldrec_;
            Unpack___(newrec_, indrec_, attr_);
            Check_Update___(oldrec_, newrec_, indrec_, attr_);
            Update___(objid_, oldrec_, newrec_, attr_, objversion_);

            -- if connect to next day, set prior day's work_day to "this" day...
            IF (connect_next_ = 'TRUE') THEN
               Trace_SYS.Message('Moving previous work day''s periods to "this" day...');
               count_ := counter_ - 1;
               new_count_ := counter_;
               -- going backwards in time intervals.
               FOR rec_ IN get_day_periods_desc(counter_ - 1) LOOP
                  IF (rec_.period = period_) AND TRUNC(rec_.end_time) <> TRUNC(rec_.start_time) THEN
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
            -- ...otherwise set "this" day's work_day to prior day.
            ELSE
               Trace_SYS.Message('Moving "this" work day''s periods to previous day...');
               count_ := counter_;
               new_count_ := counter_ - 1;
               -- going forwards in time interval
               FOR rec_ IN get_day_periods_asc(counter_) LOOP
                  IF (rec_.period = period_) AND TRUNC(rec_.end_time) <> TRUNC(rec_.start_time) THEN
                     attr_ := NULL;
                     Client_SYS.Add_To_Attr('COUNTER', counter_ - 1, attr_);
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
            -- update the two affected headers' working time and number of periods
            Work_Time_Counter_API.Set_Working_Time__(calendar_id_, count_);
            Work_Time_Counter_API.Set_Working_Time__(calendar_id_, new_count_);
         ELSE
            Trace_SYS.Message('work day update not allowed - prior start date starts at midnight');
         END IF;
      ELSE
         Trace_SYS.Message('prior start time was not found!');
      END IF;
      CLOSE get_prior_start;
   ELSE
      Trace_SYS.Message('prior date doesn''t exist or is not the day before this date');
   END IF;
END Connect_Days___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Next_Work_Minute__
--   Returns the working minute after the bypassed one.
--   If the bypassed time is the calendar's last one, NULL is returned
@UncheckedAccess
FUNCTION Get_Next_Work_Minute__ (
   calendar_id_ IN VARCHAR2,
   work_time_ IN DATE ) RETURN DATE
IS
   next_time_ DATE;
   CURSOR get_time IS
      SELECT --+index(work_time_counter_desc_tab WORK_TIME_COUNTER_DESC_IX3)
             start_time, end_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE work_time_ <= end_time
      AND calendar_id = calendar_id_
      ORDER BY end_time;

BEGIN
   next_time_ := work_time_;
   FOR rec_ IN get_time LOOP
      -- move one minute forward in time for each loop
      next_time_ := next_time_ + (1 / 1440);
      -- if current time is equal to current day's end time, move to next working day -
      -- also, if current time isn't a working day, move to next working day
      IF (next_time_ > rec_.start_time AND next_time_ <= rec_.end_time) THEN
         RETURN next_time_;
      ELSIF (rec_.start_time >= next_time_) THEN
         -- returns the next period's start time + 1 minute
         RETURN rec_.start_time + (1 / 1440);
      END IF;
   END LOOP;
   RETURN NULL;
END Get_Next_Work_Minute__;


-- Get_Next_Work_Minute_By_Time__
--   Returns the working minute after the bypassed one.
--   If the bypassed time is the calendar's last one, NULL is returned
--   This method returns the next period's start time, not the next period's
--   start time + one minute as Get_Next_Work_Minute__ does.
@UncheckedAccess
FUNCTION Get_Next_Work_Minute_By_Time__ (
   calendar_id_ IN VARCHAR2,
   work_time_ IN DATE ) RETURN DATE
IS
   next_time_ DATE;
   CURSOR get_time IS
      SELECT start_time, end_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE ((work_time_ >= start_time AND work_time_ <= end_time) OR (start_time > work_time_))
      AND calendar_id = calendar_id_
      ORDER BY start_time;
BEGIN
   next_time_ := work_time_;
   FOR rec_ IN get_time LOOP
      -- move one minute forward in time for each loop
      next_time_ := next_time_ + (1 / 1440);
      -- if current time is equal to current day's end time, move to next working day -
      -- also, if current time isn't a working day, move to next working day
      IF (next_time_ > rec_.start_time AND next_time_ <= rec_.end_time) THEN
         RETURN next_time_;
      ELSIF (rec_.start_time > next_time_) THEN
         -- returns the next period's start time
         RETURN rec_.start_time;
      END IF;
   END LOOP;
   RETURN NULL;
END Get_Next_Work_Minute_By_Time__;


-- Get_Previous_Work_Minute__
--   Returns the working minute prior to the bypassed one.
--   If the bypassed time is the calendar's first one, NULL is returned
@UncheckedAccess
FUNCTION Get_Previous_Work_Minute__ (
   calendar_id_ IN VARCHAR2,
   work_time_ IN DATE ) RETURN DATE
IS
   prev_time_ DATE;
   CURSOR get_time IS
      SELECT --+index(work_time_counter_desc_tab WORK_TIME_COUNTER_DESC_IX2)
             start_time, end_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE work_time_ > start_time
      AND calendar_id = calendar_id_
      ORDER BY start_time DESC;
BEGIN
   prev_time_ := work_time_;
   FOR rec_ IN get_time LOOP
      -- move one minute back in time for each loop
      prev_time_ := prev_time_ - (1 / 1440);
      -- if current time is equal to current day's start time, move to previous working day -
      -- also, if current time isn't a working day, move to previous working day
      IF (prev_time_ > rec_.start_time AND prev_time_ <= rec_.end_time) THEN
         RETURN prev_time_;
      ELSIF (rec_.end_time < prev_time_) THEN
         -- returns the previous period's end time
         RETURN rec_.end_time;
      END IF;
   END LOOP;
   RETURN NULL;
END Get_Previous_Work_Minute__;


@UncheckedAccess
FUNCTION Get_Next_Work_Day_For_Time__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
   temp_   DATE;
   temp_work_day_  WORK_TIME_COUNTER_DESC_TAB.work_day%TYPE;
   CURSOR get_work_day_ IS
      SELECT MIN(work_day)
      FROM   WORK_TIME_COUNTER_DESC_TAB
      WHERE calendar_id = calendar_id_
      AND   work_day > temp_work_day_;

BEGIN
   temp_work_day_ := Get_Work_Day_For_Time__(calendar_id_,work_day_);
   OPEN get_work_day_;
   FETCH get_work_day_ INTO temp_;
   CLOSE get_work_day_;
   RETURN temp_;
END Get_Next_Work_Day_For_Time__;


-- Get_Prev_Work_Day_For_Time__
--   Returns the work day that precedes the working day of a
--   specific point in time.
--   This method will return the work day for a day that spans
--   two calendar days,
--   e.g. a work day that runs from 8:00 PM one day to 8:00 PM the next day.
@UncheckedAccess
FUNCTION Get_Prev_Work_Day_For_Time__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
   temp_   DATE;
   temp_work_day_  WORK_TIME_COUNTER_DESC_TAB.work_day%TYPE;

   CURSOR get_work_day_ IS
      SELECT max(work_day)
      FROM   WORK_TIME_COUNTER_DESC_TAB
      WHERE  calendar_id = calendar_id_
      AND    work_day < temp_work_day_;

BEGIN
   temp_work_day_ := Get_Work_Day_For_Time__(calendar_id_,work_day_);
   OPEN get_work_day_;
   FETCH get_work_day_ INTO temp_;
   CLOSE get_work_day_;
   RETURN temp_;
END Get_Prev_Work_Day_For_Time__;


-- Get_Work_Day_For_Time__
--   Returns the working day for a specific point in time.
--   This method will return the work day for a day that spans two calendar days,
--   e.g. a work day that runs from 8:00 PM one day to 8:00 PM the next day.
@UncheckedAccess
FUNCTION Get_Work_Day_For_Time__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
   temp_   DATE;
   CURSOR get_work_day_ IS
      SELECT work_day
      FROM   WORK_TIME_COUNTER_DESC_TAB
      WHERE  calendar_id = calendar_id_
      AND start_time =
        (SELECT MAX(start_time)
         FROM WORK_TIME_COUNTER_DESC_TAB
         WHERE calendar_id = calendar_id_
         AND   start_time <= work_day_);
BEGIN

   IF Is_Working_Time_For_Time__(calendar_id_, work_day_) = 0 then
      RETURN trunc(work_day_);
   END IF;

   OPEN get_work_day_;
   FETCH get_work_day_ INTO temp_;
   CLOSE get_work_day_;
   RETURN temp_;
END Get_Work_Day_For_Time__;


-- Get_Working_Time__
--   Return number of working minutes a specific day and for a specific period
--   Period % is used from WorkTimeCounter's Set_Working_Time method.
--   This method will return the work day for a day that spans two calendar days,
--   e.g. a work day that runs from 8:00 PM one day to 8:00 PM the next day.
@UncheckedAccess
FUNCTION Get_Working_Time__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE,
   period_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_   NUMBER;
   CURSOR get_minutes IS
      SELECT sum(round(to_number(end_time - start_time) * 1440))
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE ((period = period_) OR (period_ IS NULL))
      AND work_day = work_day_
      AND calendar_id = calendar_id_;
BEGIN
   OPEN get_minutes;
   FETCH get_minutes INTO temp_;
   CLOSE get_minutes;
   RETURN nvl(temp_, 0);
END Get_Working_Time__;


-- Get_Working_Time_Between__
--   Returns number of working minutes between two timestamps.
@UncheckedAccess
FUNCTION Get_Working_Time_Between__ (
   calendar_id_   IN VARCHAR2,
   start_time_    IN DATE,
   end_time_      IN DATE,
   round_off_     IN VARCHAR2 DEFAULT 'TRUE' ) RETURN NUMBER
IS
   minutes_     NUMBER := 0;
   min_         NUMBER;
   first_row_   BOOLEAN := TRUE;
   
   CURSOR get_record IS
      SELECT --+INDEX(WORK_TIME_COUNTER_DESC_TAB work_time_counter_desc_ix2)
      start_time, end_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE calendar_id = calendar_id_
      AND end_time   >= start_time_
      AND start_time <  end_time_
      AND start_time > (start_time_ - 2)
      ORDER BY end_time;

   TYPE work_time_ctr_desc_rec_tab IS TABLE OF get_record%ROWTYPE;
   work_time_ctr_desc_rec_tab_     work_time_ctr_desc_rec_tab;    

BEGIN
   OPEN get_record;
   FETCH get_record BULK COLLECT INTO work_time_ctr_desc_rec_tab_;
   CLOSE get_record;   
   
   IF (work_time_ctr_desc_rec_tab_.COUNT <> 0) THEN
      FOR index_ IN work_time_ctr_desc_rec_tab_.FIRST..work_time_ctr_desc_rec_tab_.LAST LOOP
         IF first_row_ THEN
            -- set start time to from time if from time starts after start time
            IF (start_time_ > work_time_ctr_desc_rec_tab_(index_).start_time) THEN
               work_time_ctr_desc_rec_tab_(index_).start_time := start_time_;
            END IF;
            IF (work_time_ctr_desc_rec_tab_(index_).start_time > work_time_ctr_desc_rec_tab_(index_).end_time) THEN
               work_time_ctr_desc_rec_tab_(index_).end_time := work_time_ctr_desc_rec_tab_(index_).start_time;
            END IF;
            first_row_ := FALSE;
         END IF;
         -- if the interval's end time is prior to given end time
         IF (work_time_ctr_desc_rec_tab_(index_).end_time < end_time_) THEN
            min_ := to_number(work_time_ctr_desc_rec_tab_(index_).end_time - work_time_ctr_desc_rec_tab_(index_).start_time) * 1440;
         -- otherwise remove number of minutes from given end time
         ELSE
            min_ := to_number(end_time_ - work_time_ctr_desc_rec_tab_(index_).start_time) * 1440;
         END IF;
         -- if the time difference is negative - set 0 minutes
         IF (min_ < 0) THEN
            min_ := 0;
         END IF;
         -- add # minutes within current interval - sometimes the diff is shown with decimals. Round them.
         IF (round_off_ = 'TRUE') THEN
            minutes_ := minutes_ + round(min_);
         ELSE
            minutes_ := minutes_ + min_;
         END IF;
      END LOOP;
   END IF;
   RETURN minutes_;
END Get_Working_Time_Between__;


-- Is_Working_Time__
--   Returns whether or not the bypassed timestamp is working time
@UncheckedAccess
FUNCTION Is_Working_Time__ (
   calendar_id_ IN VARCHAR2,
   work_time_ IN DATE ) RETURN NUMBER
IS
   found_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE (work_time_ > start_time AND work_time_ <= end_time)
      AND calendar_id = calendar_id_
      AND rownum = 1;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF exist_control%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN found_;
END Is_Working_Time__;


-- Is_Working_Time_For_Time__
--   Returns whether or not the bypassed timestamp is working time. This method
--   uses "BETWEEN" rather than ">", so it doen't exclude any of the time slice.
@UncheckedAccess
FUNCTION Is_Working_Time_For_Time__ (
   calendar_id_ IN VARCHAR2,
   work_time_ IN DATE ) RETURN NUMBER
IS
   found_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE work_time_ BETWEEN start_time AND end_time
      AND calendar_id = calendar_id_
      AND rownum = 1;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF exist_control%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN found_;
END Is_Working_Time_For_Time__;


-- Get_Start_Time__
--   Returns the working day's first start time
@UncheckedAccess
FUNCTION Get_Start_Time__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
   temp_  WORK_TIME_COUNTER_DESC_TAB.start_time%TYPE;
   
   --Modified cursor to use index hints.
   CURSOR get_attr IS
      SELECT --+INDEX(WORK_TIME_COUNTER_DESC_TAB WORK_TIME_COUNTER_DESC_IX1)
            start_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE work_day    = work_day_
      AND   calendar_id = calendar_id_
      ORDER BY start_time;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Start_Time__;


-- Get_Start_Time_For_Time__
--   Returns the working day's first start time for a specific point in time.
@UncheckedAccess
FUNCTION Get_Start_Time_For_Time__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
   temp_           WORK_TIME_COUNTER_DESC_TAB.start_time%TYPE;
   temp_work_day_  WORK_TIME_COUNTER_DESC_TAB.work_day%TYPE;
   CURSOR get_attr IS
      SELECT MIN(start_time)
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE  work_day = temp_work_day_
      AND calendar_id = calendar_id_;
BEGIN
   temp_work_day_ := Get_Work_Day_For_Time__(calendar_id_,work_day_);
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Start_Time_For_Time__;


-- Get_End_Time__
--   Returns the working day's last end time
@UncheckedAccess
FUNCTION Get_End_Time__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
   temp_  WORK_TIME_COUNTER_DESC_TAB.end_time%TYPE;
   CURSOR get_attr IS
      SELECT end_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE work_day = work_day_
      AND calendar_id = calendar_id_
      ORDER BY start_time DESC;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_End_Time__;


-- Get_End_Time_For_Time__
--   Returns the working day's last end time for a specific point in time
@UncheckedAccess
FUNCTION Get_End_Time_For_Time__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE ) RETURN DATE
IS
   temp_           WORK_TIME_COUNTER_DESC_TAB.end_time%TYPE;
   temp_work_day_  WORK_TIME_COUNTER_DESC_TAB.work_day%TYPE;
   CURSOR get_attr IS
      SELECT MAX(end_time)
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE work_day = temp_work_day_
      AND calendar_id = calendar_id_;
BEGIN
   temp_work_day_ := Get_Work_Day_For_Time__(calendar_id_,work_day_);
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_End_Time_For_Time__;


-- Get_Period__
--   Returns the period for the specific working time
--   If no working time, NULL is returned
@UncheckedAccess
FUNCTION Get_Period__ (
   calendar_id_ IN VARCHAR2,
   work_time_ IN DATE ) RETURN VARCHAR2
IS
   period_  WORK_TIME_COUNTER_DESC_TAB.period%TYPE;
   CURSOR get_period IS
      SELECT period
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE (work_time_ > start_time AND work_time_ <= end_time)
      AND calendar_id = calendar_id_;
BEGIN
   OPEN get_period;
   FETCH get_period INTO period_;
   CLOSE get_period;
   RETURN period_;
END Get_Period__;


-- Get_Period_Start__
--   Returns the start time for the specific working day and period.
@UncheckedAccess
FUNCTION Get_Period_Start__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE,
   period_ IN VARCHAR2 ) RETURN DATE
IS
   start_time_ WORK_TIME_COUNTER_DESC_TAB.start_time%TYPE;
   CURSOR get_start IS
      SELECT start_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE period = period_
      AND work_day = work_day_
      AND calendar_id = calendar_id_
      ORDER BY start_time;
BEGIN
   OPEN get_start;
   FETCH get_start INTO start_time_;
   CLOSE get_start;
   RETURN start_time_;
END Get_Period_Start__;


-- Get_Period_End__
--   Returns the end time for the specific working day and period.
@UncheckedAccess
FUNCTION Get_Period_End__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE,
   period_ IN VARCHAR2 ) RETURN DATE
IS
   end_time_ WORK_TIME_COUNTER_DESC_TAB.end_time%TYPE;
   CURSOR get_end IS
      SELECT end_time
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE period = period_
      AND work_day = work_day_
      AND calendar_id = calendar_id_
      ORDER BY start_time DESC;
BEGIN
   OPEN get_end;
   FETCH get_end INTO end_time_;
   CLOSE get_end;
   RETURN end_time_;
END Get_Period_End__;


-- Get_Next_Period__
--   Returns the period and it's time interval, that comes after the
--   bypassed period. If period is NULL, the working day's first period and
--   time interval is returned.
--   If no more periods or the calendar is invalid or non-existant null is returned
PROCEDURE Get_Next_Period__ (
   period_ IN OUT VARCHAR2,
   from_time_ IN OUT DATE,
   to_time_ IN OUT DATE,
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE )
IS
   new_period_ WORK_TIME_COUNTER_DESC_TAB.period%TYPE;
   found_      BOOLEAN := FALSE;

   CURSOR get_period IS
      SELECT --+index(work_time_counter_desc_tab WORK_TIME_COUNTER_DESC_IX3))
             period
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE ((to_time_ IS NULL) OR (end_time >= to_time_))
      AND work_day = work_day_
      AND calendar_id = calendar_id_
      ORDER BY end_time;
BEGIN
   new_period_ := period_;
   FOR rec_ IN get_period LOOP
      found_ := TRUE;
      IF ((period_ IS NULL) OR (period_ != rec_.period)) THEN
         new_period_ := rec_.period;
         from_time_ := Get_Period_Start__(calendar_id_, work_day_, new_period_);
         to_time_ := Get_Period_End__(calendar_id_, work_day_, new_period_);
         EXIT; -- loop
      END IF;
   END LOOP;
   -- if nothing was found or somehow the periods became the same as bypassed value, return NULL
   IF (NOT found_ OR (period_ = new_period_)) THEN
      new_period_ := NULL;
      from_time_ := NULL;
      to_time_ := NULL;
   END IF;
   period_ := new_period_;
END Get_Next_Period__;


-- Exist_Period__
--   Returns whether or not the period exists on the specific day.
@UncheckedAccess
FUNCTION Exist_Period__ (
   calendar_id_ IN VARCHAR2,
   work_day_ IN DATE,
   period_ IN VARCHAR2 ) RETURN NUMBER
IS
   exist_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM WORK_TIME_COUNTER_DESC_TAB
      WHERE period = period_
      AND work_day = work_day_
      AND calendar_id = calendar_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO exist_;
   IF exist_control%NOTFOUND THEN
      exist_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN exist_;
END Exist_Period__;


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
      FROM WORK_TIME_COUNTER_DESC_TAB
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


-- New_Work_Day__
--   Creates details for a calendar work day using the bypassed day type.
PROCEDURE New_Work_Day__ (
   calendar_id_ IN VARCHAR2,
   counter_ IN NUMBER,
   work_day_ IN DATE,
   day_type_ IN VARCHAR2 )
IS
   curr_date_    VARCHAR2(8) := to_char(work_day_, 'YYYYMMDD');
   first_period_ WORK_TIME_COUNTER_DESC_TAB.period%TYPE := NULL;
   first_start_  WORK_TIME_COUNTER_DESC_TAB.start_time%TYPE;
   last_end_     WORK_TIME_COUNTER_DESC_TAB.end_time%TYPE;
   attr_         VARCHAR2(2000);
   objid_        WORK_TIME_COUNTER_DESC.objid%TYPE;
   objversion_   WORK_TIME_COUNTER_DESC.objversion%TYPE;
   newrec_       WORK_TIME_COUNTER_DESC_TAB%ROWTYPE;
   indrec_       Indicator_Rec;

   CURSOR get_day_type IS
      SELECT to_date(curr_date_ || to_char(from_time, 'HH24MI'), 'YYYYMMDDHH24MI') start_time,
             to_date(curr_date_ || to_char(to_time, 'HH24MI'), 'YYYYMMDDHH24MI') end_time,
             period
      FROM WORK_TIME_DAY_TYPE_DESC_TAB
      WHERE reserved_time = 'N'
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
   IF (to_char(first_start_, 'HH24:MI') = '00:00') THEN
      IF (to_char(last_end_, 'HH24:MI') = '00:00') AND (Work_Time_Counter_API.Get_Working_Periods__(calendar_id_, work_day_) < 2) THEN
         Trace_SYS.Message('End time is midnight and no. of periods is 0 or 1 - do nothing!');
      ELSE
         Connect_Days___(calendar_id_, counter_, first_start_, first_period_, last_end_);
      END IF;
   END IF;
END New_Work_Day__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Get_Period_Start_End(
   start_time_  OUT DATE,
   end_time_    OUT DATE,
   calendar_id_ IN VARCHAR2,
   counter_     IN NUMBER,
   work_time_   IN DATE)
   IS

   CURSOR get_time IS
      SELECT start_time, end_time
        FROM WORK_TIME_COUNTER_DESC_TAB
       WHERE work_time_ >= start_time AND work_time_ <= end_time
         AND counter = counter_
         AND calendar_id = calendar_id_;
BEGIN
   OPEN get_time ;
   FETCH get_time INTO start_time_, end_time_;
   CLOSE get_time;

END Get_Period_Start_End;      


@UncheckedAccess
PROCEDURE Get_Next_Period_Start_End(
    start_time_   IN OUT  DATE,
    end_time_     IN OUT  DATE,
    counter_      IN      NUMBER,
    calendar_id_  IN      VARCHAR2,
    work_time_    IN      DATE )
   IS

   next_ BOOLEAN :=FALSE;

   CURSOR get_next IS
      SELECT start_time, end_time
        FROM WORK_TIME_COUNTER_DESC_TAB
       WHERE counter >= counter_
         AND calendar_id = calendar_id_
         AND work_day >= trunc(work_time_)
         ORDER BY start_time;
  
BEGIN

   FOR rec_ IN get_next LOOP
       IF next_ THEN
          start_time_ := rec_.start_time;
          end_time_ := rec_.end_time;
          EXIT; --loop
       END IF;
       IF (start_time_ = rec_.start_time AND end_time_ = rec_.end_time) THEN
          next_ := TRUE;
       END IF;
   END LOOP;
END Get_Next_Period_Start_End;


@UncheckedAccess
PROCEDURE Get_Prev_Period_Start_End(
   start_time_   IN OUT  DATE,
   end_time_     IN OUT  DATE,
   calendar_id_  IN      VARCHAR2)

   IS

   CURSOR get_prev IS
      SELECT start_time, end_time
        FROM WORK_TIME_COUNTER_DESC_TAB
       WHERE calendar_id = calendar_id_
         AND end_time < = start_time_
         ORDER BY start_time DESC;         

BEGIN

   OPEN get_prev;
   FETCH get_prev INTO start_time_, end_time_;
   CLOSE get_prev;

END Get_Prev_Period_Start_End;


FUNCTION Check_Valid_Start_Time(
   calendar_id_ IN VARCHAR2,
   start_time_  IN DATE) RETURN BOOLEAN
IS
   CURSOR check_valid_start IS
      SELECT --+index(work_time_counter_desc_tab WORK_TIME_COUNTER_DESC_IX4)
             1
      FROM   work_time_counter_desc_tab t
      WHERE  t.calendar_id = calendar_id_
         AND start_time_ >= t.start_time 
         AND start_time_ < t.end_time;
   
   exist_ NUMBER;
   ret_value_ BOOLEAN := FALSE;
BEGIN
   OPEN check_valid_start;
   FETCH check_valid_start INTO exist_;
   IF check_valid_start%FOUND THEN
      ret_value_ := TRUE;
   END IF;
   CLOSE check_valid_start;
   
   RETURN ret_value_; 
END Check_Valid_Start_Time;


FUNCTION Get_New_Start_Time(
   calendar_id_ IN VARCHAR2,
   start_time_  IN DATE) RETURN DATE
IS
   CURSOR get_new_start_time IS
      SELECT --+index(work_time_counter_desc_tab WORK_TIME_COUNTER_DESC_IX4)
             MIN(t.start_time)
      FROM   work_time_counter_desc_tab t
      WHERE  t.calendar_id = calendar_id_
         AND t.start_time > start_time_;
   
   new_start_time_ DATE;
BEGIN
   OPEN get_new_start_time;
   FETCH get_new_start_time INTO new_start_time_;
   CLOSE get_new_start_time;
   
   RETURN new_start_time_;
END Get_New_Start_Time;
