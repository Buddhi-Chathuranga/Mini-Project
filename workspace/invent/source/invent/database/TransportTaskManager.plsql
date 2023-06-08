-----------------------------------------------------------------------------
--
--  Logical unit: TransportTaskManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210929  WaSalk  SC21R2-3005, Modified Inbound_Or_Outbound_Task_Exist() to correct format to comply with a new Regex.
--  201123  SBalLK  Bug 156522(SCZ-12077), Added Add_Transport_Task_To_List___() and modified Find_And_Create_Task() methods to support multiple transport task creation with align to
--  201123          defined consolidation  parameters.
--  201110  JaThlk  Bug 156148 (SCZ-12333), Modified Inbound_Or_Outbound_Task_Exist() by adding handling_unit_id in the where clause of  the cursor, check_inbound_task_pac_id.
--  201027  LEPESE  Replaced quantity with qty_supply when reading from Transport_Task_Manager_Local_1 in methods Get_Mrp_Supply and 
--  201027           Get_Project_Mrp_Supply to get proper quantity conversion when the transport task line is inter-site.
--  181204  ShPrlk  Bug 144892, Modified Inbound_Or_Outbound_Task_Exist() by adding Inventory_Part_In_Stock_API.Get_Move_Dest_Avail_Ctrl_Id() to cursor 
--  181204          check_inbound_task_pac_id to check for correct destination pac_id. 
--  180112  BudKlk  Bug 139555, Modified the method Inbound_Or_Outbound_Task_Exist() to change the cursors to improve the performance.
--  180111  MAJOSE  STRMF-16940, Splitted cursors in Get_Mrp_Supply and Get_Project_Mrp_Supply in order to improve performance of Selective Selective MRP.
--  171019  LEPESE  STRSC-13187, Removed method Find_Part___. Redesigned method Find_And_Create_Task so that it uses Inventory_Part_In_Stock_API.Find_For_Transport.
--  171012  MWERSE  STRSC-12392, Included parameters for order type and order ref in Find_Part___ and Find_And_Create_Task
--  170919  Chfose  STRSC-8922, Added new method New_Or_Add_To_Existing with the ability to reuse a transport_task_id if one is sent into the method.
--  170308  UdGnlk  LIM-10870, Modified Is_Valid_Drop_Off_Location___(), Set_Transport_Locations() to add parameter reserved_by_source_db_
--  170308          to pass to Transport_Task_Line_API.Check_Insert_();  
--  170111  MaEelk  LIM-10140, Added necessary changes relevant to newly added  pick_list_no and shipment_id columns in Transport_Task_Line_Tab.
--  160922  NiLalk  STRSC-4178, Modified Inbound_Or_Outbound_Task_Exist by adding two parameters and adding check_inbound_task_pac_id cursor to avoid 
--  160922          conflicting situations where there are 2 transport task lines having different PAC ids but same record attribute and same destination id.
--  160627  CHAHLK  STRMF-5207, Merged LCS Patch 129119.
--                  160621  CHAHLK  Bug 129119, Modified Function Get_Project_Mrp_Supply to return Project_Mrp_Supply_Rec with line_no.
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  160512  LEPESE  LIM-7363, added putaway_event_id_ in call to Transport_Task_API.New_Or_Add_To_Existing.
--  151029  Chfose  LIM-3941, Removed all pallet specific code.
--  151020  JeLise  LIM-3893, Removed check on pallet related location types in Find_And_Create_Task.
--  105028  LEPESE  LIM-1022, additional development for handling units.
--  150414  LEPESE  LIM-77, added handling_unit_id to several methods.
--  150220  LEPESE  PRSC-4564, added putaway_event_id_ as parameter to Set_Transport_Locations and Is_Valid_Drop_Off_Location___.
--  150220          passed putaway_event_id_ from Set_Transport_Locations via Is_Valid_Drop_Off_Location___ to Transport_Task_Line_API.Check_Insert_.
--  140513  MatKse  PBSC-9054, Modified Is_Valid_Drop_Off_Location___ by changing method used to see if deviating part availability control ID is allowed.
--  140415  LEPESE  BPCS-8386, removed parameter destination_ from methods Set_Transport_Locations and Is_Valid_Drop_Off_Location___.
--  140415          This is because destination will always be set as 'Move to inventory' when executing a transport task line
--  140415          that has a value in forward_to_location_no. This is because the quantity needs to end up in Qty On Hand so
--  140415          the next transport task line that moves from 'to_location_no' to 'forward_to_location_no' can be created.
--  140401  LEPESE  Modifications in methods Get_Mrp_Supply and Get_Project_Mrp_Supply where the usage of view 
--  140401          transport_task_manager_local_2 has been removed and usage of method 
--  140401          Inventory_Part_In_Stock_API.Get_Move_Dest_Supply_Ctrl_Db has been added.
--  140207  Matkse  Modified Set_Transport_Locations by changing call Site_Invent_Info_API.Get_Auto_Dropof_Man_Trans_Task to 
--                  Site_Invent_Info_API.Get_Auto_Dropof_Man_Trans_T_Db.
--  130829  RiLase  Added method Set_Transport_Locations and Is_Valid_Drop_Off_Location___.
--  130821  Cpeilk  Bug 110800, Modified Find_And_Create_Task() and Find_Part___() by modifying parameter only_company_owned_stock_ to
--  130821          only_comp_own_and_sup_consign_ and use it inside Find_Part___() to filter the records having ownerships
--  130821          'COMPANY OWNED' and 'CONSIGNMENT'.
--  130704  Matkse  Renamed parameter check_availability_control to allow_deviating_avail_ctrl 
--  130704          and changed param order in calls to Transport_Task_Line_API.Check_Insert_ from Find_Part___ and Find_Pallet___. 
--  130626  DaZase  Added TRUE values for check_availability_control_ parameter in calls to Transport_Task_Line_API.Check_Insert_.
--  130624  RILASE  Added Get_Drop_Off_Location_No, Get_Bay_Drop_Off_Location___ and Get_Whse_Drop_Off_Location___.
--  130114  RILASE  Changed where statement in views transport_task_manager_local_1 and transport_task_manager_local_2, and cursors
--  130114          check_inbound_task and check_outbound_task in method Inbound_Or_Outbound_Task_Exist to consider status
--  130801  MaRalk  TIBE-915, Removed global LU constant last_calendar_date_ and added inside Find_Part___, Find_Pallet___, 
--  130801          Get_Mrp_Supply, Get_Project_Mrp_Supply methods. Removed global LU constant first_calendar_date_ and 
--  130801          added inside Find_Part___, Find_Pallet___ methods.      
--  130114  RILASE  Changed where statement in views transport_task_manager_local_1 and transport_task_manager_local_2, and cursors
--  130114          check_inbound_task and check_outbound_task in method Inbound_Or_Outbound_Task_Exist to consider status
--  130114          NOT LIKE executed rather than LIKE created, to inlucde lines in status picked.
--  130114          NOT LIKE executed rather than LIKE created, to inlucde lines in status picked.
--  120126  LEPESE  Correction in Find_Part___ and Find_And_Create_Task to not create task for full quantity on stock record.
--  120124  LEPESE  Added function Warehouse_Task_Is_Started_Db.
--  120118  LEPESE  Changes in Warehouse_Task_Is_Started_ to make this method return TRUE also for Parked Warehouse Tasks.
--  120111  LEPESE  Replaced call to Transport_Task_Line_Pallet_API.Check_Insert_ in method Find_Pallet___
--  120111          with a call to Transport_Task_Line_API.Check_Insert_.
--  120111          Replaced call to Transport_Task_Line_Nopall_API.Check_Insert_ in method Find_Part___
--  120111          with a call to Transport_Task_Line_API.Check_Insert_.
--  120111          Removed join with inventory_part_loc_pallet_pub in view transport_task_manager_local_2. Removed usage
--  120111          of inventory_part_loc_pallet_tab in methods Warehouse_Task_Is_Started and Inbound_Or_Outbound_Task_Exist. 
--  111230  LEPESE  Removed usage of TRANSPORT_TASK_TAB in views transport_task_manager_local_1
--  111230          and transport_task_manager_local_2 as well as in methods Inbound_Or_Outbound_Task_Exist and Warehouse_Task_Is_Started_. 
--  111221  JeLise  Removed call to Transport_Task_API.Check_Insert_ in Find_Part___ and Find_Pallet___.
--  111216  JeLise  Added more prameters in call to Transport_Task_Line_Pallet_API.Check_Insert_ in Find_Pallet___.
--  111102  LEPESE  Added parameter check_storage_requirements_ when calling Transport_Task_Line_Nopall_API.Check_Insert_
--  111102          from method Find_Part___. Added parameter check_storage_requirements_ when calling
--  111102          Transport_Task_Line_Pallet_API.Check_Insert_ from method Find_Pallet___.
--  111028  NISMLK  SMA-285, Increased local_eng_chg_level_ length to STRING(6) in Find_Part___ and Find_And_Create_Task methods.
--  110527  Asawlk  Bug 97231, Added new parameter only_company_owned_stock_ to Find_And_Create_Task() and Find_Part___() methods.
--  110527          Passed value to parameter only_company_owned_stock_ when calling Find_Part___() from Find_And_Create_Task().
--  110527          Also modified Find_Part___() to handle part_ownership.    
--  110224  AwWelk  Bug 95796, Added order_supply_demand_type to the group by expression in transport_task_manager_local_3,
--  110224          transport_task_manager_local_4, TRANSPORT_TASK_SUPPL_DEMAND_OE, TRANSPORT_TASK_SUPPL_DEMAND_MS views.
--  110221  DaZase  Changed call to New_Or_Add_To_Existing so it now calls New_Or_Add_Nopall_To_Existing instead (old method renamed).
--  110114  Cpeilk  Bug 95010, Removed method call Inventory_Part_In_Stock_API.Get_Qty_Onhand_By_Location and called method
--  110114          Inventory_Part_In_Stock_API.Get_Inventory_Quantity to get On-hand and transit qty inside method Get_Qty_Onhand_And_Inbound.
--  101202  DaZase  Added activity_seq_ to params in Find_Part___ and used it in the call to Transport_Task_API.New_Or_Add_To_Existing in Find_And_Create_Task.
--  101008  Asawlk  Bug 93401, Added new parameter note_text_ to method Find_And_Create_Task() and passed it when calling methods
--  101008          Transport_Task_API.New_Or_Add_To_Existing() and Transport_Task_API.New_Or_Add_Pallet_To_Existing().
--  100825  ShKolk  Modified views transport_task_manager_local_1, transport_task_manager_local_2, transport_task_manager_local_3, 
--  100825          transport_task_manager_local_4, TRANSPORT_TASK_SUPPLY_DEMAND_OE, TRANSPORT_TASK_SUPPLY_DEMAND_MS
--  100825          and methods Get_Mrp_Supply, Get_Project_Mrp_Supply to consider min_durab_days_planning.
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  071130  MaEelk  Bug 68519, Modified transport_task_manager_local_1,transport_task_manager_local_2, Get_Mrp_Supply
--  071130          and Get_Project_Mrp_Supply to display supplies from transport tasks 
--  071130          that will also be displayed as demands, and vice versa.
--  070829  JaBalk  Bug 67276, Modified the cursor to replace transport_task with transport_task_tab 
--  070829          in Warehouse_Task_Is_Started_.
--  070512  Kaellk  Bug 61731, Added new Order supply demand views transport_task_manager_local_1,
--  070512          transport_task_manager_local_2, transport_task_manager_local_3, transport_task_manager_local_4
--  070512          TRANSPORT_TASK_SUPPLY_DEMAND,TRANSPORT_TASK_SUPPL_DEMAND_OE,TRANSPORT_TASK_SUPPL_DEMAND_MS and
--  070512          TRANSPORT_TASK_SUPP_DEMAND_EXT. Added function Get_Project_Mrp_Supply and
--  070512          Get_Mrp_Supply to retrieve records to be used by Mrp and Pmrp.
--  061115  NaLrlk  Bug 60430, Added function Inbound_Or_Outbound_Task_Exist.
--  060810  ChJalk  Modified hard_coded dates to be able to use any calendar.
------------------------------------ 13.4.0 ----------------------------------
--  050921  NiDalk  Removed unused variables.
--  050113  SeJalk  Bug 48192, Removed '=' sign and truncated the earliest_expire_date_ in the comparison
--  050113          of expiration dates in procedures Find_Part___ and Find_Pallet___.
--  050107  Asawlk  Bug 48485, Modified method Find_Pallet___, replace a call to Pallet_API.Get by
--  050107          Pallet_API.Get_Pallet_State_Db_And_Lock.
--  040630  DaZaSe  Project Inventory: Added activity_seq in method Find_Part___.
------------------------------------ 13.3.0 ----------------------------------
--  020516  NASALK  Extension of serial_no variable definitions from VARCHAR(15) to VARCHAR(50)
--  020315  CHFOLK  Rollback the change of column name part_reservation_control.
--  020206  CHFOLK  Modified CURSORs, get_location_qty and get_pallet in Find_Part___ and Find_pallet___ in accordance with the renaming of
--                  column part_reservation_control as part_auto_reserv_ctrl in the view, part_availability_control_pub respectively.
--  000928  JOHW    Corrected calls to Check_Insert_.
--  000925  JOHESE  Added undefines.
--  000906  JOHW    CTO changes added to support transport task.
--  000418  NISOSE  Added General_SYS.Init_Method in Warehouse_Task_Is_Started_.
--  000224  ROOD    Ruled out more invalid search parameter combinations.
--                  Avoided multiple Id numbers in the Id list OUT parameter in Find_And_Create_Task.
--  000221  JOHW    Added new default parameter requested_date_finished_ to Find_And_Create_Task.
--  000219  ROOD    Modified handling of find_pallets_ and find_non_pallets_ in Find_And_Create_Task.
--  000219  ROOD    Added User_Allowed_Site limitations in Find_Part___ and Find_Pallet___.
--  000219  JOHW    Made Warehouse_Task_Is_Started_ handle two task types.
--  000216  ROOD    Changed parameter qty_found_ to quantity_found_ in Find_Part___.
--  000215  ROOD    Added parameter transport_task_id_list_ in method Find_And_Create_Task.
--  000212  ROOD    Performance improvements and some cleanup after tests.
--  000211  JOHW    Added method Get_Qty_Onhand_And_Inbound.
--  000211  ROOD    Added methods Find_Part___ and Find_Pallet___.
--  000118  ROOD    Continued development.
--  000107  JOHW    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Mrp_Supply_Rec IS RECORD(
   part_no           TRANSPORT_TASK_LINE_TAB.part_no%TYPE,
   transport_task_id TRANSPORT_TASK_LINE_TAB.transport_task_id%TYPE,
   transport_date    DATE,
   quantity          TRANSPORT_TASK_LINE_TAB.quantity%TYPE);
TYPE Project_Mrp_Supply_Rec IS RECORD(
   line_no           TRANSPORT_TASK_LINE_TAB.line_no%TYPE,
   part_no           TRANSPORT_TASK_LINE_TAB.part_no%TYPE,
   transport_task_id TRANSPORT_TASK_LINE_TAB.transport_task_id%TYPE,
   transport_date    DATE,
   quantity          TRANSPORT_TASK_LINE_TAB.quantity%TYPE,
   project_id        TRANSPORT_TASK_LINE_TAB.project_id%TYPE,
   activity_seq      TRANSPORT_TASK_LINE_TAB.activity_seq%TYPE);  
TYPE Mrp_Supply_Tab IS TABLE OF Mrp_Supply_Rec INDEX BY PLS_INTEGER;
TYPE Project_Mrp_Supply_Tab IS TABLE OF Project_Mrp_Supply_Rec INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


FUNCTION Is_Valid_Drop_Off_Location___ (
   from_contract_         IN VARCHAR2,
   from_location_no_      IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   to_contract_           IN VARCHAR2,
   to_location_no_        IN VARCHAR2,
   order_type_            IN VARCHAR2,
   order_ref1_            IN VARCHAR2,
   order_ref2_            IN VARCHAR2,
   order_ref3_            IN VARCHAR2,
   order_ref4_            IN VARCHAR2,
   pick_list_no_          IN VARCHAR2,
   shipment_id_           IN NUMBER,         
   lot_batch_no_          IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   eng_chg_level_         IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   quantity_              IN NUMBER,
   activity_seq_          IN NUMBER,
   handling_unit_id_      IN NUMBER,
   reserved_by_source_db_ IN VARCHAR2) RETURN BOOLEAN
IS
   is_valid_drop_off_location_ BOOLEAN := TRUE;
   allow_deviating_avail_ctrl_ VARCHAR2(20);
BEGIN
   allow_deviating_avail_ctrl_ := Site_Invent_Info_API.Get_Allow_Deviating_Avail_C_Db(to_contract_);
   BEGIN
      Transport_Task_Line_API.Check_Insert_(from_contract_              => from_contract_,
                                            from_location_no_           => from_location_no_,
                                            part_no_                    => part_no_,
                                            configuration_id_           => configuration_id_,
                                            to_contract_                => to_contract_,
                                            to_location_no_             => to_location_no_,
                                            destination_                => Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY,
                                            order_type_                 => order_type_,
                                            order_ref1_                 => order_ref1_,
                                            order_ref2_                 => order_ref2_,
                                            order_ref3_                 => order_ref3_,
                                            order_ref4_                 => order_ref4_,
                                            pick_list_no_               => pick_list_no_,
                                            shipment_id_                => shipment_id_,                                                     
                                            lot_batch_no_               => lot_batch_no_,
                                            serial_no_                  => serial_no_,
                                            eng_chg_level_              => eng_chg_level_,
                                            waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                            quantity_                   => quantity_,
                                            activity_seq_               => activity_seq_,
                                            handling_unit_id_           => handling_unit_id_,
                                            allow_deviating_avail_ctrl_ => CASE allow_deviating_avail_ctrl_
                                                                              WHEN Fnd_Boolean_API.DB_TRUE THEN TRUE
                                                                              WHEN Fnd_Boolean_API.DB_FALSE THEN FALSE END,
                                            check_storage_requirements_ => TRUE,
                                            checking_forward_transport_ => TRUE,
                                            reserved_by_source_db_      => reserved_by_source_db_);
      EXCEPTION
         WHEN OTHERS THEN
            is_valid_drop_off_location_ := FALSE;
   END;
   
   RETURN is_valid_drop_off_location_;
END Is_Valid_Drop_Off_Location___;


PROCEDURE Get_Bay_Drop_Off_Location___ (
   drop_off_locations_ IN OUT Warehouse_Bay_Bin_API.Location_No_Tab,
   from_contract_      IN     VARCHAR2,
   from_warehouse_id_  IN     VARCHAR2,
   from_bay_id_        IN     VARCHAR2,
   from_location_no_   IN     VARCHAR2,
   to_contract_        IN     VARCHAR2, 
   to_warehouse_id_    IN     VARCHAR2, 
   to_bay_id_          IN     VARCHAR2,
   to_location_no_     IN     VARCHAR2 )
IS
   drop_off_location_no_     VARCHAR2(35);
   drop_off_location_whse_   VARCHAR2(15);
   drop_off_location_bay_id_ VARCHAR2(5);
   between_sites_            BOOLEAN; 
   between_warehouses_       BOOLEAN; 
BEGIN   
   drop_off_location_no_     := Warehouse_Bay_API.Get_Drop_Off_Location_No(to_contract_, to_warehouse_id_, to_bay_id_);
   drop_off_location_whse_   := Inventory_Location_API.Get_Warehouse(to_contract_, drop_off_location_no_);
   drop_off_location_bay_id_ := Inventory_Location_API.Get_Bay_No(to_contract_, drop_off_location_no_);
   
   between_sites_      := (from_contract_ != to_contract_);
   between_warehouses_ := (from_warehouse_id_ != to_warehouse_id_);
   
   IF (drop_off_location_no_ IS NOT NULL) THEN
      IF (from_bay_id_ != to_bay_id_ OR between_warehouses_ OR between_sites_) THEN
         IF (from_location_no_ != drop_off_location_no_ OR between_warehouses_ OR between_sites_) THEN
            IF (to_location_no_ != drop_off_location_no_) THEN
               drop_off_locations_(drop_off_locations_.COUNT + 1) := drop_off_location_no_;
               Get_Bay_Drop_Off_Location___(drop_off_locations_ => drop_off_locations_,
                                            from_contract_      => from_contract_,
                                            from_warehouse_id_  => from_warehouse_id_,
                                            from_bay_id_        => from_bay_id_,
                                            from_location_no_   => from_location_no_,
                                            to_contract_        => to_contract_,
                                            to_warehouse_id_    => drop_off_location_whse_,
                                            to_bay_id_          => drop_off_location_bay_id_,
                                            to_location_no_     => drop_off_location_no_);
            END IF;
         END IF;
      END IF;
   END IF;
END Get_Bay_Drop_Off_Location___;

   
PROCEDURE Get_Whse_Drop_Off_Location___ (
   drop_off_locations_ IN OUT Warehouse_Bay_Bin_API.Location_No_Tab,
   from_contract_      IN     VARCHAR2,
   from_warehouse_id_  IN     VARCHAR2,
   from_location_no_   IN     VARCHAR2,
   to_contract_        IN     VARCHAR2,
   to_warehouse_id_    IN     VARCHAR2,
   to_location_no_     IN     VARCHAR2)
IS
   drop_off_location_no_      VARCHAR2(35);
   drop_off_location_whse_id_ VARCHAR2(15);
   between_sites_             BOOLEAN;
BEGIN  
   drop_off_location_no_      := Warehouse_API.Get_Drop_Off_Location_No(to_contract_, to_warehouse_id_);
   drop_off_location_whse_id_ := Inventory_Location_API.Get_Warehouse(to_contract_, drop_off_location_no_);
   
   between_sites_ := (from_contract_ != to_contract_);
   
   IF (drop_off_location_no_ IS NOT NULL) THEN
      IF (from_warehouse_id_ != to_warehouse_id_ OR between_sites_) THEN
         IF (from_location_no_ != drop_off_location_no_ OR between_sites_) THEN
            IF (to_location_no_ != drop_off_location_no_) THEN
               drop_off_locations_(drop_off_locations_.COUNT + 1) := drop_off_location_no_;
               Get_Whse_Drop_Off_Location___(drop_off_locations_ => drop_off_locations_,
                                             from_contract_      => from_contract_,
                                             from_warehouse_id_  => from_warehouse_id_,
                                             from_location_no_   => from_location_no_,
                                             to_contract_        => to_contract_,
                                             to_warehouse_id_    => drop_off_location_whse_id_,
                                             to_location_no_     => drop_off_location_no_);
            END IF;
         END IF;
      END IF;
   END IF;
END Get_Whse_Drop_Off_Location___;


PROCEDURE Get_Drop_Off_Location_No___ (
   drop_off_locations_ IN OUT Warehouse_Bay_Bin_API.Location_No_Tab,
   from_contract_      IN     VARCHAR2,
   from_location_no_   IN     VARCHAR2,
   to_contract_        IN     VARCHAR2,
   to_location_no_     IN     VARCHAR2)
IS
   from_warehouse_id_             VARCHAR2(15);
   from_bay_id_                   VARCHAR2(5);
   to_warehouse_id_               VARCHAR2(15);
   to_bay_id_                     VARCHAR2(5);
   dummy_char_                    VARCHAR2(5);
   get_to_bay_drop_off_location_  BOOLEAN := FALSE;
   get_to_whse_drop_off_location_ BOOLEAN := FALSE;
BEGIN   
   Warehouse_Bay_Bin_API.Get_Location_Strings(from_warehouse_id_,
                                              from_bay_id_,
                                              dummy_char_,
                                              dummy_char_,
                                              dummy_char_,
                                              from_contract_,
                                              from_location_no_);

   Warehouse_Bay_Bin_API.Get_Location_Strings(to_warehouse_id_,
                                              to_bay_id_,
                                              dummy_char_,
                                              dummy_char_,
                                              dummy_char_,
                                              to_contract_,
                                              to_location_no_);

   IF (from_contract_ = to_contract_) THEN
      IF (from_warehouse_id_ = to_warehouse_id_) THEN
         IF (from_bay_id_ != to_bay_id_) THEN
            -- Between different bays within the same warehouse. Get drop off for destination bay
            get_to_bay_drop_off_location_ := TRUE;
         END IF;
      ELSE
         -- Between different warehouses within the same site. Get drop off for destination warehouse
         get_to_whse_drop_off_location_ := TRUE;
      END IF;
   ELSE
         -- Between different sites. Get drop off for destination warehouse
      get_to_whse_drop_off_location_ := TRUE;
   END IF;
   
   IF (get_to_bay_drop_off_location_) THEN
      Get_Bay_Drop_Off_Location___(drop_off_locations_, from_contract_, from_warehouse_id_, from_bay_id_, from_location_no_, to_contract_, to_warehouse_id_, to_bay_id_, to_location_no_);
   ELSIF (get_to_whse_drop_off_location_) THEN
      -- NOTE: Get a list of drop off locations for both warehouse and bay (for to or last warehouse). Note that invalid location combinations can be removed
      --       at a later stage when validating the transport task line in Set_Transport_Locations(). That means that there might not be any valid drop offs.
      Get_Whse_Drop_Off_Location___(drop_off_locations_, from_contract_, from_warehouse_id_, from_location_no_, to_contract_, to_warehouse_id_, to_location_no_);
      IF (drop_off_locations_.COUNT > 0) THEN
         -- Drop off location(s) was found on the warehouse level, now fetch any bay drop offs on the last warehouse drop off found.
         to_warehouse_id_ := Inventory_Location_API.Get_Warehouse(to_contract_, drop_off_locations_(drop_off_locations_.COUNT));
         to_bay_id_       := Inventory_Location_API.Get_Bay_No(to_contract_, drop_off_locations_(drop_off_locations_.COUNT));
         Get_Bay_Drop_Off_Location___(drop_off_locations_, from_contract_, from_warehouse_id_, from_bay_id_, from_location_no_, to_contract_,
                                      to_warehouse_id_, to_bay_id_, drop_off_locations_(drop_off_locations_.COUNT));
      ELSE
         -- No drop offs was found on the warehouse level, now fetch any bay drop offs on the to location.
         Get_Bay_Drop_Off_Location___(drop_off_locations_, from_contract_, from_warehouse_id_, from_bay_id_, from_location_no_, to_contract_, to_warehouse_id_, to_bay_id_, to_location_no_);
      END IF;
   END IF;
END Get_Drop_Off_Location_No___;


PROCEDURE Add_Transport_Task_To_List___(
   transport_task_list_ IN OUT VARCHAR2,
   transport_task_id_   IN     NUMBER)
IS
   transport_id_table_ Utility_SYS.NUMBER_TABLE;
   token_count_        NUMBER := 0;
   id_found_           BOOLEAN := FALSE;
BEGIN
   IF (TRIM(transport_task_list_) IS NOT NULL) THEN
      transport_task_list_ := transport_task_list_ || ',';
      Utility_SYS.Tokenize(transport_task_list_, ',', transport_id_table_, token_count_);
      IF(transport_id_table_.COUNT > 0) THEN
         FOR i_ IN transport_id_table_.FIRST..transport_id_table_.LAST LOOP
            IF(transport_id_table_(i_) = transport_task_id_) THEN
               id_found_ := TRUE;
               EXIT;
            END IF;
         END LOOP;
         IF (NOT id_found_) THEN
            transport_task_list_ := transport_task_list_ ||transport_task_id_;
         END IF;
      END IF;
   ELSE
      transport_task_list_ := transport_task_id_;
   END IF;
END Add_Transport_Task_To_List___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Warehouse_Task_Is_Started_
--   This method is a shell method and it is intended to simplify calls to
--   warehousing by finding and adding common data before performing the actual call.
@UncheckedAccess
FUNCTION Warehouse_Task_Is_Started_ (
   transport_task_id_ IN NUMBER ) RETURN BOOLEAN
IS
   from_contract_          VARCHAR2(5);
   warehouse_task_type_db_ VARCHAR2(50) := Warehouse_Task_Type_API.DB_TRANSPORT_TASK;

   CURSOR get_from_contract IS
      SELECT from_contract
        FROM transport_task_line_tab
       WHERE transport_task_id = transport_task_id_;
BEGIN
   OPEN get_from_contract;
   FETCH get_from_contract INTO from_contract_;
   CLOSE get_from_contract;

   RETURN Warehouse_Task_API.Source_Task_Started_Or_Parked(from_contract_,
                                                           Warehouse_Task_Type_API.Decode(warehouse_task_type_db_),
                                                           transport_task_id_,
                                                           NULL,
                                                           NULL,
                                                           NULL);
END Warehouse_Task_Is_Started_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Find_And_Create_Task
--   Method that find available parts according to the conditions given.
--   After this it makes the required transport task.
PROCEDURE Find_And_Create_Task (
   transport_task_id_list_        OUT VARCHAR2,
   transport_task_qty_            OUT NUMBER,
   part_no_                       IN  VARCHAR2,
   to_contract_                   IN  VARCHAR2,
   to_location_no_                IN  VARCHAR2,
   quantity_desired_              IN  NUMBER,
   from_contract_                 IN  VARCHAR2,
   from_location_no_              IN  VARCHAR2,
   from_location_group_           IN  VARCHAR2,
   requested_date_finished_       IN  DATE,
   note_text_                     IN  VARCHAR2,
   order_type_db_                 IN  VARCHAR2,
   order_ref1_                    IN  VARCHAR2,
   order_ref2_                    IN  VARCHAR2 DEFAULT NULL,
   order_ref3_                    IN  VARCHAR2 DEFAULT NULL,
   order_ref4_                    IN  VARCHAR2 DEFAULT NULL)
IS
   quantity_added_          NUMBER;
   qty_left_to_find_        NUMBER;
   destination_             VARCHAR2(200) := Inventory_Part_Destination_API.Decode(Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY);
   parameter_counter_       NUMBER := 0;
   serial_no_tab_           Part_Serial_Catalog_API.Serial_No_Tab;
   dummy_tab_               Part_Serial_Catalog_API.Serial_No_Tab;
   quantity_to_add_         NUMBER;
   local_transport_task_id_ NUMBER;
   keys_and_qty_tab_        Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   prev_from_location_no_   VARCHAR2(35);
BEGIN
   IF NVL(quantity_desired_,0) <= 0 THEN
      Error_SYS.Record_General(lu_name_, 'NEGDESIREDQTY: Desired quantity must be greater than zero.');
   END IF;

   -- Rule out invalid combinations of search parameters.
   IF from_location_no_ IS NOT NULL AND from_contract_ IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDCOMBINATION: If From Location No is entered then From Contract has to be entered as well.');
   END IF;
   IF from_location_no_ IS NOT NULL THEN
      parameter_counter_ := parameter_counter_ + 1;
   END IF;
   IF from_location_group_ IS NOT NULL THEN
      parameter_counter_ := parameter_counter_ + 1;
   END IF;
   IF parameter_counter_ > 1 THEN
      Error_SYS.Record_General(lu_name_, 'TOOMANYPARAMETERS: Only one of From Location No and From Location Group can be used at the same time.');
   END IF;

   Inventory_Part_In_Stock_API.Clear_Invent_Part_In_Stock_Tmp;
   qty_left_to_find_ := quantity_desired_;

   LOOP
      EXIT WHEN qty_left_to_find_ <= 0;

      Inventory_Part_In_Stock_API.Find_For_Transport(keys_and_qty_tab_ => keys_and_qty_tab_,
                                                     location_no_      => from_location_no_,
                                                     contract_         => from_contract_,
                                                     part_no_          => part_no_,
                                                     location_group_   => from_location_group_,
                                                     qty_to_find_      => qty_left_to_find_);
      EXIT WHEN keys_and_qty_tab_.COUNT = 0;
      FOR i IN keys_and_qty_tab_.FIRST..keys_and_qty_tab_.LAST LOOP
         BEGIN
            Transport_Task_Line_API.Check_Insert_(from_contract_              => keys_and_qty_tab_(i).contract,
                                                  from_location_no_           => keys_and_qty_tab_(i).location_no,
                                                  part_no_                    => keys_and_qty_tab_(i).part_no,
                                                  configuration_id_           => keys_and_qty_tab_(i).configuration_id,
                                                  to_contract_                => to_contract_,
                                                  to_location_no_             => to_location_no_,
                                                  destination_                => Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY,
                                                  order_type_                 => order_type_db_,
                                                  order_ref1_                 => order_ref1_,
                                                  order_ref2_                 => order_ref2_,
                                                  order_ref3_                 => order_ref3_,
                                                  order_ref4_                 => order_ref4_,
                                                  pick_list_no_               => NULL,
                                                  shipment_id_                => NULL,
                                                  lot_batch_no_               => keys_and_qty_tab_(i).lot_batch_no,
                                                  serial_no_                  => keys_and_qty_tab_(i).serial_no,
                                                  eng_chg_level_              => keys_and_qty_tab_(i).eng_chg_level,
                                                  waiv_dev_rej_no_            => keys_and_qty_tab_(i).waiv_dev_rej_no,
                                                  quantity_                   => keys_and_qty_tab_(i).quantity,
                                                  activity_seq_               => keys_and_qty_tab_(i).activity_seq,
                                                  handling_unit_id_           => keys_and_qty_tab_(i).handling_unit_id,
                                                  allow_deviating_avail_ctrl_ => FALSE,
                                                  check_storage_requirements_ => TRUE);

            IF (keys_and_qty_tab_(i).serial_no = '*') THEN
               quantity_to_add_ := keys_and_qty_tab_(i).quantity;
               serial_no_tab_.DELETE;
            ELSE
               serial_no_tab_(1).serial_no := keys_and_qty_tab_(i).serial_no;
               quantity_to_add_ := NULL;
            END IF;

            -- Inventory part in stock key set is order by the location number. Hence once the one location process that location will not be found throughout the
            -- iteration. This will help to re-investigate the transport task according the consolidation parameters and create new or add to existing. If found any
            -- issue with create transport task please revisit the cursor in Inventory_Part_In_Stock_API.Find_Part___() for "ORDER BY" statement. Location number
            -- Validations will help to avoid create new transport task for same handling unit since all part for same handling unit should store in same location. 
            IF (prev_from_location_no_ IS NULL OR prev_from_location_no_ != keys_and_qty_tab_(i).location_no) THEN
               local_transport_task_id_ := NULL;
               prev_from_location_no_   := keys_and_qty_tab_(i).location_no;
            END IF;

            New_Or_Add_To_Existing(transport_task_id_          => local_transport_task_id_,
                                   quantity_added_             => quantity_added_,
                                   serials_added_              => dummy_tab_,
                                   part_no_                    => keys_and_qty_tab_(i).part_no,
                                   configuration_id_           => keys_and_qty_tab_(i).configuration_id,
                                   from_contract_              => keys_and_qty_tab_(i).contract,
                                   from_location_no_           => keys_and_qty_tab_(i).location_no,
                                   to_contract_                => to_contract_,
                                   to_location_no_             => to_location_no_,
                                   destination_                => destination_,
                                   order_type_                 => Order_Type_API.Decode(order_type_db_),
                                   order_ref1_                 => order_ref1_,
                                   order_ref2_                 => order_ref2_,
                                   order_ref3_                 => order_ref3_,
                                   order_ref4_                 => order_ref4_,
                                   pick_list_no_               => NULL,
                                   shipment_id_                => NULL,
                                   lot_batch_no_               => keys_and_qty_tab_(i).lot_batch_no,
                                   serial_no_tab_              => serial_no_tab_,
                                   eng_chg_level_              => keys_and_qty_tab_(i).eng_chg_level,
                                   waiv_dev_rej_no_            => keys_and_qty_tab_(i).waiv_dev_rej_no,
                                   activity_seq_               => keys_and_qty_tab_(i).activity_seq,
                                   handling_unit_id_           => keys_and_qty_tab_(i).handling_unit_id,
                                   quantity_to_add_            => quantity_to_add_,
                                   requested_date_finished_    => requested_date_finished_,
                                   note_text_                  => note_text_);
            qty_left_to_find_ := qty_left_to_find_ - quantity_added_;
            Add_Transport_Task_To_List___(transport_task_id_list_, local_transport_task_id_);
         EXCEPTION
            WHEN OTHERS THEN
               -- Since this stock record could not be added to a transport task then insert the stock record keys into
               -- a temporary table which means that it will be excluded in the next call to Inventory_Part_In_Stock_API.Find_For_Transport
               Inventory_Part_In_Stock_API.Fill_Invent_Part_In_Stock_Tmp(keys_and_qty_tab_(i));
         END;
      END LOOP;
   END LOOP;

   Inventory_Part_In_Stock_API.Clear_Invent_Part_In_Stock_Tmp;
               
   transport_task_qty_ := quantity_desired_ - qty_left_to_find_;   
END Find_And_Create_Task;


-- Get_Qty_Onhand_And_Inbound
--   Returns the sum of quantities onhand and on Transport Tasks for a
--   specified part number, site and location number. Optionally other
--   parameters could be entered as well to narrow the search criteria.
@UncheckedAccess
FUNCTION Get_Qty_Onhand_And_Inbound (
   part_no_         IN VARCHAR2,
   contract_        IN VARCHAR2,
   location_no_     IN VARCHAR2,
   lot_batch_no_    IN VARCHAR2 DEFAULT NULL,
   serial_no_       IN VARCHAR2 DEFAULT NULL,
   eng_chg_level_   IN VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_ IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   qty_onhand_            NUMBER;
   qty_on_transport_task_ NUMBER;
   total_qty_onhand_      NUMBER;
BEGIN
   qty_onhand_ := Inventory_Part_In_Stock_API.Get_Inventory_Quantity(contract_         => contract_,
                                                                     part_no_          => part_no_,
                                                                     configuration_id_ => '*',
                                                                     qty_type_         => 'ONHAND_PLUS_TRANSIT',
                                                                     lot_batch_no_     => lot_batch_no_,
                                                                     serial_no_        => serial_no_,
                                                                     eng_chg_level_    => eng_chg_level_,
                                                                     waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                     location_no_      => location_no_);

   qty_on_transport_task_ := Transport_Task_API.Get_Qty_Inbound(part_no_          => part_no_,
                                                                configuration_id_ => '*',
                                                                to_contract_      => contract_,
                                                                to_location_no_   => location_no_,
                                                                lot_batch_no_     => lot_batch_no_,
                                                                serial_no_        => serial_no_,
                                                                eng_chg_level_    => eng_chg_level_,
                                                                waiv_dev_rej_no_  => waiv_dev_rej_no_);
   total_qty_onhand_ := (qty_onhand_ + qty_on_transport_task_);

   RETURN total_qty_onhand_;
END Get_Qty_Onhand_And_Inbound;


@UncheckedAccess
FUNCTION Inbound_Or_Outbound_Task_Exist (
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   location_no_                  IN VARCHAR2,
   lot_batch_no_                 IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   eng_chg_level_                IN VARCHAR2,
   waiv_dev_rej_no_              IN VARCHAR2,
   activity_seq_                 IN NUMBER,
   handling_unit_id_             IN NUMBER,
   ignore_pac_id_on_inbound_     IN BOOLEAN  DEFAULT FALSE,
   part_availability_control_id_ IN VARCHAR2 DEFAULT NULL) RETURN BOOLEAN
IS
   dummy_      NUMBER;
   task_exist_ BOOLEAN := FALSE;

   CURSOR check_outbound_task IS
      SELECT 1
        FROM transport_task_line_tab
       WHERE from_contract         = contract_
         AND from_location_no      = location_no_
         AND part_no               = part_no_
         AND configuration_id      = configuration_id_
         AND serial_no             = serial_no_
         AND lot_batch_no          = lot_batch_no_
         AND eng_chg_level         = eng_chg_level_
         AND waiv_dev_rej_no       = waiv_dev_rej_no_
         AND activity_seq          = activity_seq_
         AND handling_unit_id      = handling_unit_id_
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);

   CURSOR check_inbound_task IS
      SELECT 1
        FROM transport_task_line_tab
       WHERE to_contract           = contract_
         AND to_location_no        = location_no_
         AND part_no               = part_no_
         AND configuration_id      = configuration_id_
         AND serial_no             = serial_no_
         AND lot_batch_no          = lot_batch_no_
         AND eng_chg_level         = eng_chg_level_
         AND waiv_dev_rej_no       = waiv_dev_rej_no_
         AND activity_seq          = activity_seq_
         AND handling_unit_id      = handling_unit_id_
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);

   CURSOR check_inbound_task_pac_id IS
      SELECT 1
        FROM transport_task_line_tab ttl
       WHERE ttl.to_contract            = contract_
         AND ttl.to_location_no         = location_no_
         AND ttl.part_no                = part_no_
         AND ttl.configuration_id       = configuration_id_
         AND ttl.serial_no              = serial_no_
         AND ttl.lot_batch_no           = lot_batch_no_
         AND ttl.eng_chg_level          = eng_chg_level_
         AND ttl.waiv_dev_rej_no        = waiv_dev_rej_no_
         AND ttl.activity_seq           = activity_seq_
         AND ttl.handling_unit_id       = handling_unit_id_
         AND ttl.transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
         AND (NVL(Inventory_Part_In_Stock_API.Get_Move_Dest_Avail_Ctrl_Id(ttl.from_contract,
                                                                          ttl.from_location_no,
                                                                          ttl.to_contract,
                                                                          ttl.to_location_no,
                                                                          ttl.part_no,
                                                                          ttl.configuration_id,
                                                                          ttl.lot_batch_no,
                                                                          ttl.serial_no,
                                                                          ttl.eng_chg_level,
                                                                          ttl.waiv_dev_rej_no,
                                                                          ttl.activity_seq,
                                                                          ttl.handling_unit_id), Database_SYS.string_null_) != NVL(part_availability_control_id_, Database_SYS.string_null_));
BEGIN
   OPEN check_outbound_task;
   FETCH check_outbound_task INTO dummy_;
   IF (check_outbound_task%FOUND) THEN
      task_exist_ := TRUE;
   END IF;
   CLOSE check_outbound_task;

   IF NOT (task_exist_) THEN
      IF (ignore_pac_id_on_inbound_) THEN
         OPEN check_inbound_task_pac_id;
         FETCH check_inbound_task_pac_id INTO dummy_;
         IF (check_inbound_task_pac_id%FOUND) THEN
            task_exist_ := TRUE;
         END IF;
         CLOSE check_inbound_task_pac_id;
      ELSE
         OPEN check_inbound_task;
         FETCH check_inbound_task INTO dummy_;
         IF (check_inbound_task%FOUND) THEN
            task_exist_ := TRUE;
         END IF;
         CLOSE check_inbound_task;
      END IF;
   END IF;

   RETURN (task_exist_);
END Inbound_Or_Outbound_Task_Exist;


@UncheckedAccess
FUNCTION Get_Mrp_Supply(
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN Mrp_Supply_Tab
IS
   mrp_supply_tab_     Mrp_Supply_Tab;
   today_              DATE;
   last_calendar_date_ CONSTANT DATE := Database_Sys.last_calendar_date_;
   
   CURSOR Get_Mrp_Supply IS
     SELECT ttm1.part_no,
            ttm1.transport_task_id,
            today_               trasport_task_date,
            SUM(ttm1.qty_supply) quantity
     FROM   transport_task_manager_local_1    ttm1,
            inventory_part_in_stock_total dest_ipis
     WHERE ttm1.to_contract          = contract_
       AND NVL(ttm1.activity_seq, 0) = 0
       AND ttm1.to_contract          = dest_ipis.contract (+)
       AND ttm1.to_location_no       = dest_ipis.location_no (+)
       AND ttm1.part_no              = dest_ipis.part_no (+)
       AND ttm1.configuration_id     = dest_ipis.configuration_id (+)
       AND ttm1.lot_batch_no         = dest_ipis.lot_batch_no (+)
       AND ttm1.serial_no            = dest_ipis.serial_no (+)
       AND ttm1.eng_chg_level        = dest_ipis.eng_chg_level (+)
       AND ttm1.waiv_dev_rej_no      = dest_ipis.waiv_dev_rej_no (+)
       AND ttm1.activity_seq         = dest_ipis.activity_seq (+)
       AND ttm1.handling_unit_id     = dest_ipis.handling_unit_id (+)
       AND Inventory_Part_In_Stock_API.Get_Move_Dest_Supply_Ctrl_Db(from_contract_    => ttm1.from_contract,
                                                                    from_location_no_ => ttm1.from_location_no,
                                                                    part_no_          => ttm1.part_no,
                                                                    configuration_id_ => ttm1.configuration_id,
                                                                    lot_batch_no_     => ttm1.lot_batch_no,
                                                                    serial_no_        => ttm1.serial_no,
                                                                    eng_chg_level_    => ttm1.eng_chg_level,
                                                                    waiv_dev_rej_no_  => ttm1.waiv_dev_rej_no,
                                                                    activity_seq_     => ttm1.activity_seq,
                                                                    handling_unit_id_ => ttm1.handling_unit_id,
                                                                    to_contract_      => ttm1.to_contract,
                                                                    to_location_no_   => ttm1.to_location_no) = 'NETTABLE'
       AND NVL(dest_ipis.part_ownership_db, ttm1.source_part_ownership) IN ('COMPANY OWNED','CONSIGNMENT')
       AND LEAST(ttm1.source_expiration_date, NVL(dest_ipis.expiration_date, last_calendar_date_)) > today_ + ttm1.dest_min_durab_days
     GROUP BY ttm1.part_no,
              ttm1.transport_task_id,
              ttm1.qty_supply;
              
   -- Almost same SQL as above, but here we are using "AND ttm1.part_no = part_no_" to utilize index in a good way"
   CURSOR Get_Mrp_Supply_By_Part IS
     SELECT ttm1.part_no,
            ttm1.transport_task_id,
            today_               trasport_task_date,
            SUM(ttm1.qty_supply) quantity
     FROM   transport_task_manager_local_1    ttm1,
            inventory_part_in_stock_total dest_ipis
     WHERE ttm1.to_contract          = contract_
       AND ttm1.part_no              = part_no_
       AND NVL(ttm1.activity_seq, 0) = 0
       AND ttm1.to_contract          = dest_ipis.contract (+)
       AND ttm1.to_location_no       = dest_ipis.location_no (+)
       AND ttm1.part_no              = dest_ipis.part_no (+)
       AND ttm1.configuration_id     = dest_ipis.configuration_id (+)
       AND ttm1.lot_batch_no         = dest_ipis.lot_batch_no (+)
       AND ttm1.serial_no            = dest_ipis.serial_no (+)
       AND ttm1.eng_chg_level        = dest_ipis.eng_chg_level (+)
       AND ttm1.waiv_dev_rej_no      = dest_ipis.waiv_dev_rej_no (+)
       AND ttm1.activity_seq         = dest_ipis.activity_seq (+)
       AND ttm1.handling_unit_id     = dest_ipis.handling_unit_id (+)
       AND Inventory_Part_In_Stock_API.Get_Move_Dest_Supply_Ctrl_Db(from_contract_    => ttm1.from_contract,
                                                                    from_location_no_ => ttm1.from_location_no,
                                                                    part_no_          => ttm1.part_no,
                                                                    configuration_id_ => ttm1.configuration_id,
                                                                    lot_batch_no_     => ttm1.lot_batch_no,
                                                                    serial_no_        => ttm1.serial_no,
                                                                    eng_chg_level_    => ttm1.eng_chg_level,
                                                                    waiv_dev_rej_no_  => ttm1.waiv_dev_rej_no,
                                                                    activity_seq_     => ttm1.activity_seq,
                                                                    handling_unit_id_ => ttm1.handling_unit_id,
                                                                    to_contract_      => ttm1.to_contract,
                                                                    to_location_no_   => ttm1.to_location_no) = 'NETTABLE'
       AND NVL(dest_ipis.part_ownership_db, ttm1.source_part_ownership) IN ('COMPANY OWNED','CONSIGNMENT')
       AND LEAST(ttm1.source_expiration_date, NVL(dest_ipis.expiration_date, last_calendar_date_)) > today_ + ttm1.dest_min_durab_days
     GROUP BY ttm1.part_no,
              ttm1.transport_task_id,
              ttm1.qty_supply;
              
BEGIN
   today_ := TRUNC(Site_API.Get_Site_Date(contract_));
   IF part_no_ IS NULL OR part_no_ = '%' THEN -- Site MRP
      OPEN  Get_Mrp_Supply;
      FETCH Get_Mrp_Supply BULK COLLECT INTO mrp_supply_tab_;
      CLOSE Get_Mrp_Supply;
   ELSE -- Selective MRP
      OPEN  Get_Mrp_Supply_By_Part;
      FETCH Get_Mrp_Supply_By_Part BULK COLLECT INTO mrp_supply_tab_;
      CLOSE Get_Mrp_Supply_By_Part;
   END IF; 
   
   RETURN mrp_supply_tab_;
END Get_Mrp_Supply;


@UncheckedAccess
FUNCTION Get_Project_Mrp_Supply (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   project_id_   IN VARCHAR2,
   activity_seq_ IN NUMBER ) RETURN Project_Mrp_Supply_Tab
IS
  pmrp_supply_tab_    Project_Mrp_Supply_Tab;
  today_              DATE;
  last_calendar_date_ CONSTANT DATE := Database_Sys.last_calendar_date_;
  
  CURSOR Get_Project_Mrp_Supply IS
     SELECT ttm1.line_no,
            ttm1.part_no,
            ttm1.transport_task_id,
            today_               transport_task_date,
            SUM(ttm1.qty_supply) quantity,
            ttm1.project_id,
            ttm1.activity_seq
     FROM   transport_task_manager_local_1  ttm1,
            inventory_part_in_stock_total dest_ipis
    WHERE  ttm1.to_contract          = contract_
       AND (ttm1.project_id          =  project_id_ OR project_id_ IS NULL)
       AND (ttm1.activity_seq        =  activity_seq_ OR activity_seq_ IS NULL)
       AND NVL(ttm1.activity_seq, 0) > 0
       AND ttm1.to_contract          = dest_ipis.contract (+)
       AND ttm1.to_location_no       = dest_ipis.location_no (+)
       AND ttm1.part_no              = dest_ipis.part_no (+)
       AND ttm1.configuration_id     = dest_ipis.configuration_id (+)
       AND ttm1.lot_batch_no         = dest_ipis.lot_batch_no (+)
       AND ttm1.serial_no            = dest_ipis.serial_no (+)
       AND ttm1.eng_chg_level        = dest_ipis.eng_chg_level (+)
       AND ttm1.waiv_dev_rej_no      = dest_ipis.waiv_dev_rej_no (+)
       AND ttm1.activity_seq         = dest_ipis.activity_seq (+)
       AND ttm1.handling_unit_id     = dest_ipis.handling_unit_id (+)
       AND Inventory_Part_In_Stock_API.Get_Move_Dest_Supply_Ctrl_Db(from_contract_    => ttm1.from_contract,
                                                                    from_location_no_ => ttm1.from_location_no,
                                                                    part_no_          => ttm1.part_no,
                                                                    configuration_id_ => ttm1.configuration_id,
                                                                    lot_batch_no_     => ttm1.lot_batch_no,
                                                                    serial_no_        => ttm1.serial_no,
                                                                    eng_chg_level_    => ttm1.eng_chg_level,
                                                                    waiv_dev_rej_no_  => ttm1.waiv_dev_rej_no,
                                                                    activity_seq_     => ttm1.activity_seq,
                                                                    handling_unit_id_ => ttm1.handling_unit_id,
                                                                    to_contract_      => ttm1.to_contract,
                                                                    to_location_no_   => ttm1.to_location_no) = 'NETTABLE'
       AND NVL(dest_ipis.part_ownership_db, ttm1.source_part_ownership) IN ('COMPANY OWNED','CONSIGNMENT')
       AND LEAST(ttm1.source_expiration_date, NVL(dest_ipis.expiration_date, last_calendar_date_)) > today_ + ttm1.dest_min_durab_days
     GROUP BY ttm1.line_no,
              ttm1.part_no,
              ttm1.transport_task_id,
              ttm1.qty_supply,
              ttm1.project_id,
              ttm1.activity_seq;
   
   -- Almost same SQL as above, but here we are using "AND ttm1.part_no = part_no_" to utilize index in a good way"
   CURSOR Get_Project_Mrp_Supply_By_Part IS
     SELECT ttm1.line_no,
            ttm1.part_no,
            ttm1.transport_task_id,
            today_               transport_task_date,
            SUM(ttm1.qty_supply) quantity,
            ttm1.project_id,
            ttm1.activity_seq
     FROM   transport_task_manager_local_1  ttm1,
            inventory_part_in_stock_total dest_ipis
    WHERE  ttm1.to_contract          = contract_
       AND ttm1.part_no              = part_no_
       AND (ttm1.project_id          =  project_id_ OR project_id_ IS NULL)
       AND (ttm1.activity_seq        =  activity_seq_ OR activity_seq_ IS NULL)
       AND NVL(ttm1.activity_seq, 0) > 0
       AND ttm1.to_contract          = dest_ipis.contract (+)
       AND ttm1.to_location_no       = dest_ipis.location_no (+)
       AND ttm1.part_no              = dest_ipis.part_no (+)
       AND ttm1.configuration_id     = dest_ipis.configuration_id (+)
       AND ttm1.lot_batch_no         = dest_ipis.lot_batch_no (+)
       AND ttm1.serial_no            = dest_ipis.serial_no (+)
       AND ttm1.eng_chg_level        = dest_ipis.eng_chg_level (+)
       AND ttm1.waiv_dev_rej_no      = dest_ipis.waiv_dev_rej_no (+)
       AND ttm1.activity_seq         = dest_ipis.activity_seq (+)
       AND ttm1.handling_unit_id     = dest_ipis.handling_unit_id (+)
       AND Inventory_Part_In_Stock_API.Get_Move_Dest_Supply_Ctrl_Db(from_contract_    => ttm1.from_contract,
                                                                    from_location_no_ => ttm1.from_location_no,
                                                                    part_no_          => ttm1.part_no,
                                                                    configuration_id_ => ttm1.configuration_id,
                                                                    lot_batch_no_     => ttm1.lot_batch_no,
                                                                    serial_no_        => ttm1.serial_no,
                                                                    eng_chg_level_    => ttm1.eng_chg_level,
                                                                    waiv_dev_rej_no_  => ttm1.waiv_dev_rej_no,
                                                                    activity_seq_     => ttm1.activity_seq,
                                                                    handling_unit_id_ => ttm1.handling_unit_id,
                                                                    to_contract_      => ttm1.to_contract,
                                                                    to_location_no_   => ttm1.to_location_no) = 'NETTABLE'
       AND NVL(dest_ipis.part_ownership_db, ttm1.source_part_ownership) IN ('COMPANY OWNED','CONSIGNMENT')
       AND LEAST(ttm1.source_expiration_date, NVL(dest_ipis.expiration_date, last_calendar_date_)) > today_ + ttm1.dest_min_durab_days
     GROUP BY ttm1.line_no,
              ttm1.part_no,
              ttm1.transport_task_id,
              ttm1.qty_supply,
              ttm1.project_id,
              ttm1.activity_seq;
              
BEGIN
   today_ := TRUNC(Site_API.Get_Site_Date(contract_));
   IF part_no_ IS NULL OR part_no_ = '%' THEN -- Site PMRP
      OPEN  Get_Project_Mrp_Supply;
      FETCH Get_Project_Mrp_Supply BULK COLLECT INTO pmrp_supply_tab_;
      CLOSE Get_Project_Mrp_Supply;
   ELSE -- Selective PMRP
      OPEN  Get_Project_Mrp_Supply_By_Part;
      FETCH Get_Project_Mrp_Supply_By_Part BULK COLLECT INTO pmrp_supply_tab_;
      CLOSE Get_Project_Mrp_Supply_By_Part;
   END IF;
   RETURN pmrp_supply_tab_;
END Get_Project_Mrp_Supply;


@UncheckedAccess
FUNCTION Warehouse_Task_Is_Started_Db (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   warehouse_task_is_started_ VARCHAR2(5) := Fnd_Boolean_API.db_false;
BEGIN
   IF (Transport_Task_Manager_API.Warehouse_Task_Is_Started_(transport_task_id_)) THEN
      warehouse_task_is_started_ := Fnd_Boolean_API.db_true;
   END IF;

   RETURN (warehouse_task_is_started_);
END Warehouse_Task_Is_Started_Db;


PROCEDURE Set_Transport_Locations (
   forward_to_location_no_ OUT    VARCHAR2,   
   to_location_no_         IN OUT VARCHAR2,
   from_contract_          IN     VARCHAR2,
   from_location_no_       IN     VARCHAR2,
   to_contract_            IN     VARCHAR2,
   part_no_                IN     VARCHAR2,
   configuration_id_       IN     VARCHAR2,
   order_type_             IN     VARCHAR2,
   order_ref1_             IN     VARCHAR2,
   order_ref2_             IN     VARCHAR2,
   order_ref3_             IN     VARCHAR2,
   order_ref4_             IN     VARCHAR2,
   pick_list_no_           IN     VARCHAR2,
   shipment_id_            IN     NUMBER,      
   lot_batch_no_           IN     VARCHAR2,
   serial_no_              IN     VARCHAR2,
   eng_chg_level_          IN     VARCHAR2,
   waiv_dev_rej_no_        IN     VARCHAR2,
   quantity_               IN     NUMBER,
   activity_seq_           IN     NUMBER,
   handling_unit_id_       IN     NUMBER,
   allways_use_drop_off_   IN     BOOLEAN  DEFAULT FALSE,
   reserved_by_source_db_  IN     VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS
   drop_off_locations_         Warehouse_Bay_Bin_API.Location_No_Tab;
   no_of_drop_off_locations_   NUMBER;
   is_valid_drop_off_location_ BOOLEAN := FALSE;
   auto_dropof_man_trans_task_ VARCHAR2(5);
BEGIN   
   auto_dropof_man_trans_task_ := Site_Invent_Info_API.Get_Auto_Dropof_Man_Trans_T_Db(to_contract_);
   IF (auto_dropof_man_trans_task_ = Fnd_Boolean_API.DB_TRUE OR allways_use_drop_off_) THEN
      Get_Drop_Off_Location_No___(drop_off_locations_, from_contract_, from_location_no_, to_contract_, to_location_no_);
      no_of_drop_off_locations_ := drop_off_locations_.COUNT;
      IF (no_of_drop_off_locations_ > 0) THEN
         -- Loop through the list of drop off locations to find the "nearest" valid one.
         FOR i_ IN REVERSE drop_off_locations_.FIRST..drop_off_locations_.LAST LOOP   
            is_valid_drop_off_location_ := Is_Valid_Drop_Off_Location___(from_contract_,
                                                                         from_location_no_,
                                                                         part_no_,
                                                                         configuration_id_,
                                                                         to_contract_,
                                                                         drop_off_locations_(i_),
                                                                         order_type_,
                                                                         order_ref1_,
                                                                         order_ref2_,
                                                                         order_ref3_,
                                                                         order_ref4_,
                                                                         pick_list_no_,
                                                                         shipment_id_,
                                                                         lot_batch_no_,
                                                                         serial_no_,
                                                                         eng_chg_level_,
                                                                         waiv_dev_rej_no_,
                                                                         quantity_,
                                                                         activity_seq_,
                                                                         handling_unit_id_,
                                                                         reserved_by_source_db_);
            IF (is_valid_drop_off_location_) THEN
               forward_to_location_no_ := to_location_no_;
               to_location_no_         := drop_off_locations_(i_);
            END IF;
            EXIT WHEN is_valid_drop_off_location_;
         END LOOP;
      END IF;
   END IF;
END Set_Transport_Locations;


PROCEDURE New_Or_Add_To_Existing (
   transport_task_id_          IN OUT NUMBER,
   quantity_added_                OUT NUMBER,
   serials_added_                 OUT Part_Serial_Catalog_API.Serial_No_Tab,
   part_no_                    IN     VARCHAR2,
   configuration_id_           IN     VARCHAR2,
   from_contract_              IN     VARCHAR2,
   from_location_no_           IN     VARCHAR2,
   to_contract_                IN     VARCHAR2,
   to_location_no_             IN     VARCHAR2,
   destination_                IN     VARCHAR2,
   order_type_                 IN     VARCHAR2,
   order_ref1_                 IN     VARCHAR2,
   order_ref2_                 IN     VARCHAR2,
   order_ref3_                 IN     VARCHAR2,
   order_ref4_                 IN     VARCHAR2,
   pick_list_no_               IN     VARCHAR2,
   shipment_id_                IN     NUMBER,   
   lot_batch_no_               IN     VARCHAR2,
   serial_no_tab_              IN     Part_Serial_Catalog_API.Serial_No_Tab,
   eng_chg_level_              IN     VARCHAR2,
   waiv_dev_rej_no_            IN     VARCHAR2,
   activity_seq_               IN     NUMBER,
   handling_unit_id_           IN     NUMBER,
   quantity_to_add_            IN     NUMBER,
   requested_date_finished_    IN     DATE     DEFAULT NULL,
   note_text_                  IN     VARCHAR2 DEFAULT NULL,
   allow_deviating_avail_ctrl_ IN     VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   reserved_by_source_db_      IN     VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   check_storage_requirements_ IN     BOOLEAN  DEFAULT FALSE )
IS
   destination_db_                VARCHAR2(200);
   order_type_db_                 VARCHAR2(200);
   local_to_location_no_          VARCHAR2(35);
   forward_to_location_no_        VARCHAR2(35);
   local_serial_no_               transport_task_line_tab.serial_no%TYPE := '*';
BEGIN
   order_type_db_        := Order_Type_API.Encode(order_type_);
   destination_db_       := Inventory_Part_Destination_API.Encode(destination_);
   local_to_location_no_ := to_location_no_;
   IF (serial_no_tab_.COUNT > 0) THEN
      local_serial_no_ := serial_no_tab_(serial_no_tab_.FIRST).serial_no;
   END IF;
   
   IF (transport_task_id_ IS NULL) THEN
      Transport_Task_API.Find_Or_Create_New_Task(
         transport_task_id_        => transport_task_id_,
         part_no_                  => part_no_,
         configuration_id_         => configuration_id_,
         from_contract_            => from_contract_,
         from_location_no_         => from_location_no_,
         to_contract_              => to_contract_,
         to_location_no_           => to_location_no_,
         destination_              => destination_,
         order_type_               => order_type_,
         order_ref1_               => order_ref1_,
         order_ref2_               => order_ref2_,
         order_ref3_               => order_ref3_,
         order_ref4_               => order_ref4_,
         pick_list_no_             => pick_list_no_,
         shipment_id_              => shipment_id_,   
         lot_batch_no_             => lot_batch_no_,
         serial_no_                => local_serial_no_,
         eng_chg_level_            => eng_chg_level_,
         waiv_dev_rej_no_          => waiv_dev_rej_no_,
         activity_seq_             => activity_seq_,
         handling_unit_id_         => handling_unit_id_,
         quantity_to_add_          => quantity_to_add_,
         note_text_                => note_text_,
         reserved_by_source_db_    => reserved_by_source_db_);
   END IF;

   Transport_Task_Manager_API.Set_Transport_Locations(
      forward_to_location_no_ => forward_to_location_no_,
      to_location_no_         => local_to_location_no_,
      from_contract_          => from_contract_,
      from_location_no_       => from_location_no_,
      to_contract_            => to_contract_,
      part_no_                => part_no_,
      configuration_id_       => configuration_id_,
      order_type_             => order_type_db_,
      order_ref1_             => order_ref1_,   
      order_ref2_             => order_ref2_,
      order_ref3_             => order_ref3_,
      order_ref4_             => order_ref4_,
      pick_list_no_           => pick_list_no_,
      shipment_id_            => shipment_id_,
      lot_batch_no_           => lot_batch_no_,
      serial_no_              => local_serial_no_,
      eng_chg_level_          => eng_chg_level_,
      waiv_dev_rej_no_        => waiv_dev_rej_no_,
      quantity_               => quantity_to_add_,
      activity_seq_           => activity_seq_,
      handling_unit_id_       => handling_unit_id_,
      allways_use_drop_off_   => TRUE,
      reserved_by_source_db_  => reserved_by_source_db_);

   Transport_Task_Line_API.New_Or_Add_To_Existing_(
      quantity_added_                => quantity_added_,
      serials_added_                 => serials_added_,
      transport_task_id_             => transport_task_id_,
      part_no_                       => part_no_,
      configuration_id_              => configuration_id_,
      from_contract_                 => from_contract_,
      from_location_no_              => from_location_no_,
      to_contract_                   => to_contract_,
      to_location_no_                => local_to_location_no_,
      forward_to_location_no_        => forward_to_location_no_,
      destination_db_                => destination_db_,
      order_type_db_                 => order_type_db_,
      order_ref1_                    => order_ref1_,
      order_ref2_                    => order_ref2_,
      order_ref3_                    => order_ref3_,
      order_ref4_                    => order_ref4_,
      pick_list_no_                  => pick_list_no_,
      shipment_id_                   => shipment_id_,                                                   
      lot_batch_no_                  => lot_batch_no_,
      serial_no_tab_                 => serial_no_tab_,
      eng_chg_level_                 => eng_chg_level_,
      waiv_dev_rej_no_               => waiv_dev_rej_no_,
      activity_seq_                  => activity_seq_,
      handling_unit_id_              => handling_unit_id_,
      quantity_to_add_               => quantity_to_add_,
      catch_quantity_to_add_         => NULL,
      requested_date_finished_       => requested_date_finished_,
      allow_deviating_avail_ctrl_    => allow_deviating_avail_ctrl_,
      reserved_by_source_db_         => reserved_by_source_db_,
      check_storage_requirements_    => check_storage_requirements_);
END New_Or_Add_To_Existing;

