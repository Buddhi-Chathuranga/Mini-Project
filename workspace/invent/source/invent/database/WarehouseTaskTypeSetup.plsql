-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseTaskTypeSetup
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210218  SBalLK  Issue SC2020R1-11830, Modified methods with Client_SYS.Add/Set_To_Attr() by removing attr_ functionality to optimize the performance.
--  190926  DaZase  SCSPRING20-108, Added Raise_Inactive_Warning___ to solve MessageDefinitionValidation issue.
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to VIEW1 andbase view.
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  090406  KiSalk  Modified the error text of TIMEGTZERO1 in Unpack_Check_Insert___ to match field renaming.
--  090126  NaLrlk  Modified the method New_Site to add some default data.
--  070216  FRWAUS  LCS Patch Merge B61586, Added new function Get_Status_Db.  
--  060118  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  050921  NiDalk  Removed unused variables.
--  040302  GeKalk  Removed substrb from views for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  010925  PuIllk  Bug fix 24174,  Change the Get_Client_Value to Get_db_value in Procedure New_Site
--                  to get unique value to the Task_Type.    
--  000925  JOHESE  Added undefines.
--  000414  NISOSE  Cleaned-up General_SYS.Init_Method.
--  990419  JOHW    General performance improvements.
--  990409  JOHW    Upgraded to performance optimized template.
--  990310  JOHW    Changed from Error_SYS... to Client_SYS.Add_Warning in
--                  unpack_check_update___
--  990224  JOHW    Added checks on unpack_check_update.
--  990208  JOHW    Added that status = 'ACTIVE' on view WAREHOUSE_TASK_TYPE_SETUP1.
--  990204  JOHW    Added check when change to status inactiv on a task type.
--  990203  JOHW    Added view WAREHOUSE_TASK_TYPE_SETUP1.
--  990127  JOHW    Correct cursor in method Get_Default_Time_Needed.
--  990127  JOHW    Removed methods not in use.
--  990126  JOHW    Added method Modify_Actual_Time_Needed.
--  990124  JOHW    Corrected function Get_Priority.
--  990119  DAZA    Added functionality in method New_Site and /CASCADE to
--                  site REF.
--  981230  JOHW    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_Inactive_Warning___
IS
BEGIN
   Client_SYS.Add_Warning('WarehouseTaskTypeSetup','INACTIVE: The values will be removed because the status is set to inactive.');
END Raise_Inactive_Warning___;   
   

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT warehouse_task_type_setup_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.status = 'INACTIV' THEN
      newrec_.priority := NULL;
      newrec_.default_time_needed := NULL;
      newrec_.default_requested_lead_time := NULL;
      newrec_.actual_time_needed := NULL;
      newrec_.start_in_status := NULL;
      Client_SYS.Add_To_Attr('PRIORITY', newrec_.priority, attr_);
      Client_SYS.Add_To_Attr('DEFAULT_TIME_NEEDED', newrec_.default_time_needed, attr_);
      Client_SYS.Add_To_Attr('DEFAULT_REQUESTED_LEAD_TIME', newrec_.default_requested_lead_time, attr_);
      Client_SYS.Add_To_Attr('ACTUAL_TIME_NEEDED', newrec_.actual_time_needed, attr_);
      Client_SYS.Add_To_Attr('START_IN_STATUS', newrec_.start_in_status, attr_);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     warehouse_task_type_setup_tab%ROWTYPE,
   newrec_     IN OUT warehouse_task_type_setup_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF newrec_.status = 'INACTIVE' THEN
      newrec_.priority := NULL;
      newrec_.default_time_needed := NULL;
      newrec_.default_requested_lead_time := NULL;
      newrec_.actual_time_needed := NULL;
      newrec_.start_in_status := NULL;
      Client_SYS.Add_To_Attr('PRIORITY', newrec_.priority, attr_);
      Client_SYS.Add_To_Attr('DEFAULT_TIME_NEEDED', newrec_.default_time_needed, attr_);
      Client_SYS.Add_To_Attr('DEFAULT_REQUESTED_LEAD_TIME', newrec_.default_requested_lead_time, attr_);
      Client_SYS.Add_To_Attr('ACTUAL_TIME_NEEDED', newrec_.actual_time_needed, attr_);
      Client_SYS.Add_To_Attr('START_IN_STATUS', newrec_.start_in_status, attr_);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT warehouse_task_type_setup_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   IF (newrec_.status = 'INACTIVE') THEN
      IF (newrec_.priority IS NOT NULL or newrec_.default_time_needed IS NOT NULL
          or newrec_.default_requested_lead_time IS NOT NULL) THEN
             Raise_Inactive_Warning___;
      END IF;
   ELSE
      IF newrec_.status = 'ACTIVE' THEN
         Error_SYS.Check_Not_Null(lu_name_, 'PRIORITY', newrec_.priority);
         Error_SYS.Check_Not_Null(lu_name_, 'DEFAULT_TIME_NEEDED', newrec_.default_time_needed);
         Error_SYS.Check_Not_Null(lu_name_, 'DEFAULT_REQUESTED_LEAD_TIME', newrec_.default_requested_lead_time);
         Error_SYS.Check_Not_Null(lu_name_, 'START_IN_STATUS', newrec_.start_in_status);

         IF newrec_.default_time_needed <= 0 THEN
               Error_SYS.Record_General('WarehouseTaskTypeSetup','TIMEGTZERO1: Task Line Planned Execution Time must be greater than zero.');
         END IF;
      END IF;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     warehouse_task_type_setup_tab%ROWTYPE,
   newrec_ IN OUT warehouse_task_type_setup_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_   VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.status = 'INACTIVE') THEN
      IF (newrec_.priority IS NOT NULL or newrec_.default_time_needed IS NOT NULL
          or newrec_.default_requested_lead_time IS NOT NULL) THEN
             Raise_Inactive_Warning___;
      END IF;
   ELSE
      IF (newrec_.status = 'INACTIVE') THEN
         IF NOT Warehouse_Task_API.Check_Planned_And_Released(newrec_.contract, newrec_.task_type) THEN
             Error_SYS.Record_General('WarehouseTaskTypeSetup','CHECKPLANREL: You can not change to inactive because there are warehouse tasks in status Planned or Release.');
         END IF;
      END IF;

      IF (newrec_.status = 'ACTIVE') THEN
         Error_SYS.Check_Not_Null(lu_name_, 'PRIORITY', newrec_.priority);
         Error_SYS.Check_Not_Null(lu_name_, 'DEFAULT_TIME_NEEDED', newrec_.default_time_needed);
         Error_SYS.Check_Not_Null(lu_name_, 'DEFAULT_REQUESTED_LEAD_TIME', newrec_.default_requested_lead_time);
         Error_SYS.Check_Not_Null(lu_name_, 'START_IN_STATUS', newrec_.start_in_status);

         IF (newrec_.default_time_needed <= 0) THEN
               Error_SYS.Record_General('WarehouseTaskTypeSetup','TIMEGTZERO1: Task Line Planned Execution Time must be greater than zero.');
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Default_Requested_Leadtime
--   Returns default requested leadtime.
@UncheckedAccess
FUNCTION Get_Default_Requested_Leadtime (
   contract_ IN VARCHAR2,
   task_type_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_          NUMBER;
   task_type_db_  VARCHAR2(50);
   CURSOR get_default IS
      SELECT default_requested_lead_time
      FROM warehouse_task_type_setup_tab
      WHERE contract = contract_
      AND task_type = task_type_db_;
BEGIN
   task_type_db_ := Warehouse_Task_Type_API.Encode(task_type_);
   OPEN get_default;
   FETCH get_default INTO temp_;
   CLOSE get_default;
   RETURN temp_;
END Get_Default_Requested_Leadtime;


-- New_Site
--   This method will be called from inside of the Insert___ method of
--   package Site_API in Mpccom in order to create the new row in
--   Warehouse Task Type Setup for each of the Warehouse Tasks.
PROCEDURE New_Site (
   contract_ IN VARCHAR2 )
IS
   index_         NUMBER := 0;
   task_type_     warehouse_task_type_setup_tab.task_type%TYPE;
   newrec_        warehouse_task_type_setup_tab%ROWTYPE;
BEGIN
   LOOP
      --task_type_ := Warehouse_Task_Type_API.Get_Client_Value(index_);
      task_type_ := Warehouse_Task_Type_API.get_db_value(index_);
      
      EXIT WHEN task_type_ IS NULL;
      newrec_ := NULL;
      newrec_.contract                    := contract_;
      newrec_.task_type                   := task_type_;
      newrec_.status                      := Task_Setup_Status_API.DB_INACTIVE;
      newrec_.priority                    := 1;
      newrec_.start_in_status             := Task_Setup_Start_Status_API.DB_PLANNED;
      newrec_.default_time_needed         := 0;
      newrec_.default_requested_lead_time := 0;
      New___(newrec_);
      index_ := index_ + 1;
   END LOOP;
END New_Site;


-- Modify_Actual_Time_Needed
--   Modify Actual Time Needed.
PROCEDURE Modify_Actual_Time_Needed (
   contract_           IN VARCHAR2,
   task_type_          IN VARCHAR2,
   actual_time_needed_ IN NUMBER )
IS
   newrec_        warehouse_task_type_setup_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, task_type_);
   newrec_.actual_time_needed := actual_time_needed_;
   Modify___(newrec_);
END Modify_Actual_Time_Needed;

