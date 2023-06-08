-----------------------------------------------------------------------------
--
--  Logical unit: WorkTimeDayType
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130923  chanlk   Corrected Model file errors.
--  100422  Ajpe  Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  990506  JoEd  Added column connect_next. Added Pending check on Update___.
--  9904xx  JoEd  Removed unused methods. New template.
--  990413  JoEd  Call Id 15458: Changed "backwards" section in Get_Time_Stamp.
--                When time = start time and when time is not-working-time
--                is passed it calculated wrong.
--  990225  JoEd  Call id 9686: Get_Time_Stamp didn't calculate correct when
--                counting backwards.
--  990210  JoEd  Added method Get_Time_Stamp.
--  981117  JoEd  Added function Exist_Numeric_Period.
--  981026  JoEd  Removed Convert_Day_To_Array.
--  981021  JoEd  Removed state machine.
--                Added Get_Start_Time, Get_End_Time, Get_Min_Valid_From_Db
--                and Get_Max_Valid_To_Db.
--  9806xx-
--  980903  JoEd  Created from MchDayTypes
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CONNECT_NEXT', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     WORK_TIME_DAY_TYPE_TAB%ROWTYPE,
   newrec_     IN OUT WORK_TIME_DAY_TYPE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (newrec_.connect_next != oldrec_.connect_next) THEN
      Work_Time_Schedule_Desc_API.Set_Pending(newrec_.day_type);
      Work_Time_Exception_Code_API.Set_Pending(newrec_.day_type);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Activity_Start_Time
--   Returns the day's start time. If not working day NULL is returned.
@UncheckedAccess
FUNCTION Get_Activity_Start_Time (
   day_type_  IN VARCHAR2,
   curr_date_ IN DATE ) RETURN DATE
IS
   CURSOR get_record IS
      SELECT to_date(to_char(curr_date_, 'YYYYMMDD') || to_char(from_time, 'HH24MI'), 'YYYYMMDDHH24MI') start_time
      FROM WORK_TIME_DAY_TYPE_DESC_TAB
      WHERE reserved_time = 'N'
      AND day_type = day_type_
      ORDER BY 1;
   start_time_  DATE;
BEGIN
   OPEN get_record;
   FETCH get_record INTO start_time_;
   IF (get_record%NOTFOUND) THEN
      start_time_ := NULL;
   END IF;
   CLOSE get_record;
   RETURN start_time_;
END Get_Activity_Start_Time;


-- Get_Activity_End_Time
--   Returns the day's end time. If not working day NULL is returned.
@UncheckedAccess
FUNCTION Get_Activity_End_Time (
   day_type_ IN VARCHAR2,
   curr_date_ IN DATE ) RETURN DATE
IS
   CURSOR get_record IS
      SELECT to_date(to_char(curr_date_, 'YYYYMMDD') || to_char(to_time, 'HH24MI'), 'YYYYMMDDHH24MI') end_time
      FROM WORK_TIME_DAY_TYPE_DESC_TAB
      WHERE reserved_time = 'N'
      AND day_type = day_type_
      ORDER BY to_date(to_char(curr_date_, 'YYYYMMDD') || to_char(from_time, 'HH24MI'), 'YYYYMMDDHH24MI') DESC;
   end_time_  DATE;
BEGIN
   OPEN get_record;
   FETCH get_record INTO end_time_;
   IF (get_record%NOTFOUND) THEN
      end_time_ := NULL;
   ELSIF (to_char(end_time_, 'HH24:MI') = '00:00') THEN
      end_time_ := end_time_ + 1;
   END IF;
   CLOSE get_record;
   RETURN end_time_;
END Get_Activity_End_Time;



