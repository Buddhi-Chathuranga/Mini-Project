-----------------------------------------------------------------------------
--
--  Logical unit: CreatePickList
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210520  ThKrlk   Bug 159302(SCZ-14812), Modified Fill_Temporary_Table___() by changing the conditions to improve the performance.
--  201216  ErRalk   Bug 156939(SCZ-12853), Added condition to check if fetched task id is not null, before trying to modify warehouse task in Create_or_Update_Wh_Task___. 
--  201125  ErRalk   Bug 156297(SCZ-12527), Modified Create_Pick_List__ by using new address fields to compare before creating new pick lists.
--  201108  RasDlk   SCZ-11837, Modified Line_Backorder_Check_Passed__() and Create_Pick_List__() by passing pick_list_no_ to relevant methods.
--  200714  SBalLK   Bug 154393(SCZ-10422), Revesed the previous correction on Create_Pick_List__ () method and modified Consol_Pick_List___() methos to avoid sql injection on dynamic cursors.
--  200713  ErRalk   Bug 153878(SCZ-10196), Modified Fill_Temporary_Table___ by adding condition for shipment_creation_db != 'PICK_LIST_CREATION' when retriving data from create_pick_list_join_main except for consolidate_ = 'SHIPMENT_AT_PICK_LIST'.
--  200710  SBalLK   Bug 154393(SCZ-10422), Added Create_or_Update_Wh_Task___() method and modified Consol_Pick_List___() and Create_Pick_List__ () methods to create or update
--  200710           Warehouse Task according to the pick list creation during the customer order flow.
--  200702  ApWilk   Bug Bug 152962(SCZ-9550), Modified Line_Backorder_Check_Passed__() to allow the RMB option Report Reserved Qtys as Picked when there is a 
--  200702           fully reserved package part with the back order option Incomplete packages not allowed.
--  200609  DiJwlk   Bug 153235 (SCZ-9724), Modified Check_All_License_Connected___() to display error message when export license status is Unconnected,
--  200609           and to display info message if User has Override License Authority. Modified Consol_Pick_List___() updated condition to set
--  200609           has_invalid_order_lines_ which will stop Manual Consolidate Picklist creation from processing further.
--  200527  KiSalk   Bug 153027(SCZ-10005), Added DOP to supply codes considered in cursor line_partial_reserved of Line_Backorder_Check_Passed__.
--  200312  ApWilk   Bug 152610 (SCZ-9193), Renamed the parameter ONLY_HU_TO_BE_PICKED_IN_ONE_STEP as HU_TO_BE_PICKED_IN_ONE_STEP to prevent the error raised when trying to schedule the Create Consolidated Pick List for Customer Orders.
--  200224  ChBnlk   Bug 151416 (SCZ-8428), Modified Check_If_Reserved_Qty_Changed___() in order to allow the lines to be added in to the pick list when the backorder option
--  200224           is 'INCOMPLETE PACKAGES NOT ALLOWED'.
--  191205  ChBnlk   Bug 151001(SCZ-7748), Added check for pick_list_created_ in order to avoid assigning a pick list number 
--                   of a pick list that was rolled back.
--  190514  UdGnlk   Bug 147895(SCZ-4387), Modified Consol_Pick_List___() queirs by removing the checks if there are remaining reservations. 
--  190513  UdGnlk   Bug 147895(SCZ-4387), Modified Consol_Pick_List___() queries by removing correcton of bug 134312. Also to omitt the Released customer order lines for consolidate pick list for shipments.  
--  190319  NipKlk   Bug 147451(SCZ-3540), Changed the order of the method call Customer_Order_Pick_List_API.Set_Shipments_Consolidated to set the shipments consolidated before modifying the default ship location.
--  190214  KiSalk   Bug 146928(SCZ-3361), Removed customer_no and contract from the where clause as it affects intersite flow in get_group of Create_Pick_List__ introduced with bug 146005.
--  190103  KiSalk   Bug 146005(SCZ-2580), Modified Create_Pick_List__ for performance improvement and Consol_Pick_List___ to stop exception.
--  180614  RuLiLk   Bug 139080, Modified method Consol_Pick_List___ to add order header history only if no CO line is already connected to the pick list to avoid duplicating history records.
--  180514  SBalLK   Bug 141701, Modified Check_Order_For_Backorder__() method to evaluate only inventory sales part since backorder option doesn't need to validate for non-inventory sales parts.
--  180514           Modified Create_Shipment_Pick_Lists__() method to execute correct Start_Shipment_Flow() method to process shipment.
--  180501  RuLiLk   Bug 141326, Modified method Consol_Pick_List___ to avoid adding partially delivered lines to the shipment when the backorder option is 'INCOMPLETE LINES NOT ALLOWED'.
--  180214  KhVese   STRSC-16927, Added method Check_Invalid_Order_Line___ and Modified method Consol_Pick_List___ to replace order line validity check block with the newly added methdo.
--  180214           Also modified exception handling for Customer Order Reservation modification.
--  180212  MeAblk   STRSC-11702, Merge the correction of bug 137517 with some changes.
--  170713  RuLiLk   Bug 136839, Modified method Consol_Pick_List___ to update cosolidated information when the shipment id is changed from the previous order line.
--  170706  MeAblk   Bug 136433, Modified method Consol_Pick_List___ to reset consolidated shipment list to null after consolidated details are updated to display correct shipment id in print pick list.Added null check to avoid consolidated order numbers in getting replaced with null in print pick list.
--  170706           Modified Consol_Pick_List___() to correctly create separate picklist by considering max orders/shipments per picklist parameter. Also to avoid repeating order history for the same picklist no.
--  170624  NiNilk   Bug 134026, Modified Consol_Pick_List___ by passing warehouse_ to method call Line_Backorder_Check_Passed__. And modified Line_Backorder_Check_Passed__ by adding warehouse_ as a parameter and
--  170624           passing warehouse_ to method call Reserve_Customer_Order_API.Get_Full_Reserved_Pkg_Qty.
--  170523  MeAblk   Bug 135860, Modified Consol_Pick_List___() to correctly connect the CO lines into a shipment picklist when the shipment contains lines from different COs.
--  170522  Jhalse   LIM-11468, Modified Fill_Temporary_Table___ to always use 'SHIPINV' when (consolidate_ = 'SHIPMENT_AT_PICK_LIST').
--  170515  MaRalk   LIM-11450, Modified Print_Ship_Consol_Pl___ in order to consider the site setting 'Print Pick Report' 
--  170515           when printing the pick list report through 'Create Consolidated Pick Lists for Shipments' window.
--  170425  ThEdlk   Bug 134415, Modified Consol_Pick_List___() by not allowing to create a new pick list for a customer order line to which a pick list already created.
--  170315  ChJalk   Bug 134312, Modified the method Consol_Pick_List___ to ignore the orders which cannot be picked completely if the selection_ is 'COMPLETE_WITHIN_SELECTION'.
--  170221  ChJalk   Bug 134090, Modified the method Do_Backorder_Validation___ to remove planned_due_date check.
--  161222  MaIklk   LIM-8387, Added Receiver_Type as parameter when calling Add_Source_Line_To_Shipment().
--  161028  ShPrlk   Bug 131361, Removed line_item_no from select statement of cursor select_package_reservations in Create_Pick_List__ and Consol_Pick_List___ 
--  161028           to fetch only one reservation record per package header.
--  160920  ChJalk   Bug 131327, Modified the method Check_Order_For_Backorder__ for considering lines with supply_code DOP for backorder option 'NO PARTIAL DELIVERIES ALLOWED'.
--  160824  SWeelk   Bug 129752, Modified Fill_Temporary_Table___() by adding a check before NOCONPICKLIST and CANNOTPICKLIST1 messages to avoid these messages when consolidate_ is SHIPMENT_AT_PICK_LIST.
--  160720  Chfose   LIM-7517, Added inventory_event_id to Consol_Pick_List___ & Create_Pick_List__ to combine multiple calls to Customer_Order_Reservation_API within a single inventory_event_id.
--  160629  TiRalk   STRSC-2702, Changed state from CreditBlocked to Blocked to be more generic to handle all the block types.
--  160528  MeAblk   Bug 129494, Modified methods Fill_Temporary_Table___() and Do_Backorder_Validation___() to avoid logging duplicate warning messages when doing backorder validations.
--  160420  ThEdlk   Bug 127763, Modified Consol_Pick_List___() by passing a value to 'stmt_where_inner_' to stop creating pick list for any of the two reserved lines having different location groups with
--  160420           'Complete within Selection Parameters'. And also modifications were done for the 'stmt_select_' to create pick list for any reserved line having matching location group and storage zone with 'Complete within Selection Parameters' when it is with a released line.
--  160405  MeAblk   Bug 128169, Modified Fill_Temporary_Table___() to perform some backorder validations before start creating the consolidated picklists. Modified Consol_Pick_List___() accordingly.
--  160405           Added new method Do_Backorder_Validation___() and a type order_line_list_tab to do perform some backorder validations.
--  160317  MeAblk   Bug 127656, Modified Create_Consol_Pick_List_Impl__ and Consol_Ship_Pick_List___ to avoid trying to split the pick lists based on distinct planned_due_date.
--  160309  NipKlk   Bug 127532, Modified variable type of the variable Pick_Lists_ to CLOB in methods Create_Consol_Pick_List_Impl__ and Create_Ship_Consol_Pl_Impl__ to avoid 
--  160309           errors when the variable is assigned with a string of more than 4000 characters.
--  160218  MaIklk   LIM-4155, Moved Print_Ship_Consol_Pl___(), Print_Ship_Consol_Pick_List__() and Start_Print_Ship_Consol_Pl() from Shipment flow to this package.
--  160211  MaRalk   LIM-6214, Modified Consol_Pick_List___ by replacing the usage of Shipment_Line_Tab with Shipment_Line_Pub.
--  160202  MaIklk   LIM-6123, Changed Shipment_Handling_Utility_API.Add_Order_Line_To_Shipment method call to Add_Source_Line_To_Shipment().
--  160201  RasDlk   Bug 126224, Modified Create_Pick_List__ to create pick list excluding export controlled customer order lines if those are not connected to a license.
--  160128  MaIklk   LIM-6116, Added Create_Pick_List_Allowed().
--  160106  RoJalk   LIM-4095, Added source_ref_type_db_ to Shipment_Handling_Utility_API.Add_Order_Line_To_Shipment method call.
--  151202  RoJalk   LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202           SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit.  
--  151110  MaIklk   LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151110  RoJalk   LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151109  MaEelk   LIM-4453, Removed pallet_id_ from logic and Customer_Order_Reservation_API calls.
--  151104  JeLise   LIM-4392, Removed the creation of pallet pick lists.
--  151103  IsSalk   FINHR-316, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Line.
--  151019  JeLise   LIM-3893, Removed pallet related location types in Validate_Params.
--  150702  JaBalk   RED-496, Passed rental_flag_db_ parameter to Create_Shipment_Pick_Lists__ if the shipment creation is set to At Pick List Creation to make the flow online.
--  150504  JeLise   LIM-1893, Added handling_unit_id_ where applicable.
--  150202  RoJalk   PRSC-5668, Removed the credit check from Create_Ship_At_Consol_Pl___ method and modified Consol_Pick_List___ so the credit check is done
--  150202           once when shipment_ids_ IN  0, DUMMY and move into the next record in main loop if the current record moves to credit blocked.
--  140611  MAHPLK   PRSC-1418, Modified Consol_Pick_List___ to use bind variable for addr_1 in dynamic sql.
--  140519  DaZase   PBSC-9203, Moved methods Create_Data_Capture_Lov, Remove_Duplicate_Lov_Values___, Get_Column_Value_If_Unique and Check_Valid_Value to PickCustomerOrder since they will now use new view that is placed there.
--  140519           Removed obsolete methods Get_Qty_To_Pick, Check_Valid_Order_No, Check_Valid_Line_No, Check_Valid_Rel_No and Check_Valid_Line_Item_No. Removed Lov_Value_Tab declaration
--  140512  MAHPLK   Modified Consol_Pick_List___to filter out 'Cancelled' customer order line.
--  140212  MAHPLK   Added new implementation method Consol_Ship_Pick_List___ and modified Consol_Pick_List___, Create_Consol_Pick_List_Impl__,  
--  140212           Create_Pallet_Pick_List___, Create_Ship_At_Consol_Pl___,  Create_Ship_Consol_Pl_Impl__,  Create_Shipment_Pick_Lists__ 
--  140212           and Discard_Duplicate_Shipments___ to consolidate shipments when create pick list for customer order. 
--  140130  MAHPLK   Modified the assigned value of field_separator_ to Client_SYS.text_separator_ instead of ':' in Consol_Pick_List___.
--  140129  ChBnlk   Bug 113704, Modified Consol_Pick_List___() to add a warning message to be displayed at pick list creation if there's a configuration mismatch between customer
--  140129           orders in demand and supply sites and modified the condition to create teh picklist only if there is no configuration mismatch.
--  130926  MAHPLK   Modified Consol_Pick_List___ to correct the behavior of the Create a consolidated pick list per 'Storage Zone'.
--  131203  SBalLK   Bug 113631, Modified Consol_Pick_List___() method to add an warning message to background when export controlled customer order line not connected to an export license.
--  131021  RoJalk   Corrected code indentation issues after merge.
--  130920  ChBnlk   Bug 112345, Modified Consol_Pick_List___ by adding parameter has_invalid_order_lines_ and set it to TRUE when backorder_check_passed_ is FALSE.
--  130920           Modified Create_Consol_Pick_List_Impl__ to create the consolidated pick list when invalid order lines are not available.
--  130920           Defined a new variable has_invalid_order_lines_ in Create_Shipment_Pick_Lists__ and passed it to the method call Consol_Pick_List___. 
--  130613  ErFelk   Bug 110286, Modified Consol_Pick_List___ and Create_Pick_List__ by passing location_group to Line_Backorder_Check_Passed__. Added location_group as a parameter to Line_Backorder_Check_Passed__.  
--  130109  NaLrlk   Modified view CREATE_PICK_LIST_JOIN_MAIN to fetch part_ownership from InventoryPartInStock.
--  130830  MAHPLK   Modified Validate_Params method to validate the LOCATION_GROUP.
--  130826  MAHPLK   Modified Consol_Pick_List___ to remove the records from create_consol_pick_list_tmp, which is already included to the pick list.
--  130605  MAHPLK   Made ORDER_NO, ORDER_TYPE, COORDINATOR and LOCATION_GROUP possible to add operator values in the selection criteria in Create Cosolidated Pick List.
--  130509  MAHPLK   Added new method Create_Ship_Consol_Pl__ and Create_Ship_Consol_Pl_Impl__. Added new view CREATE_PICK_LIST_SHIP_JOIN. 
--  130509           Modified Fill_Temporary_Table___, Consol_Pick_List___, Create_Shipment_Pick_Lists__,  
--  130509           and Create_Pallet_Pick_List___ to implement consolidate shipments pre picklist.
--  130424  MaMalk   Modified several methods needed to support for combining 2 shipment creation methods exist at pick list creation to 1.
--  130405  MAHPLK   Added new implementation method Create_Shipment_Pick_Lists___ and  Modified Consol_Pick_List___, Create_Pallet_Pick_List___,
--  130405           Fill_Temporary_Table___, Create_Consol_Pick_List_Impl__ to consolidate several shipments per pick list.
--  130128  MaMalk   Replaced CREATE_PICK_LIST_JOIN with CREATE_PICK_LIST_JOIN_MAIN and removed CREATE_PICK_LIST_JOIN view.
--  130121  MaMalk   Modified Create_Shipment_Pick_Lists__ to replace the code by calling Shipment_Flow_API.Start_Shipment_Flow
--  130121           to trigger the shipment flow.
--  130111  RoJalk   Modified Create_Pick_List__, Create_Ship_At_Consol_Pl___  to create pick list when the order line is shipment connected
--  130111           and shipment_creation is CREATE NEW AT PICKLIST, ADD TO EXIST AT PICKLIST.
--  130110  MAHPLK   Renamed parameter pick_all_lines_in_co_ to include_cust_orders_ in Consol_Pick_List___, and Create_Ship_At_Consol_Pl___ methods. 
--  130110           Create new implementation method Fill_Temporary_Table___. Modified Create_Consol_Pick_List_Impl__, Create_Ship_At_Consol_Pl___ and Consol_Pick_List___ methods.
--  121218  MaEelk   changed the WHERE clause of SELECT statement in Consol_Pick_List___ to support operator values.
--  121212  MaEelk   Made PART_NO, CUSTOMER_NO and SHIP_VIA_CODE possible to add operator values in the selection criteria in Create Cosolidated Pick List
--  121211  MaEelk   Made ROUTE_ID, PLANNED_SHIPPED_PERIOD and FORWARD_AGENT_ID possible to add operator values in the selection criteria in Create Cosolidated Pick List
--  121205  MAHPLK   Added new view CREATE_PICK_LIST_JOIN_STORAGE. Modified Create_Pick_List__, Create_Consol_Pick_List_Impl__ to consolidate by STORAGE ZONE.
--  121130  RoJalk   Modifications to Create_Pick_List__, Create_Consol_Pick_List_Impl__ support multiple shipments to a customer order line.
--  121129  RoJalk   Modified Consol_Pick_List___ to support shipment id = 0.
--  121109  MAHPLK   Added new columns warehouse_route_order, bay_route_order, row_route_order, tier_route_order and bay_route_order to 
--  121109           CREATE_PICK_LIST_JOIN_MAIN, CREATE_PICK_LIST_JOIN_NEW and CREATE_PICK_LIST_JOIN views.
--  121101  RoJalk   Allow connecting a customer order line to several shipment lines - Modified CREATE_PICK_LIST_JOIN_MAIN, CREATE_PICK_LIST_JOIN and included shipment_id.
--  121101           Modified Consol_Pick_List___, Create_Pallet_Pick_List___, Create_Ship_At_Consol_Pl___ ,  Create_Pick_List__ , Create_Consol_Pick_List_Impl__ to handle shipmnet id.
--  120919  MAHPLK   Modified Create_Shipment_Pick_Lists__ to trigger the shipment process. 
--  120921  MeAblk   Removed parameter shipment_type_ from the method calls Shipment_Handling_Utility_API.Add_Order_Line_To_Shipment.
--  120717  RoJalk   Modified Create_Pallet_Pick_List___ and passed pick_inventory_type_ as the parameter.
--  120717  RoJalk   Modified Create_Shipment_Pick_Lists__ and checked for shipment inventory setting in shipment type.
--  120712  RoJalk   Modified Create_Ship_At_Consol_Pl___ to support shipment type defined in Customer Order and Shipment. 
--  120123  MAHPLK   Removed view CREATE_PICK_LIST_JOIN_STORAGE. Modified Fill_Temporary_Table___, Create_Consol_Pick_List_Impl__, Consol_Pick_List___, 
--  120123           and Create_Shipment_Pick_Lists__ methods to optimize the selection using temporary table.
--  120123  MaMalk   Added another parameter to Create_Shipment_Pick_Lists__ to find whether this is triggered from the Shipment_Flow_API.
--  130423  Cpeilk   Bug 109571, Modified Consol_Pick_List___ to change field_separator_ to Client_SYS.text_separator_ because ':' ends up assigning wrong values when translating the msg_ variable.
--  130418  MaRalk   Replaced view CUSTOMER_INFO_PUBLIC with CUSTOMER_INFO_CUSTCATEGORY_PUB in CREATE_PICK_LIST_JOIN_MAIN, CREATE_PICK_LIST_JOIN_NEW view definitions.
--  130319  AyAmlk   Bug 109011, Modified CREATE_PICK_LIST_LOV to filter by CO header state in order to prevent selecting the planned and credit blocked COs.
--  130306  IsSalk   Bug 108470, Modified method Consol_Pick_List___() so that the all the connected customer order lines in credit blocked state will be removed from the pick list
--  130306           at the pick list creation and Database Background jobs will be updated with necessary information. 
--  130227  AyAmlk   Bug 108253, Added new LOV CREATE_PICK_LIST_LOV to retrieve customer orders which are to be picked.
--  121204  SBalLK   Bug 106634, Modified Consol_Pick_List___() to update Shipment handling unit records when pick list is create.
--  121022  AyAmlk   Bug 106066, Modified Consol_Pick_List___() to prevent the selected records by the cursor limit and the cursor prel_pick_lines get mixed up when there are component part lines.
--  121011  NipKlk   Bug 102071, Modified method Create_Consol_Pick_List_Impl__ and used db value when assigning values for attribute CONSOLIDATE, PICK_ALL_THE_LINES_IN_CO and IGNORE_EXISTING_SHIPMENT.
--  120912  GiSalk   Bug 105027, Modified the view, CREATE_PICK_LIST_JOIN_MAIN by modifying the WHERE clause to avoid full table access of CUSTOMER_ORDER_LINE_TAB.
--  120803  GiSalk   Bug 104447, Removed the unnessasary and incorrect code, which assigns a value in to curr_order_no_, in first loop execution in Create_Ship_At_Consol_Pl___(). 
--  120730  GiSalk   Bug 104381, Moved Credit Check of CO on pick list creation from Create_Pick_List__ to new method Credit_Check_Order___ and used in Create_Ship_At_Consol_Pl___ too.
--  120727  SudJlk   Bug 104006, Modified Consol_Pick_List___ to stop creation of multiple CO line history records for the same picklist.
--  120419  MalLlk   Removed the condition to check the worker_id_ value before calling Modified Customer_Order_Pick_List_API.Modify_Default_Ship_Location.
--  120412  AyAmlk   Bug 100608, Increased the column length of delivery_terms to 5 in views CREATE_PICK_LIST_JOIN_MAIN, CREATE_PICK_LIST_JOIN.
--  111114  ChJalk   Added user allowed site filter to the view CREATE_PICK_LIST_JOIN_MAIN and removed the view CREATE_PICK_LIST_JOIN_UIV.
--  111101  NISMLK   SMA-289, Increased eng_chg_level length to STRING(6) in column comments.
--  110910  SudJlk   Bug 98653, Modified column comment of demand_order_ref1 in CREATE_PICK_LIST_JOIN_MAIN, CREATE_PICK_LIST_JOIN_UIV and CREATE_PICK_LIST_JOIN.
--  110923  SudJlk   Bug 98972, Modified method Create_Shipment_Pick_Lists__ to create consolidated picklists for shipments when location group in not sent from the client as a filteration criterion.
--  110726  SudJlk   Bug 97685, Modified Create_Shipment_Pick_Lists__ by adding new parameter location_goup and checking the location_group before creating consolidated picklists. 
--  110726           Modified Create_Consol_Pick_List_Impl__ to send location_group to Create_Shipment_Pick_Lists_.
--  110722  GayDLK   Bug 96406, Corrected the code to select all the order numbers when removing last field_separator_ from the orders list in Consol_Pick_List___().
--  110712  MaMalk   Added user allowed site filter to CREATE_PICK_LIST_JOIN_NEW, CUST_ORD_PICK_LOCATION and CUST_ORD_PICK_LIST_PART.
--  110624  NWeelk   Bug 94542, Modified method Create_Shipment_Pick_Lists__ by adding value to the sel_customer_no_ of the method call Consol_Pick_List___. 
--  110603  MaRalk   Added condition to check whether inventory location is connected to the shipment, when deciding the pick_inventory_type_ in Create_Pallet_Pick_List___ method.
--  110513  MaMalk   Modified Consol_Pick_List___ to add the order by to cursor prel_pick_lines.
--  110425  ChJalk   Modified the method Consol_Pick_List___ to ignore the back order option 'NO PARTIAL DELIVERIES ALLOWED' for line back order check. 
--  110425  ChJalk   Removed method Pick_Lists_To_Tmp_Tbl___ and modified the methods Create_Consol_Pick_List_Impl__ and Consol_Pick_List___ to ignore the value of location_group in advance parameters when the 
--  110425           "Incl. all Lines of CO in Pick List" is selected.
--  110303  ChJalk   EANE-3807, Removed user allowed site filter from the view CREATE_PICK_LIST_JOIN_NEW. 
--  110127  NeKolk   EANE-3744  added where clause to the View CREATE_PICK_LIST_JOIN ,CREATE_PICK_LIST_JOIN_NEW.
--  101223  ChJalk   Bug 94911, Modified methods Consol_Pick_List___, Create_Ship_At_Consol_Pl___ and Create_Consol_Pick_List_Impl__ to change the data type of due_date to DATE.
--  101011  NWeelk   Bug 93479, Modified cursor get_candidate_shipment_lines in method Create_Ship_At_Consol_Pl___ by adding CO header rowstate check to the WHERE clause. 
--  100811  ChJalk   Bug 92123, Modified method Line_Backorder_Check_Passed__ to include the order lines with supply code 'PI' to check for backorder.
--  100729  ChJalk   Bug 92123, Modified method Check_Order_For_Backorder__ to include the order lines with supply code 'PI' to check for backorder.
--  100705  RaKalk   Bug 91480, Modified procedure Consol_Pick_List___ to properly create pick lists when order use multiple location groups.
--  100805           Added function Pick_Lists_To_Tmp_Tbl___.
--  100422  MaMalk   Bug 90091, Modified methods Consol_Pick_List___, Create_Ship_At_Consol_Pl___,Create_Consol_Pick_List_Impl__ and Create_Pallet_Pick_List___ to
--  100422           filter the CO_Priority correctly when creating consolidated pick lists.
--  100419  MaMalk   Bug 90091, Modified methods Consol_Pick_List___, Create_Ship_At_Consol_Pl___ and Create_Consol_Pick_List_Impl__ to do the date comparison correctly.
--  100322  AmPalk   Bug 89429, Modified Consol_Pick_List___, Create_Consol_Pick_List_Impl__ to pick rest of the lines of the order (having any ship via code), 
--  100322           if pick_all_lines_in_co_ is TRUE and there is a single line matching for the ship via code specified.
--  100125  AmPalk   Bug 88443, Set the backorder_check_passed_ flag FALSE if the order is blocked for back order in the loop, in Consol_Pick_List___.
--  100118  AmPalk   Bug 88299, Modified Create_Pick_List__ to call Credit_Check_Order only if the CO status is not CreditBlocked.
--  100513  Ajpelk   Merge rose method documentation
--  100505  SaFalk   Removed method Schedule_Create_Consol_Pl__.
--  100304  MaRalk   Replaced '%' with NULL for the priority parameter in the Customer_Order_Pick_List_API.Set_Selections method call  within Create_Pallet_Pick_List___ method.
--  100224  HimRlk   Modified Console_Pick_List___ to correct bug introduced by EADM-629 by assigning value to backorder_check_passed_ again 
--  100224           since it is used within the method. 
--  091215  KiSalk   CONTINUE used instead of flag checking in Consol_Pick_List___, Create_Ship_At_Consol_Pl___ and Create_Ship_At_Consol_Pl___.
--  091203  KiSalk   Changed backorder option values to new IID values in Customer_Backorder_Option_API.
--  090930  MaMalk   Removed  TYPE cust_list_tab. Modified Consol_Pick_List___, Create_Ship_At_Consol_Pl___, Create_Pick_List__ and Create_Consol_Pick_List_Impl__ to remove unused code.
--  --------------------------------- 14.0.0 --------------------------------
--  091002  KiSalk   Added activity_seq, project_id, planned_due_date, preliminary_pick_list_no, qty_shipped to VIEWJOIN_1.
--  090831  ChFolk   Bug 84675, Added order_type and coordinator into VIEWJOIN_MAIN and VIEWJOIN. Added parameters order_type_, coordinator_ and co_priority_ into Consol_Pick_List___ and
--  090831           Create_Ship_At_Consol_Pl___. Removed default null from shipment_id_ in Consol_Pick_List___. Modified the cursors limit, get_candidate_shipment_lines, get_order_no, 
--  090831           get_shipment_id, get_ship_addr, get_customer_no, get_route_id, get_ship_period, get_forward_agent, get_warehouse, get_bay, get_row, get_tier, get_bin and get_pallet
--  090831           to filter the results based on order_type, coordinatort and priority and replaced trunc planned_due_date with TO_DATE. 
--  090817  MalLlk   Bug 84586, Modified the method Consol_Pick_List___ to handle different CO numbers when creating consolidated pick list.
--  090629  LaPrlk   Bug 83951, Modified where clause of cursor get_candidate_shipment_lines in Create_Ship_At_Consol_Pl___ to compare the value of deliver_to_customer_no instead of customer_no.
--  090515  HaPulk   Bug 82787, Modified method Create_Pallet_Pick_List___ to add order_no to the consolidated_orders column and modified method Consol_Pick_List___ 
--  090515           to remove the last field separator when concatenating order_no list.
--  081209  SaRilk   Bug 77033, Modified the procedure Create_Ship_At_Consol_Pl___ to handle the expected behavior when executing Create Consolidated Pick List. 
--  081205  SaRilk   Bug 77033, Modified the procedure Create_Ship_At_Consol_Pl___ to group the shipments that can be added together when executing Create Consolidated Pick List. 
--  081201  SaRilk   Bug 77918, Changed OUT parameter of Consol_Pick_List___, Create_Pallet_Pick_List___, Create_Pick_List__, Create_Shipment_Pick_Lists__
--  081201           and variable pick_list_no_list_ of Create_Consol_Pick_List_Impl__ to Pick_List_Table type from VARCHAR2 and changed the methods to manipulate parameter accordingly.
--  081127  SaRilk   Bug 77033, Modified the procedures Create_Consol_Pick_List_Impl__ and Create_Ship_At_Consol_Pl___ to ignore existing Shipments when executing Create Consolidated Pick List.  
--  080624  DaZase   Bug 72596, renamed method from Create_Consol_Pick_List__ to Create_Consol_Pick_List_Impl__, created a new Create_Consol_Pick_List__ method.
--  090226  KiSalk   Added Customer_Order_Pick_List_API.Modify_Default_Ship_Location calls before Warehouse_Task_API.New when (worker_id_ IS NOT NULL.
--  090202  KiSalk   Added method Convert_Preliminary_List__. Added preliminary_pick_list_no to views CREATE_PICK_LIST_JOIN andCREATE_PICK_LIST_JOIN_MAIN.
--  090202           Added parameter preliminary_pick_list_no_ and handled it in Consol_Pick_List___; changed the Consol_Pick_List___ calls accordingly.
--  081231  NaLrlk   Added views CUST_ORD_PICK_LIST_PART and CUST_ORD_PICK_LOCATION.
--  080130  SaJjlk   Bug 70459, Modified method Create_Ship_At_Consol_Pl___ to check for back order option before creating Shipment.
--  071227  SaJjlk   Bug 70089, Modified cursor get_candidate_shipment_lines in method Create_Ship_At_Consol_Pl___ to consider planned_due_date.
--  071129  HaPulk   Bug 68186, Modified some cursors in methods Create_Pick_List__ and Create_Consol_Pick_List__ to use the view
--  071129           CREATE_PICK_LIST_JOIN_MAIN instead of CREATE_PICK_LIST_JOIN to improve performance.
--  071023  ThAylk   Bug 67280, Modified the method Create_Consol_Pick_List__ to implement the EXECUTION_OFFSET for the schedule wizard.
--  070608  MaJalk   Modified Consol_Pick_List___ to handle different CO numbers.
--  070528  MaJalk   Modified Consol_Pick_List___, Create_Pick_List__ and Line_Backorder_Check_Passed__ to handle back order option ALLOW PARTIAL PACKAGE DELIVERY. 
--  070517  NiDalk   Modified Check_Order_For_Backorder___ and Line_Backorder_Check_Passed___ to private methods.
--  070515  Cpeilk   Bug 60944, Modified procedure Consol_Pick_List___ to correctly insert the Order Line history.
--  070507  NiDalk   Modified limit CURSOR in Consol_Pick_List___.
--  070430  MaJalk   Bug 60580, Changed the Create_Consol_Pick_List__ and Consol_Pick_List__ methods to consider the due date when creating a consolidated pick list.
--  070418  NiDalk   Modified all the cusrsors in Create_Consol_Pick_List__to get correct pallet_id selection.
--  070312  SaJjlk   Modified method Create_Ship_At_Consol_Pl___. Added method Discard_Duplicate_Shipments___ and added IN OUT
--  070312           parameter pick_list_no_list_ to method Create_Pallet_Pick_List___.
--  070306  NiDalk   Modified Create_Shipment_Pick_Lists__ to pass pick_inventory_type_db_.
--  070302  MaJalk   Modified parameters at method call Consol_Pick_List___ when pick_all_lines_in_co_ is TRUE at Create_Consol_Pick_List__.
--  070228  MaJalk   Modified Create_Consol_Pick_List__.
--  070226  NiDalk   Modified Create_Shipment_Pick_Lists__, Create_Ship_At_Consol_Pl___ and Consol_Pick_List___.
--  070222  MaJalk   Modified parameters at methods Consol_Pick_List___, Create_Ship_At_Consol_Pl___ and modified method Create_Consol_Pick_List__.
--  070222  MiErlk   Added PICK_INVENTORY_TYPE_DB to CREATE_PICK_LIST_JOIN_MAIN and CREATE_PICK_LIST_JOIN.
--  070215  RoJalk   Removed ship via desc and delivery term desc from views.
--  070216  MaJalk   Modified Consol_Pick_List___ to handle backorder_option ALLOW PARTIAL LINE DELIVERY.
--  070216  PrPrlk   Modified the method Create_Ship_At_Consol_Pl___ to allow selection of package component parts as well.
--  070215  MaJalk   Modified Line_Backorder_Check_Passed___ and Create_Pick_List__ to handle backorder_option ALLOW PARTIAL LINE DELIVERY.
--  070214  NaLrlk   Modified the History creation for pick list in Consol_Pick_List___, Create_Pick_List__ and Create_Consol_Pick_List__
--  070208  PrPrlk   Re-ordered the parameter list in method calls to Shipment_Handling_Utility_API.Add_Order_Line_To_Shipment.
--  070206  NaLrlk   Added method Handle_Backorder_Info___, Rename Backorder_Check_Passed___ to Line_Backorder_Check_Passed___ and Modified methods Consol_Pick_List___, Line_Backorder_Check_Passed___, Create_Pick_List__.
--  070206  PrPrlk   Modifed the method type of Create_Shipment_At_Consol_Pl__ to implementation and renamed it to Create_Ship_At_Consol_Pl___.
--  070205  PrPrlk   Removed the shipment creation logic in Create_Consol_Pick_List__and moved it to a new method named Added new method Create_Shipment_At_Consol_Pl__
--  070205           and removed the method Create_Shipment_Pl_At_Pick__.
--  070131  PrPrlk   Modified the OUT parameter pick_list_no_list_ to a IN OUT type parameter in method Create_Shipment_Pick_Lists__.
--  070130  PrPrlk   Made changes to the method Create_Consol_Pick_List__ to handle connecting of relevant CO lines to Shipments and to handle creating Consolidated Pick Lists for the shipments.
--  070130           Added new method Create_Shipment_Pl_At_Pick__ that handles creating of Consolidated Pick Lists per Shipment when "Create Pick List" is executed from the client.
--  070119  Cpeilk   Called Order_Delivery_Term_API.Get_Description to get delivery_terms_desc and Mpccom_Ship_Via_API.Get_Description to get ship_via_desc.
--  070117  MaJalk   Changed method name from Back_Order_Check_Passed___ to Backorder_Check_Passed___ and modified Consol_Pick_List___.
--  070116  MaJalk   Modified methods Create_Pick_List__ and Consol_Pick_List___.
--  070110  NaLrlk   Added backorder_option_ = 'NO PARTIAL DELIVERIES' in Back_Order_Check_Passed___.
--  070109  NaLrlk   Added the method Check_Order_For_Backorder___ and Back_Order_Check_Passed___. Modified the methods Consol_Pick_List___ and Create_Pick_List__.
--  061117  NaLrlk   Modified allow_backorders to backorder_option in cursors Consol_Pick_List___ & Create_Pick_List__.
--  060904  Cpeilk   Modified methods Create_Consol_Pick_List__, Consol_Pick_List___ and Create_Pick_List__ to handle credit checks.
--  060904  NaWilk   Modified method Credit_Check_Ship_Pick_List___.
--  060824  NaWilk   Added function Credit_Check_Ship_Pick_List___ and modified Create_Shipment_Pick_Lists__ by adding a credit check.
--  060601  MiErlk   Enlarge Identity - Changed view comments Description.
--  060524  NuFilk   Bug 57743, Modified method Create_Pallet_Pick_List___ to set the shipment_id and order no when creating the pick list.
--  060419  IsWilk   Enlarge Customer - Changed variable definitions.
--  060418  SaRalk   Enlarge Identity - Changed view comments.
--  --------------------------------- 13.4.0 --------------------------------
--  050921  SaMelk   Remove unused variables.
--  050805  VeMolk   Bug 52672, Modified the cursor prevent_backorder in the methods Create_Pick_List__ and Consol_Pick_List___.
--  050630  LaBolk   Bug 52194, Modified Create_Pick_List__ by correcting a cursor to exclude cancelled CO lines.
--  050513  NiRulk   Bug 51103, Modified procedure Create_Consol_Pick_List__ to include the order no in the picklists created for pallet parts.
--  050322  IsWilk   Modified the PROCEDURE Validate_Params.
--  050321  IsWilk   Added the PROCEDURE Validate_Params.
--  050216  IsAnlk   Modified SHIPMENT_CONNECTED as VARCHAR2 and changed the code accordingly.
--  050315  ErSolk   Bug 50046, Modified procedure Consol_Pick_List___ to display
--  050315           warnings for orders which cannot create consolidated pick list.
--  050201  UsRalk   Modified Create_Shipment_Pick_Lists__ to refer SHIP_INVENTORY_LOCATION_NO instead of SHIP_INVENTORY_LOC.
--  050131  NuFilk   Modified method Create_Shipment_Pick_Lists__ to consider shipmeent inventory location on shipment.
--  050131  JaJalk   Added the demand_order_ref1 to the views VIEWJOIN_MAIN and VIEWJOIN.
--  050120  NuFilk   Modified method Create_Shipment_Pick_Lists__.
--  050120  NuFilk   Modified method Consol_Pick_List___.
--  050112  HoInlk   Bug 48912, Modified Consol_Pick_List___ to consider NULL values when creating order line history records.
--  050111  NuFilk   Modified method Consol_Pick_List___.
--  050110  NuFilk   Added view CREATE_PICK_LIST_JOIN_MAIN.
--  050104  NuFilk   Added shipment_id to CREATE_PICK_LIST_JOIN, Added Create_Pallet_Pick_List___. Modified Create_Pallet_Pick_List___ and Create_Consol_Pick_List__
--  050104           Removed Create_Ship_Line_Pick_Lists__, Create_Pick_List_For_Line__ and Create_Pick_List_For_Line.
--  041028  DiVelk   Modified Consol_Pick_List___,Create_Pick_List__ and Create_Pick_List_For_Line__.
--  041021  GeKalk   Added catch_qty to CREATE_PICK_LIST_JOIN.
--  041014  DaZase   Added project_id to CREATE_PICK_LIST_JOIN.
--  040929  DaZase   Added activity_seq to CREATE_PICK_LIST_JOIN and added it in calls to Customer_Order_Reservation_API.
--  040908  IsWilk   Modified the PROCEDURE Create_Consol_Pick_List__.
--  040908  IsWilk   Removed the PROCEDURE Start_Create_Consol_Pl__.
--  040819  SaJjlk   Added columns INPUT_QTY, INPUT_UNIT_MEAS, INPUT_CONV_FACTOR and INPUT_VARIABLE_VALUES to view CREATE_PICK_LIST_JOIN
--  040712  DhAalk   Modified the views CREATE_PICK_LIST_JOIN and CREATE_PICK_LIST_JOIN_NEW to
--  040712           change CO.customer_no to COL.deliver_to_customer_no.
--  040227  IsWilk   Removed the SUBSTRB from the views for Unicode Changes.
--  040226  UdGnlk   Bug 42695, Modified Schedule_Create_Consol_Pl__ and Create_Consol_Pick_List__ in order to
--  040226           Set the SYSDATE the moment the batch job is being executed.
--  040224  ChJalk   Bug 40249, Modified the views CREATE_PICK_LIST_JOIN and CREATE_PICK_LIST_JOIN_NEW by removing the decode
--  040224           from the where condition since this is handled in the view CUST_ORDER_LINE_ADDRESS_2.
--  040211  PrTilk   Bug 41402, Modified method Consol_Pick_List___ to set the consolidated data to the
--  040211           new LU ConsolidatedOrders.
--  040130  WaJalk   Bug 41963, Modified method Consol_Pick_List___ to remove error message related to customers
--  040130           not allowing back orders.
--  040102  IsWilk   Bug 39282, Modified the procedures Consol_Pick_List___ , Create_Pick_List__ and Create_Consol_Pick_List__.
--  021106  PrInLk   Added method Create_Pick_List_For_Line as a conterpart as its private method.
--  020306  MaGu     Added parameter pick_list_no_list to method Create_Pick_List_For_Line__.
--  020220  MaGu     Added methods Create_Shipment_Pick_Lists__ and Create_Pick_List_For_Line__.
--  ********************* VSHSB Merge *****************************
--  ------------------------------------------ 13.3.0 --------------------------
--  030913  IsWilk   Bug 37960, Removed the added correction of the Bug 29217 ,added the previous coding in the PROCEDURE Create_Pick_List__.
--  030913  JaBalk   Bug 37936, Changed the length of msg_ to 2000 to include the TASK_INFO message.
--  030913           which includes the customer_no_list_, order_no_list_ in Consol_Pick_List___.
--  030729  GaJalk   SP4 Merge.
--  030521  SudWlk   Added the attibutes Part_Ownership, Part_Ownership_Db and Owning_Customer_No to VIEWJOIN.
--  030205  SudWlk   Bug 35512, Increased order_no_list_ and customer_no_list_ declarations in Consol_Pick_List to VARCHAR2(8000).
--  020917  JoAnSe   -- Merged the IceAge bugg corrections below onto the AD 2002-3 track. --
--  020720  Nufilk   Bug 29217, Modified Cursor prevent_backorder in Create_Pick_List__
--  020329  Samnlk   Call 74352,Modify PROCEDURE Create_Pick_List__
--  010927  SuSalk   BugId 24785 fixed,split the where condition to check the supply_code and have different
--                   equations to check the quantity in Consol_Pick_List___().
--  010531  IsWilk   Bug Fix 21433, Added the VIEWJOIN_1.
--  010531  SuSalk   BugId 21989 fixed,split the where condition to check the supply_code and have different
--                   equations to check the quantity.
--  ------------------------------------- IceAge Merge End -----------------------------------
--  020628  MaEelk   Modified comments on CONDITION_CODE in CREATE_PICK_LIST_JOIN and CREATE_PICK_LIST_JOIN_NEW.
--  020620  MaEelk   Modified views CREATE_PICK_LIST_JOIN and CREATE_PICK_LIST_JOIN_NEW so that it takes the CONDITION CODE from Customer Order Line now.
--  020614  MaEelk   Added CONDITION_CODE to views CREATE_PICK_LIST_JOIN and CREATE_PICK_LIST_JOIN_NEW.
--  020522  SuAmlk   Changed VIEW COMMENTS in the views CREATE_PICK_LIST_JOIN and CREATE_PICK_LIST_JOIN_NEW.
--  ------------------------------------- 2002-3 Baseline ------------------------------------
--  001107  FBen  Call ID 48753 (old Call id 17284 LeIsse), Added decode to check on cola.line_item_no in view.
--  001031  JakH  Changed TYPE in VIEWJOIN for Line_Item_No to NUMBER
--  001020  JakH  Added Configuration ID to cursors to pass to customer_order_reservation_api
--  000928  DaZa  Bug fix 17283, Added ship_via_desc and delivery_terms_desc in view.
--                Added cursor get_ship_addr and changed cursor get_group in Create_Pick_List__.
--  --------------------- 12.1 ----------------------------------------------
--  000607  PaLj  Changed call to Warehouse_Task_API.New when having Pallets in
--                functions Create_Pick_List and Create_Consol_Pick_List.
--  000511  PaLj  Added Priority to CREATE_PICK_LIST_JOIN
--  000419  PaLj  Corrected Init_Method Errors
--  --------------------- 12.0 ----------------------------------------------
--  991108  PaLj  Changed Consol_Pick_List to filter out "No Back Order allowed" orders
--  991025  PaLj  Increased ship_date_ declaration in Create_Consol_Pick_List to VARCHAR2(30)
--  991025  PaLj  Removed OUT Declaration on functions Create_Consol_Pick_List__,
--                Schedule_Create_Consol_Pl__ and Start_Create_Consol_Pl__
--  991018  PaLj  Corrected address Conslidation error
--  991012  PaLj  Added keys on create_pick_list_join
--  991011  PaLj  Added sel_* as parameters into consol_pick_list.
--  991007  JoEd  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  991007  JoEd  Call Id 21210: Corrected double-byte problems.
--  990815  PaLj  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Pick_List_Table IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;

TYPE Pick_List_Shipment_Id_Rec IS RECORD
     (shipment_id          Shipment_Line_Tab.Shipment_Id%TYPE,
      pick_list_id         Customer_Order_Pick_List_Tab.Pick_List_No%TYPE);
      
TYPE Pick_List_Shipment_ID IS TABLE OF Pick_List_Shipment_Id_Rec INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE order_list_tab IS TABLE OF VARCHAR2(12) INDEX BY BINARY_INTEGER;
TYPE order_line_rec IS RECORD (order_no VARCHAR2(12), line_no VARCHAR2(4), rel_no  VARCHAR2(4));
TYPE Order_No_Bool_Table IS TABLE OF BOOLEAN INDEX BY CUSTOMER_ORDER_TAB.ORDER_NO%TYPE;
TYPE Order_Line_Bool_Table IS TABLE OF BOOLEAN INDEX BY VARCHAR2(50);

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_If_Reserved_Qty_Changed___ (
   rollback_reservation_            OUT BOOLEAN,
   rollback_picklists_              OUT BOOLEAN,
   current_passed_order_no_list_ IN OUT Order_No_Bool_Table,
   reserved_qty_mismatch_        IN OUT BOOLEAN,
   has_invalid_order_lines_      IN OUT BOOLEAN,
   order_no_                     IN     VARCHAR2,
   line_no_                      IN     VARCHAR2,
   rel_no_                       IN     VARCHAR2,
   line_item_no_                 IN     VARCHAR2,
   backorder_option_db_          IN     VARCHAR2,
   fully_reserved_pkg_qty_       IN     NUMBER)
IS
   order_line_rec_                Customer_Order_Line_API.Public_Rec;
BEGIN
   rollback_reservation_    := FALSE;
   rollback_picklists_      := FALSE;
   
    order_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
    
   IF (line_item_no_ = 0 AND backorder_option_db_ NOT IN ('ALLOW INCOMPLETE LINES AND PACKAGES', 'INCOMPLETE PACKAGES NOT ALLOWED')) OR 
      ((line_item_no_ > 0) AND  ((backorder_option_db_ IN ('NO PARTIAL DELIVERIES ALLOWED', 'INCOMPLETE LINES NOT ALLOWED')) 
      OR ((backorder_option_db_ = 'INCOMPLETE PACKAGES NOT ALLOWED') AND (fully_reserved_pkg_qty_ = 0)))) THEN

      IF (backorder_option_db_ = 'NO PARTIAL DELIVERIES ALLOWED') THEN
         current_passed_order_no_list_(order_no_) := TRUE;
      END IF;

      IF ((order_line_rec_.revised_qty_due - (order_line_rec_.qty_shipped - order_line_rec_.qty_shipdiff)) - order_line_rec_.qty_assigned > 0) THEN
         reserved_qty_mismatch_   := TRUE;
         has_invalid_order_lines_ := TRUE;

         IF (backorder_option_db_ = 'INCOMPLETE LINES NOT ALLOWED')  AND (order_line_rec_.qty_assigned = 0) THEN
            rollback_reservation_ := TRUE;
         ELSE
            rollback_picklists_    := TRUE;   
         END IF;   
      END IF;
   ELSE
      IF (order_line_rec_.qty_assigned = 0) THEN
         reserved_qty_mismatch_   := TRUE;   
      END IF;   
   END IF;
END Check_If_Reserved_Qty_Changed___;


PROCEDURE Consol_Pick_List___ (
   pick_list_no_list_         IN OUT Pick_List_Table,
   warehouse_task_list_       IN OUT VARCHAR2,
   shipment_id_tab_           IN OUT Shipment_API.Shipment_Id_Tab,
   has_invalid_order_lines_   IN OUT BOOLEAN,
   failed_order_no_list_      IN OUT Order_No_Bool_Table,
   passed_order_no_list_      IN OUT Order_No_Bool_Table,
   contract_                  IN     VARCHAR2,
   order_no_                  IN     VARCHAR2,
   customer_no_               IN     VARCHAR2,
   route_id_                  IN     VARCHAR2,
   due_date_                  IN     DATE,
   ship_period_               IN     VARCHAR2,
   forward_agent_             IN     VARCHAR2,
   location_group_            IN     VARCHAR2,
   warehouse_                 IN     VARCHAR2,
   bay_no_                    IN     VARCHAR2,
   row_no_                    IN     VARCHAR2,
   tier_no_                   IN     VARCHAR2,
   bin_no_                    IN     VARCHAR2,
   addr_1_                    IN     VARCHAR2,
   addr_2_                    IN     VARCHAR2,
   addr_3_                    IN     VARCHAR2,
   addr_4_                    IN     VARCHAR2,
   addr_5_                    IN     VARCHAR2,
   addr_6_                    IN     VARCHAR2,
   country_code_              IN     VARCHAR2,
   consolidation_             IN     VARCHAR2,
   pick_inventory_type_db_    IN     VARCHAR2,
   sel_order_no_              IN     VARCHAR2,
   sel_customer_no_           IN     VARCHAR2,
   sel_route_id_              IN     VARCHAR2,
   sel_ship_period_           IN     VARCHAR2,
   sel_forward_agent_         IN     VARCHAR2,
   sel_location_group_        IN     VARCHAR2,
   sel_part_no_               IN     VARCHAR2,
   sel_ship_via_code_         IN     VARCHAR2,
   selection_                 IN     VARCHAR2,
   max_orders_on_pick_list_   IN     VARCHAR2,
   shipment_ids_              IN     VARCHAR2,
   order_type_                IN     VARCHAR2,
   coordinator_               IN     VARCHAR2,
   co_priority_               IN     NUMBER,
   preliminary_pick_list_no_  IN     NUMBER,
   storage_zone_id_           IN     VARCHAR2,
   sel_storage_zone_id_       IN     VARCHAR2,
   max_shipment_on_pick_list_ IN     NUMBER,
   shipment_id_               IN     VARCHAR2, 
   consol_shipment_id_        IN     VARCHAR2,
   shipment_location_         IN     VARCHAR2,   
   ship_date_                 IN     DATE,
   sel_shipment_id_           IN     VARCHAR2,
   sel_consol_shipment_id_    IN     VARCHAR2,   
   sel_shipment_type_         IN     VARCHAR2,
   sel_shipment_location_     IN     VARCHAR2,
   from_ship_consol_pl_       IN     BOOLEAN,
   ignore_existing_shipment_  IN     VARCHAR2 )
IS
   number_lines_              NUMBER  := 0;
   pick_list_created_         BOOLEAN := FALSE;
   pick_list_no_              VARCHAR2(15);
   ord_no_                    VARCHAR2(12);
   line_no_                   VARCHAR2(4);
   rel_no_                    VARCHAR2(4);
   line_item_no_              NUMBER;
   min_ship_date_             DATE;
   msg_                       VARCHAR2(2000);
   task_id_                   NUMBER;
   priority_                  NUMBER := NULL;
   field_separator_           VARCHAR2(1) := Client_SYS.text_separator_;   
   create_date_               DATE;
   order_due_date_            DATE;
   tsk_orders_info_           VARCHAR2(755);
   tsk_customers_info_        VARCHAR2(755);
   con_order_list_            VARCHAR2(2000);
   info_                      VARCHAR2(2000);
   max_tsk_order_reached_     BOOLEAN := FALSE;
   max_tsk_custno_reached_    BOOLEAN := FALSE;
   max_con_ord_list_reached_  BOOLEAN := FALSE;
   backorder_option_db_       VARCHAR2(40);
   whole_pkgs_reserved_       NUMBER := 0;
   excess_reservations_exist_ BOOLEAN;
   old_order_no_              VARCHAR2(12);
   old_line_no_               VARCHAR2(4);
   old_rel_no_                VARCHAR2(4);
   allow_partial_pkg_deliv_   VARCHAR2(5) := 'TRUE';
   catalog_no_                VARCHAR2(25);
   different_co_              NUMBER := -1;
   worker_id_                 VARCHAR2(20);
   temp_separator_            VARCHAR2(2);
   pick_shipment_id_          NUMBER;   
   different_shipment_        NUMBER := -1;
   temp_shipment_ids_         VARCHAR2(32000);
   include_shipment_ids_      VARCHAR2(32000);      
   ship_id_                   NUMBER;   
   tmp_shipment_id_           NUMBER;
   prev_tmp_shipment_id_      NUMBER;
   all_license_connected_     VARCHAR2(10):= 'TRUE';
   prev_order_no_             VARCHAR2(12):= NULL;
   prev_line_no_              VARCHAR2(4);
   prev_rel_no_               VARCHAR2(4);
   prev_line_item_no_         NUMBER;
   raise_message_             VARCHAR2(5) := 'FALSE';
   has_config_mismatch_       VARCHAR2(5) := 'FALSE';
   backorder_check_passed_    BOOLEAN := FALSE;

   TYPE Get_Limit_Type IS REF CURSOR;
   get_limit_                 Get_Limit_Type;
   stmt_                      VARCHAR2(32760);
   stmt_select_               VARCHAR2(32760);
   stmt_all_lines_            VARCHAR2(32760) := NULL;
   stmt_where_                VARCHAR2(32760) := NULL;
   stmt_where_inner_          VARCHAR2(32760) := NULL;
   sql_where_expression_      VARCHAR2(28000) := NULL; 
   temp_storage_zone_id_      VARCHAR2(30) := NULL;     
   exist_shipment_id_         VARCHAR2(5)  := 'FALSE';  
   pick_list_shipment_tab_    Create_Pick_List_API.Pick_List_Shipment_ID;
   pick_list_no_tmp_          VARCHAR2(15);
   
   dummy_order_no_                VARCHAR2(12);
   current_passed_order_no_list_  Order_No_Bool_Table;
   rollback_all_prev_picklist_    BOOLEAN := FALSE;
   reserved_qty_mismatch_         BOOLEAN := FALSE;
   rollback_picklists_            BOOLEAN := FALSE;
   rollback_reservation_          BOOLEAN := FALSE;
   return_                        BOOLEAN := FALSE;
  
   
   CURSOR prel_pick_lines IS
      SELECT customer_no,     contract,     part_no,          location_no,
             lot_batch_no,    serial_no,    waiv_dev_rej_no,  eng_chg_level,
             pick_list_no,    order_no,         line_no,
             rel_no,          line_item_no, configuration_id, activity_seq,
             planned_due_date, shipment_id, planned_ship_date, handling_unit_id
      FROM   CREATE_PICK_LIST_JOIN_MAIN cplj1
      WHERE  contract                  = contract_
        AND  pick_list_no              = '*'
        AND  preliminary_pick_list_no  = preliminary_pick_list_no_
        AND  location_group            = location_group_
      ORDER BY order_no, to_number(line_no), to_number(rel_no), line_item_no;

   CURSOR select_package_reservations IS
      SELECT DISTINCT order_no, line_no, rel_no
      FROM   customer_order_reservation_tab
      WHERE  pick_list_no = pick_list_no_
      AND    line_item_no > 0;

   TYPE reservation_lines_table IS TABLE OF prel_pick_lines%ROWTYPE INDEX BY BINARY_INTEGER;
   limitrec_ reservation_lines_table;
   
   CURSOR check_pick_list_exists(order_no_ VARCHAR2, pick_list_no_ VARCHAR2) IS
   SELECT 1 FROM Customer_Order_Reservation_TAB
   WHERE order_no = order_no_
   AND pick_list_no = pick_list_no_;
   
   pick_list_exists_  NUMBER;
   fully_resreved_pkg_qty_ NUMBER := 0;
   original_pick_list_no_list_    Pick_List_Table := pick_list_no_list_;
BEGIN
   Trace_SYS.Message('in consol_pick_list ******************************************* ');
   Trace_SYS.Field('LOCATION GROUP ', location_group_);
   Trace_SYS.Field('route          ', route_id_);
   Trace_SYS.Field('Ship period    ', ship_period_);
   Trace_SYS.Field('Forward agent  ', forward_agent_);
   Trace_SYS.Field('warehouse      ', warehouse_);
   Trace_SYS.Field('bay            ', bay_no_);
   Trace_SYS.Field('row            ', row_no_);
   Trace_SYS.Field('tier           ', tier_no_);
   Trace_SYS.Field('bin            ', bin_no_);
   Trace_SYS.Field('adr 1          ', addr_1_);
   Trace_SYS.Field('adr 2          ', addr_2_);
   Trace_SYS.Field('adr 3          ', addr_3_);
   Trace_SYS.Field('adr 4          ', addr_4_);
   Trace_SYS.Field('adr 5          ', addr_5_);
   Trace_SYS.Field('adr 6          ', addr_6_);
   Trace_SYS.Field('country        ', country_code_);
   Trace_SYS.Field('Storage Zone   ', storage_zone_id_);
   
   shipment_id_tab_.DELETE;
      
   IF ((storage_zone_id_ IS NOT NULL) AND (storage_zone_id_ != '%')) THEN
      sql_where_expression_ := Storage_Zone_API.Get_Sql_Where_Expression(contract_, storage_zone_id_);
   END IF;
      
   IF (preliminary_pick_list_no_ IS NULL) THEN
      -- Parameter shipment_ids_ => 'DUMMY', only if this method call from Consol_Ship_Pick_List___.
      IF shipment_ids_ = 'DUMMY' THEN
         temp_shipment_ids_ := 0;
      ELSE
         temp_shipment_ids_ := shipment_ids_;
      END IF;
      
      IF sql_where_expression_  IS NOT NULL THEN
         IF (selection_ = 'ALL_LINES') THEN
            IF (consolidation_ = 'STORAGE ZONE') THEN
               IF from_ship_consol_pl_ THEN
                  stmt_all_lines_ := 'AND EXISTS (SELECT shipment_id FROM create_consol_pick_list_tmp WHERE ('|| sql_where_expression_ ||')) ';
               ELSE               
                  stmt_all_lines_ := 'AND EXISTS (SELECT order_no FROM create_consol_pick_list_tmp WHERE ('|| sql_where_expression_ ||')) ';
               END IF;
            END IF;
         ELSE
            stmt_where_ := 'AND ('|| sql_where_expression_ ||') ';
         END IF;
         stmt_where_inner_ := 'WHERE location_no = cor.location_no AND ('|| sql_where_expression_ ||') ';
      ELSE
         IF((location_group_ IS NOT NULL) AND (location_group_ !='%')) THEN
            stmt_where_inner_ := 'WHERE location_no = cor.location_no AND NOT EXISTS (SELECT 1 FROM create_consol_pick_list_tmp WHERE Report_SYS.Parse_Parameter(location_group, '''||sel_location_group_||''' ) = ''FALSE'') ';
         END IF;
      END IF;
      IF from_ship_consol_pl_ THEN
         stmt_select_ := 'SELECT customer_no,     contract,     part_no,          location_no,
                                 lot_batch_no,    serial_no,    waiv_dev_rej_no,  eng_chg_level,
                                 pick_list_no,    order_no,         line_no,
                                 rel_no,          line_item_no, configuration_id, activity_seq,         
                                 planned_due_date, shipment_id, planned_ship_date, handling_unit_id
                          FROM   create_consol_pick_list_tmp cplj
                          WHERE  shipment_id   LIKE '''||shipment_id_ ||'''
                          AND    customer_no   LIKE '''||customer_no_ ||'''
                          AND    (parent_consol_shipment_id   LIKE '''||consol_shipment_id_ ||''' OR (parent_consol_shipment_id  IS NULL AND DECODE('''||consol_shipment_id_ ||''',   ''%'', NULL, '''||consol_shipment_id_ ||''') IS NULL))
                          AND    (ship_inventory_location_no  LIKE '''||shipment_location_ ||'''  OR (ship_inventory_location_no IS NULL AND DECODE('''||shipment_location_ ||''',    ''%'', NULL, '''||shipment_location_ ||''')  IS NULL))
                          AND    (planned_ship_period         LIKE '''||ship_period_ ||'''        OR (planned_ship_period        IS NULL AND DECODE('''||ship_period_ ||''',          ''%'', NULL, '''||ship_period_ ||''')        IS NULL))
                          AND    (route_id                    LIKE '''||route_id_ ||'''           OR (route_id                   IS NULL AND DECODE('''||route_id_ ||''',             ''%'', NULL, '''||route_id_ ||''')           IS NULL))                          
                          AND    (forward_agent_id            LIKE '''||forward_agent_ ||'''      OR (forward_agent_id           IS NULL AND DECODE('''||forward_agent_ ||''',        ''%'', NULL, '''||forward_agent_ ||''')      IS NULL))
                          AND    warehouse_id  LIKE :warehouse_             
                          AND    ((bay_id   LIKE :bay_no_  ) OR (bay_id  IS NULL AND DECODE(:bay_no_,  ''%'', NULL, :bay_no_  ) IS NULL))
                          AND    ((row_id   LIKE :row_no_  ) OR (row_id  IS NULL AND DECODE(:row_no_,  ''%'', NULL, :row_no_  ) IS NULL))
                          AND    ((tier_id  LIKE :tier_no_ ) OR (tier_id IS NULL AND DECODE(:tier_no_, ''%'', NULL, :tier_no_ ) IS NULL))
                          AND    ((bin_id   LIKE :bin_no_  ) OR (bin_id  IS NULL AND DECODE(:bin_no_,  ''%'', NULL, :bin_no_  ) IS NULL))
                          AND    (pick_inventory_type_db   = '''||pick_inventory_type_db_ ||''')
                          AND    location_group            = '''||location_group_ ||'''
                          AND    (('''||selection_||''' = ''WITHIN_SELECTION'') OR
                                  ('''||selection_||''' = ''ALL_LINES'' '|| stmt_all_lines_ ||') OR
                                  ('''||selection_||''' = ''COMPLETE_WITHIN_SELECTION'' AND NOT EXISTS ((SELECT order_no, line_no, rel_no, line_item_no
                                                                                                           FROM customer_order_reservation_tab cor
                                                                                                           WHERE cor.shipment_id = cplj.shipment_id
                                                                                                           AND   cor.pick_list_no = ''*''   
                                                                                                           AND NOT EXISTS (SELECT order_no, line_no, rel_no, line_item_no
                                                                                                                           FROM create_consol_pick_list_tmp '|| stmt_where_inner_ ||'))
                                                                                                         ))) '; 
      ELSE
         stmt_select_ := 'SELECT customer_no,     contract,     part_no,          location_no,
                                 lot_batch_no,    serial_no,    waiv_dev_rej_no,  eng_chg_level,
                                 pick_list_no,    order_no,         line_no,
                                 rel_no,          line_item_no, configuration_id, activity_seq,         
                                 planned_due_date, shipment_id, planned_ship_date, handling_unit_id
                          FROM   create_consol_pick_list_tmp cplj
                          WHERE  order_no              LIKE '''||order_no_ ||'''
                          AND    customer_no           LIKE '''||customer_no_ ||'''
                          AND    (route_id             LIKE '''||route_id_ ||'''       OR (route_id            IS NULL AND DECODE('''||route_id_ ||''',      ''%'', NULL, '''||route_id_ ||''')      IS NULL))
                          AND    (planned_ship_period  LIKE '''||ship_period_ ||'''    OR (planned_ship_period IS NULL AND DECODE('''||ship_period_ ||''',   ''%'', NULL, '''||ship_period_ ||''')   IS NULL))
                          AND    (forward_agent_id     LIKE '''||forward_agent_ ||'''  OR (forward_agent_id    IS NULL AND DECODE('''||forward_agent_ ||''', ''%'', NULL, '''||forward_agent_ ||''') IS NULL))
                          AND    warehouse_id    LIKE :warehouse_            
                          AND    ((bay_id        LIKE :bay_no_ ) OR (bay_id  IS NULL AND DECODE(:bay_no_,  ''%'', NULL, :bay_no_  ) IS NULL))
                          AND    ((row_id        LIKE :row_no_ ) OR (row_id  IS NULL AND DECODE(:row_no_,  ''%'', NULL, :row_no_  ) IS NULL))
                          AND    ((tier_id       LIKE :tier_no_) OR (tier_id IS NULL AND DECODE(:tier_no_, ''%'', NULL, :tier_no_ ) IS NULL))
                          AND    ((bin_id        LIKE :bin_no_ ) OR (bin_id  IS NULL AND DECODE(:bin_no_,  ''%'', NULL, :bin_no_  ) IS NULL))
                          AND    ((addr_1        LIKE :addr_1 ) OR (addr_1 IS NULL AND DECODE(:addr_1 , ''%'', NULL, :addr_1 ) IS NULL))
                          AND    ((addr_2        LIKE :addr_2 ) OR (addr_2 IS NULL AND DECODE(:addr_2 , ''%'', NULL, :addr_2 ) IS NULL))
                          AND    ((addr_3        LIKE :addr_3 ) OR (addr_3 IS NULL AND DECODE(:addr_3 , ''%'', NULL, :addr_3 ) IS NULL))
                          AND    ((addr_4        LIKE :addr_4 ) OR (addr_4 IS NULL AND DECODE(:addr_4 , ''%'', NULL, :addr_4 ) IS NULL))
                          AND    ((addr_5        LIKE :addr_5 ) OR (addr_5 IS NULL AND DECODE(:addr_5 , ''%'', NULL, :addr_5 ) IS NULL))
                          AND    ((addr_6        LIKE :addr_6 ) OR (addr_6 IS NULL AND DECODE(:addr_6 , ''%'', NULL, :addr_6 ) IS NULL))
                          AND    ((country_code  LIKE '''||country_code_ ||''')  OR (country_code  IS NULL AND DECODE('''||country_code_ ||''',  ''%'', NULL, '''||country_code_ ||''')  IS NULL))
                          AND    (shipment_id IN (SELECT TO_NUMBER(xt.column_value) FROM XMLTABLE('''||temp_shipment_ids_||''') xt))                         
                          AND    (ship_inventory_location_no  LIKE '''||shipment_location_ ||'''  OR (ship_inventory_location_no IS NULL AND DECODE('''||shipment_location_ ||''', ''%'', NULL, '''||shipment_location_ ||''') IS NULL))
                          AND    (pick_inventory_type_db   = '''||pick_inventory_type_db_ ||''')
                          AND    location_group            = '''||location_group_ ||'''
                          AND    (('''||selection_||''' = ''WITHIN_SELECTION'') OR
                                  ('''||selection_||''' = ''ALL_LINES'' '|| stmt_all_lines_ ||') OR
                                  ('''||selection_||''' = ''COMPLETE_WITHIN_SELECTION'' AND NOT EXISTS (( SELECT order_no, line_no, rel_no, line_item_no
                                                                                                           FROM customer_order_reservation_tab cor
                                                                                                           WHERE cor.order_no = cplj.order_no
                                                                                                           AND   cor.pick_list_no = ''*''   
                                                                                                           AND NOT EXISTS (SELECT order_no, line_no, rel_no, line_item_no
                                                                                                                           FROM create_consol_pick_list_tmp '|| stmt_where_inner_ ||'))
                                                                                                         ))) '; 
      END IF;
            
      -- Create complete select statement.
      IF from_ship_consol_pl_ THEN
         stmt_ := stmt_select_ || stmt_where_ || 'ORDER BY shipment_id, order_no, to_number(line_no), to_number(rel_no), line_item_no ';
         @ApproveDynamicStatement(2013-09-05,MAHPLK)
         OPEN get_limit_ FOR stmt_ USING warehouse_, 
                                         bay_no_,  bay_no_,  bay_no_,
                                         row_no_,  row_no_,  row_no_,
                                         tier_no_, tier_no_, tier_no_,
                                         bin_no_,  bin_no_,  bin_no_;
         FETCH get_limit_ BULK COLLECT INTO limitrec_;
         CLOSE get_limit_;
      ELSE
         stmt_ := stmt_select_ || stmt_where_ || 'ORDER BY order_no, to_number(line_no), to_number(rel_no), line_item_no ';
         @ApproveDynamicStatement(2013-09-05,MAHPLK)
         OPEN get_limit_ FOR stmt_ USING warehouse_, 
                                         bay_no_,  bay_no_,  bay_no_,
                                         row_no_,  row_no_,  row_no_,
                                         tier_no_, tier_no_, tier_no_,
                                         bin_no_,  bin_no_,  bin_no_,
                                         addr_1_, addr_1_, addr_1_, addr_2_, addr_2_, addr_2_, addr_3_, addr_3_, addr_3_,
                                         addr_4_, addr_4_, addr_4_, addr_5_, addr_5_, addr_5_, addr_6_, addr_6_, addr_6_;
         FETCH get_limit_ BULK COLLECT INTO limitrec_;
         CLOSE get_limit_;
      END IF;      
   ELSE
      worker_id_ := Manual_Consol_Pick_List_API.Get_Worker_Id(preliminary_pick_list_no_);
      OPEN  prel_pick_lines;
      FETCH prel_pick_lines BULK COLLECT INTO limitrec_;
      CLOSE prel_pick_lines;
   END IF;

   IF (warehouse_task_list_ IS NULL) THEN
      temp_separator_ := '';
   ELSE
      temp_separator_ := ', ';
   END IF;

   Inventory_Event_Manager_API.Start_Session;
   @ApproveTransactionStatement(2018-02-09, MeAblk)
   SAVEPOINT start_create_consol_picklist;
   
   IF (limitrec_.FIRST IS NOT NULL) THEN
      FOR i_ IN limitrec_.FIRST .. limitrec_.LAST LOOP
         @ApproveTransactionStatement(2018-02-09, MeAblk)
         SAVEPOINT start_connect_reservation_line;
         
         IF failed_order_no_list_.EXISTS(limitrec_(i_).order_no) THEN
            CONTINUE;
         END IF;
         -- Check if a backorder would be generated
         backorder_option_db_ := Customer_Order_API.Get_Backorder_Option_Db(limitrec_(i_).order_no);

         IF (backorder_option_db_ = 'NO PARTIAL DELIVERIES ALLOWED') THEN
            IF (Check_Order_For_Backorder__(limitrec_(i_).order_no)) THEN
               -- Backorders not allowed!!
               -- Do not include this order on the consolidated pick list
               info_ := Language_SYS.Translate_Constant (lu_name_, 'NOCONPICKLIST: Cannot create consolidated pick list for order. Partial deliveries not allowed for order :P1.', NULL, limitrec_(i_).order_no);
               Transaction_SYS.Log_Status_Info(info_);
               backorder_check_passed_  := FALSE;
               has_invalid_order_lines_ := TRUE;
               CONTINUE;
            ELSE
               backorder_check_passed_ := TRUE;
            END IF;
         END IF;


         has_config_mismatch_ := Order_Config_Util_API.Check_Cust_Ord_Config_Mismatch(limitrec_(i_).order_no);        
         IF (has_config_mismatch_ = 'TRUE') THEN              
            info_ := Language_SYS.Translate_Constant (lu_name_, 'CONFIGMISMATCH: Pick list creation is not allowed for order :P1 since it has lines with different configurations in supply and demand sites.', NULL, limitrec_(i_).order_no);
            Transaction_SYS.Log_Status_Info(info_);
         END IF;
         Check_All_License_Connected___(all_license_connected_, raise_message_ , limitrec_(i_).order_no, limitrec_(i_).line_no, limitrec_(i_).rel_no, limitrec_(i_).line_item_no);

         -- Export control, check if license is connected
         IF (all_license_connected_ = 'TRUE' AND (backorder_option_db_ != 'NO PARTIAL DELIVERIES' OR backorder_check_passed_)) THEN
            IF (shipment_ids_ IN  ('0', 'DUMMY')) THEN
               Customer_Order_Flow_API.Credit_Check_Order(limitrec_(i_).order_no,'CREATE_PICK_LIST');
            END IF;

            IF (Customer_Order_API.Get_Objstate(limitrec_(i_).order_no) != 'Blocked') THEN
               -- Update order reservation status
               IF (limitrec_(i_).line_item_no >= 0 AND ((limitrec_(i_).order_no != NVL(ord_no_, Database_SYS.string_null_)) OR (limitrec_(i_).line_no != NVL(line_no_, Database_SYS.string_null_)) OR (limitrec_(i_).rel_no != NVL(rel_no_, Database_SYS.string_null_)))) THEN
                  IF (backorder_option_db_ != 'NO PARTIAL DELIVERIES ALLOWED') THEN
                     backorder_check_passed_ :=  Line_Backorder_Check_Passed__(limitrec_(i_).order_no, limitrec_(i_).line_no, limitrec_(i_).rel_no,
                                                                               limitrec_(i_).line_item_no, backorder_option_db_, location_group_, warehouse_);
                  END IF;
               END IF;
            ELSE
               IF (preliminary_pick_list_no_ IS NOT NULL) THEN
                  -- Disconnect blocked orders from the consolidated pick list
                  Customer_Order_Reservation_API.Modify_Prelim_Pick_List_No(order_no_                 => limitrec_(i_).order_no,         
                                                                            line_no_                  => limitrec_(i_).line_no,
                                                                            rel_no_                   => limitrec_(i_).rel_no,           
                                                                            line_item_no_             => limitrec_(i_).line_item_no,
                                                                            contract_                 => limitrec_(i_).contract,         
                                                                            part_no_                  => limitrec_(i_).part_no,
                                                                            location_no_              => limitrec_(i_).location_no,      
                                                                            lot_batch_no_             => limitrec_(i_).lot_batch_no,
                                                                            serial_no_                => limitrec_(i_).serial_no,        
                                                                            eng_chg_level_            => limitrec_(i_).eng_chg_level,
                                                                            waiv_dev_rej_no_          => limitrec_(i_).waiv_dev_rej_no,  
                                                                            activity_seq_             => limitrec_(i_).activity_seq,
                                                                            handling_unit_id_         => limitrec_(i_).handling_unit_id,
                                                                            pick_list_no_             => limitrec_(i_).pick_list_no,
                                                                            configuration_id_         => limitrec_(i_).configuration_id, 
                                                                            shipment_id_              => limitrec_(i_).shipment_id, 
                                                                            preliminary_pick_list_no_ => NULL);
                  IF ((prev_order_no_ IS NULL) OR (prev_order_no_ != limitrec_(i_).order_no) OR (prev_line_no_ != limitrec_(i_).line_no)
                      OR (prev_rel_no_ != limitrec_(i_).rel_no) OR (prev_line_item_no_ != limitrec_(i_).line_item_no)) THEN                                                          
                     info_ := Language_SYS.Translate_Constant(lu_name_, 'REMCOFROMPILI: Customer order line :P1 was removed from manual consolidated pick list :P2 due to credit block.', 
                                                              NULL, (limitrec_(i_).order_no||'-'||limitrec_(i_).line_no||'-'|| limitrec_(i_).rel_no||'-'|| limitrec_(i_).line_item_no), preliminary_pick_list_no_);
                     Transaction_SYS.Log_Status_Info(info_);
                     prev_order_no_     := limitrec_(i_).order_no;
                     prev_line_no_      := limitrec_(i_).line_no;
                     prev_rel_no_       := limitrec_(i_).rel_no;
                     prev_line_item_no_ := limitrec_(i_).line_item_no;
                  END IF;
               END IF;
               CONTINUE;
            END IF;

            IF shipment_ids_ = 'DUMMY' THEN
               prev_tmp_shipment_id_ := tmp_shipment_id_;
               -- Added If condition to check the back order check before creating a line.
               IF (NOT(backorder_check_passed_)) AND (backorder_option_db_ = 'INCOMPLETE LINES NOT ALLOWED') THEN
                  --If the back order check is not passed, exit the loop to avoid adding two warining messages in the background job.
                   CONTINUE;
               END IF;
               Create_Ship_At_Consol_Pl___(tmp_shipment_id_, shipment_id_tab_, limitrec_(i_).order_no, limitrec_(i_).line_no, limitrec_(i_).rel_no,
                                           limitrec_(i_).line_item_no, ignore_existing_shipment_);            
            ELSE
               IF (i_ > 1) THEN
                  prev_tmp_shipment_id_ := NVL(limitrec_(i_- 1).shipment_id , 0);
               END IF;
               tmp_shipment_id_ := limitrec_(i_).shipment_id;
            END IF;

            IF (shipment_ids_ = '0') THEN
               pick_shipment_id_ := NULL;
            ELSE
               IF (max_shipment_on_pick_list_ = 1) THEN
                  pick_shipment_id_ := tmp_shipment_id_;
               ELSE               
                  pick_shipment_id_ := NULL;
               END IF;
            END IF;

            exist_shipment_id_ := 'FALSE';
            FOR index1_ IN 1..pick_list_shipment_tab_.COUNT LOOP
               IF (tmp_shipment_id_ != 0) THEN
                  --Added check for pick_list_created_ in order to avoid assigning a pick list number of a pick list that was rolled back.
                  IF((tmp_shipment_id_ =  pick_list_shipment_tab_(index1_).shipment_id) AND (pick_list_created_))THEN
                     exist_shipment_id_ := 'TRUE';
                     pick_list_no_tmp_ := pick_list_shipment_tab_(index1_).pick_list_id;
                  END IF;
               END IF;
            END LOOP;
            
            -- Check whether the CO number is different from the previous CO number.
            IF (limitrec_(i_).order_no != NVL(ord_no_, Database_SYS.string_null_)) OR
                (tmp_shipment_id_ != 0 AND tmp_shipment_id_ != NVL(ship_id_, 0)) THEN 

               different_co_ := different_co_ + 1;

               IF (tmp_shipment_id_ != 0 ) THEN               
                  IF (NVL(INSTR(temp_shipment_ids_, tmp_shipment_id_) ,0) = 0) THEN                  
                     IF (i_ = limitrec_.FIRST) THEN
                        different_shipment_ := different_shipment_ + 1;
                     ELSE
                        IF (tmp_shipment_id_ != NVL(prev_tmp_shipment_id_ , 0)) THEN
                           different_shipment_ := different_shipment_ + 1;
                        END IF; 
                     END IF;                     
                  END IF;
               END IF;

               -- Check whether the number of different COs are equal to the maximum COs on a Pick List. Or it is the first CO number.
               IF (different_co_ = TO_NUMBER(max_orders_on_pick_list_) OR (ord_no_ IS NULL) OR different_shipment_ = TO_NUMBER(max_shipment_on_pick_list_)) THEN               
                  different_co_       := 0;
                  different_shipment_ := 0;
                  temp_shipment_ids_  := NULL;
                  IF (backorder_check_passed_ AND has_config_mismatch_ = 'FALSE') THEN
                     -- Check if pick list is already created to add a new warehouse task
                     IF (pick_list_created_) THEN
                        -- Create or update warehouse task
                        msg_ := Language_SYS.Translate_Constant(lu_name_, 'TASK_INFO: Customer No: :P1 * Order No: :P2 *', NULL, tsk_customers_info_, tsk_orders_info_);
                        Create_or_Update_Wh_Task___( task_id_,
                                                     original_pick_list_no_list_,
                                                     priority_,
                                                     pick_list_no_,
                                                     number_lines_,
                                                     location_group_,
                                                     contract_,
                                                     min_ship_date_,
                                                     msg_,
                                                     worker_id_);
                        IF (con_order_list_ IS NOT NULL) THEN
                           Customer_Order_Pick_List_API.Set_Consolidated_Orders(pick_list_no_, RTRIM(con_order_list_, field_separator_));
                        END IF;
                        IF (include_shipment_ids_ IS NOT NULL) THEN
                           Customer_Order_Pick_List_API.Set_Shipments_Consolidated(pick_list_no_, RTRIM(include_shipment_ids_, field_separator_));
                        END IF;

                        pick_list_created_        := FALSE;
                        max_tsk_order_reached_    := FALSE;
                        max_tsk_custno_reached_   := FALSE;
                        max_con_ord_list_reached_ := FALSE;
                        tsk_orders_info_          := NULL;
                        tsk_customers_info_       := NULL;
                        con_order_list_           := NULL;
                        include_shipment_ids_     := NULL;
                        number_lines_             := 0;
                     END IF;
                     -- Create a new pick list object
                     order_due_date_ := due_date_;
                     create_date_    := Site_API.Get_Site_Date(contract_);
                     IF(exist_shipment_id_ = 'FALSE') THEN
                        pick_list_no_   := Customer_Order_Pick_List_API.New(NULL, pick_inventory_type_db_, pick_shipment_id_, create_date_);
                        IF (tmp_shipment_id_ != 0) THEN
                           pick_list_shipment_tab_(pick_list_shipment_tab_.COUNT + 1).shipment_id := tmp_shipment_id_;
                           pick_list_shipment_tab_(pick_list_shipment_tab_.COUNT).pick_list_id := pick_list_no_;
                        END IF;
                        pick_list_no_list_(pick_list_no_list_.COUNT + 1) := pick_list_no_;
                     ELSE
                        pick_list_no_ := pick_list_no_tmp_;
                     END IF;
                     Customer_Order_Pick_List_API.Set_Consolidated(pick_list_no_);
                     IF (consolidation_ = 'STORAGE ZONE') THEN
                        temp_storage_zone_id_ := storage_zone_id_;      
                     END IF;
                     Customer_Order_Pick_List_API.Set_Selections(pick_list_no_ ,
                                                                 contract_,
                                                                 sel_order_no_,
                                                                 sel_customer_no_,
                                                                 sel_route_id_,
                                                                 sel_ship_period_,
                                                                 sel_forward_agent_,
                                                                 sel_location_group_,
                                                                 consolidation_,
                                                                 order_due_date_,
                                                                 sel_part_no_,
                                                                 sel_ship_via_code_,
                                                                 selection_,
                                                                 max_orders_on_pick_list_,
                                                                 order_type_,
                                                                 coordinator_,
                                                                 co_priority_,
                                                                 sel_storage_zone_id_,
                                                                 pick_shipment_id_,
                                                                 ship_date_,
                                                                 sel_shipment_id_,
                                                                 sel_consol_shipment_id_,   
                                                                 sel_shipment_type_,
                                                                 sel_shipment_location_,
                                                                 max_shipment_on_pick_list_,
                                                                 temp_storage_zone_id_);                                                                 
                     pick_list_created_ := TRUE;
                  END IF;
               ELSE
                  pick_list_no_tmp_ :=  pick_list_no_; 
               END IF;
               
               pick_list_exists_ := NULL;
               
               OPEN check_pick_list_exists(limitrec_(i_).order_no,pick_list_no_);
               FETCH check_pick_list_exists INTO pick_list_exists_;
               CLOSE check_pick_list_exists;

               IF (pick_list_created_ AND (exist_shipment_id_ = 'FALSE' OR limitrec_(i_).order_no !=  NVL(ord_no_, Database_SYS.string_null_)
                  OR  (tmp_shipment_id_ != 0 AND tmp_shipment_id_ != NVL(ship_id_, 0)) )) THEN
                  -- Added CO History record.
                  msg_ := Language_SYS.Translate_Constant(lu_name_, 'PICKCRE: Picklist :P1 created', NULL, pick_list_no_);
                  IF (exist_shipment_id_ = 'FALSE' AND  (limitrec_(i_).order_no = NVL(ord_no_, Database_SYS.string_null_)))  THEN
                     IF (NVL(pick_list_no_, Database_SYS.string_null_) !=  NVL(pick_list_no_tmp_, Database_SYS.string_null_)) THEN
                        Customer_Order_History_API.New(limitrec_(i_).order_no, msg_);
                     END IF;
                  ELSIF (pick_list_exists_ IS NULL) THEN
                  -- If no lines are connected to the pick list, add the order history.   
                     Customer_Order_History_API.New(limitrec_(i_).order_no, msg_);
                  END IF;
                  
                  Cust_Order_Event_Creation_API.Pick_List_Created(limitrec_(i_).order_no);

                  IF (NOT Consolidated_Orders_API.Exists(limitrec_(i_).order_no, pick_list_no_, tmp_shipment_id_)) THEN
                     Consolidated_Orders_API.New(limitrec_(i_).order_no, pick_list_no_, tmp_shipment_id_);
                  END IF;

                  -- Note: Create Customer Order List with length less than 750 for the TASK_INFO message
                  IF (NOT max_tsk_order_reached_) THEN
                     IF ((LENGTH(tsk_orders_info_) + LENGTH(limitrec_(i_).order_no)) > 750) THEN
                        tsk_orders_info_       := tsk_orders_info_ || '...';
                        max_tsk_order_reached_ := TRUE;
                     ELSE
                        tsk_orders_info_       := tsk_orders_info_ || limitrec_(i_).order_no || field_separator_;
                     END IF;
                  END IF;

                  -- Note: Create Customer List with length less than 750 for the TASK_INFO message
                  IF (NOT max_tsk_custno_reached_) THEN
                     IF ((LENGTH(tsk_customers_info_) + LENGTH(limitrec_(i_).customer_no)) > 750) THEN
                        tsk_customers_info_     := tsk_customers_info_ || '...';
                        max_tsk_custno_reached_ := TRUE;
                     ELSE
                        tsk_customers_info_     := tsk_customers_info_ || limitrec_(i_).customer_no || field_separator_;
                     END IF;
                  END IF;

                  -- Note: Create Customer Order List with length less than 2000 for the consolidated orders column
                  IF (NOT max_con_ord_list_reached_) THEN
                     IF ((LENGTH(con_order_list_) + LENGTH(limitrec_(i_).order_no)) > 1999) THEN
                        max_tsk_custno_reached_ := TRUE;
                     ELSE
                        IF NVL(INSTR(con_order_list_, limitrec_(i_).order_no) ,0) = 0 THEN 
                           con_order_list_ := con_order_list_ || limitrec_(i_).order_no || field_separator_;
                        END IF;
                     END IF;
                  END IF;

                  -- Create shipment id list.
                  IF (tmp_shipment_id_ != 0 ) THEN
                     IF NVL(INSTR(temp_shipment_ids_, tmp_shipment_id_) ,0) = 0 THEN 
                        IF ((temp_shipment_ids_ IS NULL) OR (LENGTH(temp_shipment_ids_) + LENGTH(tmp_shipment_id_)) < 2000) THEN
                           temp_shipment_ids_    := temp_shipment_ids_ || tmp_shipment_id_ || field_separator_;
                        END IF;
                        include_shipment_ids_ := temp_shipment_ids_;
                     END IF;
                  END IF;
               END IF;
            END IF;

            -- Update order reservation status
            IF (backorder_check_passed_) THEN
               IF (pick_list_created_) THEN
                  number_lines_ := number_lines_ + 1;
                  
                  reserved_qty_mismatch_   := FALSE;
                  IF (limitrec_(i_).line_item_no >= 0 AND ((limitrec_(i_).order_no != NVL(ord_no_, Database_SYS.string_null_)) OR (limitrec_(i_).line_no != NVL(line_no_, Database_SYS.string_null_)) OR (limitrec_(i_).rel_no != NVL(rel_no_, Database_SYS.string_null_)))) THEN 
                     fully_resreved_pkg_qty_ := Reserve_Customer_Order_API.Get_Full_Reserved_Pkg_Qty(limitrec_(i_).order_no, limitrec_(i_).line_no, limitrec_(i_).rel_no, location_group_, warehouse_, pick_list_no_);
                  END IF;
                  
                  -- This check is useful when reservation exists but has been reduced.
                  Check_If_Reserved_Qty_Changed___(rollback_reservation_, rollback_picklists_, current_passed_order_no_list_, reserved_qty_mismatch_, 
                                                   has_invalid_order_lines_, limitrec_(i_).order_no, limitrec_(i_).line_no, limitrec_(i_).rel_no, 
                                                   limitrec_(i_).line_item_no, backorder_option_db_, fully_resreved_pkg_qty_);
                  IF (reserved_qty_mismatch_ = FALSE) THEN 
                     BEGIN
                        Customer_Order_Reservation_API.Modify_Pick_List_No(limitrec_(i_).order_no,         limitrec_(i_).line_no,
                                                                           limitrec_(i_).rel_no,           limitrec_(i_).line_item_no,
                                                                           limitrec_(i_).contract,         limitrec_(i_).part_no,
                                                                           limitrec_(i_).location_no,      limitrec_(i_).lot_batch_no,
                                                                           limitrec_(i_).serial_no,        limitrec_(i_).eng_chg_level,
                                                                           limitrec_(i_).waiv_dev_rej_no,  limitrec_(i_).activity_seq,
                                                                           limitrec_(i_).handling_unit_id, limitrec_(i_).pick_list_no,
                                                                           limitrec_(i_).configuration_id, tmp_shipment_id_, pick_list_no_ );
                     EXCEPTION
                        WHEN OTHERS THEN
                           reserved_qty_mismatch_   := TRUE;
                           rollback_reservation_    := TRUE;
                           -- This check is useful when reservation exists and got modified but something else failed along the modification. For EXP. when transport task has been 
                           -- created for reservation but move reserve is not allowed for pick listed reservation. In this case we rolback reservation and will log the error.
                           IF Customer_Order_Reservation_API.Exists(limitrec_(i_).order_no,         limitrec_(i_).line_no,
                                                                    limitrec_(i_).rel_no,           limitrec_(i_).line_item_no,
                                                                    limitrec_(i_).contract,         limitrec_(i_).part_no,
                                                                    limitrec_(i_).location_no,      limitrec_(i_).lot_batch_no,
                                                                    limitrec_(i_).serial_no,        limitrec_(i_).eng_chg_level,
                                                                    limitrec_(i_).waiv_dev_rej_no,  limitrec_(i_).activity_seq,
                                                                    limitrec_(i_).handling_unit_id, limitrec_(i_).configuration_id,
                                                                    pick_list_no_,                  tmp_shipment_id_ ) = TRUE THEN 
                              
                              info_ := Language_SYS.Translate_Constant(lu_name_, 'EXCEPTIONRASED: :P1', NULL, SUBSTR(SQLERRM,Instr(SQLERRM,':', 1, 2)+2,2000));
                              -- Since we rollback transactions later we need to use Log_Status_Info instead of Set_Status_Info to commit this status changes before any rollback.
                              Transaction_SYS.Log_Status_Info(info_);
                           END IF;
                     END;   
                  END IF;
                     
                  IF (reserved_qty_mismatch_) THEN
                     number_lines_ := number_lines_ - 1;
                     reserved_qty_mismatch_ := FALSE;
                    
                     IF (rollback_picklists_) THEN
                        dummy_order_no_ := current_passed_order_no_list_.FIRST;
                        LOOP
                           EXIT WHEN dummy_order_no_ IS NULL;
                           failed_order_no_list_(dummy_order_no_) := TRUE;
                           IF passed_order_no_list_.EXISTS(dummy_order_no_) THEN
                              rollback_all_prev_picklist_ := TRUE;
                           END IF;
                           dummy_order_no_ := current_passed_order_no_list_.NEXT(dummy_order_no_);                              
                        END LOOP;

                        IF (rollback_all_prev_picklist_) THEN                          
                           @ApproveTransactionStatement(2018-02-09, MeAblk)
                           ROLLBACK TO start_create_picklist_all;
                           
                           passed_order_no_list_.DELETE;    
                           pick_list_no_list_.DELETE;
                           warehouse_task_list_ := NULL;
                           shipment_id_tab_.DELETE;
                           return_ := TRUE;
                        ELSE
                           @ApproveTransactionStatement(2018-02-09, MeAblk)
                           ROLLBACK TO start_create_consol_picklist;
                        
                           return_ := TRUE;
                        END IF;      
                     END IF;
                     
                     IF (rollback_reservation_) THEN
                        @ApproveTransactionStatement(2018-02-09, MeAblk)
                        ROLLBACK TO  start_connect_reservation_line;
                        IF (number_lines_ = 0) THEN
                           pick_list_no_tmp_ :=  NULL;
                           pick_list_no_     :=  NULL; 
                           pick_list_created_ := FALSE;
                        END IF;   
                        CONTINUE;
                     END IF;
                     
                     IF (backorder_option_db_ = 'NO PARTIAL DELIVERIES ALLOWED') THEN
                        info_ := Language_SYS.Translate_Constant (lu_name_, 'NOCONPICKLIST: Cannot create consolidated pick list for order. Partial deliveries not allowed for order :P1.', NULL, limitrec_(i_).order_no);
                        Transaction_SYS.Log_Status_Info(info_);
                     ELSE
                        Handle_Backorder_Info___(limitrec_(i_).order_no, limitrec_(i_).line_no, limitrec_(i_).rel_no, backorder_option_db_); 
                     END IF;
                     
                     IF (return_) THEN
                        RETURN;
                     END IF;   
                  END IF;
                  
                  IF ((limitrec_(i_).order_no != NVL(ord_no_, Database_SYS.string_null_)) OR (limitrec_(i_).line_no != NVL(line_no_, Database_SYS.string_null_)) OR (limitrec_(i_).rel_no != NVL(rel_no_, Database_SYS.string_null_)) OR (limitrec_(i_).line_item_no != NVL(line_item_no_,0))) THEN
                     -- Added CO Line History record.
                     msg_ := Language_SYS.Translate_Constant(lu_name_, 'PICKCRE: Picklist :P1 created', NULL, pick_list_no_);
                     Customer_Order_Line_Hist_API.New(limitrec_(i_).order_no, limitrec_(i_).line_no,
                                                      limitrec_(i_).rel_no,   limitrec_(i_).line_item_no, msg_);

                     IF ((min_ship_date_ IS NULL) OR (limitrec_(i_).planned_ship_date < min_ship_date_)) THEN
                        min_ship_date_ := limitrec_(i_).planned_ship_date;
                     END IF;
                  END IF;
               END IF;
            ELSE
               IF ((limitrec_(i_).order_no != NVL(ord_no_, Database_SYS.string_null_)) OR (limitrec_(i_).line_no != NVL(line_no_, Database_SYS.string_null_)) OR (limitrec_(i_).rel_no != NVL(rel_no_, Database_SYS.string_null_))) THEN
                  Handle_Backorder_Info___(limitrec_(i_).order_no,
                                           limitrec_(i_).line_no,
                                           limitrec_(i_).rel_no,
                                           backorder_option_db_);
               END IF;
            END IF;

            IF ((limitrec_(i_).order_no != NVL(ord_no_, Database_SYS.string_null_)) OR (limitrec_(i_).line_no != NVL(line_no_, Database_SYS.string_null_)) OR (limitrec_(i_).rel_no != NVL(rel_no_, Database_SYS.string_null_)) OR (limitrec_(i_).line_item_no != NVL(line_item_no_,0))) THEN
               ord_no_       := limitrec_(i_).order_no;
               line_no_      := limitrec_(i_).line_no;
               rel_no_       := limitrec_(i_).rel_no;
               line_item_no_ := limitrec_(i_).line_item_no;
            END IF;
            IF (tmp_shipment_id_ != NVL(ship_id_, 0)) THEN
               ship_id_ := tmp_shipment_id_;
            END IF;
            -- Remove recoeds from 'create_consol_pick_list_tmp' which already included to the pick list
            -- to prevent error in ovelaping storage zones.
            IF sql_where_expression_  IS NOT NULL THEN            
                  DELETE FROM create_consol_pick_list_tmp 
                     WHERE order_no       = limitrec_(i_).order_no
                     AND line_no          = limitrec_(i_).line_no
                     AND rel_no           = limitrec_(i_).rel_no
                     AND line_item_no     = limitrec_(i_).line_item_no
                     AND contract         = limitrec_(i_).contract
                     AND part_no          = limitrec_(i_).part_no
                     AND location_no      = limitrec_(i_).location_no
                     AND lot_batch_no     = limitrec_(i_).lot_batch_no
                     AND serial_no        = limitrec_(i_).serial_no
                     AND eng_chg_level    = limitrec_(i_).eng_chg_level
                     AND waiv_dev_rej_no  = limitrec_(i_).waiv_dev_rej_no
                     AND activity_seq     = limitrec_(i_).activity_seq
                     AND handling_unit_id = limitrec_(i_).handling_unit_id
                     AND pick_list_no     = limitrec_(i_).pick_list_no
                     AND configuration_id = limitrec_(i_).configuration_id
                     AND shipment_id      = limitrec_(i_).shipment_id;
            END IF;            
         END IF; -- Export control, check end.
         IF (backorder_check_passed_ = FALSE OR all_license_connected_ = 'FALSE') THEN
            has_invalid_order_lines_ := TRUE;
         END IF;           
      END LOOP;
   END IF;

  
   IF (pick_list_created_) THEN
      IF (include_shipment_ids_ IS NOT NULL) THEN
         Customer_Order_Pick_List_API.Set_Shipments_Consolidated(pick_list_no_, RTRIM(include_shipment_ids_, field_separator_));
      END IF;
      --To have shipment inventory location if shipment inventory to be used.
      Customer_Order_Pick_List_API.Modify_Default_Ship_Location(pick_list_no_);
      msg_ := Language_SYS.Translate_Constant(lu_name_, 'TASK_INFO: Customer No: :P1 * Order No: :P2 *', NULL, tsk_customers_info_, tsk_orders_info_);
      Create_or_Update_Wh_Task___( task_id_,
                                   original_pick_list_no_list_,
                                   priority_,
                                   pick_list_no_,
                                   number_lines_,
                                   location_group_,
                                   contract_,
                                   min_ship_date_,
                                   msg_,
                                   worker_id_);
      -- Add task_id_ to list if task created
      IF (task_id_ IS NOT NULL) THEN
         warehouse_task_list_ := warehouse_task_list_ || temp_separator_ || task_id_;
         temp_separator_ := ', ';
      END IF;
      IF (con_order_list_ IS NOT NULL) THEN
         Customer_Order_Pick_List_API.Set_Consolidated_Orders(pick_list_no_, RTRIM(con_order_list_, field_separator_));
      END IF;  
   END IF;
   
   FOR select_package_reservations_ IN select_package_reservations LOOP
      IF (NVL(old_order_no_,' ') != select_package_reservations_.order_no) THEN
         backorder_option_db_ := Customer_Order_API.Get_Backorder_Option_Db(select_package_reservations_.order_no);
      END IF;

      catalog_no_ := Customer_Order_Line_API.Get_Catalog_No(select_package_reservations_.order_no,
                                                            select_package_reservations_.line_no,
                                                            select_package_reservations_.rel_no,
                                                            -1);
      allow_partial_pkg_deliv_ := Sales_Part_API.Get_Allow_Partial_Pkg_Deliv_Db(contract_, catalog_no_);

      IF (backorder_option_db_ = 'INCOMPLETE PACKAGES NOT ALLOWED' 
          OR (backorder_option_db_ = 'ALLOW INCOMPLETE LINES AND PACKAGES' AND allow_partial_pkg_deliv_ = 'FALSE')) THEN

         IF (select_package_reservations_.order_no != NVL(old_order_no_, '*') OR
             select_package_reservations_.line_no != NVL(old_line_no_, '*') OR
             select_package_reservations_.rel_no != NVL(old_rel_no_, '*') )THEN

            Reserve_Customer_Order_API.Check_Package_Reservations(whole_pkgs_reserved_,
                                                                  excess_reservations_exist_,
                                                                  select_package_reservations_.order_no,
                                                                  select_package_reservations_.line_no,
                                                                  select_package_reservations_.rel_no);
            IF excess_reservations_exist_ THEN
               Reserve_Customer_Order_API.Split_Package_Reservations(select_package_reservations_.order_no,
                                                                     select_package_reservations_.line_no,
                                                                     select_package_reservations_.rel_no,
                                                                     whole_pkgs_reserved_);
            END IF;
            old_order_no_ := select_package_reservations_.order_no;
            old_line_no_  := select_package_reservations_.line_no;
            old_rel_no_   := select_package_reservations_.rel_no;
         END IF;
      END IF;
   END LOOP;
   
   dummy_order_no_ := current_passed_order_no_list_.FIRST;
   LOOP
      EXIT WHEN dummy_order_no_ IS NULL;
      passed_order_no_list_(dummy_order_no_) := TRUE;
      dummy_order_no_ := current_passed_order_no_list_.NEXT(dummy_order_no_);                              
   END LOOP;
   
   Inventory_Event_Manager_API.Finish_Session;
END Consol_Pick_List___;


-- Credit_Check_Ship_Pick_List___
--   Do the credit check for customer orders connected to the shipment and
--   returns a boolean value.
FUNCTION Credit_Check_Ship_Pick_List___ (
   shipment_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   objstate_         CUSTOMER_ORDER_TAB.rowstate%TYPE;
   credit_check_ok_  BOOLEAN := TRUE;
   CURSOR get_shipment_order IS
      SELECT DISTINCT order_no
      FROM CREATE_PICK_LIST_JOIN_MAIN
      WHERE shipment_id = shipment_id_;
BEGIN
   FOR shipment_order IN get_shipment_order LOOP
       Customer_Order_Flow_API.Credit_Check_Order(shipment_order.order_no, 'CREATE_PICK_LIST');
       objstate_ := Customer_Order_API.Get_objstate(shipment_order.order_no);
       IF (objstate_ = 'Blocked') THEN
          credit_check_ok_ := FALSE;
       END IF;
   END LOOP;
   RETURN credit_check_ok_;
END Credit_Check_Ship_Pick_List___;


-- Credit_Check_Order___
--   Do the credit check for customer order and returns a boolean value.
FUNCTION Credit_Check_Order___ (
   order_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   credit_check_ok_ BOOLEAN := TRUE;
BEGIN
   IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') THEN
      -- In this the Objstate of CO can becomes 'Blocked'
      Customer_Order_Flow_API.Credit_Check_Order(order_no_,'CREATE_PICK_LIST');
   END IF;
   IF (Customer_Order_API.Get_Objstate(order_no_) = 'Blocked') THEN
      credit_check_ok_ := FALSE;
   END IF; 

   RETURN credit_check_ok_;
END Credit_Check_Order___;


-- Create_Ship_At_Consol_Pl___
--   Used to handle connecting Customer Order Lines to appropriate Shipments
--   that were when "create Consolidated Pick List" is executed for Customer
--   Order/Orders.
PROCEDURE Create_Ship_At_Consol_Pl___ (
   shipment_id_              OUT    NUMBER,
   shipment_id_tab_          IN OUT Shipment_API.Shipment_Id_Tab,
   order_no_                 IN     VARCHAR2,
   line_no_                  IN     VARCHAR2,
   rel_no_                   IN     VARCHAR2,
   line_item_no_             IN     NUMBER,   
   ignore_existing_shipment_ IN     VARCHAR2)
IS
   new_shipment_id_      NUMBER;
   ignore_existing_flag_ VARCHAR2(5);  
   shipmentid_tab_       Shipment_API.Shipment_Id_Tab;
BEGIN
   ignore_existing_flag_ := ignore_existing_shipment_ ;   
   
   IF (ignore_existing_shipment_ = 'TRUE') THEN
      shipmentid_tab_ := shipment_id_tab_;
   END IF;

   IF (shipment_id_tab_.COUNT != 0) THEN
      ignore_existing_flag_ := 'FALSE';
   END IF;

   Shipment_Handling_Utility_API.Add_Source_Line_To_Shipment(new_shipment_id_,
                                                            order_no_,
                                                            line_no_,
                                                            rel_no_,
                                                            line_item_no_,
                                                            Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER,
                                                            Sender_Receiver_Type_API.DB_CUSTOMER,
                                                            shipmentid_tab_,
                                                            ignore_existing_flag_);
   shipment_id_ := new_shipment_id_;
   shipment_id_tab_(shipment_id_tab_.COUNT + 1) := new_shipment_id_;
   IF (shipment_id_tab_.COUNT > 1) THEN
      Discard_Duplicate_Shipments___(shipment_id_tab_);
   END IF;
END Create_Ship_At_Consol_Pl___;


-- Handle_Backorder_Info___
--   This handles the Information messages when line is not fully reserved.
PROCEDURE Handle_Backorder_Info___ (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   backorder_option_ IN VARCHAR2 )
IS
   order_line_info_ VARCHAR2(100) := NULL;
   picklist_info_   VARCHAR2(2000) := NULL;
   part_no_         VARCHAR2(25);
BEGIN
   order_line_info_ := order_no_ ||' '|| line_no_ ||' '|| rel_no_;
   IF (backorder_option_ = 'INCOMPLETE LINES NOT ALLOWED') THEN
      -- write an info message to background
      picklist_info_ := Language_SYS.Translate_Constant(lu_name_, 'CANNOTPICKLIST1: Partial delivery not allowed for order line :P1. Line is not included in the pick list.',
                                                        NULL, order_line_info_);
      Transaction_SYS.Log_Status_Info(picklist_info_);
   ELSIF (backorder_option_ IN ('INCOMPLETE PACKAGES NOT ALLOWED','ALLOW INCOMPLETE LINES AND PACKAGES')) THEN
      -- write an info message to background
      part_no_       := Customer_Order_Line_API.Get_Catalog_No(order_no_,line_no_, rel_no_, -1);
      picklist_info_ := Language_SYS.Translate_Constant(lu_name_, 'CANNOTPICKLIST2: No Partial deliveries allowed for incomplete package part :P1. Line is not included in the pick list.',
                                                        NULL, part_no_);
      Transaction_SYS.Log_Status_Info(picklist_info_);
   END IF;
END Handle_Backorder_Info___;


-- Discard_Duplicate_Shipments___
--   This method is used to discard duplicate shipment ids stored
--   in the table if there are any.
PROCEDURE Discard_Duplicate_Shipments___ (
   shipment_id_tab_ IN OUT Shipment_API.Shipment_Id_Tab )
IS
   temp_          Shipment_API.Shipment_Id_Tab;
   id_found_      BOOLEAN := FALSE;
   shipment_id_   NUMBER;
   index1_        NUMBER;
BEGIN
   FOR index_ IN 1..shipment_id_tab_.COUNT LOOP
      shipment_id_ := shipment_id_tab_ (index_);
      index1_ := 1;
      WHILE (temp_.COUNT >= index1_ ) LOOP
         IF (shipment_id_ = temp_(index1_)) THEN
            id_found_ := TRUE;
         END IF;
         index1_ := index1_ + 1;
      END LOOP;

      IF (id_found_ = FALSE) THEN
         temp_(temp_.COUNT +1 ) := shipment_id_;
      END IF;
      id_found_ := FALSE;
      END LOOP;
   shipment_id_tab_ := temp_;
END Discard_Duplicate_Shipments___;


PROCEDURE Check_All_License_Connected___ (
   all_license_connected_ OUT VARCHAR2,
   raise_message_         OUT VARCHAR2,
   order_no_              IN  VARCHAR2,
   line_no_               IN  VARCHAR2,
   rel_no_                IN  VARCHAR2,
   line_item_no_          IN  NUMBER )
IS
   exp_ctrl_info_             VARCHAR2(32000);
BEGIN
   Log_SYS.Stack_Trace_(Log_SYS.info_, 'Customer_Order_Flow_API.Check_All_License_Connected___');
   all_license_connected_ := 'TRUE';
   raise_message_         := 'FALSE';
   IF (Customer_Order_Flow_API.Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
      $IF (Component_Expctr_SYS.INSTALLED) $THEN
         -- Since Get_All_License_Connected() method is deprecated added Get_Order_License_Connect_Info() method.
         Exp_License_Connect_Util_API.Get_Order_License_Connect_Info(all_license_connected_, raise_message_, order_no_, line_no_, rel_no_, line_item_no_ );
      $ELSE
         -- This code block get empty when export control component is not installed.
         NULL;
      $END
   END IF;

   Trace_SYS.Field('raise_message_', raise_message_);
   Trace_SYS.Field('all_license_connected_', all_license_connected_);

   IF(raise_message_ = 'TRUE') THEN
      IF (Transaction_SYS.Is_Session_Deferred ) THEN
         Transaction_SYS.Log_Status_Info(Language_SYS.Translate_Constant(lu_name_, 'EXPLICOVERRIDECONN: The Order No. :P1, Line No. :P2 and Del No. :P3 is not connected to an export license.', NULL, order_no_, line_no_, rel_no_));
      ELSIF (all_license_connected_ = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'EXP_LIC_UNCON_WITHOUT_AUTH: Export Licenses must be connected to order :P1, line no. :P2 and del no. :P3 to proceed, please use the Find and Connect License.', order_no_, line_no_, rel_no_);
      ELSIF (all_license_connected_ = 'TRUE') THEN
         exp_ctrl_info_ := Language_SYS.Translate_Constant(lu_name_, 'EXP_LIC_UNCON_WITH_AUTH: Export Licenses were not connected to order :P1, line no :P2, but proceeded creating picklist since user :P3 has ''Override License Authority''.', Language_SYS.Get_Language, order_no_, line_no_, Fnd_Session_API.Get_Fnd_User);
         IF (NOT App_Context_SYS.Exists('CREATE_PICK_LIST_API.EXPORT_CONTROL_INFO_') OR App_Context_SYS.Find_Value('CREATE_PICK_LIST_API.EXPORT_CONTROL_INFO_', '') != '') THEN
            exp_ctrl_info_ := SUBSTR('INFO'||Client_SYS.field_separator_||exp_ctrl_info_, 1, 2000);
         ELSIF (LENGTH(App_Context_SYS.Get_Value('CREATE_PICK_LIST_API.EXPORT_CONTROL_INFO_')) < 2000) THEN
            exp_ctrl_info_ := SUBSTR(App_Context_SYS.Get_Value('CREATE_PICK_LIST_API.EXPORT_CONTROL_INFO_')||chr(10)||exp_ctrl_info_, 1, 2000);
         END IF;
         App_Context_SYS.Set_Value('CREATE_PICK_LIST_API.EXPORT_CONTROL_INFO_', exp_ctrl_info_);
      END IF;
   ELSE
      NULL; -- Export Licenses is in Approved state
   END IF;

END Check_All_License_Connected___;


-- Fill_Temporary_Table___
--   Fill temporary table create_consol_pick_list_tmp.
--   Since create_consol_pick_list_tmp is used in Consol_Pick_List___ for further selection,
--   this method needs to be call before Consol_Pick_List___.
PROCEDURE Fill_Temporary_Table___ (
   contract_                           IN VARCHAR2,
   order_no_                           IN VARCHAR2,
   customer_no_                        IN VARCHAR2,
   part_no_                            IN VARCHAR2,
   ship_via_code_                      IN VARCHAR2,      
   coordinator_                        IN VARCHAR2,
   order_type_                         IN VARCHAR2,
   co_priority_                        IN NUMBER,
   route_id_                           IN VARCHAR2,
   ship_period_                        IN VARCHAR2,
   forward_agent_                      IN VARCHAR2,
   location_group_                     IN VARCHAR2,
   shipment_ids_                       IN VARCHAR2,   
   due_date_                           IN DATE,
   selection_                          IN VARCHAR2,
   consolidate_                        IN VARCHAR2,
   preliminary_pick_list_no_           IN VARCHAR2,
   consolidate_shipment_id_            IN VARCHAR2,   
   shipment_type_                      IN VARCHAR2,
   shipment_location_                  IN VARCHAR2,
   ship_date_                          IN DATE,
   from_ship_consol_pl_                IN BOOLEAN,
   hu_to_be_picked_in_one_step_        IN BOOLEAN DEFAULT FALSE)
IS 
   CURSOR get_shipment_id IS
      SELECT DISTINCT shipment_id
      FROM create_consol_pick_list_tmp;
BEGIN
   DELETE FROM create_consol_pick_list_tmp;
   
   IF consolidate_ IS NULL AND preliminary_pick_list_no_ IS NOT NULL THEN
      INSERT INTO create_consol_pick_list_tmp (location_group,   pick_inventory_type_db,    order_no,   line_no,  
                                               rel_no,           line_item_no,              planned_due_date,
                                               shipment_id,      addr_1,                    addr_2,     addr_3, 
                                               addr_4,           addr_5,                    addr_6,     country_code,                              
                                               customer_no,      route_id,                  planned_ship_period,
                                               forward_agent_id, warehouse_id,              bay_id,     row_id, 
                                               tier_id,          bin_id,                    contract,   part_no,
                                               location_no,      lot_batch_no,              serial_no,  waiv_dev_rej_no,
                                               eng_chg_level,    pick_list_no,
                                               configuration_id, activity_seq,              handling_unit_id)       
                  (SELECT  location_group,   pick_inventory_type_db,    order_no,   line_no,  
                           rel_no,           line_item_no,              planned_due_date,
                           shipment_id,      addr_1,                    addr_2,     addr_3, 
                           addr_4,           addr_5,                    addr_6,     country_code,                              
                           customer_no,      route_id,                  planned_ship_period,
                           forward_agent_id, warehouse,                 bay_no,     row_no, 
                           tier_no,          bin_no,                    contract,   part_no,
                           location_no,      lot_batch_no,              serial_no,  waiv_dev_rej_no,
                           eng_chg_level,    pick_list_no,
                           configuration_id, activity_seq,              handling_unit_id
                     FROM  create_pick_list_join_main
                     WHERE preliminary_pick_list_no = preliminary_pick_list_no_
                     AND   pick_list_no  = '*'
                     AND   selection_    = 'WITHIN_SELECTION'
                     AND   shipment_creation_db  != 'PICK_LIST_CREATION');
   END IF;
   
   IF consolidate_ IS NOT NULL THEN
      -- 'CREATE_SHIPMENT_PICK_LIST' is not an attribute of Pick_List_Consolidation_API enumiration.
      --  This is only for distinguish the selection for create shipment pick list.        
      IF (consolidate_ = 'CREATE_SHIPMENT_PICK_LIST') THEN  
         INSERT INTO create_consol_pick_list_tmp (location_group,   pick_inventory_type_db,    order_no,   line_no,  
                                                  rel_no,           line_item_no,              planned_due_date,
                                                  shipment_id,      addr_1,                    addr_2,     addr_3, 
                                                  addr_4,           addr_5,                    addr_6,     country_code,                              
                                                  customer_no,      route_id,                  planned_ship_period,
                                                  forward_agent_id, warehouse_id,              bay_id,     row_id, 
                                                  tier_id,          bin_id,                    contract,   part_no,
                                                  location_no,      lot_batch_no,              serial_no,  waiv_dev_rej_no,
                                                  eng_chg_level,    pick_list_no,
                                                  configuration_id, activity_seq,              parent_consol_shipment_id,
                                                  shipment_type,    ship_inventory_location_no, planned_ship_date, handling_unit_id)       
                     (SELECT  location_group,   pick_inventory_type_db,    order_no,    line_no,                               
                              rel_no,           line_item_no,              planned_due_date,
                              shipment_id,      addr_1,                    addr_2,     addr_3, 
                              addr_4,           addr_5,                    addr_6,     country_code,                              
                              receiver_id,                      route_id,   planned_ship_period,
                              forward_agent_id, warehouse_id,              bay_id,     row_id, 
                              tier_id,          bin_id,                    contract,   part_no,
                              location_no,      lot_batch_no,              serial_no,  waiv_dev_rej_no,
                              eng_chg_level,    pick_list_no,
                              configuration_id, activity_seq,              parent_consol_shipment_id,
                              shipment_type,    ship_inventory_location_no, planned_ship_date, handling_unit_id
                        FROM   create_pick_list_ship_join 
                        WHERE  pick_list_no  = '*'
                        AND    shipment_id   = shipment_ids_
                        AND    (Report_SYS.Parse_Parameter(location_group, location_group_) = 'TRUE' OR location_group_ IS NULL));         
         
      -- 'SHIPMENT_AT_PICK_LIST' is not an attribute of Pick_List_Consolidation_API enumiration.
      --  This is only for distinguish the selection for create shipment pick list.    
      ELSIF (consolidate_ = 'SHIPMENT_AT_PICK_LIST') THEN
         INSERT INTO create_consol_pick_list_tmp (location_group,    pick_inventory_type_db,    order_no,   line_no,  
                                                   rel_no,           line_item_no,              planned_due_date,
                                                   shipment_id,      addr_1,                    addr_2,     addr_3, 
                                                   addr_4,           addr_5,                    addr_6,     country_code,                              
                                                   customer_no,      route_id,                  planned_ship_period,
                                                   forward_agent_id, warehouse_id,              bay_id,     row_id, 
                                                   tier_id,          bin_id,                    contract,   part_no,
                                                   location_no,      lot_batch_no,              serial_no,  waiv_dev_rej_no,
                                                   eng_chg_level,    pick_list_no,
                                                   configuration_id, activity_seq,              handling_unit_id)
         
                      (SELECT  location_group,   Pick_Inventory_Type_API.DB_SHIPMENT_INVENTORY, order_no,   line_no,  
                               rel_no,           line_item_no,                                  planned_due_date,
                               shipment_id,      addr_1,                                        addr_2,     addr_3, 
                               addr_4,           addr_5,                                        addr_6,     country_code,                              
                               customer_no,      route_id,                                      planned_ship_period,
                               forward_agent_id, warehouse,                                     bay_no,     row_no, 
                               tier_no,          bin_no,                                        contract,   part_no,
                               location_no,      lot_batch_no,                                  serial_no,  waiv_dev_rej_no,
                               eng_chg_level,    pick_list_no,                    
                               configuration_id, activity_seq,                                  handling_unit_id
                         FROM create_pick_list_join_main cplj
                         WHERE contract  = contract_
                         AND   preliminary_pick_list_no IS NULL
                         AND   (CASE  WHEN selection_  = 'ALL_LINES' THEN
                                          (SELECT 1 FROM dual WHERE EXISTS ( SELECT 1
                                                                             FROM   create_pick_list_join_main cpljm
                                                                             WHERE  contract              = contract_
                                                                             AND    Report_SYS.Parse_Parameter(cpljm.order_no, order_no_)                 = 'TRUE'
                                                                             AND    Report_SYS.Parse_Parameter(cpljm.customer_no, customer_no_)           = 'TRUE'
                                                                             AND    Report_SYS.Parse_Parameter(cpljm.part_no, part_no_)                   = 'TRUE'
                                                                             AND    Report_SYS.Parse_Parameter(cpljm.ship_via_code, ship_via_code_)       = 'TRUE'
                                                                             AND    Report_SYS.Parse_Parameter(cpljm.coordinator, coordinator_)           = 'TRUE'
                                                                             AND    ((Report_SYS.Parse_Parameter(cpljm.order_type, order_type_)           = 'TRUE') OR (cpljm.order_type          IS NULL AND Decode(order_type_,    '%', NULL, order_type_)    IS NULL))
                                                                             AND    ((cpljm.priority =  co_priority_) OR (co_priority_ IS NULL))
                                                                             AND    ((Report_SYS.Parse_Parameter(cpljm.route_id, route_id_)               = 'TRUE') OR (cpljm.route_id             IS NULL AND DECODE(route_id_,      '%', NULL, route_id_)      IS NULL))
                                                                             AND    ((Report_SYS.Parse_Parameter(cpljm.planned_ship_period, ship_period_) = 'TRUE') OR (cpljm.planned_ship_period  IS NULL AND DECODE(ship_period_,   '%', NULL, ship_period_)   IS NULL))
                                                                             AND    ((Report_SYS.Parse_Parameter(cpljm.forward_agent_id, forward_agent_)  = 'TRUE') OR (cpljm.forward_agent_id     IS NULL AND DECODE(forward_agent_, '%', NULL, forward_agent_) IS NULL))
                                                                             AND    Report_SYS.Parse_Parameter(cpljm.location_group, location_group_)     = 'TRUE'
                                                                             AND    TRUNC(cpljm.planned_due_date) <= NVL(TRUNC(due_date_), TRUNC(cpljm.planned_due_date))
                                                                             AND    cpljm.pick_list_no    = '*'
                                                                             AND    cpljm.shipment_id     = 0
                                                                             AND    pick_list_no          = '*'
                                                                             AND    shipment_creation_db  = 'PICK_LIST_CREATION'
                                                                             AND    cpljm.order_no        = order_no
                                                                           )
                                          )
                                      WHEN selection_  IN ('WITHIN_SELECTION', 'COMPLETE_WITHIN_SELECTION') THEN
                                          (SELECT 1 FROM dual  WHERE shipment_creation_db    = 'PICK_LIST_CREATION'
                                                               AND   Report_SYS.Parse_Parameter(order_no, order_no_)                 = 'TRUE'
                                                               AND   Report_SYS.Parse_Parameter(customer_no, customer_no_)           = 'TRUE'
                                                               AND   Report_SYS.Parse_Parameter(part_no, part_no_)                   = 'TRUE'
                                                               AND   Report_SYS.Parse_Parameter(ship_via_code, ship_via_code_)       = 'TRUE'
                                                               AND   supply_code_db NOT IN ('PD','IPD','ND','SEO') 
                                                               AND   Report_SYS.Parse_Parameter(coordinator, coordinator_)           = 'TRUE'
                                                               AND   ((Report_SYS.Parse_Parameter(order_type, order_type_)           = 'TRUE') OR (order_type          IS NULL AND Decode(order_type_,    '%', NULL, order_type_)    IS NULL))
                                                               AND   ((priority = co_priority_) OR (co_priority_ IS NULL))
                                                               AND   ((Report_SYS.Parse_Parameter(route_id, route_id_)               = 'TRUE') OR (route_id             IS NULL AND DECODE(route_id_,      '%', NULL, route_id_)      IS NULL))
                                                               AND   ((Report_SYS.Parse_Parameter(planned_ship_period, ship_period_) = 'TRUE') OR (planned_ship_period  IS NULL AND DECODE(ship_period_,   '%', NULL, ship_period_)   IS NULL))
                                                               AND   ((Report_SYS.Parse_Parameter(forward_agent_id, forward_agent_)  = 'TRUE') OR (forward_agent_id     IS NULL AND DECODE(forward_agent_, '%', NULL, forward_agent_) IS NULL))
                                                               AND   Report_SYS.Parse_Parameter(location_group, location_group_)     = 'TRUE'
                                                               AND   TRUNC(planned_due_date) <= NVL(TRUNC(due_date_), TRUNC(planned_due_date))
                                                               AND   pick_list_no            = '*'
                                                               AND   shipment_id             = 0
                                          )
                                      ELSE 0
                                END ) = 1);
        
      -- For all other consolidation attributes in Pick_List_Consolidation_API enumiration.    
      ELSE
         IF (from_ship_consol_pl_) THEN
               INSERT INTO create_consol_pick_list_tmp (location_group,   pick_inventory_type_db,    order_no,   line_no,  
                                                        rel_no,           line_item_no,              planned_due_date,
                                                        shipment_id,      addr_1,                    addr_2,     addr_3, 
                                                        addr_4,           addr_5,                    addr_6,     country_code,                              
                                                        customer_no,      route_id,                  planned_ship_period,
                                                        forward_agent_id, warehouse_id,              bay_id,     row_id, 
                                                        tier_id,          bin_id,                    contract,   part_no,
                                                        location_no,      lot_batch_no,              serial_no,  waiv_dev_rej_no,
                                                        eng_chg_level,    pick_list_no,
                                                        configuration_id, activity_seq,              parent_consol_shipment_id,
                                                        shipment_type,    ship_inventory_location_no, planned_ship_date, handling_unit_id)       
                              (SELECT  location_group,   pick_inventory_type_db,    order_no,   line_no,  
                                       rel_no,           line_item_no,              planned_due_date,
                                       shipment_id,      addr_1,                    addr_2,     addr_3, 
                                       addr_4,           addr_5,                    addr_6,     country_code,                              
                                       receiver_id,                      route_id,   planned_ship_period,
                                       forward_agent_id, warehouse_id,              bay_id,     row_id, 
                                       tier_id,          bin_id,                    contract,   part_no,
                                       location_no,      lot_batch_no,              serial_no,  waiv_dev_rej_no,
                                       eng_chg_level,    pick_list_no,
                                       configuration_id, activity_seq,              parent_consol_shipment_id,
                                       shipment_type,    ship_inventory_location_no, planned_ship_date, handling_unit_id
                                 FROM create_pick_list_ship_join 
                                 WHERE contract            = contract_                          
                                 AND  (CASE  WHEN selection_  = 'ALL_LINES' THEN
                                                (SELECT 1 FROM dual WHERE EXISTS (SELECT  1
                                                                                  FROM    create_pick_list_ship_join cplsj
                                                                                  WHERE   cplsj.contract                = contract_
                                                                                  AND     (Report_SYS.Parse_Parameter(cplsj.shipment_id, shipment_ids_)         = 'TRUE')
                                                                                  AND     (Report_SYS.Parse_Parameter(cplsj.shipment_type, shipment_type_)      = 'TRUE')
                                                                                  AND     (Report_SYS.Parse_Parameter(cplsj.receiver_id, customer_no_)          = 'TRUE')
                                                                                  AND     (Report_SYS.Parse_Parameter(cplsj.ship_via_code, ship_via_code_)      = 'TRUE')
                                                                                  AND     ((Report_SYS.Parse_Parameter(cplsj.parent_consol_shipment_id, consolidate_shipment_id_) = 'TRUE') OR (cplsj.parent_consol_shipment_id IS NULL AND DECODE(consolidate_shipment_id_, '%', NULL, consolidate_shipment_id_) IS NULL))                           
                                                                                  AND     ((Report_SYS.Parse_Parameter(cplsj.route_id, route_id_)               = 'TRUE') OR (cplsj.route_id             IS NULL AND DECODE(route_id_,      '%', NULL, route_id_)      IS NULL))
                                                                                  AND     ((Report_SYS.Parse_Parameter(cplsj.planned_ship_period, ship_period_) = 'TRUE') OR (cplsj.planned_ship_period  IS NULL AND DECODE(ship_period_,   '%', NULL, ship_period_)   IS NULL))
                                                                                  AND     ((Report_SYS.Parse_Parameter(cplsj.forward_agent_id, forward_agent_)  = 'TRUE') OR (cplsj.forward_agent_id     IS NULL AND DECODE(forward_agent_, '%', NULL, forward_agent_) IS NULL))
                                                                                  AND     ((Report_SYS.Parse_Parameter(cplsj.ship_inventory_location_no, shipment_location_)      = 'TRUE') OR (cplsj.ship_inventory_location_no IS NULL AND Decode(shipment_location_,'%', NULL, shipment_location_)IS NULL))
                                                                                  AND     (Report_SYS.Parse_Parameter(cplsj.location_group, location_group_)    = 'TRUE')
                                                                                  AND     TRUNC(cplsj.planned_due_date) <= NVL(TRUNC(due_date_), TRUNC(cplsj.planned_due_date))
                                                                                  AND     (cplsj.planned_ship_date IS NULL OR TO_CHAR(cplsj.planned_ship_date, Report_SYS.datetime_format_) <= NVL(TO_CHAR(ship_date_, Report_SYS.datetime_format_), TO_CHAR(cplsj.planned_ship_date, Report_SYS.datetime_format_)))                                                     
                                                                                  AND     cplsj.shipment_id             != 0
                                                                                  AND     cplsj.shipment_id             = shipment_id
                                                                                  AND     pick_list_no                  = '*'
                                                                                 )
                                                )
                                             WHEN selection_  IN ('WITHIN_SELECTION', 'COMPLETE_WITHIN_SELECTION') THEN
                                                (SELECT 1 FROM dual  WHERE (Report_SYS.Parse_Parameter(shipment_id, shipment_ids_)         = 'TRUE')
                                                                     AND   (Report_SYS.Parse_Parameter(shipment_type, shipment_type_)      = 'TRUE')
                                                                     AND   (Report_SYS.Parse_Parameter(receiver_id, customer_no_)          = 'TRUE')                           
                                                                     AND   (Report_SYS.Parse_Parameter(ship_via_code, ship_via_code_)      = 'TRUE')                           
                                                                     AND   ((Report_SYS.Parse_Parameter(parent_consol_shipment_id, consolidate_shipment_id_) = 'TRUE') OR (parent_consol_shipment_id IS NULL AND DECODE(consolidate_shipment_id_, '%', NULL, consolidate_shipment_id_) IS NULL))                           
                                                                     AND   ((Report_SYS.Parse_Parameter(route_id, route_id_)               = 'TRUE') OR (route_id             IS NULL AND DECODE(route_id_,      '%', NULL, route_id_)      IS NULL))
                                                                     AND   ((Report_SYS.Parse_Parameter(planned_ship_period, ship_period_) = 'TRUE') OR (planned_ship_period  IS NULL AND DECODE(ship_period_,   '%', NULL, ship_period_)   IS NULL))
                                                                     AND   ((Report_SYS.Parse_Parameter(forward_agent_id, forward_agent_)  = 'TRUE') OR (forward_agent_id     IS NULL AND DECODE(forward_agent_, '%', NULL, forward_agent_) IS NULL))
                                                                     AND   ((Report_SYS.Parse_Parameter(ship_inventory_location_no, shipment_location_)      = 'TRUE') OR (ship_inventory_location_no IS NULL AND Decode(shipment_location_,'%', NULL, shipment_location_)IS NULL))
                                                                     AND   (Report_SYS.Parse_Parameter(location_group, location_group_)    = 'TRUE')
                                                                     AND   TRUNC(planned_due_date) <= NVL(TRUNC(due_date_), TRUNC(planned_due_date))
                                                                     AND   (planned_ship_date IS NULL OR TO_CHAR(planned_ship_date, Report_SYS.datetime_format_) <= NVL(TO_CHAR(ship_date_, Report_SYS.datetime_format_), TO_CHAR(planned_ship_date, Report_SYS.datetime_format_)))
                                                                     AND   pick_list_no            = '*'
                                                                     AND   shipment_id             != 0
                                                )
                                             ELSE 0
                                       END ) = 1);                      
            
            -- Credit check for customer orders connected to the shipment.
            FOR rec_ IN get_shipment_id LOOP
               IF NOT(Credit_Check_Ship_Pick_List___(rec_.shipment_id))THEN
                  DELETE FROM create_consol_pick_list_tmp
                  WHERE shipment_id = rec_.shipment_id;
               END IF;               
            END LOOP;
         ELSE
            INSERT INTO create_consol_pick_list_tmp (location_group,   pick_inventory_type_db,    order_no,   line_no,  
                                                     rel_no,           line_item_no,              planned_due_date,
                                                     shipment_id,      addr_1,                    addr_2,     addr_3, 
                                                     addr_4,           addr_5,                    addr_6,     country_code,                              
                                                     customer_no,      route_id,                  planned_ship_period,
                                                     forward_agent_id, warehouse_id,              bay_id,     row_id, 
                                                     tier_id,          bin_id,                    contract,   part_no,
                                                     location_no,      lot_batch_no,              serial_no,  waiv_dev_rej_no,
                                                     eng_chg_level,    pick_list_no,
                                                     configuration_id, activity_seq,              handling_unit_id)       
                        (SELECT  location_group,   pick_inventory_type_db,    order_no,   line_no,  
                                 rel_no,           line_item_no,              planned_due_date,
                                 shipment_id,      addr_1,                    addr_2,     addr_3, 
                                 addr_4,           addr_5,                    addr_6,     country_code,                              
                                 customer_no,      route_id,                  planned_ship_period,
                                 forward_agent_id, warehouse,                 bay_no,     row_no, 
                                 tier_no,          bin_no,                    contract,   part_no,
                                 location_no,      lot_batch_no,              serial_no,  waiv_dev_rej_no,
                                 eng_chg_level,    pick_list_no,
                                 configuration_id, activity_seq,              handling_unit_id
                           FROM create_pick_list_join_main cplj
                           WHERE contract  = contract_
                           AND   preliminary_pick_list_no IS NULL
                           AND   shipment_creation_db  != 'PICK_LIST_CREATION'
                           AND  (CASE  WHEN selection_  = 'ALL_LINES' THEN
                                             (SELECT 1 FROM dual WHERE EXISTS(SELECT   1
                                                                              FROM     create_pick_list_join_main cpljm
                                                                              WHERE    cpljm.contract                = contract_
                                                                              AND      Report_SYS.Parse_Parameter(cpljm.order_no, order_no_)                 = 'TRUE'
                                                                              AND      Report_SYS.Parse_Parameter(cpljm.customer_no, customer_no_)           = 'TRUE'
                                                                              AND      Report_SYS.Parse_Parameter(cpljm.part_no, part_no_)                   = 'TRUE'
                                                                              AND      Report_SYS.Parse_Parameter(cpljm.ship_via_code, ship_via_code_)       = 'TRUE'
                                                                              AND      Report_SYS.Parse_Parameter(cpljm.coordinator, coordinator_)           = 'TRUE'
                                                                              AND      ((Report_SYS.Parse_Parameter(cpljm.order_type, order_type_)           = 'TRUE') OR (cpljm.order_type          IS NULL AND Decode(order_type_,    '%', NULL, order_type_)    IS NULL))
                                                                              AND      ((cpljm.priority =  co_priority_) OR (co_priority_ IS NULL))
                                                                              AND      ((Report_SYS.Parse_Parameter(cpljm.route_id, route_id_)               = 'TRUE') OR (cpljm.route_id             IS NULL AND DECODE(route_id_,      '%', NULL, route_id_)      IS NULL))
                                                                              AND      ((Report_SYS.Parse_Parameter(cpljm.planned_ship_period, ship_period_) = 'TRUE') OR (cpljm.planned_ship_period  IS NULL AND DECODE(ship_period_,   '%', NULL, ship_period_)   IS NULL))
                                                                              AND      ((Report_SYS.Parse_Parameter(cpljm.forward_agent_id, forward_agent_)  = 'TRUE') OR (cpljm.forward_agent_id     IS NULL AND DECODE(forward_agent_, '%', NULL, forward_agent_) IS NULL))
                                                                              AND      Report_SYS.Parse_Parameter(cpljm.location_group, location_group_)     = 'TRUE'
                                                                              AND      TRUNC(cpljm.planned_due_date) <= NVL(TRUNC(due_date_), TRUNC(cpljm.planned_due_date))
                                                                              AND      cpljm.pick_list_no            = '*'
                                                                              AND      ((shipment_type_ IS NULL AND cpljm.shipment_creation_db  != 'PICK_LIST_CREATION' ) OR (shipment_type_ IS NOT NULL))
                                                                              AND      cpljm.shipment_id             = 0
                                                                              AND      cpljm.order_no                = order_no
                                                                              AND      pick_list_no                  = '*'
                                                                              AND      shipment_creation_db          != 'PICK_LIST_CREATION'
                                                                              )
                                             )
                                       WHEN selection_  IN ('WITHIN_SELECTION', 'COMPLETE_WITHIN_SELECTION') THEN
                                             (SELECT 1 FROM dual  WHERE Report_SYS.Parse_Parameter(order_no, order_no_)                 = 'TRUE'
                                                                  AND   Report_SYS.Parse_Parameter(customer_no, customer_no_)           = 'TRUE'
                                                                  AND   Report_SYS.Parse_Parameter(part_no, part_no_)                   = 'TRUE'
                                                                  AND   Report_SYS.Parse_Parameter(ship_via_code, ship_via_code_)       = 'TRUE'
                                                                  AND   Report_SYS.Parse_Parameter(coordinator, coordinator_)           = 'TRUE'
                                                                  AND   ((Report_SYS.Parse_Parameter(order_type, order_type_)           = 'TRUE') OR (order_type          IS NULL AND Decode(order_type_,    '%', NULL, order_type_)    IS NULL))
                                                                  AND   ((priority = co_priority_) OR (co_priority_ IS NULL))
                                                                  AND   ((Report_SYS.Parse_Parameter(route_id, route_id_)               = 'TRUE') OR (route_id             IS NULL AND DECODE(route_id_,      '%', NULL, route_id_)      IS NULL))
                                                                  AND   ((Report_SYS.Parse_Parameter(planned_ship_period, ship_period_) = 'TRUE') OR (planned_ship_period  IS NULL AND DECODE(ship_period_,   '%', NULL, ship_period_)   IS NULL))
                                                                  AND   ((Report_SYS.Parse_Parameter(forward_agent_id, forward_agent_)  = 'TRUE') OR (forward_agent_id     IS NULL AND DECODE(forward_agent_, '%', NULL, forward_agent_) IS NULL))
                                                                  AND   Report_SYS.Parse_Parameter(location_group, location_group_)     = 'TRUE'
                                                                  AND   TRUNC(planned_due_date) <= NVL(TRUNC(due_date_), TRUNC(planned_due_date))
                                                                  AND   pick_list_no            = '*'
                                                                  AND   shipment_id             = 0
                                             )
                                       ELSE 0
                                 END ) = 1);            
         END IF;
      END IF;      
   END IF;
   
   IF hu_to_be_picked_in_one_step_ THEN
      Remove_Mixed_HU_Res___();
   END IF;
   
END Fill_Temporary_Table___;

PROCEDURE Remove_Mixed_HU_Res___
IS
   reservations_tab_    INV_PART_STOCK_SNAPSHOT_API.Inv_Part_Stock_Tab ;
   inventory_event_id_   NUMBER;
  CURSOR get_reservations IS
      SELECT   temp.contract,
               temp.part_no,
               temp.configuration_id,
               temp.location_no,
               temp.lot_batch_no,
               temp.serial_no,
               temp.eng_chg_level,
               temp.waiv_dev_rej_no,
               temp.activity_seq,
               temp.handling_unit_id,
               co_res.qty_assigned 
      FROM create_consol_pick_list_tmp temp, customer_order_reservation_tab co_res
      WHERE temp.Order_No = co_res.Order_No AND
            temp.Line_No = co_res.Line_No AND
            temp.Rel_No = co_res.Rel_No AND
            temp.Line_Item_No = co_res.Line_Item_No AND
            temp.Contract = co_res.Contract AND
            temp.Part_No = co_res.Part_No AND
            temp.Location_No = co_res.Location_No AND
            temp.Lot_Batch_No = co_res.Lot_Batch_No AND
            temp.Serial_No = co_res.Serial_No AND
            temp.Eng_Chg_Level = co_res.Eng_Chg_Level AND
            temp.Waiv_Dev_Rej_No = co_res.Waiv_Dev_Rej_No AND
            temp.Activity_Seq = co_res.Activity_Seq AND
            temp.Handling_Unit_Id = co_res.Handling_Unit_Id AND
            temp.Configuration_Id = co_res.Configuration_Id AND
            temp.Pick_List_No = co_res.Pick_List_No AND
            temp.Shipment_Id = co_res.Shipment_Id;
BEGIN
   OPEN get_reservations;
   FETCH get_reservations BULK COLLECT INTO reservations_tab_;
   CLOSE get_reservations;
   
   inventory_event_id_ := Inventory_Event_Manager_API.Get_Next_Inventory_Event_Id;
   Handl_Unit_Snapshot_Util_API.Generate_Snapshot(inventory_event_id_, 'PICK_LIST', reservations_tab_, TRUE);
   
   DELETE FROM create_consol_pick_list_tmp 
   WHERE handling_unit_api.Get_Root_Handling_Unit_Id(handling_unit_id) NOT IN (
      SELECT DISTINCT top_hu
      FROM (SELECT handling_unit_api.Get_Root_Handling_Unit_Id(handling_unit_id) top_hu,
                   count(DISTINCT order_no || line_no || rel_no || line_item_no) OVER 
                     (PARTITION BY Handling_Unit_API.Get_Root_Handling_Unit_Id(handling_unit_id)) AS no_rows 
            FROM create_consol_pick_list_tmp
            WHERE Handling_Unit_API.Get_Root_Handling_Unit_Id(handling_unit_id) in (
                  SELECT handling_unit_id 
                  FROM handl_unit_stock_snapshot_pub 
                  WHERE source_ref1 = to_char(inventory_event_id_) 
                     AND source_ref_type_db = 'PICK_LIST'))
      WHERE no_rows = 1
      );
    
   Handl_Unit_Snapshot_Util_API.Delete_Snapshot(inventory_event_id_, 'PICK_LIST');
END Remove_Mixed_HU_Res___;

PROCEDURE Consol_Ship_Pick_List___ (
   pick_list_no_list_         IN OUT Pick_List_Table,
   warehouse_task_list_       IN OUT VARCHAR2,    
   consolidate_               IN     VARCHAR2,
   contract_                  IN     VARCHAR2,   
   due_date_                  IN     DATE,
   include_cust_orders_       IN     VARCHAR2,
   order_no_                  IN     VARCHAR2,
   customer_no_               IN     VARCHAR2,
   route_id_                  IN     VARCHAR2,
   ship_period_               IN     VARCHAR2,
   forward_agent_             IN     VARCHAR2,
   location_group_            IN     VARCHAR2,
   part_no_                   IN     VARCHAR2,
   ship_via_code_             IN     VARCHAR2,
   storage_zone_id_           IN     VARCHAR2,
   order_type_                IN     VARCHAR2,
   coordinator_               IN     VARCHAR2,
   co_priority_               IN     NUMBER,   
   max_shipment_on_pick_list_ IN     NUMBER,
   ignore_existing_shipment_  IN     VARCHAR2)
IS
   temp_storage_zone_id_    VARCHAR2(155);
   shipment_id_tab_         Shipment_API.Shipment_Id_Tab;
   has_invalid_order_lines_ BOOLEAN := FALSE;
   failed_order_no_list_      Order_No_Bool_Table;
   passed_order_no_list_      Order_No_Bool_Table;
   first_picklist_            BOOLEAN := TRUE;
   
   CURSOR get_order_no IS
      SELECT DISTINCT location_group, pick_inventory_type_db, order_no
      FROM create_consol_pick_list_tmp;

   CURSOR get_ship_addr IS
      SELECT DISTINCT location_group, pick_inventory_type_db, addr_1, addr_2, addr_3, addr_4, addr_5, addr_6, country_code
      FROM create_consol_pick_list_tmp;

   CURSOR get_customer_no IS
      SELECT DISTINCT location_group, pick_inventory_type_db, customer_no
      FROM create_consol_pick_list_tmp;

   CURSOR get_route_id IS
      SELECT DISTINCT location_group, pick_inventory_type_db, route_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_ship_period IS
      SELECT DISTINCT location_group, pick_inventory_type_db, planned_ship_period
      FROM create_consol_pick_list_tmp;
   
   CURSOR get_forward_agent IS
      SELECT DISTINCT location_group, pick_inventory_type_db, forward_agent_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_warehouse IS
      SELECT DISTINCT location_group, pick_inventory_type_db, warehouse_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_bay IS
      SELECT DISTINCT location_group, pick_inventory_type_db, warehouse_id, bay_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_row IS
      SELECT DISTINCT location_group, pick_inventory_type_db, warehouse_id, bay_id, row_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_tier IS
      SELECT DISTINCT location_group, pick_inventory_type_db, warehouse_id, bay_id, row_id, tier_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_bin IS
      SELECT DISTINCT location_group, pick_inventory_type_db, warehouse_id, bay_id, row_id, tier_id, bin_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_storage_zone_id IS
      SELECT DISTINCT location_group, pick_inventory_type_db, storage_zone_id
      FROM create_consol_pick_list_tmp c, storage_zone_detail_tab z       
      WHERE c.contract    = z.contract
      AND   Report_SYS.Parse_Parameter(z.storage_zone_id, storage_zone_id_) = 'TRUE';
BEGIN
   Fill_Temporary_Table___(contract_,              order_no_,               customer_no_,   part_no_,  ship_via_code_,  
                           coordinator_,           order_type_,             co_priority_,   route_id_, ship_period_,  
                           forward_agent_,         location_group_,         NULL,           due_date_,
                           include_cust_orders_,   'SHIPMENT_AT_PICK_LIST', NULL,           NULL,
                           NULL,                   NULL,                    NULL,           FALSE);

   IF consolidate_ != 'STORAGE ZONE' THEN
      temp_storage_zone_id_ := storage_zone_id_;
   END IF;

   IF consolidate_ = 'ORDER NO' THEN
      FOR consolidate_rec_ IN get_order_no LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,     warehouse_task_list_,   shipment_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              consolidate_rec_.order_no,        '%',          '%',              due_date_,
                              '%',                    '%',                                      consolidate_rec_.location_group,
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              consolidate_,           consolidate_rec_.pick_inventory_type_db,  order_no_,
                              customer_no_,           route_id_,                                ship_period_,
                              forward_agent_,         location_group_,                          part_no_,   
                              ship_via_code_,         include_cust_orders_,                     '999999',
                              'DUMMY',                order_type_,                              coordinator_,
                              co_priority_,           NULL,                                     storage_zone_id_,
                              temp_storage_zone_id_,  max_shipment_on_pick_list_,               NULL,      NULL,
                              NULL,                   NULL,                                     NULL,      NULL,
                              NULL,                   NULL,                                     FALSE,     ignore_existing_shipment_);
      END LOOP;
   END IF;

   IF consolidate_ = 'DELIVERY ADDRESS' THEN
      FOR consolidate_rec_ IN get_ship_addr LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,      warehouse_task_list_,  shipment_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                     '%',                   '%',              due_date_,
                              '%',                     '%',                                     consolidate_rec_.location_group,
                              '%',                     '%',                                     '%',
                              '%',                     '%',                                     consolidate_rec_.addr_1,
                              consolidate_rec_.addr_2, consolidate_rec_.addr_3,                 consolidate_rec_.addr_4,
                              consolidate_rec_.addr_5, consolidate_rec_.addr_6,                 consolidate_rec_.country_code,
                              consolidate_,            consolidate_rec_.pick_inventory_type_db, order_no_,
                              customer_no_,            route_id_,                               ship_period_,
                              forward_agent_,          location_group_,                         part_no_,
                              ship_via_code_,          include_cust_orders_,                    '999999',
                              'DUMMY',                 order_type_,                             coordinator_,
                              co_priority_,            NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,   max_shipment_on_pick_list_,              NULL,      NULL,
                              NULL,                    NULL,                                    NULL,      NULL,
                              NULL,                    NULL,                                    FALSE,     ignore_existing_shipment_);
      END LOOP;
   END IF;

   IF consolidate_ = 'CUSTOMER NO' THEN
      FOR consolidate_rec_ IN get_customer_no LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,           warehouse_task_list_,  shipment_id_tab_,  has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                          consolidate_rec_.customer_no,             '%',                      due_date_,
                              '%',                          '%',                                      consolidate_rec_.location_group,
                              '%',                          '%',                                      '%',
                              '%',                          '%',                                      '%',
                              '%',                          '%',                                      '%',
                              '%',                          '%',                                      '%',
                              consolidate_ ,                consolidate_rec_.pick_inventory_type_db,  order_no_,
                              customer_no_,                 route_id_,                                ship_period_,
                              forward_agent_,               location_group_,                          part_no_,
                              ship_via_code_,               include_cust_orders_,                     '999999',
                              'DUMMY',                      order_type_,                              coordinator_,
                              co_priority_,                 NULL,                                     storage_zone_id_,
                              temp_storage_zone_id_,        max_shipment_on_pick_list_,               NULL,      NULL,
                              NULL,                         NULL,                                     NULL,      NULL,
                              NULL,                         NULL,                                     FALSE,     ignore_existing_shipment_);
      END LOOP;
   END IF;

   IF consolidate_ = 'ROUTE ID' THEN
      FOR consolidate_rec_ IN get_route_id LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,     warehouse_task_list_,  shipment_id_tab_,  has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                    '%',                   consolidate_rec_.route_id,                   due_date_,
                              '%',                    '%',                                      consolidate_rec_.location_group,
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              consolidate_ ,          consolidate_rec_.pick_inventory_type_db,  order_no_,
                              customer_no_,           route_id_,                                ship_period_,
                              forward_agent_,         location_group_,                          part_no_,
                              ship_via_code_,         include_cust_orders_,                     '999999',
                              'DUMMY',                order_type_,                              coordinator_,
                              co_priority_,           NULL,                                     storage_zone_id_,
                              temp_storage_zone_id_,  max_shipment_on_pick_list_,               NULL,      NULL,
                              NULL,                   NULL,                                     NULL,      NULL,
                              NULL,                   NULL,                                     FALSE,     ignore_existing_shipment_);
      END LOOP;
   END IF;

   IF consolidate_ = 'PLANNED SHIP PERIOD' THEN
      FOR consolidate_rec_ IN get_ship_period LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,                   warehouse_task_list_,    shipment_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                                  '%',                     '%',              due_date_,
                              consolidate_rec_.planned_ship_period, '%',                                       consolidate_rec_.location_group,
                              '%',                                  '%',                                       '%',
                              '%',                                  '%',                                       '%',
                              '%',                                  '%',                                       '%',
                              '%',                                  '%',                                       '%',
                              consolidate_,                         consolidate_rec_.pick_inventory_type_db,   order_no_,
                              customer_no_,                         route_id_,                                 ship_period_,
                              forward_agent_,                       location_group_,                           part_no_,
                              ship_via_code_,                       include_cust_orders_,                      '999999',
                              'DUMMY',                        order_type_,                               coordinator_,
                              co_priority_,                         NULL,                                      storage_zone_id_,
                              temp_storage_zone_id_,                max_shipment_on_pick_list_,                NULL,      NULL,
                              NULL,                                 NULL,                                      NULL,      NULL,
                              NULL,                                 NULL,                                      FALSE,     ignore_existing_shipment_);
      END LOOP;
   END IF;

   IF consolidate_ = 'FORWARD AGENT' THEN
      FOR consolidate_rec_ IN get_forward_agent LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,     warehouse_task_list_,   shipment_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                    '%',                    '%',              due_date_,
                              '%',                    consolidate_rec_.forward_agent_id,        consolidate_rec_.location_group,
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              consolidate_,           consolidate_rec_.pick_inventory_type_db,  order_no_,
                              customer_no_,           route_id_,                                ship_period_,
                              forward_agent_,         location_group_,                          part_no_,
                              ship_via_code_,         include_cust_orders_,                     '999999',
                              'DUMMY',          order_type_,                              coordinator_,
                              co_priority_,           NULL,                                     storage_zone_id_,
                              temp_storage_zone_id_,  max_shipment_on_pick_list_,               NULL,      NULL,
                              NULL,                   NULL,                                     NULL,      NULL,
                              NULL,                   NULL,                                     FALSE,     ignore_existing_shipment_);
      END LOOP;
   END IF;

   IF consolidate_ = 'WAREHOUSE' THEN
      FOR consolidate_rec_ IN get_warehouse LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_,  shipment_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                             '%',                   '%',              due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   '%',                                     '%',
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     '%',
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, order_no_,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         part_no_,
                              ship_via_code_,                  include_cust_orders_,                    '999999',
                              'DUMMY',                         order_type_,                             coordinator_,
                              co_priority_,                    NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              NULL,      NULL,
                              NULL,                            NULL,                                    NULL,      NULL,
                              NULL,                            NULL,                                    FALSE,     ignore_existing_shipment_);
      END LOOP;
   END IF;

   IF consolidate_ = 'BAY' THEN
      FOR consolidate_rec_ IN get_bay LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_,  shipment_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                             '%',                   '%',              due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   consolidate_rec_.bay_id,                 '%',
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     '%',
                              consolidate_ ,                   consolidate_rec_.pick_inventory_type_db, order_no_,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         part_no_,
                              ship_via_code_,                  include_cust_orders_,                    '999999',
                              'DUMMY',                         order_type_,                             coordinator_,
                              co_priority_,                    NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              NULL,      NULL,
                              NULL,                            NULL,                                    NULL,      NULL,
                              NULL,                            NULL,                                    FALSE,     ignore_existing_shipment_);
      END LOOP;
   END IF;

   IF consolidate_ = 'ROW' THEN
      FOR consolidate_rec_ IN get_row LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_,    shipment_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                             '%',                     '%',              due_date_,
                              '%',                             '%',                                       consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   consolidate_rec_.bay_id,                   consolidate_rec_.row_id,
                              '%',                             '%',                                       '%',
                              '%',                             '%',                                       '%',
                              '%',                             '%',                                       '%',
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db,   order_no_,
                              customer_no_,                    route_id_,                                 ship_period_,
                              forward_agent_,                  location_group_,                           part_no_,
                              ship_via_code_,                  include_cust_orders_,                      '999999',
                              'DUMMY',                         order_type_,                               coordinator_,
                              co_priority_,                    NULL,                                      storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,                NULL,      NULL,
                              NULL,                            NULL,                                      NULL,      NULL,
                              NULL,                            NULL,                                      FALSE,     ignore_existing_shipment_);
      END LOOP;
   END IF;

   IF consolidate_ = 'TIER' THEN
      FOR consolidate_rec_ IN get_tier LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_,    shipment_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                             '%',                     '%',              due_date_,
                              '%',                             '%',                                       consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   consolidate_rec_.bay_id,                   consolidate_rec_.row_id,
                              consolidate_rec_.tier_id,        '%',                                       '%',
                              '%',                             '%',                                       '%',
                              '%',                             '%',                                       '%',
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db,   order_no_,
                              customer_no_,                    route_id_,                                 ship_period_,
                              forward_agent_,                  location_group_,                           part_no_,
                              ship_via_code_,                  include_cust_orders_,                      '999999',
                              'DUMMY',                         order_type_,                               coordinator_,
                              co_priority_,                    NULL,                                      storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,                NULL,      NULL,
                              NULL,                            NULL,                                      NULL,      NULL,
                              NULL,                            NULL,                                      FALSE,     ignore_existing_shipment_);
      END LOOP;
   END IF;

   IF consolidate_ = 'BIN' THEN
      FOR consolidate_rec_ IN get_bin LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_,  shipment_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                             '%',                   '%',              due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   consolidate_rec_.bay_id,                 consolidate_rec_.row_id,
                              consolidate_rec_.tier_id,        consolidate_rec_.bin_id,                 '%',
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     '%',
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, order_no_,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         part_no_,
                              ship_via_code_,                  include_cust_orders_,                    '999999',
                              'DUMMY',                         order_type_,                             coordinator_,
                              co_priority_,                    NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              NULL,      NULL,
                              NULL,                            NULL,                                    NULL,      NULL,
                              NULL,                            NULL,                                    FALSE,     ignore_existing_shipment_);
      END LOOP;
   END IF;

   IF consolidate_ = 'STORAGE ZONE' THEN
      FOR consolidate_rec_ IN get_storage_zone_id LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,         warehouse_task_list_,  shipment_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                        '%',                   '%',              due_date_,
                              '%',                        '%',                                     consolidate_rec_.location_group,
                              '%',                        '%',                                     '%',
                              '%',                        '%',                                     '%',
                              '%',                        '%',                                     '%',
                              '%',                        '%',                                     '%',
                              consolidate_,               consolidate_rec_.pick_inventory_type_db, order_no_,
                              customer_no_,               route_id_,                               ship_period_,
                              forward_agent_,             location_group_,                         part_no_,
                              ship_via_code_,             include_cust_orders_,                    '999999',
                              'DUMMY',                    order_type_,                             coordinator_,
                              co_priority_,               NULL,                                    consolidate_rec_.storage_zone_id,
                              storage_zone_id_,           max_shipment_on_pick_list_,              NULL,      NULL,
                              NULL,                       NULL,                                    NULL,      NULL,
                              NULL,                       NULL,                                    FALSE,     ignore_existing_shipment_);
      END LOOP;
   END IF;      
END Consol_Ship_Pick_List___;


-- Start_Print_Ship_Consol_Pl__
--   This method starts printing of the shipment consolidated pick lists.
PROCEDURE Start_Print_Ship_Consol_Pl___ (
   attr_ IN OUT VARCHAR2 )
IS
   description_  VARCHAR2(200);
BEGIN
   Trace_SYS.Field('attr_', attr_);
   description_ := Language_SYS.Translate_Constant(lu_name_, 'PRINTSHIPCONSPL: Print Shipment Consolidated Pick List');
   Transaction_SYS.Deferred_Call('Create_Pick_List_API.Print_Ship_Consol_Pick_List__', attr_, description_);
END Start_Print_Ship_Consol_Pl___;


PROCEDURE Print_Ship_Consol_Pl___ (
   pick_list_no_ IN VARCHAR2 )
IS
   printer_id_         VARCHAR2(100);
   attr_               VARCHAR2(200);
   report_attr_        VARCHAR2(2000);
   parameter_attr_     VARCHAR2(2000);
   result_key_         NUMBER;
   print_job_id_       NUMBER;
   printer_id_list_    VARCHAR2(32000);
   msg_                VARCHAR2(200);
   order_no_           VARCHAR2(12);
   result_key_app_     NUMBER;
   work_order_no_      NUMBER;
   purchase_order_no_  VARCHAR2(12);   
   nopart_lines_exist_ NUMBER; 
   report_id_          VARCHAR2(30);
   print_pick_report_db_         site_discom_info_tab.print_pick_report%TYPE;   
   customer_order_pick_list_rec_ Customer_Order_Pick_List_API.Public_Rec;
   
   CURSOR line_details IS
      SELECT DISTINCT line_no, rel_no, line_item_no
      FROM create_pick_list_join_new
      WHERE order_no     = order_no_
      AND   pick_list_no = pick_list_no_;

   CURSOR get_mro_lines IS
      SELECT col.demand_order_ref1
      FROM customer_order_line_tab col, create_pick_list_join_new cpl
      WHERE cpl.order_no     = order_no_
      AND   col.order_no     = cpl.order_no
      AND   col.line_no      = cpl.line_no
      AND   col.rel_no       = cpl.rel_no
      AND   col.line_item_no = cpl.line_item_no
      AND   col.supply_code  = 'MRO';

  CURSOR get_con_orders IS
      SELECT order_no
      FROM consolidated_orders_tab
      WHERE pick_list_no = pick_list_no_;
BEGIN
   customer_order_pick_list_rec_ :=  Customer_Order_Pick_List_API.Get(pick_list_no_);
   order_no_   := customer_order_pick_list_rec_.order_no;
   print_pick_report_db_   := Site_Discom_Info_API.Get_Print_Pick_Report_Db(customer_order_pick_list_rec_.contract);   

   IF print_pick_report_db_ IN (Invent_Report_Print_Option_API.DB_NONE) THEN 
      Error_SYS.Record_General(lu_name_, 'PRINTPICKLISTNOTALLOWED: Printing pick report is not allowed for the site :P1.', customer_order_pick_list_rec_.contract);
   END IF;   

   IF print_pick_report_db_ IN (Invent_Report_Print_Option_API.DB_DETAILED, Invent_Report_Print_Option_API.DB_BOTH) THEN     
      -- Generate a new print job id
      report_id_ := 'SHIPMENT_CONSOL_PICK_LIST_REP';
      printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, report_id_);
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, attr_);
      Print_Job_API.New(print_job_id_, attr_);
      
      -- Create the Consolidated report
      Client_SYS.Clear_Attr(report_attr_);
      Client_SYS.Add_To_Attr('REPORT_ID', report_id_, report_attr_); 
      Client_SYS.Clear_Attr(parameter_attr_);
      Client_SYS.Add_To_Attr('PICK_LIST_NO', pick_list_no_, parameter_attr_);
      Archive_API.New_Instance(result_key_, report_attr_, parameter_attr_);

      -- Connect the created report to a print job id
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, attr_);
      Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, attr_);
      Print_Job_Contents_API.New_Instance(attr_);      
   END IF;  
   
   IF print_pick_report_db_ IN (Invent_Report_Print_Option_API.DB_AGGREGATED, Invent_Report_Print_Option_API.DB_BOTH) THEN
      -- Create the report Handling Unit Pick List 
      Client_SYS.Clear_Attr(report_attr_);
      report_id_ := 'HANDLING_UNIT_PICK_LIST_REP';      
      Client_SYS.Add_To_Attr('REPORT_ID', report_id_, report_attr_);
      Client_SYS.Clear_Attr(parameter_attr_);
      Client_SYS.Add_To_Attr('PICK_LIST_NO', pick_list_no_, parameter_attr_);
      Archive_API.New_Instance(result_key_, report_attr_, parameter_attr_);
      
      IF print_job_id_ IS NULL THEN
         Client_SYS.Clear_Attr(attr_);
         printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, report_id_);
         Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, attr_);
         Print_Job_API.New(print_job_id_, attr_);    
         Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, attr_);
         Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, attr_);
      ELSE
         Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, attr_);
         Client_SYS.Set_Item_Value('RESULT_KEY', result_key_, attr_);
      END IF;
      Print_Job_Contents_API.New_Instance(attr_); 
   END IF;
   
   $IF (Component_Wo_SYS.INSTALLED AND Component_Purch_SYS.INSTALLED) $THEN
      -- Note: Get MRO order lines for Miscellaneous Part Report.
      FOR mro_line_ IN get_mro_lines LOOP
         work_order_no_      := TO_NUMBER(mro_line_.demand_order_ref1);      
         purchase_order_no_  := Active_Work_Order_API.Get_Receive_Order_No(work_order_no_);
         nopart_lines_exist_ := Purchase_Order_API.Check_Nopart_Lines_Exist(purchase_order_no_);

         IF nopart_lines_exist_ != 0 THEN
            -- Note: Create the Pick_List Appendix report
            Client_SYS.Clear_Attr(report_attr_);
            Client_SYS.Add_To_Attr('REPORT_ID', 'PURCH_MISCELLANEOUS_PART_REP', report_attr_);
            Client_SYS.Clear_Attr(parameter_attr_);
            Client_SYS.Add_To_Attr('ORDER_NO', purchase_order_no_, parameter_attr_);
            Client_SYS.Add_To_Attr('REPORT_TYPE', 'PICK LIST', parameter_attr_);
            Archive_API.New_Instance(result_key_app_, report_attr_, parameter_attr_);

            -- Note: Connect the Pick_List Appendix report to the same print job id
            Client_SYS.Set_Item_Value('RESULT_KEY', result_key_app_, attr_);
            Print_Job_Contents_API.New_Instance(attr_);
         END IF;           
      END LOOP;
   $END 

   -- Send the print job to the printer.
   Logical_Printer_API.Enumerate_Printer_Id(printer_id_list_);
   IF (printer_id_list_ IS NOT NULL) THEN
      IF (print_job_id_ IS NOT NULL) THEN
         Print_Job_API.Print(print_job_id_);
      END IF;
   END IF;

   -- Add a new record in customer order(s) history.    
   msg_ := Language_SYS.Translate_Constant(lu_name_, 'PICKPRINT: Picklist :P1 printed', NULL, pick_list_no_);
   FOR ord_ IN get_con_orders LOOP
      Customer_Order_History_API.New(ord_.order_no, msg_);
      order_no_ := ord_.order_no;
      FOR linerec_ IN line_details LOOP
          --Add a new record in Customer Order Line History
          Customer_Order_Line_Hist_API.New(order_no_,linerec_.line_no,linerec_.rel_no,linerec_.line_item_no,msg_);
      END LOOP;
   END LOOP;
END Print_Ship_Consol_Pl___;

-- Create_or_Update_Wh_Task___
--   Creates new Warehouse Task with passed values, if the pick_list_no_ not found in pick_list_no_list_ 
PROCEDURE Create_or_Update_Wh_Task___(
   task_id_           OUT NUMBER,
   pick_list_no_list_ IN OUT Pick_List_Table,
   priority_          IN NUMBER,
   pick_list_no_      IN NUMBER,
   no_of_lines_       IN NUMBER,
   location_group_    IN VARCHAR2,
   contract_          IN VARCHAR2,
   min_ship_date_     IN DATE,
   msg_               IN VARCHAR2,
   worker_id_         IN VARCHAR2)
IS
   temp_task_id_        NUMBER;
   line_count_          NUMBER;
   new_pick_list_       BOOLEAN := TRUE;
   warehouse_task_type_ VARCHAR2(2000) := Warehouse_Task_Type_API.Decode('CUSTOMER ORDER PICK LIST');  
BEGIN                
   IF (pick_list_no_list_.COUNT > 0) THEN 
      FOR i_ IN pick_list_no_list_.FIRST..pick_list_no_list_.LAST LOOP
         IF (pick_list_no_list_(i_) = pick_list_no_) THEN
            new_pick_list_ := FALSE;
            EXIT;
         END IF;
      END LOOP;
   END IF;

   IF (new_pick_list_) THEN
      pick_list_no_list_(pick_list_no_list_.COUNT + 1) := pick_list_no_;
      -- Create new warehouse task
      Warehouse_Task_API.New(task_id_,  warehouse_task_type_,
                             priority_, pick_list_no_, NULL, NULL, NULL,
                             no_of_lines_, location_group_, contract_, min_ship_date_, msg_, worker_id_);
   ELSE
      temp_task_id_  := Warehouse_Task_API.Get_Task_Id_From_Source(contract_, warehouse_task_type_, pick_list_no_, NULL, NULL, NULL);
      IF (temp_task_id_ IS NOT NULL) THEN
         line_count_    := Warehouse_Task_API.Get_Number_Of_Lines(temp_task_id_) + no_of_lines_;
         Warehouse_Task_API.Modify_Number_Of_Lines(temp_task_id_, line_count_);
      END IF;   
   END IF;
END Create_or_Update_Wh_Task___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Pick_List__
--   Create new pick lists for an order together with one warehouse task per
--   pick list.
--   Return a separated list of the created pick list no's as an Pick_List_Table
--   object in the parameter pick_list_no_list_.
PROCEDURE Create_Pick_List__ (
   pick_list_no_list_ IN OUT Pick_List_Table,
   order_no_          IN     VARCHAR2 )
IS
   order_rec_              Customer_Order_API.Public_Rec;   
   pick_list_no_           VARCHAR2(15);
   pick_list_created_      BOOLEAN;
   msg_                    VARCHAR2(200);
   line_no_                VARCHAR2(4);
   rel_no_                 VARCHAR2(4);
   line_item_no_           NUMBER;
   task_id_                NUMBER;
   priority_               NUMBER := NULL;
   number_lines_           NUMBER;
   planned_ship_date_      DATE;
   min_ship_date_          DATE;
   pick_inventory_type_    VARCHAR2(7);
   company_                VARCHAR2(20);
   validfrom_              DATE;
   validuntil_             DATE;
   salepart_tax_code_      VARCHAR2(20);
   create_date_            DATE;
   backorder_check_passed_ BOOLEAN := FALSE;
   row_count_              NUMBER := 0;

   CURSOR get_location_group IS
      SELECT DISTINCT Inventory_Location_API.Get_Location_Group(contract, location_no) location_group,
             contract
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  pick_list_no = '*'
      AND    order_no     = order_no_
      AND    shipment_id  = 0 ;

   CURSOR get_ship_addr IS
      SELECT DISTINCT location_group, addr_1, address1, address2, address3, address4, address5, address6,
             DECODE(addr_flag_db, 'Y', NULL, ship_addr_no) non_single_ship_addr_no, addr_flag_db, country_code,
             route_id, forward_agent_id, ship_via_code, delivery_terms
      FROM   create_pick_list_join_main
      WHERE  pick_list_no   = '*'
      AND    order_no       = order_no_
      AND    shipment_id  = 0;

   CURSOR get_group(location_group_ IN VARCHAR2) IS
      SELECT contract,         part_no,       location_no,
             lot_batch_no,     serial_no,     waiv_dev_rej_no,
             eng_chg_level,    pick_list_no,
             order_no,         line_no,       rel_no,
             line_item_no,     addr_1,        address1,       address2,         
             address3,         address4,      address5,       address6, 
             ship_addr_no,     addr_flag_db,  country_code,   route_id,
             forward_agent_id, ship_via_code, delivery_terms,
             configuration_id, activity_seq, shipment_id,
             handling_unit_id
      FROM   create_pick_list_join_main pl
      WHERE  location_group = location_group_
      AND    pick_list_no = '*'
      AND    order_no     = order_no_
      AND    shipment_id  = 0
      AND NOT EXISTS (SELECT 1
                      FROM customer_order_line_tab col
                      WHERE col.order_no         = pl.order_no
                      AND col.line_no            = pl.line_no
                      AND col.rel_no             = pl.rel_no
                      AND col.line_item_no       = pl.line_item_no
                      AND (col.shipment_connected = 'TRUE' AND col.shipment_creation != 'PICK_LIST_CREATION'))
      ORDER BY order_no, to_number(line_no), to_number(rel_no), line_item_no;

   CURSOR select_package_reservations IS
      SELECT DISTINCT order_no, line_no, rel_no
      FROM   customer_order_reservation_tab
      WHERE  pick_list_no = pick_list_no_
      AND    line_item_no > 0;

   whole_pkgs_reserved_       NUMBER := 0;
   excess_reservations_exist_ BOOLEAN;
   old_line_no_               VARCHAR2(4);
   old_rel_no_                VARCHAR2(4);
   catalog_no_                VARCHAR2(25);
   allow_partial_pkg_deliv_   VARCHAR2(5) := 'TRUE';
   all_license_connected_     VARCHAR2(10):= 'TRUE';
   raise_message_             VARCHAR2(5) := 'FALSE';
BEGIN
   pick_list_no_list_.DELETE;

   order_rec_ := Customer_Order_API.Get(order_no_);
      --  Check if a backorder would be generated
   IF (order_rec_.backorder_option = 'NO PARTIAL DELIVERIES ALLOWED') THEN
      IF Check_Order_For_Backorder__(order_no_) THEN
         Error_SYS.Record_General(lu_name_, 'NOBACKORDER: WARNING! Partial deliveries not allowed for order :P1.',order_no_);
      ELSE
         backorder_check_passed_ := TRUE;
      END IF;
   END IF;
   
   IF (Credit_Check_Order___(order_no_)) THEN
      Inventory_Event_Manager_API.Start_Session;
      FOR grouprec_ IN get_location_group LOOP
         Trace_SYS.Field('Found LOCATION_GROUP', grouprec_.location_group);
         number_lines_ := 0;
         line_no_      := '*';
         rel_no_       := '*';
         line_item_no_ := -2;

         -- Create pick list per delivery address
         FOR consolidate_rec_ IN get_ship_addr LOOP
            pick_list_created_ := FALSE;
            FOR ordrec_ IN get_group(grouprec_.location_group) LOOP
               
               -- Export control check.
               Check_All_License_Connected___(all_license_connected_, raise_message_ , 
                                              order_no_, ordrec_.line_no, 
                                              ordrec_.rel_no, ordrec_.line_item_no);
               IF (all_license_connected_ = 'TRUE') THEN
                  -- Check if the address is the same as the previous one
                  IF (((ordrec_.addr_flag_db = 'N' AND ordrec_.ship_addr_no = consolidate_rec_.non_single_ship_addr_no ) OR 
                     (ordrec_.addr_flag_db = 'Y' 
                      AND NVL(ordrec_.addr_1, Database_SYS.string_null_)   = NVL(consolidate_rec_.addr_1, Database_SYS.string_null_)
                      AND NVL(ordrec_.address1, Database_SYS.string_null_) = NVL(consolidate_rec_.address1, Database_SYS.string_null_)
                      AND NVL(ordrec_.address2, Database_SYS.string_null_) = NVL(consolidate_rec_.address2, Database_SYS.string_null_)
                      AND NVL(ordrec_.address3, Database_SYS.string_null_) = NVL(consolidate_rec_.address3, Database_SYS.string_null_)
                      AND NVL(ordrec_.address4, Database_SYS.string_null_) = NVL(consolidate_rec_.address4, Database_SYS.string_null_)
                      AND NVL(ordrec_.address5, Database_SYS.string_null_) = NVL(consolidate_rec_.address5, Database_SYS.string_null_)
                      AND NVL(ordrec_.address6, Database_SYS.string_null_) = NVL(consolidate_rec_.address6, Database_SYS.string_null_)
                      AND NVL(ordrec_.country_code,'q') = NVL(consolidate_rec_.country_code,'q')))
                      AND NVL(ordrec_.route_id,'q') = NVL(consolidate_rec_.route_id,'q')
                      AND NVL(ordrec_.forward_agent_id,'q') = NVL(consolidate_rec_.forward_agent_id,'q')
                      AND NVL(ordrec_.ship_via_code,'q') = NVL(consolidate_rec_.ship_via_code,'q')
                      AND NVL(ordrec_.delivery_terms,'q') = NVL(consolidate_rec_.delivery_terms,'q'))  THEN

                     -- Update order reservation status
                     IF ((ordrec_.line_item_no = 0 AND ((ordrec_.line_no != line_no_) OR (ordrec_.rel_no != rel_no_)))
                         OR ((ordrec_.line_item_no > 0) AND ((ordrec_.line_no != line_no_) OR (ordrec_.rel_no != rel_no_)))) THEN
                        IF (order_rec_.backorder_option != 'NO PARTIAL DELIVERIES ALLOWED') THEN
                           backorder_check_passed_ := Line_Backorder_Check_Passed__(ordrec_.order_no, ordrec_.line_no, ordrec_.rel_no,
                                                                                    ordrec_.line_item_no, order_rec_.backorder_option,
                                                                                    grouprec_.location_group, pick_list_no_ );
                        END IF;
                     END IF;

                     IF (backorder_check_passed_) THEN
                        IF NOT pick_list_created_ THEN
                           -- Create a new pick list object
                           -- Can check directly against the header, as the first condition in Customer_Order_Line_API would always evaluate false and fetch the header value.
                           IF Customer_Order_API.Uses_Shipment_Inventory(order_no_) = 1 THEN
                              pick_inventory_type_ := 'SHIPINV';
                           ELSE
                              pick_inventory_type_ := 'ORDINV';
                           END IF;
                           create_date_       := Site_API.Get_Site_Date(ordrec_.contract);
                           pick_list_no_      := Customer_Order_Pick_List_API.New(ordrec_.order_no, pick_inventory_type_, NULL, create_date_);
                           Customer_Order_Pick_List_API.Modify_Default_Ship_Location(pick_list_no_);
                           Trace_SYS.Field('New PICK_LIST_NO', pick_list_no_);
                           pick_list_created_ := TRUE;
                        END IF;
                        number_lines_ := number_lines_ + 1;

                        Customer_Order_Reservation_API.Modify_Pick_List_No(order_no_            => ordrec_.order_no,         
                                                                           line_no_             => ordrec_.line_no,
                                                                           rel_no_              => ordrec_.rel_no,           
                                                                           line_item_no_        => ordrec_.line_item_no,
                                                                           contract_            => ordrec_.contract,         
                                                                           part_no_             => ordrec_.part_no,
                                                                           location_no_         => ordrec_.location_no,      
                                                                           lot_batch_no_        => ordrec_.lot_batch_no,
                                                                           serial_no_           => ordrec_.serial_no,        
                                                                           eng_chg_level_       => ordrec_.eng_chg_level,
                                                                           waiv_dev_rej_no_     => ordrec_.waiv_dev_rej_no,  
                                                                           activity_seq_        => ordrec_.activity_seq,
                                                                           handling_unit_id_    => ordrec_.handling_unit_id,
                                                                           pick_list_no_        => ordrec_.pick_list_no,
                                                                           configuration_id_    => ordrec_.configuration_id, 
                                                                           shipment_id_         => ordrec_.shipment_id, 
                                                                           new_pick_list_no_    => pick_list_no_);

                        IF ((ordrec_.line_no != line_no_) OR (ordrec_.rel_no != rel_no_) OR (ordrec_.line_item_no != line_item_no_)) THEN
                           -- Add order line history
                           msg_ := Language_SYS.Translate_Constant(lu_name_, 'PICKCRE: Picklist :P1 created', NULL, pick_list_no_);
                           Customer_Order_Line_Hist_API.New(ordrec_.order_no, ordrec_.line_no, ordrec_.rel_no, ordrec_.line_item_no, msg_);
                           -- Find the earliest ship date/time, used when creating warehouse task.
                           planned_ship_date_ := Customer_Order_Line_API.Get_Planned_Ship_Date(order_no_, ordrec_.line_no,
                                                                                               ordrec_.rel_no, ordrec_.line_item_no);
                           IF ((min_ship_date_ IS NULL) OR (planned_ship_date_ < min_ship_date_)) THEN
                              min_ship_date_ := planned_ship_date_;
                           END IF;
                        END IF;
                     ELSE
                        IF ((ordrec_.line_no != line_no_) OR (ordrec_.rel_no != rel_no_)) THEN
                           Handle_Backorder_Info___(ordrec_.order_no,
                                                    ordrec_.line_no,
                                                    ordrec_.rel_no,
                                                    order_rec_.backorder_option);
                        END IF;
                     END IF;
                     IF ((ordrec_.line_no != line_no_) OR (ordrec_.rel_no != rel_no_) OR (ordrec_.line_item_no != line_item_no_)) THEN
                        line_no_      := ordrec_.line_no;
                        rel_no_       := ordrec_.rel_no;
                        line_item_no_ := ordrec_.line_item_no;
                     END IF;
                  END IF;
                  company_           := Site_API.Get_Company(ordrec_.contract);
                  salepart_tax_code_ := Customer_Order_Line_API.Get_Tax_Code(ordrec_.order_no, ordrec_.line_no,ordrec_.rel_no, ordrec_.line_item_no);
                  IF (salepart_tax_code_ IS NOT NULL) THEN
                  validuntil_ := statutory_fee_API.Get_Valid_Until(company_,salepart_tax_code_);
                  validfrom_  := statutory_fee_API.Get_Valid_From(company_,salepart_tax_code_);
                     IF NOT (trunc(sysdate) BETWEEN validfrom_ AND validuntil_) THEN
                        Error_SYS.Record_General(lu_name_, 'NOTAXVALID: Tax Code period is invalid');
                     END IF;
                  END IF;
               END IF;
                  
            END LOOP;
            
            IF pick_list_created_ THEN
               -- Create new warehouse task
               task_id_ := NULL;
               msg_     := Language_SYS.Translate_Constant(lu_name_, 'TASK_INFO: Customer No: :P1 * Order No: :P2 *',
                                                           NULL, order_rec_.customer_no, order_no_);
               Warehouse_Task_API.New(task_id_, Warehouse_Task_Type_API.Decode('CUSTOMER ORDER PICK LIST'),
                                      priority_, pick_list_no_, NULL, NULL, NULL,
                                      number_lines_, grouprec_.location_group,
                                      grouprec_.contract, min_ship_date_, msg_, NULL);
               -- Add order history
               Trace_SYS.Message('Creating order history for pick list.');
               msg_ := Language_SYS.Translate_Constant(lu_name_, 'PICKCRE: Picklist :P1 created', NULL, pick_list_no_);
               Customer_Order_History_API.New(order_no_, msg_);
               Cust_Order_Event_Creation_API.Pick_List_Created(order_no_);
               -- Add pick list to list
               row_count_                     := row_count_ + 1;
               pick_list_no_list_(row_count_) := pick_list_no_;
            END IF;
              
         END LOOP;
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;

   IF (order_rec_.backorder_option IN ('INCOMPLETE PACKAGES NOT ALLOWED', 'ALLOW INCOMPLETE LINES AND PACKAGES')) THEN
      -- When processing package components, even if the backorder check was passed there could be to
      -- many reservations for some components in the package

      FOR select_package_reservations_ IN select_package_reservations LOOP
         IF (select_package_reservations_.line_no != NVL(old_line_no_, '*') OR
             select_package_reservations_.rel_no != NVL(old_rel_no_, '*')) THEN

            catalog_no_ := Customer_Order_Line_API.Get_Catalog_No(select_package_reservations_.order_no,
                                                                  select_package_reservations_.line_no,
                                                                  select_package_reservations_.rel_no,
                                                                  -1);
            allow_partial_pkg_deliv_ := Sales_Part_API.Get_Allow_Partial_Pkg_Deliv_Db(order_rec_.contract,
                                                                                      catalog_no_);
            
            IF (order_rec_.backorder_option = 'INCOMPLETE PACKAGES NOT ALLOWED' OR 
               (order_rec_.backorder_option = 'ALLOW INCOMPLETE LINES AND PACKAGES' AND allow_partial_pkg_deliv_ = 'FALSE')) THEN


               Reserve_Customer_Order_API.Check_Package_Reservations(whole_pkgs_reserved_,
                                                                      excess_reservations_exist_,
                                                                      select_package_reservations_.order_no,
                                                                      select_package_reservations_.line_no,
                                                                      select_package_reservations_.rel_no);
               IF excess_reservations_exist_ THEN
                  Reserve_Customer_Order_API.Split_Package_Reservations(select_package_reservations_.order_no,
                                                                        select_package_reservations_.line_no,
                                                                        select_package_reservations_.rel_no,
                                                                        whole_pkgs_reserved_);
               
               END IF;
               old_line_no_ := select_package_reservations_.line_no;
               old_rel_no_  := select_package_reservations_.rel_no;
            END IF;
         END IF;
      END LOOP;
   END IF;
   -- This was added to stop creating any empty pick list.
   IF (pick_list_created_) THEN
      IF (Customer_Order_Reservation_API.Is_Pick_List_Connected(pick_list_no_) = 0)THEN
         Error_SYS.Record_General(lu_name_, 'NOPICKLIST: Pick list cannot be created.');
      END IF;
   END IF;
END Create_Pick_List__;


-- Create_Consol_Pick_List__
--   This method internally calls to the Create_Consol_Pick_List_Impl__ in order
--   to proceed with the create consolidated pick list process.
PROCEDURE Create_Consol_Pick_List__ (
   message_ IN OUT VARCHAR2 )
IS
   description_ VARCHAR2(200);
BEGIN
   IF (Transaction_Sys.Is_Session_Deferred()) THEN
      -- if we are already inside a background job don't create a new one, which will happened if this was a scheduled job
      Create_Consol_Pick_List_Impl__(message_);
   ELSE
      description_ := Language_SYS.Translate_Constant(lu_name_, 'CREATE_CONSOLIDATED: Create Consolidated Pick List');
      Transaction_SYS.Deferred_Call('CREATE_PICK_LIST_API.Create_Consol_Pick_List_Impl__', message_, description_);
   END IF;
END Create_Consol_Pick_List__;


-- Create_Consol_Pick_List_Impl__
--   Finds out if there will be several pick lists created
--   depending of the choice of consolidation and if several location groups are used.
PROCEDURE Create_Consol_Pick_List_Impl__ (
   message_ IN VARCHAR2 )
IS
   count_                              NUMBER;
   name_arr_                           Message_SYS.name_table;
   value_arr_                          Message_SYS.line_table;

   contract_                           VARCHAR2(5);
   order_no_                           VARCHAR2(65);
   customer_no_                        VARCHAR2(105);
   route_id_                           VARCHAR2(65);
   due_date_                           DATE;
   ship_period_                        VARCHAR2(55);
   forward_agent_                      VARCHAR2(105);
   location_group_                     VARCHAR2(30);
   consolidate_                        VARCHAR2(25);
   print_pick_list_                    NUMBER := NULL;   
   pick_list_no_tmp_                   VARCHAR2(32000) := NULL;  
   pick_list_no_list_                  Pick_List_Table;
   warehouse_task_list_                VARCHAR2(32000) := NULL;
   
   list_attr_                          VARCHAR2(200);
   dummy_ship_id_tab_                  Shipment_API.Shipment_Id_Tab;
   part_no_                            VARCHAR2(130);
   ship_via_code_                      VARCHAR2(20);
   max_orders_on_pick_list_            NUMBER;
   max_ord_ship_on_pick_list_tmp_      VARCHAR2(12);
   include_cust_orders_                VARCHAR2(25) := Consol_Pick_Incl_Cust_Ord_API.DB_WITHIN_SELECTION;
   ignore_existing_shipment_           VARCHAR2(5) := 'FALSE';
   execution_offset_                   NUMBER;
   order_type_                         VARCHAR2(20);
   coordinator_                        VARCHAR2(105);
   co_priority_                        CUSTOMER_ORDER_TAB.priority%TYPE;
   preliminary_pick_list_no_           NUMBER;
   lines_available_                    BOOLEAN := FALSE;
   worker_id_                          VARCHAR2(20);
   info_                               VARCHAR2(2000);
   temp_separator_                     VARCHAR2(2);
   storage_zone_id_                    VARCHAR2(155) := NULL;
   temp_storage_zone_id_               VARCHAR2(155);
   max_shipment_on_pick_list_          NUMBER := 1;
   multiple_ship_per_pick_list_        VARCHAR2(5) := 'FALSE';
   has_invalid_order_lines_            BOOLEAN := FALSE;
   pick_lists_                         CLOB;
   temp_shipment_type_                 VARCHAR2(3);
   hu_to_be_picked_in_one_step_        BOOLEAN := FALSE;
   failed_order_no_list_               Order_No_Bool_Table;
   passed_order_no_list_               Order_No_Bool_Table;
   first_picklist_                     BOOLEAN := TRUE;
   
   CURSOR get_order_no IS
      SELECT DISTINCT location_group, pick_inventory_type_db, order_no
      FROM create_consol_pick_list_tmp;

   CURSOR get_ship_addr IS
      SELECT DISTINCT location_group, pick_inventory_type_db, addr_1, addr_2, addr_3, addr_4, addr_5, addr_6, country_code
      FROM create_consol_pick_list_tmp;

   CURSOR get_customer_no IS
      SELECT DISTINCT location_group, pick_inventory_type_db, customer_no
      FROM create_consol_pick_list_tmp;

   CURSOR get_route_id IS
      SELECT DISTINCT location_group, pick_inventory_type_db, route_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_ship_period IS
      SELECT DISTINCT location_group, pick_inventory_type_db, planned_ship_period
      FROM create_consol_pick_list_tmp;
   
   CURSOR get_forward_agent IS
      SELECT DISTINCT location_group, pick_inventory_type_db, forward_agent_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_warehouse IS
      SELECT DISTINCT location_group, pick_inventory_type_db, warehouse_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_bay IS
      SELECT DISTINCT location_group, pick_inventory_type_db, warehouse_id, bay_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_row IS
      SELECT DISTINCT location_group, pick_inventory_type_db, warehouse_id, bay_id, row_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_tier IS
      SELECT DISTINCT location_group, pick_inventory_type_db, warehouse_id, bay_id, row_id, tier_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_bin IS
      SELECT DISTINCT location_group, pick_inventory_type_db, warehouse_id, bay_id, row_id, tier_id, bin_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_storage_zone_id IS
      SELECT DISTINCT location_group, pick_inventory_type_db, storage_zone_id
      FROM create_consol_pick_list_tmp c, storage_zone_detail_tab z       
      WHERE  c.contract    = z.contract
      AND Report_SYS.Parse_Parameter(z.storage_zone_id, storage_zone_id_) = 'TRUE';

   CURSOR get_preliminary_pick_list_no IS
      SELECT DISTINCT location_group, pick_inventory_type_db
      FROM create_consol_pick_list_tmp;

   CURSOR get_shipment IS
      SELECT DISTINCT shipment_id
      FROM consolidated_orders_tab
      WHERE pick_list_no IN (SELECT TO_NUMBER(xt.column_value)
                             FROM XMLTABLE(pick_lists_) xt)
      AND shipment_id != 0;
BEGIN
--   Error_SYS.Record_General(lu_name_, 'TESTCONSOL: The function Create_Consol_Pick_List__ is started');
   Trace_SYS.Field('attr_', message_);

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ORDER_NO') THEN
         order_no_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'CUSTOMER_NO') THEN
         customer_no_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'ROUTE_ID') THEN
         route_id_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'DUE_DATE') THEN
         due_date_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'SHIP_PERIOD') THEN
         ship_period_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'FORWARD_AGENT') THEN
         forward_agent_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'LOCATION_GROUP') THEN
         location_group_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'CONSOLIDATE') THEN
         consolidate_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PRINT_PICK_LIST') THEN
         print_pick_list_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'PART_NO') THEN
         part_no_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'SHIP_VIA_CODE') THEN
         ship_via_code_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'MAX_ORD_SHIP_ON_PICK_LIST') THEN
         max_ord_ship_on_pick_list_tmp_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'INCLUDE_CUSTOMER_ORDERS') THEN
         include_cust_orders_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'IGNORE_EXISTING_SHIPMENT') THEN
         ignore_existing_shipment_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'EXECUTION_OFFSET') THEN
         execution_offset_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'ORDER_TYPE') THEN
         order_type_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'COORDINATOR') THEN
         coordinator_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'PRIORITY') THEN
         co_priority_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'PRELIMINARY_PICK_LIST_NO') THEN
         preliminary_pick_list_no_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'STORAGE_ZONE') THEN
         storage_zone_id_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'MULTIPLE_SHIP_PER_PICK_LIST') THEN
         multiple_ship_per_pick_list_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'HU_TO_BE_PICKED_IN_ONE_STEP') THEN
         hu_to_be_picked_in_one_step_ := Fnd_Boolean_API.Evaluate_Db(value_arr_(n_));
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;

   IF (execution_offset_ IS NOT NULL) AND (due_date_ IS NULL) THEN
      due_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - execution_offset_;
   ELSE
      due_date_ := NVL(due_date_,SYSDATE);
   END IF;

   IF (max_ord_ship_on_pick_list_tmp_ IS NULL OR max_ord_ship_on_pick_list_tmp_ = '%') THEN
      max_orders_on_pick_list_ := 999999;
   ELSE
      max_orders_on_pick_list_ := to_number(max_ord_ship_on_pick_list_tmp_);
   END IF;
   IF multiple_ship_per_pick_list_ = 'TRUE' THEN
      max_shipment_on_pick_list_ := max_orders_on_pick_list_;
   END IF;

   IF consolidate_ != 'STORAGE ZONE' THEN
      temp_storage_zone_id_ := storage_zone_id_;
   END IF;

   Trace_SYS.Field('contract_  ',           contract_);
   Trace_SYS.Field('order_no_  ',           order_no_);
   Trace_SYS.Field('customer_no_  ',        customer_no_);
   Trace_SYS.Field('route_id_  ',           route_id_);
   Trace_SYS.Field('due_date_  ',           due_date_);
   Trace_SYS.Field('ship_period_  ',        ship_period_);
   Trace_SYS.Field('forward_agent_  ',      forward_agent_);
   Trace_SYS.Field('location_group_  ',     location_group_);
   Trace_SYS.Field('consolidate_  ',        consolidate_);
   Trace_SYS.Field('print_pick_list_  ',    print_pick_list_);   
   Trace_SYS.Field('storage_zone_id_  ',    storage_zone_id_);   

   pick_list_no_list_.DELETE;
   
   @ApproveTransactionStatement(2018-02-09, MeAblk)
   SAVEPOINT start_create_picklist_all;

   -- Create and consolidate the pick list for customer order lines with 'Shipment Creation' => 'At Pick List Creation'.  
   Consol_Ship_Pick_List___ (pick_list_no_list_,      warehouse_task_list_,      
                             consolidate_,            contract_,                 due_date_, 
                             include_cust_orders_,    order_no_,                 customer_no_,
                             route_id_,               ship_period_,              forward_agent_,
                             location_group_,         part_no_,                  ship_via_code_,
                             storage_zone_id_,        order_type_,               coordinator_,
                             co_priority_,            max_shipment_on_pick_list_, ignore_existing_shipment_);

   IF preliminary_pick_list_no_ IS NOT NULL THEN
      -- Fill create_consol_pick_list_tmp for preliminary pick list.       
      Fill_Temporary_Table___(contract_,       order_no_,        customer_no_,     part_no_,     ship_via_code_,  
                               coordinator_,    order_type_,      co_priority_,     route_id_,    ship_period_,  
                               forward_agent_,  location_group_,  NULL,             due_date_,    
                               include_cust_orders_,              NULL,             preliminary_pick_list_no_,
                               NULL,            NULL,             NULL,             NULL,         FALSE,
                               hu_to_be_picked_in_one_step_);
      
      FOR consolidate_rec_ IN get_preliminary_pick_list_no LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         
         Consol_Pick_List___ (pick_list_no_list_,    warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              NULL,                  NULL,                 NULL,              NULL,
                              NULL,                  NULL,                                    consolidate_rec_.location_group,
                              NULL,                  NULL,                                    NULL,
                              NULL,                  NULL,                                    NULL,
                              NULL,                  NULL,                                    NULL,
                              NULL,                  NULL,                                    NULL,
                              NULL ,                 consolidate_rec_.pick_inventory_type_db, '%',
                              '%',                   '%',                                     '%',
                              '%',                   '%',                                     '%',
                              '%',                   include_cust_orders_,                    max_orders_on_pick_list_,
                              0,                     '%',                                     '%',
                              co_priority_,          preliminary_pick_list_no_,               NULL,
                              '%',                   max_shipment_on_pick_list_,              NULL,      NULL,
                              NULL,                  NULL,                                    NULL,      NULL,
                              NULL,                  NULL,                                    FALSE,     NULL);
         lines_available_ := TRUE;
      END LOOP;
      IF (lines_available_) THEN
         worker_id_ := Manual_Consol_Pick_List_API.Get_Worker_Id(preliminary_pick_list_no_);
      END IF;
   ELSE
      -- Fill create_consol_pick_list_tmp according to the selection parametes.
      Fill_Temporary_Table___(contract_,       order_no_,        customer_no_,     part_no_,     ship_via_code_,  
                               coordinator_,    order_type_,      co_priority_,     route_id_,    ship_period_,  
                               forward_agent_,  location_group_,  NULL,             due_date_,    
                               include_cust_orders_,              consolidate_,     preliminary_pick_list_no_,
                               NULL,            NULL,             NULL,             NULL,         FALSE, 
                               hu_to_be_picked_in_one_step_);
   END IF;
   
   IF consolidate_ = 'ORDER NO' THEN
      FOR consolidate_rec_ IN get_order_no LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,     warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              consolidate_rec_.order_no,  '%',              '%',                due_date_,
                              '%',                    '%',                                      consolidate_rec_.location_group,
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              consolidate_,           consolidate_rec_.pick_inventory_type_db,  order_no_,
                              customer_no_,           route_id_,                                ship_period_,
                              forward_agent_,         location_group_,                          part_no_,   
                              ship_via_code_,         include_cust_orders_,                     max_orders_on_pick_list_,
                              0,                      order_type_,                              coordinator_,
                              co_priority_,           NULL,                                     storage_zone_id_,
                              temp_storage_zone_id_,  max_shipment_on_pick_list_,               NULL,      NULL,
                              NULL,                   NULL,                                     NULL,      NULL,
                              NULL,                   NULL,                                     FALSE,     NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'DELIVERY ADDRESS' THEN
      FOR consolidate_rec_ IN get_ship_addr LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,      warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_,  failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                     '%',                  '%',               due_date_,
                              '%',                     '%',                                     consolidate_rec_.location_group,
                              '%',                     '%',                                     '%',
                              '%',                     '%',                                     consolidate_rec_.addr_1,
                              consolidate_rec_.addr_2, consolidate_rec_.addr_3,                 consolidate_rec_.addr_4,
                              consolidate_rec_.addr_5, consolidate_rec_.addr_6,                 consolidate_rec_.country_code,
                              consolidate_,            consolidate_rec_.pick_inventory_type_db, order_no_,
                              customer_no_,            route_id_,                               ship_period_,
                              forward_agent_,          location_group_,                         part_no_,
                              ship_via_code_,          include_cust_orders_,                    max_orders_on_pick_list_,
                              0,                       order_type_,                             coordinator_,
                              co_priority_,            NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,   max_shipment_on_pick_list_,              NULL,      NULL,
                              NULL,                    NULL,                                    NULL,      NULL,
                              NULL,                    NULL,                                    FALSE,     NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'CUSTOMER NO' THEN
      FOR consolidate_rec_ IN get_customer_no LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,           warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                          consolidate_rec_.customer_no,             '%',                      due_date_,
                              '%',                          '%',                                      consolidate_rec_.location_group,
                              '%',                          '%',                                      '%',
                              '%',                          '%',                                      '%',
                              '%',                          '%',                                      '%',
                              '%',                          '%',                                      '%',
                              consolidate_ ,                consolidate_rec_.pick_inventory_type_db,  order_no_,
                              customer_no_,                 route_id_,                                ship_period_,
                              forward_agent_,               location_group_,                          part_no_,
                              ship_via_code_,               include_cust_orders_,                     max_orders_on_pick_list_,
                              0,                            order_type_,                              coordinator_,
                              co_priority_,                 NULL,                                     storage_zone_id_,
                              temp_storage_zone_id_,        max_shipment_on_pick_list_,               NULL,      NULL,
                              NULL,                         NULL,                                     NULL,      NULL,
                              NULL,                         NULL,                                     FALSE,     NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'ROUTE ID' THEN
      FOR consolidate_rec_ IN get_route_id LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,     warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                    '%',                  consolidate_rec_.route_id,                    due_date_,
                              '%',                    '%',                                      consolidate_rec_.location_group,
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              consolidate_ ,          consolidate_rec_.pick_inventory_type_db,  order_no_,
                              customer_no_,           route_id_,                                ship_period_,
                              forward_agent_,         location_group_,                          part_no_,
                              ship_via_code_,         include_cust_orders_,                     max_orders_on_pick_list_,
                              0,                      order_type_,                              coordinator_,
                              co_priority_,           NULL,                                     storage_zone_id_,
                              temp_storage_zone_id_,  max_shipment_on_pick_list_,               NULL,      NULL,
                              NULL,                   NULL,                                     NULL,      NULL,
                              NULL,                   NULL,                                     FALSE,     NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'PLANNED SHIP PERIOD' THEN
      FOR consolidate_rec_ IN get_ship_period LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,                   warehouse_task_list_,  dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                                  '%',                   '%',                due_date_,
                              consolidate_rec_.planned_ship_period, '%',                                       consolidate_rec_.location_group,
                              '%',                                  '%',                                       '%',
                              '%',                                  '%',                                       '%',
                              '%',                                  '%',                                       '%',
                              '%',                                  '%',                                       '%',
                              consolidate_,                         consolidate_rec_.pick_inventory_type_db,   order_no_,
                              customer_no_,                         route_id_,                                 ship_period_,
                              forward_agent_,                       location_group_,                           part_no_,
                              ship_via_code_,                       include_cust_orders_,                      max_orders_on_pick_list_,
                              0,                                    order_type_,                               coordinator_,
                              co_priority_,                         NULL,                                      storage_zone_id_,
                              temp_storage_zone_id_,                max_shipment_on_pick_list_,                NULL,      NULL,
                              NULL,                                 NULL,                                      NULL,      NULL,
                              NULL,                                 NULL,                                      FALSE,     NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'FORWARD AGENT' THEN
      FOR consolidate_rec_ IN get_forward_agent LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,     warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                    '%',                  '%',                due_date_,
                              '%',                    consolidate_rec_.forward_agent_id,        consolidate_rec_.location_group,
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              '%',                    '%',                                      '%',
                              consolidate_,           consolidate_rec_.pick_inventory_type_db,  order_no_,
                              customer_no_,           route_id_,                                ship_period_,
                              forward_agent_,         location_group_,                          part_no_,
                              ship_via_code_,         include_cust_orders_,                     max_orders_on_pick_list_,
                              0,                      order_type_,                              coordinator_,
                              co_priority_,           NULL,                                     storage_zone_id_,
                              temp_storage_zone_id_,  max_shipment_on_pick_list_,               NULL,      NULL,
                              NULL,                   NULL,                                     NULL,      NULL,
                              NULL,                   NULL,                                     FALSE,     NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'WAREHOUSE' THEN
      FOR consolidate_rec_ IN get_warehouse LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                             '%',                  '%',               due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   '%',                                     '%',
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     '%',
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, order_no_,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         part_no_,
                              ship_via_code_,                  include_cust_orders_,                    max_orders_on_pick_list_,
                              0,                               order_type_,                             coordinator_,
                              co_priority_,                    NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              NULL,      NULL,
                              NULL,                            NULL,                                    NULL,      NULL,
                              NULL,                            NULL,                                    FALSE,     NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'BAY' THEN
      FOR consolidate_rec_ IN get_bay LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                             '%',                  '%',               due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   consolidate_rec_.bay_id,                 '%',
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     '%',
                              consolidate_ ,                   consolidate_rec_.pick_inventory_type_db, order_no_,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         part_no_,
                              ship_via_code_,                  include_cust_orders_,                    max_orders_on_pick_list_,
                              0,                               order_type_,                             coordinator_,
                              co_priority_,                    NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              NULL,      NULL,
                              NULL,                            NULL,                                    NULL,      NULL,
                              NULL,                            NULL,                                    FALSE,     NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'ROW' THEN
      FOR consolidate_rec_ IN get_row LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_,  has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                             '%',                  '%',                 due_date_,
                              '%',                             '%',                                       consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   consolidate_rec_.bay_id,                   consolidate_rec_.row_id,
                              '%',                             '%',                                       '%',
                              '%',                             '%',                                       '%',
                              '%',                             '%',                                       '%',
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db,   order_no_,
                              customer_no_,                    route_id_,                                 ship_period_,
                              forward_agent_,                  location_group_,                           part_no_,
                              ship_via_code_,                  include_cust_orders_,                      max_orders_on_pick_list_,
                              0,                               order_type_,                               coordinator_,
                              co_priority_,                    NULL,                                      storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,                NULL,      NULL,
                              NULL,                            NULL,                                      NULL,      NULL,
                              NULL,                            NULL,                                      FALSE,     NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'TIER' THEN
      FOR consolidate_rec_ IN get_tier LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_,  dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                             '%',                   '%',                due_date_,
                              '%',                             '%',                                       consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   consolidate_rec_.bay_id,                   consolidate_rec_.row_id,
                              consolidate_rec_.tier_id,        '%',                                       '%',
                              '%',                             '%',                                       '%',
                              '%',                             '%',                                       '%',
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db,   order_no_,
                              customer_no_,                    route_id_,                                 ship_period_,
                              forward_agent_,                  location_group_,                           part_no_,
                              ship_via_code_,                  include_cust_orders_,                      max_orders_on_pick_list_,
                              0,                               order_type_,                               coordinator_,
                              co_priority_,                    NULL,                                      storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,                NULL,      NULL,
                              NULL,                            NULL,                                      NULL,      NULL,
                              NULL,                            NULL,                                      FALSE,     NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'BIN' THEN
      FOR consolidate_rec_ IN get_bin LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                             '%',                  '%',               due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   consolidate_rec_.bay_id,                 consolidate_rec_.row_id,
                              consolidate_rec_.tier_id,        consolidate_rec_.bin_id,                 '%',
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     '%',
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, order_no_,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         part_no_,
                              ship_via_code_,                  include_cust_orders_,                    max_orders_on_pick_list_,
                              0,                               order_type_,                             coordinator_,
                              co_priority_,                    NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              NULL,      NULL,
                              NULL,                            NULL,                                    NULL,      NULL,
                              NULL,                            NULL,                                    FALSE,     NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'STORAGE ZONE' THEN
      FOR consolidate_rec_ IN get_storage_zone_id LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2018-02-09, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,         warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              '%',                        '%',                  '%',               due_date_,
                              '%',                        '%',                                     consolidate_rec_.location_group,
                              '%',                        '%',                                     '%',
                              '%',                        '%',                                     '%',
                              '%',                        '%',                                     '%',
                              '%',                        '%',                                     '%',
                              consolidate_,               consolidate_rec_.pick_inventory_type_db, order_no_,
                              customer_no_,               route_id_,                               ship_period_,
                              forward_agent_,             location_group_,                         part_no_,
                              ship_via_code_,             include_cust_orders_,                    max_orders_on_pick_list_,
                              0,                          order_type_,                             coordinator_,
                              co_priority_,               NULL,                                    consolidate_rec_.storage_zone_id,
                              storage_zone_id_,           max_shipment_on_pick_list_,              NULL,      NULL,
                              NULL,                       NULL,                                    NULL,      NULL,
                              NULL,                       NULL,                                    FALSE,     NULL);
      END LOOP;
   END IF;

   IF (Transaction_Sys.Is_Session_Deferred() AND preliminary_pick_list_no_ IS NOT NULL) THEN
      IF (warehouse_task_list_ IS NOT NULL) THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'WHTASKSS_CREATED: Warehouse task(s) :P1 created.', NULL, warehouse_task_list_);
      ELSE
         IF (pick_list_no_list_.COUNT > 0) THEN
            temp_separator_ := '';
            FOR i_ IN pick_list_no_list_.FIRST..pick_list_no_list_.LAST LOOP
               pick_list_no_tmp_ := pick_list_no_tmp_ ||  temp_separator_ || pick_list_no_list_(i_);
               temp_separator_   := ', ';
            END LOOP;
            info_ := Language_SYS.Translate_Constant(lu_name_, 'PCKLSTS_CREATED: Pick list(s) :P1 created.', NULL, pick_list_no_tmp_);
         END IF;
      END IF;
      Transaction_SYS.Set_Progress_Info(info_);
   END IF;
   
   IF print_pick_list_ = 1 THEN
      IF (pick_list_no_list_.COUNT > 0) THEN
         FOR i_ IN pick_list_no_list_.FIRST..pick_list_no_list_.LAST LOOP

            Client_SYS.Clear_Attr(list_attr_);
            Client_SYS.Add_To_Attr('PICK_LIST_NO', pick_list_no_list_(i_), list_attr_);

            Trace_SYS.Field('Now printing picklist  ', pick_list_no_list_(i_));
            Trace_SYS.Field('list_attr_ ',list_attr_);

            Customer_Order_Flow_API.Start_Print_Consol_Pl__(list_attr_);
            Trace_SYS.Field('Now printing picklist  ', pick_list_no_list_(i_));

         END LOOP;
      END IF;
   END IF;
   
   IF (pick_list_no_list_.COUNT > 0) THEN
      FOR i_ IN pick_list_no_list_.FIRST..pick_list_no_list_.LAST LOOP
         pick_lists_ := pick_lists_ || pick_list_no_list_(i_) || ',';         
      END LOOP;
      pick_lists_ := RTRIM(pick_lists_, ',');
   END IF;
   
   IF (pick_lists_ IS NOT NULL) THEN
      FOR shipment_rec_ IN get_shipment LOOP          
         temp_shipment_type_ := Shipment_API.Get_Shipment_Type(shipment_rec_.shipment_id);
         -- Trigger the optional events define for 'Create Pick List'.
         Shipment_Flow_API.Process_Optional_Events(shipment_rec_.shipment_id, temp_shipment_type_, 20);    
         IF print_pick_list_ = 1 THEN
            -- Trigger the optional events define for 'Print Pick List'.
            Shipment_Flow_API.Process_Optional_Events(shipment_rec_.shipment_id, temp_shipment_type_, 30);   
         END IF;
         
      END LOOP;
   END IF;
   
   IF ((preliminary_pick_list_no_ IS NOT NULL) AND (has_invalid_order_lines_ = FALSE))THEN  
      -- Set manual consolidated pick list to state created
      Manual_Consol_Pick_List_API.Set_Created(preliminary_pick_list_no_);
   END IF;
END Create_Consol_Pick_List_Impl__;


-- Create_Shipment_Pick_Lists__
--   Called from the shipment client to create consolidated shipment
--   pick lists.
PROCEDURE Create_Shipment_Pick_Lists__ (
   pick_list_no_list_         IN OUT   Pick_List_Table,
   shipment_id_               IN       VARCHAR2,
   location_group_            IN       VARCHAR2,
   from_shipment_flow_        IN       BOOLEAN,
   rental_transfer_db_        IN       VARCHAR2 DEFAULT Fnd_Boolean_API.db_false)
IS
   consolidate_             VARCHAR2(30);
   warehouse_task_list_     VARCHAR2(32000) := NULL;   
   shipment_rec_            Shipment_API.Public_Rec;
   shipment_id_tab_         Shipment_API.Shipment_Id_Tab;   
   has_invalid_order_lines_ BOOLEAN := FALSE;
   failed_order_no_list_      Order_No_Bool_Table;
   passed_order_no_list_      Order_No_Bool_Table;
   
   CURSOR get_shipment IS
      SELECT DISTINCT location_group, pick_inventory_type_db, ship_inventory_location_no
      FROM create_consol_pick_list_tmp;
BEGIN
   consolidate_ := 'SHIPMENT';
  
   IF Credit_Check_Ship_Pick_List___(shipment_id_) THEN      
      shipment_rec_ := Shipment_API.Get(shipment_id_);
      -- 'CREATE_SHIPMENT_PICK_LIST' is not an attribute of Pick_List_Consolidation_API enumiration. 
      -- consolidate_ => 'CREATE_SHIPMENT_PICK_LIST', is only for distinguish the selection for create shipment pick list.
      Fill_Temporary_Table___(NULL,   NULL,             NULL,          NULL, NULL,  
                               NULL,   NULL,             NULL,          NULL, NULL,  
                               NULL,   location_group_,  shipment_id_,  NULL,
                               NULL,   'CREATE_SHIPMENT_PICK_LIST',     NULL, NULL,
                               NULL,   NULL,             NULL,          FALSE);

      FOR consolidate_rec_ IN get_shipment LOOP
         Consol_Pick_List___ (pick_list_no_list_,           warehouse_task_list_, shipment_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, shipment_rec_.contract, 
                              '%',                          '%',                  '%',        NULL,
                              '%',                          '%',                              consolidate_rec_.location_group,
                              '%',                          '%',                              '%',
                              '%',                          '%',                              '%',
                              '%',                          '%',                              '%',
                              '%',                          '%',                              '%',
                              consolidate_,                 consolidate_rec_.pick_inventory_type_db,     '%',
                              shipment_rec_.receiver_id,      '%',                 '%',
                              '%',                          '%',                              '%',
                              '%',                          'WITHIN_SELECTION',               999999,
                              shipment_id_,                 '%',                              '%',
                              NULL,                         NULL,                             '%',
                              '%',                          1,                                NULL,      NULL,
                              NVL(consolidate_rec_.ship_inventory_location_no, '%'),    NULL, NULL,      NULL,
                              NULL,                         NULL,                             FALSE,     NULL);
      END LOOP;
      
      shipment_id_tab_(1) := shipment_id_;

      IF NOT from_shipment_flow_ THEN
         -- Trigger shipment process.
         Shipment_Flow_API.Start_Shipment_Flow(Client_SYS.Attr_Value_To_Number(shipment_id_), 20, rental_transfer_db_);
      END IF;
   END IF;
END Create_Shipment_Pick_Lists__;


@UncheckedAccess
FUNCTION Check_Order_For_Backorder__ (
   order_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   found_            NUMBER;
   check_backorders_ BOOLEAN := FALSE;
   CURSOR prevent_backorder IS
      SELECT 1
        FROM customer_order_tab co, customer_order_line_tab col
       WHERE col.order_no = co.order_no
         AND co.backorder_option = 'NO PARTIAL DELIVERIES ALLOWED'
         AND co.order_no = order_no_
         AND col.rowstate != 'Cancelled'
         AND col.part_no IS NOT NULL
         AND col.supply_code IN ('IO','PS', 'PT', 'IPT', 'SO', 'PI', 'DOP') -- Added supply code filter to avoid PD, IPD supply for the inventory sales part.
         AND (col.revised_qty_due - (col.qty_shipped - col.qty_shipdiff)) - col.qty_assigned > 0;
BEGIN
   OPEN prevent_backorder;
   FETCH prevent_backorder INTO found_;
   IF prevent_backorder%FOUND THEN
      check_backorders_ := TRUE;
   END IF;
   CLOSE prevent_backorder;
   RETURN check_backorders_;
END Check_Order_For_Backorder__;


FUNCTION Line_Backorder_Check_Passed__ (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   backorder_option_ IN VARCHAR2,
   loctaion_group_   IN VARCHAR2,
   warehouse_        IN VARCHAR2 DEFAULT NULL,
   pick_list_no_     IN VARCHAR2 DEFAULT '*') RETURN BOOLEAN
IS
   found_                   NUMBER;
   allow_partial_pkg_deliv_ VARCHAR2(5) := 'TRUE';
   linerec_                 Customer_Order_Line_API.Public_Rec;
   backorder_checked_       BOOLEAN := FALSE; 

   CURSOR line_partial_reserved IS
      SELECT 1
        FROM customer_order_line_tab
       WHERE order_no = order_no_
         AND line_no  = line_no_
         AND rel_no   = rel_no_
         AND rowstate != 'Cancelled'
         AND (supply_code IN ('IO','PS', 'PT', 'IPT', 'SO', 'PI', 'DOP')
         AND (revised_qty_due - (qty_shipped - qty_shipdiff)) - qty_assigned > 0);
BEGIN
   IF (line_item_no_ > 0 AND backorder_option_ = 'ALLOW INCOMPLETE LINES AND PACKAGES') THEN
      linerec_                 := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, -1);
      allow_partial_pkg_deliv_ := Sales_Part_API.Get_Allow_Partial_Pkg_Deliv_Db(
                                                                        linerec_.contract,
                                                                        linerec_.catalog_no);
   END IF;

   IF (backorder_option_ = 'INCOMPLETE LINES NOT ALLOWED') THEN
      OPEN line_partial_reserved;
      FETCH line_partial_reserved INTO found_;
      IF line_partial_reserved%NOTFOUND THEN
         backorder_checked_ := TRUE;
      END IF;
      CLOSE line_partial_reserved;
   ELSIF (line_item_no_ > 0 AND (backorder_option_ = 'INCOMPLETE PACKAGES NOT ALLOWED' OR (backorder_option_ = 'ALLOW INCOMPLETE LINES AND PACKAGES' AND allow_partial_pkg_deliv_ = 'FALSE')))THEN
      IF (Reserve_Customer_Order_API.Get_Full_Reserved_Pkg_Qty(order_no_, line_no_, rel_no_, loctaion_group_, warehouse_, NVL(pick_list_no_, '*')) > 0) THEN
         backorder_checked_ := TRUE;
      END IF;      
   ELSIF (line_item_no_ > 0 AND backorder_option_ = 'ALLOW INCOMPLETE LINES AND PACKAGES' AND allow_partial_pkg_deliv_ = 'TRUE') THEN
      backorder_checked_ := TRUE;
   ELSIF (line_item_no_ = 0 AND backorder_option_ IN ('INCOMPLETE PACKAGES NOT ALLOWED', 'ALLOW INCOMPLETE LINES AND PACKAGES')) THEN
      backorder_checked_ := TRUE;
   END IF;
   RETURN backorder_checked_;
END Line_Backorder_Check_Passed__;


PROCEDURE Create_Ship_Consol_Pl__ (
   message_ IN VARCHAR2 )
IS
   description_ VARCHAR2(200);
BEGIN
   IF (Transaction_Sys.Is_Session_Deferred()) THEN
      -- if we are already inside a background job don't create a new one, which will happened if this was a scheduled job
      Create_Ship_Consol_Pl_Impl__(message_);
   ELSE
      description_ := Language_SYS.Translate_Constant(lu_name_, 'CREATE_SHIP_CONSOL: Create Consolidated Pick List for Shipments');
      Transaction_SYS.Deferred_Call('CREATE_PICK_LIST_API.Create_Ship_Consol_Pl_Impl__', message_, description_);
   END IF;
END Create_Ship_Consol_Pl__;


PROCEDURE Create_Ship_Consol_Pl_Impl__ (
   message_ IN VARCHAR2 )
IS
   count_                              NUMBER;
   name_arr_                           Message_SYS.name_table;
   value_arr_                          Message_SYS.line_table;

   contract_                           VARCHAR2(5);
   consolidate_                        VARCHAR2(25);
   print_pick_list_                    NUMBER := NULL;
   shipment_id_                        VARCHAR2(55);
   consolidate_shipment_id_            VARCHAR2(55);
   shipment_type_                      VARCHAR2(20);
   customer_no_                        VARCHAR2(105);
   route_id_                           VARCHAR2(65);
   forward_agent_                      VARCHAR2(105);
   ship_via_code_                      VARCHAR2(20);
   ship_period_                        VARCHAR2(55);
   due_date_                           DATE;
   ship_date_                          DATE;
   location_group_                     VARCHAR2(30);
   shipment_location_                  VARCHAR2(180);
   storage_zone_id_                    VARCHAR2(155) := NULL;
   temp_storage_zone_id_               VARCHAR2(100);
   max_shipment_on_pick_list_          NUMBER := 1;
   max_ship_on_pick_list_tmp_          VARCHAR2(12);
   include_shipments_                  VARCHAR2(25) := Consol_Pick_Incl_Cust_Ord_API.DB_WITHIN_SELECTION;
   pick_list_no_list_                  Pick_List_Table;   
   warehouse_task_list_                VARCHAR2(32000) := NULL;   
   list_attr_                          VARCHAR2(200);   
   due_date_execution_offset_          NUMBER;
   ship_date_execution_offset_         NUMBER;
   pick_lists_                         CLOB;
   temp_shipment_type_                 VARCHAR2(3);
   dummy_ship_id_tab_                  Shipment_API.Shipment_Id_Tab;
   has_invalid_order_lines_            BOOLEAN := FALSE;
   hu_to_be_picked_in_one_step_        BOOLEAN := FALSE;
   failed_order_no_list_               Order_No_Bool_Table;
   passed_order_no_list_               Order_No_Bool_Table;
   first_picklist_                     BOOLEAN := TRUE;
   
   CURSOR get_warehouse IS
      SELECT DISTINCT location_group, pick_inventory_type_db, ship_inventory_location_no, warehouse_id 
      FROM create_consol_pick_list_tmp;

   CURSOR get_bay IS
      SELECT DISTINCT location_group, pick_inventory_type_db, ship_inventory_location_no, warehouse_id, bay_id 
      FROM create_consol_pick_list_tmp;

   CURSOR get_row IS
      SELECT DISTINCT location_group, pick_inventory_type_db, ship_inventory_location_no, warehouse_id, bay_id, row_id 
      FROM create_consol_pick_list_tmp;

   CURSOR get_tier IS
      SELECT DISTINCT location_group, pick_inventory_type_db, ship_inventory_location_no, warehouse_id, bay_id, row_id, tier_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_bin IS
      SELECT DISTINCT location_group, pick_inventory_type_db, ship_inventory_location_no, warehouse_id, bay_id, row_id, tier_id, bin_id
      FROM create_consol_pick_list_tmp;
   
   CURSOR get_storage_zone_id IS
      SELECT DISTINCT location_group, pick_inventory_type_db, ship_inventory_location_no, storage_zone_id
      FROM create_consol_pick_list_tmp c, storage_zone_detail_tab z       
      WHERE  c.contract    = z.contract
      AND Report_SYS.Parse_Parameter(z.storage_zone_id, storage_zone_id_) = 'TRUE'; 
   
   CURSOR get_customer_no IS
      SELECT DISTINCT location_group, pick_inventory_type_db, ship_inventory_location_no, customer_no
      FROM create_consol_pick_list_tmp;   
   
   CURSOR get_shipment_id IS
      SELECT DISTINCT location_group, pick_inventory_type_db, ship_inventory_location_no, shipment_id
      FROM create_consol_pick_list_tmp;

   CURSOR get_consol_shipment_id IS
      SELECT DISTINCT location_group, pick_inventory_type_db, ship_inventory_location_no, parent_consol_shipment_id
      FROM create_consol_pick_list_tmp;   
   
   CURSOR get_ship_period IS
      SELECT DISTINCT location_group, pick_inventory_type_db, ship_inventory_location_no, planned_ship_period
      FROM create_consol_pick_list_tmp;
   
   CURSOR get_route_id IS
      SELECT DISTINCT location_group, pick_inventory_type_db, ship_inventory_location_no, route_id
      FROM create_consol_pick_list_tmp;
   
   CURSOR get_forward_agent IS   
      SELECT DISTINCT location_group, pick_inventory_type_db, ship_inventory_location_no, forward_agent_id 
      FROM create_consol_pick_list_tmp;
   
   CURSOR get_shipment IS
      SELECT DISTINCT shipment_id
      FROM consolidated_orders_tab
      WHERE pick_list_no IN (SELECT TO_NUMBER(xt.column_value)
                             FROM XMLTABLE(pick_lists_) xt)
      AND shipment_id != 0;
BEGIN
   Trace_SYS.Field('message_ ', message_);

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONSOLIDATE') THEN
         consolidate_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PRINT_PICK_LIST') THEN
         print_pick_list_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'SHIPMENT_ID') THEN
         shipment_id_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'CONSOLIDATED_SHIPMENT_ID') THEN
         consolidate_shipment_id_ := NVL(value_arr_(n_), '%');         
      ELSIF (name_arr_(n_) = 'SHIPMENT_TYPE') THEN
         shipment_type_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'CUSTOMER_NO') THEN
         customer_no_ := NVL(value_arr_(n_), '%');         
      ELSIF (name_arr_(n_) = 'ROUTE_ID') THEN
         route_id_ := NVL(value_arr_(n_), '%');         
      ELSIF (name_arr_(n_) = 'FORWARD_AGENT') THEN
         forward_agent_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'SHIP_VIA_CODE') THEN
         ship_via_code_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'SHIP_PERIOD') THEN
         ship_period_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'DUE_DATE') THEN
         due_date_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'SHIP_DATE') THEN
         ship_date_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'DUE_DATE_EXECUTION_OFFSET') THEN
         due_date_execution_offset_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'SHIP_DATE_EXECUTION_OFFSET') THEN
         ship_date_execution_offset_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));         
      ELSIF (name_arr_(n_) = 'LOCATION_GROUP') THEN
         location_group_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'SHIPMENT_LOCATION') THEN
         shipment_location_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'STORAGE_ZONE') THEN
         storage_zone_id_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'MAX_SHIPMENT_ON_PICK_LIST') THEN
         max_ship_on_pick_list_tmp_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'INCLUDE_SHIPMENTS') THEN
         include_shipments_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'HU_TO_BE_PICKED_IN_ONE_STEP') THEN
         hu_to_be_picked_in_one_step_ := Fnd_Boolean_API.Evaluate_Db(value_arr_(n_));
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;
   
   IF (due_date_execution_offset_ IS NOT NULL) AND (due_date_ IS NULL) THEN      
      due_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - due_date_execution_offset_;
   ELSE
      due_date_ := NVL(due_date_,SYSDATE);
   END IF;
   
   IF (ship_date_execution_offset_ IS NOT NULL) AND (ship_date_ IS NULL) THEN      
      ship_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - ship_date_execution_offset_;
   ELSE
      ship_date_ := NVL(ship_date_,SYSDATE);
   END IF;
   
   IF (max_ship_on_pick_list_tmp_ IS NULL OR max_ship_on_pick_list_tmp_ = '%') THEN
      max_shipment_on_pick_list_ := 999999;      
   ELSE
      max_shipment_on_pick_list_ := to_number(max_ship_on_pick_list_tmp_);
   END IF;  
   
   IF consolidate_ != 'STORAGE ZONE' THEN
      temp_storage_zone_id_ := storage_zone_id_;
   END IF;
    
   pick_list_no_list_.DELETE;   
   
   -- Fill create_consol_pick_list_tmp according to the selection parametes.
   Fill_Temporary_Table___(contract_,          NULL,                customer_no_,     NULL,             ship_via_code_,  
                            NULL,               NULL,                NULL,             route_id_,        ship_period_,  
                            forward_agent_,     location_group_,     shipment_id_,     due_date_,    
                            include_shipments_, consolidate_,        NULL,             consolidate_shipment_id_,
                            shipment_type_,     shipment_location_,  ship_date_,       TRUE,             hu_to_be_picked_in_one_step_);
   
   IF consolidate_ = 'WAREHOUSE' THEN
      FOR consolidate_rec_ IN get_warehouse LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2017-09-11, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_,   
                              NULL,                            '%',                  '%',               due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   '%',                                     '%',
                              '%',                             '%',                                     NULL,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    NULL,
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, NULL,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         NULL,
                              ship_via_code_,                  include_shipments_,                      999999,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              '%',
                              '%',                             consolidate_rec_.ship_inventory_location_no,   ship_date_,
                              shipment_id_,                    consolidate_shipment_id_,                shipment_type_,
                              shipment_location_,              TRUE,          NULL);         
      END LOOP;
   END IF;

   IF consolidate_ = 'BAY' THEN
      FOR consolidate_rec_ IN get_bay LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2017-09-11, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_, 
                              NULL,                            '%',                  '%',               due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   consolidate_rec_.bay_id,                 '%',
                              '%',                             '%',                                     NULL,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    NULL,
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, NULL,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         NULL,
                              ship_via_code_,                  include_shipments_,                      999999,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              '%',
                              '%',                             consolidate_rec_.ship_inventory_location_no,   ship_date_,
                              shipment_id_,                    consolidate_shipment_id_,                shipment_type_,
                              shipment_location_,              TRUE,          NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'ROW' THEN
      FOR consolidate_rec_ IN get_row LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2017-09-11, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_,   
                              NULL,                            '%',                  '%',               due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   consolidate_rec_.bay_id,                 consolidate_rec_.row_id,
                              '%',                             '%',                                     NULL,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    NULL,
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, NULL,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         NULL,
                              ship_via_code_,                  include_shipments_,                      999999,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              '%',
                              '%',                             consolidate_rec_.ship_inventory_location_no,   ship_date_,
                              shipment_id_,                    consolidate_shipment_id_,                shipment_type_,
                              shipment_location_,              TRUE,          NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'TIER' THEN
      FOR consolidate_rec_ IN get_tier LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2017-09-11, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_,
                              NULL,                            '%',                  '%',               due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   consolidate_rec_.bay_id,                 consolidate_rec_.row_id,
                              consolidate_rec_.tier_id,        '%',                                     NULL,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    NULL,
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, NULL,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         NULL,
                              ship_via_code_,                  include_shipments_,                      999999,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              '%',
                              '%',                             consolidate_rec_.ship_inventory_location_no,   ship_date_,
                              shipment_id_,                    consolidate_shipment_id_,                shipment_type_,
                              shipment_location_,              TRUE,          NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'BIN' THEN
      FOR consolidate_rec_ IN get_bin LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2017-09-11, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_,   
                              NULL,                            '%',                  '%',               due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              consolidate_rec_.warehouse_id,   consolidate_rec_.bay_id,                 consolidate_rec_.row_id,
                              consolidate_rec_.tier_id,        consolidate_rec_.bin_id,                 NULL,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    NULL,
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, NULL,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         NULL,
                              ship_via_code_,                  include_shipments_,                      999999,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              '%',
                              '%',                             consolidate_rec_.ship_inventory_location_no,   ship_date_,
                              shipment_id_,                    consolidate_shipment_id_,                shipment_type_,
                              shipment_location_,              TRUE,          NULL);
      END LOOP;
   END IF;
   
   IF consolidate_ = 'CONSOLIDATED SHIPMENT' THEN
      FOR consolidate_rec_ IN get_consol_shipment_id LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2017-09-11, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_,   
                              NULL,                            '%',                  '%',               due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     NULL,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    NULL,
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, NULL,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         NULL,
                              ship_via_code_,                  include_shipments_,                      999999,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              '%',
                              consolidate_rec_.parent_consol_shipment_id,        consolidate_rec_.ship_inventory_location_no,   ship_date_,
                              shipment_id_,                    consolidate_shipment_id_,                shipment_type_,
                              shipment_location_,              TRUE,          NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'SHIPMENT' THEN
      FOR consolidate_rec_ IN get_shipment_id LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2017-09-11, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_,   
                              NULL,                            '%',                  '%',               due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     NULL,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    NULL,
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, NULL,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         NULL,
                              ship_via_code_,                  include_shipments_,                      999999,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              consolidate_rec_.shipment_id,
                              '%',                             consolidate_rec_.ship_inventory_location_no,   ship_date_,
                              shipment_id_,                    consolidate_shipment_id_,                shipment_type_,
                              shipment_location_,              TRUE,          NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'CUSTOMER NO' THEN
      FOR consolidate_rec_ IN get_customer_no LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2017-09-11, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_,   
                              NULL,                            consolidate_rec_.customer_no,            '%',                       due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     NULL,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    NULL,
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, NULL,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         NULL,
                              ship_via_code_,                  include_shipments_,                      999999,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              '%',
                              '%',                             consolidate_rec_.ship_inventory_location_no,   ship_date_,
                              shipment_id_,                    consolidate_shipment_id_,                shipment_type_,
                              shipment_location_,              TRUE,          NULL);
      END LOOP;
   END IF;
   
   IF consolidate_ = 'PLANNED SHIP PERIOD' THEN
      FOR consolidate_rec_ IN get_ship_period LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2017-09-11, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_,   
                              NULL,                            '%',                  '%',               due_date_,
                              consolidate_rec_.planned_ship_period,   '%',                              consolidate_rec_.location_group,
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     NULL,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    NULL,
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, NULL,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         NULL,
                              ship_via_code_,                  include_shipments_,                      999999,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              '%',
                              '%',                             consolidate_rec_.ship_inventory_location_no,   ship_date_,
                              shipment_id_,                    consolidate_shipment_id_,                shipment_type_,
                              shipment_location_,              TRUE,          NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'ROUTE ID' THEN
      FOR consolidate_rec_ IN get_route_id LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2017-09-11, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_,   
                              NULL,                            '%',                   consolidate_rec_.route_id,                   due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     NULL,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    NULL,
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, NULL,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         NULL,
                              ship_via_code_,                  include_shipments_,                      999999,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              '%',
                              '%',                             consolidate_rec_.ship_inventory_location_no,   ship_date_,
                              shipment_id_,                    consolidate_shipment_id_,                shipment_type_,
                              shipment_location_,              TRUE,          NULL);
      END LOOP;
   END IF;

   IF consolidate_ = 'FORWARD AGENT' THEN
      FOR consolidate_rec_ IN get_forward_agent LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2017-09-11, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_,   
                              NULL,                            '%',                  '%',               due_date_,
                              '%',                             consolidate_rec_.forward_agent_id,       consolidate_rec_.location_group,
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     NULL,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    NULL,
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, NULL,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         NULL,
                              ship_via_code_,                  include_shipments_,                      999999,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    storage_zone_id_,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              '%',
                              '%',                             consolidate_rec_.ship_inventory_location_no,   ship_date_,
                              shipment_id_,                    consolidate_shipment_id_,                shipment_type_,
                              shipment_location_,              TRUE,          NULL);
      END LOOP;
   END IF;
   
   IF consolidate_ = 'STORAGE ZONE' THEN
      FOR consolidate_rec_ IN get_storage_zone_id LOOP
         IF (first_picklist_) THEN
            @ApproveTransactionStatement(2017-09-11, MeAblk)
            SAVEPOINT start_create_picklist_all;
            first_picklist_ := FALSE;
         END IF;
         Consol_Pick_List___ (pick_list_no_list_,              warehouse_task_list_, dummy_ship_id_tab_, has_invalid_order_lines_, failed_order_no_list_, passed_order_no_list_, contract_,   
                              NULL,                            '%',                  '%',               due_date_,
                              '%',                             '%',                                     consolidate_rec_.location_group,
                              '%',                             '%',                                     '%',
                              '%',                             '%',                                     NULL,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    NULL,
                              consolidate_,                    consolidate_rec_.pick_inventory_type_db, NULL,
                              customer_no_,                    route_id_,                               ship_period_,
                              forward_agent_,                  location_group_,                         NULL,
                              ship_via_code_,                  include_shipments_,                      999999,
                              NULL,                            NULL,                                    NULL,
                              NULL,                            NULL,                                    consolidate_rec_.storage_zone_id,
                              temp_storage_zone_id_,           max_shipment_on_pick_list_,              '%',
                              '%',                             consolidate_rec_.ship_inventory_location_no,   ship_date_,
                              shipment_id_,                    consolidate_shipment_id_,                shipment_type_,
                              shipment_location_,              TRUE,          NULL);
      END LOOP;
   END IF;   
   
   IF print_pick_list_ = 1 THEN
      IF (pick_list_no_list_.COUNT > 0) THEN
         FOR i_ IN pick_list_no_list_.FIRST..pick_list_no_list_.LAST LOOP
            Client_SYS.Clear_Attr(list_attr_);
            Client_SYS.Add_To_Attr('PICK_LIST_NO', pick_list_no_list_(i_), list_attr_);

            Trace_SYS.Field('Now printing picklist  ', pick_list_no_list_(i_));
            Trace_SYS.Field('list_attr_ ',list_attr_);

            Start_Print_Ship_Consol_Pl___(list_attr_);
            Trace_SYS.Field('Now printing picklist  ', pick_list_no_list_(i_));
         END LOOP;
      END IF;
   END IF;
   
   IF (pick_list_no_list_.COUNT > 0) THEN
      FOR i_ IN pick_list_no_list_.FIRST..pick_list_no_list_.LAST LOOP
         pick_lists_ := pick_lists_ || pick_list_no_list_(i_) || ',';         
      END LOOP;
      pick_lists_ := RTRIM(pick_lists_, ',');
   END IF;
   
   IF (pick_lists_ IS NOT NULL) THEN
      FOR shipment_rec_ IN get_shipment LOOP          
         temp_shipment_type_ := Shipment_API.Get_Shipment_Type(shipment_rec_.shipment_id);
         -- Trigger the optional events define for 'Create Pick List'.
         Shipment_Flow_API.Process_Optional_Events(shipment_rec_.shipment_id, temp_shipment_type_, 20);    
         IF print_pick_list_ = 1 THEN
            -- Trigger the optional events define for 'Print Pick List'.
            Shipment_Flow_API.Process_Optional_Events(shipment_rec_.shipment_id, temp_shipment_type_, 30);   
         END IF;
      END LOOP;
   END IF;
END Create_Ship_Consol_Pl_Impl__;


PROCEDURE Print_Ship_Consol_Pick_List__ (
   attr_ IN OUT VARCHAR2 )
IS
   ptr_          NUMBER;
   name_         VARCHAR2(30);
   value_        VARCHAR2(2000);
   pick_list_no_ VARCHAR2(15);
BEGIN
   WHILE (CLIENT_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'PICK_LIST_NO') THEN
         pick_list_no_ := value_;
         Print_Ship_Consol_Pl___(pick_list_no_);
         Trace_SYS.Field('pick_list_no_', pick_list_no_);
      END IF;
   END LOOP;
END Print_Ship_Consol_Pick_List__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Validate_Params
--   Validates the parameters when running the Schedule for Create
--   consolidated Pick List for Customer Order.
PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_                   NUMBER;
   name_arr_                Message_SYS.name_table;
   value_arr_               Message_SYS.line_table;
   contract_                VARCHAR2(5);
   location_group_          VARCHAR2(30);
   loc_group_exist_         BOOLEAN := FALSE;
   raise_application_error_ BOOLEAN := FALSE;
   
   CURSOR get_valid_location_group IS
      SELECT location_group, inventory_location_type
      FROM inventory_location_group_tab
      WHERE Report_SYS.Parse_Parameter(location_group, location_group_) = 'TRUE';
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LOCATION_GROUP') THEN
         location_group_ := NVL(value_arr_(n_), '%');
      END IF;
   END LOOP;

   IF (contract_ IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;
   IF ((location_group_ IS NOT NULL) AND (location_group_ != '%')) THEN
      FOR loc_rec_ IN get_valid_location_group LOOP            
         loc_group_exist_ := TRUE;
         IF (loc_rec_.inventory_location_type != 'PICKING') THEN
            raise_application_error_ := TRUE;
         END IF;
      END LOOP;
      IF (NOT loc_group_exist_) OR (raise_application_error_) THEN
         Error_SYS.Appl_General(lu_name_, 'INVALIDLOCGROUP: Invalid location group entered. Valid inventory location type is Picking.');
      END IF;            
   END IF;
END Validate_Params;
   
   
@UncheckedAccess
FUNCTION Create_Pick_List_Allowed (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;

   CURSOR create_pick_list IS
      SELECT 1
      FROM   CREATE_PICK_LIST_JOIN_MAIN
      WHERE  pick_list_no  = '*'
      AND    shipment_id   = shipment_id_;
BEGIN
   OPEN create_pick_list;
   FETCH create_pick_list INTO allowed_;
   IF (create_pick_list%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE create_pick_list;
   RETURN allowed_;
END Create_Pick_List_Allowed;

