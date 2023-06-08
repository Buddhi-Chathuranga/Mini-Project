-----------------------------------------------------------------------------
--
--  Logical unit: PickCustomerOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211103  DaZase  Bug 161481 (SCZ-16645), Changes in Is_Fully_Picked to increase performance by removing old connect by prior cursor with a smaller cursor and hu collection loop instead.
--  210725  RoJalk  SC21R2-1374, Removed the unused method Remove_Remaining_Reserv__.
--  210722  RoJalk  SC21R2-1374, Modified Pick_Reservations__ so that ship_handling_unit_id_ will be included in the attr.
--  210711  RoJalk  SC21R2-1374, Added the parameter ship_handling_unit_id_ to the methods Pick_On_Location___, Pick_Reservations__,
--  210711          to support report picking on shipment handling unit level.
--  210615  ApWilk  Bug 159468 (SCZ-15133), Modified Print_Pick_List_Allowed() and Print_Pick_List() to compare the shipment id with the correct database column to enable the RMB and 
--  210615          display the next step of the shipment flow as well as to execute the print logic correctly.
--  201204  Dazase  Bug 156812 (SCZ-12645), Added lov description for shipment in Create_Data_Capture_Lov() for DataCaptReportPickPart.
--  201127  BudKlk  SC2020R1-11383, Modified Create_Data_Capture_Lov for report pick parts to chnage the order by clause in order to pick the HU not connected parts first.
--  201109  ErRalk  SC2020R1-11001, Added method Get_HU_Order_Reference_Info to fetch order reference info for Pick Handling Unit By Choice.
--  201108  RasDlk  SCZ-11837, Modified Report_Reserved_As_Picked__() by passing pick_list_no_ to the method call Line_Backorder_Check_Passed__() so that the  
--  201108          pick list created from the same iteration could be skipped.
--  201023  DaZase  Bug 156114 (SCZ-116479), Added extra sorting on outermost_handling_unit_id in Create_Data_Capture_Lov for lov_id_ 2.
--  200702  ApWilk  Bug 152962(SCZ-9550), Modified Report_Reserved_As_Picked__() to allow the RMB option Report Reserved Qtys as Picked when there is a 
--  200702          fully reserved package part with the back order option Incomplete packages not allowed.
--  200421  KiSalk  Bug 152194(SCZ-8758), In Report_Reserved_As_Picked__, generated HU snapshot for the newly created pick list before Pick Reporting, 
--  200421          calling Inventory_Event_Manager_API.Finish_Session and Start_Session to cater for different tracked parts in the reserved HU.
--  200317  DhAplk  Bug 152541 (SCZ-8879), Modified Report_Pick_List___() by adding report_picking_ as a parameter to identify Report Picking scenario.
--  200311  DaZase  SCXTEND-3803, Small change in all Create_Data_Capture_Lov to change 1 param in calls to Data_Capture_Session_Lov_API.New.
--  191213  KiSalk  Bug 151200(SCZ-7999), Modified the cursor report_picking of Pick_Report_Ship_Allowed, not to fetch data 
--  191213          when value of shipment_id_ is part of the single shipment in shipments_consolidated.
--  191023  SWiclk  Bug 150632 (SCZ-6808), Modified Create_Data_Capture_Lov(), Get_Column_Value_If_Unique() and Record_With_Column_Value_Exist() methods  
--  191023          in order to improve performance by avoiding NVL in Where statements.
--  190930  DaZase  SCSPRING20-147, Added Create_Picked_Constant___ to solve MessageDefinitionValidation issue.
--  190813  RoJalk  SCUXXW4-22995, Modified Pick_Reservations__  and moved the Pick_Remaining_Lines___ above close line validations 
--  190813          so the remaining lines without modification will be pick reported before the validation is executed.                
--  190508  WaSaLK  Bug 147471 (SCZ-4023), Modified location of method call Pick_Remaining_Lines___() to Pick remainning lines before clear unpick reservations.
--  180907  KiSalk  Bug 144063(SCZ-988), Modified Pick_Report_Ship_Allowed, improving performance of report_picking and opening get_pick_list_count for consolidated picklists.
--  180227  DaZase  STRSC-16924, Added Last_Hndl_Unit_Structure_On_PL().
--  180223  KHVESE  STRSC-15956, Modified method Pick_On_Location___.
--  180119  KHVESE  STRSC-8813, STRSC-15743 Modified method Pick_On_Location___.
--  180119  Nikplk  STRSC-15946, Removed Start_Pick_Report_Shipment__ and Overloaded method of Pick_Report_Shipment__(shipment_id_).
--  171213  MaAuse  STRSC-15088, Added parameter trigger_shipment_flow_ in Pick_Reservations_HU and Pick_Reservations_HU__.
--  171130  RoJalk  STRSC-9103, Added to the parameter trigger_shipment_flow_ to trigger the shipment flow from client.  
--  171128  RoJalk  STRSC-9103, Added shipment_id_message_ to the method Pick_Reservations__.
--  171116  DaZase  STRSC-8865, Added inv_barcode_validation_ parameter and handling of it in Record_With_Column_Value_Exist for DataCaptReportPickPart.
--  171106  RoJalk  STRSC-12406, Removed the obsolete method Is_Ship_Pick_Report_Allowed. 
--  171102  RaVdlk  STRSC-14011, Added Raise_No_Value_Exist_Error___ procedure for the message constant VALUENOTEXIST.
--  171102  RaVdlk  Modified Record_With_Column_Value_Exist message constant from VALUENOTEXIST to NOTINPICKLIST in order to avoid overriding of language translations and 
--                  added Raise_No_Picklist_Error___ procedure for the message constant NOTINPICKLIST. 
--  171024  SBalLK  Bug 138299, Reversed correction related to Bug 134750 and handle the issue in Customer_Order_Pick_List_APi.Set_Picking_Confirmed() method by fetching pick list connected contract.
--  170927  RaVdlk  STRSC-11152,Removed Customer_Order_API.Get_State__() and replaced with Customer_Order_API.Get_State ()
--  170927  RaVdlk  STRSC-11152, Removed Customer_Order_Line_API.Get_State__() and replaced with Customer_Order_Line_API.Get_State ()
--  170523  KHVESE  STRSC-8967, Modified Pick_Reservations__ to return -1 for all_reported_ only if partial picking is not allowed.
--  170529  Jhalse  STRSC-8362, Added an error message in Pick_On_Location___ for automatic picking with a shipment.
--  170526  RoJalk  STRSC-7311, Modified Report_Pick_List___ and added the parameters shipment_id_tab_, process_shipments_ .
--  170526          Added the method Get_Merged_Shipment_Id_Tab___. Modified Pick_Reservations__ and merged shipment id's from
--  170526          Pick_Remaining_Lines___ and then pocess all shipments at once.
--  170523  KHVESE  STRSC-8590, Added new method Has_Component_Part which currently only used in WADACO process.
--  170523  MaAuse  LIM-11433, Modified the call to Customer_Order_Reservation_API.Modify_Qty_Picked in Pick_On_Location___,
--  170523          added calculation of input_qty.
--  170517  Chfose  STRSC-8205, Modified Pick_Reservations_HU__ to handle a CLOB instead of an attr-string.
--  170511  RoJalk  STRSC-7921, Modified Report_Reserved_As_Picked__ and called Report_Pick_List___ only if pick list is created.
--  170509  KhVese  STRSC-8082, Modified methods Create_Data_Capture_Lov() in which string ' -' changed to '  -' when sorting based on route_order.
--  170503  Chfose  LIM-11458, Restructured Pick_Reservations_HU__ to support picking HUs within the same structure.
--  170426  NiAslk  STRSC-7369, Modified Report_Reserved_As_Picked__ to avoid Blocked customer order lines from being picked.
--  170424  RoJalk  STRSC-7311, Added the parameter trigger_shipment_flow_ to Pick_Remaining_Lines___ to stop the 
--                  triggering of shipment flow if Pick_Remaining_Lines___/Report_Pick_List___ is called from Pick_Reservations__. 
--  170323  Jhalse  LIM-10113, Modified how the shipment location is evaluated when picking. The latest picking location is now being saved in the header.
--  170323  KhVese  LIM-10485, Replaced parameter picking_handling_unit_ with two parameters validate_hu_struct_position_ and add_hu_to_shipment_ 
--  170323          in the interface of methods Pick_Reservations__ and Pick_On_Location___ and modified call to this methods in Report_Pick_List___  
--  170323          and Pick_Reservations_HU__ accordingly.
--  170322  RoJalk  LIM-9117, Modified Reserved_As_Picked_Allowed__ and moved the generic logic to Pick_Shipment_API.Reserved_As_Picked_Allowed.
--  170320  Cpeilk  Bug 132676, Modified Clear_Unpicked_Reservations to validate rental periods/qty exist before unreserving.
--  170317  Jhalse  LIM-10113, Changed on how picking to shipment inventory is done. If shipment inventory and no location is passed to the picking process, it will now try to fetch it from the pick list header. 
--  170317  Jhalse             Also added new methods for determining if a pick list needs to be confirmed or not.
--  170315  BudKlk  Bug 134304, Modified the method Pick_Remaining_Lines___() in order to complete report picking for the shipment.
--  170315  SBalLK  Bug 134750, Modified Pick_Reservations__() method to fetch contact from the pick list when report picking from the "Report Picking of Pick List Lines" window header
--  171315          since only pick list number pass to the database.
--  170313  Chfose  LIM-11152, Moved Generate_Handl_Unit_Snapshot to Pick_Shipment_API.
--  170307  Jhalse  LIM-10113, Fixed a bug from an earlier refactor in Report_Pick_List___, where the loop was not working as intended.
--  170223  DaZase  LIM-10906, Added Handl_Unit_Exist_On_Pick_List().
--  170220  DaZase  LIM-2931, Added Lines_Left_To_Pick().
--  170215  DaZase  LIM-2931, Changed Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist that used 
--  170215          Report_Pick_Handling_Unit to now use Report_Picking_Hu_Process for better performance.
--  170214  DaZase  LIM-10615, Rewrote Create_Data_Capture_Lov() with 2 params to use dynamic cursor instead and have sql_where_expression_ param.
--  170206  KHVESE  LIM-10240, Modified method Pick_Reservations_HU.
--  170202  DaZase  LIM-9714, Added overloaded methods Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist using Start_Picking_Process.
--  170131  DaZase  LIM-2931, Added overloaded methods Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist using Report_Pick_Handling_Unit.
--  170113  KHVESE  LIM-10241, Moved the methods Pick_Hu_By_Choice_Allowed and Pick_Hu_By_Choice to InventPickListManager untility and modified method Pick_Reservations.
--  170103  KHVESE  LIM-10136, Moved Method Pick_And_Adjust_Reservation from ReserveCustomerOrder LU to this LU and renamed to Pick_By_Choice.
--  170103          Modified method Pick_Reservations() to be more generic and added parameters qty_picked and supply_demand_type_ to the method interface.
--  161223  KHVESE  LIM-10128, Modified Method Pick_Hu_By_Choice to prevent commit to happen along the way before all reservation is done.
--  161219  MaEelk  LIM-10011, Modified Report_Reserved_As_Picked__. Removed the call to Pick_On_Location___ and added call to Report_Pick_List___ 
--  161219          at the end of Report_Reserved_As_Picked__. 
--  161215  Chfose  LIM-3663, Using new Shipment_Handling_Utility_API.Connect_Hus_From_Inventory in Pick_Reservations_HU__ and Report_Pick_List___.
--  161124  KHVESE  LIM-7777, Added Methods Pick_Hu_By_Choice_Allowed and Pick_Hu_By_Choice.
--  161117  KHVESE  LIM-5835, Added Methods Pick_By_Choice_Allowed.
--  161103  Chfose  LIM-9168, Added new default-parameter trigger_shipment_flow_ to Report_Pick_List___.
--  160928  Chfose  LIM-8612, Added call to Shipment_Handling_Utility_API.Add_Hu_To_Shipment in Pick_Reservations_HU when picking a full handling unit.
--  160926  TiRalk  Bug 130619, Modified Pick_Report_Ship_Allowed() and Get_Pick_Lists_For_Shipment() in order to allow Report picking of pick list lines
--  160926          when there are one or multiple pick lists created with single shipments.
--  160913  DaZase  LIM-8336, Added sscc_, alt_handling_unit_label_id_ to Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist.
--  160909  RoJalk  LIM-8191, Added the method Get_Default_Shipment_Location.
--  160907  RoJalk  LIM-8596, Modified Post_Scrap_Return_In_Ship_Inv and moved the logic related to
--  160907          calculating price conv factor to the method Shipment_Source_Utility_API.Recalc_Catch_Price_Conv_Factor.
--  160906  KhVese  LIM-5832, Added method Modify_Qty_Assigned__ . 
--  160905  RoJalk  LIM-8284, Removed the methods Return_From_Ship_Inv__, Move_Between_Ship_Inv__ since logic is moved to HandleShipInventUtility. 
--  160902  RoJalk  LIM-8204, Moved methods Raise_Not_Correct_Return_Loc, Raise_Not_A_Shipment_Location, Validate_Qty_To_Move
--  160902          Validate_Qty_To_Return,  Return_From_Ship_Inv__ to Handle_Ship_Invent_Utility_API.Modified Move_Between_Ship_Inv__,
--  160902          Return_From_Ship_Inv__ and redirected to methods in Handle_Ship_Invent_Utility_API.
--  160902  RoJalk  LIM-8204, Removed the method Scrap_Part_In_Ship_Inv__ since the logic is included in
--  160902          Handle_Ship_Invent_Utility_API.Scrap_Part_In_Ship_Inv__.
--  160831  RoJalk  LIM-8284, Renamed Post_Scrap_Part_In_Ship_Inv to Post_Scrap_Return_In_Ship_Inv.
--  160830  RoJalk  LIM-8189, Modified Pick_On_Location___ and replaced Move_To_Shipment_Location___ with 
--  160830          Handle_Ship_Invent_Utility_API.Move_To_Shipment_Location generic call. Removed Move_To_Shipment_Location.
--  160819  Chfose  LIM-7764, Added usage of outermost_hu_id  in Report_Pick_List___ in order to keep handling unit structures together when picking a full pick list.
--  160816  Chfose  LIM-8006, Modified calls to Shipment_Reserv_Handl_Unit_API in order to make use of new parameter reserv_handling_unit_id.
--  160802  RoJalk  LIM-8180, Added the method Validate_Return_From_Ship_Inv.
--  160801  RoJalk  LIM-8179, Added the method Post_Scrap_Part_In_Ship_Inv.
--  160726  RoJalk  LIM-8147, Added shipment_line_no_ to Shipment_Reserv_Handl_Unit_API.Get_Handling_Units method call.
--  160720  Chfose  LIM-7517, Added inventory_event_id throughout the file to let it flow through to and combine multiple 
--                            calls to Customer_Order_Reservation_API/Inventory_Part_In_Stock_API within a single inventory_event_id.
--  160714  Budklk  Bug 130213, Modified the method Remove_Remaining_Reserv__() to trigger the shipment process to allow the Optional Shipment Type Event 'Release Quantity not Reserved' to work correctly when checkbox "Allow Partial Picking into Shipment Inventory" is checked.
--  160608  MaIklk  LIM-7442, Fixed the usages of renaming Customer_Order_Deliv_Note to Delivery_Note.
--  160602  Chfose  LIM-7251, Used new parameter unattached_from_handling_unit in calls to Inventory_Part_In_Stock_API.Move_Part_Shipment in
--  160602          Move_To_Shipment_Location___, Return_From_Ship_Inv__ & Move_Between_Ship_Inv__.
--  160520  RoJalk  LIM-7478, Modified Move_To_Shipment_Location___ and included shipment_line_no_. 
--  160519  Chfose  STRSC-2446, Modified cursor get_order_info in Pick_Reservations_HU__ to correctly identify a reservation-record from InvPartInStock-keys.
--  160429  JeLise  LIM-7299, Added method Is_Fully_Picked.
--  160422  JeLise  LIM-6876, Added method Pick_Reservations_HU__.
--  160420  JanWse  STRSC-1785, Added TRUE to also check for blocked in a call to Scrapping_Cause_API.Exist
--  160329  JeLise  LIM-1322, Added method Generate_Handl_Unit_Snapshot.
--  160309  MaRalk  LIM-5871, Modified Report_Complete_Ship_Pkgs___ by using SHIPMENT_LINE_PUB and 
--  160309          to reflect shipment_line_tab-sourece_ref4 data type change.
--  160217  JeLise  LIM-6223, Added handling_unit_id in call to Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment in Move_To_Shipment_Location___.
--  160216  MaIklk  LIM-4141, Added Print_Pick_List().
--  160211  RoJalk  LIM-4704, Moved Get_No_Of_Packages_Picked to ShipmentOrderUtility.  
--  160210  MaIklk  LIM-6229, Changed Pick_Report_Ship_Allowed() to keep only order specific code.
--  150201  MaIklk  LIM-4153, Added Get_Pick_Lists_For_Shipment().
--  150201  MaIklk  LIM-4154, Added Print_Pick_List_Allowed().
--  160201  RasDlk  Bug 126224, Modified Report_Reserved_As_Picked__ to stop the order line being processed if license are not connected and
--  160201          modified Check_All_License_Connected to set variables according to the authority level and license connection to be used in client.
--  160128  MaIklk  LIM-4152, Added Pick_Report_Ship_Allowed().
--  160128  RoJalk  LIM-5911, Replaced Shipment_Line_API.Get_Qty_Picked with Shipment_Line_API.Get_Qty_Picked_By_Source.
--  151215  RoJalk  LIM-5387, Added source ref type to Shipment_Line_API.Modify_Qty_Picked_Qty_Line method.
--  151202  RoJalk  LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202          SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151117  JeLise  LIM-4457, Removed pallet_id in calls to Shipment_Reserv_Handl_Unit_API.
--  151111  JeLise  LIM-4456, Removed pallet_id in calls to Temporary_Pick_Reservation_API.Create_New__ in Pick_Reservations__.
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151106  MaEelk  LIM-4453, Removed Pallet Handling logic from the business logic.
--  151105  UdGnlk  LIM-3746, Removed Inventory_Part_Loc_Pallet_API method calls since INVENTORY_PART_LOC_PALLET_TAB will be obsolete. 
--  151103  IsSalk  FINHR-316, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Line.
--  151019  JeLise  LIM-3893, Removed pallet related location types in Return_From_Ship_Inv__.
--  151008  Chfose  LIM-3771, Added handling_unit_id to Code_Picked_Locations_Single__ and replaced hardcoded 0 in Check_Start_Warehouse_Task.
--  150708  RiLase  COB-396, Extracted validations and error messages to methods Raise_Not_Correct_Return_Loc, Raise_Not_A_Shipment_Location, Validate_Qty_To_Move, Validate_Qty_To_Return.
--  150608  RiLase  COB-424, updated the consume logic for unique line id in Create_Data_Capture_Lov.
--  150601  RiLase  COB-501: Added specific order by for shipment id in Create_Data_Capture_Lov.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150520  DaZase  COB-437, Removed 100 record description limitation in method Create_Data_Capture_Lov, 
--  150520          this will be replaced with a new configurable LOV record limitation in WADACO framework.
--  150401  JeLise  COL-250, Added move_to_ship_location_ in call to Customer_Order_Reservation_API.Modify_Qty_Picked in Move_To_Shipment_Location___.
--  150331  JeLise  COL-195, Added check on from_header_ when setting keep_remaining_qty_ in Pick_Reservations__.
--  150325  JeLise  COL-173, Added in parameter keep_remaining_qty_ to Pick_On_Location___ and Split_Serials___. Also added keep_remaining_qty_ in Pick_Reservations__ 
--  150325          and new parameter in call to Customer_Order_Reservation_API.Modify_Qty_Picked in Move_To_Shipment_Location___ and Pick_On_Location___.
--  150817  RasDlk  Bug 120649, Modified Check_All_License_Connected to fetch the licensed_order_type_ correctly.
--  150729  BudKlk  Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729          method call in ORDER BY clause to sort string and number values seperately.
--  150615  KiSalk  Bug 123112, Made order history creation of the picked lines using temporary_pick_reservation_tab records without adding values to an attribute string.
--  150520  MaEelk  LIM-2557, Replaced the value 0 with relevant handling_unit_id's
--  150423  UdGnlk  LIM-172, Added handling_unit_id as new key column to Temporary_Pick_Reservation_Tab therefore did necessary changes.  
--  150423  Chfose  LIM-1781, Fixed calls to Customer_Order_Reservation_API by including new parameter handling_unit_id
--  150416  MaEelk  LIM-1070, Added dummy parameter handling_unit_id_ 0 to the Inventory_Part_In_Stock_API method calls.
--  150407  MaEelk  LIM-1070, Added dummy parameter handling_unit_id_ 0 to the method call Inventory_Part_In_Stock_API.Get_Expiration_Date and Inventory_Part_In_Stock_API.Get. 
--  150407          handling_unit_id_ will be implemented as a key in InventoryPartInstock LU.
--  150102  MAHPLK  PRSC-401, Added new overloaded method Get_No_Of_Packages_Picked.
--  141118  RoJalk  PRSC-388, Modified Move_To_Shipment_Location___ to pass the parameter move_to_ship_location_. 
--  141010  JeLise  Added method Get_First_Location_No to be used from Warehouse Task.
--  141009  MeAblk  Added new method Pick_Report_From_Wharehouse to pick report pick list from warehouse task manager window.
--  140908  ShVese  Removed unused cursor get_reservations from Pick_Reservations__.
--  140814  DaZase  PRSC-1611, Added extra column checks in methods Get_Column_Value_If_Unique, Create_Data_Capture_Lov and Record_With_Column_Value_Exist to avoid any risk of getting sql injection problems.
--  140813  RoJalk  Added missing assert safe anotation for Create_Data_Capture_Lov, Get_Column_Value_If_Unique, Record_With_Column_Value_Exist. 
--  140811  DaZase  PRSC-1611 Renamed Check_Valid_Value to Record_With_Column_Value_Exist.
--  140619  DaZase  PRSC-1207, Changed Create_Data_Capture_Lov so it now only uses ORDER BY ASC.
--  140616  HimRlk  Modified Move_To_Shipment_Location___ to invalidate all old delivery notes.
--  140519  DaZase  PBSC-9203, Added methods Create_Data_Capture_Lov, Remove_Duplicate_Lov_Values___, Get_Column_Value_If_Unique and Check_Valid_Value. Added Lov_Value_Tab in private declarations.
--  140425  RoJalk  Modified Remove_Remaining_Reserv__ and used the rec_.shipment_id instead of shipment_id_.
--  140326  DaZase  Added route order sorting on the dynamic cursor in method Create_Data_Capture_Lov, removed distinct in that cursor and added new method Remove_Duplicate_Lov_Values___ 
--  140326          for doing the distinct selection server side instead. Added Lov_Value_Tab in private declarations.
--  140321  RoJalk  Corrected code indentation issues after Merge - Pearl. Modified the error text and conditions for FULLCATCHPICK error message.
--  140320  DaZase  Added shipment_id_ to methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Check_Valid_Value. Fixed some merge issues in Create_Data_Capture_Lov. 
--  140320          Added extra pick_list_no != ''*'' where statement to cursor in these methods.
--  140226  ChBnlk  Bug 113704, Modified Report_Reserved_As_Picked__() by adding an error message to be displayed when trying to create a pick list 
--  140226          with different configurations.
--  140218  BudKlk  Bug 115520, Modified the Pick_Reservations__() method by introducing a cursor to filter the over picked records from the customer_order_reservation_tab, 
--  140218          in order to add them to the Temporary_Pick_Reservation_Tab and  assigned the overpicked_lines_ variable to TRUE.
--  140206  FAndSE  BI-3415: Modified Get_No_Of_Packages_Picked and Report_Ship_Pkg_If_Complete___, used a mixture of quantities in Inventory UoM and Sales UoM, conversion added.
--  131107  DaZase  Bug 113523, Changes in Create_Data_Capture_Lov removed old filtering of UNIQUE_LINE_ID data item added extra cursor where-statement for UNIQUE_LINE_ID if in a loop to do the filtering instead, changed size of stmt_ to 4000.
--  131016  DaZase  Bug 113172, removed distinct from the cursor in method Get_Column_Value_If_Unique and renamed some variables and changed an ELSE statement to ELSIF. Several performance changes in method Create_Data_Capture_Lov.
--  131007  MaMalk  Modified Pick_Report_Shipment__ to exclude the check Shipment_Flow_API.Pick_Report_Shipment_Allowed__ since that is checked always before this gets executed.
--  131007          This is done since the checking of picking allowed is done differently for automatic shipment processing and finalizing shipment.
--  131128  AwWelk  PBSC-4130, Replaced the calls to Inventory_Part_In_Stock_API.Get_Catch_Qty_Onhand with Inventory_Part_In_Stock_API.Get_Sum_Catch_Qty_Onhand.
--  131021  RoJalk  Corrected code indentation issues after merge. Passed shipment id to the method Pick_On_Location___ called from Pick_Reservations__. 
--  130904  MaMalk  Added trigger_shipment_flow_ parameter to Pick_Reservations__  and modified Pick_Picklist_With_Diff__ to prevent the shipment flow getting executed several times.
--  130829  JeLise  Added calls to Shipment_Reserv_Handl_Unit_API to handle these lines when we do Move_To_Shipment_Location___.
--  130822  MAHPLK  Modified Report_Consol_Pick_List__ and Pick_Picklist_With_Diff__ methods to prevent the execution of the 'Order flow' 
--  130822          when the same Customer Order has connected to the shipment.
--  130812  JeLise  Changed the cursor and removed the fetch of revised_qty_due_ and total_qty_picked_ in Get_No_Of_Packages_Picked. Also changed
--  130812          the cursor and removed the fetch of pkg_revised_qty_due_ in Report_Ship_Pkg_If_Complete___.
--  130731  MaEelk  Shipment Package Structure related message from Pick_Pick_Lists__.
--  130628  MAHPLK  Removed parameter update_pick_lists_ from Pick_Reservations__ and Pick_Report_Shipment__..
--  130617  RoJalk  Modified Report_Reserved_As_Picked__, Reserved_As_Picked_Allowed__ and passed the shipment_id_, incl_ship_connected_
--  130617          as parameters to allow the functionality from Manual Reservation window when shipment id is specified.
--  130613  RoJalk  Added the parameter info_ to the methods Return_From_Ship_Inv__, Move_Between_Ship_Inv__, Scrap_Part_In_Ship_Inv__ and modified to support info handling.
--  130613  ErFelk  Bug 110286, Modified Report_Reserved_As_Picked__() by passing location group to Create_Pick_List_API.Line_Backorder_Check_Passed__().
--  130530  KiSalk  Bug 108220, Modified Pick_Reservations__ to store data sent with attr_ in Temporary_Pick_Reservation_tab and process them later.
--  130530          Added method Pick_List_Part_Reported___. Added history record for partial picks. Removed method Pick_Pick_Lists__ and Pick_Picklist_Diff
--  130530          as they are no longer in use. Removed Pick_Picklist_With_Diff__ and moved part of its code to new method Pick_Remaining_Lines___. 
--  130530          Added Pick_Resevations_From_Header__ to handle priviledges to users modifying the picking quantity.
--  130502  RoJalk  Removed the method call Report_Complete_Ship_Pkgs___ from Remove_Remaining_Reserv__ since shipment line will be updated earlier in the picking flow. 
--  130424  MaMalk  Modified Reserved_As_Picked_Allowed__ to combine 2 shipment creation methods exist for pick list creation to 1.
--  130418  MaRalk  Replaced view CUSTOMER_INFO_PUBLIC with CUSTOMER_INFO_CUSTCATEGORY_PUB in CUST_ORD_PICK_LIST_JOIN view definition.
--  130410  MAHPLK  Added shipment_id_ as parameter to Add_Line_To_Attr___. Modified Pick_Reservations__, Pick_Picklist_With_Diff__, 
--  130410          Remove_Remaining_Reserv__, Report_Consol_Pick_List__ and Is_Ship_Pick_Report_Allowed to implement consolidate several shipments pre pick list.
--  130405  MAHPLK  Added shipments_consolidated to PRINT_PICK_LIST_JOIN view.
--  130226  CHRALK  Modified methods Pick_On_Location___() and Return_From_Ship_Inv__(), by adding rental quantity validation.
--  130214  RiLase  Added Check_Valid_Value.
--  130131  RoJalk  Improved the error text for SEVERALPICKLISTS.
--  130122  RoJalk  Added the parameter report_pick_from_co_lines_ to the methods Is_Pick_Report_Allowed/Is_Ship_Pick_Report_Allowed
--  130122          to identfy destination form as frmPickReportDiff when used in RMB enbling logic in shipment.
--  130124  RiLase  Added unique_line_id_ as an in parameter in Create_Data_Capture_Lov and Get_Column_Value_If_Unique.
--  120121  MaMalk  Modified Pick_Reservations__, Pick_Picklist_With_Diff__ and Report_Consol_Pick_List__ to replace the code by calling Shipment_Flow_API.Start_Shipment_Flow
--  120121          to trigger the shipment flow.
--  130108  RoJalk  Modified Report_Consol_Pick_List__, Pick_Report_Shipment__ and called Report_Complete_Ship_Pkgs___.
--  130104  RoJalk  Added methods Report_Complete_Ship_Pkgs___, Report_Ship_Pkg_If_Complete___ and called from Pick_Report_Shipment__ to update qty picked for pkg header 
--  130104          lines in shipment. Passed shipment id to the method Get_No_Of_Packages_Picked.  
--  121211  RoJalk  Modified Split_Serials___  and passed shipment_id_ to the method call Customer_Order_Reservation_API.Split_Reservation_Into_Serials.
--  121210  MaMalk  Made Is_Ship_Pick_Report_Allowed__ public.
--  121109  RoJalk  Modified Code_Picked_Locations_Single__, Code_Picked_Locations_Pallet__ and added the condition shipment_id = 0 considering current usage is only when not shipment connected.
--  121107  RoJalk  Removed usused method Pallets_Reserved_On_Line__.
--  121106  RoJalk  Modified Pick_Picklist_With_Diff__, Report_Consol_Pick_List__ and added NVL to assign 0 for shipment id when passing to Customer_Order_Reservation_API method interfaces.
--  121102  RoJalk  Allow connecting a customer order line to several shipment lines - added shipment id as a parameter to the methods
--  121102          Return_From_Ship_Inv__ , Move_Between_Ship_Inv__  Scrap_Part_In_Ship_Inv__  Clear_Unpicked_Reservations.Move_To_Shipment_Location___, Report_Pick_List___,
--  121102          Pick_On_Location___, Split_Serials___  Removed the view SHIPMENT_LINE_PICK_JOIN. Modified calls for Customer_Order_Reservation_API to include shipment id.   
--  121030  MaMalk  Modified method Reserved_As_Picked_Allowed__ to exclude shipment connected lines to pick report the reserved quantity directly.
--  121019  MAHPLK  REmoved unused variables shipment_id_, ship_default_location_no_ from Report_Picking__.
--  121016  JeLise  Added Check_Valid_Xxx methods.
--  121010  JeLise  Added Create_Data_Capture_Lov, Get_Column_Value_If_Unique.
--  130124  Erlise  Bug 107414, In method Report_Reserved_As_Picked__, removed call to Check_All_License_Connected___, removed method Check_All_License_Connected___.
--                  The export control check is done in the client instead. Added method Check_All_License_Connected.
--  121011  JeLise  Added method Create_Data_Capture_Lov.
--  121011  MAHPLK  Bug 103530, Modified Report_Pick_List___ to handle different orders per pick list when order_no_ is NULL and stopped it is being called
--  121011          in loop for different order numbers. Re-written Pick_Reservations__ to process attribute string in Inventory_Part_In_Stock key order.
--  120924  MAHPLK  Modified Pick_Picklist_With_Diff__, Pick_Reservations__ and Report_Consol_Pick_List__ to trigger the shipment process.
--  120921  MeAblk  Modified the error message SHIPLOCATIONNULL.
--  120828  MeAblk  Added parameter update_pick_list_ into the method Pick_Reservations__.Modified methods Pick_Reservations__, Pick_Picklist_With_Diff__ in order to update the shipment inventory location of the alreday created pick 
--  120828          lists when pick reporting a pick list if the user intends to do so from the client.
--  120817  MeAblk  Modified the error message SHIPLOCATIONNULL.
--  120815  NiDalk  Bug 104534, Added method Check_Start_Warehouse_Task.
--  120727  MeAblk  Modified the procedure Pick_Reservations__ procedure in order to avoid inserting null for the shipment location when pick reporting through
--  120727          warehouse tasks if the shipment inventory is mandatory. Updated the shipment inventory location of the shipment if it is null. 
--  120725  MeAblk  Implemented the overloaded procedure Pick_Report_Shipment__ in order to update the shipment location of the shipment and the default
--  120725          shipment inventory location of already created shipment pick lists, when pick reporting while shipment location of the shipment is
--  120725          having null for shipment inventory location. Modified the methods Report_Consol_Pick_List__, Pick_Picklist_With_Diff__ in order to update
--  120725          shipment inventory location of the shipment when it is having null while pick reporting.
--  120313  MoIflk  Bug 99430, Modified procedure Recalc_Catch_Price_Conv_Factor to include inverted_conv_factor logic with conv_factor.
--  120113  Darklk  Bug 100716, Added the parameter catch_qty_ to method calls Customer_Order_Reservation_API.New to insert the correct
--  120113          catch_qty value when the shipment inventory is used.
--  111101  NISMLK  SMA-289, Increased eng_chg_level_ length to VARCHAR2(6) in Pick_Reservations__ method.
--  110906  Darklk  Bug 98174, Modified the procedure Pick_Reservations__ and Pick_On_Location___ to avoid report picking the same pick list twice.
--  110722  MaMalk  Replaced UserAllowedSite references since the userid is not a part of the atteibutes in these views.
--  110624  NWeelk  Bug 94542, Modified view PRINT_PICK_LIST_JOIN by adding values for the customer_no and customer_name when the shipment_id 
--  110624          is NOT NULL and the consolidated_flag is CONSOLIDATED.
--  110124  ShVese  Moved the validations for catch unit and receipt and issue tracking from Pick_Reservations__ to Pick_On_Location___.
--  101222  RaKalk  Modified Pick_On_Location___ function to support split serials
--  101216  SHVESE  Changed the error message SERIALSPLIT(Report_Pick_List___) and SERIALREQ (Pick_Reservations__).
--  101129  SHVESE  Added check for receipt and issue serial tracking in Is_Pick_Report_Allowed__, Reserved_As_Picked_Allowed__,
--                  Report_Pick_List___ and Pick_Reservations__.
--                  Replaced call to Part_Catalog_API.Get_Catch_Unit_Enabled with Part_Catalog_API.Get in Reserved_As_Picked_Allowed__. 
--                  Added constants for Fnd_Boolean(True and False) and replaced hardcoded usage of 'TRUE' and 'FALSE' with the constants.
--  110131  Nekolk  EANE-3744  added where clause to View CUST_ORD_PICK_LIST_JOIN,PRINT_PICK_LIST_JOIN
--  100826  ChJalk  Bug 92358, Modified the methods Return_From_Ship_Inv__ and Scrap_Part_In_Ship_Inv__ to update the qty_shipdiff when returning 
--  100826          and scrapping parts from shipment inventory. 
--  100518  KRPELK  Merge Rose Method Documentation.
--  100212  SaJjlk  Bug 88908, Modified method Report_Pick_List___ to increment the value of count_ only if reservation records are found.
--  091203  KiSalk  Changed backorder option values to new IID values in Customer_Backorder_Option_API.
--  091001  MaMalk  Modified Is_Pick_Report_Allowed_ and Pick_List_Reported___ to remove unused code.
--  ------------------------- 14.0.0 ------------------------------------------
--  091202  DaGulk  Bug 85166, Removed parameter catch_qty_ from calls to Customer_Order_Reservation_API.New.
--  091020  NaLrlk  Removed method Report_Pick_List.
--  091020  KiSalk  Added Pallets_Used_On_Picklist__ and preliminary_pick_list_no parameter to Customer_Order_Reservation_API.New calls.
--  081030  DaZase  Bug 77960, Added check for Reserve_Customer_Order_API.Get_No_Of_Packages_Reserved() = 0 in method Report_Reserved_As_Picked__.
--  081001  DaZase  Bug 76868, Modified method Reserved_As_Picked_Allowed__ so Shipment creation at pick list stage is not allowed.
--  090224  NaLrlk  Added method Report_Pick_List.
--  080516  SuJalk  Bug 73033, Modified the Return_From_Ship_Inv__, Scrap_Part_In_Ship_Inv__ and Move_Between_Ship_Inv__
--  080516          methods to lock the customer order before processing and raised error messages if the return, scrap or quantity to move
--  080516          are greater than the quantity assigned.
--  070911  SaJjlk  Bug 66397, Modified the method Clear_Unpicked_Reservations___ to a public method.
--  070605  NiDalk  Modified type of catalog_no in Report_Reserved_As_Picked__.
--  070519  NiDalk  Modified Report_Reserved_As_Picked__ to consider back_order_option.
--  070515  Cpeilk  Bug 60944, Modified procedures Report_Pick_List___, Report_Picking__, Report_Consol_Pick_List__ 
--  070515          and Pick_Report_Shipment__ to solve the problems in recording history when handling picking functionality.
--  070503  NiDalk  Modified Move_To_Shipment_Location___ to correct invalidation of Pre-shipping delivery note.
--  070423  NiDalk  Modified Reserved_As_Picked_Allowed__ to add history information to Customer_Order and Customer_Order_Line on Status 'Picked'.
--  070329  NiDalk  Added two methods Reserved_As_Picked_Allowed__, Report_Reserved_As_Picked__.
--  070320  NiDalk  Modified Move_Between_Ship_Inv__ to invalidate Pre-Shipping Delivery note at to_location.
--  070314  SeNslk  LCS Merge 63347, Modified method Pick_Report_Shipment__ to lock the shipment before execution starts.
--  070313  NiDalk  Modified Return_From_Ship_Inv__, Scrap_Part_In_Ship_Inv__, Move_To_Shipment_Location___ and Move_Between_Ship_Inv__  to invalidate Pre-Shipping Delivery note.
--  070306  NaLrlk  Modified the methods Report_Pick_List___ and Pick_Reservations__
--  070206  MaMalk  Bug 62793, Modified procedure Pick_On_Location___ to allow pick with differences with a zero quantity for a part that is frozen for counting.
--  070122  NaWilk  Removed parameters Del_terms_desc and Ship_via_desc from Customer_Order_Deliv_Note_API.Get_Preliminary_Delnote_No
--  070122          and Create_Order_Delivery_Note_API.Create_Prelimin_Deliv_Note.
--  070118  SuSalk  Code cleanup, removed ship_via_desc external references & called Mpccom_Ship_Via_API.Get_Description.
--  061228  DaZase  Changed all usage of catch_unit_code from part catalog record so it now is fetched from Inventory_Part_API.Get_Catch_Unit_Meas instead.
--  061125  RoJalk  Bug 60371, Modified method Pick_Report_Shipment__.
--  061125          Modified the methods Report_Pick_List___ and Report_Picking__.
--  061125          Modified the methods Report_Pick_List___, Pick_Reservations__, Report_Picking__ and Report_Consol_Pick_List__
--  061003          to implement history a message that says the created pick list is picked once the picking is done.
--  061003          And added a the method Create_Ord_Hist_When_Picked___ to update the header history when the picking is dine with differences.
--  060913  ChJalk  Bug 59899, Modified Return_From_Ship_Inv__ to allow moving the stock from Shipment location to Floor Stock location
--  060913          and Production Line location.
--  060524  NuFilk  Bug 57743, Modified method Pick_Report_Shipment__ and Report_Consol_Pick_List__ to handle pallet handled parts
--  060524          originating from shipment flow. Added method Pallets_On_Pick_List___.
--  060412  RoJalk  Enlarge Identity - Changed view comments.
--  -------------------- 13.4.0 -----------------------------------------------
--  060302  NiDalk  Added the methods Is_Pick_Report_Allowed__ and Is_Ship_Pick_Report_Allowed__.
--  060103  LaBolk  Bug 55124, Modified Modify_Pick_Reported_Line___ to move call to Set_Line_Qty_Shipdiff outside the existing conditions.
--  051228  LaBolk  Bug 55124, Modified Modify_Pick_Reported_Line___ to correct a condition of raising an error message.
--  050929  DaZase  Added configuration_id/activity_seq in calls to Inventory_Part_Loc_Pallet_API methods.
--  050921  NaLrlk  Removed unused variables.
--  050829  DaZase  Added input values to attribute string in Code_Picked_Locations_Single__ and moved the QTY_TO_DELIVER in this string.
--  050712  DaZase  Added activity_seq to Code_Picked_Locations_Single__.
--  050707  DaZase  Added activity_seq_ as parameter to methods Move_To_Shipment_Location___,
--                  Move_Between_Ship_Inv__, Return_From_Ship_Inv__ and Scrap_Part_In_Ship_Inv__.
--                  Also changed these methods so they now use the correct activity_seq when reserving etc.
--  050630  MaEelk  Removed the TRUE parameter from General_SYS.Init call in Recalc_Catch_Price_Conv_Factor.
--  050511  NiRulk  Bug 49605, Modified Clear_Unpicked_Reservations___ to clear unpicked pallet parts.
--  050406  SaJjlk  Modified catch quantity validations in Pick_Reservations__.
--  050330  PrPrlk  Bug 49003, Removed the check for closed tolerence in methods Modify_Pick_Reported_Line___ and Report_Complete_Packages___ and
--  050330          made changes in procedure Pick_Reservations__.
--  050321  SaJjlk  Modified method Pick_Report_Shipment__ to get the shipment inventory location.
--  050216   IsAnlk  Modified SHIPMENT_CONNECTED as VARCHAR2 and changed the code accordingly.
--  050128  NuFilk  Modified cursor in method Get_No_Of_Packages_Picked.
--  050125  NuFilk  Modified method Pick_Report_Shipment__.
--  050125  NuFilk  Modified condition in cursor get_inv_packages_picked in method Get_No_Of_Packages_Picked.
--  050121  UsRalk  Added new public method Get_No_Of_Packages_Picked.
--  050113  NuFilk  Modified method Pick_Report_Shipment__.
--  050104  NuFilk  Modified method Pick_Report_Shipment__ and view CUST_ORD_PICK_LIST_JOIN.
--  041230  IsAnlk  Removed consignment functionality from customer orders.
--  041122  SaJjlk  Modified error message for validating catch quantity in method Pick_Reservations__.
--  041119  GeKalk  Modified Recalc_Catch_Price_Conv_Factor to fetch the catch_qty_shipped from Deliver_Customer_Order_TAB.
--  041117  UsRalk  Modified Pick_On_Location___ to use the correct ACTIVITY_SEQ.
--  041112  IsAnlk  Modified Recalc_Catch_Price_Conv_Factor.
--  041110  IsAnlk  Added Recalc_Catch_Price_Conv_Factor.
--  041109  IsAnlk  Replaced calls to Modify_Qty_Picked, Modify_Qty_Assiged, Modify_Catch_Qty by Modify_Qty_Picked.
--  041105  GeKalk  Modified Move_To_Shipment_Location___ and added parameter to represent quantity in catch unit of measure to
--  041105          methods Return_From_Ship_Inv__, Move_Between_Ship_Inv__ and Scrap_Part_In_Ship_Inv__.
--  041104  GeKalk  Moved the previous modification to Report_Pick_List___ and Pick_Reservations__.
--  041103  GeKalk  Modified method Pick_On_Location___ to update the new price conv. factor of the customer order line.
--  041028  DaRulk  Bug 47136,Added new method Pick_List_Is_Over_Reserved__
--  041019  IsAnlk  Modified Code_Picked_Locations_Single__ by adding catch_qty to attr.
--  041025  GeKalk  Added parameter catch_qty_to_pick_ to method Pick_On_Location___ and modified same method and Report_Pick_List___ to
--  041025          handle picking of catch unit handle parts.
--  041020  IsAnlk  Added parameter catch_qty_ to method calls Customer_Order_Reservation_API.New.
--  041015  DaZase  Added handling of activity_seq in Pick_Reservations__, Pick_On_Location___, Report_Pick_List___,
--                  Clear_Unpicked_Reservations___ and Remove_Remaining_Reserv__.
--  041014  SaJjlk  Added parameter catch_quantity_ to method calls Inventory_Part_In_Stock_API.Reserve_Part.
--  041013  SaJjlk  Modifications to method call to Inventory_Part_In_Stock_API.Scrap_Part.
--  040929  DaZase  Project Inventory: Added zero-parameter to calls to different Customer_Order_Reservation_API methods,
--                  the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  040915  SaJjlk  Modified method call to Inventory_Part_In_Stock_API.Scrap_Part
--                  to pass NULL for newly added parameter catch_quantity_.
--  040906  SaJjlk  Added parameters input_qty_, input_unit_meas_, input_conv_factor_ and input_variable_values_ to Move_To_Shipment_Location___.
--  040831  KeFelk Removed contact & modified deliver_to_customer_no in Create_Delivery_Notes___.
--  040825  DaRulk  Removed DEFAULT NULL input uom parameters. Instead assign the values inside the code.
--  040817  DhWilk  Inserted the General_SYS.Init_Method to Pallets_Reserved_On_Line__ & Pallets_Reserved_On_Shipment__
--  040817  DaRulk  Modified Report_Pick_List___ to add input uom arameters.
--  040811  DaRulk  Added input uom paramaeters to Pick_Reservations__ and Pick_On_Location___ .
--  040728  WaJalk  Modified methods Report_Pick_List___ and Pick_Reservations__.
--  040707  ChFolk  Bug 44440, Removed close_line_ parameter from Modify_Pick_Reported_Line___. Modified method calls for
--  040707          Modify_Pick_Reported_Line___ accordingly. Renamed method Close_Remaining_Lines__ as Remove_Remaining_Reserv__.
--  040629  WaJalk  Modified methods Report_Pick_List___ and Pick_Reservations__.
--  040511  DaZase  Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods,
--                  the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  040224  IsWilk  Removed SUBSTR from the views for Unicode Changes.
--  040408  NaWilk  Bug 42959, Modified where condition of cursor address_order_specific_exist in FUNCTION Open_Consignment_Exist___.
--  040211  PrTilk  Bug 41402, Modified methods Pick_Picklist_With_Diff__, Report_Consol_Pick_List__. Added
--  040211          code to get the consolidated data from the new lu ConsolidatedOrders.
--  040209  SuAmlk  Bug 41595, Modified procedure Scrap_Part_In_Ship_Inv__ to reduce the quantity on consignment when parts are scrapped
--  040209          for orders which use consignments.
--  040123  NaWilk  Bug 41697, Modified cursors address_id_specific_exist and single_address_specific_exist by removing tables
--  040123          CUSTOMER_ORDER_TAB and CUSTOMER_ORDER_LINE_TAB and removed the check for order currencies.
--  040116  SaRalk  Bug 41681, Modified procedure Pick_Reservations__.
--  040116  ChIwlk  Bug 41595, Modified procedure Return_From_Ship_Inv__ to reduce the quantity on consignment when parts are returned
--  040116          for orders which use consignments. Removed the method Open_Consignment_Line_Exist___ and modified method
--  040116          Modify_Pick_Reported_Line___ to call Consignment_API.Get_Consignment_For_Order_Line instead of the removed method.
--  ------------------------------ 13.3.0-------------------------------------
--  040102  IsWilk  Bug 39282, Modified the view CUST_ORD_PICK_LIST_JOIN by adding a union all.
--  ********************* VSHSB Merge End*****************************
--  021114  PrInLk  Modified method Pick_Pick_Lists__ to support multi shipment on same order line.
--  021106  PrInLk  Added a method Pick_Picklist_Diff as a public interface to the method Pick_Picklist_With_Diff__.
--  021030  PrInLk  Modified method Pick_Pick_Lists__ to support more than one pick lists.
--  021011  PrInLk  Added a proper back ground job message to the method Pick_Picklist_With_Diff__ method.
--  020610  DaMase Changed declaration of shipment_id in Pick_Pick_Lists__.
--  020516  MaGu  Modified method Pick_Report_Shipment__ so pick report method is only called once
--                per pick list no.
--  020506  MaGu  Added methods Start_Pick_Report_Shipment__ and Pick_Report_Shipment__.
--  020506  Prinlk Modify the method Pick_Pick_Lists__ to alert the user when the order line is connected to a
--                 shipment and reserved qty is different from picked qty.(if a package structure exist).
--  020502  MaGu  Added call to General_SYS.Init_Method in methods Pallets_Reserved_On_Line__,
--                and Pallets_Reserved_On_Shipment__.
--  020320  MaGu  Added objid and objversion to view SHIPMENT_LINE_PICK_JOIN.
--  020319  MaGu  Modified method Pick_Pick_Lists__.
--  020305  MaGu  Added method Pallets_Reserved_On_Shipment__.
--  020301  MaGu  Removed checks for shipment order lines in method Report_Pick_List.
--                Also added shipment_id to view CUST_ORD_PICK_LIST_JOIN and PRINT_PICK_LIST_JOIN.
--                Also added check on shipment_connected in method Report_Pick_List___ to
--                prevent creation of delivery notes when order line is connected to shipment.
--  020226  MaGu  Added view SHIPMENT_LINE_PICK_JOIN. Also added mehtods
--                Pick_Pick_Lists__ and Pallets_Reserved_On_Line__.
--  020204  MaGu  Modified cursor get_lines in method Report_Pick_List___ so that order lines connected to a
--                shipment will not be added to the pick list.
--  ********************* VSHSB Merge Start*****************************
--  031001  UdGnlk  Revoke Bug 39282 remove the where clause of the view CUST_ORD_PICK_LIST_JOIN to fetch the consolidated orders.
--  030919  ZiMolk  Bug 39282, Modified the where clause of the view CUST_ORD_PICK_LIST_JOIN to fetch the consolidated orders.
--  030911  MiKulk  Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  030801  SaNalk   Performed SP4 Merge.
--  030418  ChJalk  Bug 36704, Modified the PROCEDURE Pick_Reservations__ to consider shipped_qty as well in overpicked Order Lines.
--  030328  AnJplk  Modified Procedure Modify_Pick_Reported_Line___.
--  030324  AnJplk  Modified Procedure Modify_Pick_Reported_Line___.
--  030227  ThAjLk  Bug 35939, Modified the Procedures Report_Pick_List___ and Pick_Reservations__.
--  021213  DayJlk  Bug 34810, Added background job description CO_REP_PICKING for a Normal pick list in PROC Pick_Picklist_With_Diff__.
--  020919  JoAnSe  Merged the IceAge bugg corrections below onto the AD 2002-3 track.
--  020827  MaGu    Bug fix 29389. Modified cursor get_pick_list in method Modify_Pick_Reported_Line___.
--  ---------------------------------- IceAge Merge End ------------------------------------
--  020516  SUAMLK  Changed the serial_no_ variable definition length from VARCHAR(15) TO VARCHAR(50).
--  -------------------------------- AD 2002-3 Baseline ------------------------------------
--  020322  SaKaLk   Call 77116(Foreign Call 28170). Added county to calling methods
--                  'Customer_Order_Deliv_Note_API.New' and 'Create_Order_Delivery_Note_API.Create_Prelimin_Deliv_Note' parameter list.
--  020111  CaStse  Bug fix 25611, Modified error message in Modify_Pick_Reported_Line___.
--  020111  IsWilk  Bug Fix 26984, Removed the previous modification.
--  020110  CaStse  Bug fix 25611, Added a check if several pick lists exist for the CO line in Modify_Pick_Reported_Line___.
--  020109  GaJalk  Bug fix 27084, Modified the procedure Pick_Reservations__.
--  020103  IsWilk  Bug Fix 26984, Added the history to the Customer Order and Customer Order Lines in the PROCEDURE Report_Pick_List___.
--  011022  JSAnse  Bug fix 21851, Added and modified some lines in the cursors in Open_Consignment_Exist().
--  011012  IsWilk  Bug Fix 23041, Modified the PROCEDURE Modify_Pick_Reported_Line___ to restrict the new consignments for zero picked amounts.
--  010817  JakHse  Bug Fix 21851, Consignment Notes grouped by delivery address and by forward agent.
--                  Rewrote most of Open_Consignment_Exist___, elimnated function call from Open_Consignment_Line_Exist___
--  010621  IsWilk  Bug Fix 22628, Modified the where clause of the view PRINT_PICK_LIST_JOIN.
--  010611  IsWilk  Bug Fix 22303, Added the check and error message for frozen part in the PROCEDURE Pick_On_Location___.
--  001205  JoEd  Changed the driving table in the views and added undefines.
--  001205  JoEd  Bug fix 18513. Added call to create preliminary delivery note
--                in method Pick_Reservations__.
--  001122  DaZa  Added dummy parameter in call to Consignment_Line_API.Add_Line_To_Consignment__.
--                Rewrote cursor address_specific_exist in Open_Consignment_Exist___.
--  001113  DaZa  Changed Open_Consignment_Exist___ so it checks forward agent instead of delivery terms.
--  001020  JakH  Changed calls from inventory_part_location to call inventory_part_in_stock
--  001020  JakH  Customer_order_reservation calls includes configuration_id
--  000922  MaGu  Changed to new address format in Report_Pick_List___.
--  000918  DaZa  A fix on the new cursor in method Open_Consignment_Exist___.
--  000912  DaZa  Added new cursor in method Open_Consignment_Exist___.
--  -------------------- 12.1 -----------------------------------------------
--  000511  PaLj  Added Priority to CUST_ORD_PICK_LIST_JOIN and PRINT_PICK_LIST_JOIN
--  000419  PaLj  Corrected Init_Method Errors
--  000323  MaGu  Changed name on method After_Picking_Consol_Pl__ to To_Order_Flow_When_Picked__. Added
--                call to To_Order_Flow_When_Picked__ from Pick_Picklist_With_Diff.
--  000321  MaGu  Modified method Pick_Reservations__. Added closing of customer order line.
--  000112  JOHW  Added parameters to Move_Part_Shipment and Move_Pallet. Removed
--                calls to unreserve before move to shipment location.
--  -------------------- 12.0 ----------------------------------------------
--  991104  PaLj  Changed Report_Consol_Pick_List
--  991102  PaLj  Removed order_no in interface of functions Pick_Reservations,
--                Pick_Picklist_With_Diff and Close_Remaining_Lines.
--                Changed function Pick_Picklist_With_Diff.
--  991029  PaLj  Beautifying...
--  991020  JoEd  Added ship_via_desc to Create_Prelimin_Deliv_Note call.
--  991013  PaLj  CID 22502. Report_Consol_Pick_List Corrected to report severel picklists
--  991011  PaLj  Moved(added) view PRINT_PICK_LIST_JOIN from picklist.apy
--  991007  JoEd  Corrected double-byte problems.
--  990929  PaLj  Changed Pick_Reservation, Pick_List_Reported___, Add_Line_To_Attr___
--                and Close Remaining_Lines to work with consolidated picklists
--  990921  PaLj  Added Procedures Start_Report_Consol_Pl__ and Report_Consol_Pick_List__
--  990914  JoEd  Changed call to create delivery notes.
--  --------------------- 11.1 ----------------------------------------------
--  990601  JoEd  Call id 18477: Added contract and pallet_id to Set_Picking_Confirmed calls.
--  990519  JakH  CID 16658 - Open_Consignment_Exist___ corrected to allow all lines of an
--                single address order to appear on the same consignment.
--  990427  PaLj  Y. Added ORDER BY in Report_Pick_List to prevent deadlock
--  990419  RaKu  Y.Fixes with Get-method.
--  990415  RaKu  Y.Cleanup.
--  990415  JoEd  Y.Call id 13994 - Added joined view CUST_ORD_PICK_LIST_JOIN
--                to use in client forms.
--  990412  JoEd  Y.Call id 13985 - Making use of PK for CUSTOMER_ORDER_RESERVATION
--                instead of IX in More_Reservations_Exist___, Report_Pick_List___,
--                Clear_Unpicked_Reservations___ and Close_Remaining_Lines__.
--  990412  JakH  Y.Using Tables instead of views.
--  990406  JakH  Y.CID 10582 Removed use of Gen_Def_Key_value. use '*' where possible.
--  990403  RaKu  Added parameter overpicked_lines_ in Pick_Reservations__
--                and Pick_Picklist_With_Diff__.
--  990223  RaKu  Call ID 6430. Pallets was not unreserved correctly when closing a line.
--                Changes in Close_Remaining_Lines__.
--  990112  JoEd  Cleaned up the code.
--  981204  RaKu  Added logic for creation of preliminary delivery note in Report_Picking__,
--                Pick_Reservations__ and Pick_Picklist_With_Diff__.
--  981019  CAST  Added logic for automatic closure of order lines (close_tolerance).
--  980720  JOHW  Reconstruction of inventory location key
--  980424  RaKu  SID 4140. Added check for Single Occurance Address in Open_Consignment_Exist___.
--  980420  RaKu  SID 4181. Added 'AND order_consignment_creation_db...'
--                in Open_Consignment_Exist___.
--  980417  LEPE  Added order arguments in calls to Move_Part_Shipment and Move_Pallet.
--  980409  RaKu  Changed newattr_ and codeattr_ from VARCHAR(2000) to VARCHAR(32000).
--  980326  RaKu  Added controll for length of the attribute being created in
--                Code_Picked_Locations_Pallet/Single___.
--  980209  RaKu  Added parameter order_specific_ in Open_Consignment_Exist___.
--                Modifyed procedure Modify_Pick_Reported_Line___.
--  980123  RaKu  Added logic for automatic consignment creation in Modify_Pick_Reported_Line___.
--                Added functions Open_Consignment_Exist___ and Open_Line_Consignment_Exist___.
--  971125  RaKu  Changed to FND200 Templates.
--  971002  JoAn  Corrected cursor in Report_Package_If_Complete___
--  970604  RaKu  Modifyed Move_To_Shipment_Location___ so new reservations are
--                made in inventory after moving both single parts and pallets.
--  970603  RaKu  Added reserve/unreserve functions when parts to shipment_inventory
--                in function Move_To_Shipment_Location___.
--  970529  EvWe  Added function Inventory_Part_Location_API.Get_Expiration_Date in
--                Return_From_Ship_Inv and Move_Between_Ship_Inv.
--  970520  RaKu  Modifyed procedures Move_Between_Ship_Inv__, Return_From_Ship_Inv__
--                and Scrap_Part_In_Ship_Inv__.
--  970520  RaKu  Modifyed code to match Design.
--  970515  RaKu  Splitted function Code_Picked_Locations__ into two others,
--                Code_Picked_Locations_Pallet__ and Code_Picked_Locations_Single__.
--  970515  RaKu  Added procedure Scrap_Part_In_Ship_Inv__.
--  970507  RaKu  Added function Pallets_Reserved_On_Picklist__. Removed
--                obsolete view CUSTOMER_ORDER_REPORT_PICKING. Replaced
--                parameters in call to Move_Between_Ship_Inv__, Return_From_Ship_Inv__.
--  970430  EvWe  Added procedures Return_From_Ship_Inv__ and Move_Between_Ship_Inv__.
--  970428  RaKu  Added pallet_id in calls to customer_order_reservation.
--  970428  RaKu  Changed in a lot of methods.
--  970411  RaKu  Added procedure Pick_Reservations__.
--  970408  RaKu  Added function Pick_List_Connected__.
--  970304  RaKu  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_                        CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;
db_false_                       CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;
TYPE Lov_Value_Tab  IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
string_null_                    CONSTANT VARCHAR2(15) := Database_SYS.string_null_;
mixed_value_                    CONSTANT VARCHAR2(3)  := '...';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Create_Picked_Constant___ (
   pick_list_no_ IN VARCHAR2 ) RETURN VARCHAR2  
IS
BEGIN
   RETURN Language_SYS.Translate_Constant(lu_name_, 'PICKLISTPICKED: Picklist :P1 picked', NULL, pick_list_no_);
END Create_Picked_Constant___;   

-- More_Reservations_Exist___
--   Check if more reservatiuons exist for the specified order line on the
--   specified pick list
FUNCTION More_Reservations_Exist___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   pick_list_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   -- Concatenation with '' in order to make use of PK for CUSTOMER_ORDER_RESERVATION instead of IX
   CURSOR reservations_exist IS
      SELECT 1
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  qty_assigned       > qty_picked
      AND    pick_list_no || '' = pick_list_no_
      AND    line_item_no       = line_item_no_
      AND    rel_no             = rel_no_
      AND    line_no            = line_no_
      AND    order_no           = order_no_;
BEGIN
   OPEN  reservations_exist;
   FETCH reservations_exist INTO dummy_;
   IF (reservations_exist%NOTFOUND) THEN
      dummy_ := 0;
   END IF;
   CLOSE reservations_exist;
   RETURN (dummy_ = 1);
END More_Reservations_Exist___;


-- Pick_List_Reported___
--   Check if a pick list has been reported
FUNCTION Pick_List_Reported___ (
   pick_list_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;

   CURSOR qty_to_pick IS
      SELECT 0
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  pick_list_no = pick_list_no_
      AND    qty_picked   != qty_assigned;
BEGIN
   OPEN qty_to_pick;
   FETCH qty_to_pick INTO dummy_;
   IF (qty_to_pick%NOTFOUND) THEN
      dummy_ := 1;
   END IF;
   CLOSE qty_to_pick;
   RETURN (dummy_ = 1);
END Pick_List_Reported___;


-- Pick_List_Part_Reported___
--   Check if a pick list has been partially reported
FUNCTION Pick_List_Part_Reported___ (
   pick_list_no_ IN VARCHAR2, order_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER := 0;

   CURSOR picked_lines IS
      SELECT 1
        FROM customer_order_reservation_tab
       WHERE pick_list_no = pick_list_no_
         AND order_no = order_no_
         AND qty_picked = qty_assigned;
BEGIN
   OPEN picked_lines;
   FETCH picked_lines INTO dummy_;
   IF (picked_lines%FOUND) THEN
      dummy_ := 1;
   END IF;
   CLOSE picked_lines;
   RETURN (dummy_ = 1);
END Pick_List_Part_Reported___;


-- Report_Pick_List___
--   Report a pick list
PROCEDURE Report_Pick_List___ (
   shipment_id_tab_        OUT Shipment_API.Shipment_Id_Tab,
   pick_list_no_           IN  VARCHAR2,
   location_no_            IN  VARCHAR2,
   process_shipments_      IN  BOOLEAN,
   trigger_shipment_flow_  IN  BOOLEAN DEFAULT FALSE )
IS
   info_                      VARCHAR2(2000);
   qty_picked_                NUMBER;
   qty_assigned_              NUMBER;
   contract_                  VARCHAR2(5)    := NULL;
   part_catalog_rec_          Part_Catalog_API.Public_Rec;
   part_no_                   customer_order_line_tab.part_no%TYPE;
   order_found_               BOOLEAN;
   order_line_found_          BOOLEAN;
   order_index_               PLS_INTEGER := 1;
   order_line_index_          PLS_INTEGER := 1;
   outermost_hu_id_           NUMBER;
   k_                         PLS_INTEGER := 0;
   local_ship_location_no_    VARCHAR2(35);
    
   CURSOR get_reservations IS
      SELECT contract,          part_no,               location_no,      lot_batch_no,
             serial_no,         waiv_dev_rej_no,       eng_chg_level,    qty_assigned,      
             activity_seq,      handling_unit_id, input_qty,             input_unit_meas,
             input_conv_factor, input_variable_values, configuration_id, catch_qty,
             order_no,          line_no,               rel_no,           line_item_no, shipment_id
      FROM   customer_order_reservation_tab
      WHERE  qty_assigned > qty_picked
      AND    pick_list_no = pick_list_no_
      -- ORDER BY to prevent deadlock.
      ORDER BY part_no, location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no;

   TYPE Res_Lines             IS TABLE OF get_reservations%ROWTYPE INDEX BY PLS_INTEGER;
   reservations_              Res_Lines;
   order_lines_               Res_Lines;
   orders_                    Res_Lines;
   ship_default_location_no_  VARCHAR2(35);
BEGIN
   local_ship_location_no_   := location_no_;
   
   --If shipment inventory is used, fetch the pick list location value if no value is passed
   IF(Customer_Order_Pick_List_API.Uses_Shipment_Inventory(pick_list_no_) = 1) THEN
      local_ship_location_no_ := NVL(local_ship_location_no_,Customer_Order_Pick_List_API.Get_Ship_Inventory_Location_No(pick_list_no_));
   END IF;
   Inventory_Event_Manager_API.Start_Session;
   -- Keep all the customer order reservations before they are processed
   OPEN get_reservations;
   FETCH get_reservations BULK COLLECT INTO reservations_;
   CLOSE get_reservations;
   
   IF (reservations_.COUNT > 0) THEN
      -- Report all reservations for the the pick list sorted by part_no, location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no
      FOR i IN reservations_.FIRST .. reservations_.LAST LOOP         
         IF (NVL(part_no_, Database_SYS.string_null_) != reservations_(i).part_no) THEN
            part_no_          := reservations_(i).part_no;
            part_catalog_rec_ := Part_Catalog_API.Get(part_no_);
         END IF;

         contract_  := reservations_(i).contract;
   
         -- If the existing catch qty has been changed after order line is reserved, manual picking should be performed.
         IF ((part_catalog_rec_.catch_unit_enabled = 'TRUE' ) AND (reservations_(i).catch_qty IS NULL)) THEN         
            Error_SYS.Record_General('PickCustomerOrder', 'FULLCATCHPICK: Reserved part for order no, line no, release no (:P1, :P2, :P3) is catch unit handled. Manual picking is required.', reservations_(i).order_no, reservations_(i).line_no, reservations_(i).rel_no);            
         END IF;

         -- Check the receipt and issue serial tracking flag for serial parts 
         IF (reservations_(i).serial_no = '*' AND
             part_catalog_rec_.receipt_issue_serial_track = db_true_) THEN
             Error_SYS.Record_General('PickCustomerOrder', 'SERIALSPLIT: Part connected to order no, line no, release no (:P1, :P2, :P3) requires a serial identification. Manual picking is required.',reservations_(i).order_no, reservations_(i).line_no, reservations_(i).rel_no);
         END IF;
         
         IF (NVL(reservations_(i).shipment_id, 0) != 0) THEN
            -- Uses the shipment id as index in the collection to make it only contain unique values.
            shipment_id_tab_(reservations_(i).shipment_id) := reservations_(i).shipment_id;            
         END IF;
         
         IF (reservations_(i).handling_unit_id != 0) THEN
            outermost_hu_id_ :=  Handl_Unit_Stock_Snapshot_API.Get_Outermost_Hu_Id(source_ref1_          => pick_list_no_,
                                                                                   source_ref_type_db_   => Handl_Unit_Snapshot_Type_API.DB_PICK_LIST,
                                                                                   handling_unit_id_     => reservations_(i).handling_unit_id);
         
            -- Unattach the parent of the record's outermost handling unit on the pick list if the record is to be moved in inventory.
            IF (local_ship_location_no_ IS NOT NULL AND outermost_hu_id_ IS NOT NULL) THEN
               IF (Handling_Unit_API.Get_Parent_Handling_Unit_Id(outermost_hu_id_) IS NOT NULL) THEN
                  Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_        => outermost_hu_id_,
                                                                   parent_handling_unit_id_ => NULL);
               END IF;
            END IF;
         ELSE
            outermost_hu_id_ := NULL;
         END IF;
         
         -- Update all reservations for the current line
         Pick_On_Location___(info_                          => info_,                         
                             qty_picked_                    => qty_picked_,                      
                             qty_assigned_                  => qty_assigned_,                
                             order_no_                      => reservations_(i).order_no,     
                             line_no_                       => reservations_(i).line_no,
                             rel_no_                        => reservations_(i).rel_no,       
                             line_item_no_                  => reservations_(i).line_item_no,    
                             shipment_id_                   => reservations_(i).shipment_id, 
                             contract_                      => reservations_(i).contract,
                             part_no_                       => reservations_(i).part_no,      
                             location_no_                   => reservations_(i).location_no,     
                             lot_batch_no_                  => reservations_(i).lot_batch_no,
                             serial_no_                     => reservations_(i).serial_no,    
                             eng_chg_level_                 => reservations_(i).eng_chg_level,   
                             waiv_dev_rej_no_               => reservations_(i).waiv_dev_rej_no,
                             pick_list_no_                  => pick_list_no_,                 
                             ship_location_no_              => local_ship_location_no_,
                             activity_seq_                  => reservations_(i).activity_seq, 
                             handling_unit_id_              => reservations_(i).handling_unit_id, 
                             qty_to_pick_                   => reservations_(i).qty_assigned,    
                             catch_qty_to_pick_             => reservations_(i).catch_qty,
                             input_qty_                     => reservations_(i).input_qty,    
                             input_unit_meas_               => reservations_(i).input_unit_meas, 
                             input_conv_factor_             => reservations_(i).input_conv_factor,
                             input_variable_values_         => reservations_(i).input_variable_values, 
                             keep_remaining_qty_            => FALSE,
                             validate_hu_struct_position_   => outermost_hu_id_ IS NULL,
                             add_hu_to_shipment_            => outermost_hu_id_ IS NULL );
         
         -- Create history records, one each for order and order line (ignoring multiple reservations per order line)
         order_found_      := FALSE;
         order_line_found_ := FALSE;

         IF (orders_.COUNT > 0) THEN
            -- Check if order history has already been created for this order
            FOR j IN orders_.FIRST .. orders_.LAST LOOP
               IF (reservations_(i).order_no = orders_(j).order_no) THEN
                  order_found_ := TRUE;
                  EXIT;
               END IF;
            END LOOP;
         END IF;

         IF (order_found_) THEN
            -- Check if order line history  has already been created for this order line
            IF (order_lines_.COUNT > 0) THEN
               FOR j IN order_lines_.FIRST..order_lines_.LAST LOOP
                  IF ((reservations_(i).order_no     = order_lines_(j).order_no)  AND
                      (reservations_(i).line_no      = order_lines_(j).line_no) AND
                      (reservations_(i).rel_no       = order_lines_(j).rel_no) AND
                      (reservations_(i).line_item_no = order_lines_(j).line_item_no)) THEN

                     order_line_found_ := TRUE;
                     EXIT;
                  END IF;
               END LOOP;
            END IF;
         END IF;

         IF NOT (order_found_) THEN
            Customer_Order_History_API.New(reservations_(i).order_no, Create_Picked_Constant___(pick_list_no_));
            -- Add order to the orders_ table to mark that order history has been created
            orders_(order_index_).order_no := reservations_(i).order_no;
            order_index_                   := order_index_ + 1;
         END IF;
         
         IF NOT (order_line_found_) THEN
            Customer_Order_Line_Hist_API.New(reservations_(i).order_no, reservations_(i).line_no, reservations_(i).rel_no, reservations_(i).line_item_no,
            Create_Picked_Constant___(pick_list_no_));
            -- Add order line to the order_lines_ table to mark that order line history has been created
            order_lines_(order_line_index_).order_no     := reservations_(i).order_no;
            order_lines_(order_line_index_).line_no      := reservations_(i).line_no;
            order_lines_(order_line_index_).rel_no       := reservations_(i).rel_no;
            order_lines_(order_line_index_).line_item_no := reservations_(i).line_item_no;
            order_line_index_                            := order_line_index_ + 1;
         END IF;
      END LOOP;
   END IF;
   
   -- If picking was done to a location, update the header with the location.
   IF(local_ship_location_no_ IS NOT NULL) THEN
      Customer_Order_Pick_List_API.Modify_Ship_Inventory_Loc_No(pick_list_no_, local_ship_location_no_);
   END IF;
   
   IF (shipment_id_tab_.COUNT > 0) THEN
      k_ := shipment_id_tab_.FIRST;
      WHILE(k_ IS NOT NULL) LOOP  
         
         IF process_shipments_ THEN
            ship_default_location_no_ := Shipment_API.Get_Ship_Inventory_Location_No(shipment_id_tab_(k_)); 
            IF (ship_default_location_no_ IS NULL) AND (local_ship_location_no_ IS NOT NULL) THEN
               Customer_Order_Pick_List_API.Modify_Pick_Ship_Location(shipment_id_tab_(k_), local_ship_location_no_);
               Shipment_API.Modify_Ship_Inv_Location_No(shipment_id_tab_(k_), local_ship_location_no_);
            END IF;

            IF (trigger_shipment_flow_) THEN
               -- Trigger shipment process.
               Shipment_Flow_API.Start_Shipment_Flow(shipment_id_tab_(k_), 40);
            END IF;
         END IF;
         
         -- When picking a full pick list or a full handling unit we send add_hu_to_shipment_ = FALSE
         -- into Move_To_Shipment_Location (to not trigger it from there) because a handling unit could span several
         -- lowest level records. Because of this we need to add the fully picked handling units to the shipment after all 
         -- lowest level records have been picked.
         Shipment_Handling_Utility_API.Connect_Hus_From_Inventory(shipment_id_tab_(k_), report_picking_ => true);
         k_ := shipment_id_tab_.NEXT(k_);
      END LOOP;
   
   END IF;
   
   -- Mark the pick list as reported if it is a normal (not consolidated) picklist.
   IF (Customer_Order_Pick_List_API.Get_Consolidated_Flag_Db(pick_list_no_) = 'NOT CONSOLIDATED') THEN
      Customer_Order_Pick_List_API.Set_Picking_Confirmed(pick_list_no_, contract_);
   END IF;
      
   Inventory_Event_Manager_API.Finish_Session;
END Report_Pick_List___;


-- Modify_Pick_Reported_Line___
--   Modify a pick reported order line
PROCEDURE Modify_Pick_Reported_Line___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   pick_list_no_ IN VARCHAR2,
   qty_picked_   IN NUMBER,
   qty_assigned_ IN NUMBER )
IS
   new_qty_picked_   NUMBER;
   new_qty_assigned_ NUMBER;
   line_rec_         Customer_Order_Line_API.Public_Rec;
   dummy_            NUMBER;
   pur_peg_          NUMBER;
   shp_peg_          NUMBER;
   qty_adjust_       NUMBER;
   qty_can_reserve_  NUMBER;
   part_cat_rec_     Part_Catalog_API.Public_Rec;
   
   CURSOR get_pick_list IS
      SELECT 1
      FROM CUSTOMER_ORDER_RESERVATION_TAB
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_
      AND   qty_picked   < qty_assigned
      AND   pick_list_no != pick_list_no_;
BEGIN
   line_rec_         := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   -- Update qty_picked and qty_assigned.
   new_qty_picked_   := qty_picked_ + line_rec_.qty_picked;
   new_qty_assigned_ := qty_assigned_ + line_rec_.qty_assigned;

   Customer_Order_API.Set_Line_Qty_Picked
     (order_no_, line_no_, rel_no_, line_item_no_, new_qty_picked_);
   
   part_cat_rec_ := Part_Catalog_API.Get(line_rec_.part_no);

   IF (part_cat_rec_.catch_unit_enabled = db_true_ ) THEN
      -- calculate and update the new price conv factor based on the catch quantities for catch unit handled parts.
      Pick_Customer_Order_API.Recalc_Catch_Price_Conv_Factor(order_no_,
                                                             line_no_,
                                                             rel_no_,
                                                             line_item_no_);
   END IF;

   IF qty_assigned_ > 0 THEN
      qty_can_reserve_ := (line_rec_.revised_qty_due - line_rec_.qty_assigned - line_rec_.qty_shipped - line_rec_.qty_on_order);
      qty_adjust_      := qty_assigned_ - qty_can_reserve_;
      pur_peg_         := Customer_Order_Pur_Order_Api.Get_Connected_Peggings(order_no_, line_no_, rel_no_, line_item_no_);
      shp_peg_         := Customer_Order_Shop_Order_Api.Get_Connected_Peggings(order_no_, line_no_, rel_no_, line_item_no_);
      IF ((pur_peg_ + shp_peg_)!=0 AND (qty_adjust_>0)) THEN
         Peg_Customer_Order_Api.Adjust_Pegging(pur_peg_, shp_peg_,qty_adjust_,order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   END IF;

   Customer_Order_API.Set_Line_Qty_Assigned (order_no_, line_no_, rel_no_, line_item_no_, new_qty_assigned_);

   IF (new_qty_picked_ >= line_rec_.revised_qty_due) THEN
      -- There is nothing left to report for this line   
      Customer_Order_API.Set_Line_Qty_Shipdiff(order_no_, line_no_, rel_no_, line_item_no_, new_qty_picked_ - line_rec_.revised_qty_due);
   END IF;

   IF ((new_qty_picked_ + line_rec_.qty_shipped) >= line_rec_.revised_qty_due) THEN
      OPEN get_pick_list;
      FETCH get_pick_list INTO dummy_;
      IF (get_pick_list%FOUND) THEN
         CLOSE get_pick_list;
         Error_SYS.Record_General(lu_name_, 'SEVERALPICKLISTS: You are trying to pick report the entire quantity on customer order :P1, line no :P2, del no :P3. Several pick list(s) or reservation(s) exist for this order line. Please process the other pick list(s) or reservation(s) first.', order_no_, line_no_, rel_no_);
      END IF;
      CLOSE get_pick_list;
   END IF;
END Modify_Pick_Reported_Line___;


-- Report_Complete_Packages___
--   Pick report all completed packages
PROCEDURE Report_Complete_Packages___ (
   order_no_ IN VARCHAR2 )
IS
   CURSOR get_package_lines IS
      SELECT line_no, rel_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no     = order_no_
      AND    line_item_no = -1
      AND    rowstate     NOT IN ('Delivered','Invoiced','Cancelled');
BEGIN
   FOR package_ IN get_package_lines LOOP
      Report_Package_If_Complete___(order_no_, package_.line_no, package_.rel_no);
   END LOOP;
END Report_Complete_Packages___;


PROCEDURE Report_Complete_Ship_Pkgs___ (
   shipment_id_ IN NUMBER )
IS
   CURSOR get_package_lines IS
      SELECT source_ref1, source_ref2, source_ref3
      FROM   SHIPMENT_LINE_PUB
      WHERE  shipment_id  = shipment_id_
      AND    source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND    Utility_SYS.String_To_Number(source_ref4) = -1;
BEGIN
   FOR package_ IN get_package_lines LOOP
      Report_Ship_Pkg_If_Complete___(shipment_id_, package_.source_ref1, package_.source_ref2, package_.source_ref3);
   END LOOP;
END Report_Complete_Ship_Pkgs___;


-- Report_Package_If_Complete___
--   Pick report a package if all inventory parts in the package have been picked.
PROCEDURE Report_Package_If_Complete___ (
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2,
   rel_no_   IN VARCHAR2 )
IS
   packages_picked_ NUMBER;
   line_rec_        CUSTOMER_ORDER_LINE_API.Public_Rec;

   CURSOR get_picked_qty IS
      SELECT nvl(min(trunc(qty_picked / (revised_qty_due / line_rec_.revised_qty_due))), 0) packages_picked
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no     = order_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no > 0
      AND    part_no      IS NOT NULL
      AND    rowstate     != 'Cancelled';
BEGIN
   -- Get values for package head.
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, -1);

   OPEN  get_picked_qty;
   FETCH get_picked_qty INTO packages_picked_;
   CLOSE get_picked_qty;

   IF (packages_picked_ > line_rec_.qty_picked) THEN
      -- One or more complete packages have been picked
      Customer_Order_API.Set_Line_Qty_Picked(order_no_, line_no_, rel_no_, -1, packages_picked_);
      IF (packages_picked_ >= line_rec_.revised_qty_due ) THEN
         -- Entire package (or more) have been picked.
         Customer_Order_API.Set_Line_Qty_Shipdiff
           (order_no_, line_no_, rel_no_, -1, packages_picked_ - line_rec_.revised_qty_due);
      END IF;
   END IF;
END Report_Package_If_Complete___;


PROCEDURE Report_Ship_Pkg_If_Complete___ (
   shipment_id_ IN NUMBER,
   order_no_    IN VARCHAR2,
   line_no_     IN VARCHAR2,
   rel_no_      IN VARCHAR2 )
IS
   packages_picked_ NUMBER;
   pkg_qty_picked_  NUMBER;

   CURSOR get_picked_qty IS
      SELECT NVL(MIN(trunc(sl.qty_picked * (col.inverted_conv_factor/col.conv_factor) / col.qty_per_assembly)), 0) packages_picked      
      FROM SHIPMENT_LINE_TAB sl, CUSTOMER_ORDER_LINE_TAB col
      WHERE sl.shipment_id   = shipment_id_
      AND   NVL(sl.source_ref1, string_null_) = order_no_
      AND   NVL(sl.source_ref2, string_null_) = line_no_
      AND   NVL(sl.source_ref3, string_null_) = rel_no_
      AND   sl.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND   col.order_no     = NVL(sl.source_ref1, string_null_)
      AND   col.line_no      = NVL(sl.source_ref2, string_null_)
      AND   col.rel_no       = NVL(sl.source_ref3, string_null_)
      AND   col.line_item_no > 0
      AND   col.line_item_no = NVL(sl.source_ref4, string_null_)
      AND   col.part_no      IS NOT NULL;
BEGIN
   -- Get values for package head.
   pkg_qty_picked_ := Shipment_Line_API.Get_Qty_Picked_By_Source(shipment_id_, order_no_, line_no_, 
                                                                 rel_no_, -1, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
   OPEN  get_picked_qty;
   FETCH get_picked_qty INTO packages_picked_;
   CLOSE get_picked_qty;

   IF (packages_picked_ > pkg_qty_picked_) THEN
      Shipment_Line_API.Modify_Qty_Picked(shipment_id_, order_no_, line_no_, rel_no_, -1, 
                                          Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, packages_picked_);
   END IF;
END Report_Ship_Pkg_If_Complete___;


-- Pick_On_Location___
--   Pick an order line at the specified location. Returns the qty_assigned
--   and the qty_picked
PROCEDURE Pick_On_Location___ (
   info_                       OUT VARCHAR2,
   qty_picked_                 OUT NUMBER,
   qty_assigned_               OUT NUMBER,
   order_no_                    IN VARCHAR2,
   line_no_                     IN VARCHAR2,
   rel_no_                      IN VARCHAR2,
   line_item_no_                IN NUMBER,
   shipment_id_                 IN NUMBER,
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   pick_list_no_                IN VARCHAR2,
   ship_location_no_            IN VARCHAR2,
   activity_seq_                IN NUMBER,
   handling_unit_id_            IN NUMBER,
   qty_to_pick_                 IN NUMBER,
   catch_qty_to_pick_           IN NUMBER,
   input_qty_                   IN NUMBER,
   input_unit_meas_             IN VARCHAR2,
   input_conv_factor_           IN NUMBER, 
   input_variable_values_       IN VARCHAR2,
   keep_remaining_qty_          IN BOOLEAN,
   part_tracking_session_id_    IN NUMBER   DEFAULT NULL,
   validate_hu_struct_position_ IN BOOLEAN  DEFAULT TRUE,
   add_hu_to_shipment_          IN BOOLEAN  DEFAULT TRUE,
   ship_handling_unit_id_       IN NUMBER   DEFAULT NULL )
IS
   new_qty_picked_               NUMBER;
   qty_to_reserve_               NUMBER;
   reserv_rec_                   Customer_Order_Reservation_API.Public_Rec;
   configuration_id_             VARCHAR2(50);
   inv_part_in_rec_              Inventory_Part_In_Stock_API.Public_Rec;
   catch_quantity_               NUMBER := NULL;
   serial_catch_tab_             Inventory_Part_In_Stock_API.Serial_Catch_Table;
   accumulated_catch_qty_        NUMBER := 0;
   local_qty_to_pick_            NUMBER;
   part_cat_rec_                 Part_Catalog_API.Public_Rec;
   ord_line_txt_                 VARCHAR2(65);
   total_qty_to_reserve_         NUMBER;
   line_rec_                     Customer_Order_Line_API.Public_Rec;
   local_qty_assigned_           NUMBER := 0;
   local_input_qty_              NUMBER;
   local_input_unit_meas_        VARCHAR2(30);
   local_input_conv_factor_      NUMBER;
   local_input_variable_values_  VARCHAR2(2000);
BEGIN
   line_rec_         := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   configuration_id_ := Customer_Order_Line_API.Get_Configuration_Id(order_no_, line_no_, rel_no_, line_item_no_);
   inv_part_in_rec_  := Inventory_Part_In_Stock_API.Get(contract_,      part_no_,         configuration_id_,
                                                        location_no_,   lot_batch_no_,    serial_no_,
                                                        eng_chg_level_, waiv_dev_rej_no_, activity_seq_, 
                                                        handling_unit_id_);
   part_cat_rec_     := Part_Catalog_API.Get(part_no_);
   
   -- Check if a shipment inventory location has been entered.
   IF(qty_to_pick_ > 0 AND ship_location_no_ IS NULL AND Customer_Order_Pick_List_API.Uses_Shipment_Inventory(pick_list_no_) = 1) THEN
      -- Specific scenario for automatic picking with shipment to give more info to the user. 
      -- Should only trigger for the automatic flow when the necessary basic data is missing.
      -- Meaning the pick list is missing information or no user input was given.
      IF shipment_id_ != 0 THEN
         Error_SYS.Record_General(lu_name_, 'SHIPLOCMANDATORY: The Shipment :P1 is missing a shipment inventory location. Manual pick reporting is required.', shipment_id_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'SHIPLOCATIONNULL: The shipment location must be entered when shipment inventory is used.');
      END IF;
   END IF;
   -- Check for frozen part
   IF (inv_part_in_rec_.freeze_flag = 'Y' AND qty_to_pick_ != 0) THEN
      Error_SYS.Record_General('PickCustomerOrder', 'FROZENPART: Inventory part :P1 on site :P2 is blocked for inventory transactions because of counting.', part_no_, contract_);
   END IF;
   Trace_SYS.Field('*****************part_tracking_session_id_', part_tracking_session_id_);

   -- Check the receipt and issue serial tracking flag for serial parts 
   IF (serial_no_ = '*' AND part_tracking_session_id_ IS NULL AND
       part_cat_rec_.receipt_issue_serial_track = db_true_ AND
       qty_to_pick_ != 0) THEN
      Error_SYS.Record_General('PickCustomerOrder', 'SERIALREQ: Part connected to order no, line no, release no (:P1, :P2, :P3) requires a serial identification to proceed with Report Picking.',order_no_, line_no_,rel_no_);
   END IF;

   reserv_rec_ := Customer_Order_Reservation_API.Get(order_no_          => order_no_,      
                                                     line_no_           => line_no_,          
                                                     rel_no_            => rel_no_,
                                                     line_item_no_      => line_item_no_,  
                                                     contract_          => contract_,         
                                                     part_no_           => part_no_,
                                                     location_no_       => location_no_,   
                                                     lot_batch_no_      => lot_batch_no_,     
                                                     serial_no_         => serial_no_,
                                                     eng_chg_level_     => eng_chg_level_, 
                                                     waiv_dev_rej_no_   => waiv_dev_rej_no_,  
                                                     activity_seq_      => activity_seq_,
                                                     handling_unit_id_  => handling_unit_id_,
                                                     configuration_id_  => configuration_id_, 
                                                     pick_list_no_      => pick_list_no_, 
                                                     shipment_id_       => shipment_id_);

   IF (reserv_rec_.input_conv_factor IS NOT NULL) THEN
      local_input_qty_ := reserv_rec_.input_qty;
      local_input_unit_meas_ := reserv_rec_.input_unit_meas;
      local_input_conv_factor_ := reserv_rec_.input_conv_factor;
      local_input_variable_values_ := reserv_rec_.input_variable_values;
   END IF;
   
   IF (((reserv_rec_.qty_assigned - reserv_rec_.qty_picked) = 0) AND (qty_to_pick_ != 0)) THEN
      ord_line_txt_ := order_no_ || '-' || line_no_ || '-' || rel_no_ || '-' || line_item_no_;
      Error_SYS.Record_General(lu_name_, 'ALREADYCOLINEPICKED: The customer order line :P1 has already been pick reported for this pick list.', ord_line_txt_);
   END IF;

   new_qty_picked_ := reserv_rec_.qty_picked + qty_to_pick_;
   qty_to_reserve_ := new_qty_picked_ - reserv_rec_.qty_assigned;

   IF ((keep_remaining_qty_ = TRUE) AND (new_qty_picked_ != 0) AND (new_qty_picked_ < reserv_rec_.qty_assigned)) THEN  -- zero pick and over pick should not keep reservation
      qty_to_reserve_ := 0; -- keep reservation
   END IF;
   
   -- during a unreservation total_qty_to_reserve_ will be a negative value.
   IF (line_rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      total_qty_to_reserve_ := qty_to_pick_ - reserv_rec_.qty_assigned;

      Reserve_Customer_Order_API.Validate_On_Rental_Period_Qty(order_no_,
                                                               line_no_,
                                                               rel_no_,
                                                               line_item_no_,
                                                               lot_batch_no_,
                                                               serial_no_,
                                                               total_qty_to_reserve_);
   END IF;

   IF (qty_to_reserve_ != 0) THEN
      -- Reserve/Unreserve in inventory.      
      -- Single reservations.
      Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_    => catch_quantity_,   
                                               contract_          => contract_,      
                                               part_no_           => part_no_,
                                               configuration_id_  => configuration_id_, 
                                               location_no_       => location_no_,   
                                               lot_batch_no_      => lot_batch_no_,
                                               serial_no_         => serial_no_,        
                                               eng_chg_level_     => eng_chg_level_, 
                                               waiv_dev_rej_no_   => waiv_dev_rej_no_, 
                                               activity_seq_      => activity_seq_, 
                                               handling_unit_id_  => handling_unit_id_,
                                               quantity_          => qty_to_reserve_);      
   END IF;

   IF (new_qty_picked_ = 0) THEN
      -- If there is nothing to pick then remove reservations.
      Customer_Order_Reservation_API.Remove(order_no_             => order_no_,      
                                            line_no_              => line_no_,          
                                            rel_no_               => rel_no_,
                                            line_item_no_         => line_item_no_,  
                                            contract_             => contract_,         
                                            part_no_              => part_no_,
                                            location_no_          => location_no_,   
                                            lot_batch_no_         => lot_batch_no_,     
                                            serial_no_            => serial_no_,
                                            eng_chg_level_        => eng_chg_level_, 
                                            waiv_dev_rej_no_      => waiv_dev_rej_no_,  
                                            activity_seq_         => activity_seq_,
                                            handling_unit_id_     => handling_unit_id_,
                                            configuration_id_     => configuration_id_, 
                                            pick_list_no_         => pick_list_no_, 
                                            shipment_id_          => shipment_id_);
   ELSE
      IF (part_tracking_session_id_ IS NULL) THEN
         serial_catch_tab_(1).serial_no := serial_no_;
         serial_catch_tab_(1).catch_qty := catch_qty_to_pick_;
         local_qty_to_pick_             := new_qty_picked_;
         IF (keep_remaining_qty_ = TRUE) THEN
            local_qty_assigned_ := reserv_rec_.qty_assigned + qty_to_reserve_;
         ELSE
            local_qty_assigned_ := local_qty_to_pick_;
         END IF;  
      ELSE
         Temporary_Part_Tracking_API.Get_Serials_And_Remove_Session(serial_catch_tab_, part_tracking_session_id_);
   
         Split_Serials___(order_no_               => order_no_,
                          line_no_                => line_no_,
                          rel_no_                 => rel_no_,
                          line_item_no_           => line_item_no_,
                          shipment_id_            => shipment_id_,
                          contract_               => contract_,
                          part_no_                => part_no_,
                          configuration_id_       => configuration_id_,
                          location_no_            => location_no_,
                          lot_batch_no_           => lot_batch_no_,
                          eng_chg_level_          => eng_chg_level_,
                          waiv_dev_rej_no_        => waiv_dev_rej_no_,
                          activity_seq_           => activity_seq_,
                          handling_unit_id_       => handling_unit_id_,
                          pick_list_no_           => pick_list_no_,
                          qty_to_pick_            => qty_to_pick_,
                          input_qty_              => input_qty_,
                          input_unit_meas_        => input_unit_meas_,
                          input_conv_factor_      => input_conv_factor_,
                          input_variable_values_  => input_variable_values_,
                          serial_catch_tab_       => serial_catch_tab_,
                          keep_remaining_qty_     => keep_remaining_qty_);        
         local_qty_to_pick_  := 1;
         local_qty_assigned_ := local_qty_to_pick_;
      END IF;
   
      accumulated_catch_qty_ := 0;
      
      FOR i IN serial_catch_tab_.FIRST .. serial_catch_tab_.LAST LOOP
         IF (local_qty_to_pick_ != 0) THEN
            -- if the part is catch enabled the catch quantity can not be null and should be greater than zero.
            IF (part_cat_rec_.catch_unit_enabled = db_true_) THEN
               IF (serial_catch_tab_(i).catch_qty IS NULL) THEN
                  Error_SYS.Record_General(lu_name_,'CATCHQTYNULL: Part :P1 uses Catch Unit :P2 and Catch Quantity must be entered.', part_no_, Inventory_Part_API.Get_Catch_Unit_Meas(contract_, part_no_));
               END IF;
               IF (serial_catch_tab_(i).catch_qty <= 0)  THEN
                  Error_SYS.Record_General(lu_name_,'CATCHQTYNOZERO: Catch Quantity must be greater than 0.');
               END IF;
            END IF;

            IF (serial_catch_tab_(i).serial_no != '*') AND (part_tracking_session_id_ IS NOT NULL) THEN  
               -- If part is serial tracked only in reciept and issue we update the reservation with user inputs for input uom and convector factor and recalculate input qty and value.
               local_input_unit_meas_ := input_unit_meas_;
               local_input_conv_factor_ := input_conv_factor_;
            END IF;
               
            Customer_Order_Reservation_API.Modify_Qty_Picked(order_no_                => order_no_,                      
                                                             line_no_                 => line_no_,       
                                                             rel_no_                  => rel_no_,           
                                                             line_item_no_            => line_item_no_,
                                                             contract_                => contract_,                      
                                                             part_no_                 => part_no_,       
                                                             location_no_             => location_no_,      
                                                             lot_batch_no_            => lot_batch_no_,
                                                             serial_no_               => serial_catch_tab_(i).serial_no, 
                                                             eng_chg_level_           => eng_chg_level_, 
                                                             waiv_dev_rej_no_         => waiv_dev_rej_no_,  
                                                             activity_seq_            => activity_seq_,
                                                             handling_unit_id_        => handling_unit_id_,
                                                             pick_list_no_            => pick_list_no_,  
                                                             configuration_id_        => configuration_id_, 
                                                             shipment_id_             => shipment_id_,       
                                                             qty_picked_              => local_qty_to_pick_,
                                                             catch_qty_               => serial_catch_tab_(i).catch_qty, 
                                                             input_qty_               => local_input_qty_,     
                                                             input_unit_meas_         => local_input_unit_meas_,  
                                                             input_conv_factor_       => local_input_conv_factor_,
                                                             input_variable_values_   => local_input_variable_values_,
                                                             remaining_qty_assigned_  => local_qty_assigned_);
         END IF;

         IF (ship_location_no_ IS NOT NULL) AND (local_qty_to_pick_ > 0)  THEN
            -- If shipment location is used, move picked qty to shipment location.
            Handle_Ship_Invent_Utility_API.Move_To_Shipment_Location(info_                         => info_,               
                                                                     order_no_                     => order_no_,          
                                                                     line_no_                      => line_no_,               
                                                                     rel_no_                       => rel_no_,
                                                                     line_item_no_                 => line_item_no_,    
                                                                     source_ref_type_db_           => Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER,
                                                                     contract_                     => contract_,              
                                                                     part_no_                      => part_no_,
                                                                     location_no_                  => location_no_,        
                                                                     lot_batch_no_                 => lot_batch_no_,          
                                                                     serial_no_                    => serial_catch_tab_(i).serial_no,
                                                                     eng_chg_level_                => eng_chg_level_,      
                                                                     waiv_dev_rej_no_              => waiv_dev_rej_no_,
                                                                     pick_list_no_                 => pick_list_no_,       
                                                                     configuration_id_             => configuration_id_,      
                                                                     activity_seq_                 => activity_seq_, 
                                                                     handling_unit_id_             => handling_unit_id_,
                                                                     shipment_location_            => ship_location_no_,   
                                                                     input_qty_                    => input_qty_,             
                                                                     input_unit_meas_              => input_unit_meas_,       
                                                                     input_conv_factor_            => input_conv_factor_,  
                                                                     input_variable_values_        => input_variable_values_, 
                                                                     shipment_id_                  => shipment_id_,  
                                                                     validate_hu_struct_position_  => validate_hu_struct_position_,
                                                                     add_hu_to_shipment_           => add_hu_to_shipment_,
                                                                     ship_handling_unit_id_        => ship_handling_unit_id_ );
            
         END IF;
         accumulated_catch_qty_ := accumulated_catch_qty_ + NVL(serial_catch_tab_(i).catch_qty,0);
      END LOOP;

      IF (catch_qty_to_pick_ IS NOT NULL AND accumulated_catch_qty_ != catch_qty_to_pick_) THEN
         Error_SYS.Record_General(lu_name_, 'REPPICKSERCATCH: The total catch quantity to be picked is :P1 but the accumulated catch quantity on the serials is entered as :P2.', catch_qty_to_pick_, accumulated_catch_qty_);
      END IF;
   END IF;

   Modify_Pick_Reported_Line___(order_no_,     line_no_,      rel_no_,
                                line_item_no_, pick_list_no_, 
                                qty_to_pick_,  qty_to_reserve_);

   IF part_tracking_session_id_ IS NULL THEN
      qty_picked_    := new_qty_picked_;
      qty_assigned_  := reserv_rec_.qty_assigned + qty_to_reserve_;
   ELSE
      qty_picked_    := 0;
      qty_assigned_  := 0;
   END IF;

   Update_License_Coverage_Qty___(order_no_, line_no_, rel_no_, line_item_no_, qty_picked_, qty_to_reserve_);
END Pick_On_Location___;


PROCEDURE Lock___ (
   order_no_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   info_       VARCHAR2(2000);

   CURSOR get_id IS
      SELECT rowid, ltrim(lpad(to_char(co.rowversion,'YYYYMMDDHH24MISS'),2000))
      FROM CUSTOMER_ORDER_TAB  co
      WHERE order_no = order_no_;
BEGIN
   OPEN get_id;
   FETCH get_id INTO objid_, objversion_;
   CLOSE get_id;
   --Customer_Order_API.Lock__(info_, objid_, objversion_);
END Lock___;


PROCEDURE Split_Serials___ (
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   shipment_id_           IN NUMBER,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   location_no_           IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   eng_chg_level_         IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   activity_seq_          IN NUMBER,
   handling_unit_id_      IN NUMBER,
   pick_list_no_          IN VARCHAR2,
   qty_to_pick_           IN NUMBER,
   input_qty_             IN NUMBER,
   input_unit_meas_       IN VARCHAR2,
   input_conv_factor_     IN NUMBER,
   input_variable_values_ IN VARCHAR2,
   serial_catch_tab_      IN Inventory_Part_In_Stock_API.Serial_Catch_Table,
   keep_remaining_qty_    IN BOOLEAN DEFAULT FALSE )
IS 
   qty_assigned_ NUMBER;   
BEGIN
   IF (serial_catch_tab_.COUNT = 0) THEN
      Error_SYS.Record_General(lu_name_, 'REPPICKNOSERIAL: No serials have been identified.');
   END IF;

   IF (serial_catch_tab_.COUNT != qty_to_pick_) THEN
      Error_SYS.Record_General(lu_name_, 'REPPICKSERCOUNT: The quantity to be picked is :P1 but the number of identified serials is :P2', qty_to_pick_, serial_catch_tab_.COUNT);
   END IF;
   qty_assigned_ := Customer_Order_Reservation_API.Get_Qty_Assigned(order_no_          => order_no_,
                                                                    line_no_           => line_no_,
                                                                    rel_no_            => rel_no_,
                                                                    line_item_no_      => line_item_no_,
                                                                    contract_          => contract_,
                                                                    part_no_           => part_no_,
                                                                    location_no_       => location_no_,
                                                                    lot_batch_no_      => lot_batch_no_,
                                                                    serial_no_         => '*',
                                                                    eng_chg_level_     => eng_chg_level_,
                                                                    waiv_dev_rej_no_   => waiv_dev_rej_no_,
                                                                    activity_seq_      => activity_seq_,
                                                                    handling_unit_id_  => handling_unit_id_,
                                                                    configuration_id_  => configuration_id_,
                                                                    pick_list_no_      => pick_list_no_,                                                                     
                                                                    shipment_id_       => shipment_id_);

   IF (qty_assigned_ < qty_to_pick_) THEN
      Customer_Order_Reservation_API.Modify_Qty_Assigned(order_no_               => order_no_,
                                                         line_no_                => line_no_,
                                                         rel_no_                 => rel_no_,
                                                         line_item_no_           => line_item_no_,
                                                         contract_               => contract_,
                                                         part_no_                => part_no_,
                                                         location_no_            => location_no_,
                                                         lot_batch_no_           => lot_batch_no_,
                                                         serial_no_              => '*',
                                                         eng_chg_level_          => eng_chg_level_,
                                                         waiv_dev_rej_no_        => waiv_dev_rej_no_,
                                                         activity_seq_           => activity_seq_,
                                                         handling_unit_id_       => handling_unit_id_,
                                                         pick_list_no_           => pick_list_no_,
                                                         configuration_id_       => configuration_id_,
                                                         shipment_id_            => shipment_id_,
                                                         qty_assigned_           => qty_to_pick_,
                                                         input_qty_              => input_qty_,
                                                         input_unit_meas_        => input_unit_meas_,
                                                         input_conv_factor_      => input_conv_factor_,
                                                         input_variable_values_  => input_variable_values_);
   END IF;

   Inventory_Part_In_Stock_API.Split_Into_Serials(contract_             => contract_,
                                                  part_no_              => part_no_,
                                                  configuration_id_     => configuration_id_,
                                                  location_no_          => location_no_,
                                                  lot_batch_no_         => lot_batch_no_,
                                                  eng_chg_level_        => eng_chg_level_,
                                                  waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                  activity_seq_         => activity_seq_,
                                                  handling_unit_id_     => handling_unit_id_,
                                                  serial_catch_tab_     => serial_catch_tab_,
                                                  reservation_          => TRUE);

   Customer_Order_Reservation_API.Split_Reservation_Into_Serials(order_no_             => order_no_,
                                                                 line_no_              => line_no_,
                                                                 rel_no_               => rel_no_,
                                                                 line_item_no_         => line_item_no_,
                                                                 contract_             => contract_,
                                                                 part_no_              => part_no_,
                                                                 configuration_id_     => configuration_id_,
                                                                 location_no_          => location_no_,
                                                                 lot_batch_no_         => lot_batch_no_,
                                                                 eng_chg_level_        => eng_chg_level_,
                                                                 waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                                 activity_seq_         => activity_seq_,
                                                                 handling_unit_id_     => handling_unit_id_,
                                                                 pick_list_no_         => pick_list_no_,
                                                                 shipment_id_          => shipment_id_,
                                                                 serial_catch_tab_     => serial_catch_tab_);

   IF ((qty_assigned_ > qty_to_pick_) AND (keep_remaining_qty_ = FALSE)) THEN
      Customer_Order_Reservation_API.Remove(order_no_             => order_no_,
                                            line_no_              => line_no_,
                                            rel_no_               => rel_no_,
                                            line_item_no_         => line_item_no_,
                                            contract_             => contract_,
                                            part_no_              => part_no_,
                                            location_no_          => location_no_,
                                            lot_batch_no_         => lot_batch_no_,
                                            serial_no_            => '*',
                                            eng_chg_level_        => eng_chg_level_,
                                            waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                            activity_seq_         => activity_seq_,
                                            handling_unit_id_     => handling_unit_id_,
                                            pick_list_no_         => pick_list_no_,
                                            configuration_id_     => configuration_id_, 
                                            shipment_id_          => shipment_id_);
   END IF;
END Split_Serials___;


PROCEDURE Update_License_Coverage_Qty___(
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   quantity_     IN NUMBER,
   qty_reserve_  IN NUMBER)
IS
BEGIN
   IF (Customer_Order_Flow_API.Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN
         DECLARE
            action_ VARCHAR2(20) := 'Pick';
         BEGIN
            Exp_License_Connect_Util_Api.Update_Coverage_Quantities(action_, order_no_, line_no_, rel_no_, line_item_no_, quantity_);
            IF (qty_reserve_ < 0) THEN
               action_ := 'UnreserveWhenPick';
               Exp_License_Connect_Util_Api.Update_Coverage_Quantities(action_, order_no_, line_no_, rel_no_, line_item_no_, -1 * qty_reserve_);
            END IF;
         END;
      $ELSE
         NULL;         
      $END
   END IF;
END Update_License_Coverage_Qty___;


-- Pick_Remaining_Lines___
--   Pick report a pick list with difference
PROCEDURE Pick_Remaining_Lines___ (
   shipment_id_tab_       OUT Shipment_API.Shipment_Id_Tab,
   pick_list_no_          IN  VARCHAR2,
   ship_location_no_      IN  VARCHAR2,
   process_shipments_     IN  BOOLEAN,
   trigger_shipment_flow_ IN  BOOLEAN )
IS
   order_no_            VARCHAR2(12);
   
   CURSOR get_con_orders IS
      SELECT order_no, shipment_id
        FROM consolidated_orders_tab
       WHERE pick_list_no = pick_list_no_;
BEGIN
   Report_Pick_List___(shipment_id_tab_         => shipment_id_tab_,
                       pick_list_no_            => pick_list_no_, 
                       location_no_             => ship_location_no_, 
                       process_shipments_       => process_shipments_,
                       trigger_shipment_flow_   => trigger_shipment_flow_);
   
   IF (Customer_Order_Pick_List_API.Is_Consolidated(pick_list_no_) = 1) THEN
      -- Report remaining reservations on pick list.
      FOR ord_ IN get_con_orders LOOP           
         -- 'Report' completed packages
         Report_Complete_Packages___(ord_.order_no);
         IF (ord_.shipment_id != 0) THEN
           Report_Complete_Ship_Pkgs___(ord_.shipment_id);
         END IF;
      END LOOP;
   ELSE
      -- Normal Pick List
      order_no_ := Customer_Order_Pick_List_API.Get_Order_No(pick_list_no_);
      -- 'Report' completed packages
      Report_Complete_Packages___(order_no_);
   END IF;
END Pick_Remaining_Lines___;

FUNCTION Remove_Duplicate_Lov_Values___ (
   old_lov_value_tab_ Lov_Value_Tab ) RETURN Lov_Value_Tab
IS
   new_lov_value_tab_ Lov_Value_Tab;
   lov_value_found_   BOOLEAN;
   index_             PLS_INTEGER := 1;
BEGIN
   IF (old_lov_value_tab_.COUNT > 0) THEN
      FOR i IN old_lov_value_tab_.FIRST..old_lov_value_tab_.LAST LOOP
         lov_value_found_ := FALSE;
         IF (new_lov_value_tab_.COUNT > 0) THEN
            FOR j IN new_lov_value_tab_.FIRST..new_lov_value_tab_.LAST LOOP
               IF (old_lov_value_tab_(i) = new_lov_value_tab_(j)) THEN
                  lov_value_found_ := TRUE;
                  EXIT;
               END IF;
            END LOOP;
         END IF;
         IF NOT (lov_value_found_) THEN
            new_lov_value_tab_(index_) := old_lov_value_tab_(i);
            index_ := index_ + 1;
         END IF;
      END LOOP;
   END IF;
   RETURN new_lov_value_tab_;
END Remove_Duplicate_Lov_Values___;


FUNCTION Get_Merged_Shipment_Id_Tab___ (
   shipment_id_tab1_   IN Shipment_API.Shipment_Id_Tab,
   shipment_id_tab2_   IN Shipment_API.Shipment_Id_Tab ) RETURN Shipment_API.Shipment_Id_Tab
IS
   shipment_id_tab_    Shipment_API.Shipment_Id_Tab;
   k_                  PLS_INTEGER := 0;
BEGIN
   shipment_id_tab_ := shipment_id_tab1_;
   IF (shipment_id_tab2_.COUNT > 0) THEN
      k_ := shipment_id_tab2_.FIRST;
      WHILE(k_ IS NOT NULL) LOOP
         shipment_id_tab_(k_) := shipment_id_tab2_(k_);
         k_                   := shipment_id_tab2_.NEXT(k_);
      END LOOP;
   END IF;   
   RETURN shipment_id_tab_;
END Get_Merged_Shipment_Id_Tab___;


PROCEDURE Raise_No_Value_Exist_Error___(
   column_description_  IN VARCHAR2,
   column_value_        IN VARCHAR2)
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
END Raise_No_Value_Exist_Error___;

PROCEDURE Raise_No_Picklist_Error___(
   column_value_  IN VARCHAR2,
   pick_list_no_  IN VARCHAR2)
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTINPICKLIST: The value :P1 does not exist on Pick List :P2.', column_value_, pick_list_no_);
END Raise_No_Picklist_Error___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Pick_Resevations_From_Header__
--   Pick resevations from attr_ with changes and pick rest of the pick_list_no_ without changes.
PROCEDURE Pick_Resevations_From_Header__(
   overpicked_lines_       OUT VARCHAR2,
   attr_                IN OUT VARCHAR2,
   session_id_          IN OUT NUMBER,
   shipment_id_message_ IN OUT VARCHAR2,
   pick_list_no_        IN     VARCHAR2,
   ship_location_no_    IN     VARCHAR2 )
IS
   info_                VARCHAR2(2000);
   all_reported_        NUMBER := 0;
   closed_lines_        NUMBER;
BEGIN
   
   Pick_Reservations__(info_                  => info_, 
                       all_reported_          => all_reported_, 
                       closed_lines_          => closed_lines_, 
                       overpicked_lines_      => overpicked_lines_, 
                       session_id_            => session_id_, 
                       shipment_id_message_   => shipment_id_message_,
                       attr_                  => attr_, 
                       pick_list_no_          => pick_list_no_, 
                       ship_location_no_      => ship_location_no_, 
                       pick_all_              => 1,
                       trigger_shipment_flow_ => 'FALSE');
                       
END Pick_Resevations_From_Header__;


-- Pick_Reservations__
--   Pick report a single reservation
PROCEDURE Pick_Reservations__ (
   info_                           OUT VARCHAR2,
   all_reported_                   OUT NUMBER,
   closed_lines_                   OUT NUMBER,
   overpicked_lines_               OUT VARCHAR2,
   session_id_                  IN OUT NUMBER,
   shipment_id_message_         IN OUT VARCHAR2,
   attr_                        IN     VARCHAR2,
   pick_list_no_                IN     VARCHAR2,
   ship_location_no_            IN     VARCHAR2,
   pick_all_                    IN     NUMBER   DEFAULT 0,
   trigger_shipment_flow_       IN     VARCHAR2 DEFAULT 'TRUE',
   validate_hu_struct_position_ IN     BOOLEAN  DEFAULT TRUE,
   add_hu_to_shipment_          IN     BOOLEAN  DEFAULT TRUE )
IS
   contract_                 VARCHAR2(5);   
   qty_assigned_             NUMBER;
   qty_picked_               NUMBER;
   ptr_                      NUMBER := NULL;
   name_                     VARCHAR2(30);
   value_                    VARCHAR2(2000);
   newattr_                  VARCHAR2(32000);
   line_rec_                 Customer_Order_Line_API.Public_Rec;
   head_state_               VARCHAR2(20);
   line_state_               VARCHAR2(20);   
   uses_shipment_inventory_  NUMBER;   
   ship_default_location_no_ VARCHAR2(35);
   k_                        PLS_INTEGER := 0;   
   from_header_              VARCHAR2(10) := 'FALSE';
   finalize_                 BOOLEAN := FALSE;
   overpick_attr_            VARCHAR2(32000);
   keep_remaining_qty_       BOOLEAN;
   old_session_id_           NUMBER;
   local_ship_location_no_   VARCHAR2(30);
   first_execution_          BOOLEAN := FALSE;
   
   CURSOR get_changed_orders(temp_session_id_ VARCHAR2) IS
      SELECT DISTINCT order_no
      FROM temporary_pick_reservation_tab
      WHERE session_id = temp_session_id_;
      
   CURSOR get_changed_reservations(close_line_ VARCHAR2) IS
      SELECT order_no, line_no, rel_no, line_item_no, contract, part_no, location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, configuration_id,
             pick_list_no, input_quantity, input_conv_factor, input_unit_meas, input_variable_values, catch_qty_to_pick, ship_location_no, part_tracking_session_id, 
             qty_to_pick, shipment_id, close_line, handling_unit_id, ship_handling_unit_id
        FROM temporary_pick_reservation_tab
       WHERE session_id = session_id_
         AND (close_line_ IS NULL OR close_line = close_line_)
      -- ORDER BY to prevent deadlock.
      ORDER BY part_no, location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no;

   CURSOR get_changed_lines IS
      SELECT DISTINCT order_no, line_no, rel_no, line_item_no, part_no, shipment_id
        FROM temporary_pick_reservation_tab
       WHERE session_id = session_id_;
   
   CURSOR get_overpicked_lines IS
      SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no, cor.shipment_id, col.contract, col.part_no, 
             cor.location_no, cor.lot_batch_no, cor.serial_no, cor.eng_chg_level, cor.waiv_dev_rej_no, cor.activity_seq, cor.handling_unit_id,
             cor.configuration_id
      FROM customer_order_line_tab col, customer_order_reservation_tab cor
      WHERE col.order_no     = cor.order_no
      AND   col.line_no      = cor.line_no
      AND   col.rel_no       = cor.rel_no
      AND   col.line_item_no = cor.line_item_no
      AND   cor.pick_list_no = pick_list_no_
      AND ((col.qty_picked + col.qty_shipped) > col.revised_qty_due);
      
   shipment_id_tab1_         Shipment_API.Shipment_Id_Tab;
   shipment_id_tab2_         Shipment_API.Shipment_Id_Tab;
   merged_shipment_id_tab_   Shipment_API.Shipment_Id_Tab;
BEGIN
   uses_shipment_inventory_ := Customer_Order_Pick_List_API.Uses_Shipment_Inventory(pick_list_no_);
   
   -- If the pick list uses shipment inventory and ship_location_no is not passed, get it from the header.
   Trace_SYS.Message('uses_shipment_inventory_: ' ||uses_shipment_inventory_||'local_ship_location_no_: '||local_ship_location_no_ );
   IF (uses_shipment_inventory_ =  1) THEN
      IF (ship_location_no_ IS NULL) THEN
         local_ship_location_no_ := Customer_Order_Pick_List_API.Get_Ship_Inventory_Location_No(pick_list_no_);
      ELSE
         local_ship_location_no_ := ship_location_no_;
      END IF;   
   END IF;
   
   overpicked_lines_   := NULL;
   
   IF session_id_ IS NULL THEN
      session_id_      := Temporary_Pick_Reservation_API.Get_Next_Session_Id();
      -- this method could be called multiple times from the client due to length limitation in attr_, this var is used identify the first method call
      first_execution_ := TRUE;
   END IF;
   
   IF (Customer_Order_Pick_List_API.Get_Picking_Confirmed_Db(pick_list_no_) = 'PICKED') THEN
      Error_SYS.Record_General(lu_name_, 'ALREADYPICKED: The pick list :P1 has already been pick reported.', pick_list_no_);
   END IF;
   
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'ORDER_NO') THEN
         Client_SYS.Clear_Attr(newattr_);
         Client_SYS.Add_To_Attr('SESSION_ID', session_id_, newattr_);
         Client_SYS.Add_To_Attr('ORDER_NO', value_, newattr_);
         Client_SYS.Add_To_Attr('PICK_LIST_NO', pick_list_no_, newattr_);
         Trace_SYS.Field('in pick_reservations 2 order_no ',value_);
      ELSIF (name_ = 'LINE_NO') THEN
         Client_SYS.Add_To_Attr('LINE_NO', value_, newattr_);
      ELSIF (name_ = 'REL_NO') THEN
         Client_SYS.Add_To_Attr('REL_NO', value_, newattr_);
      ELSIF (name_ = 'LINE_ITEM_NO') THEN
         Client_SYS.Add_To_Attr('LINE_ITEM_NO', Client_SYS.Attr_Value_To_Number(value_), newattr_);
      ELSIF (name_ = 'CONTRACT') THEN
         contract_ := value_;
         Client_SYS.Add_To_Attr('CONTRACT', value_, newattr_);
      ELSIF (name_ = 'PART_NO') THEN
         Client_SYS.Add_To_Attr('PART_NO', value_, newattr_);
      ELSIF (name_ = 'CONFIGURATION_ID') THEN
         Client_SYS.Add_To_Attr('CONFIGURATION_ID', value_, newattr_);
      ELSIF (name_ = 'LOCATION_NO') THEN
         Client_SYS.Add_To_Attr('LOCATION_NO', value_, newattr_);
      ELSIF (name_ = 'LOT_BATCH_NO') THEN
         Client_SYS.Add_To_Attr('LOT_BATCH_NO', value_, newattr_);
      ELSIF (name_ = 'SERIAL_NO') THEN
         Client_SYS.Add_To_Attr('SERIAL_NO', value_, newattr_);
      ELSIF (name_ = 'ENG_CHG_LEVEL') THEN
         Client_SYS.Add_To_Attr('ENG_CHG_LEVEL', value_, newattr_);
      ELSIF (name_ = 'WAIV_DEV_REJ_NO') THEN
         Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO', value_, newattr_);
      ELSIF (name_ = 'INPUT_QUANTITY') THEN
         Client_SYS.Add_To_Attr('INPUT_QUANTITY', Client_SYS.Attr_Value_To_Number(value_), newattr_);
      ELSIF (name_ = 'INPUT_CONV_FACTOR') THEN
         Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR', Client_SYS.Attr_Value_To_Number(value_), newattr_);
      ELSIF (name_ = 'INPUT_UNIT_MEAS') THEN
         Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS', value_, newattr_);
      ELSIF (name_ = 'INPUT_VARIABLE_VALUES') THEN
         Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES', value_, newattr_);
      ELSIF (name_ = 'ACTIVITY_SEQ') THEN
         Client_SYS.Add_To_Attr('ACTIVITY_SEQ', Client_SYS.Attr_Value_To_Number(value_), newattr_);
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', Client_SYS.Attr_Value_To_Number(value_), newattr_);
      ELSIF (name_ = 'CATCH_QTY_TO_PICK') THEN
         Client_SYS.Add_To_Attr('CATCH_QTY_TO_PICK', Client_SYS.Attr_Value_To_Number(value_), newattr_);
      ELSIF (name_ = 'PART_TRACKING_SESSION_ID') THEN
         Client_SYS.Add_To_Attr('PART_TRACKING_SESSION_ID', Client_SYS.Attr_Value_To_Number(value_), newattr_);
      ELSIF (name_ = 'SHIPMENT_ID') THEN
         Client_SYS.Add_To_Attr('SHIPMENT_ID', NVL(Client_SYS.Attr_Value_To_Number(value_), 0), newattr_);
      ELSIF (name_ = 'SHIP_HANDLING_UNIT_ID') THEN
         Client_SYS.Add_To_Attr('SHIP_HANDLING_UNIT_ID', NVL(Client_SYS.Attr_Value_To_Number(value_), 0), newattr_);   
      ELSIF (name_ = 'QTY_TO_PICK') THEN        
         Client_SYS.Add_To_Attr('QTY_TO_PICK', Client_SYS.Attr_Value_To_Number(value_), newattr_);                  
         Temporary_Pick_Reservation_API.Create_New__(newattr_ );       
      ELSIF (name_ = 'CLOSE_LINE') THEN
         Client_SYS.Add_To_Attr('CLOSE_LINE', value_, newattr_);
      ELSIF (name_ = 'FROM_HEADER') THEN
         from_header_ := value_;
      ELSIF (name_ = 'LAST_LINE') THEN
         finalize_ := TRUE;
      END IF;
   END LOOP;
   
   IF finalize_ THEN
      Trace_SYS.Message('finalize_: TRUE');
      old_session_id_ := session_id_;
      IF (from_header_ = 'FALSE' ) THEN
         FOR rec_ IN get_changed_orders(old_session_id_) LOOP
            -- Create history record for partial picks.
            IF (NOT Pick_List_Part_Reported___(pick_list_no_, rec_.order_no)) THEN
               Customer_Order_History_API.New(rec_.order_no, Language_SYS.Translate_Constant(lu_name_, 'PICKLISTPARTPICKED: Picklist :P1 partially picked', NULL, pick_list_no_));
            END IF; 
         END LOOP;
      END IF;

      Inventory_Event_Manager_API.Start_Session;
      FOR rec_ IN get_changed_reservations(NULL) LOOP
         IF (NVL(rec_.shipment_id, 0) != 0) THEN
            shipment_id_tab1_(rec_.shipment_id) := rec_.shipment_id;
         END IF;
         
         -- Check if the order/shipment type allowes partially picking
         IF (((rec_.shipment_id = 0) AND (Cust_Order_Type_API.Get_Allow_Partial_Picking_Db(Customer_Order_API.Get_Order_Id(rec_.order_no)) = 'TRUE')) 
             OR ((rec_.shipment_id != 0) AND (Shipment_Type_API.Get_Allow_Partial_Picking_Db(Shipment_API.Get_Shipment_Type(rec_.shipment_id)) = 'TRUE'))) THEN
            IF ((from_header_ = 'TRUE') 
                OR (local_ship_location_no_ IS NULL)
                OR (NVL(rec_.close_line, '0') = '1')) THEN
               keep_remaining_qty_ := FALSE;
            ELSE
               keep_remaining_qty_ := TRUE;
            END IF;
         ELSE
            keep_remaining_qty_ := FALSE;
         END IF;     
         
         -- Pick on selected location.
         Pick_On_Location___(info_                          => info_,
                             qty_picked_                    => qty_picked_, 
                             qty_assigned_                  => qty_assigned_,
                             order_no_                      => rec_.order_no, 
                             line_no_                       => rec_.line_no, 
                             rel_no_                        => rec_.rel_no, 
                             line_item_no_                  => rec_.line_item_no, 
                             shipment_id_                   => rec_.shipment_id,
                             contract_                      => contract_, 
                             part_no_                       => rec_.part_no,
                             location_no_                   => rec_.location_no, 
                             lot_batch_no_                  => rec_.lot_batch_no, 
                             serial_no_                     => rec_.serial_no, 
                             eng_chg_level_                 => rec_.eng_chg_level, 
                             waiv_dev_rej_no_               => rec_.waiv_dev_rej_no,
                             pick_list_no_                  => pick_list_no_, 
                             ship_location_no_              => local_ship_location_no_, 
                             activity_seq_                  => NVL(rec_.activity_seq, 0),
                             handling_unit_id_              => rec_.handling_unit_id,
                             qty_to_pick_                   => rec_.qty_to_pick,
                             catch_qty_to_pick_             => rec_.catch_qty_to_pick, 
                             input_qty_                     => rec_.input_quantity, 
                             input_unit_meas_               => rec_.input_unit_meas, 
                             input_conv_factor_             => rec_.input_conv_factor, 
                             input_variable_values_         => rec_.input_variable_values,
                             keep_remaining_qty_            => keep_remaining_qty_, 
                             part_tracking_session_id_      => rec_.part_tracking_session_id,
                             validate_hu_struct_position_   => validate_hu_struct_position_,
                             add_hu_to_shipment_            => add_hu_to_shipment_ ,
                             ship_handling_unit_id_         => (CASE WHEN rec_.ship_handling_unit_id = 0 THEN NULL ELSE rec_.ship_handling_unit_id END));

         -- Check if any packages have been picked.
         Report_Complete_Packages___(rec_.order_no);
         IF (rec_.shipment_id != 0) THEN
            Report_Ship_Pkg_If_Complete___(rec_.shipment_id, rec_.order_no, rec_.line_no, rec_.rel_no);
         END IF;
      END LOOP;
      
      IF (pick_all_ = 1) THEN
         Pick_Remaining_Lines___ (shipment_id_tab_       => shipment_id_tab2_,
                                  pick_list_no_          => pick_list_no_,   
                                  ship_location_no_      => local_ship_location_no_, 
                                  process_shipments_     => FALSE,
                                  trigger_shipment_flow_ => FALSE);
      END IF;
   
      -- Check if line should be closed.
      FOR rec_ IN get_changed_reservations('1') LOOP
         IF (Reserve_Customer_Order_API.Unpicked_Reservations_Exist__(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no) = 1) THEN
            -- Not possible to close line if not pick reported pick list for same order line exists.
            Error_SYS.Record_General(lu_name_, 'RESEXISTS: The order line has reservations that have not been picked. The order line can not be closed.');
         ELSE
            line_state_ := Customer_Order_Line_API.Get_State(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
            head_state_ := Customer_Order_API.Get_State(rec_.order_no);
            Close_Customer_Order_API.Close_Order_Line__(head_state_, line_state_, rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
         END IF;
      END LOOP;
      
      closed_lines_ := 0;
      
      -- Check if there is any lines fully picked. In that case -> clear remaining reservations.
      FOR rec_ IN get_changed_lines LOOP
         Customer_Order_Line_Hist_API.New(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no,
         Create_Picked_Constant___(pick_list_no_));

         line_rec_ := Customer_Order_Line_API.Get(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);

         Trace_SYS.Field('Revised Qty Due', line_rec_.revised_qty_due);
         Trace_SYS.Field('Qty Picked', line_rec_.qty_picked);
         
         IF ((line_rec_.qty_picked + line_rec_.qty_shipped) > line_rec_.revised_qty_due) THEN
            -- At least one of the picked lines was picked so the picked_qty > revised_qty_due.
            Trace_SYS.Message('OverPicked');
            overpicked_lines_ := 'TRUE';
         END IF;

         IF (line_rec_.qty_picked >= line_rec_.revised_qty_due) AND
             More_Reservations_Exist___(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, pick_list_no_) THEN
            Clear_Unpicked_Reservations(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, pick_list_no_, NVL(rec_.shipment_id, 0));
            closed_lines_ := 1;
         END IF;
      END LOOP;

      IF (pick_all_ = 1) THEN                         
         -- Generated the session_id_ again.
         session_id_ := Temporary_Pick_Reservation_API.Get_Next_Session_Id();
         -- Added all the over picked rows to the Temporary_Pick_Reservation_Tab to display in the 'Over Picked Order Lines' dialog box.
         FOR rec_ IN get_overpicked_lines LOOP            
            Client_SYS.Add_To_Attr('SESSION_ID', session_id_, overpick_attr_);
            Client_SYS.Add_To_Attr('ORDER_NO', rec_.order_no, overpick_attr_);
            Client_SYS.Add_To_Attr('LINE_NO', rec_.line_no, overpick_attr_);
            Client_SYS.Add_To_Attr('REL_NO', rec_.rel_no, overpick_attr_);
            Client_SYS.Add_To_Attr('LINE_ITEM_NO', rec_.line_item_no, overpick_attr_);
            Client_SYS.Add_To_Attr('SHIPMENT_ID', rec_.shipment_id, overpick_attr_);
            Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, overpick_attr_);
            Client_SYS.Add_To_Attr('PART_NO', rec_.part_no, overpick_attr_);
            Client_SYS.Add_To_Attr('LOCATION_NO', rec_.location_no, overpick_attr_);
            Client_SYS.Add_To_Attr('LOT_BATCH_NO', rec_.lot_batch_no, overpick_attr_);
            Client_SYS.Add_To_Attr('SERIAL_NO', rec_.serial_no, overpick_attr_);
            Client_SYS.Add_To_Attr('ENG_CHG_LEVEL', rec_.eng_chg_level, overpick_attr_);
            Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO', rec_.waiv_dev_rej_no, overpick_attr_);
            Client_SYS.Add_To_Attr('ACTIVITY_SEQ', rec_.activity_seq, overpick_attr_);
            Client_SYS.Add_To_Attr('CONFIGURATION_ID', rec_.configuration_id, overpick_attr_);
            Client_SYS.Add_To_Attr('PICK_LIST_NO', pick_list_no_, overpick_attr_);
            Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', rec_.handling_unit_id, overpick_attr_);
            Temporary_Pick_Reservation_API.Create_New__(overpick_attr_ );
            overpicked_lines_ := 'TRUE';
         END LOOP;
      END IF;
      
      Inventory_Event_Manager_API.Finish_Session;

      -- Check if the picklist has been completly pick reported.
      IF Pick_List_Reported___(pick_list_no_) THEN
         -- Completly reported.
         Trace_SYS.Message('Picklist completly pick reported');
         Customer_Order_Pick_List_API.Set_Picking_Confirmed(pick_list_no_, contract_);
         all_reported_ := 1;
         -- Create history record when fully picked.
         FOR rec_ IN get_changed_orders(old_session_id_) LOOP
            Customer_Order_History_API.New(rec_.order_no, Create_Picked_Constant___(pick_list_no_));
         END LOOP;
      ELSE
         -- Not completly reported.
         Trace_SYS.Message('Picklist not completly pick reported');
         ptr_          := NULL;
         all_reported_ := 0;
         FOR rec_ IN get_changed_lines LOOP
            IF More_Reservations_Exist___(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, pick_list_no_) THEN
               IF NOT ((rec_.shipment_id = 0 AND Cust_Order_Type_API.Get_Allow_Partial_Picking_Db(Customer_Order_API.Get_Order_Id(rec_.order_no)) = 'TRUE') OR
                       (rec_.shipment_id != 0 AND Shipment_Type_API.Get_Allow_Partial_Picking_Db(Shipment_API.Get_Shipment_Type(rec_.shipment_id)) = 'TRUE')) THEN
                  -- More reservations exist on picked order line.
                  Trace_SYS.Message('More reservations exist on picked order line');
                  all_reported_ := -1;
                  EXIT;
               END IF;
            END IF;
         END LOOP;
      END IF;
      
      IF (pick_all_ = 1) THEN
         -- After order history creation done, clear the records of initial session id since over-picked ones copied to new session id 
         Temporary_Pick_Reservation_API.Clear_Session(old_session_id_);
      END IF;
   END IF;
   
   -- Modify the header to contain the latest picked to location.
   IF(local_ship_location_no_ IS NOT NULL) THEN
      Customer_Order_Pick_List_API.Modify_Ship_Inventory_Loc_No(pick_list_no_, local_ship_location_no_);
   END IF;
   
   merged_shipment_id_tab_ := Get_Merged_Shipment_Id_Tab___(shipment_id_tab1_, shipment_id_tab2_);
   IF (merged_shipment_id_tab_.COUNT > 0) THEN
      IF first_execution_ THEN
         shipment_id_message_ := Message_Sys.Construct('SHIPMENT_ID');
      END IF; 
      k_ := merged_shipment_id_tab_.FIRST;
      WHILE(k_ IS NOT NULL) LOOP 
         ship_default_location_no_ := Shipment_API.Get_Ship_Inventory_Location_No(merged_shipment_id_tab_(k_));                  
         IF (ship_default_location_no_ IS NULL) AND (local_ship_location_no_ IS NOT NULL) THEN
            Customer_Order_Pick_List_API.Modify_Pick_Ship_Location(merged_shipment_id_tab_(k_), 
                                                                   local_ship_location_no_);
            Shipment_API.Modify_Ship_Inv_Location_No(merged_shipment_id_tab_(k_), 
                                                     local_ship_location_no_);
         END IF;
         
         IF (trigger_shipment_flow_ = 'TRUE') THEN
            -- Trigger shipment process.
            Shipment_Flow_API.Start_Shipment_Flow(merged_shipment_id_tab_(k_), 40);
         END IF;
         Message_SYS.Add_Attribute(shipment_id_message_, 'SHIPMENT_ID', merged_shipment_id_tab_(k_));
         k_ := merged_shipment_id_tab_.NEXT(k_);
      END LOOP;
   END IF; 
END Pick_Reservations__;

-- Modify_Qty_Assigned__
PROCEDURE Modify_Qty_Assigned__ (
   pick_list_no_ IN  VARCHAR2,
   attr_         IN  VARCHAR2 )
IS
   reserv_rec_             Customer_Order_Reservation_API.Public_Rec;
   contract_               VARCHAR2(5) := NULL;
   order_no_               VARCHAR2(12) := NULL;
   line_no_                VARCHAR2(4) := NULL;
   rel_no_                 VARCHAR2(4) := NULL;
   line_item_no_           NUMBER;
   configuration_id_       VARCHAR2(50);
   part_no_                VARCHAR2(25) := NULL;
   location_no_            VARCHAR2(35) := NULL;
   lot_batch_no_           VARCHAR2(20) := NULL;
   serial_no_              VARCHAR2(50) := NULL;
   eng_chg_level_          VARCHAR2(6) := NULL;
   waiv_dev_rej_no_        VARCHAR2(15) := NULL;
   activity_seq_           NUMBER;
   handling_unit_id_       NUMBER;
   shipment_id_            NUMBER;
   catch_quantity_         NUMBER := NULL;
   qty_picked_             NUMBER;
   old_qty_picked_         NUMBER;
   old_qty_assigned_       NUMBER;
   new_qty_assigned_       NUMBER;
   qty_to_unreserve_       NUMBER;
   reservation_exist_      BOOLEAN;
   ptr_                    NUMBER := NULL;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
BEGIN
   
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Trace_SYS.Message('***attr_name_**** ' || name_ || ', ***attr_value_**** ' || value_);
      IF (name_ = 'ORDER_NO') THEN
         order_no_ := value_;
      ELSIF (name_ = 'LINE_NO') THEN
         line_no_ := value_;
      ELSIF (name_ = 'REL_NO') THEN
         rel_no_ := value_;
      ELSIF (name_ = 'LINE_ITEM_NO') THEN
         line_item_no_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'PART_NO') THEN
         part_no_ := value_;
      ELSIF (name_ = 'CONFIGURATION_ID') THEN
         configuration_id_ := value_;
      ELSIF (name_ = 'LOCATION_NO') THEN
         location_no_ := value_;
      ELSIF (name_ = 'LOT_BATCH_NO') THEN
         lot_batch_no_ := value_;
      ELSIF (name_ = 'SERIAL_NO') THEN
         serial_no_ := value_;
      ELSIF (name_ = 'ENG_CHG_LEVEL') THEN
         eng_chg_level_ := value_;
      ELSIF (name_ = 'WAIV_DEV_REJ_NO') THEN
         waiv_dev_rej_no_ := value_;
      ELSIF (name_ = 'ACTIVITY_SEQ') THEN
         activity_seq_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'SHIPMENT_ID') THEN
         shipment_id_ := NVL(Client_SYS.Attr_Value_To_Number(value_), 0);
      ELSIF (name_ = 'QTY_PICKED') THEN        
         qty_picked_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'OLD_QTY_PICKED') THEN        
         old_qty_picked_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'OLD_QTY_ASSIGNED') THEN        
         old_qty_assigned_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;
   END LOOP;
   
   IF qty_picked_ > old_qty_assigned_ THEN 
      new_qty_assigned_ := 0;
      qty_to_unreserve_ := old_qty_assigned_;
   ELSE 
      new_qty_assigned_ := old_qty_assigned_ - qty_picked_;
      qty_to_unreserve_ := qty_picked_;
   END IF;
   
   reservation_exist_ := Customer_Order_Reservation_API.Exists(order_no_, line_no_, rel_no_, line_item_no_, contract_, part_no_, 
                                                               location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, 
                                                               activity_seq_, handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_);
   
   IF  reservation_exist_ THEN 
      Inventory_Event_Manager_API.Start_Session;
      
      IF (old_qty_picked_ = 0 AND new_qty_assigned_ = 0)  THEN
         -- Remove reservations.
         Trace_SYS.Message('Delete reservations');
         Customer_Order_Reservation_API.Remove(order_no_             => order_no_, 
                                               line_no_              => line_no_, 
                                               rel_no_               => rel_no_, 
                                               line_item_no_         => line_item_no_,
                                               contract_             => contract_, 
                                               part_no_              => part_no_, 
                                               location_no_          => location_no_, 
                                               lot_batch_no_         => lot_batch_no_,
                                               serial_no_            => serial_no_, 
                                               eng_chg_level_        => eng_chg_level_, 
                                               waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                               activity_seq_         => activity_seq_, 
                                               handling_unit_id_     => handling_unit_id_,
                                               pick_list_no_         => pick_list_no_, 
                                               configuration_id_     => configuration_id_, 
                                               shipment_id_          => shipment_id_);            
      ELSE
         Trace_SYS.Message('Modify Reservations');
         -- Modify assigned quantity.
         Customer_Order_Reservation_API.Modify_Qty_Assigned(order_no_             => order_no_, 
                                                            line_no_              => line_no_, 
                                                            rel_no_               => rel_no_, 
                                                            line_item_no_         => line_item_no_,
                                                            contract_             => contract_, 
                                                            part_no_              => part_no_, 
                                                            location_no_          => location_no_, 
                                                            lot_batch_no_         => lot_batch_no_,
                                                            serial_no_            => serial_no_, 
                                                            eng_chg_level_        => eng_chg_level_, 
                                                            waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                            activity_seq_         => activity_seq_, 
                                                            handling_unit_id_     => handling_unit_id_,
                                                            pick_list_no_         => pick_list_no_,
                                                            configuration_id_     => configuration_id_, 
                                                            shipment_id_          => shipment_id_,
                                                            qty_assigned_         => new_qty_assigned_,
                                                            input_qty_            => reserv_rec_.input_qty, 
                                                            input_unit_meas_      => reserv_rec_.input_unit_meas, 
                                                            input_conv_factor_    => reserv_rec_.input_conv_factor, 
                                                            input_variable_values_=> reserv_rec_.input_variable_values);            
      END IF;

      -- Reserve/Unreserve in inventory.         
      -- Unreserve single parts
      Trace_SYS.Message('Unreserve single parts');

      Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_    => catch_quantity_, 
                                               contract_          => contract_, 
                                               part_no_           => part_no_, 
                                               configuration_id_  => configuration_id_,
                                               location_no_       => location_no_, 
                                               lot_batch_no_      => lot_batch_no_, 
                                               serial_no_         => serial_no_,
                                               eng_chg_level_     => eng_chg_level_,
                                               waiv_dev_rej_no_   => waiv_dev_rej_no_, 
                                               activity_seq_      => activity_seq_,
                                               handling_unit_id_  => handling_unit_id_,
                                               quantity_          => -qty_to_unreserve_);         
      Trace_SYS.Message('Modify Line');

      Modify_Pick_Reported_Line___(order_no_, line_no_, rel_no_, line_item_no_,
                                   pick_list_no_, old_qty_picked_, -qty_to_unreserve_);

      Inventory_Event_Manager_API.Finish_Session;
   END IF;
   
END Modify_Qty_Assigned__;


-- Report_Picking__
--   Report picking for an order or a pick list
PROCEDURE Report_Picking__ (
   order_no_            IN VARCHAR2,
   pick_list_no_        IN VARCHAR2,
   location_no_         IN VARCHAR2 )
IS
   shipment_id_tab_      Shipment_API.Shipment_Id_Tab;
   
   CURSOR get_unreported_pick_lists IS
      SELECT pick_list_no
      FROM   CUSTOMER_ORDER_PICK_LIST_TAB
      WHERE  order_no          = order_no_
      AND    picking_confirmed = 'UNPICKED';
BEGIN
   IF (pick_list_no_ IS NULL) THEN
      Inventory_Event_Manager_API.Start_Session;
      -- Report all unreported pick lists connected to current order
      FOR next_ IN get_unreported_pick_lists LOOP
         Report_Pick_List___(shipment_id_tab_       => shipment_id_tab_,
                             pick_list_no_          => next_.pick_list_no, 
                             location_no_           => location_no_, 
                             process_shipments_     => TRUE,
                             trigger_shipment_flow_ => FALSE);
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   ELSE
      -- Report one specific pick list connected to currenct order
      Report_Pick_List___(shipment_id_tab_       => shipment_id_tab_,
                          pick_list_no_          => pick_list_no_,
                          location_no_           => location_no_,
                          process_shipments_     => TRUE,
                          trigger_shipment_flow_ => FALSE);
   END IF;

   -- 'Report' completed packages
   Report_Complete_Packages___(order_no_);
END Report_Picking__;


-- Code_Picked_Locations_Single__
--   Create an attribute string containing all reservations with parts picked
--   for an order line. Attribute string for all existing locations and its
--   reported qty where current order line exist.
@UncheckedAccess
FUNCTION Code_Picked_Locations_Single__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   attr_        VARCHAR2(2000) := NULL;
   fsep_        VARCHAR2(1)    := Client_SYS.field_separator_;
   rsep_        VARCHAR2(1)    := Client_SYS.record_separator_;
   contract_    CUSTOMER_ORDER_LINE_TAB.contract%TYPE;
   part_no_     CUSTOMER_ORDER_LINE_TAB.part_no%TYPE;

   CURSOR get_qty_available IS
      SELECT location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq,
             handling_unit_id, SUM(qty_picked) qty_to_deliver, SUM(catch_qty) catch_qty_to_deliver
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no      = order_no_
      AND    line_no       = line_no_
      AND    rel_no        = rel_no_
      AND    line_item_no  = line_item_no_
      AND    contract      = contract_
      AND    part_no       = part_no_
      AND    shipment_id   = 0
      AND    qty_picked    > 0
      GROUP BY location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id;
BEGIN
   contract_ := Customer_Order_Line_API.Get_Contract(order_no_, line_no_, rel_no_, line_item_no_);
   part_no_  := Customer_Order_Line_API.Get_Part_No(order_no_, line_no_, rel_no_, line_item_no_);

   FOR get_next_ IN get_qty_available LOOP
      attr_ := attr_ || 'QTY_PICKED'      || fsep_ || get_next_.qty_to_deliver  || rsep_;
      -- adding null values for input values, because it is important that this string matches the strings
      -- unpacked and recreated in both clients that use this string (dlgShipDiffInv.tblShipInv and dlgLoadListDiffInv.tblShipInv)
      attr_ := attr_ || 'INPUT_UNIT_MEAS'       || fsep_ || ''  || rsep_;
      attr_ := attr_ || 'INPUT_QTY'             || fsep_ || ''  || rsep_;
      attr_ := attr_ || 'INPUT_CONV_FACTOR'     || fsep_ || ''  || rsep_;
      attr_ := attr_ || 'INPUT_VARIABLE_VALUES' || fsep_ || ''  || rsep_;
      attr_ := attr_ || 'LOCATION_NO'        || fsep_ || get_next_.location_no      || rsep_;
      attr_ := attr_ || 'LOT_BATCH_NO'       || fsep_ || get_next_.lot_batch_no     || rsep_;
      attr_ := attr_ || 'SERIAL_NO'          || fsep_ || get_next_.serial_no        || rsep_;
      attr_ := attr_ || 'ENG_CHG_LEVEL'      || fsep_ || get_next_.eng_chg_level    || rsep_;
      attr_ := attr_ || 'WAIV_DEV_REJ_NO'    || fsep_ || get_next_.waiv_dev_rej_no  || rsep_;
      attr_ := attr_ || 'ACTIVITY_SEQ'       || fsep_ || get_next_.activity_seq     || rsep_;
      attr_ := attr_ || 'HANDLING_UNIT_ID'   || fsep_ || get_next_.handling_unit_id || rsep_;
      IF get_next_.catch_qty_to_deliver IS NULL THEN
         attr_ := attr_ || 'CATCH_QTY'       || fsep_ || 'NULL'  || rsep_;
      ELSE
         attr_ := attr_ || 'CATCH_QTY'       || fsep_ || get_next_.catch_qty_to_deliver  || rsep_;
      END IF;
      attr_ := attr_ || 'QTY_TO_DELIVER'  || fsep_ || get_next_.qty_to_deliver  || rsep_;
   END LOOP;

   RETURN attr_;
EXCEPTION
   WHEN value_error THEN
      RETURN 'SIZE_LIMITED';
END Code_Picked_Locations_Single__;


-- Start_Report_Consol_Pl__
--   Client interface for start pick reporting a consolidated pick list.
PROCEDURE Start_Report_Consol_Pl__ (
   attr_ IN VARCHAR2 )
IS
   description_  VARCHAR2(200);
BEGIN
   Trace_SYS.Field('attr_', attr_);
   description_ := Language_SYS.Translate_Constant(lu_name_, 'REPORT_CONSOLIDATED: Report Consolidated Pick List');
   Transaction_SYS.Deferred_Call('PICK_CUSTOMER_ORDER_API.Report_Consol_Pick_List__', attr_, description_);
END Start_Report_Consol_Pl__;


-- Pick_List_Connected__
--   Check if the specified pick list is connected to the specified order
--   If picklist has one or more lines connected to a load list,
--   return value = 1, otherwise 0.
@UncheckedAccess
FUNCTION Pick_List_Connected__ (
   pick_list_no_ IN VARCHAR2,
   order_no_     IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER;

   CURSOR find_connected_lines IS
      SELECT 1
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no     = order_no_
      AND    pick_list_no = pick_list_no_
      AND    Cust_Order_Load_List_API.Get_Load_Id(order_no, line_no, rel_no, line_item_no) IS NOT NULL;
BEGIN
   OPEN  find_connected_lines;
   FETCH find_connected_lines INTO found_;
   IF (find_connected_lines%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE find_connected_lines;
   RETURN found_;
END Pick_List_Connected__;



-- Report_Consol_Pick_List__
--   Pick report a consolidated pick list.
PROCEDURE Report_Consol_Pick_List__ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_            VARCHAR2(5);
   pick_list_no_        VARCHAR2(15);
   location_no_         VARCHAR2(35);
   ptr_                 NUMBER;
   name_                VARCHAR2(30);
   value_               VARCHAR2(2000);
   shipment_id_tab_     Shipment_API.Shipment_Id_Tab;

   CURSOR get_con_orders(not_filter_shipment_ IN VARCHAR2) IS
      SELECT order_no
      FROM   consolidated_orders_tab
      WHERE  pick_list_no = pick_list_no_ 
      AND   (not_filter_shipment_ = 'TRUE' OR shipment_id = 0);
   
   CURSOR get_con_shipments IS
      SELECT DISTINCT shipment_id
      FROM   consolidated_orders_tab
      WHERE  pick_list_no = pick_list_no_
      AND    shipment_id != 0;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   -- Retrieve parameters from the attribute string
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'PICK_LIST_NO') THEN
         pick_list_no_ := value_;
      ELSIF (name_ = 'LOCATION_NO') THEN
         location_no_ := value_;
      ELSIF (name_ = 'CONTRACT') THEN
         contract_ := value_;
         Report_Pick_List___(shipment_id_tab_       => shipment_id_tab_,
                             pick_list_no_          => pick_list_no_, 
                             location_no_           => location_no_, 
                             process_shipments_     => TRUE,
                             trigger_shipment_flow_ => FALSE);

         FOR ord_ IN get_con_orders('TRUE') LOOP
            Report_Complete_Packages___(ord_.order_no);
         END LOOP;

         Customer_Order_Pick_List_API.Set_Picking_Confirmed(pick_list_no_, contract_);

         Trace_SYS.Field('Now Calling Set_Picking_Confirmed from Report_Consol_Pick_List - contract_', contract_);
         Trace_SYS.Field('pick_list_no_', pick_list_no_);
         -- Send the orders into the flow  (what if parts of the order is already in the flow???)
         FOR ord_ IN get_con_orders('FALSE') LOOP
            To_Order_Flow_When_Picked__(ord_.order_no);
         END LOOP;
         FOR rec_ IN get_con_shipments LOOP
            Report_Complete_Ship_Pkgs___(rec_.shipment_id);
            -- Trigger shipment process.
            Shipment_Flow_API.Start_Shipment_Flow(rec_.shipment_id, 40);
         END LOOP;
      END IF;      
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Report_Consol_Pick_List__;


-- Pick_Report_Shipment__
--   Report picking of customer order lines connected to a Shipment for a given location_no, by updating all its pick list shipment location no.
PROCEDURE Pick_Report_Shipment__ (
   shipment_id_ IN NUMBER,
   location_no_ IN VARCHAR2 )
IS
   contract_            VARCHAR2(5);
   shipment_id_tab_     Shipment_API.Shipment_Id_Tab;
   
   CURSOR get_pick_lists IS
      SELECT DISTINCT cop.pick_list_no
      FROM CUSTOMER_ORDER_PICK_LIST_TAB cop, consolidated_orders_tab con
      WHERE con.shipment_id = shipment_id_
      AND   con.pick_list_no = cop.pick_list_no
      AND   cop.picking_confirmed = 'UNPICKED'
      AND   cop.consolidated_flag = 'CONSOLIDATED';

   CURSOR get_con_orders(pick_list_no_ IN VARCHAR2) IS
      SELECT order_no
      FROM   consolidated_orders_tab
      WHERE  pick_list_no = pick_list_no_
      AND    shipment_id  = shipment_id_;
BEGIN
   contract_ := Shipment_API.Get_Contract(shipment_id_); 

   Shipment_Flow_API.Lock_Shipment__(shipment_id_);      
   -- Note: Pick Report Consolidated Pick Lists for the Shipment
   Inventory_Event_Manager_API.Start_Session;
   FOR rec_ IN get_pick_lists LOOP
      Report_Pick_List___(shipment_id_tab_       => shipment_id_tab_, 
                          pick_list_no_          => rec_.pick_list_no,
                          location_no_           => location_no_, 
                          process_shipments_     => TRUE,
                          trigger_shipment_flow_ => FALSE);
      
      FOR ord_ IN get_con_orders(rec_.pick_list_no) LOOP
         Report_Complete_Packages___(ord_.order_no);
      END LOOP;

      Customer_Order_Pick_List_API.Set_Picking_Confirmed(rec_.pick_list_no, contract_);
      Report_Complete_Ship_Pkgs___(shipment_id_);
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Pick_Report_Shipment__;   


PROCEDURE To_Order_Flow_When_Picked__(
    order_no_ IN VARCHAR2 )
IS
   attr_     VARCHAR2(2000);
   order_id_ VARCHAR2(3);
BEGIN
   order_id_ := Customer_Order_API.Get_Order_Id(order_no_);
   IF (Cust_Order_Type_Event_API.Get_Next_Event(order_id_, 85) IS NOT NULL) THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('START_EVENT', 90,         attr_);
      Client_SYS.Add_To_Attr('ORDER_NO',    order_no_,  attr_);
      Client_SYS.Add_To_Attr('END',         '',         attr_);
      Customer_Order_Flow_API.Process_Order__(attr_);
   END IF;
END To_Order_Flow_When_Picked__;


-- Pick_List_Is_Over_Reserved__
--   This functions returns TRUE if at least one of the lines to be picked
--   is over reserved.
@UncheckedAccess
FUNCTION Pick_List_Is_Over_Reserved__ (
   pick_list_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_                  NUMBER;
   picking_confirmed_db_   VARCHAR2(8);
   overreserved_           NUMBER := 0;  --0;

   CURSOR get_over_reserved_lines IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB c, CUSTOMER_ORDER_RESERVATION_TAB r
      WHERE  c.qty_assigned + c.qty_shipped > c.revised_qty_due
      AND    c.order_no     = r.order_no
      AND    c.line_no      = r.line_no
      AND    c.rel_no       = r.rel_no
      AND    c.line_item_no = r.line_item_no
      AND    r.pick_list_no =  pick_list_no_;
BEGIN
   OPEN get_over_reserved_lines;
   FETCH get_over_reserved_lines INTO dummy_;
   IF (get_over_reserved_lines%FOUND) THEN
      picking_confirmed_db_ := Customer_Order_Pick_List_API.Get_Picking_Confirmed_Db(pick_list_no_);
      IF picking_confirmed_db_ = 'UNPICKED' THEN
         overreserved_  := 1 ;
      END IF;
   END IF;
   CLOSE get_over_reserved_lines;
   RETURN overreserved_ ;
END Pick_List_Is_Over_Reserved__;


-- Is_Pick_Report_Allowed__
--   Checks if automatic pick reporing is allowed for the pick list.
@UncheckedAccess
FUNCTION Is_Pick_Report_Allowed__ (
   order_no_                  IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   report_pick_from_co_lines_ IN VARCHAR2 DEFAULT 'FALSE') RETURN NUMBER
IS
   part_catalog_rec_ Part_Catalog_API.Public_Rec;
   catch_qty_onhand_ NUMBER;
   number_null_      NUMBER := -99999999999;   

   CURSOR get_con_orders IS
      SELECT order_no
        FROM consolidated_orders_tab
       WHERE pick_list_no = pick_list_no_;

   CURSOR get_lines(order_no_ VARCHAR2) IS
      SELECT cor.contract,      cor.part_no,          cor.configuration_id,
             cor.location_no,   cor.lot_batch_no,     cor.serial_no,
             cor.eng_chg_level, cor.waiv_dev_rej_no,  cor.activity_seq,
             cor.catch_qty, cor.handling_unit_id
      FROM   CUSTOMER_ORDER_LINE_TAB col, CUSTOMER_ORDER_RESERVATION_TAB cor
      WHERE  col.qty_assigned > col.qty_picked
      AND    cor.qty_assigned > cor.qty_picked
      AND    cor.pick_list_no = pick_list_no_
      AND    col.order_no     = order_no_
      AND    col.line_item_no = cor.line_item_no
      AND    col.rel_no       = cor.rel_no
      AND    col.line_no      = cor.line_no
      ORDER BY cor.part_no;
BEGIN
   IF (order_no_ IS NOT NULL) THEN
      FOR linerec_ IN get_lines(order_no_) LOOP
         part_catalog_rec_ := Part_Catalog_API.Get(linerec_.part_no);

         IF (part_catalog_rec_.catch_unit_enabled = db_true_ ) THEN
            catch_qty_onhand_ := Inventory_Part_In_Stock_API.Get_Sum_Catch_Qty_Onhand(contract_         => linerec_.contract, 
                                                                                      part_no_          => linerec_.part_no, 
                                                                                      configuration_id_ => linerec_.configuration_id,
                                                                                      location_no_      => linerec_.location_no, 
                                                                                      lot_batch_no_     => linerec_.lot_batch_no, 
                                                                                      serial_no_        => linerec_.serial_no,
                                                                                      eng_chg_level_    => linerec_.eng_chg_level, 
                                                                                      waiv_dev_rej_no_  => linerec_.waiv_dev_rej_no, 
                                                                                      activity_seq_     => linerec_.activity_seq,
                                                                                      handling_unit_id_ => linerec_.handling_unit_id);
            
            IF ((catch_qty_onhand_ != nvl(linerec_.catch_qty,number_null_)) AND (report_pick_from_co_lines_ = 'FALSE')) THEN
               RETURN 0;
            END IF;
         END IF;
         -- Check the receipt and issue serial tracking flag for serial parts 
         IF ((linerec_.serial_no = '*' AND
             part_catalog_rec_.receipt_issue_serial_track = db_true_) AND (report_pick_from_co_lines_ = 'FALSE')) THEN
             RETURN 0;
         END IF;
      END LOOP;
   ELSE
      FOR ord_ IN get_con_orders LOOP
         FOR linerec_ IN get_lines(ord_.order_no) LOOP
            part_catalog_rec_ := Part_Catalog_API.Get(linerec_.part_no);

            IF (part_catalog_rec_.catch_unit_enabled = db_true_ ) THEN
               catch_qty_onhand_ := Inventory_Part_In_Stock_API.Get_Sum_Catch_Qty_Onhand (contract_           => linerec_.contract, 
                                                                                          part_no_            => linerec_.part_no, 
                                                                                          configuration_id_   => linerec_.configuration_id,
                                                                                          location_no_        => linerec_.location_no, 
                                                                                          lot_batch_no_       => linerec_.lot_batch_no, 
                                                                                          serial_no_          => linerec_.serial_no,
                                                                                          eng_chg_level_      => linerec_.eng_chg_level, 
                                                                                          waiv_dev_rej_no_    => linerec_.waiv_dev_rej_no, 
                                                                                          activity_seq_       => linerec_.activity_seq,
                                                                                          handling_unit_id_   => linerec_.handling_unit_id);
               IF (catch_qty_onhand_ != nvl(linerec_.catch_qty,number_null_)) THEN
                  RETURN 0;
               END IF;
            END IF;
            -- Check the receipt and issue serial tracking flag for serial parts 
            IF (linerec_.serial_no = '*' AND
                part_catalog_rec_.receipt_issue_serial_track = db_true_) THEN
                RETURN 0;
            END IF;
         END LOOP;
      END LOOP;
   END IF;

   RETURN 1;
END Is_Pick_Report_Allowed__;



-- Report_Reserved_As_Picked__
--   Pick report the reserved quantities directly.
PROCEDURE Report_Reserved_As_Picked__ (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   location_no_         IN VARCHAR2,
   shipment_id_         IN NUMBER DEFAULT 0 )
IS
   info_                      VARCHAR2(2000);
   pick_list_no_              VARCHAR2(15) := NULL;
   pick_inventory_type_       VARCHAR2(7);
   create_date_               DATE;
   company_                   VARCHAR2(20);
   validfrom_                 DATE;
   validuntil_                DATE;
   salepart_fee_code_         VARCHAR2(20);
   qty_picked_                NUMBER;
   qty_assigned_              NUMBER;
   contract_                  VARCHAR2(5)    := NULL;
   pre_order_state_           customer_order.state%TYPE;
   new_order_state_           customer_order.state%TYPE;
   backorder_check_passed_    BOOLEAN := FALSE;
   order_line_info_           VARCHAR2(100) := NULL;
   part_no_                   VARCHAR2(25);
   order_rec_                 Customer_Order_API.Public_Rec;
   catalog_no_                VARCHAR2(25);
   allow_partial_pkg_deliv_   VARCHAR2(5) := db_true_;
   all_license_connected_     VARCHAR2(5) := 'TRUE';
   raise_message_             VARCHAR2(5) := 'FALSE';
   local_shipment_id_         NUMBER;
   shipment_id_tab_           Shipment_API.Shipment_Id_Tab;
   
   CURSOR get_unpicked_reservations IS
      SELECT *
      FROM customer_order_reservation_tab
      WHERE  order_no     = order_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    (line_item_no = line_item_no_
              OR (line_item_no_ = -1 
                  AND line_item_no > 0))
      AND    pick_list_no = '*'
      AND    shipment_id  = shipment_id_;
BEGIN
   IF (Customer_Order_API.Get_Objstate(order_no_) = 'Blocked') THEN
      Error_SYS.Record_General(lu_name_, 'CRBLKORD: The customer order :P1 is blocked due to exceeding the credit limit, failing the credit check or because of manual blocking.', order_no_);
   END IF;
   
   -- Export control check.   
   IF (Customer_Order_Flow_API.Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
      $IF (Component_Expctr_SYS.INSTALLED) $THEN
         Exp_License_Connect_Util_API.Get_Order_License_Connect_Info(all_license_connected_, raise_message_, order_no_, line_no_, rel_no_, line_item_no_ );
      $ELSE
         NULL;
      $END
   END IF;
   
   IF (all_license_connected_ = 'TRUE') THEN
      pre_order_state_ := Customer_Order_API.Get_State(order_no_);
      order_rec_       := Customer_Order_API.Get(order_no_);

      --  Check if a backorder would be generated
      IF (order_rec_.backorder_option = 'NO PARTIAL DELIVERIES ALLOWED') THEN
         IF Create_Pick_List_API.Check_Order_For_Backorder__(order_no_) THEN
            Error_SYS.Record_General(lu_name_, 
                                     'NOBACKORDER: Partial deliveries not allowed for order :P1. The order must be fully reserved before executing Report Reserved Quantities as Picked.',
                                     order_no_);
         ELSE
            backorder_check_passed_ := TRUE;
         END IF;
      END IF;

      IF Customer_Order_Line_API.Uses_Shipment_Inventory(order_no_, line_no_, rel_no_, line_item_no_) = 1 THEN
         pick_inventory_type_ := 'SHIPINV';
      ELSE
         pick_inventory_type_ := 'ORDINV';
      END IF;

      Inventory_Event_Manager_API.Start_Session;
      local_shipment_id_         := CASE WHEN shipment_id_ = 0 THEN NULL ELSE shipment_id_ END;
      FOR res_rec_ IN get_unpicked_reservations LOOP         
         
         IF (order_rec_.backorder_option != 'NO PARTIAL DELIVERIES ALLOWED') THEN
            IF line_item_no_ != 0 THEN
               catalog_no_              := Customer_Order_Line_API.Get_Catalog_No(res_rec_.order_no,res_rec_.line_no, res_rec_.rel_no, -1);
               allow_partial_pkg_deliv_ := Sales_Part_API.Get_Allow_Partial_Pkg_Deliv_Db(res_rec_.contract,
                                                                                         catalog_no_);
            END IF;

            backorder_check_passed_ := Create_Pick_List_API.Line_Backorder_Check_Passed__(res_rec_.order_no,     res_rec_.line_no,  res_rec_.rel_no,
                                                                                          res_rec_.line_item_no, order_rec_.backorder_option,
                                                                                          Inventory_Location_API.Get_Location_Group(res_rec_.contract, res_rec_.location_no), pick_list_no_);                                                                           
         END IF;

         order_line_info_ := res_rec_.order_no ||' '|| res_rec_.line_no ||' '|| res_rec_.rel_no;

         IF NOT backorder_check_passed_ THEN
            IF (order_rec_.backorder_option = 'INCOMPLETE LINES NOT ALLOWED') THEN
               Error_SYS.Record_General(lu_name_, 
                                        'CANNOTPICKLIST1: Partial delivery not allowed for order line :P1. The line must be fully reserved before executing Report Reserved Quantities as Picked', 
                                        order_line_info_);
            ELSIF (order_rec_.backorder_option IN ('INCOMPLETE PACKAGES NOT ALLOWED','ALLOW INCOMPLETE LINES AND PACKAGES')) THEN
               part_no_ := Customer_Order_Line_API.Get_Catalog_No(res_rec_.order_no,res_rec_.line_no, res_rec_.rel_no, -1);
               Error_SYS.Record_General(lu_name_, 
                                        'CANNOTPICKLIST2: Partial deliveries not allowed for package part :P1. A number of complete packages must be reserved before executing Report Reserved Quantities as Picked.',
                                        part_no_);
            END IF;
         END IF;

         -- Create pick list
         IF pick_list_no_ IS NULL THEN
            create_date_  := Site_API.Get_Site_Date(res_rec_.contract);
            pick_list_no_ := Customer_Order_Pick_List_API.New(order_no_, pick_inventory_type_, local_shipment_id_, create_date_);
         END IF;
         -- Add a default shipment inv location if its shipment inventory
         Customer_Order_Pick_List_API.Modify_Default_Ship_Location(pick_list_no_);

         Customer_Order_Reservation_API.Modify_Pick_List_No(order_no_            => res_rec_.order_no,         
                                                            line_no_             => res_rec_.line_no,
                                                            rel_no_              => res_rec_.rel_no,           
                                                            line_item_no_        => res_rec_.line_item_no,
                                                            contract_            => res_rec_.contract,         
                                                            part_no_             => res_rec_.part_no,
                                                            location_no_         => res_rec_.location_no,      
                                                            lot_batch_no_        => res_rec_.lot_batch_no,
                                                            serial_no_           => res_rec_.serial_no,        
                                                            eng_chg_level_       => res_rec_.eng_chg_level,
                                                            waiv_dev_rej_no_     => res_rec_.waiv_dev_rej_no,  
                                                            activity_seq_        => res_rec_.activity_seq,
                                                            handling_unit_id_    => res_rec_.handling_unit_id,
                                                            pick_list_no_        => res_rec_.pick_list_no,
                                                            configuration_id_    => res_rec_.configuration_id, 
                                                            shipment_id_         => res_rec_.shipment_id,
                                                            new_pick_list_no_    => pick_list_no_);

         company_           := Site_API.Get_Company(res_rec_.contract);
         salepart_fee_code_ := Customer_Order_Line_API.Get_Tax_Code(res_rec_.order_no, res_rec_.line_no, res_rec_.rel_no, res_rec_.line_item_no);

         IF (salepart_fee_code_ IS NOT NULL) THEN
         validuntil_ := statutory_fee_API.Get_Valid_Until(company_, salepart_fee_code_);
         validfrom_  := statutory_fee_API.Get_Valid_From(company_, salepart_fee_code_);

            IF NOT (trunc(sysdate) BETWEEN validfrom_ AND validuntil_) THEN
               Error_SYS.Record_General(lu_name_, 'NOTAXVALID: Tax Code period is invalid');
            END IF;
         END IF;

         contract_ := res_rec_.contract;

         IF (Order_Config_Util_API.Check_Ord_Line_Config_Mismatch(res_rec_.order_no, res_rec_.line_no, res_rec_.rel_no, res_rec_.line_item_no) = 'TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'CONFIGMISMATCH: Pick list creation is not allowed since supply site configuration is different from demand site configuration for the customer order no :P1 line no :P2 rel no :P3.', res_rec_.order_no, res_rec_.line_no, res_rec_.rel_no);
         END IF;     
           
      END LOOP;
      
      IF pick_list_no_ IS NOT NULL THEN
         IF (Customer_Order_Reservation_API.Is_Pick_List_Connected(pick_list_no_) = 1)THEN
            Customer_Order_Line_Hist_API.New(order_no_, 
                                             line_no_, 
                                             rel_no_, 
                                             line_item_no_,
                                             Language_SYS.Translate_Constant(lu_name_, 'PICKEDLINE: Reserved quantity reported as picked.'));
            Customer_Order_Pick_List_API.Set_Picking_Confirmed(pick_list_no_, contract_);
            Report_Complete_Packages___(order_no_);
            new_order_state_ := Customer_Order_API.Get_State(order_no_);
            
            IF (new_order_state_ != pre_order_state_ AND
                new_order_state_ = Customer_Order_API.Finite_State_Decode__('Picked')) THEN
               Customer_Order_History_API.New(order_no_, Language_SYS.Translate_Constant(lu_name_, 'PICKEDHEAD: Picked'));
            END IF;
            
            -- Generate HU snapshot for the newly created pick list
            -- This will evaentually call Pick_Shipment_API.Generate_Handl_Unit_Snapshot(pick_list_no_). Then need to start session again to match Finish_Session in the end   
            Inventory_Event_Manager_API.Finish_Session;
            Inventory_Event_Manager_API.Start_Session;
            
            -- Pick Reporting
            Report_Pick_List___ ( shipment_id_tab_       => shipment_id_tab_,
                                  pick_list_no_          => pick_list_no_,
                                  location_no_           => location_no_,
                                  process_shipments_     => TRUE,
                                  trigger_shipment_flow_ => CASE WHEN (shipment_id_ = 0) THEN FALSE ELSE TRUE END);
         END IF;
      END IF;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
   
END Report_Reserved_As_Picked__;


-- Reserved_As_Picked_Allowed__
--   Checks if the CO Line selected has reservations for which a pick list has
--   not yet been created. (Checks if reserved quantities can be reported as picked.)
@UncheckedAccess
FUNCTION Reserved_As_Picked_Allowed__ (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   shipment_id_         IN NUMBER   DEFAULT 0,
   incl_ship_connected_ IN VARCHAR2 DEFAULT 'FALSE' ) RETURN VARCHAR2
IS
   return_val_          VARCHAR2(5) := db_false_;
   order_state_         VARCHAR2(20);
BEGIN
   order_state_ := Customer_Order_API.Get_Objstate(order_no_);

   IF ((order_state_ != 'Planned') AND
       (Customer_Order_Line_API.Get_Shipment_Creation_Db(order_no_,line_no_,rel_no_,line_item_no_) != 'PICK_LIST_CREATION') AND
       ((Customer_Order_Line_API.Get_Shipment_Connected_Db(order_no_, line_no_, rel_no_, line_item_no_) = 'FALSE') 
         OR (incl_ship_connected_ = 'TRUE'))) THEN 
      return_val_ := Pick_Shipment_API.Reserved_As_Picked_Allowed(order_no_, line_no_, rel_no_, line_item_no_,
                                                                  Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, shipment_id_);
   END IF;   
   RETURN return_val_;
END Reserved_As_Picked_Allowed__;

@UncheckedAccess
FUNCTION Check_Confirm_Ship_Location (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   --Default should be header value? Header is abstract?
   confirm_shipment_location_ NUMBER := 1;
   CURSOR get_order_lines IS
      SELECT order_no, line_no, rel_no, line_item_no
        FROM CUSTOMER_ORDER_LINE_TAB
       WHERE order_no = order_no_
         AND qty_picked < qty_assigned 
         AND rowstate IN ('Reserved', 'PartiallyDelivered', 'Picked');
BEGIN         
   FOR rec_ IN get_order_lines LOOP
      confirm_shipment_location_ := Check_Confirm_Ship_Location(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      EXIT WHEN confirm_shipment_location_ = 1;
   END LOOP;
   
   RETURN confirm_shipment_location_;
END Check_Confirm_Ship_Location;

@UncheckedAccess
FUNCTION Check_Confirm_Ship_Location (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER) RETURN NUMBER
IS
   confirm_shipment_location_ VARCHAR2(5);
   custline_rec_        Customer_Order_Line_API.Public_Rec;
BEGIN
   custline_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   IF(custline_rec_.shipment_connected = 'FALSE' AND custline_rec_.shipment_creation != Shipment_Creation_API.DB_PICK_LIST_CREATION) THEN
      confirm_shipment_location_ := 'TRUE';
   ELSE
      confirm_shipment_location_ := Shipment_Type_API.Get_Confirm_Ship_Loc_No_Db(custline_rec_.shipment_type);
   END IF;
   
   RETURN CASE WHEN confirm_shipment_location_ = 'TRUE' THEN 1 ELSE 0 END;
END Check_Confirm_Ship_Location;


-- This method is used in the Aggregated-tab of the Report Picking of Pick List Lines-window where
-- you can either pick full Handling Units or locations (NOT BOTH! because validate_hu_struct_position_ &
-- add_hu_to_shipment_ is only handled for the last thing we pick.)
FUNCTION Pick_Reservations_HU__ (
   message_               IN CLOB,
   session_id_            IN NUMBER,
   pick_list_no_          IN VARCHAR2,
   ship_location_no_      IN VARCHAR2,
   unreserve_             IN VARCHAR2 DEFAULT 'FALSE',
   trigger_shipment_flow_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN CLOB
IS
   attr_                        VARCHAR2(32000);
   index_                       NUMBER := 1;
   count_                       NUMBER;
   name_arr_                    Message_SYS.name_table;
   value_arr_                   Message_SYS.line_table;
   last_line_                   BOOLEAN := FALSE;
   clob_out_data_               CLOB;
   info_                        VARCHAR2(2000);
   all_reported_                NUMBER;
   closed_lines_                NUMBER;
   overpicked_lines_            VARCHAR2(5);
   local_session_id_            NUMBER;
   shipment_id_message_         VARCHAR2(32000);
   
   CURSOR get_pick_list_lines_hu(handling_unit_id_ NUMBER) IS 
      SELECT order_no, line_no, rel_no, line_item_no, shipment_id, input_qty, input_unit_meas, 
             input_conv_factor, input_variable_values, (qty_assigned - qty_picked) qty_to_pick, catch_qty,
             contract, part_no, configuration_id, lot_batch_no, serial_no, eng_chg_level, location_no,
             waiv_dev_rej_no, activity_seq, handling_unit_id
        FROM CUSTOMER_ORDER_RESERVATION_TAB
       WHERE pick_list_no = pick_list_no_
         AND handling_unit_id IN (SELECT handling_unit_id
                                    FROM HANDLING_UNIT_PUB hu
                                 CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                   START WITH     hu.handling_unit_id = handling_unit_id_)
         AND qty_assigned - qty_picked > 0;
      
   CURSOR get_pick_list_lines_loc(location_no_ VARCHAR2) IS 
      SELECT order_no, line_no, rel_no, line_item_no, shipment_id, input_qty, input_unit_meas, 
             input_conv_factor, input_variable_values, (qty_assigned - qty_picked) qty_to_pick, catch_qty,
             contract, part_no, configuration_id, lot_batch_no, serial_no, eng_chg_level, location_no,
             waiv_dev_rej_no, activity_seq, handling_unit_id  
        FROM CUSTOMER_ORDER_RESERVATION_TAB cor
       WHERE pick_list_no = pick_list_no_
         AND location_no  = location_no_
         AND EXISTS (SELECT *
                       FROM INV_PART_STOCK_SNAPSHOT_PUB ipss
                      WHERE ipss.source_ref1        = cor.pick_list_no
                        AND ipss.handling_unit_id   = cor.handling_unit_id
                        AND ipss.location_no        = cor.location_no
                        AND ipss.source_ref_type_db = Handl_Unit_Snapshot_Type_API.DB_PICK_LIST)
         AND qty_assigned - qty_picked > 0;
                    
   TYPE Pick_List_Lines_Tab IS TABLE OF get_pick_list_lines_hu%ROWTYPE INDEX BY PLS_INTEGER;
   TYPE Locations_Tab IS TABLE OF VARCHAR2(35) INDEX BY PLS_INTEGER;
   
   pick_list_lines_tab_         Pick_List_Lines_Tab;
   locations_to_pick_tab_       Locations_Tab;
   handling_units_to_pick_tab_  Handling_Unit_API.Handling_Unit_Id_Tab;
   shipment_id_tab_             Shipment_API.Shipment_Id_Tab;
BEGIN
   local_session_id_         := session_id_;
   
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1 .. count_ LOOP
      IF (name_arr_(n_) = 'LOCATION_NO') THEN
         locations_to_pick_tab_(locations_to_pick_tab_.COUNT + 1) := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         handling_units_to_pick_tab_(handling_units_to_pick_tab_.COUNT + 1).handling_unit_id := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LAST_LINE') THEN
         last_line_ := TRUE;
      END IF;
   END LOOP;
   
   IF (locations_to_pick_tab_.COUNT > 0 AND handling_units_to_pick_tab_.COUNT > 0) THEN
      Error_SYS.Record_General(lu_name_, 'Picking both Handling Units and Locations is not supported.');
   END IF;
   
   IF (handling_units_to_pick_tab_.COUNT > 0) THEN
      -- We filter out any lower level Handling Unit that has any of it's parent already in the collection. By doing this
      -- we avoid picking the same reservations twice.
      handling_units_to_pick_tab_ := Handling_Unit_API.Get_Outermost_Units_Only(handling_units_to_pick_tab_);
      
      FOR i IN handling_units_to_pick_tab_.FIRST .. handling_units_to_pick_tab_.LAST LOOP
         -- To be able to move a Handling Unit to Shipment Inventory we need to disconnect it from it's parent.
         IF (ship_location_no_ IS NOT NULL) THEN
            Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_          => handling_units_to_pick_tab_(i).handling_unit_id, 
                                                             parent_handling_unit_id_   => NULL);
         END IF;
         
         OPEN get_pick_list_lines_hu(handling_units_to_pick_tab_(i).handling_unit_id);
         FETCH get_pick_list_lines_hu BULK COLLECT INTO pick_list_lines_tab_;
         CLOSE get_pick_list_lines_hu;
         
         IF (pick_list_lines_tab_.COUNT > 0) THEN
            FOR j IN pick_list_lines_tab_.FIRST .. pick_list_lines_tab_.LAST LOOP
               Client_SYS.Clear_Attr(attr_);
               
               Client_SYS.Add_To_Attr('PICK_LIST_NO',           pick_list_no_,                                     attr_);
               Client_SYS.Add_To_Attr('ORDER_NO',               pick_list_lines_tab_(j).order_no,                  attr_);
               Client_SYS.Add_To_Attr('LINE_NO',                pick_list_lines_tab_(j).line_no,                   attr_);
               Client_SYS.Add_To_Attr('REL_NO',                 pick_list_lines_tab_(j).rel_no,                    attr_);
               Client_SYS.Add_To_Attr('LINE_ITEM_NO',           pick_list_lines_tab_(j).line_item_no,              attr_);
               Client_SYS.Add_To_Attr('CONTRACT',               pick_list_lines_tab_(j).contract,                  attr_);
               Client_SYS.Add_To_Attr('PART_NO',                pick_list_lines_tab_(j).part_no,                   attr_);
               Client_SYS.Add_To_Attr('CONFIGURATION_ID',       pick_list_lines_tab_(j).configuration_id,          attr_);
               Client_SYS.Add_To_Attr('LOCATION_NO',            pick_list_lines_tab_(j).location_no,               attr_);
               Client_SYS.Add_To_Attr('LOT_BATCH_NO',           pick_list_lines_tab_(j).lot_batch_no,              attr_);
               Client_SYS.Add_To_Attr('SERIAL_NO',              pick_list_lines_tab_(j).serial_no,                 attr_);
               Client_SYS.Add_To_Attr('ENG_CHG_LEVEL',          pick_list_lines_tab_(j).eng_chg_level,             attr_);
               Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO',        pick_list_lines_tab_(j).waiv_dev_rej_no,           attr_);
               Client_SYS.Add_To_Attr('INPUT_QUANTITY',         pick_list_lines_tab_(j).input_qty,                 attr_);
               Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR',      pick_list_lines_tab_(j).input_conv_factor,         attr_);
               Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS',        pick_list_lines_tab_(j).input_unit_meas,           attr_);
               Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES',  pick_list_lines_tab_(j).input_variable_values,     attr_);
               Client_SYS.Add_To_Attr('ACTIVITY_SEQ',           pick_list_lines_tab_(j).activity_seq,              attr_);
               Client_SYS.Add_To_Attr('HANDLING_UNIT_ID',       pick_list_lines_tab_(j).handling_unit_id,          attr_);         
               Client_SYS.Add_To_Attr('CATCH_QTY_TO_PICK',      pick_list_lines_tab_(j).catch_qty,                 attr_);
               Client_SYS.Add_To_Attr('SHIPMENT_ID',            pick_list_lines_tab_(j).shipment_id,               attr_);
               Client_SYS.Add_To_Attr('QTY_TO_PICK',            CASE WHEN unreserve_ = 'FALSE' 
                                                                        THEN pick_list_lines_tab_(j).qty_to_pick
                                                                        ELSE 0 
                                                                END,                                               attr_);
               
               -- Only pass LAST_LINE if this is the last reservation in the last Handling Unit to pick.
               IF ((j = pick_list_lines_tab_.LAST) AND (i = handling_units_to_pick_tab_.LAST) AND last_line_) THEN 
                  Client_SYS.Add_To_Attr('LAST_LINE', 'TRUE', attr_);
               END IF;

               Pick_Reservations__(info_                          => info_,
                                   all_reported_                  => all_reported_,
                                   closed_lines_                  => closed_lines_,
                                   overpicked_lines_              => overpicked_lines_,
                                   session_id_                    => local_session_id_,
                                   shipment_id_message_           => shipment_id_message_,
                                   attr_                          => attr_,
                                   pick_list_no_                  => pick_list_no_,
                                   ship_location_no_              => ship_location_no_,
                                   trigger_shipment_flow_         => trigger_shipment_flow_,
                                   validate_hu_struct_position_   => FALSE,
                                   add_hu_to_shipment_            => FALSE); 
               -- We send add_hu_to_shipment_ = FALSE because will add as high level HU as possible with the call to 
               -- Shipment_Handling_Utility_API.Connect_HUs_From_Inventory after all of the Handling Units have been picked.

               IF (pick_list_lines_tab_(j).shipment_id != 0) THEN
                  shipment_id_tab_(pick_list_lines_tab_(j).shipment_id) := pick_list_lines_tab_(j).shipment_id;
               END IF;
            END LOOP;
         END IF;
      END LOOP;
   
      IF (shipment_id_tab_.COUNT > 0) THEN
      -- Go through all of the Shipment IDs on the processed reservations and try to add the Handling Units from inventory to the shipments.
         index_ := shipment_id_tab_.FIRST;
         WHILE(index_ IS NOT NULL) LOOP  
            Shipment_Handling_Utility_API.Connect_HUs_From_Inventory(shipment_id_tab_(index_));
            index_ := shipment_id_tab_.NEXT(index_);
         END LOOP;
      END IF;
   END IF;
   
   
   IF (locations_to_pick_tab_.COUNT > 0) THEN
      FOR i IN locations_to_pick_tab_.FIRST .. locations_to_pick_tab_.LAST LOOP
         OPEN get_pick_list_lines_loc(locations_to_pick_tab_(i));
         FETCH get_pick_list_lines_loc BULK COLLECT INTO pick_list_lines_tab_;
         CLOSE get_pick_list_lines_loc;
         
         IF (pick_list_lines_tab_.COUNT > 0) THEN
            FOR j IN pick_list_lines_tab_.FIRST .. pick_list_lines_tab_.LAST LOOP
               Client_SYS.Clear_Attr(attr_);
               
               Client_SYS.Add_To_Attr('PICK_LIST_NO',           pick_list_no_,                                     attr_);
               Client_SYS.Add_To_Attr('ORDER_NO',               pick_list_lines_tab_(j).order_no,                  attr_);
               Client_SYS.Add_To_Attr('LINE_NO',                pick_list_lines_tab_(j).line_no,                   attr_);
               Client_SYS.Add_To_Attr('REL_NO',                 pick_list_lines_tab_(j).rel_no,                    attr_);
               Client_SYS.Add_To_Attr('LINE_ITEM_NO',           pick_list_lines_tab_(j).line_item_no,              attr_);
               Client_SYS.Add_To_Attr('CONTRACT',               pick_list_lines_tab_(j).contract,                  attr_);
               Client_SYS.Add_To_Attr('PART_NO',                pick_list_lines_tab_(j).part_no,                   attr_);
               Client_SYS.Add_To_Attr('CONFIGURATION_ID',       pick_list_lines_tab_(j).configuration_id,          attr_);
               Client_SYS.Add_To_Attr('LOCATION_NO',            pick_list_lines_tab_(j).location_no,               attr_);
               Client_SYS.Add_To_Attr('LOT_BATCH_NO',           pick_list_lines_tab_(j).lot_batch_no,              attr_);
               Client_SYS.Add_To_Attr('SERIAL_NO',              pick_list_lines_tab_(j).serial_no,                 attr_);
               Client_SYS.Add_To_Attr('ENG_CHG_LEVEL',          pick_list_lines_tab_(j).eng_chg_level,             attr_);
               Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO',        pick_list_lines_tab_(j).waiv_dev_rej_no,           attr_);
               Client_SYS.Add_To_Attr('INPUT_QUANTITY',         pick_list_lines_tab_(j).input_qty,                 attr_);
               Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR',      pick_list_lines_tab_(j).input_conv_factor,         attr_);
               Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS',        pick_list_lines_tab_(j).input_unit_meas,           attr_);
               Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES',  pick_list_lines_tab_(j).input_variable_values,     attr_);
               Client_SYS.Add_To_Attr('ACTIVITY_SEQ',           pick_list_lines_tab_(j).activity_seq,              attr_);
               Client_SYS.Add_To_Attr('HANDLING_UNIT_ID',       pick_list_lines_tab_(j).handling_unit_id,          attr_);         
               Client_SYS.Add_To_Attr('CATCH_QTY_TO_PICK',      pick_list_lines_tab_(j).catch_qty,                 attr_);
               Client_SYS.Add_To_Attr('SHIP_LOCATION_NO',       ship_location_no_,                                 attr_);
               Client_SYS.Add_To_Attr('SHIPMENT_ID',            pick_list_lines_tab_(j).shipment_id,               attr_);
               Client_SYS.Add_To_Attr('QTY_TO_PICK',            CASE WHEN unreserve_ = 'FALSE' 
                                                                        THEN pick_list_lines_tab_(j).qty_to_pick
                                                                        ELSE 0 
                                                                END,                                               attr_);

               -- Only pass LAST_LINE ff this is the last reservation in the last location to pick.
               IF ((j = pick_list_lines_tab_.LAST) AND (i = locations_to_pick_tab_.LAST) AND last_line_) THEN 
                  Client_SYS.Add_To_Attr('LAST_LINE', 'TRUE', attr_);
               END IF;

               Pick_Reservations__(info_                          => info_,
                                   all_reported_                  => all_reported_,
                                   closed_lines_                  => closed_lines_,
                                   overpicked_lines_              => overpicked_lines_,
                                   session_id_                    => local_session_id_,
                                   shipment_id_message_           => shipment_id_message_,
                                   attr_                          => attr_,
                                   pick_list_no_                  => pick_list_no_,
                                   ship_location_no_              => ship_location_no_,
                                   trigger_shipment_flow_         => trigger_shipment_flow_,
                                   validate_hu_struct_position_   => TRUE,
                                   add_hu_to_shipment_            => TRUE);
            END LOOP;
         END IF;
      END LOOP;
   END IF;
   
   clob_out_data_ := Message_SYS.Construct('');
   Message_SYS.Add_Attribute(clob_out_data_, 'ALL_REPORTED', all_reported_);
   Message_SYS.Add_Attribute(clob_out_data_, 'CLOSED_LINES', closed_lines_);
   Message_SYS.Add_Attribute(clob_out_data_, 'OVERPICKED_LINES', overpicked_lines_);
   Message_SYS.Add_Attribute(clob_out_data_, 'SESSION_ID', local_session_id_);
   IF (info_ IS NOT NULL) THEN
      Message_SYS.Add_Attribute(clob_out_data_, 'INFO', info_);
   END IF;
   
   RETURN clob_out_data_;
END Pick_Reservations_HU__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- Pick_Reservations
-- Pick report a single reservation
-- This method will be called from generic pick by choice process in Inventory 
PROCEDURE Pick_Reservations (
   qty_picked_                   OUT NUMBER,
   all_reported_                 OUT NUMBER,
   closed_lines_                 OUT NUMBER,
   overpicked_lines_             OUT VARCHAR2,
   session_id_                   IN OUT NOCOPY NUMBER,
   pick_list_no_                 IN VARCHAR2,
   order_no_                     IN VARCHAR2,
   line_no_                      IN VARCHAR2,
   rel_no_                       IN VARCHAR2,
   line_item_no_                 IN NUMBER,
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
   input_qty_                    IN NUMBER,
   input_conv_factor_            IN NUMBER,
   input_unit_meas_              IN VARCHAR2,
   input_variable_values_        IN VARCHAR2,
   shipment_id_                  IN NUMBER,
   ship_location_no_             IN VARCHAR2,
   qty_to_pick_                  IN NUMBER,
   catch_qty_to_pick_            IN NUMBER,
   part_tracking_session_id_     IN NUMBER,
   close_line_                   IN VARCHAR2,
   last_line_                    IN VARCHAR2 DEFAULT 'FALSE',
   pick_all_                     IN NUMBER   DEFAULT 0,
   trigger_shipment_flow_        IN VARCHAR2 DEFAULT 'TRUE',
   validate_hu_struct_position_  IN BOOLEAN  DEFAULT TRUE,
   add_hu_to_shipment_           IN BOOLEAN  DEFAULT TRUE,
   raise_exception_              IN BOOLEAN  DEFAULT FALSE )
IS
   pick_attr_            VARCHAR2(32000);   
   dummy_info_           VARCHAR2(32000); 
   local_close_line_     VARCHAR2(2);
   shipment_id_message_  VARCHAR2(32000);
BEGIN
   BEGIN 
      -- Since this method is called from pick by choice process, close line should apply only on the last line.
      IF close_line_ = Fnd_Boolean_API.DB_TRUE AND last_line_ = Fnd_Boolean_API.DB_TRUE THEN 
         local_close_line_  := '1';
      ELSE 
         local_close_line_  := '0';
      END IF;
   
      Client_SYS.Clear_Attr(pick_attr_);
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, pick_attr_);
      Client_SYS.Add_To_Attr('LINE_NO', line_no_, pick_attr_);
      Client_SYS.Add_To_Attr('REL_NO', rel_no_, pick_attr_);
      Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, pick_attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, pick_attr_);
      Client_SYS.Add_To_Attr('PART_NO', part_no_, pick_attr_);
      Client_SYS.Add_To_Attr('CONFIGURATION_ID', configuration_id_, pick_attr_);
      Client_SYS.Add_To_Attr('LOCATION_NO', location_no_, pick_attr_);
      Client_SYS.Add_To_Attr('LOT_BATCH_NO', lot_batch_no_, pick_attr_);
      Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, pick_attr_);
      Client_SYS.Add_To_Attr('ENG_CHG_LEVEL', eng_chg_level_, pick_attr_);
      Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO', waiv_dev_rej_no_, pick_attr_);
      Client_SYS.Add_To_Attr('CLOSE_LINE', local_close_line_, pick_attr_);
      Client_SYS.Add_To_Attr('INPUT_QUANTITY', input_qty_, pick_attr_);
      Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR', input_conv_factor_, pick_attr_);
      Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS', input_unit_meas_, pick_attr_);
      Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES', input_variable_values_, pick_attr_);
      Client_SYS.Add_To_Attr('ACTIVITY_SEQ', activity_seq_, pick_attr_);
      Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', handling_unit_id_, pick_attr_);
      Client_SYS.Add_To_Attr('CATCH_QTY_TO_PICK', catch_qty_to_pick_, pick_attr_);
      Client_SYS.Add_To_Attr('PART_TRACKING_SESSION_ID', part_tracking_session_id_, pick_attr_);
      Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, pick_attr_);
      Client_SYS.Add_To_Attr('QTY_TO_PICK', qty_to_pick_, pick_attr_);
      IF last_line_ = Fnd_Boolean_API.DB_TRUE THEN
         Client_SYS.Add_To_Attr('LAST_LINE', 'TRUE', pick_attr_);
      END IF ;
      qty_picked_ := 0;
      Pick_Reservations__(info_                    => dummy_info_, 
                          all_reported_            => all_reported_, 
                          closed_lines_            => closed_lines_, 
                          overpicked_lines_        => overpicked_lines_, 
                          session_id_              => session_id_, 
                          shipment_id_message_     => shipment_id_message_,
                          attr_                    => pick_attr_, 
                          pick_list_no_            => pick_list_no_, 
                          ship_location_no_        => ship_location_no_, 
                          pick_all_                => pick_all_, 
                          trigger_shipment_flow_   => trigger_shipment_flow_,
                          add_hu_to_shipment_      => add_hu_to_shipment_);

      IF last_line_ = Fnd_Boolean_API.DB_TRUE THEN 
         Temporary_Pick_Reservation_API.Clear_Session(session_id_);
      END IF; 
      qty_picked_ := qty_to_pick_;
   EXCEPTION
      WHEN OTHERS THEN
         IF raise_exception_ THEN 
            RAISE;
         ELSE 
            NULL;
         END IF;
   END;      
END Pick_Reservations;


-- Pick_Reservations_HU
-- Pick report a Handling unit reservation
PROCEDURE Pick_Reservations_HU (
   hu_picked_             OUT NUMBER,
   session_id_            IN OUT NOCOPY NUMBER,
   pick_list_no_          IN VARCHAR2,
   source_ref_type_db_    IN VARCHAR2,
   handling_unit_id_      IN NUMBER,
   ship_location_no_      IN VARCHAR2,
   last_line_             IN VARCHAR2,
   raise_exception_       IN BOOLEAN  DEFAULT  FALSE,
   trigger_shipment_flow_ IN VARCHAR2 DEFAULT 'TRUE')
IS
   pick_clob_       CLOB;
   out_clob_        CLOB;
BEGIN
   BEGIN 
      pick_clob_ := Message_SYS.Construct('');
      IF last_line_ = 'TRUE' THEN
        Message_SYS.Add_Attribute(pick_clob_, 'LAST_LINE', 'TRUE');
      END IF ;
      Message_SYS.Add_Attribute(pick_clob_, 'HANDLING_UNIT_ID', handling_unit_id_);

      out_clob_ := Pick_Reservations_HU__(message_               => pick_clob_,
                                          session_id_            => session_id_,
                                          pick_list_no_          => pick_list_no_,
                                          ship_location_no_      => ship_location_no_,
                                          trigger_shipment_flow_ => trigger_shipment_flow_);
      session_id_ := Message_SYS.Find_Attribute(out_clob_, 'SESSION_ID', session_id_);

      IF last_line_ = Fnd_Boolean_API.DB_TRUE THEN 
         Temporary_Pick_Reservation_API.Clear_Session(session_id_);
      END IF; 
      hu_picked_ := 1;
   EXCEPTION
      WHEN OTHERS THEN
         IF raise_exception_ THEN 
            RAISE;
         ELSE 
            NULL;
         END IF;
   END;      
END Pick_Reservations_HU;
   
   
-- Clear_Unpicked_Reservations
--   Clear reservations not picked for a specified pick list
PROCEDURE Clear_Unpicked_Reservations (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   pick_list_no_        IN VARCHAR2,
   shipment_id_         IN NUMBER )
IS
   sum_qty_unreserved_        NUMBER := 0;
   new_qty_assigned_          NUMBER;
   catch_quantity_            NUMBER := NULL;
   line_rec_                  Customer_Order_Line_API.Public_Rec;

   -- Concatenation with '' in order to make use of PK for CUSTOMER_ORDER_RESERVATION instead of IX
   CURSOR overflow_reservations IS
      SELECT contract,        part_no,           configuration_id,      location_no,
             lot_batch_no,    serial_no,         eng_chg_level,         waiv_dev_rej_no,
             qty_assigned,    qty_picked,        input_qty,
             input_unit_meas, input_conv_factor, input_variable_values, activity_seq, handling_unit_id
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  qty_picked         <  qty_assigned
      AND    pick_list_no || '' =  pick_list_no_
      AND    line_item_no       =  line_item_no_
      AND    rel_no             =  rel_no_
      AND    line_no            =  line_no_
      AND    order_no           =  order_no_
      AND    shipment_id        =  shipment_id_;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   line_rec_         := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   FOR rec_ IN overflow_reservations LOOP
      IF (line_rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN            
         Validate_Return_From_Ship_Inv(order_no_,
                                       line_no_,
                                       rel_no_,
                                       line_item_no_,
                                       rec_.lot_batch_no,
                                       rec_.serial_no,
                                       rec_.qty_assigned - rec_.qty_picked);
      END IF;
      -- Set the qty_assigned to qty_picked.
      IF (rec_.qty_picked = 0) THEN
         Customer_Order_Reservation_API.Remove(order_no_           => order_no_,             
                                               line_no_            => line_no_, 
                                               rel_no_             => rel_no_, 
                                               line_item_no_       => line_item_no_,
                                               contract_           => rec_.contract,         
                                               part_no_            => rec_.part_no,      
                                               location_no_        => rec_.location_no,
                                               lot_batch_no_       => rec_.lot_batch_no,     
                                               serial_no_          => rec_.serial_no,    
                                               eng_chg_level_      => rec_.eng_chg_level,
                                               waiv_dev_rej_no_    => rec_.waiv_dev_rej_no,  
                                               activity_seq_       => rec_.activity_seq, 
                                               handling_unit_id_   => rec_.handling_unit_id,
                                               pick_list_no_       => pick_list_no_,         
                                               configuration_id_   => rec_.configuration_id, 
                                               shipment_id_        => shipment_id_);
      ELSE
         Customer_Order_Reservation_API.Modify_Qty_Assigned(order_no_               => order_no_,              
                                                            line_no_                => line_no_,              
                                                            rel_no_                 => rel_no_,
                                                            line_item_no_           => line_item_no_,          
                                                            contract_               => rec_.contract,         
                                                            part_no_                => rec_.part_no,
                                                            location_no_            => rec_.location_no,       
                                                            lot_batch_no_           => rec_.lot_batch_no,     
                                                            serial_no_              => rec_.serial_no,
                                                            eng_chg_level_          => rec_.eng_chg_level,     
                                                            waiv_dev_rej_no_        => rec_.waiv_dev_rej_no,  
                                                            activity_seq_           => rec_.activity_seq,
                                                            handling_unit_id_       => rec_.handling_unit_id,
                                                            pick_list_no_           => pick_list_no_,         
                                                            configuration_id_       => rec_.configuration_id, 
                                                            shipment_id_            => shipment_id_,
                                                            qty_assigned_           => rec_.qty_picked,        
                                                            input_qty_              => rec_.input_qty,        
                                                            input_unit_meas_        => rec_.input_unit_meas,
                                                            input_conv_factor_      => rec_.input_conv_factor, 
                                                            input_variable_values_  => rec_.input_variable_values);
      END IF;
      
      -- Removed reservations from inventory.      
      -- Single reservations.
      Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_     => catch_quantity_,      
                                               contract_           => rec_.contract,     
                                               part_no_            => rec_.part_no, 
                                               configuration_id_   => rec_.configuration_id, 
                                               location_no_        => rec_.location_no,
                                               lot_batch_no_       => rec_.lot_batch_no,   
                                               serial_no_          => rec_.serial_no,   
                                               eng_chg_level_      => rec_.eng_chg_level,
                                               waiv_dev_rej_no_    => rec_.waiv_dev_rej_no, 
                                               activity_seq_       => rec_.activity_seq,
                                               handling_unit_id_   => rec_.handling_unit_id,
                                               quantity_           => rec_.qty_picked - rec_.qty_assigned );      

      sum_qty_unreserved_ := sum_qty_unreserved_ + rec_.qty_assigned - rec_.qty_picked;
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;

   new_qty_assigned_ := (Customer_Order_Line_API.Get_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_) - sum_qty_unreserved_);
   Customer_Order_API.Set_Line_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_, new_qty_assigned_);
END Clear_Unpicked_Reservations;


-- Recalc_Catch_Price_Conv_Factor
--   Recalclate price conversion factor using picked and delivered catch quantities.
PROCEDURE Recalc_Catch_Price_Conv_Factor (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   order_line_rec_             Customer_Order_Line_API.Public_Rec;
   picked_catch_qty_           NUMBER;
   shipped_catch_qty_          NUMBER;
   buy_qty_shipped_and_picked_ NUMBER;
   price_conv_factor_          NUMBER;
BEGIN
   order_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   -- Retrieve the total qty picked in catch unit
   picked_catch_qty_ := Customer_Order_Reservation_API.Get_Catch_Qty_Picked(order_no_,
                                                                            line_no_,
                                                                            rel_no_,
                                                                            line_item_no_);
   -- Retrieve the total qty shipped in catch unit
   shipped_catch_qty_ := Deliver_Customer_Order_API.Get_Catch_Qty_Shipped(order_no_,
                                                                          line_no_,
                                                                          rel_no_,
                                                                          line_item_no_);
   -- Calculate the average price conversion factor to store on the order line
   buy_qty_shipped_and_picked_ := (order_line_rec_.qty_picked + order_line_rec_.qty_shipped) / order_line_rec_.conv_factor * order_line_rec_.inverted_conv_factor;

   IF (buy_qty_shipped_and_picked_ > 0) THEN
      price_conv_factor_ := (picked_catch_qty_ + shipped_catch_qty_) / buy_qty_shipped_and_picked_;

      -- Update price conversion factor on the CO line
      Customer_Order_Line_API.Modify_Price_Conv_Factor(order_no_, line_no_, rel_no_, line_item_no_, price_conv_factor_);
   END IF;
END Recalc_Catch_Price_Conv_Factor;

-- Get_No_Of_Packages_Picked
--   Return the Total No of Packages fully picked for a given package part.
@UncheckedAccess
FUNCTION Get_No_Of_Packages_Picked (
   order_no_    IN VARCHAR2,
   line_no_     IN VARCHAR2,
   rel_no_      IN VARCHAR2 ) RETURN NUMBER
IS
   no_of_packages_picked_   NUMBER;
 
   -- Get the minimum picked quantity relative to the package part on a component line.
   CURSOR get_min_packages_picked IS
      SELECT NVL(MIN(TRUNC(DECODE(part_no, NULL, qty_to_ship, qty_picked) * (inverted_conv_factor/conv_factor)/(qty_per_assembly))),0)
      FROM CUSTOMER_ORDER_LINE_TAB 
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no > 0      
      AND   supply_code  NOT IN ('PD', 'IPD');
BEGIN
   OPEN  get_min_packages_picked;
   FETCH get_min_packages_picked INTO no_of_packages_picked_;
   CLOSE get_min_packages_picked;
   
   RETURN no_of_packages_picked_;
END Get_No_Of_Packages_Picked;

-- Check_Start_Warehouse_Task
--   Implements logic to approve disapprove start of warehouse tasks
PROCEDURE Check_Start_Warehouse_Task (
   pick_list_no_ IN VARCHAR2 )
IS
   CURSOR get_pick_list_info IS
      SELECT contract, part_no, configuration_id, location_no, lot_batch_no, serial_no, eng_chg_level, 
             waiv_dev_rej_no, activity_seq, handling_unit_id, qty_assigned, qty_picked  
        FROM customer_order_reservation_tab
       WHERE pick_list_no = pick_list_no_;
BEGIN
   FOR rec_ IN get_pick_list_info LOOP
      IF (Inventory_Part_In_Stock_API.Is_Frozen_For_Counting(contract_           => rec_.contract, 
                                                             part_no_            => rec_.part_no, 
                                                             configuration_id_   => rec_.configuration_id, 
                                                             location_no_        => rec_.location_no, 
                                                             lot_batch_no_       => rec_.lot_batch_no, 
                                                             serial_no_          => rec_.serial_no, 
                                                             eng_chg_level_      => rec_.eng_chg_level, 
                                                             waiv_dev_rej_no_    => rec_.waiv_dev_rej_no, 
                                                             activity_seq_       => rec_.activity_seq,
                                                             handling_unit_id_   => rec_.handling_unit_id)) THEN
         Error_SYS.Record_General(lu_name_, 
                                  'FREEZEPART: Inventory Part :P1 on location :P2 at site :P3 is blocked for inventory transactions because of counting.', 
                                  rec_.part_no, 
                                  rec_.location_no, 
                                  rec_.contract);
      END IF;
   END LOOP;
END Check_Start_Warehouse_Task;


-- Check_All_License_Connected
--   Check if export license is connected.
PROCEDURE Check_All_License_Connected (
   display_info_ IN OUT NUMBER, 
   order_no_     IN     VARCHAR2,
   line_no_      IN     VARCHAR2,
   rel_no_       IN     VARCHAR2,
   line_item_no_ IN     NUMBER )
IS
BEGIN
   IF (Customer_Order_Flow_API.Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN
         DECLARE 
            all_license_connected_     VARCHAR2(10):= 'TRUE';
            raise_message_             VARCHAR2(5) := 'FALSE';   
         BEGIN
            Exp_License_Connect_Util_API.Get_Order_License_Connect_Info(all_license_connected_, raise_message_, order_no_, line_no_, rel_no_, line_item_no_);
            IF raise_message_ = 'TRUE' THEN 
               IF all_license_connected_ = 'TRUE' THEN
                  -- License are not connected but user has override license connection rights.
                  display_info_ := 1;
               ELSIF all_license_connected_ = 'FALSE' THEN
                  -- License are not connected and user does not have override license connection rights.
                  display_info_ := 2;
               END IF;
            END IF;
         END;
      $ELSE
         NULL;
      $END
   END IF;
END Check_All_License_Connected;


-- This method is used by DataCaptReportPickHu, DataCaptReportPickPart and DataCaptStartPicking
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_             IN VARCHAR2,
   capture_session_id_   IN NUMBER,
   lov_type_db_          IN VARCHAR2,
   sql_where_expression_ IN VARCHAR2 DEFAULT NULL )
IS
   session_rec_        Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_ NUMBER;
   exit_lov_           BOOLEAN := FALSE;
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_     Get_Lov_Values;
   stmt_               VARCHAR2(4000);
   lov_value_tab_      Lov_Value_Tab;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      stmt_ := 'SELECT DISTINCT pick_list_no 
                FROM CUST_ORD_PICK_LIST_JOIN coplj
                WHERE contract             = :contract_
                AND   picking_confirmed_db = ''UNPICKED''
                AND   Customer_Order_Flow_API.Report_Picking_Ok__(pick_list_no) = 1 ';                

      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;

      stmt_ := stmt_ || ' ORDER BY Utility_SYS.String_To_Number(pick_list_no) ASC, pick_list_no ASC';

      @ApproveDynamicStatement(2017-02-14,DAZASE)
      OPEN get_lov_values_ FOR stmt_ USING contract_;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;

   $ELSE
      NULL;   
   $END
END Create_Data_Capture_Lov;


-- This method is used by DataCaptReportPickPart
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   unique_line_id_             IN VARCHAR2,
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   rel_no_                     IN VARCHAR2,
   line_item_no_               IN NUMBER,
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   shipment_id_                IN NUMBER, 
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   data_item_id_               IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   lov_id_                     IN NUMBER DEFAULT 1 )
IS
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_           Get_Lov_Values;
   stmt_                     VARCHAR2(6000);
   lov_value_tab_            Lov_Value_Tab;
   second_column_name_       VARCHAR2(200);
   second_column_value_      VARCHAR2(200);
   lov_item_description_     VARCHAR2(200);
   local_part_no_            VARCHAR2(25);
   local_location_no_        VARCHAR2(35);
   qty_assigned_             NUMBER;
   qty_picked_               NUMBER;
   session_rec_              Data_Capture_Common_Util_API.Session_Rec;
   unique_line_id_in_a_loop_ BOOLEAN := FALSE;
   lov_row_limitation_       NUMBER;
   exit_lov_                 BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      session_rec_        := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      IF lov_id_ = 1 THEN  -- using Report_Pick_List as data source

         -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
         Assert_SYS.Assert_Is_View_Column('Report_Pick_List', column_name_);
   
         stmt_ := 'SELECT ' || column_name_ 
              || ' FROM Report_Pick_List
                   WHERE contract      = :contract_                   
                   AND   pick_list_no  != ''*''
                   AND   qty_picked    = 0
                   AND   qty_assigned  > 0';
                   
         IF (pick_list_no_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
         ELSE
            stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
         END IF;
         IF (unique_line_id_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND cust_ord_reservation_objid = :unique_line_id_ ';
         ELSE
            stmt_ := stmt_|| ' AND :unique_line_id_ IS NULL  ';
         END IF;

         IF (order_no_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND order_no = :order_no_ ';
         ELSE
            stmt_ := stmt_|| ' AND :order_no_ IS NULL  ';
         END IF;

         IF (line_no_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND line_no = :line_no_ ';
         ELSE
            stmt_ := stmt_|| ' AND :line_no_ IS NULL  ';
         END IF;
         IF (rel_no_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND rel_no = :rel_no_ ';
         ELSE
            stmt_ := stmt_|| ' AND :rel_no_ IS NULL  ';
         END IF;
         IF (line_item_no_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND line_item_no = :line_item_no_ ';
         ELSE
            stmt_ := stmt_|| ' AND :line_item_no_ IS NULL  ';
         END IF;           
         IF (part_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND part_no = :part_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :part_no_ IS NULL ';
         END IF;
         IF (location_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND location_no = :location_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :location_no_ IS NULL ';
         END IF;
          IF (serial_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND serial_no = :serial_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :serial_no_ IS NULL ';
         END IF;
          IF (lot_batch_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL ';
         END IF;
          IF (waiv_dev_rej_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL ';
         END IF;
         IF (eng_chg_level_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_ ';
         ELSE
            stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL ';
         END IF;
         IF (configuration_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND configuration_id = :configuration_id_ ';
         ELSE
            stmt_ := stmt_ || ' AND :configuration_id_ IS NULL ';
         END IF;      
          IF (activity_seq_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND activity_seq = :activity_seq_ ';
         ELSE
            stmt_ := stmt_ || ' AND :activity_seq_ IS NULL ';
         END IF;
         IF (handling_unit_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_ ';
         ELSE
            stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL ';
         END IF;

         IF (sscc_ = '%') THEN 
            stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
         ELSIF (sscc_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND sscc  = :sscc_ ';
         ELSE
            stmt_ := stmt_ || ' AND (sscc IS NULL AND :sscc_ IS NULL) ';
         END IF;

         IF (alt_handling_unit_label_id_ = '%') THEN 
            stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
         ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
         ELSE
            stmt_ := stmt_ || ' AND (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
         END IF;
         IF (shipment_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND shipment_id  = :shipment_id_ ';
         ELSE
            stmt_ := stmt_ || ' AND :shipment_id_ IS NULL ';
         END IF;         
                   
         IF (column_name_ = 'CUST_ORD_RESERVATION_OBJID') THEN
            IF (Data_Capt_Conf_Data_Item_API.Is_Data_Item_In_A_Loop(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_)) THEN
               stmt_ := stmt_  || ' AND Data_Capt_Report_Pick_Part_API.Consume_Unique_Line_Id(:capture_session_id_, CONTRACT, PICK_LIST_NO,
                                                                                              ROWIDTOCHAR(cust_ord_reservation_objid), ORDER_NO,
                                                                                              LINE_NO, REL_NO, LINE_ITEM_NO, PART_NO, LOCATION_NO,
                                                                                              LOT_BATCH_NO, WAIV_DEV_REJ_NO, ENG_CHG_LEVEL,
                                                                                              CONFIGURATION_ID, ACTIVITY_SEQ, HANDLING_UNIT_ID, SHIPMENT_ID) = ''FALSE'' ';
               unique_line_id_in_a_loop_ := TRUE;
            END IF;
         END IF;
         IF (column_name_ = 'SHIPMENT_ID') THEN
            stmt_ := stmt_  || ' ORDER BY SHIPMENT_ID ';
         ELSE
            -- Add the general route order sorting 
            -- NOTE: that for this LOV we dont sort on the column that is fetched compared to similar LOVs for WADACO processes since this needs be exactly same order 
            -- as the IEE client (tbwPickReportDiffSingle). Also this is the exact same ORDER BY as the IEE client have, but if it will not give the same order everytime 
            -- for things that are not part of the ORDER BY, so sometimes the order in this LOV and that of the IEE client could be different.
            stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(warehouse_route_order) ASC, 
                                          UPPER(warehouse_route_order) ASC,
                                          Utility_SYS.String_To_Number(bay_route_order) ASC, 
                                          UPPER(decode(bay_route_order, ''  -'', Database_SYS.Get_Last_Character, bay_route_order)) ASC, 
                                          Utility_SYS.String_To_Number(row_route_order) ASC, 
                                          UPPER(decode(row_route_order, ''  -'', Database_SYS.Get_Last_Character,row_route_order)) ASC,
                                          Utility_SYS.String_To_Number(tier_route_order) ASC, 
                                          UPPER(decode(tier_route_order, ''  -'', Database_SYS.Get_Last_Character, tier_route_order)) ASC, 
                                          Utility_SYS.String_To_Number(bin_route_order) ASC, 
                                          UPPER(decode(bin_route_order, ''  -'', Database_SYS.Get_Last_Character, bin_route_order)) ASC,
                                          location_no, 
                                          order_no,                                 
                                          LPAD(line_no,4),
                                          LPAD(rel_no,4),
                                          line_item_no ';
         END IF;
   
         IF (unique_line_id_in_a_loop_) THEN
            @ApproveDynamicStatement(2014-08-13,ROJALK)
            OPEN get_lov_values_ FOR stmt_ USING contract_,
                                                pick_list_no_,
                                                unique_line_id_,
                                                order_no_,
                                                line_no_,
                                                rel_no_,
                                                line_item_no_,
                                                part_no_,
                                                location_no_,
                                                serial_no_,
                                                lot_batch_no_,
                                                waiv_dev_rej_no_,
                                                eng_chg_level_,
                                                configuration_id_,
                                                activity_seq_,
                                                handling_unit_id_,
                                                sscc_,                                      
                                                alt_handling_unit_label_id_,
                                                shipment_id_,
                                                capture_session_id_;
         ELSE
            @ApproveDynamicStatement(2014-08-13,ROJALK)
            OPEN get_lov_values_ FOR stmt_ USING contract_,
                                                 pick_list_no_,
                                                 unique_line_id_,
                                                 order_no_,
                                                 line_no_,
                                                 rel_no_,
                                                 line_item_no_,
                                                 part_no_,
                                                 location_no_,
                                                 serial_no_,
                                                 lot_batch_no_,
                                                 waiv_dev_rej_no_,
                                                 eng_chg_level_,
                                                 configuration_id_,
                                                 activity_seq_,
                                                 handling_unit_id_,                                                
                                                 sscc_,                                                 
                                                 alt_handling_unit_label_id_,
                                                 shipment_id_;
   
         END IF;


      -- If this process is used together with the START_PICKING process we need to break current sorting and add route order/location/handling unit 
      -- sorting similar to the aggregated tab. This so we can group the lines connected to a specific location and handling unit id together. 
      ELSIF lov_id_ = 2 THEN  -- using Report_Picking_Part_Process as a data source and different sorting
         -- No unique_line_id_in_a_loop_ handling in this LOV variant since this variant is more of 1 record at the time and then back to 
         -- Start Process for the next record without Loops inside Part Process

         -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
         Assert_SYS.Assert_Is_View_Column('Report_Picking_Part_Process', column_name_);

         stmt_ := 'SELECT ' || column_name_ 
              || ' FROM Report_Picking_Part_Process
                   WHERE contract                   = :contract                   
                   AND   pick_list_no              != ''*''
                   AND   qty_picked                 = 0
                   AND   qty_assigned               > 0';
                   
         IF (pick_list_no_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND   pick_list_no = :pick_list_no_ ';
         ELSE
            stmt_ := stmt_|| ' AND   :pick_list_no_ IS NULL  ';
         END IF;
         IF (unique_line_id_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND   cust_ord_reservation_objid = :unique_line_id_ ';
         ELSE
            stmt_ := stmt_|| ' AND   :unique_line_id_ IS NULL  ';
         END IF;

         IF (order_no_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND   order_no = :order_no_ ';
         ELSE
            stmt_ := stmt_|| ' AND   :order_no_ IS NULL  ';
         END IF;

         IF (line_no_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND   line_no = :line_no_ ';
         ELSE
            stmt_ := stmt_|| ' AND   :line_no_ IS NULL  ';
         END IF;
         IF (rel_no_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND   rel_no = :rel_no_ ';
         ELSE
            stmt_ := stmt_|| ' AND   :rel_no_ IS NULL  ';
         END IF;
         IF (line_item_no_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND   line_item_no = :line_item_no_ ';
         ELSE
            stmt_ := stmt_|| ' AND   :line_item_no_ IS NULL  ';
         END IF;           
         IF (part_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND part_no  = :part_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :part_no_ IS NULL ';
         END IF;
         IF (location_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND location_no  = :location_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :location_no_ IS NULL ';
         END IF;
          IF (serial_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND serial_no  = :serial_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :serial_no_ IS NULL ';
         END IF;
          IF (lot_batch_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND lot_batch_no  = :lot_batch_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL ';
         END IF;
          IF (waiv_dev_rej_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND waiv_dev_rej_no  = :waiv_dev_rej_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL ';
         END IF;
         IF (eng_chg_level_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND eng_chg_level  = :eng_chg_level_ ';
         ELSE
            stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL ';
         END IF;
         IF (configuration_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND configuration_id  = :configuration_id_ ';
         ELSE
            stmt_ := stmt_ || ' AND :configuration_id_ IS NULL ';
         END IF;      
          IF (activity_seq_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND activity_seq  = :activity_seq_ ';
         ELSE
            stmt_ := stmt_ || ' AND :activity_seq_ IS NULL ';
         END IF;
         IF (handling_unit_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND handling_unit_id  = :handling_unit_id_ ';
         ELSE
            stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL ';
         END IF;

         IF (sscc_ = '%') THEN 
            stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
         ELSIF (sscc_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND sscc  = :sscc_ ';
         ELSE
            stmt_ := stmt_ || ' AND (sscc IS NULL AND :sscc_ IS NULL) ';
         END IF;

         IF (alt_handling_unit_label_id_ = '%') THEN 
            stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
         ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
         ELSE
            stmt_ := stmt_ || ' AND (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
         END IF;
         IF (shipment_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND shipment_id  = :shipment_id ';
         ELSE
            stmt_ := stmt_ || ' AND :shipment_id IS NULL ';
         END IF;         

         -- Add the general route order sorting 
         -- NOTE: that for this LOV we dont sort on the column that is fetched compared to similar LOVs for WADACO processes 
         -- since this needs be route order sorted. 
         -- The decode in top_parent_handling_unit_id handling and the NVL on structure_level is so broken handling units 
         -- (hu id != 0 and outmost hu = NULL) will come after non handling units and before complete handlings units per location.
         -- Extra sorting on outermost_handling_unit_id to make sure broken handling units comes before complete handling units.
         stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(warehouse_route_order) ASC, 
                                       UPPER(warehouse_route_order) ASC,
                                       Utility_SYS.String_To_Number(bay_route_order) ASC, 
                                       UPPER(decode(bay_route_order, ''  -'', Database_SYS.Get_Last_Character, bay_route_order)) ASC, 
                                       Utility_SYS.String_To_Number(row_route_order) ASC, 
                                       UPPER(decode(row_route_order, ''  -'', Database_SYS.Get_Last_Character,row_route_order)) ASC,
                                       Utility_SYS.String_To_Number(tier_route_order) ASC, 
                                       UPPER(decode(tier_route_order, ''  -'', Database_SYS.Get_Last_Character, tier_route_order)) ASC, 
                                       Utility_SYS.String_To_Number(bin_route_order) ASC, 
                                       UPPER(decode(bin_route_order, ''  -'', Database_SYS.Get_Last_Character, bin_route_order)) ASC,
                                       location_no,
                                       NVL(outermost_handling_unit_id,0),
                                       NVL(top_parent_handling_unit_id, DECODE(outermost_handling_unit_id,NULL,0,handling_unit_id)),
                                       NVL(structure_level,0),
                                       handling_unit_id,
                                       order_no,                                 
                                       LPAD(line_no,4),
                                       LPAD(rel_no,4),
                                       line_item_no ';

         @ApproveDynamicStatement(2017-04-05,DAZASE)
         OPEN get_lov_values_ FOR stmt_ USING contract_,
                                              pick_list_no_,
                                              unique_line_id_,
                                              order_no_,
                                              line_no_,
                                              rel_no_,
                                              line_item_no_,
                                              part_no_,
                                              location_no_,
                                              serial_no_,
                                              lot_batch_no_,
                                              waiv_dev_rej_no_,
                                              eng_chg_level_,
                                              configuration_id_,
                                              activity_seq_,
                                              handling_unit_id_,                                             
                                              sscc_,                                              
                                              alt_handling_unit_label_id_,
                                              shipment_id_;
      END IF;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
         -- Since we are using a more advanced order by now we cannot use DISTINCT in the select 
         -- so we have now to remove all duplicate values from the LOV collection.
         lov_value_tab_ := Remove_Duplicate_Lov_Values___(lov_value_tab_);
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         CASE (column_name_)
            WHEN ('CUST_ORD_RESERVATION_OBJID') THEN
               second_column_name_ := 'PART_DESC_LOC_DESC_QTY';
            WHEN ('PART_NO') THEN
               second_column_name_ := 'PART_DESCRIPTION';
            WHEN ('LOCATION_NO') THEN
               second_column_name_ := 'LOCATION_DESCRIPTION';
            WHEN ('SHIPMENT_ID') THEN
               second_column_name_ := 'RECEIVER_NAME_SHP';
            ELSE
               NULL;
         END CASE;
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ IN ('PART_DESC_LOC_DESC_QTY')) THEN
                     local_part_no_     := Get_Column_Value_If_Unique(contract_, pick_list_no_, lov_value_tab_(i), order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_, serial_no_, lot_batch_no_, 
                                                                      waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, shipment_id_, 'PART_NO');
                     local_location_no_ := Get_Column_Value_If_Unique(contract_, pick_list_no_, lov_value_tab_(i), order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_, serial_no_, lot_batch_no_, 
                                                                      waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, shipment_id_, 'LOCATION_NO');
   
   
                     qty_assigned_ := Get_Column_Value_If_Unique(contract_, pick_list_no_, lov_value_tab_(i), order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_, serial_no_, lot_batch_no_, 
                                                                 waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, shipment_id_, 'QTY_ASSIGNED');
                     qty_picked_   := Get_Column_Value_If_Unique(contract_, pick_list_no_, lov_value_tab_(i), order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_, serial_no_, lot_batch_no_, 
                                                                 waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, shipment_id_, 'QTY_PICKED');
   
                     second_column_value_ := Inventory_Part_API.Get_Description(contract_, local_part_no_) || ' | ' ||
                                             Inventory_Location_API.Get_Location_Name(contract_, local_location_no_) || ' | ' ||
                                             TO_CHAR(NVL(qty_assigned_,0) - NVL(qty_picked_,0));
   
                  ELSIF (second_column_name_ IN ('PART_DESCRIPTION')) THEN
                     second_column_value_ := Inventory_Part_API.Get_Description(contract_, lov_value_tab_(i));
                  ELSIF (second_column_name_ IN ('LOCATION_DESCRIPTION')) THEN
                     second_column_value_ := Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
                  ELSIF (second_column_name_ IN ('RECEIVER_NAME_SHP')) THEN
                     second_column_value_ := Shipment_Source_Utility_API.Get_Receiver_Name(Shipment_API.Get_Receiver_Id(lov_value_tab_(i)), 
                                                                                           Shipment_API.Get_Receiver_Type_Db(lov_value_tab_(i)));
                  END IF;
                  IF (second_column_value_ IS NOT NULL) THEN
                     lov_item_description_ := second_column_value_;
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


-- This method is used by DataCaptReportPickPart
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   unique_line_id_             IN VARCHAR2,
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   rel_no_                     IN VARCHAR2,
   line_item_no_               IN NUMBER,
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   shipment_id_                IN NUMBER,
   column_name_                IN VARCHAR2 ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_   Get_Column_Value;
   stmt_                VARCHAR2(4000);   
   unique_column_value_ VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab;  
BEGIN

   -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('Report_Pick_List', column_name_);
   
   stmt_ := 'SELECT DISTINCT(' || column_name_ || ') 
             FROM  Report_Pick_List
             WHERE contract      = :contract_
             AND   pick_list_no  != ''*''
             AND   qty_picked    = 0
             AND   qty_assigned  > 0 ';
             
   IF (pick_list_no_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
      ELSE
         stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
      END IF;
      IF (unique_line_id_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND cust_ord_reservation_objid = :unique_line_id_ ';
      ELSE
         stmt_ := stmt_|| ' AND :unique_line_id_ IS NULL  ';
      END IF;
      
      IF (order_no_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND order_no = :order_no_ ';
      ELSE
         stmt_ := stmt_|| ' AND :order_no_ IS NULL  ';
      END IF;
      
      IF (line_no_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND line_no = :line_no_ ';
      ELSE
         stmt_ := stmt_|| ' AND :line_no_ IS NULL  ';
      END IF;
      IF (rel_no_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND rel_no = :rel_no_ ';
      ELSE
         stmt_ := stmt_|| ' AND :rel_no_ IS NULL  ';
      END IF;
      IF (line_item_no_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND line_item_no = :line_item_no_ ';
      ELSE
         stmt_ := stmt_|| ' AND :line_item_no_ IS NULL  ';
      END IF;           
      IF (part_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND part_no = :part_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :part_no_ IS NULL ';
      END IF;
      IF (location_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND location_no = :location_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :location_no_ IS NULL ';
      END IF;
       IF (serial_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND serial_no = :serial_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :serial_no_ IS NULL ';
      END IF;
       IF (lot_batch_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL ';
      END IF;
       IF (waiv_dev_rej_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND waiv_dev_rej_no  = :waiv_dev_rej_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL ';
      END IF;
      IF (eng_chg_level_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND eng_chg_level  = :eng_chg_level_ ';
      ELSE
         stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL ';
      END IF;
      IF (configuration_id_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND configuration_id  = :configuration_id_ ';
      ELSE
         stmt_ := stmt_ || ' AND :configuration_id_ IS NULL ';
      END IF;      
       IF (activity_seq_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND activity_seq  = :activity_seq_ ';
      ELSE
         stmt_ := stmt_ || ' AND :activity_seq_ IS NULL ';
      END IF;
      IF (handling_unit_id_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND handling_unit_id  = :handling_unit_id_ ';
      ELSE
         stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL ';
      END IF;
            
      IF (sscc_ = '%') THEN 
         stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
      ELSIF (sscc_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND sscc  = :sscc_ ';
      ELSE
         stmt_ := stmt_ || ' AND (sscc IS NULL AND :sscc_ IS NULL) ';
      END IF;
      
      IF (alt_handling_unit_label_id_ = '%') THEN 
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
      ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
      ELSE
         stmt_ := stmt_ || ' AND (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
      END IF;
      IF (shipment_id_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND shipment_id  = :shipment_id_ ';
      ELSE
         stmt_ := stmt_ || ' AND :shipment_id_ IS NULL ';
      END IF;
      stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';   
   
   @ApproveDynamicStatement(2014-08-13,ROJALK)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           pick_list_no_,
                                           unique_line_id_,
                                           order_no_,
                                           line_no_,
                                           rel_no_,
                                           line_item_no_,
                                           part_no_,
                                           location_no_,
                                           serial_no_,
                                           lot_batch_no_,
                                           waiv_dev_rej_no_,
                                           eng_chg_level_,
                                           configuration_id_,
                                           activity_seq_,
                                           handling_unit_id_,                                           
                                           sscc_,                                          
                                           alt_handling_unit_label_id_,
                                           shipment_id_;  
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;      
      IF (column_value_tab_.COUNT = 1) THEN
         unique_column_value_ := NVL(To_Char(column_value_tab_(1)), 'NULL');     
      END IF;
   CLOSE get_column_values_;     
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptReportPickPart
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   unique_line_id_             IN VARCHAR2,
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   rel_no_                     IN VARCHAR2,
   line_item_no_               IN NUMBER,
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   shipment_id_                IN NUMBER,
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   inv_barcode_validation_     IN BOOLEAN DEFAULT FALSE )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_       Check_Exist;
   stmt_                VARCHAR2(4000);
   dummy_               NUMBER;
   exist_               BOOLEAN := FALSE;
BEGIN

   IF (NOT inv_barcode_validation_) THEN  
      -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('Report_Pick_List', column_name_);
   END IF;

   stmt_ := 'SELECT 1
             FROM  Report_Pick_List
             WHERE contract      = :contract_             
             AND   pick_list_no  != ''*''
             AND   qty_picked    = 0
             AND   qty_assigned  > 0 ';
             
   IF (pick_list_no_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
    ELSE
       stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
    END IF;
    IF (unique_line_id_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND cust_ord_reservation_objid = :unique_line_id_ ';
    ELSE
       stmt_ := stmt_|| ' AND :unique_line_id_ IS NULL  ';
    END IF;

    IF (order_no_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND order_no = :order_no_ ';
    ELSE
       stmt_ := stmt_|| ' AND :order_no_ IS NULL  ';
    END IF;

    IF (line_no_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND line_no = :line_no_ ';
    ELSE
       stmt_ := stmt_|| ' AND :line_no_ IS NULL  ';
    END IF;
    IF (rel_no_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND rel_no = :rel_no_ ';
    ELSE
       stmt_ := stmt_|| ' AND :rel_no_ IS NULL  ';
    END IF;
    IF (line_item_no_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND line_item_no = :line_item_no_ ';
    ELSE
       stmt_ := stmt_|| ' AND :line_item_no_ IS NULL  ';
    END IF;           
    IF (part_no_ IS NOT NULL) THEN 
       stmt_ := stmt_ || ' AND part_no = :part_no_ ';
    ELSE
       stmt_ := stmt_ || ' AND :part_no_ IS NULL ';
    END IF;
    IF (location_no_ IS NOT NULL) THEN 
       stmt_ := stmt_ || ' AND location_no = :location_no_ ';
    ELSE
       stmt_ := stmt_ || ' AND :location_no_ IS NULL ';
    END IF;
     IF (serial_no_ IS NOT NULL) THEN 
       stmt_ := stmt_ || ' AND serial_no = :serial_no_ ';
    ELSE
       stmt_ := stmt_ || ' AND :serial_no_ IS NULL ';
    END IF;
     IF (lot_batch_no_ IS NOT NULL) THEN 
       stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_ ';
    ELSE
       stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL ';
    END IF;
     IF (waiv_dev_rej_no_ IS NOT NULL) THEN 
       stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_ ';
    ELSE
       stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL ';
    END IF;
    IF (eng_chg_level_ IS NOT NULL) THEN 
       stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_ ';
    ELSE
       stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL ';
    END IF;
    IF (configuration_id_ IS NOT NULL) THEN 
       stmt_ := stmt_ || ' AND configuration_id = :configuration_id_ ';
    ELSE
       stmt_ := stmt_ || ' AND :configuration_id_ IS NULL ';
    END IF;      
     IF (activity_seq_ IS NOT NULL) THEN 
       stmt_ := stmt_ || ' AND activity_seq = :activity_seq_ ';
    ELSE
       stmt_ := stmt_ || ' AND :activity_seq_ IS NULL ';
    END IF;
    IF (handling_unit_id_ IS NOT NULL) THEN 
       stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_ ';
    ELSE
       stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL ';
    END IF;

    IF (sscc_ = '%') THEN 
       stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
    ELSIF (sscc_ IS NOT NULL) THEN 
       stmt_ := stmt_ || ' AND sscc = :sscc_ ';
    ELSE
       stmt_ := stmt_ || ' AND (sscc IS NULL AND :sscc_ IS NULL) ';
    END IF;

    IF (alt_handling_unit_label_id_ = '%') THEN 
       stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
    ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
       stmt_ := stmt_ || ' AND alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
    ELSE
       stmt_ := stmt_ || ' AND (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
    END IF;
    IF (shipment_id_ IS NOT NULL) THEN 
       stmt_ := stmt_ || ' AND shipment_id = :shipment_id_ ';
    ELSE
       stmt_ := stmt_ || ' AND :shipment_id_ IS NULL ';
    END IF;


   IF (NOT inv_barcode_validation_) THEN  
      stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
   END IF;
   

   IF (inv_barcode_validation_) THEN
      @ApproveDynamicStatement(2017-11-16,DAZASE)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          pick_list_no_,
                                          unique_line_id_,
                                          order_no_,
                                          line_no_,
                                          rel_no_,
                                          line_item_no_,
                                          part_no_,
                                          location_no_,
                                          serial_no_,
                                          lot_batch_no_,
                                          waiv_dev_rej_no_,
                                          eng_chg_level_,
                                          configuration_id_,
                                          activity_seq_,
                                          handling_unit_id_,                                         
                                          sscc_,                                          
                                          alt_handling_unit_label_id_,
                                          shipment_id_;
   ELSE
      @ApproveDynamicStatement(2014-08-13,ROJALK)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          pick_list_no_,
                                          unique_line_id_,
                                          order_no_,
                                          line_no_,
                                          rel_no_,
                                          line_item_no_,
                                          part_no_,
                                          location_no_,
                                          serial_no_,
                                          lot_batch_no_,
                                          waiv_dev_rej_no_,
                                          eng_chg_level_,
                                          configuration_id_,
                                          activity_seq_,
                                          handling_unit_id_,                                          
                                          sscc_,                                          
                                          alt_handling_unit_label_id_,
                                          shipment_id_,
                                          column_value_,
                                          column_value_;
   END IF;
             
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      IF (inv_barcode_validation_) THEN
         Error_SYS.Record_General(lu_name_, 'BARCODENOTEXIST: The Barcode record does not match current Report Picking Line.');
      ELSE
         Raise_No_Picklist_Error___(column_value_, pick_list_no_);
      END IF;
   END IF;
END Record_With_Column_Value_Exist;

-- This method is used by DataCaptReportPickHu
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   aggregated_line_id_         IN VARCHAR2,
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_              Get_Lov_Values;
   stmt_                        VARCHAR2(6000);
   lov_value_tab_               Lov_Value_Tab;
   second_column_name_          VARCHAR2(200);
   second_column_value_         VARCHAR2(200);
   lov_item_description_        VARCHAR2(200);
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   aggr_line_id_in_a_loop_       BOOLEAN := FALSE;
   lov_row_limitation_           NUMBER;
   exit_lov_                     BOOLEAN := FALSE;
   tmp_location_no_              VARCHAR2(35);
   temp_handling_unit_id_        NUMBER;
   temp_sscc_                    VARCHAR2(18);
   temp_alt_handl_unit_label_id_ VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_        := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('Report_Picking_Hu_Process', column_name_);
      
      stmt_ := 'SELECT ' || column_name_ 
           || ' FROM Report_Picking_Hu_Process 
                WHERE contract  = :contract_ ';
               
      IF (pick_list_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
      ELSE
         stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
      END IF;
      IF (aggregated_line_id_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND aggregated_line_id = :aggregated_line_id_ ';
      ELSE
         stmt_ := stmt_|| ' AND :aggregated_line_id_ IS NULL  ';
      END IF;

      IF (location_no_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND location_no = :location_no_ ';
      ELSE
         stmt_ := stmt_|| ' AND :location_no_ IS NULL  ';
      END IF;

      IF (handling_unit_id_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND handling_unit_id = :handling_unit_id_ ';
      ELSE
         stmt_ := stmt_|| ' AND :handling_unit_id_ IS NULL  ';
      END IF;

      IF (sscc_ = '%') THEN 
         stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
      ELSIF (sscc_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND sscc  = :sscc_ ';
      ELSE
         stmt_ := stmt_ || ' AND (sscc IS NULL AND :sscc_ IS NULL) ';
      END IF;

      IF (alt_handling_unit_label_id_ = '%') THEN 
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
      ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
      ELSE
         stmt_ := stmt_ || ' AND (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
      END IF;        
      
      -- Add extra filtering of earlier scanned values of this data item to dynamic cursor if data item is AGGREGATED_LINE_ID and is in a loop for this configuration
      IF (column_name_ = 'AGGREGATED_LINE_ID') THEN
         IF (Data_Capt_Conf_Data_Item_API.Is_Data_Item_In_A_Loop(session_rec_.capture_process_id, session_rec_.capture_config_id, 'AGGREGATED_LINE_ID')) THEN
            stmt_ := stmt_  || ' AND NOT EXISTS (SELECT 1 FROM DATA_CAPTURE_SESSION_LINE_PUB WHERE capture_session_id = :capture_session_id_
                                                                                              AND  data_item_id = ''AGGREGATED_LINE_ID''
                                                                                              AND  data_item_detail_id IS NULL
                                                                                              AND  data_item_value = ROWIDTOCHAR(aggregated_line_id)) ';   
            aggr_line_id_in_a_loop_ := TRUE;
         END IF;
      END IF;
      -- TODO: We might have issues if it is a large hu structure with several levels, those will not be consumed here with this solution,
      -- there is similar problem with the other 2 hu processes, we turned off fake consumation for transport task hu due to this and other issues.
      -- Not sure that we can support fake consumation for large hu structures, needs investigation if we get issues with this.

      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;

      -- Add the general route order sorting 
      -- NOTE: that for this LOV we dont sort on the column that is fetched compared to similar LOVs for WADACO processes since this needs be exactly same order 
      -- as the IEE client (frmPickReportDiffAggregated.tblPickAggregated). Also this is the exact same ORDER BY as the IEE client have, but if it will not give 
      -- the same order everytime for things that are not part of the ORDER BY, so sometimes the order in this LOV and that of the IEE client could be different.
      stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(warehouse_route_order) ASC, 
                                    UPPER(warehouse_route_order) ASC,
                                    Utility_SYS.String_To_Number(bay_route_order) ASC, 
                                    UPPER(decode(bay_route_order, ''  -'', Database_SYS.Get_Last_Character, bay_route_order)) ASC, 
                                    Utility_SYS.String_To_Number(row_route_order) ASC, 
                                    UPPER(decode(row_route_order, ''  -'', Database_SYS.Get_Last_Character,row_route_order)) ASC,
                                    Utility_SYS.String_To_Number(tier_route_order) ASC, 
                                    UPPER(decode(tier_route_order, ''  -'', Database_SYS.Get_Last_Character, tier_route_order)) ASC, 
                                    Utility_SYS.String_To_Number(bin_route_order) ASC, 
                                    UPPER(decode(bin_route_order, ''  -'', Database_SYS.Get_Last_Character, bin_route_order)) ASC,
                                    location_no,
                                    structure_level ';

      IF (aggr_line_id_in_a_loop_) THEN
         @ApproveDynamicStatement(2017-02-01,DAZASE)
         OPEN get_lov_values_ FOR stmt_ USING contract_,
                                     pick_list_no_,
                                     aggregated_line_id_,
                                     location_no_,
                                     handling_unit_id_,                                    
                                     sscc_,                                     
                                     alt_handling_unit_label_id_,
                                     capture_session_id_;
      ELSE
         @ApproveDynamicStatement(2017-02-01,DAZASE)
         OPEN get_lov_values_ FOR stmt_ USING contract_,
                                              pick_list_no_,
                                              aggregated_line_id_,
                                              location_no_,
                                              handling_unit_id_,                                             
                                              sscc_,                                              
                                              alt_handling_unit_label_id_;
      END IF;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
         -- Since we are using a more advanced order by now we cannot use DISTINCT in the select 
         -- so we have now to remove all duplicate values from the LOV collection.
         --lov_value_tab_ := Remove_Duplicate_Lov_Values___(lov_value_tab_);
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         CASE (column_name_)
            WHEN ('AGGREGATED_LINE_ID') THEN
               second_column_name_ := 'LOCATION_AND_HU';
            WHEN ('LOCATION_NO') THEN
               second_column_name_ := 'LOCATION_DESCRIPTION';
            WHEN ('HANDLING_UNIT_ID') THEN
               second_column_name_ := 'HU_STR_LEVEL_AND_DESC';
            WHEN ('SSCC') THEN
               second_column_name_ := 'SSCC_STR_LEVEL_AND_DESC';
            WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
               second_column_name_ := 'ALT_STR_LEVEL_AND_DESC';
            ELSE
               NULL;
         END CASE;
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'LOCATION_AND_HU') THEN
                     IF (session_rec_.capture_process_id = 'REPORT_PICKING_HU') THEN -- just in case some other process starts using this LOV since they dont have these details probably
                        IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_HANDLING_UNIT_ID'))) THEN
                           temp_handling_unit_id_ := Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                                pick_list_no_               => pick_list_no_,
                                                                                aggregated_line_id_         => lov_value_tab_(i),
                                                                                location_no_                => location_no_,
                                                                                handling_unit_id_           => handling_unit_id_,
                                                                                sscc_                       => sscc_,
                                                                                alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                column_name_                => 'HANDLING_UNIT_ID');
                        END IF;
                        IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_SSCC'))) THEN
                           temp_sscc_ := Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                    pick_list_no_               => pick_list_no_,
                                                                    aggregated_line_id_         => lov_value_tab_(i),
                                                                    location_no_                => location_no_,
                                                                    handling_unit_id_           => handling_unit_id_,
                                                                    sscc_                       => sscc_,
                                                                    alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                    column_name_                => 'SSCC');
                        END IF;
                        IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_ALT_HANDLING_UNIT_LABEL_ID'))) THEN
                           temp_alt_handl_unit_label_id_ := Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                                       pick_list_no_               => pick_list_no_,
                                                                                       aggregated_line_id_         => lov_value_tab_(i),
                                                                                       location_no_                => location_no_,
                                                                                       handling_unit_id_           => handling_unit_id_,
                                                                                       sscc_                       => sscc_,
                                                                                       alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                       column_name_                => 'ALT_HANDLING_UNIT_LABEL_ID');
                        END IF;
                        tmp_location_no_ := Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                       pick_list_no_               => pick_list_no_,
                                                                       aggregated_line_id_         => lov_value_tab_(i),
                                                                       location_no_                => location_no_,
                                                                       handling_unit_id_           => handling_unit_id_,
                                                                       sscc_                       => sscc_,
                                                                       alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                       column_name_                => 'LOCATION_NO');


                        second_column_value_ := tmp_location_no_; 
                        IF (temp_handling_unit_id_ IS NOT NULL) THEN
                           second_column_value_ := second_column_value_ || ' | ' || temp_handling_unit_id_; 
                        END IF;
                        IF (temp_sscc_ IS NOT NULL AND temp_sscc_ != 'NULL') THEN
                           second_column_value_ := second_column_value_ || ' | ' || temp_sscc_; 
                        END IF;
                        IF (temp_alt_handl_unit_label_id_ IS NOT NULL AND temp_alt_handl_unit_label_id_ != 'NULL') THEN
                           second_column_value_ := second_column_value_ || ' | ' || temp_alt_handl_unit_label_id_; 
                        END IF;
                     END IF;
   
                  ELSIF (second_column_name_ IN ('LOCATION_DESCRIPTION')) THEN
                     second_column_value_ := Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'HU_STR_LEVEL_AND_DESC') THEN
                     temp_handling_unit_id_ := lov_value_tab_(i);
                  ELSIF (second_column_name_ = 'SSCC_STR_LEVEL_AND_DESC') THEN
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'ALT_STR_LEVEL_AND_DESC') THEN
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                  END IF;
                  
                  -- Method Handling_Unit_API.Get_Handling_Unit_From_Alt_Id can return null if alt_handling_unit_id is not unique so we better to 
                  -- check if temp_handling_unit_id_ is not null when concatenate with | to avoid empty description with character '|'
                  IF (second_column_name_ IN ('HU_STR_LEVEL_AND_DESC', 'SSCC_STR_LEVEL_AND_DESC', 'ALT_STR_LEVEL_AND_DESC') AND 
                      temp_handling_unit_id_ IS NOT NULL) THEN 
                     second_column_value_ := Handling_Unit_API.Get_Structure_Level(temp_handling_unit_id_) || ' | ' || 
                                             Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(temp_handling_unit_id_));
                  END IF; 
                  
                  IF (second_column_value_ IS NOT NULL) THEN
                     lov_item_description_ := second_column_value_;
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


-- This method is used by DataCaptReportPickHu
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   aggregated_line_id_         IN VARCHAR2,
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   column_name_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_   Get_Column_Value;
   stmt_                VARCHAR2(6000);   
   unique_column_value_ VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab;  
BEGIN

   -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('Report_Picking_Hu_Process', column_name_);
   
   stmt_ := 'SELECT DISTINCT(' || column_name_ || ') 
             FROM  Report_Picking_Hu_Process 
             WHERE contract  = :contract_ ';

   IF (pick_list_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
   ELSE
      stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
   END IF;
   IF (aggregated_line_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND aggregated_line_id = :aggregated_line_id_ ';
   ELSE
      stmt_ := stmt_|| ' AND :aggregated_line_id_ IS NULL  ';
   END IF;
   IF (location_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND location_no = :location_no_ ';
   ELSE
      stmt_ := stmt_|| ' AND :location_no_ IS NULL  ';
   END IF;
   IF (handling_unit_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND handling_unit_id = :handling_unit_id_ ';
   ELSE
      stmt_ := stmt_|| ' AND :handling_unit_id_ IS NULL  ';
   END IF;
   IF (sscc_ = '%') THEN 
      stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
   ELSIF (sscc_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND sscc = :sscc_ ';
   ELSE
      stmt_ := stmt_ || ' AND (sscc IS NULL AND :sscc_ IS NULL) ';
   END IF;

   IF (alt_handling_unit_label_id_ = '%') THEN 
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
   ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
   END IF;
   
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;
   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';   
   
   @ApproveDynamicStatement(2017-02-01,DAZASE)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           pick_list_no_,
                                           aggregated_line_id_,
                                           location_no_,
                                           handling_unit_id_,                                           
                                           sscc_,                                           
                                           alt_handling_unit_label_id_;
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
      IF (column_value_tab_.COUNT = 1) THEN
         unique_column_value_ := NVL(To_Char(column_value_tab_(1)), 'NULL');     
      END IF;
   CLOSE get_column_values_;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptReportPickHu
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   aggregated_line_id_         IN VARCHAR2,
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   column_description_         IN  VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_       Check_Exist;
   stmt_                VARCHAR2(6000);
   dummy_               NUMBER;
   exist_               BOOLEAN := FALSE;
BEGIN

   -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('Report_Picking_Hu_Process', column_name_);

   stmt_ := 'SELECT 1
             FROM  Report_Picking_Hu_Process
             WHERE contract  = :contract_ ';
   
   IF (pick_list_no_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
    ELSE
       stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
    END IF;
    IF (aggregated_line_id_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND aggregated_line_id = :aggregated_line_id_ ';
    ELSE
       stmt_ := stmt_|| ' AND :aggregated_line_id_ IS NULL  ';
    END IF;

    IF (location_no_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND location_no = :location_no_ ';
    ELSE
       stmt_ := stmt_|| ' AND :location_no_ IS NULL  ';
    END IF;

    IF (handling_unit_id_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND handling_unit_id = :handling_unit_id_ ';
    ELSE
       stmt_ := stmt_|| ' AND :handling_unit_id_ IS NULL  ';
    END IF;
   IF (sscc_ = '%') THEN 
      stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
   ELSIF (sscc_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND sscc = :sscc_ ';
   ELSE
      stmt_ := stmt_ || ' AND (sscc IS NULL AND :sscc_ IS NULL) ';
   END IF;

   IF (alt_handling_unit_label_id_ = '%') THEN 
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
   ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
   END IF;
   
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';

   @ApproveDynamicStatement(2017-02-01,DAZASE)
   OPEN exist_control_ FOR stmt_ USING contract_,
                                       pick_list_no_,
                                       aggregated_line_id_,
                                       location_no_,
                                       handling_unit_id_,                                       
                                       sscc_,                                      
                                       alt_handling_unit_label_id_,
                                       column_value_,
                                       column_value_;
             
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      IF (column_name_ = 'PICK_LIST_NO') THEN
         Raise_No_Value_Exist_Error___(column_description_, column_value_);
      ELSE
         Raise_No_Picklist_Error___(column_value_, pick_list_no_);
      END IF;
   END IF;
END Record_With_Column_Value_Exist;

-- This method is used by DataCaptStartPicking
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   location_no_                IN VARCHAR2,
   pick_list_no_level_db_      IN VARCHAR2,
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_              Get_Lov_Values;
   stmt_                        VARCHAR2(6000);
   lov_value_tab_               Lov_Value_Tab;
   lov_item_description_        VARCHAR2(200);
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_           NUMBER;
   exit_lov_                     BOOLEAN := FALSE;
   temp_lov_item_value_    VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_        := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('Start_Picking_Process', column_name_);
      
      stmt_ := 'SELECT ' || column_name_ 
           || ' FROM Start_Picking_Process spp
                WHERE contract  = :contract_ ';
                
      IF (pick_list_no_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
      ELSE
         stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
      END IF; 
      IF (location_no_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND location_no = :location_no_ ';
      ELSE
         stmt_ := stmt_|| ' AND :location_no_ IS NULL  ';
      END IF;
      IF (pick_list_no_level_db_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND part_or_handling_unit = :pick_list_no_level_db_ ';
      ELSE
         stmt_ := stmt_|| ' AND :pick_list_no_level_db_ IS NULL  ';
      END IF;

      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;

      -- Add the general route order sorting 
      -- NOTE: that for this LOV we dont sort on the column that is fetched compared to similar LOVs for WADACO processes since this needs be exactly same order 
      -- as the IEE client (frmPickReportDiffAggregated.tblPickAggregated). Also this is the exact same ORDER BY as the IEE client have, but if it will not give 
      -- the same order everytime for things that are not part of the ORDER BY, so sometimes the order in this LOV and that of the IEE client could be different.
      -- The NVL on handling_unit_id becuase 0 is NULL in this view and we still want non handling units to come before handling units in the start process, 
      -- especially if user choose Action Pick Parts on the Report Picking of Handling Units process, these should come before HU so that is the main reason for
      -- having non handling units before handling unit lines.
      stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(warehouse_route_order) ASC, 
                                    UPPER(warehouse_route_order) ASC,
                                    Utility_SYS.String_To_Number(bay_route_order) ASC, 
                                    UPPER(decode(bay_route_order, ''  -'', Database_SYS.Get_Last_Character, bay_route_order)) ASC, 
                                    Utility_SYS.String_To_Number(row_route_order) ASC, 
                                    UPPER(decode(row_route_order, ''  -'', Database_SYS.Get_Last_Character,row_route_order)) ASC,
                                    Utility_SYS.String_To_Number(tier_route_order) ASC, 
                                    UPPER(decode(tier_route_order, ''  -'', Database_SYS.Get_Last_Character, tier_route_order)) ASC, 
                                    Utility_SYS.String_To_Number(bin_route_order) ASC, 
                                    UPPER(decode(bin_route_order, ''  -'', Database_SYS.Get_Last_Character, bin_route_order)) ASC,
                                    location_no,
                                    NVL(handling_unit_id,0) ';

      @ApproveDynamicStatement(2017-02-01,DAZASE)
      OPEN get_lov_values_ FOR stmt_ USING contract_,
                                           pick_list_no_,
                                           location_no_,
                                           pick_list_no_level_db_;

 
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
         -- Since we are using a more advanced order by now we cannot use DISTINCT in the select 
         -- so we have now to remove all duplicate values from the LOV collection.
         --lov_value_tab_ := Remove_Duplicate_Lov_Values___(lov_value_tab_);
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK 
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (column_name_ = 'LOCATION_NO') THEN
                  lov_item_description_ :=  Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
               END IF;
            END IF;
            IF (column_name_ = 'PART_OR_HANDLING_UNIT') THEN
               temp_lov_item_value_ :=  Part_Or_Handl_Unit_Level_API.Decode(lov_value_tab_(i));
            ELSE
               temp_lov_item_value_ :=  lov_value_tab_(i);
            END IF;

            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => temp_lov_item_value_,
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


-- This method is used by DataCaptStartPicking
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   location_no_                IN VARCHAR2,
   pick_list_no_level_db_      IN VARCHAR2,
   column_name_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;                 
   get_column_values_    Get_Column_Value;     
   stmt_                 VARCHAR2(2000);                    
   unique_column_value_  VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab;  
BEGIN

   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('Start_Picking_Process', column_name_);

   stmt_ := 'SELECT DISTINCT(' || column_name_ || ')  
             FROM Start_Picking_Process
             WHERE contract  = :contract_ ';
   
   IF (pick_list_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
   ELSE
      stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
   END IF;
   IF (location_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND location_no = :location_no_ ';
   ELSE
      stmt_ := stmt_|| ' AND :location_no_ IS NULL  ';
   END IF;      
   IF (pick_list_no_level_db_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND part_or_handling_unit = :pick_list_no_level_db_ ';
   ELSE
      stmt_ := stmt_|| ' AND :pick_list_no_level_db_ IS NULL  ';
   END IF;
    
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;
   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';   
             
   @ApproveDynamicStatement(2017-02-01,DAZASE)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           pick_list_no_,
                                           location_no_,
                                           pick_list_no_level_db_;
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;           
      IF (column_value_tab_.COUNT = 1) THEN      
         unique_column_value_ := NVL(To_Char(column_value_tab_(1)), 'NULL');     
      END IF;
   CLOSE get_column_values_;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptStartPicking
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   location_no_                IN VARCHAR2,
   pick_list_no_level_db_      IN VARCHAR2,
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   column_description_         IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL) 
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(2000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('Start_Picking_Process', column_name_);
   
   stmt_ := 'SELECT 1 
             FROM Start_Picking_Process
             WHERE contract  = :contract_ ';             
   IF (pick_list_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
   ELSE
      stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
   END IF;
   IF (location_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND location_no = :location_no_ ';
   ELSE
      stmt_ := stmt_|| ' AND :location_no_ IS NULL  ';
   END IF;      
   IF (pick_list_no_level_db_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND part_or_handling_unit = :pick_list_no_level_db_ ';
   ELSE
      stmt_ := stmt_|| ' AND :pick_list_no_level_db_ IS NULL  ';
   END IF;

   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
   
   @ApproveDynamicStatement(2017-02-01,DAZASE)
   OPEN exist_control_ FOR stmt_ USING contract_,
                                       pick_list_no_,
                                       location_no_,
                                       pick_list_no_level_db_,
                                       column_value_,
                                       column_value_;


   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      Raise_No_Value_Exist_Error___(column_description_, column_value_);
   END IF;
END Record_With_Column_Value_Exist;


-- This method was created especially for wadaco process Report Picking of Handling Units and will probably not suit anything else
@UncheckedAccess
FUNCTION Lines_Left_To_Pick (
   pick_list_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   lines_   NUMBER;
   CURSOR get_lines_left_to_pick IS
      SELECT COUNT(*)
      FROM   Start_Picking_Process
      WHERE  pick_list_no = pick_list_no_;
BEGIN
   OPEN  get_lines_left_to_pick;
   FETCH get_lines_left_to_pick INTO lines_;
   CLOSE get_lines_left_to_pick;
   RETURN lines_;
END Lines_Left_To_Pick;


-- This method was created especially for wadaco process Report Picking of Handling Units and will probably not suit anything else
@UncheckedAccess
FUNCTION Last_Hndl_Unit_Structure_On_PL (
   pick_list_no_ IN VARCHAR2,
   root_handling_unit_id_ IN NUMBER) RETURN BOOLEAN
IS
   part_lines_                NUMBER;
   temp_handling_unit_id_     NUMBER;
   last_handl_unit_structure_ BOOLEAN := FALSE;

   CURSOR part_lines_left_to_pick_ IS
      SELECT COUNT(*)
      FROM   START_PICKING_PROCESS
      WHERE  pick_list_no = pick_list_no_
       AND   part_or_handling_unit = 'PART';

   CURSOR get_all_remaing_hu_ IS
      SELECT handling_unit_id
      FROM   START_PICKING_PROCESS
      WHERE  pick_list_no = pick_list_no_;

BEGIN
   OPEN  part_lines_left_to_pick_;
   FETCH part_lines_left_to_pick_ INTO part_lines_;
   CLOSE part_lines_left_to_pick_;

   IF part_lines_ > 0 THEN
      last_handl_unit_structure_  := FALSE;  -- Make sure no part lines are still left to pick
   ELSE
      OPEN  get_all_remaing_hu_;
      LOOP
         FETCH get_all_remaing_hu_ INTO temp_handling_unit_id_;         
         EXIT WHEN get_all_remaing_hu_%NOTFOUND;
         IF (temp_handling_unit_id_ != root_handling_unit_id_ AND 
            Handling_Unit_API.Get_Root_Handling_Unit_Id(temp_handling_unit_id_) != root_handling_unit_id_) THEN
            last_handl_unit_structure_  := FALSE;  
            -- If current hu is not root and its root is not the same as the root sent in to this method 
            -- then all remaining hu's dont belong to the same hu structure
            EXIT;
         ELSE
            last_handl_unit_structure_  := TRUE;
         END IF;		
      END LOOP;
      CLOSE get_all_remaing_hu_;
   END IF;

   RETURN last_handl_unit_structure_;
END Last_Hndl_Unit_Structure_On_PL;


PROCEDURE Pick_Report_From_Wharehouse (
   pick_list_no_ IN VARCHAR2, 
   contract_     IN VARCHAR2 )
IS
   shipment_inv_location_no_ VARCHAR2(35);
   shipment_id_tab_          Shipment_API.Shipment_Id_Tab;
   
   CURSOR get_pick_list_info IS
      SELECT DISTINCT order_no
        FROM CREATE_PICK_LIST_JOIN_MAIN
       WHERE pick_list_no = pick_list_no_;
BEGIN
   shipment_inv_location_no_ := Customer_Order_Pick_List_API.Get_Ship_Inventory_Location_No(pick_list_no_);
   Report_Pick_List___(shipment_id_tab_       => shipment_id_tab_,
                       pick_list_no_          => pick_list_no_, 
                       location_no_           => shipment_inv_location_no_, 
                       process_shipments_     => TRUE,
                       trigger_shipment_flow_ => TRUE);
   
   FOR rec_ IN get_pick_list_info LOOP
      Report_Complete_Packages___(rec_.order_no);   
   END LOOP;
      
   IF (Customer_Order_Pick_List_API.Get_Consolidated_Flag_Db(pick_list_no_) = 'CONSOLIDATED') THEN
     Customer_Order_Pick_List_API.Set_Picking_Confirmed(pick_list_no_, contract_);
  END IF;
END Pick_Report_From_Wharehouse; 


-- Get_First_Location_No
--    Fetches the location_no for the first line of the pick list
@UncheckedAccess
FUNCTION Get_First_Location_No ( 
   pick_list_no_ IN VARCHAR2 ) RETURN VARCHAR2  
IS
   location_no_ VARCHAR2(35);
   
   CURSOR get_location_no IS
      SELECT location_no
      FROM Report_Pick_List
      WHERE pick_list_no = pick_list_no_
      ORDER BY cust_ord_reservation_objid;
BEGIN
   OPEN get_location_no;
   FETCH get_location_no INTO location_no_;
   CLOSE get_location_no;

   RETURN location_no_;
END Get_First_Location_No;


@UncheckedAccess
FUNCTION Pick_Report_Ship_Allowed (
   shipment_id_               IN NUMBER,
   report_pick_from_co_lines_ IN VARCHAR2 DEFAULT 'FALSE') RETURN NUMBER
IS
   allowed_           NUMBER;
   pick_list_count_   NUMBER := 0;
   separator_         VARCHAR2(1) := Client_SYS.text_separator_;
   consolidated_flag_ customer_order_pick_list_tab.consolidated_flag%TYPE;
   picklist_shipment_ customer_order_pick_list_tab.shipment_id%TYPE;
   
   -- Report picking is allowed if qty_assigned > qty_picked
   CURSOR report_picking IS
         SELECT consolidated_flag, shipment_id
         FROM   CUSTOMER_ORDER_PICK_LIST_TAB cop
         WHERE  ((cop.shipment_id  = shipment_id_ AND consolidated_flag = 'NOT CONSOLIDATED') OR 
                 ( consolidated_flag = 'CONSOLIDATED' AND (cop.shipments_consolidated = TO_CHAR(shipment_id_))))
         AND    picking_confirmed =  'UNPICKED';
   
   CURSOR get_pick_list_count IS
      SELECT COUNT(DISTINCT con.pick_list_no)
      FROM consolidated_orders_tab con
      WHERE con.shipment_id  = shipment_id_;
BEGIN
   allowed_ := 0;
   OPEN report_picking;
   FETCH report_picking INTO consolidated_flag_, picklist_shipment_;
   IF (report_picking%FOUND) THEN
      IF(picklist_shipment_ = shipment_id_ OR consolidated_flag_ = 'NOT CONSOLIDATED') THEN
         allowed_ := 1;
      ELSE
         OPEN get_pick_list_count;
         FETCH get_pick_list_count INTO pick_list_count_;
         CLOSE get_pick_list_count;
         IF ((report_pick_from_co_lines_ = 'TRUE' AND pick_list_count_ >= 1) OR (report_pick_from_co_lines_ = 'FALSE' AND pick_list_count_ = 1)) THEN
            allowed_ := 1;
         END IF;
      END IF;
   END IF;
   CLOSE report_picking;
   RETURN allowed_;

END Pick_Report_Ship_Allowed;


@UncheckedAccess
FUNCTION Get_Pick_Lists_For_Shipment (
   shipment_id_  IN NUMBER,
   printed_flag_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   pick_list_no_list_ VARCHAR2(32000);
   shipment_count_    NUMBER;
   
   CURSOR get_pick_lists IS
      SELECT DISTINCT cop.pick_list_no
        FROM CUSTOMER_ORDER_PICK_LIST_TAB cop, consolidated_orders_tab con
       WHERE con.shipment_id       = shipment_id_
         AND con.pick_list_no      = cop.pick_list_no
         AND (cop.printed_flag     =  printed_flag_ OR printed_flag_ IS NULL)
         AND cop.picking_confirmed = 'UNPICKED';
   
   CURSOR get_shipment_count(pick_list_no_ IN NUMBER) IS
       SELECT COUNT (DISTINCT con.shipment_id)
       FROM   consolidated_orders_tab con
       WHERE  con.pick_list_no = pick_list_no_ ;
BEGIN
   pick_list_no_list_ := NULL;
   FOR rec_ IN get_pick_lists LOOP
      OPEN get_shipment_count(rec_.pick_list_no);
      FETCH get_shipment_count INTO shipment_count_;
      CLOSE get_shipment_count;
      
      IF (shipment_count_ =  1) THEN
         -- Add pick list to list
         pick_list_no_list_ := pick_list_no_list_ || rec_.pick_list_no || Client_SYS.field_separator_;
      END IF;
   END LOOP;
   RETURN pick_list_no_list_;
END Get_Pick_Lists_For_Shipment;

@UncheckedAccess
FUNCTION Print_Pick_List_Allowed (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;
   CURSOR get_pick_list IS
      SELECT 1
      FROM   CUSTOMER_ORDER_PICK_LIST_TAB
      WHERE  (shipment_id = shipment_id_ OR shipments_consolidated = TO_CHAR(shipment_id_))
      AND    printed_flag      = 'N'
      AND    picking_confirmed = 'UNPICKED';
BEGIN
   OPEN get_pick_list;
   FETCH get_pick_list INTO allowed_;
   IF (get_pick_list%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE get_pick_list;
   RETURN allowed_;
END Print_Pick_List_Allowed;


PROCEDURE Print_Pick_List (
   shipment_id_ IN NUMBER )
IS    
   CURSOR get_pick_list IS
      SELECT pick_list_no
      FROM   customer_order_pick_list_tab
      WHERE  (shipment_id = shipment_id_ OR shipments_consolidated = TO_CHAR(shipment_id_))
      AND    printed_flag      = 'N'
      AND    picking_confirmed = 'UNPICKED';
BEGIN
   FOR rec_ IN get_pick_list LOOP
      Customer_Order_Flow_API.Print_Pick_List(rec_.pick_list_no);
   END LOOP;
END Print_Pick_List;


-- Is_Fully_Picked
--    Used from the Aggregated tab in Report Picking of Pick List Lines
@UncheckedAccess
FUNCTION Is_Fully_Picked (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER,
   location_no_      IN VARCHAR2 ) RETURN VARCHAR2 
IS
   is_fully_picked_ VARCHAR2(5) := 'TRUE';
   dummy_                NUMBER;
   handling_unit_id_tab_ Handling_Unit_API.Handling_Unit_Id_Tab;   

   CURSOR not_picked_hu_exist (local_handling_unit_id_ IN NUMBER) IS
      SELECT 1
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  pick_list_no = pick_list_no_
      AND    handling_unit_id = local_handling_unit_id_
      AND    qty_assigned > qty_picked;
                                  
   CURSOR get_quantities IS
      SELECT qty_assigned, qty_picked
      FROM CUSTOMER_ORDER_RESERVATION_TAB cor
      WHERE pick_list_no = pick_list_no_
      AND   location_no  = location_no_
      AND   EXISTS (SELECT *
                    FROM INV_PART_STOCK_SNAPSHOT_PUB ipss
                    WHERE ipss.source_ref1        = cor.pick_list_no
                    AND   ipss.handling_unit_id   = cor.handling_unit_id
                    AND   ipss.location_no        = cor.location_no
                    AND   ipss.source_ref_type_db = Handl_Unit_Snapshot_Type_API.DB_PICK_LIST);
BEGIN
   -- Check lines that attached to a handling unit
   IF (handling_unit_id_ IS NOT NULL) THEN
      handling_unit_id_tab_ := Handling_Unit_API.Get_Node_And_Descendants(handling_unit_id_);
      IF (handling_unit_id_tab_.COUNT > 0) THEN
         FOR i_ IN handling_unit_id_tab_.first..handling_unit_id_tab_.last LOOP
            OPEN not_picked_hu_exist(handling_unit_id_tab_(i_).handling_unit_id);
            FETCH not_picked_hu_exist INTO dummy_;
            -- If any of the handling units has qty to pick return false
            IF (not_picked_hu_exist%FOUND) THEN
               is_fully_picked_ := 'FALSE';
               CLOSE not_picked_hu_exist;
               EXIT;
            END IF;
            CLOSE not_picked_hu_exist;
         END LOOP;
      END IF;
   ELSE
      -- Check lines that are not attached to a handling unit or should be picked out of a handling unit
      FOR rec_ IN get_quantities LOOP 
         IF (rec_.qty_assigned > rec_.qty_picked) THEN
            is_fully_picked_ := 'FALSE';
            EXIT;
         END IF;
      END LOOP;
   END IF;
   
	RETURN is_fully_picked_;
END Is_Fully_Picked;

PROCEDURE Post_Scrap_Return_In_Ship_Inv (  
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,
   quantity_       IN NUMBER )  
IS
   line_rec_       CUSTOMER_ORDER_LINE_API.Public_Rec;
BEGIN
   -- Reduce assigned quantity with the scrapped quantity in Customer Order Line
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   Customer_Order_API.Set_Line_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_, line_rec_.qty_assigned - quantity_);

   Customer_Order_API.Set_Line_Qty_Shipdiff(order_no_, line_no_, rel_no_, line_item_no_, GREATEST(line_rec_.qty_shipdiff - quantity_, 0));

   -- Reduce picked quantity with the scrapped quantity in Customer Order Line
   Customer_Order_API.Set_Line_Qty_Picked(order_no_, line_no_, rel_no_, line_item_no_, line_rec_.qty_picked - quantity_);
   
END Post_Scrap_Return_In_Ship_Inv;


PROCEDURE Validate_Return_From_Ship_Inv (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   lot_batch_no_ IN VARCHAR2,
   serial_no_    IN VARCHAR2,
   qty_returned_ IN NUMBER )
IS
BEGIN
   IF (Customer_Order_Line_API.Get_Rental_Db(order_no_, line_no_, rel_no_, line_item_no_) = Fnd_Boolean_API.DB_TRUE) THEN
      Reserve_Customer_Order_API.Validate_On_Rental_Period_Qty(order_no_, line_no_, rel_no_, line_item_no_,
                                                               lot_batch_no_, serial_no_, - qty_returned_);
   END IF;
END Validate_Return_From_Ship_Inv;

@UncheckedAccess
FUNCTION Get_Default_Shipment_Location (
   pick_list_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   location_no_    VARCHAR2(35);
BEGIN
   location_no_ := Customer_Order_Pick_List_API.Get_Ship_Inventory_Location_No(pick_list_no_);
   IF (location_no_ IS NULL) THEN
      location_no_ := Customer_Order_API.Get_Default_Shipment_Location(pick_list_no_);
   END IF;   
   RETURN location_no_;
END Get_Default_Shipment_Location;



@UncheckedAccess
FUNCTION Get_Shipment_Id (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   shipment_id_   CUSTOMER_ORDER_RESERVATION_TAB.shipment_id%TYPE;
BEGIN
   SELECT Distinct shipment_id
   INTO shipment_id_ 
   FROM CUSTOMER_ORDER_RESERVATION_TAB cor
   WHERE pick_list_no = pick_list_no_
   AND   handling_unit_id IN (SELECT handling_unit_id
                              FROM HANDLING_UNIT_TAB 
                              CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                              START WITH       handling_unit_id = handling_unit_id_);
   RETURN shipment_id_;
EXCEPTION
   WHEN no_data_found OR too_many_rows THEN
      RETURN NULL;
END Get_Shipment_Id;



@UncheckedAccess
FUNCTION Get_Order_No (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   order_no_   CUSTOMER_ORDER_RESERVATION_TAB.order_no%TYPE;
BEGIN
   SELECT Distinct order_no
   INTO order_no_ 
   FROM CUSTOMER_ORDER_RESERVATION_TAB cor
   WHERE pick_list_no = pick_list_no_
   AND   handling_unit_id IN (SELECT handling_unit_id
                              FROM HANDLING_UNIT_TAB 
                              CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                              START WITH       handling_unit_id = handling_unit_id_);
   RETURN order_no_;
EXCEPTION
   WHEN no_data_found OR too_many_rows THEN
      RETURN NULL;
END Get_Order_No;


@UncheckedAccess
FUNCTION Get_Line_No (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   line_no_   CUSTOMER_ORDER_RESERVATION_TAB.line_no%TYPE;
BEGIN
   SELECT Distinct line_no
   INTO line_no_ 
   FROM CUSTOMER_ORDER_RESERVATION_TAB cor
   WHERE pick_list_no = pick_list_no_
   AND   handling_unit_id IN (SELECT handling_unit_id
                              FROM HANDLING_UNIT_TAB 
                              CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                              START WITH       handling_unit_id = handling_unit_id_);
   RETURN line_no_;
EXCEPTION
   WHEN no_data_found OR too_many_rows THEN
      RETURN NULL;
END Get_Line_No;


@UncheckedAccess
FUNCTION Get_Rel_No (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   rel_no_   CUSTOMER_ORDER_RESERVATION_TAB.rel_no%TYPE;
BEGIN
   SELECT Distinct rel_no
   INTO rel_no_
   FROM CUSTOMER_ORDER_RESERVATION_TAB cor
   WHERE pick_list_no = pick_list_no_
   AND   handling_unit_id IN (SELECT handling_unit_id
                              FROM HANDLING_UNIT_TAB 
                              CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                              START WITH       handling_unit_id = handling_unit_id_);
   RETURN rel_no_;
EXCEPTION
   WHEN no_data_found OR too_many_rows THEN
      RETURN NULL;
END Get_Rel_No;


@UncheckedAccess
FUNCTION Get_Line_Item_No (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER,
   location_no_      IN VARCHAR2 ) RETURN VARCHAR2 
IS
   line_item_no_   CUSTOMER_ORDER_RESERVATION_TAB.line_item_no%TYPE;
BEGIN
   IF (handling_unit_id_ != 0) THEN
      SELECT Distinct line_item_no
      INTO line_item_no_
      FROM CUSTOMER_ORDER_RESERVATION_TAB cor
      WHERE pick_list_no = pick_list_no_
      AND   handling_unit_id IN (SELECT handling_unit_id
                                 FROM HANDLING_UNIT_TAB 
                                 CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                                 START WITH       handling_unit_id = handling_unit_id_);
   ELSE 
      SELECT Distinct line_item_no
      INTO line_item_no_
      FROM CUSTOMER_ORDER_RESERVATION_TAB cor
      WHERE pick_list_no = pick_list_no_
      AND   location_no  = location_no_
      AND   EXISTS (SELECT *
                    FROM INV_PART_STOCK_SNAPSHOT ipss
                    WHERE ipss.source_ref1        = cor.pick_list_no
                    AND   ipss.handling_unit_id   = cor.handling_unit_id
                    AND   ipss.location_no        = cor.location_no
                    AND   ipss.source_ref_type_db = Handl_Unit_Snapshot_Type_API.DB_PICK_LIST);
   END IF ; 
   RETURN line_item_no_;
EXCEPTION
   WHEN no_data_found OR too_many_rows THEN
      RETURN NULL;
END Get_Line_Item_No;


@UncheckedAccess
FUNCTION Handl_Unit_Exist_On_Pick_List (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER ) RETURN BOOLEAN
IS
   hu_exist_  BOOLEAN := FALSE;
   dummy_     NUMBER;
   CURSOR check_if_hu_exist_ IS
      SELECT 1 
      FROM  Report_Pick_List 
      WHERE pick_list_no = pick_list_no_
      AND   handling_unit_id = handling_unit_id_;
BEGIN
   OPEN check_if_hu_exist_;
   FETCH check_if_hu_exist_ INTO dummy_;
   IF (check_if_hu_exist_%FOUND) THEN
      hu_exist_ := TRUE;
   END IF;
   CLOSE check_if_hu_exist_;
   RETURN hu_exist_;
END Handl_Unit_Exist_On_Pick_List;


@UncheckedAccess
FUNCTION Hu_Has_Package_Component_Part (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS 
   CURSOR check_exists IS
      SELECT 1
        FROM customer_order_reservation_tab 
       WHERE pick_list_no = pick_list_no_
         AND line_item_no > 0
         AND handling_unit_id IN ( SELECT hu.handling_unit_id
                                     FROM handling_unit_pub hu
                         CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                               START WITH hu.handling_unit_id = handling_unit_id_); 
              
   has_component_part_  VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE; 
   dummy_               NUMBER; 
BEGIN
   OPEN  check_exists;
   FETCH check_exists INTO dummy_;
   IF check_exists%FOUND THEN
      has_component_part_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   CLOSE check_exists;

   RETURN has_component_part_;
END Hu_Has_Package_Component_Part; 

-- This method fetch order reference info for Pick Handling Unit By Choice
@UncheckedAccess
PROCEDURE Get_HU_Order_Reference_Info (
   order_no_         OUT VARCHAR2,
   line_no_          OUT VARCHAR2,
   rel_no_           OUT VARCHAR2,
   line_item_no_     OUT VARCHAR2,
   shipment_id_      OUT VARCHAR2,
   pick_list_no_     IN  VARCHAR2,
	handling_unit_id_ IN  NUMBER)
IS 
BEGIN
   SELECT DISTINCT order_no, line_no, rel_no, shipment_id
   INTO order_no_, line_no_, rel_no_, shipment_id_
   FROM CUSTOMER_ORDER_RESERVATION_TAB cor
   WHERE pick_list_no = pick_list_no_
   AND   handling_unit_id IN (SELECT handling_unit_id
                              FROM HANDLING_UNIT_TAB 
                              CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                              START WITH       handling_unit_id = handling_unit_id_);
  
   line_item_no_     := Get_Line_Item_No(pick_list_no_, handling_unit_id_,null);
EXCEPTION
   WHEN no_data_found OR too_many_rows THEN
        order_no_    := NULL; 
        line_no_     := NULL;
        rel_no_      := NULL;
        shipment_id_ := NULL;
END Get_HU_Order_Reference_Info; 

