-----------------------------------------------------------------------------
--
--  Logical unit: WorkTimeScheduleDesc
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130923  chanlk   Corrected Model file errors.
--  040220 DHSELK Removed substrb and changed to substr where needed for Unicode Support
--  990421  JoEd  New template.
--                Renamed Set_Invalid to Set_Pending.
--  990211  JoEd  Rebuild Get_Day_Type:2.
--  981105  JoEd  Added extra where on cursor in Set_Invalid to use primary key.
--  9810xx  JoEd  Changed modification behaviour. Removed unused methods.
--                Changed error messages.
--  9806xx-
--  980903  JoEd  Created from MchBaseSchedDesc
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Interval___
--   Checks that the user has entered valid day types and that they start
--   and ends correctly.
PROCEDURE Check_Interval___ (
   newrec_ IN WORK_TIME_SCHEDULE_DESC_TAB%ROWTYPE,
   objid_  IN VARCHAR2 )
IS
   new_start_  DATE;
   new_end_    DATE;
   cmp_start_  DATE;
   cmp_end_    DATE;
   curr_date_  DATE;
   CURSOR get_record IS
      SELECT rowid objid, day_type, period_pos
      FROM WORK_TIME_SCHEDULE_DESC_TAB
      WHERE schedule = newrec_.schedule;
BEGIN
   curr_date_ := SYSDATE;
   new_start_ := Work_Time_Day_Type_API.Get_Activity_Start_Time(newrec_.day_type, newrec_.period_pos + curr_date_);
   new_end_ := Work_Time_Day_Type_API.Get_Activity_End_Time(newrec_.day_type, newrec_.period_pos + curr_date_);
   FOR rec_ IN get_record LOOP
      IF (((objid_ IS NULL) OR (objid_ != rec_.objid)) AND (rec_.day_type IS NOT NULL)) THEN
         cmp_start_ := Work_Time_Day_Type_API.Get_Activity_Start_Time(rec_.day_type, rec_.period_pos + curr_date_);
         cmp_end_ := Work_Time_Day_Type_API.Get_Activity_End_Time(rec_.day_type, rec_.period_pos + curr_date_);
         IF ((new_start_ > cmp_start_) AND (new_start_ < cmp_end_)) THEN
            Error_SYS.Record_General(lu_name_, 'INV_START: The day type :P1 has invalid start time!', newrec_.day_type);
         ELSIF ((new_end_ > cmp_start_) AND (new_end_ < cmp_end_)) THEN
            Error_SYS.Record_General(lu_name_, 'INV_END: The day type :P1 has invalid end time!', newrec_.day_type);
         ELSIF ((new_start_ < cmp_start_) AND (new_end_ > cmp_end_)) THEN
            Error_SYS.Record_General(lu_name_, 'INV_OVERLAP: The day type :P1 overlaps another day type!', newrec_.day_type);
         END IF;
      END IF;
   END LOOP;
END Check_Interval___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT WORK_TIME_SCHEDULE_DESC_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);

   Work_Time_Calendar_Desc_API.Set_Schedule_Pending(newrec_.schedule);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     WORK_TIME_SCHEDULE_DESC_TAB%ROWTYPE,
   newrec_     IN OUT WORK_TIME_SCHEDULE_DESC_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Check_Interval___(newrec_, objid_);

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   Work_Time_Calendar_Desc_API.Set_Schedule_Pending(newrec_.schedule);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN WORK_TIME_SCHEDULE_DESC_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Work_Time_Calendar_Desc_API.Set_Schedule_Pending(remrec_.schedule);
END Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Sched_Period__
--   Called from WorkTimeSchedule when header is created to automatically
--   create correct number of detail rows.
PROCEDURE Create_Sched_Period__ (
   schedule_ IN VARCHAR2,
   period_length_ IN NUMBER,
   period_start_day_ IN VARCHAR2 )
IS
   newrec_       WORK_TIME_SCHEDULE_DESC_TAB%ROWTYPE;
   indrec_       Indicator_Rec;
   objid_        WORK_TIME_SCHEDULE_DESC.objid%TYPE;
   objversion_   WORK_TIME_SCHEDULE_DESC.objversion%TYPE;
   attr_         VARCHAR2(2000);
   current_day_  NUMBER;
BEGIN
   current_day_ := to_number(period_start_day_);
   FOR n_ IN 1..period_length_ LOOP
      Prepare_Insert___(attr_);
      Client_SYS.Add_To_Attr('SCHEDULE', schedule_, attr_);
      Client_SYS.Add_To_Attr('PERIOD_POS', n_, attr_);
      Client_SYS.Add_To_Attr('PERIOD_DAY_DB', current_day_, attr_);
      Client_SYS.Add_To_Attr('DAY_TYPE', '', attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
      current_day_ := mod(current_day_, 7) + 1;
   END LOOP;
END Create_Sched_Period__;


-- Delete_Sched_Period__
--   Used when updating schedule header's period length to recreate
--   the details.
PROCEDURE Delete_Sched_Period__ (
   schedule_ IN VARCHAR2 )
IS
   remrec_      WORK_TIME_SCHEDULE_DESC_TAB%ROWTYPE;
   objid_       WORK_TIME_SCHEDULE_DESC.objid%TYPE;
   objversion_  WORK_TIME_SCHEDULE_DESC.objversion%TYPE;

   CURSOR get_record IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM WORK_TIME_SCHEDULE_DESC_TAB
      WHERE schedule = schedule_;
BEGIN
   FOR rec_ IN get_record LOOP
      objid_ := rec_.objid;
      objversion_ := rec_.objversion;
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END LOOP;
END Delete_Sched_Period__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Set_Pending
--   Called from WorkTimeDayTypeDesc when a day type has been changed.
--   Invalidates all calendars that uses the schedules using the bypassed
--   day type.
PROCEDURE Set_Pending (
   day_type_ IN VARCHAR2 )
IS
   CURSOR get_schedule IS
      SELECT distinct(schedule) schedule
      FROM WORK_TIME_SCHEDULE_DESC_TAB
      WHERE day_type = day_type_
      AND schedule > ' ';
BEGIN
   FOR rec_ IN get_schedule LOOP
      Work_Time_Calendar_Desc_API.Set_Schedule_Pending(rec_.schedule);
   END LOOP;
END Set_Pending;


-- Get_Day_Type
--   Returns the day type by finding the period position via a date.
@UncheckedAccess
FUNCTION Get_Day_Type (
   schedule_ IN VARCHAR2,
   schedule_date_ IN DATE,
   curr_date_ IN DATE ) RETURN VARCHAR2
IS
   period_length_  NUMBER;
   pos_           NUMBER := 0;
BEGIN
   IF (curr_date_ >= schedule_date_) THEN
      period_length_ := Work_Time_Schedule_API.Get_Period_Length(schedule_);
      pos_ := mod((trunc(curr_date_) - trunc(schedule_date_)), period_length_) + 1;
      RETURN Get_Day_Type(schedule_, pos_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Day_Type;



