-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentHandlingUtility
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220603  PamPlk  SCDEV-10606, Modified Add_Source_Line_To_Shipment by adding sender_type_ and sender_id_ as in parameters.
--  220510  PrRtlk  SCDEV-7227, Modified Find_Shipment___ to consider Sender Address Details.
--  211124  ErRalk  SC21R2-3009, Modified Get_Sender_Address_Info method parameters to support sender address in Supplier Return.
--  201120  LEPESE  SC2020R1-10727, added use of Shipment_Line_API.Get_Converted_Source_Ref in Get_Packing_Qty_Deviation to support Shipment Order.
--  200916  RoJalk  SC2020R1-1673, Modified Build_Attr_Create_Shipment___ to fetch language_code using Shipment_Source_Utility_API.Get_Language_Code.
--  200828  PamPlk  SC2020R1-9435, Modified the method Build_Attr_Create_Shipment___ by using Shipment_Source_Utility_API.Get_Sender_Address_Info 
--  200828          to fetch the sender address info.
--  200707  BudKlk  Bug 148995 (SCZ-5793), Modified the method Build_Attr_Create_Shipment___ to resize the variable receiver_ref_.    
--  200525  RoJalk  SC2020R1-2201, Modified Any_Packing_Qty_Deviation___, Get_Packing_Qty_Deviation to pass the source ref type as a parameter.
--  200413  Aabalk  Bug 153107(SCZ-9691), Added Move_Handling_Unit_Quantity() method to move shipment line handling unit parts between handling units.
--  200318  DhAplk  Bug 152713 (SCZ-9267), Modified Build_Attr_Create_Shipment___() to get planned_ship_date and planned_delivery_date from source_line_rec_ during reassignment.
--  200317  DhAplk  Bug 152541 (SCZ-8879), Modified Connect_Hu_To_Ship___(), Add_Hu_To_Shipment(), Connect_HUs_From_Inventory() methods to avoid quantity comparison process 
--  200317          within Report Picking scenario by passing a parameter through method stack. And modified Any_Shipment_Qty_Deviation() to complete shipment at that situation.
--  191212  KhVese  SCSPRING20-1281, Added method Get_Total_Qty_Shipped.
--  191207  MeAblk  SCSPRING20-180, Build_Attr_Create_Shipment___() to set the SHIPMENT_CATEGORY_DB for automatic shipment creation.
--  191107  MeAblk  SCSPRING20-937, Modified methods Create_Or_Connect_Shipment___(), Create_Shipment__(), Find_Existing_Shipment___(), Find_Shipment___(),
--  191107          Build_Attr_Create_Shipment___(), Add_Source_Line_To_Shipment() to support sender_type, sender_id, receiver_type. 
--  191025  MeAblk  SCSPRING20-538, Added sender_id as the contract in Build_Attr_Create_Shipment___() to support automatic shipment creation.
--  180813  SBalLK  Bug 149413 (SCZ-6113), Modified Connect_HUs_From_Inventory(), Add_Hu_To_Shipment() and Connect_Hu_To_Ship___() methods to not reset manually entered weight, volume and not to validate mix handling unit of the already defined handling units in the inventory.
--  190103  KiSalk  Bug 146005(SCZ-2580), Modified Find_Shipment___ to fetch shipment_tab by shipment_id when there is a vallue passed.
--  180516  SBalLK  Bug 141724, Removed defined component dependency with own component.
--  180228  KHVESE  STRSC-16652, Modified CURSOR get_reservations in method Connect_Hu_To_Ship___.
--  171116  Chfose  STRSC-13781, Added new method Disconnect_Empty_Hu_On_Ship to disconnect handling units without any ShipmentLineHandlUnit-records.
--  171019  RoJalk  STRSC-12396, Modified Is_Qty_Left_To_Attach and moved some of the logic to Dispatch_Advice_Utility_API.Prioritize_Reservations___.  
--  170904  MaRalk  STRSC-11317, Modified Build_Attr_Create_Shipment___ to rename SHIPMENT_PAYER as SHIPMENT_FREIGHT_PAYER in SHIPMENT_TAB.
--  170825  MaRalk  STRSC-11314, Modified Build_Attr_Create_Shipment___ in order to support fetching freight payer and payer id
--  170825          in the automatic creation of shipment process and when reassigning to a new shipment.
--  170621  Chfose  STRSC-8805, Modified Connect_Hu_To_Ship___ to handle the source qty when connecting the shipment line to the Handling Unit.
--  170601  Chfose  STRSC-8781, Modified the cursor in Connect_HUs_From_Inventory to properly group reservations by the InventoryPartInStock-keys.
--  170601  MaRalk  LIM-11503, Modified Any_Shipment_Conn_For_Site by adding the condition for source ref type 'Customer Order'.
--  170524  RoJalk  LIM-11477, Modified Build_Attr_Create_Shipment___ to assign a value to ship_inventory_location_no during reassignmnet.
--  170503  RoJalk  Bug 132014, Modified the method Is_Qty_Left_To_Attach() to check if there are inventory not tracked serial parts in the shipment.
--  170503  RoJalk  Bug 130169, Added new method Is_Qty_Left_To_Attach(). 
--  170327  MaIklk  LIM-11259, Fixed to handle NVL for ship via and delivery terms when find existing shipment. 
--  170321  MaIklk  LIM-11182, Included source ref type in Find Shipment where clause in order to avoid mix scenario between CO and PD.
--  170309  Chfose  LIM-10728, Modified Connect_Hu_To_Ship___ to only connect qty not already represented in Shipment_Reserv_Handl_Unit_Tab.
--  170131  MaIklk  LIM-9825, Handled NVL for source ref columns when calling ShipmentReservHandlUnit methods.
--  170131  RoJalk  LIM-10194, Modified the text of QTYDEV error message to make it more explainable. 
--  170126  MaIklk  LIM-10463, Used Shipment_Source_Utility_API.Get_Source_Supply_Country_Db instead of fetching the supply country via Shipment_Source_Utility_API.Get().
--  170126  MaIklk  LIM-10461, Added ORIGINATING_SOURCE_REF_TYPE when build attribute string for automatic shipment creation.
--  170104  MaIklk  LIM-9397, Moved Calculate_Freight_Charges() and Calculate_Shipment_Charges() to ShipmentFreightCharge.
--  161222  MaIklk  LIM-8387, Fixed to compare receiver type during automatic creation.
--  161216  Chfose  LIM-3663, Removed Generate_Conn_Inv_Hu_Snapshot & Add_Inv_HUs_To_Shipment.
--  161206  Chfose  LIM-9188, Reworked Connect_Hu_To_Ship___ to avoid using a snapshot to check if all quantity in a handling unit is reserved to the shipment.
--  161128  MaIklk  LIM-9255, Fixed to directly access ShipmentReservHandlUnit since it is moved to SHPMNT.
--  161117  Chfose  LIM-9436, Moved logic regarding Adding/Removing HU to/from a Shipment from HandlingUnitShipUtil(INVENT).
--  161116  MaIklk  LIM-9232, Moved reservation related methods to ReserveShipment. 
--  161107  RoJalk  LIM-8391, Moved Release_Not_Reserved_Qty__,  Shipment_Structure_Exist to Shipment_API.
--  161028  RoJalk  Moved the content of Shipment_Handling_Utility_API.Get_Qty_To_Ship_Reassign to 
--  161028          Reassign_Shipment_Utility_API.Get_Qty_To_Ship_Reassign___
--  161028  RoJalk  LIM-9424, Moved Get_Tot_Packing_Qty_Deviation from Shipment_Handling_Utility_API to Shipment_API.
--  161026  RoJalk  LIM-8391, Moved Remove_Shipment_Lines to ShipmentLine.
--  161026  RoJalk  LIM-8391, Moved All_Lines_Reserved, All_Lines_Picked, Unconnected_Structure_Allowed to Shipment_API. 
--  161025  RoJalk  LIM-6948, Modified Release_Not_Reserved_Qty__ and called Shipment_Order_Utility_API.Release_Not_Reserved_Pkg_Qty.
--  160816  MaIklk  LIM-8300, Implemented to fetch customs_value_currency from order when creating new shipment.
--  160810  MaRalk  LIM-6755, Modified the error messages SHIPLINEREMOVE, SUPPCOUNTRYMISMATCH in order to support generic shipment functionality.
--  160810  MaIklk  LIM-8133, Renamed Reserve_Manually_HU__ to Reserve_Manually_Hu__.
--  160726  MaIklk  LIM-8055, Implemented to use planned_delivery_date as a consolidation parameter in shipment types.
--  160630  RoJalk  LIM-7654, Modified Build_Attr_Create_Shipment___ to include planned_delivery_date in reassignment.
--  160614  MaRalk  LIM-7653, Removed unused parameter forward_agent_id_ from Build_Attr_Create_Shipment___.
--  160607  RoJalk  LIM-6975, Replaced the usage of Shipment_API.Get_State with Shipment_API.Get_Objstate.
--  160607  MaIklk  LIM-7568, Removed the check for package part in Generate_Man_Res_HU_Snapshot and used to compare normally.
--  160603  RoJalk  LIM-7467, Modified Find_Shipment___ and removed uncommented code.
--  160519  RoJalk  LIM-7467, Modified Build_Attr_Create_Shipment___, Create_Shipment__, Create_Or_Connect_Shipment___ to support freight handling.
--  160524  MaIklk  LIM-7364, Moved Reserve_Manually_HU__, Unreserve_Manually_HU__ and Generate_Man_Res_HU_Snapshot to Shipment_Handling_Unit_API.
--  160516  reanpl  STRLOC-65, Added handling of new attributes address3, address4, address5, address6 
--  160509  MaRalk  LIM-6531, Modified methods Calculate_Shipment_Charges, Find_Shipment___ and Build_Attr_Create_Shipment___
--  160509          to reflect moving freight related columns from Shipment_Tab to order-Shipment_Freight_Tab.
--  160503  RoJalk  LIM-7310, Renamed Get_Remain_Parcel_Qty to Get_Remaining_Qty_To_Attach.
--  160428  RoJalk  LIM-6811, Replaced Shipment_Handling_Utility_API.Reassign_Connected_Qty__
--  160428          with Reassign_Shipment_Utility_API.Reassign_Connected_Qty__. 
--  160428  RoJalk  LIM-6811, Replaced Shipment_Handling_Utility_API.Reassign_Pkg_Comp_Qty__ 
--  160428          with eassign_Shipment_Utility_API.Reassign_Pkg_Comp_Qty__.
--  160427  RoJalk  LIM-6811, Move code related to reassignment to ReassignShipmentUtility.
--  160426  RoJalk  LIM-6631, Modified Reassign_Pkg_Comp___, All_Lines_Picked, Modify_Qty_To_Ship_Source_Line
--  160426          to include NVL handling for source_ref columns.
--  160422  MaRalk  LIM-7229, Added Get_Converted_Inv_Qty, Get_Converted_Source_Qty.
--  160412  RoJalk  LIM-6631, Added NVL handling for source ref comparisons since it can be null.
--  160411  MaIklk  LIM-6957, Renamed Ship_Date to Planned_Ship_Date in Shipment_tab.
--  160405  MaRalk  LIM-6543, Modified method Build_Attr_Create_Shipment___ to reflect the  
--  160405          change of the column name sender_id as sender_addr_id in Shipment_Tab.
--  160328  MaRalk  LIM-6591, Modified Reassign_Shipment__ by adding parameters source_unit_meas, conv_factor and inverted_conv_factor
--  160328          to Shipment_Line_API.Reassign_Line__ method call. Modified Reassign_Pkg_Comp___ by using shipment line values
--  160328          conv_factor and inverted_conv_factor instead of fetching from customer order line.
--  160328  RoJalk  LIM-6557, Changed the return type of Is_Goods_Non_Inv_Part_Type method to be VARCHAR2.
--  160315  RoJalk  LIM-5719, Removed unused rec type extended_packing_info, renamed order ref as source ref where applicable.
--  160315  RoJalk  LIM-6509, Replaced Customer_Order_Reservation_API.Reassign_Connected_Qty with Shipment_Source_Utility_API.Reassign_Connected_Qty.
--  160314  RoJalk  LIM-6509, Removed unused PLSQL collection packing_qty_tbl. Removed type declaration based on customer_order_reservation_tab.
--  160314  RoJalk  LIM-6511, Modified Reassign_Shipment__ and passed source part info to Reassign_Line__.
--  160308  MaRalk  LIM-5871, Modified source_ref4_ parameter as VARCHAR2 in Create_Shipment___, Find_Shipment___, Build_Attr_Create_Shipment___, 
--  160308          Reassign_Shipment__ and Get_Packing_Qty_Deviation methods. Modified Find_Shipment___, Reassign_Pkg_Comp_Qty__, 
--  160308          Add_Source_Line_To_Shipment, Get_Packing_Qty_Deviation to reflect shipment_line_tab-sourece_ref4 data type change.        
--  160306  RoJalk  LIM-6321, Modified Reassign_Shipment__ and added new_shipment_line_no_ to  Shipment_Line_API.Reassign_Order_Line__.
--  160308  RoJalk  LIM-4107, Added the method Modify_Qty_To_Ship_Source_Line and called from Modify_Shipment_Qty_To_Ship.
--  160304  MaIklk  LIM-4630, Added source_ref_type_db as a parameter to call connect_to_shipment().
--  160225  MaRalk  LIM-4102, Added method Modify_Shipment_Qty_To_Ship by moving the relevant logic of setting qty_to_ship  
--  160225          in Shipment_Line_Tab for non inventory parts from Customer_Order_Line_API.Make_Service_Deliverable__ method.           
--  160202  MaRalk  LIM-6114, Modified methods Create_Or_Connect_Shipment___, Create_Shipment___, Find_Existing_Shipment___,  
--  160202          Find_Shipment___, Build_Attr_Create_Shipment___ and Add_Source_Line_To_Shipment to reflect the  
--  160203          change of the column name ship_addr_no as receiver_addr_id in Shipment_Tab.
--  160202  MaIklk  LIM-6123, Renamed Add_Order_Line_To_Shipment() to Add_Source_Line_To_Shipment() and added Add_Source_Line_To_Shipment__()).
--  160128  RoJalk  LIM-5911, Shipment_Line_API.Get_Connected_Source_Qty with Shipment_Line_API.Get_Conn_Source_Qty_By_Source.
--  160128  RoJalk  LIM-5387, Added shipment_line_no to Reassign_Pkg_Comp_Qty__ method call. 
--  160119  MaIklk  LIM-5751, Made Get_Packing_Qty_Deviation() generic.
--  160118  RoJalk  LIM-5911, Included source_ref_type in Shipment_Line_API.Remove_Shipment_Line, Release_Not_Reserved_Qty__ method calls.
--  160111  MaIklk  LIM-4097, Made Calculate_Freight_Charges method and Calculate_Shipment_Charges generic.
--  160111  RoJalk  LIM-5712, Rename shipment_qty to connected_source_qty in SHIPMENT_LINE_TAB. 
--  160111  RoJalk  LIM-4096, Used handling_unit_pub instead of handling_unit_tab in Unconnected_Structure_Allowed.   
--  160108  RoJalk  LIM-5748, Replaced Shipment_Source_Utility_API.Fetch_Line_Info with Shipment_Source_Utility_API.Fetch_Info.
--  160107  MaIklk  LIM-5749, Modified Build_Attr_Create_Shipment___() to make it generic.
--  160106  RoJalk  LIM-5748, Modified the method Find_Shipment___ and included Shipment_Source_Utility_API.Fetch_Line_Info to make it generic.
--  160106  RoJalk  LIM-4095, Modified Add_Order_Line_To_Shipment and used Shipment_Source_Utility_API.Get_Line to make it generic.
--  160106  MaIklk  LIM-5750, Moved Get_No_Of_Packages_To_Ship___() to ShipmentOrderUtility.
--  160104  RoJalk  LIM-4092, Moved Remove_Picked_Line to Shipment_Order_Utility_API.
--  160104  MaIklk  LIM-5720, Moved Shipment_Connected_Lines_Exist() to ShipmentLine.
--  160104  RoJalk  LIM-5717, Moved the methods Shipment_At_Release___ and Shipment_At_Create_Pick___, Create_Automatic_Shipments to 
--  160104          ShipmentOrderUtility. Added source_ref_type_db_ parameter to the Remove_Shipment_Lines method.
--  151231  HimRlk  Bug 126175, Modified Build_Attr_Create_Shipment___() to consider forwarder_agent_id from consolidation parameters.
--  151229  MaIklk  LIM-5721, Moved the Remove_Shipment_Charges() to Shipment_Freight_Charge_API.
--  151229  MaIklk  LIM-5720, Any_Shipment_Connected_Lines() and Shipment_Connected_Lines_Exist() made generic.
--  151229  MaIklk  LIM-4094, Changed the unpicked_lines in All_Lines_Picked to make it generic.
--  151229  MaIklk  LIM-4093, Removed All_Lines_Delivered() and moved to ShipmentSourceUtility package.
--  151221  MaIklk  LIM-5674, Renamed CUST ORDER NUMBER to SOURCE REF 1 in Consolidated paramters.
--  151215  RoJalk  LIM-5387, Added source ref type to Shipment_Line_API.Check_Active_Shipment_Exist method.
--  151209  MaIklk LIM-4060, Renamed ORDER_NO to SOURCE_REF1 in Shipment_tab.
--  151202  RoJalk LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202         SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151119  RoJalk LIM-4886, Make Shipment Line Generic - Rename SALES_QTY to SHIPMENT_QTY, REVISED_QTY_DUE to INVENTORY_QTY.
--  151113  MaEelk LIM-4453, Removed PALLET_ID related codes
--  151110  MaIklk LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151110  RoJalk LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  150504  JeLise LIM-1893, Added handling_unit_id_ in LU calls where applicable.
--  150901  RiLase AFT-2024, Added method Reassign_Handling_Unit___ and new alternative method interface for Reassign_Handling_Unit to be able to use info message in WADACO.
--  150526  IsSalk KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  150625  ChBnlk ORA-892, Modified Create_Shipment___() by moving the attribute string manipulation to seperate method. Introduced new method Build_Attr_Create_Shipment___() for the attr_ manipulation.
--  150617  RILASE COB-579, Added Get_Tot_Packing_Qty_Deviation.
--  150417  FAndSE COB-342, Add_Order_Line_To_Shipment removed conditions for shipment_connected and shipment creation from get_order_line cursor.
--  150417         This caused problem for call from the new Order Lines Available for Shipments window. The check was redundant since this is checked before calling the method.
--  140919  NaLrlk Modified Create_Shipment___() to consider IPT_RO demand_code for replacement rental.
--  140819  RoJalk Added the method Remove_Shipment_Lines.
--  140808  RoJalk Added the parameter 'RELEASE_NOT_RESERVED' to the Shipment_Order_Line_API.Release_Not_Reserved_Qty__ method calls.
--  140520  RoJalk Modified Create_Shipment___ and corrected the logic to fetch the forward_agent_id. 
--  140506  RoJalk Modified Create_Shipment___ and added code to copy consolidated parametrs, freight_price_list_no, freight_map_id, zone_id from source shipment for Reassignment of HU. 
--  140505  RoJalk Replaced the usage of order_head_rec_ with co_rec_ in Create_Shipment___
--  140425  SURBLK Modified Create_Shipment___() by adding nvl into language_code_.
--  140318  AyAmlk Bug 115778, Modified Create_Shipment___(), to prevent creating a shipment when the supply_country is different from the Site Country.
--  140318  MeAblk Removed method Get_No_Of_Open_Shipments.
--  140224  RoJalk Modified REASSIGN_CONNECTED_COMP_QTY and added rowkey.
--  140221  RoJalk Modified Release_Not_Reserved_Qty__ to consider conversion factors for PKG parts.
--  140219  FAndSE Removed validation of if pick list lines to report exists in Remove_Reserved_Line. Moved to ShipmentOrderLine to cover partly picked lines.
--  140219  FAndSE Find_Shipment___, the get_shipment_id in the cursor is corrected the grouping per location_no was not correct.
--  140218  RoJalk Added conv_factor, inverted_conv_factor to the REASSIGN_CONNECTED_COMP_QTY view.
--  140206  FAndSE BI-3447: Modified CURSOR unreported_pick_lists_exist to consider that we now can have multiple shipments per pick list.
--  140304  FAndSE PBSC-3168: Merge issue - Changes due to functional conflict between support bug 108291 and Billabong, change of COL quantity when connected to shipment.
--  140227  KiSalk Bug 114398, Made Remove_Picked_Line operates on attr_ when it grows exceeding 31000 characters, not to exceed 32000 with safety margin.
--  140124  MeAblk Added new method Get_No_Of_Open_Shipments. 
--  131021  RoJalk Corrected code indentation issues after merge.
--  130930  SudJlk Bug 112764, Modified CUSTOMER_ORDER_LINE_SHIPMENT to correct the mistake made in condition for filtering Invoiced and Cancelled CO headers through Bug 109280 correction.  
--  130912  ErFelk Bug 111147, Modified Get_Next_Index___() and Any_Previous_Pallet_For___() by making them PROCEDURES. Modified Collect_Packages_To_Pallets___() 
--  130912         to handle the out parameter values of the above procedures.
--  130827  IsSalk Bug 112056, Modified method Remove_Reserved_Line() to close the Open Cursor unreported_pick_lists_exist which was not closed within the method.
--  130802  SudJlk Bug 109280, Modified CUSTOMER_ORDER_LINE_SHIPMENT to filter out Invoiced and Cancelled CO headers to improve performance.
--  130905  JeLise Modified Get_Packing_Qty_Deviation to show the correct value for package components and for non-inventory parts.
--  130904  MaEelk Removed the method Modify__ since it is used no more. Moved the view SHIPMENT_CONNECTABLE_LINE to ShiomentOrderLine.apy
--  130905  RoJalk Added the method All_Lines_Reserved.
--  130903  RoJalk Added the columns part_ownership, owner to the view REASSIGN_CONNECTED_COMP_QTY.
--  130902  JeLise Added method Get_Packing_Qty_Deviation and calling it from Any_Packing_Qty_Deviation___.
--  130901  RoJalk Modified Release_Not_Reserved_Qty__ and replaced ROUND with CEIL in get_max_pkg_comp_reserved cursor.
--  130830  RoJalk Moved Reassign_Connected_Pallets__,Reassign_Connected_Qty__ from Customer_Order_Reservation_API to Shipment_Handling_Utility_API and updated the usage.
--  130829  RoJalk Added the method Release_Not_Reserved_Qty__.
--  130828  RoJalk Modified Reassign_Pkg_Comp___ and changed the error text QTYREASSINNULL, modified the view comments for REASSIGN_CONNECTED_COMP_QTY.
--  130826  JeLise Added convertion of structure_connected_qty_ in Any_Packing_Qty_Deviation___.
--  130823  MaEelk Added Calculate_Shipment_Charges and Calculate_Freight_Charges. 
--  130823         Calculate_Shipment_Charges will calculate freight charges of all shipments in the shipment_id_tab_ that are not in Cancelled state while
--  130823         Calculate_Freight_Charges  will find all shipments having this sales part no and, calculate freight charges for them using Calculate_Shipment_Charges.
--  130822  RoJalk Modified Reassign_Pkg_Comp___ and passed do_release_reservations_ to the method Shipment_Order_Line_API.Reassign_Pkg_Comp__.
--  130822  RoJalk Modified Reassign_Pkg_Comp___ and used Customer_Order_Line_API.Get instead of different get methods.Changed the scope of Clear_Temporary_Table___ to be private.
--  130821  MaMalk Added default order line parameters to method Shipment_Connected_Lines_Exist to call this method from customer order line.
--  130821  RoJalk Modified Reassign_Pkg_Comp___ and the view REASSIGN_CONNECTED_COMP_QTY to handle non inventory parts as pKG components in reassignment flow.
--  130821  RoJalk Modified Reassign_Pkg_Comp___ and included the validation to check if all shipment lines have qty to reassign defined. 
--  130820  RoJalk Added the method Get_Qty_To_Ship_Reassign to calculate qty_to_ship to reassign.
--  130819  RoJalk Modified Reassign_Pkg_Comp_Qty__ and removed QTY_PER_ASSEMBLY from attr. 
--  130816  MAHPLK Modified Create_Shipment___ to set the value for APPROVE_BEFORE_DELIVERY_DB, when creating a shipment.
--  130816  RoJalk Removed the parameters pkg_not_reserv_qty_available_, pkg_reserved_qty_available_ from Reassign_Pkg_Comp_Qty__. Added Clear_Temporary_Table___.
--  130816         Modified Reassign_Pkg_Comp_Qty__ to use reassign_ship_component_tmp for both components and reservations.
--  130813  RoJalk Moved the methods Fill_Temporary_Table__, Reassign_Reserved_Pkg_Comp__ from CUSTOMER_ORDER_RESERVATION_API.
--  130805  MaEelk Removed obsolete method Generate_Package_Structure
--  130805  MeAblk Modified method Create_Shipment___ by removing the attribute setting MULTI_LOT_BATCH_PER_PALLET_DB, SHIPMENT_MEASURE_EDIT_DB.
--  130731  RoJalk Added the new parameters pkg_revised_qty_reassigned_, do_complete_ to the method Reassign_Pkg_Comp_Qty__.
--  130730  MaEelk Removed views SHIPMENT_HANDLING_UTILITY and SSCC_HANDLING_UTILITY. obsolete methods and codes related to Package Structure. 
--  130730         Moved Is_Number___ and Vaidate_Sscc to Handling_Unit_API
--  130726  MaEelk Removed obsolete methods and codes related to Package Structure
--  130725  MeAblk Removed method Collect_Packages_To_Pallets___ since no any usage.
--  130724  RoJalk Modified Reassign_Pkg_Comp_Qty__ and included qty_per_assembly  reassigned_from_reserved.
--  130724  MeAblk Changed the references of Pallet_Type_API and Pallet_Type_Tab into Handling_Unit_Type_API and Handling_Unit_Type_Tab.
--  130723  MaMalk Moved SHIPMENT_ORDER_LINE_OVW to ShipmentOrderLine.apy since the rowkey is taken from shipment_order_line_tab.
--  130718  RoJalk Moved the view REASSIGN_SHIP_CONNECTED_QTY from SHIPMENT_ORDER_LINE_API.
--  130717  RoJalk Modified Reassign_Pkg_Comp_Qty__ and replaced the usage of not_reserved_msg_, reserved_msg_ with message_. Used customer_order_reservation_
--  130717         to differentiate between Customer Order Reservation lines and not reserved component line quantity.
--  130716  MaMalk Modified Create_Shipment___ to pass the load sequence no to the shipment when the route is defined as a consolidation parameter.
--  130711  RoJalk Added the method Reassign_Pkg_Comp_Qty__ to handle reassignment of PKG components.
--  130709  MaIklk TIBE-1027, Fixed to close the unreported_pick_lists_exist curosr.
--  130619  RoJalk Modified Reassign_Handling_Unit and included the info messages to indicate shipment state.
--  130612  RoJalk Modified Reassign_Handling_Unit and moved the warning messages to the client.
--  130612  RoJalk Modified the calling places of Customer_Order_Reservation_API.Modify_Line_Reservations and included the parameter transfer_on_add_remove_line.
--  130607  RoJalk Addd the parameter qty_to_ship_to_reassign_, removed source_revised_qty_due_, source_sales_qty_  from Reassign_Shipment__.
--  130605  RoJalk Modified Reassign_Handling_Unit and called Handling_Unit_API.Modify_Parent_And_Shipment instead of Handling_Unit_API.Reassign_Structure.
--  130604  RoJalk Added the validation SHIPBLOCKED to the beginning of the method Reassign_Handling_Unit to be raised in the start of the flow.
--  130529  RoJalk Added the parameter source_shipment_rec_ to the method Create_Reassign_Shipment___ and modified the method Reassign_Handling_Unit
--  130531         to validate source shipment. Modified Reassign_Handling_Unit and added the parameter info_.
--  130522  RoJalk Modified Reassign_Shipment__ and removed unused cursor get_valid_dest_shipment.
--  130520  RoJalk Modified Reassign_Shipment__ and included validations for destination shipment id. 
--  130516  RoJalk Modified Reassign_Handling_Unit and assigned correct value for to_shipment_id.  
--  130515  RoJalk Modified Reassign_Handling_Unit and changed to_shipment_id_ to be a in out paramater.
--  130515  RoJalk Modified Create_Shipment___ to fetch consignee_reference from source shipment during reassignment flow.
--  130513  RoJalk Removed the address related parameters from Shipment_Handling_Utility_API.Reassign_Shipment__. Added Create_Reassign_Shipment___.
--  130514  RoJalk Modified Create_Shipment___ to fetch address information from source shipment when reassignment flow is used. 
--  130513  RoJalk Modified Reassign_Shipment__ and removed source_revised_qty_due_,  source_sales_qty_  parameters from Shipment_Order_Line_API.Reassign_Order_Line__ method call.
--  130513  RoJalk Added the method Reassign_Handling_Unit to be used in reassign the handling units functionality.
--  130513  ErFelk Bug 109612, Added Check_Move_To_Pallet() and removed error messages DIFFWDRNCOL and DIFFWDRNPKG which was introduced from bug 84186.
--  130507  MeAblk Modified method Any_Packing_Qty_Deviation___ in order to by pass the validations done when trying to partially deliver non-inventory component part. 
--  130507         Also adjust the validation when it all have non-inventory component parts for the package.
--  130503  ErFelk Bug 109612, Removed Check_Move_To_Pallet() as the restrictions are no longer needed.
--  130503  MeAblk Modified methods Any_Packing_Qty_Deviation___, Structure_Exist___, Any_Shipment_Qty_Deviation in order to correctly do the validations relating to setting the Shipment into 
--  130503         'Complete' based on whether unattached shipment lines allowed for the Shipment.
--  130503  RoJalk Modified SHIPMENT_ORDER_LINE_OVW to align with shipment order line keys.
--  130423  MaMalk Introduced Shipment_At_Release___ and Shipment_At_Create_Pick___ and removed the other 4 methods we had for shipment creation.
--  130423         and removed Find_Shipment_For_Order___ and modified Find_Shipment___. The Shipment Creation Methods were reduced to 3 from 5.
--  130422  RoJalk Added the column revised_qty_due to the view  SHIPMENT_ORDER_LINE_OVW. 
--  130418  RoJalk Removed the method  No_Delivered_Lines and replaced the usages with ship_date not null check.
--  130416  MeAblk Added attribute packing_instruction_id into the view SHIPMENT_CONNECTABLE_LINE.
--  130410  RoJalk Added the parameters source_revised_qty_due_,  source_sales_qty_ to the method Reassign_Shipment__. 
--  130328  JeLise Added handling_unit_type_id to view SHIPMENT_CONNECTABLE_LINE and added call to Shipment_Order_Line_API.Is_Instance_Exist in Modify__.
--  130328  RoJalk Modified Any_Shipment_Qty_Deviation to include the shipment id in the eror message QTYDEV.
--  130322  RoJalk Added the column part_no ot the SHIPMENT_ORDER_LINE_OVW. 
--  130322  RoJalk Added the method Reassign_Shipment__ , modified the scope of the method Create_Or_Connect_Shipment__ to be implementation.
--  130318  RoJalk Modified the scope of the Create_Or_Connect_Shipment___ method to be private.
--  130222  JeLise Added method Get_Available_Quantity.
--  130221  JeLise Removed the cursor and checks on qty_assigned and qty_picked in Get_Remain_Parcel_Qty.
--  130221  RoJalk Modified Find_Shipment_For_Order___ and added the condition auto_connection_blocked = 'FALSE'.
--  130214  RoJalk Renamed the column fixed to be auto_connection_blocked and modified the references.
--  130212  RoJalk Modified the cursor get_existing_shipment in Find_Shipment___ to handle the fixed column.
--  130212  RoJalk Removed sales_qty_order, reserved_qty_order, delivered_qty_order, qty_to_ship_order from the view SHIPMENT_ORDER_LINE_OVW becuse it si no longer used from client. 
--  130212  SBalLK Bug 107802, Modified Create_Shipment_At_Release___() and Add_To_Shipment_At_Release___() methods to restrict creating shipment when supply code IPD is used.
--  130212         Modified 'CUSTOMER_ORDER_LINE_SHIPMENT' view to have package which jave supply code IPD for component parts.
--  130211  SBalLK Bug 107364, Modified Create_Shipment_At_Release___() method to find shipment even in first attempt to create shipment.
--  130209  RoJalk Added the column qty_to_pick the view  SHIPMENT_ORDER_LINE_OVW.
--  130207  JeLise Removed columns and added group by in view SHIPMENT_CONNECTABLE_LINE and added cursor in Get_Remain_Parcel_Qty.
--  130201  IsSalk Bug 108033, Modified view VIEW_SHIPMENT to consider the rowstate of the component lines to add package part lines
--  130201         which contains cancelled component lines with supply codes IPD, PD, ND, SEO.
--  130201  NWeelk Bug 108155, Modified method Create_Shipment___ by removing unnecessary Get methods, used co_line_rec_ 
--  130201         demand_code without calling the Get method and assigned order_head_rec_ data for consignee_ref_.
--  130129  RoJalk Code improvements to the method All_Lines_Picked, modified Create_Automatic_Shipments and removed the NOPICKCRESHIP validation
--  130129         since pick list creation is possible for already shipment connected customer order lines. 
--  130128  MaMalk Replaced CREATE_PICK_LIST_JOIN with CREATE_PICK_LIST_JOIN_MAIN.
--  130123  RoJalk Modified the cursors in Add_To_Shipment_At_Pick___/Create_Shipment_At_Pick___  and added cor.shipment_id  = 0. 
--  130122  JeLise Added remaining_parcel_qty in view SHIPMENT_CONNECTABLE_LINE to be used for the new Handling Unit functionality.
--  130111  RoJalk Create_Shipment_At_Pick___ , Add_To_Shipment_At_Pick___, Add_Order_Line_To_Shipment to allow shipment connection even if order line is  
--  130111         shipment connected but the shipment_creation in CREATE NEW AT PICKLIST, ADD TO EXIST AT PICKLIST. Modified CUSTOMER_ORDER_LINE_SHIPMENT to 
--  130111         include picked CO lines with no pick listed reservations not yet picked for shipment ID = 0.  
--  130109  RoJalk Several shipments per CO line, modified Any_Packing_Qty_Deviation___, Get_No_Of_Packages_To_Ship___ and removed the method Any_Packing_Qty_Deviation___ without the shipment id. 
--  130104  RoJalk Modified All_Lines_Picked, Get_No_Of_Packages_To_Ship___ to support multiple shipments per CO line and new columns in shipment order line.
--  130104  MeAblk Modified view  VIEW_OVW(SHIPMENT_ORDER_LINE_OVW) in order to retrieve the package component parts. Also added qty_to_ship, qty_to_ship_order, catalog_type.  
--  130103  KiSalk Bug 106705, Modified Where clause of CUSTOMER_ORDER_LINE_SHIPMENT to improve performance.
--  121220  JeLise Added new method Get_Remain_Parcel_Qty to support the new Handling Unit functionality.
--  121219  RoJalk Modified Get_Remain_Parcel_Qty and added code to fetch qty_picked_, qty_reserved_.
--  121130  RoJalk Removed the method Get_Remain_Parcel_Qty with the order line reference.
--  121128  RoJalk Modified Remove_Reserved_Line and modified the parameter list for Customer_Order_Reservation_API.Modify_Line_Reservations.
--  121123  SBalLK Bug 106634, Added parameter pick_list_no to the method Get_Remain_Parcel_Qty and modified view SHIPMENT_CONNECTABLE_LINE and SHIPMENT_HANDLING_UTILITY by
--  121121  RoJalk Modified the view SHIPMENT_CONNECTABLE_LINE, Find_Packing_Quantity___, Get_Remain_Parcel_Qty to support multiple shipments per CO line.
--  121116  RoJalk Modified Remove_Picked_Line and changed the parameter order of Deliver_Customer_Order_API.Deliver_Line_Inv_Diff.
--  121115  RoJalk Modified Add_Order_Line_To_Shipment and replaced SHIPMENT_ORDER_LINE_API.Get_Active_Shipment_Id with Shipment_Order_Line_API.Check_Active_Shipment_Exist.
--  121109  MaMalk Modified method Find_Shipment___ to include only Normal shipments when searching for the existing shipments.
--  121106  RoJalk Removed unused overloaded methods Get_Reserved_Remain_Qty.
--  121102  RoJalk Allow connecting a customer order line to several shipment lines - Modified Remove_Picked_Line, Get_Remain_Parcel_Qty,  Create_Pallets_On_Shipment__,  
--  121102         Create_Packages_On_Shipment___, Find_Packing_Quantity___. Modified Remove_Reserved_Line and called Customer_Order_Reservation_API.Modify_Line_Reservations.    
--  121102  MaMalk Changed the decimal format for buy_qty_due in view Customer_Order_Line_Shipment.
--  121102  MaEelk Modified CUSTOMER_ORDER_LINE_SHIPMENT to handle multiple shipments connected to a customer order line.
--  121102  MaMalk Modified view SHIPMENT_ORDER_LINE_OVW to show both customer order line and shipment order line quantities.
--  121023  MAHPLK BI-677, Modified rowstate to 'Completed' in completed_shipment cursor in Create_Automatic_Shipments.
--  120921  MeAblk Removed parameter shipment_type_ from the method Add_Order_Line_To_Shipment and modify it accordingly in order to get the shipment type from the
--  120921         customer order line.
--  120921  MeAblk Added new parameter show_shipment_id_ into the methods Generate_Package_Structure, Generate_Package_Structure___, Raise_Error_On_Basic_Data___. 
--  120921         And modified method Raise_Error_On_Basic_Data___ in order to show the shipment id in Generate Structure of Shipments window.   
--  120912  MeAblk Modified Create_Shipment___ in order to avoid getting the shipment inventory location no from the site directly.
--  120829  MeAblk Modified the view CUSTOMER_ORDER_LINE_SHIPMENT in order to get the shipment type from the customer order line.
--  120824  MeAblk Removed the parameter shipment_type_ parameter from the methods Create_Shipment_At_Release___, Create_Shipment_At_Pick___, Add_To_Shipment_At_Release___
--  120824  Add_To_Shipment_At_Pick___.
--  120821  JeLise Changed from calling Handling_Unit_Type_API to S_Handling_Unit_Type_API and from Handling_Unit_Accessory_API to S_Handling_Unit_Accessory_API.
--  120821  HimRlk Modified Create_Or_Connect_Shipment___, Create_Shipment___, Find_Shipment___, Find_Existing_Shipment___, Find_Shipment_For_Order___ by adding 
--  120821         new parameter use_price_incl_tax. 
--  120820  HimRlk Added use_price_incl_tax_db to view CUSTOMER_ORDER_LINE_SHIPMENT.
--  120724  RoJalk Added the method Get_Packages_On_Pallet returning Handling_Unit_Id_Tab.
--  120712  RoJalk Added the shipment_type_ parameter to the methods Create_Or_Connect_Shipment___, Create_Shipment___ Find_Shipment___, Find_Existing_Shipment___ ,
--  120712         Create_Shipment_At_Release___, Create_Shipment_At_Pick___ , Add_To_Shipment_At_Release___, Add_To_Shipment_At_Pick___, Find_Shipment_For_Order___.  
--  120710  RoJalk Added shipment_type to the view CUSTOMER_ORDER_LINE_SHIPMENT. 
--  121123         adding pick_list_no as a parameter to the method call Get_Remain_Parcel_Qty.
--  120803  ChFolk Modified Get_Pallet_Def_Weight_Volume and Get_Pallet_Weight_Volume to replace usages of Company_Distribution_Info_API with
--  120803         Company_Invent_Info_API during SP1 merge.
--  120704  RuLiLk Bug 102220, Added procedures Get_Pallet_Weight_Volume and Get_Pallet_Def_Weight_Volume to calculate weight and volume.
--  120106  AyAmlk Bug 100608, Increased the length to 5 of column delivery_terms in view CUSTOMER_ORDER_LINE_SHIPMENT and delivery_terms_ in Add_Order_Line_To_Shipment().
--  120305  AyAmlk Bug 101058, Added the variable co_line_addr_flag_db_ and modified the WHERE clause in the cursor not to check ship_address_no_ when the address is single
--  120305         occurrence in Find_Shipment___() and in Find_Shipment_For_Order___().
--  120207  DaZase Changed reserved_qty in SHIPMENT_ORDER_LINE_OVW so it uses Shipment_Order_Line_API.Get_Ordline_Reserved_Qty instead of Customer_Order_Line_API.Get_Full_Qty_Assigned.
--  111230  GiSalk SSC-2499, Modified cursor shipment_lines in function Shipment_Connected_Lines_Exist to select only from shipment_order_line_tab.
--  111205  MaMalk Added pragma to Get_Net_Summary.
--  111101  NISMLK SMA-289, Increased current_chg_eng_ length to VARCHAR2(6) in Collect_Packages_To_Pallets___ method.
--  111006  JeLise Added in parameter location_no_ to Collect_Parts___, Collect_Parts_Into_Packages___ and Collect_Parts_Into_Packages___. Added location_no in cursor
--  111006         reserved_qty in Find_Package_Quantity___.
--  111003  JeLise Added parameter location_no_ in call to Shipment_Package_Unit_API.Add_New_Package and Handling_Unit_Part_API.Add_Parts_To_Pallet in Collect_Parts___.
--  110909  MaMalk Modified Remove_Handling_Unit to calculate charges for the connected order lines from the scratch when no structure exists after removal.
--  110720  SurBlk Bug 97704, Added attribute sales_unit_meas to SHIPMENT_ORDER_LINE_OVW view.
--  110707  MaMalk Added the user allowed site filteration to CUSTOMER_ORDER_LINE_SHIPMENT.
--  110516  MiKulk Added a condition to the CUSTOMER_ORDER_LINE_SHIPMENT to filter the freight connected customer order lines which are in Partially Delivered state.
--  110303  MaMalk Modified method Find_Shipment___ to find a shipment with matching supply country and Create_Shipment___ to raise an error when the CO supply country differs.
--  110131  Nekolk EANE-3744  added where clause to View SHIPMENT_ORDER_LINE_OVW,SSCC_HANDLING_UTILITY
--  110303  MaMalk Added methods Remove_Freight_Charges, Shipment_Connected_Lines_Exist and added supply_country to the view CUSTOMER_ORDER_LINE_SHIPMENT.
--  101021  NWeelk Bug 93570, Added parameter location_no_ to the method Get_Remain_Parcel_Qty and modified view SHIPMENT_CONNECTABLE_LINE by
--  101021         adding location_no as a parameter to the method call Get_Remain_Parcel_Qty.
--  100920  NWeelk Bug 93023, Modified method Remove_Picked_Line by adding remove_ship_ to the parameter list.
--  100827  SaJjlk Bug 92668, Modified method Remove_Picked_Line to consider the part_no instead of catalog_no in cursor get_delivery.
--  100607  KiSalk Added Order_Lines_Connected.
--  100513  KRPELK Merge Rose Method Documentation.
--  100617  ShKolk Used new backorder_option_db_ values instead of old values.
--  091001  MaMalk Removed unused code in Create_Shipment___ and  Add_Order_Line_To_Shipment.
--  ------------------------- 14.0.0 -----------------------------------------
--  100426  JeLise Renamed zone_definition_id to freight_map_id.
--  091123  ErFelk Bug 86516, Modified Create_Shipment_At_Pick___ and Add_To_Shipment_At_Pick___ by checking the customer order line is fully reserved.
--  091118  AmPalk Bug 86635, Added key_unit_id column. On the Shipment window when TechnicalObjectReference used, the column acts like a key to the SHIPMENT_HANDLING_UTILITY.
--  090807  MaMalk Bug 84186, Added attribute waiv_dev_rej_no to all the necessary views and methods.
--  090720  Cpeilk Bug 84587, Added a warning to display no pick list created in method Create_Automatic_Shipments.
--  090625  IrRalk Bug 82835, Modified methods Get_Package_Volume and Get_Loaded_Pallet_Weight to change volume to 6 dicimals and weight to 4 decimals.
--  090519  SaWjlk Bug 80588, Added activity_seq column to the select statement and  activity_seq to the attribute string in the Remove_Picked_Line procedure.
--  090515  SuJalk Bug 80760, Removed function Get_Available_Quantity.
--  090420  DaGulk Bug 80511, Modified procedure Create_Shipment___ by adding SHIP_INVENTORY_LOCATION_NO to the attribute list.
--  090410  SaWjlk Bug 81492, Added NOCHECK for activity_seq in CUSTOMER_ORDER_LINE_SHIPMENT and SHIPMENT_ORDER_LINE_OVW views.
--  081223  SuJalk Bug 79451, Added wanted_delivery_date to the SELECT statement of CUSTOMER_ORDER_LINE_SHIPMENT view. Also added method Get_Available_Quantity.
--  081211  SaRilk Bug 77033, Modified the proceduresAdd_To_Shipment_At_Pick___, Create_Shipment_At_Pick___, Add_To_Shipment_At_Release___ and Create_Shipment_At_Release___
--  081205         by changing the variable temp_ to dummy_.
--  081205  SaRilk Bug 77033, Modified the procedures Add_Order_Line_To_Shipment, Find_Shipment___, Add_To_Shipment_At_Pick___, Create_Shipment_At_Pick___, Add_To_Shipment_At_Release___
--  081205         and Create_Shipment_At_Release___ and added the procedure Find_Existing_Shipment___ to ignore existing Shipments and to group the shipments that can be added 
--  081205         together when executing Create Consolidated Pick List. 
--  081029  SuJalk Bug 76539, Modified the Create_Shipment___ method to assign the correct value for consignee ref according to the demand code.
--  081015  NaLrlk Bug 74689, Modified the method Create_Shipment___ to fetch the correct language_code.
--  080815  SaJjlk Bug 76233, Restructured methods Any_Packing_Qty_Deviation___ to handle non inventory parts of type Service.
--  080711  NaLrlk Bug 73533, Added methods Remove_All_Handling_Units and Remove_All_Package_Units.
--  090513  ShKolk Modified Remove_Handling_Unit() to pass correct shipment_id_.
--  090506  MiKulk Modified the method Create_Shipment___ in order to set values for zone_definition_id, zone_id and price_list_no when automatically creating the shipment.
--  090430  NaLrlk Added view SSCC_HANDLING_UTILITY.
--  090428  NaLrlk Added method Validate_Sscc and Is_Number___.
--  090427  NaLrlk Added method Connect_Sscc, Modify_Sscc_On_Handling_Unit__ and Modify_Sscc_On_Package_Unit__.
--  090423  ShKolk Added function call to Shipment_Freight_Charge_API.Calculate_Shipment_Charges() to calculate freight charges.
--  090415  NaLrlk Added column SSCC to view SHIPMENT_HANDLING_UTILITY and method Check_Exist_For_Sscc.
--  090302  KiSalk Added parameters adjusted_net_weight_ and total_tare_weight_ to Get_Net_Summary.
--  090226  MaHplk Added new method Any_Shipment_Conn_For_Site.
--  081120  AmPalk Modified Generate_Package_Structure___ and Collect_Parts___ to consider Partca_Company_Sal_Part freight information with the instances 
--  081120         'Use Site Specific Freight Information' marked as FALSE, on the sales part. 
--  080325  SaJjlk Bug 70056, Modified method Create_Shipment___ to retrieve the Customer Reference from the first CO when creating a new Shipment.
--  080131  NaLrlk Bug 70005, Added parameter del_terms_location_ to the methods Create_Or_Connect_Shipment___ and Create_Shipment___, and modified places they're called.
--  080121  LaBolk Bug 70649, Added parameter forward_agent_id_ to methods Create_Or_Connect_Shipment___ and Create_Shipment___, and modified places they're called.
--  080121         Added logic in method Add_Order_Line_To_Shipment to pass forward_agent_id from CO line to method Create_Or_Connect_Shipment___.
--  080119  LaBolk Bug 70536, Modified method Add_To_Shipment_At_Pick___ to change the cursor to use a sub-select instead of a join, to check the pick list no.
--  080116  HaPulk Bug 70092, Added new condition to filter records with rowstate 'Released', 'Reserved' and 'PartiallyDelivered' 
--  080116         from view CUSTOMER_ORDER_LINE_SHIPMENT.
--  080114  SaJjlk Bug 70217, Added columns input_unit_meas, input_qty, input_conv_factor 
--  080114         and input_variable_values to view CUSTOMER_ORDER_LINE_SHIPMENT.
--  080104  ThAylk Bug 70284, Modified methods Add_To_Shipment_At_Pick___, Add_To_Shipment_At_Release___, Create_Shipment_At_Release___ and 
--  080104         Create_Shipment_At_Pick___ to stop fetching 'Cancelled order lines' when creating shipments.    
--  071210  SaJjlk Bug 66397, Modified method All_Lines_Picked to allow delivery of incomplete package parts.
--  070726  JaBalk Added constant SHIPMENTSTATE and used it in SHIPMENT_ORDER_LINE_OVW
--  070712  NuVelk Bug 66305, Modified method Create_Empty_Package to check whether the handling unit is simplified.
--  070704  MiKulk Bug 64082, Modified method Get_Remain_Parcel_Qty and view SHIPMENT_CONNECTABLE_LINES.
--  070703  MiKulk Bug 66012, Modified method Check_Move_To_Pallet to allow connecting of differnet parts 
--  070703         with different revision numbers to the same package unit.
--  070503  AmPalk Bug 64284, Added attribute customer_address_name to view CUSTOMER_ORDER_LINE_SHIPMENT.
--  070503         Modified cursors of method Find_Shipment___ and Find_Shipment_For_Order___ to consider addr_1 (customer name) as well.
--  070430  NiDalk Bug 64107, Modified method Get_Net_Summary to calculate volumes correctly.
--  070405  NaLrlk Bug 64179, Modified SHIPMENT_HANDLING_UTILITY and SHIPMENT_CONNECTABLE_LINE views to fetch the part description 
--  070405         from Customer_Order_Line_API.Get_Catalog_Desc().          
--  070328  SuSalk LCS Merge 63028, Modified view SEND_DELNOTE_FOR_SHIPMENT to fetch objversion from shipment_tab.
--  070328         Added view SEND_DELNOTE_FOR_SHIPMENT.
--  070327  NaLrlk Bug 64086, Increased the length of the table type lot_batch_list to 25.
--  070314  NaLrlk Bug 63588, Modified view CUSTOMER_ORDER_LINE_SHIPMENT to display available package parts order lines for the shipment correctly.
--  070314  MaRalk Bug 63361, Added attribute type_of_goods to the view SHIPMENT_HANDLING_UTILITY. Modified method Collect_Parts___
--  070314         in order to add in parameter type_of_goods when calling method Shipment_Package_Unit_API.Add_New_Package.
--  070228  SaJjlk Modified cursor get_new_ship_lines in Create_Shipment_At_Pick___. 
--  070223  SaJjlk Modified method Create_Shipment_At_Pick___ to check whether there exist any open shipments for a given CO.
--  070219  SaJjlk Removed method Get_Address_Info___ and view CUST_ORD_ADDRESS. 
--  070216  PrPrlk Modified the methods Create_Shipment_At_Pick___, Add_To_Shipment_At_Pick___ and Add_Order_Line_To_Shipment to allow connecting package parts to shipments.
--  070214  PrPrlk Modified the methods Create_Shipment_At_Release___ and Add_To_Shipment_At_Release___ to validate for CO lines already connected to shipments.
--  070212  RaNhlk Modified method get_Net_Summary to calculate the gross_weight correctly.
--  070212  SaJjlk Changed method Get_Address_Info___, Create_Shipment___, Find_Shipment___ and Find_Shipment_For_Order___ to retrive customer address name correctly.
--  070208  RaNhlk removed methods Get_Net_Weight, Get_Gross_Weight and Get_Total_Volume.
--  070208  PrPrlk Sorted the parameter order in method Create_Automatic_Shipments, Create_Shipment_At_Pick___, Add_To_Shipment_At_Pick___ and Add_Order_Line_To_Shipment.
--  070208         Added a new OUT parameter shipment_id_tab_ to methods Create_Shipment_At_Release___ and Add_To_Shipment_At_Release___ and extended their logic to return the list of Shipment id's.   
--  070205  PrPrlk Restructured the view CUSTOMER_ORDER_LINE_SHIPMENT.
--  070205  PrPrlk Added a new out parameter shipment_id_ to the method Add_Order_Line_To_Shipment.
--  070205         Added a new OUT parameter shipment_id_tab_ to method Create_Automatic_Shipments that will be used to store the created list of shipments.
--  070205         Added an IN OUT type variable shipment_id_ to the method Create_Or_Connect_Shipment___.
--  070205         Added an IN OUT Shipment_API.Shipment_Id_Tab to the methods Create_Shipment_At_Pick___ and Add_To_Shipment_At_Pick___.
--  070201  RaNhlk Modified methods Create_Shipment__ and Get_Net_Summary().
--  070131  RaNhlk Modified view SHIPMENT_HANDLING_UTILITY and added a new method Unconnected_Structure_Allowed.
--  070131         Modified methods Modify__,Get_Total_Volume,Get_Gross_Weight and Get_Loaded_Pallet_Weight.
--  070131  SaJjlk Added method Get_Address_info___ and renamed one of the Find_Shipment___ methods to Find_Shipment_For_Order___.
--  070131         Modified cursors in methods Find_Shipment___ and Find_Shipment_For_Order___ and modified method Create_Shipment___
--  070131         to handle Customer Address information when creating shipments. Added view CUST_ORD_ADDRESS
--  070131         Modified view CUSTOMER_ORDER_LINE_SHIPMENT. 
--  070129  PrPrlk Renamed methods Create_New_Shipment___ and Add_To_Existing_Shipment___ to Create_Shipment_At_Release___
--  070129         and Add_To_Shipment_At_Release___ respectively to better reflect their purpose.
--  070129         Added new method Create_Shipment_At_Pick___ to handle connecting CO lines with shipment_creation 'CREATE NEW AT PICKLIST'.
--  070129         Added new method Add_To_Shipment_At_Pick___ to handle connecting CO lines with shipment_creation 'ADD TO EXIST AT PICKLIST'.
--  070129         Modified the method Create_Automatic_Shipments to make calls to the renamed and new newly added methods mentioned above.
--  070129         The logic in method Add_Order_Line_To_Shipment will be extended to handle CO lines with the new shipment creation options.
--  070129         The view CUSTOMER_ORDER_LINE_SHIPMENT was modified to include partially delivered CO Lines.
--  070125  SaJjlk Modified cursors in methods Add_To_Existing_Shipment___ and Create_New_Shipment___
--  070125         to avoid creating shipments when the supply code is Not Decided on the order line.
--  070125         Added public method Any_Shipment_Connected_Lines.
--  060802  MaMalk Replaced OrderDeliveryTermDesc and MpccomShipViaDesc with OrderDeliveryTerm and MpccomShipVia.
--  060613  JoEd   Bug 58762. Rebuild Get_Remain_Parcel_Qty to include lot/batch, EC and serial no.
--  060609  JoEd   Bug 58344. Removed error message for serial numbers in Check_Move_To_Pallet.
--  060601  MiErlk Enlarge Identity - Changed view comments - Description.
--  060530  JoEd   Bug 58344. Added handling of serial numbers in packages and on pallets.
--                 Added column serial_no to joined views. Changed CONN_VIEW's remain_parcel_qty
--                 to display a more correct quantity - according to the corresponding server code.
--                 Added serial_no parameter to Get_Reserved_Remain_Qty and Check_Move_To_
--  060517  MiErlk Enlarge Identity - Changed view comment
--  060516  SaRalk Enlarge Address - Changed variable definitions.
--  060419  KeFelk Enlarge Customer - Changed variable definitions.
--  060418  NaLrlk Enlarge Identity - Changed view comments of deliver_to_customer_no.
--  ------------------------- 13.4.0 -----------------------------------------------
--  060323  RaKalk Added new procedure Check_Move_To_Pallet
--  060316  RaKalk Added multi_lot_batch_per_pallet_ parameter to Any_Previous_Pallet_For___ function
--  060316         Modified Collect_Packages_To_Pallets___ to fetch the multi_lot_batch_per_pallet_ value
--  060316         from customer address information and pass it to the Any_Previous_Pallet_For___ function.
--  060315  RaKalk Added record data type packing_qty_rec nad its plsql table.
--  060315         Modified method Find_Packing_Quantity___ to process all the rows in its cursor and output a plsql table
--  060315         Modified Collect_Parts___ to change the first parameter to IN OUT
--  060315         and avoid clearing the pack_info_ table within the function for pachage handling
--  060315         Modified the first parameter of Collect_Parts_Into_Packages___ to IN OUT
--  060315         Modified Create_Packages_On_Shipment___ and Create_Pallets_On_Shipment___ to handle
--  060315         Moutiple lot/batch order lines.
--  060228  IsAnlk Modified View SHIPMENT_ORDER_LINE_OVW to show qty_reserved correctly for PKG parts.
--  060222  MaHplk Modified View SHIPMENT_ORDER_LINE_OVW ( 'WHERE sol.line_item_no <= 0' ).
--  051011  JaBalk Get the consignee_reference from cust_order_customer_address_tab in Create_Shipment___.
--  050928  JaBalk Used the parameter ship_address_no_ in Create_Shipment___ when creating shipment.
--  050920  MaEelk Removed unused variables from the code.
--  050525  JaJalk Added CUSTOMER_PO_REL_NO and CUSTOMER_PO_LINE_NO to the view VIEW_SHIPMENT and VIEW_OVW.
--  050419  NuFilk Modified the cursor delivered_lines in method No_Delivered_Lines to
--  050419         enable reopen for partialy delivered lines connected to the shipment included cursor delivered_on_shipment.
--  050331  NuFilk Modified view VIEW_SHIPMENT set deliver_to_customer_no the value from customer order line.
--  050308  NuFilk Modified method Any_Packing_Qty_Deviation___, to handle non-inventory service parts correctly.
--  050216  IsAnlk Modified SHIPMENT_CONNECTED as VARCHAR2 and changed the code accordingly.
--  050131  NuFilk Modified method Any_Packing_Qty_Deviation___, to consider non-inventory parts also.
--  050128  UsRalk Modified cursor unpicked_lines at All_Lines_Picked to exclude non-inventory parts.
--  050126  NuFilk Modified method Any_Shipment_Qty_Deviation, Renamed the method Any_Order_Line_Qty_Deviation and
--  050126         the overloaded version of it to implementation methods Any_Packing_Qty_Deviation___.
--  050121  UsRalk Added new method Get_No_Of_Packages_To_Ship___.
--  050119  SaJjlk Modified method All_Lines_Delivered.
--  050118  JaBalk Added new procedure Add_Order_Line_To_Shipment to call when inserting CO lines to released order.
--  050118  UsRalk Renamed CustomerNo attribute on Shipment LU to DeliverToCustomerNo.
--  050118  JaBalk Added Create_New_Shipment___, Add_To_Existing_Shipment___, Find_Shipment___ with extra parameter.
--  050118  NuFilk Modified method Remove_Reserved_Line to give a error message if the pick list is already created for the line.
--  050117  SaJjlk Added conditions in methods Create_Packages_On_Shipment___ and Create_Pallets_On_Shipment___.
--  050113  GeKalk Modified the SHIPMENT_ORDER_LINE_OVW.
--  050111  JaBalk Added a condition to exclude the Non Inventory Service Part in Raise_Error_On_Basic_Data___
--  050111         while generating package structure .
--  050107  JaBalk Replace the views to tables in all cursors.
--  050105  JaBalk Changed the order of the parameter of Any_Previous_Pallet_For___.
--  050105         Restructure the method Generate_Package_Structure by adding methods
--  050105         Generate_Package_Structure___, Find_Packing_Quantity___, Collect_Parts___, Collect_Parts___,
--  050105         Collect_Parts_Into_Packages___, Create_Packages_On_Shipment___, Collect_Parts_Into_Pallets___,
--  050105         Create_Pallets_On_Shipment___, Collect_Packages_To_Pallets___, Remove_Empty_Packages___, Raise_Error_On_Basic_Data___.
--  050105  JaBalk Modified VIEW_SHIPMENT to exclude the package parts if its components parts
--  050105         having PD/IPD/ND supply codes and removed Create_Pick_List_API.Create_Pick_List_For_Line.
--  050105  UsRalk Modified cursor connected_lines at Generate_Package_Structure to exclude package parts.
--  050104  JaBalk Modified Create_Automatic_Shipments and removed order consignment creation from VIEW_SHIPMENT
--  050104  JaBalk Added new procedure Create_Automatic_Shipments,Create_Or_Connect_Shipment___,
--  050104         Create_Shipment___, Find_Shipment___.
--  041231  UsRalk Modified view CUSTOMER_ORDER_LINE_SHIPMENT to include Package Parts.
--  041124  YoMiJp Modified the PROCEDURE Generate_Package_Structure Added 2 Error Messages.
--  041112  YoMiJp Modified the PROCEDURE Generate_Package_Structure to avoid the Permanent Loop caused by the blank Proposed Parcel Quantity
--  040906  Samnlk Added project_id and activity_seq to vew SHIPMENT_ORDER_LINE_OVW and CUSTOMER_ORDER_LINE_SHIPMENT.
--  040817  dhwilk Inserted General_SYS.Method to Is_Simplified
--  040712  NuFilk Removed the join in the View, Modified function Find_Pallet_Type___.
--  040227  JoEd   Added column customer_part_no and ref_id to CUSTOMER_ORDER_LINE_SHIPMENT.
--                 Added code to look for already created pick lists if pick list couldn't be
--                 created in method Remove_Reserved_Line.
--                 Included removal of packages with zero quantity in Generate_Package_Structure.
--  040226  IsWilk Removed the SUBSTRB from the view for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes-----------------------
--  040204  JoEd   Reduced the number of function calls in the views.
--  040121  JoEd   Removed Check_Delivery_Terms__ and Check_Ship_Via_Code__. Added NOCHECK flags
--                 to the VIEW_SHIPMENT columns comments instead.
--  ------------------------------ 13.3.0-------------------------------------
--  021112  PrInLk Undone some changes made on All_Lines_Delivered__.
--  021108  PrInLk Discarded previous modification on view comment on reference_sys. Added two private
--                 methods Check_Delivery_Terms__,Check_Ship_Via_Code__.
--  021107  GeKaLk Modified CUSTOMER_ORDER_LINE_SHIPMENT View to remove CUSTOM values. .
--  021105  PrInLk Modified the method Remove_Reserved_Line.Picked 0 qty for all reservations at one call.
--                 Modify the method Generate_Package_Structure to support Partially Delivered Lines.
--  021104  PrInLk Added version 2 of the method Get_Remain_Parcel_Qty.The definition for shipment_connectable_line changed considerably.
--  021030  PrInLk Modified method Remove_Picked_Line to handle pallet handled parts.
--  021029  PrInLk Removed suffixed underscores from cursor names. Modified the method
--                 Remove_Picked_Lines to allocate more space to attr_ variable.
--  021025  PrInLk Modified method Get_Total_Volume. Shipment_Package_Unit info accessed directly from table.
--  021024  GeKaLk Added SHIPMENT_ORDER_LINE_OVW view to this from ShipmentOrderLine LU.
--  021024  PrInLk Added methods All_Lines_Delivered,All_Lines_Picked,No_Delivered_Lines to support Shipment state diagram.
--  021023  PrInLk Moved CUSTOMER_ORDER_LINE_SHIPMENT into this LU from CustomerOrderLine LU.
--                      Removed unnecessary columns. Added methods Remove_Picked_Line,Remove_Reserved_Line,Get_Reserved_Remain_Qty.
--  021022  PrInLk Added an overloaded version of the method Any_Order_Line_Qty_Deviation to handle Partially Delivered lines.
--  021014  PrInLk Change the references in doc_code,sub_code,gate,reference_id in Shipment_Handling_Utility view
--                 to refere directly from customer order line.
--  020619  MaGu   Modified mehtod Structure_Exist___. Changed cursor shipment_structure to avoid error when tables in
--                 select statement are empty.
--  020607  MaGu   Added methods Get_No_Of_Pallets and Get_No_Of_Packages.
--                 Added methods Get_Remain_Parcel_Qty. Replaced all calls to Shipment_Order_Line_API.Get_Remain_Parcel_Qty
--                 with calls to Shipment_Handling_Utility_API.Get_Remain_Parcel_Qty.
--  020606  MaGu   Removed use of %TYPE in declaration of TYPE pallet_list.
--                 Added method Get_Package_Net_Weight.
--  020604  MaGu   Added methods Get_Pallet_Lot_Batch and Get_Pallet_Ec.
--                 Made code more readable and removed use of %TYPE in methods Get_Next_Index___,
--                 Find_Pallet_Type___, Generate_Package_Structure
--  020508  PrInLk Added public methods Any_Order_Line_Qty_Deviation and Any_Shipment_Qty_Deviation to
--                 have a control between shipment order line quantities and package structure quantities.
--  020502  MaGu   Added call to General_SYS.Init_Method in methods Generate_Package_Structure,
--                 Create_Empty_Package, Create_Empty_Pallet, Remove_Packaged_Order, Get_Gross_Weigh,
--                 Get_Packages_On_Pallet, Get_Total_Volume and Get_Net_Summary.
--  020430  PrInLk Completed the method implementation for Get_Total_Volume.
--  020430  PrInLk Modify the implementation method Structure_Exist___ to locate the empty pallets.
--  020425  PrInLk Modify the method Generate_Package_Structure to handle different lot batch numbers and
--                 ec level for Reserved and Picked lines.(Addition to the modification on 020311 by Prinlk)
--  020419  PrInLk Added public method Shipment_Structure_Exist to check a package structure exists
--                 for a given shipment.
--  020417  ZiMolk Added ref_id to view SHIPMENT_HANDLING_UTILITY.
--  020322  ZiMolk Added method Get_Packages_On_Pallet.
--  020321  PrInLk Modify the view definition for shipment_connectable_lines to show remain quantities
--                 in each reserved locations for reserved lines.
--  020320  ZiMolk Renamed doc_code, sub_doc_code to dock_code, sub_dock_code.
--  020315  ZiMolk Added doc_code, sub_doc_code, gate to view SHIPMENT_HANDLING_UTILITY.
--  020312  PrInLk Added a new view named Shipment_Connectable_Line.
--  020311  PrInLk Modified the method named Generate_Package_Structure. The modification intended to generate
--                 the package structure according to ODETTE rules.
--  020224  PrInLk Added public method Get_Net_Summary to obtain summary of the shipment using one method.
--  020223  PrInLk Added public method Get_Net_Weight to obtain the net weight of the shipment.
--  020221  PrInLk Added public methods Any_Connected_Package, Remove_Packaged_Order,
--                 Remove_Palletized_Order.
--  020218  PrInLk Added method Create_Empty_Package and Create_Empty_Pallet which creates
--                 arbitrary number of package units and handling units respectively.
--  020214  PrInLk Added private method Modify__ which calles the correponding lu method to
--                 perform modification on this utility lu.
--  020212  PrInLk Added implementation method Find_Pallet_Type___ to find the pallet type
--                 of the given pallet. Added public method Label_Pallet_Type to label
--                 the pallet with the type.Added implementation method Label_Pallet_Sets___
--                 to label the pallet type in a set of handling units.
--  020211  PrInLk Renamed the method Is_Homogeneous to Is_Simplified.
--  020208  PrInLk Added public method Is_Homogeneous to check a pallet is homogeneous
--                 pallet or not.
--  020207  PrInLk Added public method Remove_Handling_Unit to remove Handling Units
--                 from the system. This will check whether it is a HandlingUnitPackage
--                 or HandlingUnitPart.
--  020206  PrInLk Added implementation methods Discard_Structure(Removes the
--                 complete structure)and Structure_Exist(Checks a structure exist
--                 for a shipment).Included these methods into the public method
--                 Generate_Package_Structure.
--  020201  PrInLk Added public method Generate_Package_Structure for
--                 automatic genetation of shipment structure. Added two
--                 implementation methods named Get_Next_Index___ and
--                 Any_Previous_Pallet_For___ to support the public method
--  020128  PrInLk Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Handling_Unit_Id_Tab IS TABLE OF NUMBER
   INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------
   
string_null_         CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Any_Packing_Qty_Deviation___
--   This will return 'TRUE' if there are any difference in picked qty in order
--   line and created package structure qty. Return 'FALSE' if there are no
FUNCTION Any_Packing_Qty_Deviation___ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   shipment_id_        IN NUMBER ) RETURN VARCHAR2
IS
   qty_deviation_       NUMBER;
   qty_deviation_exist_ VARCHAR2(5) := 'FALSE';
BEGIN
   qty_deviation_ := Get_Packing_Qty_Deviation(source_ref1_,
                                               source_ref2_,
                                               source_ref3_,
                                               source_ref4_,
                                               source_ref_type_db_,
                                               shipment_id_);
   IF (qty_deviation_ != 0) THEN
      qty_deviation_exist_ := 'TRUE';
   END IF;

   RETURN qty_deviation_exist_;   
END Any_Packing_Qty_Deviation___;


PROCEDURE Create_Or_Connect_Shipment___ (
   shipment_id_            IN OUT NUMBER,
   source_ref1_            IN     VARCHAR2,
   source_ref2_            IN     VARCHAR2,
   source_ref3_            IN     VARCHAR2,
   source_ref4_            IN     VARCHAR2,
   source_ref_type_db_     IN     VARCHAR2,
   receiver_id_            IN     VARCHAR2,
   receiver_type_db_       IN     VARCHAR2,
   sender_id_              IN     VARCHAR2,
   sender_type_db_         IN     VARCHAR2,
   sender_addr_id_         IN     VARCHAR2,
   receiver_addr_id_       IN     VARCHAR2,
   ship_via_code_          IN     VARCHAR2,
   contract_               IN     VARCHAR2,
   delivery_terms_         IN     VARCHAR2,
   del_terms_location_     IN     VARCHAR2,
   forward_agent_id_       IN     VARCHAR2,
   use_price_incl_tax_     IN     VARCHAR2,
   shipment_type_          IN     VARCHAR2 )
IS
   new_shipment_id_       NUMBER;
   added_to_new_shipment_ VARCHAR2(5):= 'FALSE';
BEGIN
   new_shipment_id_ := shipment_id_;
   IF (new_shipment_id_ IS NULL) THEN
      Create_Shipment__(new_shipment_id_ ,
                        source_ref1_,
                        source_ref2_,
                        source_ref3_,
                        source_ref4_,
                        source_ref_type_db_,
                        receiver_id_,
                        receiver_type_db_,
                        sender_id_,
                        sender_type_db_,
                        sender_addr_id_,
                        receiver_addr_id_,
                        ship_via_code_,
                        contract_,
                        delivery_terms_,
                        del_terms_location_,
                        forward_agent_id_,
                        use_price_incl_tax_,
                        shipment_type_,
                        NULL);
      added_to_new_shipment_ := 'TRUE';                 
   END IF;

   Shipment_Line_API.Connect_To_Shipment(new_shipment_id_,
                                         source_ref1_,
                                         source_ref2_,
                                         source_ref3_,
                                         source_ref4_,
                                         source_ref_type_db_,
                                         added_to_new_shipment_ );
   
   shipment_id_ := new_shipment_id_;      
END Create_Or_Connect_Shipment___;


-- Create_Shipment___
--   Create new shipment.
PROCEDURE Create_Shipment__ (
   shipment_id_            OUT NUMBER,
   source_ref1_            IN  VARCHAR2,
   source_ref2_            IN  VARCHAR2,
   source_ref3_            IN  VARCHAR2,
   source_ref4_            IN  VARCHAR2,
   source_ref_type_db_     IN  VARCHAR2,
   receiver_id_            IN  VARCHAR2,
   receiver_type_db_       IN  VARCHAR2,
   sender_id_              IN  VARCHAR2,
   sender_type_db_         IN  VARCHAR2,
   sender_addr_id_         IN  VARCHAR2,
   receiver_addr_id_       IN  VARCHAR2,
   ship_via_code_          IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   delivery_terms_         IN  VARCHAR2,
   del_terms_location_     IN  VARCHAR2,
   forward_agent_id_       IN  VARCHAR2,
   use_price_incl_tax_     IN  VARCHAR2,
   shipment_type_          IN  VARCHAR2,
   from_shipment_id_       IN  NUMBER )
IS
   attr_                        VARCHAR2(32000);
   info_                        VARCHAR2(2000);   
BEGIN
   attr_ := Build_Attr_Create_Shipment___(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, receiver_id_, receiver_type_db_, sender_id_, sender_type_db_, sender_addr_id_, receiver_addr_id_, 
                                          ship_via_code_, contract_, delivery_terms_, del_terms_location_, use_price_incl_tax_, shipment_type_, from_shipment_id_);  
   Shipment_API.New(info_, attr_);
   shipment_id_ := Client_SYS.Get_Item_Value('SHIPMENT_ID', attr_);
   Shipment_Source_Utility_API.Post_Create_Auto_Ship(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_,
                                                     from_shipment_id_, receiver_id_, use_price_incl_tax_, ship_via_code_, contract_, forward_agent_id_);
END Create_Shipment__;


-- Find_Existing_Shipment___
--   This method calls Find_Shipment___ to find a matching shipment.
PROCEDURE Find_Existing_Shipment___ (
   shipment_id_            OUT NUMBER,
   source_ref1_            IN  VARCHAR2,
   source_ref2_            IN  VARCHAR2,
   source_ref3_            IN  VARCHAR2,
   source_ref4_            IN  VARCHAR2,
   source_ref_type_db_     IN  VARCHAR2,
   receiver_id_            IN  VARCHAR2,
   receiver_type_db_       IN  VARCHAR2,
   sender_id_              IN  VARCHAR2,
   sender_type_db_         IN  VARCHAR2,
   receiver_addr_id_       IN  VARCHAR2,
   sender_addr_id_         IN  VARCHAR2,
   ship_via_code_          IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   delivery_terms_         IN  VARCHAR2,
   shipment_id_tab_        IN  Shipment_API.Shipment_Id_Tab,
   use_price_incl_tax_     IN  VARCHAR2,
   shipment_type_          IN  VARCHAR2 )
IS
BEGIN
   IF (shipment_id_tab_.COUNT > 0) THEN
      -- Searching matching shipment based on delivery information in the given shipment_id_tab
      FOR i_ IN shipment_id_tab_.FIRST..shipment_id_tab_.LAST LOOP
         Find_Shipment___(shipment_id_,
                          source_ref1_,
                          source_ref2_,
                          source_ref3_,
                          source_ref4_,
                          source_ref_type_db_,
                          receiver_id_,
                          receiver_type_db_,
                          sender_id_,
                          sender_type_db_,
                          receiver_addr_id_,
                          sender_addr_id_,
                          ship_via_code_,
                          contract_,
                          delivery_terms_,
                          shipment_id_tab_(i_),
                          use_price_incl_tax_,
                          shipment_type_ );
   
          -- Matching shipment id is found
         IF shipment_id_ IS NOT NULL  THEN
            EXIT;
         END IF;
      END LOOP;
   ELSE
      -- Searching matching shipment based on delivery information
      Find_Shipment___(shipment_id_,
                       source_ref1_,
                       source_ref2_,
                       source_ref3_,
                       source_ref4_,
                       source_ref_type_db_,
                       receiver_id_,
                       receiver_type_db_,
                       sender_id_,
                       sender_type_db_,
                       receiver_addr_id_,
                       sender_addr_id_,
                       ship_via_code_,
                       contract_,
                       delivery_terms_,
                       NULL,
                       use_price_incl_tax_,
                       shipment_type_ );
   END IF;
END Find_Existing_Shipment___;

-- Find_Shipment___
--   Search any existing shipment for a particular order in status preliminary with the matching
--   deliver-to-customer, address, ship via, contract, delivery terms and address info and consolidation params.
PROCEDURE Find_Shipment___ (
   shipment_id_            OUT NUMBER,
   source_ref1_            IN  VARCHAR2,
   source_ref2_            IN  VARCHAR2,
   source_ref3_            IN  VARCHAR2,
   source_ref4_            IN  VARCHAR2, 
   source_ref_type_db_     IN  VARCHAR2,
   receiver_id_            IN  VARCHAR2,
   receiver_type_db_       IN  VARCHAR2,
   sender_id_              IN  VARCHAR2,
   sender_type_db_         IN  VARCHAR2,
   receiver_addr_id_       IN  VARCHAR2,
   sender_addr_id_         IN  VARCHAR2,
   ship_via_code_          IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   delivery_terms_         IN  VARCHAR2,
   existing_shipment_id_   IN  VARCHAR2,
   use_price_incl_tax_     IN  VARCHAR2,
   shipment_type_          IN  VARCHAR2 )
IS
   consol_rule_co_        NUMBER := 0;
   consol_rule_ship_date_ NUMBER := 0;
   consol_rule_del_date_  NUMBER := 0;
   consol_rule_dock_      NUMBER := 0;
   consol_rule_subdock_   NUMBER := 0;
   consol_rule_route_     NUMBER := 0;
   consol_rule_ref_       NUMBER := 0;
   consol_rule_location_  NUMBER := 0;
   consol_rule_forwarder_ NUMBER := 0;
   public_rec_            Shipment_Source_Utility_API.Public_Rec;
   public_line_rec_       Shipment_Source_Utility_API.Public_Line_Rec;
   sender_address1_         VARCHAR2(35);         
   sender_address2_         VARCHAR2(35);        
   sender_address3_         VARCHAR2(100);        
   sender_address4_         VARCHAR2(100);        
   sender_address5_         VARCHAR2(100);        
   sender_address6_         VARCHAR2(100);        
   sender_city_             VARCHAR2(35);        
   sender_state_            VARCHAR2(35);        
   sender_zip_code_         VARCHAR2(35);    
   sender_county_           VARCHAR2(35);      
   sender_country_          VARCHAR2(2);
   sender_name_             VARCHAR2(100);
   sender_reference_        VARCHAR2(100);
   sender_country_desc_     VARCHAR2(2000);
   public_addr_line_rec_  Shipment_Source_Utility_API.Public_Addr_Line_Rec;
   shipment_record_       Shipment_API.Public_Rec;
   $IF (Component_Order_SYS.INSTALLED) $THEN
      shipment_freight_rec_   Shipment_Freight_API.Public_Rec;
   $END
   CURSOR get_consol_rule IS
      SELECT consol_param
      FROM   shipment_consol_rule_tab
      WHERE  shipment_type = shipment_type_;  
   
   CURSOR get_shipment_id IS   
      SELECT shipment_id 
      FROM  shipment_tab    
      WHERE shipment_type                  =  shipment_type_
      AND   receiver_id                    =  receiver_id_
      AND   receiver_type                  =  receiver_type_db_
      AND   sender_id                      =  sender_id_
      AND   sender_type                    =  sender_type_db_
      AND   (source_ref_type                = '^' || source_ref_type_db_ || '^' OR source_ref_type IS NULL) -- TODO_LIME: This to avoid mix scenario between CO and PD, this should be removed when mix scenario is allowed.
      AND   NVL(sender_name,           Database_SYS.string_null_) = NVL(sender_name_,         Database_SYS.string_null_)
      AND   NVL(sender_address1,       Database_SYS.string_null_) = NVL(sender_address1_,     Database_SYS.string_null_)
      AND   NVL(sender_address2,       Database_SYS.string_null_) = NVL(sender_address2_,     Database_SYS.string_null_)
      AND   NVL(sender_address3,       Database_SYS.string_null_) = NVL(sender_address3_,     Database_SYS.string_null_)
      AND   NVL(sender_address4,       Database_SYS.string_null_) = NVL(sender_address4_,     Database_SYS.string_null_)
      AND   NVL(sender_address5,       Database_SYS.string_null_) = NVL(sender_address5_,     Database_SYS.string_null_)
      AND   NVL(sender_address6,       Database_SYS.string_null_) = NVL(sender_address6_,     Database_SYS.string_null_)
      AND   NVL(sender_city ,          Database_SYS.string_null_) = NVL(sender_city_,         Database_SYS.string_null_)
      AND   NVL(sender_state,          Database_SYS.string_null_) = NVL(sender_state_,        Database_SYS.string_null_)
      AND   NVL(sender_zip_code,       Database_SYS.string_null_) = NVL(sender_zip_code_,     Database_SYS.string_null_)
      AND   NVL(sender_county,         Database_SYS.string_null_) = NVL(sender_county_,       Database_SYS.string_null_)
      AND   NVL(sender_country,        Database_SYS.string_null_) = NVL(sender_country_,      Database_SYS.string_null_)
      AND   NVL(receiver_address_name, Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address_name, Database_SYS.string_null_)
      AND   NVL(receiver_address1,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address1,     Database_SYS.string_null_)
      AND   NVL(receiver_address2,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address2,     Database_SYS.string_null_)
      AND   NVL(receiver_address3,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address3,     Database_SYS.string_null_)
      AND   NVL(receiver_address4,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address4,     Database_SYS.string_null_)
      AND   NVL(receiver_address5,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address5,     Database_SYS.string_null_)
      AND   NVL(receiver_address6,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address6,     Database_SYS.string_null_)
      AND   NVL(receiver_city ,        Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_city,         Database_SYS.string_null_)
      AND   NVL(receiver_state,        Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_state,        Database_SYS.string_null_)
      AND   NVL(receiver_zip_code,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_zip_code,     Database_SYS.string_null_)
      AND   NVL(receiver_county,       Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_county,       Database_SYS.string_null_)
      AND   NVL(receiver_country,      Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_country,      Database_SYS.string_null_)
      AND   NVL(ship_via_code,         Database_SYS.string_null_) = NVL(ship_via_code_,                              Database_SYS.string_null_)
      AND   contract                       =  contract_
      AND   NVL(delivery_terms,        Database_SYS.string_null_) = NVL(delivery_terms_,                             Database_SYS.string_null_)
      AND   rowstate                       = 'Preliminary'
      AND   auto_connection_blocked        = 'FALSE'
      AND   shipment_category = 'NORMAL'
      AND   ((public_line_rec_.addr_flag = 'Y' AND addr_flag = 'Y') OR (public_line_rec_.addr_flag = 'N' AND addr_flag = 'N' AND receiver_addr_id =  receiver_addr_id_))
      AND   NVL(customs_value_currency,      Database_SYS.string_null_) = NVL(public_rec_.customs_value_currency,      Database_SYS.string_null_)
      AND   (consol_rule_co_        = 0 OR source_ref1 = source_ref1_)
      AND   (consol_rule_ship_date_ = 0 OR TO_CHAR(planned_ship_date, Report_SYS.datetime_format_) = TO_CHAR(public_line_rec_.planned_ship_date, Report_SYS.datetime_format_))
      AND   (consol_rule_del_date_  = 0 OR TO_CHAR(planned_delivery_date, Report_SYS.datetime_format_) = TO_CHAR(public_line_rec_.planned_delivery_date, Report_SYS.datetime_format_))
      AND   (consol_rule_ref_       = 0 OR NVL(ref_id,            Database_SYS.string_null_) = NVL(public_line_rec_.ref_id,             Database_SYS.string_null_))
      AND   (consol_rule_forwarder_ = 0 OR NVL(forward_agent_id,  Database_SYS.string_null_) = NVL(public_line_rec_.forward_agent_id,   Database_SYS.string_null_))
      AND   (consol_rule_route_     = 0 OR NVL(route_id,          Database_SYS.string_null_) = NVL(public_line_rec_.route_id,           Database_SYS.string_null_))
      AND   (consol_rule_dock_      = 0 OR NVL(dock_code,         Database_SYS.string_null_) = NVL(public_line_rec_.dock_code,          Database_SYS.string_null_))
      AND   (consol_rule_subdock_   = 0 OR NVL(sub_dock_code,     Database_SYS.string_null_) = NVL(public_line_rec_.sub_dock_code,      Database_SYS.string_null_))
      AND   (consol_rule_location_  = 0 OR NVL(location_no,       Database_SYS.string_null_) = NVL(public_line_rec_.location_no,        Database_SYS.string_null_))
      ORDER BY shipment_id DESC;
BEGIN                                             
   IF((source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(source_ref4_) > 0)) THEN
      -- Since all component parts should belong to the same shipment, 
      -- it is sufficient to check the shipment parameters against package part line info.
      Shipment_Source_Utility_API.Fetch_Info(public_rec_, public_line_rec_, public_addr_line_rec_, source_ref1_, source_ref2_, source_ref3_, -1, source_ref_type_db_);
   ELSE
      Shipment_Source_Utility_API.Fetch_Info(public_rec_, public_line_rec_, public_addr_line_rec_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   END IF;
   
   Shipment_Source_Utility_API.Get_Sender_Addr_Info(sender_address1_, 
                                                    sender_address2_, 
                                                    sender_address3_, 
                                                    sender_address4_, 
                                                    sender_address5_, 
                                                    sender_address6_, 
                                                    sender_zip_code_,
                                                    sender_city_,
                                                    sender_state_,
                                                    sender_county_,
                                                    sender_country_,
                                                    sender_country_desc_,
                                                    sender_name_,
                                                    sender_reference_,
                                                    sender_id_, 
                                                    sender_addr_id_,                                                                             
                                                    sender_type_db_,
                                                    source_ref1_,
                                                    source_ref2_,
                                                    source_ref3_,
                                                    source_ref4_,
                                                    source_ref_type_db_); 
   
   FOR rule_ IN get_consol_rule LOOP
      CASE rule_.consol_param
         WHEN 'SOURCE REF 1' THEN
           consol_rule_co_ := 1;
         WHEN 'PLANNED SHIP DATE' THEN
            consol_rule_ship_date_ := 1;
         WHEN 'PLANNED DEL DATE' THEN
            consol_rule_del_date_ := 1;
         WHEN 'ROUTE' THEN
           consol_rule_route_ := 1;
         WHEN 'FORWARDER' THEN
            consol_rule_forwarder_ := 1;
         WHEN 'REFERENCE ID' THEN
            consol_rule_ref_ := 1;
         WHEN 'DOCK CODE' THEN
            consol_rule_dock_ := 1;
         WHEN 'SUB DOCK CODE' THEN
            consol_rule_subdock_ := 1;
         WHEN 'TO LOCATION' THEN
            consol_rule_location_ := 1;
      END CASE;
   END LOOP;

   shipment_id_ := NULL;

   IF (existing_shipment_id_ IS NOT NULL) THEN      
      shipment_record_ := Shipment_API.Get(existing_shipment_id_);
      IF (shipment_record_.shipment_id IS NOT NULL 
          AND shipment_record_.shipment_type          =  shipment_type_
          AND shipment_record_.receiver_id          =  receiver_id_
          AND shipment_record_.receiver_type        = receiver_type_db_
          AND shipment_record_.sender_id            = sender_id_
          AND shipment_record_.sender_type          = sender_type_db_
          AND (shipment_record_.source_ref_type     = '^' || source_ref_type_db_ || '^' OR shipment_record_.source_ref_type IS NULL) -- TODO_LIME: This to avoid mix scenario between CO and PD, this should be removed when mix scenario is allowed.
          AND NVL(shipment_record_.sender_name,           Database_SYS.string_null_) = NVL(sender_name_, Database_SYS.string_null_)
          AND NVL(shipment_record_.sender_address1,       Database_SYS.string_null_) = NVL(sender_address1_,     Database_SYS.string_null_)
          AND NVL(shipment_record_.sender_address2,       Database_SYS.string_null_) = NVL(sender_address2_,     Database_SYS.string_null_)
          AND NVL(shipment_record_.sender_address3,       Database_SYS.string_null_) = NVL(sender_address3_,     Database_SYS.string_null_)
          AND NVL(shipment_record_.sender_address4,       Database_SYS.string_null_) = NVL(sender_address4_,     Database_SYS.string_null_)
          AND NVL(shipment_record_.sender_address5,       Database_SYS.string_null_) = NVL(sender_address5_,     Database_SYS.string_null_)
          AND NVL(shipment_record_.sender_address6,       Database_SYS.string_null_) = NVL(sender_address6_,     Database_SYS.string_null_)
          AND NVL(shipment_record_.sender_city ,          Database_SYS.string_null_) = NVL(sender_city_,         Database_SYS.string_null_)
          AND NVL(shipment_record_.sender_state,          Database_SYS.string_null_) = NVL(sender_state_,        Database_SYS.string_null_)
          AND NVL(shipment_record_.sender_zip_code,       Database_SYS.string_null_) = NVL(sender_zip_code_,     Database_SYS.string_null_)
          AND NVL(shipment_record_.sender_county,         Database_SYS.string_null_) = NVL(sender_county_,       Database_SYS.string_null_)
          AND NVL(shipment_record_.sender_country,        Database_SYS.string_null_) = NVL(sender_country_,      Database_SYS.string_null_)
          AND NVL(shipment_record_.receiver_address_name, Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address_name, Database_SYS.string_null_)
          AND NVL(shipment_record_.receiver_address1,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address1,     Database_SYS.string_null_)
          AND NVL(shipment_record_.receiver_address2,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address2,     Database_SYS.string_null_)
          AND NVL(shipment_record_.receiver_address3,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address3,     Database_SYS.string_null_)
          AND NVL(shipment_record_.receiver_address4,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address4,     Database_SYS.string_null_)
          AND NVL(shipment_record_.receiver_address5,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address5,     Database_SYS.string_null_)
          AND NVL(shipment_record_.receiver_address6,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_address6,     Database_SYS.string_null_)
          AND NVL(shipment_record_.receiver_city ,        Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_city,         Database_SYS.string_null_)
          AND NVL(shipment_record_.receiver_state,        Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_state,        Database_SYS.string_null_)
          AND NVL(shipment_record_.receiver_zip_code,     Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_zip_code,     Database_SYS.string_null_)
          AND NVL(shipment_record_.receiver_county,       Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_county,       Database_SYS.string_null_)
          AND NVL(shipment_record_.receiver_country,      Database_SYS.string_null_) = NVL(public_addr_line_rec_.receiver_country,      Database_SYS.string_null_)
          AND NVL(shipment_record_.ship_via_code,         Database_SYS.string_null_) = NVL(ship_via_code_,                              Database_SYS.string_null_)
          AND shipment_record_.contract                       =  contract_
          AND NVL(shipment_record_.delivery_terms,        Database_SYS.string_null_) = NVL(delivery_terms_,                             Database_SYS.string_null_)
          AND shipment_record_.rowstate                       = 'Preliminary'
          AND shipment_record_.auto_connection_blocked        = 'FALSE'
          AND shipment_record_.shipment_category = 'NORMAL'
          AND ((public_line_rec_.addr_flag = 'Y' AND shipment_record_.addr_flag = 'Y') OR (public_line_rec_.addr_flag = 'N' AND shipment_record_.addr_flag = 'N' AND shipment_record_.receiver_addr_id =  receiver_addr_id_))
          AND NVL(shipment_record_.customs_value_currency,      Database_SYS.string_null_) = NVL(public_rec_.customs_value_currency,      Database_SYS.string_null_)
          AND (consol_rule_co_        = 0 OR shipment_record_.source_ref1 = source_ref1_)
          AND (consol_rule_ship_date_ = 0 OR TO_CHAR(shipment_record_.planned_ship_date, Report_SYS.datetime_format_) = TO_CHAR(public_line_rec_.planned_ship_date, Report_SYS.datetime_format_))
          AND (consol_rule_del_date_  = 0 OR TO_CHAR(shipment_record_.planned_delivery_date, Report_SYS.datetime_format_) = TO_CHAR(public_line_rec_.planned_delivery_date, Report_SYS.datetime_format_))
          AND (consol_rule_ref_       = 0 OR NVL(shipment_record_.ref_id,            Database_SYS.string_null_) = NVL(public_line_rec_.ref_id,             Database_SYS.string_null_))
          AND (consol_rule_forwarder_ = 0 OR NVL(shipment_record_.forward_agent_id,  Database_SYS.string_null_) = NVL(public_line_rec_.forward_agent_id,   Database_SYS.string_null_))
          AND (consol_rule_route_     = 0 OR NVL(shipment_record_.route_id,          Database_SYS.string_null_) = NVL(public_line_rec_.route_id,           Database_SYS.string_null_))
          AND (consol_rule_dock_      = 0 OR NVL(shipment_record_.dock_code,         Database_SYS.string_null_) = NVL(public_line_rec_.dock_code,          Database_SYS.string_null_))
          AND (consol_rule_subdock_   = 0 OR NVL(shipment_record_.sub_dock_code,     Database_SYS.string_null_) = NVL(public_line_rec_.sub_dock_code,      Database_SYS.string_null_))
          AND (consol_rule_location_  = 0 OR NVL(shipment_record_.location_no,       Database_SYS.string_null_) = NVL(public_line_rec_.location_no,        Database_SYS.string_null_))) THEN
   
         shipment_id_ := shipment_record_.shipment_id;
      END IF;
   END IF;
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN      
      $IF (Component_Order_SYS.INSTALLED) $THEN
         IF ( existing_shipment_id_ IS NOT NULL ) THEN
            IF (shipment_id_ IS NOT NULL) THEN
               shipment_freight_rec_ := Shipment_Freight_API.Get(shipment_id_);
               IF ((NVL(shipment_freight_rec_.supply_country, Database_SYS.string_null_) != Shipment_Source_Utility_API.Get_Source_Supply_Country_Db(source_ref1_, contract_, source_ref_type_db_)) OR
                   (NVL(shipment_freight_rec_.use_price_incl_tax, Database_SYS.string_null_) != use_price_incl_tax_)) THEN
                     shipment_id_ := NULL;
               END IF;
            END IF;
         ELSE
            FOR shipment_rec_ IN get_shipment_id LOOP
               shipment_freight_rec_ := Shipment_Freight_API.Get(shipment_rec_.shipment_id);
               IF ((NVL(shipment_freight_rec_.supply_country, Database_SYS.string_null_) = Shipment_Source_Utility_API.Get_Source_Supply_Country_Db(source_ref1_, contract_, source_ref_type_db_)) AND
                   (NVL(shipment_freight_rec_.use_price_incl_tax, Database_SYS.string_null_) = use_price_incl_tax_)) THEN
                  shipment_id_ := shipment_rec_.shipment_id;
                  EXIT;
               END IF;
            END LOOP;                     
         END IF;
         
      $ELSE
         NULL;
      $END       
   ELSE
      IF ( existing_shipment_id_ IS NULL ) THEN
         OPEN get_shipment_id;
         FETCH get_shipment_id INTO shipment_id_;
         CLOSE get_shipment_id;
      END IF;
   END IF;
   
END Find_Shipment___;


-- Build_Attr_Create_Shipment___ 
-- This method is used to build the attr_ which is used in method New_Exchange_Invoice_Item___.
FUNCTION Build_Attr_Create_Shipment___ (
   source_ref1_            IN  VARCHAR2,
   source_ref2_            IN  VARCHAR2,
   source_ref3_            IN  VARCHAR2,
   source_ref4_            IN  VARCHAR2,
   source_ref_type_db_     IN  VARCHAR2,
   receiver_id_            IN  VARCHAR2,
   receiver_type_db_       IN  VARCHAR2,
   sender_id_              IN  VARCHAR2,
   sender_type_db_         IN  VARCHAR2,
   sender_addr_id_         IN  VARCHAR2,
   receiver_addr_id_       IN  VARCHAR2,
   ship_via_code_          IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   delivery_terms_         IN  VARCHAR2,
   del_terms_location_     IN  VARCHAR2,   
   use_price_incl_tax_     IN  VARCHAR2,
   shipment_type_          IN  VARCHAR2,
   from_shipment_id_       IN  NUMBER ) RETURN VARCHAR2
IS
   attr_                        VARCHAR2(32000);
   language_code_               VARCHAR2(3);
   addr_attr_                   VARCHAR2(32000);  
   receiver_ref_                VARCHAR2(100);
   source_line_rec_             Shipment_Source_Utility_API.Public_Line_Rec;
   source_line_addr_rec_        Shipment_Source_Utility_API.Public_Addr_Line_Rec;    
   source_rec_                  Shipment_Source_Utility_API.Public_Rec;
   addr_flag_                   Shipment_Tab.addr_flag%TYPE;
   receiver_address_name_       Shipment_Tab.receiver_address_name%TYPE;
   receiver_address1_           Shipment_Tab.receiver_address1%TYPE;
   receiver_address2_           Shipment_Tab.receiver_address2%TYPE;
   receiver_address3_           Shipment_Tab.receiver_address3%TYPE;
   receiver_address4_           Shipment_Tab.receiver_address4%TYPE;
   receiver_address5_           Shipment_Tab.receiver_address5%TYPE;
   receiver_address6_           Shipment_Tab.receiver_address6%TYPE;
   receiver_city_               Shipment_Tab.receiver_city%TYPE;
   receiver_state_              Shipment_Tab.receiver_state%TYPE;
   receiver_zip_code_           Shipment_Tab.receiver_zip_code%TYPE;
   receiver_county_             Shipment_Tab.receiver_county%TYPE;
   receiver_country_            Shipment_Tab.receiver_country%TYPE;
   from_shipment_rec_           Shipment_API.Public_Rec;
   approve_before_delivery_     VARCHAR2(5);
   consol_location_no_          Shipment_Tab.location_no%TYPE;  
   consol_sub_dock_code_        Shipment_Tab.sub_dock_code%TYPE; 
   consol_dock_code_            Shipment_Tab.dock_code%TYPE; 
   consol_ref_id_               Shipment_Tab.ref_id%TYPE; 
   ship_source_ref1_            Shipment_Tab.source_ref1%TYPE; 
   consol_planned_ship_date_    Shipment_Tab.planned_ship_date%TYPE;
   consol_planned_del_date_     Shipment_Tab.planned_delivery_date%TYPE;
   consol_route_id_             Shipment_Tab.route_id%TYPE; 
   consol_forward_agent_id_     Shipment_Tab.forward_agent_id%TYPE; 
   customs_value_currency_      Shipment_Tab.customs_value_currency%TYPE;
   ship_inventory_location_no_  Shipment_Tab.ship_inventory_location_no%TYPE; 
   freight_payer_db_            Shipment_Tab.shipment_freight_payer%TYPE :=  NULL;  
   freight_payer_id_            Shipment_Tab.shipment_freight_payer_id%TYPE;
   
   CURSOR get_consol_rule IS
      SELECT consol_param
      FROM shipment_consol_rule_tab
      WHERE shipment_type = shipment_type_;
BEGIN   
   -- source_ref1_ is null when called from Reassignment of handling units   
   IF (source_ref1_ IS NOT NULL) THEN
      Shipment_Source_Utility_API.Fetch_Info(source_rec_, source_line_rec_, source_line_addr_rec_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);      
      IF (NVL(Company_Site_API.Get_Country_Db(contract_), Database_SYS.string_null_) != NVL(Shipment_Source_Utility_API.Get_Source_Supply_Country_Db(source_ref1_, contract_, source_ref_type_db_), Database_SYS.string_null_)) THEN
         Error_SYS.Record_General(lu_name_, 'SUPPCOUNTRYMISMATCH: Supply country of the shipment source does not match with the site country. '||
                                            'Shipment is not created for this source.');                                   
      END IF;
   END IF;

   language_code_ := Shipment_Source_Utility_API.Get_Language_Code(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_,
                                                                   receiver_id_, receiver_type_db_, source_rec_.language_code);
    
   IF (from_shipment_id_ IS NULL) THEN        
      addr_flag_             := source_line_rec_.addr_flag;                
      receiver_address_name_ := source_line_addr_rec_.receiver_address_name;         
      receiver_address1_     := source_line_addr_rec_.receiver_address1;
      receiver_address2_     := source_line_addr_rec_.receiver_address2;
      receiver_address3_     := source_line_addr_rec_.receiver_address3;
      receiver_address4_     := source_line_addr_rec_.receiver_address4;
      receiver_address5_     := source_line_addr_rec_.receiver_address5;
      receiver_address6_     := source_line_addr_rec_.receiver_address6;
      receiver_city_         := source_line_addr_rec_.receiver_city;
      receiver_state_        := source_line_addr_rec_.receiver_state;
      receiver_zip_code_     := source_line_addr_rec_.receiver_zip_code;
      receiver_county_       := source_line_addr_rec_.receiver_county;
      receiver_country_      := source_line_addr_rec_.receiver_country;
      IF (source_line_rec_.demand_code IN ('IPT', 'IPT_RO')) THEN
         receiver_ref_          := source_rec_.internal_ref;   
      ELSE
         receiver_ref_          := source_rec_.cust_ref;
      END IF;
      customs_value_currency_ := source_rec_.customs_value_currency;
      
      FOR rule_ IN get_consol_rule LOOP
         CASE rule_.consol_param
            WHEN 'SOURCE REF 1' THEN 
               ship_source_ref1_          := source_ref1_;
            WHEN 'PLANNED SHIP DATE' THEN 
               consol_planned_ship_date_  := source_line_rec_.planned_ship_date;
            WHEN 'PLANNED DEL DATE' THEN 
               consol_planned_del_date_   := source_line_rec_.planned_delivery_date;
            WHEN 'ROUTE' THEN
               consol_route_id_           := source_line_rec_.route_id;
            WHEN 'REFERENCE ID' THEN
               consol_ref_id_             := source_line_rec_.ref_id;   
            WHEN 'DOCK CODE' THEN
               consol_dock_code_          := source_line_rec_.dock_code;     
            WHEN 'SUB DOCK CODE' THEN
               consol_sub_dock_code_      := source_line_rec_.sub_dock_code;  
            WHEN 'TO LOCATION' THEN
               consol_location_no_        := source_line_rec_.location_no;
            WHEN 'FORWARDER' THEN
               consol_forward_agent_id_   := source_line_rec_.forward_agent_id;
            ELSE
               NULL;
          END CASE;
       END LOOP;
       -- Fetching Freight Payer and Payer ID to the shipment
       Shipment_API.Fetch_Freight_Payer_Info(freight_payer_id_,
                                             freight_payer_db_,
                                             contract_,
                                             delivery_terms_,
                                             consol_forward_agent_id_,
                                             receiver_type_db_,
                                             receiver_id_,
                                             receiver_addr_id_);                                         
   ELSE
      -- New shipment is created via Reassignment flows, from_shipment_id_ has a value.    
      from_shipment_rec_          := Shipment_API.Get(from_shipment_id_);
      addr_flag_                  := from_shipment_rec_.addr_flag;                
      receiver_address_name_      := from_shipment_rec_.receiver_address_name;         
      receiver_address1_          := from_shipment_rec_.receiver_address1;
      receiver_address2_          := from_shipment_rec_.receiver_address2;
      receiver_address3_          := from_shipment_rec_.receiver_address3;
      receiver_address4_          := from_shipment_rec_.receiver_address4;
      receiver_address5_          := from_shipment_rec_.receiver_address5;
      receiver_address6_          := from_shipment_rec_.receiver_address6;
      receiver_city_              := from_shipment_rec_.receiver_city;
      receiver_state_             := from_shipment_rec_.receiver_state;
      receiver_zip_code_          := from_shipment_rec_.receiver_zip_code;
      receiver_county_            := from_shipment_rec_.receiver_county;
      receiver_country_           := from_shipment_rec_.receiver_country;
      receiver_ref_               := from_shipment_rec_.receiver_reference;
      customs_value_currency_     := from_shipment_rec_.customs_value_currency;
      -- add consolidated parameters
      ship_source_ref1_           := from_shipment_rec_.source_ref1;
      consol_route_id_            := from_shipment_rec_.route_id;
      consol_forward_agent_id_    := from_shipment_rec_.forward_agent_id;
      consol_ref_id_              := from_shipment_rec_.ref_id;
      consol_dock_code_           := from_shipment_rec_.dock_code;
      consol_sub_dock_code_       := from_shipment_rec_.sub_dock_code;
      consol_location_no_         := from_shipment_rec_.location_no;  
      ship_inventory_location_no_ := from_shipment_rec_.ship_inventory_location_no;       
      freight_payer_db_           := from_shipment_rec_.shipment_freight_payer;
      freight_payer_id_           := from_shipment_rec_.shipment_freight_payer_id;
      FOR rule_ IN get_consol_rule LOOP
         CASE rule_.consol_param  
            WHEN 'PLANNED SHIP DATE' THEN 
               consol_planned_ship_date_  := source_line_rec_.planned_ship_date;
            WHEN 'PLANNED DEL DATE' THEN 
               consol_planned_del_date_   := source_line_rec_.planned_delivery_date;              
            ELSE
               NULL;
         END CASE;
      END LOOP;
   END IF;
   approve_before_delivery_ := Shipment_Type_API.Get_Approve_Before_Delivery_Db(shipment_type_);
   
   -- Fetching Sender Address info to the shipment
   Shipment_Source_Utility_API.Get_Sender_Address_Info(addr_attr_, sender_id_, sender_addr_id_, contract_, sender_type_db_, 
                                                       source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   
   Client_SYS.Add_To_Attr('SENDER_ADDRESS1',               Client_SYS.Get_Item_Value('SENDER_ADDRESS1', addr_attr_),      attr_);
   Client_SYS.Add_To_Attr('SENDER_ADDRESS2',               Client_SYS.Get_Item_Value('SENDER_ADDRESS2', addr_attr_),      attr_);
   Client_SYS.Add_To_Attr('SENDER_ADDRESS3',               Client_SYS.Get_Item_Value('SENDER_ADDRESS3', addr_attr_),      attr_);
   Client_SYS.Add_To_Attr('SENDER_ADDRESS4',               Client_SYS.Get_Item_Value('SENDER_ADDRESS4', addr_attr_),      attr_);
   Client_SYS.Add_To_Attr('SENDER_ADDRESS5',               Client_SYS.Get_Item_Value('SENDER_ADDRESS5', addr_attr_),      attr_);
   Client_SYS.Add_To_Attr('SENDER_ADDRESS6',               Client_SYS.Get_Item_Value('SENDER_ADDRESS6', addr_attr_),      attr_);
   Client_SYS.Add_To_Attr('SENDER_ZIP_CODE',               Client_SYS.Get_Item_Value('SENDER_ZIP_CODE', addr_attr_),      attr_);
   Client_SYS.Add_To_Attr('SENDER_CITY',                   Client_SYS.Get_Item_Value('SENDER_CITY', addr_attr_),          attr_);
   Client_SYS.Add_To_Attr('SENDER_STATE',                  Client_SYS.Get_Item_Value('SENDER_STATE', addr_attr_),         attr_);
   Client_SYS.Add_To_Attr('SENDER_COUNTY',                 Client_SYS.Get_Item_Value('SENDER_COUNTY', addr_attr_),        attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ID',                   receiver_id_,                                                  attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDR_ID',              receiver_addr_id_,                                             attr_);
   Client_SYS.Add_To_Attr('CONTRACT',                      contract_,                                                     attr_);
   Client_SYS.Add_To_Attr('SENDER_ID',                     sender_id_,                                                    attr_);
   Client_SYS.Add_To_Attr('SENDER_TYPE_DB',                sender_type_db_,                                               attr_);
   Client_SYS.Add_To_Attr('RECEIVER_TYPE_DB',              receiver_type_db_,                                             attr_);
   Client_SYS.Add_To_Attr('SENDER_COUNTRY',                Client_SYS.Get_Item_Value('SENDER_COUNTRY', addr_attr_),       attr_);
   Client_SYS.Add_To_Attr('SENDER_ADDR_ID',                sender_addr_id_,                                               attr_);
   Client_SYS.Add_To_Attr('SHIP_VIA_CODE',                 ship_via_code_,                                                attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TERMS',                delivery_terms_,                                               attr_);
   Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION',            del_terms_location_,                                           attr_);
   Client_SYS.Add_To_Attr('LANGUAGE_CODE',                 language_code_,                                                attr_);
   Client_SYS.Add_To_Attr('SENDER_NAME',                   Client_SYS.Get_Item_Value('SENDER_ADDRESS_NAME', addr_attr_),  attr_);
   Client_SYS.Add_To_Attr('SENDER_REFERENCE',              Client_SYS.Get_Item_Value('SENDER_REFERENCE', addr_attr_),     attr_);
   Client_SYS.Add_To_Attr('RECEIVER_REFERENCE',            receiver_ref_,                                                 attr_);
   Client_SYS.Add_To_Attr('ADDR_FLAG_DB',                  addr_flag_,                                                    attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS_NAME',         receiver_address_name_,                                        attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS1',             receiver_address1_,                                            attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS2',             receiver_address2_,                                            attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS3',             receiver_address3_,                                            attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS4',             receiver_address4_,                                            attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS5',             receiver_address5_,                                            attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS6',             receiver_address6_,                                            attr_);
   Client_SYS.Add_To_Attr('RECEIVER_CITY',                 receiver_city_,                                                attr_);
   Client_SYS.Add_To_Attr('RECEIVER_STATE',                receiver_state_,                                               attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ZIP_CODE',             receiver_zip_code_,                                            attr_);
   Client_SYS.Add_To_Attr('RECEIVER_COUNTY',               receiver_county_,                                              attr_);
   Client_SYS.Add_To_Attr('RECEIVER_COUNTRY',              receiver_country_,                                             attr_);   
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB',         use_price_incl_tax_,                                           attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_TYPE',                 shipment_type_,                                                attr_);
   Client_SYS.Add_To_Attr('APPROVE_BEFORE_DELIVERY_DB',    approve_before_delivery_,                                      attr_);
   -- add consolidated parameters
   Client_SYS.Add_To_Attr('SOURCE_REF1',                   ship_source_ref1_,                 attr_);
   Client_SYS.Add_To_Attr('PLANNED_SHIP_DATE',             consol_planned_ship_date_,         attr_);
   Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE',         consol_planned_del_date_,          attr_);     
   Client_SYS.Add_To_Attr('ROUTE_ID',                      consol_route_id_,                  attr_);
   Client_SYS.Add_To_Attr('FORWARD_AGENT_ID',              consol_forward_agent_id_,          attr_);
   Client_SYS.Add_To_Attr('REF_ID',                        consol_ref_id_,                    attr_);
   Client_SYS.Add_To_Attr('DOCK_CODE',                     consol_dock_code_,                 attr_);
   Client_SYS.Add_To_Attr('SUB_DOCK_CODE',                 consol_sub_dock_code_,             attr_);
   Client_SYS.Add_To_Attr('LOCATION_NO',                   consol_location_no_,               attr_);
   Client_SYS.Add_To_Attr('AUTOMATIC_CREATION',            'TRUE',                            attr_);
   Client_SYS.Add_To_Attr('CUSTOMS_VALUE_CURRENCY',        customs_value_currency_,           attr_);
   Client_SYS.Add_To_Attr('ORIGINATING_SOURCE_REF_TYPE',   source_ref_type_db_,               attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_FREIGHT_PAYER_DB',     freight_payer_db_,                 attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_FREIGHT_PAYER_ID',     freight_payer_id_,                 attr_);
   IF (ship_inventory_location_no_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SHIP_INVENTORY_LOCATION_NO', ship_inventory_location_no_,       attr_);
   END IF;
   Client_SYS.Add_To_Attr('SHIPMENT_CATEGORY_DB',          Shipment_Category_API.DB_NORMAL,   attr_);
   
   $IF Component_Order_SYS.INSTALLED $THEN
      Client_SYS.Add_To_Attr('SHIPMENT_UNCON_STRUCT_DB',      Cust_Ord_Customer_Address_API.Get_Shipment_Uncon_Struct_Db(receiver_id_, receiver_addr_id_),         attr_);
      IF (consol_route_id_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('LOAD_SEQUENCE_NO', Load_Plan_Line_API.Get_Load_Seq_No(source_line_rec_.route_id,  ship_via_code_, contract_, receiver_id_, receiver_addr_id_), attr_);
      END IF; 
   $END
          
	RETURN attr_;
END Build_Attr_Create_Shipment___;

PROCEDURE Connect_Hu_To_Ship___ (
   handling_unit_id_    IN NUMBER,
   shipment_id_         IN NUMBER,
   assign_existing_hu_  IN BOOLEAN,
   report_picking_      IN BOOLEAN)
IS
   CURSOR get_qty_not_on_shipment IS
      SELECT SUM(qty_onhand) quantity
      FROM INVENTORY_PART_IN_STOCK_PUB
      WHERE handling_unit_id IN (SELECT handling_unit_id
                                 FROM HANDLING_UNIT_PUB
                                 CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                                 START WITH     handling_unit_id = handling_unit_id_)
      AND (qty_onhand + qty_in_transit) > 0
      GROUP BY contract, part_no, configuration_id, location_no, lot_batch_no, serial_no, 
               eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id
      MINUS
      SELECT SUM(qty_assigned) quantity
      FROM SHIPMENT_SOURCE_RESERVATION
      WHERE shipment_id = shipment_id_
      AND handling_unit_id IN (SELECT handling_unit_id
                               FROM HANDLING_UNIT_PUB
                               CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                               START WITH     handling_unit_id = handling_unit_id_)
      GROUP BY contract, part_no, configuration_id, location_no, lot_batch_no, serial_no, 
               eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id;
                   
   CURSOR get_reservations IS
      SELECT source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type_db,
             contract, part_no, location_no, lot_batch_no, serial_no, eng_chg_level, 
             waiv_dev_rej_no, activity_seq, handling_unit_id, configuration_id, pick_list_no,
             Shipment_Reserv_Handl_Unit_API.Get_Qty_To_Attach_On_Res(source_ref1, 
                                                                     source_ref2,
                                                                     source_ref3,
                                                                     source_ref4,
                                                                     source_ref_type_db,
                                                                     contract,
                                                                     part_no,
                                                                     location_no,
                                                                     lot_batch_no,
                                                                     serial_no,
                                                                     eng_chg_level,
                                                                     waiv_dev_rej_no,
                                                                     activity_seq,
                                                                     handling_unit_id, 
                                                                     configuration_id, 
                                                                     pick_list_no,
                                                                     shipment_id) qty_to_attach,
             catch_qty - NVL(Shipment_Reserv_Handl_Unit_API.Get_Catch_Qty_On_Shipment(source_ref1, 
                                                                                      source_ref2,
                                                                                      source_ref3,
                                                                                      source_ref4,
                                                                                      source_ref_type_db,
                                                                                      contract,
                                                                                      part_no,
                                                                                      location_no,
                                                                                      lot_batch_no,
                                                                                      serial_no,
                                                                                      eng_chg_level,
                                                                                      waiv_dev_rej_no,
                                                                                      activity_seq,
                                                                                      handling_unit_id, 
                                                                                      configuration_id, 
                                                                                      pick_list_no,
                                                                                      shipment_id),0) catch_qty_to_attach
      FROM SHIPMENT_SOURCE_RESERVATION
      WHERE shipment_id      = shipment_id_
      AND handling_unit_id IN (SELECT handling_unit_id
                               FROM HANDLING_UNIT_PUB
                               CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                               START WITH     handling_unit_id = handling_unit_id_);  
   shipment_line_rec_           Shipment_Line_API.Public_Rec;
   quantity_not_on_shipment_    NUMBER;
   conn_source_qty_to_attach_   NUMBER;
BEGIN
   OPEN get_qty_not_on_shipment;
   FETCH get_qty_not_on_shipment INTO quantity_not_on_shipment_;
   CLOSE get_qty_not_on_shipment;

   IF (NVL(quantity_not_on_shipment_, 0) > 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_HU_CONN: Unable to connect handling unit :P1 to shipment :P2. All inventory stock must be reserved to the shipment.', handling_unit_id_, shipment_id_);
   END IF;
   IF (Handling_Unit_API.Get_Shipment_Id(handling_unit_id_) IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'HU_ALRDY_ON_SHIP: The handling unit :P1 is already on a shipment and can not be connected to shipment :P2', handling_unit_id_, shipment_id_);
   END IF;
      
   IF (Handling_Unit_API.Get_Parent_Handling_Unit_Id(handling_unit_id_) IS NOT NULL) THEN
      Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_         => handling_unit_id_, 
                                                       parent_handling_unit_id_  => NULL);
   END IF;

   Handling_Unit_API.Modify_Shipment_Id(handling_unit_id_   => handling_unit_id_, 
                                        shipment_id_        => shipment_id_);

   -- Connect the shipment line and the reservations to the added handling unit structure.
   FOR rec_ IN get_reservations LOOP
      shipment_line_rec_ := Shipment_Line_API.Get_By_Source(shipment_id_          => shipment_id_, 
                                                            source_ref1_          => rec_.source_ref1, 
                                                            source_ref2_          => Shipment_Line_API.Get_Converted_Source_Ref(rec_.source_ref2, rec_.source_ref_type_db),
                                                            source_ref3_          => Shipment_Line_API.Get_Converted_Source_Ref(rec_.source_ref3, rec_.source_ref_type_db, 3),
                                                            source_ref4_          => Shipment_Line_API.Get_Converted_Source_Ref(rec_.source_ref4, rec_.source_ref_type_db, 4),
                                                            source_ref_type_db_   => rec_.source_ref_type_db);
                                                                                
      conn_source_qty_to_attach_ := Shipment_Handling_Utility_API.Get_Converted_Source_Qty(shipment_id_           => shipment_line_rec_.shipment_id, 
                                                                                           shipment_line_no_      => shipment_line_rec_.shipment_line_no,
                                                                                           inventory_qty_         => rec_.qty_to_attach,
                                                                                           conv_factor_           => shipment_line_rec_.conv_factor,
                                                                                           inverted_conv_factor_  => shipment_line_rec_.inverted_conv_factor);

         Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing(shipment_id_           => shipment_id_, 
                                                             shipment_line_no_      => shipment_line_rec_.shipment_line_no, 
                                                             handling_unit_id_      => rec_.handling_unit_id, 
                                                             quantity_to_be_added_  => conn_source_qty_to_attach_,
                                                          assign_existing_hu_   => assign_existing_hu_,
                                                          report_picking_       => report_picking_);
                                                              

         Shipment_Reserv_Handl_Unit_API.New_Or_Add_To_Existing(source_ref1_               => rec_.source_ref1,
                                                               source_ref2_               => NVL(rec_.source_ref2,'*'),
                                                               source_ref3_               => NVL(rec_.source_ref3,'*'),
                                                               source_ref4_               => NVL(rec_.source_ref4,'*'),
                                                               contract_                  => rec_.contract,
                                                               part_no_                   => rec_.part_no,
                                                               location_no_               => rec_.location_no,
                                                               lot_batch_no_              => rec_.lot_batch_no,
                                                               serial_no_                 => rec_.serial_no,
                                                               eng_chg_level_             => rec_.eng_chg_level,
                                                               waiv_dev_rej_no_           => rec_.waiv_dev_rej_no,
                                                               activity_seq_              => rec_.activity_seq,
                                                               reserv_handling_unit_id_   => rec_.handling_unit_id,
                                                               configuration_id_          => rec_.configuration_id,
                                                               pick_list_no_              => rec_.pick_list_no,
                                                               shipment_id_               => shipment_id_,
                                                               shipment_line_no_          => shipment_line_rec_.shipment_line_no,
                                                               handling_unit_id_          => rec_.handling_unit_id,
                                                               quantity_to_be_added_      => rec_.qty_to_attach,
                                                               catch_qty_to_reassign_     => rec_.catch_qty_to_attach);    
   END LOOP;
END Connect_Hu_To_Ship___;


PROCEDURE Disconn_Hu_From_Ship___ (
   handling_unit_id_       IN NUMBER,
   disconnect_structure_   IN BOOLEAN )
IS
   CURSOR get_children IS
      SELECT handling_unit_id
        FROM HANDLING_UNIT_PUB
       WHERE parent_handling_unit_id = handling_unit_id_;
   
   parent_handling_unit_id_   NUMBER;
BEGIN
   IF (Handling_Unit_API.Get_Shipment_Id(handling_unit_id_) IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'HU_NO_SHIP: The handling unit is not connected to any shipment.');
   END IF;
   
   Inventory_Event_Manager_API.Start_Session;
   
   IF (NOT disconnect_structure_) THEN
      parent_handling_unit_id_ := Handling_Unit_API.Get_Parent_Handling_Unit_Id(handling_unit_id_);  
      FOR rec_ IN get_children LOOP
         Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_         => rec_.handling_unit_id, 
                                                          parent_handling_unit_id_  => parent_handling_unit_id_);
      END LOOP;
   END IF;
   
   IF (Handling_Unit_API.Get_Parent_Handling_Unit_Id(handling_unit_id_) IS NOT NULL) THEN
      Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_         => handling_unit_id_, 
                                                       parent_handling_unit_id_  => NULL);
   END IF;
   
   Handling_Unit_API.Modify_Shipment_Id(handling_unit_id_   => handling_unit_id_, 
                                        shipment_id_        => NULL);

   Inventory_Event_Manager_API.Finish_Session;
END Disconn_Hu_From_Ship___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Add_Source_Line_To_Shipment__
--   This is callled from the client side to connect source line to shipment
PROCEDURE Add_Source_Line_To_Shipment__ (
   shipment_id_              OUT NUMBER,  
   source_ref1_              IN  VARCHAR2,
   source_ref2_              IN  VARCHAR2,
   source_ref3_              IN  VARCHAR2,
   source_ref4_              IN  VARCHAR2, 
   source_ref_type_db_       IN  VARCHAR2, 
   receiver_type_db_         IN  VARCHAR2,
   ignore_existing_shipment_ IN  VARCHAR2)
IS
   dummy_      Shipment_API.Shipment_Id_Tab;
BEGIN
   Add_Source_Line_To_Shipment(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, receiver_type_db_, dummy_, ignore_existing_shipment_);
END Add_Source_Line_To_Shipment__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Any_Shipment_Qty_Deviation
--   If there is a difference in quantities in connected lines in the
--   shipment and the created package structure exception will be raised.
--   This method will be used by the new Handling Unit
PROCEDURE Any_Shipment_Qty_Deviation (
   shipment_id_ IN NUMBER )
IS
   deviation_  VARCHAR2(5) := NULL;
   attached_qty_ NUMBER;
   CURSOR connected_lines IS
      SELECT shipment_line_no, source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type, qty_picked
        FROM shipment_line_tab
       WHERE shipment_id = shipment_id_
       AND (((source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(source_ref4) <= 0))
           OR (source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER));          
BEGIN
   IF (Shipment_API.Shipment_Structure_Exist(shipment_id_) = 'TRUE') THEN
      FOR rec_ IN connected_lines LOOP
         attached_qty_     := Shipment_Reserv_Handl_Unit_API.Get_Line_Attached_Qty(rec_.source_ref1,
                                                                                   NVL(rec_.source_ref2,'*'),
                                                                                   NVL(rec_.source_ref3,'*'),
                                                                                   NVL(rec_.source_ref4,'*'),
                                                                                   shipment_id_, 
                                                                                   rec_.shipment_line_no,
                                                                                   NULL);
         
         IF(attached_qty_ != rec_.qty_picked) THEN
         deviation_ := Any_Packing_Qty_Deviation___(rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, 
                                                    rec_.source_ref4, rec_.source_ref_type, shipment_id_);
         IF (deviation_ = 'TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'QTYDEV: The picked quantity on Shipment :P1 Line No :P2 has not been fully packed into the handling unit structure. If a handling unit structure is used, the full quantity has to be packed before completing the shipment.', shipment_id_, rec_.shipment_line_no);
         END IF;
         END IF;
      END LOOP;
   END IF;
END Any_Shipment_Qty_Deviation;


@UncheckedAccess
FUNCTION Get_Remaining_Qty_To_Attach (
   shipment_id_         IN NUMBER,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN NUMBER
IS
   connected_qty_ NUMBER;
   available_qty_ NUMBER;
BEGIN
   available_qty_ := Get_Available_Quantity(shipment_id_, 
                                            source_ref1_, 
                                            source_ref2_, 
                                            source_ref3_, 
                                            source_ref4_,
                                            source_ref_type_db_);

   connected_qty_ := Shipment_Line_Handl_Unit_API.Get_Shipment_Line_Quantity(shipment_id_,
                                                                             source_ref1_,
                                                                             source_ref2_,
                                                                             source_ref3_,
                                                                             source_ref4_,
                                                                             source_ref_type_db_ );

   RETURN (available_qty_ - connected_qty_);
END Get_Remaining_Qty_To_Attach;


@UncheckedAccess
FUNCTION Get_Available_Quantity (
   shipment_id_         IN NUMBER,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN NUMBER
IS
   available_qty_       NUMBER;   
BEGIN   
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER AND Utility_SYS.String_To_Number(source_ref4_) = -1) THEN
       $IF (Component_Order_SYS.INSTALLED) $THEN
         -- package parts
         available_qty_ := Shipment_Order_Utility_API.Get_No_Of_Packages_To_Ship(source_ref1_, source_ref2_, source_ref3_, shipment_id_);
      $ELSE
         NULL;
      $END      
   ELSE
     available_qty_ := Shipment_Line_API.Get_Conn_Source_Qty_By_Source(shipment_id_,
                                                                       source_ref1_,
                                                                       source_ref2_,
                                                                       source_ref3_,
                                                                       source_ref4_,
                                                                       source_ref_type_db_);
   END IF;

   RETURN nvl(available_qty_, 0);
END Get_Available_Quantity;


-- Add_Source_Line_To_Shipment
--   When saving customer order line to an already released customer order,
--   add that line to an existing or newly created shipment according to the
--   value of shipment creation.
PROCEDURE Add_Source_Line_To_Shipment (
   shipment_id_              OUT NUMBER,  
   source_ref1_              IN  VARCHAR2,
   source_ref2_              IN  VARCHAR2,
   source_ref3_              IN  VARCHAR2,
   source_ref4_              IN  VARCHAR2, 
   source_ref_type_db_       IN  VARCHAR2,
   receiver_type_db_         IN  VARCHAR2,
   shipment_id_tab_          IN  Shipment_API.Shipment_Id_Tab,
   ignore_existing_shipment_ IN  VARCHAR2, 
   sender_type_db_           IN  VARCHAR2 DEFAULT NULL,
   sender_id_                IN  VARCHAR2 DEFAULT NULL)
IS
   new_shipment_id_        NUMBER;
   tmp_line_item_no_       NUMBER;   
   already_connected_      VARCHAR2(5):= 'FALSE';
   use_price_incl_tax_     VARCHAR2(20);
   source_line_rec_        Shipment_Source_Utility_API.Public_Line_Rec;   
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN 
      $IF Component_Order_SYS.INSTALLED $THEN
         use_price_incl_tax_ := Customer_order_API.Get_Use_Price_Incl_Tax_Db(source_ref1_);
      $END
      IF (Utility_SYS.String_To_Number(source_ref4_) > 0) THEN
         tmp_line_item_no_  := -1 ;
         already_connected_ := Shipment_Line_API.Check_Active_Shipment_Exist(source_ref1_, source_ref2_ , 
                                                                             source_ref3_ , tmp_line_item_no_, source_ref_type_db_); 
      END IF;       
   END IF;
   
   source_line_rec_ := Shipment_Source_Utility_API.Get_Line(source_ref1_, source_ref2_, source_ref3_, 
                                                            source_ref4_, source_ref_type_db_, sender_type_db_, sender_id_);
   IF ignore_existing_shipment_ = 'FALSE' THEN
       Find_Existing_Shipment___(new_shipment_id_,
                                 source_line_rec_.source_ref1,
                                 source_line_rec_.source_ref2,
                                 source_line_rec_.source_ref3,
                                 source_line_rec_.source_ref4,
                                 source_ref_type_db_,
                                 source_line_rec_.receiver_id,
                                 receiver_type_db_,
                                 source_line_rec_.sender_id,
                                 source_line_rec_.sender_type,
                                 source_line_rec_.receiver_addr_id,
                                 source_line_rec_.sender_addr_id,
                                 source_line_rec_.ship_via_code,
                                 source_line_rec_.contract,
                                 source_line_rec_.delivery_terms,
                                 shipment_id_tab_,
                                 use_price_incl_tax_,
                                 source_line_rec_.shipment_type );
   END IF;

   IF (already_connected_ = 'FALSE') THEN
      Create_Or_Connect_Shipment___(new_shipment_id_,
                                    source_line_rec_.source_ref1,
                                    source_line_rec_.source_ref2,
                                    source_line_rec_.source_ref3,
                                    source_line_rec_.source_ref4,
                                    source_ref_type_db_,
                                    source_line_rec_.receiver_id,
                                    receiver_type_db_,
                                    source_line_rec_.sender_id,
                                    source_line_rec_.sender_type,
                                    source_line_rec_.sender_addr_id,
                                    source_line_rec_.receiver_addr_id,
                                    source_line_rec_.ship_via_code,
                                    source_line_rec_.contract,
                                    source_line_rec_.delivery_terms,
                                    source_line_rec_.del_terms_location,
                                    source_line_rec_.forward_agent_id,
                                    use_price_incl_tax_,
                                    source_line_rec_.shipment_type );
   END IF;      
                           
   -- Return the shipment id of the shipment where the CO line was connected to
   shipment_id_ := new_shipment_id_;
END Add_Source_Line_To_Shipment;


-- Any_Shipment_Connected_Lines
--   This method checks whether there exist any connected open shipments
--   for a given Source Ref Number.
@UncheckedAccess
FUNCTION Any_Shipment_Connected_Lines (
   source_ref1_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS
   result_ NUMBER;
   exist_  VARCHAR2(5) := 'FALSE';
   CURSOR shipment_lines IS
      SELECT 1
      FROM SHIPMENT_TAB s, SHIPMENT_LINE_TAB sl
      WHERE  s.shipment_id  = sl.shipment_id
      AND    NVL(sl.source_ref1, string_null_) = NVL(source_ref1_, string_null_)
      AND    sl.source_ref_type = source_ref_type_db_
      AND    s.rowstate    != 'Closed';
BEGIN
   OPEN shipment_lines;
   FETCH shipment_lines INTO result_;
   IF (shipment_lines%FOUND) THEN
      exist_ := 'TRUE';
   END IF;
   CLOSE shipment_lines;
   RETURN exist_;
END Any_Shipment_Connected_Lines;


-- Any_Shipment_Conn_For_Site
--   This method checks whether there exist any connected open shipments
--   which having 'Customer Order' source ref type lines. 
@UncheckedAccess
FUNCTION Any_Shipment_Conn_For_Site (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   result_ NUMBER;
   exist_  VARCHAR2(5) := 'FALSE';
   CURSOR shipment_lines IS
      SELECT 1
      FROM SHIPMENT_TAB s, SHIPMENT_LINE_TAB sl
      WHERE s.shipment_id = sl.shipment_id
      AND   s.contract    = contract_
      AND   s.rowstate    = 'Preliminary'
      AND   sl.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER;
BEGIN
   OPEN shipment_lines;
   FETCH shipment_lines INTO result_;
   IF (shipment_lines%FOUND) THEN
      exist_ := 'TRUE';
   END IF;
   CLOSE shipment_lines;
   RETURN exist_;
END Any_Shipment_Conn_For_Site;


@UncheckedAccess
FUNCTION Get_Packing_Qty_Deviation (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   shipment_id_        IN NUMBER ) RETURN NUMBER 
   IS
   line_picked_qty_           NUMBER := 0;
   line_qty_packed_           NUMBER := 0;  
   line_rec_                  Shipment_Line_API.Public_Rec;
   qty_deviation_             NUMBER := 0;
   qty_picked_fetched_        BOOLEAN := FALSE;
   BEGIN 
   line_rec_ := Shipment_Line_API.Get_By_Source(shipment_id_,
                                                Shipment_Line_API.Get_Converted_Source_Ref(source_ref1_, source_ref_type_db_, 1), 
                                                Shipment_Line_API.Get_Converted_Source_Ref(source_ref2_, source_ref_type_db_, 2), 
                                                Shipment_Line_API.Get_Converted_Source_Ref(source_ref3_, source_ref_type_db_, 3), 
                                                Shipment_Line_API.Get_Converted_Source_Ref(source_ref4_, source_ref_type_db_, 4),
                                                source_ref_type_db_);
   IF(line_rec_.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         IF(Utility_SYS.String_To_Number(source_ref4_) > 0 ) THEN
            RETURN 0;
         ELSIF (Utility_SYS.String_To_Number(source_ref4_) = -1 ) THEN
            Shipment_Order_Utility_API.Get_Pkg_Part_Qy_Picked(line_picked_qty_, shipment_id_,  source_ref1_, source_ref2_, source_ref3_, source_ref4_, line_rec_.qty_assigned, line_rec_.qty_shipped, line_rec_.qty_picked);
            qty_picked_fetched_ := TRUE;
         END IF;
      $ELSE
         NULL;
      $END
   END IF;

   IF (NOT qty_picked_fetched_) THEN
      -- Note: Check for Inventory or non-Inventory part
      -- Note: Consider non-inventory parts for non package part line only
      line_picked_qty_ := line_rec_.qty_shipped;              
      IF (line_picked_qty_ = 0) THEN
         IF ((line_rec_.inventory_part_no IS NULL) AND 
             (Shipment_Source_Utility_API.Is_Goods_Non_Inv_Part_Type(shipment_id_, line_rec_.source_part_no, line_rec_.inventory_part_no, line_rec_.source_ref_type) = 'TRUE')) THEN      
            line_picked_qty_ := line_rec_.qty_to_ship;
         ELSE
            line_picked_qty_ := line_rec_.qty_picked;
         END IF;     
      END IF;
   END IF;   
    
   line_qty_packed_   := Shipment_Line_Handl_Unit_API.Get_Shipment_Line_Inv_Qty(shipment_id_,
                                                                                source_ref1_,
                                                                                source_ref2_,
                                                                                source_ref3_,
                                                                                source_ref4_,
                                                                                line_rec_.source_ref_type);     
      
   IF (line_picked_qty_ > 0 OR line_qty_packed_ > 0) THEN
      IF (line_picked_qty_ != line_qty_packed_) THEN
         qty_deviation_ := (line_picked_qty_ - line_qty_packed_);
      END IF;
   END IF;
   RETURN qty_deviation_;   
END Get_Packing_Qty_Deviation;


PROCEDURE Modify_Shipment_Qty_To_Ship (
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   shipment_id_  IN NUMBER )
IS
   shipment_line_rec_     Shipment_Line_API.Public_Rec;   
BEGIN
   IF (shipment_id_ != 0) THEN
      shipment_line_rec_ := Shipment_Line_API.Get_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);      
      Shipment_Line_API.Modify_Qty_To_Ship(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                           source_ref_type_db_, shipment_line_rec_.inventory_qty);
   ELSE
      Modify_Qty_To_Ship_Source_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   END IF;
END Modify_Shipment_Qty_To_Ship;

PROCEDURE Modify_Qty_To_Ship_Source_Line (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 )
IS
   CURSOR get_ship_connected_lines IS
      SELECT shipment_id, inventory_qty
      FROM   shipment_line_tab
      WHERE  NVL(source_ref1, string_null_) =  NVL(source_ref1_, string_null_)
      AND    NVL(source_ref2, string_null_) =  NVL(source_ref2_, string_null_)
      AND    NVL(source_ref3, string_null_) =  NVL(source_ref3_, string_null_)
      AND    NVL(source_ref4, string_null_) =  NVL(source_ref4_, string_null_)
      AND    qty_shipped = 0
      AND    source_ref_type = source_ref_type_db_;
BEGIN
   FOR shipment_rec_ IN get_ship_connected_lines LOOP
      Shipment_Line_API.Modify_Qty_To_Ship(shipment_rec_.shipment_id, source_ref1_, source_ref2_, source_ref3_, source_ref4_, 
                                           source_ref_type_db_, shipment_rec_.inventory_qty);
   END LOOP;
END Modify_Qty_To_Ship_Source_Line;

@UncheckedAccess
FUNCTION Get_Converted_Inv_Qty (
   shipment_id_          IN  NUMBER,
   shipment_line_no_     IN  NUMBER,
   shipment_qty_         IN NUMBER,
   conv_factor_          IN NUMBER,
   inverted_conv_factor_ IN NUMBER) RETURN NUMBER
IS 
   inventory_qty_     NUMBER;
   shipment_line_rec_ Shipment_Line_API.Public_Rec;
BEGIN
   IF (conv_factor_ IS NULL) THEN
      shipment_line_rec_ := Shipment_Line_API.Get(shipment_id_, shipment_line_no_);
   END IF;   
   inventory_qty_   := (shipment_qty_ * NVL(conv_factor_, shipment_line_rec_.conv_factor) / NVL(inverted_conv_factor_, shipment_line_rec_.inverted_conv_factor));
   RETURN NVL(inventory_qty_, 0);  
END Get_Converted_Inv_Qty;

@UncheckedAccess
FUNCTION Get_Converted_Source_Qty (
   shipment_id_          IN  NUMBER,
   shipment_line_no_     IN  NUMBER,
   inventory_qty_        IN NUMBER,
   conv_factor_          IN NUMBER,
   inverted_conv_factor_ IN NUMBER) RETURN NUMBER
IS      
   source_inv_qty_    NUMBER;
   shipment_line_rec_ Shipment_Line_API.Public_Rec;
BEGIN
   IF (conv_factor_ IS NULL) THEN
      shipment_line_rec_ := Shipment_Line_API.Get(shipment_id_, shipment_line_no_);
   END IF;
   source_inv_qty_  := (inventory_qty_ * NVL(inverted_conv_factor_, shipment_line_rec_.inverted_conv_factor) / NVL(conv_factor_, shipment_line_rec_.conv_factor));
   RETURN NVL(source_inv_qty_, 0); 
END Get_Converted_Source_Qty;


PROCEDURE Add_Hu_To_Shipment (
   handling_unit_id_        IN NUMBER,
   shipment_id_             IN NUMBER,
   parent_handling_unit_id_ IN NUMBER DEFAULT NULL,
   assign_existing_hu_      IN BOOLEAN DEFAULT NULL,
   report_picking_          IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (NVL(Handling_Unit_API.Get_Shipment_Id(handling_unit_id_), 0) != shipment_id_) THEN
      Connect_Hu_To_Ship___(handling_unit_id_   => handling_unit_id_,
                            shipment_id_        => shipment_id_,
                            assign_existing_hu_ => assign_existing_hu_,
                            report_picking_     => report_picking_);

      IF (parent_handling_unit_id_ IS NOT NULL) THEN      
         Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_         => handling_unit_id_, 
                                                          parent_handling_unit_id_  => parent_handling_unit_id_);                                                     
      END IF; 
   END IF;
END Add_Hu_To_Shipment;

-- Looks at all the picked reservations for a shipment and tries to attach as "big" Handling Units as possible.
PROCEDURE Connect_HUs_From_Inventory (
   shipment_id_     IN NUMBER,
   report_picking_  IN BOOLEAN DEFAULT FALSE )
IS
   CURSOR get_unpacked_reserved_stock IS
      SELECT contract, part_no, configuration_id, location_no, 
             lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, 
             activity_seq, handling_unit_id, SUM(qty_picked) quantity
      FROM   SHIPMENT_SOURCE_RESERVATION ssr
      WHERE  shipment_id = shipment_id_
      AND    handling_unit_id != 0
      AND    qty_picked > 0
      AND NOT EXISTS (SELECT 1
                      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB srhu
                      WHERE srhu.shipment_id              = ssr.shipment_id
                      AND srhu.source_ref1              = ssr.source_ref1
                      AND srhu.source_ref2              = ssr.source_ref2
                      AND srhu.source_ref3              = ssr.source_ref3
                      AND srhu.source_ref4              = ssr.source_ref4
                      AND Shipment_Line_API.Get_Source_Ref_Type_Db(srhu.shipment_id, srhu.shipment_line_no) = ssr.source_ref_type_db
                      AND srhu.contract                 = ssr.contract
                      AND srhu.part_no                  = ssr.part_no
                      AND srhu.location_no              = ssr.location_no
                      AND srhu.lot_batch_no             = ssr.lot_batch_no
                      AND srhu.serial_no                = ssr.serial_no
                      AND srhu.eng_chg_level            = ssr.eng_chg_level
                      AND srhu.waiv_dev_rej_no          = ssr.waiv_dev_rej_no
                      AND srhu.activity_seq             = ssr.activity_seq
                      AND srhu.configuration_id         = ssr.configuration_id
                      AND srhu.reserv_handling_unit_id  = ssr.handling_unit_id)
      -- Remove the reservations that are package components.
      AND NOT ((source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(source_ref4) > 0))
      GROUP BY contract, part_no, configuration_id, location_no, 
               lot_batch_no, serial_no, eng_chg_level, 
               waiv_dev_rej_no, activity_seq, handling_unit_id;
   
   inv_part_stock_tab_        Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
   handling_unit_tab_         Handl_Unit_Stock_Snapshot_API.Handl_Unit_Stock_Tab;
BEGIN
   OPEN get_unpacked_reserved_stock;
   FETCH get_unpacked_reserved_stock BULK COLLECT INTO inv_part_stock_tab_;
   CLOSE get_unpacked_reserved_stock;

   IF (inv_part_stock_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      Handl_Unit_Snapshot_Util_API.Generate_Snapshot(handl_unit_stock_result_tab_   => handling_unit_tab_, 
                                                     inv_part_stock_result_tab_     => inv_part_stock_tab_, 
                                                     inv_part_stock_tab_            => inv_part_stock_tab_, 
                                                     only_outermost_in_result_      => TRUE);
 
      FOR i IN handling_unit_tab_.FIRST .. handling_unit_tab_.LAST LOOP
         Add_Hu_To_Shipment(handling_unit_id_   => handling_unit_tab_(i).handling_unit_id, 
                            shipment_id_        => shipment_id_,
                            assign_existing_hu_ => TRUE,
                            report_picking_     => report_picking_);
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Connect_HUs_From_Inventory;


-- Used to move shipment handling unit connected quantities between the shipment handling unit structure.
PROCEDURE Move_Handling_Unit_Quantity (
   info_                         OUT VARCHAR2,
   shipment_id_                  IN NUMBER,
   shipment_line_no_             IN NUMBER,
   from_handling_unit_id_        IN NUMBER,
   to_handling_unit_id_          IN NUMBER,
   quantity_to_move_             IN NUMBER,
   move_attached_reservations_   IN VARCHAR2,
   move_unattached_reservations_ IN VARCHAR2)
IS
   -- Get all attached reservations in source HU
   CURSOR get_attached_reservations IS
     SELECT source_ref1, source_ref2, source_ref3, source_ref4, contract, 
            part_no, location_no, lot_batch_no, serial_no, eng_chg_level, 
            waiv_dev_rej_no, activity_seq, reserv_handling_unit_id, configuration_id, pick_list_no, 
            shipment_id_, shipment_line_no_, handling_unit_id, quantity, catch_qty_to_reassign
       FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE shipment_id = shipment_id_
        AND shipment_line_no = shipment_line_no_
        AND handling_unit_id = from_handling_unit_id_;
   
   TYPE Attached_Hu_Reservations_Tab IS TABLE OF get_attached_reservations%ROWTYPE
      INDEX BY PLS_INTEGER;
   attached_hu_reservations_tab_    Attached_Hu_Reservations_Tab;
   attached_qty_exists_             BOOLEAN := FALSE;
   manual_net_weight_               NUMBER;
   unreserved_qty_to_move_          NUMBER := 0;
   reservations_attached_           NUMBER := 0;
BEGIN
   IF (from_handling_unit_id_ = to_handling_unit_id_) THEN
      RETURN;
   END IF;
   
   manual_net_weight_   := Shipment_Line_Handl_Unit_API.Get_Manual_Net_Weight(shipment_id_, shipment_line_no_, from_handling_unit_id_);
   -- Check if an attached quantity of the same shipment line no exists in the destination HU.
   attached_qty_exists_ := Shipment_Line_Handl_Unit_API.Exists(shipment_id_, shipment_line_no_, to_handling_unit_id_);
   
   IF (move_attached_reservations_ = Fnd_Boolean_API.DB_TRUE) THEN
      OPEN get_attached_reservations;
      FETCH get_attached_reservations BULK COLLECT INTO attached_hu_reservations_tab_;
      CLOSE get_attached_reservations;
      
      -- Move each reservation node from source HU to the destination HU.
      IF (attached_hu_reservations_tab_.COUNT > 0) THEN
         FOR i IN attached_hu_reservations_tab_.FIRST .. attached_hu_reservations_tab_.LAST LOOP
            reservations_attached_ := reservations_attached_ + Shipment_Reserv_Handl_Unit_API.Get_Line_Attached_Qty(
                                                                  attached_hu_reservations_tab_(i).source_ref1, 
                                                                  attached_hu_reservations_tab_(i).source_ref2, 
                                                                  attached_hu_reservations_tab_(i).source_ref3, 
                                                                  attached_hu_reservations_tab_(i).source_ref4, 
                                                                  shipment_id_, 
                                                                  shipment_line_no_, 
                                                                  from_handling_unit_id_);
            Shipment_Reserv_Handl_Unit_API.Change_Handling_Unit_Id(
               attached_hu_reservations_tab_(i).source_ref1, 
               attached_hu_reservations_tab_(i).source_ref2, 
               attached_hu_reservations_tab_(i).source_ref3, 
               attached_hu_reservations_tab_(i).source_ref4, 
               attached_hu_reservations_tab_(i).contract, 
               attached_hu_reservations_tab_(i).part_no, 
               attached_hu_reservations_tab_(i).location_no, 
               attached_hu_reservations_tab_(i).lot_batch_no, 
               attached_hu_reservations_tab_(i).serial_no, 
               attached_hu_reservations_tab_(i).eng_chg_level, 
               attached_hu_reservations_tab_(i).waiv_dev_rej_no, 
               attached_hu_reservations_tab_(i).activity_seq, 
               attached_hu_reservations_tab_(i).reserv_handling_unit_id, 
               attached_hu_reservations_tab_(i).configuration_id, 
               attached_hu_reservations_tab_(i).pick_list_no, 
               shipment_id_, 
               shipment_line_no_, 
               from_handling_unit_id_, 
               to_handling_unit_id_, 
               attached_hu_reservations_tab_(i).quantity, 
               attached_hu_reservations_tab_(i).catch_qty_to_reassign);
         END LOOP;
      END IF;
   END IF;
   -- Move unreserved quantity from source HU to the destination HU.
   IF (move_unattached_reservations_ = Fnd_Boolean_API.DB_TRUE) THEN
      IF (quantity_to_move_ - reservations_attached_ > 0) THEN
         unreserved_qty_to_move_ := quantity_to_move_ - reservations_attached_;
         Shipment_Line_Handl_Unit_API.Reduce_Quantity(shipment_id_, shipment_line_no_, from_handling_unit_id_, unreserved_qty_to_move_);

         -- If there exists qty from the same shipment line in the destination HU or not all quantity is being moved, then clear manual net weight.
         IF (attached_qty_exists_ OR Shipment_Line_Handl_Unit_API.Get_Quantity(shipment_id_, shipment_line_no_, from_handling_unit_id_) IS NOT NULL) THEN
            manual_net_weight_ := NULL;
         END IF;

         Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing(shipment_id_, 
                                                             shipment_line_no_, 
                                                             to_handling_unit_id_, 
                                                             unreserved_qty_to_move_,
                                                             manual_net_weight_ => manual_net_weight_);
      END IF;
   END IF;
   info_ := Handling_Unit_API.Get_Max_Capacity_Exceeded_Info(handling_unit_id_ => to_handling_unit_id_);
END Move_Handling_Unit_Quantity;


PROCEDURE Remove_Hu_From_Shipment (
   handling_unit_id_    IN NUMBER,
   remove_structure_db_ IN VARCHAR2 )
IS
   handling_unit_id_tab_   Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   IF (remove_structure_db_ = Fnd_Boolean_API.DB_TRUE) THEN
      handling_unit_id_tab_ := Handling_Unit_API.Get_Node_And_Descendants(handling_unit_id_);   
      FOR i IN handling_unit_id_tab_.FIRST .. handling_unit_id_tab_.LAST LOOP
         IF (Inventory_Transaction_Hist_API.Check_Handling_Unit_Exist(handling_unit_id_tab_(i).handling_unit_id)) THEN
            Error_SYS.Record_General(lu_name_, 'REM_INV_HU_STRUCT: A handling unit structure with inventory transaction history cannot be deleted. Try using Disconnect Handling Unit instead.');
         END IF;
      END LOOP;
      
      Handling_Unit_API.Remove_Structure(handling_unit_id_);
   ELSE
      IF (Inventory_Transaction_Hist_API.Check_Handling_Unit_Exist(handling_unit_id_)) THEN
         Error_SYS.Record_General(lu_name_, 'REM_INV_HU: A handling unit with inventory transaction history cannot be deleted. Try using Disconnect Handling Unit instead.');
      END IF;
      
      Handling_Unit_API.Remove(handling_unit_id_);
   END IF;
END Remove_Hu_From_Shipment;


PROCEDURE Disconnect_Hu_From_Shipment (
   handling_unit_id_          IN NUMBER,
   disconnect_structure_db_   IN VARCHAR2)
IS
BEGIN
   Disconn_Hu_From_Ship___(handling_unit_id_, 
                           disconnect_structure_db_ = Fnd_Boolean_API.DB_TRUE);
END Disconnect_Hu_From_Shipment;


FUNCTION Can_Modify_Hu_Struct_On_Ship (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   result_           VARCHAR2(5) := 'FALSE';
   shipment_state_   VARCHAR2(20);
BEGIN
   shipment_state_ := Shipment_API.Get_Objstate(shipment_id_);
   IF (shipment_state_ NOT IN ('Complete', 'Cancelled', 'Closed')) THEN
      result_ := 'TRUE';
   END IF;
   RETURN(result_);
END Can_Modify_Hu_Struct_On_Ship;


PROCEDURE Remove_All_Hu_On_Shipment (
   shipment_id_ IN NUMBER )
IS
   CURSOR get_handling_units IS 
      SELECT handling_unit_id
        FROM HANDLING_UNIT_PUB
       WHERE shipment_id = shipment_id_
         AND parent_handling_unit_id IS NULL;
      
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   FOR rec_ IN get_handling_units LOOP
      Remove_Hu_From_Shipment(handling_unit_id_    => rec_.handling_unit_id,
                              remove_structure_db_ => Fnd_Boolean_API.DB_TRUE);
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Remove_All_Hu_On_Shipment;


PROCEDURE Disconn_All_Hu_On_Shipment (
   shipment_id_   IN NUMBER )
IS
   CURSOR get_top_handling_units IS 
      SELECT handling_unit_id
        FROM HANDLING_UNIT_PUB
       WHERE shipment_id = shipment_id_
         AND parent_handling_unit_id IS NULL;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   FOR rec_ IN get_top_handling_units LOOP
      Disconn_Hu_From_Ship___(handling_unit_id_      => rec_.handling_unit_id, 
                              disconnect_structure_  => TRUE);
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Disconn_All_Hu_On_Shipment;


PROCEDURE Disconnect_Empty_Hu_On_Ship (
   shipment_id_         IN NUMBER,
   handling_unit_id_    IN NUMBER DEFAULT NULL )
IS
   -- Removes all empty Handling Units from the Shipment
   CURSOR get_all_empty_handling_units IS
     SELECT handling_unit_id
       FROM HANDLING_UNIT_EXTENDED
      WHERE shipment_id = shipment_id_
        AND Shipment_Line_Handl_Unit_API.Get_Sub_Struct_Connected_Qty(shipment_id, handling_unit_id) = 0
      ORDER BY structure_level;
   
   -- Removes all empty Handling Units within a specific Handling Unit structure from the Shipment
   CURSOR get_empty_hu_in_structure IS
     SELECT handling_unit_id
       FROM HANDLING_UNIT_EXTENDED
      WHERE shipment_id = shipment_id_
        AND Shipment_Line_Handl_Unit_API.Get_Sub_Struct_Connected_Qty(shipment_id, handling_unit_id) = 0
    CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
      START WITH     handling_unit_id = handling_unit_id_
      ORDER BY structure_level;
      
   handling_unit_tab_   Handling_Unit_API.Handling_Unit_Id_Tab;
   local_shipment_id_   NUMBER;
BEGIN
   IF (handling_unit_id_ IS NULL) THEN
      OPEN get_all_empty_handling_units;
      FETCH get_all_empty_handling_units BULK COLLECT INTO handling_unit_tab_;
      CLOSE get_all_empty_handling_units;
   ELSE
      OPEN get_empty_hu_in_structure;
      FETCH get_empty_hu_in_structure BULK COLLECT INTO handling_unit_tab_;
      CLOSE get_empty_hu_in_structure;
   END IF;
   
   IF (handling_unit_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      FOR i IN handling_unit_tab_.FIRST .. handling_unit_tab_.LAST LOOP
         -- The shipment id needs to be fetched within the loop since the id could have been removed
         -- by a previous iteration in the loop (on a parent handling unit).
         local_shipment_id_ := Handling_Unit_API.Get_Shipment_Id(handling_unit_tab_(i).handling_unit_id);
         IF (local_shipment_id_ IS NOT NULL) THEN
            Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_         => handling_unit_tab_(i).handling_unit_id, 
                                                             parent_handling_unit_id_  => NULL);
            Handling_Unit_API.Modify_Shipment_Id(handling_unit_id_ => handling_unit_tab_(i).handling_unit_id, 
                                                 shipment_id_      => NULL);
         END IF;
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Disconnect_Empty_Hu_On_Ship;


@UncheckedAccess
FUNCTION Is_Qty_Left_To_Attach (
   shipment_id_ IN NUMBER ) RETURN BOOLEAN
IS
   shipment_qty_                   NUMBER;
   reserved_qty_                   NUMBER;
   reserved_qty_left_to_attach_    NUMBER;   
   qty_left_to_attach_             BOOLEAN := FALSE;
BEGIN  
   shipment_qty_ := Shipment_Line_Handl_Unit_API.Get_Shipment_Qty_For_Inv_Parts(shipment_id_);
   reserved_qty_ := Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment(shipment_id_);
   
   reserved_qty_left_to_attach_ := shipment_qty_ - reserved_qty_;
   IF (reserved_qty_left_to_attach_ > 0) THEN
      qty_left_to_attach_:= TRUE ;
   END IF;
   
   RETURN qty_left_to_attach_;
   
END Is_Qty_Left_To_Attach;


FUNCTION Get_Total_Qty_Shipped (  
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS   
   qty_shipped_        NUMBER;
   
   CURSOR get_qty_shipped IS
      SELECT SUM(qty_shipped)
        FROM shipment_line_pub
       WHERE source_ref1 = source_ref1_
         AND (source_ref2_ IS NULL OR source_ref2 = source_ref2_)
         AND (source_ref3_ IS NULL OR source_ref3 = source_ref3_)
         AND (source_ref4_ IS NULL OR source_ref4 = source_ref4_)
         AND source_ref_type_db = source_ref_type_db_;
BEGIN  
   OPEN get_qty_shipped;
   FETCH get_qty_shipped INTO qty_shipped_;
   CLOSE get_qty_shipped;   
   
   RETURN nvl(qty_shipped_, 0);
END Get_Total_Qty_Shipped;
