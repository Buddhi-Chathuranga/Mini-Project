-----------------------------------------------------------------------------
--
--  Logical unit: ReserveCustomerOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  211109  NiRalk   SC21R2-5444,Modified overload methods Modify_Cost_After_Reserve___() by making cost as zero when Part_Ownership is DB_COMPANY_RENTAL_ASSET.
--  211108  KiSalk   Bug 161251(SC21R2-5235), Modified Reserve_Order_Line__ having added parameter reservation_operation_id_ to cater for pick by choice for manually reserved CO lines with pegged objects.
--  211101  GISSLK   MF21R2-5854, Modify Control_Ms_Mrp_Consumption() to consider abnormal demands with online consumption.
--  210711  ErFelk   Bug 159902(SCZ-15453), Restructured the code of Man_Res_Valid_Ext_Service___() so that it correctly filter the serial and lot batch which are coming from External Service Order. 
--  210630  JOWISE   MF21R2-2040, Truncate time indication for Planned Due Date field when comparing with a date field
--  210607  KETKLK   PJ21R2-749, Replaced Project Delivery supply code 'PRD' with Project Deliverables supply code 'PJD' as Project Delivery functionality will be removed.
--  210512  ThKrlk   Bug 159242(SCZ-14740), Correction of Bug 151855 was reversed.
--  210419  JICESE   Merged LCS Bug 158120
--                   210329  UtSwLK   Bug 158120(MFZ-6960), Added condition not to update the quantity_on_order if the supply code is DOP in Unregister_Arrival___().
--  210303  ThKrlk   Bug 158111 (SCZ-13853), Modified Reserve_Batch_Orders__() to pass new parameter planned_due_date_ to Customer_Order_Shortage_API.Remove_All().
--  201109  RasDlk   SCZ-11538, Modified Reserve_Line_At_Location___() to call Check_Release_For_Mtrl_plan___() when Rel_Mtrl_Planning option is not set to Rel_Mtrl_Planning_API.DB_NOT_VIS_PLANNED_RELEASED.
--  201103  SBalLK   Bug 156289(SCZ-11488), Added Modify_Cost_After_Reserve___() method with new interface and modified Reserve_Manually_Impl__(), Unregister_Arrival___()
--  201103           and Create_Arrival_Reservations___() method to call new method interface.
--  201108  RasDlk   SCZ-11837, Modified Get_Full_Reserved_Pkg_Qty() by passing pick_list_no_ so that it could be skipped from the calculation. New cursor get_location_group was added to find the multiple location groups.
--  201013  RasDlk   SCZ-11813, Modified Get_Expiration_Control_Date___() to get the correct minimum remaining days at CO delivery from the sales part cross reference.
--  200421  ErFelk   Bug 153086(SCZ-8893), Modified Reserve_Manually_Impl__() by moving the code to check Availability_Control_Id to a different place so that negative reservations are not alowed.
--  200219  ErFelk   Bug 151855(SCZ-8371), Modified Unregister_Arrival___() to handle qty_on_order(pegged qty) when the reservation does not exist.
--  200214  ThKrLk   Bug 151123(SCZ-7988), Modified Reserve_Manually_ to allow unreserving when the Customer Order is blocked.
--  191219  KiSalk   Bug 151355(SCZ-8032), Rewrote cursor find_printed_pick_lists in Any_Pick_List_Printed to fetch data for Consolidated pick lists.
--  191023  SBalLK   Bug 150436 (SCZ-6914), Marked Execute_Transport_Task_Line() method as Deprecated.
--  191011  ErFelk   Bug 149961(SCZ-6400), Modified Reserve_Manually_Impl__() by adding a code to set the Rel_Mtrl_Planning flag if it is FALSE.
--  190916  DiKulk   Bug 149962 (SCZ-6907), Modified Unreserve_Cust_Order_Lines__() to use Get_Part_Ownership_Db() to be compatible with all languages.
--  190820  ApWilk   Bug 149508, Modified Get_Expiration_Control_Date___() to fetch the Minimum Remaining Days at CO Delivery using Deliver to Customer.
--  190711  ErFelk   Bug 143629, Modified Move_With_Trans_Task__() by adding execution_offset. 
--  190530  AsZelk   Bug 148245(SCZ-4637), Modified Check_Reserve_Package___() to allow reserve package part when backorder option in CO is set to "Incomplete Lines Not Allowed"
--  190530           or "No Partial Deliveries Allowed".
--  190524  KiSalk   Bug 148393(SCZ-4896), Created new functions Man_Res_Valid_Ext_Service___, Man_Res_Valid_Ownership___ and Check_Man_Reservation_Valid. 
--  190524           Rewritten Man_Res_Valid_Ext_Service__ and Man_Res_Valid_Ownership__ using new methods. Check_Man_Reservation_Valid
--  190524           is a combination of Man_Res_Valid_Ext_Service__ and Man_Res_Valid_Ownership__, to reduce repeated access of customer_order_line_tab.
--  190517  ChJalk   Bug 147450(SCZ-3924), Modified the method Get_Available_Qty to change the name of the parameter is_customer_order_ to is_order_.
--  190329  MaEelk   SCUXXW4-18093, Added Get_Avail_Qty_For_Quotation in order to avoid dynamic Component Dependency in Sales Quotation Line Tab.
--  190515  KiSalk   Bug 145799(SCZ-2321), Modified Get_Available_Qty and Get_Available_Pkg_Qty__  so that the Project connected package component lines calculate available qty from Project Inventory.
--  181030  UdGnlk   Bug 143922, Modified Consume_Peggings() qty_on_order_ calculation to make it 0 when less than 0 quantity calculated.
--  181030           Modified Consume_Peggings() by introducing new temporaly variable temp_con_qty_on_order_ and changed the condition to update Customer_Order_Pur_Order_TAB.
--  181024  ErFelk   Bug 144695, Modified Reserve_Lines___() by adding qty_assigned to a condition so that it checks the full quantity reserved.
--  181015  ChBnlk   Bug 144721, Modified Reserve_Manually_Impl__() by adding a condition to checked the qty_to_reserve_ in order to allow unreserving
--  181015           even if the customer is credit blocked. 
--  180807  UdGnlk   Bug 142077, Modified Reserve_Line_At_Location___() to ignore availability control ID for external repair order when reserving.
--  180720  ErFelk   Bug 142166, Modified cursor get_lines_to_reserve in Reserve_Lines___() by removing qty_on_order from the equation.
--  180514  SBalLK   Bug 141701, Modified Entire_Order_Reserved__() method to validate reservation and backorder option separately using separate cursors.
--  180301  LEPESE   STRSC-16569, Pass TRUE in the manual_reservation_ parameter when calling Inventory_Part_In_Stock_API.Reserve_Part
--  180301           from Execute_Transport_Task_Line. Also put the call withing anonymous PL block to have generic error message EXTTUNABLETORES.
--  180223  JoAnSe   STRMF-17812, Replaced call to Shop_Ord_API.Modify with Shop_Ord_API.Modify_Pegging_From_Demand in Feedback_From_Manufacturing.
--  180223  KHVESE   STRSC-15956, Modified method Reserve_Cust_Ord_Manually___.
--  180221  KhVese   STRSC-17267, Modified Reserve_Manually_Impl__ to skip error QTYOVERRIDES and QTYOVERRIDESSHP When unpacking from HU. 
--  180212  JeLise   STRSC-16913, Added pick_by_choice_blocked in call to Customer_Order_Reservation_API.Modify_Qty_Assigned.
--  171220  RuLiLk   Bug 137426, Modified method Reserve_Manually_Impl__ to raise different error message if the credit block is for the parent customer.
--  180125  KHVESE   STRSC-16110, Modified methods Reserve_Manually_Impl__ and Reserve_Manually__ to exclude check for customer order/credit blocked when operation is pick by choice or move reserve.
--  180123  ChFolk   STRSC-16009, Modified Move_With_Trans_Task__ to check the reserved record count greater than zero to be moved with transport task. 
--  180119  KHVESE   STRSC-15892, STRSC-8813, Modified method Report_Line_Reservation___.
--  171226  MaRalk   STRSC-15399, Replaced Customer_Order_Reservation_API.Get_Pick_By_Choice_Blocked_Db instead of
--  171226           Customer_Order_Reservation_API.Get_Pick_By_Choice_Blocked in Reserve_Manually_Impl__.
--  171213  Chfolk   STRSC-14821, Renamed variable exclude_complete_hu_reserv_ as exclude_hu_to_pick_in_one_step_ and parameter EXCLUDE_COMPLETE_HU_RESERV
--  171213           as EXCLUDE_HU_TO_PICK_IN_ONE_STEP.
--  171213  ChFolk   STRSC-14898, Removed method Validate_Move_Co_Reserv_Stock as the usage of it is replaced with Reserve_Shipment_API.Validate_Move_With_Trans_Task.
--  171213           Modified Move_With_Trans_Task__ to use a common method  Reserve_Shipment_API.Move_Res_With_Trans_Task.
--  171129  DAYJLK   STRSC-13921, Modified Reserve_Line_At_Location___ by adding value for parameter reserve_from_transp_task_db_ in call 
--  171129           to Inventory_Part_In_Stock_API.Find_And_Reserve_Part.
--  171120  ChFolk   STRSC-14444, Modified Move_With_Trans_Task__ to replace usage of Transport_Task_Line_API.Reservation_Booked_For_Transp with new attribute value on_transport_task. 
--  171115  RoJalk   STRSC-14229, Modified Reserve_Cust_Ord_Manually___ and included NVL handling when calling Validate_On_Rental_Period_Qty. 
--  171110  UdGnlk   Bug 138257, Modified Get_Full_Reserved_Pkg_Qty() calculation of qty_to_pick_ with conv_factor considering the brackets
--  171107  LEPESE   STRSC-14169, Added call to Inv_Part_Stock_Reservation_API.Move_New_With_Transport_Task from Report_Line_Reservation___.
--  171106  RaVdlk   Moved the method Unreserve_Cust_Order_Lines__ to the LU specific private methods section 
--  171106  RaVdlk   STRSC-14008, Modified message constant ESONOSERIALCODE to DIFFLOTBATCHNO and to DIFFSERIALNO to avoid overriding of language translations and 
--                   added Raise_Reservation_Error___ procedure for the message constant RESERVENOTALLOWED, Raise_Wrong_Loc_Error___ procedure for WRONGLOCTYPE, 
--                   procedure Raise_Qty_Reservation_Error___for DONTREDUCEQTYRES and procedure Raise_Part_Reserve_Error___ for AVAILIDMANRES.                
--  171031  ChBnlk   STRSC-13798, Added new method Unreserve_Cust_Order_Lines__() in order to unreserve the total quantity reserved for a customer order line. 
--  171030  RasDlk   Bug 133794, Modified Feedback_From_Manufacturing() by adding a method call to revalidate the customer order's find and connect
--  171030           when the part structure has changed within the shop order.
--  171030  AsZelk   STRSC-11461, Modified Check_Reserve_Package___ in order to fix the Customer Quick Order Flow handling issue.
--  171026  JeLise   STRSC-13216, Added pick_by_choice_blocked_ in call to Customer_Order_Reservation_API.New in Execute_Transport_Task_Line.
--  171025  JeLise   STRSC-13216, Added pick_by_choice_blocked_ in Make_CO_Reservation.
--  171017  ChFolk   STRSC-12120, Modified Move_With_Trans_Task__ to use Has_Stock_On_Transport_Task and Has_Immovable_Stock_Reserv methods from Handling_Unit_API 
--  171013  ChFolk   STRSC-12120, Modified Move_With_Trans_Task__ to check whether the full handling unit structure is possible to move with the move reserved stock 
--  171013           parameter when include_full_qty_of_top_handling_unit is selected. Aslo did some performance improvements when checking root_handling_unit informations.
--  171012  Chfolk   STRSC-12120, Modified Move_With_Trans_Task__ to move part of join from view to business logic to get better performance.
--  171009  NiLalk   Bug 137860, Modified Entire_Order_Reserved__ method by adding a new init_shipment_creation parameter and modified cursor conditions to exclude reservation of NO,PRJ 
--  171009           and SEO supply code lines during the shipment creation process.
--  171004  ChFolk   STRSC-12120, Modified Move_With_Trans_Task__ to support selection of exclude_complete_hu_reserv_ and added site level filteration on
--  171004           move reserved option when creating trasport tasks for the reservations.
--  171003  JeLise   STRSC-12327, Added pick_by_choice_blocked_ in Reserve_Cust_Ord_Manually___, Reserve_Manually_Impl__ and Reserve_Manually__.
--  170929  ChFolk   STRSC-12120, Modified Validate_Move_Co_Reserv_Stock to support storage_zone and some modification on include_full_qty_of_top_hu_ is checked.
--  170928  ChFolk   STRSC-12120, Modified Move_With_Trans_Task__ to support move top handling unit with trasport task when include_full_qty_of_top_hu_ is checked.
--  170927  ChFolk   STRSC-12120, Renamed method Move_Co_Res_With_Trans_Task___ as Move_With_Trans_Task__ as implementation method is not supported by Deferred_Call.
--  170927           Added logic inside Move_With_Trans_Task__ to support creation of transport tasks for the selected reservations.
--  170927  RaVdlk   STRSC-11152, Removed Customer_Order_Line_API.Get_State__() and replaced with Customer_Order_Line_API.Get_State ()
--  170922  Chfolk   STRSC-12119, Added new methods Move_Co_Res_With_Trans_Task__, Move_Co_Res_With_Trans_Task___ and Validate_Move_Co_Reserv_Stock to support with 
--  170922           move reserved stock with transport task batch job.  
--  170906  ChFolk   STRSC-9122, Modified method Reserve_Manually_Impl__ to not to add customer order line history lines when moving the reserved stock at inventory.
--  170810  AsZelk   Bug 137162, Modified Reserve_Manually__() in order to disallow the reservation when the substitute part has been changed by another user.
--  170724  Hapulk   STRSC-11013, Renamed Temporary table SHIP_CONN_RESERVED_ORD_TEMP to align with naming convention.
--  170706  MeAblk   Bug 136431, Modified Reserve_Lines___() and Reserve_Lines__() to move the backorder validation to be done after the reservation are done. Accordingly modified the impacted methods.
--  170624  NiNilk   Bug 134026, Modified Get_Full_Reserved_Pkg_Qty() by adding warehouse to the where clause in cursor get_qty_in_picklist to create picklists for all different warehouses
--  170624           when component parts of a package part are reserved at different warehouses and added warehouse_ to the parameter list.
--  170525  MeAblk   Bug 135713, Modified Reserve_Manually_Impl__() to correctly credit block the external CO when processing the internal CO having manually blocked the external customer in an inter-site flow.
--  170512  RoJalk   LIM-11437, Modified Reserve_Line_At_Location___ and added a condition to exit when qty_left_to_be_reserved_ less or equal to 0.
--  170512  UdGnlk   LIM-9668 Added parameter reservation_operation_id_ to Make_CO_Reservation(), Reserve_Manually__(), Reserve_Manually_Impl__() and
--  170512           Reserve_Cust_Ord_Manually___() to avoid validation for rental objects when moving reserved parts.
--  170427  KhVese   STRSC-7211, Modified method Make_CO_Reservation and removed public method Reserve_Manually().
--  170421  NiAslk   STRSC-7369, Modified Reserve_Manually__ to avoid Blocked customer orders from being reserved.
--  170308  MaEelk   LIM-10887, Added parameter handling_unit_id_ to the  method Execute_Transport_Task_Line. If the part was unattched from the HU during the move,
--  170308           handling_unit_id_ would be taken as zero. 
--  170308           If it is not attached to the handling unit reservations should be made with handling unit id 0. 
--  170308  TiRalk   STRSC-6472, Modified Reserve_Line_At_Location___ to pass serial_no and lot_batch_no correctly when its a external service order.
--  170306  MaEelk   LIM-10889. Modified Execute_Transport_Task_Line and passed TRUE value to transport_task_executed_ in the call to Customer_Order_Reservation_API.Remove.
--  170217  MaEelk   LIM-10889, Modified Execute_Transport_Task_Line to increase the quantity assigned when the To Location already exists with a customer order reservation.
--  170306  MaEelk   LIM-10889, Modified Execute_Transport_Task_Line and passed TRUE value to transport_task_executed_ in the call to Customer_Order_Reservation_API.Remove.
--  170217  MaEelk   LIM-10489, Modified Execute_Transport_Task_Line to increase the quantity assigned when the To Location already exists with a customer order reservation.
--  170217  KHVESE   LIM-10240, Removed methods Find_Reservations__, Reset_Reservations__, Have_Enough_Qty_To_Pick__, Unreserve_Stock__, 
--  170217           Find_And_Reserve_Stock__, Reserve_Stock__, Have_Quantity__, Get_Reserved_Stock_Content__ and Unreserve_Handling_Unit__.
--  170208  MaEelk   LIM-10889, Added Execute_Transport_Task_Line. This would remove the Customer Order Reservation to the previous location where the Transport Task was created, 
--  170208           and make a new Customer Order Reservation to the new location.
--  170206  NiLalk   Bug 133651, Modified Register_Arrival___ by repositioning Create_Arrival_Reservations___ method call after Customer_Order_Line_API.Modify_Qty_On_Order to  
--  170206           update the qty_on_order prior to calculate qty_short in Customer_Order_Line_API.
--  170113  KHVESE   LIM-10241, Modified method Make_CO_Reservation.
--  170103  KHVESE   LIM-10136, LIM-10129, LIM-9517, Moved Method Pick_And_Adjust_Reservation to PickCustomerOrder LU and renamed to Pick_By_Choice.
--  170103           Removed implementation methods Pick_New_Reservation___ and Pick_And_Adjust_Reservation___ and public method Unreserve_Manually() and merged the logic into Pick_By_Choice() method.
--  170103           Changed methods Reset_Reservations___, Have_Enough_Qty_To_Pick___ and Find_Reservations___() to private methods and modified cursor in Find_Reservations__.
--  170103           Removed method Make_Stock_Reservation___ and instead added private methods Find_And_Reserve_Stock__, Reserve_Stock__ and Unreserve_Stock__.
--  170103           Changed method Make_CO_Reservation___ to public method AND modified the logic.
--  161222  KhVese   LIM-9517, Modified methods Pick_And_Adjust_Reservation___ and Make_CO_Reservation and removed method Make_Additional_Reservation().
--  161208  SeJalk   STRSC-4497, Allowed re reservations for supply types SO and DOP from reserve customer order windows if manually unreserved from customer order.
--  161208  SeJalk   Bug 131992, Modified Reserve_Line_At_Location___ to set project info if demand code is project inventory and supply codes are in PT and IPT.
--  161130  Asawlk   LIM-9921, Added method Reserve_Manually().
--  161128  ChBnlk   STRSC-4284, Added new method Check_Available_To_Reserve() to see whether a perticular part can be reserve at the time of the customer 
--  161128           order entry.
--  161124  KhVese   LIM-5833, Modified methods Reserve_Handling_Unit__, Unreserve_Manually_Handl_Unit.
--  161103  KhVese   LIM-9406, Added methods Reserve_Handling_Unit__, Unreserve_Manually_Handl_Unit.
--  161101  KhVese   LIM-5833, Modified method Find_Reservations___ and call to it.
--  161019  MaRalk   STRSC-4502, Removed unnecessary conditional compilation for INVENT module inside Find_Reservations___ method.
--  161006  KhVese   LIM-5832, Added pick_list_no_ with default * to the methods Report_Line_Reservation___ and Reserve_Manually_Impl__ and Reserve_Manually__ interface and modified the methods respectively
--                   Added inv part stock key and pick list number as default parameter to Reserve_Line_At_Location___ and Reserve_Order_Line__ and modified the methods respectively
--                   Added implementation method Make_Additional_Reservation___ and moved the code from method Make_Additional_Reservations__ to implementation method. 
--                   Added public method Make_Additional_Reservation with call to implementation method to be used in process move reserved part. 
--  160929  LEPESE   LIM-8882, Added value for parameter handling_unit_id_ in call to method Inventory_Part_In_Stock_API.Get_Serial_No_For_Stock.
--  160905  KhVese   LIM-5832, Modified Make_Additional_Reservations__. 
--  160901  RasDlk   Bug 131131, Modified Consume_Peggings and Consume_So_Peggings to update the license coverage quantities correctly when a purchase order and a shop order
--  160901           is pegged into a customer order respectively.
--  160901           Modified Unconsume_Peggings to update the license coverage quantities correctly when a purchase order is unpegged from a customer order.
--  160831  ChJalk   Bug 130966, Modified Reserve_Order___ to add order_no_ into the message RESERVMISSING. Modified Reserve_Batch_Orders__, Reserve_Customer_Order__, Batch_Reserve_Orders__, Reserve_Order__ and Reserve_Lines___ to 
--  160831           run the shipment flow after all the reservations have been done for the batch process 'Create Customer Order Reservations'.
--  160819  ErFelk   Bug 129961, Modified Reserve_Manually__() and Reserve_Manually_Impl__() by adding an error message CANNOTRESERVED to stop reservation for
--  160819           Delivered and Closed Customer Order Lines.
--  160726  MaEelk   LIM-6499, Added methods Get_Co_Reservation_Keys_For_Hu, Get_Order_No, Get_Line_No, Get_Rel_No, Get_Line_Item_No, Get_Shipment_Id and Get_Qty_Assigned 
--  160726           to fetch key values and quantity assigned to a  handling unit in a particular pick list.
--  160720  Chfose   LIM-7517, Added inventory_event_id to Split_Package_Reservations to combine multiple calls to Customer_Order_Reservation_API within a single inventory_event_id.
--  160714  SudJlk   STRSC-1959, Modified Validate_Params to check validity for order coordinator.
--  160629  TiRalk   STRSC-2702, Changed the places where it has used CreditBlocked from CustomerOrder has changed to state Blocked.
--  160524  MaIklk   LIM-7364, Moved Reserve_Manually_HU__, Unreserve_Manually_HU__ and Generate_Man_Res_HU_Snapshot to Shipment_Handling_Unit_API.
--  160308  RoJalk   LIM-4108, Added the method Reserve_Shipment_Pkg_Comp___ and called from Reserve_Package_Components___,
--  160308           Reserve_Complete_Package___. Called Shipment_Handling_Utility_API.Modify_Qty_To_Ship_Source_Line from Reserve_Non_Inventory___. 
--  160503  Chfose   LIM-7319, Added shipment_id to Generate_Man_Res_HU_Snapshot to correctly filter the view.
--  160412  Chfose   LIM-6145, Added methods Man_Res_Valid_Ext_Service & Man_Res_Valid_Ownership__ to support new view Manual_Reservation_CO
--  160412           and extracted validation from Generate_Man_Res_HU_Snapshot & client into the new view.
--  160331  Chfose   LIM-6146, Added methods Reserve_Manually_HU___ & Unreserve_Manually_HU___ & Reserve_Manually_HU___.
--  160315  Chfose   LIM-6145, Added method Generate_Man_Res_HU_Snapshot.
--  160315  SBalLK   Bug 127969, Modified Reserve_Order_Line__() method by Adding condition to validate the actual reservation completed against the customer order line before update the
--  160315           reserve quantities in the line to avoid activate of the finite state machine for state change.
--  160309  MaRalk   LIM-5871, Modified Reserve_Complete_Package___, Reserve_Package_Components___ 
--  160309           to reflect shipment_line_tab-sourece_ref4 data type change
--  160304  RoJalk   LIM-4106, Replaced shipment_line_tab with shipment_line_pub.
--  160226  RoJalk   LIM-4637, Replaced Shipment_Source_Utility_API.Get_Line_Qty_To_Reserve with Shipment_Line_API.Get_Qty_To_Reserve.
--  160226  RoJalk   LIM-4178, Called Shipment_Order_Utility_API.Start_Shipment_Flow from Reserve_Lines___.
--  160219  MaIklk   LIM-4134, Removed Reserve_Shipment_Lines__() since it used by finalize shipment.
--  160218  RoJalk   LIM-4631, Shipment_Line_API.Get_Shipment_To_Reserve/Get_Shipments_to_Reserve 
--  160218           with Shipment_Order_Utility_API.Get_Shipment_To_Reserve/Get_Shipments_to_Reserve.
--  160218  RoJalk   LIM-4637, Replaced Shipment_Line_API.Get_Qty_To_Reserve with method Shipment_Source_Utility_API.Get_Line_Qty_To_Reserve.
--  160211  MaIklk   LIM-4110, Removed Picked_Component_Exist___().
--  160211  MaIklk   LIM-4105, Removed Clear_Unpicked_Shipment_Res__() since Finalize Shipment will be obsoleted.
--  150201  RoJalk   LIM-5911, Added Source_Ref_Type to Shipment_Line_API.Get_Qty_To_Reserve call.
--  150128  MaIklk   LIM-4148, Added source_ref_type condition for the where clauses in Reserve_Shipment_Lines__().
--  160128  RoJalk   LIM-5911, Replaced Shipment_Line_API.Get_Qty_To_Ship with Shipment_Line_API.Get_Qty_To_Ship_By_Source.
--  160116  LEPESE   LIM-3742, added method Report_Line_Reservation___ and moved logic from Reserve_At_Line_Location___ into this new method.
--  160116           Redesigned the reservation logic inside of Reserve_At_Line_Location___ to use a new version of 
--  160116           Inventory_Part_In_Stock_API.Find_And_Reserve_Part which returns a collection of stock record keys and quantitites reserved.
--  160111  RoJalk   LIM-5524, Included Source_Ref_Type when calling Shipment_Line_API.Unreserve_Non_Inventory, Shipment_Line_API.Modify_Qty_To_Ship
--  160105  RoJalk   LIM-4632, Added Source_Ref_Type to the method Shipment_Line_API.Reserve_Non_Inventory.
--  160105  PrYaLK   Bug 125877, Modified methods Reserve_Complete_Package___, Complete_Package___, Check_Package___, Check_Reserve_Package___ and Check_Reserve_Package_Comp___
--  160105           to handle part reservations for supply_codes PI and PRJ.
--  151202  RoJalk   LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202           SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151119  RoJalk   LIM-4886, Make Shipment Line Generic - Rename SALES_QTY to SHIPMENT_QTY, REVISED_QTY_DUE to INVENTORY_QTY.
--  151106  Chfose   LIM-4454/LIM-4455, Removed pallet_id from code related to CO_SUPPLY_SITE_RESERVATION & SOURCE_CO_SUPPLY_SITE_RES.
--  151112  MaEelk   LIM-4453, Removed pallet_id from CustomerOrderReservation related logic.
--  151105  UdGnlk   LIM-3746, Removed Inventory_Part_Loc_Pallet_API method calls since INVENTORY_PART_LOC_PALLET_TAB will be obsolete. 
--  151103  UdGnlk   LIM-3671, Modified Reserve_Manually_Impl__() by removing the pallet related logic since pallet entity will be obsolete.
--  151029  JeLise   LIM-4351, Removed calls to Mpccom_System_Parameter_API.Get_Parameter_Value1('PALLET_HANDLING'), 
--  151029           Inventory_Part_API.Pallet_Handled and Inventory_Part_Loc_Pallet_API.Find_And_Reserve_Pallet in Reserve_Line_At_Location___
--  151019  Chfose   LIM-3893, Removed pallet location types in calls to Inventory_Part_In_Stock_API.Get_Inventory_Quantity & Inventory_Part_In_Stock_API.Get_Avail_Plan_Qty_Loc_Type.
--  150602  JeLise   LIM-2983, Added handling_unit_id as parameter in Reserve_Supply_Site_Man___, Reserve_Src_Supply_Site_Man__, Reserve_Cust_Ord_Manually___,
--  150602           Handle_Project_Reservations___, Reserve_Manually_Impl__ and Reserve_Manually__.
--  150505  LEPESE   LIM-2861, added handling_unit_id as parameter to several methods and passed in calls to other packages.
--  150424  Chfose   LIM-1781, Modified calls to Customer_Order_Reservation to include handling_unit_id and make the file compile.
--  150420  UdGnlk   LIM-142, Added handling_unit_id as new key column to Co_Supply_Site_Reservation_Tab therefore did necessary changes.
--  150420           Modified method calls of Sourced_Co_Supply_Site_Res_API as new key column handling_unit_id is added.
--  150416  MaEelk   LIM-1071, Added dummy parameter handling_unit_id_ 0 to the Inventory_Part_In_Stock_API and Inventory_Part_Loc_Pallet_API.
--  150407  MaEelk   LIM-1071, Added dummy parameter handling_unit_id_ 0 to the method call Inventory_Part_In_Stock_API.Get_Expiration_Date, Inventory_Part_In_Stock_API.Get. 
--  150407           Inventory_Part_In_Stock_API.Get_Availability_Control_Id and Inventory_Part_In_Stock_API.Get_Location_Type_Db . 
--  150407           handling_unit_id_ will be implemented as a key in InventoryPartInstock LU.
--  150915  NaSalk   AFT-4649, Modified Get_Available_Qty to add rental_db parameter.
--  150911  RoJalk   AFT-1676, Modified get_shipment_qty_to_reserev cursor in Reserve_Order_Line__ to handle pegged qty.
--  150812  BhKalk   RED-672, Modified Get_Available_Qty() to have sum of CRA and SR stocks when the ownership is CRA.
--  150713  JaBalk   RED-638, Modified Create_Reservations__ to send the activity_seq_ if the supply code is 'PI'.
--  150619  JaBalk   RED-557, Modified the condition Entire_Order_Reserved__ to Line_Is_Fully_Reserved.
--  150605	JaBalk   RED-361, Modified Create_Reservations__ to send the rental transfer value to by pass the stop of order type.
--  150526  JaBalk   RED-361, Added Create_Reservations__ to reserve the order line and deliver it.
--  150817  RasDlk   Bug 120649, Modified Check_Export_Controlled___ to set the licensed_order_type_ correctly.
--  150721  MeAblk   Bug 123685, Modified method Register_Arrival___ in order to avoid run the check for credit block when the customer order in Planned state.
--  150526  MeAblk   Bug 122747, Modified method Register_Arrival___ in order to avoid run the check for credit block when the customer order in Delivered or Invoiced states.
--  150210  NaSalk   PRSC-5080, Modified Get_Available_Qty to consider company rental assets when supply code is IPT.
--  150129  Cpeilk   PRSC-5118, Added new method Check_Before_Reserve___ to prevent manual reservations for incorrect ownerships from different sessions.
--  150127  NaSaLK   PRSC-5080. Modified Reserve_Line_At_Location___ to to give priority to CRA ownerships
--  150127           for supply site reservations.
--  150119  RoJalk   PRSC-2006, Modified Get_Full_Reserved_Pkg_Qty to consider conversion factors for  qty_to_pick_ calculation.
--  141212  Chfose   PRSC-434, Modified Get_Available_Pkg_Qty__ to consider conv factor when calculating the qty.
--  141204  MAHPLK   PRSC-409, Modified Reserve_Line_At_Location___, Reserve_Complete_Package___, Complete_Package___, and 
--  141204           Check_Package___ methods to raise the reservation_info_ when online execution.
--  140930  AyAmlk   Bug 118958, Modified Reserve_Manually__() by clearing current_info_ global variable defined in the Customer_Order_Line_API in order to prevent raising info
--  140930           messages that were raised in the previous transaction.
--  140829  AyAmlk   Bug 115977, Modified Register_Arrival___() and Consume_Peggings() in order to run the credit check for the CO at reservation when receiving the pegged object.
--  140819  AyAmlk   Bug 118321, Modified Consume_Peggings() so that the Customer Order will be reserved when the pegged Purchase Order is received, regardless of the Credit block.
--  140731  MeAblk   Removed activity_seq_ parameter from the method call Shortage_Demand_API.Calculate_Order_Shortage_Qty.
--  140508  Chsllk   PBSA-6610, Modified Reserve_Manually__ to cancel work order when reserved qty is less than zero.
--  140409  AndDse   PBMF-6215, Modified Control_Ms_Mrp_Consumption, added activity_seq_ as inparameter. Online consumption is only supported when using standard master scheduling (not project ms).
--  140409  RoJalk   Modified the methods Reserve_Complete_Package___, Reserve_Package_Components___ and aligned the logic with co line cursors not connected to shipment.
--  140402  RoJalk   Modified the methods Reserve_Complete_Package___, Reserve_Package_Components___ and specified supply codes in cursors handling shipment qty.
--  140321  TiRalk   Bug 116024, Modified Get_Available_Pkg_Qty__ to get the available quantity correctly for component parts when sales part has a different invetory part id.
--  140325  AndDse   PBMF-4700, Merged in LCS bug 113040, Modified Control_Ms_Mrp_Consumption() method to use conditional compilation and to pass order_line_cancellation_ parameter to the call
--  140325           Level_1_Forecast_Util_API.Control_Consumption().
--  140227  KiSalk   Bug 115639, Modified Consume_Peggings and Consume_So_Peggings to reserve manually pegged lines with serial no *, when part is serialized but not in-inventory tracked. 
--  140211  FAndSE   BI-3417: Unregister_Arrival is refined: order by using CASE instead of DECODE, the variable shipment_to_unreserv removed and replaced nby rec_.shipment_id.
--  140207  FAndSE   BI-3417: Changes in Unregister_Arrival to avoid infinte loop, now only possible to unreserve from any shipment_ID if it is within the same stock record key and order line key.
--  140205  FAndSE   BI-3442: The validation for what you can reserve was incorrect in Reserve_Manually_Impl__, now alligned with how Qty to Reserve is calculated in the client via the ORDER_LINE_SHIP_JOIN view.
--  140310  MADGLK   PBSA-5675 Removed PCM references.
--  131227  NipKlk   Bug 114428, Used the variable qty_reserved_ in the check for updating the pegged quantity in the method Consume_Peggings() to make the pegged amounts 
--  131227           update correctly when full amount is received from a single receipt, and a CO is pegged FROM multiple POs.
--  131126  NaSalk   Modified Consume_Peggings method to include company rental assets. 
--  131025  Vwloza   Added rental parameter to method calls in Create_Supply_Site_Reserve__, Create_Instant_Reservation__, Is_Supply_Chain_Reservation.
--  131010  Vwloza   Updated Consume_Peggings with Rental condition.
--  131004  KaNilk   Modified Reserve_Line_At_Location___ method.
--  130903  PraWlk   Bug 112184, Reversed the correction done for bug 111320. Modified Consume_Peggings() by passing the activity_seq_ coming from PO 
--  130903           when calling Inventory_Part_In_Stock_API.Get() and Register_Arrival___().
--  130823  SeJalk   Bug 111257, Added Supply code 'PI' to cursor in methods Reserve_Complete_Package___, Complete_Package___, Check_Package___ and Check_Reserve_Package___.
--  130716  SWiclk   Bug 111320, Modified Consume_Peggings() in order to set the activity sequence no to zero when supply code is not 'PI' or 'PRD'.  
--  130613  ErFelk   Bug 110286, Modified Get_Full_Reserved_Pkg_Qty() by adding location group as a parameter and modified get_qty_in_picklist cursor
--  130613           by joining warehouse_bay_bin_tab to get the location_group.
--  130802  RoJalk   In Create_Arrival_Reservations___ moved the call Customer_Order_API.Set_Line_Qty_Assigned below the LOOP because Shipment_Order_Line_API.Get_Shipment_To_Reserve refer to co qty.
--  130731  MaEelk   Removed old package structure related messges from Reserve_Manually_Impl__ 
--  130128  RoJalk   Modified Create_Arrival_Reservations___ and modified parameters in Shipment_Order_Line_API.Get_Shipment_To_Reserve to indicate that it is called from pegged order. 
--  130117  MaMalk   Called the new method in Shipment_Flow_API to trigger the Shipment flow in Reserve_Lines___.
--  120117           Also removed the triggering process from Reserve_Order_Line__. 
--  130109  RoJalk   Modified Picked_Component_Exist___ and passed the shipment id.
--  130107  MeAblk   Modified Reserve_Shipment_Lines__ by replacing the method call Customer_Order_Reservation_API.Get_Total_Qty_Picked by Shipment_Order_Line_API.Get_Qty_Picked. 
--  130107  RoJalk   Modified Clear_Unpicked_Shipment_Res__ and fetched qty picked from shipment order line.
--  121219  MeAblk   Modified method Reserve_Shipment_Lines__ by replacing the function call Customer_Order_Reservation_API.Get_Total_Qty_Assigned by Shipment_Order_Line_API.Get_Qty_Assigned.
--  121214  RoJalk   Modified the cursor get_shipment_qty_to_reserev in Reserve_Order_Line__.
--  121212  RoJalk   Modified Unregister_Arrival___ and did some further corrections to support multiple shipments per order line.
--  121211  RoJalk   Modified Reserve_Non_Inventory___ and modified the shipment id parameter to be NOT NULL.
--  121207  RoJalk   Modified Consume_Peggings, Unconsume_Peggings and called Shipment_Order_Line_API.Reserve_Non_Inventory/Unreserve_Non_Inventory to update qty_to_ship in shipment order line.
--  121206  RoJalk   Modified Unregister_Arrival___ to unregister first for order line and then for shipments.
--  121205  RoJalk   Modified Clear_Unpicked_Shipment_Res__ to support the connecting a customer order line to several shipment lines. 
--  121130  MeAblk   Modified method Reserve_Shipment_Lines__ in order to handle the shipment connected qty when finalizing the shipment(RMB option).
--  121128  RoJalk   Modified Unregister_Arrival___, Create_Arrival_Reservations___ to support multiple shipments for CO line for pegged objects. 
--  121122  RoJalk   Modified Reserve_Shipment_Lines__ to pass the shipment id to the Reserve_Inventory___ method.
--  121120  MeAblk   Modified methods Reserve_Inventory___, Reserve_Non_Inventory___, Reserve_Package_Components___, Reserve_Complete_Package___ in order to handle the shipment connected quantities when 
--  121120           reserving shipment connected with package part lines.
--  121119  RoJalk   Modified Reserve_Line_At_Location___ and called Shipment_Order_Line_API.Get_Shipment_To_Reserve only when it is not a supply 
--  121119           site reservation/sourcing reservation and shipment id is not passed to the method.
--  121115  RoJalk   Modified Reserve_Line_At_Location___ and called Shipment_Order_Line_API.Get_Shipment_To_Reserve only when shipment_id_= 0.
--  121115  RoJalk   Modified Reserve_Line_At_Location___ and removed the default null for shipment id parameter.
--  121115  RoJalk   Modified Reserve_Order_Line__ and passed resrevable qty per shipment to Reserve_Line_At_Location___ if resrvation is done per shipment.
--  121114  RoJalk   Modified Get_Min_Due_Date_For_Unpicked,Get_Min_Ship_Date_For_Unpicked and added the condition r.shipment_id  = 0.
--  121031  RoJalk   Allow connecting a customer order line to several shipment lines - Modified the method calls to Customer_Order_Reservation_API by 
--  121031           adding shipment id. Removed the methods Serial_Delivered_On_Order_Line, Clear_Unpicked_Shipment_Res__, Check_No_Backorders__.
--  121031           Modified Reserve_Line_At_Location___  and changed the reservation logic to reserve for connectd shipment lines and then for the order line.
--  121031           Added shipment_id_ parameter to the Reserve_Order_Line__, Make_Additional_Reservations__ , Reserve_Manually_Impl__,Reserve_Manually__ , Unpicked_Picklist_Exist__,
--  121031           Reserve_Package__, Reserve_Line_At_Location___  Reserve_Complete_Package___  Reserve_Cust_Ord_Manually___.   
--  120918  MHAPLK   Modified Reserve_Lines___ to trigger shipment process for order line connected shipments when customer order reserve.
--  120711  MaHplk   Added picking lead time as parameter to Inventory_Part_In_Stock_API.Make_Onhand_Analysis.
--  130826  Nuwklk   Modified Reserve_Manually__ method.  
--  130815  KaNilk   Modified Reserve_Manually__ method.  
--  130606  NaLrlk   Aded method Validate_On_Rental_Period_Qty() to validate unreserve quantity when rental period exist.
--  130219  CHRALK   Modified Reserve_Cust_Ord_Manually___(), by adding rental quantity validation.
--  130710  MaRalk   TIBE-1014, Removed following global LU constants and modified relevant methods accordingly.
--  130710           inst_Level1ForecastUtil_ - Control_Ms_Mrp_Consumption, inst_SparePartForeCUtil_ - Control_Ms_Mrp_Consumption, 
--  130710           inst_PurOrdChargedComp_ - Reserve_Line_At_Location___, inst_PurOrderExchangeComp_ - Reserve_Line_At_Location___, 
--  130710           inst_PurchaseOrderLine_ - Create_Priority_Reservation__, inst_PurchaseOrderLinePart_ - Reserve_Line_At_Location___,
--  130710           inst_Project_ - Handle_Project_Reservations___, inst_ProjectReservedMatUtil_ - Handle_Project_Reservations___.
--  130508  KiSalk   Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  130503  AyAmlk   Bug 109675, Modified Get_Available_Pkg_Qty__() by changing the get_inventory_line CURSOR to include DOP line qty when calculating the available qty.
--  130222  Dinklk   EIGHTBALL, Modified Reserve_Manually_Impl__ to increase the qty_on_order of the CO Line by the amount unreserved.
--  130220  Dinklk   EIGHTBALL, Modified Reserve_Manually_Impl__ to block new reservation IF (Demand Code = 'CRE'). 
--  130219  Dinklk   EIGHTBALL, Modified Reserve_Manually_Impl__ to call Cro_Line_Util_API.Unreserved_In_Co_Line
--                   IF (Demand Code = 'CRE' AND unreserve material is performed).
--  121224  IsSalk   Bug 106210, Added parameter catalog_type_db_ to the methods Reserve_Order___ and Reserve_Lines___. Modified methods Batch_Reserve_Orders__, 
--  121224           Reserve_Customer_Order__, Reserve_Order___ and Reserve_Lines___ in order to handle the newly added parameter catalog_type_db_.
--  121016  MeAblk   Bug 105375, Modified Reserve_Order_Line__ to handle reservation of non inventory sales parts correctly.
--  121011  NipKlk   Bug 102071, Modified method BATCH_RESERVE_ORDERS__ and used db value when assigning value for attribute RESERVE_ALL_LINES_CO.
--  121008  RoJalk   Bug 104933, Modified Create_Instant_Reservation__, Create_Priority_Reservation__, Unregister_Arrival___ and Create_Arrival_Reservations___ 
--  121008           methods to calculate customer order line cost when order line is pegged from supply objects.
--  120824  NuVelk   Modified Handle_Project_Reservations___ to call Project_Reserved_Mat_Util_API.Make_Unreserve for CO component lines having PO_demand_code_db PRD.
--  120404  NaLrlk   Modified Reserve_Line_At_Location___ to correct the demand_order_ref variable declarations.
--  120404  NWeelk   Bug 101483, Modified Get_Full_Reserved_Pkg_Qty to deduct the quantity already included in a pick list when calculating the reserved_qty_,
--  120404           and changed a condition in cursor get_qty_from_component to select only the component lines not included in a pick list. 
--  120302  ChJalk   Modified the method Get_Expiration_Control_Date___ to add IN parameters order_no_, contract_ and part_no_ to move the call Sales_Part_Cross_Reference_API.Get_Min_Durab_Days_For_Catalog
--  120302           into Get_Expiration_Control_Date___.
--  120301  ChJalk   Added new Function Check_Expired to check whether a given item will be expired by the planned delivery date of the CO line. Modified the method Reserve_Manually_Impl__ to 
--  120301           consider the min durability days defined in the sales part cross reference for the calculation of expiry date.
--  120227  MoIflk   Bug 101084, Modified Backorder_Generated___ to check availability of qty to reserve in project inventory qty when only supply code 'PI'
--  120227           and added to consider supply code 'PRD' (project delivery) in backorder option.
--  120215  IsSalk   Bug 100671, Modified method Reserve_Shipment_Lines__ by adding a new status info for blocked orders.
--  120113  Darklk   Bug 100716, Added the parameter catch_qty_ to Customer_Order_Reservation_API.New.
--  111121  LEPESE   Added part_no in call to Inventory_Part_In_Stock_API.Get_Serial_No_For_Stock from Consume_Peggings.
--  111101  NISMLK   SMA-289, Increased eng_chg_level_ length to VARCHAR2(6) in Reserve_Line_At_Location___ method.
--  111025  NWeelk   Bug 94992, Modified method Reserve_Line_At_Location___ by introducing a warning message to raise if the line is not released for material planning. 
--  110910  SudJlk   Bug 98653, Modified Reserve_Line_At_Location___ to reflect the length change of demand_order_ref1 in customer_order_line_tab.
--  110908  Darklk   Bug 98372, Modified the procedure Reserve_Manually_Impl__ to retrieve already cleared info messages by calling to the function Get_Current_Info
--  110908           in the Customer_Order_Line_API.
--  110906  Darklk   Bug 98174, Modified the procedure Make_Additional_Reservations__ to avoid report picking from another location when the pick list is already picked.
--  110722  NWeelk   Bug 97608, Modified method Feedback_From_Manufacturing by adding qty_on_order_diff_ to the IF condition, to avoid unnecessary method calls.
--  110717  ChJalk   Modified usage of view CUSTOMER_ORDER_LINE to CUSTOMER_ORDER_LINE_TAB in cursors.
--  110519  MaRalk   Added COUNT check before FOR loops introduced from the bug 88111. Modified Check_Package___ to avoid unnecessary flows when  reserving package components.
--  110503  ShVese   Added code to support supply code PI in the method Backorder_Generated____. This was part of the bug 88327 but the complete correction wasn't merged.
--  110428  UdGnlk   Modified Consume_Peggings() and Unconsume_Peggings() for part ownership null values assign 'COMPANY OWNED'.
--  110331  JoAnSe   Added call to Inventory_Part_In_Stock_API.Get_Serial_No_For_Stock in Consume_Peggings.
--  110322  NWeelk   Bug 96263, Modified method Feedback_From_Manufacturing to use qty_on_order_diff_ when calculating QTY_ON_ORDER in order to 
--  110322           update QTY_ON_ORDER correctly for manually reserved COs having a pegged SO.  
--  110310  DaZase   Changed call to Inventory_Part_Pallet_API.Check_Exist so it uses Inventory_Part_API.Pallet_Handled instead.
--  110217  ShVese   Replaced the serial_tracking_code flag with receipt_issue_track in Reserve_Line_At_Location___. 
--  110228  ChJalk   Modified CURSOR get_reservations for getting required data from Warehouse_Worker_Task_Type_API.Is_Active_Worker instead of accessing the view WAREHOUSE_WORKER_TASK_TYPE.
--  110118  MalLlk   Modified Feedback_From_Manufacturing to support CRO reservations. Removed method Reserve_From_Cro.
--  110114  MalLlk   Added method Reserve_From_Cro.
--  110106  SaJjlk   Bug 95145, Modified method Consume_Peggings to set the Customer Order to Blocked state if conditions are fulfilled. 
--  101011  NiDalk   Bug 93470, Modified Get_Available_Pkg_Qty__ to check for line_qty_per_pkg_ is more than 0 when calculating pkg_qty_possible_.
--  100629  MaEelk   Replaced the obsolete call Inventory_Part_stock_Owner_API.Get with
--  100629           with Inventory_Part_In_Stock_API.Get in Unconsume_Peggings.
--  100622  RaKalk   Bug 88111, When there are huge number of orders with many lines (with normal and package part),and when background reservation jobs run frequently,  
--  100622           in order to gain a performance increase, cursor BULCK COLLECT fetches has been introduced to Reserve_Order___, Reserve_Lines___, Backorder_Generated___,  
--  100622           Reserve_Complete_Package___, Complete_Package___, Check_Package___, Check_Reserve_Package___, Reserve_Package_Components___ and Batch_Reserve_Orders__. 
--  100622           In Reserve_Line_At_Location___ removed unnecessary number of dynamic calls that fetched PURCH connected serial, lot numbers and service type, 
--  100622           and unnecessary possibilities to calls of those. 
--  100920  PaWelk   Reversed the correction made in bug id 88111.
--  100909  ChJalk   Bug 92907, Modified the method Create_Instant_Reservation__ to change the error message NO_ASSIGN_PART3.
--  100602  RaKalk   Bug 90605, Modified function Backorder_Generated___ to consider configuration_id, part_ownership and condition code
--  100602           when calculating the total quantity to be reserved.
--  100517  KRPELK   Merge Rose Method Documentation.
--  100617  ShKolk   Used new backorder_option_db_ values instead of old values.
--  100615  MaEelk   Replaced the obsolete call Inventory_Part_stock_Owner_API.Get with
--  100615           with Inventory_Part_In_Stock_API.Get in Consume_Peggings.
--  100517  KRPELK   Merge Rose Method Documentation.
--  100506  RaKalk   Bug 90314, Modified Reserve_Manually_Impl__ procedure to check credit blocked flag of ordering customer
--  100504  AmPalk   Bug 90324, Correction 88111 lacks some code in Reserve_Line_At_Location___. At the end of each reservation attempt, 
--  100504           at the end of the loop set the location, serial, lot batch numbers and order code null. So the automatic reservation process searches all possible values of them while in the loops.
--  100430  NuVelk   Merged Twin Peaks.
--  100121  AmPalk   Bug 88111, When there are huge number of orders with many lines (with normal and package part),and when background reservation jobs run frequently,  
--  100121           in order to gain a performance increase, cursor BULCK COLLECT fetches has been introduced to Reserve_Order___, Reserve_Lines___, Backorder_Generated___,  
--  100121           Reserve_Complete_Package___, Complete_Package___, Check_Package___, Check_Reserve_Package___, Reserve_Package_Components___ and Batch_Reserve_Orders__. 
--  100121           In Reserve_Line_At_Location___ removed unnecessary number of dynamic calls that fetched PURCH connected serial, lot numbers and service type, 
--  100121           and unnecessary possibilities to calls of those. 
--  100118  Cpeilk   Bug 88327, Modified Function Backorder_Generated___ to consider sypply code project inventory.
--  091215  ShRalk   Bug 87735, Modified Batch_Reserve_Orders__ to add a condition to filter by CO header parameters.
--  090403  NuVelk   Modified Consume_Peggings to correctly pass the activity_seq.
--  091203  KiSalk   Changed backorder option values to new IID values in Customer_Backorder_Option_API.
--  091001  MaMalk   Modified Backorder_Generated___, Reserve_Complete_Package___, Check_Reserve_Package___, Check_Reserve_Package_Comp___, Register_Arrival___,
--  091001           Unregister_Arrival___, Reserve_Order__, Reserve_Order_Line__, Create_Supply_Site_Reserve__, Create_Instant_Reservation__, Reserve_Manually_Impl__,
--  091001           Reserve_Shipment_Lines__, Clear_Unpicked_Shipment_Res__, Reserve_Line_From_Shortage, Get_Full_Reserved_Pkg_Qty, Get_Available_Qty and Reserve_Lines___
--  091001           to remove unused code.
--  ------------------------- 14.0.0 -------------------------------------------
--  091215  ShRalk   Bug 87735, Modified Batch_Reserve_Orders__ to add a condition to filter by CO header parameters.
--  091202  DaGulk   Bug 85166, Removed parameter catch_qty_ from calls to Customer_Order_Reservation_API.New.
--  091124  NWeelk   Bug 85592, Modified method Handle_Project_Reservations___ to send struct_line_no_ to method Make_Unreserve in Project_Reserved_Mat_Util_API
--  091124           and by adding demand order details to the parameter list.  
--  091027  SaWjlk   Bug 86068, Modified the cursor get_qty_from_component in the function Get_Full_Reserved_Pkg_Qty to check whether the variables 
--  091027           qty_assigned, qty_picked and qty_shipped are zero.
--  091012  NaLrlk   Modified the method call Inventory_Part_In_Stock_API.Get_Inventory_Quantity to pass the unit_of_measure_type in Backorder_Generated___.
--  091007  KiSalk   Added preliminary_pick_list_no marameter to Customer_Order_Reservation_API.New calls.
--  090824  ShKolk   Added function call to Sales Part Cross Reference to get min_durab_days_co_deliv_.
--  090818  ShKolk   Added function Get_Expiration_Control_Date___. 
--  090812  ShKolk   Added expiration_control_date_ to Handle_Project_Reservations___, Reserve_Line_At_Location___, Backorder_Generated___.
--  090606  PraWlk   Bug 83548, Modified procedure Validate_Params to validate Order_Coordinator.
--  090527  SuJalk   Bug 83173, Changed the error constant to WRONGCFGARR in method Unregister_Arrival___. Also formatted the message CANNOTRESERVE.
--  090515  SuJalk   Bug 80760, Added parameter ownership_type2_db to Get_Available_Pkg_Qty__ method. Also added paramter condition code to Get_Available_Qty method. 
--  090515           Modified the method call Inventory_Part_In_Stock_API.Get_Inventory_Quantity to pass the condition code, ownership_type2_db, vendor_no and is_customer_order_  in order to 
--  090515           consider those values when calculating the available quantity. Also overloaded the method Get_Available_Quantity to allow calls from some other clients in the order module.
--  090424  SudJlk   Bug 81283, Modified Create_Priority_Reservation__ to call Purchase_Order_Line_API.Get_Demand_Operation_No only when demand code is ICD or ICT.  
--  090130  SaJjlk   Bug 79846, Removed the length declaration for NUMBER type variables activity_seq_ and temp_activity_seq_ in method Reserve_Line_At_Location___. 
--  090130  SudJlk   Bug 76805, Added new parameters result_code_, available_qty_, earliest_available_date_to Control_Ms_Mrp_Consumption.
--  081218  SuJalk   Bug 79233, Added the DONTREDUCEQTYRES error message to Reserve_Src_Supply_Site_Man___ and Reserve_Supply_Site_Man___.
--  081209  SuJalk   Bug 79018, Modified the DONTREDUCEQTYRES error message to be more generic rather than focusing on pick lists. 
--  081031  ChJalk   Bug 76959, Modified the method Reserve_Manually_Impl__ to pass a parameter to avoid creating the Customer Order Line History log in Customer Order Line.
--  081007  MaMalk   Bug 76899, Modified check_reserv cursor in Entire_Order_Reserved__ function to remove the part_no check for supply code SEO.
--  080929  DaZase   Bug 76868(part 2), added check 'qty_assigned != qty_picked + qty_shipped' in method Get_Full_Reserved_Pkg_Qty cursor get_qty_from_component to avoid already picked components.
--  080723  MaRalk   Bug 75379, Modified check_reserv cursor in Entire_Order_Reserved__ function.
--  080708  NaLrlk   Bug 74298, Added function Picked_Component_Exist___ and restructured the code in method Clear_Unpicked_Shipment_Res__.
--  080707  NaLrlk   Bug 74298, Added the cursor exist_comp_picked and modified the method Clear_Unpicked_Shipment_Res__.
--  080707           Added parameter consider_reserved_qty_ to method Clear_Unpicked_Shipment_Res__ and modified method Reserve_Shipment_Lines__.
--  080701  NaLrlk   Bug 74298, Added parameter discon_not_picked_ to methods Clear_Unpicked_Shipment_Res__ and Reserve_Shipment_Lines__.
--  090417  KiSalk   Added Connect_To_Manual_Pick_List.
--  081127  MaJalk   Created one background job for a site which enabled fair share reservation and background job 
--  081127           for each order which disabled fair share reservation in site at methods Batch_Reserve_Orders__ and Reserve_Batch_Orders__. 
--  081124  MaJalk   Modified Batch_Reserve_Orders__ to fetch fair share reservation info from Site_Discom_Info_API and modified Reserve_Batch_Orders__.
--  080701  KiSalk   Merged APP75 SP2.
--  ----------------------------- APP75 SP2 Merge - End -----------------------------
--  080421  ChJalk   Bug 72659, Modified the method Feedback_From_Manufacturing to handle the locations where the parameter Activity_Seq_ is NULL.
--  080408  ChJalk   Bug 72659, Modified the method Feedback_From_Manufacturing to give the error message NOTPICKINGLOC.
--  ----------------------------- APP75 SP2 Merge - Start -----------------------------
--  080313  KiSalk   Merged APP75 SP1.
--  ---------------------   APP75 SP1 merge - End ------------------------------
--  071210  SaJjlk   Bug 66397, Added method Clear_Unpicked_Shipment_Res___ to be a private method.
--  071210           Added parameters finalize_on_picked_qty_ and consider_reserved_qty_ to Reserve_Shipment_Lines__ .
--  071119  MaRalk   Bug 67755, Modified procedures Reserve_Manually_Impl__, Feedback_From_Manufacturing and Reserve_From_Ctp 
--  071119           in order to go with increased length of MESSAGE_TEXT column in CUSTOMER_ORDER_LINE_HIST_TAB.  
--  ---------------------   APP75 SP1 merge - Start ------------------------------
--  080212  MiKulk   Added a new method Reserve_Batch_Orders__ and moved the main logic of the Batch_Reserve_Orders__ to that method.
--  080212           The Batch_Reserve_Orders__ will be calling this new method in the foreground or background based on the value passed for fair_share_res.
--  080116           This is mainly done to have one background job for fair share reservation and several background jobs per each order for normal rservation.
--  080103  MiKulk   Added the parameter sequence_no_ to the method Reserve_Order___. Modified the method Reserve_Customer_Order__,
--  080103           Batch_Reserve_Orders__ and Reserve_Order___ to handle the Fair Share Reservation.
--  --------------------- Nice Price--------------------------------------------
--  070912  MaJalk   At Reserve_Order_Line__, used activity_seq to find out qty_short_.
--  070904  ChJalk   Modified Feedback_From_Manufacturing to change the pegged quantities in Shop Order.
--  070820  MaJalk   Modified Get_Full_Reserved_Pkg_Qty to returns the number of reserved packages that are not yet picked. 
--  070731  NuVelk   Bug 65015, Modified procedures Batch_Reserve_Orders__, Reserve_Lines___,Reserve_Shipment_Lines__ and 
--  070731           Handle_Project_Reservations___. Modified the function Entire_Order_Reserved__.    
--  070621  MiKulk   Bug 61765, Changed Control_Ms_Mrp_Consumption__ to a public method.  
--  070619  ChBalk   Removed General_SYS.Init_Method from Get_Available_Qty, Made Get_Available_Pkg_Qty___ private.
--  070612  MaJalk   Rewrote method Get_Full_Reserved_Pkg_Qty.
--  070611  MaJalk   Bug 62565, Added new implementation method Handle_Project_Reservations___ and modified Reserve_Line_At_Location___ to handle project reservations.
--  070611  AmPalk   Bug 63107, Modified Make_Pick_Plan__, Reserve_Lines___, Pick_Package___ and Complete_Package___
--  070611           to reserve remaining unpegged qty for CO line with supply code 'PT', 'IPT', and 'SO'.
--  070607  Mikulk   Modified the method Reserve_Manually_Impl__ to consider the customer_no_pay when checking for credit.
--  070516  NaLrlk   Modified the function Batch_Reserve_Orders__ for reserve_all_lines_co_db_ to get db value.
--  070511  NiDaLK   Modified Check_Pkage___ to update shortage quantities for package components.
--  070509  Cpeilk   Modified method Reserve_Manually_Impl__ to check for released_from_credit_check flag.
--  070427  MaJalk   Modified Get_Available_Pkg_Qty___ to calculate pkg_qty_possible_ using buy_qty_due.
--  070419  NaLrlk   Bug 64424, Modification in methods Reserve_Order_Line__ and Reserve_Complete_Package___ to calculate
--  070419           quantity shortages using method Shortage_Demand_API.Calculate_Order_Shortage_Qty.
--  070416  NiDalk   Added General_SYS.Init_Method to Package_Partially_Reserved, Check_Package_Reservations, Split_Package_Reservations, Get_Full_Reserved_Pkg_Qty and
--  070416           Get_Available_Qty.
--  070416  MaJalk   Modified methods Get_Available_Qty, Get_Available_Pkg_Qty___.
--  070326  MaJalk   Added methods Get_Available_Qty, Get_Available_Pkg_Qty___.
--  070322  SuSalk   LCS Merge 61771, Modified Pick_Package___, Check_Package___ Complete_Package___, Check_Pick_Package___ and Reserve_Order_Line__ to
--  070322           avoid reserving incomplete packages and to remove the incorrect behavior when reserving package parts.
--  070308  MiKulk   Bug 61497, Modified Reserve_Complete_Package___ to correctly calculate the qty to be reserved.
--  070221  MaJalk   Modified Reserve_Package__ to eliminate warning messages when processing fully reserved packages.
--  070214  MaJalk   Added methods Check_Package_Reservations, Split_Package_Reservations, Get_Full_Reserved_Pkg_Qty.
--  070213  NaLrlk   Modified the IF condition in the method Package_Partially_Reserved.
--  070206  NuVelk   Bug 62800, Modified method Create_Arrival_Reservations___ in order to handle catch quantity correctly.
--  070125  SaJjlk   Replaced method call to Shipment_Order_Line_API.Get_Shipment_Id with Shipment_Order_Line_API.Get_Active_Shipment_Id.
--  070118  MaJalk   Modified methods Reserve_Order___, Reserve_Lines___, Make_Pick_Plan__, Pick_Plan_Order__ and
--  070118           renamed methods Make_Pick_Plan__, Pick_Plan_Order__, Pick_Plan_Ship_Lines__, Reserve_Customer_Order__
--  070118           to Batch_Reserve_Orders__, Reserve_Customer_Order__, Reserve_Shipment_Lines__, Reserve_Customer_Orders__.
--  070112  NaLrlk   Changed the Call Reserve_Complete_Package___ to Reserve_Package__ in Pick_Plan_Ship_Lines__ and Reserve_Lines___. Modified Check_Package___.
--  070109  MaJalk   Modified Backorder_Generated___ to handle package parts and modified Check_Package___, Reserve_Complete_Package___, Reserve_Package_Components___.
--  070102  NaLrlk   Added the method Package_Partially_Reserved. Modified methods Reserve_Package__, Check_Package___ and Complete_Package___.
--  070102  ChBalk   Replaced call Customer_Order_Line_API.Modify_Cost with Sales_Cost_Util_API.Modify_Cost_Incl_Sales_Overhead.
--  061228  NiDalk   Renamed Pick_Package___ to Reserve_Complete_Package___ and removed parameter backorder_option_db_.
--  061228           Added method Reserve_Package_Components___ and Reserve_Package__.
--  061222  NiDalk   Modified method names of Pick_Plan_Order___, Pick_Plan_Lines___, Pick_Inventory___,
--  061222           Pick_Non_Inventory___, Check_Pick_Package___, Check_Pick_Package_Comp___ to
--  061222           Reserve_Order___, Reserve_Lines___, Reserve_Inventory___, Reserve_Non_Inventory___,
--  061222           Check_Reserve_Package___, Check_Reserve_Package_Comp___.
--  061222  NiDalk   Added method Reserve_Customer_Order__.
--  061220  NaLrlk   Modified the reservation_info_ message in all places. Modified methods Complete_Package___, Check_Package___.
--  061220           Removed else section which create new shortages in Reserve_Manually_Impl__.
--  061130  MaJalk   Changed info messages at Reserve_Line_At_Location___.
--  061127  MaJalk   Did modifications at Reserve_Line_At_Location___, Check_Package___, Reserve_Manually_Impl__.
--  061125  KaDilk   Bug 61168, Modified procedures Pick_Plan_Lines___, Make_Pick_Plan__, Pick_Plan_Ship_Lines__ and Entire_Order_Reserved__ function
--  061125           to solve the problems when reserving project connected Inventory Parts and Non Inventory Parts.
--  061117  MaJalk   Modified method Make_Pick_Plan__.
--  061115  MaJalk   Modified methods Reserve_Line_At_Location___, Pick_Plan_Order___, Pick_Plan_Lines___, Pick_Inventory___,
--  061115           Pick_Package___, Complete_Package___, Check_Package___, Reserve_Order_Line__, Create_Supply_Site_Reserve__.
--  061110  MiErlk   Bug 59639, Added information message to Reserve_Line_From_Shortage when not possible to reserve the full quantity and
--  061110           changed a parameter in Reserve_Order_Line__ and modified the places where calling this method.
--  061030  DaZase   Changes in methods Create_Supply_Site_Reserve__ and Create_Instant_Reservation__
--                   so quantities are calculated in supply site inventory UoM. Changes in method
--                   Reserve_Manually_Impl__ so the quantities on the customer order line history are calculated
--                   in demand site inventory UoM.
--  060929  ChJalk   Modified Modified Pick_Plan_Ship_Lines__.
--  060822  Cpeilk   Added new parameter to method Check_Order_for_Blocking inside methods Pick_Plan_Order___ and Reserve_Order__.
--  060808  MaMalk   Replaced some of the instances of TO_DATE function with Database_Sys.last_calendar_date_.
--  060518  JaJalk   Bug 58061, Modified the method Make_Pick_Plan__ to implement the EXECUTION_OFFSET for the schedule wizard.
--  060428  JOHESE   Enabled reservation of project connected lines in Pick_Plan_Lines___ and Entire_Order_Reserved__
--  060424  IsAnlk   Enlarge Supplier - Changed variable definitions.
--  060419  MaJalk   Enlarge Customer - Changed variable definitions.
--  ---------------------------------13.4.0-------------------------------------
--  060216  IsAnlk   Modified error message NO_ASSIGN_PART1 in Create_Priority_Reservation__.
--  060124  JaJalk   Added Assert safe annotation.
--  060120  DaZase   Moved reservation logic from Register_Arrival___ to Create_Arrival_Reservations___,
--                   because this is also used by CC-process using Reserve_From_Ctp and here we
--                   dont want any qty_on_order considerations when reservations are created.
--  060119  JOHESE   Added check in Reserve_Line_At_Location___ to prevent reservations from other activities in the same project when not allowed
--  060104  LaBolk   Bug 54542, Modified Unregister_Arrival___ to remove the reservation record if the qty_assigned becomes 0.
--  051227  LaBolk   Bug 54542, Added parameters location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, configuration_id_
--  051227           and condition_code_to Unconsume_Peggings. Modified the same method to handle inventory reservations.
--  051227           Added parameter qty_on_order_diff_ to Unregister_Arrival___ and modified its code to calculate pegged and assigned quantities correctly.
--  051221  MaJalk   Bug 54660  Added rowstates Released, Reserved, Picked, PartiallyDelivered to cursor get_qty in function Backorder_Generated___.
--  051216  MaJalk   Bug 54660, Modified function Backorder_Generated___.
--  051201  LaBolk   Bug 54214, Modified Consume_Peggings to correct an error that qty_to_ship is updated with too much quantity.
--  051207  KanGlk   Modified the error message 'AVAILIDMANRES'.
--  051122  JaBalk   Changed the info to warning when an order line was not fully reserved in the method Reserve_Line_At_Location___.
--  051118  LaBolk   Bug 54214, Added method Unconsume_Peggings to reverse the corresponding CO quantities when the connected PO receipt is cancelled.
--  051118           Modified Consume_Peggings to update qty_to_ship correctly in non-inventory CO lines.
--  051109  GeKalk   Modified Reserve_Line_At_Location___ to fetch the correct value of co_reserve_onh_analys_flag.
--  051102  GeKalk   Removed onhand_analysis_flag parameter from Reserve_Order_Line__,Reserve_Line_At_Location___,
--  051102           Create_Supply_Site_Reserve__,Pick_Plan_Lines___,Pick_Package___,Complete_Package___,Pick_Inventory___,
--  051102           Check_Package___,Backorder_Generated___, Pick_Plan_Order___ and retreived Co_Reserve_Onh_Analys_Flag
--  051102           from inventory_part in Backorder_Generated___,Check_Package___and Reserve_Line_At_Location__.
--  051101  IsAnlk   Modified Customer_Order_Flow_API.Credit_Check__ to Check_Order_for_Blocking.
--  051025  MaJalk   Bug 54159, Modified procedure Consume_Peggings() to give the info message when condition codes are differ.
--  051020  SuJalk   Changed the reference of get_batch_sites cursor in Make_Pick_Plan__ procedure to user_allowed_site_pub.
--  051011  Cpeilk   Bug 53688, Modified cursor get_order in method Make_Pick_Plan__.
--  051006  MaJalk   Bug 53305, Modified procedure Consume_Peggings to eliminate reservations of CO lines with different ownerships
--  051006           and added an info message.
--  051005  IsAnlk   Added error message QTYOVERRIDES in Reserve_Manually_Impl__.
--  050930  DaZase   Added configuration_id/activity_seq in calls to Inventory_Part_Loc_Pallet_API methods.
--  050921  DaZase   Added activity_seq to methods Reserve_Src_Supply_Site_Man___ and Reserve_Supply_Site_Man___. Also added real activity_seq to calls
--                   to Co_Supply_Site_Reservation_API and Sourced_Co_Supply_Site_Res_API methods
--  050824  ChJalk   Bug 52277, Restructured the Procedure Unregister_Arrival___ and modified the value of QTY_ON_ORDER in Feedback_From_Manufacturing.
--  050824           Modified the Procedure Register_Arrival___ to consider qty_on_order in calculating
--  050824           qty_to_assign_. Also re-arranged some codes in Procedure Unregister_Arrival___.
--  050824  JaBalk   Added an info when an order line was not fully reserved in the method Reserve_Line_At_Location___.
--  050815  VeMolk   Bug 50869, Modified the calls to the method Inventory_Part_In_Stock_API.Make_Onhand_Analysis in the methods
--  050815           Reserve_Line_At_Location___, Backorder_Generated___ and Check_Package___.
--  050628  SaLalk   Bug 50559, Modified Consume_Peggings to correctly calculate value for column qty_on_order and
--  050628           added a new out parameter to Register_Arrival___, moved Customer_Order_Line_API.Modify_Qty_On_Order to one place in there.
--  050518  JoEd     Added customer consignment check in Reserve_Line_At_Location___ -
--                   to use "ownership" 'COMPANY OWNED NOT CONSIGNMENT'.
--  050505  LaBolk   Bug 50111, Added private function Unpicked_Picklist_Exist__.
--  050415  MiKulk   Bug 50511, Modified the text in the error message.
--  050412  MiKulk   Bug 50511, Modified the procedure Reserve_Cust_Ord_Manually___ to raise an error message when we try to reduce the manually reserved
--  050412           qty, when a pick list is already created.Moved the existing error message from the method Reserve_Manually_Impl__.
--  050405  LaBolk   Bug 48763, Reversed the correction done on 050328 as it was decided to handle the problems in this area in a separate bug.
--  050401  JOHESE   Modified Reserve_Line_At_Location___ to prevent reservations on consignment stock when delivery confirmation is used
--  050330  PrPrlk   Bug 49003, Changed the name of function Line_Reservations_Exist__ to Unpicked_Reservations_Exist__.
--  050328  LaBolk   Bug 48763, Modified Consume_Peggings to correctly calculate value for column qty_on_order.
--  050324  IsWilk   Added FUNCTIONs Get_Min_Due_Date_For_Unpicked,Get_Min_Ship_Date_For_Unpicked.
--  050323  IsWilk   Addded the PROCEDURE Validate_Params.
--  050323  GeKalk   Added new public method Is_Pick_List_Created.
--  050222  NuFilk   Modified method Reserved_With_No_Pick_List__ change cursor get_reserved.
--  050216  IsAnlk   Modified SHIPMENT_CONNECTED as VARCHAR2 and changed the code accordingly.
--  050201  NiRulk   Bug 49248, Modified cursor check_reserv in function Entire_Order_Reserved__.
--  050128  NuFilk   Modified cursor in method Get_No_Of_Packages_Reserved.
--  050125  NuFilk   Modified condition in cursor get_inv_packages_reserved in method Get_No_Of_Packages_Reserved.
--  050121  UsRalk   Added new public method Get_No_Of_Packages_Reserved.
--  050105  NuFilk   Added new method Pick_Plan_Ship_Lines__.
--  041231  LaPrlk   Bug 48601, Modified the cursor 'demand_rec' in procedure 'Consume_Peggings'.
--  041110  IsAnlk   Modified Reserve_Line_At_Location___ to update MUM information.
--  041108  IsAnlk   Removed Customer_Order_Reservation_API.Modify_Catch_Qty calls.
--  041104  GeKalk   Modified Make_Additional_Reservations__ to handle the catch quantity.
--  041104  IsAnlk   Removed catch_qty_ from Reserve_Manually__, Reserve_Manually_Impl__.
--  041102  DiVelk   Added validations for 'PS' in Pick_Plan_Lines___,Backorder_Generated___,Pick_Package___,
--                   Complete_Package___,Check_Package___,Check_Pick_Package___,Check_Pick_Package_Comp___,
--                   Entire_Order_Reserved__,Make_Pick_Plan__,Reserve_Manually_Impl__ and Consume_Peggings.
--  041026  GeKalk   Modified Make_Additional_Reservations__ to handle the catch quantity.
--  041026  IsAnlk   Modified Reserve_Cust_Ord_Manually___ and Reserve_Line_At_Location___.
--  041025  MiKulk   Bug 47558, Modified the procedure Feedback_From_Manufacturing by adding a condition to code part added by bug 47161.
--  041021  IsAnlk   Added catch_qty_to Reserve_Manually__, Reserve_Manually_Impl__.
--  041220  MaJalk   Bug 48481, Modified the cursor check_reserv in function Entire_Order_Reserved__.
--  041020  IsAnlk   Added parameter catch_qty_ to method calls Customer_Order_Reservation_API.New.
--  041015  DaZase   Added activity_seq handling in method Make_Additional_Reservations__.
--  041014  SaJjlk   Added parameter catch_quantity_ to method calls Inventory_Part_In_Stock_API.Reserve_Part.
--  041014  LaBolk   Bug 46826, Modified Consume_Peggings to update CO-PO connection table when supply code is PT and IPT.
--  041013  SaJjlk   Added parameter reserved_catch_qty_ to Inventory_Part_In_Stock_API.Find_And_Reserve_Part.
--  041007  DaZase   Added activity_seq to methods Feedback_From_Manufacturing, Register_Arrival___ and Unregister_Arrival___
--  041006  DaZase   Added use of activity_seq and project_id in method Reserve_Line_At_Location___.
--  041004  DaZase   Added activity_seq as a parameter to methods Reserve_Manually__, Reserve_Manually_Impl__ and Reserve_Cust_Ord_Manually___.
--  041001  MiKulk   Bug 47161, Modified the procedure Feedback_From_Manufacturing to modify the qty_on_order in Customer_Order_Shop_Order_Tab.
--  040930  DaZase   Project Inventory: Added zero-parameter to calls to different Customer_Order_Reservation_API methods,
--                   the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  040921  JOHESE   Modified some calls to Inventory_Part_In_Stock_API
--  040917  IsWilk   Modified PROCEDURE Make_Pick_Plan__ to set the correct Db values.
--  040827  MiKulk   Bug 45916, Modified the procedures Reserve_Order_Line__ and Reserve_Manually_Impl__
--  040827           to correctly remove the package parts from the shortage tab.
--  040825  DaRulk   Removed DEFAULT NULL input uom paramters. Instead assign the values inside the code.
--  040727  DaRulk   Added parameters input_qty_, input_unit_meas_ ,input_conv_factor_, input_variable_values_
--                   to Make_Additional_Reservations__
--  040720  JaJalk   Corrected the definition of OBJID and OBJVERSION.
--  040719  DaRulk   Added parameters input_qty_, input_unit_meas_ ,input_conv_factor_, input_variable_values_
--                   to Reserve_Cust_Ord_Manually___, Reserve_Manually__ and Reserve_Manually_Impl__
--  040706  JOHESE   Added null parameter in cal to Inventory_Part_In_Stock_API.Get_Inventory_Quantity
--  040609  ChBalk   Bug 41364, Stop Instant Reservations when part has online consumption checked.
--  040609  VeMolk   Bug 45251, Modified the methods Pick_Plan_Lines___, Make_Pick_Plan__ to make the reservation
--  040609           possible for order lines with supply code 'SEO'.
--  040514  DaZase   Project Inventory: Added dummy parameters to call Inventory_Part_In_Stock_API.Find_And_Reserve_Part,
--                   change these parameters to real Activity_Seq and Project_Id values if this functionality uses Project Inventory.
--  040510  DaZase   Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods,
--                   the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  040430  VeMolk   Bug 44234, Modified an argument passed to a method call in the method Backorder_Generated___.
--  040303  ChJalk   Bug 42256, Modified the PROCEDURE Check_Package___ to get the least value out of, quantity in the inventory location
--  040303           and the available quantity onhand for a part, when calculating the minimum number of package parts that can be reserved.
--  040224  SeKalk   Bug 41744, Removed the setting of RELEASE_PLANNING attribute for the originating order line in procedure Transfer_Reservation.
--  040224  IsWilk   Modified the SUBSTRB to SUBSTR for Unicode Changes.
--  040129  WaJalk   Bug 41797, Removed the error message and assigned min_pkg_picked_ to zero in Check_Package___ method.
--  040129  GeKalk   Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  040102  IsWilk   Bug 39282, Removed the obsolete statments DEFINE CUSTPICKVIEW and UNDEFINE CUSTPICKVIEW
--  031217  ChBalk   Bug 40352, Added validation for the online_consumption_flag when priority_reservation
--  031217           in the PROCEDURE Create_Priority_Reservation__.
--  ********************* VSHSB Merge End *************************
--  020422  Prinlk   Made a modification to the method Reserve_Manually_Impl__. When an order line is connected to a shipment
--                   and that shipment has any package structure then alert has been raised to capture from the client side.
--  ********************* VSHSB Merge *****************************
--  031106  JaJalk   Reversed LCS bug correction of 37906.
--  031031  UdGnlk   Modified Reserve_Line_At_Location___ to get the correct serialno/lotbatchno for ESO when Priority Reservation of customer order.
--  031028  JaJalk   Modified the method Backorder_Generated___.
--  031018  JaJalk   Used Inventory_Part_In_Stock_API.Get_Avail_Plan_Qty_Loc_Type for Inventory_Part_In_Stock_API.Get_Inventory_Quantity in Backorder_Generated___.
--  031017  DaZa     Moved cost handling from Reserve_Manually_Impl__/Reserve_Order_Line__ to a new method Modify_Cost_After_Reserve___
--                   and made some changes in the checks for this.
--  031017  SaNalk   Added FUNCTION Serial_Delivered_On_Order_Line.
--  031013  PrJalk   Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  031002  PrTilk   Modified method Reserve_Line_At_Location___. Changed the code to get the serial and lot batch no
--  031002           using the po line keys for exchnage orders.
--  031002  AjShlk   Modified the method Consume_Peggings() to reserve COs for non condition code parts.
--  031001  NuFilk   Modified the method Reserve_Manually_Impl__ to set value for cost when all lines are unreserved.
--  030926  JaJalk   Modified the method Reserve_Manually_Impl__ to remove the shortage record.
--  030918  SuAmlk   Bug 37906, Added dynamic sql in method Reserve_Manually__ to get Dop ID and modify Quantity delivered
--                   in manufacturing side when a Dop order is connected to the Custome order.
--  030917  DaZa     Made some modifications in Transfer_Reservation.
--  030917  AjShlk   Modified Consume_Pegging() to match condition codes
--  030915  DaZa     Added purchase_part_no to Create_Supply_Site_Reserve__.
--  030912  Puillk   Bug 37707, Modified If condtion in PROCEDURE Reserve_Line_At_Location___.
--  030911  DaZa     Added some functionality so that supply site reservations and priority reservations on an internal order
--                   will work better, added this in methods Create_Priority_Reservation__ and Transfer_Reservation.
--  030910  MaMalk   Bug 37453, Modified Reserve_Manually_Impl__ to show the correct reserved quantity in Order Line History.
--  030901  NuFilk   CR Merge 02
--  030829  JoEd     Added check against supply site part in Is_Supply_Chain_Reservation -
--                   if demand site's part is non-inventory, the supply site's part might be...
--  030820  DaZa     Added call to Set_Line_Qty_Assigned in Transfer_Reservation.
--  **************************** CR Merge 02 ************************************
--  030828  DaZa     Added extra check in Reserve_Manually_Impl__ so the cost handling will only executed when its not an SupplySiteReservation.
--  030825  GaSo     Performed CR Merge.
--  030814  DaZa     Removed calls to Customer_Order_Line_API.Modify_Release_Planning.
--  030813  DaZa     Changed call to Reserve_Manually__ in method Transfer_Reservation so it now instead
--                   calls Customer_Order_Reservation_API.New also added handling of qty_assigned.
--  030808  DaZa     Fixed Order Lines history for supply chain reservations in Reserve_Manually_Impl__.
--  030807  DaZa     Added handling for sourced local site reservations in methods Create_Supply_Site_Reserve__,
--                   Reserve_Line_At_Location___ and Reserve_Manually_Impl__.
--  030716  NaWalk   Removed Bug coments.
--  030630  JoEd     Removed Reserve_Or_Make_Analysis__. Added method Create_Priority_Reservation__
--  030623  DaZa     Removed check for CO status = 'Planned' in method Is_Supply_Chain_Reservation.
--  030617  JoEd     Added order line history for manual supply site reservation (Reserve_Manually__).
--  030616  DaZa     Made some changes in methods Is_Supply_Chain_Reservation due to changes on the supply_site_reserve_type IID.
--  030613  JoEd     Added calls to modify the release_planning attribute on customer order line
--                   depending on supply site reservations.
--  030613  DaZa     Added handling for sourced supply chain reservations. Added new methods Reserve_Manually_Impl__,
--                   Reserve_Src_Supply_Site_Man___ and Create_Instant_Reservation__. Move supply chain reservation handling
--                   from Reserve_Or_Make_Analysis__ to Create_Instant_Reservation__. Added source_id_ as a param to
--                   Reserve_Line_At_Location___, Create_Supply_Site_Reserve__ and Is_Supply_Chain_Reservation.
--  030611  JoEd     Added Transfer_Reservation.
--  030423  DaZa     Added an overload on Is_Supply_Chain_Reservation
--  030417  DaZa     Moved some reservation handling from Reserve_Manually__ to new methods Reserve_Supply_Site_Man___ and Reserve_Cust_Ord_Manually___
--  030415  DaZa     Added method Create_Supply_Site_Reserve__.
--  030411  DaZa     Added some error checks for supply chain reservation in Reserve_Or_Make_Analysis__.
--  030409  DaZa     Added method Is_Supply_Chain_Reservation. Added reservation_type_ parameter to
--                   method Reserve_Line_At_Location___. Added SupplyChainReservation handling in
--                   methods Reserve_Order_Line__, Reserve_Or_Make_Analysis__, Reserve_Manually__,
--                   Reserve_Line_At_Location___  and calls to Co_Supply_Site_Reservation_API.
--  **************************************CR Merge******************************
--  030806  SaNalk   Removed Bug tags.
--  030801  SaNalk   Performed SP4 Merge.
--  030723  UdGnlk   Modified Backorder_Generated___ and Check_Package___ Inventory_Part_In_Stock_API.Get_Sales_Plannable_Qty_Onhand
--                   and Inventory_Part_In_Stock_API.Get_Sales_Plannable_Qty_Res replaced by Inventory_Part_In_Stock_API.Get_Avail_Plan_Qty_Loc_Type.
--  030718  GeKalk   Include ownership parameters for every Inventory_Part_In_Stock_API.Make_Onhand_Analysis call.
--  030718  SuAmlk   Modified methods Reserve_Manually__ & Reserve_Order_Line__ to update cost details when the order line is reserved.
--  030626  ChIwlk   Modified procedure Reserve_Line_At_Location___ to hanlde NULL values of serial no and lot batch no.
--  030613  GeKalk   Modified Reserve_Line_At_Location___ to reserve exchange items.
--  030609  GeKalk   Removed unwanted comment lines.
--  030520  GeKalk   Modified Reserve_Line_At_Location___ to send part_ownership, owning_customer_no and owning_vendor_no.
--  030520           to Find_And_Reserve_Pallet and Find_And_Reserve_Part.
--  030513  GeKalk   Modified Consume_So_Peggings and Consume_Peggings to remove event calls
--  030513           Unfulfilled_Pegging_Co_Po and Unfulfilled_Pegging_Co_So.
--  030513  ThPalk   Bug 37102, Changed method Make_Pick_Plan__ .
--  030513  ThPalk   Bug 37045, Changed method Pick_Plan_Order__ ,Make_Pick_Plan__ in order to correct the name of attribute ONHAND_ANALYSIS_DB.
--  030510  ThPalk   Bug 37102, Changed method Make_Pick_Plan__ .
--  030509  MaMalk   Bug 37031, Changed the procedure Make_Additional_Reservations__ to show the correct Qty Reserved
--  030509           in Manual Reservation for Customer Order Lines.
--  030508  AnJplk   Modify procedure Make_Additional_Reservations__.
--  030508  ThPalk   Bug 37045, Changed method Pick_Plan_Order__  in order to correct the name of attribute ONHAND_ANALYSIS_FLAG_DB.
--  030505  GeKaLk   Bug 96380, Added a info_ parameter to Reserve_Manually__ method.
--  030428  MiKulk   Bug 37068, Added a check to the procedure Register_Purch_Order_Arrival for a package part with a Non inventory component part.
--  030409  PrTilk   Made the code review corrections.
--  030403  PrTilk   Changed the public method calls Modify_Po_Peg_Qty, Modify_So_Peg_Qty to
--  030403           Modify_Po_Peg_Qty__, Modify_Po_Peg_Qty__ in Reserve_Manually__ procedure.
--  030401  GeKaLk   Added a new method Consume_So_Peggings.
--  030331  PrTilk   Modified procedure Reserve_Manually__.
--  030328  GeKaLk   Modified Public Method Consume_Peggings.
--  030328  GeKaLk   Done code review modifications.
--  030328  AnJplk   Modified Procedure Reserve_Manually__.
--  030325  GeKaLk   Modified Public Method Consume_Peggings to add a check for the CO line state.
--  030325  CaRase   Bug 33537, Add check if qty_assign_ is minus set it to zero in procedure Unregister_Arrival___.
--  030324  GeKaLk   Modified Public Method Consume_Peggings to add an event.
--  030324  GeKaLk   Modified Public Method Consume_Peggings.
--  030321  GeKaLk   Added a new Public Method Consume_Peggings and removed Method Register_Purch_Order_Arrival.
--  030320  PrTilk   Modified Procedure Reserve_Manually__. Added code for handling of manual pegging.
--  030320  AnJplk   Modified Procedure Make_Pick_Plan__ and CURSOR get_lines in Procedure Pick_Plan_Lines___.
--  030318  AnJplk   Modified procedure Reserve_Order_Line__ .
--  030312  CaRase   Bug 33537, Add check of parameter qty_to_assign_ in procedure Unregister_Arrival___
--  030310  MaEelk   Added parameter condition_code to Inventory_Part_Loc_Pallet_API.Find_And_Reserve_Pallet
--                   called in Reserve_Line_At_Location___.
--  030214  CaRase   Bug 33537, Add procedure Unregister_Arrival___
--  030101  DayJlk   Bug 34696, Modified Function Line_Is_Fully_Reserved to handle Non-Inventory Parts.
--  021213  Asawlk   Merged bug fixes in 2002-3 SP3
--  021210  MKrase   Bug 34426, Removed check for objstate in Reserve_Manually__.
--  021024  SAABLK   Call Id 90413, Stop reservation if CO was made from an external service order, and no items in stock.
--  021023  Susalk   Bug 33363, Change the error message to add part_no as a parameter to display.
--  021018  MKrase   Bug 30258, Added new parameter delivery_leadtime_ to Reserve_Or_Make_Analysis__ and
--                   removed variabel delivery_leadtime_ in same procedure.
--  020919  JoAnSe   Merged the IceAge bugg corrections below onto the AD 2002-3 track.
--  020903  Samnlk   Bug 31820, restrick the reservation when the location type is 'Floor Stock' in PROCEDURE Reserve_Manually__
--  020829  ErFise   Bug 29508, Changed the handling of order lines with supply_code
--                   IPD in PROCEDURE Reserve_Or_Make_Analysis__.
--  020816  ShFeLk   Bug 29920, Added a new variable shortage_ and a call to function Customer_Order_Shortage_API.Get_Buy_Qty_Due in Backorder_Generated___
--  020816           Changed the text in RESERVMISSING in Pick_Plan_Order___
--  020628  MIGUUS   Bug 31336, Added error message in Reserve_Manually__ when customer is credit block.
--  020516  ANHO     Bug 29317, Added check on the manual reservation flag on availability control id for pallets.
--  ---------------------------------- IceAge Merge End ------------------------------------
--  020904  ARAMLK   Modified dynamic calls in method Reserve_Line_At_Location___.
--  020902  ARAMLK   Remove static calls to Purch_Connection_V1310AV_API in method Reserve_Line_At_Location. Instead added dynamic calls.
--  020827  Nabeus   Call 88214 - added condition_code_ parameter to
--                   Inventory_Part_In_Stock_API.Find_And_Reserve_Part in method
--                   Reserve_Line_At_Location___.
--  020626  SAABLK   Modified method Reserve_Line_At_Location to fetch serial no from purchase order when applicable.
--  -------------------------------2002-3 AV Baseline (Takeoff) ----------------
--  020516  SUAM     Changed the serial_no_ variable definition length from VARCHAR(15) TO VARCHAR(50).
--  020325  ANHO     Added check in Make_Additional_Reservations__ and Reserve_Manually__ regarding
--                   the manual reservation flag on availability control id in InventoryPartInStock.
--  010413  JaBa     Bug Fix 20598,Added new global lu constants to check logical unit installed.
--  010410  MaBl     Bug Id 20036, Added 'order by part_no' to cursor in Pick_Plan_Lines___ to avoid deadlock.
--  010215  JoAn     Bug Id 20036, Added new method Reserve_Order__ used for automatic reserval of orders in
--                   the order flow.
--                   Made some changes in Entire_Order_Reserved__, removed comparision with planned_due_date
--                   and added qty_shipdiff in the cursor.
--                   Also moved the body of Register_Arrival___ to the implementation section.
--  010208  JeAsse   Bug Fix 19689, Added call for Customer_Order_Shortage_API.New in method Reserve_Line_At_Location___
--                   so shortages get created in CustomerOrderShortage.
--  010206  ViPa     Bug fix 19665, Set warning status on the background job in order not to lose shortage records
--                   created, in proc. Pick_Plan_Order___.
--  010104  JoAn     Bug Id 18831, Added SAVEPOINT before_pick_plan and ROLLBACK TO before_pick_plan
--                   in Pick_Plan_Order___.
--  001219  CaSt     Correction of changes made 001127 and 001214. Call to Substitute_Sales_Part_API.
--  001218  JoAn     Added new method Reserve_Line_From_Shortage.
--  001214  JoAn     Bug Id 18555 Added new method Line_is_Fully_Reserved to be called from
--                   PO when trying to cancel a connected PO Line.
--  001214  CaSt     Changed error message TARGETDATECHG in Reserve_Or_Make_Analysis__ if substitute part does not exist.
--  001211  FBen     BugFix. Added qty_possible_to_assign_ as OUT parameter in Reserve_Line_At_Location___. Changed to qty_possible_to_assign_
--                   in error msg NO_ASSIGN_2 and NO_ASSIGN and Removed calls to Inventory_Part_In_Stock_API in Reserve_Or_Make_Analysis__.
--  001127  CaSt     Changed error message NO_ASSIGN in Reserve_Or_Make_Analysis__ if substitute part does not exist.
--  001027  DaZa     Added Reserve_From_Ctp.
--  001023  JakH     Added Feedback_From_Manufacturing and copied common part from that and Register_Purch_Order_Arrival
--                   into a new function Register_Arrival___
--  001020  JakH     Added configuration_id handling in calls to inventory_part_in_stock and customer_order_reservation
--  000913  FBen     Added UNDEFINED.
--  000906  JakH     Added source_type_ to Control_Ms_Mrp_Consumption__, in dynamic calls also.
--  000906  JakH     Changed call to Inventory_Part_API.Get_Forecast_Consumption_Flag to _db-version
--                   removed references to order-state 'Quoted' since it is nolonger present.
--  --------------------------- 13.0 ----------------------------------------
--  000426  PaLj     Changed check for installed logical units. A check is made when API is instantiatet.
--                   See beginning of api-file.
--  000229  SaMi     CID 33351:Request was spelled wrongly
--  000224  JoAn     Bug ID 15024 removed min in cursor non_inventory_to_deliver in Check_Package___.
--  000214  PaLj     CID 30036 = Bug fix 12889, Removed call to Shortage_Demand_API.Calculate_Order_Shortage_Qty
--                   and added calculation of qty_short_ in procedure Reserve_Order_Line__.
--  000203  SaMi     qty_On_hand_ modified in Reserve_Or_Make_analysis to show the reservable qty
--  000203  SAMi     Error messages in Reserve_or_Make_analays modified to sutie substitute sales part
--  000127  JoAn     Info message in Reserve_Or_Make_Analysis only created for
--                   non package lines.
--  ------------------------------ 12.0 -------------------------------------
--  991027  JoAn     Bug Id 12304 Made several changes in Reserve_Or_Make_Analysis__.
--  991012  PaLj     Removed view Reserv_Cust_Ord_Join. Not used.
--  990924  JoEd     Changed Register_Purch_Order_Arrival to handle non-inventory
--                   part lines.
--  990830  JoEd     Changed use of route_id, forward_agent_id and delivery_leadtime.
--  990823  sami     Reserve_Or_Make_Analysis dose nothing if supply_code_db_='ND'
--  990806  PaLj     Added view RESERVE_CUST_ORD_JOIN to support Consolidated Picklist
--  ------------------------------ 11.1 -------------------------------------
--  990527  JoEd     Changed error messages NO_ASSIGN, NOPICKING AND TARGETDATECHG
--                   to work with Localize.
--  990519  JICE     Added supply_code to Reserve_Or_Make_Analysis__, added handling
--                   of ms_mrp_consumption for all order types.
--  990514  JoAn     Bug Id 10377 Reservations of service parts in packages.
--                   Added cursor non_inventory_to_deliver in Check_Package___ method.
--  990415  JoAn     Made use of the new public Get methods.
--  990414  JoAn     Removed obsolete methods Reservations_Made__, Unpicked_Lines_Exist__
--  990412  JoAn     General Yoshimura performance improvements
--  990406  JakH     Y.CID 10582 Removed use of Gen_Def_Key_value. use '*' where possible.
--  990324  JoAn     Added check for credit blocked customer in Reserve_Manually__
--  990318  JICE     Removed order-line key to Control_Ms_Mrp_Consumption__
--  990308  JoAn     CID 4336 Corrected the number of reservations created in
--                   Register_Purch_Order_Arrival.
--  990301  JoAn     MS/MRP consumption called from Reserve_Or_Make_Analysis__
--                   event if supply_code = 'IO'
--  990226  JoAn     Call Id 4217 Package picking by batch routine.
--                   Corrected the bug and also rewrote parts of the code.
--                   Removed all the COMMITS made.
--  990222  JICE     Removed call to MS/MRP-consumption for supply_code = 'IO' (inventory order).
--  990218  JoAn     Added logic for preserving the time part of planned_delivery_date_
--                   in Reserve_Or_Make_Analysis__. Also added new parameters
--                   planned_ship_date_ and planned_ship_period_ to the same method.
--  990203  JoEd     Changed TARGETDATECHG info message.
--  990128  JICE     Additional changes to Control_Ms_Mrp_Consumption__
--  990127  JICE     Added order-line key to Control_Ms_Mrp_Consumption__
--  990127  JoEd     Rebuild Reserve_Or_Make_Analysis__ - added time to planned_delivery_date.
--  990118  PaLj     changed sysdate to Site_API.Get_Site_Date(contract)
--  990113  CAST     Changed so that waiv_dev_rej_no_ is assigned NULL in Reserve_Line_At_Location___.
--  981118  RaKu     SID 6755. Reservations went wrong when a priority order line was changed.
--                   Changes in Reserve_Or_Make_Analysis__.
--  981030  JoEd     Added error message where using calendar.
--  981027  JoEd     Replaced MpccomShopCalendar calls with new calendar WorkTimeCalendar.
--  981019  JoAn     Corrected dynamic call in Control_Ms_Mrp_Consumption___
--  981007  JoAn     Renamed the method Generate_Ms_Forecast___ to Control_Ms_Mrp_Consumption__
--                   also changed the logic in this method. The method is now private to allow calls
--                   from Cancel_Customer_Order.
--  981001  JoAn     Removed last parameter in call to Make_Onhand_Analysis.
--  980423  RaKu     Added status_check for header in Make_Pick_Plan__.
--  980422  JoAn     SID 2734 Changed error message in Generate_MS_Forecast___
--  980422  RaKu     SID 1694. Added contract as parameter in cursor in Make_Pick_Plan__.
--  980420  RaKu     Route-handling in Reserve_Or_Make_Analysis__ changed.
--  980420  RaKu     Added check for routes in Reserve_Or_Make_Analysis__.
--  980415  RaKu     Made Any_Pick_List_Printed__ public.
--  980403  DaZa     HEAT 4037 (SID 2899) Calculation of Planned Delivery Date on
--                   customer order is not correct. Changes made in
--                   Reserve_Or_Make_Analysis__.
--  980317  JoAn     Corrections in Generate_Ms_Forecast___
--  980316  JoAn     Added method Register_Purch_Order_Arrival
--  980313  JoAn     Corrected dynamic call made in Generate_Ms_Forecast___
--  980311  JoAn     Bugg 1243 Added TRUNC before date comparision in Reserve_Or_Make_Analysis__
--  980303  JoAn     Renamed Reserve_Priority_Order_Line__ to Reserve_Or_Make_Analysis__.
--                   Added functionality for MS forecast planning.
--  980302  MNYS     Bug 3372, Added check for Qty Reserved in Reserve_Manually__.
--  980217  JOHNI    Added new batch error handling.
--                   Changed cursor in Make_Pick_Plan__ to increase performance,
--                   removed the function Lines_To_Pick_Exist__.
--  980127  JoAn     Add controll for routing in the method Reserve_Priority_Order_Line__
--  971125  RaKu     Changed to FND200 Templates.
--  971104  JoAn     Changed the message passed to server in Reserve_Priority_Order_Line__
--                   when target date has been changed.
--  971028  RaKu     Added logic for handling of qty_rest in Reserve_Line_At_Location___.
--  971010  RoNi     Where-cluase modified in Reserved_With_No_Pick_List__.
--                   IID-function replaced with variable
--  971003  RaKu     Added User_Allowed_Site_API.Authorized(contract) in cursor in Make_Pick_Plan__.
--  970924  JoAn     Removed quotes in message passed to Client_SYS.Add_Info (translation problems)
--  970731  JOMU     Moved calculation and update of qty_short to beyond rollback.
--  970721  PHDE     Added shortage demand logic to reserve_order_line__.
--  970623  RaKu     Added function Any_Pick_List_Printed__.
--  970612  JoEd     Added info message if planned_delivery_date has changed in
--                   Reserve_Priority_Order_Line__.
--  970612  JoAn     Added call to Customer_Order_Flow_API.Credit_Check__ in
--                   Pick_Plan_Order___.
--  970604  JoEd     Added part no in the PLANNABLE message.
--  970603  RaKu     Changed Reserve_Order_Line__ to make reservations only
--                   if qty_to_reserve > 0.
--  970528  RaKu     Uncommented code in Make_Additional_Reservations__.
--  970528  JoAn     Changed cursor in Line_Reservations_Exist__ to check for
--                   qty_picked = 0.
--                   Added qty_shipdiff to cursors in Unpicked_Lines_Exist__ and
--                   Lines_To_Pick_Exist__.
--  970527  RaKu     Added history transactions in Reserve_Manually__.
--  970527  RaKu     Fixed bug in procedure Reserve_Order_Line__ with rcode_.
--  970521  RaKu     Added function Reserved_With_No_Pick_List__.
--  970515  JoEd     Removed parameters from Make_Pick_Plan__.
--  970514  JoEd     Added parameters to Make_Pick_Plan__.
--  970513  RaKu     Modifyed procedure Reserve_Manually__. Added pallet handling
--                   in Reserve_Line_At_Location___.
--  970430  RaKu     Added procedure Reserve_Manually__. Added pallet handling
--                   in Make_Additional_Reservations__. Removed function
--                   Code_Reservation_Locations__ and Get_Sum_Qty_Assigned.
--  970428  RaKu     Added pallet_id in calls to customer_order_reservation.
--  970423  JoAn     Removed all usage of status_code.
--  970422  RaKu     Removed obsolete function Order_Reservations_Exist__.
--                   Removed status_code from all calls to Customer_Order_Reservations.
--  970421  JoEd     Changed call to Customer_Order_Flow_API.Proceed_After_Pick_Planning__.
--  970417  JoEd     Beautified the code. Rebuild some methods. Removed procedure
--                   Code_Reservation_Location__.
--                   Replaced method call Modify_Qty_Assigned to
--                   Set_Line_Qty_Assigned.
--  970410  RaKu     Added procedure Make_Additional_Reservations__
--  970409  RaKu     Changed Code_Reservation_Locations__.
--  970404  RaKu     Added parameter qty_picked in call to
--                   Customer_Order_Reservation_API.New.
--  970319  RaKu     Added functions Get_Sum_Qty_Assigned and Code_Reservation_Locations__.
--  970203  RaKu     BugID = 97-0017 Changed constant ORDER_PROCESSED_WITH_FAILURE
--                   to ORDER_PROC_FAILURE.
--  961205  RaKu     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

string_null_ CONSTANT VARCHAR2(11) := Database_SYS.string_null_;

-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_     CONSTANT VARCHAR2(4) := Fnd_Boolean_API.db_true;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Make_Additional_Reservations___
-- Creates another reservation on specified picklist.
-- (Picklist created).
PROCEDURE Make_Additional_Reservation___ (
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   location_no_            IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   waiv_dev_rej_no_        IN VARCHAR2,
   eng_chg_level_          IN NUMBER,
   activity_seq_           IN NUMBER,
   handling_unit_id_       IN NUMBER,
   input_qty_              IN NUMBER,
   input_conv_factor_      IN NUMBER,
   input_unit_meas_        IN VARCHAR2,
   input_variable_values_  IN VARCHAR2,
   qty_to_reserve_         IN NUMBER,
   pick_list_no_           IN VARCHAR2,
   shipment_id_            IN NUMBER )
IS
   line_rec_                Customer_Order_Line_API.Public_Rec;
   contract_                customer_order_reservation_tab.contract%TYPE;
   part_no_                 customer_order_reservation_tab.part_no%TYPE;
   configuration_id_        customer_order_reservation_tab.configuration_id%TYPE;
   new_qty_assigned_        NUMBER;
   availability_control_id_ VARCHAR2(25);
   qty_can_reserve_         NUMBER;
   pur_peg_                 NUMBER;
   shp_peg_                 NUMBER;
   qty_adjust_              NUMBER;
   catch_quantity_          NUMBER := NULL;
   owning_vendor_no_        CUSTOMER_ORDER_LINE_TAB.vendor_no%TYPE;
BEGIN
   line_rec_         := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   contract_         := line_rec_.contract;
   part_no_          := line_rec_.part_no;
   configuration_id_ := line_rec_.configuration_id;

   -- Create new reservations.   
   -- Reserve in inventory.         
   -- Reserve single
   availability_control_id_ := Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract_         => contract_,
                                                                                       part_no_          => part_no_,
                                                                                       configuration_id_ => configuration_id_,
                                                                                       location_no_      => location_no_,
                                                                                       lot_batch_no_     => lot_batch_no_,
                                                                                       serial_no_        => serial_no_,
                                                                                       eng_chg_level_    => eng_chg_level_,
                                                                                       waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                       activity_seq_     => activity_seq_, 
                                                                                       handling_unit_id_ => handling_unit_id_);

   IF (Part_Availability_Control_API.Check_Man_Reservation_Control(availability_control_id_) != 'MANUAL_RESERV') THEN
      Raise_Part_Reserve_Error___(part_no_, availability_control_id_);
   END IF;

   IF line_rec_.part_ownership = 'SUPPLIER LOANED' THEN
      owning_vendor_no_ := Customer_Order_Line_API.Get_Owner_For_Part_Ownership(order_no_,line_no_,rel_no_,line_item_no_,line_rec_.part_ownership);
   END IF;
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
   Customer_Order_Reservation_API.New(order_no_                 => order_no_, 
                                      line_no_                  => line_no_, 
                                      rel_no_                   => rel_no_, 
                                      line_item_no_             => line_item_no_,
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
                                      qty_assigned_             => qty_to_reserve_, 
                                      qty_picked_               => 0, 
                                      qty_shipped_              => 0,
                                      input_qty_                => input_qty_, 
                                      input_unit_meas_          => input_unit_meas_, 
                                      input_conv_factor_        => input_conv_factor_, 
                                      input_variable_values_    => input_variable_values_, 
                                      preliminary_pick_list_no_ => NULL, 
                                      catch_qty_                => catch_quantity_);

   new_qty_assigned_ := line_rec_.qty_assigned + qty_to_reserve_;

   IF qty_to_reserve_ > 0 AND new_qty_assigned_ <= line_rec_.revised_qty_due THEN
      qty_can_reserve_ := (line_rec_.revised_qty_due - line_rec_.qty_assigned - line_rec_.qty_shipped - line_rec_.qty_on_order);
      qty_adjust_      := qty_to_reserve_ - qty_can_reserve_;
      pur_peg_         := Customer_Order_Pur_Order_Api.Get_Connected_Peggings(order_no_, line_no_, rel_no_, line_item_no_);
      shp_peg_         := Customer_Order_Shop_Order_Api.Get_Connected_Peggings(order_no_, line_no_, rel_no_, line_item_no_);
      IF ((pur_peg_ + shp_peg_)!=0 AND (qty_adjust_>0)) THEN
         Peg_Customer_Order_Api.Adjust_Pegging(pur_peg_, shp_peg_,qty_adjust_,order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   END IF;
   new_qty_assigned_ := Customer_Order_Line_API.Get_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_) + qty_to_reserve_;

   Customer_Order_API.Set_Line_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_, new_qty_assigned_);
END Make_Additional_Reservation___;


PROCEDURE Report_Line_Reservation___ (
   reservation_type_       IN VARCHAR2,
   supply_site_            IN VARCHAR2,
   demand_site_            IN VARCHAR2,
   source_id_              IN NUMBER,
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   stock_keys_and_qty_rec_ IN Inventory_Part_In_Stock_API.Keys_And_Qty_Rec,
   shipment_id_            IN NUMBER,
   revised_qty_due_        IN NUMBER,
   pick_list_no_           IN VARCHAR2 )
IS
   new_qty_assigned_ NUMBER;
   input_qty_               NUMBER         := NULL;
   input_unit_meas_         VARCHAR2(30)   := NULL;
   input_conv_factor_       NUMBER         := NULL;
   input_variable_values_   VARCHAR2(2000) := NULL;
   co_reservation_pub_rec_  Customer_Order_Reservation_API.Public_Rec;
   
   CURSOR get_mum_info IS
      SELECT input_qty,input_unit_meas,input_conv_factor,input_variable_values
      FROM customer_order_line_tab
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   IF (reservation_type_ = 'SupplyChainReservation') AND (supply_site_ != demand_site_) THEN
      IF (source_id_ IS NULL) THEN
         -- Supply chain reservation (call Co_Supply_Site_Reservation_API methods).
         -- We move the CO reservations to a temporary object (Co_Supply_Site_Reservation)
         -- before a new CO is created on the supply_site, the CO reservations will later be
         -- moved from Co_Supply_Site_Reservation to Customer_Order_Reservation.                
         IF (Co_Supply_Site_Reservation_API.Oe_Exist(order_no_         => order_no_, 
                                                     line_no_          => line_no_, 
                                                     rel_no_           => rel_no_, 
                                                     line_item_no_     => line_item_no_,
                                                     supply_site_      => stock_keys_and_qty_rec_.contract, 
                                                     part_no_          => stock_keys_and_qty_rec_.part_no, 
                                                     configuration_id_ => stock_keys_and_qty_rec_.configuration_id, 
                                                     location_no_      => stock_keys_and_qty_rec_.location_no, 
                                                     lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no, 
                                                     serial_no_        => stock_keys_and_qty_rec_.serial_no,
                                                     eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level, 
                                                     waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no, 
                                                     activity_seq_     => stock_keys_and_qty_rec_.activity_seq, 
                                                     handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id ) = 1) THEN

            new_qty_assigned_ := Co_Supply_Site_Reservation_API.Get_Qty_Assigned(order_no_         => order_no_,
                                                                                 line_no_          => line_no_,
                                                                                 rel_no_           => rel_no_,
                                                                                 line_item_no_     => line_item_no_,
                                                                                 supply_site_      => stock_keys_and_qty_rec_.contract,
                                                                                 part_no_          => stock_keys_and_qty_rec_.part_no,
                                                                                 configuration_id_ => stock_keys_and_qty_rec_.configuration_id,
                                                                                 location_no_      => stock_keys_and_qty_rec_.location_no,
                                                                                 lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no,
                                                                                 serial_no_        => stock_keys_and_qty_rec_.serial_no,
                                                                                 eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level,
                                                                                 waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no,
                                                                                 activity_seq_     => stock_keys_and_qty_rec_.activity_seq,
                                                                                 handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id ) +
                                                                                                      stock_keys_and_qty_rec_.quantity;  
            Co_Supply_Site_Reservation_API.Modify_Qty_Assigned(order_no_         => order_no_,
                                                               line_no_          => line_no_,
                                                               rel_no_           => rel_no_,
                                                               line_item_no_     => line_item_no_,
                                                               supply_site_      => stock_keys_and_qty_rec_.contract,
                                                               part_no_          => stock_keys_and_qty_rec_.part_no,
                                                               configuration_id_ => stock_keys_and_qty_rec_.configuration_id,
                                                               location_no_      => stock_keys_and_qty_rec_.location_no,
                                                               lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no,
                                                               serial_no_        => stock_keys_and_qty_rec_.serial_no,
                                                               eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level,
                                                               waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no,
                                                               activity_seq_     => stock_keys_and_qty_rec_.activity_seq,
                                                               handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id,
                                                               qty_assigned_     => new_qty_assigned_);
         ELSE
            Co_Supply_Site_Reservation_API.New(order_no_         => order_no_,
                                               line_no_          => line_no_,
                                               rel_no_           => rel_no_,
                                               line_item_no_     => line_item_no_,
                                               supply_site_      => stock_keys_and_qty_rec_.contract,
                                               part_no_          => stock_keys_and_qty_rec_.part_no,
                                               configuration_id_ => stock_keys_and_qty_rec_.configuration_id,
                                               location_no_      => stock_keys_and_qty_rec_.location_no,
                                               lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no,
                                               serial_no_        => stock_keys_and_qty_rec_.serial_no,
                                               eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level,
                                               waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no,
                                               activity_seq_     => stock_keys_and_qty_rec_.activity_seq,
                                               handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id,
                                               qty_assigned_     => stock_keys_and_qty_rec_.quantity);      
         END IF;
      ELSE
         -- Sourced Supply chain reservation (call Sourced_Co_Supply_Site_Res_API methods).
         -- We move the Sourced CO reservations to a temporary object (Sourced_Co_Supply_Site_Res)
         -- before a new CO is created on the supply_site, the sourced CO reservations will later be
         -- moved from Sourced_Co_Supply_Site_Res to Co_Supply_Site_Reservation when the sourced line
         -- is converted to customer order line.
         IF (Sourced_Co_Supply_Site_Res_API.Oe_Exist(order_no_         => order_no_, 
                                                     line_no_          => line_no_, 
                                                     rel_no_           => rel_no_, 
                                                     line_item_no_     => line_item_no_,
                                                     source_id_        => source_id_, 
                                                     supply_site_      => stock_keys_and_qty_rec_.contract, 
                                                     part_no_          => stock_keys_and_qty_rec_.part_no, 
                                                     configuration_id_ => stock_keys_and_qty_rec_.configuration_id, 
                                                     location_no_      => stock_keys_and_qty_rec_.location_no, 
                                                     lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no,
                                                     serial_no_        => stock_keys_and_qty_rec_.serial_no, 
                                                     eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level, 
                                                     waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no, 
                                                     activity_seq_     => stock_keys_and_qty_rec_.activity_seq, 
                                                     handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id ) = 1) THEN

            new_qty_assigned_ := Sourced_Co_Supply_Site_Res_API.Get_Qty_Assigned(order_no_         => order_no_,
                                                                                 line_no_          => line_no_,
                                                                                 rel_no_           => rel_no_,
                                                                                 line_item_no_     => line_item_no_,
                                                                                 source_id_        => source_id_,
                                                                                 supply_site_      => stock_keys_and_qty_rec_.contract,
                                                                                 part_no_          => stock_keys_and_qty_rec_.part_no,
                                                                                 configuration_id_ => stock_keys_and_qty_rec_.configuration_id,
                                                                                 location_no_      => stock_keys_and_qty_rec_.location_no,
                                                                                 lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no,
                                                                                 serial_no_        => stock_keys_and_qty_rec_.serial_no,
                                                                                 eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level,
                                                                                 waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no,
                                                                                 activity_seq_     => stock_keys_and_qty_rec_.activity_seq,
                                                                                 handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id ) +
                                                                                                      stock_keys_and_qty_rec_.quantity;  

            Sourced_Co_Supply_Site_Res_API.Modify_Qty_Assigned(order_no_         => order_no_,
                                                               line_no_          => line_no_,
                                                               rel_no_           =>  rel_no_,
                                                               line_item_no_     => line_item_no_,                                                                     
                                                               source_id_        => source_id_,
                                                               supply_site_      => stock_keys_and_qty_rec_.contract,
                                                               part_no_          => stock_keys_and_qty_rec_.part_no,
                                                               configuration_id_ => stock_keys_and_qty_rec_.configuration_id,
                                                               location_no_      => stock_keys_and_qty_rec_.location_no,
                                                               lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no,
                                                               serial_no_        => stock_keys_and_qty_rec_.serial_no,
                                                               eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level,
                                                               waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no,
                                                               activity_seq_     => stock_keys_and_qty_rec_.activity_seq,
                                                               handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id,                                                              
                                                               qty_assigned_     => new_qty_assigned_);   
         ELSE
            Sourced_Co_Supply_Site_Res_API.New(order_no_         => order_no_,
                                               line_no_          => line_no_,
                                               rel_no_           =>  rel_no_,
                                               line_item_no_     => line_item_no_,                                                                     
                                               source_id_        => source_id_,
                                               supply_site_      => stock_keys_and_qty_rec_.contract,
                                               part_no_          => stock_keys_and_qty_rec_.part_no,
                                               configuration_id_ => stock_keys_and_qty_rec_.configuration_id,
                                               location_no_      => stock_keys_and_qty_rec_.location_no,
                                               lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no,
                                               serial_no_        => stock_keys_and_qty_rec_.serial_no,
                                               eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level,
                                               waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no,
                                               activity_seq_     => stock_keys_and_qty_rec_.activity_seq,
                                               handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id,
                                               qty_assigned_     => stock_keys_and_qty_rec_.quantity);   
         END IF;
      END IF;
   ELSIF (supply_site_ = demand_site_) AND (source_id_ IS NOT NULL) THEN
      -- Sourced Local Site Reservation  (Inventory Order)
      -- This will also be saved on the temporary source reservation object (Sourced_Co_Supply_Site_Res)
      -- and later be moved to Customer_Order_Reservation when the sourced line is transfered to a CO line
      IF (Sourced_Co_Supply_Site_Res_API.Oe_Exist(order_no_         => order_no_, 
                                                  line_no_          => line_no_, 
                                                  rel_no_           => rel_no_, 
                                                  line_item_no_     => line_item_no_,
                                                  source_id_        => source_id_, 
                                                  supply_site_      => stock_keys_and_qty_rec_.contract, 
                                                  part_no_          => stock_keys_and_qty_rec_.part_no, 
                                                  configuration_id_ => stock_keys_and_qty_rec_.configuration_id, 
                                                  location_no_      => stock_keys_and_qty_rec_.location_no, 
                                                  lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no,
                                                  serial_no_        => stock_keys_and_qty_rec_.serial_no, 
                                                  eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level, 
                                                  waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no, 
                                                  activity_seq_     => stock_keys_and_qty_rec_.activity_seq, 
                                                  handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id ) = 1) THEN

         new_qty_assigned_ := Sourced_Co_Supply_Site_Res_API.Get_Qty_Assigned(order_no_         => order_no_,
                                                                              line_no_          => line_no_,
                                                                              rel_no_           => rel_no_,
                                                                              line_item_no_     => line_item_no_,
                                                                              source_id_        => source_id_,
                                                                              supply_site_      => stock_keys_and_qty_rec_.contract,
                                                                              part_no_          => stock_keys_and_qty_rec_.part_no,
                                                                              configuration_id_ => stock_keys_and_qty_rec_.configuration_id,
                                                                              location_no_      => stock_keys_and_qty_rec_.location_no,
                                                                              lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no,
                                                                              serial_no_        => stock_keys_and_qty_rec_.serial_no,
                                                                              eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level,
                                                                              waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no,
                                                                              activity_seq_     => stock_keys_and_qty_rec_.activity_seq,
                                                                              handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id ) +
                                                                                                   stock_keys_and_qty_rec_.quantity;

         Sourced_Co_Supply_Site_Res_API.Modify_Qty_Assigned(order_no_         => order_no_,
                                                            line_no_          => line_no_,
                                                            rel_no_           =>  rel_no_,
                                                            line_item_no_     => line_item_no_,                                                                     
                                                            source_id_        => source_id_,
                                                            supply_site_      => stock_keys_and_qty_rec_.contract,
                                                            part_no_          => stock_keys_and_qty_rec_.part_no,
                                                            configuration_id_ => stock_keys_and_qty_rec_.configuration_id,
                                                            location_no_      => stock_keys_and_qty_rec_.location_no,
                                                            lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no,
                                                            serial_no_        => stock_keys_and_qty_rec_.serial_no,
                                                            eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level,
                                                            waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no,
                                                            activity_seq_     => stock_keys_and_qty_rec_.activity_seq,
                                                            handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id,                                                                
                                                            qty_assigned_     => new_qty_assigned_);
      ELSE
         Sourced_Co_Supply_Site_Res_API.New(order_no_         => order_no_,
                                            line_no_          => line_no_,
                                            rel_no_           =>  rel_no_,
                                            line_item_no_     => line_item_no_,                                                                     
                                            source_id_        => source_id_,
                                            supply_site_      => stock_keys_and_qty_rec_.contract,
                                            part_no_          => stock_keys_and_qty_rec_.part_no,
                                            configuration_id_ => stock_keys_and_qty_rec_.configuration_id,
                                            location_no_      => stock_keys_and_qty_rec_.location_no,
                                            lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no,
                                            serial_no_        => stock_keys_and_qty_rec_.serial_no,
                                            eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level,
                                            waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no,
                                            activity_seq_     => stock_keys_and_qty_rec_.activity_seq,
                                            handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id,
                                            qty_assigned_     => stock_keys_and_qty_rec_.quantity);
      END IF;
   ELSE
      -- Normal reservation (call  Customer_Order_Reservation_API methods)
      IF (Customer_Order_Reservation_API.Oe_Exist(order_no_         => order_no_, 
                                                  line_no_          => line_no_, 
                                                  rel_no_           => rel_no_, 
                                                  line_item_no_     => line_item_no_,
                                                  contract_         => stock_keys_and_qty_rec_.contract, 
                                                  part_no_          => stock_keys_and_qty_rec_.part_no, 
                                                  location_no_      => stock_keys_and_qty_rec_.location_no, 
                                                  lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no, 
                                                  serial_no_        => stock_keys_and_qty_rec_.serial_no, 
                                                  eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level,
                                                  waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no, 
                                                  activity_seq_     => stock_keys_and_qty_rec_.activity_seq, 
                                                  handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id,
                                                  pick_list_no_     => pick_list_no_, 
                                                  configuration_id_ => stock_keys_and_qty_rec_.configuration_id, 
                                                  shipment_id_      => shipment_id_) = 1) THEN
         
         co_reservation_pub_rec_ := Customer_Order_Reservation_API.Get(order_no_         => order_no_, 
                                                                       line_no_          => line_no_, 
                                                                       rel_no_           => rel_no_, 
                                                                       line_item_no_     => line_item_no_,
                                                                       contract_         => stock_keys_and_qty_rec_.contract, 
                                                                       part_no_          => stock_keys_and_qty_rec_.part_no, 
                                                                       location_no_      => stock_keys_and_qty_rec_.location_no, 
                                                                       lot_batch_no_     => stock_keys_and_qty_rec_.lot_batch_no, 
                                                                       serial_no_        => stock_keys_and_qty_rec_.serial_no, 
                                                                       eng_chg_level_    => stock_keys_and_qty_rec_.eng_chg_level,
                                                                       waiv_dev_rej_no_  => stock_keys_and_qty_rec_.waiv_dev_rej_no, 
                                                                       activity_seq_     => stock_keys_and_qty_rec_.activity_seq, 
                                                                       handling_unit_id_ => stock_keys_and_qty_rec_.handling_unit_id,
                                                                       pick_list_no_     => pick_list_no_, 
                                                                       configuration_id_ => stock_keys_and_qty_rec_.configuration_id, 
                                                                       shipment_id_      => shipment_id_);

         new_qty_assigned_ := co_reservation_pub_rec_.qty_assigned + stock_keys_and_qty_rec_.quantity;
         
         IF co_reservation_pub_rec_.input_conv_factor IS NOT NULL THEN 
            co_reservation_pub_rec_.input_qty               := new_qty_assigned_ / co_reservation_pub_rec_.input_conv_factor;
            co_reservation_pub_rec_.input_variable_values   := Input_Unit_Meas_API.Get_Input_Value_String(co_reservation_pub_rec_.input_qty, co_reservation_pub_rec_.input_unit_meas);
         END IF;

         Customer_Order_Reservation_API.Modify_Qty_Assigned(order_no_              => order_no_, 
                                                            line_no_               => line_no_, 
                                                            rel_no_                => rel_no_, 
                                                            line_item_no_          => line_item_no_,
                                                            contract_              => stock_keys_and_qty_rec_.contract, 
                                                            part_no_               => stock_keys_and_qty_rec_.part_no, 
                                                            location_no_           => stock_keys_and_qty_rec_.location_no, 
                                                            lot_batch_no_          => stock_keys_and_qty_rec_.lot_batch_no, 
                                                            serial_no_             => stock_keys_and_qty_rec_.serial_no, 
                                                            eng_chg_level_         => stock_keys_and_qty_rec_.eng_chg_level, 
                                                            waiv_dev_rej_no_       => stock_keys_and_qty_rec_.waiv_dev_rej_no,
                                                            activity_seq_          => stock_keys_and_qty_rec_.activity_seq, 
                                                            handling_unit_id_      => stock_keys_and_qty_rec_.handling_unit_id,
                                                            pick_list_no_          => pick_list_no_, 
                                                            configuration_id_      => stock_keys_and_qty_rec_.configuration_id, 
                                                            shipment_id_           => shipment_id_, 
                                                            qty_assigned_          => new_qty_assigned_, 
                                                            input_qty_             => co_reservation_pub_rec_.input_qty, 
                                                            input_unit_meas_       => co_reservation_pub_rec_.input_unit_meas, 
                                                            input_conv_factor_     => co_reservation_pub_rec_.input_conv_factor,  
                                                            input_variable_values_ => co_reservation_pub_rec_.input_variable_values);
      ELSE
         OPEN get_mum_info;
         FETCH get_mum_info INTO input_qty_, input_unit_meas_, input_conv_factor_, input_variable_values_;
         CLOSE get_mum_info;

         IF input_conv_factor_ IS NOT NULL THEN 
            input_qty_ := stock_keys_and_qty_rec_.quantity / input_conv_factor_;
            input_variable_values_  := Input_Unit_Meas_API.Get_Input_Value_String(input_qty_, input_unit_meas_);
         END IF;
         
         Customer_Order_Reservation_API.New(order_no_                 => order_no_, 
                                            line_no_                  => line_no_, 
                                            rel_no_                   => rel_no_, 
                                            line_item_no_             => line_item_no_,
                                            contract_                 => stock_keys_and_qty_rec_.contract, 
                                            part_no_                  => stock_keys_and_qty_rec_.part_no, 
                                            location_no_              => stock_keys_and_qty_rec_.location_no, 
                                            lot_batch_no_             => stock_keys_and_qty_rec_.lot_batch_no, 
                                            serial_no_                => stock_keys_and_qty_rec_.serial_no, 
                                            eng_chg_level_            => stock_keys_and_qty_rec_.eng_chg_level,
                                            waiv_dev_rej_no_          => stock_keys_and_qty_rec_.waiv_dev_rej_no, 
                                            activity_seq_             => stock_keys_and_qty_rec_.activity_seq, 
                                            handling_unit_id_         => stock_keys_and_qty_rec_.handling_unit_id,
                                            pick_list_no_             => pick_list_no_, 
                                            configuration_id_         => stock_keys_and_qty_rec_.configuration_id, 
                                            shipment_id_              => shipment_id_, 
                                            qty_assigned_             => stock_keys_and_qty_rec_.quantity,
                                            qty_picked_               => 0, 
                                            qty_shipped_              => 0, 
                                            input_qty_                => input_qty_, 
                                            input_unit_meas_          => input_unit_meas_, 
                                            input_conv_factor_        => input_conv_factor_, 
                                            input_variable_values_    => input_variable_values_, 
                                            preliminary_pick_list_no_ => NULL, 
                                            catch_qty_                => stock_keys_and_qty_rec_.catch_quantity);

         IF (stock_keys_and_qty_rec_.to_location_no IS NOT NULL) THEN
            Inv_Part_Stock_Reservation_API.Move_New_With_Transport_Task(stock_keys_and_qty_rec_      => stock_keys_and_qty_rec_,
                                                                        order_supply_demand_type_db_ => Order_Supply_Demand_Type_API.DB_CUST_ORDER,
                                                                        order_no_                    => order_no_,
                                                                        line_no_                     => line_no_,
                                                                        release_no_                  => rel_no_,
                                                                        line_item_no_                => line_item_no_,
                                                                        pick_list_no_                => pick_list_no_,
                                                                        shipment_id_                 => shipment_id_);
         END IF;
      END IF;
   END IF;
END Report_Line_Reservation___;

-- Reserve_Line_At_Location___
--   Find out available locations in inventory and reserve order_line.
--   For a normal reservation, contract_ = demand site/first CO
--   For a supply chain reservation, contract_ = supply site/second CO
--   For pick and adjust we sent in inventory part in stock keys plus pick list number
PROCEDURE Reserve_Line_At_Location___ (
   qty_possible_to_assign_    OUT NUMBER,
   sum_qty_assigned_       IN OUT NUMBER,
   objid_                  IN     VARCHAR2,
   order_no_               IN     VARCHAR2,
   line_no_                IN     VARCHAR2,
   rel_no_                 IN     VARCHAR2,
   line_item_no_           IN     NUMBER,
   source_id_              IN     NUMBER,
   contract_               IN     VARCHAR2,
   part_no_                IN     VARCHAR2,
   qty_to_assign_          IN     NUMBER,
   reservation_type_       IN     VARCHAR2,
   shipment_id_            IN     NUMBER,
   location_no_            IN     VARCHAR2 DEFAULT NULL,
   lot_batch_no_           IN     VARCHAR2 DEFAULT NULL,
   serial_no_              IN     VARCHAR2 DEFAULT NULL,
   eng_chg_level_          IN     VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_        IN     VARCHAR2 DEFAULT NULL,
   activity_seq_           IN     NUMBER   DEFAULT NULL,
   handling_unit_id_       IN     NUMBER   DEFAULT NULL,
   pick_list_no_           IN     VARCHAR2 DEFAULT '*' )
IS
   picked_                  BOOLEAN;
   dummy_date_              DATE;
   test_date_               DATE := TRUNC(Site_API.Get_Site_Date(contract_));
   qty_to_be_reserved_      NUMBER;
   qty_left_to_be_reserved_ NUMBER;
   qty_possible_            NUMBER;
   local_lot_batch_no_      VARCHAR2(20);
   local_serial_no_         VARCHAR2(50);
   shortage_qty_            NUMBER;
   result_                  VARCHAR2(80);
   configuration_id_        VARCHAR2(50);
   purch_part_no_           VARCHAR2(25);
   condition_code_          VARCHAR2(10);
   service_type_            VARCHAR2(20);
   is_ext_serv_ord_         BOOLEAN;
   part_ownership_db_       VARCHAR2(20);
   reserve_ownership_       VARCHAR2(50);
   owning_vendor_no_        CUSTOMER_ORDER_LINE_TAB.vendor_no%TYPE;
   exchange_item_           VARCHAR2(20);
   line_rec_                Customer_Order_Line_API.Public_Rec;
   supply_site_             VARCHAR2(5);
   demand_site_             VARCHAR2(5);
   demand_order_ref1_       CUSTOMER_ORDER_LINE_TAB.demand_order_ref1%TYPE;
   demand_order_ref2_       CUSTOMER_ORDER_LINE_TAB.demand_order_ref2%TYPE;
   demand_order_ref3_       CUSTOMER_ORDER_LINE_TAB.demand_order_ref3%TYPE;
   demand_order_ref4_       CUSTOMER_ORDER_LINE_TAB.demand_order_ref4%TYPE;
   order_code_              VARCHAR2(3);
   local_activity_seq_      NUMBER         := 0;
   project_id_              VARCHAR2(10)   := NULL;
   reservation_info_        VARCHAR2(1000) := NULL;
   order_line_info_         VARCHAR2(100)  := NULL;
   inv_part_rec_            Inventory_Part_API.Public_Rec;
   part_catalog_rec_        Part_Catalog_API.Public_Rec;
   backorder_option_db_     VARCHAR2(40);
   expiration_control_date_ DATE;
   min_durab_days_co_deliv_ NUMBER;
   demand_code_             VARCHAR2(20);
   wo_no_                   NUMBER;
   counter_                 NUMBER;
   stock_keys_and_qty_tab_  Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   shipment_quantity_tab_   Shipment_Line_API.Shipment_Quantity_Tab;
   try_to_reserve_again_    BOOLEAN;
   material_allocation_     VARCHAR2(30)  := NULL;
   ignore_this_avail_control_id_    VARCHAR2(25);   
   
   $IF Component_Purch_SYS.INSTALLED $THEN
      pur_ord_exg_comp_rec_ Pur_Order_Exchange_Comp_API.Public_Rec;  
      pur_ord_cha_comp_rec_ Purchase_Order_Line_Part_Api.Public_Rec;      
   $END

   CURSOR get_demand_info IS
      SELECT demand_order_ref1, demand_order_ref2, demand_order_ref3, demand_order_ref4, demand_code
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   picked_                  := FALSE;
   qty_to_be_reserved_      := qty_to_assign_;
   sum_qty_assigned_        := 0;
   qty_possible_to_assign_  := 0;
   line_rec_                := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   supply_site_             := contract_;
   demand_site_             := line_rec_.contract;
   shortage_qty_            := line_rec_.qty_short;
   configuration_id_        := line_rec_.configuration_id;
   condition_code_          := line_rec_.condition_code;
   part_ownership_db_       := line_rec_.part_ownership;
   exchange_item_           := line_rec_.exchange_item;
   inv_part_rec_            := Inventory_Part_API.Get(contract_, part_no_);
   min_durab_days_co_deliv_ := inv_part_rec_.min_durab_days_co_deliv;
   expiration_control_date_ := Get_Expiration_Control_Date___(line_rec_.planned_delivery_date, test_date_, min_durab_days_co_deliv_, order_no_, line_no_, rel_no_, line_item_no_, contract_, part_no_);

   IF (line_rec_.rel_mtrl_planning = 'FALSE') AND (Site_To_Site_Reserve_Setup_API.Get_Rel_Mtrl_Planning_Db(line_rec_.supply_site, line_rec_.contract) != Rel_Mtrl_Planning_API.DB_NOT_VIS_PLANNED_RELEASED) THEN
      Check_Release_For_Mtrl_plan___(order_no_, line_no_, rel_no_, part_no_);
      RETURN;
   END IF;
   
   -- convert the demand site inv uom quantity to supply site inv uom, this method should only work in the inv uom that the current site (could be demand or supply site) is using
   shortage_qty_        := Inventory_Part_API.Get_Site_Converted_Qty(line_rec_.contract,part_no_,contract_, shortage_qty_,'ADD');
   backorder_option_db_ := Customer_Order_API.Get_Backorder_Option_Db(order_no_);

   -- For non-rental lines, Parts in consignment cannot be reserved if the order use Delivery Confirmation or Consignment stock.
   -- For rental lines, when supply site reservations are made, priority is given to company rental assets.
   IF (line_rec_.rental = Fnd_Boolean_API.DB_FALSE AND
      ((Customer_Order_API.Get_Confirm_Deliveries_Db(order_no_) = 'TRUE') OR (line_rec_.consignment_stock = 'CONSIGNMENT STOCK'))) THEN
      reserve_ownership_ := 'COMPANY OWNED NOT CONSIGNMENT';
   ELSIF (line_rec_.rental = Fnd_Boolean_API.DB_TRUE AND part_ownership_db_ = Part_Ownership_API.DB_SUPPLIER_RENTED AND reservation_type_= 'SupplyChainReservation') THEN     
      reserve_ownership_ := Part_Ownership_API.DB_COMPANY_RENTAL_ASSET;
   ELSE
      reserve_ownership_ := part_ownership_db_;
   END IF;
   
   OPEN get_demand_info;
   FETCH get_demand_info INTO demand_order_ref1_, demand_order_ref2_, demand_order_ref3_, demand_order_ref4_, demand_code_;
   CLOSE get_demand_info;

   order_line_info_ := order_no_ ||' '|| line_no_ ||' '|| rel_no_;

   IF (line_rec_.supply_code IN ('PI','PJD')) THEN
      Trace_SYS.Message('Parts reserved from Project Inventory.');
      -- Reserve from project inventory.
      project_id_   := line_rec_.project_id;
      local_activity_seq_ := NVL(line_rec_.activity_seq, 0);
   ELSE
      Trace_SYS.Message('Parts reserved from Standard Inventory.');
      -- Reserve from Standard inventory.
      project_id_   := NULL;
      local_activity_seq_ := 0;
   END IF;

   IF (activity_seq_ IS NOT NULL) AND local_activity_seq_ != activity_seq_ THEN
      $IF Component_Proj_SYS.INSTALLED $THEN
         IF project_id_ IS NOT NULL THEN 
            material_allocation_ := Project_API.Get_Material_Allocation_Db(project_id_);
         END IF ; 
      $END
      IF NOT (material_allocation_ IN ('WITHIN_ACTIVITY','WITHIN_PROJECT') AND demand_order_ref1_ IS NOT NULL) THEN
         -- write an info message to bakground
         Error_SYS.Record_General( lu_name_, 'NOTALLOWEDACTIVITYSEQ: Activity sequence :P1 is not allowed within project :P2.', activity_seq_, project_id_);
      END IF ;
      local_activity_seq_ := activity_seq_;
   END IF ;
   
   IF part_ownership_db_ = 'SUPPLIER LOANED' THEN
      owning_vendor_no_ := Customer_Order_Line_API.Get_Owner_For_Part_Ownership(order_no_,line_no_,rel_no_,line_item_no_,part_ownership_db_);
   END IF;

   Trace_Sys.Message('Condition code: '||condition_code_||
                     ' Configuration_id: '||configuration_id_);
   IF (inv_part_rec_.co_reserve_onh_analys_flag = 'Y') THEN
      IF (line_rec_.supply_code IN ('PI','PJD')) THEN
         Inventory_Part_In_Stock_API.Make_Onhand_Analysis(result_                => result_, 
                                                          qty_possible_          => qty_possible_, 
                                                          next_analysis_date_    => dummy_date_,
                                                          planned_delivery_date_ => dummy_date_, 
                                                          planned_due_date_      => test_date_, 
                                                          contract_              => contract_,
                                                          part_no_               => part_no_, 
                                                          configuration_id_      => configuration_id_,
                                                          include_standard_      => 'FALSE', 
                                                          include_project_       => 'TRUE', 
                                                          project_id_            => line_rec_.project_id, 
                                                          activity_seq_          => activity_seq_, 
                                                          row_id_                => objid_,
                                                          qty_desired_           => qty_to_assign_, 
                                                          picking_leadtime_      => line_rec_.picking_leadtime, 
                                                          part_ownership_        => part_ownership_db_,
                                                          owning_vendor_no_      => owning_vendor_no_, 
                                                          owning_customer_no_    => line_rec_.owning_customer_no);
      ELSE
         Inventory_Part_In_Stock_API.Make_Onhand_Analysis(result_                => result_, 
                                                          qty_possible_          => qty_possible_, 
                                                          next_analysis_date_    => dummy_date_,
                                                          planned_delivery_date_ => dummy_date_, 
                                                          planned_due_date_      => test_date_, 
                                                          contract_              => contract_,
                                                          part_no_               => part_no_, 
                                                          configuration_id_      => configuration_id_,
                                                          include_standard_      => 'TRUE', 
                                                          include_project_       => 'FALSE', 
                                                          project_id_            => NULL, 
                                                          activity_seq_          => NULL, 
                                                          row_id_                => objid_,
                                                          qty_desired_           => qty_to_assign_, 
                                                          picking_leadtime_      => line_rec_.picking_leadtime, 
                                                          part_ownership_        => part_ownership_db_,
                                                          owning_vendor_no_      => owning_vendor_no_, 
                                                          owning_customer_no_    => line_rec_.owning_customer_no);
      END IF;
      IF (result_ != 'SUCCESS' AND location_no_ IS NOT NULL) THEN
         Error_SYS.Record_General( lu_name_, 'CANNOTRESERVEALL: All reservations cannot be made for part :P1 on order line :P2.',
                                   part_no_, order_line_info_);
      END IF ;
      
      IF (result_ != 'SUCCESS') THEN

         IF (backorder_option_db_ IN ('NO PARTIAL DELIVERIES ALLOWED', 'INCOMPLETE LINES NOT ALLOWED')) THEN
            qty_possible_to_assign_ := qty_possible_;
            Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, line_item_no_, 'PLANPICK01');
            reservation_info_       := Language_SYS.Translate_Constant(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                                                       NULL, part_no_, order_line_info_);
            IF (Transaction_SYS.Is_Session_Deferred) THEN
               Transaction_SYS.Set_Status_Info(reservation_info_);
            ELSE
               Client_SYS.Add_Info(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                   part_no_, order_line_info_);
            END IF;
            RETURN;
         ELSIF (qty_possible_ <= 0) THEN
            Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, line_item_no_, 'PLANPICK05');
            reservation_info_ := Language_SYS.Translate_Constant(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                                                 NULL, part_no_, order_line_info_);
            IF (Transaction_SYS.Is_Session_Deferred) THEN
               Transaction_SYS.Set_Status_Info(reservation_info_);
            ELSE
               Client_SYS.Add_Info(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                   part_no_, order_line_info_);
            END IF;
            RETURN;
         ELSE
            qty_to_be_reserved_ := qty_possible_;
         END IF;
      END IF;
   END IF;

   @ApproveTransactionStatement(2014-08-15,darklk)
   SAVEPOINT before_reserving;

   purch_part_no_ := part_no_;

   IF (demand_code_ IN ('PO', 'IPD', 'IPT')) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         Pur_Ord_Charged_Comp_API.Get_Serial_Lot_Service_Type(local_lot_batch_no_, local_serial_no_, service_type_, 
                                                              order_no_, line_no_, rel_no_, line_item_no_, purch_part_no_);
   
         is_ext_serv_ord_ := (service_type_ IS NOT NULL);

         IF demand_order_ref1_ IS NOT NULL THEN
            order_code_ := Purchase_Order_Line_Part_API.Get_Order_Code(demand_order_ref1_, demand_order_ref2_, demand_order_ref3_); 
         END IF;
      $END

      IF order_code_ = '6' THEN
         $IF Component_Purch_SYS.INSTALLED $THEN
             pur_ord_cha_comp_rec_ := Purchase_Order_Line_Part_API.Get(demand_order_ref1_,
                                                                       demand_order_ref2_,
                                                                       demand_order_ref3_);
             local_lot_batch_no_   := pur_ord_cha_comp_rec_.lot_batch_no;
             local_serial_no_      := pur_ord_cha_comp_rec_.serial_no;
             service_type_         := pur_ord_cha_comp_rec_.service_type; 
         $END
  
         is_ext_serv_ord_ := (service_type_ IS NOT NULL);
      END IF;
      
      IF is_ext_serv_ord_ THEN
         part_catalog_rec_ := Part_Catalog_API.Get(purch_part_no_);

         IF ((local_serial_no_ IS NULL) AND (part_catalog_rec_.receipt_issue_serial_track = db_true_)) THEN
            Error_SYS.Record_General(lu_name_, 'ESONOSERIALCODE: Customer Order cannot be reserved without specifying a serial no.');
         END IF;
         IF ((local_lot_batch_no_ IS NULL) AND (part_catalog_rec_.lot_tracking_code = 'LOT TRACKING')) THEN
            Error_SYS.Record_General(lu_name_, 'ESONOLOTCODE: Customer Order cannot be reserved without specifying a lot batch no.');
         END IF;
      END IF;   
     
      IF (exchange_item_ = 'EXCHANGED ITEM') THEN
         $IF Component_Purch_SYS.INSTALLED $THEN
            IF demand_order_ref1_ IS NOT NULL THEN 
               pur_ord_exg_comp_rec_ := Pur_Order_Exchange_Comp_API.Get(demand_order_ref1_, demand_order_ref2_, demand_order_ref3_);                                                                                  
               local_lot_batch_no_         := pur_ord_exg_comp_rec_.lot_batch_no;
               local_serial_no_            := pur_ord_exg_comp_rec_.serial_no; 
            END IF;
         $ELSE
            NULL;    
         $END
      END IF;
      IF local_lot_batch_no_ IS NOT NULL AND lot_batch_no_ IS NOT NULL AND local_lot_batch_no_ != lot_batch_no_ THEN
         Error_SYS.Record_General(lu_name_, 'DIFFLOTBATCHNO: Customer Order line :P1 does not allow lot batch no :P2.', order_line_info_, lot_batch_no_);
      END IF;   
      IF local_serial_no_ IS NOT NULL AND serial_no_ IS NOT NULL AND local_serial_no_ != serial_no_ THEN
         Error_SYS.Record_General(lu_name_, 'DIFFSERIALNO: Customer Order line :P1 does not allow serial no :P2.', order_line_info_, serial_no_);
      END IF;
      
      IF NVL(serial_no_, local_serial_no_) != '*' THEN
         ignore_this_avail_control_id_ := Inventory_Part_In_Stock_API.Get_Serial_Avail_Control_Id(part_no_, NVL(serial_no_, local_serial_no_));             
      END IF; 
      
   ELSIF (demand_code_ = 'PI') THEN      
      IF (line_rec_.supply_code IN ('PT', 'IPT')) THEN
        project_id_       := line_rec_.project_id;
        local_activity_seq_     := NVL(line_rec_.activity_seq, 0);
      END IF;     
   END IF;


   -- Fetch the shipment id's and qty to reserve only when it is not a supply site reservation/sourcing reservation and shipment id is not passed to the method.
   IF NOT (((reservation_type_ = 'SupplyChainReservation') AND (supply_site_ != demand_site_)) OR ((supply_site_ = demand_site_) AND (source_id_ IS NOT NULL))) THEN
      IF (shipment_id_ = 0) THEN
         shipment_quantity_tab_ := Shipment_Order_Utility_API.Get_Shipments_to_Reserve(order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   END IF;
   
   -- The assignments below work both in a situation where we already have shipment records due to the output from Shipment_Order_Utility_API.Get_Shipments_to_Reserve,
   -- but also in the other situations, where we have just value in parameter shipment_id_. In the case where Shipment_Order_Utility_API.Get_Shipments_to_Reserve has given
   -- a list of shipments, then shipment_id_ parameter is 0 which means that we will also consider reserving to non-shipment, remaining quantity which is
   -- the difference between total of shipment_qty_to_assign_ and qty_to_assign_. and in the other situations it is just one record inserted, where
   -- shipment_id_ might be > 0 or even 0 which means really not reserving to a shipment. But for convenience we also put shipment_id_ = 0 into this collection.
   counter_ := shipment_quantity_tab_.COUNT;
   shipment_quantity_tab_(counter_ + 1).shipment_id := shipment_id_;
   shipment_quantity_tab_(counter_ + 1).quantity    := qty_to_be_reserved_;
   qty_left_to_be_reserved_                         := qty_to_be_reserved_;

   FOR k IN 1..2 LOOP
      FOR i IN shipment_quantity_tab_.FIRST..shipment_quantity_tab_.LAST LOOP

         Inventory_Part_In_Stock_API.Find_And_Reserve_Part(keys_and_qty_tab_             => stock_keys_and_qty_tab_,
                                                           location_no_                  => location_no_,
                                                           lot_batch_no_                 => NVL(lot_batch_no_, local_lot_batch_no_),
                                                           serial_no_                    => NVL(serial_no_, local_serial_no_),
                                                           eng_chg_level_                => eng_chg_level_,
                                                           waiv_dev_rej_no_              => waiv_dev_rej_no_,
                                                           configuration_id_             => configuration_id_,
                                                           activity_seq_                 => local_activity_seq_,
                                                           handling_unit_id_             => handling_unit_id_,
                                                           contract_                     => contract_,
                                                           part_no_                      => part_no_,
                                                           location_type_db_             => Inventory_Location_Type_API.DB_PICKING,
                                                           qty_to_reserve_               => LEAST(shipment_quantity_tab_(i).quantity, qty_left_to_be_reserved_),
                                                           project_id_                   => project_id_,
                                                           condition_code_               => condition_code_,
                                                           part_ownership_db_            => reserve_ownership_,
                                                           owning_vendor_no_             => owning_vendor_no_,
                                                           owning_customer_no_           => line_rec_.owning_customer_no,
                                                           only_one_lot_allowed_         => FALSE,
                                                           many_records_allowed_         => TRUE,
                                                           expiration_control_date_      => expiration_control_date_,                                                          
                                                           ignore_this_avail_control_id_ => ignore_this_avail_control_id_,
                                                           reserve_from_transp_task_db_  => Site_Discom_Info_API.Get_Reserv_From_Transp_Task_Db(contract_));
         IF (stock_keys_and_qty_tab_.COUNT > 0) THEN
            FOR j IN stock_keys_and_qty_tab_.FIRST..stock_keys_and_qty_tab_.LAST LOOP

               Trace_SYS.Message('**************Automatic reservation********');
               Trace_SYS.Field('**************order_no', order_no_);
               Trace_SYS.Field('**************line_no', line_no_);
               Trace_SYS.Field('**************RELEASE_NO', rel_no_);
               Trace_SYS.Field('**************line_item_no', line_item_no_);
               Trace_SYS.Field('**************part_no', stock_keys_and_qty_tab_(j).part_no);
               Trace_SYS.Field('**************contract', stock_keys_and_qty_tab_(j).contract);
               Trace_SYS.Field('**************configuration_id', stock_keys_and_qty_tab_(j).configuration_id);
               Trace_SYS.Field('**************location_no', stock_keys_and_qty_tab_(j).location_no);
               Trace_SYS.Field('**************lot_batch_no', stock_keys_and_qty_tab_(j).lot_batch_no);
               Trace_SYS.Field('**************serial_no', stock_keys_and_qty_tab_(j).serial_no);
               Trace_SYS.Field('**************handling_unit_id', stock_keys_and_qty_tab_(j).handling_unit_id);
               Trace_SYS.Field('**************pick_list_no', pick_list_no_);
               Trace_SYS.Field('**************quantity', stock_keys_and_qty_tab_(j).quantity);
               
               sum_qty_assigned_        := sum_qty_assigned_        + stock_keys_and_qty_tab_(j).quantity;
               qty_left_to_be_reserved_ := qty_left_to_be_reserved_ - stock_keys_and_qty_tab_(j).quantity;
               shortage_qty_            := shortage_qty_            - stock_keys_and_qty_tab_(j).quantity;         
               picked_                  := TRUE;

               Report_Line_Reservation___(reservation_type_       => reservation_type_,
                                          supply_site_            => supply_site_,
                                          demand_site_            => demand_site_,
                                          source_id_              => source_id_,
                                          order_no_               => order_no_,
                                          line_no_                => line_no_,
                                          rel_no_                 => rel_no_,
                                          line_item_no_           => line_item_no_,
                                          stock_keys_and_qty_rec_ => stock_keys_and_qty_tab_(j),
                                          shipment_id_            => shipment_quantity_tab_(i).shipment_id,
                                          revised_qty_due_        => line_rec_.revised_qty_due,
                                          pick_list_no_           => pick_list_no_);

               IF (line_rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
                  $IF Component_Wo_SYS.INSTALLED $THEN
                     Active_Separate_API.Create_Rental_Wo(wo_no_        => wo_no_,
                                                          contract_     => stock_keys_and_qty_tab_(j).contract,
                                                          part_no_      => stock_keys_and_qty_tab_(j).part_no,
                                                          serial_no_    => stock_keys_and_qty_tab_(j).serial_no,
                                                          customer_no_  => line_rec_.customer_no,
                                                          req_finish_   => line_rec_.planned_due_date,
                                                          order_no_     => order_no_,
                                                          line_no_      => line_no_,
                                                          rel_no_       => rel_no_,
                                                          line_item_no_ => line_item_no_,
                                                          reserve_qty_  => stock_keys_and_qty_tab_(j).quantity,
                                                          create_wo_    => 'TRUE');
                  $ELSE
                     NULL;
                  $END
               END IF;
            END LOOP;
         END IF;
         EXIT WHEN (qty_left_to_be_reserved_ <= 0);     
      END LOOP;
      
      try_to_reserve_again_ := FALSE;
      IF (qty_left_to_be_reserved_ > 0) THEN
         IF (project_id_ IS NOT NULL AND activity_seq_ IS NULL) THEN  -- 
         -- If there is no sufficient qty in the location with the activity connected to order line,
         -- its try to unreserver from project if the CO line was created as demand of another
         -- PO connected with project and find sufficient quantity in the location with the activity connected to order line.
            Handle_Project_Reservations___(try_to_reserve_again_,
                                           local_activity_seq_,
                                           project_id_);
         END IF;
      END IF;
      EXIT WHEN NOT try_to_reserve_again_; 
   END LOOP;

   IF (sum_qty_assigned_ <> qty_to_be_reserved_) AND (is_ext_serv_ord_) THEN
      Error_SYS.Record_General( lu_name_, 'NORESERV: Unable to reserve part(s) for External Service Order' );
   END IF;

   qty_possible_to_assign_ := sum_qty_assigned_;

   Update_License_Coverage_Qty___(order_no_, line_no_, rel_no_, line_item_no_,sum_qty_assigned_);

   IF ((qty_left_to_be_reserved_ > 0) OR (shortage_qty_ > 0) OR NOT picked_ OR (sum_qty_assigned_ < qty_to_assign_ ) ) THEN
      order_line_info_ := order_no_ ||' '|| line_no_ ||' '|| rel_no_;

      IF NOT picked_ THEN
         -- No reservations made, generate a shortage record.
         Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, line_item_no_, 'PLANPICK05');
         
         reservation_info_ := Language_SYS.Translate_Constant(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                                              NULL, part_no_, order_line_info_);
         IF (Transaction_SYS.Is_Session_Deferred) THEN
            Transaction_SYS.Set_Status_Info(reservation_info_);
         ELSE
            Client_SYS.Add_info(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                part_no_, order_line_info_);            
         END IF;
         RETURN;
      ELSE
         IF (backorder_option_db_ IN ('NO PARTIAL DELIVERIES ALLOWED', 'INCOMPLETE LINES NOT ALLOWED')) THEN
            -- No backorders allowed, make sure the reservations made are removed
            @ApproveTransactionStatement(2014-08-15,darklk)
            ROLLBACK TO before_reserving;
            Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, line_item_no_, 'PLANPICK04');
            -- write an info message to bakground
            reservation_info_ := Language_SYS.Translate_Constant(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                                                 NULL, part_no_, order_line_info_);
            IF (Transaction_SYS.Is_Session_Deferred) THEN
               Transaction_SYS.Set_Status_Info(reservation_info_);
            ELSE
               Client_SYS.Add_Info(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                   part_no_, order_line_info_);
            END IF;
            sum_qty_assigned_ := 0;
            RETURN;
         ELSE
            -- Partial reservations are allowed. Just generate a shortage record.
            Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, line_item_no_, 'PLANPICK03');
            -- write an info message to bakground
            reservation_info_ := Language_SYS.Translate_Constant(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                                                 NULL, part_no_, order_line_info_);
            IF (Transaction_SYS.Is_Session_Deferred) THEN
               Transaction_SYS.Set_Status_Info(reservation_info_);
            ELSE
               Client_SYS.Add_Info(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                   part_no_, order_line_info_);                                               
            END IF;
            RETURN;
         END IF;
      END IF;
   END IF;
END Reserve_Line_At_Location___;


-- Reserve_Order___
--   Reserve the whole order
PROCEDURE Reserve_Order___ (
   order_no_               IN VARCHAR2,
   order_id_               IN VARCHAR2,
   planned_due_date_       IN DATE,
   part_no_                IN VARCHAR2,
   ship_via_code_          IN VARCHAR2,
   deliver_to_customer_no_ IN VARCHAR2,
   ship_addr_no_           IN VARCHAR2,
   route_id_               IN VARCHAR2,
   forward_agent_          IN VARCHAR2,
   sequence_no_            IN NUMBER,
   catalog_type_db_        IN VARCHAR2,
   batch_reserve_shipment_ IN VARCHAR2)
IS
   backorder_           BOOLEAN;
   error_message_       VARCHAR2(2000);
   info_                VARCHAR2(2000); 
   backorder_option_db_ VARCHAR2(40);  
   contract_            VARCHAR2(5);
   row_state_           customer_order_tab.rowstate%TYPE;
   exit_from_reserving_   BOOLEAN := FALSE;
   
   CURSOR get_order_detail IS
      SELECT backorder_option, rowstate, contract
      FROM customer_order_tab
      WHERE order_no = order_no_;
BEGIN
   @ApproveTransactionStatement(2014-08-15,darklk)
   SAVEPOINT before_pick_plan;

   Lock___(order_no_);

   IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') THEN
      -- Do a credit check before reservations are made
      -- In this row_state can become Blocked.
      Customer_Order_Flow_API.Credit_Check_Order(order_no_, 'PICK_PROPOSAL');
   END IF;

   OPEN get_order_detail;
   FETCH get_order_detail INTO backorder_option_db_, row_state_, contract_; 
   CLOSE get_order_detail;
   
   IF (row_state_ != 'Blocked') THEN
      -- Allow the fair share reservation only for the options 'Allow Partial Deliveries of Lines, Complete Packages'
      -- and 'Allow Partial Deliveries of Lines and Incomplete Packages'
      IF (backorder_option_db_ IN ('ALLOW INCOMPLETE LINES AND PACKAGES', 'INCOMPLETE PACKAGES NOT ALLOWED') AND (sequence_no_ IS NOT NULL)) THEN
         -- Enter record in the Fair_Share_Reservation_Tab
         Fair_Share_Reservation_API.New(sequence_no_, order_no_, planned_due_date_);
      ELSE
         Reserve_Lines___(exit_from_reserving_, order_no_, planned_due_date_, part_no_, ship_via_code_, deliver_to_customer_no_, ship_addr_no_, route_id_, forward_agent_, catalog_type_db_, batch_reserve_shipment_);
         
         IF (exit_from_reserving_) THEN
            IF (backorder_option_db_ = 'NO PARTIAL DELIVERIES ALLOWED') THEN   
               -- If whole order shall be picked, perform check so all lines are availbale.
               -- If backorder would be generated shortage records will be created.
               backorder_ := Backorder_Generated___(order_no_);

               IF (backorder_) THEN
                  -- Set the warning status on the background job.
                  info_ := Language_SYS.Translate_Constant(lu_name_, 'RESERVMISSING: Reservations have not been made for the order :P1. Check the Customer Order Shortages for more info.', NULL, order_no_);
                  Transaction_SYS.Set_Status_Info(info_);
                  Cust_Order_Event_Creation_API.Order_Processing_Error(order_no_, info_);
               END IF;
            END IF;
            RETURN;
         END IF;   

         IF (Cust_Order_Type_Event_API.Get_Next_Event(order_id_, '60') IS NOT NULL) THEN
            Customer_Order_Flow_API.Proceed_After_Pick_Planning__(order_no_);
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN others THEN
      @ApproveTransactionStatement(2014-08-15,darklk)
      ROLLBACK TO before_pick_plan;

      Trace_SYS.Message('*** EXCEPTION WHEN others i Reserve_Order___');
      Trace_SYS.Message('SQLCODE = ' || sqlcode || ' Message = ' || sqlerrm);
      error_message_ := sqlerrm;

      -- Logg the error
      info_ := Language_SYS.Translate_Constant(lu_name_, 'ORDERERR: Order: :P1 - :P2.', NULL, order_no_, error_message_);
      Transaction_SYS.Set_Status_Info(info_);
      Cust_Order_Event_Creation_API.Order_Processing_Error(order_no_, error_message_);
END Reserve_Order___;


-- Reserve_Lines___
--   Reserve all lines for an order.
PROCEDURE Reserve_Lines___ (
   exit_from_reserving_    OUT BOOLEAN,
   order_no_               IN VARCHAR2,
   planned_due_date_       IN DATE,   
   part_no_                IN VARCHAR2,
   ship_via_code_          IN VARCHAR2,
   deliver_to_customer_no_ IN VARCHAR2,
   ship_addr_no_           IN VARCHAR2,
   route_id_               IN VARCHAR2,
   forward_agent_          IN VARCHAR2,
   catalog_type_db_        IN VARCHAR2,
   batch_reserve_shipment_ IN VARCHAR2)
IS
   CURSOR get_lines IS
      SELECT  line_no, rel_no, line_item_no, contract, part_no, supply_code, catalog_type,
              (revised_qty_due - qty_assigned - qty_shipped - qty_to_ship - qty_on_order) qty_rest, revised_qty_due, qty_assigned
        FROM  customer_order_line_tab
       WHERE  order_no = order_no_
         AND  line_item_no <= 0
         AND  trunc(planned_due_date) <= trunc(planned_due_date_)
         AND  rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
         AND  ((revised_qty_due - qty_assigned - qty_shipped- qty_on_order > 0 AND              
              supply_code IN ('IO', 'PKG', 'PS', 'PI', 'PT', 'IPT', 'SO', 'DOP', 'PJD'))
          OR  (revised_qty_due - qty_to_ship - qty_shipped > 0 AND
              supply_code IN ('NO', 'SEO', 'PRJ')))
         AND ((part_no                LIKE part_no_)                OR (DECODE(part_no_,                '%',  NULL, part_no_) IS NULL)
          OR (part_no IS NULL AND Decode(part_no_, '%', NULL, part_no_) IS NULL))
         AND ((ship_via_code          LIKE ship_via_code_)          OR (DECODE(ship_via_code_,          '%',  NULL, ship_via_code_) IS NULL))
         AND ((deliver_to_customer_no LIKE deliver_to_customer_no_) OR (DECODE(deliver_to_customer_no_, '%',  NULL, deliver_to_customer_no_) IS NULL))
         AND ((ship_addr_no           LIKE ship_addr_no_)           OR (DECODE(ship_addr_no_,           '%',  NULL, ship_addr_no_) IS NULL))
         AND ((route_id               LIKE route_id_)               OR (DECODE(route_id_,               '%',  NULL, route_id_) IS NULL)
          OR (route_id IS NULL        AND  Decode(route_id_,'%', NULL, route_id_) IS NULL))
         AND ((forward_agent_id       LIKE forward_agent_)          OR (DECODE(forward_agent_,          '%',  NULL, forward_agent_) IS NULL)
          OR (forward_agent_id IS NULL AND Decode(forward_agent_, '%', NULL, forward_agent_) IS NULL))
         AND ((catalog_type           LIKE catalog_type_db_)        OR (DECODE(catalog_type_db_,        '%',  NULL, catalog_type_db_) IS NULL))
      ORDER BY part_no, planned_due_date, date_entered;
    
   TYPE Lines_Tab IS TABLE OF get_lines%ROWTYPE
   INDEX BY PLS_INTEGER;
   line_rec_               Lines_Tab;
   
   -- This cursor is written to find all possible CO Lines which can be reserved.
   CURSOR get_lines_to_reserve IS
      SELECT COUNT(order_no)
      FROM  customer_order_line_tab
      WHERE order_no = order_no_
      AND   line_item_no <= 0
      AND   rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND   ((revised_qty_due - qty_assigned - qty_shipped > 0 AND              
              supply_code IN ('IO', 'PKG', 'PS', 'PI', 'PT', 'IPT', 'SO', 'PJD'))
          OR  (revised_qty_due - qty_to_ship - qty_shipped > 0 AND
              supply_code IN ('NO', 'SEO', 'PRJ')));
      
   
   no_of_lines_to_reserve_ NUMBER;
   tot_line_qty_reserved_  NUMBER;
   backorder_option_db_    VARCHAR2(40);
BEGIN
   OPEN get_lines;
   FETCH get_lines BULK COLLECT INTO line_rec_;
   CLOSE get_lines;
   
   backorder_option_db_ := Customer_Order_API.Get_Backorder_Option_Db(order_no_);
   @ApproveTransactionStatement(2017-06-20, meablk)
   SAVEPOINT before_line_reserving;
   exit_from_reserving_ := FALSE;

   IF (backorder_option_db_ = 'NO PARTIAL DELIVERIES ALLOWED') THEN
      OPEN  get_lines_to_reserve;
      FETCH get_lines_to_reserve INTO no_of_lines_to_reserve_;
      CLOSE get_lines_to_reserve;
      
      IF  (line_rec_.count != no_of_lines_to_reserve_) THEN
         @ApproveTransactionStatement(2017-06-20, meablk)
         ROLLBACK TO  before_line_reserving;
         exit_from_reserving_ := TRUE;
         RETURN;         
      END IF;   
   END IF;

   IF (line_rec_.count > 0) THEN
      FOR i IN line_rec_.FIRST .. line_rec_.LAST LOOP
         IF (line_rec_(i).supply_code = 'PKG') THEN
            Reserve_Package__(order_no_, line_rec_(i).line_no, line_rec_(i).rel_no, 0);
         -- Modified the condition to include SEO as a possible supply code for non inventory parts
         ELSIF ((line_rec_(i).supply_code IN ('NO', 'SEO', 'PRJ')) OR (line_rec_(i).supply_code IN ('PT', 'IPT') AND line_rec_(i).catalog_type = 'NON')) THEN
            Reserve_Non_Inventory___(order_no_, line_rec_(i).line_no, line_rec_(i).rel_no,
                                     line_rec_(i).line_item_no, line_rec_(i).qty_rest, 0);
         ELSE
            Reserve_Inventory___(tot_line_qty_reserved_, order_no_, line_rec_(i).line_no, line_rec_(i).rel_no, line_rec_(i).line_item_no,
                                 line_rec_(i).qty_rest, 0);
            
            IF (backorder_option_db_ = 'NO PARTIAL DELIVERIES ALLOWED') THEN
               -- This will check whether the full quantity has been reserved. If not the process will roleback.
               IF ((tot_line_qty_reserved_ + line_rec_(i).qty_assigned) != line_rec_(i).revised_qty_due) THEN
                  @ApproveTransactionStatement(2017-06-20, meablk)
                  ROLLBACK TO  before_line_reserving;
                  exit_from_reserving_ := TRUE;
                  RETURN;
               END IF;   
            END IF;
         END IF;
      END LOOP;
   END IF;
   
   -- Trigger shipment process for order line connected shipments.
   IF (NVL(batch_reserve_shipment_, 'FALSE') != 'TRUE') THEN
      Shipment_Order_Utility_API.Start_Shipment_Flow(order_no_, 10, 'FALSE');
   END IF;
   
END Reserve_Lines___;


-- Backorder_Generated___
--   Check if a backorder would be generated for the specified order.
--   If a shortage exists for one or more lines new records will be created in
--   CustomerOrderShortage for all order lines.
--   Return TRUE or FALSE depending on if a backorder would be generated or not.
FUNCTION Backorder_Generated___ (
   order_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   result_                  VARCHAR2(20);
   test_date_               DATE := trunc(Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(order_no_)));
   dummy_date_              DATE;
   qty_possible_            NUMBER;
   qty_to_reserve_          NUMBER;
   backorder_               BOOLEAN := FALSE;
   owning_vendor_no_        customer_order_line_tab.vendor_no%TYPE;
   part_ownership2_         VARCHAR2(200) := NULL;
   inv_part_rec_            Inventory_Part_API.Public_Rec;
   rest_to_reserve_         NUMBER;
   qty_inv_stock_           NUMBER;
   min_pkg_picked_          NUMBER := 0;
   backorder_option_db_     VARCHAR2(40);
   expiration_control_date_ DATE;
   min_durab_days_co_deliv_ NUMBER;
   include_standard_        VARCHAR2(5);
   include_project_         VARCHAR2(5);

   CURSOR get_lines IS
      SELECT line_no, rel_no,line_item_no, contract, part_no, configuration_id, supply_code,
             (revised_qty_due - qty_assigned - qty_shipped) qty_rest, part_ownership,
             owning_customer_no, condition_code, picking_leadtime, planned_delivery_date, ROWID objid
      FROM customer_order_line_tab
      WHERE order_no = order_no_
      AND   line_item_no <= 0
      AND   (revised_qty_due - qty_assigned - qty_shipped) > 0
      AND   rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND   supply_code IN ('IO', 'SO', 'PT', 'IPT','PS','PKG','PI','PJD')
      ORDER BY planned_due_date, date_entered;

   CURSOR get_qty (part_no_            IN VARCHAR2,
                   configuration_id_   IN VARCHAR2,
                   part_ownership_     IN VARCHAR2,
                   owning_customer_no_ IN VARCHAR2,
                   condition_code_     IN VARCHAR2) IS
      SELECT SUM(revised_qty_due - qty_assigned - qty_shipped) 
      FROM customer_order_line_tab
      WHERE order_no         =  order_no_
      AND   part_no          =  part_no_
      AND   configuration_id =  configuration_id_
      AND   part_ownership   =  part_ownership_
      AND   ((part_ownership  != 'CUSTOMER OWNED') OR
             (owning_customer_no = owning_customer_no_))
      AND   ((condition_code  =  condition_code_) OR 
             (condition_code IS NULL AND condition_code_ IS NULL))
      AND   line_item_no     >= 0
      AND   rowstate         IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered');

   TYPE Lines_Tab IS TABLE OF get_lines%ROWTYPE
   INDEX BY PLS_INTEGER;
   line_rec_                Lines_Tab;
BEGIN
   @ApproveTransactionStatement(2014-08-15,darklk)
   SAVEPOINT check_backorder;

   OPEN get_lines;
   FETCH get_lines BULK COLLECT INTO line_rec_;
   CLOSE get_lines;

   -- Retrieve all lines which would generate a backorder
   IF (line_rec_.count > 0) THEN
      FOR i IN line_rec_.FIRST .. line_rec_.LAST LOOP
         IF (line_rec_(i).line_item_no = 0 ) THEN
            IF line_rec_(i).supply_code IN ('IO','PI','PJD') THEN
               -- Inventory Order
               inv_part_rec_ := Inventory_Part_API.Get(line_rec_(i).contract, line_rec_(i).part_no);

               IF ((inv_part_rec_.onhand_analysis_flag = 'Y') AND (inv_part_rec_.co_reserve_onh_analys_flag = 'Y')) THEN
                  IF line_rec_(i).part_ownership = 'SUPPLIER LOANED' THEN
                     owning_vendor_no_ := Customer_Order_Line_API.Get_Owner_For_Part_Ownership(order_no_,
                                                                                               line_rec_(i).line_no,
                                                                                               line_rec_(i).rel_no,
                                                                                               line_rec_(i).line_item_no,
                                                                                               line_rec_(i).part_ownership);
                  END IF;

                  Inventory_Part_In_Stock_API.Make_Onhand_Analysis(result_                => result_, 
                                                                   qty_possible_          => qty_possible_, 
                                                                   next_analysis_date_    => dummy_date_,
                                                                   planned_delivery_date_ => test_date_, 
                                                                   planned_due_date_      => test_date_, 
                                                                   contract_              => line_rec_(i).contract,
                                                                   part_no_               => line_rec_(i).part_no, 
                                                                   configuration_id_      => line_rec_(i).configuration_id,
                                                                   include_standard_      => 'TRUE', 
                                                                   include_project_       => 'FALSE', 
                                                                   project_id_            => NULL, 
                                                                   activity_seq_          => NULL, 
                                                                   row_id_                => line_rec_(i).objid,
                                                                   qty_desired_           => line_rec_(i).qty_rest, 
                                                                   picking_leadtime_      => line_rec_(i).picking_leadtime, 
                                                                   part_ownership_        => line_rec_(i).part_ownership,
                                                                   owning_vendor_no_      => owning_vendor_no_, 
                                                                   owning_customer_no_    => line_rec_(i).owning_customer_no);

                  IF (result_ != 'SUCCESS') THEN
                     Customer_Order_Shortage_API.New(order_no_, line_rec_(i).line_no, line_rec_(i).rel_no, line_rec_(i).line_item_no, 'PLANPICK01');
                     backorder_ := TRUE;
                  ELSE
                     -- Create a shortage record event if analysis was a success. Will be removed if all lines are OK.
                     Customer_Order_Shortage_API.New(order_no_, line_rec_(i).line_no, line_rec_(i).rel_no, line_rec_(i).line_item_no, 'PLANPICK02');
                  END IF;
               ELSE
                  OPEN get_qty(line_rec_(i).part_no,
                               line_rec_(i).configuration_id,
                               line_rec_(i).part_ownership,
                               line_rec_(i).owning_customer_no,
                               line_rec_(i).condition_code);
                  FETCH get_qty INTO rest_to_reserve_;
                  IF get_qty%NOTFOUND THEN
                     rest_to_reserve_ := 0;
                  END IF;
                  CLOSE get_qty;

                  min_durab_days_co_deliv_ := inv_part_rec_.min_durab_days_co_deliv;
                  expiration_control_date_ := Get_Expiration_Control_Date___(line_rec_(i).planned_delivery_date, test_date_, min_durab_days_co_deliv_, order_no_, line_rec_(i).line_no, line_rec_(i).rel_no, line_rec_(i).line_item_no, line_rec_(i).contract,line_rec_(i).part_no);
                  -------------------------------------------------------------------------------------

                  IF (line_rec_(i).part_ownership = 'COMPANY OWNED') THEN
                     part_ownership2_ := 'CONSIGNMENT';
                  ELSE
                     part_ownership2_ := NULL;
                  END IF;
                  
                  IF line_rec_(i).supply_code IN ('PI','PJD') THEN
                     include_standard_ := 'FALSE';
                     include_project_  := 'TRUE';
                  ELSE
                     include_standard_ := 'TRUE';
                     include_project_  := 'FALSE';   
                  END IF;
                                    
                  qty_inv_stock_  := Inventory_Part_In_Stock_API.Get_Inventory_Quantity(contract_                => line_rec_(i).contract,
                                                                                        part_no_                 => line_rec_(i).part_no,
                                                                                        configuration_id_        => line_rec_(i).configuration_id,
                                                                                        qty_type_                => 'AVAILABLE',
                                                                                        ownership_type1_db_      => line_rec_(i).part_ownership,
                                                                                        ownership_type2_db_      => part_ownership2_,
                                                                                        owning_customer_no_      => line_rec_(i).owning_customer_no,
                                                                                        owning_vendor_no_        => owning_vendor_no_,
                                                                                        location_type1_db_       => 'PICKING',
                                                                                        location_type2_db_       => 'SHIPMENT',
                                                                                        include_standard_        => include_standard_,
                                                                                        include_project_         => include_project_,
                                                                                        automat_reserv_ctrl_db_  => 'AUTO RESERVATION',
                                                                                        condition_code_          => line_rec_(i).condition_code,
                                                                                        unit_of_measure_type_    => 'INVENTORY',
                                                                                        expiration_control_date_ => expiration_control_date_);

                  qty_to_reserve_ := qty_inv_stock_ - rest_to_reserve_;

                  --------------------------------------------------------------------------------------
                  IF (qty_to_reserve_ < 0) THEN
                     IF qty_inv_stock_ = 0 THEN
                        Customer_Order_Shortage_API.New(order_no_, line_rec_(i).line_no, line_rec_(i).rel_no, line_rec_(i).line_item_no, 'PLANPICK05');
                     ELSE
                        Customer_Order_Shortage_API.New(order_no_, line_rec_(i).line_no, line_rec_(i).rel_no, line_rec_(i).line_item_no, 'PLANPICK01');
                     END IF;
                     backorder_ := TRUE;
                  ELSE
                  -- Create a shortage record event if parts are available. Will be removed if all lines are OK.
                     Customer_Order_Shortage_API.New(order_no_, line_rec_(i).line_no, line_rec_(i).rel_no, line_rec_(i).line_item_no, 'PLANPICK02');
                  END IF;
               END IF;
            ELSE
               -- supply_code is Shop Order or Purch Order Transit
               IF (line_rec_(i).qty_rest > 0) THEN
                  Customer_Order_Shortage_API.New(order_no_, line_rec_(i).line_no, line_rec_(i).rel_no, line_rec_(i).line_item_no, 'PLANPICK01');
                  backorder_ := TRUE;
               ELSE
                  -- Create a shortage record event if parts are available. Will be removed if all lines are OK.
                  Customer_Order_Shortage_API.New(order_no_, line_rec_(i).line_no, line_rec_(i).rel_no, line_rec_(i).line_item_no, 'PLANPICK02');
               END IF;
            END IF;
         ELSE
            backorder_option_db_ := Customer_Order_API.Get_Backorder_Option_Db(order_no_);
            Check_Package___(min_pkg_picked_, order_no_, line_rec_(i).line_no, line_rec_(i).rel_no, backorder_option_db_);
            IF (min_pkg_picked_< line_rec_(i).qty_rest) THEN
               backorder_ := TRUE;
            END IF;
         END IF;
      END LOOP;
   END IF;

   IF (NOT backorder_) THEN
      -- No backorder will be generated, remove all shortage records created
      @ApproveTransactionStatement(2014-08-15,darklk)
      ROLLBACK TO check_backorder;
   END IF;
   RETURN (backorder_);
END Backorder_Generated___;


-- Reserve_Inventory___
--   Reserves inventory part
PROCEDURE Reserve_Inventory___ (
    reserved_qty_ OUT NUMBER,
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   qty_to_assign_ IN NUMBER,
   shipment_id_   IN NUMBER )
IS
   qty_reserved_ NUMBER;
BEGIN
   -- Send a NULL value for the qty_to_be_reserved_.
   -- This parameter is only used by the shortage_demand LU.
   Reserve_Order_Line__(qty_reserved_, order_no_, line_no_, rel_no_,
                        line_item_no_, qty_to_assign_, shipment_id_);
                        
   reserved_qty_ :=  qty_reserved_;                     
END Reserve_Inventory___;


-- Reserve_Non_Inventory___
--   Make non inventory line deliverable by assigning qty_to_ship a value.
PROCEDURE Reserve_Non_Inventory___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_to_ship_  IN NUMBER,
   shipment_id_  IN NUMBER )
IS
   old_qty_to_ship_      customer_order_line_tab.qty_to_ship%TYPE;
   ship_old_qty_to_ship_ NUMBER;
   pkg_qty_reserved_     NUMBER;
BEGIN
   old_qty_to_ship_ := Customer_Order_Line_API.Get_Qty_To_Ship(order_no_, line_no_, rel_no_, line_item_no_);
   Customer_Order_Line_API.Modify_Qty_To_Ship__(order_no_, line_no_, rel_no_, line_item_no_,
                                                old_qty_to_ship_ + qty_to_ship_);

   IF (line_item_no_ > 0) THEN
      pkg_qty_reserved_ := Reserve_Customer_Order_API.Get_No_Of_Packages_Reserved(order_no_,
                                                                                  line_no_,
                                                                                  rel_no_);
      Customer_Order_Line_API.Set_Qty_Assigned(order_no_, line_no_, rel_no_, -1, pkg_qty_reserved_);
   END IF;
   
   IF (shipment_id_ != 0) THEN
      ship_old_qty_to_ship_ := Shipment_Line_API.Get_Qty_To_Ship_By_Source(shipment_id_, order_no_, line_no_,
                                                                           rel_no_, line_item_no_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
      Shipment_Line_API.Modify_Qty_To_Ship(shipment_id_, order_no_, line_no_, rel_no_, line_item_no_,
                                           Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, ship_old_qty_to_ship_ + qty_to_ship_); 
   ELSE
      Shipment_Handling_Utility_API.Modify_Qty_To_Ship_Source_Line(order_no_, line_no_, rel_no_,
                                                                   line_item_no_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);         
   END IF;      
END Reserve_Non_Inventory___;


-- Reserve_Complete_Package___
--   Reserves an entire package
PROCEDURE Reserve_Complete_Package___ (
   order_no_    IN VARCHAR2,
   line_no_     IN VARCHAR2,
   rel_no_      IN VARCHAR2,
   shipment_id_ IN NUMBER )
IS
   pkg_to_pick_           NUMBER := 0;   
   qty_short_             NUMBER := 0;
   pkg_revised_qty_due_   NUMBER;
   qty_reserved_          NUMBER;
   line_qty_to_pick_once_ NUMBER := 0;
   rolled_back_           BOOLEAN := FALSE;
   backorder_option_db_   VARCHAR2(40);
   linerec_               Customer_Order_Line_API.Public_Rec;
   reservation_info_      VARCHAR2(1000) := NULL;
   order_line_info_       VARCHAR2(100) := NULL;
   
   CURSOR package_curs IS
      SELECT line_item_no, supply_code, revised_qty_due, contract, part_no,
             DECODE(supply_code, 'IO', qty_assigned, 'NO', qty_to_ship, qty_assigned) qty_assigned, qty_shipped, qty_on_order
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    line_item_no > 0
      AND    rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND  (((revised_qty_due - qty_assigned - qty_shipped - qty_on_order) > 0 AND
             supply_code IN ('IO','PS','PT','IPT', 'SO', 'PI'))
      OR    ((revised_qty_due - qty_to_ship - qty_shipped) > 0 AND
             supply_code IN ('NO', 'PRJ')))
      ORDER BY line_item_no;

   TYPE Pkg_Comps_Tab IS TABLE OF package_curs%ROWTYPE
   INDEX BY PLS_INTEGER;
   package_part_  Pkg_Comps_Tab;
   
BEGIN
   order_line_info_     := order_no_ ||' '|| line_no_ ||' '|| rel_no_;
   linerec_             := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, -1);
   backorder_option_db_ := Customer_Order_API.Get_Backorder_Option_Db(order_no_);
   @ApproveTransactionStatement(2014-08-15,darklk)
   SAVEPOINT reserve_complete_pkg;

   IF (shipment_id_ = 0) THEN
      -- Complete picking of partially picked packages
      Complete_Package___(order_no_, line_no_, rel_no_);

      -- Now we only should have whole packages left to be picked, no loose components.
      -- Retrieve the number of whole packages possible to pick.
      Check_Package___(pkg_to_pick_, order_no_, line_no_, rel_no_, backorder_option_db_);

      Trace_SYS.Field('pkg_to_pick', pkg_to_pick_);

      IF (pkg_to_pick_ > 0) THEN
         pkg_revised_qty_due_ := Customer_Order_Line_API.Get_Revised_Qty_Due(order_no_, line_no_, rel_no_, -1);
         FOR pkg_counter_ IN 1..pkg_to_pick_ LOOP
            
            @ApproveTransactionStatement(2014-08-15,darklk)
            SAVEPOINT before_reserve;
            rolled_back_ := FALSE;

            OPEN package_curs;
            FETCH package_curs BULK COLLECT INTO package_part_;
            CLOSE package_curs;

            IF (package_part_.count > 0) THEN
               FOR i IN package_part_.FIRST .. package_part_.LAST LOOP
                  line_qty_to_pick_once_ := package_part_(i).revised_qty_due / pkg_revised_qty_due_;
                  IF (line_qty_to_pick_once_  > 0 ) THEN
                     IF (package_part_(i).supply_code = 'NO') THEN
                        Reserve_Non_Inventory___(order_no_, line_no_, rel_no_, package_part_(i).line_item_no, line_qty_to_pick_once_, 0);
                     ELSE
                        IF (pkg_counter_ != pkg_to_pick_) THEN
                           -- Last parameter is set to FALSE becuase we do NOT want to set shortages at this point
                           Reserve_Order_Line__(qty_reserved_ , order_no_, line_no_, rel_no_, package_part_(i).line_item_no,
                                                line_qty_to_pick_once_, shipment_id_, FALSE);
                        ELSE
                           Reserve_Order_Line__(qty_reserved_ , order_no_, line_no_, rel_no_, package_part_(i).line_item_no,
                                                line_qty_to_pick_once_, shipment_id_);
                        END IF;

                        IF (qty_reserved_ != line_qty_to_pick_once_) THEN
                           rolled_back_ := TRUE;
                           @ApproveTransactionStatement(2014-08-15,darklk)
                           ROLLBACK TO before_reserve;
                           EXIT;
                        END IF;
                     END IF;
                  END IF;
               END LOOP;
            END IF;
            EXIT WHEN rolled_back_;
         END LOOP;
      END IF;
   ELSE
      Reserve_Shipment_Pkg_Comp___(order_no_, line_no_, rel_no_, shipment_id_); 
   END IF;

   IF (rolled_back_) THEN
      OPEN package_curs;
      FETCH package_curs BULK COLLECT INTO package_part_;
      CLOSE package_curs;

      IF (package_part_.count > 0) THEN
         FOR i IN package_part_.FIRST .. package_part_.LAST LOOP
            IF package_part_(i).part_no IS NOT NULL THEN
               qty_short_ := Shortage_Demand_API.Calculate_Order_Shortage_Qty(package_part_(i).contract,
                                                                              package_part_(i).part_no,
                                                                              package_part_(i).revised_qty_due,
                                                                              package_part_(i).qty_assigned,
                                                                              (package_part_(i).qty_shipped + package_part_(i).qty_on_order));
            ELSE
               qty_short_ := 0;
            END IF;
            Customer_Order_Line_API.Set_Qty_Short(order_no_, line_no_, rel_no_, package_part_(i).line_item_no, qty_short_);
         END LOOP;
      END IF;
   END IF;

   IF (backorder_option_db_ IN ('NO PARTIAL DELIVERIES ALLOWED', 'INCOMPLETE LINES NOT ALLOWED')) THEN
      IF (Package_Partially_Reserved(order_no_, line_no_, rel_no_) = 'TRUE') THEN
         -- Package line is not possible to fully reserved .
         @ApproveTransactionStatement(2014-08-15,darklk)
         ROLLBACK TO reserve_complete_pkg;

         Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, -1, 'PLANPICK06');
         -- write an info message to background
         reservation_info_ := Language_SYS.Translate_Constant(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                                              NULL, linerec_.catalog_no, order_line_info_);
         IF (Transaction_SYS.Is_Session_Deferred) THEN
            Transaction_SYS.Set_Status_Info(reservation_info_);
         ELSE
            Client_SYS.Add_Info(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                linerec_.catalog_no, order_line_info_);
         END IF;
      END IF;
   END IF;
END Reserve_Complete_Package___;


-- Complete_Package___
--   Completes picking of partially picked packages.
PROCEDURE Complete_Package___ (
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2,
   rel_no_   IN VARCHAR2 )
IS
   pkg_qty_picked_          NUMBER;
   pkg_qty_to_pick_         NUMBER;
   pkg_qty_to_finish_       NUMBER;
   line_qty_per_pkg_        NUMBER;
   line_qty_picked_         NUMBER;
   line_qty_to_pick_        NUMBER;
   line_qty_to_finish_      NUMBER;
   reservation_info_        VARCHAR2(1000)  := NULL;
   order_line_info_         VARCHAR2(100)   := NULL;
   linerec_                 Customer_Order_Line_API.Public_Rec;
   backorder_option_db_     VARCHAR2(40);
   allow_partial_pkg_deliv_ VARCHAR2(5);

   CURSOR complete_package_curs IS
      SELECT line_item_no, supply_code
      FROM   customer_order_line_tab
      WHERE  rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND   (((revised_qty_due - qty_assigned - qty_shipped) > 0 AND
             supply_code IN ('IO', 'PS', 'PT', 'IPT', 'SO', 'PI'))
         OR  ((revised_qty_due - qty_to_ship - qty_shipped) > 0 AND
             supply_code IN ('NO', 'PRJ')))
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      ORDER BY line_item_no;

   TYPE Pkg_Comps_Tab IS TABLE OF complete_package_curs%ROWTYPE
   INDEX BY PLS_INTEGER;
   lines_                Pkg_Comps_Tab;
   
   qty_reserved_  NUMBER;
BEGIN
   order_line_info_         := order_no_ ||' '|| line_no_ ||' '|| rel_no_;
   linerec_                 := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, -1);
   backorder_option_db_     := Customer_Order_API.Get_Backorder_Option_Db(order_no_);
   allow_partial_pkg_deliv_ := Sales_Part_API.Get_Allow_Partial_Pkg_Deliv_Db(
                                                                     linerec_.contract,
                                                                     linerec_.catalog_no);
   -- Retrieve the number
   Check_Reserve_Package___(pkg_qty_picked_, pkg_qty_to_pick_, pkg_qty_to_finish_, order_no_, line_no_, rel_no_);
   @ApproveTransactionStatement(2014-08-15,darklk)
   SAVEPOINT complete_package;

   OPEN complete_package_curs;
   FETCH complete_package_curs BULK COLLECT INTO lines_;
   CLOSE complete_package_curs;

   IF (lines_.count > 0) THEN
      FOR i IN lines_.FIRST .. lines_.LAST LOOP
         Check_Reserve_Package_Comp___(line_qty_per_pkg_, line_qty_picked_, line_qty_to_pick_,
                                       line_qty_to_finish_, order_no_, line_no_,
                                       rel_no_, lines_(i).line_item_no, pkg_qty_picked_, pkg_qty_to_finish_);
         Trace_SYS.Field('line_qty_to_finish', line_qty_to_finish_);
         IF (line_qty_to_finish_ > 0) THEN
            IF (lines_(i).supply_code = 'NO') THEN
               Reserve_Non_Inventory___(order_no_, line_no_, rel_no_, lines_(i).line_item_no,
                                        line_qty_to_finish_, 0);
            ELSE
               Reserve_Inventory___(qty_reserved_, order_no_, line_no_, rel_no_, lines_(i).line_item_no,
                                    line_qty_to_finish_, 0);
            END IF;
         END IF;
      END LOOP;
   END IF;

   Check_Reserve_Package___(pkg_qty_picked_, pkg_qty_to_pick_, pkg_qty_to_finish_, order_no_, line_no_, rel_no_);

   IF (backorder_option_db_ = 'INCOMPLETE PACKAGES NOT ALLOWED' OR
       (backorder_option_db_ = 'ALLOW INCOMPLETE LINES AND PACKAGES' AND allow_partial_pkg_deliv_ = 'FALSE')) THEN
      IF (pkg_qty_to_finish_ > 0) THEN
         -- It was not possible to complete picking of partially picked packages.
         @ApproveTransactionStatement(2014-08-15,darklk)
         ROLLBACK TO complete_package;

         Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, -1, 'PLANPICK08');
         -- write an info message to background
         reservation_info_ := Language_SYS.Translate_Constant(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                                              NULL, linerec_.catalog_no, order_line_info_);
         IF (Transaction_SYS.Is_Session_Deferred) THEN
            Transaction_SYS.Set_Status_Info(reservation_info_);
         ELSE
            Client_SYS.Add_Info(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                linerec_.catalog_no, order_line_info_);
         END IF;
      END IF;
   END IF;
END Complete_Package___;


-- Check_Package___
--   Calculate the number of whole packages possible to pick.
--   Generate records in CustomerOrderShortage when needed.
PROCEDURE Check_Package___ (
   min_pkg_picked_      IN OUT NUMBER,
   order_no_            IN     VARCHAR2,
   line_no_             IN     VARCHAR2,
   rel_no_              IN     VARCHAR2,
   backorder_option_db_ IN     VARCHAR2 )
IS
   pkg_revised_qty_due_      NUMBER;
   pkg_qty_picked_           NUMBER := 0;
   pkg_qty_to_pick_          NUMBER := 0;
   pkg_qty_to_finish_        NUMBER := 0;
   line_qty_per_pkg_         NUMBER := 0;
   line_qty_picked_          NUMBER := 0;
   line_qty_to_pick_         NUMBER := 0;
   line_qty_to_finish_       NUMBER := 0;
   line_qty_possible_        NUMBER := 0;
   dummy_date_               DATE;
   test_date_                DATE := trunc(Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(order_no_)));
   rcode_                    VARCHAR2(80);
   owning_vendor_no_         customer_order_line_tab.vendor_no%TYPE;
   onhand_line_qty_possible_ NUMBER := 0;
   inv_part_rec_             Inventory_part_API.Public_Rec;
   reservation_info_         VARCHAR2(1000)  := NULL;
   order_line_info_          VARCHAR2(100)   := NULL;
   linerec_                  Customer_Order_Line_API.Public_Rec;
   allow_partial_pkg_deliv_  VARCHAR2(5);
   qty_short_                NUMBER;

   CURSOR non_inventory_to_deliver IS
      SELECT floor(((revised_qty_due - qty_to_ship - qty_shipped)/revised_qty_due) * pkg_revised_qty_due_)
      FROM   customer_order_line_tab
      WHERE  supply_code IN ('NO', 'PRJ')
      AND    rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0;

   CURSOR get_inventory_line IS
      SELECT line_item_no, contract, part_no, configuration_id, part_ownership, owning_customer_no, ROWID objid,
             qty_on_order, revised_qty_due, qty_assigned, qty_shipped, picking_leadtime
      FROM   customer_order_line_tab
      WHERE  (revised_qty_due - qty_assigned - qty_shipped) > 0
      AND    supply_code IN ('IO', 'SO', 'PT', 'IPT','PS', 'PI')
      AND    rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      ORDER BY line_item_no;

   TYPE Pkg_Comps_Tab IS TABLE OF get_inventory_line%ROWTYPE
   INDEX BY PLS_INTEGER;
   lines_                Pkg_Comps_Tab;
BEGIN
   Check_Reserve_Package___(pkg_qty_picked_, pkg_qty_to_pick_, pkg_qty_to_finish_, order_no_, line_no_, rel_no_);

   -- If there are no packages to be picked or to be finished no need to go through the below methods.
   IF NOT (pkg_qty_to_pick_ = 0 AND pkg_qty_to_finish_  = 0 )THEN
      -- All non inventory lines are always possible to pick
      pkg_revised_qty_due_ := Customer_Order_Line_API.Get_Revised_Qty_Due(order_no_, line_no_, rel_no_, -1);
      OPEN non_inventory_to_deliver;
      FETCH non_inventory_to_deliver INTO min_pkg_picked_;
      IF (non_inventory_to_deliver%NOTFOUND) THEN
         min_pkg_picked_ := 99999999999999.99;
      END IF;
      CLOSE non_inventory_to_deliver;
      
      @ApproveTransactionStatement(2014-08-15,darklk)
      SAVEPOINT check_shortage;

      OPEN get_inventory_line;
      FETCH get_inventory_line BULK COLLECT INTO lines_;
      CLOSE get_inventory_line;
      IF (lines_.count > 0) THEN
         FOR i IN lines_.FIRST .. lines_.LAST LOOP
            Check_Reserve_Package_Comp___(line_qty_per_pkg_, line_qty_picked_, line_qty_to_pick_,
                                          line_qty_to_finish_, order_no_, line_no_, rel_no_,
                                          lines_(i).line_item_no, pkg_qty_picked_, pkg_qty_to_finish_);

            line_qty_to_pick_  := line_qty_to_pick_ - lines_(i).qty_on_order;
            line_qty_possible_ := Inventory_Part_In_Stock_API.Get_Avail_Plan_Qty_Loc_Type(contract_            => lines_(i).contract,
                                                                                          part_no_             => lines_(i).part_no,
                                                                                          configuration_id_    => lines_(i).configuration_id,
                                                                                          activity_seq_        => NULL,
                                                                                          qty_type_            => 'AVAILABLE',
                                                                                          date_requested_      => NULL,
                                                                                          location_type1_db_   => 'PICKING',
                                                                                          location_type2_db_   => 'SHIPMENT');

            inv_part_rec_      := Inventory_Part_API.Get(lines_(i).contract, lines_(i).part_no);
            IF (inv_part_rec_.co_reserve_onh_analys_flag = 'Y') THEN

               IF lines_(i).part_ownership = 'SUPPLIER LOANED' THEN
                  owning_vendor_no_ := Customer_Order_Line_API.Get_Owner_For_Part_Ownership(order_no_, line_no_, rel_no_, lines_(i).line_item_no, lines_(i).part_ownership );
               END IF;

               Inventory_Part_In_Stock_API.Make_Onhand_Analysis(result_                => rcode_, 
                                                                qty_possible_          => onhand_line_qty_possible_, 
                                                                next_analysis_date_    => dummy_date_, 
                                                                planned_delivery_date_ => test_date_, 
                                                                planned_due_date_      => test_date_,
                                                                contract_              => lines_(i).contract, 
                                                                part_no_               => lines_(i).part_no, 
                                                                configuration_id_      => lines_(i).configuration_id,
                                                                include_standard_      => 'TRUE', 
                                                                include_project_       => 'TRUE', 
                                                                project_id_            => NULL, 
                                                                activity_seq_          => NULL, 
                                                                row_id_                => lines_(i).objid, 
                                                                qty_desired_           => line_qty_to_pick_,
                                                                picking_leadtime_      => lines_(i).picking_leadtime, 
                                                                part_ownership_        => lines_(i).part_ownership, 
                                                                owning_vendor_no_      => owning_vendor_no_, 
                                                                owning_customer_no_    => lines_(i).owning_customer_no);

               line_qty_possible_ := least(line_qty_possible_, onhand_line_qty_possible_);
               IF (rcode_ != 'SUCCESS') THEN
                  Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, lines_(i).line_item_no, 'PLANPICK09');
                  qty_short_ := Shortage_Demand_API.Calculate_Order_Shortage_Qty(lines_(i).contract,
                                                                                 lines_(i).part_no,
                                                                                 lines_(i).revised_qty_due,
                                                                                 lines_(i).qty_assigned ,
                                                                                 (lines_(i).qty_shipped + lines_(i).qty_on_order));
                  Customer_Order_Line_API.Set_Qty_Short(order_no_, line_no_, rel_no_, lines_(i).line_item_no, qty_short_);
               ELSE
                  Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, lines_(i).line_item_no, 'PLANPICK10');
               END IF;
            ELSE

               IF (line_qty_to_pick_ > line_qty_possible_) THEN
                  Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, lines_(i).line_item_no, 'PLANPICK09');
                  qty_short_ := Shortage_Demand_API.Calculate_Order_Shortage_Qty(lines_(i).contract,
                                                                                 lines_(i).part_no,
                                                                                 lines_(i).revised_qty_due,
                                                                                 lines_(i).qty_assigned ,
                                                                                 (lines_(i).qty_shipped + lines_(i).qty_on_order));
                  Customer_Order_Line_API.Set_Qty_Short(order_no_, line_no_, rel_no_, lines_(i).line_item_no, qty_short_);
               ELSE
                  Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, lines_(i).line_item_no, 'PLANPICK10');
               END IF;
            END IF;
            min_pkg_picked_ := least(floor(least(line_qty_to_pick_,line_qty_possible_) /
                                           line_qty_per_pkg_), min_pkg_picked_);
         END LOOP;
      END IF;

      order_line_info_         := order_no_ ||' '|| line_no_ ||' '|| rel_no_;
      linerec_                 := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, -1);
      allow_partial_pkg_deliv_ := Sales_Part_API.Get_Allow_Partial_Pkg_Deliv_Db(
                                                                        linerec_.contract,
                                                                        linerec_.catalog_no);
      IF (min_pkg_picked_ = 99999999999999.99) THEN
         min_pkg_picked_ := 0;
      ELSIF (min_pkg_picked_ >= pkg_qty_to_pick_) THEN
         -- No shortage occurred, remove the created shortage record.
         @ApproveTransactionStatement(2014-08-15,darklk)
         ROLLBACK TO check_shortage;
      END IF;

      IF (min_pkg_picked_ <= 0) THEN
         -- write an info message to background
         IF NOT (backorder_option_db_ = 'NO PARTIAL DELIVERIES ALLOWED') THEN
            reservation_info_ := Language_SYS.Translate_Constant(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                                                 NULL, linerec_.catalog_no, order_line_info_);
            IF (Transaction_SYS.Is_Session_Deferred) THEN
               Transaction_SYS.Set_Status_Info(reservation_info_);
            ELSE
               Client_SYS.Add_Info(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                   linerec_.catalog_no, order_line_info_);
            END IF;
         END IF;
         IF (backorder_option_db_ IN ('NO PARTIAL DELIVERIES ALLOWED', 'INCOMPLETE LINES NOT ALLOWED')) THEN
            Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, -1, 'PLANPICK06');
         ELSE
            Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, -1, 'PLANPICK08');
         END IF;
      ELSIF ((min_pkg_picked_ < pkg_qty_to_pick_) AND (min_pkg_picked_ > 0)) THEN
         -- write an info message to background
         IF (backorder_option_db_ IN ('INCOMPLETE PACKAGES NOT ALLOWED','ALLOW INCOMPLETE LINES AND PACKAGES')) THEN
            reservation_info_ := Language_SYS.Translate_Constant(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                                                 NULL, linerec_.catalog_no, order_line_info_);
            IF (Transaction_SYS.Is_Session_Deferred) THEN
               Transaction_SYS.Set_Status_Info(reservation_info_);
            ELSE
               Client_SYS.Add_Info(lu_name_, 'CANNOTRESERVE: All reservations could not be made for part :P1 on order line :P2. Check the customer order shortages for more info.',
                                   linerec_.catalog_no, order_line_info_);
            END IF;
         END IF;

         IF (backorder_option_db_ = 'INCOMPLETE PACKAGES NOT ALLOWED' OR
             (backorder_option_db_ = 'ALLOW INCOMPLETE LINES AND PACKAGES' AND allow_partial_pkg_deliv_ = 'FALSE')) THEN
            Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, -1, 'PLANPICK07');
         ELSE
            Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, -1, 'PLANPICK06');
            min_pkg_picked_ := 0;
         END IF;
      END IF;
   END IF;
END Check_Package___;


-- Check_Reserve_Package___
--   Procedure to check how much of a package that is picked and
--   Left to pick and how many partially picked packages that exists.
--   Return parameters:
--   qty_picked_    The number of whole packages picked.
--   qty_to_pick_   The number of remaining whole packages that should be reserved.
--   Outstanding orders for any of the components will be considered.
--   qty_to_finish_ Number of packages partly picked which should be completed.
PROCEDURE Check_Reserve_Package___ (
   qty_picked_    OUT NUMBER,
   qty_to_pick_   OUT NUMBER,
   qty_to_finish_ OUT NUMBER,
   order_no_      IN  VARCHAR2,
   line_no_       IN  VARCHAR2,
   rel_no_        IN  VARCHAR2)
IS 
   pkgs_fully_picked_   NUMBER := 99999999999999;
   pkgs_picked_in_part_ NUMBER := 0;
   
   CURSOR get_qty_from_component IS
      SELECT decode(supply_code, 'IO', qty_assigned, 'PI', qty_assigned,
                    'SO', qty_assigned, 'PT', qty_assigned, 'IPT', qty_assigned,
                    'PS', qty_assigned,
                    'NO', qty_to_ship, 'PRJ', qty_to_ship, qty_assigned) qty_assigned,
                    qty_shipped, revised_qty_due, qty_on_order, qty_per_assembly, inverted_conv_factor, conv_factor
      FROM   customer_order_line_tab
      WHERE  supply_code IN ('IO', 'SO', 'PT', 'NO', 'IPT','PS', 'PI', 'PRJ')
      AND    rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      ORDER BY line_item_no;

   TYPE Pkg_Comps_Tab IS TABLE OF get_qty_from_component%ROWTYPE
   INDEX BY PLS_INTEGER;
   comp_rec_            Pkg_Comps_Tab;
BEGIN

   OPEN get_qty_from_component;
   FETCH get_qty_from_component BULK COLLECT INTO comp_rec_;
   CLOSE get_qty_from_component;

   IF (comp_rec_.count > 0) THEN
      qty_to_pick_ := 0;
      FOR i IN comp_rec_.FIRST .. comp_rec_.LAST LOOP
         pkgs_fully_picked_   := LEAST(pkgs_fully_picked_,
                                       FLOOR(((comp_rec_(i).qty_assigned + comp_rec_(i).qty_shipped) /
                                               comp_rec_(i).qty_per_assembly) * comp_rec_(i).inverted_conv_factor/comp_rec_(i).conv_factor));
         
         pkgs_picked_in_part_ := GREATEST(pkgs_picked_in_part_,
                                          CEIL(((comp_rec_(i).qty_assigned + comp_rec_(i).qty_shipped) /
                                                 comp_rec_(i).qty_per_assembly) * comp_rec_(i).inverted_conv_factor/comp_rec_(i).conv_factor));
         
         qty_to_pick_ := GREATEST(qty_to_pick_, ((comp_rec_(i).revised_qty_due - (comp_rec_(i).qty_assigned + comp_rec_(i).qty_shipped) - comp_rec_(i).qty_on_order) /
                                                  comp_rec_(i).qty_per_assembly) * comp_rec_(i).inverted_conv_factor/comp_rec_(i).conv_factor);
      END LOOP;
   END IF;
   qty_picked_    := pkgs_fully_picked_;
   -- If we are still expecting deliveries of components from other sites or external suppliers
   -- this will have to be considered when calculating how much of the quantity for the package
   -- that we should try to reserve now.
   
   -- The number of partially reserved and/or delivered packages, here the qty_on_order
   -- should not be considered.
   qty_to_finish_ := pkgs_picked_in_part_ - pkgs_fully_picked_;
END Check_Reserve_Package___;


-- Check_Reserve_Package_Comp___
--   Procedure to check how much of a package component that is picked
--   and left to pick and how many partially picked component that exists.
PROCEDURE Check_Reserve_Package_Comp___ (
   qty_per_pkg_       OUT NUMBER,
   qty_picked_        OUT NUMBER,
   qty_to_pick_       OUT NUMBER,
   qty_to_finish_     OUT NUMBER,
   order_no_          IN  VARCHAR2,
   line_no_           IN  VARCHAR2,
   rel_no_            IN  VARCHAR2,
   line_item_no_      IN  NUMBER,
   pkg_qty_picked_    IN  NUMBER,   
   pkg_qty_to_finish_ IN  NUMBER )
IS
   line_qty_per_pkg_    NUMBER;
   line_picked_         NUMBER;
   line_to_pick_        NUMBER;   
   pkg_revised_qty_due_ NUMBER;

   CURSOR get_qty_from_component IS
      SELECT decode(supply_code, 'IO', qty_assigned, 'SO', qty_assigned,
                                 'PT', qty_assigned, 'IPT', qty_assigned,
                                 'PS', qty_assigned, 'PI', qty_assigned,
                                 'NO', qty_to_ship, 'PRJ', qty_to_ship, qty_assigned) qty_assigned,
             qty_shipped, revised_qty_due
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    line_item_no = line_item_no_
      AND    rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered');

   linerec_             get_qty_from_component%ROWTYPE;
BEGIN
   pkg_revised_qty_due_ := Customer_Order_Line_API.Get_Revised_Qty_Due(order_no_, line_no_, rel_no_, -1);

   OPEN  get_qty_from_component;
   FETCH get_qty_from_component INTO linerec_;
   IF (get_qty_from_component%FOUND) THEN
      line_qty_per_pkg_ := linerec_.revised_qty_due / pkg_revised_qty_due_;
      line_picked_      := linerec_.qty_assigned + linerec_.qty_shipped;
      line_to_pick_     := linerec_.revised_qty_due - line_picked_;
   END IF;
   CLOSE get_qty_from_component;

   qty_picked_    := line_picked_;
   qty_to_pick_   := line_to_pick_;
   qty_to_finish_ := pkg_qty_to_finish_ * line_qty_per_pkg_ - line_picked_ + pkg_qty_picked_ * line_qty_per_pkg_;
   qty_per_pkg_   := line_qty_per_pkg_;
END Check_Reserve_Package_Comp___;


-- Lock___
--   Lock the specified order for processing
PROCEDURE Lock___ (
   order_no_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR get_id IS
      SELECT rowid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000))
      FROM CUSTOMER_ORDER_TAB
      WHERE order_no = order_no_;
BEGIN
   OPEN get_id;
   FETCH get_id INTO objid_, objversion_;
   CLOSE get_id;
   --Customer_Order_API.Lock__(info_, objid_, objversion_);
END Lock___;


-- Register_Arrival___
--   makes the neccessry reservations in inventory and customer order when
--   purchase and shpord delivers to order.
PROCEDURE Register_Arrival___ (
   qty_on_order_diff_ OUT NUMBER,
   qty_reserved_      OUT NUMBER,
   qty_received_      IN  NUMBER,
   order_no_          IN  VARCHAR2,
   line_no_           IN  VARCHAR2,
   rel_no_            IN  VARCHAR2,
   line_item_no_      IN  NUMBER,
   contract_          IN  VARCHAR2,
   part_no_           IN  VARCHAR2,
   configuration_id_  IN  VARCHAR2,
   location_no_       IN  VARCHAR2,
   lot_batch_no_      IN  VARCHAR2,
   serial_no_         IN  VARCHAR2,
   eng_chg_level_     IN  VARCHAR2,
   waiv_dev_rej_no_   IN  VARCHAR2,
   activity_seq_      IN  NUMBER,
   handling_unit_id_  IN  NUMBER,
   line_rec_          IN  Customer_Order_Line_API.Public_Rec)
IS
   qty_on_order_     NUMBER;
   old_qty_shipped_  NUMBER;
   old_qty_assigned_ NUMBER;   
   qty_to_assign_    NUMBER;
   old_qty_shipdiff_ NUMBER;
   res_source_       VARCHAR2(200);
   objstate_         customer_order_tab.rowstate%TYPE;
BEGIN
   IF (line_rec_.supply_code IN ('PT', 'IPT', 'SO', 'DOP', 'IO')) THEN
      objstate_ := Customer_Order_API.Get_Objstate(order_no_);
      IF (objstate_ NOT IN ('Blocked', 'Invoiced', 'Delivered', 'Planned')) THEN
         Customer_Order_Flow_API.Credit_Check_Order(order_no_, 'PICK_PROPOSAL');
      END IF;
   END IF;
   
   old_qty_shipped_  := line_rec_.qty_shipped;
   old_qty_assigned_ := line_rec_.qty_assigned;
   old_qty_shipdiff_ := line_rec_.qty_shipdiff;
   -- Calculate the quantity to reserve
   qty_to_assign_    := LEAST(line_rec_.revised_qty_due - old_qty_shipped_ - old_qty_assigned_ + old_qty_shipdiff_, line_rec_.qty_on_order) ;
   qty_to_assign_    := least(qty_to_assign_, qty_received_);
   qty_on_order_     := GREATEST(line_rec_.qty_on_order - qty_received_, 0);
   Customer_Order_Line_API.Modify_Qty_On_Order(order_no_, line_no_, rel_no_, line_item_no_, qty_on_order_);
   qty_on_order_diff_ := qty_on_order_ - line_rec_.qty_on_order;

   -- Reservation logic have been removed from this method and moved to Create_Arrival_Reservations___ because this functionality
   -- is also used by the CC-process when a Capability Checked Customer Order Line is released and the Interim Order reservations
   -- are moved to the COL and here we dont want any qty_on_order considerations at all
   Create_Arrival_Reservations___(qty_to_assign_    => qty_to_assign_, 
                                  order_no_         => order_no_,         
                                  line_no_          => line_no_,     
                                  rel_no_           => rel_no_,       
                                  line_item_no_     => line_item_no_, 
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
                                  line_rec_         => line_rec_);

   -- remove unused serial numbers if nothing more to reserve on this order line.
   IF (qty_received_ >= (line_rec_.revised_qty_due - line_rec_.qty_assigned - line_rec_.qty_shipped + line_rec_.qty_shipdiff)) THEN
      res_source_ := 'CUSTOMER ORDER';
      IF (Serial_No_Reservation_API.Check_Reservation_Exist(order_no_, line_no_, rel_no_, line_item_no_, res_source_, part_no_) = 'TRUE') THEN
         Serial_No_Reservation_API.Delete_Reserved(order_no_, line_no_, rel_no_, line_item_no_, res_source_);
      END IF;
   END IF;

   qty_reserved_ := qty_to_assign_;
END Register_Arrival___;


-- Unregister_Arrival___
--   makes the neccessry unreservations in inventory and customer order when
--   shpord do unreceive to order.
PROCEDURE Unregister_Arrival___ (
   qty_on_order_diff_ OUT NUMBER,
   qty_reserved_      OUT NUMBER,
   qty_received_      IN  NUMBER,
   order_no_          IN  VARCHAR2,
   line_no_           IN  VARCHAR2,
   rel_no_            IN  VARCHAR2,
   line_item_no_      IN  NUMBER,
   contract_          IN  VARCHAR2,
   part_no_           IN  VARCHAR2,
   configuration_id_  IN  VARCHAR2,
   location_no_       IN  VARCHAR2,
   lot_batch_no_      IN  VARCHAR2,
   serial_no_         IN  VARCHAR2,
   eng_chg_level_     IN  VARCHAR2,
   waiv_dev_rej_no_   IN  VARCHAR2,
   activity_seq_      IN  NUMBER,
   handling_unit_id_  IN  NUMBER, 
   line_rec_          IN  Customer_Order_Line_API.Public_Rec)
IS
   qty_on_order_              NUMBER;
   qty_assigned_              NUMBER;
   qty_to_assign_             NUMBER;
   my_pick_list_no_           customer_order_reservation_tab.pick_list_no%TYPE := '*';
   my_configuration_id_       customer_order_reservation_tab.configuration_id%TYPE;         
   catch_quantity_            NUMBER := NULL;
   new_qty_assigned_          NUMBER :=0;
   co_new_qty_assigned_       NUMBER;
   qty_to_split_per_shipment_ NUMBER :=0;
   total_qty_to_assign_       NUMBER :=0;
   inv_part_cost_level_       VARCHAR2(50);
   -- Customer order reservations to unreserve, sorted with shipment ID = 0 first and then shipment ID > 0 descending.
   -- The purpose is to unreserve what is expected to be delivered last i.e. the oldest shipment is 
   -- expected to be delivered first.
   -- Reservations with different shipment ID are only interchangable if it is the same stock record and order line.
   CURSOR get_reservations_to_unreserve IS
      SELECT shipment_id
      FROM customer_order_reservation_tab
      WHERE order_no         = order_no_
      AND   line_no          = line_no_
      AND   rel_no           = rel_no_
      AND   line_item_no     = line_item_no_
      AND   contract         = contract_
      AND   part_no          = part_no_
      AND   location_no      = location_no_
      AND   lot_batch_no     = lot_batch_no_
      AND   serial_no        = serial_no_
      AND   eng_chg_level    = eng_chg_level_
      AND   waiv_dev_rej_no  = waiv_dev_rej_no_
      AND   activity_seq     = NVL(activity_seq_,0)
      AND   handling_unit_id = handling_unit_id_
      AND   pick_list_no     = my_pick_list_no_
      AND   configuration_id = my_configuration_id_
      ORDER BY CASE shipment_id 
                 WHEN 0 THEN NULL 
                 ELSE shipment_id  
               END DESC;
BEGIN
   IF configuration_id_ IS NULL THEN
      my_configuration_id_ := line_rec_.configuration_id;
   ELSIF configuration_id_ != line_rec_.configuration_id THEN
      Error_Sys.Record_General(lu_name_,
                               'WRONGCFGARR: The configuration of the arrived part, :P1 does not match the ordered one on order :P2',
                               part_no_, order_no_ );
   ELSE
      my_configuration_id_ := configuration_id_;
   END IF;

   qty_to_split_per_shipment_ := qty_received_;
   
   FOR rec_ IN get_reservations_to_unreserve LOOP
      -- split the reservations(to unreserve) for order and then for the shipments
      qty_assigned_ := Customer_Order_Reservation_API.Get_Qty_Assigned(order_no_          => order_no_, 
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
                                                                       activity_seq_      => NVL(activity_seq_,0),
                                                                       handling_unit_id_  => handling_unit_id_,
                                                                       configuration_id_  => my_configuration_id_, 
                                                                       pick_list_no_      => my_pick_list_no_, 
                                                                       shipment_id_       => rec_.shipment_id);
      IF (qty_assigned_ IS NULL) THEN
         -- No reservations exist, nothing to unreserve
         qty_to_assign_ := 0;
      ELSIF (qty_assigned_ >= (-1) * qty_to_split_per_shipment_ ) THEN
      -- If the qty to be unreceived is less than the qty reserved in the CO Line, then unreceive the full qty.
         qty_to_assign_ := qty_to_split_per_shipment_;
      ELSE
         qty_to_assign_ := (-1) * qty_assigned_ ;
      END IF;

      -- If some reservations exist clear them as it is going to be unreserved.
      IF (NVL(qty_to_assign_, 0) != 0) THEN
         new_qty_assigned_ := qty_assigned_ + qty_to_assign_;
         IF (new_qty_assigned_ = 0) THEN
            Customer_Order_Reservation_API.Remove(order_no_         => order_no_, 
                                                  line_no_          => line_no_, 
                                                  rel_no_           => rel_no_, 
                                                  line_item_no_     => line_item_no_, 
                                                  contract_         => contract_, 
                                                  part_no_          => part_no_, 
                                                  location_no_      => location_no_, 
                                                  lot_batch_no_     => lot_batch_no_,
                                                  serial_no_        => serial_no_, 
                                                  eng_chg_level_    => eng_chg_level_, 
                                                  waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                                  activity_seq_     => NVL(activity_seq_,0), 
                                                  handling_unit_id_ => handling_unit_id_,
                                                  pick_list_no_     => my_pick_list_no_, 
                                                  configuration_id_ => my_configuration_id_, 
                                                  shipment_id_      => rec_.shipment_id);
         ELSE
            Customer_Order_Reservation_API.Modify_Qty_Assigned(order_no_              => order_no_, 
                                                               line_no_               => line_no_, 
                                                               rel_no_                => rel_no_, 
                                                               line_item_no_          => line_item_no_,
                                                               contract_              => contract_, 
                                                               part_no_               => part_no_, 
                                                               location_no_           => location_no_, 
                                                               lot_batch_no_          => lot_batch_no_,
                                                               serial_no_             => serial_no_, 
                                                               eng_chg_level_         => eng_chg_level_, 
                                                               waiv_dev_rej_no_       => waiv_dev_rej_no_, 
                                                               activity_seq_          => NVL(activity_seq_,0),
                                                               handling_unit_id_      => handling_unit_id_,
                                                               pick_list_no_          => my_pick_list_no_, 
                                                               configuration_id_      => my_configuration_id_, 
                                                               shipment_id_           => rec_.shipment_id,
                                                               qty_assigned_          => new_qty_assigned_, 
                                                               input_qty_             => NULL, 
                                                               input_unit_meas_       => NULL, 
                                                               input_conv_factor_     => NULL, 
                                                               input_variable_values_ => NULL);
         END IF;

         qty_to_split_per_shipment_ := qty_to_split_per_shipment_ - qty_to_assign_;
         total_qty_to_assign_       := total_qty_to_assign_ + qty_to_assign_;
      END IF;      
      EXIT WHEN (qty_to_split_per_shipment_ = 0);      
   END LOOP;
   
   -- If some reservations exist clear them as it is going to be unreserved.
   IF (NVL(total_qty_to_assign_, 0) != 0) THEN
     
      co_new_qty_assigned_ := line_rec_.qty_assigned + total_qty_to_assign_;
      Customer_Order_API.Set_Line_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_, co_new_qty_assigned_);

      -- The qty_on_order of the CO Line should be increased by the amount unreceived.
      qty_on_order_        := line_rec_.qty_on_order - total_qty_to_assign_ ;
      Customer_Order_Line_API.Modify_Qty_On_Order(order_no_, line_no_, rel_no_, line_item_no_, qty_on_order_);
      qty_on_order_diff_   := qty_on_order_ - line_rec_.qty_on_order;

      -- Unreserve the qty that is unreceived from the inventory. The qty unreserve is a negative value.
      Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_   => catch_quantity_, 
                                               contract_         => contract_, 
                                               part_no_          => part_no_, 
                                               configuration_id_ => my_configuration_id_, 
                                               location_no_      => location_no_, 
                                               lot_batch_no_     => lot_batch_no_,
                                               serial_no_        => serial_no_, 
                                               eng_chg_level_    => eng_chg_level_, 
                                               waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                               activity_seq_     => NVL(activity_seq_,0), 
                                               handling_unit_id_ => handling_unit_id_,
                                               quantity_         => total_qty_to_assign_);
      inv_part_cost_level_ := Inventory_Part_API.Get_Invent_Part_Cost_Level_Db(contract_, part_no_);
      IF (inv_part_cost_level_ = 'COST PER LOT BATCH') OR (inv_part_cost_level_ = 'COST PER SERIAL') THEN
         Modify_Cost_After_Reserve___(order_no_, line_no_, rel_no_, line_item_no_, line_rec_.qty_assigned, lot_batch_no_, serial_no_);
      END IF;
   END IF;

   -- Return the actual amount unreceived.
   qty_reserved_ := total_qty_to_assign_;
END Unregister_Arrival___;


-- Reserve_Supply_Site_Man___
--   makes the manual supply site reservations for the customer order in
--   the temporary object Co_Supply_Site_Reservation_API.
PROCEDURE Reserve_Supply_Site_Man___ (
   new_qty_assigned_     OUT NUMBER,
   order_no_             IN  VARCHAR2,
   line_no_              IN  VARCHAR2,
   rel_no_               IN  VARCHAR2,
   line_item_no_         IN  NUMBER,
   contract_             IN  VARCHAR2,
   part_no_              IN  VARCHAR2,
   location_no_          IN  VARCHAR2,
   lot_batch_no_         IN  VARCHAR2,
   serial_no_            IN  VARCHAR2,
   eng_chg_level_        IN  VARCHAR2,
   waiv_dev_rej_no_      IN  VARCHAR2,
   activity_seq_         IN  NUMBER,
   handling_unit_id_     IN  NUMBER,
   configuration_id_     IN  VARCHAR2,
   total_qty_to_reserve_ IN  NUMBER,
   old_qty_assigned_     IN  NUMBER )
IS
   location_type_db_ VARCHAR2(20);
BEGIN
   location_type_db_ := Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_);

   IF (Co_Supply_Site_Reservation_API.Oe_Exist(order_no_         => order_no_, 
                                               line_no_          => line_no_, 
                                               rel_no_           => rel_no_, 
                                               line_item_no_     => line_item_no_,
                                               supply_site_      => contract_, 
                                               part_no_          => part_no_, 
                                               configuration_id_ => configuration_id_, 
                                               location_no_      => location_no_, 
                                               lot_batch_no_     => lot_batch_no_, 
                                               serial_no_        => serial_no_,
                                               eng_chg_level_    => eng_chg_level_, 
                                               waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                               activity_seq_     => activity_seq_, 
                                               handling_unit_id_ => handling_unit_id_ ) = 1) THEN

      new_qty_assigned_ := Co_Supply_Site_Reservation_API.Get_Qty_Assigned(order_no_         => order_no_, 
                                                                           line_no_          => line_no_, 
                                                                           rel_no_           => rel_no_, 
                                                                           line_item_no_     => line_item_no_,
                                                                           supply_site_      => contract_, 
                                                                           part_no_          => part_no_, 
                                                                           configuration_id_ => configuration_id_, 
                                                                           location_no_      => location_no_, 
                                                                           lot_batch_no_     => lot_batch_no_, 
                                                                           serial_no_        => serial_no_,
                                                                           eng_chg_level_    => eng_chg_level_, 
                                                                           waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                                                           activity_seq_     => activity_seq_, 
                                                                           handling_unit_id_ => handling_unit_id_) + total_qty_to_reserve_;
      IF (new_qty_assigned_ = 0) THEN
         Co_Supply_Site_Reservation_API.Remove(order_no_         => order_no_, 
                                               line_no_          => line_no_, 
                                               rel_no_           => rel_no_, 
                                               line_item_no_     => line_item_no_,
                                               supply_site_      => contract_, 
                                               part_no_          => part_no_, 
                                               configuration_id_ => configuration_id_, 
                                               location_no_      => location_no_, 
                                               lot_batch_no_     => lot_batch_no_, 
                                               serial_no_        => serial_no_,
                                               eng_chg_level_    => eng_chg_level_, 
                                               waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                               activity_seq_     => activity_seq_, 
                                               handling_unit_id_ => handling_unit_id_);
      ELSE
         IF (location_type_db_ = Inventory_Location_Type_API.DB_FLOOR_STOCK) AND (new_qty_assigned_>old_qty_assigned_)  THEN
            Raise_Wrong_Loc_Error___();
         END IF;
         Co_Supply_Site_Reservation_API.Modify_Qty_Assigned(order_no_         => order_no_, 
                                                            line_no_          => line_no_, 
                                                            rel_no_           => rel_no_, 
                                                            line_item_no_     => line_item_no_,
                                                            supply_site_      => contract_, 
                                                            part_no_          => part_no_, 
                                                            configuration_id_ => configuration_id_, 
                                                            location_no_      => location_no_, 
                                                            lot_batch_no_     => lot_batch_no_, 
                                                            serial_no_        => serial_no_,
                                                            eng_chg_level_    => eng_chg_level_, 
                                                            waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                                            activity_seq_     => activity_seq_, 
                                                            handling_unit_id_ => handling_unit_id_,
                                                            qty_assigned_     => new_qty_assigned_);
      END IF;
   ELSE
      -- total_qty_to_reserve_ cannot be negative when creating a new reservation. 
      IF (total_qty_to_reserve_ < 0)  THEN
          Raise_Qty_Reservation_Error___();
      END IF;

      IF (location_type_db_ = Inventory_Location_Type_API.DB_FLOOR_STOCK) THEN
         Raise_Wrong_Loc_Error___();      
      END IF;
      Co_Supply_Site_Reservation_API.New(order_no_         => order_no_, 
                                         line_no_          => line_no_, 
                                         rel_no_           => rel_no_, 
                                         line_item_no_     => line_item_no_,
                                         supply_site_      => contract_, 
                                         part_no_          => part_no_, 
                                         configuration_id_ => configuration_id_, 
                                         location_no_      => location_no_, 
                                         lot_batch_no_     => lot_batch_no_, 
                                         serial_no_        => serial_no_,
                                         eng_chg_level_    => eng_chg_level_, 
                                         waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                         activity_seq_     => activity_seq_, 
                                         handling_unit_id_ => handling_unit_id_,
                                         qty_assigned_     => total_qty_to_reserve_);
   END IF;

   new_qty_assigned_ := old_qty_assigned_ + total_qty_to_reserve_;
END Reserve_Supply_Site_Man___;


-- Reserve_Src_Supply_Site_Man___
--   makes the manual sourced supply site reservations for the customer order in
--   the temporary object Sourced_Co_Supply_Site_Res_API.
PROCEDURE Reserve_Src_Supply_Site_Man___ (
   new_qty_assigned_     OUT NUMBER,
   order_no_             IN  VARCHAR2,
   line_no_              IN  VARCHAR2,
   rel_no_               IN  VARCHAR2,
   line_item_no_         IN  NUMBER,
   source_id_            IN  NUMBER,
   contract_             IN  VARCHAR2,
   part_no_              IN  VARCHAR2,
   location_no_          IN  VARCHAR2,
   lot_batch_no_         IN  VARCHAR2,
   serial_no_            IN  VARCHAR2,
   eng_chg_level_        IN  VARCHAR2,
   waiv_dev_rej_no_      IN  VARCHAR2,
   activity_seq_         IN  NUMBER,
   handling_unit_id_     IN  NUMBER,
   configuration_id_     IN  VARCHAR2,
   total_qty_to_reserve_ IN  NUMBER,
   old_qty_assigned_     IN  NUMBER )
IS
   location_type_db_ VARCHAR2(20);
BEGIN
   location_type_db_ := Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_);

   IF (Sourced_Co_Supply_Site_Res_API.Oe_Exist(order_no_         => order_no_, 
                                               line_no_          => line_no_, 
                                               rel_no_           => rel_no_, 
                                               line_item_no_     => line_item_no_,
                                               source_id_        => source_id_, 
                                               supply_site_      => contract_, 
                                               part_no_          => part_no_, 
                                               configuration_id_ => configuration_id_, 
                                               location_no_      => location_no_, 
                                               lot_batch_no_     => lot_batch_no_,
                                               serial_no_        => serial_no_, 
                                               eng_chg_level_    => eng_chg_level_, 
                                               waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                               activity_seq_     => activity_seq_, 
                                               handling_unit_id_ => handling_unit_id_) = 1) THEN

      new_qty_assigned_  := Sourced_Co_Supply_Site_Res_API.Get_Qty_Assigned(order_no_         => order_no_,
                                                                            line_no_          => line_no_,
                                                                            rel_no_           => rel_no_,
                                                                            line_item_no_     => line_item_no_,
                                                                            source_id_        => source_id_,
                                                                            supply_site_      => contract_,
                                                                            part_no_          => part_no_,
                                                                            configuration_id_ => configuration_id_,
                                                                            location_no_      => location_no_,
                                                                            lot_batch_no_     => lot_batch_no_,
                                                                            serial_no_        => serial_no_,
                                                                            eng_chg_level_    => eng_chg_level_,
                                                                            waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                            activity_seq_     => activity_seq_,
                                                                            handling_unit_id_ => handling_unit_id_ )  + total_qty_to_reserve_;
      
      IF (new_qty_assigned_ = 0) THEN
         Sourced_Co_Supply_Site_Res_API.Remove(order_no_         => order_no_,
                                               line_no_          => line_no_,
                                               rel_no_           => rel_no_,
                                               line_item_no_     => line_item_no_,                                                                     
                                               source_id_        => source_id_,
                                               supply_site_      => contract_,
                                               part_no_          => part_no_,
                                               configuration_id_ => configuration_id_,
                                               location_no_      => location_no_,
                                               lot_batch_no_     => lot_batch_no_,
                                               serial_no_        => serial_no_,
                                               eng_chg_level_    => eng_chg_level_,
                                               waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                               activity_seq_     => activity_seq_,
                                               handling_unit_id_ => handling_unit_id_);
      ELSE
         IF (location_type_db_ = Inventory_Location_Type_API.DB_FLOOR_STOCK) AND (new_qty_assigned_>old_qty_assigned_)  THEN
            Raise_Wrong_Loc_Error___();
         END IF;
         
         Sourced_Co_Supply_Site_Res_API.Modify_Qty_Assigned(order_no_         => order_no_,
                                                            line_no_          => line_no_,
                                                            rel_no_           => rel_no_,
                                                            line_item_no_     => line_item_no_,                                                                     
                                                            source_id_        => source_id_,
                                                            supply_site_      => contract_,
                                                            part_no_          => part_no_,
                                                            configuration_id_ => configuration_id_,
                                                            location_no_      => location_no_,
                                                            lot_batch_no_     => lot_batch_no_,
                                                            serial_no_        => serial_no_,
                                                            eng_chg_level_    => eng_chg_level_,
                                                            waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                            activity_seq_     => activity_seq_,
                                                            handling_unit_id_ => handling_unit_id_,                                                                   
                                                            qty_assigned_     => new_qty_assigned_);
     END IF;
   ELSE
     -- total_qty_to_reserve_ cannot be negative when creating a new reservation. 
     IF (total_qty_to_reserve_ < 0)  THEN
         Raise_Qty_Reservation_Error___();
     END IF;

     IF (location_type_db_ = Inventory_Location_Type_API.DB_FLOOR_STOCK) THEN
        Raise_Wrong_Loc_Error___();
     END IF;

     Sourced_Co_Supply_Site_Res_API.New(order_no_         => order_no_,
                                        line_no_          => line_no_,
                                        rel_no_           => rel_no_,
                                        line_item_no_     => line_item_no_,                                                                     
                                        source_id_        => source_id_,
                                        supply_site_      => contract_,
                                        part_no_          => part_no_,
                                        configuration_id_ => configuration_id_,
                                        location_no_      => location_no_,
                                        lot_batch_no_     => lot_batch_no_,
                                        serial_no_        => serial_no_,
                                        eng_chg_level_    => eng_chg_level_,
                                        waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                        activity_seq_     => activity_seq_,
                                        handling_unit_id_ => handling_unit_id_,
                                        qty_assigned_     => total_qty_to_reserve_);
   END IF;

   new_qty_assigned_ := old_qty_assigned_ + total_qty_to_reserve_;
END Reserve_Src_Supply_Site_Man___;


-- Reserve_Cust_Ord_Manually___
--   makes the manual reservations for the customer order in
--   object Customer_Order_Reservation_API.
PROCEDURE Reserve_Cust_Ord_Manually___ (
   new_qty_assigned_         OUT NUMBER,
   order_no_                 IN  VARCHAR2,
   line_no_                  IN  VARCHAR2,
   rel_no_                   IN  VARCHAR2,
   line_item_no_             IN  NUMBER,
   contract_                 IN  VARCHAR2,
   part_no_                  IN  VARCHAR2,
   location_no_              IN  VARCHAR2,
   lot_batch_no_             IN  VARCHAR2,
   serial_no_                IN  VARCHAR2,
   eng_chg_level_            IN  VARCHAR2,
   waiv_dev_rej_no_          IN  VARCHAR2,
   configuration_id_         IN  VARCHAR2,
   pick_list_no_             IN  VARCHAR2,
   activity_seq_             IN  NUMBER,
   handling_unit_id_         IN  NUMBER,
   total_qty_to_reserve_     IN  NUMBER,
   old_qty_assigned_         IN  NUMBER,
   catch_qty_                IN  NUMBER,
   input_qty_                IN  NUMBER,
   input_unit_meas_          IN  VARCHAR2,
   input_conv_factor_        IN  NUMBER,
   input_variable_values_    IN  VARCHAR2,
   shipment_id_              IN  NUMBER,
   reservation_operation_id_ IN  NUMBER,
   pick_by_choice_blocked_   IN  VARCHAR2 )
IS
   location_type_db_     VARCHAR2(20);
   rental_db_            VARCHAR2(5);
   local_input_qty_      NUMBER;
   local_input_var_val_  VARCHAR2(2000);
BEGIN
   location_type_db_ := Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_);
   rental_db_        := Customer_Order_Line_API.Get_Rental_Db(order_no_, line_no_, rel_no_, line_item_no_);

   IF (Customer_Order_Reservation_API.Oe_Exist(order_no_          => order_no_, 
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
                                               pick_list_no_      => pick_list_no_, 
                                               configuration_id_  => configuration_id_, 
                                               shipment_id_       => shipment_id_) = 1) THEN
      new_qty_assigned_ := Customer_Order_Reservation_API.Get_Qty_Assigned(order_no_         => order_no_, 
                                                                           line_no_          => line_no_, 
                                                                           rel_no_           => rel_no_, 
                                                                           line_item_no_     => line_item_no_,
                                                                           contract_         => contract_, 
                                                                           part_no_          => part_no_, 
                                                                           location_no_      => location_no_, 
                                                                           lot_batch_no_     => lot_batch_no_, 
                                                                           serial_no_        => serial_no_, 
                                                                           eng_chg_level_    => eng_chg_level_, 
                                                                           waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                           activity_seq_     => activity_seq_,
                                                                           handling_unit_id_ => handling_unit_id_,
                                                                           configuration_id_ => configuration_id_, 
                                                                           pick_list_no_     => pick_list_no_, 
                                                                           shipment_id_      => shipment_id_) + total_qty_to_reserve_;
      IF ((rental_db_ = Fnd_Boolean_API.DB_TRUE) AND 
          (reservation_operation_id_ IS NULL OR reservation_operation_id_ NOT IN (Inv_Part_Stock_Reservation_API.move_reservation_, 
                                                                                  Inv_Part_Stock_Reservation_API.unpack_reservation_))) THEN
         Validate_On_Rental_Period_Qty(order_no_,
                                       line_no_, 
                                       rel_no_, 
                                       line_item_no_,
                                       lot_batch_no_,
                                       serial_no_,
                                       total_qty_to_reserve_);
      END IF;
      
      IF (new_qty_assigned_ = 0) THEN
         Customer_Order_Reservation_API.Remove(order_no_           => order_no_, 
                                               line_no_            => line_no_, 
                                               rel_no_             => rel_no_, 
                                               line_item_no_       => line_item_no_,
                                               contract_           => contract_, 
                                               part_no_            => part_no_, 
                                               location_no_        => location_no_, 
                                               lot_batch_no_       => lot_batch_no_, 
                                               serial_no_          => serial_no_, 
                                               eng_chg_level_      => eng_chg_level_, 
                                               waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                               activity_seq_       => activity_seq_, 
                                               handling_unit_id_   => handling_unit_id_,
                                               pick_list_no_       => pick_list_no_, 
                                               configuration_id_   => configuration_id_, 
                                               shipment_id_        => shipment_id_);
      ELSE
         IF (location_type_db_ = Inventory_Location_Type_API.DB_FLOOR_STOCK) AND (new_qty_assigned_ > old_qty_assigned_) THEN
            Raise_Wrong_Loc_Error___();
         END IF;
         IF input_conv_factor_ IS NOT NULL THEN 
            local_input_qty_ := new_qty_assigned_ / input_conv_factor_;
            local_input_var_val_ := Input_Unit_Meas_API.Get_Input_Value_String(local_input_qty_, input_unit_meas_);
         END IF;
         Customer_Order_Reservation_API.Modify_Qty_Assigned(order_no_                  => order_no_, 
                                                            line_no_                   => line_no_, 
                                                            rel_no_                    => rel_no_, 
                                                            line_item_no_              => line_item_no_,
                                                            contract_                  => contract_, 
                                                            part_no_                   => part_no_, 
                                                            location_no_               => location_no_, 
                                                            lot_batch_no_              => lot_batch_no_, 
                                                            serial_no_                 => serial_no_, 
                                                            eng_chg_level_             => eng_chg_level_, 
                                                            waiv_dev_rej_no_           => waiv_dev_rej_no_,
                                                            activity_seq_              => activity_seq_, 
                                                            handling_unit_id_          => handling_unit_id_,
                                                            pick_list_no_              => pick_list_no_, 
                                                            configuration_id_          => configuration_id_, 
                                                            shipment_id_               => shipment_id_, 
                                                            qty_assigned_              => new_qty_assigned_,
                                                            input_qty_                 => local_input_qty_, 
                                                            input_unit_meas_           => input_unit_meas_, 
                                                            input_conv_factor_         => input_conv_factor_, 
                                                            input_variable_values_     => local_input_var_val_,
                                                            pick_by_choice_blocked_db_ => pick_by_choice_blocked_);
      END IF;
   ELSE
      IF (location_type_db_ = Inventory_Location_Type_API.DB_FLOOR_STOCK ) THEN
        Raise_Wrong_Loc_Error___();
     END IF;
      IF (total_qty_to_reserve_ < 0) THEN
         Raise_Qty_Reservation_Error___();
      END IF;
      IF input_conv_factor_ IS NOT NULL THEN 
         local_input_qty_ := total_qty_to_reserve_ / input_conv_factor_;
         local_input_var_val_ := Input_Unit_Meas_API.Get_Input_Value_String(local_input_qty_, input_unit_meas_);
      END IF;
      
      Customer_Order_Reservation_API.New(order_no_                 => order_no_, 
                                         line_no_                  => line_no_, 
                                         rel_no_                   => rel_no_, 
                                         line_item_no_             => line_item_no_,
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
                                         qty_assigned_             => total_qty_to_reserve_, 
                                         qty_picked_               => 0, 
                                         qty_shipped_              => 0,
                                         input_qty_                => local_input_qty_, 
                                         input_unit_meas_          => input_unit_meas_, 
                                         input_conv_factor_        => input_conv_factor_, 
                                         input_variable_values_    => local_input_var_val_, 
                                         preliminary_pick_list_no_ => NULL, 
                                         catch_qty_                => catch_qty_,
                                         pick_by_choice_blocked_   => pick_by_choice_blocked_);
   END IF;

   new_qty_assigned_ := old_qty_assigned_ + total_qty_to_reserve_;
END Reserve_Cust_Ord_Manually___;


-- Modify_Cost_After_Reserve___
--   Modify the cost after the reservation process.
PROCEDURE Modify_Cost_After_Reserve___ (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
   inventory_value_ NUMBER;
   line_cost_       NUMBER;
   total_cost_      NUMBER := 0;
   new_cost_        NUMBER;
   total_quantity_  NUMBER := 0;
   condition_code_  VARCHAR2(10);

   CURSOR get_reserved_lines IS
      SELECT serial_no, lot_batch_no, qty_assigned
      FROM customer_order_reservation_tab
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   IF (Customer_Order_Line_API.Get_Part_Ownership_Db(order_no_, line_no_, rel_no_, line_item_no_) = Part_Ownership_API.DB_COMPANY_RENTAL_ASSET) THEN
 	 	new_cost_ := 0;
   ELSE
      FOR reserved_line IN get_reserved_lines LOOP
         inventory_value_ := Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method(contract_,
                                                                                        part_no_,
                                                                                        configuration_id_,
                                                                                        reserved_line.lot_batch_no,
                                                                                        reserved_line.serial_no);
         line_cost_       := inventory_value_ * reserved_line.qty_assigned;
         total_cost_      := total_cost_ + line_cost_;
         total_quantity_  := total_quantity_ + reserved_line.qty_assigned;
      END LOOP;
      IF total_quantity_ = 0 THEN
         condition_code_ := Customer_Order_Line_API.Get_Condition_Code(order_no_, line_no_, rel_no_, line_item_no_);
         new_cost_       := Inventory_Part_Cost_API.Get_Cost(contract_, part_no_, configuration_id_, condition_code_);
      ELSE
         new_cost_ := total_cost_/total_quantity_;
      END IF;
   END IF;
   Sales_Cost_Util_API.Modify_Cost_Incl_Sales_Oh (order_no_, line_no_, rel_no_, line_item_no_, new_cost_, 'ORDER');
END Modify_Cost_After_Reserve___;

PROCEDURE Modify_Cost_After_Reserve___(
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   old_qty_assigned_ IN NUMBER,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2 )
IS
   cust_ord_line_rec_   Customer_Order_Line_API.Public_Rec;
   old_line_total_cost_ NUMBER := 0;
   inventory_value_     NUMBER := 0;
   new_total_cost_      NUMBER := 0;
   new_cost_            NUMBER := 0;
BEGIN
   cust_ord_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   IF (cust_ord_line_rec_.part_ownership = Part_Ownership_API.DB_COMPANY_RENTAL_ASSET) THEN
      new_cost_ := 0;  
 	ELSE   
      -- qty_assigned is equal to 0 when whole customer order line unreserved. In such situation customer order line should update with inventory part cost.
      IF (cust_ord_line_rec_.qty_assigned = 0) THEN
         new_cost_ := Inventory_Part_Cost_API.Get_Cost( cust_ord_line_rec_.contract, cust_ord_line_rec_.part_no, cust_ord_line_rec_.configuration_id, cust_ord_line_rec_.condition_code);
      ELSE
         -- If there are already reserved part, then calculate the line cost before adding new cost to existing cost.
         IF (old_qty_assigned_ > 0 ) THEN
            old_line_total_cost_ := cust_ord_line_rec_.cost * old_qty_assigned_;
         END IF;

         -- Retrieve the new cost for the part.
         inventory_value_ := Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method(cust_ord_line_rec_.contract,
                                                                                        cust_ord_line_rec_.part_no,
                                                                                        cust_ord_line_rec_.configuration_id,
                                                                                        lot_batch_no_,
                                                                                        serial_no_);
         -- Calculate total cost for newly assigned parts.
         new_total_cost_ := inventory_value_ * (cust_ord_line_rec_.qty_assigned - old_qty_assigned_);
         -- Calculate cost for all assigned reservations.
         new_cost_ := (old_line_total_cost_ + new_total_cost_) /cust_ord_line_rec_.qty_assigned;
      END IF;
   END IF;
   Sales_Cost_Util_API.Modify_Cost_Incl_Sales_Oh (order_no_, line_no_, rel_no_, line_item_no_, new_cost_, 'ORDER');
END Modify_Cost_After_Reserve___;

-- Create_Arrival_Reservations___
--   Creates the reservations for the things received from either purchasing or
--   manufacturing. Also used in the Capability Check process when a CC-customer
--   order lines is released and the interim order reservations are moved to the
--   customer order line
PROCEDURE Create_Arrival_Reservations___ (
   qty_to_assign_    IN NUMBER,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   line_rec_         IN Customer_Order_Line_API.Public_Rec)
IS
   qty_assigned_              NUMBER;
   my_pick_list_no_           customer_order_reservation_tab.pick_list_no%TYPE := '*';
   my_configuration_id_       customer_order_reservation_tab.configuration_id%TYPE;
   res_exists_                NUMBER;
   catch_quantity_            NUMBER := NULL;
   shipment_to_reserve_       NUMBER := 0;
   shipment_qty_to_assign_    NUMBER := 0;
   qty_to_split_per_shipment_ NUMBER := 0;
   reservation_qty_           NUMBER := 0;
   total_qty_assigned_        NUMBER := 0;   
   inv_part_cost_level_       VARCHAR2(50);

BEGIN
   IF configuration_id_ IS NULL THEN
      my_configuration_id_ := line_rec_.configuration_id;
   ELSIF configuration_id_ != line_rec_.configuration_id THEN
      Error_Sys.Record_General(lu_name_,
                               'WRONGCFG: The configuration of the part, :P1 does not match the ordered one on order :P2',
                               part_no_, order_no_ );
   ELSE
      my_configuration_id_ := configuration_id_;
   END IF;

   IF (qty_to_assign_ > 0) THEN
      total_qty_assigned_ := line_rec_.qty_assigned + qty_to_assign_;

      -- Create reservation in InventoryPartLocation
      Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_     => catch_quantity_, 
                                               contract_           => contract_, 
                                               part_no_            => part_no_, 
                                               configuration_id_   => my_configuration_id_, 
                                               location_no_        => location_no_, 
                                               lot_batch_no_       => lot_batch_no_,
                                               serial_no_          => serial_no_, 
                                               eng_chg_level_      => eng_chg_level_, 
                                               waiv_dev_rej_no_    => waiv_dev_rej_no_, 
                                               activity_seq_       => NVL(activity_seq_,0), 
                                               handling_unit_id_   => handling_unit_id_,
                                               quantity_           => qty_to_assign_);

      qty_to_split_per_shipment_ := qty_to_assign_;

      LOOP
         -- Reserve for shipment lines(if any) 
         Shipment_Order_Utility_API.Get_Shipment_To_Reserve(shipment_qty_to_assign_ => shipment_qty_to_assign_ ,
                                                            shipment_id_            => shipment_to_reserve_,
                                                            order_no_               => order_no_,
                                                            line_no_                => line_no_,
                                                            rel_no_                 => rel_no_, 
                                                            line_item_no_           => line_item_no_,
                                                            consume_pegging_        => 'TRUE');

         IF (NVL(shipment_qty_to_assign_, 0) = 0) THEN
            -- reservation for the order line without shipment
            reservation_qty_ := qty_to_split_per_shipment_;
         ELSE
            IF (qty_to_split_per_shipment_ >= shipment_qty_to_assign_) THEN
               reservation_qty_ := shipment_qty_to_assign_;
            ELSE
               reservation_qty_ := qty_to_split_per_shipment_;
            END IF;
         END IF;

         res_exists_ := Customer_Order_Reservation_API.Oe_Exist(order_no_           => order_no_, 
                                                                line_no_            => line_no_, 
                                                                rel_no_             => rel_no_, 
                                                                line_item_no_       => line_item_no_,
                                                                contract_           => contract_, 
                                                                part_no_            => part_no_, 
                                                                location_no_        => location_no_, 
                                                                lot_batch_no_       => lot_batch_no_,
                                                                serial_no_          => serial_no_, 
                                                                eng_chg_level_      => eng_chg_level_, 
                                                                waiv_dev_rej_no_    => waiv_dev_rej_no_, 
                                                                activity_seq_       => NVL(activity_seq_,0),
                                                                handling_unit_id_   => handling_unit_id_,
                                                                pick_list_no_       => my_pick_list_no_, 
                                                                configuration_id_   => my_configuration_id_, 
                                                                shipment_id_        => shipment_to_reserve_);
         
         IF (res_exists_ = 1) THEN
            -- Update qty_assigned on the existing CustomerOrderReservation record
            qty_assigned_ := Customer_Order_Reservation_API.Get_Qty_Assigned(order_no_          => order_no_, 
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
                                                                             activity_seq_      => NVL(activity_seq_,0),
                                                                             handling_unit_id_  => handling_unit_id_,
                                                                             configuration_id_  => my_configuration_id_, 
                                                                             pick_list_no_      => my_pick_list_no_, 
                                                                             shipment_id_       => shipment_to_reserve_);
   
            qty_assigned_ := qty_assigned_ + reservation_qty_;
            Customer_Order_Reservation_API.Modify_Qty_Assigned(order_no_              => order_no_, 
                                                               line_no_               => line_no_, 
                                                               rel_no_                => rel_no_, 
                                                               line_item_no_          => line_item_no_,
                                                               contract_              => contract_, 
                                                               part_no_               => part_no_, 
                                                               location_no_           => location_no_, 
                                                               lot_batch_no_          => lot_batch_no_,
                                                               serial_no_             => serial_no_, 
                                                               eng_chg_level_         => eng_chg_level_, 
                                                               waiv_dev_rej_no_       => waiv_dev_rej_no_, 
                                                               activity_seq_          => NVL(activity_seq_,0),
                                                               handling_unit_id_      => handling_unit_id_,
                                                               pick_list_no_          => my_pick_list_no_, 
                                                               configuration_id_      => my_configuration_id_, 
                                                               shipment_id_           => shipment_to_reserve_,
                                                               qty_assigned_          => qty_assigned_, 
                                                               input_qty_             => NULL,
                                                               input_unit_meas_       => NULL,
                                                               input_conv_factor_     => NULL,
                                                               input_variable_values_ => NULL);
         ELSE
            -- Create a new CustomerOrderReservation record
            qty_assigned_ := reservation_qty_;
            Customer_Order_Reservation_API.New(order_no_                 => order_no_, 
                                               line_no_                  => line_no_, 
                                               rel_no_                   => rel_no_, 
                                               line_item_no_             => line_item_no_,
                                               contract_                 => contract_, 
                                               part_no_                  => part_no_, 
                                               location_no_              => location_no_, 
                                               lot_batch_no_             => lot_batch_no_,
                                               serial_no_                => serial_no_, 
                                               eng_chg_level_            => eng_chg_level_, 
                                               waiv_dev_rej_no_          => waiv_dev_rej_no_, 
                                               activity_seq_             => NVL(activity_seq_,0),
                                               handling_unit_id_         => handling_unit_id_,
                                               pick_list_no_             => my_pick_list_no_, 
                                               configuration_id_         => my_configuration_id_, 
                                               shipment_id_              => shipment_to_reserve_,
                                               qty_assigned_             => qty_assigned_, 
                                               qty_picked_               => 0, 
                                               qty_shipped_              => 0, 
                                               input_qty_                => NULL,
                                               input_unit_meas_          => NULL,
                                               input_conv_factor_        => NULL,
                                               input_variable_values_    => NULL,
                                               preliminary_pick_list_no_ => NULL, 
                                               catch_qty_                => catch_quantity_);
         END IF;

         qty_to_split_per_shipment_ := qty_to_split_per_shipment_ - reservation_qty_ ;
         EXIT WHEN (qty_to_split_per_shipment_ = 0);
      END LOOP;

      Customer_Order_API.Set_Line_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_, total_qty_assigned_);

      inv_part_cost_level_ := Inventory_Part_API.Get_Invent_Part_Cost_Level_Db( contract_, part_no_ );
      IF (inv_part_cost_level_ = 'COST PER LOT BATCH') OR (inv_part_cost_level_ = 'COST PER SERIAL') THEN
         Modify_Cost_After_Reserve___(order_no_, line_no_, rel_no_, line_item_no_, line_rec_.qty_assigned, lot_batch_no_, serial_no_);
      END IF;
   END IF;
END Create_Arrival_Reservations___;


-- Reserve_Package_Components___
--   Reserves a customer order line component without considering the
--   full package quantity
PROCEDURE Reserve_Package_Components___ (
   order_no_    IN VARCHAR2,
   line_no_     IN VARCHAR2,
   rel_no_      IN VARCHAR2,
   shipment_id_ IN NUMBER )
IS
   CURSOR package_curs IS
      SELECT line_item_no, supply_code,
             (revised_qty_due - qty_assigned - qty_shipped + qty_shipdiff - qty_to_ship - qty_on_order) qty_rest
        FROM customer_order_line_tab
       WHERE order_no = order_no_
         AND line_no  = line_no_
         AND rel_no   = rel_no_
         AND line_item_no > 0
         AND rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
         AND (((revised_qty_due - qty_assigned - qty_shipped) > 0 AND
               supply_code IN ('IO','PS'))
             OR ((revised_qty_due - qty_to_ship - qty_shipped) > 0 AND
                 supply_code = 'NO'))
        ORDER BY line_item_no;

   TYPE  Pkg_Comps_Tab IS TABLE OF package_curs%ROWTYPE
   INDEX BY PLS_INTEGER;
   package_part_   Pkg_Comps_Tab;
      
   qty_reserved_ NUMBER;  
BEGIN
   IF (shipment_id_ = 0) THEN
      OPEN package_curs;
      FETCH package_curs BULK COLLECT INTO package_part_;
      CLOSE package_curs;
      IF (package_part_.count > 0) THEN
         FOR i IN package_part_.FIRST .. package_part_.LAST LOOP
            IF (package_part_(i).qty_rest  > 0 ) THEN
               IF (package_part_(i).supply_code = 'NO') THEN
                  Reserve_Non_Inventory___(order_no_, line_no_, rel_no_, package_part_(i).line_item_no, package_part_(i).qty_rest, 0);
               ELSE
                  Reserve_Inventory___(qty_reserved_, order_no_, line_no_, rel_no_, package_part_(i).line_item_no, package_part_(i).qty_rest, 0);
               END IF;
            END IF;
         END LOOP;
      END IF;
   ELSE
      Reserve_Shipment_Pkg_Comp___(order_no_, line_no_, rel_no_, shipment_id_);  
   END IF;

   IF (Package_Partially_Reserved(order_no_, line_no_, rel_no_) = 'TRUE') THEN
      Customer_Order_Shortage_API.New(order_no_, line_no_, rel_no_, -1, 'PLANPICK11');
   END IF;
END Reserve_Package_Components___;


PROCEDURE Reserve_Shipment_Pkg_Comp___ (
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   shipment_id_            IN NUMBER )
IS
   CURSOR ship_con_pkg_comp IS
      SELECT a.source_ref4, b.supply_code, (a.inventory_qty - a.qty_assigned - a.qty_to_ship) qty_rest
        FROM shipment_line_pub a, customer_order_line_tab b 
       WHERE a.shipment_id = shipment_id_
         AND NVL(a.source_ref1, string_null_) = order_no_
         AND NVL(a.source_ref2, string_null_) = line_no_
         AND NVL(a.source_ref3, string_null_) = rel_no_
         AND (Utility_SYS.String_To_Number(a.source_ref4) > 0)
         AND NVL(a.source_ref1, string_null_) = b.order_no
         AND NVL(a.source_ref2, string_null_) = b.line_no
         AND NVL(a.source_ref3, string_null_) = b.rel_no
         AND NVL(a.source_ref4, string_null_) = b.line_item_no
         AND (b.supply_code IN ('IO', 'PS', 'PI', 'NO', 'PRJ')) 
         AND a.source_ref_type_db = 'CUSTOMER_ORDER'
         AND ((a.inventory_qty - a.qty_assigned - a.qty_to_ship - a.qty_shipped) > 0) 
         AND (b.revised_qty_due - b.qty_assigned - b.qty_to_ship - b.qty_shipped + b.qty_shipdiff > 0)
      ORDER BY  b.line_item_no;
   
   qty_reserved_ NUMBER;   
BEGIN
   FOR ship_con_pkg_comp_ IN ship_con_pkg_comp LOOP
      IF (ship_con_pkg_comp_.supply_code = 'NO') THEN
         Reserve_Non_Inventory___(order_no_, line_no_, rel_no_, ship_con_pkg_comp_.source_ref4, ship_con_pkg_comp_.qty_rest, shipment_id_);
      ELSE 
         Reserve_Inventory___(qty_reserved_, order_no_, line_no_, rel_no_, ship_con_pkg_comp_.source_ref4, NULL, shipment_id_);                             
      END IF;
   END LOOP;          
END Reserve_Shipment_Pkg_Comp___;

-- Handle_Project_Reservations___
--   This will handle reservation of customer order line that connected with project.
PROCEDURE Handle_Project_Reservations___ (
   try_to_reserve_again_       OUT BOOLEAN,
   activity_seq_            IN OUT NUMBER,
   project_id_              IN     VARCHAR2 )  
IS
   material_allocation_ VARCHAR2(30);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      material_allocation_ := Project_API.Get_Material_Allocation_Db(project_id_);
   $END
   
   IF material_allocation_ IN ('WITHIN_ACTIVITY','WITHIN_PROJECT') THEN
      -- If the material_allocation_ is 'WITHIN_PROJECT' its find parts from any location and reserve
      -- within project regardless of activity.
      -- otherwise its fine and reserve from that activity.
      IF material_allocation_ = 'WITHIN_PROJECT' THEN
         activity_seq_ := NULL;  -- send null to reserve from any activity
      END IF;
      try_to_reserve_again_ := TRUE;
   ELSE
      try_to_reserve_again_ := FALSE;
   END IF;

END Handle_Project_Reservations___;

FUNCTION Get_Expiration_Control_Date___ (
   planned_delivery_date_   IN DATE,
   today_                   IN DATE,
   min_durab_days_co_deliv_ IN NUMBER,
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   rel_no_                  IN VARCHAR2,
   line_item_no_            IN NUMBER,
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2 ) RETURN DATE
IS
   expiration_control_date_ DATE;
   min_durab_days_          NUMBER;
   catalog_no_              SALES_PART_TAB.catalog_no%TYPE;
BEGIN
   catalog_no_ := Sales_Part_API.Get_Catalog_No_For_Part_No(contract_, part_no_);   
   min_durab_days_ := NVL(Sales_Part_Cross_Reference_API.Get_Min_Durab_Days_For_Catalog(Customer_Order_Line_API.Get_Deliver_To_Customer_No(order_no_,line_no_,rel_no_,line_item_no_),contract_,catalog_no_), min_durab_days_co_deliv_);
   IF (min_durab_days_ IS NOT NULL) THEN
      IF (planned_delivery_date_ > today_) THEN
         expiration_control_date_ := planned_delivery_date_ + min_durab_days_;
      ELSE
         expiration_control_date_ := today_ + min_durab_days_;
      END IF;
   END IF;
   RETURN (expiration_control_date_);
END Get_Expiration_Control_Date___;


-- Check_Release_For_Mtrl_plan___
--   Raise an error message upon reserving if the specified order line has
--   rel_mtrl_planning false.
PROCEDURE Check_Release_For_Mtrl_plan___ (
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2,
   rel_no_   IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
   reservation_info_ VARCHAR2(1000) := NULL;
   order_line_info_  VARCHAR2(100) := NULL;
BEGIN
   order_line_info_  := order_no_ ||' '|| line_no_ ||' '|| rel_no_;
   reservation_info_ := Language_SYS.Translate_Constant(lu_name_, 'NOTRELMTRLPLN: Reservations could not be made for part :P1 on order line :P2 since the Release for Mtrl Planning check box is not selected.',
                                                        NULL, part_no_, order_line_info_);
   IF (Transaction_SYS.Is_Session_Deferred) THEN
      Transaction_SYS.Set_Status_Info(reservation_info_);
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOTRELMTRLPLN: Reservations could not be made for part :P1 on order line :P2 since the Release for Mtrl Planning check box is not selected.', part_no_, order_line_info_);
   END IF;
END Check_Release_For_Mtrl_plan___;


PROCEDURE Update_License_Coverage_Qty___(
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   quantity_     IN NUMBER )
IS
BEGIN
   IF (Customer_Order_Flow_API.Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN 
      $IF Component_Expctr_SYS.INSTALLED $THEN
         DECLARE
            action_ VARCHAR2(20) := 'Reserve';
         BEGIN
            Exp_License_Connect_Util_API.Update_Coverage_Quantities(action_, order_no_, line_no_, rel_no_, line_item_no_, quantity_);
         END;
      $ELSE
         NULL;
      $END
   END IF;
END Update_License_Coverage_Qty___;


PROCEDURE Check_Export_Controlled___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER)
IS
BEGIN
   IF (Customer_Order_Flow_API.Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN     
      $IF Component_Expctr_SYS.INSTALLED $THEN
         DECLARE
            licensed_order_type_ VARCHAR2(25);
            line_rec_            Customer_Order_Line_API.Public_Rec;
         BEGIN
            line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
            licensed_order_type_ := Customer_Order_Line_API.Get_Expctr_License_Order_Type(line_rec_.demand_code, line_rec_.demand_order_ref1, line_rec_.demand_order_ref2, line_rec_.demand_order_ref3);
            Exp_License_Connect_Util_API.Check_Order_Proceed_Allowed(order_no_, line_no_, rel_no_, line_item_no_, licensed_order_type_);
         END;     
      $ELSE
         NULL;
      $END
   END IF;
END Check_Export_Controlled___;


-- Check_Before_Reserve___
--   If the CO line gets changed, when a manual reservation window is opened from a different session
--   wrong values will be reserved to the co line. This method will stop it by raising an error.
PROCEDURE Check_Before_Reserve___ (
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,   
   part_ownership_ IN VARCHAR2,
   owner_          IN VARCHAR2,
   condition_code_ IN VARCHAR2)
IS
   co_line_rec_       Customer_Order_Line_API.Public_Rec;
   raise_error_       BOOLEAN := FALSE;   
   part_ownership_db_ VARCHAR2(20);
   co_line_owner_     VARCHAR2(20);
   confirm_del_       VARCHAR2(5);
BEGIN
   co_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   IF (part_ownership_ IS NOT NULL) THEN
      part_ownership_db_ := Part_Ownership_API.Encode(part_ownership_);
      CASE co_line_rec_.part_ownership
         WHEN 'COMPANY OWNED' THEN
            confirm_del_ := Customer_Order_API.Get_Confirm_Deliveries_Db(order_no_);
            IF (confirm_del_ = 'TRUE' OR co_line_rec_.consignment_stock = 'CONSIGNMENT STOCK') THEN
               IF (part_ownership_db_ != 'COMPANY OWNED') THEN
                  raise_error_ := TRUE;            
               END IF;
            ELSE
               IF (part_ownership_db_ NOT IN ('COMPANY OWNED', 'CONSIGNMENT')) THEN
                  raise_error_ := TRUE;
               END IF;
            END IF;
         WHEN 'COMPANY RENTAL ASSET' THEN
            IF (part_ownership_db_ NOT IN ('COMPANY RENTAL ASSET', 'SUPPLIER RENTED')) THEN
               raise_error_ := TRUE;
            END IF;
         WHEN 'SUPPLIER RENTED' THEN
            IF (part_ownership_db_ != 'SUPPLIER RENTED' ) THEN
               raise_error_ := TRUE;
            END IF;            
         WHEN 'CUSTOMER OWNED' THEN
            co_line_owner_ := co_line_rec_.owning_customer_no;
            IF ((part_ownership_db_ != 'CUSTOMER OWNED') OR (owner_ != co_line_owner_)) THEN
               raise_error_ := TRUE;         
            END IF;
         WHEN 'SUPPLIER LOANED' THEN
            co_line_owner_ := Customer_Order_Line_API.Get_Owner_For_Part_Ownership(order_no_, line_no_, rel_no_, line_item_no_, co_line_rec_.part_ownership);   
            IF ((part_ownership_db_ != 'SUPPLIER LOANED') OR (owner_ != co_line_owner_ )) THEN
               raise_error_ := TRUE;         
            END IF;
      END CASE;
   END IF;
   
   IF (condition_code_ IS NOT NULL AND NOT raise_error_) THEN
      IF (Validate_SYS.Is_Changed(condition_code_, co_line_rec_.condition_code)) THEN
         raise_error_ := TRUE;  
      END IF;
   END IF;
      
   IF raise_error_ THEN
      Error_SYS.Record_General(lu_name_, 'NOTALLOWTORESERVE: The parts you are going to reserve do not match with those of the customer order. This can be due to a discrepancy between customer order line ownership, owner, condition code or delivery confirmation indicator of the customer order header.');
   END IF;
END Check_Before_Reserve___;

PROCEDURE Raise_Reservation_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'RESERVENOTALLOWED: Reservations cannot be made for Customer Order Lines which are in the Delivered or Invoiced/Closed state.');
END Raise_Reservation_Error___;

PROCEDURE Raise_Wrong_Loc_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'WRONGLOCTYPE: It should not  be allowed to reserve parts that is placed on a floor stock location ');
END Raise_Wrong_Loc_Error___;

PROCEDURE Raise_Qty_Reservation_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'DONTREDUCEQTYRES: Quantity reserved cannot be reduced. The reservation has already been updated or deleted.');
END Raise_Qty_Reservation_Error___;

PROCEDURE Raise_Part_Reserve_Error___(
   part_no_                 IN VARCHAR2,
   availability_control_id_ IN VARCHAR2)
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'AVAILIDMANRES: Part :P1 with Availability Control ID :P2 cannot be manually reserved.', part_no_, availability_control_id_);
END Raise_Part_Reserve_Error___;

FUNCTION Man_Res_Valid_Ext_Service___(
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   order_line_rec_      IN Customer_Order_Line_API.Public_Rec ) RETURN VARCHAR2
IS
   order_code_             CUSTOMER_ORDER_LINE_TAB.order_code%TYPE;
   exchange_item_db_       CUSTOMER_ORDER_LINE_TAB.exchange_item%TYPE;   
   sales_part_no_          VARCHAR2(25);
   po_serial_no_           VARCHAR2(50);
   po_lot_batch_no_        VARCHAR2(20);
   service_type_           VARCHAR2(20);   
   part_catalog_rec_       Part_Catalog_API.Public_Rec;   
   result_                 VARCHAR2(5) := 'FALSE';   
BEGIN  
   IF (order_line_rec_.demand_code = 'PO') THEN
      
      $IF Component_Purch_SYS.INSTALLED $THEN
         order_code_ := Purchase_Order_API.Get_Order_Code(Customer_Order_Line_API.Get_Purchase_Order_No(order_no_,
                                                                                                        line_no_,
                                                                                                        rel_no_,
                                                                                                        line_item_no_));

         sales_part_no_ := Sales_Part_API.Get_Purchase_Part_No(order_line_rec_.contract, 
                                                               order_line_rec_.catalog_no);

         Pur_Ord_Charged_Comp_API.Get_Serial_Lot_Service_Type(po_lot_batch_no_,
                                                              po_serial_no_,
                                                              service_type_,
                                                              order_no_,
                                                              line_no_,
                                                              rel_no_,
                                                              line_item_no_,
                                                              sales_part_no_);
      $END
      exchange_item_db_ := order_line_rec_.exchange_item;
      
      IF (exchange_item_db_ != 'EXCHANGE ITEM' AND order_code_ = '6') THEN
         part_catalog_rec_ := Part_Catalog_API.Get(order_line_rec_.catalog_no);
         
         IF ( part_catalog_rec_.eng_serial_tracking_code = 'SERIAL TRACKING' OR 
              part_catalog_rec_.serial_tracking_code = 'SERIAL TRACKING' )THEN 
            IF (po_serial_no_ IS NOT NULL) THEN
               IF (po_serial_no_ = serial_no_) THEN
                  result_ := 'TRUE';
               END IF;
            END IF;
         ELSIF (part_catalog_rec_.lot_tracking_code = 'LOT TRACKING') THEN              
               IF (po_lot_batch_no_ IS NOT NULL) THEN
                  IF (po_lot_batch_no_ = lot_batch_no_) THEN
                     result_ := 'TRUE';
                  END IF;
               END IF;
         ELSE
            -- normal parts
            result_ := 'TRUE';         
         END IF;
      ELSE
         result_ := 'TRUE';
      END IF;
   ELSE
      result_ := 'TRUE';
   END IF;   
   RETURN result_;
END Man_Res_Valid_Ext_Service___;

FUNCTION Man_Res_Valid_Ownership___(
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN VARCHAR2,
   part_ownership_db_   IN VARCHAR2,
   owning_customer_no_  IN VARCHAR2,
   owning_vendor_no_    IN VARCHAR2,
   order_line_rec_      IN Customer_Order_Line_API.Public_Rec ) RETURN VARCHAR2
IS
   co_owner_            CUSTOMER_ORDER_LINE_TAB.customer_no%TYPE;
   confirm_deliveries_  CUSTOMER_ORDER_TAB.confirm_deliveries%TYPE;
   result_  VARCHAR2(5) := 'FALSE';
BEGIN
   IF order_line_rec_.part_ownership IN ('CUSTOMER OWNED', 'SUPPLIER LOANED') THEN
      co_owner_ := Customer_Order_Line_API.Get_Owner_For_Part_Ownership(order_no_,
                                                                        line_no_,
                                                                        rel_no_,
                                                                        line_item_no_,
                                                                        order_line_rec_.part_ownership);
   END IF;
   CASE order_line_rec_.part_ownership
      WHEN 'COMPANY OWNED' THEN
         confirm_deliveries_ := Customer_Order_API.Get_Confirm_Deliveries(order_no_);
      
         IF ((confirm_deliveries_ = 'TRUE' OR order_line_rec_.consignment_stock = 'CONSIGNMENT STOCK')) THEN
            IF (part_ownership_db_ = 'COMPANY OWNED') THEN
               result_ := 'TRUE';
            END IF;
         ELSIF (part_ownership_db_ IN ('COMPANY OWNED', 'CONSIGNMENT')) THEN
            result_ := 'TRUE';
         END IF;
      
      WHEN 'CUSTOMER OWNED' THEN
         IF (part_ownership_db_ = 'CUSTOMER OWNED' AND co_owner_ = owning_customer_no_) THEN
            result_ := 'TRUE';
         END IF;
         
      WHEN 'SUPPLIER LOANED' THEN
         IF (part_ownership_db_ = 'SUPPLIER LOANED' AND co_owner_ = owning_vendor_no_) THEN
            result_ := 'TRUE';
         END IF;
         
      WHEN 'COMPANY RENTAL ASSET' THEN
         IF (order_line_rec_.rental = 'TRUE') THEN
            IF (part_ownership_db_ IN ('COMPANY RENTAL ASSET', 'SUPPLIER RENTED')) THEN
               result_ := 'TRUE';
            END IF;
         ELSIF (part_ownership_db_ = 'COMPANY RENTAL ASSET') THEN
            result_ := 'TRUE';
         END IF;
         
      WHEN 'SUPPLIER RENTED' THEN
         IF (part_ownership_db_ = 'SUPPLIER RENTED') THEN
            result_ := 'TRUE';
         END IF;
         
      ELSE
         result_ := 'TRUE';
   END CASE;
   
   RETURN result_;
END Man_Res_Valid_Ownership___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
-- Reserve_Order__
--   Reserves an entire order.
--   Called from the order flow when the reservation step should be
--   automatically executed.
PROCEDURE Reserve_Order__ (
   order_no_ IN VARCHAR2 )
IS   
   planned_due_date_ DATE;
   order_rec_        Customer_Order_API.Public_Rec;
   exit_from_reserving_      BOOLEAN := FALSE;
   backorder_        BOOLEAN;
BEGIN
   -- Do a credit check before reservations are made
   Customer_Order_Flow_API.Credit_Check_Order(order_no_, 'PICK_PROPOSAL');

   IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') THEN
      order_rec_ := Customer_Order_API.Get(order_no_);
      -- Make reservations for all order lines
      -- Try to reserve the entire order, no due dates should be considered
      planned_due_date_ := Database_Sys.last_calendar_date_;
      Reserve_Lines___(exit_from_reserving_, order_no_, planned_due_date_,'%','%','%','%','%','%','%', 'FALSE');
      
      IF (exit_from_reserving_) THEN
         IF (order_rec_.backorder_option = 'NO PARTIAL DELIVERIES ALLOWED') THEN
            -- If whole order shall be picked, perform check so all lines are available.
            -- If backorder would be generated shortage records will be created.
            backorder_ := Backorder_Generated___(order_no_);
         END IF;
         RETURN;
      END IF;
   END IF;
END Reserve_Order__;


-- Reserve_Order_Line__
--   Reserves the order_line.
PROCEDURE Reserve_Order_Line__ (
   qty_reserved_             OUT NUMBER,
   order_no_                 IN  VARCHAR2,
   line_no_                  IN  VARCHAR2,
   rel_no_                   IN  VARCHAR2,
   line_item_no_             IN  NUMBER,
   qty_to_be_reserved_       IN  NUMBER,
   shipment_id_              IN  NUMBER,
   set_shortage_             IN  BOOLEAN  DEFAULT TRUE,
   location_no_              IN  VARCHAR2 DEFAULT NULL,
   lot_batch_no_             IN  VARCHAR2 DEFAULT NULL,
   serial_no_                IN  VARCHAR2 DEFAULT NULL,
   eng_chg_level_            IN  VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_          IN  VARCHAR2 DEFAULT NULL,
   activity_seq_             IN  NUMBER   DEFAULT NULL,
   handling_unit_id_         IN  NUMBER   DEFAULT NULL,
   pick_list_no_             IN  VARCHAR2 DEFAULT '*',
   reservation_operation_id_ IN  NUMBER   DEFAULT NULL )
IS
   qty_short_              NUMBER := 0;   
   reserve_qty_            NUMBER;
   qty_possible_to_assign_ NUMBER;
   inv_part_cost_level_    VARCHAR2(50);
   pkg_qty_picked_         NUMBER;
   pkg_qty_to_pick_        NUMBER;
   pkg_qty_to_finish_      NUMBER;   
   qty_rest_               NUMBER;
   
   CURSOR get_line IS
      SELECT ROWID objid, contract, part_no, revised_qty_due, qty_assigned, qty_shipped, qty_on_order,
             (revised_qty_due - qty_assigned - qty_shipped - qty_on_order) qty_to_reserve, configuration_id, activity_seq,
             supply_code, catalog_type, qty_to_ship
      FROM  customer_order_line_tab
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_;

   linerec_  get_line%ROWTYPE;
   
   CURSOR get_shipment_qty_to_reserev IS
      SELECT LEAST((sol.inventory_qty - sol.qty_assigned), 
                   (col.revised_qty_due - col.qty_assigned - col.qty_shipped + col.qty_shipdiff - col.qty_on_order)) shipment_qty_to_reserve
      FROM   shipment_line_pub sol, customer_order_line_tab col
      WHERE  NVL(sol.source_ref1, string_null_) = order_no_
      AND    NVL(sol.source_ref2, string_null_) = line_no_
      AND    NVL(sol.source_ref3, string_null_) = rel_no_
      AND    NVL(sol.source_ref4, string_null_) = line_item_no_
      AND    sol.shipment_id  = shipment_id_
      AND    NVL(sol.source_ref1, string_null_) = col.order_no
      AND    NVL(sol.source_ref2, string_null_) = col.line_no
      AND    NVL(sol.source_ref3, string_null_) = col.rel_no
      AND    NVL(sol.source_ref4, string_null_) = col.line_item_no
      AND    source_ref_type_db = 'CUSTOMER_ORDER'
      AND    (col.revised_qty_due - col.qty_assigned - col.qty_shipped + col.qty_shipdiff - col.qty_on_order > 0);
BEGIN
   IF Customer_Order_Shortage_API.Check_Exist(order_no_, line_no_, rel_no_, line_item_no_) THEN
      -- Remove previous shortage record if any
      Customer_Order_Shortage_API.Remove(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   
   OPEN  get_line;
   FETCH get_line INTO linerec_;
   CLOSE get_line;

   IF (NVL(reservation_operation_id_, -1) = Inv_Part_Stock_Reservation_API.pick_by_choice_) THEN
      reserve_qty_ := qty_to_be_reserved_;
   ELSIF (qty_to_be_reserved_ IS NOT NULL AND location_no_ IS NULL) THEN
      reserve_qty_ := LEAST(qty_to_be_reserved_,  linerec_.qty_to_reserve);
   ELSIF (qty_to_be_reserved_ IS NOT NULL AND location_no_ IS NOT NULL) THEN
      reserve_qty_ := qty_to_be_reserved_;
   ELSE
      IF (NVL(shipment_id_, 0) = 0) THEN
         reserve_qty_ := linerec_.qty_to_reserve;
      ELSE
         OPEN  get_shipment_qty_to_reserev;
         FETCH get_shipment_qty_to_reserev INTO reserve_qty_;
         CLOSE get_shipment_qty_to_reserev;
      END IF;
   END IF;
   
   IF (reserve_qty_ > 0) THEN
      IF ((linerec_.supply_code IN ('NO', 'SEO', 'PRJ')) OR (linerec_.supply_code IN ('PT', 'IPT') AND linerec_.catalog_type = 'NON')) THEN
         qty_rest_ := linerec_.qty_to_reserve - linerec_.qty_to_ship;
         Reserve_Non_Inventory___(order_no_, line_no_, rel_no_, line_item_no_, qty_rest_, shipment_id_);
      ELSE     
         -- Try to reserve parts on line.  
         Reserve_Line_At_Location___(qty_possible_to_assign_, qty_reserved_, linerec_.objid, order_no_,
                                     line_no_, rel_no_, line_item_no_, NULL, linerec_.contract,
                                     linerec_.part_no, reserve_qty_, 'NormalReservation', shipment_id_, location_no_,
                                     lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, pick_list_no_);
         IF qty_reserved_ != 0 THEN
            Customer_Order_API.Set_Line_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_, (linerec_.qty_assigned + qty_reserved_)); 
         END IF;
      END IF;
   END IF;
   
   IF(set_shortage_) THEN
      -- Calculate the qty short for Inventory shortage demand.
      qty_short_ := Shortage_Demand_API.Calculate_Order_Shortage_Qty(linerec_.contract,
                                                                     linerec_.part_no,
                                                                     linerec_.revised_qty_due,
                                                                     (linerec_.qty_assigned + NVL(qty_reserved_, 0)),
                                                                     (linerec_.qty_shipped + linerec_.qty_on_order));
      Customer_Order_Line_API.Set_Qty_Short(order_no_, line_no_, rel_no_, line_item_no_, qty_short_);
   END IF;
   
   -- only modify cost if there were reservations made and nothing have been delivered yet
   IF (qty_reserved_ > 0 AND linerec_.qty_shipped = 0) THEN
      --Note: Fetching and updating cost details of order lines when reserved.
      inv_part_cost_level_ := Inventory_Part_API.Get_Invent_Part_Cost_Level_Db(linerec_.contract, linerec_.part_no);
      IF (inv_part_cost_level_ = 'COST PER LOT BATCH') OR (inv_part_cost_level_ = 'COST PER SERIAL') THEN
         Modify_Cost_After_Reserve___(order_no_, line_no_, rel_no_, line_item_no_, linerec_.contract, linerec_.part_no, linerec_.configuration_id);
      END IF;
   END IF;
   
   IF ((line_item_no_ > 0) AND Customer_Order_Shortage_API.Check_Exist(order_no_, line_no_, rel_no_, -1)) THEN
      -- Check if reservations have been made for the entire package
      Check_Reserve_Package___(pkg_qty_picked_, pkg_qty_to_pick_, pkg_qty_to_finish_, order_no_, line_no_, rel_no_);
      IF (pkg_qty_to_finish_ = 0) AND (pkg_qty_to_pick_ = 0) THEN
         -- The whole package was picked, remove shortage record.
         Customer_Order_Shortage_API.Remove(order_no_, line_no_, rel_no_, -1);
      END IF;
   END IF;
END Reserve_Order_Line__;


-- Create_Supply_Site_Reserve__
--   Creates Supply Site Reservations, both normal and sourced.
PROCEDURE Create_Supply_Site_Reserve__ (
   reservations_made_  OUT NUMBER,
   order_no_           IN  VARCHAR2,
   line_no_            IN  VARCHAR2,
   rel_no_             IN  VARCHAR2,
   line_item_no_       IN  NUMBER,
   source_id_          IN  NUMBER,
   qty_to_be_reserved_ IN  NUMBER )
IS
   qty_assigned_                NUMBER := 0;   
   reserve_qty_                 NUMBER;
   qty_possible_to_assign_      NUMBER;
   supply_site_                 VARCHAR2(5);
   qty_assigned_on_supply_site_ NUMBER := 0;
   supply_site_uom_revised_qty_ NUMBER := 0;
   supply_site_uom_qty_shipped_ NUMBER := 0;
   supply_site_uom_sourced_qty_ NUMBER := 0;

   CURSOR get_line IS
      SELECT ROWID objid, contract, part_no, revised_qty_due, qty_shipped,
             supply_code, vendor_no, release_planning, purchase_part_no, supply_site, rental
      FROM  customer_order_line_tab
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;

   linerec_  get_line%ROWTYPE;

   CURSOR get_sourced_line IS
      SELECT ROWID objid, sourced_qty, supply_code, vendor_no, supply_site
      FROM  sourced_cust_order_line_tab
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      AND   source_id = source_id_;

   sourcerec_  get_sourced_line%ROWTYPE;
BEGIN
   OPEN  get_line;
   FETCH get_line INTO linerec_;
   CLOSE get_line;

   IF (source_id_ IS NOT NULL) THEN
      OPEN  get_sourced_line;
      FETCH get_sourced_line INTO sourcerec_;
      CLOSE get_sourced_line;

      qty_assigned_on_supply_site_ := Sourced_Co_Supply_Site_Res_API.Get_Qty_Reserved(order_no_, line_no_, rel_no_, line_item_no_, source_id_);
      -- convert the demand site inv uom quantities to supply site inv uom
      supply_site_uom_sourced_qty_ := Inventory_Part_API.Get_Site_Converted_Qty(linerec_.contract,linerec_.part_no,sourcerec_.supply_site, sourcerec_.sourced_qty,'ADD');
      supply_site_uom_qty_shipped_ := Inventory_Part_API.Get_Site_Converted_Qty(linerec_.contract,linerec_.part_no,sourcerec_.supply_site, linerec_.qty_shipped,'REMOVE');
   ELSE
      qty_assigned_on_supply_site_ := Co_Supply_Site_Reservation_API.Get_Qty_Reserved(order_no_, line_no_, rel_no_, line_item_no_);
      -- convert the demand site inv uom quantities to supply site inv uom
      supply_site_uom_revised_qty_ := Inventory_Part_API.Get_Site_Converted_Qty(linerec_.contract,linerec_.part_no,linerec_.supply_site, linerec_.revised_qty_due,'ADD');
      supply_site_uom_qty_shipped_ := Inventory_Part_API.Get_Site_Converted_Qty(linerec_.contract,linerec_.part_no,linerec_.supply_site, linerec_.qty_shipped,'REMOVE');
   END IF;

   IF (qty_to_be_reserved_ IS NOT NULL) THEN
      reserve_qty_ := qty_to_be_reserved_;
   ELSE
      IF (source_id_ IS NULL) THEN
         reserve_qty_ := supply_site_uom_revised_qty_ - qty_assigned_on_supply_site_ - supply_site_uom_qty_shipped_;
      ELSE
         reserve_qty_ := supply_site_uom_sourced_qty_ - qty_assigned_on_supply_site_ - supply_site_uom_qty_shipped_;
      END IF;
   END IF;

   IF (reserve_qty_ > 0) THEN
      -- Try to reserve parts on line.
      -- supply chain reservation (sending supply_site as contract)
      IF (source_id_ IS NULL) THEN   -- supply chain reservation
         supply_site_ := Customer_Order_Line_API.Get_Vendor_Contract__(linerec_.vendor_no, NULL, NULL, NULL, linerec_.rental);
         Reserve_Line_At_Location___(qty_possible_to_assign_, qty_assigned_, linerec_.objid, order_no_,
                                     line_no_, rel_no_, line_item_no_, source_id_, supply_site_,
                                     NVL(linerec_.part_no, linerec_.purchase_part_no), reserve_qty_,
                                     'SupplyChainReservation', 0);
      ELSE   -- sourced supply chain reservation
         supply_site_ := Customer_Order_Line_API.Get_Vendor_Contract__(sourcerec_.vendor_no, NULL, NULL, NULL, linerec_.rental);
         -- if supply_site is null it might be a local site reservation instead, so use COL contract instead
         Reserve_Line_At_Location___(qty_possible_to_assign_, qty_assigned_, sourcerec_.objid, order_no_,
                                     line_no_, rel_no_, line_item_no_, source_id_, NVL(supply_site_,linerec_.contract),
                                     NVL(linerec_.part_no, linerec_.purchase_part_no), reserve_qty_,
                                     'SupplyChainReservation', 0);
      END IF;
   END IF;

   IF (qty_assigned_ > 0) THEN
      reservations_made_ := 1;
   ELSE
      reservations_made_ := 0;
   END IF;
END Create_Supply_Site_Reserve__;


-- Unpicked_Reservations_Exist__
--   Returns 1 if any reservations not picked are made on order_line.
--   Returns 0 otherwise.
@UncheckedAccess
FUNCTION Unpicked_Reservations_Exist__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   exist_ NUMBER;

   CURSOR reservations_exist IS
      SELECT 1
      FROM   customer_order_reservation_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    qty_assigned > 0
      AND    qty_picked = 0;
BEGIN
   OPEN  reservations_exist;
   FETCH reservations_exist INTO exist_;
   IF (reservations_exist%NOTFOUND) THEN
      exist_ := 0;
   END IF;
   CLOSE reservations_exist;
   RETURN exist_;
END Unpicked_Reservations_Exist__;


-- Line_Reservations_Exist__
--   Returns 1 if any reservations exist for the order_line.
--   Returns 0 otherwise.
@UncheckedAccess
FUNCTION Line_Reservations_Exist__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   exist_ NUMBER;

   CURSOR reservations_exist IS
      SELECT 1
      FROM   customer_order_reservation_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    qty_assigned > 0;
BEGIN
   OPEN reservations_exist;
   FETCH reservations_exist INTO exist_;
   IF (reservations_exist%NOTFOUND) THEN
      exist_ := 0;
   END IF;
   CLOSE reservations_exist;
   RETURN exist_;
END Line_Reservations_Exist__;


-- Entire_Order_Reserved__
--   Check if physical reservations exist for every order line
--   for an order
@UncheckedAccess
FUNCTION Entire_Order_Reserved__ (
   order_no_                   IN VARCHAR2,
   shipment_creation_on_pick_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_    NUMBER;
   reserved_ BOOLEAN;

   CURSOR check_pick_reservation IS
      SELECT 1
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND    line_item_no >= 0
      AND    part_no IS NOT NULL
      AND    supply_code IN ('IO','PS', 'PT', 'IPT', 'SO', 'PI', 'DOP') -- Added supply code filter to avoid PD, IPD supply for the inventory sales part.
      AND   ( revised_qty_due - qty_assigned - ( qty_shipped - qty_shipdiff ) )> 0;

   CURSOR check_reservation IS
      SELECT 1
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND    line_item_no >= 0
      AND    (((revised_qty_due - qty_assigned - ( qty_shipped - qty_shipdiff)) > 0  AND supply_code IN ('IO', 'PI', 'PJD')) OR
              ((revised_qty_due - qty_to_ship - ( qty_shipped - qty_shipdiff)) > 0 AND supply_code IN ('NO','PRJ', 'SEO')) OR
              ((revised_qty_due - qty_assigned - qty_to_ship - ( qty_shipped - qty_shipdiff)) > qty_on_order  AND supply_code IN ('PT', 'IPT', 'SO', 'DOP', 'PD', 'IPD')));
BEGIN
   IF ( shipment_creation_on_pick_ = Fnd_Boolean_API.DB_FALSE ) THEN
      OPEN check_reservation;
      FETCH check_reservation INTO dummy_;
      reserved_ := check_reservation%NOTFOUND;
      CLOSE check_reservation;
   ELSE
      OPEN check_pick_reservation;
      FETCH check_pick_reservation INTO dummy_;
      reserved_ := check_pick_reservation%NOTFOUND;
      CLOSE check_pick_reservation;
   END IF;
   RETURN reserved_;
END Entire_Order_Reserved__;



-- Create_Priority_Reservation__
--   Check if priority reservations should be made for an order line.
--   If so then try to make the reservations needed.
PROCEDURE Create_Priority_Reservation__ (
   qty_assigned_    IN OUT NUMBER,
   contract_        IN     VARCHAR2,
   part_no_         IN     VARCHAR2,
   order_no_        IN     VARCHAR2,
   line_no_         IN     VARCHAR2,
   rel_no_          IN     VARCHAR2,
   line_item_no_    IN     NUMBER,
   revised_qty_due_ IN     NUMBER,
   qty_shipped_     IN     NUMBER,
   supply_code_db_  IN     VARCHAR2,
   objid_           IN     VARCHAR2 )
IS
   new_qty_assigned_    NUMBER := 0;
   alloc_assign_flag_   VARCHAR2(200);
   qty_to_assign_       NUMBER;
   qty_possible_        NUMBER;
   catalog_no_          VARCHAR2(25);
   substitute_part_     BOOLEAN;
   po_line_no_          VARCHAR2(4);
   po_rel_no_           VARCHAR2(4);
   orig_order_no_       VARCHAR2(12);
   orig_line_no_        VARCHAR2(4);
   orig_rel_no_         VARCHAR2(4);
   orig_line_item_no_   NUMBER;
   ssr_qty_reserved_    NUMBER := 0;
   headrec_             Customer_Order_API.Public_Rec;   
   inv_part_cost_level_ VARCHAR2(50);
   configuration_id_    VARCHAR2(50);   

   $IF Component_Purch_SYS.INSTALLED $THEN
      poline_ Purchase_Order_Line_API.Public_Rec;
   $END 
BEGIN
   IF (supply_code_db_ = 'IO') THEN
      -- Init_Method moved here so we do not see this method while tracing unnecessary
      headrec_ := Customer_Order_API.Get(order_no_);
      $IF Component_Purch_SYS.INSTALLED $THEN
         IF (headrec_.internal_po_no IS NOT NULL) THEN 
            po_line_no_ := line_no_;  -- for an internal order the CO and PO line_no are the same
            po_rel_no_  := rel_no_;   -- for an internal order the CO and PO rel_no are the same
            -- get the originating order line keys
            poline_     := Purchase_Order_Line_API.Get(headrec_.internal_po_no, po_line_no_, po_rel_no_);
            IF (poline_.demand_code IN ('ICD', 'ICT')) THEN
               orig_order_no_     := poline_.demand_order_no;
               orig_line_no_      := poline_.demand_release;
               orig_rel_no_       := poline_.demand_sequence_no;
               orig_line_item_no_ := Purchase_Order_Line_API.Get_Demand_Operation_No(headrec_.internal_po_no, po_line_no_, po_rel_no_);
            END IF;
            -- get supply_site_reservation qty
            ssr_qty_reserved_ := Co_Supply_Site_Reservation_API.Get_Qty_Reserved(orig_order_no_, orig_line_no_, orig_rel_no_, orig_line_item_no_);
         END IF;
      $END
      
      alloc_assign_flag_ := Inventory_Part_API.Get_Oe_Alloc_Assign_Flag(contract_, part_no_);
      IF (alloc_assign_flag_ = Cust_Ord_Reservation_Type_API.Decode('N')) THEN
         alloc_assign_flag_ := Cust_Order_Type_API.Get_Oe_Alloc_Assign_Flag(Customer_Order_API.Get_Order_Id(order_no_));
      END IF;

      IF (alloc_assign_flag_ = Cust_Ord_Reservation_Type_API.Decode('Y')) THEN
         IF (Inventory_Part_API.Get_Forecast_Consump_Flag_Db(contract_, part_no_) = 'NOFORECAST') THEN
            qty_to_assign_ := (revised_qty_due_ - qty_assigned_ - ssr_qty_reserved_-  qty_shipped_);
            IF (qty_to_assign_ > 0) THEN
               Trace_SYS.Message('Quantity > 0. Reserving...');
   
               Reserve_Line_At_Location___(qty_possible_, new_qty_assigned_, NVL(objid_, 'ROWID'),
                                           order_no_, line_no_, rel_no_, line_item_no_, NULL,
                                           contract_, part_no_, qty_to_assign_, 'NormalReservation', 0);   
               IF (new_qty_assigned_ < qty_to_assign_) THEN
                  --Check if there is a substitute part.
                  catalog_no_      := Customer_Order_Line_API.Get_Catalog_No(order_no_, line_no_, rel_no_, line_item_no_);
                  substitute_part_ := Substitute_Sales_Part_API.Check_Substitute_Part_Exist(contract_, catalog_no_, NULL);
                  Trace_SYS.Field('substitute_part_', substitute_part_);
   
                  --Check if there is a substitute part
                  IF substitute_part_ THEN
                        Error_SYS.Record_General(lu_name_, 'NO_ASSIGN_PART: Only :P1 of the requested sales part, :P2 is available. Check Substitute Sales part.', qty_possible_, part_no_);                                     
                  ELSE
                     Error_SYS.Record_General(lu_name_, 'NO_ASSIGN_PART1: Only :P1 of the requested sales part, :P2 is available. Part cannot be added to customer order due to priority reservation usage.', qty_possible_, part_no_);
                  END IF;
               ELSE
                  qty_assigned_ := qty_assigned_ + new_qty_assigned_;
                  Customer_Order_API.Set_Line_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_, qty_assigned_);
               END IF;
            END IF;
               
            inv_part_cost_level_ := Inventory_Part_API.Get_Invent_Part_Cost_Level_Db( contract_, part_no_ );
            IF (inv_part_cost_level_ = 'COST PER LOT BATCH') OR (inv_part_cost_level_ = 'COST PER SERIAL') THEN
               configuration_id_ := Customer_Order_Line_API.Get_Configuration_Id(order_no_, line_no_, rel_no_, line_item_no_ );
               Modify_Cost_After_Reserve___( order_no_, line_no_, rel_no_, line_item_no_, contract_, part_no_, configuration_id_ );
            END IF;   
         END IF;
      END IF;
   END IF;
END Create_Priority_Reservation__;


-- Create_Instant_Reservation__
--   Creates instant reservation if possible for both order line reservations
--   and sourced reservation.
PROCEDURE Create_Instant_Reservation__ (
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   line_item_no_    IN NUMBER,
   source_id_       IN NUMBER,
   part_no_         IN VARCHAR2,
   revised_qty_due_ IN NUMBER,
   qty_shipped_     IN NUMBER,
   objid_           IN VARCHAR2,
   vendor_no_       IN VARCHAR2 )
IS
   line_rec_                     Customer_Order_Line_API.Public_Rec;   
   new_qty_assigned_             NUMBER := 0;
   qty_assigned_                 NUMBER := 0;
   qty_possible_to_assign_       NUMBER;
   supply_site_                  VARCHAR2(5);
   supply_site_uom_revised_qty_  NUMBER := 0;
   supply_site_uom_qty_shipped_  NUMBER := 0;
   demand_site_qty_possible_     NUMBER := 0;
   demand_site_qty_possible_str_ VARCHAR2(100); 
   inv_part_cost_level_          VARCHAR2(50);
BEGIN
   IF (source_id_ IS NULL) THEN
      qty_assigned_ := Co_Supply_Site_Reservation_API.Get_Qty_Reserved(order_no_, line_no_, rel_no_, line_item_no_);
   ELSE
      qty_assigned_ := Sourced_Co_Supply_Site_Res_API.Get_Qty_Reserved(order_no_, line_no_, rel_no_, line_item_no_, source_id_);
   END IF;

   line_rec_    := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   supply_site_ := Customer_Order_Line_API.Get_Vendor_Contract__(vendor_no_, NULL, NULL, NULL, line_rec_.rental);

   -- convert the demand site inv uom quantities to supply site inv uom
   supply_site_uom_revised_qty_ := Inventory_Part_API.Get_Site_Converted_Qty(line_rec_.contract,part_no_,supply_site_,revised_qty_due_,'ADD');
   supply_site_uom_qty_shipped_ := Inventory_Part_API.Get_Site_Converted_Qty(line_rec_.contract,part_no_,supply_site_,qty_shipped_,'REMOVE');

   -- No Instant Reservations allowed when the online consumption ticked.
   IF (Inventory_Part_API.Get_Forecast_Consump_Flag_Db(supply_site_, part_no_) = 'NOFORECAST') THEN
      IF ((supply_site_uom_revised_qty_ - qty_assigned_ - supply_site_uom_qty_shipped_) > 0) THEN
         Trace_SYS.Message('Quantity > 0. Reserving...');

         -- supply chain reservation (sending supply_site as contract)
         Reserve_Line_At_Location___(qty_possible_to_assign_, new_qty_assigned_, NVL(objid_, 'ROWID'),
                                     order_no_, line_no_, rel_no_, line_item_no_, source_id_,
                                     supply_site_, part_no_,
                                     supply_site_uom_revised_qty_ - qty_assigned_ - supply_site_uom_qty_shipped_,
                                     'SupplyChainReservation', 0);

         inv_part_cost_level_ := Inventory_Part_API.Get_Invent_Part_Cost_Level_Db( supply_site_, part_no_ );
         IF (inv_part_cost_level_ = 'COST PER LOT BATCH') OR (inv_part_cost_level_ = 'COST PER SERIAL') THEN
            Modify_Cost_After_Reserve___( order_no_, line_no_, rel_no_, line_item_no_, supply_site_, part_no_, line_rec_.configuration_id );
         END IF;

         -- error message if not enough quantity was available to reserve, if its a sourced reservation
         -- we change the reservation flag to MANUAL instead (this done in LU SourceOrderLines)
         IF (new_qty_assigned_ < (supply_site_uom_revised_qty_ - qty_assigned_ - supply_site_uom_qty_shipped_) AND source_id_ IS NULL) THEN
            demand_site_qty_possible_     := Inventory_Part_API.Get_Site_Converted_Qty(supply_site_,part_no_,line_rec_.contract,qty_possible_to_assign_,'REMOVE');
            demand_site_qty_possible_str_ := TO_CHAR(demand_site_qty_possible_) || ' ' || Inventory_Part_API.Get_Unit_Meas(line_rec_.contract, part_no_);
            Error_SYS.Record_General(lu_name_, 'NO_ASSIGN_PART3: Only :P1 of the requested sales part :P2 is available. Part cannot be added to customer order due to instant reservation usage between sites.', demand_site_qty_possible_str_, part_no_);
         END IF;
      END IF;
   END IF;
END Create_Instant_Reservation__;


-- Batch_Reserve_Orders__
--   Starts pickplan for all orders. The parameters are stored in
--   the "attr_" cause this method is started in batch.
PROCEDURE Batch_Reserve_Orders__ (
   attr_ IN VARCHAR2)
IS
   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);
   description_               VARCHAR2(200);
   fair_share_reservation_db_ VARCHAR2(5) := 'FALSE';
   contract_                  VARCHAR2(30);
   new_attr_                  VARCHAR2(32000);
   old_attr_                  VARCHAR2(32000);

   CURSOR get_batch_sites IS
      SELECT DISTINCT contract
      FROM CUSTOMER_ORDER_TAB
      WHERE contract LIKE NVL(contract_, '%')
      AND   EXISTS (SELECT 1 FROM user_allowed_site_pub
                    WHERE contract = site);

   TYPE Sites_Tab IS TABLE OF get_batch_sites%ROWTYPE
   INDEX BY PLS_INTEGER;
   next_site_                Sites_Tab;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, new_attr_);
      END IF;
   END LOOP;
   old_attr_ := new_attr_;
   OPEN get_batch_sites;
   FETCH get_batch_sites BULK COLLECT INTO next_site_;
   CLOSE get_batch_sites;

   IF (next_site_.count > 0) THEN
      FOR i IN next_site_.FIRST .. next_site_.LAST LOOP
         fair_share_reservation_db_ := Site_Discom_Info_API.Get_Fair_Share_Reservation_Db(next_site_(i).contract);
         Client_SYS.Add_To_Attr('FAIR_SHARE_RESERVATION_DB', fair_share_reservation_db_, new_attr_);
         Client_SYS.Add_To_Attr('CONTRACT', next_site_(i).contract, new_attr_);

         IF fair_share_reservation_db_ = 'TRUE' THEN
            -- One background job should be created for the fair share reservation for a site.
            description_ := Language_SYS.Translate_Constant(lu_name_, 'FAIR_SHARE_ORDERS: Create Fair Share Reservation for Customer Orders');
            Transaction_SYS.Deferred_Call('RESERVE_CUSTOMER_ORDER_API.Reserve_Batch_Orders__', new_attr_, description_);
         ELSE
            -- One background job should be created for the reservations for a site.           
            description_ := Language_SYS.Translate_Constant(lu_name_, 'PICK_ORDERS: Create Reservations for Customer Order');
            Transaction_SYS.Deferred_Call('RESERVE_CUSTOMER_ORDER_API.Reserve_Batch_Orders__', new_attr_, description_);
         END IF;
         new_attr_ := old_attr_;
      END LOOP;
   END IF;
END Batch_Reserve_Orders__;


-- Make_Additional_Reservations__
--   Creates another reservation on specified picklist.
--   (Picklist created).
PROCEDURE Make_Additional_Reservations__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   pick_list_no_ IN VARCHAR2,
   shipment_id_  IN NUMBER,
   attr_         IN VARCHAR2 )
IS
   location_no_             customer_order_reservation_tab.location_no%TYPE;
   lot_batch_no_            customer_order_reservation_tab.lot_batch_no%TYPE;
   serial_no_               customer_order_reservation_tab.serial_no%TYPE;
   waiv_dev_rej_no_         customer_order_reservation_tab.waiv_dev_rej_no%TYPE;
   eng_chg_level_           customer_order_reservation_tab.eng_chg_level%TYPE;
   activity_seq_            customer_order_reservation_tab.activity_seq%TYPE;
   handling_unit_id_        customer_order_reservation_tab.handling_unit_id%TYPE;
   input_qty_               customer_order_reservation_tab.input_qty%TYPE;
   input_conv_factor_       customer_order_reservation_tab.input_conv_factor%TYPE;
   input_unit_meas_         customer_order_reservation_tab.input_unit_meas%TYPE;
   input_variable_values_   customer_order_reservation_tab.input_variable_values%TYPE;
   qty_to_reserve_          NUMBER;
   ptr_                     NUMBER := NULL;
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(2000);
BEGIN
   IF (Customer_Order_Pick_List_API.Get_Picking_Confirmed_Db(pick_list_no_) = 'PICKED') THEN
      Error_SYS.Record_General(lu_name_, 'ALREADYPICKED: The pick list :P1 has already been pick reported.', pick_list_no_);
   END IF;

   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Trace_SYS.Message('*************name_: ' || name_ || ', value_: ' || value_);
      IF (name_ = 'LOCATION_NO') THEN
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
      ELSIF (name_ = 'QTY_TO_RESERVE') THEN
         qty_to_reserve_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'INPUT_QUANTITY') THEN
         input_qty_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'INPUT_CONV_FACTOR') THEN
         input_conv_factor_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'INPUT_UNIT_MEAS') THEN
         input_unit_meas_ := value_;
      ELSIF (name_ = 'INPUT_VARIABLE_VALUES') THEN
         input_variable_values_ := value_;

         -- Create new reservations.   
         -- Reserve in inventory.         
         -- Reserve single
         Make_Additional_Reservation___(order_no_, 
                                        line_no_, 
                                        rel_no_, 
                                        line_item_no_, 
                                        location_no_, 
                                        lot_batch_no_, 
                                        serial_no_, 
                                        waiv_dev_rej_no_, 
                                        eng_chg_level_, 
                                        activity_seq_, 
                                        handling_unit_id_, 
                                        input_qty_, 
                                        input_conv_factor_, 
                                        input_unit_meas_, 
                                        input_variable_values_, 
                                        qty_to_reserve_, 
                                        pick_list_no_, 
                                        shipment_id_);
      END IF;
   END LOOP;
END Make_Additional_Reservations__;


-- Reserve_Customer_Order__
--   Pick plans an entire order.
PROCEDURE Reserve_Customer_Order__ (
   attr_ IN VARCHAR2 )
IS
   order_no_               CUSTOMER_ORDER.order_no%TYPE;
   order_id_               CUSTOMER_ORDER.order_id%TYPE;
   planned_due_date_       DATE;
   deliver_to_customer_no_ VARCHAR2(20);
   delivery_address_       VARCHAR2(50);
   route_id_               VARCHAR2(12);
   forward_agent_id_       VARCHAR2(20);
   part_no_                VARCHAR2(25);
   ship_via_               VARCHAR2(3);
   sequence_no_            NUMBER;  
   catalog_type_db_        VARCHAR2(4);
   batch_reserve_shipment_ VARCHAR2(5);
BEGIN
   order_no_               := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
   order_id_               := Client_SYS.Get_Item_Value('ORDER_ID', attr_);
   planned_due_date_       := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('PLANNED_DUE_DATE', attr_));
   deliver_to_customer_no_ := Client_SYS.Get_Item_Value('DELIVER_TO_CUSTOMER_NO', attr_);
   delivery_address_       := Client_SYS.Get_Item_Value('DELIVERY_ADDRESS', attr_);
   route_id_               := Client_SYS.Get_Item_Value('ROUTE_ID', attr_);
   forward_agent_id_       := Client_SYS.Get_Item_Value('FORWARD_AGENT_ID', attr_);
   part_no_                := Client_SYS.Get_Item_Value('PART_NO', attr_);
   ship_via_               := Client_SYS.Get_Item_Value('SHIP_VIA', attr_);
   sequence_no_            := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SEQUENCE_NO', attr_));
   catalog_type_db_        := Client_SYS.Get_Item_Value('CATALOG_TYPE_DB', attr_);
   batch_reserve_shipment_ := Client_SYS.Get_Item_Value('BATCH_RESERVE_SHIPMENT', attr_);
   
   Reserve_Order___(order_no_, order_id_, planned_due_date_, part_no_, ship_via_,
                    deliver_to_customer_no_, delivery_address_, route_id_, forward_agent_id_, sequence_no_, catalog_type_db_, batch_reserve_shipment_);
END Reserve_Customer_Order__;


-- Reserve_Manually_Impl__
--   Created reservations for picklist = '*'
--   For a normal reservation, contract_ = demand site/first CO
--   For a supply chain reservation, contract_ = supply site/second CO
--   For normal reservation or ordinary supply chain reservation, source_id = NULL
--   For sourced supply chain reservation, source_id != NULL
PROCEDURE Reserve_Manually_Impl__ (
   info_                     OUT VARCHAR2,
   state_                    OUT VARCHAR2,
   order_no_                 IN  VARCHAR2,
   line_no_                  IN  VARCHAR2,
   rel_no_                   IN  VARCHAR2,
   line_item_no_             IN  NUMBER,
   source_id_                IN  NUMBER,
   contract_                 IN  VARCHAR2,
   part_no_                  IN  VARCHAR2,
   location_no_              IN  VARCHAR2,
   lot_batch_no_             IN  VARCHAR2,
   serial_no_                IN  VARCHAR2,
   eng_chg_level_            IN  VARCHAR2,
   waiv_dev_rej_no_          IN  VARCHAR2,
   activity_seq_             IN  NUMBER,
   handling_unit_id_         IN  NUMBER,
   qty_to_reserve_           IN  NUMBER,
   input_qty_                IN  NUMBER,
   input_unit_meas_          IN  VARCHAR2,
   input_conv_factor_        IN  NUMBER,
   input_variable_values_    IN  VARCHAR2,
   shipment_id_              IN  NUMBER,
   part_ownership_           IN  VARCHAR2 DEFAULT NULL,
   owner_                    IN  VARCHAR2 DEFAULT NULL,
   condition_code_           IN  VARCHAR2 DEFAULT NULL,
   pick_list_no_             IN  VARCHAR2 DEFAULT '*',
   reservation_operation_id_ IN  NUMBER   DEFAULT NULL,
   pick_by_choice_blocked_   IN  VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS
   line_rec_                     Customer_Order_Line_API.Public_Rec;
   old_qty_assigned_             NUMBER := 0;
   new_qty_assigned_             NUMBER := 0;
   total_qty_to_reserve_         NUMBER := 0;
   configuration_id_             customer_order_line_tab.configuration_id%TYPE;
   text_                         VARCHAR2(200);   
   availability_control_id_      VARCHAR2(25);
   supply_site_                  VARCHAR2(5);
   demand_site_                  VARCHAR2(5);
   supply_chain_reservation_     NUMBER := 0;
   reseverble_qty_               NUMBER;
   new_qty_on_order_             NUMBER;
   re_order_no_                  VARCHAR2(12);
   re_line_no_                   VARCHAR2(4);
   re_rel_no_                    VARCHAR2(4);
   purch_type_                   VARCHAR2(200);
   no_of_pur_ord_lines_          NUMBER;
   no_of_shop_ord_lines_         NUMBER;
   inv_part_cost_level_          VARCHAR2(50);
   order_qty_assigned_           NUMBER;
   order_revised_qty_due_        NUMBER;
   order_qty_shipped_            NUMBER;
   order_qty_to_resrv_           NUMBER;
   order_open_shipment_qty_      NUMBER;
   pkg_qty_picked_               NUMBER;
   pkg_qty_to_pick_              NUMBER;
   pkg_qty_to_finish_            NUMBER;
   catch_quantity_               NUMBER  := NULL;
   add_hist_log_                 VARCHAR2(5);
   expiration_date_              DATE;
   planned_delivery_date_        DATE;
   min_durab_days_co_deliv_      NUMBER;
   test_date_                    DATE := trunc(Site_API.Get_Site_Date(contract_));
   expiration_control_date_      DATE;
   qty_on_order_                 NUMBER;
   credit_control_group_id_      VARCHAR2(40);
   check_ext_customer_           VARCHAR2(5);
   ext_order_no_                 VARCHAR2(20);
   customer_credit_blocked_      VARCHAR2(25);
   customer_no_                  VARCHAR2(20);
   customer_no_pay_              VARCHAR2(20);
   local_pick_by_choice_blocked_ VARCHAR2(5);
   parent_customer_                VARCHAR2(20);
   attr_credit_                    VARCHAR2(2000);
   
   CURSOR reservation_rec IS
      SELECT revised_qty_due, qty_assigned, qty_shipped, open_shipment_qty
      FROM customer_order_line_tab
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;    
BEGIN
   IF (Customer_Order_Line_API.Get_Objstate(order_no_, line_no_, rel_no_, line_item_no_) IN ('Delivered', 'Invoiced')) THEN
      Raise_Reservation_Error___();   
   END IF;
   
   configuration_id_ := Customer_Order_Line_API.Get_Configuration_Id(order_no_, line_no_, rel_no_, line_item_no_);
   expiration_date_  := Inventory_Part_In_Stock_API.Get_Expiration_Date(contract_         => contract_,
                                                                        part_no_          => part_no_,
                                                                        configuration_id_ => configuration_id_,
                                                                        location_no_      => location_no_,
                                                                        lot_batch_no_     => lot_batch_no_,
                                                                        serial_no_        => serial_no_,
                                                                        eng_chg_level_    => eng_chg_level_,
                                                                        waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                        activity_seq_     => activity_seq_, 
                                                                        handling_unit_id_ => handling_unit_id_); 
   planned_delivery_date_   := Customer_Order_Line_API.Get_Planned_Delivery_Date(order_no_, line_no_, rel_no_, line_item_no_);
   min_durab_days_co_deliv_ := Inventory_Part_API.Get_Min_Durab_Days_Co_Deliv(contract_,part_no_);
   expiration_control_date_ := Get_Expiration_Control_Date___(planned_delivery_date_, test_date_, min_durab_days_co_deliv_, order_no_, line_no_, rel_no_, line_item_no_, contract_, part_no_);

   IF (qty_to_reserve_ > 0 AND expiration_date_ < expiration_control_date_) THEN
      Client_SYS.Add_Info(lu_name_,'PARTWILLEXPIRE: Expiration date will be insufficient at customer order delivery');
      info_ := info_ || Client_Sys.Get_All_Info; 
   END IF;
      
   -- Note: Checking for Manual Peggings
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   IF (line_rec_.demand_code = 'CRE') AND (qty_to_reserve_ > 0) THEN
      Error_SYS.Record_General(lu_name_, 'CROEXCONNECNONEWRES: Customer order line is connected to a CRO Exchange line. New reservations should done from CRO Exchange line.');
   END IF;

   IF (line_rec_.supply_code IN ('IO','PS')) AND (line_rec_.qty_on_order > 0) THEN
      reseverble_qty_ := line_rec_.revised_qty_due - line_rec_.qty_assigned - line_rec_.qty_shipped - line_rec_.qty_on_order;

      IF (qty_to_reserve_ > reseverble_qty_) THEN
         no_of_pur_ord_lines_  := Customer_Order_Pur_Order_API.Get_Connected_Peggings(order_no_, line_no_, rel_no_, line_item_no_);
         no_of_shop_ord_lines_ := Customer_Order_Shop_Order_API.Get_Connected_Peggings(order_no_, line_no_, rel_no_, line_item_no_);

         IF (no_of_pur_ord_lines_ = 1) OR (no_of_shop_ord_lines_ = 1) THEN
            Client_SYS.Add_Info(lu_name_, 'PEG_REDUCE: Manual peggings has been reduced.');
            info_ := info_ || Client_SYS.Get_All_Info;
         END IF;

         IF (no_of_pur_ord_lines_ = 1) AND (no_of_shop_ord_lines_ = 0) THEN
            Customer_Order_Pur_Order_API.Get_Purord_For_Custord(re_order_no_, re_line_no_, re_rel_no_, purch_type_, order_no_, line_no_, rel_no_, line_item_no_);
            new_qty_on_order_ := line_rec_.qty_on_order - (qty_to_reserve_ - reseverble_qty_);
            Peg_Customer_Order_API.Modify_Po_Peg_Qty__(order_no_, line_no_, rel_no_, line_item_no_, re_order_no_, re_line_no_, re_rel_no_, new_qty_on_order_);

         ELSIF (no_of_shop_ord_lines_ = 1) AND (no_of_pur_ord_lines_ = 0) THEN
            Customer_Order_Shop_Order_API.Get_Shop_Order(re_order_no_, re_line_no_, re_rel_no_, order_no_, line_no_, rel_no_, line_item_no_);
            new_qty_on_order_ := line_rec_.qty_on_order - (qty_to_reserve_ - reseverble_qty_);
            Peg_Customer_Order_API.Modify_So_Peg_Qty__(order_no_, line_no_, rel_no_, line_item_no_, re_order_no_, re_line_no_, re_rel_no_, new_qty_on_order_);

         ELSE
            Error_SYS.Record_General(lu_name_, 'REDUCEPEGQTY: Reduce the connected peggings manually to perform the reservation');
         END IF;
      END IF;
   END IF;

   Customer_Order_API.Check_Customer_Credit_Blocked(customer_credit_blocked_, attr_credit_, order_no_, 'FALSE');
   
   IF (customer_credit_blocked_ = 'FALSE') THEN
      credit_control_group_id_ := Cust_Ord_Customer_API.Get_Credit_Control_Group_Id(NVL(Customer_Order_API.Get_Customer_No_Pay(order_no_), Customer_Order_API.Get_Customer_No(order_no_)));
      IF (credit_control_group_id_ IS NOT NULL) THEN
         check_ext_customer_   := Credit_Control_Group_API.Get_Ext_Cust_Crd_Chk_Db(credit_control_group_id_);
      END IF;
   
      IF check_ext_customer_ = 'TRUE' THEN 
         Customer_Order_Line_API.Get_External_Cust_Order(ext_order_no_, order_no_);
         IF ext_order_no_ IS NOT NULL AND ext_order_no_ != order_no_ THEN
            Customer_Order_API.Check_Customer_Credit_Blocked(customer_credit_blocked_, attr_credit_, ext_order_no_);
            IF (customer_credit_blocked_ != 'FALSE') THEN
               customer_no_     := Customer_Order_API.Get_Customer_No(ext_order_no_);
               customer_no_pay_ := Customer_Order_API.Get_Customer_No_Pay(ext_order_no_);   
            END IF;   
         END IF;   
      END IF;
   ELSE
      customer_no_         := Customer_Order_API.Get_Customer_No(order_no_);
      customer_no_pay_     := Customer_Order_API.Get_Customer_No_Pay(order_no_);   
   END IF;
   
   IF Client_SYS.Item_Exist('PARENT_IDENTITY', attr_credit_) THEN
      parent_customer_ := Client_SYS.Get_Item_Value('PARENT_IDENTITY', attr_credit_); 
   END IF;
   

   IF (reservation_operation_id_ IS NULL) OR 
      (reservation_operation_id_ NOT IN (Inv_Part_Stock_Reservation_API.move_reservation_, 
                                         Inv_Part_Stock_Reservation_API.pick_by_choice_, 
                                         Inv_Part_Stock_Reservation_API.unpack_reservation_)) THEN
      -- Added a condition to checked the qty_to_reserve_ in order to allow unreserving
      -- even if the customer is credit blocked. 
      IF (qty_to_reserve_ > 0) THEN 
      -- First make sure the customer is not credit blocked
         CASE (customer_credit_blocked_)
            WHEN 'CUSTOMER_BLOCKED' THEN
               IF parent_customer_ IS NULL  THEN
                  Error_SYS.Record_General(lu_name_, 'NOPICKCUSTCREBLK: The customer :P1 is credit blocked. New reservations not allowed.', customer_no_);
               ELSE
                  Error_SYS.Record_General(lu_name_, 'NOPICKPRCUSTCREBLK: The parent :P1 of the customer is credit blocked. New reservations not allowed.', parent_customer_);
               END IF;
            WHEN 'PAY_CUSTOMER_BLOCKED' THEN
               IF parent_customer_ IS NULL  THEN
                  Error_SYS.Record_General(lu_name_, 'NOPICKPAYCUSTCREBLK: The paying customer :P1 is credit blocked. New reservations not allowed.', customer_no_pay_);
               ELSE
                  Error_SYS.Record_General(lu_name_, 'NOPICKPRPAYCUSTCREBLK: The parent :P1 of the paying customer is credit blocked. New reservations not allowed.', parent_customer_);
               END IF;
            ELSE
               NULL;
         END CASE;
      END IF;
   END IF;
      
   configuration_id_ := Customer_Order_Line_API.Get_Configuration_Id(order_no_, line_no_, rel_no_, line_item_no_);
   
   IF ((qty_to_reserve_ > 0)) THEN
      availability_control_id_ := Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract_         => contract_,
                                                                                          part_no_          => part_no_,
                                                                                          configuration_id_ => configuration_id_,
                                                                                          location_no_      => location_no_,
                                                                                          lot_batch_no_     => lot_batch_no_,
                                                                                          serial_no_        => serial_no_,
                                                                                          eng_chg_level_    => eng_chg_level_,
                                                                                          waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                          activity_seq_     => activity_seq_, 
                                                                                          handling_unit_id_ => handling_unit_id_);

      IF (Part_Availability_Control_API.Check_Man_Reservation_Control(availability_control_id_) != 'MANUAL_RESERV') THEN
         Raise_Part_Reserve_Error___( part_no_, availability_control_id_);
      END IF;
   END IF;
   
   IF (qty_to_reserve_ != 0) THEN      

      -- Reserve/Unreserve single part.
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
   IF (line_rec_.rel_mtrl_planning = 'FALSE') THEN
      Customer_Order_API.Check_Rel_Mtrl_Planning(order_no_, Fnd_Boolean_API.DB_FALSE);         
   END IF;
   END IF;

   -- executes only if customer order is created from a CRO Exchange line and the process unreserves the materials.
   IF (line_rec_.demand_code = 'CRE') AND (qty_to_reserve_ < 0) THEN
      -- The qty_on_order of the CO Line should be increased by the amount unreserved.
      qty_on_order_ := line_rec_.qty_on_order - qty_to_reserve_ ;
      Customer_Order_Line_API.Modify_Qty_On_Order(order_no_, line_no_, rel_no_, line_item_no_, qty_on_order_);

      $IF Component_Cromfg_SYS.INSTALLED $THEN
         Cro_Line_Util_API.Unreserved_In_Co_Line(line_rec_.demand_order_ref1,
                                                 line_rec_.demand_order_ref2,
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
                                                 qty_to_reserve_);
      $ELSE
         NULL;
      $END
   END IF;

   total_qty_to_reserve_ := qty_to_reserve_;   

   Trace_Sys.Field('   new_qty_assigned_',new_qty_assigned_);

   line_rec_                     := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   old_qty_assigned_             := line_rec_.qty_assigned;
   local_pick_by_choice_blocked_ := Customer_Order_Reservation_API.Get_Pick_By_Choice_Blocked_Db(order_no_         => order_no_, 
                                                                                                 line_no_          => line_no_, 
                                                                                                 rel_no_           => rel_no_, 
                                                                                                 line_item_no_     => line_item_no_, 
                                                                                                 contract_         => contract_, 
                                                                                                 part_no_          => part_no_, 
                                                                                                 location_no_      => location_no_, 
                                                                                                 lot_batch_no_     => lot_batch_no_, 
                                                                                                 serial_no_        => serial_no_, 
                                                                                                 eng_chg_level_    => eng_chg_level_, 
                                                                                                 waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                                                                                 activity_seq_     => activity_seq_, 
                                                                                                 handling_unit_id_ => handling_unit_id_, 
                                                                                                 configuration_id_ => configuration_id_, 
                                                                                                 pick_list_no_     => pick_list_no_, 
                                                                                                 shipment_id_      => shipment_id_);
   Trace_SYS.Field('Reserve/Unreserve QTY', total_qty_to_reserve_);
   IF ((total_qty_to_reserve_ != 0) OR (pick_by_choice_blocked_ != local_pick_by_choice_blocked_)) THEN
      supply_site_              := contract_;
      demand_site_              := line_rec_.contract;
      supply_chain_reservation_ := Is_Supply_Chain_Reservation(order_no_, line_no_, rel_no_, line_item_no_, source_id_, NULL);
      IF (supply_chain_reservation_ = 1) AND (supply_site_ != demand_site_) THEN
         IF (source_id_ IS NULL) THEN
            -- Normal Supply chain reservation (calls Co_Supply_Site_Reservation_API methods).
            -- We move the CO reservations to a temporary object (Co_Supply_Site_Reservation)
            -- before a new CO is created on the supply_site, the CO reservations will later be
            -- moved from Co_Supply_Site_Reservation to Customer_Order_Reservation.
            Reserve_Supply_Site_Man___(new_qty_assigned_, order_no_, line_no_, rel_no_, line_item_no_, contract_,
                                       part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_,
                                       waiv_dev_rej_no_, activity_seq_, handling_unit_id_, configuration_id_, 
                                       total_qty_to_reserve_, old_qty_assigned_);
         ELSE
            -- Sourced supply chain reservation (calls Sourced_Co_Supply_Site_Res_API methods).
            -- We move the Sourced CO reservations to a temporary object (Sourced_Co_Supply_Site_Res)
            -- before a new CO is created on the supply_site, the Sourced CO reservations will later be
            -- moved from Sourced_Co_Supply_Site_Res to Co_Supply_Site_Reservation when the sourced line
            -- is converted to customer order line.
            Reserve_Src_Supply_Site_Man___(new_qty_assigned_, order_no_, line_no_, rel_no_, line_item_no_,
                                           source_id_, contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                                           eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, configuration_id_,
                                           total_qty_to_reserve_, old_qty_assigned_);
         END IF;
      ELSIF (supply_site_ = demand_site_) AND (source_id_ IS NOT NULL) THEN
         -- Sourced Local Site Reservation  (Inventory Order)
         -- This will also be saved on the temporary source reservation object (Sourced_Co_Supply_Site_Res)
         -- and later be moved to Customer_Order_Reservation when the sourced line is transfered to a CO line
         Reserve_Src_Supply_Site_Man___(new_qty_assigned_, order_no_, line_no_, rel_no_, line_item_no_,
                                        source_id_, contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                                        eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, configuration_id_,
                                        total_qty_to_reserve_, old_qty_assigned_);
      ELSE
         -- Normal reservation (calls  Customer_Order_Reservation_API methods)
         Reserve_Cust_Ord_Manually___(new_qty_assigned_, order_no_, line_no_, rel_no_, line_item_no_, contract_,
                                      part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_,
                                      waiv_dev_rej_no_, configuration_id_, pick_list_no_,
                                      activity_seq_, handling_unit_id_, total_qty_to_reserve_, old_qty_assigned_ , catch_quantity_,
                                      input_qty_, input_unit_meas_, input_conv_factor_, input_variable_values_, shipment_id_, 
                                      reservation_operation_id_, pick_by_choice_blocked_);
         IF (supply_chain_reservation_ = 0 OR source_id_ IS NULL) THEN
            add_hist_log_ := 'FALSE';
         END IF;
         Customer_Order_API.Set_Line_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_, new_qty_assigned_, add_hist_log_);
      END IF;

      Trace_Sys.Field('   new_qty_assigned_',new_qty_assigned_);
      Trace_Sys.Field('   old_qty_assigned_',old_qty_assigned_);
      Trace_Sys.Field('   total_qty_to_reserve_',total_qty_to_reserve_);

      text_ := NULL;
      IF (reservation_operation_id_ IS NULL OR reservation_operation_id_ NOT IN (Inv_Part_Stock_Reservation_API.move_reservation_, 
                                                                                 Inv_Part_Stock_Reservation_API.unpack_reservation_)) THEN
         IF (new_qty_assigned_ > old_qty_assigned_) THEN
            IF (supply_chain_reservation_ = 0) THEN
               text_ := Language_SYS.Translate_Constant(lu_name_, 'MANRESERVED: :P1 :P2 Manually reserved.', NULL,
                                                        to_char(new_qty_assigned_ - old_qty_assigned_), Inventory_Part_API.Get_Unit_Meas(contract_, part_no_));
            ELSIF (source_id_ IS NULL) THEN
               text_ := Language_SYS.Translate_Constant(lu_name_, 'MANRESERVEDSUPP: :P1 :P2 Manually reserved on site :P3.', NULL,
                                                        to_char(Inventory_Part_API.Get_Site_Converted_Qty(supply_site_,part_no_,demand_site_, new_qty_assigned_ - old_qty_assigned_,'ADD')),
                                                        Inventory_Part_API.Get_Unit_Meas(demand_site_, part_no_), supply_site_);
            END IF;
         ELSE
            IF (supply_chain_reservation_ = 0) THEN
               text_ := Language_SYS.Translate_Constant(lu_name_, 'MANUNRESERVED: :P1 :P2 Manually unreserved.', NULL,
                                                        to_char(old_qty_assigned_ - new_qty_assigned_), Inventory_Part_API.Get_Unit_Meas(contract_, part_no_));
            ELSIF (source_id_ IS NULL) THEN
               text_ := Language_SYS.Translate_Constant(lu_name_, 'MANUNRESERVEDSUPP: :P1 :P2 Manually unreserved on site :P3.', NULL,
                                                        to_char(Inventory_Part_API.Get_Site_Converted_Qty(supply_site_,part_no_,demand_site_, old_qty_assigned_ - new_qty_assigned_,'ADD')),
                                                        Inventory_Part_API.Get_Unit_Meas(demand_site_, part_no_), supply_site_);
            END IF;
         END IF;
      END IF;

      IF (text_ IS NOT NULL) THEN
         Customer_Order_Line_Hist_API.New(order_no_, line_no_, rel_no_, line_item_no_, text_);
      END IF;
   END IF;

   state_ := Customer_Order_Line_API.Get_State(order_no_, line_no_, rel_no_, line_item_no_);

   -- only modify cost if nothing have been delivered yet and its not a supply chain reservation
   IF (line_rec_.qty_shipped = 0 AND supply_chain_reservation_ = 0) THEN
      --Note: Fetching and updating cost details of order lines when reserved.
      inv_part_cost_level_ := Inventory_Part_API.Get_Invent_Part_Cost_Level_Db(contract_, part_no_);
      IF (inv_part_cost_level_ = 'COST PER LOT BATCH') OR (inv_part_cost_level_ = 'COST PER SERIAL') THEN
         Modify_Cost_After_Reserve___(order_no_, line_no_, rel_no_, line_item_no_, old_qty_assigned_, lot_batch_no_, serial_no_);
      END IF;
   END IF;

   OPEN reservation_rec;
   FETCH reservation_rec INTO order_revised_qty_due_, order_qty_assigned_, order_qty_shipped_, order_open_shipment_qty_;
   CLOSE reservation_rec;
   Trace_SYS.Field('**********order_revised_qty_due_', order_revised_qty_due_);
   Trace_SYS.Field('**********order_qty_assigned_', order_qty_assigned_);
   Trace_SYS.Field('**********order_qty_shipped_', order_qty_shipped_);
   Trace_SYS.Field('**********order_open_shipment_qty_', order_open_shipment_qty_);
   
   IF (reservation_operation_id_ IS NULL OR reservation_operation_id_ != Inv_Part_Stock_Reservation_API.unpack_reservation_) THEN
      IF (shipment_id_ = 0) THEN
         IF ((order_revised_qty_due_ - order_qty_assigned_ - order_qty_shipped_ - order_open_shipment_qty_
                + Shipment_Line_API.Get_Sum_Reserved_Line(order_no_, line_no_, rel_no_, line_item_no_,
                                                          Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER)) < 0) THEN
            Error_SYS.Record_General(lu_name_, 'QTYOVERRIDES: Cannot assign more than the required quantity on the order line.');
         END IF;
      ELSE
         IF (Shipment_Line_API.Get_Qty_To_Reserve(shipment_id_, order_no_, line_no_, rel_no_, line_item_no_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) < 0) THEN 
            Error_SYS.Record_General(lu_name_, 'QTYOVERRIDESSHP: Cannot assign more than the required quantity on the shipment line.');
         END IF;
      END IF;
   END IF;
   
   order_qty_to_resrv_ := order_revised_qty_due_ - order_qty_shipped_;
   IF (order_qty_to_resrv_ = order_qty_assigned_) THEN
      IF Customer_Order_Shortage_API.Check_Exist(order_no_, line_no_, rel_no_, line_item_no_) THEN
         Customer_Order_Shortage_API.Remove(order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
      IF ((line_item_no_ > 0) AND Customer_Order_Shortage_API.Check_Exist(order_no_, line_no_, rel_no_, -1)) THEN
         -- Check if reservations have been made for the entire package
         Check_Reserve_Package___(pkg_qty_picked_, pkg_qty_to_pick_, pkg_qty_to_finish_, order_no_, line_no_, rel_no_);
         IF (pkg_qty_to_finish_ = 0) AND (pkg_qty_to_pick_ = 0) THEN
            -- The whole package was picked, remove shortage record.
            Customer_Order_Shortage_API.Remove(order_no_, line_no_, rel_no_, -1);
         END IF;
      END IF;
   END IF;   
   
   Check_Before_Reserve___(order_no_, line_no_, rel_no_, line_item_no_, part_ownership_, owner_, condition_code_);
      
   info_ := info_ || Customer_Order_Line_API.Get_Current_Info || Client_SYS.Get_All_Info;
   Customer_Order_Line_API.Clear_Current_Info();
END Reserve_Manually_Impl__;


-- Reserve_Manually__
--   Created reservations for picklist = '*'
--   For a normal reservation, contract_ = demand site/first CO
--   For a supply chain reservation, contract_ = supply site/second CO
--   For normal reservation or ordinary supply chain reservation, source_id = NULL
--   Created reservations for picklist = '*'

PROCEDURE Reserve_Manually__ (
   info_                     OUT VARCHAR2,
   state_                    OUT VARCHAR2,
   order_no_                 IN  VARCHAR2,
   line_no_                  IN  VARCHAR2,
   rel_no_                   IN  VARCHAR2,
   line_item_no_             IN  NUMBER,
   contract_                 IN  VARCHAR2,
   part_no_                  IN  VARCHAR2,
   location_no_              IN  VARCHAR2,
   lot_batch_no_             IN  VARCHAR2,
   serial_no_                IN  VARCHAR2,
   eng_chg_level_            IN  VARCHAR2,
   waiv_dev_rej_no_          IN  VARCHAR2,
   activity_seq_             IN  NUMBER,
   handling_unit_id_         IN  NUMBER,
   qty_to_reserve_           IN  NUMBER,
   input_qty_                IN  NUMBER,
   input_unit_meas_          IN  VARCHAR2,
   input_conv_factor_        IN  NUMBER,
   input_variable_values_    IN  VARCHAR2,
   shipment_id_              IN  NUMBER,
   part_ownership_           IN  VARCHAR2 DEFAULT NULL,
   owner_                    IN  VARCHAR2 DEFAULT NULL,
   condition_code_           IN  VARCHAR2 DEFAULT NULL,
   pick_list_no_             IN  VARCHAR2 DEFAULT '*',
   reservation_operation_id_ IN  NUMBER   DEFAULT NULL,
   pick_by_choice_blocked_   IN  VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS
   wo_no_           NUMBER;
   linerec_         Customer_Order_Line_API.Public_Rec;
   changed_part_no_ CUSTOMER_ORDER_LINE_TAB.part_no%TYPE;
BEGIN
   changed_part_no_ := Customer_Order_Line_API.Get_Part_No(order_no_, line_no_, rel_no_, line_item_no_);
         
   IF (part_no_ != NVL(changed_part_no_, Database_Sys.string_null_)) THEN
      Error_SYS.Record_General(lu_name_, 'LINECHANGED: The Customer Order Line object has been modified by another user.');
   END IF;
   
   IF (Customer_Order_Line_API.Get_Objstate(order_no_, line_no_, rel_no_, line_item_no_) IN ('Delivered', 'Invoiced')) THEN
      Raise_Reservation_Error___();
   END IF;
   
   IF (reservation_operation_id_ IS NULL) OR 
      (reservation_operation_id_ NOT IN (Inv_Part_Stock_Reservation_API.move_reservation_, 
                                         Inv_Part_Stock_Reservation_API.pick_by_choice_, 
                                         Inv_Part_Stock_Reservation_API.unpack_reservation_)) THEN
      IF (Customer_Order_API.Get_Objstate(order_no_) IN ('Blocked')) THEN
         -- Added the condition to allow unreserving.
         IF (qty_to_reserve_ >= 0) THEN
          Error_SYS.Record_General(lu_name_, 'CANNOTRESERVED: Reservations cannot be made for Customer Orders which are in the Blocked state.');
         END IF;
      END IF;
   END IF;
   
   Customer_Order_Line_API.Clear_Current_Info();

   Check_Export_Controlled___(order_no_, line_no_, rel_no_, line_item_no_); -- Export control

   Reserve_Manually_Impl__(info_,state_, order_no_, line_no_, rel_no_, line_item_no_, NULL,
                           contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_,
                           waiv_dev_rej_no_, activity_seq_, handling_unit_id_, qty_to_reserve_,
                           input_qty_, input_unit_meas_, input_conv_factor_, input_variable_values_, shipment_id_,
                           part_ownership_, owner_, condition_code_, pick_list_no_, reservation_operation_id_,
                           pick_by_choice_blocked_);

   Update_License_Coverage_Qty___(order_no_, line_no_, rel_no_, line_item_no_, qty_to_reserve_); -- Export control

   linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);    

   IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Wo_SYS.INSTALLED $THEN
         IF (qty_to_reserve_ > 0) THEN
            Active_Separate_API.Create_Rental_Wo(wo_no_, contract_, part_no_, serial_no_, linerec_.customer_no, linerec_.planned_due_date, order_no_, line_no_, rel_no_, line_item_no_,qty_to_reserve_, 'TRUE');
         ELSIF (qty_to_reserve_ < 0) THEN
            Active_Separate_API.Create_Rental_Wo(wo_no_, contract_, part_no_, serial_no_, linerec_.customer_no, linerec_.planned_due_date, order_no_, line_no_, rel_no_, line_item_no_,qty_to_reserve_, 'FALSE');
         END IF;
      $ELSE
         NULL;
      $END
   END IF;
END Reserve_Manually__;


-- Reserved_With_No_Pick_List__
--   Returns 1 if there are any reservations made but no pick list
@UncheckedAccess
FUNCTION Reserved_With_No_Pick_List__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER;
   -- pick_list_no concatenated with '' in order to make use of PK for CUSTOMER_ORDER_RESERVATION instead of IX
   CURSOR get_reserved IS
      SELECT 1
      FROM customer_order_tab co, customer_order_reservation_tab cor
       WHERE co.order_no            = order_no_
         AND co.order_no            = cor.order_no
         AND co.rowstate           IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
         AND cor.shipment_id        = 0
         AND cor.pick_list_no || '' = '*'
         AND NOT EXISTS (SELECT 1
                           FROM customer_order_line_tab col
                          WHERE col.order_no           = cor.order_no
                            AND col.line_no            = cor.line_no
                            AND col.rel_no             = cor.rel_no
                            AND col.line_item_no       = cor.line_item_no
                            AND ((col.shipment_connected = 'TRUE') 
                                 AND (col.shipment_creation != 'PICK_LIST_CREATION')));
BEGIN
   OPEN get_reserved;
   FETCH get_reserved INTO found_;
   IF (get_reserved%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE get_reserved;
   RETURN found_;
END Reserved_With_No_Pick_List__;



-- Unpicked_Picklist_Exist__
--   Returns TRUE if there are unpicked reservations in the given order line for
--   which a pick list has been created, returns FALSE otherwise.
@UncheckedAccess
FUNCTION Unpicked_Picklist_Exist__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   shipment_id_  IN NUMBER DEFAULT NULL ) RETURN BOOLEAN
IS
   found_ NUMBER;

   CURSOR get_unpicked_reservations IS
      SELECT 1
      FROM   customer_order_reservation_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    (shipment_id = shipment_id_ OR shipment_id_ IS NULL)
      AND    qty_assigned > 0
      AND    qty_picked = 0
      AND    pick_list_no != '*';
BEGIN
   OPEN get_unpicked_reservations;
   FETCH get_unpicked_reservations INTO found_;
   CLOSE get_unpicked_reservations;

   IF (found_ = 1) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Unpicked_Picklist_Exist__;


-- Reserve_Customer_Orders__
--   Reserves a set of customer orders in the attribute string.
PROCEDURE Reserve_Customer_Orders__ (
   attr_ IN VARCHAR2 )
IS
   ptr_         NUMBER;
   name_        VARCHAR2(30);
   value_       VARCHAR2(2000);
   description_ VARCHAR2(200);
BEGIN
   description_ := Language_SYS.Translate_Constant(lu_name_, 'RESERVE_CUSORDER: Reserve Customer Orders');
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'ORDER_NO') THEN
         Transaction_SYS.Deferred_Call('RESERVE_CUSTOMER_ORDER_API.Reserve_Order__', value_, description_);
      END IF;
   END LOOP;
END Reserve_Customer_Orders__;


-- Reserve_Package__
--   Check for the backorder_option and reserves package accordingly.
PROCEDURE Reserve_Package__ (
   order_no_    IN VARCHAR2,
   line_no_     IN VARCHAR2,
   rel_no_      IN VARCHAR2,
   shipment_id_ IN NUMBER )
IS
   backorder_option_db_     VARCHAR2(40);
   allow_partial_pkg_deliv_ VARCHAR2(5);
   linerec_                 Customer_Order_Line_API.Public_Rec;
BEGIN
   IF (Package_Partially_Reserved(order_no_, line_no_, rel_no_) = 'TRUE') THEN
      backorder_option_db_     := Customer_Order_API.Get_Backorder_Option_Db(order_no_);
      linerec_                 := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, -1);
      allow_partial_pkg_deliv_ := Sales_Part_API.Get_Allow_Partial_Pkg_Deliv_Db(
                                                                        linerec_.contract,
                                                                        linerec_.catalog_no);

      IF (backorder_option_db_ = 'ALLOW INCOMPLETE LINES AND PACKAGES' AND allow_partial_pkg_deliv_ = 'TRUE') THEN
         Reserve_Package_Components___(order_no_, line_no_, rel_no_, shipment_id_);
      ELSE
         Reserve_Complete_Package___(order_no_, line_no_, rel_no_, shipment_id_);
      END IF;
   END IF;
END Reserve_Package__;


-- Get_Available_Pkg_Qty__
--   Returns available quantity for a package part.
@UncheckedAccess
FUNCTION Get_Available_Pkg_Qty__ (
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   part_ownership_db_  IN VARCHAR2,
   ownership_type2_db_ IN VARCHAR2,
   owning_customer_no_ IN VARCHAR2,
   owning_vendor_no_   IN VARCHAR2,
   location_type4_db_  IN VARCHAR2,
   include_standard_   IN VARCHAR2,
   include_project_    IN VARCHAR2,
   proj_id_            IN VARCHAR2,
   condition_code_     IN VARCHAR2 ) RETURN NUMBER
IS
   pkg_buy_qty_due_   NUMBER;
   line_qty_per_pkg_  NUMBER := 0;
   line_qty_possible_ NUMBER := 0;
   pkg_qty_possible_  NUMBER;
   sales_part_rec_    Sales_Part_API.Public_Rec;
   temp_proj_id_          VARCHAR2(10);
   temp_include_standard_ VARCHAR2(5);
   temp_include_project_  VARCHAR2(5);
   -- Added supply_code to select list and fetched lines with 'PI' too, so that the Project connected package components will be included when calculating the available qty.
   CURSOR get_inventory_line IS
      SELECT line_item_no, contract, part_no, configuration_id, buy_qty_due, condition_code, conv_factor, inverted_conv_factor, supply_code
      FROM   customer_order_line_tab
      WHERE  (supply_code IN ('IO', 'SO', 'PT', 'IPT','PS', 'DOP') OR (supply_code IN ( 'PI', 'PJD') AND proj_id_ IS NOT NULL))
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      ORDER BY line_item_no;

   CURSOR get_package_line IS
      SELECT catalog_no, qty_per_assembly
      FROM   sales_part_package_tab
      WHERE  parent_part = part_no_;
BEGIN
   pkg_qty_possible_ := 99999999999999.99;
   -- For already saved lines  (Records are at customer order lines tab)
   FOR lines IN get_inventory_line LOOP
      pkg_buy_qty_due_   := Customer_Order_Line_API.Get_Buy_Qty_Due(order_no_, line_no_, rel_no_, -1);
      line_qty_per_pkg_  := lines.buy_qty_due / pkg_buy_qty_due_;
     
      IF (lines.supply_code IN ('PI', 'PJD')) THEN
         temp_proj_id_          := proj_id_;
         temp_include_standard_ := 'FALSE';
         temp_include_project_  := 'TRUE';
      ELSE
         temp_proj_id_          := NULL;
         temp_include_standard_ := include_standard_;
         temp_include_project_  := include_project_;
      END IF;
      line_qty_possible_ := Inventory_Part_In_Stock_API.Get_Inventory_Quantity(contract_            => lines.contract,
                                                                               part_no_             => lines.part_no,
                                                                               configuration_id_    => lines.configuration_id,
                                                                               qty_type_            => 'AVAILABLE',
                                                                               expiration_control_  => 'NOT EXPIRED',
                                                                               supply_control_db_   => 'NETTABLE',
                                                                               ownership_type1_db_  => part_ownership_db_,
                                                                               ownership_type2_db_  => ownership_type2_db_,
                                                                               owning_customer_no_  => owning_customer_no_,
                                                                               owning_vendor_no_    => owning_vendor_no_,
                                                                               location_type1_db_   => 'PICKING',
                                                                               location_type2_db_   => 'F',
                                                                               location_type3_db_   => 'MANUFACTURING',
                                                                               location_type4_db_   => location_type4_db_,
                                                                               include_standard_    => temp_include_standard_,
                                                                               include_project_     => temp_include_project_,
                                                                               project_id_          => temp_proj_id_,
                                                                               condition_code_      => NVL(condition_code_,lines.condition_code));
      line_qty_possible_ := line_qty_possible_ * lines.inverted_conv_factor / lines.conv_factor; 
      pkg_qty_possible_  := least(floor(line_qty_possible_ / line_qty_per_pkg_), pkg_qty_possible_);
   END LOOP;

   -- For a new co line  (Before save)
   IF (pkg_qty_possible_ = 99999999999999.99) THEN
      FOR pkg_lines IN get_package_line LOOP
         sales_part_rec_ := Sales_Part_API.Get(contract_, pkg_lines.catalog_no);
         IF (sales_part_rec_.catalog_type != 'NON') THEN
            line_qty_per_pkg_  := pkg_lines.qty_per_assembly;

            line_qty_possible_ := Inventory_Part_In_Stock_API.Get_Inventory_Quantity(contract_           => contract_,
                                                                                     part_no_            => Sales_Part_API.Get_Part_No(contract_, pkg_lines.catalog_no),
                                                                                     configuration_id_   => configuration_id_,
                                                                                     qty_type_           => 'AVAILABLE',
                                                                                     expiration_control_ => 'NOT EXPIRED',
                                                                                     supply_control_db_  => 'NETTABLE',
                                                                                     ownership_type1_db_ => part_ownership_db_,
                                                                                     ownership_type2_db_ => ownership_type2_db_,
                                                                                     owning_customer_no_ => owning_customer_no_,
                                                                                     owning_vendor_no_   => owning_vendor_no_,
                                                                                     location_type1_db_  => 'PICKING',
                                                                                     location_type2_db_  => 'F',
                                                                                     location_type3_db_  => 'MANUFACTURING',
                                                                                     location_type4_db_  => location_type4_db_,
                                                                                     include_standard_   => include_standard_,
                                                                                     include_project_    => include_project_,
                                                                                     project_id_         => proj_id_,
                                                                                     condition_code_     => condition_code_);
            line_qty_possible_ := line_qty_possible_ * sales_part_rec_.inverted_conv_factor / sales_part_rec_.conv_factor;

            IF line_qty_per_pkg_ > 0 THEN
               pkg_qty_possible_ := least(floor(line_qty_possible_ / line_qty_per_pkg_), pkg_qty_possible_);
            END IF;
         END IF;
      END LOOP;
   END IF;

   IF (pkg_qty_possible_ = 99999999999999.99) THEN
      pkg_qty_possible_ := 0;
   END IF;
   RETURN pkg_qty_possible_;
END Get_Available_Pkg_Qty__;


-- Reserve_Batch_Orders__
--   This method is called from Batch_Reserve_Orders__.
PROCEDURE Reserve_Batch_Orders__ (
   attr_ IN VARCHAR2)
IS
   planned_due_date_          DATE;
   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);
   order_attr_                VARCHAR2(32000);
   description_               VARCHAR2(200);
   contract_                  VARCHAR2(5);
   select_contract_           VARCHAR2(5);
   select_due_date_           DATE;
   execution_offset_          NUMBER;
   order_type_                VARCHAR2(3);
   coordinator_               VARCHAR2(20);
   priority_                  VARCHAR2(10);
   deliver_to_customer_no_    VARCHAR2(20);
   delivery_address_          VARCHAR2(50);
   route_id_                  VARCHAR2(12);
   forward_agent_id_          VARCHAR2(20);
   part_no_                   VARCHAR2(25);
   ship_via_                  VARCHAR2(3);
   reserve_all_lines_co_db_   VARCHAR2(5);
   fair_share_reservation_db_ VARCHAR2(5);
   sequence_no_               NUMBER;
   max_rows_                  PLS_INTEGER := 10000;
   catalog_type_db_           VARCHAR2(4);
   
   batch_reserve_shipment_   VARCHAR2(5);
   
   CURSOR get_shipmet_orders IS
      SELECT order_no
      FROM ship_conn_reserved_ord_tmp;
      
   CURSOR get_order IS
      SELECT order_no, order_id
      FROM CUSTOMER_ORDER_TAB
      WHERE rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND   contract = select_contract_
      AND   order_id LIKE order_type_
      AND   authorize_code LIKE coordinator_
      AND   ((priority LIKE priority_) OR (priority IS NULL AND  Decode(priority_,'%', NULL, priority_) IS NULL))
      AND   order_no IN
               (SELECT order_no FROM customer_order_line_tab
                WHERE line_item_no >= 0
                AND   trunc(planned_due_date) <= select_due_date_
                AND   rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
                AND   ((revised_qty_due - qty_assigned - qty_shipped - qty_on_order + qty_shipdiff > 0 AND
                        supply_code IN ('IO', 'PS', 'PI', 'PT', 'IPT', 'SO', 'PJD'))
                        OR
                       (revised_qty_due - qty_to_ship - qty_shipped + qty_shipdiff > 0 AND
                        supply_code IN ('NO', 'SEO', 'PRJ')))
                AND   ((part_no                LIKE part_no_)                OR (part_no IS NULL AND Decode(part_no_, '%', NULL, part_no_) IS NULL))
                AND   ((deliver_to_customer_no LIKE deliver_to_customer_no_) OR (DECODE(deliver_to_customer_no_, '%',  NULL, deliver_to_customer_no_) IS NULL))
                AND   ((ship_addr_no           LIKE delivery_address_)       OR (DECODE(delivery_address_,       '%',  NULL, delivery_address_) IS NULL))
                AND   ((ship_via_code          LIKE ship_via_)               OR (DECODE(ship_via_,               '%',  NULL, ship_via_) IS NULL))
                AND   ((route_id               LIKE route_id_)               OR (route_id IS NULL AND  Decode(route_id_,'%', NULL, route_id_) IS NULL))
                AND   ((forward_agent_id       LIKE forward_agent_id_)       OR (forward_agent_id IS NULL AND
                                                                                 Decode(forward_agent_id_,'%', NULL, forward_agent_id_) IS NULL)))
      ORDER BY date_entered;
                
   TYPE Orders_Tab IS TABLE OF get_order%ROWTYPE
   INDEX BY PLS_INTEGER;
   nextorder_                Orders_Tab;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'PLANNED_DUE_DATE') THEN
         IF (value_ IS NULL) THEN
            planned_due_date_ := NULL;
         ELSE
            planned_due_date_ := Client_SYS.Attr_Value_To_Date(value_);
         END IF;
      ELSIF (name_ = 'EXECUTION_OFFSET') THEN
         execution_offset_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'ORDER_TYPE') THEN
         order_type_ := value_;
      ELSIF (name_ = 'COORDINATOR') THEN
         coordinator_ := value_;
      ELSIF (name_ = 'PRIORITY') THEN
         priority_ := value_;
      ELSIF (name_ = 'DELIVER_TO_CUSTOMER_NO') THEN
         deliver_to_customer_no_ := value_;
      ELSIF (name_ = 'DELIVERY_ADDRESS') THEN
         delivery_address_ := value_;
      ELSIF (name_ = 'ROUTE_ID') THEN
         route_id_ := value_;
      ELSIF (name_ = 'FORWARD_AGENT_ID') THEN
         forward_agent_id_ := value_;
      ELSIF (name_ = 'PART_NO') THEN
         part_no_ := value_;
      ELSIF (name_ = 'SHIP_VIA') THEN
         ship_via_ := value_;
      ELSIF (name_ = 'RESERVE_ALL_LINES_CO') THEN
         reserve_all_lines_co_db_ := value_;
      ELSIF (name_ = 'FAIR_SHARE_RESERVATION_DB') THEN
         fair_share_reservation_db_ := value_;
      ELSIF (name_ = 'CATALOG_TYPE') THEN
         IF value_ IS NULL THEN
            catalog_type_db_ := '%';
         ELSE
            Sales_Part_Type_API.Exist(value_);
            catalog_type_db_ := Sales_Part_Type_API.Encode(value_);
         END IF;
      END IF;
   END LOOP;

   IF (execution_offset_ IS NOT NULL) AND (planned_due_date_ IS NULL) THEN
      IF (contract_ = '%' OR contract_ IS NULL) THEN
         planned_due_date_ := TRUNC(Site_API.Get_Site_Date(User_Allowed_Site_API.Get_Default_Site)) - execution_offset_;
      ELSE
         planned_due_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - execution_offset_;
      END IF;
   END IF;

   Trace_SYS.Field('CONTRACT', contract_);
   Trace_SYS.Field('PLANNED_DUE_DATE', planned_due_date_);

   -- Remove previous shortage records for all sites for which pick planning will be executed.   
   IF (((order_type_            = '%' OR order_type_             IS NULL) AND 
       (coordinator_            = '%' OR coordinator_            IS NULL) AND 
       (priority_               = '%' OR priority_               IS NULL))AND          
      ((reserve_all_lines_co_db_ = 'TRUE') OR
      ((deliver_to_customer_no_ = '%' OR deliver_to_customer_no_ IS NULL) AND
       (delivery_address_       = '%' OR delivery_address_       IS NULL) AND
       (route_id_               = '%' OR route_id_               IS NULL) AND
       (forward_agent_id_       = '%' OR forward_agent_id_       IS NULL) AND
       (part_no_                = '%' OR part_no_                IS NULL) AND
       (ship_via_               = '%' OR ship_via_               IS NULL) AND
       (catalog_type_db_        = '%' )))) THEN
      Customer_Order_Shortage_API.Remove_All(contract_, planned_due_date_);
   END IF;

   select_contract_ := contract_;
   select_due_date_ := nvl(planned_due_date_,Site_API.Get_Site_Date(select_contract_));

   IF fair_share_reservation_db_ = 'TRUE' THEN
      sequence_no_ := Fair_Share_Reservation_API.Get_Next_Sequence_No__;
   END IF;
   
   OPEN get_order;
   LOOP
      FETCH get_order BULK COLLECT INTO nextorder_ LIMIT max_rows_;
      EXIT WHEN nextorder_.COUNT = 0;

      FOR j IN nextorder_.FIRST .. nextorder_.LAST LOOP
         Trace_SYS.Field('Inside loop. ORDER_NO', nextorder_(j).order_no);
         Client_SYS.Clear_Attr(order_attr_);
         Client_SYS.Add_To_Attr('ORDER_NO', nextorder_(j).order_no, order_attr_);
         Client_SYS.Add_To_Attr('ORDER_ID', nextorder_(j).order_id, order_attr_);         
         IF (Customer_Order_API.Shipment_Connected_Lines_Exist(nextorder_(j).order_no)= 1) THEN            
            batch_reserve_shipment_ := 'TRUE';
            Client_SYS.Add_To_Attr('BATCH_RESERVE_SHIPMENT', batch_reserve_shipment_, order_attr_);            
            INSERT INTO ship_conn_reserved_ord_tmp
               (order_no)
            VALUES
               (nextorder_(j).order_no);
         END IF;
         
         IF (reserve_all_lines_co_db_ = 'TRUE') THEN
            select_due_date_        := Database_SYS.last_calendar_date_;
            deliver_to_customer_no_ := '%';
            delivery_address_       := '%';
            route_id_               := '%';
            forward_agent_id_       := '%';
            part_no_                := '%';
            ship_via_               := '%';
            catalog_type_db_        := '%';
         END IF;
         Client_SYS.Add_To_Attr('PLANNED_DUE_DATE', select_due_date_, order_attr_);
         Client_SYS.Add_To_Attr('DELIVER_TO_CUSTOMER_NO', deliver_to_customer_no_, order_attr_);
         Client_SYS.Add_To_Attr('DELIVERY_ADDRESS', delivery_address_, order_attr_);
         Client_SYS.Add_To_Attr('ROUTE_ID', route_id_, order_attr_);
         Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', forward_agent_id_, order_attr_);
         Client_SYS.Add_To_Attr('PART_NO', part_no_, order_attr_);
         Client_SYS.Add_To_Attr('SHIP_VIA', ship_via_, order_attr_);
         Client_SYS.Add_To_Attr('SEQUENCE_NO', sequence_no_, order_attr_);
         Client_SYS.Add_To_Attr('CATALOG_TYPE_DB', catalog_type_db_, order_attr_);
   
         Reserve_Customer_Order__(order_attr_);
      END LOOP;
   END LOOP;
   CLOSE get_order;
   
   IF fair_share_reservation_db_ = 'TRUE' THEN
      -- Note: This method should be moved to Reserve_Customer_Order_API
      Fair_Share_Reservation_API.Process_Fair_Share_Orders__(sequence_no_);
   END IF;
   IF (batch_reserve_shipment_ = 'TRUE') THEN
      FOR orders_ IN get_shipmet_orders LOOP         
         Shipment_Order_Utility_API.Start_Shipment_Flow(orders_.order_no, 10, 'FALSE');        
      END LOOP;      
      DELETE FROM ship_conn_reserved_ord_tmp;
   END IF;
END Reserve_Batch_Orders__; 


-- Create_Reservations__
--   Creates the reservations and deliver it for order line created via rental transfer. 
PROCEDURE Create_Reservations__ (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   qty_to_assign_    IN NUMBER,
   configuration_id_ IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   handling_unit_id_ IN NUMBER )
IS
   line_rec_     Customer_Order_Line_API.Public_Rec;   
   activity_seq_ NUMBER := 0;
BEGIN
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   IF (line_rec_.supply_code = 'PI') THEN
      activity_seq_ := line_rec_.activity_seq;
   END IF;
   IF (Reserve_Customer_Order_API.Line_Is_Fully_Reserved(order_no_, line_no_, rel_no_, line_item_no_ )= 0) THEN
      Create_Arrival_Reservations___(qty_to_assign_, order_no_, line_no_, rel_no_, line_item_no_, contract_,
                                     part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_,
                                     eng_chg_level_, waiv_dev_rej_no_, activity_seq_, 
                                     handling_unit_id_, line_rec_);
   END IF;   
END Create_Reservations__;


@UncheckedAccess
FUNCTION Man_Res_Valid_Ext_Service__(
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN VARCHAR2,
   lot_batch_no_  IN VARCHAR2,
   serial_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_line_rec_   CUSTOMER_ORDER_LINE_API.Public_Rec;   
   result_   VARCHAR2(5) := 'TRUE';
BEGIN
   order_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);   
   result_ := Man_Res_Valid_Ext_Service___(order_no_,
                                           line_no_,
                                           rel_no_,
                                           line_item_no_,
                                           lot_batch_no_,
                                           serial_no_,
                                           order_line_rec_);
   
   RETURN result_;
END Man_Res_Valid_Ext_Service__;


@UncheckedAccess
FUNCTION Man_Res_Valid_Ownership__(
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN VARCHAR2,
   part_ownership_db_   IN VARCHAR2,
   owning_customer_no_  IN VARCHAR2,
   owning_vendor_no_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_line_rec_   CUSTOMER_ORDER_LINE_API.Public_Rec;
   result_  VARCHAR2(5);
BEGIN
   order_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   result_ := Man_Res_Valid_Ownership___(order_no_,
                                         line_no_,
                                         rel_no_,
                                         line_item_no_,
                                         part_ownership_db_,
                                         owning_customer_no_,
                                         owning_vendor_no_,
                                         order_line_rec_);
   RETURN result_;
END Man_Res_Valid_Ownership__;

PROCEDURE Move_Co_Res_With_Trans_Task__ (
   message_ IN OUT NOCOPY VARCHAR2 )
IS
   description_ VARCHAR2(200);
BEGIN
   IF (Transaction_Sys.Is_Session_Deferred()) THEN
      -- if we are already inside a background job don't create a new one, which will happened if this was a scheduled job
      Move_With_Trans_Task__(message_);
   ELSE
      description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVE_RES_WITH_TT: Move Customer Order Reservations with Transport Task');
      Transaction_SYS.Deferred_Call('RESERVE_CUSTOMER_ORDER_API.Move_With_Trans_Task__', message_, description_);
   END IF;
END Move_Co_Res_With_Trans_Task__;

-- This method is used to generate transport tasks with batch for customer order reservations. 
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
   order_no_                         VARCHAR2(2000);
   order_type_                       VARCHAR2(2000);
   coordinator_                      VARCHAR2(2000);
   priority_                         NUMBER;
   route_id_                         VARCHAR2(2000);
   planned_ship_period_              VARCHAR2(2000);
   part_no_                          VARCHAR2(2000);
   ship_via_code_                    VARCHAR2(2000);
   planned_due_date_                 DATE;
   forwarder_id_                     VARCHAR2(2000);
   customer_no_                      VARCHAR2(2000);
   include_full_qty_of_top_hu_       VARCHAR2(1);
   exclude_stock_attached_to_hu_     VARCHAR2(1);
   exclude_stock_not_attached_to_hu_ VARCHAR2(1);
   exclude_hu_to_pick_in_one_step_   VARCHAR2(1);
   location_no_tab_                  Warehouse_Bay_Bin_API.Location_No_Tab; 
   move_reserve_tab_                 Reserve_Shipment_API.Move_Reserve_Tab;
   execution_offset_                 NUMBER;
   
   CURSOR get_reserv_details IS
      SELECT part_no, location_no from_location_no, order_no source_ref1, line_no source_ref2, rel_no source_ref3, line_item_no source_ref4, cust_order_type_db source_ref_type_db,
             configuration_id, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, pick_list_no, shipment_id, qty_to_move       
      FROM move_cust_ord_reserv_with_tt
      WHERE contract = contract_    
      AND  ((UPPER(warehouse_id) = UPPER(warehouse_id_)) OR warehouse_id_ IS NULL)
      AND  ((UPPER(bay_id)       = UPPER(bay_id_)) OR bay_id_ IS NULL)
      AND  ((UPPER(row_id)       = UPPER(row_id_)) OR row_id_ IS NULL)
      AND  ((UPPER(tier_id)      = UPPER(tier_id_)) OR tier_id_ IS NULL)
      AND  ((UPPER(bin_id)       = UPPER(bin_id_)) OR bin_id_ IS NULL) 
      AND  ((storage_zone_id_ IS NOT NULL AND location_no IN (SELECT * FROM TABLE(location_no_tab_))) OR (storage_zone_id_ IS NULL))
      AND  (Report_SYS.Parse_Parameter(order_no, order_no_) = 'TRUE')
      AND  (Report_SYS.Parse_Parameter(order_type, order_type_) = 'TRUE')
      AND  (Report_SYS.Parse_Parameter(coordinator, coordinator_) = 'TRUE')
      AND  ((priority_ != 0 AND (Report_SYS.Parse_Parameter(priority, TO_CHAR(priority_)) = 'TRUE')) OR (priority_ = 0 AND priority IS NULL))
      AND  ((Report_SYS.Parse_Parameter(route_id, route_id_) = 'TRUE') OR (route_id_ = '%' AND route_id IS NULL))
      AND  ((Report_SYS.Parse_Parameter(planned_ship_period, planned_ship_period_) = 'TRUE') OR (planned_ship_period_ = '%' AND planned_ship_period IS NULL))
      AND  (Report_SYS.Parse_Parameter(part_no, part_no_) = 'TRUE') 
      AND  (Report_SYS.Parse_Parameter(ship_via_code, ship_via_code_) = 'TRUE')
      AND  TRUNC(planned_due_date) <= NVL(TRUNC(planned_due_date_), TRUNC(planned_due_date))
      AND  ((Report_SYS.Parse_Parameter(forwarder_id, forwarder_id_) = 'TRUE') OR (forwarder_id_ = '%' AND forwarder_id IS NULL))
      AND  (Report_SYS.Parse_Parameter(customer_no, customer_no_) = 'TRUE')     
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
      ELSIF (name_arr_(n_) = 'ORDER_NO') THEN
         order_no_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'ORDER_TYPE') THEN
         order_type_ := NVL(value_arr_(n_), '%'); 
      ELSIF (name_arr_(n_) = 'COORDINATOR') THEN
         coordinator_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'PRIORITY') THEN
         priority_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'ROUTE_ID') THEN
         route_id_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'PLANNED_SHIP_PERIOD') THEN
         planned_ship_period_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'PART_NO') THEN
         part_no_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'SHIP_VIA_CODE') THEN
         ship_via_code_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'PLANNED_DUE_DATE') THEN
         planned_due_date_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'FORWARDER_ID') THEN
         forwarder_id_ := NVL(value_arr_(n_), '%');   
      ELSIF (name_arr_(n_) = 'CUSTOMER_NO') THEN
         customer_no_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'INCLUDE_FULL_QTY_OF_TOP_HU') THEN
         include_full_qty_of_top_hu_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'EXCLUDE_STOCK_ATTACHED_TO_HU') THEN
         exclude_stock_attached_to_hu_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'EXCLUDE_STOCK_NOT_ATTACH_TO_HU') THEN
         exclude_stock_not_attached_to_hu_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'EXCLUDE_HU_TO_PICK_IN_ONE_STEP') THEN
         exclude_hu_to_pick_in_one_step_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'EXECUTION_OFFSET') THEN
         execution_offset_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
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
   IF (execution_offset_ IS NOT NULL) AND (planned_due_date_ IS NULL) THEN         
      planned_due_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - execution_offset_;      
   END IF;   
   OPEN get_reserv_details;
   FETCH get_reserv_details BULK COLLECT INTO move_reserve_tab_;
   CLOSE get_reserv_details;
   IF (move_reserve_tab_.COUNT() > 0) THEN
      Reserve_Shipment_API.Move_Res_With_Trans_Task(contract_, move_reserve_tab_, to_location_, include_full_qty_of_top_hu_, exclude_hu_to_pick_in_one_step_);
   END IF;
   
END Move_With_Trans_Task__;

PROCEDURE Unreserve_Cust_Order_Lines__ (
   info_             OUT VARCHAR2,
   order_no_         IN  VARCHAR2,
   line_no_          IN  VARCHAR2,
   rel_no_           IN  VARCHAR2,
   line_item_no_     IN  NUMBER,
   quantity_         IN  NUMBER)
IS
   res_info_                  VARCHAR2(2000);   
   state_                     VARCHAR2(20);
   part_ownership_            VARCHAR2(20);
      
   CURSOR get_reservations IS
      SELECT * 
      FROM customer_order_reservation
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;   
BEGIN 
   FOR resv_rec_ IN get_reservations LOOP
      -- Used Get_Part_Ownership_Db() to be compatible with all languages.
      part_ownership_ :=  Customer_Order_Line_API.Get_Part_Ownership_Db(order_no_, line_no_, rel_no_, line_item_no_);      
      Reserve_Manually__(res_info_, state_, order_no_, line_no_, rel_no_, line_item_no_, resv_rec_.contract, resv_rec_.part_no, resv_rec_.location_no, resv_rec_.lot_batch_no,
                         resv_rec_.serial_no, resv_rec_.eng_chg_level, resv_rec_.waiv_dev_rej_no, resv_rec_.activity_seq, resv_rec_.handling_unit_id, (quantity_ - resv_rec_.qty_assigned),
                         resv_rec_.input_qty, resv_rec_.input_unit_meas, resv_rec_.input_conv_factor, resv_rec_.input_variable_values, resv_rec_.shipment_id, Part_Ownership_API.Decode(part_ownership_),
                         Customer_Order_Line_API.Get_Owner_For_Part_Ownership(order_no_, line_no_, rel_no_, line_item_no_, part_ownership_), Customer_Order_Line_API.Get_Condition_Code(order_no_, line_no_, rel_no_, line_item_no_));
   END LOOP;
   info_ := info_ || res_info_;   
END Unreserve_Cust_Order_Lines__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Any_Pick_List_Printed
--   Returns 1 if any pick list has been printed for order_no.
@UncheckedAccess
FUNCTION Any_Pick_List_Printed (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;

   CURSOR find_printed_pick_lists IS
      SELECT 1
      FROM CUSTOMER_ORDER_PICK_LIST_TAB
      WHERE pick_list_no IN( SELECT DISTINCT pick_list_no
                             FROM CUSTOMER_ORDER_RESERVATION_TAB r
                             WHERE order_no = order_no_
                             AND pick_list_no != '*')
      AND   printed_flag = 'Y';

BEGIN
   OPEN find_printed_pick_lists;
   FETCH find_printed_pick_lists INTO dummy_;
   IF (find_printed_pick_lists%NOTFOUND) THEN
      dummy_ := 0;
   END IF;
   CLOSE find_printed_pick_lists;
   RETURN dummy_;
END Any_Pick_List_Printed;


-- Feedback_From_Manufacturing
--   To be called from Shop order when a shop order originated by a
--   customer order has been received into inventory or from CRO process when
--   reservations are moved from supply order. This method will create
--   reservations in Customer Orders and Inventory.
PROCEDURE Feedback_From_Manufacturing (
   qty_reserved_     IN OUT NUMBER,
   order_no_         IN     VARCHAR2,
   line_no_          IN     VARCHAR2,
   rel_no_           IN     VARCHAR2,
   line_item_no_     IN     NUMBER,
   contract_         IN     VARCHAR2,
   part_no_          IN     VARCHAR2,
   manufactured_qty_ IN     NUMBER,
   location_no_      IN     VARCHAR2,
   lot_batch_no_     IN     VARCHAR2,
   serial_no_        IN     VARCHAR2,
   eng_chg_level_    IN     VARCHAR2,
   waiv_dev_rej_no_  IN     VARCHAR2,
   configuration_id_ IN     VARCHAR2 DEFAULT NULL,
   activity_seq_     IN     NUMBER   DEFAULT NULL,
   handling_unit_id_ IN     NUMBER   DEFAULT 0 )
IS
   line_rec_          Customer_Order_Line_API.Public_Rec;
   text_              VARCHAR2(200);
   unit_meas_         VARCHAR2(10);
   so_order_no_       VARCHAR2(12);
   so_release_no_     VARCHAR2(4);
   so_sequence_no_    VARCHAR2(4);
   qty_on_order_diff_ NUMBER;
   location_type_     VARCHAR2(20);
BEGIN
   line_rec_      := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   location_type_ := Inventory_Part_In_Stock_API.Get_Location_Type_Db(contract_           => contract_,
                                                                      part_no_            => part_no_,
                                                                      configuration_id_   => configuration_id_,
                                                                      location_no_        => location_no_,
                                                                      lot_batch_no_       => lot_batch_no_,
                                                                      serial_no_          => serial_no_,
                                                                      eng_chg_level_      => eng_chg_level_ ,
                                                                      waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                      activity_seq_       => NVL(activity_seq_, NVL(line_rec_.activity_seq, 0)), 
                                                                      handling_unit_id_   => handling_unit_id_);
   IF (location_type_ != 'PICKING') THEN
      Error_SYS.Record_General(lu_name_, 'NOTPICKINGLOC: This part will be automatically reserved to a customer order line. Receipt must be done to a Picking Location.');
   END IF;

   IF (manufactured_qty_ > 0) THEN
      Register_Arrival___(qty_on_order_diff_ => qty_on_order_diff_, 
                          qty_reserved_      => qty_reserved_, 
                          qty_received_      => manufactured_qty_,
                          order_no_          => order_no_, 
                          line_no_           => line_no_, 
                          rel_no_            => rel_no_, 
                          line_item_no_      => line_item_no_,
                          contract_          => contract_, 
                          part_no_           => part_no_, 
                          configuration_id_  => configuration_id_,
                          location_no_       => location_no_, 
                          lot_batch_no_      => lot_batch_no_, 
                          serial_no_         => serial_no_, 
                          eng_chg_level_     => eng_chg_level_, 
                          waiv_dev_rej_no_   => waiv_dev_rej_no_,
                          activity_seq_      => NVL(activity_seq_,line_rec_.activity_seq), 
                          handling_unit_id_  => handling_unit_id_,
                          line_rec_          => line_rec_);

   ELSIF (manufactured_qty_ < 0) THEN
      Unregister_Arrival___(qty_on_order_diff_ => qty_on_order_diff_, 
                            qty_reserved_      => qty_reserved_, 
                            qty_received_      => manufactured_qty_,
                            order_no_          => order_no_, 
                            line_no_           => line_no_, 
                            rel_no_            => rel_no_, 
                            line_item_no_      => line_item_no_,
                            contract_          => contract_, 
                            part_no_           => part_no_, 
                            configuration_id_  => configuration_id_,
                            location_no_       => location_no_, 
                            lot_batch_no_      => lot_batch_no_, 
                            serial_no_         => serial_no_, 
                            eng_chg_level_     => eng_chg_level_, 
                            waiv_dev_rej_no_   => waiv_dev_rej_no_,
                            activity_seq_      => NVL(activity_seq_,line_rec_.activity_seq),
                            handling_unit_id_  => handling_unit_id_,
                            line_rec_          => line_rec_);
   END IF;

   unit_meas_ := Inventory_Part_API.Get_Unit_Meas(contract_, part_no_);

   IF (line_rec_.supply_code = 'SO') THEN
      Customer_Order_Shop_Order_API.Get_Shop_Order(so_order_no_, so_release_no_, so_sequence_no_, order_no_, line_no_, rel_no_, line_item_no_);

      IF (so_order_no_ IS NOT NULL) AND (qty_on_order_diff_ IS NOT NULL) THEN
         $IF Component_Shpord_SYS.INSTALLED $THEN
            Shop_Ord_API.Modify_Pegging_From_Demand(so_order_no_, so_release_no_, so_sequence_no_, qty_on_order_diff_);
         $ELSE
            NULL;
         $END
      END IF;

      text_ := SUBSTR(Language_SYS.Translate_Constant(lu_name_, 'RECFROMSO: Received from Shop Order: :P1 :P2',
                                                      NULL, TO_CHAR(qty_reserved_), unit_meas_), 1, 200);
   ELSE
      text_ := SUBSTR(Language_SYS.Translate_Constant(lu_name_, 'RECFROMCRO: Received from Supply Order: :P1 :P2.',
                                                      NULL, TO_CHAR(qty_reserved_), unit_meas_), 1, 200);
   END IF;
   $IF Component_Expctr_SYS.INSTALLED $THEN
      Exp_License_Connect_Util_API.Update_So_Connect_Co_License(part_no_, contract_, order_no_, line_no_, rel_no_, line_item_no_, so_order_no_, so_release_no_, so_sequence_no_);
   $END
   Customer_Order_Line_Hist_API.New(order_no_, line_no_, rel_no_, line_item_no_, text_);
END Feedback_From_Manufacturing;


-- Reserve_From_Ctp
--   To be called from CC process when reservations are moved from Interim Order to
--   Customer Order. This method will create reservations in Customer Order
--   and Inventory. This method is called when a release of a
--   Capability Checked Customer Order (Line) happens.
PROCEDURE Reserve_From_Ctp (
   qty_reserved_     IN OUT NUMBER,
   order_no_         IN     VARCHAR2,
   line_no_          IN     VARCHAR2,
   rel_no_           IN     VARCHAR2,
   line_item_no_     IN     NUMBER,
   contract_         IN     VARCHAR2,
   part_no_          IN     VARCHAR2,
   qty_to_reserve_   IN     NUMBER,
   location_no_      IN     VARCHAR2,
   lot_batch_no_     IN     VARCHAR2,
   serial_no_        IN     VARCHAR2,
   eng_chg_level_    IN     VARCHAR2,
   waiv_dev_rej_no_  IN     VARCHAR2,
   configuration_id_ IN     VARCHAR2 DEFAULT NULL,
   handling_unit_id_ IN     NUMBER   DEFAULT 0 )
IS
   line_rec_      Customer_Order_Line_API.Public_Rec;
   text_          VARCHAR2(200);
   qty_to_assign_ NUMBER;
BEGIN
   Trace_Sys.Field('   qty_reserved_',qty_reserved_);
   Trace_Sys.Field('   order_no_',order_no_);
   Trace_Sys.Field('   line_no_',line_no_);
   Trace_Sys.Field('   rel_no_',rel_no_);
   Trace_Sys.Field('   line_item_no_',line_item_no_);
   Trace_Sys.Field('   contract_',contract_);
   Trace_Sys.Field('   part_no_',part_no_);
   Trace_Sys.Field('   qty_to_reserve',qty_to_reserve_);
   Trace_Sys.Field('   location_no_',location_no_);
   Trace_Sys.Field('   lot_batch_no_',lot_batch_no_);
   Trace_Sys.Field('   line_item_no_',line_item_no_);
   Trace_Sys.Field('   serial_no_',serial_no_);
   Trace_Sys.Field('   eng_chg_level_',eng_chg_level_);
   Trace_Sys.Field('   waiv_dev_rej_no_',waiv_dev_rej_no_);
   Trace_Sys.Field('   configuration_id_',configuration_id_);
   Trace_Sys.Field('   handling_unit_id_',handling_unit_id_);

   line_rec_      := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   qty_to_assign_ := least(line_rec_.revised_qty_due - line_rec_.qty_shipped - line_rec_.qty_assigned + line_rec_.qty_shipdiff, qty_to_reserve_);

   -- sending activity_seq = 0, since CC at the moment dont support Project Inventory
   Create_Arrival_Reservations___(qty_to_assign_    => qty_to_assign_, 
                                  order_no_         => order_no_, 
                                  line_no_          => line_no_, 
                                  rel_no_           => rel_no_, 
                                  line_item_no_     => line_item_no_,
                                  contract_         => contract_, 
                                  part_no_          => part_no_, 
                                  configuration_id_ => configuration_id_, 
                                  location_no_      => location_no_, 
                                  lot_batch_no_     => lot_batch_no_,
                                  serial_no_        => serial_no_, 
                                  eng_chg_level_    => eng_chg_level_, 
                                  waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                  activity_seq_     => 0, 
                                  handling_unit_id_ => handling_unit_id_, 
                                  line_rec_         => line_rec_);

   qty_reserved_  := qty_to_assign_;
   Customer_Order_Line_API.Modify_Qty_On_Order(order_no_, line_no_, rel_no_, line_item_no_, line_rec_.qty_on_order - qty_reserved_);
   text_          := SUBSTR(Language_SYS.Translate_Constant(lu_name_, 'RECFROMCC: :P1 are reserved. This reservation is inherited from Interim Order',
                                                            NULL, to_char(qty_reserved_)), 1, 200);
   Customer_Order_Line_Hist_API.New(order_no_, line_no_, rel_no_, line_item_no_, text_);
END Reserve_From_Ctp;


-- Line_Is_Fully_Reserved
--   Return TRUE = 1 if the order line if all reservations have been made for
--   the specified order line.
--   Return FALSE = 0 if reservations still remain to be done.
--   Called from Purchase Order when trying to cancel a purchase order line
--   connected to a customer order line.
@UncheckedAccess
FUNCTION Line_Is_Fully_Reserved (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   line_rec_ Customer_Order_Line_API.Public_Rec;
BEGIN
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   IF line_rec_.catalog_type = 'NON' THEN
      RETURN(1);
   END IF;
   IF (line_rec_.revised_qty_due <= line_rec_.qty_assigned + line_rec_.qty_shipped - line_rec_.qty_shipdiff) THEN
      RETURN(1);
   ELSE
      RETURN(0);
   END IF;
END Line_Is_Fully_Reserved;



-- Reserve_Line_From_Shortage
--   Called from inventory when resolving shortages for a part.
--   Creates reservations for an order line.
PROCEDURE Reserve_Line_From_Shortage (
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   qty_to_be_reserved_ IN NUMBER )
IS
   qty_reserved_ NUMBER;
BEGIN
   Reserve_Order_Line__(qty_reserved_,
                        order_no_, line_no_, rel_no_, line_item_no_,
                        qty_to_be_reserved_, 0);
   IF (qty_reserved_ < qty_to_be_reserved_) THEN
      Client_SYS.Add_Info(lu_name_, 'RESERVEDQTYIS: Only :P1 could be reserved.', qty_reserved_);
   END IF;
END Reserve_Line_From_Shortage;


-- Consume_Peggings
--   To be called from Purchase when a purchase order pegged for a customer
--   order has been received into inventory. This method will create
--   reservations in Customer Orders and Inventory.
--   To be called from Shop Order when a shop order pegged for a
--   customer order has been received into inventory. This method will
--   create reservations in Customer Orders and Inventory.
PROCEDURE Consume_Peggings (
   qty_consumed_     OUT NUMBER,
   order_no_         IN  VARCHAR2,
   line_no_          IN  VARCHAR2,
   rel_no_           IN  VARCHAR2,
   contract_         IN  VARCHAR2,
   part_no_          IN  VARCHAR2,
   location_no_      IN  VARCHAR2,
   lot_batch_no_     IN  VARCHAR2,
   serial_no_        IN  VARCHAR2,
   eng_chg_level_    IN  VARCHAR2,
   waiv_dev_rej_no_  IN  VARCHAR2,
   qty_received_     IN  NUMBER,
   configuration_id_ IN  VARCHAR2,
   condition_code_   IN  VARCHAR2,
   activity_seq_     IN  NUMBER,
   handling_unit_id_ IN  NUMBER )
IS
   CURSOR demand_rec IS
      SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no,
             col.condition_code ,col.qty_to_ship, cop.qty_on_order, col.shipment_connected
        FROM customer_order_line_tab col,customer_order_pur_order_tab cop
       WHERE col.order_no      = cop.oe_order_no
         AND col.line_no       = cop.oe_line_no
         AND col.rel_no        = cop.oe_rel_no
         AND col.line_item_no  = cop.oe_line_item_no
         AND cop.po_order_no   = order_no_
         AND cop.po_line_no    = line_no_
         AND cop.po_rel_no     =  rel_no_
         AND cop.purchase_type = 'O'
    ORDER BY col.planned_delivery_date;

   line_rec_                  Customer_Order_Line_API.Public_Rec;
   qty_reserved_              NUMBER;
   qty_on_order_              NUMBER;
   con_qty_on_order_          NUMBER;
   qty_remaining_             NUMBER;
   qty_on_order_diff_         NUMBER;
   unit_meas_                 VARCHAR2(10);
   state_                     VARCHAR2(30);
   message_text_              VARCHAR2(200);
   attr_                      VARCHAR2(32000);
   comp_catalog_type_         VARCHAR2(4);
   part_rec_                  Inventory_Part_In_Stock_API.Public_Rec;
   ord_line_owning_vendor_no_ CUSTOMER_ORDER_LINE_TAB.vendor_no%TYPE;
   new_qty_to_ship_           NUMBER;
   part_cat_rec_              Part_Catalog_API.Public_Rec;
   serial_no_in_stock_        VARCHAR2(50);
   location_type_db_          VARCHAR2(20);
   qty_to_ship_               NUMBER:=0;
   db_company_owned_          CONSTANT CUSTOMER_ORDER_LINE_TAB.part_ownership%TYPE := Part_Ownership_API.DB_COMPANY_OWNED;
   db_consignment_            CONSTANT CUSTOMER_ORDER_LINE_TAB.part_ownership%TYPE := Part_Ownership_API.DB_CONSIGNMENT;
   db_supplier_loaned_        CONSTANT CUSTOMER_ORDER_LINE_TAB.part_ownership%TYPE := Part_Ownership_API.DB_SUPPLIER_LOANED;
   db_customer_owned_         CONSTANT CUSTOMER_ORDER_LINE_TAB.part_ownership%TYPE := Part_Ownership_API.DB_CUSTOMER_OWNED;
   db_company_rental_asset_   CONSTANT CUSTOMER_ORDER_LINE_TAB.part_ownership%TYPE := Part_Ownership_API.DB_COMPANY_RENTAL_ASSET;
   db_supplier_rented_        CONSTANT CUSTOMER_ORDER_LINE_TAB.part_ownership%TYPE := Part_Ownership_API.DB_SUPPLIER_RENTED;   
   temp_serial_no_            VARCHAR2(50);
   temp_con_qty_on_order_     NUMBER;
BEGIN
   qty_consumed_       := 0;
   part_cat_rec_       := Part_Catalog_API.Get(part_no_);
   location_type_db_   := Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_);
   
   -- For receipt and issue tracked parts the serial no passed in might not be found in InventoryPartInStock
   serial_no_in_stock_ := Inventory_Part_In_Stock_API.Get_Serial_No_For_Stock(part_no_, serial_no_, part_cat_rec_, location_type_db_, handling_unit_id_);

   FOR rec_ IN demand_rec LOOP
      line_rec_ := Customer_Order_Line_API.Get(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      part_rec_ := Inventory_Part_In_Stock_API.Get(contract_         => contract_,
                                                   part_no_          => part_no_,
                                                   configuration_id_ => configuration_id_,
                                                   location_no_      => location_no_,
                                                   lot_batch_no_     => lot_batch_no_,
                                                   serial_no_        => serial_no_in_stock_,
                                                   eng_chg_level_    => eng_chg_level_,
                                                   waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                   activity_seq_     => NVL(activity_seq_,0), 
                                                   handling_unit_id_ => handling_unit_id_);
      IF (line_rec_.part_ownership = db_supplier_loaned_) THEN
         ord_line_owning_vendor_no_ :=  Customer_Order_Line_API.Get_Owner_For_Part_Ownership(rec_.order_no,
                                                                                             rec_.line_no,
                                                                                             rec_.rel_no,
                                                                                             rec_.line_item_no,
                                                                                             line_rec_.part_ownership);
      END IF;
      
      -- Non-Inventory parts
      IF (part_rec_.part_ownership IS NULL) THEN
         IF (line_rec_.rental = Fnd_Boolean_API.DB_FALSE) THEN
            part_rec_.part_ownership := db_company_owned_;
         ELSE
            part_rec_.part_ownership := db_supplier_rented_;
         END IF;
      END IF;

      IF (((line_rec_.part_ownership = db_company_owned_) AND (part_rec_.part_ownership = db_company_owned_ OR part_rec_.part_ownership = db_consignment_)) OR
          ((line_rec_.part_ownership = db_customer_owned_) AND (part_rec_.part_ownership = db_customer_owned_) AND (part_rec_.owning_customer_no = line_rec_.owning_customer_no)) OR
          ((line_rec_.part_ownership = db_supplier_loaned_) AND (part_rec_.part_ownership = db_supplier_loaned_) AND (part_rec_.owning_vendor_no = ord_line_owning_vendor_no_)) OR
          ((line_rec_.part_ownership IN (db_supplier_rented_, db_company_rental_asset_)) AND part_rec_.part_ownership IN (db_supplier_rented_, db_company_rental_asset_))) THEN
         IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(part_no_) = 'NOT_ALLOW_COND_CODE' ) OR ( rec_.condition_code = Condition_Code_ ) THEN
            state_ := Customer_Order_Line_API.Get_Objstate(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
            IF (line_rec_.catalog_type = 'KOMP') THEN
               IF (Sales_Part_Type_API.Encode(Sales_Part_API.Get_Catalog_Type(contract_,line_rec_.catalog_no)) = 'NON') THEN
                  comp_catalog_type_ := 'NON';
               END IF;
            END IF;
            IF (state_ != 'Cancelled') THEN
               IF qty_consumed_ < qty_received_ THEN
                  qty_remaining_ := qty_received_ - qty_consumed_;
                  IF (line_rec_.catalog_type = 'NON' OR comp_catalog_type_ = 'NON') THEN

                     IF (state_ NOT IN ('Delivered', 'Invoiced')) THEN
                        qty_to_ship_     := LEAST(line_rec_.qty_on_order, qty_remaining_);
                        new_qty_to_ship_ := rec_.qty_to_ship + qty_to_ship_;
                        IF ((new_qty_to_ship_ + line_rec_.qty_shipped) > line_rec_.revised_qty_due) THEN
                           new_qty_to_ship_ := line_rec_.revised_qty_due - (line_rec_.qty_to_ship + line_rec_.qty_shipped);
                        END IF;
                        IF (rec_.shipment_connected = 'TRUE') THEN
                           Shipment_Line_API.Reserve_Non_Inventory(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, 
                                                                   Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, qty_to_ship_);
                        END IF;
                        Customer_Order_Line_API.Modify_Qty_To_Ship__(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, new_qty_to_ship_);
                     END IF;
                     -- Added the SQL function GREATEST, to avoid less than 0 values
                     qty_on_order_     := GREATEST(line_rec_.qty_on_order - (least(rec_.qty_on_order, qty_remaining_)),0);
                     Customer_Order_Line_API.Modify_Qty_On_Order(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, qty_on_order_);
                     unit_meas_        := Sales_Part_API.Get_Sales_Unit_Meas(contract_, line_rec_.catalog_no);
                     message_text_     := Language_SYS.Translate_Constant(lu_name_, 'RECEIVED: Received from purchase order: :P1 :P2.', NULL,
                                                                          to_char(least(line_rec_.qty_on_order, qty_remaining_)), unit_meas_);
                     qty_consumed_     := qty_consumed_ + least(rec_.qty_on_order, qty_remaining_);
                     con_qty_on_order_ := GREATEST(rec_.qty_on_order - qty_remaining_, 0);
                  ELSE
                     temp_serial_no_ := serial_no_;
                     IF ((serial_no_ != '*') AND (line_rec_.supply_code = 'IO') AND
                         (Inventory_Part_In_Stock_API.Check_Individual_Exist(part_no_, serial_no_) = 0)) THEN
                        temp_serial_no_ := '*';
                     END IF;
                     Register_Arrival___(qty_on_order_diff_ => qty_on_order_diff_, 
                                         qty_reserved_      => qty_reserved_, 
                                         qty_received_      => least(rec_.qty_on_order, (qty_received_-qty_consumed_)),
                                         order_no_          => rec_.order_no, 
                                         line_no_           => rec_.line_no, 
                                         rel_no_            => rec_.rel_no, 
                                         line_item_no_      => rec_.line_item_no,
                                         contract_          => contract_, 
                                         part_no_           => part_no_, 
                                         configuration_id_  => configuration_id_,
                                         location_no_       => location_no_, 
                                         lot_batch_no_      => lot_batch_no_, 
                                         serial_no_         => temp_serial_no_, 
                                         eng_chg_level_     => eng_chg_level_, 
                                         waiv_dev_rej_no_   => waiv_dev_rej_no_,
                                         activity_seq_      => NVL(activity_seq_, 0), 
                                         handling_unit_id_  => handling_unit_id_,
                                         line_rec_          => line_rec_);
                     Update_License_Coverage_Qty___(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, qty_reserved_);                     
                     unit_meas_        := Inventory_Part_API.Get_Unit_Meas(contract_, part_no_);
                     message_text_     := Language_SYS.Translate_Constant(lu_name_, 'RECEIVED: Received from purchase order: :P1 :P2.', NULL,
                                                                          to_char(qty_reserved_), unit_meas_);
                     qty_consumed_     := qty_consumed_ + qty_reserved_;
                     con_qty_on_order_ := rec_.qty_on_order + qty_on_order_diff_;
                  END IF;
                  
                  IF (line_rec_.catalog_type = 'NON' OR comp_catalog_type_ = 'NON') THEN
                     temp_con_qty_on_order_ := con_qty_on_order_;
                  ELSE
                     temp_con_qty_on_order_ := qty_reserved_;
                  END IF;  

                  IF (qty_consumed_ > 0) THEN
                     Customer_Order_Line_Hist_API.New(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, message_text_);
                  END IF;

                  --Update the connection with the new qty_on_order.
                  IF (line_rec_.supply_code IN ('IO', 'PT', 'IPT','PS')) AND (temp_con_qty_on_order_ >0) THEN
                     Client_SYS.Clear_Attr(attr_);
                     Client_SYS.Add_To_Attr('QTY_ON_ORDER',con_qty_on_order_, attr_);
                     Customer_Order_Pur_Order_API.Modify(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no,
                                                         order_no_, line_no_, rel_no_, attr_);
                  END IF;
               END IF;
            END IF;
         END IF;
      ELSE
         Client_SYS.Add_Info(lu_name_, 'PARTOWNERSHPDIFFER: The pegged customer order line :P1 :P2 :P3 has different part ownership and thus will not be reserved automatically.',
                             rec_.order_no,
                             rec_.line_no,
                             rec_.rel_no);
      END IF;
   END LOOP;
END Consume_Peggings;


PROCEDURE Consume_So_Peggings (
   qty_consumed_     OUT NUMBER,
   order_no_         IN  VARCHAR2,
   release_no_       IN  VARCHAR2,
   sequence_no_      IN  VARCHAR2,
   contract_         IN  VARCHAR2,
   part_no_          IN  VARCHAR2,
   location_no_      IN  VARCHAR2,
   lot_batch_no_     IN  VARCHAR2,
   serial_no_        IN  VARCHAR2,
   eng_chg_level_    IN  VARCHAR2,
   waiv_dev_rej_no_  IN  VARCHAR2,
   qty_received_     IN  NUMBER,
   configuration_id_ IN  VARCHAR2,
   handling_unit_id_ IN  NUMBER )
IS
   CURSOR demand_rec IS
      SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no, cos.qty_on_order
      FROM customer_order_line_tab col,customer_order_shop_order_tab cos
      WHERE col.order_no       = cos.oe_order_no
      AND   col.line_no        = cos.oe_line_no
      AND   col.rel_no         = cos.oe_rel_no
      AND   col.line_item_no   = cos.oe_line_item_no
      AND   cos.so_order_no    = order_no_
      AND   cos.so_release_no  = release_no_
      AND   cos.so_sequence_no = sequence_no_
      ORDER BY col.planned_delivery_date;

   line_rec_          Customer_Order_Line_API.Public_Rec;
   qty_reserved_      NUMBER;
   qty_on_order_      NUMBER;
   con_qty_on_order_  NUMBER;
   rem_qty_           NUMBER;
   qty_on_order_diff_ NUMBER;
   unit_meas_         VARCHAR2(10);
   state_             VARCHAR2(30);
   message_text_      VARCHAR2(200);
   attr_              VARCHAR2(32000);
   temp_serial_no_    VARCHAR2(50);
BEGIN
   qty_consumed_ := 0;
   FOR rec_ IN demand_rec LOOP
       line_rec_ := Customer_Order_Line_API.Get(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
       state_    := Customer_Order_Line_API.Get_Objstate(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
       rem_qty_  := qty_received_ - qty_consumed_;
       IF (state_ != 'Cancelled') THEN
          IF qty_consumed_ <= qty_received_ THEN
             IF (line_rec_.catalog_type = 'NON') THEN
                -- Update CustomerOrderLine attributes
                Customer_Order_Line_API.Modify_Qty_To_Ship__(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, least(line_rec_.qty_on_order, (qty_received_-qty_consumed_)));
                qty_on_order_     := line_rec_.qty_on_order - (least(rec_.qty_on_order, (qty_received_-qty_consumed_)));
                Customer_Order_Line_API.Modify_Qty_On_Order(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, qty_on_order_);
                unit_meas_        := Sales_Part_API.Get_Sales_Unit_Meas(contract_, line_rec_.catalog_no);
                message_text_     := Language_SYS.Translate_Constant(lu_name_, 'RECEIVEDSO: Received from shop order: :P1 :P2.', NULL,
                                                                     to_char(least(line_rec_.qty_on_order, (qty_received_-qty_consumed_))), unit_meas_);
                qty_consumed_     := qty_consumed_ + least(rec_.qty_on_order, (qty_received_-qty_consumed_));
                con_qty_on_order_ := GREATEST(rec_.qty_on_order - (qty_received_-qty_consumed_), 0);
             ELSE
                temp_serial_no_ := serial_no_;
                IF ((serial_no_ != '*') AND (line_rec_.supply_code = 'IO') AND
                    (Inventory_Part_In_Stock_API.Check_Individual_Exist(part_no_, serial_no_) = 0)) THEN
                   temp_serial_no_ := '*';
                END IF;
                Register_Arrival___(qty_on_order_diff_ => qty_on_order_diff_, 
                                    qty_reserved_      => qty_reserved_, 
                                    qty_received_      => least(rec_.qty_on_order, (qty_received_-qty_consumed_)),
                                    order_no_          => rec_.order_no, 
                                    line_no_           => rec_.line_no, 
                                    rel_no_            => rec_.rel_no, 
                                    line_item_no_      => rec_.line_item_no,
                                    contract_          => contract_, 
                                    part_no_           => part_no_, 
                                    configuration_id_  => configuration_id_,
                                    location_no_       => location_no_, 
                                    lot_batch_no_      => lot_batch_no_, 
                                    serial_no_         => temp_serial_no_, 
                                    eng_chg_level_     => eng_chg_level_, 
                                    waiv_dev_rej_no_   => waiv_dev_rej_no_,
                                    activity_seq_      => 0, 
                                    handling_unit_id_  => handling_unit_id_,
                                    line_rec_          => line_rec_ );
                Update_License_Coverage_Qty___(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, qty_reserved_);
                unit_meas_        := Inventory_Part_API.Get_Unit_Meas(contract_, part_no_);
                message_text_     := Language_SYS.Translate_Constant(lu_name_, 'RECEIVEDSO: Received from shop order: :P1 :P2.', NULL,
                                                                     to_char(qty_reserved_), unit_meas_);
                qty_consumed_     := qty_consumed_ + qty_reserved_;
                con_qty_on_order_ := rec_.qty_on_order + qty_on_order_diff_;
             END IF;

             Customer_Order_Line_Hist_API.New(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, message_text_);

             --Update the connection with the new qty_on_order.
             IF (line_rec_.supply_code = 'IO') THEN
                Client_SYS.Clear_Attr(attr_);
                Client_SYS.Add_To_Attr('QTY_ON_ORDER',con_qty_on_order_, attr_);
                Customer_Order_Shop_Order_API.Modify(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no,
                                                     order_no_, release_no_, sequence_no_, attr_);
             END IF;
          END IF;
       END IF;
   END LOOP;
END Consume_So_Peggings;


-- Control_Ms_Mrp_Consumption
--   Generate a call to the MS or MRP module passing the current part,
--   old and new demand quantity and old and new planned due date.
--   This method should be called when order lines have been released or when
--   the demand quantity or planned due date has been changed.
PROCEDURE Control_Ms_Mrp_Consumption (
   result_code_             OUT VARCHAR2,
   available_qty_           OUT NUMBER,
   earliest_available_date_ OUT DATE,
   contract_                IN  VARCHAR2,
   part_no_                 IN  VARCHAR2,
   activity_seq_            IN  NUMBER,
   new_demand_qty_          IN  NUMBER,
   old_demand_qty_          IN  NUMBER,
   new_planned_due_date_    IN  DATE,
   old_planned_due_date_    IN  DATE,
   source_type_             IN  VARCHAR2,
   order_line_cancellation_ IN  BOOLEAN, 
   abnormal_demand_new_     IN  VARCHAR2,
   abnormal_demand_old_     IN  VARCHAR2 )
IS
BEGIN
   -- Online consumption is only supported for standard master scheduling.
   IF (activity_seq_ = 0) THEN
      -- If the MS module is installed the call to check consumption should be directed there, else
      -- consumption should be checked by MRP if this module is installed.
      $IF Component_Massch_SYS.INSTALLED $THEN
         Level_1_Forecast_Util_API.Control_Consumption(result_code_, available_qty_, earliest_available_date_, contract_, part_no_, new_demand_qty_, old_demand_qty_, 
                                                       trunc(new_planned_due_date_), trunc(old_planned_due_date_), source_type_, order_line_cancellation_, abnormal_demand_new_, abnormal_demand_old_ );
      $ELSIF Component_Mrp_SYS.INSTALLED $THEN  
         Spare_Part_Forecast_Util_API.Control_Consumption(result_code_, available_qty_, earliest_available_date_, contract_, part_no_, new_demand_qty_, old_demand_qty_, 
                                                          trunc(new_planned_due_date_), trunc(old_planned_due_date_), source_type_ );
      $ELSE
         NULL;
      $END
   END IF;
END Control_Ms_Mrp_Consumption;


-- Is_Supply_Chain_Reservation
--   Note: Return TRUE = 1 if the order/source line can/will use supply chain reservations
--   Note: Return FALSE = 0 if the order/source line will use only normal reservations
--   Return TRUE = 1 if the order/source line can/will use supply chain reservations
--   Return FALSE = 0 if the order/source line will use only normal reservations
--   Overloaded function
FUNCTION Is_Supply_Chain_Reservation (
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   source_id_          IN NUMBER,
   reservation_method_ IN VARCHAR2 ) RETURN NUMBER
IS
   line_rec_                    Customer_Order_Line_API.Public_Rec;
   source_rec_                  Sourced_Cust_Order_Line_API.Public_Rec;
   supply_site_                 VARCHAR2(5);
   source_default_reserve_type_ VARCHAR2(20);
BEGIN
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   IF (source_id_ IS NULL) THEN
      RETURN Is_Supply_Chain_Reservation(order_no_, line_no_, rel_no_, line_item_no_, source_id_, line_rec_.contract,
                                         line_rec_.supply_code, line_rec_.vendor_no, nvl(line_rec_.part_no, line_rec_.purchase_part_no),
                                         line_rec_.supply_site_reserve_type, reservation_method_);
   ELSE
      source_rec_  := Sourced_Cust_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_, source_id_);
      supply_site_ := Customer_Order_Line_API.Get_Vendor_Contract__(source_rec_.vendor_no, NULL, NULL, NULL, line_rec_.rental);
      IF (Site_To_Site_Reserve_Setup_API.Connection_Allowed(supply_site_, line_rec_.contract) = 1) THEN
         -- get default supply_site_reserve_type
         source_default_reserve_type_ := Site_To_Site_Reserve_Setup_API.Get_Supply_Site_Reserve_Db(supply_site_, line_rec_.contract);
      ELSE
         source_default_reserve_type_ := 'NOTALLOWED';
      END IF;
      RETURN Is_Supply_Chain_Reservation(order_no_, line_no_, rel_no_, line_item_no_, source_id_, line_rec_.contract,
                                         source_rec_.supply_code, source_rec_.vendor_no, nvl(line_rec_.part_no, line_rec_.purchase_part_no),
                                         source_default_reserve_type_, reservation_method_);
   END IF;
END Is_Supply_Chain_Reservation;


-- Is_Supply_Chain_Reservation
--   Note: Return TRUE = 1 if the order/source line can/will use supply chain reservations
--   Note: Return FALSE = 0 if the order/source line will use only normal reservations
--   Return TRUE = 1 if the order/source line can/will use supply chain reservations
--   Return FALSE = 0 if the order/source line will use only normal reservations
--   Overloaded function
FUNCTION Is_Supply_Chain_Reservation (
   order_no_                 IN VARCHAR2,
   line_no_                  IN VARCHAR2,
   rel_no_                   IN VARCHAR2,
   line_item_no_             IN NUMBER,
   source_id_                IN NUMBER,
   contract_                 IN VARCHAR2,
   supply_code_              IN VARCHAR2,
   vendor_no_                IN VARCHAR2,
   part_no_                  IN VARCHAR2,
   supply_site_reserve_type_ IN VARCHAR2,
   reservation_method_       IN VARCHAR2 ) RETURN NUMBER
IS
   supply_site_ VARCHAR2(5);
   rental_db_   VARCHAR2(5);   
BEGIN
   rental_db_ := Customer_Order_Line_API.Get_Rental_Db(order_no_, line_no_, rel_no_, line_item_no_);
   -- only Internal Purchase Direct or Internal Purchase Transfer are considered for supply chain reservations
   IF (supply_code_ = 'IPD' OR supply_code_ = 'IPT') THEN
      -- check if the inventory part exists on the supply_site (is the supply_site in the same database)
      supply_site_ := Customer_Order_Line_API.Get_Vendor_Contract__(vendor_no_, NULL, NULL, NULL, rental_db_);
      IF (Inventory_Part_API.Part_Exist(supply_site_, part_no_) = 1) THEN
         -- check if a security connection exists between the CO/PO Site (Demand site) and the Supply Site
         IF (Site_To_Site_Reserve_Setup_API.Connection_Allowed(supply_site_, contract_) = 1) THEN
            -- if reservation_method_ have no value we dont care what SupplySiteReservation method is used,
            -- so this is a Supply Chain Reservation as long as there is a reservation type != 'NOTALLOWED'
            IF (reservation_method_ IS NULL AND supply_site_reserve_type_ != 'NOTALLOWED') THEN
               -- This is a Supply Chain Reservation
               RETURN (1);
            -- check reservation_method_ is the same on the order/source line (either Manual or Instant)
            ELSIF (reservation_method_ = supply_site_reserve_type_ AND supply_site_reserve_type_ != 'NOTALLOWED') THEN
               -- This is a Supply Chain Reservation
               RETURN (1);
            END IF;
         END IF;
      END IF;
   END IF;
   -- This is not a Supply Chain Reservation
   RETURN (0);
END Is_Supply_Chain_Reservation;


PROCEDURE Transfer_Reservation (
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   line_item_no_    IN NUMBER,
   to_order_no_     IN VARCHAR2,
   to_line_no_      IN VARCHAR2,
   to_rel_no_       IN VARCHAR2,
   to_line_item_no_ IN NUMBER )
IS
   qty_assigned_          NUMBER := 0;
   new_qty_assigned_      NUMBER;
   
   CURSOR get_supp_res IS
      SELECT supply_site, part_no, configuration_id,
             location_no, lot_batch_no, serial_no,
             eng_chg_level, waiv_dev_rej_no, activity_seq, 
             handling_unit_id, qty_assigned
      FROM   co_supply_site_reservation
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   qty_assigned_ := NVL(Customer_Order_Line_API.Get_Qty_Assigned(to_order_no_, to_line_no_, to_rel_no_, to_line_item_no_),0);

   FOR rec_ IN get_supp_res LOOP
      -- Remove the supply site reservation record...
      Co_Supply_Site_Reservation_API.Remove(order_no_         => order_no_, 
                                            line_no_          => line_no_, 
                                            rel_no_           => rel_no_, 
                                            line_item_no_     => line_item_no_,
                                            supply_site_      => rec_.supply_site, 
                                            part_no_          => rec_.part_no, 
                                            configuration_id_ => rec_.configuration_id, 
                                            location_no_      => rec_.location_no,
                                            lot_batch_no_     => rec_.lot_batch_no, 
                                            serial_no_        => rec_.serial_no, 
                                            eng_chg_level_    => rec_.eng_chg_level, 
                                            waiv_dev_rej_no_  => rec_.waiv_dev_rej_no,
                                            activity_seq_     => rec_.activity_seq, 
                                            handling_unit_id_ => rec_.handling_unit_id);

      qty_assigned_ := qty_assigned_ + rec_.qty_assigned;

      -- ...to make way for a new/"real" reservation using the same reservation
      IF (Customer_Order_Reservation_API.Oe_Exist(order_no_         => to_order_no_, 
                                                  line_no_          => to_line_no_, 
                                                  rel_no_           => to_rel_no_, 
                                                  line_item_no_     => to_line_item_no_,
                                                  contract_         => rec_.supply_site, 
                                                  part_no_          => rec_.part_no, 
                                                  location_no_      => rec_.location_no, 
                                                  lot_batch_no_     => rec_.lot_batch_no,
                                                  serial_no_        => rec_.serial_no, 
                                                  eng_chg_level_    => rec_.eng_chg_level, 
                                                  waiv_dev_rej_no_  => rec_.waiv_dev_rej_no, 
                                                  activity_seq_     => 0, 
                                                  handling_unit_id_ => rec_.handling_unit_id,
                                                  pick_list_no_     => '*', 
                                                  configuration_id_ => rec_.configuration_id, 
                                                  shipment_id_      => 0) = 1) THEN

         -- add any qty_assigned already made by priority reservations (will only happen if the supply site reservation was not complete)
         new_qty_assigned_ := Customer_Order_Reservation_API.Get_Qty_Assigned(order_no_         => to_order_no_, 
                                                                              line_no_          => to_line_no_, 
                                                                              rel_no_           => to_rel_no_, 
                                                                              line_item_no_     => to_line_item_no_,
                                                                              contract_         => rec_.supply_site, 
                                                                              part_no_          => rec_.part_no, 
                                                                              location_no_      => rec_.location_no, 
                                                                              lot_batch_no_     => rec_.lot_batch_no,
                                                                              serial_no_        => rec_.serial_no, 
                                                                              eng_chg_level_    => rec_.eng_chg_level, 
                                                                              waiv_dev_rej_no_  => rec_.waiv_dev_rej_no, 
                                                                              activity_seq_     => 0, 
                                                                              handling_unit_id_ => rec_.handling_unit_id,
                                                                              configuration_id_ => rec_.configuration_id, 
                                                                              pick_list_no_     => '*', 
                                                                              shipment_id_      => 0) + rec_.qty_assigned;

         Customer_Order_Reservation_API.Modify_Qty_Assigned(order_no_              => to_order_no_, 
                                                            line_no_               => to_line_no_, 
                                                            rel_no_                => to_rel_no_, 
                                                            line_item_no_          => to_line_item_no_,
                                                            contract_              => rec_.supply_site, 
                                                            part_no_               => rec_.part_no, 
                                                            location_no_           => rec_.location_no, 
                                                            lot_batch_no_          => rec_.lot_batch_no,
                                                            serial_no_             => rec_.serial_no, 
                                                            eng_chg_level_         => rec_.eng_chg_level, 
                                                            waiv_dev_rej_no_       => rec_.waiv_dev_rej_no, 
                                                            activity_seq_          => 0,
                                                            handling_unit_id_      => rec_.handling_unit_id,
                                                            pick_list_no_          => '*', 
                                                            configuration_id_      => rec_.configuration_id, 
                                                            shipment_id_           => 0, 
                                                            qty_assigned_          => new_qty_assigned_, 
                                                            input_qty_             => NULL, 
                                                            input_unit_meas_       => NULL, 
                                                            input_conv_factor_     => NULL, 
                                                            input_variable_values_ => NULL);
      ELSE
         Customer_Order_Reservation_API.New(order_no_                 => to_order_no_, 
                                            line_no_                  => to_line_no_, 
                                            rel_no_                   => to_rel_no_, 
                                            line_item_no_             => to_line_item_no_,
                                            contract_                 => rec_.supply_site, 
                                            part_no_                  => rec_.part_no, 
                                            location_no_              => rec_.location_no, 
                                            lot_batch_no_             => rec_.lot_batch_no,
                                            serial_no_                => rec_.serial_no, 
                                            eng_chg_level_            => rec_.eng_chg_level, 
                                            waiv_dev_rej_no_          => rec_.waiv_dev_rej_no, 
                                            activity_seq_             => 0,
                                            handling_unit_id_         => rec_.handling_unit_id,
                                            pick_list_no_             => '*', 
                                            configuration_id_         => rec_.configuration_id, 
                                            shipment_id_              => 0, 
                                            qty_assigned_             => rec_.qty_assigned, 
                                            qty_picked_               => 0, 
                                            qty_shipped_              => 0, 
                                            input_qty_                => NULL, 
                                            input_unit_meas_          => NULL, 
                                            input_conv_factor_        => NULL, 
                                            input_variable_values_    => NULL, 
                                            preliminary_pick_list_no_ => NULL, 
                                            catch_qty_                => NULL);
      END IF;
   END LOOP;
   -- add/modify qty_assigned to the internal order
   Customer_Order_API.Set_Line_Qty_Assigned(to_order_no_, to_line_no_, to_rel_no_, to_line_item_no_, qty_assigned_);
END Transfer_Reservation;


-- Is_Manual_Pl_Pick_Confirmed
--    Check whether Manual Consolidate Pick List has completely picked.
@UncheckedAccess
FUNCTION Is_Manual_Pl_Pick_Confirmed (
   preliminary_pick_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
   dummy_ NUMBER;
   exist_ VARCHAR2(5) := 'FALSE';
   
   CURSOR check_fully_picked IS
      SELECT 1
      FROM customer_order_reservation_tab cor
      WHERE cor.preliminary_pick_list_no = preliminary_pick_list_no_ 
      AND EXISTS (SELECT copl.pick_list_no
                    FROM customer_order_pick_list_tab copl 
                   WHERE copl.picking_confirmed = 'UNPICKED'
                     AND copl.pick_list_no = cor.pick_list_no);
BEGIN
   OPEN check_fully_picked;
   FETCH check_fully_picked INTO dummy_;
   IF (check_fully_picked%NOTFOUND) THEN
      exist_ := 'TRUE';
   END IF;   
   CLOSE check_fully_picked;
   RETURN exist_;
END Is_Manual_Pl_Pick_Confirmed;
   
   
-- Get_No_Of_Packages_Reserved
--   Return the Total No of Packages fully reseved for a given package part.
@UncheckedAccess
FUNCTION Get_No_Of_Packages_Reserved (
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2,
   rel_no_   IN VARCHAR2 ) RETURN NUMBER
IS
   no_of_packages_reserved_  NUMBER;
   revised_qty_due_          NUMBER;

   -- Get the minimum reserved quantity relative to the package part on a component line.
   CURSOR get_min_packages_reserved IS
      SELECT NVL(MIN(TRUNC(DECODE(part_no, NULL, qty_to_ship, qty_assigned)/(revised_qty_due/revised_qty_due_))),0)
      FROM   customer_order_line_tab
      WHERE  order_no      =  order_no_
      AND    line_no       =  line_no_
      AND    rel_no        =  rel_no_
      AND    line_item_no  >  0
      AND    rowstate     != 'Cancelled'
      AND    supply_code  NOT IN ('PD', 'IPD');
BEGIN
   -- Get pacakage parts revised quantity due
   revised_qty_due_ := Customer_Order_Line_API.Get_Revised_Qty_Due(order_no_, line_no_, rel_no_, -1);

   OPEN  get_min_packages_reserved;
   FETCH get_min_packages_reserved INTO no_of_packages_reserved_;
   CLOSE get_min_packages_reserved;

   RETURN no_of_packages_reserved_;
END Get_No_Of_Packages_Reserved;



-- Validate_Params
--   This procedure is calling when running the Scehdule Create Picking Proposal
--   for Customer Orders.
PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_       NUMBER;
   name_arr_    Message_SYS.name_table;
   value_arr_   Message_SYS.line_table;
   contract_    VARCHAR2(5);
   coordinator_ VARCHAR2(20);
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := NVL(value_arr_(n_), '%');
      END IF;
      IF (name_arr_(n_) = 'COORDINATOR') THEN
         coordinator_  := NVL(value_arr_(n_), '%');
      END IF;
   END LOOP;

   IF ((contract_ IS NOT NULL) AND (contract_ != '%')) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;
   IF ((coordinator_ IS NOT NULL) AND (coordinator_ != '%')) THEN
      Order_Coordinator_API.Exist(coordinator_, true);
   END IF;
END Validate_Params;


-- Get_Min_Due_Date_For_Unpicked
--   This will return earliest planned due date of all the lines the order has,
--   which are in status reserved and the pick list is still not created.
@UncheckedAccess
FUNCTION Get_Min_Due_Date_For_Unpicked (
   order_no_ IN VARCHAR2 ) RETURN DATE
IS
   planned_due_date_ CUSTOMER_ORDER_LINE_TAB.planned_due_Date%TYPE;

   CURSOR get_due_date IS
      SELECT MIN(t.planned_due_Date)
        FROM CUSTOMER_ORDER_LINE_TAB t ,CUSTOMER_ORDER_RESERVATION_TAB r
       WHERE r.order_no     = t.order_no
         AND r.line_no      = t.line_no
         AND r.rel_no       = t.rel_no
         AND r.line_item_no = t.line_item_no
         AND r.pick_list_no = '*'
         AND r.shipment_id  = 0
         AND r.order_no     = order_no_;
BEGIN
   OPEN get_due_date;
   FETCH get_due_date INTO planned_due_date_;
   CLOSE get_due_date;
   RETURN trunc(planned_due_date_);
END Get_Min_Due_Date_For_Unpicked;



-- Get_Min_Ship_Date_For_Unpicked
--   This will return earliest planned ship date of all the lines the order has,
--   which are in status reserved and the pick list is still not created.
@UncheckedAccess
FUNCTION Get_Min_Ship_Date_For_Unpicked (
   order_no_ IN VARCHAR2 ) RETURN DATE
IS
   planned_ship_date_ CUSTOMER_ORDER_LINE_TAB.planned_ship_date%TYPE;

   CURSOR get_ship_date IS
      SELECT MIN(t.planned_ship_Date)
       FROM  CUSTOMER_ORDER_LINE_TAB t ,CUSTOMER_ORDER_RESERVATION_TAB r
      WHERE  r.order_no     = t.order_no
        AND  r.line_no      = t.line_no
        AND  r.rel_no       = t.rel_no
        AND  r.line_item_no = t.line_item_no
        AND  r.pick_list_no = '*'
        AND  r.shipment_id  = 0
        AND  r.order_no     = order_no_;
BEGIN
   OPEN get_ship_date;
   FETCH get_ship_date INTO planned_ship_date_;
   CLOSE get_ship_date;
   RETURN planned_ship_date_;
END Get_Min_Ship_Date_For_Unpicked;


-- Is_Pick_List_Created
--   Returns 1 if no pick list has created for the reservation done.
@UncheckedAccess
FUNCTION Is_Pick_List_Created (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   created_  NUMBER;
   CURSOR cre_pick IS
      SELECT 1
        FROM customer_order_reservation_tab cor
       WHERE cor.order_no     = order_no_
         AND cor.line_no      = line_no_
         AND cor.rel_no       = rel_no_
         AND cor.line_item_no = line_item_no_
         AND cor.pick_list_no != '*';
BEGIN
   OPEN cre_pick;
   FETCH cre_pick INTO created_;
   IF (cre_pick%NOTFOUND) THEN
      created_ := 0;
   END IF;
   CLOSE cre_pick;
   RETURN created_;
END Is_Pick_List_Created;


-- Unconsume_Peggings
--   This method is called from PURCH when cancelling a PO receipt in order to check if the
--   quantities of the CO can be adjusted accordingly, and if can, do the actual adjustments.
--   If can't, raise relevant error/info messages.
PROCEDURE Unconsume_Peggings (
   qty_unconsumed_   OUT NUMBER,
   order_no_         IN  VARCHAR2,
   line_no_          IN  VARCHAR2,
   rel_no_           IN  VARCHAR2,
   contract_         IN  VARCHAR2,
   part_no_          IN  VARCHAR2,
   location_no_      IN  VARCHAR2,
   lot_batch_no_     IN  VARCHAR2,
   serial_no_        IN  VARCHAR2,
   eng_chg_level_    IN  VARCHAR2,
   waiv_dev_rej_no_  IN  VARCHAR2,
   configuration_id_ IN  VARCHAR2,
   condition_code_   IN  VARCHAR2,
   handling_unit_id_ IN  NUMBER,
   qty_unreceived_   IN  NUMBER )
IS
   qty_on_order_       NUMBER;
   qty_unreserved_     NUMBER;
   qty_on_order_diff_  NUMBER;
   co_line_rec_        Customer_Order_Line_API.Public_Rec;
   part_rec_           Inventory_Part_In_Stock_API.Public_Rec;
   line_own_vend_no_   VARCHAR2(10);
   attr_               VARCHAR2(2000);
   comp_catalog_type_  VARCHAR2(4);
   unit_meas_          VARCHAR2(10);
   message_text_       VARCHAR2(200);
   co_pegging_updated_ BOOLEAN;

   CURSOR get_connected_lines IS
      SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no, col.rowstate,
             col.supply_code, col.condition_code, col.catalog_no, col.catalog_type, col.part_ownership, col.owning_customer_no,
             col.qty_to_ship, col.qty_on_order col_qty_on_order, col.shipment_connected, copo.qty_on_order copo_qty_on_order, col.activity_seq
      FROM customer_order_line_tab col, customer_order_pur_order_tab copo
      WHERE col.order_no = copo.oe_order_no
      AND   col.line_no = copo.oe_line_no
      AND   col.rel_no = copo.oe_rel_no
      AND   col.line_item_no = copo.oe_line_item_no
      AND   copo.po_order_no = order_no_
      AND   copo.po_line_no = line_no_
      AND   copo.po_rel_no =  rel_no_
      AND   copo.purchase_type = 'O'
      ORDER BY col.planned_delivery_date DESC;
BEGIN
   qty_unconsumed_     := 0;
   co_pegging_updated_ := FALSE;
   FOR line_rec_ IN get_connected_lines LOOP
      IF (line_rec_.rowstate != 'Cancelled') THEN
         IF (line_rec_.catalog_type = 'KOMP') THEN
            IF (Sales_Part_Type_API.Encode(Sales_Part_API.Get_Catalog_Type(contract_, line_rec_.catalog_no)) = 'NON') THEN
               comp_catalog_type_ := 'NON';
            END IF;
         END IF;

         IF ((line_rec_.catalog_type = 'NON') OR (comp_catalog_type_ = 'NON')) THEN
            IF (qty_unreceived_ <= line_rec_.qty_to_ship) THEN
               IF (line_rec_.shipment_connected = 'TRUE') THEN
                  Shipment_Line_API.Unreserve_Non_Inventory(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no,
                                                            line_rec_.line_item_no, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, qty_unreceived_);
               END IF;
               Customer_Order_Line_API.Modify_Qty_To_Ship__(line_rec_.order_no,
                                                            line_rec_.line_no,
                                                            line_rec_.rel_no,
                                                            line_rec_.line_item_no,
                                                            (line_rec_.qty_to_ship - qty_unreceived_));
               qty_unconsumed_     := qty_unreceived_;
               qty_on_order_       := line_rec_.col_qty_on_order + qty_unreceived_;
               Customer_Order_Line_API.Modify_Qty_On_Order(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no, qty_on_order_);
               unit_meas_          := Sales_Part_API.Get_Sales_Unit_Meas(contract_, line_rec_.catalog_no);
               co_pegging_updated_ := TRUE;
            END IF;
         ELSE
            IF (qty_unconsumed_ < qty_unreceived_) THEN
               part_rec_ := Inventory_Part_In_Stock_API.Get(contract_         => contract_,
                                                            part_no_          => part_no_,
                                                            configuration_id_ => configuration_id_,
                                                            location_no_      => location_no_,
                                                            lot_batch_no_     => lot_batch_no_,
                                                            serial_no_        => serial_no_,
                                                            eng_chg_level_    => eng_chg_level_,
                                                            waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                            activity_seq_     => line_rec_.activity_seq, 
                                                            handling_unit_id_ => handling_unit_id_);
               IF (line_rec_.part_ownership = 'SUPPLIER LOANED') THEN
                  line_own_vend_no_ := Customer_Order_Line_API.Get_Owner_For_Part_Ownership(line_rec_.order_no,
                                                                                            line_rec_.line_no,
                                                                                            line_rec_.rel_no,
                                                                                            line_rec_.line_item_no,
                                                                                            line_rec_.part_ownership);
               END IF;
               
               IF (part_rec_.part_ownership IS NULL) THEN
                  part_rec_.part_ownership := 'COMPANY OWNED';
               END IF;
               IF (((line_rec_.part_ownership = 'COMPANY OWNED') AND ((part_rec_.part_ownership = 'COMPANY OWNED') OR (part_rec_.part_ownership = 'CONSIGNMENT'))) OR
                   ((line_rec_.part_ownership = 'CUSTOMER OWNED') AND (part_rec_.part_ownership = 'CUSTOMER OWNED') AND (part_rec_.owning_customer_no = line_rec_.owning_customer_no)) OR
                   ((line_rec_.part_ownership = 'SUPPLIER LOANED') AND (part_rec_.part_ownership = 'SUPPLIER LOANED') AND (part_rec_.owning_vendor_no = line_own_vend_no_))) THEN
                  IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(part_no_) = 'NOT_ALLOW_COND_CODE') OR (line_rec_.condition_code = condition_code_) THEN
                     co_line_rec_ := Customer_Order_Line_API.Get(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);

                     Unregister_Arrival___(qty_on_order_diff_ => qty_on_order_diff_,
                                           qty_reserved_      => qty_unreserved_,
                                           qty_received_      => (-1) * qty_unreceived_,
                                           order_no_          => line_rec_.order_no,
                                           line_no_           => line_rec_.line_no,
                                           rel_no_            => line_rec_.rel_no,
                                           line_item_no_      => line_rec_.line_item_no,
                                           contract_          => contract_,
                                           part_no_           => part_no_,
                                           configuration_id_  => configuration_id_,
                                           location_no_       => location_no_,
                                           lot_batch_no_      => lot_batch_no_,
                                           serial_no_         => serial_no_,
                                           eng_chg_level_     => eng_chg_level_,
                                           waiv_dev_rej_no_   => waiv_dev_rej_no_,
                                           activity_seq_      => line_rec_.activity_seq,
                                           handling_unit_id_  => handling_unit_id_,
                                           line_rec_          => co_line_rec_);
                     Update_License_Coverage_Qty___(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no, qty_unreserved_);
                     qty_on_order_diff_  := NVL(qty_on_order_diff_, 0);
                     qty_unconsumed_     := qty_unconsumed_ + (-1) * qty_unreserved_;
                     qty_on_order_       := co_line_rec_.qty_on_order + qty_on_order_diff_;
                     unit_meas_          := Inventory_Part_API.Get_Unit_Meas(contract_, part_no_);
                     co_pegging_updated_ := TRUE;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;

      IF (co_pegging_updated_) THEN
         message_text_ := Language_SYS.Translate_Constant(lu_name_, 'RECEIPT_CANCELLED: Purchase order receipt was cancelled: :P1 :P2.',
                                                          NULL, qty_unconsumed_, unit_meas_);
         Customer_Order_Line_Hist_API.New(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no, message_text_);

         IF (line_rec_.supply_code IN ('IO', 'PT', 'IPT')) THEN
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('QTY_ON_ORDER', qty_on_order_, attr_);
            Customer_Order_Pur_Order_API.Modify(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no,
                                                order_no_, line_no_, rel_no_, attr_);
         END IF;
         co_pegging_updated_ := FALSE;
         unit_meas_ := NULL;
      END IF;
   END LOOP;
END Unconsume_Peggings;


FUNCTION Package_Partially_Reserved (
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2,
   rel_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   pkg_qty_picked_     NUMBER;
   pkg_qty_to_pick_    NUMBER;
   pkg_qty_to_finish_  NUMBER;
   partially_reserved_ VARCHAR2(5);
BEGIN
   Check_Reserve_Package___(pkg_qty_picked_, pkg_qty_to_pick_, pkg_qty_to_finish_,
                            order_no_, line_no_, rel_no_);
   IF (pkg_qty_to_pick_ = 0 AND pkg_qty_to_finish_= 0) THEN
      partially_reserved_ := 'FALSE';
   ELSE
      partially_reserved_ := 'TRUE';
   END IF;
   RETURN partially_reserved_;
END Package_Partially_Reserved;


PROCEDURE Check_Package_Reservations (
   pkgs_res_or_shipped_       OUT NUMBER,
   excess_reservations_exist_ OUT BOOLEAN,
   order_no_                  IN  VARCHAR2,
   line_no_                   IN  VARCHAR2,
   rel_no_                    IN  VARCHAR2 )
IS
   pkg_qty_picked_    NUMBER;
   pkg_qty_to_pick_   NUMBER;
   pkg_qty_to_finish_ NUMBER;
BEGIN
   -- Find out how much of the package that has been reserved or shipped. Consider what has been
   -- shipped so far as well. The objective is to avoid having shipped partial packages.
   excess_reservations_exist_ := FALSE;

   Check_Reserve_Package___(pkg_qty_picked_, pkg_qty_to_pick_, pkg_qty_to_finish_,
                            order_no_, line_no_, rel_no_);

   IF (pkg_qty_to_finish_ > 0) THEN
      -- Excess quantity exists for one or more components
      excess_reservations_exist_ := TRUE;
   END IF;

   pkgs_res_or_shipped_ := pkg_qty_picked_;
END Check_Package_Reservations;

@UncheckedAccess
FUNCTION Check_Man_Reservation_Valid(
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN VARCHAR2,
   part_ownership_db_  IN VARCHAR2,
   owning_customer_no_ IN VARCHAR2,
   owning_vendor_no_   IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_line_rec_   CUSTOMER_ORDER_LINE_API.Public_Rec;
   result_  VARCHAR2(5);
BEGIN
   order_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   result_ := Man_Res_Valid_Ownership___(order_no_,
                                         line_no_,
                                         rel_no_,
                                         line_item_no_,
                                         part_ownership_db_,
                                         owning_customer_no_,
                                         owning_vendor_no_,
                                         order_line_rec_);
   IF result_ = 'TRUE' THEN
      result_ := Man_Res_Valid_Ext_Service___(order_no_,
                                              line_no_,
                                              rel_no_,
                                              line_item_no_,
                                              lot_batch_no_,
                                              serial_no_,
                                              order_line_rec_);
   END IF;
   RETURN result_;
END Check_Man_Reservation_Valid;

PROCEDURE Split_Package_Reservations (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   pkg_to_pick_         IN NUMBER )
IS
   CURSOR get_pkg_components IS
      SELECT line_item_no, revised_qty_due, qty_shipped, qty_assigned
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    line_item_no > 0
      AND    rowstate != 'Cancelled';

   CURSOR get_comp_reservations (line_item_no_ IN NUMBER) IS
      SELECT cor.contract, part_no, location_no,
             lot_batch_no, serial_no, waiv_dev_rej_no,
             eng_chg_level, cor.pick_list_no,
             configuration_id, activity_seq, handling_unit_id,
             cor.shipment_id, qty_assigned,
             cor.pick_by_choice_blocked
       FROM customer_order_reservation_tab cor,
            customer_order_pick_list_tab cop
      WHERE cor.order_no     = order_no_
        AND cor.line_no      = line_no_
        AND cor.rel_no       = rel_no_
        AND cor.line_item_no = line_item_no_
        AND cor.qty_picked   = 0
        AND cor.qty_shipped  = 0
        AND cor.pick_list_no = cop.pick_list_no
        AND cop.printed_flag = 'N'
      ORDER BY cor.pick_list_no DESC;

   pkg_revised_qty_due_ NUMBER;
   excess_qty_assigned_ NUMBER;
   qty_per_pkg_         NUMBER;
   new_qty_assigned_    NUMBER;
   qty_assigned_        NUMBER;
   
BEGIN
   pkg_revised_qty_due_       := Customer_Order_Line_API.Get_Revised_Qty_Due(order_no_, line_no_, rel_no_, -1);
   Inventory_Event_Manager_API.Start_Session;

   FOR next_comp_ IN get_pkg_components LOOP
      -- Loop over the reservations and create a split if needed
      -- Note that when splitting if input units have been specified on the original reservation record
      -- these will have to be cleared on both the original reservation record and on the
      -- new record created.
      qty_per_pkg_         := next_comp_.revised_qty_due / pkg_revised_qty_due_;

      -- Check if there are excess reservations for this component
      excess_qty_assigned_ := (next_comp_.qty_assigned + next_comp_.qty_shipped) -
                              (pkg_to_pick_ * qty_per_pkg_);

      IF (excess_qty_assigned_ > 0) THEN
         FOR next_res_ IN get_comp_reservations (next_comp_.line_item_no)LOOP
            IF (excess_qty_assigned_ = next_res_.qty_assigned) THEN
               -- set the pick_list_no back to '*'
               Customer_Order_Reservation_API.Clear_Pick_List_No(order_no_             => order_no_, 
                                                                 line_no_              => line_no_, 
                                                                 rel_no_               => rel_no_,
                                                                 line_item_no_         => next_comp_.line_item_no,
                                                                 contract_             => next_res_.contract,
                                                                 part_no_              => next_res_.part_no,
                                                                 location_no_          => next_res_.location_no,
                                                                 lot_batch_no_         => next_res_.lot_batch_no,
                                                                 serial_no_            => next_res_.serial_no,
                                                                 eng_chg_level_        => next_res_.eng_chg_level,
                                                                 waiv_dev_rej_no_      => next_res_.waiv_dev_rej_no,
                                                                 activity_seq_         => next_res_.activity_seq,
                                                                 handling_unit_id_     => next_res_.handling_unit_id,
                                                                 pick_list_no_         => next_res_.pick_list_no,
                                                                 configuration_id_     => next_res_.configuration_id,
                                                                 shipment_id_          => next_res_.shipment_id,
                                                                 excess_qty_assigned_  => next_res_.qty_assigned);
               excess_qty_assigned_ := 0;
               EXIT;
            ELSIF (excess_qty_assigned_ > next_res_.qty_assigned) THEN
               -- Set pick_list_no to '*' and continue with the next reservation
               Customer_Order_Reservation_API.Clear_Pick_List_No(order_no_             => order_no_, 
                                                                 line_no_              => line_no_, 
                                                                 rel_no_               => rel_no_,
                                                                 line_item_no_         => next_comp_.line_item_no,
                                                                 contract_             => next_res_.contract,
                                                                 part_no_              => next_res_.part_no,
                                                                 location_no_          => next_res_.location_no,
                                                                 lot_batch_no_         => next_res_.lot_batch_no,
                                                                 serial_no_            => next_res_.serial_no,
                                                                 eng_chg_level_        => next_res_.eng_chg_level,
                                                                 waiv_dev_rej_no_      => next_res_.waiv_dev_rej_no,
                                                                 activity_seq_         => next_res_.activity_seq,
                                                                 handling_unit_id_     => next_res_.handling_unit_id,
                                                                 pick_list_no_         => next_res_.pick_list_no,
                                                                 configuration_id_     => next_res_.configuration_id,
                                                                 shipment_id_          => next_res_.shipment_id,
                                                                 excess_qty_assigned_  => next_res_.qty_assigned);

               excess_qty_assigned_ := excess_qty_assigned_ - next_res_.qty_assigned;
            ELSE
                  new_qty_assigned_ := next_res_.qty_assigned - excess_qty_assigned_;
                  -- Split the current reservation record into two
                  -- one connected to the pick list and one new with pick_list_no_ = '*'
                  Customer_Order_Reservation_API.Modify_Qty_Assigned(order_no_               => order_no_,
                                                                     line_no_                => line_no_,
                                                                     rel_no_                 => rel_no_,
                                                                     line_item_no_           => next_comp_.line_item_no,
                                                                     contract_               => next_res_.contract,
                                                                     part_no_                => next_res_.part_no,
                                                                     location_no_            => next_res_.location_no,
                                                                     lot_batch_no_           => next_res_.lot_batch_no,
                                                                     serial_no_              => next_res_.serial_no,
                                                                     eng_chg_level_          => next_res_.eng_chg_level,
                                                                     waiv_dev_rej_no_        => next_res_.waiv_dev_rej_no,
                                                                     activity_seq_           => next_res_.activity_seq,
                                                                     handling_unit_id_       => next_res_.handling_unit_id,
                                                                     pick_list_no_           => next_res_.pick_list_no,
                                                                     configuration_id_       => next_res_.configuration_id,
                                                                     shipment_id_            => next_res_.shipment_id,
                                                                     qty_assigned_           => new_qty_assigned_,
                                                                     input_qty_              => NULL,
                                                                     input_unit_meas_        => NULL,
                                                                     input_conv_factor_      => NULL,
                                                                     input_variable_values_  => NULL);

                  IF Customer_Order_Reservation_API.Oe_Exist(order_no_           => order_no_, 
                                                             line_no_            => line_no_, 
                                                             rel_no_             => rel_no_,
                                                             line_item_no_       => next_comp_.line_item_no,
                                                             contract_           => next_res_.contract,
                                                             part_no_            => next_res_.part_no,
                                                             location_no_        => next_res_.location_no,
                                                             lot_batch_no_       => next_res_.lot_batch_no,
                                                             serial_no_          => next_res_.serial_no,
                                                             eng_chg_level_      => next_res_.eng_chg_level,
                                                             waiv_dev_rej_no_    => next_res_.waiv_dev_rej_no,
                                                             activity_seq_       => next_res_.activity_seq,
                                                             handling_unit_id_   => next_res_.handling_unit_id,
                                                             pick_list_no_       => '*',
                                                             configuration_id_   => next_res_.configuration_id,
                                                             shipment_id_        => next_res_.shipment_id) = 1 THEN
                     
                     qty_assigned_ := Customer_Order_Reservation_API.Get_Qty_Assigned(order_no_          => order_no_, 
                                                                                      line_no_           => line_no_, 
                                                                                      rel_no_            => rel_no_,
                                                                                      line_item_no_      => next_comp_.line_item_no,
                                                                                      contract_          => next_res_.contract,
                                                                                      part_no_           => next_res_.part_no,
                                                                                      location_no_       => next_res_.location_no,
                                                                                      lot_batch_no_      => next_res_.lot_batch_no,
                                                                                      serial_no_         => next_res_.serial_no,
                                                                                      eng_chg_level_     => next_res_.eng_chg_level,
                                                                                      waiv_dev_rej_no_   => next_res_.waiv_dev_rej_no,
                                                                                      activity_seq_      => next_res_.activity_seq,
                                                                                      handling_unit_id_  => next_res_.handling_unit_id,
                                                                                      configuration_id_  => next_res_.configuration_id,
                                                                                      pick_list_no_      => '*',                                                                                      
                                                                                      shipment_id_       => next_res_.shipment_id);
                     
                     Customer_Order_Reservation_API.Modify_Qty_Assigned(order_no_              => order_no_,
                                                                        line_no_               => line_no_,
                                                                        rel_no_                => rel_no_,
                                                                        line_item_no_          => next_comp_.line_item_no,
                                                                        contract_              => next_res_.contract,
                                                                        part_no_               => next_res_.part_no,
                                                                        location_no_           => next_res_.location_no,
                                                                        lot_batch_no_          => next_res_.lot_batch_no,
                                                                        serial_no_             => next_res_.serial_no,
                                                                        eng_chg_level_         => next_res_.eng_chg_level,
                                                                        waiv_dev_rej_no_       => next_res_.waiv_dev_rej_no,
                                                                        activity_seq_          => next_res_.activity_seq,
                                                                        handling_unit_id_      => next_res_.handling_unit_id,
                                                                        pick_list_no_          => '*',
                                                                        configuration_id_      => next_res_.configuration_id,
                                                                        shipment_id_           => next_res_.shipment_id,
                                                                        qty_assigned_          => excess_qty_assigned_ + qty_assigned_,
                                                                        input_qty_             => NULL,
                                                                        input_unit_meas_       => NULL,
                                                                        input_conv_factor_     => NULL,
                                                                        input_variable_values_ => NULL);
                  ELSE
                     Customer_Order_Reservation_API.New(order_no_                 => order_no_, 
                                                        line_no_                  => line_no_, 
                                                        rel_no_                   => rel_no_,
                                                        line_item_no_             => next_comp_.line_item_no,
                                                        contract_                 => next_res_.contract,
                                                        part_no_                  => next_res_.part_no,
                                                        location_no_              => next_res_.location_no,
                                                        lot_batch_no_             => next_res_.lot_batch_no,
                                                        serial_no_                => next_res_.serial_no,
                                                        eng_chg_level_            => next_res_.eng_chg_level,
                                                        waiv_dev_rej_no_          => next_res_.waiv_dev_rej_no,
                                                        activity_seq_             => next_res_.activity_seq,
                                                        handling_unit_id_         => next_res_.handling_unit_id,
                                                        pick_list_no_             => '*',
                                                        configuration_id_         => next_res_.configuration_id,
                                                        shipment_id_              => next_res_.shipment_id,
                                                        qty_assigned_             => excess_qty_assigned_,
                                                        qty_picked_               => 0,
                                                        qty_shipped_              => 0,
                                                        input_qty_                => NULL,
                                                        input_unit_meas_          => NULL,
                                                        input_conv_factor_        => NULL,
                                                        input_variable_values_    => NULL,
                                                        preliminary_pick_list_no_ => NULL,
                                                        catch_qty_                => NULL,
                                                        pick_by_choice_blocked_   => next_res_.pick_by_choice_blocked);
                  END IF;

                  excess_qty_assigned_ := 0;
                  EXIT;
            END IF;
         END LOOP;

         -- If a component had only package reservations which could not be split
         IF (excess_qty_assigned_ > 0) THEN
            Error_SYS.Record_General(lu_name_, 'NORESSPLIT: Excess package component reservations for customer order line :P1 :P2 :P3 must be manually removed before creating pick list',
                                     order_no_, line_no_, rel_no_ );
         END IF;
      END IF;
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Split_Package_Reservations;


-- Get_Full_Reserved_Pkg_Qty
--   Returns the number of reserved packages that are not yet picked.
FUNCTION Get_Full_Reserved_Pkg_Qty (
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   loctaion_group_ IN VARCHAR2,
   warehouse_      IN VARCHAR2 DEFAULT NULL,
   pick_list_no_   IN VARCHAR2 DEFAULT '*' ) RETURN NUMBER
IS
   reserved_qty_     NUMBER;
   qty_to_pick_      NUMBER := 99999999999999;
   qty_in_pick_list_ NUMBER := 0;
   qty_in_sum_       NUMBER;
   
   CURSOR get_qty_from_component IS
      SELECT DECODE(supply_code, 'NO', qty_to_ship, qty_assigned) qty_assigned,
             line_item_no, qty_per_assembly, inverted_conv_factor, conv_factor
      FROM   customer_order_line_tab
      WHERE  supply_code IN ('IO', 'SO', 'PT', 'NO', 'IPT','PS')
      AND    rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND    (revised_qty_due != qty_picked + qty_shipped)
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      ORDER BY line_item_no;
      
   CURSOR get_qty_in_picklist(line_item_no_ IN NUMBER, location_group_ IN VARCHAR2) IS
      SELECT SUM(qty_assigned)
      FROM   customer_order_reservation_tab c, warehouse_bay_bin_tab w
      WHERE  c.contract = w.contract
      AND    c.location_no = w.location_no
      AND    c.order_no = order_no_
      AND    c.line_no = line_no_
      AND    c.rel_no = rel_no_
      AND    c.line_item_no = line_item_no_
      AND    w.location_group = location_group_
      AND    (w.warehouse_id = warehouse_ OR warehouse_ IS NULL)
      AND    c.pick_list_no NOT IN (pick_list_no_, '*'); -- Need to skip the records having '*' and the passed pick_list_no if both are there. 
      
   -- This will find what are the multiple location groups that the reservation has been made.
   CURSOR get_location_group(line_item_no_ IN NUMBER) IS
      SELECT DISTINCT Inventory_Location_API.Get_Location_Group(contract, location_no) location_group
      FROM   customer_order_reservation_tab 
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    pick_list_no NOT IN (pick_list_no_, '*');
BEGIN
   FOR comp_rec IN get_qty_from_component LOOP
      qty_in_pick_list_ := 0;
      FOR loc_rec IN get_location_group(comp_rec.line_item_no) LOOP
         OPEN get_qty_in_picklist(comp_rec.line_item_no, loc_rec.location_group);
         FETCH get_qty_in_picklist INTO qty_in_sum_;
         CLOSE get_qty_in_picklist;
         qty_in_pick_list_ := qty_in_pick_list_ + NVL(qty_in_sum_, 0);
      END LOOP;
      reserved_qty_ := comp_rec.qty_assigned - NVL(qty_in_pick_list_, 0);
      qty_to_pick_  := LEAST(qty_to_pick_,
                       FLOOR((reserved_qty_* comp_rec.inverted_conv_factor/comp_rec.conv_factor)/comp_rec.qty_per_assembly));

   END LOOP;
   RETURN qty_to_pick_;
END Get_Full_Reserved_Pkg_Qty;


-- Get_Available_Qty
--   Returns available quantity for a part.
@UncheckedAccess
FUNCTION Get_Available_Qty (
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   rel_no_                  IN VARCHAR2,
   line_item_no_            IN NUMBER,
   supply_code_db_          IN VARCHAR2,
   part_ownership_db_       IN VARCHAR2,
   owning_customer_no_      IN VARCHAR2,
   project_id_              IN VARCHAR2,
   condition_code_          IN VARCHAR2,
   vendor_no_               IN VARCHAR2,
   is_order_                IN VARCHAR2,
   rental_db_               IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   available_qty_      NUMBER;   
   owning_vendor_no_   customer_order_line_tab.vendor_no%TYPE;
   include_standard_   VARCHAR2(10) DEFAULT 'TRUE';
   include_project_    VARCHAR2(10) DEFAULT 'FALSE';
   location_type4_db_  VARCHAR2(20);
   proj_id_            VARCHAR2(10);
   ownership_type2_db_ VARCHAR2(200):= NULL;
   local_rental_db_           customer_order_line_tab.rental%TYPE := rental_db_;
BEGIN
   IF (is_order_ = 'TRUE') THEN
      IF (part_no_ IS NULL) THEN
         RETURN NULL;
      END IF;
      IF (part_ownership_db_ = 'SUPPLIER LOANED') THEN
         owning_vendor_no_ := Customer_Order_Line_API.Get_Owner_For_Part_Ownership(order_no_, line_no_,
                                                                                   rel_no_, line_item_no_,
                                                                                   part_ownership_db_);
      ELSIF (part_ownership_db_ = 'COMPANY OWNED') THEN
         location_type4_db_  := 'SHIPMENT';
         ownership_type2_db_ := 'CONSIGNMENT';
      ELSIF (part_ownership_db_ IN ('SUPPLIER RENTED', 'COMPANY RENTAL ASSET')) THEN 
         IF local_rental_db_ IS NULL THEN 
            local_rental_db_ := NVL(Customer_Order_Line_API.Get_Rental_db(order_no_, line_no_, rel_no_, line_item_no_),
                                    Fnd_Boolean_API.DB_FALSE);
         END IF;
         IF (local_rental_db_ = Fnd_Boolean_API.DB_TRUE) THEN 
            /* When Int Purch Trans supply code is used, both company rental asset and supplier rented ownerships are considered.*/
            IF (supply_code_db_ = 'IPT') THEN
               IF (part_ownership_db_ = 'SUPPLIER RENTED') THEN 
                  ownership_type2_db_ := 'COMPANY RENTAL ASSET';
               ELSE
                  ownership_type2_db_ := 'SUPPLIER RENTED';
               END IF;
            ELSIF (part_ownership_db_ = 'COMPANY RENTAL ASSET') THEN
               ownership_type2_db_ := 'SUPPLIER RENTED';
            END IF;
         END IF;   
      END IF;
      IF (supply_code_db_ IN ('PI', 'PJD')) THEN
         include_standard_ := 'FALSE';
         include_project_  := 'TRUE';
         proj_id_          := project_id_;
      END IF;
   ELSIF (part_ownership_db_ = 'COMPANY OWNED') THEN
      ownership_type2_db_ := 'CONSIGNMENT';
   END IF;
   
   IF (supply_code_db_ = 'PKG') THEN
      available_qty_ := Get_Available_Pkg_Qty__(order_no_,
                                                line_no_,
                                                rel_no_,
                                                contract_,
                                                part_no_,
                                                configuration_id_,
                                                part_ownership_db_,
                                                ownership_type2_db_,
                                                owning_customer_no_,
                                                owning_vendor_no_,
                                                location_type4_db_,
                                                include_standard_,
                                                include_project_,
                                                project_id_,
                                                condition_code_);
   ELSE
      available_qty_ := Inventory_Part_In_Stock_API.Get_Inventory_Quantity(contract_            => contract_,
                                                                           part_no_             => part_no_,
                                                                           configuration_id_    => configuration_id_,
                                                                           qty_type_            => 'AVAILABLE',
                                                                           expiration_control_  => 'NOT EXPIRED',
                                                                           supply_control_db_   => 'NETTABLE',
                                                                           ownership_type1_db_  => part_ownership_db_,
                                                                           ownership_type2_db_  => ownership_type2_db_,
                                                                           owning_customer_no_  => owning_customer_no_,
                                                                           owning_vendor_no_    => owning_vendor_no_,
                                                                           location_type1_db_   => 'PICKING',
                                                                           location_type2_db_   => 'F',
                                                                           location_type3_db_   => 'MANUFACTURING',
                                                                           location_type4_db_   => location_type4_db_,
                                                                           include_standard_    => include_standard_,
                                                                           include_project_     => include_project_,
                                                                           project_id_          => proj_id_,
                                                                           condition_code_      => condition_code_);
   END IF;

   RETURN Inventory_Part_API.Get_Site_Converted_Qty(contract_,part_no_,available_qty_,contract_,'REMOVE');
END Get_Available_Qty;


-- Get_Available_Qty
--   Returns available quantity for a part.
@UncheckedAccess
FUNCTION Get_Available_Qty (
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   is_customer_order_ IN VARCHAR2 ) RETURN NUMBER
IS
   co_line_rec_ Customer_Order_Line_API.Public_Rec;
BEGIN
   co_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   
   RETURN Get_Available_Qty(NVL(co_line_rec_.contract,co_line_rec_.supply_site), 
                            NVL(co_line_rec_.part_no, co_line_rec_.catalog_no),
                            co_line_rec_.configuration_id,
                            order_no_,
                            line_no_, 
                            rel_no_, 
                            line_item_no_, 
                            co_line_rec_.supply_code ,
                            co_line_rec_.part_ownership, 
                            co_line_rec_.owning_customer_no,
                            co_line_rec_.project_id, 
                            co_line_rec_.condition_code,
                            NULL,
                            'TRUE');
END Get_Available_Qty;

-- Get_Avail_Qty_For_Quotation
--   Returns available quantity for a part.
--   This was written to avoid a dynamic component dependency in SalesQuotationLineTab.fragment
@UncheckedAccess
FUNCTION Get_Avail_Qty_For_Quotation (
   contract_                IN VARCHAR2,
   vendor_no_               IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   supply_code_db_          IN VARCHAR2,
   condition_code_          IN VARCHAR2) RETURN NUMBER
IS
   contract_temp_      VARCHAR2(5);
BEGIN
   IF (vendor_no_ IS NOT NULL) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN    
         contract_temp_ :=  Supplier_API.Get_Acquisition_Site(vendor_no_);  
      $ELSE
         contract_temp_ := NULL;
      $END
   END IF;
   contract_temp_ := NVL(contract_temp_, contract_);
   RETURN Reserve_Customer_Order_API.Get_Available_Qty(contract_temp_, part_no_,configuration_id_,null,null,null,null,supply_code_db_,'COMPANY OWNED',null,null,condition_code_,vendor_no_,'FALSE');
END Get_Avail_Qty_For_Quotation;

-- Connect_To_Manual_Pick_List
--   The unpicked reservations are connected to Manual Consolidated Pick List
--   according to its selection criteria.
PROCEDURE Connect_To_Manual_Pick_List (
   preliminary_pick_list_no_ IN NUMBER )
IS
   CURSOR get_reservations IS
      SELECT lines.order_no, lines.line_no, lines.rel_no, lines.line_item_no, lines.contract, lines.part_no, lines.location_no, lines.lot_batch_no, lines.serial_no, lines.eng_chg_level,
             lines.waiv_dev_rej_no, lines.activity_seq, lines.handling_unit_id, lines.pick_list_no, lines.configuration_id, mcpl.worker_id, lines.shipment_id
      FROM  create_pick_list_join_main lines, manual_consol_pick_list_tab mcpl
      WHERE lines.preliminary_pick_list_no IS NULL 
      AND   lines.contract = mcpl.contract
      AND   (lines.order_no, lines.line_no, lines.rel_no, lines.line_item_no) IN (SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no FROM customer_order_line_tab col WHERE rowstate IN ('Reserved', 'PartiallyDelivered')) 
      AND   lines.pick_list_no = '*' 
      AND   lines.shipment_id = 0
      AND   mcpl.preliminary_pick_list_no = preliminary_pick_list_no_
      AND   (mcpl.planned_ship_date      IS NULL OR lines.planned_ship_date = mcpl.planned_ship_date)
      AND   (mcpl.until_planned_due_date IS NULL OR lines.planned_due_date <= mcpl.until_planned_due_date)
      AND   lines.order_no       LIKE NVL(mcpl.order_no, '%')
      AND   lines.warehouse      LIKE NVL(mcpl.warehouse, '%')
      AND   lines.part_no        LIKE NVL(mcpl.part_no, '%')
      AND   lines.customer_no    LIKE NVL(mcpl.customer_no, '%')
      AND   lines.location_group LIKE NVL(mcpl.location_group, '%')
      AND   (mcpl.route_id         IS NULL OR lines.route_id  LIKE NVL(mcpl.route_id, '%'))
      AND   (mcpl.ship_via_code    IS NULL OR lines.ship_via_code    LIKE NVL(mcpl.ship_via_code, '%'))
      AND   (mcpl.forward_agent_id IS NULL OR lines.forward_agent_id LIKE NVL(mcpl.forward_agent_id, '%'))
      AND   (mcpl.bay_no           IS NULL OR lines.bay_no           LIKE NVL(mcpl.bay_no, '%'))
      AND   (mcpl.row_no           IS NULL OR lines.row_no           LIKE NVL(mcpl.row_no, '%'))
      AND   (mcpl.tier_no          IS NULL OR lines.tier_no          LIKE NVL(mcpl.tier_no, '%'));
      
   TYPE reservation_lines_table IS TABLE OF get_reservations%ROWTYPE INDEX BY BINARY_INTEGER;
   linerec_      reservation_lines_table;
   task_type_db_ warehouse_worker_task_type.task_type_db%TYPE; 
BEGIN
   OPEN get_reservations;
   FETCH get_reservations BULK COLLECT INTO linerec_;
   CLOSE get_reservations;

   IF linerec_.COUNT>0 THEN
      FOR i_ IN linerec_.FIRST .. linerec_.LAST LOOP
         IF linerec_(i_).worker_id IS NOT NULL THEN
            task_type_db_ := 'CUSTOMER ORDER PICK LIST';
         END IF;
         IF linerec_(i_).worker_id IS NULL OR (linerec_(i_).worker_id IS NOT NULL AND Warehouse_Worker_Task_Type_API.Is_Active_Worker(linerec_(i_).contract, linerec_(i_).worker_id, task_type_db_)) THEN
            Customer_Order_Reservation_API.Modify_Prelim_Pick_List_No(order_no_                 => linerec_(i_).order_no,
                                                                      line_no_                  => linerec_(i_).line_no,
                                                                      rel_no_                   => linerec_(i_).rel_no,
                                                                      line_item_no_             => linerec_(i_).line_item_no,
                                                                      contract_                 => linerec_(i_).contract,
                                                                      part_no_                  => linerec_(i_).part_no,
                                                                      location_no_              => linerec_(i_).location_no,
                                                                      lot_batch_no_             => linerec_(i_).lot_batch_no,
                                                                      serial_no_                => linerec_(i_).serial_no,
                                                                      eng_chg_level_            => linerec_(i_).eng_chg_level,
                                                                      waiv_dev_rej_no_          => linerec_(i_).waiv_dev_rej_no,
                                                                      activity_seq_             => linerec_(i_).activity_seq,
                                                                      handling_unit_id_         => linerec_(i_).handling_unit_id,
                                                                      pick_list_no_             => linerec_(i_).pick_list_no,
                                                                      configuration_id_         => linerec_(i_).configuration_id,
                                                                      shipment_id_              => linerec_(i_).shipment_id,
                                                                      preliminary_pick_list_no_ => preliminary_pick_list_no_);
         END IF;
      END LOOP;
   END IF;
END Connect_To_Manual_Pick_List;


-- Check_Expired
--   Returns TRUE if the part_no_ is expired by the planned_delivery_date_. FALSE will be returned otherwise.
@UncheckedAccess
FUNCTION Check_Expired (
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   planned_delivery_date_ IN DATE ) RETURN BOOLEAN
IS 
   CURSOR get_reservations IS
      SELECT cor.configuration_id, cor.location_no, cor.lot_batch_no, cor.serial_no, cor.eng_chg_level, cor.waiv_dev_rej_no, cor.activity_seq, cor.handling_unit_id
      FROM customer_order_reservation_tab cor
      WHERE cor.order_no = order_no_
      AND   cor.line_no  = line_no_
      AND   cor.rel_no   = rel_no_
      AND   cor.line_item_no = line_item_no_;
   
   inv_part_rec_            Inventory_Part_API.Public_Rec;
   min_durab_days_co_deliv_ NUMBER;
   expiration_control_date_ DATE;
   exp_date_                DATE;
   expired_                 BOOLEAN := FALSE;
   test_date_               DATE := trunc(Site_API.Get_Site_Date(contract_));
BEGIN
   inv_part_rec_            := Inventory_Part_API.Get(contract_, part_no_);
   min_durab_days_co_deliv_ := inv_part_rec_.min_durab_days_co_deliv;
   expiration_control_date_ := Get_Expiration_Control_Date___(planned_delivery_date_, test_date_, min_durab_days_co_deliv_, order_no_, line_no_, rel_no_, line_item_no_, contract_, part_no_);

   FOR rec_ IN get_reservations LOOP
      exp_date_ := Inventory_Part_In_Stock_API.Get_Expiration_Date(contract_         => contract_, 
                                                                   part_no_          => part_no_, 
                                                                   configuration_id_ => rec_.configuration_id, 
                                                                   location_no_      => rec_.location_no, 
                                                                   lot_batch_no_     => rec_.lot_batch_no, 
                                                                   serial_no_        => rec_.serial_no, 
                                                                   eng_chg_level_    => rec_.eng_chg_level, 
                                                                   waiv_dev_rej_no_  => rec_.waiv_dev_rej_no, 
                                                                   activity_seq_     => rec_.activity_seq, 
                                                                   handling_unit_id_ => rec_.handling_unit_id);
      IF ((expiration_control_date_ > exp_date_) AND (NOT expired_)) THEN
         expired_ := TRUE;
      END IF;
   END LOOP;
   RETURN expired_;
END Check_Expired;


-- Validate_On_Rental_Period_Qty
--   This method check whether the rental period exist for given
--   order line and validate qty_to_reserve accordingly.
PROCEDURE Validate_On_Rental_Period_Qty (
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,
   lot_batch_no_   IN VARCHAR2,
   serial_no_      IN VARCHAR2,
   qty_to_reserve_ IN NUMBER )
IS
   max_rental_qty_         NUMBER;
   serial_or_lot_batch_no_ VARCHAR2(50);
BEGIN
   $IF Component_Rental_SYS.INSTALLED $THEN
      IF (Rental_Object_Manager_API.On_Rental_Period_Qty_Exist(order_no_,
                                                               line_no_, 
                                                               rel_no_, 
                                                               line_item_no_, 
                                                               Rental_Type_API.DB_CUSTOMER_ORDER,
                                                               lot_batch_no_,
                                                               serial_no_,
                                                               qty_to_reserve_)) THEN

         max_rental_qty_ := Rental_Event_History_API.Get_Max_Rental_Qty(order_no_,
                                                                        line_no_,
                                                                        rel_no_,
                                                                        line_item_no_,
                                                                        Rental_Type_API.DB_CUSTOMER_ORDER,
                                                                        lot_batch_no_,
                                                                        serial_no_);

         IF (serial_no_ = '*' AND lot_batch_no_ = '*') THEN
            Error_SYS.Record_General(lu_name_, 'CANNOTUNRESRENTQTY: You cannot reduce the reserved quantity to below :P1, as rental periods exist for this quantity. Please remove the rental periods by creating correction rental events.', max_rental_qty_);
         END IF;
         IF (serial_no_ != '*' OR lot_batch_no_ != '*') THEN
            IF (serial_no_ != '*') THEN
               serial_or_lot_batch_no_ := serial_no_;
            ELSIF (lot_batch_no_ != '*') THEN
               serial_or_lot_batch_no_ := lot_batch_no_;
            END IF;
            Error_SYS.Record_General(lu_name_, 'CANNOTUNRESTRRENTQTY: You cannot reduce the reserved quantity to below :P1 for serial/lot batch :P2, as rental periods exist for this quantity. Please remove the rental periods by creating correction rental events.', max_rental_qty_, serial_or_lot_batch_no_);
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Validate_On_Rental_Period_Qty;

FUNCTION Get_Co_Reservation_Keys_For_Hu (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER) RETURN  Customer_Order_Reservation_API.Keys_And_Qty_Tab
IS
   co_reservation_keys_tab_ Customer_Order_Reservation_API.Keys_And_Qty_Tab;
   CURSOR get_reservation IS
      SELECT cor.order_no, 
             cor.line_no, rel_no, 
             cor.line_item_no, 
             cor.contract, part_no, 
             cor.location_no, 
             cor.lot_batch_no, 
             cor.serial_no, 
             cor.eng_chg_level, 
             cor.waiv_dev_rej_no, 
             cor.activity_seq, 
             cor.handling_unit_id, 
             cor.configuration_id, 
             cor.pick_list_no, 
             cor.shipment_id,
             cor.qty_assigned
        FROM customer_order_reservation_tab cor       
       WHERE cor.pick_list_no = pick_list_no_
         AND cor.handling_unit_id IN ( SELECT hu.handling_unit_id
                                         FROM handling_unit_pub hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH       hu.handling_unit_id = handling_unit_id_); 
              
BEGIN
      OPEN  get_reservation;
      FETCH get_reservation BULK COLLECT INTO co_reservation_keys_tab_;
      CLOSE get_reservation;
   
      RETURN(co_reservation_keys_tab_);   
END Get_Co_Reservation_Keys_For_Hu;

FUNCTION Get_Order_No (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS 
   order_no_                customer_order_reservation_tab.order_no%TYPE; 
   previous_order_no_       customer_order_reservation_tab.order_no%TYPE;
   co_reservation_keys_tab_ Customer_Order_Reservation_API.Keys_And_Qty_Tab;
BEGIN
   co_reservation_keys_tab_ := Get_Co_Reservation_Keys_For_Hu(pick_list_no_, handling_unit_id_);

   IF (co_reservation_keys_tab_.COUNT > 0) THEN
      FOR i IN co_reservation_keys_tab_.FIRST .. co_reservation_keys_tab_.LAST LOOP
         order_no_ := co_reservation_keys_tab_(i).order_no;

         IF (previous_order_no_ IS NULL) THEN
            previous_order_no_ := order_no_;
         ELSIF (order_no_ != previous_order_no_) THEN
            order_no_ := NULL;
            EXIT;
         END IF;
      END LOOP;
   END IF; 

   RETURN(order_no_);
END Get_Order_No;   
      
FUNCTION Get_Line_No (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS 
   line_no_                 customer_order_reservation_tab.line_no%TYPE; 
   previous_line_no_       customer_order_reservation_tab.line_no%TYPE;
   co_reservation_keys_tab_ Customer_Order_Reservation_API.Keys_And_Qty_Tab;
BEGIN
   co_reservation_keys_tab_ := Get_Co_Reservation_Keys_For_Hu(pick_list_no_, handling_unit_id_);

   IF (co_reservation_keys_tab_.COUNT > 0) THEN
      FOR i IN co_reservation_keys_tab_.FIRST .. co_reservation_keys_tab_.LAST LOOP
         line_no_ := co_reservation_keys_tab_(i).line_no;

         IF (previous_line_no_ IS NULL) THEN
            previous_line_no_ := line_no_;
         ELSIF (line_no_ != previous_line_no_) THEN
            line_no_ := NULL;
            EXIT;
         END IF;
      END LOOP;
   END IF; 

   RETURN(line_no_);
END Get_Line_No;   

FUNCTION Get_Rel_No (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS 
   rel_no_                 customer_order_reservation_tab.rel_no%TYPE; 
   previous_rel_no_       customer_order_reservation_tab.rel_no%TYPE;
   co_reservation_keys_tab_ Customer_Order_Reservation_API.Keys_And_Qty_Tab;
BEGIN
   co_reservation_keys_tab_ := Get_Co_Reservation_Keys_For_Hu(pick_list_no_, handling_unit_id_);

   IF (co_reservation_keys_tab_.COUNT > 0) THEN
      FOR i IN co_reservation_keys_tab_.FIRST .. co_reservation_keys_tab_.LAST LOOP
         rel_no_ := co_reservation_keys_tab_(i).rel_no;

         IF (previous_rel_no_ IS NULL) THEN
            previous_rel_no_ := rel_no_;
         ELSIF (rel_no_ != previous_rel_no_) THEN
            rel_no_ := NULL;
            EXIT;
         END IF;
      END LOOP;
   END IF; 

   RETURN(rel_no_);
END Get_Rel_No;

FUNCTION Get_Line_Item_No (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS 
   line_item_no_                 customer_order_reservation_tab.line_item_no%TYPE; 
   previous_line_item_no_       customer_order_reservation_tab.line_item_no%TYPE;
   co_reservation_keys_tab_ Customer_Order_Reservation_API.Keys_And_Qty_Tab;
BEGIN
   co_reservation_keys_tab_ := Get_Co_Reservation_Keys_For_Hu(pick_list_no_, handling_unit_id_);

   IF (co_reservation_keys_tab_.COUNT > 0) THEN
      FOR i IN co_reservation_keys_tab_.FIRST .. co_reservation_keys_tab_.LAST LOOP
         line_item_no_ := co_reservation_keys_tab_(i).line_item_no;

         IF (previous_line_item_no_ IS NULL) THEN
            previous_line_item_no_ := line_item_no_;
         ELSIF (line_item_no_ != previous_line_item_no_) THEN
            line_item_no_ := NULL;
            EXIT;
         END IF;
      END LOOP;
   END IF; 

   RETURN(line_item_no_);
END Get_Line_Item_No; 

FUNCTION Get_Shipment_Id (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS 
   shipment_id_                 customer_order_reservation_tab.shipment_id%TYPE; 
   previous_shipment_id_        customer_order_reservation_tab.shipment_id%TYPE;
   co_reservation_keys_tab_ Customer_Order_Reservation_API.Keys_And_Qty_Tab;
BEGIN
   co_reservation_keys_tab_ := Get_Co_Reservation_Keys_For_Hu(pick_list_no_, handling_unit_id_);

   IF (co_reservation_keys_tab_.COUNT > 0) THEN
      FOR i IN co_reservation_keys_tab_.FIRST .. co_reservation_keys_tab_.LAST LOOP
         shipment_id_ := co_reservation_keys_tab_(i).shipment_id;

         IF (previous_shipment_id_ IS NULL) THEN
            previous_shipment_id_ := shipment_id_;
         ELSIF (shipment_id_ != previous_shipment_id_) THEN
            shipment_id_ := NULL;
            EXIT;
         END IF;
      END LOOP;
   END IF; 

   RETURN(shipment_id_);
END Get_Shipment_Id;

FUNCTION Get_Qty_Assigned (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS 
   part_no_                     customer_order_reservation_tab.part_no%TYPE; 
   qty_assigned_                customer_order_reservation_tab.qty_assigned%TYPE := 0;
   co_reservation_keys_tab_ Customer_Order_Reservation_API.Keys_And_Qty_Tab;
BEGIN
   co_reservation_keys_tab_ := Get_Co_Reservation_Keys_For_Hu(pick_list_no_, handling_unit_id_);

   IF (co_reservation_keys_tab_.COUNT > 0) THEN
      part_no_ := co_reservation_keys_tab_(1).part_no;
      FOR i IN co_reservation_keys_tab_.FIRST .. co_reservation_keys_tab_.LAST LOOP
         IF (co_reservation_keys_tab_(i).part_no = part_no_) THEN
            qty_assigned_ := qty_assigned_ + co_reservation_keys_tab_(i).quantity;
         ELSE
            qty_assigned_ := NULL;
            EXIT;
         END IF;
      END LOOP;
   END IF; 

   RETURN(qty_assigned_);
END Get_Qty_Assigned; 


-- Check_Available_To_Reserve
-- Checks whether a perticular part has enough 
-- quantity to reserve at the time of the
-- customer order creation.
FUNCTION Check_Available_To_Reserve (
   qty_to_assign_     IN     NUMBER,
   contract_          IN     VARCHAR2,
   part_no_           IN     VARCHAR2,
   order_no_          IN     VARCHAR2,
   line_no_           IN     VARCHAR2,
   rel_no_            IN     VARCHAR2,
   line_item_no_      IN     NUMBER,
   customer_no_       IN     VARCHAR2,   
   supply_code_db_    IN     VARCHAR2,
   picking_leadtime_  IN     NUMBER,
   part_ownership_    IN     VARCHAR2 ) RETURN BOOLEAN
IS
   possible_to_reserve_   BOOLEAN := TRUE;   
   qty_possible_        NUMBER := 0;  
   po_line_no_          VARCHAR2(4);
   po_rel_no_           VARCHAR2(4);
   orig_order_no_       VARCHAR2(12);
   orig_line_no_        VARCHAR2(4);
   orig_rel_no_         VARCHAR2(4);
   orig_line_item_no_   NUMBER;
   headrec_             Customer_Order_API.Public_Rec;
   result_              VARCHAR2(80);
   dummy_date_          DATE;
   test_date_           DATE := TRUNC(Site_API.Get_Site_Date(contract_));      

   $IF Component_Purch_SYS.INSTALLED $THEN
      poline_ Purchase_Order_Line_API.Public_Rec;
   $END 
BEGIN
   IF (supply_code_db_ = 'IO') THEN
      headrec_ := Customer_Order_API.Get(order_no_);      
      
      $IF Component_Purch_SYS.INSTALLED $THEN
         IF (headrec_.internal_po_no IS NOT NULL) THEN 
            po_line_no_ := line_no_;  -- for an internal order the CO and PO line_no are the same
            po_rel_no_  := rel_no_;   -- for an internal order the CO and PO rel_no are the same
            -- get the originating order line keys
            poline_     := Purchase_Order_Line_API.Get(headrec_.internal_po_no, po_line_no_, po_rel_no_);
            IF (poline_.demand_code IN ('ICD', 'ICT')) THEN
               orig_order_no_     := poline_.demand_order_no;
               orig_line_no_      := poline_.demand_release;
               orig_rel_no_       := poline_.demand_sequence_no;
               orig_line_item_no_ := Purchase_Order_Line_API.Get_Demand_Operation_No(headrec_.internal_po_no, po_line_no_, po_rel_no_);
            END IF;            
         END IF;
      $END    
      
      IF (Substitute_Sales_Part_API.Allow_Auto_Substitution(contract_, customer_no_))THEN
         IF (Inventory_Part_API.Get_Forecast_Consump_Flag_Db(contract_, part_no_) = 'NOFORECAST') THEN            
            IF (qty_to_assign_ > 0) THEN                
               IF (part_ownership_ = 'COMPANY OWNED') THEN                  
                  Inventory_Part_In_Stock_API.Make_Onhand_Analysis(result_             => result_, 
                                                                qty_possible_          => qty_possible_, 
                                                                next_analysis_date_    => dummy_date_,
                                                                planned_delivery_date_ => dummy_date_, 
                                                                planned_due_date_      => test_date_, 
                                                                contract_              => contract_,
                                                                part_no_               => part_no_, 
                                                                configuration_id_      => '*',
                                                                include_standard_      => 'TRUE', 
                                                                include_project_       => 'FALSE', 
                                                                project_id_            => NULL, 
                                                                activity_seq_          => NULL, 
                                                                row_id_                => NULL,
                                                                qty_desired_           => qty_to_assign_, 
                                                                picking_leadtime_      => picking_leadtime_,
                                                                part_ownership_        => part_ownership_,
                                                                owning_vendor_no_      => NULL, 
                                                                owning_customer_no_    => NULL);
                  
                  IF (result_ != 'SUCCESS') THEN
                     possible_to_reserve_ := FALSE; 
                  ELSE
                     IF (qty_possible_ < qty_to_assign_) THEN
                        possible_to_reserve_ := FALSE;               
                     END IF;
                  END IF;
               END IF;               
            END IF;
            IF (qty_possible_= 0) THEN
               possible_to_reserve_ := FALSE;      
            END IF;
         END IF;
      END IF;
   END IF;
	RETURN possible_to_reserve_;
END Check_Available_To_Reserve;
  

PROCEDURE Make_CO_Reservation (
   reserved_qty_             OUT    NUMBER,
   input_qty_                IN OUT NUMBER, 
   input_unit_meas_          IN OUT VARCHAR2, 
   input_conv_factor_        IN OUT NUMBER, 
   input_variable_values_    IN OUT VARCHAR2,   
   order_no_                 IN     VARCHAR2, 
   line_no_                  IN     VARCHAR2,
   rel_no_                   IN     VARCHAR2, 
   line_item_no_             IN     NUMBER, 
   contract_                 IN     VARCHAR2, 
   part_no_                  IN     VARCHAR2, 
   location_no_              IN     VARCHAR2, 
   lot_batch_no_             IN     VARCHAR2, 
   serial_no_                IN     VARCHAR2, 
   eng_chg_level_            IN     VARCHAR2, 
   waiv_dev_rej_no_          IN     VARCHAR2, 
   activity_seq_             IN     NUMBER,
   handling_unit_id_         IN     NUMBER,
   configuration_id_         IN     VARCHAR2,
   pick_list_no_             IN     VARCHAR2,
   shipment_id_              IN     NUMBER,
   qty_to_reserve_           IN     NUMBER,
   reserve_manually_         IN     BOOLEAN,
   reservation_operation_id_ IN     NUMBER,
   pick_by_choice_blocked_   IN     VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS
   qty_reserved_           NUMBER := 0; 
   dummy_info_             VARCHAR2(2000);
   dummy_state_            VARCHAR2(50);
   co_reservation_pub_rec_ Customer_Order_Reservation_API.Public_Rec;   
BEGIN
   reserved_qty_ := 0;
   IF reserve_manually_ THEN 
      IF qty_to_reserve_ < 0 THEN 
         co_reservation_pub_rec_ := Customer_Order_Reservation_API.Get(order_no_, 
                                                                       line_no_,
                                                                       rel_no_, 
                                                                       line_item_no_, 
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

         input_qty_              := co_reservation_pub_rec_.input_qty; 
         input_unit_meas_        := co_reservation_pub_rec_.input_unit_meas; 
         input_conv_factor_      := co_reservation_pub_rec_.input_conv_factor; 
         input_variable_values_  := co_reservation_pub_rec_.input_variable_values;
      END IF;
      Reserve_Manually__(info_                     => dummy_info_, 
                         state_                    => dummy_state_, 
                         order_no_                 => order_no_, 
                         line_no_                  => line_no_, 
                         rel_no_                   => rel_no_, 
                         line_item_no_             => line_item_no_,  
                         contract_                 => contract_, 
                         part_no_                  => part_no_, 
                         location_no_              => location_no_,  
                         lot_batch_no_             => lot_batch_no_,  
                         serial_no_                => serial_no_,  
                         eng_chg_level_            => eng_chg_level_,  
                         waiv_dev_rej_no_          => waiv_dev_rej_no_,  
                         activity_seq_             => activity_seq_, 
                         handling_unit_id_         => handling_unit_id_, 
                         qty_to_reserve_           => qty_to_reserve_,  
                         input_qty_                => input_qty_, 
                         input_unit_meas_          => input_unit_meas_, 
                         input_conv_factor_        => input_conv_factor_, 
                         input_variable_values_    => input_variable_values_, 
                         shipment_id_              => shipment_id_, 
                         part_ownership_           => NULL, 
                         owner_                    => NULL, 
                         condition_code_           => NULL,
                         pick_list_no_             => pick_list_no_,
                         reservation_operation_id_ => reservation_operation_id_,
                         pick_by_choice_blocked_   => pick_by_choice_blocked_);    
      reserved_qty_ := qty_to_reserve_;
   ELSE 
      Reserve_Order_Line__(qty_reserved_        => qty_reserved_, 
                           order_no_            => order_no_,  
                           line_no_             => line_no_,  
                           rel_no_              => rel_no_, 
                           line_item_no_        => line_item_no_, 
                           qty_to_be_reserved_  => qty_to_reserve_, 
                           shipment_id_         => shipment_id_, 
                           set_shortage_        => FALSE, 
                           location_no_         => location_no_, 
                           lot_batch_no_        => lot_batch_no_, 
                           serial_no_           => serial_no_, 
                           eng_chg_level_       => eng_chg_level_, 
                           waiv_dev_rej_no_     => waiv_dev_rej_no_, 
                           activity_seq_        => activity_seq_, 
                           handling_unit_id_    => handling_unit_id_,
                           pick_list_no_        => pick_list_no_,
                           reservation_operation_id_ => reservation_operation_id_);
      IF qty_reserved_ IS NOT NULL AND qty_reserved_ = qty_to_reserve_ THEN 
         reserved_qty_ := qty_to_reserve_;
      END IF;
   END IF ;
END Make_CO_Reservation;


@Deprecated
PROCEDURE Execute_Transport_Task_Line (
   transport_task_id_             IN  VARCHAR2,
   task_line_no_                  IN  VARCHAR2,
   handling_unit_id_              IN  NUMBER )
IS
   transport_task_line_rec_   Transport_Task_Line_API.Public_Rec;
   co_reservation_pub_rec_    Customer_Order_Reservation_API.Public_Rec;
   catch_quantity_            NUMBER;
   new_qty_assigned_          NUMBER := 0;
BEGIN
   transport_task_line_rec_ := Transport_Task_Line_API.Get(transport_task_id_, task_line_no_);
   
   IF (transport_task_line_rec_.order_type = Order_Type_API.DB_CUSTOMER_ORDER) THEN
      co_reservation_pub_rec_ := Customer_Order_Reservation_API.Get( transport_task_line_rec_.order_ref1, 
                                                                     transport_task_line_rec_.order_ref2,
                                                                     transport_task_line_rec_.order_ref3,
                                                                     transport_task_line_rec_.order_ref4, 
                                                                     transport_task_line_rec_.from_contract,
                                                                     transport_task_line_rec_.part_no,
                                                                     transport_task_line_rec_.from_location_no, 
                                                                     transport_task_line_rec_.lot_batch_no, 
                                                                     transport_task_line_rec_.serial_no,
                                                                     transport_task_line_rec_.eng_chg_level, 
                                                                     transport_task_line_rec_.waiv_dev_rej_no, 
                                                                     transport_task_line_rec_.activity_seq,
                                                                     transport_task_line_rec_.handling_unit_id,
                                                                     transport_task_line_rec_.configuration_id,
                                                                     transport_task_line_rec_.pick_list_no,
                                                                     transport_task_line_rec_.shipment_id);
      
      IF (co_reservation_pub_rec_.qty_assigned > 0) THEN
         Customer_Order_Reservation_API.Remove(transport_task_line_rec_.order_ref1,
                                               transport_task_line_rec_.order_ref2,
                                               transport_task_line_rec_.order_ref3,
                                               transport_task_line_rec_.order_ref4,
                                               transport_task_line_rec_.from_contract,
                                               transport_task_line_rec_.part_no,
                                               transport_task_line_rec_.from_location_no,
                                               transport_task_line_rec_.lot_batch_no,
                                               transport_task_line_rec_.serial_no,
                                               transport_task_line_rec_.eng_chg_level, 
                                               transport_task_line_rec_.waiv_dev_rej_no,
                                               transport_task_line_rec_.activity_seq,
                                               transport_task_line_rec_.handling_unit_id,
                                               transport_task_line_rec_.pick_list_no,
                                               transport_task_line_rec_.configuration_id,
                                               transport_task_line_rec_.shipment_id); 
         BEGIN
            Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_            => catch_quantity_,
                                                     contract_                  => transport_task_line_rec_.to_contract,
                                                     part_no_                   => transport_task_line_rec_.part_no,
                                                     configuration_id_          => transport_task_line_rec_.configuration_id,
                                                     location_no_               => transport_task_line_rec_.to_location_no,
                                                     lot_batch_no_              => transport_task_line_rec_.lot_batch_no,
                                                     serial_no_                 => transport_task_line_rec_.serial_no,
                                                     eng_chg_level_             => transport_task_line_rec_.eng_chg_level,
                                                     waiv_dev_rej_no_           => transport_task_line_rec_.waiv_dev_rej_no,
                                                     activity_seq_              => transport_task_line_rec_.activity_seq,
                                                     handling_unit_id_          => handling_unit_id_,
                                                     quantity_                  => co_reservation_pub_rec_.qty_assigned,
                                                     manual_reservation_        => TRUE);
         EXCEPTION
            WHEN OTHERS THEN 
               Error_SYS.Record_General(lu_name_, 'EXTTUNABLETORES: Unable to recreate the source reservations at the destination location.');
         END;

         IF (Customer_Order_Reservation_API.Oe_Exist(transport_task_line_rec_.order_ref1,
                                                     transport_task_line_rec_.order_ref2,
                                                     transport_task_line_rec_.order_ref3,
                                                     transport_task_line_rec_.order_ref4,
                                                     transport_task_line_rec_.to_contract,
                                                     transport_task_line_rec_.part_no,
                                                     transport_task_line_rec_.to_location_no,
                                                     transport_task_line_rec_.lot_batch_no,
                                                     transport_task_line_rec_.serial_no,
                                                     transport_task_line_rec_.eng_chg_level,
                                                     transport_task_line_rec_.waiv_dev_rej_no,
                                                     transport_task_line_rec_.activity_seq,
                                                     handling_unit_id_,
                                                     transport_task_line_rec_.pick_list_no,
                                                     transport_task_line_rec_.configuration_id,
                                                     transport_task_line_rec_.shipment_id) = 1) THEN

            new_qty_assigned_ := Customer_Order_Reservation_API.Get_Qty_Assigned(transport_task_line_rec_.order_ref1,
                                                                                 transport_task_line_rec_.order_ref2,
                                                                                 transport_task_line_rec_.order_ref3,
                                                                                 transport_task_line_rec_.order_ref4,
                                                                                 transport_task_line_rec_.to_contract,
                                                                                 transport_task_line_rec_.part_no,
                                                                                 transport_task_line_rec_.to_location_no,
                                                                                 transport_task_line_rec_.lot_batch_no,
                                                                                 transport_task_line_rec_.serial_no,
                                                                                 transport_task_line_rec_.eng_chg_level,
                                                                                 transport_task_line_rec_.waiv_dev_rej_no,
                                                                                 transport_task_line_rec_.activity_seq,
                                                                                 handling_unit_id_,
                                                                                 transport_task_line_rec_.configuration_id, 
                                                                                 transport_task_line_rec_.pick_list_no, 
                                                                                 transport_task_line_rec_.shipment_id) + co_reservation_pub_rec_.qty_assigned;

            Customer_Order_Reservation_API.Modify_Qty_Assigned(transport_task_line_rec_.order_ref1,
                                                               transport_task_line_rec_.order_ref2,
                                                               transport_task_line_rec_.order_ref3,
                                                               transport_task_line_rec_.order_ref4,
                                                               transport_task_line_rec_.to_contract,
                                                               transport_task_line_rec_.part_no,
                                                               transport_task_line_rec_.to_location_no,
                                                               transport_task_line_rec_.lot_batch_no,
                                                               transport_task_line_rec_.serial_no,
                                                               transport_task_line_rec_.eng_chg_level, 
                                                               transport_task_line_rec_.waiv_dev_rej_no,
                                                               transport_task_line_rec_.activity_seq,
                                                               handling_unit_id_,
                                                               transport_task_line_rec_.pick_list_no,
                                                               transport_task_line_rec_.configuration_id,
                                                               transport_task_line_rec_.shipment_id,
                                                               qty_assigned_            => new_qty_assigned_, 
                                                               input_qty_               => NULL, 
                                                               input_unit_meas_         => NULL, 
                                                               input_conv_factor_       => NULL, 
                                                               input_variable_values_   => NULL);

         ELSE
            Customer_Order_Reservation_API.New(transport_task_line_rec_.order_ref1,
                                               transport_task_line_rec_.order_ref2,
                                               transport_task_line_rec_.order_ref3,
                                               transport_task_line_rec_.order_ref4,
                                               transport_task_line_rec_.to_contract,
                                               transport_task_line_rec_.part_no,
                                               transport_task_line_rec_.to_location_no,
                                               transport_task_line_rec_.lot_batch_no,
                                               transport_task_line_rec_.serial_no,
                                               transport_task_line_rec_.eng_chg_level, 
                                               transport_task_line_rec_.waiv_dev_rej_no,
                                               transport_task_line_rec_.activity_seq,
                                               handling_unit_id_,
                                               transport_task_line_rec_.pick_list_no,
                                               transport_task_line_rec_.configuration_id,
                                               transport_task_line_rec_.shipment_id,
                                               co_reservation_pub_rec_.qty_assigned,
                                               co_reservation_pub_rec_.qty_picked,
                                               co_reservation_pub_rec_.qty_shipped,
                                               co_reservation_pub_rec_.input_qty,
                                               co_reservation_pub_rec_.input_unit_meas,
                                               co_reservation_pub_rec_.input_conv_factor,
                                               co_reservation_pub_rec_.input_variable_values,
                                               co_reservation_pub_rec_.preliminary_pick_list_no,
                                               co_reservation_pub_rec_.catch_qty,
                                               pick_by_choice_blocked_ => co_reservation_pub_rec_.pick_by_choice_blocked);  
         END IF;
      END IF; 
   END IF;   
END Execute_Transport_Task_Line;

