-----------------------------------------------------------------------------
--
--  Logical unit: SodCache
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100316  DUWI    Created.
--  130822  PGAN  Added REF to column cache_task_ref of view SOD_CACHE (Bug#109335)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Enable_Batch_Schedule___ (
   schedule_id_ IN OUT NUMBER )
IS
   no_batch_schedule EXCEPTION;
   PRAGMA EXCEPTION_INIT(no_batch_schedule, -20111);
BEGIN
   Batch_Schedule_API.Activate__(schedule_id_);
EXCEPTION
      WHEN no_batch_schedule THEN
         schedule_id_ := NULL;
END Enable_Batch_Schedule___;


PROCEDURE Disable_Batch_Schedule___ (
   schedule_id_ IN OUT NUMBER )
IS
   no_batch_schedule EXCEPTION;
   PRAGMA EXCEPTION_INIT(no_batch_schedule, -20111);
BEGIN
   Batch_Schedule_API.Deactivate__(schedule_id_);
EXCEPTION
      WHEN no_batch_schedule THEN
         schedule_id_ := NULL;
END Disable_Batch_Schedule___;


FUNCTION Create_Batch_Schedule___ (
   method_name_ IN VARCHAR2,
   schedule_name_ IN VARCHAR2,
   execution_plan_ IN VARCHAR2,
   installation_id_ IN NUMBER ) RETURN NUMBER
IS
   schedule_id_         NUMBER;
   next_execution_date_ DATE;
   start_date_          DATE := SYSDATE;
BEGIN
   IF (Batch_SYS.Exist_Batch_Schedule(installation_id_) = 0) THEN
      Batch_SYS.New_Batch_Schedule(schedule_id_,
                                   next_execution_date_,
                                   start_date_,
                                   NULL,
                                   schedule_name_,
                                   method_name_,
                                   'TRUE',
                                   execution_plan_);
   END IF;
   RETURN (schedule_id_);
END Create_Batch_Schedule___;


FUNCTION Get_Cache_Task_Ref___ RETURN NUMBER
IS
   schedule_id_ NUMBER;
   CURSOR getrec IS
      SELECT cache_task_ref
      FROM  SOD_CACHE_TAB
      WHERE ROWVERSION = 1;
BEGIN
   OPEN getrec;
   FETCH getrec INTO schedule_id_;
   CLOSE getrec;
   RETURN(schedule_id_);
END Get_Cache_Task_Ref___;


-- Check_Exist___
--   Check if a specific LU-instance already exist in the database.
FUNCTION Check_Exist___ RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SOD_CACHE_TAB
      WHERE ROWVERSION = 1;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Exist___;


FUNCTION Check_Cache_Task_Ref___ RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SOD_CACHE_TAB
      WHERE ROWVERSION = 1 AND CACHE_TASK_REF IS NOT NULL;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Cache_Task_Ref___;


FUNCTION Check_Enable_Cache___ RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SOD_CACHE_TAB
      WHERE ROWVERSION = 1 AND CACHE_ENABLE IS NOT NULL;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Enable_Cache___;


PROCEDURE Insert_Single_Rec___
IS
BEGIN
   INSERT INTO sod_cache_tab (
      cache_task_ref,
      cache_enable,
      rowversion)
   VALUES (
      NULL,
      'FALSE',
      1);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert_Single_Rec___;


PROCEDURE Update_Enable_Cache___(
   enable_  IN VARCHAR2)
IS
BEGIN
   UPDATE sod_cache_tab
      SET cache_enable = enable_
      WHERE rowversion = 1;
END Update_Enable_Cache___;


PROCEDURE Update_Cache_Task_Ref___(
   schedule_id_  IN NUMBER)
IS
BEGIN
   UPDATE sod_cache_tab
      SET cache_task_ref = schedule_id_
      WHERE rowversion = 1;
END Update_Cache_Task_Ref___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist
IS
BEGIN
   IF (NOT Check_Exist___) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
END Exist;


PROCEDURE Enable_Cache
IS
   schedule_id_ NUMBER;
BEGIN
   -- Check the line is exist
   IF Check_Exist___ THEN
      -- Update the Cache_Enable flag to TRUE
      Update_Enable_Cache___('TRUE');
      -- IF Schedule_ref exist then 
      IF Check_Cache_Task_Ref___ THEN
         schedule_id_ := Get_Cache_Task_Ref___;
         Enable_Batch_Schedule___(schedule_id_);
      ELSE
         schedule_id_ := Create_Batch_Schedule___('FUNC_AREA_CONFLICT_CACHE_API.REFRESH_CACHE', 'Refresh Cache for Segregation of Duties','WEEKLY ON SUN AT 00:00', NULL);
         Update_Cache_Task_Ref___(schedule_id_);
      END IF;
   ELSE
      Insert_Single_Rec___;
      Update_Enable_Cache___('TRUE');
      schedule_id_ := Create_Batch_Schedule___('FUNC_AREA_CONFLICT_CACHE_API.REFRESH_CACHE', 'Refresh Cache for Segregation of Duties','WEEKLY ON SUN AT 00:00', NULL);
      Update_Cache_Task_Ref___(schedule_id_);
   END IF;    
END Enable_Cache;


PROCEDURE Disable_Cache
IS
   schedule_id_ NUMBER;
BEGIN
   IF Check_Exist___ THEN
      Update_Enable_Cache___('FALSE');
      IF Check_Cache_Task_Ref___ THEN
         schedule_id_ := Get_Cache_Task_Ref___;
         Disable_Batch_Schedule___(schedule_id_);
      END IF; 
   END IF;
END Disable_Cache;



