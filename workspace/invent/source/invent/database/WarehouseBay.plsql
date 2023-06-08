-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseBay
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211211  JaThlk  SC21R2-2932, Added new function Get_Default_Bay_Id. 
--  190103  KoDelk  SCUXXW4-15164, Added new Function Get_Base_Bin_Volume_Capacity()
--  170105  LEPESE  LIM-10028, Added parameter ignore_this_handling_unit_id_ to method Get_Free_Carrying_Capacity.
--  161004  ApWilk  Bug 131743, Changed the method as Get_Exclude_Storage_Req_Val_Db() in Check_Update___ for changing the Exclude Storage Requirement 
--                  Validation from FALSE to TRUE on the Bay level.
--  151120  JeLise  LIM-4369, Removed all code related to pallet_drop_off_location_no and renamed nopall_drop_off_location_no.
--  151020  JeLise  LIM-3893, Removed check on pallet related location types in Validate_Drop_Off_Loc_Type___.
--  150820  Matkse  COB-485, Modified Get_Bin_Vol_Cap_And_Src_Db___ by changing the prerequisites for calculating volume.
--  150820          Now height, width and depth needs to have a value for volume to be calculated, else the inherited value is used. (If such exist)
--  140911  Erlise  PRSC-2475, Put to empty. Added attribute receipt_to_occupied_blocked.
--  140911          Added methods Get_Receipt_To_Occup_Blockd, Get_Receipt_To_Occup_Blockd_Db and Get_Receipt_To_Occup_Blkd_Src.
--  140512  MAHPLK  PBSC-9173, Modified Check_Insert___  and Check_Update___ method to validate the route_order for valid string.
--  140220  AwWelk  PBSC-7299, Removed the overtake in Get_Bin_Volume_Capacity().
--  121115  MaEelk  Made a call to Storage_Zone_Detail_API.Remove_Bay from Delete___ that would remove the relevent record when remind a warehouse 
--  121106  MAHPLK  Added Route_Order.
--  120904  JeLise  Changed from calling Part_Catalog_API methods to call the same methods in Part_Catalog_Invent_Attrib_API.
--  120829  Matkse  Added check for cubic capacity of bin_volume in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  120829          Added new implementation method, Get_Bin_Vol_Cap_And_Src_Db___, used for determine source and retrieval of volume capacity.
--  120829          This new method is being called from Get_Volume_Capacity and Get_Bin_Volume_Cap_Source_Db. 
--  120821  Matkse  Modified Get_Bin_Volume_Capacity and Get_Bin_Volume_Capacity_Source by fixing a small bug leading to changes of height not to be
--                  taken into consideration when calculating volume capacity and source.
--  120605  Matkse  Modified Delete___ by adding calls to Site_Putaway_Zone_API.Remove_Bay and Invent_Part_Putaway_Zone_API.Remove_Bay
--  120604  Matkse  Added bin_volume_capacity.
--  120417  MaEelk  Modified Get_Bin_Volume_Capacity to return LEAST(bin_volume_capacity_,999999999999999999999999999) to avoid client errors
--  120417          when the return vlue exceeds 29 digits.
--  120315  MaEelk  Removed the last parameter TRUE in call General_SYS.Init_Method from  non-implementation methods
--  120312  Matkse  Added view WAREHOUSE_BAY_LOV2
--  120309  LEPESE  Added methods FUNCTION Get_Bin_Height_Cap_Source_Db, Get_Bin_Width_Cap_Source_Db, Get_Bin_Dept_Cap_Source_Db
--  120309          Get_Bin_Carry_Cap_Source_Db, Get_Bin_Min_Temp_Source_Db, Get_Bin_Max_Temp_Source_Db, Get_Bin_Min_Humidity_Source_Db
--  120309          Get_Bin_Max_Humidity_Source_Db, Get_Bay_Carry_Cap_Source_Db, Get_Row_Carry_Cap_Source_Db, Get_Tier_Carry_Cap_Source_Db.
--  120307  LEPESE  Added method Copy_Capabilities___.
--  111121  JeLise  Added methods Clear_Storage_Chars__, Clear_Row_Tier_Strg_Chars___ and Clear_Row_Tier_Storage_Chars__.
--  111103  JeLise  Added exclude_storage_req_val.
--  110916  DaZase  Added functionality in Get_Attr___, Copy__ and Copy_Rows_And_Tiers__ to make sure that some capacities and conditions will not 
--  110916          be copied if from/to companies have different length, weight or temperature uoms.
--  110905  DaZase  Changed Get_Bin_Volume_Capacity so it will only return value if we have a valid volume UOM.
--  110707  MaEelk  Added user allowed site filter to WAREHOUSE_BAY and WAREHOUSE_BAY_LOV.
--  110526  ShKolk  Added General_SYS for Get_Free_Carrying_Capacity().
--  110405  DaZase  Added mix_of_lot_batch_no_blocked.
--  110208  DaZase  Added Lock_By_Keys_Wait.
--  110124  DaZase  Added Get_Free_Carrying_Capacity.
--  101014  JeLise  Added mix_of_part_number_blocked and mix_of_cond_codes_blocked.
--  100922  JeLise  Changed from calling Incorrect_Temperature_Range and Incorrect_Humidity_Range in 
--  100922          Site_Invent_Info_API to same methods in Part_Catalog_API.
--  100830  DaZase  Added Get_Bin_Volume_Capacity.
--  100824  JeLise  Changed from calling Warehouse_Bay_Bin_API.Check_Humidity to Part_Catalog_API.Check_Humidity.
--  100406  Dazase  Added hide_in_whse_navigator.
--  100115  DaZase  Added methods Get_Receipts_Blocked, Get_Receipts_Blocked_Db and Get_Receipts_Blocked_Source.
--  100114  RILASE  Added receipts_blocked.
--  091106  NaLrlk  Added view WAREHOUSE_BAY_LOV.
--  091027  LEPESE  Added calls from Unpack_Check_Insert___ and Unpack_Check_Update___
--  091027          to methods Warehouse_Bay_Bin_API.Check_Humidity,
--  091027          Warehouse_Bay_Bin_API.Check_Carrying_Capacity and
--  091027          Warehouse_Bay_Bin_API.Check_Cubic_Capacity where checks are centralized.
--  091021  LEPESE  Renamed Check_Humidity_Interval and Check_Temperature_Interval into
--  091021          Check_Humidity_Range and Check_Temperature_Range.
--  091021          Modifications in Check_Humidity_Range and Check_Temperature_Range
--  091021          to use methods Site_Invent_Info_API.Incorrect_Temperature_Range and
--  091021          Site_Invent_Info_API.Incorrect_Humidity_Range to validate the ranges.
--  091019  NaLrlk  Modified method Copy_Rows_And_Tiers__ to check from_contract is user allowed site.
--  091008  NaLrlk  Modified the WAREHOUSE_BAY view ref column to CASCADE check.
--  090907  ShKolk  Added method Check_Exist and renamed method Create_Default_Bay to New.
--  090904  LEPESE  Added methods Check_Bin_Temperature_Interval and Check_Bin_Humidity_Interval.
--  090904          Added calls to these methods from Insert___ and Update___.
--  090825  LEPESE  Added methods Get_Attr___, Copy__ and Copy_Rows_And_Tiers__.
--  090819  NaLrlk  Added max weight for bay, row and tier columns.
--  090707  NaLrlk  Added warehouse bin characteristics public columns and respective source functions.
--  090707          Implemented Micro Cache. Added new mehods Invalidate_Cache___ and Update_Cache___.
--  090428  KiSalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

default_bay_id_ CONSTANT VARCHAR2(3)  := '  -';


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Bin_Vol_Cap_And_Src_Db___ (
   bin_volume_capacity_           OUT WAREHOUSE_BAY_TAB.bin_volume_capacity%TYPE,
   bin_volume_capacity_source_db_ OUT VARCHAR2,
   contract_                      IN WAREHOUSE_BAY_TAB.contract%TYPE,
   warehouse_id_                  IN WAREHOUSE_BAY_TAB.warehouse_id%TYPE,
   bay_id_                        IN WAREHOUSE_BAY_TAB.bay_id%TYPE,
   get_capacity_                  IN BOOLEAN,
   get_source_                    IN BOOLEAN )
IS
   bin_height_capacity_ WAREHOUSE_BAY_TAB.bin_height_capacity%TYPE;
   bin_width_capacity_  WAREHOUSE_BAY_TAB.bin_width_capacity%TYPE;
   bin_dept_capacity_   WAREHOUSE_BAY_TAB.bin_dept_capacity%TYPE;
BEGIN
   IF (Site_Invent_Info_API.Get_Volume_Uom(contract_) IS NOT NULL) THEN
      Update_Cache___(contract_, warehouse_id_, bay_id_);
      IF ( micro_cache_value_.bin_volume_capacity IS NULL) THEN
         IF ((micro_cache_value_.bin_width_capacity IS NULL) OR
            (micro_cache_value_.bin_height_capacity IS NULL) OR
            (micro_cache_value_.bin_dept_capacity IS NULL)) THEN
            IF (get_capacity_) THEN
               bin_volume_capacity_ := Warehouse_API.Get_Bin_Volume_Capacity(contract_, warehouse_id_);
            END IF;
            IF (get_source_) THEN
               bin_volume_capacity_source_db_ := Warehouse_API.Get_Bin_Volume_Cap_Source_Db(contract_, warehouse_id_);
            END IF;
         ELSE
            bin_height_capacity_ := Get_Bin_Height_Capacity(contract_, warehouse_id_, bay_id_);
            IF (bin_height_capacity_ IS NOT NULL) THEN
               bin_width_capacity_  := Get_bin_Width_Capacity(contract_, warehouse_id_, bay_id_);
               IF (bin_width_capacity_ IS NOT NULL) THEN
                  bin_dept_capacity_   := Get_Bin_Dept_Capacity(contract_, warehouse_id_, bay_id_);
                  IF (bin_dept_capacity_ IS NOT NULL) THEN
                     bin_volume_capacity_ := bin_height_capacity_ * bin_width_capacity_ * bin_dept_capacity_;
                     bin_volume_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
                  END IF;
               END IF;
            END IF;
         END IF;
      ELSE
         bin_volume_capacity_ := micro_cache_value_.bin_volume_capacity;
         bin_volume_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
      END IF;
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
   newrec_     IN OUT WAREHOUSE_BAY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   -- These checks needs to be performed after storing the record
   -- because they are using the method for fetching the operative
   -- values which read the database.
   Check_Bin_Temperature_Range(newrec_.contract, newrec_.warehouse_id, newrec_.bay_id);
   Check_Bin_Humidity_Range   (newrec_.contract, newrec_.warehouse_id, newrec_.bay_id);

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     WAREHOUSE_BAY_TAB%ROWTYPE,
   newrec_     IN OUT WAREHOUSE_BAY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   number_null_ NUMBER := -9999999;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   IF ((NVL(newrec_.bin_min_temperature, number_null_) != NVL(oldrec_.bin_min_temperature, number_null_)) OR
       (NVL(newrec_.bin_max_temperature, number_null_) != NVL(oldrec_.bin_max_temperature, number_null_))) THEN
      -- Theses checks needs to be performed after updating the record
      -- because it uses Get_Bin_Min_Temperature and
      -- Get_Bin_Max_Temperature which reads the database.
      Check_Bin_Temperature_Range(newrec_.contract, newrec_.warehouse_id, newrec_.bay_id);
   END IF;

   IF ((NVL(newrec_.bin_min_humidity, number_null_) != NVL(oldrec_.bin_min_humidity, number_null_)) OR
       (NVL(newrec_.bin_max_humidity, number_null_) != NVL(oldrec_.bin_max_humidity, number_null_))) THEN
      -- These checks needs to be performed after updating the record
      -- because it uses Get_Bin_Min_Humidity and
      -- Get_Bin_Max_Humidity which reads the database.
      Check_Bin_Humidity_Range(newrec_.contract, newrec_.warehouse_id, newrec_.bay_id);
   END IF;

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
   WHEN OTHERS THEN
      Invalidate_Cache___;
      RAISE;
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN WAREHOUSE_BAY_TAB%ROWTYPE )
IS
BEGIN
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, remrec_.contract);
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN WAREHOUSE_BAY_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Storage_Zone_Detail_API.Remove_Bay(remrec_.contract, remrec_.warehouse_id, remrec_.bay_id);
END Delete___;


FUNCTION Get_Attr___ (
   lu_rec_                    IN WAREHOUSE_BAY_TAB%ROWTYPE,
   include_cubic_capacity_    IN BOOLEAN,
   include_carrying_capacity_ IN BOOLEAN,
   include_temperatures_      IN BOOLEAN ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(2000);
BEGIN
   Client_SYS.Add_To_Attr('CONTRACT',                       lu_rec_.contract,                    attr_);
   Client_SYS.Add_To_Attr('WAREHOUSE_ID',                   lu_rec_.warehouse_id,                attr_);
   Client_SYS.Add_To_Attr('BAY_ID',                         lu_rec_.bay_id,                      attr_);
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
      IF (lu_rec_.bay_carrying_capacity IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('BAY_CARRYING_CAPACITY', lu_rec_.bay_carrying_capacity, attr_);
      END IF;
      IF (lu_rec_.row_carrying_capacity IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('ROW_CARRYING_CAPACITY', lu_rec_.row_carrying_capacity, attr_);
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


PROCEDURE Clear_Row_Tier_Strg_Chars___ (
   contract_                      IN VARCHAR2,
   warehouse_id_                  IN VARCHAR2,
   bay_id_                        IN VARCHAR2,
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
   row_carrying_capacity_db_      IN BOOLEAN,
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
   CURSOR get_rows IS
      SELECT row_id
      FROM warehouse_bay_row_tab
      WHERE contract     = contract_
      AND   warehouse_id = warehouse_id_
      AND   bay_id       = bay_id_;

   CURSOR get_tiers IS
      SELECT tier_id
      FROM warehouse_bay_tier_tab
      WHERE contract     = contract_
      AND   warehouse_id = warehouse_id_
      AND   bay_id       = bay_id_;
BEGIN
   
   FOR row_rec_ IN get_rows LOOP
      Warehouse_Bay_Row_API.Clear_Storage_Chars__(contract_,
                                                  warehouse_id_,
                                                  bay_id_,
                                                  row_rec_.row_id,
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
                                                  row_carrying_capacity_db_,
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

   FOR tier_rec_ IN get_tiers LOOP
      Warehouse_Bay_Tier_API.Clear_Storage_Chars__(contract_,
                                                   warehouse_id_,
                                                   bay_id_,
                                                   tier_rec_.tier_id,
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
                                                   tier_carrying_capacity_db_,
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
END Clear_Row_Tier_Strg_Chars___;


PROCEDURE Copy_Capabilities___ (
   from_contract_     IN VARCHAR2,
   from_warehouse_id_ IN VARCHAR2,
   from_bay_id_       IN VARCHAR2,
   to_contract_       IN VARCHAR2,
   to_warehouse_id_   IN VARCHAR2,
   to_bay_id_         IN VARCHAR2 )
IS
   CURSOR get_capabilities IS
      SELECT storage_capability_id
        FROM warehouse_bay_capability_tab
       WHERE contract     = from_contract_
         AND warehouse_id = from_warehouse_id_
         AND bay_id       = from_bay_id_;
BEGIN

   FOR rec_ IN get_capabilities LOOP
      Warehouse_Bay_Capability_API.Copy__(from_contract_,
                                          from_warehouse_id_,
                                          from_bay_id_,
                                          rec_.storage_capability_id,
                                          to_contract_,
                                          to_warehouse_id_,
                                          to_bay_id_);
   END LOOP;
END Copy_Capabilities___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT warehouse_bay_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF NOT (indrec_.route_order)THEN
      newrec_.route_order  := newrec_.bay_id;
   END IF;
   IF NOT (indrec_.receipts_blocked)THEN
      newrec_.receipts_blocked            := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.receipt_to_occupied_blocked) THEN
      newrec_.receipt_to_occupied_blocked := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.hide_in_whse_navigator)THEN
      newrec_.hide_in_whse_navigator      := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.mix_of_part_number_blocked)THEN
      newrec_.mix_of_part_number_blocked  := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.mix_of_cond_codes_blocked)THEN
     newrec_.mix_of_cond_codes_blocked    := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.mix_of_lot_batch_no_blocked)THEN
     newrec_.mix_of_lot_batch_no_blocked  := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.exclude_storage_req_val)THEN
     newrec_.exclude_storage_req_val      := Fnd_Boolean_API.db_false;
   END IF;

   
   super(newrec_, indrec_, attr_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract); 
 
   IF (UPPER(newrec_.bay_id) != newrec_.bay_id) THEN
      Error_SYS.Record_General(lu_name_,'WBIDUPPERCASE: The Bay ID must be entered in upper-case.');
   END IF;
   IF (newrec_.bay_id != default_bay_id_) THEN
      Error_SYS.Check_Valid_Key_String('BAY_ID', newrec_.bay_id);
   END IF;
   
   IF (newrec_.route_order != default_bay_id_) THEN
      Error_SYS.Check_Valid_Key_String('ROUTE_ORDER', newrec_.route_order);
   END IF;
   
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.bin_height_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.bin_width_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.bin_dept_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.bin_volume_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.bay_carrying_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.row_carrying_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.tier_carrying_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.bin_carrying_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Humidity         (newrec_.bin_min_humidity);
   Part_Catalog_Invent_Attrib_API.Check_Humidity         (newrec_.bin_max_humidity);
   
   Validate_Drop_Off_Location___(newrec_);

END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     warehouse_bay_tab%ROWTYPE,
   newrec_ IN OUT warehouse_bay_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
   number_null_                 NUMBER := -9999999;   
   receipts_blocked_source_     VARCHAR2(200);
   receipt_to_occup_blkd_src_   VARCHAR2(200);
   mix_of_part_blocked_source_  VARCHAR2(200);
   mix_of_cond_blocked_source_  VARCHAR2(200);
   mix_of_lot_blocked_source_   VARCHAR2(200);
   exclude_storage_req_val_src_ VARCHAR2(200);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
 
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract); 
 
   IF (oldrec_.receipts_blocked = Fnd_Boolean_API.db_false) AND (newrec_.receipts_blocked = Fnd_Boolean_API.db_true) THEN
      -- Receipts Blocked has been changed from FALSE to TRUE on the Bay level.
      IF (Get_Receipts_Blocked_Db(newrec_.contract,
                                  newrec_.warehouse_id,
                                  newrec_.bay_id) = Fnd_Boolean_API.db_true) THEN
         -- The Bay is already blocked because whole Warehouse is blocked.
         receipts_blocked_source_ := Get_Receipts_Blocked_Source(newrec_.contract,
                                                                 newrec_.warehouse_id,
                                                                 newrec_.bay_id);
         Error_SYS.Record_General(lu_name_,'RECEIPTSBLKTNOUPDATE: Receipts are already blocked on the :P1 level of the Warehouse Structure.', receipts_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.receipt_to_occupied_blocked = Fnd_Boolean_API.db_false) AND (newrec_.receipt_to_occupied_blocked = Fnd_Boolean_API.db_true) THEN
      -- Receipt to occupied blocked has been changed from FALSE to TRUE on the Bay level.
      IF (Get_Receipt_To_Occup_Blockd_Db(newrec_.contract,
                                         newrec_.warehouse_id,
                                         newrec_.bay_id) = Fnd_Boolean_API.db_true) THEN
         -- The Bay is already blocked because whole Warehouse is blocked.
         receipt_to_occup_blkd_src_ := Get_Receipt_To_Occup_Blkd_Src(newrec_.contract,
                                                                     newrec_.warehouse_id,
                                                                     newrec_.bay_id);
         Error_SYS.Record_General(lu_name_,'RECOCCUPBLKTNOUPDATE: Receipt to occupied is already blocked on the :P1 level of the Warehouse Structure.', receipt_to_occup_blkd_src_);
      END IF;
   END IF;

   IF (oldrec_.mix_of_part_number_blocked = Fnd_Boolean_API.db_false) AND (newrec_.mix_of_part_number_blocked = Fnd_Boolean_API.db_true) THEN
      -- Mix of Part Numbers Blocked has been changed from FALSE to TRUE on the Bay level.
      IF (Get_Mix_Of_Parts_Blocked_Db(newrec_.contract,
                                      newrec_.warehouse_id,
                                      newrec_.bay_id) = Fnd_Boolean_API.db_true) THEN
         -- The Bay is already blocked because whole Warehouse is blocked.
         mix_of_part_blocked_source_ := Get_Mix_Of_Part_Blocked_Source(newrec_.contract,
                                                                       newrec_.warehouse_id,
                                                                       newrec_.bay_id);
         Error_SYS.Record_General(lu_name_,'MIXPARTSNOUPDATE: Mix of Part Numbers already blocked on the :P1 level of the Warehouse Structure.', mix_of_part_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.mix_of_cond_codes_blocked = Fnd_Boolean_API.db_false) AND (newrec_.mix_of_cond_codes_blocked = Fnd_Boolean_API.db_true) THEN
      -- Mix of Condition Codes Blocked has been changed from FALSE to TRUE on the Bay level.
      IF (Get_Mix_Of_Cond_Blocked_Db(newrec_.contract,
                                      newrec_.warehouse_id,
                                      newrec_.bay_id) = Fnd_Boolean_API.db_true) THEN
         -- The Bay is already blocked because whole Warehouse is blocked.
         mix_of_cond_blocked_source_ := Get_Mix_Of_Cond_Blocked_Source(newrec_.contract,
                                                                       newrec_.warehouse_id,
                                                                       newrec_.bay_id);
         Error_SYS.Record_General(lu_name_,'MIXCONDITIONSNOUPDATE: Mix of Condition Codes already blocked on the :P1 level of the Warehouse Structure.', mix_of_cond_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.mix_of_lot_batch_no_blocked = Fnd_Boolean_API.db_false) AND (newrec_.mix_of_lot_batch_no_blocked = Fnd_Boolean_API.db_true) THEN
      -- Mix of Lot Batch Numbers Blocked has been changed from FALSE to TRUE on the Bay level.
      IF (Get_Mix_Of_Lot_Blocked_Db(newrec_.contract,
                                    newrec_.warehouse_id,
                                    newrec_.bay_id) = Fnd_Boolean_API.db_true) THEN
         -- The Bay is already blocked because whole Warehouse is blocked.
         mix_of_lot_blocked_source_ := Get_Mix_Of_Lot_Blocked_Source(newrec_.contract,
                                                                     newrec_.warehouse_id,
                                                                     newrec_.bay_id);
         Error_SYS.Record_General(lu_name_,'MIXLOTBATCHNOUPDATE: Mix of Lot Batch Numbers already blocked on the :P1 level of the Warehouse Structure.', mix_of_lot_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.exclude_storage_req_val = Fnd_Boolean_API.db_false) AND (newrec_.exclude_storage_req_val = Fnd_Boolean_API.db_true) THEN
      -- Exclude Storage Requirement Validation has been changed from FALSE to TRUE on the Bay level.
      IF (Get_Exclude_Storage_Req_Val_Db(newrec_.contract,
                                         newrec_.warehouse_id,
                                         newrec_.bay_id) = Fnd_Boolean_API.db_true) THEN
         -- The Bay is already excluded because whole Warehouse is excluded.
         exclude_storage_req_val_src_ := Get_Excl_Storage_Req_Val_Src(newrec_.contract,
                                                                      newrec_.warehouse_id,
                                                                      newrec_.bay_id);
         Error_SYS.Record_General(lu_name_,'EXCLSTORAGEREQUPDATE: Exclude Storage Requirement Validation already checked on the :P1 level of the Warehouse Structure.', exclude_storage_req_val_src_);
      END IF;
   END IF;
   
   IF (newrec_.route_order != default_bay_id_) THEN
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
   IF (NVL(newrec_.bay_carrying_capacity, number_null_) != NVL(oldrec_.bay_carrying_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.bay_carrying_capacity);
   END IF;
   IF (NVL(newrec_.row_carrying_capacity, number_null_) != NVL(oldrec_.row_carrying_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.row_carrying_capacity);
   END IF;
   IF (NVL(newrec_.tier_carrying_capacity, number_null_) != NVL(oldrec_.tier_carrying_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.tier_carrying_capacity);
   END IF;
   IF (NVL(newrec_.bin_carrying_capacity, number_null_) != NVL(oldrec_.bin_carrying_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.bin_carrying_capacity);
   END IF;
   IF (NVL(newrec_.bin_min_humidity, number_null_) != NVL(oldrec_.bin_min_humidity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.bin_min_humidity);
   END IF;
   IF (NVL(newrec_.bin_max_humidity, number_null_) != NVL(oldrec_.bin_max_humidity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.bin_max_humidity);
   END IF;
   
   Validate_Drop_Off_Location___(newrec_, oldrec_);

END Check_Update___;


PROCEDURE Validate_Drop_Off_Loc_Type___ (
   newrec_ IN WAREHOUSE_BAY_TAB%ROWTYPE )
IS
BEGIN     
   IF (NOT Inventory_Location_API.Get_Location_Type_Db(newrec_.contract, newrec_.drop_off_location_no) IN ('PICKING','F','MANUFACTURING')) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGSINGLELOCATIONTYPE: A drop-off location must to be of location type :P1, :P2 or :P3.', Inventory_Location_Type_API.Decode('PICKING'), Inventory_Location_Type_API.Decode('F'), Inventory_Location_Type_API.Decode('MANUFACTURING'));
   END IF;
END Validate_Drop_Off_Loc_Type___;


PROCEDURE Validate_Drop_Off_Location___ (
   newrec_ IN WAREHOUSE_BAY_TAB%ROWTYPE,
   oldrec_ IN WAREHOUSE_BAY_TAB%ROWTYPE DEFAULT NULL)
IS
BEGIN     
   IF (Inventory_Location_API.Get_Warehouse(newrec_.contract, newrec_.drop_off_location_no) != newrec_.warehouse_id) THEN
      Error_SYS.Record_General(lu_name_,'DROPOFFLOCATIONSAMEBAY: A drop off location for a bay must be in the same warehouse as the bay itself.');
   END IF;
   
   Validate_Drop_Off_Loc_Type___(newrec_);
   Validate_Drop_Off_Loop___(newrec_.contract, newrec_.warehouse_id, newrec_.bay_id, newrec_.drop_off_location_no);
END Validate_Drop_Off_Location___;


PROCEDURE Validate_Drop_Off_Loop___ (
   contract_             IN VARCHAR2,
   warehouse_id_         IN VARCHAR2,
   source_bay_id_        IN VARCHAR2,
   drop_off_location_no_ IN VARCHAR2 )
IS
   TYPE drop_off_type         IS VARRAY(100) OF VARCHAR2(15);
   approved_drop_offs_        drop_off_type;
   old_drop_off_bay_id_       VARCHAR2(15);
   next_drop_off_bay_id_      VARCHAR2(15);
   next_drop_off_location_no_ VARCHAR2(35);
   has_drop_off_              BOOLEAN  := FALSE;
   infinite_loop_             BOOLEAN  := FALSE;
   counter_                   NUMBER   := 1;
BEGIN
   next_drop_off_bay_id_ := Inventory_Location_API.Get_Bay_No(contract_, drop_off_location_no_);
   next_drop_off_location_no_ := drop_off_location_no_;
   -- If drop off bay differ from source bay
   IF (source_bay_id_ != next_drop_off_bay_id_) THEN 
      -- First drop off is considered approved
      approved_drop_offs_ := drop_off_type();
      approved_drop_offs_.extend;
      approved_drop_offs_(counter_) := next_drop_off_bay_id_;
      counter_ := counter_ + 1;
      
      LOOP
         old_drop_off_bay_id_       := next_drop_off_bay_id_;
         -- Get next possible drop off 
         next_drop_off_location_no_ := Get_Drop_Off_Location_No(contract_, warehouse_id_, next_drop_off_bay_id_);
         next_drop_off_bay_id_      := Inventory_Location_API.Get_Bay_No(contract_, next_drop_off_location_no_);

         has_drop_off_ := CASE WHEN next_drop_off_bay_id_ IS NOT NULL THEN TRUE ELSE FALSE END;
         IF (has_drop_off_) THEN
            -- If the next drop off is same as source bay we got a infinite loop
            IF (next_drop_off_bay_id_ = source_bay_id_) THEN
               infinite_loop_ := TRUE;
            ELSIF (next_drop_off_bay_id_ = old_drop_off_bay_id_) THEN
               -- The next drop off has itself as drop off, OK and we're done
               EXIT;
            ELSE
               -- Iterate through all previously approved drop offs and see if the current one already exists, if so, infinite loop exists
               FOR i IN approved_drop_offs_.FIRST .. approved_drop_offs_.LAST LOOP
                  IF approved_drop_offs_(i) = next_drop_off_bay_id_ THEN
                     infinite_loop_ := TRUE;
                     EXIT;
                  END IF;
               END LOOP;
            END IF;
                      
            IF (infinite_loop_) THEN
               Error_SYS.Record_General(lu_name_, 'DROPOFFINFINITERECURSION: Current drop off location structure is causing an infinite loop.');
               EXIT;
            END IF;
         
            -- All good, add current drop off to list of approved drop offs.
            approved_drop_offs_.EXTEND;
            approved_drop_offs_(counter_) := next_drop_off_bay_id_;
            counter_ := counter_ + 1;       
         END IF;
         EXIT WHEN has_drop_off_ = FALSE;
      END LOOP;
   END IF;
   
END Validate_Drop_Off_Loop___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy__ (
   from_contract_          IN VARCHAR2,
   from_warehouse_id_      IN VARCHAR2,
   from_bay_id_            IN VARCHAR2,
   to_contract_            IN VARCHAR2,
   to_warehouse_id_        IN VARCHAR2,
   to_bay_id_              IN VARCHAR2,
   copy_rows_and_tiers_    IN BOOLEAN,
   copy_cubic_capacity_    IN BOOLEAN,
   copy_carrying_capacity_ IN BOOLEAN,
   copy_temperatures_      IN BOOLEAN )
IS
   newrec_     WAREHOUSE_BAY_TAB%ROWTYPE;
   empty_rec_  WAREHOUSE_BAY_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN

   Exist(from_contract_, from_warehouse_id_, from_bay_id_);
   Warehouse_API.Exist(to_contract_, to_warehouse_id_);

   IF NOT (Check_Exist___(to_contract_, to_warehouse_id_, to_bay_id_)) THEN
      newrec_              := Get_Object_By_Keys___(from_contract_, from_warehouse_id_, from_bay_id_);
      newrec_.contract     := to_contract_;
      newrec_.warehouse_id := to_warehouse_id_;
      newrec_.bay_id       := to_bay_id_;
      attr_                := Get_Attr___(newrec_, copy_cubic_capacity_, copy_carrying_capacity_, copy_temperatures_);
      newrec_              := empty_rec_;

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);      
      Insert___(objid_, objversion_, newrec_, attr_);

      Copy_Capabilities___(from_contract_,
                           from_warehouse_id_,
                           from_bay_id_,
                           to_contract_,
                           to_warehouse_id_,
                           to_bay_id_);
   END IF;

   IF (copy_rows_and_tiers_) THEN
      Copy_Rows_And_Tiers__(from_contract_,
                            from_warehouse_id_,
                            from_bay_id_,
                            to_contract_,
                            to_warehouse_id_,
                            to_bay_id_,
                            copy_cubic_capacity_, 
                            copy_carrying_capacity_, 
                            copy_temperatures_);
   END IF;
END Copy__;


PROCEDURE Copy_Rows_And_Tiers__ (
   from_contract_          IN VARCHAR2,
   from_warehouse_id_      IN VARCHAR2,
   from_bay_id_            IN VARCHAR2,
   to_contract_            IN VARCHAR2,
   to_warehouse_id_        IN VARCHAR2,
   to_bay_id_              IN VARCHAR2,
   copy_cubic_capacity_    IN BOOLEAN,
   copy_carrying_capacity_ IN BOOLEAN,
   copy_temperatures_      IN BOOLEAN )
IS
   CURSOR get_rows IS
      SELECT row_id
        FROM warehouse_bay_row_tab
       WHERE contract     = from_contract_
         AND warehouse_id = from_warehouse_id_
         AND bay_id       = from_bay_id_;

   CURSOR get_tiers IS
      SELECT tier_id
        FROM warehouse_bay_tier_tab
       WHERE contract     = from_contract_
         AND warehouse_id = from_warehouse_id_
         AND bay_id       = from_bay_id_;
BEGIN

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, from_contract_);
   FOR row_rec_ IN get_rows LOOP
      Warehouse_Bay_Row_API.Copy__(from_contract_,
                                   from_warehouse_id_,
                                   from_bay_id_,
                                   row_rec_.row_id,
                                   to_contract_,
                                   to_warehouse_id_,
                                   to_bay_id_,
                                   row_rec_.row_id,
                                   copy_bins_ => TRUE,
                                   copy_cubic_capacity_ => copy_cubic_capacity_,
                                   copy_carrying_capacity_ => copy_carrying_capacity_,
                                   copy_temperatures_ => copy_temperatures_);
   END LOOP;

   FOR tier_rec_ IN get_tiers LOOP
      Warehouse_Bay_Tier_API.Copy__(from_contract_,
                                    from_warehouse_id_,
                                    from_bay_id_,
                                    tier_rec_.tier_id,
                                    to_contract_,
                                    to_warehouse_id_,
                                    to_bay_id_,
                                    tier_rec_.tier_id,
                                    copy_bins_ => TRUE,
                                    copy_cubic_capacity_ => copy_cubic_capacity_,
                                    copy_carrying_capacity_ => copy_carrying_capacity_,
                                    copy_temperatures_ => copy_temperatures_);
   END LOOP;
END Copy_Rows_And_Tiers__;


PROCEDURE Clear_Storage_Chars__ (
   contract_                      IN VARCHAR2,
   warehouse_id_                  IN VARCHAR2,
   bay_id_                        IN VARCHAR2,
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
   bay_carrying_capacity_db_      IN BOOLEAN,
   row_carrying_capacity_db_      IN BOOLEAN,
   tier_carrying_capacity_db_     IN BOOLEAN,
   bin_carrying_capacity_db_      IN BOOLEAN,
   bin_min_temperature_db_        IN BOOLEAN,
   bin_max_temperature_db_        IN BOOLEAN,
   bin_min_humidity_db_           IN BOOLEAN,
   bin_max_humidity_db_           IN BOOLEAN,
   capabilities_db_               IN BOOLEAN,
   all_capabilities_db_           IN BOOLEAN,
   capability_tab_                IN Storage_Capability_API.Capability_Tab,
   availability_control_id_db_    IN BOOLEAN,
   drop_off_location_db_          IN BOOLEAN )
IS
   newrec_     WAREHOUSE_BAY_TAB%ROWTYPE;
   oldrec_     WAREHOUSE_BAY_TAB%ROWTYPE;
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
   IF (bay_carrying_capacity_db_) THEN
      Client_SYS.Add_To_Attr('BAY_CARRYING_CAPACITY', to_number(NULL), attr_);
   END IF;
   IF (row_carrying_capacity_db_) THEN
      Client_SYS.Add_To_Attr('ROW_CARRYING_CAPACITY', to_number(NULL), attr_);
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
   IF (drop_off_location_db_) THEN
      Client_SYS.Add_To_Attr('DROP_OFF_LOCATION_NO', to_number(NULL), attr_);
   END IF;
   
   oldrec_ := Lock_By_Keys___(contract_, warehouse_id_, bay_id_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   
   IF (capabilities_db_) THEN
      Warehouse_Bay_Capability_API.Clear_Storage_Capabilities__(contract_, 
                                                                warehouse_id_, 
                                                                bay_id_,
                                                                all_capabilities_db_,
                                                                capability_tab_);
   END IF;
   
   Clear_Row_Tier_Strg_Chars___(contract_,
                                warehouse_id_,
                                bay_id_,
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
                                row_carrying_capacity_db_,
                                tier_carrying_capacity_db_,
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


PROCEDURE Clear_Row_Tier_Storage_Chars__ (
   contract_                    IN VARCHAR2,
   warehouse_id_                IN VARCHAR2,
   bay_id_                      IN VARCHAR2,
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
   row_carrying_capacity_       IN NUMBER,
   tier_carrying_capacity_      IN NUMBER,
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
         capability_tab_ := Warehouse_Bin_Capability_API.Get_Operative_Capabilities(contract_, warehouse_id_, bay_id_, NULL, NULL, NULL);
      END IF;
   END IF;
   
   Clear_Row_Tier_Strg_Chars___(contract_,
                                warehouse_id_,
                                bay_id_,
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
                                CASE row_carrying_capacity_       WHEN 1 THEN TRUE ELSE FALSE END,
                                CASE tier_carrying_capacity_      WHEN 1 THEN TRUE ELSE FALSE END,
                                CASE bin_carrying_capacity_       WHEN 1 THEN TRUE ELSE FALSE END,
                                CASE bin_min_temperature_         WHEN 1 THEN TRUE ELSE FALSE END,
                                CASE bin_max_temperature_         WHEN 1 THEN TRUE ELSE FALSE END,
                                CASE bin_min_humidity_            WHEN 1 THEN TRUE ELSE FALSE END,
                                CASE bin_max_humidity_            WHEN 1 THEN TRUE ELSE FALSE END,
                                CASE capabilities_                WHEN 1 THEN TRUE ELSE FALSE END,
                                CASE all_capabilities_            WHEN 1 THEN TRUE ELSE FALSE END,
                                capability_tab_,
                                CASE availability_control_id_     WHEN 1 THEN TRUE ELSE FALSE END);
END Clear_Row_Tier_Storage_Chars__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   newrec_     WAREHOUSE_BAY_TAB%ROWTYPE;
   objid_      WAREHOUSE_BAY.objid%TYPE;
   objversion_ WAREHOUSE_BAY.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('WAREHOUSE_ID', warehouse_id_, attr_);
   Client_SYS.Add_To_Attr('BAY_ID', bay_id_, attr_);
   Client_SYS.Add_To_Attr('ROUTE_ORDER', bay_id_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);    
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Height_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   bin_height_capacity_ WAREHOUSE_BAY_TAB.bin_height_capacity%TYPE;
BEGIN
   bin_height_capacity_ := super(contract_, warehouse_id_, bay_id_);

   IF (bin_height_capacity_ IS NULL) THEN
      bin_height_capacity_ := Warehouse_API.Get_Bin_Height_Capacity(contract_, warehouse_id_);
   END IF;
   RETURN (bin_height_capacity_);
END Get_Bin_Height_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Width_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   bin_width_capacity_ WAREHOUSE_BAY_TAB.bin_width_capacity%TYPE;
BEGIN
   bin_width_capacity_ := super(contract_, warehouse_id_, bay_id_);

   IF (bin_width_capacity_ IS NULL) THEN
      bin_width_capacity_ := Warehouse_API.Get_Bin_Width_Capacity(contract_, warehouse_id_);
   END IF;
   RETURN (bin_width_capacity_);
END Get_Bin_Width_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Dept_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   bin_dept_capacity_ WAREHOUSE_BAY_TAB.bin_dept_capacity%TYPE;
BEGIN
   bin_dept_capacity_ := super(contract_, warehouse_id_, bay_id_);

   IF (bin_dept_capacity_ IS NULL) THEN
      bin_dept_capacity_ := Warehouse_API.Get_Bin_Dept_Capacity(contract_, warehouse_id_);
   END IF;
   RETURN (bin_dept_capacity_);
END Get_Bin_Dept_Capacity;


@UncheckedAccess
FUNCTION Get_Bin_Volume_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_volume_cap_source_db_ VARCHAR2(20);
   dummy_                    WAREHOUSE_BAY_TAB.bin_volume_capacity%TYPE;
BEGIN
   Get_Bin_Vol_Cap_And_Src_Db___(dummy_,
                                 bin_volume_cap_source_db_,
                                 contract_,
                                 warehouse_id_,
                                 bay_id_,
                                 get_capacity_ => FALSE,
                                 get_source_   => TRUE);
   RETURN (bin_volume_cap_source_db_);
END Get_Bin_Volume_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Volume_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Volume_Cap_Source_Db(contract_, warehouse_id_, bay_id_)));
END Get_Bin_Volume_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Volume_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   bin_volume_capacity_ WAREHOUSE_BAY_TAB.bin_volume_capacity%TYPE;
   dummy_               VARCHAR2(20);
BEGIN
   Get_Bin_Vol_Cap_And_Src_Db___(bin_volume_capacity_,
                                 dummy_,
                                 contract_,
                                 warehouse_id_,
                                 bay_id_,
                                 get_capacity_ => TRUE,
                                 get_source_   => FALSE);
   RETURN (bin_volume_capacity_);
END Get_Bin_Volume_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Carrying_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   bin_carrying_capacity_ WAREHOUSE_BAY_TAB.bin_carrying_capacity%TYPE;
BEGIN
   bin_carrying_capacity_ := super(contract_, warehouse_id_, bay_id_);

   IF (bin_carrying_capacity_ IS NULL) THEN
      bin_carrying_capacity_ := Warehouse_API.Get_Bin_Carrying_Capacity(contract_, warehouse_id_);
   END IF;
   RETURN (bin_carrying_capacity_);
END Get_Bin_Carrying_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Bay_Carrying_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   bay_carrying_capacity_ WAREHOUSE_BAY_TAB.bay_carrying_capacity%TYPE;
BEGIN
   bay_carrying_capacity_ := super(contract_, warehouse_id_, bay_id_);
  
   IF (bay_carrying_capacity_ IS NULL) THEN
      bay_carrying_capacity_ := Warehouse_API.Get_Bay_Carrying_Capacity(contract_, warehouse_id_);
   END IF;
   RETURN (bay_carrying_capacity_);
END Get_Bay_Carrying_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Min_Temperature (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   bin_min_temperature_ WAREHOUSE_BAY_TAB.bin_min_temperature%TYPE;
BEGIN
   bin_min_temperature_ := super(contract_, warehouse_id_, bay_id_);
   
   IF (bin_min_temperature_ IS NULL) THEN
      bin_min_temperature_ := Warehouse_API.Get_Bin_Min_Temperature(contract_, warehouse_id_);
   END IF;
   RETURN (bin_min_temperature_);
END Get_Bin_Min_Temperature;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Max_Temperature (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   bin_max_temperature_ WAREHOUSE_BAY_TAB.bin_max_temperature%TYPE;
BEGIN
   bin_max_temperature_ := super(contract_, warehouse_id_, bay_id_);

   IF (bin_max_temperature_ IS NULL) THEN
      bin_max_temperature_ := Warehouse_API.Get_Bin_Max_Temperature(contract_, warehouse_id_);
   END IF;
   RETURN (bin_max_temperature_);
END Get_Bin_Max_Temperature;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Min_Humidity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   bin_min_humidity_ WAREHOUSE_BAY_TAB.bin_min_humidity%TYPE;
BEGIN
   bin_min_humidity_ := super(contract_, warehouse_id_, bay_id_);
  
   IF (bin_min_humidity_ IS NULL) THEN
      bin_min_humidity_ := Warehouse_API.Get_Bin_Min_Humidity(contract_, warehouse_id_);
   END IF;
   RETURN (bin_min_humidity_);
END Get_Bin_Min_Humidity;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Max_Humidity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   bin_max_humidity_ WAREHOUSE_BAY_TAB.bin_max_humidity%TYPE;
BEGIN
   bin_max_humidity_ := super(contract_, warehouse_id_, bay_id_);

   IF (bin_max_humidity_ IS NULL) THEN
      bin_max_humidity_ := Warehouse_API.Get_Bin_Max_Humidity(contract_, warehouse_id_);
   END IF;
   RETURN (bin_max_humidity_);
END Get_Bin_Max_Humidity;


@Override
@UncheckedAccess
FUNCTION Get_Row_Carrying_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   row_carrying_capacity_ WAREHOUSE_BAY_TAB.row_carrying_capacity%TYPE;
BEGIN
   row_carrying_capacity_ := super(contract_, warehouse_id_, bay_id_);

   IF (row_carrying_capacity_ IS NULL) THEN
      row_carrying_capacity_ := Warehouse_API.Get_Row_Carrying_Capacity(contract_, warehouse_id_);
   END IF;
   RETURN (row_carrying_capacity_);
END Get_Row_Carrying_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Tier_Carrying_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   tier_carrying_capacity_ WAREHOUSE_BAY_TAB.tier_carrying_capacity%TYPE;
BEGIN
   tier_carrying_capacity_ := super(contract_, warehouse_id_, bay_id_);

   IF (tier_carrying_capacity_ IS NULL) THEN
      tier_carrying_capacity_ := Warehouse_API.Get_Tier_Carrying_Capacity(contract_, warehouse_id_);
   END IF;
   RETURN (tier_carrying_capacity_);
END Get_Tier_Carrying_Capacity;


@UncheckedAccess
FUNCTION Get_Bin_Height_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Height_Cap_Source_Db(contract_, warehouse_id_, bay_id_)));
END Get_Bin_Height_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Width_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Width_Cap_Source_Db(contract_, warehouse_id_, bay_id_)));
END Get_Bin_Width_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Dept_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Dept_Cap_Source_Db(contract_, warehouse_id_, bay_id_)));
END Get_Bin_Dept_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Carry_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Carry_Cap_Source_Db(contract_, warehouse_id_, bay_id_)));
END Get_Bin_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Min_Temperature_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Min_Temp_Source_Db(contract_, warehouse_id_, bay_id_)));
END Get_Bin_Min_Temperature_Source;


@UncheckedAccess
FUNCTION Get_Bin_Max_Temperature_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Max_Temp_Source_Db(contract_, warehouse_id_, bay_id_)));
END Get_Bin_Max_Temperature_Source;


@UncheckedAccess
FUNCTION Get_Bin_Min_Humidity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Min_Humidity_Source_Db(contract_, warehouse_id_, bay_id_)));
END Get_Bin_Min_Humidity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Max_Humidity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Max_Humidity_Source_Db(contract_, warehouse_id_, bay_id_)));
END Get_Bin_Max_Humidity_Source;


@UncheckedAccess
FUNCTION Get_Bay_Carry_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bay_Carry_Cap_Source_Db(contract_, warehouse_id_, bay_id_)));
END Get_Bay_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Row_Carry_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Row_Carry_Cap_Source_Db(contract_, warehouse_id_, bay_id_)));
END Get_Row_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Tier_Carry_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Tier_Carry_Cap_Source_Db(contract_, warehouse_id_, bay_id_)));
END Get_Tier_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Height_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_height_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.bin_height_capacity IS NULL) THEN
      bin_height_capacity_source_db_ := Warehouse_API.Get_Bin_Height_Cap_Source_Db(contract_, warehouse_id_);
   ELSE
      bin_height_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
   END IF;
   RETURN (bin_height_capacity_source_db_);
END Get_Bin_Height_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Width_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_width_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.bin_width_capacity IS NULL) THEN
      bin_width_capacity_source_db_ := Warehouse_API.Get_Bin_Width_Cap_Source_Db(contract_, warehouse_id_);
   ELSE
      bin_width_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
   END IF;
   RETURN (bin_width_capacity_source_db_);
END Get_Bin_Width_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Dept_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_dept_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.bin_dept_capacity IS NULL) THEN
      bin_dept_capacity_source_db_ := Warehouse_API.Get_Bin_Dept_Cap_Source_Db(contract_, warehouse_id_);
   ELSE
      bin_dept_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
   END IF;
   RETURN (bin_dept_capacity_source_db_);
END Get_Bin_Dept_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Carry_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_carry_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.bin_carrying_capacity IS NULL) THEN
      bin_carry_capacity_source_db_ := Warehouse_API.Get_Bin_Carry_Cap_Source_Db(contract_, warehouse_id_);
   ELSE
      bin_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
   END IF;
   RETURN (bin_carry_capacity_source_db_);
END Get_Bin_Carry_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Min_Temp_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_min_temperature_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.bin_min_temperature IS NULL) THEN
      bin_min_temperature_source_db_ := Warehouse_API.Get_Bin_Min_Temp_Source_Db(contract_, warehouse_id_);
   ELSE
      bin_min_temperature_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
   END IF;
   RETURN (bin_min_temperature_source_db_);
END Get_Bin_Min_Temp_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Max_Temp_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_max_temperature_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.bin_max_temperature IS NULL) THEN
      bin_max_temperature_source_db_ := Warehouse_API.Get_Bin_Max_Temp_Source_Db(contract_, warehouse_id_);
   ELSE
      bin_max_temperature_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
   END IF;
   RETURN (bin_max_temperature_source_db_);
END Get_Bin_Max_Temp_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Min_Humidity_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_min_humidity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.bin_min_humidity IS NULL) THEN
      bin_min_humidity_source_db_ := Warehouse_API.Get_Bin_Min_Humidity_Source_Db(contract_, warehouse_id_);
   ELSE
      bin_min_humidity_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
   END IF;
   RETURN (bin_min_humidity_source_db_);
END Get_Bin_Min_Humidity_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Max_Humidity_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_max_humidity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.bin_max_humidity IS NULL) THEN
      bin_max_humidity_source_db_ := Warehouse_API.Get_Bin_Max_Humidity_Source_Db(contract_, warehouse_id_);
   ELSE
      bin_max_humidity_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
   END IF;
   RETURN (bin_max_humidity_source_db_);
END Get_Bin_Max_Humidity_Source_Db;


@UncheckedAccess
FUNCTION Get_Bay_Carry_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   bay_carry_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.bay_carrying_capacity IS NULL) THEN
      bay_carry_capacity_source_db_ := Warehouse_API.Get_Bay_Carry_Cap_Source_Db(contract_, warehouse_id_);
   ELSE
      bay_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
   END IF;
   RETURN (bay_carry_capacity_source_db_);
END Get_Bay_Carry_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Row_Carry_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   row_carry_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.row_carrying_capacity IS NULL) THEN
      row_carry_capacity_source_db_ := Warehouse_API.Get_Row_Carry_Cap_Source_Db(contract_, warehouse_id_);
   ELSE
      row_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
   END IF;
   RETURN (row_carry_capacity_source_db_);
END Get_Row_Carry_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Tier_Carry_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   tier_carry_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.tier_carrying_capacity IS NULL) THEN
      tier_carry_capacity_source_db_ := Warehouse_API.Get_Tier_Carry_Cap_Source_Db(contract_, warehouse_id_);
   ELSE
      tier_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
   END IF;
   RETURN (tier_carry_capacity_source_db_);
END Get_Tier_Carry_Cap_Source_Db;


@Override
@UncheckedAccess
FUNCTION Get_Receipts_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipts_blocked_ WAREHOUSE_BAY_TAB.receipts_blocked%TYPE;
BEGIN
   receipts_blocked_ := super(contract_, warehouse_id_, bay_id_);

   receipts_blocked_ := Fnd_Boolean_API.Encode(receipts_blocked_);
   IF (receipts_blocked_ = Fnd_Boolean_API.db_false) THEN
      receipts_blocked_ := Warehouse_API.Get_Receipts_Blocked_Db(contract_, warehouse_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(receipts_blocked_);
END Get_Receipts_Blocked;


@Override
@UncheckedAccess
FUNCTION Get_Receipts_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipts_blocked_ WAREHOUSE_BAY_TAB.receipts_blocked%TYPE;
BEGIN
   receipts_blocked_ := super(contract_, warehouse_id_, bay_id_);
 
   IF (receipts_blocked_ = Fnd_Boolean_API.db_false) THEN
      receipts_blocked_ := Warehouse_API.Get_Receipts_Blocked_Db(contract_, warehouse_id_);
   END IF;
   RETURN (receipts_blocked_);
END Get_Receipts_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Receipts_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipts_blocked_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.receipts_blocked = Fnd_Boolean_API.db_false) THEN
      receipts_blocked_source_ := Warehouse_API.Get_Receipts_Blocked_Source(contract_, warehouse_id_);
   ELSE
      receipts_blocked_source_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_BAY);
   END IF;
   RETURN (receipts_blocked_source_);
END Get_Receipts_Blocked_Source;


@Override
@UncheckedAccess
FUNCTION Get_Receipt_To_Occup_Blockd (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipt_to_occupied_blocked_ WAREHOUSE_BAY_TAB.receipt_to_occupied_blocked%TYPE;
BEGIN
   receipt_to_occupied_blocked_ := super(contract_, warehouse_id_, bay_id_);
   receipt_to_occupied_blocked_ := Fnd_Boolean_API.Encode(receipt_to_occupied_blocked_);
   
   IF (receipt_to_occupied_blocked_ = Fnd_Boolean_API.db_false) THEN
      receipt_to_occupied_blocked_ := Warehouse_API.Get_Receipt_To_Occup_Blockd_Db(contract_, warehouse_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(receipt_to_occupied_blocked_);
END Get_Receipt_To_Occup_Blockd;


@Override
@UncheckedAccess
FUNCTION Get_Receipt_To_Occup_Blockd_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipt_to_occupied_blocked_ WAREHOUSE_BAY_TAB.receipt_to_occupied_blocked%TYPE;
BEGIN
   receipt_to_occupied_blocked_ := super(contract_, warehouse_id_, bay_id_);

   IF (receipt_to_occupied_blocked_ = Fnd_Boolean_API.db_false) THEN
      receipt_to_occupied_blocked_ := Warehouse_API.Get_Receipt_To_Occup_Blockd_Db(contract_, warehouse_id_);
   END IF;
   RETURN (receipt_to_occupied_blocked_);
END Get_Receipt_To_Occup_Blockd_Db;


@UncheckedAccess
FUNCTION Get_Receipt_To_Occup_Blkd_Src (
   contract_ IN VARCHAR2,
   warehouse_id_ VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipt_to_occup_blkd_src_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.receipt_to_occupied_blocked = Fnd_Boolean_API.db_false) THEN
      receipt_to_occup_blkd_src_ := Warehouse_API.Get_Receipt_To_Occup_Blkd_Src(contract_, warehouse_id_);
   ELSE
      receipt_to_occup_blkd_src_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_BAY);
   END IF;
   RETURN (receipt_to_occup_blkd_src_);
END Get_Receipt_To_Occup_Blkd_Src;


@Override
@UncheckedAccess
FUNCTION Get_Hide_In_Whse_Navigator (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   hide_in_whse_navigator_ WAREHOUSE_BAY_TAB.hide_in_whse_navigator%TYPE;
BEGIN
   hide_in_whse_navigator_  := super(contract_, warehouse_id_, bay_id_);
   
   hide_in_whse_navigator_  := Fnd_Boolean_API.Encode(hide_in_whse_navigator_);
   IF (hide_in_whse_navigator_ = Fnd_Boolean_API.db_false) THEN
      hide_in_whse_navigator_ := Warehouse_API.Get_Hide_In_Whse_Navigator_Db(contract_, warehouse_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(hide_in_whse_navigator_);
END Get_Hide_In_Whse_Navigator;


@Override
@UncheckedAccess
FUNCTION Get_Hide_In_Whse_Navigator_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   hide_in_whse_navigator_ WAREHOUSE_BAY_TAB.hide_in_whse_navigator%TYPE;
BEGIN
   hide_in_whse_navigator_ := super(contract_, warehouse_id_, bay_id_);

   IF (hide_in_whse_navigator_ = Fnd_Boolean_API.db_false) THEN
      hide_in_whse_navigator_ := Warehouse_API.Get_Hide_In_Whse_Navigator_Db(contract_, warehouse_id_);
   END IF;
   RETURN (hide_in_whse_navigator_);
END Get_Hide_In_Whse_Navigator_Db;


@UncheckedAccess
FUNCTION Is_Hidden_In_Structure_Below (
   contract_           IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2,
   called_from_parent_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   hide_in_whse_navigator_ WAREHOUSE_BAY_TAB.hide_in_whse_navigator%TYPE := Fnd_Boolean_API.db_false;

   CURSOR get_rows IS
      SELECT row_id
        FROM warehouse_bay_row_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_;

   CURSOR get_tiers IS
      SELECT tier_id
        FROM warehouse_bay_tier_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_;
BEGIN
   IF (called_from_parent_ = 'TRUE') THEN
      Update_Cache___(contract_, warehouse_id_, bay_id_);
      hide_in_whse_navigator_ := micro_cache_value_.hide_in_whse_navigator;
   END IF;

   IF (hide_in_whse_navigator_ = Fnd_Boolean_API.db_false) THEN
      FOR row_rec_ IN get_rows LOOP
         hide_in_whse_navigator_ := Warehouse_Bay_Row_API.Is_Hidden_In_Structure_Below(contract_,
                                                                                       warehouse_id_,
                                                                                       bay_id_,
                                                                                       row_rec_.row_id,
                                                                                       'TRUE');
         EXIT WHEN hide_in_whse_navigator_ = 'TRUE';
      END LOOP;

      IF hide_in_whse_navigator_ = 'TRUE' THEN
         RETURN hide_in_whse_navigator_;
      END IF;

      FOR tier_rec_ IN get_tiers LOOP
         hide_in_whse_navigator_ := Warehouse_Bay_Tier_API.Is_Hidden_In_Structure_Below(contract_,
                                                                                        warehouse_id_,
                                                                                        bay_id_,
                                                                                        tier_rec_.tier_id,
                                                                                        'TRUE');
         EXIT WHEN hide_in_whse_navigator_ = 'TRUE';
      END LOOP;
   END IF;

   RETURN hide_in_whse_navigator_;
END Is_Hidden_In_Structure_Below;


PROCEDURE Check_Bin_Temperature_Range (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 )
IS
   bin_min_temperature_ WAREHOUSE_BAY_TAB.bin_min_temperature%TYPE;
   bin_max_temperature_ WAREHOUSE_BAY_TAB.bin_max_temperature%TYPE;

   CURSOR get_rows IS
      SELECT row_id
        FROM warehouse_bay_row_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_
         AND ((bin_min_temperature IS     NULL AND bin_max_temperature IS NOT NULL) OR
              (bin_min_temperature IS NOT NULL AND bin_max_temperature IS     NULL));

   CURSOR get_tiers IS
      SELECT tier_id
        FROM warehouse_bay_tier_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_
         AND ((bin_min_temperature IS     NULL AND bin_max_temperature IS NOT NULL) OR
              (bin_min_temperature IS NOT NULL AND bin_max_temperature IS     NULL));

   CURSOR get_bins IS
      SELECT tier_id, row_id, bin_id
        FROM warehouse_bay_bin_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_
         AND ((min_temperature IS     NULL AND max_temperature IS NOT NULL) OR
              (min_temperature IS NOT NULL AND max_temperature IS     NULL));
BEGIN

   bin_min_temperature_ := Get_Bin_Min_Temperature(contract_, warehouse_id_, bay_id_);
   bin_max_temperature_ := Get_Bin_Max_Temperature(contract_, warehouse_id_, bay_id_);

   IF (Part_Catalog_Invent_Attrib_API.Incorrect_Temperature_Range(bin_min_temperature_, bin_max_temperature_)) THEN
      Error_SYS.Record_General(lu_name_, 'TEMPRANGE: Incorrect Operative Temperature Range for Bay :P1 in Warehouse :P2 on Site :P3.', bay_id_, warehouse_id_, contract_);
   END IF;

   FOR row_rec_ IN get_rows LOOP
      Warehouse_Bay_Row_API.Check_Bin_Temperature_Range(contract_,
                                                        warehouse_id_,
                                                        bay_id_,
                                                        row_rec_.row_id,
                                                        check_all_bins_ => FALSE);
   END LOOP;

   FOR tier_rec_ IN get_tiers LOOP
      Warehouse_Bay_Tier_API.Check_Bin_Temperature_Range(contract_,
                                                         warehouse_id_,
                                                         bay_id_,
                                                         tier_rec_.tier_id,
                                                         check_all_bins_ => FALSE);
   END LOOP;

   FOR bin_rec_ IN get_bins LOOP
      Warehouse_Bay_Bin_API.Check_Temperature_Range(contract_,
                                                    warehouse_id_,
                                                    bay_id_,
                                                    bin_rec_.tier_id,
                                                    bin_rec_.row_id,
                                                    bin_rec_.bin_id);
   END LOOP;
END Check_Bin_Temperature_Range;


PROCEDURE Check_Bin_Humidity_Range (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 )
IS
   bin_min_humidity_ WAREHOUSE_BAY_TAB.bin_min_humidity%TYPE;
   bin_max_humidity_ WAREHOUSE_BAY_TAB.bin_max_humidity%TYPE;

   CURSOR get_rows IS
      SELECT row_id
        FROM warehouse_bay_row_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_
         AND ((bin_min_humidity IS     NULL AND bin_max_humidity IS NOT NULL) OR
              (bin_min_humidity IS NOT NULL AND bin_max_humidity IS     NULL));

   CURSOR get_tiers IS
      SELECT tier_id
        FROM warehouse_bay_tier_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_
         AND ((bin_min_humidity IS     NULL AND bin_max_humidity IS NOT NULL) OR
              (bin_min_humidity IS NOT NULL AND bin_max_humidity IS     NULL));

   CURSOR get_bins IS
      SELECT tier_id, row_id, bin_id
        FROM warehouse_bay_bin_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_
         AND ((min_humidity IS     NULL AND max_humidity IS NOT NULL) OR
              (min_humidity IS NOT NULL AND max_humidity IS     NULL));
BEGIN

   bin_min_humidity_ := Get_Bin_Min_Humidity(contract_, warehouse_id_, bay_id_);
   bin_max_humidity_ := Get_Bin_Max_Humidity(contract_, warehouse_id_, bay_id_);

   IF (Part_Catalog_Invent_Attrib_API.Incorrect_Humidity_Range(bin_min_humidity_, bin_max_humidity_)) THEN
      Error_SYS.Record_General(lu_name_, 'HUMRANGE: Incorrect Operative Humidity Range for Bay :P1 in Warehouse :P2 on Site :P3.', bay_id_, warehouse_id_, contract_);
   END IF;

   FOR row_rec_ IN get_rows LOOP
      Warehouse_Bay_Row_API.Check_Bin_Humidity_Range(contract_,
                                                     warehouse_id_,
                                                     bay_id_,
                                                     row_rec_.row_id,
                                                     check_all_bins_ => FALSE);
   END LOOP;

   FOR tier_rec_ IN get_tiers LOOP
      Warehouse_Bay_Tier_API.Check_Bin_Humidity_Range(contract_,
                                                      warehouse_id_,
                                                      bay_id_,
                                                      tier_rec_.tier_id,
                                                      check_all_bins_ => FALSE);
   END LOOP;

   FOR bin_rec_ IN get_bins LOOP
      Warehouse_Bay_Bin_API.Check_Humidity_Range(contract_,
                                                 warehouse_id_,
                                                 bay_id_,
                                                 bin_rec_.tier_id,
                                                 bin_rec_.row_id,
                                                 bin_rec_.bin_id);
   END LOOP;
END Check_Bin_Humidity_Range;


@UncheckedAccess
FUNCTION Check_Exist (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_, warehouse_id_, bay_id_);
END Check_Exist;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Part_Number_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_part_number_blocked_ WAREHOUSE_BAY_TAB.mix_of_part_number_blocked%TYPE;
BEGIN
   mix_of_part_number_blocked_ := super(contract_, warehouse_id_, bay_id_);

   mix_of_part_number_blocked_ := Fnd_Boolean_API.Encode(mix_of_part_number_blocked_);
   IF (mix_of_part_number_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_part_number_blocked_ := Warehouse_API.Get_Mix_Of_Parts_Blocked_Db(contract_, warehouse_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(mix_of_part_number_blocked_);
END Get_Mix_Of_Part_Number_Blocked;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Parts_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_part_number_blocked_ WAREHOUSE_BAY_TAB.mix_of_part_number_blocked%TYPE;
BEGIN
   mix_of_part_number_blocked_ := super(contract_, warehouse_id_, bay_id_);

   IF (mix_of_part_number_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_part_number_blocked_ := Warehouse_API.Get_Mix_Of_Parts_Blocked_Db(contract_, warehouse_id_);
   END IF;
   RETURN (mix_of_part_number_blocked_);
END Get_Mix_Of_Parts_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Mix_Of_Part_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_part_blocked_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.mix_of_part_number_blocked = Fnd_Boolean_API.db_false) THEN
      mix_of_part_blocked_source_ := Warehouse_API.Get_Mix_Of_Part_Blocked_Source(contract_, warehouse_id_);
   ELSE
      mix_of_part_blocked_source_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_BAY);
   END IF;
   RETURN (mix_of_part_blocked_source_);
END Get_Mix_Of_Part_Blocked_Source;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Codes_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_cond_codes_blocked_ WAREHOUSE_BAY_TAB.mix_of_cond_codes_blocked%TYPE;
BEGIN
   mix_of_cond_codes_blocked_ := super(contract_, warehouse_id_, bay_id_);
   
   mix_of_cond_codes_blocked_ := Fnd_Boolean_API.Encode(mix_of_cond_codes_blocked_);
   IF (mix_of_cond_codes_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_cond_codes_blocked_ := Warehouse_API.Get_Mix_Of_Cond_Blocked_Db(contract_, warehouse_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(mix_of_cond_codes_blocked_);
END Get_Mix_Of_Cond_Codes_Blocked;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_cond_codes_blocked_ WAREHOUSE_BAY_TAB.mix_of_cond_codes_blocked%TYPE;
BEGIN
   mix_of_cond_codes_blocked_ := super(contract_, warehouse_id_, bay_id_);

   IF (mix_of_cond_codes_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_cond_codes_blocked_ := Warehouse_API.Get_Mix_Of_Cond_Blocked_Db(contract_, warehouse_id_);
   END IF;
   RETURN (mix_of_cond_codes_blocked_);
END Get_Mix_Of_Cond_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_cond_blocked_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.mix_of_cond_codes_blocked = Fnd_Boolean_API.db_false) THEN
      mix_of_cond_blocked_source_ := Warehouse_API.Get_Mix_Of_Cond_Blocked_Source(contract_, warehouse_id_);
   ELSE
      mix_of_cond_blocked_source_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_BAY);
   END IF;
   RETURN (mix_of_cond_blocked_source_);
END Get_Mix_Of_Cond_Blocked_Source;

@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Lot_Batch_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_lot_batch_no_blocked_ WAREHOUSE_BAY_TAB.mix_of_lot_batch_no_blocked%TYPE;
BEGIN
   mix_of_lot_batch_no_blocked_ := super(contract_, warehouse_id_, bay_id_);
   
   mix_of_lot_batch_no_blocked_ := Fnd_Boolean_API.Encode(mix_of_lot_batch_no_blocked_);
   IF (mix_of_lot_batch_no_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_lot_batch_no_blocked_ := Warehouse_API.Get_Mix_Of_Lot_Blocked_Db(contract_, warehouse_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(mix_of_lot_batch_no_blocked_);
END Get_Mix_Of_Lot_Batch_Blocked;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Lot_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_lot_batch_no_blocked_ WAREHOUSE_BAY_TAB.mix_of_lot_batch_no_blocked%TYPE;
BEGIN
   mix_of_lot_batch_no_blocked_ := super(contract_, warehouse_id_, bay_id_);

   IF (mix_of_lot_batch_no_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_lot_batch_no_blocked_ := Warehouse_API.Get_Mix_Of_Lot_Blocked_Db(contract_, warehouse_id_);
   END IF;
   RETURN (mix_of_lot_batch_no_blocked_);
END Get_Mix_Of_Lot_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Mix_Of_Lot_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_lot_blocked_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.mix_of_lot_batch_no_blocked = Fnd_Boolean_API.db_false) THEN
      mix_of_lot_blocked_source_ := Warehouse_API.Get_Mix_Of_Lot_Blocked_Source(contract_, warehouse_id_);
   ELSE
      mix_of_lot_blocked_source_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_BAY);
   END IF;
   RETURN (mix_of_lot_blocked_source_);
END Get_Mix_Of_Lot_Blocked_Source;


@Override
@UncheckedAccess
FUNCTION Get_Exclude_Storage_Req_Val (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   exclude_storage_req_val_ WAREHOUSE_BAY_TAB.exclude_storage_req_val%TYPE;
BEGIN
   exclude_storage_req_val_ := super(contract_, warehouse_id_, bay_id_);
  
   exclude_storage_req_val_ := Fnd_Boolean_API.Encode(exclude_storage_req_val_);
   IF (exclude_storage_req_val_ = Fnd_Boolean_API.db_false) THEN
      exclude_storage_req_val_ := Warehouse_API.Get_Exclude_Storage_Req_Val_Db(contract_, warehouse_id_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(exclude_storage_req_val_);
END Get_Exclude_Storage_Req_Val;


@Override
@UncheckedAccess
FUNCTION Get_Exclude_Storage_Req_Val_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   exclude_storage_req_val_ WAREHOUSE_BAY_TAB.exclude_storage_req_val%TYPE;
BEGIN
   exclude_storage_req_val_ := super(contract_, warehouse_id_, bay_id_);

   IF (exclude_storage_req_val_ = Fnd_Boolean_API.db_false) THEN
      exclude_storage_req_val_ := Warehouse_API.Get_Exclude_Storage_Req_Val_Db(contract_, warehouse_id_);
   END IF;
   RETURN (exclude_storage_req_val_);
END Get_Exclude_Storage_Req_Val_Db;


@UncheckedAccess
FUNCTION Get_Excl_Storage_Req_Val_Src (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   exclude_storage_req_val_src_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.exclude_storage_req_val = Fnd_Boolean_API.db_false) THEN
      exclude_storage_req_val_src_ := Warehouse_API.Get_Excl_Storage_Req_Val_Src(contract_, warehouse_id_);
   ELSE
      exclude_storage_req_val_src_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_BAY);
   END IF;
   RETURN (exclude_storage_req_val_src_);
END Get_Excl_Storage_Req_Val_Src;


FUNCTION Get_Free_Carrying_Capacity (
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
   free_carrying_capacity_     NUMBER := Inventory_Putaway_Manager_API.positive_infinity_;
   total_carrying_capacity_    NUMBER;
   consumed_carrying_capacity_ NUMBER;
BEGIN
   total_carrying_capacity_ := NVL(Get_Bay_Carrying_Capacity(contract_,
                                                             warehouse_id_,
                                                             bay_id_), Inventory_Putaway_Manager_API.positive_infinity_);

   IF (total_carrying_capacity_ < Inventory_Putaway_Manager_API.positive_infinity_) THEN
      consumed_carrying_capacity_ := Inventory_Part_In_Stock_API.Get_Consumed_Carrying_Capacity(contract_                     => contract_,
                                                                                                warehouse_id_                 => warehouse_id_,
                                                                                                bay_id_                       => bay_id_,
                                                                                                ignore_this_handling_unit_id_ => ignore_this_handling_unit_id_);
      free_carrying_capacity_ := total_carrying_capacity_ - consumed_carrying_capacity_;
   END IF;
   RETURN (free_carrying_capacity_);
END Get_Free_Carrying_Capacity; 

@Override
@UncheckedAccess
FUNCTION Get_Availability_Control_Id (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   availability_control_id_ WAREHOUSE_BAY_TAB.availability_control_id%TYPE;
BEGIN
   availability_control_id_ := super(contract_, warehouse_id_, bay_id_);
   
   IF (availability_control_id_ IS NULL) THEN
      availability_control_id_ := Warehouse_API.Get_Availability_Control_Id(contract_, warehouse_id_);
   END IF;
   
   RETURN availability_control_id_;
END Get_Availability_Control_Id;

@UncheckedAccess
FUNCTION Get_Avail_Control_Id_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Avail_Control_Id_Source_Db(contract_, warehouse_id_, bay_id_)));
END Get_Avail_Control_Id_Source;

@UncheckedAccess
FUNCTION Get_Avail_Control_Id_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   avail_control_id_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_);
   IF (micro_cache_value_.availability_control_id IS NULL) THEN
      avail_control_id_source_db_ := Warehouse_API.Get_Avail_Control_Id_Source_Db(contract_, warehouse_id_);
   ELSE
      avail_control_id_source_db_ := Warehouse_Structure_Level_API.DB_BAY;
   END IF;
   RETURN avail_control_id_source_db_;
END Get_Avail_Control_Id_Source_Db;


PROCEDURE Lock_By_Keys_Wait (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 )
IS
   dummy_ WAREHOUSE_BAY_TAB%ROWTYPE;
BEGIN

   dummy_ := Lock_By_Keys___(contract_, warehouse_id_, bay_id_);

END Lock_By_Keys_Wait;


FUNCTION Get_Base_Bin_Volume_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR get_volume_ IS
   SELECT bin_volume_capacity
     FROM warehouse_bay
    WHERE contract = contract_
      AND warehouse_id = warehouse_id_
      AND bay_id = bay_id_;
BEGIN
   OPEN get_volume_;
   FETCH get_volume_ INTO dummy_;
   CLOSE get_volume_;
   RETURN dummy_;
END Get_Base_Bin_Volume_Capacity;


@UncheckedAccess
FUNCTION Get_Default_Bay_Id RETURN VARCHAR2
IS
BEGIN
   RETURN default_bay_id_;
END Get_Default_Bay_Id;