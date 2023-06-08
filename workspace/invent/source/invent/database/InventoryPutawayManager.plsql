-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPutawayManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220118  LEPESE  SC21R2-2766, Correction in Check_Storage_Requirements to not approve the complete root handling unit ID after the first stock record validation
--  220118          if there are any Mix Blocked settings on the destination location and the Handling Unit has corresponding mixed content.
--  220105  LEPESE  SC21R2-2766, Correction to make sure that no Lock_By_Keys_Wait methods are called within an autonomous transaction context.
--  220103  LEPESE  SC21R2-2766, Added public method Putaway_Handling_Units. Major redesign of the putaway logic to use tables with persistent storage
--  220103          instead of temporary tables and collections. Introduced the putaway_session_id_ as a key and used autonomous transaction plus commit
--  220103          when writing to the database tables because of a savepoint and rollback in Putaway_Handling_Unit___. 
--  211130  SBalLK  SC21R2-6433, Added Approve_Handling_Unit___() and Handling_Unit_Approved___() methods and modified Check_Storage_Requirements() method
--  211130          to not validate same handling unit repetitive to improve the performance on transport task execution.
--  210427  JaThlk  Bug 158912 (SCZ-14438), Modified Violating_Hu_Type_Capacity___() to pass the value FALSE into a default parameter of 
--  210427          the method Transport_Task_API.Get_Inbound_Handling_Units().
--  200908  AsZelk  SC2020R1-9620, Modified Putaway_Handling_Unit() to allow when source ref type is Shipment Order.
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  200202  KHVESE  SCSPRING20-1749, Modified methods Putaway___ to call to Get_Order_Receipt_Serial_Count instead of Get_Pur_Receipt_Serial_Count.
--  200217  PAWELK  Bug 152470 (MFZ-3300), Modified Putaway_Handling_Unit() by replacing Get_Append_Putaway_Bin_Tab___() with Append_Putaway_Bin_Tab___() to increase the performance.
--  200203  SBalLK  Bug 152206(SCZ-8596), Added two Get_Capability_Appr_Bins___() methods and Bin_Is_Capability_Approved___() with restoring code implementation before
--  200203          the bug correction 150748 (SCZ-6531). Renamed restored Get_Capability_Appr_Bins___() method to Get_Capab_Appr_Few_Bins___() since this method now 
--  200203          handle small number of putaway bins. Added switch between solution to find capability approved bins according to the Manuf/Distribution parameter 
--  200203          for large and small warehouses. Renamed the Get_Capability_Appr_Bins___() method with Get_Capab_Appr_Large_Bins___().
--  200120  PamPlk  Bug 151605 (SCZ-7963), Modified Violating_Hu_Type_Capacity___() in order to compare the inbound handling unit id with the correct root handling unit id. 
--  191118  SBalLK  Bug 150748 (SCZ-6531), Modified Get_Capability_Appr_Bins___() for efficiently fetch possible putaway bin locations for the putaway part.
--  190627  SBalLK  SCUXXW4-22873, Modified Putaway___() and Putaway_Handling_Unit() methods to fetch sql_where_statement seperately since it can be exceed the 4000 chars.
--  190527  Asawlk  Bug 148371(SCZ-5020), Moved the transport_task_id_ clearing login from Putaway_Part___ to Putaway___. transport_task_id_ clearing
--  190527          will take place when putaway is performed not in context of handling unit.
--  181127  DilMlk  Bug 145556(SCZ-1596), Modified method Get_Qty_That_Must_Be_Moved___ to prevent generating transport tasks recursively, to putaway inventory 
--  181127          quantity between two inventory locations in the same storage zone.
--  181108  LEPESE  SCUXXW4-14169, correction in Get_Qty_That_Must_Be_Moved___ to assign HU quantity to return value variable qty_that_must_be_moved_.
--  180308  LEPESE  STRSC-17479, Added package constant last_character_ and replaced usage of Database_SYS.Get_Last_Character with this new constant for increased performance.
--  180221  JaThlk  Bug 140182, Added parameter performing_optimization_ to methods Forbidden_Mix_Of_Conditions___, Forbidden_Mix_Of_Lot_Batch___ 
--  180221          and Forbidden_Mixing_Of_Parts___.
--  180220  LEPESE  STRSC-17081, Added parameter handling_unit_id_investigated_ to Is_Available_Bin___ and Violating_Hu_Type_Capacity___.
--  180219  LEPESE  STRSC-17074, Adjustment in Putaway___ to make sure that all bins in the zone are considered when counting no_of_bins_in_use_.
--  180215  LEPESE  STRSC-16027, Added Violating_Hu_Type_Capacity___ and Hu_Type_Cap_Is_Consumed___.
--  180205  LEPESE  STRSC-16027, Added method Get_Hu_Capacit_Approvd_Bins___ and called it from Putaway_Handling_Unit.
--  171026  LEPESE  STRSC-13819, Removed parameter ignore_transport_task_id_ from Check_Storage_Requirements and following in call chain, use calling process instead. 
--  171026          In Forbidden_Rec_To_Occupied___ transformed calling_process_ = 'EXECUTING_TRANSPORT_TASK_LINE' into consider_inbound_parts = FALSE.
--  170919  Chfose  STRSC-8922, Modified Putaway___ & Putaway_Part___ to take transport_task_id_ as an 'IN OUT'-parameter to be able to 
--  170919          use the same transport task id for all parts within a handling unit.
--  170628  JeeJlk  Bug 136122, Modified Get_Bins_Not_In_Better_Zone___ to stop bin_not_in_better_zone_tab_ become sparse.
--  170512  LEPESE  STRSC-8437, Added parameter calling_process_ to method Putaway_Handling_Unit and subsequent implementation methods.
--  170328  Chfose  LIM-11173, Added source_ref-parameters to Putaway_Handling_Unit.
--  170308  UdGnlk  LIM-10870, Modified Valid_Transport_Task___() by adding parameter calling_process_ to condition it to get value to transport task reserved_by_source.
--  170308          Also when calling Transport_Task_API.New_Or_Add_To_Existing() and Transport_Task_Line_API.Check_Insert_().
--  170307  UdGnlk  LIM-10870, Modified Putaway___() by adding parameter reserved_by_source_db_ TRUE to method call Transport_Task_API.New_Or_Add_To_Existing().  
--  170119  LEPESE  LIM-8584, Added solution in Putaway_Handling_Unit to manage putaway of handling units in ARRIVAL and QA locations. 
--  170109  MaEelk  LIM-10121, Added pick_list_no_ and shipment_id_ to the method call Transport_Task_API.New_Or_Add_To_Existing and Transport_Task_Line_API.Check_Insert_
--  170105  LEPESE  LIM-10028, Added parameter ignore_this_handling_unit_id_ to methods Get_Free_Carrying_Capacity___, Get_Free_Bay_Carrying_Cap___,
--  170105          Get_Free_Bin_Carrying_Cap___, Get_Free_Row_Carrying_Cap___, Get_Free_Tier_Carrying_Cap___ and Get_Free_Volume_Capacity___.
--  170104  LEPESE  LIM-10028, Changes in Check_Storage_Requirements to consider dimensions, weight and volume of Handling Unit.
--  170102  LEPESE  LIM-10112, Performance improvement for evaluating the capability requirements for the complete handling unit content. 
--  161230  LEPESE  LIM-10112, Performance improvement for min and max temp, min and max humidity on a handling unit.
--  161229  LEPESE  LIM-10028, Added handling unit id into error messages in method Get_Cap_And_Cond_Appr_Bins___.
--  161229  LEPESE  LIM-9401, Added validations for width, height and depth of Handling Units. 
--  161209  LEPESE  LIM-9483, Added parameter handling_unit_volume_ to method Putaway___ and the call chain from Putaway_Handling_Unit into Putaway___.
--  161028  LEPESE  LIM-9401, Added methods Get_Distinct_Putaway_Bins___ and Get_Append_Putaway_Bin_Tab___.
--  161028          Added parameter handling_unit_gross_weight_ to method Putaway___ and the call chain from Putaway_Handling_Unit into Putaway___.
--  161027  LEPESE  LIM-9401, Added parameters handl_unit_parts_common_bins_ and transport_task_id_ to method Putaway___. Added method Get_Common_Putaway_Bin_Tab___
--  161027          and called it from Putaway___. Added methods Get_Location_Filtered_Bins___ and Putaway_Part_In_Handl_Unit___.
--  161026  LEPESE  LIM-9401, Added parameters handling_unit_putaway_success_ and putting_away_handling_unit_ to method Putaway___. Added method Putaway_Part___.
--  161026          Changed direction of parameter to_location_no_ in Putaway___ from IN to IN OUT. Assign OUT value when putting away handling unit content.
--  161026          Added method Putaway_Handl_Unit_Content___.
--  161024  LEPESE  LIM-9401, Added method Putaway_Handling_Unit.
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  151126  JeLise  LIM-4470, Removed parameter include_pallet_locations_ in call to Warehouse_Bay_Bin_API.Get_Putaway_Bins.
--  151106  UdGnlk  LIM-3671, Removed method calls from Inventory_Part_Loc_Pallet_API, since INVENTORY_PART_LOC_PALLET_TAB will be obsolete. 
--  151102  MaEelk  LIM-4367, Removed the parameter pallet_id_ from Transport_Task_API.New_Or_Add_To_Existing
--  150512  IsSalk  KES-443, Renamed order_no_, release_no_, sequence_no, line_item_no_ and order_type parameters in method calls to Inventory_Transaction_Hist_API
--  150414  LEPESE  LIM-996, added handling_unit_id_ throughout the file.
--  150220  LEPESE  PRSC-4564, passed putaway_event_id_ as new parameter in call to Transport_Task_API.New_Or_Add_To_Existing from Putaway___.
--  150205  LEPESE  PRSC-5443, modified the calculations of free_carrying_capacity_qty_ and free_volume_capacity_qty_ to set them to negative infinity
--  150205          when the part has an infinite carrying capacity requirement or volume capacity requirement.
--  141118  NiDalk   Bug 119736, Modified Putaway___ to pass TRUE as ignore_unit_type_ when calling Inventory_Part_API.Get_Calc_Rounded_Qty 
--  141118           to do the rounding for extra 2 places
--  141008  LEPESE  PRSC-3231, added parameter ignore_transport_task_id_ to methods Putaway___, Is_Available_Bin___ and Forbidden_Rec_To_Occupied___.
--  141008          Added parameters putaway_event_id_ and ignore_transport_task_id_ to method Check_Storage_Requirements.
--  141008          Passed the value for ignore_transport_task_id_ when calling Inventory_Part_In_Stock_API.Any_Parts_Exist from Forbidden_Rec_To_Occupied___.
--  140922  LEPESE  PRSC-2518, Added method Get_Next_Putaway_Event_Id. Passed performing_optimization_ into Forbidden_Rec_To_Occupied___
--  140922          to avoid having the optimization job moving all stock away from a location marked as Receipt to Occupied Blocked.
--  140919  LEPESE  PRSC-2518, Added method Forbidden_Rec_To_Occupied___ and called is from Is_Available_Bin___.
--  140519  LEPESE  PBSC-9285, Correction in Indicate_Bins_In_Use___ to use i instead of rows_ for putaway_bin_tab_.
--  140331  LEPESE  PBSC-8098, Added call to Transport_Task_API.Get_Qty_Inbound_For_Warehouse in method Get_Remote_Whse_Refill_Qty___. 
--  140321  LEPESE   PBSC-6065, added parameter putaway_event_id_ to methods Putaway___, Get_Qty_That_Must_Be_Moved___,
--  140321           Get_Remote_Whse_Refill_Qty___ and Putaway_Part. Added logic in Get_Remote_Whse_Refill_Qty___ based on
--  140321           putaway_event_id_ that secures that we continue to refill a remote warehouse part all the way up to the
--  140321           Refill Up To Qty even if the refill is done in several steps, meaning several calls to Putaway from 
--  140321           InventoryRefillManager. Earlier the problem was that the refill halted as soon as the first Putaway
--  140321           made the Plannable Qty go above the Refill Point Qty. 
--  130715  ErFelk   Bug 111147, Added ignore return annotation to method Valid_Transport_Task___().
--  121217  MAHPLK   Modified Putaway___ and Get_Sorted_Putaway_Bins___ to sort using route_order.
--  121119  MAHPLK   Added new implementation method Get_Bins_Not_In_Better_Zone___. Modified Lock_Zone_By_Keys_Wait___ and Putaway___. 
--  120706  Matkse   Modified Lock_Zone_By_Keys_Wait to work as a switch against Lock_By_Keys_Wait on Site_Putaway_Zone and Invent_Part_Putaway_Zone
--  120706           depending on were the zone is situated.
--  120706           Modified Putaway___ by replacing obsolete parameters in call to Get_Putaway_Bins with a single new parameter sql_where_expression
--  120504  LEPESE   Added method Add_No_Location_Found_Info___.
--  120424  LEPESE   Changes in Get_Free_Bay_Carrying_Cap___, Get_Free_Tier_Carrying_Cap___, Get_Free_Row_Carrying_Cap___,
--  120424           Get_Free_Bin_Carrying_Cap___ and Get_Free_Volume_Capacity___ to avoid locking records that have infinite capacity.
--  120402  JeeJlk   Modified Putaway___ not to give the error message LOTTRACKERR when receive case is not 'Receive in to Arrival, Perfom Putaway'.
--  120312  LEPESE   Removed methods Remove_Receipt_Blocked_Bins___, Remove_Occupied_Pallet_Bins___, Get_Height_Approved_Bins___,
--  120312           Get_Width_Approved_Bins___, Get_Depth_Approved_Bins___, Get_Min_Temp_Approved_Bins___, Get_Max_Temp_Approved_Bins___, 
--  120312           Get_Min_Humid_Approved_Bins___, Get_Max_Humid_Approved_Bins___, Remove_Kanban_Control_Bins___. Added methods
--  120312           Get_Cap_And_Cond_Appr_Bins___, Is_Occupied_Pallet_Bin___, Is_Kanban_Controlled_Bin___, Is_Receipt_Blocked_Bin___,
--  120312           Is_Available_Bin___, Get_Inherited_Bin_Value___, Get_Bin_Cap_And_Cond___.
--  120229  LEPESE   Added parameter qty_exceeding_weight_volume_ to method Putaway___. Renamed method Qty_Already_In_Good_Place___
--  120229           into Get_Qty_That_Must_Be_Moved___ and changed return type from BOOLEAN to NUMBER. 
--  120228  LEPESE   Changes in Putaway___ and Get_Free_Carrying_Capacity___ to make Qty_Already_In_Good_Place___ return FALSE
--  120228           if either carrying capacity limit or volume capacity limit is already exceeded for a specific location.
--  120222  LEPESE   Added parameter condition_code_ to methods Putaway___ and Qty_Already_In_Good_Place___.
--  120220  LEPESE   Added method Qty_Already_In_Good_Place___.
--  120209  LEPESE   Added method Remove_Kanban_Control_Bins___.
--  120111  LEPESE   Replaced calls to Transport_Task_Line_Nopall__API.Check_Insert_ and 
--  120111           Transport_Task_Line_Pallet_API.Check_Insert_ in method Valid_Transport_Task___ with one
--  120111           common call to Transport_Task_Line_API.Check_Insert_ for both transport task line types.
--  111221  JeLise   Removed call to Transport_Task_API.Check_Insert_ in Valid_Transport_Task___.
--  111216  JeLise   Added more prameters in call to Transport_Task_Line_Pallet_API.Check_Insert_ in Valid_Transport_Task___.
--  111124  LEPESE   Used Utility_SYS.String_To_Number for sorting in method Get_Sorted_Putaway_Bins___ to sort
--  111124           warehouse_id, bay_id, tier_id, row_id and bin_id as numerical values if these columns contains
--  111124           strings that can be converted into numbers. If not then they are sorted using string sorting.
--  111104  LEPESE   Added parameters to_warehouse_id_, to_bay_id_, to_row_id_, to_tier_id_ and to_bin_id_
--  111104           to method Putaway___. Added check for exclude_storage_req_val in Check_Storage_Requirements.
--  111102  LEPESE   Added specific error messages for each type of storage requirement in method Putaway___.
--  111102  LEPESE   Added parameter check_storage_requirements_ when calling Transport_Task_Line_Nopall_API.Check_Insert_
--  111102           and Transport_Task_Line_Pallet_API.Check_Insert_ from method Valid_Transport_Task___.
--  111028  LEPESE   Added method Check_Storage_Requirements. Added parameter to_location_no_ to method Putaway___.
--  111028           Added logic and error messages in method Putaway___ to make this method work as a validation method
--  111028           with which we can validate capacities, conditions and cabailities of a specific inventory location
--  111028           against the Storage Requirements entered on the Inventory Part.
--  110915  JeLise   Changed information message handling in Putaway___. No message is sent if transport task is created.
--  110510  LEPESE   Changed information message PUTAWAYALL by replacing the word "Full" with "All available".
--  110506  LEPESE   Added method Valid_Transport_Task___.
--  110408  DaZase   Added Forbidden_Mix_Of_Lot_Batch___.
--  101110  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

positive_infinity_ CONSTANT NUMBER := 999999999999;

-------------------- PRIVATE DECLARATIONS -----------------------------------

negative_infinity_     CONSTANT NUMBER      := -999999999999;
absolute_min_humidity_ CONSTANT NUMBER      := 0;
absolute_max_humidity_ CONSTANT NUMBER      := 100;
db_true_               CONSTANT VARCHAR2(5) := Fnd_Boolean_API.DB_TRUE;
last_character_        CONSTANT VARCHAR2(1) := Database_SYS.Get_Last_Character;
not_investigated_      CONSTANT VARCHAR2(5) := 'OPEN';

TYPE Stock_Record IS RECORD (
   contract                inventory_part_in_stock_tab.contract%TYPE,
   part_no                 inventory_part_in_stock_tab.part_no%TYPE,
   configuration_id        inventory_part_in_stock_tab.configuration_id%TYPE,
   location_no             inventory_part_in_stock_tab.location_no%TYPE,
   lot_batch_no            inventory_part_in_stock_tab.lot_batch_no%TYPE,
   serial_no               inventory_part_in_stock_tab.serial_no%TYPE,
   eng_chg_level           inventory_part_in_stock_tab.eng_chg_level%TYPE,
   waiv_dev_rej_no         inventory_part_in_stock_tab.waiv_dev_rej_no%TYPE,
   activity_seq            inventory_part_in_stock_tab.activity_seq%TYPE,
   handling_unit_id        inventory_part_in_stock_tab.handling_unit_id%TYPE,
   qty_onhand              inventory_part_in_stock_tab.qty_onhand%TYPE,
   qty_reserved            inventory_part_in_stock_tab.qty_reserved%TYPE,
   qty_in_transit          inventory_part_in_stock_tab.qty_in_transit%TYPE,
   location_type           inventory_part_in_stock_tab.location_type%TYPE,
   freeze_flag             inventory_part_in_stock_tab.freeze_flag%TYPE,
   availability_control_id inventory_part_in_stock_tab.availability_control_id%TYPE,
   rotable_part_pool_id    inventory_part_in_stock_tab.rotable_part_pool_id%TYPE,
   condition_code          part_serial_catalog_pub.condition_code%TYPE,
   source_ref1             transport_task_line_tab.order_ref1%TYPE,
   source_ref2             transport_task_line_tab.order_ref2%TYPE,
   source_ref3             transport_task_line_tab.order_ref3%TYPE,
   source_ref4             transport_task_line_tab.order_ref4%TYPE,
   source_ref_type_db      transport_task_line_tab.order_type%TYPE);

TYPE Stock_Record_Tab IS TABLE OF Stock_Record INDEX BY PLS_INTEGER;

TYPE Handl_Unit_Characteristics_Tab IS TABLE OF handl_unit_characteristics_tmp%ROWTYPE INDEX BY PLS_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Putaway___ (
   handling_unit_putaway_success_    OUT        BOOLEAN,
   qty_not_in_good_place_            OUT        NUMBER,
   transport_task_id_             IN OUT        NUMBER,
   selected_hu_location_no_       IN OUT        VARCHAR2,
   contract_                      IN            VARCHAR2,
   part_no_                       IN            VARCHAR2,
   configuration_id_              IN            VARCHAR2,
   from_location_no_              IN            VARCHAR2,
   lot_batch_no_                  IN            VARCHAR2,
   serial_no_tab_                 IN            Part_Serial_Catalog_API.Serial_No_Tab,
   eng_chg_level_                 IN            VARCHAR2,
   waiv_dev_rej_no_               IN            VARCHAR2,
   activity_seq_                  IN            NUMBER,
   handling_unit_id_              IN            NUMBER,
   quantity_                      IN            NUMBER,
   source_ref1_                   IN            VARCHAR2,
   source_ref2_                   IN            VARCHAR2,
   source_ref3_                   IN            VARCHAR2,
   source_ref4_                   IN            NUMBER,
   source_ref_type_db_            IN            VARCHAR2,
   condition_code_usage_db_       IN            VARCHAR2,
   to_location_no_                IN            VARCHAR2,
   to_warehouse_id_               IN            VARCHAR2,
   to_bay_id_                     IN            VARCHAR2,
   to_tier_id_                    IN            VARCHAR2,
   to_row_id_                     IN            VARCHAR2,
   to_bin_id_                     IN            VARCHAR2,
   condition_code_                IN            VARCHAR2,
   calling_process_               IN            VARCHAR2,
   putting_away_handling_unit_    IN            BOOLEAN,
   handling_unit_gross_weight_    IN            NUMBER,
   handling_unit_volume_          IN            NUMBER,
   handl_unit_height_requirement_ IN            NUMBER,
   handl_unit_width_requirement_  IN            NUMBER,
   handl_unit_depth_requirement_  IN            NUMBER,
   handling_unit_id_investigated_ IN            NUMBER,
   handling_unit_min_temperature_ IN            NUMBER,
   handling_unit_max_temperature_ IN            NUMBER,
   handling_unit_min_humidity_    IN            NUMBER,
   handling_unit_max_humidity_    IN            NUMBER,
   putaway_session_id_            IN            NUMBER,
   handl_unit_capability_req_tab_ IN            Storage_Capability_API.Capability_Tab )
IS
   remaining_qty_to_putaway_      NUMBER;
   source_ref_type_               VARCHAR2(20);
   partca_rec_                    Part_Catalog_API.Public_Rec;
   lot_tracking_handled_          VARCHAR2(20);
   serial_tracking_handled_       VARCHAR2(20);
   local_condition_code_          VARCHAR2(10);
   height_requirement_            NUMBER;
   width_requirement_             NUMBER;
   depth_requirement_             NUMBER;
   volume_capacity_requirement_   NUMBER;
   carrying_capacity_requirement_ NUMBER;
   min_temp_requirement_          NUMBER;
   max_temp_requirement_          NUMBER;
   min_humid_requirement_         NUMBER;
   max_humid_requirement_         NUMBER;
   capability_requirement_tab_    Storage_Capability_API.Capability_Tab;
   putaway_zone_tab_              Invent_Part_Putaway_Zone_API.Putaway_Zone_Tab;
   putaway_bin_tab_               Warehouse_Bay_Bin_API.Putaway_Bin_Tab;
   quantity_added_                NUMBER;
   no_of_bins_in_use_             NUMBER;
   free_carrying_capacity_        NUMBER;
   free_carrying_capacity_qty_    NUMBER;
   free_bin_volume_capacity_      NUMBER;
   free_volume_capacity_qty_      NUMBER;
   free_putaway_quantity_         NUMBER;
   standard_putaway_qty_          NUMBER;
   quantity_to_putaway_           NUMBER;
   transport_task_created_        BOOLEAN;
   remaining_serials_to_putaway_  Part_Serial_Catalog_API.Serial_No_Tab;
   serials_to_putaway_            Part_Serial_Catalog_API.Serial_No_Tab;
   serials_added_                 Part_Serial_Catalog_API.Serial_No_Tab;
   local_serial_no_               VARCHAR2(50);
   number_of_serials_to_putaway_  NUMBER;
   serial_track_error_            EXCEPTION;
   from_location_type_db_         VARCHAR2(20);
   order_receipt_serial_count_    NUMBER;
   sum_qty_received_              NUMBER;
   performing_putaway_            BOOLEAN := TRUE;
   from_location_zone_ranking_    NUMBER  := positive_infinity_;
   remote_warehouse_refill_qty_   NUMBER;
   performing_optimization_       BOOLEAN := FALSE;
   inventory_event_id_            NUMBER := Inventory_Event_Manager_API.Get_Session_Id;
   hu_type_id_investigated_       handling_unit_tab.handling_unit_type_id%TYPE;
   zone_bin_count_                NUMBER;
   capability_approved_bin_count_ NUMBER;
BEGIN

   IF (from_location_no_ IS NULL) THEN
      IF (to_location_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOLOCATONS: Design Error. Either from_location_no_ or to_location_no_ should have a value in method Putaway___. Contact System Support.');
      END IF;
      -- When to_location_no_ has a value and from_location_no_ has no value then it indicates that
      -- method Putaway___ is called from method Check_Storage_Requirements or Get_Qty_Not_In_Good_Place___. This means that we should not
      -- attempt to any actual putaway (creation of transport tasks) since we only want to run through
      -- the validations for the storage requirements to see if the quantity fits into the specified to_location_no_.
      IF (quantity_ = 0) THEN
         -- This indicates that Putaway___ is called from Get_Qty_Not_In_Good_Place___ in order to
         -- investigate if an already existing quantity violates the storage requirements.
         performing_optimization_ := TRUE;
      END IF;
      performing_putaway_          := FALSE;
      qty_not_in_good_place_       := 0;
   ELSE
      IF (to_location_no_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'TWOLOCATONS: Design Error. Both from_location_no_ and to_location_no_ should not have values in method Putaway___. Contact System Support.');
      END IF;
      from_location_zone_ranking_ :=Invent_Part_Putaway_Zone_API.Get_Best_Location_Ranking(contract_,
                                                                                           part_no_,
                                                                                           from_location_no_);
   END IF;

   number_of_serials_to_putaway_ := serial_no_tab_.COUNT;

   IF (number_of_serials_to_putaway_ = 0) THEN
      local_serial_no_ := '*';
   ELSE
      IF (quantity_ IS NOT NULL) THEN
         Error_SYS.Record_General('InventoryPutawayManager', 'SERIALQTY: Quantity should not be defined for serials.');
      END IF;
      remaining_serials_to_putaway_ := serial_no_tab_;
      local_serial_no_              := remaining_serials_to_putaway_ (1).serial_no; 
   END IF;

   remaining_qty_to_putaway_ := NVL(quantity_, number_of_serials_to_putaway_);  
   source_ref_type_          := Order_Type_API.Decode(source_ref_type_db_);

   IF ((performing_putaway_) AND (NOT putting_away_handling_unit_)) THEN
      -- When putting away a handling unit we should always consider the full quantity contained in the handling unit.
      standard_putaway_qty_ := Inventory_Part_API.Get_Standard_Putaway_Qty(contract_, part_no_);
   ELSE
      standard_putaway_qty_ := remaining_qty_to_putaway_;
   END IF;

   partca_rec_              := Part_Catalog_API.Get(part_no_);
   lot_tracking_handled_    := partca_rec_.lot_tracking_code;
   serial_tracking_handled_ := partca_rec_.serial_tracking_code;

   IF (lot_tracking_handled_ = Part_Lot_Tracking_API.DB_LOT_TRACKING AND lot_batch_no_ = '*' AND performing_putaway_) THEN
      Error_SYS.Record_General('InventoryPutawayManager', 'LOTTRACKERR: A lot batch no must be specified for part :P1 when performing putaway to a stock location.', part_no_);
   END IF;

   IF ((local_serial_no_ = '*') AND (performing_putaway_) AND
       (partca_rec_.receipt_issue_serial_track = Fnd_Boolean_API.db_true)) THEN

      from_location_type_db_ := Inventory_Location_API.Get_Location_Type_Db(contract_, from_location_no_);

      IF (Inventory_Location_API.Arrival_Or_Quality_Location(from_location_type_db_) = Fnd_Boolean_API.db_true) THEN

         IF (partca_rec_.serial_tracking_code = Part_Serial_Tracking_API.db_serial_tracking) THEN
            RAISE serial_track_error_;
         END IF;

         order_receipt_serial_count_ := Inventory_Transaction_Hist_API.Get_Order_Receipt_Serial_Count(source_ref1_,
                                                                                                      source_ref2_,
                                                                                                      source_ref3_,
                                                                                                      source_ref4_,
                                                                                                      source_ref_type_db_);

         sum_qty_received_ := Inventory_Transaction_Hist_API.Get_Sum_Qty_Received(source_ref1_        => source_ref1_,
                                                                                  source_ref2_        => source_ref2_,
                                                                                  source_ref3_        => source_ref3_,
                                                                                  source_ref4_        => source_ref4_,
                                                                                  source_ref_type_db_ => source_ref_type_db_,
                                                                                  contract_           => NULL,
                                                                                  part_no_            => NULL,
                                                                                  configuration_id_   => NULL,
                                                                                  lot_batch_no_       => NULL);
         IF (order_receipt_serial_count_ < sum_qty_received_) THEN
            RAISE serial_track_error_;
         END IF;
      END IF;
   END IF;
   
   IF (condition_code_usage_db_ = Condition_Code_Usage_API.DB_ALLOW_CONDITION_CODE) THEN
      local_condition_code_ := NVL(condition_code_, Condition_Code_Manager_API.Get_Condition_Code(part_no_, local_serial_no_, lot_batch_no_));
   END IF;

   height_requirement_    := NVL(handl_unit_height_requirement_, NVL(Inventory_Part_API.Get_Storage_Height_Requirement(contract_, part_no_), positive_infinity_    ));
   width_requirement_     := NVL(handl_unit_width_requirement_ , NVL(Inventory_Part_API.Get_Storage_Width_Requirement (contract_, part_no_), positive_infinity_    ));
   depth_requirement_     := NVL(handl_unit_depth_requirement_ , NVL(Inventory_Part_API.Get_Storage_Depth_Requirement (contract_, part_no_), positive_infinity_    ));
   min_temp_requirement_  := NVL(handling_unit_min_temperature_, NVL(Inventory_Part_API.Get_Min_Storage_Temperature   (contract_, part_no_), negative_infinity_    ));
   max_temp_requirement_  := NVL(handling_unit_max_temperature_, NVL(Inventory_Part_API.Get_Max_Storage_Temperature   (contract_, part_no_), positive_infinity_    ));
   min_humid_requirement_ := NVL(handling_unit_min_humidity_   , NVL(Inventory_Part_API.Get_Min_Storage_Humidity      (contract_, part_no_), absolute_min_humidity_));
   max_humid_requirement_ := NVL(handling_unit_max_humidity_   , NVL(Inventory_Part_API.Get_Max_Storage_Humidity      (contract_, part_no_), absolute_max_humidity_));

   IF (handl_unit_capability_req_tab_.COUNT = 0) THEN
      capability_requirement_tab_ := Inventory_Part_Capability_API.Get_Operative_Capabilities(contract_, part_no_);
   ELSE
      capability_requirement_tab_ := handl_unit_capability_req_tab_;
   END IF;

   IF (handling_unit_volume_ IS NULL) THEN
      volume_capacity_requirement_ := NVL(Inventory_Part_API.Get_Storage_Volume_Requirement   (contract_, part_no_), positive_infinity_);
   END IF;
   IF (handling_unit_gross_weight_ IS NULL) THEN
      carrying_capacity_requirement_ := NVL(Inventory_Part_API.Get_Storage_Weight_Requirement   (contract_, part_no_), positive_infinity_);
   END IF;

   IF (performing_putaway_) THEN
      putaway_zone_tab_ := Get_Putaway_Zones___(putaway_session_id_, contract_, part_no_);
   ELSE
      -- We have one single location which we want to validate. So we define a zone which is this single location without zone information.
      -- This is just for practical reasons since it allows us to run through the normal putaway logic below.
      putaway_zone_tab_(1).storage_zone_id   := Database_SYS.string_null_;
      putaway_zone_tab_(1).sequence_no       := NULL;
      putaway_zone_tab_(1).source_db         := NULL;
      putaway_zone_tab_(1).max_bins_per_part := NULL;
      putaway_zone_tab_(1).ranking           := 1;      
   END IF;

   IF (putaway_zone_tab_.COUNT = 0) THEN
      Error_SYS.Record_General(lu_name_, 'ZONENOTEXIST: Inventory Part :P1 on site :P2 does not have any operative Putaway Zones.', part_no_, contract_);
   END IF;

   IF (handling_unit_id_investigated_ IS NOT NULL) THEN
      hu_type_id_investigated_ := Handling_Unit_API.Get_Handling_Unit_Type_Id(handling_unit_id_investigated_);
   END IF;
   zone_bin_count_  := Mpccom_System_Parameter_API.Get_parameter_value1('CAPABLE_BINS_FOR_LARGE_ZONES');

   FOR i IN putaway_zone_tab_.FIRST..putaway_zone_tab_.LAST LOOP

      IF (putaway_zone_tab_(i).max_bins_per_part IS NOT NULL) THEN
         Lock_Zone_By_Keys_Wait___(contract_, part_no_, putaway_zone_tab_(i).sequence_no, putaway_zone_tab_(i).source_db, putaway_zone_tab_(i).storage_zone_id);
      END IF;

      IF (putaway_zone_tab_(i).ranking = from_location_zone_ranking_) THEN
         -- There is no valid location available in any zone with better ranking than the zone to which
         -- the from_location belongs. So we need to investigate whether the quantity on the from_location
         -- is violating any storage requirements or if it should be left as it is without being moved.
         remaining_qty_to_putaway_ := Get_Qty_That_Must_Be_Moved___(contract_                   => contract_,
                                                                    part_no_                    => part_no_,
                                                                    configuration_id_           => configuration_id_,
                                                                    location_no_                => from_location_no_,
                                                                    lot_batch_no_               => lot_batch_no_,
                                                                    eng_chg_level_              => eng_chg_level_,
                                                                    waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                    activity_seq_               => activity_seq_,
                                                                    handling_unit_id_           => handling_unit_id_,
                                                                    condition_code_usage_db_    => condition_code_usage_db_,
                                                                    condition_code_             => local_condition_code_,
                                                                    remaining_qty_to_putaway_   => remaining_qty_to_putaway_,
                                                                    standard_putaway_qty_       => standard_putaway_qty_,
                                                                    putting_away_handling_unit_ => putting_away_handling_unit_);
         IF (remaining_qty_to_putaway_ = 0) THEN
            -- The quantity is already in a good place since it is in the best zone possible and does not
            -- violate any storage requirements.
            EXIT;
         END IF;
      END IF;

      IF (performing_putaway_) THEN
         Load_Putaway_Bins_Into_Tmp___(putaway_session_id_, contract_, part_no_, putaway_zone_tab_(i).storage_zone_id, putaway_zone_tab_(i).source_db);
      ELSE
      -- We have one single location which we want to validate. So we put that single location into the putaway_zone_bin_tmp.
      -- This is just for practical reasons since it allows us to run through the normal putaway logic below.
         Load_Single_Bin_Into_Tmp___(putaway_session_id_,
                                     contract_,
                                     part_no_,
                                     putaway_zone_tab_(i).storage_zone_id,
                                     to_warehouse_id_,
                                     to_bay_id_,
                                     to_tier_id_,
                                     to_row_id_,
                                     to_bin_id_,
                                     to_location_no_);
      END IF;
      Mark_Part_Zone_Bins_In_Use___(putaway_session_id_, contract_, part_no_, putaway_zone_tab_(i).storage_zone_id);
      no_of_bins_in_use_ := Get_No_Of_Bins_In_Use___(putaway_session_id_, contract_, part_no_, putaway_zone_tab_(i).storage_zone_id);

      IF ((performing_putaway_) AND (to_warehouse_id_ IS NOT NULL OR to_bay_id_ IS NOT NULL)) THEN
         Reject_Bins_Not_In_Whse_Bay___(putaway_session_id_, contract_, part_no_, putaway_zone_tab_(i).storage_zone_id, to_warehouse_id_, to_bay_id_);
      END IF;

      IF (putaway_zone_tab_(i).max_bins_per_part IS NOT NULL) AND (no_of_bins_in_use_ >= putaway_zone_tab_(i).max_bins_per_part) THEN
         Reject_Bins_Not_In_Use___(putaway_session_id_, contract_, part_no_, putaway_zone_tab_(i).storage_zone_id);
      END IF;

      Mark_Capability_Appr_Bins___(putaway_session_id_,
                                   contract_,
                                   part_no_,
                                   putaway_zone_tab_(i).storage_zone_id,
                                   capability_requirement_tab_,
                                   zone_bin_count_,
                                   putting_away_handling_unit_);

      IF NOT (performing_putaway_) THEN
         capability_approved_bin_count_ := Get_Capab_Approvd_Bin_Count___(putaway_session_id_,
                                                                          contract_,
                                                                          part_no_,
                                                                          putaway_zone_tab_(i).storage_zone_id);
         IF (capability_approved_bin_count_ = 0) THEN
            Error_SYS.Record_General(lu_name_,'CAPABILITY: Location :P1 on site :P2 does not fulfill the Storage Capability Requirements for part :P3', to_location_no_, contract_, part_no_);
         END IF;
      END IF;

      Mark_Cap_And_Cond_Appr_Bins___(putaway_session_id_,
                                     putaway_zone_tab_(i).storage_zone_id,
                                     contract_,
                                     part_no_,
                                     to_location_no_,
                                     height_requirement_,
                                     width_requirement_,
                                     depth_requirement_,
                                     min_temp_requirement_,
                                     max_temp_requirement_,
                                     min_humid_requirement_,
                                     max_humid_requirement_,
                                     performing_putaway_,
                                     handling_unit_id_investigated_,
                                     putting_away_handling_unit_);
      -- Final sorting of approved bins
      putaway_bin_tab_ := Get_Sorted_Putaway_Bins___(putaway_session_id_, contract_, part_no_, putaway_zone_tab_(i).storage_zone_id, selected_hu_location_no_);

      IF (putaway_bin_tab_.COUNT > 0) THEN
         FOR j IN putaway_bin_tab_.FIRST..putaway_bin_tab_.LAST LOOP

            transport_task_created_ := FALSE;
            quantity_added_         := 0;
            serials_added_.DELETE;

            IF (putaway_zone_tab_(i).max_bins_per_part IS NULL) OR
               (no_of_bins_in_use_ < putaway_zone_tab_(i).max_bins_per_part) OR
               (putaway_bin_tab_(j).part_stored = 1) THEN

               IF (Is_Available_Bin___(contract_,
                                       putaway_bin_tab_(j).warehouse_id,
                                       putaway_bin_tab_(j).bay_id,
                                       putaway_bin_tab_(j).tier_id,
                                       putaway_bin_tab_(j).row_id,
                                       putaway_bin_tab_(j).bin_id,
                                       putaway_bin_tab_(j).location_no,
                                       part_no_,
                                       lot_batch_no_,
                                       local_condition_code_,
                                       performing_putaway_,
                                       remaining_qty_to_putaway_,
                                       calling_process_,
                                       inventory_event_id_,
                                       performing_optimization_,
                                       putting_away_handling_unit_,
                                       hu_type_id_investigated_,
                                       handling_unit_id_investigated_)) THEN

                  free_carrying_capacity_ := Get_Free_Carrying_Capacity___(putaway_session_id_,
                                                                           contract_,
                                                                           putaway_bin_tab_(j).warehouse_id,
                                                                           putaway_bin_tab_(j).bay_id,
                                                                           putaway_bin_tab_(j).tier_id,
                                                                           putaway_bin_tab_(j).row_id,
                                                                           putaway_bin_tab_(j).bin_id,
                                                                           handling_unit_id_investigated_);

                  IF (free_carrying_capacity_ = positive_infinity_) THEN
                     -- Then bin has an infinite carrying capacity. We can fit an infinite qty of any part into the Bin.
                     free_carrying_capacity_qty_ := positive_infinity_;
                  ELSIF ((carrying_capacity_requirement_ = positive_infinity_) AND (handling_unit_gross_weight_ IS NULL)) THEN
                     -- The bin has a finite capacity and the part has an infinite capacity requirement. No quantity of this part can fit
                     -- in the bin, and if its already there it has to be removed. We have no information about any handling unit gross weight.
                     free_carrying_capacity_qty_ := negative_infinity_;
                  ELSE
                     IF (handling_unit_gross_weight_ IS NULL) THEN
                        -- The bin has a finite free carrying capacity and the part has a finite carrying capacity requirement.
                        free_carrying_capacity_qty_ := Inventory_Part_API.Get_Calc_Rounded_Qty(contract_, 
                                                                                               part_no_,
                                                                                               (free_carrying_capacity_ / carrying_capacity_requirement_),
                                                                                               'REMOVE',
                                                                                               TRUE);
                     ELSE
                        IF (handling_unit_gross_weight_ > free_carrying_capacity_) THEN
                           free_carrying_capacity_qty_ := 0;
                        ELSE
                           free_carrying_capacity_qty_ := remaining_qty_to_putaway_;
                        END IF;
                     END IF;
                  END IF;

                  free_bin_volume_capacity_ := Get_Free_Volume_Capacity___(putaway_session_id_,
                                                                           contract_,
                                                                           putaway_bin_tab_(j).warehouse_id,
                                                                           putaway_bin_tab_(j).bay_id,
                                                                           putaway_bin_tab_(j).tier_id,
                                                                           putaway_bin_tab_(j).row_id,
                                                                           putaway_bin_tab_(j).bin_id,
                                                                           handling_unit_id_investigated_);

                  IF (free_bin_volume_capacity_ = positive_infinity_) THEN
                     -- Then bin has an infinite volume capacity. We can fit an infinite qty of any part into the Bin.
                     free_volume_capacity_qty_ := positive_infinity_;
                  ELSIF ((volume_capacity_requirement_ = positive_infinity_) AND (handling_unit_volume_ IS NULL)) THEN
                     -- The bin has a finite capacity and the part has an infinite capacity requirement. No quantity of this part can fit
                     -- in the bin, and if its already there it has to be removed. We have no information about any handling unit volume.
                     free_volume_capacity_qty_ := negative_infinity_;
                  ELSE
                     IF (handling_unit_volume_ IS NULL) THEN
                        -- The bin has a finite free volume capacity and the part has a finite volume capacity requirement.
                        free_volume_capacity_qty_ := Inventory_Part_API.Get_Calc_Rounded_Qty(contract_, 
                                                                                             part_no_, 
                                                                                             (free_bin_volume_capacity_ / volume_capacity_requirement_), 
                                                                                             'REMOVE',
                                                                                             TRUE);
                     ELSE
                        IF (handling_unit_volume_ > free_bin_volume_capacity_) THEN
                           free_volume_capacity_qty_ := 0;
                        ELSE
                           free_volume_capacity_qty_ := remaining_qty_to_putaway_;
                        END IF;
                     END IF;
                  END IF;

                  free_putaway_quantity_ := LEAST(free_carrying_capacity_qty_, free_volume_capacity_qty_);
                  
                  IF (Is_Remote_Warehouse___(contract_, putaway_bin_tab_(j).warehouse_id) AND NVL(calling_process_, Database_SYS.string_null_) != 'MOVE_ORDER_RESERVATION') THEN

                     remote_warehouse_refill_qty_ := Get_Remote_Whse_Refill_Qty___(contract_,
                                                                                   part_no_,
                                                                                   configuration_id_,
                                                                                   putaway_bin_tab_(j).warehouse_id,
                                                                                   performing_putaway_,
                                                                                   performing_optimization_,
                                                                                   inventory_event_id_);

                     free_putaway_quantity_ := LEAST(free_putaway_quantity_, remote_warehouse_refill_qty_);
                  END IF;

                  IF (standard_putaway_qty_ IS NULL) THEN
                     quantity_to_putaway_ := LEAST(free_putaway_quantity_, remaining_qty_to_putaway_);
                  ELSE
                     IF (remaining_qty_to_putaway_ <= GREATEST(free_putaway_quantity_, 0)) THEN
                        quantity_to_putaway_ := remaining_qty_to_putaway_;
                     ELSE
                        quantity_to_putaway_ := TRUNC(free_putaway_quantity_ / standard_putaway_qty_) * standard_putaway_qty_;
                     END IF; 
                  END IF;

                  IF ((quantity_to_putaway_ > 0) AND (performing_putaway_)) THEN
                     IF (number_of_serials_to_putaway_ > 0) THEN -- this is a collection with serials
                        serials_to_putaway_  := Get_Serials_To_Putaway___(remaining_serials_to_putaway_, quantity_to_putaway_);
                        quantity_to_putaway_ := NULL;
                     END IF;

                     IF (Valid_Transport_Task___(contract_,
                                                 from_location_no_,
                                                 putaway_bin_tab_(j).location_no,
                                                 part_no_,
                                                 configuration_id_,
                                                 lot_batch_no_,
                                                 serials_to_putaway_,
                                                 eng_chg_level_,
                                                 waiv_dev_rej_no_,
                                                 activity_seq_,
                                                 handling_unit_id_,
                                                 source_ref1_,
                                                 source_ref2_,
                                                 source_ref3_,
                                                 source_ref4_,
                                                 source_ref_type_db_,
                                                 quantity_to_putaway_,
                                                 calling_process_ )) THEN

                        -- Create transport task
                        Transport_Task_Manager_API.New_Or_Add_To_Existing(
                           transport_task_id_          => transport_task_id_,
                           quantity_added_             => quantity_added_,
                           serials_added_              => serials_added_,
                           part_no_                    => part_no_,
                           configuration_id_           => configuration_id_,
                           from_contract_              => contract_,
                           from_location_no_           => from_location_no_,
                           to_contract_                => contract_,
                           to_location_no_             => putaway_bin_tab_(j).location_no,
                           destination_                => Inventory_Part_Destination_API.Decode('N'),
                           order_type_                 => source_ref_type_,
                           order_ref1_                 => source_ref1_,
                           order_ref2_                 => source_ref2_,
                           order_ref3_                 => source_ref3_,
                           order_ref4_                 => source_ref4_,
                           pick_list_no_               => NULL,
                           shipment_id_                => NULL,   
                           lot_batch_no_               => lot_batch_no_,
                           serial_no_tab_              => serials_to_putaway_,
                           eng_chg_level_              => eng_chg_level_,
                           waiv_dev_rej_no_            => waiv_dev_rej_no_,
                           activity_seq_               => activity_seq_,
                           handling_unit_id_           => handling_unit_id_,
                           quantity_to_add_            => quantity_to_putaway_,
                           reserved_by_source_db_      => CASE calling_process_ WHEN 'MOVE_ORDER_RESERVATION' THEN Fnd_Boolean_API.DB_TRUE
                                                                                WHEN 'PUTAWAY'                THEN Fnd_Boolean_API.DB_FALSE
                                                                                ELSE Fnd_Boolean_API.DB_FALSE END );
                                                                                   
                        IF (transport_task_id_ IS NOT NULL) THEN
                           transport_task_created_ := TRUE;
                           IF (putting_away_handling_unit_) THEN
                              -- Need to pass this location out and back to the Putaway_Handling_Unit method so that it can be sent in again for the next
                              -- stock record within the handling unit structure which needs to be moved to the very same location. HU must not be splitted.
                              selected_hu_location_no_ := putaway_bin_tab_(j).location_no;
                           ELSE                              
                              -- Only retain the transport_task_id_ in a handling unit context (to avoid splitting
                              -- the handling unit on multiple transport tasks).
                              transport_task_id_ := NULL;
                           END IF;
                        END IF;
                        remaining_qty_to_putaway_     := remaining_qty_to_putaway_ - quantity_added_;
                        remaining_serials_to_putaway_ := Get_Remaining_Serials___(remaining_serials_to_putaway_, serials_added_);
                     END IF; -- valid transport task
                  END IF;

                  IF (transport_task_created_) THEN
                     IF (putaway_bin_tab_(j).part_stored = 0) THEN
                        no_of_bins_in_use_ := no_of_bins_in_use_ + 1;
                        -- Setting in_use to TRUE in the temporary table so that we have that info alrady when putting away the next identical Handling Unit
                        Mark_Part_Bin_In_Use___(putaway_session_id_,
                                                putting_away_handling_unit_,
                                                contract_,
                                                part_no_,
                                                putaway_bin_tab_(j).location_no);
                     END IF;

                     Reduce_Free_Carrying_Capaci___(putaway_session_id_,
                                                    putting_away_handling_unit_,
                                                    contract_,
                                                    putaway_bin_tab_(j).warehouse_id,
                                                    putaway_bin_tab_(j).bay_id,
                                                    putaway_bin_tab_(j).tier_id,
                                                    putaway_bin_tab_(j).row_id,
                                                    putaway_bin_tab_(j).bin_id,
                                                    NVL(handling_unit_gross_weight_, (quantity_added_ * carrying_capacity_requirement_)));
                     Reduce_Free_Volume_Capacity___(putaway_session_id_,
                                                    putting_away_handling_unit_,
                                                    contract_,
                                                    putaway_bin_tab_(j).warehouse_id,
                                                    putaway_bin_tab_(j).bay_id,
                                                    putaway_bin_tab_(j).tier_id,
                                                    putaway_bin_tab_(j).row_id,
                                                    putaway_bin_tab_(j).bin_id,
                                                    NVL(handling_unit_volume_, (quantity_added_ * volume_capacity_requirement_)));
                  END IF;
               END IF; -- is available bin
            END IF;  -- max number of bins
            EXIT WHEN putting_away_handling_unit_ AND transport_task_created_;
            EXIT WHEN remaining_qty_to_putaway_ = 0;

            IF NOT (transport_task_created_) THEN
               Mark_Rejected_Putaway_Bin___(putaway_session_id_, contract_, putaway_bin_tab_(j).location_no);
            END IF;
         END LOOP;  -- Putaway Bin loop
      END IF; -- locations in putaway_bin_tab_
      EXIT WHEN putting_away_handling_unit_ AND transport_task_created_;
      EXIT WHEN remaining_qty_to_putaway_ = 0;
   END LOOP; -- Putaway Zone loop

   IF (performing_putaway_) THEN
      IF (putting_away_handling_unit_) THEN
         IF (remaining_qty_to_putaway_ = 0) THEN
            handling_unit_putaway_success_ := TRUE;
         ELSE
            handling_unit_putaway_success_ := FALSE;
         END IF;
      ELSE
         IF (remaining_qty_to_putaway_ = NVL(quantity_, number_of_serials_to_putaway_)) THEN
            Add_No_Location_Found_Info___(handling_unit_id_             => handling_unit_id_,
                                          contract_                     => contract_,
                                          part_no_                      => part_no_,
                                          configuration_id_             => configuration_id_,
                                          from_location_no_             => from_location_no_,
                                          lot_batch_no_                 => lot_batch_no_,
                                          local_serial_no_              => local_serial_no_,
                                          eng_chg_level_                => eng_chg_level_,
                                          waiv_dev_rej_no_              => waiv_dev_rej_no_,
                                          activity_seq_                 => activity_seq_,
                                          remaining_qty_to_putaway_     => remaining_qty_to_putaway_,
                                          number_of_serials_to_putaway_ => number_of_serials_to_putaway_);
         ELSIF (remaining_qty_to_putaway_ != 0) THEN
            Client_SYS.Add_Info(lu_name_,'PUTAWAYPART: :P1 of :P2 for part :P3 were not added to transport task(s)', remaining_qty_to_putaway_, NVL(quantity_, number_of_serials_to_putaway_), part_no_);
         END IF;
      END IF;
   ELSE
      IF (free_putaway_quantity_ < remaining_qty_to_putaway_) THEN
         IF (remaining_qty_to_putaway_ = 0) THEN
            -- This indicates that Putaway___ is called from Get_Qty_Not_In_Good_Place___ in order to investigate if an already existing quantity 
            -- violates the storage requirements. Here we have discovered that with the existing qty we have already violated the volume and or weight capacity.
            -- Or we might have found that the Plannable Qty on a remote warehouse location exceeds the Refill To Qty defined on the Remote Warehouse Assortment 
            -- and at the same time this assortment is configured to have its Excess Inventory Removed by the Storage Optimization process.
            -- So instead of raising an error we want to return a number which tells us how much that needs to be moved away from this location to remove
            -- the violation of the capacity limits.
            qty_not_in_good_place_ := free_putaway_quantity_ * -1;                
         ELSE
            free_putaway_quantity_ := GREATEST(free_putaway_quantity_, 0);
            IF (free_carrying_capacity_qty_ < free_volume_capacity_qty_) THEN
               IF (carrying_capacity_requirement_ = positive_infinity_) THEN
                  free_putaway_quantity_ := 0;
               END IF;
               IF (handling_unit_id_investigated_ IS NULL) THEN
                  Error_SYS.Record_General('InventoryPutawayManager', 'CARRYCAPA: The remaining Free Carrying Capacity does not allow more than :P1 :P2 to be put into location :P3.', free_putaway_quantity_, Inventory_Part_API.Get_Unit_Meas(contract_, part_no_), to_location_no_);
               ELSE
                  Error_SYS.Record_General('InventoryPutawayManager', 'HUCARRYCAPA: The remaining Free Carrying Capacity does not allow handling unit :P1 to be put into location :P2.', handling_unit_id_investigated_, to_location_no_);
               END IF;
            ELSE
               IF (volume_capacity_requirement_ = positive_infinity_) THEN
                  free_putaway_quantity_ := 0;
               END IF;
               IF (handling_unit_id_investigated_ IS NULL) THEN
                  Error_SYS.Record_General('InventoryPutawayManager', 'VOLUMECAPA: The remaining Free Volume Capacity does not allow more than :P1 :P2 to be put into location :P3.', free_putaway_quantity_, Inventory_Part_API.Get_Unit_Meas(contract_, part_no_), to_location_no_);
               ELSE
                  Error_SYS.Record_General('InventoryPutawayManager', 'HUVOLUMECAPA: The remaining Free Volume Capacity does not allow handling unit :P1 to be put into location :P2.', handling_unit_id_investigated_, to_location_no_);
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN serial_track_error_ THEN
      Error_SYS.Record_General('InventoryPutawayManager', 'SERIALTRACKERR: You must define the serial numbers before performing putaway for part :P1 to a stock location.', part_no_);
END Putaway___;


FUNCTION Mixed_Condition_Codes___ (
   serials_no_tab_          IN Part_Serial_Catalog_API.Serial_No_Tab,
   part_no_                 IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   condition_code_usage_db_ IN VARCHAR2 ) RETURN BOOLEAN
IS 
   mixed_condition_codes_ BOOLEAN := FALSE;
   condition_code_        VARCHAR2(10);
   old_condition_code_    VARCHAR2(10);
BEGIN

   IF (condition_code_usage_db_ = Condition_Code_Usage_API.DB_ALLOW_CONDITION_CODE AND serials_no_tab_.COUNT > 0) THEN
      FOR i IN serials_no_tab_.FIRST..serials_no_tab_.LAST LOOP
         condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(part_no_, serials_no_tab_(i).serial_no, lot_batch_no_);
         IF (old_condition_code_ IS NOT NULL AND old_condition_code_ != condition_code_) THEN
            mixed_condition_codes_ := TRUE;
            EXIT;
         END IF;
         old_condition_code_ := condition_code_;
      END LOOP;
   END IF;

   RETURN mixed_condition_codes_;
END Mixed_Condition_Codes___;


PROCEDURE Lock_Zone_By_Keys_Wait___ (
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   sequence_no_     IN NUMBER,
   source_db_       IN VARCHAR2,
   storage_zone_id_ IN VARCHAR2 )
IS
BEGIN
   IF (source_db_ = Part_Putaway_Zone_Level_API.DB_INVENTORY_PART) THEN
      Invent_Part_Putaway_Zone_API.Lock_By_Keys_Wait(contract_, part_no_, sequence_no_);
   ELSIF (source_db_ IN (Part_Putaway_Zone_Level_API.DB_SITE, 
                         Part_Putaway_Zone_Level_API.DB_ASSET_CLASS_FREQUENCY_CLASS, 
                         Part_Putaway_Zone_Level_API.DB_COMM_GROUP_FREQUENCY_CLASS)) THEN
      Site_Putaway_Zone_API.Lock_By_Keys_Wait(contract_, sequence_no_);
   ELSIF (source_db_ = Part_Putaway_Zone_Level_API.DB_REMOTE_WAREHOUSE_ASSORTMENT) THEN
      -- storage_zone_id_ is actually warehouse_id when source is REMOTE_WAREHOUSE_ASSORTMENT
      Warehouse_API.Lock_By_Keys_Wait(contract_, storage_zone_id_);
   ELSE
      Error_Sys.Record_General(lu_name_, 'SOURCENOTSUPPORTED: Source :P1 is not supported in Lock_Zone_By_Keys_Wait___. Contact System Support.', Part_Putaway_Zone_Level_API.Decode(source_db_));
   END IF;
END Lock_Zone_By_Keys_Wait___;


PROCEDURE Mark_Part_Zone_Bins_In_Use___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   storage_zone_id_    IN VARCHAR2 )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   in_use_ VARCHAR2(5);

   CURSOR get_zone_bins IS
      SELECT location_no
        FROM putaway_zone_bin_tmp
       WHERE putaway_session_id = putaway_session_id_
         AND contract           = contract_
         AND part_no            = part_no_
         AND storage_zone_id    = storage_zone_id_
         AND in_use             = not_investigated_
      FOR UPDATE;
BEGIN
   FOR rec_ IN get_zone_bins LOOP
      in_use_ := Fnd_Boolean_API.DB_FALSE;
      IF (Inventory_Part_In_Stock_API.Quantity_Exist_At_Location(contract_, part_no_, rec_.location_no)) OR 
         (Transport_Task_API.Inbound_Task_Exist(part_no_, contract_, rec_.location_no)) THEN
         -- bin is already used or will be used soon
         in_use_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
      UPDATE putaway_zone_bin_tmp
         SET in_use = in_use_
         WHERE CURRENT OF get_zone_bins;
   END LOOP;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
END Mark_Part_Zone_Bins_In_Use___;


PROCEDURE Mark_Part_Bin_In_Use___ (
   putaway_session_id_         IN NUMBER,
   putting_away_handling_unit_ IN BOOLEAN,
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2 )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   IF (putting_away_handling_unit_) THEN
      UPDATE putaway_zone_bin_tmp
         SET in_preliminary_use = Fnd_Boolean_API.DB_TRUE
       WHERE putaway_session_id = putaway_session_id_
         AND contract           = contract_
         AND part_no            = part_no_
         AND location_no        = location_no_
         AND in_use             = Fnd_Boolean_API.DB_FALSE;
   ELSE
      UPDATE putaway_zone_bin_tmp
         SET in_use = Fnd_Boolean_API.DB_TRUE
       WHERE putaway_session_id = putaway_session_id_
         AND contract           = contract_
         AND part_no            = part_no_
         AND location_no        = location_no_
         AND in_use             = Fnd_Boolean_API.DB_FALSE;
   END IF;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
END Mark_Part_Bin_In_Use___;


PROCEDURE Revert_Part_Bin_Usage___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   location_no_        IN VARCHAR2 )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   UPDATE putaway_zone_bin_tmp
      SET in_preliminary_use = Fnd_Boolean_API.DB_FALSE
    WHERE putaway_session_id = putaway_session_id_
      AND contract           = contract_
      AND location_no        = location_no_
      AND in_preliminary_use = Fnd_Boolean_API.DB_TRUE;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
END Revert_Part_Bin_Usage___;


PROCEDURE Confirm_Part_Bin_Usage___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   location_no_        IN VARCHAR2 )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   UPDATE putaway_zone_bin_tmp
      SET in_use             = Fnd_Boolean_API.DB_TRUE,
          in_preliminary_use = Fnd_Boolean_API.DB_FALSE
    WHERE putaway_session_id = putaway_session_id_
      AND contract           = contract_
      AND location_no        = location_no_
      AND in_preliminary_use = Fnd_Boolean_API.DB_TRUE
      AND in_use             = Fnd_Boolean_API.DB_FALSE;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
END Confirm_Part_Bin_Usage___;


FUNCTION Get_No_Of_Bins_In_Use___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   storage_zone_id_    IN VARCHAR2 ) RETURN NUMBER
IS
   usage_counter_ NUMBER;

   CURSOR get_usage_counter IS
      SELECT COUNT(*)
        FROM putaway_zone_bin_tmp
       WHERE putaway_session_id = putaway_session_id_
         AND contract           = contract_
         AND part_no            = part_no_
         AND storage_zone_id    = storage_zone_id_
         AND in_use             = Fnd_Boolean_API.DB_TRUE;
BEGIN
   OPEN  get_usage_counter;
   FETCH get_usage_counter INTO usage_counter_;
   CLOSE get_usage_counter;

   RETURN (usage_counter_);
END Get_No_Of_Bins_In_Use___;


-- Get_Capability_Appr_Bins___()
--    This method switches between the two different implementation of the finding approved capability bins according to amount of the putaway bins.
--    These two methods are optimize for respectively Get_Capab_Appr_Few_Bins___() method for few putaway bins where validating for small amount
--       of the putaway bins and Get_Capab_Appr_Many_Bins___() method for large number of putway bins
--    This switching point can be configured in MpccomParameters and need to evaluate and finding sweet spot of switching is customer responsibility. 
PROCEDURE Mark_Capability_Appr_Bins___ (
   putaway_session_id_         IN NUMBER,
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   storage_zone_id_            IN VARCHAR2,
   capability_requirement_tab_ IN Storage_Capability_API.Capability_Tab,
   zone_bin_count_             IN NUMBER,
   putting_away_handling_unit_ IN BOOLEAN )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   putaway_bin_count_     NUMBER;
   local_putting_away_hu_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

   CURSOR get_putaway_bin_count IS
      SELECT count(*)
        FROM putaway_zone_bin_tmp
       WHERE putaway_session_id    = putaway_session_id_
         AND contract              = contract_
         AND ((part_no             = part_no_) OR (local_putting_away_hu_ = Fnd_Boolean_API.DB_TRUE))
         AND storage_zone_id       = storage_zone_id_
         AND rejected              = Fnd_Boolean_API.DB_FALSE
         AND capabilities_approved = Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF (putting_away_handling_unit_) THEN
      local_putting_away_hu_ := Fnd_Boolean_API.DB_TRUE;
   END IF;

   IF (capability_requirement_tab_.COUNT > 0) THEN
      OPEN  get_putaway_bin_count;
      FETCH get_putaway_bin_count INTO putaway_bin_count_;
      CLOSE get_putaway_bin_count;

      IF (putaway_bin_count_ > zone_bin_count_ ) THEN
         Mark_Capab_Appr_Many_Bins___(putaway_session_id_, contract_, part_no_, storage_zone_id_, capability_requirement_tab_, putting_away_handling_unit_);
      ELSIF (putaway_bin_count_ > 0) THEN
         Mark_Capab_Appr_Few_Bins___ (putaway_session_id_, contract_, part_no_, storage_zone_id_, capability_requirement_tab_, putting_away_handling_unit_);
      END IF;
   ELSE
      -- Since there were no capability requirements from the part or handling unit we can set all locations to capability approved.
      UPDATE putaway_zone_bin_tmp
         SET number_of_capabilities = 0,
             capabilities_approved  = Fnd_Boolean_API.DB_TRUE
       WHERE putaway_session_id_    = putaway_session_id_
         AND contract               = contract_
         AND storage_zone_id        = storage_zone_id_
         AND rejected               = Fnd_Boolean_API.DB_FALSE
         AND capabilities_approved  = Fnd_Boolean_API.DB_FALSE
         AND ((part_no              = part_no_) OR (local_putting_away_hu_ = Fnd_Boolean_API.DB_TRUE));
   END IF;

   @ApproveTransactionStatement(2021-12-21,LEPESE)
   COMMIT;
END Mark_Capability_Appr_Bins___;


PROCEDURE Mark_Capab_Appr_Few_Bins___(
   putaway_session_id_         IN NUMBER,
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   storage_zone_id_            IN VARCHAR2,
   capability_requirement_tab_ IN Storage_Capability_API.Capability_Tab,
   putting_away_handling_unit_ IN BOOLEAN  )
IS
   bin_capability_tab_    Storage_Capability_API.Capability_Tab;
   local_putting_away_hu_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   bin_capability_count_  NUMBER;

   CURSOR get_part_putaway_zone_bins IS
      SELECT location_no, warehouse_id, bay_id, tier_id, row_id, bin_id
        FROM putaway_zone_bin_tmp
       WHERE putaway_session_id    = putaway_session_id_
         AND contract              = contract_
         AND ((part_no             = part_no_) OR (local_putting_away_hu_ = Fnd_Boolean_API.DB_TRUE))
         AND storage_zone_id       = storage_zone_id_
         AND rejected              = Fnd_Boolean_API.DB_FALSE
         AND capabilities_approved = Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF (putting_away_handling_unit_) THEN
      local_putting_away_hu_ := Fnd_Boolean_API.DB_TRUE;
   END IF;

   FOR rec_ IN get_part_putaway_zone_bins LOOP
      bin_capability_tab_ := Warehouse_Bin_Capability_API.Get_Operative_Capabilities(contract_,
                                                                                     rec_.warehouse_id,
                                                                                     rec_.bay_id,
                                                                                     rec_.tier_id,
                                                                                     rec_.row_id,
                                                                                     rec_.bin_id);

      IF (Bin_Is_Capability_Approved___(bin_capability_tab_, capability_requirement_tab_)) THEN

         -- If we are in context of putting away a complete Handling Unit then we can approve the location for all parts since the
         -- capability requirements are compiled from all parts in the HU. This is compiled in Putaway_Handling_Unit___ and
         -- passed in as parameter handl_unit_capability_req_tab_ into Putaway___. 
         -- We can also approve or reject the location regardless of storage_zone since the capabilities for a location is the
         -- same regardless of storage zone.
         bin_capability_count_ := bin_capability_tab_.COUNT;

         UPDATE putaway_zone_bin_tmp
            SET number_of_capabilities = bin_capability_count_,
                capabilities_approved  = Fnd_Boolean_API.DB_TRUE
            WHERE putaway_session_id = putaway_session_id_
              AND contract           = contract_
              AND location_no        = rec_.location_no
              AND ((part_no          = part_no_) OR (local_putting_away_hu_ = Fnd_Boolean_API.DB_TRUE));
      ELSE
         UPDATE putaway_zone_bin_tmp
            SET rejected = Fnd_Boolean_API.DB_TRUE
            WHERE putaway_session_id = putaway_session_id_
              AND contract           = contract_
              AND location_no        = rec_.location_no
              AND ((part_no          = part_no_) OR (local_putting_away_hu_ = Fnd_Boolean_API.DB_TRUE));
      END IF;
   END LOOP;

END Mark_Capab_Appr_Few_Bins___;


FUNCTION Bin_Is_Capability_Approved___ (
   bin_capability_tab_         IN Storage_Capability_API.Capability_Tab,
   capability_requirement_tab_ IN Storage_Capability_API.Capability_Tab ) RETURN BOOLEAN
IS
   bin_is_capability_approved_ BOOLEAN := TRUE;
   capability_found_           BOOLEAN;
BEGIN
   IF (capability_requirement_tab_.COUNT > 0) THEN
      FOR i IN capability_requirement_tab_.FIRST..capability_requirement_tab_.LAST LOOP
         capability_found_ := FALSE;
         IF (bin_capability_tab_.COUNT > 0) THEN
            FOR j IN bin_capability_tab_.FIRST..bin_capability_tab_.LAST LOOP
               IF (bin_capability_tab_(j).storage_capability_id = capability_requirement_tab_(i).storage_capability_id) THEN
                  capability_found_ := TRUE;
                  EXIT;
               END IF;
            END LOOP;
         END IF;
         IF NOT (capability_found_) THEN
            bin_is_capability_approved_ := FALSE;
            EXIT;
         END IF;
      END LOOP;
   END IF;

   RETURN (bin_is_capability_approved_);
END Bin_Is_Capability_Approved___;


PROCEDURE Mark_Capab_Appr_Many_Bins___ (
   putaway_session_id_         IN NUMBER,
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   storage_zone_id_            IN VARCHAR2,
   capability_requirement_tab_ IN Storage_Capability_API.Capability_Tab,
   putting_away_handling_unit_ IN BOOLEAN  )
IS
   bin_capability_tab_       Warehouse_Bin_Capability_API.Bin_Capability_Tab;
   cap_req_counter_          NUMBER;
   local_putting_away_hu_    VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

   CURSOR get_bin_capabilities IS
      SELECT DISTINCT op.storage_capability_id, pb.location_no
        FROM wh_bin_operative_cap op,
             putaway_zone_bin_tmp pb
       WHERE pb.putaway_session_id    = putaway_session_id_
         AND pb.contract              = contract_
         AND ((part_no                = part_no_) OR (local_putting_away_hu_ = Fnd_Boolean_API.DB_TRUE))
         AND pb.storage_zone_id       = storage_zone_id_
         AND pb.rejected              = Fnd_Boolean_API.DB_FALSE
         AND pb.capabilities_approved = Fnd_Boolean_API.DB_FALSE
         AND op.contract              = pb.contract
         AND op.warehouse_id          = pb.warehouse_id
         AND op.bay_id                = pb.bay_id
         AND op.tier_id               = pb.tier_id
         AND op.row_id                = pb.row_id
         AND op.bin_id                = pb.bin_id;

   CURSOR get_bin_with_approvals IS
      SELECT DISTINCT location_no, (SELECT count(*)
                                     FROM inv_location_capability_tmp b, TABLE (capability_requirement_tab_) pcr
                                    WHERE a.location_no           = b.location_no
                                      AND b.storage_capability_id = pcr.storage_capability_id) bin_cap_counter
        FROM inv_location_capability_tmp a;

   TYPE Bin_With_Approvals_Tab IS TABLE OF get_bin_with_approvals%rowtype;
   bin_with_approvals_tab_ Bin_With_Approvals_Tab;
BEGIN
   -- Clear temporary table.
   DELETE FROM inv_location_capability_tmp;
   cap_req_counter_ := capability_requirement_tab_.COUNT;

   IF (putting_away_handling_unit_) THEN
      local_putting_away_hu_ := Fnd_Boolean_API.DB_TRUE;
   END IF;

   IF ( cap_req_counter_ > 0 ) THEN
      -- Fetch a list of capabilities for each location in the zone for the part.
      OPEN  get_bin_capabilities;
      FETCH get_bin_capabilities BULK COLLECT INTO bin_capability_tab_;
      CLOSE get_bin_capabilities;

      IF (bin_capability_tab_.COUNT > 0) THEN
      -- Write the list of capabilities for each location in the zone for the part into temporary table.
         FORALL i IN bin_capability_tab_.first..bin_capability_tab_.last
            INSERT INTO inv_location_capability_tmp (
               storage_capability_id,
               location_no )
            VALUES (
               bin_capability_tab_(i).storage_capability_id,
               bin_capability_tab_(i).location_no);

         OPEN  get_bin_with_approvals;
         FETCH get_bin_with_approvals BULK COLLECT INTO bin_with_approvals_tab_;
         CLOSE get_bin_with_approvals;

         FORALL i IN bin_with_approvals_tab_.FIRST..bin_with_approvals_tab_.LAST
            UPDATE putaway_zone_bin_tmp pzb
               SET capabilities_approved  = CASE bin_with_approvals_tab_(i).bin_cap_counter WHEN cap_req_counter_ THEN Fnd_Boolean_API.DB_TRUE  ELSE Fnd_Boolean_API.DB_FALSE END,
                   rejected               = CASE bin_with_approvals_tab_(i).bin_cap_counter when cap_req_counter_ THEN Fnd_Boolean_API.DB_FALSE ELSE Fnd_Boolean_API.DB_TRUE  END,
                   number_of_capabilities = (SELECT count(*) FROM inv_location_capability_tmp ilca WHERE ilca.location_no = pzb.location_no)        
             WHERE location_no            = bin_with_approvals_tab_(i).location_no
               AND putaway_session_id     = putaway_session_id_
               AND contract               = contract_
               AND ((part_no              = part_no_) OR (local_putting_away_hu_ = Fnd_Boolean_API.DB_TRUE))
               AND storage_zone_id        = storage_zone_id_
               AND rejected               = Fnd_Boolean_API.DB_FALSE
               AND capabilities_approved  = Fnd_Boolean_API.DB_FALSE;
      END IF;
      -- We need to reject all the locations that have not been capability approved since there were some capability requirements from the part or handling unit.
      UPDATE putaway_zone_bin_tmp
         SET number_of_capabilities = 0,
             rejected               = Fnd_Boolean_API.DB_TRUE
       WHERE putaway_session_id_    = putaway_session_id_
         AND contract               = contract_
         AND storage_zone_id        = storage_zone_id_
         AND rejected               = Fnd_Boolean_API.DB_FALSE
         AND capabilities_approved  = Fnd_Boolean_API.DB_FALSE
         AND ((part_no              = part_no_) OR (local_putting_away_hu_ = Fnd_Boolean_API.DB_TRUE));
   END IF;
END Mark_Capab_Appr_Many_Bins___;

FUNCTION Get_Sorted_Putaway_Bins___ (
   putaway_session_id_      IN NUMBER,
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   storage_zone_id_         IN VARCHAR2,
   selected_hu_location_no_ IN VARCHAR2 ) RETURN Warehouse_Bay_Bin_API.Putaway_Bin_Tab
IS
   sorted_putaway_bin_tab_ Warehouse_Bay_Bin_API.Putaway_Bin_Tab;

   CURSOR get_putaway_bins IS
      SELECT 
             warehouse_id,
             bay_id,
             tier_id,
             row_id,
             bin_id,
             location_no,
             location_group,
             DECODE(in_use, Fnd_Boolean_API.DB_TRUE, 1, 0) part_stored,
             height_capacity,
             width_capacity,
             dept_capacity,
             0,
             min_temperature,
             max_temperature,
             min_humidity,
             max_humidity,
             number_of_capabilities,
             warehouse_route_order,
             bay_route_order,
             row_route_order,
             tier_route_order,
             bin_route_order,
             handling_unit_type_capacity
        FROM putaway_zone_bin_tmp
       WHERE putaway_session_id = putaway_session_id_
         AND contract           = contract_
         AND part_no            = part_no_
         AND storage_zone_id    = storage_zone_id_
         AND rejected           = Fnd_Boolean_API.DB_FALSE
         AND ((location_no      = selected_hu_location_no_) OR (selected_hu_location_no_ IS NULL))
      ORDER BY number_of_capabilities ASC, 
               (max_temperature - min_temperature) DESC, 
               (max_humidity - min_humidity) DESC, 
               height_capacity ASC,
               width_capacity ASC,
               dept_capacity ASC,
               DECODE(in_use, Fnd_Boolean_API.DB_TRUE, 1, 0) DESC,
               Utility_SYS.String_To_Number(warehouse_route_order) ASC,
               UPPER(warehouse_route_order) ASC,
               Utility_SYS.String_To_Number(bay_route_order) ASC,
               UPPER(decode(bay_route_order,  Warehouse_Bay_API.default_bay_id_,       last_character_, bay_route_order))  ASC,
               Utility_SYS.String_To_Number(row_route_order) ASC,
               UPPER(decode(row_route_order,  Warehouse_Bay_Row_API.default_row_id_,   last_character_, row_route_order))  ASC,
               Utility_SYS.String_To_Number(tier_route_order) ASC,
               UPPER(decode(tier_route_order, Warehouse_Bay_Tier_API.default_tier_id_, last_character_, tier_route_order)) ASC,
               Utility_SYS.String_To_Number(bin_route_order) ASC,
               UPPER(decode(bin_route_order,  Warehouse_Bay_Bin_API.default_bin_id_,   last_character_, bin_route_order))  ASC;
BEGIN
   OPEN  get_putaway_bins;
   FETCH get_putaway_bins BULK COLLECT INTO sorted_putaway_bin_tab_;
   CLOSE get_putaway_bins;

   RETURN sorted_putaway_bin_tab_;
END Get_Sorted_Putaway_Bins___;


PROCEDURE Set_Bin_Hu_Type_Capacity____ (
   putaway_session_id_    IN NUMBER,
   contract_              IN VARCHAR2,
   handling_unit_type_id_ IN VARCHAR2 )
IS
   handling_unit_type_capacity_  NUMBER;
   -- We only need to bother to investigate those bins that are not already rejected.
   CURSOR get_putaway_bins IS
      SELECT DISTINCT contract, location_no, warehouse_id, bay_id, tier_id, row_id, bin_id
        FROM putaway_zone_bin_tmp
      WHERE putaway_session_id = putaway_session_id_
        AND rejected           = Fnd_Boolean_API.DB_FALSE;
BEGIN
   FOR rec_ IN get_putaway_bins LOOP
      handling_unit_type_capacity_ := Warehouse_Bay_Bin_API.Get_Hu_Type_Capacity(contract_              => contract_,
                                                                                 warehouse_id_          => rec_.warehouse_id,
                                                                                 bay_id_                => rec_.bay_id,
                                                                                 tier_id_               => rec_.tier_id,
                                                                                 row_id_                => rec_.row_id,
                                                                                 bin_id_                => rec_.bin_id,
                                                                                 handling_unit_type_id_ => handling_unit_type_id_);

      -- Reason for having the actual update of putaway_zone_bin_tmp in a separate procedure with AUTONOMOUS TRANSACTION is
      -- because Warehouse_Bay_Bin_API.Get_Hu_Type_Capacity applies a database lock on warehouse_bay_bin_tab and if we had the call
      -- to Get_Hu_Type_Capacity inside of the autonomous transaction the the lock would be released at COMMIT of the autonomous transaction.
      -- And we need to keep the database record locked until the whole Putaway process is finished and we have committed the transport task lines.
      Store_Bin_Hu_Type_Capacity____(putaway_session_id_, rec_.contract, rec_.location_no, handling_unit_type_capacity_);
   END LOOP;
END Set_Bin_Hu_Type_Capacity____;


PROCEDURE Store_Bin_Hu_Type_Capacity____ (
   putaway_session_id_          IN NUMBER,
   contract_                    IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   handling_unit_type_capacity_ IN NUMBER )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   IF (handling_unit_type_capacity_ > 0) THEN
      UPDATE putaway_zone_bin_tmp
         SET handling_unit_type_capacity = handling_unit_type_capacity_
       WHERE putaway_session_id = putaway_session_id_
         AND contract           = contract_
         AND location_no        = location_no_;
   ELSE
      UPDATE putaway_zone_bin_tmp
         SET handling_unit_type_capacity = 0,
             rejected                    = Fnd_Boolean_API.DB_TRUE
       WHERE putaway_session_id = putaway_session_id_
         AND contract           = contract_
         AND location_no        = location_no_;
   END IF;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
      
END Store_Bin_Hu_Type_Capacity____;


PROCEDURE Reduce_Bin_Hu_Type_Capacit____ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   location_no_        IN VARCHAR2 )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   -- Never go negative and never reduce if capacity is infinite. Set Rejected to TRUE when capacity reaches zero.
   UPDATE putaway_zone_bin_tmp
      SET handling_unit_type_capacity = GREATEST((handling_unit_type_capacity - 1), 0),
          rejected                    = CASE GREATEST((handling_unit_type_capacity - 1), 0) WHEN 0 THEN Fnd_Boolean_API.DB_TRUE ELSE rejected END
    WHERE putaway_session_id          = putaway_session_id_
      AND contract                    = contract_
      AND location_no                 = location_no_
      AND rejected                    = Fnd_Boolean_API.DB_FALSE
      AND handling_unit_type_capacity < positive_infinity_;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;      
END Reduce_Bin_Hu_Type_Capacit____;


FUNCTION Get_Free_Bin_Carrying_Cap___ (
   putaway_session_id_           IN VARCHAR2,
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   tier_id_                      IN VARCHAR2,
   row_id_                       IN VARCHAR2,
   bin_id_                       IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   free_bin_carrying_capacity_ NUMBER;

   CURSOR get_free_carrying_capacity IS
      SELECT free_carrying_capacity - preliminary_consumption
      FROM free_bin_carrying_capacity_tmp
      WHERE putaway_session_id = putaway_session_id_
      AND   contract           = contract_
      AND   warehouse_id       = warehouse_id_
      AND   bay_id             = bay_id_
      AND   tier_id            = tier_id_
      AND   row_id             = row_id_
      AND   bin_id             = bin_id_;
BEGIN
   OPEN get_free_carrying_capacity;
   FETCH get_free_carrying_capacity INTO free_bin_carrying_capacity_;
   CLOSE get_free_carrying_capacity;

   IF (free_bin_carrying_capacity_ IS NULL) THEN

      free_bin_carrying_capacity_ := Warehouse_Bay_Bin_API.Get_Free_Carrying_Capacity(contract_,
                                                                                      warehouse_id_,
                                                                                      bay_id_,
                                                                                      tier_id_,
                                                                                      row_id_,
                                                                                      bin_id_,
                                                                                      ignore_this_handling_unit_id_);
      IF (free_bin_carrying_capacity_ < positive_infinity_) THEN
         -- The bin has a finite carrying capacity that will be consumbed by each receipt.
         -- Lock the bin with WAIT option before calculating free capacity to prevent
         -- several simultaneous putaway processes from using the same free capacity.
         Warehouse_Bay_Bin_API.Lock_By_Keys_Wait(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

         free_bin_carrying_capacity_ := Warehouse_Bay_Bin_API.Get_Free_Carrying_Capacity(contract_,
                                                                                         warehouse_id_,
                                                                                         bay_id_,
                                                                                         tier_id_,
                                                                                         row_id_,
                                                                                         bin_id_,
                                                                                         ignore_this_handling_unit_id_);
      END IF;
      
      Insert_Free_Bin_Carry_Cap___(putaway_session_id_,
                                   contract_,
                                   warehouse_id_,
                                   bay_id_,
                                   tier_id_,
                                   row_id_,
                                   bin_id_,
                                   free_bin_carrying_capacity_);
   END IF;

   RETURN free_bin_carrying_capacity_;
END Get_Free_Bin_Carrying_Cap___;


PROCEDURE Insert_Free_Bin_Carry_Cap___ (
   putaway_session_id_         IN VARCHAR2,
   contract_                   IN VARCHAR2,
   warehouse_id_               IN VARCHAR2,
   bay_id_                     IN VARCHAR2,
   tier_id_                    IN VARCHAR2,
   row_id_                     IN VARCHAR2,
   bin_id_                     IN VARCHAR2,
   free_bin_carrying_capacity_ IN NUMBER )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   INSERT INTO free_bin_carrying_capacity_tmp
      (putaway_session_id,
       contract,
       warehouse_id,
       bay_id,
       tier_id,
       row_id,
       bin_id,
       free_carrying_capacity,
       preliminary_consumption,
       date_created)
   VALUES
      (putaway_session_id_,
       contract_,
       warehouse_id_,
       bay_id_,
       tier_id_,
       row_id_,
       bin_id_,
       free_bin_carrying_capacity_,
       0,
       SYSDATE);

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;

END Insert_Free_Bin_Carry_Cap___;


PROCEDURE Insert_Free_Tier_Carry_Cap___ (
   putaway_session_id_          IN VARCHAR2,
   contract_                    IN VARCHAR2,
   warehouse_id_                IN VARCHAR2,
   bay_id_                      IN VARCHAR2,
   tier_id_                     IN VARCHAR2,
   free_tier_carrying_capacity_ IN NUMBER )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   INSERT INTO free_tier_carrying_cap_tmp
      (putaway_session_id,
       contract,
       warehouse_id,
       bay_id,
       tier_id,
       free_carrying_capacity,
       preliminary_consumption,
       date_created)
   VALUES
      (putaway_session_id_,
       contract_,
       warehouse_id_,
       bay_id_,
       tier_id_,
       free_tier_carrying_capacity_,
       0,
       SYSDATE);

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;

END Insert_Free_Tier_Carry_Cap___;


PROCEDURE Insert_Free_Row_Carry_Cap___ (
   putaway_session_id_         IN VARCHAR2,
   contract_                   IN VARCHAR2,
   warehouse_id_               IN VARCHAR2,
   bay_id_                     IN VARCHAR2,
   row_id_                     IN VARCHAR2,
   free_row_carrying_capacity_ IN NUMBER )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   INSERT INTO free_row_carrying_cap_tmp
      (putaway_session_id,
       contract,
       warehouse_id,
       bay_id,
       row_id,
       free_carrying_capacity,
       preliminary_consumption,
       date_created)
   VALUES
      (putaway_session_id_,
       contract_,
       warehouse_id_,
       bay_id_,
       row_id_,
       free_row_carrying_capacity_,
       0,
       SYSDATE);

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;

END Insert_Free_Row_Carry_Cap___;


PROCEDURE Insert_Free_Bay_Carry_Cap___ (
   putaway_session_id_         IN VARCHAR2,
   contract_                   IN VARCHAR2,
   warehouse_id_               IN VARCHAR2,
   bay_id_                     IN VARCHAR2,
   free_bay_carrying_capacity_ IN NUMBER )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   INSERT INTO free_bay_carrying_cap_tmp
      (putaway_session_id,
       contract,
       warehouse_id,
       bay_id,
       free_carrying_capacity,
       preliminary_consumption,
       date_created)
   VALUES
      (putaway_session_id_,
       contract_,
       warehouse_id_,
       bay_id_,
       free_bay_carrying_capacity_,
       0,
       SYSDATE);

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;

END Insert_Free_Bay_Carry_Cap___;


FUNCTION Get_Free_Tier_Carrying_Cap___ (
   putaway_session_id_           IN VARCHAR2,
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   tier_id_                      IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   free_tier_carrying_capacity_ NUMBER;

   CURSOR get_free_carrying_capacity IS
      SELECT free_carrying_capacity - preliminary_consumption
      FROM free_tier_carrying_cap_tmp
      WHERE putaway_session_id = putaway_session_id_
      AND   contract           = contract_
      AND   warehouse_id       = warehouse_id_
      AND   bay_id             = bay_id_
      AND   tier_id            = tier_id_;
BEGIN
   OPEN get_free_carrying_capacity;
   FETCH get_free_carrying_capacity INTO free_tier_carrying_capacity_;
   CLOSE get_free_carrying_capacity;

   IF (free_tier_carrying_capacity_ IS NULL)  THEN

      free_tier_carrying_capacity_ := Warehouse_Bay_Tier_API.Get_Free_Carrying_Capacity(contract_,
                                                                                        warehouse_id_,
                                                                                        bay_id_,
                                                                                        tier_id_,
                                                                                        ignore_this_handling_unit_id_);
      IF (free_tier_carrying_capacity_ < positive_infinity_) THEN
         -- The tier has a finite carrying capacity which will be consumed by each receipt.
         -- Lock the tier with WAIT option before calculating free capacity to prevent
         -- several simultaneous putaway processes from using the same free capacity.
         Warehouse_Bay_Tier_API.Lock_By_Keys_Wait(contract_, warehouse_id_, bay_id_, tier_id_);

         free_tier_carrying_capacity_ := Warehouse_Bay_Tier_API.Get_Free_Carrying_Capacity(contract_,
                                                                                           warehouse_id_,
                                                                                           bay_id_,
                                                                                           tier_id_,
                                                                                           ignore_this_handling_unit_id_);
      END IF;
      
      Insert_Free_Tier_Carry_Cap___(putaway_session_id_,
                                    contract_,
                                    warehouse_id_,
                                    bay_id_,
                                    tier_id_,
                                    free_tier_carrying_capacity_);
   END IF;

   RETURN free_tier_carrying_capacity_;
END Get_Free_Tier_Carrying_Cap___;


FUNCTION Get_Free_Bay_Carrying_Cap___ (
   putaway_session_id_           IN VARCHAR2,
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   free_bay_carrying_capacity_ NUMBER;

   CURSOR get_free_carrying_capacity IS
      SELECT free_carrying_capacity - preliminary_consumption
      FROM free_bay_carrying_cap_tmp
      WHERE putaway_session_id = putaway_session_id_
      AND   contract           = contract_
      AND   warehouse_id       = warehouse_id_
      AND   bay_id             = bay_id_;
BEGIN
   OPEN get_free_carrying_capacity;
   FETCH get_free_carrying_capacity INTO free_bay_carrying_capacity_;
   CLOSE get_free_carrying_capacity;

   IF (free_bay_carrying_capacity_ IS NULL)  THEN

      free_bay_carrying_capacity_ := Warehouse_Bay_API.Get_Free_Carrying_Capacity(contract_,
                                                                                  warehouse_id_,
                                                                                  bay_id_,
                                                                                  ignore_this_handling_unit_id_);
      IF (free_bay_carrying_capacity_ < positive_infinity_) THEN
         -- The bay has a finite carrying capacity which will be consumed by each receipt.
         -- Lock the bay with WAIT option before calculating free capacity to prevent
         -- several simultaneous putaway processes from using the same free capacity.
         Warehouse_Bay_API.Lock_By_Keys_Wait(contract_, warehouse_id_, bay_id_);

         free_bay_carrying_capacity_ := Warehouse_Bay_API.Get_Free_Carrying_Capacity(contract_,
                                                                                     warehouse_id_,
                                                                                     bay_id_,
                                                                                     ignore_this_handling_unit_id_);
      END IF;
      
      Insert_Free_Bay_Carry_Cap___(putaway_session_id_,
                                   contract_,
                                   warehouse_id_,
                                   bay_id_,
                                   free_bay_carrying_capacity_);
   END IF;

   RETURN free_bay_carrying_capacity_;
END Get_Free_Bay_Carrying_Cap___;


FUNCTION Get_Free_Carrying_Capacity___ (
   putaway_session_id_           IN NUMBER, 
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   tier_id_                      IN VARCHAR2,
   row_id_                       IN VARCHAR2,
   bin_id_                       IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   free_bin_carrying_capacity_  NUMBER;
   free_tier_carrying_capacity_ NUMBER;
   free_row_carrying_capacity_  NUMBER;
   free_bay_carrying_capacity_  NUMBER;
   free_carrying_capacity_      NUMBER;
BEGIN

   free_bin_carrying_capacity_ := Get_Free_Bin_Carrying_Cap___(putaway_session_id_,
                                                               contract_,
                                                               warehouse_id_,
                                                               bay_id_,
                                                               tier_id_,
                                                               row_id_,
                                                               bin_id_,
                                                               ignore_this_handling_unit_id_);

   free_tier_carrying_capacity_ := Get_Free_Tier_Carrying_Cap___(putaway_session_id_,
                                                                 contract_,
                                                                 warehouse_id_,
                                                                 bay_id_,
                                                                 tier_id_,
                                                                 ignore_this_handling_unit_id_);

   free_row_carrying_capacity_ := Get_Free_Row_Carrying_Cap___(putaway_session_id_,
                                                               contract_,
                                                               warehouse_id_,
                                                               bay_id_,
                                                               row_id_,
                                                               ignore_this_handling_unit_id_); 

   free_bay_carrying_capacity_ := Get_Free_Bay_Carrying_Cap___(putaway_session_id_,
                                                               contract_,
                                                               warehouse_id_,
                                                               bay_id_,
                                                               ignore_this_handling_unit_id_);

   free_carrying_capacity_ := LEAST(free_bin_carrying_capacity_,
                                    free_tier_carrying_capacity_,
                                    free_row_carrying_capacity_,
                                    free_bay_carrying_capacity_);

   RETURN free_carrying_capacity_;
END Get_Free_Carrying_Capacity___;


FUNCTION Get_Free_Volume_Capacity___ (
   putaway_session_id_           IN NUMBER,
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   tier_id_                      IN VARCHAR2,
   row_id_                       IN VARCHAR2,
   bin_id_                       IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   free_bin_volume_capacity_ NUMBER;
   
   CURSOR get_free_volume_capacity IS
      SELECT free_volume_capacity - preliminary_consumption
      FROM free_bin_volume_capacity_tmp
      WHERE putaway_session_id = putaway_session_id_
      AND   contract           = contract_
      AND   warehouse_id       = warehouse_id_
      AND   bay_id             = bay_id_
      AND   tier_id            = tier_id_
      AND   row_id             = row_id_
      AND   bin_id             = bin_id_; 
BEGIN   
   OPEN get_free_volume_capacity;
   FETCH get_free_volume_capacity INTO free_bin_volume_capacity_;
   CLOSE get_free_volume_capacity;

   IF (free_bin_volume_capacity_ IS NULL)  THEN
      free_bin_volume_capacity_ := Warehouse_Bay_Bin_API.Get_Free_volume_Capacity(contract_,
                                                                                  warehouse_id_,
                                                                                  bay_id_,
                                                                                  tier_id_,
                                                                                  row_id_,
                                                                                  bin_id_,
                                                                                  ignore_this_handling_unit_id_);
      IF (free_bin_volume_capacity_ < positive_infinity_) THEN
         -- The bin has a finite volume capacity which will be consumed by each receipt.
         -- Lock the bin with WAIT option before calculating free capacity to prevent
         -- several simultaneous putaway processes from using the same free capacity.
         Warehouse_Bay_Bin_API.Lock_By_Keys_Wait(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

         free_bin_volume_capacity_ := Warehouse_Bay_Bin_API.Get_Free_volume_Capacity(contract_,
                                                                                     warehouse_id_,
                                                                                     bay_id_,
                                                                                     tier_id_,
                                                                                     row_id_,
                                                                                     bin_id_,
                                                                                     ignore_this_handling_unit_id_);
      END IF;
      
      Insert_Free_Volume_Capacity___(putaway_session_id_,
                                     contract_,
                                     warehouse_id_,
                                     bay_id_,
                                     tier_id_,
                                     row_id_,
                                     bin_id_,
                                     free_bin_volume_capacity_);
   END IF;
   
   RETURN free_bin_volume_capacity_;
END Get_Free_Volume_Capacity___;


FUNCTION Forbidden_Mixing_Of_Parts___ (
   contract_                 IN VARCHAR2,
   part_no_                  IN VARCHAR2,
   warehouse_id_             IN VARCHAR2,
   bay_id_                   IN VARCHAR2,
   tier_id_                  IN VARCHAR2,
   row_id_                   IN VARCHAR2,
   bin_id_                   IN VARCHAR2,
   performing_optimization_  IN BOOLEAN  ) RETURN BOOLEAN
IS
   mix_of_parts_blocked_db_   VARCHAR2(5);
   forbidden_mixing_of_parts_ BOOLEAN := FALSE;
   other_parts_exist_         BOOLEAN;
BEGIN

   mix_of_parts_blocked_db_ := Warehouse_Bay_Bin_API.Get_Mix_Of_Parts_Blocked_Db(contract_,
                                                                                 warehouse_id_,
                                                                                 bay_id_,
                                                                                 tier_id_,
                                                                                 row_id_,
                                                                                 bin_id_);

   IF (mix_of_parts_blocked_db_ = Fnd_Boolean_API.DB_TRUE) THEN
      -- Lock the bin with WAIT option before checking if other parts exist to prevent getting into a situation
      -- where another Putaway process is about to create putaway task while this check is performed.
      Warehouse_Bay_Bin_API.Lock_By_Keys_Wait(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

      other_parts_exist_ := Inventory_Part_In_Stock_API.Other_Parts_Exist(contract_,
                                                                          part_no_,
                                                                          warehouse_id_,
                                                                          bay_id_,
                                                                          tier_id_,
                                                                          row_id_,
                                                                          bin_id_,
                                                                          performing_optimization_);

      IF (other_parts_exist_) THEN
         forbidden_mixing_of_parts_ := TRUE;
      END IF;
   END IF;

   RETURN (forbidden_mixing_of_parts_);
END Forbidden_Mixing_Of_Parts___;


FUNCTION Forbidden_Rec_To_Occupied___ (
   contract_                 IN VARCHAR2,
   warehouse_id_             IN VARCHAR2,
   bay_id_                   IN VARCHAR2,
   tier_id_                  IN VARCHAR2,
   row_id_                   IN VARCHAR2,
   bin_id_                   IN VARCHAR2,
   inventory_event_id_       IN NUMBER,
   performing_optimization_  IN BOOLEAN,
   calling_process_          IN VARCHAR2 ) RETURN BOOLEAN
IS
   rec_to_occupied_blocked_db_    VARCHAR2(5);
   forbidden_receipt_to_occupied_ BOOLEAN := FALSE;
   any_parts_exist_               BOOLEAN;
   put_to_empty_is_in_progress_   BOOLEAN := FALSE;
BEGIN
   IF NOT (performing_optimization_) THEN
      -- We need to avoid this when executed in the context of Storage Optimization because we don't want
      -- the optimization job to move the stock away from this location because it brakes the Receipt To Occupied Blocked rule.
      rec_to_occupied_blocked_db_ := Warehouse_Bay_Bin_API.Get_Receipt_To_Occup_Blockd_Db(contract_,
                                                                                          warehouse_id_,
                                                                                          bay_id_,
                                                                                          tier_id_,
                                                                                          row_id_,
                                                                                          bin_id_);

      IF (rec_to_occupied_blocked_db_ = Fnd_Boolean_API.DB_TRUE) THEN
         IF (inventory_event_id_ IS NOT NULL) THEN
            put_to_empty_is_in_progress_ := Putaway_To_Empty_Event_API.EXISTS(contract_,
                                                                              warehouse_id_,
                                                                              bay_id_,
                                                                              tier_id_,
                                                                              row_id_,
                                                                              bin_id_,
                                                                              inventory_event_id_);
         END IF;

         IF NOT (put_to_empty_is_in_progress_) THEN
            -- Lock the bin with WAIT option before checking if other parts exist to prevent getting into a situation
            -- where another Putaway process is about to create putaway task while this check is performed.
            Warehouse_Bay_Bin_API.Lock_By_Keys_Wait(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

            any_parts_exist_ := Inventory_Part_In_Stock_API.Any_Parts_Exist(contract_,
                                                                              warehouse_id_,
                                                                              bay_id_,
                                                                              tier_id_,
                                                                              row_id_,
                                                                              bin_id_,
                                                                              consider_inbound_parts_ => (calling_process_ != 'EXECUTING_TRANSPORT_TASK_LINE'));

            IF (any_parts_exist_) THEN
               forbidden_receipt_to_occupied_ := TRUE;
            ELSE
               IF (inventory_event_id_ IS NOT NULL) THEN
                  Putaway_To_Empty_Event_API.NEW(contract_,
                                                 warehouse_id_,
                                                 bay_id_,
                                                 tier_id_,
                                                 row_id_,
                                                 bin_id_,
                                                 inventory_event_id_);
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;

   RETURN (forbidden_receipt_to_occupied_);
END Forbidden_Rec_To_Occupied___;


FUNCTION Forbidden_Mix_Of_Conditions___ (
   condition_code_           IN VARCHAR2,
   contract_                 IN VARCHAR2,
   warehouse_id_             IN VARCHAR2,
   bay_id_                   IN VARCHAR2,
   tier_id_                  IN VARCHAR2,
   row_id_                   IN VARCHAR2,
   bin_id_                   IN VARCHAR2,
   performing_optimization_  IN BOOLEAN  ) RETURN BOOLEAN
IS
   mix_of_conditions_blocked_db_ VARCHAR2(5);
   forbidden_mix_of_conditions_  BOOLEAN := FALSE;
   other_conditions_exist_       BOOLEAN;
BEGIN

   mix_of_conditions_blocked_db_ := Warehouse_Bay_Bin_API.Get_Mix_Of_Cond_Blocked_Db(contract_,
                                                                                     warehouse_id_,
                                                                                     bay_id_,
                                                                                     tier_id_,
                                                                                     row_id_,
                                                                                     bin_id_);

   IF (mix_of_conditions_blocked_db_ = Fnd_Boolean_API.DB_TRUE) THEN
      -- Lock the bin with WAIT option before checking if other conditions exist to prevent getting into a situation
      -- where another Putaway process is about to create putaway task while this check is performed.
      Warehouse_Bay_Bin_API.Lock_By_Keys_Wait(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

      other_conditions_exist_ := Inventory_Part_In_Stock_API.Other_Conditions_Exist(condition_code_,
                                                                                    contract_,
                                                                                    warehouse_id_,
                                                                                    bay_id_,
                                                                                    tier_id_,
                                                                                    row_id_,
                                                                                    bin_id_,
                                                                                    performing_optimization_);

      IF (other_conditions_exist_) THEN
         forbidden_mix_of_conditions_ := TRUE;
      END IF;
   END IF;

   RETURN (forbidden_mix_of_conditions_);
END Forbidden_Mix_Of_Conditions___;


FUNCTION Forbidden_Mix_Of_Lot_Batch___ (
   contract_                 IN VARCHAR2,
   part_no_                  IN VARCHAR2,
   lot_batch_no_             IN VARCHAR2,
   warehouse_id_             IN VARCHAR2,
   bay_id_                   IN VARCHAR2,
   tier_id_                  IN VARCHAR2,
   row_id_                   IN VARCHAR2,
   bin_id_                   IN VARCHAR2,
   performing_optimization_  IN BOOLEAN) RETURN BOOLEAN
IS
   mix_of_lot_batch_blocked_db_    VARCHAR2(5);
   forbidden_mix_of_lot_batch_no_  BOOLEAN := FALSE;
   other_lot_batch_no_exist_       BOOLEAN;
BEGIN

   mix_of_lot_batch_blocked_db_ := Warehouse_Bay_Bin_API.Get_Mix_Of_Lot_Blocked_Db(contract_,
                                                                                   warehouse_id_,
                                                                                   bay_id_,
                                                                                   tier_id_,
                                                                                   row_id_,
                                                                                   bin_id_);

   IF (mix_of_lot_batch_blocked_db_ = Fnd_Boolean_API.DB_TRUE) THEN
      -- Lock the bin with WAIT option before checking if other lot batch no exist to prevent getting into a situation
      -- where another Putaway process is about to create putaway task while this check is performed.
      Warehouse_Bay_Bin_API.Lock_By_Keys_Wait(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

      other_lot_batch_no_exist_ := Inventory_Part_In_Stock_API.Other_Lots_Exist(contract_,
                                                                                part_no_,
                                                                                lot_batch_no_,
                                                                                warehouse_id_,
                                                                                bay_id_,
                                                                                tier_id_,
                                                                                row_id_,
                                                                                bin_id_,
                                                                                performing_optimization_);

      IF (other_lot_batch_no_exist_) THEN
         forbidden_mix_of_lot_batch_no_ := TRUE;
      END IF;
   END IF;

   RETURN (forbidden_mix_of_lot_batch_no_);
END Forbidden_Mix_Of_Lot_Batch___;


FUNCTION Get_Serials_To_Putaway___ (
   remaining_serials_to_putaway_ IN Part_Serial_Catalog_API.Serial_No_Tab,
   quantity_to_putaway_          IN NUMBER ) RETURN Part_Serial_Catalog_API.Serial_No_Tab
IS
   serials_to_putaway_ Part_Serial_Catalog_API.Serial_No_Tab;
BEGIN

   FOR i IN 1..quantity_to_putaway_ LOOP
      serials_to_putaway_(i) := remaining_serials_to_putaway_(i);
   END LOOP;

   RETURN (serials_to_putaway_);
END Get_Serials_To_Putaway___;


FUNCTION Get_Remaining_Serials___ (
   remaining_serials_to_putaway_ IN Part_Serial_Catalog_API.Serial_No_Tab,
   serials_added_                IN Part_Serial_Catalog_API.Serial_No_Tab ) RETURN Part_Serial_Catalog_API.Serial_No_Tab
IS
   remaining_serials_ Part_Serial_Catalog_API.Serial_No_Tab;
   serial_added_      BOOLEAN;
   rows_              PLS_INTEGER := 1;
BEGIN

   IF (remaining_serials_to_putaway_.COUNT > 0) THEN
      IF (serials_added_.COUNT = 0) THEN
         remaining_serials_ := remaining_serials_to_putaway_;
      ELSE
         FOR i IN remaining_serials_to_putaway_.FIRST..remaining_serials_to_putaway_.LAST LOOP
            serial_added_ := FALSE;
            FOR j IN serials_added_.FIRST..serials_added_.LAST LOOP
               IF (remaining_serials_to_putaway_(i).serial_no = serials_added_(j).serial_no) THEN
                  serial_added_ := TRUE;
                  EXIT;
               END IF;
            END LOOP;
            IF NOT (serial_added_) THEN
               remaining_serials_(rows_) := remaining_serials_to_putaway_(i);
               rows_ := rows_ + 1;
            END IF;
         END LOOP;
      END IF;
   END IF;

   RETURN (remaining_serials_);
END Get_Remaining_Serials___;


PROCEDURE Reduce_Free_Bin_Carry_Cap___ (
   putaway_session_id_         IN NUMBER,
   putting_away_handling_unit_ IN BOOLEAN,
   contract_                   IN VARCHAR2,
   warehouse_id_               IN VARCHAR2,
   bay_id_                     IN VARCHAR2,
   tier_id_                    IN VARCHAR2,
   row_id_                     IN VARCHAR2,
   bin_id_                     IN VARCHAR2,
   consumed_carrying_capacity_ IN NUMBER )
IS
BEGIN
   IF (putting_away_handling_unit_) THEN
      UPDATE free_bin_carrying_capacity_tmp
         SET preliminary_consumption = preliminary_consumption + consumed_carrying_capacity_
       WHERE putaway_session_id      = putaway_session_id_ 
         AND contract                = contract_
         AND warehouse_id            = warehouse_id_
         AND bay_id                  = bay_id_
         AND tier_id                 = tier_id_
         AND row_id                  = row_id_
         AND bin_id                  = bin_id_
         AND free_carrying_capacity  < positive_infinity_;
   ELSE
      UPDATE free_bin_carrying_capacity_tmp
         SET free_carrying_capacity = free_carrying_capacity - consumed_carrying_capacity_
       WHERE putaway_session_id     = putaway_session_id_ 
         AND contract               = contract_
         AND warehouse_id           = warehouse_id_
         AND bay_id                 = bay_id_
         AND tier_id                = tier_id_
         AND row_id                 = row_id_
         AND bin_id                 = bin_id_
         AND free_carrying_capacity < positive_infinity_;
   END IF;
END Reduce_Free_Bin_Carry_Cap___;


PROCEDURE Reduce_Free_Tier_Carry_Cap___ (
   putaway_session_id_         IN NUMBER,
   putting_away_handling_unit_ IN BOOLEAN,
   contract_                   IN VARCHAR2,
   warehouse_id_               IN VARCHAR2,
   bay_id_                     IN VARCHAR2,
   tier_id_                    IN VARCHAR2,
   consumed_carrying_capacity_ IN NUMBER )
IS
BEGIN
   IF (putting_away_handling_unit_) THEN
      UPDATE free_tier_carrying_cap_tmp
         SET preliminary_consumption = preliminary_consumption + consumed_carrying_capacity_
       WHERE putaway_session_id      = putaway_session_id_ 
         AND contract                = contract_
         AND warehouse_id            = warehouse_id_
         AND bay_id                  = bay_id_
         AND tier_id                 = tier_id_
         AND free_carrying_capacity  < positive_infinity_;
   ELSE
      UPDATE free_tier_carrying_cap_tmp
         SET free_carrying_capacity = free_carrying_capacity - consumed_carrying_capacity_
       WHERE putaway_session_id     = putaway_session_id_ 
         AND contract               = contract_
         AND warehouse_id           = warehouse_id_
         AND bay_id                 = bay_id_
         AND tier_id                = tier_id_
         AND free_carrying_capacity < positive_infinity_;
   END IF;
END Reduce_Free_Tier_Carry_Cap___;


PROCEDURE Reduce_Free_Row_Carry_Cap___ (
   putaway_session_id_         IN NUMBER,
   putting_away_handling_unit_ IN BOOLEAN,
   contract_                   IN VARCHAR2,
   warehouse_id_               IN VARCHAR2,
   bay_id_                     IN VARCHAR2,
   row_id_                     IN VARCHAR2,
   consumed_carrying_capacity_ IN NUMBER )
IS
BEGIN
   IF (putting_away_handling_unit_) THEN
      UPDATE free_row_carrying_cap_tmp
         SET preliminary_consumption = preliminary_consumption + consumed_carrying_capacity_
       WHERE putaway_session_id      = putaway_session_id_ 
         AND contract                = contract_
         AND warehouse_id            = warehouse_id_
         AND bay_id                  = bay_id_
         AND row_id                  = row_id_
         AND free_carrying_capacity  < positive_infinity_;
   ELSE
      UPDATE free_row_carrying_cap_tmp
         SET free_carrying_capacity = free_carrying_capacity - consumed_carrying_capacity_
       WHERE putaway_session_id     = putaway_session_id_ 
         AND contract               = contract_
         AND warehouse_id           = warehouse_id_
         AND bay_id                 = bay_id_
         AND row_id                 = row_id_
         AND free_carrying_capacity < positive_infinity_;
   END IF;
END Reduce_Free_Row_Carry_Cap___;


PROCEDURE Reduce_Free_Bay_Carry_Cap___ (
   putaway_session_id_         IN NUMBER,
   putting_away_handling_unit_ IN BOOLEAN,
   contract_                   IN VARCHAR2,
   warehouse_id_               IN VARCHAR2,
   bay_id_                     IN VARCHAR2,
   consumed_carrying_capacity_ IN NUMBER )
IS
BEGIN
   IF (putting_away_handling_unit_) THEN
      UPDATE free_bay_carrying_cap_tmp
         SET preliminary_consumption = preliminary_consumption + consumed_carrying_capacity_
       WHERE putaway_session_id      = putaway_session_id_ 
         AND contract                = contract_
         AND warehouse_id            = warehouse_id_
         AND bay_id                  = bay_id_
         AND free_carrying_capacity  < positive_infinity_;
   ELSE
      UPDATE free_bay_carrying_cap_tmp
         SET free_carrying_capacity = free_carrying_capacity - consumed_carrying_capacity_
       WHERE putaway_session_id     = putaway_session_id_ 
         AND contract               = contract_
         AND warehouse_id           = warehouse_id_
         AND bay_id                 = bay_id_
         AND free_carrying_capacity < positive_infinity_;
   END IF;
END Reduce_Free_Bay_Carry_Cap___;


PROCEDURE Reduce_Free_Carrying_Capaci___ (
   putaway_session_id_         IN NUMBER,
   putting_away_handling_unit_ IN BOOLEAN,
   contract_                   IN VARCHAR2,
   warehouse_id_               IN VARCHAR2,
   bay_id_                     IN VARCHAR2,
   tier_id_                    IN VARCHAR2,
   row_id_                     IN VARCHAR2,
   bin_id_                     IN VARCHAR2,
   consumed_carrying_capacity_ IN NUMBER )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   Reduce_Free_Bin_Carry_Cap___(putaway_session_id_,
                                putting_away_handling_unit_,
                                contract_,
                                warehouse_id_,
                                bay_id_,
                                tier_id_,
                                row_id_,
                                bin_id_,
                                consumed_carrying_capacity_);
   
   Reduce_Free_Tier_Carry_Cap___(putaway_session_id_,
                                 putting_away_handling_unit_,
                                 contract_,
                                 warehouse_id_,
                                 bay_id_,
                                 tier_id_,
                                 consumed_carrying_capacity_);
   
   Reduce_Free_Row_Carry_Cap___(putaway_session_id_,
                                putting_away_handling_unit_,
                                contract_,
                                warehouse_id_,
                                bay_id_,
                                row_id_,
                                consumed_carrying_capacity_);
   
   Reduce_Free_Bay_Carry_Cap___(putaway_session_id_,
                                putting_away_handling_unit_,
                                contract_,
                                warehouse_id_,
                                bay_id_,
                                consumed_carrying_capacity_); 

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;

END Reduce_Free_Carrying_Capaci___;


PROCEDURE Reduce_Free_Volume_Capacity___ (
   putaway_session_id_         IN NUMBER,
   putting_away_handling_unit_ IN BOOLEAN,
   contract_                   IN VARCHAR2,
   warehouse_id_               IN VARCHAR2,
   bay_id_                     IN VARCHAR2,
   tier_id_                    IN VARCHAR2,
   row_id_                     IN VARCHAR2,
   bin_id_                     IN VARCHAR2,
   consumed_volume_capacity_   IN NUMBER )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   IF (putting_away_handling_unit_) THEN
      UPDATE free_bin_volume_capacity_tmp
         SET preliminary_consumption = preliminary_consumption + consumed_volume_capacity_
       WHERE putaway_session_id   = putaway_session_id_ 
         AND contract             = contract_
         AND warehouse_id         = warehouse_id_
         AND bay_id               = bay_id_
         AND tier_id              = tier_id_
         AND row_id               = row_id_
         AND bin_id               = bin_id_
         AND free_volume_capacity < positive_infinity_;
   ELSE
      UPDATE free_bin_volume_capacity_tmp
         SET free_volume_capacity = free_volume_capacity - consumed_volume_capacity_
       WHERE putaway_session_id   = putaway_session_id_ 
         AND contract             = contract_
         AND warehouse_id         = warehouse_id_
         AND bay_id               = bay_id_
         AND tier_id              = tier_id_
         AND row_id               = row_id_
         AND bin_id               = bin_id_
         AND free_volume_capacity < positive_infinity_;
   END IF;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;

END Reduce_Free_Volume_Capacity___;


FUNCTION Valid_Transport_Task___ (
   contract_           IN VARCHAR2,
   from_location_no_   IN VARCHAR2,
   to_location_no_     IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_tab_      IN Part_Serial_Catalog_API.Serial_No_Tab,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN NUMBER,
   handling_unit_id_   IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN NUMBER,
   source_ref_type_db_ IN VARCHAR2,
   quantity_           IN NUMBER,
   calling_process_    IN VARCHAR2 ) RETURN BOOLEAN
IS
   valid_transport_task_ BOOLEAN := TRUE;
   local_serial_no_tab_  Part_Serial_Catalog_API.Serial_No_Tab;
BEGIN

   BEGIN
      local_serial_no_tab_ := serial_no_tab_;

      IF (local_serial_no_tab_.COUNT = 0) THEN
         local_serial_no_tab_(1).serial_no := '*';
      END IF;

      FOR i IN local_serial_no_tab_.FIRST..local_serial_no_tab_.LAST  LOOP

         Transport_Task_Line_API.Check_Insert_(from_contract_              => contract_,
                                               from_location_no_           => from_location_no_,
                                               part_no_                    => part_no_,
                                               configuration_id_           => configuration_id_,
                                               to_contract_                => contract_,
                                               to_location_no_             => to_location_no_,
                                               destination_                => 'N',
                                               order_type_                 => source_ref_type_db_,
                                               order_ref1_                 => source_ref1_,
                                               order_ref2_                 => source_ref2_,
                                               order_ref3_                 => source_ref3_,
                                               order_ref4_                 => source_ref4_,
                                               pick_list_no_               => NULL,
                                               shipment_id_                => NULL,
                                               lot_batch_no_               => lot_batch_no_,
                                               serial_no_                  => local_serial_no_tab_(i).serial_no,
                                               eng_chg_level_              => eng_chg_level_,
                                               waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                               quantity_                   => quantity_,
                                               activity_seq_               => activity_seq_,
                                               handling_unit_id_           => handling_unit_id_,
                                               allow_deviating_avail_ctrl_ => FALSE,
                                               check_storage_requirements_ => FALSE,
                                               reserved_by_source_db_      => CASE calling_process_ WHEN 'MOVE_ORDER_RESERVATION' THEN Fnd_Boolean_API.DB_TRUE                                                                                                    
                                                                                                    ELSE Fnd_Boolean_API.DB_FALSE END );
      END LOOP;

   EXCEPTION
      WHEN OTHERS THEN
         valid_transport_task_ := FALSE;
   END;

   RETURN(valid_transport_task_);
END Valid_Transport_Task___;


FUNCTION Get_Qty_That_Must_Be_Moved___ (
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   location_no_                IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   condition_code_usage_db_    IN VARCHAR2,
   condition_code_             IN VARCHAR2,
   remaining_qty_to_putaway_   IN NUMBER,
   standard_putaway_qty_       IN NUMBER,
   putting_away_handling_unit_ IN BOOLEAN ) RETURN NUMBER
IS
   qty_not_in_good_place_  NUMBER;
   qty_that_must_be_moved_ NUMBER;
   empty_serial_no_tab_    Part_Serial_Catalog_API.Serial_No_Tab;
   warehouse_id_           warehouse_bay_bin_tab.warehouse_id%TYPE;
   bay_id_                 warehouse_bay_bin_tab.bay_id%TYPE;
   row_id_                 warehouse_bay_bin_tab.row_id%TYPE;
   tier_id_                warehouse_bay_bin_tab.tier_id%TYPE;
   bin_id_                 warehouse_bay_bin_tab.bin_id%TYPE;
   dummy_boolean_          BOOLEAN;
   dummy_number_           NUMBER;
   putaway_session_id_     NUMBER;
   dummy_string_           VARCHAR2(50);
   empty_cap_req_tab_      Storage_Capability_API.Capability_Tab;
   root_handling_unit_id_  NUMBER;
BEGIN
   putaway_session_id_ := Get_Next_Putaway_Session_Id___;
   Warehouse_Bay_Bin_API.Get_Location_Strings(warehouse_id_,
                                              bay_id_,
                                              tier_id_,
                                              row_id_,
                                              bin_id_,
                                              contract_,
                                              location_no_);
   IF (handling_unit_id_ != 0) THEN
      root_handling_unit_id_ := Handling_Unit_API.Get_Root_Handling_Unit_Id(handling_unit_id_);
   END IF;
   BEGIN
      -- for violating Hu type capacity, when Hu capacity is not consumed at all.
      Putaway___(handling_unit_putaway_success_ => dummy_boolean_,
                 qty_not_in_good_place_         => qty_not_in_good_place_,
                 transport_task_id_             => dummy_number_,
                 selected_hu_location_no_       => dummy_string_,
                 contract_                      => contract_,
                 part_no_                       => part_no_,
                 configuration_id_              => configuration_id_,
                 from_location_no_              => NULL,
                 lot_batch_no_                  => lot_batch_no_,
                 serial_no_tab_                 => empty_serial_no_tab_,
                 eng_chg_level_                 => eng_chg_level_,
                 waiv_dev_rej_no_               => waiv_dev_rej_no_,
                 activity_seq_                  => activity_seq_,
                 handling_unit_id_              => handling_unit_id_,
                 quantity_                      => 0,
                 source_ref1_                   => NULL,
                 source_ref2_                   => NULL,
                 source_ref3_                   => NULL,
                 source_ref4_                   => NULL,
                 source_ref_type_db_            => NULL,
                 condition_code_usage_db_       => condition_code_usage_db_,
                 to_location_no_                => location_no_,
                 to_warehouse_id_               => warehouse_id_,
                 to_bay_id_                     => bay_id_,
                 to_tier_id_                    => tier_id_,
                 to_row_id_                     => row_id_,
                 to_bin_id_                     => bin_id_,
                 condition_code_                => condition_code_,
                 calling_process_               => NULL,
                 putting_away_handling_unit_    => FALSE,
                 handling_unit_gross_weight_    => NULL,
                 handling_unit_volume_          => NULL,
                 handl_unit_height_requirement_ => NULL,
                 handl_unit_width_requirement_  => NULL,
                 handl_unit_depth_requirement_  => NULL,
                 handling_unit_id_investigated_ => root_handling_unit_id_,
                 handling_unit_min_temperature_ => NULL, 
                 handling_unit_max_temperature_ => NULL, 
                 handling_unit_min_humidity_    => NULL,    
                 handling_unit_max_humidity_    => NULL,
                 putaway_session_id_            => putaway_session_id_,
                 handl_unit_capability_req_tab_ => empty_cap_req_tab_);
   EXCEPTION
      WHEN OTHERS THEN
         qty_not_in_good_place_ := remaining_qty_to_putaway_;
   END;

   IF (putting_away_handling_unit_) THEN
      IF (qty_not_in_good_place_ > 0) THEN
         -- When putting away a handling unit we must always move the full quantity
         qty_that_must_be_moved_ := remaining_qty_to_putaway_;
      END IF;
   ELSE
      -- It might be so that Putaway___ returns a value in qty_not_in_good_place_ which is greater
      -- than the current Qty On Hand on this particular stock record. This can be caused by other parts
      -- also stored on the same location. Still we cannot move more than the Qty of this particular record.
      qty_not_in_good_place_ := LEAST(qty_not_in_good_place_, remaining_qty_to_putaway_);

      IF (standard_putaway_qty_ IS NULL) THEN
         qty_that_must_be_moved_ := qty_not_in_good_place_;
      ELSE
      -- Remove as many standard putaway quantity multiples as you need to solve the capacity limit violation,
      -- but of course not more than is present at this stock record.
         qty_that_must_be_moved_ := TRUNC(qty_not_in_good_place_ / standard_putaway_qty_) * standard_putaway_qty_;

         IF (qty_that_must_be_moved_ < qty_not_in_good_place_) THEN
            -- the quantity not in a good place was not exactly a multiple of a standard putaway quantity.
            -- So we need to add one extra standard putaway quantity.
            qty_that_must_be_moved_ := qty_that_must_be_moved_ + standard_putaway_qty_;
         END IF;
         -- We cannot move more than what is available to move.
         qty_that_must_be_moved_ := LEAST(qty_that_must_be_moved_, remaining_qty_to_putaway_);
      END IF;
   END IF;

   Cleanup_Putaway_Session___(putaway_session_id_);

   RETURN (qty_that_must_be_moved_);
END Get_Qty_That_Must_Be_Moved___;


PROCEDURE Mark_Cap_And_Cond_Appr_Bins___ (
   putaway_session_id_            IN NUMBER,
   storage_zone_id_               IN VARCHAR2,
   contract_                      IN VARCHAR2,
   part_no_                       IN VARCHAR2,
   to_location_no_                IN VARCHAR2,
   height_requirement_            IN NUMBER,
   width_requirement_             IN NUMBER,
   depth_requirement_             IN NUMBER,
   min_temp_requirement_          IN NUMBER,
   max_temp_requirement_          IN NUMBER,
   min_humid_requirement_         IN NUMBER,
   max_humid_requirement_         IN NUMBER,
   performing_putaway_            IN BOOLEAN,
   handling_unit_id_investigated_ IN NUMBER,
   putting_away_handling_unit_    IN BOOLEAN )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   site_rec_              Site_Invent_Info_API.Public_Rec;
   warehouse_rec_         Warehouse_API.Public_Rec;
   bay_rec_               Warehouse_Bay_API.Public_Rec;
   tier_rec_              Warehouse_Bay_Tier_API.Public_Rec;
   row_rec_               Warehouse_Bay_Row_API.Public_Rec;
   bin_rec_               Warehouse_Bay_Bin_API.Public_Rec;
   bin_is_approved_       BOOLEAN;
   local_putting_away_hu_ VARCHAR2(5)  := Fnd_Boolean_API.DB_FALSE;
   previous_warehouse_id_ VARCHAR2(20) := Database_SYS.string_null_;
   previous_bay_id_       VARCHAR2(20) := Database_SYS.string_null_;
   previous_row_id_       VARCHAR2(20) := Database_SYS.string_null_;
   previous_tier_id_      VARCHAR2(20) := Database_SYS.string_null_;

   CURSOR get_part_zone_bins IS
      SELECT location_no, warehouse_id, bay_id, row_id, tier_id, bin_id
        FROM putaway_zone_bin_tmp
       WHERE putaway_session_id            = putaway_session_id_
         AND contract                      = contract_
         AND part_no                       = part_no_
         AND storage_zone_id               = storage_zone_id_
         AND rejected                      = Fnd_Boolean_API.DB_FALSE
         AND sizes_and_conditions_approved = Fnd_Boolean_API.DB_FALSE
      ORDER BY warehouse_id, bay_id, row_id, tier_id, bin_id;
BEGIN
   site_rec_ := Site_Invent_Info_API.Get(contract_);

   IF (putting_away_handling_unit_) THEN
      local_putting_away_hu_ := Fnd_Boolean_API.DB_TRUE;
   END IF;

   FOR rec_ IN get_part_zone_bins LOOP

         IF (rec_.warehouse_id != previous_warehouse_id_) THEN
            warehouse_rec_ := Warehouse_API.Get(contract_, rec_.warehouse_id);
         END IF;

         IF ((rec_.warehouse_id != previous_warehouse_id_) OR 
             (rec_.bay_id       != previous_bay_id_      )) THEN
            bay_rec_ := Warehouse_Bay_API.Get(contract_, rec_.warehouse_id, rec_.bay_id);
         END IF;

         IF ((rec_.warehouse_id != previous_warehouse_id_) OR 
             (rec_.bay_id       != previous_bay_id_      ) OR
             (rec_.tier_id      != previous_tier_id_     )) THEN
            tier_rec_ := Warehouse_Bay_Tier_API.Get(contract_, rec_.warehouse_id, rec_.bay_id, rec_.tier_id);
         END IF;

         IF ((rec_.warehouse_id != previous_warehouse_id_) OR 
             (rec_.bay_id       != previous_bay_id_      ) OR
             (rec_.row_id       != previous_row_id_      )) THEN
            row_rec_ := Warehouse_Bay_Row_API.Get(contract_, rec_.warehouse_id, rec_.bay_id, rec_.row_id);
         END IF;

         bin_rec_         := Warehouse_Bay_Bin_API.Get (contract_, rec_.warehouse_id, rec_.bay_id, rec_.tier_id, rec_.row_id, rec_.bin_id);
         bin_rec_         := Get_Bin_Cap_And_Cond___(site_rec_, warehouse_rec_, bay_rec_, tier_rec_, row_rec_, bin_rec_);
         bin_is_approved_ := TRUE;

         IF (bin_rec_.height_capacity < height_requirement_) THEN
            IF (performing_putaway_) THEN
               bin_is_approved_ := FALSE;
            ELSE
               IF (handling_unit_id_investigated_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_,'HEIGHT: Location :P1 on site :P2 does not fulfill the Bin Height Requirement for part :P3', to_location_no_, contract_, part_no_);
               ELSE
                  Error_SYS.Record_General(lu_name_,'HUHEIGHT: Location :P1 on site :P2 does not fulfill the Bin Height Requirement for handling unit :P3', to_location_no_, contract_, handling_unit_id_investigated_);
               END IF;
            END IF;
         END IF;

         IF (bin_rec_.width_capacity < width_requirement_) THEN
            IF (performing_putaway_) THEN
               bin_is_approved_ := FALSE;
            ELSE
               IF (handling_unit_id_investigated_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_,'WIDTH: Location :P1 on site :P2 does not fulfill the Bin Width Requirement for part :P3', to_location_no_, contract_, part_no_);
               ELSE
                  Error_SYS.Record_General(lu_name_,'HUWIDTH: Location :P1 on site :P2 does not fulfill the Bin Width Requirement for handling unit :P3', to_location_no_, contract_, handling_unit_id_investigated_);
               END IF;
            END IF;
         END IF;

         IF (bin_rec_.dept_capacity < depth_requirement_) THEN
            IF (performing_putaway_) THEN
               bin_is_approved_ := FALSE;
            ELSE
               IF (handling_unit_id_investigated_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_,'DEPTH: Location :P1 on site :P2 does not fulfill the Bin Depth Requirement for part :P3', to_location_no_, contract_, part_no_);
               ELSE
                  Error_SYS.Record_General(lu_name_,'HUDEPTH: Location :P1 on site :P2 does not fulfill the Bin Depth Requirement for handling unit :P3', to_location_no_, contract_, handling_unit_id_investigated_);
               END IF;
            END IF;
         END IF;

         IF (bin_rec_.min_temperature < min_temp_requirement_) THEN
            IF (performing_putaway_) THEN
               bin_is_approved_ := FALSE;
            ELSE
               IF (handling_unit_id_investigated_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_,'MINTEMP: Location :P1 on site :P2 does not fulfill the Minimum Temperature Requirement for part :P3', to_location_no_, contract_, part_no_);
               ELSE
                  Error_SYS.Record_General(lu_name_,'HUMINTEMP: Location :P1 on site :P2 does not fulfill the Minimum Temperature Requirement for handling unit :P3', to_location_no_, contract_, handling_unit_id_investigated_);
               END IF;
            END IF;
         END IF;

         IF (bin_rec_.max_temperature > max_temp_requirement_) THEN
            IF (performing_putaway_) THEN
               bin_is_approved_ := FALSE;
            ELSE
               IF (handling_unit_id_investigated_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_,'MAXTEMP: Location :P1 on site :P2 does not fulfill the Maximum Temperature Requirement for part :P3', to_location_no_, contract_, part_no_);
               ELSE
                  Error_SYS.Record_General(lu_name_,'HUMAXTEMP: Location :P1 on site :P2 does not fulfill the Maximum Temperature Requirement for handling unit :P3', to_location_no_, contract_, handling_unit_id_investigated_);
               END IF;
            END IF;
         END IF;

         IF (bin_rec_.min_humidity < min_humid_requirement_) THEN
            IF (performing_putaway_) THEN
               bin_is_approved_ := FALSE;
            ELSE
               IF (handling_unit_id_investigated_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_,'MINHUM: Location :P1 on site :P2 does not fulfill the Minimum Humidity Requirement for part :P3', to_location_no_, contract_, part_no_);
               ELSE
                  Error_SYS.Record_General(lu_name_,'HUMINHUM: Location :P1 on site :P2 does not fulfill the Minimum Humidity Requirement for handling unit :P3', to_location_no_, contract_, handling_unit_id_investigated_);
               END IF;
            END IF;
         END IF;

         IF (bin_rec_.max_humidity > max_humid_requirement_) THEN
            IF (performing_putaway_) THEN
               bin_is_approved_ := FALSE;
            ELSE
               IF (handling_unit_id_investigated_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_,'MAXHUM: Location :P1 on site :P2 does not fulfill the Maximum Humidity Requirement for part :P3', to_location_no_, contract_, part_no_);
               ELSE
                  Error_SYS.Record_General(lu_name_,'HUMAXHUM: Location :P1 on site :P2 does not fulfill the Maximum Humidity Requirement for handling unit :P3', to_location_no_, contract_, handling_unit_id_investigated_);
               END IF;
            END IF;
         END IF;

         -- If we are in context of putting away a complete Handling Unit then we can approve the location for all parts since the
         -- capacity and condition requirements are compiled from all parts in the HU. This is compiled in Putaway_Handling_Unit___ and
         -- passed in as parameters into Putaway___. 
         -- We can also approve or reject the location regardless of storage_zone since the capacities and conditions for a location is the
         -- same regardless of storage zone.

         IF (bin_is_approved_) THEN
            UPDATE putaway_zone_bin_tmp
               SET height_capacity = bin_rec_.height_capacity,
                   width_capacity  = bin_rec_.width_capacity,
                   dept_capacity   = bin_rec_.dept_capacity,
                   min_temperature = bin_rec_.min_temperature,
                   max_temperature = bin_rec_.max_temperature,
                   min_humidity    = bin_rec_.min_humidity,
                   max_humidity    = bin_rec_.max_humidity,
                   sizes_and_conditions_approved = Fnd_Boolean_API.DB_TRUE
               WHERE putaway_session_id = putaway_session_id_
                 AND contract           = contract_
                 AND location_no        = rec_.location_no
                 AND ((part_no          = part_no_) OR (local_putting_away_hu_ = Fnd_Boolean_API.DB_TRUE));
         ELSE
            UPDATE putaway_zone_bin_tmp
               SET rejected = Fnd_Boolean_API.DB_TRUE
               WHERE putaway_session_id = putaway_session_id_
                 AND contract           = contract_
                 AND location_no        = rec_.location_no
                 AND ((part_no          = part_no_) OR (local_putting_away_hu_ = Fnd_Boolean_API.DB_TRUE));
         END IF;

         previous_warehouse_id_ := rec_.warehouse_id;
         previous_bay_id_       := rec_.bay_id;
         previous_row_id_       := rec_.row_id;
         previous_tier_id_      := rec_.tier_id;
   END LOOP;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
END Mark_Cap_And_Cond_Appr_Bins___;


FUNCTION Is_Kanban_Controlled_Bin___ (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   location_no_        IN VARCHAR2,
   performing_putaway_ IN BOOLEAN ) RETURN BOOLEAN
IS
   is_kanban_controlled_bin_ BOOLEAN := FALSE;
BEGIN

   IF (performing_putaway_) THEN
      is_kanban_controlled_bin_ := Inventory_Refill_Manager_API.Is_Kanban_Controlled(contract_, part_no_, location_no_);
   END IF;

   RETURN (is_kanban_controlled_bin_);
END Is_Kanban_Controlled_Bin___;


FUNCTION Is_Receipt_Blocked_Bin___ (
   contract_                 IN VARCHAR2,
   warehouse_id_             IN VARCHAR2,
   bay_id_                   IN VARCHAR2,
   tier_id_                  IN VARCHAR2,
   row_id_                   IN VARCHAR2,
   bin_id_                   IN VARCHAR2,
   remaining_qty_to_putaway_ IN NUMBER ) RETURN BOOLEAN
IS
   is_receipt_blocked_bin_ BOOLEAN := FALSE;
BEGIN

   IF (remaining_qty_to_putaway_ > 0) THEN
      IF (Warehouse_Bay_Bin_API.Get_Receipts_Blocked_Db(contract_,
                                                        warehouse_id_,
                                                        bay_id_,
                                                        tier_id_,
                                                        row_id_,
                                                        bin_id_) = Fnd_Boolean_API.db_true) THEN
         is_receipt_blocked_bin_ := TRUE;
      END IF;
   END IF;

   RETURN (is_receipt_blocked_bin_);
END Is_Receipt_Blocked_Bin___;


FUNCTION Is_Available_Bin___ (
   contract_                      IN VARCHAR2,
   warehouse_id_                  IN VARCHAR2,
   bay_id_                        IN VARCHAR2,
   tier_id_                       IN VARCHAR2,
   row_id_                        IN VARCHAR2,
   bin_id_                        IN VARCHAR2,
   location_no_                   IN VARCHAR2,
   part_no_                       IN VARCHAR2,
   lot_batch_no_                  IN VARCHAR2,
   condition_code_                IN VARCHAR2,
   performing_putaway_            IN BOOLEAN,
   remaining_qty_to_putaway_      IN NUMBER,
   calling_process_               IN VARCHAR2,
   inventory_event_id_            IN NUMBER,
   performing_optimization_       IN BOOLEAN,
   putting_away_handling_unit_    IN BOOLEAN,
   hu_type_id_investigated_       IN VARCHAR2,
   handling_unit_id_investigated_ IN NUMBER ) RETURN BOOLEAN
IS
   is_available_bin_ BOOLEAN := FALSE;
BEGIN
   IF NOT (Is_Kanban_Controlled_Bin___(contract_,
                                       part_no_,
                                       location_no_,
                                       performing_putaway_)) THEN

      IF NOT (Is_Receipt_Blocked_Bin___(contract_,
                                        warehouse_id_,
                                        bay_id_,
                                        tier_id_,
                                        row_id_,
                                        bin_id_,
                                        remaining_qty_to_putaway_)) THEN

         IF NOT (Forbidden_Rec_To_Occupied___(contract_,
                                              warehouse_id_,
                                              bay_id_,
                                              tier_id_,
                                              row_id_,
                                              bin_id_,
                                              inventory_event_id_,
                                              performing_optimization_,
                                              calling_process_)) THEN

            IF NOT (Forbidden_Mixing_Of_Parts___(contract_,
                                                 part_no_,
                                                 warehouse_id_,
                                                 bay_id_,
                                                 tier_id_,
                                                 row_id_,
                                                 bin_id_,
                                                 performing_optimization_)) THEN

               IF NOT (Forbidden_Mix_Of_Conditions___(condition_code_,
                                                      contract_,
                                                      warehouse_id_,
                                                      bay_id_,
                                                      tier_id_,
                                                      row_id_,
                                                      bin_id_,
                                                      performing_optimization_)) THEN

                  IF NOT (Forbidden_Mix_Of_Lot_Batch___(contract_,
                                                        part_no_,
                                                        lot_batch_no_,
                                                        warehouse_id_,
                                                        bay_id_,
                                                        tier_id_,
                                                        row_id_,
                                                        bin_id_,
                                                        performing_optimization_)) THEN
                     IF NOT (Violating_Hu_Type_Capacity___(contract_,
                                                           warehouse_id_,
                                                           bay_id_,
                                                           tier_id_,
                                                           row_id_,
                                                           bin_id_,
                                                           location_no_,
                                                           performing_putaway_,
                                                           putting_away_handling_unit_,
                                                           hu_type_id_investigated_,
                                                           handling_unit_id_investigated_)) THEN
                        IF (Is_Process_Enabled_Whse___(contract_,
                                                       warehouse_id_,
                                                       performing_putaway_,
                                                       calling_process_)) THEN
                           is_available_bin_ := TRUE;
                        END IF;
                     END IF;
                  ELSE
                     IF NOT (performing_putaway_) THEN
                        Error_SYS.Record_General(lu_name_,'LOTMIX: Mix of Lot Batch Numbers is blocked for location :P1 on site :P2 ', location_no_, contract_);
                     END IF;
                  END IF; -- mix of lot batch numbers
               ELSE
                  IF NOT (performing_putaway_) THEN
                     Error_SYS.Record_General(lu_name_,'CONDMIX: Mix of Condition Codes is blocked for location :P1 on site :P2 ', location_no_, contract_);
                  END IF;
               END IF; -- mix of condition codes
            ELSE
               IF NOT (performing_putaway_) THEN
                  Error_SYS.Record_General(lu_name_,'PARTMIX: Mix of Part Numbers is blocked for location :P1 on site :P2 ', location_no_, contract_);
               END IF;
            END IF; -- mix of parts
         ELSE
            IF NOT (performing_putaway_) THEN
               Error_SYS.Record_General(lu_name_,'RECTOOCCUPIED: Receipt to Occupied is blocked for location :P1 on site :P2 ', location_no_, contract_);
            END IF;
         END IF; -- Receipt to Occupied
      ELSE
         IF NOT (performing_putaway_) THEN
            Error_SYS.Record_General(lu_name_, 'RECBLOCKED: Location :P1 on Site :P2 is blocked for receipts.', location_no_, contract_);
         END IF;
      END IF; -- receipt blocked bin
   END IF; -- is kanban controlled

   RETURN (is_available_bin_);
END Is_Available_Bin___;


PROCEDURE Add_No_Location_Found_Info___ (
   handling_unit_id_             IN NUMBER,
   contract_                     IN VARCHAR2 DEFAULT NULL,
   part_no_                      IN VARCHAR2 DEFAULT NULL,
   configuration_id_             IN VARCHAR2 DEFAULT NULL,
   from_location_no_             IN VARCHAR2 DEFAULT NULL,
   lot_batch_no_                 IN VARCHAR2 DEFAULT NULL,
   local_serial_no_              IN VARCHAR2 DEFAULT NULL,
   eng_chg_level_                IN VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_              IN VARCHAR2 DEFAULT NULL,
   activity_seq_                 IN NUMBER   DEFAULT NULL,
   remaining_qty_to_putaway_     IN NUMBER   DEFAULT NULL,
   number_of_serials_to_putaway_ IN NUMBER   DEFAULT NULL )
IS
   part_no_info_          VARCHAR2(100);
   location_no_info_      VARCHAR2(100);
   configuration_id_info_ VARCHAR2(100);
   lot_batch_no_info_     VARCHAR2(100);
   serial_no_info_        VARCHAR2(100);
   waiv_dev_rej_no_info_  VARCHAR2(100);
   eng_chg_level_info_    VARCHAR2(100);
   activity_seq_info_     VARCHAR2(100);
   handling_unit_id_info_ VARCHAR2(100);
   info_                  VARCHAR2(2000);
BEGIN

   serial_no_info_        := Language_SYS.Translate_Constant(lu_name_,'PUTAWAYNOT1: Serial ');
   part_no_info_          := Language_SYS.Translate_Constant(lu_name_,'PUTAWAYNOT2: of Part ');
   configuration_id_info_ := Language_SYS.Translate_Constant(lu_name_,'PUTAWAYNOT3: Configuration ');
   lot_batch_no_info_     := Language_SYS.Translate_Constant(lu_name_,'PUTAWAYNOT4: Lot ');
   activity_seq_info_     := Language_SYS.Translate_Constant(lu_name_,'PUTAWAYNOT5: Activity ');
   waiv_dev_rej_no_info_  := Language_SYS.Translate_Constant(lu_name_,'PUTAWAYNOT6: Waiver ');
   eng_chg_level_info_    := Language_SYS.Translate_Constant(lu_name_,'PUTAWAYNOT7: Revision ');
   location_no_info_      := Language_SYS.Translate_Constant(lu_name_,'PUTAWAYNOT8: currently stored at Location ');
   handling_unit_id_info_ := Language_SYS.Translate_Constant(lu_name_,'PUTAWAYNOT9: Handling Unit ');
   
   IF (number_of_serials_to_putaway_ IS NOT NULL) THEN
      -- This parameter is null when called from Putaway_Handling_Unit
      IF (number_of_serials_to_putaway_ = 1) THEN
         info_ := serial_no_info_||local_serial_no_;
      ELSE
         info_ := remaining_qty_to_putaway_||' '||Inventory_Part_API.Get_Unit_Meas(contract_, part_no_);
      END IF;
   END IF;
   
   IF (part_no_ IS NOT NULL) THEN
      -- This parameter is null when called from Putaway_Handling_Unit
      info_ := info_||' '||part_no_info_||part_no_;
   END IF;
   
   IF (NVL(number_of_serials_to_putaway_, 0) != 1) THEN
      -- Want to go into this section when called from Putaway_Handling_Unit to get the handling_unit_id_info_. 
      IF (configuration_id_ != '*') THEN
         info_ := info_||', '||configuration_id_info_||configuration_id_;
      END IF;
      IF (lot_batch_no_ != '*') THEN
         info_ := info_||', '||lot_batch_no_info_||lot_batch_no_;
      END IF;
      IF (activity_seq_ != 0) THEN
         info_ := info_||', '||activity_seq_info_||activity_seq_;
      END IF;
      IF (waiv_dev_rej_no_ != '*') THEN
         info_ := info_||', '||waiv_dev_rej_no_info_||waiv_dev_rej_no_;
      END IF;
      IF (eng_chg_level_ != '1') THEN
         info_ := info_||', '||eng_chg_level_info_||eng_chg_level_;
      END IF;      
      IF (handling_unit_id_ != 0) THEN
         IF (info_ IS NOT NULL) THEN
            -- comma is only needed if previous info was added. In case called from Putaway_Handling_Unit then handling_unit_info_ comes first.
            info_ := info_||', ';
         END IF;
         info_ := info_||handling_unit_id_info_||handling_unit_id_;
      END IF;      
   END IF;
   
   info_ := info_||' '||location_no_info_||from_location_no_;
   Client_SYS.Add_Info(lu_name_,'PUTAWAYNOT: No putaway location could be found for :P1', info_);
END Add_No_Location_Found_Info___;


FUNCTION Get_Inherited_Bin_Value___ (
   site_value_      IN NUMBER,
   warehouse_value_ IN NUMBER,
   bay_value_       IN NUMBER,
   tier_value_      IN NUMBER,
   row_value_       IN NUMBER,
   bin_value_       IN NUMBER,
   use_least_       IN BOOLEAN ) RETURN NUMBER
IS
   inherited_bin_value_ NUMBER;
BEGIN

   IF (bin_value_ IS NULL) THEN
      IF (row_value_ IS NULL) THEN
         IF (tier_value_ IS NULL) THEN
            IF (bay_value_ IS NULL) THEN
               IF (warehouse_value_ IS NULL) THEN
                  inherited_bin_value_ := site_value_;
               ELSE
                  inherited_bin_value_ := warehouse_value_;
               END IF;
            ELSE
               inherited_bin_value_ := bay_value_;
            END IF;
         ELSE
            inherited_bin_value_ := tier_value_;
         END IF;
      ELSE
         IF (tier_value_ IS NULL) THEN
            inherited_bin_value_ := row_value_;
         ELSE
            IF (use_least_) THEN
               inherited_bin_value_ := LEAST(row_value_, tier_value_);
            ELSE
               inherited_bin_value_ := GREATEST(row_value_, tier_value_);
            END IF;
         END IF;
      END IF;
   ELSE
      inherited_bin_value_ := bin_value_;
   END IF;

   RETURN (inherited_bin_value_);
END Get_Inherited_Bin_Value___;


FUNCTION Get_Bin_Cap_And_Cond___ (
   site_rec_      IN Site_Invent_Info_API.Public_Rec,
   warehouse_rec_ IN Warehouse_API.Public_Rec,
   bay_rec_       IN Warehouse_Bay_API.Public_Rec,
   tier_rec_      IN Warehouse_Bay_Tier_API.Public_Rec,
   row_rec_       IN Warehouse_Bay_Row_API.Public_Rec,
   bin_rec_       IN Warehouse_Bay_Bin_API.Public_Rec ) RETURN Warehouse_Bay_Bin_API.Public_Rec
IS
   inherited_bin_rec_ Warehouse_Bay_Bin_API.Public_Rec;
BEGIN

   inherited_bin_rec_ := bin_rec_;

   inherited_bin_rec_.height_capacity := NVL(Get_Inherited_Bin_Value___(site_rec_.bin_height_capacity,
                                                                        warehouse_rec_.bin_height_capacity,
                                                                        bay_rec_.bin_height_capacity,
                                                                        tier_rec_.bin_height_capacity,
                                                                        row_rec_.bin_height_capacity,
                                                                        bin_rec_.height_capacity,
                                                                        use_least_ => TRUE), positive_infinity_);

   inherited_bin_rec_.dept_capacity   := NVL(Get_Inherited_Bin_Value___(site_rec_.bin_dept_capacity,
                                                                        warehouse_rec_.bin_dept_capacity,
                                                                        bay_rec_.bin_dept_capacity,
                                                                        tier_rec_.bin_dept_capacity,
                                                                        row_rec_.bin_dept_capacity,
                                                                        bin_rec_.dept_capacity,
                                                                        use_least_ => TRUE), positive_infinity_);

   inherited_bin_rec_.width_capacity  := NVL(Get_Inherited_Bin_Value___(site_rec_.bin_width_capacity,
                                                                        warehouse_rec_.bin_width_capacity,
                                                                        bay_rec_.bin_width_capacity,
                                                                        tier_rec_.bin_width_capacity,
                                                                        row_rec_.bin_width_capacity,
                                                                        bin_rec_.width_capacity,
                                                                        use_least_ => TRUE), positive_infinity_);

   inherited_bin_rec_.min_temperature := NVL(Get_Inherited_Bin_Value___(site_rec_.bin_min_temperature,
                                                                        warehouse_rec_.bin_min_temperature,
                                                                        bay_rec_.bin_min_temperature,
                                                                        tier_rec_.bin_min_temperature,
                                                                        row_rec_.bin_min_temperature,
                                                                        bin_rec_.min_temperature,
                                                                        use_least_ => TRUE), negative_infinity_);

   inherited_bin_rec_.max_temperature := NVL(Get_Inherited_Bin_Value___(site_rec_.bin_max_temperature,
                                                                        warehouse_rec_.bin_max_temperature,
                                                                        bay_rec_.bin_max_temperature,
                                                                        tier_rec_.bin_max_temperature,
                                                                        row_rec_.bin_max_temperature,
                                                                        bin_rec_.max_temperature,
                                                                        use_least_ => FALSE), positive_infinity_);

   inherited_bin_rec_.min_humidity    := NVL(Get_Inherited_Bin_Value___(site_rec_.bin_min_humidity,
                                                                        warehouse_rec_.bin_min_humidity,
                                                                        bay_rec_.bin_min_humidity,
                                                                        tier_rec_.bin_min_humidity,
                                                                        row_rec_.bin_min_humidity,
                                                                        bin_rec_.min_humidity,
                                                                        use_least_ => TRUE), absolute_min_humidity_);

   inherited_bin_rec_.max_humidity    := NVL(Get_Inherited_Bin_Value___(site_rec_.bin_max_humidity,
                                                                        warehouse_rec_.bin_max_humidity,
                                                                        bay_rec_.bin_max_humidity,
                                                                        tier_rec_.bin_max_humidity,
                                                                        row_rec_.bin_max_humidity,
                                                                        bin_rec_.max_humidity,
                                                                        use_least_ => FALSE), absolute_max_humidity_);
RETURN (inherited_bin_rec_);
END Get_Bin_Cap_And_Cond___;


FUNCTION Get_Free_Row_Carrying_Cap___ (
   putaway_session_id_           IN NUMBER,
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   row_id_                       IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   free_row_carrying_capacity_ NUMBER;

   CURSOR get_free_carrying_capacity IS
      SELECT free_carrying_capacity - preliminary_consumption
      FROM free_row_carrying_cap_tmp
      WHERE putaway_session_id = putaway_session_id_
      AND   contract           = contract_
      AND   warehouse_id       = warehouse_id_
      AND   bay_id             = bay_id_
      AND   row_id             = row_id_;
BEGIN

   OPEN get_free_carrying_capacity;
   FETCH get_free_carrying_capacity INTO free_row_carrying_capacity_;
   CLOSE get_free_carrying_capacity;

   IF (free_row_carrying_capacity_ IS NULL) THEN

      free_row_carrying_capacity_ := Warehouse_Bay_Row_API.Get_Free_Carrying_Capacity(contract_,
                                                                                      warehouse_id_,
                                                                                      bay_id_,
                                                                                      row_id_,
                                                                                      ignore_this_handling_unit_id_);
      IF (free_row_carrying_capacity_ < positive_infinity_) THEN
         -- The row has a finite carrying capacity which will be consumed by each receipt.
         -- Lock the row with WAIT option before calculating free capacity to prevent
         -- several simultaneous putaway processes from using the same free capacity.
         Warehouse_Bay_Row_API.Lock_By_Keys_Wait(contract_, warehouse_id_, bay_id_, row_id_);

         free_row_carrying_capacity_ := Warehouse_Bay_Row_API.Get_Free_Carrying_Capacity(contract_,
                                                                                         warehouse_id_,
                                                                                         bay_id_,
                                                                                         row_id_,
                                                                                         ignore_this_handling_unit_id_);
      END IF;
      
      Insert_Free_Row_Carry_Cap___(putaway_session_id_,
                                   contract_,
                                   warehouse_id_,
                                   bay_id_,
                                   row_id_,
                                   free_row_carrying_capacity_);
   END IF;

   RETURN free_row_carrying_capacity_;
END Get_Free_Row_Carrying_Cap___;


FUNCTION Is_Remote_Warehouse___ (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   is_remote_warehouse_   BOOLEAN := FALSE;
BEGIN   
   IF (Warehouse_API.Get_Remote_Warehouse_Db(contract_, warehouse_id_) = Fnd_Boolean_API.DB_TRUE) THEN
      is_remote_warehouse_ := TRUE;
   END IF;
   RETURN (is_remote_warehouse_);
END Is_Remote_Warehouse___;


FUNCTION Get_Remote_Whse_Refill_Qty___ (
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   warehouse_id_            IN VARCHAR2,
   performing_putaway_      IN BOOLEAN,
   performing_optimization_ IN BOOLEAN,
   inventory_event_id_      IN NUMBER ) RETURN NUMBER
IS
   remote_whse_refill_qty_      NUMBER := positive_infinity_;
   assortment_id_               VARCHAR2(50);
   plannable_qty_               NUMBER;
   refill_point_qty_            NUMBER;
   refill_to_qty_               NUMBER;
   remove_excess_inventory_db_  VARCHAR2(5);
   refill_is_in_progress_       BOOLEAN;
   qty_inbound_for_warehouse_   NUMBER;
BEGIN   
   IF ((performing_putaway_) OR (performing_optimization_)) THEN
      assortment_id_ := Remote_Whse_Assort_Part_API.Get_Prioritized_Assortment_Id(part_no_, contract_, warehouse_id_);

      IF (assortment_id_ IS NOT NULL) THEN
         
         Remote_Whse_Assort_Connect_API.Lock_By_Keys_Wait(contract_, warehouse_id_, assortment_id_);
         
         plannable_qty_              := Remote_Whse_Assort_Part_API.Get_Plannable_Qty(part_no_, contract_, warehouse_id_);
         refill_point_qty_           := Remote_Whse_Assort_Part_API.Get_Refill_Point_Inv_Qty(assortment_id_, part_no_, contract_);
         refill_to_qty_              := Remote_Whse_Assort_Part_API.Get_Refill_To_Inv_Qty(assortment_id_, part_no_, contract_);
         remove_excess_inventory_db_ := Remote_Whse_Assort_Part_API.Get_Remove_Excess_Inventory_Db(assortment_id_, part_no_);
         refill_is_in_progress_      := Remote_Whse_Refill_Event_API.Refill_Is_In_Progress(contract_, part_no_, warehouse_id_);
         IF NOT (refill_is_in_progress_) THEN
            qty_inbound_for_warehouse_ := Transport_Task_API.Get_Qty_Inbound_For_Warehouse(part_no_,
                                                                                           configuration_id_,
                                                                                           contract_,
                                                                                           warehouse_id_);
            IF (qty_inbound_for_warehouse_ > 0) THEN
               -- If quantities of this part are already decided to be transported from another warehouse to this remote warehouse
               -- then we consider this as a Refill In Progress, which means that we should continue to refill up to refill_to_qty_.
               refill_is_in_progress_ := TRUE;
            END IF;
         END IF;

         IF ((plannable_qty_ < refill_point_qty_) OR
            ((plannable_qty_ > refill_to_qty_) AND (remove_excess_inventory_db_ = Fnd_Boolean_API.db_true)) OR
            ((plannable_qty_ < refill_to_qty_) AND refill_is_in_progress_) OR
            ((refill_point_qty_ = 0) AND (plannable_qty_ = 0))) THEN
            -- We want to indicate a need to refill (a positive remote_whse_refill_qty_)
            -- when plannable quantity is below the refill point, or if they both are zero.
            -- In this case we will refill up to the specified 'refill to qty'.
            -- In case the plannable qty it above the 'refill to qty' we will indicate this
            -- with a negative remote_whse_refill_qty_ which will make the optimization job pull the excess away.
            remote_whse_refill_qty_ := refill_to_qty_ - plannable_qty_;
            IF (inventory_event_id_ IS NOT NULL) THEN
               IF ((plannable_qty_ < refill_point_qty_) OR
                  ((plannable_qty_ < refill_to_qty_) AND refill_is_in_progress_) OR
                  ((refill_point_qty_ = 0) AND (plannable_qty_ = 0))) THEN
                  -- We need to indicate that we have found this combination of inventory part and remote warehouse
                  -- to have a Plannable Qty which is below the Refill Point Qty. This indication will help us 
                  -- understand that we should continue to refill until we reach the Refill To Qty. 
                  Remote_Whse_Refill_Event_API.New(contract_, part_no_, warehouse_id_, inventory_event_id_);
               END IF;
            END IF;
         ELSE
            remote_whse_refill_qty_ := 0;
            IF (refill_is_in_progress_) THEN
               Remote_Whse_Refill_Event_API.Remove_Part_Warehouse(contract_, part_no_, warehouse_id_);
            END IF;
         END IF;
      END IF;
   END IF;

   RETURN(remote_whse_refill_qty_);
END Get_Remote_Whse_Refill_Qty___;


FUNCTION Is_Process_Enabled_Whse___ (
   contract_               IN VARCHAR2,
   warehouse_id_           IN VARCHAR2,
   performing_putaway_     IN BOOLEAN,
   calling_process_        IN VARCHAR2 ) RETURN BOOLEAN
IS
   is_process_enabled_whse_ BOOLEAN := TRUE;
   warehouse_rec_           Warehouse_API.Public_Rec;
BEGIN   
   IF (performing_putaway_) THEN
      -- Performing_putaway_ is always TRUE unless we are in the context of "Check Storage Requirements" which is only using the Putaway logic
      -- for validations, not for creating actual transport tasks. And since we want to allow manual receipts, moves etcetera regardless of
      -- the warehouse settings this method will always return TRUE when running only validations.

      CASE calling_process_
         WHEN 'AUTOMATIC_REFILL' THEN
            -- It is only when the refill is triggered automatically by an issue or a receipt that calling_process_ is 'AUTOMATIC_REFILL'.
            -- So when the refill is triggered from a scheduled background job then it is not considered as an auto_refill and thus we ignore
            -- the setting on the warehouse. This is specifically designed for situations where the continuous creation of refill transport tasks is unwanted.
            warehouse_rec_           := Warehouse_API.Get(contract_, warehouse_id_);
            is_process_enabled_whse_ := warehouse_rec_.auto_refill_putaway_zones = db_true_;
         WHEN 'PUTAWAY' THEN
            -- Calling process is 'PUTAWAY' when the putaway logic is actually executed in a true 'putaway context', meaning that the end user has
            -- initiated a Putaway. This separates from when the logic is used to perform refill. 
            warehouse_rec_           := Warehouse_API.Get(contract_, warehouse_id_);
            is_process_enabled_whse_ := warehouse_rec_.putaway_destination = db_true_;
         WHEN 'DEFERRED_REFILL' THEN
            -- Deferred Refill (background job 'Refill All Putaway Zones') is allowed irrespective of any warehouse settings.
            NULL;
         WHEN 'MOVE_ORDER_RESERVATION' THEN
            -- Move Order Reservation is allowed irrespective of any warehouse settings. 
            NULL;
         ELSE
            Error_SYS.Record_General(lu_name_, 'CALLINGPROCESS: No implementation for calling process :P1 in method Is_Process_Enabled_Whse___. Contact System Support.', calling_process_);
      END CASE;
   END IF;

   RETURN (is_process_enabled_whse_);
END Is_Process_Enabled_Whse___;

PROCEDURE Reject_Bins_Not_In_Whse_Bay___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   storage_zone_id_    IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2 )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   local_warehouse_id_ warehouse_tab.warehouse_id%TYPE;
   local_bay_id_       warehouse_bay_tab.bay_id%TYPE;
BEGIN
   IF ((warehouse_id_ IS NOT NULL) OR (bay_id_ IS NOT NULL)) THEN

      local_warehouse_id_ := NVL(warehouse_id_, '%');
      local_bay_id_       := NVL(bay_id_      , '%');

      UPDATE putaway_zone_bin_tmp
         SET rejected = Fnd_Boolean_API.DB_TRUE
       WHERE putaway_session_id = putaway_session_id_
         AND contract           = contract_
         AND part_no            = part_no_
         AND storage_zone_id    = storage_zone_id_
         AND rejected           = Fnd_Boolean_API.DB_FALSE
         AND NOT ((warehouse_id LIKE local_warehouse_id_) AND (bay_id LIKE local_bay_id_));
   END IF;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
END Reject_Bins_Not_In_Whse_Bay___;


PROCEDURE Reject_Bins_Not_In_Use___ (
   putaway_session_id_ IN NUMBER, 
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   storage_zone_id_    IN VARCHAR2 )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   UPDATE putaway_zone_bin_tmp
      SET rejected = Fnd_Boolean_API.DB_TRUE
    WHERE putaway_session_id = putaway_session_id_
      AND contract           = contract_
      AND part_no            = part_no_
      AND storage_zone_id    = storage_zone_id_
      AND in_use             = Fnd_Boolean_API.DB_FALSE
      AND rejected           = Fnd_Boolean_API.DB_FALSE;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
END Reject_Bins_Not_In_Use___;


PROCEDURE Putaway_Part___ (
   handling_unit_putaway_success_    OUT BOOLEAN,
   info_                             OUT VARCHAR2,
   transport_task_id_             IN OUT NUMBER,
   selected_hu_location_no_       IN OUT VARCHAR2,
   contract_                      IN     VARCHAR2,
   part_no_                       IN     VARCHAR2,
   configuration_id_              IN     VARCHAR2,
   location_no_                   IN     VARCHAR2,
   lot_batch_no_                  IN     VARCHAR2,
   serial_no_tab_                 IN     Part_Serial_Catalog_API.Serial_No_Tab,
   eng_chg_level_                 IN     VARCHAR2,
   waiv_dev_rej_no_               IN     VARCHAR2,
   activity_seq_                  IN     NUMBER,
   handling_unit_id_              IN     NUMBER,
   quantity_                      IN     NUMBER,
   handl_unit_capability_req_tab_ IN     Storage_Capability_API.Capability_Tab,
   putaway_session_id_            IN     NUMBER,
   source_ref1_                   IN     VARCHAR2 DEFAULT NULL,
   source_ref2_                   IN     VARCHAR2 DEFAULT NULL,
   source_ref3_                   IN     VARCHAR2 DEFAULT NULL,
   source_ref4_                   IN     NUMBER   DEFAULT NULL,
   source_ref_type_db_            IN     VARCHAR2 DEFAULT NULL,
   calling_process_               IN     VARCHAR2 DEFAULT 'PUTAWAY',
   to_warehouse_id_               IN     VARCHAR2 DEFAULT NULL,
   to_bay_id_                     IN     VARCHAR2 DEFAULT NULL,
   putting_away_handling_unit_    IN     BOOLEAN  DEFAULT FALSE,
   handling_unit_gross_weight_    IN     NUMBER   DEFAULT NULL,
   handling_unit_volume_          IN     NUMBER   DEFAULT NULL,
   handl_unit_height_requirement_ IN     NUMBER   DEFAULT NULL,
   handl_unit_width_requirement_  IN     NUMBER   DEFAULT NULL,
   handl_unit_depth_requirement_  IN     NUMBER   DEFAULT NULL,
   handling_unit_min_temperature_ IN     NUMBER   DEFAULT NULL,
   handling_unit_max_temperature_ IN     NUMBER   DEFAULT NULL,
   handling_unit_min_humidity_    IN     NUMBER   DEFAULT NULL,
   handling_unit_max_humidity_    IN     NUMBER   DEFAULT NULL )
IS
   line_info_               VARCHAR2(2000);
   local_serial_no_tab_     Part_Serial_Catalog_API.Serial_No_Tab;
   condition_code_usage_db_ VARCHAR2(20);
   mixed_condition_codes_   BOOLEAN := FALSE;
   number_of_serials_       NUMBER;
   iterations_              NUMBER := 1;
   local_quantity_          NUMBER;
   dummy_number_            NUMBER;
BEGIN

   condition_code_usage_db_ := Part_Catalog_API.Get_Condition_Code_Usage_Db(part_no_);
   number_of_serials_       := serial_no_tab_.COUNT;

   IF (number_of_serials_ = 0) THEN
      local_quantity_ := quantity_;
   END IF;

   IF (number_of_serials_ > 1) THEN
      mixed_condition_codes_ := Mixed_Condition_Codes___(serial_no_tab_, part_no_, lot_batch_no_, condition_code_usage_db_); 
   END IF;

   IF (mixed_condition_codes_) THEN
      iterations_ := number_of_serials_;
   ELSE
      local_serial_no_tab_ := serial_no_tab_;
   END IF;

   Inventory_Event_Manager_API.Start_Session;
   FOR i IN 1..iterations_ LOOP
      IF (mixed_condition_codes_) THEN
         local_serial_no_tab_(1).serial_no := serial_no_tab_(i).serial_no;
      END IF;
      
      Putaway___(handling_unit_putaway_success_ => handling_unit_putaway_success_,
                 qty_not_in_good_place_         => dummy_number_,
                 transport_task_id_             => transport_task_id_,
                 selected_hu_location_no_       => selected_hu_location_no_,
                 contract_                      => contract_,
                 part_no_                       => part_no_,
                 configuration_id_              => configuration_id_,
                 from_location_no_              => location_no_,
                 lot_batch_no_                  => lot_batch_no_,
                 serial_no_tab_                 => local_serial_no_tab_,
                 eng_chg_level_                 => eng_chg_level_,
                 waiv_dev_rej_no_               => waiv_dev_rej_no_,
                 activity_seq_                  => activity_seq_,
                 handling_unit_id_              => handling_unit_id_,
                 quantity_                      => local_quantity_,
                 source_ref1_                   => source_ref1_,
                 source_ref2_                   => source_ref2_,
                 source_ref3_                   => source_ref3_,
                 source_ref4_                   => source_ref4_,
                 source_ref_type_db_            => source_ref_type_db_,
                 condition_code_usage_db_       => condition_code_usage_db_,
                 to_location_no_                => NULL,
                 to_warehouse_id_               => to_warehouse_id_,
                 to_bay_id_                     => to_bay_id_,
                 to_tier_id_                    => NULL,
                 to_row_id_                     => NULL,
                 to_bin_id_                     => NULL,
                 condition_code_                => NULL,
                 calling_process_               => calling_process_,
                 putting_away_handling_unit_    => putting_away_handling_unit_,
                 handling_unit_gross_weight_    => handling_unit_gross_weight_,
                 handling_unit_volume_          => handling_unit_volume_,
                 handl_unit_height_requirement_ => handl_unit_height_requirement_,
                 handl_unit_width_requirement_  => handl_unit_width_requirement_,
                 handl_unit_depth_requirement_  => handl_unit_depth_requirement_,
                 handling_unit_id_investigated_ => NULL,
                 handling_unit_min_temperature_ => handling_unit_min_temperature_,
                 handling_unit_max_temperature_ => handling_unit_max_temperature_,
                 handling_unit_min_humidity_    => handling_unit_min_humidity_,
                 handling_unit_max_humidity_    => handling_unit_max_humidity_,
                 putaway_session_id_            => putaway_session_id_,
                 handl_unit_capability_req_tab_ => handl_unit_capability_req_tab_);

      line_info_ := line_info_ || Client_SYS.Get_All_Info;
      -- If putting away content of a handling unit and a failure has been detected then there is no point in continuing in the loop.
      EXIT WHEN ((putting_away_handling_unit_) AND (NOT handling_unit_putaway_success_));
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;

   info_ := line_info_ || Client_SYS.Get_All_Info;
END Putaway_Part___;


FUNCTION Get_Common_Putaway_Bin_Tab___ (
   first_putaway_bin_tab_  IN Warehouse_Bay_Bin_API.Putaway_Bin_Tab,
   second_putaway_bin_tab_ IN Warehouse_Bay_Bin_API.Putaway_Bin_Tab ) RETURN Warehouse_Bay_Bin_API.Putaway_Bin_Tab
IS
   common_putaway_bin_tab_ Warehouse_Bay_Bin_API.Putaway_Bin_Tab;
   counter_                PLS_INTEGER := 0;
BEGIN
   IF ((first_putaway_bin_tab_.COUNT > 0) AND (second_putaway_bin_tab_.COUNT > 0)) THEN
      FOR i IN first_putaway_bin_tab_.FIRST..first_putaway_bin_tab_.LAST LOOP
         FOR j IN second_putaway_bin_tab_.FIRST..second_putaway_bin_tab_.LAST LOOP
            IF (first_putaway_bin_tab_(i).location_no = second_putaway_bin_tab_(j).location_no) THEN
               counter_                          := counter_ + 1;
               common_putaway_bin_tab_(counter_) := first_putaway_bin_tab_(i);
               EXIT;
            END IF;
         END LOOP;
      END LOOP;
   END IF;
   RETURN (common_putaway_bin_tab_);
END Get_Common_Putaway_Bin_Tab___;


PROCEDURE Putaway_Handl_Unit_Content___ (
   handling_unit_putaway_success_    OUT BOOLEAN,
   putaway_failure_is_final_         OUT BOOLEAN,
   selected_putaway_location_no_  IN OUT VARCHAR2,
   stock_record_tab_              IN     Stock_Record_Tab,
   handling_unit_gross_weight_    IN     NUMBER,
   handling_unit_volume_          IN     NUMBER,
   handl_unit_height_requirement_ IN     NUMBER,
   handl_unit_width_requirement_  IN     NUMBER,
   handl_unit_depth_requirement_  IN     NUMBER,
   handling_unit_min_temperature_ IN     NUMBER,
   handling_unit_max_temperature_ IN     NUMBER,
   handling_unit_min_humidity_    IN     NUMBER,
   handling_unit_max_humidity_    IN     NUMBER,
   handl_unit_capability_req_tab_ IN     Storage_Capability_API.Capability_Tab,
   calling_process_               IN     VARCHAR2,
   putaway_session_id_            IN     NUMBER )
IS
   serial_no_tab_                 Part_Serial_Catalog_API.Serial_No_Tab;
   putaway_previous_serials_      BOOLEAN;
   putaway_current_record_        BOOLEAN;
   add_current_serial_            BOOLEAN;
   serial_counter_                NUMBER := 0;
   previous_serial_part_no_       inventory_part_in_stock_tab.part_no%TYPE;
   previous_serial_config_id_     inventory_part_in_stock_tab.configuration_id%TYPE;
   previous_serial_lot_batch_no_  inventory_part_in_stock_tab.lot_batch_no%TYPE;
   previous_serial_eng_chg_level_ inventory_part_in_stock_tab.lot_batch_no%TYPE;
   previous_serial_wdr_no_        inventory_part_in_stock_tab.waiv_dev_rej_no%TYPE;
   previous_serial_activity_seq_  inventory_part_in_stock_tab.activity_seq%TYPE;
   previous_serial_handl_unit_id_ inventory_part_in_stock_tab.handling_unit_id%TYPE;
   previous_serial_source_ref1_   transport_task_line_tab.order_ref1%TYPE;
   previous_serial_source_ref2_   transport_task_line_tab.order_ref2%TYPE;
   previous_serial_source_ref3_   transport_task_line_tab.order_ref3%TYPE;
   previous_serial_source_ref4_   transport_task_line_tab.order_ref4%TYPE;
   prev_serial_src_ref_type_db_   transport_task_line_tab.order_type%TYPE;
   exit_procedure_                EXCEPTION;
   contract_                      inventory_part_in_stock_tab.contract%TYPE;
   location_no_                   inventory_part_in_stock_tab.location_no%TYPE; 
   putaway_attempt_counter_       NUMBER := 0;
   transport_task_id_             NUMBER;
BEGIN
   contract_                      := stock_record_tab_(stock_record_tab_.FIRST).contract;
   location_no_                   := stock_record_tab_(stock_record_tab_.FIRST).location_no;
   putaway_failure_is_final_      := FALSE;

   Inventory_Event_Manager_API.Start_Session;
   FOR i IN stock_record_tab_.FIRST..stock_record_tab_.LAST LOOP
      putaway_previous_serials_ := FALSE;
      putaway_current_record_   := FALSE;
      add_current_serial_       := FALSE;

      IF (stock_record_tab_(i).serial_no = '*') THEN
         -- Putaway should be called immediately for any non-serial-tracked record.
         -- But first need to perform Putaway for all earlier collected serials in serial_no_tab_.
         putaway_previous_serials_ := TRUE;
         putaway_current_record_   := TRUE;
      ELSE
         -- Current record is serial tracked
         IF ((Validate_SYS.Is_Different(stock_record_tab_(i).part_no           , previous_serial_part_no_      )) OR
             (Validate_SYS.Is_Different(stock_record_tab_(i).configuration_id  , previous_serial_config_id_    )) OR
             (Validate_SYS.Is_Different(stock_record_tab_(i).lot_batch_no      , previous_serial_lot_batch_no_ )) OR
             (Validate_SYS.Is_Different(stock_record_tab_(i).eng_chg_level     , previous_serial_eng_chg_level_)) OR
             (Validate_SYS.Is_Different(stock_record_tab_(i).waiv_dev_rej_no   , previous_serial_wdr_no_       )) OR
             (Validate_SYS.Is_Different(stock_record_tab_(i).activity_seq      , previous_serial_activity_seq_ )) OR 
             (Validate_SYS.Is_Different(stock_record_tab_(i).handling_unit_id  , previous_serial_handl_unit_id_)) OR
             (Validate_SYS.Is_Different(stock_record_tab_(i).source_ref1       , previous_serial_source_ref1_  )) OR
             (Validate_SYS.Is_Different(stock_record_tab_(i).source_ref2       , previous_serial_source_ref2_  )) OR
             (Validate_SYS.Is_Different(stock_record_tab_(i).source_ref3       , previous_serial_source_ref3_  )) OR
             (Validate_SYS.Is_Different(stock_record_tab_(i).source_ref4       , previous_serial_source_ref4_  )) OR
             (Validate_SYS.Is_Different(stock_record_tab_(i).source_ref_type_db, prev_serial_src_ref_type_db_  ))) THEN
            -- Current record has different keys that previously collected serials. To call
            -- Putaway for the preiously collected serials.
            putaway_previous_serials_ := TRUE;
         END IF;
         -- Add current serial to the collection. 
         add_current_serial_ := TRUE;
      END IF;

      IF (putaway_previous_serials_) THEN
         IF (serial_no_tab_.COUNT > 0) THEN
            Putaway_Part_In_Handl_Unit___(handling_unit_putaway_success_ => handling_unit_putaway_success_,
                                          putaway_failure_is_final_      => putaway_failure_is_final_,
                                          selected_putaway_location_no_  => selected_putaway_location_no_,
                                          putaway_attempt_counter_       => putaway_attempt_counter_,
                                          selected_transport_task_id_    => transport_task_id_,
                                          contract_                      => stock_record_tab_(i).contract,
                                          part_no_                       => previous_serial_part_no_,     
                                          configuration_id_              => previous_serial_config_id_,   
                                          location_no_                   => stock_record_tab_(i).location_no,
                                          lot_batch_no_                  => previous_serial_lot_batch_no_,   
                                          serial_no_tab_                 => serial_no_tab_,                  
                                          eng_chg_level_                 => previous_serial_eng_chg_level_, 
                                          waiv_dev_rej_no_               => previous_serial_wdr_no_,        
                                          activity_seq_                  => previous_serial_activity_seq_,  
                                          handling_unit_id_              => previous_serial_handl_unit_id_, 
                                          quantity_                      => NULL,                           
                                          handling_unit_gross_weight_    => handling_unit_gross_weight_,
                                          handling_unit_volume_          => handling_unit_volume_,
                                          handl_unit_height_requirement_ => handl_unit_height_requirement_,
                                          handl_unit_width_requirement_  => handl_unit_width_requirement_, 
                                          handl_unit_depth_requirement_  => handl_unit_depth_requirement_,
                                          handling_unit_min_temperature_ => handling_unit_min_temperature_,
                                          handling_unit_max_temperature_ => handling_unit_max_temperature_,
                                          handling_unit_min_humidity_    => handling_unit_min_humidity_,
                                          handling_unit_max_humidity_    => handling_unit_max_humidity_,
                                          handl_unit_capability_req_tab_ => handl_unit_capability_req_tab_,
                                          source_ref1_                   => previous_serial_source_ref1_,
                                          source_ref2_                   => previous_serial_source_ref2_,
                                          source_ref3_                   => previous_serial_source_ref3_,
                                          source_ref4_                   => previous_serial_source_ref4_,
                                          source_ref_type_db_            => prev_serial_src_ref_type_db_,
                                          calling_process_               => calling_process_,
                                          putaway_session_id_            => putaway_session_id_);
            IF NOT (handling_unit_putaway_success_) THEN
               RAISE exit_procedure_;
            END IF;

            serial_no_tab_.DELETE;
            serial_counter_ := 0;
         END IF;
      END IF;
      IF (putaway_current_record_) THEN
         Putaway_Part_In_Handl_Unit___(handling_unit_putaway_success_ => handling_unit_putaway_success_,
                                       putaway_failure_is_final_      => putaway_failure_is_final_,
                                       selected_putaway_location_no_  => selected_putaway_location_no_,
                                       putaway_attempt_counter_       => putaway_attempt_counter_,
                                       selected_transport_task_id_    => transport_task_id_,
                                       contract_                      => stock_record_tab_(i).contract,         
                                       part_no_                       => stock_record_tab_(i).part_no,          
                                       configuration_id_              => stock_record_tab_(i).configuration_id, 
                                       location_no_                   => stock_record_tab_(i).location_no,      
                                       lot_batch_no_                  => stock_record_tab_(i).lot_batch_no,     
                                       serial_no_tab_                 => serial_no_tab_,                        
                                       eng_chg_level_                 => stock_record_tab_(i).eng_chg_level,    
                                       waiv_dev_rej_no_               => stock_record_tab_(i).waiv_dev_rej_no,  
                                       activity_seq_                  => stock_record_tab_(i).activity_seq,     
                                       handling_unit_id_              => stock_record_tab_(i).handling_unit_id, 
                                       quantity_                      => stock_record_tab_(i).qty_onhand,       
                                       handling_unit_gross_weight_    => handling_unit_gross_weight_,
                                       handling_unit_volume_          => handling_unit_volume_,
                                       handl_unit_height_requirement_ => handl_unit_height_requirement_,
                                       handl_unit_width_requirement_  => handl_unit_width_requirement_, 
                                       handl_unit_depth_requirement_  => handl_unit_depth_requirement_,
                                       handling_unit_min_temperature_ => handling_unit_min_temperature_,
                                       handling_unit_max_temperature_ => handling_unit_max_temperature_,
                                       handling_unit_min_humidity_    => handling_unit_min_humidity_,
                                       handling_unit_max_humidity_    => handling_unit_max_humidity_,
                                       handl_unit_capability_req_tab_ => handl_unit_capability_req_tab_,
                                       source_ref1_                   => stock_record_tab_(i).source_ref1,
                                       source_ref2_                   => stock_record_tab_(i).source_ref2,
                                       source_ref3_                   => stock_record_tab_(i).source_ref3,
                                       source_ref4_                   => stock_record_tab_(i).source_ref4,
                                       source_ref_type_db_            => stock_record_tab_(i).source_ref_type_db,
                                       calling_process_               => calling_process_,
                                       putaway_session_id_            => putaway_session_id_);
         IF NOT (handling_unit_putaway_success_) THEN
            RAISE exit_procedure_;
         END IF;
      END IF;
      IF (add_current_serial_) THEN
         serial_counter_ := serial_counter_ + 1;
         serial_no_tab_(serial_counter_).serial_no := stock_record_tab_(i).serial_no;
         previous_serial_part_no_       := stock_record_tab_(i).part_no;
         previous_serial_config_id_     := stock_record_tab_(i).configuration_id;
         previous_serial_lot_batch_no_  := stock_record_tab_(i).lot_batch_no;
         previous_serial_eng_chg_level_ := stock_record_tab_(i).eng_chg_level;
         previous_serial_wdr_no_        := stock_record_tab_(i).waiv_dev_rej_no;
         previous_serial_activity_seq_  := stock_record_tab_(i).activity_seq;
         previous_serial_handl_unit_id_ := stock_record_tab_(i).handling_unit_id;
         previous_serial_source_ref1_   := stock_record_tab_(i).source_ref1;
         previous_serial_source_ref2_   := stock_record_tab_(i).source_ref2;
         previous_serial_source_ref3_   := stock_record_tab_(i).source_ref3;
         previous_serial_source_ref4_   := stock_record_tab_(i).source_ref4;
         prev_serial_src_ref_type_db_   := stock_record_tab_(i).source_ref_type_db;
      END IF;
   END LOOP;
   
   IF (serial_no_tab_.COUNT > 0) THEN
      Putaway_Part_In_Handl_Unit___(handling_unit_putaway_success_ => handling_unit_putaway_success_,
                                    putaway_failure_is_final_      => putaway_failure_is_final_,
                                    selected_putaway_location_no_  => selected_putaway_location_no_,
                                    putaway_attempt_counter_       => putaway_attempt_counter_,
                                    selected_transport_task_id_    => transport_task_id_,
                                    contract_                      => contract_,                      
                                    part_no_                       => previous_serial_part_no_,       
                                    configuration_id_              => previous_serial_config_id_,     
                                    location_no_                   => location_no_,                   
                                    lot_batch_no_                  => previous_serial_lot_batch_no_,  
                                    serial_no_tab_                 => serial_no_tab_,                 
                                    eng_chg_level_                 => previous_serial_eng_chg_level_, 
                                    waiv_dev_rej_no_               => previous_serial_wdr_no_,        
                                    activity_seq_                  => previous_serial_activity_seq_,  
                                    handling_unit_id_              => previous_serial_handl_unit_id_, 
                                    quantity_                      => NULL,                           
                                    handling_unit_gross_weight_    => handling_unit_gross_weight_,
                                    handling_unit_volume_          => handling_unit_volume_,
                                    handl_unit_height_requirement_ => handl_unit_height_requirement_,
                                    handl_unit_width_requirement_  => handl_unit_width_requirement_, 
                                    handl_unit_depth_requirement_  => handl_unit_depth_requirement_,
                                    handling_unit_min_temperature_ => handling_unit_min_temperature_,
                                    handling_unit_max_temperature_ => handling_unit_max_temperature_,
                                    handling_unit_min_humidity_    => handling_unit_min_humidity_,
                                    handling_unit_max_humidity_    => handling_unit_max_humidity_,
                                    handl_unit_capability_req_tab_ => handl_unit_capability_req_tab_,
                                    source_ref1_                   => previous_serial_source_ref1_,
                                    source_ref2_                   => previous_serial_source_ref2_,
                                    source_ref3_                   => previous_serial_source_ref3_,
                                    source_ref4_                   => previous_serial_source_ref4_,
                                    source_ref_type_db_            => prev_serial_src_ref_type_db_,
                                    calling_process_               => calling_process_,
                                    putaway_session_id_            => putaway_session_id_);
      IF NOT (handling_unit_putaway_success_) THEN
         RAISE exit_procedure_;
      END IF;
   END IF;
   Inventory_Event_Manager_API.Finish_Session;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Putaway_Handl_Unit_Content___;


PROCEDURE Putaway_Part_In_Handl_Unit___ (
   handling_unit_putaway_success_    OUT BOOLEAN,
   putaway_failure_is_final_         OUT BOOLEAN,
   selected_putaway_location_no_  IN OUT VARCHAR2,
   putaway_attempt_counter_       IN OUT NUMBER,
   selected_transport_task_id_    IN OUT NUMBER,
   contract_                      IN     VARCHAR2,
   part_no_                       IN     VARCHAR2,
   configuration_id_              IN     VARCHAR2,
   location_no_                   IN     VARCHAR2,
   lot_batch_no_                  IN     VARCHAR2,
   serial_no_tab_                 IN     Part_Serial_Catalog_API.Serial_No_Tab,
   eng_chg_level_                 IN     VARCHAR2,
   waiv_dev_rej_no_               IN     VARCHAR2,
   activity_seq_                  IN     NUMBER,
   handling_unit_id_              IN     NUMBER,
   quantity_                      IN     NUMBER,
   handling_unit_gross_weight_    IN     NUMBER,
   handling_unit_volume_          IN     NUMBER,
   handl_unit_height_requirement_ IN     NUMBER,
   handl_unit_width_requirement_  IN     NUMBER,
   handl_unit_depth_requirement_  IN     NUMBER,
   handling_unit_min_temperature_ IN     NUMBER,
   handling_unit_max_temperature_ IN     NUMBER,
   handling_unit_min_humidity_    IN     NUMBER,
   handling_unit_max_humidity_    IN     NUMBER,
   handl_unit_capability_req_tab_ IN     Storage_Capability_API.Capability_Tab,
   source_ref1_                   IN     VARCHAR2,
   source_ref2_                   IN     VARCHAR2,
   source_ref3_                   IN     VARCHAR2,
   source_ref4_                   IN     NUMBER,
   source_ref_type_db_            IN     VARCHAR2,
   calling_process_               IN     VARCHAR2,
   putaway_session_id_            IN     NUMBER )
IS
   dummy_string_                  VARCHAR2(2000);
   local_handl_unit_gross_weight_ NUMBER;
   local_handling_unit_volume_    NUMBER;
BEGIN
   putaway_attempt_counter_       := putaway_attempt_counter_ + 1;
   local_handl_unit_gross_weight_ := handling_unit_gross_weight_;
   local_handling_unit_volume_    := handling_unit_volume_;

   IF (putaway_attempt_counter_ > 1) THEN
      IF (local_handl_unit_gross_weight_ IS NOT NULL) THEN
         -- We consume the full carrying capacity of the bin already at the first attempt, so for the
         -- reminding content the weight is indicated as zero.
         local_handl_unit_gross_weight_ := 0;
      END IF;
      IF (local_handling_unit_volume_ IS NOT NULL) THEN
         -- We consume the full volume capacity of the bin already at the first attempt, so for the
         -- reminding content the volume is indicated as zero.
         local_handling_unit_volume_ := 0;
      END IF;
   END IF;

   Putaway_Part___(handling_unit_putaway_success_ => handling_unit_putaway_success_,
                   info_                          => dummy_string_,
                   transport_task_id_             => selected_transport_task_id_,
                   selected_hu_location_no_       => selected_putaway_location_no_,
                   contract_                      => contract_,
                   part_no_                       => part_no_,       
                   configuration_id_              => configuration_id_,     
                   location_no_                   => location_no_,   
                   lot_batch_no_                  => lot_batch_no_,  
                   serial_no_tab_                 => serial_no_tab_,                 
                   eng_chg_level_                 => eng_chg_level_, 
                   waiv_dev_rej_no_               => waiv_dev_rej_no_,        
                   activity_seq_                  => activity_seq_,  
                   handling_unit_id_              => handling_unit_id_, 
                   quantity_                      => quantity_,
                   putting_away_handling_unit_    => TRUE,
                   handling_unit_gross_weight_    => local_handl_unit_gross_weight_,
                   handling_unit_volume_          => local_handling_unit_volume_,
                   handl_unit_height_requirement_ => handl_unit_height_requirement_,
                   handl_unit_width_requirement_  => handl_unit_width_requirement_, 
                   handl_unit_depth_requirement_  => handl_unit_depth_requirement_,
                   handling_unit_min_temperature_ => handling_unit_min_temperature_,
                   handling_unit_max_temperature_ => handling_unit_max_temperature_,
                   handling_unit_min_humidity_    => handling_unit_min_humidity_,
                   handling_unit_max_humidity_    => handling_unit_max_humidity_,
                   handl_unit_capability_req_tab_ => handl_unit_capability_req_tab_,
                   putaway_session_id_            => putaway_session_id_,
                   source_ref1_                   => source_ref1_,
                   source_ref2_                   => source_ref2_,
                   source_ref3_                   => source_ref3_,
                   source_ref4_                   => source_ref4_,
                   source_ref_type_db_            => source_ref_type_db_,
                   calling_process_               => calling_process_);

   IF (putaway_attempt_counter_ = 1) THEN
      IF (NOT handling_unit_putaway_success_) THEN
         selected_transport_task_id_    := NULL;
         putaway_failure_is_final_      := TRUE;
      END IF;
   END IF;
END Putaway_Part_In_Handl_Unit___;


FUNCTION Hu_Type_Cap_Is_Consumed___ (
   consumed_hu_type_capacity_     IN OUT NUMBER,
   root_hu_type_in_stock_tab_     IN     Handling_Unit_Type_API.Unit_Type_Tab,
   hu_type_with_capacity_tab_     IN     Handling_Unit_Type_API.Unit_Type_Tab,
   contract_                      IN     VARCHAR2,
   location_no_                   IN     VARCHAR2,
   hu_type_id_investigated_       IN     VARCHAR2,
   hu_type_investigated_capacity_ IN     NUMBER,
   performing_putaway_            IN     BOOLEAN ) RETURN BOOLEAN
IS
BEGIN
   IF (root_hu_type_in_stock_tab_.COUNT > 0) THEN
      -- Something is indeed stored on this location. Could be packed, unpacked or both. Unpacked is indicated as handling unit type being NULL
      FOR i IN root_hu_type_in_stock_tab_.FIRST..root_hu_type_in_stock_tab_.LAST LOOP
         IF (hu_type_investigated_capacity_ IS NOT NULL) THEN
            -- There is HU Type Capacity limit for the type of the handling unit we are investigating in Check_Storage_Requirements...
            IF (Validate_SYS.Is_Different(root_hu_type_in_stock_tab_(i).handling_unit_type_id, hu_type_id_investigated_)) THEN
               -- There is unpacked stock or stock of another root handling Unit type in the location, so we cannot allow this one
               IF NOT (performing_putaway_) THEN
                  IF (root_hu_type_in_stock_tab_(i).handling_unit_type_id IS NULL) THEN
                     Error_SYS.Record_General(lu_name_, 'HUTYPECAPUNP: Location :P1 cannot store Handling Units of type :P2 because there is unpacked stock on or inbound to the location.', location_no_, hu_type_id_investigated_);
                  ELSE
                     Error_SYS.Record_General(lu_name_, 'DIFFHUTYPECAP: Location :P1 cannot store Handling Units of type :P2 because there is also stock packed in handling unit type :P3 on or inbound to the location.', location_no_, hu_type_id_investigated_, root_hu_type_in_stock_tab_(i).handling_unit_type_id);
                  END IF;
               END IF;
               RETURN (TRUE);
            END IF;             
         END IF;
         -- For each handling unit type actually stored on the location (including NULL for unpacked) we need to investigate if there are capacity limits
         FOR j IN hu_type_with_capacity_tab_.FIRST..hu_type_with_capacity_tab_.LAST LOOP
            -- For each handling unit in stock we loop through the handling unit type capacity restrictions to see if we have a match
            -- If we get a match then we know that consumption of limited capacity has already started for one specific HU Type.
            -- This means that we should not allow unpacked material or packed in other HU Type into this location.
            IF (Validate_SYS.Is_Equal(root_hu_type_in_stock_tab_(i).handling_unit_type_id, hu_type_with_capacity_tab_(j).handling_unit_type_id)) THEN
               -- We have found that a handling unit type with capacity limit has started to consume capacity at this location
               IF (Validate_SYS.Is_Equal(hu_type_with_capacity_tab_(j).handling_unit_type_id, hu_type_id_investigated_)) THEN
                  -- Since it is the same HU Type as we are now investigating we need to count to see if we are below the capacity limit or not.
                  consumed_hu_type_capacity_ := consumed_hu_type_capacity_ + 1;
                  IF (consumed_hu_type_capacity_ >= hu_type_investigated_capacity_) THEN
                     -- The capacity is already consumed up to or above the limit.
                     IF NOT (performing_putaway_) THEN
                        Error_SYS.Record_General(lu_name_, 'HUTYPECAPLIMIT: The Capacity Limit of :P1 for Handling Unit Type :P2 on Location :P3 is already reached', hu_type_investigated_capacity_, hu_type_id_investigated_, location_no_);
                     END IF;
                     RETURN (TRUE);
                  END IF;
               ELSE
                  -- We can consider the location as not available since a handling unit type having a capacity limit has started to consume from this location.
                  IF NOT (performing_putaway_) THEN
                     Error_SYS.Record_General(lu_name_,'HUTYPECAPRES: Location :P1 on site :P2 can currently only hold Handling Units of type :P3', location_no_, contract_, hu_type_with_capacity_tab_(j).handling_unit_type_id);
                  END IF;
                  RETURN (TRUE);
               END IF;
            END IF;
         END LOOP;
      END LOOP;
   END IF;

   RETURN (FALSE);
END Hu_Type_Cap_Is_Consumed___;


FUNCTION Violating_Hu_Type_Capacity___ (
   contract_                      IN VARCHAR2,
   warehouse_id_                  IN VARCHAR2,
   bay_id_                        IN VARCHAR2,
   tier_id_                       IN VARCHAR2,
   row_id_                        IN VARCHAR2,
   bin_id_                        IN VARCHAR2,
   location_no_                   IN VARCHAR2,
   performing_putaway_            IN BOOLEAN,
   putting_away_handling_unit_    IN BOOLEAN,
   hu_type_id_investigated_       IN VARCHAR2,
   handling_unit_id_investigated_ IN NUMBER ) RETURN BOOLEAN
IS
   hu_type_with_capacity_tab_     Handling_Unit_Type_API.Unit_Type_Tab;
   root_hu_type_in_stock_tab_     Handling_Unit_Type_API.Unit_Type_Tab;
   hu_type_investigated_capacity_ NUMBER;
   consumed_hu_type_capacity_     NUMBER := 0;
   inbound_handl_unit_stock_tab_  Handl_Unit_Stock_Snapshot_API.Handl_Unit_Stock_Tab;
   index_                         PLS_INTEGER := 0;
BEGIN
   IF (putting_away_handling_unit_) THEN
      -- This has already been cleared in Putaway_Handling_Unit for the whole HU
      RETURN (FALSE);
   END IF;
      -- Get a list of all handling unit types for which there is a capacity limit defined on this location. 
   hu_type_with_capacity_tab_ := Warehouse_Bin_Hu_Capacity_API.Get_Hu_Types_Having_Cap_Limits(contract_,
                                                                                              warehouse_id_,
                                                                                              bay_id_,
                                                                                              tier_id_,
                                                                                              row_id_,
                                                                                              bin_id_);
   IF (hu_type_with_capacity_tab_.COUNT = 0) THEN
      -- There are no Handling Unit Type Capacity limits defined for this location.
      RETURN (FALSE);
   END IF;

   IF (hu_type_id_investigated_ IS NOT NULL) THEN
      -- From Check_Storage_Requirements there is a specific Handling Unit identified to be investigated
      hu_type_investigated_capacity_ := Warehouse_Bin_Hu_Capacity_API.Get_Operative_Hu_Type_Capacity(contract_,
                                                                                                     warehouse_id_,
                                                                                                     bay_id_,
                                                                                                     tier_id_,
                                                                                                     row_id_,
                                                                                                     bin_id_,
                                                                                                     hu_type_id_investigated_);
      IF (hu_type_investigated_capacity_ = 0) THEN
         -- The Capacity for this HU Type on the location is zero meaning that it should not be here at all
         IF NOT (performing_putaway_) THEN
            Error_SYS.Record_General(lu_name_, 'HUTYPEZEROCAP: The Capacity Limit for Handling Unit Type :P1 on Location :P2 is :P3.', hu_type_id_investigated_, location_no_, hu_type_investigated_capacity_);
         END IF;
         RETURN (TRUE);
      END IF;
   END IF;

   -- We need to lock the Location record before investigating the stock content. Otherwise two parallell processes might consume the same capacity
   Warehouse_Bay_Bin_API.Lock_By_Keys_Wait(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
  
   -- Fetch the types of the root handling units stored on this location. One record per Handling Unit
   -- meaning that the same HU Type ID can appear many times in the result.
   root_hu_type_in_stock_tab_ := Inventory_Part_In_Stock_API.Get_Root_Hu_Types_In_Stock(contract_,
                                                                                        warehouse_id_,
                                                                                        bay_id_,
                                                                                        tier_id_,
                                                                                        row_id_,
                                                                                        bin_id_,
                                                                                        ignore_this_handling_unit_id_ => handling_unit_id_investigated_);
   IF (Hu_Type_Cap_Is_Consumed___(consumed_hu_type_capacity_,
                                  root_hu_type_in_stock_tab_,
                                  hu_type_with_capacity_tab_,
                                  contract_,
                                  location_no_,
                                  hu_type_id_investigated_,
                                  hu_type_investigated_capacity_,
                                  performing_putaway_)) THEN
      RETURN (TRUE);
   END IF;

   inbound_handl_unit_stock_tab_ := Transport_Task_API.Get_Inbound_Handling_Units(contract_, 
                                                                                  location_no_,
                                                                                  incl_hu_zero_in_result_ => FALSE);

   IF (inbound_handl_unit_stock_tab_.COUNT > 0) THEN
      root_hu_type_in_stock_tab_.DELETE;
      FOR i IN inbound_handl_unit_stock_tab_.FIRST..inbound_handl_unit_stock_tab_.LAST LOOP
         IF ((handling_unit_id_investigated_ IS NULL) OR
             (Handling_Unit_API.Get_Root_Handling_Unit_Id(inbound_handl_unit_stock_tab_(i).handling_unit_id) != handling_unit_id_investigated_)) THEN
            index_ := index_ + 1;
            root_hu_type_in_stock_tab_(index_).handling_unit_type_id := Handling_Unit_API.Get_Handling_Unit_Type_Id(inbound_handl_unit_stock_tab_(i).handling_unit_id);
         END IF;
      END LOOP;
      IF (Hu_Type_Cap_Is_Consumed___(consumed_hu_type_capacity_,
                                     root_hu_type_in_stock_tab_,
                                     hu_type_with_capacity_tab_,
                                     contract_,
                                     location_no_,
                                     hu_type_id_investigated_,
                                     hu_type_investigated_capacity_,
                                     performing_putaway_)) THEN
         RETURN (TRUE);
      END IF;
   END IF;

   RETURN (FALSE);
END Violating_Hu_Type_Capacity___;


PROCEDURE Putaway_Handling_Unit___ (
   previous_hu_stock_record_tab_  IN OUT NOCOPY Stock_Record_Tab,
   handling_unit_min_temperature_ IN OUT NOCOPY NUMBER, 
   handling_unit_max_temperature_ IN OUT NOCOPY NUMBER,
   handling_unit_min_humidity_    IN OUT NOCOPY NUMBER,
   handling_unit_max_humidity_    IN OUT NOCOPY NUMBER,
   handl_unit_capability_req_tab_ IN OUT NOCOPY Storage_Capability_API.Capability_Tab,
   putaway_session_id_            IN OUT NOCOPY NUMBER,
   handling_unit_rec_             IN            Handling_Unit_API.Public_Rec,
   source_ref_type_db_            IN            VARCHAR2,
   source_ref1_                   IN            VARCHAR2,
   source_ref2_                   IN            VARCHAR2,
   source_ref3_                   IN            VARCHAR2,
   source_ref4_                   IN            VARCHAR2,
   throw_error_on_exception_      IN            BOOLEAN,
   calling_process_               IN            VARCHAR2,
   handling_unit_volume_          IN            NUMBER  DEFAULT NULL,
   handling_unit_gross_weight_    IN            NUMBER  DEFAULT NULL,
   handl_unit_height_requirement_ IN            NUMBER  DEFAULT NULL,
   handl_unit_width_requirement_  IN            NUMBER  DEFAULT NULL,
   handl_unit_depth_requirement_  IN            NUMBER  DEFAULT NULL,
   previous_handling_unit_id_     IN            NUMBER  DEFAULT NULL,
   handling_units_are_comparable_ IN            BOOLEAN DEFAULT FALSE )
IS
   handling_unit_putaway_success_ BOOLEAN;
   putaway_failure_is_final_      BOOLEAN;
   stock_records_are_comparable_  BOOLEAN;
   reuse_putaway_prerequisites_   BOOLEAN := FALSE;
   local_hu_volume_               NUMBER  := handling_unit_volume_;
   local_hu_gross_weight_         NUMBER  := handling_unit_gross_weight_;
   local_hu_height_requirement_   NUMBER  := handl_unit_height_requirement_;
   local_hu_width_requirement_    NUMBER  := handl_unit_width_requirement_;
   local_hu_depth_requirement_    NUMBER  := handl_unit_depth_requirement_;
   stock_record_tab_              Stock_Record_Tab;
   previous_part_no_              inventory_part_in_stock_tab.part_no%TYPE := Database_SYS.string_null_;
   part_counter_                  INTEGER := 0;
   putaway_zone_tab_              Invent_Part_Putaway_Zone_API.Putaway_Zone_Tab;
   selected_putaway_location_no_  inventory_part_in_stock_tab.location_no%TYPE;
   exit_procedure_                EXCEPTION;
   previous_source_ref1_          transport_task_line_tab.order_ref1%TYPE;
   previous_source_ref2_          transport_task_line_tab.order_ref2%TYPE;
   previous_source_ref3_          transport_task_line_tab.order_ref3%TYPE;
   previous_source_ref4_          transport_task_line_tab.order_ref4%TYPE;

   CURSOR get_and_lock_stock_records IS
      SELECT ipis.contract,
             ipis.part_no,
             ipis.configuration_id,
             ipis.location_no,
             ipis.lot_batch_no,
             ipis.serial_no,
             ipis.eng_chg_level,
             ipis.waiv_dev_rej_no,
             ipis.activity_seq,
             ipis.handling_unit_id,
             ipis.qty_onhand,
             ipis.qty_reserved,
             ipis.qty_in_transit,
             ipis.location_type_db,
             ipis.freeze_flag_db,
             ipis.availability_control_id,
             ipis.rotable_part_pool_id,
             NVL(ipis.condition_code, 'STRINGNULL'),
             source_ref1_, 
             source_ref2_, 
             source_ref3_, 
             source_ref4_, 
             source_ref_type_db_
        FROM inventory_part_in_stock_pub ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                       CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                       START WITH       hu.handling_unit_id = handling_unit_rec_.handling_unit_id)
         AND (qty_onhand != 0 OR qty_in_transit != 0)
      ORDER BY ipis.part_no, ipis.handling_unit_id, ipis.configuration_id, ipis.lot_batch_no,
               ipis.eng_chg_level, ipis.waiv_dev_rej_no, ipis.activity_seq
      FOR UPDATE;

   $IF Component_Rceipt_SYS.INSTALLED $THEN
      CURSOR get_and_lock_receipt_records IS
         SELECT ipis.contract,
                ipis.part_no,
                ipis.configuration_id,
                ipis.location_no,
                ipis.lot_batch_no,
                ipis.serial_no,
                ipis.eng_chg_level,
                ipis.waiv_dev_rej_no,
                ipis.activity_seq,
                ipis.handling_unit_id,
                ril.inv_qty_in_store,
                ipis.qty_reserved,
                ipis.qty_in_transit,
                ipis.location_type_db,
                ipis.freeze_flag_db,
                ipis.availability_control_id,
                ipis.rotable_part_pool_id,
                NVL(ipis.condition_code, 'STRINGNULL'),
                ril.source_ref1,
                ril.source_ref2,
                ril.source_ref3,
                ril.receipt_no,
                ril.source_ref_type_db
           FROM inventory_part_in_stock_pub ipis,
                receipt_inv_location_pub    ril
          WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                            FROM handling_unit_tab hu
                                          CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                          START WITH       hu.handling_unit_id = handling_unit_rec_.handling_unit_id)
            AND (ipis.qty_onhand != 0 OR ipis.qty_in_transit != 0)
            AND ipis.contract         = ril.contract
            and ipis.part_no          = ril.part_no
            and ipis.configuration_id = ril.configuration_id
            and ipis.location_no      = ril.location_no
            and ipis.lot_batch_no     = ril.lot_batch_no
            and ipis.serial_no        = ril.serial_no
            and ipis.eng_chg_level    = ril.eng_chg_level
            and ipis.waiv_dev_rej_no  = ril.waiv_dev_rej_no
            and ipis.activity_seq     = ril.activity_seq
            and ipis.handling_unit_id = ril.handling_unit_id
         ORDER BY ipis.part_no, ipis.handling_unit_id, ipis.configuration_id, ipis.lot_batch_no,
                  ipis.eng_chg_level, ipis.waiv_dev_rej_no, ipis.activity_seq
         FOR UPDATE OF ipis.qty_reserved;
   $END

   CURSOR get_capability_requirements IS
      SELECT DISTINCT storage_capability_id
        FROM inventory_part_operative_cap
       WHERE (contract, part_no) IN (SELECT DISTINCT ipis.contract, ipis.part_no
                                       FROM inventory_part_in_stock_tab ipis
                                      WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                                                        FROM handling_unit_tab hu
                                                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                                                      START WITH       hu.handling_unit_id = handling_unit_rec_.handling_unit_id)
                                        AND (qty_onhand != 0 OR qty_in_transit != 0));
BEGIN

   IF (handling_unit_rec_.location_type IN (Inventory_Location_Type_API.DB_ARRIVAL, Inventory_Location_Type_API.DB_QUALITY_ASSURANCE)) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         OPEN  get_and_lock_receipt_records;
         FETCH get_and_lock_receipt_records BULK COLLECT INTO stock_record_tab_;
         CLOSE get_and_lock_receipt_records;
      $ELSE
         Error_SYS.Component_Not_Exist('RCEIPT');
      $END
   ELSE
      OPEN  get_and_lock_stock_records;
      FETCH get_and_lock_stock_records BULK COLLECT INTO stock_record_tab_;
      CLOSE get_and_lock_stock_records;
   END IF;

   IF (stock_record_tab_.COUNT = 0) THEN
      IF (throw_error_on_exception_) THEN
         Handling_Unit_API.Raise_Not_In_Stock_Error(handling_unit_rec_.handling_unit_id);
      ELSE
         RAISE exit_procedure_;
      END IF;
   END IF;

   IF (handling_unit_rec_.shipment_id IS NOT NULL) THEN
      IF (throw_error_on_exception_) THEN
         Error_SYS.Record_General(lu_name_, 'PUTAWAYHUSHIP: Handling unit ID :P1 is connected to shipment ID :P2.', handling_unit_rec_.handling_unit_id, handling_unit_rec_.shipment_id);
      ELSE
         RAISE exit_procedure_;
      END IF;
   END IF;

   IF (handling_unit_rec_.source_ref_type IS NOT NULL) THEN
      IF (throw_error_on_exception_) THEN
         Error_SYS.Record_General(lu_name_, 'PUTAWAYHUSOURCE: Handling unit ID :P1 is connected to :P2 :P3.', handling_unit_rec_.handling_unit_id, Handl_Unit_Source_Ref_Type_API.Decode(handling_unit_rec_.source_ref_type), handling_unit_rec_.source_ref1);
      ELSE
         RAISE exit_procedure_;
      END IF;
   END IF;

   IF (handling_units_are_comparable_) THEN
      -- Method Putaway_Handling_Units has not detected any differences between current and previous Handling Unit in terms of Handling Unit Type,
      -- Site, Height, Width, Depth, Weights or Volumes that would force us to start from the beginning to investigate zones and bins. 
      -- Need to conclude whether the latest HU at least have the same part numbers, Lot Batch numbers and Condition Codes as the last one.
      -- If not then we need to start all over again with finding and evaluating zones and bins.
      -- This is because the inventory locations might have Mix of Parts, Mix of LotBatch or Mix of Conditions set as Forbidden.
      -- It is Ok to continue with the same zones and bins if the latest HU has at least the same parts, lots, conditions as the previous one,
      -- since then we at least know that any of the bins we have skipped up to now cannot be used for this HU either.
      stock_records_are_comparable_ := Stock_Records_Are_Comparabl___(handling_unit_rec_.handling_unit_id,
                                                                      previous_handling_unit_id_,
                                                                      stock_record_tab_,
                                                                      previous_hu_stock_record_tab_);
      IF (stock_records_are_comparable_) THEN
         -- The Handling Unit and the Handling Unit content (the parts) are so similar that we can continue with the same putaway_session_id which 
         -- means that we have all the prerequisites loaded into temporary tables already.
         reuse_putaway_prerequisites_ := TRUE;
      ELSE
         Cleanup_Putaway_Session___(putaway_session_id_);
         putaway_session_id_ := Get_Next_Putaway_Session_Id___;
      END IF;
   END IF;

   FOR i IN stock_record_tab_.FIRST..stock_record_tab_.LAST LOOP

      IF stock_record_tab_(i).location_type IN (Inventory_Location_Type_API.DB_ARRIVAL, Inventory_Location_Type_API.DB_QUALITY_ASSURANCE) THEN
         $IF Component_Rceipt_SYS.INSTALLED $THEN
            IF (stock_record_tab_(i).source_ref_type_db IN (Logistics_Source_Ref_Type_API.DB_PURCHASE_ORDER, Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER)) THEN               
                  IF ((Validate_SYS.Is_Different(stock_record_tab_(i).source_ref1, previous_source_ref1_)) OR
                      (Validate_SYS.Is_Different(stock_record_tab_(i).source_ref2, previous_source_ref2_)) OR 
                      (Validate_SYS.Is_Different(stock_record_tab_(i).source_ref3, previous_source_ref3_)) OR 
                      (Validate_SYS.Is_Different(stock_record_tab_(i).source_ref4, previous_source_ref4_))) THEN                     
                     BEGIN
                        Receive_Order_API.Check_Putaway_And_Move_Receipt(source_ref1_           => stock_record_tab_(i).source_ref1,
                                                                         source_ref2_           => stock_record_tab_(i).source_ref2,
                                                                         source_ref3_           => stock_record_tab_(i).source_ref3,
                                                                         source_ref4_           => NULL,
                                                                         source_ref_type_db_    => stock_record_tab_(i).source_ref_type_db,
                                                                         receipt_no_            => stock_record_tab_(i).source_ref4,
                                                                         from_location_type_db_ => stock_record_tab_(i).location_type,
                                                                         to_location_type_db_   => Inventory_Location_Type_API.DB_PICKING);
                     EXCEPTION
                        WHEN OTHERS THEN
                           IF (throw_error_on_exception_) THEN
                              RAISE;
                           ELSE
                              RAISE exit_procedure_;
                           END IF;
                     END;
                     previous_source_ref1_ := stock_record_tab_(i).source_ref1;
                     previous_source_ref2_ := stock_record_tab_(i).source_ref2;
                     previous_source_ref3_ := stock_record_tab_(i).source_ref3;
                     previous_source_ref4_ := stock_record_tab_(i).source_ref4;
                  END IF;
            ELSE
               Error_SYS.Record_General(lu_name_, 'PUTAWAYHURECEIPT: Putaway of Handling Units is not supported for Source Reference Type :P1.', Logistics_Source_Ref_Type_API.Decode(stock_record_tab_(i).source_ref_type_db));
            END IF;
            stock_record_tab_(i).source_ref_type_db := Receive_Order_API.Get_Inv_Trans_Src_Ref_Type_Db(stock_record_tab_(i).source_ref_type_db);
         $ELSE
            Error_SYS.Component_Not_Exist('RCEIPT');
         $END
      END IF;

      IF (stock_record_tab_(i).qty_reserved != 0) THEN
         IF (throw_error_on_exception_) THEN
            Error_SYS.Record_General(lu_name_, 'PUTAWAYHURES: Handling Unit ID :P1 has reserved stock for Part :P2.', handling_unit_rec_.handling_unit_id, stock_record_tab_(i).part_no);
         ELSE
            RAISE exit_procedure_;
         END IF;
      END IF;

      IF (stock_record_tab_(i).qty_in_transit != 0) THEN
         IF (throw_error_on_exception_) THEN
            Error_SYS.Record_General(lu_name_, 'PUTAWAYHUTRANS: Handling Unit ID :P1 has stock in transit for Part :P2.', handling_unit_rec_.handling_unit_id, stock_record_tab_(i).part_no);
         ELSE
            RAISE exit_procedure_;
         END IF;
      END IF;

      IF stock_record_tab_(i).location_type NOT IN (Inventory_Location_Type_API.DB_PICKING, 
                                                    Inventory_Location_Type_API.DB_FLOOR_STOCK,
                                                    Inventory_Location_Type_API.DB_PRODUCTION_LINE,
                                                    Inventory_Location_Type_API.DB_ARRIVAL,
                                                    Inventory_Location_Type_API.DB_QUALITY_ASSURANCE) THEN
         IF (throw_error_on_exception_) THEN
            Inventory_Part_In_Stock_API.Raise_Putaway_Locat_Type_Error(stock_record_tab_(i).location_type);
         ELSE
            RAISE exit_procedure_;
         END IF;
      END IF;

      IF (stock_record_tab_(i).freeze_flag = Inventory_Part_Freeze_Code_API.DB_FROZEN_FOR_COUNTING) THEN
         IF (throw_error_on_exception_) THEN
            Inventory_Part_In_Stock_API.Raise_Freeze_Flag_Error(stock_record_tab_(i).part_no, stock_record_tab_(i).location_no);
         ELSE
            RAISE exit_procedure_;
         END IF;
      END IF;

      Part_Availability_Control_API.Check_Part_Movement_Allowed(stock_record_tab_(i).part_no, stock_record_tab_(i).availability_control_id);

      IF stock_record_tab_(i).rotable_part_pool_id IS NOT NULL THEN
         IF (throw_error_on_exception_) THEN
            Inventory_Part_In_Stock_API.Raise_Rotable_Pool_Move_Error(stock_record_tab_(i).part_no, stock_record_tab_(i).rotable_part_pool_id);
         ELSE
            RAISE exit_procedure_;
         END IF;
      END IF;

      IF (stock_record_tab_(i).contract != handling_unit_rec_.contract) THEN
         -- This should always raise exception because it is due to database inconsistency. Should not happen unless there is a bug.
         Error_SYS.Record_General(lu_name_, 'PUTAWAYHUCONTRACT: Mismatch between stock record site :P1 and handling unit site :P2', stock_record_tab_(i).contract, handling_unit_rec_.contract);
      END IF;

      IF (stock_record_tab_(i).location_no != handling_unit_rec_.location_no) THEN
         -- This should always raise exception because it is due to database inconsistency. Should not happen unless there is a bug.
         Error_SYS.Record_General(lu_name_, 'PUTAWAYHULOCAT: Mismatch between stock record location :P1 and handling unit location :P2', stock_record_tab_(i).location_no, handling_unit_rec_.location_no);
      END IF;

      IF ((stock_record_tab_(i).part_no != previous_part_no_) AND (NOT reuse_putaway_prerequisites_)) THEN
         -- If the call to this method is done from Putaway_Handling_Units and if then the current handling unit to be putaway can use the same prerequisites as
         -- the handling unit that was putaway in the previous iteration, then we don't need to find the putaway zones, putaway bins, temperature or 
         -- humidity intervals again, because we already know them from the previous iteration. When stating that a Handling Unit can use the same prerequisites as
         -- another one in this context, then we mean that it is the same Handling Unit Type on the same Site, containing the same combination of
         -- Part_No, Lot_Batch_No, Condition Code.
         --
         -- Find all putaway zones for this part number
         putaway_zone_tab_ := Get_Putaway_Zones___(putaway_session_id_, stock_record_tab_(i).contract, stock_record_tab_(i).part_no);
         -- Find all putaway bins for each putaway zone and store it temporarily
         IF (putaway_zone_tab_.COUNT > 0) THEN
            FOR j IN putaway_zone_tab_.FIRST..putaway_zone_tab_.LAST LOOP

               Load_Putaway_Bins_Into_Tmp___(putaway_session_id_,
                                             stock_record_tab_(i).contract,
                                             stock_record_tab_(i).part_no,
                                             putaway_zone_tab_(j).storage_zone_id,
                                             putaway_zone_tab_(j).source_db);
            END LOOP;
         END IF;

         handling_unit_min_temperature_ := GREATEST(NVL(handling_unit_min_temperature_, negative_infinity_),
                                                    NVL(Inventory_Part_API.Get_Min_Storage_Temperature(stock_record_tab_(i).contract,
                                                                                                       stock_record_tab_(i).part_no), negative_infinity_));
         handling_unit_max_temperature_ := LEAST   (NVL(handling_unit_max_temperature_, positive_infinity_),
                                                    NVL(Inventory_Part_API.Get_Max_Storage_Temperature(stock_record_tab_(i).contract,
                                                                                                       stock_record_tab_(i).part_no), positive_infinity_));
         handling_unit_min_humidity_    := GREATEST(NVL(handling_unit_min_humidity_, absolute_min_humidity_),
                                                    NVL(Inventory_Part_API.Get_Min_Storage_Humidity(stock_record_tab_(i).contract,
                                                                                                    stock_record_tab_(i).part_no), absolute_min_humidity_));
         handling_unit_max_humidity_    := LEAST   (NVL(handling_unit_max_humidity_, absolute_max_humidity_),
                                                    NVL(Inventory_Part_API.Get_Max_Storage_Humidity(stock_record_tab_(i).contract,
                                                                                                    stock_record_tab_(i).part_no), absolute_max_humidity_));
         previous_part_no_ := stock_record_tab_(i).part_no;
         part_counter_     := part_counter_ + 1;
      END IF;
   END LOOP;

   IF (NOT reuse_putaway_prerequisites_) THEN
      -- Now we need to indicate in the temporary table which bins that are common for all parts in the Handling Unit. Only those bins should be considered
      -- as potential destinations in the Putaway___ method.
      Mark_Common_Putaway_Bins___(putaway_session_id_, part_counter_);
   END IF;

   IF ((local_hu_height_requirement_ IS NULL) OR
       (local_hu_width_requirement_  IS NULL) OR
       (local_hu_depth_requirement_  IS NULL) OR
       (local_hu_gross_weight_       IS NULL) OR
       (local_hu_volume_             IS NULL)) THEN
      -- If height, width, depth, weight and volume is not being passed in from Putaway_Handling_Units then we need to fetch this info.
      -- This information is being passed in from Putaway_Handling_Units even when the HU's are different because that info is used for sorting the HU's.
      Get_Hu_Storage_Capacity_Req___(local_hu_height_requirement_,
                                     local_hu_width_requirement_,
                                     local_hu_depth_requirement_,
                                     local_hu_gross_weight_,
                                     local_hu_volume_,
                                     handling_unit_rec_);
   END IF;

   IF (NOT reuse_putaway_prerequisites_) THEN
      -- If the call to this method is done from Putaway_Handling_Units and if then the current handling unit to be putaway can use the same prerequisites
      -- as the handling unit that was putaway in the previous iteration, then we don't need to find the common_putaway_bin_tab_ or capability requirements
      -- because we already know them from the previous iteration. 
      Set_Bin_Hu_Type_Capacity____(putaway_session_id_, handling_unit_rec_.contract, handling_unit_rec_.handling_unit_type_id);

      OPEN  get_capability_requirements;
      FETCH get_capability_requirements BULK COLLECT INTO handl_unit_capability_req_tab_;
      CLOSE get_capability_requirements;
   END IF;
   
   LOOP
      @ApproveTransactionStatement(2016-10-26,lepese)
      SAVEPOINT Putaway_Handling_Unit;

      Putaway_Handl_Unit_Content___(handling_unit_putaway_success_,
                                    putaway_failure_is_final_,
                                    selected_putaway_location_no_,
                                    stock_record_tab_,
                                    local_hu_gross_weight_,
                                    local_hu_volume_,
                                    local_hu_height_requirement_,
                                    local_hu_width_requirement_,
                                    local_hu_depth_requirement_,
                                    handling_unit_min_temperature_,
                                    handling_unit_max_temperature_,
                                    handling_unit_min_humidity_,
                                    handling_unit_max_humidity_,
                                    handl_unit_capability_req_tab_,
                                    calling_process_,
                                    putaway_session_id_);
      -- If Putaway_Handl_Unit_Content___ managed to putaway all stock records without failure then we are done.
      EXIT WHEN handling_unit_putaway_success_;
      @ApproveTransactionStatement(2016-10-26,lepese)
      ROLLBACK TO Putaway_Handling_Unit;
      -- If failure is final then exit after having done rollback.
      Revert_Capacity_Consumption___(putaway_session_id_, handling_unit_rec_.contract, selected_putaway_location_no_);
      Revert_Part_Bin_Usage___      (putaway_session_id_, handling_unit_rec_.contract, selected_putaway_location_no_);
      EXIT WHEN putaway_failure_is_final_;
      -- Remove the location number that failed from the work-in-progress bin list. Then we make a new attempt.
      Mark_Rejected_Putaway_Bin___(putaway_session_id_, handling_unit_rec_.contract, selected_putaway_location_no_);
      selected_putaway_location_no_ := NULL;
   END LOOP;

   IF (handling_unit_putaway_success_) THEN
      -- We have managed to find a destination for the Handling Unit so we need to reduce the Handling Unit Type Capacity for the seleced location.
      Reduce_Bin_Hu_Type_Capacit____(putaway_session_id_, handling_unit_rec_.contract, selected_putaway_location_no_);
      Confirm_Capacity_Consumptio___(putaway_session_id_, handling_unit_rec_.contract, selected_putaway_location_no_);
      Confirm_Part_Bin_Usage___     (putaway_session_id_, handling_unit_rec_.contract, selected_putaway_location_no_);
   END IF;

   IF (putaway_failure_is_final_) THEN
      Add_No_Location_Found_Info___(handling_unit_id_ => handling_unit_rec_.handling_unit_id, from_location_no_ => handling_unit_rec_.location_no);
   END IF;
   -- Assigning stock_record_tab_ to previous_hu_stock_record_tab_ so that it can be passed in again in the next call and then serve as input
   -- to method Stock_Records_Are_Comparabl___.
   previous_hu_stock_record_tab_ := stock_record_tab_;

EXCEPTION
   WHEN exit_procedure_ THEN
      -- Deleting the content of previous_hu_stock_record_tab_ in this situation secures that we will have a clean start for the next Handling Unit if
      -- this method is being called from Putaway_Handling_Units. It will lead to that Stock_Records_Are_Comparabl___ returns FALSE which in turn
      -- secures that we retrieve a new putaway_session_id_ and also keep variable reuse_putaway_prerequisites_ as FALSE.
      previous_hu_stock_record_tab_.DELETE;
END Putaway_Handling_Unit___;


PROCEDURE Get_Handling_Unit_Char_Tab___ (
   handling_unit_char_tab_   OUT Handl_Unit_Characteristics_Tab,
   handling_unit_public_tab_ OUT Handling_Unit_API.Public_Tab,
   handling_unit_id_tab_     IN  Handling_Unit_API.Handling_Unit_Id_Tab )
IS
   handling_unit_public_rec_ Handling_Unit_API.Public_Rec;
   height_requirement_       NUMBER;
   width_requirement_        NUMBER;
   depth_requirement_        NUMBER;
   operative_gross_weight_   NUMBER;
   operative_volume_         NUMBER;

   CURSOR get_handling_units IS
      SELECT * FROM handl_unit_characteristics_tmp
      ORDER BY contract,
               handling_unit_type_id,
               operative_volume,
               operative_gross_weight,
               height_requirement,
               width_requirement,
               depth_requirement,
               handling_unit_id;
BEGIN
   DELETE FROM handl_unit_characteristics_tmp;

   IF (handling_unit_id_tab_.COUNT > 0 ) THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP

         Handling_Unit_API.Exist(handling_unit_id_tab_(i).handling_unit_id);
         -- Lock the structure so that no updates of parent_handling_unit_id, contract, location_no, shipment_id, source_ref or any other thing can happen
         -- while we evaluate this structure for Putaway and try to find a location that fits.
         Handling_Unit_API.Lock_Node_And_Descendants(handling_unit_id_tab_(i).handling_unit_id);

         handling_unit_public_rec_ := Handling_Unit_API.Get(handling_unit_id_tab_(i).handling_unit_id);
         handling_unit_public_tab_(handling_unit_id_tab_(i).handling_unit_id) := handling_unit_public_rec_;      

         Get_Hu_Storage_Capacity_Req___(height_requirement_,
                                        width_requirement_,
                                        depth_requirement_,
                                        operative_gross_weight_,
                                        operative_volume_,
                                        handling_unit_public_rec_);

         INSERT INTO handl_unit_characteristics_tmp
            (contract,
             handling_unit_id,
             handling_unit_type_id,
             height_requirement,
             width_requirement,
             depth_requirement,
             operative_gross_weight,
             operative_volume)
         VALUES
            (handling_unit_public_rec_.contract,
             handling_unit_public_rec_.handling_unit_id,
             handling_unit_public_rec_.handling_unit_type_id,
             height_requirement_,    
             width_requirement_,     
             depth_requirement_,     
             operative_gross_weight_,
             operative_volume_);    
      END LOOP;

      OPEN  get_handling_units;
      FETCH get_handling_units BULK COLLECT INTO handling_unit_char_tab_;
      CLOSE get_handling_units;
   END IF;
END Get_Handling_Unit_Char_Tab___;


PROCEDURE Get_Hu_Storage_Capacity_Req___ (
   height_requirement_     OUT NUMBER,
   width_requirement_      OUT NUMBER,
   depth_requirement_      OUT NUMBER,
   operative_gross_weight_ OUT NUMBER,
   operative_volume_       OUT NUMBER,
   handling_unit_rec_      IN  Handling_Unit_API.Public_Rec)
IS
   company_uom_for_length_ VARCHAR2(10);
BEGIN
   company_uom_for_length_ := Company_Invent_Info_API.Get_Uom_For_Length(Site_API.Get_Company(handling_unit_rec_.contract));
   operative_volume_       := Handling_Unit_API.Get_Operative_Volume(handling_unit_rec_.handling_unit_id,
                                                                     Handling_Unit_API.Get_Uom_For_Volume(handling_unit_rec_.handling_unit_id));
   operative_gross_weight_ := Handling_Unit_API.Get_Operative_Gross_Weight(handling_unit_id_     => handling_unit_rec_.handling_unit_id,
                                                                           uom_for_weight_       => Handling_Unit_API.Get_Uom_For_Weight(handling_unit_rec_.handling_unit_id),
                                                                           apply_freight_factor_ => Fnd_Boolean_Api.DB_FALSE);
   height_requirement_     := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_rec_.height,
                                                                           handling_unit_rec_.uom_for_length,
                                                                           company_uom_for_length_),positive_infinity_);
   width_requirement_      := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_rec_.width,
                                                                           handling_unit_rec_.uom_for_length,
                                                                           company_uom_for_length_), positive_infinity_);
   depth_requirement_      := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_rec_.depth,
                                                                           handling_unit_rec_.uom_for_length,
                                                                           company_uom_for_length_), positive_infinity_);
END Get_Hu_Storage_Capacity_Req___;


FUNCTION Get_Putaway_Zones___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2 ) RETURN Invent_Part_Putaway_Zone_API.Putaway_Zone_Tab
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   putaway_zone_tab_ Invent_Part_Putaway_Zone_API.Putaway_Zone_Tab;

   CURSOR get_putaway_zones IS
      SELECT sequence_no, source_db, max_bins_per_part, ranking, storage_zone_id
        FROM invent_part_putaway_zone_tmp
       WHERE putaway_session_id = putaway_session_id_
         AND contract           = contract_
         AND part_no            = part_no_
    ORDER BY ranking, NVL(max_bins_per_part, positive_infinity_);
BEGIN
   OPEN  get_putaway_zones;
   FETCH get_putaway_zones bulk collect INTO putaway_zone_tab_;
   CLOSE get_putaway_zones;

   IF (putaway_zone_tab_.COUNT = 0) THEN
      putaway_zone_tab_ := Invent_Part_Putaway_Zone_API.Get_Putaway_Zones(contract_, part_no_);

      IF (putaway_zone_tab_.COUNT > 0) THEN
         FORALL i IN putaway_zone_tab_.FIRST..putaway_zone_tab_.LAST
            INSERT INTO invent_part_putaway_zone_tmp (
               putaway_session_id,
               contract,
               part_no,
               sequence_no,
               source_db,
               max_bins_per_part,
               ranking,
               storage_zone_id,
               date_created )
            VALUES (
               putaway_session_id_,
               contract_,
               part_no_,
               putaway_zone_tab_(i).sequence_no,
               putaway_zone_tab_(i).source_db,
               putaway_zone_tab_(i).max_bins_per_part,
               putaway_zone_tab_(i).ranking,
               putaway_zone_tab_(i).storage_zone_id,
               SYSDATE );
      END IF;
   END IF;
   
   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;

   RETURN (putaway_zone_tab_);
END Get_Putaway_Zones___;


PROCEDURE Load_Putaway_Bins_Into_Tmp___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   storage_zone_id_    IN VARCHAR2,
   source_db_          IN VARCHAR2 )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   sql_where_expression_ VARCHAR2(28000);
   putaway_bin_tab_      Warehouse_Bay_Bin_API.Putaway_Bin_Tab;
   dummy_                NUMBER;
   tmp_is_loaded_        BOOLEAN := FALSE;

   CURSOR check_exist IS
      SELECT 1
        FROM putaway_zone_bin_tmp
       WHERE putaway_session_id = putaway_session_id_
         AND contract           = contract_
         AND part_no            = part_no_
         AND storage_zone_id    = storage_zone_id_;
BEGIN
   OPEN  check_exist;
   FETCH check_exist INTO dummy_;
   IF check_exist%FOUND THEN
      tmp_is_loaded_ := TRUE;
   END IF; 
   CLOSE check_exist;

   IF (NOT tmp_is_loaded_) THEN
      sql_where_expression_ := Invent_Part_Putaway_Zone_API.Get_Sql_Where_Expression(contract_, storage_zone_id_, source_db_);
      putaway_bin_tab_ := Warehouse_Bay_Bin_API.Get_Putaway_Bins(contract_, sql_where_expression_);

         IF (putaway_bin_tab_.COUNT > 0) THEN
            FOR i IN putaway_bin_tab_.FIRST..putaway_bin_tab_.LAST LOOP
               BEGIN
                  INSERT INTO putaway_zone_bin_tmp (
                      putaway_session_id,
                      contract,
                      part_no,
                      storage_zone_id,
                      rejected,
                      in_use,
                      in_preliminary_use,
                      warehouse_id,
                      bay_id,
                      tier_id,
                      row_id,
                      bin_id,
                      location_no,
                      location_group,
                      warehouse_route_order,
                      bay_route_order,
                      row_route_order,
                      tier_route_order,
                      bin_route_order,
                      handling_unit_type_capacity,
                      sizes_and_conditions_approved,
                      capabilities_approved,
                      date_created )
                  VALUES (
                      putaway_session_id_,
                      contract_,
                      part_no_,
                      storage_zone_id_,     
                      Fnd_Boolean_API.DB_FALSE,
                      not_investigated_,
                      Fnd_Boolean_API.DB_FALSE,
                      putaway_bin_tab_(i).warehouse_id,        
                      putaway_bin_tab_(i).bay_id,              
                      putaway_bin_tab_(i).tier_id,             
                      putaway_bin_tab_(i).row_id,                
                      putaway_bin_tab_(i).bin_id,               
                      putaway_bin_tab_(i).location_no,          
                      putaway_bin_tab_(i).location_group,       
                      putaway_bin_tab_(i).warehouse_route_order,
                      putaway_bin_tab_(i).bay_route_order,      
                      putaway_bin_tab_(i).row_route_order,      
                      putaway_bin_tab_(i).tier_route_order,     
                      putaway_bin_tab_(i).bin_route_order,
                      0,
                      Fnd_Boolean_API.DB_FALSE,
                      Fnd_Boolean_API.DB_FALSE,
                      SYSDATE );
               EXCEPTION
                  -- We do have a unique index on contract, location_no, part_no and since we are inserting records based on a sorted putaway_zone_tab
                  -- this makes sure that the location for the part is only inserted in context of its best zone, since the sorting is based on
                  -- zone ranking plus max number of bins.
                  WHEN dup_val_on_index THEN
                     NULL;
               END;
            END LOOP;
         END IF;
   END IF;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
END Load_Putaway_Bins_Into_Tmp___;

                                                                                
PROCEDURE Load_Single_Bin_Into_Tmp___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   storage_zone_id_    IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2,
   tier_id_            IN VARCHAR2,
   row_id_             IN VARCHAR2,
   bin_id_             IN VARCHAR2,
   location_no_        IN VARCHAR2 )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;

   warehouse_route_order_ warehouse_bay_bin_tab.warehouse_id%TYPE;
   bay_route_order_       warehouse_bay_bin_tab.bay_id%TYPE;
   row_route_order_       warehouse_bay_bin_tab.row_id%TYPE;
   tier_route_order_      warehouse_bay_bin_tab.tier_id%TYPE;
   bin_route_order_       warehouse_bay_bin_tab.route_order%TYPE;
   location_group_        warehouse_bay_bin_tab.location_group%TYPE;

BEGIN
   location_group_ := Warehouse_Bay_Bin_API.Get_Location_Group(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   Warehouse_Bay_Bin_API.Get_Route_Order_Strings(warehouse_route_order_,
                                                 bay_route_order_,
                                                 row_route_order_,
                                                 tier_route_order_,
                                                 bin_route_order_,
                                                 contract_,
                                                 location_no_);
   BEGIN
      INSERT INTO putaway_zone_bin_tmp (
          putaway_session_id,
          contract,
          part_no,
          storage_zone_id,
          rejected,
          in_use,
          in_preliminary_use,
          warehouse_id,
          bay_id,
          tier_id,
          row_id,
          bin_id,
          location_no,
          location_group,
          warehouse_route_order,
          bay_route_order,
          row_route_order,
          tier_route_order,
          bin_route_order,
          handling_unit_type_capacity,
          sizes_and_conditions_approved,
          capabilities_approved,
          date_created )
      VALUES (
          putaway_session_id_,
          contract_,
          part_no_,
          storage_zone_id_,     
          Fnd_Boolean_API.DB_FALSE,
          not_investigated_,
          Fnd_Boolean_API.DB_FALSE,
          warehouse_id_,
          bay_id_,
          tier_id_,
          row_id_,
          bin_id_,
          location_no_,
          location_group_,
          warehouse_route_order_,
          bay_route_order_,
          row_route_order_,
          tier_route_order_,
          bin_route_order_,
          0,
          Fnd_Boolean_API.DB_FALSE,
          Fnd_Boolean_API.DB_FALSE,
          SYSDATE );
   EXCEPTION
      -- We do have a unique index on contract, location_no, part_no and since we are inserting records based on a sorted putaway_zone_tab
      -- this makes sure that the location for the part is only inserted in context of its best zone, since the sorting is based on
      -- zone ranking plus max number of bins.
      WHEN dup_val_on_index THEN
         NULL;
   END;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
END Load_Single_Bin_Into_Tmp___;

                                                                                
PROCEDURE Mark_Common_Putaway_Bins___ (
   putaway_session_id_  IN NUMBER,
   parts_in_hu_counter_ IN INTEGER )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;

   CURSOR get_part_bin_usage_counter IS
      SELECT contract, location_no, COUNT (DISTINCT part_no) bin_usage_counter
        FROM putaway_zone_bin_tmp
       WHERE putaway_session_id = putaway_session_id_
    GROUP BY contract, location_no;
BEGIN
   FOR rec_ IN get_part_bin_usage_counter LOOP
      IF rec_.bin_usage_counter != parts_in_hu_counter_ THEN 
         UPDATE putaway_zone_bin_tmp
            SET rejected = Fnd_Boolean_API.DB_TRUE
          WHERE putaway_session_id = putaway_session_id_
            AND contract           = rec_.contract
            AND location_no        = rec_.location_no;
      END IF;      
   END LOOP;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
END Mark_Common_Putaway_Bins___;


PROCEDURE Mark_Rejected_Putaway_Bin___ (
   putaway_session_id_  IN NUMBER,
   contract_            IN VARCHAR2,
   location_no_         IN VARCHAR2 )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   UPDATE putaway_zone_bin_tmp
      SET rejected = Fnd_Boolean_API.DB_TRUE
    WHERE putaway_session_id = putaway_session_id_
      AND contract           = contract_
      AND location_no        = location_no_;

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
END Mark_Rejected_Putaway_Bin___;


FUNCTION Get_Next_Putaway_Session_Id___ RETURN NUMBER
IS
   putaway_session_id_ NUMBER;
BEGIN
   SELECT putaway_session_id_seq.NEXTVAL INTO putaway_session_id_ FROM dual;
   RETURN (putaway_session_id_);
END Get_Next_Putaway_Session_Id___;


PROCEDURE Revert_Capacity_Consumption___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   location_no_        IN VARCHAR2)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;

   warehouse_id_ warehouse_bay_bin_tab.warehouse_id%TYPE;
   bay_id_       warehouse_bay_bin_tab.bay_id%TYPE;
   row_id_       warehouse_bay_bin_tab.row_id%TYPE;
   tier_id_      warehouse_bay_bin_tab.tier_id%TYPE;
   bin_id_       warehouse_bay_bin_tab.bin_id%TYPE;
BEGIN
   Warehouse_Bay_Bin_API.Get_Location_Strings(warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_, contract_, location_no_);

   Revert_Prel_Volume_Cap_Cons___(putaway_session_id_, contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   Revert_Prel_Bin_Carry_Cons___ (putaway_session_id_, contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   Revert_Prel_Tier_Carry_Cons___(putaway_session_id_, contract_, warehouse_id_, bay_id_, tier_id_);   
   Revert_Prel_Row_Carry_Cons___ (putaway_session_id_, contract_, warehouse_id_, bay_id_, row_id_);  
   Revert_Prel_Bay_Carry_Cons___ (putaway_session_id_, contract_, warehouse_id_, bay_id_);

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
END Revert_Capacity_Consumption___;


PROCEDURE Revert_Prel_Bin_Carry_Cons___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2,
   tier_id_            IN VARCHAR2,
   row_id_             IN VARCHAR2,
   bin_id_             IN VARCHAR2 )
IS
BEGIN
   UPDATE free_bin_carrying_capacity_tmp
      SET preliminary_consumption = 0
    WHERE putaway_session_id      = putaway_session_id_ 
      AND contract                = contract_
      AND warehouse_id            = warehouse_id_
      AND bay_id                  = bay_id_
      AND tier_id                 = tier_id_
      AND row_id                  = row_id_
      AND bin_id                  = bin_id_;
END Revert_Prel_Bin_Carry_Cons___;


PROCEDURE Revert_Prel_Tier_Carry_Cons___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2,
   tier_id_            IN VARCHAR2 )
IS
BEGIN
   UPDATE free_tier_carrying_cap_tmp
      SET preliminary_consumption = 0
    WHERE putaway_session_id      = putaway_session_id_ 
      AND contract                = contract_
      AND warehouse_id            = warehouse_id_
      AND bay_id                  = bay_id_
      AND tier_id                 = tier_id_;
END Revert_Prel_Tier_Carry_Cons___;


PROCEDURE Revert_Prel_Row_Carry_Cons___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2,
   row_id_            IN VARCHAR2 )
IS
BEGIN
   UPDATE free_row_carrying_cap_tmp
      SET preliminary_consumption = 0
    WHERE putaway_session_id      = putaway_session_id_ 
      AND contract                = contract_
      AND warehouse_id            = warehouse_id_
      AND bay_id                  = bay_id_
      AND row_id                  = row_id_;
END Revert_Prel_Row_Carry_Cons___;


PROCEDURE Revert_Prel_Bay_Carry_Cons___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2 )
IS
BEGIN
   UPDATE free_bay_carrying_cap_tmp
      SET preliminary_consumption = 0
    WHERE putaway_session_id      = putaway_session_id_ 
      AND contract                = contract_
      AND warehouse_id            = warehouse_id_
      AND bay_id                  = bay_id_;
END Revert_Prel_Bay_Carry_Cons___;


PROCEDURE Revert_Prel_Volume_Cap_Cons___ (
   putaway_session_id_         IN NUMBER,
   contract_                   IN VARCHAR2,
   warehouse_id_               IN VARCHAR2,
   bay_id_                     IN VARCHAR2,
   tier_id_                    IN VARCHAR2,
   row_id_                     IN VARCHAR2,
   bin_id_                     IN VARCHAR2 )
IS
BEGIN
   UPDATE free_bin_volume_capacity_tmp
      SET preliminary_consumption = 0
    WHERE putaway_session_id   = putaway_session_id_ 
      AND contract             = contract_
      AND warehouse_id         = warehouse_id_
      AND bay_id               = bay_id_
      AND tier_id              = tier_id_
      AND row_id               = row_id_
      AND bin_id               = bin_id_;
END Revert_Prel_Volume_Cap_Cons___;


PROCEDURE Insert_Free_Volume_Capacity___ (
   putaway_session_id_       IN NUMBER,
   contract_                 IN VARCHAR2,
   warehouse_id_             IN VARCHAR2,
   bay_id_                   IN VARCHAR2,
   tier_id_                  IN VARCHAR2,
   row_id_                   IN VARCHAR2,
   bin_id_                   IN VARCHAR2,
   free_bin_volume_capacity_ IN NUMBER )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   INSERT INTO free_bin_volume_capacity_tmp
      (putaway_session_id,
       contract,
       warehouse_id,
       bay_id,
       tier_id,
       row_id,
       bin_id,
       free_volume_capacity,
       preliminary_consumption,
       date_created)
   VALUES
      (putaway_session_id_,
       contract_,
       warehouse_id_,
       bay_id_,
       tier_id_,
       row_id_,
       bin_id_,
       free_bin_volume_capacity_,
       0,
       SYSDATE);

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;

END Insert_Free_Volume_Capacity___;


PROCEDURE Confirm_Capacity_Consumptio___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   location_no_        IN VARCHAR2)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;

   warehouse_id_ warehouse_bay_bin_tab.warehouse_id%TYPE;
   bay_id_       warehouse_bay_bin_tab.bay_id%TYPE;
   row_id_       warehouse_bay_bin_tab.row_id%TYPE;
   tier_id_      warehouse_bay_bin_tab.tier_id%TYPE;
   bin_id_       warehouse_bay_bin_tab.bin_id%TYPE;
BEGIN
   Warehouse_Bay_Bin_API.Get_Location_Strings(warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_, contract_, location_no_);

   Confirm_Volume_Cap_Consumpt___(putaway_session_id_, contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   Confirm_Bin_Carry_Consumpt___ (putaway_session_id_, contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
   Confirm_Tier_Carry_Consumpt___(putaway_session_id_, contract_, warehouse_id_, bay_id_, tier_id_);   
   Confirm_Row_Carry_Consumpt___ (putaway_session_id_, contract_, warehouse_id_, bay_id_, row_id_);  
   Confirm_Bay_Carry_Consumpt___ (putaway_session_id_, contract_, warehouse_id_, bay_id_);

   @ApproveTransactionStatement(2021-12-14,LEPESE)
   COMMIT;
END Confirm_Capacity_Consumptio___;


PROCEDURE Confirm_Bin_Carry_Consumpt___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2,
   tier_id_            IN VARCHAR2,
   row_id_             IN VARCHAR2,
   bin_id_             IN VARCHAR2 )
IS
BEGIN
   UPDATE free_bin_carrying_capacity_tmp
      SET free_carrying_capacity  = free_carrying_capacity - preliminary_consumption,
          preliminary_consumption = 0
    WHERE putaway_session_id      = putaway_session_id_ 
      AND contract                = contract_
      AND warehouse_id            = warehouse_id_
      AND bay_id                  = bay_id_
      AND tier_id                 = tier_id_
      AND row_id                  = row_id_
      AND bin_id                  = bin_id_
      AND free_carrying_capacity  < positive_infinity_
      AND preliminary_consumption > 0;
END Confirm_Bin_Carry_Consumpt___;


PROCEDURE Confirm_Tier_Carry_Consumpt___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2,
   tier_id_            IN VARCHAR2 )
IS
BEGIN
   UPDATE free_tier_carrying_cap_tmp
      SET free_carrying_capacity  = free_carrying_capacity - preliminary_consumption,
          preliminary_consumption = 0
    WHERE putaway_session_id      = putaway_session_id_ 
      AND contract                = contract_
      AND warehouse_id            = warehouse_id_
      AND bay_id                  = bay_id_
      AND tier_id                 = tier_id_
      AND free_carrying_capacity  < positive_infinity_
      AND preliminary_consumption > 0;
END Confirm_Tier_Carry_Consumpt___;


PROCEDURE Confirm_Row_Carry_Consumpt___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2,
   row_id_            IN VARCHAR2 )
IS
BEGIN
   UPDATE free_row_carrying_cap_tmp
      SET free_carrying_capacity  = free_carrying_capacity - preliminary_consumption,
          preliminary_consumption = 0
    WHERE putaway_session_id      = putaway_session_id_ 
      AND contract                = contract_
      AND warehouse_id            = warehouse_id_
      AND bay_id                  = bay_id_
      AND row_id                  = row_id_
      AND free_carrying_capacity  < positive_infinity_
      AND preliminary_consumption > 0;
END Confirm_Row_Carry_Consumpt___;


PROCEDURE Confirm_Bay_Carry_Consumpt___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2 )
IS
BEGIN
   UPDATE free_bay_carrying_cap_tmp
      SET free_carrying_capacity  = free_carrying_capacity - preliminary_consumption,
          preliminary_consumption = 0
    WHERE putaway_session_id      = putaway_session_id_ 
      AND contract                = contract_
      AND warehouse_id            = warehouse_id_
      AND bay_id                  = bay_id_
      AND free_carrying_capacity  < positive_infinity_
      AND preliminary_consumption > 0;
END Confirm_Bay_Carry_Consumpt___;


PROCEDURE Confirm_Volume_Cap_Consumpt___ (
   putaway_session_id_         IN NUMBER,
   contract_                   IN VARCHAR2,
   warehouse_id_               IN VARCHAR2,
   bay_id_                     IN VARCHAR2,
   tier_id_                    IN VARCHAR2,
   row_id_                     IN VARCHAR2,
   bin_id_                     IN VARCHAR2 )
IS
BEGIN
   UPDATE free_bin_volume_capacity_tmp
      SET free_volume_capacity    = free_volume_capacity - preliminary_consumption,
          preliminary_consumption = 0
    WHERE putaway_session_id      = putaway_session_id_ 
      AND contract                = contract_
      AND warehouse_id            = warehouse_id_
      AND bay_id                  = bay_id_
      AND tier_id                 = tier_id_
      AND row_id                  = row_id_
      AND bin_id                  = bin_id_
      AND free_volume_capacity    < positive_infinity_
      AND preliminary_consumption > 0;
END Confirm_Volume_Cap_Consumpt___;


FUNCTION Get_Capab_Approvd_Bin_Count___ (
   putaway_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   storage_zone_id_    IN VARCHAR2 ) RETURN number
IS
   capability_approved_bin_count_ NUMBER;

   CURSOR get_capabil_approved_bin_count IS
      SELECT count(*)
        FROM putaway_zone_bin_tmp
       WHERE putaway_session_id    = putaway_session_id_
         AND contract              = contract_
         AND part_no               = part_no_
         AND storage_zone_id       = storage_zone_id_
         AND capabilities_approved = Fnd_Boolean_API.DB_TRUE;
BEGIN
   OPEN  get_capabil_approved_bin_count;
   FETCH get_capabil_approved_bin_count INTO capability_approved_bin_count_;
   CLOSE get_capabil_approved_bin_count;

   RETURN (capability_approved_bin_count_);
END Get_Capab_Approvd_Bin_Count___;


FUNCTION Stock_Records_Are_Comparabl___ (
   current_handling_unit_id_     IN NUMBER,
   previous_handling_unit_id_    IN NUMBER,
   current_hu_stock_record_tab_  IN Stock_Record_Tab,
   previous_hu_stock_record_tab_ IN Stock_Record_Tab ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   
   CURSOR check_part_in_current_only IS
      SELECT 1
        FROM handl_unit_part_content_tmp a
       WHERE a.handling_unit_id = current_handling_unit_id_
         AND NOT EXISTS (SELECT 1
                           FROM handl_unit_part_content_tmp b
                          WHERE b.handling_unit_id = previous_handling_unit_id_
                            AND b.part_no          = a.part_no);

   CURSOR check_part_in_previous_only IS
      SELECT 1
        FROM handl_unit_part_content_tmp a
       WHERE a.handling_unit_id = previous_handling_unit_id_
         AND NOT EXISTS (SELECT 1
                           FROM handl_unit_part_content_tmp b
                          WHERE b.handling_unit_id = current_handling_unit_id_
                            AND b.part_no          = a.part_no);

   CURSOR check_lot_batch_in_previo_only IS
      SELECT 1
        FROM handl_unit_part_content_tmp a
       WHERE a.handling_unit_id = previous_handling_unit_id_
         AND NOT EXISTS (SELECT 1
                           FROM handl_unit_part_content_tmp b
                          WHERE b.handling_unit_id = current_handling_unit_id_
                            AND b.lot_batch_no     = a.lot_batch_no);

   CURSOR check_condition_in_previo_only IS
      SELECT 1
        FROM handl_unit_part_content_tmp a
       WHERE a.handling_unit_id = previous_handling_unit_id_
         AND NOT EXISTS (SELECT 1
                           FROM handl_unit_part_content_tmp b
                          WHERE b.handling_unit_id = current_handling_unit_id_
                            AND b.condition_code   = a.condition_code);
BEGIN
   DELETE FROM handl_unit_part_content_tmp;

   FOR i IN previous_hu_stock_record_tab_.FIRST..previous_hu_stock_record_tab_.LAST LOOP
      BEGIN
         INSERT INTO handl_unit_part_content_tmp ( handling_unit_id, 
                                                   part_no,
                                                   lot_batch_no,
                                                   condition_code )
         VALUES ( previous_handling_unit_id_,
                  previous_hu_stock_record_tab_(i).part_no,
                  previous_hu_stock_record_tab_(i).lot_batch_no,
                  previous_hu_stock_record_tab_(i).condition_code );
      EXCEPTION
         -- We do have a unique index on handling_unit_id, part_no, lot_batch_no and condition_code.
         -- This makes sure each combination of these values are only inserted once. 
         WHEN dup_val_on_index THEN
            NULL;
      END;
   END LOOP;


   FOR i IN current_hu_stock_record_tab_.FIRST..current_hu_stock_record_tab_.LAST LOOP
      BEGIN
         INSERT INTO handl_unit_part_content_tmp ( handling_unit_id,
                                                   part_no,
                                                   lot_batch_no,
                                                   condition_code )
         VALUES  ( current_handling_unit_id_,
                   current_hu_stock_record_tab_(i).part_no,
                   current_hu_stock_record_tab_(i).lot_batch_no,
                   current_hu_stock_record_tab_(i).condition_code );
      EXCEPTION
         -- We do have a unique index on handling_unit_id, part_no, lot_batch_no and condition_code.
         -- This makes sure each combination of these values are only inserted once. 
         WHEN dup_val_on_index THEN
            NULL;
      END;
   END LOOP;

   OPEN  check_part_in_current_only;
   FETCH check_part_in_current_only INTO dummy_;
   IF check_part_in_current_only%FOUND THEN
      -- If there is a part number in the current HU that was not in the previous HU then we need to investigate common zones and bins again
      -- and also evaluate things like capability requirements and condition requirements.
      RETURN (FALSE);
   END IF;
   CLOSE check_part_in_current_only;
   
   OPEN  check_part_in_previous_only;
   FETCH check_part_in_previous_only INTO dummy_;
   IF check_part_in_previous_only%FOUND THEN
      -- If there was a part number in the previous HU that is not in the current HU then we need to investigate common zones and bins again
      -- and also evaluate things like capability requirements and condition requirements. We could also have skipped locations because of
      -- Forbidden Mix of Parts that could be considered for this handling unit.
      RETURN (FALSE);
   END IF;
   CLOSE check_part_in_previous_only;
   
   OPEN  check_lot_batch_in_previo_only;
   FETCH check_lot_batch_in_previo_only INTO dummy_;
   IF check_lot_batch_in_previo_only%FOUND THEN
      -- If there was a Lot/Batch number in the previous HU that is not in the current HU then we need to start from the beginning again since we might
      -- have skipped locations because of Forbidden Mix of Lot/Batch that could be considered for this handling unit.
      RETURN (FALSE);
   END IF;
   CLOSE check_lot_batch_in_previo_only;
   
   OPEN  check_condition_in_previo_only;
   FETCH check_condition_in_previo_only INTO dummy_;
   IF check_condition_in_previo_only%FOUND THEN
      -- If there was a Condition Code in the previous HU that is not in the current HU then we need to start from the beginning again since we might
      -- have skipped locations because of Forbidden Mix of Condition Code that could be considered for this handling unit.
      RETURN (FALSE);
   END IF;
   CLOSE check_condition_in_previo_only;

   RETURN (TRUE);
END Stock_Records_Are_Comparabl___;


PROCEDURE Cleanup_Putaway_Session___ (
   putaway_session_id_   IN NUMBER,
   cleanup_old_sessions_ IN BOOLEAN DEFAULT FALSE )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   DELETE FROM free_bay_carrying_cap_tmp      WHERE putaway_session_id = putaway_session_id_;
   DELETE FROM free_bin_carrying_capacity_tmp WHERE putaway_session_id = putaway_session_id_;
   DELETE FROM free_bin_volume_capacity_tmp   WHERE putaway_session_id = putaway_session_id_;
   DELETE FROM free_row_carrying_cap_tmp      WHERE putaway_session_id = putaway_session_id_;
   DELETE FROM free_tier_carrying_cap_tmp     WHERE putaway_session_id = putaway_session_id_;
   DELETE FROM invent_part_putaway_zone_tmp   WHERE putaway_session_id = putaway_session_id_;
   DELETE FROM putaway_zone_bin_tmp           WHERE putaway_session_id = putaway_session_id_;

   IF (cleanup_old_sessions_) THEN
      DELETE FROM free_bay_carrying_cap_tmp      WHERE TRUNC(date_created) < TRUNC(SYSDATE) - 1;
      DELETE FROM free_bin_carrying_capacity_tmp WHERE TRUNC(date_created) < TRUNC(SYSDATE) - 1;
      DELETE FROM free_bin_volume_capacity_tmp   WHERE TRUNC(date_created) < TRUNC(SYSDATE) - 1;
      DELETE FROM free_row_carrying_cap_tmp      WHERE TRUNC(date_created) < TRUNC(SYSDATE) - 1;
      DELETE FROM free_tier_carrying_cap_tmp     WHERE TRUNC(date_created) < TRUNC(SYSDATE) - 1;
      DELETE FROM invent_part_putaway_zone_tmp   WHERE TRUNC(date_created) < TRUNC(SYSDATE) - 1;
      DELETE FROM putaway_zone_bin_tmp           WHERE TRUNC(date_created) < TRUNC(SYSDATE) - 1;
   END IF;

   @ApproveTransactionStatement(2021-12-29,LEPESE)
   COMMIT;
END Cleanup_Putaway_Session___;


PROCEDURE Approve_Handling_Unit___(
   handling_unit_id_ IN NUMBER,
   to_contract_      IN VARCHAR2,
   to_location_no_   IN VARCHAR2)
IS
BEGIN
   INSERT INTO approv_handl_unit_location_tmp(
      handling_unit_id,
      to_contract,
      to_location_no )
   VALUES(
      handling_unit_id_,
      to_contract_,
      to_location_no_);
EXCEPTION
   WHEN dup_val_on_index THEN
      NULL;
END Approve_Handling_Unit___;

FUNCTION Handling_Unit_Approved___(
   handling_unit_id_ IN NUMBER,
   to_contract_      IN VARCHAR2,
   to_location_no_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR get_approved_hu IS
      SELECT 1
      FROM approv_handl_unit_location_tmp
      WHERE handling_unit_id = handling_unit_id_
      AND   to_contract      = to_contract_
      AND   to_location_no   = to_location_no_;
   
   dummy_       NUMBER;
   approved_hu_ BOOLEAN := FALSE;
BEGIN
   OPEN get_approved_hu;
   FETCH get_approved_hu INTO dummy_;
   IF (get_approved_hu%FOUND) THEN
      approved_hu_ := TRUE;
   END IF;
   CLOSE get_approved_hu;
   
   RETURN approved_hu_;
END Handling_Unit_Approved___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Putaway_Part (
   info_               OUT VARCHAR2,
   contract_           IN  VARCHAR2,
   part_no_            IN  VARCHAR2,
   configuration_id_   IN  VARCHAR2,
   location_no_        IN  VARCHAR2,
   lot_batch_no_       IN  VARCHAR2,
   serial_no_          IN  VARCHAR2, 
   eng_chg_level_      IN  VARCHAR2,
   waiv_dev_rej_no_    IN  VARCHAR2,
   activity_seq_       IN  NUMBER,
   handling_unit_id_   IN  NUMBER,
   quantity_           IN  NUMBER,
   source_ref1_        IN  VARCHAR2,
   source_ref2_        IN  VARCHAR2,
   source_ref3_        IN  VARCHAR2,
   source_ref4_        IN  NUMBER,
   source_ref_type_db_ IN  VARCHAR2,
   calling_process_    IN  VARCHAR2 DEFAULT 'PUTAWAY',
   to_warehouse_id_    IN  VARCHAR2 DEFAULT NULL,
   to_bay_id_          IN  VARCHAR2 DEFAULT NULL )
IS
   serial_no_tab_           Part_Serial_Catalog_API.Serial_No_Tab;
   local_quantity_          NUMBER;
   dummy_number_            NUMBER;
   putaway_session_id_      NUMBER;
   dummy_boolean_           BOOLEAN;
   dummy_string_            VARCHAR2(50);
   condition_code_usage_db_ VARCHAR2(20);
   empty_cap_req_tab_       Storage_Capability_API.Capability_Tab;
BEGIN
   putaway_session_id_      := Get_Next_Putaway_Session_Id___;
   condition_code_usage_db_ := Part_Catalog_API.Get_Condition_Code_Usage_Db(part_no_);
   local_quantity_          := quantity_;

   IF (serial_no_ IS NOT NULL AND serial_no_ != '*') THEN
      serial_no_tab_(1).serial_no := serial_no_;
      local_quantity_ := NULL;
   END IF;

   Putaway___(handling_unit_putaway_success_ => dummy_boolean_,
              qty_not_in_good_place_         => dummy_number_,
              transport_task_id_             => dummy_number_,
              selected_hu_location_no_       => dummy_string_,
              contract_                      => contract_,
              part_no_                       => part_no_,
              configuration_id_              => configuration_id_,
              from_location_no_              => location_no_,
              lot_batch_no_                  => lot_batch_no_,
              serial_no_tab_                 => serial_no_tab_,
              eng_chg_level_                 => eng_chg_level_,
              waiv_dev_rej_no_               => waiv_dev_rej_no_,
              activity_seq_                  => activity_seq_,
              handling_unit_id_              => handling_unit_id_,
              quantity_                      => local_quantity_,
              source_ref1_                   => source_ref1_,
              source_ref2_                   => source_ref2_,
              source_ref3_                   => source_ref3_,
              source_ref4_                   => source_ref4_,
              source_ref_type_db_            => source_ref_type_db_,
              condition_code_usage_db_       => condition_code_usage_db_,
              to_location_no_                => NULL,
              to_warehouse_id_               => to_warehouse_id_,
              to_bay_id_                     => to_bay_id_,
              to_tier_id_                    => NULL,
              to_row_id_                     => NULL,
              to_bin_id_                     => NULL,
              condition_code_                => NULL,
              calling_process_               => calling_process_,
              putting_away_handling_unit_    => FALSE,
              handling_unit_gross_weight_    => NULL,
              handling_unit_volume_          => NULL,
              handl_unit_height_requirement_ => NULL,
              handl_unit_width_requirement_  => NULL,
              handl_unit_depth_requirement_  => NULL,
              handling_unit_id_investigated_ => NULL,
              handling_unit_min_temperature_ => NULL, 
              handling_unit_max_temperature_ => NULL, 
              handling_unit_min_humidity_    => NULL,    
              handling_unit_max_humidity_    => NULL,
              putaway_session_id_            => putaway_session_id_,
              handl_unit_capability_req_tab_ => empty_cap_req_tab_);

   Cleanup_Putaway_Session___(putaway_session_id_, cleanup_old_sessions_ => TRUE);
   info_ := Client_SYS.Get_All_Info;
END Putaway_Part;


PROCEDURE Putaway_Part (
   info_               OUT VARCHAR2,
   contract_           IN  VARCHAR2,
   part_no_            IN  VARCHAR2,
   configuration_id_   IN  VARCHAR2,
   location_no_        IN  VARCHAR2,
   lot_batch_no_       IN  VARCHAR2,
   serial_no_tab_      IN  Part_Serial_Catalog_API.Serial_No_Tab,
   eng_chg_level_      IN  VARCHAR2,
   waiv_dev_rej_no_    IN  VARCHAR2,
   activity_seq_       IN  NUMBER,
   handling_unit_id_   IN  NUMBER,
   quantity_           IN  NUMBER,
   source_ref1_        IN  VARCHAR2,
   source_ref2_        IN  VARCHAR2,
   source_ref3_        IN  VARCHAR2,
   source_ref4_        IN  NUMBER,
   source_ref_type_db_ IN  VARCHAR2,
   calling_process_    IN  VARCHAR2 DEFAULT 'PUTAWAY',
   to_warehouse_id_    IN  VARCHAR2 DEFAULT NULL,
   to_bay_id_          IN  VARCHAR2 DEFAULT NULL )
IS
   dummy_boolean_      BOOLEAN;
   dummy_number_       NUMBER;
   putaway_session_id_ NUMBER;
   dummy_string_       VARCHAR2(50);
   empty_cap_req_tab_  Storage_Capability_API.Capability_Tab;
BEGIN
   putaway_session_id_ := Get_Next_Putaway_Session_Id___;

   Putaway_Part___(handling_unit_putaway_success_ => dummy_boolean_,
                   info_                          => info_,
                   transport_task_id_             => dummy_number_,
                   selected_hu_location_no_       => dummy_string_,
                   contract_                      => contract_,
                   part_no_                       => part_no_,
                   configuration_id_              => configuration_id_,
                   location_no_                   => location_no_,
                   lot_batch_no_                  => lot_batch_no_,
                   serial_no_tab_                 => serial_no_tab_,
                   eng_chg_level_                 => eng_chg_level_,
                   waiv_dev_rej_no_               => waiv_dev_rej_no_,
                   activity_seq_                  => activity_seq_,
                   handling_unit_id_              => handling_unit_id_,
                   quantity_                      => quantity_,
                   source_ref1_                   => source_ref1_,
                   source_ref2_                   => source_ref2_,
                   source_ref3_                   => source_ref3_,
                   source_ref4_                   => source_ref4_,
                   source_ref_type_db_            => source_ref_type_db_,
                   calling_process_               => calling_process_,
                   to_warehouse_id_               => to_warehouse_id_,
                   to_bay_id_                     => to_bay_id_,
                   handl_unit_capability_req_tab_ => empty_cap_req_tab_,
                   putaway_session_id_            => putaway_session_id_);

   Cleanup_Putaway_Session___(putaway_session_id_, cleanup_old_sessions_ => TRUE);
END Putaway_Part;


PROCEDURE Check_Storage_Requirements (
   to_contract_                   IN VARCHAR2,
   part_no_                       IN VARCHAR2,
   configuration_id_              IN VARCHAR2,
   to_location_no_                IN VARCHAR2,
   lot_batch_no_                  IN VARCHAR2,
   serial_no_                     IN VARCHAR2, 
   eng_chg_level_                 IN VARCHAR2,
   waiv_dev_rej_no_               IN VARCHAR2,
   activity_seq_                  IN NUMBER,
   handling_unit_id_              IN NUMBER,
   quantity_                      IN NUMBER,
   calling_process_               IN VARCHAR2 DEFAULT NULL )
IS
   serial_no_tab_                 Part_Serial_Catalog_API.Serial_No_Tab;
   local_quantity_                NUMBER;
   dummy_number_                  NUMBER;
   dummy_boolean_                 BOOLEAN;
   dummy_string_                  VARCHAR2(50);
   condition_code_usage_db_       VARCHAR2(20);
   exit_procedure_                EXCEPTION;
   warehouse_id_                  warehouse_bay_bin_tab.warehouse_id%TYPE;
   bay_id_                        warehouse_bay_bin_tab.bay_id%TYPE;
   row_id_                        warehouse_bay_bin_tab.row_id%TYPE;
   tier_id_                       warehouse_bay_bin_tab.tier_id%TYPE;
   bin_id_                        warehouse_bay_bin_tab.bin_id%TYPE;
   exclude_storage_req_val_db_    VARCHAR2(5);
   empty_cap_req_tab_             Storage_Capability_API.Capability_Tab;
   handl_unit_height_requirement_ NUMBER;
   handl_unit_width_requirement_  NUMBER;
   handl_unit_depth_requirement_  NUMBER;
   root_handling_unit_id_         NUMBER;
   handling_unit_rec_             Handling_Unit_API.Public_Rec;
   handling_unit_volume_          NUMBER;
   handling_unit_gross_weight_    NUMBER;
   putaway_session_id_            NUMBER;
   company_uom_for_length_        VARCHAR2(10);
   mix_of_parts_blocked_db_       VARCHAR2(5);
   mix_of_lot_batch_blocked_db_   VARCHAR2(5);
   mix_of_conditions_blocked_db_  VARCHAR2(5);
   handling_unit_part_no_         inventory_part_in_stock_tab.part_no%TYPE;
   handling_unit_lot_batch_no_    inventory_part_in_stock_tab.lot_batch_no%TYPE;
   handling_unit_condition_code_  part_serial_catalog_pub.condition_code%TYPE;
   approve_handling_unit_         BOOLEAN;
BEGIN

   Error_SYS.Check_Not_Null(lu_name_, 'LOCATION_NO', to_location_no_);
   Inventory_Location_API.Exist(to_contract_, to_location_no_);

   Warehouse_Bay_Bin_API.Get_Location_Strings(warehouse_id_,
                                              bay_id_,
                                              tier_id_,
                                              row_id_,
                                              bin_id_,
                                              to_contract_,
                                              to_location_no_);

   exclude_storage_req_val_db_ := Warehouse_Bay_Bin_API.Get_Exclude_Storage_Req_Val_Db(to_contract_,   
                                                                                       warehouse_id_,
                                                                                       bay_id_,     
                                                                                       tier_id_,    
                                                                                       row_id_,     
                                                                                       bin_id_);
   IF (exclude_storage_req_val_db_ = Fnd_Boolean_API.db_true) THEN
      RAISE exit_procedure_;
   END IF;

   condition_code_usage_db_ := Part_Catalog_API.Get_Condition_Code_Usage_Db(part_no_);
   local_quantity_          := quantity_;

   IF (serial_no_ IS NOT NULL AND serial_no_ != '*') THEN
      serial_no_tab_(1).serial_no := serial_no_;
      local_quantity_ := NULL;
   END IF;

   IF (handling_unit_id_ != 0) THEN
      root_handling_unit_id_         := Handling_Unit_API.Get_Root_Handling_Unit_Id(handling_unit_id_);
      IF (Handling_Unit_Approved___(root_handling_unit_id_, to_contract_, to_location_no_)) THEN
         RAISE exit_procedure_;
      END IF;
      handling_unit_rec_             := Handling_Unit_API.Get(root_handling_unit_id_);
      handling_unit_volume_          := Handling_Unit_API.Get_Operative_Volume(root_handling_unit_id_, Handling_Unit_API.Get_Uom_For_Volume(root_handling_unit_id_));
      handling_unit_gross_weight_    := Handling_Unit_API.Get_Operative_Gross_Weight(handling_unit_id_   => root_handling_unit_id_,
                                                                                uom_for_weight_       => Handling_Unit_API.Get_Uom_For_Weight(root_handling_unit_id_),
                                                                                apply_freight_factor_ => Fnd_Boolean_Api.DB_FALSE);
      company_uom_for_length_        := Company_Invent_Info_API.Get_Uom_For_Length(Site_API.Get_Company(to_contract_));
      handl_unit_height_requirement_ := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_rec_.height,
                                                                                     handling_unit_rec_.uom_for_length,
                                                                                     company_uom_for_length_),positive_infinity_);
      handl_unit_width_requirement_  := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_rec_.width,
                                                                                     handling_unit_rec_.uom_for_length,
                                                                                     company_uom_for_length_), positive_infinity_);
      handl_unit_depth_requirement_  := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_rec_.depth,
                                                                                     handling_unit_rec_.uom_for_length,
                                                                                     company_uom_for_length_), positive_infinity_);
   END IF;

   putaway_session_id_ := Get_Next_Putaway_Session_Id___;

   Putaway___(handling_unit_putaway_success_ => dummy_boolean_,
              qty_not_in_good_place_         => dummy_number_,
              transport_task_id_             => dummy_number_,
              selected_hu_location_no_       => dummy_string_,
              contract_                      => to_contract_,
              part_no_                       => part_no_,
              configuration_id_              => configuration_id_,
              from_location_no_              => NULL,
              lot_batch_no_                  => lot_batch_no_,
              serial_no_tab_                 => serial_no_tab_,
              eng_chg_level_                 => eng_chg_level_,
              waiv_dev_rej_no_               => waiv_dev_rej_no_,
              activity_seq_                  => activity_seq_,
              handling_unit_id_              => handling_unit_id_,
              quantity_                      => local_quantity_,
              source_ref1_                   => NULL,
              source_ref2_                   => NULL,
              source_ref3_                   => NULL,
              source_ref4_                   => NULL,
              source_ref_type_db_            => NULL,
              condition_code_usage_db_       => condition_code_usage_db_,
              to_location_no_                => to_location_no_,
              to_warehouse_id_               => warehouse_id_,
              to_bay_id_                     => bay_id_,
              to_tier_id_                    => tier_id_,
              to_row_id_                     => row_id_,
              to_bin_id_                     => bin_id_,
              condition_code_                => NULL,
              calling_process_               => NULL,
              putting_away_handling_unit_    => FALSE,
              handling_unit_gross_weight_    => handling_unit_gross_weight_,
              handling_unit_volume_          => handling_unit_volume_,
              handl_unit_height_requirement_ => handl_unit_height_requirement_,
              handl_unit_width_requirement_  => handl_unit_width_requirement_,
              handl_unit_depth_requirement_  => handl_unit_depth_requirement_,
              handling_unit_id_investigated_ => root_handling_unit_id_,
              handling_unit_min_temperature_ => NULL, 
              handling_unit_max_temperature_ => NULL, 
              handling_unit_min_humidity_    => NULL,    
              handling_unit_max_humidity_    => NULL,
              putaway_session_id_            => putaway_session_id_,
              handl_unit_capability_req_tab_ => empty_cap_req_tab_);

   IF (root_handling_unit_id_ IS NOT NULL) THEN
      approve_handling_unit_ := TRUE;

      mix_of_parts_blocked_db_ := Warehouse_Bay_Bin_API.Get_Mix_Of_Parts_Blocked_Db(to_contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
      IF (mix_of_parts_blocked_db_ = Fnd_Boolean_API.DB_TRUE) THEN
         handling_unit_part_no_ := Handling_Unit_API.Get_Part_No(root_handling_unit_id_);
         IF (handling_unit_part_no_ = Handling_Unit_API.mixed_value_) THEN
            -- Since the HU has several part numbers and the location does not allow it, then we cannot approve the handling unit for this location.
            approve_handling_unit_ := FALSE;
         END IF;
      END IF;

      IF (approve_handling_unit_) THEN
         mix_of_lot_batch_blocked_db_ := Warehouse_Bay_Bin_API.Get_Mix_Of_Lot_Blocked_Db(to_contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
         IF (mix_of_lot_batch_blocked_db_ = Fnd_Boolean_API.DB_TRUE) THEN
            handling_unit_lot_batch_no_ := Handling_Unit_API.Get_Lot_Batch_No(root_handling_unit_id_);
            IF (handling_unit_lot_batch_no_ = Handling_Unit_API.mixed_value_) THEN
               -- Since the HU has several lot/batch numbers and the location does not allow it, then we cannot approve the handling unit for this location.
               approve_handling_unit_ := FALSE;
            END IF;
         END IF;
      END IF;

      IF (approve_handling_unit_) THEN
         mix_of_conditions_blocked_db_ := Warehouse_Bay_Bin_API.Get_Mix_Of_Cond_Blocked_Db(to_contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
         IF (mix_of_conditions_blocked_db_ = Fnd_Boolean_API.DB_TRUE) THEN
            handling_unit_condition_code_ := NVL(Handling_Unit_API.Get_Condition_Code(root_handling_unit_id_), 'STRINGNULL');
            IF (handling_unit_condition_code_ = Handling_Unit_API.mixed_value_) THEN
               -- Since the HU has several condition codes and the location does not allow it, then we cannot approve the handling unit for this location.
               approve_handling_unit_ := FALSE;
            END IF;
         END IF;
      END IF;

      IF (approve_handling_unit_) THEN
         Approve_Handling_Unit___(root_handling_unit_id_, to_contract_, to_location_no_);
      END IF;
   END IF;

   Cleanup_Putaway_Session___(putaway_session_id_, cleanup_old_sessions_ => TRUE);
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Check_Storage_Requirements;


PROCEDURE Putaway_Handling_Unit (
   info_                     OUT VARCHAR2,
   handling_unit_id_         IN  NUMBER,
   source_ref_type_db_       IN  VARCHAR2 DEFAULT NULL,
   source_ref1_              IN  VARCHAR2 DEFAULT NULL,
   source_ref2_              IN  VARCHAR2 DEFAULT NULL,
   source_ref3_              IN  VARCHAR2 DEFAULT NULL,
   source_ref4_              IN  VARCHAR2 DEFAULT NULL,
   throw_error_on_exception_ IN  BOOLEAN  DEFAULT TRUE,
   calling_process_          IN  VARCHAR2 DEFAULT 'PUTAWAY' )
IS
   handling_unit_rec_             Handling_Unit_API.Public_Rec;
   dummy_stock_tab_               Stock_Record_Tab;
   handling_unit_min_temperature_ NUMBER;
   handling_unit_max_temperature_ NUMBER;
   handling_unit_min_humidity_    NUMBER;
   handling_unit_max_humidity_    NUMBER;
   putaway_session_id_            NUMBER;
   dummy_cap_req_tab_             Storage_Capability_API.Capability_Tab;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   putaway_session_id_ := Get_Next_Putaway_Session_Id___;

   Handling_Unit_API.Exist(handling_unit_id_);
   -- Lock the structure so that no updates of parent_handling_unit_id, contract, location_no, shipment_id, source_ref or any other thing can happen
   -- while we evaluate this structure for Putaway and try to find a location that fits.
   Handling_Unit_API.Lock_Node_And_Descendants(handling_unit_id_);

   handling_unit_rec_ := Handling_Unit_API.Get(handling_unit_id_);

   Putaway_Handling_Unit___(previous_hu_stock_record_tab_  => dummy_stock_tab_              ,
                            handling_unit_min_temperature_ => handling_unit_min_temperature_,
                            handling_unit_max_temperature_ => handling_unit_max_temperature_,
                            handling_unit_min_humidity_    => handling_unit_min_humidity_   ,
                            handling_unit_max_humidity_    => handling_unit_max_humidity_   ,
                            handl_unit_capability_req_tab_ => dummy_cap_req_tab_            ,
                            handling_unit_rec_             => handling_unit_rec_            ,
                            putaway_session_id_            => putaway_session_id_           ,
                            source_ref_type_db_            => source_ref_type_db_           ,
                            source_ref1_                   => source_ref1_                  ,
                            source_ref2_                   => source_ref2_                  ,
                            source_ref3_                   => source_ref3_                  ,
                            source_ref4_                   => source_ref4_                  ,
                            throw_error_on_exception_      => throw_error_on_exception_     ,
                            calling_process_               => calling_process_              );

   Inventory_Event_Manager_API.Finish_Session;
   Cleanup_Putaway_Session___(putaway_session_id_, cleanup_old_sessions_ => TRUE);
   info_ := Client_SYS.Get_All_Info;
END Putaway_Handling_Unit;


PROCEDURE Putaway_Handling_Units (
   info_                     OUT VARCHAR2,
   handling_unit_id_tab_     IN  Handling_Unit_API.Handling_Unit_Id_Tab,
   source_ref_type_db_       IN  VARCHAR2 DEFAULT NULL,
   source_ref1_              IN  VARCHAR2 DEFAULT NULL,
   source_ref2_              IN  VARCHAR2 DEFAULT NULL,
   source_ref3_              IN  VARCHAR2 DEFAULT NULL,
   source_ref4_              IN  VARCHAR2 DEFAULT NULL,
   throw_error_on_exception_ IN  BOOLEAN  DEFAULT TRUE,
   calling_process_          IN  VARCHAR2 DEFAULT 'PUTAWAY' )
IS
   handling_unit_char_tab_        Handl_Unit_Characteristics_Tab;
   handling_unit_public_tab_      Handling_Unit_API.Public_Tab;
   previous_hu_stock_record_tab_  Stock_Record_Tab;
   handl_unit_capability_req_tab_ Storage_Capability_API.Capability_Tab;
   handling_unit_min_temperature_ NUMBER;
   handling_unit_max_temperature_ NUMBER;
   handling_unit_min_humidity_    NUMBER;
   handling_unit_max_humidity_    NUMBER;
   putaway_session_id_            NUMBER;
   previous_handling_unit_id_     NUMBER;
   handling_units_are_comparable_ BOOLEAN := FALSE;
BEGIN
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      putaway_session_id_ := Get_Next_Putaway_Session_Id___;

      Get_Handling_Unit_Char_Tab___(handling_unit_char_tab_, handling_unit_public_tab_, handling_unit_id_tab_);

      FOR i IN handling_unit_char_tab_.FIRST..handling_unit_char_tab_.LAST LOOP

         IF (i > handling_unit_char_tab_.FIRST) THEN
            -- Investigate if there is a need to restart from scratch again because of different prerequisites
            IF ((handling_unit_char_tab_(i).contract                = handling_unit_char_tab_(i - 1).contract              ) AND
                (handling_unit_char_tab_(i).handling_unit_type_id   = handling_unit_char_tab_(i - 1).handling_unit_type_id ) AND
                (handling_unit_char_tab_(i).height_requirement      = handling_unit_char_tab_(i - 1).height_requirement    ) AND
                (handling_unit_char_tab_(i).width_requirement       = handling_unit_char_tab_(i - 1).width_requirement     ) AND
                (handling_unit_char_tab_(i).depth_requirement       = handling_unit_char_tab_(i - 1).depth_requirement     ) AND
                (handling_unit_char_tab_(i).operative_volume       >= handling_unit_char_tab_(i - 1).operative_volume      ) AND
                (handling_unit_char_tab_(i).operative_gross_weight >= handling_unit_char_tab_(i - 1).operative_gross_weight)) THEN
               -- Safe to continue with the same zones and bins as for the previous handling unit
               handling_units_are_comparable_ := TRUE;
            ELSE
            -- There is a need to restart from scratch again because of different prerequisites
               Cleanup_Putaway_Session___(putaway_session_id_);
               putaway_session_id_            := Get_Next_Putaway_Session_Id___;
               handling_units_are_comparable_ := FALSE;
            END IF;
         END IF;

         Putaway_Handling_Unit___(previous_hu_stock_record_tab_  => previous_hu_stock_record_tab_,
                                  handling_unit_min_temperature_ => handling_unit_min_temperature_,
                                  handling_unit_max_temperature_ => handling_unit_max_temperature_,
                                  handling_unit_min_humidity_    => handling_unit_min_humidity_,
                                  handling_unit_max_humidity_    => handling_unit_max_humidity_,
                                  handl_unit_capability_req_tab_ => handl_unit_capability_req_tab_,
                                  handling_unit_rec_             => handling_unit_public_tab_(handling_unit_char_tab_(i).handling_unit_id),
                                  putaway_session_id_            => putaway_session_id_,
                                  source_ref_type_db_            => source_ref_type_db_,
                                  source_ref1_                   => source_ref1_,
                                  source_ref2_                   => source_ref2_,
                                  source_ref3_                   => source_ref3_,
                                  source_ref4_                   => source_ref4_,
                                  throw_error_on_exception_      => throw_error_on_exception_,
                                  calling_process_               => calling_process_,
                                  handling_unit_volume_          => handling_unit_char_tab_(i).operative_volume,
                                  handling_unit_gross_weight_    => handling_unit_char_tab_(i).operative_gross_weight,
                                  handl_unit_height_requirement_ => handling_unit_char_tab_(i).height_requirement,
                                  handl_unit_width_requirement_  => handling_unit_char_tab_(i).width_requirement,
                                  handl_unit_depth_requirement_  => handling_unit_char_tab_(i).depth_requirement,
                                  previous_handling_unit_id_     => previous_handling_unit_id_,
                                  handling_units_are_comparable_ => handling_units_are_comparable_);

         previous_handling_unit_id_ := handling_unit_char_tab_(i).handling_unit_id;
      END LOOP;

      Cleanup_Putaway_Session___(putaway_session_id_, cleanup_old_sessions_ => TRUE);
      Inventory_Event_Manager_API.Finish_Session;
      info_ := Client_SYS.Get_All_Info;
   END IF;
END Putaway_Handling_Units;

