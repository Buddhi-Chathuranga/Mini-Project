-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseBayBin
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220103  LEPESE  SC21R2-2766, Added handling_unit_type_capacity to Putaway_Bin_Rec. Changed function Hu_Type_Capacity_Exists___ into Get_Hu_Type_Capacity___.
--  220103          Changed function Hu_Type_Capacity_Exists into Get_Hu_Type_Capacity to return a number instead of a boolean.
--  211211  JaThlk  SC21R2-2932, Added new function Get_Default_Bin_Id.  
--  210614  SBalLK  SC21R2-1204, Added New(), Create_Parent_Structure___() and Get_First_Existing_Location() methods and modified New__() method to
--  210614          create remote warehouse automatically for the service task.
--  201109  PamPlk  SC2020R1-10310, Changed the scope of Get_New_Location_Sequence___ to private.
--  190204  ShPrlk  Bug 145405(SCZ-2180), Modified Get_Volume_Cap_And_Src_Db___ to fetch the Volume Operative Value in Bin based on the input at Tier level.
--  190103  KoDelk  SCUXXW4-15164, Added new Function Get_Base_Bin_Volume_Capacity()
--  180214  LEPESE  STRSC-16027, Added call to Inventory_Part_In_Stock_API.Get_Root_Hu_Types_In_Stock from Hu_Type_Capacity_Exists.
--  180209  LEPESE  STRSC-16027, Added call to Transport_Task_API.Get_Inbound_Handling_Units from Hu_Type_Capacity_Exists. Added method Hu_Type_Capacity_Exists___.
--  180205  LEPESE  STRSC-16027, Added method Hu_Type_Capacity_Exists.
--  170908  SBalLK  Bug 137678, Modified Bin_Is_In_Storage_Zone() method by increasing the length of the stmt_ variable to avoid character buffer too small error.
--  170630  BudKlk  Bug 136631, Added new method Get_Availability_Control_Id() to get the default availability control id set in warehouse navigator using contract and location no as parameters.
--  170419  Jhalse  LIM-10756, Modified Get_Volume_Cap_And_Src_Db___ to now properly display inherited value unless volume gets calculated or with manual override.
--  170105  LEPESE  LIM-10028, Added parameter ignore_this_handling_unit_id_ to methods Get_Free_Carrying_Capacity and Get_Free_Volume_Capacity.
--  160822  SBalLK  Bug 131006, Modified Get_Putaway_Bins() method by increasing the length of the stmt_ variable to avoid character buffer too small error.
--  160505  SeJalk  Bug 128229, Added new method Bin_Is_In_Storage_Zone to improve performance of finding the bin is in StorageZone.
--  151125  JeLise  LIM-4470, Removed method Get_First_Free_Pallet_Storage and parameter include_pallet_locations_ in Get_Putaway_Bins.
--  151106  UdGnlk  LIM-3746, Removed Inventory_Part_Loc_Pallet_API method calls since INVENTORY_PART_LOC_PALLET_TAB will be obsolete.
--  151029  JeLise  LIM-3941, Removed Location_Type_Db_Is_Pallet and Is_Pallet_Location.
--  150608  ErFelk  Bug 122945, Modified Get_Receipts_Blocked(), Get_Receipt_To_Occup_Blockd(), Get_Hide_In_Whse_Navigator(), Get_Mix_Of_Part_Number_Blocked(), 
--  150608          Get_Mix_Of_Cond_Codes_Blocked(), Get_Mix_Of_Lot_Batch_Blocked() and Get_Exclude_Storage_Req_Val() to avoid getting an error due to insufficient length.
--  150706  RILASE  COB-25, Added Is_Shipment_Location.
--  141217  KoDelk  PRSC-4354, Modified Unpack___() to avoid adding the location_sequence again when record modified called.
--  141122  NipKlk  Bug 119573, Assigned the location_sequence from the next sequence value if the location_sequence is null and set location_no 
--  141122          as location_sequence when the location_no by overriding in Unpack___().
--  141029  Maeelk  PRSC-3297, Added Get_Storage_Zone_Locations to select the set of locations connected to a storage zone id
--  140911  Erlise  PRSC-2475, Put to empty. Added attribute receipt_to_occupied_blocked.
--  140911          Added methods Get_Receipt_To_Occup_Blockd, Get_Receipt_To_Occup_Blockd_Db, Get_Parent_Rec_To_Occp_Blk_Db, 
--  140911          Get_Receipt_To_Occup_Blkd_Src and Get_Parent_Rec_To_Occp_Blk_Src.
--  140911          Changed attribute Volume_Capacity to private to remove unnecessary override annotation.
--  140512  MAHPLK  PBSC-9173, Modified Check_Insert___  and Check_Update___ method to validate the route_order for valid string.
--  140505  MaEelk  Added Receipts_Blocked fuction to check if the receipts are bloced or not in a given location.
--  140505          Replaced the code in Check_Receipts_Blocked with a call to the Receipts_Blocked function.
--  140310  LEPESE  Corrected Override problems.
--  140220  AwWelk  PBSC-7296,Added method Get_Loc_Group_By_Site_Location() to get the location_group corresponding to contract and location_no.
--  140212  Matkse  Removed use of obsolete micro cache variable micro_cache_rec_ and replaced it with micro_cache_value_.
--  130823  Matkse  Modified query in Get_Putaway_Bins, removed check for warehouses with only_scheduled_task_refill (obsolete).
--  130710  Matkse  Modified query in Get_Putaway_Bins once again, must use nested select for only_scheduled_task_refill
--                  due to ambiguous column problem from sql_where_expression with warehouse_bay_bin_tab and warehouse_tab.                
--  130709  Matkse  Modified query in Get_Putaway_Bins to dont include bins in warehouses which have only_scheduled_task_refill set.
--  130625  Matkse  Modified Get_Attr___ to handle availability_control_id.
--  130620  Matkse  Modified Clear_Storage_Chars__ to accept flag for availability_control_id.
--  121217  MAHPLK  Added new method Get_Route_Order_Strings. Modified Get_Putaway_Bins to retrieve warehouse_route_order, 
--  121217          bay_route_order, row_route_order, tier_route_order, bin_route_order.
--  121115  MaEelk  Made a call to Storage_Zone_Detail_API.Remove_Bin from Delete___ that would remove the relevent record when remind a warehouse 
--  121106  MAHPLK  Added Route_Order.
--  120904  JeLise  Changed from calling Part_Catalog_API methods to call the same methods in Part_Catalog_Invent_Attrib_API.
--  120816  RiLase  Added method Get_Media_Id().
--  121102  NipKlk  Bug 106065, Added ifs assert safe statement where its mising.
--  130531  RiLase  Added NOPALL_DROP_OFF_LOV and PALLET_DROP_OFF_LOV.
--  130521  Erlise  Added availability_control_id.
--  130521  DaZase  Changed bay_id_ to DEFAULT NULL parameter in method Get_Location_Numbers.
--  120905  Matkse  Added check for cubic capacity of volume in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  120905          Added new implementation method, Get_Volume_Cap_And_Src_Db___, used for determine source and retrieval of volume capacity.
--  120905          This new method is being called from Get_Volume_Capacity and Get_Volume_Cap_Source_Db. 
--  120821  Matkse  Modified Get_Volume_Capacity and Get_Volume_Capacity_Source by fixing a small bug leading to changes of height not to be
--                  taken into consideration when calculating volume capacity and source.
--  120814  Matkse  Modified Get_Putaway_Bins by encapsulate the use of sql_where_expression in parenthesis for increased security.
--  120802  Matkse  Modified Delete___ by adding calls to Site_Putaway_Zone_API.Remove_Bin and Invent_Part_Putaway_Zone_API.Remove_Bin
--  120626  Matkse  Modified Get_Putaway_Bins to use column sql_where_expression when selecting bins. Also removed obsolete in-parameters.
--  120604  Matkse  Added volume_capacity.
--  120417  MaEelk  Modified Get_Volume_Capacity to return LEAST(volume_capacity_,999999999999999999999999999) to avoid client errors
--  120417          when the return vlue exceeds 29 digits.
--  120310  LEPESE  Redesigned methods Get_Height_Capacity, Get_Width_Capacity, Get_Dept_Capacity, Get_Carrying_Capacity, Get_Min_Temperature, 
--  120310          Get_Max_Temperature, Get_Min_Humidity, Get_Max_Humidity, Get_Height_Capacity_Source, Get_Width_Capacity_Source,
--  120310          Get_Dept_Capacity_Source, Get_Carry_Capacity_Source, Get_Min_Temperature_Source, Get_Max_Temperature_Source, 
--  120310          Get_Min_Humidity_Source, Get_Max_Humidity_Source for better performance. Less number of calls to fetch inherited values.
--  120309  LEPESE  Changes in methods Get_Height_Capacity, Get_Width_Capacity, Get_Dept_Capacity, Get_Carrying_Capacity, Get_Min_Temperature, 
--  120309          Get_Max_Temperature, Get_Min_Humidity, Get_Max_Humidity, Get_Height_Capacity_Source, Get_Width_Capacity_Source, 
--  120309          Get_Dept_Capacity_Source, Get_Carry_Capacity_Source, Get_Min_Temperature_Source, Get_Max_Temperature_Source, 
--  120309          Get_Min_Humidity_Source and Get_Max_Humidity_Source to increase performance by avoiding unnecessary DECODE/ENCODE operations
--  120309          on Warehouse_Structure_Level. 
--  120307  LEPESE  Added method Copy_Capabilities___.
--  120217  LEPESE  Added method Exist_With_Wildcard.
--  111129  LEPESE  Added use of Utility_SYS.String_To_Number for sorting of warehouse_id, bay_id, row_id,
--  111129          tier_id and bin_id in method Get_First_Free_Pallet_Storage.
--  111121  JeLise  Added method Clear_Storage_Chars__.
--  111103  JeLise  Added exclude_storage_req_val.
--  110920  DaZase  Added functionality in Get_Attr___ and Copy__ to make sure that some capacities and conditions will not 
--  110920          be copied if from/to companies have different length, weight or temperature uoms.
--  110907  DaZase  Reversed some of my changes from 110531, so now the errors mentioned there will only happen if you try and check these chechboxes if any level above is already blocked.
--  110905  DaZase  Changed Get_Bin_Volume_Capacity so it will only return value if we have a valid volume UOM.
--  110707  MaEelk  Added user allowed site filter to WH_STORAGE_VOLUME_LOV and undefined STOR_VOL_LOV.
--  110531  DaZase  Change in Unpack_Check_Update___ so errors RECEIPTSBLKTNOUPDATE, MIXPARTSNOUPDATE, MIXCONDITIONSNOUPDATE and MIXLOTBATCHNOUPDATE 
--  110531          is happening as soon as you try to change the blocked value if any level above it is already blocked. Added methods 
--  110531          Get_Parent_Receipts_Blocked_Db, Get_Parent_Receipts_Bl_Source, Get_Parent_Mix_Of_Parts_Bl_Db, Get_Parent_Mix_Of_Part_Bl_Src, 
--  110531          Get_Parent_Mix_Of_Cond_Bl_Db, Get_Parent_Mix_Of_Cond_Bl_Src, Get_Parent_Mix_Of_Lot_Bl_Db and Get_Parent_Mix_Of_Lot_Bl_Src.
--  110526  ShKolk  Added General_SYS for Get_Free_Carrying_Capacity() and Get_Free_Volume_Capacity().
--  110509  DaZase  Corrected a double warning alias in method New__, changed the last NOROW to NOTIER.
--  110406  DaZase  Added mix_of_lot_batch_no_blocked.
--  110308  DaZase  Removed obsolete PRIORITY column.
--  110302  ChJalk  Added user_allowed_site_pub filtering to the base view.
--  110208  DaZase  Added Lock_By_Keys_Wait.
--  110126  DaZase  Added Get_Free_Volume_Capacity.
--  110110  DaZase  Added Get_Free_Carrying_Capacity.
--  110105  DaZase  Added Get_Location_Numbers.
--  101014  JeLise  Added mix_of_part_number_blocked and mix_of_cond_codes_blocked.
--  101001  DaZase  Added WH_STORAGE_VOLUME_LOV.
--  100922  DaZase  Added some more logic to Capacity/Condition Get/Get_Source methods for chosing values and source.
--  100922  JeLise  Changed from calling Incorrect_Temperature_Range and Incorrect_Humidity_Range in 
--  100922          Site_Invent_Info_API to same methods in Part_Catalog_API.
--  100830  DaZase  Added Get_Volume_Capacity.
--  100824  JeLise  Moved methods Check_Humidity, Check_Carrying_Capacity and Check_Cubic_Capacity to Part Catalog.
--  100406  DaZase  Added hide_in_whse_navigator.
--  100122  DaZase  Added changes in methods Get_First_Free_Pallet_Storage/Get_Any_Location for handling receipts_blocked.
--  100120  DaZase  Added method Check_Receipts_Blocked.
--  100115  DaZase  Added methods Get_Receipts_Blocked, Get_Receipts_Blocked_Db and Get_Receipts_Blocked_Source.
--  100114  RILASE  Added receipts_blocked.
--  091116  NaLrlk  Added uppercase check to location_no and bin_id in Unpack_Check_Insert___.
--  091027  LEPESE  Added methods Check_Humidity, Check_Carrying_Capacity and Check_Cubic_Capacity.
--  091027          Added calls to these from Unpack_Check_Insert___ and Unpack_Check_Update___.
--  091021  LEPESE  Renamed Check_Humidity_Interval and Check_Temperature_Interval into
--  091021          Check_Humidity_Range and Check_Temperature_Range.
--  091021          Modifications in Check_Humidity_Range and Check_Temperature_Range
--  091021          to use methods Site_Invent_Info_API.Incorrect_Temperature_Range and
--  091021          Site_Invent_Info_API.Incorrect_Humidity_Range to validate the ranges.
--  091008  NaLrlk  Modified the WAREHOUSE_BAY_BIN view ref columns to CASCADE check.
--  090919  LEPESE  Modifications in Get_New_Location_Sequence___ to avoid duplicates on
--  090919          combination of contract and location_no. Change in Location_Exists_On_Site
--  090919          to check on all sites if parameter contract_ is null.
--  090907  ShKolk  Modified method New__ to add a warning message for missing locations and to
--  090907          create new warehouse, bay, row, tier locations.
--  090904  LEPESE  Added methods Check_Humidity_Interval and Check_Temperature_Interval. Added
--  090904          calls to these methods in Insert___ and Update___.
--  090826  LEPESE  Added methods Copy__, Get_Attr___  and Get_New_Location_Sequence___. Made
--  090826          location_sequence insertable. Moved assignment of value to location_sequence
--  090826          from Insert___ to Prepare_Insert___. Setting location_sequence as default value
--  090826          for location_no in Prepare_Insert___.
--  090820  NaLrlk  Modified the methods Check_Delete___ and Delete___ for check the InventoryLocation LU.
--  090707  NaLrlk  Added warehouse bin characteristics public columns and respective source functions.
--  090707          Implemented Micro Cache. Added new mehods Invalidate_Cache___ and Update_Cache___.
--  090611  HoInlk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

default_bin_id_ CONSTANT VARCHAR2(3)  := '  -';

TYPE Putaway_Bin_Rec IS RECORD (
    warehouse_id                WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE,
    bay_id                      WAREHOUSE_BAY_BIN_TAB.bay_id%TYPE,
    tier_id                     WAREHOUSE_BAY_BIN_TAB.tier_id%TYPE,
    row_id                      WAREHOUSE_BAY_BIN_TAB.row_id%TYPE,
    bin_id                      WAREHOUSE_BAY_BIN_TAB.bin_id%TYPE,
    location_no                 WAREHOUSE_BAY_BIN_TAB.location_no%TYPE,
    location_group              WAREHOUSE_BAY_BIN_TAB.location_group%TYPE,
    part_stored                 NUMBER,
    height_capacity             WAREHOUSE_BAY_BIN_TAB.height_capacity%TYPE,
    width_capacity              WAREHOUSE_BAY_BIN_TAB.width_capacity%TYPE,
    dept_capacity               WAREHOUSE_BAY_BIN_TAB.dept_capacity%TYPE,
    carrying_capacity           WAREHOUSE_BAY_BIN_TAB.carrying_capacity%TYPE,
    min_temperature             WAREHOUSE_BAY_BIN_TAB.min_temperature%TYPE,
    max_temperature             WAREHOUSE_BAY_BIN_TAB.max_temperature%TYPE,
    min_humidity                WAREHOUSE_BAY_BIN_TAB.min_humidity%TYPE,
    max_humidity                WAREHOUSE_BAY_BIN_TAB.max_humidity%TYPE,
    number_of_capabilities      NUMBER,
    warehouse_route_order       WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE,
    bay_route_order             WAREHOUSE_BAY_BIN_TAB.bay_id%TYPE,
    row_route_order             WAREHOUSE_BAY_BIN_TAB.row_id%TYPE,
    tier_route_order            WAREHOUSE_BAY_BIN_TAB.tier_id%TYPE,
    bin_route_order             WAREHOUSE_BAY_BIN_TAB.bin_id%TYPE,
    handling_unit_type_capacity NUMBER );

TYPE Putaway_Bin_Tab IS TABLE OF Putaway_Bin_Rec
INDEX BY PLS_INTEGER;

TYPE Location_No_Tab IS TABLE OF VARCHAR2(35) INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------

positive_infinity_   CONSTANT NUMBER := Inventory_Putaway_Manager_API.positive_infinity_;

true_                CONSTANT VARCHAR2(4) := Fnd_Boolean_API.db_true;

false_               CONSTANT VARCHAR2(5) := Fnd_Boolean_API.db_false;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Volume_Cap_And_Src_Db___ (
   volume_capacity_           OUT WAREHOUSE_BAY_BIN_TAB.volume_capacity%TYPE,
   volume_capacity_source_db_ OUT VARCHAR2,
   contract_                  IN  VARCHAR2,
   warehouse_id_              IN  VARCHAR2,
   bay_id_                    IN  VARCHAR2,
   tier_id_                   IN  VARCHAR2,
   row_id_                    IN  VARCHAR2,
   bin_id_                    IN  VARCHAR2,
   get_capacity_              IN  BOOLEAN )
IS
   height_capacity_               WAREHOUSE_BAY_BIN_TAB.height_capacity%TYPE;
   width_capacity_                WAREHOUSE_BAY_BIN_TAB.width_capacity%TYPE;
   dept_capacity_                 WAREHOUSE_BAY_BIN_TAB.dept_capacity%TYPE;
   row_volume_capacity_source_db_ VARCHAR2(20);
   tier_volume_capacity_src_db_   VARCHAR2(20);
   tier_volume_capacity_          NUMBER;
   row_volume_capacity_           NUMBER;
BEGIN
   IF ( micro_cache_value_.volume_capacity IS NULL) THEN
      IF ((micro_cache_value_.width_capacity  IS NULL) OR
         (micro_cache_value_.height_capacity  IS NULL) OR
         (micro_cache_value_.dept_capacity    IS NULL)) THEN

         row_volume_capacity_source_db_ := Warehouse_Bay_Row_API.Get_Bin_Volume_Cap_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
         tier_volume_capacity_src_db_   := Warehouse_Bay_Tier_API.Get_Bin_Volume_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

         IF(row_volume_capacity_source_db_ IS NULL) THEN
            IF(tier_volume_capacity_src_db_ IS NULL) THEN
               -- No capacity on either ROW or TIER. Method can return NULL
               NULL;
            ELSE
               -- ROW does not have any specific capacity but TIER has it. Return capacity value from TIER
               IF (get_capacity_) THEN
                  volume_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Volume_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
               END IF;
               volume_capacity_source_db_ := tier_volume_capacity_src_db_;
            END IF;
         ELSE
            -- ROW capacity source is NOT NULL
            IF (tier_volume_capacity_src_db_ IS NULL) THEN
               -- TIER capacity source IS NULL so use capacity from ROW
               IF (get_capacity_) THEN
                  volume_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Volume_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
               END IF;
               volume_capacity_source_db_ := row_volume_capacity_source_db_;
            ELSE
               -- ROW capacity source IS NOT NULL. TIER capacity source IS NOT NULL
               IF (row_volume_capacity_source_db_ = tier_volume_capacity_src_db_) THEN
                  -- ROW and TIER has the same capacity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
                  IF (get_capacity_) THEN
                     volume_capacity_ := Warehouse_Bay_Row_API.Get_Bin_volume_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
                  END IF;
                  volume_capacity_source_db_ := row_volume_capacity_source_db_;
               ELSE
                  IF (row_volume_capacity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                     IF (tier_volume_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                        -- we need to fetch both and take the lowest
                        tier_volume_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Volume_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                        row_volume_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Volume_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                        IF (row_volume_capacity_ < tier_volume_capacity_) THEN
                           volume_capacity_           := row_volume_capacity_;
                           volume_capacity_source_db_ := row_volume_capacity_source_db_;
                        ELSE
                           volume_capacity_           := tier_volume_capacity_;
                           volume_capacity_source_db_ := tier_volume_capacity_src_db_;
                        END IF;
                     ELSE
                        -- ROW has a specific capacity entered on ROW level. TIER also has a capacity but that one is inherited
                        -- from BAY, WAREHOUSE or SITE. Use Capacity from ROW.
                        IF (get_capacity_) THEN
                           volume_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Volume_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
                        END IF;
                        volume_capacity_source_db_ := row_volume_capacity_source_db_;
                     END IF;
                  ELSE
                     -- ROW capacity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                     IF (tier_volume_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                        -- TIER capacity source is TIER, use capacity from TIER
                        IF (get_capacity_) THEN
                           volume_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Volume_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                        END IF;
                        volume_capacity_source_db_ := tier_volume_capacity_src_db_;
                     ELSE
                        -- TIER capacity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                        -- ROW  capacity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                        -- Still ROW and TIER does not have the same capacity source. This should not be a possible scenario...
                        tier_volume_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Volume_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                        row_volume_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Volume_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                        IF (row_volume_capacity_ < tier_volume_capacity_) THEN
                           volume_capacity_           := row_volume_capacity_;
                           volume_capacity_source_db_ := row_volume_capacity_source_db_;
                        ELSE
                           volume_capacity_           := tier_volume_capacity_;
                           volume_capacity_source_db_ := tier_volume_capacity_src_db_;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      ELSE
         height_capacity_ := Get_Height_Capacity(contract_, warehouse_id_, bay_id_, tier_id_,row_id_, bin_id_);
         IF (height_capacity_ IS NOT NULL) THEN
            width_capacity_ := Get_Width_Capacity(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
            IF (width_capacity_ IS NOT NULL) THEN
               dept_capacity_ := Get_Dept_Capacity(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
               IF (dept_capacity_ IS NOT NULL) THEN
                  volume_capacity_           := height_capacity_ * width_capacity_ * dept_capacity_;
                  volume_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BIN;
               END IF;
            END IF;
         END IF;
      END IF;
   ELSE
      volume_capacity_ := micro_cache_value_.volume_capacity;
      volume_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BIN;
   END IF;
      
   volume_capacity_ := LEAST(volume_capacity_, 999999999999999999999999999);
END Get_Volume_Cap_And_Src_Db___;

@UncheckedAccess
FUNCTION Get_New_Location_Sequence__ (
   contract_ IN VARCHAR2 ) RETURN NUMBER
IS
   new_location_sequence_   NUMBER;
   location_exists_on_site_ BOOLEAN;
BEGIN
   LOOP
      SELECT Inventory_Location_Sequence.nextval
         INTO new_location_sequence_
         FROM DUAL;

      location_exists_on_site_ := Location_Exists_On_Site(contract_, new_location_sequence_);
      EXIT WHEN NOT location_exists_on_site_;
   END LOOP;

   RETURN (new_location_sequence_);
END Get_New_Location_Sequence__;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   location_sequence_ WAREHOUSE_BAY_BIN_TAB.location_sequence%TYPE;
   contract_          WAREHOUSE_BAY_BIN_TAB.contract%TYPE;
BEGIN
   contract_ := Client_SYS.Get_Item_Value('CONTRACT', attr_);

   super(attr_);
   location_sequence_ := Get_New_Location_Sequence__(contract_);

   Client_SYS.Add_To_Attr('LOCATION_SEQUENCE', location_sequence_, attr_);
   Client_SYS.Add_To_Attr('LOCATION_NO', location_sequence_, attr_);
   Client_SYS.Add_To_Attr('RECEIPTS_BLOCKED_DB', false_, attr_);
   Client_SYS.Add_To_Attr('RECEIPT_TO_OCCUPIED_BLOCKED_DB', false_, attr_);
   Client_SYS.Add_To_Attr('HIDE_IN_WHSE_NAVIGATOR_DB', false_, attr_);
   Client_SYS.Add_To_Attr('MIX_OF_PART_NUMBER_BLOCKED_DB', false_, attr_);
   Client_SYS.Add_To_Attr('MIX_OF_COND_CODES_BLOCKED_DB', false_, attr_);
   Client_SYS.Add_To_Attr('MIX_OF_LOT_BATCH_NO_BLOCKED_DB', false_, attr_);
   Client_SYS.Add_To_Attr('EXCLUDE_STORAGE_REQ_VAL_DB', false_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT WAREHOUSE_BAY_BIN_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);

   -- These checks needs to be performed after storing the record
   -- because they are using the method for fetching the operative
   -- values which read the database.
   Check_Temperature_Range(newrec_.contract,
                           newrec_.warehouse_id,
                           newrec_.bay_id,
                           newrec_.tier_id,
                           newrec_.row_id,
                           newrec_.bin_id);

   Check_Humidity_Range(newrec_.contract,
                        newrec_.warehouse_id,
                        newrec_.bay_id,
                        newrec_.tier_id,
                        newrec_.row_id,
                        newrec_.bin_id);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     WAREHOUSE_BAY_BIN_TAB%ROWTYPE,
   newrec_     IN OUT WAREHOUSE_BAY_BIN_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   number_null_ NUMBER := -9999999;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Invalidation of the cache must take place immediately after the UPDATE statement!
   Invalidate_Cache___;

   IF (newrec_.location_group != oldrec_.location_group) THEN
      Inventory_Location_Manager_API.Handle_Location_Group_Change__(newrec_.contract,
                                                                    newrec_.location_no,
                                                                    oldrec_.location_group,
                                                                    newrec_.location_group);
   END IF;

   IF ((NVL(newrec_.min_temperature, number_null_) != NVL(oldrec_.min_temperature, number_null_)) OR
       (NVL(newrec_.max_temperature, number_null_) != NVL(oldrec_.max_temperature, number_null_))) THEN
      -- These checks needs to be performed after updating the record
      -- because it uses Get_Min_Temperature and Get_Max_Temperature which reads the database.
      Check_Temperature_Range(newrec_.contract,
                              newrec_.warehouse_id,
                              newrec_.bay_id,
                              newrec_.tier_id,
                              newrec_.row_id,
                              newrec_.bin_id);
   END IF;

   IF ((NVL(newrec_.min_humidity, number_null_) != NVL(oldrec_.min_humidity, number_null_)) OR
       (NVL(newrec_.max_humidity, number_null_) != NVL(oldrec_.max_humidity, number_null_))) THEN
      -- These checks needs to be performed after updating the record
      -- because it uses Get_Min_Humidity and Get_Max_Humidity which reads the database.
      Check_Humidity_Range(newrec_.contract,
                           newrec_.warehouse_id,
                           newrec_.bay_id,
                           newrec_.tier_id,
                           newrec_.row_id,
                           newrec_.bin_id);
   END IF;

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
   WHEN OTHERS THEN
      Invalidate_Cache___;
      RAISE;
END Update___;

@Override
PROCEDURE Unpack___ (
   newrec_ IN OUT warehouse_bay_bin_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   IF (newrec_.location_sequence IS NULL) THEN
      newrec_.location_sequence := Client_SYS.Get_Item_Value('LOCATION_SEQUENCE', attr_);
      indrec_.location_sequence := TRUE;
      IF (newrec_.location_sequence IS NULL) THEN
         newrec_.location_sequence :=  Get_New_Location_Sequence__(newrec_.contract);
         indrec_.location_sequence := TRUE;
      END IF;
   END IF;
   
   IF (newrec_.location_no IS NULL) THEN
      newrec_.location_no :=  newrec_.location_sequence;
      indrec_.location_no :=  TRUE;
   END IF;
   super(newrec_, indrec_, attr_);
   --Add post-processing code here
END Unpack___;




@Override
PROCEDURE Check_Delete___ (
   remrec_ IN WAREHOUSE_BAY_BIN_TAB%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   super(remrec_);

   key_ := remrec_.contract || '^' || remrec_.location_no || '^';
   Reference_SYS.Check_Restricted_Delete('InventoryLocation', key_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN WAREHOUSE_BAY_BIN_TAB%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   super(objid_, remrec_);
  
   key_ := remrec_.contract || '^' || remrec_.location_no || '^';
   Reference_SYS.Do_Cascade_Delete('InventoryLocation', key_);
   Storage_Zone_Detail_API.Remove_Bin(remrec_.contract, remrec_.warehouse_id, remrec_.bay_id, remrec_.tier_id, remrec_.row_id, remrec_.bin_id);
END Delete___;


FUNCTION Get_Attr___ (
   lu_rec_                    IN WAREHOUSE_BAY_BIN_TAB%ROWTYPE,
   include_cubic_capacity_    IN BOOLEAN,
   include_carrying_capacity_ IN BOOLEAN,
   include_temperatures_      IN BOOLEAN ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(2000);
BEGIN

   Client_SYS.Add_To_Attr('CONTRACT',                       lu_rec_.contract,                    attr_);
   Client_SYS.Add_To_Attr('WAREHOUSE_ID',                   lu_rec_.warehouse_id,                attr_);
   Client_SYS.Add_To_Attr('BAY_ID',                         lu_rec_.bay_id,                      attr_);
   Client_SYS.Add_To_Attr('ROW_ID',                         lu_rec_.row_id,                      attr_);
   Client_SYS.Add_To_Attr('TIER_ID',                        lu_rec_.tier_id,                     attr_);
   Client_SYS.Add_To_Attr('BIN_ID',                         lu_rec_.bin_id,                      attr_);
   Client_SYS.Add_To_Attr('LOCATION_NO',                    lu_rec_.location_no,                 attr_);
   Client_SYS.Add_To_Attr('LOCATION_SEQUENCE',              lu_rec_.location_sequence,           attr_);
   Client_SYS.Add_To_Attr('LOCATION_GROUP',                 lu_rec_.location_group,              attr_);
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
      IF (lu_rec_.height_capacity IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('HEIGHT_CAPACITY', lu_rec_.height_capacity, attr_);
      END IF;
      IF (lu_rec_.width_capacity IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('WIDTH_CAPACITY', lu_rec_.width_capacity, attr_);
      END IF;
      IF (lu_rec_.dept_capacity IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('DEPT_CAPACITY', lu_rec_.dept_capacity, attr_);
      END IF;
      IF (lu_rec_.volume_capacity IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('VOLUME_CAPACITY', lu_rec_.volume_capacity, attr_);
      END IF;
   END IF;

   IF (include_carrying_capacity_) THEN
      IF (lu_rec_.carrying_capacity IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('CARRYING_CAPACITY', lu_rec_.carrying_capacity, attr_);
      END IF;
   END IF;

   IF (include_temperatures_) THEN
      IF (lu_rec_.min_temperature IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('MIN_TEMPERATURE', lu_rec_.min_temperature, attr_);
      END IF;
      IF (lu_rec_.max_temperature IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('MAX_TEMPERATURE', lu_rec_.max_temperature, attr_);
      END IF;
   END IF;

   IF (lu_rec_.min_humidity IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MIN_HUMIDITY', lu_rec_.min_humidity, attr_);
   END IF;
   IF (lu_rec_.max_humidity IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MAX_HUMIDITY', lu_rec_.max_humidity, attr_);
   END IF;
   IF (lu_rec_.note_text IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', lu_rec_.note_text, attr_);
   END IF;
   
   IF (lu_rec_.availability_control_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('AVAILABILITY_CONTROL_ID', lu_rec_.availability_control_id, attr_);
   END IF;

   RETURN (attr_);
END Get_Attr___;


PROCEDURE Copy_Capabilities___ (
   from_contract_     IN VARCHAR2,
   from_warehouse_id_ IN VARCHAR2,
   from_bay_id_       IN VARCHAR2,
   from_row_id_       IN VARCHAR2,
   from_tier_id_      IN VARCHAR2,
   from_bin_id_       IN VARCHAR2,
   to_contract_       IN VARCHAR2,
   to_warehouse_id_   IN VARCHAR2,
   to_bay_id_         IN VARCHAR2,
   to_row_id_         IN VARCHAR2,
   to_tier_id_        IN VARCHAR2,
   to_bin_id_         IN VARCHAR2 )
IS
   CURSOR get_capabilities IS
      SELECT storage_capability_id
        FROM warehouse_bin_capability_tab
       WHERE contract     = from_contract_
         AND warehouse_id = from_warehouse_id_
         AND bay_id       = from_bay_id_
         AND tier_id      = from_tier_id_
         AND row_id       = from_row_id_
         AND bin_id       = from_bin_id_;
BEGIN

   FOR rec_ IN get_capabilities LOOP
      Warehouse_Bin_Capability_API.Copy__(from_contract_,
                                          from_warehouse_id_,
                                          from_bay_id_,
                                          from_tier_id_,
                                          from_row_id_,
                                          from_bin_id_,
                                          rec_.storage_capability_id,
                                          to_contract_,
                                          to_warehouse_id_,
                                          to_bay_id_,
                                          to_tier_id_,
                                          to_row_id_,
                                          to_bin_id_);
   END LOOP;
END Copy_Capabilities___;


@Override
PROCEDURE Check_Insert___ (
   newrec_              IN OUT warehouse_bay_bin_tab%ROWTYPE,
   indrec_              IN OUT Indicator_Rec,
   attr_                IN OUT VARCHAR2, 
   do_row_exist_check_  IN     BOOLEAN DEFAULT FALSE,
   do_tier_exist_check_ IN     BOOLEAN DEFAULT FALSE )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT (indrec_.route_order) THEN 
      newrec_.route_order   := newrec_.bin_id;
   END IF;
   IF NOT (indrec_.receipts_blocked) THEN
      newrec_.receipts_blocked            := false_;
   END IF;
   IF NOT (indrec_.receipt_to_occupied_blocked) THEN 
      newrec_.receipt_to_occupied_blocked := false_;
   END IF;
   IF NOT (indrec_.hide_in_whse_navigator) THEN
      newrec_.hide_in_whse_navigator      := false_;
   END IF;
   IF NOT (indrec_.mix_of_part_number_blocked) THEN
      newrec_.mix_of_part_number_blocked  := false_;
   END IF;
   IF NOT (indrec_.mix_of_cond_codes_blocked) THEN
      newrec_.mix_of_cond_codes_blocked   := false_;
   END IF;
   IF NOT (indrec_.mix_of_lot_batch_no_blocked) THEN
      newrec_.mix_of_lot_batch_no_blocked := false_;
   END IF;
   IF NOT (indrec_.exclude_storage_req_val) THEN 
      newrec_.exclude_storage_req_val     := false_;
   END IF;
   
   IF (indrec_.tier_id) THEN
      IF (do_tier_exist_check_) THEN
         Warehouse_Bay_Tier_API.Exist(newrec_.contract, newrec_.warehouse_id, newrec_.bay_id, newrec_.tier_id);
      END IF;
   END IF;
   IF (indrec_.row_id) THEN 
      IF (do_row_exist_check_) THEN
         Warehouse_Bay_Row_API.Exist(newrec_.contract, newrec_.warehouse_id, newrec_.bay_id, newrec_.row_id);
      END IF;
   END IF;

   super(newrec_, indrec_, attr_);
 
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract); 
 
   IF (newrec_.bin_id != default_bin_id_) THEN
      Error_SYS.Check_Valid_Key_String('BIN_ID', newrec_.bin_id);
   END IF;
   
   IF (newrec_.route_order != default_bin_id_) THEN
      Error_SYS.Check_Valid_Key_String('ROUTE_ORDER', newrec_.route_order);
   END IF;
   
   Error_SYS.Check_Valid_Key_String('LOCATION_NO', newrec_.location_no);

   IF (UPPER(newrec_.bin_id) != newrec_.bin_id) THEN
      Error_SYS.Record_General(lu_name_,'UPPERBINID: The Bin ID must be entered in upper-case.');
   END IF;
   IF (UPPER(newrec_.location_no) != newrec_.location_no) THEN
      Error_SYS.Record_General(lu_name_,'UPPERLOCATION: The Location No must be entered in upper-case.');
   END IF;
   IF (Location_Exists_On_Site(newrec_.contract, newrec_.location_no)) THEN
      Error_SYS.Record_Exist(lu_name_, 'EXISTONSITE: The Location No :P1 already exists on site :P2', newrec_.location_no, newrec_.contract);
   END IF;

   Part_Catalog_Invent_Attrib_API.Check_Humidity         (newrec_.min_humidity);
   Part_Catalog_Invent_Attrib_API.Check_Humidity         (newrec_.max_humidity);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.height_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.width_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.dept_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.volume_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.carrying_capacity);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     warehouse_bay_bin_tab%ROWTYPE,
   newrec_ IN OUT warehouse_bay_bin_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                        VARCHAR2(30);
   value_                       VARCHAR2(2000);
   old_location_type_db_        VARCHAR2(20);
   new_location_type_db_        VARCHAR2(20);
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

   IF (oldrec_.receipts_blocked = false_) AND (newrec_.receipts_blocked = true_) THEN
      -- Receipts Blocked has been changed from FALSE to TRUE on the Bin level.
      IF (Get_Parent_Receipts_Blocked_Db(newrec_.contract,
                                         newrec_.warehouse_id,
                                         newrec_.bay_id,
                                         newrec_.tier_id,
                                         newrec_.row_id) = true_) THEN
         -- The Bin is already blocked because either the whole Row or the whole Tier is blocked.
         receipts_blocked_source_ := Get_Parent_Receipts_Bl_Source(newrec_.contract,
                                                                   newrec_.warehouse_id,
                                                                   newrec_.bay_id,
                                                                   newrec_.tier_id,
                                                                   newrec_.row_id);
         Error_SYS.Record_General(lu_name_,'RECEIPTSBLKTNOUPDATE: Receipts are already blocked on the :P1 level of the Warehouse Structure.', receipts_blocked_source_);
      END IF;
   END IF; 
   
   IF (oldrec_.receipt_to_occupied_blocked = false_) AND (newrec_.receipt_to_occupied_blocked = true_) THEN
      -- Receipt to occupied blocked has been changed from FALSE to TRUE on the Bin level.
      IF (Get_Parent_Rec_To_Occp_Blkd_Db(newrec_.contract,
                                         newrec_.warehouse_id,
                                         newrec_.bay_id,
                                         newrec_.tier_id,
                                         newrec_.row_id) = true_) THEN
         -- The Bin is already blocked because the whole Row or the whole Tier is blocked.
         receipt_to_occup_blkd_src_ := Get_Parent_Rec_To_Occp_Blk_Src(newrec_.contract,
                                                                      newrec_.warehouse_id,
                                                                      newrec_.bay_id,
                                                                      newrec_.tier_id,
                                                                      newrec_.row_id);
         Error_SYS.Record_General(lu_name_,'RECOCCUPBLKTNOUPDATE: Receipt to occupied is already blocked on the :P1 level of the Warehouse Structure.', receipt_to_occup_blkd_src_);
      END IF;
   END IF;

   IF (oldrec_.mix_of_part_number_blocked = false_) AND (newrec_.mix_of_part_number_blocked = true_) THEN
      -- Mix of Part Numbers Blocked has been changed from FALSE to TRUE on the Bin level.
      IF (Get_Parent_Mix_Of_Parts_Bl_Db(newrec_.contract,
                                        newrec_.warehouse_id,
                                        newrec_.bay_id,
                                        newrec_.tier_id,
                                        newrec_.row_id) = true_) THEN
         -- The Bin is already blocked because either the whole Row or the whole Tier is blocked.
         mix_of_part_blocked_source_ := Get_Parent_Mix_Of_Part_Bl_Src(newrec_.contract,
                                                                      newrec_.warehouse_id,
                                                                      newrec_.bay_id,
                                                                      newrec_.tier_id,
                                                                      newrec_.row_id);
         Error_SYS.Record_General(lu_name_,'MIXPARTSNOUPDATE: Mix of Part Numbers already blocked on the :P1 level of the Warehouse Structure.', mix_of_part_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.mix_of_cond_codes_blocked = false_) AND (newrec_.mix_of_cond_codes_blocked = true_) THEN
      -- Mix of Condition Codes Blocked has been changed from FALSE to TRUE on the Bin level.
      IF (Get_Parent_Mix_Of_Cond_Bl_Db(newrec_.contract,
                                       newrec_.warehouse_id,
                                       newrec_.bay_id,
                                       newrec_.tier_id,
                                       newrec_.row_id) = true_) THEN
         -- The Bin is already blocked because either the whole Row or the whole Tier is blocked.
         mix_of_cond_blocked_source_ := Get_Parent_Mix_Of_Cond_Bl_Src(newrec_.contract,
                                                                      newrec_.warehouse_id,
                                                                      newrec_.bay_id,
                                                                      newrec_.tier_id,
                                                                      newrec_.row_id);
         Error_SYS.Record_General(lu_name_,'MIXCONDITIONSNOUPDATE: Mix of Condition Codes already blocked on the :P1 level of the Warehouse Structure.', mix_of_cond_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.mix_of_lot_batch_no_blocked = false_) AND (newrec_.mix_of_lot_batch_no_blocked = true_) THEN
      -- Mix of Lot Batch Numbers Blocked has been changed from FALSE to TRUE on the Bin level.
      IF (Get_Parent_Mix_Of_Lot_Bl_Db(newrec_.contract,
                                      newrec_.warehouse_id,
                                      newrec_.bay_id,
                                      newrec_.tier_id,
                                      newrec_.row_id) = true_) THEN
         -- The Bin is already blocked because either the whole Row or the whole Tier is blocked.
         mix_of_lot_blocked_source_ := Get_Parent_Mix_Of_Lot_Bl_Src(newrec_.contract,
                                                                    newrec_.warehouse_id,
                                                                    newrec_.bay_id,
                                                                    newrec_.tier_id,
                                                                    newrec_.row_id);
         Error_SYS.Record_General(lu_name_,'MIXLOTBATCHNOUPDATE: Mix of Lot Batch Numbers already blocked on the :P1 level of the Warehouse Structure.', mix_of_lot_blocked_source_);
      END IF;
   END IF;

   IF (oldrec_.exclude_storage_req_val = false_) AND (newrec_.exclude_storage_req_val = true_) THEN
      -- Exclude Storage Requirement Validation has been changed from FALSE to TRUE on the Bin level.
      IF (Get_Parent_Excl_Strg_Req_Db(newrec_.contract,
                                      newrec_.warehouse_id,
                                      newrec_.bay_id,
                                      newrec_.tier_id,
                                      newrec_.row_id) = true_) THEN
         -- The Bin is already excluded because whole Warehouse is excluded.
         exclude_storage_req_val_src_ := Get_Parent_Excl_Strg_Req_Src(newrec_.contract,
                                                                      newrec_.warehouse_id,
                                                                      newrec_.bay_id,
                                                                      newrec_.tier_id,
                                                                      newrec_.row_id);
         Error_SYS.Record_General(lu_name_,'EXCLSTORAGEREQUPDATE: Exclude Storage Requirement Validation already checked on the :P1 level of the Warehouse Structure.', exclude_storage_req_val_src_);
      END IF;
   END IF;
   
   IF (oldrec_.location_group != newrec_.location_group) THEN
      old_location_type_db_ := Inventory_Location_Group_API.Get_Inventory_Location_Type_Db(oldrec_.location_group);
      new_location_type_db_ := Inventory_Location_Group_API.Get_Inventory_Location_Type_Db(newrec_.location_group);
      IF (old_location_type_db_ != new_location_type_db_) THEN
         Error_SYS.Record_General(lu_name_, 'NODIFFLOCTYPE: The location group can only be replaced with another location group of the same location type.');
      END IF;
   END IF;
   
   IF (newrec_.route_order != default_bin_id_) THEN
      Error_SYS.Check_Valid_Key_String('ROUTE_ORDER', newrec_.route_order);
   END IF;
   
   IF (NVL(newrec_.min_humidity, number_null_) != NVL(oldrec_.min_humidity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.min_humidity);
   END IF;
   IF (NVL(newrec_.max_humidity, number_null_) != NVL(oldrec_.max_humidity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.max_humidity);
   END IF;
   IF (NVL(newrec_.height_capacity, number_null_) != NVL(oldrec_.height_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.height_capacity);
   END IF;
   IF (NVL(newrec_.width_capacity, number_null_) != NVL(oldrec_.width_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.width_capacity);
   END IF;
   IF (NVL(newrec_.dept_capacity,  number_null_) != NVL(oldrec_.dept_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.dept_capacity);
   END IF;
   IF (NVL(newrec_.volume_capacity, number_null_) != NVL(oldrec_.volume_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.volume_capacity);
   END IF;
   IF (NVL(newrec_.carrying_capacity, number_null_) != NVL(oldrec_.carrying_capacity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.carrying_capacity);
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


FUNCTION Get_Latest_Row_Tier_Pac___ (
   contract_           IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2, 
   tier_id_            IN VARCHAR2,
   row_id_             IN VARCHAR2,
   row_avail_ctrl_id_  IN VARCHAR2,
   tier_avail_ctrl_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   row_dummy_ DATE;
   tier_dummy_ DATE;

   CURSOR get_row IS
      SELECT rowversion
      FROM warehouse_bay_row_tab
      WHERE contract = contract_
      AND warehouse_id = warehouse_id_
      AND bay_id = bay_id_
      AND row_id = row_id_
      AND availability_control_id = row_avail_ctrl_id_;

   CURSOR get_tier IS
      SELECT rowversion
      FROM warehouse_bay_tier_tab
      WHERE contract = contract_
      AND warehouse_id = warehouse_id_
      AND bay_id = bay_id_
      AND tier_id = tier_id_
      AND availability_control_id = tier_avail_ctrl_id_;

BEGIN   
   OPEN get_row;
   FETCH get_row INTO row_dummy_;
   CLOSE get_row;

   OPEN get_tier;
   FETCH get_tier INTO tier_dummy_;
   CLOSE get_tier;
   -- Return the latest updated item..
   IF (row_dummy_ > tier_dummy_) THEN
      RETURN 'ROW';
   ELSE
      RETURN 'TIER';
   END IF;

END Get_Latest_Row_Tier_Pac___;


FUNCTION Get_Prio_Avail_Ctrl_Id_Src___(
   contract_           IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2, 
   tier_id_            IN VARCHAR2,
   row_id_             IN VARCHAR2,
   row_avail_ctrl_id_  IN VARCHAR2,
   tier_avail_ctrl_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   
BEGIN   
   -- Test according to a priority list
   
   -- 1. Supply control
   IF (Part_Availability_Control_Api.Check_Supply_Control(row_avail_ctrl_id_) != Part_Availability_Control_Api.Check_Supply_Control(tier_avail_ctrl_id_)) THEN
      -- all_equal_ := FALSE;
      IF (Part_Availability_Control_Api.Check_Supply_Control(row_avail_ctrl_id_) = 'NOT NETTABLE') THEN
         RETURN 'ROW';
      ELSE
         RETURN 'TIER';     
      END IF;
   -- 2. Order issue control
   ELSIF (Part_Availability_Control_Api.Check_Order_Issue_Control(row_avail_ctrl_id_) != Part_Availability_Control_Api.Check_Order_Issue_Control(tier_avail_ctrl_id_)) THEN
      IF (Part_Availability_Control_Api.Check_Order_Issue_Control(row_avail_ctrl_id_) = 'NOT ORDER ISSUE') THEN
         RETURN 'ROW';
      ELSE
         RETURN 'TIER';     
      END IF;
   -- 3. Auto reservation control
   ELSIF(Part_Availability_Control_Api.Check_Reservation_Control(row_avail_ctrl_id_) != Part_Availability_Control_Api.Check_Reservation_Control(tier_avail_ctrl_id_)) THEN
      IF (Part_Availability_Control_Api.Check_Reservation_Control(row_avail_ctrl_id_) = 'NOT AUTO RESERVATION') THEN
         RETURN 'ROW';
      ELSE
         RETURN 'TIER';     
      END IF;
   -- 4. Manual reservation control
   ELSIF(Part_Availability_Control_Api.Check_Man_Reservation_Control(row_avail_ctrl_id_) != Part_Availability_Control_Api.Check_Man_Reservation_Control(tier_avail_ctrl_id_)) THEN
      IF (Part_Availability_Control_Api.Check_Man_Reservation_Control(row_avail_ctrl_id_) = 'NOT_MANUAL_RESERV') THEN
         RETURN 'ROW';
      ELSE
         RETURN 'TIER';     
      END IF;
   -- 5. Non-Order issue control
   ELSIF(Part_Availability_Control_Api.Check_Noorder_Issue_Control(row_avail_ctrl_id_) != Part_Availability_Control_Api.Check_Noorder_Issue_Control(tier_avail_ctrl_id_)) THEN
      IF (Part_Availability_Control_Api.Check_Noorder_Issue_Control(row_avail_ctrl_id_) = 'NOT NON-ORDER ISSUE') THEN
         RETURN 'ROW';
      ELSE
         RETURN 'TIER';     
      END IF;
   -- 6. Scrap control
   ELSIF(Part_Availability_Control_Api.Check_Scrap_Control(row_avail_ctrl_id_) != Part_Availability_Control_Api.Check_Scrap_Control(tier_avail_ctrl_id_)) THEN
      IF (Part_Availability_Control_Api.Check_Scrap_Control(row_avail_ctrl_id_) = 'NOT SCRAPPABLE') THEN
         RETURN 'ROW';
      ELSE
         RETURN 'TIER';     
      END IF;
   -- 7. Counting control
   ELSIF(Part_Availability_Control_Api.Check_Counting_Control(row_avail_ctrl_id_) != Part_Availability_Control_Api.Check_Counting_Control(tier_avail_ctrl_id_)) THEN
      IF (Part_Availability_Control_Api.Check_Counting_Control(row_avail_ctrl_id_) = 'NOT ALLOW REDUCING') THEN
         RETURN 'ROW';
      ELSE
         RETURN 'TIER';     
      END IF;
   -- 8. Movement control
   ELSIF(Part_Availability_Control_Api.Check_Part_Movement_Control(row_avail_ctrl_id_) != Part_Availability_Control_Api.Check_Part_Movement_Control(tier_avail_ctrl_id_)) THEN
      IF (Part_Availability_Control_Api.Check_Part_Movement_Control(row_avail_ctrl_id_) = 'NOT NETTABLE') THEN
         RETURN 'ROW';
      ELSE
         RETURN 'TIER';     
      END IF;
   -- 9. Get the value from the latest updated source, ROW or TIER.
   ELSE
      RETURN Get_Latest_Row_Tier_Pac___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, row_avail_ctrl_id_, tier_avail_ctrl_id_);
   END IF;
      
END Get_Prio_Avail_Ctrl_Id_Src___;


FUNCTION Get_Hu_Type_Capacity___ (
   this_hu_type_stock_counter_   IN OUT NUMBER,
   handl_unit_type_in_stock_tab_ IN     Handling_Unit_Type_API.Unit_Type_Tab,
   hu_type_with_capacity_tab_    IN     Handling_Unit_Type_API.Unit_Type_Tab,
   this_handling_unit_type_id_   IN     VARCHAR2,
   this_hu_type_capacity_        IN     NUMBER ) RETURN NUMBER
IS
   this_hu_type_capacity_local_ NUMBER  := 0;
   other_limited_hu_type_exist_ BOOLEAN := FALSE;
   unpacked_stock_exists_       BOOLEAN := FALSE;
BEGIN
   IF (handl_unit_type_in_stock_tab_.COUNT = 0) THEN
      this_hu_type_capacity_local_ := this_hu_type_capacity_;
   ELSE
      FOR i IN handl_unit_type_in_stock_tab_.FIRST..handl_unit_type_in_stock_tab_.LAST LOOP
         IF (handl_unit_type_in_stock_tab_(i).handling_unit_type_id IS NULL) THEN
            unpacked_stock_exists_ := TRUE;
         ELSIF (handl_unit_type_in_stock_tab_(i).handling_unit_type_id = this_handling_unit_type_id_) THEN
            this_hu_type_stock_counter_ := this_hu_type_stock_counter_ + 1;
         ELSE
            unpacked_stock_exists_ := TRUE;
            IF (this_hu_type_capacity_ = positive_infinity_) AND (NOT other_limited_hu_type_exist_) THEN
               -- Since the location does not have capacity limit for the type of the HU we are investigating
               -- we need to find out if there are other HU types on this location which has a limit defined for it. 
               FOR j IN hu_type_with_capacity_tab_.FIRST..hu_type_with_capacity_tab_.LAST LOOP
                  IF (hu_type_with_capacity_tab_(j).handling_unit_type_id = handl_unit_type_in_stock_tab_(i).handling_unit_type_id) THEN
                     -- A handling unit type existing on this location has a limit defined for this location
                     other_limited_hu_type_exist_ := TRUE;
                  END IF;
               END LOOP;
            END IF;
         END IF;
      END LOOP;

      IF (this_hu_type_capacity_ = positive_infinity_) THEN
         -- This location does not have a capacity limit for the type of the handling unit we are investigating
         IF NOT (other_limited_hu_type_exist_) THEN
            -- There is no stock on this location for which there is a handling unit type capacity limit defined.
            -- And there is no capacity limit on the location for the handling unit type we are investigating either.
            this_hu_type_capacity_local_ := this_hu_type_capacity_;
         END IF;
      ELSE
         -- The location has a capacity limit for the type of the handling unit that we are investigating
         IF ((NOT unpacked_stock_exists_) AND (this_hu_type_stock_counter_ < this_hu_type_capacity_))  THEN
            -- There is no unpacked stock or stock of other handling unit types on the location and there is free capacity for this HU type
            this_hu_type_capacity_local_ := this_hu_type_capacity_ - this_hu_type_stock_counter_;
         END IF;
      END IF;
   END IF;

   RETURN (this_hu_type_capacity_local_);
END Get_Hu_Type_Capacity___;

PROCEDURE Create_Parent_Structure___(
   contract_      IN VARCHAR2,
   warehouse_id_  IN VARCHAR2,
   bay_id_        IN VARCHAR2,
   row_id_        IN VARCHAR2,
   tier_id_       IN VARCHAR2)
IS
   local_warehouse_id_ VARCHAR2(15) := warehouse_id_;
BEGIN
   IF NOT (Warehouse_API.Check_Exist(contract_, warehouse_id_)) THEN
      Warehouse_API.New(local_warehouse_id_, contract_);
   END IF;

   IF NOT (Warehouse_Bay_API.Check_Exist(contract_, warehouse_id_, bay_id_)) THEN
      Warehouse_Bay_API.New(contract_, warehouse_id_, bay_id_);
   END IF;

   IF NOT (Warehouse_Bay_Row_API.Check_Exist(contract_, warehouse_id_, bay_id_, row_id_)) THEN
      Warehouse_Bay_Row_API.New(contract_, warehouse_id_, bay_id_, row_id_);
   END IF;

   IF NOT (Warehouse_Bay_Tier_API.Check_Exist(contract_, warehouse_id_, bay_id_, tier_id_)) THEN
      Warehouse_Bay_Tier_API.New(contract_, warehouse_id_, bay_id_, tier_id_);
   END IF;
END Create_Parent_Structure___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_            WAREHOUSE_BAY_BIN_TAB%ROWTYPE;
   warehouse_warning_ VARCHAR2(2000);
   bay_warning_       VARCHAR2(2000);
   row_warning_       VARCHAR2(2000);
   tier_warning_      VARCHAR2(2000);
   warning_message_   VARCHAR2(2000);
BEGIN
   IF (action_ = 'CHECK')THEN 
      newrec_.contract     := Client_SYS.Get_Item_Value('CONTRACT', attr_);
      newrec_.warehouse_id := Client_SYS.Get_Item_Value('WAREHOUSE_ID', attr_);
      newrec_.bay_id       := Client_SYS.Get_Item_Value('BAY_ID', attr_);
      newrec_.row_id       := Client_SYS.Get_Item_Value('ROW_ID', attr_);
      newrec_.tier_id      := Client_SYS.Get_Item_Value('TIER_ID', attr_);

      IF NOT (Warehouse_API.Check_Exist(newrec_.contract,
                                        newrec_.warehouse_id)) THEN
         warehouse_warning_ := Language_SYS.Translate_Constant(lu_name_,'NOWAREHOUSE: Warehouse :P1 will be created on Site :P2. ', NULL, newrec_.warehouse_id, newrec_.contract);
      END IF;

      IF (newrec_.bay_id != Warehouse_Bay_API.default_bay_id_) THEN
         IF NOT (Warehouse_Bay_API.Check_Exist(newrec_.contract,
                                               newrec_.warehouse_id,
                                               newrec_.bay_id)) THEN
            bay_warning_ := Language_SYS.Translate_Constant(lu_name_,'NOBAY: Bay :P1 will be created in Warehouse :P2. ', NULL, newrec_.bay_id, newrec_.warehouse_id);
         END IF;
      END IF;

      IF (newrec_.row_id != Warehouse_Bay_Row_API.default_row_id_) THEN
         IF NOT (Warehouse_Bay_Row_API.Check_Exist(newrec_.contract,
                                                   newrec_.warehouse_id,
                                                   newrec_.bay_id,
                                                   newrec_.row_id)) THEN
            row_warning_ := Language_SYS.Translate_Constant(lu_name_,'NOROW: Row :P1 will be created in Bay :P2. ', NULL, newrec_.row_id, newrec_.bay_id);
         END IF;
      END IF;

      IF (newrec_.tier_id != Warehouse_Bay_Tier_API.default_tier_id_) THEN
         IF NOT (Warehouse_Bay_Tier_API.Check_Exist(newrec_.contract,
                                                    newrec_.warehouse_id,
                                                    newrec_.bay_id,
                                                    newrec_.tier_id)) THEN
            tier_warning_ := Language_SYS.Translate_Constant(lu_name_,'NOTIER: Tier :P1 will be created in Bay :P2. ', NULL, newrec_.tier_id, newrec_.bay_id);
         END IF;
      END IF;

      warning_message_ := warehouse_warning_||bay_warning_||row_warning_||tier_warning_;

      IF (warning_message_ IS NOT NULL) THEN
         Client_SYS.Add_Warning(lu_name_, warning_message_);
      END IF;
   ELSIF (action_ = 'DO') THEN
      newrec_.contract     := Client_SYS.Get_Item_Value('CONTRACT', attr_);
      newrec_.warehouse_id := Client_SYS.Get_Item_Value('WAREHOUSE_ID', attr_);
      newrec_.bay_id       := Client_SYS.Get_Item_Value('BAY_ID', attr_);
      newrec_.row_id       := Client_SYS.Get_Item_Value('ROW_ID', attr_);
      newrec_.tier_id      := Client_SYS.Get_Item_Value('TIER_ID', attr_);
      
      Create_Parent_Structure___(newrec_.contract, newrec_.warehouse_id, newrec_.bay_id, newrec_.row_id, newrec_.tier_id);
   END IF;
   
   super(info_, objid_, objversion_, attr_, action_);
END New__;

PROCEDURE Copy__ (
   from_contract_          IN VARCHAR2,
   from_warehouse_id_      IN VARCHAR2,
   from_bay_id_            IN VARCHAR2,
   from_row_id_            IN VARCHAR2,
   from_tier_id_           IN VARCHAR2,
   from_bin_id_            IN VARCHAR2,
   to_contract_            IN VARCHAR2,
   to_warehouse_id_        IN VARCHAR2,
   to_bay_id_              IN VARCHAR2,
   to_row_id_              IN VARCHAR2,
   to_tier_id_             IN VARCHAR2,
   to_bin_id_              IN VARCHAR2,
   copy_cubic_capacity_    IN BOOLEAN,
   copy_carrying_capacity_ IN BOOLEAN,
   copy_temperatures_      IN BOOLEAN )
IS
   newrec_         WAREHOUSE_BAY_BIN_TAB%ROWTYPE;
   empty_rec_      WAREHOUSE_BAY_BIN_TAB%ROWTYPE;
   attr_           VARCHAR2(2000);
   objid_          VARCHAR2(2000);
   objversion_     VARCHAR2(2000);
   exit_procedure_ EXCEPTION;
   indrec_         Indicator_Rec;
BEGIN

   Exist(from_contract_,
         from_warehouse_id_,
         from_bay_id_,
         from_tier_id_,
         from_row_id_,
         from_bin_id_);

   Warehouse_Bay_API.Exist(to_contract_, to_warehouse_id_, to_bay_id_);

   IF (Check_Exist___(to_contract_,
                      to_warehouse_id_,
                      to_bay_id_,
                      to_tier_id_,
                      to_row_id_,
                      to_bin_id_)) THEN
      RAISE exit_procedure_;
   END IF;

   IF NOT (Warehouse_Bay_Row_API.Check_Exist(to_contract_,
                                             to_warehouse_id_,
                                             to_bay_id_,
                                             to_row_id_)) THEN
      RAISE exit_procedure_;
   END IF;

   IF NOT (Warehouse_Bay_Tier_API.Check_Exist(to_contract_,
                                              to_warehouse_id_,
                                              to_bay_id_,
                                              to_tier_id_)) THEN
      RAISE exit_procedure_;
   END IF;

   newrec_                   := Get_Object_By_Keys___(from_contract_,
                                                      from_warehouse_id_,
                                                      from_bay_id_,
                                                      from_tier_id_,
                                                      from_row_id_,
                                                      from_bin_id_);
   newrec_.contract          := to_contract_;
   newrec_.warehouse_id      := to_warehouse_id_;
   newrec_.bay_id            := to_bay_id_;
   newrec_.row_id            := to_row_id_;
   newrec_.tier_id           := to_tier_id_;
   newrec_.bin_id            := to_bin_id_;
   newrec_.location_sequence := Get_New_Location_Sequence__(newrec_.contract);
   newrec_.location_no       := newrec_.location_sequence;
   attr_                     := Get_Attr___(newrec_, copy_cubic_capacity_, copy_cubic_capacity_, copy_temperatures_);
   newrec_                   := empty_rec_;

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_, TRUE, TRUE);
   Insert___(objid_, objversion_, newrec_, attr_);

   Copy_Capabilities___(from_contract_,
                        from_warehouse_id_,
                        from_bay_id_,
                        from_row_id_,
                        from_tier_id_,
                        from_bin_id_,
                        to_contract_,
                        to_warehouse_id_,
                        to_bay_id_,
                        to_row_id_,
                        to_tier_id_,
                        to_bin_id_);
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Copy__;


PROCEDURE Clear_Storage_Chars__ (
   contract_                      IN VARCHAR2,
   warehouse_id_                  IN VARCHAR2,
   bay_id_                        IN VARCHAR2,
   tier_id_                       IN VARCHAR2,
   row_id_                        IN VARCHAR2,
   bin_id_                        IN VARCHAR2,
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
   newrec_     WAREHOUSE_BAY_BIN_TAB%ROWTYPE;
   oldrec_     WAREHOUSE_BAY_BIN_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN

   IF (receipts_blocked_db_) THEN
      Client_SYS.Add_To_Attr('RECEIPTS_BLOCKED_DB', false_, attr_);
   END IF;
   IF (receipt_to_occup_blocked_db_) THEN
      Client_SYS.Add_To_Attr('RECEIPT_TO_OCCUPIED_BLOCKED_DB', false_, attr_);
   END IF;
   IF (mix_of_part_number_blocked_db_) THEN 
      Client_SYS.Add_To_Attr('MIX_OF_PART_NUMBER_BLOCKED_DB', false_, attr_);
   END IF;
   IF (mix_of_cond_codes_blocked_db_) THEN
      Client_SYS.Add_To_Attr('MIX_OF_COND_CODES_BLOCKED_DB', false_, attr_);
   END IF;
   IF (mix_of_lot_batch_blocked_db_) THEN
      Client_SYS.Add_To_Attr('MIX_OF_LOT_BATCH_NO_BLOCKED_DB', false_, attr_);
   END IF;
   IF (exclude_storage_req_val_db_) THEN
      Client_SYS.Add_To_Attr('EXCLUDE_STORAGE_REQ_VAL_DB', false_, attr_);
   END IF;
   IF (hide_in_whse_navigator_db_) THEN
      Client_SYS.Add_To_Attr('HIDE_IN_WHSE_NAVIGATOR_DB', false_, attr_);
   END IF;
   IF (bin_width_capacity_db_) THEN
      Client_SYS.Add_To_Attr('WIDTH_CAPACITY', to_number(NULL), attr_);
   END IF;
   IF (bin_height_capacity_db_) THEN
      Client_SYS.Add_To_Attr('HEIGHT_CAPACITY', to_number(NULL), attr_);
   END IF;
   IF (bin_dept_capacity_db_) THEN
      Client_SYS.Add_To_Attr('DEPT_CAPACITY', to_number(NULL), attr_);
   END IF;
   IF (bin_volume_capacity_db_) THEN
      Client_SYS.Add_To_Attr('VOLUME_CAPACITY', to_number(NULL), attr_);
   END IF;
   IF (bin_carrying_capacity_db_) THEN
      Client_SYS.Add_To_Attr('CARRYING_CAPACITY', to_number(NULL), attr_);
   END IF;
   IF (bin_min_temperature_db_) THEN
      Client_SYS.Add_To_Attr('MIN_TEMPERATURE', to_number(NULL), attr_);
   END IF;
   IF (bin_max_temperature_db_) THEN
      Client_SYS.Add_To_Attr('MAX_TEMPERATURE', to_number(NULL), attr_);
   END IF;
   IF (bin_min_humidity_db_) THEN
      Client_SYS.Add_To_Attr('MIN_HUMIDITY', to_number(NULL), attr_);
   END IF;
   IF (bin_max_humidity_db_) THEN
      Client_SYS.Add_To_Attr('MAX_HUMIDITY', to_number(NULL), attr_);
   END IF;
   IF (availability_control_id_db_) THEN
      Client_SYS.Add_To_Attr('AVAILABILITY_CONTROL_ID', to_number(NULL), attr_);
   END IF;
   
   oldrec_ := Lock_By_Keys___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   
   IF (capabilities_db_) THEN
      Warehouse_Bin_Capability_API.Clear_Storage_Capabilities__(contract_, 
                                                                warehouse_id_, 
                                                                bay_id_,
                                                                tier_id_, 
                                                                row_id_,
                                                                bin_id_,
                                                                all_capabilities_db_,
                                                                capability_tab_);
   END IF; 
END Clear_Storage_Chars__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New(
   location_no_    IN OUT VARCHAR2,
   contract_       IN     VARCHAR2,
   warehouse_id_   IN     VARCHAR2,
   location_group_ IN     VARCHAR2,
   bay_id_         IN     VARCHAR2,
   tier_id_        IN     VARCHAR2,
   row_id_         IN     VARCHAR2,
   bin_id_         IN     VARCHAR2 )
IS
   newrec_ warehouse_bay_bin_tab%ROWTYPE;
BEGIN
   newrec_.location_sequence := Get_New_Location_Sequence__(newrec_.contract);
   location_no_              := NVL(location_no_, newrec_.location_sequence);
   newrec_.location_no       := location_no_;
   newrec_.contract          := contract_;
   newrec_.warehouse_id      := warehouse_id_;
   newrec_.location_group    := location_group_;
   newrec_.bay_id            := bay_id_;
   newrec_.tier_id           := tier_id_;
   newrec_.row_id            := row_id_;
   newrec_.bin_id            := bin_id_;

   Create_Parent_Structure___(newrec_.contract, newrec_.warehouse_id, newrec_.bay_id, newrec_.row_id, newrec_.tier_id);
   New___(newrec_);
END New;


FUNCTION Get_First_Existing_Location(
   contract_         IN VARCHAR2,
   warehouse_id_     IN VARCHAR2,
   location_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_first_existing_location IS
      SELECT location_no
      FROM   warehouse_bay_bin_tab
      WHERE  contract     = contract_
      AND    warehouse_id = warehouse_id_
      AND    location_group IN (SELECT location_group
                                FROM   inventory_location_group_tab
                                WHERE  inventory_location_type = location_type_db_);
   
   location_no_ warehouse_bay_bin_tab.location_no%TYPE;
BEGIN
   OPEN get_first_existing_location;
   FETCH get_first_existing_location INTO location_no_;
   CLOSE get_first_existing_location;
   RETURN location_no_;
END Get_First_Existing_Location;


@Override
@UncheckedAccess
FUNCTION Get_Height_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   height_capacity_               WAREHOUSE_BAY_BIN_TAB.height_capacity%TYPE;
   row_height_capacity_           WAREHOUSE_BAY_BIN_TAB.height_capacity%TYPE;
   tier_height_capacity_          WAREHOUSE_BAY_BIN_TAB.height_capacity%TYPE;
   row_height_capacity_source_db_ VARCHAR2(20);
   tier_height_capacity_src_db_   VARCHAR2(20);
BEGIN
   
   height_capacity_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (height_capacity_ IS NULL) THEN

      row_height_capacity_source_db_ := Warehouse_Bay_Row_API.Get_Bin_Height_Cap_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_height_capacity_src_db_   := Warehouse_Bay_Tier_API.Get_Bin_Height_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_height_capacity_source_db_ IS NULL) THEN
         IF (tier_height_capacity_src_db_ IS NULL) THEN
            -- No capacity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific capacity but TIER has it. Return capacity value from TIER
            height_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Height_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
         END IF;
      ELSE
         -- ROW capacity source is NOT NULL
         IF (tier_height_capacity_src_db_ IS NULL) THEN
            -- TIER capacity source IS NULL so use capacity from ROW
            height_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Height_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
         ELSE
            -- ROW capacity source IS NOT NULL. TIER capacity source IS NOT NULL
            IF (row_height_capacity_source_db_ = tier_height_capacity_src_db_) THEN
               -- ROW and TIER has the same capacity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               height_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Height_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
            ELSE
               IF (row_height_capacity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_height_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_height_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Height_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_height_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Height_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_height_capacity_ < tier_height_capacity_) THEN
                        height_capacity_ := row_height_capacity_;
                     ELSE
                        height_capacity_ := tier_height_capacity_;
                     END IF;
                  ELSE
                     -- ROW has a specific capacity entered on ROW level. TIER also has a capacity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use Capacity from ROW.
                     height_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Height_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
                  END IF;
               ELSE
                  -- ROW capacity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_height_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER capacity source is TIER, use capacity from TIER
                     height_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Height_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                  ELSE
                  -- TIER capacity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  capacity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same capacity source. This should not be a possible scenario...
                     tier_height_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Height_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_height_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Height_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_height_capacity_ < tier_height_capacity_) THEN
                        height_capacity_ := row_height_capacity_;
                     ELSE
                        height_capacity_ := tier_height_capacity_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (height_capacity_);
END Get_Height_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Width_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   width_capacity_               WAREHOUSE_BAY_BIN_TAB.width_capacity%TYPE;
   row_width_capacity_           WAREHOUSE_BAY_BIN_TAB.width_capacity%TYPE;
   tier_width_capacity_          WAREHOUSE_BAY_BIN_TAB.width_capacity%TYPE;
   row_width_capacity_source_db_ VARCHAR2(20);
   tier_width_capacity_src_db_   VARCHAR2(20);
BEGIN
   width_capacity_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (width_capacity_ IS NULL) THEN

      row_width_capacity_source_db_ := Warehouse_Bay_Row_API.Get_Bin_width_Cap_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_width_capacity_src_db_   := Warehouse_Bay_Tier_API.Get_Bin_width_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_width_capacity_source_db_ IS NULL) THEN
         IF (tier_width_capacity_src_db_ IS NULL) THEN
            -- No capacity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific capacity but TIER has it. Return capacity value from TIER
            width_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Width_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
         END IF;
      ELSE
         -- ROW capacity source is NOT NULL
         IF (tier_width_capacity_src_db_ IS NULL) THEN
            -- TIER capacity source IS NULL so use capacity from ROW
            width_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Width_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
         ELSE
            -- ROW capacity source IS NOT NULL. TIER capacity source IS NOT NULL
            IF (row_width_capacity_source_db_ = tier_width_capacity_src_db_) THEN
               -- ROW and TIER has the same capacity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               width_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Width_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
            ELSE
               IF (row_width_capacity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_width_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_width_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Width_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_width_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Width_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_width_capacity_ < tier_width_capacity_) THEN
                        width_capacity_ := row_width_capacity_;
                     ELSE
                        width_capacity_ := tier_width_capacity_;
                     END IF;
                  ELSE
                     -- ROW has a specific capacity entered on ROW level. TIER also has a capacity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use Capacity from ROW.
                     width_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Width_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
                  END IF;
               ELSE
                  -- ROW capacity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_width_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER capacity source is TIER, use capacity from TIER
                     width_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Width_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                  ELSE
                  -- TIER capacity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  capacity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same capacity source. This should not be a possible scenario...
                     tier_width_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Width_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_width_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Width_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_width_capacity_ < tier_width_capacity_) THEN
                        width_capacity_ := row_width_capacity_;
                     ELSE
                        width_capacity_ := tier_width_capacity_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (width_capacity_);
END Get_Width_Capacity;


@Override
@UncheckedAccess
FUNCTION Get_Dept_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   dept_capacity_               WAREHOUSE_BAY_BIN_TAB.dept_capacity%TYPE;
   row_dept_capacity_           WAREHOUSE_BAY_BIN_TAB.dept_capacity%TYPE;
   tier_dept_capacity_          WAREHOUSE_BAY_BIN_TAB.dept_capacity%TYPE;
   row_dept_capacity_source_db_ VARCHAR2(20);
   tier_dept_capacity_src_db_   VARCHAR2(20);
BEGIN
   dept_capacity_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (dept_capacity_ IS NULL) THEN

      row_dept_capacity_source_db_ := Warehouse_Bay_Row_API.Get_Bin_dept_Cap_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_dept_capacity_src_db_   := Warehouse_Bay_Tier_API.Get_Bin_dept_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_dept_capacity_source_db_ IS NULL) THEN
         IF (tier_dept_capacity_src_db_ IS NULL) THEN
            -- No capacity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific capacity but TIER has it. Return capacity value from TIER
            dept_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Dept_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
         END IF;
      ELSE
         -- ROW capacity source is NOT NULL
         IF (tier_dept_capacity_src_db_ IS NULL) THEN
            -- TIER capacity source IS NULL so use capacity from ROW
            dept_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Dept_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
         ELSE
            -- ROW capacity source IS NOT NULL. TIER capacity source IS NOT NULL
            IF (row_dept_capacity_source_db_ = tier_dept_capacity_src_db_) THEN
               -- ROW and TIER has the same capacity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               dept_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Dept_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
            ELSE
               IF (row_dept_capacity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_dept_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_dept_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Dept_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_dept_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Dept_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_dept_capacity_ < tier_dept_capacity_) THEN
                        dept_capacity_ := row_dept_capacity_;
                     ELSE
                        dept_capacity_ := tier_dept_capacity_;
                     END IF;
                  ELSE
                     -- ROW has a specific capacity entered on ROW level. TIER also has a capacity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use Capacity from ROW.
                     dept_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Dept_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
                  END IF;
               ELSE
                  -- ROW capacity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_dept_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER capacity source is TIER, use capacity from TIER
                     dept_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Dept_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                  ELSE
                  -- TIER capacity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  capacity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same capacity source. This should not be a possible scenario...
                     tier_dept_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Dept_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_dept_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Dept_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_dept_capacity_ < tier_dept_capacity_) THEN
                        dept_capacity_ := row_dept_capacity_;
                     ELSE
                        dept_capacity_ := tier_dept_capacity_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (dept_capacity_);
END Get_Dept_Capacity;


@UncheckedAccess
FUNCTION Get_Volume_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   volume_capacity_ WAREHOUSE_BAY_BIN_TAB.volume_capacity%TYPE;
   dummy_           VARCHAR2(20);
BEGIN
   IF (Site_Invent_Info_API.Get_Volume_Uom(contract_) IS NOT NULL) THEN
      Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
      Get_Volume_Cap_And_Src_Db___(volume_capacity_,
                                   dummy_,
                                   contract_,
                                   warehouse_id_,
                                   bay_id_,
                                   tier_id_,
                                   row_id_,
                                   bin_id_,
                                   get_capacity_ => TRUE);
   END IF;
   RETURN (volume_capacity_);
END Get_Volume_Capacity;


@UncheckedAccess
FUNCTION Get_Volume_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_                     WAREHOUSE_BAY_BIN_TAB.volume_capacity%TYPE;               
   volume_capacity_source_db_ VARCHAR2(20);
BEGIN
   IF (Site_Invent_Info_API.Get_Volume_Uom(contract_) IS NOT NULL) THEN
       Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_,row_id_, bin_id_);
       dummy_ := micro_cache_value_.volume_capacity;

      IF( dummy_ IS NULL) THEN
         Get_Volume_Cap_And_Src_Db___(dummy_,
                                     volume_capacity_source_db_,
                                     contract_,
                                     warehouse_id_,
                                     bay_id_,
                                     tier_id_,
                                     row_id_,
                                     bin_id_,
                                     get_capacity_ => FALSE);
      ELSE
         volume_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BIN;
      END IF;
   END IF;
   RETURN Warehouse_Structure_level_API.Decode(volume_capacity_source_db_);
END Get_Volume_Capacity_Source;


@Override
@UncheckedAccess
FUNCTION Get_Carrying_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   carrying_capacity_           WAREHOUSE_BAY_BIN_TAB.carrying_capacity%TYPE;
   row_carrying_capacity_       WAREHOUSE_BAY_BIN_TAB.carrying_capacity%TYPE;
   tier_carrying_capacity_      WAREHOUSE_BAY_BIN_TAB.carrying_capacity%TYPE;
   row_carrying_cap_source_db_  VARCHAR2(20);
   tier_carrying_cap_source_db_ VARCHAR2(20);
BEGIN
   carrying_capacity_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (carrying_capacity_ IS NULL) THEN

      row_carrying_cap_source_db_  := Warehouse_Bay_Row_API.Get_Bin_Carry_Cap_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_carrying_cap_source_db_ := Warehouse_Bay_Tier_API.Get_Bin_Carry_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_carrying_cap_source_db_ IS NULL) THEN
         IF (tier_carrying_cap_source_db_ IS NULL) THEN
            -- No capacity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific capacity but TIER has it. Return capacity value from TIER
            carrying_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Carrying_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
         END IF;
      ELSE
         -- ROW capacity source is NOT NULL
         IF (tier_carrying_cap_source_db_ IS NULL) THEN
            -- TIER capacity source IS NULL so use capacity from ROW
            carrying_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Carrying_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
         ELSE
            -- ROW capacity source IS NOT NULL. TIER capacity source IS NOT NULL
            IF (row_carrying_cap_source_db_ = tier_carrying_cap_source_db_) THEN
               -- ROW and TIER has the same capacity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               carrying_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Carrying_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
            ELSE
               IF (row_carrying_cap_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_carrying_cap_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_carrying_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Carrying_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_carrying_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Carrying_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_carrying_capacity_ < tier_carrying_capacity_) THEN
                        carrying_capacity_ := row_carrying_capacity_;
                     ELSE
                        carrying_capacity_ := tier_carrying_capacity_;
                     END IF;
                  ELSE
                     -- ROW has a specific capacity entered on ROW level. TIER also has a capacity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use Capacity from ROW.
                     carrying_capacity_ := Warehouse_Bay_Row_API.Get_Bin_Carrying_Capacity(contract_, warehouse_id_, bay_id_, row_id_ );
                  END IF;
               ELSE
                  -- ROW capacity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_carrying_cap_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER capacity source is TIER, use capacity from TIER
                     carrying_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Carrying_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                  ELSE
                  -- TIER capacity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  capacity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same capacity source. This should not be a possible scenario...
                     tier_carrying_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Carrying_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_carrying_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Carrying_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_carrying_capacity_ < tier_carrying_capacity_) THEN
                        carrying_capacity_ := row_carrying_capacity_;
                     ELSE
                        carrying_capacity_ := tier_carrying_capacity_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (carrying_capacity_);
END Get_Carrying_Capacity;


@UncheckedAccess
FUNCTION Get_Loc_Group_By_Site_Location(
   contract_    IN VARCHAR2,
   location_no_ IN VARCHAR2)RETURN VARCHAR2
IS
   location_group_ VARCHAR2(5);
   
   CURSOR get_loc_group IS 
      SELECT location_group 
        FROM warehouse_bay_bin_tab
       WHERE contract    = contract_
       AND   location_no = location_no_;
BEGIN
   OPEN  get_loc_group;
   FETCH get_loc_group INTO location_group_;
   CLOSE get_loc_group;

   RETURN location_group_;
END Get_Loc_Group_By_Site_Location;

@Override
@UncheckedAccess
FUNCTION Get_Min_Temperature (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   min_temperature_               WAREHOUSE_BAY_BIN_TAB.min_temperature%TYPE;
   row_min_temperature_           WAREHOUSE_BAY_BIN_TAB.min_temperature%TYPE;
   tier_min_temperature_          WAREHOUSE_BAY_BIN_TAB.min_temperature%TYPE;
   row_min_temperature_source_db_ VARCHAR2(20);
   tier_min_temperature_src_db_   VARCHAR2(20);
BEGIN
   min_temperature_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (min_temperature_ IS NULL) THEN

      row_min_temperature_source_db_ := Warehouse_Bay_Row_API.Get_Bin_Min_Temp_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_min_temperature_src_db_   := Warehouse_Bay_Tier_API.Get_Bin_Min_Temp_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_min_temperature_source_db_ IS NULL) THEN
         IF (tier_min_temperature_src_db_ IS NULL) THEN
            -- No min temperature on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific min temperature but TIER has it. Return min temperature value from TIER
            min_temperature_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);
         END IF;
      ELSE
         -- ROW min temperature source is NOT NULL
         IF (tier_min_temperature_src_db_ IS NULL) THEN
            -- TIER min temperature source IS NULL so use min temperature from ROW
            min_temperature_ := Warehouse_Bay_Row_API.Get_Bin_Min_Temperature(contract_, warehouse_id_, bay_id_, row_id_ );
         ELSE
            -- ROW min temperature source IS NOT NULL. TIER min temperature source IS NOT NULL
            IF (row_min_temperature_source_db_ = tier_min_temperature_src_db_) THEN
               -- ROW and TIER has the same min temperature source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               min_temperature_ := Warehouse_Bay_Row_API.Get_Bin_Min_Temperature(contract_, warehouse_id_, bay_id_, row_id_ );
            ELSE
               IF (row_min_temperature_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_min_temperature_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_min_temperature_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_min_temperature_  := Warehouse_Bay_Row_API.Get_Bin_Min_Temperature (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_min_temperature_ < tier_min_temperature_) THEN
                        min_temperature_ := row_min_temperature_;
                     ELSE
                        min_temperature_ := tier_min_temperature_;
                     END IF;
                  ELSE
                     -- ROW has a specific min temperature entered on ROW level. TIER also has a min temperature but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use min temperature from ROW.
                     min_temperature_ := Warehouse_Bay_Row_API.Get_Bin_Min_Temperature(contract_, warehouse_id_, bay_id_, row_id_ );
                  END IF;
               ELSE
                  -- ROW min temperature source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_min_temperature_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER min temperature source is TIER, use min temperature from TIER
                     min_temperature_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);
                  ELSE
                  -- TIER min temperature source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  min temperature source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same min temperature source. This should not be a possible scenario...
                     tier_min_temperature_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_min_temperature_  := Warehouse_Bay_Row_API.Get_Bin_Min_Temperature (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_min_temperature_ < tier_min_temperature_) THEN
                        min_temperature_ := row_min_temperature_;
                     ELSE
                        min_temperature_ := tier_min_temperature_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (min_temperature_);
END Get_Min_Temperature;


@Override
@UncheckedAccess
FUNCTION Get_Max_Temperature (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   max_temperature_               WAREHOUSE_BAY_BIN_TAB.max_temperature%TYPE;
   row_max_temperature_           WAREHOUSE_BAY_BIN_TAB.max_temperature%TYPE;
   tier_max_temperature_          WAREHOUSE_BAY_BIN_TAB.max_temperature%TYPE;
   row_max_temperature_source_db_ VARCHAR2(20);
   tier_max_temperature_src_db_   VARCHAR2(20);
BEGIN
   max_temperature_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (max_temperature_ IS NULL) THEN

      row_max_temperature_source_db_ := Warehouse_Bay_Row_API.Get_Bin_Max_Temp_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_max_temperature_src_db_   := Warehouse_Bay_Tier_API.Get_Bin_Max_Temp_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_max_temperature_source_db_ IS NULL) THEN
         IF (tier_max_temperature_src_db_ IS NULL) THEN
            -- No max temperature on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific max temperature but TIER has it. Return max temperature value from TIER
            max_temperature_ := Warehouse_Bay_Tier_API.Get_Bin_Max_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);
         END IF;
      ELSE
         -- ROW max temperature source is NOT NULL
         IF (tier_max_temperature_src_db_ IS NULL) THEN
            -- TIER max temperature source IS NULL so use max temperature from ROW
            max_temperature_ := Warehouse_Bay_Row_API.Get_Bin_Max_Temperature(contract_, warehouse_id_, bay_id_, row_id_ );
         ELSE
            -- ROW max temperature source IS NOT NULL. TIER max temperature source IS NOT NULL
            IF (row_max_temperature_source_db_ = tier_max_temperature_src_db_) THEN
               -- ROW and TIER has the same max temperature source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               max_temperature_ := Warehouse_Bay_Row_API.Get_Bin_Max_Temperature(contract_, warehouse_id_, bay_id_, row_id_ );
            ELSE
               IF (row_max_temperature_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_max_temperature_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the highest
                     tier_max_temperature_ := Warehouse_Bay_Tier_API.Get_Bin_Max_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_max_temperature_  := Warehouse_Bay_Row_API.Get_Bin_Max_Temperature (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_max_temperature_ < tier_max_temperature_) THEN
                        max_temperature_ := tier_max_temperature_;
                     ELSE
                        max_temperature_ := row_max_temperature_;
                     END IF;
                  ELSE
                     -- ROW has a specific max temperature entered on ROW level. TIER also has a max temperature but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use max temperature from ROW.
                     max_temperature_ := Warehouse_Bay_Row_API.Get_Bin_Max_Temperature(contract_, warehouse_id_, bay_id_, row_id_ );
                  END IF;
               ELSE
                  -- ROW max temperature source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_max_temperature_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER max temperature source is TIER, use max temperature from TIER
                     max_temperature_ := Warehouse_Bay_Tier_API.Get_Bin_Max_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);
                  ELSE
                  -- TIER max temperature source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  max temperature source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same max temperature source. This should not be a possible scenario...
                     tier_max_temperature_ := Warehouse_Bay_Tier_API.Get_Bin_Max_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_max_temperature_  := Warehouse_Bay_Row_API.Get_Bin_Max_Temperature (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_max_temperature_ < tier_max_temperature_) THEN
                        max_temperature_ := tier_max_temperature_;
                     ELSE
                        max_temperature_ := row_max_temperature_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (max_temperature_);
END Get_Max_Temperature;


@Override
@UncheckedAccess
FUNCTION Get_Min_Humidity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   min_humidity_                WAREHOUSE_BAY_BIN_TAB.min_humidity%TYPE;
   row_min_humidity_            WAREHOUSE_BAY_BIN_TAB.min_humidity%TYPE;
   tier_min_humidity_           WAREHOUSE_BAY_BIN_TAB.min_humidity%TYPE;
   row_min_humidity_source_db_  VARCHAR2(20);
   tier_min_humidity_source_db_ VARCHAR2(20);
BEGIN
   min_humidity_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (min_humidity_ IS NULL) THEN

      row_min_humidity_source_db_  := Warehouse_Bay_Row_API.Get_Bin_Min_Humidity_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_min_humidity_source_db_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Humidity_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_min_humidity_source_db_ IS NULL) THEN
         IF (tier_min_humidity_source_db_ IS NULL) THEN
            -- No min humidity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific min humidity but TIER has it. Return min humidity value from TIER
            min_humidity_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);
         END IF;
      ELSE
         -- ROW min humidity source is NOT NULL
         IF (tier_min_humidity_source_db_ IS NULL) THEN
            -- TIER min humidity source IS NULL so use min humidity from ROW
            min_humidity_ := Warehouse_Bay_Row_API.Get_Bin_Min_Humidity(contract_, warehouse_id_, bay_id_, row_id_ );
         ELSE
            -- ROW min humidity source IS NOT NULL. TIER min humidity source IS NOT NULL
            IF (row_min_humidity_source_db_ = tier_min_humidity_source_db_) THEN
               -- ROW and TIER has the same min humidity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               min_humidity_ := Warehouse_Bay_Row_API.Get_Bin_Min_Humidity(contract_, warehouse_id_, bay_id_, row_id_ );
            ELSE
               IF (row_min_humidity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_min_humidity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_min_humidity_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_min_humidity_  := Warehouse_Bay_Row_API.Get_Bin_Min_Humidity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_min_humidity_ < tier_min_humidity_) THEN
                        min_humidity_ := row_min_humidity_;
                     ELSE
                        min_humidity_ := tier_min_humidity_;
                     END IF;
                  ELSE
                     -- ROW has a specific min humidity entered on ROW level. TIER also has a min humidity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use min humidity from ROW.
                     min_humidity_ := Warehouse_Bay_Row_API.Get_Bin_Min_Humidity(contract_, warehouse_id_, bay_id_, row_id_ );
                  END IF;
               ELSE
                  -- ROW min humidity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_min_humidity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER min humidity source is TIER, use min humidity from TIER
                     min_humidity_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);
                  ELSE
                  -- TIER min humidity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  min humidity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same min humidity source. This should not be a possible scenario...
                     tier_min_humidity_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_min_humidity_  := Warehouse_Bay_Row_API.Get_Bin_Min_Humidity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_min_humidity_ < tier_min_humidity_) THEN
                        min_humidity_ := row_min_humidity_;
                     ELSE
                        min_humidity_ := tier_min_humidity_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (min_humidity_);
END Get_Min_Humidity;


@Override
@UncheckedAccess
FUNCTION Get_Max_Humidity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   max_humidity_               WAREHOUSE_BAY_BIN_TAB.max_humidity%TYPE;
   row_max_humidity_           WAREHOUSE_BAY_BIN_TAB.max_humidity%TYPE;
   tier_max_humidity_          WAREHOUSE_BAY_BIN_TAB.max_humidity%TYPE;
   row_max_humidity_source_db_ VARCHAR2(20);
   tier_max_humidity_src_db_   VARCHAR2(20);
BEGIN
   max_humidity_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (max_humidity_ IS NULL) THEN

      row_max_humidity_source_db_ := Warehouse_Bay_Row_API.Get_Bin_Max_Humidity_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_max_humidity_src_db_   := Warehouse_Bay_Tier_API.Get_Bin_Max_Humidity_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_max_humidity_source_db_ IS NULL) THEN
         IF (tier_max_humidity_src_db_ IS NULL) THEN
            -- No max humidity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific max humidity but TIER has it. Return max humidity value from TIER
            max_humidity_ := Warehouse_Bay_Tier_API.Get_Bin_Max_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);
         END IF;
      ELSE
         -- ROW max humidity source is NOT NULL
         IF (tier_max_humidity_src_db_ IS NULL) THEN
            -- TIER max humidity source IS NULL so use max humidity from ROW
            max_humidity_ := Warehouse_Bay_Row_API.Get_Bin_Max_Humidity(contract_, warehouse_id_, bay_id_, row_id_ );
         ELSE
            -- ROW max humidity source IS NOT NULL. TIER max humidity source IS NOT NULL
            IF (row_max_humidity_source_db_ = tier_max_humidity_src_db_) THEN
               -- ROW and TIER has the same max humidity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               max_humidity_ := Warehouse_Bay_Row_API.Get_Bin_Max_Humidity(contract_, warehouse_id_, bay_id_, row_id_ );
            ELSE
               IF (row_max_humidity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_max_humidity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the highest
                     tier_max_humidity_ := Warehouse_Bay_Tier_API.Get_Bin_Max_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_max_humidity_  := Warehouse_Bay_Row_API.Get_Bin_Max_Humidity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_max_humidity_ < tier_max_humidity_) THEN
                        max_humidity_ := tier_max_humidity_;
                     ELSE
                        max_humidity_ := row_max_humidity_;
                     END IF;
                  ELSE
                     -- ROW has a specific max humidity entered on ROW level. TIER also has a max humidity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use max humidity from ROW.
                     max_humidity_ := Warehouse_Bay_Row_API.Get_Bin_Max_Humidity(contract_, warehouse_id_, bay_id_, row_id_ );
                  END IF;
               ELSE
                  -- ROW max humidity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_max_humidity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER max humidity source is TIER, use max humidity from TIER
                     max_humidity_ := Warehouse_Bay_Tier_API.Get_Bin_Max_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);
                  ELSE
                  -- TIER max humidity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  max humidity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same max humidity source. This should not be a possible scenario...
                     tier_max_humidity_ := Warehouse_Bay_Tier_API.Get_Bin_Max_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_max_humidity_  := Warehouse_Bay_Row_API.Get_Bin_Max_Humidity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_max_humidity_ < tier_max_humidity_) THEN
                        max_humidity_ := tier_max_humidity_;
                     ELSE
                        max_humidity_ := row_max_humidity_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (max_humidity_);
END Get_Max_Humidity;


@UncheckedAccess
PROCEDURE Get_Location_Strings (
   warehouse_id_ OUT VARCHAR2,
   bay_id_       OUT VARCHAR2,
   tier_id_      OUT VARCHAR2,
   row_id_       OUT VARCHAR2,
   bin_id_       OUT VARCHAR2,
   contract_     IN  VARCHAR2,
   location_no_  IN  VARCHAR2 )
IS
   CURSOR location_strings IS
      SELECT warehouse_id,
             bay_id,
             row_id,
             tier_id,
             bin_id
      FROM   WAREHOUSE_BAY_BIN_TAB
      WHERE contract    = contract_
      AND   location_no = location_no_;
BEGIN
   OPEN  location_strings;
   FETCH location_strings INTO warehouse_id_, bay_id_, row_id_, tier_id_, bin_id_;
   CLOSE location_strings;
END Get_Location_Strings;


@UncheckedAccess
FUNCTION Get_Location_Type (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Inventory_Location_Group_API.Get_Inventory_Location_Type(
                                          Get_Location_Group(contract_,
                                                             warehouse_id_,
                                                             bay_id_,
                                                             tier_id_,
                                                             row_id_,
                                                             bin_id_));
END Get_Location_Type;


@UncheckedAccess
FUNCTION Get_Any_Location (
   contract_                 IN VARCHAR2,
   location_group_           IN VARCHAR2,
   exclude_receipts_blocked_ IN BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   location_no_ WAREHOUSE_BAY_BIN_TAB.location_no%TYPE;

   CURSOR get_any_location IS
      SELECT location_no, warehouse_id, bay_id, row_id, tier_id, bin_id
      FROM   WAREHOUSE_BAY_BIN_TAB
      WHERE contract       = contract_
      AND   location_group = location_group_;
BEGIN
   FOR location_rec_ IN get_any_location LOOP
      IF (exclude_receipts_blocked_) THEN
         IF (Get_Receipts_Blocked_Db(contract_,
                                     location_rec_.warehouse_id,
                                     location_rec_.bay_id,
                                     location_rec_.tier_id,
                                     location_rec_.row_id,
                                     location_rec_.bin_id) = false_) THEN
            location_no_ := location_rec_.location_no;
            EXIT;
         END IF;
      ELSE
         location_no_ := location_rec_.location_no;
         EXIT;
      END IF;
   END LOOP;

   RETURN location_no_;
END Get_Any_Location;


@UncheckedAccess
FUNCTION Is_Shipment_Location (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN (Get_Location_Type_db(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_) = 'SHIPMENT');
END Is_Shipment_Location;


@UncheckedAccess
FUNCTION Get_Location_Type_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Inventory_Location_Group_API.Get_Inventory_Location_Type_Db(
                                          Get_Location_Group(contract_,
                                                             warehouse_id_,
                                                             bay_id_,
                                                             tier_id_,
                                                             row_id_,
                                                             bin_id_));
END Get_Location_Type_Db;


@UncheckedAccess
FUNCTION Location_Exists_On_Site (
   contract_    IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM WAREHOUSE_BAY_BIN_TAB
      WHERE location_no = location_no_
      AND   (contract = contract_ OR contract_ IS NULL);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN TRUE;
   END IF;
   CLOSE exist_control;
   RETURN FALSE;
END Location_Exists_On_Site;


PROCEDURE Get_Control_Type_Values (
   location_type_db_ OUT    VARCHAR2,
   location_group_   IN OUT VARCHAR2,
   contract_         IN     VARCHAR2,
   warehouse_id_     IN     VARCHAR2,
   bay_id_           IN     VARCHAR2,
   tier_id_          IN     VARCHAR2,
   row_id_           IN     VARCHAR2,
   bin_id_           IN     VARCHAR2 )
IS
BEGIN
   location_group_   := Get_Location_Group(contract_,
                                           warehouse_id_,
                                           bay_id_,
                                           tier_id_,
                                           row_id_,
                                           bin_id_);
   location_type_db_ := Inventory_Location_Group_API.Get_Inventory_Location_Type_Db(location_group_);
END Get_Control_Type_Values;


@UncheckedAccess
FUNCTION Arrival_Or_Quality_Location (
   location_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   arrival_or_quality_location_ VARCHAR2(5) := false_;
BEGIN
   IF (location_type_db_ IN ('ARRIVAL','QA')) THEN
      arrival_or_quality_location_ := 'TRUE';
   END IF;
   RETURN (arrival_or_quality_location_);
END Arrival_Or_Quality_Location;


@UncheckedAccess
FUNCTION Warehouse_Exists_On_Site (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM WAREHOUSE_BAY_BIN_TAB
      WHERE  contract     = contract_
      AND    warehouse_id = warehouse_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN TRUE;
   END IF;
   CLOSE exist_control;
   RETURN FALSE;
END Warehouse_Exists_On_Site;


@UncheckedAccess
FUNCTION Get_Height_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   height_capacity_source_db_     VARCHAR2(20);
   row_height_capacity_           WAREHOUSE_BAY_BIN_TAB.height_capacity%TYPE;
   tier_height_capacity_          WAREHOUSE_BAY_BIN_TAB.height_capacity%TYPE;
   row_height_capacity_source_db_ VARCHAR2(20);
   tier_height_capacity_src_db_   VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (micro_cache_value_.height_capacity IS NULL) THEN

      row_height_capacity_source_db_ := Warehouse_Bay_Row_API.Get_Bin_Height_Cap_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_height_capacity_src_db_   := Warehouse_Bay_Tier_API.Get_Bin_Height_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_height_capacity_source_db_ IS NULL) THEN
         IF (tier_height_capacity_src_db_ IS NULL) THEN
            -- No capacity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific capacity but TIER has it. Return capacity source from TIER
            height_capacity_source_db_ := tier_height_capacity_src_db_;
         END IF;
      ELSE
         -- ROW capacity source is NOT NULL
         IF (tier_height_capacity_src_db_ IS NULL) THEN
            -- TIER capacity source IS NULL so use capacity from ROW
            height_capacity_source_db_ := row_height_capacity_source_db_;
         ELSE
            -- ROW capacity source IS NOT NULL. TIER capacity source IS NOT NULL
            IF (row_height_capacity_source_db_ = tier_height_capacity_src_db_) THEN
               -- ROW and TIER has the same capacity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               height_capacity_source_db_ := row_height_capacity_source_db_;
            ELSE
               IF (row_height_capacity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_height_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_height_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Height_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_height_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Height_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_height_capacity_ < tier_height_capacity_) THEN
                        height_capacity_source_db_ := row_height_capacity_source_db_;
                     ELSE
                        height_capacity_source_db_ := tier_height_capacity_src_db_;
                     END IF;
                  ELSE
                     -- ROW has a specific capacity entered on ROW level. TIER also has a capacity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use Capacity from ROW.
                     height_capacity_source_db_ := row_height_capacity_source_db_;
                  END IF;
               ELSE
                  -- ROW capacity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_height_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER capacity source is TIER, use capacity from TIER
                     height_capacity_source_db_ := tier_height_capacity_src_db_;
                  ELSE
                  -- TIER capacity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  capacity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same capacity source. This should not be a possible scenario...
                     tier_height_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Height_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_height_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Height_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_height_capacity_ < tier_height_capacity_) THEN
                        height_capacity_source_db_ := row_height_capacity_source_db_;
                     ELSE
                        height_capacity_source_db_ := tier_height_capacity_src_db_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   ELSE
      height_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BIN;
   END IF;
   RETURN (Warehouse_Structure_Level_API.Decode(height_capacity_source_db_));
END Get_Height_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Width_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   width_capacity_source_db_     VARCHAR2(20);
   row_width_capacity_           WAREHOUSE_BAY_BIN_TAB.width_capacity%TYPE;
   tier_width_capacity_          WAREHOUSE_BAY_BIN_TAB.width_capacity%TYPE;
   row_width_capacity_source_db_ VARCHAR2(20);
   tier_width_capacity_src_db_   VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (micro_cache_value_.width_capacity IS NULL) THEN

      row_width_capacity_source_db_ := Warehouse_Bay_Row_API.Get_Bin_Width_Cap_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_width_capacity_src_db_   := Warehouse_Bay_Tier_API.Get_Bin_Width_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_width_capacity_source_db_ IS NULL) THEN
         IF (tier_width_capacity_src_db_ IS NULL) THEN
            -- No capacity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific capacity but TIER has it. Return capacity source from TIER
            width_capacity_source_db_ := tier_width_capacity_src_db_;
         END IF;
      ELSE
         -- ROW capacity source is NOT NULL
         IF (tier_width_capacity_src_db_ IS NULL) THEN
            -- TIER capacity source IS NULL so use capacity from ROW
            width_capacity_source_db_ := row_width_capacity_source_db_;
         ELSE
            -- ROW capacity source IS NOT NULL. TIER capacity source IS NOT NULL
            IF (row_width_capacity_source_db_ = tier_width_capacity_src_db_) THEN
               -- ROW and TIER has the same capacity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               width_capacity_source_db_ := row_width_capacity_source_db_;
            ELSE
               IF (row_width_capacity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_width_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_width_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Width_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_width_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Width_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_width_capacity_ < tier_width_capacity_) THEN
                        width_capacity_source_db_ := row_width_capacity_source_db_;
                     ELSE
                        width_capacity_source_db_ := tier_width_capacity_src_db_;
                     END IF;
                  ELSE
                     -- ROW has a specific capacity entered on ROW level. TIER also has a capacity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use Capacity from ROW.
                     width_capacity_source_db_ := row_width_capacity_source_db_;
                  END IF;
               ELSE
                  -- ROW capacity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_width_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER capacity source is TIER, use capacity from TIER
                     width_capacity_source_db_ := tier_width_capacity_src_db_;
                  ELSE
                  -- TIER capacity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  capacity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same capacity source. This should not be a possible scenario...
                     tier_width_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Width_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_width_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Width_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_width_capacity_ < tier_width_capacity_) THEN
                        width_capacity_source_db_ := row_width_capacity_source_db_;
                     ELSE
                        width_capacity_source_db_ := tier_width_capacity_src_db_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   ELSE
      width_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BIN;
   END IF;
   RETURN (Warehouse_Structure_Level_API.Decode(width_capacity_source_db_));
END Get_Width_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Dept_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   dept_capacity_source_db_     VARCHAR2(20);
   row_dept_capacity_           WAREHOUSE_BAY_BIN_TAB.dept_capacity%TYPE;
   tier_dept_capacity_          WAREHOUSE_BAY_BIN_TAB.dept_capacity%TYPE;
   row_dept_capacity_source_db_ VARCHAR2(20);
   tier_dept_capacity_src_db_   VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (micro_cache_value_.dept_capacity IS NULL) THEN

      row_dept_capacity_source_db_ := Warehouse_Bay_Row_API.Get_Bin_Dept_Cap_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_dept_capacity_src_db_   := Warehouse_Bay_Tier_API.Get_Bin_Dept_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_dept_capacity_source_db_ IS NULL) THEN
         IF (tier_dept_capacity_src_db_ IS NULL) THEN
            -- No capacity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific capacity but TIER has it. Return capacity source from TIER
            dept_capacity_source_db_ := tier_dept_capacity_src_db_;
         END IF;
      ELSE
         -- ROW capacity source is NOT NULL
         IF (tier_dept_capacity_src_db_ IS NULL) THEN
            -- TIER capacity source IS NULL so use capacity from ROW
            dept_capacity_source_db_ := row_dept_capacity_source_db_;
         ELSE
            -- ROW capacity source IS NOT NULL. TIER capacity source IS NOT NULL
            IF (row_dept_capacity_source_db_ = tier_dept_capacity_src_db_) THEN
               -- ROW and TIER has the same capacity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               dept_capacity_source_db_ := row_dept_capacity_source_db_;
            ELSE
               IF (row_dept_capacity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_dept_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_dept_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Dept_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_dept_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Dept_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_dept_capacity_ < tier_dept_capacity_) THEN
                        dept_capacity_source_db_ := row_dept_capacity_source_db_;
                     ELSE
                        dept_capacity_source_db_ := tier_dept_capacity_src_db_;
                     END IF;
                  ELSE
                     -- ROW has a specific capacity entered on ROW level. TIER also has a capacity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use Capacity from ROW.
                     dept_capacity_source_db_ := row_dept_capacity_source_db_;
                  END IF;
               ELSE
                  -- ROW capacity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_dept_capacity_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER capacity source is TIER, use capacity from TIER
                     dept_capacity_source_db_ := tier_dept_capacity_src_db_;
                  ELSE
                  -- TIER capacity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  capacity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same capacity source. This should not be a possible scenario...
                     tier_dept_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_Dept_Capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_dept_capacity_  := Warehouse_Bay_Row_API.Get_Bin_Dept_Capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_dept_capacity_ < tier_dept_capacity_) THEN
                        dept_capacity_source_db_ := row_dept_capacity_source_db_;
                     ELSE
                        dept_capacity_source_db_ := tier_dept_capacity_src_db_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   ELSE
      dept_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BIN;
   END IF;
   RETURN (Warehouse_Structure_Level_API.Decode(dept_capacity_source_db_));
END Get_Dept_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Carry_Capacity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   carrying_capacity_source_db_   VARCHAR2(20);
   row_carrying_capacity_         WAREHOUSE_BAY_BIN_TAB.carrying_capacity%TYPE;
   tier_carrying_capacity_        WAREHOUSE_BAY_BIN_TAB.carrying_capacity%TYPE;
   row_carry_capacity_source_db_  VARCHAR2(20);
   tier_carry_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (micro_cache_value_.carrying_capacity IS NULL) THEN

      row_carry_capacity_source_db_ := Warehouse_Bay_Row_API.Get_Bin_Carry_Cap_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_carry_capacity_source_db_   := Warehouse_Bay_Tier_API.Get_Bin_Carry_Cap_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_carry_capacity_source_db_ IS NULL) THEN
         IF (tier_carry_capacity_source_db_ IS NULL) THEN
            -- No capacity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific capacity but TIER has it. Return capacity source from TIER
            carrying_capacity_source_db_ := tier_carry_capacity_source_db_;
         END IF;
      ELSE
         -- ROW capacity source is NOT NULL
         IF (tier_carry_capacity_source_db_ IS NULL) THEN
            -- TIER capacity source IS NULL so use capacity from ROW
            carrying_capacity_source_db_ := row_carry_capacity_source_db_;
         ELSE
            -- ROW capacity source IS NOT NULL. TIER capacity source IS NOT NULL
            IF (row_carry_capacity_source_db_ = tier_carry_capacity_source_db_) THEN
               -- ROW and TIER has the same capacity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               carrying_capacity_source_db_ := row_carry_capacity_source_db_;
            ELSE
               IF (row_carry_capacity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_carry_capacity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_carrying_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_carrying_capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_carrying_capacity_  := Warehouse_Bay_Row_API.Get_Bin_carrying_capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_carrying_capacity_ < tier_carrying_capacity_) THEN
                        carrying_capacity_source_db_ := row_carry_capacity_source_db_;
                     ELSE
                        carrying_capacity_source_db_ := tier_carry_capacity_source_db_;
                     END IF;
                  ELSE
                     -- ROW has a specific capacity entered on ROW level. TIER also has a capacity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use Capacity from ROW.
                     carrying_capacity_source_db_ := row_carry_capacity_source_db_;
                  END IF;
               ELSE
                  -- ROW capacity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_carry_capacity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER capacity source is TIER, use capacity from TIER
                     carrying_capacity_source_db_ := tier_carry_capacity_source_db_;
                  ELSE
                  -- TIER capacity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  capacity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same capacity source. This should not be a possible scenario...
                     tier_carrying_capacity_ := Warehouse_Bay_Tier_API.Get_Bin_carrying_capacity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_carrying_capacity_  := Warehouse_Bay_Row_API.Get_Bin_carrying_capacity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_carrying_capacity_ < tier_carrying_capacity_) THEN
                        carrying_capacity_source_db_ := row_carry_capacity_source_db_;
                     ELSE
                        carrying_capacity_source_db_ := tier_carry_capacity_source_db_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   ELSE
      carrying_capacity_source_db_ := Warehouse_Structure_Level_API.DB_BIN;
   END IF;
   RETURN (Warehouse_Structure_Level_API.Decode(carrying_capacity_source_db_));
END Get_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Min_Temperature_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   min_temperature_source_db_     VARCHAR2(20);
   row_min_temperature_           WAREHOUSE_BAY_BIN_TAB.min_temperature%TYPE;
   tier_min_temperature_          WAREHOUSE_BAY_BIN_TAB.min_temperature%TYPE;
   row_min_temperature_source_db_ VARCHAR2(20);
   tier_min_temperature_src_db_   VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (micro_cache_value_.min_temperature IS NULL) THEN

      row_min_temperature_source_db_ := Warehouse_Bay_Row_API.Get_Bin_Min_Temp_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_min_temperature_src_db_   := Warehouse_Bay_Tier_API.Get_Bin_Min_Temp_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_min_temperature_source_db_ IS NULL) THEN
         IF (tier_min_temperature_src_db_ IS NULL) THEN
            -- No capacity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific capacity but TIER has it. Return capacity source from TIER
            min_temperature_source_db_ := tier_min_temperature_src_db_;
         END IF;
      ELSE
         -- ROW capacity source is NOT NULL
         IF (tier_min_temperature_src_db_ IS NULL) THEN
            -- TIER capacity source IS NULL so use capacity from ROW
            min_temperature_source_db_ := row_min_temperature_source_db_;
         ELSE
            -- ROW capacity source IS NOT NULL. TIER capacity source IS NOT NULL
            IF (row_min_temperature_source_db_ = tier_min_temperature_src_db_) THEN
               -- ROW and TIER has the same capacity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               min_temperature_source_db_ := row_min_temperature_source_db_;
            ELSE
               IF (row_min_temperature_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_min_temperature_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_min_temperature_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_min_temperature_  := Warehouse_Bay_Row_API.Get_Bin_Min_Temperature (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_min_temperature_ < tier_min_temperature_) THEN
                        min_temperature_source_db_ := row_min_temperature_source_db_;
                     ELSE
                        min_temperature_source_db_ := tier_min_temperature_src_db_;
                     END IF;
                  ELSE
                     -- ROW has a specific capacity entered on ROW level. TIER also has a capacity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use Capacity from ROW.
                     min_temperature_source_db_ := row_min_temperature_source_db_;
                  END IF;
               ELSE
                  -- ROW capacity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_min_temperature_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER capacity source is TIER, use capacity from TIER
                     min_temperature_source_db_ := tier_min_temperature_src_db_;
                  ELSE
                  -- TIER capacity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  capacity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same capacity source. This should not be a possible scenario...
                     tier_min_temperature_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_min_temperature_  := Warehouse_Bay_Row_API.Get_Bin_Min_Temperature (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_min_temperature_ < tier_min_temperature_) THEN
                        min_temperature_source_db_ := row_min_temperature_source_db_;
                     ELSE
                        min_temperature_source_db_ := tier_min_temperature_src_db_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   ELSE
      min_temperature_source_db_ := Warehouse_Structure_Level_API.DB_BIN;
   END IF;
   RETURN (Warehouse_Structure_Level_API.Decode(min_temperature_source_db_));
END Get_Min_Temperature_Source;


@UncheckedAccess
FUNCTION Get_Max_Temperature_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   max_temperature_source_db_     VARCHAR2(20);
   row_max_temperature_           WAREHOUSE_BAY_BIN_TAB.max_temperature%TYPE;
   tier_max_temperature_          WAREHOUSE_BAY_BIN_TAB.max_temperature%TYPE;
   row_max_temperature_source_db_ VARCHAR2(20);
   tier_max_temperature_src_db_   VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (micro_cache_value_.max_temperature IS NULL) THEN

      row_max_temperature_source_db_ := Warehouse_Bay_Row_API.Get_Bin_Max_Temp_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_max_temperature_src_db_   := Warehouse_Bay_Tier_API.Get_Bin_Max_Temp_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_max_temperature_source_db_ IS NULL) THEN
         IF (tier_max_temperature_src_db_ IS NULL) THEN
            -- No capacity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific capacity but TIER has it. Return capacity source from TIER
            max_temperature_source_db_ := tier_max_temperature_src_db_;
         END IF;
      ELSE
         -- ROW capacity source is NOT NULL
         IF (tier_max_temperature_src_db_ IS NULL) THEN
            -- TIER capacity source IS NULL so use capacity from ROW
            max_temperature_source_db_ := row_max_temperature_source_db_;
         ELSE
            -- ROW capacity source IS NOT NULL. TIER capacity source IS NOT NULL
            IF (row_max_temperature_source_db_ = tier_max_temperature_src_db_) THEN
               -- ROW and TIER has the same capacity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               max_temperature_source_db_ := row_max_temperature_source_db_;
            ELSE
               IF (row_max_temperature_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_max_temperature_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_max_temperature_ := Warehouse_Bay_Tier_API.Get_Bin_Max_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_max_temperature_  := Warehouse_Bay_Row_API.Get_Bin_Max_Temperature (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_max_temperature_ < tier_max_temperature_) THEN
                        max_temperature_source_db_ := tier_max_temperature_src_db_;
                     ELSE
                        max_temperature_source_db_ := row_max_temperature_source_db_;
                     END IF;
                  ELSE
                     -- ROW has a specific capacity entered on ROW level. TIER also has a capacity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use Capacity from ROW.
                     max_temperature_source_db_ := row_max_temperature_source_db_;
                  END IF;
               ELSE
                  -- ROW capacity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_max_temperature_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER capacity source is TIER, use capacity from TIER
                     max_temperature_source_db_ := tier_max_temperature_src_db_;
                  ELSE
                  -- TIER capacity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  capacity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same capacity source. This should not be a possible scenario...
                     tier_max_temperature_ := Warehouse_Bay_Tier_API.Get_Bin_Max_Temperature(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_max_temperature_  := Warehouse_Bay_Row_API.Get_Bin_Max_Temperature (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_max_temperature_ < tier_max_temperature_) THEN
                        max_temperature_source_db_ := tier_max_temperature_src_db_;
                     ELSE
                        max_temperature_source_db_ := row_max_temperature_source_db_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   ELSE
      max_temperature_source_db_ := Warehouse_Structure_Level_API.DB_BIN;
   END IF;
   RETURN (Warehouse_Structure_Level_API.Decode(max_temperature_source_db_));
END Get_Max_Temperature_Source;


@UncheckedAccess
FUNCTION Get_Min_Humidity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   min_humidity_source_db_      VARCHAR2(20);
   row_min_humidity_            WAREHOUSE_BAY_BIN_TAB.min_humidity%TYPE;
   tier_min_humidity_           WAREHOUSE_BAY_BIN_TAB.min_humidity%TYPE;
   row_min_humidity_source_db_  VARCHAR2(20);
   tier_min_humidity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (micro_cache_value_.min_humidity IS NULL) THEN

      row_min_humidity_source_db_  := Warehouse_Bay_Row_API.Get_Bin_Min_Humidity_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_min_humidity_source_db_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Humidity_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_min_humidity_source_db_ IS NULL) THEN
         IF (tier_min_humidity_source_db_ IS NULL) THEN
            -- No capacity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific capacity but TIER has it. Return capacity source from TIER
            min_humidity_source_db_ := tier_min_humidity_source_db_;
         END IF;
      ELSE
         -- ROW capacity source is NOT NULL
         IF (tier_min_humidity_source_db_ IS NULL) THEN
            -- TIER capacity source IS NULL so use capacity from ROW
            min_humidity_source_db_ := row_min_humidity_source_db_;
         ELSE
            -- ROW capacity source IS NOT NULL. TIER capacity source IS NOT NULL
            IF (row_min_humidity_source_db_ = tier_min_humidity_source_db_) THEN
               -- ROW and TIER has the same capacity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               min_humidity_source_db_ := row_min_humidity_source_db_;
            ELSE
               IF (row_min_humidity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_min_humidity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_min_humidity_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_min_humidity_  := Warehouse_Bay_Row_API.Get_Bin_Min_Humidity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_min_humidity_ < tier_min_humidity_) THEN
                        min_humidity_source_db_ := row_min_humidity_source_db_;
                     ELSE
                        min_humidity_source_db_ := tier_min_humidity_source_db_;
                     END IF;
                  ELSE
                     -- ROW has a specific capacity entered on ROW level. TIER also has a capacity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use Capacity from ROW.
                     min_humidity_source_db_ := row_min_humidity_source_db_;
                  END IF;
               ELSE
                  -- ROW capacity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_min_humidity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER capacity source is TIER, use capacity from TIER
                     min_humidity_source_db_ := tier_min_humidity_source_db_;
                  ELSE
                  -- TIER capacity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  capacity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same capacity source. This should not be a possible scenario...
                     tier_min_humidity_ := Warehouse_Bay_Tier_API.Get_Bin_Min_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_min_humidity_  := Warehouse_Bay_Row_API.Get_Bin_Min_Humidity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_min_humidity_ < tier_min_humidity_) THEN
                        min_humidity_source_db_ := row_min_humidity_source_db_;
                     ELSE
                        min_humidity_source_db_ := tier_min_humidity_source_db_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   ELSE
      min_humidity_source_db_ := Warehouse_Structure_Level_API.DB_BIN;
   END IF;
   RETURN (Warehouse_Structure_Level_API.Decode(min_humidity_source_db_));
END Get_Min_Humidity_Source;


@UncheckedAccess
FUNCTION Get_Max_Humidity_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   max_humidity_source_db_      VARCHAR2(20);
   row_max_humidity_            WAREHOUSE_BAY_BIN_TAB.max_humidity%TYPE;
   tier_max_humidity_           WAREHOUSE_BAY_BIN_TAB.max_humidity%TYPE;
   row_max_humidity_source_db_  VARCHAR2(20);
   tier_max_humidity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (micro_cache_value_.max_humidity IS NULL) THEN

      row_max_humidity_source_db_  := Warehouse_Bay_Row_API.Get_Bin_Max_Humidity_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_max_humidity_source_db_ := Warehouse_Bay_Tier_API.Get_Bin_Max_Humidity_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_max_humidity_source_db_ IS NULL) THEN
         IF (tier_max_humidity_source_db_ IS NULL) THEN
            -- No capacity on either ROW or TIER. Method can return NULL
            NULL;
         ELSE
            -- ROW does not have any specific capacity but TIER has it. Return capacity source from TIER
            max_humidity_source_db_ := tier_max_humidity_source_db_;
         END IF;
      ELSE
         -- ROW capacity source is NOT NULL
         IF (tier_max_humidity_source_db_ IS NULL) THEN
            -- TIER capacity source IS NULL so use capacity from ROW
            max_humidity_source_db_ := row_max_humidity_source_db_;
         ELSE
            -- ROW capacity source IS NOT NULL. TIER capacity source IS NOT NULL
            IF (row_max_humidity_source_db_ = tier_max_humidity_source_db_) THEN
               -- ROW and TIER has the same capacity source (BAY, WAREHOUSE or SITE). So we can use either value because they are the same
               max_humidity_source_db_ := row_max_humidity_source_db_;
            ELSE
               IF (row_max_humidity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_max_humidity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- we need to fetch both and take the lowest
                     tier_max_humidity_ := Warehouse_Bay_Tier_API.Get_Bin_Max_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_max_humidity_  := Warehouse_Bay_Row_API.Get_Bin_Max_Humidity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_max_humidity_ < tier_max_humidity_) THEN
                        max_humidity_source_db_ := tier_max_humidity_source_db_;
                     ELSE
                        max_humidity_source_db_ := row_max_humidity_source_db_;
                     END IF;
                  ELSE
                     -- ROW has a specific capacity entered on ROW level. TIER also has a capacity but that one is inherited
                     -- from BAY, WAREHOUSE or SITE. Use Capacity from ROW.
                     max_humidity_source_db_ := row_max_humidity_source_db_;
                  END IF;
               ELSE
                  -- ROW capacity source is not ROW, so it must be either BAY, WAREHOUSE or SITE
                  IF (tier_max_humidity_source_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER capacity source is TIER, use capacity from TIER
                     max_humidity_source_db_ := tier_max_humidity_source_db_;
                  ELSE
                  -- TIER capacity source is not TIER, so it must be either BAY, WAREHOUSE or SITE.
                  -- ROW  capacity source is not ROW , so it must be either BAY, WAREHOUSE or SITE.
                  -- Still ROW and TIER does not have the same capacity source. This should not be a possible scenario...
                     tier_max_humidity_ := Warehouse_Bay_Tier_API.Get_Bin_Max_Humidity(contract_, warehouse_id_, bay_id_, tier_id_);
                     row_max_humidity_  := Warehouse_Bay_Row_API.Get_Bin_Max_Humidity (contract_, warehouse_id_, bay_id_, row_id_ );
                     IF (row_max_humidity_ < tier_max_humidity_) THEN
                        max_humidity_source_db_ := tier_max_humidity_source_db_;
                     ELSE
                        max_humidity_source_db_ := row_max_humidity_source_db_;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   ELSE
      max_humidity_source_db_ := Warehouse_Structure_Level_API.DB_BIN;
   END IF;
   RETURN (Warehouse_Structure_Level_API.Decode(max_humidity_source_db_));
END Get_Max_Humidity_Source;


@Override
@UncheckedAccess
FUNCTION Get_Receipts_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_   WAREHOUSE_BAY_BIN.receipts_blocked%TYPE;   
   receipts_blocked_      WAREHOUSE_BAY_BIN_TAB.receipts_blocked%TYPE;
   tier_receipts_blocked_ WAREHOUSE_BAY_BIN_TAB.receipts_blocked%TYPE;
BEGIN
   dummy_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   receipts_blocked_ := micro_cache_value_.receipts_blocked;

   IF (receipts_blocked_ = false_) THEN
      tier_receipts_blocked_ := Warehouse_Bay_Tier_API.Get_Receipts_Blocked_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_receipts_blocked_ = false_) THEN
         receipts_blocked_ :=  Warehouse_Bay_Row_API.Get_Receipts_Blocked_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         receipts_blocked_ :=  tier_receipts_blocked_;
      END IF;
   END IF;
   RETURN Fnd_Boolean_API.Decode(receipts_blocked_);
END Get_Receipts_Blocked;


@Override
@UncheckedAccess
FUNCTION Get_Receipts_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipts_blocked_      WAREHOUSE_BAY_BIN_TAB.receipts_blocked%TYPE;
   tier_receipts_blocked_ WAREHOUSE_BAY_BIN_TAB.receipts_blocked%TYPE;
BEGIN
   receipts_blocked_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (receipts_blocked_ = false_) THEN
      tier_receipts_blocked_ := Warehouse_Bay_Tier_API.Get_Receipts_Blocked_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_receipts_blocked_ = false_) THEN
         receipts_blocked_ := Warehouse_Bay_Row_API.Get_Receipts_Blocked_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         receipts_blocked_ := tier_receipts_blocked_;
      END IF;
   END IF;
   RETURN (receipts_blocked_);
END Get_Receipts_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Parent_Receipts_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipts_blocked_      WAREHOUSE_BAY_BIN_TAB.receipts_blocked%TYPE;
   tier_receipts_blocked_ WAREHOUSE_BAY_BIN_TAB.receipts_blocked%TYPE;
BEGIN
   tier_receipts_blocked_ := Warehouse_Bay_Tier_API.Get_Receipts_Blocked_Db(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (tier_receipts_blocked_ = false_) THEN
      receipts_blocked_ := Warehouse_Bay_Row_API.Get_Receipts_Blocked_Db(contract_, warehouse_id_, bay_id_, row_id_);
   ELSE
      receipts_blocked_ := tier_receipts_blocked_;
   END IF;
   RETURN (receipts_blocked_);
END Get_Parent_Receipts_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Receipts_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipts_blocked_source_ VARCHAR2(200);
   tier_receipts_blocked_   WAREHOUSE_BAY_BIN_TAB.receipts_blocked%TYPE;
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   IF (micro_cache_value_.receipts_blocked = false_) THEN
      tier_receipts_blocked_ := Warehouse_Bay_Tier_API.Get_Receipts_Blocked_Db(contract_,
                                                                               warehouse_id_,
                                                                               bay_id_,
                                                                               tier_id_);
      IF (tier_receipts_blocked_ = false_) THEN
         receipts_blocked_source_ := Warehouse_Bay_Row_API.Get_Receipts_Blocked_Source(contract_,
                                                                                       warehouse_id_,
                                                                                       bay_id_,
                                                                                       row_id_);
      ELSE
         receipts_blocked_source_ := Warehouse_Bay_Tier_API.Get_Receipts_Blocked_Source(contract_,
                                                                                        warehouse_id_,
                                                                                        bay_id_,
                                                                                        tier_id_);
      END IF;
   ELSE
      receipts_blocked_source_ := Warehouse_Structure_Level_API.Decode(WAREHOUSE_STRUCTURE_LEVEL_API.DB_BIN);
   END IF;
   RETURN (receipts_blocked_source_);
END Get_Receipts_Blocked_Source;


@UncheckedAccess
FUNCTION Get_Parent_Receipts_Bl_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipts_blocked_source_ VARCHAR2(200);
   tier_receipts_blocked_   WAREHOUSE_BAY_BIN_TAB.receipts_blocked%TYPE;
BEGIN
   tier_receipts_blocked_ := Warehouse_Bay_Tier_API.Get_Receipts_Blocked_Db(contract_,
                                                                            warehouse_id_,
                                                                            bay_id_,
                                                                            tier_id_);
   IF (tier_receipts_blocked_ = false_) THEN
      receipts_blocked_source_ := Warehouse_Bay_Row_API.Get_Receipts_Blocked_Source(contract_,
                                                                                    warehouse_id_,
                                                                                    bay_id_,
                                                                                    row_id_);
   ELSE
      receipts_blocked_source_ := Warehouse_Bay_Tier_API.Get_Receipts_Blocked_Source(contract_,
                                                                                     warehouse_id_,
                                                                                     bay_id_,
                                                                                     tier_id_);
   END IF;

   RETURN (receipts_blocked_source_);
END Get_Parent_Receipts_Bl_Source;


@Override
@UncheckedAccess
FUNCTION Get_Receipt_To_Occup_Blockd (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_   WAREHOUSE_BAY_BIN.receipt_to_occupied_blocked%TYPE; 
   receipt_to_occupied_blocked_ WAREHOUSE_BAY_BIN_TAB.receipt_to_occupied_blocked%TYPE;
   tier_receipt_to_occ_blkd_    WAREHOUSE_BAY_BIN_TAB.receipt_to_occupied_blocked%TYPE;
BEGIN
   dummy_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   receipt_to_occupied_blocked_ := micro_cache_value_.receipt_to_occupied_blocked;
   
   IF (receipt_to_occupied_blocked_ = false_) THEN
      tier_receipt_to_occ_blkd_ := Warehouse_Bay_Tier_API.Get_Receipts_Blocked_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_receipt_to_occ_blkd_ = false_) THEN
         receipt_to_occupied_blocked_ :=  Warehouse_Bay_Row_API.Get_Receipt_To_Occup_Blockd_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         receipt_to_occupied_blocked_ :=  tier_receipt_to_occ_blkd_;
      END IF;
   END IF;
   RETURN Fnd_Boolean_API.Decode(receipt_to_occupied_blocked_);
END Get_Receipt_To_Occup_Blockd;


@Override
@UncheckedAccess
FUNCTION Get_Receipt_To_Occup_Blockd_Db (
   contract_ IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_ IN VARCHAR2,
   tier_id_ IN VARCHAR2,
   row_id_ IN VARCHAR2,
   bin_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipt_to_occupied_blocked_ WAREHOUSE_BAY_BIN_TAB.receipt_to_occupied_blocked%TYPE;
   tier_receipt_to_occ_blkd_    WAREHOUSE_BAY_BIN_TAB.receipt_to_occupied_blocked%TYPE;
BEGIN
   receipt_to_occupied_blocked_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   
   IF (receipt_to_occupied_blocked_ = false_) THEN
      tier_receipt_to_occ_blkd_ := Warehouse_Bay_Tier_API.Get_Receipt_To_Occup_Blockd_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_receipt_to_occ_blkd_ = false_) THEN
         receipt_to_occupied_blocked_ :=  Warehouse_Bay_Row_API.Get_Receipt_To_Occup_Blockd_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         receipt_to_occupied_blocked_ :=  tier_receipt_to_occ_blkd_;
      END IF;
   END IF;
   RETURN (receipt_to_occupied_blocked_);
END Get_Receipt_To_Occup_Blockd_Db;


@UncheckedAccess
FUNCTION Get_Parent_Rec_To_Occp_Blkd_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipt_to_occupied_blocked_ WAREHOUSE_BAY_BIN_TAB.receipt_to_occupied_blocked%TYPE;
   tier_receipt_to_occ_blkd_    WAREHOUSE_BAY_BIN_TAB.receipt_to_occupied_blocked%TYPE;
BEGIN
   tier_receipt_to_occ_blkd_ := Warehouse_Bay_Tier_API.Get_Receipt_To_Occup_Blockd_Db(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (tier_receipt_to_occ_blkd_ = false_) THEN
      receipt_to_occupied_blocked_ := Warehouse_Bay_Row_API.Get_Receipt_To_Occup_Blockd_Db(contract_, warehouse_id_, bay_id_, row_id_);
   ELSE
      receipt_to_occupied_blocked_ := tier_receipt_to_occ_blkd_;
   END IF;
   RETURN (receipt_to_occupied_blocked_);
END Get_Parent_Rec_To_Occp_Blkd_Db;


@UncheckedAccess
FUNCTION Get_Receipt_To_Occup_Blkd_Src (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipt_to_occup_blkd_src_ VARCHAR2(200);
   tier_receipt_to_occ_blkd_  WAREHOUSE_BAY_BIN_TAB.receipt_to_occupied_blocked%TYPE;
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   IF (micro_cache_value_.receipt_to_occupied_blocked = false_) THEN
      tier_receipt_to_occ_blkd_ := Warehouse_Bay_Tier_API.Get_Receipt_To_Occup_Blockd_Db(contract_,
                                                                                         warehouse_id_,
                                                                                         bay_id_,
                                                                                         tier_id_);
      IF (tier_receipt_to_occ_blkd_ = false_) THEN
         receipt_to_occup_blkd_src_ := Warehouse_Bay_Row_API.Get_Receipt_To_Occup_Blkd_Src(contract_,
                                                                                           warehouse_id_,
                                                                                           bay_id_,
                                                                                           row_id_);
      ELSE
         receipt_to_occup_blkd_src_ := Warehouse_Bay_Tier_API.Get_Receipt_To_Occup_Blkd_Src(contract_,
                                                                                            warehouse_id_,
                                                                                            bay_id_,
                                                                                            tier_id_);
      END IF;
   ELSE
      receipt_to_occup_blkd_src_ := Warehouse_Structure_Level_API.Decode(WAREHOUSE_STRUCTURE_LEVEL_API.DB_BIN);
   END IF;
   RETURN (receipt_to_occup_blkd_src_);
END Get_Receipt_To_Occup_Blkd_Src;


@UncheckedAccess
FUNCTION Get_Parent_Rec_To_Occp_Blk_Src (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   receipt_to_occup_blkd_src_ VARCHAR2(200);
   tier_receipt_to_occ_blkd_    WAREHOUSE_BAY_BIN_TAB.receipt_to_occupied_blocked%TYPE;
BEGIN
   tier_receipt_to_occ_blkd_ := Warehouse_Bay_Tier_API.Get_Receipt_To_Occup_Blockd_Db(contract_,
                                                                                      warehouse_id_,
                                                                                      bay_id_,
                                                                                      tier_id_);
   IF (tier_receipt_to_occ_blkd_ = false_) THEN
      receipt_to_occup_blkd_src_ := Warehouse_Bay_Row_API.Get_Receipt_To_Occup_Blkd_Src(contract_,
                                                                                        warehouse_id_,
                                                                                        bay_id_,
                                                                                        row_id_);
   ELSE
      receipt_to_occup_blkd_src_ := Warehouse_Bay_Tier_API.Get_Receipt_To_Occup_Blkd_Src(contract_,
                                                                                         warehouse_id_,
                                                                                         bay_id_,
                                                                                         tier_id_);
   END IF;

   RETURN (receipt_to_occup_blkd_src_);
END Get_Parent_Rec_To_Occp_Blk_Src;


@Override
@UncheckedAccess
FUNCTION Get_Hide_In_Whse_Navigator (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_   WAREHOUSE_BAY_BIN.hide_in_whse_navigator%TYPE;
   hide_in_whse_navigator_      WAREHOUSE_BAY_BIN_TAB.hide_in_whse_navigator%TYPE;
   tier_hide_in_whse_navigator_ WAREHOUSE_BAY_BIN_TAB.hide_in_whse_navigator%TYPE;
BEGIN
   dummy_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   hide_in_whse_navigator_ := micro_cache_value_.hide_in_whse_navigator;

   IF (hide_in_whse_navigator_ = false_) THEN
      tier_hide_in_whse_navigator_ := Warehouse_Bay_Tier_API.Get_Hide_In_Whse_Navigator_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_hide_in_whse_navigator_ = false_) THEN
         hide_in_whse_navigator_ := Warehouse_Bay_Row_API.Get_Hide_In_Whse_Navigator_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         hide_in_whse_navigator_ := tier_hide_in_whse_navigator_;
      END IF;
   END IF;
   RETURN Fnd_Boolean_API.Decode(hide_in_whse_navigator_);
END Get_Hide_In_Whse_Navigator;


@Override
@UncheckedAccess
FUNCTION Get_Hide_In_Whse_Navigator_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   hide_in_whse_navigator_       WAREHOUSE_BAY_BIN_TAB.hide_in_whse_navigator%TYPE;
   tier_hide_in_warehouse_navig_ WAREHOUSE_BAY_BIN_TAB.hide_in_whse_navigator%TYPE;
BEGIN
   hide_in_whse_navigator_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (hide_in_whse_navigator_ = false_) THEN
      tier_hide_in_warehouse_navig_ := Warehouse_Bay_Tier_API.Get_Hide_In_Whse_Navigator_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_hide_in_warehouse_navig_ = false_) THEN
         hide_in_whse_navigator_ := Warehouse_Bay_Row_API.Get_Hide_In_Whse_Navigator_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         hide_in_whse_navigator_ := tier_hide_in_warehouse_navig_;
      END IF;
   END IF;
   RETURN (hide_in_whse_navigator_);
END Get_Hide_In_Whse_Navigator_Db;


@UncheckedAccess
FUNCTION Is_Hidden_In_Structure_Below (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   hide_in_whse_navigator_ WAREHOUSE_BAY_BIN_TAB.hide_in_whse_navigator%TYPE;

BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   hide_in_whse_navigator_ := micro_cache_value_.hide_in_whse_navigator;

   RETURN hide_in_whse_navigator_;
END Is_Hidden_In_Structure_Below;


PROCEDURE Check_Receipts_Blocked (
   contract_     IN VARCHAR2,
   location_no_  IN VARCHAR2 )
IS
BEGIN
   IF Receipts_Blocked(contract_, location_no_) THEN
      Error_SYS.Record_General(lu_name_, 'LOCATIONBLOCKED: Location :P1 on Site :P2 is blocked for receipts.', location_no_, contract_);
   END IF;
END Check_Receipts_Blocked;


PROCEDURE Check_Temperature_Range (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 )
IS
   min_temperature_ WAREHOUSE_BAY_BIN_TAB.min_temperature%TYPE;
   max_temperature_ WAREHOUSE_BAY_BIN_TAB.max_temperature%TYPE;
   location_no_     WAREHOUSE_BAY_BIN_TAB.location_no%TYPE;
BEGIN

   min_temperature_ := Get_Min_Temperature(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   max_temperature_ := Get_Max_Temperature(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (Part_Catalog_Invent_Attrib_API.Incorrect_Temperature_Range(min_temperature_, max_temperature_)) THEN
      location_no_ := Get_Location_No(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
      Error_SYS.Record_General(lu_name_, 'TEMPRANGE: Incorrect Operative Temperature Range for Location No :P1 on Site :P2.', location_no_, contract_);
   END IF;
END Check_Temperature_Range;


PROCEDURE Check_Humidity_Range (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 )
IS
   min_humidity_ WAREHOUSE_BAY_BIN_TAB.min_humidity%TYPE;
   max_humidity_ WAREHOUSE_BAY_BIN_TAB.max_humidity%TYPE;
   location_no_  WAREHOUSE_BAY_BIN_TAB.location_no%TYPE;
BEGIN

   min_humidity_ := Get_Min_Humidity(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   max_humidity_ := Get_Max_Humidity(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (Part_Catalog_Invent_Attrib_API.Incorrect_Humidity_Range(min_humidity_, max_humidity_)) THEN
      location_no_ := Get_Location_No(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
      Error_SYS.Record_General(lu_name_, 'HUMRANGE: Incorrect Operative Humidity Range for Location No :P1 on Site :P2.', location_no_, contract_);
   END IF;
END Check_Humidity_Range;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Part_Number_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ WAREHOUSE_BAY_BIN.mix_of_part_number_blocked%TYPE; 
   mix_of_part_number_blocked_ WAREHOUSE_BAY_BIN_TAB.mix_of_part_number_blocked%TYPE;
   tier_mix_of_parts_blocked_  WAREHOUSE_BAY_BIN_TAB.mix_of_part_number_blocked%TYPE;
BEGIN
   dummy_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   mix_of_part_number_blocked_ := micro_cache_value_.mix_of_part_number_blocked;

   IF (mix_of_part_number_blocked_ = false_) THEN
      tier_mix_of_parts_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Parts_Blocked_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_mix_of_parts_blocked_ = false_) THEN
         mix_of_part_number_blocked_ := Warehouse_Bay_Row_API.Get_Mix_Of_Parts_Blocked_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         mix_of_part_number_blocked_ := tier_mix_of_parts_blocked_;
      END IF;
   END IF;
   RETURN Fnd_Boolean_API.Decode(mix_of_part_number_blocked_);
END Get_Mix_Of_Part_Number_Blocked;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Parts_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_part_number_blocked_ WAREHOUSE_BAY_BIN_TAB.mix_of_part_number_blocked%TYPE;
   tier_mix_of_parts_blocked_  WAREHOUSE_BAY_BIN_TAB.mix_of_part_number_blocked%TYPE;
BEGIN
   mix_of_part_number_blocked_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (mix_of_part_number_blocked_ = false_) THEN
      tier_mix_of_parts_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Parts_Blocked_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_mix_of_parts_blocked_ = false_) THEN
         mix_of_part_number_blocked_ := Warehouse_Bay_Row_API.Get_Mix_Of_Parts_Blocked_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         mix_of_part_number_blocked_ := tier_mix_of_parts_blocked_;
      END IF;
   END IF;
   RETURN (mix_of_part_number_blocked_);
END Get_Mix_Of_Parts_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Parent_Mix_Of_Parts_Bl_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_part_number_blocked_ WAREHOUSE_BAY_BIN_TAB.mix_of_part_number_blocked%TYPE;
   tier_mix_of_parts_blocked_  WAREHOUSE_BAY_BIN_TAB.mix_of_part_number_blocked%TYPE;
BEGIN
   tier_mix_of_parts_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Parts_Blocked_Db(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (tier_mix_of_parts_blocked_ = false_) THEN
      mix_of_part_number_blocked_ := Warehouse_Bay_Row_API.Get_Mix_Of_Parts_Blocked_Db(contract_, warehouse_id_, bay_id_, row_id_);
   ELSE
      mix_of_part_number_blocked_ := tier_mix_of_parts_blocked_;
   END IF;
   RETURN (mix_of_part_number_blocked_);
END Get_Parent_Mix_Of_Parts_Bl_Db;


@UncheckedAccess
FUNCTION Get_Mix_Of_Part_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_part_blocked_source_ VARCHAR2(200);
   tier_mix_of_parts_blocked_  WAREHOUSE_BAY_BIN_TAB.mix_of_part_number_blocked%TYPE;
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   IF (micro_cache_value_.mix_of_part_number_blocked = false_) THEN
      tier_mix_of_parts_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Parts_Blocked_Db(contract_,
                                                                                       warehouse_id_,
                                                                                       bay_id_,
                                                                                       tier_id_);
      IF (tier_mix_of_parts_blocked_ = false_) THEN
         mix_of_part_blocked_source_ := Warehouse_Bay_Row_API.Get_Mix_Of_Part_Blocked_Source(contract_,
                                                                                             warehouse_id_,
                                                                                             bay_id_,
                                                                                             row_id_);
      ELSE
         mix_of_part_blocked_source_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Part_Blocked_Source(contract_,
                                                                                              warehouse_id_,
                                                                                              bay_id_,
                                                                                              tier_id_);
      END IF;
   ELSE
      mix_of_part_blocked_source_ := Warehouse_Structure_Level_API.Decode(WAREHOUSE_STRUCTURE_LEVEL_API.DB_BIN);
   END IF;
   RETURN (mix_of_part_blocked_source_);
END Get_Mix_Of_Part_Blocked_Source;


@UncheckedAccess
FUNCTION Get_Parent_Mix_Of_Part_Bl_Src (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_part_blocked_source_ VARCHAR2(200);
   tier_mix_of_parts_blocked_  WAREHOUSE_BAY_BIN_TAB.mix_of_part_number_blocked%TYPE;
BEGIN
   tier_mix_of_parts_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Parts_Blocked_Db(contract_,
                                                                                    warehouse_id_,
                                                                                    bay_id_,
                                                                                    tier_id_);
   IF (tier_mix_of_parts_blocked_ = false_) THEN
      mix_of_part_blocked_source_ := Warehouse_Bay_Row_API.Get_Mix_Of_Part_Blocked_Source(contract_,
                                                                                          warehouse_id_,
                                                                                          bay_id_,
                                                                                          row_id_);
   ELSE
      mix_of_part_blocked_source_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Part_Blocked_Source(contract_,
                                                                                           warehouse_id_,
                                                                                           bay_id_,
                                                                                           tier_id_);
   END IF;
   RETURN (mix_of_part_blocked_source_);
END Get_Parent_Mix_Of_Part_Bl_Src;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Codes_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_   WAREHOUSE_BAY_BIN.mix_of_cond_codes_blocked%TYPE;   
   mix_of_cond_codes_blocked_ WAREHOUSE_BAY_BIN_TAB.mix_of_cond_codes_blocked%TYPE;
   tier_mix_of_cond_blocked_  WAREHOUSE_BAY_BIN_TAB.mix_of_cond_codes_blocked%TYPE;
BEGIN
   dummy_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   mix_of_cond_codes_blocked_ := micro_cache_value_.mix_of_cond_codes_blocked;

   IF (mix_of_cond_codes_blocked_ = false_) THEN
      tier_mix_of_cond_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Cond_Blocked_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_mix_of_cond_blocked_ = false_) THEN
         mix_of_cond_codes_blocked_ := Warehouse_Bay_Row_API.Get_Mix_Of_Cond_Blocked_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         mix_of_cond_codes_blocked_ := tier_mix_of_cond_blocked_;
      END IF;
   END IF;
   RETURN Fnd_Boolean_API.Decode(mix_of_cond_codes_blocked_);
END Get_Mix_Of_Cond_Codes_Blocked;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_cond_codes_blocked_ WAREHOUSE_BAY_BIN_TAB.mix_of_cond_codes_blocked%TYPE;
   tier_mix_of_cond_blocked_  WAREHOUSE_BAY_BIN_TAB.mix_of_cond_codes_blocked%TYPE;
BEGIN
   mix_of_cond_codes_blocked_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (mix_of_cond_codes_blocked_ = false_) THEN
      tier_mix_of_cond_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Cond_Blocked_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_mix_of_cond_blocked_ = false_) THEN
         mix_of_cond_codes_blocked_ := Warehouse_Bay_Row_API.Get_Mix_Of_Cond_Blocked_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         mix_of_cond_codes_blocked_ := tier_mix_of_cond_blocked_;
      END IF;
   END IF;
   RETURN (mix_of_cond_codes_blocked_);
END Get_Mix_Of_Cond_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Parent_Mix_Of_Cond_Bl_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_cond_codes_blocked_ WAREHOUSE_BAY_BIN_TAB.mix_of_cond_codes_blocked%TYPE;
   tier_mix_of_cond_blocked_  WAREHOUSE_BAY_BIN_TAB.mix_of_cond_codes_blocked%TYPE;
BEGIN
   tier_mix_of_cond_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Cond_Blocked_Db(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (tier_mix_of_cond_blocked_ = false_) THEN
      mix_of_cond_codes_blocked_ := Warehouse_Bay_Row_API.Get_Mix_Of_Cond_Blocked_Db(contract_, warehouse_id_, bay_id_, row_id_);
   ELSE
      mix_of_cond_codes_blocked_ := tier_mix_of_cond_blocked_;
   END IF;
   RETURN (mix_of_cond_codes_blocked_);
END Get_Parent_Mix_Of_Cond_Bl_Db;


@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_cond_blocked_source_ VARCHAR2(200);
   tier_mix_of_cond_blocked_   WAREHOUSE_BAY_BIN_TAB.mix_of_cond_codes_blocked%TYPE;
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   IF (micro_cache_value_.mix_of_cond_codes_blocked = false_) THEN
      tier_mix_of_cond_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Cond_Blocked_Db(contract_,
                                                                                     warehouse_id_,
                                                                                     bay_id_,
                                                                                     tier_id_);
      IF (tier_mix_of_cond_blocked_ = false_) THEN
         mix_of_cond_blocked_source_ := Warehouse_Bay_Row_API.Get_Mix_Of_Cond_Blocked_Source(contract_,
                                                                                             warehouse_id_,
                                                                                             bay_id_,
                                                                                             row_id_);
      ELSE
         mix_of_cond_blocked_source_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Cond_Blocked_Source(contract_,
                                                                                              warehouse_id_,
                                                                                              bay_id_,
                                                                                              tier_id_);
      END IF;
   ELSE
      mix_of_cond_blocked_source_ := Warehouse_Structure_Level_API.Decode(WAREHOUSE_STRUCTURE_LEVEL_API.DB_BIN);
   END IF;
   RETURN (mix_of_cond_blocked_source_);
END Get_Mix_Of_Cond_Blocked_Source;


@UncheckedAccess
FUNCTION Get_Parent_Mix_Of_Cond_Bl_Src (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_cond_blocked_source_ VARCHAR2(200);
   tier_mix_of_cond_blocked_   WAREHOUSE_BAY_BIN_TAB.mix_of_cond_codes_blocked%TYPE;
BEGIN
   tier_mix_of_cond_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Cond_Blocked_Db(contract_,
                                                                                  warehouse_id_,
                                                                                  bay_id_,
                                                                                  tier_id_);
   IF (tier_mix_of_cond_blocked_ = false_) THEN
      mix_of_cond_blocked_source_ := Warehouse_Bay_Row_API.Get_Mix_Of_Cond_Blocked_Source(contract_,
                                                                                          warehouse_id_,
                                                                                          bay_id_,
                                                                                          row_id_);
   ELSE
      mix_of_cond_blocked_source_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Cond_Blocked_Source(contract_,
                                                                                           warehouse_id_,
                                                                                           bay_id_,
                                                                                           tier_id_);
   END IF;
   RETURN (mix_of_cond_blocked_source_);
END Get_Parent_Mix_Of_Cond_Bl_Src;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Lot_Batch_Blocked (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_   WAREHOUSE_BAY_BIN.mix_of_lot_batch_no_blocked%TYPE;
   mix_of_lot_batch_blocked_      WAREHOUSE_BAY_BIN_TAB.mix_of_lot_batch_no_blocked%TYPE;
   tier_mix_of_lot_batch_blocked_ WAREHOUSE_BAY_BIN_TAB.mix_of_lot_batch_no_blocked%TYPE;
BEGIN   
   dummy_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   mix_of_lot_batch_blocked_ := micro_cache_value_.mix_of_lot_batch_no_blocked;

   IF (mix_of_lot_batch_blocked_ = false_) THEN
      tier_mix_of_lot_batch_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Lot_Blocked_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_mix_of_lot_batch_blocked_ = false_) THEN
         mix_of_lot_batch_blocked_ := Warehouse_Bay_Row_API.Get_Mix_Of_Lot_Blocked_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         mix_of_lot_batch_blocked_ := tier_mix_of_lot_batch_blocked_;
      END IF;
   END IF;
   RETURN Fnd_Boolean_API.Decode(mix_of_lot_batch_blocked_);
END Get_Mix_Of_Lot_Batch_Blocked;


@Override
@UncheckedAccess
FUNCTION Get_Mix_Of_Lot_Blocked_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_lot_batch_blocked_      WAREHOUSE_BAY_BIN_TAB.mix_of_lot_batch_no_blocked%TYPE;
   tier_mix_of_lot_batch_blocked_ WAREHOUSE_BAY_BIN_TAB.mix_of_lot_batch_no_blocked%TYPE;
BEGIN
   mix_of_lot_batch_blocked_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (mix_of_lot_batch_blocked_ = false_) THEN
      tier_mix_of_lot_batch_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Lot_Blocked_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_mix_of_lot_batch_blocked_ = false_) THEN
         mix_of_lot_batch_blocked_ := Warehouse_Bay_Row_API.Get_Mix_Of_Lot_Blocked_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         mix_of_lot_batch_blocked_ := tier_mix_of_lot_batch_blocked_;
      END IF;
   END IF;
   RETURN (mix_of_lot_batch_blocked_);
END Get_Mix_Of_Lot_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Parent_Mix_Of_Lot_Bl_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_lot_batch_blocked_      WAREHOUSE_BAY_BIN_TAB.mix_of_lot_batch_no_blocked%TYPE;
   tier_mix_of_lot_batch_blocked_ WAREHOUSE_BAY_BIN_TAB.mix_of_lot_batch_no_blocked%TYPE;
BEGIN
   tier_mix_of_lot_batch_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Lot_Blocked_Db(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (tier_mix_of_lot_batch_blocked_ = false_) THEN
      mix_of_lot_batch_blocked_ := Warehouse_Bay_Row_API.Get_Mix_Of_Lot_Blocked_Db(contract_, warehouse_id_, bay_id_, row_id_);
   ELSE
      mix_of_lot_batch_blocked_ := tier_mix_of_lot_batch_blocked_;
   END IF;
   RETURN (mix_of_lot_batch_blocked_);
END Get_Parent_Mix_Of_Lot_Bl_Db;


@UncheckedAccess
FUNCTION Get_Mix_Of_Lot_Blocked_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_lot_blocked_source_ VARCHAR2(200);
   tier_mix_of_lot_blocked_   WAREHOUSE_BAY_BIN_TAB.mix_of_lot_batch_no_blocked%TYPE;
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   IF (micro_cache_value_.mix_of_lot_batch_no_blocked = false_) THEN
      tier_mix_of_lot_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Lot_Blocked_Db(contract_,
                                                                                   warehouse_id_,
                                                                                   bay_id_,
                                                                                   tier_id_);
      IF (tier_mix_of_lot_blocked_ = false_) THEN
         mix_of_lot_blocked_source_ := Warehouse_Bay_Row_API.Get_Mix_Of_Lot_Blocked_Source(contract_,
                                                                                           warehouse_id_,
                                                                                           bay_id_,
                                                                                           row_id_);
      ELSE
         mix_of_lot_blocked_source_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Lot_Blocked_Source(contract_,
                                                                                            warehouse_id_,
                                                                                            bay_id_,
                                                                                            tier_id_);
      END IF;
   ELSE
      mix_of_lot_blocked_source_ := Warehouse_Structure_Level_API.Decode(WAREHOUSE_STRUCTURE_LEVEL_API.DB_BIN);
   END IF;
   RETURN (mix_of_lot_blocked_source_);
END Get_Mix_Of_Lot_Blocked_Source;


@UncheckedAccess
FUNCTION Get_Parent_Mix_Of_Lot_Bl_Src (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mix_of_lot_blocked_source_ VARCHAR2(200);
   tier_mix_of_lot_blocked_   WAREHOUSE_BAY_BIN_TAB.mix_of_lot_batch_no_blocked%TYPE;
BEGIN
   tier_mix_of_lot_blocked_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Lot_Blocked_Db(contract_,
                                                                                warehouse_id_,
                                                                                bay_id_,
                                                                                tier_id_);
   IF (tier_mix_of_lot_blocked_ = false_) THEN
      mix_of_lot_blocked_source_ := Warehouse_Bay_Row_API.Get_Mix_Of_Lot_Blocked_Source(contract_,
                                                                                        warehouse_id_,
                                                                                        bay_id_,
                                                                                        row_id_);
   ELSE
      mix_of_lot_blocked_source_ := Warehouse_Bay_Tier_API.Get_Mix_Of_Lot_Blocked_Source(contract_,
                                                                                         warehouse_id_,
                                                                                         bay_id_,
                                                                                         tier_id_);
   END IF;
   RETURN (mix_of_lot_blocked_source_);
END Get_Parent_Mix_Of_Lot_Bl_Src;


@Override
@UncheckedAccess
FUNCTION Get_Exclude_Storage_Req_Val (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_   WAREHOUSE_BAY_BIN.exclude_storage_req_val%TYPE;
   exclude_storage_req_val_      WAREHOUSE_BAY_BIN_TAB.exclude_storage_req_val%TYPE;
   tier_exclude_storage_req_val_ WAREHOUSE_BAY_BIN_TAB.exclude_storage_req_val%TYPE;
BEGIN
   dummy_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   exclude_storage_req_val_ := micro_cache_value_.exclude_storage_req_val;

   IF (exclude_storage_req_val_ = false_) THEN
      tier_exclude_storage_req_val_ := Warehouse_Bay_Tier_API.Get_Exclude_Storage_Req_Val_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_exclude_storage_req_val_ = false_) THEN 
         exclude_storage_req_val_ := Warehouse_Bay_Row_API.Get_Exclude_Storage_Req_Val_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         exclude_storage_req_val_ := tier_exclude_storage_req_val_;
      END IF;
   END IF;
   RETURN Fnd_Boolean_API.Decode(exclude_storage_req_val_);
END Get_Exclude_Storage_Req_Val;


@Override
@UncheckedAccess
FUNCTION Get_Exclude_Storage_Req_Val_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   exclude_storage_req_val_      WAREHOUSE_BAY_BIN_TAB.exclude_storage_req_val%TYPE;
   tier_exclude_storage_req_val_ WAREHOUSE_BAY_BIN_TAB.exclude_storage_req_val%TYPE;
BEGIN
   exclude_storage_req_val_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (exclude_storage_req_val_ = false_) THEN
      tier_exclude_storage_req_val_ := Warehouse_Bay_Tier_API.Get_Exclude_Storage_Req_Val_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      IF (tier_exclude_storage_req_val_ = false_) THEN 
         exclude_storage_req_val_ := Warehouse_Bay_Row_API.Get_Exclude_Storage_Req_Val_Db(contract_, warehouse_id_, bay_id_, row_id_);
      ELSE
         exclude_storage_req_val_ := tier_exclude_storage_req_val_;
      END IF;
   END IF;
   RETURN (exclude_storage_req_val_);
END Get_Exclude_Storage_Req_Val_Db;


@UncheckedAccess
FUNCTION Get_Parent_Excl_Strg_Req_Db (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   exclude_storage_req_val_      WAREHOUSE_BAY_BIN_TAB.exclude_storage_req_val%TYPE;
   tier_exclude_storage_req_val_ WAREHOUSE_BAY_BIN_TAB.exclude_storage_req_val%TYPE;
BEGIN
   tier_exclude_storage_req_val_ := Warehouse_Bay_Tier_API.Get_Exclude_Storage_Req_Val_Db(contract_, warehouse_id_, bay_id_, tier_id_);
   IF (tier_exclude_storage_req_val_ = false_) THEN
      exclude_storage_req_val_ := Warehouse_Bay_Row_API.Get_Exclude_Storage_Req_Val_Db(contract_, warehouse_id_, bay_id_, row_id_);
   ELSE
      exclude_storage_req_val_ := tier_exclude_storage_req_val_;
   END IF;
   RETURN (exclude_storage_req_val_);
END Get_Parent_Excl_Strg_Req_Db;


@UncheckedAccess
FUNCTION Get_Excl_Storage_Req_Val_Src (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   exclude_storage_req_val_src_  VARCHAR2(200);
   tier_exclude_storage_req_val_ WAREHOUSE_BAY_BIN_TAB.exclude_storage_req_val%TYPE;
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   IF (micro_cache_value_.exclude_storage_req_val = false_) THEN
      tier_exclude_storage_req_val_ := Warehouse_Bay_Tier_API.Get_Exclude_Storage_Req_Val_Db(contract_,
                                                                                             warehouse_id_,
                                                                                             bay_id_,
                                                                                             tier_id_);
      IF (tier_exclude_storage_req_val_ = false_) THEN 
         exclude_storage_req_val_src_ := Warehouse_Bay_Row_API.Get_Excl_Storage_Req_Val_Src(contract_,
                                                                                            warehouse_id_,
                                                                                            bay_id_,
                                                                                            row_id_);
      ELSE
         exclude_storage_req_val_src_ := Warehouse_Bay_Tier_API.Get_Excl_Storage_Req_Val_Src(contract_,
                                                                                             warehouse_id_,
                                                                                             bay_id_,
                                                                                             tier_id_);
      END IF;
   ELSE
      exclude_storage_req_val_src_ := Warehouse_Structure_Level_API.Decode(WAREHOUSE_STRUCTURE_LEVEL_API.DB_BIN);
   END IF;
   RETURN (exclude_storage_req_val_src_);
END Get_Excl_Storage_Req_Val_Src;


@UncheckedAccess
FUNCTION Get_Parent_Excl_Strg_Req_Src (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   exclude_storage_req_val_src_  VARCHAR2(200);
   tier_exclude_storage_req_val_ WAREHOUSE_BAY_BIN_TAB.exclude_storage_req_val%TYPE;
BEGIN
   tier_exclude_storage_req_val_ := Warehouse_Bay_Tier_API.Get_Exclude_Storage_Req_Val_Db(contract_,
                                                                                          warehouse_id_,
                                                                                          bay_id_,
                                                                                          tier_id_);
   IF (tier_exclude_storage_req_val_ = false_) THEN
      exclude_storage_req_val_src_ := Warehouse_Bay_Row_API.Get_Excl_Storage_Req_Val_Src(contract_,
                                                                                         warehouse_id_,
                                                                                         bay_id_,
                                                                                         row_id_);
   ELSE
      exclude_storage_req_val_src_ := Warehouse_Bay_Tier_API.Get_Excl_Storage_Req_Val_Src(contract_,
                                                                                          warehouse_id_,
                                                                                          bay_id_,
                                                                                          tier_id_);
   END IF;
   RETURN (exclude_storage_req_val_src_);
END Get_Parent_Excl_Strg_Req_Src;


@UncheckedAccess
FUNCTION Get_Putaway_Bins (
   contract_             IN VARCHAR2,
   sql_where_expression_ IN VARCHAR2 ) RETURN Putaway_Bin_Tab
IS
   db_picking_         CONSTANT VARCHAR2(7)  := Inventory_Location_Type_API.db_picking;
   db_floor_stock_     CONSTANT VARCHAR2(1)  := Inventory_Location_Type_API.db_floor_stock;
   db_production_line_ CONSTANT VARCHAR2(13) := Inventory_Location_Type_API.db_production_line;
   putaway_bin_tab_    Putaway_Bin_Tab;
   TYPE Get_Bins_Type  IS REF CURSOR;
   get_bins_           Get_Bins_Type;
   stmt_               VARCHAR2(32760);
BEGIN
   stmt_ :='
      SELECT a.warehouse_id, a.bay_id, a.tier_id, a.row_id, a.bin_id, a.location_no, a.location_group,
             NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, a.warehouse_route_order, 
             a.bay_route_order, a.row_route_order, a.tier_route_order, a.bin_route_order, NULL
      FROM   inventory_location_pub a, inventory_location_group_tab b
      WHERE  a.location_group = b.location_group
      AND    (b.inventory_location_type IN (:db_picking, :db_floor_stock, :db_production_line))
      AND    a.contract      = :contract
      AND    (' || sql_where_expression_ || ')';
      
   @ApproveDynamicStatement(2012-11-02,NipKlk)
   OPEN get_bins_ FOR stmt_ using db_picking_,
                                  db_floor_stock_,
                                  db_production_line_,
                                  contract_;

   FETCH get_bins_ BULK COLLECT INTO putaway_bin_tab_;
   CLOSE get_bins_;
   
   RETURN(putaway_bin_tab_);
END Get_Putaway_Bins;

FUNCTION Bin_Is_In_Storage_Zone (
   contract_        IN VARCHAR2,
   storage_zone_id_ IN VARCHAR2,
   zone_source_db_  IN VARCHAR2,
   warehouse_id_    IN VARCHAR2,
   bay_id_          IN VARCHAR2,
   tier_id_         IN VARCHAR2,
   row_id_          IN VARCHAR2,
   bin_id_          IN VARCHAR2 ) RETURN BOOLEAN
IS
   TYPE Exist_Control_Type IS REF CURSOR;
   exist_control_          Exist_Control_Type;
   stmt_                   VARCHAR2(32000);
   dummy_                  NUMBER;
   sql_where_expression_   VARCHAR2(28000);
   db_picking_             CONSTANT VARCHAR2(7)  := Inventory_Location_Type_API.db_picking;
   db_floor_stock_         CONSTANT VARCHAR2(1)  := Inventory_Location_Type_API.db_floor_stock;
   db_production_line_     CONSTANT VARCHAR2(13) := Inventory_Location_Type_API.db_production_line; 
   bin_is_in_storage_zone_ BOOLEAN := FALSE;
BEGIN
   sql_where_expression_ := Invent_Part_Putaway_Zone_API.Get_Sql_Where_Expression(contract_, storage_zone_id_, zone_source_db_);

   stmt_ :='
      SELECT 1
      FROM   warehouse_bay_bin_tab a, inventory_location_group_tab b
      WHERE  a.location_group = b.location_group
      AND    b.inventory_location_type IN (:db_picking, :db_floor_stock, :db_production_line)
      AND    a.contract      = :contract
      and    a.warehouse_id  = :warehouse_id
      and    a.bay_id        = :bay_id
      and    a.tier_id       = :tier_id
      and    a.row_id        = :row_id
      and    a.bin_id        = :bin_id
      AND    (' || sql_where_expression_ || ')';
      
   @ApproveDynamicStatement(2016-03-21,LePeSe)
   OPEN exist_control_ FOR stmt_ using db_picking_,
                                       db_floor_stock_,
                                       db_production_line_,                                      
                                       contract_,
                                       warehouse_id_,
                                       bay_id_,
                                       tier_id_,
                                       row_id_,
                                       bin_id_;

   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      bin_is_in_storage_zone_ := TRUE;
   END IF;
   CLOSE exist_control_;

   RETURN(bin_is_in_storage_zone_);
END Bin_Is_In_Storage_Zone;

@UncheckedAccess
FUNCTION Get_Location_Numbers (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 DEFAULT NULL,
   tier_id_      IN VARCHAR2 DEFAULT NULL,
   row_id_       IN VARCHAR2 DEFAULT NULL,
   bin_id_       IN VARCHAR2 DEFAULT NULL ) RETURN Inventory_Part_In_Stock_API.Inventory_Location_Table
IS
   location_no_tab_ Inventory_Part_In_Stock_API.Inventory_Location_Table;
   
   CURSOR get_tier_row_locations IS
      SELECT location_no
      FROM   WAREHOUSE_BAY_BIN_TAB
      WHERE  contract     = contract_
      AND    warehouse_id = warehouse_id_
      AND    bay_id       = bay_id_
      AND    tier_id      = tier_id_
      AND    row_id       = row_id_;

   CURSOR get_row_locations IS
      SELECT location_no
      FROM   WAREHOUSE_BAY_BIN_TAB
      WHERE  contract     = contract_
      AND    warehouse_id = warehouse_id_
      AND    bay_id       = bay_id_
      AND    row_id       = row_id_;

   CURSOR get_tier_locations IS
      SELECT location_no
      FROM   WAREHOUSE_BAY_BIN_TAB
      WHERE  contract     = contract_
      AND    warehouse_id = warehouse_id_
      AND    bay_id       = bay_id_
      AND    tier_id      = tier_id_;

   CURSOR get_bay_locations IS
      SELECT location_no
      FROM   WAREHOUSE_BAY_BIN_TAB
      WHERE  contract     = contract_
      AND    warehouse_id = warehouse_id_
      AND    bay_id       = bay_id_;
      
    CURSOR get_warehouse_locations IS
      SELECT location_no
      FROM   WAREHOUSE_BAY_BIN_TAB
      WHERE  contract     = contract_
      AND    warehouse_id = warehouse_id_;
BEGIN
   IF (bin_id_ IS NULL) THEN
      IF (row_id_ IS NULL) THEN
         IF (tier_id_ IS NULL) THEN
            IF (bay_id_ IS NULL) THEN
               OPEN  get_warehouse_locations;
               FETCH get_warehouse_locations BULK COLLECT INTO location_no_tab_;
               CLOSE get_warehouse_locations;
            ELSE
               OPEN  get_bay_locations;
               FETCH get_bay_locations BULK COLLECT INTO location_no_tab_;
               CLOSE get_bay_locations;
            END IF;
         ELSE
            OPEN  get_tier_locations;
            FETCH get_tier_locations BULK COLLECT INTO location_no_tab_;
            CLOSE get_tier_locations;
         END IF;
      ELSE
         IF (tier_id_ IS NULL) THEN
            OPEN  get_row_locations;
            FETCH get_row_locations BULK COLLECT INTO location_no_tab_;
            CLOSE get_row_locations;
         ELSE
            OPEN  get_tier_row_locations;
            FETCH get_tier_row_locations BULK COLLECT INTO location_no_tab_;
            CLOSE get_tier_row_locations;
         END IF;
      END IF;
   ELSE
      location_no_tab_(1) := Get_Location_No(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   END IF;

   RETURN location_no_tab_;
END Get_Location_Numbers;


FUNCTION Get_Free_Carrying_Capacity (
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   tier_id_                      IN VARCHAR2,
   row_id_                       IN VARCHAR2,
   bin_id_                       IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
   free_carrying_capacity_     NUMBER := positive_infinity_;
   total_carrying_capacity_    NUMBER;
   consumed_carrying_capacity_ NUMBER;
BEGIN
   total_carrying_capacity_ := Get_Carrying_Capacity(contract_,
                                                     warehouse_id_,
                                                     bay_id_,
                                                     tier_id_,
                                                     row_id_,
                                                     bin_id_);

   IF (total_carrying_capacity_ < positive_infinity_) THEN
      consumed_carrying_capacity_ := Inventory_Part_In_Stock_API.Get_Consumed_Carrying_Capacity(contract_                     => contract_,
                                                                                                warehouse_id_                 => warehouse_id_,
                                                                                                bay_id_                       => bay_id_,
                                                                                                tier_id_                      => tier_id_,
                                                                                                row_id_                       => row_id_,
                                                                                                bin_id_                       => bin_id_,
                                                                                                ignore_this_handling_unit_id_ => ignore_this_handling_unit_id_);
      free_carrying_capacity_ := total_carrying_capacity_ - consumed_carrying_capacity_;
   END IF;
   RETURN (free_carrying_capacity_);
END Get_Free_Carrying_Capacity; 


FUNCTION Get_Free_Volume_Capacity (
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   tier_id_                      IN VARCHAR2,
   row_id_                       IN VARCHAR2,
   bin_id_                       IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
   free_volume_capacity_     NUMBER := positive_infinity_;
   total_volume_capacity_    NUMBER;
   consumed_volume_capacity_ NUMBER;
BEGIN
   total_volume_capacity_ := Get_Volume_Capacity(contract_,
                                                 warehouse_id_,
                                                 bay_id_,
                                                 tier_id_,
                                                 row_id_,
                                                 bin_id_);

   IF (total_volume_capacity_ < positive_infinity_) THEN
      consumed_volume_capacity_ := Inventory_Part_In_Stock_API.Get_Consumed_Volume_Capacity(contract_                     => contract_,
                                                                                            warehouse_id_                 => warehouse_id_,
                                                                                            bay_id_                       => bay_id_,
                                                                                            tier_id_                      => tier_id_,
                                                                                            row_id_                       => row_id_,
                                                                                            bin_id_                       => bin_id_,
                                                                                            ignore_this_handling_unit_id_ => ignore_this_handling_unit_id_);
      free_volume_capacity_ := total_volume_capacity_ - consumed_volume_capacity_;
   END IF;
   RETURN (free_volume_capacity_);
END Get_Free_Volume_Capacity;


PROCEDURE Lock_By_Keys_Wait (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 )
IS
   dummy_ WAREHOUSE_BAY_BIN_TAB%ROWTYPE;
BEGIN

   dummy_ := Lock_By_Keys___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

END Lock_By_Keys_Wait;


PROCEDURE Exist_With_Wildcard (
   contract_         IN VARCHAR2,
   warehouse_id_     IN VARCHAR2,
   bay_id_           IN VARCHAR2,
   tier_id_          IN VARCHAR2,
   row_id_           IN VARCHAR2,
   location_type_db_ IN VARCHAR2,
   location_group_   IN VARCHAR2 )
IS
   exist_with_wildcard_ BOOLEAN := FALSE;

   CURSOR get_location_group IS
      SELECT DISTINCT location_group
        FROM WAREHOUSE_BAY_BIN_TAB
       WHERE contract       = contract_
         AND warehouse_id   LIKE NVL(warehouse_id_  , '%')
         AND bay_id         LIKE NVL(bay_id_        , '%')
         AND tier_id        LIKE NVL(tier_id_       , '%')
         AND row_id         LIKE NVL(row_id_        , '%')
         AND location_group LIKE NVL(location_group_, '%');
BEGIN

   FOR rec_ IN get_location_group LOOP
      IF (Inventory_Location_Group_API.Get_Inventory_Location_Type_Db(rec_.location_group) LIKE location_type_db_) THEN
         exist_with_wildcard_ := TRUE;
         EXIT;
      END IF;
   END LOOP;
   
   IF (NOT exist_with_wildcard_) THEN
      Error_SYS.Record_Not_Exist(lu_name_, 'WILDNOTEXIST: The search criterias do not match any Inventory Locations on Site :P1.', contract_);
   END IF;

END Exist_With_Wildcard;


@UncheckedAccess
PROCEDURE Get_Route_Order_Strings (
   warehouse_route_order_ OUT VARCHAR2,
   bay_route_order_       OUT VARCHAR2,
   row_route_order_       OUT VARCHAR2,
   tier_route_order_      OUT VARCHAR2,
   bin_route_order_       OUT VARCHAR2,
   contract_              IN  VARCHAR2,
   location_no_           IN  VARCHAR2)
IS
   CURSOR location_strings IS
      SELECT warehouse_route_order,
             bay_route_order,
             row_route_order,
             tier_route_order,
             bin_route_order
      FROM   inventory_location_pub
      WHERE contract    = contract_
      AND   location_no = location_no_;
BEGIN
   OPEN  location_strings;
   FETCH location_strings INTO warehouse_route_order_, bay_route_order_, row_route_order_, tier_route_order_, bin_route_order_;
   CLOSE location_strings;
END Get_Route_Order_Strings;


@UncheckedAccess
FUNCTION Get_Media_Id (
   contract_    IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN ROWID
IS
   warehouse_id_ VARCHAR2(15);
   bay_id_       VARCHAR2(5);
   tier_id_      VARCHAR2(5);
   row_id_       VARCHAR2(5);
   bin_id_       VARCHAR2(5);
   lu_name_      VARCHAR2(30) := 'WarehouseBayBin';
   media_id_     ROWID;
   objid_        WAREHOUSE_BAY_BIN.objid%TYPE;
   objversion_   WAREHOUSE_BAY_BIN.objversion%TYPE;
BEGIN
   Get_Location_Strings(warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_, contract_, location_no_);
   Get_Id_Version_By_Keys___(objid_, objversion_, contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   media_id_ := Media_Library_Item_API.Get_Def_Media_Obj_Id(Media_Library_API.Get_Library_Id_From_Obj_Id(lu_name_, objid_));
   RETURN media_id_;
END Get_Media_Id;


@UncheckedAccess
FUNCTION Get_Availability_Control_Id (
   contract_    IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2 
IS   
   warehouse_id_            WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE;
   bay_id_                  WAREHOUSE_BAY_BIN_TAB.bay_id%TYPE;
   tier_id_                 WAREHOUSE_BAY_BIN_TAB.tier_id%TYPE;
   row_id_                  WAREHOUSE_BAY_BIN_TAB.row_id%TYPE;
   bin_id_                  WAREHOUSE_BAY_BIN_TAB.bin_id%TYPE;
   availability_control_id_ WAREHOUSE_BAY_BIN_TAB.availability_control_id%TYPE;
BEGIN
   IF (location_no_ IS NOT NULL) THEN
      Get_Location_Strings(warehouse_id_,
                           bay_id_,
                           tier_id_,
                           row_id_,
                           bin_id_,
                           contract_,
                           location_no_);
                           
      IF (warehouse_id_ IS NOT NULL) THEN
         availability_control_id_ := Get_Availability_Control_Id(contract_,
                                                                 warehouse_id_,
                                                                 bay_id_,
                                                                 tier_id_,
                                                                 row_id_,
                                                                 bin_id_);
      END IF;
   END IF;
   RETURN availability_control_id_;   
END Get_Availability_Control_Id;


@Override
@UncheckedAccess
FUNCTION Get_Availability_Control_Id (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   avail_ctrl_id_             WAREHOUSE_BAY_BIN_TAB.availability_control_id%TYPE;
   row_avail_ctrl_id_         WAREHOUSE_BAY_BIN_TAB.availability_control_id%TYPE;
   tier_avail_ctrl_id_        WAREHOUSE_BAY_BIN_TAB.availability_control_id%TYPE;
   row_avail_ctrl_id_src_db_  VARCHAR2(20);
   tier_avail_ctrl_id_src_db_ VARCHAR2(20);
BEGIN
   avail_ctrl_id_ := super(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (avail_ctrl_id_ IS NULL) THEN
      row_avail_ctrl_id_src_db_ := Warehouse_Bay_Row_API.Get_Avail_Control_Id_Source_Db(contract_, warehouse_id_, bay_id_, row_id_);
      tier_avail_ctrl_id_src_db_ := Warehouse_Bay_Tier_API.Get_Avail_Control_Id_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);
      
      IF (row_avail_ctrl_id_src_db_ IS NULL) THEN
         IF (tier_avail_ctrl_id_src_db_ IS NULL) THEN
            -- No value found on either ROW or TIER. Method can return NULL.
            NULL;
         ELSE
            -- ROW does not have a default value but TIER has. Return value from TIER.
            avail_ctrl_id_ := Warehouse_Bay_Tier_API.Get_Availability_Control_Id(contract_, warehouse_id_, bay_id_, tier_id_);
         END IF;
      ELSE
         -- ROW value source IS NOT NULL.
         IF (tier_avail_ctrl_id_src_db_ IS NULL) THEN
            -- TIER value source IS NULL, use value from ROW.
            avail_ctrl_id_ := Warehouse_Bay_Row_API.Get_Availability_Control_Id(contract_, warehouse_id_, bay_id_, row_id_);
         ELSE
            -- ROW value source IS NOT NULL. TIER value source IS NOT NULL.
            IF (row_avail_ctrl_id_src_db_ = tier_avail_ctrl_id_src_db_) THEN
               -- ROW and TIER has the same value source (BAY or WAREHOUSE). Use either value because they are the same.
               avail_ctrl_id_ := Warehouse_Bay_Row_API.Get_Availability_Control_Id(contract_, warehouse_id_, bay_id_, row_id_);
            ELSE
               IF (row_avail_ctrl_id_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_avail_ctrl_id_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- There is a value set on both TIER and ROW.
                     -- Both values need to be fetched and compared to pick the value with highest ranking.
                     row_avail_ctrl_id_ := Warehouse_Bay_Row_API.Get_Availability_Control_Id(contract_, warehouse_id_, bay_id_, row_id_);
                     tier_avail_ctrl_id_ := Warehouse_Bay_Tier_API.Get_Availability_Control_Id(contract_, warehouse_id_, bay_id_, tier_id_);
                     IF (Get_Prio_Avail_Ctrl_Id_Src___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, row_avail_ctrl_id_, tier_avail_ctrl_id_) = 'ROW') THEN
                        -- Value from ROW has highest prio.
                        avail_ctrl_id_ := Warehouse_Bay_Row_API.Get_Availability_Control_Id(contract_, warehouse_id_, bay_id_, row_id_);
                     ELSE
                        -- Value from TIER has highest prio.
                        avail_ctrl_id_ := Warehouse_Bay_Tier_API.Get_Availability_Control_Id(contract_, warehouse_id_, bay_id_, tier_id_);
                     END IF;
                  ELSE
                     -- ROW has a specific value entered on ROW level.
                     -- TIER also has a value but that one is inherited from BAY or WAREHOUSE.
                     -- Use value from ROW.
                     avail_ctrl_id_ := Warehouse_Bay_Row_API.Get_Availability_Control_Id(contract_, warehouse_id_, bay_id_, row_id_);
                  END IF;
               ELSE
                  -- ROW value source IS NOT ROW, it must be either BAY or WAREHOUSE.
                  IF (tier_avail_ctrl_id_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER value source is TIER, use value from TIER.
                     avail_ctrl_id_ := Warehouse_Bay_Tier_API.Get_Availability_Control_Id(contract_, warehouse_id_, bay_id_, tier_id_);
                  END IF;
               END IF;
            END IF;
         END IF; 
      END IF;
   END IF;
   
   RETURN avail_ctrl_id_;
END Get_Availability_Control_Id;


@UncheckedAccess
FUNCTION Get_Avail_Control_Id_Source (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   avail_ctrl_id_src_db_      VARCHAR2(25);
   row_avail_ctrl_id_         WAREHOUSE_BAY_BIN_TAB.availability_control_id%TYPE;
   tier_avail_ctrl_id_        WAREHOUSE_BAY_BIN_TAB.availability_control_id%TYPE;
   row_avail_ctrl_id_src_db_  VARCHAR2(20);
   tier_avail_ctrl_id_src_db_ VARCHAR2(20);
   
BEGIN
   Update_Cache___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   
   IF (micro_cache_value_.availability_control_id IS NULL) THEN
      row_avail_ctrl_id_src_db_ := Warehouse_Bay_Row_API.Get_Avail_Control_Id_Source_Db (contract_, warehouse_id_, bay_id_, row_id_);
      tier_avail_ctrl_id_src_db_ := Warehouse_Bay_Tier_API.Get_Avail_Control_Id_Source_Db(contract_, warehouse_id_, bay_id_, tier_id_);

      IF (row_avail_ctrl_id_src_db_ IS NULL) THEN
         IF (tier_avail_ctrl_id_src_db_ IS NULL) THEN
            -- No value found on either ROW or TIER. Method can return NULL.
            NULL;
         ELSE
            -- ROW does not have a default value but TIER has. Return value source from TIER.
            avail_ctrl_id_src_db_ := tier_avail_ctrl_id_src_db_;
         END IF;
      ELSE
         -- ROW value source IS NOT NULL.
         IF (tier_avail_ctrl_id_src_db_ IS NULL) THEN
            -- TIER value source IS NULL, use value from ROW.
            avail_ctrl_id_src_db_ := row_avail_ctrl_id_src_db_;
         ELSE
            -- ROW value source IS NOT NULL. TIER value source IS NOT NULL.
            IF (row_avail_ctrl_id_src_db_ = tier_avail_ctrl_id_src_db_) THEN
               -- ROW and TIER has the same value source (BAY or WAREHOUSE). Use either value because they are the same.
               avail_ctrl_id_src_db_ := row_avail_ctrl_id_src_db_;
            ELSE
               IF (row_avail_ctrl_id_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_ROW) THEN
                  IF (tier_avail_ctrl_id_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- There is a value set on both TIER and ROW.
                     -- Both values need to be fetched and compared to pick the value with highest ranking.
                     row_avail_ctrl_id_ := Warehouse_Bay_Row_API.Get_Availability_Control_Id(contract_, warehouse_id_, bay_id_, row_id_);
                     tier_avail_ctrl_id_ := Warehouse_Bay_Tier_API.Get_Availability_Control_Id(contract_, warehouse_id_, bay_id_, tier_id_);
                     IF (Get_Prio_Avail_Ctrl_Id_Src___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, row_avail_ctrl_id_, tier_avail_ctrl_id_) = 'ROW') THEN
                        -- Value from ROW has highest prio.
                        avail_ctrl_id_src_db_ := row_avail_ctrl_id_src_db_;
                     ELSE
                        -- Value from TIER has highest prio.
                        avail_ctrl_id_src_db_ := tier_avail_ctrl_id_src_db_;
                     END IF;
                  ELSE
                     -- ROW has a specific value entered on ROW level. 
                     -- TIER also has a value but that one is inherited from BAY or WAREHOUSE.
                     -- Use value from ROW.
                     avail_ctrl_id_src_db_ := row_avail_ctrl_id_src_db_;
                  END IF;
               ELSE
                  -- ROW value source IS NOT ROW, it must be either BAY or WAREHOUSE.
                  IF (tier_avail_ctrl_id_src_db_ = WAREHOUSE_STRUCTURE_LEVEL_API.DB_TIER) THEN
                     -- TIER value source is TIER, use value from TIER.
                     avail_ctrl_id_src_db_ := tier_avail_ctrl_id_src_db_;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   ELSE
      avail_ctrl_id_src_db_ := Warehouse_Structure_Level_API.DB_BIN;
   END IF;
   RETURN (Warehouse_Structure_Level_API.Decode(avail_ctrl_id_src_db_));
END Get_Avail_Control_Id_Source;

@UncheckedAccess
FUNCTION Receipts_Blocked (
   contract_     IN  VARCHAR2,
   location_no_  IN  VARCHAR2 ) RETURN BOOLEAN
IS
   receipts_blocked_    BOOLEAN := FALSE;
   warehouse_id_        VARCHAR2(15);
   bay_id_              VARCHAR2(5);
   tier_id_             VARCHAR2(5);
   row_id_              VARCHAR2(5);
   bin_id_              VARCHAR2(5);
BEGIN
   IF (location_no_ IS NOT NULL) THEN
      Get_Location_Strings(warehouse_id_,
                           bay_id_,
                           tier_id_,
                           row_id_,
                           bin_id_,
                           contract_,
                           location_no_);
      receipts_blocked_ := Get_Receipts_Blocked_Db(contract_,
                                                   warehouse_id_,
                                                   bay_id_,
                                                   tier_id_,
                                                   row_id_,
                                                   bin_id_) = Fnd_Boolean_API.db_true;
   END IF;       
   RETURN receipts_blocked_;
END Receipts_Blocked;

FUNCTION Get_Storage_Zone_Locations (
   contract_        IN VARCHAR2,
   storage_zone_id_ IN VARCHAR2 ) RETURN Location_No_Tab
IS
   sql_where_expression_ VARCHAR2(28000);
   putaway_bin_tab_      Putaway_Bin_Tab;
   location_no_tab_      Location_No_Tab;
   count_                PLS_INTEGER := 0;
BEGIN
    sql_where_expression_ := Storage_Zone_API.Get_Sql_Where_Expression(contract_, storage_zone_id_);
    putaway_bin_tab_      := Warehouse_Bay_Bin_API.Get_Putaway_Bins(contract_, sql_where_expression_);

    IF putaway_bin_tab_.COUNT > 0 THEN
      FOR i in putaway_bin_tab_.first..putaway_bin_tab_.last loop
        count_ := count_ + 1;
        location_no_tab_(count_) := putaway_bin_tab_(i).location_no;
      END LOOP;
    END IF;

   RETURN(location_no_tab_);
END Get_Storage_Zone_Locations;


FUNCTION Get_Hu_Type_Capacity (
   contract_              IN VARCHAR2,
   warehouse_id_          IN VARCHAR2,
   bay_id_                IN VARCHAR2,
   tier_id_               IN VARCHAR2,
   row_id_                IN VARCHAR2,
   bin_id_                IN VARCHAR2,
   handling_unit_type_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   this_hu_type_stock_counter_   NUMBER  := 0;
   hu_type_capacity_exists_      BOOLEAN := FALSE;
   handling_unit_type_capacity_  NUMBER;
   hu_type_with_capacity_tab_    Handling_Unit_Type_API.Unit_Type_Tab;
   handling_unit_type_tab_       Handling_Unit_Type_API.Unit_Type_Tab;   
   rec_                          warehouse_bay_bin_tab%ROWTYPE;
   inbound_handl_unit_stock_tab_ Handl_Unit_Stock_Snapshot_API.Handl_Unit_Stock_Tab;
BEGIN
   -- Get a list of all handling unit types for which there is a capacity limit defined on this location. 
   hu_type_with_capacity_tab_ := Warehouse_Bin_Hu_Capacity_API.Get_Hu_Types_Having_Cap_Limits(contract_,
                                                                                              warehouse_id_,
                                                                                              bay_id_,
                                                                                              tier_id_,
                                                                                              row_id_,
                                                                                              bin_id_);
   IF (hu_type_with_capacity_tab_.COUNT = 0) THEN
      -- There are no capacity limits defined for any Handling Unit Type. So this location can be seen as having unlimited hu type capacity.
      RETURN (positive_infinity_);
   END IF;

   handling_unit_type_capacity_ := NVL(Warehouse_Bin_Hu_Capacity_API.Get_Operative_Hu_Type_Capacity(contract_,
                                                                                                    warehouse_id_,
                                                                                                    bay_id_,
                                                                                                    tier_id_,
                                                                                                    row_id_,
                                                                                                    bin_id_,
                                                                                                    handling_unit_type_id_), positive_infinity_);
   IF (handling_unit_type_capacity_ = 0) THEN
      -- Zero actually means that the handling unit type is "forbidden" on this location.
      RETURN (0);
   END IF;

   -- Need to lock the bin before fetching from get_root_hu_types_in_stock to prevent two parallell
   -- Putwaway sessions from finding and consuming the same available HU Capacity
   rec_ := Lock_By_Keys___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   handling_unit_type_tab_ := Inventory_Part_In_Stock_API.Get_Root_Hu_Types_In_Stock(contract_,
                                                                                     warehouse_id_,
                                                                                     bay_id_,
                                                                                     tier_id_,
                                                                                     row_id_,
                                                                                     bin_id_);
   IF (handling_unit_type_tab_.COUNT > 0) THEN
      handling_unit_type_capacity_ := Get_Hu_Type_Capacity___(this_hu_type_stock_counter_   => this_hu_type_stock_counter_,
                                                              handl_unit_type_in_stock_tab_ => handling_unit_type_tab_,
                                                              hu_type_with_capacity_tab_    => hu_type_with_capacity_tab_,
                                                              this_handling_unit_type_id_   => handling_unit_type_id_,
                                                              this_hu_type_capacity_        => handling_unit_type_capacity_);
   END IF;

   IF (handling_unit_type_capacity_ > 0) THEN
      -- No stock on the location prevents adding additional handling unit(s) of the investigated type
      -- But there could be inbound stock that has already booked this capacity. Need to look at inbound transport tasks.
      inbound_handl_unit_stock_tab_ := Transport_Task_API.Get_Inbound_Handling_Units(rec_.contract, rec_.location_no);

      IF (inbound_handl_unit_stock_tab_.COUNT > 0) THEN
         handling_unit_type_tab_.DELETE;
         FOR i IN inbound_handl_unit_stock_tab_.FIRST..inbound_handl_unit_stock_tab_.LAST LOOP
            handling_unit_type_tab_(i).handling_unit_type_id := Handling_Unit_API.Get_Handling_Unit_Type_Id(inbound_handl_unit_stock_tab_(i).handling_unit_id);
         END LOOP;
         handling_unit_type_capacity_ := Get_Hu_Type_Capacity___(this_hu_type_stock_counter_   => this_hu_type_stock_counter_,
                                                                 handl_unit_type_in_stock_tab_ => handling_unit_type_tab_,
                                                                 hu_type_with_capacity_tab_    => hu_type_with_capacity_tab_,
                                                                 this_handling_unit_type_id_   => handling_unit_type_id_,
                                                                 this_hu_type_capacity_        => handling_unit_type_capacity_);
      END IF;
   END IF;

   RETURN (handling_unit_type_capacity_);
END Get_Hu_Type_Capacity;

FUNCTION Get_Base_Bin_Volume_Capacity (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR get_volume_ IS
   SELECT volume_capacity
     FROM warehouse_bay_bin
    WHERE contract = contract_
      AND warehouse_id = warehouse_id_
      AND bay_id = bay_id_
      AND tier_id = tier_id_
      AND row_id = row_id_
      AND bin_id = bin_id_;
BEGIN
   OPEN get_volume_;
   FETCH get_volume_ INTO dummy_;
   CLOSE get_volume_;
   RETURN dummy_;
END Get_Base_Bin_Volume_Capacity;


@UncheckedAccess
FUNCTION Get_Default_Bin_Id RETURN VARCHAR2
IS
BEGIN
   RETURN default_bin_id_;
END Get_Default_Bin_Id;

