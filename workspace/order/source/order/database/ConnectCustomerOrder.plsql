-----------------------------------------------------------------------------
--
--  Logical unit: ConnectCustomerOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220112  ShWtlk   MF21R2-6416, Modified Release_Ctp_Planned_Lines___ to remove interim order headers created by neither reserver nor allocate option in capability check.
--  211125  PumJlk   Bug 161657(SCZ-16984), Modified Modify_Shop_Order___ by increasing so_info_ charactor length from 2000 to 32000
--  210615  JoAnSe   MF21R2-2079, Added parameter time_passed_with_date_ in call to Shop_Ord_API.Update_Need_Date.
--  201202  RasDlk   SCZ-11538, Modified Create_Connected_Order_Line___() to create Pegged orders for DB_NOT_VIS_PLANNED_RELEASED even though Rel_Mtrl_Planning is FALSE.  
--  201201  RoJalk   Bug 156034(SCZ-12196), Modified Create_Connected_Order_Line___() for not to change the supply code as IO from SO/DOP when executing Release Blocked Order.
--  201021  JoAnSe   MFZ-5372 Merged LCS bug 155479,
--  201021           PAWELK, Bug 155479 (MFZ-5182), Modified Modifiy_Shop_Order___ by passing revised_qty_due_ instead of order_qty_ as the QTY_ON_ORDER in attr_.
--  200625  ErFelk   Bug 154479(SCZ-10486), Modified Create_Internal_Pur_Order___() so that Send_Order_Change is sent by checking supplier's automatic change request value. 
--  200311  DaZase   SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in calls to Data_Capture_Session_Lov_API.New.
--  200122  DhAplk   Bug 151745 (SCZ-8399), Modified Modify_Conn_Cust_Order_Line() to add CUSTOMER_PART_BUY_QTY value to attr_ when it is NULL also to set update the Customer Sales Qty value in CO line.
--  191018  PamPlk   Bug 150393 (SCZ-7343), Modified Create_Purchase_Requisition___() to pass the correct value to eng_chg_level_.
--  190718  AmPlk    Bug 145427, Merged.
--  190718           Bug 145427, Modified the method Create_Shop_Order___ to call Validate_Shop_Order_Details to validate shop order details.
--  190619  ShPrlk   Bug 148057 (SCZ-4301), Modified Get_Qty_To_Receive_For_Demand to get quantities that could be recieved against an order. 
--  190508  KiSalk   Bug 148168 (SCZ-4686), Modified cursor get_ctp_planned_lines of Release_Ctp_Planned_Lines___, only to fetch Released CO lines 
--  190508           not to try to create Shop Order if one already exists.
--  181113  ShPrlk   Bug 145252(SCZ-1861), Modified Create_Internal_Pur_Order___ to fetch rental_no correctly and create rental lines respectively.
--  180301  RaKalk   STRMF-17414, Modified Connect_Wo_To_Mro_Line to pass handling_unit_id_ as NULL in to Find_Part method in inventory.
--  170927  RaVdlk   STRSC-11152, Removed Customer_Order_Line_API.Get_State__() and replaced with Customer_Order_Line_API.Get_State ()
--  170831  ApWilk   Bug 137598, Modified Modify_Conn_Cust_Order_Line() in order to replicate date changes to External CO, what do through the internal CO.
--  170911  ShPrlk   Bug 132048, Modified Modify_Conn_Cust_Order_Line to update the quantiy to the customer's buy quantity if the part has a sales part cross reference.
--  170426  JoAnSe  STRMF-7137, Replaced use of obsoleted Shop_Ord_Sched_Direction_API with Sched_Direction_API
--  170331  ChJalk   Bug 134609, Modified the method Modify_Connected_Order_Line to add the value for REVISED_QTY_DUE when the order address has been changed.
--  170327  NaLrlk   LIM-11230, Modified Modify_Conn_Cust_Order_Line() to handle replicate changes for packing instruction.
--  170321  NaLrlk   LIM-11230, Modified Modify_Connected_Order_Line() to handle packing instruction in replicate changes.
--  170320  NaSalk   LIM-11223, Modified Create_Internal_Pur_Order___ to pass packing instruction to purchase order when supply code is IPD. 
--  161104  TiRalk   STRSC-4544, Removed ORDER_SENT and CHANGE_REQUEST_SENT as print, email and order sending represent with new communication fields.
--  161103  JoAnSe   STRMF-7735, Removed the scrap factor consideration in Modify_Dop
--  161005  SeJalk   Bug 129623, Modified Modify_Dop(), Modify_Connected_Order_Line() to update quantity changes with inventory scrap factor.
--  161005           Modified Modify_Conn_Cust_Order_Line() to check the quantity changed without the scrap factor when changes come from DOP, PT or IPT.
--  160826  ChJalk   Bug 131122, Modified Modify_Conn_Cust_Order_Line to add SHIP_VIA_CODE from the customer order line, if it is NULL.
--  160718  DilMlk   Bug 129962, Modified Create_Shop_Order___ to use Transaction_SYS.Log_Status_Info instead of Transaction_SYS.Set_Status_Info in order to
--  160718           prevent getting a deadlock in TRANSACTION_SYS_STATUS_TAB when system tries to insert two consecutive warning/info messages.
--  160628  NaSalk   LIM-7724, Modified Get_Lot_Serial_For_Demand to return part ownership info.
--  160623  SudJlk   STRSC-2598, Replaced Cust_Order_Line_Address_API.Public_Rec with Cust_Order_Line_Address_API.Co_Line_Addr_Rec and 
--  160623           Cust_Order_Line_Address_API.Get() with Cust_Order_Line_Address_API.Get_Co_Line_Addr()
--  160520  reanpl   STRLOC-58, Added handling of new attributes address3, address4, address5, address6 
--  160217  ThEdlk   Bug 125706, Modified Modify_Dop() to update DOP header for the changes done through Customer Order Line Address dialogue.
--  151204  HimRlk   Bug 126039, Modified Create_Internal_Pur_Order___ to set changed_attrib_not_in_pol to FALSE only when order_sent flag is SENT.
--  151112  MaEelk   LIM-4453, Removed pallet_id from Reserve_Customer_Order_API.Reserve_Manually__.
--  150901  VISALK   STRMF-124, Changed the DOP_ID data type into VARCHAR2(12).
--  150417  MaEelk   LIM-1059, Added dummy parameter handling_unit_id_ 0 to the Inventory_Part_In_Stock_API.Find_Part
--  150626  RILASE   COB-519, Added Create_Data_Capture_Lov, Record_With_Column_Value_Exist and Get_Column_Value_If_Unique.
--  150422  HimRlk   Bug 121003, Modified method Modify_Connected_Order_Line() by changing the method call to fetch quantity due in stores for qty_on_order
--  150422           when order type is purchase order.
--  150208  MAHPLK   PRSC-5825, Modified the parameter list (remove send_from_co_) of Purchase_Order_Transfer_API.Send_Order_Change in Cancel_Connected_Order_Line() 
--  150208           Create_Internal_Pur_Order___ and Modify_Connected_Order_Line().
--  141214  OSALLK  PRSC-4401, Modified the method Modify_Connected_Order_Line to add REVISED_QTY instead of BUY_QTY_DUE to the attr_ variable.
--  141213  ErSrLK   PRMF-1600, Merged LCS Patch 117247.
--  141213           140813 ErSrLK Bug 117247, Modified Generate_Connected_Orders() to call Remove_Or_Retain_Interim_Head() instead of Remove_Interim_Head_By_Usage().
--  141211  MAHPLK   PRSC-4493, Modified the parameter list of Purchase_Order_Transfer_API.Send_Order_Change in Cancel_Connected_Order_Line() and Modify_Connected_Order_Line().
--  141113  RoJalk   PRSC-3986, Modified Modify_Connected_Order and added the parameter replicate_label_note_.
--  141030  RoJalk   Modify Modify_Connected_Order and removed the check_ipd_exists_ since header replication must have at least one IPD.
--  141028  RoJalk   Added parameters check_ipd_exists_ and check_ipt_not_exists_ to the method Modify_Connected_Order.
--  141027  RoJalk   Modified Modify_Connected_Order and called Purchase_Order_API.Modify_Order.
--  141022  NWeelk   Bug 119323, Modified Release_Internal_Pur_Order___ to stop releasing the created internal PO if the INTERACT_PUR_ORD is set in 
--  141022           the export control basic data and the part is export controlled, added parameter part_no_ to Release_Internal_Pur_Order___.
--  141020  RoJalk   Added the method Modify_Connected_Order to be used in CO header replication.
--  141014  HimRlk   Modified Modify_Connected_Order_Line() to handle delivery address information for supply_code IPD and PD.
--  141009  MAHPLK   Modified Modify_Connected_Order_Lineto pass the attribute through the attribute string. 
--  140929  RoJalk   Modified Create_Internal_Pur_Order___ checked if POCO is mandatory before adding to an existing PO.
--  140926  RoJalk   Modified Create_Internal_Pur_Order___ and added an info to indicate if the line is added to the existing PO.
--  140917  RoJalk   Modified Create_Internal_Pur_Order___ and added code to replicate new lines added to Existing Purchase Order in a state other than Planned state.
--  140912  MAHPLK   PRSC-2584, Added new method Modify_Conn_Cust_Order_Line with different method signature to pass modified attributes through the attribute string.
--  140828  MAHPLK   PRSC-2451, Added new parameter ship_via_code_ to Modify_Connected_Order_Line.
--  140708  BudKlk   Bug 110718, Modified Modify_Conn_Cust_Order_Line() method to avoid the incorrect calculation of sales qty 
--  140708           when the DOP order demand qty is chnaged. 
--  140619  KiSalk   Bug 117476, Modified Is_Pegged_Object_Updatable to fetch pegged purch object from Customer_Order_Pur_Order for all the supply types.
--  140619           Rewritten dynamic PL/SQL calls in the method with conditional compilation.
--  140417  MOADLK   Bug 116149, Removed copying Pre posting logic from Create_Cst_Ord_Shp_Ord_Conn___(). 
--  140513  RoJalk   Modified Create_Connected_Order_Line and added the OUT parameter qty_on_order_. 
--  140512  NaLrlk   Modified method Modify_Connected_Order_Line() to support for rental replicate changes.
--  140227  IsSalk   Bug 115537, Modified Create_Connected_Order_Line() in order to create intersite purchase orders in 'Planned' state 
--  140227           when there is no default method for 'ORDERS' message class for the internal supplier.
--  140123  AyAmlk   Bug 113885, Modified Create_Purchase_Requisition___() to increase the length of requisition_code_ to 20.
--  140123  MaKrlk   Changes were added to the Modify_Conn_Cust_Order_Line so that the rental related data is filtered out from the pur_req_attr_ using the method Rental_Object_API.Create_Rental_Attr 
--  131029  NaSalk   Added Get_Transit_Serials_For_Demand, Get_Transit_Lot_Qty_For_Demand and Get_Qty_To_Receive_For_Demand. Added view PARTS_DELIVERED_NOT_RECEIVED.
--  131016  CHRALK   Modified method Create_Internal_Pur_Order___().
--  131009  Vwloza   Added rental_attr_ and handling to Create_Purchase_Requisition___.
--  130605  NiDalk   Bug 110444, Modified Modify_Shop_Order_Peggings to calculate the quantities correctly. Also removed unused parameter revised_qty_due_.
--  130321  ChFolk   Modified Create_Purchase_Requisition___ to remove the code which fetches purchase conversion factor and purchase qty as it is ok to send null values and it is handled from purch side.
--  121102  RoJalk   Allow connecting a customer order line to several shipment lines- Modified Connect_Wo_To_Mro_Line and passed 0 as 
--  121102           shipment id to the method call Reserve_Customer_Order_API.Reserve_Manually.
--  120711  MaHplk   Added Added picking lead time as parameter to Cust_Ord_Date_Calculation_API.Calc_Order_Dates_Forwards, in Modify_Conn_Cust_Order_Line.
--  130704  AwWelk   TIBE-957, removed global variables inst_ShopOrd_, inst_SchedCapacity_, inst_ShopOrdSchedDirection_, inst_PurchaseReqUtil_, inst_PurchasePart_, 
--  130704           inst_PurchasePartSupplier_,inst_PurchaseOrder_, inst_DopDemandGen_, inst_Project_, inst_LineSchedManager_,inst_PurchaseOrderLineUtil_, 
--  130704           inst_InterimCtpManager_, inst_PurchaseOrderLinePart_, inst_InterimDemandHead_ and introduced conditional compilation.
--  130116  NWeelk   Bug 98604, Modified Modify_Conn_Cust_Order_Line to update the order line dates of a package part upon replicating. 
--  130314  MAATLK   PCM-2334, Modified the method Modify_Shop_Order___ to consider the shop order status "Parked'.
--  120919  CHINLK   Bug 102791, Modified Create_Connected_Order_Line___ to consider scrap factor when creating production schedules.
--  120717  VWLOZA   BRZ-365, replaced Project_Connection_API calls with Project_Connection_Util_API.
--  120312  MaMalk   Bug 99430, Modified several methods to consider inverted_conv_factor for calculation of BUY_QTY_DUE where conv_factor is used.
--  120131  THLILK   SMA-1468, Modified procedure Modify_Dop to correctly update qty_on_order.
--  111118  SBallk   Bug 99794, Modified Release_Internal_Pur_Orders___ and Release_Internal_Pur_Order___ to filter purchase order for the release.
--  111101  NISMLK   SMA-289, Increased eng_chg_level_ length to VARCHAR2(6) in Create_Purchase_Requisition___ and Connect_Wo_To_Mro_Line methods.
--  111026  Darklk   Bug 99082, Added Release_Internal_Pur_Orders and modified Create_Connected_Order_Line and Release_Internal_Pur_Order___
--  111026           to avoid releasing PO created/merged for package component parts.
--  111025  NWeelk   Bug 94992, Modified method Create_Connected_Order_Line___ to stop creating Shop Orders, Purchase Requisitions, Internal Purchase Orders or
--  111025             DOP orders if the rel_mtrl_planning = 'TRUE' in the specified COL.
--  111020  MoIflk   Bug 99333, Modified Release_Internal_Pur_Orders___ and Release_Internal_Pur_Order___ to create CO order after PO release.
--  110831  Darklk   Bug 98668, Modified the procedure Create_Connected_Order_Line___.
--  110728  RoJalk   Modified Create_Purchase_Requisition___,Create_Internal_Pur_Order___ and removed the LCS corrections 75932,91838 since ARR-NONINV - M93 will have include project pre posting.
--  110203  AndDse   BP-3776, Modifications for external transport calendar, in Modify_Conn_Cust_Order_Line, call to Cust_Ord_Date_Calculation_API.Calc_Order_Dates_Forwards.
--  110125  AndDse   BP-3776, Introduced external transport calendar, which is needed in a calculation called from this LU.
--  101108  ShRalk   Modified Is_Pegged_Object_Updatable to add state Change Order Created in condition.
--  110115  Nekolk   EAPM-13104 :fixed build errors.
--  110104  NaLrlk   Modified the method Modify_Conn_Cust_Order_Line.
--  101011  RiLase   Bug 91838, Changed project code fetch from Get_Project_No to Get_Project_Code_Value in
--  101011  RiLase   methods Create_Purchase_Requsition and Create_Internal_Pur_Order___.
--  100805  NALWLK   Bug 91922, Modified in Create_Dop() to remove updating the qty_on_order.
--  100803  ChJalk   Bug 92257, Modified method Modify_Conn_Cust_Order_Line to assign values for REVISED_QTY_DUE and BUY_QTY_DUE based on the supply code.  
--  100513  Ajpelk   Merge rose method documentation
--  100615  KaEllk   Corrected merge error in Create_Shop_Order_From_Oe.
--  100429  NuVElk   Merged TwinPeaks.
--  100318  RoJalk   Modified Create_Internal_Pur_Order___ to remove project pre posting for the IPD - companies for the same site.
--  100801  NALWLK   Bug 91922. Modified in Create_Dop() to check the dop_connection before updating the qty_on_order.
--  100210  SudJlk   Bug 88821, Modified Release_Ctp_Planned_Lines___().
--  100201  UtSwlk   Bug 87214, Modified method Create_Connected_Order_Line___ to check for remaining quantity to peg and existing supply orders before create new orders.
--  091023  RoJalk   Modified Create_Internal_Pur_Order___ to remove project preposting only when the demand code is IPD - sites from the same company. 
--  091022  RoJalk   Modified Remove_Project_Connection to check for the revenue connection before calling Project_Connection_Util_API.Remove_Connection. 
--  091001  RoJalk   Removed the parameter proj_lu_name_ from Remove_Project_Connection.Modified Remove_Project_Connection to remove both revenue and cost connections. 
--  090923  RoJalk   Added the parameter proj_lu_name_ to Remove_Project_Connection to support separate project connections for cost and revenue.
--  090716  RoJalk   SP4 Merge.
--  090302  ChJalk   Bug 79845, Modified the method Modify_Dop to allow changing DOP Order if the value of REPLICATE_DOP_IN_SERVER is "TRUE".
--  090129  SaJjlk   Bug 79846, Removed the length declaration for NUMBER type variable dummy_activity_seq_ in method Connect_Wo_To_Mro_Line. 
--  090710  RoJalk   Modified Create_Purchase_Requisition___ and passed linerec_.activity_seq to Purchase_Req_Util_API.New_Line_Part since both CT and CD is project connected.
--  090708  RoJalk   Modified Create_Purchase_Requisition___ to support the project connection when the demand code is 'PD'. 
--  090626  RoJalk   Modified Create_Internal_Pur_Order___ and passed activity_seq to Purchase_Order_API.Create_Int_Purch_Order
--  090626           to project connect the created purchase order when supply option is Purchase Order Trans.
--  090511  Ersruk   Passed in pre posting source 'CUSTOMER ORDER' when calling Pre_Accounting_API.Copy_Pre_Accounting.
--  090403  NuVelk   Modified Create_Purchase_Requisition___ to support the project connection.
--  090313  RoJalk   Modified Create_Shop_Order___ to support the project connection.
--  100114  KAYOLK   Replaced the obsolete usages of Shop_Order_Int_API calls to other relevant methods.
--  091224  MaEelk   Replaced the call Interim_Order_Int_API.Remove_Interim_Head_By_Usage with Interim_Demand_Head_API.Remove_Interim_Head_By_Usage.
--  091222  KAYOLK   Modified the methods Create_Internal_Pur_Order___() and Create_Purchase_Requisition___() for renaming the code part
--  091222           cost_center, object_no, and project_no as codeno_b, codeno_e and codeno_f respectively.
--  090930  MaMalk   Modified Create_Internal_Pur_Order___,Modify_Dop,More_Supplies_Expected,Create_Purchase_Requisition___,Modify_Shop_Order___ and Modify_Connected_Order_Line to remove unused code.
--  090930           Removed constant inst_DuplicateOperation_.
--  ------------------------- 14.0.0 -----------------------------------------
--  091208  Castse   Bug 86107, Modified the method Modify_Dop to check whether the Dop is modified from the customer order header level changes.
--  090911  HiWilk   Bug 85623, Modified Modify_Shop_Order___ to correctly pack the value of QTY_ON_ORDER before calling Shop_Ord_API.Modify.
--  090824  ChJalk   Bug 75274, Modified the methods Create_Shop_Order___, Create_Connected_Order_Line___, Modify_Shop_Order___, Create_Dop, Modify_Dop, 
--  090824           Generate_Connected_Orders, Modify_Connected_Order_Line and Modify_Conn_Cust_Order_Line to consider the reserved qty and shipped qty also when creating 
--  090824           pegged orders. Added IN parameter qty_shipped_ and qty_assigned_ to the method Modify_Connected_Order_Line. Also added the function More_Supplies_Expected.
--  090626  DaGulk   Bug 84232, Modified the variable length of media_code_ to VARCHAR2(30) in methods Cancel_Connected_Order_Line and Modify_Conn_Cust_Order_Line.
--  090302  ChJalk   Bug 79845, Modified the method Modify_Dop to allow changing DOP Order if the value of REPLICATE_DOP_IN_SERVER is "TRUE".
--  090129  SaJjlk   Bug 79846, Removed the length declaration for NUMBER type variable dummy_activity_seq_ in method Connect_Wo_To_Mro_Line. 
--  080815  NuVelk   Bug 75932, Modified Create_Internal_Pur_Order___ and Create_Purchase_Requisition___, not to pass
--  080815           project pre accounting data when supply_code is 'IPD' or 'PD'.
--  080704  HaYalk   Bug 74772, Modified Create_Production_Schedule___ to raise a info message in the background if prosch supply is back dated.
--  080625  MaMalk   Bug 75204, Modified Create_Shop_Order___ to update the message given by constant NEW_DUE_DATE.
--  080510  MaMalk   Bug 73434, Removed methods Check_Duplicate_Operations, Check_Ext_Dupl_Operations and Clear_Duplicate_Operations.
--  080422  ChJalk   Bug 73087, Modified the cursor lines_to_connect in Generate_Connected_Orders to avoid generating new pegged orders for 
--  080422           the lines where there are pegged orders which are processed and closed.
--  080328  MaMalk   Bug 70007, Modified Modify_Conn_Cust_Order_Line to change the conditions to replicate dates to customer order for IPD,PD,IPT and PT deliveries.
--  080303  MaRalk   Bug 70850, Modified Modify_Conn_Cust_Order_Line in order to update planning date for DOP lines which not satisfy the previous date comparison.
--  080108  NaLrlk   Bug 68613, Modified the procedure Generate_Connected_Orders to delete interim order structure.
--  071227  MaAtlk   Bug 68629, Modified the method Create_Shop_Order___ to pass NULL as the close tolerance to fetch the 
--  071227           manufacturing part attribute close tolerance value when shop order is created.
--  071218  ThAylk   Bug 68685, Modified procedure Connect_Wo_To_Mro_Line to change the parameter order of procedure Get_Next_Line_No.   
--  071120  NaLrlk   Bug 68044, Added SAVEPONT release_internal_po and Exception to the Release_Internal_Pur_Orders___.
--  071119  MaRalk   Bug 67755, Modified procedures Create_Purchase_Requisition___, Modify_Shop_Order___ and Create_Cst_Ord_Shp_Ord_Conn___ 
--  071119           in order to go with increased length of MESSAGE_TEXT column in CUSTOMER_ORDER_LINE_HIST_TAB.
--  070904  ChJalk   Modified Modify_Connected_Order_Line to change the pegged quantities in Shop Order and Customer Order.
--  070716  ChJalk   Modified Modify_Connected_Order_Line to replicate the qty change when the qty is less than the earlier qty.
--  070214  RaKalk   Bug 63166, Added an IF condition to Generate_Connected_Orders method, in order to prevent the creation of Connected lines if a configuration is not created for a configurable part.
--  070213  NuVelk   Bug 62972, Modified procedure Create_Internal_Pur_Order___ by altering cursor check_po_exist and by removing cursor get_relevent_po_no. 
--  070125  SaJjlk   Removed method Any_Shipment_Connected_Lines.
--  061120  NaLrlk   Bug 60637, Added an order by clause to the cursor check_po_exist in function Create_Internal_Pur_Order___.
--  060926  OsAllk   Bug 59869, Modified method Modify_Dop to update qty_on_order of CO line only if replicate changes = true or revised qty has been reduced.
--  060817  KaDilk   Reverse the public cursor removal changes done.
--  060731  KaDilk   Modified procedure Move_Serials_To_Module___.
--  060721  KaDilk   Modified procedure Move_Serials_To_Module___.
--  060720  RoJalk   Centralized Part Desc - Use Inventory_Part_API.Get_Description.
--  060523  IsWilk   Bug 57940, Modifeid currency_rate as null to call
--  060523           Purchase_Req_Util_API.New_Line_Part in PROCEDURE Create_Purchase_Requisition___.
--  060509  LaBolk   Bug 57071, Added parameters revised_qty_due_ and replicate_ch_flag_ to Modify_Shop_Order_Peggings.
--  060509           Modified the same method to update pegged qty correctly.
--  060424  IsAnlk   Enlarge Supplier - Changed variable definitions.
--  060419  IsWilk   Enlarge Customer - Changed variable definitions.
--  ------------------------- 13.4.0 -----------------------------------------
--  060317  LaBolk   Bug 56536, Modified Modify_Conn_Cust_Order_Line to change condition that updated pegged qty.
--  060309  IsWilk   Modified the PROCEDURE Modify_Conn_Cust_Order_Line to update te CO line
--  060309           when descreasing the CO line qty for not replicate changes.
--  060211  RaSilk   Modified method Modify_Dop to update customer order line qty_on_order.
--  060125  JaJalk   Added Assert safe annotation.
--  060124  NiDalk   Added Assert safe annotation.
--  051216  DaZase   Added new method Modify_Shop_Order_Peggings.
--  051214  MaJalk   Bug 54771, In procedure Connect_Wo_To_Mro_Line, added configuration_id_ to attr_, when creating MRO lines.
--  050921  SaMelk   Removed unused variables.
--  050907  DaZase   Changed the qty that will be sent to Create_Cst_Ord_Shp_Ord_Conn___ in method Release_Ctp_Planned_Lines___.
--  050510  Asawlk   Bug 50519, Replaced some dynamic SQL statements with EXECUTE IMMEDIATE format in Create_Shop_Order___(),
--  050510           Create_Purchase_Requisition___() and Create_Internal_Pur_Order___(), and passed value
--  050510           to new parameter CONTRACT when calling Pre_Accounting_API.Copy_Pre_Accounting().
--  050506  NaLrlk   Modify the method Modify_Connected_Order_Line for check the replicate_change_flag for SO and DOP.
--  050408  KeFelk   Changes to Create_Internal_Pur_Order___ regarding Deliver to Customer No.
--  050323  DaZase   Added an extra latest_release_date check in Release_Ctp_Planned_Lines___.
--  050314  LaBolk   Bug 48763, Modified parameters and logic of Modify_Conn_Cust_Order_Line and Modify_Connected_Order_Line to
--  050314           restructure the logic updating qty_on_order. Added global constant inst_PurchaseOrderLinePart_.
--  050310  IsWilk   Modified the error messge NOT_INV_LOCATION in PROCEDURE Connect_Wo_To_Mro_Line.
--  050306  VeMolk   Bug 49684, Modified the method Modify_Shop_Order___.
--  050216  IsAnlk   Modified Any_Shipment_Connected_Lines to fetch SHIPMENT_CONNECTED correctly..
--  050128  DaZase   Added methods Create_Cst_Ord_Shp_Ord_Conn___ and Release_Ctp_Planned_Lines___.
--  050120  JaJalk   Modified the Modify_Conn_Cust_Order_Line to correct the DOP replications.
--  050118  DaZase   Added a check on ctp_planned for Shop Orders in method Create_Connected_Order_Line___.
--  050111  ToBeSe   Bug 48995, Modified the cursor lines_to_connect in Generate_Connected_Orders
--                   to sort the order lines correctly.
--  050103  JaJalk   Corrected the variable server_data_change_ in Modify_Conn_Cust_Order_Line.
--  041217  KeFelk   Revised the change done on 041108.
--  041214  JaJalk   Modified the method Modify_Dop.
--  041123  NiRulk   Bug 44599, Restructured procedure Modify_Conn_Cust_Order_Line and added parameter planned_due_date_.
--  041122  KiSalk   In Create_Shop_Order___, call to Sched_Direction_API.Decode replaced with
--  041122           Shop_Ord_Sched_Direction_API and removed variable bom_type_.
--  041119  DiVelk   Changed cursor lines_to_connect in Generate_Connected_Orders.
--  041118  JaJalk   In Create_Shop_Order___, call to Sched_Direction_API.Decode
--  041118           replaced with Shop_Ord_Sched_Direction_API
--  041112  JaJalk   Modified the method Modify_Dop.
--  041108  KeFelk   Corrected to show Deliver_to_customer in PO's & ICO's when all IPD cases.
--  041104  IsAnlk   Removed dummy_number_ to call Reserve_Customer_Order_API.Reserve_Manually__.
--  041029  DiVelk   Modified Create_Connected_Order_Line___.
--  041026  DiVelk   Added procedure Create_Production_Schedule___.
--  041021  IsAnlk   Added dummy_number_ to call Reserve_Customer_Order_API.Reserve_Manually__.
--  041020  JaJalk   Modified the method Modify_Dop to handle the header date changes.
--  041014  LaBolk   Bug 46826, Added parameters, restructured and cleaned up code in methods Modify_Connected_Order_Line, Modify_Conn_Cust_Order_Line
--  041014           and Modify_Shop_Order___. Added constant inst_PurchaseOrderLineUtil_.
--  041006  LoPrlk   Method Modify_Dop was altered.
--  041004  DaZase   Added activity_seq in call to Reserve_Customer_Order_API.Reserve_Manually__.
--  040921  LoPrlk   Modified the method Modify_Dop.
--  040908  KiSalk   Added attribute QUICK_REGISTERED_PART_DB for 'Sales_Part_API.New' call.
--  040906  MaEelk   Added public method Remove_Project_Connection.
--  040902  KeFelk   removed contact from Create_Internal_Pur_Order___.
--  040825  DaRulk   Modified Connect_Wo_To_Mro_Line. Passed input uom parameters as null in method call
--                   Reserve_Customer_Order_API.Reserve_Manually__
--  040818  IsWilk   Modified the PROCEDURE Create_Internal_Pur_Order___ to fetch the PO Line Address.
--  040817  DhWilk   Inserted General_SYS.Init_Method to Any_Shipment_Connected_Lines
--  040721  IsWilk   Modified the PROCEDURE Create_Internal_Pur_Order___ to fetch the Intrastat from the External CO.
--  040716  WaJalk   Modified method Create_Internal_Pur_Order___.
--  040708  IsWilk   Modified the PROCEDURE Create_Internal_Pur_Order___ to fetch the correct address.
--  040707  IsWilk   Modified the PROCEDURE Create_Internal_Pur_Order___.
--  040624  LoPrlk   Method Create_Internal_Pur_Order___ was altered.
--  040525  MiKalk   Bug 44642, Modified method Create_Internal_Pur_Order___.
--  040514  DaZase   Project Inventory: Added dummy parameters to call Inventory_Part_In_Stock_API.Find_Part,
--                   change these parameters to real Activity_Seq and Project_Id values if this functionality uses Project Inventory.
--  040429  IsWilk   Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs
--  040429           and removed the unnecessary statements in the PROCEDURE Check_Duplicate_Operations,
--  040429           PROCEDURE Check_Ext_Dupl_Operations.
--  040308  WaJalk   Bug 42802, Modified method Modify_Conn_Cust_Order_Line to send REVISED_QTY_DUE to connected CO line.
--  040301  VeMolk   Bug 42007, Added the method Modify_Shop_Order___ and modified Modify_Connected_Order_Line method to call this method.
--  040129  GeKalk   Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  ------------------------------ 13.3.0-------------------------------------
--  ********************* VSHSB Merge End  *****************************
--  020528  DaMase   Changed customer_order_line to customer_order_line_tab to avoid deploy dependencies.
--  020124  Prinlk   Added the method Any_Shipment_Connected_Lines to check order
--                   lines connection with a shipment for a specific order.
--  ********************* VSHSB Merge *****************************
--  040126  GeKalk   Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  --------------------------------- 13.3.0 -------------------------------------
--  031022  ZiMolk   Bug 38376, Added an information message in the procedure Modify_Dop when pegged_qty_ < revised_qty_due_.
--  031008  PrJalk   Bug Fix 106224, Added Missing General_Sys.Init_Method calls.
--  030929  NuFilk   Modified Modify_Conn_Cust_Order_Line to handle revised qty due when package component lines are updated.
--  030911  NaWalk   Corrected the wrong pegging of CO to IPO.. in Create_Internal_Pur_Order___
--  030901  NuFilk   CR Merge 02
--  030825  ChBalk   Changed parameter name in Modify_Conn_Cust_Order_Line
--  030825  WaJalk   Code review modifications.
--  **************************** CR Merge 02 ************************************
--  030820  NuFilk   CR-TakeOff Merge.
--  030812  SeKalk   Modified the cursor check_po_exist in procedure Create_Internal_Pur_Order___
--  030730  NuFilk   Moved some code in Modify_Connected_Order_Line to Purchase_Order_Line_API.Modify_Ord_Line.
--  030619  NuFilk   Added a Check in Modify_Connected_Order_Line for media code.
--  030620  WaJalk   Removed commented coding in method Is_Pegged_Object_Updatable.
--  030619  NuFilk   Removed parameter to method Cancel_Connected_Order_Line.
--  030618  ChBalk   Added Modify_Conn_Cust_Order_Line.
--  030617  WaJalk   Modified method Is_Pegged_Object_Updatable.
--  030616  NuFilk   Added parameter to method Cancel_Connected_Order_Line.
--  030612  WaJalk   Added Method Is_Pegged_Object_Updatable.
--  030610  ChBalk   Added Default NULL parameter to the Modify_Connected_Order_Line and continue the order change replication.
--  030512  BhRalk   Modified the Cursor  check_po_exist in method Create_Internal_Pur_Order___.
--  030512  BhRalk   Modified the method Create_Internal_Pur_Order___.
--  030505  DaZa     All occurences of acquisition type/mode changed to supply code.
--  **************************** CR Merge ************************************
--  030806 GeKalk Call Id 99383, Modified Create_Internal_Pur_Order___ to add condition_code to method call ofPurchase_Order_API.Create_Int_Purch_Order.
--  030701 ChFolk Modified function Is_Wo_Connected_To_Mro_Line to return FALSE when the order line status is Cancelled.
--  030610 AnJplk Modified Create_Shop_Order___.
--  030609 ChFolk Call ID 98135. Modified procedure Is_Wo_Connected_To_Mro_Line.
--  030609 ChFolk Call ID 98287. Modified procedure Connect_Wo_To_Mro_Line to add the modified condition code into the customer order line when the object is returned.
--  030609 ChFolk Call ID 98209. Modified procedure Connect_Wo_To_Mro_Line to give an error message when reserving objects from an arrival location.
--  030604 ChFolk Modified code review changes.
--  030528 ChFolk Added a new FUNCTION Is_Order_Line_Exist. Modified the parameters of the procedure Connect_Wo_To_Mro_Line.
--  030527 ChFolk Modified parameters of FUNCTION Is_Wo_Connected_To_Mro_Line.
--  030526 ChFolk Modified procedure Connect_Wo_To_Mro_Line.
--  030526 SaAblk Removed references to LU ConnectCustomerOrder.
--  030521 ChFolk Added a new PROCEDURE Connect_Wo_To_Mro_Line.
--                Added a new FUNCTION Is_Wo_Connected_To_Mro_Line.
--  030521 SaAblk Modified method Check_Ext_Dupl_Operations by removing references to obsolete LU ExtCustOrdOptionChange.
--  030403 SudWlk Modified methods, Release_Internal_Pur_Orders___ and Release_Internal_Pur_Order___.
--  030331 SudWlk Removed obsolete parameters from method calls to Customer_Order_Pur_Order_API.New in methods,
--  030331        Create_Purchase_Requisition, Create_Internal_Pur_Order and Connect_To_Ctp_Generated_Order.
--  030319 GeKaLk Done code review modifications.
--  030307 GeKaLk Added revised_qty_due_ as a attribute to Customer_Order_Pur_Order_API.New method in
--                Create_Internal_Pur_Order___, Create_Purchase_Requisition___ , Create_Shop_Order___ to
--                update the qty_on_order field.
--  020906 NABEUS Added condition_code to Purchase_Req_Util_API.New_Line_Part in Create_Purchase_Requisition___
--                method. Call 88615.
--  020731 JOMCUS Added condition_code in call to Shop_Order_Int_API.Create_Shop_Order_From_Oe.
--  020522 SuAmlk Extended the length of the parameters, serial_begin and serial_end in the Procedure Create_Shop_Order___.
--  ******************************** AD 2002-3 Baseline ************************************
--  020322 SaKaLk Call 77116(Foreign Call 28170). Added county to calling method
--                'PURCHASE_ORDER_API.Create_Int_Purch_Order' parameter list.
--  020305  JaBa  Bug Fix 27737, Modified the Modify_Dop.
--  010412  JaBa  Bug Fix 20598,Added global lu constants and used those in necessary places.
--  001211  DaZa  Added check in Create_Connected_Order_Line___ for ctp_planned_db_ when creating DOP.
--  001127  JakH  Corrected select stmt in Create_Connected_Order_Line___
--  001124  JoAn  CID 55232 Corrected spelling error for configuration_id in dynamic call in Create_Internal_Pur_Order___
--  001123  JAkH  Added configuration id to call to purchase. Added parameter to Create_Internal_Pur_Order___
--  001103  MaGu  Changed call to Create_Int_Purch_Order in Create_Internal_Pur_Order___. Changed to new address format.
--  001030  DaZa  Added method Connect_To_Ctp_Generated_Order.
--  001013  JoAn  Added config_id and several other parameters in call to
--                Purchase_Req_Util_API.New_Line_Part
--  000913  FBen  Added UNDEFINE.
--  000908  JoEd  Changed length on supply_code in dynamic call in Create_Internal_Pur_Order___.
--  --------------------- 13.0 ----------------------------------------------
--  000607  JoEd  Bug fix 15829, Changed checks on purchase_type_ from db values
--                to client values in Modify_Connected_Order_Line and
--                Cancel_Connected_Order_Line.
--                Added parameter part_no in call to Purchase_Order_Option_API.New and added
--                call to Purch_Revision_Status_API.Decode in Modify_Connected_Order_Line.
--                Moved call to Customer_Order_Pur_Order_API.New in Create_Internal_Pur_Order___.
--  000512  JoAn  Bug fix 14997, cursors are correctly closed in Create_Shop_Order___,
--                also restructured the dynamic code for cursors used for
--                options so that parse and open is only done once.
--  000425  PaLj  Changed check for installed logical units. A check is made when API is instantiatet.
--                See beginning of api-file.
--  000418  JoAn  Replace call to Inventory_Part_Planning_API.Get_Scrapping_Adjusted_Qty
--                with Get_Scrap_Added_Qty.
--  000331  JoAn  Added handling for new DOP Connection REL in Create_Dop.
--  000309  JoEd  Added exist check in Modify_Dop.
--  000214  DaMa  Removed unnecessary statments in exception for Check_Duplicate_Operations and
--                Check_Ext_Dupl_Operations.
--  --------------------- 12.0 ----------------------------------------------
--  991101  JoEd  Changed misspelled bind variable in Cancel_Dop.
--  991006  JoEd  New attributes in Purchase_Order_API.Create_Int_Purch_Order call.
--  991004  JoEd  Changed part no to purchase part no in call Create_Internal_Pur_Order___.
--  990924  JoEd  Changed call to Modify_Req_Demand_Order_Info.
--  990923  JoEd  Changed Create_Purchase_Requisition___ to use purchase part no
--                instead of part no - due to non-inventory sales parts' order supply.
--                Changed fetch of order address to fetch it from the order line
--                instead of order header.
--  990910  JoAn  Added parameter line_item_no_ in call made to
--                Modify_Req_Demand_Order_Info in Create_Purchase_Requisition___
--  --------------------- 11.1 ----------------------------------------------
--  990617  JICE  Fixes for checks on duplicate operations on order change.
--  990617  JICE  Corrected error when creating allocations for purchased
--                options in Create_Shop_Order__.
--  990611  JICE  Corrected Check_Ext_Dupl_Operations.
--  990610  JICE  In call to Shop_Material_Alloc_Int.Make_Standard_Allocation,
--                added draw_pos_no.
--  990604  JICE  Corrected call to create purchase order options.
--  990602  JICE  Corrected dynamic call to get objstate from shop order.
--  990507  JoAn  Moved the logic from Create_Connected_Order_Line to
--                implementation method.
--  990506  JoAn  CID 14721 Create_Purchase_Requisition___: Scrap factor only
--                considered when acquisition is Purchase Order Transit
--  990506  JoAn  Added condition for order state before releasing purchase
--                order in Create_Connected_Order_Line
--  990503  JoAn  Passing DB values in calls to Serial_No_Reservation_API.
--  990430  JICE  Added re-release of shop order on changed configuration.
--  990429  RaKu  CID 14448. Changed ...Sched_Capacity_API.Decode(''F'') in
--                Create_Shop_Order___ to ...Decode(''I'').
--  990423  RaKu  Y.Cleanup.
--  990415  JakH  Y. Made use of public-records in other lu-s
--  990408  RaKu  New templates.
--  990407  JoAn  Replaced nondynamic call to Shop_Ord_Code_API.Get_Client_Value
--                in Create_Shop_Order__ with bom_type_.
--  990406  JakH  Y.CID 10582 Removed use of Gen_Def_Key_value. use '*' where possible.
--  990329  JoAn  Rewrote Generate_Connected_Orders, added condition for order state
--                to dynamic call in Release_Internal_Pur_Orders___
--                Removed obsolete methods Create_Internal_Pur_Order,
--                Create_Shop_Order, Create_Shop_Order__ and Create_Purchase_Requisition.
--  990326  JoAn  Added call to Get_Scrapping_Adjusted_Qty to calculate order qty
--                in Create_Shop_Order___ and Create_Purchase_Requisition___
--  990323  JoAn  Corrected assignment of order_qty in Create_Shop_Order___
--                and Create_Purchase_Requisition___
--  990319  JoAn  Rounding when creating connected orders only done when
--                shrinkage factor != 0
--  990316  JICE  Added handling of purchased options for configured orders.
--  990315  JoAn  CID 10580 qty_on_order assigned a value when PO or SO is created.
--  990315  JoAn  Corrected the rounding of order_qty in Create_Shop_Order___
--                and Create_Purchase_Requisition___
--  990311  JICE  Added new public method Check_Ext_Dupl_Operations for check
--                of duplicate operations on incoming change requests.
--  990310  JoAn  CID 11908 Corrected bind variables in Modify_Dop
--  990305  RaKu  Added check for Move_Serials_To_Module___ so no order lines
--                with supply_code 'IPD' and 'PD' are moved.
--  990303  JICE  Corrected handling of Duplicate Operations.
--  990226  RaKu  Made call to Shop_Order_Int_API.Get_Start_Date to a dynamic call.
--  990215  RaKu  Changes in Move_Serials_To_Module___: Replaced the ...Remove and
--                ...New method with Serial_No_Reservation_API.Modify.
--  990212  JICE  Bugfixed creation of shop order allocations.
--  990211  JoEd  Call Id 7388: Changed the rounding to 12 decimals
--                in Create_Shop_Order___ and Create_Purchase_Requisition___.
--  990209  JICE  Added new public method Modify_Connected_Order_Line.
--  990208  JICE  Added new public method Cancel_Connected_Order_Line.
--  990205  JICE  Added new public methods Check_Duplicate_Operations
--                and Clear_Duplicate_Operations.
--  990205  RaKu  Added procedure Move_Serials_To_Module___.
--  990203  JICE  Added FRGAs code to correct the Revised Start Date when
--                creating allocations for connected shop order and get correct
--                revision_no for option parts.
--  990115  ToBe  Modified variables for authorize_code to VARCHAR2(20).
--  990114  JICE  Corrected handling of operations for configured orders.
--  990112  JICE  Added handling of configurations to Create_Shop_Order.
--  990104  JoEd  Modified methods Create_Dop, Modify_Dop, Cancel_Dop and
--                Generate_Connected_Orders for DOP handling.
--  981221  JoAn  New parameters in call to Create_Shop_Order_From_Oe
--  981218  JICE  Added sending of options in Create_Internal_Pur_Order.
--  981209  JoEd  Changed rounding using shrinkage factor in Create_Shop_Order___
--                and Create_Purchase_Requisition___. Rounding up to 12 decimals.
--  981117  JoEd  SID 6261: Added Transaction_SYS call if revised_due_date's
--                changed in Create_Shop_Order___.
--  981027  JoEd  Replaced MpccomShopCalendar with new calendar WorkTimeCalendar.
--  981001  JoAn  Added new methods Create_Internal_Pur_Order and Release_Internal_Pur_Order___
--  980925  JoEd  Support id 5431. Corrected parameters in calls to Get_Planned_Due_Date and
--                Get_Revised_Qty_Due in procedure Create_Shop_Order__.
--  980818  JOHW  Changed Inventory_Part_API.Get_Mrp_Order_Code to Inventory_Part_Planning_API.Get...
--  980406  JoAn  Replaced call to Create_Purchase_Requisition__ with
--                call to the implementation method.
--  980325  JoAn  SID 2592 Wrong qty passed when creating Purchase Requistion.
--                Corrected in Create_Purchase_Requisition.
--                Also corrected inventory_flag check in Create_Purchase_Requisition___
--  980324  JoAn  Generate_Connected_Orders___, Create_Internal_Pur_Order___
--                and Release_Internal_Pur_Orders___ moved from CustomerOrderFlow
--                to ConnectCustomerOrder LU.
--  980311  JoAn  Changed 'PurchaseRequisLine'to 'PurchaseReqUtil' in call to
--                Transaction_SYS.Logical_Unit_Is_Installed. PurchaseRequisLine
--                is obsolete and should no longer be used.
--  980310  RaKu  Added Create_Purchase_Requisition procedures.
--  980305  RaKu  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
string_null_ CONSTANT VARCHAR2(11) := Database_SYS.string_null_;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Create_Shop_Order___
--   Create a shop order from the order line when supply code is through
--   shop order
PROCEDURE Create_Shop_Order___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   customer_no_           CUSTOMER_ORDER_TAB.customer_no%TYPE;
   revised_qty_due_       NUMBER;
   revised_due_date_      DATE;
   contract_              VARCHAR2(5);
   part_no_               VARCHAR2(25);
   manuf_leadtime_        NUMBER;
   sched_capacity_        VARCHAR2(200) := NULL;
   sched_direction_       VARCHAR2(200) := NULL;
   revised_start_date_    DATE;
   stmt_                  VARCHAR2(500);
   order_qty_             NUMBER;
   so_order_no_           VARCHAR2(12);
   so_release_no_         VARCHAR2(4);
   so_sequence_no_        VARCHAR2(4);
   so_status_code_        VARCHAR2(20);
   calendar_id_           VARCHAR2(10);
   temp_due_              DATE;
   linerec_               Customer_Order_Line_API.public_rec;
   close_tolerance_       NUMBER := NULL;
BEGIN
   linerec_          := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   revised_qty_due_  := linerec_.revised_qty_due - (linerec_.qty_assigned + linerec_.qty_shipped);
   revised_due_date_ := linerec_.planned_due_date;
   part_no_          := linerec_.part_no;
   contract_         := linerec_.contract;

   IF (revised_qty_due_ != 0) THEN
      manuf_leadtime_ := Inventory_Part_API.Get_Manuf_Leadtime(contract_, part_no_);

      -- You must not create a shop order and its connections if LU's not installed!
      $IF NOT (Component_Shpord_SYS.INSTALLED) $THEN 
         RETURN;
      $END   

      $IF Component_Mfgstd_SYS.INSTALLED $THEN
         sched_capacity_ := Sched_Capacity_API.Decode('I');
      $END 

      $IF (Component_Shpord_SYS.INSTALLED) $THEN 
         sched_direction_ := Sched_Direction_API.Decode('B');
      $END 

      -- Fetch revised start date
      calendar_id_ := Site_API.Get_Dist_Calendar_Id(contract_);
      IF (Work_Time_Calendar_API.Is_Working_Day(calendar_id_, revised_due_date_) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOT_WORKING_DAY: :P1 is not a working day!',
                                  to_char(revised_due_date_, 'YYYY-MM-DD'));
      ELSE
         revised_start_date_ := Work_Time_Calendar_API.Get_Start_Date(calendar_id_, revised_due_date_, manuf_leadtime_);
      END IF;

      -- It might be neccessary to order more than what is needed due to a scrapping factor for the part.
      order_qty_ := Inventory_Part_Planning_API.Get_Scrap_Added_Qty(contract_, part_no_, revised_qty_due_);

      -- Make sure unique key values are specified for the shop order created
      -- Try using the keys from the customer order line
      so_order_no_    := order_no_;
      so_release_no_  := line_no_;
      so_sequence_no_ := rel_no_;

      stmt_ := 'BEGIN Shop_Ord_Util_API.Validate_Shop_Order_Keys(:order_no, :release_no, :sequence_no); END;';
      @ApproveDynamicStatement(2019-07-18,ampalk)
      EXECUTE IMMEDIATE stmt_
         USING IN OUT    so_order_no_,
               IN OUT    so_release_no_,
               IN OUT    so_sequence_no_;


      temp_due_ := revised_due_date_;

   customer_no_ := Customer_Order_API.Get_Customer_No(order_no_);
   stmt_ := 'BEGIN Shop_Ord_Util_API.Create_Shop_Order_From_Oe(:status_code, :revised_qty_due,' ||
      ':revised_due_date, :order_no, :line_no, :rel_no, :contract, :part_no,' ||
      ':supply_type, :sched_capacity, :sched_direction, :close_tolerance,' ||
      ':org_qty_due, :revised_start_date, :customer_order_no, :customer_line_no, :customer_rel_no, ' ||
      ':customer_line_item_no, :customer_no, :project_id, :activity_seq, :condition_code, :ownership, :owning_customer_no ); END;';
      @ApproveDynamicStatement(2010-01-14,kayolk)
   EXECUTE IMMEDIATE stmt_
      USING OUT    so_status_code_,
            IN OUT order_qty_,
            IN OUT revised_due_date_,
            IN     so_order_no_,
            IN     so_release_no_,
            IN     so_sequence_no_,
            IN     contract_,
            IN     part_no_,
            IN     Order_Supply_Type_API.Decode('CT'),
            IN     sched_capacity_,
            IN     sched_direction_,
            IN     close_tolerance_,
            IN     order_qty_,
            IN     revised_start_date_,
            IN     order_no_,
            IN     line_no_,
            IN     rel_no_,
            IN     line_item_no_,
            IN     customer_no_,
            IN     linerec_.project_id,
            IN     linerec_.activity_seq,
            IN     linerec_.condition_code,
            IN     linerec_.part_ownership,
            IN     linerec_.owning_customer_no;

      IF (revised_due_date_ != temp_due_) THEN
         Transaction_SYS.Log_Status_Info(Language_SYS.Translate_Constant(lu_name_,
             'NEW_DUE_DATE: The due date of the shop order :P1 for part :P2 will be :P3.', NULL, so_order_no_, part_no_, to_char(revised_due_date_, 'YYYY-MM-DD')), 'INFO');
      END IF;

      Create_Cst_Ord_Shp_Ord_Conn___(order_no_, line_no_, rel_no_, line_item_no_,
                                     so_order_no_, so_release_no_, so_sequence_no_, revised_qty_due_);
   END IF;
END Create_Shop_Order___;


-- Create_Purchase_Requisition___
--   Create a purchase requisition from the order line when supply code is
--   through purchase
PROCEDURE Create_Purchase_Requisition___ (
   vendor_no_            IN OUT VARCHAR2,
   order_no_             IN     VARCHAR2,
   line_no_              IN     VARCHAR2,
   rel_no_               IN     VARCHAR2,
   line_item_no_         IN     NUMBER,
   planned_receipt_date_ IN     DATE,
   revised_qty_due_      IN     NUMBER )
IS
   order_code_         VARCHAR2(3);
   demand_code_        VARCHAR2(200);
   requisitioner_code_ VARCHAR2(20);
   inventory_flag_     VARCHAR2(200);
   unit_meas_          VARCHAR2(10);
   requis_line_no_     VARCHAR2(4);
   requis_rel_no_      VARCHAR2(4);
   is_inventory_part_  NUMBER;
   eng_chg_level_      VARCHAR2(6) := NULL;
   order_qty_          NUMBER;
   order_pre_acc_id_   NUMBER;
   req_pre_acc_id_     NUMBER;
   contract_           VARCHAR2(5);
   part_no_            VARCHAR2(25);
   po_order_no_        VARCHAR2(12) := NULL;
   text_               VARCHAR2(200);
   mark_for_           VARCHAR2(200);
   linerec_            Customer_Order_Line_API.Public_Rec;
   pre_acc_contract_   VARCHAR2(5);
   rental_attr_        VARCHAR2(16000);
BEGIN
   -- demand_code is set to DB value because New_Req procedure's
   -- mark_for parameter's only 25 chars long and New_Requis_Line only allows
   -- one-character IIDs...

   linerec_  := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   contract_ := linerec_.contract;
   part_no_  := linerec_.purchase_part_no;
   
   --Collect rental information.
   IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN 
      $IF Component_Rental_SYS.INSTALLED $THEN
         rental_attr_ := Rental_Object_API.Get_Rental_Object_Attr(Rental_Object_API.Get_Rental_No(order_no_,
                                                                                                  line_no_,
                                                                                                  rel_no_,
                                                                                                  line_item_no_,
                                                                                                  Rental_Type_API.DB_CUSTOMER_ORDER));
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END
   END IF;
   

   IF (linerec_.supply_code = 'PT') THEN
      -- Purch Order Transit
      demand_code_ := Order_Supply_Type_API.Decode('CT');
      order_code_ := '1';
   ELSE
      -- Purch Order Direct
      demand_code_ := Order_Supply_Type_API.Decode('CD');
      order_code_ := '2';
   END IF;

   requisitioner_code_ := Mpccom_Defaults_API.Get_Char_Value('OEORDER', 'REQUISITION_HEADER', 'REQUISITIONER_CODE');

   $IF (Component_Purch_SYS.INSTALLED) $THEN
      mark_for_ := order_no_ || ' ' || line_no_ || ' ' || rel_no_ || ' ' || to_char(line_item_no_) || ' ' || demand_code_;
      Purchase_Req_Util_API.New_Requisition(po_order_no_, order_code_, contract_, requisitioner_code_, mark_for_);

   -- Purchase_Requisition returns one attribute, requisition_no.
      inventory_flag_ := Purchase_Part_API.Get_Inventory_Flag(contract_, part_no_);
   $ELSE 
      inventory_flag_ := NULL;
   $END 

   IF (inventory_flag_ = Inventory_Flag_API.Decode('Y')) THEN
      unit_meas_ := Inventory_Part_API.Get_Unit_Meas(contract_, part_no_);
      -- It might be neccessary to order more than what is needed due to a scrapping factor for the part.
      -- This should only be done when supply code is Purch Order Transit.
      IF (linerec_.supply_code = 'PT') THEN
         order_qty_ := Inventory_Part_Planning_API.Get_Scrap_Added_Qty(contract_, part_no_, revised_qty_due_);
      ELSE
         order_qty_ := revised_qty_due_;
      END IF;
   ELSE
      unit_meas_ := Sales_Part_API.Get_Unit_Meas(contract_, part_no_);
      order_qty_ := revised_qty_due_;
   END IF;

   $IF (Component_Purch_SYS.INSTALLED) $THEN   
      is_inventory_part_ := Purchase_Part_API.Is_Inventory_Part(contract_, part_no_);
      IF (is_inventory_part_ = 1) THEN
         eng_chg_level_ := Inventory_Part_Revision_API.Get_Eng_Chg_Level(contract_, part_no_, planned_receipt_date_);
      END IF;

      requis_line_no_ := '1';
      requis_rel_no_  := '1';
      
     -- Create a new purchase requisition line
      Purchase_Req_Util_API.New_Line_Part(requis_line_no_, requis_rel_no_, po_order_no_,
                                          contract_, part_no_, unit_meas_, order_qty_, planned_receipt_date_,
                                          demand_code_, vendor_no_, order_code_, TO_NUMBER(NULL), order_qty_, '',
                                          TO_NUMBER(NULL), eng_chg_level_, TO_CHAR(NULL), TO_DATE(NULL),
                                          TO_CHAR(NULL), TO_CHAR(NULL), TO_CHAR(NULL), TO_NUMBER(NULL),
                                          TO_NUMBER(NULL), TO_CHAR(NULL), 1,
                                          order_no_, line_no_, rel_no_, TO_CHAR(NULL),
                                          TO_CHAR(NULL), TO_CHAR(line_item_no_), linerec_.configuration_id, TO_CHAR(NULL),linerec_.condition_code,
                                          TO_CHAR(NULL), TO_CHAR(NULL), TO_CHAR(NULL), TO_CHAR(NULL), TO_CHAR(NULL), TO_CHAR(NULL),
                                          TO_CHAR(NULL), TO_CHAR(NULL), TO_NUMBER(NULL), TO_NUMBER(NULL),
                                          TO_CHAR(NULL), linerec_.activity_seq, TO_CHAR(NULL), rental_attr_);             
      
      -- Copy preaccountings from customer order line to created requisition line
      order_pre_acc_id_ := Customer_Order_Line_API.Get_Pre_Accounting_Id(order_no_, line_no_, rel_no_, line_item_no_);
      req_pre_acc_id_   := Purchase_Req_Line_Part_API.Get_Pre_Accounting_Id(po_order_no_, requis_line_no_, requis_rel_no_);
      pre_acc_contract_ := Purchase_Req_Line_Part_API.Get_Contract(po_order_no_, requis_line_no_, requis_rel_no_);      
      
      Pre_Accounting_API.Copy_Pre_Accounting(order_pre_acc_id_, req_pre_acc_id_, pre_acc_contract_, NULL, 'CUSTOMER ORDER');
   $END 

   --Create a new record in the connection tab.
   Customer_Order_Pur_Order_API.New(order_no_, line_no_, rel_no_, line_item_no_, po_order_no_, '1', '1',
      Purchase_Type_API.Decode('R'), revised_qty_due_);

   -- Set qty_on_order for the customer order line
   Customer_Order_Line_API.Modify_Qty_On_Order(order_no_, line_no_, rel_no_, line_item_no_, revised_qty_due_);

   -- Move serials, if any, from customer order line to created purchase order.
   IF (linerec_.supply_code != 'PD') THEN
      Move_Serials_To_Module___(order_no_, line_no_, rel_no_, line_item_no_, po_order_no_, '1', '1', 'PURCHASE ORDER');
   END IF;

   text_ := substr(Language_SYS.Translate_Constant(lu_name_, 'REQCREATED: Requisition :P1 created', NULL, po_order_no_), 1, 200);
   Customer_Order_Line_Hist_API.New(order_no_, line_no_, rel_no_, line_item_no_, text_);
END Create_Purchase_Requisition___;


-- Create_Internal_Pur_Order___
--   When a CustomerOrder is released this method should be called to create
--   internal purchase orders for order lines having
--   supply_code = 'IPT' or 'IPD'
--   IPT - 'Int Purch Transit' and IPD - 'Int Purch Direct
PROCEDURE Create_Internal_Pur_Order___ (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   supply_code_         IN VARCHAR2,
   vendor_no_           IN VARCHAR2,
   wanted_receipt_date_ IN DATE,
   revised_qty_due_     IN NUMBER )
IS
   po_order_no_          VARCHAR2(12) := NULL;
   po_line_no_           VARCHAR2(4)  := NULL;
   po_rel_no_            VARCHAR2(4)  := NULL;
   addrec_               Cust_Order_Line_Address_API.Co_Line_Addr_Rec;
   headrec_              Customer_Order_API.Public_Rec;
   linerec_              Customer_Order_Line_API.Public_Rec;   
   msg_text_             VARCHAR2(200);
   co_pre_acc_id_        NUMBER;
   po_pre_acc_id_        NUMBER;
   head_supply_code_     VARCHAR2(200);
   ean_locatn_           VARCHAR2(100) := NULL;
   del_to_cust_          CUSTOMER_ORDER_LINE_TAB.deliver_to_customer_no%TYPE := NULL;
   intrastat_exempt_     VARCHAR2(20) := NULL;
   pre_acc_contract_     VARCHAR2(5);
   rental_attr_          VARCHAR2(16000);
   replicate_new_line_   BOOLEAN := FALSE;     
   media_code_           VARCHAR2(30);
   changed_attrib_not_in_pol_  VARCHAR2(5):='';
   $IF (Component_Purch_SYS.INSTALLED) $THEN
   po_rec_               Purchase_Order_API.Public_Rec;
   $END
   packing_instruction_id_ VARCHAR2(50);
   
   CURSOR check_po_exist IS
      SELECT DISTINCT po_order_no
      FROM   customer_order_pur_order_tab copo, customer_order_line_tab col
      WHERE  col.order_no      = copo.oe_order_no
      AND    col.line_no       = copo.oe_line_no
      AND    col.rel_no        = copo.oe_rel_no
      AND    col.line_item_no  = copo.oe_line_item_no
      AND    copo.oe_order_no  = order_no_
      AND    col.vendor_no     = vendor_no_
      AND    col.rowstate      = 'Released';
BEGIN
   -- Note: Create Purchase Order for supply_code = 'IPT' or 'IPD'
   headrec_ := Customer_Order_API.Get(order_no_);
   linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   FOR  rec_ IN check_po_exist LOOP
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         po_rec_ := Purchase_Order_API.Get(rec_.po_order_no);
         IF (po_rec_.rowstate NOT IN ('Cancelled', 'Closed')) THEN
            IF (po_rec_.rowstate = 'Planned') THEN
               po_order_no_ := rec_.po_order_no;
            ELSE 
               IF (Purchase_Order_API.Change_Order_Required(rec_.po_order_no) = 'FALSE') THEN
                  po_order_no_        := rec_.po_order_no;
                  replicate_new_line_ := TRUE;
               END IF;
            END IF;
            IF (po_order_no_ IS NOT NULL) THEN
               EXIT;
            END IF;
         END IF;
      $ELSE
         EXIT;
      $END
   END LOOP;
   
   IF (po_order_no_ IS NULL) THEN
      Client_SYS.Add_Info(lu_name_, 'ADDEDTOSAMEPO: The new line cannot be added to an existing pegged purchase order, a new pegged purchase order is created.');
   ELSE
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         -- Changed condition to set changed_attrib_not_in_pol to FALSE only when a new line needs to be added to an existing PO (communicated_via flag is ORDER_SENT)
         IF (po_rec_.communicated_via LIKE '%^'||Pur_Order_Communication_API.DB_ORDER_SENT||'^%') THEN
            changed_attrib_not_in_pol_ := 'FALSE';
         END IF;
      $ELSE
         changed_attrib_not_in_pol_ := NULL;
      $END
   END IF;   

   IF (supply_code_ = (Order_Supply_Type_API.Decode('IPD'))) THEN
      IF (linerec_.addr_flag = 'N') THEN
         ean_locatn_ := Customer_Info_Address_API.Get_Ean_Location(linerec_.deliver_to_customer_no, linerec_.ship_addr_no);
      END IF;
      del_to_cust_ := linerec_.deliver_to_customer_no;
      packing_instruction_id_ := linerec_.packing_instruction_id;
   END IF;

   -- Fetch the Intrastat from the External CO
   intrastat_exempt_ := headrec_.intrastat_exempt;

   -- Note: When CO has lines with Supply Type IPD and IPT then the Order Code of the created PO should  be 4.
   head_supply_code_ := Order_Supply_Type_API.Decode('IPT');

   --Note: If a purchase order with transit delivery is created then customer order address should be passed.
   IF (supply_code_ = Order_Supply_Type_API.Decode('IPD')) THEN
      addrec_ := Cust_Order_Line_Address_API.Get_Co_Line_Addr(order_no_, line_no_, rel_no_, line_item_no_);
   ELSE
      addrec_.addr_1          := NULL;
      addrec_.address1        := NULL;
      addrec_.address2        := NULL;
      addrec_.address3        := NULL;
      addrec_.address4        := NULL;
      addrec_.address5        := NULL;
      addrec_.address6        := NULL;
      addrec_.zip_code        := NULL;
      addrec_.city            := NULL;
      addrec_.state           := NULL;
      addrec_.county          := NULL;
      addrec_.country_code    := NULL;
   END IF;

   -- Note: Added condition code to the dynamic call.
   $IF (Component_Purch_SYS.INSTALLED) $THEN           
      IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
         $IF Component_Rental_SYS.INSTALLED $THEN
            rental_attr_ := Rental_Object_API.Get_Rental_Object_Attr(Rental_Object_API.Get_Rental_No(order_no_,
                                                                                                     line_no_,
                                                                                                     rel_no_,
                                                                                                     line_item_no_,
                                                                                                     Rental_Type_API.DB_CUSTOMER_ORDER));
         $ELSE
            Error_SYS.Component_Not_Exist('RENTAL');
         $END   
      END IF; 
      Purchase_Order_API.Create_Int_Purch_Order(po_order_no_, po_line_no_, po_rel_no_,
                                                supply_code_, vendor_no_, part_no_, contract_, headrec_.authorize_code, wanted_receipt_date_,
                                                revised_qty_due_, headrec_.customer_po_no, addrec_.addr_1, 
                                                addrec_.address1, addrec_.address2, addrec_.address3, addrec_.address4, addrec_.address5, addrec_.address6,
                                                addrec_.zip_code, addrec_.city, addrec_.state, addrec_.county, addrec_.country_code, order_no_, line_no_, rel_no_, to_char(line_item_no_),
                                                configuration_id_, linerec_.condition_code, head_supply_code_, del_to_cust_, ean_locatn_, intrastat_exempt_, linerec_.activity_seq, rental_attr_,
                                                packing_instruction_id_);

      -- Add a new entry to the connection table
      Customer_Order_Pur_Order_API.New(order_no_, line_no_, rel_no_, line_item_no_ , po_order_no_, po_line_no_,
      po_rel_no_, Purchase_Type_API.Decode('O') , revised_qty_due_, changed_attrib_not_in_pol_);
   $END 
   -- Create a new history record for the order line
   msg_text_ := Language_SYS.Translate_Constant(lu_name_, 'INTPOCREATED: Internal purchase order :P1 created',
                                                NULL, po_order_no_);
   Customer_Order_Line_Hist_API.New(order_no_, line_no_, rel_no_, line_item_no_, msg_text_);


   -- Copy preaccountings from customer order line to created purchase order
   co_pre_acc_id_ := Customer_Order_Line_API.Get_Pre_Accounting_Id(order_no_, line_no_, rel_no_, line_item_no_);

   $IF (Component_Purch_SYS.INSTALLED) $THEN
      po_pre_acc_id_    := Purchase_Order_Line_Part_API.Get_Pre_Accounting_Id(po_order_no_, po_line_no_, po_rel_no_);
      pre_acc_contract_ := Purchase_Order_Line_Part_API.Get_Contract(po_order_no_, po_line_no_, po_rel_no_);
   $END 
   
   Pre_Accounting_API.Copy_Pre_Accounting(co_pre_acc_id_, po_pre_acc_id_, pre_acc_contract_, NULL, 'CUSTOMER ORDER');
   
   -- Set qty_on_order for the customer order line
   Customer_Order_Line_API.Modify_Qty_On_Order(order_no_, line_no_, rel_no_, line_item_no_, revised_qty_due_);

   -- Move serials, if any, from customer order line to created purchase order.
   IF (Customer_Order_Line_API.Get_Supply_Code(order_no_, line_no_, rel_no_, line_item_no_) != Order_Supply_Type_API.Decode('PD')) THEN
      Move_Serials_To_Module___(order_no_, line_no_, rel_no_, line_item_no_, po_order_no_, po_line_no_, po_rel_no_, 'PURCHASE ORDER');
   END IF;
   
   $IF (Component_Purch_SYS.INSTALLED) $THEN   
      IF (replicate_new_line_ AND (Supplier_API.Get_Send_Change_Message_Db(vendor_no_)= 'Y')) THEN         
         Purchase_Order_Transfer_API.Send_Order_Change(po_order_no_, po_line_no_, po_rel_no_);         
      END IF;
   $END
   
END Create_Internal_Pur_Order___;


-- Release_Internal_Pur_Orders___
--   Release all internal purchase orders created when releasing a
--   customer order.
PROCEDURE Release_Internal_Pur_Orders___ (
   order_no_ IN VARCHAR2 )
IS
   planned_state_ VARCHAR2(10) := 'Planned';
   error_message_ VARCHAR2(2000);
   info_          VARCHAR2(2000);
   -- Cursor for retrieving all internal purchase orders generated by the customer order
   CURSOR get_pur_orders IS
      SELECT DISTINCT po_order_no
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE  oe_order_no = order_no_
      AND    purchase_type = 'O';
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      FOR next_pur_order_ IN get_pur_orders LOOP
         @ApproveTransactionStatement(2013-11-28,MeAblk)
         SAVEPOINT release_internal_po; 
            IF (Purchase_Order_API.Get_Objstate(next_pur_order_.po_order_no) = planned_state_) THEN
               Purchase_Order_API.Release_Order_And_Create_CO(next_pur_order_.po_order_no);
            END IF;
      END LOOP;
   $ELSE 
      NULL;
   $END
EXCEPTION
   WHEN others THEN
      error_message_ := sqlerrm;
      -- Rollback to the last savepoint
      @ApproveTransactionStatement(2013-11-28,MeAblk)
      ROLLBACK to release_internal_po;
      -- Logg the error
      info_ := Language_SYS.Translate_Constant(lu_name_, 'ORDERERR: Order: :P1   :P2',
                                               NULL, order_no_, error_message_);

      Transaction_SYS.Set_Status_Info(info_);
END Release_Internal_Pur_Orders___;


-- Release_Internal_Pur_Order___
--   Release internal purchase order created when adding a new line to a
--   customer order which has already been released.
PROCEDURE Release_Internal_Pur_Order___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   part_no_      IN VARCHAR2 )
IS
   po_order_no_     VARCHAR2(12);
   planned_state_   VARCHAR2(10) := 'Planned';
   proceed_release_ BOOLEAN := TRUE;
   po_line_no_      VARCHAR2(4);
   po_rel_no_       VARCHAR2(4);

   -- Cursor for retrieving all purchase orders generated by the customer order
   CURSOR get_pur_order IS
      SELECT po_order_no, po_line_no, po_rel_no
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE  oe_order_no = order_no_
      AND    oe_line_no = line_no_
      AND    oe_rel_no = rel_no_
      AND    oe_line_item_no = line_item_no_;
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN 
      OPEN get_pur_order;
      FETCH get_pur_order INTO po_order_no_, po_line_no_, po_rel_no_;
      IF (get_pur_order%NOTFOUND) THEN
         po_order_no_ := NULL;
      END IF;
      CLOSE get_pur_order;

      -- If the INTERACT_PUR_ORD is set in the export control basic data and the part is export controlled the internal PO should not be released.
      -- It should remain in the Planned state until Find and Connect Export License is executed for the PO line.
      $IF Component_Expctr_SYS.INSTALLED $THEN
         IF (Exp_License_Connect_Util_API.Get_Export_Controlled(part_no_, po_order_no_, po_line_no_, po_rel_no_, NULL, 'PURCHASE_ORDER') = 'TRUE') AND
            (Purchase_Order_API.Get_License_Enabled(po_order_no_, 'INTERACT_PUR_ORD') = 'TRUE') THEN
               proceed_release_ := FALSE;
         END IF;
      $END
      IF (po_order_no_ IS NOT NULL) AND (proceed_release_) AND (Purchase_Order_API.Get_Objstate(po_order_no_) = planned_state_)THEN
         Purchase_Order_API.Release_Order_And_Create_CO(po_order_no_);
      END IF;
   $ELSE 
      NULL;
   $END 
END Release_Internal_Pur_Order___;


-- Move_Serials_To_Module___
--   Checks if any serial numbers have been reserved for specified order_line
--   any transfers them, in that case, to the specified module (destination_).
PROCEDURE Move_Serials_To_Module___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   to_order_no_  IN VARCHAR2,
   to_line_no_   IN VARCHAR2,
   to_rel_no_    IN VARCHAR2,
   destination_  IN VARCHAR2 )
IS
   source_  VARCHAR2(200) := 'CUSTOMER ORDER';
   part_no_ VARCHAR2(25);
BEGIN

   part_no_ := Customer_Order_Line_API.Get_Part_No(order_no_, line_no_, rel_no_, line_item_no_);

   -- Check if any serials exists.
   IF (Serial_No_Reservation_API.Check_Reservation_Exist(order_no_, line_no_,
                                                         rel_no_, line_item_no_,
                                                         source_, part_no_) = 'TRUE') THEN

      -- Use public cursor to fetch the serials from CO and move them to new order.
      FOR next_ IN Serial_No_Reservation_API.get_part_serial_no_cur(order_no_, line_no_,
                                                                    rel_no_, line_item_no_,
                                                                    source_) LOOP
         Serial_No_Reservation_API.Modify(next_.part_no, next_.serial_no,
                                          to_order_no_, to_line_no_, to_rel_no_,
                                          NULL, destination_);
      END LOOP;
   END IF;
END Move_Serials_To_Module___;


PROCEDURE Create_Connected_Order_Line___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   supply_code_db_         VARCHAR2(3);
   revised_qty_due_        NUMBER;
   qty_assigned_           NUMBER;
   part_no_                VARCHAR2(25);
   contract_               VARCHAR2(5);
   vendor_no_              CUSTOMER_ORDER_LINE_TAB.vendor_no%TYPE;
   wanted_receipt_date_    DATE;
   planned_delivery_date_  DATE;
   planned_due_date_       DATE;
   purchase_part_no_       VARCHAR2(25);
   configuration_id_       VARCHAR2(50);
   ctp_planned_db_         VARCHAR2(20);
   qty_due_                NUMBER;
   qty_shipped_            NUMBER;
   connected_dop_id_       VARCHAR2(12);
   col_rec_                Customer_Order_Line_API.Public_Rec;
 	create_connected_order_ VARCHAR2(5):= 'FALSE';
   qty_to_connect_         NUMBER;
   connected_so_found_     VARCHAR2(5) := 'FALSE';
   connected_po_found_     NUMBER;

   CURSOR get_line_info IS
      SELECT supply_code, revised_qty_due, qty_assigned, qty_shipped, part_no, contract,
             planned_delivery_date, planned_due_date, vendor_no,
             purchase_part_no, configuration_id, ctp_planned
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    (rel_mtrl_planning = 'TRUE' OR (rel_mtrl_planning = 'FALSE' AND create_connected_order_ = 'TRUE'));
BEGIN
   col_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   
   IF ((Site_To_Site_Reserve_Setup_API.Exists(col_rec_.supply_site, col_rec_.contract)) AND
       (Site_To_Site_Reserve_Setup_API.Get_Rel_Mtrl_Planning_Db(col_rec_.supply_site, col_rec_.contract) = Rel_Mtrl_Planning_API.DB_NOT_VIS_PLANNED_RELEASED)) THEN
      -- Pegged order needs to be created for DB_NOT_VIS_PLANNED_RELEASED even though Rel_Mtrl_Planning is FALSE.
      create_connected_order_ := 'TRUE';
 	END IF;
   
   OPEN get_line_info;
   FETCH get_line_info INTO supply_code_db_, revised_qty_due_, qty_assigned_, qty_shipped_, part_no_, contract_,
         planned_delivery_date_, planned_due_date_, vendor_no_, purchase_part_no_,
         configuration_id_, ctp_planned_db_;
   CLOSE get_line_info;

   -- Set the wanted receipt date for purchase orders
   IF (supply_code_db_ IN ('PD', 'IPD')) THEN
      -- Direct delivery from PO
      wanted_receipt_date_ := planned_delivery_date_;

   ELSIF (supply_code_db_ IN ('PT', 'IPT')) THEN
      -- Transit delivery from PO
      wanted_receipt_date_ := planned_due_date_;
   END IF;

   qty_to_connect_ := revised_qty_due_ - (qty_assigned_ + qty_shipped_);
   IF (supply_code_db_ = 'SO') THEN
      connected_so_found_ := Customer_Order_Shop_Order_API.Connected_Orders_Found(order_no_, line_no_, rel_no_, line_item_no_);
   ELSIF (supply_code_db_ = 'DOP') THEN
      $IF (Component_Dop_SYS.INSTALLED) $THEN                     
        connected_dop_id_ := Dop_Demand_Gen_API.Get_Dop_Id(order_no_, line_no_, rel_no_, line_item_no_);         
      $ELSE 
        NULL;
      $END 
   ELSIF (supply_code_db_ IN ('PT', 'PD', 'IPT', 'IPD')) THEN
      connected_po_found_ := (Customer_Order_Pur_Order_API.Connected_Orders_Found(order_no_, line_no_, rel_no_, line_item_no_));
   END IF;
   
   -- Shop Order (and no capability check reservations/allocations have been done)
   IF (supply_code_db_ = 'SO' AND ctp_planned_db_ = 'N' AND qty_to_connect_ != 0 AND connected_so_found_ = 'FALSE') THEN
      Create_Shop_Order___(order_no_, line_no_, rel_no_, line_item_no_);
   ELSIF (supply_code_db_ IN ('PS','PT', 'PD','IPT', 'IPD') AND revised_qty_due_ > (qty_assigned_ + qty_shipped_))  THEN
      -- Production Schedule
      IF (supply_code_db_ = 'PS') THEN
         --we should not consider the reserved quantity
         qty_due_ := revised_qty_due_ -qty_assigned_;
         qty_due_ := Inventory_Part_Planning_API.Get_Scrap_Added_Qty(contract_, part_no_, qty_due_);
	
         Create_Production_Schedule___(contract_,
                                       part_no_,
                                       planned_due_date_,
                                       qty_due_ ,
                                       order_no_,
                                       line_no_,
                                       rel_no_,
                                       line_item_no_,
                                       'CUSTOMER_ORDER');

      -- Purch Order Direct or Purch Order Transit
      ELSIF (supply_code_db_ IN ('PT', 'PD')) THEN
         IF (connected_po_found_ = 0) THEN
            Create_Purchase_Requisition___(vendor_no_, order_no_, line_no_, rel_no_, line_item_no_,
                                           wanted_receipt_date_, qty_to_connect_);
         END IF;
      -- Internal Purch Direct or Internal Purch Transit
      ELSIF (supply_code_db_ IN ('IPT', 'IPD')) THEN
         IF (connected_po_found_ = 0) THEN
            Create_Internal_Pur_Order___(order_no_, line_no_, rel_no_, line_item_no_, contract_,
                                         purchase_part_no_, configuration_id_,
                                         Order_Supply_Type_API.Decode(supply_code_db_), vendor_no_, wanted_receipt_date_, qty_to_connect_);
         END IF;
      END IF;
   -- DOP Order (and no capability check reservations/allocations have been done)
   ELSIF ((supply_code_db_ = 'DOP') AND (ctp_planned_db_ = 'N') AND (qty_to_connect_ != 0)) THEN
      $IF (Component_Dop_SYS.INSTALLED) $THEN                             
         IF (connected_dop_id_ IS NULL) THEN
            Create_Dop(order_no_, line_no_, rel_no_, line_item_no_);
         END IF;
      $ELSE 
         NULL;
      $END 
   ELSIF ((supply_code_db_ IN ('SO', 'DOP')) AND (qty_to_connect_ = 0) AND (connected_so_found_ = 'FALSE') AND (connected_dop_id_ IS NULL)) THEN
      Customer_Order_Line_API.Modify_Acquisition_Type__(order_no_, line_no_, rel_no_, line_item_no_, 'IO');
   END IF;
END Create_Connected_Order_Line___;


-- Modify_Shop_Order___
--   Method for modifying the shop order in response to the changes
--   in the connected customer order line.
--   This is typically called when the supply code of the customer order
--   is shop order.
PROCEDURE Modify_Shop_Order___ (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   revised_qty_due_  IN NUMBER,
   revised_due_date_ IN DATE )
IS
   so_order_no_         VARCHAR2(12);
   so_release_no_       VARCHAR2(4);
   so_sequence_no_      VARCHAR2(4);
   so_objstate_         VARCHAR2(20);
   so_prev_state_       VARCHAR2(20);
   order_qty_           NUMBER;
   calendar_id_         VARCHAR2(10);
   text_                VARCHAR2(200);
   attr_                VARCHAR2(2000);
   so_info_             VARCHAR2(32000);
BEGIN
   -- If ShopOrd LU is not installed, return without doing anything.
   $IF (Component_Shpord_SYS.INSTALLED) $THEN 
      Customer_Order_Shop_Order_API.Get_Shop_Order(so_order_no_,
                                                   so_release_no_,
                                                   so_sequence_no_,
                                                   order_no_,
                                                   line_no_,
                                                   rel_no_,
                                                   line_item_no_);

      -- It might be neccessary to order more than what is needed due to a scrapping factor for the part.
      order_qty_     := Inventory_Part_Planning_API.Get_Scrap_Added_Qty(contract_, part_no_, revised_qty_due_);

      so_objstate_   := Shop_Ord_Util_API.Get_Objstate(so_order_no_, so_release_no_, so_sequence_no_);
      so_prev_state_ := Shop_Ord_API.Get_State_Before_Park(so_order_no_, so_release_no_, so_sequence_no_);            
                     
      -- Modification through change request is not allowed for started orders.
      IF (so_objstate_ = 'Started' OR (so_objstate_ = 'Parked' AND so_prev_state_ = 'Started')) THEN
         Error_SYS.Record_General(lu_name_, 'SHPCANNOTUPDATE: The shop order is started, updates through change request is not allowed.');
      END IF;

      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('QTY_ON_ORDER', revised_qty_due_, attr_);
      
      IF revised_qty_due_ = 0 THEN
         Shop_Ord_API.Cancel(so_order_no_, so_release_no_, so_sequence_no_);         
      ELSE
         Shop_Ord_API.Update_Revised_Qty_Due(so_info_, so_order_no_, so_release_no_, so_sequence_no_, order_qty_, TRUE);
         -- Validating the revised due date.
         calendar_id_ := Site_API.Get_Dist_Calendar_Id(contract_);
         IF (Work_Time_Calendar_API.Is_Working_Day(calendar_id_, revised_due_date_) = 0) THEN
            Error_SYS.Record_General(lu_name_, 'NOT_WORKING_DAY: :P1 is not a working day!',
                                     to_char(revised_due_date_, 'YYYY-MM-DD'));
         END IF;

         -- Updating the need date for shop order, that in turn updates the neccessary dates.
         Shop_Ord_API.Update_Need_Date(so_info_, so_order_no_, so_release_no_, so_sequence_no_, revised_due_date_, 
                                       update_from_demand_    => TRUE,
                                       time_passed_with_date_ => TRUE);            

         Client_SYS.Add_To_Attr('UPDATE_FROM_DEMAND', 'TRUE', attr_);
         Shop_Ord_API.Modify(so_order_no_, so_release_no_, so_sequence_no_, attr_);
         -- Adding the order line history for the customer order.
         text_ := SUBSTR(Language_SYS.Translate_Constant(lu_name_, 'SOMODIFIED: Shop order :P1 modified',
         NULL, so_order_no_), 1, 200);
         Customer_Order_Line_Hist_API.New(order_no_, line_no_, rel_no_, line_item_no_, text_);         
      END IF;
      -- Modify the quantity in the connection tab.      
      Customer_Order_Shop_Order_API.Modify(order_no_, line_no_, rel_no_, line_item_no_, so_order_no_, so_release_no_, so_sequence_no_, attr_);
   $ELSE 
      NULL;
   $END
END Modify_Shop_Order___;


PROCEDURE Create_Production_Schedule___ (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   due_date_          IN DATE,
   qty_due_           IN NUMBER,
   order_ref1_        IN VARCHAR2,
   order_ref2_        IN VARCHAR2,
   order_ref3_        IN VARCHAR2,
   order_ref4_        IN NUMBER,
   demand_source_db_  IN VARCHAR2 )
IS
   supply_postponed_ VARCHAR2(10);
   status_msg_       VARCHAR2(2000);
BEGIN
   $IF (Component_Prosch_SYS.INSTALLED) $THEN
      Line_Sched_Manager_API.Create_Schedule_From_Source(supply_postponed_,
                                                         contract_,
                                                         part_no_,
                                                         due_date_,
                                                         qty_due_,
                                                         order_ref1_,
                                                         order_ref2_,
                                                         order_ref3_,
                                                         order_ref4_,
                                                         demand_source_db_);
      IF (supply_postponed_ = 'TRUE') THEN
         status_msg_ := Language_SYS.Translate_Constant (lu_name_,
                                                         'PROSHPOSTPONED: Production Schedule supply created after the Firm Horizon for Order No: :P1, Line No: :P2, Release No: :P3.',
                                                         Fnd_Session_API.Get_Language,
                                                         order_ref1_,
                                                         order_ref2_,
                                                         order_ref3_);

         Transaction_SYS.Set_Status_Info (status_msg_, 'INFO');
      END IF;
   $ELSE 
      NULL;
   $END 
END Create_Production_Schedule___;


PROCEDURE Create_Cst_Ord_Shp_Ord_Conn___ (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   so_order_no_      IN VARCHAR2,
   so_release_no_    IN VARCHAR2,
   so_sequence_no_   IN VARCHAR2,
   revised_qty_due_  IN NUMBER )
IS
   text_                  VARCHAR2(200);
BEGIN

   --Create a new record in the connection tab.
   Customer_Order_Shop_Order_API.New(order_no_, line_no_, rel_no_, line_item_no_, so_order_no_, so_release_no_, so_sequence_no_, revised_qty_due_);

   -- Set qty_on_order for the customer order line
   Customer_Order_Line_API.Modify_Qty_On_Order(order_no_, line_no_, rel_no_, line_item_no_, revised_qty_due_);

   -- Move serials, if any, from customer order line to created shop order.
   Move_Serials_To_Module___(order_no_, line_no_, rel_no_, line_item_no_, so_order_no_, so_release_no_, so_sequence_no_, 'SHOP ORDER');

   text_ := substr(Language_SYS.Translate_Constant(lu_name_, 'SOCREATED: Shop order :P1 created',
                   NULL, so_order_no_), 1, 200);
   Customer_Order_Line_Hist_API.New(order_no_, line_no_, rel_no_, line_item_no_, text_);

END Create_Cst_Ord_Shp_Ord_Conn___;


-- Release_Ctp_Planned_Lines___
--   Calls Interim_Ctp_Manager_API.Release_Ctp for any lines that are
--   capability check reserved/allocated.
PROCEDURE Release_Ctp_Planned_Lines___ (
   order_no_ IN VARCHAR2 )
IS
   site_date_            DATE;
   so_order_no_          VARCHAR2(12);
   so_release_no_        VARCHAR2(4);
   so_sequence_no_       VARCHAR2(4);
   qty_on_order_         NUMBER;
   interim_ord_id_       VARCHAR2(12);

   -- Added rowstate condition only to select Released CO lines, not to try to create Shop Order if one already exists
   CURSOR get_ctp_planned_lines IS
      SELECT line_no, rel_no, line_item_no, latest_release_date, supply_code, revised_qty_due, ctp_planned
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND rowstate = 'Released';
BEGIN
   site_date_ := Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(order_no_));
   -- Call Promise_Order to inform them that they may have to change their reservations
   $IF (Component_Ordstr_SYS.INSTALLED) $THEN
      FOR linerec_ IN get_ctp_planned_lines LOOP
         IF linerec_.ctp_planned = 'Y' THEN
            IF (linerec_.latest_release_date IS NULL OR trunc(linerec_.latest_release_date) < trunc(site_date_)) THEN
               Error_SYS.Record_General(lu_name_, 'LATESTRELDATEPASSED: The customer order is not allowed to be released. Interim orders exist but are in the past or they exist but the capability check has failed. Please run the capability check again.');
            END IF;

            Interim_Ctp_Manager_API.Release_Ctp(qty_on_order_, so_order_no_, so_release_no_, so_sequence_no_, linerec_.supply_code,
                                                order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, 'CUSTOMERORDER');         
            -- if this a shop order the ctp/cc engine have now created the corresponding shop order
            -- so we need to fix additional connections between the CO and SO and copy some data between them
            IF (linerec_.supply_code = 'SO') THEN

               Create_Cst_Ord_Shp_Ord_Conn___(order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no,
                                              so_order_no_, so_release_no_, so_sequence_no_,
                                              NVL(qty_on_order_,linerec_.revised_qty_due - Customer_Order_Line_API.Get_Qty_Assigned(order_no_,linerec_.line_no,
                                              linerec_.rel_no,linerec_.line_item_no)));
            END IF;
         ELSIF linerec_.ctp_planned = 'N' THEN
            interim_ord_id_:= Customer_Order_Line_API.Get_Interim_Order_No(order_no_,linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, linerec_.ctp_planned);
            IF  interim_ord_id_ IS NOT NULL AND Interim_Demand_Head_API.Get_Objstate(interim_ord_id_) = 'Cancelled' THEN
               Interim_Demand_Head_API.CLOSE(interim_ord_id_);
               Interim_Demand_Head_API.Remove(interim_ord_id_);
            END IF;  
         END IF;
      END LOOP;
   $ELSE 
      NULL;
   $END 
END Release_Ctp_Planned_Lines___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Dop
--   Create a DOP header for order line with supply code 'DOP Order'.
--   Called when the order line is released.
PROCEDURE Create_Dop (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   contract_         VARCHAR2(5);
   info_             VARCHAR2(2000);
   key_attr_         VARCHAR2(2000) := NULL;
   order_type_       VARCHAR2(200);
   linerec_          Customer_Order_Line_API.public_rec;
BEGIN

   linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   IF (linerec_.dop_connection IN ('AUT', 'REL')) THEN
      $IF (Component_Dop_SYS.INSTALLED) $THEN
         contract_ := Customer_Order_API.Get_Contract(order_no_);
         Client_SYS.Add_To_Attr('ORDER_NO',    order_no_,      key_attr_);
         Client_SYS.Add_To_Attr('RELEASE_NO',   rel_no_,       key_attr_);
         Client_SYS.Add_To_Attr('LINE_NO',      line_no_,      key_attr_);
         Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, key_attr_);

         order_type_ := Dop_Demand_Type_API.Decode('CUORD');
         Dop_Demand_Gen_API.Create_Dop_Demand(info_, key_attr_, linerec_.part_no, contract_, linerec_.planned_due_date, order_type_,
                                                       linerec_.revised_qty_due - (linerec_.qty_assigned + linerec_.qty_shipped));
         -- Set qty_on_order for the customer order line
      $ELSE 
         NULL;
      $END
         
      END IF;
END Create_Dop;


-- Modify_Dop
--   Modify DOP header for part with supply code 'DOP Order' when the corresponding
--   line has been modified.
PROCEDURE Modify_Dop (
   qty_on_order_       IN OUT NUMBER,
   order_no_           IN     VARCHAR2,
   line_no_            IN     VARCHAR2,
   rel_no_             IN     VARCHAR2,
   line_item_no_       IN     NUMBER,
   revised_qty_due_    IN     NUMBER,
   planned_due_date_   IN     DATE,
   dop_new_qty_demand_ IN     VARCHAR2,
   replicate_changes_  IN     VARCHAR2 )
IS
   linerec_             Customer_Order_Line_API.Public_Rec;   
   from_co_head_client_        VARCHAR2(5);
   dop_qty_replicate_          VARCHAR2(5);
BEGIN

   from_co_head_client_ := Message_SYS.Find_Attribute(dop_new_qty_demand_, 'FROM_CO_HEAD_CLIENT', 'FALSE');
   IF ((Message_SYS.Find_Attribute(dop_new_qty_demand_, 'FROM_CO_LINE_CLIENT', 'FALSE') = 'TRUE') OR 
      (Message_SYS.Find_Attribute(dop_new_qty_demand_, 'REPLICATE_DOP_IN_SERVER', 'FALSE') = 'TRUE') OR
       (from_co_head_client_ = 'TRUE')) THEN
         
      $IF (Component_Dop_SYS.INSTALLED) $THEN
         linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
         IF (linerec_.revised_qty_due != revised_qty_due_) THEN
            IF (Dop_Demand_Gen_API.Get_Dop_Id(order_no_, line_no_, rel_no_, line_item_no_) IS NOT NULL) THEN
               Dop_Demand_Gen_API.Modify_Dop_Qty(dop_qty_replicate_, order_no_, line_no_, rel_no_, line_item_no_, 
                                                 revised_qty_due_ - (linerec_.qty_assigned + linerec_.qty_shipped), dop_new_qty_demand_, replicate_changes_);        
            END IF;
            IF ((replicate_changes_ = 'TRUE' AND dop_qty_replicate_ = 'TRUE') OR ((revised_qty_due_ - (linerec_.qty_assigned + linerec_.qty_shipped)) < linerec_.qty_on_order)) THEN
               qty_on_order_ := revised_qty_due_ - (linerec_.qty_assigned + linerec_.qty_shipped);
            END IF;
         END IF;

         IF (linerec_.planned_due_date != planned_due_date_) OR (from_co_head_client_ = 'TRUE') OR (Message_Sys.Find_Attribute(dop_new_qty_demand_, 'FROM_COL_ADDR_DIALOGUE', 'FALSE') = 'TRUE') THEN
            IF (Dop_Demand_Gen_API.Get_Dop_Id(order_no_, line_no_, rel_no_, line_item_no_) IS NOT NULL) THEN
               Dop_Demand_Gen_API.Modify_Dop_Due_Date(order_no_, line_no_, rel_no_, line_item_no_, planned_due_date_, replicate_changes_);
         END IF;
      END IF;
      $ELSE 
         NULL;
      $END
   END IF;
END Modify_Dop;


-- Cancel_Dop
--   Cancel DOP header for part with MRP order code 'S' when
--   the corresponding order line has been removed.
PROCEDURE Cancel_Dop (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
BEGIN
   $IF (Component_Dop_SYS.INSTALLED) $THEN 
      Dop_Demand_Gen_API.Cancel_Dop_Head(order_no_, line_no_, rel_no_, line_item_no_);   
   $ELSE 
      NULL;
   $END 
END Cancel_Dop;


-- Generate_Connected_Orders
--   Generate connected orders when a Customer Order is activated.
--   Depending on the supply_code for the customer order lines
--   Shop Orders, Purchase Requisitions, Internal Purchase Orders or
--   DOP orders could be generated.
PROCEDURE Generate_Connected_Orders (
   order_no_ IN VARCHAR2 )
IS
   configurable_   VARCHAR2(20);

   CURSOR lines_to_connect IS
      SELECT line_no, rel_no, line_item_no, configuration_id, contract, catalog_no, supply_code
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_item_no >= 0
      AND    ctp_planned = 'N'
      AND    supply_code IN ('PD', 'PT', 'IPD', 'IPT', 'SO', 'DOP','PS')
      AND    qty_on_order = 0
      AND    rowstate IN ('Released','Reserved')
      ORDER BY LPAD(line_no, 4, ' '), LPAD(rel_no, 4, ' ');
BEGIN
   -- Process all lines on the current order
   FOR next_line_ IN lines_to_connect LOOP
      configurable_ := Sales_Part_API.Get_Configurable_Db(next_line_.contract, next_line_.catalog_no);

      IF NOT ((configurable_ = 'CONFIGURED') AND (next_line_.configuration_id = '*')) THEN
         Create_Connected_Order_Line___(order_no_, next_line_.line_no, next_line_.rel_no, next_line_.line_item_no);
         IF (next_line_.supply_code IN ('PD', 'PT', 'IPD', 'IPT', 'SO')) THEN
            -- Remove the interim order structure
            $IF (Component_Ordstr_SYS.INSTALLED) $THEN 
               Interim_Demand_Head_API.Remove_Or_Retain_Interim_Head('CUSTOMERORDER',
                                                                     order_no_,
                                                                     next_line_.line_no,
                                                                     next_line_.rel_no,
                                                                     next_line_.line_item_no);
            $ELSE 
               NULL;
            $END 
            END IF;
         END IF;
   END LOOP;

   -- Now release all internal purchase orders created if any
   Release_Internal_Pur_Orders___(order_no_);
   -- Release any lines that are capability check reserved/allocated
   Release_Ctp_Planned_Lines___(order_no_);
END Generate_Connected_Orders;


-- Modify_Connected_Order_Line
--   Depending on the supply_code for the customer order lines
--   the connected Shop Orders, Dop order or Purchase Order will be
--   modified with a new quantity, receipt_date and option list.
PROCEDURE Modify_Connected_Order_Line (
   qty_on_order_      IN OUT NUMBER,
   order_attr_        IN OUT VARCHAR2,
   order_no_          IN     VARCHAR2,
   line_no_           IN     VARCHAR2,
   rel_no_            IN     VARCHAR2,
   line_item_no_      IN     NUMBER)
IS
   po_order_no_          VARCHAR2(12);
   po_line_no_           VARCHAR2(4);
   po_rel_no_            VARCHAR2(4);
   purchase_type_        VARCHAR2(200);
   planned_receipt_date_ DATE;
   stmt_                 VARCHAR2(2500);
   attr_                 VARCHAR2(32000);
   rental_attr_          VARCHAR2(32000);
   server_data_change_   NUMBER := 1;
   purchase_type_db_     VARCHAR2(1);
   so_order_no_          VARCHAR2(12);
   so_release_no_        VARCHAR2(4);
   so_sequence_no_       VARCHAR2(4);

   contract_               VARCHAR2(5);
   part_no_                VARCHAR2(25);
   supply_code_db_         VARCHAR2(3);
   revised_qty_due_        NUMBER;
   planned_del_date_       DATE;
   planned_due_date_       DATE;
   change_req_flag_        VARCHAR2(5);
   replicate_ch_flag_      VARCHAR2(5);
   qty_assigned_           NUMBER;
   qty_shipped_            NUMBER;
   ship_via_code_          VARCHAR2(3);
   forward_agent_id_       VARCHAR2(20);
   delivery_terms_         VARCHAR2(5);
   del_terms_location_     VARCHAR2(100);
   changed_attrib_not_in_pol_ VARCHAR2(5);   
   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(32000);
   ext_transport_calendar_id_ VARCHAR2(10);
   ean_locatn_             VARCHAR2(100) := NULL;
   deliver_to_customer_no_ VARCHAR2(20);
   ship_addr_no_           VARCHAR2(50);
   addr_flag_db_           VARCHAR2(1);
   addrec_                 Cust_Order_Line_Address_API.Co_Line_Addr_Rec;
   originating_from_       VARCHAR2(10);
   address_name_           CUST_ORDER_LINE_ADDRESS_2.addr_1%TYPE;
   address1_               CUST_ORDER_LINE_ADDRESS_2.address1%TYPE;
   address2_               CUST_ORDER_LINE_ADDRESS_2.address1%TYPE;
   address3_               CUST_ORDER_LINE_ADDRESS_2.address3%TYPE;
   address4_               CUST_ORDER_LINE_ADDRESS_2.address4%TYPE;
   address5_               CUST_ORDER_LINE_ADDRESS_2.address5%TYPE;
   address6_               CUST_ORDER_LINE_ADDRESS_2.address6%TYPE;
   state_                  CUST_ORDER_LINE_ADDRESS_2.state%TYPE;
   city_                   CUST_ORDER_LINE_ADDRESS_2.city%TYPE;
   county_                 CUST_ORDER_LINE_ADDRESS_2.county%TYPE;
   zip_code_               CUST_ORDER_LINE_ADDRESS_2.zip_code%TYPE;
   country_code_           CUST_ORDER_LINE_ADDRESS_2.country_code%TYPE;
   header_rowstate_        CUSTOMER_ORDER_TAB.rowstate%TYPE;
   default_addr_flag_      CUSTOMER_ORDER_LINE_TAB.Default_Addr_Flag%TYPE;
   packing_instruction_id_ CUSTOMER_ORDER_LINE_TAB.packing_instruction_id%TYPE;
   forward_agent_id_ind_       BOOLEAN := FALSE;
   ship_via_code_ind_          BOOLEAN := FALSE;   
   del_terms_location_ind_     BOOLEAN := FALSE;
   ext_trn_calendar_id_ind_    BOOLEAN := FALSE;
   packing_instruction_id_ind_ BOOLEAN := FALSE;
   ord_line_rec_            Customer_Order_Line_API.Public_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);   
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(order_attr_, ptr_, name_, value_)) LOOP
      CASE name_
      WHEN ('CONTRACT') THEN
         contract_ := value_;
      WHEN ('PART_NO') THEN
         part_no_ := value_;
      WHEN ('SUPPLY_CODE') THEN
         supply_code_db_ := value_;
      WHEN ('REVISED_QTY_DUE') THEN
         revised_qty_due_ := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('PLANNED_DELIVERY_DATE') THEN
         planned_del_date_ := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('PLANNED_DUE_DATE') THEN
         planned_due_date_ :=Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('CHANGE_REQUEST') THEN
         change_req_flag_ := value_;
      WHEN ('REPLICATE_CHANGES') THEN
         replicate_ch_flag_ := value_;
      WHEN ('QTY_ASSIGNED') THEN
         qty_assigned_ := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('QTY_SHIPPED') THEN
         qty_shipped_ := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('SHIP_VIA_CODE') THEN
         ship_via_code_ := value_;
         ship_via_code_ind_ := TRUE;
      WHEN ('FORWARD_AGENT_ID') THEN
         forward_agent_id_ := value_;
         forward_agent_id_ind_ := TRUE;
      WHEN ('DELIVERY_TERMS') THEN
         delivery_terms_ := value_;
      WHEN ('DEL_TERMS_LOCATION') THEN
         del_terms_location_ := value_;
         del_terms_location_ind_ := TRUE;
      WHEN ('CHANGED_ATTRIB_NOT_IN_POL') THEN
         changed_attrib_not_in_pol_ := value_;
      WHEN ('EXT_TRANSPORT_CALENDAR_ID') THEN
         ext_transport_calendar_id_ := value_;
         ext_trn_calendar_id_ind_ := TRUE;
      WHEN ('SHIP_ADDR_NO') THEN
         ship_addr_no_ := value_;
      WHEN ('CUSTOMER_NO') THEN
         deliver_to_customer_no_ := value_;
      WHEN ('ADDR_FLAG_DB') THEN
         addr_flag_db_ := value_;                  
      WHEN ('ORIGINATING_FROM') THEN
         originating_from_ := value_; 
      WHEN ('ADDR_NAME') THEN
         address_name_ := value_;
      WHEN ('ADDRESS1') THEN
         address1_ := value_;
      WHEN ('ADDRESS2') THEN
         address2_ := value_;
      WHEN ('ADDRESS3') THEN
         address3_ := value_;
      WHEN ('ADDRESS4') THEN
         address4_ := value_;
      WHEN ('ADDRESS5') THEN
         address5_ := value_;
      WHEN ('ADDRESS6') THEN
         address6_ := value_;
      WHEN ('ADDR_STATE') THEN
         state_ := value_;
      WHEN ('CITY') THEN
         city_ := value_;
      WHEN ('COUNTY') THEN
         county_ := value_;
      WHEN ('ZIP_CODE') THEN
         zip_code_ := value_;
      WHEN ('COUNTRY_CODE') THEN
         country_code_ := value_;         
      WHEN ('CO_HEADER_STATUS') THEN
         header_rowstate_ := value_;
      WHEN ('DEFAULT_ADDR_FLAG') THEN
         default_addr_flag_ := value_;
      WHEN ('PACKING_INSTRUCTION_ID') THEN
         packing_instruction_id_ := value_;
         packing_instruction_id_ind_ := TRUE;
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, attr_);
      END CASE;
   END LOOP;
   order_attr_ := attr_;
   
   IF (supply_code_db_ IN ('PD', 'PT', 'IPD', 'IPT')) THEN
      Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no_, po_line_no_, po_rel_no_, purchase_type_,
                                                          order_no_, line_no_, rel_no_, line_item_no_);

      purchase_type_db_ := Purchase_Type_API.Encode(purchase_type_);
      
      ord_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
      -- Note: The rental line information is extracted from the attr_ if exist.
      IF (ord_line_rec_.rental = Fnd_Boolean_API.DB_TRUE AND attr_ IS NOT NULL) THEN
         $IF Component_Rental_SYS.INSTALLED $THEN
            Rental_Object_API.Create_Rental_Attr(rental_attr_, attr_);
         $ELSE
            Error_SYS.Component_Not_Exist('RENTAL');
         $END
      END IF;
      
      Client_SYS.Clear_Attr(attr_);      
      Client_SYS.Add_To_Attr('CHANGED_ATTRIB_NOT_IN_POL', changed_attrib_not_in_pol_, attr_);
      Customer_Order_Pur_Order_API.Modify(order_no_, line_no_, rel_no_, line_item_no_,
                                          po_order_no_, po_line_no_, po_rel_no_, attr_);
                                          
      IF (replicate_ch_flag_ = 'TRUE') THEN
         IF (supply_code_db_ IN ('PD', 'IPD')) THEN
            planned_receipt_date_ := planned_del_date_;
         ELSIF (supply_code_db_ IN ('PT', 'IPT')) THEN
            planned_receipt_date_ := planned_due_date_;
         END IF;

         $IF (Component_Purch_SYS.INSTALLED) $THEN 
            IF (Purchase_Part_API.Is_Inventory_Part(contract_, part_no_) = 1) THEN
               IF supply_code_db_ IN ('PT', 'IPT') THEN
                  revised_qty_due_ := Inventory_Part_Planning_API.Get_Scrap_Added_Qty(contract_, part_no_, revised_qty_due_);
               END IF;
            END IF;
            Client_SYS.Clear_Attr(attr_);
            IF revised_qty_due_ IS NOT NULL THEN
               Client_SYS.Add_To_Attr('REVISED_QTY', revised_qty_due_, attr_);
            END IF;
            Client_SYS.Add_To_Attr('PLANNED_RECEIPT_DATE', planned_receipt_date_, attr_);
            Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', server_data_change_, attr_);
            Client_SYS.Add_To_Attr('CHANGED_ATTRIB_NOT_IN_POL', changed_attrib_not_in_pol_, attr_);
            
            IF (supply_code_db_ IN ('PD', 'IPD')) THEN
               IF ship_via_code_ind_ THEN
                  Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_);
               END IF;
               IF forward_agent_id_ind_ THEN
                  Client_SYS.Add_To_Attr('FORWARDER_ID', forward_agent_id_, attr_); 
               END IF;
               IF packing_instruction_id_ind_ THEN
                  Client_SYS.Add_To_Attr('PACKING_INSTRUCTION_ID', packing_instruction_id_, attr_);    
               END IF;
               
               IF (NOT Cust_Order_Line_Address_API.Is_Connected_Addr_Same(order_no_, line_no_, rel_no_, line_item_no_, header_rowstate_, supply_code_db_)) THEN
                  IF ((originating_from_ = 'ADDRESS') OR ((originating_from_ = 'ORDER') AND (addr_flag_db_ = 'N' OR NVL(default_addr_flag_, Database_SYS.string_null_) = 'Y'))) THEN
                     IF ((originating_from_ = 'ORDER') AND (addr_flag_db_ = 'N' OR NVL(default_addr_flag_, Database_SYS.string_null_) = 'Y'))  THEN
                        addrec_ := Cust_Order_Line_Address_API.Get_Co_Line_Addr(order_no_, line_no_, rel_no_, line_item_no_);
                        address_name_ := addrec_.addr_1;
                        address1_ := addrec_.address1;
                        address2_ := addrec_.address2;
                        address3_ := addrec_.address3;
                        address4_ := addrec_.address4;
                        address5_ := addrec_.address5;
                        address6_ := addrec_.address6;
                        state_ := addrec_.state;
                        city_ := addrec_.city;
                        county_ := addrec_.county;
                        zip_code_ := addrec_.zip_code;
                        country_code_ := addrec_.country_code;
                     ELSE                        
                        IF revised_qty_due_ IS NULL THEN                        
                           Client_SYS.Add_To_Attr('REVISED_QTY', ord_line_rec_.revised_qty_due, attr_);
                        END IF;
                     END IF;
                     Client_SYS.Add_To_Attr('ADDR_NAME', address_name_, attr_);
                     Client_SYS.Add_To_Attr('ADDRESS1', address1_, attr_);
                     Client_SYS.Add_To_Attr('ADDRESS2', address2_, attr_);
                     Client_SYS.Add_To_Attr('ADDRESS3', address3_, attr_);
                     Client_SYS.Add_To_Attr('ADDRESS4', address4_, attr_);
                     Client_SYS.Add_To_Attr('ADDRESS5', address5_, attr_);
                     Client_SYS.Add_To_Attr('ADDRESS6', address6_, attr_);
                     Client_SYS.Add_To_Attr('ADDR_STATE', state_, attr_);
                     Client_SYS.Add_To_Attr('CITY', city_, attr_);
                     Client_SYS.Add_To_Attr('COUNTY', county_, attr_);
                     Client_SYS.Add_To_Attr('ZIP_CODE', zip_code_, attr_);
                     Client_SYS.Add_To_Attr('COUNTRY_CODE', country_code_, attr_);
                  END IF;
               END IF;
                              
            END IF;
            IF (supply_code_db_ = 'IPD') THEN
               IF (delivery_terms_ IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr('DELIVERY_TERMS', delivery_terms_, attr_); 
               END IF;
               IF del_terms_location_ind_ THEN
                  Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', del_terms_location_, attr_);
               END IF;
               IF ext_trn_calendar_id_ind_ THEN
                  Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', ext_transport_calendar_id_, attr_);               
               END IF;
               
               IF (addr_flag_db_ = 'N') THEN  
                  IF (ship_addr_no_ IS NOT NULL) THEN
                     ean_locatn_ := Customer_Info_Address_API.Get_Ean_Location(deliver_to_customer_no_, ship_addr_no_);
                     Client_SYS.Add_To_Attr('EAN_LOCATION_DEL_ADDR', ean_locatn_, attr_);
                     Client_SYS.Add_To_Attr('SHIP_ADDR_NO', ship_addr_no_, attr_);
                  END IF;
               END IF;
            END IF;            
            
            IF (changed_attrib_not_in_pol_ = 'FALSE') THEN              
               Purchase_Order_Line_API.Modify_Ord_Line( po_order_no_, po_line_no_, po_rel_no_,
                                                                  purchase_type_, change_req_flag_, attr_, rental_attr_ );
            ELSE
               IF (((change_req_flag_ = 'TRUE') OR (change_req_flag_ IS NULL)) AND 
                  (Purchase_Order_API.Get_Communicated_Via_Db(po_order_no_) LIKE '%^'||Pur_Order_Communication_API.DB_ORDER_SENT||'^%'))  THEN
                  -- Send ORDCHG message without creating purchase order revision
                  Purchase_Order_Transfer_API.Send_Order_Change(po_order_no_, po_line_no_, po_rel_no_);
               END IF;
            END IF;
         $END 
      ELSIF (revised_qty_due_ < qty_on_order_) THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN 
            Purchase_Order_Line_Util_API.Modify_Qty_On_Order_In_Po_Pr(po_order_no_, po_line_no_, po_rel_no_,
                                                                      purchase_type_db_, revised_qty_due_);
         $ELSE 
            NULL;
         $END 
      END IF;

      IF (purchase_type_db_ = 'O') THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN 
            qty_on_order_ := Purchase_Order_Line_Part_Api.Get_Due_In_Stores(po_order_no_, po_line_no_, po_rel_no_);
         $ELSE
            NULL;
         $END 
      ELSIF (purchase_type_db_ = 'R') THEN
         qty_on_order_ := revised_qty_due_;
      END IF;

      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('QTY_ON_ORDER', qty_on_order_, attr_);      
      Customer_Order_Pur_Order_API.Modify(order_no_, line_no_, rel_no_, line_item_no_,
                                          po_order_no_, po_line_no_, po_rel_no_, attr_);
   ELSIF (supply_code_db_ = 'DOP') THEN
      IF (replicate_ch_flag_ = 'TRUE') THEN
         Modify_Dop(qty_on_order_, order_no_, line_no_, rel_no_, line_item_no_, revised_qty_due_, planned_due_date_,NULL, replicate_ch_flag_);
      END IF;
   ELSIF (supply_code_db_ = 'SO') THEN
      IF (replicate_ch_flag_ = 'TRUE') THEN
         Customer_Order_Line_API.Modify_Qty_On_Order(order_no_, line_no_, rel_no_, line_item_no_, revised_qty_due_ - (qty_assigned_+qty_shipped_));
         Modify_Shop_Order___(order_no_, line_no_, rel_no_ , line_item_no_,
                              contract_, part_no_, revised_qty_due_ - (qty_assigned_ + qty_shipped_), planned_due_date_);
         qty_on_order_ := revised_qty_due_ - (qty_assigned_ + qty_shipped_);
      ELSIF (revised_qty_due_ - (qty_assigned_ + qty_shipped_) < qty_on_order_) THEN
         Customer_Order_Shop_Order_API.Get_Shop_Order(so_order_no_,
                                                      so_release_no_,
                                                      so_sequence_no_,
                                                      order_no_,
                                                      line_no_,
                                                      rel_no_,
                                                      line_item_no_);
         Client_SYS.Clear_Attr(attr_);

         Client_SYS.Add_To_Attr('QTY_ON_ORDER', GREATEST(revised_qty_due_ - (qty_assigned_ + qty_shipped_),0), attr_);
         Customer_Order_Shop_Order_API.Modify(order_no_, line_no_, rel_no_, line_item_no_, so_order_no_, so_release_no_, so_sequence_no_, attr_);
         stmt_ := 'BEGIN
                   Shop_Ord_API.Modify(:so_order_no, :so_release_no, :so_sequence_no, :attr);
                END;';

         @ApproveDynamicStatement(2007-09-04,chjalk)
         EXECUTE IMMEDIATE stmt_
            USING IN so_order_no_,
                  IN so_release_no_,
                  IN so_sequence_no_,
                  IN attr_;

         qty_on_order_ := GREATEST(revised_qty_due_ - (qty_assigned_ + qty_shipped_),0);
      END IF;
   END IF;
END Modify_Connected_Order_Line;

PROCEDURE Modify_Connected_Order ( 
   order_no_              IN VARCHAR2,
   customer_po_no_        IN VARCHAR2,
   change_request_        IN VARCHAR2,
   check_ipt_not_exists_  IN VARCHAR2,
   replicate_label_note_  IN VARCHAR2)
IS  
   CURSOR get_pur_orders IS
      SELECT DISTINCT po_order_no
        FROM customer_order_pur_order_tab 
       WHERE oe_order_no = order_no_;
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      FOR pur_order_rec IN get_pur_orders LOOP
         Purchase_Order_API.Modify_Order(pur_order_rec.po_order_no, customer_po_no_, change_request_, check_ipt_not_exists_, replicate_label_note_);   
      END LOOP;   
   $ELSE 
      NULL;
   $END
END Modify_Connected_Order;

-- Cancel_Connected_Order_Line
--   Depending on the supply_code for the customer order lines
--   cancel connected Shop Orders, Dop order or Purchase Order.
PROCEDURE Cancel_Connected_Order_Line (
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   line_item_no_    IN NUMBER )
IS
   stmt_             VARCHAR2(2500);
   so_order_no_      VARCHAR2(12);
   so_release_no_    VARCHAR2(4);
   so_sequence_no_   VARCHAR2(4);
   po_order_no_      VARCHAR2(12);
   po_line_no_       VARCHAR2(4);
   po_rel_no_        VARCHAR2(4);
   purchase_type_    VARCHAR2(200);
   purchase_type_db_ VARCHAR2(1);
   info_             VARCHAR2(2000);
   media_code_       VARCHAR2(30);
   message_type_     VARCHAR2(20);
   new_status_       VARCHAR2(20);
   supply_code_db_   VARCHAR2(3);   

   CURSOR get_line_info IS
      SELECT supply_code
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   IF (Customer_Order_API.Get_Objstate(order_no_) NOT IN ('Planned','Quoted')) THEN
      OPEN get_line_info;
      FETCH get_line_info INTO supply_code_db_;
      CLOSE get_line_info;

      IF (supply_code_db_ IN ('PD', 'PT', 'IPD', 'IPT')) THEN

         Customer_Order_Pur_Order_API.Get_Purord_For_Custord(
                           po_order_no_, po_line_no_, po_rel_no_, purchase_type_,
                           order_no_, line_no_, rel_no_, line_item_no_);

         purchase_type_db_ := Purchase_Type_API.Encode(purchase_type_);

         IF (purchase_type_db_ = 'O') THEN
            stmt_ := 'BEGIN Purchase_Order_Line_API.Cancel_Line(:po_order_no, :po_line_no, :po_release_no, :info); END;';
            @ApproveDynamicStatement(2006-01-24,nidalk)
            EXECUTE IMMEDIATE stmt_
               USING IN     po_order_no_,
                     IN     po_line_no_,
                     IN     po_rel_no_,
                     IN OUT info_;

         ELSIF (purchase_type_db_ = 'R') THEN
            stmt_ := 'BEGIN Purchase_Req_Util_API.Remove_Line_Part(:po_order_no, :po_line_no, :po_release_no); END;';
            @ApproveDynamicStatement(2006-01-24,nidalk)
            EXECUTE IMMEDIATE stmt_
               USING IN po_order_no_,
                     IN po_line_no_,
                     IN po_rel_no_;
         END IF;

         IF (supply_code_db_ IN ('IPD', 'IPT')) THEN
            new_status_ := 'CANCELLED';
            stmt_ := 'BEGIN Purch_Line_Revision_Status_API.Set_Status(:po_order_no, :po_line_no, :po_release_no, :status); END;';
            @ApproveDynamicStatement(2006-01-24,nidalk)
            EXECUTE IMMEDIATE stmt_
               USING IN po_order_no_,
                     IN po_line_no_,
                     IN po_rel_no_,
                     IN new_status_;

            message_type_ := 'ORDCHG';            

            stmt_ := 'BEGIN :media_code := Supplier_Info_Msg_Setup_API.Get_Default_Media_Code(Purchase_Order_API.Get_Vendor_No(:po_order_no), :message_type); END;';
            @ApproveDynamicStatement(2006-01-24,nidalk)
            EXECUTE IMMEDIATE stmt_
               USING OUT media_code_,
                     IN  po_order_no_,
                     IN  message_type_;

            stmt_ := 'BEGIN Purchase_Order_Transfer_API.Send_Order_Change(:po_order_no, NULL, NULL, :media_code ); END;';
            @ApproveDynamicStatement(2006-01-24,nidalk)
            EXECUTE IMMEDIATE stmt_
               USING IN po_order_no_,
                     IN media_code_;
         END IF;
      ELSIF (supply_code_db_ = 'DOP') THEN
         Cancel_Dop(order_no_, line_no_, rel_no_, line_item_no_);
      ELSIF (supply_code_db_ = 'SO') THEN
         Customer_Order_Shop_Order_API.Get_Shop_Order(
                        so_order_no_, so_release_no_, so_sequence_no_,
                        order_no_, line_no_, rel_no_, line_item_no_);

         stmt_ := 'BEGIN Shop_Ord_API.Cancel(:so_order_no, :so_release_no, :so_sequence_no); END;';
         @ApproveDynamicStatement(2010-01-14,kayolk)
         EXECUTE IMMEDIATE stmt_
            USING IN so_order_no_,
                  IN so_release_no_,
                  IN so_sequence_no_;

         Customer_Order_Shop_Order_API.Remove_Cancelled_Order(order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   END IF;
END Cancel_Connected_Order_Line;


-- Create_Connected_Order_Line
--   Generate connected order from a customer order line
--   when the Customer Order is released or changes have been approved from
--   incoming order change.
--   Depending on the supply_code for the customer order lines
--   Shop Orders, Purchase Requisitions, Internal Purchase Orders or
--   DOP orders will be generated for a customer order line.
--   Generate connected order from a customer order line
--   when the Customer Order is released or changes have been approved
--   from incoming order change.
--   Depending on the supply_code for the customer order lines
--   Shop Orders, Purchase Requisitions, Internal Purchase Orders or
--   DOP orders will be generated for a customer order line.
--   This method should be called when adding lines to an already
--   released order.
PROCEDURE Create_Connected_Order_Line (
   qty_on_order_        OUT NUMBER,
   order_no_            IN  VARCHAR2,
   line_no_             IN  VARCHAR2,
   rel_no_              IN  VARCHAR2,
   line_item_no_        IN  NUMBER,
   insert_package_mode_ IN  BOOLEAN )
IS
   line_rec_ Customer_Order_Line_API.Public_Rec;
BEGIN

   Create_Connected_Order_Line___(order_no_, line_no_, rel_no_, line_item_no_);

   line_rec_     := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   qty_on_order_ := line_rec_.qty_on_order;
   
   -- If the internal purchase order is created/merged using a package component part no need to release them here.
   IF (line_rec_.supply_code IN ('IPT', 'IPD') AND NOT(insert_package_mode_)) THEN
      -- The line was added after releasing the customer order.
      -- Release internal purchase order created.
      IF (Supplier_Info_Msg_Setup_API.Get_Default_Media_Code(line_rec_.vendor_no, 'ORDERS') IS NOT NULL) THEN
         Release_Internal_Pur_Order___(order_no_, line_no_, rel_no_, line_item_no_, line_rec_.part_no);
      END IF;
   END IF;
END Create_Connected_Order_Line;


-- Connect_To_Ctp_Generated_Order
--   Changes supply code on the order line, creates a Shop Order or
--   Purchase Order and modifies qty_on_order on the order line.
PROCEDURE Connect_To_Ctp_Generated_Order (
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   new_supply_code_db_ IN VARCHAR2,
   qty_on_order_       IN NUMBER,
   identity1_          IN VARCHAR2,
   identity2_          IN VARCHAR2,
   identity3_          IN VARCHAR2,
   purchase_type_db_   IN VARCHAR2 )
IS
BEGIN
   IF (new_supply_code_db_ NOT IN ('SO','PT','PD')) THEN
      Error_SYS.Record_General(lu_name_, 'CONWRONGSUPCODE: Supply Code :P1 is not allowed here, only :P2 and :P3 is allowed for CTP planned Orders',
                              nvl(Order_Supply_Type_API.Decode(new_supply_code_db_),new_supply_code_db_),
                              Order_Supply_Type_API.Decode('SO')||', '||Order_Supply_Type_API.Decode('PT'),
                              Order_Supply_Type_API.Decode('PD'));
   END IF;

   IF (purchase_type_db_ NOT IN ('O','R')) AND (new_supply_code_db_ IN ('PT','PD')) THEN
      Error_SYS.Record_General(lu_name_, 'CONWRONGPURTYPE: Purchase Type :P1 is not allowed for Supply Code :P2',
                               nvl(Purchase_Type_API.Decode(purchase_type_db_),purchase_type_db_),
                               Order_Supply_Type_API.Decode(new_supply_code_db_));
   END IF;

   Customer_Order_Line_API.Modify_Acquisition_Type__(order_no_, line_no_, rel_no_, line_item_no_, new_supply_code_db_);

   IF (new_supply_code_db_ = 'SO') THEN
      Customer_Order_Shop_Order_API.New(order_no_, line_no_, rel_no_, line_item_no_, identity1_, identity2_, identity3_);
   ELSIF (new_supply_code_db_ = 'PT') OR (new_supply_code_db_ = 'PD') THEN
      Customer_Order_Pur_Order_API.New(order_no_, line_no_, rel_no_, line_item_no_, identity1_, identity2_, identity3_,
         Purchase_Type_API.Decode(purchase_type_db_));
   END IF;

   Customer_Order_Line_API.Modify_Qty_On_Order(order_no_, line_no_, rel_no_, line_item_no_, qty_on_order_);
END Connect_To_Ctp_Generated_Order;


-- Connect_Wo_To_Mro_Line
--   This method is used to connect a Work Order into a MRO Customer Order Line.
PROCEDURE Connect_Wo_To_Mro_Line (
   line_no_       OUT    VARCHAR2,
   rel_no_        OUT    VARCHAR2,
   line_item_no_  OUT    NUMBER,
   order_no_      IN OUT VARCHAR2,
   customer_no_   IN     VARCHAR2,
   part_no_       IN     VARCHAR2,
   serial_no_     IN     VARCHAR2,
   contract_      IN     VARCHAR2,
   wo_no_         IN     VARCHAR2,
   order_type_    IN     VARCHAR2,
   coordinator_   IN     VARCHAR2,
   currency_code_ IN     VARCHAR2 )
IS
   info_               VARCHAR2(2000);
   attr_               VARCHAR2(2000);
   sales_part_no_      VARCHAR2(25);
   inv_part_rec_       Inventory_Part_API.Public_Rec;
   create_sales_part_  BOOLEAN := FALSE;
   create_mro_line_    BOOLEAN := FALSE;
   reserve_order_      BOOLEAN := FALSE;
   state_              VARCHAR2(20);
   location_no_        VARCHAR2(35);
   lot_batch_no_       VARCHAR2(20);
   eng_chg_level_      VARCHAR2(6);
   waiv_dev_rej_no_    VARCHAR2(15);
   qty_available_      NUMBER;
   configuration_id_   VARCHAR2(50);
   location_type_      VARCHAR2(20);
   auto_reservation_   VARCHAR2(50);
   order_issue_        VARCHAR2(50);
   condition_code_     VARCHAR2(10);
   part_serial_no_     VARCHAR2(50);
   old_cond_code_      VARCHAR2(10);
   dummy_activity_seq_ NUMBER := 0;
   dummy_project_id_   VARCHAR2(10) := NULL;
   part_cat_rec_       Part_Catalog_API.Public_Rec;
   handling_unit_id_   NUMBER := NULL;

   CURSOR mro_line_exist IS
      SELECT line_no, rel_no, line_item_no, condition_code
      FROM  customer_order_line_tab
      WHERE order_no = order_no_
      AND   part_no = part_no_
      AND   supply_code = 'MRO'
      AND   rowstate = 'Released';
BEGIN
   condition_code_ := Part_Serial_Catalog_API.Get_Condition_Code(part_no_, serial_no_);
   IF (order_no_ IS NOT NULL) THEN
      -- Note: CO is already connected to a WO. Check for a MRO line exist
      OPEN mro_line_exist;
      FETCH mro_line_exist INTO line_no_, rel_no_, line_item_no_, old_cond_code_;
      CLOSE mro_line_exist;
      IF (line_no_ IS NOT NULL) THEN
         -- Note: MRO line exist. Modify it with WO connection reference parameters
         Client_SYS.Clear_Attr(attr_);
         IF (old_cond_code_ != condition_code_) THEN
            Client_SYS.Add_To_Attr('CONDITION_CODE', condition_code_, attr_);
         END IF;
         Client_SYS.Add_To_Attr('DEMAND_CODE_DB', 'WO', attr_);
         Client_SYS.Add_To_Attr('DEMAND_ORDER_REF1', wo_no_, attr_);
         Customer_Order_Line_API.Modify(attr_, order_no_, line_no_, rel_no_, line_item_no_);
         reserve_order_ := TRUE;
      ELSE
         -- Note: NO MRO line exist. have to create a MRO line
         sales_part_no_ := Sales_Part_API.Get_Catalog_No_For_Part_No(contract_, part_no_);
         IF (sales_part_no_ IS NULL) THEN
            create_sales_part_ := TRUE;
         END IF;
         create_mro_line_ := TRUE;
      END IF;
   ELSE
      -- Note: No CO is connected to a WO. Create a CO header
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_no_, attr_);
      IF (order_type_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('ORDER_ID', order_type_, attr_);
      END IF;
      IF (coordinator_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('AUTHORIZE_CODE', coordinator_, attr_);
      END IF;
      IF (currency_code_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('CURRENCY_CODE', currency_code_, attr_);
      END IF;
      Customer_Order_API.New(info_, attr_);
      order_no_      := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
      sales_part_no_ := Sales_Part_API.Get_Catalog_No_For_Part_No(contract_, part_no_);
      IF (sales_part_no_ IS NULL) THEN
         create_sales_part_ := TRUE;
      END IF;
      create_mro_line_ := TRUE;
   END IF;

   IF (create_sales_part_) THEN
      inv_part_rec_ := Inventory_Part_API.Get(contract_, part_no_);
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
      Client_SYS.Add_To_Attr('CATALOG_NO', part_no_, attr_);
      Client_SYS.Add_To_Attr('CATALOG_DESC', Inventory_Part_API.Get_Description(contract_, part_no_), attr_);
      Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
      Client_SYS.Add_To_Attr('CATALOG_TYPE_DB', 'INV', attr_);
      Client_SYS.Add_To_Attr('SALES_UNIT_MEAS', inv_part_rec_.unit_meas, attr_);
      Client_SYS.Add_To_Attr('PRICE_UNIT_MEAS', inv_part_rec_.unit_meas, attr_);
      Client_SYS.Add_To_Attr('SALES_PRICE_GROUP_ID', '*', attr_);
      Client_SYS.Add_To_Attr('CATALOG_GROUP', '*', attr_);
      Client_SYS.Add_To_Attr('LIST_PRICE', 0, attr_);
      Client_SYS.Add_To_Attr('QUICK_REGISTERED_PART_DB', 'TRUE', attr_);

      Sales_Part_API.New(info_, attr_);
      sales_part_no_ := part_no_;
   END IF;
   IF (create_mro_line_) THEN
      Customer_Order_API.Get_Next_Line_No(rel_no_, line_item_no_, line_no_, order_no_, contract_, sales_part_no_, 'MRO');
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
      Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
      Client_SYS.Add_To_Attr('CATALOG_NO', sales_part_no_, attr_);
      Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
      Client_SYS.Add_To_Attr('SUPPLY_CODE_DB', 'MRO', attr_);
      Client_SYS.Add_To_Attr('DEMAND_CODE_DB', 'WO', attr_);
      Client_SYS.Add_To_Attr('DEMAND_ORDER_REF1', wo_no_, attr_);
      Client_SYS.Add_To_Attr('BUY_QTY_DUE', 1, attr_);
      Client_SYS.Add_To_Attr('PART_OWNERSHIP_DB', 'CUSTOMER OWNED', attr_);
      Client_SYS.Add_To_Attr('OWNING_CUSTOMER_NO', customer_no_, attr_);
      Client_SYS.Add_To_Attr('CONDITION_CODE', condition_code_, attr_);

      part_cat_rec_ := Part_Catalog_API.Get(part_no_);
      IF (part_cat_rec_.configurable = 'CONFIGURED' AND part_cat_rec_.eng_serial_tracking_code   = 'SERIAL TRACKING') THEN
         configuration_id_ := Part_Serial_Catalog_API.Get_Configuration_Id(part_no_,serial_no_);
         IF (configuration_id_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('CONFIGURATION_ID', configuration_id_, attr_);
         END IF;
      END IF;

      Customer_Order_Line_API.New(info_, attr_);
      line_no_      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
      rel_no_       := Client_SYS.Get_Item_Value('REL_NO', attr_);
      line_item_no_ := Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_);

      reserve_order_ := TRUE;
   END IF;
   IF (reserve_order_) THEN
      part_serial_no_ := serial_no_;
      Inventory_Part_In_Stock_API.Find_Part(qty_available_        => qty_available_,
                                            location_no_          => location_no_,
                                            lot_batch_no_         => lot_batch_no_,
                                            serial_no_            => part_serial_no_,
                                            eng_chg_level_        => eng_chg_level_,
                                            waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                            configuration_id_     => configuration_id_,
                                            activity_seq_         => dummy_activity_seq_,
                                            handling_unit_id_     => handling_unit_id_,
                                            contract_             => contract_,
                                            part_no_              => part_no_,
                                            location_type_        => location_type_,
                                            auto_reservation_     => auto_reservation_,
                                            order_issue_          => order_issue_,
                                            project_id_           => dummy_project_id_,
                                            condition_code_       => condition_code_,
                                            part_ownership_       => 'CUSTOMER OWNED',
                                            owning_vendor_no_     => NULL,
                                            owning_customer_no_   => customer_no_);

      IF (qty_available_ = 0) THEN
         Error_SYS.Record_General(lu_name_,'NOT_INV_LOCATION: It is not possible to reserve the MRO object. Make sure that the object is not already reserved and that it has been received into a Picking, Production Line or Shop Floor location.');
      END IF;

      Reserve_Customer_Order_API.Reserve_Manually__(info_,
                                                    state_,
                                                    order_no_,
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
                                                    dummy_activity_seq_,
                                                    handling_unit_id_,
                                                    1,
                                                    NULL,
                                                    NULL,
                                                    NULL,
                                                    NULL,
                                                    0 );
   END IF;
END Connect_Wo_To_Mro_Line;


-- Is_Wo_Connected_To_Mro_Line
--   This method is used from Work Order side, to check whether the
--   Work Order is connected to a MRO line or not.
@UncheckedAccess
FUNCTION Is_Wo_Connected_To_Mro_Line (
   order_no_  IN VARCHAR2,
   wo_no_     IN VARCHAR2,
   part_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   connected_ VARCHAR2(10) := 'FALSE';
   dummy_     NUMBER := 0;
   CURSOR mro_line_ref_exist IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE demand_code = 'WO'
      AND supply_code = 'MRO'
      AND demand_order_ref1 = wo_no_
      AND part_no = part_no_
      AND order_no = order_no_
      AND rowstate NOT IN ('Released', 'Cancelled');
BEGIN
   IF (order_no_ IS NOT NULL) THEN
      OPEN mro_line_ref_exist;
      FETCH mro_line_ref_exist INTO dummy_;
      CLOSE mro_line_ref_exist;
      IF (dummy_ = 1) THEN
         connected_ := 'TRUE';
      END IF;
   END IF;
   RETURN connected_;
END Is_Wo_Connected_To_Mro_Line;



@UncheckedAccess
FUNCTION Is_Order_Line_Exist (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_  NUMBER := 0;
   temp_   VARCHAR2(5) := 'FALSE';

   CURSOR check_line_exist IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND rowstate NOT IN ('Cancelled');
BEGIN
   OPEN check_line_exist;
   FETCH check_line_exist INTO dummy_;
   CLOSE check_line_exist;
   IF (dummy_ = 1) THEN
      temp_ := 'TRUE';
   END IF;
   RETURN temp_;
END Is_Order_Line_Exist;



-- Is_Pegged_Object_Updatable
--   This method is used to check if the connected/pegged Purchase Order or
--   Requsition is in a state upadatable.
FUNCTION Is_Pegged_Object_Updatable (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   supply_code_db_   VARCHAR2(3);
   po_line_state_    VARCHAR2(20);
   pr_line_state_    VARCHAR2(20);
   flag_             VARCHAR2(5);
   po_no_            VARCHAR2(12);
   po_line_no_       VARCHAR2(4);
   po_rel_no_        VARCHAR2(4);
   purchase_type_    VARCHAR2(36);
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      supply_code_db_ := Order_Supply_Type_API.Encode(Customer_Order_Line_API.Get_Supply_Code(order_no_, line_no_, rel_no_, line_item_no_));
      IF (supply_code_db_ IN ('IPD', 'IPT', 'PD', 'PT')) THEN
         Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_no_,
                                                             po_line_no_,
                                                             po_rel_no_,
                                                             purchase_type_,
                                                             order_no_,
                                                             line_no_,
                                                             rel_no_,
                                                             line_item_no_);
         IF Purchase_Type_API.Encode(purchase_type_) = 'R' THEN
            pr_line_state_ := Purchase_Req_Line_Part_API.Get_Objstate(po_no_, po_line_no_, po_rel_no_);
            IF (pr_line_state_ IN ('Request Created', 'PO Created', 'Change Order Created')) THEN
               flag_ := 'FALSE';
               Purchase_Req_Line_Part_API.Get_Purord_For_Custord(po_no_,
                                                                 po_line_no_,
                                                                 po_rel_no_,
                                                                 order_no_,
                                                                 line_no_,
                                                                 rel_no_,
                                                                 line_item_no_);
               po_line_state_ := Purchase_Order_Line_Part_API.Get_Objstate(po_no_, po_line_no_, po_rel_no_);
               IF (po_line_state_ IN ('Received', 'Closed', 'Cancelled')) THEN
                  flag_ := 'FALSE';
               ELSE
                  flag_ := 'TRUE';
               END IF;
            ELSE
               flag_ := 'TRUE';
            END IF;
         ELSE
            po_line_state_ := Purchase_Order_Line_Part_API.Get_Objstate(po_no_, po_line_no_, po_rel_no_);
            IF (po_line_state_ IN ('Received', 'Closed', 'Cancelled')) THEN
               flag_ := 'FALSE';
            ELSE
               flag_ := 'TRUE';
            END IF;
         END IF;
      END IF;
  $END
      
  RETURN flag_;
END Is_Pegged_Object_Updatable;


-- More_Supplies_Expected
--   This returns 1 if there are more qty to be handled by the relevant Supply Order. If the full qty has
--   been handled by manually reserving or if the Customer Order has no peggings to a Supply then this will return 0.
@UncheckedAccess
FUNCTION More_Supplies_Expected (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER ) RETURN NUMBER 
IS
   line_is_fully_reserved_  NUMBER;
   co_qty_on_order_         NUMBER;
   cust_ord_line_state_     VARCHAR2(20);
   expected_supplies_       NUMBER;   
BEGIN   
   cust_ord_line_state_    := Customer_Order_Line_API.Get_objstate(order_no_, line_no_, rel_no_, line_item_no_);
   line_is_fully_reserved_ := Reserve_Customer_Order_API.Line_Is_Fully_Reserved(order_no_, line_no_, rel_no_, line_item_no_);
   co_qty_on_order_        := Customer_Order_Line_API.Get_Qty_On_Order(order_no_, line_no_, rel_no_, line_item_no_);

   IF ((cust_ord_line_state_ NOT IN ('Cancelled', 'Invoiced')) AND (line_is_fully_reserved_ = 0) AND co_qty_on_order_ != 0) THEN
      expected_supplies_ := 1;
   ELSE
      expected_supplies_ := 0;
   END IF;
   RETURN expected_supplies_;
END More_Supplies_Expected;


-- Modify_Conn_Cust_Order_Line
--   The method is used to update the connected Customer Order line with buy
--   quantity and delivery date, when the connected Purchase Requsition is changed.
PROCEDURE Modify_Conn_Cust_Order_Line (
   qty_on_order_          IN NUMBER,
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   release_no_            IN VARCHAR2,
   line_item_no_          IN NUMBER,
   revised_qty_due_       IN NUMBER,
   planned_delivery_date_ IN DATE,
   planned_due_date_      IN DATE,
   send_ord_conf_flag_    IN VARCHAR2,
   replicate_ch_flag_     IN VARCHAR2,
   purch_attr_            IN VARCHAR2 DEFAULT NULL )
IS
   conn_cust_order_line_attr_   VARCHAR2(32000);
BEGIN
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, conn_cust_order_line_attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, conn_cust_order_line_attr_);
   Client_SYS.Add_To_Attr('RELEASE_NO', release_no_, conn_cust_order_line_attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, conn_cust_order_line_attr_);
   Client_SYS.Add_To_Attr('QTY_ON_ORDER', qty_on_order_, conn_cust_order_line_attr_);
   Client_SYS.Add_To_Attr('REVISED_QTY_DUE', revised_qty_due_, conn_cust_order_line_attr_);
   Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE', planned_delivery_date_, conn_cust_order_line_attr_);
   Client_SYS.Add_To_Attr('PLANNED_DUE_DATE', planned_due_date_, conn_cust_order_line_attr_);
               
   Modify_Conn_Cust_Order_Line(conn_cust_order_line_attr_,
                               send_ord_conf_flag_,
                               replicate_ch_flag_,
                               purch_attr_);
END Modify_Conn_Cust_Order_Line;
   
-- Modify_Conn_Cust_Order_Line
--   The method is used to update the connected Customer Order line 
--   when the connected Purchase Order is changed.
PROCEDURE Modify_Conn_Cust_Order_Line (
   conn_cust_order_line_attr_ IN VARCHAR2,
   send_ord_conf_flag_        IN VARCHAR2,
   replicate_ch_flag_         IN VARCHAR2,
   purch_attr_                IN VARCHAR2 DEFAULT NULL )
IS
   attr_                   VARCHAR2(32000);
   send_attr_              VARCHAR2(1000);
   media_code_             VARCHAR2(30);
   line_rec_               Customer_Order_Line_API.Public_Rec;
   po_order_no_            VARCHAR2(12);
   po_line_no_             VARCHAR2(4);
   po_rel_no_              VARCHAR2(4);
   purchase_type_          VARCHAR2(200);
   input_variable_values_  VARCHAR2(2000);
   temp_planned_due_date_  DATE;
   buy_qty_due_            NUMBER;
   input_qty_              NUMBER;
   dates_calculated_       BOOLEAN := FALSE;

   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(32000);
   msg_                    VARCHAR2(32000);   
   order_no_               VARCHAR2(12);
   line_no_                VARCHAR2(4);
   release_no_             VARCHAR2(4);
   line_item_no_           NUMBER;
   qty_on_order_           NUMBER;
   revised_qty_due_        NUMBER;
   planned_delivery_date_  DATE;
   planned_due_date_       DATE;
   ship_via_code_          VARCHAR2(3);
   forward_agent_id_       VARCHAR2(20);
   delivery_terms_         VARCHAR2(5);
   del_terms_location_     VARCHAR2(100);
   ext_transport_calendar_id_ VARCHAR2(10);
   packing_instruction_id_    VARCHAR2(50);
   customer_part_buy_qty_  NUMBER;
BEGIN
   Client_SYS.Clear_Attr(msg_);
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(conn_cust_order_line_attr_, ptr_, name_, value_)) LOOP
      CASE name_
      WHEN ('ORDER_NO') THEN
         order_no_ := value_;
      WHEN ('LINE_NO') THEN
         line_no_ := value_;
      WHEN ('RELEASE_NO') THEN
         release_no_ := value_;
      WHEN ('LINE_ITEM_NO') THEN
         line_item_no_ := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('QTY_ON_ORDER') THEN
         qty_on_order_ := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('REVISED_QTY_DUE') THEN
         revised_qty_due_ := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('PLANNED_DELIVERY_DATE') THEN
         planned_delivery_date_ := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('PLANNED_DUE_DATE') THEN
         planned_due_date_ := Client_SYS.Attr_Value_To_Date(value_);
      WHEN ('SHIP_VIA_CODE') THEN
         ship_via_code_ := value_;
      WHEN ('FORWARD_AGENT_ID') THEN
         forward_agent_id_ := value_;
      WHEN ('DELIVERY_TERM') THEN
         delivery_terms_ := value_;
      WHEN ('DEL_TERMS_LOCATION') THEN
         del_terms_location_ := value_;
      WHEN ('EXT_TRANSPORT_CALENDAR_ID') THEN
         ext_transport_calendar_id_ := value_;
      WHEN ('PACKING_INSTRUCTION_ID') THEN
         packing_instruction_id_ := value_;
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, msg_);
      END CASE;
   END LOOP;
   
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, release_no_, line_item_no_);
   ship_via_code_ := NVL(ship_via_code_,line_rec_.ship_via_code);
   
   IF (replicate_ch_flag_ = Fnd_Boolean_API.DB_TRUE) THEN
      Client_Sys.Clear_Attr(attr_);      
      -- Note: It is added rental line information to the attr_.
      IF (line_rec_.rental = Fnd_Boolean_API.DB_TRUE AND purch_attr_ IS NOT NULL) THEN
         $IF Component_Rental_SYS.INSTALLED $THEN
            Rental_Object_API.Create_Rental_Attr(attr_, purch_attr_);
         $ELSE
            Error_SYS.Component_Not_Exist('RENTAL');
         $END
      END IF;
      
      -- Remove scrap added quantity if added before checking the quantity change.
      IF (line_rec_.supply_code IN ('PT', 'IPT')) THEN
         revised_qty_due_ := Inventory_Part_Planning_API.Get_Scrap_Removed_Qty(line_rec_.contract, 
                                                                          line_rec_.part_no, 
                                                                          revised_qty_due_);
         qty_on_order_    := Inventory_Part_Planning_API.Get_Scrap_Removed_Qty(line_rec_.contract, 
                                                                          line_rec_.part_no, 
                                                                          qty_on_order_);
      END IF;
      
      IF (line_rec_.revised_qty_due != revised_qty_due_) THEN
         Client_SYS.Add_To_Attr('REVISED_QTY_DUE', revised_qty_due_, attr_);
         buy_qty_due_ := revised_qty_due_ * (line_rec_.inverted_conv_factor/ line_rec_.conv_factor);
         Client_SYS.Add_To_Attr('BUY_QTY_DUE', buy_qty_due_, attr_);
         
         IF ((line_rec_.customer_part_conv_factor IS NOT NULL) AND (line_rec_.cust_part_invert_conv_fact IS NOT NULL)) THEN
              customer_part_buy_qty_ := buy_qty_due_ * (line_rec_.cust_part_invert_conv_fact / line_rec_.customer_part_conv_factor );
         END IF;        
         Client_SYS.Add_To_Attr('CUSTOMER_PART_BUY_QTY', customer_part_buy_qty_, attr_);
         -- If customer order line defined with input unit measure values, 
         -- Then it should be adjusted the input qty with sales quantity.
         IF (line_rec_.input_unit_meas IS NOT NULL) THEN
            input_qty_ := (buy_qty_due_ / line_rec_.input_conv_factor);
            input_variable_values_ := Input_Unit_Meas_API.Get_Input_Value_String(input_qty_, line_rec_.input_unit_meas);
            Client_SYS.Add_To_Attr('INPUT_QTY', input_qty_, attr_);
            Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES', input_variable_values_, attr_);
         END IF;
      END IF;
      
      IF ((line_rec_.supply_code IN ('DOP','IPD', 'PD','IPT', 'PT')) OR (line_rec_.planned_due_date != planned_due_date_)) THEN
         IF (line_rec_.supply_code IN ('IPD', 'PD')) THEN
            IF (planned_due_date_ < line_rec_.target_date) THEN
               Client_SYS.Add_To_Attr('TARGET_DATE', planned_due_date_, attr_);               
            ELSE
               -- For direct deliveries planned delivery date should be the same as the planned due date.
               Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE', planned_due_date_, attr_);
            END IF;
         ELSIF (line_rec_.supply_code IN ('IPT', 'PT')) THEN
            IF (line_rec_.planned_due_date < planned_due_date_) THEN
                Customer_Order_Line_API.Update_Planning_Date (order_no_, line_no_, release_no_, line_item_no_, planned_due_date_, NULL);
                dates_calculated_ := TRUE;
            ELSE
               temp_planned_due_date_ := planned_due_date_;  
                             
               Cust_Ord_Date_Calculation_API.Calc_Order_Dates_Forwards(line_rec_.planned_delivery_date, line_rec_.planned_ship_date, temp_planned_due_date_,
                                                                       line_rec_.supply_site_due_date, NULL, line_rec_.contract, line_rec_.supply_code, line_rec_.deliver_to_customer_no,
                                                                       line_rec_.vendor_no, line_rec_.part_no, NVL(line_rec_.part_no, line_rec_.purchase_part_no), line_rec_.ship_addr_no, line_rec_.ship_via_code,
                                                                       line_rec_.route_id, line_rec_.delivery_leadtime, line_rec_.picking_leadtime, line_rec_.ext_transport_calendar_id, line_rec_.supplier_ship_via_transit);
                                                                       
               line_rec_.planned_delivery_date := TO_DATE(TO_CHAR(line_rec_.planned_delivery_date, 'YYYY-MM-DD') || ' ' || TO_CHAR(line_rec_.target_date, 'HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS');
                            
                              
               IF (line_rec_.planned_delivery_date >= line_rec_.wanted_delivery_date) THEN
                  IF (line_rec_.target_date > line_rec_.planned_delivery_date) THEN                                  
                     Client_SYS.Add_To_Attr('TARGET_DATE', line_rec_.planned_delivery_date, attr_);
                  ELSE
                     Customer_Order_Line_API.Update_Planning_Date (order_no_, line_no_, release_no_, line_item_no_, planned_due_date_, NULL);
                     dates_calculated_ := TRUE;
                  END IF; 
               END IF;
            END IF;                   
         ELSE
            Customer_Order_Line_API.Update_Planning_Date (order_no_, line_no_, release_no_, line_item_no_, planned_due_date_, NULL);
            dates_calculated_ := TRUE;
         END IF;
      END IF;
      Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 1, attr_);
      Client_SYS.Add_To_Attr('QTY_ON_ORDER', qty_on_order_, attr_);
      Client_SYS.Add_To_Attr('EVALUATE_DEFAULT_INFO', 'TRUE', attr_);
               
      IF (line_rec_.supply_code IN ('PD', 'IPD')) THEN
         Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_); 
         Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', forward_agent_id_, attr_);
         Client_SYS.Add_To_Attr('PACKING_INSTRUCTION_ID', packing_instruction_id_, attr_);
      END IF;
      
      IF (line_rec_.supply_code = 'IPD') THEN
         IF (delivery_terms_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('DELIVERY_TERMS', delivery_terms_, attr_); 
         END IF;
         Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', del_terms_location_, attr_);
         Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', ext_transport_calendar_id_, attr_);
      END IF;
      
      Customer_Order_Line_API.Modify (attr_, order_no_, line_no_, release_no_, line_item_no_);
      -- Checked dates_calculated_ to avoid calling Update_Package_Dates again since it is called inside the Update_Planning_Date. 
      IF (line_item_no_ > 0) AND (line_rec_.planned_due_date != planned_due_date_) AND (NOT dates_calculated_) THEN
         Customer_Order_Line_API.Update_Package_Dates(order_no_, line_no_, release_no_);
      END IF;
   ELSIF (qty_on_order_ < line_rec_.qty_on_order) THEN
      Customer_Order_Line_API.Modify_Qty_On_Order(order_no_, line_no_, release_no_, line_item_no_, qty_on_order_);
   END IF;

   Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no_, po_line_no_, po_rel_no_, purchase_type_,
                                                       order_no_, line_no_, release_no_, line_item_no_);
   Client_SYS.Clear_Attr(attr_);
   IF (po_order_no_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('QTY_ON_ORDER', qty_on_order_, attr_);
      Customer_Order_Pur_Order_API.Modify(order_no_, line_no_, release_no_, line_item_no_,
                                          po_order_no_, po_line_no_, po_rel_no_, attr_);
   END IF;
   IF (send_ord_conf_flag_ = 'TRUE') THEN
      IF (Customer_Order_Transfer_API.Allowed_To_Send(order_no_, 'ORDRSP')= 1) THEN
         media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(Customer_Order_API.Get_Customer_No(order_no_), 'ORDRSP');
         Client_Sys.Clear_Attr(send_attr_);
         Client_SYS.Add_To_Attr('START_EVENT', 40, send_attr_);
         Client_SYS.Add_To_Attr('ORDER_NO', order_no_, send_attr_);
         Client_SYS.Add_To_Attr('MEDIA_CODE', media_code_, send_attr_);
         Client_SYS.Add_To_Attr('END', To_Number(NULL), send_attr_);
         Customer_Order_Flow_API.Start_Print_Order_Conf__(send_attr_);
      END IF;
   END IF;
END Modify_Conn_Cust_Order_Line;


-- Remove_Project_Connection
--   This method is used to remove manually created connections from project.
PROCEDURE Remove_Project_Connection (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   activity_seq_ IN NUMBER )
IS
   dummy_            VARCHAR2(10);
BEGIN
   -- Remove Customer Order Line and Customer Order Revenue connections
   $IF (Component_Proj_SYS.INSTALLED) $THEN
      Project_Connection_Util_API.Remove_Connection ('COLINE',
                                                     activity_seq_,
                                                     order_no_,
                                                     line_no_,
                                                     rel_no_,
                                                     line_item_no_,
                                                     dummy_,
                                                     dummy_);
      IF Project_Connection_Util_API.Exist_Project_Connection(activity_seq_,
                                                              order_no_,
                                                              line_no_,
                                                              rel_no_,
                                                              line_item_no_,
                                                              dummy_,
                                                              dummy_,
                                                             'COLINEREV') = 'TRUE' THEN 
         Project_Connection_Util_API.Remove_Connection('COLINEREV',
                                                       activity_seq_,
                                                       order_no_,
                                                       line_no_,
                                                       rel_no_,
                                                       line_item_no_,
                                                       dummy_,
                                                       dummy_);                                                           
      END IF;
   $ELSE
      NULL;
   $END 
END Remove_Project_Connection;


PROCEDURE Modify_Shop_Order_Peggings (
   so_order_no_       IN VARCHAR2,
   so_release_no_     IN VARCHAR2,
   so_sequence_no_    IN VARCHAR2,
   qty_on_order_      IN NUMBER,
   replicate_ch_flag_ IN VARCHAR2 )
IS
   order_no_      VARCHAR2(12);
   line_no_       VARCHAR2(4);
   rel_no_        VARCHAR2(4);
   line_item_no_  NUMBER;
   attr_          VARCHAR2(2000);
   ord_state_db_  VARCHAR2(20);
   ord_state_     VARCHAR2(200);
   linerec_       Customer_Order_Line_API.Public_Rec;
BEGIN
   -- Get Customer order line keys. Notice the order of rel_no and line_no here
   Customer_Order_Shop_Order_API.Get_Shop_Order_Origin(order_no_, rel_no_, line_no_, line_item_no_, so_order_no_,so_release_no_,so_sequence_no_);

   IF (order_no_ IS NOT NULL) THEN  -- if supply code = IO we will get null from Get_Shop_Order_Origin method and should not do anything more

      linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
      IF (replicate_ch_flag_ = 'TRUE') THEN
         ord_state_db_ := Customer_Order_Line_API.Get_Objstate(order_no_, line_no_, rel_no_, line_item_no_);

         IF (ord_state_db_ NOT IN ('Released', 'Reserved')) THEN
            ord_state_ := Customer_Order_Line_API.Get_State(order_no_, line_no_, rel_no_, line_item_no_);
            Error_SYS.Record_General(lu_name_, 'CANT_UPDATE_CO: The connected Customer Order is in state :P1 and therefore cannot be updated.', ord_state_);
         END IF;

         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('REVISED_QTY_DUE', qty_on_order_ + linerec_.qty_assigned + linerec_.qty_shipped, attr_);
         Client_SYS.Add_To_Attr('BUY_QTY_DUE', (qty_on_order_ + linerec_.qty_assigned + linerec_.qty_shipped) * (linerec_.inverted_conv_factor/linerec_.conv_factor), attr_);
         Client_SYS.Add_To_Attr('QTY_ON_ORDER', qty_on_order_, attr_);
         Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 1, attr_);
         Customer_Order_Line_API.Modify(attr_, order_no_, line_no_, rel_no_, line_item_no_);
      ELSIF (qty_on_order_ < linerec_.qty_on_order) THEN
         Customer_Order_Line_API.Modify_Qty_On_Order(order_no_, line_no_, rel_no_, line_item_no_, qty_on_order_);
      END IF;

      -- Modify the quantity in the connection tab.
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('QTY_ON_ORDER', qty_on_order_, attr_);
      Customer_Order_Shop_Order_API.Modify(order_no_, line_no_, rel_no_, line_item_no_, so_order_no_, so_release_no_, so_sequence_no_, attr_);
   END IF;
END Modify_Shop_Order_Peggings;


-- Release_Internal_Pur_Orders
--   Release all internal purchase orders created when adding a package part
--   to a release CO
PROCEDURE Release_Internal_Pur_Orders (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2  )
IS
   CURSOR lines_to_release IS
      SELECT line_item_no, part_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no  = rel_no_
      AND    line_item_no > 0
      AND    supply_code IN ('IPD', 'IPT');
BEGIN
   FOR next_component_part_ IN lines_to_release LOOP
      Release_Internal_Pur_Order___(order_no_, line_no_, rel_no_, next_component_part_.line_item_no, next_component_part_.part_no);
   END LOOP;   
END Release_Internal_Pur_Orders;

--   Get_Lot_Serial_For_Demand
--   Returns list of serial no, lot batch numbers and qty 
--   for a given demand order info used in transit delivery.
--   The out list includes records of serial^lot batch no^qty.
@UncheckedAccess
FUNCTION Get_Lot_Serial_For_Demand (
   demand_order_ref1_  IN VARCHAR2,
   demand_order_ref2_  IN VARCHAR2,
   demand_order_ref3_  IN VARCHAR2 ) RETURN CLOB
IS
   order_no_          VARCHAR2(12);
   line_no_           VARCHAR2(4);
   rel_no_            VARCHAR2(4);
   line_item_no_      NUMBER;
   customer_no_       VARCHAR2(20);
   contract_          VARCHAR2(5);
   lot_serial_clob_   CLOB;
   lot_serial_record_ VARCHAR2(2000);
   separator_         VARCHAR2(1) := Client_SYS.Text_Separator_;

   CURSOR get_co_info IS      
      SELECT order_no, line_no, rel_no, line_item_no, customer_no, contract 
      FROM   customer_order_line_tab
      WHERE  demand_order_ref1 = demand_order_ref1_
      AND    demand_order_ref2 = demand_order_ref2_
      AND    demand_order_ref3 = demand_order_ref3_;
   
   CURSOR get_lot_serial_intra_comp IS 
      SELECT serial_no, lot_batch_no, SUM(quantity) quantity,  part_ownership_db, owning_vendor_no 
      FROM   parts_delivered_not_received
      WHERE  NVL(order_no, order_no_)             = order_no_
      AND    NVL(line_no, line_no_)               = line_no_
      AND    NVL(rel_no, rel_no_)                 = rel_no_
      AND    NVL(line_item_no, line_item_no_)     = line_item_no_
      AND    NVL(po_order_no, demand_order_ref1_) = demand_order_ref1_
      AND    NVL(po_line_no, demand_order_ref2_)  = demand_order_ref2_
      AND    NVL(po_rel_no, demand_order_ref3_)   = demand_order_ref3_
      GROUP BY serial_no, lot_batch_no, part_ownership_db, owning_vendor_no HAVING SUM(quantity) > 0;
      
   CURSOR get_lot_serial_inter_comp IS 
      SELECT serial_no, lot_batch_no, SUM(quantity) quantity 
      FROM   parts_delivered_not_received
      WHERE  NVL(order_no, order_no_)             = order_no_
      AND    NVL(line_no, line_no_)               = line_no_
      AND    NVL(rel_no, rel_no_)                 = rel_no_
      AND    NVL(line_item_no, line_item_no_)     = line_item_no_
      AND    NVL(po_order_no, demand_order_ref1_) = demand_order_ref1_
      AND    NVL(po_line_no, demand_order_ref2_)  = demand_order_ref2_
      AND    NVL(po_rel_no, demand_order_ref3_)   = demand_order_ref3_
      GROUP BY serial_no, lot_batch_no HAVING SUM(quantity) > 0;
BEGIN   
   OPEN  get_co_info;  
   FETCH get_co_info INTO order_no_, line_no_, rel_no_, line_item_no_, customer_no_, contract_;
   CLOSE get_co_info;
   
   IF (Site_API.Get_Company(Cust_Ord_Customer_API.Get_Acquisition_Site(customer_no_)) = Site_API.Get_Company(contract_)) THEN
      -- Intersite Intra company
      FOR lot_serial_rec_ IN get_lot_serial_intra_comp LOOP
         lot_serial_record_ := lot_serial_rec_.serial_no || separator_ || 
                               lot_serial_rec_.lot_batch_no || separator_ || 
                               lot_serial_rec_.quantity || separator_ || 
                               lot_serial_rec_.part_ownership_db || separator_ || 
                               lot_serial_rec_.owning_vendor_no;

         IF lot_serial_clob_ IS NULL THEN
            lot_serial_clob_ := lot_serial_record_;
         ELSE
            lot_serial_clob_ := lot_serial_clob_ || Client_SYS.Field_Separator_ || lot_serial_record_;
         END IF;
      END LOOP;
   ELSE
      -- Intersite Inter company
      FOR lot_serial_rec_ IN get_lot_serial_inter_comp LOOP
         lot_serial_record_ := lot_serial_rec_.serial_no || separator_ || 
                               lot_serial_rec_.lot_batch_no || separator_ || 
                               lot_serial_rec_.quantity || separator_ || 
                               ''|| separator_ || 
                               '';

         IF lot_serial_clob_ IS NULL THEN
            lot_serial_clob_ := lot_serial_record_;
         ELSE
            lot_serial_clob_ := lot_serial_clob_ || Client_SYS.Field_Separator_ || lot_serial_record_;
         END IF;
      END LOOP;
   END IF;
   RETURN lot_serial_clob_;
END Get_Lot_Serial_For_Demand;

--   Get_Qty_To_Receive_For_Demand
--   This method returns a total available qty to receive 
--   for a given demand order info used in transit delivery.
@UncheckedAccess
FUNCTION Get_Qty_To_Receive_For_Demand (
   demand_order_ref1_  IN VARCHAR2,
   demand_order_ref2_  IN VARCHAR2,
   demand_order_ref3_  IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   part_ownership_db_  IN VARCHAR2, 
   owning_vendor_no_   IN VARCHAR2 ) RETURN NUMBER
IS 
   order_no_       VARCHAR2(12);
   line_no_        VARCHAR2(4);
   rel_no_         VARCHAR2(4);
   line_item_no_   NUMBER;
   qty_to_receive_ NUMBER := 0;
   co_qty_to_receive_ NUMBER := 0;

   -- Modified cursor to fetch quantity that is available for receipt from customer order side of the process
   CURSOR get_co_info IS      
      SELECT order_no, line_no, rel_no, line_item_no, (qty_shipped - qty_returned)
      FROM   customer_order_line_tab
      WHERE  demand_order_ref1 = demand_order_ref1_
      AND    demand_order_ref2 = demand_order_ref2_
      AND    demand_order_ref3 = demand_order_ref3_;
   
   CURSOR get_quantity IS 
      SELECT SUM(quantity) quantity
      FROM   parts_delivered_not_received
      WHERE  NVL(order_no, order_no_) = order_no_
      AND    NVL(line_no, line_no_)   = line_no_
      AND    NVL(rel_no, rel_no_)     = rel_no_
      AND    NVL(line_item_no, line_item_no_)      = line_item_no_
      AND    NVL(po_order_no, demand_order_ref1_)  = demand_order_ref1_
      AND    NVL(po_line_no, demand_order_ref2_)   = demand_order_ref2_
      AND    NVL(po_rel_no, demand_order_ref3_)    = demand_order_ref3_
      AND    lot_batch_no = lot_batch_no_
      AND    serial_no    = serial_no_
      AND    (part_ownership_db_ IS NULL OR part_ownership_db = part_ownership_db_)
      AND    (owning_vendor_no_  IS NULL OR owning_vendor_no  = owning_vendor_no_);
BEGIN
   OPEN  get_co_info;  
   FETCH get_co_info INTO order_no_, line_no_, rel_no_, line_item_no_, co_qty_to_receive_;
   CLOSE get_co_info;
   
   -- Seperated non-tracked parts related qty to be fetched from Customer order line 
   -- as the calling method of Get_Qty_To_Receive_For_Demand consists purchasing related qty.
   IF ( NVL(lot_batch_no_, '*') = '*' AND NVL(serial_no_, '*') = '*') THEN 
      qty_to_receive_ := co_qty_to_receive_;
   ELSE       
      OPEN get_quantity;
      FETCH get_quantity INTO qty_to_receive_;
      CLOSE get_quantity;
   END IF;
   
   RETURN NVL(qty_to_receive_, 0);
END Get_Qty_To_Receive_For_Demand;

--   Is_Serial_Lot_Delivered
--   This method returns a if a given serial/lot is deliverred by the supply site 
--   for a given demand order info used in transit delivery.
@UncheckedAccess
FUNCTION Is_Serial_Lot_Delivered (
   demand_order_ref1_  IN  VARCHAR2,
   demand_order_ref2_  IN  VARCHAR2,
   demand_order_ref3_  IN  VARCHAR2,
   lot_batch_no_       IN  VARCHAR2,
   serial_no_          IN  VARCHAR2 ) RETURN VARCHAR2
IS 
   order_no_       VARCHAR2(12);
   line_no_        VARCHAR2(4);
   rel_no_         VARCHAR2(4);
   line_item_no_   NUMBER;
   dummy_          NUMBER;

   CURSOR get_co_info IS      
       SELECT order_no, line_no, rel_no, line_item_no 
       FROM   customer_order_line_tab
       WHERE  demand_order_ref1 = demand_order_ref1_
       AND    demand_order_ref2 = demand_order_ref2_
       AND    demand_order_ref3 = demand_order_ref3_;
   
   CURSOR get_exist IS 
      SELECT 1
      FROM   parts_delivered_not_received
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    line_item_no = line_item_no_
      AND    lot_batch_no = lot_batch_no_
      AND    serial_no    = serial_no_;
BEGIN
   OPEN  get_co_info;  
   FETCH get_co_info INTO order_no_, line_no_, rel_no_, line_item_no_;
   CLOSE get_co_info;

   OPEN get_exist;
   FETCH get_exist INTO dummy_;
   IF (get_exist%FOUND) THEN
      CLOSE get_exist;  
      RETURN 'TRUE';      
   END IF;
   CLOSE get_exist;
   RETURN 'FALSE';
   
END Is_Serial_Lot_Delivered;

-------------------------------------------------------------
-- Purchase Order Arrival Rental ----------------------------
-------------------------------------------------------------
-- This method is used by DataCaptRegstrArrivals
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                IN VARCHAR2,
   po_order_no_             IN VARCHAR2,
   po_line_no_              IN VARCHAR2,
   po_rel_no_               IN VARCHAR2,
   part_ownership_db_       IN VARCHAR2,
   owning_vendor_no_        IN VARCHAR2,
   capture_session_id_      IN NUMBER,
   column_name_             IN VARCHAR2,
   lov_type_db_             IN VARCHAR2,
   sql_where_expression_    IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_       Get_Lov_Values;
   stmt_                 VARCHAR2(4000);
   TYPE Lov_Value_Tab    IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_        Lov_Value_Tab;
   second_column_name_   VARCHAR2(200);
   second_column_value_  VARCHAR2(200);
   lov_item_description_ VARCHAR2(200);
   session_rec_          Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_   NUMBER;
   exit_lov_             BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('RENTAL_PART_IN_TRANSIT_CC', column_name_);

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;

      stmt_ := stmt_  || ' FROM RENTAL_PART_IN_TRANSIT_CC
                           WHERE po_order_no                                     = NVL(:po_order_no_,          po_order_no)
                           AND   po_line_no                                      = NVL(:po_line_no_,           po_line_no)
                           AND   po_rel_no                                       = NVL(:po_rel_no_,            po_rel_no)
                           AND   part_ownership_db                               = NVL(:part_ownership_db_,    part_ownership_db)
                           AND   (NVL(owning_vendor_no, :string_null_)            = NVL(:owning_vendor_no_, :string_null_) OR :owning_vendor_no_ = ''%'')
                           AND   contract                                        = :contract_ ';
                           
      IF (sql_where_expression_ IS NOT NULL) THEN
       stmt_ := stmt_ || ' AND ' || sql_where_expression_;
      END IF;

      stmt_ := stmt_ || ' ORDER BY ' || column_name_ || ' ASC';
   
      @ApproveDynamicStatement(2015-06-26,RILASE)
      OPEN get_lov_values_ FOR stmt_ USING po_order_no_,
                                           po_line_no_,
                                           po_rel_no_,
                                           part_ownership_db_,
                                           string_null_,
                                           owning_vendor_no_,
                                           string_null_,
                                           owning_vendor_no_,
                                           contract_;
         
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            IF (column_name_ = 'PART_OWNERSHIP_DB') THEN
               Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                                capture_session_id_    => capture_session_id_,
                                                lov_item_value_        => Part_Ownership_API.Decode(lov_value_tab_(i)),
                                                lov_item_description_  => lov_item_description_,
                                                lov_row_limitation_    => lov_row_limitation_,    
                                                session_rec_           => session_rec_);
            ELSE
               Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                                capture_session_id_    => capture_session_id_,
                                                lov_item_value_        => lov_value_tab_(i),
                                                lov_item_description_  => lov_item_description_,
                                                lov_row_limitation_    => lov_row_limitation_,    
                                                session_rec_           => session_rec_);
            END IF;
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;
   

-- This method is used by DataCaptRegstrArrivals
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_                IN VARCHAR2,
   po_order_no_             IN VARCHAR2,
   po_line_no_              IN VARCHAR2,
   po_rel_no_               IN VARCHAR2,
   part_ownership_db_       IN VARCHAR2,
   owning_vendor_no_        IN VARCHAR2,
   column_name_             IN VARCHAR2,
   sql_where_expression_    IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                          VARCHAR2(2000);
   column_value_                  VARCHAR2(200);
   unique_column_value_           VARCHAR2(200);
BEGIN
   Assert_SYS.Assert_Is_View_Column('RENTAL_PART_IN_TRANSIT_CC', column_name_);
   stmt_ := 'SELECT ' || column_name_ || '
             FROM  RENTAL_PART_IN_TRANSIT_CC
             WHERE po_order_no                                     = NVL(:po_order_no_,       po_order_no)
               AND po_line_no                                      = NVL(:po_line_no_,        po_line_no)
               AND po_rel_no                                       = NVL(:po_rel_no_,         po_rel_no)
               AND part_ownership_db                               = NVL(:part_ownership_db_, part_ownership_db)
               AND (NVL(owning_vendor_no, :string_null_)           = NVL(:owning_vendor_no_, :string_null_) OR :owning_vendor_no_ = ''%'')
               AND contract                                        = :contract_ ';
   
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;

   @ApproveDynamicStatement(2015-06-29,RILASE)
   OPEN get_column_values_ FOR stmt_ USING po_order_no_,
                                           po_line_no_,
                                           po_rel_no_,
                                           part_ownership_db_,
                                           string_null_,
                                           owning_vendor_no_,
                                           string_null_,
                                           owning_vendor_no_,
                                           contract_;
   
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
         unique_column_value_ := NULL;
         EXIT;
      END IF;
   END LOOP;
   CLOSE get_column_values_;
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptRegstrArrivals
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_                IN VARCHAR2,
   po_order_no_             IN VARCHAR2,
   po_line_no_              IN VARCHAR2,
   po_rel_no_               IN VARCHAR2,
   part_ownership_db_       IN VARCHAR2,
   owning_vendor_no_        IN VARCHAR2,
   capture_session_id_      IN NUMBER,
   column_name_             IN VARCHAR2,
   column_value_            IN VARCHAR2,
   column_description_      IN VARCHAR2,
   sql_where_expression_    IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_           Check_Exist;
   stmt_                    VARCHAR2(2000);
   dummy_                   NUMBER;
   exist_                   BOOLEAN := FALSE;
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
   Assert_SYS.Assert_Is_View_Column('RENTAL_PART_IN_TRANSIT_CC', column_name_);

   stmt_ := ' SELECT 1
              FROM RENTAL_PART_IN_TRANSIT_CC
              WHERE po_order_no                                     = NVL(:po_order_no_,          po_order_no)
              AND   po_line_no                                      = NVL(:po_line_no_,           po_line_no)
              AND   po_rel_no                                       = NVL(:po_rel_no_,            po_rel_no)
              AND   part_ownership_db                               = NVL(:part_ownership_db_,    part_ownership_db)
              AND   (NVL(owning_vendor_no, :string_null_)           = NVL(:owning_vendor_no_, :string_null_) OR :owning_vendor_no_ = ''%'')
              AND   contract                                        = :contract_  
              AND   NVL(' || column_name_ || ', :string_null_)      = NVL(:column_value_, :string_null_)';
   
   IF (sql_where_expression_ IS NOT NULL) THEN
    stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;
   
   @ApproveDynamicStatement(2015-06-29,RILASE)
   OPEN exist_control_ FOR stmt_ USING po_order_no_,
                                       po_line_no_,
                                       po_rel_no_,
                                       part_ownership_db_,
                                       string_null_,
                                       owning_vendor_no_,
                                       string_null_,
                                       owning_vendor_no_,
                                       contract_,
                                       string_null_,
                                       column_value_,
                                       string_null_;
      
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
   END IF;
END Record_With_Column_Value_Exist;
