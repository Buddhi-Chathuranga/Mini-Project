-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseBayTier
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211211  JaThlk  SC21R2-2932, Added new function Get_Default_Tier_Id. 
--  190103  KoDelk  SCUXXW4-15164, Added new Function Get_Base_Bin_Volume_Capacity()
--  170105  LEPESE  LIM-10028, Added parameter ignore_this_handling_unit_id_ to method Get_Free_Carrying_Capacity.
--  150820  Matkse  COB-485, Modified Get_Bin_Vol_Cap_And_Src_Db___ by changing the prerequisites for calculating volume.
--  150820          Now height, width and depth needs to have a value for volume to be calculated, else the inherited value is used. (If such exist)  
--  140911  Erlise  PRSC-2475, Put to empty. Added attribute receipt_to_occupied_blocked.
--  140911          Added methods Get_Receipt_To_Occup_Blockd, Get_Receipt_To_Occup_Blockd_Db and Get_Receipt_To_Occup_Blkd_Src.
--  140911          Changed attribute Bin_Volume_Capacity to private to remove unnecessary override annotation.
--  140512  MAHPLK  PBSC-9173, Modified Check_Insert___  and Check_Update___ method to validate the route_order for valid string.
--  121115  MaEelk  Made a call to Storage_Zone_Detail_API.Remove_Tier from Delete___ that would remove the relevent record when remind a warehouse 
--  121106  MAHPLK  Added Route_Order.
--  120904  JeLise  Changed from calling Part_Catalog_API methods to call the same methods in Part_Catalog_Invent_Attrib_API.
--  120829  Matkse  Added check for cubic capacity of bin_volume in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  120829          Added new implementation method, Get_Bin_Vol_Cap_And_Src_Db___, used for determine source and retrieval of volume capacity.
--  120829          This new method is being called from Get_Volume_Capacity and Get_Bin_Volume_Cap_Source_Db. 
--  120821  Matkse  Modified Get_Bin_Volume_Capacity and Get_Bin_Volume_Capacity_Source by fixing a small bug leading to changes of height not to be
--  120821          taken into consideration when calculating volume capacity and source.
--  120605  Matkse  Modified Delete___ by adding calls to Site_Putaway_Zone_API.Remove_Tier and Invent_Part_Putaway_Zone_API.Remove_Tier
--  120604  Matkse  Added bin_volume_capacity.
--  120417  MaEelk  Modified Get_Bin_Volume_Capacity to return LEAST(bin_volume_capacity_,999999999999999999999999999) to avoid client errors
--  120417          when the return vlue exceeds 29 digits.
--  120315  MaEelk  Removed the last parameter TRUE in call General_SYS.Init_Method from  non-implementation methods
--  120309  LEPESE  Added methods FUNCTION Get_Bin_Height_Cap_Source_Db, Get_Bin_Width_Cap_Source_Db, Get_Bin_Dept_Cap_Source_Db
--  120309          Get_Bin_Carry_Cap_Source_Db, Get_Bin_Min_Temp_Source_Db, Get_Bin_Max_Temp_Source_Db, 
--  120309          Get_Bin_Min_Humidity_Source_Db, Get_Bin_Max_Humidity_Source_Db, Get_Tier_Carry_Cap_Source_Db.
--  120309  Matkse  Added new LOV view WAREHOUSE_BAY_TIER_LOV2
--  120307  LEPESE  Added method Copy_Capabilities___.
--  111121  JeLise  Added methods Clear_Storage_Chars__, Clear_Bin_Storage_Chars___ and Clear_Bin_Storage_Chars__.
--  111103  JeLise  Added exclude_storage_req_val.
--  110920  DaZase  Added functionality in Get_Attr___, Copy__ and Copy_Bins__ to make sure that some capacities and conditions will not 
--  110920          be copied if from/to companies have different length, weight or temperature uoms.
--  110905  DaZase  Changed Get_Bin_Volume_Capacity so it will only return value if we have a valid volume UOM.
--  110707  MaEelk  Added user allowed site filter to WAREHOUSE_BAY_TIER and WAREHOUSE_BAY_TIER_LOV.
--  110526  ShKolk  Added General_SYS for Get_Free_Carrying_Capacity().
--  110405  DaZase  Added mix_of_lot_batch_no_blocked.
--  110208  DaZase  Added Lock_By_Keys_Wait.
--  110120  DaZase  Added Get_Free_Carrying_Capacity.
--  101014  JeLise  Added mix_of_part_number_blocked and mix_of_cond_codes_blocked.
--  100927  DaZase  Removed unnecessary check in get_bins cursors in methods Check_Bin_Temperature_Range/Check_Bin_Humidity_Range
--  100922  JeLise  Changed from calling Incorrect_Temperature_Range and Incorrect_Humidity_Range in 
--  100922          Site_Invent_Info_API to same methods in Part_Catalog_API.
--  100830  DaZase  Added Get_Bin_Volume_Capacity.
--  100824  JeLise  Changed from calling Warehouse_Bay_Bin_API.Check_Humidity to Part_Catalog_API.Check_Humidity.
--  100406  Dazase  Added hide_in_whse_navigator.
--  100115  DaZase  Added methods Get_Receipts_Blocked, Get_Receipts_Blocked_Db and Get_Receipts_Blocked_Source.
--  100114  RILASE  Added receipts_blocked.
--  091106  NaLrlk  Added view WAREHOUSE_BAY_TIER_LOV.
--  091027  LEPESE  Added calls from Unpack_Check_Insert___ and Unpack_Check_Update___
--  091027          to methods Warehouse_Bay_Bin_API.Check_Humidity,
--  091027          Warehouse_Bay_Bin_API.Check_Carrying_Capacity and
--  091027          Warehouse_Bay_Bin_API.Check_Cubic_Capacity where checks are centralized.
--  091021  LEPESE  Renamed Check_Humidity_Interval and Check_Temperature_Interval into
--  091021          Check_Humidity_Range and Check_Temperature_Range.
--  091021          Modifications in Check_Humidity_Range and Check_Temperature_Range
--  091021          to use methods Site_Invent_Info_API.Incorrect_Temperature_Range and
--  091021          Site_Invent_Info_API.Incorrect_Humidity_Range to validate the ranges.
--  091019  NaLrlk  Modified method Copy_Bins__ to check from_contract is user allowed site.
--  091008  NaLrlk  Modified the WAREHOUSE_BAY_TIER view ref column to CASCADE check.
--  090907  ShKolk  Renamed method Create_Default_Tier to New.
--  090904  LEPESE  Added methods Check_Bin_Temperature_Interval and Check_Bin_Humidity_Interval.
--  090904          Added calls to these methods from Insert___ and Update___.
--  090825  LEPESE  Added methods Get_Attr___, Copy__, Copy_Bins__ and Check_Exist.
--  090819  NaLrlk  Added function Get_Tier_Carry_Capacity_Source.
--  090707  NaLrlk  Added warehouse bin characteristics public columns and respective source functions.
--  090707          Implemented Micro Cache. Added new mehods Invalidate_Cache___ and Update_Cache___.
--  090609  ShKolk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

default_tier_id_ CONSTANT VARCHAR2(3)  := '  -';


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Bin_Vol_Cap_And_Src_Db___ (
   bin_volume_capacity_           OUT WAREHOUSE_BAY_TIER_TAB.bin_volume_capacity%TYPE,
   bin_volume_capacity_source_db_ OUT VARCHAR2,
   contract_                      IN WAREHOUSE_BAY_TIER_TAB.contract%TYPE,
   warehouse_id_                  IN WAREHOUSE_BAY_TIER_TAB.warehouse_id%TYPE,
   bay_id_                        IN WAREHOUSE_BAY_TIER_TAB.bay_id%TYPE,
   tier_id_                       IN WAREHOUSE_BAY_TIER_TAB.tier_id%TYPE,
   get_capacity_                  IN BOOLEAN,
   get_source_                    IN BOOLEAN )
IS
   bin_height_capacity_ WAREHOUSE_BAY_TIER_TAB.bin_height_capacity%TYPE;
   bin_width_capacity_  WAREHOUSE_BAY_TIER_TAB.bin_width_capacity%TYPE;
   bin_dept_capacity_   WAREHOUSE_BAY_TIER_TAB.bin_dept_capacity%TYPE;
BEGIN
   IF ( micro_cache_value_.bin_volume_capacity IS NULL) THEN
      IF ((micro_cache_value_.bin_width_capacity IS NULL) OR
         (micro_cache_value_.bin_height_capacity IS NULL) OR
         (micro_cache_value_.bin_dept_capacity IS NULL)) THEN
         IF (get_capacity_) THEN
            bin_volume_capacity_ := Warehouse_Bay_API.Get_Bin_Volume_Capacity(contract_, warehouse_id_, bay_id_);
         END IF;
         IF (get_source_) THEN
            bin_volume_capacity_source_db_ := Warehouse_Bay_API.Get_Bin_Volume_Cap_Source_Db(contract_, warehouse_id_, bay_id_);
         END IF;
      ELSE
         bin_height_capacity_ := Get_Bin_Height_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
         IF (bin_height_capacity_ IS NOT NULL) THEN
            bin_width_capacity_  := Get_bin_Width_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
            IF (bin_width_capacity_ IS NOT NULL) THEN
               bin_dept_capacity_   := Get_Bin_Dept_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
               IF (bin_dept_capacity_ IS NOT NULL) THEN
                  bin_volume_capacity_ := bin_height_capacity_ * bin_width_capacity_ * bin_dept_capacity_;
                  bin_volume_capacity_source_db_ := Warehouse_Structure_Level_API.DB_TIER;
               END IF;
            END IF;
         END IF;
      END IF;
   ELSE
      bin_volume_capacity_ := micro_cache_value_.bin_volume_capacity;
      bin_volume_capacity_source_db_ := Warehouse_Structure_Level_API.DB_TIER;
   END IF;   
   bin_volume_capacity_ := LEAST(bin_volume_capacity_, 999999999999999999999999999);
END Get_Bin_Vol_Cap_And_Src_Db___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', User_Allowed_Site_API.Get_Default_Site(), attr_);
   Client_SYS.Add_To_Attr('RECEIPTS_BLOCKED_DB', Fnd_Boolean_API.db_false, attr_);
   Client_SYS.Add_To_Attr('RECEIPT_TO_OCCUPIED_BLOCKED_DB', Fnd_Boolean_API.db_false, attr_);
   Client_SYS.Add_To_Attr('HIDE_IN_WHSE_NAVIGATOR_DB', Fnd_Boolean_API.db_false, attr_);
   Client_SYS.Add_To_Attr('MIX_OF_PART_NUMBER_BLOCKED_DB', Fnd_Boolean_API.db_false, attr_);
   Client_SYS.Add_To_Attr('MIX_OF_COND_CODES_BLOCKED_DB', Fnd_Boolean_API.db_false, attr_);
   Client_SYS.Add_To_Attr('MIX_OF_LOT_BATCH_NO_BLOCKED_DB', Fnd_Boolean_API.db_false, attr_);
   Client_SYS.Add_To_Attr('EXCLUDE_STORAGE_REQ_VAL_DB', Fnd_Boolean_API.db_false, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT WAREHOUSE_BAY_TIER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   -- These checks needs to be performed after storing the record
   -- because they are using the method for fetching the operative
   -- values which read the database.
   Check_Bin_Temperature_Range(newrec_.contract,
                               newrec_.warehouse_id,
                               newrec_.bay_id,
                               newrec_.tier_id);

   Check_Bin_Humidity_Range(newrec_.contract,
                            newrec_.warehouse_id,
                            newrec_.bay_id,
                            newrec_.tier_id);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     WAREHOUSE_BAY_TIER_TAB%ROWTYPE,
   newrec_     IN OUT WAREHOUSE_BAY_TIER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   number_null_ NUMBER := -9999999;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Invalidation of the cache must take place immediately after the UPDATE statement!
   Invalidate_Cache___;

   IF ((NVL(newrec_.bin_min_temperature, number_null_) != NVL(oldrec_.bin_min_temperature, number_null_)) OR
       (NVL(newrec_.bin_max_temperature, number_null_) != NVL(oldrec_.bin_max_temperature, number_null_))) THEN
      -- This check needs to be performed after updating the record
      -- because it uses Get_Bin_Min_Temperature and Get_Bin_Max_Temperature which reads the database.
      Check_Bin_Temperature_Range(newrec_.contract, newrec_.warehouse_id, newrec_.bay_id, newrec_.tier_id);
   END IF;

   IF ((NVL(newrec_.bin_min_humidity, number_null_) != NVL(oldrec_.bin_min_humidity, number_null_)) OR
       (NVL(newrec_.bin_max_humidity, number_null_) != NVL(oldrec_.bin_max_humidity, number_null_))) THEN
      -- This check needs to be performed after updating the record
      -- because it uses Get_Bin_Min_Humidity and Get_Bin_Max_Humidity which reads the database.
      Check_Bin_Humidity_Range(newrec_.contract,newrec_.warehouse_id, newrec_.bay_id, newrec_.tier_id);
   END IF;

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
   WHEN OTHERS THEN
      Invalidate_Cache___;
      RAISE;
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN WAREHOUSE_BAY_TIER_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Storage_Zone_Detail_API.Remove_Tier(remrec_.contract, remrec_.warehouse_id, remrec_.bay_id, remrec_.tier_id);
END Delete___;


FUNCTION Get_Attr___ (
   lu_rec_                    IN WAREHOUSE_BAY_TIER_TAB%ROWTYPE,
   include_cubic_capacity_    IN BOOLEAN,
   include_carrying_capacity_ IN BOOLEAN,
   include_temperatures_      IN BOOLEAN ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(2000);
BEGIN

   Client_SYS.Add_To_Attr('CONTRACT',                       lu_rec_.contract,                    attr_);
   Client_SYS.Add_To_Attr('WAREHOUSE_ID',                   lu_rec_.warehouse_id,                attr_);
   Client_SYS.Add_To_Attr('BAY_ID',                         lu_rec_.bay_id,                      attr_);
   Client_SYS.Add_To_Attr('TIER_ID',                        lu_rec_.tier_id,                     attr_);
   Client_SYS.Add_To_Attr('RECEIPTS_BLOCKED_DB',            lu_rec_.receipts_blocked,            attr_);
   Client_SYS.Add_To_Attr('RECEIPT_TO_OCCUPIED_BLOCKED_DB', lu_rec_.receipt_to_occupied_blocked, attr_);
   Client_SYS.Add_To_Attr('HIDE_IN_WHSE_NAVIGATOR_DB',      lu_rec_.hide_in_whse_navigator,      attr_);
   Client_SYS.Add_To_Attr('MIX_OF_PART_NUMBER_BLOCKED_DB',  lu_rec_.mix_of_part_number_blocked,  attr_);
   Client_SYS.Add_To_Attr('MIX_OF_COND_CODES_BLOCKED_DB',   lu_rec_.mix_of_cond_codes_blocked,   attr_);
   Client_SYS.Add_To_Attr('MIX_OF_LOT_BATCH_NO_BLOCKED_DB', lu_rec_.mix_of_lot_batch_no_blocked, attr_);
   Client_SYS.Add_To_Attr('EXCLUDE_STORAGE_REQ_VAL_DB',     lu_rec_.exclude_storage_req_val,     attr_);
   Client_SYS.Add_To_Attr('ROUTE_ORDER',                    lu_rec_.route_order,                 attr_);

   IF (lu_rec_.description IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', lu_rec_.description, attr_);
   END IF;

   IF (include_cubic_capacity_) THEN
      IF (lu_rec_.bin_height_capacity IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('BIN_HEIGHT_CAPACITY', lu_rec_.bin_height_capacity, attr_);
      END IF;
      IF (lu_rec_.bin_width_capacity IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('BIN_WIDTH_CAPACITY', lu_rec_.bin_width_capacity, attr_);
      END IF;
      IF (lu_rec_.bin_dept_capacity IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('BIN_DEPT_CAPACITY', lu_rec_.bin_dept_capacity, attr_);
      END IF;
      IF (lu_rec_.bin_volume_capacity IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('BIN_VOLUME_CAPACITY', lu_rec_.bin_volume_capacity, attr_);
      END IF;
   END IF;

   IF (include_carrying_capacity_) THEN
      IF (lu_rec_.bin_carrying_capacity IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('BIN_CARRYING_CAPACITY', lu_rec_.bin_carrying_capacity, attr_);
      END IF;
      IF (lu_rec_.tier_carrying_capacity IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('TIER_CARRYING_CAPACITY', lu_rec_.tier_carrying_capacity, attr_);
      END IF;
   END IF;

   IF (include_temperatures_) THEN
      IF (lu_rec_.bin_min_temperature IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('BIN_MIN_TEMPERATURE', lu_rec_.bin_min_temperature, attr_);
      END IF;
      IF (lu_rec_.bin_max_temperature IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('BIN_MAX_TEMPERATURE', lu_rec_.bin_max_temperature, attr_);
      END IF;
   END IF;

   IF (lu_rec_.bin_min_humidity IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('BIN_MIN_HUMIDITY', lu_rec_.bin_min_humidity, attr_);
   END IF;
   IF (lu_rec_.bin_max_humidity IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('BIN_MAX_HUMIDITY', lu_rec_.bin_max_humidity, attr_);
   END IF;

   IF (lu_rec_.availability_control_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('AVAILABILITY_CONTROL_ID', lu_rec_.availability_control_id, attr_);
   END IF;

   RETURN (attr_);
END Get_Attr___;


PROCEDURE Clear_Bin_Storage_Chars___ (
   contract_                      IN VARCHAR2,
   warehouse_id_                  IN VARCHAR2,
   bay_id_                        IN VARCHAR2,
   tier_id_                       IN VARCHAR2,
   receipts_blocked_db_           IN BOOLEAN,
   receipt_to_occup_blocked_db_   IN BOOLEAN,
   mix_of_part_number_blocked_db_ IN BOOLEAN,
   mix_of_cond_codes_blocked_db_  IN BOOLEAN,
   mix_of_lot_batch_blocked_db_   IN BOOLEAN,
   exclude_storage_req_val_db_    IN BOOLEAN,
   hide_in_whse_navigator_db_     IN BOOLEAN,
   bin_width_capacity_db_         IN BOOLEAN,
   bin_height_capacity_db_        IN BOOLEAN,
   bin_dept_capacity_db_          IN BOOLEAN,
   bin_volume_capacity_db_        IN BOOLEAN,
   bin_carrying_capacity_db_      IN BOOLEAN,
   bin_min_temperature_db_        IN BOOLEAN,
   bin_max_temperature_db_        IN BOOLEAN,
   bin_min_humidity_db_           IN BOOLEAN,
   bin_max_humidity_db_           IN BOOLEAN,
   capabilities_db_               IN BOOLEAN,
   all_capabilities_db_           IN BOOLEAN,
   capability_tab_                IN Storage_Capability_API.Capability_Tab,
   availability_control_id_db_    IN BOOLEAN )
IS
   CURSOR get_bins IS
      SELECT row_id, bin_id
      FROM warehouse_bay_bin_tab
      WHERE contract     = contract_
      AND   warehouse_id = warehouse_id_
      AND   bay_id       = bay_id_
      AND   tier_id      = tier_id_;
BEGIN
   
   FOR bin_rec_ IN get_bins LOOP
      Warehouse_Bay_Bin_API.Clear_Storage_Chars__(contract_,
                                                  warehouse_id_,
                                                  bay_id_,
                                                  tier_id_,
                                                  bin_rec_.row_id,
                                                  bin_rec_.bin_id,
                                                  receipts_blocked_db_,
                                                  receipt_to_occup_blocked_db_,
                                                  mix_of_part_number_blocked_db_,
                                                  mix_of_cond_codes_blocked_db_,
                                                  mix_of_lot_batch_blocked_db_,
                                                  exclude_storage_req_val_db_,
                                                  hide_in_whse_navigator_db_,
                                                  bin_width_capacity_db_,
                                                  bin_height_capacity_db_,
                                                  bin_dept_capacity_db_,
                                                  bin_volume_capacity_db_,
                                                  bin_carrying_capacity_db_,
                                                  bin_min_temperature_db_,
                                                  bin_max_temperature_db_,
                                                  bin_min_humidity_db_,
                                                  bin_max_humidity_db_,
                                                  capabilities_db_,
                                                  all_capabilities_db_,
                                                  capability_tab_,
                                                  availability_control_id_db_);
   END LOOP;
END Clear_Bin_Storage_Chars___;


PROCEDURE Copy_Capabilities___ (
   from_contract_     IN VARCHAR2,
   from_warehouse_id_ IN VARCHAR2,
   from_bay_id_       IN VARCHAR2,
   from_tier_id_      IN VARCHAR2,
   to_contract_       IN VARCHAR2,
   to_warehouse_id_   IN VARCHAR2,
   to_bay_id_         IN VARCHAR2,
   to_tier_id_        IN VARCHAR2 )
IS
   CURSOR get_capabilities IS
      SELECT storage_capability_id
        FROM warehouse_tier_capability_tab
       WHERE contract     = from_contract_
         AND warehouse_id = from_warehouse_id_
         AND bay_id       = from_bay_id_
         AND tier_id      = from_tier_id_;
BEGIN

   FOR rec_ IN get_capabilities LOOP
      Warehouse_Tier_Capability_API.Copy__(from_contract_,
                                           from_warehouse_id_,
                                           from_bay_id_,
                                           from_tier_id_,
                                           rec_.storage_capability_id,
                                           to_contract_,
                                           to_warehouse_id_,
                                           to_bay_id_,
                                           to_tier_id_);
   END LOOP;
END Copy_Capabilities___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT warehouse_bay_tier_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT (indrec_.route_order)THEN 
      newrec_.route_order                 := newrec_.tier_id;
   END IF;
   IF NOT (indrec_.receipts_blocked) THEN 
      newrec_.receipts_blocked            := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.receipt_to_occupied_blocked) THEN
      newrec_.receipt_to_occupied_blocked := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.hide_in_whse_navigator) THEN
      newrec_.hide_in_whse_navigator      := Fnd_Boolean_API.db_false; 
   END IF;
   IF NOT (indrec_.mix_of_part_number_blocked) THEN 
      newrec_.mix_of_part_number_blocked  := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.mix_of_cond_codes_blocked) THEN 
      newrec_.mix_of_cond_codes_blocked   := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.mix_of_lot_batch_no_blocked) THEN
      newrec_.mix_of_lot_batch_no_blocked := Fnd_Boolean_API.db_false; 
   END IF;
   IF NOT (indrec_.exclude_storage_req_val) THEN 
      newrec_.exclude_storage_req_val     := Fnd_Boolean_API.db_false;
   END IF;

   super(newrec_, indrec_, attr_);
 
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User,newrec_.contract); 
 
   IF (newrec_.tier_id != default_tier_id_) THEN
      Error_SYS.Check_Valid_Key_String('TIER_ID', newrec_.tier_id);
   END IF;
   
   IF (newrec_.route_order != default_tier_id_) THEN
      Error_SYS.Check_Valid_Key_String('ROUTE_ORDER', newrec_.route_order);
   END IF;
   
   IF (UPPER(newrec_.tier_id) != newrec_.tier_id) THEN
      Error_SYS.Record_General(lu_name_,'UPPERCASE: The Tier ID must be entered in upper-case.');
   END IF;

   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.bin_height_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.bin_width_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.bin_dept_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.bin_volume_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.bin_carrying_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.tier_carrying_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Humidity         (newrec_.bin_min_humidity);
   Part_Catalog_Invent_Attrib_API.Check_Humidity         (newrec_.bin_max_humidity);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     warehouse_bay_tier_tab%ROWTYPE,
   newrec_ IN OUT warehouse_bay_tier_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                        VARCHAR2(30);
   value_                       VARCHAR2(4000);   
   number_null_                 NUMBER := -9999999;
   receipts_blocked_source_     VARCHAR2(200);
   receipt_to_occup_blkd_src_   VARCHAR2(200);
   mix_of_part_blocked_source_  VARCHAR2(200);
   mix_of_cond_blocked_source_  VARCHAR2(200);
   mix_of_lot_blocked_source_   VARCHAR2(200);
   exclude_storage_req_val_src_ VARCHAR2(200);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
 
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User,newrec_.contract); 
 
   IF (oldrec_.receipts_blocked = Fnd_Boolean_API.db_false) AND (newrec_.receipts_blocked = Fnd_Boolean_API.db_true) THEN
      -- Receipts Blocked has been changed from FALSE to TRUE on the Tier level.
      IF (Get_Receipts_Blocked_Db(newrec_.contract,
                                  newrec_.warehouse_id,
                                  newrec_.bay_id,
                                  newrec_.tier_id) = Fnd_Boolean_API.db_true) THEN
         -- The Tier is already blocked because whole bay is blocked.
         receipts_blocked_source_ := Get_Receipts_Blocked_Source(newrec_.contract,
                                                                 newrec_.warehouse_id,
                                                                 newrec_.bay_id,
                                                                 newrec_.tier_id);
         Error_SYS.Record_General(lu_name_,'RECEIPTSBLKTNOUPDATE: Receipts are already blocked on the :P1 level of the Warehouse Structure.', receipts_blocked_source_);
      END IF;
   END IF;
   
   IF (oldrec_.receipt_to_occupied_blocked = Fnd_Boolean_API.db_false) AND (newrec_.receipt_to_occupied_blocked = Fnd_Boolean_API.db_true) THEN
      -- Receipt to occupied blocked has been changed from FALSE to TRUE on the Tier level.
      IF (Get_Receipt_To_Occup_Blockd_Db(newrec_.contract,
                                         newrec_.warehouse_id,
                                         newrec_.bay_id,
                                         newrec_.tier_id) = Fnd_Boolean_API.db_true) THEN
         -- The Tier is already blocked because the whole bay is blocked.
         receipt_to_occup_blkd_src_ := Get_Receipt_To_Occup_Blkd_Src(newrec_.contract,
                                                                     newrec_.warehouse_id,
                                                                     newrec_.bay_id,
                                                                     newrec_.tier_id);
         Error_SYS.Record_General(lu_name_,'RECOCCUPBLKTNOUPDATE: Receipt to occupied is already blocked on the :P1 level of the Warehouse Structure.', receipt_to_occup_blkd_src_);
      END IF;
   END IF;

   IF (oldrec_.mix_of_part_number_blocked = Fnd_Boolean_API.db_false) AND (newrec_.mix_of_part_number_blocked = Fnd_Boolean_API.db_true) THEN
      -- Mix of Part Numbers Blocked has been changed from FALSE to TRUE on the Tier level.
      IF (Get_Mix_Of_Parts_Blocked_Db(newrec_.contract,
                                      newrec_.warehouse_id,
                                      newrec_.bay_id,
                                      newrec_.tier_id) = Fnd_Boolean_API.db_true) THEN
         -- The Tier is already blocked because whole bay is blocked.
         mix_of_part_blocked_source_ := Get_Mix_Of_Part_Blocked_Source(newrec_.contract,
                                                                       newrec_.warehouse_id,
                                                                       newrec_.bay_id,
                                                                       newrec_.tier_id);
         Error_SYS.Record_General(lu_name_,'MIXPARTSNOUPDATE: Mix of Part Numbers already blocked on the :P1 level of the Warehouse Structure.', mix_of_part_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.mix_of_cond_codes_blocked = Fnd_Boolean_API.db_false) AND (newrec_.mix_of_cond_codes_blocked = Fnd_Boolean_API.db_true) THEN
      -- Mix of Condition Codes Blocked has been changed from FALSE to TRUE on the Tier level.
      IF (Get_Mix_Of_Cond_Blocked_Db(newrec_.contract,
                                      newrec_.warehouse_id,
                                      newrec_.bay_id,
                                      newrec_.tier_id) = Fnd_Boolean_API.db_true) THEN
         -- The Tier is already blocked because whole bay is blocked.
         mix_of_cond_blocked_source_ := Get_Mix_Of_Cond_Blocked_Source(newrec_.contract,
                                                                       newrec_.warehouse_id,
                                                                       newrec_.bay_id,
                                                                       newrec_.tier_id);
         Error_SYS.Record_General(lu_name_,'MIXCONDITIONSNOUPDATE: Mix of Condition Codes already blocked on the :P1 level of the Warehouse Structure.', mix_of_cond_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.mix_of_lot_batch_no_blocked = Fnd_Boolean_API.db_false) AND (newrec_.mix_of_lot_batch_no_blocked = Fnd_Boolean_API.db_true) THEN
      -- Mix of Lot Batch Numbers Blocked has been changed from FALSE to TRUE on the Tier level.
      IF (Get_Mix_Of_Lot_Blocked_Db(newrec_.contract,
                                    newrec_.warehouse_id,
                                    newrec_.bay_id,
                                    newrec_.tier_id) = Fnd_Boolean_API.db_true) THEN
         -- The Tier is already blocked because whole bay is blocked.
         mix_of_lot_blocked_source_ := Get_Mix_Of_Lot_Blocked_Source(newrec_.contract,
                                                                     newrec_.warehouse_id,
                                                                     newrec_.bay_id,
                                                                     newrec_.tier_id);
         Error_SYS.Record_General(lu_name_,'MIXLOTBATCHNOUPDATE: Mix of Lot Batch Numbers already blocked on the :P1 level of the Warehouse Structure.', mix_of_cond_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.exclude_storage_req_val = Fnd_Boolean_API.db_false) AND (newrec_.exclude_storage_req_val = Fnd_Boolean_API.db_true) THEN
      -- Exclude Storage Requirement Validation has been changed from FALSE to TRUE on the Tier level.
      IF (Get_Exclude_Storage_Req_Val(newrec_.contract,
                                      newrec_.warehouse_id,
                                      newrec_.bay_id,
                                      newrec_.tier_id) = Fnd_Boolean_API.db_true) THEN
         -- The Tier is already excluded because whole Warehouse is excluded.
         exclude_storage_req_val_src_ := Get_Excl_Storage_Req_Val_Src(newrec_.contract,
                                                                      newrec_.warehouse_id,
                                                                      newrec_.bay_id,
                                                                      newrec_.tier_id);
         Error_SYS.Record_General(lu_name_,'EXCLSTORAGEREQUPDATE: Exclude Storage Requirement Validation already checked on the :P1 level of the Warehouse Structure.', exclude_storage_req_val_src_);
      END IF;
   END IF;
   
   IF (newrec_.route_order != default_tier_id_) THEN
      Error_SYS.Check_Valid_Key_String('ROUTE_ORDER', newrec_.route_order);
   END IF;
   
   IF (NVL(newrec_.bin_height_capacity, number_null_) != NVL(oldrec_.bin_height_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.bin_height_capacity);
   END IF;
   IF (NVL(newrec_.bin_width_capacity, number_null_) != NVL(oldrec_.bin_width_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.bin_width_capacity);
   END IF;
   IF (NVL(newrec_.bin_dept_capacity,  number_null_) != NVL(oldrec_.bin_dept_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.bin_dept_capacity);
   END IF;
   IF (NVL(newrec_.bin_volume_capacity,  number_null_) != NVL(oldrec_.bin_volume_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.bin_volume_capacity);
   END IF;
   IF (NVL(newrec_.bin_carrying_capacity, number_null_) != NVL(oldrec_.bin_carrying_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.bin_carrying_capacity);
   END IF;
   IF (NVL(newrec_.tier_carrying_capacity, number_null_) != NVL(oldrec_.tier_carrying_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.tier_carrying_capacity);
   END IF;
   IF (NVL(newrec_.bin_min_humidity, number_null_) != NVL(oldrec_.bin_min_humidity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.bin_min_humidity);
   END IF;
   IF (NVL(newrec_.bin_max_humidity, number_null_) != NVL(oldrec_.bin_max_humidity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.bin_max_humidity);
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy__ (
   from_contract_          IN VARCHAR2,
   from_warehouse_id_      IN VARCHAR2,
   from_bay_id_            IN VARCHAR2,
   from_tier_id_           IN VARCHAR2,
   to_contract_            IN VARCHAR2,
   to_warehouse_id_        IN VARCHAR2,
   to_bay_id_              IN VARCHAR2,
   to_tier_id_             IN VARCHAR2,
   copy_bins_              IN BOOLEAN,
   copy_cubic_capacity_    IN BOOLEAN,
   copy_carrying_capacity_ IN BOOLEAN,
   copy_temperatures_      IN BOOLEAN )
IS
   newrec_     WAREHOUSE_BAY_TIER_TAB%ROWTYPE;
   empty_rec_  WAREHOUSE_BAY_TIER_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN

   Exist(from_contract_, from_warehouse_id_, from_bay_id_, from_tier_id_);
   Warehouse_Bay_API.Exist(to_contract_, to_warehouse_id_, to_bay_id_);

   IF NOT (Check_Exist___(to_contract_, to_warehouse_id_, to_bay_id_, to_tier_id_)) THEN
      newrec_              := Get_Object_By_Keys___(from_contract_,
                                                    from_warehouse_id_,
                                                    from_bay_id_,
                                                    from_tier_id_);
      newrec_.contract     := to_contract_;
      newrec_.warehouse_id := to_warehouse_id_;
      newrec_.bay_id       := to_bay_id_;
      newrec_.tier_id      := to_tier_id_;
      attr_                := Get_Attr___(newrec_, copy_cubic_capacity_, copy_carrying_capacity_, copy_temperatures_);
      newrec_              := empty_rec_;

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);

      Copy_Capabilities___(from_contract_,
                           from_warehouse_id_,
                           from_bay_id_,
                           from_tier_id_,
                           to_contract_,
                           to_warehouse_id_,
                           to_bay_id_,
                           to_tier_id_);
   END IF;

   IF (copy_bins_) THEN
      Copy_Bins__(from_contract_,
                  from_warehouse_id_,
                  from_bay_id_,
                  from_tier_id_,
                  to_contract_,
                  to_warehouse_id_,
                  to_bay_id_,
                  to_tier_id_,
                  copy_cubic_capacity_, 
                  copy_carrying_capacity_, 
                  copy_temperatures_);
   END IF;
END Copy__;


PROCEDURE Copy_Bins__ (
   from_contract_          IN VARCHAR2,
   from_warehouse_id_      IN VARCHAR2,
   from_bay_id_            IN VARCHAR2,
   from_tier_id_           IN VARCHAR2,
   to_contract_            IN VARCHAR2,
   to_warehouse_id_        IN VARCHAR2,
   to_bay_id_              IN VARCHAR2,
   to_tier_id_             IN VARCHAR2,
   copy_cubic_capacity_    IN BOOLEAN,
   copy_carrying_capacity_ IN BOOLEAN,
   copy_temperatures_      IN BOOLEAN )
IS
   CURSOR get_bins IS
      SELECT row_id, bin_id
        FROM warehouse_bay_bin_tab
       WHERE contract     = from_contract_
         AND warehouse_id = from_warehouse_id_
         AND bay_id       = from_bay_id_
         AND tier_id      = from_tier_id_;
BEGIN

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, from_contract_);
   FOR bin_rec_ IN get_bins LOOP
      Warehouse_Bay_Bin_API.Copy__(from_contract_,
                                   from_warehouse_id_,
                                   from_bay_id_,
                                   bin_rec_.row_id,
                                   from_tier_id_,
                                   bin_rec_.bin_id,
                                   to_contract_,
                                   to_warehouse_id_,
                                   to_bay_id_,
                                   bin_rec_.row_id,
                                   to_tier_id_,
                                   bin_rec_.bin_id,
                                   copy_cubic_capacity_, 
                                   copy_carrying_capacity_, 
                                   copy_temperatures_);
   END LOOP;
END Copy_Bins__;


PROCEDURE Clear_Storage_Chars__ (
   contract_                      IN VARCHAR2,
   warehouse_id_                  IN VARCHAR2,
   bay_id_                        IN VARCHAR2,
   tier_id_                       IN VARCHAR2,
   receipts_blocked_db_           IN BOOLEAN,
   receipt_to_occup_blocked_db_   IN BOOLEAN,
   mix_of_part_number_blocked_db_ IN BOOLEAN,
   mix_of_cond_codes_blocked_db_  IN BOOLEAN,
   mix_of_lot_batch_blocked_db_   IN BOOLEAN,
   exclude_storage_req_val_db_    IN BOOLEAN,
   hide_in_whse_navigator_db_     IN BOOLEAN,
   bin_width_capacity_db_         IN BOOLEAN,
   bin_height_capacity_db_        IN BOOLEAN,
   bin_dept_capacity_db_          IN BOOLEAN,
   bin_volume_capacity_db_        IN BOOLEAN,
   tier_carrying_capacity_db_     IN BOOLEAN,
   bin_carrying_capacity_db_      IN BOOLEAN,
   bin_min_temperature_db_        IN BOOLEAN,
   bin_max_temperature_db_        IN BOOLEAN,
   bin_min_humidity_db_           IN BOOLEAN,
   bin_max_humidity_db_           IN BOOLEAN,
   capabilities_db_               IN BOOLEAN,
   all_capabilities_db_           IN BOOLEAN,
   capability_tab_                IN Storage_Capability_API.Capability_Tab,
   availability_control_id_db_    IN BOOLEAN )
IS
   newrec_     WAREHOUSE_BAY_TIER_TAB%ROWTYPE;
   oldrec_     WAREHOUSE_BAY_TIER_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN

   IF (receipts_blocked_db_) THEN
      Client_SYS.Add_To_Attr('RECEIPTS_BLOCKED_DB', Fnd_Boolean_API.db_false, attr_);
   END IF;
   IF (receipt_to_occup_blocked_db_) THEN
      Client_SYS.Add_To_Attr('RECEIPT_TO_OCCUPIED_BLOCKED_DB', Fnd_Boolean_API.db_false, attr_);
   END IF;
   IF (mix_of_part_number_blocked_db_) THEN 
      Client_SYS.Add_To_Attr('MIX_OF_PART_NUMBER_BLOCKED_DB', Fnd_Boolean_API.db_false, attr_);
   END IF;
   IF (mix_of_cond_codes_blocked_db_) THEN
      Client_SYS.Add_To_Attr('MIX_OF_COND_CODES_BLOCKED_DB', Fnd_Boolean_API.db_false, attr_);
   END IF;
   IF (mix_of_lot_batch_blocked_db_) THEN
      Client_SYS.Add_To_Attr('MIX_OF_LOT_BATCH_NO_BLOCKED_DB', Fnd_Boolean_API.db_false, attr_);
   END IF;
   IF (exclude_storage_req_val_db_) THEN
      Client_SYS.Add_To_Attr('EXCLUDE_STORAGE_REQ_VAL_DB', Fnd_Boolean_API.db_false, attr_);
   END IF;
   IF (hide_in_whse_navigator_db_) THEN
      Client_SYS.Add_To_Attr('HIDE_IN_WHSE_NAVIGATOR_DB', Fnd_Boolean_API.db_false, attr_);
   END IF;
   IF (bin_width_capacity_db_) THEN
      Client_SYS.Add_To_Attr('BIN_WIDTH_CAPACITY', to_number(NULL), attr_);
   END IF;
   IF (bin_height_capacity_db_) THEN
      Client_SYS.Add_To_Attr('BIN_HEIGHT_CAPACITY', to_number(NULL), attr_);
   END IF;
   IF (bin_dept_capacity_db_) THEN
      Client_SYS.Add_To_Attr('BIN_DEPT_CAPACITY', to_number(NULL), attr_);
   END IF;
   IF (bin_volume_capacity_db_) THEN
      Client_SYS.Add_To_Attr('BIN_VOLUME_CAPACITY', to_number(NULL), attr_);
   END IF;
   IF (tier_carrying_capacity_db_) THEN
      Client_SYS.Add_To_Attr('TIER_CARRYING_CAPACITY', to_number(NULL), attr_);
   END IF;
   IF (bin_carrying_capacity_db_) THEN
      Client_SYS.Add_To_Attr('BIN_CARRYING_CAPACITY', to_number(NULL), attr_);
   END IF;
   IF (bin_min_temperature_db_) THEN
      Client_SYS.Add_To_Attr('BIN_MIN_TEMPERATURE', to_number(NULL), attr_);
   END IF;
   IF (bin_max_temperature_db_) THEN
      Client_SYS.Add_To_Attr('BIN_MAX_TEMPERATURE', to_number(NULL), attr_);
   END IF;
   IF (bin_min_humidity_db_) THEN
      Client_SYS.Add_To_Attr('BIN_MIN_HUMIDITY', to_number(NULL), attr_);
   END IF;
   IF (bin_max_humidity_db_) THEN
      Client_SYS.Add_To_Attr('BIN_MAX_HUMIDITY', to_number(NULL), attr_);
   END IF;
   IF (availability_control_id_db_) THEN
      Client_SYS.Add_To_Attr('AVAILABILITY_CONTROL_ID', to_number(NULL), attr_);
   END IF;
   
   oldrec_ := Lock_By_Keys___(contract_, warehouse_id_, bay_id_, tier_id_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   
   IF (capabilities_db_) THEN
      Warehouse_Tier_Capability_API.Clear_Storage_Capabilities__(contract_, 
                                                                 warehouse_id_, 
                                                                 bay_id_,
                                                                 tier_id_,
                                                                 all_capabilities_db_,
                                                                 capability_tab_);
   END IF;
   
   Clear_Bin_Storage_Chars___(contract_,
                              warehouse_id_,
                              bay_id_,
                              tier_id_,
                              receipts_blocked_db_,
                              receipt_to_occup_blocked_db_,
                              mix_of_part_number_blocked_db_,
                              mix_of_cond_codes_blocked_db_,
                              mix_of_lot_batch_blocked_db_,
                              exclude_storage_req_val_db_,
                              hide_in_whse_navigator_db_,
                              bin_width_capacity_db_,
                              bin_height_capacity_db_,
                              bin_dept_capacity_db_,
                              bin_volume_capacity_db_,
                              bin_carrying_capacity_db_,
                              bin_min_temperature_db_,
                              bin_max_temperature_db_,
                              bin_min_humidity_db_,
                              bin_max_humidity_db_,
                              capabilities_db_,
                              all_capabilities_db_,
                              capability_tab_,
                              availability_control_id_db_);
END Clear_Storage_Chars__;


PROCEDURE Clear_Bin_Storage_Chars__ (
   contract_                    IN VARCHAR2,
   warehouse_id_                IN VARCHAR2,
   bay_id_                      IN VARCHAR2,
   tier_id_                     IN VARCHAR2,
   receipts_blocked_            IN NUMBER,
   receipt_to_occupied_blocked_ IN NUMBER,
   mix_of_part_number_blocked_  IN NUMBER,
   mix_of_cond_codes_blocked_   IN NUMBER,
   mix_of_lot_batch_blocked_    IN NUMBER,
   exclude_storage_req_val_     IN NUMBER,
   hide_in_whse_navigator_      IN NUMBER,
   bin_width_capacity_          IN NUMBER,
   bin_height_capacity_         IN NUMBER,
   bin_dept_capacity_           IN NUMBER,
   bin_volume_capacity_         IN NUMBER,
   bin_carrying_capacity_       IN NUMBER,
   bin_min_temperature_         IN NUMBER,
   bin_max_temperature_         IN NUMBER,
   bin_min_humidity_            IN NUMBER,
   bin_max_humidity_            IN NUMBER,
   capabilities_                IN NUMBER,
   all_capabilities_            IN NUMBER,
   availability_control_id_     IN NUMBER )
IS
   capability_tab_ Storage_Capability_API.Capability_Tab;
BEGIN
   
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   
   IF (capabilities_ = 1) THEN
      IF (all_capabilities_ = 0) THEN 
         capability_tab_ := Warehouse_Bin_Capability_API.Get_Operative_Capabilities(contract_, warehouse_id_, bay_id_, tier_id_, NULL, NULL);
      END IF;
   END IF;
   
   Clear_Bin_Storage_Chars___(contract_,
                              warehouse_id_,
                              bay_id_,
                              tier_id_,
                              CASE receipts_blocked_            WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE receipt_to_occupied_blocked_ WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE mix_of_part_number_blocked_  WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE mix_of_cond_codes_blocked_   WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE mix_of_lot_batch_blocked_    WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE exclude_storage_req_val_     WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE hide_in_whse_navigator_      WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE bin_width_capacity_          WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE bin_height_capacity_         WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE bin_dept_capacity_           WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE bin_volume_capacity_         WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE bin_carrying_capacity_       WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE bin_min_temperature_         WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE bin_max_temperature_         WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE bin_min_humidity_            WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE bin_max_humidity_            WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE capabilities_                WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE all_capabilities_            WHEN 1 THEN TRUE ELSE FALSE END,
                              capability_tab_,
                              CASE availability_control_id_     WHEN 1 THEN TRUE ELSE FALSE END);
END Clear_Bin_Storage_Chars__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 )
IS
   attr_         VARCHAR2(2000);
   newrec_       WAREHOUSE_BAY_TIER_TAB%ROWTYPE;
   objid_        WAREHOUSE_BAY_TIER.objid%TYPE;
   objversion_   WAREHOUSE_BAY_TIER.objversion%TYPE;
   indrec_       Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('WAREHOUSE_ID', warehouse_id_, attr_);
   Client_SYS.Add_To_Attr('BAY_ID', bay_id_, attr_);
   Client_SYS.Add_To_Attr('TIER_ID', tier_id_, attr_);
   Client_SYS.Add_To_Attr('ROUTE_ORDER', tier_id_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Width_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN NUMBER
IS
   bin_width_capacity_ WAREHOUSE_BAY_TIER_TAB.bin_width_capacity%TYPE;
BEGIN
   bin_width_capacity_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (bin_width_capacity_ IS NULL) THEN
      bin_width_capacity_ := Warehouse_Bay_API.Get_Bin_Width_Capacity(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (bin_width_capacity_);
END Get_Bin_Width_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Dept_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN NUMBER
IS
   bin_dept_capacity_ WAREHOUSE_BAY_TIER_TAB.bin_dept_capacity%TYPE;
BEGIN
   bin_dept_capacity_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (bin_dept_capacity_ IS NULL) THEN
      bin_dept_capacity_ := Warehouse_Bay_API.Get_Bin_Dept_Capacity(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (bin_dept_capacity_);
END Get_Bin_Dept_Capacity;


@UncheckedAccess
FUNCTION Get_Bin_Volume_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN NUMBER
IS
   bin_volume_capacity_ WAREHOUSE_BAY_TIER_TAB.bin_volume_capacity%TYPE;
   dummy_               VARCHAR2(20);
BEGIN
   IF (Site_Invent_Info_API.Get_Volume_Uom(contract_) IS NOT NULL) THEN
      Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
      Get_Bin_Vol_Cap_And_Src_Db___(bin_volume_capacity_,
                                    dummy_,
                                    contract_,
                                    warehouse_id_,
                                    bay_id_,
                                    tier_id_,
                                    get_capacity_ => TRUE,
                                    get_source_   => FALSE);
   END IF;                                 
   RETURN (bin_volume_capacity_);      
END Get_Bin_Volume_Capacity;

@UncheckedAccess
FUNCTION Get_Bin_Volume_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_volume_cap_source_db_ VARCHAR2(20);
   dummy_                    WAREHOUSE_BAY_TIER_TAB.bin_volume_capacity%TYPE;
BEGIN
   IF (Site_Invent_Info_API.Get_Volume_Uom(contract_) IS NOT NULL) THEN
      Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
      Get_Bin_Vol_Cap_And_Src_Db___(dummy_,
                                    bin_volume_cap_source_db_,
                                    contract_,
                                    warehouse_id_,
                                    bay_id_,
                                    tier_id_,
                                    get_capacity_ => FALSE,
                                    get_source_   => TRUE);
   END IF;
   RETURN (bin_volume_cap_source_db_);
END Get_Bin_Volume_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Volume_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Volume_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_)));
END Get_Bin_Volume_Capacity_Source;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Carrying_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN NUMBER
IS
   bin_carrying_capacity_ WAREHOUSE_BAY_TIER_TAB.bin_carrying_capacity%TYPE;
BEGIN
   bin_carrying_capacity_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (bin_carrying_capacity_ IS NULL) THEN
      bin_carrying_capacity_ := Warehouse_Bay_API.Get_Bin_Carrying_Capacity(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (bin_carrying_capacity_);
END Get_Bin_Carrying_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Tier_Carrying_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN NUMBER
IS
   tier_carrying_capacity_ WAREHOUSE_BAY_TIER_TAB.tier_carrying_capacity%TYPE;
BEGIN
   tier_carrying_capacity_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (tier_carrying_capacity_ IS NULL) THEN
      tier_carrying_capacity_ := Warehouse_Bay_API.Get_Tier_Carrying_Capacity(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (tier_carrying_capacity_);
END Get_Tier_Carrying_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Min_Temperature (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN NUMBER
IS
   bin_min_temperature_ WAREHOUSE_BAY_TIER_TAB.bin_min_temperature%TYPE;
BEGIN
   bin_min_temperature_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (bin_min_temperature_ IS NULL) THEN
      bin_min_temperature_ := Warehouse_Bay_API.Get_Bin_Min_Temperature(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (bin_min_temperature_);
END Get_Bin_Min_Temperature;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Max_Temperature (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN NUMBER
IS
   bin_max_temperature_ WAREHOUSE_BAY_TIER_TAB.bin_max_temperature%TYPE;
BEGIN
   bin_max_temperature_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (bin_max_temperature_ IS NULL) THEN
      bin_max_temperature_ := Warehouse_Bay_API.Get_Bin_Max_Temperature(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (bin_max_temperature_);
END Get_Bin_Max_Temperature;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Min_Humidity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN NUMBER
IS
   bin_min_humidity_ WAREHOUSE_BAY_TIER_TAB.bin_min_humidity%TYPE;
BEGIN
   bin_min_humidity_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (bin_min_humidity_ IS NULL) THEN
      bin_min_humidity_ := Warehouse_Bay_API.Get_Bin_Min_Humidity(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (bin_min_humidity_);
END Get_Bin_Min_Humidity;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Max_Humidity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN NUMBER
IS
   bin_max_humidity_ WAREHOUSE_BAY_TIER_TAB.bin_max_humidity%TYPE;
BEGIN
   bin_max_humidity_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (bin_max_humidity_ IS NULL) THEN
      bin_max_humidity_ := Warehouse_Bay_API.Get_Bin_Max_Humidity(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (bin_max_humidity_);
END Get_Bin_Max_Humidity;


@UncheckedAccess
FUNCTION Get_Bin_Height_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Height_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_)));
END Get_Bin_Height_Capacity_Source;

@Override
@UncheckedAccess
FUNCTION Get_Bin_Height_Capacity (
   contract_ IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_ IN VARCHAR2,
   tier_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   bin_height_capacity_ warehouse_bay_tier_tab.bin_height_capacity%TYPE;   
BEGIN
   IF (contract_ IS NULL OR warehouse_id_ IS NULL OR bay_id_ IS NULL OR tier_id_ IS NULL) THEN
      RETURN NULL;
   END IF;   
   bin_height_capacity_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (bin_height_capacity_ IS NULL) THEN
      bin_height_capacity_ := Warehouse_Bay_API.Get_Bin_Height_Capacity(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (bin_height_capacity_);
END Get_Bin_Height_Capacity;

@UncheckedAccess
FUNCTION Get_Bin_Width_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Width_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_)));
END Get_Bin_Width_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Dept_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Dept_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_)));
END Get_Bin_Dept_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Carry_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Carry_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_)));
END Get_Bin_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Min_Temperature_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Min_Temp_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_)));
END Get_Bin_Min_Temperature_Source;


@UncheckedAccess
FUNCTION Get_Bin_Max_Temperature_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Max_Temp_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_)));
END Get_Bin_Max_Temperature_Source;


@UncheckedAccess
FUNCTION Get_Bin_Min_Humidity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Min_Humidity_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_)));
END Get_Bin_Min_Humidity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Max_Humidity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Max_Humidity_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_)));
END Get_Bin_Max_Humidity_Source;


@UncheckedAccess
FUNCTION Get_Tier_Carry_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Tier_Carry_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_)));
END Get_Tier_Carry_Capacity_Source;

@UncheckedAccess
FUNCTION Get_Bin_Height_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_height_capacity_source_db_ VARCHAR2(20);   
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.bin_height_capacity IS NULL) THEN
      bin_height_capacity_source_db_ := Warehouse_Bay_API.Get_Bin_Height_Cap_Source_Db(contract_, warehouse_id_, bay_id_);
   ELSE
      bin_height_capacity_source_db_ := Warehouse_Structure_Level_API.DB_TIER;
   END IF;
   RETURN (bin_height_capacity_source_db_);
END Get_Bin_Height_Cap_Source_Db;

@UncheckedAccess
FUNCTION Get_Bin_Width_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_width_capacity_source_db_ VARCHAR2(20);   
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.bin_width_capacity IS NULL) THEN
      bin_width_capacity_source_db_ := Warehouse_Bay_API.Get_Bin_Width_Cap_Source_Db(contract_, warehouse_id_, bay_id_);
   ELSE
      bin_width_capacity_source_db_ := Warehouse_Structure_Level_API.DB_TIER;
   END IF;
   RETURN (bin_width_capacity_source_db_);
END Get_Bin_Width_Cap_Source_Db;

@UncheckedAccess
FUNCTION Get_Bin_Dept_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_dept_capacity_source_db_ VARCHAR2(20);   
BEGIN   
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.bin_dept_capacity IS NULL) THEN
      bin_dept_capacity_source_db_ := Warehouse_Bay_API.Get_Bin_Dept_Cap_Source_Db(contract_, warehouse_id_, bay_id_);
   ELSE
      bin_dept_capacity_source_db_ := Warehouse_Structure_Level_API.DB_TIER;
   END IF;
   RETURN (bin_dept_capacity_source_db_);
END Get_Bin_Dept_Cap_Source_Db;

@UncheckedAccess
FUNCTION Get_Bin_Carry_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_carry_capacity_source_db_ VARCHAR2(20);   
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.bin_carrying_capacity IS NULL) THEN
      bin_carry_capacity_source_db_ := Warehouse_Bay_API.Get_Bin_Carry_Cap_Source_Db(contract_, warehouse_id_, bay_id_);
   ELSE
      bin_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_TIER;
   END IF;
   RETURN (bin_carry_capacity_source_db_);
END Get_Bin_Carry_Cap_Source_Db;

@UncheckedAccess
FUNCTION Get_Bin_Min_Temp_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
  bin_min_temperature_source_db_ VARCHAR2(20);  
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.bin_min_temperature IS NULL) THEN
      bin_min_temperature_source_db_ := Warehouse_Bay_API.Get_Bin_Min_Temp_Source_Db(contract_, warehouse_id_, bay_id_);
   ELSE
      bin_min_temperature_source_db_ := Warehouse_Structure_Level_API.DB_TIER;
   END IF;
   RETURN (bin_min_temperature_source_db_);
END Get_Bin_Min_Temp_Source_Db;

@UncheckedAccess
FUNCTION Get_Bin_Max_Temp_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_max_temperature_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.bin_max_temperature IS NULL) THEN
      bin_max_temperature_source_db_ := Warehouse_Bay_API.Get_Bin_Max_Temp_Source_Db(contract_, warehouse_id_, bay_id_);
   ELSE
      bin_max_temperature_source_db_ := Warehouse_Structure_Level_API.DB_TIER;
   END IF;
   RETURN (bin_max_temperature_source_db_);  
END Get_Bin_Max_Temp_Source_Db;

@UncheckedAccess
FUNCTION Get_Bin_Min_Humidity_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
  bin_min_humidity_source_db_ VARCHAR2(20); 
BEGIN
   IF (micro_cache_value_.bin_min_humidity IS NULL) THEN
      bin_min_humidity_source_db_ := Warehouse_Bay_API.Get_Bin_Min_Humidity_Source_Db(contract_, warehouse_id_, bay_id_);
   ELSE
      bin_min_humidity_source_db_ := Warehouse_Structure_Level_API.DB_TIER;
   END IF;
   RETURN (bin_min_humidity_source_db_); 
END Get_Bin_Min_Humidity_Source_Db;

@UncheckedAccess
FUNCTION Get_Bin_Max_Humidity_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
  bin_max_humidity_source_db_ VARCHAR2(20);  
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.bin_max_humidity IS NULL) THEN
      bin_max_humidity_source_db_ := Warehouse_Bay_API.Get_Bin_Max_Humidity_Source_Db(contract_, warehouse_id_, bay_id_);
   ELSE
      bin_max_humidity_source_db_ := Warehouse_Structure_Level_API.DB_TIER;
   END IF;
   RETURN (bin_max_humidity_source_db_);
END Get_Bin_Max_Humidity_Source_Db;

@UncheckedAccess
FUNCTION Get_Tier_Carry_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   tier_carry_capacity_source_db_ VARCHAR2(20);   
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.tier_carrying_capacity IS NULL) THEN
      tier_carry_capacity_source_db_ := Warehouse_Bay_API.Get_Tier_Carry_Cap_Source_Db(contract_, warehouse_id_, bay_id_);
   ELSE
      tier_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_TIER;
   END IF;
   RETURN (tier_carry_capacity_source_db_); 
END Get_Tier_Carry_Cap_Source_Db;


@Override
@UncheckedAccess
FUNCTION Get_Receipts_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipts_blocked_ WAREHOUSE_BAY_TIER_TAB.receipts_blocked%TYPE;
BEGIN
   receipts_blocked_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   receipts_blocked_ := Fnd_Boolean_API.Encode(receipts_blocked_);
   IF (receipts_blocked_ = Fnd_Boolean_API.db_false) THEN
      receipts_blocked_ := Warehouse_Bay_API.Get_Receipts_Blocked_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(receipts_blocked_);
END Get_Receipts_Blocked;


@Override
@UncheckedAccess
FUNCTION Get_Receipts_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipts_blocked_ WAREHOUSE_BAY_TIER_TAB.receipts_blocked%TYPE;
BEGIN
   receipts_blocked_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (receipts_blocked_ = Fnd_Boolean_API.db_false) THEN
      receipts_blocked_ := Warehouse_Bay_API.Get_Receipts_Blocked_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (receipts_blocked_);
END Get_Receipts_Blocked_Db;

@UncheckedAccess
FUNCTION Get_Receipts_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipts_blocked_source_ VARCHAR2(200);   
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.receipts_blocked = Fnd_Boolean_API.db_false) THEN
      receipts_blocked_source_ := Warehouse_Bay_API.Get_Receipts_Blocked_Source(contract_, warehouse_id_, bay_id_);
   ELSE
      receipts_blocked_source_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_TIER);
   END IF;
   RETURN (receipts_blocked_source_);
END Get_Receipts_Blocked_Source;


@Override
@UncheckedAccess
FUNCTION Get_Receipt_To_Occup_Blockd (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipt_to_occupied_blocked_ WAREHOUSE_BAY_TIER_TAB.receipt_to_occupied_blocked%TYPE;
BEGIN
   receipt_to_occupied_blocked_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   receipt_to_occupied_blocked_ := Fnd_Boolean_API.Encode(receipt_to_occupied_blocked_);
   
   IF (receipt_to_occupied_blocked_ = Fnd_Boolean_API.db_false) THEN
      receipt_to_occupied_blocked_ := Warehouse_Bay_API.Get_Receipt_To_Occup_Blockd_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(receipt_to_occupied_blocked_);
END Get_Receipt_To_Occup_Blockd;


@Override
@UncheckedAccess
FUNCTION Get_Receipt_To_Occup_Blockd_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipt_to_occupied_blocked_ WAREHOUSE_BAY_TIER_TAB.receipt_to_occupied_blocked%TYPE;
BEGIN
   receipt_to_occupied_blocked_ := super(contract_, warehouse_id_, bay_id_, tier_id_);

   IF (receipt_to_occupied_blocked_ = Fnd_Boolean_API.db_false) THEN
      receipt_to_occupied_blocked_ := Warehouse_Bay_API.Get_Receipt_To_Occup_Blockd_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (receipt_to_occupied_blocked_);
END Get_Receipt_To_Occup_Blockd_Db;


@UncheckedAccess
FUNCTION Get_Receipt_To_Occup_Blkd_Src (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipt_to_occup_blkd_src_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.receipt_to_occupied_blocked = Fnd_Boolean_API.db_false) THEN
      receipt_to_occup_blkd_src_ := Warehouse_Bay_API.Get_Receipt_To_Occup_Blkd_Src(contract_, warehouse_id_, bay_id_);
   ELSE
      receipt_to_occup_blkd_src_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_TIER);
   END IF;
   RETURN (receipt_to_occup_blkd_src_);
END Get_Receipt_To_Occup_Blkd_Src;


@Override
@UncheckedAccess
FUNCTION Get_Hide_In_Whse_Navigator (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   hide_in_whse_navigator_ WAREHOUSE_BAY_TIER_TAB.hide_in_whse_navigator%TYPE;
BEGIN
   hide_in_whse_navigator_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (hide_in_whse_navigator_ = Fnd_Boolean_API.db_false) THEN
      hide_in_whse_navigator_ := Warehouse_Bay_API.Get_Hide_In_Whse_Navigator_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(hide_in_whse_navigator_);
END Get_Hide_In_Whse_Navigator;


@Override
@UncheckedAccess
FUNCTION Get_Hide_In_Whse_Navigator_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   hide_in_whse_navigator_ WAREHOUSE_BAY_TIER_TAB.hide_in_whse_navigator%TYPE;
BEGIN   
   hide_in_whse_navigator_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (hide_in_whse_navigator_ = Fnd_Boolean_API.db_false) THEN
      hide_in_whse_navigator_ := Warehouse_Bay_API.Get_Hide_In_Whse_Navigator_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (hide_in_whse_navigator_);
END Get_Hide_In_Whse_Navigator_Db;


@UncheckedAccess
FUNCTION Is_Hidden_In_Structure_Below (
   contract_           IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2,
   tier_id_            IN VARCHAR2,
   called_from_parent_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   hide_in_whse_navigator_ WAREHOUSE_BAY_TIER_TAB.hide_in_whse_navigator%TYPE := Fnd_Boolean_API.db_false;

   CURSOR get_bins IS
      SELECT row_id, bin_id
        FROM warehouse_bay_bin_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_
         AND tier_id      = tier_id_;
BEGIN
   IF (called_from_parent_ = 'TRUE') THEN
      Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
      hide_in_whse_navigator_ := micro_cache_value_.hide_in_whse_navigator;
   END IF;

   IF (hide_in_whse_navigator_ = Fnd_Boolean_API.db_false) THEN
      FOR bin_rec_ IN get_bins LOOP
         hide_in_whse_navigator_ := Warehouse_Bay_Bin_API.Is_Hidden_In_Structure_Below(contract_,
                                                                                       warehouse_id_,
                                                                                       bay_id_,
                                                                                       tier_id_,
                                                                                       bin_rec_.row_id,
                                                                                       bin_rec_.bin_id);
         EXIT WHEN hide_in_whse_navigator_ = 'TRUE';
      END LOOP;
   END IF;

   RETURN hide_in_whse_navigator_;
END Is_Hidden_In_Structure_Below;


@UncheckedAccess
FUNCTION Check_Exist (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN (Check_Exist___(contract_, warehouse_id_, bay_id_, tier_id_));
END Check_Exist;


PROCEDURE Check_Bin_Temperature_Range (
   contract_       IN VARCHAR2,
   warehouse_id_   IN VARCHAR2,
   bay_id_         IN VARCHAR2,
   tier_id_        IN VARCHAR2,
   check_all_bins_ IN BOOLEAN DEFAULT TRUE )
IS
   bin_min_temperature_ WAREHOUSE_BAY_TIER_TAB.bin_min_temperature%TYPE;
   bin_max_temperature_ WAREHOUSE_BAY_TIER_TAB.bin_max_temperature%TYPE;

   CURSOR get_bins IS
      SELECT row_id, bin_id
        FROM warehouse_bay_bin_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_
         AND tier_id      = tier_id_;
BEGIN

   bin_min_temperature_ := Get_Bin_Min_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);
   bin_max_temperature_ := Get_Bin_Max_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);

   IF (Part_Catalog_Invent_Attrib_API.Incorrect_Temperature_Range(bin_min_temperature_, bin_max_temperature_)) THEN
      Error_SYS.Record_General(lu_name_, 'TEMPRANGE: Incorrect Operative Temperature Range for Tier :P1 of Bay :P2 in Warehouse :P3.', tier_id_, bay_id_, warehouse_id_);
   END IF;

   IF (check_all_bins_) THEN
      FOR bin_rec_ IN get_bins LOOP
         Warehouse_Bay_Bin_API.Check_Temperature_Range(contract_,
                                                       warehouse_id_,
                                                       bay_id_,
                                                       tier_id_,
                                                       bin_rec_.row_id,
                                                       bin_rec_.bin_id);
      END LOOP;
   END IF;
END Check_Bin_Temperature_Range;


PROCEDURE Check_Bin_Humidity_Range (
   contract_       IN VARCHAR2,
   warehouse_id_   IN VARCHAR2,
   bay_id_         IN VARCHAR2,
   tier_id_        IN VARCHAR2,
   check_all_bins_ IN BOOLEAN DEFAULT TRUE )
IS
   bin_min_humidity_ WAREHOUSE_BAY_TIER_TAB.bin_min_humidity%TYPE;
   bin_max_humidity_ WAREHOUSE_BAY_TIER_TAB.bin_max_humidity%TYPE;

   CURSOR get_bins IS
      SELECT row_id, bin_id
        FROM warehouse_bay_bin_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_
         AND tier_id      = tier_id_;
BEGIN

   bin_min_humidity_ := Get_Bin_Min_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);
   bin_max_humidity_ := Get_Bin_Max_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);

   IF (Part_Catalog_Invent_Attrib_API.Incorrect_Humidity_Range(bin_min_humidity_, bin_max_humidity_)) THEN
      Error_SYS.Record_General(lu_name_, 'HUMRANGE: Incorrect Operative Humidity Range for Tier :P1 of Bay :P2 in Warehouse :P3.', tier_id_, bay_id_, warehouse_id_);
   END IF;

   IF (check_all_bins_) THEN
      FOR bin_rec_ IN get_bins LOOP
         Warehouse_Bay_Bin_API.Check_Humidity_Range(contract_,
                                                    warehouse_id_,
                                                    bay_id_,
                                                    tier_id_,
                                                    bin_rec_.row_id,
                                                    bin_rec_.bin_id);
      END LOOP;
   END IF;
END Check_Bin_Humidity_Range;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Part_Number_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_part_number_blocked_ WAREHOUSE_BAY_TIER_TAB.mix_of_part_number_blocked%TYPE;
BEGIN
   mix_of_part_number_blocked_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (mix_of_part_number_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_part_number_blocked_ := Warehouse_Bay_API.Get_Mix_Of_Parts_Blocked_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(mix_of_part_number_blocked_);
END Get_Mix_Of_Part_Number_Blocked;

@UncheckedAccess
FUNCTION Get_Mix_Of_Parts_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_part_number_blocked_ WAREHOUSE_BAY_TIER_TAB.mix_of_part_number_blocked%TYPE;
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   mix_of_part_number_blocked_ := micro_cache_value_.mix_of_part_number_blocked;

   IF (mix_of_part_number_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_part_number_blocked_ := Warehouse_Bay_API.Get_Mix_Of_Parts_Blocked_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (mix_of_part_number_blocked_);
END Get_Mix_Of_Parts_Blocked_Db;

@UncheckedAccess
FUNCTION Get_Mix_Of_Part_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_part_blocked_source_ VARCHAR2(200);   
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.mix_of_part_number_blocked = Fnd_Boolean_API.db_false) THEN
      mix_of_part_blocked_source_ := Warehouse_Bay_API.Get_Mix_Of_Part_Blocked_Source(contract_, warehouse_id_, bay_id_);
   ELSE
      mix_of_part_blocked_source_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_TIER);
   END IF;
   RETURN (mix_of_part_blocked_source_); 
END Get_Mix_Of_Part_Blocked_Source;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Codes_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_cond_codes_blocked_ WAREHOUSE_BAY_TIER_TAB.mix_of_cond_codes_blocked%TYPE;
BEGIN
   mix_of_cond_codes_blocked_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (mix_of_cond_codes_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_cond_codes_blocked_ := Warehouse_Bay_API.Get_Mix_Of_Cond_Blocked_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(mix_of_cond_codes_blocked_);
END Get_Mix_Of_Cond_Codes_Blocked;

@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_cond_codes_blocked_ WAREHOUSE_BAY_TIER_TAB.mix_of_cond_codes_blocked%TYPE;
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   mix_of_cond_codes_blocked_ := micro_cache_value_.mix_of_cond_codes_blocked;

   IF (mix_of_cond_codes_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_cond_codes_blocked_ := Warehouse_Bay_API.Get_Mix_Of_Cond_Blocked_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (mix_of_cond_codes_blocked_);
END Get_Mix_Of_Cond_Blocked_Db;

@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_cond_codes_blocked_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.mix_of_cond_codes_blocked = Fnd_Boolean_API.db_false) THEN
      mix_of_cond_codes_blocked_ := Warehouse_Bay_API.Get_Mix_Of_Cond_Blocked_Source(contract_, warehouse_id_, bay_id_);
   ELSE
      mix_of_cond_codes_blocked_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_TIER);
   END IF;
   RETURN (mix_of_cond_codes_blocked_);
END Get_Mix_Of_Cond_Blocked_Source;

@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Lot_Batch_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_lot_batch_no_blocked_ WAREHOUSE_BAY_TIER_TAB.mix_of_lot_batch_no_blocked%TYPE;
BEGIN
   mix_of_lot_batch_no_blocked_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (mix_of_lot_batch_no_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_lot_batch_no_blocked_ := Warehouse_Bay_API.Get_Mix_Of_Lot_Blocked_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(mix_of_lot_batch_no_blocked_);   
END Get_Mix_Of_Lot_Batch_Blocked;

@UncheckedAccess
FUNCTION Get_Mix_Of_Lot_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_lot_batch_no_blocked_ WAREHOUSE_BAY_TIER_TAB.mix_of_lot_batch_no_blocked%TYPE;
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   mix_of_lot_batch_no_blocked_ := micro_cache_value_.mix_of_lot_batch_no_blocked;

   IF (mix_of_lot_batch_no_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_lot_batch_no_blocked_ := Warehouse_Bay_API.Get_Mix_Of_Lot_Blocked_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (mix_of_lot_batch_no_blocked_);
END Get_Mix_Of_Lot_Blocked_Db;

@UncheckedAccess
FUNCTION Get_Mix_Of_Lot_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_lot_blocked_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.mix_of_lot_batch_no_blocked = Fnd_Boolean_API.db_false) THEN
      mix_of_lot_blocked_source_ := Warehouse_Bay_API.Get_Mix_Of_Lot_Blocked_Source(contract_, warehouse_id_, bay_id_);
   ELSE
      mix_of_lot_blocked_source_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_TIER);
   END IF;
   RETURN (mix_of_lot_blocked_source_);
END Get_Mix_Of_Lot_Blocked_Source;


@Override
@UncheckedAccess
FUNCTION Get_Exclude_Storage_Req_Val (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   exclude_storage_req_val_ WAREHOUSE_BAY_TIER_TAB.exclude_storage_req_val%TYPE;
BEGIN
   exclude_storage_req_val_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (exclude_storage_req_val_ = Fnd_Boolean_API.db_false) THEN
      exclude_storage_req_val_ := Warehouse_Bay_API.Get_Exclude_Storage_Req_Val_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(exclude_storage_req_val_);
END Get_Exclude_Storage_Req_Val;


@Override
@UncheckedAccess
FUNCTION Get_Exclude_Storage_Req_Val_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   exclude_storage_req_val_ WAREHOUSE_BAY_TIER_TAB.exclude_storage_req_val%TYPE;
BEGIN
   exclude_storage_req_val_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (exclude_storage_req_val_ = Fnd_Boolean_API.db_false) THEN
      exclude_storage_req_val_ := Warehouse_Bay_API.Get_Exclude_Storage_Req_Val_Db(contract_, warehouse_id_, bay_id_);
   END IF;
   RETURN (exclude_storage_req_val_);
END Get_Exclude_Storage_Req_Val_Db;

@UncheckedAccess
FUNCTION Get_Excl_Storage_Req_Val_Src (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   exclude_storage_req_val_src_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.exclude_storage_req_val = Fnd_Boolean_API.db_false) THEN
      exclude_storage_req_val_src_ := Warehouse_Bay_API.Get_Excl_Storage_Req_Val_Src(contract_, warehouse_id_, bay_id_);
   ELSE
      exclude_storage_req_val_src_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_TIER);
   END IF;
   RETURN (exclude_storage_req_val_src_);   
END Get_Excl_Storage_Req_Val_Src;


FUNCTION Get_Free_Carrying_Capacity (
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   tier_id_                      IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
   free_carrying_capacity_     NUMBER := Inventory_Putaway_Manager_API.positive_infinity_;
   total_carrying_capacity_    NUMBER;
   consumed_carrying_capacity_ NUMBER;
BEGIN
   total_carrying_capacity_ := NVL(Get_Tier_Carrying_Capacity(contract_,
                                                          warehouse_id_,
                                                          bay_id_,
                                                          tier_id_), Inventory_Putaway_Manager_API.positive_infinity_);

   IF (total_carrying_capacity_ < Inventory_Putaway_Manager_API.positive_infinity_) THEN
      consumed_carrying_capacity_ := Inventory_Part_In_Stock_API.Get_Consumed_Carrying_Capacity(contract_                     => contract_,
                                                                                                warehouse_id_                 => warehouse_id_,
                                                                                                bay_id_                       => bay_id_,
                                                                                                tier_id_                      => tier_id_,
                                                                                                ignore_this_handling_unit_id_ => ignore_this_handling_unit_id_);
      free_carrying_capacity_ := total_carrying_capacity_ - consumed_carrying_capacity_;
   END IF;
   RETURN (free_carrying_capacity_);
END Get_Free_Carrying_Capacity; 


PROCEDURE Lock_By_Keys_Wait (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 )
IS
   dummy_ WAREHOUSE_BAY_TIER_TAB%ROWTYPE;
BEGIN

   dummy_ := Lock_By_Keys___(contract_, warehouse_id_, bay_id_, tier_id_);

END Lock_By_Keys_Wait;

@Override
@UncheckedAccess
FUNCTION Get_Availability_Control_Id (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   availability_control_id_ WAREHOUSE_BAY_TIER_TAB.availability_control_id%TYPE;
BEGIN
   availability_control_id_ := super(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (availability_control_id_ IS NULL) THEN
      availability_control_id_ := Warehouse_Bay_API.Get_Availability_Control_Id(contract_, warehouse_id_, bay_id_);
   END IF;   
   RETURN availability_control_id_;
END Get_Availability_Control_Id;

@UncheckedAccess
FUNCTION Get_Avail_Control_Id_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Avail_Control_Id_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_)));
END Get_Avail_Control_Id_Source;

@UncheckedAccess
FUNCTION Get_Avail_Control_Id_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   avail_control_id_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (micro_cache_value_.availability_control_id IS NULL) THEN
      avail_control_id_source_db_ := Warehouse_Bay_API.Get_Avail_Control_Id_Source_Db(contract_, warehouse_id_, bay_id_);
   ELSE
      avail_control_id_source_db_ := Warehouse_Structure_Level_API.DB_TIER;
   END IF;
   RETURN avail_control_id_source_db_;
END Get_Avail_Control_Id_Source_Db;


FUNCTION Get_Base_Bin_Volume_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR get_volume_ IS
   SELECT bin_volume_capacity
     FROM warehouse_bay_tier
    WHERE contract = contract_
      AND warehouse_id = warehouse_id_
      AND bay_id = bay_id_
      AND tier_id = tier_id_;
BEGIN
   OPEN get_volume_;
   FETCH get_volume_ INTO dummy_;
   CLOSE get_volume_;
   RETURN dummy_;
END Get_Base_Bin_Volume_Capacity;


@UncheckedAccess
FUNCTION Get_Default_Tier_Id RETURN VARCHAR2
IS
BEGIN
   RETURN default_tier_id_;
END Get_Default_Tier_Id;