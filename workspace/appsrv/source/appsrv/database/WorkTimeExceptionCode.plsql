-----------------------------------------------------------------------------
--
--  Logical unit: WorkTimeExceptionCode
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990505  JoEd  Added Set_Pending call on Delete.
--  9904xx  JoEd  Removed unused methods. New template.
--  990202  JoEd  Added comments to the methods.
--  981113  JoEd  SID 6877: Changed end time from 23:59 Current to 00:00 Next
--                in Check_Interval___.
--  981019  JoEd  Removed state check and added call to Calendar when anything
--                has changed.
--                Changed Check_Interval___.
--  9806xx-
--  980903  JoEd  Created from MchSubSchedDesc
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT WORK_TIME_EXCEPTION_CODE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);

   Work_Time_Calendar_API.Set_Exception_Pending(newrec_.exception_code);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     WORK_TIME_EXCEPTION_CODE_TAB%ROWTYPE,
   newrec_     IN OUT WORK_TIME_EXCEPTION_CODE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   IF ((newrec_.day_type <> oldrec_.day_type) OR (newrec_.exception_date <> oldrec_.exception_date)) THEN
      Work_Time_Calendar_API.Set_Exception_Pending(newrec_.exception_code);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN WORK_TIME_EXCEPTION_CODE_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Work_Time_Calendar_API.Set_Exception_Pending(remrec_.exception_code);
END Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Set_Pending
--   Called from WorkTimeDayTypeDesc when a day type has been changed.
--   Invalidates all calendars that uses the exceptions using the bypassed
--   day type.
PROCEDURE Set_Pending (
   day_type_ IN VARCHAR2 )
IS
   CURSOR get_exception IS
      SELECT DISTINCT exception_code
      FROM WORK_TIME_EXCEPTION_CODE_TAB
      WHERE day_type = day_type_;
BEGIN
   FOR rec_ IN get_exception LOOP
      Work_Time_Calendar_API.Set_Exception_Pending(rec_.exception_code);
   END LOOP;
END Set_Pending;



