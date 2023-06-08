-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseWorkerGrpTask
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120320  MaRalk Added methods Get and Is_Active_Worker_Group.   
--  110718  MaEelk Added user allowed site filter to WAREHOUSE_WORKER_GRP_TASK.
--  081230  KiSalk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT warehouse_worker_grp_task_tab%ROWTYPE,
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
   oldrec_ IN     warehouse_worker_grp_task_tab%ROWTYPE,
   newrec_ IN OUT warehouse_worker_grp_task_tab%ROWTYPE,
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

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Is_Active_Worker_Group
--   Returns true if worker group is to be assign to a warehouse task.
@UncheckedAccess
FUNCTION Is_Active_Worker_Group (
   contract_     IN VARCHAR2,
   worker_group_ IN VARCHAR2,
   task_type_db_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   rec_       Public_Rec;
   is_active_ BOOLEAN := FALSE;
BEGIN
   rec_ := Get(contract_, worker_group_, task_type_db_);
   IF (rec_.status = 'ACTIVE') THEN
      is_active_ := TRUE;
   END IF;
   RETURN (is_active_);
END Is_Active_Worker_Group;


-- Create_Task_Types_Per_Group
--   Create task types for new worker group with default values.
PROCEDURE Create_Task_Types_Per_Group (
   contract_     IN VARCHAR2,
   worker_group_ IN VARCHAR2 )
IS
   objid_         WAREHOUSE_WORKER_GRP_TASK.objid%TYPE;
   objversion_    WAREHOUSE_WORKER_GRP_TASK.objversion%TYPE;
   attr_          VARCHAR2(2000);
   index_         NUMBER := 0;
   task_type_     WAREHOUSE_WORKER_GRP_TASK_TAB.task_type%TYPE;
   newrec_        WAREHOUSE_WORKER_GRP_TASK_TAB%ROWTYPE;
BEGIN

   Warehouse_Worker_Group_API.Exist(contract_, worker_group_);

   LOOP
      task_type_ := Warehouse_Task_Type_API.get_db_value(index_);
      
      EXIT WHEN task_type_ IS NULL;
      Client_SYS.Clear_Attr(attr_);
      newrec_.contract := contract_;
      newrec_.worker_group := worker_group_;
      newrec_.task_type := task_type_;
      newrec_.status := 'INACTIVE';
      newrec_.efficency_rate := 0.8;
      newrec_.time_share := 0;
      Insert___(objid_, objversion_, newrec_, attr_);
      index_ := index_ + 1;
   END LOOP;
END Create_Task_Types_Per_Group;



