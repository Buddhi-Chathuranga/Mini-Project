-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseWorkerGroup
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150202  MeAblk  PRSC-5506, Added new method Get_Warehouse_Workers and type Worker_Id_Tab.
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060118  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  020314  SaNalk  Call Id 77337,Did changes to WAREHOUSE_WORKER_GROUP_LOV.
--  000925  JOHESE  Added undefines.
--  000619  ANLASE  Added WAREHOUSE_WORKER_GROUP_LOV.
--  990407  JOHW    Upgraded to performance optimized template.
--  990217  JOHW    Uppercase on worker_group.
--  990201  JOHW    Added description in LOV.
--  990129  JOHW    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Worker_Id_Tab IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_    WAREHOUSE_WORKER_GROUP.contract%TYPE;
BEGIN
   super(attr_);
   contract_ := User_Allowed_Site_API.Get_Default_Site;
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT WAREHOUSE_WORKER_GROUP_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Warehouse_Worker_Grp_Task_API.Create_Task_Types_Per_Group(newrec_.contract, newrec_.worker_group);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Warehouse_Workers (
   contract_     IN VARCHAR2,
   worker_group_ IN VARCHAR2 ) RETURN Warehouse_Worker_Group_API.Worker_Id_Tab
IS
   worker_id_tab_ Warehouse_Worker_Group_API.Worker_Id_Tab;
   CURSOR get_worker_ids IS
      SELECT worker_id
      FROM   warehouse_worker_tab
      WHERE  contract = contract_
      AND    worker_group = worker_group_;
BEGIN
   OPEN  get_worker_ids;
   FETCH get_worker_ids BULK COLLECT INTO worker_id_tab_;
   CLOSE get_worker_ids;

   RETURN(worker_id_tab_);
END Get_Warehouse_Workers;   
   
   

