-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseWorkerLocGroup
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210217  SBalLK  Issue SC2020R1-11830, Modified methods with Client_SYS.Add/Set_To_Attr() by removing attr_ functionality to optimize the performance.
--  200603  SBalLK  Bug 154243(SCZ-10299), Modified Create_Loc_Groups_For_Worker() and Add_All_Location_Groups() methods to clear attr
--  200603          values for avoid "Character or String Buffer Too small" error due to rowkey adding in Insert__() method.
--  110708  MaEelk  Added user allowed site filter to WAREHOUSE_WORKER_LOC_GROUP_LOV
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  100505  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  090807  NaLrlk   Modified methods Add_All_Location_Groups and Unpack_Check_Insert___ to use warehouse_bay_bin_tab.
--  090305  KiSalk   Added Percentage range checks in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  090102  KiSalk   Added methods Add_All_Location_Groups, Create_Loc_Groups_For_Worker and Copy_Location_Groups__.
--  081231  KiSalk   Added 'STATUS' in attribute string of Prepare_Insert___.
--  080303  NiBalk   Bug 72023, Modified Check_Exist, to have a single return value.
--  060725  ThGulk   Added &OBJID instead of rowid in Procedure Insert___
--  060118  NiDalk   Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  040302  GeKalk   Removed substrb from views for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  020305  CaStse  Added cursor get_location_group in Unpack_Check_Insert___.
--  000925  JOHESE  Added undefines.
--  990419  JOHW  General performance improvements.
--  990407  JOHW  Upgraded to performance optimized template.
--  990208  JOHW  Changed model properties.
--  990126  JOHW  Added method Modify_Actual_Time_Share.
--  990122  JOHW  Added Check_Exist method.
--  990118  JOHW  Changed name on method, from Check_Worker_Loc_Group to
--                Is_Active_Worker.
--  990118  JOHW  Added function Check_Worker_Loc_Group.
--  981230  JOHW  Created
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
   Client_SYS.Add_To_Attr('STATUS', Warehouse_Worker_Status_API.Decode('ACTIVE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT warehouse_worker_loc_group_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);

   dummy_           NUMBER;
   CURSOR get_location_group(contract_ IN VARCHAR2, location_group_ IN VARCHAR2) IS
      SELECT 1
      FROM   WAREHOUSE_BAY_BIN_TAB
      WHERE  contract = contract_
      AND    location_group = location_group_;
BEGIN
   super(newrec_, indrec_, attr_);

   -- check percentage
   IF  (newrec_.time_share < 0) THEN
       Error_SYS.Record_General(lu_name_, 'PERCENTAGE_NEGATIVE: Percentage cannot be negative.');
   END IF;
   IF (newrec_.time_share > 1) THEN
       Error_SYS.Record_General(lu_name_, 'PERCENTAGE_TOOBIG: Percentage cannot be greater than 100.');
   END IF;

   --Check that specified location group is connected to a location that in turn is connected to the site
   -- in question.
   OPEN get_location_group(newrec_.contract, newrec_.location_group);
   FETCH get_location_group INTO dummy_;
   IF (get_location_group%NOTFOUND) THEN
      CLOSE get_location_group;
      Error_SYS.Record_General('WarehouseWorkerLocGroup','INVALIDSITE: Location group :P1 is not valid for site :P2', newrec_.location_group, newrec_.contract);
   END IF;
   CLOSE get_location_group;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     warehouse_worker_loc_group_tab%ROWTYPE,
   newrec_ IN OUT warehouse_worker_loc_group_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   -- check percentage
   IF  (newrec_.time_share < 0) THEN
       Error_SYS.Record_General(lu_name_, 'PERCENTAGE_NEGATIVE: Percentage cannot be negative.');
   END IF;
   IF (newrec_.time_share > 1) THEN
       Error_SYS.Record_General(lu_name_, 'PERCENTAGE_TOOBIG: Percentage cannot be greater than 100.');
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy_Location_Groups__ (
   contract_     IN VARCHAR2,
   worker_id_    IN VARCHAR2,
   to_contract_  IN VARCHAR2,
   to_worker_id_ IN VARCHAR2 )
IS
   newrec_        WAREHOUSE_WORKER_LOC_GROUP_TAB%ROWTYPE;

   CURSOR get_loc_groups IS
      SELECT location_group, time_share, actual_time_share, status
      FROM WAREHOUSE_WORKER_LOC_GROUP_TAB
      WHERE contract  = contract_
      AND   worker_id = worker_id_;
BEGIN
   -- Copy records from the original worker
   IF (to_contract_ = contract_) THEN
      FOR rec_ IN get_loc_groups LOOP
         newrec_ := NULL;

         newrec_.contract          := to_contract_;
         newrec_.worker_id         := to_worker_id_;
         newrec_.location_group    := rec_.location_group;
         newrec_.time_share        := rec_.time_share;
         newrec_.actual_time_share := rec_.actual_time_share;
         newrec_.status            := rec_.status;
         New___(newrec_);
      END LOOP;
   ELSE
      -- Add all possible location groups
      Add_All_Location_Groups(to_contract_, to_worker_id_);
   END IF;
END Copy_Location_Groups__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Modify_Actual_Time_Share
--   Modify actual time share.
PROCEDURE Modify_Actual_Time_Share (
   contract_          IN VARCHAR2,
   worker_id_         IN VARCHAR2,
   location_group_    IN VARCHAR2,
   actual_time_share_ IN NUMBER )
IS
   newrec_          WAREHOUSE_WORKER_LOC_GROUP_TAB%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, worker_id_, location_group_);
   newrec_.actual_time_share := actual_time_share_;
   Modify___(newrec_);
END Modify_Actual_Time_Share;


-- Is_Active_Worker
--   Returns true if worker is to be assign to a warehouse task
@UncheckedAccess
FUNCTION Is_Active_Worker (
   contract_       IN VARCHAR2,
   worker_id_      IN VARCHAR2,
   location_group_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   status_db_     VARCHAR2(50);
   temp_          BOOLEAN;
   CURSOR get_attr IS
      SELECT status
      FROM WAREHOUSE_WORKER_LOC_GROUP_TAB
      WHERE contract = contract_
      AND   location_group = location_group_
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
--   Checks if a worker is connected to a location group.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_       IN VARCHAR2,
   worker_id_      IN VARCHAR2,
   location_group_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   temp_          VARCHAR2(50);
   is_exist_      BOOLEAN := FALSE;

   CURSOR get_attr IS
      SELECT location_group
      FROM WAREHOUSE_WORKER_LOC_GROUP_TAB
      WHERE contract = contract_
      AND   location_group = location_group_
      AND   worker_id = worker_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%FOUND THEN
      is_exist_ := TRUE;
   END IF;
   CLOSE get_attr;
   RETURN is_exist_;
END Check_Exist;


-- Add_All_Location_Groups
--   Add all possible location groups that are not already connected.
PROCEDURE Add_All_Location_Groups (
   contract_       IN VARCHAR2,
   worker_id_      IN VARCHAR2 )
IS
   objid_         WAREHOUSE_WORKER_LOC_GROUP.objid%TYPE;
   objversion_    WAREHOUSE_WORKER_LOC_GROUP.objversion%TYPE;
   attr_          VARCHAR2(2000);
   newrec_        WAREHOUSE_WORKER_LOC_GROUP_TAB%ROWTYPE;
   CURSOR get_location_groups IS
      SELECT location_group
      FROM   inventory_location_group_tab ilg
      WHERE  location_group IN (SELECT location_group 
                                FROM   warehouse_bay_bin_tab wbb 
                                WHERE  wbb.contract = contract_)
      AND    location_group NOT IN (SELECT location_group 
                                    FROM   WAREHOUSE_WORKER_LOC_GROUP_TAB wlg 
                                    WHERE  wlg.contract = contract_ 
                                    AND    wlg.worker_id = worker_id_);
BEGIN

   -- Copy records from WarehouseWorkerGroupLoc first
   Create_Loc_Groups_For_Worker(contract_, worker_id_);

   -- Create other location groups with default values
   FOR rec_ IN get_location_groups LOOP
      Client_SYS.Clear_Attr(attr_);
      newrec_.contract := contract_;
      newrec_.worker_id := worker_id_;
      newrec_.location_group := rec_.location_group;
      newrec_.status := 'ACTIVE';
      newrec_.time_share := 0;
      
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;

END Add_All_Location_Groups;


-- Create_Loc_Groups_For_Worker
--   Copy records from WarehouseWorkerGroupLoc for the new worker from connected worker group..
PROCEDURE Create_Loc_Groups_For_Worker (
   contract_     IN VARCHAR2,
   worker_id_    IN VARCHAR2 )
IS
   objid_         WAREHOUSE_WORKER_LOC_GROUP.objid%TYPE;
   objversion_    WAREHOUSE_WORKER_LOC_GROUP.objversion%TYPE;
   attr_          VARCHAR2(2000);
   worker_group_  warehouse_worker_grp_task_tab.worker_group%TYPE;
   newrec_        WAREHOUSE_WORKER_LOC_GROUP_TAB%ROWTYPE;
   CURSOR get_group_task_types IS
      SELECT location_group, time_share, status
      FROM  warehouse_worker_group_loc_tab gl
      WHERE contract     = contract_
      AND   worker_group = worker_group_
      AND   location_group NOT IN (SELECT location_group FROM WAREHOUSE_WORKER_LOC_GROUP_TAB wl
                                   WHERE  gl.contract = wl.contract
                                   AND    worker_id = worker_id_);
BEGIN

   worker_group_ := Warehouse_Worker_API.Get_Worker_Group(contract_,worker_id_);

   --Add records with location groups related to worker group
   FOR rec_ IN get_group_task_types LOOP
      Client_SYS.Clear_Attr(attr_);
      newrec_.contract := contract_;
      newrec_.worker_id := worker_id_;
      newrec_.location_group := rec_.location_group;
      newrec_.status := rec_.status;
      newrec_.time_share := rec_.time_share;
      
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;

END Create_Loc_Groups_For_Worker;



