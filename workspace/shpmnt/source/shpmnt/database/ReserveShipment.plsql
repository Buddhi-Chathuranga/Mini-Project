-----------------------------------------------------------------------------
--
--  Logical unit: ReserveShipment
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220720  AvWilk  Bug SCZ-19150, Removed Handl_Unit_Snapshot_Util_API.Delete_Old_Snapshots call from Generate_Man_Res_Hu_Snapshot improve performance.
--  220710  RoJalk  SCDEV-12440, Added the parameter source_ref_demand_code_ to the method Reserve_As_Picked and included in Inventory_Part_Reservation_API.Reserve_And_Report_As_Picked call.
--  220503  RoJalk  SCDEV-8951, Added the parameter source_ref_demand_code_ to methods Reserve_Manually___, Reserve_Manually.
--  211230  RasDlk  SC21R2-3145, Modified Post_Update_Reserv_Actions by adding qty_shipped_ as a new parameter and changing the logic to support Undo Shipment Delivery for sources other than Customer Order.
--  211213  PamPlk  SC21R2-3012, Modified Get_Logistics_Source_Type_Db to support Purchase Receipt Return.
--  211208  PrRtlk  SC21R2-5265, Modified Get_Order_Sup_Demand_Type_Db__ method by reverting the changes done for Purchase Receipt Return.
--  211207  PrRtlk  SC21R2-5677, Modified Get_Hndl_Unt_Snpshot_Type_Db__ method by reverting the changes done for Purchase Receipt Return.
--  211110  Aabalk  SC21R2-5899, Added method Get_Logistics_Source_Type_Db to fetch logistics source ref type from order supply demand type.
--  211104  PrRtlk  SC21R2-5677, Modified Get_Hndl_Unt_Snpshot_Type_Db__ to support Purchase Receipt Return.
--  211101  PamPlk  SC21R2-3012, Modified Get_Logistic_Source_Type_Db to support Purchase Receipt Return.
--  211028  PrRtlk  SC21R2-5265, Added DB_PURCH_RECEIPT_RETURN to Get_Order_Sup_Demand_Type_Db__ method.
--  211021  RoJalk  SC21R2-3082, Modified Reserve_Inventory to support ownership information from shipment order.
--  211014  AsZelk  SC21R2-3014, Modified Use_Generic_Reservation() to support Purchase Receipt Return.
--  210728  RoJalk  SC21R2-1034, Modified Is_Fully_Reserved_Hu and called the method Get_Inventory_Quantity.
--  210721  RoJalk  SC21R2-1034, Added the method Is_Fully_Reserved_Hu.
--  210714  RoJalk  SC21R2-1374, Added the parameter ship_handling_unit_id_ to Post_Update_Reserv_Actions.
--  210714  KiSalk  Bug 159976(SCZ-15451), In Move_Res_With_Trans_Task, root_handling_unit_tab_ made a local type variable INDEX BY VARCAR2 not to raise error on exist check for HU ID larger than 2,147,483,647.
--  210209  RoJalk  SC2020R1-7243, Modified Shipment_Source_Utility_API.Get_Source_Info_At_Reserve__ and removed the parameters part_no and contract,
--  210208  RoJalk  SC2020R1-12438, Modified Move_Res_With_Trans_Task so that source_ref3 will be correctly converted for Shipment Order.
--  210126  RoJalk  SC2020R1-7243, Modified Reserve_Inventory to use correct values for include_standard_, include_project_ for all source types.
--  201029  ErRalk  SC2020R1-10472, Modified Reserve_Inventory___ into  a public method and included default parameters to support automatic reservation.
--  200924  RoJalk  SC2020R1-1673, Modified Reserve_Inventory___ to support new parameters added for Shipment_Source_Utility_API.Get_Source_Info_At_Reserve__.
--  200923  KETKLK  PJ2020R1-3755, Modified Reserve_Inventory___ to pass the part_ownership_db_ and owning_customer_no_ to the Inventory_Part_Reservation_API.Find_And_Reserve_Part() method.
--  200916  RoJalk  SC2020R1-9192, Modified Reserve_Inventory___ and moved shipment order specific code to Shipment_Source_Utility_API.Get_Source_Info_At_Reserve__.
--  200909  RoJalk  SC2020R1-1138, Renamed Get_Source_Proj_At_Reserve__ to  Get_Source_Info_At_Reserve__ and included the logic to fetch the values for Shipment Order.
--  200729  ErRalk  SC2020R1-1033, Modified Reserve_Manually___ by adding pick_by_choice_blocked_ to add Blocked for Pick By choice to Generic Reservation.
--  200714  AsZelk  SC2020R1-2172, Modified Reserve_Inventory___ to check Availability when Reservation.
--  200417  RasDlk  SCSPRING20-1954, Modified Reserve_Manually, Reserve_Manually___, Reserve_Manually_Hu__, Reserve_Manually_Hu___ and Unreserve_Manually_Hu__ by adding sender related
--  200417          information required for manual reservations. Modified Reserve_Manually___ to fetch the Default Pac ID of a particular remote warehouse and pass it in
--  200417          to the parameter ignore_this_avail_control_id_ when the sender_type is REMOTE_WAREHOUSE. 
--  200302  KiSalk  Bug 152676(SCZ-9021), Added parameters part_no_ and contract_ to Generate_Man_Res_Hu_Snapshot to make it faster.
--  200216  RasDlk  SCSPRING20-170, Modified Get_Hndl_Unt_Snpshot_Type_Db__ to support new MAN_RES_SHIP_ORD enumeration value.
--  200216  RasDlk  SCSPRING20-170, Added the method Get_Min_Durab_Days_For_Reserve() to handle dynamic dependency correctly to support aurena functionality in ManualReservationsForShipmentAndCustomerOrderLine.
--  191219  KiSalk  Bug 151371(SCZ-8121), In Unreported_Pick_List_Exists, modified cursor chk_unreported_pick_list_exist adding condition 
--  191219          to check source_ref4_ when the line is customer order line package header.
--  191212  MeAblk  SCSPRING20-1239, Modified methods Post_New_Reservation_Actions(), Post_Unreservation_Actions() and Post_Update_Reserv_Actions() to handle the post actions of 
--  191212          source specific reservation qty changes. Also shipment lines spefici changes restricted only when the reservation is shipment connected.
--  191107  RoJalk  SCSPRING20-486, Modified Reserve___, Reserve_Lines__, Reserve_Line___, Reserve_Inventory___ to handle reservation from a specific sender warehouse..
--  191029  Aabalk  SCSPRING20-63, Modified Use_Generic_Reservation, Get_Inv_Res_Source_Type_Db, Get_Logistic_Source_Type_Db and Get_Order_Sup_Demand_Type_Db___
--                  to support new SHIPMENT_ORDER enumeration value.
--  190711  ErFelk  Bug 143629, Modified Move_With_Trans_Task__() by adding due_date_execution_offset and ship_date_execution_offset.
--  190221  RoJalk  SCUXXW4-16684, Added Validate_Qty_To_Reserve to be used in reservation clients.
--  190503  ErFelk  Bug 147615(SCZ-4066), Modified Reserve_Inventory___() by calling a method Shipment_Source_Utility_API.Get_Source_Proj_At_Reserve__() to get the
--  190503          project_id and activity_seq.
--  180516  SBalLK  Bug 141724, Removed defined component dependency with own component.
--  180225  ChBnlk  STRSC-17293, Modified the method Get_Total_Qty_On_Pick_List() with source information to exclude the delivered lines from the cursor
--  180225          get_total_qty_on_pick_list to improve performance.
--  180216  RoJalk  STRSC-15257, Added the method Get_Total_Qty_On_Pick_List.
--  180211  ChFolk  STRSC-16710, Modified Move_Res_With_Trans_Task to avoid including when reservations is same as to location.
--  180208  ChFolk  STRSC-16340, Modified Move_With_Trans_Task__ to remove date trunc in planned_ship_date in the cursor get_reserv_details.
--  171213  ChFolk  STRSC-14821, Renamed variable exclude_complete_hu_reserv_ as exclude_hu_to_pick_in_one_step_ and parameter EXCLUDE_COMPLETE_HU_RESERV
--  171213          as EXCLUDE_HU_TO_PICK_IN_ONE_STEP.
--  171213  ChFolk  STRSC-14898, Renamed Validate_Move_Ship_Reserve as Validate_Move_With_Trans_Task to use commonly for move with 
--  171207          customer order reservations and shipment reservations. Added new method Move_Res_With_Trans_Task which contains the common code
--  171213          for both move shipment reservations as well as customer order reservations with transport task. Modified method to
--  171212          move common code to the new method. Added new record type Move_Reserve_Rec and table type Move_Reserve_Tab to be used with the common method.
--  171031  ChBnlk  STRSC-13798, Added new method Get_Total_Qty_On_Pick_List() to get the total quantity on pick list for a perticular source line.
--  171020  ChFolk  STRSC-12547, Modified Move_With_Trans_Task__ to pass correct paraeter value for source_ref4 to support with project delivarables.
--  171018  ChFolk  STRSC-12547, Modified Move_With_Trans_Task__ to support moving shipment reservations with transport tasks.
--  171010  ChFolk  STRSC-12546, Added new methods Move_Ship_Res_With_Trans_Task, Validate_Move_Ship_Reserve and Move_With_Trans_Task__ to support
--  171010          Move Shipment Reservations with Transport Task.
--  171003  JeLise  STRSC-12327, Added pick_by_choice_blocked_ in Reserve_Manually.
--  170713  ChFolk  STRSC-10912, Modified Move_Shipment_Reservation to create transport task for the newly reserved quantity 
--  170713          if old reservation is linked with a transport task.
--  170516  RoJalk  LIM-11281, Modified Move_Shipment_Reservation and added parameters new_shipment_id_,  source_ref_type_db_
--  170516          to the call Reassign_Shipment_Utility_API.Validate_Reassign_Reserve.
--  170515  RoJalk  STRSC-8427, Added the method Unreported_Pick_List_Exists.
--  170512  RoJalk  STRSC-8336, Modified Reserve_As_Picked and added string_parameter1_, string_parameter2_,
--  170512          inventory_event_id_ to Inventory_Part_Reservation_API.Reserve_And_Report_As_Picked.
--  170505  RoJalk  STRSC-7931, Added the method Reservation_Exists.
--  170402  RoJalk  LIM-11451, Modified Lock_And_Fetch_Reserve_Info and called Reserve_Shipment_API.Convert_Pick_List_No_To_Num.
--  170330  Chfose  LIM-10832, Added new method Reserve_As_Picked.
--  170302  RoJalk  LIM-11001, Added Public_Reservation_Rec and replaced it with Shipment_Source_Utility_API.Public_Reservation_Rec usage.
--  170302          Added the method Lock_And_Fetch_Reserve_Info. 
--  170220  MaIklk  LIM-10879, Handled to use NVL for move_to_ship_location_ parameter in post actions of InventoryPartReservation.
--  170207  MaIklk  LIM-10421, Handled to use NVL when passing source ref values on Generate Snap shot.
--  170127  MaIklk  LIM-9825, Handled NVL for source ref columns when calling ShipmentReservHandlUnit methods.
--  170124  MaIklk  LIM-9819, Handled to send "*" to InventoryPartReservation when source ref columns are NULL. 
--  170104  MaIklk  LIM-10190, Moved Shipment_Source_Utility_API.Transfer_Line_Reservations() to this utility.
--  170102  MaIklk  LIM-8281, Added Get_Number_Of_Lines_To_Pick().
--  170102  MaIklk  LIM-10161,Fixed to use shipment_source_reservation to fetch qty_assigned in some functions.
--  161221  MaIklk  LIM-8389, Added Get_Total_Catch_Qty_Issued().
--  161215  MaIklk  LIM-9815, Added Get_Hndl_Unt_Snpshot_Type_Db__() and used it when generating snapshot.
--  161209  MaIklk  LIM-9882, Added Get_Order_Sup_Demand_Type_Db__().
--  161205  MaIklk  LIM-9257, Moved Get_Sum_Reserve_To_Reassign to Reserve_Shipment_API from Customer_Order_Reservation_API and renamed it to Get_Reserved_And_Picked_Qty. 
--  161202  MaIklk  LIM-9932, Called Get_Unpicked_Pick_Listed_Qty to fetch unpicked qty in order to calculate maximum qty to reassign.
--  161128  MaIklk  LIM-9749, Added Reservation_Exist().
--  161116  MaIklk  LIM-9232, Implemented logic for manual reservation and move shipment reservations.
--  161102  MaIklk  LIM-9230, Implemented logic for automatic reservation.
--  161021  MaIklk  LIM-9170, Added Post_New_Reservation_Actions and Post_Unreservation_Actions.
--  161018  MaIklk  LIM-9346, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Reserve_Shipment_Rec IS RECORD
   (source_ref1         SHIPMENT_LINE_TAB.source_ref1%TYPE,
    source_ref2         SHIPMENT_LINE_TAB.source_ref2%TYPE,
    source_ref3         SHIPMENT_LINE_TAB.source_ref3%TYPE,
    source_ref4         SHIPMENT_LINE_TAB.source_ref4%TYPE,
    contract            SHIPMENT_TAB.contract%TYPE,
    inventory_part_no   SHIPMENT_LINE_TAB.inventory_part_no%TYPE);
TYPE Reserve_Shipment_Table IS TABLE OF Reserve_Shipment_Rec INDEX BY BINARY_INTEGER;

TYPE Public_Reservation_Rec IS RECORD
  (qty_assigned               NUMBER,
   qty_picked                 NUMBER,       
   catch_qty                  NUMBER,
   qty_shipped                NUMBER,   
   input_qty                  NUMBER,
   preliminary_pick_list_no   NUMBER,
   input_conv_factor          NUMBER,
   input_unit_meas            VARCHAR2(30),
   input_variable_values      VARCHAR2(2000),   
   delnote_no                 VARCHAR2(15));

TYPE Move_Reserve_Rec IS RECORD
   (part_no                  VARCHAR2(25),
    from_location_no         VARCHAR2(35),   
    source_ref1              VARCHAR2(50),
    source_ref2              VARCHAR2(50),
    source_ref3              VARCHAR2(50),
    source_ref4              VARCHAR2(50),
    source_ref_type_db       VARCHAR2(20),
    configuration_id         VARCHAR2(50),
    lot_batch_no             VARCHAR2(20),
    serial_no                VARCHAR2(50),
    eng_chg_level            VARCHAR2(6),
    waiv_dev_rej_no          VARCHAR2(15),
    activity_seq             NUMBER,
    handling_unit_id         NUMBER,
    pick_list_no             VARCHAR2(15),
    shipment_id              NUMBER,
    qty_to_move              NUMBER );

TYPE Move_Reserve_Tab IS TABLE OF Move_Reserve_Rec INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_         CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

db_true_             CONSTANT VARCHAR2(5) := Fnd_Boolean_API.DB_TRUE;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
                            
-- Reserve___
-- This will bundle the lines for a specific source ref1 and do reservation.
PROCEDURE Reserve___ (
   reserve_ship_tab_     IN OUT   Reserve_Shipment_Table,   
   shipment_id_          IN       NUMBER,
   source_ref_type_db_   IN       VARCHAR2,
   sender_type_          IN       VARCHAR2,
   sender_id_            IN       VARCHAR2 )
IS
   curr_source_ref1_             VARCHAR2(50);
   shipment_online_process_db_   VARCHAR2(5);
   attr_                         VARCHAR2(32000);
   temp_attr_                    VARCHAR2(32000);
   description_                  VARCHAR2(200);
   warehouse_rec_                Warehouse_API.Public_Rec;
BEGIN                              
   IF (reserve_ship_tab_.COUNT > 0) THEN
      
      shipment_online_process_db_ := Shipment_Type_API.Get_Online_Processing_Db(Shipment_API.Get_Shipment_Type(shipment_id_));
      curr_source_ref1_           := reserve_ship_tab_(reserve_ship_tab_.FIRST).source_ref1;     
      description_                := Language_SYS.Translate_Constant(lu_name_, 'PICKPLAN_LINES: Reserve Shipment Lines');
      
      IF (sender_type_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
         warehouse_rec_ := Warehouse_API.Get(sender_id_);
      END IF;   
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('SOURCE_REF1',     reserve_ship_tab_(reserve_ship_tab_.FIRST).source_ref1, attr_);
      Client_SYS.Add_To_Attr('SHIPMENT_ID',     shipment_id_,                                           attr_);
      Client_SYS.Add_To_Attr('CONTRACT',        reserve_ship_tab_(reserve_ship_tab_.FIRST).contract,    attr_);
      Client_SYS.Add_To_Attr('SOURCE_REF_TYPE', source_ref_type_db_,                                    attr_);
      IF (sender_type_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
         Client_SYS.Add_To_Attr('WAREHOUSE_ID',            warehouse_rec_.warehouse_id,            attr_);
         Client_SYS.Add_To_Attr('AVAILABILITY_CONTROL_ID', warehouse_rec_.availability_control_id, attr_);
      END IF;
      
      FOR index_ IN reserve_ship_tab_.FIRST..reserve_ship_tab_.LAST LOOP
         IF (reserve_ship_tab_(index_).source_ref1 != curr_source_ref1_) THEN
            IF (Transaction_SYS.Is_Session_Deferred) OR (shipment_online_process_db_ = Fnd_Boolean_API.DB_TRUE) THEN
               Reserve_Shipment_API.Reserve_Lines__(attr_);
            ELSE   
               Transaction_SYS.Deferred_Call('Reserve_Shipment_API.Reserve_Lines__', attr_, description_);
            END IF;
            
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('SOURCE_REF1',       reserve_ship_tab_(index_).source_ref1,       attr_);
            Client_SYS.Add_To_Attr('SHIPMENT_ID',       shipment_id_,                                attr_);
            Client_SYS.Add_To_Attr('CONTRACT',          reserve_ship_tab_(index_).contract,          attr_);
            Client_SYS.Add_To_Attr('SOURCE_REF_TYPE',   source_ref_type_db_,                         attr_);
            IF (sender_type_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
              Client_SYS.Add_To_Attr('WAREHOUSE_ID',            warehouse_rec_.warehouse_id,            attr_);
              Client_SYS.Add_To_Attr('AVAILABILITY_CONTROL_ID', warehouse_rec_.availability_control_id, attr_);
            END IF;
            Client_SYS.Add_To_Attr('SOURCE_REF2',       reserve_ship_tab_(index_).source_ref2,       attr_);
            Client_SYS.Add_To_Attr('SOURCE_REF3',       reserve_ship_tab_(index_).source_ref3,       attr_);
            Client_SYS.Add_To_Attr('SOURCE_REF4',       reserve_ship_tab_(index_).source_ref4,       attr_);                
            Client_SYS.Add_To_Attr('INVENTORY_PART_NO', reserve_ship_tab_(index_).inventory_part_no, attr_);
            
            curr_source_ref1_ := reserve_ship_tab_(index_).source_ref1;
         ELSE
            Client_SYS.Clear_Attr(temp_attr_);
            Client_SYS.Add_To_Attr('SOURCE_REF2',       reserve_ship_tab_(index_).source_ref2,       temp_attr_);
            Client_SYS.Add_To_Attr('SOURCE_REF3',       reserve_ship_tab_(index_).source_ref3,       temp_attr_);
            Client_SYS.Add_To_Attr('SOURCE_REF4',       reserve_ship_tab_(index_).source_ref4,       temp_attr_); 
            Client_SYS.Add_To_Attr('INVENTORY_PART_NO', reserve_ship_tab_(index_).inventory_part_no, temp_attr_);
   
            IF (length(attr_ || temp_attr_) <= 2000) THEN
               attr_ := attr_ || temp_attr_;
            ELSE
               -- if the attribute string length will exceed 2000, 
               -- make deferred call for the data already in the attribute string.
               IF (Transaction_SYS.Is_Session_Deferred) OR (shipment_online_process_db_ = Fnd_Boolean_API.DB_TRUE) THEN
                  Reserve_Shipment_API.Reserve_Lines__(attr_);
               ELSE               
                  Transaction_SYS.Deferred_Call('Reserve_Shipment_API.Reserve_Lines__', attr_, description_);
               END IF;
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('SOURCE_REF1',     reserve_ship_tab_(index_).source_ref1, attr_);
               Client_SYS.Add_To_Attr('SHIPMENT_ID',     shipment_id_,                          attr_);
               Client_SYS.Add_To_Attr('CONTRACT',        reserve_ship_tab_(index_).contract,    attr_);
               Client_SYS.Add_To_Attr('SOURCE_REF_TYPE', source_ref_type_db_,                   attr_);
               IF (sender_type_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
                  Client_SYS.Add_To_Attr('WAREHOUSE_ID',            warehouse_rec_.warehouse_id,            attr_);
                  Client_SYS.Add_To_Attr('AVAILABILITY_CONTROL_ID', warehouse_rec_.availability_control_id, attr_);
               END IF;
               attr_ := attr_ || temp_attr_;
            END IF;
         END IF;         
      END LOOP;
      
        -- Process the last record
      IF (Transaction_SYS.Is_Session_Deferred) OR (shipment_online_process_db_ = Fnd_Boolean_API.DB_TRUE) THEN
         Reserve_Shipment_API.Reserve_Lines__(attr_);
      ELSE      
         Transaction_SYS.Deferred_Call('Reserve_Shipment_API.Reserve_Lines__', attr_, description_);           
      END IF; 
      
   END IF; 
END Reserve___;
                

PROCEDURE Reserve_Line___ (
   source_ref1_             IN VARCHAR2,
   source_ref2_             IN VARCHAR2,
   source_ref3_             IN VARCHAR2,
   source_ref4_             IN VARCHAR2,
   source_ref_type_db_      IN VARCHAR2,
   shipment_id_             IN NUMBER,
   contract_                IN VARCHAR2,
   inventory_part_no_       IN VARCHAR2,
   warehouse_id_            IN VARCHAR2,
   availability_control_id_ IN VARCHAR2 )                 
IS    
   qty_to_reserve_    NUMBER;
   quantity_reserved_ NUMBER := 0;
BEGIN
   qty_to_reserve_ := Shipment_Line_API.Get_Qty_To_Reserve(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   IF(inventory_part_no_ IS NULL) THEN
      Reserve_Non_Inventory___(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, shipment_id_, qty_to_reserve_);
   ELSE
      Reserve_Inventory(quantity_reserved_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_,
                        shipment_id_, contract_, inventory_part_no_, warehouse_id_, availability_control_id_, qty_to_reserve_);
   END IF;
END Reserve_Line___;


PROCEDURE Reserve_Non_Inventory___ (
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2,
   source_ref_type_db_     IN VARCHAR2,    
   shipment_id_            IN NUMBER,
   qty_to_reserve_         IN NUMBER)   
IS   
   ship_old_qty_to_ship_ NUMBER;
BEGIN
   ship_old_qty_to_ship_ := Shipment_Line_API.Get_Qty_To_Ship_By_Source(shipment_id_, source_ref1_, source_ref2_,
                                                                        source_ref3_, source_ref4_, source_ref_type_db_);
   Shipment_Line_API.Modify_Qty_To_Ship(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                        source_ref_type_db_, ship_old_qty_to_ship_ + qty_to_reserve_);
                                        
   -- TODO: Call the source....
END Reserve_Non_Inventory___;


PROCEDURE Reserve_Manually___ (
   info_                   OUT VARCHAR2,  
   shipment_id_            IN  NUMBER,
   source_ref1_            IN  VARCHAR2,
   source_ref2_            IN  VARCHAR2,
   source_ref3_            IN  VARCHAR2,
   source_ref4_            IN  VARCHAR2,
   source_ref_type_db_     IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   inventory_part_no_      IN  VARCHAR2,
   configuration_id_       IN  VARCHAR2,
   location_no_            IN  VARCHAR2,
   lot_batch_no_           IN  VARCHAR2,
   serial_no_              IN  VARCHAR2,
   eng_chg_level_          IN  VARCHAR2,
   waiv_dev_rej_no_        IN  VARCHAR2,
   activity_seq_           IN  NUMBER,
   handling_unit_id_       IN  NUMBER,
   qty_to_reserve_         IN  NUMBER,
   sender_type_            IN  VARCHAR2,
   sender_id_              IN  VARCHAR2,
   source_ref_demand_code_ IN  VARCHAR2,
   pick_by_choice_blocked_ IN  VARCHAR2)
IS  
   warehouse_rec_    Warehouse_API.Public_Rec;
BEGIN      
   IF (sender_type_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      warehouse_rec_ := Warehouse_API.Get(sender_id_);
   END IF;

   Inventory_Part_Reservation_API.Reserve_Part(contract_                      => contract_,
                                               part_no_                       => inventory_part_no_,
                                               configuration_id_              => configuration_id_,
                                               location_no_                   => location_no_,
                                               lot_batch_no_                  => lot_batch_no_,
                                               serial_no_                     => serial_no_,
                                               eng_chg_level_                 => eng_chg_level_,
                                               waiv_dev_rej_no_               => waiv_dev_rej_no_,
                                               activity_seq_                  => activity_seq_,
                                               handling_unit_id_              => handling_unit_id_,
                                               quantity_                      => qty_to_reserve_,
                                               source_ref_type_db_            => Get_Inv_Res_Source_Type_Db(source_ref_type_db_),
                                               source_ref1_                   => source_ref1_,
                                               source_ref2_                   => NVL(source_ref2_,'*'),
                                               source_ref3_                   => NVL(source_ref3_,'*'),
                                               source_ref4_                   => NVL(source_ref4_,'*'),
                                               shipment_id_                   => shipment_id_,  
                                               ignore_this_avail_control_id_  => warehouse_rec_.availability_control_id,
                                               string_parameter1_             => NULL,
                                               string_parameter2_             => 'FALSE',
                                               pick_by_choice_blocked_db_     => pick_by_choice_blocked_,
                                               source_ref_demand_code_        => source_ref_demand_code_ );
   IF (Shipment_Line_API.Get_Qty_To_Reserve(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_) < 0) THEN 
      Error_SYS.Record_General(lu_name_, 'QTYOVERRIDESSHP: Cannot assign more than the required quantity on the shipment line.');
   END IF;
   
   info_ := Client_SYS.Get_All_Info;
END Reserve_Manually___;


-- Reserve_Manually_Hu___
--   This method will reserve/unreserve a everything in each handling unit in the list. 
PROCEDURE Reserve_Manually_Hu___(
   info_                   OUT VARCHAR2,    
   source_ref1_            IN  VARCHAR2,
   source_ref2_            IN  VARCHAR2,
   source_ref3_            IN  VARCHAR2,
   source_ref4_            IN  VARCHAR2,
   handling_unit_id_list_  IN  VARCHAR2,
   shipment_id_            IN  NUMBER,
   unreserve_              IN  BOOLEAN,
   source_ref_type_db_     IN  VARCHAR2,
   sender_type_            IN  VARCHAR2,
   sender_id_              IN  VARCHAR2,
   part_ownership_         IN  VARCHAR2 DEFAULT NULL,
   owner_                  IN  VARCHAR2 DEFAULT NULL,
   condition_code_         IN  VARCHAR2 DEFAULT NULL) 
IS
   handling_unit_id_tab_ Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Handling_Unit_API.Get_Handling_Unit_Id_Tab(handling_unit_id_list_);
   
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST.. handling_unit_id_tab_.LAST LOOP
         Reserve_Manually_Hu___(info_                 => info_,                                 
                                source_ref1_          => source_ref1_,
                                source_ref2_          => source_ref2_,
                                source_ref3_          => source_ref3_,
                                source_ref4_          => source_ref4_,
                                handling_unit_id_     => handling_unit_id_tab_(i).handling_unit_id,
                                shipment_id_          => shipment_id_,
                                unreserve_            => unreserve_,
                                source_ref_type_db_   => source_ref_type_db_,
                                part_ownership_       => part_ownership_,
                                owner_                => owner_,
                                condition_code_       => condition_code_,
                                sender_type_          => sender_type_,
                                sender_id_            => sender_id_);
      END LOOP;
   END IF;
END Reserve_Manually_Hu___;


-- Reserve_Manually_Hu___
--   This method will reserve/unreserve a everything in a handling unit. 
PROCEDURE Reserve_Manually_Hu___ (
   info_                OUT VARCHAR2,   
   source_ref1_         IN  VARCHAR2,
   source_ref2_         IN  VARCHAR2,
   source_ref3_         IN  VARCHAR2,
   source_ref4_         IN  VARCHAR2,
   handling_unit_id_    IN  NUMBER,
   shipment_id_         IN  NUMBER,
   unreserve_           IN  BOOLEAN,
   source_ref_type_db_  IN  VARCHAR2,
   sender_type_         IN  VARCHAR2,
   sender_id_           IN  VARCHAR2,
   part_ownership_      IN  VARCHAR2 DEFAULT NULL,
   owner_               IN  VARCHAR2 DEFAULT NULL,
   condition_code_      IN  VARCHAR2 DEFAULT NULL)
IS
   inv_part_stock_tab_ Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   
   qty_assigned_     NUMBER;
   qty_to_reserve_   NUMBER;
   current_info_     VARCHAR2(20000);
BEGIN
   inv_part_stock_tab_ := Handling_Unit_API.Get_Part_Stock_Onhand_Content(handling_unit_id_);
   
   IF (inv_part_stock_tab_.COUNT > 0) THEN
      FOR i IN inv_part_stock_tab_.FIRST .. inv_part_stock_tab_.LAST LOOP
         qty_assigned_ := Get_Qty_Reserved(source_ref1_       => source_ref1_,
                                           source_ref2_       => source_ref2_,
                                           source_ref3_       => source_ref3_,
                                           source_ref4_       => source_ref4_, 
                                           contract_          => inv_part_stock_tab_(i).contract, 
                                           inventory_part_no_ => inv_part_stock_tab_(i).part_no, 
                                           location_no_       => inv_part_stock_tab_(i).location_no, 
                                           lot_batch_no_      => inv_part_stock_tab_(i).lot_batch_no, 
                                           serial_no_         => inv_part_stock_tab_(i).serial_no, 
                                           eng_chg_level_     => inv_part_stock_tab_(i).eng_chg_level, 
                                           waiv_dev_rej_no_   => inv_part_stock_tab_(i).waiv_dev_rej_no, 
                                           activity_seq_      => inv_part_stock_tab_(i).activity_seq, 
                                           handling_unit_id_  => inv_part_stock_tab_(i).handling_unit_id, 
                                           configuration_id_  => inv_part_stock_tab_(i).configuration_id, 
                                           pick_list_no_      => '*', 
                                           shipment_id_       => shipment_id_,
                                           source_ref_type_db_ => source_ref_type_db_);
         
         IF (unreserve_) THEN
            qty_to_reserve_ := -qty_assigned_;
         ELSE
            qty_to_reserve_ := inv_part_stock_tab_(i).quantity - qty_assigned_;
         END IF;
         
         IF (qty_to_reserve_ != 0) THEN
            Reserve_Manually(info_                  => current_info_,        
                             shipment_id_           => shipment_id_,
                             source_ref1_           => source_ref1_,
                             source_ref2_           => source_ref2_,
                             source_ref3_           => source_ref3_,
                             source_ref4_           => source_ref4_,
                             source_ref_type_db_    => source_ref_type_db_,
                             contract_              => inv_part_stock_tab_(i).contract,
                             inventory_part_no_     => inv_part_stock_tab_(i).part_no,
                             configuration_id_      => inv_part_stock_tab_(i).configuration_id,
                             location_no_           => inv_part_stock_tab_(i).location_no,
                             lot_batch_no_          => inv_part_stock_tab_(i).lot_batch_no,
                             serial_no_             => inv_part_stock_tab_(i).serial_no,
                             eng_chg_level_         => inv_part_stock_tab_(i).eng_chg_level,
                             waiv_dev_rej_no_       => inv_part_stock_tab_(i).waiv_dev_rej_no,
                             activity_seq_          => inv_part_stock_tab_(i).activity_seq,
                             handling_unit_id_      => inv_part_stock_tab_(i).handling_unit_id,
                             qty_to_reserve_        => qty_to_reserve_,
                             input_qty_             => NULL,
                             input_unit_meas_       => NULL,
                             input_conv_factor_     => NULL,
                             input_variable_values_ => NULL,
                             part_ownership_        => part_ownership_,
                             owner_                 => owner_,
                             condition_code_        => condition_code_,
                             sender_type_           => sender_type_,
                             sender_id_             => sender_id_,
                             source_ref_demand_code_ => NULL );
         END IF;
                             
         info_ := current_info_ || info_;
      END LOOP;
   END IF;
END Reserve_Manually_Hu___;


FUNCTION Get_Expiration_Control_Date___ (  
   shipment_id_     IN NUMBER,
   contract_        IN VARCHAR2) RETURN DATE
IS  
   expiration_control_date_ DATE;   
   planned_delivery_date_   DATE;   
   today_                   DATE := trunc(Site_API.Get_Site_Date(contract_));
BEGIN     
   planned_delivery_date_ := Shipment_API.Get_Planned_Delivery_Date(shipment_id_);
   IF (planned_delivery_date_ > today_) THEN
      expiration_control_date_ := planned_delivery_date_;    
   END IF;   
   RETURN (expiration_control_date_); 
END Get_Expiration_Control_Date___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Reserve_Lines__
-- This will execute line by line for specific source ref1.
PROCEDURE Reserve_Lines__ (
   attr_   IN  VARCHAR2 )
IS
   source_ref1_             VARCHAR2(50);
   source_ref2_             VARCHAR2(50);
   source_ref3_             VARCHAR2(50);
   source_ref4_             VARCHAR2(50);
   source_ref_type_db_      VARCHAR2(20);
   contract_                VARCHAR2(5);
   shipment_id_             NUMBER;
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(2000);
   ptr_                     NUMBER;
   inventory_part_no_       VARCHAR2(25);
   warehouse_id_            VARCHAR2(15);
   availability_control_id_ VARCHAR2(25); 
   
BEGIN   
   source_ref1_             := Client_SYS.Get_Item_Value('SOURCE_REF1',             attr_);
   shipment_id_             := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SHIPMENT_ID', attr_));
   contract_                := Client_SYS.Get_Item_Value('CONTRACT',                attr_);
   source_ref_type_db_      := Client_SYS.Get_Item_Value('SOURCE_REF_TYPE',         attr_);
   warehouse_id_            := Client_SYS.Get_Item_Value('WAREHOUSE_ID',            attr_);
   availability_control_id_ := Client_SYS.Get_Item_Value('AVAILABILITY_CONTROL_ID', attr_);
   
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP        
      IF (name_ = 'SOURCE_REF2') THEN
         source_ref2_ := value_;
      ELSIF (name_ = 'SOURCE_REF3') THEN
         source_ref3_ := value_;
      ELSIF (name_ = 'SOURCE_REF4') THEN
         source_ref4_ := value_;
      ELSIF(name_ = 'INVENTORY_PART_NO') THEN
         inventory_part_no_     := value_;
         -- Reserve the line
         Reserve_Line___(source_ref1_, 
                         source_ref2_, 
                         source_ref3_, 
                         source_ref4_, 
                         source_ref_type_db_, 
                         shipment_id_, 
                         contract_, 
                         inventory_part_no_,
                         warehouse_id_,
                         availability_control_id_);         
       
      END IF;
   END LOOP;      
END Reserve_Lines__;


-- Reserve_Manually_Hu__
--   Reserves everything(!) in a list of handling units to a certain source.
PROCEDURE Reserve_Manually_Hu__ (
   info_                  OUT VARCHAR2, 
   source_ref1_           IN  VARCHAR2,
   source_ref2_           IN  VARCHAR2,
   source_ref3_           IN  VARCHAR2,
   source_ref4_           IN  VARCHAR2, 
   handling_unit_id_list_ IN  VARCHAR2,
   shipment_id_           IN  NUMBER,
   source_ref_type_db_    IN  VARCHAR2,
   sender_type_           IN  VARCHAR2,
   sender_id_             IN  VARCHAR2,
   part_ownership_        IN  VARCHAR2 DEFAULT NULL,
   owner_                 IN  VARCHAR2 DEFAULT NULL,
   condition_code_        IN  VARCHAR2 DEFAULT NULL)
IS
BEGIN
   Reserve_Manually_Hu___(info_                    => info_,                          
                          source_ref1_             => source_ref1_,
                          source_ref2_             => source_ref2_,
                          source_ref3_             => source_ref3_,
                          source_ref4_             => source_ref4_,
                          handling_unit_id_list_   => handling_unit_id_list_,
                          shipment_id_             => shipment_id_,
                          unreserve_               => FALSE,
                          source_ref_type_db_      => source_ref_type_db_,
                          part_ownership_          => part_ownership_,
                          owner_                   => owner_,
                          condition_code_          => condition_code_,
                          sender_type_             => sender_type_,
                          sender_id_               => sender_id_);
END Reserve_Manually_Hu__;


-- Unreserve_Manually_Hu__
--   Unreserves everything(!) in a list of handling units on a certain source.
PROCEDURE Unreserve_Manually_Hu__ (
   info_                  OUT VARCHAR2,    
   source_ref1_           IN  VARCHAR2,
   source_ref2_           IN  VARCHAR2,
   source_ref3_           IN  VARCHAR2,
   source_ref4_           IN  VARCHAR2, 
   handling_unit_id_list_ IN  VARCHAR2,
   shipment_id_           IN  NUMBER,
   source_ref_type_db_    IN  VARCHAR2,
   sender_type_           IN  VARCHAR2,
   sender_id_             IN  VARCHAR2,
   part_ownership_        IN  VARCHAR2 DEFAULT NULL,
   owner_                 IN  VARCHAR2 DEFAULT NULL,
   condition_code_        IN  VARCHAR2 DEFAULT NULL)
IS
BEGIN
   Reserve_Manually_Hu___(info_                    => info_,                          
                          source_ref1_             => source_ref1_,
                          source_ref2_             => source_ref2_,
                          source_ref3_             => source_ref3_,
                          source_ref4_             => source_ref4_,
                          handling_unit_id_list_   => handling_unit_id_list_,
                          shipment_id_             => shipment_id_,
                          unreserve_               => TRUE,
                          source_ref_type_db_      => source_ref_type_db_,
                          part_ownership_          => part_ownership_,
                          owner_                   => owner_,
                          condition_code_          => condition_code_,
                          sender_type_             => sender_type_,
                          sender_id_               => sender_id_);
END Unreserve_Manually_Hu__;


@UncheckedAccess
FUNCTION Get_Qty_Reserved_In_HU__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,  
   handling_unit_id_   IN NUMBER,    
   pick_list_no_       IN VARCHAR2,
   shipment_id_        IN NUMBER,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   qty_reserved_ NUMBER := 0;
   CURSOR get_qty_reserved IS
      SELECT SUM(qty_assigned)
      FROM   shipment_source_reservation
      WHERE  source_ref1         = source_ref1_
      AND    source_ref2         = NVL(source_ref2_,'*')
      AND    source_ref3         = NVL(source_ref3_,'*')
      AND    source_ref4         = NVL(source_ref4_,'*')
      AND    source_ref_type_db  = source_ref_type_db_
      AND    handling_unit_id IN (SELECT handling_unit_id
                                  FROM handling_unit_pub
                                  CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                                  START WITH       handling_unit_id = handling_unit_id_)
      AND    pick_list_no        = pick_list_no_
      AND    shipment_id         = shipment_id_;
BEGIN
   OPEN get_qty_reserved;
   FETCH get_qty_reserved INTO qty_reserved_;
   CLOSE get_qty_reserved;
   RETURN NVL(qty_reserved_, 0);
END Get_Qty_Reserved_In_HU__;


@UncheckedAccess
FUNCTION Get_Total_Qty_Reserved_In_HU__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,  
   handling_unit_id_   IN NUMBER,        
   shipment_id_        IN NUMBER,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   tot_qty_reserved_ NUMBER := 0;
   CURSOR get_tot_qty_reserved IS
      SELECT SUM(qty_assigned)
      FROM   shipment_source_reservation
      WHERE  source_ref1         = source_ref1_
      AND    source_ref2         = NVL(source_ref2_,'*')
      AND    source_ref3         = NVL(source_ref3_,'*')
      AND    source_ref4         = NVL(source_ref4_,'*')
      AND    source_ref_type_db  = source_ref_type_db_
      AND    handling_unit_id IN (SELECT handling_unit_id
                                  FROM handling_unit_pub
                                  CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                                  START WITH       handling_unit_id = handling_unit_id_)        
      AND    shipment_id         = shipment_id_;
BEGIN
   OPEN get_tot_qty_reserved;
   FETCH get_tot_qty_reserved INTO tot_qty_reserved_;
   CLOSE get_tot_qty_reserved;
   RETURN tot_qty_reserved_;
END Get_Total_Qty_Reserved_In_HU__;


@UncheckedAccess
FUNCTION Get_Order_Sup_Demand_Type_Db__ (
   logistics_source_type_db_ IN  VARCHAR2) RETURN VARCHAR2
IS
   order_supply_demand_type_db_ VARCHAR2(20);
BEGIN
   order_supply_demand_type_db_ := CASE logistics_source_type_db_
                                      WHEN Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER THEN 
                                           Order_Supply_Demand_Type_API.DB_CUST_ORDER
                                      WHEN Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES THEN 
                                           Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES
                                      WHEN Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER THEN
                                           Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER 
                                   END;
   RETURN (order_supply_demand_type_db_);
END Get_Order_Sup_Demand_Type_Db__;
                                

@UncheckedAccess
FUNCTION Get_Hndl_Unt_Snpshot_Type_Db__ (
   logistics_source_type_db_ IN  VARCHAR2) RETURN VARCHAR2
IS
   handl_unit_snapshot_type_db_ VARCHAR2(20);
BEGIN
   handl_unit_snapshot_type_db_ := CASE logistics_source_type_db_
                                      WHEN Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER THEN 
                                           Handl_Unit_Snapshot_Type_API.DB_MAN_RES_CUST_ORD
                                      WHEN Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES THEN 
                                           Handl_Unit_Snapshot_Type_API.DB_MAN_RES_PROJ_DEL
                                      WHEN Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER THEN 
                                           Handl_Unit_Snapshot_Type_API.DB_MAN_RES_SHIP_ORD
                                   END;
   RETURN (handl_unit_snapshot_type_db_);
END Get_Hndl_Unt_Snpshot_Type_Db__;

-- This method is used to generate transport tasks with batch. 
PROCEDURE Move_With_Trans_Task__ (
   message_ IN VARCHAR2 )
IS
   count_                            NUMBER;
   name_arr_                         Message_SYS.name_table;
   value_arr_                        Message_SYS.line_table;
   contract_                         VARCHAR2(5);
   warehouse_id_                     VARCHAR2(15);
   bay_id_                           VARCHAR2(5);
   row_id_                           VARCHAR2(5);
   tier_id_                          VARCHAR2(5); 
   bin_id_                           VARCHAR2(5);
   storage_zone_id_                  VARCHAR2(30);
   to_location_                      VARCHAR2(35);
   shipment_id_                      VARCHAR2(2000);
   consol_shipment_id_               VARCHAR2(2000);
   shipment_type_                    VARCHAR2(2000);
   receiver_type_                    VARCHAR2(2000);
   receiver_id_                      VARCHAR2(2000);
   ship_via_code_                    VARCHAR2(2000);
   route_id_                         VARCHAR2(2000);
   forwarder_id_                     VARCHAR2(2000);
   shipment_location_no_             VARCHAR2(2000);
   planned_ship_period_              VARCHAR2(2000);
   planned_ship_date_                DATE;
   planned_due_date_                 DATE;   
   include_full_qty_of_top_hu_       VARCHAR2(1);
   exclude_stock_attached_to_hu_     VARCHAR2(1);
   exclude_stock_not_attached_to_hu_ VARCHAR2(1);
   exclude_hu_to_pick_in_one_step_   VARCHAR2(1);
   location_no_tab_                  Warehouse_Bay_Bin_API.Location_No_Tab;  
   move_reserve_tab_                 Move_Reserve_Tab;
   due_date_execution_offset_        NUMBER;
   ship_date_execution_offset_       NUMBER;
   
   CURSOR get_reserv_details IS
      SELECT part_no, location_no from_location_no, source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type_db, configuration_id, lot_batch_no, serial_no,
             eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, pick_list_no, shipment_id, qty_to_move    
      FROM move_shipment_reserv_with_tt
      WHERE contract = contract_    
      AND  ((UPPER(warehouse_id) = UPPER(warehouse_id_)) OR warehouse_id_ IS NULL)
      AND  ((UPPER(bay_id)       = UPPER(bay_id_)) OR bay_id_ IS NULL)
      AND  ((UPPER(row_id)       = UPPER(row_id_)) OR row_id_ IS NULL)
      AND  ((UPPER(tier_id)      = UPPER(tier_id_)) OR tier_id_ IS NULL)
      AND  ((UPPER(bin_id)       = UPPER(bin_id_)) OR bin_id_ IS NULL) 
      AND  ((storage_zone_id_ IS NOT NULL AND location_no IN (SELECT * FROM TABLE(location_no_tab_))) OR (storage_zone_id_ IS NULL))
      AND  (Report_SYS.Parse_Parameter(shipment_id, shipment_id_) = db_true_)
      AND  ((Report_SYS.Parse_Parameter(consol_shipment_id, consol_shipment_id_) = db_true_) OR (consol_shipment_id_ = '%' AND consol_shipment_id IS NULL))
      AND  ((Report_SYS.Parse_Parameter(shipment_type, shipment_type_) = db_true_) OR (shipment_type_ = '%' AND shipment_type IS NULL))
      AND  (Report_SYS.Parse_Parameter(receiver_type, receiver_type_) = db_true_)
      AND  ((Report_SYS.Parse_Parameter(receiver_id, receiver_id_) = db_true_) OR (receiver_id_ = '%' AND receiver_id IS NULL))
      AND  ((Report_SYS.Parse_Parameter(ship_via_code, ship_via_code_) = db_true_) OR (ship_via_code_ = '%' AND ship_via_code IS NULL))
      AND  ((Report_SYS.Parse_Parameter(route_id, route_id_) = db_true_) OR (route_id_ = '%' AND route_id IS NULL))
      AND  ((Report_SYS.Parse_Parameter(forwarder_id, forwarder_id_) = db_true_) OR (forwarder_id_ = '%' AND forwarder_id IS NULL))
      AND  ((Report_SYS.Parse_Parameter(shipment_location_no, shipment_location_no_) = db_true_) OR (shipment_location_no_ = '%' AND shipment_location_no IS NULL))
      AND  ((Report_SYS.Parse_Parameter(planned_ship_period, planned_ship_period_) = db_true_) OR (planned_ship_period_ = '%' AND planned_ship_period IS NULL))   
      AND  ((planned_ship_date <= NVL(planned_ship_date_, planned_ship_date)) OR (TO_CHAR(planned_ship_date)) IS NULL)
      AND  ((TRUNC(planned_ship_date) <= NVL(TRUNC(planned_ship_date_), TRUNC(planned_ship_date))) OR (TO_CHAR(TRUNC(planned_ship_date)) IS NULL))
      AND  ((TRUNC(planned_due_date) <= NVL(TRUNC(planned_due_date_), TRUNC(planned_due_date))) OR (TO_CHAR(TRUNC(planned_due_date)) IS NULL))
      AND  ((exclude_stock_attached_to_hu_ = 'N' AND handling_unit_id != 0) OR
           (exclude_stock_not_attached_to_hu_ = 'N' AND handling_unit_id = 0));
     
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'WAREHOUSE') THEN
         warehouse_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'BAY') THEN
         bay_id_ := value_arr_(n_);   
      ELSIF (name_arr_(n_) = 'ROW') THEN
         row_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'TIER') THEN
         tier_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'BIN') THEN
         bin_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'STORAGE_ZONE') THEN
         storage_zone_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'TO_LOCATION') THEN
         to_location_ := value_arr_(n_);         
      ELSIF (name_arr_(n_) = 'SHIPMENT_ID') THEN
         shipment_id_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'CONSOL_SHIPMENT_ID') THEN
         consol_shipment_id_ := NVL(value_arr_(n_), '%'); 
      ELSIF (name_arr_(n_) = 'SHIPMENT_TYPE') THEN
         shipment_type_ := NVL(value_arr_(n_), '%');   
      ELSIF (name_arr_(n_) = 'RECEIVER_TYPE') THEN
         receiver_type_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'RECEIVER_ID') THEN
         receiver_id_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'SHIP_VIA_CODE') THEN
         ship_via_code_ := NVL(value_arr_(n_), '%');   
      ELSIF (name_arr_(n_) = 'ROUTE_ID') THEN
         route_id_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'FORWARDER_ID') THEN
         forwarder_id_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'SHIPMENT_LOCATION_NO') THEN
         shipment_location_no_ := NVL(value_arr_(n_), '%');   
      ELSIF (name_arr_(n_) = 'PLANNED_SHIP_PERIOD') THEN
         planned_ship_period_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'PLANNED_SHIP_DATE') THEN
         planned_ship_date_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'PLANNED_DUE_DATE') THEN
         planned_due_date_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'INCLUDE_FULL_QTY_OF_TOP_HU') THEN
         include_full_qty_of_top_hu_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'EXCLUDE_STOCK_ATTACHED_TO_HU') THEN
         exclude_stock_attached_to_hu_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'EXCLUDE_STOCK_NOT_ATTACH_TO_HU') THEN
         exclude_stock_not_attached_to_hu_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'EXCLUDE_HU_TO_PICK_IN_ONE_STEP') THEN
         exclude_hu_to_pick_in_one_step_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'DUE_DATE_EXECUTION_OFFSET') THEN
         due_date_execution_offset_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'SHIP_DATE_EXECUTION_OFFSET') THEN
         ship_date_execution_offset_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;
   IF (warehouse_id_ = '%') THEN
      warehouse_id_ := NULL;
   END IF;  
   IF (bay_id_ = '%') THEN
      bay_id_ := NULL;
   END IF;
   IF (row_id_ = '%') THEN
      row_id_ := NULL;
   END IF;
   IF (tier_id_ = '%') THEN
      tier_id_ := NULL;
   END IF;
   IF (bin_id_ = '%') THEN
      bin_id_ := NULL;
   END IF;
   IF (storage_zone_id_ = '%') THEN
      storage_zone_id_ := NULL;
   END IF;   
   IF (storage_zone_id_ IS NOT NULL) THEN
      location_no_tab_ := Warehouse_Bay_Bin_API.Get_Storage_Zone_Locations(contract_, storage_zone_id_);
   END IF;
   IF ((due_date_execution_offset_ IS NOT NULL) AND (planned_due_date_ IS NULL)) THEN      
      planned_due_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - due_date_execution_offset_;
   ELSE
      planned_due_date_ := NVL(planned_due_date_,SYSDATE);
   END IF;

   IF ((ship_date_execution_offset_ IS NOT NULL) AND (planned_ship_date_ IS NULL)) THEN      
      planned_ship_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - ship_date_execution_offset_;
   ELSE
      planned_ship_date_ := NVL(planned_ship_date_,SYSDATE);
   END IF;
    
   OPEN get_reserv_details;
   FETCH get_reserv_details BULK COLLECT INTO move_reserve_tab_;
   CLOSE get_reserv_details;
   IF (move_reserve_tab_.COUNT() > 0) THEN
      Move_Res_With_Trans_Task(contract_, move_reserve_tab_, to_location_, include_full_qty_of_top_hu_, exclude_hu_to_pick_in_one_step_);
   END IF; 
 
END Move_With_Trans_Task__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Post_New_Reserv_Actions
--   Post actions of new reservation record
PROCEDURE Post_New_Reservation_Actions (
   source_ref1_                     IN VARCHAR2,
   source_ref2_                     IN VARCHAR2,
   source_ref3_                     IN VARCHAR2,
   source_ref4_                     IN VARCHAR2,
   inv_part_res_source_type_db_     IN VARCHAR2,    
   shipment_id_                     IN NUMBER,
   qty_reserved_                    IN NUMBER,
   qty_picked_                      IN NUMBER,   
   reassignment_type_               IN VARCHAR2,
   move_to_ship_location_           IN VARCHAR2)
IS  
   logistics_source_type_db_ VARCHAR2(50);   
BEGIN  
   logistics_source_type_db_ := Get_Logistic_Source_Type_Db(inv_part_res_source_type_db_);
   
   IF (shipment_id_ != 0) THEN     
      -- Post actions
      IF (NVL(move_to_ship_location_, Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_FALSE) THEN       
         Shipment_Line_API.Update_On_Reserve(shipment_id_, 
                                             source_ref1_, 
                                             source_ref2_, 
                                             source_ref3_, 
                                             source_ref4_, 
                                             logistics_source_type_db_,
                                             qty_reserved_, 
                                             qty_picked_,
                                             qty_modification_source_ => reassignment_type_,
                                             qty_shipped_ => NULL);         
      END IF;
   END IF;
   
   Shipment_Source_Utility_API.Post_Reservation_Actions(shipment_id_, source_ref1_, source_ref2_, source_ref3_, 
                                                               source_ref4_, logistics_source_type_db_);
END Post_New_Reservation_Actions;


-- Post_Update_Reserv_Actions
--   Post actions of updating reservation record
PROCEDURE Post_Update_Reserv_Actions (
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN VARCHAR2,
   inv_part_res_source_type_db_  IN VARCHAR2,
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
   pick_list_no_                 IN VARCHAR2,
   shipment_id_                  IN NUMBER,
   qty_reserved_                 IN NUMBER,
   old_qty_reserved_             IN NUMBER,
   qty_picked_                   IN NUMBER,
   old_qty_picked_               IN NUMBER,
   qty_shipped_                  IN NUMBER,
   reassignment_type_            IN VARCHAR2,
   move_to_ship_location_        IN VARCHAR2,
   ship_handling_unit_id_        IN NUMBER DEFAULT NULL)
IS  
   logistics_source_type_db_     VARCHAR2(50);    
   shipment_line_no_             NUMBER;       
   info_                         VARCHAR2(1000);
BEGIN            
   logistics_source_type_db_ := Get_Logistic_Source_Type_Db(inv_part_res_source_type_db_);    
   
   IF (NVL(shipment_id_, 0) != 0) THEN
      -- Post actions
      IF (NVL(move_to_ship_location_, Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_FALSE) THEN               
         IF (reassignment_type_ = 'UNDO_DELIVERY') THEN
            Shipment_Line_API.Update_On_Reserve(shipment_id_, 
                                                source_ref1_, 
                                                source_ref2_, 
                                                source_ref3_, 
                                                source_ref4_, 
                                                logistics_source_type_db_,
                                                qty_reserved_ - old_qty_reserved_, 
                                                qty_picked_ - old_qty_picked_,
                                                NULL,
                                                qty_shipped_,
                                                'TRUE');
         ELSE
            Shipment_Line_API.Update_On_Reserve(shipment_id_, 
                                                source_ref1_, 
                                                source_ref2_, 
                                                source_ref3_, 
                                                source_ref4_, 
                                                logistics_source_type_db_,
                                                qty_reserved_ - old_qty_reserved_, 
                                                qty_picked_ - old_qty_picked_,
                                                qty_modification_source_ => reassignment_type_,
                                                qty_shipped_ => NULL);
         END IF;
      END IF;    

      IF ((NVL(reassignment_type_,  Database_Sys.string_null_) != 'HANDLING_UNIT') AND ((qty_reserved_ - old_qty_reserved_) < 0)) THEN
            shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, 
                                                                                source_ref4_, logistics_source_type_db_ );
            Shipment_Reserv_Handl_Unit_API.Remove_Or_Modify(info_                   => info_,
                                                            source_ref1_            => source_ref1_, 
                                                            source_ref2_            => NVL(source_ref2_,'*'), 
                                                            source_ref3_            => NVL(source_ref3_,'*'), 
                                                            source_ref4_            => NVL(source_ref4_,'*'),  
                                                            contract_               => contract_, 
                                                            part_no_                => part_no_, 
                                                            location_no_            => location_no_,
                                                            lot_batch_no_           => lot_batch_no_, 
                                                            serial_no_              => serial_no_, 
                                                            eng_chg_level_          => eng_chg_level_, 
                                                            waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                            activity_seq_           => activity_seq_, 
                                                            reserv_handling_unit_id_=> handling_unit_id_,
                                                            configuration_id_       => configuration_id_, 
                                                            pick_list_no_           => pick_list_no_, 
                                                            shipment_id_            => shipment_id_,
                                                            shipment_line_no_       => shipment_line_no_,
                                                            new_quantity_           => qty_reserved_,
                                                            old_quantity_           => old_qty_reserved_,
                                                            handling_unit_id_       => ship_handling_unit_id_);
      END IF;  
   END IF;
   
   Shipment_Source_Utility_API.Post_Reservation_Actions(shipment_id_, source_ref1_, source_ref2_, source_ref3_, 
                                                               source_ref4_, logistics_source_type_db_);
END Post_Update_Reserv_Actions;


-- Post_Unreservation_Actions
--   Handling shipmemt post actions when removing a reservation from InventoryPartReservation
PROCEDURE Post_Unreservation_Actions (
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN VARCHAR2,
   inv_part_res_source_type_db_  IN VARCHAR2,
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
   pick_list_no_                 IN VARCHAR2,
   shipment_id_                  IN NUMBER,
   qty_reserved_                 IN NUMBER,
   qty_picked_                   IN NUMBER,  
   reassignment_type_            IN VARCHAR2,
   move_to_ship_location_        IN VARCHAR2)
IS
   logistics_source_type_db_     VARCHAR2(50);    
   shipment_line_no_             NUMBER;
   reserved_handling_unit_exist_ VARCHAR2(5);   
BEGIN   
   logistics_source_type_db_ := Get_Logistic_Source_Type_Db(inv_part_res_source_type_db_); 
   
   IF (NVL(shipment_id_, 0) != 0) THEN
      -- Post actions  
      IF (NVL(move_to_ship_location_,Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_FALSE) THEN
         Shipment_Line_API.Update_On_Reserve(shipment_id_, 
                                             source_ref1_, 
                                             source_ref2_, 
                                             source_ref3_, 
                                             source_ref4_, 
                                             logistics_source_type_db_,
                                             -(qty_reserved_), 
                                             -(qty_picked_),
                                             qty_modification_source_ => reassignment_type_,
                                             qty_shipped_ => NULL);
      END IF;

      shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, 
                                                                          source_ref1_, 
                                                                          source_ref2_, 
                                                                          source_ref3_, 
                                                                          source_ref4_, 
                                                                          logistics_source_type_db_ );

      reserved_handling_unit_exist_ := Shipment_Reserv_Handl_Unit_API.Handling_Unit_Exist(source_ref1_, 
                                                                                          NVL(source_ref2_,'*'), 
                                                                                          NVL(source_ref3_,'*'), 
                                                                                          NVL(source_ref4_,'*'), 
                                                                                          contract_, 
                                                                                          part_no_, 
                                                                                          location_no_,
                                                                                          lot_batch_no_, 
                                                                                          serial_no_, 
                                                                                          eng_chg_level_, 
                                                                                          waiv_dev_rej_no_, 
                                                                                          activity_seq_, 
                                                                                          handling_unit_id_,
                                                                                          configuration_id_,
                                                                                          pick_list_no_, 
                                                                                          shipment_id_,
                                                                                          shipment_line_no_ );
      IF (reserved_handling_unit_exist_ = Fnd_Boolean_API.DB_TRUE) THEN
         Shipment_Reserv_Handl_Unit_API.Remove_Handling_Unit(source_ref1_, 
                                                             NVL(source_ref2_,'*'), 
                                                             NVL(source_ref3_,'*'), 
                                                             NVL(source_ref4_,'*'), 
                                                             contract_, 
                                                             part_no_, 
                                                             location_no_,
                                                             lot_batch_no_, 
                                                             serial_no_, 
                                                             eng_chg_level_, 
                                                             waiv_dev_rej_no_, 
                                                             activity_seq_, 
                                                             handling_unit_id_,
                                                             configuration_id_,
                                                             pick_list_no_, 
                                                             shipment_id_,
                                                             shipment_line_no_);
      END IF;
   END IF;
   
   Shipment_Source_Utility_API.Post_Reservation_Actions(shipment_id_, source_ref1_, source_ref2_, source_ref3_, 
                                                               source_ref4_, logistics_source_type_db_);
END Post_Unreservation_Actions;


-- Reserve
-- This will call the correct reservation object in order to handle automaic reservation.
PROCEDURE Reserve (
   reserve_ship_tab_     IN OUT   Reserve_Shipment_Table,   
   shipment_id_          IN       NUMBER,
   source_ref_type_db_   IN       VARCHAR2,
   sender_type_          IN       VARCHAR2,
   sender_id_            IN       VARCHAR2)
IS  
BEGIN   
   IF(Use_Generic_Reservation(source_ref_type_db_)) THEN
      -- Handle objects whihc connected with semi centralized reservation (InventroyPartReservation).
      Reserve___(reserve_ship_tab_, shipment_id_, source_ref_type_db_, sender_type_, sender_id_);
   ELSE
      -- Hanlde customer order or other source which has seperate reservation objects.
      Shipment_Source_Utility_API.Reserve_Shipment(reserve_ship_tab_, shipment_id_, source_ref_type_db_);
   END IF;
END Reserve;


@UncheckedAccess
FUNCTION Reserve_Line_Allowed (
   shipment_id_            IN NUMBER,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2,
   source_ref_type_db_     IN VARCHAR2 ) RETURN NUMBER
IS     
   allowed_                NUMBER := 0;       
BEGIN    
   IF(Use_Generic_Reservation(source_ref_type_db_)) THEN    
      -- Semi centralized reservation
      IF(Shipment_Line_API.Get_Qty_To_Reserve(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_) > 0) THEN
         allowed_ := 1;
      END IF;
   ELSE
      -- Other reservation like customer order
      allowed_:= Shipment_Source_Utility_API.Reserve_Shipment_Line_Allowed(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   END IF;    
   RETURN allowed_;
END Reserve_Line_Allowed;


-- Reserve_Manually
-- This will handle to call the correct source in order to do manual reservation.
PROCEDURE Reserve_Manually (
   info_                   OUT VARCHAR2,  
   shipment_id_            IN  NUMBER,
   source_ref1_            IN  VARCHAR2,
   source_ref2_            IN  VARCHAR2,
   source_ref3_            IN  VARCHAR2,
   source_ref4_            IN  VARCHAR2,
   source_ref_type_db_     IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   inventory_part_no_      IN  VARCHAR2,
   configuration_id_       IN  VARCHAR2,
   location_no_            IN  VARCHAR2,
   lot_batch_no_           IN  VARCHAR2,
   serial_no_              IN  VARCHAR2,
   eng_chg_level_          IN  VARCHAR2,
   waiv_dev_rej_no_        IN  VARCHAR2,
   activity_seq_           IN  NUMBER,
   handling_unit_id_       IN  NUMBER,
   qty_to_reserve_         IN  NUMBER,
   input_qty_              IN  NUMBER,
   input_unit_meas_        IN  VARCHAR2,
   input_conv_factor_      IN  NUMBER,
   input_variable_values_  IN  VARCHAR2,  
   part_ownership_         IN  VARCHAR2,  
   owner_                  IN  VARCHAR2,  
   condition_code_         IN  VARCHAR2,
   sender_type_            IN  VARCHAR2,
   sender_id_              IN  VARCHAR2,
   source_ref_demand_code_ IN  VARCHAR2,
   pick_by_choice_blocked_ IN  VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS       
BEGIN
   IF (Use_Generic_Reservation(source_ref_type_db_)) THEN
      -- Handle objects which connected with semi centralized reservation (InventroyPartReservation).
      Reserve_Manually___(info_,   
                          shipment_id_,
                          source_ref1_, 
                          source_ref2_, 
                          source_ref3_, 
                          source_ref4_,
                          source_ref_type_db_,
                          contract_,
                          inventory_part_no_, 
                          configuration_id_,
                          location_no_,
                          lot_batch_no_,
                          serial_no_, 
                          eng_chg_level_, 
                          waiv_dev_rej_no_,
                          activity_seq_,
                          handling_unit_id_,
                          qty_to_reserve_,
                          sender_type_,
                          sender_id_,
                          source_ref_demand_code_,
                          pick_by_choice_blocked_);
   ELSE
      -- Handle customer order or other source which has seperate reservation objects.
      Shipment_Source_Utility_API.Reserve_Manually(info_,
                                                   source_ref1_,
                                                   source_ref2_,
                                                   source_ref3_,
                                                   source_ref4_,
                                                   contract_,
                                                   inventory_part_no_, 
                                                   configuration_id_,
                                                   location_no_,
                                                   lot_batch_no_,
                                                   serial_no_, 
                                                   eng_chg_level_, 
                                                   waiv_dev_rej_no_,
                                                   activity_seq_,
                                                   handling_unit_id_,
                                                   qty_to_reserve_,
                                                   input_qty_,
                                                   input_unit_meas_,
                                                   input_conv_factor_,
                                                   input_variable_values_,
                                                   shipment_id_,
                                                   part_ownership_, 
                                                   owner_,
                                                   condition_code_,
                                                   source_ref_type_db_,
                                                   pick_by_choice_blocked_);  
   END IF;
END Reserve_Manually;


PROCEDURE Reserve_As_Picked (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,  
   source_ref_type_db_        IN VARCHAR2,
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   handling_unit_id_          IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   qty_to_reserve_            IN NUMBER,
   catch_qty_to_reserve_      IN NUMBER,
   reassignment_type_         IN VARCHAR2 DEFAULT NULL,
   move_to_ship_location_     IN VARCHAR2 DEFAULT 'FALSE',
   source_ref_demand_code_    IN VARCHAR2 DEFAULT NULL)
IS
   public_reservation_rec_    Public_Reservation_Rec;
   catch_quantity_            NUMBER;
BEGIN
   IF (Use_Generic_Reservation(source_ref_type_db_)) THEN
      Inventory_Part_Reservation_API.Reserve_And_Report_As_Picked(contract_             => contract_,       
                                                                  part_no_              => part_no_,
                                                                  configuration_id_     => configuration_id_,
                                                                  location_no_          => location_no_,
                                                                  lot_batch_no_         => lot_batch_no_,
                                                                  serial_no_            => serial_no_,
                                                                  eng_chg_level_        => eng_chg_level_,
                                                                  waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                                  activity_seq_         => activity_seq_,
                                                                  handling_unit_id_     => handling_unit_id_,
                                                                  pick_list_no_         => pick_list_no_,
                                                                  qty_picked_           => qty_to_reserve_,  
                                                                  catch_qty_picked_     => catch_qty_to_reserve_,
                                                                  source_ref_type_db_   => source_ref_type_db_,
                                                                  source_ref1_          => source_ref1_, 
                                                                  source_ref2_          => source_ref2_,
                                                                  source_ref3_          => source_ref3_,
                                                                  source_ref4_          => source_ref4_,
                                                                  shipment_id_          => shipment_id_,
                                                                  string_parameter1_    => reassignment_type_,
                                                                  string_parameter2_    => move_to_ship_location_,
                                                                  reserve_in_inventory_ => TRUE,
                                                                  source_ref_demand_code_ => source_ref_demand_code_);
   ELSE
      Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_   => catch_quantity_, 
                                               contract_         => contract_, 
                                               part_no_          => part_no_, 
                                               configuration_id_ => configuration_id_,
                                               location_no_      => location_no_, 
                                               lot_batch_no_     => lot_batch_no_, 
                                               serial_no_        => serial_no_, 
                                               eng_chg_level_    => eng_chg_level_,
                                               waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                               activity_seq_     => activity_seq_, 
                                               handling_unit_id_ => handling_unit_id_,
                                               quantity_         => qty_to_reserve_);   

      IF (Shipment_Source_Utility_API.Reservation_Exists(source_ref1_         => source_ref1_, 
                                                         source_ref2_         => source_ref2_, 
                                                         source_ref3_         => source_ref3_, 
                                                         source_ref4_         => source_ref4_, 
                                                         source_ref_type_db_  => source_ref_type_db_,
                                                         contract_            => contract_, 
                                                         part_no_             => part_no_, 
                                                         location_no_         => location_no_,
                                                         lot_batch_no_        => lot_batch_no_, 
                                                         serial_no_           => serial_no_, 
                                                         eng_chg_level_       => eng_chg_level_, 
                                                         waiv_dev_rej_no_     => waiv_dev_rej_no_, 
                                                         activity_seq_        => activity_seq_, 
                                                         handling_unit_id_    => handling_unit_id_,  
                                                         configuration_id_    => configuration_id_, 
                                                         pick_list_no_        => pick_list_no_, 
                                                         shipment_id_         => shipment_id_) = 'TRUE') THEN
         public_reservation_rec_ := Shipment_Source_Utility_API.Lock_And_Fetch_Reserve_Info(source_ref1_            => source_ref1_, 
                                                                                            source_ref2_            => source_ref2_, 
                                                                                            source_ref3_            => source_ref3_,
                                                                                            source_ref4_            => source_ref4_, 
                                                                                            source_ref_type_db_     => source_ref_type_db_,
                                                                                            contract_               => contract_, 
                                                                                            part_no_                => part_no_, 
                                                                                            location_no_            => location_no_, 
                                                                                            lot_batch_no_           => lot_batch_no_, 
                                                                                            serial_no_              => serial_no_,
                                                                                            eng_chg_level_          => eng_chg_level_, 
                                                                                            waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                                                            activity_seq_           => activity_seq_, 
                                                                                            handling_unit_id_       => handling_unit_id_,
                                                                                            pick_list_no_           => pick_list_no_, 
                                                                                            configuration_id_       => configuration_id_, 
                                                                                            shipment_id_            => shipment_id_);

         IF ((public_reservation_rec_.qty_assigned + qty_to_reserve_) = 0) THEN
             Shipment_Source_Utility_API.Remove_Reservation(source_ref1_           => source_ref1_, 
                                                            source_ref2_           => source_ref2_, 
                                                            source_ref3_           => source_ref3_, 
                                                            source_ref4_           => source_ref4_,
                                                            source_ref_type_db_    => source_ref_type_db_,
                                                            contract_              => contract_, 
                                                            part_no_               => part_no_, 
                                                            location_no_           => location_no_, 
                                                            lot_batch_no_          => lot_batch_no_, 
                                                            serial_no_             => serial_no_,
                                                            eng_chg_level_         => eng_chg_level_, 
                                                            waiv_dev_rej_no_       => waiv_dev_rej_no_, 
                                                            activity_seq_          => activity_seq_, 
                                                            handling_unit_id_      => handling_unit_id_,
                                                            pick_list_no_          => pick_list_no_, 
                                                            configuration_id_      => configuration_id_, 
                                                            shipment_id_           => shipment_id_,
                                                            reassignment_type_     => reassignment_type_,
                                                            move_to_ship_location_ => move_to_ship_location_);
         ELSE
            Shipment_Source_Utility_API.Modify_Reservation_Qty_Picked(source_ref1_              => source_ref1_,        
                                                                      source_ref2_              => source_ref2_,          
                                                                      source_ref3_              => source_ref3_,             
                                                                      source_ref4_              => source_ref4_,
                                                                      source_ref_type_db_       => source_ref_type_db_,
                                                                      contract_                 => contract_,        
                                                                      part_no_                  => part_no_,          
                                                                      location_no_              => location_no_,        
                                                                      lot_batch_no_             => lot_batch_no_,
                                                                      serial_no_                => serial_no_,       
                                                                      eng_chg_level_            => eng_chg_level_,    
                                                                      waiv_dev_rej_no_          => waiv_dev_rej_no_,    
                                                                      activity_seq_             => activity_seq_,
                                                                      handling_unit_id_         => handling_unit_id_,
                                                                      pick_list_no_             => pick_list_no_,     
                                                                      configuration_id_         => configuration_id_,   
                                                                      shipment_id_              => shipment_id_,
                                                                      remaining_qty_assigned_   => public_reservation_rec_.qty_assigned + qty_to_reserve_,
                                                                      qty_picked_               => public_reservation_rec_.qty_picked + qty_to_reserve_,
                                                                      catch_qty_                => public_reservation_rec_.catch_qty + catch_qty_to_reserve_,
                                                                      input_qty_                => public_reservation_rec_.input_qty, 
                                                                      input_unit_meas_          => public_reservation_rec_.input_unit_meas,
                                                                      input_conv_factor_        => public_reservation_rec_.input_conv_factor,       
                                                                      input_variable_values_    => public_reservation_rec_.input_variable_values,
                                                                      move_to_ship_location_    => move_to_ship_location_);
         END IF;
      ELSE
         Shipment_Source_Utility_API.New_Reservation(source_ref1_              => source_ref1_, 
                                                     source_ref2_              => source_ref2_,
                                                     source_ref3_              => source_ref3_,
                                                     source_ref4_              => source_ref4_,
                                                     source_ref_type_db_       => source_ref_type_db_,
                                                     contract_                 => contract_, 
                                                     part_no_                  => part_no_, 
                                                     location_no_              => location_no_, 
                                                     lot_batch_no_             => lot_batch_no_,
                                                     serial_no_                => serial_no_,
                                                     eng_chg_level_            => eng_chg_level_, 
                                                     waiv_dev_rej_no_          => waiv_dev_rej_no_, 
                                                     activity_seq_             => activity_seq_,     
                                                     handling_unit_id_         => handling_unit_id_,
                                                     pick_list_no_             => pick_list_no_,       
                                                     preliminary_pick_list_no_ => NULL,
                                                     configuration_id_         => configuration_id_, 
                                                     new_shipment_id_          => shipment_id_,
                                                     qty_assigned_             => qty_to_reserve_, 
                                                     qty_picked_               => qty_to_reserve_, 
                                                     catch_qty_                => catch_qty_to_reserve_,
                                                     qty_shipped_              => 0,
                                                     input_qty_                => NULL,                           
                                                     input_unit_meas_          => NULL,
                                                     input_conv_factor_        => NULL, 
                                                     input_variable_values_    => NULL, 
                                                     reassignment_type_        => reassignment_type_,
                                                     move_to_ship_location_    => move_to_ship_location_);
      END IF;
   END IF;
END Reserve_As_Picked;


PROCEDURE Move_Shipment_Reservation (
   source_ref1_            IN  VARCHAR2,
   source_ref2_            IN  VARCHAR2,
   source_ref3_            IN  VARCHAR2,
   source_ref4_            IN  VARCHAR2,
   source_ref_type_db_     IN  VARCHAR2, 
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   location_no_            IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   eng_chg_level_          IN VARCHAR2,
   waiv_dev_rej_no_        IN VARCHAR2,
   activity_seq_           IN NUMBER,
   handling_unit_id_       IN NUMBER,
   pick_list_no_           IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   shipment_id_            IN NUMBER,
   new_shipment_id_        IN NUMBER,
   qty_to_reassign_        IN NUMBER,
   catch_qty_to_reassign_  IN NUMBER,  
   reassignment_type_      IN VARCHAR2 )
IS
   remaining_qty_assigned_      NUMBER := 0;
   remaining_qty_picked_        NUMBER := 0;
   modify_source_shipment_qty_  BOOLEAN := FALSE;
   picked_qty_to_transfer_      NUMBER := 0;
   remaining_catch_qty_         NUMBER := 0;  
   to_shipment_qty_assigned_    NUMBER := 0;
   to_shipment_qty_picked_      NUMBER := 0;
   to_shipment_catch_qty_       NUMBER := 0;
   public_reservation_rec_      Public_Reservation_Rec;
   from_qty_reserved_           NUMBER := 0;
   from_qty_picked_             NUMBER := 0;
   from_catch_qty_              NUMBER := 0;
   reservation_booked_for_transp_  BOOLEAN;

BEGIN
    Get_Quantity(from_qty_reserved_, from_qty_picked_, from_catch_qty_, source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                 source_ref_type_db_, contract_, part_no_,
                 location_no_, lot_batch_no_, serial_no_,
                 eng_chg_level_, waiv_dev_rej_no_, activity_seq_,
                 handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_);   
         
   IF (reassignment_type_ IS NOT NULL) THEN
      Reassign_Shipment_Utility_API.Validate_Reassign_Reserve(qty_to_reassign_           => qty_to_reassign_,
                                                              catch_qty_to_reassign_     => catch_qty_to_reassign_,
                                                              reassignment_type_         => reassignment_type_,
                                                              qty_assigned_              => from_qty_reserved_, 
                                                              pick_list_no_              => pick_list_no_, 
                                                              qty_picked_                => from_qty_picked_, 
                                                              catch_qty_                 => from_catch_qty_, 
                                                              new_shipment_id_           => new_shipment_id_, 
                                                              source_ref_type_db_        => source_ref_type_db_ );                                                               
   END IF;   
   remaining_qty_assigned_ := from_qty_reserved_ - qty_to_reassign_;
   IF (from_qty_picked_ > 0) THEN
      picked_qty_to_transfer_ := qty_to_reassign_;  
      remaining_qty_picked_   := from_qty_picked_ - picked_qty_to_transfer_;
   END IF;
   IF (NVL(catch_qty_to_reassign_, 0) > 0) THEN
      remaining_catch_qty_    := from_catch_qty_ - catch_qty_to_reassign_;
   END IF;  
   
   IF(Use_Generic_Reservation(source_ref_type_db_)) THEN
      Inventory_Part_Reservation_API.Modify_Shipment_Id(contract_            => contract_,
                                                        part_no_             => part_no_,
                                                        configuration_id_    => configuration_id_, 
                                                        location_no_         => location_no_,
                                                        lot_batch_no_        => lot_batch_no_, 
                                                        serial_no_           => serial_no_,
                                                        eng_chg_level_       => eng_chg_level_, 
                                                        waiv_dev_rej_no_     => waiv_dev_rej_no_, 
                                                        activity_seq_        => activity_seq_, 
                                                        handling_unit_id_    => handling_unit_id_,                                                        
                                                        new_shipment_id_     => new_shipment_id_,
                                                        qty_reserved_        => qty_to_reassign_,
                                                        qty_picked_          => picked_qty_to_transfer_,
                                                        catch_qty_picked_    => NVL(catch_qty_to_reassign_, 0),
                                                        source_ref_type_db_  => Get_Inv_Res_Source_Type_Db(source_ref_type_db_),
                                                        source_ref1_         => source_ref1_, 
                                                        source_ref2_         => NVL(source_ref2_,'*'), 
                                                        source_ref3_         => NVL(source_ref3_,'*'),
                                                        source_ref4_         => NVL(source_ref4_,'*'),                                                       
                                                        pick_list_no_        => Convert_Pick_List_No_To_Num(pick_list_no_),
                                                        old_shipment_id_     => shipment_id_,
                                                        string_parameter1_   => reassignment_type_,
                                                        string_parameter2_   => Fnd_Boolean_API.DB_FALSE);
   ELSE       
      IF (Shipment_Source_Utility_API.Reservation_Exists(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_,
                                                         contract_, part_no_, location_no_,
                                                         lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, 
                                                         activity_seq_, handling_unit_id_,  configuration_id_, pick_list_no_, new_shipment_id_) = 'TRUE') THEN
      
         public_reservation_rec_ := NULL;

         public_reservation_rec_ := Shipment_Source_Utility_API.Lock_And_Fetch_Reserve_Info(source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                                                                            source_ref_type_db_, contract_, part_no_,
                                                                                            location_no_, lot_batch_no_, serial_no_,
                                                                                            eng_chg_level_, waiv_dev_rej_no_, activity_seq_,
                                                                                            handling_unit_id_, pick_list_no_, configuration_id_, new_shipment_id_); 

         
         to_shipment_qty_assigned_ := public_reservation_rec_.qty_assigned;
         to_shipment_qty_picked_   := public_reservation_rec_.qty_picked;
         to_shipment_catch_qty_    := public_reservation_rec_.catch_qty;

         -- reservation record for the destination shipment id exists, add the transferred qty to qty assigned
         Shipment_Source_Utility_API.Update_Reserve_On_Reassign(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_,
                                                                contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                                                                eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                                                                pick_list_no_, configuration_id_, new_shipment_id_,   
                                                                (to_shipment_qty_assigned_ + qty_to_reassign_        ), 
                                                                (to_shipment_qty_picked_   + picked_qty_to_transfer_ ),
                                                                (to_shipment_catch_qty_    + catch_qty_to_reassign_  ),
                                                                 reassignment_type_); 

         modify_source_shipment_qty_ := TRUE;
      ELSE
         IF remaining_qty_assigned_ = 0 THEN
            $IF Component_Order_SYS.INSTALLED $THEN
               -- reservation record for the destination shipment id does not exists, qty assigned on source shipment id will be 0 after the qty transfer 
               Customer_Order_Reservation_API.Move_To_Shipment(source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                                               contract_, part_no_, location_no_, lot_batch_no_, 
                                                               serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                                                               configuration_id_, pick_list_no_, shipment_id_,
                                                               new_shipment_id_, reassignment_type_);
            $ELSE
               NULL;
            $END                                                   
         ELSE
            -- reservation record for the destination shipment id does not exists
            Shipment_Source_Utility_API.New_Reservation(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_,
                                                        contract_,  part_no_, location_no_, lot_batch_no_,
                                                        serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, 
                                                        pick_list_no_, NULL, configuration_id_, new_shipment_id_, qty_to_reassign_,
                                                        picked_qty_to_transfer_, catch_qty_to_reassign_, 0,
                                                        NULL, NULL, NULL, NULL, reassignment_type_);
                                                        
            Transport_Task_API.New_Trans_Task_For_Changed_Res(reservation_booked_for_transp_ => reservation_booked_for_transp_,
                                                              part_no_            => part_no_,
                                                              configuration_id_   => configuration_id_,
                                                              from_contract_      => contract_,
                                                              from_location_no_   => location_no_,   
                                                              order_type_db_      => Order_Type_API.DB_CUSTOMER_ORDER,
                                                              order_ref1_         => source_ref1_,
                                                              order_ref2_         => source_ref2_,
                                                              order_ref3_         => source_ref3_,
                                                              order_ref4_         => source_ref4_,
                                                              from_pick_list_no_  => pick_list_no_,
                                                              to_pick_list_no_    => pick_list_no_,
                                                              from_shipment_id_   => shipment_id_,
                                                              to_shipment_id_     => new_shipment_id_,   
                                                              lot_batch_no_       => lot_batch_no_,
                                                              serial_no_          => serial_no_,
                                                              eng_chg_level_      => eng_chg_level_,
                                                              waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                              activity_seq_       => activity_seq_,
                                                              handling_unit_id_   => handling_unit_id_,
                                                              quantity_           => qty_to_reassign_);                                                       
            modify_source_shipment_qty_ := TRUE;
         END IF;
      END IF;

      IF modify_source_shipment_qty_ THEN
         -- Remove the source record
         IF (remaining_qty_assigned_ = 0) THEN       
            Shipment_Source_Utility_API.Remove_Reservation(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, 
                                                           contract_, part_no_, location_no_, lot_batch_no_,
                                                           serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                                                           pick_list_no_, configuration_id_, shipment_id_, reassignment_type_, 'FALSE');       

         ELSE
            IF (from_qty_reserved_ > 0) THEN
               -- Reduce the qty on source record
               Shipment_Source_Utility_API.Update_Reserve_On_Reassign(source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                                                      source_ref_type_db_, contract_, part_no_,
                                                                      location_no_, lot_batch_no_, serial_no_,
                                                                      eng_chg_level_, waiv_dev_rej_no_, activity_seq_,
                                                                      handling_unit_id_, pick_list_no_, configuration_id_,
                                                                      shipment_id_, remaining_qty_assigned_, remaining_qty_picked_,
                                                                      remaining_catch_qty_, reassignment_type_     ); 
            END IF;
         END IF;
      END IF;
   END IF;
END Move_Shipment_Reservation;


PROCEDURE Get_Quantity(
   qty_reserved_          OUT NUMBER,
   qty_picked_            OUT NUMBER,
   catch_qty_picked_      OUT NUMBER,
   source_ref1_           IN  VARCHAR2,
   source_ref2_           IN  VARCHAR2,
   source_ref3_           IN  VARCHAR2,
   source_ref4_           IN  VARCHAR2,
   source_ref_type_db_    IN  VARCHAR2, 
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   location_no_           IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   eng_chg_level_         IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   activity_seq_          IN NUMBER,
   handling_unit_id_      IN NUMBER,  
   configuration_id_      IN VARCHAR2,
   pick_list_no_          IN VARCHAR2,
   shipment_id_           IN NUMBER)
IS
   inv_part_res_rec_            Inventory_Part_Reservation_API.Public_Rec;
   public_reservation_rec_      Public_Reservation_Rec;
BEGIN
   IF(Use_Generic_Reservation(source_ref_type_db_)) THEN
      inv_part_res_rec_    := Inventory_Part_Reservation_API.Get(contract_,
                                                                 part_no_, 
                                                                 configuration_id_, 
                                                                 location_no_, 
                                                                 lot_batch_no_, 
                                                                 serial_no_, 
                                                                 eng_chg_level_, 
                                                                 waiv_dev_rej_no_, 
                                                                 activity_seq_, 
                                                                 handling_unit_id_, 
                                                                 source_ref1_, 
                                                                 NVL(source_ref2_, '*'), 
                                                                 NVL(source_ref3_, '*'),
                                                                 NVL(source_ref4_, '*'),
                                                                 Get_Inv_Res_Source_Type_Db(source_ref_type_db_), 
                                                                 Convert_Pick_List_No_To_Num(pick_list_no_), 
                                                                 shipment_id_);
      qty_reserved_        := inv_part_res_rec_.qty_reserved;
      qty_picked_          := inv_part_res_rec_.qty_picked;
      catch_qty_picked_    := inv_part_res_rec_.catch_qty_picked;
   ELSE
      public_reservation_rec_ := Shipment_Source_Utility_API.Lock_And_Fetch_Reserve_Info(source_ref1_, 
                                                                                         source_ref2_, 
                                                                                         source_ref3_, 
                                                                                         source_ref4_,
                                                                                         source_ref_type_db_, 
                                                                                         contract_, 
                                                                                         part_no_,
                                                                                         location_no_, 
                                                                                         lot_batch_no_, 
                                                                                         serial_no_,
                                                                                         eng_chg_level_, 
                                                                                         waiv_dev_rej_no_, 
                                                                                         activity_seq_,
                                                                                         handling_unit_id_, 
                                                                                         pick_list_no_, 
                                                                                         configuration_id_, 
                                                                                         shipment_id_);
      qty_reserved_        := public_reservation_rec_.qty_assigned;
      qty_picked_          := public_reservation_rec_.qty_picked;
      catch_qty_picked_    := public_reservation_rec_.catch_qty;
   END IF;     
END Get_Quantity;


@UncheckedAccess
FUNCTION Get_Total_Qty_Reserved (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   shipment_id_         IN NUMBER) RETURN NUMBER
IS
   total_qty_reserved_ NUMBER := 0;
   CURSOR get_total_qty_reserved IS
      SELECT NVL(SUM(qty_assigned), 0)
      FROM   shipment_source_reservation 
      WHERE  source_ref1         = source_ref1_
      AND    source_ref2         = NVL(source_ref2_,'*')
      AND    source_ref3         = NVL(source_ref3_,'*')
      AND    source_ref4         = NVL(source_ref4_,'*')
      AND    source_ref_type_db  = source_ref_type_db_
      AND    shipment_id         = shipment_id_;
BEGIN
   OPEN  get_total_qty_reserved;
   FETCH get_total_qty_reserved INTO total_qty_reserved_;
   CLOSE get_total_qty_reserved;
   RETURN total_qty_reserved_;   
END Get_Total_Qty_Reserved;  

-- This method is only used for manual reservation window and added for performance reasons.
-- Method return null instead of zero because it is bind to reserved quantity column.
-- Needed to avoid to_char conversion considering performance.
@UncheckedAccess
FUNCTION Get_Total_Qty_Reserved (  
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   contract_           IN VARCHAR2,
   inventory_part_no_  IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN VARCHAR2,
   handling_unit_id_   IN NUMBER,
   shipment_id_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN NUMBER
IS
   total_qty_reserved_ NUMBER := 0;
BEGIN
   IF(Use_Generic_Reservation(source_ref_type_db_)) THEN
      total_qty_reserved_ := Inventory_Part_Reservation_API.Get_Total_Qty_Reserved (contract_           => contract_,
                                                                                    part_no_            => inventory_part_no_,
                                                                                    configuration_id_   => configuration_id_,
                                                                                    location_no_        => location_no_,
                                                                                    lot_batch_no_       => lot_batch_no_,
                                                                                    serial_no_          => serial_no_,
                                                                                    eng_chg_level_      => eng_chg_level_,
                                                                                    waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                                    activity_seq_       => activity_seq_ ,
                                                                                    handling_unit_id_   => handling_unit_id_,
                                                                                    source_ref_type_db_ => Get_Inv_Res_Source_Type_Db(source_ref_type_db_),
                                                                                    source_ref1_        => source_ref1_,
                                                                                    source_ref2_        => NVL(source_ref2_, '*'),
                                                                                    source_ref3_        => NVL(source_ref3_, '*'),
                                                                                    source_ref4_        => NVL(source_ref4_, '*'),
                                                                                    shipment_id_        => shipment_id_); 
   ELSE
      total_qty_reserved_ := Shipment_Source_Utility_API.Get_Total_Qty_Reserved (source_ref1_        => source_ref1_,
                                                                                 source_ref2_        => source_ref2_,
                                                                                 source_ref3_        => source_ref3_,
                                                                                 source_ref4_        => source_ref4_,
                                                                                 source_ref_type_db_ => source_ref_type_db_, 
                                                                                 contract_           => contract_,
                                                                                 part_no_            => inventory_part_no_,
                                                                                 configuration_id_   => configuration_id_,
                                                                                 location_no_        => location_no_,
                                                                                 lot_batch_no_       => lot_batch_no_,
                                                                                 serial_no_          => serial_no_,
                                                                                 eng_chg_level_      => eng_chg_level_,
                                                                                 waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                                 activity_seq_       => activity_seq_,
                                                                                 handling_unit_id_   => handling_unit_id_,
                                                                                 shipment_id_        => shipment_id_);
   END IF;
   
   total_qty_reserved_ := CASE total_qty_reserved_ WHEN 0 THEN NULL ELSE total_qty_reserved_ END;
   
   RETURN total_qty_reserved_;
END Get_Total_Qty_Reserved;


@UncheckedAccess
FUNCTION Get_Qty_Reserved (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   contract_           IN VARCHAR2,
   inventory_part_no_  IN VARCHAR2,   
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN VARCHAR2,
   handling_unit_id_   IN NUMBER,
   configuration_id_   IN VARCHAR2,
   pick_list_no_       IN VARCHAR2,
   shipment_id_        IN NUMBER,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS   
   qty_reserved_   NUMBER:=0;
   CURSOR get_qty_reserved IS
      SELECT NVL(qty_assigned,0)
      FROM   shipment_source_reservation 
      WHERE  source_ref1            = source_ref1_
      AND    source_ref2            = NVL(source_ref2_,'*')
      AND    source_ref3            = NVL(source_ref3_,'*')
      AND    source_ref4            = NVL(source_ref4_,'*')
      AND    source_ref_type_db     = source_ref_type_db_
      AND    contract               = contract_
      AND    part_no                = inventory_part_no_
      AND    configuration_id       = configuration_id_
      AND    location_no            = location_no_
      AND    lot_batch_no           = lot_batch_no_
      AND    serial_no              = serial_no_
      AND    eng_chg_level          = eng_chg_level_
      AND    waiv_dev_rej_no        = waiv_dev_rej_no_
      AND    activity_seq           = activity_seq_
      AND    handling_unit_id       = handling_unit_id_
      AND    pick_list_no           = pick_list_no_
      AND    shipment_id            = shipment_id_;
BEGIN
   OPEN get_qty_reserved;
   FETCH get_qty_reserved INTO qty_reserved_;
   CLOSE get_qty_reserved;
   RETURN qty_reserved_;
END Get_Qty_Reserved;


@UncheckedAccess
FUNCTION Get_Max_Ship_Qty_To_Reassign (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   shipment_id_         IN NUMBER,
   inventory_qty_       IN NUMBER ) RETURN NUMBER
IS  
BEGIN
   IF(Use_Generic_Reservation(source_ref_type_db_)) THEN
      RETURN (inventory_qty_ - Inventory_Part_Reservation_API.Get_Unpicked_Pick_Listed_Qty(Get_Inv_Res_Source_Type_Db(source_ref_type_db_), source_ref1_, NVL(source_ref2_,'*'), NVL(source_ref3_,'*'), NVL(source_ref4_,'*'), shipment_id_));
   ELSE
      RETURN Shipment_Source_Utility_API.Get_Max_Ship_Qty_To_Reassign(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, shipment_id_, inventory_qty_);
   END IF;   
END Get_Max_Ship_Qty_To_Reassign;


@UncheckedAccess
FUNCTION Get_Logistic_Source_Type_Db (
   inv_part_res_source_type_db_ IN  VARCHAR2) RETURN VARCHAR2
IS
   logistics_source_type_db_ VARCHAR2(50);
BEGIN
   logistics_source_type_db_ := CASE inv_part_res_source_type_db_
                                 WHEN Inv_Part_Res_Source_Type_API.DB_PROJECT_DELIVERABLES THEN 
                                    Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES 
                                 WHEN Inv_Part_Res_Source_Type_API.DB_SHIPMENT_ORDER THEN
                                    Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER
                                 WHEN Inv_Part_Res_Source_Type_API.DB_PURCH_RECEIPT_RETURN THEN
                                    Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN
                                 END;
   RETURN (logistics_source_type_db_);
END Get_Logistic_Source_Type_Db;


@UncheckedAccess
FUNCTION Get_Logistics_Source_Type_Db (
   order_supply_demand_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS
   logistics_source_type_db_ VARCHAR2(50);
BEGIN
   logistics_source_type_db_ := CASE order_supply_demand_type_db_
                                    WHEN Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES THEN 
                                       Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES 
                                    WHEN Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER THEN
                                       Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER
                                    WHEN Order_Supply_Demand_Type_API.DB_CUST_ORDER THEN
                                       Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
                                    WHEN Order_Supply_Demand_Type_API.DB_PURCH_RECEIPT_RETURN THEN                                       
                                       Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN                                       
                                 END;
   RETURN logistics_source_type_db_;
END Get_Logistics_Source_Type_Db;
                              

PROCEDURE Generate_Man_Res_Hu_Snapshot (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   shipment_id_         IN NUMBER,
   source_ref_type_db_  IN VARCHAR2,
   part_no_             IN VARCHAR2 DEFAULT NULL,
   contract_            IN VARCHAR2 DEFAULT NULL)
IS
    TYPE get_inv_part_stock IS REF CURSOR;
    get_inv_part_stock_ get_inv_part_stock;
    stmt_      VARCHAR2(2000);
   inv_part_stock_tab_  Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
   
BEGIN
   stmt_ := 'SELECT contract, part_no, configuration_id, location_no,
             lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
             activity_seq, handling_unit_id, qty_onhand
      FROM   single_manual_reservation
      WHERE  shipment_id   = :shipment_id_
      AND    source_ref_type_db = :source_ref_type_db_ ';
   IF (source_ref1_ IS NULL) THEN
      stmt_ := stmt_ || ' AND :source_ref1_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref1 = :source_ref1_';
   END IF;
   IF (source_ref2_ IS NULL) THEN
      stmt_ := stmt_ || ' AND :source_ref2_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref2 = :source_ref2_';
   END IF;
   IF (source_ref3_ IS NULL) THEN
      stmt_ := stmt_ || ' AND :source_ref3_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref3 = :source_ref3_';
   END IF;
   IF (source_ref4_ IS NULL) THEN
      stmt_ := stmt_ || ' AND :source_ref4_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref4 = :source_ref4_';
   END IF;
   IF (part_no_ IS NULL) THEN
      stmt_ := stmt_ || ' AND :part_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_no = :part_no_';
   END IF;
   IF (contract_ IS NULL) THEN
      stmt_ := stmt_ || ' AND :contract_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND contract = :contract_';
   END IF;
   
   @ApproveDynamicStatement(2020-03-02,KiSalk)
   OPEN get_inv_part_stock_ FOR stmt_ USING shipment_id_, source_ref_type_db_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, part_no_, contract_;
   FETCH get_inv_part_stock_ BULK COLLECT INTO inv_part_stock_tab_;
   CLOSE get_inv_part_stock_;

   Handl_Unit_Snapshot_Util_API.Generate_Snapshot(source_ref1_          => source_ref1_,
                                                  source_ref2_          => NVL(source_ref2_,'*'),
                                                  source_ref3_          => NVL(source_ref3_,'*'),
                                                  source_ref4_          => NVL(source_ref4_,'*'),
                                                  source_ref5_          => '*',
                                                  source_ref_type_db_   => Get_Hndl_Unt_Snpshot_Type_Db__(source_ref_type_db_),
                                                  inv_part_stock_tab_   => inv_part_stock_tab_);
                                                  
END Generate_Man_Res_Hu_Snapshot;


PROCEDURE Reservation_Exist(
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   pick_list_no_        IN VARCHAR2,
   shipment_id_         IN NUMBER )
IS   
BEGIN
   IF(Use_Generic_Reservation(source_ref_type_db_)) THEN
      Inventory_Part_Reservation_API.Exist_Db(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, source_ref1_, NVL(source_ref2_,'*'), NVL(source_ref3_,'*'), NVL(source_ref4_,'*'), Get_Inv_Res_Source_Type_Db(source_ref_type_db_), Convert_Pick_List_No_To_Num(pick_list_no_), shipment_id_);
   ELSE 
      Shipment_Source_Utility_API.Reservation_Exist(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_);         
   END IF;
END Reservation_Exist;


@UncheckedAccess
FUNCTION Use_Generic_Reservation(
   source_ref_type_db_  IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN (source_ref_type_db_ IN (Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES,
                                   Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER,
                                   Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN));   
END Use_Generic_Reservation;


@UncheckedAccess
FUNCTION Get_Inv_Res_Source_Type_Db (
   logistics_source_type_db_ IN  VARCHAR2) RETURN VARCHAR2
IS
   inv_part_res_source_type_db_ VARCHAR2(50);
BEGIN
   inv_part_res_source_type_db_ := CASE logistics_source_type_db_
                                 WHEN Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES THEN 
                                    Inv_Part_Res_Source_Type_API.DB_PROJECT_DELIVERABLES 
                                 WHEN Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER THEN
                                    Inv_Part_Res_Source_Type_API.DB_SHIPMENT_ORDER   
                                 WHEN Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN THEN
                                    Inv_Part_Res_Source_Type_API.DB_PURCH_RECEIPT_RETURN   
                                 END;
   RETURN (inv_part_res_source_type_db_);
END Get_Inv_Res_Source_Type_Db;                                                    
  
                                
@UncheckedAccess
FUNCTION Convert_Pick_List_No_To_Num (
    pick_list_no_    IN    VARCHAR2) RETURN NUMBER
IS
BEGIN
   IF(pick_list_no_ = '*') THEN
      RETURN 0;
   END IF;
   RETURN pick_list_no_;
END Convert_Pick_List_No_To_Num;
 

@UncheckedAccess
FUNCTION Get_Reserved_And_Picked_Qty (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   shipment_id_        IN NUMBER ) RETURN NUMBER
IS
   sum_reserve_to_reassign_   NUMBER;
   CURSOR get_qty_to_reserve IS
      SELECT SUM(DECODE(pick_list_no, '*', qty_assigned, qty_picked)) qty_assigned  
      FROM   shipment_source_reservation
      WHERE  source_ref1            = source_ref1_
      AND    source_ref2            = NVL(source_ref2_,'*')
      AND    source_ref3            = NVL(source_ref3_,'*')
      AND    source_ref4            = NVL(source_ref4_,'*')
      AND    source_ref_type_db     = source_ref_type_db_
      AND    shipment_id            = shipment_id_;
BEGIN
   OPEN  get_qty_to_reserve;
   FETCH get_qty_to_reserve INTO sum_reserve_to_reassign_; 
   CLOSE get_qty_to_reserve;
   RETURN NVL(sum_reserve_to_reassign_, 0);     
END Get_Reserved_And_Picked_Qty;  


@UncheckedAccess
FUNCTION Get_Total_Catch_Qty_Issued (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   shipment_id_         IN NUMBER) RETURN NUMBER
IS  
   catch_qty_issued_   NUMBER;
   CURSOR get_catch_qty_issued IS
      SELECT NVL(SUM(catch_qty_issued), SUM(catch_qty))  
      FROM   shipment_source_reservation
      WHERE  source_ref1            = source_ref1_
      AND    source_ref2            = NVL(source_ref2_,'*')
      AND    source_ref3            = NVL(source_ref3_,'*')
      AND    source_ref4            = NVL(source_ref4_,'*')
      AND    source_ref_type_db     = source_ref_type_db_
      AND    shipment_id            = shipment_id_;
BEGIN
   OPEN get_catch_qty_issued;
   FETCH get_catch_qty_issued INTO catch_qty_issued_;
   CLOSE get_catch_qty_issued;
   RETURN catch_qty_issued_;
END Get_Total_Catch_Qty_Issued;


@UncheckedAccess
FUNCTION Get_Number_Of_Lines_To_Pick (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   shipment_id_         IN NUMBER) RETURN NUMBER
IS  
   count_   NUMBER;
   CURSOR get_lines_to_pick IS
      SELECT count(*) 
      FROM   shipment_source_reservation
      WHERE  source_ref1            = source_ref1_
      AND    source_ref2            = NVL(source_ref2_,'*')
      AND    source_ref3            = NVL(source_ref3_,'*')
      AND    source_ref4            = NVL(source_ref4_,'*')
      AND    source_ref_type_db     = source_ref_type_db_
      AND    shipment_id            = shipment_id_
      AND    qty_assigned > qty_picked;
BEGIN
   OPEN get_lines_to_pick;
   FETCH get_lines_to_pick INTO count_;
   CLOSE get_lines_to_pick;   
   RETURN NVL(count_, 0);
END Get_Number_Of_Lines_To_Pick;


-- Transfer_Line_Reservations
--   This method is used to transfer reservation records from one shipment to another when
--   a shipment line with reservation is deleted, customer order line with reservations is
--   added the shipment or the sales qty is increased in shipment order line when reservations
--   exists for shipment id = 0 (customer order line).
PROCEDURE Transfer_Line_Reservations (
   source_ref1_                 IN VARCHAR2,
   source_ref2_                 IN VARCHAR2,
   source_ref3_                 IN VARCHAR2,
   source_ref4_                 IN VARCHAR2,
   source_ref_type_db_          IN VARCHAR2,
   from_shipment_id_            IN NUMBER,
   to_shipment_id_              IN NUMBER,
   qty_to_transfer_             IN NUMBER,
   transfer_on_add_remove_line_ IN BOOLEAN )
IS
   remaining_qty_to_transfer_        NUMBER := 0;
   qty_assigned_to_transfer_         NUMBER := 0;
   catch_qty_assign_to_transfer_     NUMBER := 0;
   
   CURSOR get_shipment_reservations IS
      SELECT contract, part_no, location_no, lot_batch_no, serial_no, eng_chg_level,
             waiv_dev_rej_no, activity_seq, handling_unit_id, pick_list_no, configuration_id, qty_assigned, qty_picked, catch_qty   
      FROM   shipment_source_reservation
      WHERE  source_ref1         = source_ref1_
      AND    source_ref2         = NVL(source_ref2_,'*')
      AND    source_ref3         = NVL(source_ref3_,'*')
      AND    source_ref4         = NVL(source_ref4_,'*')
      AND    source_ref_type_db  = source_ref_type_db_
      AND    shipment_id         = from_shipment_id_
      AND    qty_assigned > 0;
BEGIN
   IF (NOT transfer_on_add_remove_line_) THEN
      remaining_qty_to_transfer_ := qty_to_transfer_;
   END IF;
   FOR from_shipment_reservation_rec_ IN get_shipment_reservations LOOP 

      IF (transfer_on_add_remove_line_) THEN
         qty_assigned_to_transfer_     := from_shipment_reservation_rec_.qty_assigned;  
         catch_qty_assign_to_transfer_ := from_shipment_reservation_rec_.catch_qty; 
      ELSE
         IF (remaining_qty_to_transfer_ < from_shipment_reservation_rec_.qty_assigned) THEN
            qty_assigned_to_transfer_ := remaining_qty_to_transfer_;
         ELSE
            qty_assigned_to_transfer_ := from_shipment_reservation_rec_.qty_assigned;
         END IF;         
         remaining_qty_to_transfer_ := remaining_qty_to_transfer_ - qty_assigned_to_transfer_;
      END IF;

      Move_Shipment_Reservation(source_ref1_,
                                source_ref2_,
                                source_ref3_,
                                source_ref4_,
                                source_ref_type_db_,
                                from_shipment_reservation_rec_.contract,
                                from_shipment_reservation_rec_.part_no,
                                from_shipment_reservation_rec_.location_no,
                                from_shipment_reservation_rec_.lot_batch_no,
                                from_shipment_reservation_rec_.serial_no,
                                from_shipment_reservation_rec_.eng_chg_level,
                                from_shipment_reservation_rec_.waiv_dev_rej_no,
                                from_shipment_reservation_rec_.activity_seq,
                                from_shipment_reservation_rec_.handling_unit_id,
                                from_shipment_reservation_rec_.pick_list_no,
                                from_shipment_reservation_rec_.configuration_id,
                                from_shipment_id_,
                                to_shipment_id_,
                                qty_assigned_to_transfer_,
                                catch_qty_assign_to_transfer_,
                                NULL );

      EXIT WHEN ((NOT transfer_on_add_remove_line_) AND (remaining_qty_to_transfer_ = 0));
   END LOOP;
END Transfer_Line_Reservations;


FUNCTION Lock_And_Fetch_Reserve_Info (       
   source_ref1_            IN  VARCHAR2,
   source_ref2_            IN  VARCHAR2,
   source_ref3_            IN  VARCHAR2,
   source_ref4_            IN  VARCHAR2,
   source_ref_type_db_     IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   part_no_                IN  VARCHAR2,
   location_no_            IN  VARCHAR2,
   lot_batch_no_           IN  VARCHAR2,
   serial_no_              IN  VARCHAR2,
   eng_chg_level_          IN  VARCHAR2,
   waiv_dev_rej_no_        IN  VARCHAR2,
   activity_seq_           IN  NUMBER,
   handling_unit_id_       IN  NUMBER,
   pick_list_no_           IN  VARCHAR2,
   configuration_id_       IN  VARCHAR2,
   shipment_id_            IN  NUMBER ) RETURN Public_Reservation_Rec
IS  
   public_reservation_rec_ Public_Reservation_Rec;
   inv_part_res_rec_       Inventory_Part_Reservation_API.Public_Rec;
BEGIN
   IF(Use_Generic_Reservation(source_ref_type_db_)) THEN
      inv_part_res_rec_ := Inventory_Part_Reservation_API.Lock_By_Keys_And_Get(contract_            ,
                                                                               part_no_             ,
                                                                               configuration_id_    ,
                                                                               location_no_         ,
                                                                               lot_batch_no_        ,
                                                                               serial_no_           ,
                                                                               eng_chg_level_       ,
                                                                               waiv_dev_rej_no_     ,
                                                                               activity_seq_        ,
                                                                               handling_unit_id_    ,
                                                                               source_ref1_         ,
                                                                               NVL(source_ref2_, '*'),
                                                                               NVL(source_ref3_, '*'),
                                                                               NVL(source_ref4_, '*'),
                                                                               source_ref_type_db_   ,
                                                                               Reserve_Shipment_API.Convert_Pick_List_No_To_Num(pick_list_no_),
                                                                               shipment_id_          ); 
      public_reservation_rec_.qty_assigned := inv_part_res_rec_.qty_reserved; 
      public_reservation_rec_.qty_picked   := inv_part_res_rec_.qty_picked; 
      public_reservation_rec_.catch_qty    := inv_part_res_rec_.catch_qty_picked; 
   ELSE 
      public_reservation_rec_ := Shipment_Source_Utility_API.Lock_And_Fetch_Reserve_Info(source_ref1_            => source_ref1_, 
                                                                                         source_ref2_            => source_ref2_, 
                                                                                         source_ref3_            => source_ref3_,
                                                                                         source_ref4_            => source_ref4_, 
                                                                                         source_ref_type_db_     => source_ref_type_db_,
                                                                                         contract_               => contract_, 
                                                                                         part_no_                => part_no_, 
                                                                                         location_no_            => location_no_, 
                                                                                         lot_batch_no_           => lot_batch_no_, 
                                                                                         serial_no_              => serial_no_,
                                                                                         eng_chg_level_          => eng_chg_level_, 
                                                                                         waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                                                         activity_seq_           => activity_seq_, 
                                                                                         handling_unit_id_       => handling_unit_id_,
                                                                                         pick_list_no_           => pick_list_no_, 
                                                                                         configuration_id_       => configuration_id_, 
                                                                                         shipment_id_            => shipment_id_);
   END IF;
   RETURN public_reservation_rec_;
END Lock_And_Fetch_Reserve_Info;


@UncheckedAccess
FUNCTION Reservation_Exists (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2, 
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   location_no_        IN VARCHAR2,   
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN NUMBER,
   handling_unit_id_   IN NUMBER,
   configuration_id_   IN VARCHAR2,
   pick_list_no_       IN VARCHAR2,
   shipment_id_        IN NUMBER ) RETURN VARCHAR2
IS
   reservation_exist_   VARCHAR2(5):= 'FALSE';
BEGIN
   IF(Use_Generic_Reservation(source_ref_type_db_)) THEN
      IF (Inventory_Part_Reservation_API.Exists_Db(contract_           => contract_, 
                                                   part_no_            => part_no_, 
                                                   configuration_id_   => configuration_id_,
                                                   location_no_        => location_no_,
                                                   lot_batch_no_       => lot_batch_no_,
                                                   serial_no_          => serial_no_,
                                                   eng_chg_level_      => eng_chg_level_, 
                                                   waiv_dev_rej_no_    => waiv_dev_rej_no_, 
                                                   activity_seq_       => activity_seq_, 
                                                   handling_unit_id_   => handling_unit_id_,                               
                                                   source_ref1_        => source_ref1_, 
                                                   source_ref2_        => source_ref2_, 
                                                   source_ref3_        => source_ref3_, 
                                                   source_ref4_        => source_ref4_, 
                                                   source_ref_type_db_ => Get_Inv_Res_Source_Type_Db(source_ref_type_db_),                               
                                                   pick_list_no_       => Reserve_Shipment_API.Convert_Pick_List_No_To_Num(pick_list_no_), 
                                                   shipment_id_        => shipment_id_)) THEN
         reservation_exist_ := 'TRUE';                                                                  
      END IF;                                                                     
   ELSE
      reservation_exist_ := Shipment_Source_Utility_API.Reservation_Exists(source_ref1_            => source_ref1_, 
                                                                           source_ref2_            => source_ref2_, 
                                                                           source_ref3_            => source_ref3_, 
                                                                           source_ref4_            => source_ref4_, 
                                                                           source_ref_type_db_     => source_ref_type_db_, 
                                                                           contract_               => contract_, 
                                                                           part_no_                => part_no_, 
                                                                           location_no_            => location_no_, 
                                                                           lot_batch_no_           => lot_batch_no_, 
                                                                           serial_no_              => serial_no_, 
                                                                           eng_chg_level_          => eng_chg_level_, 
                                                                           waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                                           activity_seq_           => activity_seq_, 
                                                                           handling_unit_id_       => handling_unit_id_, 
                                                                           configuration_id_       => configuration_id_, 
                                                                           pick_list_no_           => pick_list_no_, 
                                                                           shipment_id_            => shipment_id_);
   END IF;   
   RETURN reservation_exist_;   
END Reservation_Exists;


@UncheckedAccess
FUNCTION Unreported_Pick_List_Exists (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_                         NUMBER;
   unreported_pick_lists_exist_   VARCHAR2(5) := 'FALSE';
   CURSOR chk_unreported_pick_list_exist IS
      SELECT 1
      FROM   SHIPMENT_SOURCE_RESERVATION
      WHERE  source_ref1        =  source_ref1_
      AND    source_ref2        =  NVL(source_ref2_,'*')
      AND    source_ref3        =  NVL(source_ref3_,'*')
      AND   (source_ref4 =  NVL(source_ref4_,'*') OR (source_ref4_ = '-1' AND source_ref4 > '0'))
      AND    source_ref_type_db = source_ref_type_db_
      AND    shipment_id        =  shipment_id_
      AND    pick_list_no       != '*'
      AND    (qty_assigned > qty_picked);
BEGIN
   OPEN  chk_unreported_pick_list_exist;
   FETCH chk_unreported_pick_list_exist INTO dummy_;
   IF (chk_unreported_pick_list_exist%FOUND) THEN
      unreported_pick_lists_exist_ := 'TRUE';
   END IF;
   CLOSE chk_unreported_pick_list_exist;
   RETURN unreported_pick_lists_exist_;
END Unreported_Pick_List_Exists;

PROCEDURE Move_Ship_Res_With_Trans_Task (
   message_ IN  VARCHAR2 )
IS
   description_ VARCHAR2(200);
BEGIN
   IF (Transaction_Sys.Is_Session_Deferred()) THEN
      -- if we are already inside a background job don't create a new one, which will happened if this was a scheduled job
      Move_With_Trans_Task__(message_);
   ELSE
      description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVE_SHIP_RES_IN_TT: Move Shipment Reservations with Transport Task');
      Transaction_SYS.Deferred_Call('RESERVE_SHIPMENT_API.Move_With_Trans_Task__', message_, description_);
   END IF;
END Move_Ship_Res_With_Trans_Task;


PROCEDURE Validate_Move_With_Trans_Task (
   message_ IN VARCHAR2 )
IS
   count_            NUMBER;
   name_arr_         Message_SYS.name_table;
   value_arr_        Message_SYS.line_table;
   contract_         VARCHAR2(5);
   to_location_      VARCHAR2(35);
   move_reserv_option_db_  VARCHAR2(20);
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'TO_LOCATION') THEN
         to_location_ := value_arr_(n_);
      END IF;
   END LOOP;

   IF (contract_ IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;
   -- refer Invent_Part_Quantity_Util_API.Validate_Move_Reservation
   move_reserv_option_db_ := Site_Invent_Info_API.Get_Move_Reservation_Option_Db(contract_);
   IF (move_reserv_option_db_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN
      Error_SYS.Record_General(lu_name_, 'MOVE_RES_NOT_ALLOW: It is not possible to move reserved stock.');
   END IF;
   IF (to_location_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'TO_LOCATION_NULL: To Location must be entered');
   END IF;
END Validate_Move_With_Trans_Task;


FUNCTION Get_Total_Qty_On_Pick_List(
   source_ref1_           IN  VARCHAR2,
   source_ref2_           IN  VARCHAR2,
   source_ref3_           IN  VARCHAR2,
   source_ref4_           IN  VARCHAR2,
   source_ref_type_db_    IN  VARCHAR2,
   shipment_id_           IN  NUMBER) RETURN NUMBER
IS
   qty_on_pick_list_ NUMBER := 0;
   CURSOR get_total_qty_on_pick_list IS
      SELECT NVL(SUM(qty_assigned), 0)
      FROM   shipment_source_reservation 
      WHERE  source_ref1         = source_ref1_
      AND    source_ref2         = NVL(source_ref2_,'*')
      AND    source_ref3         = NVL(source_ref3_,'*')
      AND    source_ref4         = NVL(source_ref4_,'*')
      AND    source_ref_type_db  = source_ref_type_db_
      AND    shipment_id         = NVL(shipment_id_, shipment_id)            
      AND    pick_list_no != '*'
      AND    qty_assigned > 0;
BEGIN
   OPEN get_total_qty_on_pick_list;
   FETCH get_total_qty_on_pick_list INTO qty_on_pick_list_;
   CLOSE get_total_qty_on_pick_list;
	RETURN qty_on_pick_list_;
END Get_Total_Qty_On_Pick_List;


@UncheckedAccess
FUNCTION Get_Total_Qty_On_Pick_List (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   contract_           IN VARCHAR2,
   inventory_part_no_  IN VARCHAR2,   
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN VARCHAR2,
   handling_unit_id_   IN NUMBER,
   configuration_id_   IN VARCHAR2,
   shipment_id_        IN NUMBER,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS   
   total_qty_on_pick_list_   NUMBER:=0;
BEGIN
   IF(Use_Generic_Reservation(source_ref_type_db_)) THEN
      total_qty_on_pick_list_ := Inventory_Part_Reservation_API.Get_Total_Qty_On_Pick_List (contract_           => contract_,
                                                                                            part_no_            => inventory_part_no_,
                                                                                            configuration_id_   => configuration_id_,
                                                                                            location_no_        => location_no_,
                                                                                            lot_batch_no_       => lot_batch_no_,
                                                                                            serial_no_          => serial_no_,
                                                                                            eng_chg_level_      => eng_chg_level_,
                                                                                            waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                                            activity_seq_       => activity_seq_ ,
                                                                                            handling_unit_id_   => handling_unit_id_, 
                                                                                            source_ref_type_db_ => Get_Inv_Res_Source_Type_Db(source_ref_type_db_),
                                                                                            source_ref1_        => source_ref1_,
                                                                                            source_ref2_        => NVL(source_ref2_, '*'),
                                                                                            source_ref3_        => NVL(source_ref3_, '*'),
                                                                                            source_ref4_        => NVL(source_ref4_, '*'),  
                                                                                            shipment_id_        => shipment_id_); 
   ELSE
      total_qty_on_pick_list_ := Shipment_Source_Utility_API.Get_Total_Qty_On_Pick_List (source_ref1_        => source_ref1_,
                                                                                         source_ref2_        => source_ref2_,
                                                                                         source_ref3_        => source_ref3_,
                                                                                         source_ref4_        => source_ref4_,
                                                                                         source_ref_type_db_ => source_ref_type_db_, 
                                                                                         contract_           => contract_,
                                                                                         part_no_            => inventory_part_no_,
                                                                                         configuration_id_   => configuration_id_,
                                                                                         location_no_        => location_no_,
                                                                                         lot_batch_no_       => lot_batch_no_,
                                                                                         serial_no_          => serial_no_,
                                                                                         eng_chg_level_      => eng_chg_level_,
                                                                                         waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                                         activity_seq_       => activity_seq_,
                                                                                         handling_unit_id_   => handling_unit_id_,
                                                                                         shipment_id_        => shipment_id_);
   END IF;
   RETURN total_qty_on_pick_list_;
END Get_Total_Qty_On_Pick_List;


PROCEDURE Move_Res_With_Trans_Task (
   contract_                       IN VARCHAR2, 
   move_reserve_tab_               Move_Reserve_Tab,
   to_location_no_                 IN VARCHAR2, 
   include_full_qty_of_top_hu_     IN VARCHAR2,
   exclude_hu_to_pick_in_one_step_ IN VARCHAR2 )
IS 
   move_reserv_option_db_       VARCHAR2(20);
   include_res_                 BOOLEAN := TRUE;
   root_handling_unit_id_       NUMBER;  
   un_executed_tt_line_exist_   BOOLEAN;
   hu_total_qty_on_hand_        NUMBER;
   hu_total_qty_reserved_       NUMBER;    

   TYPE Handling_Unit_Rec_      IS RECORD (handling_unit_id NUMBER);
   TYPE Handling_Unit_Tab_      IS TABLE OF Handling_Unit_Rec_ INDEX BY VARCHAR2(25);
   root_handling_unit_tab_      Handling_Unit_Tab_;

   index_                       BINARY_INTEGER := 0;
   move_res_allow_              BOOLEAN;
BEGIN
   move_reserv_option_db_ := Site_Invent_Info_API.Get_Move_Reservation_Option_Db(contract_);
   
   FOR i_ IN move_reserve_tab_.FIRST..move_reserve_tab_.LAST LOOP
      include_res_ := TRUE;
      IF (move_reserve_tab_(i_).pick_list_no != '*') THEN
         IF (move_reserv_option_db_ = Reservat_Adjustment_Option_API.DB_NOT_PICK_LISTED) THEN
            include_res_ := FALSE;
         ELSIF (move_reserv_option_db_ = Reservat_Adjustment_Option_API.DB_NOT_PRINTED_PICKLIST) THEN
            IF Use_Generic_Reservation(move_reserve_tab_(i_).source_ref_type_db) THEN
               IF (Inventory_Pick_List_API.Get_Printed_Db(move_reserve_tab_(i_).pick_list_no) = db_true_) THEN
                  include_res_ := FALSE;
               END IF;
            ELSE   
               $IF Component_Order_SYS.INSTALLED $THEN
                  IF (Customer_Order_Pick_List_API.Get_Printed_Flag_Db(move_reserve_tab_(i_).pick_list_no) = 'Y') THEN
                     include_res_ := FALSE;
                  END IF;
               $ELSE
                  NULL;
               $END
            END IF;   
         END IF;
      END IF;
      IF (Transport_Task_Line_API.Reservation_Booked_For_Transp(contract_,
                                                                move_reserve_tab_(i_).from_location_no,
                                                                move_reserve_tab_(i_).part_no,
                                                                move_reserve_tab_(i_).configuration_id,
                                                                move_reserve_tab_(i_).lot_batch_no,
                                                                move_reserve_tab_(i_).serial_no,
                                                                move_reserve_tab_(i_).eng_chg_level,
                                                                move_reserve_tab_(i_).waiv_dev_rej_no,
                                                                move_reserve_tab_(i_).activity_seq,
                                                                move_reserve_tab_(i_).handling_unit_id,
                                                                move_reserve_tab_(i_).source_ref1,
                                                                move_reserve_tab_(i_).source_ref2,
                                                                CASE move_reserve_tab_(i_).source_ref3 WHEN '*' THEN NULL ELSE move_reserve_tab_(i_).source_ref3 END,
                                                                TO_NUMBER(CASE move_reserve_tab_(i_).source_ref4 WHEN '*' THEN NULL ELSE move_reserve_tab_(i_).source_ref4 END),
                                                                move_reserve_tab_(i_).pick_list_no,
                                                                move_reserve_tab_(i_).shipment_id,
                                                                Order_Supply_Demand_Type_API.Get_Order_Type_Db(Get_Order_Sup_Demand_Type_Db__(move_reserve_tab_(i_).source_ref_type_db)))) THEN
         include_res_ := FALSE;                                                       
      END IF;
      IF (move_reserve_tab_(i_).from_location_no = to_location_no_) THEN
         include_res_ := FALSE;
      END IF;
      IF (move_reserve_tab_(i_).handling_unit_id != 0 AND (include_full_qty_of_top_hu_ = 'Y' OR exclude_hu_to_pick_in_one_step_ = 'Y')) THEN
         root_handling_unit_id_ := Handling_Unit_API.Get_Root_Handling_Unit_Id(move_reserve_tab_(i_).handling_unit_id);
         IF (root_handling_unit_tab_.COUNT > 0) THEN
            IF (root_handling_unit_tab_.EXISTS(root_handling_unit_id_)) THEN
               -- the top handling unit has been previously considered. Hence no need to consider it again.
               include_res_ := FALSE;
            ELSE
               index_ := index_ + 1;
               root_handling_unit_tab_(index_).handling_unit_id := root_handling_unit_id_;
            END IF;
         ELSE
            root_handling_unit_tab_(index_).handling_unit_id := root_handling_unit_id_;
         END IF;
         IF (exclude_hu_to_pick_in_one_step_ = 'Y') THEN
            IF (include_res_) THEN
               hu_total_qty_on_hand_ := Handling_Unit_API.Get_Qty_Onhand(root_handling_unit_id_);
               hu_total_qty_reserved_ := Handling_Unit_API.Get_Qty_Reserved(root_handling_unit_id_);
               IF (hu_total_qty_on_hand_ = hu_total_qty_reserved_) THEN
                  IF (NOT(Inv_Part_Stock_Reservation_API.Mixed_Reservations_Exist(root_handling_unit_id_))) THEN
                     -- full qty of handling unit structure is reserved by one CO line. Since exclude_hu_to_pick_in_one_step_ we must not include that reservations for transport tasks 
                     include_res_ := FALSE;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;   
      IF (include_res_) THEN        
         IF (move_reserve_tab_(i_).handling_unit_id != 0 AND include_full_qty_of_top_hu_ = 'Y') THEN
            un_executed_tt_line_exist_ := FALSE;
            move_res_allow_  := TRUE;
            IF (Handling_Unit_API.Has_Stock_On_Transport_Task(root_handling_unit_id_)) THEN
               un_executed_tt_line_exist_ := TRUE;
            END IF;

            IF (Handling_Unit_API.Has_Immovable_Stock_Reserv(root_handling_unit_id_, move_reserv_option_db_)) THEN
               move_res_allow_ := FALSE;
            END IF;
            IF (NOT(un_executed_tt_line_exist_) AND move_res_allow_) THEN                                                                                             
               Handling_Unit_API.Add_To_Transport_Task(root_handling_unit_id_, contract_, to_location_no_);
            END IF;        
         ELSE
            Inv_Part_Stock_Reservation_API.Move_Res_with_Transport_Task(move_reserve_tab_(i_).part_no,
                                                                        move_reserve_tab_(i_).configuration_id,
                                                                        contract_,
                                                                        move_reserve_tab_(i_).from_location_no,
                                                                        to_location_no_,
                                                                        Get_Order_Sup_Demand_Type_Db__(move_reserve_tab_(i_).source_ref_type_db),
                                                                        move_reserve_tab_(i_).source_ref1,
                                                                        move_reserve_tab_(i_).source_ref2,
                                                                        CASE move_reserve_tab_(i_).source_ref3 WHEN '*' THEN NULL ELSE move_reserve_tab_(i_).source_ref3 END,
                                                                        CASE move_reserve_tab_(i_).source_ref4 WHEN '*' THEN NULL ELSE move_reserve_tab_(i_).source_ref4 END,
                                                                        move_reserve_tab_(i_).pick_list_no,
                                                                        move_reserve_tab_(i_).shipment_id,
                                                                        move_reserve_tab_(i_).lot_batch_no,
                                                                        move_reserve_tab_(i_).serial_no,
                                                                        move_reserve_tab_(i_).eng_chg_level,
                                                                        move_reserve_tab_(i_).waiv_dev_rej_no,
                                                                        move_reserve_tab_(i_).activity_seq,
                                                                        move_reserve_tab_(i_).handling_unit_id,
                                                                        move_reserve_tab_(i_).qty_to_move);
         END IF; 
      END IF;
   END LOOP; 
END Move_Res_With_Trans_Task;

PROCEDURE Validate_Qty_To_Reserve (
   qty_to_reserve_ IN  NUMBER,
   qty_available_  IN  NUMBER )
IS
BEGIN
   IF (qty_to_reserve_ > qty_available_) THEN
      Error_SYS.Record_General(lu_name_, 'AVAILQTYEXCEED: More than the available quantity at the inventory location may not be pick reserved.');
   END IF; 
   IF (qty_to_reserve_  < 0 AND qty_to_reserve_ IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'QTYRESNEGVAL: The quantity reserved must be 0 or greater.');
   END IF;
END Validate_Qty_To_Reserve;

FUNCTION Get_Min_Durab_Days_For_Reserve(
   receiver_id_       IN VARCHAR2,
   contract_          IN VARCHAR2,
   inventory_part_no_ IN VARCHAR2) RETURN NUMBER
IS
   min_rem_days_at_deliv_ NUMBER;
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      min_rem_days_at_deliv_ := Sales_Part_Cross_Reference_API.Get_Min_Durab_Days_For_Catalog(receiver_id_,contract_,inventory_part_no_);
   $END
   
   IF min_rem_days_at_deliv_ IS NULL THEN
      min_rem_days_at_deliv_ := Inventory_Part_API.Get_Min_Durab_Days_Co_Deliv(contract_,inventory_part_no_);
   END IF;   
   
   RETURN min_rem_days_at_deliv_;
END Get_Min_Durab_Days_For_Reserve;


@UncheckedAccess
PROCEDURE Reserve_Inventory (
   reserved_qty_            OUT NUMBER,
   source_ref1_             IN  VARCHAR2,
   source_ref2_             IN  VARCHAR2,
   source_ref3_             IN  VARCHAR2,
   source_ref4_             IN  VARCHAR2,
   source_ref_type_db_      IN  VARCHAR2,   
   shipment_id_             IN  NUMBER,
   contract_                IN  VARCHAR2,
   inventory_part_no_       IN  VARCHAR2,
   warehouse_id_            IN  VARCHAR2,
   availability_control_id_ IN  VARCHAR2,
   qty_to_reserve_          IN  NUMBER,
   location_no_             IN  VARCHAR2 DEFAULT NULL,
   lot_batch_no_            IN  VARCHAR2 DEFAULT NULL,
   serial_no_               IN  VARCHAR2 DEFAULT NULL,
   eng_chg_level_           IN  VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_         IN  VARCHAR2 DEFAULT NULL,
   handling_unit_id_        IN  NUMBER   DEFAULT NULL,
   pick_list_no_            IN  NUMBER   DEFAULT 0)   
IS   
   quantity_reserved_      NUMBER := 0;
   source_project_id_      VARCHAR2(10);
   source_activity_seq_    NUMBER;
   configuration_id_       VARCHAR2(50);
   condition_code_         VARCHAR2(10);
   result_                 VARCHAR2(80);
   atp_checked_            VARCHAR2(1);
   err_text_1_             VARCHAR2(2000);
   err_text_2_             VARCHAR2(2000);
   new_due_date_           DATE := TRUNC(Site_API.Get_Site_Date(contract_));
   next_analysis_date_     DATE;
   early_ship_date_        DATE;
   qty_possible_           NUMBER;   
   is_nettable_            BOOLEAN;
   run_atp_check_          BOOLEAN := FALSE;
   part_ownership_db_      VARCHAR2(20);
   owning_customer_no_     VARCHAR2(20);
   owning_vendor_no_       VARCHAR2(20);
   atp_rowid_              VARCHAR2(2000);
   picking_leadtime_       NUMBER;
   include_standard_       VARCHAR2(5);
   include_project_        VARCHAR2(5); 
BEGIN     
   Shipment_Source_Utility_API.Get_Source_Info_At_Reserve__(source_project_id_,
                                                            source_activity_seq_,
                                                            include_standard_,
                                                            include_project_,
                                                            part_ownership_db_,
                                                            owning_customer_no_,
                                                            owning_vendor_no_,
                                                            configuration_id_,
                                                            condition_code_,
                                                            picking_leadtime_,
                                                            atp_rowid_,
                                                            source_ref1_, 
                                                            source_ref2_, 
                                                            source_ref3_, 
                                                            source_ref4_,                                                             
                                                            source_ref_type_db_);
   
  
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      atp_checked_ := Inventory_Part_API.Get_Onhand_Analysis_Flag_Db(contract_, inventory_part_no_);
      IF atp_checked_ = 'Y' THEN
         run_atp_check_ := TRUE;
         -- warehouse_id_ always have a value when Shipment Order Sender Type is a remote warehouse.
         IF warehouse_id_ IS NOT NULL THEN
            is_nettable_ := (Part_Availability_Control_API.Check_Supply_Control(availability_control_id_) = Part_Supply_Control_API.DB_NETTABLE);
            IF NOT is_nettable_ THEN
               run_atp_check_ := FALSE;
            END IF;
         END IF;
      END IF;
   END IF;

   IF run_atp_check_ THEN
      Inventory_Part_In_Stock_API.Make_Onhand_Analysis(result_                => result_, 
                                                       qty_possible_          => qty_possible_, 
                                                       next_analysis_date_    => next_analysis_date_,
                                                       planned_delivery_date_ => early_ship_date_, 
                                                       planned_due_date_      => new_due_date_, 
                                                       contract_              => contract_,
                                                       part_no_               => inventory_part_no_, 
                                                       configuration_id_      => configuration_id_,
                                                       include_standard_      => include_standard_, 
                                                       include_project_       => include_project_, 
                                                       project_id_            => source_project_id_, 
                                                       activity_seq_          => source_activity_seq_, 
                                                       row_id_                => atp_rowid_,
                                                       qty_desired_           => qty_to_reserve_, 
                                                       picking_leadtime_      => picking_leadtime_, 
                                                       part_ownership_        => part_ownership_db_,
                                                       owning_vendor_no_      => owning_vendor_no_, 
                                                       owning_customer_no_    => owning_customer_no_ );
      IF result_ != 'SUCCESS' THEN
         err_text_1_ := Language_SYS.Translate_Constant(lu_name_,
                                                        'CANNOTRESERVE: The reservation of part :P1 for :P2-:P3 has failed due to availability constraints.',
                                                        NULL,
                                                        inventory_part_no_, Logistics_Source_Ref_Type_API.Decode(source_ref_type_db_), source_ref1_ || ' ' || source_ref2_ || ' ' || source_ref3_ || ' ' || source_ref4_ );
         err_text_2_ := Language_SYS.Translate_Constant(lu_name_,
                                                        'EARLIESTAVAIL: Only :P1 is available. The earliest date with full availability is :P2.',
                                                        NULL,
                                                        to_char(qty_possible_), to_char(new_due_date_, 'YYYY-MM-DD'));
         Error_SYS.Record_General( lu_name_, 'SHIPODRESERVEFAIL: :P1 :P2', err_text_1_, err_text_2_);
      END IF;
      
   END IF;
      
   Inventory_Part_Reservation_API.Find_And_Reserve_Part(quantity_reserved_            => quantity_reserved_, 
                                                        contract_                     => contract_, 
                                                        part_no_                      => inventory_part_no_, 
                                                        configuration_id_             => configuration_id_, 
                                                        quantity_to_reserve_          => qty_to_reserve_, 
                                                        source_ref_type_db_           => Get_Inv_Res_Source_Type_Db(source_ref_type_db_),
                                                        source_ref1_                  => source_ref1_,
                                                        source_ref2_                  => NVL(source_ref2_,'*'),
                                                        source_ref3_                  => NVL(source_ref3_,'*'),
                                                        source_ref4_                  => NVL(source_ref4_,'*'),
                                                        shipment_id_                  => shipment_id_,
                                                        part_ownership_db_            => part_ownership_db_,
                                                        owning_vendor_no_             => owning_vendor_no_,
                                                        owning_customer_no_           => owning_customer_no_,
                                                        location_no_                  => location_no_,
                                                        lot_batch_no_                 => lot_batch_no_,
                                                        serial_no_                    => serial_no_,
                                                        eng_chg_level_                => eng_chg_level_,
                                                        waiv_dev_rej_no_              => waiv_dev_rej_no_,                                                      
                                                        activity_seq_                 => source_activity_seq_,
                                                        handling_unit_id_             => handling_unit_id_,
                                                        project_id_                   => source_project_id_,
                                                        condition_code_               => condition_code_,                                                        
                                                        expiration_control_date_      => Get_Expiration_Control_Date___(shipment_id_, contract_),
                                                        warehouse_id_                 => warehouse_id_,
                                                        ignore_this_avail_control_id_ => availability_control_id_,
                                                        string_parameter1_            => NULL,
                                                        string_parameter2_            => 'FALSE',                                                                                                          
                                                        pick_list_no_                 => pick_list_no_);
   

   reserved_qty_ := qty_to_reserve_;

END Reserve_Inventory;


@UncheckedAccess
FUNCTION Is_Fully_Reserved_Hu (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   fully_reserved_handling_unit_ VARCHAR2(5):='FALSE';
   hu_total_qty_on_hand_         NUMBER:=0;
   hu_total_qty_reserved_        NUMBER:=0; 
   dummy_                        NUMBER:=0; 
BEGIN
   Handling_Unit_API.Get_Inventory_Quantity(hu_total_qty_on_hand_, hu_total_qty_reserved_,
                                            dummy_, handling_unit_id_);
   
   IF (hu_total_qty_on_hand_ = hu_total_qty_reserved_) THEN
      IF (NOT(Inv_Part_Stock_Reservation_API.Mixed_Reservations_Exist(handling_unit_id_))) THEN
         fully_reserved_handling_unit_ := 'TRUE';
      END IF;   
   END IF; 

   RETURN fully_reserved_handling_unit_;
END Is_Fully_Reserved_Hu;

-------------------- LU  NEW METHODS -------------------------------------
