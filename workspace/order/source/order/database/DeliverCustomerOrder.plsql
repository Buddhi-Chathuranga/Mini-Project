-----------------------------------------------------------------------------
--
--  Logical unit: DeliverCustomerOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  220125  ManWlk   MFZ-9807, Added dependent_demand_ parameter to Update_Ms_Forecast___(). Modified calling places to set dependent_demand_ parameter TRUE if the demand code is Distribution Order.
--  211220  KiSalk   Bug 161843(SC21R2-6439), Modified Issue_Delivered_Parts___ to pass the correct handling_unit_id_ to required methods instead of 0 assigned local_handling_unit_id_ within the loop and corrected qty_reserved_ 
--  211220           to be passed to Inventory_Part_In_Stock_API.Issue_Part when Handling Units involved.
--  211207  ThKrlk   Bug 161240 (SC21R2-6023), Moved the logic of Setting up receipt reference, from Connect_Ship_Deliv_Note() to Post_Deliver_Shipment().
--  211207           Modified Connect_Ship_Deliv_Note() by adding new condition to get_shipment_line cursor, to match the shipment with the delivery when multiple deliveries occurs.
--  210615  ApWilk   Bug 159527(SCZ-15205), Modified Issue_Delivered_Parts___() to stop creating a customer warranty when delivering a rental CO line. 
--  210614  ChFolk   SCZ-15164(159677), Modified Direct_Delivery_From_Pur_Order to rename the variables qty_to_invoice_ and total_qty_to_invoice_ as sales_qty_to_ship_ and total_sales_qty_to_ship_.
--  210607  NiDalk   Bug 159243(SCZ-14593), Modified Find_Deliveries___, Get_Consignment_Stock_Qty__ and Consume_Consignment_Stock___ to support deliveries made before APP8. 
--  210525  ChFolk   SCZ-14926(Bug 159236), Modified Issue_Delivered_Parts___ to exit from find_all_picklists loop when qty_to_deliver_ is fulfilled otherwise new_deliv_no_ sets with NULL unnecessarily.
--  210323  MaEelk   SC21R2-504, Added Get_Last_Cum_Delnote_Data to qty shipped and the last delivery date of a deliver note 
--  210323           of a given customer, ship addr no and a customer part no.
--  210303  Ambslk   MFZ-6915, Merged LCS bug 157803.
--  210303           210203  KaAulk   Bug 157803, [MFZ-6143] Modified New_Inv_Line_Delivery___() to update the approved quantity if any parts delivered 
--                                    and modified Deliver_Order_Inv_With_Diff___ to remove the code of update approved quantity as it covered from New_Inv_Line_Delivery___
--  201125  ErRalk   Bug 156297(SCZ-12527), Modified Create_Ord_Pre_Ship_Del_Note__ to set ship_addr_no of the delivery note only when CO line address is not single occurrence.
--  201016  RoJalk   Bug 146018(SCZ-11809), Modified procedures New_Non_Inv_Line_Delivery___() and Create_Outstanding_Sales() in order to create a new outstanding sales record when the 
--  201016           customer order line is created through a service order.
--  200727  BudKlk   Bug 154810(SCZ-10801), Modified Consume_Consignment_Stock___ and Get_Consignment_Stock_Qty__ methods in order to pass the expiration_date_ to get the correct sum quanitiy of the relevant parts which will satisfied all the conditions.
--  200713  JaThlk   Bug 151033(SCZ-7893), Modified Consume_Consignment_Stock___ in order to pass addr_no_ to the method call Customer_Consignment_Stock_API.Decrease_Consignment_Stock_Qty 
--  200713           and modified Find_Deliveries___ to find deliveries based on the delivery address from the delivery record instead of customer order line.
--  200706  WaSalk   Bug 151152(SCZ-8170), Modified Create_Outstanding_Sales() by adding transaction code PODIRSH-NI to the condition.
--  200512  MalLlk   GESPRING20-4424, Modified New_Non_Inv_Line_Delivery___() to pass shipment_id_ for Customer_Order_Delivery_API.New when delivery note number 
--  200512           is null and localization parameter 'NO_DELIVERY_NOTE_FOR_SERVICES' is true.
--  200504  BudKlk   Bug 153735(SCZ-9998), Modified the method Get_Consignment_Stock_Qty__() to get the quantity to consume related to a specific sales part and its relavent parameters and moved it to the private method block
--                   and modified the method Consume_Consignment_Stock__() to replace the method to get the consignment stock qty from Get_Consignment_Stock_Qty__() to retrive the correct values according to the sales part.
--  200304  BudKlk   Bug 152192(SCZ-8629), Modified Consume_Consignment_Stock___() and added new methods Find_Deliveries___(), Get_Consignment_Stock_Qty_() to add the common cursor to a public method to use the consignment stock qty in client side.
--  200226  ErFelk   Bug 152213(SCZ-8797), Modified Direct_Delivery_From_Pur_Order() by converting the total_qty_shipped_on_pur_ord_ in to Sales unit of measure, when assigning to total_qty_to_invoice.
--  191206  DhAplk   Bug 150387(SCZ-7777), Modified Create_Outstanding_Sales method to include COGS Posted date when supply code is Int Purch Dir.
--  191122  ChBnlk   Bug 150797(SCZ-7688), Modified Consume_Consignment_Stock___() to add NVL check to expiration_date_ in order to check the date properly
--  191122           when finding deliveries. Added new parameter aggregated_ to Consume_Consignment_Stock___() and Consume_Consignment_Stock__() methods.
--  191125  THKRLK   Bug 150915(SCZ-7763), Removed condition, pre_ship_invent_loc_no_ IS NOT NULL from Get_Actual_Del_Note_Ship_Date() to get the actual ship date instead wanted delivery date, 
--  191125           when it is a two stage picking customer order.
--  101015  KiSalk   Bug 150523(SCZ-7111), Changed parameter b2b_client_ of Consume_Consignment_Stock___ to VARCHAR2 from BOOLEAN.
--  190802  NiDalk   Bug 149058(SCZ-5668), Modified Consume_Consignment_Stock___ to support consignmet stock created before APP8. Set to ignore inventory_transaction_hist.source_ref5
--  190802           if it is not set.
--  190528  KiSalk   Bug 148475(SCZ-5184), Replaced obsolete customer order status 'CreditBlocked' with 'Blocked'.
--  190527  MaEelk   SCUXXW4-21736, Removed the global constant  date_last_calendar_date_ added from SCUXXW4-18796.
--  190513  LaThlk   SCUXXW4-18796, Modified procedures Consume_Consignment_Stock__() and Consume_Consignment_Stock___() by passing the expiration_date_ as default last calendar date.
--  190508  RasDlk   SCUXXW4-15857,15696,15695,18910, Added the method Fetch_Input_Units_To_Deliver to support Input UoM in Aurena client.
--  190506  WaSalk   Bug 147754(SCZ-4542), Added method Create_Delivery_Inv_Ref___() to create invoice referenc in cust_delivery_inv_ref_tab if stage billing invoices created before delivery.
--  190404  NiDalk   Bug 147716(SCZ-4191), Added RETURN statement to Pack_Deliv_Attr_To_Message___.
--  190102  RasDlk   SCUXXW4-4749, Added function Calculate_Totals() to support totals in CustomerOrderDeliveryNoteAnalysis Projection.
--  190102           customer order line is created through a service order.
--  181029  MaIklk   SCUXX-4745, Fixed a place to use the same description for CRBLKORD constant as in other places.
--  181021  BudKlk   Bug 144009, Modified the methods Modify_Order_Line_Cost() and New_Inv_Line_Delivery___() to avoid updating the customer order line cost for the transactions 'CO-DELV-OU', 'DELCONF-OU'.
--  180811  SBalLK   Bug 141519, Added Deliver_Order_With_Diff___(), Deliver_Order_With_Diff___() and Pack_Deliv_Attr_To_Message___() methods to handle CLOB type parameters.
--  180811           Deliver_Order_Inv_With_Diff___(), Deliver_Order_Non_With_Diff___() and Line_Already_Delivered___() methods to accept CLOB type parameters.
--  180811           Made Deliver_Order_With_Diff__() method as a function for invoke process from client with CLOB parameters.
--  180823  UdGnlk   Bug 141162, Modified Direct_Delivery_From_Pur_Order() include an error message to stop the direct delivery when the order line is delivered or invoiced. 
--  180823  ErRalk   Bug 143657, Modified Create_Outstanding_Sales method to include COGS Posted date when supply code is Purch Ord Dir.
--  180704  ErRalk   Bug 142834, Modified Deliver_Complete_Packages___ method to deliver package when backorder option is 'ALLOW INCOMPLETE LINES AND PACKAGES'.
--  180622  KiSalk   Bug 142629, Added parameter total_qty_shipped_on_pur_ord_ to Direct_Delivery_From_Pur_Order and used it(if not null) in the last batch processing.
--  180619  KiSalk   Bug 142607(SCZ-395), Modified New_Inv_Line_Delivery___ to reduce the over-picked quantity (qty_shipdiff) if delivered less than order qty.
--  180302  KHVESE   STRSC-17267, Modified method Issue_Delivered_Parts___.
--  180221  KHVESE   STRSC-16922, Modified methods Deliver_Order_Inv_With_Diff___, Deliver_Line_Inv_With_Diff___ and Deliver_List_Inv_Lines___.
--  180223  UdGnlk   Bug 139806, Modified Deliver_Line_Inv_With_Diff__() to check shipment line been removed.
--  180221  KHVESE   STRSC-17267, Modified method Issue_Delivered_Parts___.
--  180208  KHVESE   STRSC-16375, Modified method Deliver_List_Inv_Lines___ to be able to keep HU when site/customer setting is to keep HU at delivery.
--  180131  KHVESE   STRSC-16395, Modified method Deliver_Line_Inv_With_Diff___ to set and fetch inventory_event_id_ from Session
--  180125  KHVESE   STRSC-16212, Modified method Deliver_Order_Inv_With_Diff___ to fetch inventory_event_id_ from Session
--  180125  IzShlk   STRSC-15937, Modified Issue_Delivered_Parts___() to not to perform an inventory transaction if the quantity to deliver is 0.Also to remove reservation.
--  180117  AsZelk   Bug 139158, Modified New_Non_Inv_Line_Delivery___() in order to update export control license coverage quantity when a non-inventory part delivered.
--  171230  KhVese   STRSC-12028, Modified method Issue_Delivered_Parts___ to handle senarios that inventory part get seperated from HU.
--  171219  NaLrlk   STRSC-15140, Modified Deliver_Line_Inv_With_Diff___(), Send_Deliv_Data_To_Dist_Order() and Post_Deliver_Shipment() methods to support for HU's in shipment delivery when DO's connected.
--  171214  KHVESE   STRSC-9352, Added implementation method Consume_Consignment_Stock___ and modified method Consume_Consignment_Stock__ to call the implementation mehtod.
--  171211  DiKuLk   Bug 138072, Modified Get_Latest_Delnote_No() by adding order_no as an OUT parameter. This was done mainly to get the order no when a shipment is connected. 
--  171208  HASTSE   STRSA-23852, Adjustment of attributes sent for creating SM Object in Create_Sm_Object___
--  171110  UdGnlk   Bug 138257, Modified Deliver_Package_If_Complete___() calculation of qty_to_pick_ with conv_factor considering the brackets.
--  171110  KHVESE   STRSC-14208, Modified method Consume_Consignment_Stock__
--  171030  KHVESE   STRSC-9352, Added new parameters to the interface of method Consume_Consignment_Stock__ and modified the method to be able to report on detailed level.
--  171012  KiSalk   Bug 138238, Added Clear_Temp_Table_Deliv_No___ and parameter deliv_no_ to Fill_Temporary_Table___.
--  171012           Modified Deliver_Line_Inv_With_Diff___ to use one deliv_no when called in a loop in a same session.
--  171004  KHVESE   STRSC-9352, Modified method Consume_Consignment_Stock__ to consume on detailed level (per serial, lot batch, hu and etc) also modified method 
--                   Issue_Delivered_Parts___ to prevent start of warrany when order line delivered on customer consignment stock order.
--  170929  KiSalk   Bug 137980, Changed delnote_no_ parameter of Is_Schedule_Connected and Get_Sched_Latest_Delivery_Date to VARCHAR2 from NUMBER.
--  170911  TiRalk   STRSC-11807, Modified Direct_Delivery_From_Pur_Order by changing logic to create one delivery record for direct delivery serial part flow.
--  170706  KhVese   STRSC-10703, Modified Deliver_Line_Inv_With_Diff___ and Deliver_Order_Inv_With_Diff___ to unattache/keep Hu at CO delivery based on Site/Customer setting.
--  170705  KhVese   STRSC-9339, Modified Deliver_Line_Inv_With_Diff___ and Deliver_Order_Inv_With_Diff___ to unattach Hu at delivery with presumption of unattach handling unit.
--  170612  TiRalk   STRSC-5756, Modified Issue_Delivered_Parts___ to update the qty_to_deliver and catch_qty_to_deliver.
--  170425  NiFrSE   STRSA-23491, Modified the Create_Sm_Object___() method.
--  170410  NiFrSE   STRSA-21318, Checked the Source_Ref Handling to EquipmentStructureCost in Update_Sm_Object___().
--  170324  ApWilk   Bug 134489, Modified Modify_Order_Line_Cost() to stop updating the Component CO unit cost as Zero when the PO is directly delivered.
--  170316  MeAblk   Bug 134663, Added new parameter deliv_no_ into the method Direct_Delivery_From_Pur_Order() to consider tge deliv_no which was generated when creating the inventory transaction.
--  170314  MeAblk   Bug 134044, Added parameter cost_ into the method Create_Outstanding_Sales() and accordingly modified the relevant places.
--  170210  Jhalse   LIM-10150, Modified snapshot to use inventory event id and changed the handling of the result to a more generic way.
--  170201  Jhalse   LIM-10150, Added call to Change_Handling_Unit_Id in Issue_Delivered_Parts to make it easier to understand.
--  170131  MaEelk   LIM-10488, passed inventory_ivent_id_ to Customer_Order_Reservation_API.Remove
--  170123  Jhalse   LIM-10150, Modified Deliver_List_Inv_Lines___, Deliver_List_Non_Inv_Lines___, Deliver_Order_Inv_With_Diff___, Issue_Delivered_Parts___ 
--                   to handle delivering multi-level handling units and intersite delivery of handling units.
--  161108  JaRolk   STRSA-14490, Modified Create_Sm_Object___().
--  160922  UdGnlk   LIM-8848, Modified Deliver_Line_Inv_With_Diff___() by changing the position of INVENTORY_EVENT_ID.
--	 160902	Jhalse	LIM-7804, Testing of the inventory event id concept. Fixed ambiuguity regarding the inventory event id in Deliver_Order_Line_Inv_With_Diff.
--  160809  TiRalk   STRSC-2725, Deliver_Load_List__, Deliver_Load_List_With_Diff__, Deliver_Order_Inv_With_Diff__, Deliver_Order_Non_With_Diff__, Deliver_Line_Inv_With_Diff__
--  160809           Deliver_Line_Non_With_Diff__, Deliver_Order_Line__, Deliver_Order_With_Diff__, Deliver_Pre_Ship_Del_Note__ and Batch_Deliv_Pre_Ship_Del_Note
--  160729  RoJalk   LIM-7954, Added the method Pre_Deliver_Shipment.
--  160729  RoJalk   LIM-7954, Added the methods Deliver_Ship_Line_Non_Inv, Deliver_Ship_Line_Inv.
--  160729           Removed Deliver_Shipment__ and moved the logic to Shipment_API.Deliver_Shipment__.
--  160729  RoJalk   LIM-7954, Added the method Post_Deliver_Shipment to include order specific actions after shipment delivery.
--  160728  UdGnlk   LIM-7792, Modified Deliver_Order_Line__() to support inventory event logic.
--  160726  UdGnlk   LIM-7792, Modified Deliver_Line_Inv_With_Diff___(), Deliver_Package_Line___(), Deliver_Line_Inv_With_Diff__(),
--  160726           Deliver_Shipment__(), Deliver_Pre_Ship_Del_Note__() and Cancel_Deliver_Line__() to support inventory event logic.
--  160720  Chfose   LIM-7517, Added inventory_event_id to Deliver_List_Inv_Lines___, Deliver_Order_Inv_With_Diff___ & Issue_Delivered_Parts___
--                   to combine multiple calls to Customer_Order_Reservation_API/Inventory_Part_In_Stock_API within a single inventory_event_id.
--  160720  RoJalk   LIM-8034, Modified Send_Mul_Tier_Del_Notificat___, Direct_Delivery_From_Pur_Order to include handling_unit_id. 
--  160704  MaRalk   LIM-7671, Modified Conn_Order_To_Pre_Del_Note__ - get_line, Connect_Order_To_Deliv_Note - get_line and 
--  160704           Check_Del_Note_Addr_No - exist_control cursors to reflect column renaming in delivery_note_tab.
--  160629  TiRalk   STRSC-2702, Changed the places where it has used CreditBlocked from CustomerOrder has changed to state Blocked.
--  160623  SudJlk   STRSC-2698, Replaced Cust_Order_Line_Address_API.Public_Rec with Cust_Order_Line_Address_API.Co_Line_Addr_Rec and 
--  160623           Cust_Order_Line_Address_API.Get() with Cust_Order_Line_Address_API.Get_Co_Line_Addr()
--  160613  RoJalk   LIM-7680, Replaced Customer_Order_Transfer_API.Send_Dispatch_Advice with Dispatch_Advice_Utility_API.Send_Dispatch_Advice.
--  160608  MaIklk   LIM-7442, Fixed the usages of renaming Customer_Order_Deliv_Note to Delivery_Note.
--  160608           Also moved some order specific functions from Create_Delivery_Note_API and Delivery_Note_API.
--  160411  MaIklk   LIM-6957, Renamed Ship_Date to Planned_Ship_Date in Shipment_tab.
--  160309  MaRalk   LIM-5871, Modified Deliver_Shipment__ to reflect shipment_line_tab-sourece_ref4 data type change.
--  160309  RoJalk   LIM-4114, Called Shipment_API.Get_Distinct_Source_Ref1 from Get_Sched_Latest_Delivery_Date, 
--  160309           Is_Schedule_Connected, Get_Sched_Ord_Qty_Shipped.
--  160212  RoJalk   LIM-4115, Modified Deliver_Shipment__ and fetched all values from SHIPMENT_LINE_PUB in get_lines cursor.
--  150211  RoJalk   LIM-4116, Modified Deliver_Line_Non_With_Diff___ and used Shipment_Line_API.Get_Qty_To_Ship_By_Source.
--  150128  MaIklk   LIM-4150, Added source_ref_type condition for the where clauses in Deliver_Shipment__().
--  151202  RoJalk   LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202           SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151111  MaEelk   LIM-4453, Removed pallet_id from the code.
--  151110  MaIklk   LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151110  RoJalk   LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151105  MeAblk   Bug 125402, Modified Deliver_Package_If_Complete___() in order to correctly set the package hader cost when delivering.
--  151105  UdGnlk   LIM-3746, Removed Inventory_Part_Loc_Pallet_API method calls since INVENTORY_PART_LOC_PALLET_TAB will be obsolete. 
--  151009  Chfose   LIM-3771, Added missing handling_unit_id to Location_Already_Delivered___ and Fill_Temporary_Table___.
--  150710  Chfose   LIM-3749, Changed the incorrectly sent hu id from the attr to instead be the hu id from the reservation cursor instead in Deliver_Line_Inv_With_Diff___.
--  150709  IsSalk   KES-906, Added reference-by-name for the parameter list when calling the method Inventory_Part_In_Stock_API.Issue_Part().
--  150707  IsSalk   KES-905, Added reference-by-name for the parameter list when calling the method Inventory_Transaction_Hist_API.New().
--  150624  JaBalk   RED-495, Modified Issue_Delivered_Parts___ to exclude the part availability check for rental transfer.
--  150819  PrYaLK   Bug 121587, Modified Get_Cumulative_Shipped_Qty(), Get_Cum_Qty_After_Delnote_No() and Get_Line_Total_Qty_Delivered() by adding cust_part_invert_conv_fact
--  150819           to the SELECT list of the CURSORs get_cumulative_shipped_qty, get_cumulative_qty and get_lines respectively.
--  150723  PrYaLK   Bug 123113, Modified Get_Sched_Latest_Delivery_Date() to fetch the date_delivered_.
--  150608  IsSalk   KES-518, Passed new_deliv_no_ as a parameter when calling Inventory_Part_Loc_Pallet_API.Issue_Pallet().
--  150526  IsSalk   KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  150515  IsSalk   KES-409, Passed new parameter to Inventory_Transaction_Hist_API.Set_Alt_Source_Ref().
--  150512  IsSalk   KES-421, Passed new parameter to Inventory_Transaction_Hist_API.New().
--  150520  UdGnlk  LIM-1816, Modified method calls to include handling_unit_id_ into the logic.      
--  150423  Chfose  LIM-1781, Modified calls to Customer_Order_Reservation_API to include new parameter handling_unit_id.
--  150415  MaEelk  LIM-1067, Added dummy parameter handling_unit_id_ 0 to the method call Inventory_Part_In_Stock_API.Reserve_Part   
--  150415          and Inventory_Part_In_Stock_API.Issue_Part. 
--  150406  MaEelk  LIM-1067, Added dummy parameter handling_unit_id_ 0 to the method call Inventory_Part_In_Stock_API.Get_Expiration_Date. 
--  150406          handling_unit_id_ will be implemented as a key in InventoryPartInstock LU.
--  150223  MeAblk   PRSC-6194, Modified New_Non_Inv_Line_Delivery___ in order to update the line shipped qty after the inventory transaction have been created and before create delivery. 
--  150126  ShVese   PRSC-4778, Made the code to modify customer order line cost conditional and not execute in the delivery confirmation flow in New_Non_Inv_Line_Delivery___.
--  141218  RoJalk   PRSC-4387, Modified New_Non_Inv_Line_Delivery___ and removed the (qty_to_deliver_ > 0) check before calling Customer_Order_API.Set_Line_Qty_Shipped.
--  141125  KiSalk   Bug 119862, Changed variable type of sup_sm_object_ in Issue_Delivered_Parts___ to have 100 length.
--  141031  DilMlk   Bug 118191, Modified method - Create_Sm_Object___, reverted the fix of setting addr_1 to address1 under bug 56307.
--  141029  Chfose   Removed transition of info_ in Deliver_List_Inv_Lines___ and Deliver_List_Non_Inv_Lines___ and added a boolean line_removed_ instead 
--                   to make sure that only one info message regarding empty load list lines can appear.
--  141028  Chfose   Modified Deliver_List_Inv_Lines___ to make use of public interface for Remove in Cust_Order_Load_List_Line_API and added the same recent changes to Deliver_List_Non_Inv_Lines___.
--  141023  Chfose   Modified Deliver_List_Inv_Lines___ to remove Load List lines with qty of 0. Also added transition of info_ to be able to retrieve info when this happens.
--  140919  NaLrlk   Modified Is_Internal_Transit_Delivery to consider IPT_RO demand_code for replacement rental.
--  140730  RoJalk   Renamed Set_Mul_Tier_Del_Notificat___ to Send_Mul_Tier_Del_Notificat___.
--  140730  RoJalk   Modified session_id_ parameter to be NOT NULL in Customer_Order_Transfer_API.Send_Direct_Delivery.
--  140729  RoJalk   Restructure the code in Set_Mul_Tier_Del_Notificat___.
--  140724  RoJalk   Modified Set_Mul_Tier_Del_Notificat___, Direct_Delivery_From_Pur_Order to support delive_no.
--  140707  RoJalk   Modified Direct_Delivery_From_Pur_Order and called the new method Set_Mul_Tier_Del_Notificat___ to handle multi-tier delivery notification. 
--  140410  NWeelk   Bug 116249, Modified method Deliver_Package_If_Complete___ by removing multiplication from qty_per_assembly in the cursor get_total_cost.
--  140207  FAndSE   BI-3415: CURSOR get_packages_shipped in Deliver_Package_If_Complete___ modified. Conversion added since qty_shipped and qty_per_assembly are not in the same UoM. 
--  140123  IsSalk   Bug 114459, Modified method Direct_Delivery_From_Pur_Order() to update the qty_shipdiff_ when the shipped qty is greater than or equal to the ordered quantity.
--  130212  RoJalk   Modified Deliver_Line_Inv_With_Diff__ and changed shipment id to be default 0 parameter. Removed default NULL parameters from New_Non_Inv_Line_Delivery___ 
--  130212           Deliver_Line_Inv_With_Diff___ Deliver_Line_Non_With_Diff___.
--  131021  NaLrlk   Modified New_Non_Inv_Line_Delivery___() to handle transaction ownership for non inventory rentals.
--  131021  RoJalk   Corrected code indentation issues after merge.
--  130916  MAWILK   BLACK-566, Replaced Component_Pcm_SYS.
--  130911  AyAmlk   Bug 110181, Modified Modify_Cost_Of_Delivery() to update the cost in delivery tab correctly when there are multiple partial deliveries.
--  130830  HimRlk   Merged Bug 110133-PIV, Modified method Update_Sm_Object___, by changing Calculation logic of line discount amount to be consistent with discount postings.
--  130830           Calculations are done using order currency, then final values are converted to base currency. 
--  130730  RuLiLk   Bug 110133, Modified method Update_Sm_Object___, by changing Calculation logic of line discount amount to be consistent with discount postings.
--  130730           Calculations are done using order currency, then final values are converted to base currency. 
--  130710  ErFelk   Bug 111142, Corrected the method name in General_SYS.Init_Method of Update_Ms_Forecast___().
--  130705  UdGnlk   TIBE-991, Removed global varaiables and modify to conditional compilation. Moved global varaiables to methods. 
--  130627  ChJalk   EBALL-127, Modified Issue_Delivered_Parts___ to change the method call to update the dispatched qty in CRO exchange reservations to Cro_Exchange_Reservation_API.Update_Qty_Dispatched.
--  130619  Nuwklk   ONESA-600, Modified Deliver_Order_Inv_With_Diff___()
--  130613  AwWelk   EBALL-115, Modified Issue_Delivered_Parts___() to  trigger the CRO-EXD-OU transaction only for Company Owned parts.
--  130606  AwWelk   EBALL-112, Modified the condition check for 'CRO-EXD-OU' in Issue_Delivered_Parts___().
--  130605  ChJalk   EBALL-84, Modified Issue_Delivered_Parts___ to update the CRO exchange details.
--  130510  AwWelk   EBALL-67, Modified Modify_Order_Line_Cost() and Issue_Delivered_Parts___() to handle CRO-EXD-OU transaction.
--  130510  ChJalk   EBALL-65, Modified Issue_Delivered_Parts___ to add the transaction code for the customer order lines created from a Component Repair Exchange.
--  130507  Cpeilk   Bug 108603, Modified Deliver_Shipment__() to trigger event ORDER_DELIVERED_USING_SHIPMENT for delivered orders.
--  130430  Asawlk   EBALL-37, Modified Consume_Consignment_Stock__() to call Customer_Consignment_Stock_API.Decrease_Consignment_Stock_Qty() with new parameters.
--  130426  Asawlk   EBALL-37, Modified New_Inv_Line_Delivery___() by moving the call Customer_Consignment_Stock_API.Increase_Consignment_Stock_Qty()
--  130426           to Inventory_Part_In_Stock_API.Issue_Part().
--  130422  Darklk   Bug 99815, Modified the procedure Modify_Cost_Of_Delivery to update the delivery cost of a transaction. 
--  130417  JanWse   Bug 107258, Added parameter co_order_no_ to Send_Deliv_Data_To_Dist_Order and modified removing extra cursor to get count.
--  130408  Asawlk   EBALL-37, Modified methods New_Inv_Line_Delivery___() and Consume_Consignment_Stock__() to use the Increase_Consignment_Stock_Qty() and 
--  130408           Decrease_Consignment_Stock_Qty() methods from Customer_Consignment_Stock_API. 
--  130213  KiSalk   Bug 108242, Receipt and issue serial tracked parts check done with Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db.
--  120517  Darklk   Bug 99815, Modified the procedures New_Inv_Line_Delivery___, New_Non_Inv_Line_Delivery___, Deliver_Package_If_Complete___ and Direct_Delivery_From_Pur_Order
--  120517           to retrieve the exact cost amount when delivering the parts and changed the logic of modifying the CO line cost for non-inventory parts.
--  130222  CHRALK   Modified Issue_Delivered_Parts___(), by adding rental quantity validation.
--  130201  MaMalk   Added method Get_Catch_Qty_Shipped to get shipped catch qty for a shipment order line.
--  130104  RoJalk   Modified Deliver_Shipment__ to refer to qty_picked from  SHIPMENT_ORDER_LINE_TAB. 
--  121219  RoJalk   Removed Shipment_Order_Line_API.Modify_Qty_To_Ship/Modify_Qty_Shipped from  Deliver_Line_Non_With_Diff___ since it will be handled from Customer_Order_Delivery_APIInsert___.
--  121218  RoJalk   Modified the cursors in Deliver_Shipment__ to refer to qty's in SHIPMENT_ORDER_LINE_TAB. 
--  121211  MeAblk   Modified method Deliver_Line_Inv_With_Diff___ by removing the method call to Customer_Order_Line_API.Modify_Open_Shipment_Qty.  
--  121122  MeAblk   Modified method Deliver_Line_Inv_With_Diff___ in order to update the open shipment quantity in customer_order_line_tab for package component lines when doing deliveries.  
--  121120  MeAblk   Modified methods New_Non_Inv_Line_Delivery___, Deliver_Line_Non_With_Diff___ in order to handle the deliveries of the shipment connected non-inventory part line quantities. 
--  121116  RoJalk   Modified the parameter order of Deliver_Line_Inv_Diff. Modified Issue_Delivered_Parts___, Deliver_Line_Inv_With_Diff___, Deliver_Line_Inv_With_Diff___
--  121116           and passed a value for remove_ship_ to identify the situation where reservations needs to be transferred  when shipment line is deleted.  
--  121109  RoJalk   Modified Picked_Reservations_Exist__ and added the condition shipment_id = 0 considering current usage is only when not shipment connected.
--  121001  RoJalk   Allow connecting a customer order line to several shipment lines - Modified Issue_Delivered_Parts___, Deliver_Line_Inv_With_Diff___, Deliver_List_Inv_Lines___ 
--  121001           Deliver_Order_Inv_With_Diff___, New_Inv_Line_Delivery___ ,Modify_Qty_To_Deliver___ , Reset_Qty_To_Deliver___ Deliver_Package_Line___ ,Deliver_Line_Inv_With_Diff__,
--  121001           Deliver_Order_Line__, Deliver_Shipment__, Cancel_Deliver_Line__ Deliver_Pre_Ship_Del_Note__ Deliver_Line_Inv_Diff to handle shipment id.   
--  120927  MaMalk   Removed the obsolete method Get_Shipped_Qty_On_Shipment.
--  120409  GiSalk   Bug 102102, Modified Get_Sched_Latest_Delivery_Date() by removing the GROUP BY clause from the cursor get_dem_date_deliv,
--  120409           because the same attributes are in WHERE clause.
--  120404  NaLrlk   Modified Deliver_List_Inv_Lines___, Deliver_Order_Inv_With_Diff___, Deliver_Line_Inv_With_Diff___ to correct the demand_order_ref variable declarations.
--  120330  JuMalk   Bug 100910, Modified method Direct_Delivery_From_Pur_Order. Assigned qty_to_invoice_ to zero, for Non Charged Items.
--  120315  JuMalk   Bug 101695, Introduced method Get_Sched_Ord_Qty_Shipped to get the quantity shipped connected to a customer schedule, 
--  120315           method Is_Schedule_Connected to see whether a delivery has a customer schedule connection and method Get_Sched_Latest_Delivery_Date 
--  120315           to get the delivery date.  
--  120313  MaMalk   Bug 99430, Modified the code to consider inverted_conv_factor where conv_factor has been considered.
--  120116  KiSalk   Bug 100032, Removed attr_ parameter and Location_Already_Delivered___ was re-written using temporary table delivered_line_with_diff_tmp.
--  120116           Added Fill_Temporary_Table___ and called from Deliver_Line_Inv_With_Diff___ to save attribute values sent be client as chunks.
--  120116           Modified Deliver_Line_Inv_With_Diff___ to get  quantity to deliver from delivered_line_with_diff_tmp.
--  111216  NWeelk   Bug 100062, Modified method Direct_Delivery_From_Pur_Order by adding parameter qty_remaining_ and used qty_remaining_ and last_in_batch_ 
--  111216           to set qty_shipdiff_ when receiving more than the ordered quantity.
--  111209  ChFolk   Removed Generay_sys from Get_Latest_Delnote_No and added pragma.
--  111128  NipKlk   Bug 100076, Modified the length of the variable customer_no_ in the procedure Deliver_Shipment__  to VARCHAR(20).
--  111124  GiSalk   Bug 94416, Modified Deliver_Package_If_Complete___ by adding new_comp_after_delivery check to the WHERE clause of cursor get_packages_shipped
--  111124           and used qty_per_assembly instead of the calculation.
--  111123  SudJlk   Bug 99987, Modified Direct_Delivery_From_Pur_Order to update Master Schedule Forecast when direct delivery is done for parts with online consumption.
--  111101  NISMLK   SMA-289, Increased eng_chg_level length to STRING(6) in column comments.
--  111012  MoIflk   Bug 99314, Modified Consume_Consignment_Stock__ to calculate CO line cost correctly upon consignment stock consumption for partially delivered CO.
--  110913  SudJlk   Bug 98653, Modified Deliver_List_Inv_Lines___ to reflect length change in demand_order_ref1 in customer_order_line_tab.
--  110915  RoJalk   Modified New_Non_Inv_Line_Delivery___ to pass the activity sequence for the transaction when job costing is used. 
--  110731  Dobese   Changed Chemmate receiver to HSE receiver.
--  110701  AmPalk   Bug 93777, Modified Create_Sm_Object___. The Serial_Tracking_Code of the part can get modified after a CO line gets created. 
--  110701           Hence added a validation to check it and the create_sm_object_option, prior calling Equipment_Serial_Utility_API.Create_Object. 
--  110629  AmPalk   Bug 95350, Modified Deliver_List_Inv_Lines___ to inform Distribution Order that a delivery has been made.
--  110629           This will trigger the automatic receipt creation and rest of the process, if the Distribution Order has been set to do so.
--  110627  NWeelk   Bug 96500, Modified method Consume_Consignment_Stock__ to calculate CO line cost correctly upon consignment stock consumption.
--  110330  AndDse   BP-4760, Modified Issue_Delivered_Parts___ and Direct_Delivery_From_Pur_Order due to changes in Cust_Ord_Date_Calculation.
--  110317  AndDse   BP-4453, Modified Issue_Delivered_Parts___ and Direct_Delivery_From_Pur_Order to consider external transport calendar when calculating with delivery leadtime.
--  110128  ShVese   Replaced use of Part Catalog serial tracking_code with the receipt_issue_serial_track.
--  100929  NWeelk   Bug 93023, Modified method Deliver_Line_Inv_With_Diff__ to evaluate NULL values for remove_ship_.
--  100920  NWeelk   Bug 93023, Modified methods Deliver_Line_Inv_Diff and Deliver_Line_Inv_With_Diff__ by adding remove_ship_ to the parameter list
--  100920           and by adding remove_ship_ check before the method call Customer_Order_Flow_API.Credit_Check_Order.
--  100825  SaJjlk   Bug 92605, Added OUT parameter info_ to method Deliver_Line_Inv_With_Diff___ and added code in the method to collect info after calling New_Inv_Line_Delivery___.
--  100817  ChJalk   Bug 92303, Modified the methods Deliver_List_Inv_Lines___ and Deliver_List_Non_Inv_Lines___ to consider the orders with state 'CreditBlocked' when delivering 
--  100817           the load list. Modified the method Credit_Check_Load_List___ to correct the info message when there is a credit blocked order when delivering. Modified method 
--  100817           Deliver_Load_List___ to set the load list as delivered only if at least one line is delivered and modified the methods Deliver_Load_List__ and Deliver_Load_List_With_Diff__ 
--  100817           to deliver the order lines even if there are blocked orders exist.
--  100810  ChJalk   Bug 92303, Modified the methods Deliver_List_Inv_Lines___, Deliver_List_Non_Inv_Lines___ and Credit_Check_Load_List___ 
--  100810           to avoid orders in Planned state to deliver and check against credit check. 
--  100725  NWeelk   Bug 92011, Modified Issue_Delivered_Parts___ by changing a condition to check the transaction DELCONF-OU as well  
--  100725           to prevent creating S/M objects when using 'Delay Cost of Sold Goods to Delivery Confirmation' in the CO.
--  100602  RaKalk   Bug 91032, Modified Deliver_Package_Line___ procedure to deliver only picked component lines lines.
--  100520  KRPELK   Merge Rose Method Documentation.
--  100512  MaMalk   Bug 90002, Modified method Deliver_Line_Inv_With_Diff___ to filter the reservation records by the delnote_no.
--  100427  NWeelk   Bug 90016, Added parameter airway_bill_no_ to method calls to Customer_Order_Delivery_API.New and
--  100427           added parameter airway_bill_no_ to method Direct_Delivery_From_Pur_Order.
--  100422  NWeelk   Bug 90111, Modified method Consume_Consignment_Stock__ by changing the cursor find_deliveries to select records
--  100422           with addr_no equal to ship_addr_no of the CUSTOMER_ORDER_DELIVERY_TAB and added parameter ship_addr_no_ to 
--  100422           method calls to Customer_Order_Delivery_API.New. 
--  100420  MaRalk   Modified reference by name method call to Inventory_Transaction_Hist_API.Create_And_Account within
--  100420           Consume_Consignment_Stock__ method.
--  100104  SaJjlk   Bug 88091, Modified method Deliver_Order_Inv_With_Diff___ and changed the declaration of Dist_Order_Line_Rec.
--  091218  SaWjlk   Bug 87371, Replaced the 'do_attr_' attribute string with a PL/SQL table in the procedure Deliver_Order_Inv_With_Diff___.
--  091216  SudJlk   Bug 87166, Modified method Issue_Delivered_Parts___ to create correct transaction when delivering CO created from DO.
--  090930  MaMalk   Modified Issue_Delivered_Parts___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  090922  ChJalk   Bug 85951, Modified Issue_Delivered_Parts___ to get the customer_contract from Customer_Order_Line level in all the places. 
--  090922           For the customer orders created from internal purchase orders, the customer contract is taken from Purchase_Order_Line level.
--  090804  NWeelk   Bug 84811, Modified Issue_Delivered_Parts___ to get the correct value for catch_qty_shipped and 
--  090804           added parameter catch_qty_shipped_ to the method call Modify_On_Delivery__.
--  090626  DaGulk   Bug 84232, Modified the variable length of media_code_ to VARCHAR2(30) in method Deliver_Shipment__.
--  090604  HoInlk   Bug 82024, Modified Send_Deliv_Data_To_Dist_Order to send eng_chg_level as TRANSIT_ENG_CHG_LEVEL.
--  090603  DaGulk   Bug 83173, Modified the error message in method New_Inv_Line_Delivery___.
--  090527  SuJalk   Bug 83173, Modified the error constant to RESEXISTSPICK in method New_Inv_Line_Delivery___ to make it unique.
--  090522  AmPalk   Bug 82723, Removed Modify__ calls of Customer_Order_Reservation_API in Modify_Qty_To_Deliver___. Private methods only suppose to use as interfaces to client not in business logic.
--  090525  SudJlk   Bug 81907, Removed the code block that sets ownership of delivered serial parts for transaction OESHIP in Issue_Delivered_Parts___.
--  090512  AmPalk   Bug 82723, Modify Modify_Qty_To_Deliver___ by removing use of CUSTOMER_ORDER_RESERVATION view. 
--  090512           The DeliverCustomerOrder.apy runs prior CustomerOrderReservation.apy accordingly to the deploy.ini.
--  090324  SuJalk   Bug 79875, Added method Batch_Deliv_Pre_Ship_Del_Note.
--  081231  MaMalk   Bug 70877, Modified methods Reset_Qty_To_Deliver___, Ready_Non_Inv_Lines_On_List__ and Ready_Inv_Lines_On_List__ to use tables instead of views.
--  081230  ChJalk   Bug 70877, Added columns qty_to_deliver and catch_qty_to_deliver to VIEW. Added methods Deliver_Load_List___,
--  081230           Deliver_List_Inv_Lines___, Deliver_List_Non_Inv_Lines___, Get_Tot_Qty_To_Deliver, Get_Tot_Catch_Qty_To_Deliver,  
--  081230           Modify_Qty_To_Deliver___, Modify_Qty_To_Deliver_, Reset_Qty_To_Deliver__ and Reset_Qty_To_Deliver___. 
--  081230           Modified methods Deliver_Load_List__ and Deliver_Load_List_With_Diff__. 
--  081230           Removed methods Deliver_List_Inv_With_Diff___ and Deliver_List_Non_With_Diff___. 
--  081230           Modified the Where condition in the cursor to consider the COL load_id column in the methods Deliver_Order_Inv_With_Diff___,
--  081230           Deliver_Order_Non_With_Diff___, Deliver_Line_Non_With_Diff___, Ready_Inv_Lines_On_List__, Ready_Inv_Lines_On_Order__, 
--  081230           Ready_Non_Inv_Lines_On_List__ and Ready_Non_Inv_Lines_On_Order__.
--  081125  SuJalk   Bug 78711, Modified the IF condition in Issue_Delivered_Parts___ to check the qty to deliver against total assigned qty instead of the qty to assigned per picklist.
--  080714  SaJjlk   Bug 75495, Modified method Send_Deliv_Data_To_Dist_Order to send EXPIRATION_DATE in the message.
--  080623  SaJjlk   Bug 72602, Modified method Issue_Delivered_Parts___ to set the expiration date in reservation table when issuing parts.
--  090603  NaLrlk   Added function Get_Line_Qty_Delivered, Get_Line_Total_Qty_Delivered and Get_Line_Qty_Remaining.
--  080516  SuJalk   Bug 73033, Modified the Issue_Delivered_Parts___ method to raise an error message if the quantity to ship is greater than the quantity assigned for shipment inventory
--  080516  KaEllk   Bug 73810, Modified New_Non_Inv_Line_Delivery___ to set the shipped qty after the Inventory transaction is created..
--  080203  LaBolk   Bug 69512, Modified method Issue_Delivered_Parts___ to raise errors PURCHLINECANCELLED and PURSHIPCONNECTED,
--  080203           even for inter-site orders in different companies.
--  080123  LEPESE   Bug 68763, Removed method Get_Demand_Order_Keys___ and replaced it's usage
--  080123           with calls to Customer_Order_Line_API.Get_Demand_Order_Info.
--  080108  SaJjlk   Bug 69557, Added parameter delivery_note_ref_ to method calls to Customer_Order_Delivery_API.New and
--  080108           added parameters delivery_no_ and delivery_note_ref_ to method Direct_Delivery_From_Pur_Order.
--  071227  CwIclk   Bug 69991, Modified Method New_Inv_Line_Delivery___ to add new if condition before update MS forecast.
--  071128  LaBolk   Bug 67546, Added parameter last_in_batch_  and removed DEFAULT NULL from serial_no_ in Direct_Delivery_From_Pur_Order.
--  071127  MaRalk   Bug 66013, Modified method New_Non_Inv_Line_Delivery___ in order to pass NULL 
--  071127           for project id and activity sequence, if the supply_code is 'Non Inventory'.
--  071116  ChJalk   Bug 69187, Modified Method Issue_Delivered_Parts___ to change the error message when a shipment has been created.
--  071015  NaLrlk   Bug 67691, Added check on if qty_shipped_ != 0 in Modify_Order_Line_Cost.
--  070903  MiKulk   Bug 67163, Modified the method Confirmed_Deliv_Return_Allowed in order to consider the shipped quantity instead of 
--  070903           qty_to_invoice, in the calculation to decide whether to allow to do the returning of goods. 
--  070705  VIGALK   Bug 65090, Added parameter planned_due_date_ to Update_Ms_Forecast___, also in call to
--                   Update_Ms_Forecast___ from New_Inv_Line_Delivery___.
--  070620  Cpeilk   Added an info message about credit blocked in methods Deliver_Order_Inv_With_Diff__, Deliver_Order_Non_With_Diff__,
--  070620           Deliver_Line_Inv_With_Diff__, Deliver_Line_Non_With_Diff__, Deliver_Order_With_Diff__, Deliver_Order_Line__,
--  070620           Deliver_Load_List__, Deliver_Load_List_With_Diff__ and Deliver_Pre_Ship_Del_Note__.
--  070504  WaJalk   Bug 64895 - Fix in New_Inv_Line_Delivery___, in call to Update_Ms_Forecast___. No check needed
--                   if online consumption flag checked in INVENT.
--  070503  DaZase   Added more qty conversions in Send_Deliv_Data_To_Dist_Order since the shipped qty should be in purch uom.
--  070423  DaZase   Added qty conversion in method Send_Deliv_Data_To_Dist_Order.
--  070328  SuSalk   LCS Merge 63028, Modified Deliver_Shipment__ to send delivery note for orders with IPD lines.
--  070315  MaMalk   Bug 62968, Modified Get_Cum_Qty_After_Delnote_No() to calculate the quantity correctly, when delivery note is null.
--  070309  MaJalk   Added call Customer_Order_Deliv_Note_API.Set_Pre_Ship_Delivery_Made() to Deliver_Pre_Ship_Del_Note__().
--  070305  MaJalk   Added new method Deliver_Pre_Ship_Del_Note__ and added delnote_no_ parameter to few methods and modified.
--  070116  KaDilk   LCS Merge 58965, Modified Direct_Delivery_From_Pur_Order to check if connection table entry exists before modifying it.
--  070109  DaZase   Changed usage of catch_unit_code from part catalog record so it now is fetched from Inventory_Part_API.Get_Catch_Unit_Meas instead.
--  070104  NiDalk   Added method Deliver_Package_Line___ and modified Deliver_Order_Line__ to deliver package lines.
--  070102  ChBalk   Made Modify_Order_Line_Cost___ public and modified according to the sales overhead changes.
--  060908  Cpeilk   Added new methods Cancel_Deliver_Order__, Cancel_Deliver_Line__ and Cancel_Deliver_Load_List__.
--  060908           Added new paramether cancel_delivery_ and modified methods Deliver_Order_Inv_With_Diff___, Deliver_Line_Inv_With_Diff___,
--  060908           Deliver_List_Inv_With_Diff___, Deliver_Order_Non_With_Diff___, Deliver_Line_Non_With_Diff___, and Deliver_List_Non_With_Diff___.
--  060906  RoJalk   Modifications to the Deliver_Order_With_Diff__ parameters.
--  060831  KanGlk   Added new procedure Deliver_Order_With_Diff__.
--  060831  Cpeilk   Added new method Credit_Check_Load_List___ and modified methods Deliver_Load_List__ and Deliver_Load_List_With_Diff__.
--  060824  RaKalk   Implemented the credit check for the order on delivery.
--  060824           Modified Deliver_Order__, Deliver_Order_Inv_With_Diff__, Deliver_Order_Non_With_Diff__
--  060824           Deliver_Line_Inv_With_Diff__, Deliver_Line_Non_With_Diff__, Deliver_Order_Line__, Deliver_Shipment__
--  060531  KanGlk   Bug 56825, Added check against Purchase Order Line status in Issue_Delivered_Parts___.
--  060531           If internal POL is Cancelled the internal COL may only be delivered with differences - qty 0.
--  060524  MiKulk  Changed the coding to remove LU dependancies.
--  060517  MiErlk   Enlarge Identity - Changed view comment
--  060503  MaRalk   Bug 56011, Modified New_Inv_Line_Delivery___, New_Non_Inv_Line_Delivery___, Direct_Delivery_From_Pur_Order
--  060503           to remove Close Tolerance checks for the package components. Removed Bug correction 50560.
--  060425  NuFilk   Bug 56307, Modified Create_Sm_Object___ to adjust the odject address.
--  060419  NaLrlk  Enlarge Customer - Changed variable definitions
--  060410  IsWilk  Enlarge Identity - Changed view comments of customer_no.
--  ------------------------- 13.4.0 -----------------------------------------
--  060327  RaSilk   Added Catch Unit functionality to Deliver_List_Inv_With_Diff___.
--  060327  NuFilk   Modified method New_Inv_Line_Delivery___ to set qty_assigned and qty_picked according to reservations.
--  060321  JoAnSe   Removed restrictions for 'PURSHIP', 'CO-PURSHIP', 'EXCH-SHIP', 'CO-EX-SHIP'
--  060321           in Modify_Cost_Of_Delivery
--  060124  LEPESE   Modifications in method Consume_Consignment_Stock__ to get cost details on
--  060124           the inventory transaction CO-CONSUME.
--  060124  JaJalk   Added Assert safe annotation.
--  060106  JaBalk   Passed order_type_db value to Inventory_transaction_hist_API.Get_Wip_Cost.
--  060102  PrPrlk   Bug 54547, Made changes to the method Issue_Delivered_Parts___ to prevent delivering of internal order lines
--  060102           containing package parts when both demand and supply site belong to the same company.
--  051109  JoAnSe   Added handling for 'CO-SHIPDIR', 'CO-SHIPTRN' in Modify_Order_Line_Cost___
--  051027  PrPrlk   Bug 54155, Made changes in the method Get_Cum_Qty_After_Delnote_No () to check the availability of the delnote no.
--  051027  DAYJLK   Bug 53604, Modified Modify_Order_Line_Cost___ to handle transaction codes PURDIR and INTPURDIR.
--  051013  Asawlk   Bug 53826, Modified Modify_Order_Line_Cost___ inorder to calculate new_cost_ correctly.
--  051007  GaSolk   Bug 53712, Made Deliver_Package_If_Complete__ method public.
--  051007           Also added parentheses for the computation of qty_shipped in CUSTOMER_ORDER_DELIVERY_LOV view
--  051007           and CUSTOMER_ORDER_DELIVERY_CS view in order to make sure delta can be extracted using Delta Engine.
--  050929  DaZase   Added configuration_id/activity_seq in calls to Inventory_Part_Loc_Pallet_API methods.
--  050923  DaZase   Removed REF to InventoryPartLocation and added a REF to InventoryPartInStock instead.
--  050922  RaKalk   Modified Issue_Delivered_Parts___ to fetch the actual transaction code once the parts are delivered.
--  050920  NaLrlk   Removed unused variables.
--  050901  AnLaSe   Added TRUNC when fetching consume_date in Consume_Consignment_Stock__.
--  050825  DaZase   Added activity_seq and project_id to cursor get_line_attributes in method New_Non_Inv_Line_Delivery___ and also to the call to Inventory_Transaction_Hist_API.New in this method.
--  050816  AnLaSe   Added call to Customer_Order_Delivery_API.Modify_Delivery_Confirmed in Consume_Consignment_Stock__.
--  050811  AnLaSe   Added NVL in Confirmed_Deliv_Return_Allowed.
--  050720  KanGlk   Modified Update_Sm_Object___ PROCEDURE. Change the pkg name Equipment_Object_Cost_API -> Equipment_Structure_Cost_API to call the method Update_Cost_Revenue().
--  050708  SaLalk   Bug 52317, Modified the IF condition of Deliver_Order_Line__ to call Deliver_Line_Non_With_Diff___ when parts are non inventory.
--  050531  IsWilk   Removed the warranty from PROCEDURE Create_Sm_Object___.
--  050517  JoEd     Changed Confirmed_Deliv_Return_Allowed to use qty_to_invoice (qty_confirmed) instead of qty_shipped.
--  050510  ThGulk   Bug 50560, Modified 'New_Inv_Line_Delivery___', added If condition to check sales parts.
--  050504  JoEd     Added restriction in New_Non_Inv_Line_Delivery___ to not book a transaction
--                   for non-inventory parts when COGS is posted at delivery confirmation.
--  050429  Asawlk   Bug 49377, Modifed Issue_Delivered_Parts___ inorder to set alternative source reference information.
--  050429           Modified Modify_Order_Line_Cost___, added new parameters when calling Inventory_Transaction_Hist_API.Get_Sum_Value_Order_Line.
--  050415  JoEd     Added default transaction to Deliver_Package_If_Complete___ to know whether
--                   or not outstanding sales record will be created - primarily used to distinguish between
--                   regular deliveries and direct deliveries.
--  050411  SaJjlk   Modified Direct_Delivery_From_Pur_Order to give an error when catch qty is negative.
--  050406  JoEd     Added method Create_Outstanding_Sales___.
--  050404  DaZase   Added method Confirmed_Deliv_Return_Allowed.
--  050331  SaJjlk   Minor modification for catch quantity calculations in Deliver_Line_Inv_With_Diff___.
--  050328  PrPrlk   Bug 49003, Made changes to the method New_Inv_Line_Delivery___ to check for existing reservations and present the user with an appropriate information message and
--  050328           made changes to method Deliver_Package_If_Complete___ to cheack for existing reservations for component parts and present the user with a appropriate
--  050328           info message if reservations exist for a component part, else to update their qty ship diff. Made changes to procdure Deliver_Order__ and Deliver_Order_Line__.
--  050322  AnLaSe   SCJP625: Added DELCONF-OU in Issue_Delivered_Parts___ and Modify_Order_Line_Cost___.
--  050321  GeKalk   Modified methods Deliver_Order_Inv_With_Diff___ and Send_Deliv_Data_To_Dist for DO receipts.
--  050316  LaBolk   Bug 48763, Modified Direct_Delivery_From_Pur_Order to update qty_on_order in connection table.
--  050224  NuFilk   Modified method Deliver_Order_Inv_With_Diff___ and Deliver_Order_Non_With_Diff___ to exclude shipment connected order lines.
--  050221  MiKulk   Bug 49584, Modified the Create_Sm_Object___ by removing some logic of handling addresses.
--  050216  GeKalk   Added a new method Deliver_Order_Line method to call Deliver_Order_Line__ from outside the module.
--  050214  GeKalk   Modified Deliver_Line_Inv_With_Diff___ to change the state of correct Distribution Order.
--  050131  NuFilk   Modified method Deliver_Shipment__ to consider non-inventory parts also.
--  050117  UsRalk   Changed references to Shipment_API.Get_Customer_No to Shipment_API.Get_Deliver_To_Customer_No.
--  050113  GeKalk   Modified a method Get_Shipped_Qty_On_Shipment.
--  050111  GeKalk   Added a new method Get_Shipped_Qty_On_Shipment.
--  041230  IsAnlk   Removed consignment functionality from Customer Orders. Modified New_Inv_Line_Delivery___.
--  041217  ChJalk   Bug 47792, Modifeid Update_Sm_Object___ to consider Additional Discount in calculting total_base_amount_ .
--  041210  SaJjlk   Removed view SBI_DELIVERY_NOT_INVOICED, SBI_QUANTITY_DEVIATIONS and moved them to OrderSelfBillingManager.apy
--  041123  IsAnlk   Modified Issue_Delivered_Parts___ to handle catch_aty correctly when Shipment Inventory is used.
--  041119  GeKalk   Added a new parameter catch_qty_shipped_on_pur_ord_ to Direct_Delivery_From_Pur_Order and added a new method Get_Catch_Qty_Shipped.
--  041117  SaJjlk   Renamed method Get_Input_Unit_Info_To_Deliver to Get_Input_Units_To_Deliver__.
--  041116  SaJjlk   Added method Get_Input_Unit_Info_To_Deliver and removed input unit columns from view DELIVER_CUSTOMER_ORDER.
--  041112  IsAnlk   Called Pick_Customer_Order_API.Recalc_Catch_Price_Conv_Factor in Direct_Delivery_From_Pur_Order.
--  041110  IsAnlk   Removed error message from New_Inv_Line_Delivery___ ,Deliver_Order_Inv_With_Diff___.
--  041109  HaPulk   Changed method call Get_Condition_Code.
--  041109  IsAnlk   Modified New_Inv_Line_Delivery___ to update price conv factor.
--  041108  IsAnlk   Modified Deliver_Line_Inv_With_Diff___ to handle catch_unit functionality.
--  041102  IsAnlk   Added IN OUT parameter in Issue_Delivered_Parts___. Modified Inventory_Part_In_Stock_API.Issue_Part call by adding catch_quantity_.
--  041101  SeJalk   Bug 47200, Added OUT paramerter info_ to Deliver_Order_Inv_With_Diff__, Deliver_Line_Inv_With_Diff__, Deliver_Load_List_With_Diff__,Deliver_Order_Inv_With_Diff___
--  041101           and Deliver_List_Inv_With_Diff___. Added info message in New_Inv_Line_Delivery___ if the inventory location is shipment and there are remaining reservations.
--  041029  IsAnlk   Added public function Get_Catch_Qty_To_Deliver.
--  041028  IsAnlk   Added catch_qty parameter to Issue_Delivered_Parts___, New_Inv_Line_Delivery___.
--  041027  DaZase   Added activity_seq to view and methods Deliver_List_Inv_With_Diff___, Deliver_Order_Inv_With_Diff___,
--                   Deliver_Line_Inv_With_Diff___, Issue_Delivered_Parts___ and Picked_Reservations_Exist__.
--  041020  IsAnlk   Modified Issue_Delivered_Parts___.
--  041014  SaJjlk   Added parameter catch_quantity_ to method calls Inventory_Part_In_Stock_API.Reserve_Part.
--  040929  DaZaSe   Project Inventory: Added zero-parameter to calls to different Customer_Order_Reservation_API methods,
--                   the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  040920  HeWelk   Added catch_quantity as null to Inventory_Transaction_Hist_API.New().
--  040901  SaJjlk   Modified Deliver_Order_Inv_With_Diff___ to handle Input UoM.
--  040826  GeKalk   Modified Deliver_Order_Inv_With_Diff___ to handle the exceptions of DO call.
--  040825  SAMELK   Removed the static calls to PurchaseOrderLine API.
--  040825  DaRulk   Removed DEFAULT NULL input uom parameters. Instead assign the values inside the code.
--  040824  DAYJLK   Call ID 116770, Removed parameter cost_ and added transaction_code_ to Direct_Delivery_From_Pur_Order
--  040824           and modified calculation of CO Line cost. Modified Modify_Order_Line_Cost___ to handle direct delivery transactions.
--  040817  GeKalk   Modified Deliver_Order_Inv_With_Diff___ to handle delivery with automatic receipt of distribution order.
--  040813  IsWilk   Modified the FUNCTION Is_Internal_Transit_Delivery to reverse the modification of Bug 43183.
--  040812  DaRulk   Modified Deliver_Line_Inv_With_Diff___, Issue_Delivered_Parts___ to include input uom parameters.
--  040806  GeKalk   Modified Deliver_Order_Inv_With_Diff___ to call Distribution order methods.
--  040804  GeKalk   Modified Send_Deliv_Data_To_Dist_Order and change the parameters of tha method.
--  040803  GeKalk   Modified Deliver_Order_Inv_With_Diff___ to call Distribution order methods.
--  040801  GeKalk   Modified Deliver_Line_Inv_With_Diff___ to call Distribution order methods and added a new method
--  040701           Send_Delivery_Data_To_Dist_Order automate the receipt process.
--  040629  NuFilk   Modified Direct_Delivery_From_Pur_Order to consider delivery_leadtime from CO Line when calculating warranty dates,
--  040629           prevented creation of SM Object for demand code IPT and for INTPODIRIM transaction. Modified Issue_Delivered_Parts___
--  040629           to exclude creation of SM object for SHIPDIR and added new parameter values to calls Issue_Part and Issue_Pallet.
--  040609  SaRalk   Bug 44952, Modified procedure Deliver_Order_Inv_With_Diff___ to handle any number of edited rows.
--  040518  DaZaSe   Project Inventory: Added zero/null-parameters to call Inventory_Transaction_Hist_API.New,
--                   change these parameters to real Activity_Seq and Project_Id values if this functionality uses Project Inventory.
--  040512  JaJalk   Corrected the lead time lables.
--  040510  GaJalk   Bug 44042, Modified the procedure Issue_Delivered_Parts___.
--  040510  DaZaSe   Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods,
--                   the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  040503  CaRase   Bug 43183, Add check of Delivery Type Internal Direct in function Is_Internal_Transit_Delivery,
--  ***********************************Touch Down Merge End*********************************************************************************************
--  040218  JoAnSe   DI04 Added new method Modify_Cost_Of_Delivery
--  ***********************************Touch Down Merge Begin*******************************************************************************************
--  040220  IsWilk   Modified the SUBSTRB to SUBSTR for Unicode Changes.
--  040202  Castse   Bug 42359, Added a check if several pick lists exist for the CO line in New_Inv_Line_Delivery___ .
--  040129  GeKalk   Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  040116  ChIwlk   Bug 41595, Modified procedure New_Inv_Line_Delivery___ to adjust the quantity on consignemnts when delivering with differences.
--  ********************* VSHSB Merge End  *************************************************************************************************************
--  021122  GeKaLk   Call Id 91659, Rearange the where statement of the SBI_QUANTITY_DEVIATIONS.
--  021107  GeKaLk   Rearange the where statement of the SBI_QUANTITY_DEVIATIONS.
--  021106  PrInLk   Added public method Deliver_Line_Inv_Diff as a public interface to the method Deliver_Line_Inv_With_Diff__.
--  021024  GeKaLk   Moved SBI_DELIVERY_NOT_INVOICED and SBI_QUANTITY_DEVIATIONS from SelfBillingItem LU.
--  021021  PrInLk   Modify the method Deliver_Shipment__ to set the ship_date in the shipment when it is null.
--  020513  MaGu     Added automatic sending of dispatch advice in method Deliver_Shipment__.
--  020412  MaGu     Added method Deliver_Shipment__.
--  ********************* VSHSB Merge ******************************************************************************************************************
--  --------------------13.3.0--------------------------------------------------------------------------------------------------------------------------
--  031104  NuFilk   LCS 37855, Added Method Is_Internal_Transit_Delivery.
--  031031  SaNalk   Modified procedure Issue_Delivered_Parts___ for Returning of MRO serial.
--  031020  ChBalk   Bug fixed LCS #39564, Changed condition 'internal_delivery_type' to demand_code in Issue_delivery_parts___.
--  031019  OsAllk   Modifed the method call Part_Serial_Catalog_API.Set_Serial_Ownership to fetch the correct owner depending on the ownership.
--  031014  SaRalk   Bug 37763, Modified procedure Deliver_Line_Inv_With_Diff___.
--  031013  DAYJLK   Call Id 105252, Modified Issue_Delivered_Parts___ to exclude calculation of serial warranty dates when order line is
--  031013           for externally owned stock or if it originates from an external service order or if it is for an exchanged item.
--  031013  OsAllk   Modified the method  Modify_Order_Line_Cost___.
--  031007  NuFilk   Modified the method call Part_Serial_Catalog_API.Set_Serial_Ownership and the conditions to it in Issue_Delivered_Parts___.
--  031006  OsAllk   Modified the method Modify_Order_Line_Cost___ to set the value of the total cost for the exchange order line.
--  031002  JaJalk   Added the owner for the method call Part_Serial_Catalog_API.Set_Serial_Ownership ini Issue_Delivered_Parts___.
--  031001  ChBalk   Applied LCS Bug 39564, Modified Issue_Delivered_Parts___ and changed the condition when create SM_Object.
--  030926  Asawlk   Applied LCS Bug 39571, Removed the correction of 36804, and modified the condition in method Deliver_Complete_Packages___.
--  030916  Prjalk   Bug 37655, Modified Procedure Issue_Delivered_Parts___ to avoid merging warrenties if qty_to_deliver_=0.
--  030829  JoAnSe   Replaced call to Inventory_Part_Unit_Cost.Get_Inventory_Value_By_Method with
--                   Get_Invent_Value_By_Condition in Consume_Consignment_Stock__.
--  030730  UdGnlk   Performed SP4 Merge.
--  030724  GeKalk   Modified Deliver_Order_Inv_With_Diff___ and Deliver_Line_Inv_With_Diff___ to
--                   set serial_no and lot_batch_no to NULL when those values equal to *.
--  030724  GeKalk   Done code review in Deliver_Order_Inv_With_Diff___ and Deliver_Line_Inv_With_Diff___.
--  030722  MaEelk   Added Part_Serial_Catalog_API.Set_Serial_Ownership in Issue_Delivered_Parts___.
--  030624  AnJplk   Modified procedure Issue_Delivered_Parts___.
--  030617  GeKalk   Modified methods Deliver_Order_Inv_With_Diff___ and Deliver_Line_Inv_With_Diff___
--  030617           to modify exchange part infomation after shipping the part.
--  030616  AnJplk   Modified procedure Issue_Delivered_Parts___.
--  030521  PrTilk   Changed PROCEDURE New_Inv_Line_Delivery___.
--  030513  JaBalk   Bug 37130, Added an error message CLOSETHELINE in New_Inv_Line_Delivery___ to restrict the user to deliver the
--  030513           qunatity with zero and close option is ticked if anything is not delivered before.
--  030422  ThPalk   Bug 36804, Added a condition to the method Deliver_Complete_Packages___ to check whether package part has components before deliver it.
--  030206  GaJalk   Bug 35434, Removed the check when qty_to_deliver_ is zero and line is not closed inside procedure New_Non_Inv_Line_Delivery___.
--  030131  ArAmlk   Call ID 93450 - Set value 'CONSIGNMENT' for location_group in call to
--                   Inventory_Transaction_Hist_API.New from Consume_Consignment_Stock__.
--  ------------------------------------- TakeOff --------------------------------------------------------------------------------------------------------------
--  021212  Asawlk   Merged bug fixes in 2002-3 SP3
--  021111  SaRalk   Bug 32842, Modified PROCEDURE New_Non_Inv_Line_Delivery___.
--  021031  LEPESE   Bug 32465, Added value 'CONSIGNMENT' for location_group in call to
--                   Inventory_Transaction_Hist_API.New from Consume_Consignment_Stock__.
--  021022  SaRalk   Bug 32842, Modified PROCEDURE New_Non_Inv_Line_Delivery___.
--  021010  SaRalk   Bug 32842, Rolled back the changes of bug 32842.
--  020930  SaRalk   Bug 32842, Modified PROCEDURE New_Non_Inv_Line_Delivery___.
--  020917  JoAnSe   Merged the IceAge bugg corrections below onto the AD 2002-3 track.
--  020904  LEPESE   Bug 31992, added logic for INTSHIP-NI to method New_Non_Inv_Line_Delivery___.
--  020701  NaMolk   Bug 31045, Modify the PROCEDURE Create_Sm_Object___ to concatenate the customer
--  020701           address according to the request made by the Manufacturing Solutions product team.
--  ------------------------------------- IceAge Merge End -----------------------------------------------------------------------------------------------------
--  020816  ANLASE   Replaced Inventory_Part_Config_API.Get_Inventory_Value_By_Method with
--                   Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method.
--  020522  SuAmlk   Changed VIEW COMMENTS in the view DELIVER_CUSTOMER_ORDER.
--  ------------------------------ AD 2002-3 Baseline ----------------------------------------------------------------------------------------------------------
--  020325  JoAn     Call Id 80346 Changed New_Inv_Line_Delivery___.
--                   Call to Modify_Order_Line_Cost___ only made qty_delivered_ > 0.
--  020226  CaSt     Bug Fix 27846, Removed deliv_no_ as in-parameter in several procedures.
--  020206  IsWilk   Bug Fix 27243, Modify the PROCEDURE Create_Sm_Object___ to fetch the correct address of Customer.
--  020108  Samnlk   Bug Fix 27004 , Modify PROCEDURE Issue_Delivered_Parts___ ,Change the checking for Create_Sm_Object___.
--  011005  CaSt     Bug Fix 22917, Modified the calculation of new_packages_shipped_ if only components are
--                   delivered in Deliver_Package_If_Complete___.
--  011005  IsWilk   Bug Fix 24798, Modified the PROCEDURE New_Non_Inv_Line_Delivery___.
--  011003  CaSt     Bug fix 22917, Added deliv_no_ as in-parameter in several procedures to be able to set
--                   component_invoice_flag for the correct delivery line.
--  010911  JSAnse   Bug fix 23965, removed '(ordrec_.internal_po_no IS NOT NULL) AND' from an IF-statement in Procedure Issue_Delivered_Parts__.
--  010823  CaSt     Bug Fix 22917, Status problems with package parts. Added procedures Check_Package_Status___,
--                   Mark_Component_For_Invoice___ and Close_Package_Header___ to be able to handle component lines
--                   being closed after Report picking with differences. Check_Package_Status___ is called from
--                   Deliver_Package_If_Complete___.
--  010709  SaNalk   Bug Fix 21071, Changed the str_code of transaction 'SHIPDIR' from M10 to M4 in Procedure 'Modify_order_line_cost__'.
--  010517  JaBa     Bug Fix 21575, assign a null value to deliv_no if the qty_shipped_from_location_ <=0 in Issue_Delivered_Parts___.
--  010514  JaBa     Bug Fix 21575,Call the Customer_Order_Delivery_API.Get_Next_Deliv_No after the
--                   comment Store all lines that are changed in the lineattr in the methods
--                   Deliver_Order_Inv_With_Diff___,Deliver_List_Inv_With_Diff___.
--  010413  JaBa     Bug Fix 20598,Added Boolean global lu constants to check for installed logical units.
--  010306  LeIsse   Bug fix 19111, Changed IF to ELSIF in Deliver_Package_If_Complete___.
--  010124  JoEd     Bug fix 19054. Modifed the cursor find_deliveries in order to
--                   fetch only the Consignment handled orders in Consume_Consignment_Stock__.
--  010124  JoEd     Bug fix 19115. Added use of close tolerance in New_Non_Inv_Line_Delivery___.
--  010123  JoEd     Bug fix 19215. Increased length for variable location_attr_
--                   in Delivery_Line_Inv_With_Diff___.
--  010111  JoAn     Bug Id 19006 Cost not retrived from Sales Part when delivering 'SEO' lines.
--                   Corrected in New_Non_Inv_Line_Delivery___
--  001130  CaSt     Removed price conversion factor from calculation of new_packages_to_invoice_ in
--                   Deliver_Package_If_Complete___.
--  001114  JoEd     Changed term for calculating warranties for serial number parts
--                   in Issue_Delivered_Parts___.
--  001106  JoAn     Changed the format of the message sent in Send_Hse_Msg_On_Delivery___.
--  001103  JoAn     Corrected the If statment controlling if HSE message should be sent.
--  001102  JakH     Added Confguration_Id to view, changed calls to Inventory_Transaction_Hist_API to
--                   use method New (and sending cfg id) instead of Inventory_Transaction
--  001101  JoEd     Added merge between customer order line's warranties and
--                   part serial catalog's warranties in Issue_Delivered_Parts___.
--  001031  JoEd     Added warranty date calculation in Issue_Delivered_Parts___.
--  001031  JoAn     Added Send_Hse_Msg_On_Delivery___ called when a new delivery has been made for a
--                   part with the HSEContract attribute set in Part Catalog.
--  001020  JakH     Issue_Delivered_Parts___ modified to take care of configuration_id when
--                   calling Customer_Order_Reservation
--  000929  MaGu     Bug fix 15894,  Added cursor get_component_rowstate and check if any of the component
--                   lines is delivered with differences and closed in Deliver_Package_If_Complete___.
--  000912  JoEd     Added deliv_no_ to Issue_Delivered_Parts___ and
--                   New_Inv_Line_Delivery___.
--  --------------   ---- 13.0 -----------------------------------------------------------------------------------------------------------------------------------
--  000615  JoAn     Bug fix 16527 Reversed the changes made for bug fix 15894.
--  000607  JoEd     Bug fix 15849, Added parameter cost_ to Direct_Delivery_From_Pur_Order
--                   and added call to Customer_Order_Line_API.Modify_Cost in the same method.
--  000522  MaGu     Bug fix 15894, Removed min in cursor get_packages_shipped and added FOR LOOP
--                   in Deliver_Package_If_Complete___
--  000425  PaLj     Changed check for installed logical units. A check is made when API is instantiatet.
--                   See beginning of api-file.
--  000419  PaLj     Corrected Init_Method Errors
--  000323  MaGu     Added procedure To_Order_Flow_When_Delivered__.
--  000228  DaZa     Bug fix 14963, fix in Create_Sm_Object___  so we fetch address from
--                   Cust_Order_Line_Address_API.Get.
--  000217  DaZa     Added new attributes (LINE_NO, REL_NO, LINE_ITEM_NO, SUP_SM_CONTRACT, SUP_SM_OBJECT)
--                   in method Create_Sm_Object___. Added new method Update_Sm_Object___.
--  000209  PaLj     Changed procedure Deliver_Package_If_Complete___ to support staged billing.
--  000207  JoAn     Added Get_Part_Shipments_All_Orders.
--  000203  PaLj     Changed procedure Update_Qty_In_Scheduling___.
--  000201  PaLj     Added procedure Update_Qty_In_Scheduling___.
--  000114  DaZa     Bug fix 12659, Added call to Modify_Cost in New_Non_Inv_Line_Delivery___.
--  000113  PaLj     Changed functions New_Inv_Line_Delivery and New_Non_Inv_Line_Delivery
--                   to support staged billing.
--  --------------   ---- 12.0 ------------------------------------------------------------------------------------------------------------------------------------
--  991111  JoEd     Changed datatype length on company_ variables.
--  991109  JakH     CID 27562 Made some adaptions for rma (and corrections) to  Consign_Stock_Return_Allowed
--  991014  PaLj     Bug fix 11304, Added check on new_qty_shipped_ in New_Inv_Line_Delivery___.
--  990831  JoAn     Changed Update_Ms_Forecast___ method in order to comply with new 11.1 interface.
--  990526  JoEd     Changed use of ship_addr_no to fetch from order line instead
--                   of header.
--  990519  JoAn     CID 17324 Changed the order of statements in New_Inv_Line_Delivery___
--                   Modify_Order_Line_Cost___ is done first to avoid problems
--                   updating Invoiced order lines.
--  990517  JakH     CID 16595: Added Modify_Order_Line_Cost___ and Get_Demand_Order_Keys___
--                   to be able to correctly update the cost on the order line when
--                   inventory parts are fetched from multiple locations.
--  990510  RaKU     Replaced Inventory_Part_Cost_API.Get_Total_Cost with
--                   Inventory_Part_API.Get_Inventory_Value_By_Method.
--  990510  RaKu     Added procedure Consign_Stock_Return_Allowed.
--  990427  PaLj     Y. Added order by in Deliver_Order_Inv_With_Diff to prevent deadlock
--  990421  JoAn     Passing client values in call to Customer_Order_Delivery_API.New
--  990420  JoAn     Corrected Deliver_Order_Inv_With_Diff___
--  990414  PaLj     YOSHIMURA - New Template and Performance changes
--  990406  JakH     Y.CID 10582 Removed use of Gen_Def_Key_value. use '*' where possible.
--  990326  JoAn     CID 12693 PURSHIP transaction booked on the purchase order in
--                   Issue_delivered_Parts___
--  990325  RaKu     Replaced Customer_Order_API.Get_Customer_No with direct cursor-fetch.
--  990323  JoAn     CID 12381 Conversion factors applied on quantities returned
--                   from functions called by Customer Scheduling. Added join
--                   with CUSTOMER_ORDER_LINE in some cursors to increase performance.
--  990312  JoAn     CID 11922 Corrected cursor in Sum_Qty_Btwn_Delnote_And_Date
--  990304  RaKu     Fixed error in Consume_Consignment_Stock__. Changed a plus-sign to
--                   a minus in "remaining qty_consumed_"-calculation.
--  990219  JoAn     CID 9302 passing part_no instead of catalog_no when calling
--                   Inventory_Transaction for 'CO-CONSUME'
--  990205  JoAn     Replaced call to Inventory_Transaction_Hist_API.Do_Booking
--                   with Inventory_Transaction_Hist_API.Do_Transaction_Booking
--  990202  JoAn     Retriving company from Site instead of Customer_Order_Line in
--                   Create_Sm_Object__.
--  990201  CAST     Modified calculations involving qty_to_invoice and qty_invoiced. Conv-factors were wrong.
--                   (qty_to_invoice and qty_invoiced are stored in sales unit).
--  990127  PaLj     Small changes in Ready_Non_Inv_Lines_On_Order__, Deliver_Order_Non_With_Diff__
--                   and New_Non_Inv_Line_Delivery__
--  990118  PaLj     changed sysdate to Site_API.Get_Site_Date(contract)
--  990115  JakH     Added procedure Create_Sm_Object__.
--  981214  JoAn     Added condition for objstate to cursor in Get_Cum_Qty_After_Delnote_No
--  981214  RaKu     Modifyed in Consume_Consignment_Stock__.
--  981211  RaKu     Finished Consignmnet Stock logic by adding missing
--                   Inventory-Transactions. Changes in Issue_Delivered_Parts___,
--                   New_Inv_Line_Delivery___ and Consume_Consignment_Stock__.
--  981207  JoEd     Changed view comments for qty_... columns.
--  981204  RaKu     Replaced function with objstate in Any_Delivery_Note_Printed__.
--  981125  RaKu     Modifyed all attributes using qty_to_invoice and qty_invoiced
--                   in CustomerOrderDelivery. Conv-factors was wrong.
--  981104  JoAn     Corrected Sum_Qty_Btwn_Delnote_And_Date.
--  981023  CAST     Added charge/nocharge functionality.
--  981016  CAST     Added logic for automatic closure of order lines (close_tolerance).
--  980918  RaKu     Added check in Consume_Consignment_Stock__ if consignment_stock
--                   is active. Only then an EventServer-event should be generated.
--                   Removed obsolete parameters in call to Customer_Order_Delivery_API.New.
--  980915  RaKu     Modifyed Consume_Consignment_Stock__.
--  980910  RaKu     Added Consignment Stock-logic in several procedures.
--                   Added procedure Consume_Consignment_Stock__.
--  980720  JOHW     Reconstruction of inventory location key
--  960618  JoAn     Modified cursors in Sum_Qty_Btwn_Denote_And_Date
--                   wanted_delivery_date used instead of date_entered.
--  980617  JoAn     Added method Sum_Qty_Btwn_Denote_And_Date needed by CS.
--  980428  JoAn     SID 3748 Cost not updated on delivery of an order line.
--                   Corrected in Issue_Delivered_Parts___.
--  980421  JoAn     SID 3090 Added check if internal order is within the same
--                   company in Issue_Delivered_Parts___
--  980414  LEPE     Corrected calls to issue reserved pallet from inventory.
--  980409  RaKu     Changed lineattr_ from VARCHAR(2000) to VARCHAR(32000).
--  980409  JoAn     SID 1649 Real ship date set whenever a delivery has been made.
--  980406  JoAn     SID 3085, 3087 Corrected inventory transactions for internal orders.
--                   Changes in Issue_Delivered_Parts___.
--  980325  JoAn     Replaced catalog_no with customer_part_no in Get_Latest_Delnote_No
--                   Get_Cum_Qty_After_Delnote_No and Get_Cumulative_Shipped_Qty
--  980317  JoAn     Added Update_Ms_Forecast___ called when a delivery has been made
--                   for an inventory part.
--  980227  JoAn     Removed Process_Internal_Orders___, this method should now be replaced
--                   with the EDI/MHS message DESADV.
--  980224  JoAn     Added parameter receipt_date to Direct_Delivery_From_Pur_Order and
--                   Deliver_Package_If_Complete___.
--  980223  ToOs     Corrected procedure Issue_Delivered_Parts___
--  980220  MNYS     Changed comparison with qty_to_ship to be qty_to_ship != 0 in cursor
--                   method Deliver_Order_Non_With_Diff___. Changed comparison with qty_to_deliver
--                   in method New_Non_Inv_Line_Delivery___. Changes made due to negative quantity.
--  980218  JoAn     Added view CUSTOMER_ORDER_DELIVERY_CS.
--  980211  RaKu     Added QTY_PICKED > 0 in VIEW-definition.
--                   Changed function Get_Latest_Delnote_No to procedure.
--  980209  JoAn     Bug 3002 Not possible to close order line when delivering 0 with differences.
--                   Removed check in procedure New_Inv_Line_Delivery___.
--  980205  RaKu     Added procedure Location_Already_Delivered___. Rewrote Deliver_Line_Inv_With_Diff__.
--  980202  RaKu     Added new view to handle deliveries without the picklist involved.
--                   Added functions Picked_Single_On_Order_Line__ and Picked_Pallets_On_Order_Line__.
--  980129  RaKu     Added functions Get_Cumulative_Shipped_Qty and Get_Latest_Delnote_No.
--  980127  RaKu     Added procedures Deliver_Line_Inv_With_Diff__, Deliver_Line_Non_With_Diff__
--                   Deliver_Order_Line__, Deliver_Line_Inv_With_Diff___ and Deliver_Line_Non_With_Diff___.
--  980113  MNYS     Added check on supply_code in Procedure New_Non_Inv_Line_Delivery___.
--  971215  RaKu     Bug 2587. Changes in New_Inv_Line_Delivery___. Reservations was not removed
--                   correctly when several picklists was created.
--  971201  JoAn     Bug 2373 Added condition objstate != 'Cancelled' to cursor
--                   in Deliver_Order_Non_With_Diff___
--  971125  RaKu     Changed to FND200 Templates.
--  971103  RaKu     Added check so a line can not be closed when nothing is delivered.
--  971006  JoAn     Changed Deliver_Package_If_Complete___ and added private interface to
--                   this method.
--  971002  JoAn     Added Direct_Delivery_From_Pur_Order.
--  970926  RaKu     Changed in New_Non_Inv_Line_Delivery___. Modify of Qty_Shipdiff was
--                   made before modify of qty_shipped -> Caused a statemachine-error.
--  970926  RaKu     Added functionality to update real_ship_date when delivering a non inventory line.
--  970623  RaKu     Added function Any_Delivery_Note_Printed__.
--  970612  RaKu     Changed so pallets are unreserved before issue in Issue_Delivered_Parts___.
--  970605  JoAn     Created delivery record for original order in Process_Internal_Orders___
--  970528  RaKu     Rewrote deliver function to clear reservations when
--                   a delivery with diff. is made and the inventory_type is not shipment
--                   inventory.
--  970527  RaKu     Changed functions Ready_Inv_Lines_On_Order__ and
--                   Ready_Non_Inv_Lines_On_Order__.
--  970522  RaKu     Added Issue_Pallet in procedure Issue_Delivered_Parts___.
--  970520  RaKu     Added function Picked_Reservations_Exist__.
--  970520  RaKu     Removed obsolete function Picked_Qty_Exist.
--  970517  RaKu     Rewrote deliver methods. Removed obsolete functions/procedures.
--                   Added all Ready...-functions.
--  970508  RaKu     Changed Mpccom_Company_API.Get_Home_Company ->
--                   Site_API.Get_Company(CONTRACT).
--                   Added function Pallets_Picked_On_Order__.
--  970507  JoAn     Modified Process_Internal_Orders___
--  970507  JoAn     Replaced call to Modify_Qty_To_Ship with Modify_Qty_To_Ship__
--  970429  JoAn     Reinserted public method Deliver_Complete_Packages.
--  970428  RaKu     Added pallet_id in calls to customer_order_reservation.
--  970428  RaKu     Rewrote some deliver methods.
--  970417  JoEd     Removed status_code from Customer_Order_Line_Hist_API.New.
--  970417  NABE     Added a new implementation Method to handle Internal orders
--                   in delivery Process_Internal_Orders___.
--  970407  RaKu     Added procedure Deliver_Load_List_With_Diff__.
--  970317  RaKu     Rewrote the delivery function to match the 10.3 release
--                   (handling loadlists). Not finished.
--  961209  JoAn     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Calculated_Weight_Volume_Totals_Rec IS RECORD (
   gross_total_weight   NUMBER,
   net_total_weight     NUMBER,
   total_volume         NUMBER);

TYPE Calculated_Weight_Volume_Totals_Arr IS TABLE OF Calculated_Weight_Volume_Totals_Rec;

TYPE Input_Uom_Rec IS RECORD (
   input_qty              NUMBER,
   input_unit_meas        VARCHAR2(30),
   input_conv_factor      NUMBER,
   input_variable_values  VARCHAR2(2000),
   multiple_picking       VARCHAR2(5));

TYPE Input_Uom_Arr IS TABLE OF Input_Uom_Rec;

TYPE Find_Deliveries_Rec IS RECORD
   (date_delivered           customer_order_delivery_tab.date_delivered%TYPE,
    deliv_no                 customer_order_delivery_tab.deliv_no%TYPE,
    delivery_qty_to_invoice  customer_order_delivery_tab.qty_to_invoice%TYPE,
    conv_factor              customer_order_line_tab.conv_factor%TYPE,
    inverted_conv_factor     customer_order_line_tab.inverted_conv_factor%TYPE,
    order_no                 customer_order_delivery_tab.order_no%TYPE,
    line_no                  customer_order_delivery_tab.line_no%TYPE,
    rel_no                   customer_order_delivery_tab.rel_no%TYPE,
    line_item_no             customer_order_delivery_tab.line_item_no%TYPE,
    source_ref5              inventory_transaction_hist_pub.source_ref5%TYPE,
    configuration_id         customer_order_line_tab.configuration_id%TYPE,
    handling_unit_id         inventory_transaction_hist_pub.handling_unit_id%TYPE,
    lot_batch_no             inventory_transaction_hist_pub.lot_batch_no%TYPE,
    serial_no                inventory_transaction_hist_pub.serial_no%TYPE,
    waiv_dev_rej_no          inventory_transaction_hist_pub.waiv_dev_rej_no%TYPE,
    eng_chg_level            inventory_transaction_hist_pub.eng_chg_level%TYPE,
    activity_seq             inventory_transaction_hist_pub.activity_seq%TYPE,
    expiration_date          inventory_transaction_hist_pub.expiration_date%TYPE);
    
    
TYPE Find_Deliveries_Tab IS TABLE OF Find_Deliveries_Rec
INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_               CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

TYPE delivered_line_info IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Package_Status___
--   Check if the package header should be closed after closing a package
--   component line
PROCEDURE Check_Package_Status___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2 )
IS
   found_ NUMBER := 0;

   CURSOR undelivered IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    line_item_no > 0
      AND    rowstate NOT IN ('Cancelled', 'Delivered', 'Invoiced');
BEGIN
   OPEN undelivered;
   FETCH undelivered INTO found_;
   IF (undelivered%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE undelivered;

   IF (found_ = 0) THEN
      -- All components in the package have either been delivered or cancelled
      -- The package header should be closed
      Close_Package_Header___(order_no_, line_no_, rel_no_);
   END IF;
END Check_Package_Status___;


-- Mark_Component_For_Invoice___
--   Called when an order is closed. Sets the component_invoice_flag for
--   all deliveries for the component in CustomerOrderDelivery in order
--   to force invoicing of the component.
PROCEDURE Mark_Component_For_Invoice___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   CURSOR get_deliveries IS
      SELECT deliv_no
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    cancelled_delivery = 'FALSE';
BEGIN
   FOR delivery_rec_ IN get_deliveries LOOP
      -- Set the component_invoice_flag for the delivery record in order to force invoicing.
      Customer_Order_Delivery_API.Modify_Component_Invoice_Flag
         (delivery_rec_.deliv_no, Invoice_Package_Component_API.Decode('Y'));
   END LOOP;
END Mark_Component_For_Invoice___;


-- Close_Package_Header___
--   Close a package header row
PROCEDURE Close_Package_Header___ (
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2,
   rel_no_   IN VARCHAR2 )
IS
   pkg_revised_qty_due_ customer_order_line_tab.revised_qty_due%TYPE;
   qty_shipdiff_        customer_order_line_tab.qty_shipdiff%TYPE;
   no_of_packages_      NUMBER;
   close_pkg_header_    VARCHAR2(1) := 'N';

   CURSOR no_of_packages(pkg_revised_qty_due_ NUMBER) IS
      SELECT MIN(TRUNC((qty_picked + qty_shipped) * pkg_revised_qty_due_ / revised_qty_due)) no_of_packages
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      AND    rowstate != 'Cancelled';

   CURSOR get_components(pkg_revised_qty_due_ NUMBER,
                         no_of_packages_      NUMBER) IS
      SELECT line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      AND    rowstate != 'Cancelled'
      AND    (qty_picked + qty_shipped) * pkg_revised_qty_due_  > no_of_packages_ * revised_qty_due;
BEGIN
   pkg_revised_qty_due_ := Customer_Order_Line_API.Get_Revised_Qty_Due(order_no_, line_no_, rel_no_, -1);

   OPEN no_of_packages(pkg_revised_qty_due_);
   FETCH no_of_packages INTO no_of_packages_;
   CLOSE no_of_packages;

   FOR comp_rec_ IN get_components(pkg_revised_qty_due_, no_of_packages_) LOOP
      Mark_Component_For_Invoice___(order_no_, line_no_, rel_no_, comp_rec_.line_item_no);
      close_pkg_header_ := 'Y';
   END LOOP;

   -- Set qty_shipdiff on the package header
   qty_shipdiff_ := no_of_packages_ - pkg_revised_qty_due_;

   Customer_Order_API.Set_Line_Qty_Shipdiff(order_no_, line_no_, rel_no_, -1, qty_shipdiff_);

   -- At least one component line has been delivered with differences and closed.
   IF close_pkg_header_ = 'Y' THEN

      Customer_Order_Line_Hist_API.New
         (order_no_, line_no_, rel_no_, -1,
         Language_SYS.Translate_Constant(lu_name_, 'MANCLOSE2: The line was manually closed'));
   END IF;
END Close_Package_Header___;


-- Deliver_List_Inv_Lines___
--   Deliver all inventory lines(single) for an load list.
--   When deliv_load_list_diff_ = TRUE then deliver with differences will made.
--   Otherwise will made normal delivery.
--   When close_ = TRUE then the line will be closed after delivery.
PROCEDURE Deliver_List_Inv_Lines___ (
   line_removed_         IN OUT BOOLEAN,
   info_                 OUT    VARCHAR2,
   load_id_              IN     NUMBER,
   deliv_load_list_diff_ IN     BOOLEAN,
   cancel_delivery_      IN     VARCHAR2 )
IS
   line_rec_                Customer_Order_Line_API.Public_Rec;
   close_                   BOOLEAN := FALSE;
   transaction_             VARCHAR2(10);
   g_info_                  VARCHAR2(32000) := '';
   deliv_no_                NUMBER;
   line_catch_qty_to_deliv_ NUMBER := 0;
   line_qty_to_deliver_     NUMBER := 0;
   qty_to_deliver_          NUMBER;
   catch_qty_to_deliver_    NUMBER;
   input_qty_               CUSTOMER_ORDER_RESERVATION_TAB.input_qty%TYPE:= NULL;
   input_conv_factor_       CUSTOMER_ORDER_RESERVATION_TAB.input_conv_factor%TYPE:= NULL;
   input_unit_meas_         CUSTOMER_ORDER_RESERVATION_TAB.input_unit_meas%TYPE:= NULL;
   input_variable_values_   CUSTOMER_ORDER_RESERVATION_TAB.input_variable_values%TYPE:= NULL;
   demand_order_ref1_       CUSTOMER_ORDER_LINE_TAB.demand_order_ref1%TYPE;
   demand_order_ref2_       CUSTOMER_ORDER_LINE_TAB.demand_order_ref2%TYPE;
   demand_order_ref3_       CUSTOMER_ORDER_LINE_TAB.demand_order_ref3%TYPE;
   demand_order_ref4_       CUSTOMER_ORDER_LINE_TAB.demand_order_ref4%TYPE;
   inventory_event_id_      NUMBER := NULL;
   unattach_handling_unit_  BOOLEAN := TRUE;
   hu_at_co_delivery_       VARCHAR2(20);
   
   CURSOR find_all_inventory IS
      SELECT lll.order_no, lll.line_no, lll.rel_no, 
             lll.line_item_no, lll.close_line
      FROM   CUST_ORDER_LOAD_LIST_TAB ll,
             CUST_ORDER_LOAD_LIST_LINE_TAB lll,
             CUSTOMER_ORDER_LINE_TAB col,
             CUSTOMER_ORDER_TAB co
      WHERE  ll.load_id = load_id_
      AND    ll.load_list_state = 'NOTDEL'
      AND    lll.load_id = ll.load_id
      AND    lll.order_no = col.order_no
      AND    lll.line_no = col.line_no
      AND    lll.rel_no = col.rel_no
      AND    lll.line_item_no = col.line_item_no
      AND    lll.line_item_no >= 0
      AND    col.qty_picked > 0
      AND    co.order_no = col.order_no
      AND    co.rowstate NOT IN ('Planned', 'Blocked');

   CURSOR get_all_reservations (contract_ IN VARCHAR2, part_no_ IN VARCHAR2,
                                order_no_ IN VARCHAR2, line_no_ IN VARCHAR2,
                                rel_no_ IN VARCHAR2, line_item_no_ IN NUMBER) IS
      SELECT location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
             SUM(qty_picked) qty_picked, SUM(catch_qty) catch_qty, SUM(input_qty) input_qty,
             SUM(qty_to_deliver) qty_to_deliver, SUM(catch_qty_to_deliver) catch_qty_to_deliver,
             input_unit_meas, input_conv_factor, input_variable_values, activity_seq, handling_unit_id
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    contract = contract_
      AND    part_no = part_no_
      AND    qty_picked > 0
      GROUP BY location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
               input_unit_meas, input_conv_factor, input_variable_values, activity_seq, handling_unit_id;

   CURSOR get_inv_reservations (order_no_ IN VARCHAR2, line_no_      IN VARCHAR2,
                                rel_no_   IN VARCHAR2, line_item_no_ IN NUMBER) IS
      SELECT  contract, part_no, configuration_id, location_no, lot_batch_no, serial_no,
              eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, qty_picked quantity
        FROM Deliver_Customer_Order
       WHERE order_no         = order_no_
         AND   line_no        = line_no_
         AND   rel_no         = rel_no_
         AND   line_item_no   = line_item_no_;
   
   inv_part_reservation_tab_     Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
BEGIN
   Trace_SYS.Message('Deliver with difference, all inventory parts');
   
   FOR next_ IN find_all_inventory LOOP
      line_qty_to_deliver_     := 0;
      line_catch_qty_to_deliv_ := 0;
      line_rec_                := Customer_Order_Line_API.Get(next_.order_no, 
                                                              next_.line_no, 
                                                              next_.rel_no, 
                                                              next_.line_item_no);
      deliv_no_                := Customer_Order_Delivery_API.Get_Next_Deliv_No;
      IF deliv_load_list_diff_ THEN
         close_ := (next_.close_line = 'TRUE');
      END IF;

      Inventory_Event_Manager_API.Start_Session;
      inventory_event_id_ := Inventory_Event_Manager_API.Get_Session_Id;
   
      hu_at_co_delivery_ := Cust_Ord_Customer_API.Get_Handl_Unit_At_Co_Delive_Db(line_rec_.deliver_to_customer_no);
      IF hu_at_co_delivery_ = Handl_Unit_At_Co_Delivery_API.DB_USE_SITE_DEFAULT THEN 
         unattach_handling_unit_ := (Site_Discom_Info_API.Get_Unattach_Hu_At_Delivery_Db(line_rec_.contract) = 'TRUE');
      ELSE 
         unattach_handling_unit_ := (hu_at_co_delivery_ = Handl_Unit_At_Co_Delivery_API.DB_UNATTACH);
      END IF;

      IF (NOT unattach_handling_unit_) THEN 
         OPEN get_inv_reservations(next_.order_no, 
                                   next_.line_no,
                                   next_.rel_no, 
                                   next_.line_item_no);
         FETCH get_inv_reservations BULK COLLECT INTO inv_part_reservation_tab_;
         CLOSE get_inv_reservations;
         Handl_Unit_Snapshot_Util_API.Generate_Snapshot(source_ref1_          => inventory_event_id_,
                                                        source_ref_type_db_   => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                        inv_part_stock_tab_   => inv_part_reservation_tab_);

      END IF;

      FOR res_ IN get_all_reservations (line_rec_.contract, 
                                        line_rec_.part_no, 
                                        next_.order_no, 
                                        next_.line_no,
                                        next_.rel_no, 
                                        next_.line_item_no) LOOP
         IF (cancel_delivery_ = 'TRUE') THEN
            qty_to_deliver_ := 0;
            IF (res_.catch_qty_to_deliver IS NOT NULL) THEN
               catch_qty_to_deliver_ := 0;
            END IF;
         ELSE
            IF (deliv_load_list_diff_) THEN
               qty_to_deliver_        := res_.qty_to_deliver;
               catch_qty_to_deliver_  := res_.catch_qty_to_deliver;

            ELSE
               qty_to_deliver_        := res_.qty_picked;
               catch_qty_to_deliver_  := res_.catch_qty;
               input_qty_             := res_.input_qty;
               input_conv_factor_     := res_.input_conv_factor;
               input_unit_meas_       := res_.input_unit_meas;
               input_variable_values_ := res_.input_variable_values;
            END IF;
         END IF;

         line_qty_to_deliver_     := line_qty_to_deliver_ + qty_to_deliver_;
         line_catch_qty_to_deliv_ := line_catch_qty_to_deliv_ + catch_qty_to_deliver_;

         Issue_Delivered_Parts___(transaction_, 
                                  catch_qty_to_deliver_, 
                                  next_.order_no, 
                                  next_.line_no, 
                                  next_.rel_no, 
                                  next_.line_item_no, 
                                  res_.location_no,
                                  res_.lot_batch_no, 
                                  res_.serial_no, 
                                  res_.eng_chg_level, 
                                  res_.waiv_dev_rej_no, 
                                  qty_to_deliver_, 
                                  deliv_no_,
                                  input_qty_, 
                                  input_unit_meas_, 
                                  input_conv_factor_, 
                                  input_variable_values_, 
                                  NVL(res_.activity_seq, 0),
                                  res_.handling_unit_id,
                                  0,
                                  'FALSE');
      END LOOP;

      New_Inv_Line_Delivery___(next_.order_no, 
                               next_.line_no, 
                               next_.rel_no, 
                               next_.line_item_no, 
                               load_id_, 
                               line_qty_to_deliver_, 
                               line_catch_qty_to_deliv_, 
                               close_, 
                               transaction_, 
                               deliv_no_,
                               NULL);

      g_info_ := g_info_ || Client_SYS.Get_All_Info;
      -- Modify package header if any package parts delivered
      Deliver_Complete_Packages___(next_.order_no, NULL);

      -- After a customer order delivery, this informs the DistributionOrder that a delivery has been performed.
      -- This is only done, if the customer order has been created from a distribution order.
      $IF (Component_Disord_SYS.INSTALLED) $THEN     
         IF (line_rec_.demand_code = 'DO' AND line_qty_to_deliver_ > 0) THEN
            Customer_Order_Line_API.Get_Demand_Order_Info (demand_order_ref1_ ,
                                                           demand_order_ref2_ ,
                                                           demand_order_ref3_ ,
                                                           demand_order_ref4_ ,
                                                           next_.order_no ,
                                                           next_.line_no  ,
                                                           next_.rel_no   ,
                                                           next_.line_item_no);
            Distribution_Order_API.Customer_Order_Delivered(demand_order_ref1_, deliv_no_);
         END IF;
      $END
        
      -- Remove the order line from the load list if there's nothing delivered from it.
      IF (line_qty_to_deliver_ = 0) THEN   
         Cust_Order_Load_List_Line_API.Remove(load_id_, 
               Cust_Order_Load_List_Line_API.Get_Pos(load_id_, 
                                                     next_.order_no, 
                                                     next_.line_no, 
                                                     next_.rel_no, 
                                                     next_.line_item_no));
          line_removed_ := TRUE;                                           
      END IF;
      Inventory_Event_Manager_API.Finish_Session;
      
   END LOOP;
   
   info_ := g_info_;
END Deliver_List_Inv_Lines___;


-- Deliver_List_Non_Inv_Lines___
--   Deliver all non inventory lines on load list.
--   When deliv_load_list_diff_ = TRUE then deliver with differences will made.
--   Otherwise will made normal delivery.
--   When close_ = TRUE then the line will be closed after delivery.
PROCEDURE Deliver_List_Non_Inv_Lines___ (
   line_removed_         IN OUT BOOLEAN,
   load_id_              IN     NUMBER,
   deliv_load_list_diff_ IN     BOOLEAN,
   cancel_delivery_      IN     VARCHAR2 )
IS
   qty_to_deliver_ NUMBER;
   close_          BOOLEAN := FALSE;

   CURSOR find_all_non_inventory IS
      SELECT lll.order_no, lll.line_no, lll.rel_no, lll.line_item_no, 
             lll.qty_to_deliver, lll.close_line, col.qty_to_ship
      FROM   CUST_ORDER_LOAD_LIST_TAB ll,
             CUST_ORDER_LOAD_LIST_LINE_TAB lll,
             CUSTOMER_ORDER_LINE_TAB col,
             CUSTOMER_ORDER_TAB co
      WHERE  ll.load_id = load_id_
      AND    ll.load_list_state = 'NOTDEL'
      AND    lll.load_id = ll.load_id
      AND    lll.order_no = col.order_no
      AND    lll.line_no = col.line_no
      AND    lll.rel_no = col.rel_no
      AND    lll.line_item_no = col.line_item_no
      AND    col.supply_code != 'PD'
      AND    lll.line_item_no >= 0
      AND    col.qty_to_ship > 0
      AND    co.order_no = col.order_no
      AND    co.rowstate NOT IN ('Planned', 'Blocked');
BEGIN
   Trace_SYS.Message('Deliver with differeence, all non inventory parts');
   
   FOR next_ IN find_all_non_inventory LOOP
      IF (cancel_delivery_ = 'TRUE') THEN
         qty_to_deliver_ := 0;
      ELSE
         IF (deliv_load_list_diff_) THEN
            close_          := (next_.close_line = 'TRUE');
            qty_to_deliver_ := next_.qty_to_deliver;
         ELSE
            qty_to_deliver_ := next_.qty_to_ship;
         END IF;
      END IF;

      New_Non_Inv_Line_Delivery___ (next_.order_no, 
                                    next_.line_no, 
                                    next_.rel_no,
                                    next_.line_item_no, 
                                    load_id_, 
                                    qty_to_deliver_, 
                                    close_,
                                    delnote_no_  => NULL,
                                    shipment_id_ => 0  );
      -- Modify package header if any package parts delivered
      Deliver_Complete_Packages___(next_.order_no, NULL);
           
      -- Remove the order line from the load list if there's nothing delivered from it.
      IF (qty_to_deliver_ = 0) THEN    
         Cust_Order_Load_List_Line_API.Remove(load_id_, 
               Cust_Order_Load_List_Line_API.Get_Pos(load_id_, 
                                                     next_.order_no, 
                                                     next_.line_no, 
                                                     next_.rel_no, 
                                                     next_.line_item_no));
         line_removed_ := TRUE;
      END IF;
   END LOOP;  
END Deliver_List_Non_Inv_Lines___;


-- Deliver_Order_Inv_With_Diff___
--   Deliver all inventory lines for an order with differences.
--   All changed lines are stored in the attribute string.
PROCEDURE Deliver_Order_Inv_With_Diff___ (
   info_            OUT VARCHAR2,
   order_no_        IN  VARCHAR2,
   message_         IN  CLOB,
   cancel_delivery_ IN  VARCHAR2 )
IS
   co_rec_                      Customer_Order_API.Public_Rec;
   line_rec_                    Customer_Order_Line_API.Public_Rec;
   line_no_                     CUSTOMER_ORDER_LINE_TAB.line_no%TYPE;
   rel_no_                      CUSTOMER_ORDER_LINE_TAB.rel_no%TYPE;
   line_item_no_                CUSTOMER_ORDER_LINE_TAB.line_item_no%TYPE;
   location_no_                 CUSTOMER_ORDER_RESERVATION_TAB.location_no%TYPE;
   lot_batch_no_                CUSTOMER_ORDER_RESERVATION_TAB.lot_batch_no%TYPE;
   serial_no_                   CUSTOMER_ORDER_RESERVATION_TAB.serial_no%TYPE;
   eng_chg_level_               CUSTOMER_ORDER_RESERVATION_TAB.eng_chg_level%TYPE;
   waiv_dev_rej_no_             CUSTOMER_ORDER_RESERVATION_TAB.waiv_dev_rej_no%TYPE;
   handling_unit_id_            CUSTOMER_ORDER_RESERVATION_TAB.handling_unit_id%TYPE;
   qty_picked_                  NUMBER;
   input_uom_                   VARCHAR2(30);
   input_qty_                   NUMBER;
   input_conv_factor_           NUMBER;
   input_variable_values_       VARCHAR2(2000);
   qty_to_deliver_              NUMBER;
   line_qty_to_deliver_         NUMBER := 0;
   close_                       BOOLEAN;
   line_delivered_              BOOLEAN;
   transaction_                 VARCHAR2(10);
   deliv_no_                    NUMBER;
   exchange_attr_               VARCHAR2(32000);
   bfinal_batch_                VARCHAR2(1) := 'Y';
   error_message_               VARCHAR2(32000);
   infor_                       VARCHAR2(32000);
   activity_seq_                NUMBER;
   catch_qty_to_deliver_        NUMBER;
   line_catch_qty_to_deliv_     NUMBER;
   g_info_                      VARCHAR2(32000) := '';
   dist_order_no_               VARCHAR2(12);
   demand_order_ref1_           CUSTOMER_ORDER_LINE_TAB.demand_order_ref1%TYPE;
   demand_order_ref2_           CUSTOMER_ORDER_LINE_TAB.demand_order_ref2%TYPE;
   demand_order_ref3_           CUSTOMER_ORDER_LINE_TAB.demand_order_ref3%TYPE;
   demand_order_ref4_           CUSTOMER_ORDER_LINE_TAB.demand_order_ref4%TYPE;
   inventory_event_id_          NUMBER;
   unattach_handling_unit_      BOOLEAN := TRUE;
   hu_at_co_delivery_           VARCHAR2(20);
   name_arr_                Message_SYS.name_table;
   value_arr_               Message_SYS.line_table;
   count_                   NUMBER := 0;
   no_of_line_              NUMBER := 0;
   inv_line_list_           delivered_line_info; 
   
   TYPE Dist_Order_Line_Rec IS RECORD
      (dist_order_no     VARCHAR2(12),
       deliv_no          customer_order_delivery_tab.deliv_no%TYPE);
       
   TYPE Dist_Ord_Line_Details_Table IS TABLE OF Dist_Order_Line_Rec INDEX BY BINARY_INTEGER;
   dist_ord_det_tab_     Dist_Ord_Line_Details_Table;
   row_count_            NUMBER;
   
   CURSOR find_all_inventory IS
      SELECT line_no, rel_no, line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB col
      WHERE  col.order_no            = order_no_
      AND    col.line_item_no       >= 0
      AND    col.qty_picked         > 0
      AND    col.shipment_connected  = 'FALSE'
      AND NOT EXISTS (SELECT 1
                         FROM   CUST_ORDER_LOAD_LIST_TAB ll
                         WHERE  ll.load_id         = col.load_id
                         AND    ll.load_list_state = 'NOTDEL')
      -- ORDER BY to prevent deadlock
      ORDER BY part_no;

   CURSOR get_all_reservations (contract_ IN VARCHAR2, part_no_ IN VARCHAR2,
                                line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2,
                                line_item_no_ IN NUMBER) IS
      SELECT location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
             SUM(qty_picked) qty_to_deliver, SUM(catch_qty) catch_qty_to_deliver, SUM(input_qty) input_qty, input_unit_meas,
             input_conv_factor, input_variable_values, activity_seq, handling_unit_id
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    contract = contract_
      AND    part_no = part_no_
      AND    qty_picked > 0
      GROUP BY location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
               input_unit_meas, input_conv_factor, input_variable_values, activity_seq, handling_unit_id
      -- ORDER BY to prevent deadlock
      ORDER BY location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
               input_unit_meas, input_conv_factor, input_variable_values, activity_seq, handling_unit_id;
               
   CURSOR get_inv_reservations IS
      SELECT  contract, part_no, configuration_id, location_no, lot_batch_no, serial_no,
              eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, qty_picked quantity
        FROM Deliver_Customer_Order
        WHERE order_no = order_no_;
   
   inv_part_reservation_tab_     Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
   
BEGIN
   Trace_SYS.Field('Deliver with difference, unconnected inventory parts on ORDER_NO', order_no_);
  
   row_count_ := 0;
   Inventory_Event_Manager_API.Start_Session;
   inventory_event_id_ := Inventory_Event_Manager_API.Get_Session_Id; 

   OPEN get_inv_reservations;
   FETCH get_inv_reservations BULK COLLECT INTO inv_part_reservation_tab_;
   CLOSE get_inv_reservations;
   
   -- Generate snapshot to determine what handling units will be fully delivered
   Handl_Unit_Snapshot_Util_API.Generate_Snapshot(source_ref1_          => inventory_event_id_,
                                                  source_ref_type_db_   => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                  inv_part_stock_tab_   => inv_part_reservation_tab_);

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   -- Retrieve all records to be delivered from the attribute string.
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'LINE_NO') THEN
         line_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'REL_NO') THEN
         rel_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LINE_ITEM_NO') THEN
         line_item_no_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'CLOSE_LINE') THEN
         IF (value_arr_(n_) = '0') THEN
            close_ := FALSE;
         ELSE
            close_ := TRUE;
         END IF;
         -- This triggers a new line so all initiations for a new line are made here.
         line_qty_to_deliver_ := 0;
         line_catch_qty_to_deliv_ := 0;

         Trace_SYS.Message('Delivers new line');
         Trace_SYS.Field('LINE_NO', line_no_);
         Trace_SYS.Field('REL_NO', rel_no_);
         Trace_SYS.Field('LINE_ITEM_NO', line_item_no_);
         Trace_SYS.Field('CLOSE_LINE', close_);

         no_of_line_ := no_of_line_ + 1;
         inv_line_list_(no_of_line_) := 'ORDER_NO='||order_no_|| Client_SYS.field_separator_ ||
                                        'LINE_NO=' ||line_no_ || Client_SYS.field_separator_ ||
                                        '^REL_NO=' || rel_no_ || Client_SYS.field_separator_ ||
                                        '^LINE_ITEM_NO='|| line_item_no_;
         deliv_no_ := Customer_Order_Delivery_API.Get_Next_Deliv_No;
      ELSIF (name_arr_(n_) = 'QTY_PICKED') THEN
         qty_picked_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'INPUT_UNIT_MEAS') THEN
          input_uom_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'INPUT_QTY') THEN
          input_qty_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'INPUT_CONV_FACTOR') THEN
          input_conv_factor_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'INPUT_VARIABLE_VALUES') THEN
          input_variable_values_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LOCATION_NO') THEN
         location_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LOT_BATCH_NO') THEN
         lot_batch_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SERIAL_NO') THEN
         serial_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ENG_CHG_LEVEL') THEN
         eng_chg_level_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'WAIV_DEV_REJ_NO') THEN
         waiv_dev_rej_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'FINAL_BATCH') THEN
            bfinal_batch_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ACTIVITY_SEQ') THEN
         activity_seq_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'CATCH_QTY_TO_DELIVER') THEN
         catch_qty_to_deliver_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
         line_catch_qty_to_deliv_ := line_catch_qty_to_deliv_ + catch_qty_to_deliver_;
      ELSIF (name_arr_(n_) = 'QTY_TO_DELIVER') THEN
         qty_to_deliver_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
         line_qty_to_deliver_ := line_qty_to_deliver_ + qty_to_deliver_;

         Trace_SYS.Field('QTY_PICKED', qty_picked_);
         Trace_SYS.Field('QTY_TO_DELIVER', qty_to_deliver_);
         Trace_SYS.Field('CATCH_QTY_TO_DELIVER', catch_qty_to_deliver_);
      
         line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
         hu_at_co_delivery_ := Cust_Ord_Customer_API.Get_Handl_Unit_At_Co_Delive_Db(line_rec_.deliver_to_customer_no);
         IF hu_at_co_delivery_ = Handl_Unit_At_Co_Delivery_API.DB_USE_SITE_DEFAULT THEN 
            unattach_handling_unit_ := (Site_Discom_Info_API.Get_Unattach_Hu_At_Delivery_Db(line_rec_.contract) = 'TRUE');
         ELSE 
            unattach_handling_unit_ := (hu_at_co_delivery_ = Handl_Unit_At_Co_Delivery_API.DB_UNATTACH);
         END IF;

         -- (Check if hu need to be unattached OR Qty to deliver is less than picked qty) =>  Whole handling unit should not be delivered => Unpack reservations
         IF (unattach_handling_unit_ OR qty_to_deliver_ < qty_picked_) AND 
            (Handl_Unit_Stock_Snapshot_API.Handling_Unit_Exist(source_ref1_         => inventory_event_id_, 
                                                               source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                               handling_unit_id_    => handling_unit_id_))THEN

            Handl_Unit_Stock_Snapshot_API.Remove_Handling_Unit(source_ref1_         => inventory_event_id_,
                                                               source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                               handling_unit_id_    => handling_unit_id_);
         END IF;

         Issue_Delivered_Parts___(transaction_, 
                                  catch_qty_to_deliver_, 
                                  order_no_, 
                                  line_no_, 
                                  rel_no_, 
                                  line_item_no_,
                                  location_no_, 
                                  lot_batch_no_, 
                                  serial_no_, 
                                  eng_chg_level_,
                                  waiv_dev_rej_no_, 
                                  qty_to_deliver_, 
                                  deliv_no_, 
                                  input_qty_,
                                  input_uom_,
                                  input_conv_factor_, 
                                  input_variable_values_, 
                                  NVL(activity_seq_, 0), 
                                  handling_unit_id_, 
                                  0, 
                                  'FALSE');                                  
      ELSIF (name_arr_(n_) = 'END_OF_LINE') THEN
         Trace_SYS.Field('LINE', line_qty_to_deliver_);
         New_Inv_Line_Delivery___(order_no_, line_no_, rel_no_, line_item_no_, NULL,
                                  line_qty_to_deliver_, line_catch_qty_to_deliv_, close_, transaction_, deliv_no_, delnote_no_ => NULL);
         g_info_ := g_info_||Client_SYS.Get_All_Info;

         Update_License_Coverage_Qty___(order_no_, line_no_, rel_no_, line_item_no_,line_qty_to_deliver_);-- Export control

         IF (Order_Supply_Type_API.Encode(Customer_Order_Line_API.Get_Demand_Code(order_no_, line_no_, rel_no_, line_item_no_)) = 'DO') THEN
            Customer_Order_Line_API.Get_Demand_Order_Info(demand_order_ref1_,demand_order_ref2_,demand_order_ref3_,demand_order_ref4_,
                                                          order_no_, line_no_, rel_no_, line_item_no_);
            dist_ord_det_tab_(row_count_).dist_order_no := demand_order_ref1_;
            dist_ord_det_tab_(row_count_).deliv_no      := deliv_no_;
            row_count_ := row_count_ + 1;
         END IF;
      END IF;
      -- Get next line from attribute string
   END LOOP;

   IF bfinal_batch_ = 'Y' THEN
      FOR next_ IN find_all_inventory LOOP
         Line_Already_Delivered___(line_delivered_, order_no_, next_.line_no, next_.rel_no, next_.line_item_no, inv_line_list_);

         IF NOT line_delivered_ THEN
            line_qty_to_deliver_ := 0;
            line_catch_qty_to_deliv_ := 0;
            line_rec_ := Customer_Order_Line_API.Get(order_no_, next_.line_no, next_.rel_no, next_.line_item_no);
            deliv_no_ := Customer_Order_Delivery_API.Get_Next_Deliv_No;

            hu_at_co_delivery_ := Cust_Ord_Customer_API.Get_Handl_Unit_At_Co_Delive_Db(line_rec_.deliver_to_customer_no);
            IF hu_at_co_delivery_ = Handl_Unit_At_Co_Delivery_API.DB_USE_SITE_DEFAULT THEN 
               unattach_handling_unit_ := (Site_Discom_Info_API.Get_Unattach_Hu_At_Delivery_Db(line_rec_.contract) = 'TRUE');
            ELSE 
               unattach_handling_unit_ := (hu_at_co_delivery_ = Handl_Unit_At_Co_Delivery_API.DB_UNATTACH);
            END IF;

            FOR res_ IN get_all_reservations (line_rec_.contract, line_rec_.part_no,
                                              next_.line_no, next_.rel_no, next_.line_item_no) LOOP

               IF (cancel_delivery_ = 'TRUE') THEN
                  qty_to_deliver_ := 0;
                  IF (res_.catch_qty_to_deliver IS NOT NULL) THEN
                     catch_qty_to_deliver_ := 0;
                  END IF;
               ELSE
                  qty_to_deliver_       := res_.qty_to_deliver;
                  catch_qty_to_deliver_ := res_.catch_qty_to_deliver;
               END IF;
               line_qty_to_deliver_     := line_qty_to_deliver_ + qty_to_deliver_;
               line_catch_qty_to_deliv_ :=  line_catch_qty_to_deliv_ +  catch_qty_to_deliver_;

               -- (Check if hu need to be unattached =>  Whole handling unit should not be delivered => Unpack reservations
               IF (unattach_handling_unit_ AND Handl_Unit_Stock_Snapshot_API.Handling_Unit_Exist(source_ref1_         => inventory_event_id_, 
                                                                                                 source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                                                                 handling_unit_id_    => res_.handling_unit_id))THEN

                  Handl_Unit_Stock_Snapshot_API.Remove_Handling_Unit(source_ref1_         => inventory_event_id_,
                                                                     source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                                     handling_unit_id_    => res_.handling_unit_id);
               END IF;

               
               Issue_Delivered_Parts___(transaction_, 
                                        catch_qty_to_deliver_, 
                                        order_no_, 
                                        next_.line_no, 
                                        next_.rel_no, 
                                        next_.line_item_no,
                                        res_.location_no, 
                                        res_.lot_batch_no, 
                                        res_.serial_no, 
                                        res_.eng_chg_level,
                                        res_.waiv_dev_rej_no, 
                                        qty_to_deliver_, 
                                        deliv_no_,
                                        res_.input_qty, 
                                        res_.input_unit_meas, 
                                        res_.input_conv_factor,
                                        res_.input_variable_values, 
                                        NVL(res_.activity_seq, 0), 
                                        res_.handling_unit_id, 
                                        0, 
                                        'FALSE');
                                        
               serial_no_     := res_.serial_no;
               lot_batch_no_  := res_.lot_batch_no;
            END LOOP;

            New_Inv_Line_Delivery___(order_no_, next_.line_no, next_.rel_no, next_.line_item_no,
                                  NULL, line_qty_to_deliver_, line_catch_qty_to_deliv_, FALSE, transaction_, deliv_no_, delnote_no_ => NULL);
            g_info_ := g_info_||Client_SYS.Get_All_Info;

            Update_License_Coverage_Qty___(order_no_, next_.line_no, next_.rel_no, next_.line_item_no, line_qty_to_deliver_);-- Export control

            IF (Order_Supply_Type_API.Encode(Customer_Order_Line_API.Get_Demand_Code(order_no_, next_.line_no, next_.rel_no, next_.line_item_no)) = 'DO') THEN
               Customer_Order_Line_API.Get_Demand_Order_Info(demand_order_ref1_,demand_order_ref2_,demand_order_ref3_,demand_order_ref4_,
                                                             order_no_, next_.line_no, next_.rel_no, next_.line_item_no);
               dist_ord_det_tab_(row_count_).dist_order_no := demand_order_ref1_;
               dist_ord_det_tab_(row_count_).deliv_no      := deliv_no_;
               row_count_                                  := row_count_ + 1;
            END IF;

            -- Note: Modify the exchange component details after shipping the part.
            IF (Exchange_Item_API.Encode(customer_order_line_API.Get_Exchange_Item(order_no_, next_.line_no, next_.rel_no, next_.line_item_no)) = 'EXCHANGED ITEM' AND line_qty_to_deliver_ > 0) THEN
               $IF (Component_Purch_SYS.INSTALLED) $THEN
                  Client_Sys.Clear_Attr(exchange_attr_);
                  Client_SYS.Add_To_Attr('EXCHANGE_PART_SHIPPED_DB', 'SHIPPED', exchange_attr_);
                  IF (serial_no_ = '*') THEN
                     serial_no_ := NULL;
                  END IF;
                  IF (lot_batch_no_ = '*') THEN
                     lot_batch_no_ := NULL;
                  END IF;
                  Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, exchange_attr_);
                  Client_SYS.Add_To_Attr('LOT_BATCH_NO', lot_batch_no_, exchange_attr_);
                  Client_SYS.Add_To_Attr('CONDITION_CODE', line_rec_.condition_code, exchange_attr_);

                  DECLARE
                     po_order_no_ VARCHAR2(12);
                     po_line_no_  VARCHAR2(4);
                     po_rel_no_   VARCHAR2(4);
                  BEGIN
                     Pur_Order_Exchange_Comp_API.Get_Connected_Po_Info(po_order_no_, po_line_no_, po_rel_no_, order_no_, next_.line_no, next_.rel_no, next_.line_item_no);
                     Pur_Order_Exchange_Comp_API.Modify(exchange_attr_, po_order_no_, po_line_no_, po_rel_no_ );
                  END;
               $ELSE
                  NULL;
               $END
            END IF;
         END IF;
      END LOOP;
      -- Modify package header if any package parts delivered
      IF (line_qty_to_deliver_ > 0) THEN
         Deliver_Complete_Packages___(order_no_, delnote_no_ => NULL);
      END IF;
   END IF;


   info_ := g_info_;
   
   Handl_Unit_Snapshot_Util_API.Delete_Snapshot(source_ref1_         => inventory_event_id_,
                                                source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_DELIVERY);
   Inventory_Event_Manager_API.Finish_Session;
   BEGIN
      @ApproveTransactionStatement(2014-12-17,jelise)
      SAVEPOINT event_processed;
      -- After a customer order delivery, this informs the DistributionOrder that a
      -- delivery has been performed. This is only done, if the customer order has been
      -- created from a distribution order.
      
      $IF (Component_Disord_SYS.INSTALLED) $THEN   
         IF (Order_Supply_Type_API.Encode(Customer_Order_Line_API.Get_Demand_Code(order_no_, '1', '1', 0)) = 'DO' AND line_qty_to_deliver_ > 0) THEN
            IF (dist_ord_det_tab_.COUNT > 0) THEN
               FOR index_ IN dist_ord_det_tab_.FIRST..dist_ord_det_tab_.LAST LOOP
                  dist_order_no_ := dist_ord_det_tab_(index_).dist_order_no;
                  deliv_no_      := dist_ord_det_tab_(index_).deliv_no;
                  Distribution_Order_API.Customer_Order_Delivered(dist_order_no_, deliv_no_);
               END LOOP;
            END IF;
         END IF;
      $END
   EXCEPTION
      WHEN others THEN
         error_message_ := sqlerrm;

         -- Rollback to the last savepoint
         @ApproveTransactionStatement(2014-12-17,jelise)
         ROLLBACK to event_processed;
         -- Logg the error
         infor_ := Language_SYS.Translate_Constant(lu_name_, 'ORDERERR: Order: :P1   :P2',
                                                   NULL, order_no_, error_message_);

         Transaction_SYS.Set_Status_Info(infor_);
         Cust_Order_Event_Creation_API.Order_Processing_Error(order_no_, error_message_);
   END;
END Deliver_Order_Inv_With_Diff___;


-- Deliver_Order_Non_With_Diff___
--   Deliver all lines with no acquisition for an order with differences.
--   All changed lines are stored in the attribute string.
PROCEDURE Deliver_Order_Non_With_Diff___ (
   order_no_        IN VARCHAR2,
   message_         IN CLOB,
   cancel_delivery_ IN VARCHAR2 )
IS
   name_arr_          Message_SYS.name_table;
   value_arr_         Message_SYS.line_table;
   count_             NUMBER := 0;
   no_of_line_        NUMBER := 0;
   non_inv_line_list_ delivered_line_info;
   line_no_        CUSTOMER_ORDER_LINE_TAB.line_no%TYPE;
   rel_no_         CUSTOMER_ORDER_LINE_TAB.rel_no%TYPE;
   line_item_no_   CUSTOMER_ORDER_LINE_TAB.line_item_no%TYPE;
   close_          BOOLEAN;
   qty_to_deliver_ NUMBER;
   line_delivered_ BOOLEAN;
   qty_to_ship_    CUSTOMER_ORDER_LINE_TAB.qty_to_ship%TYPE;

   CURSOR find_all_non_inventory IS
      SELECT line_no, rel_no, line_item_no, qty_to_ship
      FROM   CUSTOMER_ORDER_LINE_TAB col
      WHERE  col.order_no            = order_no_
      AND    col.supply_code        != 'PD'
      AND    col.qty_to_ship        != 0
      AND    col.line_item_no       >= 0
      AND    col.shipment_connected  = 'FALSE'
      AND    col.rowstate           != 'Cancelled'
      AND  NOT EXISTS (SELECT 1
                       FROM   CUST_ORDER_LOAD_LIST_TAB ll
                       WHERE  ll.load_id         = col.load_id
                       AND    ll.load_list_state = 'NOTDEL');
BEGIN
   Trace_SYS.Field('Deliver with difference, unconnected non inventory parts on ORDER_NO', order_no_);
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   
   -- Retrieve all records to be delivered from the attribute string.
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'LINE_NO') THEN
         line_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'REL_NO') THEN
         rel_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LINE_ITEM_NO') THEN
         line_item_no_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'CLOSE_LINE') THEN
         IF (value_arr_(n_) = '0') THEN
            close_ := FALSE;
         ELSE
            close_ := TRUE;
         END IF;
      ELSIF (name_arr_(n_) = 'QTY_TO_DELIVER') THEN
         qty_to_deliver_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));

         -- This triggers a new line so all initiations for a new line are made here.
         Trace_SYS.Message('Delivers new line');
         Trace_SYS.Field('LINE_NO', line_no_);
         Trace_SYS.Field('REL_NO', rel_no_);
         Trace_SYS.Field('LINE_ITEM_NO', line_item_no_);
         Trace_SYS.Field('CLOSE_LINE', close_);

         no_of_line_ := no_of_line_ + 1;
         non_inv_line_list_(no_of_line_) := 'ORDER_NO='||order_no_|| Client_SYS.field_separator_ ||
                                            'LINE_NO=' ||line_no_ || Client_SYS.field_separator_ ||
                                            '^REL_NO=' || rel_no_ || Client_SYS.field_separator_ ||
                                            '^LINE_ITEM_NO='|| line_item_no_;

         New_Non_Inv_Line_Delivery___(order_no_, line_no_, rel_no_, line_item_no_,
                                      load_id_ => NULL, qty_to_deliver_ => qty_to_deliver_, close_ => close_,
                                      delnote_no_ => NULL, shipment_id_ => 0);
      END IF;
   END LOOP;

   FOR next_ IN find_all_non_inventory LOOP
      Line_Already_Delivered___(line_delivered_, order_no_, next_.line_no, next_.rel_no, next_.line_item_no, non_inv_line_list_);
      IF NOT line_delivered_ THEN
         IF (cancel_delivery_ = 'TRUE') THEN
            qty_to_ship_ := 0;
         ELSE
            qty_to_ship_ := next_.qty_to_ship;
         END IF;
         New_Non_Inv_Line_Delivery___ (order_no_, next_.line_no, next_.rel_no,
                                       next_.line_item_no, load_id_ => NULL, qty_to_deliver_ => qty_to_ship_, close_ => FALSE, delnote_no_ => NULL, shipment_id_ => 0);
      END IF;
   END LOOP;
   -- Modify package header if any package parts delivered
   Deliver_Complete_Packages___(order_no_, delnote_no_ => NULL);
END Deliver_Order_Non_With_Diff___;


-- Issue_Delivered_Parts___
--   Deliver line from inventory and modifies all reservations.
PROCEDURE Issue_Delivered_Parts___ (
   transaction_                 IN OUT VARCHAR2,
   catch_qty_to_deliver_        IN OUT NUMBER,
   order_no_                    IN     VARCHAR2,
   line_no_                     IN     VARCHAR2,
   rel_no_                      IN     VARCHAR2,
   line_item_no_                IN     NUMBER,
   location_no_                 IN     VARCHAR2,
   lot_batch_no_                IN     VARCHAR2,
   serial_no_                   IN     VARCHAR2,
   eng_chg_level_               IN     VARCHAR2,
   waiv_dev_rej_no_             IN     VARCHAR2,
   qty_to_deliver_              IN     NUMBER,
   deliv_no_                    IN     NUMBER,
   input_qty_                   IN     NUMBER,
   input_unit_meas_             IN     VARCHAR2,
   input_conv_factor_           IN     NUMBER,
   input_variable_values_       IN     VARCHAR2,
   activity_seq_                IN     NUMBER,
   handling_unit_id_            IN     NUMBER,
   shipment_id_                 IN     NUMBER,
   remove_ship_                 IN     VARCHAR2)
IS
   contract_                      CUSTOMER_ORDER_LINE_TAB.contract%TYPE;
   customer_contract_             CUSTOMER_ORDER_LINE_TAB.contract%TYPE;
   part_no_                       CUSTOMER_ORDER_LINE_TAB.part_no%TYPE;
   configuration_id_              CUSTOMER_ORDER_LINE_TAB.configuration_id%TYPE;
   pick_list_no_                  CUSTOMER_ORDER_RESERVATION_TAB.pick_list_no%TYPE;
   reservation_rec_               CUSTOMER_ORDER_RESERVATION_API.Public_Rec;
   partca_rec_                    PART_CATALOG_API.Public_Rec;
   old_qty_assigned_              NUMBER;
   old_qty_picked_                NUMBER;
   old_catch_qty_                 NUMBER;
   new_qty_assigned_              NUMBER;
   new_qty_picked_                NUMBER;
   qty_shipped_from_location_     NUMBER;
   qty_remaining_                 NUMBER;
   shipment_inventory_            BOOLEAN := FALSE;
   total_qty_picked_              NUMBER  := 0;
   trans_order_no_                VARCHAR2(12) := order_no_;
   trans_line_no_                 VARCHAR2(4) := line_no_;
   trans_rel_no_                  VARCHAR2(4) := rel_no_;
   trans_line_item_no_            NUMBER := line_item_no_;
   ordrec_                        Customer_Order_API.Public_Rec;
   linerec_                       Customer_Order_Line_API.Public_Rec;
   delivery_date_                 DATE;
   new_deliv_no_                  NUMBER;   
   calculate_warranty_dates_      BOOLEAN;
   supply_code_                   VARCHAR2(3);
   sup_sm_contract_               VARCHAR2(5);
   sup_sm_object_                 CUSTOMER_ORDER_LINE_TAB.sup_sm_object%TYPE;
   attr_                          VARCHAR2(2000);
   cust_category_                 VARCHAR2(2);
   diff_comp_sm_obj_              BOOLEAN := FALSE;
   dummy_number_                  NUMBER;
   new_catch_qty_                 NUMBER;
   transaction_id_                NUMBER;
   alt_source_ref_type_db_        VARCHAR2(10) := ('CUST ORDER');
   company_                       VARCHAR2 (20);
   internal_po_no_                VARCHAR2(12);
   pur_order_no_                  VARCHAR2(12);
   pur_line_no_                   VARCHAR2(4);
   pur_rel_no_                    VARCHAR2(4);
   dummy_                         NUMBER;
   pur_status_                    VARCHAR2(20);
   expiration_date_               DATE;
   transfer_reservations_         VARCHAR2(5) := 'FALSE';

   tot_qty_assigned_              NUMBER;

   index_                         NUMBER := 0;
   catch_qty_shipped_             NUMBER;
   total_qty_to_reserve_          NUMBER;
   ignore_this_avail_control_id_  VARCHAR2(25);
   rental_transfer_db_            VARCHAR2(5);
   qty_reserved_                  NUMBER;
   hu_qty_reserved_               NUMBER := 0;
   local_handling_unit_id_        NUMBER;
   exists_in_snapshot_            BOOLEAN;
   newrec_qty_shipped_            NUMBER;
   newrec_                        Customer_Order_Reservation_API.Public_Rec;
   validate_hu_struct_position_   BOOLEAN;
   outermost_hu_id_               NUMBER;
   catch_qty_remaining_           NUMBER;
   inventory_event_id_            NUMBER;   
   availability_control_id_       VARCHAR2(25);   
   catch_qty_shipped_from_location_ NUMBER;
   total_catch_qty_delivered_     NUMBER := 0;
   destination_warehouse_id_      VARCHAR2(15);  
   
   CURSOR find_all_picklists IS
      SELECT pick_list_no
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    contract = contract_
      AND    part_no = part_no_
      AND    location_no = location_no_
      AND    lot_batch_no = lot_batch_no_
      AND    serial_no = serial_no_
      AND    eng_chg_level = eng_chg_level_
      AND    waiv_dev_rej_no = waiv_dev_rej_no_
      AND    activity_seq = activity_seq_
      AND    handling_unit_id = handling_unit_id_
      AND    shipment_id = shipment_id_ 
      AND    qty_picked > 0;
BEGIN
   linerec_                      := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   contract_                     := linerec_.contract;
   part_no_                      := linerec_.part_no;
   configuration_id_             := linerec_.configuration_id;
   new_deliv_no_                 := deliv_no_;
   partca_rec_                   := Part_Catalog_API.Get(part_no_);
   qty_reserved_                 := qty_to_deliver_;
   local_handling_unit_id_       := handling_unit_id_;
   newrec_qty_shipped_           := 0;
   validate_hu_struct_position_  := TRUE;
   
   customer_contract_ := Cust_Ord_Customer_API.Get_Acquisition_Site(linerec_.customer_no);
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (qty_to_deliver_ != 0) THEN
         IF (customer_contract_ IS NOT NULL) THEN
            internal_po_no_           := Customer_Order_API.Get_Internal_Po_No(order_no_);
            destination_warehouse_id_ := '*';
            IF (internal_po_no_ IS NOT NULL) THEN
               Customer_Order_Line_API.Get_Demand_Order_Info(pur_order_no_, pur_line_no_, pur_rel_no_, dummy_,
                                                             order_no_, line_no_, rel_no_, line_item_no_);
               IF (linerec_.demand_code != 'DO') THEN
                  -- if the order line is created by the internal purchase order...
                  IF (internal_po_no_ = NVL(pur_order_no_, ' ')) THEN
                        pur_status_        := Purchase_Order_Line_API.Get_Objstate(pur_order_no_, pur_line_no_, pur_rel_no_);
                        customer_contract_ := Purchase_Order_Line_Part_API.Get_Contract(pur_order_no_, pur_line_no_, pur_rel_no_);          
                     IF (NVL(pur_status_, ' ') = 'Cancelled') THEN
                        IF (linerec_.shipment_connected = 'FALSE') THEN
                           Error_SYS.Record_General(lu_name_, 'PURCHLINECANCELLED: This order line is connected to Purchase Order Line :P1/:P2/:P3 - which is Cancelled. Only Deliver with Differences is allowed - with Qty To Deliver 0.',
                                                    pur_order_no_, pur_line_no_, pur_rel_no_);
                        ELSE
                           Error_SYS.Record_General(lu_name_, 'PURSHIPCONNECTED: Order line :P1 is connected to Purchase Order Line :P2 - which is cancelled. The order line(s) cannot be delivered and must be disconnected from the Shipment after status has been set back to Preliminary.',
                                                   (order_no_||' '||line_no_||' '||rel_no_), (pur_order_no_||' '|| pur_line_no_||' '|| pur_rel_no_));
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   $END   

   IF (Inventory_Location_API.Get_Location_Type(contract_, location_no_) = Inventory_Location_Type_API.Decode('SHIPMENT')) THEN
      -- It's a shipment location.
      shipment_inventory_ := TRUE;
   END IF;
   qty_remaining_       := qty_to_deliver_;
   catch_qty_remaining_ := catch_qty_to_deliver_;

   expiration_date_  := Inventory_Part_In_Stock_API.Get_Expiration_Date(contract_, 
                                                                        part_no_,
                                                                        configuration_id_,
                                                                        location_no_,
                                                                        lot_batch_no_,
                                                                        serial_no_,
                                                                        eng_chg_level_,
                                                                        waiv_dev_rej_no_,
                                                                        activity_seq_, 
                                                                        local_handling_unit_id_); 
   
   tot_qty_assigned_ := Customer_Order_Line_API.Get_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_);

   FOR next_ IN find_all_picklists LOOP
      pick_list_no_     := next_.pick_list_no;
      -- Modify existing reservation
      reservation_rec_  := Customer_Order_Reservation_API.Get(order_no_          => order_no_, 
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
      old_qty_assigned_ := reservation_rec_.qty_assigned;
      old_qty_picked_   := reservation_rec_.qty_picked;
      old_catch_qty_    := reservation_rec_.catch_qty;

      total_qty_picked_          := total_qty_picked_ + old_qty_picked_;
      -- fetch the least qty always for particular pick list line.
      -- qty_remaining_ will be always the remainig qty to deliver.
      qty_shipped_from_location_ := LEAST(old_qty_picked_, qty_remaining_);
      IF (old_catch_qty_ IS NOT NULL AND partca_rec_.catch_unit_enabled = 'TRUE') THEN
         IF handling_unit_id_ != 0 AND old_catch_qty_ < catch_qty_remaining_ THEN 
            Error_SYS.Record_General(lu_name_, 'MORECATCHQTYTHANPICKED: Cannot deliver more catch quantity than already picked for handling unit :P1 .', handling_unit_id_);
         END IF;
         catch_qty_shipped_from_location_ := LEAST(old_catch_qty_, nvl(catch_qty_remaining_,0));
      END IF;
      IF (qty_to_deliver_ > 0 AND qty_shipped_from_location_ = 0 AND NVL(catch_qty_shipped_from_location_, 0) = 0) THEN
         EXIT;
      END IF;
      -- during a unreservation total_qty_to_reserve_ will be a negative value.
      IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
         total_qty_to_reserve_ := qty_to_deliver_ - old_qty_assigned_;

         Reserve_Customer_Order_API.Validate_On_Rental_Period_Qty(order_no_,
                                                                  line_no_, 
                                                                  rel_no_, 
                                                                  line_item_no_,
                                                                  lot_batch_no_,
                                                                  serial_no_,
                                                                  total_qty_to_reserve_);
      END IF;

      -- if partially delivery has been done before qty_shipped has a value.
      newrec_qty_shipped_     := reservation_rec_.qty_shipped + qty_shipped_from_location_;  
      IF (catch_qty_to_deliver_ IS NOT NULL) AND (newrec_qty_shipped_ > reservation_rec_.qty_shipped) THEN
         index_ := index_ + 1;
         IF (index_ = 1) THEN
            -- if partially delivery has been done before catch_qty_shipped has a value.
            catch_qty_shipped_ := NVL(reservation_rec_.catch_qty_shipped, 0) + catch_qty_to_deliver_; --catch_qty_shipped_from_location_
         ELSE
            catch_qty_shipped_ := reservation_rec_.catch_qty_shipped;
         END IF;
      END IF;
      
      IF shipment_inventory_ THEN
         -- Added a condition to raise an error if the qty to deliver is greater than the quantity to assign.
         IF (qty_to_deliver_ >  tot_qty_assigned_) THEN
            Error_SYS.Record_General(lu_name_, 'QTYTODELGTASSQTY: Quantity to deliver is greater than the assigned quantity.');
         END IF;

         -- Do not remove remaining reservations.
         new_qty_assigned_ := old_qty_assigned_ - qty_shipped_from_location_;
         new_qty_picked_   := old_qty_picked_ - qty_shipped_from_location_;

         -- Check if catch unit is used
         IF new_qty_assigned_ = old_qty_assigned_ THEN 
            new_catch_qty_ := old_catch_qty_;
         ELSIF (old_catch_qty_ IS NOT NULL AND partca_rec_.catch_unit_enabled = 'TRUE') THEN
            IF (new_qty_picked_ > 0) THEN
               new_catch_qty_ := old_catch_qty_ - catch_qty_shipped_from_location_;            
            ELSE
               new_catch_qty_ := 0;
            END IF;
         ELSE
            new_catch_qty_ := NULL;
         END IF;

         IF (remove_ship_ = 'TRUE') THEN
            transfer_reservations_ := 'TRUE';
         END IF;
      ELSE
         -- Remove remaining reservations.
         new_qty_assigned_ := 0;
         new_qty_picked_   := 0;

         -- Check if catch unit is used
         IF (old_catch_qty_ IS NOT NULL) THEN
            new_catch_qty_ := 0;
         ELSE
            new_catch_qty_ := NULL;
         END IF;
         
      END IF;

      IF (qty_shipped_from_location_ <= 0) THEN
         new_deliv_no_:= NULL;
      END IF;

      inventory_event_id_ := Inventory_Event_Manager_API.Get_Session_Id;
      -- Check if the handling unit exists in the snapshot, handling unit id 0 always returns false.
      -- If there is no snapshot generated for this it will return false, and proceed to unpack the reservations.
      exists_in_snapshot_ := Handl_Unit_Stock_Snapshot_API.Handling_Unit_Exist(source_ref1_        => inventory_event_id_, 
                                                                               source_ref_type_db_ => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                                               handling_unit_id_   => local_handling_unit_id_);
      validate_hu_struct_position_ := NOT exists_in_snapshot_;
      IF(NOT exists_in_snapshot_ AND handling_unit_id_ != 0 AND qty_to_deliver_>0) THEN
         
         Customer_Order_Reservation_API.Change_Handling_Unit_Id(availability_control_id_  => availability_control_id_,
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
                                                                to_handling_unit_id_      => 0,
                                                                configuration_id_         => configuration_id_, 
                                                                pick_list_no_             => pick_list_no_, 
                                                                shipment_id_              => shipment_id_, 
                                                                qty_assigned_             => old_qty_assigned_,
                                                                qty_picked_               => old_qty_picked_,
                                                                catch_qty_                => old_catch_qty_,
                                                                qty_to_move_              => qty_shipped_from_location_,
                                                                catch_qty_to_move_        => catch_qty_shipped_from_location_,
                                                                release_remaining_qty_    => NOT shipment_inventory_,
                                                                reservation_operation_id_ => Inv_Part_Stock_Reservation_API.unpack_reservation_);

         -- Quantity has been moved to the new reservation, now we fetch that quantity from this reservation
         -- and calculate the new qty_picked and qty_assigned and catch_qty to be sent to method Modify_On_Delivery.
         newrec_                 := Customer_Order_Reservation_API.Get(order_no_, line_no_, rel_no_, line_item_no_, contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, 0, configuration_id_, pick_list_no_, shipment_id_);  
         newrec_qty_shipped_     := newrec_.qty_shipped + qty_shipped_from_location_;
         new_qty_assigned_       := newrec_.qty_assigned - qty_shipped_from_location_;
         new_qty_picked_         := newrec_.qty_picked - qty_shipped_from_location_;
         IF (newrec_.catch_qty IS NOT NULL AND partca_rec_.catch_unit_enabled = 'TRUE') THEN
            new_catch_qty_       := GREATEST(0, (newrec_.catch_qty - catch_qty_shipped_from_location_));
            catch_qty_shipped_   := NVL(newrec_.catch_qty_shipped, 0) + catch_qty_shipped_from_location_;
         END IF;
         hu_qty_reserved_        := hu_qty_reserved_ + qty_shipped_from_location_;
         qty_reserved_           := hu_qty_reserved_;
         -- Set the new handling unit id to 0 as we are delivering from this reservation.
         local_handling_unit_id_ := 0;
      END IF;
      
      Customer_Order_Reservation_API.Modify_On_Delivery__(order_no_              => order_no_, 
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
                                                          activity_seq_          => activity_seq_,
                                                          handling_unit_id_      => local_handling_unit_id_,
                                                          pick_list_no_          => pick_list_no_, 
                                                          configuration_id_      => configuration_id_, 
                                                          shipment_id_           => shipment_id_, 
                                                          expiration_date_       => expiration_date_, 
                                                          qty_shipped_           => newrec_qty_shipped_,
                                                          qty_assigned_          => new_qty_assigned_, 
                                                          qty_picked_            => new_qty_picked_, 
                                                          catch_qty_             => new_catch_qty_,
                                                          deliv_no_              => new_deliv_no_,
                                                          input_qty_             => input_qty_, 
                                                          input_unit_meas_       => input_unit_meas_,
                                                          input_conv_factor_     => input_conv_factor_, 
                                                          input_variable_values_ => input_variable_values_, 
                                                          catch_qty_shipped_     => catch_qty_shipped_, 
                                                          transfer_reservations_ => transfer_reservations_);

      qty_remaining_       := qty_remaining_ - qty_shipped_from_location_;
      IF catch_qty_shipped_from_location_ IS NOT NULL THEN 
         catch_qty_remaining_ := catch_qty_remaining_ - catch_qty_shipped_from_location_;
      END IF;
      
      -- merge warranties and calculate warranty dates if serial part
      IF (serial_no_ != '*' AND NVL(qty_to_deliver_,0) > 0 ) THEN
         calculate_warranty_dates_ := TRUE;
         IF ((linerec_.charged_item = 'ITEM NOT CHARGED' OR linerec_.exchange_item = 'EXCHANGED ITEM')
            OR (linerec_.part_ownership IN ('SUPPLIER LOANED', 'CUSTOMER OWNED'))
            OR (linerec_.consignment_stock = 'CONSIGNMENT STOCK')
            OR (linerec_.rental = 'TRUE')) THEN
            calculate_warranty_dates_ := FALSE;
         END IF;
         IF calculate_warranty_dates_ THEN
            IF (linerec_.cust_warranty_id IS NOT NULL) THEN
               Part_Serial_Catalog_API.Set_Or_Merge_Cust_Warranty(part_no_, serial_no_, linerec_.cust_warranty_id);
            END IF;
            Cust_Ord_Date_Calculation_API.Fetch_Calendar_End_Date(delivery_date_, linerec_.ext_transport_calendar_id,
                                                                  Site_API.Get_Site_Date(contract_),
                                                                  linerec_.delivery_leadtime);
            Serial_Warranty_Dates_API.Calculate_Warranty_Dates(part_no_, serial_no_, delivery_date_);
         END IF;
      END IF;
   END LOOP;
   -- refresh records after possible modifications. (part and contract and configuration will not change)
   ordrec_  := Customer_Order_API.Get(order_no_);
   linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   -- Issue part in InventoryPartLocation
   IF (qty_to_deliver_ > 0) THEN
      -- Check if this is an internal order within the same company.
      -- If so then a different transaction should be set.
      IF ((Site_API.Get_Company(contract_) = Site_API.Get_Company(customer_contract_))) THEN
         IF (linerec_.demand_code = 'IPD') THEN
            transaction_ := 'SHIPDIR';
         ELSE
            transaction_ := 'SHIPTRAN';
         END IF;
      ELSE
         IF (linerec_.demand_code = 'CRE' AND linerec_.supply_code = 'CRO' AND linerec_.part_ownership = 'COMPANY OWNED') THEN
            -- Set the standard transaction for order lines created from a Component Repair Exchange.
            transaction_ := 'CRO-EXD-OU';
         ELSIF (linerec_.consignment_stock = 'CONSIGNMENT STOCK') THEN
            -- Set the standard transaction for order lines using consignment stock.
            Trace_SYS.Message('Consignment Stock 1');
            transaction_ := 'CO-DELV-OU';
         ELSIF (ordrec_.delay_cogs_to_deliv_conf = 'TRUE') THEN
            -- Set the standard transaction for order lines using delay COGS.
            transaction_ := 'DELCONF-OU';
         ELSIF (linerec_.charged_item = 'ITEM NOT CHARGED') THEN
            -- Set the standard transaction for order lines created from a purchase order with 'no charge'.
            transaction_ := 'PURSHIP';
            -- The PURSHIP transaction must be booked on the purchase order
            -- A new transaction should probably be defined for this case.
            Customer_Order_Line_API.Get_Demand_Order_Info(trans_order_no_,
                                                          trans_line_no_,
                                                          trans_rel_no_,
                                                          trans_line_item_no_,
                                                          order_no_,
                                                          line_no_,
                                                          rel_no_,
                                                          line_item_no_ );
         ELSIF linerec_.exchange_item ='EXCHANGED ITEM' THEN
            --Note: Set the transaction for shipment of exchange parts.
            --Note: The EXCH-SHIP transaction must be booked on the purchase order
            transaction_ := 'EXCH-SHIP';
            Customer_Order_Line_API.Get_Demand_Order_Info(trans_order_no_,
                                                          trans_line_no_,
                                                          trans_rel_no_,
                                                          trans_line_item_no_,
                                                          order_no_,
                                                          line_no_,
                                                          rel_no_,
                                                          line_item_no_ );
         ELSE
            -- Set the standard transaction for orders not internal.
            transaction_ := 'OESHIP';
         END IF;
      END IF;
      Trace_SYS.Field('Qty issued', qty_to_deliver_);

      IF (line_item_no_ > 0) THEN
         company_ := Site_API.Get_Company(linerec_.contract);

         IF (Site_API.Get_Company(customer_contract_)= company_) AND (customer_contract_ IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOPKGPART: Creation or delivery of internal customer order lines using a package part is not allowed for Inter-Site handling between two sites connected to the same company.');
         END IF;
      END IF;
      
      $IF (Component_Cromfg_SYS.INSTALLED) $THEN
         IF (linerec_.demand_code = 'CRE' AND linerec_.supply_code = 'CRO') THEN
            Cro_Exchange_Reservation_API.Update_Qty_Dispatched(cro_no_           => linerec_.demand_order_ref1,
                                                               line_no_          => linerec_.demand_order_ref2,
                                                               contract_         => contract_, 
                                                               ex_part_no_       => part_no_, 
                                                               configuration_id_ => configuration_id_,
                                                               lot_batch_no_     => lot_batch_no_,
                                                               serial_no_        => serial_no_,
                                                               eng_chg_level_    => eng_chg_level_,
                                                               activity_seq_     => activity_seq_,
                                                               handling_unit_id_ => handling_unit_id_,
                                                               qty_dispatched_   => qty_to_deliver_);
         END IF; 
      $END
         -- ignore part availability check for rental transfer
      IF (linerec_.rental = 'TRUE') THEN       
         $IF Component_Rental_SYS.INSTALLED $THEN
            rental_transfer_db_ := Rental_Object_API.Get_Rental_Transfer_Db(Rental_Object_API.Get_Rental_No(order_no_, line_no_, rel_no_, line_item_no_, Rental_Type_API.DB_CUSTOMER_ORDER));               
            IF (rental_transfer_db_ = Fnd_Boolean_API.DB_TRUE) THEN
               ignore_this_avail_control_id_ := Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_);
            END IF;
         $ELSE
            Error_SYS.Component_Not_Exist('RENTAL');
         $END             
      END IF;

      IF(handling_unit_id_ != 0) THEN 
         IF NOT exists_in_snapshot_ THEN
            ignore_this_avail_control_id_ := availability_control_id_;
         ELSE  -- Disconnect the handling unit from the structure as we are only delivering lowest level handling units.
            -- Get the outermost handling unit from the snapshot, if this exists in the snapshot, it is safe to deliver the entire structure
            outermost_hu_id_ := Handl_Unit_Stock_Snapshot_API.Get_Outermost_Hu_Id(source_ref1_        => inventory_event_id_, 
                                                                                  source_ref_type_db_ => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                                                  handling_unit_id_   => handling_unit_id_);
            IF(NOT Handl_Unit_Stock_Snapshot_API.Handling_Unit_Exist(source_ref1_         => inventory_event_id_, 
                                                                     source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                                     handling_unit_id_    => outermost_hu_id_))THEN
               outermost_hu_id_ := handling_unit_id_;
            END IF;
            -- Make sure the outermost handling unit is the top parent(parent id = NULL), otherwise disconnect from that parent structure
            IF(Handling_Unit_API.Get_Parent_Handling_Unit_Id(outermost_hu_id_) IS NOT NULL) THEN
               Handling_Unit_API.Modify_Parent_Handling_Unit_Id(outermost_hu_id_, NULL);
            END IF;            
         END IF;
      END IF;
      Inventory_Part_In_Stock_API.Issue_Part(transaction_id_               => transaction_id_,
                                             catch_quantity_               => catch_qty_to_deliver_,
                                             contract_                     => contract_,
                                             part_no_                      => part_no_,
                                             configuration_id_             => configuration_id_,
                                             location_no_                  => location_no_,
                                             lot_batch_no_                 => lot_batch_no_,
                                             serial_no_                    => serial_no_,
                                             eng_chg_level_                => eng_chg_level_,
                                             waiv_dev_rej_no_              => waiv_dev_rej_no_,
                                             activity_seq_                 => activity_seq_,
                                             handling_unit_id_     		   => local_handling_unit_id_,
                                             transaction_                  => transaction_,
                                             quantity_                     => qty_to_deliver_,
                                             quantity_reserved_            => qty_reserved_,
                                             source_ref1_                  => trans_order_no_,
                                             source_ref2_                  => trans_line_no_,
                                             source_ref3_                  => trans_rel_no_,
                                             source_ref4_                  => trans_line_item_no_,
                                             source_ref5_                  => new_deliv_no_,
                                             source_                       => NULL,
                                             source_ref_type_              => NULL,
                                             dest_contract_                => customer_contract_,
                                             ignore_this_avail_control_id_ => ignore_this_avail_control_id_,
                                             validate_hu_struct_position_  => validate_hu_struct_position_,
                                             destination_warehouse_id_     => destination_warehouse_id_ );
                                             
      Inventory_Transaction_Hist_API.Set_Alt_Source_Ref(transaction_id_,
                                                        order_no_,
                                                        line_no_,
                                                        rel_no_,
                                                        line_item_no_,
                                                        new_deliv_no_,
                                                        alt_source_ref_type_db_);

      transaction_ := Inventory_Transaction_Hist_API.Get_Transaction_Code(transaction_id_);
   END IF;
   -- Unreserve remaining parts in inventory (if not 'Shipment'-location)
   IF ((total_qty_picked_ - qty_to_deliver_) > 0) AND NOT shipment_inventory_ THEN
      -- If handling unit is not zero and exist in snapshot means we are delivering whole qty. No need to unreserve stock
      -- If handling unit is not zero and not exist in snapshot and qty to deliver is greater than zero we already removed the extra reservation for 
      -- orders not in shipment inv during HU change.
      -- If handling unit is not zero and if we do not deliver any quantity, then remove reservation.
      -- If handling unit is zero we need to remove extra reservation if order was partialy delivered.
      IF (handling_unit_id_ = 0 OR qty_to_deliver_ = 0) THEN 
         Trace_SYS.Message('Unreserve remaining');
         Trace_SYS.Field('Qty unreserved', total_qty_picked_ - qty_to_deliver_);

         Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_   => dummy_number_, 
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
                                                  quantity_         => -(total_qty_picked_ - qty_to_deliver_));
      END IF;
      Update_License_Coverage_Qty___(order_no_ , line_no_, rel_no_,line_item_no_,0,(total_qty_picked_ - qty_to_deliver_));-- Export control

   END IF;
   cust_category_ := Cust_Ord_Customer_Category_API.Encode(Cust_Ord_Customer_API.Get_Category(ordrec_.customer_no));

   IF NOT ((transaction_ IN ('OESHIP', 'DELCONF-OU', 'CRO-EXD-OU')) AND cust_category_ = 'I') THEN
      diff_comp_sm_obj_ := TRUE;
   END IF;
   -- Get the create sm object option flag
   IF (linerec_.create_sm_object_option = 'CREATESMOBJECT' AND (qty_to_deliver_ > 0) AND (transaction_ NOT IN ('SHIPTRAN','SHIPDIR')) AND diff_comp_sm_obj_) THEN
      Create_Sm_Object___(order_no_, line_no_, rel_no_, line_item_no_, serial_no_);
   END IF ;
   supply_code_ := Order_Supply_Type_API.Encode(Customer_Order_Line_API.Get_Supply_Code(order_no_ , line_no_, rel_no_,line_item_no_));
   IF (qty_to_deliver_ > 0) AND (supply_code_ = 'MRO') THEN
      sup_sm_contract_ := Customer_Order_Line_API.Get_Sup_Sm_Contract(order_no_ , line_no_, rel_no_,line_item_no_);
      sup_sm_object_   := Customer_Order_Line_API.Get_Sup_Sm_Object(order_no_ , line_no_, rel_no_,line_item_no_);
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
      Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
      Client_SYS.Add_To_Attr('SUP_SM_CONTRACT', sup_sm_contract_, attr_);
      Client_SYS.Add_To_Attr('SUP_SM_OBJECT', sup_sm_object_, attr_);
      
      $IF (Component_Wo_SYS.INSTALLED) $THEN
          Active_Work_Order_Util_API.Return_Mro_Serial(attr_);
      $END        
   END IF;
END Issue_Delivered_Parts___;


-- New_Inv_Line_Delivery___
--   Modify CustomerOrderLine attributes when a new delivery has been made
--   for inventory parts.
--   This method will also create a new delivery record.
PROCEDURE New_Inv_Line_Delivery___ (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   load_id_             IN NUMBER,
   qty_delivered_       IN NUMBER,
   catch_qty_delivered_ IN NUMBER,
   close_line_          IN BOOLEAN,
   transaction_         IN VARCHAR2,
   deliv_no_            IN NUMBER,
   delnote_no_          IN VARCHAR2 )
IS
   revised_qty_due_         NUMBER;
   old_qty_shipped_         NUMBER;
   new_qty_shipped_         NUMBER;
   old_qty_assigned_        NUMBER;
   old_qty_picked_          NUMBER;
   part_cat_rec_            Part_Catalog_API.Public_Rec;
   pos_                     CUST_ORDER_LOAD_LIST_LINE_TAB.pos%TYPE;
   contract_                CUSTOMER_ORDER_TAB.contract%TYPE;
   ship_addr_no_            CUSTOMER_ORDER_LINE_TAB.ship_addr_no%TYPE;
   catalog_no_              CUSTOMER_ORDER_LINE_TAB.catalog_no%TYPE;
   part_no_                 CUSTOMER_ORDER_LINE_TAB.part_no%TYPE;
   consignment_stock_       CUSTOMER_ORDER_LINE_TAB.consignment_stock%TYPE;
   charged_item_            CUSTOMER_ORDER_LINE_TAB.charged_item%TYPE;
   price_conv_factor_       CUSTOMER_ORDER_LINE_TAB.price_conv_factor%TYPE;
   conv_factor_             CUSTOMER_ORDER_LINE_TAB.conv_factor%TYPE;
   inverted_conv_factor_    CUSTOMER_ORDER_LINE_TAB.inverted_conv_factor%TYPE;
   close_tolerance_         CUSTOMER_ORDER_LINE_TAB.close_tolerance%TYPE;
   customer_no_             CUSTOMER_ORDER_LINE_TAB.customer_no%TYPE;
   customer_part_no_        CUSTOMER_ORDER_LINE_TAB.customer_part_no%TYPE;
   create_sm_object_option_ CUSTOMER_ORDER_LINE_TAB.create_sm_object_option%TYPE;
   sup_sm_contract_         CUSTOMER_ORDER_LINE_TAB.sup_sm_contract%TYPE;
   sup_sm_object_           CUSTOMER_ORDER_LINE_TAB.sup_sm_object%TYPE;
   sale_unit_price_         NUMBER;
   discount_                CUSTOMER_ORDER_LINE_TAB.discount%TYPE;
   order_discount_          CUSTOMER_ORDER_LINE_TAB.order_discount%TYPE;
   qty_to_invoice_          NUMBER;
   cost_                    NUMBER;
   part_ownership_          VARCHAR2(20);
   location_no_             VARCHAR2(35);
   staged_billing_          VARCHAR2(20);
   qty_expected_            NUMBER;
   info_                    VARCHAR2(2000);
   sum_assigned_            NUMBER;
   sum_picked_              NUMBER;
   planned_due_date_        DATE;
   new_cost_                NUMBER;
   old_cost_                NUMBER;
   new_total_cost_          NUMBER;
   old_total_cost_          NUMBER;
   demand_code_             CUSTOMER_ORDER_LINE_TAB.demand_code%TYPE;
   supply_code_             CUSTOMER_ORDER_LINE_TAB.supply_code%TYPE;
   demand_order_ref1_       CUSTOMER_ORDER_LINE_TAB.demand_order_ref1%TYPE;
   demand_order_ref2_       CUSTOMER_ORDER_LINE_TAB.demand_order_ref2%TYPE;
   
   CURSOR get_line_attributes IS
      SELECT contract, catalog_no, part_no, revised_qty_due, qty_shipped, qty_assigned, qty_picked,
             consignment_stock, charged_item, close_tolerance, conv_factor,inverted_conv_factor, price_conv_factor,
             customer_no, ship_addr_no, customer_part_no,
             create_sm_object_option, sup_sm_contract, sup_sm_object, sale_unit_price,
             discount, order_discount, part_ownership, staged_billing, planned_due_date, cost, 
             demand_code, supply_code, demand_order_ref1, demand_order_ref2
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;
      
  CURSOR get_Location IS
      SELECT location_no
      FROM   customer_order_reservation_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    contract = contract_
      AND    part_no = part_no_
      AND    qty_picked > 0;


  CURSOR get_assigned_and_picked_qty IS
     SELECT SUM(qty_assigned), SUM(qty_picked)
     FROM customer_order_reservation_tab
        WHERE  order_no = order_no_
        AND    line_no = line_no_
        AND    rel_no = rel_no_
        AND    line_item_no = line_item_no_
        AND    contract = contract_
        AND    part_no = part_no_;
BEGIN
   OPEN  get_line_attributes;
   FETCH get_line_attributes INTO contract_, catalog_no_, part_no_, revised_qty_due_, old_qty_shipped_, old_qty_assigned_, old_qty_picked_,
                                  consignment_stock_, charged_item_, close_tolerance_, conv_factor_,inverted_conv_factor_, price_conv_factor_, customer_no_,
                                  ship_addr_no_, customer_part_no_,
                                  create_sm_object_option_, sup_sm_contract_, sup_sm_object_,
                                  sale_unit_price_, discount_, order_discount_, part_ownership_, staged_billing_, planned_due_date_, old_cost_, 
                                  demand_code_, supply_code_, demand_order_ref1_, demand_order_ref2_;
   CLOSE get_line_attributes;

   new_qty_shipped_ := old_qty_shipped_ + qty_delivered_;

   IF (qty_delivered_ > 0) THEN
      -- Added a condition to avoid updating customer order line cost for the below transactions.
      IF NOT(transaction_ IN ('CO-DELV-OU', 'DELCONF-OU')) THEN
         -- Update the cost on the order line
         -- Only needed if a new delivery has been made.
         Modify_Order_Line_Cost(transaction_, order_no_, line_no_, rel_no_, line_item_no_, new_qty_shipped_);
      END IF;
      -- Increase qty shipped on the order line
      Customer_Order_API.Set_Line_Qty_Shipped(order_no_, line_no_, rel_no_, line_item_no_, new_qty_shipped_);
   END IF;

   OPEN get_assigned_and_picked_qty;
   FETCH get_assigned_and_picked_qty INTO sum_assigned_, sum_picked_;
   CLOSE get_assigned_and_picked_qty;

   -- Note: Set assigned and picked quantities according to reservations.
   Customer_Order_API.Set_Line_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_, sum_assigned_);
   Customer_Order_API.Set_Line_Qty_Picked(order_no_, line_no_, rel_no_, line_item_no_, sum_picked_);

   -- If line is connected to a shipment list => Modify Qty_Loaded.
   IF (load_id_ IS NOT NULL) THEN
      Trace_SYS.Field('Set qty_loaded to ' || TO_CHAR(qty_delivered_) || ' on load_id', load_id_);
      pos_ := Cust_Order_Load_List_Line_API.Get_Pos(load_id_, order_no_, line_no_, rel_no_, line_item_no_);
      Cust_Order_Load_List_Line_API.Modify_Qty_Loaded(load_id_, pos_, qty_delivered_);
   END IF;
   Trace_SYS.Field('QTY_DELIVERED', qty_delivered_);

   IF (qty_delivered_ > 0) THEN
      -- Create a new delivery record
      IF (consignment_stock_ = 'CONSIGNMENT STOCK') THEN
         qty_to_invoice_ := 0;
      ELSIF (charged_item_ = 'ITEM NOT CHARGED') THEN
         qty_to_invoice_ := 0;
      ELSIF (part_ownership_ IN ('CUSTOMER OWNED', 'SUPPLIER LOANED')) THEN
         qty_to_invoice_ := 0;
      ELSIF (staged_billing_ = 'STAGED BILLING') THEN
         qty_to_invoice_ := 0;
      ELSE
         qty_to_invoice_ := (qty_delivered_ / conv_factor_ * inverted_conv_factor_);
      END IF;

      qty_expected_ := qty_to_invoice_;
      -- if using delivery confirmation the qty to invoice is set on confirmation - not at this point
      IF (Customer_Order_API.Get_Confirm_Deliveries_Db(order_no_) = 'TRUE') THEN
         qty_to_invoice_ := 0;
      END IF;
      
      new_cost_       := Customer_Order_Line_API.Get_Cost(order_no_, line_no_, rel_no_, line_item_no_);
      new_total_cost_ := new_cost_ * new_qty_shipped_;
      old_total_cost_ := old_cost_ * old_qty_shipped_;
      cost_           := (new_total_cost_ - old_total_cost_)/qty_delivered_;

      Customer_Order_Delivery_API.New(order_no_, line_no_, rel_no_, line_item_no_, Invoice_Package_Component_API.Decode('N'),
                                      load_id_, delnote_no_, NULL, qty_delivered_, catch_qty_delivered_, qty_to_invoice_, 0, 
                                      Site_API.Get_Site_Date(contract_), ship_addr_no_, NULL, cost_, deliv_no_);
                                      
      IF (staged_billing_ = 'STAGED BILLING')THEN
           Create_Delivery_Inv_Ref___(order_no_,line_no_,rel_no_,line_item_no_,deliv_no_);
      END IF;

      Create_Outstanding_Sales(deliv_no_, transaction_, order_no_, line_item_no_, qty_expected_, qty_delivered_, cost_);

      Customer_Order_Line_API.Modify_Real_Ship_Date(order_no_, line_no_, rel_no_, line_item_no_, TRUNC(Site_API.Get_Site_Date(contract_)));

      -- ------------------- SCHEDULING -----------------------------------------------
      IF Customer_Order_API.Get_Scheduling_Connection_Db(order_no_) = 'SCHEDULE' THEN
         Update_Qty_In_Scheduling___(order_no_, contract_, customer_no_, ship_addr_no_, customer_part_no_ , qty_delivered_);
      END IF;

      -- ------------- SERVICE MANAGEMENT ---------------------------------------------
      IF (create_sm_object_option_ = 'DONOTCREATESMOBJECT') AND
         (sup_sm_contract_ IS NOT NULL) AND (sup_sm_object_ IS NOT NULL) THEN
         Update_Sm_Object___(contract_, order_no_, line_no_, rel_no_, line_item_no_,
                             sup_sm_contract_, sup_sm_object_, qty_delivered_, new_cost_, conv_factor_,
                             inverted_conv_factor_, sale_unit_price_, price_conv_factor_, discount_, order_discount_);
      END IF;

      ------------------------------------------------------------------------------
      -- Check if MS Forecast Consumtion is active for the part shipped.
      -- If this is the case then update MS Forecast.
      IF part_ownership_ != 'CUSTOMER OWNED' THEN
         IF demand_code_ = 'DO' THEN
            Update_Ms_Forecast___(contract_, part_no_, qty_delivered_, planned_due_date_, TRUE);
         ELSE
            Update_Ms_Forecast___(contract_, part_no_, qty_delivered_, planned_due_date_, FALSE);
         END IF;
      END IF;
      
      $IF (Component_Cromfg_SYS.INSTALLED) $THEN
         IF (demand_code_ = 'CRE' AND supply_code_ = 'CRO') THEN
            --Approve the part automatically for cro exchange parts
            Cro_Exchange_Line_API.Approve_Part_Automatically(demand_order_ref1_,demand_order_ref2_);
         END IF; 
      $END  
   END IF;

   IF close_line_ THEN
      IF (Reserve_Customer_Order_API.Line_Reservations_Exist__(order_no_, line_no_, rel_no_, line_item_no_) = 1) THEN
         -- Not possible to close line if not pick reported pick list for same order line exists.
         Error_SYS.Record_General(lu_name_, 'RESEXISTSPICK: The order line has reservations that have not been picked. The order line cannot be closed.');
      END IF;
   END IF;
   IF (close_line_ AND (new_qty_shipped_ = 0)) THEN
      Error_SYS.Record_General(lu_name_, 'CLOSETHELINE: Can not close line when nothing is delivered. Use cancel instead');
   END IF;

   IF ((new_qty_shipped_ >= (revised_qty_due_ * (1 - close_tolerance_/100)) AND line_item_no_ = 0) OR close_line_) THEN
      IF (Reserve_Customer_Order_API.Line_Reservations_Exist__(order_no_, line_no_, rel_no_, line_item_no_) = 1) THEN
         IF close_line_ THEN
            -- Not possible to close line if not pick reported pick list for same order line exists.
            Error_SYS.Record_General(lu_name_, 'RESEXISTS: The order line has reservations that have not been delivered. The order line can not be closed.');
         ELSE
            -- Even when doing the manual Close from the header if we give this mesage how does the user know which order line has the reservations
            info_ := Language_SYS.Translate_Constant (lu_name_, 'RESEXIST: The Line No :P1, Del No :P2 has reservations that have not been picked. The order line will not be closed.', NULL, line_no_, rel_no_ );
            IF (Transaction_SYS.Is_Session_Deferred) THEN
               Transaction_SYS.Set_Status_Info(info_);
            ELSE
               Client_SYS.Add_Info(lu_name_, info_);
            END IF;
         END IF;
      ELSE
         -- There is nothing left to deliver for this line
         Customer_Order_API.Set_Line_Qty_Shipdiff(order_no_, line_no_, rel_no_, line_item_no_, new_qty_shipped_ - revised_qty_due_);
      END IF;
   ELSIF (new_qty_shipped_ < revised_qty_due_ AND Customer_Order_Line_API.Get_Qty_Shipdiff(order_no_, line_no_, rel_no_, line_item_no_)>0) THEN
      -- Need to reduce the over-picked quantity if delivered less
      Customer_Order_API.Set_Line_Qty_Shipdiff(order_no_, line_no_, rel_no_, line_item_no_, GREATEST(new_qty_shipped_ - revised_qty_due_, 0));
   END IF;
   -- Check if a message to Connectivity (to the Chemmate application should be created)
   IF (Part_Catalog_Invent_Attrib_API.Get_Hse_Contract(part_no_) IS NOT NULL AND qty_delivered_ > 0 ) THEN
      Send_Hse_Msg_On_Delivery___(customer_no_, part_no_, catalog_no_, customer_part_no_);
   END IF;

   part_cat_rec_ := Part_Catalog_API.Get(part_no_);

   IF (part_cat_rec_.catch_unit_enabled = 'TRUE' ) THEN
   -- calculate and update the new price conv factor based on the catch quantities for catch unit handled parts.
      Pick_Customer_Order_API.Recalc_Catch_Price_Conv_Factor(order_no_,
                                                             line_no_,
                                                             rel_no_,
                                                             line_item_no_);
   END IF;

   OPEN get_Location;
   FETCH get_Location INTO location_no_;
   CLOSE get_Location;

   IF (Inventory_Location_API.Get_Location_Type(contract_, location_no_) = Inventory_Location_Type_API.Decode('SHIPMENT')) THEN
   -- For a shipment location.
      IF ((old_qty_picked_ - qty_delivered_)>0) THEN
        Client_SYS.Add_Info(lu_name_,'AVAILMSG: A remaining reserved and picked qty of part :P1 on CO line :P2 exists in Shipment Inventory.',part_no_ ,line_no_);
      END IF;
   END IF;
END New_Inv_Line_Delivery___;


-- New_Non_Inv_Line_Delivery___
--   Deliver a line for for which no acquisition is needed.
--   This method will modify attributes in CustomerOrderLine, and create
--   new records in CustomerOrderDelivery as well as registering transactions
--   and bookings in InventoryTransactionHist.
PROCEDURE New_Non_Inv_Line_Delivery___ (
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,
   load_id_        IN NUMBER,
   qty_to_deliver_ IN NUMBER,
   close_          IN BOOLEAN,
   delnote_no_     IN VARCHAR2,
   shipment_id_    IN NUMBER )
IS
   transaction_       VARCHAR2(10);
   customer_contract_ VARCHAR2(5);
   transaction_id_    NUMBER;
   accounting_id_     NUMBER;
   value_             NUMBER;
   def_value_         VARCHAR2(1) := '*';
   pos_               NUMBER;
   qty_to_invoice_    NUMBER;
   cost_              NUMBER;
   number_dummy_      NUMBER;
   deliv_no_          NUMBER;
   qty_expected_      NUMBER;
   company_           VARCHAR2(20);
   site_date_         DATE;
   delay_cogs_db_     VARCHAR2(20);
   part_ownership_db_ VARCHAR2(20);
   from_service_order_ BOOLEAN := FALSE;

   CURSOR get_line_attributes IS
      SELECT contract, catalog_no, buy_qty_due, supply_code, qty_to_ship, qty_shipped, qty_shipdiff,
             conv_factor, inverted_conv_factor, price_conv_factor, customer_part_no, customer_no, ship_addr_no,
             create_sm_object_option, sup_sm_contract, sup_sm_object, sale_unit_price,
             discount, order_discount, configuration_id, cost, close_tolerance, revised_qty_due,
             staged_billing, activity_seq, project_id, job_id, rental
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;

   line_              get_line_attributes%ROWTYPE;
BEGIN
   OPEN  get_line_attributes;
   FETCH get_line_attributes INTO line_;
   CLOSE get_line_attributes;

   IF (close_ OR (qty_to_deliver_ > (line_.buy_qty_due - line_.qty_shipped))) THEN
      -- Close this line
      line_.qty_shipdiff := qty_to_deliver_ - (line_.buy_qty_due - line_.qty_shipped);
   END IF;

   IF (line_.supply_code = Order_Supply_Type_API.DB_SERVICE_ORDER )THEN
      from_service_order_ := TRUE;
   END IF;
   
   line_.qty_shipped := line_.qty_shipped + qty_to_deliver_;

   Trace_SYS.Field('LINE_.QTY_SHIPPED',line_.qty_shipped);
   
   IF (close_ AND (line_.qty_shipped = 0)) THEN
      Error_SYS.Record_General(lu_name_, 'CLOSETHELINE: Can not close line when nothing is delivered. Use cancel instead');
   END IF;

   IF (line_.qty_shipdiff != 0) THEN
      Customer_Order_API.Set_Line_Qty_Shipdiff(order_no_, line_no_,  rel_no_, line_item_no_, line_.qty_shipdiff);
   END IF;

   IF (shipment_id_ != 0) THEN
      Customer_Order_Line_API.Modify_Qty_To_Ship__(order_no_, line_no_,  rel_no_, line_item_no_, (line_.qty_to_ship - qty_to_deliver_));
   ELSE
      Customer_Order_Line_API.Modify_Qty_To_Ship__(order_no_, line_no_,  rel_no_, line_item_no_, 0);
   END IF;
         
   -- If line is connected to a shipment list => Modify Qty_Loaded.
   IF (load_id_ IS NOT NULL) THEN
      Trace_SYS.Field('Set qty_loaded to '||TO_CHAR(qty_to_deliver_)||' on load_id', load_id_);
      pos_ := Cust_Order_Load_List_Line_API.Get_Pos(load_id_, order_no_, line_no_, rel_no_, line_item_no_);
      Cust_Order_Load_List_Line_API.Modify_Qty_Loaded(load_id_, pos_, qty_to_deliver_);
   END IF;

   IF (qty_to_deliver_ != 0) THEN
      IF (line_.staged_billing = 'STAGED BILLING') THEN
         qty_to_invoice_ := 0;
      ELSE
         qty_to_invoice_ := (qty_to_deliver_ / line_.conv_factor * line_.inverted_conv_factor);
      END IF;

      qty_expected_ := qty_to_invoice_;
      -- if using delivery confirmation the qty to invoice is set on confirmation - not at this point
      IF (Customer_Order_API.Get_Confirm_Deliveries_Db(order_no_) = 'TRUE') THEN
         qty_to_invoice_ := 0;
      END IF;

      company_           := Site_API.Get_Company(line_.contract);
      site_date_         := Site_API.Get_Site_Date(line_.contract);

      customer_contract_ := Cust_Ord_Customer_API.Get_Acquisition_Site(line_.customer_no);

      IF (company_ = Site_API.Get_Company(customer_contract_)) THEN
         transaction_ := 'INTSHIP-NI';
      ELSE
         transaction_ := 'OESHIPNI';
      END IF;

      deliv_no_ := Customer_Order_Delivery_API.Get_Next_Deliv_No;
      
      IF (line_.supply_code != 'SEO') THEN
         -- Update cost for non Service Management lines
         cost_ := Sales_Part_API.Get_Cost(line_.contract, line_.catalog_no);         
      ELSE
         -- Service management lines should already have a cost on the order line
         cost_ := line_.cost;
      END IF;
      IF (line_.rental = Fnd_Boolean_API.DB_FALSE) THEN
         part_ownership_db_ := Part_Ownership_API.DB_COMPANY_OWNED;
      ELSE
         part_ownership_db_ := Part_Ownership_API.DB_COMPANY_RENTAL_ASSET;
      END IF;
      delay_cogs_db_ := Customer_Order_API.Get_Delay_Cogs_To_Dc_Db(order_no_);

      -- if delay COGS is true, the transaction is booked at delivery confirmation instead
      IF (line_.supply_code != 'SEO') AND (delay_cogs_db_ = 'FALSE') THEN
         IF (line_.supply_code = 'NO') THEN
            -- Create a new inventory transaction
            Inventory_Transaction_Hist_API.New(transaction_id_    => transaction_id_,
                                               accounting_id_     => accounting_id_,
                                               value_             => value_,
                                               transaction_code_  => transaction_,
                                               contract_          => line_.contract,
                                               part_no_           => line_.catalog_no,
                                               configuration_id_  => line_.configuration_id,
                                               location_no_       => NULL,
                                               lot_batch_no_      => def_value_,
                                               serial_no_         => def_value_,
                                               waiv_dev_rej_no_   => def_value_,
                                               eng_chg_level_     => def_value_,
                                               activity_seq_      => NULL,
                                               project_id_        => NULL,
                                               source_ref1_       => order_no_,
                                               source_ref2_       => line_no_,
                                               source_ref3_       => rel_no_,
                                               source_ref4_       => line_item_no_,
                                               source_ref5_       => deliv_no_,
                                               reject_code_       => NULL,
                                               price_             => cost_,
                                               quantity_          => qty_to_deliver_,
                                               qty_reversed_      => 0,
                                               catch_quantity_    => NULL,
                                               source_            => NULL,
                                               part_ownership_db_ => part_ownership_db_);
         ELSE
            IF ((line_.job_id IS NOT NULL) AND (line_.supply_code IN ('PT', 'IPT'))) THEN
               line_.activity_seq := 0;
            END IF;

            -- Create a new inventory transaction
            Inventory_Transaction_Hist_API.New(transaction_id_    => transaction_id_,
                                               accounting_id_     => accounting_id_,
                                               value_             => value_,
                                               transaction_code_  => transaction_,
                                               contract_          => line_.contract,
                                               part_no_           => line_.catalog_no,
                                               configuration_id_  => line_.configuration_id,
                                               location_no_       => NULL,
                                               lot_batch_no_      => def_value_,
                                               serial_no_         => def_value_,
                                               waiv_dev_rej_no_   => def_value_,
                                               eng_chg_level_     => def_value_,
                                               activity_seq_      => line_.activity_seq,
                                               project_id_        => line_.project_id,
                                               source_ref1_       => order_no_,
                                               source_ref2_       => line_no_,
                                               source_ref3_       => rel_no_,
                                               source_ref4_       => line_item_no_,
                                               source_ref5_       => deliv_no_,
                                               reject_code_       => NULL,
                                               price_             => cost_,
                                               quantity_          => qty_to_deliver_,
                                               qty_reversed_      => 0,
                                               catch_quantity_    => NULL,
                                               source_            => NULL,
                                               part_ownership_db_ => part_ownership_db_);
         END IF;
         Inventory_Transaction_Hist_API.Do_Transaction_Booking(transaction_id_, company_, 'N', NULL);
         -- Update the average cost for non Service Management lines
         Modify_Order_Line_Cost(transaction_, order_no_, line_no_, rel_no_, line_item_no_, line_.qty_shipped);
      END IF;
      
      -- Increase qty shipped on the order line
      Customer_Order_API.Set_Line_Qty_Shipped(order_no_, line_no_, rel_no_, line_item_no_, line_.qty_shipped);
      
      Update_License_Coverage_Qty___(order_no_, line_no_, rel_no_, line_item_no_,qty_to_deliver_);-- Export control
      
      -- gelr:no_delivery_note_for_services, begin
      IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(line_.contract, 'NO_DELIVERY_NOTE_FOR_SERVICES') = Fnd_boolean_API.DB_TRUE AND shipment_id_ != 0 AND delnote_no_ IS NULL) THEN
         Customer_Order_Delivery_API.New(order_no_, line_no_, rel_no_, line_item_no_,
                                         Invoice_Package_Component_API.Decode('N'), load_id_, delnote_no_, NULL,
                                         qty_to_deliver_, number_dummy_, qty_to_invoice_, 0, site_date_, line_.ship_addr_no, NULL, cost_, deliv_no_, shipment_id_ => shipment_id_);
      ELSE
      -- gelr:no_delivery_note_for_services, end
         Customer_Order_Delivery_API.New(order_no_, line_no_, rel_no_, line_item_no_,
                                         Invoice_Package_Component_API.Decode('N'), load_id_, delnote_no_, NULL,
                                         qty_to_deliver_, number_dummy_, qty_to_invoice_, 0, site_date_, line_.ship_addr_no, NULL, cost_, deliv_no_);
      END IF;      
                                      
      IF (line_.staged_billing = 'STAGED BILLING')THEN
            Create_Delivery_Inv_Ref___(order_no_,line_no_,rel_no_,line_item_no_,deliv_no_);
      END IF;

      Create_Outstanding_Sales(deliv_no_, transaction_, order_no_, line_item_no_, qty_expected_, qty_to_deliver_, cost_, NULL, from_service_order_);

      Customer_Order_Line_API.Modify_Real_Ship_Date(order_no_, line_no_, rel_no_, line_item_no_, TRUNC(site_date_));

      -- --------------- SCHEDULING  --------------------------------------------------
      IF (Customer_Order_API.Get_Scheduling_Connection_Db(order_no_) = 'SCHEDULE') THEN
         Update_Qty_In_Scheduling___(order_no_, line_.contract, line_.customer_no, line_.ship_addr_no,
                                     line_.customer_part_no , qty_to_deliver_);
      END IF;

      -- --------------- SERVICE MANAGEMENT -------------------------------------------
      IF (line_.create_sm_object_option = 'DONOTCREATESMOBJECT') AND
          (line_.sup_sm_contract IS NOT NULL) AND (line_.sup_sm_object IS NOT NULL) THEN
         Update_Sm_Object___(line_.contract, order_no_, line_no_, rel_no_, line_item_no_,
                             line_.sup_sm_contract, line_.sup_sm_object, qty_to_deliver_, cost_, line_.conv_factor, line_.inverted_conv_factor,
                             line_.sale_unit_price, line_.price_conv_factor, line_.discount, line_.order_discount);
      END IF;
   END IF;
   
   IF ((line_.qty_shipped >= (line_.revised_qty_due * (1 - line_.close_tolerance/100)) AND line_item_no_ = 0 ) OR close_) THEN
      -- There is nothing left to deliver for this line
      Customer_Order_API.Set_Line_Qty_Shipdiff(order_no_, line_no_, rel_no_, line_item_no_, line_.qty_shipped - line_.revised_qty_due);
   END IF;
END New_Non_Inv_Line_Delivery___;


-- Line_Already_Delivered___
--   Checks if the specified line exist in the attribute string.
PROCEDURE Line_Already_Delivered___ (
   line_delivered_ OUT BOOLEAN,
   order_no_       IN  VARCHAR2,
   line_no_        IN  VARCHAR2,
   rel_no_         IN  VARCHAR2,
   line_item_no_   IN  NUMBER,
   line_list_      IN  delivered_line_info )
IS
   key_ VARCHAR2(100) := 'ORDER_NO='||order_no_|| Client_SYS.field_separator_ ||
                         'LINE_NO=' ||line_no_ || Client_SYS.field_separator_ ||
                         '^REL_NO=' ||rel_no_  || Client_SYS.field_separator_ ||
                         '^LINE_ITEM_NO='|| line_item_no_;
BEGIN
   line_delivered_ := FALSE;
   IF (line_list_.COUNT > 0 ) THEN
      FOR count_ IN line_list_.FIRST..line_list_.LAST LOOP
         IF(line_list_(count_) = key_) THEN
            line_delivered_ := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
END Line_Already_Delivered___;


-- Location_Already_Delivered___
--   Checks if delivery has already been made for the specified location
--   when delivering an order line with differences.
PROCEDURE Location_Already_Delivered___ (
   location_delivered_ OUT BOOLEAN,
   location_no_        IN  VARCHAR2,
   lot_batch_no_       IN  VARCHAR2,
   serial_no_          IN  VARCHAR2,
   eng_chg_level_      IN  VARCHAR2,
   waiv_dev_rej_no_    IN  VARCHAR2,
   handling_unit_id_   IN  NUMBER )
IS
   found_ NUMBER := 0;
   CURSOR delivery_diff_control IS
      SELECT 1
      FROM  delivered_line_with_diff_tmp
      WHERE location_no       = location_no_
      AND   lot_batch_no      = lot_batch_no_
      AND   serial_no         = serial_no_
      AND   eng_chg_level     = eng_chg_level_
      AND   waiv_dev_rej_no   = waiv_dev_rej_no_
      AND   handling_unit_id  = handling_unit_id_;
BEGIN
   OPEN delivery_diff_control;
   FETCH delivery_diff_control INTO found_;
   IF (delivery_diff_control%FOUND) THEN
      Trace_SYS.Message('This location was delivered with differences');
      Trace_SYS.Field('LOCATION_NO', location_no_);
      Trace_SYS.Field('LOT_BATCH_NO', lot_batch_no_);
      Trace_SYS.Field('SERIAL_NO', serial_no_);
      Trace_SYS.Field('ENG_CHG_LEVEL', eng_chg_level_);
      Trace_SYS.Field('WAIV_DEV_REJ_NO', waiv_dev_rej_no_);
      Trace_SYS.Field('HANDLING_UNIT_ID', handling_unit_id_);
   ELSE
      found_ := 0;
   END IF;
   CLOSE delivery_diff_control;

   location_delivered_ := (found_ = 1);
END Location_Already_Delivered___;


-- Deliver_Line_Inv_With_Diff___
--   Deliver inventory line with differences.
--   All changed locations are stored in the attribute string.
--   The attr-attribute can be leaved -> Normal delivery will be made.
PROCEDURE Deliver_Line_Inv_With_Diff___ (
   info_                         OUT VARCHAR2,
   order_no_                     IN  VARCHAR2,
   line_no_                      IN  VARCHAR2,
   rel_no_                       IN  VARCHAR2,
   line_item_no_                 IN  NUMBER,
   close_line_                   IN  NUMBER,
   attr_                         IN  VARCHAR2,
   cancel_delivery_              IN  VARCHAR2,
   delnote_no_                   IN  VARCHAR2,
   shipment_id_                  IN  NUMBER,
   remove_ship_                  IN  VARCHAR2)
IS
   contract_                  CUSTOMER_ORDER_RESERVATION_TAB.contract%TYPE;
   part_no_                   CUSTOMER_ORDER_RESERVATION_TAB.part_no%TYPE;
   location_no_               CUSTOMER_ORDER_RESERVATION_TAB.location_no%TYPE;
   lot_batch_no_              CUSTOMER_ORDER_RESERVATION_TAB.lot_batch_no%TYPE;
   serial_no_                 CUSTOMER_ORDER_RESERVATION_TAB.serial_no%TYPE;
   eng_chg_level_             CUSTOMER_ORDER_RESERVATION_TAB.eng_chg_level%TYPE;
   waiv_dev_rej_no_           CUSTOMER_ORDER_RESERVATION_TAB.waiv_dev_rej_no%TYPE;
   handling_unit_id_          CUSTOMER_ORDER_RESERVATION_TAB.handling_unit_id%TYPE;
   ptr_                       NUMBER := NULL;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);
   qty_to_deliver_            NUMBER;
   line_qty_to_deliver_       NUMBER := 0;
   close_                     BOOLEAN;
   location_delivered_        BOOLEAN;
   location_attr_             VARCHAR2(32000);
   transaction_               VARCHAR2(10);
   deliv_no_                  NUMBER;   
   exchange_attr_             VARCHAR2(32000);
   bcomplete_                 VARCHAR2(1);
   input_qty_                 CUSTOMER_ORDER_RESERVATION_TAB.input_qty%TYPE;
   input_conv_factor_         CUSTOMER_ORDER_RESERVATION_TAB.input_conv_factor%TYPE;
   input_unit_meas_           CUSTOMER_ORDER_RESERVATION_TAB.input_unit_meas%TYPE;
   input_variable_values_     CUSTOMER_ORDER_RESERVATION_TAB.input_variable_values%TYPE;
   activity_seq_              NUMBER;
   catch_qty_to_deliv_        NUMBER := 0;
   line_catch_qty_to_deliv_   NUMBER := 0;
   shipment_connected_        VARCHAR2(5) := 'FALSE';
   co_line_rec_               Customer_Order_Line_API.Public_Rec;
   co_rec_                    Customer_Order_API.Public_Rec;
   inventory_event_id_        NUMBER := NULL;
   qty_picked_                NUMBER;
   snapshot_generated_        BOOLEAN := FALSE;
   unattach_handling_unit_    BOOLEAN := TRUE;
   hu_at_co_delivery_         VARCHAR2(20);
   
   CURSOR get_all_reservations IS
      SELECT location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
             SUM(qty_picked) qty_to_deliver, SUM(catch_qty) catch_qty_to_deliver, SUM(input_qty) input_qty, input_conv_factor,
             input_unit_meas, input_variable_values, activity_seq, handling_unit_id
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    shipment_id  = shipment_id_
      AND    contract = contract_
      AND    part_no = part_no_
      AND    qty_picked > 0
      AND    ((delnote_no_ IS NULL) OR (shipment_connected_ = 'TRUE') OR (delnote_no = delnote_no_))
      GROUP BY location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
               input_conv_factor, input_unit_meas, input_variable_values, activity_seq, handling_unit_id;

   CURSOR get_line_qty_to_deliver IS
      SELECT SUM(qty_to_deliver), SUM(catch_qty_to_deliv) 
      FROM   delivered_line_with_diff_tmp
      WHERE location_no != 'TEMPORARILY SAVED DELIV_NO';

   CURSOR get_saved_deliv_no IS
      SELECT deliv_no 
      FROM   delivered_line_with_diff_tmp
      WHERE location_no = 'TEMPORARILY SAVED DELIV_NO'; 
      
   CURSOR get_inv_reservations IS
      SELECT  contract, part_no, configuration_id, location_no, lot_batch_no, serial_no,
              eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, qty_picked quantity
        FROM Deliver_Customer_Order
       WHERE order_no         = order_no_
         AND   line_no        = line_no_
         AND   rel_no         = rel_no_
         AND   line_item_no   = line_item_no_;
   
   inv_part_reservation_tab_     Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
   session_started_              BOOLEAN := FALSE;
   
BEGIN
   co_rec_                    := Customer_Order_API.Get(order_no_);
   contract_                  := co_rec_.contract;
   co_line_rec_               := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   part_no_                   := co_line_rec_.part_no;
   shipment_connected_        := co_line_rec_.shipment_connected;
   
   Client_SYS.Clear_Attr(location_attr_);

   -- if line shall be closed after delivery.
   close_     := (close_line_ = 1);
   
   -- If this method is called in a loop in the same session, get already generated deliv_no of previous itteration
   OPEN get_saved_deliv_no;
   FETCH get_saved_deliv_no INTO deliv_no_;
   CLOSE get_saved_deliv_no;
   IF deliv_no_ IS NULL THEN
      deliv_no_  := Customer_Order_Delivery_API.Get_Next_Deliv_No;
      -- Save deliv_no in qty_to_deliver with location_no as 'TEMPORARILY SAVED DELIV_NO', to be used if this method is called in a loop
      Fill_Temporary_Table___('TEMPORARILY SAVED DELIV_NO',
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                              deliv_no_);
   END IF;

   bcomplete_ := 'Y';
   
   hu_at_co_delivery_ := Cust_Ord_Customer_API.Get_Handl_Unit_At_Co_Delive_Db(co_line_rec_.deliver_to_customer_no);
   IF hu_at_co_delivery_ = Handl_Unit_At_Co_Delivery_API.DB_USE_SITE_DEFAULT THEN 
      unattach_handling_unit_ := Site_Discom_Info_API.Get_Unattach_Hu_At_Delivery_Db(contract_) = 'TRUE';
   ELSE 
      unattach_handling_unit_ := hu_at_co_delivery_ = Handl_Unit_At_Co_Delivery_API.DB_UNATTACH;
   END IF;

   inventory_event_id_ := Inventory_Event_Manager_API.Get_Session_Id;
   -- No snapshot was generated before entering this method, so we need to generate one
   IF(NOT Handl_Unit_Stock_Snapshot_API.Snapshot_Exist(source_ref1_        => inventory_event_id_, 
                                                       source_ref_type_db_ => Handl_Unit_Snapshot_Type_API.DB_DELIVERY)) THEN
      OPEN get_inv_reservations;
      FETCH get_inv_reservations BULK COLLECT INTO inv_part_reservation_tab_;
      CLOSE get_inv_reservations;
      -- If order uses shipment inventory we will not unaatache the handling unit at delivery and snapshot should be generated. otherwise we dont need to generate snapshot.
      IF shipment_id_ != 0 OR NOT unattach_handling_unit_ THEN 
         IF inventory_event_id_ IS NULL THEN 
            Inventory_Event_Manager_API.Start_Session;
            inventory_event_id_ := Inventory_Event_Manager_API.Get_Session_Id;
            session_started_ := TRUE;
         END IF;
         Handl_Unit_Snapshot_Util_API.Generate_Snapshot(source_ref1_          => inventory_event_id_,
                                                        source_ref_type_db_   => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                        inv_part_stock_tab_   => inv_part_reservation_tab_);

         snapshot_generated_ := TRUE;
      END IF;
   -- If order does not use shipment inventory and customer/site setting says to unattach Hu at delivery we remove the handling units in inv_part_reservation_tab_ from snapshot.
   -- We don't remove the entire snapshot since the snapshot was created in another lu and might have diferent source of data than get_inv_reservations cursor.
   ELSIF shipment_id_ = 0 AND unattach_handling_unit_ THEN 
      FOR i IN inv_part_reservation_tab_.FIRST..inv_part_reservation_tab_.LAST LOOP
            IF Handl_Unit_Stock_Snapshot_API.Handling_Unit_Exist(source_ref1_         => inventory_event_id_, 
                                                                  source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                                  handling_unit_id_    => inv_part_reservation_tab_(i).handling_unit_id) THEN

               Handl_Unit_Stock_Snapshot_API.Remove_Handling_Unit(source_ref1_         => inventory_event_id_,
                                                                  source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                                  handling_unit_id_    => inv_part_reservation_tab_(i).handling_unit_id);
            END IF;
      END LOOP;
   END IF;
   
   
 
   IF (attr_ IS NOT NULL) THEN
      -- Deliver with differences
      -- Retrieve all records to be delivered from the attribute string.
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
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
         ELSIF (name_ = 'ROW_COMPLETE') THEN
            bcomplete_ := value_;
         ELSIF (name_ = 'INPUT_QUANTITY') THEN
            input_qty_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'INPUT_CONV_FACTOR') THEN
            input_conv_factor_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'INPUT_UNIT_MEAS') THEN
            input_unit_meas_ := value_;
         ELSIF (name_ = 'INPUT_VARIABLE_VALUES') THEN
            input_variable_values_ := value_;
         ELSIF (name_ = 'ACTIVITY_SEQ') THEN
            activity_seq_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
            handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'INVENTORY_EVENT_ID') THEN
            inventory_event_id_ := NVL(inventory_event_id_, Client_SYS.Attr_Value_To_Number(value_));
         ELSIF (name_ = 'CATCH_QTY_TO_DELIVER') THEN
            catch_qty_to_deliv_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'QTY_PICKED') THEN
            qty_picked_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'QTY_TO_DELIVER') THEN
            qty_to_deliver_ := Client_SYS.Attr_Value_To_Number(value_);
            
            Trace_SYS.Field('QTY_TO_DELIVER', qty_to_deliver_);
            Trace_SYS.Field('QTY_PICKED', qty_picked_);
            
            
            -- (Check if hu is NOT in snapshot OR Qty to deliver is less than picked qty) =>  Whole handling unit should not be delivered => Unpack reservations
            IF (Handl_Unit_Stock_Snapshot_API.Handling_Unit_Exist(source_ref1_         => inventory_event_id_, 
                                                                  source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                                  handling_unit_id_    => handling_unit_id_) AND qty_to_deliver_ < qty_picked_ ) THEN

               Handl_Unit_Stock_Snapshot_API.Remove_Handling_Unit(source_ref1_         => inventory_event_id_,
                                                                  source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_DELIVERY, 
                                                                  handling_unit_id_    => handling_unit_id_);
            END IF;

            -- Store all locations that are changed in the temporary table.
            Fill_Temporary_Table___(location_no_,
                                    lot_batch_no_,
                                    serial_no_,
                                    eng_chg_level_,
                                    waiv_dev_rej_no_,
                                    handling_unit_id_,
                                    qty_to_deliver_,
                                    catch_qty_to_deliv_,
                                    NULL);

            Issue_Delivered_Parts___(transaction_, 
                                     catch_qty_to_deliv_, 
                                     order_no_, 
                                     line_no_, 
                                     rel_no_, 
                                     line_item_no_,
                                     location_no_, 
                                     lot_batch_no_, 
                                     serial_no_, 
                                     eng_chg_level_,
                                     waiv_dev_rej_no_, 
                                     qty_to_deliver_, 
                                     deliv_no_,
                                     input_qty_, 
                                     input_unit_meas_, 
                                     input_conv_factor_,
                                     input_variable_values_, 
                                     NVL(activity_seq_, 0), 
                                     handling_unit_id_, 
                                     shipment_id_, 
                                     remove_ship_);
         ELSIF (name_ = 'END_OF_LINE') THEN
            NULL;
         END IF;
         -- Get next line from attribute string
      END LOOP;
   END IF;
   
   -- Loop through all remaining reservations not included in the attr_
   -- If the location_attr_ is null -> Normal delivery is made
   IF bcomplete_ = 'Y' THEN
      OPEN get_line_qty_to_deliver;
      FETCH get_line_qty_to_deliver INTO line_qty_to_deliver_, line_catch_qty_to_deliv_;
      CLOSE get_line_qty_to_deliver;
      
      line_qty_to_deliver_     := NVL(line_qty_to_deliver_, 0);
      line_catch_qty_to_deliv_ := NVL(line_catch_qty_to_deliv_, 0);
      Trace_SYS.Field('Total diff delivery was', line_qty_to_deliver_);
      FOR next_ IN get_all_reservations LOOP
         Location_Already_Delivered___(location_delivered_, next_.location_no, next_.lot_batch_no, next_.serial_no,
                                       next_.eng_chg_level, next_.waiv_dev_rej_no, next_.handling_unit_id);
         IF NOT location_delivered_ THEN
            IF (cancel_delivery_ = 'TRUE') THEN
               qty_to_deliver_ := 0;
               IF (next_.catch_qty_to_deliver IS NOT NULL) THEN
                  catch_qty_to_deliv_ := 0;
               END IF;
            ELSE
               qty_to_deliver_     :=  next_.qty_to_deliver;
               catch_qty_to_deliv_ :=  next_.catch_qty_to_deliver;
            END IF;
            line_qty_to_deliver_     := line_qty_to_deliver_ + qty_to_deliver_;
            line_catch_qty_to_deliv_ := line_catch_qty_to_deliv_ + catch_qty_to_deliv_;

            Issue_Delivered_Parts___(transaction_                 => transaction_, 
                                     catch_qty_to_deliver_        => catch_qty_to_deliv_, 
                                     order_no_                    => order_no_, 
                                     line_no_                     => line_no_, 
                                     rel_no_                      => rel_no_, 
                                     line_item_no_                => line_item_no_, 
                                     location_no_                 => next_.location_no,
                                     lot_batch_no_                => next_.lot_batch_no, 
                                     serial_no_                   => next_.serial_no, 
                                     eng_chg_level_               => next_.eng_chg_level, 
                                     waiv_dev_rej_no_             => next_.waiv_dev_rej_no,
                                     qty_to_deliver_              => qty_to_deliver_, 
                                     deliv_no_                    => deliv_no_,
                                     input_qty_                   => next_.input_qty, 
                                     input_unit_meas_             => next_.input_unit_meas, 
                                     input_conv_factor_           => next_.input_conv_factor,
                                     input_variable_values_       => next_.input_variable_values, 
                                     activity_seq_                => NVL(next_.activity_seq, 0), 
                                     handling_unit_id_            => next_.handling_unit_id, 
                                     shipment_id_                 => shipment_id_, 
                                     remove_ship_                 => 'FALSE');
            serial_no_    := next_.serial_no;
            lot_batch_no_ := next_.lot_batch_no;
         END IF;
      END LOOP;      

      -- Note: Modify the exchange component details after shipping the part.      
      IF (co_line_rec_.exchange_item = 'EXCHANGED ITEM' AND line_qty_to_deliver_ > 0) THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN   
            Client_Sys.Clear_Attr(exchange_attr_);
            Client_SYS.Add_To_Attr('EXCHANGE_PART_SHIPPED_DB', 'SHIPPED', exchange_attr_);
            IF (serial_no_ = '*') THEN
               serial_no_ := NULL;
            END IF;
            IF (lot_batch_no_ = '*') THEN
               lot_batch_no_ := NULL;
            END IF;
            Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, exchange_attr_);
            Client_SYS.Add_To_Attr('LOT_BATCH_NO', lot_batch_no_, exchange_attr_);
            Client_SYS.Add_To_Attr('CONDITION_CODE', co_line_rec_.condition_code, exchange_attr_);

            DECLARE
               po_order_no_ VARCHAR2(12);
               po_line_no_  VARCHAR2(4);
               po_rel_no_   VARCHAR2(4);
            BEGIN
               Pur_Order_Exchange_Comp_API.Get_Connected_Po_Info(po_order_no_, po_line_no_, po_rel_no_, order_no_, line_no_, rel_no_, line_item_no_);
               Pur_Order_Exchange_Comp_API.Modify(exchange_attr_, po_order_no_, po_line_no_, po_rel_no_ );
            END;
         $ELSE
            NULL;
         $END            
      END IF;

      -- Update order line with new quantity.
      New_Inv_Line_Delivery___(order_no_, line_no_, rel_no_, line_item_no_, NULL, line_qty_to_deliver_, line_catch_qty_to_deliv_,
                               close_, transaction_, deliv_no_, delnote_no_);

      -- Remove the temporarily saved deliv_no_ once used in creating a customer_order_delivery_tab record as it is the key in table.
      -- Then a new one will be fetched for next call to this method in the same transaction.
      Clear_Temp_Table_Deliv_No___;
      
      info_ := Client_SYS.Get_All_Info;
      Trace_SYS.Field('Total delivery was', line_qty_to_deliver_);

      -- Modify package header if any package parts delivered
      IF (line_qty_to_deliver_ > 0) THEN
         Deliver_Complete_Packages___(order_no_, delnote_no_);

         Update_License_Coverage_Qty___(order_no_, line_no_, rel_no_, line_item_no_, line_qty_to_deliver_);-- Export control
      END IF;
   END IF;
   
   IF(snapshot_generated_) THEN
      Handl_Unit_Snapshot_Util_API.Delete_Snapshot(source_ref1_         => inventory_event_id_, 
                                                   source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_DELIVERY);
      IF session_started_ THEN 
         Inventory_Event_Manager_API.Finish_Session;                                                   
      END IF;
   END IF;
   
   --After a customer order delivery , this informs the DistributionOrder that a
   --delivery has been performed.This is only done ,if the customer order has been
   --created from a distribution order and order does not use shipment inventory.
   $IF (Component_Disord_SYS.INSTALLED) $THEN   
      IF (shipment_id_ = 0 AND co_line_rec_.demand_code = 'DO' AND line_qty_to_deliver_ > 0) THEN
         Distribution_Order_API.Customer_Order_Delivered(co_line_rec_.demand_order_ref1, 
                                                         deliv_no_);
      END IF;
   $END
END Deliver_Line_Inv_With_Diff___;


-- Deliver_Line_Non_With_Diff___
--   Deliver line with no acquisition with differences.
--   The qty_to_deliver-attribute can be leaved -> Normal delivery will be made.
PROCEDURE Deliver_Line_Non_With_Diff___ (
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   line_item_no_    IN NUMBER,
   close_line_      IN NUMBER,
   qty_to_deliver_  IN NUMBER,
   cancel_delivery_ IN VARCHAR2,
   delnote_no_      IN VARCHAR2,
   shipment_id_     IN NUMBER)
IS
   close_       BOOLEAN := FALSE;
   qty_to_ship_ NUMBER := NULL;

   CURSOR find_non_inventory IS
      SELECT qty_to_ship
      FROM   CUSTOMER_ORDER_LINE_TAB col
      WHERE  col.order_no = order_no_
      AND    col.line_no = line_no_
      AND    col.rel_no = rel_no_
      AND    col.line_item_no = line_item_no_
      AND    col.supply_code != 'PD'
      AND    col.qty_to_ship > 0
      AND    col.line_item_no >= 0
      AND    col.rowstate != 'Cancelled'
      AND  NOT EXISTS (SELECT 1
                       FROM   CUST_ORDER_LOAD_LIST_TAB ll
                       WHERE  ll.load_id = col.load_id
                       AND    ll.load_list_state = 'NOTDEL');
BEGIN
   IF (qty_to_deliver_ IS NULL) THEN
      -- Normal deliver
      IF (shipment_id_ = 0) THEN
         OPEN  find_non_inventory;
         FETCH find_non_inventory INTO qty_to_ship_;
         CLOSE find_non_inventory;
      ELSE
         qty_to_ship_ := Shipment_Line_API.Get_Qty_To_Ship_By_Source(shipment_id_, order_no_, line_no_, rel_no_,
                                                                     line_item_no_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);  
      END IF;
   ELSE
      -- Deliver with differences
      qty_to_ship_ := qty_to_deliver_;

      IF (close_line_ = 1) THEN
         -- line shall be closed after delivery.
         close_ := TRUE;
      END IF;
   END IF;

   IF (qty_to_ship_ IS NOT NULL) THEN
      Trace_SYS.Message('Delivers new line');
      Trace_SYS.Field('LINE_NO', line_no_);
      Trace_SYS.Field('REL_NO', rel_no_);
      Trace_SYS.Field('LINE_ITEM_NO', line_item_no_);
      Trace_SYS.Field('CLOSE_LINE', close_);
      Trace_SYS.Field('QTY_TO_SHIP', qty_to_deliver_);
      IF (cancel_delivery_ = 'TRUE') THEN
         qty_to_ship_ := 0;
      END IF;
      -- Update order line with new quantity.
      New_Non_Inv_Line_Delivery___(order_no_, line_no_, rel_no_, line_item_no_, load_id_ => NULL, qty_to_deliver_ => qty_to_ship_,
                                   close_ => close_, delnote_no_ => delnote_no_, shipment_id_ => shipment_id_);   
      -- Modify package header if any package parts delivered
      Deliver_Complete_Packages___(order_no_, delnote_no_);
   END IF;
END Deliver_Line_Non_With_Diff___;


PROCEDURE Update_Ms_Forecast___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   qty_shipped_      IN NUMBER,
   planned_due_date_ IN DATE,
   dependent_demand_ IN BOOLEAN )
IS
BEGIN
   -- Make different calls depending on the installed version of Massch/MRP
   $IF (Component_Mrp_SYS.INSTALLED) $THEN    
      $IF (Component_Massch_SYS.INSTALLED) $THEN   
      -- Update MASSCH forecast consumtion
         Level_1_Forecast_Util_API.Shipment_Update(contract_, part_no_, qty_shipped_, planned_due_date_, dependent_demand_ );
      $ELSIF (Component_Mrp_SYS.INSTALLED) $THEN
         -- Update MRP Spares forecast consumtion
         Spare_Part_Forecast_Util_API.Shipment_Update(contract_, part_no_, qty_shipped_, planned_due_date_ );
      $ELSE
         RETURN;
      $END
   $ELSE
      RETURN;
   $END

   Trace_SYS.Field('contract', contract_);
   Trace_SYS.Field('part_no', part_no_);
   Trace_SYS.Field('qty_shipped', qty_shipped_);
END Update_Ms_Forecast___;


-- Create_Sm_Object___
--   Upon delivery there is a possible creation of a service management object.
--   Generate a call to the Equipment module when delivering an order line
--   for which the create_sm_object flag i set.
PROCEDURE Create_Sm_Object___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   serial_no_    IN VARCHAR2 )
IS
   attr_                    VARCHAR2(1000);
   company_                 VARCHAR2(20);
   customer_no_             CUSTOMER_ORDER_LINE_TAB.customer_no%TYPE;
   contract_                CUSTOMER_ORDER_LINE_TAB.contract%TYPE;
   base_sale_unit_price_    NUMBER;
   vendor_no_               CUSTOMER_ORDER_LINE_TAB.vendor_no%TYPE;
   catalog_no_              CUSTOMER_ORDER_LINE_TAB.catalog_no%TYPE;
   part_no_                 CUSTOMER_ORDER_LINE_TAB.part_no%TYPE;
   address_rec_             Cust_Order_Line_Address_API.Co_Line_Addr_Rec;
   sup_sm_contract_         CUSTOMER_ORDER_LINE_TAB.sup_sm_contract%TYPE;
   sup_sm_object_           CUSTOMER_ORDER_LINE_TAB.sup_sm_object%TYPE;
   co_line_with_error_      VARCHAR2(25);
   create_sm_object_option_ VARCHAR2(20);
   db_false_                VARCHAR2(5)  := Fnd_Boolean_API.db_false;

   CURSOR order_line_attributes IS
      SELECT customer_no, contract,
             base_sale_unit_price, vendor_no,
             catalog_no, part_no,
             sup_sm_contract, sup_sm_object, create_sm_object_option
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   -- get the create sm object option flag,
   $IF (Component_Equip_SYS.INSTALLED) $THEN
      -- if its checked then get the actual parameters for the SM-function call
      OPEN order_line_attributes;
      FETCH order_line_attributes INTO customer_no_, contract_, base_sale_unit_price_,
         vendor_no_, catalog_no_, part_no_, sup_sm_contract_, sup_sm_object_, create_sm_object_option_;
      IF (order_line_attributes%NOTFOUND)THEN
         CLOSE order_line_attributes;
         Trace_SYS.Field('SM object not created for order -- LINE DONT EXIST', order_no_);
         Trace_SYS.Field('LINE_NO', line_no_);
         Trace_SYS.Field('REL_NO', rel_no_);
         Trace_SYS.Field('LINE_ITEM_NO', line_item_no_);
      ELSE
         CLOSE order_line_attributes;
         IF (create_sm_object_option_ = 'CREATESMOBJECT') AND (Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = db_false_) THEN
            co_line_with_error_  :=  order_no_ || '-' || line_no_ || '-' || rel_no_;
            Error_SYS.Record_General(lu_name_, 'SMNOTALLOWEDCOL: If the Create SM Object check box is selected on the customer order line :P1, it is required that the serial tracking is enabled for the part :P2.', co_line_with_error_, part_no_);
         END IF;

         company_ := Site_API.Get_Company(contract_);

         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
         Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_no_, attr_);
         Client_SYS.Add_To_Attr('AGREEMENT_ID', Customer_Order_API.Get_Agreement_Id(order_no_), attr_);
         Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
         Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE', base_sale_unit_price_, attr_);
         Client_SYS.Add_To_Attr('DELIVERY_DATE', Site_API.Get_Site_Date(contract_), attr_);
         Client_SYS.Add_To_Attr('SUPPLIER', vendor_no_, attr_);

         address_rec_ :=  Cust_Order_Line_Address_API.Get_Co_Line_Addr(order_no_, line_no_, rel_no_, line_item_no_);

         Client_SYS.Add_To_Attr('ADDRESS_NAME', address_rec_.addr_1, attr_);
         Client_SYS.Add_To_Attr('ADDRESS1', address_rec_.address1, attr_);
         Client_SYS.Add_To_Attr('ADDRESS2', address_rec_.address2, attr_);
         Client_SYS.Add_To_Attr('ZIP_CODE', address_rec_.zip_code, attr_);
         Client_SYS.Add_To_Attr('CITY', address_rec_.city, attr_);
         Client_SYS.Add_To_Attr('STATE', address_rec_.state, attr_);
         Client_SYS.Add_To_Attr('COUNTY', address_rec_.county, attr_);
         Client_SYS.Add_To_Attr('COUNTRY_CODE', address_rec_.country_code, attr_);
         Client_SYS.Add_To_Attr('ADDRESS3', address_rec_.address3, attr_);
         Client_SYS.Add_To_Attr('ADDRESS4', address_rec_.address4, attr_);
         Client_SYS.Add_To_Attr('ADDRESS5', address_rec_.address5, attr_);
         Client_SYS.Add_To_Attr('ADDRESS6', address_rec_.address6, attr_);
         Client_SYS.Add_To_Attr('CATALOG_NO', catalog_no_, attr_);
         Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
         Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, attr_);
         Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
         Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
         Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
         Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
         Client_SYS.Add_To_Attr('SUP_SM_CONTRACT', sup_sm_contract_, attr_);
         Client_SYS.Add_To_Attr('SUP_SM_OBJECT', sup_sm_object_, attr_);

         -- create a dynamic sql-statement to execute the SM-function
         Equipment_Serial_Utility_API.Create_Object (attr_);

         Trace_SYS.Field('SM object created for order', order_no_);
         Trace_SYS.Field('LINE_NO', line_no_);
         Trace_SYS.Field('REL_NO', rel_no_);
         Trace_SYS.Field('LINE_ITEM_NO', line_item_no_);
      END IF;
   $ELSE
      Trace_SYS.Field('SM object not created for order -- no SM', order_no_);
      Trace_SYS.Field('LINE_NO', line_no_);
      Trace_SYS.Field('REL_NO', rel_no_);
      Trace_SYS.Field('LINE_ITEM_NO', line_item_no_);
   $END
END Create_Sm_Object___;


-- Update_Qty_In_Scheduling___
--   This procedure does a dynamic call to Cust_Sched_Cum_Management_API.Update_Cum_Qty
PROCEDURE Update_Qty_In_Scheduling___ (
   order_no_         IN VARCHAR2,
   contract_         IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   ship_addr_no_     IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   qty_shipped_      IN NUMBER )
IS
BEGIN
   $IF (Component_Cussch_SYS.INSTALLED) $THEN
      Cust_Sched_Cum_Manager_API.Update_Cum_Qty(order_no_, customer_no_, ship_addr_no_, contract_, customer_part_no_, qty_shipped_);
   $ELSE
      NULL;
   $END 
END Update_Qty_In_Scheduling___;

-- Modified parameter base_sale_unit_price_ to sale_unit_price_. 
--            Calculations should be done using order currency and then should convert to base amounts. 
PROCEDURE Update_Sm_Object___ (
   contract_             IN VARCHAR2,
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER,
   sup_sm_contract_      IN VARCHAR2,
   sup_sm_object_        IN VARCHAR2,
   qty_to_deliver_       IN NUMBER,
   cost_                 IN NUMBER,
   conv_factor_          IN NUMBER,
   inverted_conv_factor_ IN NUMBER,
   sale_unit_price_      IN NUMBER,
   price_conv_factor_    IN NUMBER,
   discount_             IN NUMBER,
   order_discount_       IN NUMBER )
IS
   attr_              VARCHAR2(1000);
   total_base_amount_ NUMBER;
   total_base_cost_   NUMBER;
   company_           VARCHAR2(20);
   rounding_          NUMBER;
   currency_code_     VARCHAR2(3);
   add_discount_      NUMBER;
   total_amount_      NUMBER;
   line_discount_     NUMBER;
   curr_rounding_     NUMBER;
   curr_rate_         NUMBER;
   amount_with_disc_  NUMBER;

   CURSOR get_currency_rate IS
      SELECT currency_rate
      FROM  CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   $IF (Component_Equip_SYS.INSTALLED) $THEN
      company_         := Site_API.Get_Company(contract_);
      currency_code_   := Company_Finance_API.Get_Currency_Code(company_);
      rounding_        := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);

      total_base_cost_ := cost_ * qty_to_deliver_;

      add_discount_    := CUSTOMER_ORDER_LINE_API.Get_Additional_Discount(order_no_, line_no_, rel_no_, line_item_no_);

      -- NOTE: When using price including tax, discount calculation is not modified as this pakage was not handled in price including tax is specified.
      curr_rounding_   := Customer_Order_API.Get_Order_Currency_Rounding(order_no_);
      IF (Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_) = 'TRUE') THEN
         total_amount_ := ROUND((qty_to_deliver_/conv_factor_ * inverted_conv_factor_) * sale_unit_price_ * price_conv_factor_ *
                                             (1 - discount_ / 100) * (1 - (order_discount_ + add_discount_) / 100), curr_rounding_);
      ELSE
         line_discount_    := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(order_no_, line_no_, rel_no_, line_item_no_, 
                                                                                   (qty_to_deliver_/conv_factor_ * inverted_conv_factor_) ,
                                                                                   price_conv_factor_,  curr_rounding_);
         amount_with_disc_ := (qty_to_deliver_/conv_factor_ * inverted_conv_factor_) * sale_unit_price_ * price_conv_factor_;
         total_amount_     := ROUND((amount_with_disc_ - line_discount_)* (1 - (order_discount_ + add_discount_) / 100), curr_rounding_) ;
      END IF;

      OPEN get_currency_rate;
      FETCH get_currency_rate INTO curr_rate_;
      CLOSE get_currency_rate;

      total_base_amount_ := ROUND(total_amount_ * curr_rate_ ,rounding_);
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('SOURCE_REF1', order_no_, attr_);
      Client_SYS.Add_To_Attr('SOURCE_REF2', line_no_, attr_);
      Client_SYS.Add_To_Attr('SOURCE_REF3', rel_no_, attr_);
      Client_SYS.Add_To_Attr('SOURCE_REF4', line_item_no_, attr_);

      Equipment_Structure_Cost_API.Update_Cost_Revenue(sup_sm_contract_, sup_sm_object_, total_base_cost_, total_base_amount_, attr_);   
   $ELSE
      NULL;        
   $END
END Update_Sm_Object___;


-- Send_Hse_Msg_On_Delivery___
--   Send a message to Connectivity (for transfer to the Chemmate application)
--   when a delivery has been made for an inventory part with the HSEContract
--   attribute set in part catalog.
PROCEDURE Send_Hse_Msg_On_Delivery___ (
   customer_no_      IN VARCHAR2,
   part_no_          IN VARCHAR2,
   catalog_no_       IN VARCHAR2,
   customer_part_no_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   message_id_ NUMBER;
BEGIN
   -- Create Connectivity Message Header
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CLASS_ID', 'HSE_CUST_ORDER_DELIVERY.ADD', attr_);
   Client_SYS.Add_To_Attr('MEDIA_CODE', 'MHS', attr_);
   Client_SYS.Add_To_Attr('RECEIVER', 'HSE', attr_);
   Client_SYS.Add_To_Attr('SENDER', 'IFSAPP', attr_);
   Connectivity_SYS.Create_Message(message_id_, attr_);
   -- Create Connectivity Outbox Line
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('MESSAGE_ID', message_id_, attr_);
   Client_SYS.Add_To_Attr('MESSAGE_LINE', 1, attr_);
   Client_SYS.Add_To_Attr('NAME', 'HEADER', attr_);
   Client_SYS.Add_To_Attr('C00', customer_no_, attr_);
   Client_SYS.Add_To_Attr('C01', part_no_, attr_);
   Client_SYS.Add_To_Attr('C02', catalog_no_, attr_);
   IF (customer_part_no_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('C03', customer_part_no_, attr_);
   END IF;

   Connectivity_SYS.Create_Message_Line(attr_);
   Connectivity_SYS.Release_Message(message_id_);
END Send_Hse_Msg_On_Delivery___;


-- Deliver_Package_If_Complete___
--   Check if delivered parts for the specified package add up to one or
--   more complete package deliveries. If this is the case the update the
--   package header row in CustomerOrderLine and create a new delivery
--   record for the package header row.
PROCEDURE Deliver_Package_If_Complete___ (
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   date_delivered_ IN DATE,
   transaction_    IN VARCHAR2 DEFAULT 'OESHIP',
   delnote_no_     IN VARCHAR2 )
IS
   qty_shipped_             NUMBER := 0;
   qty_to_ship_             NUMBER;
   new_qty_to_ship_         NUMBER;
   revised_qty_due_         NUMBER;
   close_tolerance_         CUSTOMER_ORDER_LINE_TAB.close_tolerance%TYPE;
   conv_factor_             CUSTOMER_ORDER_LINE_TAB.conv_factor%TYPE;
   inverted_conv_factor_    CUSTOMER_ORDER_LINE_TAB.inverted_conv_factor%TYPE;
   price_conv_factor_       CUSTOMER_ORDER_LINE_TAB.price_conv_factor%TYPE;
   rowstate_                CUSTOMER_ORDER_LINE_TAB.rowstate%TYPE;
   packages_shipped_        NUMBER := 0;
   new_packages_shipped_    NUMBER := 0;
   new_packages_to_invoice_ NUMBER;
   component_number_        NUMBER := 0;
   component_shipped_       NUMBER := 0;
   number_dummy_            NUMBER := NULL;
   staged_billing_          VARCHAR2(20);
   deliv_no_                NUMBER;
   qty_expected_            NUMBER;
   info_                    VARCHAR2(2000);
   res_exist_               BOOLEAN := FALSE;
   ship_addr_no_            VARCHAR2(50);
   old_total_cost_          NUMBER;
   new_total_cost_          NUMBER;
   cost_                    NUMBER; 

   CURSOR get_package_attributes IS
      SELECT qty_shipped, qty_to_ship, revised_qty_due, conv_factor, inverted_conv_factor, price_conv_factor,
      close_tolerance, rowstate, staged_billing, ship_addr_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = -1;

   CURSOR get_packages_shipped IS
      SELECT NVL(MIN(TRUNC(qty_shipped * inverted_conv_factor/conv_factor/qty_per_assembly)),0)
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    line_item_no > 0
      AND    rowstate != 'Cancelled'
      AND    new_comp_after_delivery = 'FALSE';

   CURSOR get_component_rowstate IS
      SELECT rowstate
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    line_item_no > 0
      AND    rowstate != 'Cancelled';

    CURSOR get_components IS
      SELECT part_no, line_item_no, qty_shipped, revised_qty_due
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      AND    rowstate != 'Cancelled';
    
   CURSOR get_total_cost IS
      SELECT NVL(sum(qty_shipped * cost), 0)
      FROM  CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no > 0
      AND   rowstate != 'Cancelled';
BEGIN
   OPEN  get_package_attributes;
   FETCH get_package_attributes INTO qty_shipped_, qty_to_ship_, revised_qty_due_, conv_factor_, inverted_conv_factor_, price_conv_factor_,
                                     close_tolerance_, rowstate_, staged_billing_, ship_addr_no_;
   CLOSE get_package_attributes;

   OPEN  get_packages_shipped;
   FETCH get_packages_shipped INTO packages_shipped_;
   CLOSE get_packages_shipped;
   
   OPEN  get_total_cost;
   FETCH get_total_cost INTO new_total_cost_;
   CLOSE get_total_cost;

   FOR rec_ IN get_component_rowstate LOOP
      component_number_ := component_number_ + 1;
      IF (rec_.rowstate = 'Delivered') THEN
         component_shipped_ := component_shipped_ + 1;
      END IF;
   END LOOP;

   IF (packages_shipped_ > qty_shipped_) THEN
      -- One or more complete packages have been shipped
      new_qty_to_ship_ := GREATEST(qty_to_ship_ - (packages_shipped_ - qty_shipped_), 0);
      Customer_Order_Line_API.Modify_Qty_To_Ship__(order_no_, line_no_, rel_no_, -1, new_qty_to_ship_);

      IF (packages_shipped_ >= (revised_qty_due_ * (1 - close_tolerance_/100))) THEN
         -- All packages shipped.
         -- Check for existing reservations for any of the component parts.
         FOR comp_rec_ IN get_components LOOP
            -- Check for only inventory components.
            IF (comp_rec_.part_no IS NOT NULL) THEN
               -- If a reservation exist for a inventory component part
               -- set res_exist_ to TRUE and exit the loop.
               IF (Reserve_Customer_Order_API.Line_Reservations_Exist__(order_no_, line_no_, rel_no_, comp_rec_.line_item_no) = 1) THEN
                  res_exist_ := TRUE;
                  EXIT;
               END IF;
            END IF;
         END LOOP;

         IF (res_exist_ = FALSE) THEN
            -- No existing reservations for any of the components, therefore update the qty ship diff of the components.
            FOR comp_rec_ IN get_components LOOP
               Customer_Order_API.Set_Line_Qty_Shipdiff(order_no_, line_no_, rel_no_, comp_rec_.line_item_no, comp_rec_.qty_shipped - comp_rec_.revised_qty_due);
            END LOOP;
            -- If no reservations exist for any of the components of the package, update the Qty Ship diff for the package part.
            Customer_Order_API.Set_Line_Qty_Shipdiff(order_no_, line_no_, rel_no_, -1, packages_shipped_ - revised_qty_due_);
         ELSE
            -- Inform the user about the existing reservation that had not been picked.
            info_ := Language_SYS.Translate_Constant (lu_name_, 'RESEXIST: The Line No :P1, Del No :P2 has reservations that have not been picked. The order line will not be closed.', NULL, line_no_, rel_no_ );
            IF (Transaction_SYS.Is_Session_Deferred) THEN
               Transaction_SYS.Set_Status_Info(info_);
            ELSE
               Client_SYS.Add_Info(lu_name_, info_);
            END IF;
         END IF;
      ELSIF rowstate_ = Customer_Order_Line_API.Get_Objstate(order_no_, line_no_, rel_no_, -1) THEN
         -- The state is not changed. Write history for another delivery.
         Customer_Order_Line_Hist_API.New(order_no_, line_no_, rel_no_, -1);
      END IF;

      new_packages_shipped_ := packages_shipped_ - qty_shipped_;

      IF (staged_billing_ = 'STAGED BILLING') THEN
         new_packages_to_invoice_ := 0;
      ELSE
         new_packages_to_invoice_ := (new_packages_shipped_ / conv_factor_ * inverted_conv_factor_);
      END IF;

      qty_expected_ := new_packages_to_invoice_;
      -- if using delivery confirmation the qty to invoice is set on confirmation - not at this point
      IF (Customer_Order_API.Get_Confirm_Deliveries_Db(order_no_) = 'TRUE') THEN
         new_packages_to_invoice_ := 0;
      END IF;

      Trace_SYS.Field('NEW_PACKAGES_TO_INVOICE_', new_packages_to_invoice_);

      deliv_no_       := Customer_Order_Delivery_API.Get_Next_Deliv_No;
      
      cost_ := Customer_Order_Delivery_API.Get_Pkg_Delivery_Cost(order_no_, line_no_, rel_no_, new_packages_shipped_);

      Customer_Order_Delivery_API.New(order_no_, line_no_, rel_no_, -1, Invoice_Package_Component_API.Decode('N'),
                                      NULL, delnote_no_, NULL, new_packages_shipped_, number_dummy_, new_packages_to_invoice_, 0,
                                      date_delivered_, ship_addr_no_, NULL, cost_, deliv_no_);

      Create_Outstanding_Sales(deliv_no_, transaction_, order_no_, -1, qty_expected_, new_packages_shipped_, cost_);
      Customer_Order_Line_API.Modify_Real_Ship_Date(order_no_, line_no_, rel_no_, -1, date_delivered_);
      Customer_Order_API.Set_Line_Qty_Shipped(order_no_, line_no_, rel_no_, -1, packages_shipped_);

   ELSIF ((component_number_ = component_shipped_) AND (rowstate_ != 'Delivered')) THEN
      new_packages_shipped_ := packages_shipped_ - qty_shipped_;

      IF (new_packages_shipped_ > 0) THEN
         Customer_Order_API.Set_Line_Qty_Shipped(order_no_, line_no_, rel_no_, -1, new_packages_shipped_);
         new_packages_to_invoice_ := (new_packages_shipped_ / conv_factor_ * inverted_conv_factor_);

         qty_expected_            := new_packages_to_invoice_;
         -- if using delivery confirmation the qty to invoice is set on confirmation - not at this point
         IF (Customer_Order_API.Get_Confirm_Deliveries_Db(order_no_) = 'TRUE') THEN
            new_packages_to_invoice_ := 0;
         END IF;

         Trace_SYS.Field('NEW_PACKAGES_TO_INVOICE_', new_packages_to_invoice_);

         deliv_no_       := Customer_Order_Delivery_API.Get_Next_Deliv_No;
         
         cost_ := Customer_Order_Delivery_API.Get_Pkg_Delivery_Cost(order_no_, line_no_, rel_no_, new_packages_shipped_);
         
         Customer_Order_Delivery_API.New(order_no_, line_no_, rel_no_, -1, Invoice_Package_Component_API.Decode('N'),
                                         NULL, delnote_no_, NULL, new_packages_shipped_, number_dummy_, new_packages_to_invoice_, 0,
                                         date_delivered_, ship_addr_no_, NULL, cost_, deliv_no_);

         Create_Outstanding_Sales(deliv_no_, transaction_, order_no_, -1, qty_expected_, new_packages_shipped_, cost_);
         Customer_Order_Line_API.Modify_Real_Ship_Date(order_no_, line_no_, rel_no_, -1, date_delivered_);
      END IF;
   END IF;

   -- If a component line is delivered with differences and closed, the package might be completely delivered.
   Check_Package_Status___(order_no_, line_no_, rel_no_);
END Deliver_Package_If_Complete___;


-- Create_Outstanding_Sales
--   If COGS is NOT posted at delivery confirmation (or Delivery confirmation
--   is not used at all), a record in Outstanding Sales has to be created -
--   but only if quantity > 0.
--   Package components should not create outstanding sales records.
PROCEDURE Create_Outstanding_Sales(
   deliv_no_            IN NUMBER,
   transaction_         IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_item_no_        IN NUMBER,
   qty_expected_        IN NUMBER,
   qty_shipped_         IN NUMBER,
   cost_                IN NUMBER,
   date_cogs_posted_    IN DATE DEFAULT NULL,
   from_service_order_  IN BOOLEAN DEFAULT FALSE)
IS
   attr_    VARCHAR2(32000);
   ordrec_  Customer_Order_API.Public_Rec;
BEGIN
   IF (transaction_ IN ('OESHIP', 'OESHIPNI', 'PODIRSH', 'INTPODIRSH', 'CO-OESHIP', 'CO-CONSUME', 'PODIRSH-NI')) THEN
      IF (line_item_no_ <= 0) AND (qty_expected_ > 0 OR from_service_order_) THEN
         ordrec_ := Customer_Order_API.Get(order_no_);
         IF (ordrec_.delay_cogs_to_deliv_conf = 'FALSE') THEN
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('DELIV_NO', deliv_no_, attr_);
            Client_SYS.Add_To_Attr('CONTRACT', ordrec_.contract, attr_);
            Client_SYS.Add_To_Attr('COMPANY', Site_API.Get_Company(ordrec_.contract), attr_);
            Client_SYS.Add_To_Attr('QTY_EXPECTED', qty_expected_, attr_);
            -- qty_shipped = qty delivered | packages delivered | qty consumed
            Client_SYS.Add_To_Attr('QTY_SHIPPED', qty_shipped_, attr_);
            IF (transaction_ IN ('PODIRSH', 'INTPODIRSH')) THEN
               Client_SYS.Add_To_Attr('DATE_COGS_POSTED', date_cogs_posted_, attr_);           
            END IF;
            Client_SYS.Add_To_Attr('COST', cost_, attr_);
            Outstanding_Sales_API.New(attr_);
         END IF;
      END IF;
   END IF;
END Create_Outstanding_Sales;


-- Credit_Check_Load_List___
--   Checks whether orders connected to a particular load list is credit
--   blocked or not. If credit blocked then the order no will be added to
--   the blocked orders list.
PROCEDURE Credit_Check_Load_List___ (
   blocked_orders_ OUT VARCHAR2,
   load_id_        IN  NUMBER )
IS
   CURSOR get_orders IS
      SELECT DISTINCT order_no
      FROM   CUST_ORDER_LOAD_LIST_LINE_TAB
      WHERE  load_id = load_id_;
BEGIN
   blocked_orders_ := '';
   FOR load_list_rec_ IN get_orders LOOP
      IF (Customer_Order_API.Get_Objstate(load_list_rec_.order_no) != 'Planned') THEN
         -- Check whether the order is credit blocked.
         Customer_Order_Flow_API.Credit_Check_Order(load_list_rec_.order_no, 'DELIVER');
         IF (Customer_Order_API.Get_Objstate(load_list_rec_.order_no) = 'Blocked') THEN
            blocked_orders_ := blocked_orders_ || load_list_rec_.order_no || ', ';
         END IF;
      END IF;
   END LOOP;
   blocked_orders_ := RTRIM(SUBSTR(blocked_orders_, 1, 2000), ', ');
END Credit_Check_Load_List___;


-- Deliver_Complete_Packages___
--   Check if delivered parts of packages for the specified order add up to
--   one ore more complete package(s). If this is the case then 'deliver'
--   the completed package header lines.
PROCEDURE Deliver_Complete_Packages___ (
   order_no_   IN VARCHAR2,
   delnote_no_ IN VARCHAR2 )
IS
   date_  DATE;
   found_ NUMBER := 0;

   CURSOR get_packages IS
      SELECT line_no, rel_no
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND   line_item_no = -1
      AND   rowstate NOT IN ( 'Delivered', 'Invoiced', 'Cancelled');

   CURSOR get_incomplete_packages IS                 
      SELECT line_no, rel_no
      FROM  CUSTOMER_ORDER_LINE_TAB 
      WHERE order_no = order_no_        
      AND   line_item_no = -1  
      AND   qty_shipped = 0  
      AND   qty_shipdiff < 0          
      AND   rowstate IN ('Delivered');    

   CURSOR get_component_lines (line_no_ VARCHAR2, rel_no_ VARCHAR2) IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no > 0;
BEGIN
   -- Note: modified the code to get the contract from a get method
   date_ := Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(order_no_));
   FOR package_ IN get_packages LOOP
      OPEN Get_Component_Lines(package_.line_no,package_.rel_no);
      FETCH Get_Component_Lines INTO found_;
      -- Note: Added a condition to check if the package part has any components connected to it.
      IF (Get_Component_Lines%FOUND) THEN
         Deliver_Package_If_Complete___(order_no_, package_.line_no, package_.rel_no, TRUNC(date_), transaction_ => 'OESHIP' ,delnote_no_ => delnote_no_ );
      END IF;
      CLOSE Get_Component_Lines;
   END LOOP;
   
   IF (Customer_Order_API.Get_Backorder_Option_Db(order_no_) = 'ALLOW INCOMPLETE LINES AND PACKAGES' ) THEN 
      FOR package_ IN get_incomplete_packages LOOP
         OPEN Get_Component_Lines(package_.line_no,package_.rel_no);
         FETCH Get_Component_Lines INTO found_;   
         -- Note: Added a condition to check if the package part has any components connected to it.
         IF (Get_Component_Lines%FOUND) THEN           
            Deliver_Package_If_Complete___(order_no_, package_.line_no, package_.rel_no, TRUNC(date_), transaction_ => 'OESHIP' ,delnote_no_ => delnote_no_ );
         END IF;         
         CLOSE Get_Component_Lines;
      END LOOP;
   END IF;   
   
END Deliver_Complete_Packages___;


-- Deliver_Package_Line___
--   Fetches component lines of the package part and delivers the component
PROCEDURE Deliver_Package_Line___ (
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2 )
IS
   info_                VARCHAR2(32000) := NULL;   
   CURSOR get_component_lines IS
      SELECT line_item_no,
             qty_to_ship
      FROM  CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no      = order_no_
      AND    line_no       = line_no_
      AND    rel_no        = rel_no_
      AND    line_item_no  > 0
      AND    (qty_picked   > 0 OR qty_to_ship > 0);
BEGIN  
   FOR pkg_component_rec_ IN get_component_lines LOOP
      IF Cust_Order_Load_List_API.Get_Load_Id(order_no_, line_no_, rel_no_, pkg_component_rec_.line_item_no) IS NULL THEN
         IF (pkg_component_rec_.qty_to_ship > 0) THEN
            -- Delivery non inventory line.
            Deliver_Line_Non_With_Diff___(order_no_, line_no_, rel_no_, pkg_component_rec_.line_item_no, close_line_ => 0, 
                                          qty_to_deliver_ => NULL, cancel_delivery_ => 'FALSE', delnote_no_ => NULL, shipment_id_ => 0);
         ELSE
            -- Delivery inventory line.
            Deliver_Line_Inv_With_Diff___(info_, order_no_, line_no_, rel_no_, pkg_component_rec_.line_item_no, close_line_ => 0, attr_ => NULL, 
                                          cancel_delivery_ => 'FALSE', delnote_no_ => NULL, shipment_id_ => 0, remove_ship_ => 'FALSE');
         END IF;
      END IF;
   END LOOP;   
END Deliver_Package_Line___;


PROCEDURE Deliver_Load_List___ (
   info_                 OUT VARCHAR2,
   load_id_              IN  NUMBER,
   deliv_load_list_diff_ IN  BOOLEAN )
IS
   loaded_       NUMBER;
   line_removed_ BOOLEAN := FALSE;
   
   CURSOR get_loaded IS
      SELECT 1
      FROM CUST_ORDER_LOAD_LIST_LINE_TAB
      WHERE load_id_ = load_id
      AND   qty_loaded > 0;
BEGIN
   -- Deliver all non inventory lines on load list.
   Deliver_List_Non_Inv_Lines___(line_removed_, load_id_, deliv_load_list_diff_, 'FALSE');
   -- Deliver all inventory lines on load list.
   Deliver_List_Inv_Lines___(line_removed_, info_, load_id_, deliv_load_list_diff_, 'FALSE');
   -- Set load list delivered.
   
   IF (line_removed_ = TRUE) THEN
      Client_SYS.Add_Info(lu_name_, 'EMPTYLOADLISTLINEREMOVED: One or more lines had nothing delivered and was removed from the Load List.');
   END IF; 
   info_ := info_ || Client_SYS.Get_All_Info;

   OPEN get_loaded;
   FETCH get_loaded INTO loaded_;
   CLOSE get_loaded;
   IF (loaded_ = 1) THEN
      Cust_Order_Load_List_API.Set_Load_List_Delivered(load_id_);
   END IF;
END Deliver_Load_List___;


-- Modify_Qty_To_Deliver___
--   This method is used to store qty_to_deliver and catch_qty_to_deliver for
--   the group of reservation lines when total qty and catch qty to deliver values are given.
PROCEDURE Modify_Qty_To_Deliver___ (
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER,
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   location_no_          IN VARCHAR2,
   lot_batch_no_         IN VARCHAR2,
   serial_no_            IN VARCHAR2,
   eng_chg_level_        IN VARCHAR2,
   waiv_dev_rej_no_      IN VARCHAR2,
   activity_seq_         IN NUMBER,
   handling_unit_id_     IN NUMBER,
   configuration_id_     IN VARCHAR2,
   qty_to_deliver_       IN NUMBER,
   catch_qty_to_deliver_ IN NUMBER )
IS
   qty_shipped_from_location_ NUMBER;
   catch_qty_ship_from_loc_   NUMBER;
   qty_remaining_shipped_     NUMBER;
   index_                     NUMBER := 0;

   CURSOR find_all_picklists IS
      SELECT pick_list_no, qty_picked, shipment_id
        FROM CUSTOMER_ORDER_RESERVATION_TAB
       WHERE order_no = order_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no = line_item_no_
         AND contract = contract_
         AND part_no = part_no_
         AND location_no = location_no_
         AND lot_batch_no = lot_batch_no_
         AND serial_no = serial_no_
         AND eng_chg_level = eng_chg_level_
         AND waiv_dev_rej_no = waiv_dev_rej_no_
         AND activity_seq = activity_seq_
         AND handling_unit_id = handling_unit_id_
         AND qty_picked > 0
         AND configuration_id = configuration_id_;
BEGIN
   qty_remaining_shipped_ := qty_to_deliver_;
   FOR next_ IN find_all_picklists LOOP
      IF (qty_to_deliver_ IS NOT NULL) THEN
         qty_shipped_from_location_ := LEAST(next_.qty_picked, qty_remaining_shipped_);
         Customer_Order_Reservation_API.Modify_Qty_To_Deliver(order_no_          => order_no_, 
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
                                                              pick_list_no_      => next_.pick_list_no, 
                                                              configuration_id_  => configuration_id_, 
                                                              shipment_id_       => next_.shipment_id, 
                                                              qty_to_deliver_    => qty_shipped_from_location_);

         qty_remaining_shipped_ := qty_remaining_shipped_ - qty_shipped_from_location_;
      END IF;

      IF (catch_qty_to_deliver_ IS NOT NULL) THEN
         index_ := index_ + 1;
         -- Stored full catch quantity to the first picklist line.
         IF (index_ = 1) THEN
            catch_qty_ship_from_loc_ := catch_qty_to_deliver_;
         ELSE
            catch_qty_ship_from_loc_ := NULL;
         END IF;
         Customer_Order_Reservation_API.Modify_Catch_Qty_To_Deliver(order_no_             => order_no_, 
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
                                                                    pick_list_no_         => next_.pick_list_no, 
                                                                    configuration_id_     => configuration_id_, 
                                                                    shipment_id_          => next_.shipment_id, 
                                                                    catch_qty_to_deliver_ => catch_qty_ship_from_loc_);
      END IF;
   END LOOP;
END Modify_Qty_To_Deliver___;


-- Reset_Qty_To_Deliver___
--   This method is modified the qty to deliver and catch qty to deliver values
--   to its original values for the specified order line.
PROCEDURE Reset_Qty_To_Deliver___ (
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER )
IS
   line_rec_ Customer_Order_Line_API.Public_Rec;
   part_no_  CUSTOMER_ORDER_LINE_TAB.Part_No%TYPE;
   contract_ CUSTOMER_ORDER_LINE_TAB.contract%TYPE;
       
   CURSOR get_all_reservations IS
      SELECT *     
        FROM customer_order_reservation_tab
       WHERE order_no = order_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no = line_item_no_
         AND contract = contract_
         AND part_no = part_no_
         AND qty_picked > 0;
BEGIN
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   contract_ := line_rec_.contract;
   part_no_  := line_rec_.part_no;
   
   FOR res_ IN get_all_reservations LOOP
      IF (res_.qty_picked != res_.qty_to_deliver) THEN
         Customer_Order_Reservation_API.Modify_Qty_To_Deliver(order_no_          => order_no_, 
                                                              line_no_           => line_no_, 
                                                              rel_no_            => rel_no_, 
                                                              line_item_no_      => line_item_no_, 
                                                              contract_          => contract_, 
                                                              part_no_           => part_no_, 
                                                              location_no_       => res_.location_no, 
                                                              lot_batch_no_      => res_.lot_batch_no, 
                                                              serial_no_         => res_.serial_no, 
                                                              eng_chg_level_     => res_.eng_chg_level,
                                                              waiv_dev_rej_no_   => res_.waiv_dev_rej_no, 
                                                              activity_seq_      => res_.activity_seq, 
                                                              handling_unit_id_  => res_.handling_unit_id,
                                                              pick_list_no_      => res_.pick_list_no, 
                                                              configuration_id_  => res_.configuration_id, 
                                                              shipment_id_       => res_.shipment_id, 
                                                              qty_to_deliver_    => res_.qty_picked);
      END IF;

      IF (NVL(res_.catch_qty, 0) != NVL(res_.catch_qty_to_deliver, 0)) THEN
         Customer_Order_Reservation_API.Modify_Catch_Qty_To_Deliver(order_no_             => order_no_, 
                                                                    line_no_              => line_no_, 
                                                                    rel_no_               => rel_no_, 
                                                                    line_item_no_         => line_item_no_, 
                                                                    contract_             => contract_, 
                                                                    part_no_              => part_no_, 
                                                                    location_no_          => res_.location_no, 
                                                                    lot_batch_no_         => res_.lot_batch_no, 
                                                                    serial_no_            => res_.serial_no, 
                                                                    eng_chg_level_        => res_.eng_chg_level,
                                                                    waiv_dev_rej_no_      => res_.waiv_dev_rej_no, 
                                                                    activity_seq_         => res_.activity_seq, 
                                                                    handling_unit_id_     => res_.handling_unit_id,
                                                                    pick_list_no_         => res_.pick_list_no, 
                                                                    configuration_id_     => res_.configuration_id, 
                                                                    shipment_id_          => res_.shipment_id, 
                                                                    catch_qty_to_deliver_ => res_.catch_qty);
      END IF;
   END LOOP;
END Reset_Qty_To_Deliver___;


-- Fill_Temporary_Table___
--   Store all location detail passed in the temporary table.
PROCEDURE Fill_Temporary_Table___ (
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   handling_unit_id_   IN NUMBER,
   qty_to_deliver_     IN NUMBER,
   catch_qty_to_deliv_ IN NUMBER,
   deliv_no_           IN NUMBER )
IS
BEGIN
   INSERT INTO delivered_line_with_diff_tmp
      (location_no,
       lot_batch_no,
       serial_no,
       eng_chg_level,
       waiv_dev_rej_no,
       handling_unit_id,
       qty_to_deliver,
       catch_qty_to_deliv,
       deliv_no)
   VALUES
      (location_no_,
       lot_batch_no_,
       serial_no_,
       eng_chg_level_,
       waiv_dev_rej_no_,
       handling_unit_id_,
       qty_to_deliver_,
       catch_qty_to_deliv_,
       deliv_no_);
END Fill_Temporary_Table___;

--   Delete a record belong to stored deliv_no within the transaction from the temporary table.
PROCEDURE Clear_Temp_Table_Deliv_No___
IS
BEGIN
   DELETE delivered_line_with_diff_tmp
    WHERE location_no = 'TEMPORARILY SAVED DELIV_NO';
END Clear_Temp_Table_Deliv_No___;


PROCEDURE Update_License_Coverage_Qty___(
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   quantity_     IN NUMBER,
   qty_reserved_ IN NUMBER DEFAULT 0 )
IS
BEGIN
   IF (Customer_Order_Flow_API.Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN
         DECLARE
            action_ VARCHAR2(20);         
         BEGIN
            IF qty_reserved_ > 0 THEN
               action_ := 'UnreserveWhenDeliver';
               Exp_License_Connect_Util_API.Update_Coverage_Quantities(action_, order_no_, line_no_, rel_no_, line_item_no_, qty_reserved_);
            ELSE
               action_ := 'Deliver';
               Exp_License_Connect_Util_API.Update_Coverage_Quantities(action_, order_no_, line_no_, rel_no_, line_item_no_, quantity_);
            END IF;
         END;
      $ELSE
         NULL;
      $END
   END IF;
END Update_License_Coverage_Qty___;

PROCEDURE Send_Mul_Tier_Del_Notificat___ (
   session_id_                   IN NUMBER,
   order_no_                     IN VARCHAR2,
   line_no_                      IN VARCHAR2,
   rel_no_                       IN VARCHAR2,
   line_item_no_                 IN NUMBER,
   deliv_no_                     IN NUMBER,
   qty_shipped_on_pur_ord_       IN NUMBER,
   catch_qty_shipped_on_pur_ord_ IN NUMBER,
   serial_no_                    IN VARCHAR2,
   last_in_batch_                IN NUMBER,
   configuration_id_             IN VARCHAR2,
   lot_batch_no_                 IN VARCHAR2, 
   eng_chg_level_                IN VARCHAR2,
   handling_unit_id_             IN NUMBER,
   waiv_dev_rej_no_              IN VARCHAR2,
   expiration_date_              IN DATE,
   on_approve_del_notification_  IN VARCHAR2,
   last_rec_in_del_notification_ IN VARCHAR2,
   mul_tier_dirdel_allowed_      IN VARCHAR2 )
IS
   send_mul_tier_del_notificat_ BOOLEAN:= FALSE;
BEGIN  
   IF (mul_tier_dirdel_allowed_ = 'TRUE') THEN
      IF (NVL(on_approve_del_notification_, 'FALSE') = 'TRUE') THEN   
         IF (NVL(last_rec_in_del_notification_, 'FALSE') = 'TRUE') THEN
            send_mul_tier_del_notificat_ := TRUE;
         END IF;                                            
      ELSE 
         IF (NVL(last_in_batch_, 1) = 1) THEN
            send_mul_tier_del_notificat_ := TRUE;
         END IF;   
      END IF;
      Customer_Order_Transfer_API.Send_Multi_Tier_Dir_Delivery(session_id_,
                                                               order_no_,
                                                               line_no_, 
                                                               rel_no_, 
                                                               line_item_no_,
                                                               deliv_no_,
                                                               configuration_id_,
                                                               lot_batch_no_,
                                                               serial_no_,
                                                               waiv_dev_rej_no_,
                                                               eng_chg_level_,
                                                               handling_unit_id_,
                                                               qty_shipped_on_pur_ord_,
                                                               catch_qty_shipped_on_pur_ord_,
                                                               expiration_date_,
                                                               send_mul_tier_del_notificat_ );  
   END IF;
END Send_Mul_Tier_Del_Notificat___;


PROCEDURE Connect_Reserve_To_Del_Note___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   contract_     IN VARCHAR2,
   location_no_  IN VARCHAR2,
   delnote_no_   IN VARCHAR2 )
IS
   status_text_    VARCHAR2(255);
   alt_delnote_no_ VARCHAR2(50);
   
   CURSOR get_pre_ship_reservation_data IS
      SELECT part_no,         
             configuration_id, 
             lot_batch_no, 
             serial_no,
             waiv_dev_rej_no, 
             eng_chg_level,    
             pick_list_no, 
             activity_seq, 
             shipment_id,
             handling_unit_id
        FROM customer_order_reservation_tab
       WHERE order_no       = order_no_
         AND line_no        = line_no_
         AND rel_no         = rel_no_
         AND line_item_no   = line_item_no_
         AND contract       = contract_
         AND location_no    = location_no_
         AND delnote_no     IS NULL
         AND qty_picked     > 0;
BEGIN
   -- Find all deliveries for which a delivery note has not been created
   FOR reservation_data_  IN get_pre_ship_reservation_data LOOP
      Customer_Order_Reservation_API.Modify_Delnote_No(order_no_         => order_no_,     
                                                       line_no_          => line_no_,  
                                                       rel_no_           => rel_no_,
                                                       line_item_no_     => line_item_no_, 
                                                       contract_         => contract_,
                                                       part_no_          => reservation_data_.part_no,
                                                       location_no_      => location_no_,  
                                                       lot_batch_no_     => reservation_data_.lot_batch_no,
                                                       serial_no_        => reservation_data_.serial_no,
                                                       eng_chg_level_    => reservation_data_.eng_chg_level,
                                                       waiv_dev_rej_no_  => reservation_data_.waiv_dev_rej_no,
                                                       activity_seq_     => reservation_data_.activity_seq,
                                                       handling_unit_id_ => reservation_data_.handling_unit_id,
                                                       pick_list_no_     => reservation_data_.pick_list_no,
                                                       configuration_id_ => reservation_data_.configuration_id,
                                                       shipment_id_      => reservation_data_.shipment_id,
                                                       delnote_no_       => delnote_no_);
   END LOOP;
   
   alt_delnote_no_ := Delivery_Note_Api.Get_Alt_Delnote_No(delnote_no_);
   status_text_    := Language_SYS.Translate_Constant(lu_name_, 'DELNOCREATEDLINE: Pre-Ship Delivery Note :P1 created', NULL, alt_delnote_no_);
   
   Customer_Order_Line_Hist_API.New(order_no_, line_no_, rel_no_,
                                    line_item_no_, status_text_);
END Connect_Reserve_To_Del_Note___;


-- Connect_Line_To_Deliv_Note___
--   Set the delivery_note attribute in CustomerOrderDelivery for all
--   deliveries for an order line not already connected to a delivery note.
--   Also creates a new entry in CustomerOrderLineHistory.
PROCEDURE Connect_Line_To_Deliv_Note___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   delnote_no_   IN VARCHAR2 )
IS
   status_text_    VARCHAR2(255);
   alt_delnote_no_ VARCHAR2(50);
   
   CURSOR get_delivery IS
      SELECT deliv_no
        FROM CUSTOMER_ORDER_DELIVERY_TAB
       WHERE order_no = order_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no = line_item_no_
         AND delnote_no IS NULL
         AND cancelled_delivery = 'FALSE';
BEGIN
   -- Find all deliveries for which a delivery note has not been created
   FOR delivrec_ IN get_delivery LOOP
      -- Connect the delivery to the delivery note
      Customer_Order_Delivery_API.Modify_Delnote_No(delivrec_.deliv_no, delnote_no_);
      alt_delnote_no_ := Delivery_Note_Api.Get_Alt_Delnote_No(delnote_no_);
      status_text_    := Language_SYS.Translate_Constant(lu_name_, 'DELNOCREATEDHEAD: Delivery note :P1 created', NULL, alt_delnote_no_);
      Customer_Order_Line_Hist_API.New(order_no_, line_no_, rel_no_,
                                       line_item_no_, status_text_);
   END LOOP;
END Connect_Line_To_Deliv_Note___;


-- Set_Receipt_Ref_On_Receipt___
--   In order to match supplier invoices correctly, when distribution order
--   has the automatic receipt check box checked, the receipt reference should be the delivery note number.
--   This method calls Set_Receipt_Ref_On_Receipt to do so.
PROCEDURE Set_Receipt_Ref_On_Receipt___ (
   order_no_   IN VARCHAR2,
   line_no_    IN VARCHAR2,
   rel_no_     IN VARCHAR2,
   delnote_no_ IN VARCHAR2 )
IS
BEGIN
   $IF Component_Disord_SYS.INSTALLED $THEN
      Distribution_Order_API.Set_Receipt_Ref_On_Receipt(order_no_, line_no_, rel_no_, delnote_no_);
   $ELSE
      NULL;
   $END
END Set_Receipt_Ref_On_Receipt___;

-- Added new parameter aggregated_ to identify the aggregated window
-- Consume_Consignment_Stock___
--   Consumes quantity from Customer Consignment Stock and updates
--   qty_to_invoice in Customer Order Deliveries.
PROCEDURE Consume_Consignment_Stock___ (
   contract_                  IN VARCHAR2,
   catalog_no_                IN VARCHAR2,
   customer_no_               IN VARCHAR2,
   addr_no_                   IN VARCHAR2,
   qty_to_consume_            IN NUMBER,
   configuration_id_          IN VARCHAR2 DEFAULT NULL,
   lot_batch_no_              IN VARCHAR2 DEFAULT NULL,
   serial_no_                 IN VARCHAR2 DEFAULT NULL,
   eng_chg_level_             IN VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_           IN VARCHAR2 DEFAULT NULL,
   activity_seq_              IN NUMBER   DEFAULT NULL,
   handling_unit_id_          IN NUMBER   DEFAULT NULL,
   expiration_date_           IN DATE     DEFAULT Database_SYS.Get_Last_Calendar_Date(),
   aggregated_                IN VARCHAR2 DEFAULT 'FALSE')
IS
   part_no_               CUSTOMER_ORDER_LINE_TAB.part_no%TYPE;
   qty_delivered_         NUMBER;
   qty_consumed_          NUMBER;
   qty_to_invoice_        NUMBER;
   del_qty_to_invoice_    NUMBER;   
   qty_to_consume_local_  NUMBER;
   invent_qty_to_consume_ NUMBER;
   all_consumed_          BOOLEAN := FALSE;
   consume_date_          DATE;
   sum_qty_to_invoice_    NUMBER;
   deliv_no_              NUMBER;
   find_deliveries_tab_   Find_Deliveries_Tab;
   

      CURSOR get_sum_to_invoice (order_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2, line_item_no_ IN NUMBER) IS 
         SELECT SUM(qty_to_invoice) sum_to_invoice
         FROM   CUSTOMER_ORDER_DELIVERY_TAB
         WHERE  order_no = order_no_
         AND    line_no = line_no_
         AND    rel_no = rel_no_  
         AND    line_item_no = line_item_no_
         AND    cancelled_delivery = 'FALSE';
   BEGIN

   find_deliveries_tab_ := Find_Deliveries___(contract_,catalog_no_,customer_no_,addr_no_,configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, expiration_date_, aggregated_);
   -- Remaining qty in inventory units to consume and "distribute" on available deliveries.
   qty_to_consume_local_ := qty_to_consume_;
   part_no_              := Sales_Part_API.Get_Part_No(contract_, catalog_no_);

   IF (find_deliveries_tab_.COUNT > 0) THEN
      FOR i IN find_deliveries_tab_.FIRST..find_deliveries_tab_.LAST LOOP 
         qty_consumed_ := Inventory_Transaction_Hist_API.Get_Sum_Quantity(contract_             => contract_, 
                                                                             source_ref1_          => find_deliveries_tab_(i).order_no,
                                                                             source_ref2_          => find_deliveries_tab_(i).line_no,
                                                                             source_ref3_          => find_deliveries_tab_(i).rel_no,
                                                                             source_ref4_          => find_deliveries_tab_(i).line_item_no,
                                                                             source_ref5_          => find_deliveries_tab_(i).source_ref5,
                                                                             source_ref_type_db_   => Order_Type_API.DB_CUSTOMER_ORDER,
                                                                             part_no_              => part_no_,
                                                                             configuration_id_     => find_deliveries_tab_(i).configuration_id,
                                                                             lot_batch_no_         => find_deliveries_tab_(i).lot_batch_no,
                                                                             serial_no_            => find_deliveries_tab_(i).serial_no,
                                                                             eng_chg_level_        => find_deliveries_tab_(i).eng_chg_level,
                                                                             waiv_dev_rej_no_      => find_deliveries_tab_(i).waiv_dev_rej_no,
                                                                             activity_seq_         => find_deliveries_tab_(i).activity_seq,
                                                                             handling_unit_id_     => find_deliveries_tab_(i).handling_unit_id,
                                                                             transaction_code_     => 'CO-CONSUME',
                                                                             expiration_date_      => find_deliveries_tab_(i).expiration_date,
                                                                             ignore_expiration_date_ => 'FALSE');
         
         -- This is to handle situations where the delivery is made before APP9 and consumption is made after the upgrade
         IF (find_deliveries_tab_(i).eng_chg_level = '*') THEN
            qty_consumed_ := qty_consumed_ + Inventory_Transaction_Hist_API.Get_Sum_Quantity(contract_            => contract_, 
                                                                                            source_ref1_          => find_deliveries_tab_(i).order_no,
                                                                                            source_ref2_          => find_deliveries_tab_(i).line_no,
                                                                                            source_ref3_          => find_deliveries_tab_(i).rel_no,
                                                                                            source_ref4_          => find_deliveries_tab_(i).line_item_no,
                                                                                            source_ref5_          => find_deliveries_tab_(i).source_ref5,
                                                                                            source_ref_type_db_   => Order_Type_API.DB_CUSTOMER_ORDER,
                                                                                            part_no_              => part_no_,
                                                                                            configuration_id_     => find_deliveries_tab_(i).configuration_id,
                                                                                            lot_batch_no_         => find_deliveries_tab_(i).lot_batch_no,
                                                                                            serial_no_            => find_deliveries_tab_(i).serial_no,
                                                                                            eng_chg_level_        => '1',
                                                                                            waiv_dev_rej_no_      => find_deliveries_tab_(i).waiv_dev_rej_no,
                                                                                            activity_seq_         => find_deliveries_tab_(i).activity_seq,
                                                                                            handling_unit_id_     => find_deliveries_tab_(i).handling_unit_id,
                                                                                            transaction_code_     => 'CO-CONSUME',
                                                                                            expiration_date_      => find_deliveries_tab_(i).expiration_date,
                                                                                            ignore_expiration_date_ => 'FALSE');
         END IF;

         qty_delivered_ := Inventory_Transaction_Hist_API.Get_Sum_Quantity(contract_            => contract_, 
                                                                              source_ref1_         => find_deliveries_tab_(i).order_no,
                                                                              source_ref2_         => find_deliveries_tab_(i).line_no,
                                                                              source_ref3_         => find_deliveries_tab_(i).rel_no,
                                                                              source_ref4_         => find_deliveries_tab_(i).line_item_no,
                                                                              source_ref5_         => find_deliveries_tab_(i).source_ref5,
                                                                              source_ref_type_db_  => Order_Type_API.DB_CUSTOMER_ORDER,
                                                                              part_no_             => part_no_,
                                                                              configuration_id_    => find_deliveries_tab_(i).configuration_id,
                                                                              lot_batch_no_        => find_deliveries_tab_(i).lot_batch_no,
                                                                              serial_no_           => find_deliveries_tab_(i).serial_no,
                                                                              eng_chg_level_       => find_deliveries_tab_(i).eng_chg_level,
                                                                              waiv_dev_rej_no_     => find_deliveries_tab_(i).waiv_dev_rej_no,
                                                                              activity_seq_        => find_deliveries_tab_(i).activity_seq,
                                                                              handling_unit_id_    => find_deliveries_tab_(i).handling_unit_id,
                                                                              transaction_code_    => 'CO-DELV-IN',
                                                                              expiration_date_      => find_deliveries_tab_(i).expiration_date,
                                                                              ignore_expiration_date_ => 'FALSE');

         IF (qty_delivered_ - qty_consumed_) > 0 THEN 
            IF (qty_to_consume_local_ <= qty_delivered_ - qty_consumed_) THEN
               invent_qty_to_consume_ := qty_to_consume_local_;
               all_consumed_        := TRUE;
            ELSE
               invent_qty_to_consume_ := qty_delivered_ - qty_consumed_;
            END IF;

            IF deliv_no_ IS NULL OR deliv_no_ != find_deliveries_tab_(i).deliv_no THEN 
               del_qty_to_invoice_ := find_deliveries_tab_(i).delivery_qty_to_invoice + invent_qty_to_consume_;
               deliv_no_           := find_deliveries_tab_(i).deliv_no;
            ELSE 
               del_qty_to_invoice_ := del_qty_to_invoice_ + invent_qty_to_consume_;
            END IF;
            Customer_Consignment_Stock_API.Decrease_Consignment_Stock_Qty (contract_         => contract_, 
                                                                           part_no_          => part_no_,
                                                                           configuration_id_ => find_deliveries_tab_(i).configuration_id,
                                                                           lot_batch_no_     => find_deliveries_tab_(i).lot_batch_no,
                                                                           serial_no_        => find_deliveries_tab_(i).serial_no,
                                                                           eng_chg_level_    => find_deliveries_tab_(i).eng_chg_level,
                                                                           waiv_dev_rej_no_  => find_deliveries_tab_(i).waiv_dev_rej_no,
                                                                           activity_seq_     => find_deliveries_tab_(i).activity_seq,
                                                                           handling_unit_id_ => find_deliveries_tab_(i).handling_unit_id,
                                                                           expiration_date_  => find_deliveries_tab_(i).expiration_date,
                                                                           transaction_code_ => 'CO-CONSUME',
                                                                           project_id_       => NULL,
                                                                           order_no_         => find_deliveries_tab_(i).order_no,
                                                                           release_no_       => find_deliveries_tab_(i).line_no,
                                                                           sequence_no_      => find_deliveries_tab_(i).rel_no,
                                                                           line_item_no_     => find_deliveries_tab_(i).line_item_no,
                                                                           deliv_no_         => find_deliveries_tab_(i).deliv_no,
                                                                           quantity_         => invent_qty_to_consume_,
                                                                           catch_quantity_   => NULL,
                                                                           addr_no_          => addr_no_);

            consume_date_         := TRUNC(Site_API.Get_Site_Date(contract_));

            OPEN get_sum_to_invoice(find_deliveries_tab_(i).order_no,find_deliveries_tab_(i).line_no,find_deliveries_tab_(i).rel_no,find_deliveries_tab_(i).line_item_no);
            FETCH get_sum_to_invoice INTO sum_qty_to_invoice_;
            CLOSE get_sum_to_invoice;
            sum_qty_to_invoice_ := (sum_qty_to_invoice_ * find_deliveries_tab_(i).conv_factor/find_deliveries_tab_(i).inverted_conv_factor);

            qty_to_invoice_ := (del_qty_to_invoice_) / find_deliveries_tab_(i).conv_factor * find_deliveries_tab_(i).inverted_conv_factor;
            Customer_Order_Delivery_API.Modify_Delivery_Confirmed(find_deliveries_tab_(i).deliv_no, qty_to_invoice_, consume_date_, NULL);

            Modify_Order_Line_Cost('CO-CONSUME', find_deliveries_tab_(i).order_no, find_deliveries_tab_(i).line_no, find_deliveries_tab_(i).rel_no, find_deliveries_tab_(i).line_item_no, (invent_qty_to_consume_+ sum_qty_to_invoice_));
            EXIT WHEN all_consumed_;
            qty_to_consume_local_ := qty_to_consume_local_ - invent_qty_to_consume_; 

            Trace_SYS.Field('The entire qty was not consumed within this transaction', invent_qty_to_consume_);
         END IF;
      END LOOP;
   END IF;
END Consume_Consignment_Stock___;

@UncheckedAccess
FUNCTION Find_Deliveries___ (
   contract_                  IN VARCHAR2,
   catalog_no_                IN VARCHAR2,
   customer_no_               IN VARCHAR2,
   addr_no_                   IN VARCHAR2,
   configuration_id_          IN VARCHAR2 DEFAULT NULL,
   lot_batch_no_              IN VARCHAR2 DEFAULT NULL,
   serial_no_                 IN VARCHAR2 DEFAULT NULL,
   eng_chg_level_             IN VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_           IN VARCHAR2 DEFAULT NULL,
   activity_seq_              IN NUMBER   DEFAULT NULL,
   handling_unit_id_          IN NUMBER   DEFAULT NULL,
   expiration_date_           IN DATE     DEFAULT Database_SYS.Get_Last_Calendar_Date(),
   aggregated_                IN VARCHAR2 DEFAULT 'FALSE') RETURN Find_Deliveries_Tab
IS
   last_calendar_date_              DATE := Database_Sys.last_calendar_date_;
   row_index_                       PLS_INTEGER := 1;
   find_deliveries_tab_             Find_Deliveries_Tab;
  
  CURSOR find_deliveries IS
      SELECT DISTINCT deliv.date_delivered, deliv.deliv_no, 
                      (deliv.qty_to_invoice * line.conv_factor/line.inverted_conv_factor) delivery_qty_to_invoice,
                      line.conv_factor, line.inverted_conv_factor,
                      deliv.order_no, deliv.line_no, deliv.rel_no, deliv.line_item_no, line.configuration_id,
                      ith.handling_unit_id, ith.lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no, 
                      ith.eng_chg_level, ith.activity_seq, ith.expiration_date, ith.source_ref5
      FROM   CUSTOMER_ORDER_DELIVERY_TAB deliv, CUSTOMER_ORDER_LINE_TAB line, INVENTORY_TRANSACTION_HIST_PUB ith
      WHERE  deliv.order_no              = line.order_no
      AND    deliv.line_no               = line.line_no
      AND    deliv.rel_no                = line.rel_no
      AND    deliv.line_item_no          = line.line_item_no
      AND    deliv.qty_to_invoice        < (deliv.qty_shipped / line.conv_factor * line.inverted_conv_factor)
      AND    deliv.cancelled_delivery    = 'FALSE'   
      AND    deliv.ship_addr_no          = addr_no_
      AND    line.contract               = contract_
      AND    line.catalog_no             = catalog_no_
      AND    line.customer_no            = customer_no_
      AND    line.consignment_stock      = 'CONSIGNMENT STOCK'
      AND    line.qty_invoiced           < (line.qty_shipped / line.conv_factor * line.inverted_conv_factor)
      AND    (line.configuration_id      = configuration_id_    OR configuration_id_ IS NULL) 
      AND    ith.source_ref1             = line.order_no
      AND    ith.source_ref2             = line.line_no
      AND    ith.source_ref3             = line.rel_no
      AND    ith.source_ref4             = line.line_item_no
      AND    (ith.source_ref5            = deliv.deliv_no      OR ith.source_ref5   IS NULL)
      AND    ith.source_ref_type         = 'CUST ORDER'
      AND    ith.transaction_code        = 'CO-DELV-IN'
      AND    (ith.lot_batch_no           = lot_batch_no_       OR lot_batch_no_     IS NULL) 
      AND    (ith.serial_no              = serial_no_          OR serial_no_        IS NULL) 
      AND    (ith.eng_chg_level          = eng_chg_level_      OR eng_chg_level_    IS NULL OR (ith.eng_chg_level = '*' AND ith.source_ref5 IS NULL)) 
      AND    (ith.waiv_dev_rej_no        = waiv_dev_rej_no_    OR waiv_dev_rej_no_  IS NULL) 
      AND    (ith.activity_seq           = activity_seq_       OR activity_seq_     IS NULL) 
      AND    ((ith.handling_unit_id      = handling_unit_id_   OR handling_unit_id_ IS NULL) OR (handling_unit_id_ = 0 AND ith.source_ref5 IS NULL))
      AND  (((aggregated_ = 'FALSE') AND ((ith.expiration_date IS NOT NULL AND expiration_date_ = ith.expiration_date) OR (NVL(expiration_date_, last_calendar_date_) = last_calendar_date_  AND ith.expiration_date IS NULL))) 
      OR (aggregated_ = 'TRUE'))    
      ORDER BY deliv.date_delivered, line.configuration_id, ith.lot_batch_no, ith.serial_no, ith.handling_unit_id, ith.waiv_dev_rej_no, 
               ith.eng_chg_level, ith.activity_seq, ith.expiration_date;

BEGIN

   FOR rec_ IN find_deliveries LOOP
      find_deliveries_tab_(row_index_).date_delivered   := rec_.date_delivered;
      find_deliveries_tab_(row_index_).deliv_no         := rec_.deliv_no;
      find_deliveries_tab_(row_index_).delivery_qty_to_invoice  := rec_.delivery_qty_to_invoice;
      find_deliveries_tab_(row_index_).conv_factor      := rec_.conv_factor;
      find_deliveries_tab_(row_index_).inverted_conv_factor     := rec_.inverted_conv_factor;
      find_deliveries_tab_(row_index_).order_no         := rec_.order_no;
      find_deliveries_tab_(row_index_).line_no          := rec_.line_no;
      find_deliveries_tab_(row_index_).rel_no           := rec_.rel_no;
      find_deliveries_tab_(row_index_).line_item_no     := rec_.line_item_no;
      find_deliveries_tab_(row_index_).source_ref5      := rec_.source_ref5;
      find_deliveries_tab_(row_index_).configuration_id := rec_.configuration_id;
      find_deliveries_tab_(row_index_).handling_unit_id := rec_.handling_unit_id;
      find_deliveries_tab_(row_index_).lot_batch_no     := rec_.lot_batch_no;
      find_deliveries_tab_(row_index_).serial_no        := rec_.serial_no;
      find_deliveries_tab_(row_index_).waiv_dev_rej_no  := rec_.waiv_dev_rej_no;
      find_deliveries_tab_(row_index_).eng_chg_level    := rec_.eng_chg_level;
      find_deliveries_tab_(row_index_).activity_seq     := rec_.activity_seq;
      find_deliveries_tab_(row_index_).expiration_date  := rec_.expiration_date;
     
      row_index_ := row_index_ + 1;
   END LOOP; 
   
   RETURN find_deliveries_tab_;
END Find_Deliveries___;

-- Deliver_Order_With_Diff__
--   Deliver a order with differances
PROCEDURE Deliver_Order_With_Diff___ (
   info_          OUT VARCHAR2,
   order_no_      IN  VARCHAR2,
   inv_message_   IN  CLOB,
   non_message_   IN  CLOB )
IS
BEGIN
   Customer_Order_Flow_API.Credit_Check_Order(order_no_,'DELIVER');
   IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') THEN
      -- Handle non inventory parts.
      Deliver_Order_Non_With_Diff___(order_no_, non_message_, 'FALSE');
      -- Handle inventory parts.
      Deliver_Order_Inv_With_Diff___(info_,order_no_, inv_message_, 'FALSE');
   ELSE
      Client_SYS.Add_Info(lu_name_, 'CRBLKORD: The customer order :P1 is blocked due to exceeding the credit limit, failing the credit check or because of manual blocking.', order_no_);
   END IF;
   info_ := info_ || Client_SYS.Get_All_Info;
END Deliver_Order_With_Diff___;


-- Pack_Deliv_Attr_To_Message___
--    This method packed attr_ message in to a message_sys message.
FUNCTION Pack_Deliv_Attr_To_Message___(
   catalog_type_  IN VARCHAR2,
   attr_          IN VARCHAR2 ) RETURN CLOB
IS
   message_ CLOB;
   ptr_                     NUMBER := NULL;
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(2000);
BEGIN
   message_ := Message_SYS.Construct_Clob_Message(catalog_type_);
   Message_SYS.Add_Attribute(message_, 'CATALOG_TYPE', catalog_type_);
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Message_SYS.Add_Attribute(message_, name_, value_);
   END LOOP;
   RETURN message_;
END Pack_Deliv_Attr_To_Message___;

PROCEDURE Create_Delivery_Inv_Ref___(
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ,
   deliv_no_     IN VARCHAR2) 
   
IS
   invoice_id_   VARCHAR2(20);
   company_      VARCHAR2(20);
   item_id_      NUMBER;

   CURSOR latest_invoice_line_ IS
      SELECT MAX (invoice_id), company
      FROM   ORDER_LINE_STAGED_BILLING_TAB
      WHERE  order_no        = order_no_
      AND    line_no         = line_no_
      AND    rel_no          = rel_no_
      AND    line_item_no    = line_item_no_
      AND    rowstate        = 'Invoiced'
      GROUP BY company;
   
   CURSOR Get_item_id_ IS 
      SELECT item_id 
      FROM   customer_order_inv_item 
      WHERE  invoice_id   = invoice_id_
      AND    company      = company_ 
      AND    order_no     = order_no_
      AND    line_no      = line_no_
      AND    release_no   = rel_no_
      AND    line_item_no = line_item_no_;

BEGIN   
   OPEN latest_invoice_line_;
   FETCH latest_invoice_line_ INTO invoice_id_, company_;
   CLOSE latest_invoice_line_;
   IF (invoice_id_ IS NOT NULL)THEN 
      OPEN Get_item_id_;                                             
      FETCH Get_item_id_ INTO item_id_;
      CLOSE Get_item_id_;
      cust_delivery_inv_ref_API.Create_Reference(deliv_no_, company_, invoice_id_, item_id_);
    END IF;   
END Create_Delivery_Inv_Ref___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Deliver_Load_List__
--   Deliver all order lines on load list.
PROCEDURE Deliver_Load_List__ (
   info_    OUT VARCHAR2,
   load_id_ IN  NUMBER )
IS
   blocked_orders_ VARCHAR2(2000);
BEGIN
   Trace_SYS.Field('Deliver LOAD_ID', load_id_);
   Credit_Check_Load_List___(blocked_orders_, load_id_);
   Deliver_Load_List___(info_, load_id_, FALSE);
   IF (blocked_orders_ IS NOT NULL) THEN
      Client_SYS.Add_Info(lu_name_, 'LOADLISTBLK: Customer order(s) :P1 is blocked due to exceeding the credit limit, failing the credit check or because of manual blocking.', blocked_orders_);      
   END IF;
   info_ := info_ || Client_SYS.Get_All_Info;
END Deliver_Load_List__;


-- Deliver_Load_List_With_Diff__
--   Make a delivery with differences for a load list.
--   If the line is part of a package the package head might also be
PROCEDURE Deliver_Load_List_With_Diff__ (
   info_    OUT VARCHAR2,
   load_id_ IN  NUMBER )
IS
   blocked_orders_ VARCHAR2(2000);
BEGIN
   Trace_SYS.Field('Deliver load_id', load_id_);
   Credit_Check_Load_List___(blocked_orders_, load_id_);
   Deliver_Load_List___(info_, load_id_, TRUE);
   IF (blocked_orders_ IS NOT NULL) THEN
      Client_SYS.Add_Info(lu_name_, 'LOADLISTBLK: Customer order(s) :P1 is blocked due to exceeding the credit limit, failing the credit check or because of manual blocking.', blocked_orders_);            
   END IF;
   info_ := info_ || Client_SYS.Get_All_Info;
END Deliver_Load_List_With_Diff__;


-- Deliver_Order__
--   Deliver all lines on order, not connected to any load list.
PROCEDURE Deliver_Order__ (
   order_no_ IN VARCHAR2 )
IS
   info_  VARCHAR2(32000);
BEGIN
   Customer_Order_Flow_API.Credit_Check_Order(order_no_,'DELIVER');

   IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') THEN
      Trace_SYS.Field('Deliver ORDER_NO', order_no_);
      -- Deliver all non inventory lines on order.
      Deliver_Order_Non_With_Diff___(order_no_, NULL, 'FALSE');
      -- Deliver all inventory lines on order.
      Deliver_Order_Inv_With_Diff___(info_, order_no_, NULL, 'FALSE');
   END IF;
END Deliver_Order__;


-- Deliver_Order_Inv_With_Diff__
--   Make a delivery with differences for a noninventory part.
--   If the line is part of a package the package head might also be
PROCEDURE Deliver_Order_Inv_With_Diff__ (
   info_     OUT VARCHAR2,
   order_no_ IN  VARCHAR2,
   attr_     IN  VARCHAR2 )
IS
   message_ CLOB;
BEGIN
   Customer_Order_Flow_API.Credit_Check_Order(order_no_,'DELIVER');

   IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') THEN
      Trace_SYS.Field('Deliver inventory parts with differeence, all unconnected lines on ORDER_NO', order_no_);
      message_ := Pack_Deliv_Attr_To_Message___('INV', attr_);
      Deliver_Order_Inv_With_Diff___(info_, order_no_, message_, 'FALSE');
   ELSE
      Client_SYS.Add_Info(lu_name_, 'CRBLKORD: The customer order :P1 is blocked due to exceeding the credit limit, failing the credit check or because of manual blocking.', order_no_);
   END IF;
   info_ := info_ || Client_SYS.Get_All_Info;
END Deliver_Order_Inv_With_Diff__;


-- Deliver_Order_Non_With_Diff__
--   Make a delivery with differences for an inventory part.
--   If the line is part of a package the package head might also be
PROCEDURE Deliver_Order_Non_With_Diff__ (
   info_     OUT VARCHAR2,
   order_no_ IN  VARCHAR2,
   attr_     IN  VARCHAR2 )
IS
   message_ CLOB;
BEGIN
   Customer_Order_Flow_API.Credit_Check_Order(order_no_, 'DELIVER');

   IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') THEN
      Trace_SYS.Field('Deliver non inventory parts with differeence, all unconnected lines on ORDER_NO', order_no_);
      message_ := Pack_Deliv_Attr_To_Message___('NON', attr_);
      Deliver_Order_Non_With_Diff___(order_no_, message_, 'FALSE');
   ELSE
      Client_SYS.Add_Info(lu_name_, 'CRBLKORD: The customer order :P1 is blocked due to exceeding the credit limit, failing the credit check or because of manual blocking.', order_no_);
   END IF;
   info_ := info_ || Client_SYS.Get_All_Info;
END Deliver_Order_Non_With_Diff__;


-- Ready_Inv_Lines_On_List__
--   Returns 1 if the list has any picked inventory lines connected than can be
--   shipped, otherwise 0.
@UncheckedAccess
FUNCTION Ready_Inv_Lines_On_List__ (
   load_id_ IN NUMBER ) RETURN NUMBER
IS
   found_ NUMBER;

   CURSOR find_inventory_lines IS
      SELECT 1
      FROM   customer_order_line_tab
      WHERE  load_id = load_id_
      AND    qty_picked > 0;
BEGIN
   OPEN  find_inventory_lines;
   FETCH find_inventory_lines INTO found_;
   IF (find_inventory_lines%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE find_inventory_lines;
   RETURN found_;
END Ready_Inv_Lines_On_List__;



-- Ready_Inv_Lines_On_Order__
--   Returns 1 if the order has any inventory lines that can be shipped,
--   otherwise 0.
@UncheckedAccess
FUNCTION Ready_Inv_Lines_On_Order__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ number;

   CURSOR exists_lines_to_deliver IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB col
      WHERE  col.order_no = order_no_
      AND    col.qty_picked > 0
      AND  NOT EXISTS (SELECT 1
                       FROM   CUST_ORDER_LOAD_LIST_TAB ll
                       WHERE  ll.load_id = col.load_id
                       AND    ll.load_list_state = 'NOTDEL');
BEGIN
   OPEN  exists_lines_to_deliver;
   FETCH exists_lines_to_deliver INTO found_;
   IF (exists_lines_to_deliver%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exists_lines_to_deliver;
   RETURN found_;
END Ready_Inv_Lines_On_Order__;


-- Ready_Non_Inv_Lines_On_List__
--   Returns 1 if the list has any non inventory lines connected that can be
--   shipped, otherwise 0.
@UncheckedAccess
FUNCTION Ready_Non_Inv_Lines_On_List__ (
   load_id_ IN NUMBER ) RETURN NUMBER
IS
   found_ NUMBER;

   CURSOR find_non_inventory_lines IS
      SELECT 1
      FROM   customer_order_line_tab
      WHERE  load_id = load_id_
      AND    qty_to_ship > 0;
BEGIN
   OPEN  find_non_inventory_lines;
   FETCH find_non_inventory_lines INTO found_;
   IF (find_non_inventory_lines%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE find_non_inventory_lines;
   RETURN found_;
END Ready_Non_Inv_Lines_On_List__;


-- Ready_Non_Inv_Lines_On_Order__
--   Returns 1 if the order has any non inventory lines that can be shipped,
--   otherwise 0.
@UncheckedAccess
FUNCTION Ready_Non_Inv_Lines_On_Order__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER;

   CURSOR exists_lines_to_deliver IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB col
      WHERE  col.order_no = order_no_
      AND    (col.buy_qty_due - col.qty_shipped + col.qty_shipdiff) > 0
      AND    col.part_no IS NULL
      AND    col.line_item_no >= 0
      AND  NOT EXISTS (SELECT 1
                       FROM   CUST_ORDER_LOAD_LIST_TAB ll
                       WHERE  ll.load_id = col.load_id
                       AND    ll.load_list_state = 'NOTDEL');
BEGIN
   OPEN  exists_lines_to_deliver;
   FETCH exists_lines_to_deliver INTO found_;
   IF (exists_lines_to_deliver%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exists_lines_to_deliver;
   RETURN found_;
END Ready_Non_Inv_Lines_On_Order__;



-- Picked_Reservations_Exist__
--   Returns 1 if the reservation has any quantity picked.
@UncheckedAccess
FUNCTION Picked_Reservations_Exist__ (
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
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER) RETURN NUMBER
IS
   found_ NUMBER;

   CURSOR exist_picked_quantity IS
      SELECT 1
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    contract = contract_
      AND    part_no = part_no_
      AND    location_no = location_no_
      AND    lot_batch_no = lot_batch_no_
      AND    serial_no = serial_no_
      AND    eng_chg_level = eng_chg_level_
      AND    waiv_dev_rej_no = waiv_dev_rej_no_
      AND    activity_seq = activity_seq_
      AND    handling_unit_id = handling_unit_id_
      AND    shipment_id = 0
      AND    qty_picked > 0;
BEGIN
   OPEN  exist_picked_quantity;
   FETCH exist_picked_quantity INTO found_;
   IF (exist_picked_quantity%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_picked_quantity;
   RETURN found_;
END Picked_Reservations_Exist__;



-- Any_Delivery_Note_Printed__
--   Returns 1 if any delivery notes has been printed for order_no.
@UncheckedAccess
FUNCTION Any_Delivery_Note_Printed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER;

   CURSOR find_printed_notes IS
      SELECT 1
      FROM   delivery_note_pub
      WHERE  order_no = order_no_
      AND    objstate = 'Printed';
BEGIN
   OPEN find_printed_notes;
   FETCH find_printed_notes INTO found_;
   IF (find_printed_notes%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE find_printed_notes;
   RETURN found_;
END Any_Delivery_Note_Printed__;



-- Deliver_Line_Inv_With_Diff__
--   Make a delivery with differences for a noninventory part.
--   If the line is part of a package the package head might also be
PROCEDURE Deliver_Line_Inv_With_Diff__ (
   info_         OUT VARCHAR2,
   order_no_     IN  VARCHAR2,
   line_no_      IN  VARCHAR2,
   rel_no_       IN  VARCHAR2,
   line_item_no_ IN  NUMBER,   
   close_line_   IN  NUMBER,
   attr_         IN  VARCHAR2,
   remove_ship_  IN  VARCHAR2 DEFAULT NULL,
   shipment_id_  IN  NUMBER   DEFAULT 0 )
IS
BEGIN
   IF (remove_ship_ IS NULL) OR (remove_ship_ != 'TRUE') THEN
      Customer_Order_Flow_API.Credit_Check_Order(order_no_,'DELIVER');
   END IF;  

   IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') OR (remove_ship_ = 'TRUE') THEN
      Deliver_Line_Inv_With_Diff___(info_, order_no_, line_no_, rel_no_, line_item_no_, close_line_, attr_, cancel_delivery_ => 'FALSE', delnote_no_ => NULL, shipment_id_ => shipment_id_, remove_ship_ => remove_ship_ );
   ELSE
      Client_SYS.Add_Info(lu_name_, 'CRBLKORD: The customer order :P1 is blocked due to exceeding the credit limit, failing the credit check or because of manual blocking.', order_no_);
   END IF;
   info_ := info_ || Client_SYS.Get_All_Info;
END Deliver_Line_Inv_With_Diff__;


-- Deliver_Line_Non_With_Diff__
--   Make a delivery with differences for an inventory part.
--   If the line is part of a package the package head might also be
PROCEDURE Deliver_Line_Non_With_Diff__ (
   info_           OUT VARCHAR2,
   order_no_       IN  VARCHAR2,
   line_no_        IN  VARCHAR2,
   rel_no_         IN  VARCHAR2,
   line_item_no_   IN  NUMBER,
   close_line_     IN  NUMBER,
   qty_to_deliver_ IN  NUMBER )
IS
BEGIN
   Customer_Order_Flow_API.Credit_Check_Order(order_no_,'DELIVER');

   IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') THEN
      Deliver_Line_Non_With_Diff___(order_no_, line_no_, rel_no_, line_item_no_, close_line_, qty_to_deliver_, cancel_delivery_ => 'FALSE', delnote_no_ => NULL, shipment_id_=> 0);
   ELSE
      Client_SYS.Add_Info(lu_name_, 'CRBLKORD: The customer order :P1 is blocked due to exceeding the credit limit, failing the credit check or because of manual blocking.', order_no_);
   END IF;
   info_ := info_ || Client_SYS.Get_All_Info;
END Deliver_Line_Non_With_Diff__;


-- Deliver_Order_Line__
--   Deliver order line, not connected to any load list.
PROCEDURE Deliver_Order_Line__ (
   info_               OUT VARCHAR2,
   order_no_           IN  VARCHAR2,
   line_no_            IN  VARCHAR2,
   rel_no_             IN  VARCHAR2,
   line_item_no_       IN  NUMBER)
IS
   g_info_ VARCHAR2(32000) := '';
BEGIN
   Customer_Order_Flow_API.Credit_Check_Order(order_no_,'DELIVER');
   IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') THEN
      IF line_item_no_ = -1 THEN
         Deliver_Package_Line___(order_no_, line_no_, rel_no_);
      ELSE
         IF (Customer_Order_Line_API.Get_Qty_To_Ship(order_no_, line_no_, rel_no_, line_item_no_) > 0) THEN
            -- Delivery non inventory line.
            Deliver_Line_Non_With_Diff___(order_no_, line_no_, rel_no_, line_item_no_, close_line_ => 0, qty_to_deliver_ => NULL,
                                          cancel_delivery_ => 'FALSE', delnote_no_ => NULL, shipment_id_ => 0);
         ELSE
            -- Delivery inventory line.
            Deliver_Line_Inv_With_Diff___(info_, order_no_, line_no_, rel_no_, line_item_no_, 0, NULL, 'FALSE', delnote_no_ => NULL, shipment_id_ => 0, remove_ship_ => 'FALSE');
         END IF;
      END IF;
   ELSE
      Client_SYS.Add_Info(lu_name_, 'CRBLKORD: The customer order :P1 is blocked due to exceeding the credit limit, failing the credit check or because of manual blocking.', order_no_);
   END IF;

   g_info_ := g_info_||Client_SYS.Get_All_Info;
   info_   := g_info_;
END Deliver_Order_Line__;


-- Picked_Single_On_Order_Line__
--   Return TRUE if the are picked reservations
--   for the specified order line.
@UncheckedAccess
FUNCTION Picked_Single_On_Order_Line__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   found_     NUMBER;

   CURSOR single_picked_on_order_line IS
      SELECT 1
      FROM CUSTOMER_ORDER_RESERVATION_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      AND   qty_picked > 0;
BEGIN
   OPEN single_picked_on_order_line;
   FETCH single_picked_on_order_line INTO found_;
   IF (single_picked_on_order_line%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE single_picked_on_order_line;
   RETURN found_;
END Picked_Single_On_Order_Line__;

-- Added new parameter aggregated_ to identify the aggregated window.
-- Consume_Consignment_Stock__
--   Consumes quantity from Customer Consignment Stock and updates
--   qty_to_invoice in Customer Order Deliveries.
PROCEDURE Consume_Consignment_Stock__ (
   contract_                  IN VARCHAR2,
   catalog_no_                IN VARCHAR2,
   customer_no_               IN VARCHAR2,
   addr_no_                   IN VARCHAR2,
   qty_to_consume_            IN NUMBER,
   configuration_id_          IN VARCHAR2 DEFAULT NULL,
   lot_batch_no_              IN VARCHAR2 DEFAULT NULL,
   serial_no_                 IN VARCHAR2 DEFAULT NULL,
   eng_chg_level_             IN VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_           IN VARCHAR2 DEFAULT NULL,
   activity_seq_              IN NUMBER   DEFAULT NULL,
   handling_unit_id_          IN NUMBER   DEFAULT NULL,   
   b2b_client_                IN VARCHAR2 DEFAULT 'FALSE',
   expiration_date_           IN DATE     DEFAULT Database_SYS.Get_Last_Calendar_Date(),
   aggregated_                IN VARCHAR2 DEFAULT 'FALSE')
IS
   consignment_stock_qty_ NUMBER;
   order_point_           NUMBER;
   consignment_stock_db_  VARCHAR2(20);
   allow_aggr_report_     VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   
BEGIN
   IF (qty_to_consume_ IS NOT NULL) THEN 
      -- Consignment stock qty in inventory units.
      allow_aggr_report_ := Customer_Consignment_Stock_API.Get_Allow_Aggregated_Report_Db(contract_, catalog_no_, customer_no_, addr_no_);
   
      -- If aggregated reporting is not allowed, the inventroy keys should have values 
      IF (allow_aggr_report_ = Fnd_Boolean_API.DB_FALSE AND serial_no_ IS NULL AND lot_batch_no_ IS NULL AND b2b_client_ = 'FALSE') THEN  
         Error_SYS.Record_General(lu_name_, 'CONSUMEAGGR: Aggregated level reporting is not allowed.');
      END IF;
      consignment_stock_qty_:= Get_Consignment_Stock_Qty__(contract_, catalog_no_, customer_no_, addr_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, expiration_date_, aggregated_);

      IF (qty_to_consume_ <= 0) THEN
         Error_SYS.Record_General(lu_name_, 'CONSUMENEG: The Qty to Consume can not be negative or zero.');
      ELSIF (qty_to_consume_ > consignment_stock_qty_) THEN
         Error_SYS.Record_General(lu_name_, 'CONSUMETOBIG: The Consumed Qty cannot be more than Consignment Stock Qty.');
      END IF;

      Consume_Consignment_Stock___(contract_, 
                                   catalog_no_, 
                                   customer_no_, 
                                   addr_no_, 
                                   qty_to_consume_, 
                                   configuration_id_, 
                                   lot_batch_no_, 
                                   serial_no_, 
                                   eng_chg_level_, 
                                   waiv_dev_rej_no_, 
                                   activity_seq_, 
                                   handling_unit_id_,
                                   expiration_date_,
                                   aggregated_);
                                   
      order_point_          := Customer_Consignment_Stock_API.Get_Order_Point(contract_, catalog_no_, customer_no_, addr_no_);

      consignment_stock_db_ := Customer_Consignment_Stock_API.Get_Consignment_Stock_Db(contract_, catalog_no_, customer_no_, addr_no_);
      IF (order_point_ > consignment_stock_qty_ - qty_to_consume_) AND (consignment_stock_db_ = 'CONSIGNMENT STOCK') THEN
         Trace_SYS.Message('Consignment stock quantity is below order point. Generate a new event');
         Cust_Order_Event_Creation_API.Consignment_Stock_Order_Point(contract_, catalog_no_, customer_no_, addr_no_);
      END IF;
   END IF;
END Consume_Consignment_Stock__;


-- To_Order_Flow_When_Delivered__
--   Put the order back in the order flow according to the order type.
PROCEDURE To_Order_Flow_When_Delivered__ (
   order_no_ IN VARCHAR2 )
IS
   attr_        VARCHAR2(2000);
   order_id_    VARCHAR2(3);
   next_event_  NUMBER;
   description_ VARCHAR2(200);
BEGIN
   order_id_   := Customer_Order_API.Get_Order_Id(order_no_);
   next_event_ := Cust_Order_Type_Event_API.Get_Next_Event(order_id_, 90);
   IF (next_event_ IS NOT NULL) THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('START_EVENT', next_event_, attr_);
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
      Client_SYS.Add_To_Attr('END', '', attr_);

      description_ := Language_SYS.Translate_Constant(lu_name_, 'ORDERFLOW: Process Customer Order.');
      Transaction_SYS.Deferred_Call('Customer_Order_Flow_API.Process_Order__', attr_, description_);
   END IF;
END To_Order_Flow_When_Delivered__;


-- Get_Input_Units_To_Deliver__
--   This method retrieves the input unit values and also returns a flag
--   stating whether multiple pick list numbers exist or not.
PROCEDURE Get_Input_Units_To_Deliver__ (
   input_qty_              OUT NUMBER,
   input_unit_meas_        OUT VARCHAR2,
   input_conv_factor_      OUT NUMBER,
   input_variable_values_  OUT VARCHAR2,
   multiple_picking_       OUT VARCHAR2,
   order_no_               IN  VARCHAR2,
   line_no_                IN  VARCHAR2,
   rel_no_                 IN  VARCHAR2,
   line_item_no_           IN  NUMBER,
   contract_               IN  VARCHAR2,
   part_no_                IN  VARCHAR2,
   location_no_            IN  VARCHAR2,
   lot_batch_no_           IN  VARCHAR2,
   serial_no_              IN  VARCHAR2,
   eng_chg_level_          IN  VARCHAR2,
   waiv_dev_rej_no_        IN  VARCHAR2,
   configuration_id_       IN  VARCHAR2,
   activity_seq_           IN  NUMBER,
   handling_unit_id_       IN  NUMBER)
IS
   CURSOR get_input_info_ IS
      SELECT input_qty, input_unit_meas, input_conv_factor, input_variable_values
      FROM   customer_order_reservation_tab
      WHERE  order_no         = order_no_
      AND    line_no          = line_no_
      AND    rel_no           = rel_no_
      AND    line_item_no     = line_item_no_
      AND    contract         = contract_
      AND    part_no          = part_no_
      AND    location_no      = location_no_
      AND    lot_batch_no     = lot_batch_no_
      AND    serial_no        = serial_no_
      AND    eng_chg_level    = eng_chg_level_
      AND    waiv_dev_rej_no  = waiv_dev_rej_no_
      AND    configuration_id = configuration_id_
      AND    activity_seq     = activity_seq_
      AND    handling_unit_id = handling_unit_id_
      AND    qty_picked       > 0;
BEGIN
   multiple_picking_ := 'FALSE';
   OPEN get_input_info_;

   LOOP
      FETCH get_input_info_ INTO input_qty_, input_unit_meas_, input_conv_factor_, input_variable_values_;
      IF (get_input_info_%ROWCOUNT > 1) THEN
         multiple_picking_      := 'TRUE';
         input_qty_             := NULL;
         input_unit_meas_       := NULL;
         input_conv_factor_     := NULL;
         input_variable_values_ := NULL;
         EXIT;
      END IF;
      EXIT WHEN get_input_info_%NOTFOUND;
   END LOOP;

   CLOSE get_input_info_;
END Get_Input_Units_To_Deliver__;


-- Fetch_Input_Units_To_Deliver
--   This method used in Aurena retrieves the input unit values and also returns a flag
--   stating whether multiple pick list numbers exist or not.
@UncheckedAccess
FUNCTION Fetch_Input_Units_To_Deliver (
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
   configuration_id_ IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER) RETURN Input_Uom_Arr PIPELINED
IS
   input_qty_             NUMBER;
   input_unit_meas_       VARCHAR2(30);
   input_conv_factor_     NUMBER;
   input_variable_values_ VARCHAR2(2000);
   multiple_picking_      VARCHAR2(5);
   rec_                   Input_Uom_Rec;   
BEGIN
   Get_Input_Units_To_Deliver__(input_qty_, input_unit_meas_, input_conv_factor_, input_variable_values_, multiple_picking_, order_no_, line_no_, rel_no_, line_item_no_, 
                                contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, configuration_id_, activity_seq_, handling_unit_id_);
                                
   rec_.input_qty             := input_qty_;
   rec_.input_unit_meas       := input_unit_meas_;
   rec_.input_conv_factor     := input_conv_factor_;
   rec_.input_variable_values := input_variable_values_;
   rec_.multiple_picking      := multiple_picking_;
   PIPE ROW (rec_); 
END Fetch_Input_Units_To_Deliver;


-- Deliver_Order_With_Diff__
--   Deliver a order with differances
FUNCTION Deliver_Order_With_Diff__(
   message_    IN CLOB,
   order_no_   IN VARCHAR2 ) RETURN CLOB
IS
   info_ VARCHAR2(32000);
   clob_out_data_ CLOB;
   name_arr_      Message_SYS.name_table;
   value_arr_     Message_SYS.line_table;
   record_type_   VARCHAR2(25);
   count_         NUMBER;
   inv_message_   CLOB;
   non_message_   CLOB;
BEGIN
   inv_message_ := Message_SYS.Construct_Clob_Message('INV');
   non_message_ := Message_SYS.Construct_Clob_Message('NON');
   
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF(name_arr_(n_) = 'CATALOG_TYPE') THEN
         IF((record_type_ IS NULL AND value_arr_(n_) = 'INV') OR
            ((record_type_ IS NULL OR record_type_ = 'INV') AND value_arr_(n_) = 'NON')) THEN
            record_type_ := value_arr_(n_);
         ELSE
            -- This error safeguard the invalid order of the message from third party caller. Will not raise through IFS Application core implementation.
            Error_SYS.Record_General(lu_name_, 'INVALATTRORDER: The sequence of the content in the attribute string is invalid. The content should include inventory sales parts followed by non-inventory sales parts.');
         END IF;
      END IF;
      IF(name_arr_(n_) != 'CATALOG_TYPE') THEN
         IF(record_type_ = 'INV') THEN
            Message_SYS.Add_Attribute(inv_message_, name_arr_(n_), value_arr_(n_));
         ELSIF(record_type_ = 'NON') THEN
            Message_SYS.Add_Attribute(non_message_, name_arr_(n_), value_arr_(n_));
         ELSE
            -- This error safeguard the invalid sources of the message from third party caller. Will not raise through IFS Application core implementation.
            Error_SYS.Record_General(lu_name_, 'INVALRECTYPE: Invalid part type found. Part should be either an inventory sales part or non-inventory sales part.');
         END IF;
      END IF;
   END LOOP;
   
   Deliver_Order_With_Diff___(info_, order_no_, inv_message_, non_message_);
   
   clob_out_data_ := Message_SYS.Construct('OUTPUT_DATA');
   IF (info_ IS NOT NULL) THEN 
      Message_SYS.Add_Attribute(clob_out_data_, 'INFO', info_);
   END IF;
   RETURN clob_out_data_;
END Deliver_Order_With_Diff__;


-- Cancel_Deliver_Line__
--   This method is used to cancel a delivery line. It is called from the
--   deliver order line with differences client.
PROCEDURE Cancel_Deliver_Line__ (
   info_         OUT VARCHAR2,
   order_no_     IN  VARCHAR2,
   line_no_      IN  VARCHAR2,
   release_no_   IN  VARCHAR2,
   line_item_no_ IN  NUMBER )
IS
BEGIN
   IF (Customer_Order_Line_API.Get_Qty_To_Ship(order_no_, line_no_, release_no_, line_item_no_) > 0) THEN
      -- Handle non inventory parts.
      Deliver_Line_Non_With_Diff___(order_no_, line_no_, release_no_, line_item_no_, close_line_ => 0, qty_to_deliver_ => NULL,
                                    cancel_delivery_ => 'TRUE', delnote_no_ => NULL, shipment_id_ => 0 );
   ELSE
      -- Handle inventory parts.
      Deliver_Line_Inv_With_Diff___(info_, order_no_, line_no_, release_no_, line_item_no_, 0, NULL, 'TRUE', delnote_no_ => NULL, shipment_id_ => 0, remove_ship_ => 'FALSE' );
   END IF;
END Cancel_Deliver_Line__;


-- Cancel_Deliver_Order__
--   This method is used to cancel a delivery order. It is called from the
--   deliver order with differences client.
PROCEDURE Cancel_Deliver_Order__ (
   info_     OUT VARCHAR2,
   order_no_ IN  VARCHAR2 )
IS
BEGIN
   -- Handle non inventory parts.
   Deliver_Order_Non_With_Diff___(order_no_, NULL, 'TRUE');
   -- Handle inventory parts.
   Deliver_Order_Inv_With_Diff___(info_, order_no_, NULL, 'TRUE');
END Cancel_Deliver_Order__;


-- Cancel_Deliver_Load_List__
--   This method is used to cancel a delivery order. It is called from the
--   deliver load list with differences client.
PROCEDURE Cancel_Deliver_Load_List__ (
   info_    OUT VARCHAR2,
   load_id_ IN  NUMBER )
IS
   line_removed_ BOOLEAN;
BEGIN
   -- Handle non inventory parts.
   Deliver_List_Non_Inv_Lines___(line_removed_, load_id_, NULL, 'TRUE');
   -- Deliver all inventory lines on load list.
   Deliver_List_Inv_Lines___(line_removed_, info_, load_id_, NULL, 'TRUE');
END Cancel_Deliver_Load_List__;


-- Deliver_Pre_Ship_Del_Note__
--   Record the delivery for delivery notes.
PROCEDURE Deliver_Pre_Ship_Del_Note__ (
   info_        OUT VARCHAR2,
   order_no_    IN  VARCHAR2,
   delnote_no_  IN  VARCHAR2 )
IS
   CURSOR get_lines IS
      SELECT DISTINCT line_no, rel_no, line_item_no
        FROM CUSTOMER_ORDER_RESERVATION_TAB
       WHERE order_no        =  order_no_
         AND delnote_no      =  delnote_no_
         AND qty_picked      >  0;

   CURSOR get_nopart_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM   customer_order_line_tab
      WHERE  order_no        =  order_no_
      AND    qty_to_ship     >  0;
BEGIN
   --Perform credit check for the order before delivery
   Customer_Order_Flow_API.Credit_Check_Order(order_no_,'DELIVER');
   IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') THEN
      Inventory_Event_Manager_API.Start_Session;
      FOR linerec_ IN get_lines LOOP
         Deliver_Line_Inv_With_Diff___(info_,
                                       order_no_,
                                       linerec_.line_no,
                                       linerec_.rel_no,
                                       linerec_.line_item_no,
                                       close_line_         => 0,
                                       attr_               => NULL,
                                       cancel_delivery_    => 'FALSE',
                                       delnote_no_         => delnote_no_,
                                       shipment_id_        => 0,
                                       remove_ship_        => 'FALSE');
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;

      --Get non inventory order lines which can be delivered with this delivery.
      FOR get_nopart_lines_ IN get_nopart_lines LOOP
         Deliver_Line_Non_With_Diff___(order_no_,
                                       get_nopart_lines_.line_no,
                                       get_nopart_lines_.rel_no,
                                       get_nopart_lines_.line_item_no,
                                       close_line_      => 0,
                                       qty_to_deliver_  => NULL,
                                       cancel_delivery_ => 'FALSE',
                                       delnote_no_      => delnote_no_,
                                       shipment_id_     => 0 );
      END LOOP;
      Delivery_Note_API.Set_Pre_Ship_Delivery_Made(delnote_no_);
   ELSE
      Client_SYS.Add_Info(lu_name_, 'CRBLKORD: The customer order :P1 is blocked due to exceeding the credit limit, failing the credit check or because of manual blocking.', order_no_);
   END IF;
   info_ := info_ || Client_SYS.Get_All_Info;
END Deliver_Pre_Ship_Del_Note__;


-- Modify_Qty_To_Deliver__
--   This method is used in deliver laod list with difference window
--   to store qty_to_deliver and catch_qty_to_deliver for ship inventory reservations.
PROCEDURE Modify_Qty_To_Deliver__ (
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
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   configuration_id_ IN VARCHAR2,
   attr_             IN VARCHAR2 )
IS
   ptr_                  NUMBER := NULL;
   name_                 VARCHAR2(30);
   value_                VARCHAR2(2000);
   qty_to_deliver_       NUMBER;
   catch_qty_to_deliver_ NUMBER;
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'QTY_TO_DELIVER') THEN
         qty_to_deliver_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'CATCH_QTY_TO_DELIVER') THEN
         catch_qty_to_deliver_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;
   END LOOP;

   Modify_Qty_To_Deliver___(order_no_,
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
                            qty_to_deliver_,
                            catch_qty_to_deliver_ );
END Modify_Qty_To_Deliver__;


-- Reset_Qty_To_Deliver__
--   This method is modified the qty to deliver and catch qty to deliver values
--   to its original values when the order line is disconnected from load list.
PROCEDURE Reset_Qty_To_Deliver__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
BEGIN
   Reset_Qty_To_Deliver___(order_no_,
                          line_no_,
                          rel_no_,
                          line_item_no_ );
END Reset_Qty_To_Deliver__;


PROCEDURE Create_Pre_Ship_Del_Notes__ (
   contract_    IN VARCHAR2,
   location_no_ IN VARCHAR2 )
IS
   CURSOR get_pre_ship_data IS
      SELECT DISTINCT cot.order_no
        FROM customer_order_tab cot, customer_order_line_tab colt, customer_order_reservation_tab cort
       WHERE cot.contract        = contract_
         AND cort.location_no    = location_no_
         AND cot.order_no        = colt.order_no
         AND colt.order_no       = cort.order_no
         AND colt.line_no        = cort.line_no
         AND colt.rel_no         = cort.rel_no
         AND colt.line_item_no   = cort.line_item_no
         AND cot.use_pre_ship_del_note  = 'TRUE'
         AND colt.shipment_connected    = 'FALSE'
         AND cort.qty_picked > 0
         AND cort.delnote_no IS NULL
         AND NOT EXISTS (
                 SELECT 1
                   FROM cust_order_load_list_tab collt, cust_order_load_list_line_tab colllt
                  WHERE collt.load_id         = colllt.load_id
                    AND collt.load_list_state = 'NOTDEL'
                    AND colllt.order_no       = colt.order_no
                    AND colllt.line_no        = colt.line_no
                    AND colllt.rel_no         = colt.rel_no
                    AND colllt.line_item_no   = colt.line_item_no)
      ORDER BY cot.order_no;
BEGIN
   FOR get_pre_ship_data_ IN get_pre_ship_data LOOP
      Create_Ord_Pre_Ship_Del_Note__(get_pre_ship_data_.order_no,
                                     location_no_);
   END LOOP;
END Create_Pre_Ship_Del_Notes__;


PROCEDURE Create_Pre_Ship_Del_Notes__ (
   attr_ IN VARCHAR2 )
IS
   ptr_         NUMBER;
   name_        VARCHAR2(30);
   value_       VARCHAR2(2000);
   contract_    VARCHAR2(5);
   location_no_ VARCHAR2(35);
BEGIN
   -- Retrieve parameters from the attribute string
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'LOCATION_NO') THEN
         location_no_ := value_;
      ELSIF (name_ = 'END') THEN
         Create_Pre_Ship_Del_Notes__(contract_,
                                     location_no_);
      END IF;
   END LOOP;
END Create_Pre_Ship_Del_Notes__;


PROCEDURE Create_Ord_Pre_Ship_Del_Note__ (
   order_no_    IN VARCHAR2,
   location_no_ IN VARCHAR2 )
IS
   delnote_no_  delivery_note_tab.delnote_no%TYPE;
   CURSOR get_line IS
      SELECT DISTINCT DECODE(colt.addr_flag, 'Y', NULL, colt.ship_addr_no) non_single_ship_addr_no, colt.addr_flag,      cola.addr_1,
                      cola.address1,      cola.address2,       cola.address3,
                      cola.address4,      cola.address5,      cola.address6, cola.zip_code,
                      cola.city,          cola.state,          cola.county,
                      cola.country_code,  colt.route_id,       colt.forward_agent_id,
                      colt.ship_via_code, colt.delivery_terms, colt.deliver_to_customer_no, 
                      colt.del_terms_location, colt.originating_co_lang_code
        FROM customer_order_line_tab colt, cust_order_line_address_2 cola
       WHERE (colt.order_no, colt.line_no, colt.rel_no, colt.line_item_no) IN
             (SELECT order_no, line_no, rel_no, line_item_no
                FROM customer_order_reservation_tab
               WHERE delnote_no IS NULL
                 AND qty_picked > 0
                 AND order_no  = order_no_
                 AND location_no = location_no_)
                 AND colt.line_item_no = cola.line_item_no
                 AND colt.rel_no   = cola.rel_no
                 AND colt.line_no  = cola.line_no
                 AND colt.order_no = cola.order_no
                 AND colt.order_no = order_no_
                 AND colt.shipment_connected = 'FALSE'
                 AND NOT EXISTS(
                  SELECT 1
                    FROM cust_order_load_list_tab collt, cust_order_load_list_line_tab colllt
                   WHERE collt.load_id         = colllt.load_id
                     AND collt.load_list_state = 'NOTDEL'
                     AND colllt.order_no       = colt.order_no
                     AND colllt.line_no        = colt.line_no
                     AND colllt.rel_no         = colt.rel_no
                     AND colllt.line_item_no   = colt.line_item_no);
BEGIN
   FOR get_line_ IN get_line LOOP
      Delivery_Note_API.New(delnote_no_, order_no_, get_line_.non_single_ship_addr_no,
                            get_line_.addr_flag, get_line_.addr_1, get_line_.address1,
                            get_line_.address2,get_line_.address3,get_line_.address4,
                            get_line_.address5,get_line_.address6,get_line_.zip_code, get_line_.city,
                            get_line_.state, get_line_.county, get_line_.country_code,
                            get_line_.route_id, get_line_.forward_agent_id, get_line_.ship_via_code,
                            get_line_.delivery_terms, NULL, get_line_.deliver_to_customer_no, 
                            location_no_, get_line_.del_terms_location, get_line_.originating_co_lang_code);
      Customer_Order_Flow_API.Print_Delivery_Note(delnote_no_);
   END LOOP;
END Create_Ord_Pre_Ship_Del_Note__;


PROCEDURE Conn_Order_To_Pre_Del_Note__ (
   delnote_no_             IN VARCHAR2,
   pre_ship_invent_loc_no_ IN VARCHAR2 )
IS
   status_text_  VARCHAR2(255);
   delnoterec_   Delivery_Note_API.Public_Rec;
   contract_     VARCHAR2(5);
   CURSOR get_line IS
      SELECT col.line_no, col.rel_no, col.line_item_no
        FROM customer_order_line_tab col, cust_order_line_address_2 cola
       WHERE (((col.addr_flag = 'N')
         AND (col.ship_addr_no = delnoterec_.receiver_addr_id)) OR ((col.addr_flag = 'Y')
         AND (cola.addr_1 || '^' || cola.address1 || '^' || cola.address2 || '^' || cola.address3 || '^' || cola.address4 || '^' || cola.address5 || '^' || cola.address6 || '^' || cola.zip_code || '^' || cola.city || '^' || cola.state || '^' || cola.country_code || '^' || col.delivery_terms || '^' || col.del_terms_location || '^' =
             delnoterec_.receiver_addr_name || '^' || delnoterec_.receiver_address1 || '^' || delnoterec_.receiver_address2 || '^' || delnoterec_.receiver_address3 || '^' || delnoterec_.receiver_address4 || '^' || delnoterec_.receiver_address5 || '^' || delnoterec_.receiver_address6 || '^' || delnoterec_.receiver_zip_code || '^' || delnoterec_.receiver_city || '^' || delnoterec_.receiver_state || '^' || delnoterec_.receiver_country || '^' || delnoterec_.delivery_terms || '^' || delnoterec_.del_terms_location || '^')))
         AND col.addr_flag = delnoterec_.single_occ_addr_flag
         AND nvl(col.ship_via_code, ' ') = nvl(delnoterec_.ship_via_code, ' ')
         AND nvl(col.delivery_terms, ' ') = nvl(delnoterec_.delivery_terms, ' ')
         AND nvl(col.del_terms_location, ' ') = nvl(delnoterec_.del_terms_location, ' ')
         AND nvl(col.forward_agent_id, ' ') = nvl(delnoterec_.forward_agent_id, ' ')
         AND nvl(col.route_id, ' ') = nvl(delnoterec_.route_id, ' ')
         AND col.line_item_no = cola.line_item_no
         AND col.rel_no = cola.rel_no
         AND col.line_no = cola.line_no
         AND col.order_no = cola.order_no
         AND col.shipment_connected = 'FALSE'
         AND col.qty_picked > 0
         AND col.order_no = delnoterec_.order_no
         AND (col.line_no, col.rel_no, col.line_item_no) IN
             (SELECT line_no, rel_no, line_item_no
                FROM customer_order_reservation_tab
               WHERE delnote_no IS NULL
                 AND qty_picked > 0
                 AND order_no  = col.order_no
                 AND location_no = pre_ship_invent_loc_no_)
                 AND NOT EXISTS (
                         SELECT 1
                           FROM cust_order_load_list_tab collt, cust_order_load_list_line_tab colllt
                          WHERE collt.load_id         = colllt.load_id
                            AND collt.load_list_state = 'NOTDEL'
                            AND colllt.order_no       = col.order_no
                            AND colllt.line_no        = col.line_no
                            AND colllt.rel_no         = col.rel_no
                            AND colllt.line_item_no   = col.line_item_no);
BEGIN
   delnoterec_ := Delivery_Note_API.Get(delnote_no_);
   contract_   := Customer_Order_API.Get_Contract(delnoterec_.order_no);
   FOR get_line_ IN get_line LOOP
      Connect_Reserve_To_Del_Note___(delnoterec_.order_no, get_line_.line_no, get_line_.rel_no,
                                     get_line_.line_item_no, contract_, pre_ship_invent_loc_no_,
                                     delnote_no_);
   END LOOP;
   
   status_text_ := Language_SYS.Translate_Constant(lu_name_, 'DELNOCREATEDLINE: Pre-Ship Delivery Note :P1 created', NULL, delnoterec_.alt_delnote_no );
   Customer_Order_History_API.New(delnoterec_.order_no,
                                  status_text_);
END Conn_Order_To_Pre_Del_Note__;

-- Added the parameters to make sure that this method can be used to get the quantity related to the below parameters as well.
@UncheckedAccess
FUNCTION Get_Consignment_Stock_Qty__(
   contract_                  IN VARCHAR2,
   catalog_no_                IN VARCHAR2,
   customer_no_               IN VARCHAR2,
   addr_no_                   IN VARCHAR2,
   configuration_id_          IN VARCHAR2 DEFAULT NULL,
   lot_batch_no_              IN VARCHAR2 DEFAULT NULL,
   serial_no_                 IN VARCHAR2 DEFAULT NULL,
   eng_chg_level_             IN VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_           IN VARCHAR2 DEFAULT NULL,
   activity_seq_              IN NUMBER   DEFAULT NULL,
   handling_unit_id_          IN NUMBER   DEFAULT NULL,
   expiration_date_           IN DATE     DEFAULT NULL,
   aggregated_                IN VARCHAR2 DEFAULT 'FALSE') RETURN NUMBER 
IS
   consignment_stock_qty_     NUMBER := 0;
   qty_consumed_              NUMBER := 0;
   qty_delivered_             NUMBER := 0;
   find_deliveries_tab_       Find_Deliveries_Tab;
   part_no_                   CUSTOMER_ORDER_LINE_TAB.part_no%TYPE;
BEGIN
   find_deliveries_tab_  := Find_Deliveries___(contract_,catalog_no_,customer_no_,addr_no_,configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, expiration_date_, aggregated_);
   part_no_              := Sales_Part_API.Get_Part_No(contract_, catalog_no_);
 IF (find_deliveries_tab_.COUNT > 0) THEN
      FOR i IN find_deliveries_tab_.FIRST..find_deliveries_tab_.LAST LOOP 
         qty_consumed_ := Inventory_Transaction_Hist_API.Get_Sum_Quantity(contract_             => contract_, 
                                                                          source_ref1_          => find_deliveries_tab_(i).order_no,
                                                                          source_ref2_          => find_deliveries_tab_(i).line_no,
                                                                          source_ref3_          => find_deliveries_tab_(i).rel_no,
                                                                          source_ref4_          => find_deliveries_tab_(i).line_item_no,
                                                                          source_ref5_          => find_deliveries_tab_(i).source_ref5,
                                                                          source_ref_type_db_   => Order_Type_API.DB_CUSTOMER_ORDER,
                                                                          part_no_              => part_no_,
                                                                          configuration_id_     => find_deliveries_tab_(i).configuration_id,
                                                                          lot_batch_no_         => find_deliveries_tab_(i).lot_batch_no,
                                                                          serial_no_            => find_deliveries_tab_(i).serial_no,
                                                                          eng_chg_level_        => find_deliveries_tab_(i).eng_chg_level,
                                                                          waiv_dev_rej_no_      => find_deliveries_tab_(i).waiv_dev_rej_no,
                                                                          activity_seq_         => find_deliveries_tab_(i).activity_seq,
                                                                          handling_unit_id_     => find_deliveries_tab_(i).handling_unit_id,
                                                                          transaction_code_     => 'CO-CONSUME',
                                                                          expiration_date_      => find_deliveries_tab_(i).expiration_date,
                                                                          ignore_expiration_date_ => 'FALSE');
         
         IF (find_deliveries_tab_(i).eng_chg_level = '*') THEN
            qty_consumed_ := qty_consumed_ + Inventory_Transaction_Hist_API.Get_Sum_Quantity(contract_             => contract_, 
                                                                          source_ref1_          => find_deliveries_tab_(i).order_no,
                                                                          source_ref2_          => find_deliveries_tab_(i).line_no,
                                                                          source_ref3_          => find_deliveries_tab_(i).rel_no,
                                                                          source_ref4_          => find_deliveries_tab_(i).line_item_no,
                                                                          source_ref5_          => find_deliveries_tab_(i).source_ref5,
                                                                          source_ref_type_db_   => Order_Type_API.DB_CUSTOMER_ORDER,
                                                                          part_no_              => part_no_,
                                                                          configuration_id_     => find_deliveries_tab_(i).configuration_id,
                                                                          lot_batch_no_         => find_deliveries_tab_(i).lot_batch_no,
                                                                          serial_no_            => find_deliveries_tab_(i).serial_no,
                                                                          eng_chg_level_        => '1',
                                                                          waiv_dev_rej_no_      => find_deliveries_tab_(i).waiv_dev_rej_no,
                                                                          activity_seq_         => find_deliveries_tab_(i).activity_seq,
                                                                          handling_unit_id_     => find_deliveries_tab_(i).handling_unit_id,
                                                                          transaction_code_     => 'CO-CONSUME',
                                                                          expiration_date_      => find_deliveries_tab_(i).expiration_date,
                                                                          ignore_expiration_date_ => 'FALSE'); 
         END IF;
         
         qty_delivered_ := Inventory_Transaction_Hist_API.Get_Sum_Quantity(contract_            => contract_, 
                                                                           source_ref1_         => find_deliveries_tab_(i).order_no,
                                                                           source_ref2_         => find_deliveries_tab_(i).line_no,
                                                                           source_ref3_         => find_deliveries_tab_(i).rel_no,
                                                                           source_ref4_         => find_deliveries_tab_(i).line_item_no,
                                                                           source_ref5_         => find_deliveries_tab_(i).source_ref5,
                                                                           source_ref_type_db_  => Order_Type_API.DB_CUSTOMER_ORDER,
                                                                           part_no_             => part_no_,
                                                                           configuration_id_    => find_deliveries_tab_(i).configuration_id,
                                                                           lot_batch_no_        => find_deliveries_tab_(i).lot_batch_no,
                                                                           serial_no_           => find_deliveries_tab_(i).serial_no,
                                                                           eng_chg_level_       => find_deliveries_tab_(i).eng_chg_level,
                                                                           waiv_dev_rej_no_     => find_deliveries_tab_(i).waiv_dev_rej_no,
                                                                           activity_seq_        => find_deliveries_tab_(i).activity_seq,
                                                                           handling_unit_id_    => find_deliveries_tab_(i).handling_unit_id,
                                                                           transaction_code_    => 'CO-DELV-IN',
                                                                           expiration_date_     => find_deliveries_tab_(i).expiration_date,
                                                                           ignore_expiration_date_ => 'FALSE');
     
      IF (qty_delivered_ - qty_consumed_ > 0) THEN 
            consignment_stock_qty_ := consignment_stock_qty_ + (qty_delivered_ - qty_consumed_);
         END IF;
      END LOOP;
   END IF;
   RETURN (consignment_stock_qty_);
END Get_Consignment_Stock_Qty__;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Deliver_Package_If_Complete
--   Check if delivered parts for the specified package add up to one ore
--   more complete package deliveries.If this is the case the update the
--   package header row in CustomerOrderLine and create a new delivery
--   record for the package header row.
PROCEDURE Deliver_Package_If_Complete (
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2,
   rel_no_   IN VARCHAR2 )
IS
BEGIN
   Deliver_Package_If_Complete___(order_no_, line_no_, rel_no_, TRUNC(Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(order_no_))), transaction_ => 'OESHIP' , delnote_no_ => NULL);
END Deliver_Package_If_Complete;


-- Deliver_Complete_Packages
--   Check if delivered parts of packages for the specified order add up to
--   one ore more complete package(s). If this is the case then 'deliver'
--   the completed package header lines.
PROCEDURE Deliver_Complete_Packages (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   Deliver_Complete_Packages___(order_no_, delnote_no_ => NULL);
END Deliver_Complete_Packages;


-- Modify_Order_Line_Cost
--   Sets the value of the total cost for the orderline after the all
--   components of the row has been delivered.
PROCEDURE Modify_Order_Line_Cost (
   transaction_    IN VARCHAR2,
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,
   qty_shipped_    IN NUMBER )
IS
   trans_order_no_         VARCHAR2(12) := order_no_;
   trans_line_no_          VARCHAR2(4) := line_no_;
   trans_rel_no_           VARCHAR2(4) := rel_no_;
   trans_line_item_no_     NUMBER := line_item_no_;
   order_type_             VARCHAR2(200) := Order_Type_API.Decode('CUST ORDER');
   str_code_               VARCHAR2(3);
   new_cost_               CUSTOMER_ORDER_LINE_TAB.cost%TYPE;
   sum_cost_               NUMBER;
   inv_part_no_            CUSTOMER_ORDER_LINE_TAB.Part_No%TYPE;
   contract_               CUSTOMER_ORDER_LINE_TAB.contract%TYPE;
   alt_source_ref1_        VARCHAR2(12) := NULL;
   alt_source_ref2_        VARCHAR2(4)  := NULL;
   alt_source_ref3_        VARCHAR2(4)  := NULL;
   alt_source_ref4_        NUMBER       := NULL;
   alt_source_ref_type_db_ VARCHAR2(10);
   charged_item_           VARCHAR2(20);
   
   $IF Component_Purch_SYS.INSTALLED $THEN
      CURSOR get_internal_demand_info IS
         SELECT order_no, line_no, release_no
         FROM purchase_order_line_tab 
         WHERE demand_order_no = order_no_
         AND demand_release = line_no_
         AND demand_sequence_no = rel_no_
         AND demand_operation_no = line_item_no_;
   $END
   sales_oh_cost_          NUMBER;
BEGIN
   IF (transaction_ IN ('SHIPDIR', 'SHIPTRAN')) THEN
      str_code_ := 'M4';
   ELSIF (transaction_ IN ('CO-SHIPDIR', 'CO-SHIPTRN')) THEN
         str_code_ := 'M3';
   ELSIF (transaction_ IN ('CRO-EXD-OU')) THEN
      str_code_ := 'M3';
   ELSIF (transaction_ IN ('PURSHIP', 'CO-PURSHIP', 'INTPURDIR', 'PURDIR')) THEN
      str_code_ := 'M15';
      Customer_Order_Line_API.Get_Demand_Order_Info(trans_order_no_,
                                                    trans_line_no_,
                                                    trans_rel_no_,
                                                    trans_line_item_no_,
                                                    order_no_,
                                                    line_no_,
                                                    rel_no_,
                                                    line_item_no_ );
      order_type_ := Order_Type_API.Decode('PUR ORDER');
      charged_item_ := Charged_Item_API.Encode(
                                             Customer_Order_Line_API.Get_Charged_Item(order_no_,
                                                                                      line_no_,
                                                                                      rel_no_,
                                                                                      line_item_no_));
   ELSIF (transaction_ IN ('OESHIP', 'CO-OESHIP')) THEN
      str_code_ := 'M24';
   ELSIF (transaction_ IN ('INTPODIRIM', 'PODIRINTEM')) THEN
      str_code_ := 'M4';
   ELSIF (transaction_ IN ('INTPODIRSH', 'PODIRSH')) THEN
      str_code_ := 'M24';
   ELSIF (transaction_ IN ('OESHIPNI', 'PODIRSH-NI')) THEN
      str_code_ := 'M26';
   ELSIF (transaction_ IN ('CO-CONSUME', 'DELIVCONF')) THEN
      str_code_ := 'M24';
   ELSIF (transaction_ IN ('INTSHIP-NI')) THEN
      str_code_ := 'M95';
   END IF;

   -- Retrieve the cost of the deliveries made so far
   trace_sys.message('Retrieve the cost of the deliveries made so far');
   IF (qty_shipped_ != 0) THEN
      IF (transaction_ IN ('PURSHIP','INTPURDIR','PURDIR')) THEN
         IF(charged_item_ = 'ITEM NOT CHARGED' ) THEN
            $IF Component_Purch_SYS.INSTALLED $THEN
               OPEN get_internal_demand_info;
               FETCH get_internal_demand_info INTO alt_source_ref1_, alt_source_ref2_, alt_source_ref3_;
               CLOSE get_internal_demand_info;
               alt_source_ref_type_db_ := 'PUR ORDER';   
            $ELSE
               NULL;
            $END 
         ELSE
            alt_source_ref1_        := order_no_;
            alt_source_ref2_        := line_no_;
            alt_source_ref3_        := rel_no_;
            alt_source_ref4_        := line_item_no_;
            alt_source_ref_type_db_ := 'CUST ORDER';               
         END IF;  
         sum_cost_ := Inventory_Transaction_Hist_API.Get_Sum_Value_Order_Line (order_type_, trans_order_no_,
                                                                               trans_line_no_, trans_rel_no_,
                                                                               trans_line_item_no_, str_code_,
                                                                               alt_source_ref1_, alt_source_ref2_, alt_source_ref3_,
                                                                               alt_source_ref4_, alt_source_ref_type_db_);
         new_cost_ := sum_cost_ / qty_shipped_;
      ELSIF (transaction_ IN ('EXCH-SHIP', 'CO-EX-SHIP')) THEN
         Customer_Order_Line_API.Get_Demand_Order_Info(trans_order_no_,
                                                       trans_line_no_,
                                                       trans_rel_no_,
                                                       trans_line_item_no_,
                                                       order_no_,
                                                       line_no_,
                                                       rel_no_,
                                                       line_item_no_);
         inv_part_no_ := Customer_Order_Line_API.Get_Part_No(order_no_, line_no_, rel_no_, line_item_no_);
         contract_    := Customer_Order_Line_API.Get_Contract(order_no_, line_no_, rel_no_, line_item_no_);
         new_cost_    := Inventory_Transaction_Hist_API.Get_Wip_Cost(trans_order_no_, trans_line_no_, trans_rel_no_, trans_line_item_no_,
                                                                     'PUR ORDER', transaction_,inv_part_no_, contract_);
      ELSIF (transaction_ IN ('OESHIP', 'CO-OESHIP', 'INTPODIRSH', 'PODIRSH', 'CO-CONSUME', 'DELIVCONF')) THEN
         -- For posting type 'M24'
         sum_cost_ := Inventory_Transaction_Hist_API.Get_Sum_Value_Order_Line (order_type_, trans_order_no_,
                                                                               trans_line_no_, trans_rel_no_,
                                                                               trans_line_item_no_, str_code_,
                                                                               NULL, NULL, NULL, NULL, NULL);
         -- For posting type 'M194'
         sales_oh_cost_ := Inventory_Transaction_Hist_API.Get_Sum_Value_Order_Line (order_type_, trans_order_no_,
                                                                                    trans_line_no_, trans_rel_no_,
                                                                                    trans_line_item_no_, 'M194',
                                                                                    NULL, NULL, NULL, NULL, NULL);

         new_cost_ := (sum_cost_ + sales_oh_cost_) / qty_shipped_;
      ELSE
         sum_cost_ := Inventory_Transaction_Hist_API.Get_Sum_Value_Order_Line (order_type_, trans_order_no_,
                                                                               trans_line_no_, trans_rel_no_,
                                                                               trans_line_item_no_, str_code_,
                                                                               NULL, NULL, NULL, NULL, NULL);

         new_cost_ := sum_cost_ / qty_shipped_;
      END IF;
      Customer_Order_Line_API.Modify_Cost(order_no_, line_no_, rel_no_, line_item_no_, new_cost_);
   END IF;
END Modify_Order_Line_Cost;


-- Direct_Delivery_From_Pur_Order
--   To be called from purchase when a direct delivery has been made for a purchase order connected to a customer order.
--   total_qty_shipped_on_pur_ord_ will have total quantity for tracked parts as delivery can be split with serial or lot batch.
PROCEDURE Direct_Delivery_From_Pur_Order (
   order_no_                     IN VARCHAR2,
   line_no_                      IN VARCHAR2,
   rel_no_                       IN VARCHAR2,
   line_item_no_                 IN NUMBER,
   qty_shipped_on_pur_ord_       IN NUMBER,
   catch_qty_shipped_on_pur_ord_ IN NUMBER,
   receipt_date_                 IN DATE,
   delivery_note_ref_            IN VARCHAR2,
   close_line_                   IN NUMBER,
   transaction_code_             IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   last_in_batch_                IN NUMBER,
   airway_bill_no_               IN VARCHAR2,
   qty_remaining_                IN NUMBER,
   configuration_id_             IN VARCHAR2,
   lot_batch_no_                 IN VARCHAR2, 
   eng_chg_level_                IN VARCHAR2,
   handling_unit_id_             IN NUMBER,
   waiv_dev_rej_no_              IN VARCHAR2,
   expiration_date_              IN DATE,
   session_id_                   IN NUMBER,
   on_approve_del_notification_  IN VARCHAR2,
   last_rec_in_del_notification_ IN VARCHAR2,
   mul_tier_dirdel_allowed_      IN VARCHAR2,
   deliv_no_                     IN NUMBER,
   total_qty_shipped_on_pur_ord_ IN NUMBER DEFAULT NULL)
IS
   qty_shipped_               NUMBER;
   qty_shipdiff_              NUMBER;
   qty_on_order_              NUMBER;
   revised_qty_due_           NUMBER;
   conv_factor_               CUSTOMER_ORDER_LINE_TAB.conv_factor%TYPE;
   inverted_conv_factor_      CUSTOMER_ORDER_LINE_TAB.inverted_conv_factor%TYPE;
   price_conv_factor_         CUSTOMER_ORDER_LINE_TAB.price_conv_factor%TYPE;
   part_cat_rec_              PART_CATALOG_API.Public_rec;
   close_tolerance_           NUMBER;
   sales_qty_to_ship_         NUMBER;
   part_no_                   VARCHAR2(25);
   create_sm_object_option_   VARCHAR2(20);
   cust_warranty_id_          NUMBER;
   demand_code_               VARCHAR2(20);
   delivery_leadtime_         NUMBER;
   ext_transport_calendar_id_ CUSTOMER_ORDER_LINE_TAB.ext_transport_calendar_id%TYPE;
   po_order_no_               VARCHAR2(12);
   po_line_no_                VARCHAR2(4);
   po_rel_no_                 VARCHAR2(4);
   purchase_type_             VARCHAR2(200);
   attr_                      VARCHAR2(2000);
   contract_                  CUSTOMER_ORDER_LINE_TAB.contract%TYPE;
   ship_addr_no_              VARCHAR2(50);
   temp_date_                 DATE;
   planned_due_date_          DATE;
   part_ownership_            CUSTOMER_ORDER_LINE_TAB.part_ownership%TYPE;
   charged_item_              VARCHAR2(20);
   old_qty_shipped_           NUMBER;
   old_cost_                  NUMBER;
   new_cost_                  NUMBER;
   old_total_cost_            NUMBER;
   new_total_cost_            NUMBER;
   cost_                      NUMBER;
   total_sales_qty_to_ship_   NUMBER;
   rowstate_                  CUSTOMER_ORDER_LINE_TAB.rowstate%TYPE;
   
   CURSOR get_line_attributes IS
      SELECT qty_shipped, revised_qty_due, close_tolerance, conv_factor, inverted_conv_factor, price_conv_factor,
             part_no, create_sm_object_option, cust_warranty_id, nvl(demand_code,'NOTNULL'), delivery_leadtime, ext_transport_calendar_id, contract, ship_addr_no, 
             planned_due_date, part_ownership, charged_item, cost, rowstate
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   OPEN  get_line_attributes;
   FETCH get_line_attributes INTO old_qty_shipped_, revised_qty_due_, close_tolerance_,
                                  conv_factor_, inverted_conv_factor_, price_conv_factor_, part_no_,
                                  create_sm_object_option_, cust_warranty_id_, demand_code_, delivery_leadtime_,
                                  ext_transport_calendar_id_, contract_, ship_addr_no_, planned_due_date_, part_ownership_, charged_item_, old_cost_, rowstate_;
   CLOSE get_line_attributes;

   IF (rowstate_ IN ('Invoiced', 'Delivered')) THEN      
      Error_SYS.Record_General(lu_name_, 'NOTALLOWEDTODELIVER: New deliveries cannot be made for Customer Orders which are in the :P1 state.', Customer_Order_Line_API.Get_State(order_no_, line_no_, rel_no_, line_item_no_));      
   END IF;
   
   IF (qty_shipped_on_pur_ord_ > 0) THEN      
      IF(charged_item_ = 'CHARGED ITEM') THEN
         -- Convert the total_qty_shipped_on_pur_ord_ in to Sales unit of measure.
         sales_qty_to_ship_       := (qty_shipped_on_pur_ord_ / conv_factor_ * inverted_conv_factor_);
         total_sales_qty_to_ship_ := NVL((total_qty_shipped_on_pur_ord_ / conv_factor_ * inverted_conv_factor_), sales_qty_to_ship_);
      ELSE
         sales_qty_to_ship_       := 0;
         total_sales_qty_to_ship_ := 0;
      END IF;
   END IF;
   
   IF (NVL(last_in_batch_,1) = 1) THEN
      -- Add value of total_qty_shipped_on_pur_ord_ if not null, as it is the total qty of different reservations of tracked parts
      qty_shipped_ := old_qty_shipped_ + NVL(total_qty_shipped_on_pur_ord_, qty_shipped_on_pur_ord_);  
      IF ((old_qty_shipped_ < revised_qty_due_) AND (qty_shipped_ >= revised_qty_due_) AND (qty_remaining_ > 0)) THEN
         qty_shipdiff_ := (qty_shipped_ + qty_remaining_) - revised_qty_due_;
         Customer_Order_API.Set_Line_Qty_Shipdiff(order_no_, line_no_, rel_no_, line_item_no_, qty_shipdiff_);
      END IF;
      Customer_Order_API.Set_Line_Qty_Shipped(order_no_, line_no_, rel_no_, line_item_no_, qty_shipped_);   

      -- Update CO Line Cost with average value of inventory transactions connected to the delivery
      Deliver_Customer_Order_API.Modify_Order_Line_Cost( transaction_code_,
                                                         order_no_,
                                                         line_no_,
                                                         rel_no_,
                                                         line_item_no_,
                                                         qty_shipped_ );

      IF ((close_line_ = 1) OR (qty_shipped_ >= (revised_qty_due_ * (1 - close_tolerance_/100)) AND line_item_no_ = 0 )) THEN
         qty_shipdiff_ := qty_shipped_ - revised_qty_due_;
         Customer_Order_API.Set_Line_Qty_Shipdiff(order_no_, line_no_, rel_no_, line_item_no_, qty_shipdiff_);
         qty_on_order_ := 0;
      ELSE
         qty_on_order_ := revised_qty_due_ - qty_shipped_;
      END IF;
      Customer_Order_Line_API.Modify_Qty_On_Order(order_no_, line_no_, rel_no_, line_item_no_, qty_on_order_);
      Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no_, po_line_no_, po_rel_no_, purchase_type_,
                                                          order_no_, line_no_, rel_no_, line_item_no_);

      IF (po_order_no_ IS NOT NULL) THEN
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('QTY_ON_ORDER', qty_on_order_, attr_);
         Customer_Order_Pur_Order_API.Modify(order_no_, line_no_, rel_no_, line_item_no_,
                                             po_order_no_, po_line_no_, po_rel_no_, attr_);
      END IF;
      IF (NVL(total_qty_shipped_on_pur_ord_, qty_shipped_on_pur_ord_) > 0) THEN
         -- Create a new delivery record        

         new_cost_       := Customer_Order_Line_API.Get_Cost(order_no_, line_no_, rel_no_, line_item_no_);
         new_total_cost_ := new_cost_*qty_shipped_;
         old_total_cost_ := old_cost_*old_qty_shipped_;
         cost_           := (new_total_cost_ - old_total_cost_)/NVL(total_qty_shipped_on_pur_ord_, qty_shipped_on_pur_ord_);

         Customer_Order_Delivery_API.New(order_no_, line_no_, rel_no_, line_item_no_, Invoice_Package_Component_API.Decode('N'),
                                         NULL, NULL, delivery_note_ref_, NVL(total_qty_shipped_on_pur_ord_, qty_shipped_on_pur_ord_), catch_qty_shipped_on_pur_ord_, total_sales_qty_to_ship_, 0, receipt_date_, ship_addr_no_, airway_bill_no_, cost_, deliv_no_);
         
         Create_Outstanding_Sales(deliv_no_, transaction_code_, order_no_, line_item_no_, total_sales_qty_to_ship_, NVL(total_qty_shipped_on_pur_ord_, qty_shipped_on_pur_ord_), cost_,receipt_date_);

         Customer_Order_Line_API.Modify_Real_Ship_Date(order_no_, line_no_, rel_no_, line_item_no_, receipt_date_);

         -- Check if MS Forecast Consumtion is active for the part delivered and then update MS Forecast is the part is not customer owned.
         IF (part_ownership_ != 'CUSTOMER OWNED') THEN
            Update_Ms_Forecast___(contract_, part_no_, NVL(total_qty_shipped_on_pur_ord_, qty_shipped_on_pur_ord_), planned_due_date_, FALSE);
         END IF;
      END IF;

      -- If package component check if package header can be delivered
      IF (line_item_no_ > 0) THEN
         Deliver_Package_If_Complete___(order_no_, line_no_, rel_no_, receipt_date_, transaction_code_, delnote_no_ => NULL);
      END IF;
      
      part_cat_rec_ := Part_Catalog_API.Get(part_no_);
      IF (part_cat_rec_.catch_unit_enabled = 'TRUE' ) THEN
      -- calculate and update the new price conv factor based on the catch quantities for catch unit handled parts.
         IF (catch_qty_shipped_on_pur_ord_ IS NOT NULL) THEN
            IF (catch_qty_shipped_on_pur_ord_ <= 0) THEN
               --Catch qty must be greater than zero
               Error_SYS.Record_General('DeliverCustomerOrder','CATCHQTYNEGATIVE: Catch Quantity must be greater than 0.');
            ELSE
               Pick_Customer_Order_API.Recalc_Catch_Price_Conv_Factor(order_no_,
                                                                      line_no_,
                                                                      rel_no_,
                                                                      line_item_no_);
            END IF;
         ELSE
            --Catch Qty cannot be null
            Error_SYS.Record_General('DeliverCustomerOrder', 'CATCHQTYPLSENTER: Part :P1 uses Catch Unit :P2 and Catch Quantity must be entered.',
                                                               part_no_, Inventory_Part_API.Get_Catch_Unit_Meas(contract_, part_no_));
         END IF;
      END IF;
   END IF;
   
   IF (serial_no_ IS NOT NULL) THEN
      IF (serial_no_ != '*') AND (qty_shipped_on_pur_ord_ > 0) THEN
         IF (cust_warranty_id_ IS NOT NULL) THEN
            Part_Serial_Catalog_API.Set_Or_Merge_Cust_Warranty(part_no_, serial_no_, cust_warranty_id_);
         END IF;

         Cust_Ord_Date_Calculation_API.Fetch_Calendar_End_Date(temp_date_, ext_transport_calendar_id_, receipt_date_, delivery_leadtime_);
         Serial_Warranty_Dates_API.Calculate_Warranty_Dates(part_no_, serial_no_, temp_date_);

         -- Note: Prevent creation of SM Object for INTPODIRIM
         IF (create_sm_object_option_ = 'CREATESMOBJECT') AND (demand_code_ NOT IN ('IPD','IPT')) THEN
            Create_Sm_Object___(order_no_, line_no_, rel_no_, line_item_no_, serial_no_);
         END IF;
      END IF;
   END IF;
   -- Check and trigger Multi-tier delivery notification   
   Send_Mul_Tier_Del_Notificat___(session_id_                   ,
                                  order_no_                     ,
                                  line_no_                      ,
                                  rel_no_                       ,
                                  line_item_no_                 ,
                                  deliv_no_                     , 
                                  sales_qty_to_ship_            ,
                                  catch_qty_shipped_on_pur_ord_ ,
                                  serial_no_                    ,
                                  last_in_batch_                ,
                                  configuration_id_             ,
                                  lot_batch_no_                 , 
                                  eng_chg_level_                ,
                                  handling_unit_id_             ,
                                  waiv_dev_rej_no_              ,
                                  expiration_date_              ,
                                  on_approve_del_notification_  ,
                                  last_rec_in_del_notification_ ,
                                  mul_tier_dirdel_allowed_ );
END Direct_Delivery_From_Pur_Order;


-- Get_Cumulative_Shipped_Qty
--   Sums total qty_shipped for currenct order_no, customer_part_no after
--   specified date.
@UncheckedAccess
FUNCTION Get_Cumulative_Shipped_Qty (
   order_no_         IN VARCHAR2,
   contract_         IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   calc_date_        IN DATE ) RETURN NUMBER
IS
   qty_shipped_ NUMBER;

   CURSOR get_cumulative_shipped_qty IS
      SELECT SUM((cod.qty_shipped / col.conv_factor * col.inverted_conv_factor)  /
                  nvl(col.customer_part_conv_factor, 1) * NVL(col.cust_part_invert_conv_fact, 1))
      FROM  CUSTOMER_ORDER_DELIVERY_TAB cod, CUSTOMER_ORDER_LINE_TAB col
      WHERE cod.order_no = order_no_
      AND   cod.order_no = col.order_no
      AND   cod.line_no = col.line_no
      AND   cod.rel_no = col.rel_no
      AND   cod.line_item_no = col.line_item_no
      AND   col.customer_part_no = customer_part_no_
      AND   cod.date_delivered >= calc_date_
      AND   cod.cancelled_delivery = 'FALSE';
BEGIN
   IF (Customer_Order_API.Get_Contract(order_no_) != contract_) THEN
      -- If the orders site don't match, return NULL.
      RETURN NULL;
   ELSE
      OPEN  get_cumulative_shipped_qty;
      FETCH get_cumulative_shipped_qty INTO qty_shipped_;
      IF (get_cumulative_shipped_qty%NOTFOUND) THEN
         qty_shipped_ := NULL;
      END IF;
      CLOSE get_cumulative_shipped_qty;
      RETURN qty_shipped_;
   END IF;
END Get_Cumulative_Shipped_Qty;



-- Get_Latest_Delnote_No
--   Returns latest delnote_no and date_delivered for specified order_no
--   and customer_part_no.
--   Returns latest delnote_no and date_delivered for specified customer
--   ship addr no and customer_part_no which is schedule connected.
@UncheckedAccess
PROCEDURE Get_Latest_Delnote_No (
   delnote_no_       OUT VARCHAR2,
   date_delivered_   OUT DATE,
   order_no_         IN  VARCHAR2,
   contract_         IN  VARCHAR2,
   customer_part_no_ IN  VARCHAR2 )
IS
   max_delnote_no_ customer_order_delivery_tab.delnote_no%TYPE;

   CURSOR get_latest_delnote_no IS
      SELECT max(to_number(delnote_no))
      FROM  CUSTOMER_ORDER_DELIVERY_TAB cod, CUSTOMER_ORDER_LINE_TAB col
      WHERE cod.order_no = order_no_
      AND   cod.order_no = col.order_no
      AND   cod.line_no = col.line_no
      AND   cod.rel_no = col.rel_no
      AND   cod.line_item_no = col.line_item_no
      AND   col.customer_part_no = customer_part_no_
      AND   cod.cancelled_delivery = 'FALSE';

   CURSOR get_latest_date_delivered IS
      SELECT max(date_delivered)
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE order_no = order_no_
      AND   delnote_no = max_delnote_no_
      AND   cancelled_delivery = 'FALSE';
BEGIN
   IF (Customer_Order_API.Get_Contract(order_no_) = contract_) THEN
      -- If the orders site match, find the delnote_no and delivery_date.
      OPEN  get_latest_delnote_no;
      FETCH get_latest_delnote_no INTO max_delnote_no_;
      CLOSE get_latest_delnote_no;

      delnote_no_ := max_delnote_no_;

      OPEN  get_latest_date_delivered;
      FETCH get_latest_date_delivered INTO date_delivered_;
      CLOSE get_latest_date_delivered;
   END IF;
END Get_Latest_Delnote_No;



-- Get_Latest_Delnote_No
--   Returns latest delnote_no and date_delivered for specified order_no
--   and customer_part_no.
--   Returns latest delnote_no and date_delivered for specified customer
--   ship addr no and customer_part_no which is schedule connected.
@UncheckedAccess
PROCEDURE Get_Latest_Delnote_No (
   delnote_no_       OUT VARCHAR2,
   date_delivered_   OUT DATE,
   sched_order_no_   OUT VARCHAR2,
   customer_no_      IN  VARCHAR2,
   ship_addr_no_     IN  VARCHAR2,
   contract_         IN  VARCHAR2,
   customer_part_no_ IN  VARCHAR2 )
IS
   max_delnote_no_  customer_order_delivery_tab.delnote_no%TYPE;
   order_no_        VARCHAR2(12);

   CURSOR get_latest_delnote_no IS
      SELECT max(to_number(delnote_no))
      FROM  CUSTOMER_ORDER_DELIVERY_TAB cod,
            CUSTOMER_ORDER_LINE_TAB     col,
            CUSTOMER_ORDER_TAB           co
      WHERE cod.order_no             = co.order_no
      AND   col.order_no             = co.order_no
      AND   co.scheduling_connection = 'SCHEDULE'
      AND   co.contract              = contract_
      AND   co.customer_no           = customer_no_
      AND   cod.order_no             = col.order_no
      AND   cod.line_no              = col.line_no
      AND   cod.rel_no               = col.rel_no
      AND   cod.line_item_no         = col.line_item_no
      AND   col.ship_addr_no         = ship_addr_no_
      AND   col.customer_part_no     = customer_part_no_
      AND   cod.cancelled_delivery = 'FALSE';

   CURSOR get_order_no IS
      SELECT cod.order_no
      FROM  CUSTOMER_ORDER_DELIVERY_TAB cod
      WHERE delnote_no  = max_delnote_no_
      AND   cod.cancelled_delivery = 'FALSE';

   CURSOR get_latest_date_delivered IS
      SELECT max(date_delivered)
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE order_no = order_no_
      AND   delnote_no = max_delnote_no_
      AND   cancelled_delivery = 'FALSE';
BEGIN
   OPEN  get_latest_delnote_no;
   FETCH get_latest_delnote_no INTO max_delnote_no_; --, order_no_;
   CLOSE get_latest_delnote_no;

   OPEN  get_order_no;
   FETCH get_order_no INTO order_no_;
   CLOSE get_order_no;

   -- If the orders site match, take the delnote_no and delivery_date.
   IF (Customer_Order_API.Get_Contract(order_no_) = contract_) THEN
      delnote_no_ := max_delnote_no_;
      sched_order_no_ := order_no_;

      OPEN  get_latest_date_delivered;
      FETCH get_latest_date_delivered INTO date_delivered_;
      CLOSE get_latest_date_delivered;
   END IF;
END Get_Latest_Delnote_No;



-- Get_Cum_Qty_After_Delnote_No
--   Returns the cumulative quantity delivered of the specified customer_part_no
--   after the specified delivery note number.
@UncheckedAccess
FUNCTION Get_Cum_Qty_After_Delnote_No (
   order_no_         IN VARCHAR2,
   contract_         IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   delnote_no_       IN VARCHAR2 ) RETURN NUMBER
IS
   qty_shipped_ NUMBER;
   delnote_     NUMBER;

   CURSOR get_cumulative_qty(delnote_ IN NUMBER) IS
      SELECT SUM((cod.qty_shipped / col.conv_factor * col.inverted_conv_factor)  /
                  nvl(col.customer_part_conv_factor, 1) * NVL(col.cust_part_invert_conv_fact, 1))
      FROM  CUSTOMER_ORDER_DELIVERY_TAB cod, CUSTOMER_ORDER_LINE_TAB col
      WHERE cod.order_no = order_no_
      AND   cod.order_no = col.order_no
      AND   cod.line_no = col.line_no
      AND   cod.rel_no = col.rel_no
      AND   cod.line_item_no = col.line_item_no
      AND   col.customer_part_no = customer_part_no_
      AND   ((to_number(delnote_no) > delnote_) OR delnote_no IS NULL)
      AND   cod.cancelled_delivery = 'FALSE';
BEGIN
   IF (Customer_Order_API.Get_Contract(order_no_) != contract_) THEN
      -- If the orders site don't match, return NULL.
      RETURN NULL;
   ELSE
      IF (Delivery_Note_API.Check_Exist(delnote_no_) = 'TRUE') OR
         (delnote_no_ IS NULL) THEN
         delnote_ := nvl(to_number(delnote_no_), 0);
         OPEN  get_cumulative_qty(delnote_);
         FETCH get_cumulative_qty INTO qty_shipped_;
         CLOSE get_cumulative_qty;
      END IF;
      RETURN qty_shipped_;
   END IF;
END Get_Cum_Qty_After_Delnote_No;


-- Sum_Qty_Btwn_Delnote_And_Date
--   Return the sum qty on customer order lines for a specified customer_part_no
--   after the specified delivery note number.
@UncheckedAccess
FUNCTION Sum_Qty_Btwn_Delnote_And_Date (
   order_no_         IN VARCHAR2,
   contract_         IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   delnote_no_       IN VARCHAR2,
   date_             IN DATE ) RETURN NUMBER
IS
  qty_shipped_   NUMBER;
  qty_remaining_ NUMBER;

  CURSOR get_cumulative_qty(delnote_ IN NUMBER) IS
      SELECT nvl(SUM((cod.qty_shipped / col.conv_factor * col.inverted_conv_factor) /
                     nvl(col.customer_part_conv_factor, 1) * NVL(col.cust_part_invert_conv_fact, 1)), 0)
      FROM  CUSTOMER_ORDER_DELIVERY_TAB cod, CUSTOMER_ORDER_LINE_TAB col
      WHERE cod.order_no = order_no_
      AND   col.customer_part_no = customer_part_no_
      AND   ((to_number(cod.delnote_no) > nvl(delnote_, 0)) OR delnote_no IS NULL)
      AND   cod.order_no = col.order_no
      AND   cod.line_no = col.line_no
      AND   cod.rel_no = col.rel_no
      AND   cod.line_item_no = col.line_item_no
      AND   col.wanted_delivery_date < date_
      AND   cod.cancelled_delivery = 'FALSE';

   CURSOR get_remaining_qty IS
      SELECT NVL(SUM(((revised_qty_due - qty_shipped + qty_shipdiff) / conv_factor *  inverted_conv_factor ) /
                      nvl(customer_part_conv_factor, 1) * NVL(cust_part_invert_conv_fact, 1)),0)
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    customer_part_no = customer_part_no_
      AND    (revised_qty_due - qty_shipped) > 0
      AND    wanted_delivery_date < date_
      AND    rowstate != 'Cancelled';
BEGIN
   OPEN  get_cumulative_qty(to_number(delnote_no_));
   FETCH get_cumulative_qty INTO qty_shipped_;
   CLOSE get_cumulative_qty;

   OPEN  get_remaining_qty;
   FETCH get_remaining_qty INTO qty_remaining_;
   CLOSE get_remaining_qty;

   RETURN (qty_shipped_ + qty_remaining_);
END Sum_Qty_Btwn_Delnote_And_Date;



-- Consign_Stock_Return_Allowed
--   Checks if the returned qty has been consumed from the Consignment Stock.
--   If not, an error message is displayed.
PROCEDURE Consign_Stock_Return_Allowed (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_returned_ IN NUMBER )
IS
   total_qty_consumed_ NUMBER;
   linerec_            Customer_Order_Line_API.Public_Rec;

   -- returns qty in sales U/M
   CURSOR get_total_qty_consumed IS
      SELECT SUM(QTY_TO_INVOICE)
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    cancelled_delivery = 'FALSE';
BEGIN
   OPEN  get_total_qty_consumed;
   FETCH get_total_qty_consumed INTO total_qty_consumed_;
   CLOSE get_total_qty_consumed;

   linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   IF ((total_qty_consumed_ * linerec_.conv_factor/linerec_.inverted_conv_factor) < (linerec_.qty_returned + qty_returned_)) THEN
      Error_SYS.Appl_General(lu_name_, 'NOT_CONSUMED_YET: The quantity must be consumed from the Consignment Stock before return.');
   END IF;
END Consign_Stock_Return_Allowed;


-- Confirmed_Deliv_Return_Allowed
--   Checks the returned qty has been delivery confirmed. If not, an error message is displayed.
--   If the delivery is NOT fully confirmed, still we should allow to return the whole amount in that delivery
--   because the confirmation transaction is done for the full quantity.
PROCEDURE Confirmed_Deliv_Return_Allowed (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_returned_ IN NUMBER )
IS
   total_qty_confirmed_ NUMBER;
   linerec_             Customer_Order_Line_API.Public_Rec;

   -- returns qty in inventory U/M
   CURSOR get_total_qty_confirmed IS
      SELECT NVL(SUM(QTY_SHIPPED), 0)
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    date_confirmed IS NOT NULL
      AND    cancelled_delivery = 'FALSE';
BEGIN
   OPEN  get_total_qty_confirmed;
   FETCH get_total_qty_confirmed INTO total_qty_confirmed_;
   CLOSE get_total_qty_confirmed;

   linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   -- If the order line is delivered with several partial deliveries, a consumption of one delivery line 
   -- should only allow to return the total amount stated in that delivery line.
   IF (total_qty_confirmed_ < linerec_.qty_returned + qty_returned_) THEN
      Error_SYS.Appl_General(lu_name_, 'NOT_CONFIRMED_YET: The quantity should be delivery confirmed before return.');
   END IF;
END Confirmed_Deliv_Return_Allowed;


-- Get_Part_Shipments_All_Orders
--   Return the total quantity shipped of a part in the specified date interval.
--   (Used by Master Scheduling)
@UncheckedAccess
FUNCTION Get_Part_Shipments_All_Orders (
   contract_   IN VARCHAR2,
   part_no_    IN VARCHAR2,
   date_from_  IN DATE,
   date_until_ IN DATE ) RETURN NUMBER
IS
   temp_ NUMBER;

   CURSOR get_total_qty_shipped IS
      SELECT SUM(cod.qty_shipped)
      FROM   CUSTOMER_ORDER_LINE_TAB col,
             CUSTOMER_ORDER_DELIVERY_TAB cod
      WHERE  col.order_no     = cod.order_no
      AND    col.line_no      = cod.line_no
      AND    col.rel_no       = cod.rel_no
      AND    col.line_item_no = cod.line_item_no
      AND    col.contract     = contract_
      AND    col.part_no      = part_no_
      AND    trunc(cod.date_delivered) BETWEEN trunc(date_from_) AND trunc(date_until_)
      AND    cod.cancelled_delivery = 'FALSE';
BEGIN
   OPEN get_total_qty_shipped;
   FETCH get_total_qty_shipped INTO temp_;
   CLOSE get_total_qty_shipped;
   RETURN NVL(temp_, 0);
END Get_Part_Shipments_All_Orders;


-- Is_Internal_Transit_Delivery
--   Returns 1 if the first customer order line connected to the delivery note is
--   an internal transit delivery type (INTDIRECT), else retruns 0.
@UncheckedAccess
FUNCTION Is_Internal_Transit_Delivery (
   order_no_   IN VARCHAR2,
   delnote_no_ IN VARCHAR2) RETURN NUMBER
IS
   found_ NUMBER;

   CURSOR find_trans_del_line IS
      SELECT DISTINCT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no  = order_no_
      AND    demand_code IN ('IPT', 'IPT_RO')
      AND    (line_no,rel_no) IN ( SELECT line_no,rel_no
                                   FROM   CUSTOMER_ORDER_DELIVERY_TAB
                                   WHERE  delnote_no = delnote_no_
                                   AND    order_no = order_no_
                                   AND    cancelled_delivery = 'FALSE' );
BEGIN
   OPEN find_trans_del_line;
   FETCH find_trans_del_line INTO found_;
   IF (find_trans_del_line%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE find_trans_del_line;
   RETURN found_;
END Is_Internal_Transit_Delivery;



-- Deliver_Line_Inv_Diff
--   Deliver inventory part on specified order line with differances.
--   Act as a public interface.
PROCEDURE Deliver_Line_Inv_Diff (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   close_line_   IN NUMBER,
   attr_         IN VARCHAR2,
   shipment_id_  IN VARCHAR2,
   remove_ship_  IN VARCHAR2 DEFAULT NULL )
IS
   info_  VARCHAR2(32000);
BEGIN
   Deliver_Line_Inv_With_Diff__(info_, order_no_, line_no_, rel_no_, line_item_no_, close_line_, attr_, remove_ship_, shipment_id_);
END Deliver_Line_Inv_Diff;


-- Modify_Cost_Of_Delivery
--   This method should be called from inventory when the cost of a delivery
--   transaction has been updated.
--   This could happen if the inventory part shipped on a customer order line
--   is setup with Invoice Consideration = Transaction Based.
PROCEDURE Modify_Cost_Of_Delivery (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   transaction_  IN VARCHAR2 )
IS
   linerec_  Customer_Order_Line_API.Public_Rec;
   new_cost_ NUMBER;
   
   CURSOR get_del_lines IS
      SELECT deliv_no
      FROM   CUSTOMER_ORDER_DELIVERY_TAB t
      WHERE  order_no     = order_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_
      AND    cancelled_delivery = 'FALSE';
BEGIN
   linerec_  := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   Modify_Order_Line_Cost(transaction_, order_no_, line_no_, rel_no_, line_item_no_, linerec_.qty_shipped);
   new_cost_ := Customer_Order_Line_API.Get_Cost(order_no_, line_no_, rel_no_, line_item_no_);
   
   FOR rec_ IN get_del_lines LOOP
      Customer_Order_Delivery_API.Modify_Cost(rec_.deliv_no, new_cost_);
   END LOOP;
END Modify_Cost_Of_Delivery;


-- Send_Deliv_Data_To_Dist_Order
--   Automatic Receipt Process start. Selects all the delivery information for
--   a customer order delivery by using deliv_no. Then it is packed to message
--   and send back to the DistributionOrder in order to create a purchase receipt.
PROCEDURE Send_Deliv_Data_To_Dist_Order (
   order_no_    IN VARCHAR2,
   deliv_no_    IN NUMBER,
   part_no_     IN VARCHAR2,
   location_no_ IN VARCHAR2,
   co_order_no_ IN VARCHAR2 )
IS
   CURSOR get_delivery_info IS
      SELECT order_no,
             line_no,
             rel_no,
             line_item_no,
             location_no,
             lot_batch_no,
             serial_no,
             expiration_date,
             eng_chg_level,
             qty_shipped,
             waiv_dev_rej_no,
             part_no,
             configuration_id,
             activity_seq,
             handling_unit_id
      FROM customer_order_reservation_tab
      WHERE deliv_no = deliv_no_
      AND order_no = co_order_no_;

   TYPE Deliv_Tab IS TABLE OF get_delivery_info%ROWTYPE
      INDEX BY PLS_INTEGER;
   delivery_rec_              Deliv_Tab;   
   delivery_count_            NUMBER := 0;
   msg_                       CLOB;   
   qty_shipped_               NUMBER :=0;
   condition_code_            VARCHAR2(10);
   do_supply_site_            VARCHAR2(5);
   do_demand_site_            VARCHAR2(5);
   qty_shipped_in_demand_uom_ NUMBER;
   qty_shipped_in_purch_uom_  NUMBER;
   purch_conv_factor_         NUMBER;
BEGIN
   -- Refer the Receive Purchase ORDER client AND pack the info TO a message   
   msg_   := Message_SYS.Construct('RECEIVE_DATA');  

   OPEN get_delivery_info;
   FETCH get_delivery_info BULK COLLECT INTO delivery_rec_;
   CLOSE get_delivery_info;

   delivery_count_ := delivery_rec_.count;

   IF (Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE) THEN
      IF (delivery_count_ > 0) THEN
         FOR i IN delivery_rec_.FIRST .. delivery_rec_.LAST LOOP            
            Message_SYS.Add_Attribute( msg_, 'LOCATION_NO', location_no_);
            Message_SYS.Add_Attribute( msg_, 'LOT_BATCH_NO', delivery_rec_(i).lot_batch_no);
            Message_SYS.Add_Attribute( msg_, 'SERIAL_NO', delivery_rec_(i).serial_no);
            Message_SYS.Add_Attribute( msg_, 'EXPIRATION_DATE', delivery_rec_(i).expiration_date);
            condition_code_ := Customer_Order_Line_API.Get_Condition_Code(delivery_rec_(i).order_no ,delivery_rec_(i).line_no ,delivery_rec_(i).rel_no, delivery_rec_(i).line_item_no);

            Message_SYS.Add_Attribute( msg_, 'CONDITION_CODE', condition_code_);
            Message_SYS.Add_Attribute( msg_, 'CONFIGURATION_ID', delivery_rec_(i).configuration_id);
            Message_SYS.Add_Attribute( msg_, 'ACTIVITY_SEQ', delivery_rec_(i).activity_seq);            
            Message_SYS.Add_Attribute( msg_, 'TRANSIT_ENG_CHG_LEVEL', delivery_rec_(i).eng_chg_level);
            Message_SYS.Add_Attribute( msg_, 'QTY_IN_STORE', 1);
            Message_SYS.Add_Attribute( msg_, 'INV_QTY_IN_STORE', 1);
            Message_SYS.Add_Attribute( msg_, 'HANDLING_UNIT_ID', delivery_rec_(i).handling_unit_id);
            Message_SYS.Add_Attribute( msg_, 'WAIV_DEV_REJ_NO', delivery_rec_(i).waiv_dev_rej_no);
         END LOOP;
      END IF;
      $IF (Component_Disord_SYS.INSTALLED) $THEN   
          Distribution_Order_API.Process_Cust_Order_Deliveries(msg_, order_no_, delivery_count_);
      $END
   ELSE
      IF (delivery_count_ > 0) THEN
         FOR i IN delivery_rec_.FIRST .. delivery_rec_.LAST LOOP
            $IF (Component_Disord_SYS.INSTALLED) $THEN   
                DECLARE
                   dist_rec_    Distribution_Order_API.Public_Rec;
                   do_order_no_ VARCHAR2(12);
                   po_order_no_ VARCHAR2(12);
                   po_line_no_  VARCHAR2(4);
                   po_rel_no_   VARCHAR2(4);
                BEGIN
                   do_order_no_       := order_no_;
                   dist_rec_          := Distribution_Order_API.Get(do_order_no_);
                   do_supply_site_    := dist_rec_.supply_site;
                   do_demand_site_    := dist_rec_.demand_site;
                   Distribution_Order_API.Get_Purchase_Order_Info(po_order_no_, po_line_no_, po_rel_no_, do_order_no_);
                   purch_conv_factor_ := NVL(Purchase_Order_Line_Part_API.Get_Conv_Factor(po_order_no_, po_line_no_, po_rel_no_), 1);
                END;

               -- convert the qty from supply site inv uom to demand site inv uom
               qty_shipped_in_demand_uom_ := Inventory_Part_API.Get_Site_Converted_Qty(do_supply_site_, part_no_, delivery_rec_(i).qty_shipped, do_demand_site_, 'REMOVE');
               -- convert (demand site) inv uom qty to purch uom
               qty_shipped_in_purch_uom_  := qty_shipped_in_demand_uom_ / purch_conv_factor_;
            $END

            Message_SYS.Add_Attribute( msg_, 'LOCATION_NO', location_no_);
            Message_SYS.Add_Attribute( msg_, 'LOT_BATCH_NO', delivery_rec_(i).lot_batch_no);
            Message_SYS.Add_Attribute( msg_, 'SERIAL_NO', delivery_rec_(i).serial_no);
            Message_SYS.Add_Attribute( msg_, 'EXPIRATION_DATE', delivery_rec_(i).expiration_date);
            condition_code_ := Customer_Order_Line_API.Get_Condition_Code(delivery_rec_(i).order_no ,delivery_rec_(i).line_no ,delivery_rec_(i).rel_no, delivery_rec_(i).line_item_no);

            Message_SYS.Add_Attribute( msg_, 'CONDITION_CODE', condition_code_);
            Message_SYS.Add_Attribute( msg_, 'CONFIGURATION_ID', delivery_rec_(i).configuration_id);
            Message_SYS.Add_Attribute( msg_, 'ACTIVITY_SEQ', delivery_rec_(i).activity_seq);
            Message_SYS.Add_Attribute( msg_, 'TRANSIT_ENG_CHG_LEVEL', delivery_rec_(i).eng_chg_level);
            Message_SYS.Add_Attribute( msg_, 'QTY_IN_STORE', qty_shipped_in_purch_uom_);
            Message_SYS.Add_Attribute( msg_, 'INV_QTY_IN_STORE', qty_shipped_in_demand_uom_);
            Message_SYS.Add_Attribute( msg_, 'HANDLING_UNIT_ID', delivery_rec_(i).handling_unit_id);
            Message_SYS.Add_Attribute( msg_, 'WAIV_DEV_REJ_NO', delivery_rec_(i).waiv_dev_rej_no);
            qty_shipped_ := qty_shipped_ + qty_shipped_in_purch_uom_;
         END LOOP;
      END IF;
     
      $IF (Component_Disord_SYS.INSTALLED) $THEN        
         Distribution_Order_API.Process_Cust_Order_Deliveries(msg_, order_no_, qty_shipped_);      
      $END
   END IF;
END Send_Deliv_Data_To_Dist_Order;


@UncheckedAccess
FUNCTION Get_Catch_Qty_To_Deliver (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   catch_qty_ NUMBER;
   CURSOR get_catch_qty IS
      SELECT SUM(catch_qty)
      FROM customer_order_reservation_tab
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND qty_picked > 0;
BEGIN
   OPEN  get_catch_qty;
   FETCH get_catch_qty INTO catch_qty_;
   CLOSE get_catch_qty;
   RETURN catch_qty_;
END Get_Catch_Qty_To_Deliver;



-- Get_Catch_Qty_Shipped
--   This method retrieves the total qty shipped in catch unit for a specific order line.
@UncheckedAccess
FUNCTION Get_Catch_Qty_Shipped (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   catch_qty_    NUMBER;

   CURSOR get_catch_qty IS
      SELECT SUM(catch_qty_shipped)
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no     = order_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_
      AND    qty_shipped  > 0
      AND    cancelled_delivery = 'FALSE';
BEGIN
   OPEN  get_catch_qty;
   FETCH get_catch_qty INTO catch_qty_;
   CLOSE get_catch_qty;
   RETURN NVL(catch_qty_,0);
END Get_Catch_Qty_Shipped;



-- Get_Catch_Qty_Shipped
--   This method retrieves the total qty shipped in catch unit for a specific shipment order line.
@UncheckedAccess
FUNCTION Get_Catch_Qty_Shipped (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   shipment_id_  IN NUMBER ) RETURN NUMBER
IS
   catch_qty_    NUMBER;

   CURSOR get_catch_qty IS
      SELECT catch_qty_shipped
      FROM   customer_order_delivery_tab
      WHERE  order_no     = order_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_
      AND    shipment_id  = shipment_id_
      AND    qty_shipped  > 0
      AND    cancelled_delivery = 'FALSE';
BEGIN
   OPEN  get_catch_qty;
   FETCH get_catch_qty INTO catch_qty_;
   CLOSE get_catch_qty;
   RETURN NVL(catch_qty_,0);
END Get_Catch_Qty_Shipped;


-- Deliver_Order_Line
--   Public method to Call DeliverOrderLine private method from outside the
--   LU to Deliver specified order line
PROCEDURE Deliver_Order_Line (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   info_ VARCHAR2(32000);
BEGIN
   Deliver_Order_Line__(info_,order_no_,line_no_,rel_no_,line_item_no_);
END Deliver_Order_Line;


-- Get_Line_Qty_Delivered
--   Returns delivered quantity for specified delivery note's
--   connected order line.
@UncheckedAccess
FUNCTION Get_Line_Qty_Delivered (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   delnote_no_   IN VARCHAR2 ) RETURN NUMBER
IS
   line_rec_                Customer_Order_Line_API.Public_Rec;
   qty_delivered_           NUMBER;
   pre_ship_invent_loc_no_  VARCHAR2(35);
   
   CURSOR get_preship_invent_loc_no IS
      SELECT pre_ship_invent_loc_no
      FROM   delivery_note_pub
      WHERE  delnote_no = delnote_no_;

   CURSOR get_preship_pkg_delivered_qty(revised_qty_due_ NUMBER) IS
      SELECT NVL(MIN(TRUNC(cor.qty_picked/(col.revised_qty_due/revised_qty_due_))),0)
      FROM   customer_order_line_tab col, customer_order_reservation_tab cor
      WHERE  col.order_no     = order_no_
      AND    col.line_no      = line_no_
      AND    col.rel_no       = rel_no_
      AND    col.line_item_no > 0
      AND    col.order_no     = cor.order_no
      AND    col.line_no      = cor.line_no
      AND    col.rel_no       = cor.rel_no
      AND    col.line_item_no = cor.line_item_no
      AND    cor.delnote_no   = delnote_no_;
BEGIN
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   OPEN get_preship_invent_loc_no;
   FETCH get_preship_invent_loc_no INTO pre_ship_invent_loc_no_;
   CLOSE get_preship_invent_loc_no;

   IF pre_ship_invent_loc_no_ IS NOT NULL THEN
      IF line_rec_.catalog_type = 'NON' THEN
         qty_delivered_ := line_rec_.qty_to_ship;
      ELSE
         IF (line_item_no_ = -1) THEN
            OPEN get_preship_pkg_delivered_qty(line_rec_.revised_qty_due);
            FETCH get_preship_pkg_delivered_qty INTO qty_delivered_;
            CLOSE get_preship_pkg_delivered_qty;
         ELSE
            qty_delivered_ := Customer_Order_Line_API.Get_Qty_Picked_On_Deliv_Note(order_no_,
                                                                                   line_no_,
                                                                                   rel_no_,
                                                                                   line_item_no_,
                                                                                   delnote_no_);
         END IF;
      END IF;
   ELSE
      qty_delivered_ := Customer_Order_Line_API.Get_Qty_Shipped_On_Deliv_Note(order_no_,
                                                                              line_no_,
                                                                              rel_no_,
                                                                              line_item_no_,
                                                                              delnote_no_);
   END IF;
   RETURN qty_delivered_;
END Get_Line_Qty_Delivered;



-- Get_Line_Total_Qty_Delivered
--   Returns total delivered quantity for specified delivery note's
--   connected order line.
@UncheckedAccess
FUNCTION Get_Line_Total_Qty_Delivered (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   delnote_no_   IN VARCHAR2 ) RETURN NUMBER
IS
   pre_ship_invent_loc_no_  VARCHAR2(35);
   
   CURSOR get_preship_invent_loc_no IS
      SELECT pre_ship_invent_loc_no
      FROM   delivery_note_pub
      WHERE  delnote_no = delnote_no_;

   CURSOR get_lines IS
      SELECT catalog_type,              
             DECODE(customer_part_buy_qty, NULL, (qty_shipped/conv_factor * inverted_conv_factor),
             (qty_shipped/conv_factor * inverted_conv_factor)/customer_part_conv_factor * cust_part_invert_conv_fact) qty_delivered,
             qty_to_ship,
             DECODE(customer_part_buy_qty, NULL, (qty_picked/conv_factor * inverted_conv_factor),
             (qty_picked/conv_factor * inverted_conv_factor)/customer_part_conv_factor * cust_part_invert_conv_fact) qty_picked                
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;

   linerec_              get_lines%ROWTYPE;
   total_delivered_qty_  NUMBER;
BEGIN
   OPEN get_preship_invent_loc_no;
   FETCH get_preship_invent_loc_no INTO pre_ship_invent_loc_no_;
   CLOSE get_preship_invent_loc_no;

   OPEN get_lines;
   FETCH get_lines INTO linerec_;
   CLOSE get_lines;

   IF pre_ship_invent_loc_no_ IS NOT NULL THEN
      IF linerec_.catalog_type = 'NON' THEN
         total_delivered_qty_ := linerec_.qty_delivered + linerec_.qty_to_ship;
      ELSE
         total_delivered_qty_ := linerec_.qty_delivered + linerec_.qty_picked;
      END IF;
   ELSE
      total_delivered_qty_ := linerec_.qty_delivered;
   END IF;
   RETURN total_delivered_qty_;
END Get_Line_Total_Qty_Delivered;



-- Get_Line_Qty_Remaining
--   Returns remaining quantity for specified delivery note's
--   connected order line.
@UncheckedAccess
FUNCTION Get_Line_Qty_Remaining (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   delnote_no_   IN VARCHAR2 ) RETURN NUMBER
IS
   pre_ship_invent_loc_no_  VARCHAR2(35);
   remaining_qty_           NUMBER;
   
   CURSOR get_preship_invent_loc_no IS
      SELECT pre_ship_invent_loc_no
      FROM   delivery_note_pub
      WHERE  delnote_no = delnote_no_;

   CURSOR get_lines IS
      SELECT catalog_type,              
             DECODE(customer_part_buy_qty, NULL, GREATEST(buy_qty_due - ((qty_shipped - qty_shipdiff)/conv_factor * inverted_conv_factor), 0),
             GREATEST(customer_part_buy_qty - (((qty_shipped - qty_shipdiff)/conv_factor * inverted_conv_factor)/customer_part_conv_factor * NVL(cust_part_invert_conv_fact, 1)),0)) qty_remaining,
             qty_to_ship,
             DECODE(customer_part_buy_qty, NULL, (qty_picked/conv_factor * inverted_conv_factor),
             (qty_picked/conv_factor * inverted_conv_factor)/customer_part_conv_factor * NVL(cust_part_invert_conv_fact, 1)) qty_picked                
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;

   linerec_  get_lines%ROWTYPE;
BEGIN
   OPEN get_preship_invent_loc_no;
   FETCH get_preship_invent_loc_no INTO pre_ship_invent_loc_no_;
   CLOSE get_preship_invent_loc_no;

   OPEN get_lines;
   FETCH get_lines INTO linerec_;
   CLOSE get_lines;

   IF pre_ship_invent_loc_no_ IS NOT NULL THEN
      IF linerec_.catalog_type = 'NON' THEN
         remaining_qty_ := GREATEST(linerec_.qty_remaining - linerec_.qty_to_ship, 0);
      ELSE
         remaining_qty_ := GREATEST(linerec_.qty_remaining - linerec_.qty_picked, 0);
      END IF;
   ELSE
      remaining_qty_ := linerec_.qty_remaining;
   END IF;
   RETURN remaining_qty_;
END Get_Line_Qty_Remaining;


-- Get_Tot_Qty_To_Deliver
--   This method retrieves the total qty to deliver for a specific order line.
@UncheckedAccess
FUNCTION Get_Tot_Qty_To_Deliver (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   qty_to_deliver_  NUMBER;
   CURSOR get_qty_to_deliver IS
      SELECT SUM(qty_to_deliver)
        FROM customer_order_reservation_tab
       WHERE order_no = order_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no = line_item_no_
         AND qty_picked > 0;
BEGIN
   OPEN  get_qty_to_deliver;
   FETCH get_qty_to_deliver INTO qty_to_deliver_;
   CLOSE get_qty_to_deliver;
   RETURN qty_to_deliver_;
END Get_Tot_Qty_To_Deliver;


-- Get_Tot_Catch_Qty_To_Deliver
--   This method retrieves the total catch qty to deliver for a specific order line.
@UncheckedAccess
FUNCTION Get_Tot_Catch_Qty_To_Deliver (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   catch_qty_to_deliver_  NUMBER;
   CURSOR get_catch_qty_to_deliver IS
      SELECT SUM(catch_qty_to_deliver)
        FROM customer_order_reservation_tab
       WHERE order_no = order_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no = line_item_no_
         AND qty_picked > 0;
BEGIN
   OPEN  get_catch_qty_to_deliver;
   FETCH get_catch_qty_to_deliver INTO catch_qty_to_deliver_;
   CLOSE get_catch_qty_to_deliver;
   RETURN catch_qty_to_deliver_;
END Get_Tot_Catch_Qty_To_Deliver;



-- Batch_Deliv_Pre_Ship_Del_Note
--   This method calls the Deliver_Pre_Ship_Del_Note__ method within a loop.
--   The purpose of this method is to deliver pre ship delivery notes for multiple
--   order records sent from the client.
PROCEDURE Batch_Deliv_Pre_Ship_Del_Note (
   long_info_ OUT VARCHAR2,
   key_list_  IN  VARCHAR2)
IS
   info_msg_exist_ BOOLEAN := FALSE;
   ptr_            NUMBER := NULL;
   count_          NUMBER := 0;
   name_           VARCHAR2(30);
   value_          VARCHAR2(2000);
   order_no_       customer_order_line_tab.order_no%TYPE;
   del_note_no_    customer_order_delivery_tab.delnote_no%TYPE;
   info_           VARCHAR2(2000);
   blocked_orders_ VARCHAR2(2000);
BEGIN
   IF (key_list_ IS NOT NULL) THEN
      WHILE (Client_SYS.Get_Next_From_Attr(key_list_, ptr_, name_, value_)) LOOP
         count_ := count_ + 1;
         -- Count variable is used to determine different attributes from the key_list_. Attributes are packed in the same order from the client.  
         CASE 
            WHEN count_ = 1 
                THEN order_no_ := value_;
            WHEN count_ = 2 
                THEN del_note_no_ := value_;
         END CASE;

         IF (count_ = 2) THEN
            count_ := 0;
            IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') THEN
               Deliver_Pre_Ship_Del_Note__(info_, order_no_, del_note_no_);
            ELSE
               blocked_orders_ := blocked_orders_ || order_no_ || ', ';
               info_msg_exist_ := TRUE;
            END IF;
         END IF;
      END LOOP;

      blocked_orders_ := RTRIM(blocked_orders_,', ');
      
      IF (info_msg_exist_) THEN
         Client_SYS.Add_Info(lu_name_, 'CRBLKORDLIST: The following order(s) are blocked due to exceeding the credit limit, failing the credit check or because of manual blocking: :P1.', blocked_orders_);
         long_info_ := long_info_ || Client_SYS.Get_All_Info;
      END IF;
   END IF;
END Batch_Deliv_Pre_Ship_Del_Note;


-- Get_Sched_Ord_Qty_Shipped
--   This method returns the sum of quantity shipped for schedule connected order in a
--   given delivery note.
@UncheckedAccess
FUNCTION Get_Sched_Ord_Qty_Shipped (
   delnote_no_       IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   ship_addr_no_     IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   contract_         IN VARCHAR2) RETURN NUMBER
IS
   shipment_id_              NUMBER;
   sched_connected_          VARCHAR2(5);
   sched_order_no_           VARCHAR2(12);
   qty_shipped_              CUSTOMER_ORDER_DELIVERY_CS.qty_shipped%TYPE;
   qty_shipped_temp_         CUSTOMER_ORDER_DELIVERY_CS.qty_shipped%TYPE;
   distinct_source_ref1_tab_ Shipment_Line_API.Source_Ref1_Tab; 
   
   CURSOR get_dem_sum_qty(order_no_ VARCHAR2) IS
      SELECT SUM(qty_shipped)
      FROM   CUSTOMER_ORDER_DELIVERY_CS
      WHERE  delnote_no       = delnote_no_
      AND    customer_part_no = customer_part_no_
      AND    order_no         = order_no_
      GROUP BY delnote_no, customer_part_no;

BEGIN
   sched_connected_ := 'FALSE';
   sched_order_no_  := Delivery_Note_API.Get_Order_No(delnote_no_);
   IF(sched_order_no_ IS NOT NULL) THEN   
      sched_connected_ := Customer_Order_API.Check_Delivered_Sched_Order(sched_order_no_,
                                                                         customer_no_,
                                                                         ship_addr_no_,
                                                                         customer_part_no_,
                                                                         contract_);
      IF (sched_connected_ = 'TRUE') THEN
         OPEN get_dem_sum_qty(sched_order_no_);
         FETCH get_dem_sum_qty INTO qty_shipped_;
         CLOSE get_dem_sum_qty;
      END IF;
   ELSE
      qty_shipped_ := 0;
      shipment_id_ := Delivery_Note_API.Get_Shipment_Id(delnote_no_);
      IF (shipment_id_ IS NOT NULL) THEN
         distinct_source_ref1_tab_ := Shipment_API.Get_Distinct_Source_Ref1(shipment_id_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
         IF (distinct_source_ref1_tab_.COUNT > 0) THEN
            FOR i IN distinct_source_ref1_tab_.FIRST..distinct_source_ref1_tab_.LAST LOOP
               sched_connected_ := Customer_Order_API.Check_Delivered_Sched_Order(distinct_source_ref1_tab_(i).source_ref1,
                                                                                  customer_no_,
                                                                                  ship_addr_no_,
                                                                                  customer_part_no_,
                                                                                  contract_);
               IF (sched_connected_ = 'TRUE') THEN  
                  OPEN get_dem_sum_qty(distinct_source_ref1_tab_(i).source_ref1);
                  FETCH get_dem_sum_qty INTO qty_shipped_temp_;
                  CLOSE get_dem_sum_qty;
                  qty_shipped_ := qty_shipped_ + qty_shipped_temp_;
               END IF;         
            END LOOP;
         END IF; 
      END IF;       
   END IF;
   RETURN qty_shipped_;
END Get_Sched_Ord_Qty_Shipped;



-- Is_Schedule_Connected
--   This method returns TRUE, if the order connected to the given delivery note is
--   connected to a customer schedule or, the shipment connected to the given delivery note
--   contains schedule connected order. It returns FALSE otherwise.
@UncheckedAccess
FUNCTION Is_Schedule_Connected (
   delnote_no_       IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   ship_addr_no_     IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   contract_         IN VARCHAR2) RETURN VARCHAR2
IS
   sched_connected_          VARCHAR2(5);
   sched_order_no_           VARCHAR2(12);
   shipment_id_              NUMBER;
   sched_connected_temp_     VARCHAR2(5);
   distinct_source_ref1_tab_ Shipment_Line_API.Source_Ref1_Tab;
BEGIN
   sched_connected_ := 'FALSE';
   sched_order_no_  := Delivery_Note_API.Get_Order_No(delnote_no_);
   IF (sched_order_no_ IS NOT NULL) THEN
      sched_connected_ := Customer_Order_API.Check_Delivered_Sched_Order(sched_order_no_,
                                                                         customer_no_,
                                                                         ship_addr_no_,
                                                                         customer_part_no_,
                                                                         contract_);         
   ELSE
      shipment_id_ := Delivery_Note_API.Get_Shipment_Id(delnote_no_);
      IF (shipment_id_ IS NOT NULL) THEN
         distinct_source_ref1_tab_ := Shipment_API.Get_Distinct_Source_Ref1(shipment_id_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
         IF (distinct_source_ref1_tab_.COUNT > 0) THEN
            FOR i IN distinct_source_ref1_tab_.FIRST..distinct_source_ref1_tab_.LAST LOOP
               sched_connected_temp_ := Customer_Order_API.Check_Delivered_Sched_Order(distinct_source_ref1_tab_(i).source_ref1,
                                                                                       customer_no_,
                                                                                       ship_addr_no_,
                                                                                       customer_part_no_,
                                                                                       contract_);
               IF (sched_connected_temp_ = 'TRUE') THEN
                  sched_connected_ := 'TRUE';
                  EXIT;
               END IF;         
            END LOOP;
         END IF;
      END IF;
   END IF;
   RETURN sched_connected_;
END Is_Schedule_Connected;


-- Get_Sched_Latest_Delivery_Date
--   This method returns the latest delivery date if a schedule connected order is
--   connected to the given delivery note or, the shipement delivery date if a shipment
--   is connected to the given delivery note and the shipment contains a schedule
--   connected order.
@UncheckedAccess
FUNCTION Get_Sched_Latest_Delivery_Date (
   delnote_no_       IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   ship_addr_no_     IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   contract_         IN VARCHAR2) RETURN VARCHAR2
IS
   date_delivered_           DATE;
   sched_connected_          VARCHAR2(5);
   sched_connected_temp_     VARCHAR2(5);
   sched_order_no_           VARCHAR2(12);   
   shipment_id_              NUMBER;
   distinct_source_ref1_tab_ Shipment_Line_API.Source_Ref1_Tab;
   
   CURSOR get_dem_date_deliv IS
      SELECT MAX(date_delivered)
      FROM   CUSTOMER_ORDER_DELIVERY_CS
      WHERE  delnote_no       = delnote_no_
      AND    customer_part_no = customer_part_no_
      AND    order_no         = sched_order_no_;   
BEGIN
   sched_order_no_ := Delivery_Note_API.Get_Order_No(delnote_no_);
   IF (sched_order_no_ IS NOT NULL) THEN
      sched_connected_ := Customer_Order_API.Check_Delivered_Sched_Order(sched_order_no_,
                                                                         customer_no_,
                                                                         ship_addr_no_,
                                                                         customer_part_no_,
                                                                         contract_);
      IF (sched_connected_ = 'TRUE') THEN
         OPEN  get_dem_date_deliv;
         FETCH get_dem_date_deliv INTO date_delivered_;
         CLOSE get_dem_date_deliv;
      END IF;
   ELSE
      shipment_id_ := Delivery_Note_API.Get_Shipment_Id(delnote_no_);
      IF (shipment_id_ IS NOT NULL) THEN
         distinct_source_ref1_tab_ := Shipment_API.Get_Distinct_Source_Ref1(shipment_id_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
         IF (distinct_source_ref1_tab_.COUNT > 0) THEN
            FOR i IN distinct_source_ref1_tab_.FIRST..distinct_source_ref1_tab_.LAST LOOP
               sched_connected_temp_ := Customer_Order_API.Check_Delivered_Sched_Order(distinct_source_ref1_tab_(i).source_ref1,
                                                                                       customer_no_,
                                                                                       ship_addr_no_,
                                                                                       customer_part_no_,
                                                                                       contract_);
               IF (sched_connected_temp_ = 'TRUE') THEN
                  date_delivered_ := Customer_Order_Delivery_API.Get_Actual_Shipment_Date(shipment_id_);
                  EXIT;
               END IF;         
            END LOOP;
         END IF;
      END IF;
   END IF;
   RETURN date_delivered_;
END Get_Sched_Latest_Delivery_Date;


FUNCTION Get_Actual_Del_Note_Ship_Date (
   delnote_no_             IN VARCHAR2,
   order_no_               IN VARCHAR2,
   pre_ship_invent_loc_no_ IN VARCHAR2 ) RETURN DATE 
IS
   count_date_              NUMBER;
   actual_ship_date_        DATE := NULL;    

   CURSOR check_real_ship_date   IS
      SELECT count(DISTINCT TRUNC(date_delivered))
      FROM   customer_order_line_tab col ,customer_order_delivery_tab  cod
      WHERE  col.order_no = order_no_
      AND    col.order_no = cod.order_no
      AND    col.line_no  = cod.line_no
      AND    col.rel_no   = cod.rel_no
      AND    col.line_item_no = cod.line_item_no
      AND    delnote_no = delnote_no_
      AND    cod.cancelled_delivery = 'FALSE';

   CURSOR get_real_ship_date IS
      SELECT MAX(date_delivered)
      FROM   customer_order_line_tab col, customer_order_delivery_tab cod
      WHERE  col.order_no = order_no_
      AND    col.order_no = cod.order_no
      AND    col.line_no  = cod.line_no
      AND    col.rel_no   = cod.rel_no
      AND    col.line_item_no = cod.line_item_no
      AND    delnote_no = delnote_no_
      AND    cod.cancelled_delivery = 'FALSE';
   
BEGIN
   OPEN check_real_ship_date;
   FETCH check_real_ship_date INTO count_date_;
   CLOSE check_real_ship_date;

   IF (count_date_ IN (1,0)) THEN
       OPEN get_real_ship_date;
       FETCH get_real_ship_date INTO actual_ship_date_;
       CLOSE get_real_ship_date;
   ELSIF (count_date_ > 1)  THEN
       actual_ship_date_ := NULL;
   END IF;
   
   RETURN actual_ship_date_;
END Get_Actual_Del_Note_Ship_Date; 


-- Delivery_Note_To_Be_Created
--   Return TRUE if the order has one ore more order lines for which a
--   delivery note has not been created.
@UncheckedAccess
FUNCTION Delivery_Note_To_Be_Created (
   order_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   found_ NUMBER;
   CURSOR create_delnote IS
      SELECT 1
        FROM customer_order_delivery_tab cod, customer_order_line_tab col
       WHERE col.order_no     = cod.order_no
         AND col.line_no      = cod.line_no
         AND col.rel_no       = cod.rel_no
         AND col.line_item_no = cod.line_item_no
         AND col.supply_code  NOT IN('PD', 'IPD')
         AND cod.line_item_no >= 0
         AND cod.order_no     = order_no_
         AND cod.delnote_no   IS NULL
         AND cod.cancelled_delivery = 'FALSE';   
BEGIN
   OPEN create_delnote;
   FETCH create_delnote INTO found_;
   IF (create_delnote%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE create_delnote;
   RETURN (found_ = 1);
END Delivery_Note_To_Be_Created;


@UncheckedAccess
FUNCTION Find_Pre_Ship_Delivery_Note (
   order_no_    IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   delnote_no_ delivery_note_tab.delnote_no%TYPE;
   CURSOR get_attr IS
      SELECT delnote_no
        FROM customer_order_reservation_tab
       WHERE order_no    = order_no_
         AND location_no = location_no_
         AND qty_picked  > 0;
BEGIN
   OPEN   get_attr;
   FETCH  get_attr INTO delnote_no_;
   CLOSE  get_attr;
   RETURN delnote_no_;
END Find_Pre_Ship_Delivery_Note;


-- Invalidate_Pre_Ship_Delnote
--   This method will be used to invalidate pre ship del notes when
--   the qty_to_ship is modified in the customer order line.
PROCEDURE Invalidate_Pre_Ship_Delnote (
   order_no_ IN VARCHAR2 )
IS
  CURSOR connected_lines IS
     SELECT DISTINCT delnote_no
       FROM customer_order_reservation_tab
      WHERE order_no = order_no_
        AND qty_picked > 0
        AND delnote_no IS NOT NULL;      
BEGIN
   FOR connected_lines_ IN connected_lines LOOP
      Delivery_Note_API.Set_Invalid(connected_lines_.delnote_no);
   END LOOP;
END Invalidate_Pre_Ship_Delnote;


-- Connect_Order_To_Deliv_Note
--   Set the delnote_no attribute in CustomerOrderDelivery for
--   delivered rows not already connected to a delivery note.
--   To be called when the state on a delivery note has to be changed to
PROCEDURE Connect_Order_To_Deliv_Note (
   delnote_no_ IN VARCHAR2 )
IS
   message_text_ VARCHAR2(255);
   delnoterec_   Delivery_Note_API.Public_Rec;  

   CURSOR get_line IS
      SELECT col.line_no, col.rel_no, col.line_item_no, col.demand_code
        FROM customer_order_line_tab col, CUST_ORDER_LINE_ADDRESS_2 cola
       WHERE (((col.addr_flag = 'N')
         AND (col.ship_addr_no = delnoterec_.receiver_addr_id)) OR ((col.addr_flag = 'Y')
         AND (cola.addr_1||'^'||cola.address1||'^'||cola.address2||'^'||cola.address3||'^'||cola.address4||'^'||cola.address5||'^'||cola.address6||'^'||cola.zip_code||'^'||cola.city||'^'||cola.state||'^'||cola.country_code||'^'||col.delivery_terms||'^'||col.del_terms_location||'^' =
              delnoterec_.receiver_addr_name||'^'||delnoterec_.receiver_address1||'^'||delnoterec_.receiver_address2||'^'||delnoterec_.receiver_address3||'^'||delnoterec_.receiver_address4||'^'||delnoterec_.receiver_address5||'^'||delnoterec_.receiver_address6||'^'||delnoterec_.receiver_zip_code||'^'||delnoterec_.receiver_city||'^'||delnoterec_.receiver_state||'^'||delnoterec_.receiver_country||'^'||DELNOTEREC_.delivery_terms||'^'||DELNOTEREC_.del_terms_location||'^')))
         AND col.addr_flag = delnoterec_.single_occ_addr_flag
         AND nvl(col.ship_via_code, ' ') = nvl(delnoterec_.ship_via_code, ' ')
         AND nvl(col.delivery_terms, ' ') = nvl(delnoterec_.delivery_terms, ' ')
         AND nvl(col.del_terms_location, ' ') = nvl(delnoterec_.del_terms_location, ' ')
         AND nvl(col.forward_agent_id, ' ') = nvl(delnoterec_.forward_agent_id, ' ')
         AND nvl(col.route_id, ' ') = nvl(delnoterec_.route_id, ' ')
         AND nvl(col.deliver_to_customer_no, ' ') = nvl(delnoterec_.receiver_id, ' ')
         AND col.line_item_no = cola.line_item_no
         AND col.rel_no   = cola.rel_no
         AND col.line_no  = cola.line_no
         AND col.order_no = cola.order_no
         AND col.supply_code != 'PD'
         AND col.shipment_connected = 'FALSE'
         AND col.supply_code NOT IN ('PD','IPD')
         AND EXISTS (
             SELECT 1
               FROM customer_order_delivery_tab cod
              WHERE cod.delnote_no IS NULL
                AND cod.order_no = col.order_no
                AND cod.line_no  = col.line_no
                AND cod.rel_no   = col.rel_no
                AND cod.line_item_no = col.line_item_no
                AND cod.cancelled_delivery = 'FALSE')
         AND col.order_no = delnoterec_.order_no;
  
BEGIN
   delnoterec_ := Delivery_Note_API.Get(delnote_no_);
   
   IF (delnoterec_.shipment_id IS NULL) THEN
      message_text_ := Language_SYS.Translate_Constant(lu_name_, 'DELNOCREATEDHEAD: Delivery note :P1 created', NULL, delnoterec_.alt_delnote_no );
      Customer_Order_History_API.New(delnoterec_.order_no, message_text_);
      -- fetch all lines that have the same criteria as the delivery note
      FOR linerec_ IN get_line LOOP
         -- Make connection to delivery note
         Connect_Line_To_Deliv_Note___(delnoterec_.order_no, linerec_.line_no,
                                       linerec_.rel_no,      linerec_.line_item_no,
                                       delnote_no_);
         IF (linerec_.demand_code = 'DO') THEN
            Set_Receipt_Ref_On_Receipt___(delnoterec_.order_no, 
                                          linerec_.line_no,
                                          linerec_.rel_no,
                                          delnote_no_);
         END IF;
      END LOOP;  
   END IF;
END Connect_Order_To_Deliv_Note;


-- Connect_Ship_Deliv_Note
--   Set the delnote_no attribute in CustomerOrderDelivery for
--   delivered rows not already connected to a delivery note.
--   To be called when the state on a delivery note has to be changed to
PROCEDURE Connect_Ship_Deliv_Note (
   delnote_no_ IN VARCHAR2 )
IS 
   delnoterec_      Delivery_Note_API.Public_Rec;
   demand_code_db_  VARCHAR2(20);
    
   CURSOR get_shipment_line IS
      SELECT s.source_ref1, s.source_ref2, s.source_ref3, s.source_ref4
        FROM shipment_line_tab s
       WHERE source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
         AND EXISTS (
             SELECT 1
               FROM customer_order_delivery_tab cod
              WHERE cod.order_no     = NVL(s.source_ref1, string_null_)
                AND cod.line_no      = NVL(s.source_ref2, string_null_)
                AND cod.rel_no       = NVL(s.source_ref3, string_null_)
                AND cod.line_item_no = NVL(s.source_ref4, string_null_)
                AND cod.shipment_id  = delnoterec_.shipment_id
                AND cod.cancelled_delivery = 'FALSE')
         AND s.shipment_id = delnoterec_.shipment_id;
BEGIN
   delnoterec_ := Delivery_Note_API.Get(delnote_no_);
   IF (delnoterec_.shipment_id IS NOT NULL) THEN   
      -- Delivery note for shipment. Connect all shipment order lines to delivery note
      FOR linerec_ IN get_shipment_line LOOP
         -- Make connection to delivery note
         Connect_Line_To_Deliv_Note___(linerec_.source_ref1, linerec_.source_ref2,
                                       linerec_.source_ref3, linerec_.source_ref4,
                                       delnote_no_);
         demand_code_db_ := Customer_Order_Line_API.Get_Demand_Code_Db(linerec_.source_ref1, 
                                                                       linerec_.source_ref2,
                                                                       linerec_.source_ref3,   
                                                                       linerec_.source_ref4);
      END LOOP;
   END IF;
END Connect_Ship_Deliv_Note;


-- Check_Del_Note_Addr_No
--   Custom removal check on ship address number.
--   Customer is located on the customer order and not on the delivery note.
PROCEDURE Check_Del_Note_Addr_No (
   receiver_id_      IN VARCHAR2,
   receiver_addr_id_ IN VARCHAR2)
IS   
   found_        NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   delivery_note_pub cod, customer_order_tab co
      WHERE cod.receiver_addr_id = receiver_addr_id_
      AND co.order_no = cod.order_no
      AND cod.receiver_id = receiver_id_;
BEGIN    
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   IF (found_ = 1) THEN
      Error_SYS.Record_General(lu_name_, 'SHIP_ADDRESS_EXIST: Ship Address :P1 exists on one or several Delivery Notes', receiver_id_);
   END IF;
END Check_Del_Note_Addr_No;


-- Get_Net_Summary
--   This method retreives the net summary information for
--   all connected order lines to specified delivery note.
@UncheckedAccess
PROCEDURE Get_Net_Summary (
   gross_total_  OUT NUMBER,
   net_total_    OUT NUMBER,
   total_volume_ OUT NUMBER,
   delnote_no_   IN  VARCHAR2,
   order_no_     IN  VARCHAR2 )
IS
   CURSOR order_line IS
      SELECT line_no, rel_no, line_item_no, conv_factor, inverted_conv_factor, contract, catalog_no, buy_qty_due
      FROM   CO_DELIV_NOTE_LINE
      WHERE  delnote_no = delnote_no_
      AND    order_no   = order_no_;

   ordline_rec_            Customer_Order_Line_API.Public_Rec;
   qty_delivered_          NUMBER;
   qty_delivered_tmp_      NUMBER;
   weight_net_             NUMBER;
   weight_gross_           NUMBER;
   volume_                 NUMBER;
   total_net_weight_       NUMBER;
   adjusted_net_weight_    NUMBER;
   adjusted_gross_weight_  NUMBER;
   adjusted_volume_        NUMBER;
   sales_part_rec_         Sales_Part_API.Public_Rec;
BEGIN
   gross_total_  := 0.0;
   net_total_    := 0.0;
   total_volume_ := 0.0;

   FOR next_row_ IN order_line LOOP
      sales_part_rec_    := Sales_Part_API.Get(next_row_.contract, next_row_.catalog_no);
      ordline_rec_       := Customer_Order_Line_API.Get(order_no_, next_row_.line_no, next_row_.rel_no, next_row_.line_item_no);
      -- Retrive the weight and volume for the sales part
      qty_delivered_     := Get_Line_Qty_Delivered(order_no_, next_row_.line_no, next_row_.rel_no, next_row_.line_item_no, delnote_no_);
      -- Retrieve the actual sales quantity delivered for weight and volume calculations 
      qty_delivered_tmp_ := ( qty_delivered_ / next_row_.conv_factor * next_row_.inverted_conv_factor);

      weight_net_        := Part_Weight_Volume_Util_API.Get_Config_Weight_Net(next_row_.contract, next_row_.catalog_no, ordline_rec_.configuration_id, sales_part_rec_.part_no, sales_part_rec_.sales_unit_meas,  sales_part_rec_.conv_factor, sales_part_rec_.inverted_conv_factor, Company_Invent_Info_API.Get_Uom_For_Weight(Site_API.Get_Company(next_row_.contract)));

      Sales_Weight_Volume_Util_API.Get_Total_Weight_Volume(total_net_weight_       => total_net_weight_,
                                                           total_gross_weight_     => weight_gross_,
                                                           total_volume_           => volume_,
                                                           adjusted_net_weight_    => adjusted_net_weight_,
                                                           adjusted_gross_weight_  => adjusted_gross_weight_,
                                                           adjusted_volume_        => adjusted_volume_,
                                                           contract_               => next_row_.contract,
                                                           catalog_no_             => next_row_.catalog_no,
                                                           part_no_                => ordline_rec_.part_no,
                                                           buy_qty_due_            => qty_delivered_tmp_,
                                                           configuration_id_       => ordline_rec_.configuration_id,
                                                           input_unit_meas_        => ordline_rec_.input_unit_meas,
                                                           input_qty_              => ordline_rec_.input_qty,
                                                           packing_instruction_id_ => ordline_rec_.packing_instruction_id);
      -- Update the totals
      IF (weight_net_ IS NOT NULL) THEN
         net_total_ := net_total_ + (weight_net_ * qty_delivered_tmp_);
      END IF;
      IF (weight_gross_ IS NOT NULL) THEN
         gross_total_ := gross_total_ + weight_gross_;
      END IF;
      IF (volume_ IS NOT NULL) THEN
         total_volume_ := total_volume_ + volume_;
      END IF;
   END LOOP;
END Get_Net_Summary;

PROCEDURE Post_Deliver_Shipment (
   shipment_id_   IN NUMBER,
   delnote_no_    IN VARCHAR2 )
IS
   customer_no_   VARCHAR2(20);
   media_code_    VARCHAR2(30);
   co_line_rec_   Customer_Order_Line_API.Public_Rec;
   order_no_      VARCHAR2(12) := NULL;
  
   CURSOR get_cos_to_send_delnote IS
      SELECT DISTINCT source_ref1
      FROM  shipment_line_pub sol
      WHERE shipment_id = shipment_id_
      AND   sol.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND EXISTS (SELECT 1
                  FROM customer_order_line_tab col
                  WHERE col.order_no   = sol.source_ref1
                  AND col.line_no      = sol.source_ref2
                  AND col.rel_no       = sol.source_ref3
                  AND col.line_item_no = sol.source_ref4
                  AND col.demand_code  = 'IPD');
      
   CURSOR get_delivered_orders IS
      SELECT order_no, line_no, rel_no, line_item_no, deliv_no, qty_shipped
      FROM   customer_order_delivery_tab
      WHERE  shipment_id IS NOT NULL AND shipment_id = shipment_id_
      AND    cancelled_delivery = 'FALSE'
      ORDER BY order_no;
BEGIN        
   IF (Delivery_Note_API.Get_Objstate(delnote_no_) = 'Printed') THEN
      FOR co_rec_ IN get_cos_to_send_delnote LOOP
         customer_no_ := Customer_Order_API.Get_Customer_no(co_rec_.source_ref1);
         media_code_  := Cust_Ord_Customer_API.Get_Default_Media_Code(customer_no_, 'DIRDEL');
         IF (media_code_ IS NOT NULL) THEN
            Customer_Order_Transfer_API.Send_Direct_Delivery(delnote_no_ => delnote_no_, 
                                                             order_no_   => co_rec_.source_ref1, 
                                                             media_code_ => media_code_,
                                                             session_id_ => NULL ); 
         END IF;
      END LOOP;
   END IF;

   FOR deliv_rec_ IN get_delivered_orders LOOP
      IF (Validate_SYS.Is_Different(deliv_rec_.order_no, order_no_)) THEN
         Cust_Order_Event_Creation_API.Order_Delivered_Using_Shipment(shipment_id_, deliv_rec_.order_no);
         order_no_ := deliv_rec_.order_no;
      END IF;
      co_line_rec_ := Customer_Order_Line_API.Get(deliv_rec_.order_no, deliv_rec_.line_no, deliv_rec_.rel_no, deliv_rec_.line_item_no);
      $IF (Component_Disord_SYS.INSTALLED) $THEN   
         IF (co_line_rec_.demand_code = 'DO' AND deliv_rec_.qty_shipped > 0) THEN
            Distribution_Order_API.Customer_Order_Delivered(co_line_rec_.demand_order_ref1, 
                                                            deliv_rec_.deliv_no);
            Set_Receipt_Ref_On_Receipt___(deliv_rec_.order_no, deliv_rec_.line_no, deliv_rec_.rel_no, delnote_no_);
         END IF;
      $END
   END LOOP;
END Post_Deliver_Shipment;

PROCEDURE Deliver_Ship_Line_Non_Inv (
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   line_item_no_    IN NUMBER,
   delnote_no_      IN VARCHAR2,
   shipment_id_     IN NUMBER)
IS
BEGIN
    Deliver_Line_Non_With_Diff___(order_no_        => order_no_,
                                  line_no_         => line_no_, 
                                  rel_no_          => rel_no_,
                                  line_item_no_    => line_item_no_, 
                                  close_line_      => 0,
                                  qty_to_deliver_  => NULL, 
                                  cancel_delivery_ => 'FALSE', 
                                  delnote_no_      => delnote_no_, 
                                  shipment_id_     => shipment_id_);
END Deliver_Ship_Line_Non_Inv;


PROCEDURE Deliver_Ship_Line_Inv (
   info_               OUT VARCHAR2,
   order_no_           IN  VARCHAR2,
   line_no_            IN  VARCHAR2,
   rel_no_             IN  VARCHAR2,
   line_item_no_       IN  NUMBER,
   delnote_no_         IN  VARCHAR2,
   shipment_id_        IN  NUMBER)
IS
BEGIN
   Deliver_Line_Inv_With_Diff___(info_                         => info_, 
                                 order_no_                     => order_no_, 
                                 line_no_                      => line_no_, 
                                 rel_no_                       => rel_no_, 
                                 line_item_no_                 => line_item_no_, 
                                 close_line_                   => 0, 
                                 attr_                         => NULL, 
                                 cancel_delivery_              => 'FALSE',
                                 delnote_no_                   => delnote_no_, 
                                 shipment_id_                  => shipment_id_, 
                                 remove_ship_                  => 'FALSE');
END Deliver_Ship_Line_Inv;   

PROCEDURE Pre_Deliver_Shipment (
   deliver_allowed_ OUT VARCHAR2,
   shipment_id_     IN  NUMBER )
IS  
   CURSOR get_orders IS
      SELECT source_ref1
        FROM shipment_line_pub 
       WHERE shipment_id =  shipment_id_
         AND Utility_SYS.String_To_Number(source_ref4) >= 0
         AND source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
         AND (qty_picked > 0 OR qty_to_ship >  0)
      GROUP BY source_ref1;
BEGIN  
   deliver_allowed_ := 'TRUE';
   --Perform credit check for all connected orders before delivery
   FOR rec_ IN get_orders LOOP
      Customer_Order_Flow_API.Credit_Check_Order(rec_.source_ref1,'DELIVER');
      IF (Customer_Order_API.Get_Objstate(rec_.source_ref1) = 'Blocked') THEN
         deliver_allowed_ := 'FALSE';
      END if;
   END LOOP;
END Pre_Deliver_Shipment;

FUNCTION Calculate_Totals (
   del_note_no_   IN  VARCHAR2,
   order_no_      IN  VARCHAR2) RETURN Calculated_Weight_Volume_Totals_Arr PIPELINED
IS
   rec_     Calculated_Weight_Volume_Totals_Rec;
BEGIN 
  Deliver_Customer_Order_API.Get_Net_Summary(rec_.gross_total_weight, rec_.net_total_weight, rec_.total_volume, del_note_no_, order_no_);  
  PIPE ROW (rec_);                       
END Calculate_Totals;

PROCEDURE Get_Last_Cum_Delnote_Data (
   date_delivered_   OUT DATE,   
   qty_shipped_      OUT NUMBER,
   customer_no_      IN VARCHAR2,
   ship_addr_no_     IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   delnote_no_       IN VARCHAR2 )
IS
   CURSOR get_last_delnote_delivery IS
   SELECT TRUNC(cod.date_delivered)                    date_delivered,
          SUM((cod.qty_shipped / col.conv_factor * col.inverted_conv_factor) /
              NVL(col.customer_part_conv_factor, 1) *
              NVL(col.cust_part_invert_conv_fact, 1))     qty_shipped
   FROM   CUSTOMER_ORDER_DELIVERY_TAB cod, CUSTOMER_ORDER_LINE_TAB col
   WHERE  col.order_no = cod.order_no
   AND    col.line_no = cod.line_no
   AND    col.rel_no = cod.rel_no
   AND    col.line_item_no = cod.line_item_no
   AND    cod.delnote_no IS NOT NULL
   AND    cod.cancelled_delivery = 'FALSE'
   AND    col.customer_no = customer_no_
   AND    col.ship_addr_no = ship_addr_no_
   AND    col.customer_part_no = customer_part_no_
   AND    cod.delnote_no = delnote_no_
   GROUP BY TRUNC(cod.date_delivered)
   ORDER BY TRUNC(date_delivered) DESC; 
   
BEGIN
   OPEN get_last_delnote_delivery;
   FETCH get_last_delnote_delivery INTO date_delivered_, qty_shipped_;
   CLOSE get_last_delnote_delivery;
END Get_Last_Cum_Delnote_Data;
