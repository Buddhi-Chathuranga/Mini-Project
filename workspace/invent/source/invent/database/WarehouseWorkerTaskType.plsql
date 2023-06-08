-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseWorkerTaskType
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210217  SBalLK  Issue SC2020R1-11830, Modified methods with Client_SYS.Add/Set_To_Attr() by removing attr_ functionality to optimize the performance.
--  110225  ChJalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  090305  KiSalk  Added Percentage range checks in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  090101  KiSalk  Added methods Create_Task_Types_For_Worker and Copy_Task_Types__.
--  080303  NiBalk  Bug 72023, Modified Check_Exist, to have a single return value.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060118  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  040303  GeKalk  Removed substrb from views for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  000925  JOHESE  Added undefines.
--  990419  JOHW  General performance improvements.
--  990408  JOHW  Upgraded to performance optimized template.
--  990217  JOHW  Uppercase on Worker_Id.
--  990126  JOHW  Added method Modify_Actual_Time_Needed.
--  990124  JOHW  Checked Procedures and Functions according to performence.
--  990122  JOHW  Added Check_Exist method.
--  990118  JOHW  Changed name on method, from Check_Worker_Task_Type to
--                Is_Active_Worker.
--  990118  JOHW  Corrected differencies between api, apy and cat.
--  990113  JOHW  Added function Check_Worker_Task_Type.
--  981230  JOHW  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT warehouse_worker_task_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   -- check percentages
   IF  (newrec_.time_share < 0 OR newrec_.efficency_rate < 0) THEN
       Error_SYS.Record_General(lu_name_, 'PERCENTAGE_NEGATIVE: Percentage cannot be negative.');
   END IF;
   IF (newrec_.time_share > 1 OR newrec_.efficency_rate > 1) THEN
       Error_SYS.Record_General(lu_name_, 'PERCENTAGE_TOOBIG: Percentage cannot be greater than 100.');
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     warehouse_worker_task_type_tab%ROWTYPE,
   newrec_ IN OUT warehouse_worker_task_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   -- check percentages
   IF  (newrec_.time_share < 0 OR newrec_.efficency_rate < 0) THEN
       Error_SYS.Record_General(lu_name_, 'PERCENTAGE_NEGATIVE: Percentage cannot be negative.');
   END IF;
   IF (newrec_.time_share > 1 OR newrec_.efficency_rate > 1) THEN
       Error_SYS.Record_General(lu_name_, 'PERCENTAGE_TOOBIG: Percentage cannot be greater than 100.');
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy_Task_Types__ (
   contract_     IN VARCHAR2,
   worker_id_    IN VARCHAR2,
   to_contract_  IN VARCHAR2,
   to_worker_id_ IN VARCHAR2 )
IS
   newrec_        WAREHOUSE_WORKER_TASK_TYPE_TAB%ROWTYPE;
   CURSOR get_task_types IS
      SELECT task_type, actual_time_needed, time_share, efficency_rate, actual_time_share, status
      FROM WAREHOUSE_WORKER_TASK_TYPE_TAB
      WHERE contract  = contract_
      AND   worker_id = worker_id_;
BEGIN

   -- Copy records from the original worker
   IF (to_contract_ = contract_ 
       AND Warehouse_Worker_API.Get_Worker_Group(to_contract_, to_worker_id_) = Warehouse_Worker_API.Get_Worker_Group(contract_, worker_id_)) THEN
      FOR rec_ IN get_task_types LOOP
         newrec_ := NULL;

         newrec_.contract           := to_contract_;
         newrec_.worker_id          := to_worker_id_;
         newrec_.task_type          := rec_.task_type;
         newrec_.actual_time_needed := rec_.actual_time_needed;
         newrec_.time_share         := rec_.time_share;
         newrec_.efficency_rate     := rec_.efficency_rate;
         newrec_.actual_time_share  := rec_.actual_time_share;
         newrec_.status             := rec_.status;
         New___(newrec_);
      END LOOP;
   ELSE
      -- Add records with task types related to worker group
      Create_Task_Types_For_Worker(to_contract_, to_worker_id_);
   END IF;

END Copy_Task_Types__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Modify_Actual_Time_Needed
--   Modify actual time needed.
PROCEDURE Modify_Actual_Time_Needed (
   contract_           IN VARCHAR2,
   worker_id_          IN VARCHAR2,
   task_type_          IN VARCHAR2,
   actual_time_needed_ IN NUMBER )
IS
   newrec_          WAREHOUSE_WORKER_TASK_TYPE_TAB%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, worker_id_, task_type_);
   newrec_.actual_time_needed := actual_time_needed_;
   Modify___(newrec_);
END Modify_Actual_Time_Needed;


-- Modify_Actual_Time_Share
--   Modify actual time share.
PROCEDURE Modify_Actual_Time_Share (
   contract_          IN VARCHAR2,
   worker_id_         IN VARCHAR2,
   task_type_         IN VARCHAR2,
   actual_time_share_ IN NUMBER )
IS
   newrec_          WAREHOUSE_WORKER_TASK_TYPE_TAB%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, worker_id_, task_type_);
   newrec_.actual_time_share := actual_time_share_;
   Modify___(newrec_);
END Modify_Actual_Time_Share;


-- Is_Active_Worker
--   Returns true if worker is to be assign to a warehouse task.
@UncheckedAccess
FUNCTION Is_Active_Worker (
   contract_     IN VARCHAR2,
   worker_id_    IN VARCHAR2,
   task_type_db_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   status_db_     VARCHAR2(50);
   temp_          BOOLEAN;
   CURSOR get_attr IS
      SELECT status
      FROM WAREHOUSE_WORKER_TASK_TYPE_TAB
      WHERE contract = contract_
      AND   task_type = task_type_db_
      AND   worker_id = worker_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO status_db_;
   IF get_attr%FOUND THEN
      CLOSE get_attr;
      IF status_db_ = 'ACTIVE' THEN
         temp_ := TRUE;
      ELSE
         temp_ := FALSE;
      END IF;
   ELSE
      CLOSE get_attr;
      temp_ := FALSE;
   END IF;
   RETURN temp_;
END Is_Active_Worker;


-- Check_Exist
--   Checks if a worker is connected to a warehouse task type.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_  IN VARCHAR2,
   worker_id_ IN VARCHAR2,
   task_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   task_type_db_  VARCHAR2(50);
   temp_          VARCHAR2(50);
   is_exist_      BOOLEAN := FALSE;

   CURSOR get_attr IS
      SELECT task_type
      FROM WAREHOUSE_WORKER_TASK_TYPE_TAB
      WHERE contract = contract_
      AND   task_type = task_type_db_
      AND   worker_id = worker_id_;
BEGIN
   task_type_db_ := task_type_;
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%FOUND THEN
      is_exist_ := TRUE;
   END IF;
   CLOSE get_attr;
   RETURN is_exist_;
END Check_Exist;


-- Create_Task_Types_For_Worker
--   Copy records from warehouse worker grp task for the new user from connected worker group;
--   if unavailable, create new records in Warehouse Worker Task Type.
PROCEDURE Create_Task_Types_For_Worker (
   contract_  IN VARCHAR2,
   worker_id_ IN VARCHAR2 )
IS
   index_         NUMBER := 0;
   task_type_     WAREHOUSE_WORKER_TASK_TYPE_TAB.task_type%TYPE;
   worker_group_  warehouse_worker_grp_task_tab.worker_group%TYPE;
   newrec_        WAREHOUSE_WORKER_TASK_TYPE_TAB%ROWTYPE;

   CURSOR get_group_task_types IS
      SELECT task_type, time_share, efficency_rate, status
      FROM warehouse_worker_grp_task_tab
      WHERE contract     = contract_
      AND   worker_group = worker_group_;

BEGIN

   worker_group_ := Warehouse_Worker_API.Get_Worker_Group(contract_,worker_id_);

   --Add records with task types related to worker group
   FOR rec_ IN get_group_task_types LOOP
      newrec_ := NULL;

      newrec_.contract       := contract_;
      newrec_.worker_id      := worker_id_;
      newrec_.task_type      := rec_.task_type;
      newrec_.status         := rec_.status;
      newrec_.time_share     := rec_.time_share;
      newrec_.efficency_rate := rec_.efficency_rate;
      New___(newrec_);
   END LOOP;

   LOOP
   -- Add records with task types not found in worker group
      task_type_ := Warehouse_Task_Type_API.get_db_value(index_);

      EXIT WHEN task_type_ IS NULL;
      IF (NOT Check_Exist___(contract_, worker_id_, task_type_)) THEN
         newrec_ := NULL;

         newrec_.contract       := contract_;
         newrec_.worker_id      := worker_id_;
         newrec_.task_type      := task_type_;
         newrec_.status         := Warehouse_Worker_Status_API.DB_ACTIVE;
         newrec_.time_share     := 0;
         newrec_.efficency_rate := 1;
         New___(newrec_);
      END IF;
      index_ := index_ + 1;
   END LOOP;

END Create_Task_Types_For_Worker;



