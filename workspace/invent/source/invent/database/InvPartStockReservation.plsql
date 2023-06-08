-----------------------------------------------------------------------------
--
--  Logical unit: InvPartStockReservation
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210120  Asawlk  SCZ-12896, Modified Reserve_Stock() in order to allow move of reserved stock for PROJ_MISC_DEMAND. 
--  201125  RoJalk  SC2020R1-11300, Modified Lock_And_Get_From_Source and passed default values for order_ref2_, order_ref3_ in Inventory_Part_Reservation_API.Lock_Res_And_Fetch_Info call.
--  201029  ErRalk  SC2020R1-10472, Modified Reserve_Stock() to allow Shipment Orders,Project Deliverables to find and reserve stock for source refrences that lost their reservation. 
--  201002  RoJalk  SC2020R1-1987, Modified Reserve_Stock and called Shipment_Order_API.Get_Availability_Control_Id.
--  201002  LEPESE  SC2021R1-318, replaced Work Order logic with Work Task logic in Get_Project_Cost_Elements, Move_Res_with_Transport_Task
--  201002          and Lock_And_Get_From_Source.
--  200921  LEPESE  SC2021R1-291, added order type WORK_TASK in method Get_Project_Cost_Elements.
--  200903  ErRalk  SC2020R1-7302, Modified Reserve_Stock to pass Default PAC ID value when the SourceRefType is Shipment Order and SenderType is Remote Warehouse.
--  200720  UtSwlk  Bug 154877(MFZ-4987), Corrected process id to MANUAL_ISSUE_SHOP_ORDER_PART in if condition in Create_Data_Capture_Lov().
--  200311  RoJalk  SCSPRING20-1930, Modified Move_Res_with_Transport_Task, Move_Reservation, Find_Reservations,
--  200311          Get_Available_Qty_To_Move, Lock_And_Get_From_Source, Reserve_Stock  to support Shipment Order.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  200206  RuLiLk  Bug 152261 (SCZ-8411), Modified Get_Qty_Picked by replacing cursor view inv_part_stock_res_move with Inv_Part_Stock_Reserv_Qty_Pick and replaced CONNECT BY PRIO with FOR loop handling to improve performance.
--  200122  BudKlk  Bug 151922 (SCZ-8162), Removed allow_deviating_avail_ctrl_ value from Transport_Task_Manager_API.New_Or_Add_To_Existing method to stop creating transport tasks for 
--  200122          the reserved parts from the inventory part in stock window when "Allow Deviating Availability Control" set from the site level.  
--  191224  UdGnlk  Bug 150959 (SCZ-7515), Modified Find_Reservations(), Reserve_Stock(), Move_Reservation() and Move_Res_with_Transport_Task() to support the reserving stock for PROJ_MISC_DEMAND.
--  191029  RuLiLk  Bug 149974 (SCZ-6834), Modified method Get_Pick_By_Choice_Blocked_Db by removing Connect by Prio used in cursor. Replaced it with Handling_Unit_API.Get_Node_And_Descendants to improve performance.
--  190823  AsZelk  Bug 149643 (SCZ-6081), Modified Move_Res_with_Transport_Task(), Move_Reservation(), Is_Booked_For_Transport() and used inv_part_stock_res_move instead inv_part_stock_reservation
--  190823          to allow move reserved inventory parts in a DO.
--  190722  BudKlk  Bug 149275 (SCZ-5522), Added a new constant move_reserve_src_type_7_ for distribution order type.
--  190617  ShPrlk  Bug 148455 (SCZ-5011), Replaced the Source_Ref_Type_Tab structure of move_reserve_src_type_tab_ and pick_by_choice_src_type_tab_
--  190617          to individual constants to reduce performance overheads. 
--  190428  AsZelk  Bug 147923 (SCZ-4128), Modified Get_Qty_Reserved(), Move_Hu_Res_Wth_Transp_Task() to allowed move reservation with transport task for Distribution Order.
--  180227  ChFolk  STRSC-16576, Modified Move_Reservation to restrict moving reservation if it is on transport task.
--  180221  KhVese  STRSC-17267, Added public constant unpack_reservation_.
--  180220  LEPESE  STRSC-16279, Added call to Inventory_Part_In_Stock_API.Get_Destinat_Expiration_Date in Move_Reservation.
--  180209  JeLise  STRSC-16913, Added in parameter order_supply_demand_type_db_ to Get_Pick_By_Choice_Blocked_Db (for part) and added
--  180209          check on qty in conditions in both Get_Pick_By_Choice_Blocked_Db.
--  180209  mwerse  STRSC-16598, Added overloaded method of Get_Qty_Picked to get quantity_picked for reserved stock.
--  180207  ChFolk  STRSC-16839, Modified Move_Res_with_Transport_Task to avoid validation for site level Move Reserved Stock flag as it is not applicable for Work Order Reservations.
--  180103  ChFolk  STRSC-14535, Renamed method Get_Reservation_On_Trans_Task as Is_Booked_For_Transport and changed the parameter order.
--  171212  MaAuse  STRSC-14792, Modified conditions in Get_Pick_By_Choice_Blocked_Db .
--  171204  MaAuse  STRSC-14792, Added parameter pick_by_choice_blocked_ in call to Shop_Material_Assign_Util_API.Reserve_Or_Unreserve_On_Swap in Reserve_Stock.
--  171130  MaAuse  STRSC-14792, Added parameter pick_by_choice_blocked_ in call to Dop_Invent_Assign_External_API.Reserve_Or_Unreserve_On_Swap in Reserve_Stock.
--  171128  ChFolk  STRSC-14535, Added new method Get_Reservation_On_Trans_Task which is used by the client to display the reservation is on a active transport task.
--  171107  LEPESE  STRSC-14169, Added validation for location_type in Move_New_With_Transport_Task.
--  171101  ChFolk  STRSC-14020, Added new method Raise_Move_Res_Not_Allowed___ to raise the error message in common when not allow to move the reserved stock.
--  171025  JeLise  STRSC-13216, Added pick_by_choice_blocked_ in Inv_Part_In_Stock_Res_Rec, Move_Reservation, Find_Reservations and Reserve_Stock.
--  171024  JeLise  STRSC-13216, Added two methods Get_Pick_By_Choice_Blocked_Db.
--  171020  SWiclk  STRSC-12675, Modified Find_Reservations() by adding case to handle Reservat_Adjustment_Option_API.DB_NOT_ALLOWED.
--  171017  ChFOLK  STRSC-12120, Moved method Allow_Move_Reserved_Stock to Handling_Unit_API as it relates to the whole structure of the handling unit.
--  171016  LEPESE  STRSC-12433, Replaced implementation methods with call to Order_Supply_Demand_Type_API.Get_Order_Type_Db.
--  171013  ChFolk  STRSC-12120, Added new method Allow_Move_Reserved_Stock which checks whether the reserved stock is allowed to move based on site parameter move reserved stock.
--  171006  LEPESE  STRSC-12433, Added method Move_New_With_Transport_Task.
--  171004  ChFolk  STRSC-12120, Added new method Mixed_Reservations_Exist which returns true when thre exists reservations from different sources lines with one handling unit structure.
--  171003  ChFolk  STRSC-12493, Modified Move_Res_with_Transport_Task to support pick_list_printed_ falg for shop materials and project deliverable reservations.
--  171002  ChFolk  STRSC-12493, Modified Move_Res_with_Transport_Task to support filtering over move reserved stock site settings.
--  170919  Chfose  STRSC-8922, Added overloaded method of Move_Res_With_Transport_Task that also has transport_task_id_ as an INOUT-parameter to be able to reuse the transport task id.
--  170822  DAYJLK  STRSC-11598, Modified Move_Res_with_Transport_Task and Lock_And_Get_From_Source to allow create new transport task for Material Requisitions.
--  170821  DAYJLK  STRSC-11526, Modified Move_Reservation to allow move of reserved stock for Material Requistions.
--  170802  Chfolk  STRSC-11135, Modified Move_Reservation to include project deliverables.
--  170802  ChFolk  STRSC-11135, Modified Move_Res_with_Transport_Task and Lock_And_Get_From_Source to allow create new transport task for project deliverables.
--  170728  JoAnSe  STRSC-9222, Implemented changes needed for moving DOP reservations with transport task. 
--  170727  DAYJLK  STRSC-11042, Modified definition of constant move_reserve_src_type_tab_ and method Reserve_Stock.
--  170726  JoAnSe  STRSC-11019, Added DB_DOP_DEMAND and DB_DOP_NETTED_DEMAND to pick_by_choice_src_type_tab_.
--  170725  JoAnSe  STRSC-9220, Changes in Reserve_Stock to support moving reservation in DOP temporary inventory. 
--  170714  Chfose  STRSC-9355, Added validate_hu_struct_position_ as parameter in Move_Reservation.
--  170615  MaEelk  STRSC-8108, Removed Parameter move_comment_ from Move_Res_with_Transport_Task and Move_Reservation.
--  170612  JoAnSe  LIM-11512, Corrected cursor in Get_Qty_Reserved.
--  170607  MaEelk  STRSC-8108, Added Parameter move_comment_ to Move_Res_with_Transport_Task and Move_Reservation.
--  170608  JoAnSe  LIM-10663, Changes in Move_Res_with_Transport_Task and Lock_And_Get_From_Source to allow transport task for material reserved to a shop order.
--  170531  KHVESE  LIM-10758, Modified methods Move_Hu_Res_Wth_Transp_Task and Move_Res_with_Transport_Task by adding default parameter check_storage_requirements_.
--  170531  UdGnlk  STRSC-8108, Modified Move_Reservation() pass the to location description to the inventory transaction history notes.
--  170512  UdGnlk  LIM-9668, Modified Reserve_Stock() to pass parameter reservation_operation_id_ to Reserve_Customer_Order_API.Make_CO_Reservation().   
--  170509  KhVese  STRSC-7211, Removed method Get_Source_Ref_Types() and instead added two public constants move_reserve_src_type_tab_ and pick_by_choice_src_type_tab_
--  170503  UdGnlk  LIM-11456, Modified Inv_Part_In_Stock_Res_Rec and Find_Reservations() cursor get_attr retrieving order_supply_demand_type_db instead order_supply_demand_type.
--  170428  KhVese  STRSC-7211, Modified methods Get_Available_Qty_To_Move and renamed method Source_Ref_Type_Is_Allowed() to Get_Source_Ref_Types().
--  170427  KhVese  STRSC-7211, Modified methods Find_Reservations and added methods Reserve_Stock() Source_Ref_Type_Is_Allowed().
--  170407  UdGnlk  LIM-10831, Modified Get_Available_Qty_To_Move() adding NVL to picked_qty_ and filtering with order supply demand type. 
--  170303  MaEelk  LIM-10886, Modified Move_Hu_Res_Wth_Transp_Task. Modified cursor to fetch reservation records for a inventory part in stock record instead of the handling Unit.
--  170303          Raised an error message when reserved quantity to be moved is not equal to the total moved quantity.
--  170302  RoJalk  LIM-11001, Replaced Shipment_Source_Utility_API.Public_Reservation_Rec with
--  170302          Reserve_Shipment_API.Public_Reservation_Rec.
--  170227  MaEelk  LIM-10886, Added Move_Hu_Res_Wth_Transp_Task. This will create transport task lines for the Customer Order  reservations connected to the Handling Unit.
--  170224  UdGnlk  LIM-10873, Renamed Lock_And_Fetch_Reserve_Info() to Lock_And_Get_From_Source() and modified review comments.  
--  170317  JoAnSe  LIM-10607, Correted condition for order_supply_demand_type in cursor in Find_Reservations___.
--  170215  MaEelk  LIM-10398, Added NVL to qty_picked in the cusrsor get_attr at Find_Reservation. Cursor was filtered to retrieve only Customer Order and Shop Order Reservations.
--  170214  UdGnlk  LIM-10371, Modified Lock_And_Fetch_Reserve_Info() further improvements. 
--  170203  KhVeSe  LIM-10240, Added method Get_Qty_Picked to get qty_picked for handling unit reservations.
--  170203  JoAnSe  LIM-10607, Changed Move_Reservation and Find_Reservations to allowed move of stock reserved for Shop Order
--  170131  UdGnlk  LIM-10371, Added Lock_And_Fetch_Reserve_Info() to support move reservation functionality.
--  170130  UdGnlk  LIM-10127, Modified Find_Reservations() cursor get_attr by renaming the planned_due_date to date_required previously added.
--  170126  UdGnlk  LIM-10127, Modified Find_Reservations() cursor get_attr by adding order by clause as planned_due_date. 
--  170113  UdGnlk  LIM-10371, Modified Move_Res_with_Transport_Task() by adding CUSTOMER ORDER as the order supply demand type to the condition of the message.
--  170111  MaEelk  LIM-10139, Added parameters pick_list_no_ and shipment_id to Get_Qty_Reserved.
--  161209  Asawlk  LIM-9965, Renamed existing method Move_Reservation() to Move_Res_with_Transport_Task() as it only handle moves with transport tasks.
--  161209          Added new method Move_Reservation() to move parts directly between inventory locations. 
--  161124  UdGnlk  LIM-9840, Modified Get_Available_Qty_To_Move() add condition when no reservatrion exists to return qty on hand. 
--  161122  UdGnlk  LIM-9826, Modified Find_Reservations() get_attr cursor values of pick_list_printed_db as it changed in Customer_Order_Res view.   
--  161118  UdGnlk  LIM-9536, Added Get_Available_Qty_To_Move() to calculate available quantity to move in move reservation functionality. 
--  160915  Asawlk  LIM-8698, Added method Find_Reservations(), record type Inv_Part_In_Stock_Res_Rec and table type Inv_Part_In_Stock_Res_Table.
--  160229  MaEelk  LIM-6313, Modified Get_Lot_Batch_Numbers and removed quotes from the Lot Batch Number List.
--  160126  JeLise  LIM-5984, Renamed Inv_Part_Stock_Reservation_Pub to Inv_Part_Stock_Reservation_Ext and made all calls to Inv_Part_Stock_Reservation dynamic,
--  160126          since it is created in Post_Installation_Object. 
--  151117  DaZase  LIM-4305, Changed methods Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist to use view Inv_Part_Stock_Reservation_Pub.
--  151117          Replaced cursor_id handling in Record_With_Column_Value_Exist with new params column_value_exist_check_ and column_value_nullable_. 
--  151102  MaEelk  LIM-4367, Removed the parameter pallet_id_ from Transport_Task_API.New_Or_Add_To_Existing
--  150826  RuLiLk  Bug 124207, Modified Create_Data_Capture_Lov() to display quantities between 0 and 1 with a leading 0 when displaying with LOV description for LOCATION_NO.
--  150729  BudKlk  Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729          method call in ORDER BY clause to sort string and number values seperately. 
--  150618  DaZase  COB-475, Added out param to Get_Column_Value_If_Unique to make it possible to see difference between no unique value found and to many values found.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150520  DaZase  COB-437, Removed 100 record description limitation in method Create_Data_Capture_Lov, 
--  150520          this will be replaced with a new configurable LOV record limitation in WADACO framework.
--  150518  DaZase  COB-394, Added method Get_Column_Value_If_Unique.
--  150512  DaZase  COB-394, Added cursor 2 to Record_With_Column_Value_Exist. Added sql_where_expression_ to Create_Data_Capture_Lov.
--  150512  JeLise  LIM-2876, Added handling_unit_id to Record_With_Column_Value_Exist.
--  150511  JeLise  LIM-2888, Added handling_unit_id to Get_Pick_List_No
--  150505  LEPESE  LIM-2861, added handling_unit_id to Get_Po_Rec_Co_Res_Serials.
--  150414  LEPESE  LIM-77, added handling_unit_id to some method declarations and calls.
--  150413  Chfose  LIM-1009, Fixed calls to Inventory_Part_In_Stock_API by including handling_unit_id.
--  150225  RILASE  PRSC-4585, Added Record_With_Column_Value_Exist.
--  150203  Chfose  PRSC-5924, Modified Get_Lot_Batch_Numbers to use new parameter part_no and only use other parameters if not null in where-statement.
--  141217  DaZase  PRSC-1611, Added extra column check in method Create_Data_Capture_Lov to avoid any risk of getting sql injection problems.
--  141113  RILASE  PBSC-3389, Added method Create_Data_Capture_Lov.
--  140212  AwWelk  PBSC-5502, Merged bug 113666 which added Get_Lot_Batch_Numbers() to return concatanated lot batch numbers.
--  140203  Matkse  Modified Move_Reservation by fetching DB value of allow_deviating_avail_ctrl_ intead of client value. 
--  131004  RILASE  Added Get_Qty_Reserved, Move_Reservation and Get_Pick_List_No.
--  130419  Vwloza  Added SUPPLIER_SHIPMENT_RESERVATION to INV_PART_STOCK_RESERVATION view.
--  130103  NaLrlk  Added INV_PART_STOCK_RESERVATION_PUB view to use for rental.
--  130325  Kanilk  ONESA-546 Modified INV_PART_STOCK_RESERVATION view.
--  121213  Dinklk  Added CRO_EXCHANGE_RESERVATION as a UNION to INV_PART_STOCK_RESERVATION view.
--  121212  RoJalk  Modified INV_PART_STOCK_RESERVATION, INV_PART_STOCK_RESERVATION_UIV and added shipment id.
--  120918  IRJALK  Bug 104826, Modified Get_Project_Cost_Elements() by adding parameter part_no to invoking function 
--  120918          Inventory_Transaction_Hist_API.Create_Value_Detail_Tab().
--  111219  Matkse  Modified INV_PART_STOCK_RESERVATION_UIV to contain WAREHOUSE, BAY_NO, ROW_NO, TIER_NO, BIN_NO from INVENTORY_LOCATION
--  111027  NISMLK  SMA-285, Increased eng_chg_level length to STRING(6) in column comments.
--  110810  MaEelk  Renamed views SHOP_MATERIAL_ASSIGN, DOP_INVENT_ASSIGN_EXTERNAL, DOP_INVENT_ASSIGN_INTERNAL , 
--  110810          INTERIM_ORD_INVENT_ASSIGN and CRO_RESERVATION as SHOP_MATERIAL_ASSIGN_RES, DOP_INVENT_ASSIGN_EXT_RES, 
--  110810          DOP_INVENT_ASSIGN_INT_RES, INTERIM_ORD_INV_ASSIGN_RES and CRO_RESERVATION_RES.
--  110601  LEPESE  Added method Get_Po_Rec_Co_Res_Serials.
--  110325  PAWELK  EANE-4869, Modified the where clause in INV_PART_STOCK_RESERVATION_UIV to fetch user allowed site. 
--  110225  LaRelk  Added view PLANT_RESERVED_MATERIAL.
--  110203  JoAnSe  Added retrieval of pick_list_no for WO in MAINT_MATERIAL_ALLOCATION view
--  101124  RaKalk  Added pick list no to INV_PART_STOCK_RESERVATION view
--  ----------------------- Blackbird Merge End ------------------------------
--  110212  Nuwklk Merge Blackbird Code
--  100816  ImFelk BB08, Added view MAINT_TASK_OPER_MATR_ALLOC1 to INV_PART_STOCK_RESERVATION.
--  ----------------------- Blackbird Merge Start ----------------------------- 
--  110228  ChJalk Added view VIEW_UIV to be used in client side with 'User Allowed Site' filter.
--  101104  MalLlk Modified view INV_PART_STOCK_RESERVATION to union the view CRO_RESERVATION.
--  100108  SaFalk Replaced WORK_ORDER_PART_ALLOC with MAINT_MATERIAL_ALLOCATION
--  ------------------------------------------ 14.0.0 -----------------------
--  080709  RoJalk Bug 74811, Removed parameters transaction_id_,pre_accounting_id_,   
--  080709         activity_seq_ and project_id_ from the call Mpccom_Accounting_API.
--  080709         Get_Project_Cost_Elements in Get_Project_Cost_Elements.
--  080507  RoJalk Bug 73185, Modified Get_Project_Cost_Elements to handle location_group_ and location_type_.
--  080507  HoInlk Bug 73185, Added method Get_Project_Cost_Elements.
--  071108  HaYalk Bug 68150, Unioned MTRL_TRANSFER_REQ_RESERVATION to INV_PART_STOCK_RESERVATION.
--  060310  IsWilk Added the condition supply_reserved_flag = 'N' to the where clause of the    
--  060310         INTERIM_ORD_INVENT_ASSIGN to fix the problem in assembly shop orders.
--  060119  OsAllk Replaced the hard codeed value 0 with activity_sequence.
--  060118  ShVese Added view DOP_INVENT_ASSIGN_INTERNAL and added an extra condition
--                 in the view DOP_INVENT_ASSIGN_EXTERNAL.
--  051003  IsWilk Modified the view comments in view INV_PART_STOCK_RESERVATION. 
--  050929  IsWilk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Inv_Part_In_Stock_Res_Rec IS RECORD (
                  ORDER_NO                      VARCHAR2(50),
                  LINE_NO                       VARCHAR2(4000),
                  RELEASE_NO                    VARCHAR2(50),
                  LINE_ITEM_NO                  VARCHAR2(50),
                  ORDER_SUPPLY_DEMAND_TYPE_DB   VARCHAR2(30),
                  PART_NO                       VARCHAR2(25),
                  CONTRACT                      VARCHAR2(5),
                  CONFIGURATION_ID              VARCHAR2(50),
                  LOCATION_NO                   VARCHAR2(35),
                  LOT_BATCH_NO                  VARCHAR2(20),
                  SERIAL_NO                     VARCHAR2(50),
                  ENG_CHG_LEVEL                 VARCHAR2(6),
                  WAIV_DEV_REJ_NO               VARCHAR2(15),                  
                  ACTIVITY_SEQ                  NUMBER,
                  HANDLING_UNIT_ID              NUMBER,
                  SHIPMENT_ID                   NUMBER,
                  PICK_LIST_NO                  VARCHAR2(40),
                  QTY_PICKED                    NUMBER,
                  PICK_LIST_PRINTED_DB          VARCHAR2(5),             
                  QTY_RESERVED                  NUMBER,                  
                  CO_RES_INPUT_QTY              NUMBER,
                  CO_RES_INPUT_UNIT_MEAS        VARCHAR2(30),
                  CO_RES_INPUT_CONV_FACTOR      NUMBER,
                  CO_RES_INPUT_VARIABLE_VALUES  VARCHAR2(2000),
                  PICK_BY_CHOICE_BLOCKED        VARCHAR2(5));

TYPE Inv_Part_In_Stock_Res_Table IS TABLE OF Inv_Part_In_Stock_Res_Rec INDEX BY BINARY_INTEGER;
TYPE Source_Ref_Type_Tab         IS TABLE OF VARCHAR2(30);

move_reserve_src_type_1_         CONSTANT VARCHAR2(1)   :=    Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO; 
move_reserve_src_type_2_         CONSTANT VARCHAR2(1)   :=    Order_Supply_Demand_Type_API.DB_CUST_ORDER;
move_reserve_src_type_3_         CONSTANT VARCHAR2(2)   :=    Order_Supply_Demand_Type_API.DB_DOP_DEMAND;
move_reserve_src_type_4_         CONSTANT VARCHAR2(2)   :=    Order_Supply_Demand_Type_API.DB_DOP_NETTED_DEMAND;
move_reserve_src_type_5_         CONSTANT VARCHAR2(20)  :=    Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES;
move_reserve_src_type_6_         CONSTANT VARCHAR2(1)   :=    Order_Supply_Demand_Type_API.DB_MATERIAL_REQ;
move_reserve_src_type_7_         CONSTANT VARCHAR2(2)   :=    Order_Supply_Demand_Type_API.DB_DISTRIBUTION_ORDER;
move_reserve_src_type_8_         CONSTANT VARCHAR2(2)   :=    Order_Supply_Demand_Type_API.DB_PROJ_MISC_DEMAND;
move_reserve_src_type_9_         CONSTANT VARCHAR2(14)  :=    Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER;

pick_by_choice_src_type_1_       CONSTANT VARCHAR2(1)   :=    Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO;
pick_by_choice_src_type_2_       CONSTANT VARCHAR2(1)   :=    Order_Supply_Demand_Type_API.DB_CUST_ORDER;
pick_by_choice_src_type_3_       CONSTANT VARCHAR2(2)   :=    Order_Supply_Demand_Type_API.DB_DISTRIBUTION_ORDER;
pick_by_choice_src_type_4_       CONSTANT VARCHAR2(2)   :=    Order_Supply_Demand_Type_API.DB_DOP_DEMAND;
pick_by_choice_src_type_5_       CONSTANT VARCHAR2(2)   :=    Order_Supply_Demand_Type_API.DB_DOP_NETTED_DEMAND;
pick_by_choice_src_type_6_       CONSTANT VARCHAR2(20)  :=    Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES;
pick_by_choice_src_type_7_       CONSTANT VARCHAR2(14)  :=    Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER;

move_reservation_                CONSTANT NUMBER := 1;
pick_by_choice_                  CONSTANT NUMBER := 2;
unpack_reservation_              CONSTANT NUMBER := 3;

-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_        CONSTANT VARCHAR2(11) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Raise_Move_Res_Not_Allowed___ (
   order_supply_demand_type_db_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'ONLYMOVEWORESERVATIONS: It is not allowed to move a reservation of type :P1.', Order_Supply_Demand_Type_API.Decode(order_supply_demand_type_db_));
END Raise_Move_Res_Not_Allowed___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Project_Cost_Elements (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN Mpccom_Accounting_API.Project_Cost_Element_Tab
IS
   char_null_                   VARCHAR2(12) := 'VARCHAR2NULL';   
   order_supply_demand_type_    VARCHAR2(2000);
   order_supply_demand_type_db_ VARCHAR2(2);
   valuation_method_db_         VARCHAR2(50);
   unit_cost_detail_tab_        Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   value_detail_tab_            Mpccom_Accounting_API.Value_Detail_Tab;
   cost_element_tab_            Mpccom_Accounting_API.Project_Cost_Element_Tab;
   total_cost_element_tab_      Mpccom_Accounting_API.Project_Cost_Element_Tab;
   location_group_              VARCHAR2(5);
   location_type_               VARCHAR2(20);

   CURSOR get_reservations IS
      SELECT contract, part_no, configuration_id, lot_batch_no, serial_no, location_no,
             SUM(qty_reserved) quantity
        FROM inv_part_stock_res_move
       WHERE order_no                        = source_ref1_
         AND line_no                         = source_ref2_ 
         AND NVL(release_no, char_null_)     = NVL(source_ref3_, char_null_)
         AND NVL(line_item_no, char_null_)   = NVL(source_ref4_, char_null_)
         AND order_supply_demand_type        = order_supply_demand_type_
       GROUP BY contract, part_no, configuration_id, lot_batch_no, serial_no, location_no;

   TYPE Reservation_Tab IS TABLE OF get_reservations%ROWTYPE;
   reservation_tab_ Reservation_Tab;
BEGIN
   CASE source_ref_type_db_
      WHEN Order_Type_API.DB_CUSTOMER_ORDER       THEN order_supply_demand_type_db_ := Order_Supply_Demand_Type_API.DB_CUST_ORDER;
      WHEN Order_Type_API.DB_MATERIAL_REQUISITION THEN order_supply_demand_type_db_ := Order_Supply_Demand_Type_API.DB_MATERIAL_REQ;
      WHEN Order_Type_API.DB_PROJECT              THEN order_supply_demand_type_db_ := Order_Supply_Demand_Type_API.DB_PROJ_MISC_DEMAND;
      WHEN Order_Type_API.DB_PURCHASE_ORDER       THEN order_supply_demand_type_db_ := Order_Supply_Demand_Type_API.DB_PURCH_ORDER_RES;
      WHEN Order_Type_API.DB_SHOP_ORDER           THEN order_supply_demand_type_db_ := Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO;
      WHEN Order_Type_API.DB_WORK_TASK            THEN order_supply_demand_type_db_ := Order_Supply_Demand_Type_API.DB_WORK_TASK;
   END CASE;

   order_supply_demand_type_ := Order_Supply_Demand_Type_API.Decode(order_supply_demand_type_db_);

   OPEN get_reservations;
   FETCH get_reservations BULK COLLECT INTO reservation_tab_;
   CLOSE get_reservations;

   IF (reservation_tab_.COUNT > 0) THEN
      FOR i IN reservation_tab_.FIRST..reservation_tab_.LAST LOOP
         valuation_method_db_ := Inventory_Part_API.Get_Invent_Valuation_Method_Db(
                                                                      reservation_tab_(i).contract,
                                                                      reservation_tab_(i).part_no);
         IF (valuation_method_db_ IN ('FIFO','LIFO')) THEN
            unit_cost_detail_tab_ := Inventory_Part_Cost_Fifo_API.Get_Cost_Details(
                                                                     reservation_tab_(i).contract,
                                                                     reservation_tab_(i).part_no,
                                                                     reservation_tab_(i).quantity);
         ELSE
            unit_cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Cost_Details_By_Method(
                                                              reservation_tab_(i).contract,
                                                              reservation_tab_(i).part_no,
                                                              reservation_tab_(i).configuration_id,
                                                              reservation_tab_(i).lot_batch_no,
                                                              reservation_tab_(i).serial_no);
         END IF;
         value_detail_tab_ := Inventory_Transaction_Hist_API.Create_Value_Detail_Tab(
                                                                     unit_cost_detail_tab_,
                                                                     reservation_tab_(i).quantity,
                                                                     reservation_tab_(i).part_no);

         location_group_   := Inventory_Location_API.Get_Location_Group(reservation_tab_(i).contract,
                                                                        reservation_tab_(i).location_no);

         location_type_    := Inventory_Location_Group_API.Get_Inventory_Location_Type_Db(location_group_); 

         cost_element_tab_ := Mpccom_Accounting_API.Get_Project_Cost_Elements(
                                  part_no_                      => reservation_tab_(i).part_no,
                                  contract_                     => reservation_tab_(i).contract,
                                  source_ref_type_db_           => source_ref_type_db_,
                                  source_ref1_                  => source_ref1_,
                                  source_ref2_                  => source_ref2_,
                                  source_ref3_                  => source_ref3_,
                                  source_ref4_                  => source_ref4_,
                                  part_related_                 => TRUE,
                                  charge_type_                  => NULL,
                                  charge_group_                 => NULL,
                                  error_when_element_not_exist_ => TRUE,
                                  include_charge_               => FALSE,
                                  supp_grp_                     => NULL,
                                  stat_grp_                     => NULL,
                                  assortment_                   => NULL,
                                  value_detail_tab_             => value_detail_tab_,
                                  location_type_                => location_type_,
                                  location_group_               => location_group_);

         total_cost_element_tab_ := Mpccom_Accounting_API.Get_Merged_Cost_Element_Tab(
                                                                           total_cost_element_tab_,
                                                                           cost_element_tab_);
      END LOOP;
   END IF;
   
   RETURN (total_cost_element_tab_);
END Get_Project_Cost_Elements;


@UncheckedAccess
FUNCTION Get_Po_Rec_Co_Res_Serials (
   po_order_no_      IN VARCHAR2,
   po_line_no_       IN VARCHAR2,
   po_release_no_    IN VARCHAR2,
   po_receipt_no_    IN NUMBER,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN Part_Serial_Catalog_API.Serial_No_Tab
IS
   dummy_             NUMBER;
   po_rec_serial_tab_ Part_Serial_Catalog_API.Serial_No_Tab;
   co_res_serial_tab_ Part_Serial_Catalog_API.Serial_No_Tab;
   row_               PLS_INTEGER := 0;

   CURSOR exist_control (serial_no_ IN VARCHAR2) IS
      SELECT 1
        FROM inv_part_stock_res_move
       WHERE contract                 = contract_
         AND part_no                  = part_no_
         AND configuration_id         = configuration_id_
         AND location_no              = location_no_
         AND lot_batch_no             = lot_batch_no_
         AND serial_no                = serial_no_
         AND eng_chg_level            = eng_chg_level_
         AND waiv_dev_rej_no          = waiv_dev_rej_no_
         AND activity_seq             = activity_seq_
         AND handling_unit_id         = handling_unit_id_
         AND order_supply_demand_type = Order_Supply_Demand_Type_API.Decode('1');
BEGIN
   po_rec_serial_tab_ := Inventory_Transaction_Hist_API.Get_Purchase_Receipt_Serials(po_order_no_,
                                                                                     po_line_no_,
                                                                                     po_release_no_,
                                                                                     po_receipt_no_);
   IF (po_rec_serial_tab_.COUNT > 0) THEN
      FOR i IN po_rec_serial_tab_.FIRST..po_rec_serial_tab_.LAST LOOP
         OPEN exist_control (po_rec_serial_tab_(i).serial_no);
         FETCH exist_control INTO dummy_;
         IF (exist_control%FOUND) THEN
            row_ := row_ + 1;
            co_res_serial_tab_(row_) := po_rec_serial_tab_(i);
         END IF;
         CLOSE exist_control;
      END LOOP;
   END IF;

   RETURN (co_res_serial_tab_);
END Get_Po_Rec_Co_Res_Serials;


@UncheckedAccess
FUNCTION Get_Qty_Reserved (
   order_no_                    IN VARCHAR2,
   line_no_                     IN VARCHAR2,
   release_no_                  IN VARCHAR2,
   line_item_no_                IN VARCHAR2,
   pick_list_no_                IN VARCHAR2,
   shipment_id_                 IN NUMBER,
   order_supply_demand_type_db_ IN VARCHAR2,
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   activity_seq_                IN NUMBER,
   handling_unit_id_            IN NUMBER ) RETURN NUMBER
IS
   qty_reserved_ NUMBER := 0;

   CURSOR get_attr IS
      SELECT qty_reserved
      FROM  inv_part_stock_res_move
      WHERE order_no                 = order_no_
      AND   line_no                  = line_no_
      AND   ((release_no IS NULL AND release_no_ IS NULL) OR (release_no = release_no_))
      AND   ((line_item_no IS NULL AND line_item_no_ IS NULL) OR (line_item_no = line_item_no_))
      AND   ((pick_list_no IS NULL AND pick_list_no_ IS NULL) OR (pick_list_no = pick_list_no_))
      AND   ((shipment_id IS NULL AND shipment_id_ IS NULL) OR (shipment_id = shipment_id_))
      AND   order_supply_demand_type = Order_Supply_Demand_Type_API.Decode(order_supply_demand_type_db_)
      AND   contract                 = contract_
      AND   part_no                  = part_no_
      AND   configuration_id         = configuration_id_
      AND   location_no              = location_no_
      AND   lot_batch_no             = lot_batch_no_
      AND   serial_no                = serial_no_
      AND   eng_chg_level            = eng_chg_level_
      AND   waiv_dev_rej_no          = waiv_dev_rej_no_
      AND   activity_seq             = activity_seq_
      AND   handling_unit_id         = handling_unit_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO qty_reserved_;
   CLOSE get_attr;
   RETURN NVL(qty_reserved_, 0);
END Get_Qty_Reserved;


@UncheckedAccess
FUNCTION Get_Pick_List_No (
   order_no_                 IN VARCHAR2,
   line_no_                  IN VARCHAR2,
   release_no_               IN VARCHAR2,
   line_item_no_             IN VARCHAR2,
   order_supply_demand_type_ IN VARCHAR2,
   contract_                 IN VARCHAR2,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   location_no_              IN VARCHAR2,
   lot_batch_no_             IN VARCHAR2,
   serial_no_                IN VARCHAR2,
   eng_chg_level_            IN VARCHAR2,
   waiv_dev_rej_no_          IN VARCHAR2,
   activity_seq_             IN NUMBER,
   handling_unit_id_         IN NUMBER ) RETURN VARCHAR2
IS
   pick_list_no_ VARCHAR2(15);

   CURSOR get_attr IS
      SELECT pick_list_no
      FROM  inv_part_stock_res_move
      WHERE order_no                 = order_no_
      AND   line_no                  = line_no_
      AND   release_no               = release_no_
      AND   line_item_no             = line_item_no_
      AND   order_supply_demand_type = order_supply_demand_type_
      AND   contract                 = contract_
      AND   part_no                  = part_no_
      AND   configuration_id         = configuration_id_
      AND   location_no              = location_no_
      AND   lot_batch_no             = lot_batch_no_
      AND   serial_no                = serial_no_
      AND   eng_chg_level            = eng_chg_level_
      AND   waiv_dev_rej_no          = waiv_dev_rej_no_
      AND   activity_seq             = activity_seq_
      AND   handling_unit_id         = handling_unit_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO pick_list_no_;
   CLOSE get_attr;
   
   RETURN pick_list_no_;
END Get_Pick_List_No;


PROCEDURE Move_Res_With_Transport_Task (
   part_no_                      IN     VARCHAR2,
   configuration_id_             IN     VARCHAR2,
   contract_                     IN     VARCHAR2,
   from_location_no_             IN     VARCHAR2,
   to_location_no_               IN     VARCHAR2,
   order_supply_demand_type_db_  IN     VARCHAR2,
   order_no_                     IN     VARCHAR2,
   line_no_                      IN     VARCHAR2,
   release_no_                   IN     VARCHAR2,
   line_item_no_                 IN     VARCHAR2,
   pick_list_no_                 IN     VARCHAR2,
   shipment_id_                  IN     NUMBER,
   lot_batch_no_                 IN     VARCHAR2,
   serial_no_                    IN     VARCHAR2,
   eng_chg_level_                IN     VARCHAR2,
   waiv_dev_rej_no_              IN     VARCHAR2,
   activity_seq_                 IN     NUMBER,
   handling_unit_id_             IN     NUMBER,
   quantity_to_move_             IN     NUMBER,
   check_storage_requirements_   IN     BOOLEAN DEFAULT FALSE )
IS
   transport_task_id_ NUMBER;
BEGIN
   Move_Res_with_Transport_Task(
      transport_task_id_            => transport_task_id_,
      part_no_                      => part_no_,
      configuration_id_             => configuration_id_,
      contract_                     => contract_,
      from_location_no_             => from_location_no_,
      to_location_no_               => to_location_no_,
      order_supply_demand_type_db_  => order_supply_demand_type_db_,
      order_no_                     => order_no_,
      line_no_                      => line_no_,
      release_no_                   => release_no_,
      line_item_no_                 => line_item_no_,
      pick_list_no_                 => pick_list_no_,
      shipment_id_                  => shipment_id_,
      lot_batch_no_                 => lot_batch_no_,
      serial_no_                    => serial_no_,
      eng_chg_level_                => eng_chg_level_,
      waiv_dev_rej_no_              => waiv_dev_rej_no_,
      activity_seq_                 => activity_seq_,
      handling_unit_id_             => handling_unit_id_,
      quantity_to_move_             => quantity_to_move_,
      check_storage_requirements_   => check_storage_requirements_);
END Move_Res_With_Transport_Task;


PROCEDURE Move_Res_with_Transport_Task (
   transport_task_id_            IN OUT NUMBER,
   part_no_                      IN     VARCHAR2,
   configuration_id_             IN     VARCHAR2,
   contract_                     IN     VARCHAR2,
   from_location_no_             IN     VARCHAR2,
   to_location_no_               IN     VARCHAR2,
   order_supply_demand_type_db_  IN     VARCHAR2,
   order_no_                     IN     VARCHAR2,
   line_no_                      IN     VARCHAR2,
   release_no_                   IN     VARCHAR2,
   line_item_no_                 IN     VARCHAR2,
   pick_list_no_                 IN     VARCHAR2,
   shipment_id_                  IN     NUMBER,
   lot_batch_no_                 IN     VARCHAR2,
   serial_no_                    IN     VARCHAR2,
   eng_chg_level_                IN     VARCHAR2,
   waiv_dev_rej_no_              IN     VARCHAR2,
   activity_seq_                 IN     NUMBER,
   handling_unit_id_             IN     NUMBER,
   quantity_to_move_             IN     NUMBER,
   check_storage_requirements_   IN     BOOLEAN DEFAULT FALSE)
  IS
   serial_no_tab_              Part_Serial_Catalog_API.Serial_No_Tab;
   serials_added_              Part_Serial_Catalog_API.Serial_No_Tab;
   quantity_added_             NUMBER;
   local_quantity_to_move_     NUMBER;
   move_reservation_option_db_ VARCHAR2(20);
   reserved_stock_rec_         Inv_Part_In_Stock_Res_Rec;
   pick_list_printed_          BOOLEAN := FALSE;
   
   local_order_no_             VARCHAR2(4000);
   local_line_no_              VARCHAR2(4000);
   local_release_no_           VARCHAR2(4000);
   local_line_item_no_         NUMBER;
   local_demand_type_db_       VARCHAR2(4000);
  BEGIN
   IF (order_supply_demand_type_db_ NOT IN (Order_Supply_Demand_Type_API.DB_WORK_TASK, Order_Supply_Demand_Type_API.DB_CUST_ORDER, Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO,
                                            Order_Supply_Demand_Type_API.DB_DOP_DEMAND, Order_Supply_Demand_Type_API.DB_DOP_NETTED_DEMAND, Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES,
                                            Order_Supply_Demand_Type_API.DB_MATERIAL_REQ, Order_Supply_Demand_Type_API.DB_DISTRIBUTION_ORDER,  Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER, Order_Supply_Demand_Type_API.DB_PROJ_MISC_DEMAND)) THEN
      Raise_Move_Res_Not_Allowed___(order_supply_demand_type_db_);
   
   END IF; 
   
   $IF Component_Disord_SYS.INSTALLED $THEN
      IF order_supply_demand_type_db_ = Order_Supply_Demand_Type_API.DB_DISTRIBUTION_ORDER THEN 
         Distribution_Order_API.Get_Customer_Order_Info(local_order_no_, local_line_no_, local_release_no_, local_line_item_no_, order_no_);
         local_demand_type_db_ := Order_Supply_Demand_Type_API.DB_CUST_ORDER;
      END IF;
   $ELSE
      NULL;
   $END
   
   IF (serial_no_ != '*') THEN
      serial_no_tab_(1).serial_no := serial_no_;
      local_quantity_to_move_ := NULL;
   ELSE
      local_quantity_to_move_ := quantity_to_move_;
   END IF;
   
   move_reservation_option_db_ := Site_Invent_Info_API.Get_Move_Reservation_Option_Db(contract_);
     
   reserved_stock_rec_.order_no                 := nvl(local_order_no_, order_no_);
   reserved_stock_rec_.line_no                  := nvl(local_line_no_, line_no_);
   reserved_stock_rec_.release_no               := nvl(local_release_no_, release_no_);
   reserved_stock_rec_.line_item_no             := nvl(local_line_item_no_, line_item_no_);
   reserved_stock_rec_.order_supply_demand_type_db := nvl(local_demand_type_db_, order_supply_demand_type_db_);
   reserved_stock_rec_.part_no                  := part_no_;
   reserved_stock_rec_.contract                 := contract_;
   reserved_stock_rec_.configuration_id         := configuration_id_;
   reserved_stock_rec_.location_no              := from_location_no_;
   reserved_stock_rec_.lot_batch_no             := lot_batch_no_;
   reserved_stock_rec_.serial_no                := serial_no_;
   reserved_stock_rec_.eng_chg_level            := eng_chg_level_;
   reserved_stock_rec_.waiv_dev_rej_no          := waiv_dev_rej_no_;
   reserved_stock_rec_.activity_seq             := activity_seq_;
   reserved_stock_rec_.handling_unit_id         := handling_unit_id_;
   reserved_stock_rec_.shipment_id              := shipment_id_;
   reserved_stock_rec_.pick_list_no             := pick_list_no_;
   
   IF (pick_list_no_ != '*') THEN
      IF (nvl(local_demand_type_db_, order_supply_demand_type_db_) = Order_Supply_Demand_Type_API.DB_CUST_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            pick_list_printed_ := Customer_Order_Pick_List_API.Get_Printed_Flag_Db(pick_list_no_) = 'Y';      
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER');
         $END
      ELSIF (nvl(local_demand_type_db_, order_supply_demand_type_db_) = Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO) THEN
         $IF Component_Shpord_SYS.INSTALLED $THEN
            pick_list_printed_ := Shop_Material_Pick_List_API.Get_Pick_List_Printed_Db(pick_list_no_) = 'TRUE';
         $ELSE
            Error_SYS.Component_Not_Exist('SHPORD');
         $END      
      ELSIF (nvl(local_demand_type_db_, order_supply_demand_type_db_) IN (Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES, 
                                                                          Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER)) THEN
         pick_list_printed_ := Inventory_Pick_List_API.Get_Printed_Db(pick_list_no_) = 'TRUE';         
      END IF;   
      IF (pick_list_printed_) THEN
         reserved_stock_rec_.pick_list_printed_db := 'TRUE';
      ELSE
         reserved_stock_rec_.pick_list_printed_db := 'FALSE';
      END IF;
   END IF;

   reserved_stock_rec_.qty_picked := Get_Qty_Picked(   
      order_no_                    => nvl(local_order_no_, order_no_),
      line_no_                     => nvl(local_line_no_, line_no_),
      release_no_                  => nvl(local_release_no_, release_no_),
      line_item_no_                => nvl(local_line_item_no_, line_item_no_),
      pick_list_no_                => pick_list_no_,
      shipment_id_                 => shipment_id_,
      order_supply_demand_type_db_ => nvl(local_demand_type_db_, order_supply_demand_type_db_),
      contract_                    => contract_,
      part_no_                     => part_no_,
      configuration_id_            => configuration_id_,
      location_no_                 => from_location_no_,
      lot_batch_no_                => lot_batch_no_,
      serial_no_                   => serial_no_,
      eng_chg_level_               => eng_chg_level_,
      waiv_dev_rej_no_             => waiv_dev_rej_no_,
      activity_seq_                => activity_seq_,
      handling_unit_id_            => handling_unit_id_);
   reserved_stock_rec_.qty_reserved := local_quantity_to_move_;
   
   -- site level Move Reserved Stock flag is not applicable for Work Task Reservations
   IF order_supply_demand_type_db_ NOT IN (Order_Supply_Demand_Type_API.DB_WORK_TASK) THEN
      Invent_Part_Quantity_Util_API.Validate_Move_Reservation(move_reservation_option_db_, reserved_stock_rec_); 
   END IF;
   Transport_Task_Manager_API.New_Or_Add_To_Existing(
      transport_task_id_          => transport_task_id_,
      quantity_added_             => quantity_added_,
      serials_added_              => serials_added_,
      part_no_                    => part_no_,
      configuration_id_           => configuration_id_,
      from_contract_              => contract_,
      from_location_no_           => from_location_no_,
      to_contract_                => contract_,
      to_location_no_             => to_location_no_,
      destination_                => Inventory_Part_Destination_API.Decode(Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY),
      order_type_                 => Order_Type_API.Decode(Order_Supply_Demand_Type_API.Get_Order_Type_Db(nvl(local_demand_type_db_, order_supply_demand_type_db_))),
      order_ref1_                 => nvl(local_order_no_, order_no_),
      order_ref2_                 => nvl(local_line_no_, line_no_),
      order_ref3_                 => nvl(local_release_no_, release_no_),
      order_ref4_                 => nvl(local_line_item_no_, line_item_no_),
      pick_list_no_               => pick_list_no_,
      shipment_id_                => shipment_id_,
      lot_batch_no_               => lot_batch_no_,
      serial_no_tab_              => serial_no_tab_,
      eng_chg_level_              => eng_chg_level_,
      waiv_dev_rej_no_            => waiv_dev_rej_no_,
      activity_seq_               => activity_seq_,
      handling_unit_id_           => handling_unit_id_,
      quantity_to_add_            => local_quantity_to_move_,
      requested_date_finished_    => NULL,
      note_text_                  => NULL,
      reserved_by_source_db_      => Fnd_Boolean_API.DB_TRUE,
      check_storage_requirements_ => check_storage_requirements_);
  
END Move_Res_with_Transport_Task;

PROCEDURE Move_Reservation (
   part_no_                       IN VARCHAR2,
   configuration_id_              IN VARCHAR2,
   contract_                      IN VARCHAR2,
   from_location_no_              IN VARCHAR2,
   to_location_no_                IN VARCHAR2,
   order_supply_demand_type_db_   IN VARCHAR2,
   order_no_                      IN VARCHAR2,
   line_no_                       IN VARCHAR2,
   release_no_                    IN VARCHAR2,
   line_item_no_                  IN VARCHAR2,
   lot_batch_no_                  IN VARCHAR2,
   serial_no_                     IN VARCHAR2,
   eng_chg_level_                 IN VARCHAR2,
   waiv_dev_rej_no_               IN VARCHAR2,
   activity_seq_                  IN NUMBER,
   handling_unit_id_              IN NUMBER,
   quantity_to_move_              IN NUMBER,   
   pick_list_no_                  IN VARCHAR2,
   qty_picked_                    IN NUMBER,
   pick_list_printed_db_          IN VARCHAR2,
   shipment_id_                   IN NUMBER,
   move_comment_                  IN VARCHAR2,
   validate_hu_struct_position_   IN BOOLEAN DEFAULT TRUE,
   executing_transport_task_line_ IN BOOLEAN DEFAULT FALSE )
IS   
   dummy_char_                 VARCHAR2(2000);
   dummy_number_               NUMBER;
   reserved_stock_rec_         Inv_Part_In_Stock_Res_Rec;
   expiration_date_            DATE;
   local_order_no_             VARCHAR2(12);
   local_line_no_              VARCHAR2(4);
   local_release_no_           VARCHAR2(4);
   local_line_item_no_         NUMBER;
   local_demand_type_db_       VARCHAR2(4000);
BEGIN
   -- Note: We can get DO references when only calling from Inventory part in stock reservation client.
   IF (order_supply_demand_type_db_ NOT IN (Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO, 
                                            Order_Supply_Demand_Type_API.DB_CUST_ORDER,
                                            Order_Supply_Demand_Type_API.DB_DOP_DEMAND,
                                            Order_Supply_Demand_Type_API.DB_DOP_NETTED_DEMAND,
                                            Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES,
                                            Order_Supply_Demand_Type_API.DB_MATERIAL_REQ,
                                            Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER,
                                            Order_Supply_Demand_Type_API.DB_DISTRIBUTION_ORDER,
                                            Order_Supply_Demand_Type_API.DB_PROJ_MISC_DEMAND)) THEN
      Raise_Move_Res_Not_Allowed___(order_supply_demand_type_db_);
     
   END IF;
   
   $IF Component_Disord_SYS.INSTALLED $THEN
      IF order_supply_demand_type_db_ = Order_Supply_Demand_Type_API.DB_DISTRIBUTION_ORDER THEN 
         Distribution_Order_API.Get_Customer_Order_Info(local_order_no_, local_line_no_, local_release_no_, local_line_item_no_, order_no_);
         local_demand_type_db_ := Order_Supply_Demand_Type_API.DB_CUST_ORDER;
      END IF;
   $ELSE
      NULL;
   $END
   
   IF NOT (executing_transport_task_line_) THEN
      IF (Is_Booked_For_Transport( contract_                    => contract_,
                                   part_no_                     => part_no_,
                                   configuration_id_            => configuration_id_,
                                   location_no_                 => from_location_no_,
                                   lot_batch_no_                => lot_batch_no_,
                                   serial_no_                   => serial_no_,
                                   eng_chg_level_               => eng_chg_level_,
                                   waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                   activity_seq_                => activity_seq_,
                                   handling_unit_id_            => handling_unit_id_,      
                                   source_ref1_                 => nvl(local_order_no_, order_no_),
                                   source_ref2_                 => nvl(local_line_no_, line_no_),
                                   source_ref3_                 => nvl(local_release_no_, release_no_),
                                   source_ref4_                 => nvl(local_line_item_no_, line_item_no_),
                                   pick_list_no_                => pick_list_no_,
                                   shipment_id_                 => shipment_id_,   
                                   order_supply_demand_type_db_ => nvl(local_demand_type_db_, order_supply_demand_type_db_)) = 'TRUE') THEN
         Transport_Task_Line_API.Raise_Res_Is_On_Trans_Task;
      END IF;
   END IF;
      
   reserved_stock_rec_.order_no                    := nvl(local_order_no_, order_no_);
   reserved_stock_rec_.line_no                     := nvl(local_line_no_, line_no_);
   reserved_stock_rec_.release_no                  := nvl(local_release_no_, release_no_);
   reserved_stock_rec_.line_item_no                := nvl(local_line_item_no_, line_item_no_);
   reserved_stock_rec_.order_supply_demand_type_db := nvl(local_demand_type_db_, order_supply_demand_type_db_);
   reserved_stock_rec_.part_no                     := part_no_;
   reserved_stock_rec_.contract                    := contract_;
   reserved_stock_rec_.configuration_id            := configuration_id_;
   reserved_stock_rec_.location_no                 := from_location_no_;
   reserved_stock_rec_.lot_batch_no                := lot_batch_no_;
   reserved_stock_rec_.serial_no                   := serial_no_;
   reserved_stock_rec_.eng_chg_level               := eng_chg_level_;
   reserved_stock_rec_.waiv_dev_rej_no             := waiv_dev_rej_no_;
   reserved_stock_rec_.activity_seq                := activity_seq_;
   reserved_stock_rec_.handling_unit_id            := handling_unit_id_;
   reserved_stock_rec_.shipment_id                 := shipment_id_;
   reserved_stock_rec_.pick_list_no                := pick_list_no_;   
   reserved_stock_rec_.qty_picked                  := qty_picked_;
   reserved_stock_rec_.pick_list_printed_db        := pick_list_printed_db_;   
   reserved_stock_rec_.qty_reserved                := quantity_to_move_;
   reserved_stock_rec_.pick_by_choice_blocked      := Get_Pick_By_Choice_Blocked_Db(order_no_                    => nvl(local_order_no_, order_no_),
                                                                                    line_no_                     => nvl(local_line_no_, line_no_),
                                                                                    release_no_                  => nvl(local_release_no_, release_no_),
                                                                                    line_item_no_                => nvl(local_line_item_no_, line_item_no_),
                                                                                    order_supply_demand_type_db_ => nvl(local_demand_type_db_, order_supply_demand_type_db_),
                                                                                    contract_                    => contract_,
                                                                                    part_no_                     => part_no_,
                                                                                    configuration_id_            => configuration_id_,
                                                                                    location_no_                 => from_location_no_,
                                                                                    lot_batch_no_                => lot_batch_no_,
                                                                                    serial_no_                   => serial_no_,
                                                                                    eng_chg_level_               => eng_chg_level_,
                                                                                    waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                                    activity_seq_                => activity_seq_,
                                                                                    handling_unit_id_            => handling_unit_id_,
                                                                                    pick_list_no_                => pick_list_no_);
                                                                                      
   expiration_date_ := Inventory_Part_In_Stock_API.Get_Destinat_Expiration_Date(from_contract_    => contract_,
                                                                                   to_contract_      => contract_,
                                                                                   part_no_          => part_no_,
                                                                                   configuration_id_ => configuration_id_,
                                                                                   from_location_no_ => from_location_no_,
                                                                                   to_location_no_   => to_location_no_,
                                                                                   lot_batch_no_     => lot_batch_no_,
                                                                                   serial_no_        => serial_no_,
                                                                                   eng_chg_level_    => eng_chg_level_,
                                                                                   waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                   activity_seq_     => activity_seq_,
                                                                                   handling_unit_id_ => handling_unit_id_);

   Invent_Part_Quantity_Util_API.Move_Part(unattached_from_handling_unit_ => dummy_char_,
                                           catch_quantity_                => dummy_number_,
                                           contract_                      => contract_,
                                           part_no_                       => part_no_,
                                           configuration_id_              => configuration_id_,
                                           location_no_                   => from_location_no_,
                                           lot_batch_no_                  => lot_batch_no_,
                                           serial_no_                     => serial_no_,
                                           eng_chg_level_                 => eng_chg_level_,
                                           waiv_dev_rej_no_               => waiv_dev_rej_no_,
                                           activity_seq_                  => activity_seq_,
                                           handling_unit_id_              => handling_unit_id_,
                                           expiration_date_               => expiration_date_,
                                           to_contract_                   => contract_,
                                           to_location_no_                => to_location_no_,
                                           to_destination_                => Inventory_Part_Destination_API.Decode(Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY),
                                           quantity_                      => quantity_to_move_,
                                           quantity_reserved_             => 0,   
                                           move_comment_                  => move_comment_,
                                           order_no_                      => NULL,
                                           release_no_                    => NULL,
                                           sequence_no_                   => NULL,
                                           line_item_no_                  => NULL,
                                           order_type_                    => NULL,
                                           consume_consignment_stock_     => NULL,
                                           to_waiv_dev_rej_no_            => NULL,
                                           part_tracking_session_id_      => NULL,
                                           transport_task_id_             => NULL,
                                           validate_hu_struct_position_   => validate_hu_struct_position_,
                                           move_part_shipment_            => FALSE,
                                           reserved_stock_rec_            => reserved_stock_rec_);   
END Move_Reservation;
-------------------------------------------------------------------------------
-- Name: Get_Lot_Batch_Numbers
-- Purpose: Returns the concatanated lot batch numbers (ex. 'Lot1', 'Lot2', 'Lot3') 
--          for a reservation, to use in a IN operator of a SQL WHERE clause. 
-------------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_Lot_Batch_Numbers (
   source_ref1_     IN VARCHAR2,
   source_ref2_     IN VARCHAR2,
   source_ref3_     IN VARCHAR2,
   source_ref4_     IN VARCHAR2,
   source_ref_type_ IN VARCHAR2,
   part_no_         IN VARCHAR2) RETURN VARCHAR2
IS
   lot_batch_numbers_ VARCHAR2(32000); 

   CURSOR get_lot_batch_numbers IS
      SELECT DISTINCT lot_batch_no
        FROM INV_PART_STOCK_RESERVATION
       WHERE order_no                 = source_ref1_
         AND (line_no                 = source_ref2_ OR source_ref2_ IS NULL) 
         AND (release_no              = source_ref3_ OR source_ref3_ IS NULL)
         AND (line_item_no            = source_ref4_ OR source_ref4_ IS NULL)
         AND order_supply_demand_type = source_ref_type_
         AND part_no                  = part_no_;
BEGIN
   FOR rec_ IN get_lot_batch_numbers LOOP
      IF (lot_batch_numbers_ IS NULL) THEN
         lot_batch_numbers_ := rec_.lot_batch_no;
      ELSE
         lot_batch_numbers_ := lot_batch_numbers_ || ',' ||  rec_.lot_batch_no;
      END IF;
   END LOOP;
   
   RETURN (lot_batch_numbers_);
END Get_Lot_Batch_Numbers;

-- This method is used by DataCaptManIssSoHu, DataCaptManIssSoPart and DataCaptManIssueWo
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   release_no_                 IN VARCHAR2,
   line_item_no_               IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   location_no_                IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_   	       IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL)
IS
   TYPE Get_Lov_Values       IS REF CURSOR;
   get_lov_values_           Get_Lov_Values;
   stmt_                     VARCHAR2(2000);
   TYPE Lov_Value_Tab        IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_            Lov_Value_Tab;
   session_rec_              Data_Capture_Common_Util_API.Session_Rec;
   second_column_name_       VARCHAR2(200);
   second_column_value_      VARCHAR2(200);
   lov_item_description_     VARCHAR2(200);
   capture_process_id_       VARCHAR2(30);
   capture_config_id_        NUMBER;
   translation_res_          VARCHAR2(40):= Language_SYS.Translate_Constant(lu_name_, 'SHORTFORRESERVED: Res');
   translation_avail_        VARCHAR2(40):= Language_SYS.Translate_Constant(lu_name_, 'SHORTFORAVAILABLE: Avail');
   lov_desc_separator_       VARCHAR2(3) := ' | ';
   qty_available_            NUMBER;
   qty_reserved_             NUMBER;
   lov_row_limitation_       NUMBER;
   exit_lov_                 BOOLEAN := FALSE;
   temp_handling_unit_id_    NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_        := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
      Assert_SYS.Assert_Is_View_Column('Inv_Part_Stock_Reservation_Ext', column_name_);

      stmt_ := ' FROM  Inv_Part_Stock_Reservation_Ext
                 WHERE contract          = NVL(:contract_,         contract         )
                 AND   order_no          = NVL(:order_no_,         order_no         )
                 AND   line_no           = NVL(:line_no_,          line_no          )
                 AND   release_no        = NVL(:release_no_,       release_no       )
                 AND   line_item_no      = NVL(:line_item_no_,     line_item_no     )
                 AND   part_no           = NVL(:part_no_,          part_no          )
                 AND   configuration_id  = NVL(:configuration_id_, configuration_id )
                 AND   location_no       = NVL(:location_no_,      location_no      )
                 AND   lot_batch_no      = NVL(:lot_batch_no_,     lot_batch_no     )
                 AND   serial_no         = NVL(:serial_no_,        serial_no        )
                 AND   eng_chg_level     = NVL(:eng_chg_level_,    eng_chg_level    )
                 AND   waiv_dev_rej_no   = NVL(:waiv_dev_rej_no_,  waiv_dev_rej_no  )
                 AND   activity_seq      = NVL(:activity_seq_,     activity_seq     ) 
                 AND   handling_unit_id  = NVL(:handling_unit_id_, handling_unit_id ) 
                 AND   ((alt_handling_unit_label_id = :alt_handling_unit_label_id_) OR (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) OR (:alt_handling_unit_label_id_ = ''%''))
                 AND   EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site = contract) ';

      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;

      IF (lov_type_db_ = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK and can have the normal order since only 1 value will be picked anyway
         stmt_ := 'SELECT ' || column_name_ || stmt_ || ' ORDER BY  Utility_SYS.String_To_Number( ' || column_name_ || ' ) ASC, ' || column_name_ || ' ASC' ;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_ || stmt_ || ' ORDER BY  Utility_SYS.String_To_Number( ' || column_name_ || ' ) ASC, ' || column_name_ || ' ASC';
      END IF;
      @ApproveDynamicStatement(2014-11-03,CHJALK)
      OPEN get_lov_values_ FOR stmt_ USING contract_,
                                           order_no_,
                                           line_no_,
                                           release_no_,
                                           line_item_no_,
                                           part_no_,
                                           configuration_id_,
                                           location_no_,
                                           lot_batch_no_,
                                           serial_no_,
                                           eng_chg_level_,
                                           waiv_dev_rej_no_,
                                           activity_seq_,
                                           handling_unit_id_,
                                           alt_handling_unit_label_id_,
                                           alt_handling_unit_label_id_,
                                           alt_handling_unit_label_id_;
                                           
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         CASE (column_name_)
            WHEN ('LOCATION_NO') THEN
               second_column_name_ := 'LOCATION_INFO';
            WHEN ('HANDLING_UNIT_ID') THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
            WHEN ('SSCC') THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
            WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
            ELSE
               NULL;
            END CASE;
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK 
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'LOCATION_INFO') THEN
                     capture_process_id_ := Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_);
                     capture_config_id_  := Data_Capture_Session_API.Get_Capture_Config_Id(capture_session_id_);
                     IF (capture_process_id_ = 'MANUAL_ISSUE_SHOP_ORDER_PART') THEN
                        IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_, capture_config_id_, 'DISPLAY_LOCATION_DESCRIPTION'))) THEN
                           -- Show location description
                           second_column_value_ := Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
                        END IF;
                        IF (order_no_ IS NOT NULL AND line_no_ IS NOT NULL AND release_no_ IS NOT NULL AND 
                            line_item_no_ IS NOT NULL AND part_no_ IS NOT NULL AND configuration_id_ IS NOT NULL AND 
                            lot_batch_no_ IS NOT NULL AND serial_no_ IS NOT NULL AND eng_chg_level_ IS NOT NULL AND
                            waiv_dev_rej_no_ IS NOT NULL AND activity_seq_ IS NOT NULL AND handling_unit_id_ IS NOT NULL) THEN
                           qty_reserved_ := Get_Qty_Reserved(order_no_                    => order_no_,
                                                             line_no_                     => line_no_,
                                                             release_no_                  => release_no_,
                                                             line_item_no_                => line_item_no_,
                                                             pick_list_no_                => NULL,
                                                             shipment_id_                 => NULL,
                                                             order_supply_demand_type_db_ => Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO,
                                                             contract_                    => contract_,
                                                             part_no_                     => part_no_,
                                                             configuration_id_            => configuration_id_,
                                                             location_no_                 => lov_value_tab_(i),
                                                             lot_batch_no_                => lot_batch_no_,
                                                             serial_no_                   => serial_no_,
                                                             eng_chg_level_               => eng_chg_level_,
                                                             waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                             activity_seq_                => activity_seq_,
                                                             handling_unit_id_            => handling_unit_id_);
                        END IF;
                        
                        IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_, capture_config_id_, 'DISPLAY_QTY_RESERVED_HEADER'))) THEN
                           -- Add description separator
                           IF (second_column_value_ IS NOT NULL) THEN
                              second_column_value_ := second_column_value_  || lov_desc_separator_;
                           END IF;
                           -- Show desc AND value
                           second_column_value_ := second_column_value_ || translation_res_ || ': ' || Data_Capture_Common_Util_API.Get_Leading_Zero_For_Decimals(qty_reserved_);
                        ELSIF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_, capture_config_id_, 'DISPLAY_QTY_RESERVED'))) THEN
                           -- Add description separator
                           IF (second_column_value_ IS NOT NULL) THEN
                              second_column_value_ := second_column_value_  || lov_desc_separator_;
                           END IF;
                           -- Show only value
                           second_column_value_ := second_column_value_ || Data_Capture_Common_Util_API.Get_Leading_Zero_For_Decimals(qty_reserved_);
                        END IF;
                        qty_available_ := Inventory_Part_In_Stock_API.Get_Qty_Onhand(contract_           => contract_, 
                                                                                     part_no_            => part_no_, 
                                                                                     configuration_id_   => configuration_id_, 
                                                                                     location_no_        => lov_value_tab_(i), 
                                                                                     lot_batch_no_       => lot_batch_no_, 
                                                                                     serial_no_          => serial_no_, 
                                                                                     eng_chg_level_      => eng_chg_level_, 
                                                                                     waiv_dev_rej_no_    => waiv_dev_rej_no_, 
                                                                                     activity_seq_       => activity_seq_,
                                                                                     handling_unit_id_   => handling_unit_id_) - 
                                                Inventory_Part_In_Stock_API.Get_Qty_Reserved(contract_         => contract_, 
                                                                                             part_no_          => part_no_, 
                                                                                             configuration_id_ => configuration_id_, 
                                                                                             location_no_      => lov_value_tab_(i), 
                                                                                             lot_batch_no_     => lot_batch_no_, 
                                                                                             serial_no_        => serial_no_, 
                                                                                             eng_chg_level_    => eng_chg_level_, 
                                                                                             waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                                                                             activity_seq_     => activity_seq_,
                                                                                             handling_unit_id_ => handling_unit_id_); 
                        IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_, capture_config_id_, 'DISPLAY_QTY_AVAILABLE_HEADER'))) THEN
                           -- Add description separator
                           IF (second_column_value_ IS NOT NULL) THEN
                              second_column_value_ := second_column_value_  || lov_desc_separator_;
                           END IF;
                           -- Show desc AND value
                           second_column_value_ := second_column_value_ || translation_avail_ || ': ' || Data_Capture_Common_Util_API.Get_Leading_Zero_For_Decimals(qty_available_);
                        ELSIF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_, capture_config_id_, 'DISPLAY_QTY_AVAILABLE'))) THEN
                           -- Add description separator
                           IF (second_column_value_ IS NOT NULL) THEN
                              second_column_value_ := second_column_value_  || lov_desc_separator_;
                           END IF;
                           -- Show only value
                           second_column_value_ := second_column_value_ || Data_Capture_Common_Util_API.Get_Leading_Zero_For_Decimals(qty_available_);
                        END IF;
                     END IF;
                  ELSIF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESC') THEN
                     IF (column_name_ = 'HANDLING_UNIT_ID') THEN
                        temp_handling_unit_id_ := lov_value_tab_(i);
                     ELSIF (column_name_ = 'SSCC') THEN
                        temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                     ELSIF (column_name_ = 'ALT_HANDLING_UNIT_LABEL_ID') THEN
                        temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                     END IF;
                     second_column_value_ := Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(temp_handling_unit_id_));
                  END IF;
                  IF (second_column_value_ IS NOT NULL) THEN
                     lov_item_description_ := second_column_value_;
                     second_column_value_ := NULL;
                  ELSE
                    lov_item_description_ := NULL;
                  END IF;
               END IF;
            END IF;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;
   
   
-- This method is used by DataCaptManIssSoHu, DataCaptManIssSoPart and DataCaptManIssueWo
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_                   IN VARCHAR2,
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   release_no_                 IN VARCHAR2,
   line_item_no_               IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   location_no_                IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   column_description_         IN VARCHAR2,
   column_value_exist_check_   IN BOOLEAN  DEFAULT TRUE,    
   column_value_nullable_      IN BOOLEAN  DEFAULT FALSE )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(2000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN

   -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
   Assert_SYS.Assert_Is_View_Column('Inv_Part_Stock_Reservation_Ext', column_name_);

   stmt_ := ' SELECT 1
              FROM  Inv_Part_Stock_Reservation_Ext
              WHERE contract          = NVL(:contract_,         contract         )
              AND   order_no          = NVL(:order_no_,         order_no         )
              AND   line_no           = NVL(:line_no_,          line_no          )
              AND   release_no        = NVL(:release_no_,       release_no       )
              AND   line_item_no      = NVL(:line_item_no_,     line_item_no     )
              AND   part_no           = NVL(:part_no_,          part_no          )
              AND   configuration_id  = NVL(:configuration_id_, configuration_id )
              AND   location_no       = NVL(:location_no_,      location_no      )
              AND   lot_batch_no      = NVL(:lot_batch_no_,     lot_batch_no     )
              AND   serial_no         = NVL(:serial_no_,        serial_no        )
              AND   eng_chg_level     = NVL(:eng_chg_level_,    eng_chg_level    )
              AND   waiv_dev_rej_no   = NVL(:waiv_dev_rej_no_,  waiv_dev_rej_no  )
              AND   activity_seq      = NVL(:activity_seq_,     activity_seq     )  
              AND   handling_unit_id  = NVL(:handling_unit_id_, handling_unit_id )
              AND   ((alt_handling_unit_label_id = :alt_handling_unit_label_id_) OR (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) OR (:alt_handling_unit_label_id_ = ''%''))
              AND   EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site = contract) ';

   IF (column_value_exist_check_) THEN
      IF (column_value_nullable_) THEN
         stmt_ := stmt_ || ' AND NVL('|| column_name_ ||', :string_null_) = NVL(:column_value_, :string_null)';
      ELSE -- NOT column_value_nullable_
        stmt_ := stmt_ || ' AND ' || column_name_ ||'  = :column_value_ ';
      END IF;
   END IF;


   IF (NOT column_value_exist_check_) THEN
      -- No column value exist check, only check the rest of the keys
      @ApproveDynamicStatement(2015-05-12,DAZASE)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          order_no_,
                                          line_no_,
                                          release_no_,
                                          line_item_no_,
                                          part_no_,
                                          configuration_id_,
                                          location_no_,
                                          lot_batch_no_,
                                          serial_no_,
                                          eng_chg_level_,
                                          waiv_dev_rej_no_,
                                          activity_seq_,
                                          handling_unit_id_,
                                          alt_handling_unit_label_id_,
                                          alt_handling_unit_label_id_,
                                          alt_handling_unit_label_id_;
   ELSIF (column_value_nullable_) THEN
      -- Column value check on a nullable column
      @ApproveDynamicStatement(2015-11-17,DAZASE)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          order_no_,
                                          line_no_,
                                          release_no_,
                                          line_item_no_,
                                          part_no_,
                                          configuration_id_,
                                          location_no_,
                                          lot_batch_no_,
                                          serial_no_,
                                          eng_chg_level_,
                                          waiv_dev_rej_no_,
                                          activity_seq_,
                                          handling_unit_id_,
                                          alt_handling_unit_label_id_,
                                          alt_handling_unit_label_id_,
                                          alt_handling_unit_label_id_,
                                          string_null_,
                                          column_value_,
                                          string_null_;
   ELSE
      -- Column value check without any nullable handling
      @ApproveDynamicStatement(2015-02-25,RILASE)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          order_no_,
                                          line_no_,
                                          release_no_,
                                          line_item_no_,
                                          part_no_,
                                          configuration_id_,
                                          location_no_,
                                          lot_batch_no_,
                                          serial_no_,
                                          eng_chg_level_,
                                          waiv_dev_rej_no_,
                                          activity_seq_,
                                          handling_unit_id_,
                                          alt_handling_unit_label_id_,
                                          alt_handling_unit_label_id_,
                                          alt_handling_unit_label_id_,
                                          column_value_;
   END IF;
             
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
   END IF;
END Record_With_Column_Value_Exist;


-- This method is used by DataCaptManIssueWo
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   no_unique_value_found_      OUT BOOLEAN,
   contract_                   IN  VARCHAR2,
   order_no_                   IN  VARCHAR2,
   line_no_                    IN  VARCHAR2,
   release_no_                 IN  VARCHAR2,
   line_item_no_               IN  VARCHAR2,
   part_no_                    IN  VARCHAR2,
   configuration_id_           IN  VARCHAR2,
   location_no_                IN  VARCHAR2,
   lot_batch_no_               IN  VARCHAR2,
   serial_no_                  IN  VARCHAR2,
   eng_chg_level_              IN  VARCHAR2,
   waiv_dev_rej_no_            IN  VARCHAR2,
   activity_seq_               IN  NUMBER,
   handling_unit_id_           IN  NUMBER,
   alt_handling_unit_label_id_ IN  VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN  VARCHAR2 ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                          VARCHAR2(4000);
   column_value_                  VARCHAR2(50);
   unique_column_value_           VARCHAR2(50);
   too_many_values_found_         BOOLEAN := FALSE;
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('Inv_Part_Stock_Reservation_Ext', column_name_);

   stmt_ := ' SELECT ' || column_name_ || '
              FROM  Inv_Part_Stock_Reservation_Ext
              WHERE contract          = NVL(:contract_,         contract         )
              AND   order_no          = NVL(:order_no_,         order_no         )
              AND   line_no           = NVL(:line_no_,          line_no          )
              AND   release_no        = NVL(:release_no_,       release_no       )
              AND   line_item_no      = NVL(:line_item_no_,     line_item_no     )
              AND   part_no           = NVL(:part_no_,          part_no          )
              AND   configuration_id  = NVL(:configuration_id_, configuration_id )
              AND   location_no       = NVL(:location_no_,      location_no      )
              AND   lot_batch_no      = NVL(:lot_batch_no_,     lot_batch_no     )
              AND   serial_no         = NVL(:serial_no_,        serial_no        )
              AND   eng_chg_level     = NVL(:eng_chg_level_,    eng_chg_level    )
              AND   waiv_dev_rej_no   = NVL(:waiv_dev_rej_no_,  waiv_dev_rej_no  )
              AND   activity_seq      = NVL(:activity_seq_,     activity_seq     )
              AND   handling_unit_id  = NVL(:handling_unit_id_, handling_unit_id )
              AND   ((alt_handling_unit_label_id = :alt_handling_unit_label_id_) OR (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) OR (:alt_handling_unit_label_id_ = ''%''))
              AND   EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site = contract) ';

   @ApproveDynamicStatement(2015-05-18,DAZASE)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           order_no_,
                                           line_no_,
                                           release_no_,
                                           line_item_no_,
                                           part_no_,
                                           configuration_id_,
                                           location_no_,
                                           lot_batch_no_,
                                           serial_no_,
                                           eng_chg_level_,
                                           waiv_dev_rej_no_,
                                           activity_seq_,
                                           handling_unit_id_,
                                           alt_handling_unit_label_id_,
                                           alt_handling_unit_label_id_,
                                           alt_handling_unit_label_id_;
                                                       
   LOOP
      FETCH get_column_values_ INTO column_value_;
      EXIT WHEN get_column_values_%NOTFOUND;

      -- make sure NULL values are handled also
      IF (column_value_ IS NULL) THEN
         column_value_ := 'NULL';
      END IF;

      IF (unique_column_value_ IS NULL) THEN
         unique_column_value_ := column_value_;
      ELSIF (unique_column_value_ != column_value_) THEN
         too_many_values_found_ := TRUE; -- more then one unique value found
         unique_column_value_ := NULL;
         EXIT;
      END IF;
   END LOOP;
   CLOSE get_column_values_;

   -- If no values was found at all then set no_unique_value_found_ out-param to TRUE else set it to FALSE. 
   -- This to be able to see the why this method returned NULL so we can know if it was because no values 
   -- was found at all or if it was because to many values was found. This can be used in process utilities which
   -- fetch unique values from several data sources for a specific data item, so that utility can check if 
   -- there was a combined unique value from the data sources or not.
   IF (unique_column_value_ IS NULL AND NOT too_many_values_found_) THEN 
      no_unique_value_found_ := TRUE;
   ELSE
      no_unique_value_found_ := FALSE; -- either a unique value was found or too many values was found
   END IF;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;

@UncheckedAccess
FUNCTION Find_Reservations (
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   activity_seq_                IN NUMBER,
   handling_unit_id_            IN NUMBER,
   reserved_qty_to_move_        IN NUMBER,
   move_reservation_option_db_  IN VARCHAR2 ) RETURN Inv_Part_In_Stock_Res_Table
IS
   stock_reservation_info_tab_      Inv_Part_In_Stock_Res_Table;
   use_not_pick_listed_             VARCHAR2(5);
   use_not_on_printed_pick_list_    VARCHAR2(5);
   use_printed_pick_list_           VARCHAR2(5);

   CURSOR get_attr IS
      SELECT order_no, line_no, release_no, line_item_no, order_supply_demand_type_db, part_no, contract, configuration_id, location_no, 
             lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, shipment_id, pick_list_no, qty_picked, 
             pick_list_printed_db, qty_reserved, NULL, NULL, NULL, NULL, pick_by_choice_blocked_db
      FROM  inv_part_stock_res_move
      WHERE contract                 = contract_
      AND   part_no                  = part_no_
      AND   configuration_id         = configuration_id_
      AND   location_no              = location_no_
      AND   lot_batch_no             = lot_batch_no_
      AND   serial_no                = serial_no_
      AND   eng_chg_level            = eng_chg_level_
      AND   waiv_dev_rej_no          = waiv_dev_rej_no_
      AND   activity_seq             = activity_seq_
      AND   handling_unit_id         = handling_unit_id_                  
      AND CASE WHEN (NVL(pick_list_no, '*') = '*')  AND (use_not_pick_listed_ = 'TRUE')  THEN 1
               WHEN (pick_list_no != '*') AND (pick_list_printed_db = 'FALSE') AND (use_not_on_printed_pick_list_ = 'TRUE') THEN 1
               WHEN (pick_list_no != '*') AND (pick_list_printed_db = 'TRUE')  AND (use_printed_pick_list_ = 'TRUE') THEN 1
               ELSE 0
          END = 1
      AND NVL(qty_picked,0) = 0
      AND order_supply_demand_type_db IN (move_reserve_src_type_1_, move_reserve_src_type_2_, move_reserve_src_type_3_ , 
                                          move_reserve_src_type_4_, move_reserve_src_type_5_, move_reserve_src_type_6_ ,
                                          move_reserve_src_type_8_, move_reserve_src_type_9_)
      ORDER BY (CASE NVL(pick_list_no, '*')
                 WHEN '*' THEN
                     1
                 ELSE 
                    CASE pick_list_printed_db 
                       WHEN 'FALSE' then
                          2
                       ELSE 
                          3
                    END 
              END ) ASC, 
              (DECODE(TRUNC(qty_reserved/reserved_qty_to_move_), 0, TO_NUMBER(NULL), qty_reserved)) ASC NULLS LAST, qty_reserved DESC,
              date_required DESC;
BEGIN
   CASE move_reservation_option_db_
      WHEN Reservat_Adjustment_Option_API.DB_NOT_ALLOWED THEN
         use_not_pick_listed_ := 'FALSE';
         use_not_on_printed_pick_list_ := 'FALSE';
         use_printed_pick_list_ := 'FALSE';
      WHEN Reservat_Adjustment_Option_API.DB_NOT_PICK_LISTED THEN
         use_not_pick_listed_ := 'TRUE';
         use_not_on_printed_pick_list_ := 'FALSE';
         use_printed_pick_list_ := 'FALSE';
      WHEN Reservat_Adjustment_Option_API.DB_NOT_PRINTED_PICKLIST THEN
         use_not_pick_listed_ := 'TRUE';
         use_not_on_printed_pick_list_ := 'TRUE';
         use_printed_pick_list_ := 'FALSE';
      WHEN Reservat_Adjustment_Option_API.DB_ALLOWED THEN
         use_not_pick_listed_ := 'TRUE';
         use_not_on_printed_pick_list_ := 'TRUE';
         use_printed_pick_list_ := 'TRUE';            
   END CASE;   
   
   OPEN get_attr;
   FETCH get_attr BULK COLLECT INTO stock_reservation_info_tab_;
   CLOSE get_attr;
   RETURN stock_reservation_info_tab_;
END Find_Reservations;                              
  
                    
@UncheckedAccess
FUNCTION Get_Available_Qty_To_Move (
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   activity_seq_                IN NUMBER,
   handling_unit_id_            IN NUMBER,
   qty_on_hand_                 IN NUMBER,
   qty_reserved_                IN NUMBER ) RETURN NUMBER
IS
   move_reservation_option_db_  VARCHAR2(20);   
   not_pick_list_qty_           NUMBER;
   not_printed_pick_list_qty_   NUMBER;
   printed_pick_list_qty_       NUMBER;   
   available_qty_               NUMBER;
   picked_qty_                  NUMBER; 
           
   CURSOR get_quantities IS
      SELECT 
         SUM (CASE WHEN NVL(pick_list_no, '*') = '*' THEN qty_reserved END) AS not_pick_list_qty,      
         SUM (CASE WHEN pick_list_no != '*' AND pick_list_printed_db = 'FALSE' THEN qty_reserved END) AS not_printed_pick_list_qty,
         SUM (CASE WHEN pick_list_no != '*' AND pick_list_printed_db = 'TRUE'  THEN qty_reserved END) AS printed_pick_list_qty,
         SUM (qty_picked)                                                                             AS picked_qty
         FROM  inv_part_stock_res_move
         WHERE contract                 = contract_
         AND   part_no                  = part_no_
         AND   configuration_id         = configuration_id_
         AND   location_no              = location_no_
         AND   lot_batch_no             = lot_batch_no_
         AND   serial_no                = serial_no_
         AND   eng_chg_level            = eng_chg_level_
         AND   waiv_dev_rej_no          = waiv_dev_rej_no_
         AND   activity_seq             = activity_seq_
         AND   handling_unit_id         = handling_unit_id_
         AND   order_supply_demand_type_db IN ( move_reserve_src_type_1_, move_reserve_src_type_2_, move_reserve_src_type_3_ , 
                                                move_reserve_src_type_4_, move_reserve_src_type_5_, move_reserve_src_type_6_,
                                                move_reserve_src_type_8_, move_reserve_src_type_9_);
BEGIN
   IF (qty_reserved_ != 0) THEN
      move_reservation_option_db_ := Site_Invent_Info_API.Get_Move_Reservation_Option_Db(contract_);
      available_qty_ := NVL((qty_on_hand_ - qty_reserved_),0);
      IF (move_reservation_option_db_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN
         RETURN available_qty_;
      ELSE   
         OPEN get_quantities;
         FETCH get_quantities INTO not_pick_list_qty_, not_printed_pick_list_qty_, printed_pick_list_qty_, picked_qty_;
         CLOSE get_quantities;     

         CASE move_reservation_option_db_         
            WHEN Reservat_Adjustment_Option_API.DB_NOT_PICK_LISTED THEN
               RETURN (NVL(not_pick_list_qty_,0) + available_qty_);
            WHEN Reservat_Adjustment_Option_API.DB_NOT_PRINTED_PICKLIST THEN
               RETURN (NVL(not_pick_list_qty_,0) + NVL(not_printed_pick_list_qty_,0) + available_qty_);
            WHEN Reservat_Adjustment_Option_API.DB_ALLOWED THEN
               RETURN ((NVL(not_pick_list_qty_,0) + NVL(not_printed_pick_list_qty_,0) + NVL(printed_pick_list_qty_,0) + available_qty_) - NVL(picked_qty_,0));  
         END CASE;
      END IF;
   ELSE
      RETURN qty_on_hand_;
   END IF;
END Get_Available_Qty_To_Move;

FUNCTION Lock_And_Get_From_Source (
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   activity_seq_                IN NUMBER,
   handling_unit_id_            IN NUMBER,      
   order_ref1_                  IN VARCHAR2,
   order_ref2_                  IN VARCHAR2,
   order_ref3_                  IN VARCHAR2,
   order_ref4_                  IN NUMBER,
   pick_list_no_                IN VARCHAR2,
   shipment_id_                 IN NUMBER,   
   order_supply_demand_type_db_ IN VARCHAR2 ) RETURN Inv_Part_Stock_Reservation_API.Inv_Part_In_Stock_Res_Rec
IS
   $IF Component_Order_SYS.INSTALLED $THEN
      public_reservation_rec_   Reserve_Shipment_API.Public_Reservation_Rec;
      public_pick_list_rec_     Customer_Order_Pick_List_API.Public_Rec;      
   $END   
   reserved_stock_rec_       Inv_Part_In_Stock_Res_Rec;
   qty_picked_               NUMBER := 0;
   qty_assigned_             NUMBER := 0;
   print_flag_               VARCHAR2(20); 
   pick_list_printed_db_     VARCHAR2(5);
   local_pick_list_no_       NUMBER;
   
BEGIN   
	IF (order_supply_demand_type_db_ = Order_Supply_Demand_Type_API.DB_CUST_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN                
         Customer_Order_Reservation_API.Lock_And_Fetch_Info(public_reservation_rec_, order_ref1_, order_ref2_, order_ref3_, order_ref4_,
                                                            contract_, part_no_,
                                                            location_no_, lot_batch_no_, serial_no_,
                                                            eng_chg_level_, waiv_dev_rej_no_, activity_seq_,
                                                            handling_unit_id_, pick_list_no_, configuration_id_, shipment_id_  );                                                 
         qty_picked_    := public_reservation_rec_.qty_picked;
         qty_assigned_  := public_reservation_rec_.qty_assigned;         
      
         IF (pick_list_no_ != '*') THEN
            public_pick_list_rec_ := Customer_Order_Pick_List_API.Lock_By_Keys_And_Get(pick_list_no_);
            print_flag_ := CASE public_pick_list_rec_.printed_flag
                                WHEN Pick_List_Printed_API.DB_PRINTED THEN Fnd_Boolean_API.DB_TRUE
                                                                      ELSE Fnd_Boolean_API.DB_FALSE END;
         END IF;          
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   ELSIF (order_supply_demand_type_db_ = Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO) THEN
      $IF Component_Shpord_SYS.INSTALLED $THEN                
         Shop_Material_Assign_Util_API.Lock_Res_And_Fetch_Info(qty_assigned_, pick_list_printed_db_, 
                                                               order_ref1_, order_ref2_, order_ref3_, order_ref4_,
                                                               contract_, part_no_,
                                                               location_no_, lot_batch_no_, serial_no_,
                                                               eng_chg_level_, waiv_dev_rej_no_, configuration_id_,
                                                               activity_seq_, handling_unit_id_, pick_list_no_);
         print_flag_ := pick_list_printed_db_;
      $ELSE
         Error_SYS.Component_Not_Exist('SHPORD');
      $END
   ELSIF (order_supply_demand_type_db_ = Order_Supply_Demand_Type_API.DB_DOP_DEMAND) THEN
      $IF Component_Dop_SYS.INSTALLED $THEN                
         Dop_Invent_Assign_Internal_API.Lock_Res_And_Fetch_Info(qty_assigned_, contract_, part_no_,
                                                                location_no_, lot_batch_no_, serial_no_,
                                                                eng_chg_level_, waiv_dev_rej_no_, 
                                                                order_ref1_, order_ref2_, 
                                                                configuration_id_, activity_seq_, handling_unit_id_);
      $ELSE
         Error_SYS.Component_Not_Exist('DOP');
      $END
   ELSIF (order_supply_demand_type_db_ = Order_Supply_Demand_Type_API.DB_DOP_NETTED_DEMAND) THEN
      $IF Component_Dop_SYS.INSTALLED $THEN                
         Dop_Invent_Assign_External_API.Lock_Res_And_Fetch_Info(qty_assigned_, contract_, part_no_,
                                                                location_no_, lot_batch_no_, serial_no_,
                                                                eng_chg_level_, waiv_dev_rej_no_, 
                                                                order_ref1_, order_ref2_, 
                                                                configuration_id_, activity_seq_, handling_unit_id_);
      $ELSE
         Error_SYS.Component_Not_Exist('DOP');
      $END
   
   ELSIF (order_supply_demand_type_db_ = Order_Supply_Demand_Type_API.DB_WORK_TASK) THEN
      $IF Component_Wo_SYS.INSTALLED $THEN
         qty_assigned_ := Maint_Material_Allocation_API.Lock_And_Get_Qty_Assigned(source_ref1_      => order_ref2_,
                                                                                  source_ref2_      => order_ref3_,
                                                                                  contract_         => contract_,
                                                                                  part_no_          => part_no_,
                                                                                  configuration_id_ => configuration_id_,
                                                                                  location_no_      => location_no_,
                                                                                  lot_batch_no_     => lot_batch_no_,
                                                                                  serial_no_        => serial_no_,
                                                                                  eng_chg_level_    => eng_chg_level_,
                                                                                  waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                  activity_seq_     => activity_seq_,
                                                                                  handling_unit_id_ => handling_unit_id_ );
                                                          
      $ELSE
         Error_SYS.Component_Not_Exist('WO');
      $END
   ELSIF (order_supply_demand_type_db_ IN (Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES, 
                                           Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER)) THEN
      IF (pick_list_no_ = '*') THEN
         local_pick_list_no_ := 0;
      ELSE
         local_pick_list_no_ := TO_NUMBER(pick_list_no_);
      END IF;
      Inventory_Part_Reservation_API.Lock_Res_And_Fetch_Info(qty_assigned_,
                                                             contract_,
                                                             part_no_,
                                                             configuration_id_,
                                                             location_no_,
                                                             lot_batch_no_,
                                                             serial_no_,
                                                             eng_chg_level_,
                                                             waiv_dev_rej_no_,
                                                             activity_seq_,
                                                             handling_unit_id_,
                                                             order_supply_demand_type_db_,
                                                             order_ref1_,
                                                             NVL(order_ref2_, '*'),
                                                             NVL(order_ref3_, '*'),
                                                             NVL(TO_CHAR(order_ref4_), '*'),
                                                             local_pick_list_no_,
                                                             shipment_id_);
      IF (pick_list_no_ != '*') THEN
         print_flag_ := Inventory_Pick_List_API.Get_Printed_Db(pick_list_no_);
      END IF;                                                             
   ELSIF (order_supply_demand_type_db_ = Order_Supply_Demand_Type_API.DB_MATERIAL_REQ) THEN            
      Material_Requis_Reservat_API.Lock_Res_And_Fetch_Info( qty_assigned_ => qty_assigned_,
                                                            order_no_ => order_ref1_,
                                                            line_no_ => order_ref2_,
                                                            release_no_ => order_ref3_,
                                                            line_item_no_ => order_ref4_,
                                                            part_no_ => part_no_,
                                                            contract_ => contract_,
                                                            configuration_id_ => configuration_id_,
                                                            location_no_ => location_no_,
                                                            lot_batch_no_ => lot_batch_no_,
                                                            serial_no_ => serial_no_,
                                                            waiv_dev_rej_no_ => waiv_dev_rej_no_,
                                                            eng_chg_level_ => eng_chg_level_,
                                                            activity_seq_ => activity_seq_,
                                                            handling_unit_id_ => handling_unit_id_);
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOTSUPPORTED: The supply demand type :P1 is not supported ', Order_Supply_Demand_Type_API.Decode(order_supply_demand_type_db_));
   END IF;
   
   reserved_stock_rec_.order_no                 := order_ref1_;
   reserved_stock_rec_.line_no                  := order_ref2_;
   reserved_stock_rec_.release_no               := order_ref3_;
   reserved_stock_rec_.line_item_no             := order_ref4_;
   reserved_stock_rec_.order_supply_demand_type_db := order_supply_demand_type_db_;
   reserved_stock_rec_.part_no                  := part_no_;
   reserved_stock_rec_.contract                 := contract_;
   reserved_stock_rec_.configuration_id         := configuration_id_;
   reserved_stock_rec_.location_no              := location_no_;
   reserved_stock_rec_.lot_batch_no             := lot_batch_no_;
   reserved_stock_rec_.serial_no                := serial_no_;
   reserved_stock_rec_.eng_chg_level            := eng_chg_level_;
   reserved_stock_rec_.waiv_dev_rej_no          := waiv_dev_rej_no_;
   reserved_stock_rec_.activity_seq             := activity_seq_;
   reserved_stock_rec_.handling_unit_id         := handling_unit_id_;
   reserved_stock_rec_.shipment_id              := shipment_id_;
   reserved_stock_rec_.pick_list_no             := pick_list_no_;   
   reserved_stock_rec_.qty_picked               := qty_picked_;   
   reserved_stock_rec_.pick_list_printed_db     := print_flag_;      
   reserved_stock_rec_.qty_reserved             := qty_assigned_; 
	RETURN reserved_stock_rec_;
END Lock_And_Get_From_Source;


@UncheckedAccess
FUNCTION Get_Qty_Picked (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER 
IS
   qty_picked_       NUMBER;
   handling_unit_id_tab_   Handling_Unit_API.Handling_Unit_Id_Tab;
   CURSOR get_qty_picked(handling_unit_ NUMBER) IS
   SELECT SUM(NVL(qty_picked,0)), part_no
   FROM Inv_Part_Stock_Reserv_Qty_Pick 
   WHERE handling_unit_id = handling_unit_
   GROUP BY part_no;
   previous_part_no_ VARCHAR2(2000);
   part_no_ VARCHAR2(2000);
   total_qty_picked_  NUMBER := 0;
BEGIN
   handling_unit_id_tab_ := Handling_Unit_API.Get_Node_And_Descendants(handling_unit_id_); 
   IF handling_unit_id_tab_.Count > 0 THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         OPEN get_qty_picked(handling_unit_id_tab_(i).handling_unit_id);
         FETCH get_qty_picked  INTO qty_picked_, part_no_;
         CLOSE get_qty_picked;
         IF previous_part_no_ IS NOT NULL AND (previous_part_no_ != part_no_) THEN
            RAISE too_many_rows;
         END IF;
         IF qty_picked_ IS NOT NULL  THEN
            total_qty_picked_ := total_qty_picked_ + qty_picked_ ;
            previous_part_no_ := part_no_;
            qty_picked_ := 0;
            part_no_ := NULL;
         END IF;      
      END LOOP;
   END IF;
   RETURN total_qty_picked_;
EXCEPTION
   WHEN no_data_found OR too_many_rows THEN
      RETURN NULL;
END Get_Qty_Picked;

@UncheckedAccess
FUNCTION Get_Qty_Picked (
   order_no_                    IN VARCHAR2,
   line_no_                     IN VARCHAR2,
   release_no_                  IN VARCHAR2,
   line_item_no_                IN VARCHAR2,
   pick_list_no_                IN VARCHAR2,
   shipment_id_                 IN NUMBER,
   order_supply_demand_type_db_ IN VARCHAR2,
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   activity_seq_                IN NUMBER,
   handling_unit_id_            IN NUMBER ) RETURN NUMBER
IS
   qty_picked_ NUMBER := 0;
   
   CURSOR get_attr IS
      SELECT qty_picked
      FROM  inv_part_stock_res_move
      WHERE order_no                 = order_no_
      AND   line_no                  = line_no_
      AND   ((release_no IS NULL AND release_no_ IS NULL) OR (release_no = release_no_))
      AND   ((line_item_no IS NULL AND line_item_no_ IS NULL) OR (line_item_no = line_item_no_))
      AND   ((pick_list_no IS NULL AND pick_list_no_ IS NULL) OR (pick_list_no = pick_list_no_))
      AND   ((shipment_id IS NULL AND shipment_id_ IS NULL) OR (shipment_id = shipment_id_))
      AND   order_supply_demand_type = Order_Supply_Demand_Type_API.Decode(order_supply_demand_type_db_)
      AND   contract                 = contract_
      AND   part_no                  = part_no_
      AND   configuration_id         = configuration_id_
      AND   location_no              = location_no_
      AND   lot_batch_no             = lot_batch_no_
      AND   serial_no                = serial_no_
      AND   eng_chg_level            = eng_chg_level_
      AND   waiv_dev_rej_no          = waiv_dev_rej_no_
      AND   activity_seq             = activity_seq_
      AND   handling_unit_id         = handling_unit_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO qty_picked_;
   CLOSE get_attr;
   RETURN NVL(qty_picked_, 0);
END Get_Qty_Picked;

PROCEDURE Move_Hu_Res_Wth_Transp_Task (
   transport_task_id_            IN OUT NUMBER,
   contract_                     IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   configuration_id_             IN     VARCHAR2,
   from_location_no_             IN     VARCHAR2,
   lot_batch_no_                 IN     VARCHAR2,
   serial_no_                    IN     VARCHAR2,
   eng_chg_level_                IN     VARCHAR2,
   waiv_dev_rej_no_              IN     VARCHAR2,
   activity_seq_                 IN     NUMBER,
   handling_unit_id_             IN     NUMBER,
   to_location_no_               IN     VARCHAR2,
   quantity_to_move_             IN     NUMBER,
   check_storage_requirements_   IN     BOOLEAN  DEFAULT FALSE )   
IS
   
   CURSOR get_reservations IS
      SELECT part_no, configuration_id, contract, location_no, order_supply_demand_type, order_supply_demand_type_db, 
             order_no, line_no, release_no, line_item_no, pick_list_no, shipment_id,    
             lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, qty_reserved
      FROM  inv_part_stock_res_move
      WHERE contract                 = contract_
      AND   part_no                  = part_no_
      AND   configuration_id         = configuration_id_
      AND   location_no              = from_location_no_
      AND   lot_batch_no             = lot_batch_no_
      AND   serial_no                = serial_no_
      AND   eng_chg_level            = eng_chg_level_
      AND   waiv_dev_rej_no          = waiv_dev_rej_no_
      AND   activity_seq             = activity_seq_
      AND   handling_unit_id         = handling_unit_id_ ;

   TYPE Reservation_Tab IS TABLE OF get_reservations%ROWTYPE;
   reservation_tab_ Reservation_Tab;  

   total_moved_qty_    NUMBER := 0;
BEGIN    
   OPEN get_reservations;
   FETCH get_reservations BULK COLLECT INTO reservation_tab_;
   CLOSE get_reservations;

   IF (reservation_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      FOR i IN reservation_tab_.FIRST..reservation_tab_.LAST LOOP
         
         Move_Res_With_Transport_Task (
            transport_task_id_           => transport_task_id_,
            part_no_                     => reservation_tab_(i).part_no,
            configuration_id_            => reservation_tab_(i).configuration_id,
            contract_                    => reservation_tab_(i).contract,
            from_location_no_            => reservation_tab_(i).location_no,
            to_location_no_              => to_location_no_,
            order_supply_demand_type_db_ => reservation_tab_(i).order_supply_demand_type_db,
            order_no_                    => reservation_tab_(i).order_no,
            line_no_                     => reservation_tab_(i).line_no,
            release_no_                  => reservation_tab_(i).release_no,
            line_item_no_                => reservation_tab_(i).line_item_no,
            pick_list_no_                => reservation_tab_(i).pick_list_no,
            shipment_id_                 => reservation_tab_(i).shipment_id,
            lot_batch_no_                => reservation_tab_(i).lot_batch_no,
            serial_no_                   => reservation_tab_(i).serial_no,
            eng_chg_level_               => reservation_tab_(i).eng_chg_level,
            waiv_dev_rej_no_             => reservation_tab_(i).waiv_dev_rej_no,
            activity_seq_                => reservation_tab_(i).activity_seq,
            handling_unit_id_            => reservation_tab_(i).handling_unit_id,
            quantity_to_move_            => reservation_tab_(i).qty_reserved,
            check_storage_requirements_  => check_storage_requirements_);

         total_moved_qty_ := total_moved_qty_ + reservation_tab_(i).qty_reserved;
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;

      IF (total_moved_qty_ != quantity_to_move_) THEN
         Error_SYS.Record_General(lu_name_, 'NOTALLRESERVEDQTYMOVE: Inconsistent reservation quantity information in the database. Mismatch between InventoryPartInStock and InvPartStockReservation. Please contact system support', quantity_to_move_);    
      END IF;
   END IF;
END Move_Hu_Res_Wth_Transp_Task;


PROCEDURE Reserve_Stock ( 
   quantity_reserved_         OUT    NUMBER,
   input_qty_                 IN OUT NUMBER, 
   input_unit_meas_           IN OUT VARCHAR2, 
   input_conv_factor_         IN OUT NUMBER, 
   input_variable_values_     IN OUT VARCHAR2,   
   source_ref1_               IN     VARCHAR2,
   source_ref2_               IN     VARCHAR2,
   source_ref3_               IN     VARCHAR2,
   source_ref4_               IN     NUMBER,
   source_ref_type_db_        IN     VARCHAR2,
   contract_                  IN     VARCHAR2,
   part_no_                   IN     VARCHAR2,
   location_no_               IN     VARCHAR2,
   lot_batch_no_              IN     VARCHAR2,
   serial_no_                 IN     VARCHAR2,
   eng_chg_level_             IN     VARCHAR2,
   waiv_dev_rej_no_           IN     VARCHAR2,
   activity_seq_              IN     NUMBER,
   handling_unit_id_          IN     NUMBER,
   configuration_id_          IN     VARCHAR2,
   pick_list_no_              IN     VARCHAR2,
   shipment_id_               IN     NUMBER,
   quantity_to_reserve_       IN     NUMBER,
   reservation_operation_id_  IN     NUMBER,
   raise_exception_           IN     BOOLEAN  DEFAULT FALSE,
   pick_by_choice_blocked_    IN     VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS 
   reserve_manually_               BOOLEAN := FALSE;
   ignore_this_avail_control_id_   VARCHAR2(25);
   warehouse_id_                   VARCHAR2(15);
   $IF Component_Shpmnt_SYS.INSTALLED $THEN
   warehouse_info_                 Shipment_Source_Utility_API.Warehouse_Info_Rec;
   $END

BEGIN   
   IF (source_ref_type_db_ IN (Order_Supply_Demand_Type_API.DB_CUST_ORDER, Order_Supply_Demand_Type_API.DB_DISTRIBUTION_ORDER)) THEN           
      $IF Component_Order_SYS.INSTALLED $THEN
         reserve_manually_ := (reservation_operation_id_ = move_reservation_) OR (quantity_to_reserve_ < 0);
         Reserve_Customer_Order_API.Make_CO_Reservation(reserved_qty_             => quantity_reserved_,
                                                        input_qty_                => input_qty_, 
                                                        input_unit_meas_          => input_unit_meas_, 
                                                        input_conv_factor_        => input_conv_factor_, 
                                                        input_variable_values_    => input_variable_values_, 
                                                        order_no_                 => source_ref1_, 
                                                        line_no_                  => source_ref2_,
                                                        rel_no_                   => source_ref3_, 
                                                        line_item_no_             => source_ref4_, 
                                                        contract_                 => contract_, 
                                                        part_no_                  => part_no_, 
                                                        location_no_              => location_no_, 
                                                        lot_batch_no_             => lot_batch_no_, 
                                                        serial_no_                => serial_no_, 
                                                        eng_chg_level_            => eng_chg_level_, 
                                                        waiv_dev_rej_no_          => waiv_dev_rej_no_, 
                                                        activity_seq_             => activity_seq_,
                                                        handling_unit_id_         => handling_unit_id_,
                                                        configuration_id_         => configuration_id_,
                                                        pick_list_no_             => pick_list_no_,
                                                        shipment_id_              => shipment_id_,
                                                        qty_to_reserve_           => quantity_to_reserve_,
                                                        reserve_manually_         => reserve_manually_,
                                                        reservation_operation_id_ => reservation_operation_id_,
                                                        pick_by_choice_blocked_   => pick_by_choice_blocked_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END   
                                                        
   ELSIF (source_ref_type_db_ IN  (Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO)) THEN           
      $IF Component_Shpord_SYS.INSTALLED $THEN
         reserve_manually_ := (reservation_operation_id_ = move_reservation_) OR 
                              (location_no_ IS NOT NULL); 
         Shop_Material_Assign_Util_API.Reserve_Or_Unreserve_On_Swap(qty_reserved_           => quantity_reserved_,
                                                                    order_no_               => source_ref1_, 
                                                                    release_no_             => source_ref2_,
                                                                    sequence_no_            => source_ref3_, 
                                                                    line_item_no_           => source_ref4_, 
                                                                    contract_               => contract_, 
                                                                    part_no_                => part_no_, 
                                                                    location_no_            => location_no_, 
                                                                    lot_batch_no_           => lot_batch_no_, 
                                                                    serial_no_              => serial_no_, 
                                                                    eng_chg_level_          => eng_chg_level_, 
                                                                    waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                                    configuration_id_       => configuration_id_,
                                                                    activity_seq_           => activity_seq_,
                                                                    handling_unit_id_       => handling_unit_id_,
                                                                    pick_list_no_           => pick_list_no_,
                                                                    qty_to_reserve_         => quantity_to_reserve_,
                                                                    manual_reserve_         => reserve_manually_,
                                                                    pick_by_choice_blocked_ => pick_by_choice_blocked_);
      $ELSE
         Error_SYS.Component_Not_Exist('SHPORD');
      $END
   ELSIF (source_ref_type_db_ IN  (Order_Supply_Demand_Type_API.DB_DOP_DEMAND)) THEN           
      $IF Component_Dop_SYS.INSTALLED $THEN
         reserve_manually_ := (reservation_operation_id_ = move_reservation_) OR 
                              (location_no_ IS NOT NULL); 
         Dop_Invent_Assign_Internal_API.Reserve_Or_Unreserve_On_Swap(qty_reserved_           => quantity_reserved_,
                                                                     contract_               => contract_, 
                                                                     part_no_                => part_no_, 
                                                                     location_no_            => location_no_, 
                                                                     lot_batch_no_           => lot_batch_no_, 
                                                                     serial_no_              => serial_no_, 
                                                                     eng_chg_level_          => eng_chg_level_, 
                                                                     waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                                     dop_id_                 => source_ref1_, 
                                                                     dop_order_id_           => source_ref2_,
                                                                     configuration_id_       => configuration_id_,
                                                                     activity_seq_           => activity_seq_,
                                                                     handling_unit_id_       => handling_unit_id_,
                                                                     qty_to_reserve_         => quantity_to_reserve_,
                                                                     manual_reserve_         => reserve_manually_,
                                                                     pick_by_choice_blocked_ => pick_by_choice_blocked_);
      $ELSE
         Error_SYS.Component_Not_Exist('DOP');
      $END
   ELSIF (source_ref_type_db_ IN  (Order_Supply_Demand_Type_API.DB_DOP_NETTED_DEMAND)) THEN           
      $IF Component_Dop_SYS.INSTALLED $THEN
         reserve_manually_ := (reservation_operation_id_ = move_reservation_) OR 
                              (location_no_ IS NOT NULL); 
         Dop_Invent_Assign_External_API.Reserve_Or_Unreserve_On_Swap(qty_reserved_           => quantity_reserved_,
                                                                     contract_               => contract_, 
                                                                     part_no_                => part_no_, 
                                                                     location_no_            => location_no_, 
                                                                     lot_batch_no_           => lot_batch_no_, 
                                                                     serial_no_              => serial_no_, 
                                                                     eng_chg_level_          => eng_chg_level_, 
                                                                     waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                                     dop_id_                 => source_ref1_, 
                                                                     dop_order_id_           => source_ref2_,
                                                                     configuration_id_       => configuration_id_,
                                                                     activity_seq_           => activity_seq_,
                                                                     handling_unit_id_       => handling_unit_id_,
                                                                     qty_to_reserve_         => quantity_to_reserve_,
                                                                     manual_reserve_         => reserve_manually_,
                                                                     pick_by_choice_blocked_ => pick_by_choice_blocked_);
      $ELSE
         Error_SYS.Component_Not_Exist('DOP');
      $END   
   ELSIF (source_ref_type_db_ IN  (Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES,
                                   Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER)) THEN
      
      IF (source_ref_type_db_ = Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER) THEN
         $IF Component_Shpmnt_SYS.INSTALLED $THEN
            warehouse_info_               := Shipment_Source_Utility_API.Get_Warehouse_Info(shipment_id_, source_ref1_, source_ref_type_db_);
            warehouse_id_                 := warehouse_info_.warehouse_id;
            ignore_this_avail_control_id_ := warehouse_info_.availability_control_id;
         $ELSE
            Error_SYS.Component_Not_Exist('SHPMNT');
         $END
      END IF;
      
   -- Inventory_Part_Reservation_API.Reserve_Or_Unreserve_On_Swap is called when there is a Move Reservation as well as the unreservation in Pick By choice.  
   -- In Pick By Choice scenario, Quantity will be unreserved when we call Reserve_Stock___ and
   -- Unreserve_Stock___(Scenario where there is no available qty to pick and we need to take qty from a reserved stock) from Inventory_Picking_Manager_API.Pick_By_Choice. 
   -- All the reservations in Pick By Choice such as reserve available stock (unreserved stock) for current pick list line and 
   -- Find and reserve stock for source references that lost their reservation is handled by the else block as the reservation is behave like an automatic reservation.

      IF (reservation_operation_id_ = move_reservation_) OR (quantity_to_reserve_ < 0) THEN 
         Inventory_Part_Reservation_API.Reserve_Or_Unreserve_On_Swap(qty_reserved_                 => quantity_reserved_,
                                                                     contract_                     => contract_,
                                                                     part_no_                      => part_no_,
                                                                     configuration_id_             => configuration_id_,
                                                                     location_no_                  => location_no_,
                                                                     lot_batch_no_                 => lot_batch_no_,
                                                                     serial_no_                    => serial_no_,
                                                                     eng_chg_level_                => eng_chg_level_,
                                                                     waiv_dev_rej_no_              => waiv_dev_rej_no_,
                                                                     activity_seq_                 => activity_seq_,
                                                                     handling_unit_id_             => handling_unit_id_,
                                                                     quantity_                     => quantity_to_reserve_,
                                                                     source_ref_type_db_           => source_ref_type_db_,
                                                                     source_ref1_                  => source_ref1_,
                                                                     source_ref2_                  => source_ref2_,
                                                                     source_ref3_                  => source_ref3_,
                                                                     source_ref4_                  => source_ref4_,
                                                                     pick_list_no_                 => (CASE pick_list_no_ WHEN '*' THEN 0 ELSE pick_list_no_ END),
                                                                     shipment_id_                  => shipment_id_,
                                                                     ignore_this_avail_control_id_ => ignore_this_avail_control_id_);
                                                                  
      ELSE 
         $IF Component_Shpmnt_SYS.INSTALLED $THEN  
          Reserve_shipment_API.Reserve_Inventory(reserved_qty_            => quantity_reserved_,
                                                 source_ref1_             => source_ref1_,
                                                 source_ref2_             => source_ref2_,
                                                 source_ref3_             => source_ref3_,
                                                 source_ref4_             => source_ref4_,
                                                 source_ref_type_db_      => source_ref_type_db_,
                                                 shipment_id_             => shipment_id_,
                                                 contract_                => contract_,
                                                 inventory_part_no_       => part_no_, 
                                                 warehouse_id_            => warehouse_id_, 
                                                 availability_control_id_ => ignore_this_avail_control_id_, 
                                                 qty_to_reserve_          => quantity_to_reserve_,
                                                 location_no_             => location_no_,
                                                 lot_batch_no_            => lot_batch_no_,
                                                 serial_no_               => serial_no_,
                                                 eng_chg_level_           => eng_chg_level_,
                                                 waiv_dev_rej_no_         => waiv_dev_rej_no_,
                                                 handling_unit_id_        => handling_unit_id_,
                                                 pick_list_no_            => (CASE pick_list_no_ WHEN '*' THEN 0 ELSE pick_list_no_ END));
                
          quantity_reserved_ := quantity_to_reserve_;
         $ELSE   
            Error_SYS.Component_Not_Exist('SHPMNT');
         $END
      END IF;
   ELSIF (source_ref_type_db_ IN  (Order_Supply_Demand_Type_API.DB_MATERIAL_REQ)) THEN                                                                             
      Material_Requis_Reservat_API.Reserve_Or_Unreserve_On_Swap( qty_reserved_     => quantity_reserved_,
                                                                 order_no_         => source_ref1_,
                                                                 line_no_          => source_ref2_,
                                                                 release_no_       => source_ref3_,
                                                                 line_item_no_     => source_ref4_,
                                                                 part_no_          => part_no_,
                                                                 contract_         => contract_,                                                                 
                                                                 location_no_      => location_no_,
                                                                 lot_batch_no_     => lot_batch_no_,
                                                                 serial_no_        => serial_no_,
                                                                 waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                 eng_chg_level_    => eng_chg_level_,
                                                                 activity_seq_     => activity_seq_,
                                                                 handling_unit_id_ => handling_unit_id_,
                                                                 qty_to_reserve_   => quantity_to_reserve_);
   
   ELSIF (source_ref_type_db_ IN  (move_reserve_src_type_8_)) THEN         
      $IF (Component_Proj_SYS.INSTALLED) $THEN         
         Project_Reserved_Mat_Util_API.Make_Manual_Reservations(project_demand_type_ => Proj_Lu_Name_API.DB_PROJ_MISCELLANEOUS_DEMAND,
                                                                project_demand_key_  => source_ref4_,
                                                                part_no_             => part_no_,
                                                                contract_            => contract_,
                                                                location_no_         => location_no_,
                                                                lot_batch_no_        => lot_batch_no_,
                                                                serial_no_           => serial_no_,
                                                                waiv_dev_rej_no_     => waiv_dev_rej_no_,
                                                                eng_chg_level_       => eng_chg_level_,
                                                                activity_seq_        => activity_seq_,
                                                                handling_unit_id_    => handling_unit_id_,
                                                                quantity_            => quantity_to_reserve_,
                                                                configuration_id_	 => configuration_id_);                                                                           
         quantity_reserved_ := quantity_to_reserve_;                                                                                                                                        
      $ELSE   
         Error_SYS.Component_Not_Exist('PROJ');
      $END
   END IF;
EXCEPTION
   WHEN Error_SYS.Err_Component_Not_Exist THEN 
      RAISE;
   WHEN OTHERS THEN
      IF raise_exception_ THEN 
         RAISE;
      END IF;
END Reserve_Stock;
   
@UncheckedAccess
FUNCTION Mixed_Reservations_Exist (
   handling_unit_id_   IN NUMBER ) RETURN BOOLEAN
IS
   mixed_reserv_exist_         BOOLEAN := FALSE;
   handling_unit_id_tab_       Handling_Unit_API.Handling_Unit_Id_Tab;
   
   CURSOR get_reserv_ref IS
      SELECT DISTINCT order_no, line_no, release_no, line_item_no, order_supply_demand_type_db  
      FROM inv_part_stock_res_move
      WHERE handling_unit_id IN (SELECT handling_unit_id FROM TABLE(handling_unit_id_tab_))
      AND (qty_reserved != 0);
   
   TYPE Reserv_Rec IS RECORD (
      order_no                     inv_part_stock_reservation.order_no%TYPE,
      line_no                      inv_part_stock_reservation.line_no%TYPE,
      release_no                   inv_part_stock_reservation.release_no%TYPE,
      line_item_no                 inv_part_stock_reservation.release_no%TYPE,
      order_supply_demand_type_db  inv_part_stock_reservation.order_supply_demand_type_db%TYPE);

   TYPE Reservations_Tab IS TABLE OF Reserv_Rec INDEX BY PLS_INTEGER;
   reservations_tab_     Reservations_Tab;
BEGIN
   handling_unit_id_tab_ := Handling_Unit_API.Get_Node_And_Descendants(handling_unit_id_);
   
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      OPEN  get_reserv_ref;
      FETCH get_reserv_ref BULK COLLECT INTO reservations_tab_;
      CLOSE get_reserv_ref;
      
      IF (reservations_tab_.COUNT > 1) THEN
         mixed_reserv_exist_ := TRUE;
      END IF;   
   END IF;   
   RETURN mixed_reserv_exist_;
END Mixed_Reservations_Exist;



PROCEDURE Move_New_With_Transport_Task (
   stock_keys_and_qty_rec_      IN Inventory_Part_In_Stock_API.Keys_And_Qty_Rec,
   order_supply_demand_type_db_ IN VARCHAR2,
   order_no_                    IN VARCHAR2,
   line_no_                     IN VARCHAR2,
   release_no_                  IN VARCHAR2,
   line_item_no_                IN VARCHAR2,
   pick_list_no_                IN VARCHAR2 DEFAULT NULL,
   shipment_id_                 IN NUMBER   DEFAULT NULL )
IS
   transport_is_already_booked_ BOOLEAN;
   qty_reserved_                NUMBER;
   order_type_db_               VARCHAR2(20);
   transport_task_id_           NUMBER;
   exit_procedure_              EXCEPTION;
   to_location_type_db_         VARCHAR2(20);
BEGIN
   IF ((stock_keys_and_qty_rec_.transport_task_id IS NULL) OR (stock_keys_and_qty_rec_.to_location_no IS NULL)) THEN
      RAISE exit_procedure_;
   END IF;

   IF (order_supply_demand_type_db_ NOT IN (Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO,
                                            Order_Supply_Demand_Type_API.DB_DOP_DEMAND,
                                            Order_Supply_Demand_Type_API.DB_DOP_NETTED_DEMAND)) THEN
      to_location_type_db_ := Inventory_Location_API.Get_Location_Type_Db(stock_keys_and_qty_rec_.contract,
                                                                          stock_keys_and_qty_rec_.to_location_no);
      -- Only allow manufacturing type reservation sources to have their reservations moved to Floor Stock.
      IF (to_location_type_db_ != Inventory_Location_Type_API.DB_PICKING) THEN
         RAISE exit_procedure_;
      END IF;
   END IF; 

   order_type_db_               := Order_Supply_Demand_Type_API.Get_Order_Type_Db(order_supply_demand_type_db_);
   transport_is_already_booked_ :=Transport_Task_Line_API.Reservation_Booked_For_Transp(from_contract_    => stock_keys_and_qty_rec_.contract,
                                                                                        from_location_no_ => stock_keys_and_qty_rec_.location_no,
                                                                                        part_no_          => stock_keys_and_qty_rec_.part_no,
                                                                                        configuration_id_ => stock_keys_and_qty_rec_.configuration_id,
                                                                                        lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no,
                                                                                        serial_no_        => stock_keys_and_qty_rec_.serial_no,
                                                                                        eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level,
                                                                                        waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no,
                                                                                        activity_seq_     => stock_keys_and_qty_rec_.activity_seq,
                                                                                        handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id,
                                                                                        order_ref1_       => order_no_,     
                                                                                        order_ref2_       => line_no_,      
                                                                                        order_ref3_       => release_no_,   
                                                                                        order_ref4_       => line_item_no_, 
                                                                                        pick_list_no_     => pick_list_no_,
                                                                                        shipment_id_      => shipment_id_,
                                                                                        order_type_db_    => order_type_db_);
   IF NOT (transport_is_already_booked_) THEN
      qty_reserved_ := Get_Qty_Reserved(order_no_                    => order_no_,
                                        line_no_                     => line_no_,
                                        release_no_                  => release_no_,
                                        line_item_no_                => line_item_no_,
                                        pick_list_no_                => pick_list_no_,
                                        shipment_id_                 => shipment_id_,
                                        order_supply_demand_type_db_ => order_supply_demand_type_db_,
                                        contract_                    => stock_keys_and_qty_rec_.contract,                
                                        part_no_                     => stock_keys_and_qty_rec_.part_no,               
                                        configuration_id_            => stock_keys_and_qty_rec_.configuration_id,       
                                        location_no_                 => stock_keys_and_qty_rec_.location_no,            
                                        lot_batch_no_                => stock_keys_and_qty_rec_.lot_batch_no,           
                                        serial_no_                   => stock_keys_and_qty_rec_.serial_no,              
                                        eng_chg_level_               => stock_keys_and_qty_rec_.eng_chg_level,        
                                        waiv_dev_rej_no_             => stock_keys_and_qty_rec_.waiv_dev_rej_no,          
                                        activity_seq_                => stock_keys_and_qty_rec_.activity_seq,           
                                        handling_unit_id_            => stock_keys_and_qty_rec_.handling_unit_id);      
      IF (qty_reserved_ = stock_keys_and_qty_rec_.quantity) THEN
         -- This reservation was created now, there was nothing reserved from this stock location since before to this material requisition line. 
         -- So we can add the reservation to the transport task.
         transport_task_id_ := stock_keys_and_qty_rec_.transport_task_id;
         Move_Res_with_Transport_Task(transport_task_id_            => transport_task_id_,
                                      part_no_                      => stock_keys_and_qty_rec_.part_no,          
                                      configuration_id_             => stock_keys_and_qty_rec_.configuration_id, 
                                      contract_                     => stock_keys_and_qty_rec_.contract,    
                                      from_location_no_             => stock_keys_and_qty_rec_.location_no, 
                                      to_location_no_               => stock_keys_and_qty_rec_.to_location_no, 
                                      order_supply_demand_type_db_  => order_supply_demand_type_db_,
                                      order_no_                     => order_no_,       
                                      line_no_                      => line_no_,        
                                      release_no_                   => release_no_,     
                                      line_item_no_                 => line_item_no_,   
                                      pick_list_no_                 => pick_list_no_,
                                      shipment_id_                  => shipment_id_,
                                      lot_batch_no_                 => stock_keys_and_qty_rec_.lot_batch_no,     
                                      serial_no_                    => stock_keys_and_qty_rec_.serial_no,        
                                      eng_chg_level_                => stock_keys_and_qty_rec_.eng_chg_level,    
                                      waiv_dev_rej_no_              => stock_keys_and_qty_rec_.waiv_dev_rej_no,  
                                      activity_seq_                 => stock_keys_and_qty_rec_.activity_seq,     
                                      handling_unit_id_             => stock_keys_and_qty_rec_.handling_unit_id, 
                                      quantity_to_move_             => stock_keys_and_qty_rec_.quantity);
      END IF;
   END IF;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Move_New_With_Transport_Task;


@UncheckedAccess
FUNCTION Get_Pick_By_Choice_Blocked_Db (
   order_no_                    IN VARCHAR2,
   line_no_                     IN VARCHAR2,
   release_no_                  IN VARCHAR2,
   line_item_no_                IN VARCHAR2,   
   order_supply_demand_type_db_ IN VARCHAR2,
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   activity_seq_                IN NUMBER,
   handling_unit_id_            IN NUMBER,
   pick_list_no_                IN VARCHAR2 ) RETURN VARCHAR2
IS
   pick_by_choice_blocked_ VARCHAR2(5);

   CURSOR get_attr IS
      SELECT pick_by_choice_blocked_db
      FROM inv_part_stock_res_move
      WHERE order_no                    = order_no_
      AND   line_no                     = line_no_ 
      AND  (release_no                  = release_no_   OR release_no_ IS NULL)
      AND  (line_item_no                = line_item_no_ OR line_item_no_ IS NULL)
      AND  (pick_list_no                = pick_list_no_ OR pick_list_no_ IS NULL)
      AND   order_supply_demand_type_db = order_supply_demand_type_db_
      AND   contract                    = contract_
      AND   part_no                     = part_no_
      AND   configuration_id            = configuration_id_
      AND   location_no                 = location_no_
      AND   lot_batch_no                = lot_batch_no_
      AND   serial_no                   = serial_no_
      AND   eng_chg_level               = eng_chg_level_
      AND   waiv_dev_rej_no             = waiv_dev_rej_no_
      AND   activity_seq                = activity_seq_
      AND   handling_unit_id            = handling_unit_id_
      AND   qty_reserved - qty_picked   > 0;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO pick_by_choice_blocked_;
   CLOSE get_attr;
   
   RETURN NVL(pick_by_choice_blocked_, Fnd_Boolean_API.DB_FALSE);
END Get_Pick_By_Choice_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Pick_By_Choice_Blocked_Db (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2  
IS
   handling_unit_id_tab_   Handling_Unit_API.Handling_Unit_Id_Tab;
   CURSOR get_pick_by_choice_blocked(hu_id_ NUMBER) IS
      SELECT pick_by_choice_blocked_db
      FROM inv_part_stock_reservation ipsr
      WHERE ipsr.handling_unit_id = hu_id_
      AND   qty_reserved - qty_picked > 0;

   result_                     VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   handling_unit_id_tab_ := Handling_Unit_API.Get_Node_And_Descendants(handling_unit_id_); 
   IF handling_unit_id_tab_.Count > 0 THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         OPEN get_pick_by_choice_blocked(handling_unit_id_tab_(i).handling_unit_id);
         FETCH get_pick_by_choice_blocked  INTO result_;
         CLOSE get_pick_by_choice_blocked;
         IF result_ = Fnd_Boolean_API.DB_TRUE  THEN
            EXIT;
         END IF;      
      END LOOP;
   END IF;
   RETURN(result_);

END Get_Pick_By_Choice_Blocked_Db;

@UncheckedAccess
FUNCTION Is_Booked_For_Transport (
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   activity_seq_                IN NUMBER,
   handling_unit_id_            IN NUMBER,      
   source_ref1_                 IN VARCHAR2,
   source_ref2_                 IN VARCHAR2,
   source_ref3_                 IN VARCHAR2,
   source_ref4_                 IN NUMBER,
   pick_list_no_                IN VARCHAR2,
   shipment_id_                 IN NUMBER,   
   order_supply_demand_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   res_is_on_trans_task_        VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   local_source_ref1_           VARCHAR2(12);
   local_source_ref2_           VARCHAR2(4);
   local_source_ref3_           VARCHAR2(4);
   local_source_ref4_           NUMBER;
BEGIN
   IF (order_supply_demand_type_db_ IN (Order_Supply_Demand_Type_API.DB_CUST_ORDER, Order_Supply_Demand_Type_API.DB_DISTRIBUTION_ORDER)) THEN
      $IF Component_Disord_SYS.INSTALLED $THEN
         IF order_supply_demand_type_db_ = Order_Supply_Demand_Type_API.DB_DISTRIBUTION_ORDER THEN
            Distribution_Order_API.Get_Customer_Order_Info(order_no_     => local_source_ref1_, 
                                                           line_no_      => local_source_ref2_,
                                                           rel_no_       => local_source_ref3_,
                                                           line_item_no_ => local_source_ref4_,
                                                           do_order_no_  => source_ref1_);
         END IF;
      $ELSE
         NULL;
      $END
      
      $IF Component_Order_SYS.INSTALLED $THEN
         res_is_on_trans_task_ := Customer_Order_Reservation_API.Get_On_Transport_Task_Db(nvl(local_source_ref1_, source_ref1_),
                                                                                          nvl(local_source_ref2_, source_ref2_),
                                                                                          nvl(local_source_ref3_, source_ref3_),
                                                                                          nvl(local_source_ref4_, source_ref4_),
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
                                                                                          shipment_id_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   ELSE
      IF (Transport_Task_Line_API.Reservation_Booked_For_Transp(contract_,
                                                                location_no_,
                                                                part_no_,
                                                                configuration_id_,
                                                                lot_batch_no_,
                                                                serial_no_,
                                                                eng_chg_level_,
                                                                waiv_dev_rej_no_,
                                                                activity_seq_,
                                                                handling_unit_id_,
                                                                source_ref1_,
                                                                source_ref2_,
                                                                source_ref3_,
                                                                source_ref4_,
                                                                pick_list_no_,
                                                                shipment_id_,
                                                                Order_Supply_Demand_Type_API.Get_Order_Type_Db(order_supply_demand_type_db_))) THEN
         res_is_on_trans_task_ := Fnd_Boolean_API.DB_TRUE;                                                                
      END IF;
   END IF;

   RETURN res_is_on_trans_task_;
END Is_Booked_For_Transport;

