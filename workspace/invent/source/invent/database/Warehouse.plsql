-----------------------------------------------------------------------------
--
--  Logical unit: Warehouse
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211216  SbalLK  SC21R2-2833, Modified Is_Remote() method to use warehouse micro cache through Get_Remote_Warehouse_Db().
--  210924  Asawlk  SC21R2-2770, Modified Get_Keys_By_Global_Id___ to be public Get_Keys_By_Global_Id(). Also modified the usages.
--  210831  SBalLK  SC21R2-2442, Replaced Client_SYS.Add_To_Attr by assigning values directly to newrec_ throughout the file.
--  210804  SBalLK  SC21R2-1426, Added Remove() method to remove warehouse and added AUTO_CREATED attribute to track automatically created
--  210804          warehouses through the WarehouseManager.
--  210614  SBalLK  SC21R2-1204, Added Create_New_Warehouse_Id___() and modified New() method to create remote warehouse automatically for service tasks.
--  201013  UdGnlk  SCZ-11843, Modified Is_Hidden_In_Structure_Below() by adding a NVL to hide_in_whse_navigator_, inorder to return a value than NULL.     
--  200601  RoJalk  SC2020R1-1391, Modified Check_Insert___ and added a validation that prevents creating new records with '*' for warehouse id.
--  200219  MeAblk  SCSPRING20-1798, Added overloaded method Check_Supply_Control() to be used in shipment order demand/supply views.
--  200219          Modified Get_Keys_By_Global_Id___() to avoid oracle error when fetching keys for a non existing global warehouse id.
--  200128  Aabalk  SCSPRING20-1687, Added function Get_Warehouse_Id_By_Global_Id() to fetch the warehouse ID using the global warehouse id.
--  191016  KhVeSE  SCSPRING20-538, Added method Get_Keys_By_Global_Id___(), Get() and Check_Exist() based on unique attribute global_warehous_id.
--  191014  KhVeSE  SCSPRING20-538,SCSPRING20-1080,  Added an override of method Insert___ and Raise_Constraint_Violated___ and updated Check_Insert___ 
--  191014          method to check string validity for GLOBAL_WAREHOUSE_ID.
--  190103  KoDelk  SCUXXW4-15164, Added new Function Get_Base_Bin_Volume_Capacity()
--  151120  JeLise  LIM-4369, Removed all code related to pallet_drop_off_location_no and renamed nopall_drop_off_location_no.
--  151020  JeLise  LIM-3893, Removed check on pallet related location types in Validate_Drop_Off_Loc_Type___.
--  140911  Erlise  PRSC-2475, Put to empty. Added attribute receipt_to_occupied_blocked.
--  140911          Added methods Get_Receipt_To_Occup_Blockd, Get_Receipt_To_Occup_Blockd_Db and Get_Receipt_To_Occup_Blkd_Src.
--  140512  MAHPLK  PBSC-9173, Modified Check_Insert___  and Check_Update___ method to validate the route_order for valid string.
--  140220  AwWelk  PBSC-7298, Removed the overtake in Get_Bin_Volume_Capacity().
--  140219  MaEelk  Removed all codes related to Delivery Address and moved them to WarehousePurchInfo in PURCH.
--  140210  MeAblk  Added new method Is_Remote.
--  131115  JeLise  Added new lov WAREHOUSE_LOV5.
--  131114  Matkse  Added new LOV REMOTE_WAREHOUSE.
--  131106  MaEelk  Added Check_Supply_Control to get the part supply control value of the part availability control id connected to the warehoure
--  131017  Matkse  Modified Copy_Remote_Whse_Users___ by adding conditional compilation for call to User_Warehouse_Connection_API.Copy__ located in PCM.
--  131017  Matkse  Added attributes TRANSPORT_FROM_WHSE_LEVEL and TRANSPORT_TO_WHSE_LEVEL.
--  131003  DaZase  Added derived attributes party_type, party_type_id and party_type_address_id.
--  121115  MaEelk  Made a call to Storage_Zone_Detail_API.Remove_Warehouse from Delete___ that would remove the relevent record when remind a warehouse 
--  121106  MAHPLK  Added Route_Order.
--  120904  JeLise  Changed from calling Part_Catalog_API methods to call the same methods in Part_Catalog_Invent_Attrib_API.
--  131003          NOTE: that these derived attribues in server and client to dont exactly match the model due to constrictions. 
--  131003          Added private functions Get_Party_Type__, Get_Party_Type_Id__ and Get_Party_Type_Address_Id__ for new derived attributes. 
--  131003          Added manual unpacks for these derived attributes, changes in method Validate_Delivery_Address___.
--  131003  Matkse  Added methods Copy_Remote_Whse_Users___ and Copy_Remote_Whse_Assortment___. Modified Copy___ by adding calls to aforementioned methods.
--  131003          Modified Get_Attr___ by adding AUTO_REFILL_PUTAWAY_ZONES_DB, PUTAWAY_DESTINATION_DB to attribute string. And also,
--  131003          if warehouse is remote, adding APPEAR_AS_PUTAWAY_ZONE_DB, PUTAWAY_MAX_BINS_PER_PART,PUTAWAY_ZONE_RANKING along with address information.
--  130618  RiLase  Added attributes and get methods for PALLET_DROP_OFF_LOCATION_NO and NOPALL_DROP_OFF_LOCATION_NO.
--  130910  RILASE  Added attributes PERSON_ID, PERSON_ADDRESS_ID, COMPANY, COMPANY_ADDRESS_ID, CUSTOMER_ID and CUSTOMER_ADDRESS_ID.
--  130910          Added method Validate_Delivery_Address___.
--  130826  Matkse  Added new attribute putaway_destination.
--  130826  Matkse  Added new attribute auto_refill.
--  130823  DaZase  Added WAREHOUSE_LOV3 for used from new PCM-client.
--  130823  Matkse  Removed obsolete attribute only_scheduled_task_refill.
--  130821  Matkse  Renamed ranking and max_bins_per_part to putaway_zone_ranking and putaway_max_bins_per_part.
--  130821          Added new methods Validate_Putaway_Ranking___ and Validate_Putaway_Max_Bins___.
--  130807  DaZase  Added method Connect_Assortment_To_Remotes.
--  130808  Matkse  Added appear_as_putaway_zone, ranking and max_bins_per_part.
--  130712  Matkse  Modified Prepare_Insert___ and Unpack_Check_Insert___ to give only_scheduled_task_refill default value.
--  130703  Matkse  Modified Validate_Drop_Off_Loop___ to handle a warehouse location having a drop off in itself.
--  130701  Matkse  Added method Validate_Drop_Off_Loop___.
--  130625  Matkse  Modified Get_Attr___ to handle availability_control_id.
--  130620  Matkse  Modified Clear_Bay_Storage_Chars__ and Clear_Storage_Chars__ to accept flag for availability_control_id and drop-off bins.
--  130618  Matkse  Added UPPERCASE attribute to drop off columns
--  130529  RiLase  Added methods Validate_Drop_Off_Loc_Type___ and Validate_Drop_Off_Location___.
--  130521  Erlise  Added availability_control_id.
--  130418  DaZase  Added remote_warehouse.
--  120829  Matkse  Added check for cubic capacity of bin_volume in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  120829          Added new implementation method, Get_Bin_Vol_Cap_And_Src_Db___, used for determine source and retrieval of volume capacity.
--  120829          This new method is being called from Get_Volume_Capacity and Get_Bin_Volume_Cap_Source_Db. 
--  120821  Matkse  Modified Get_Bin_Volume_Capacity and Get_Bin_Volume_Capacity_Source by fixing a small bug leading to changes of height not to be
--                  taken into consideration when calculating volume capacity and source.
--  120605  Matkse  Modified Delete___ by adding calls to Site_Putaway_Zone_API.Remove_Warehouse and Invent_Part_Putaway_Zone_API.Remove_Warehouse
--  120604  Matkse  Added bin_volume_capacity.
--  120417  MaEelk  Modified Get_Bin_Volume_Capacity to return LEAST(bin_volume_capacity_,999999999999999999999999999) to avoid client errors
--  120417          when the return vlue exceeds 29 digits.
--  120321  MaEelk  Removed last parameter TRUE from General_SYS.Init method in Check_Bin_Temperature_Range and Check_Bin_Humidity_Range.
--  120312  Matke   Added view WAREHOUSE_LOV2
--  120309  LEPESE  Added methods FUNCTION Get_Bin_Height_Cap_Source_Db, Get_Bin_Width_Cap_Source_Db, Get_Bin_Dept_Cap_Source_Db
--  120309          Get_Bin_Carry_Cap_Source_Db, Get_Bin_Min_Temp_Source_Db, Get_Bin_Max_Temp_Source_Db, Get_Bin_Min_Humidity_Source_Db
--  120309          Get_Bin_Max_Humidity_Source_Db, Get_Bay_Carry_Cap_Source_Db, Get_Row_Carry_Cap_Source_Db, Get_Tier_Carry_Cap_Source_Db
--  120306  LEPESE  Added method Copy_Capabilities___.
--  111121  JeLise  Added methods Clear_Storage_Chars__, Clear_Bay_Storage_Chars__ and Clear_Bay_Storage_Chars__.
--  111103  JeLise  Added exclude_storage_req_val.
--  110916  DaZase  Added more parameters to Copy__.
--  110905  DaZase  Changed Get_Bin_Volume_Capacity so it will only return value if we have a valid volume UOM.
--  110706  MaEelk  added user allowed site filter to WAREHOUSE and WAREHOUSE_LOV.
--  110405  DaZase  Added mix_of_lot_batch_no_blocked.
--  110208  DaZase  Added Lock_By_Keys_Wait.
--  101013  JeLise  Added mix_of_part_number_blocked and mix_of_cond_codes_blocked.
--  100927  DaZase  Added checks for temperature/humidity in Update___.
--  100922  JeLise  Changed from calling Incorrect_Temperature_Range and Incorrect_Humidity_Range in 
--  100922          Site_Invent_Info_API to same methods in Part_Catalog_API.
--  100830  DaZase  Added Get_Bin_Volume_Capacity.
--  100824  JeLise  Changed from calling Warehouse_Bay_Bin_API.Check_Humidity to Part_Catalog_API.Check_Humidity.
--  100406  Dazase  Added hide_in_whse_navigator.
--  100115  DaZase  Added methods Get_Receipts_Blocked, Get_Receipts_Blocked_Db and Get_Receipts_Blocked_Source.
--  100114  RILASE  Added receipts_blocked.
--  091106  NaLrlk  Added view WAREHOUSE_LOV.
--  091027  LEPESE  Added calls from Unpack_Check_Insert___ and Unpack_Check_Update___
--  091027          to methods Warehouse_Bay_Bin_API.Check_Humidity,
--  091027          Warehouse_Bay_Bin_API.Check_Carrying_Capacity and
--  091027          Warehouse_Bay_Bin_API.Check_Cubic_Capacity where checks are centralized.
--  091021  LEPESE  Renamed Check_Humidity_Interval and Check_Temperature_Interval into
--  091021          Check_Humidity_Range and Check_Temperature_Range.
--  091021          Modifications in Check_Humidity_Range and Check_Temperature_Range
--  091021          to use methods Site_Invent_Info_API.Incorrect_Temperature_Range and
--  091021          Site_Invent_Info_API.Incorrect_Humidity_Range to validate the ranges.
--  091019  NaLrlk  Modified method Copy_Bays__ to check from_contract is user allowed site.
--  090907  ShKolk  Added methods New and Check_Exist.
--  090904  LEPESE  Added methods Check_Bin_Temperature_Interval and Check_Bin_Humidity_Interval.
--  090904          Added calls to these methods from Insert___ and Update___.
--  090825  LEPESE  Added methods Get_Attr___, Copy__ and Copy_Bays__.
--  090819  NaLrlk  Added max weigth for bay, row and tier columns.
--  090707  NaLrlk  Added warehouse bin characteristics public columns and respective source functions.
--  090707          Implemented Micro Cache. Added new mehods Invalidate_Cache___ and Update_Cache___.
--  090427  KiSalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

DUPLICATE_GLOBAL_WAREHOUSE_ID EXCEPTION;
PRAGMA                        EXCEPTION_INIT(DUPLICATE_GLOBAL_WAREHOUSE_ID,-20999);   

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


PROCEDURE Get_Bin_Vol_Cap_And_Src_Db___ (
   bin_volume_capacity_           OUT warehouse_tab.bin_volume_capacity%TYPE,
   bin_volume_capacity_source_db_ OUT VARCHAR2,
   contract_                      IN  warehouse_tab.contract%TYPE,
   warehouse_id_                  IN  warehouse_tab.warehouse_id%TYPE,
   get_capacity_                  IN  BOOLEAN,
   get_source_                    IN  BOOLEAN )
IS
   bin_height_capacity_ warehouse_tab.bin_height_capacity%TYPE;
   bin_width_capacity_  warehouse_tab.bin_width_capacity%TYPE;
   bin_dept_capacity_   warehouse_tab.bin_dept_capacity%TYPE;
BEGIN
   IF (Site_Invent_Info_API.Get_Volume_Uom(contract_) IS NOT NULL) THEN
      Update_Cache___(contract_, warehouse_id_);
      IF ( micro_cache_value_.bin_volume_capacity IS NULL) THEN
         IF ((micro_cache_value_.bin_width_capacity IS NULL) AND
            (micro_cache_value_.bin_height_capacity IS NULL) AND
            (micro_cache_value_.bin_dept_capacity IS NULL)) THEN
            IF (get_capacity_) THEN
               bin_volume_capacity_ := Site_Invent_Info_API.Get_Bin_Volume_Capacity(contract_);
            END IF;
            IF (get_source_) THEN
               bin_volume_capacity_source_db_ := Site_Invent_Info_API.Get_Bin_Volume_Cap_Source_Db(contract_);
            END IF;
         ELSE
            bin_height_capacity_ := Get_Bin_Height_Capacity(contract_, warehouse_id_);
            IF (bin_height_capacity_ IS NOT NULL) THEN
               bin_width_capacity_  := Get_bin_Width_Capacity(contract_, warehouse_id_);
               IF (bin_width_capacity_ IS NOT NULL) THEN
                  bin_dept_capacity_   := Get_Bin_Dept_Capacity(contract_, warehouse_id_);
                  IF (bin_dept_capacity_ IS NOT NULL) THEN
                     bin_volume_capacity_ := bin_height_capacity_ * bin_width_capacity_ * bin_dept_capacity_;
                     bin_volume_capacity_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
                  END IF;
               END IF;
            END IF;
         END IF;
      ELSE
         bin_volume_capacity_ := micro_cache_value_.bin_volume_capacity;
         bin_volume_capacity_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
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
   Client_SYS.Add_To_Attr('REMOTE_WAREHOUSE_DB', Fnd_Boolean_API.db_false, attr_);
   Client_SYS.Add_To_Attr('APPEAR_AS_PUTAWAY_ZONE_DB', Fnd_Boolean_API.db_false, attr_);
   Client_SYS.Add_To_Attr('AUTO_REFILL_PUTAWAY_ZONES_DB', Fnd_Boolean_API.DB_TRUE, attr_);
   Client_SYS.Add_To_Attr('PUTAWAY_DESTINATION_DB', Fnd_Boolean_API.DB_TRUE, attr_);
   Client_SYS.Add_To_Attr('AUTO_CREATED_DB', Fnd_Boolean_API.DB_FALSE, attr_);
END Prepare_Insert___;

@UncheckedAccess
FUNCTION Get_Warehouse_Id_By_Global_Id (
   global_warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_            warehouse_tab.contract%TYPE;
   warehouse_id_        warehouse_tab.warehouse_id%TYPE;
BEGIN
   Get_Keys_By_Global_Id(contract_, warehouse_id_, global_warehouse_id_);
   RETURN warehouse_id_;
END Get_Warehouse_Id_By_Global_Id;


@Override
PROCEDURE Raise_Constraint_Violated___ (
   rec_ IN warehouse_tab%ROWTYPE,
   constraint_ IN VARCHAR2 )
IS
BEGIN
   IF (constraint_ = 'WAREHOUSE_UX1') THEN  
      RAISE DUPLICATE_GLOBAL_WAREHOUSE_ID;
   ELSE
      super(rec_, constraint_);
   END IF;
END Raise_Constraint_Violated___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT NOCOPY warehouse_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2 )
IS
   separator_                    VARCHAR2(50) := '-';
   global_whse_id_is_default_    BOOLEAN := FALSE;
   default_global_warehouse_id_  VARCHAR2(50) := newrec_.contract||separator_||UPPER(newrec_.warehouse_id);
BEGIN
   newrec_.global_warehouse_id := NVL(UPPER(newrec_.global_warehouse_id), default_global_warehouse_id_);
   
   IF (newrec_.global_warehouse_id = default_global_warehouse_id_) THEN
      global_whse_id_is_default_ := TRUE;
   END IF;
   LOOP
      BEGIN
         super(objid_, objversion_, newrec_, attr_);
         EXIT;
      EXCEPTION
         WHEN DUPLICATE_GLOBAL_WAREHOUSE_ID THEN
            IF (global_whse_id_is_default_) THEN
                  separator_ := separator_ || '-';
                  newrec_.global_warehouse_id := newrec_.contract||separator_||UPPER(newrec_.warehouse_id);
            ELSE
               Error_SYS.Record_Exist(lu_name_, 'GLWHIDNU: Global Warehouse ID :P1 is already used.', newrec_.global_warehouse_id);
            END IF;
      END;
      END LOOP;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     warehouse_tab%ROWTYPE,
   newrec_     IN OUT warehouse_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   number_null_ NUMBER := -9999999;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   IF ((NVL(newrec_.bin_min_temperature, number_null_) != NVL(oldrec_.bin_min_temperature, number_null_)) OR
      (NVL(newrec_.bin_max_temperature, number_null_) != NVL(oldrec_.bin_max_temperature, number_null_))) THEN
      Check_Bin_Temperature_Range(newrec_.contract,newrec_.warehouse_id);
   END IF;

   IF ((NVL(newrec_.bin_min_humidity, number_null_) != NVL(oldrec_.bin_min_humidity, number_null_)) OR
       (NVL(newrec_.bin_max_humidity, number_null_) != NVL(oldrec_.bin_max_humidity, number_null_))) THEN
      Check_Bin_Humidity_Range(newrec_.contract,newrec_.warehouse_id);
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
   remrec_ IN warehouse_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Storage_Zone_Detail_API.Remove_Warehouse(remrec_.contract, remrec_.warehouse_id);
END Delete___;


FUNCTION Clean_Non_Copy_Attributes___(
   lu_rec_                    IN warehouse_tab%ROWTYPE,
   include_cubic_capacity_    IN BOOLEAN,
   include_carrying_capacity_ IN BOOLEAN,
   include_temperatures_      IN BOOLEAN ) RETURN warehouse_tab%ROWTYPE
IS
   newrec_ warehouse_tab%ROWTYPE := lu_rec_;
BEGIN
   IF (NOT include_cubic_capacity_) THEN
      newrec_.bin_height_capacity := NULL;
      newrec_.bin_width_capacity  := NULL;
      newrec_.bin_dept_capacity   := NULL;
      newrec_.bin_volume_capacity := NULL;
   END IF;
   IF (NOT include_carrying_capacity_) THEN
      newrec_.bin_carrying_capacity  := NULL;
      newrec_.bay_carrying_capacity  := NULL;
      newrec_.row_carrying_capacity  := NULL;
      newrec_.tier_carrying_capacity := NULL;
   END IF;
   IF (NOT include_temperatures_) THEN
      newrec_.bin_min_temperature := NULL;
      newrec_.bin_max_temperature := NULL;
   END IF;
   
   IF (newrec_.remote_warehouse = Fnd_Boolean_API.DB_FALSE) THEN
      newrec_.appear_as_putaway_zone := NULL;
   END IF;
   IF(newrec_.appear_as_putaway_zone IS NULL OR newrec_.appear_as_putaway_zone = Fnd_Boolean_API.DB_FALSE) THEN
      newrec_.putaway_max_bins_per_part := NULL;
      newrec_.putaway_zone_ranking      := NULL;
   END IF;
END Clean_Non_Copy_Attributes___;


PROCEDURE Clear_Bay_Storage_Chars___ (
   contract_                      IN VARCHAR2,
   warehouse_id_                  IN VARCHAR2,
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
   CURSOR get_bays IS
      SELECT bay_id
      FROM warehouse_bay_tab
      WHERE contract     = contract_
      AND   warehouse_id = warehouse_id_;
BEGIN
   FOR bay_rec_ IN get_bays LOOP
      Warehouse_Bay_API.Clear_Storage_Chars__(contract_,
                                              warehouse_id_,
                                              bay_rec_.bay_id,
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
                                              bay_carrying_capacity_db_,
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
                                              availability_control_id_db_,
                                              drop_off_location_db_);
   END LOOP;
END Clear_Bay_Storage_Chars___;


PROCEDURE Copy_Capabilities___ (
   from_contract_     IN VARCHAR2,
   from_warehouse_id_ IN VARCHAR2,
   to_contract_       IN VARCHAR2,
   to_warehouse_id_   IN VARCHAR2 )
IS
   CURSOR get_capabilities IS
      SELECT storage_capability_id
        FROM warehouse_capability_tab
       WHERE contract     = from_contract_
         AND warehouse_id = from_warehouse_id_;
BEGIN

   FOR rec_ IN get_capabilities LOOP
      Warehouse_Capability_API.Copy__(from_contract_,
                                      from_warehouse_id_,
                                      rec_.storage_capability_id,
                                      to_contract_,
                                      to_warehouse_id_);
   END LOOP;
END Copy_Capabilities___;


PROCEDURE Copy_Remote_Whse_Assortment___ (
   from_contract_     IN VARCHAR2,
   from_warehouse_id_ IN VARCHAR2,
   to_contract_       IN VARCHAR2,
   to_warehouse_id_   IN VARCHAR2 )
IS
   CURSOR get_assortments IS
      SELECT assortment_id
      FROM   remote_whse_assort_connect_tab
      WHERE  contract     = from_contract_
      AND    warehouse_id = from_warehouse_id_;
BEGIN   
   FOR rec_ IN get_assortments LOOP
      Remote_Whse_Assort_Connect_API.Copy__(from_contract_,
                                            from_warehouse_id_,
                                            rec_.assortment_id,
                                            to_contract_,
                                            to_warehouse_id_);
   END LOOP;
END Copy_Remote_Whse_Assortment___;

PROCEDURE Copy_Remote_Whse_Users___ (
   from_contract_     IN VARCHAR2,
   from_warehouse_id_ IN VARCHAR2,
   to_contract_       IN VARCHAR2,
   to_warehouse_id_   IN VARCHAR2 )
IS
   $IF (Component_Mscom_SYS.INSTALLED) $THEN
      CURSOR get_users IS
         SELECT user_id
         FROM   user_warehouse_connection_tab
         WHERE  contract     = from_contract_
         AND    warehouse_id = from_warehouse_id_;
   $END
BEGIN   
   $IF (Component_Mscom_SYS.INSTALLED) $THEN
      FOR rec_ IN get_users LOOP
         User_Warehouse_Connection_API.Copy__(from_contract_,
                                              from_warehouse_id_,
                                              rec_.user_id,
                                              to_contract_,
                                              to_warehouse_id_);
      END LOOP;
   $ELSE
      NULL;
   $END
END Copy_Remote_Whse_Users___;

PROCEDURE Validate_Putaway_Ranking___ (
   newrec_ IN warehouse_tab%ROWTYPE )
IS
BEGIN
   IF newrec_.putaway_zone_ranking < 1 OR (newrec_.putaway_zone_ranking != ROUND(newrec_.putaway_zone_ranking)) THEN
      Error_SYS.Record_General(lu_name_,'PUTAWAYZONERANKING: Putaway Zone Ranking must be an integer greater than 0.');
   END IF;
END Validate_Putaway_Ranking___;

PROCEDURE Validate_Putaway_Max_Bins___ (
   newrec_ IN warehouse_tab%ROWTYPE )
IS
BEGIN
   IF newrec_.putaway_max_bins_per_part < 1 OR (newrec_.putaway_max_bins_per_part != ROUND(newrec_.putaway_max_bins_per_part)) THEN
         Error_SYS.Record_General(lu_name_,'PUTAWAYMAXBINSPERPART: Putaway Max Bins per Part must be an integer greater than 0.');
      END IF;
END Validate_Putaway_Max_Bins___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT warehouse_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
BEGIN
   IF NOT (indrec_.route_order) THEN
      newrec_.route_order                 := newrec_.warehouse_id;
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
   IF NOT (indrec_.remote_warehouse) THEN
      newrec_.remote_warehouse            := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.appear_as_putaway_zone) THEN
      newrec_.appear_as_putaway_zone      := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.auto_refill_putaway_zones) THEN
      newrec_.auto_refill_putaway_zones   := Fnd_Boolean_API.db_true;
   END IF;
   IF NOT (indrec_.putaway_destination) THEN
      newrec_.putaway_destination         := Fnd_Boolean_API.db_true;
   END IF;
   IF NOT (indrec_.auto_created ) THEN
      newrec_.auto_created := Fnd_Boolean_API.DB_FALSE;
   END IF;

   super(newrec_, indrec_, attr_);
   
   IF (newrec_.warehouse_id = '*') THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDWHID: Warehouse ID * is not allowed.');
   END IF;
   
   IF (newrec_.appear_as_putaway_zone = Fnd_Boolean_API.db_true) THEN
      Error_SYS.Check_Not_Null(lu_name_, 'PUTAWAY_ZONE_RANKING', newrec_.putaway_zone_ranking);
   END IF;

   IF newrec_.putaway_max_bins_per_part IS NOT NULL THEN
     Validate_Putaway_Max_Bins___(newrec_);
   END IF;
   
   IF newrec_.putaway_zone_ranking IS NOT NULL THEN
     Validate_Putaway_Ranking___(newrec_);
   END IF;
   
   IF (UPPER(newrec_.warehouse_id) != newrec_.warehouse_id) THEN
      Error_SYS.Record_General(lu_name_,'WIDUPPERCASE: The Warehouse ID must be entered in upper-case.');
   END IF;
   Error_SYS.Check_Valid_Key_String('WAREHOUSE_ID', newrec_.warehouse_id);
   Error_SYS.Check_Valid_Key_String('ROUTE_ORDER', newrec_.route_order);
   Error_SYS.Check_Valid_Key_String('GLOBAL_WAREHOUSE_ID', newrec_.global_warehouse_id);
   
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
   oldrec_ IN     warehouse_tab%ROWTYPE,
   newrec_ IN OUT warehouse_tab%ROWTYPE,
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
   
   IF (newrec_.appear_as_putaway_zone = Fnd_Boolean_API.db_true) THEN
      Error_SYS.Check_Not_Null(lu_name_, 'PUTAWAY_ZONE_RANKING', newrec_.putaway_zone_ranking);
   END IF;
   
   IF newrec_.putaway_max_bins_per_part IS NOT NULL THEN
     Validate_Putaway_Max_Bins___(newrec_);
   END IF;
   
   IF newrec_.putaway_zone_ranking IS NOT NULL THEN
     Validate_Putaway_Ranking___(newrec_);
   END IF;
   IF (oldrec_.receipts_blocked = Fnd_Boolean_API.db_false) AND (newrec_.receipts_blocked = Fnd_Boolean_API.db_true) THEN
      -- Receipts Blocked has been changed from FALSE to TRUE on the Warehouse level.
      IF (Get_Receipts_Blocked_Db(newrec_.contract,
                                  newrec_.warehouse_id) = Fnd_Boolean_API.db_true) THEN
         -- The Warehouse is already blocked because whole Site is blocked.
         receipts_blocked_source_ := Get_Receipts_Blocked_Source(newrec_.contract,
                                                                 newrec_.warehouse_id);
         Error_SYS.Record_General(lu_name_,'RECEIPTSBLKTNOUPDATE: Receipts are already blocked on the :P1 level of the Warehouse Structure.', receipts_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.receipt_to_occupied_blocked = Fnd_Boolean_API.db_false) AND (newrec_.receipt_to_occupied_blocked = Fnd_Boolean_API.db_true) THEN
      -- Receipt to occupied blocked has been changed from FALSE to TRUE on the Warehouse level.
      IF (Get_Receipt_To_Occup_Blockd_Db(newrec_.contract,
                                         newrec_.warehouse_id) = Fnd_Boolean_API.db_true) THEN
         -- The Warehouse is already blocked because the whole Site is blocked.
         receipt_to_occup_blkd_src_ := Get_Receipt_To_Occup_Blkd_Src(newrec_.contract,
                                                                     newrec_.warehouse_id);
         Error_SYS.Record_General(lu_name_,'RECOCCUPBLKTNOUPDATE: Receipt to occupied is already blocked on the :P1 level of the Warehouse Structure.', receipt_to_occup_blkd_src_);
      END IF;
   END IF;

   IF (oldrec_.mix_of_part_number_blocked = Fnd_Boolean_API.db_false) AND (newrec_.mix_of_part_number_blocked = Fnd_Boolean_API.db_true) THEN
      -- Mix of Part Numbers Blocked has been changed from FALSE to TRUE on the Warehouse level.
      IF (Get_Mix_Of_Parts_Blocked_Db(newrec_.contract,
                                      newrec_.warehouse_id) = Fnd_Boolean_API.db_true) THEN
         -- The Warehouse is already blocked because whole Site is blocked.
         mix_of_part_blocked_source_ := Get_Mix_Of_Part_Blocked_Source(newrec_.contract,
                                                                       newrec_.warehouse_id);
         Error_SYS.Record_General(lu_name_,'MIXPARTSNOUPDATE: Mix of Part Numbers already blocked on the :P1 level of the Warehouse Structure.', mix_of_part_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.mix_of_cond_codes_blocked = Fnd_Boolean_API.db_false) AND (newrec_.mix_of_cond_codes_blocked = Fnd_Boolean_API.db_true) THEN
      -- Mix of Condition Codes Blocked has been changed from FALSE to TRUE on the Warehouse level.
      IF (Get_Mix_Of_Cond_Blocked_Db(newrec_.contract,
                                      newrec_.warehouse_id) = Fnd_Boolean_API.db_true) THEN
         -- The Warehouse is already blocked because whole Site is blocked.
         mix_of_cond_blocked_source_ := Get_Mix_Of_Cond_Blocked_Source(newrec_.contract,
                                                                       newrec_.warehouse_id);
         Error_SYS.Record_General(lu_name_,'MIXCONDITIONSNOUPDATE: Mix of Condition Codes already blocked on the :P1 level of the Warehouse Structure.', mix_of_cond_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.mix_of_lot_batch_no_blocked = Fnd_Boolean_API.db_false) AND (newrec_.mix_of_lot_batch_no_blocked = Fnd_Boolean_API.db_true) THEN
      -- Mix of Lot Batch Numbers Blocked has been changed from FALSE to TRUE on the Warehouse level.
      IF (Get_Mix_Of_Lot_Blocked_Db(newrec_.contract,
                                    newrec_.warehouse_id) = Fnd_Boolean_API.db_true) THEN
         -- The Warehouse is already blocked because whole Site is blocked.
         mix_of_lot_blocked_source_ := Get_Mix_Of_Lot_Blocked_Source(newrec_.contract,
                                                                     newrec_.warehouse_id);
         Error_SYS.Record_General(lu_name_,'MIXLOTBATCHNOUPDATE: Mix of Lot Batch Numbers already blocked on the :P1 level of the Warehouse Structure.', mix_of_lot_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.exclude_storage_req_val = Fnd_Boolean_API.db_false) AND (newrec_.exclude_storage_req_val = Fnd_Boolean_API.db_true) THEN
      -- Exclude Storage Requirement Validation has been changed from FALSE to TRUE on the Warehouse level.
      IF (Get_Exclude_Storage_Req_Val_Db(newrec_.contract,
                                         newrec_.warehouse_id) = Fnd_Boolean_API.db_true) THEN
         -- The Warehouse is already excluded because whole Site is excluded.
         exclude_storage_req_val_src_ := Get_Excl_Storage_Req_Val_Src(newrec_.contract,
                                                                      newrec_.warehouse_id);
         Error_SYS.Record_General(lu_name_,'EXCLSTORAGEREQUPDATE: Exclude Storage Requirement Validation already checked on the :P1 level of the Warehouse Structure.', exclude_storage_req_val_src_);
      END IF;
   END IF;
   
   IF (newrec_.remote_warehouse != oldrec_.remote_warehouse) THEN
      IF ((Inventory_Part_In_Stock_API.Quantity_In_Warehouse_Exist(newrec_.contract, newrec_.warehouse_id)) OR
          (Transport_Task_API.Inbound_To_Warehouse_Exist(newrec_.contract, newrec_.warehouse_id))) THEN
         Error_SYS.Record_General(lu_name_,'LOCUSEDNOTALLOWEDREMWHSE: You cannot change the Remote property of Warehouse :P1 since it has Part Quantities On Hand or Inbound.', newrec_.warehouse_id);
      END IF;
      IF ((newrec_.remote_warehouse = Fnd_Boolean_API.db_false) AND
         (Remote_Whse_Assort_Connect_API.Connected_Assortment_Exist(newrec_.contract, newrec_.warehouse_id))) THEN
         Error_SYS.Record_General(lu_name_,'CONNECTEDASSORTMENTEXIST: You cannot deselect the Remote property of Warehouse :P1 since it has connected assortments.', newrec_.warehouse_id);
      END IF;
   END IF;
   
   Error_SYS.Check_Valid_Key_String('ROUTE_ORDER', newrec_.route_order);
      
   IF (NVL(newrec_.bin_height_capacity, number_null_) != NVL(oldrec_.bin_height_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.bin_height_capacity);
   END IF;
   IF (NVL(newrec_.bin_width_capacity, number_null_) != NVL(oldrec_.bin_width_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.bin_width_capacity);
   END IF;
   IF (NVL(newrec_.bin_dept_capacity, number_null_) != NVL(oldrec_.bin_dept_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.bin_dept_capacity);
   END IF;
   IF (NVL(newrec_.bin_volume_capacity, number_null_) != NVL(oldrec_.bin_volume_capacity, number_null_)) THEN
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
   
   Validate_Drop_Off_Location___(newrec_);
   
END Check_Update___;


PROCEDURE Validate_Drop_Off_Loc_Type___ (
   newrec_ IN warehouse_tab%ROWTYPE )
IS
BEGIN      
   IF (NOT Inventory_Location_API.Get_Location_Type_Db(newrec_.contract, newrec_.drop_off_location_no) IN ('PICKING','F','MANUFACTURING')) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGSINGLELOCATIONTYPE: Drop-off location must to be of location type :P1, :P2 or :P3.', Inventory_Location_Type_API.Decode('PICKING'), Inventory_Location_Type_API.Decode('F'), Inventory_Location_Type_API.Decode('MANUFACTURING'));
   END IF;
END Validate_Drop_Off_Loc_Type___;

   
PROCEDURE Validate_Drop_Off_Location___ (
   newrec_ IN warehouse_tab%ROWTYPE)
IS
BEGIN   
   Validate_Drop_Off_Loc_Type___(newrec_);
   
   Validate_Drop_Off_Loop___(newrec_.contract, newrec_.warehouse_id, newrec_.drop_off_location_no);
END Validate_Drop_Off_Location___;


PROCEDURE Validate_Drop_Off_Loop___ (
   contract_             IN VARCHAR2,
   source_whse_id_       IN VARCHAR2,
   drop_off_location_no_ IN VARCHAR2 )
IS
   TYPE drop_off_type         IS VARRAY(100) OF VARCHAR2(15);
   approved_drop_offs_        drop_off_type;
   next_drop_off_whse_id_     VARCHAR2(15);
   old_drop_off_whse_id_      VARCHAR2(15);
   next_drop_off_location_no_ VARCHAR2(35);
   has_drop_off_              BOOLEAN  := FALSE;
   infinite_loop_             BOOLEAN  := FALSE;
   counter_                   NUMBER   := 1;
BEGIN
   next_drop_off_whse_id_ := Inventory_Location_API.Get_Warehouse(contract_, drop_off_location_no_);
   next_drop_off_location_no_ := drop_off_location_no_;
   -- If drop off warehouse differ from source warehouse
   IF (source_whse_id_ != next_drop_off_whse_id_) THEN 
      -- First drop off is considered approved
      approved_drop_offs_ := drop_off_type();
      approved_drop_offs_.extend;
      approved_drop_offs_(counter_) := next_drop_off_whse_id_;
      counter_ := counter_ + 1;
      
      LOOP
         old_drop_off_whse_id_ := next_drop_off_whse_id_;
         -- Get next possible drop off 
         next_drop_off_location_no_ := Get_Drop_Off_Location_No(contract_, next_drop_off_whse_id_);
         next_drop_off_whse_id_     := Inventory_Location_API.Get_Warehouse(contract_, next_drop_off_location_no_);

         has_drop_off_ := CASE WHEN next_drop_off_whse_id_ IS NOT NULL THEN TRUE ELSE FALSE END;
         IF (has_drop_off_) THEN
            -- If the next drop off is located in the source warehouse we got a infinite loop
            IF (next_drop_off_whse_id_ = source_whse_id_) THEN
               infinite_loop_ := TRUE;
            ELSIF (next_drop_off_whse_id_ = old_drop_off_whse_id_) THEN
               -- The next drop off has itself as drop off, OK and we're done
               EXIT;   
            ELSE
               -- Iterate through all previously approved drop offs and see if the current one already exists, if so, infinite loop exists
               FOR i IN approved_drop_offs_.FIRST .. approved_drop_offs_.LAST LOOP
                  IF approved_drop_offs_(i) = next_drop_off_whse_id_ THEN
                     infinite_loop_ := TRUE;
                  END IF;
               END LOOP;
            END IF;
                      
            IF (infinite_loop_) THEN
               Error_SYS.Record_General(lu_name_, 'DROPOFFINFINITERECURSION: Current drop off location structure is causing an infinite loop.');
               EXIT;
            END IF;
         
            -- All good, add current drop off to list of approved drop offs.
            approved_drop_offs_.EXTEND;
            approved_drop_offs_(counter_) := next_drop_off_whse_id_;
            counter_ := counter_ + 1;       
         END IF;
         EXIT WHEN has_drop_off_ = FALSE;
      END LOOP;
   END IF;
   
END Validate_Drop_Off_Loop___;


FUNCTION Create_New_Warehouse_Id___(
   contract_ IN VARCHAR2 ) RETURN NUMBER
IS
   new_warehouse_id_ warehouse_tab.warehouse_id%TYPE;
BEGIN
   LOOP
      SELECT warehouse_id_seq.nextval
         INTO new_warehouse_id_
         FROM dual;
      EXIT WHEN NOT Check_Exist___(contract_, new_warehouse_id_);
   END LOOP;
   RETURN new_warehouse_id_;
END Create_New_Warehouse_Id___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy__ (
   from_contract_          IN VARCHAR2,
   from_warehouse_id_      IN VARCHAR2,
   to_contract_            IN VARCHAR2,
   to_warehouse_id_        IN VARCHAR2,
   copy_bays_              IN BOOLEAN,
   copy_cubic_capacity_    IN BOOLEAN,
   copy_carrying_capacity_ IN BOOLEAN,
   copy_temperatures_      IN BOOLEAN )
IS
   newrec_     warehouse_tab%ROWTYPE;
BEGIN

   Exist(from_contract_, from_warehouse_id_);
   Site_API.Exist(to_contract_);

   IF NOT (Check_Exist___(to_contract_, to_warehouse_id_)) THEN
      newrec_              := Get_Object_By_Keys___(from_contract_, from_warehouse_id_);
      newrec_.contract     := to_contract_;
      newrec_.warehouse_id := to_warehouse_id_;
      newrec_ := Clean_Non_Copy_Attributes___(newrec_, copy_cubic_capacity_, copy_carrying_capacity_, copy_temperatures_);
      New___(newrec_);

      Copy_Capabilities___(from_contract_, from_warehouse_id_, to_contract_, to_warehouse_id_);
      
      IF (newrec_.remote_warehouse = Fnd_Boolean_API.DB_TRUE) THEN
         Copy_Remote_Whse_Assortment___(from_contract_, from_warehouse_id_, to_contract_, to_warehouse_id_);
         Copy_Remote_Whse_Users___(from_contract_, from_warehouse_id_, to_contract_, to_warehouse_id_);
      END IF;
   END IF;

   IF (copy_bays_) THEN
      Copy_Bays__(from_contract_,
                  from_warehouse_id_,
                  to_contract_,
                  to_warehouse_id_,
                  copy_cubic_capacity_, 
                  copy_carrying_capacity_, 
                  copy_temperatures_);
   END IF;
END Copy__;


PROCEDURE Copy_Bays__ (
   from_contract_          IN VARCHAR2,
   from_warehouse_id_      IN VARCHAR2,
   to_contract_            IN VARCHAR2,
   to_warehouse_id_        IN VARCHAR2,
   copy_cubic_capacity_    IN BOOLEAN,
   copy_carrying_capacity_ IN BOOLEAN,
   copy_temperatures_      IN BOOLEAN )
IS
   CURSOR get_bays IS
      SELECT bay_id
        FROM warehouse_bay_tab
       WHERE contract     = from_contract_
         AND warehouse_id = from_warehouse_id_;
BEGIN

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, from_contract_);
   FOR bay_rec_ IN get_bays LOOP
      Warehouse_Bay_API.Copy__(from_contract_,
                               from_warehouse_id_,
                               bay_rec_.bay_id,
                               to_contract_,
                               to_warehouse_id_,
                               bay_rec_.bay_id,
                               copy_rows_and_tiers_ => TRUE,
                               copy_cubic_capacity_ => copy_cubic_capacity_,
                               copy_carrying_capacity_ => copy_carrying_capacity_,
                               copy_temperatures_ => copy_temperatures_);
   END LOOP;
END Copy_Bays__;


PROCEDURE Clear_Storage_Chars__ (
   contract_                      IN VARCHAR2,
   warehouse_id_                  IN VARCHAR2,
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
   newrec_     warehouse_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, warehouse_id_);
   
   IF (receipts_blocked_db_) THEN
      newrec_.receipts_blocked := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (receipt_to_occup_blocked_db_) THEN
      newrec_.receipt_to_occupied_blocked := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (mix_of_part_number_blocked_db_) THEN 
      newrec_.mix_of_part_number_blocked := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (mix_of_cond_codes_blocked_db_) THEN
      newrec_.mix_of_cond_codes_blocked := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (mix_of_lot_batch_blocked_db_) THEN
      newrec_.mix_of_lot_batch_no_blocked := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (exclude_storage_req_val_db_) THEN
      newrec_.exclude_storage_req_val := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (hide_in_whse_navigator_db_) THEN
      newrec_.hide_in_whse_navigator := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (bin_width_capacity_db_) THEN
      newrec_.bin_width_capacity := NULL;
   END IF;
   IF (bin_height_capacity_db_) THEN
      newrec_.bin_height_capacity := NULL;
   END IF;
   IF (bin_dept_capacity_db_) THEN
      newrec_.bin_dept_capacity := NULL;
   END IF;
   IF (bin_volume_capacity_db_) THEN
      newrec_.bin_volume_capacity := NULL;
   END IF;  
   IF (bay_carrying_capacity_db_) THEN
      newrec_.bay_carrying_capacity := NULL;
   END IF;
   IF (row_carrying_capacity_db_) THEN
      newrec_.row_carrying_capacity := NULL;
   END IF;
   IF (tier_carrying_capacity_db_) THEN
      newrec_.tier_carrying_capacity := NULL;
   END IF;
   IF (bin_carrying_capacity_db_) THEN
      newrec_.bin_carrying_capacity := NULL;
   END IF;
   IF (bin_min_temperature_db_) THEN
      newrec_.bin_min_temperature := NULL;
   END IF;
   IF (bin_max_temperature_db_) THEN
      newrec_.bin_max_temperature := NULL;
   END IF;
   IF (bin_min_humidity_db_) THEN
      newrec_.bin_min_humidity := NULL;
   END IF;
   IF (bin_max_humidity_db_) THEN
      newrec_.bin_max_humidity := NULL;
   END IF;
   IF (availability_control_id_db_) THEN
      newrec_.availability_control_id := NULL;
   END IF;
   IF (drop_off_location_db_) THEN
      newrec_.drop_off_location_no := NULL;
   END IF;
   
   Modify___(newrec_);
   
   IF (capabilities_db_) THEN
      Warehouse_Capability_API.Clear_Storage_Capabilities__(contract_, 
                                                            warehouse_id_,
                                                            all_capabilities_db_, 
                                                            capability_tab_);
   END IF;
   
   Clear_Bay_Storage_Chars___(contract_,
                              warehouse_id_,
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
                              bay_carrying_capacity_db_,
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
                              availability_control_id_db_,
                              drop_off_location_db_);
END Clear_Storage_Chars__;


PROCEDURE Clear_Bay_Storage_Chars__ (
   contract_                    IN VARCHAR2,
   warehouse_id_                IN VARCHAR2,
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
   bay_carrying_capacity_       IN NUMBER,
   row_carrying_capacity_       IN NUMBER,
   tier_carrying_capacity_      IN NUMBER,
   bin_carrying_capacity_       IN NUMBER,
   bin_min_temperature_         IN NUMBER,
   bin_max_temperature_         IN NUMBER,
   bin_min_humidity_            IN NUMBER,
   bin_max_humidity_            IN NUMBER,
   capabilities_                IN NUMBER,
   all_capabilities_            IN NUMBER,
   availability_control_id_     IN NUMBER,
   drop_off_location_           IN NUMBER ) 
IS
   capability_tab_ Storage_Capability_API.Capability_Tab;
BEGIN
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   
   IF (capabilities_ = 1) THEN
      IF (all_capabilities_ = 0) THEN 
         capability_tab_ := Warehouse_Bin_Capability_API.Get_Operative_Capabilities(contract_, warehouse_id_, NULL, NULL, NULL, NULL);
      END IF;
   END IF;
   
   Clear_Bay_Storage_Chars___(contract_,
                              warehouse_id_,
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
                              CASE bay_carrying_capacity_       WHEN 1 THEN TRUE ELSE FALSE END,
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
                              CASE availability_control_id_     WHEN 1 THEN TRUE ELSE FALSE END,
                              CASE drop_off_location_           WHEN 1 THEN TRUE ELSE FALSE END);
END Clear_Bay_Storage_Chars__;



-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Remove(
   contract_   IN VARCHAR2,
   warehouse_id_  IN VARCHAR2 )
IS
   remrec_ warehouse_tab%ROWTYPE;
BEGIN
   remrec_ := Lock_By_Keys___(contract_, warehouse_id_);
   -- Remove Warehouse
   Remove___(remrec_);
END Remove;

@Override
@UncheckedAccess
FUNCTION Get_Bin_Height_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   bin_height_capacity_ warehouse_tab.bin_height_capacity%TYPE;
BEGIN
   bin_height_capacity_ := super(contract_, warehouse_id_);

   IF (bin_height_capacity_ IS NULL) THEN
      bin_height_capacity_ := Site_Invent_Info_API.Get_Bin_Height_Capacity(contract_);
   END IF;
   RETURN (bin_height_capacity_);
END Get_Bin_Height_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Width_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   bin_width_capacity_ warehouse_tab.bin_width_capacity%TYPE;
BEGIN
   bin_width_capacity_ := super(contract_, warehouse_id_);

   IF (bin_width_capacity_ IS NULL) THEN
      bin_width_capacity_ := Site_Invent_Info_API.Get_Bin_Width_Capacity(contract_);
   END IF;
   RETURN (bin_width_capacity_);
END Get_Bin_Width_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Dept_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   bin_dept_capacity_ warehouse_tab.bin_dept_capacity%TYPE;
BEGIN
   bin_dept_capacity_ := super(contract_, warehouse_id_);

   IF (bin_dept_capacity_ IS NULL) THEN
      bin_dept_capacity_ := Site_Invent_Info_API.Get_Bin_Dept_Capacity(contract_);
   END IF;
   RETURN (bin_dept_capacity_);
END Get_Bin_Dept_Capacity;


@UncheckedAccess
FUNCTION Get_Bin_Volume_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   bin_volume_capacity_ warehouse_tab.bin_volume_capacity%TYPE;
   dummy_               VARCHAR2(20);
BEGIN
   Get_Bin_Vol_Cap_And_Src_Db___(bin_volume_capacity_,
                                 dummy_,
                                 contract_,
                                 warehouse_id_,
                                 get_capacity_ => TRUE,
                                 get_source_   => FALSE);
   RETURN (bin_volume_capacity_);
END Get_Bin_Volume_Capacity;


@UncheckedAccess
FUNCTION Get_Bin_Volume_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_volume_cap_source_db_ VARCHAR2(20);
   dummy_                    warehouse_tab.bin_volume_capacity%TYPE;
BEGIN
   Get_Bin_Vol_Cap_And_Src_Db___(dummy_,
                                 bin_volume_cap_source_db_,
                                 contract_,
                                 warehouse_id_,
                                 get_capacity_ => FALSE,
                                 get_source_   => TRUE);
   RETURN (bin_volume_cap_source_db_);
END Get_Bin_Volume_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Volume_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Volume_Cap_Source_Db(contract_, warehouse_id_)));
END Get_Bin_Volume_Capacity_Source;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Carrying_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   bin_carrying_capacity_ warehouse_tab.bin_carrying_capacity%TYPE;
BEGIN
   bin_carrying_capacity_ := super(contract_, warehouse_id_);

   IF (bin_carrying_capacity_ IS NULL) THEN
      bin_carrying_capacity_ := Site_Invent_Info_API.Get_Bin_Carrying_Capacity(contract_);
   END IF;
   RETURN (bin_carrying_capacity_);
END Get_Bin_Carrying_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Min_Temperature (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   bin_min_temperature_ warehouse_tab.bin_min_temperature%TYPE;
BEGIN
   bin_min_temperature_ := super(contract_, warehouse_id_);

   IF (bin_min_temperature_ IS NULL) THEN
      bin_min_temperature_ := Site_Invent_Info_API.Get_Bin_Min_Temperature(contract_);
   END IF;
   RETURN (bin_min_temperature_);
END Get_Bin_Min_Temperature;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Max_Temperature (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   bin_max_temperature_ warehouse_tab.bin_max_temperature%TYPE;
BEGIN
   bin_max_temperature_ := super(contract_, warehouse_id_);

   IF (bin_max_temperature_ IS NULL) THEN
      bin_max_temperature_ := Site_Invent_Info_API.Get_Bin_Max_Temperature(contract_);
   END IF;
   RETURN (bin_max_temperature_);
END Get_Bin_Max_Temperature;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Min_Humidity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   bin_min_humidity_ warehouse_tab.bin_min_humidity%TYPE;
BEGIN
   bin_min_humidity_ := super(contract_, warehouse_id_);

   IF (bin_min_humidity_ IS NULL) THEN
      bin_min_humidity_ := Site_Invent_Info_API.Get_Bin_Min_Humidity(contract_);
   END IF;
   RETURN (bin_min_humidity_);
END Get_Bin_Min_Humidity;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Max_Humidity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   bin_max_humidity_ warehouse_tab.bin_max_humidity%TYPE;
BEGIN
   bin_max_humidity_ := super(contract_, warehouse_id_);

   IF (bin_max_humidity_ IS NULL) THEN
      bin_max_humidity_ := Site_Invent_Info_API.Get_Bin_Max_Humidity(contract_);
   END IF;
   RETURN (bin_max_humidity_);
END Get_Bin_Max_Humidity;


@Override
@UncheckedAccess
FUNCTION Get_Bay_Carrying_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   bay_carrying_capacity_ warehouse_tab.bay_carrying_capacity%TYPE;
BEGIN
   bay_carrying_capacity_ := super(contract_, warehouse_id_);

   IF (bay_carrying_capacity_ IS NULL) THEN
      bay_carrying_capacity_ := Site_Invent_Info_API.Get_Bay_Carrying_Capacity(contract_);
   END IF;
   RETURN (bay_carrying_capacity_);
END Get_Bay_Carrying_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Row_Carrying_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   row_carrying_capacity_ warehouse_tab.row_carrying_capacity%TYPE;
BEGIN
   row_carrying_capacity_ := super(contract_, warehouse_id_);

   IF (row_carrying_capacity_ IS NULL) THEN
      row_carrying_capacity_ := Site_Invent_Info_API.Get_Row_Carrying_Capacity(contract_);
   END IF;
   RETURN (row_carrying_capacity_);
END Get_Row_Carrying_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Tier_Carrying_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   tier_carrying_capacity_ warehouse_tab.tier_carrying_capacity%TYPE;
BEGIN
   tier_carrying_capacity_ := super(contract_, warehouse_id_);

   IF (tier_carrying_capacity_ IS NULL) THEN
      tier_carrying_capacity_ := Site_Invent_Info_API.Get_Tier_Carrying_Capacity(contract_);
   END IF;
   RETURN (tier_carrying_capacity_);
END Get_Tier_Carrying_Capacity;


@UncheckedAccess
FUNCTION Get_Bin_Height_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Height_Cap_Source_Db(contract_, warehouse_id_)));
END Get_Bin_Height_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Width_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Width_Cap_Source_Db(contract_, warehouse_id_)));
END Get_Bin_Width_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Dept_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Dept_Cap_Source_Db(contract_, warehouse_id_)));
END Get_Bin_Dept_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Carry_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Carry_Cap_Source_Db(contract_, warehouse_id_)));
END Get_Bin_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Min_Temperature_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Min_Temp_Source_Db(contract_, warehouse_id_)));
END Get_Bin_Min_Temperature_Source;


@UncheckedAccess
FUNCTION Get_Bin_Max_Temperature_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Max_Temp_Source_Db(contract_, warehouse_id_)));
END Get_Bin_Max_Temperature_Source;


@UncheckedAccess
FUNCTION Get_Bin_Min_Humidity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Min_Humidity_Source_Db(contract_, warehouse_id_)));
END Get_Bin_Min_Humidity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Max_Humidity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Max_Humidity_Source_Db(contract_, warehouse_id_)));
END Get_Bin_Max_Humidity_Source;


@UncheckedAccess
FUNCTION Get_Bay_Carry_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bay_Carry_Cap_Source_Db(contract_, warehouse_id_)));
END Get_Bay_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Row_Carry_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Row_Carry_Cap_Source_Db(contract_, warehouse_id_)));
END Get_Row_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Tier_Carry_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Tier_Carry_Cap_Source_Db(contract_, warehouse_id_)));
END Get_Tier_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Height_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_height_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.bin_height_capacity IS NULL) THEN
      bin_height_capacity_source_db_ := Site_Invent_Info_API.Get_Bin_Height_Cap_Source_Db(contract_);
   ELSE
      bin_height_capacity_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN (bin_height_capacity_source_db_);
END Get_Bin_Height_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Width_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_width_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.bin_width_capacity IS NULL) THEN
      bin_width_capacity_source_db_ := Site_Invent_Info_API.Get_Bin_Width_Cap_Source_Db(contract_);
   ELSE
      bin_width_capacity_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN (bin_width_capacity_source_db_);
END Get_Bin_Width_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Dept_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_dept_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.bin_dept_capacity IS NULL) THEN
      bin_dept_capacity_source_db_ := Site_Invent_Info_API.Get_Bin_Dept_Cap_Source_Db(contract_);
   ELSE
      bin_dept_capacity_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN (bin_dept_capacity_source_db_);
END Get_Bin_Dept_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Carry_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_carry_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.bin_carrying_capacity IS NULL) THEN
      bin_carry_capacity_source_db_ := Site_Invent_Info_API.Get_Bin_Carry_Cap_Source_Db(contract_);
   ELSE
      bin_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN (bin_carry_capacity_source_db_);
END Get_Bin_Carry_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Min_Temp_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_min_temperature_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.bin_min_temperature IS NULL) THEN
      bin_min_temperature_source_db_ := Site_Invent_Info_API.Get_Bin_Min_Temp_Source_Db(contract_);
   ELSE
      bin_min_temperature_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN (bin_min_temperature_source_db_);
END Get_Bin_Min_Temp_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Max_Temp_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_max_temperature_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.bin_max_temperature IS NULL) THEN
      bin_max_temperature_source_db_ := Site_Invent_Info_API.Get_Bin_Max_Temp_Source_Db(contract_);
   ELSE
      bin_max_temperature_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN (bin_max_temperature_source_db_);
END Get_Bin_Max_Temp_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Min_Humidity_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_min_humidity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.bin_min_humidity IS NULL) THEN
      bin_min_humidity_source_db_ := Site_Invent_Info_API.Get_Bin_Min_Humidity_Source_Db(contract_);
   ELSE
      bin_min_humidity_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN (bin_min_humidity_source_db_);
END Get_Bin_Min_Humidity_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Max_Humidity_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_max_humidity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.bin_max_humidity IS NULL) THEN
      bin_max_humidity_source_db_ := Site_Invent_Info_API.Get_Bin_Max_Humidity_Source_Db(contract_);
   ELSE
      bin_max_humidity_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN (bin_max_humidity_source_db_);
END Get_Bin_Max_Humidity_Source_Db;


@UncheckedAccess
FUNCTION Get_Bay_Carry_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bay_carry_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.bay_carrying_capacity IS NULL) THEN
      bay_carry_capacity_source_db_ := Site_Invent_Info_API.Get_Bay_Carry_Cap_Source_Db(contract_);
   ELSE
      bay_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN (bay_carry_capacity_source_db_);
END Get_Bay_Carry_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Row_Carry_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   row_carry_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.row_carrying_capacity IS NULL) THEN
      row_carry_capacity_source_db_ := Site_Invent_Info_API.Get_Row_Carry_Cap_Source_Db(contract_);
   ELSE
      row_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN (row_carry_capacity_source_db_);
END Get_Row_Carry_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Tier_Carry_Cap_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   tier_carry_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.tier_carrying_capacity IS NULL) THEN
      tier_carry_capacity_source_db_ := Site_Invent_Info_API.Get_Tier_Carry_Cap_Source_Db(contract_);
   ELSE
      tier_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN (tier_carry_capacity_source_db_);
END Get_Tier_Carry_Cap_Source_Db;


@Override
@UncheckedAccess
FUNCTION Get_Receipts_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipts_blocked_ warehouse_tab.receipts_blocked%TYPE;
BEGIN
   receipts_blocked_ := super(contract_, warehouse_id_);
   
   receipts_blocked_ := Fnd_Boolean_API.Encode(receipts_blocked_);
   IF (receipts_blocked_ = Fnd_Boolean_API.db_false) THEN
      receipts_blocked_ := Site_Invent_Info_API.Get_Receipts_Blocked_Db(contract_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(receipts_blocked_);
END Get_Receipts_Blocked;


@Override
@UncheckedAccess
FUNCTION Get_Receipts_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipts_blocked_ warehouse_tab.receipts_blocked%TYPE;
BEGIN
   receipts_blocked_ := super(contract_, warehouse_id_);

   IF (receipts_blocked_ = Fnd_Boolean_API.db_false) THEN
      receipts_blocked_ := Site_Invent_Info_API.Get_Receipts_Blocked_Db(contract_);
   END IF;
   RETURN (receipts_blocked_);
END Get_Receipts_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Receipts_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipts_blocked_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.receipts_blocked = Fnd_Boolean_API.db_false) THEN
      receipts_blocked_source_ := Site_Invent_Info_API.Get_Receipts_Blocked_Source(contract_);
   ELSE
      receipts_blocked_source_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_WAREHOUSE);
   END IF;
   RETURN (receipts_blocked_source_);
END Get_Receipts_Blocked_Source;


@Override
@UncheckedAccess
FUNCTION Get_Receipt_To_Occup_Blockd (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipt_to_occupied_blocked_ warehouse_tab.receipt_to_occupied_blocked%TYPE;
BEGIN
   receipt_to_occupied_blocked_ := super(contract_, warehouse_id_);
   receipt_to_occupied_blocked_ := Fnd_Boolean_API.Encode(receipt_to_occupied_blocked_);
   
   IF (receipt_to_occupied_blocked_ = Fnd_Boolean_API.db_false) THEN
      receipt_to_occupied_blocked_ := Site_Invent_Info_API.Get_Receipt_To_Occup_Blockd_Db(contract_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(receipt_to_occupied_blocked_);
END Get_Receipt_To_Occup_Blockd;


@Override
@UncheckedAccess
FUNCTION Get_Receipt_To_Occup_Blockd_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipt_to_occupied_blocked_ warehouse_tab.receipt_to_occupied_blocked%TYPE;
BEGIN
   receipt_to_occupied_blocked_ := super(contract_, warehouse_id_);

   IF (receipt_to_occupied_blocked_ = Fnd_Boolean_API.db_false) THEN
      receipt_to_occupied_blocked_ := Site_Invent_Info_API.Get_Receipt_To_Occup_Blockd_Db(contract_);
   END IF;
   RETURN (receipt_to_occupied_blocked_);
END Get_Receipt_To_Occup_Blockd_Db;


@UncheckedAccess
FUNCTION Get_Receipt_To_Occup_Blkd_Src (
   contract_ IN VARCHAR2,
   warehouse_id_ VARCHAR2 ) RETURN VARCHAR2
IS
   receipt_to_occup_blkd_src_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.receipt_to_occupied_blocked = Fnd_Boolean_API.db_false) THEN
      receipt_to_occup_blkd_src_ := Site_Invent_Info_API.Get_Receipt_To_Occup_Blkd_Src(contract_);
   ELSE
      receipt_to_occup_blkd_src_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_WAREHOUSE);
   END IF;
   RETURN (receipt_to_occup_blkd_src_);
END Get_Receipt_To_Occup_Blkd_Src;


@UncheckedAccess
FUNCTION Is_Hidden_In_Structure_Below (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   hide_in_whse_navigator_ warehouse_tab.hide_in_whse_navigator%TYPE;

   CURSOR get_bays IS
      SELECT bay_id
        FROM warehouse_bay_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_;
BEGIN
   FOR bay_rec_ IN get_bays LOOP
      hide_in_whse_navigator_ := Warehouse_Bay_API.Is_Hidden_In_Structure_Below(contract_, warehouse_id_, bay_rec_.bay_id, 'TRUE');
      EXIT WHEN hide_in_whse_navigator_ = 'TRUE';
   END LOOP;

   RETURN NVL(hide_in_whse_navigator_, 'FALSE');
END Is_Hidden_In_Structure_Below;

@UncheckedAccess
FUNCTION Is_Remote (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Remote_Warehouse_Db(contract_, warehouse_id_);
END Is_Remote;   


PROCEDURE Check_Bin_Temperature_Range (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 )
IS
   bin_min_temperature_ warehouse_tab.bin_min_temperature%TYPE;
   bin_max_temperature_ warehouse_tab.bin_max_temperature%TYPE;

   CURSOR get_bays IS
      SELECT bay_id
        FROM warehouse_bay_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_
         AND (bin_min_temperature IS NULL OR bin_max_temperature IS NULL);
BEGIN

   bin_min_temperature_ := Get_Bin_Min_Temperature(contract_, warehouse_id_);
   bin_max_temperature_ := Get_Bin_Max_Temperature(contract_, warehouse_id_);

   IF (Part_Catalog_Invent_Attrib_API.Incorrect_Temperature_Range(bin_min_temperature_, bin_max_temperature_)) THEN
      Error_SYS.Record_General(lu_name_, 'TEMPRANGE: Incorrect Operative Temperature Range in Warehouse :P1 on Site :P2.', warehouse_id_, contract_);
   END IF;

   FOR bay_rec_ IN get_bays LOOP
      Warehouse_Bay_API.Check_Bin_Temperature_Range(contract_, warehouse_id_, bay_rec_.bay_id);
   END LOOP;
END Check_Bin_Temperature_Range;


PROCEDURE Check_Bin_Humidity_Range (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 )
IS
   bin_min_humidity_ warehouse_tab.bin_min_humidity%TYPE;
   bin_max_humidity_ warehouse_tab.bin_max_humidity%TYPE;

   CURSOR get_bays IS
      SELECT bay_id
        FROM warehouse_bay_tab
       WHERE contract     = contract_
         AND warehouse_id = warehouse_id_
         AND (bin_min_humidity IS NULL OR bin_max_humidity IS NULL);
BEGIN

   bin_min_humidity_ := Get_Bin_Min_Humidity(contract_, warehouse_id_);
   bin_max_humidity_ := Get_Bin_Max_Humidity(contract_, warehouse_id_);

   IF (Part_Catalog_Invent_Attrib_API.Incorrect_Humidity_Range(bin_min_humidity_, bin_max_humidity_)) THEN
      Error_SYS.Record_General(lu_name_, 'HUMRANGE: Incorrect Operative Humidity Range in Warehouse :P1 on Site :P2.', warehouse_id_, contract_);
   END IF;

   FOR bay_rec_ IN get_bays LOOP
      Warehouse_Bay_API.Check_Bin_Humidity_Range(contract_, warehouse_id_, bay_rec_.bay_id);
   END LOOP;
END Check_Bin_Humidity_Range;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Part_Number_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_part_number_blocked_ warehouse_tab.mix_of_part_number_blocked%TYPE;
BEGIN
   mix_of_part_number_blocked_ := super(contract_, warehouse_id_);
   
   mix_of_part_number_blocked_ := Fnd_Boolean_API.Encode(mix_of_part_number_blocked_);
   IF (mix_of_part_number_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_part_number_blocked_ := Site_Invent_Info_API.Get_Mix_Of_Parts_Blocked_Db(contract_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(mix_of_part_number_blocked_);
END Get_Mix_Of_Part_Number_Blocked;

@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Parts_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_part_number_blocked_ warehouse_tab.mix_of_part_number_blocked%TYPE;
BEGIN
   mix_of_part_number_blocked_ := super(contract_, warehouse_id_);

   IF (mix_of_part_number_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_part_number_blocked_ := Site_Invent_Info_API.Get_Mix_Of_Parts_Blocked_Db(contract_);
   END IF;
   RETURN (mix_of_part_number_blocked_);
END Get_Mix_Of_Parts_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Mix_Of_Part_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_part_blocked_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.mix_of_part_number_blocked = Fnd_Boolean_API.db_false) THEN
      mix_of_part_blocked_source_ := Site_Invent_Info_API.Get_Mix_Of_Part_Blocked_Source(contract_);
   ELSE
      mix_of_part_blocked_source_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_WAREHOUSE);
   END IF;
   RETURN (mix_of_part_blocked_source_);
END Get_Mix_Of_Part_Blocked_Source;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Codes_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_cond_codes_blocked_ warehouse_tab.mix_of_cond_codes_blocked%TYPE;
BEGIN
   mix_of_cond_codes_blocked_ := super(contract_, warehouse_id_);
   
   mix_of_cond_codes_blocked_ := Fnd_Boolean_API.Encode(mix_of_cond_codes_blocked_);
   IF (mix_of_cond_codes_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_cond_codes_blocked_ := Site_Invent_Info_API.Get_Mix_Of_Cond_Blocked_Db(contract_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(mix_of_cond_codes_blocked_);
END Get_Mix_Of_Cond_Codes_Blocked;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_cond_codes_blocked_ warehouse_tab.mix_of_cond_codes_blocked%TYPE;
BEGIN
   mix_of_cond_codes_blocked_ := super(contract_,warehouse_id_);

   IF (mix_of_cond_codes_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_cond_codes_blocked_ := Site_Invent_Info_API.Get_Mix_Of_Cond_Blocked_Db(contract_);
   END IF;
   RETURN (mix_of_cond_codes_blocked_);
END Get_Mix_Of_Cond_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_cond_blocked_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.mix_of_cond_codes_blocked = Fnd_Boolean_API.db_false) THEN
      mix_of_cond_blocked_source_ := Site_Invent_Info_API.Get_Mix_Of_Cond_Blocked_Source(contract_);
   ELSE
      mix_of_cond_blocked_source_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_WAREHOUSE);
   END IF;
   RETURN (mix_of_cond_blocked_source_);
END Get_Mix_Of_Cond_Blocked_Source;

@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Lot_Batch_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_lot_batch_no_blocked_ warehouse_tab.mix_of_lot_batch_no_blocked%TYPE;
BEGIN
   mix_of_lot_batch_no_blocked_ := super(contract_, warehouse_id_);
   
   mix_of_lot_batch_no_blocked_ := Fnd_Boolean_API.Encode(mix_of_lot_batch_no_blocked_);
   IF (mix_of_lot_batch_no_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_lot_batch_no_blocked_ := Site_Invent_Info_API.Get_Mix_Of_Lot_Blocked_Db(contract_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(mix_of_lot_batch_no_blocked_);
END Get_Mix_Of_Lot_Batch_Blocked;

@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Lot_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_lot_batch_no_blocked_ warehouse_tab.mix_of_lot_batch_no_blocked%TYPE;
BEGIN
   mix_of_lot_batch_no_blocked_ := super(contract_, warehouse_id_);

   IF (mix_of_lot_batch_no_blocked_ = Fnd_Boolean_API.db_false) THEN
      mix_of_lot_batch_no_blocked_ := Site_Invent_Info_API.Get_Mix_Of_Lot_Blocked_Db(contract_);
   END IF;
   RETURN (mix_of_lot_batch_no_blocked_);
END Get_Mix_Of_Lot_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Mix_Of_Lot_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_lot_blocked_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.mix_of_lot_batch_no_blocked = Fnd_Boolean_API.db_false) THEN
      mix_of_lot_blocked_source_ := Site_Invent_Info_API.Get_Mix_Of_Lot_Blocked_Source(contract_);
   ELSE
      mix_of_lot_blocked_source_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_WAREHOUSE);
   END IF;
   RETURN (mix_of_lot_blocked_source_);
END Get_Mix_Of_Lot_Blocked_Source;


@Override
@UncheckedAccess
FUNCTION Get_Exclude_Storage_Req_Val (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   exclude_storage_req_val_ warehouse_tab.exclude_storage_req_val%TYPE;
BEGIN
   exclude_storage_req_val_ := super(contract_, warehouse_id_);

   exclude_storage_req_val_ := Fnd_Boolean_API.Encode(exclude_storage_req_val_);
   IF (exclude_storage_req_val_ = Fnd_Boolean_API.db_false) THEN
      exclude_storage_req_val_ := Site_Invent_Info_API.Get_Exclude_Storage_Req_Val_Db(contract_);
   END IF;
   RETURN Fnd_Boolean_API.Decode(exclude_storage_req_val_);
END Get_Exclude_Storage_Req_Val;


@Override
@UncheckedAccess
FUNCTION Get_Exclude_Storage_Req_Val_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   exclude_storage_req_val_ warehouse_tab.exclude_storage_req_val%TYPE;
BEGIN
   exclude_storage_req_val_ := super(contract_, warehouse_id_);

   IF (exclude_storage_req_val_ = Fnd_Boolean_API.db_false) THEN
      exclude_storage_req_val_ := Site_Invent_Info_API.Get_Exclude_Storage_Req_Val_Db(contract_);
   END IF;
   RETURN (exclude_storage_req_val_);
END Get_Exclude_Storage_Req_Val_Db;


@UncheckedAccess
FUNCTION Get_Excl_Storage_Req_Val_Src (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   exclude_storage_req_val_src_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.exclude_storage_req_val = Fnd_Boolean_API.db_false) THEN
      exclude_storage_req_val_src_ := Site_Invent_Info_API.Get_Excl_Storage_Req_Val_Src(contract_);
   ELSE
      exclude_storage_req_val_src_ := Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_WAREHOUSE);
   END IF;
   RETURN (exclude_storage_req_val_src_);
END Get_Excl_Storage_Req_Val_Src;


@UncheckedAccess
FUNCTION Get_Avail_Control_Id_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Avail_Control_Id_Source_Db(contract_, warehouse_id_)));
END Get_Avail_Control_Id_Source;


@UncheckedAccess
FUNCTION Get_Avail_Control_Id_Source_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   avail_control_id_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.availability_control_id IS NOT NULL) THEN
      avail_control_id_source_db_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN (avail_control_id_source_db_);
END Get_Avail_Control_Id_Source_Db;


@Override
@UncheckedAccess
FUNCTION Get_Transport_From_Whse_Level (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   transport_from_whse_level_ warehouse_tab.transport_from_whse_level%TYPE;
BEGIN
   transport_from_whse_level_ := super(contract_, warehouse_id_);
   IF (transport_from_whse_level_ IS NULL) THEN
      transport_from_whse_level_ := Site_Invent_Info_API.Get_Transport_From_Whse_Level(contract_);
   END IF;
   RETURN (transport_from_whse_level_);   
END Get_Transport_From_Whse_Level;


@UncheckedAccess
FUNCTION Get_Transport_From_Whse_Lvl_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   transport_from_whse_level_ warehouse_tab.transport_from_whse_level%TYPE;
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   transport_from_whse_level_ := micro_cache_value_.transport_from_whse_level;
   IF (transport_from_whse_level_ IS NULL) THEN
      transport_from_whse_level_ := Site_Invent_Info_API.Get_Transport_From_Whse_Lvl_Db(contract_);
   END IF;
   RETURN transport_from_whse_level_;
END Get_Transport_From_Whse_Lvl_Db;


@UncheckedAccess
FUNCTION Get_Trans_From_Whse_Lvl_Src_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   transport_from_whse_level_src_ warehouse_tab.transport_from_whse_level%TYPE;
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.transport_from_whse_level IS NULL) THEN
      transport_from_whse_level_src_ := Warehouse_Structure_Level_API.DB_SITE;
   ELSE
      transport_from_whse_level_src_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN transport_from_whse_level_src_;
END Get_Trans_From_Whse_Lvl_Src_Db;


@UncheckedAccess
FUNCTION Get_Trans_From_Whse_Level_Src (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Trans_From_Whse_Lvl_Src_Db(contract_, warehouse_id_)));
END Get_Trans_From_Whse_Level_Src;


@Override
@UncheckedAccess
FUNCTION Get_Transport_To_Whse_Level (
   contract_     IN VARCHAR2, 
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   transport_to_whse_level_ warehouse_tab.transport_to_whse_level%TYPE;
BEGIN
   transport_to_whse_level_ := super(contract_, warehouse_id_);
   IF (transport_to_whse_level_ IS NULL) THEN
      transport_to_whse_level_ := Site_Invent_Info_API.Get_Transport_To_Whse_Level(contract_);
   END IF;
   RETURN (transport_to_whse_level_);     
END Get_Transport_To_Whse_Level;


@UncheckedAccess
FUNCTION Get_Transport_To_Whse_Lvl_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   transport_to_whse_level_ warehouse_tab.transport_to_whse_level%TYPE;
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   transport_to_whse_level_ := micro_cache_value_.transport_to_whse_level;
   IF (transport_to_whse_level_ IS NULL) THEN
      transport_to_whse_level_ := Site_Invent_Info_API.Get_Transport_To_Whse_Lvl_Db(contract_);
   END IF;
   RETURN transport_to_whse_level_;
END Get_Transport_To_Whse_Lvl_Db;


@UncheckedAccess
FUNCTION Get_Trans_To_Whse_Lvl_Src_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   transport_to_whse_level_src_ warehouse_tab.transport_to_whse_level%TYPE;
BEGIN
   Update_Cache___(contract_, warehouse_id_);
   IF (micro_cache_value_.transport_to_whse_level IS NULL) THEN
      transport_to_whse_level_src_ := Warehouse_Structure_Level_API.DB_SITE;
   ELSE
      transport_to_whse_level_src_ := Warehouse_Structure_Level_API.DB_WAREHOUSE;
   END IF;
   RETURN transport_to_whse_level_src_;
END Get_Trans_To_Whse_Lvl_Src_Db;


@UncheckedAccess
FUNCTION Get_Trans_To_Whse_Level_Src (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Trans_To_Whse_Lvl_Src_Db(contract_, warehouse_id_)));
END Get_Trans_To_Whse_Level_Src;



@UncheckedAccess
FUNCTION Check_Exist (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_, warehouse_id_);
END Check_Exist;


PROCEDURE New(
   warehouse_id_                  IN OUT VARCHAR2,
   contract_                      IN     VARCHAR2, 
   description_                   IN     VARCHAR2 DEFAULT NULL,
   availability_control_id_       IN     VARCHAR2 DEFAULT NULL,
   remote_warehouse_db_           IN     VARCHAR2 DEFAULT NULL,
   putaway_destination_db_        IN     VARCHAR2 DEFAULT NULL,
   auto_refill_putaway_zones_db_  IN     VARCHAR2 DEFAULT NULL,
   auto_created_db_               IN     VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   auto_generate_warehouse_id_    IN     BOOLEAN  DEFAULT FALSE )
IS
   newrec_     warehouse_tab%ROWTYPE;
BEGIN
   newrec_.contract                  := contract_;
   IF (warehouse_id_ IS NULL AND auto_generate_warehouse_id_) THEN
      warehouse_id_ := Create_New_Warehouse_Id___(contract_);
   END IF;
   newrec_.warehouse_id              := warehouse_id_;
   newrec_.description               := NVL(description_,  newrec_.warehouse_id);
   newrec_.route_order               := newrec_.warehouse_id;
   newrec_.remote_warehouse          := remote_warehouse_db_;
   newrec_.putaway_destination       := putaway_destination_db_;
   newrec_.auto_refill_putaway_zones := auto_refill_putaway_zones_db_;
   newrec_.availability_control_id   := availability_control_id_;
   newrec_.auto_created              := auto_created_db_;
   New___(newrec_);
END New;


PROCEDURE Lock_By_Keys_Wait (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 )
IS
   dummy_ warehouse_tab%ROWTYPE;
BEGIN
   dummy_ := Lock_By_Keys___(contract_, warehouse_id_);
END Lock_By_Keys_Wait;


PROCEDURE Connect_Assortment_To_Remotes (
   contract_      IN VARCHAR2,
   assortment_id_ IN VARCHAR2 )
IS

   CURSOR get_all_remote_warehouses IS
      SELECT warehouse_id
      FROM   warehouse_tab
      WHERE  contract = contract_
      AND    remote_warehouse = Fnd_Boolean_API.DB_TRUE;

BEGIN   
   FOR whse_rec IN get_all_remote_warehouses LOOP
      -- Dont add connection if it exist, this functionality can be called several times and 
      -- we should only add connections for sites that have been added since last time
      IF (NOT Remote_Whse_Assort_Connect_API.Check_Exist(contract_, whse_rec.warehouse_id, assortment_id_)) THEN
         Remote_Whse_Assort_Connect_API.New(contract_, whse_rec.warehouse_id, assortment_id_);
      END IF;
   END LOOP;
END Connect_Assortment_To_Remotes;


@UncheckedAccess
PROCEDURE Optimize_Using_Putaway (
   contract_       IN VARCHAR2,
   warehouse_id_   IN VARCHAR2 )
IS
   message_        VARCHAR2(32000);

BEGIN   
   Warehouse_API.Exist(contract_, warehouse_id_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);

   message_ := Message_SYS.Construct('OPTIMIZE_USING_PUTAWAY');  
   Message_SYS.Add_Attribute(message_, 'CONTRACT',  contract_);
   Message_SYS.Add_Attribute(message_, 'WAREHOUSE_ID', warehouse_id_);
   Inventory_Part_In_Stock_API.Optimize_Using_Putaway(message_);
END Optimize_Using_Putaway;


@UncheckedAccess
FUNCTION Check_Supply_Control (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   availability_control_id_ warehouse_tab.availability_control_id%TYPE;
BEGIN
   IF (warehouse_id_ IS NOT NULL) THEN
      availability_control_id_ := Get_Availability_Control_id(contract_, warehouse_id_);
   END IF;
   
   RETURN Part_Availability_Control_API.Check_Supply_Control(availability_control_id_);
END Check_Supply_Control;


@UncheckedAccess
FUNCTION Check_Supply_Control (
   global_warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_ Public_Rec; 
BEGIN
   rec_ := Get(global_warehouse_id_);
     
   RETURN Check_Supply_Control(rec_.contract, rec_.warehouse_id);
END Check_Supply_Control;


FUNCTION Get_Base_Bin_Volume_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR get_volume_ IS
   SELECT bin_volume_capacity
     FROM warehouse
    WHERE contract = contract_
      AND warehouse_id = warehouse_id_;
BEGIN
   OPEN get_volume_;
   FETCH get_volume_ INTO dummy_;
   CLOSE get_volume_;
   RETURN dummy_;
END Get_Base_Bin_Volume_Capacity;


FUNCTION Check_Exist (
   global_warehouse_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   contract_     warehouse_tab.contract%TYPE;
   warehouse_id_ warehouse_tab.warehouse_id%TYPE;
BEGIN
   Get_Keys_By_Global_Id(contract_, warehouse_id_, global_warehouse_id_);
   
   RETURN Check_Exist(contract_, warehouse_id_);
END Check_Exist;


FUNCTION Get (
   global_warehouse_id_ IN VARCHAR2 ) RETURN Public_Rec 
IS
   contract_     warehouse_tab.contract%TYPE;
   warehouse_id_ warehouse_tab.warehouse_id%TYPE;
BEGIN
   Get_Keys_By_Global_Id(contract_, warehouse_id_, global_warehouse_id_);
   
   RETURN Get(contract_, warehouse_id_);
END Get;

PROCEDURE Get_Keys_By_Global_Id (
   contract_            OUT VARCHAR2,
   warehouse_id_        OUT VARCHAR2,
   global_warehouse_id_ IN  VARCHAR2 )
IS
   CURSOR fetch_warehouse_keys IS
      SELECT contract, warehouse_id
      FROM  warehouse_tab
      WHERE global_warehouse_id = global_warehouse_id_;   
BEGIN 
   IF (global_warehouse_id_ IS NOT NULL) THEN
      OPEN  fetch_warehouse_keys;
      FETCH fetch_warehouse_keys INTO contract_, warehouse_id_;
      CLOSE fetch_warehouse_keys;
   END IF;
END Get_Keys_By_Global_Id;
