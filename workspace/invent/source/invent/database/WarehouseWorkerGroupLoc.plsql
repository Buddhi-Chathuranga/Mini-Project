-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseWorkerGroupLoc
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200603  SBalLK  Bug 154243(SCZ-10299), Modified Add_All_Location_Groups method to clear attr values for avoid
--  200603          "Character or String Buffer Too small" error due to rowkey adding in Insert__() method.
--  141017  MeAblk Added new method Check_Location_Group_Active.
--  110718  MaEelk Added user allowed site filter to WAREHOUSE_WORKER_GROUP_LOC.
--  090807  NaLrlk Modified the methods Add_All_Location_Groups and Unpack_Check_Insert___ 
--  090807         to use warehouse_bay_bin_tab.
--  090217  KiSalk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT warehouse_worker_group_loc_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   dummy_ NUMBER;
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

   --Check if Location group is valid for the site
   OPEN get_location_group(newrec_.contract, newrec_.location_group);
   FETCH get_location_group INTO dummy_;
   IF (get_location_group%NOTFOUND) THEN
      CLOSE get_location_group;
      Error_SYS.Record_General(lu_name_,'INVALIDSITE: Location group :P1 is not valid for site :P2', newrec_.location_group, newrec_.contract);
   END IF;
   CLOSE get_location_group;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     warehouse_worker_group_loc_tab%ROWTYPE,
   newrec_ IN OUT warehouse_worker_group_loc_tab%ROWTYPE,
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

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Add_All_Location_Groups
--   Add all possible location groups that are not already connected.
PROCEDURE Add_All_Location_Groups (
   contract_     IN VARCHAR2,
   worker_group_ IN VARCHAR2 )
IS
   objid_         WAREHOUSE_WORKER_GROUP_LOC.objid%TYPE;
   objversion_    WAREHOUSE_WORKER_GROUP_LOC.objversion%TYPE;
   attr_          VARCHAR2(2000);
   newrec_        WAREHOUSE_WORKER_GROUP_LOC_TAB%ROWTYPE;
   CURSOR get_location_groups IS
      SELECT location_group
      FROM   inventory_location_group_tab ilg
      WHERE  location_group IN (SELECT location_group 
                                FROM   warehouse_bay_bin_tab wbb 
                                WHERE wbb.contract = contract_)
      AND    location_group NOT IN (SELECT location_group 
                                    FROM   WAREHOUSE_WORKER_GROUP_LOC_TAB wgl 
                                    WHERE  wgl.contract = contract_ 
                                    AND    wgl.worker_group = worker_group_);
BEGIN

   FOR rec_ IN get_location_groups LOOP
      Client_SYS.Clear_Attr(attr_);
      newrec_.contract := contract_;
      newrec_.worker_group := worker_group_;
      newrec_.location_group := rec_.location_group;
      newrec_.status := 'ACTIVE';
      newrec_.time_share := 0;
      
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
END Add_All_Location_Groups;


FUNCTION Check_Location_Group_Active (
   contract_       IN VARCHAR2,
   worker_group_   IN VARCHAR2,
   location_group_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   active_ BOOLEAN := FALSE;
   
   CURSOR get_loc_group IS
      SELECT 1
      FROM  warehouse_worker_group_loc_tab
      WHERE contract = contract_
      AND   worker_group = worker_group_
      AND   location_group = location_group_
      AND   status = 'ACTIVE';
BEGIN
   OPEN  get_loc_group;
   FETCH get_loc_group INTO dummy_;
   IF (get_loc_group%FOUND) THEN
      active_ := TRUE;   
   END IF;  
   CLOSE get_loc_group;
   RETURN active_;
END Check_Location_Group_Active;      
   
