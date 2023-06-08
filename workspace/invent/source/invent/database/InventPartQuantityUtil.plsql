-----------------------------------------------------------------------------
--
--  Logical unit: InventPartQuantityUtil
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211110  Aabalk  SC21R2-5899, Added type Ship_Reserv_Handl_Unit_Rec and Ship_Reserv_Handl_Unit_Tab, modified Unreserve_Stock___ and Reserve_Stock___ methods 
--  211027          to reattach shipment handling unit reservations after move stock operation,
--  201014  Asawlk  Bug 155296(SCZ-11820), Added method Set_Serial_Traked_In_Inv___ and called it inside Move_part() in order to temporary set the tracked_in_inventory  
--  201014          flag in part_serial_catalog for only receipt and issue tracked serials to stop merging identified serial record to stock record with serial = '*'. 
--  201014          Later reset the flag.
--  200311  RoJalk  SCSPRING20-1930, Modified Unreserve_Stock___ to support Shipment Order. 
--  191023  SBalLK  Bug 150436 (SCZ-6914), Added Add_Source_Ref_If_Not_Exists___() method and modified Reserve_Stock___() method to update location group in
--  191023          warehouse task when whole pick list connected reservation move to diffrent location group.
--  180209  KHVESE  STRSC-16657, Added new parameter calling_process_ to the method Validate_Move_Reservation and modified the method to give different 
--  180209          messages depending on calling_process_ value. Also added public constant new_or_add_to_transport_task_.
--  180209  ChFolk  STRSC-16519, Removed method Raise_Not_Possible_To_Move___ and Modifed method Validate_Move_Reservation to give different messages
--  180209          depending on the move_reservation_option in site level and pick reported.
--  180208  KHVESE  STRSC-16772, Modified method Move_Part to add extra check for serial no befor call to the method Reserve_Stock___.
--  171204  ChFolk  STRSC-14036, Made the common error message in Unreserve_Stock___ by calling the method Raise_Move_To_Location_Error.
--  171120  ChFolk  STRSC-14036, Added new parameter to_location_type_db_ to Unreserve_Stock___ to validate some demand types when moving 
--  171120          to different location types than picking. Modifed the customer order specific error message in Reserve_Stock___ to a common message.
--  171025  JeLise  STRSC-13216, Added pick_by_choice_blocked_ in call to Inv_Part_Stock_Reservation_API.Reserve_Stock in Reserve_Stock___.
--  170726  ChJalk  Bug, Modified Move_Part to add the parameter availability_ctrl_id_.
--  170608  JoAnSe  LIM-10663, Changes in Validate_Move_Reservation to allow transport task for material reserved to a shop order.
--  170529  Asawlk  STRSC-8703, Modified Reserve_Stock___() and Unreserve_Stock___() by changing condition from (reserved_qty_ IS NOT NULL) to (reserved_qty_ !=0) 
--  170529          to determine whether the reservation or unreservation is successful. Also modified Unreserve_Stock___() to optimize the splitting of reservations.
--  170503  UdGnlk  LIM-11456, Modified Inv_Part_Stock_Reservation_API.Reserve_Stock() passing parameter order_supply_demand_type_db instead order_supply_demand_type. 
--  170427  KhVese  STRSC-7211, Removed method Make_CO_Reservation and modified methods Unreserve_Stock___() and Reserve_Stock___().
--  170215  MaEelk  LIM-10398, Changed the errror message in Have_Enough_Qty_For_Move___
--  170203  JoAnSe  LIM-10607, Changed Unreserve_Stock___, Reserve_Stock___ and Validate_Move_Reservation to enable move of material reserved to Shop Order 
--  170127  UdGnlk  LIM-10371, Rename Validate_Move_Reservation() to public method and modified New_Or_Add_To_Existing() to lock and fetch information
--  170127          to validate move reservation.   .  
--  161209  Asawlk  LIM-9965, Modified Move_Part() by adding parameter reserved_stock_rec_ to support the sceanrios where the reservation info in known. 
--  161205  Asawlk  LIM-9921, Modified Make_CO_Reservation___ in order to use Reserve_Customer_Order_API.Reserve_Manually for both 
--  161205          reservations and un-reservations.
--  161012  Asawlk  LIM-8698, Modified Make_CO_Reservation___ in order to use Reserve_Customer_Order_API.Unreserve_Manually and 
--  161012          Reserve_Customer_Order_API.Make_Additional_Reservation for customer order un-reservations and reservations respectively.
--  160915  Asawlk  LIM-8698, Added methods Move_Part, Have_Enough_Qty_For_Move___, Unreserve_Stock___, Reserve_Stock___ and Make_CO_Reservation___
--  160915          in order to facilitate moving reserved/un-reserved stocks.
--  130910  UdGnlk  EBALL-168, Modified Check_Part_Exist() by adding RETURN statement.
--  130627  AwWelk  EBALL-140, Modified Check_Quantity_Exist() by correcting the parameters passed to the 
--  130627          Inventory_Part_In_Stock_API.Check_Quantity_Exist().
--  130522  Asawlk  EBALL-37, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

new_or_add_to_transport_task_        CONSTANT NUMBER := 1;

TYPE Ship_Reserv_Handl_Unit_Rec IS RECORD
  (source_ref1                    VARCHAR2(50),
   source_ref2                    VARCHAR2(50),
   source_ref3                    VARCHAR2(50),
   source_ref4                    VARCHAR2(50),
   contract                       VARCHAR2(5),
   part_no                        VARCHAR2(25),
   location_no                    VARCHAR2(35),
   lot_batch_no                   VARCHAR2(20),
   serial_no                      VARCHAR2(50),
   eng_chg_level                  VARCHAR2(6),
   waiv_dev_rej_no                VARCHAR2(15),
   activity_seq                   NUMBER,
   reserv_handling_unit_id        NUMBER,
   configuration_id               VARCHAR2(50),
   pick_list_no                   VARCHAR2(15),
   shipment_id                    NUMBER,
   shipment_line_no               NUMBER,
   handling_unit_id               NUMBER,
   quantity                       NUMBER,
   catch_qty_to_reassign          NUMBER);
   
TYPE Ship_Reserv_Handl_Unit_Tab IS TABLE OF Ship_Reserv_Handl_Unit_Rec INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------
TYPE Pick_List_No_Tab IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Merge_Config_Lot_Serial_Tab___(
   stock_tab_   IN Inventory_Part_In_Stock_API.Config_lot_Serial_Tab,
   transit_tab_ IN Inventory_Part_In_Stock_API.Config_lot_Serial_Tab ) RETURN Inventory_Part_In_Stock_API.Config_lot_Serial_Tab
IS
   merged_ix_             PLS_INTEGER;
   missing_in_merged_tab_ BOOLEAN;
   merged_tab_            Inventory_Part_In_Stock_API.Config_Lot_Serial_Tab;

BEGIN
   merged_tab_ := stock_tab_;

   IF (transit_tab_.COUNT > 0) THEN
      FOR i IN transit_tab_.FIRST..transit_tab_.LAST LOOP
         missing_in_merged_tab_ := TRUE;
         merged_ix_              := 0;
         IF (merged_tab_.COUNT > 0) THEN
            FOR j IN merged_tab_.FIRST..merged_tab_.LAST LOOP
               IF((transit_tab_(i).configuration_id = merged_tab_(j).configuration_id) AND
                  (transit_tab_(i).lot_batch_no     = merged_tab_(j).lot_batch_no)     AND
                  (transit_tab_(i).serial_no        = merged_tab_(j).serial_no))       THEN  
                         
                 merged_tab_(j).quantity := merged_tab_(j).quantity + transit_tab_(i).quantity;
                 missing_in_merged_tab_  := FALSE;
                 EXIT;
               END IF;
               merged_ix_ := j;
            END LOOP;
         END IF;
         IF (missing_in_merged_tab_) THEN
            merged_ix_ := merged_ix_ + 1;
            merged_tab_(merged_ix_).configuration_id := transit_tab_(i).configuration_id; 
            merged_tab_(merged_ix_).lot_batch_no     := transit_tab_(i).lot_batch_no;
            merged_tab_(merged_ix_).serial_no        := transit_tab_(i).serial_no;
            merged_tab_(merged_ix_).quantity         := transit_tab_(i).quantity; 
         END IF;
      END LOOP;
   END IF;

   RETURN (merged_tab_);
END Merge_Config_Lot_Serial_Tab___;

PROCEDURE Have_Enough_Qty_For_Move___ (qty_to_move_               IN NUMBER,
                                       inv_part_stock_res_tab_    IN Inv_Part_Stock_Reservation_API.Inv_Part_In_Stock_Res_Table)
IS
   reserved_qty_in_stock_  NUMBER:= 0;
BEGIN
   IF inv_part_stock_res_tab_.COUNT > 0 THEN
      FOR i IN inv_part_stock_res_tab_.FIRST..inv_part_stock_res_tab_.LAST LOOP
         reserved_qty_in_stock_ := reserved_qty_in_stock_ + inv_part_stock_res_tab_(i).qty_reserved;
      END LOOP;            
   END IF;
   IF (reserved_qty_in_stock_< qty_to_move_ ) THEN
      Error_SYS.Record_General(lu_name_, 'RESEEXIST: There exist reservations that cannot be moved.');
   END IF;   
END Have_Enough_Qty_For_Move___;

PROCEDURE Unreserve_Stock___ ( shipment_reserv_handl_unit_tab_       OUT Ship_Reserv_Handl_Unit_Tab,
                               stock_reservation_info_tab_        IN OUT Inv_Part_Stock_Reservation_API.Inv_Part_In_Stock_Res_Table,   
                               quantity_to_unreserve_             IN     NUMBER,
                               to_location_type_db_               IN     VARCHAR2 )
IS 
   quantity_to_unreserve_local_        NUMBER := quantity_to_unreserve_;
   j_                                  NUMBER := 1;
   reserved_qty_                       NUMBER;   
   unreserved_stock_tab_               Inv_Part_Stock_Reservation_API.Inv_Part_In_Stock_Res_Table;
   shipment_reserv_handl_unit_tab2_    Ship_Reserv_Handl_Unit_Tab;
   split_reservation_                  BOOLEAN := FALSE;
   exit_procedure                      EXCEPTION;   
BEGIN   
   IF (stock_reservation_info_tab_.COUNT > 0 ) THEN
      FOR i IN stock_reservation_info_tab_.FIRST..stock_reservation_info_tab_.LAST LOOP
         -- Passed the LEAST(stock_reservation_info_tab_(i).qty_reserved,  quantity_to_unreserve_local_) as the quantity_to_reserve_ in order to support the
         -- splitting of reservations.
         IF ((stock_reservation_info_tab_(i).order_supply_demand_type_db IN (Order_Supply_Demand_Type_API.DB_CUST_ORDER,
                                                                             Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES,
                                                                             Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER,
                                                                             Order_Supply_Demand_Type_API.DB_MATERIAL_REQ)) AND (to_location_type_db_ != Inventory_Location_Type_API.DB_PICKING)) THEN
            Inventory_Part_In_Stock_API.Raise_Move_To_Location_Error(Order_Supply_Demand_Type_API.Get_Order_Type_Db(stock_reservation_info_tab_(i).order_supply_demand_type_db), to_location_type_db_); 
         END IF;                                                                     
         
         
         IF stock_reservation_info_tab_(i).shipment_id != 0 THEN
            $IF Component_Shpmnt_SYS.INSTALLED $THEN
               shipment_reserv_handl_unit_tab2_ :=  Shipment_Reserv_Handl_Unit_API.Get_Hus_Per_Reservation (stock_reservation_info_tab_(i).order_no,
                                                                                                            stock_reservation_info_tab_(i).line_no,
                                                                                                            stock_reservation_info_tab_(i).release_no,
                                                                                                            stock_reservation_info_tab_(i).line_item_no,
                                                                                                            stock_reservation_info_tab_(i).order_supply_demand_type_db,
                                                                                                            stock_reservation_info_tab_(i).part_no,
                                                                                                            stock_reservation_info_tab_(i).contract,
                                                                                                            stock_reservation_info_tab_(i).configuration_id,
                                                                                                            stock_reservation_info_tab_(i).location_no,
                                                                                                            stock_reservation_info_tab_(i).lot_batch_no,
                                                                                                            stock_reservation_info_tab_(i).serial_no,
                                                                                                            stock_reservation_info_tab_(i).eng_chg_level,
                                                                                                            stock_reservation_info_tab_(i).waiv_dev_rej_no,                  
                                                                                                            stock_reservation_info_tab_(i).activity_seq,
                                                                                                            stock_reservation_info_tab_(i).handling_unit_id,
                                                                                                            stock_reservation_info_tab_(i).shipment_id,
                                                                                                            stock_reservation_info_tab_(i).pick_list_no);
            $ELSE
               Error_SYS.Component_Not_Exist('SHPMNT');
            $END
         END IF;
         
         
         Inv_Part_Stock_Reservation_API.Reserve_Stock(quantity_reserved_         => reserved_qty_,
                                                      input_qty_                 => stock_reservation_info_tab_(i).co_res_input_qty,
                                                      input_unit_meas_           => stock_reservation_info_tab_(i).co_res_input_unit_meas,
                                                      input_conv_factor_         => stock_reservation_info_tab_(i).co_res_input_conv_factor,
                                                      input_variable_values_     => stock_reservation_info_tab_(i).co_res_input_variable_values,
                                                      source_ref1_               => stock_reservation_info_tab_(i).order_no,
                                                      source_ref2_               => stock_reservation_info_tab_(i).line_no,
                                                      source_ref3_               => stock_reservation_info_tab_(i).release_no,
                                                      source_ref4_               => stock_reservation_info_tab_(i).line_item_no,
                                                      source_ref_type_db_        => stock_reservation_info_tab_(i).order_supply_demand_type_db,
                                                      contract_                  => stock_reservation_info_tab_(i).contract,
                                                      part_no_                   => stock_reservation_info_tab_(i).part_no,
                                                      location_no_               => stock_reservation_info_tab_(i).location_no,
                                                      lot_batch_no_              => stock_reservation_info_tab_(i).lot_batch_no,
                                                      serial_no_                 => stock_reservation_info_tab_(i).serial_no,
                                                      eng_chg_level_             => stock_reservation_info_tab_(i).eng_chg_level,
                                                      waiv_dev_rej_no_           => stock_reservation_info_tab_(i).waiv_dev_rej_no,
                                                      activity_seq_              => stock_reservation_info_tab_(i).activity_seq,
                                                      handling_unit_id_          => stock_reservation_info_tab_(i).handling_unit_id,
                                                      configuration_id_          => stock_reservation_info_tab_(i).configuration_id,
                                                      pick_list_no_              => stock_reservation_info_tab_(i).pick_list_no,
                                                      shipment_id_               => stock_reservation_info_tab_(i).shipment_id,
                                                      quantity_to_reserve_       => LEAST(stock_reservation_info_tab_(i).qty_reserved,  quantity_to_unreserve_local_)* -1,
                                                      reservation_operation_id_  => Inv_Part_Stock_Reservation_API.move_reservation_);
         
         -- We assume the unreservation is successful if reserved_qty_ is not zero. 
         IF (reserved_qty_ != 0) THEN                                                                                                     
            unreserved_stock_tab_(j_) := stock_reservation_info_tab_(i);
            -- Check whether a splitting of reservation have already taken place.
            -- If so, adjust the unreserved quantity accordingly.
            IF (stock_reservation_info_tab_(i).qty_reserved > quantity_to_unreserve_local_) THEN
               unreserved_stock_tab_(j_).qty_reserved := quantity_to_unreserve_local_; 
               split_reservation_ := TRUE;
            END IF;   
            j_ := j_ + 1;
            quantity_to_unreserve_local_ := (quantity_to_unreserve_local_ - (reserved_qty_* -1));
         END IF;
         
         IF stock_reservation_info_tab_(i).shipment_id != 0 THEN
            shipment_reserv_handl_unit_tab_ := Get_Ship_Reserv_Hus_To_Reattach___(shipment_reserv_handl_unit_tab_, shipment_reserv_handl_unit_tab2_, split_reservation_, unreserved_stock_tab_(j_ - 1).qty_reserved);
         END IF;
         split_reservation_ := FALSE;
         -- This should be the last statement in the LOOP since it evaluates the exit condition and assignes values to the OUT parameter if the condition has successfully met.
         -- If nothing to be reserved more, then exit the method.
         IF (quantity_to_unreserve_local_ = 0) THEN
            RAISE exit_procedure;
         END IF;   
      END LOOP;
      -- If we still have qty remaining then the move cannot be performed. 
      IF (quantity_to_unreserve_local_ > 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTENOUGHQTY: Insufficient stock to move.');   
      END IF; 
   END IF;
EXCEPTION
   WHEN exit_procedure THEN
      -- Now we are assigning back what has already been unreserved.
      stock_reservation_info_tab_ := unreserved_stock_tab_;
END Unreserve_Stock___;

PROCEDURE Reserve_Stock___ (shipment_reserv_handl_unit_tab_       IN OUT Ship_Reserv_Handl_Unit_Tab,
                            stock_reservation_info_tab_           IN     Inv_Part_Stock_Reservation_API.Inv_Part_In_Stock_Res_Table,
                            qty_to_reserve_                       IN     NUMBER,
                            to_location_                          IN     VARCHAR2,
                            to_waiv_dev_rej_no_                   IN     VARCHAR2,
                            unattached_from_handling_unit_        IN     VARCHAR2)
IS
   total_reserved_qty_         NUMBER := 0;
   reserved_qty_               NUMBER;
   stock_res_info_tab_local_   Inv_Part_Stock_Reservation_API.Inv_Part_In_Stock_Res_Table := stock_reservation_info_tab_;
   pick_list_no_tab_                   Pick_List_No_Tab;
   co_picklist_wh_task_status_db_      VARCHAR2(30);
   customer_order_pick_list_task_type_ VARCHAR2(300) := Warehouse_Task_Type_API.Decode(Warehouse_Task_Type_API.DB_CUSTOMER_ORDER_PICK_LIST);
   from_location_group_                VARCHAR2(5);
   to_location_group_                  VARCHAR2(5);
   single_location_group_              BOOLEAN;
   warehouse_task_id_                  NUMBER;
BEGIN   
   IF (stock_res_info_tab_local_.COUNT > 0 ) THEN
      co_picklist_wh_task_status_db_ := Warehouse_Task_Type_Setup_API.Get_Status_Db(stock_res_info_tab_local_(1).contract, customer_order_pick_list_task_type_);
      to_location_group_             := Warehouse_Bay_Bin_API.Get_Loc_Group_By_Site_Location(stock_res_info_tab_local_(1).contract, to_location_);
      FOR i IN stock_res_info_tab_local_.FIRST..stock_res_info_tab_local_.LAST LOOP
         Inv_Part_Stock_Reservation_API.Reserve_Stock(quantity_reserved_         => reserved_qty_,
                                                      input_qty_                 => stock_res_info_tab_local_(i).co_res_input_qty,
                                                      input_unit_meas_           => stock_res_info_tab_local_(i).co_res_input_unit_meas,
                                                      input_conv_factor_         => stock_res_info_tab_local_(i).co_res_input_conv_factor,
                                                      input_variable_values_     => stock_res_info_tab_local_(i).co_res_input_variable_values,
                                                      source_ref1_               => stock_res_info_tab_local_(i).order_no,
                                                      source_ref2_               => stock_res_info_tab_local_(i).line_no,
                                                      source_ref3_               => stock_res_info_tab_local_(i).release_no,
                                                      source_ref4_               => stock_res_info_tab_local_(i).line_item_no,
                                                      source_ref_type_db_        => stock_res_info_tab_local_(i).order_supply_demand_type_db,
                                                      contract_                  => stock_res_info_tab_local_(i).contract,
                                                      part_no_                   => stock_res_info_tab_local_(i).part_no,
                                                      location_no_               => to_location_,
                                                      lot_batch_no_              => stock_res_info_tab_local_(i).lot_batch_no,
                                                      serial_no_                 => stock_res_info_tab_local_(i).serial_no,
                                                      eng_chg_level_             => stock_res_info_tab_local_(i).eng_chg_level,
                                                      waiv_dev_rej_no_           => to_waiv_dev_rej_no_,
                                                      activity_seq_              => stock_res_info_tab_local_(i).activity_seq,
                                                      handling_unit_id_          => stock_res_info_tab_local_(i).handling_unit_id,
                                                      configuration_id_          => stock_res_info_tab_local_(i).configuration_id,
                                                      pick_list_no_              => stock_res_info_tab_local_(i).pick_list_no,
                                                      shipment_id_               => stock_res_info_tab_local_(i).shipment_id,
                                                      quantity_to_reserve_       => stock_res_info_tab_local_(i).qty_reserved,
                                                      reservation_operation_id_  => Inv_Part_Stock_Reservation_API.move_reservation_,
                                                      pick_by_choice_blocked_    => stock_res_info_tab_local_(i).pick_by_choice_blocked);
         -- Collect unique pick list numbers connected to customer order reservations which are moving between different location groups.
         IF (stock_res_info_tab_local_(i).order_supply_demand_type_db = Order_Supply_Demand_Type_API.DB_CUST_ORDER) THEN
            IF ((stock_res_info_tab_local_(i).pick_list_no != '*') AND (co_picklist_wh_task_status_db_ = Task_Setup_Status_API.DB_ACTIVE)) THEN
               from_location_group_ := Warehouse_Bay_Bin_API.Get_Loc_Group_By_Site_Location( stock_res_info_tab_local_(i).contract,
                                                                                             stock_res_info_tab_local_(i).location_no);
               IF (from_location_group_ != to_location_group_) THEN
                  Add_Pick_List_If_Not_Exists___(pick_list_no_tab_, stock_res_info_tab_local_(i).pick_list_no);
               END IF;
            END IF;
         END IF;

         -- We assume the reservation is successful if reserved_qty_ is not zero. 
         IF (reserved_qty_ != 0) THEN
            total_reserved_qty_ := total_reserved_qty_ + reserved_qty_;
         END IF;         
      END LOOP;
      IF (qty_to_reserve_ != total_reserved_qty_) THEN
         Error_SYS.Record_General(lu_name_, 'UNABLETORES: Unable to recreate the source reservations at the destination location.');
      END IF;   
      
      -- Validate and update location group on warehouse tasks which are completely moved to new location group.
      IF (pick_list_no_tab_.count > 0) THEN
         FOR i IN pick_list_no_tab_.FIRST..pick_list_no_tab_.LAST LOOP
            single_location_group_ := FALSE;
            $IF Component_Order_SYS.INSTALLED $THEN
               single_location_group_ := Customer_Order_Pick_List_API.Homogeneous_Location_Group(pick_list_no_tab_(i));
            $ELSE
               Error_SYS.Component_Not_Exist('ORDER');
               -- Customer Order component not installed.
            $END
            
            IF (single_location_group_) THEN
               warehouse_task_id_ := Warehouse_Task_API.Get_Task_Id_From_Source( stock_res_info_tab_local_(1).contract,
                                                                                 customer_order_pick_list_task_type_,
                                                                                 pick_list_no_tab_(i),
                                                                                 NULL, NULL, NULL);
               IF(warehouse_task_id_ IS NOT NULL) THEN
                  IF( Warehouse_Task_API.Get_Objstate(warehouse_task_id_) IN ( Warehouse_Task_API.DB_PLANNED,
                                                                               Warehouse_Task_API.DB_RELEASED,
                                                                               Warehouse_Task_API.DB_PARKED,
                                                                               Warehouse_Task_API.DB_STARTED )) THEN
                     Warehouse_Task_API.Modify_Location_Group(warehouse_task_id_, to_location_group_);
                  END IF;
               END IF;
            END IF;
         END LOOP;
      END IF;
      
      IF shipment_reserv_handl_unit_tab_.COUNT > 0 THEN
         $IF Component_Shpmnt_SYS.INSTALLED $THEN
            Shipment_Reserv_Handl_Unit_API.Attach_Reservations_To_Ship_Hu(shipment_reserv_handl_unit_tab_, to_location_, unattached_from_handling_unit_);
         $ELSE
            Error_SYS.Component_Not_Exist('SHPMNT');
         $END
      END IF;
   END IF;
END Reserve_Stock___;

@UncheckedAccess
FUNCTION Get_Ship_Reserv_Hus_To_Reattach___ (
   ship_reserv_handl_unit_tab1_ IN Ship_Reserv_Handl_Unit_Tab,
   ship_reserv_handl_unit_tab2_ IN Ship_Reserv_Handl_Unit_Tab,
   split_reservation_           IN BOOLEAN,
   qty_to_reattach_             IN NUMBER) RETURN Ship_Reserv_Handl_Unit_Tab
IS
   ship_reserv_handl_unit_tab_   Ship_Reserv_Handl_Unit_Tab;
   index_                        PLS_INTEGER;
BEGIN
   index_ := ( NVL(ship_reserv_handl_unit_tab1_.LAST, 0) + 1);
   ship_reserv_handl_unit_tab_ := ship_reserv_handl_unit_tab1_;
   IF (ship_reserv_handl_unit_tab2_.COUNT > 0 AND NOT split_reservation_ OR (ship_reserv_handl_unit_tab2_.COUNT = 1 AND split_reservation_)) THEN
      FOR i IN ship_reserv_handl_unit_tab2_.FIRST..ship_reserv_handl_unit_tab2_.LAST LOOP
         ship_reserv_handl_unit_tab_(index_) := ship_reserv_handl_unit_tab2_(i);
         IF (ship_reserv_handl_unit_tab2_.COUNT = 1 AND split_reservation_) THEN
            ship_reserv_handl_unit_tab_(index_).quantity := qty_to_reattach_;
         END IF;
         index_ := index_ + 1;
      END LOOP;
   END IF;   

   RETURN ship_reserv_handl_unit_tab_;
END Get_Ship_Reserv_Hus_To_Reattach___;

PROCEDURE Add_Pick_List_If_Not_Exists___(
   pick_list_no_tab_    IN OUT Pick_List_No_Tab,
   pick_list_no_        IN     VARCHAR2)
IS
   exit_procedure_ EXCEPTION;
BEGIN
   IF (pick_list_no_tab_.COUNT > 0) THEN
      FOR i IN pick_list_no_tab_.FIRST..pick_list_no_tab_.LAST LOOP
         IF (pick_list_no_tab_(i) = pick_list_no_) THEN
            RAISE exit_procedure_;
         END IF;
      END LOOP;
   END IF;
   pick_list_no_tab_(pick_list_no_tab_.count + 1) := pick_list_no_;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Add_Pick_List_If_Not_Exists___;

PROCEDURE Set_Serial_Traked_In_Inv___(
   serial_set_to_tracked_in_inv_ OUT   BOOLEAN,
   part_no_                      IN    VARCHAR2,
   serial_no_                    IN    VARCHAR2 )
IS
BEGIN
   serial_set_to_tracked_in_inv_ := FALSE;
   IF (serial_no_ != '*') THEN
      IF (Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(part_no_) = TRUE) THEN
         IF (Part_Serial_Catalog_API.Get_Tracked_In_Inventory_Db(part_no_, serial_no_) = Fnd_Boolean_API.DB_FALSE) THEN
            Part_Serial_Catalog_API.Set_Tracked_In_Inventory(part_no_, serial_no_);
            serial_set_to_tracked_in_inv_ := TRUE;
         END IF;
      END IF;
   END IF;
END Set_Serial_Traked_In_Inv___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Quantity_Exist (
   contract_                      IN VARCHAR2,
   part_no_                       IN VARCHAR2,
   configuration_id_              IN VARCHAR2,
   lot_batch_no_                  IN VARCHAR2 DEFAULT NULL,
   serial_no_                     IN VARCHAR2 DEFAULT NULL,
   exclude_customer_owned_stock_  IN VARCHAR2 DEFAULT 'FALSE',
   exclude_supplier_loaned_stock_ IN VARCHAR2 DEFAULT 'FALSE',
   exclude_consignment_stock_     IN VARCHAR2 DEFAULT 'FALSE',
   exclude_supplier_owned_stock_  IN VARCHAR2 DEFAULT 'FALSE',
   exclude_company_owned_         IN VARCHAR2 DEFAULT 'FALSE',
   exclude_supplier_rented_stock_ IN VARCHAR2 DEFAULT 'FALSE',
   exclude_company_rental_stock_  IN VARCHAR2 DEFAULT 'FALSE',
   exclude_fixed_asset_pool_      IN VARCHAR2 DEFAULT 'FALSE' ) RETURN BOOLEAN
IS
   qty_found_     BOOLEAN := FALSE;
BEGIN
   -- Added Rental parameters
   -- Check for quantity in stock.
   IF (Inventory_Part_In_Stock_API.Check_Quantity_Exist (contract_,
                                                         part_no_,
                                                         configuration_id_,
                                                         lot_batch_no_,
                                                         serial_no_,
                                                         exclude_customer_owned_stock_,
                                                         exclude_supplier_loaned_stock_,
                                                         exclude_consignment_stock_,
                                                         exclude_supplier_owned_stock_,
                                                         exclude_company_owned_,
                                                         exclude_supplier_rented_stock_,
                                                         exclude_company_rental_stock_,
                                                         exclude_fixed_asset_pool_ ) = 'TRUE') THEN
      qty_found_ := TRUE;
   ELSE
      IF (exclude_company_owned_ = Fnd_Boolean_API.db_false) THEN
         -- Check for quantity in transit.
         IF (Inventory_Part_In_Transit_API.Get_Total_Qty_In_Order_Transit(contract_, 
                                                                          part_no_, 
                                                                          configuration_id_, 
                                                                          lot_batch_no_, 
                                                                          serial_no_) != 0) THEN
            qty_found_ := TRUE;
         ELSE
            -- Check for quantity at customer.
            IF (Inventory_Part_At_Customer_API.Check_Quantity_Exist(contract_, 
                                                                    part_no_, 
                                                                    configuration_id_, 
                                                                    lot_batch_no_, 
                                                                    serial_no_)) THEN
               qty_found_ := TRUE;
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (qty_found_);
END Check_Quantity_Exist;



@UncheckedAccess
PROCEDURE Get_Company_Owned_Inventory (
   qty_onhand_       OUT NUMBER,
   qty_in_transit_   OUT NUMBER,
   contract_         IN  VARCHAR2,
   part_no_          IN  VARCHAR2,
   configuration_id_ IN  VARCHAR2,
   lot_batch_no_     IN  VARCHAR2 DEFAULT NULL,
   serial_no_        IN  VARCHAR2 DEFAULT NULL )
IS
   qty_in_order_transit_   NUMBER;
   qty_at_customer_        NUMBER;
BEGIN
   Inventory_Part_In_Stock_API.Get_Company_Owned_Inventory (qty_onhand_,
                                                            qty_in_transit_,
                                                            contract_,
                                                            part_no_,
                                                            configuration_id_,
                                                            lot_batch_no_,
                                                            serial_no_);

   qty_in_order_transit_ := Inventory_Part_In_Transit_API.Get_Total_Qty_In_Order_Transit(contract_,
                                                                                         part_no_,
                                                                                         configuration_id_,
                                                                                         lot_batch_no_,
                                                                                         serial_no_);

   qty_at_customer_ := Inventory_Part_At_Customer_API.Get_Company_Owned_Inventory (contract_,
                                                                                   part_no_,
                                                                                   configuration_id_,
                                                                                   lot_batch_no_,
                                                                                   serial_no_);
   qty_onhand_     := NVL(qty_onhand_, 0) + NVL(qty_at_customer_, 0);
   qty_in_transit_ := NVL(qty_in_transit_, 0) + NVL(qty_in_order_transit_, 0);
END Get_Company_Owned_Inventory;



@UncheckedAccess
FUNCTION Get_Company_Owned_Inventory (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2) RETURN Inventory_Part_In_Stock_API.Config_Lot_Serial_Tab
IS
   in_stock_tab_     Inventory_Part_In_Stock_API.Config_Lot_Serial_Tab;
   transit_tab_      Inventory_Part_In_Stock_API.Config_Lot_Serial_Tab;
   at_customer_tab_  Inventory_Part_In_Stock_API.Config_Lot_Serial_Tab;

BEGIN
   in_stock_tab_ := Inventory_part_In_Stock_API.Get_Company_Owned_Inventory(contract_,
                                                                            part_no_,
                                                                            configuration_id_);

   transit_tab_ := Inventory_part_In_Transit_API.Get_Total_Qty_In_Order_Trans(contract_,
                                                                              part_no_,
                                                                              configuration_id_);

   at_customer_tab_ := Inventory_Part_At_Customer_API.Get_Company_Owned_Inventory(contract_,
                                                                                  part_no_,
                                                                                  configuration_id_);
   RETURN Merge_Config_Lot_Serial_Tab___(Merge_Config_Lot_Serial_Tab___(in_stock_tab_, transit_tab_), at_customer_tab_);
END Get_Company_Owned_Inventory;



@UncheckedAccess
FUNCTION Check_Part_Exist (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2 ) RETURN BOOLEAN
IS
   part_exist_       BOOLEAN := FALSE;
BEGIN
   IF Inventory_Part_In_Stock_API.Check_Part_Exist(contract_, part_no_) THEN
      part_exist_ := TRUE;
   ELSE
      IF (Inventory_Part_In_Transit_API.Check_Part_Exist(contract_, part_no_) = Fnd_Boolean_API.db_true) THEN
         part_exist_ := TRUE;
      ELSE
         IF Inventory_Part_At_Customer_API.Check_Part_Exist(contract_, part_no_) THEN
            part_exist_ := TRUE;
         END IF;
      END IF;
   END IF;
   RETURN(part_exist_);
END Check_Part_Exist;



@UncheckedAccess
FUNCTION Check_Individual_Exist (
   part_no_    IN VARCHAR2,
   serial_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   exist_   NUMBER := 0;
BEGIN
   IF (Inventory_Part_In_Stock_API.Check_Individual_Exist(part_no_, serial_no_) = 1) THEN
      exist_ := 1;
   ELSE
      IF (Inventory_Part_In_Transit_API.Check_Individual_Exist(part_no_, serial_no_) = Fnd_Boolean_API.db_true) THEN
         exist_ := 1;
      ELSE
         IF (Inventory_Part_At_Customer_API.Check_Individual_Exist(part_no_, serial_no_) = 1) THEN
            exist_ := 1;
         END IF;
      END IF;
   END IF;
   RETURN(exist_);
END Check_Individual_Exist;


@UncheckedAccess
FUNCTION Get_Lot_Batch_Track_Status (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   return_from_part_in_stock_    VARCHAR2(20);
   return_from_part_in_transit_  VARCHAR2(20);
   return_from_part_at_customer_ VARCHAR2(20);
   return_string_                VARCHAR2(20);
BEGIN
   return_from_part_in_stock_:= Inventory_Part_In_Stock_API.Get_Lot_Batch_Track_Status(part_no_);
   IF return_from_part_in_stock_ IS NOT NULL THEN
      return_string_ := return_from_part_in_stock_;
   ELSE
      return_from_part_in_transit_:= Inventory_Part_In_Transit_API.Get_Lot_Batch_Track_Status(part_no_);
      IF return_from_part_in_transit_ IS NOT NULL THEN
         return_string_ := return_from_part_in_transit_;
      ELSE
         return_from_part_at_customer_:= Inventory_Part_At_Customer_API.Get_Lot_Batch_Track_Status(part_no_);
         IF return_from_part_at_customer_ IS NOT NULL THEN
            return_string_ := return_from_part_at_customer_; 
         END IF;
      END IF;
   END IF;
   RETURN return_string_;
END Get_Lot_Batch_Track_Status;



@UncheckedAccess
FUNCTION Check_Qty_For_Condition (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   ownership_        IN VARCHAR2 ) RETURN NUMBER
IS
   found_      NUMBER := 0;
BEGIN
   IF (Inventory_Part_In_Stock_API.Check_Qty_For_Condition(contract_,
                                                          part_no_,
                                                          configuration_id_,
                                                          condition_code_,
                                                          ownership_ ) = 1) THEN
      found_ := 1;
   ELSE
      IF (Inventory_Part_At_Customer_API.Check_Qty_For_Condition(contract_,
                                                                 part_no_,
                                                                 configuration_id_,
                                                                 condition_code_) = 1) THEN
         found_ := 1;
      END IF;
   END IF;
   RETURN found_;
END Check_Qty_For_Condition;


PROCEDURE Validate_Move_Reservation (move_reservation_option_db_  IN VARCHAR2,
                                     reserved_stock_rec_          IN Inv_Part_Stock_Reservation_API.Inv_Part_In_Stock_Res_Rec DEFAULT NULL,
                                     calling_process_             IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   IF (reserved_stock_rec_.qty_picked != 0) THEN
      Error_SYS.Record_General(lu_name_, 'RESMOVEPICKED: It is not possible to move reserved stock which is pick reported.');
   END IF;   
   CASE move_reservation_option_db_
      WHEN Reservat_Adjustment_Option_API.DB_NOT_ALLOWED THEN
         Error_SYS.Record_General(lu_name_, 'RESMOVENOTALLOWED: It is not allowed to move reserved stock.');
      WHEN Reservat_Adjustment_Option_API.DB_NOT_PICK_LISTED THEN
         IF (NVL(reserved_stock_rec_.pick_list_no, '*') != '*') THEN 
            IF calling_process_ = new_or_add_to_transport_task_ THEN 
               Error_SYS.Record_General(lu_name_, 'TTRESMOVEPICKLISTED: It is not allowed to move reserved stock which is on a picklist with transport task.');
            ELSE 
               Error_SYS.Record_General(lu_name_, 'RESMOVEPICKLISTED: It is not allowed to move reserved stock which is on a picklist.');
            END IF;
         END IF;   
      WHEN Reservat_Adjustment_Option_API.DB_NOT_PRINTED_PICKLIST THEN
         IF (NVL(reserved_stock_rec_.pick_list_no, '*') != '*') AND (reserved_stock_rec_.pick_list_printed_db = 'TRUE') THEN
            IF calling_process_ = new_or_add_to_transport_task_ THEN 
               Error_SYS.Record_General(lu_name_, 'TTRESMOVEPICKLISTPRINT: It is not allowed to move reserved stock which is on a printed picklist with transport task.');
            ELSE 
               Error_SYS.Record_General(lu_name_, 'RESMOVEPICKLISTPRINT: It is not allowed to move reserved stock which is on a printed picklist.');
            END IF;
         END IF;   
      WHEN Reservat_Adjustment_Option_API.DB_ALLOWED THEN
         NULL;             
   END CASE;
END Validate_Move_Reservation;


-- This is the main entry method for moving parts manually. This will handle reserved and unserved stock.
PROCEDURE Move_Part (
   unattached_from_handling_unit_    OUT VARCHAR2,
   catch_quantity_                IN OUT NUMBER,
   contract_                      IN     VARCHAR2,
   part_no_                       IN     VARCHAR2,
   configuration_id_              IN     VARCHAR2,
   location_no_                   IN     VARCHAR2,
   lot_batch_no_                  IN     VARCHAR2,
   serial_no_                     IN     VARCHAR2,
   eng_chg_level_                 IN     VARCHAR2,
   waiv_dev_rej_no_               IN     VARCHAR2,
   activity_seq_                  IN     NUMBER,
   handling_unit_id_              IN     NUMBER,
   expiration_date_               IN     DATE,
   to_contract_                   IN     VARCHAR2,
   to_location_no_                IN     VARCHAR2,
   to_destination_                IN     VARCHAR2,
   quantity_                      IN     NUMBER,
   quantity_reserved_             IN     NUMBER,   
   move_comment_                  IN     VARCHAR2,
   order_no_                      IN     VARCHAR2 DEFAULT NULL,
   release_no_                    IN     VARCHAR2 DEFAULT NULL,
   sequence_no_                   IN     VARCHAR2 DEFAULT NULL,
   line_item_no_                  IN     NUMBER   DEFAULT NULL,
   order_type_                    IN     VARCHAR2 DEFAULT NULL,
   consume_consignment_stock_     IN     VARCHAR2 DEFAULT NULL,
   to_waiv_dev_rej_no_            IN     VARCHAR2 DEFAULT NULL,
   part_tracking_session_id_      IN     NUMBER   DEFAULT NULL,
   transport_task_id_             IN     NUMBER   DEFAULT NULL,
   validate_hu_struct_position_   IN     BOOLEAN  DEFAULT TRUE,
   move_part_shipment_            IN     BOOLEAN  DEFAULT FALSE,
   reserved_stock_rec_            IN     Inv_Part_Stock_Reservation_API.Inv_Part_In_Stock_Res_Rec DEFAULT NULL,
   availability_ctrl_id_          IN     VARCHAR2 DEFAULT NULL )
IS
   reserved_stock_tab_          Inv_Part_Stock_Reservation_API.Inv_Part_In_Stock_Res_Table;
   inv_part_in_stock_pub_rec_   Inventory_Part_In_Stock_API.Public_Rec;
   reserved_qty_to_move_        NUMBER;
   move_reservation_option_db_  VARCHAR2(20);
   serial_set_to_tracked_in_inv_    BOOLEAN := FALSE;
   shipment_reserv_handl_unit_tab_     Ship_Reserv_Handl_Unit_Tab;
BEGIN   
   @ApproveTransactionStatement(2016-09-09,asawlk)   
   SAVEPOINT before_stock_locked;
   inv_part_in_stock_pub_rec_ := Inventory_Part_In_Stock_API.Lock_By_Keys( contract_,
                                                                           part_no_,
                                                                           configuration_id_,
                                                                           location_no_,
                                                                           lot_batch_no_,
                                                                           serial_no_,
                                                                           eng_chg_level_,
                                                                           waiv_dev_rej_no_,
                                                                           activity_seq_,
                                                                           handling_unit_id_);
                                                                           
   IF (reserved_stock_rec_.order_no IS NULL) THEN
      IF (quantity_ > inv_part_in_stock_pub_rec_.qty_onhand) THEN
         Error_SYS.Record_General(lu_name_, 'NOTENOUGHQTY: Insufficient stock to move.');
      END IF;
      -- This statement gives priority to available quantity at the source location. It will be moved in full as first priority.
      -- Remainder is chosen from the reserved stock.
      reserved_qty_to_move_ := quantity_ - (inv_part_in_stock_pub_rec_.qty_onhand - inv_part_in_stock_pub_rec_.qty_reserved);
   ELSE
      -- This is the scenario that we start the move by pointing to a reservation which is passed to the this method in reserved_stock_rec_. 
      reserved_qty_to_move_ := quantity_;
   END IF;   
   
   IF (reserved_qty_to_move_ > 0 ) THEN
      IF (contract_ != to_contract_) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDRESMOVE: It is not possible to move reserved stock between sites.');   
      END IF;
      move_reservation_option_db_ := Site_Invent_Info_API.Get_Move_Reservation_Option_Db(contract_);
      IF (move_reservation_option_db_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN
         Validate_Move_Reservation(move_reservation_option_db_);
      END IF;
      IF (reserved_stock_rec_.order_no IS NULL) THEN 
         reserved_stock_tab_ := Inv_Part_Stock_Reservation_API.Find_Reservations(contract_,
                                                                                 part_no_,
                                                                                 configuration_id_,
                                                                                 location_no_,
                                                                                 lot_batch_no_,
                                                                                 serial_no_,
                                                                                 eng_chg_level_,
                                                                                 waiv_dev_rej_no_,
                                                                                 activity_seq_,
                                                                                 handling_unit_id_,
                                                                                 reserved_qty_to_move_,
                                                                                 move_reservation_option_db_);
      ELSE
         -- Addressing a specific reservation passed in.
         reserved_stock_tab_(1) := reserved_stock_rec_;
         -- We need to validate the move against the move reservation option in site invent info
         Validate_Move_Reservation(move_reservation_option_db_, reserved_stock_tab_(1));
      END IF;  

      -- Check whether enough reserved quantity is there at the stock location to proceed. This is done as a pre-check before we do the
      -- actual un-reservation and check the qunatities.
      Have_Enough_Qty_For_Move___(reserved_qty_to_move_, reserved_stock_tab_);
      
      -- If the serial is only receipt and issue tracked, we temporary set the tracked_in_inventory flag in part_serial_catalog to true.
      -- This is done in order to prevent the loss of the serial record in the stock which happens due to being merged to stock record 
      -- with serial = '*' upon the unreservation.
      Set_Serial_Traked_In_Inv___(serial_set_to_tracked_in_inv_,
                                  part_no_,
                                  serial_no_);
                                  
      -- Un-reserve the stock
      Unreserve_Stock___(shipment_reserv_handl_unit_tab_, reserved_stock_tab_, reserved_qty_to_move_, Inventory_Location_API.Get_Location_Type_db(to_contract_, to_location_no_));
   ELSE
      -- No need to lock the stock record as we are not handling reservations in this case.
      @ApproveTransactionStatement(2016-09-09,asawlk)      
      ROLLBACK TO before_stock_locked; 
   END IF;   
   -- Perform the actual move operation
   Inventory_Part_In_Stock_API.Move_Part( unattached_from_handling_unit_ => unattached_from_handling_unit_,
                                          catch_quantity_                => catch_quantity_,
                                          contract_                      => contract_,
                                          part_no_                       => part_no_,
                                          configuration_id_              => configuration_id_,
                                          location_no_                   => location_no_,
                                          lot_batch_no_                  => lot_batch_no_,
                                          serial_no_                     => serial_no_,
                                          eng_chg_level_                 => eng_chg_level_,
                                          waiv_dev_rej_no_               => waiv_dev_rej_no_,
                                          activity_seq_                  => activity_seq_,
                                          handling_unit_id_              => handling_unit_id_,
                                          expiration_date_               => expiration_date_,
                                          to_contract_                   => to_contract_,
                                          to_location_no_                => to_location_no_,
                                          to_destination_                => to_destination_,
                                          quantity_                      => quantity_,
                                          quantity_reserved_             => quantity_reserved_,
                                          move_comment_                  => move_comment_,
                                          order_no_                      => order_no_,
                                          release_no_                    => release_no_,
                                          sequence_no_                   => sequence_no_,
                                          line_item_no_                  => line_item_no_,
                                          order_type_                    => order_type_,
                                          consume_consignment_stock_     => consume_consignment_stock_,
                                          to_waiv_dev_rej_no_            => to_waiv_dev_rej_no_,
                                          part_tracking_session_id_      => part_tracking_session_id_,
                                          transport_task_id_             => transport_task_id_,
                                          validate_hu_struct_position_   => validate_hu_struct_position_,
                                          move_part_shipment_            => move_part_shipment_,
                                          availability_ctrl_id_          => availability_ctrl_id_);
   -- Re-reserve the un-reserved stocks in the new location after the move.                                       
   IF (reserved_qty_to_move_ > 0 ) THEN
      -- If there had been an unattachment from the handling unit then the moved stock will have the handling_unit_id = 0 in the destination location.
      -- Therefore the re-reservation should also be done with handling_unit_id = 0.
      IF (unattached_from_handling_unit_ = 'TRUE') THEN
         FOR i IN reserved_stock_tab_.FIRST..reserved_stock_tab_.LAST LOOP  
            reserved_stock_tab_(i).handling_unit_id := 0;
            -- This check is useful when moving reserved stock attached to a HU in combination with serial tracking only at receipt and issue and when unpacking 
            -- the serial meaning that handling unit ID goes to zero and serial resets to *. 
            IF (reserved_stock_tab_(i).serial_no != '*') AND 
               (Inventory_Part_In_Stock_API.Check_Individual_Exist(reserved_stock_tab_(i).part_no, reserved_stock_tab_(i).serial_no) = 0) THEN 
               reserved_stock_tab_(i).serial_no := '*';
            END IF ;
         END LOOP;   
      END IF;
      Reserve_Stock___(shipment_reserv_handl_unit_tab_,
                       reserved_stock_tab_,
                       reserved_qty_to_move_,
                       to_location_no_,
                       NVL(to_waiv_dev_rej_no_, waiv_dev_rej_no_),
                       unattached_from_handling_unit_);
      IF serial_set_to_tracked_in_inv_ THEN
         -- Revert the temporary set flag tracked_in_inventory, to its original value if we have already modified it.
         Part_Serial_Catalog_API.Reset_Tracked_In_Inventory(part_no_, serial_no_);
      END IF;
   END IF;                 
END Move_Part;
