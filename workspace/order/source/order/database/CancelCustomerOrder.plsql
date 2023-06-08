-----------------------------------------------------------------------------
--
--  Logical unit: CancelCustomerOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220111  ShWtlk  MF21R2-6416, Cancel_Simple_Line___, Modified Cancel_Simple_Line___ to remove interim order headers created by neither reserver nor allocate option in capability check. 
--  211101  GISSLK  MF21R2-5854, Modify Cancel_Simple_Line___() to change Control_Ms_Mrp_Consumption() method call parameters.
--  211028  Amiflk  SC21R2-5479, Modified Pegged_Obj_Start_Operation___ procedure's Core layer method call into Pegged_Obj_Start_Operation___  for reducing the unwanted inner methods of non-overridden methods in generated plsql/plsvc files.   
--  210812  KiSalk  Bug 160396(SCZ-15899), Modified Cancel_Order_Line___ to restrict cancelling a co line if a pick list exists.
--  200827  AsZelk  Bug 154175 (SCZ-10262), Modified Cancel_Connected_Order_Line___ to avoid blank info message when cancelling the external customer order.
--  200527  ChWkLk  MF2020R1-417 ,Modified Cancel_Connected_Order_Line___() to use CroLineMaterialRoute to clear cro connected customer orders.
--  200527  ApWilk  Bug 153853 (SCZ-10069), Added a new method Handle_Staged_Billing___() and modified Cancel_Order_Line___(),Check_Package_Status___() to handle cancelling 
--  200527          of package component lines when the package part having an invoiced staged billing.
--  190704  MiKulk  SCUXXW4-22978, Added a new method Cancel_Order__ to be called from Aurena client Cancellation dialog and also from Unpegging.
--  190219  Cpeilk  Bug 145616 (SCZ-2382), Modified Cancel_Order_Line__, Cancel_Order__ to get the current_info_ stored in CO line when cancelling a CO line, CO header.
--  190106  UdGnlk  Bug 144611, Modified Cancel_Simple_Line___() to validate prepayment and added a parameter co_cancel_. Modified Cancel_Order___(), Cancel_Order_Line__()
--  190106          and Cancel_Order_Line() to introduce co_cancel_ to differentiate CO or COL cancellation. Added new parameter co_cancel_ Cancel_Order_Line___().      
--  181103  UdGnlk  Bug 143991, Modified Connected_Orders_Exist___() message PEG_CANC to add parameters to make it more meaningful.
--  180628  DiKuLk  Bug 142093, Modified Cancel_Connected_Order_Line___() to set demand code PI when a project is connected and shop order is closed.
--  180508  UdGnlk  Bug 141225, Modified Cancel_Order_Line___() to avoid the message INVSTAGEEXIST when unpeging for IPD supply code for stage billing invoice. 
--  180419  DiKuLk  Bug 140792, Modified Cancel_Simple_Line___() to convert supply code to 'Project Inventory' and stop removing project connection in customer order line 
--  180419          when unpegging customer order line in intersite customer order.
--  180202  AsZelk  STRSC-16366, Modified Cancel_Order___ in order to fix getting wrong message when Cancelling cancelled customer order.
--  180119  CKumlk  STRSC-15930, Modified Cancel_Order_Line___ by changing Get_State() to Get_Objstate().                       
--  170927  RaVdlk  STRSC-11152,Removed Customer_Order_API.Get_State__() and replaced with Customer_Order_API.Get_State ()
--  170927  RaVdlk  STRSC-11152,Removed Customer_Order_Line_API.Get_State__() and replaced with Customer_Order_Line_API.Get_State ()
--  170922  Cpeilk  Bug 135315, Modified Cancel_Simple_Line___() and Cancel_Order_Line___() by adding a parameter unpeg_ipd_flag_. Modified Cancel_Simple_Line___() 
--  170922          so that customer order line is cancelled in the direct delivery flow when line is unpeg.
--  170131  MaEelk  LIM-10488, passed inventory_ivent_id_ to Customer_Order_Reservation_API.Remove
--  160926  MadGLk  STRSA-12957, Modified Cancel_Order_Line__()added new Alertbox to select whether to cancel service request lines as well when cancelling a customer order line.  
--  160831  DilMlk  Bug 131048, Modified method Cancel_Simple_Line___ by changing value of parameter activity_seq to 0 when call method Reserve_Customer_Order_API.Control_Ms_Mrp_Consumption()
--  160629  TiRalk  STRSC-2702, Modified Cancel_Order___ by changing state from CreditBlocked to Blocked.
--  160602  MeAblk  Bug 129590, Modified Cancel_Connected_Order_Line___ to avoid updating shop order when there no shop order has been created.
--  160512  ChJalk  Bug 128646, Modified Check_Package_Status___ to remove the connected charge lines when cancelling a package part component.
--  160328  PrYaLK  Bug 127992, Modified Cancel_Connected_Order_Line___() by including Received state of a purchase order since the pegged object cannot be updated
--  160328          in PO Received state as well.
--  151215  RoJalk  LIM-5387, Added source ref type to Shipment_Line_API.Remove_Active_Shipments method.
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151106  Maeelk  LIM-4453, Removed pallet_id_ from Customer_Order_Reservation_API calls
--  151106  Chfose  LIM-4454/LIM-4455, Removed pallet_id from code related to CO_SUPPLY_SITE_RESERVATION & SOURCE_CO_SUPPLY_SITE_RES.
--  151105  UdGnlk  LIM-3746, Removed Inventory_Part_Loc_Pallet_API method calls since INVENTORY_PART_LOC_PALLET_TAB will be obsolete. 
--  151009  RasDlk  Bug 124704, Modified Cancel_Simple_Line___ by adding a condition to check whether the component 'EXPCTR' is installed. 
--  150916  RasDlk  Bug 124200, Modified Cancel_Simple_Line___ to set the export license order event as 'Canceled' when cancelling an order line.
--  150916          Moved the correction done by bug 120649 to Cancel_Simple_Line___.
--  150817  RasDlk  Bug 120649, Modified Cancel_Order_Line___ to fetch the licensed_order_type_ correctly.
--  150723  JeeJlk  Bug 122851, Modified Cancel_Connected_Order_Line___ to send null when cancel reason is not set.
--  150423  Chfose  LIM-1781, Added missing handling_unit_id parameter to Customer_Order_Reservation_API.Remove.
--  150420  UdGnlk  LIM-142, Added handling_unit_id as new key column to Co_Supply_Site_Reservation_Tab therefore did necessary changes.
--  150416  MaEelk  LIM-1057, Added dummy parameter handling_unit_id_ 0 to the Inventory_Part_In_Stock_API and Inventory_Part_Loc_Pallet_API.
--  150214  ShKolk  EAP-804, Modified Cancel_Order_Line___() to call Consolidate_Grouped_Charges() instead of Calc_Consolidate_Charges() to consolidate only the affected group.
--  150210  NISMLK  PRMF-5064, Modified Cancel_Connected_Order_Line___(), Cleared CO Exchange Line information if CO line was created by a Component Repair Order Exchange Line.
--  150209  Chfose  PRSC-5657, Added call to Customer_Order_Transfer_API.Get_Auto_Change_Approval_User and order_type check in Int_Cust_Ord_Line_State_Check to properly show the warning 
--  150209          when cancelling from purchase order, not having executing of order changes online or having a manual approval of changes.
--  150208  MAHPLK  PRSC-5825, Modified the parameter list (remove send_from_co_) of Purchase_Order_Transfer_API.Send_Order_Change in Cancel_Connected_Order_Line___().
--  150207  SBalLK  Bug 120209, Modified Int_Cust_Ord_Line_State_Check() method to raise warnning message when cancel the purchase order where pegged customer order is proccess beyond the 'Reserved' state.
--  150123  ThImlk  Bug 120704, Modified Cancel_Connected_Order_Line___() to remove customer order references from the shop orde, when the supply_code_db_ is 'SO' and if that shop order is closed.
--  141211  ErFelk  Bug 120180, Modified Cancel_Order_Line__() by changing the head_state to head_objstate_ and change the method call to get the 
--  141211          Customer Order Objstate instead of the translated state.
--  141211  MAHPLK  PRSC-4493, Modified the parameter list of Purchase_Order_Transfer_API.Send_Order_Change in Cancel_Connected_Order_Line___().
--  141125  MalLlk  Bug 119885, Modified Int_Cust_Ord_Line_State_Check() to use the decode value of CO line state in a warning message.
--  141015  KiSalk  Bug 119040, Modified Cancel_Simple_Line___ to call Project_Connection_Util_API.Cancel_Connection after Cancel_Connected_Order_Line___ and making Qty_On_Order 0,
--  141015          because Dop_Demand_Cust_Ord_API.Unpeg__ which is called later need activity_sequence of CO line and Customer_Order_Line_API.Validate_Proj_Disconnect___ raises error if Qty_On_Order > 0.    
--  140919  NaLrlk  Modified Pegged_Obj_Start_Operation___(), Int_Cust_Ord_Line_State_Check() to consider IPT_RO demand_code for replacement rental.
--  140701  ChFolk  Added new method Pegged_Obj_Start_Operation___ and used in Cancel_Order_Line___ when cancelling the external CO line.
--  140604  NaLrlk  Modified Cancel_Order_Line___ to consider the on rental period when cancellation.
--  140527  Chsllk  Modified Cancel_Simple_Line___ to call Cancel_Mobilization_Wo in Active_Separate_API instead of create_rental_wo when cancelling mobilization work orders.
--  140523  Chsllk  Modified Cancel_Simple_Line___ to cancel the connected mobilization work orders when a rental customer order line is cancelled.
--  140513  JeLise  PBSC-9230, Moved the call to Cancel_Order_If_Obsolete___ to the end of the method Cancel_Order_Line___.
--  140422  KiSalk  Bug 111264, Modified Cancel_Order___ and Cancel_Package___ to send one change request per internal PO of the PO connected lines.
--  140325  AndDse  PBMF-4700, Merged in LCS bug 113040, Modified Cancel_Simple_Line___() to pass order_line_cancellation_ parameter to the call Reserve_Customer_Order_API.Control_Ms_Mrp_Consumption().
--  140321  KiSalk  Bug 114220, Added public method Cancel_Simple_Line, a public interface to Cancel_Simple_Line___ to be called from PCM.
--  140305  KiSalk  Bug 114804, Moved clearing info in Cancel_Order__ to Cancel_Order___ and moved info handling from Cancel_Order___ to Customer_Order_API.Set_Cancelled.
--  140220  PraWlk  Modified Int_Cust_Ord_Line_State_Check() to re-structure the warning message COLSTATEVALIDATE as the default selection goes with yes.
--  131227  MaEdlk  Bug 114531, Moved 'Order_Line_Commission_API.Cancel_Order_Commission_Lines' in Cancel_Simple_Line___() to 'Customer_Order_Line_API.Set_Cancelled'.
--  130925  AyAmlk  Bug 110034, Modified Cancel_Order_Line__() to prevent carry forward the info messages from previous transactions in the
--  130925          current_info_ global variable defined in the Customer_Order_Line_API.
--  130902  VISALK  Bug 112121, Modified Cancel_Connected_Order_Line___() to pass the parameter value as demand_order_ref4 instead of demand_order_ref3 to Srv_Sales_Lines_API.Undo_Transfer().
--  130827  IsSalk  Bug 112056, Modified method Cancel_Order___() to close the Open Cursor check_exist which was not closed within the method.
--  130731  HimRlk  Removed Int_Cust_Ord_Line_Delivered___(). Added new public method Int_Cust_Ord_Line_State_Check(), which validate customer order line states for
--  130731          several levels and returns a message.
--  130703  MaIklk  TIBE-947, Removed global constants and used conditional compilation instead.
--  130408  IsSalk  Bug 109340, Modified Cancel_Connected_Order_Line___ to remove customer order purchase order connection when cancelling
--  130408          the CO for both replicate YES and NO occurrences.
--  130214  Dinklk  EIGHTBALL, Modified Cancel_Simple_Line___ to call Cro_Exchange_Util_API.Co_Line_Canceled if demand code is CRE.
--  130129  RuLiLk  Bug 106274 Modified method Cancel_Order_Line___(). Freight Charge lines should be consolidated,   
--  130129          when a CO line get canceled. (Not applied to planned state CO headers)
--  121031  RoJalk  Allow connecting a customer order line to several shipment lines - modified Cancel_Simple_Line___  and passed shipment_id to the method Customer_Order_Reservation_API.Remove.
--  121016  GiSalk  Bug 105492, Modified Cancel_Order___ by calling Customer_Order_Flow_API.Check_No_Previous_Execution() before cancelling the order.
--  120708  RoJalk  Modified Cancel_Order_Line___ and called Shipment_Order_Line_API.Remove_Active_Shipments since one order line can have multiple shipments connected.
--  120221  IsSalk  Bug 101107, Modified Cancel_Connected_Order_Line___ to allow unpegging for purchase type 'R' when cancelling the CO header/line and for replicate changes NO.
--  111102  AwWeLK  Bug 99661, Modified Cancel_Connected_Order_Line___ to stop the unpegging for supply codes IPD,PD when cancelling the CO header/line and for replicate changes NO.
--  111012  MaMalk  Modified Cancel_Package___ and Cancel_Simple_Line___ to change the order of the line setting to Cancelled and modifying the activitiy_seq to null.
--  110902  SudJlk  Bug 98653, Modified Cancel_Order_Line___ to stop cancelling of Co lines originated from work orders and service contracts and to remove encoding of demand code values.. 
--  110602  AmPalk  Bug 95338, Modified method Cancel_Order___ by adding new method call On_Account_Ledger_Item_API.Remove_Cust_Order_Ref() to remove any connected payments.    
--  110514  MaMalk  Modified Cancel_Connected_Order_Line___ to correct the paramers passed to method Shop_Ord_Util_API.Modify_Cust_Ord_Details.
--  110224  MaRalk  Modified Cancel_Simple_Line___ and Cancel_Connected_Order_Line___ methods.
--  110214  MaMalk  Bug 95657, Modified methods Cancel_Simple_Line___ and Cancel_Package___ by removing the check for the demand codes.
--  110106  MaEelk  Modified Cancel_Order_Line___ to send a call to Srv_Sales_Lines to change the 
--  110106          Srv Sales Line back to Invoiceable state.
--  101207  SaLalk  Modified Cancel_Connected_Order_Line___() and Cancel_Simple_Line___().
--  101206  RoJalk  Added the methods Check_Project_Baseline__, Remove_Project_Rev_Conn__.
--  100511  RoJalk  Added the global variable inst_ProjectConnectionUtil_. Added method Check_Project_Baseline__ to 
--  100308          handle the project connection removal for baseline projects.
--  100713  ChFolk  Removed calls for Customer_Order_API.Modify_Calc_Disc_Bonus_Flag as bonus functionality is obsoleted.
--  100512  Ajpelk  Merge rose method documentation
--  100429  NuVelk  Merged TwinPeaks
--  101026  NiDalk  Bug 93740, Removed project connection from package part header when cancelling the order.
--  100718  CwIclk  Bug 91481, Modified method Cancel_Simple_Line___ to allow supply codes IPD and IPT for conditions checked when calling 
--  100718          method Reserve_Customer_Order_API.Control_Ms_Mrp_Consumption.
--  100325  ErFelk  Bug 89346, Modified method Cancel_Simple_Line___ by adding demand code 'PO' to one of the conditions so that the Project Connection can be removed. 
--  100205  Castse  Bug 87918, Modified method Cancel_Order_Line to retrieve the value for change_req_flag_ from supplier.
--  080318  RoJalk  Modified the method call Shop_Order_Int_API.Modify_Cust_Ord_Details inside
--  080318          Cancel_Connected_Order_Line___ to pass the null values for project_id_ and activity_seq_.
--  100114  KAYOLK  Replaced the obsolete usages of Shop_Order_Int_API calls to other relevant methods.
--  091224  MaEelk  Replaced the call Interim_Order_Int_API.Remove_Interim_Head_By_Usage with Interim_Demand_Head_API.Remove_Interim_Head_By_Usage.
--  091124  MaRalk  Removed language dependant global variable pkg_info_. Added OUT parameter pkg_info_ to Cancel_Order_Line___ and modify the places where it is calling.
--  091124          Modified methods Cancel_Order___, Cancel_Order_Line__ and Cancel_Order_Line.
--  090930  MaMalk  Modified Int_Cust_Ord_Line_Delivered___, Check_Package_Status___, Package_Pick_Planned___, Cancel_Package___ and Cancel_Order_Line___ to remove unused code.
--  --------------14.0.0-------------------------------------------------------
--  090824  ChJalk  Bug 75274, Modified the method Cancel_Connected_Order_Line___ to check whether there is a pegged qty before updating a connected order.
--  090626  DaGulk  Bug 84232, Modified the variable length of media_code_ to VARCHAR2(30) in method Cancel_Connected_Order_Line___.
--  090610  DaGulk  Bug 83694, Modified method Cancel_Order___ to check whether there any picklist exists when the order is in Reserved state.
--  090528  SudJlk  Bug 80756, Modified method Cancel_Order___ to allow cancellation of orders in Reserved state if no picklist is created. 
--  090512  NWeelk  Bug 81195, Modified the procedure Cancel_Order_Line___ to remove the connected charge lines, when cancelling the customer order and
--  090512          added procedure Remove_Charge_Lines___.
--  090130  SudJlk  Bug 76805, Modified the method call to Reserve_Customer_Order_API.Control_Ms_Mrp_Consumption in Cancel_Simple_Line___.
--  080805  MaRalk  Bug 73839, Renamed Int_Cust_Ord_Delivered and Int_Cust_Ord_Delivered___ as Int_Cust_Ord_Line_Delivered and Int_Cust_Ord_Line_Delivered___ respectively.
--  080805          Added function Int_Cust_Ord_Delivered. 
--  080815  MaJalk  Modified Cancel_Order_Line___ to move CO charge logic to Customer_Order_Charge_Util_API.
--  080808  MaJalk  Modified cursor get_record at Cancel_Order_Line___.
--  080804  MaJalk  Modified Cancel_Order_Line___ to remove CO charge line when cancelling the CO line.
--  080522  SuJalk  Bug 72836, Added DOP to the IF condition before the call to Serial_No_Reservation_API.Delete_Reserved in Cancel_Simple_Line___.
--  080405  MaRalk  Bug 72388, Modified procedure Cancel_Connected_Order_Line___ to remove the CO/SO connection for both Replication choice is No or Yes.
--  080227  LaBolk  Bug 70620, Converted Int_Cust_Ord_Delivered into an implementation method and added method Int_Cust_Ord_Delivered.
--  080203  LaBolk  Bug 69512, Added function Int_Cust_Ord_Delivered. Removed info handling added by bug 56825.
--  071127  SaJjlk  Bug 69264, Modified method Cancel_Simple_Line___ to allow supply codes PD and PT for conditions checked when calling 
--  071127          method Reserve_Customer_Order_API.Control_Ms_Mrp_Consumption.
--  070521  MiKulk  Bug 61765, Modified Cancel_Simple_Line___ by changing the Control_Ms_Mrp_Consumption__ as public method call.
--  070514  NaLrlk  Modified the method Cancel_Order_Line__.
--  070425  WaJalk  Bug 64528, Modified method Cancel_Connected_Order_Line___.
--  070327  IsAnlk  Modifed Check_Package_Status___ to update qty_assigned for the package parts.
--  070206  Cpeilk  Bug 62342, Modified Cancel_Order_Line___, Check_Package_Status___ to avoid modifying calc_disc_bonus_flag when a package component is cancelled.
--  070125  SaJjlk  Replaced method call to Shipment_Order_Line_API.Get_Shipment_Id with Shipment_Order_Line_API.Get_Active_Shipment_Id.
--  070110  KaDilk  LCS Merge 58965, Modified Cancel_Order_Line__ and Cancel_Order__.  
--  060531  KanGlk  Bug 56825, Modified Cancel_Connected_Order_Line___ so client info is not swallowed
--  060531          after Purchasing has been called.
--  060524  MiKulk  Changed the coding to remove LU dependancy for deployment order.
--  --------------13.4.0-------------------------------------------------------
--  060125  JaJalk  Added Assert safe annotation.
--  060118  IsAnlk  Modified Purchase_Util_API.Unpeg_Order as Purchase_Order_Line_Part_API.Unpeg_Order.
--  060106  RaSilk  Modified IF condition to call Cancel_Connected_Order_Line___ in method Cancel_Simple_Line___.
--  051007  GaSolk  Bug 53712, Made the call Deliver_Package_If_Complete__ public.
--  050929  DaZase  Added configuration_id/activity_seq in calls to Inventory_Part_Loc_Pallet_API methods.
--  050921  DaZase  Added activity_seq to calls to Inventory_Part_In_Stock_API.Reserve_Part, Sourced_Co_Supply_Site_Res_API.Remove and Co_Supply_Site_Reservation_API.Remove in method Cancel_Simple_Line___.
--  050920  NaLrlk  Removed Unused variables.
--  050818  NaLrlk  Bug 126266 Removed the method calls Purchase_Order_Line_Part_API.Modify_Qty_On_Order(..) , Customer_Order_Pur_Order_API.Modify(..) and
--  050818          added the call Customer_Order_Pur_Order_API.Remove(..) when CO is pegged with PO/PR and replicate_change_ is FALSE. Added the call 
--  050818          Customer_Order_Shop_Order_API.Remove_Cancelled_Order(..) when CO is pegged with SO and replicate_change_ is FALSE in the Cancel_Connected_Order_Line___.
--  050719  NaWalk  Modify the code to Make the call to CO line Modify_Activity_Seq before Cancelling the CO Line.
--  050628  MiKulk  Bug 51740, Modified the method Cancel_Simple_Line___ to consider the supply codes SO and DOP when unconsuming the cancelled Qty.
--  050620  JaBalk  Changed the CANCELDOFIRST message text.
--  050613  NaLrLk  Changed the stmt_ variable size into VARCHAR2(2000) and modified the Dynamic call in Cancel_Simple_Line___
--  050609  NaWalk  Changed the method call to Get_Shipment_Connected to Get_Shipment_Connected_Db.
--  050519  SaJjlk  Modified method Cancel_Order_Line___ to remove shipment connection when cancelling order lines.
--  050517  NaLrLk  Removed the unneed server call (Dop_Demand_Gen_API.Modify_Dop_Qty) in Cancel_Connected_Order_Line___ for DOP order.
--  050510  NiRulk  Bug 51100, Modified Cancel_Order_Line___ to delete connected staged billing lines if none of the lines are 'Invoiced'.
--  050429  NaLrlk  Modify the method Cancel_Connected_Order_Line___ when supply_code_db_ id 'DOP'.
--  050428  NaLrLk  Added Dynamic Call in the method Cancel_Connected_Order_Line___ when supply_code_db_ in 'PD', 'PT', 'IPD', 'IPT' and replicate_change_ is FALSE.
--  050322  JaJalk  Modified the method Cancel_Order_Line___ to restrict the cancerlation if the order is originated from a DO.
--  050322  JaJalk  Modified the Cancel_Order_Line___ to make possible to cancel the order header if the line is originated
--  050322          by a distribution order. Satisfied that the order does not has any more uncancelled lines as the CO is no longer 
--  050322          useful if the corresponding DO is cancelled.
--  050306  VeMolk  Bug 49684, Modified Cancel_Simple_Line___ and reversed the correction of the bug 46826 
--  050306          in this method. Modified Cancel_Connected_Order_Line___ to update the QTY_ON_ORDER to zero  
--  050306          in all the connected orders and in the connection tables. 
--  050304  JICE    Bug 49626, Cancel reason sent to connected exchange order lines.
--  050304  JICE    Bug 49626, Cancel reason sent to connected purchase order lines.
--  050224  JICE    Bug 49626, Added handling of cancel reasons on package structures.
--  050203  GeKalk  Modified Cancel_Order_Line___ to pass the correct distribution order no.
--  050131  DaZase  Added a call to Customer_Order_Line_API.Clear_Ctp_Planned in Cancel_Simple_Line___.
--  050117  DaZase  Modified Cancel_Simple_Line___ so when its ctp_planned row it calls Interim_Ctp_Manager_API.Cancel_Ctp.
--  041112  DiVelk  Modified Cancel_Simple_Line___.
--  041029  ChJalk  Bug 47613, Modified PROCEDURE Cancel_Order_Line___, to check whether there are connected charge lines.
--  041028  DiVelk  Modified Connected_Orders_Exist___ and Cancel_Simple_Line___.
--  041014  SaJjlk  Added parameter catch_quantity_ to method calls Inventory_Part_In_Stock_API.Reserve_Part.
--  041014  LaBolk  Bug 46826, Modified Cancel_Simple_Line___, inter-changed code lines to stop errors. Removed unused variables.
--  041014          Modified Cancel_Connected_Order_Line___ to remove code that deletes records in connection tables.
--  041011  DaZase  Modified Cancel_Simple_Line___ so Project Inventory unreservations for normal reservations works.
--  040929  DaZase  Added activity_seq to call Customer_Order_Reservation_API.Remove.
--  040914  MaEelk  Removed the activity_seq when cancelling a customer order line.
--  040907          Modified Cancel_Simple_Line___.
--  040907  MaEelk  Removed a project connection when cancelling a customer order line.
--  040907          Modified Cancel_Simple_Line___.
--  040820  SaRalk  Bug 46539, Moved the code for checking invoiced stages from procedure Cancel_Simple_Line___ to Cancel_Order_Line___. 
--  040802  JaBalk  Modified the Cancel_Order___ to stop the error WRONGSTATE. 
--  040723  MaMalk  Bug 45507, Modified method Cancel_Connected_Order_Line___ in order to update qty_on_order in shop order and remove the 
--  040723          connetion between the shop order and the customer order line when the customer order line is cancelled. 
--  040714  SaNalk  Modified Cancel_Simple_Line___ to update cost and progress of the project connected customer order lines.
--  040618  NaWalk  Made cancelling possible in CO created from Do ,Only when DO status is stopped.
--  040510  DaZaSe  Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods, 
--                  the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  040209  GaJalk  Bug 42491, Merged Touch Down code.
--  040203  GeKalk  Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  040127  WaJalk  Bug 40079, Added an info message for SO lines in Cancel_Simple_Line___, added a new global variable and a cursor 
--  040127          to check pkg component lines in Cancel_Package___, modified Cancel_Order_Line___ and Cancel_Order_Line__,  
--  040127          added a new cursor in Cancel_Order__ to check if connected shop orders exist.
--  031110  PrInLk  Modified the method Cancel_Simple_Line___ to enable pegging of cancellation.
--  031106  JaJalk  Modified the method Cancel_Simple_Line___.
--  031003  NuFilk  Modified Connected_Orders_Exist___ removed error message 'Unable to cancel. Receipts for the connected purchase order line is already made'.
--  030909  DaZa    Fixed unreserve handling in Cancel_Simple_Line___ for Supply Chain Reservations and Sourced Reservations.
--  030901  ChBalk  CR Merged 02.
--  030828  CaRase  Add call to Inventory_Part_In_Stock_API.Reserve_Part and add cursor get_sourced_reservations to decrese Qty Reserved in Inventory_Part_In_Stock when
--                  one Co Line is cancelled.This is performed for normal and pallet parts and for normal and pallet parts on sourced lines.
--  030822  UdGnlk  Performed CR Merge and removed Default null parameters in implementation methods Cancel_Order___ ,Cancel_Order_Line___ ,
--                  Cancel_Package___ ,Cancel_Simple_Line___ and private methods Cancel_Order__,Cancel_Order_Line__. 
--  030813  NuFilk  Bug Fix, Removed Obsolete information message.
--  030812  WaJalk  Modified method Cancel_Connected_Order_Line___.
--  030806  WaJalk  Modified method Cancel_Connected_Order_Line___.
--  030805  WaJalk  Modified method Cancel_Connected_Order_Line___ to give a meaningful error message when pegged object is not updatable.
--  030805  NuFilk  Modified method Cancel_Connected_Order_Line to work according to specification for Shop orders.
--  030724  NuFilk  Modified method Cancel_Simple_Line___ to consider Sourced Lines also.
--  030716  NuFilk  Modified code in Cancel_Connected_Order_Line___ method.
--  030619  NuFilk  Added Cancel_Connected_Order_Line method, Added replicate_change_ and change_req_flag_ 
--  030619          parameters to methods.
--  030612  DaZa    Added extra NULL parameter in call to Is_Supply_Chain_Reservation.
--  030416  DaZa    Added removal of supply chain reservations in method Cancel_Simple_Line___.
--  **************** CR Merge *************************************************
--  030804  UdGnlk  Reversed the changes that have been done for Advance Payment by modifying method Cancel_Simple_Line___.
--  030729  UdGnlk  Performed SP4 Merge.
--  030625  GeKalk  Modified Cancel_Simple_Line__ and removed method Cancel_Exchange_Order___().
--  030612  GeKalk  Modified Cancel_Simple_Line__ method to call method Cancel_Exchange_Order___().
--  030609  GeKalk  Modified method Cancel_Exchange_Order___().
--  030609  GeKalk  Added new method Cancel_Exchange_Order___().
--  030526  SaAblk  Removed references to obsolete LU CustomerOrderOption
--  030409  GeKaLk  Done code review modifications.
--  030403  GeKaLk  Modified Connected_Orders_Exist___() to change the constant of the error message formanually pegged lines.
--  030401  GeKaLk  Modified Connected_Orders_Exist___() to check for manually pegged lines.
--  030331  GeKaLk  Modified Connected_Orders_Exist___() to check for manually pegged lines.
--  030212  AjShlk  Modified Cancel_Simple_Line___() to check Advance Invoiced Lines.
--  030114  LoPrlk  Bug 34738, Internal Customer order (Transite and Direct) were added to checks in the method Cancel_Simple_Line___.
--  030114          In method Cancel_Order___ calling place of Customer_Order_API.Set_Cancelled was altered.
--  020627  IsWilk  Bug 23920, removed the cursor get_notconnected_charges in the PROCEDURE Cancel_Order_Line___
--  020627          and modified the PROCEDURE Cancel_Order___.
--  020520  MIGUUS  Bug 29952, Moved info_ from inside of get_lines to outside in PROC Cancel_Order___
--                  since it's getting too big inside the loop.
--  020320  GaJalk  Call Id 74379, Modified the procedure Cancel_Order_Line___.
--  020226  GaJalk  Bug fix 26284, Added procedure Cancel_Order_If_Obsolete___. Modified procedure Cancel_Order_Line__.
--  011011  JakHse  Bug fix 23920, Removed condition for cancelling order head in Cancel_Order___
--  011011  JSAnse  Bug fix 19104, Removed previous corrections in the bug, bug fix in PurOrderCustOrderComp.apy.
--  010910  GaJalk  Bug fix 24228, Closed the cursor get_rma_line inside an IF statement.
--  010829  JakHse  Bug fix 23920, Removed logic for cancelling orders when last line gets cancelled. Removed Cancel_Order_If_Obsolete___
--  010720  ViPalk  Bug fix 19701, Added a new function Connected_To_Shop_Order.
--  010524  ViPalk  Bug fix 19701, Removed the part corresponding to Shop Order from Procedure Connected_Orders_Exist___.
--  010413  JaBa    Bug Fix 20598, Added new global lu constants and used those in necessary places.
--  010322  GaJalk  Bug fix 19104, Modified the procedure Cancel_Order___ by adding a cursor to get the rma_line_no.
--  001123  FBen  Added call to CUSTOMER_ORDER_LINE_API.Recalc_Package_Structure__ in Cancel_Order_Line___ in order to
--                get right amount to credit to customer in RMA, when returning package part with cancelled lines.
--  001117  DaZa  Added check on ctp_planned flag in method Cancel_Simple_Line___.
--  001114  JoAn  Bug Id 16754 Do not cancel order header when a line is cancelled if
--                the order was created by Customer Scheduling.
--                Corrected in Cancel_Order_Line___
--  001020  JakH  Changed reserve call to inventory_part_in_stock and added configuration id in call to customer_order_reservation
--  001005  JakH  Changed calls to Config_Spec_Usage to call Interim_Order_Int
--  001005  JoEd  Bug fix 17459. Modified cursor get_planned in Package_Pick_Planned___.
--                Modified cursor get_qty_reservations in Cancel_Simple_Line___.
--                Modified cursor get_package_structure in Cancel_Package___.
--  000913  FBen  Added UNDEFINE.
--  000906  JakH  Changed call to Inventory_Part_API.Get_Forecast_Consumption_Flag to _db-version
--                removed references to order-state 'Quoted' since it is nolonger present.
--  000719  LIN   Added cancel of configuration usage and interim order in Cancel_Simple_Line___
--  000713  LIN   Added Modify_Char_Price
--  000425  BRO   Added cancel of commissions in Cancel_Simple_Line___
--  -------------------------- 12.10 -----------------------------------------
--  000606  JoEd  Bug fix 16101, Added OUT parameter info_ to Cancel_Order__ and
--                Cancel_Order_Line__.
--                Changed so that po_order_no_, po_line_no_ and po_rel_no_ is used instead
--                of order_no_, line_no_ and rel_no_ in call to Purchase_Req_Util_API.Line_Instance_Exists.
--                Also added check on found_, all this in Cancel_Simple_Line___.
--  000606  JoAn  Bug Id 16411 If shortage records exist they will be removed
--                when line is cancelled. Corrected in Cancel_Simple_Line___
--  000425  PaLj  Changed check for installed logical units. A check is made when API is instantiatet.
--                See beginning of api-file.
--  000303  PaLj  CID 34705. Added check for invoiced stages when cancelling line.
--  000222  PaLj  Bug fix 12639 = CID 29115. Moved an IF statement in Cancel_Simple_Line___.
--  000210  PaLj  Bug fix 13030 = CID 29520. , Added cursor get_qty_reservations and
--                IF condition to check whether the Qty_Reserved is Zero or not in Cancel_Simple_Line___.
--  000114  DaZa  Bug fix 13018 - Modified Connected_Orders_Exist___.
--  --------------------------- 12.0 ----------------------------------------
--  991101  JoEd  Added Cancel of DOP orders in Cancel_Order_Line___.
--  --------------------------- 11.1 ----------------------------------------
--  990503  JoAn  Passing DB values in calls to Serial_No_Reservation_API.
--  990422  RaKu  Y.Cleanup.
--  990415  JakH  Y.In Cancel_Simple_Line___ make use of public-rec from ordrow.
--  990412  JoEd  Y.Call id 13985: Making use of PK for CUSTOMER_ORDER_RESERVATION
--                instead of IX in Cancel_Simple_Line___.
--  990409  JakH  Use of tables instead of views.
--  990406  JakH  Y.CID 10582 Removed use of Gen_Def_Key_value. use '*' where possible.
--  990319  JICE  Order line keys removed from call to Control_Ms_Mrp_Consumption__,
--                unconsuming forecast for options by removing them on cancel.
--  990316  JoAn  Unreserve_Pallet called when cancelling a line with pallet
--                reservations.
--  990312  JoAn  CID 12382 When trying to cancel whats already cancelled
--                no error message should be displayed.
--                Corrected in Cancel_Order___ and Cancel_Order_Line___.
--  990208  RaKu  Added logic for removing reserved serials when cancel of
--                an order line is made. Changed in Cancel_Simple_Line___.
--  990205  PaLj  Bug fix 7970/5745.  Added a condition before checking for the Connected_Orders.
--                Modification was done in Connected_Orders_Exist___.
--  990128  JICE  Order line keys added to call to Control_Ms_Mrp_Consumption__
--                in Reserve_Customer_Order_API.
--  990114  JoAn  Added methods Cancel_Order and Cancle_Order___.
--  981007  JoAn  Added call to Control_Ms_Mrp_Consumtion__ in Cancel_Simple_Line___
--  971126  ASBE  Bug 2373 Switched order of calls in procedure
--                Cancel_Simple_Line.
--  980225  JoAn  Added method Cancel_Order_Line.
--                Changed Cancel_Order_Line___ and Cancel_Simple_Line___ in order
--                to allow cancellation of a reserved line when pick list has not
--                been created.
--  971201  JoAn  Bug 2373 Corrected Cancel_Simple_Line___.
--                Line cancelled before attributes are modified.
--  971120  RaKu  Changed to FND200 Templates.
--  971029  JoAn  Changed error message in Connected_Orders_Exist___
--  971006  JoAn  Changed Check_Package_Status___.
--  971003  JoAn  Bug 97-0123 Made it possible to cancel quoted orders.
--                Corrected in Cancel_Simple_Line___.
--  970528  JOED  Changed call Instance_Exists to Line_Instance_Exists and
--                also changed package name.
--  970526  JoAn  Cancel_Order__ added check for objstate before cancelling order.
--  970429  JoAn  Using Customer_Order_Set_Line_Cancelled to cancel order lines
--  970428  RaKu  Added pallet_id in calls to customer_order_reservation.
--  970422  JoAn  Removed all references to status_code.
--  961210  JoAn  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Cancel_Order_If_Obsolete___ (
   order_no_ IN VARCHAR2 )
IS
   found_ NUMBER := 1;

   CURSOR get_uncancelled IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    rowstate != 'Cancelled';
BEGIN
   OPEN get_uncancelled;
   FETCH get_uncancelled INTO found_;
   IF (get_uncancelled%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE get_uncancelled;
   IF (found_ = 0) THEN
      Customer_Order_API.Set_Cancelled(order_no_);
   END IF;
END Cancel_Order_If_Obsolete___;


-- Connected_Orders_Exist___
--   Check if the given order line has connected purchase or shop orders.
--   If connected orders are found a call to Error_SYS is made.
PROCEDURE Connected_Orders_Exist___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   line_rec_ CUSTOMER_ORDER_LINE_API.Public_Rec;
BEGIN
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   
   -- Note: If the supply_code is 'IO' or 'PS' and qty_on_order > 0  then there exist a connected record in customer_order_pur_order_tab.
   IF (line_rec_.supply_code IN ('IO','PS') AND line_rec_.qty_on_order > 0) THEN
      Error_SYS.Record_General(lu_name_, 'PEG_CANC: There are manual peggings connected to customer order line :P1 - :P2. Remove the pegging first, then cancel the customer order line.',line_no_, rel_no_ );
   END IF;
END Connected_Orders_Exist___;


-- Package_Pick_Planned___
--   Returns TRUE if the specified package line has been pick planned.
FUNCTION Package_Pick_Planned___ (
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2,
   rel_no_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   found_ NUMBER;

   CURSOR get_planned IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    rowstate IN ('Picked', 'PartiallyDelivered', 'Delivered', 'Invoiced')
      AND    line_item_no > 0;
BEGIN
   OPEN get_planned;
   FETCH get_planned INTO found_;
   IF (get_planned%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE get_planned;
   RETURN (found_ = 1);
END Package_Pick_Planned___;


-- Check_Package_Status___
--   Check if the package header status should be modified when a package
--   component has been cancelled.
--   If all components are cancelled the package header is also cancelled.
--   If all components have status 'Delivered' the status for the package header
--   is also set to 'Delivered', and a new delivery record is created.
PROCEDURE Check_Package_Status___ (
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2,
   rel_no_   IN VARCHAR2 )
IS
   found_                  NUMBER;
   pkg_qty_reserved_       NUMBER;

   connect_charge_line_    NUMBER;   
   check_freight_exist_    NUMBER;
   line_rec_               CUSTOMER_ORDER_LINE_API.Public_Rec;

   CURSOR check_freight_exist IS
      SELECT 1
      FROM customer_order_charge_tab coc,
           sales_charge_type_tab sct
      WHERE coc.order_no                = order_no_
      AND   coc.line_no                 = line_no_
      AND   coc.rel_no                  = rel_no_
      AND   coc.line_item_no            = -1
      AND   sct.sales_chg_type_category = 'FREIGHT'
      AND   sct.contract                = coc.contract
      AND   sct.charge_type             = coc.charge_type;
      
   CURSOR uncancelled IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    line_item_no > 0
      AND    rowstate != 'Cancelled';
BEGIN
   OPEN uncancelled;
   FETCH uncancelled INTO found_;
   IF (uncancelled%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE uncancelled;

   IF (found_ = 0) THEN
      -- No uncancelled components exist in this package => Cancel package header
      Customer_Order_Line_API.Modify_Revised_Qty_Due(order_no_, line_no_, rel_no_, -1, 0);
      Handle_Staged_Billing___(order_no_, line_no_, rel_no_, -1);
      Customer_Order_API.Set_Line_Cancelled(order_no_, line_no_, rel_no_, -1);
      connect_charge_line_ := Customer_Order_Charge_API.Exist_Charge_On_Order_Line(order_no_, line_no_, rel_no_, -1);      
      IF (connect_charge_line_ = 1) THEN
         IF Customer_Order_API.Get_Objstate(order_no_) != 'Planned' THEN
            OPEN check_freight_exist;
            FETCH check_freight_exist INTO check_freight_exist_;
            CLOSE check_freight_exist;
         END IF;         
         Customer_Order_Charge_Util_API.Remove_Connected_Chg_Lines(order_no_, line_no_, rel_no_, -1);
         IF check_freight_exist_ IS NOT NULL THEN
            line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, -1);
            Customer_Order_Charge_Util_API.Consolidate_Grouped_Charges(order_no_,
                                                                       NULL,
                                                                       line_rec_.planned_ship_date,
                                                                       line_rec_.zone_id,
                                                                       line_rec_.delivery_terms,
                                                                       line_rec_.freight_price_list_no,
                                                                       line_rec_.demand_code);
         END IF;
      END IF;      
   ELSE
      pkg_qty_reserved_ := Reserve_Customer_Order_API.Get_No_Of_Packages_Reserved(order_no_, 
                                                                                  line_no_, 
                                                                                  rel_no_);
      Customer_Order_Line_API.Set_Qty_Assigned(order_no_, line_no_, rel_no_, -1, pkg_qty_reserved_);
      
      -- Deliver packages now completed if any.
      Deliver_Customer_Order_API.Deliver_Package_If_Complete(order_no_, line_no_, rel_no_);
   END IF;
END Check_Package_Status___;

-- Cancel_Simple_Line___
--   Cancels a line which may be an ordinary line (line_item_no = 0 ) or a
--   line which is part of a package (line_item_no > 0).
PROCEDURE Cancel_Simple_Line___ (
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   change_req_flag_   IN VARCHAR2,
   replicate_change_  IN VARCHAR2,
   change_exchg_part_ IN VARCHAR2,
   unpeg_ipd_flag_    IN VARCHAR2,
   co_cancel_         IN  VARCHAR2 )
IS
   supply_code_db_          VARCHAR2(3);
   demand_code_db_          VARCHAR2(20);
   found_                   NUMBER := 0;
   res_source_              VARCHAR2(200);
   linerec_                 Customer_Order_Line_API.public_rec;
   qty_reserved_            NUMBER;
   info_                    VARCHAR2(2000);
   dummy_number_            NUMBER;
   header_state_            customer_order_tab.rowstate%TYPE;
   dummy_                   VARCHAR2(2000);
   cancel_reason_           VARCHAR2(10);
   result_code_             VARCHAR2(2000);
   available_qty_           NUMBER := 0;
   earliest_available_date_ DATE;
   po_order_no_             VARCHAR2(12);
   po_line_no_              VARCHAR2(4);
   po_release_no_           VARCHAR2(4);
   
   CURSOR get_res_with_list IS
      SELECT 1
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      -- Concatenation with '' in order to make use of PK for CUSTOMER_ORDER_RESERVATION instead of IX
      WHERE  pick_list_no || '' != '*'
      AND    line_item_no = line_item_no_
      AND    rel_no       = rel_no_
      AND    line_no      = line_no_
      AND    order_no     = order_no_;

   CURSOR get_reservations IS
      SELECT contract,
             part_no,
             location_no,
             lot_batch_no,
             serial_no,
             eng_chg_level,
             waiv_dev_rej_no,
             qty_assigned,
             configuration_id,
             activity_seq,
             handling_unit_id,
             shipment_id
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      -- Concatenation with '' in order to make use of PK for CUSTOMER_ORDER_RESERVATION instead of IX
      WHERE  pick_list_no || '' = '*'
      AND    line_item_no = line_item_no_
      AND    rel_no       = rel_no_
      AND    line_no      = line_no_
      AND    order_no     = order_no_;

   CURSOR get_sc_reservations IS
      SELECT supply_site,
             part_no,
             location_no,
             lot_batch_no,
             serial_no,
             eng_chg_level,
             waiv_dev_rej_no,
             activity_seq,
             handling_unit_id,
             qty_assigned,
             configuration_id
      FROM   CO_SUPPLY_SITE_RESERVATION_TAB
      WHERE  line_item_no = line_item_no_
      AND    rel_no       = rel_no_
      AND    line_no      = line_no_
      AND    order_no     = order_no_;

   CURSOR get_sourced_reservations IS
      SELECT source_id,
             supply_site,
             part_no,
             location_no,
             lot_batch_no,
             serial_no,
             eng_chg_level,
             waiv_dev_rej_no,
             activity_seq,
             handling_unit_id,
             qty_assigned,
             configuration_id
      FROM   SOURCED_CO_SUPPLY_SITE_RES_TAB
      WHERE  line_item_no = line_item_no_
      AND    rel_no       = rel_no_
      AND    line_no      = line_no_
      AND    order_no     = order_no_;
      
   CURSOR get_qty_reservations IS
      SELECT qty_assigned
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  line_item_no = line_item_no_
      AND    rel_no       = rel_no_
      AND    line_no      = line_no_
      AND    order_no     = order_no_;

   licensed_order_type_    VARCHAR2(25);
   exp_license_connect_id_ NUMBER;
   ctp_run_id_             NUMBER;
   interim_ord_id_         VARCHAR2(12);
BEGIN
   -- Make sure no connected orders exist for this line
   Connected_Orders_Exist___(order_no_, line_no_, rel_no_, line_item_no_);
   cancel_reason_  := Customer_Order_Line_API.Get_Cancel_Reason(order_no_, line_no_, rel_no_, line_item_no_);
   linerec_        := Customer_Order_Line_API.Get(order_no_, line_no_,rel_no_, line_item_no_);
   supply_code_db_ := linerec_.supply_code;
   demand_code_db_ := linerec_.demand_code;

   header_state_   := Customer_Order_API.Get_Objstate(order_no_);

   -- Inventory order
   IF (supply_code_db_ IN ('SO','PT', 'PD','IPT', 'IPD', 'DOP')) THEN
      IF (header_state_ = 'Planned') THEN
         res_source_ := 'CUSTOMER ORDER';
         IF (Serial_No_Reservation_API.Check_Reservation_Exist(order_no_, line_no_,
                                                               rel_no_, line_item_no_,
                                                               res_source_, linerec_.part_no) = 'TRUE')
         THEN
            Serial_No_Reservation_API.Delete_Reserved(order_no_, line_no_, rel_no_, line_item_no_, res_source_);
         END IF;
      END IF;
   END IF;
   OPEN get_qty_reservations;
   FETCH get_qty_reservations INTO qty_reserved_ ;
   CLOSE get_qty_reservations;

   -- Check if a pick list has been created for any of the reservations
   IF (qty_reserved_ != 0 ) THEN
      -- Check if a pick list has been created for any of the reservations
      OPEN get_res_with_list;
      FETCH get_res_with_list INTO found_;
      IF get_res_with_list%FOUND THEN
         -- Pick list has been created for at least on reservation. The line may not be cancelled
         CLOSE get_res_with_list;
         Error_SYS.Record_General(lu_name_, 'PLISTCREATEDCOL: Line :P1-:P2-:P3 may not be cancelled when pick list has been created.', order_no_, line_no_, rel_no_);
      END IF;
      CLOSE get_res_with_list;
   END IF;

   Inventory_Event_Manager_API.Start_Session;
   FOR res_rec_ IN get_reservations LOOP
      -- Remove reservations in CustomerOrderReservation
      Customer_Order_Reservation_API.Remove(order_no_           => order_no_, 
                                            line_no_            => line_no_, 
                                            rel_no_             => rel_no_, 
                                            line_item_no_       => line_item_no_,
                                            contract_           => res_rec_.contract, 
                                            part_no_            => res_rec_.part_no,
                                            location_no_        => res_rec_.location_no, 
                                            lot_batch_no_       => res_rec_.lot_batch_no,
                                            serial_no_          => res_rec_.serial_no, 
                                            eng_chg_level_      => res_rec_.eng_chg_level,
                                            waiv_dev_rej_no_    => res_rec_.waiv_dev_rej_no, 
                                            activity_seq_       => res_rec_.activity_seq,
                                            handling_unit_id_   => res_rec_.handling_unit_id,
                                            pick_list_no_       => '*', 
                                            configuration_id_   => res_rec_.configuration_id, 
                                            shipment_id_        => res_rec_.shipment_id);
                                            
      -- Clear reservations made in InventoryPartLocation
      Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_    => dummy_number_,
                                               contract_          => res_rec_.contract, 
                                               part_no_           => res_rec_.part_no, 
                                               configuration_id_  => res_rec_.configuration_id,
                                               location_no_       => res_rec_.location_no, 
                                               lot_batch_no_      => res_rec_.lot_batch_no,
                                               serial_no_         => res_rec_.serial_no, 
                                               eng_chg_level_     => res_rec_.eng_chg_level,
                                               waiv_dev_rej_no_   => res_rec_.waiv_dev_rej_no, 
                                               activity_seq_      => res_rec_.activity_seq, 
                                               handling_unit_id_  => res_rec_.handling_unit_id,
                                               quantity_          => -res_rec_.qty_assigned);

      -- executes only if customer order is created from a CRO Exchange line.
      IF linerec_.demand_code = 'CRE' THEN
         $IF Component_Cromfg_SYS.INSTALLED $THEN
            Cro_Line_Util_API.Co_Line_Canceled(linerec_.demand_order_ref1,
                                               linerec_.demand_order_ref2,
                                               res_rec_.contract,
                                               res_rec_.part_no,
                                               res_rec_.configuration_id,
                                               res_rec_.location_no,
                                               res_rec_.lot_batch_no,
                                               res_rec_.serial_no,
                                               res_rec_.eng_chg_level,
                                               res_rec_.waiv_dev_rej_no,
                                               res_rec_.activity_seq,
                                               res_rec_.handling_unit_id,
                                               res_rec_.qty_assigned);
         $ELSE
            NULL;
         $END
      END IF;

      -- cancel connected mobilization work orders
      IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE  AND (res_rec_.serial_no != '*')) THEN
         $IF Component_Wo_SYS.INSTALLED $THEN
            Active_Separate_API.Cancel_Mobilization_Wo(order_no_, line_no_, rel_no_, line_item_no_,res_rec_.part_no, res_rec_.serial_no, Maintenance_Type_Api.DB_MOBILIZATION);
         $ELSE
            NULL;
         $END
      END IF;      
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
   
   -- clear any supply chain reservations in ScReserveCustOrderLine
   IF (Reserve_Customer_Order_API.Is_Supply_Chain_Reservation(order_no_, line_no_, rel_no_, line_item_no_, NULL, NULL) = 1) THEN
      FOR sc_res_rec_ IN get_sc_reservations LOOP         
         Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_       => dummy_number_,
                                                  contract_             => sc_res_rec_.supply_site, 
                                                  part_no_              => sc_res_rec_.part_no,
                                                  configuration_id_     => sc_res_rec_.configuration_id,
                                                  location_no_          => sc_res_rec_.location_no, 
                                                  lot_batch_no_         => sc_res_rec_.lot_batch_no,
                                                  serial_no_            => sc_res_rec_.serial_no, 
                                                  eng_chg_level_        => sc_res_rec_.eng_chg_level,
                                                  waiv_dev_rej_no_      => sc_res_rec_.waiv_dev_rej_no, 
                                                  activity_seq_         => sc_res_rec_.activity_seq, 
                                                  handling_unit_id_     => sc_res_rec_.handling_unit_id,
                                                  quantity_             => -sc_res_rec_.qty_assigned);         
         Co_Supply_Site_Reservation_API.Remove(order_no_       => order_no_, 
                                               line_no_        => line_no_,
                                               rel_no_         => rel_no_,
                                               line_item_no_   => line_item_no_,
                                               supply_site_    => sc_res_rec_.supply_site,
                                               part_no_        => sc_res_rec_.part_no,
                                               configuration_id_ => sc_res_rec_.configuration_id,
                                               location_no_      => sc_res_rec_.location_no,
                                               lot_batch_no_     => sc_res_rec_.lot_batch_no,
                                               serial_no_        => sc_res_rec_.serial_no,
                                               eng_chg_level_    => sc_res_rec_.eng_chg_level,
                                               waiv_dev_rej_no_  => sc_res_rec_.waiv_dev_rej_no,
                                               activity_seq_     => sc_res_rec_.activity_seq,
                                               handling_unit_id_ => sc_res_rec_.handling_unit_id);
      END LOOP;
   END IF;

   -- remove any source lines existing to the order line.
   IF Sourced_Cust_Order_Line_API.Check_Exist(order_no_, line_no_, rel_no_, line_item_no_) = 1 THEN
      FOR sourced_sc_res_rec_ IN get_sourced_reservations LOOP         
         Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_       => dummy_number_,
                                                  contract_             => sourced_sc_res_rec_.supply_site, 
                                                  part_no_              => sourced_sc_res_rec_.part_no,
                                                  configuration_id_     => sourced_sc_res_rec_.configuration_id,
                                                  location_no_          => sourced_sc_res_rec_.location_no, 
                                                  lot_batch_no_         => sourced_sc_res_rec_.lot_batch_no,
                                                  serial_no_            => sourced_sc_res_rec_.serial_no, 
                                                  eng_chg_level_        => sourced_sc_res_rec_.eng_chg_level,
                                                  waiv_dev_rej_no_      => sourced_sc_res_rec_.waiv_dev_rej_no, 
                                                  activity_seq_         => sourced_sc_res_rec_.activity_seq,
                                                  handling_unit_id_     => sourced_sc_res_rec_.handling_unit_id,
                                                  quantity_             => -sourced_sc_res_rec_.qty_assigned); 
                                                     
         Sourced_Co_Supply_Site_Res_API.Remove(order_no_         => order_no_,
                                               line_no_          => line_no_,
                                               rel_no_           => rel_no_,
                                               line_item_no_     => line_item_no_,
                                               source_id_        => sourced_sc_res_rec_.source_id,
                                               supply_site_      => sourced_sc_res_rec_.supply_site,
                                               part_no_          => sourced_sc_res_rec_.part_no,
                                               configuration_id_ => sourced_sc_res_rec_.configuration_id,
                                               location_no_      => sourced_sc_res_rec_.location_no,
                                               lot_batch_no_     => sourced_sc_res_rec_.lot_batch_no,
                                               serial_no_        => sourced_sc_res_rec_.serial_no,
                                               eng_chg_level_    => sourced_sc_res_rec_.eng_chg_level,
                                               waiv_dev_rej_no_  => sourced_sc_res_rec_.waiv_dev_rej_no,
                                               activity_seq_     => sourced_sc_res_rec_.activity_seq,
                                               handling_unit_id_ => sourced_sc_res_rec_.handling_unit_id);
      END LOOP;
      Sourced_Cust_Order_Line_API.Remove(info_, order_no_, line_no_, rel_no_, line_item_no_);
   END IF;

   IF (supply_code_db_ IN ('IO','PS','SO','DOP','PD','PT','IPD','IPT')) THEN
      -- Update forecast in MS or MRP if needed.
      linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_,rel_no_, line_item_no_);

      IF Inventory_Part_API.Get_Forecast_Consump_Flag_Db(linerec_.contract, linerec_.part_no) = 'FORECAST'
      THEN
         -- Unconsume the cancelled quantity
         Reserve_Customer_Order_API.Control_Ms_Mrp_Consumption
            (result_code_,
             available_qty_,
             earliest_available_date_,
             linerec_.contract, linerec_.part_no, NVL(linerec_.activity_seq, 0),
             0, linerec_.revised_qty_due, -- old_demand_qty_
             linerec_.planned_due_date, linerec_.planned_due_date,
             'CO', TRUE, linerec_.abnormal_demand, NULL);
      END IF;   
   END IF;
   
   $IF (Component_Ordstr_SYS.INSTALLED) $THEN
   interim_ord_id_:= Customer_Order_Line_API.Get_Interim_Order_No(order_no_, line_no_, rel_no_, line_item_no_, linerec_.ctp_planned);
      -- remove capibility check reservations/allocations
      IF (linerec_.ctp_planned = 'Y' OR (linerec_.ctp_planned = 'N' AND interim_ord_id_ IS NOT NULL)) THEN
         Interim_Ctp_Manager_API.Cancel_Ctp(dummy_, order_no_, line_no_, rel_no_, line_item_no_, 'CUSTOMERORDER', supply_code_db_);        
         Customer_Order_Line_API.Clear_Ctp_Planned(order_no_, line_no_, rel_no_, line_item_no_);               
      END IF;
      -- Remove interim order/promise order
      IF (linerec_.configuration_id != '*' AND linerec_.ctp_planned = 'N') THEN      
         Interim_Demand_Head_API.Remove_Interim_Head_By_Usage('CUSTOMERORDER', order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
      -- Remove ctp record
      ctp_run_id_ := Interim_Ctp_Critical_Path_API.Get_Ctp_Run_Id('CUSTOMERORDER', order_no_, line_no_, rel_no_, line_item_no_);
      IF (ctp_run_id_ IS NOT NULL AND ctp_run_id_ > 0) THEN
         Interim_Ctp_Critical_Path_API.Clear_Ctp_Data(ctp_run_id_);
      END IF;
   $END   

   -- Modify line attributes
   IF (Customer_Order_Line_API.Get_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_) > 0) THEN
      Customer_Order_API.Set_Line_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_, 0);
   END IF;

   -- Check if shortage records exist for this line, if so then remove them.
   IF (Customer_Order_Shortage_API.Check_Exist(order_no_, line_no_, rel_no_, line_item_no_)) THEN
      -- Remove shortage records
      Customer_Order_Shortage_API.Remove(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;

   IF (linerec_.qty_short != 0) THEN
      Customer_Order_Line_API.Set_Qty_Short(order_no_, line_no_, rel_no_, line_item_no_, 0);
   END IF;
   
   IF NOT(supply_code_db_ = 'IPD' AND unpeg_ipd_flag_ = 'TRUE') THEN
      Customer_Order_API.Set_Line_Cancelled(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;

   IF ((supply_code_db_ IN ('PT', 'PD','IPT','IPD','DOP','SO') AND (header_state_ != 'Planned')) OR ((demand_code_db_ IN ('CRO', 'CRE')) AND (supply_code_db_ IN ('IO', 'CRO', 'SEO'))) ) THEN
      Cancel_Connected_Order_Line___( order_no_, line_no_, rel_no_, line_item_no_, NVL(change_req_flag_,'FALSE'), NVL(replicate_change_,'TRUE'));
      -- Note: There is no any pegged qty on the lines with demand code 'CRO' and supply code 'IO' and 'SEO'. No need to update the pegged qty.
      IF NOT ((demand_code_db_ = 'CRO') AND (supply_code_db_ IN ('IO', 'SEO'))) THEN
         Customer_Order_Line_API.Modify_Qty_On_Order(order_no_, line_no_, rel_no_, line_item_no_, 0);
      END IF;
   END IF;
   
   IF (supply_code_db_ = 'IPD' AND unpeg_ipd_flag_ = 'TRUE') THEN
      Customer_Order_Line_API.Unpeg_Line(order_no_, line_no_, rel_no_, line_item_no_, unpeg_ipd_flag_);
   ELSE
      IF (linerec_.activity_seq IS NOT NULL) AND (linerec_.activity_seq > 0) THEN 
         $IF (Component_Proj_SYS.INSTALLED) $THEN 
            -- Remove cost connection
            Project_Connection_Util_API.Remove_Connection(proj_lu_name_   => 'COLINE',
                                                          activity_seq_   => linerec_.activity_seq,
                                                          keyref1_        => order_no_,
                                                          keyref2_        => line_no_,
                                                          keyref3_        => rel_no_,
                                                          keyref4_        => line_item_no_,
                                                          keyref5_        => NULL,
                                                          keyref6_        => NULL);
            -- Remove revenue connection
            Project_Connection_Util_API.Remove_Connection(proj_lu_name_   => 'COLINEREV',
                                                          activity_seq_   => linerec_.activity_seq,
                                                          keyref1_        => order_no_,
                                                          keyref2_        => line_no_,
                                                          keyref3_        => rel_no_,
                                                          keyref4_        => line_item_no_,
                                                          keyref5_        => NULL,
                                                          keyref6_        => NULL);              
         $END
         Customer_Order_Line_API.Modify_Activity_Seq(order_no_, line_no_, rel_no_, line_item_no_, NULL);
      END IF ;
   END IF;

   IF (linerec_.qty_to_ship != 0) THEN
      Customer_Order_Line_API.Modify_Qty_To_Ship__(order_no_, line_no_, rel_no_, line_item_no_, 0);
   END IF;

   -- Only for package components
   IF line_item_no_ > 0 THEN
      IF (NVL(linerec_.char_price, 0) > 0 OR NVL(linerec_.calc_char_price, 0) > 0) THEN
         Customer_Order_Line_API.Modify_Char_Price(order_no_, line_no_, rel_no_, line_item_no_, 0, 0);
      END IF;
   END IF;
   
   IF (linerec_.exchange_item = 'EXCHANGED ITEM') THEN
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         IF (change_exchg_part_ = 'FALSE') THEN
            IF cancel_reason_ IS NOT NULL THEN
               Pur_Order_Exchange_Comp_API.Get_Connected_Po_Info(po_order_no_, po_line_no_, po_release_no_, order_no_, line_no_, rel_no_, line_item_no_);
               Purchase_Order_Line_API.Set_Cancel_Reason(po_order_no_, po_line_no_, po_release_no_, cancel_reason_, NULL);
            END IF;
            Pur_Order_Exchange_Comp_API.Cancel_Exchange_Pur_Order(order_no_,line_no_,rel_no_,line_item_no_ );                    
         END IF;
      $ELSE
         NULL;
      $END
   END IF;

   IF (supply_code_db_ = 'PS' AND header_state_ = 'Released') THEN
      Client_SYS.Add_Info(lu_name_, 'PS_EXISTLCANC: Production schedules will not be cancelled or removed automatically.');
   END IF;

   licensed_order_type_ := Customer_Order_Line_API.Get_Expctr_License_Order_Type(linerec_.demand_code, linerec_.demand_order_ref1, linerec_.demand_order_ref2, linerec_.demand_order_ref3);
   
   $IF Component_Expctr_SYS.INSTALLED $THEN
      exp_license_connect_id_ := Exp_License_Connect_Head_API.Get_Connect_Id_From_Ref(licensed_order_type_,order_no_, line_no_, rel_no_, line_item_no_);
      IF(exp_license_connect_id_ IS NOT NULL) THEN
         Exp_License_Connect_Head_API.Set_License_Order_Event(exp_license_connect_id_, 'CANCELED');   
      END IF; 
   $END
   
   IF (NVL(co_cancel_, 'FALSE') = 'FALSE' AND Company_Order_Info_API.Get_Prepayment_Inv_Method_Db(Site_API.Get_Company(linerec_.contract)) = ('PREPAYMENT_BASED_INVOICE') AND Customer_Invoice_Pub_Util_API.Has_Adv_Or_Prepaym_Inv(order_no_) = 'FALSE') THEN
      Customer_Order_Line_API.Validate_PrePayment(order_no_, line_no_, rel_no_, line_item_no_, 'MODIFY');
   END IF;
END Cancel_Simple_Line___;


-- Cancel_Package___
--   Cancels a package including all rows within the package
PROCEDURE Cancel_Package___ (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   change_req_flag_  IN VARCHAR2,
   replicate_change_ IN VARCHAR2 )
IS
   this_line_item_no_    customer_order_line_tab.line_item_no%TYPE;
   next_line_item_no_    customer_order_line_tab.line_item_no%TYPE;
   po_order_no_          customer_order_pur_order_tab.po_order_no%TYPE;
   next_po_order_no_     customer_order_pur_order_tab.po_order_no%TYPE;
   temp_change_req_flag_ VARCHAR2(5);
   
   CURSOR get_po_connected_components IS
      SELECT line_item_no, po_order_no
      FROM   customer_order_line_tab col, customer_order_pur_order_tab cop
      WHERE  col.order_no = order_no_
      AND    col.line_no  = line_no_
      AND    col.rel_no   = rel_no_
      AND    col.line_item_no > 0
      AND    col.rowstate IN ('Released', 'Reserved')
      AND    cop.oe_order_no = col.order_no
      AND    cop.oe_line_no = col.line_no
      AND    cop.oe_rel_no = col.rel_no
      AND    cop.oe_line_item_no  = col.line_item_no
      ORDER BY po_order_no;
   
   CURSOR get_package_structure IS
      SELECT line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    line_item_no > 0
      AND    rowstate IN ('Released', 'Reserved');
   CURSOR lines_connected IS
      SELECT 1
      FROM  customer_order_line_tab
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no   = rel_no_
      AND   line_item_no > 0
      AND   qty_on_order > 0
      AND   rowstate IN ('Released', 'Reserved')
      AND   supply_code IN ('SO');

   cancel_reason_     VARCHAR2(10);
   connected_         NUMBER := 0;
   change_exchg_part_ VARCHAR2(5) := 'FALSE';
   linerec_           Customer_Order_Line_API.public_rec;
BEGIN
   OPEN  lines_connected;
   FETCH lines_connected INTO connected_;
   CLOSE lines_connected;

   IF (Package_Pick_Planned___(order_no_, line_no_, rel_no_)) THEN
      Error_SYS.Record_General(lu_name_, 'PICKPLANNEDEXIST: A package may not be cancelled after pick planning');
   END IF;
   
   linerec_       := Customer_Order_Line_API.Get(order_no_, line_no_,rel_no_, line_item_no_);
   cancel_reason_ := linerec_.cancel_reason;
   
   IF change_req_flag_ = 'TRUE' THEN
      -- cancel PO connected, non-cancelled component lines 
      OPEN get_po_connected_components;
      -- Fetch first line
      FETCH get_po_connected_components INTO this_line_item_no_, po_order_no_;
      LOOP
         EXIT WHEN get_po_connected_components%NOTFOUND;
         -- Fetch next line
         FETCH get_po_connected_components INTO next_line_item_no_, next_po_order_no_;
         IF (get_po_connected_components%NOTFOUND OR next_po_order_no_ != po_order_no_) THEN
            -- This is the last line or the next line is connected to a different internal PO
            temp_change_req_flag_ := 'TRUE';
         ELSE
            -- Next line is also connected to the same internal PO
            temp_change_req_flag_ := 'FALSE';
         END IF;

         IF cancel_reason_ IS NOT NULL THEN
            Customer_Order_Line_API.Set_Cancel_Reason(order_no_, line_no_, rel_no_, this_line_item_no_, cancel_reason_);
         END IF;
         Cancel_Simple_Line___(order_no_, line_no_, rel_no_, this_line_item_no_, temp_change_req_flag_, replicate_change_, change_exchg_part_, 'FALSE', 'FALSE');

         this_line_item_no_ := next_line_item_no_;
         po_order_no_ := next_po_order_no_;

      END LOOP;
      CLOSE get_po_connected_components;
   END IF;

   -- Cancel all package components not caancelled in above get_po_connected_components loop.
   FOR comp_rec_ IN get_package_structure LOOP
      IF cancel_reason_ IS NOT NULL THEN
         Customer_Order_Line_API.Set_Cancel_Reason(order_no_, line_no_, rel_no_, comp_rec_.line_item_no, cancel_reason_);
      END IF;
      Cancel_Simple_Line___(order_no_, line_no_, rel_no_, comp_rec_.line_item_no, change_req_flag_, replicate_change_, change_exchg_part_, 'FALSE', 'FALSE');
   END LOOP;

   -- Modify package header attributes
   Customer_Order_Line_API.Modify_Revised_Qty_Due(order_no_, line_no_, rel_no_, line_item_no_, 0);

   Customer_Order_API.Set_Line_Cancelled(order_no_, line_no_, rel_no_, line_item_no_);

   IF (linerec_.activity_seq IS NOT NULL) AND (linerec_.activity_seq > 0) THEN
      Customer_Order_Line_API.Modify_Activity_Seq(order_no_, line_no_, rel_no_, line_item_no_, NULL);
   END IF ;  

   IF (connected_ > 0) THEN
      Client_SYS.Clear_Info;
      Client_SYS.Add_Info(lu_name_, 'PKG_CONNECTED: This order line contains package components connected to Shop Order.');
   END IF;
END Cancel_Package___;

-- Cancel_Order_Line___
--   Cancel an order line.
--   A line may be cancelled only if in state 'Released'
--   A line may not be cancelled if it has been picked
--   (inventory parts) or deliveries have been made (non inventory parts)
PROCEDURE Cancel_Order_Line___ (
   pkg_info_            OUT VARCHAR2,           
   order_no_            IN  VARCHAR2,
   line_no_             IN  VARCHAR2,
   rel_no_              IN  VARCHAR2,
   line_item_no_        IN  NUMBER,
   change_req_flag_     IN  VARCHAR2,
   replicate_change_    IN  VARCHAR2,
   change_exchg_part_   IN  VARCHAR2,
   unpeg_ipd_flag_      IN  VARCHAR2,
   co_cancel_           IN  VARCHAR2 )
IS 
   supply_code_db_         customer_order_line_tab.supply_code%TYPE;
   demand_code_db_         customer_order_line_tab.demand_code%TYPE;
   demand_order_ref1_      customer_order_line_tab.demand_order_ref1%TYPE;
   demand_order_ref3_      customer_order_line_tab.demand_order_ref1%TYPE;
   shipment_connected_db_  customer_order_line_tab.shipment_connected%TYPE;
   objstate_               customer_order_line_tab.rowstate%TYPE;
   rental_db_              customer_order_line_tab.rental%TYPE;
   planned_ship_date_      customer_order_line_tab.planned_ship_date%TYPE;
   zone_id_                customer_order_line_tab.zone_id%TYPE;
   delivery_terms_         customer_order_line_tab.delivery_terms%TYPE;
   freight_price_list_no_  customer_order_line_tab.freight_price_list_no%TYPE;
   stmt_                   VARCHAR2(1200);
   state_                  VARCHAR2(12);
   connect_charge_line_    NUMBER;
   
   CURSOR get_co_line_info IS
      SELECT supply_code, demand_code, demand_order_ref1, demand_order_ref3, shipment_connected, rowstate, rental,
             planned_ship_date, zone_id, delivery_terms, freight_price_list_no
      FROM customer_order_line_tab
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_;

   CURSOR check_freight_exist IS
      SELECT 1
      FROM customer_order_charge_tab coc,
           sales_charge_type_tab sct
      WHERE coc.order_no                = order_no_
      AND   coc.line_no                 = line_no_
      AND   coc.rel_no                  = rel_no_
      AND   coc.line_item_no            = line_item_no_
      AND   sct.sales_chg_type_category = 'FREIGHT'
      AND   sct.contract                = coc.contract
      AND   sct.charge_type             = coc.charge_type;

   check_freight_exist_ NUMBER;
BEGIN
   OPEN get_co_line_info;
   FETCH get_co_line_info INTO supply_code_db_, demand_code_db_, demand_order_ref1_, demand_order_ref3_, shipment_connected_db_, objstate_, rental_db_,
                               planned_ship_date_, zone_id_, delivery_terms_, freight_price_list_no_;
   CLOSE get_co_line_info;

   IF (objstate_ = 'Cancelled') THEN
      -- Bail out
      RETURN;
   END IF;

   IF objstate_ = ( 'Reserved') THEN
      IF (Customer_Order_Reservation_API.Pick_List_Exist(order_no_, line_no_, rel_no_, line_item_no_) = 1) THEN
         Error_SYS.Record_General(lu_name_, 'NOCANCELCOLRES: Order line :P1-:P2-:P3 may not be cancelled if a pick list has been created.', order_no_, line_no_, rel_no_);
      END IF;
   ELSIF (objstate_ !='Released') THEN
      Error_SYS.Record_General(lu_name_, 'NOCANCELCOL: Order line :P1-:P2-:P3 may not be cancelled if the line has been picked or deliveries have been made.', order_no_, line_no_, rel_no_);
   END IF;  
   
   IF NOT(supply_code_db_ = 'IPD' AND unpeg_ipd_flag_ = 'TRUE') THEN
      Handle_Staged_Billing___(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   
   connect_charge_line_ := Customer_Order_Charge_API.Exist_Charge_On_Order_Line(order_no_, line_no_, rel_no_, line_item_no_);
   IF (connect_charge_line_ = 1) THEN
      IF Customer_Order_API.Get_Objstate(order_no_) != 'Planned' THEN
         OPEN check_freight_exist;
         FETCH check_freight_exist INTO check_freight_exist_;
         CLOSE check_freight_exist;
      END IF;
      Customer_Order_Charge_Util_API.Remove_Connected_Chg_Lines(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;

   IF (demand_code_db_ = 'DO') THEN
      stmt_ := 'BEGIN :state_ := Distribution_Order_API.Get_Objstate(:order_no); END;';
      @ApproveDynamicStatement(2011-01-06,maeelk)
      EXECUTE IMMEDIATE stmt_ USING OUT state_, IN demand_order_ref1_;
      IF (state_ != 'Cancelled') THEN
         Error_SYS.Record_General(lu_name_, 'CANCELDOFIRST: This Customer Order is connected to a Distribution Order. Cancel the DO instead.');
      END IF;
   ELSIF (demand_code_db_ IN ('WO', 'SEC')) THEN
      Error_SYS.Record_General(lu_name_, 'CANCELNOTALLOWED: Customer order lines generated from a work order or a service contract cannot be cancelled. They should be handled from the corresponding work order or service contract.');
   END IF;
   IF (rental_db_ = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         IF (Rental_Object_Manager_API.On_Rental_Period_Qty_Exist(order_no_,
                                                                  line_no_,
                                                                  rel_no_,
                                                                  line_item_no_,   
                                                                  Rental_Type_API.DB_CUSTOMER_ORDER)) THEN
            Error_SYS.Record_General(lu_name_, 'NOTCANCELRENTALCOL: You cannot cancel customer order line(s) when rental periods exist. Please remove the rental periods by creating correction rental events.');
         END IF;
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END
   END IF;
   
   IF (replicate_change_ = 'TRUE' AND supply_code_db_ IN ('IPD', 'IPT')) THEN
      Pegged_Obj_Start_Operation___(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   
   IF (line_item_no_ = 0) THEN
      -- Ordinary line
      Cancel_Simple_Line___(order_no_, line_no_, rel_no_, line_item_no_, change_req_flag_, replicate_change_, change_exchg_part_, unpeg_ipd_flag_, co_cancel_);
   ELSIF (line_item_no_ = -1) THEN
      -- Package header
      Cancel_Package___(order_no_, line_no_, rel_no_, line_item_no_,  change_req_flag_, replicate_change_);
   ELSE
      -- Package component
      Cancel_Simple_Line___(order_no_, line_no_, rel_no_, line_item_no_, change_req_flag_, replicate_change_, change_exchg_part_, unpeg_ipd_flag_, co_cancel_);
      pkg_info_ := Client_SYS.Get_All_Info;   
      Customer_Order_Line_API.Recalc_Package_Structure__ (order_no_, line_no_, rel_no_);
      -- Check if the package header status should be modified
      Check_Package_Status___(order_no_, line_no_, rel_no_);
   END IF;

   IF (shipment_connected_db_ = 'TRUE') THEN
      Shipment_Line_API.Remove_Active_Shipments(order_no_, line_no_, rel_no_, 
                                                line_item_no_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);   
   END IF;
      
   IF check_freight_exist_ IS NOT NULL THEN
      Customer_Order_Charge_Util_API.Consolidate_Grouped_Charges(order_no_,
                                                                 NULL,
                                                                 planned_ship_date_,
                                                                 zone_id_,
                                                                 delivery_terms_,
                                                                 freight_price_list_no_,
                                                                 demand_code_db_);
   END IF;
   
   IF (demand_code_db_ = 'DO') THEN
      Cancel_Order_If_Obsolete___(order_no_);
   END IF;
END Cancel_Order_Line___;


-- Cancel_Order___
--   Cancel all order lines for the specified order.
--   An order may be cancelled only if it has not been reserved.
--   An order may be cancelled only if no lines have been picked
--   (inventory parts) and now deliveries have been made (non inventory parts).
PROCEDURE Cancel_Order___ (
   order_no_         IN VARCHAR2,
   change_req_flag_  IN VARCHAR2,
   replicate_change_ IN VARCHAR2 )
IS
   objstate_          VARCHAR2(20);
   change_exchg_part_ VARCHAR2(5) := 'FALSE';
   demand_code_       VARCHAR2(200);
   pick_list_exist_   BOOLEAN := FALSE;
   dummy_             NUMBER := 0;
   pkg_info_          VARCHAR2(32000);
   cust_no_           VARCHAR2(20);
   company_           VARCHAR2(20);
   temp_change_req_flag_ VARCHAR2(5);

   CURSOR get_po_connected_lines IS
      SELECT line_no,
             rel_no,
             line_item_no,
             po_order_no
      FROM   customer_order_line_tab col, customer_order_pur_order_tab cop
      WHERE  col.order_no = order_no_
      AND    col.rowstate != 'Cancelled'
      AND    col.line_item_no <= 0
      AND    cop.oe_order_no = col.order_no
      AND    cop.oe_line_no = col.line_no
      AND    cop.oe_rel_no = col.rel_no
      AND    cop.oe_line_item_no  = col.line_item_no
      ORDER BY po_order_no;
   connected_line_       get_po_connected_lines%ROWTYPE;
   next_connected_line_  get_po_connected_lines%ROWTYPE;

   CURSOR get_lines IS
      SELECT line_no,
             rel_no,
             line_item_no
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    rowstate != 'Cancelled'
      AND    line_item_no <= 0;

   CURSOR check_exist IS
      SELECT 1
      FROM   customer_order_reservation_tab
      WHERE  order_no = order_no_
      AND    pick_list_no != '*';
BEGIN
   objstate_    := Customer_Order_API.Get_Objstate(order_no_);
   demand_code_ := Customer_Order_Line_API.Get_Demand_Code(order_no_ ,'1', '1', 0);
   
   IF (objstate_ = 'Cancelled') THEN
      -- Bail out
      RETURN;
   END IF;
   
   IF (objstate_ = 'Reserved') THEN
      OPEN  check_exist;
      FETCH check_exist INTO dummy_;
      IF (check_exist%FOUND) THEN
         CLOSE check_exist;
         pick_list_exist_ := TRUE;
      ELSE
         CLOSE check_exist;
      END IF;      
   END IF;

   IF (objstate_ NOT IN ('Planned', 'Released', 'Blocked', 'Reserved') OR (objstate_ = 'Reserved' AND pick_list_exist_)) THEN
      -- the below error is not needed when a customer order is created from Distribution Order
      IF NOT (demand_code_ IS NOT NULL AND Order_Supply_Type_API.Encode(demand_code_) = 'DO') THEN
         Error_SYS.Record_General(lu_name_, 'WRONGSTATE: Order may not be cancelled if deliveries have been made.');
      END IF; 
   END IF;

   Customer_Order_Flow_API.Check_No_Previous_Execution(order_no_, 'CANCEL');
  IF change_req_flag_ = 'TRUE' THEN
      -- cancel PO connected, non-cancelled order lines and store the info messages between each lap
      -- Send one Change request per internal PO 
      OPEN get_po_connected_lines;
      -- Fetch first line
      FETCH get_po_connected_lines INTO connected_line_;
      LOOP
         EXIT WHEN get_po_connected_lines%NOTFOUND;
         -- Fetch next line
         FETCH get_po_connected_lines INTO next_connected_line_;
         IF (get_po_connected_lines%NOTFOUND OR next_connected_line_.po_order_no != connected_line_.po_order_no) THEN
            -- This is the last line or the next line is connected to a different internal PO
            temp_change_req_flag_ := 'TRUE';
         ELSE
            -- Next line is also connected to the same internal PO
            temp_change_req_flag_ := 'FALSE';
         END IF;
         
         Cancel_Order_Line___(pkg_info_, order_no_, connected_line_.line_no, connected_line_.rel_no, connected_line_.line_item_no, temp_change_req_flag_, replicate_change_, change_exchg_part_, 'FALSE', 'TRUE');
         connected_line_ := next_connected_line_;

      END LOOP;
      CLOSE get_po_connected_lines;
   END IF;
   
   -- cancel rest of the non-cancelled order lines and store the info messages between each lap
   FOR next_line_ IN get_lines LOOP
      Cancel_Order_Line___(pkg_info_, order_no_, next_line_.line_no, next_line_.rel_no, next_line_.line_item_no, change_req_flag_, replicate_change_, change_exchg_part_, 'FALSE', 'TRUE');
   END LOOP;
   
   Client_SYS.Clear_Info;

   -- Note: Cancel the order head itself.
   -- Note: The cancellation of a single line does not check for cancellation of the order,
   -- Note: the order has to be cancelled explicitly and Line was brought to top.
   Customer_Order_API.Set_Cancelled(order_no_);
   
   $IF (Component_Payled_SYS.INSTALLED) $THEN
      company_ := Site_API.Get_Company(Customer_Order_API.Get_Contract(order_no_));
      cust_no_ := Customer_Order_API.Get_Customer_No(order_no_);
      On_Account_Ledger_Item_API.Remove_Cust_Order_Ref(company_, cust_no_, order_no_);  
   $END
END Cancel_Order___;


-- Cancel_Connected_Order_Line___
--   Removes connected order lines to the customer order line.
PROCEDURE Cancel_Connected_Order_Line___ (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   change_req_flag_  IN VARCHAR2,
   replicate_change_ IN VARCHAR2 )
IS
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
   linerec_          Customer_Order_Line_API.public_rec; 
   dummy_str_        VARCHAR2(12) := NULL;
   dummy_no_         NUMBER := NULL;
   demand_decode_type_ VARCHAR2(3);
BEGIN
   linerec_        := Customer_Order_Line_API.Get(order_no_, line_no_,rel_no_, line_item_no_);
   supply_code_db_ := linerec_.supply_code;
   -- check supply code and replicate flag
   IF (supply_code_db_ IN ('PD', 'PT', 'IPD', 'IPT')) THEN   
      -- get connected order information
      Customer_Order_Pur_Order_API.Get_Purord_For_Custord( po_order_no_, po_line_no_, po_rel_no_, 
                                                           purchase_type_, order_no_, line_no_, rel_no_, line_item_no_);
      IF (po_order_no_ IS NOT NULL) THEN
         purchase_type_db_ := Purchase_Type_API.Encode(purchase_type_);
               
         IF (replicate_change_ = 'TRUE') THEN   
            -- check if the pegged object is updatable 
            IF (Connect_Customer_Order_API.Is_pegged_Object_Updatable( order_no_, line_no_, rel_no_, line_item_no_) = 'TRUE') THEN                             
               $IF (Component_Purch_SYS.INSTALLED) $THEN
                  IF (purchase_type_db_ = 'O') THEN
                     -- Connected Purchase Order Cancel Line  
                     -- Cancel the corresponding PO when replicate YES.
                     Purchase_Order_Line_API.Set_Cancel_Reason(po_order_no_, po_line_no_, po_rel_no_, linerec_.cancel_reason, NULL);
                     Purchase_Order_Line_API.Cancel_Line(po_order_no_, po_line_no_, po_rel_no_, info_);
                     
                     IF info_ IS NOT NULL THEN
                        Client_SYS.Add_Info(lu_name_, info_);
                     END IF;
                  ELSIF (purchase_type_db_ = 'R') THEN
                     -- Connected Purchase Requsition Remove Line and Requsition  
                     Purchase_Req_Line_API.Remove_Instance(po_order_no_, po_line_no_, po_rel_no_);
                     Purchase_Requisition_API.Remove_Requis_Header(po_order_no_);                           
                  END IF;
                  IF (supply_code_db_ IN ('IPD', 'IPT')) THEN
                     new_status_ := 'CANCELLED';
                     new_status_ := Purch_Revision_Status_API.Decode(new_status_);
                     Purch_Line_Revision_Status_API.Set_Status(po_order_no_, po_line_no_, po_rel_no_, new_status_);                           
   
                     -- If change request is allowed then change pegged object in the other site  
                     -- by sending a change request for cancellation
                     IF (change_req_flag_ = 'TRUE') THEN
                        message_type_ := 'ORDCHG';
                        media_code_   := Supplier_Info_Msg_Setup_API.Get_Default_Media_Code(Purchase_Order_API.Get_Vendor_No(po_order_no_), message_type_);                                 
                        IF media_code_ IS NOT NULL THEN
                           -- Passed line_no_ and release_no_ parameters as NULL since it is not necessary to 
                           -- consider given line information to determine ordchg_line_state_ .
                           Purchase_Order_Transfer_API.Send_Order_Change(po_order_no_, NULL, NULL, media_code_);                           
                        END IF;
                     END IF;  
                  END IF;
               $ELSE
                  NULL;
               $END          
            ELSE
               -- if pegged object not updatable   
               Error_SYS.Record_General(lu_name_, 'NOCANCEL_CUSTPURORD: No changes are allowed when the purchase order is in the "Received", "Closed" or "Canceled" status.');
            END IF;
         ELSE
            $IF (Component_Purch_SYS.INSTALLED) $THEN
               IF (supply_code_db_ IN ('IPT', 'PT') OR (purchase_type_db_ = 'R')) THEN
                  Purchase_Order_Line_Part_API.Unpeg_Order(po_order_no_, po_line_no_, po_rel_no_, purchase_type_);                                         
               END IF;
            $ELSE
               NULL; 
            $END
         END IF;
         Customer_Order_Pur_Order_API.Remove(order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   ELSIF (supply_code_db_ = 'DOP') THEN
      -- Cancel Connected DOP orders
      $IF (Component_Dop_SYS.INSTALLED) $THEN        
         Dop_Demand_Gen_API.Cancel_Dop_Head(order_no_, line_no_, rel_no_,
                                            line_item_no_, replicate_change_);       
      $ELSE
         NULL;      
      $END
   ELSIF (supply_code_db_ = 'SO') THEN
      -- get connected shop orders
      Customer_Order_Shop_Order_API.Get_Shop_Order(so_order_no_, so_release_no_, so_sequence_no_,
                                                   order_no_, line_no_, rel_no_, line_item_no_);
      IF (so_order_no_ IS NOT NULL) THEN
         IF (linerec_.qty_on_order > 0) THEN
            IF (so_order_no_ IS NOT NULL) THEN
               -- Note: Remove the Shop order when automatic cancellation through Message box takes place.
               IF (replicate_change_ = 'TRUE') THEN
                  $IF (Component_Shpord_SYS.INSTALLED) $THEN
                     Shop_Ord_API.Cancel(so_order_no_, so_release_no_, so_sequence_no_); 
                  $ELSE
                     NULL;
                  $END
               ELSE
                  $IF (Component_Shpord_SYS.INSTALLED) $THEN                
                     Shop_Ord_Util_API.Modify_Cust_Ord_Details(so_order_no_,
                                                               so_release_no_,
                                                               so_sequence_no_,
                                                               dummy_str_,
                                                               dummy_str_,
                                                               dummy_str_,
                                                               dummy_no_,
                                                               dummy_str_,
                                                               Order_Supply_Type_API.Decode('IO'),
                                                               0);                        
                  $ELSE
                     NULL;
                  $END 
                  END IF; 
               END IF;
         ELSIF (linerec_.qty_on_order = 0) THEN  
            $IF (Component_Shpord_SYS.INSTALLED) $THEN
               IF ((Customer_Order_Line_Api.Get_Activity_Seq(order_no_,line_no_,rel_no_, line_item_no_ ) IS NOT NULL) AND (Shop_Ord_Api.Get_State_Db(so_order_no_,so_release_no_,so_sequence_no_ )='Closed')) THEN
                  demand_decode_type_ := 'PI';
               ELSE 
                  demand_decode_type_ := 'IO';
               END IF;
               Shop_Ord_Util_API.Modify_Cust_Ord_Details(so_order_no_, 
                                                         so_release_no_, 
                                                         so_sequence_no_, 
                                                         dummy_str_, 
                                                         dummy_str_, 
                                                         dummy_str_, 
                                                         dummy_no_, 
                                                         dummy_str_,
                                                         Order_Supply_Type_API.Decode(demand_decode_type_),
                                                         0);
            $ELSE
               NULL;
            $END
         END IF;
         -- Remove the customer order shop order connection when cancelling the CO for both replicate YES and NO occurrences.  
         Customer_Order_Shop_Order_API.Remove_Cancelled_Order(order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   END IF;

   IF ((linerec_.demand_code = Order_Supply_Type_API.DB_COMPONENT_REPAIR_ORDER) OR (linerec_.demand_code = Order_Supply_Type_API.DB_COMPONENT_REPAIR_EXCHANGE)) THEN
      IF (supply_code_db_ IN ('IO', 'CRO')) THEN
         -- Clear CO Line information if CO line was created by a CRO Line/CRO Exchange Line.
         $IF (Component_Cromfg_SYS.INSTALLED) $THEN
            Cro_Line_Material_Route_API.Clear_Co_Information(  cro_no_              => linerec_.demand_order_ref1, 
                                                               cro_line_no_         => linerec_.demand_order_ref2,
                                                               dispatch_order_ref1_ => order_no_,
                                                               dispatch_order_ref2_ => line_no_,
                                                               dispatch_order_ref3_ => rel_no_, 
                                                               dispatch_order_ref4_ => line_item_no_);
            Cro_Exchange_Line_API.Clear_Co_Information(linerec_.demand_order_ref1, linerec_.demand_order_ref2);
         $ELSE
            NULL;
         $END
      ELSIF (supply_code_db_ = 'SEO')THEN
         -- Clear CO Line information if CO line was generated by transferring sales lines in Component Repair Order.
         $IF (Component_Srvinv_SYS.INSTALLED) $THEN
            Srv_Sales_Lines_API.Undo_Transfer(linerec_.demand_order_ref4);
         $ELSE
            NULL;
         $END
      END IF;
   END IF;
END Cancel_Connected_Order_Line___;

@IgnoreUnitTest NoOutParams
-------------------------------------------------------------------------------------------
-- Pegged_Obj_Start_Operation___
--   This method checks whether the pegged object has already started the operation when
-- cancelling the external Cusomer Order in Inter-Site flow.
-------------------------------------------------------------------------------------------
PROCEDURE Pegged_Obj_Start_Operation___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) 
IS 
   po_order_no_      VARCHAR2(12);
   po_line_no_       VARCHAR2(4);
   po_rel_no_        VARCHAR2(4);
   purchase_type_    VARCHAR2(20);
   supply_code_db_   VARCHAR2(3);
   po_order_no2_     VARCHAR2(12);
   po_line_no2_      VARCHAR2(4);
   po_rel_no2_       VARCHAR2(4);
   purchase_type2_   VARCHAR2(20);
   po_state_         VARCHAR2(50);
   po_contract_      VARCHAR2(5);
   so_order_no_      VARCHAR2(12);
   so_release_no_    VARCHAR2(4);
   so_sequence_no_   VARCHAR2(4); 
   so_state_         VARCHAR2(20);
   so_contract_      VARCHAR2(5);
   int_order_no_     VARCHAR2(12);
   int_line_no_      VARCHAR2(4);
   int_rel_no_       VARCHAR2(4); 
   int_line_item_no_ NUMBER;   
         
   CURSOR get_internal_co_info(po_order_no_ IN VARCHAR2, po_line_no_ IN VARCHAR2, po_rel_no_ IN VARCHAR2) IS
      SELECT order_no, line_no, rel_no, line_item_no, supply_code
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  demand_order_ref1 = po_order_no_
      AND    demand_order_ref2 = po_line_no_
      AND    demand_order_ref3 = po_rel_no_
      AND    demand_code IN ('IPT', 'IPD', 'IPT_RO')
      AND    rowstate != 'Cancelled';
BEGIN
   
   Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no_,
                                                       po_line_no_,
                                                       po_rel_no_, 
                                                       purchase_type_, 
                                                       order_no_,      
                                                       line_no_,       
                                                       rel_no_,      
                                                       line_item_no_);
   IF (po_order_no_ IS NOT NULL) THEN
      OPEN  get_internal_co_info(po_order_no_, po_line_no_, po_rel_no_);
      FETCH get_internal_co_info INTO int_order_no_, int_line_no_, int_rel_no_, int_line_item_no_, supply_code_db_;
      CLOSE get_internal_co_info;
   END IF;
      
   IF (supply_code_db_ IN ('PD', 'PT')) THEN
      Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no2_,
                                                          po_line_no2_,
                                                          po_rel_no2_, 
                                                          purchase_type2_, 
                                                          int_order_no_,
                                                          int_line_no_,
                                                          int_rel_no_,
                                                          int_line_item_no_);
                                                           
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         IF (Purchase_Type_API.Encode(purchase_type2_) = 'O') THEN
            po_state_ := Purchase_Order_API.Get_Objstate(po_order_no2_);
            po_contract_ := Purchase_Order_API.Get_Contract(po_order_no2_);
            IF (po_state_ NOT IN ('Planned', 'Cancelled')) THEN
               Error_SYS.Record_General(lu_name_, 'NOT_CANCEL_ALLOW_PO: It is not possible to cancel the customer order since the purchase order :P1 created in site :P2 is already released. Please unpeg the purchase order or cancel the pegged customer order of that purchase order before canceling this customer order.',po_order_no2_, po_contract_);
            END IF;
         END IF;
      $END
   ELSIF (supply_code_db_ IN ('IPD', 'IPT')) THEN
      Pegged_Obj_Start_Operation___(int_order_no_, int_line_no_, int_rel_no_, int_line_item_no_);
   ELSIF (supply_code_db_ IN ('SO')) THEN
      Customer_Order_Shop_Order_API.Get_Shop_Order(so_order_no_, so_release_no_, so_sequence_no_, int_order_no_, int_line_no_, int_rel_no_, int_line_item_no_);
      IF (so_order_no_ IS NOT NULL) THEN
         $IF (Component_Shpord_SYS.INSTALLED) $THEN
            so_state_ := Shop_Ord_API.Get_State_Db(so_order_no_, so_release_no_, so_sequence_no_);
            so_contract_ := Shop_Ord_API.Get_Contract(so_order_no_, so_release_no_, so_sequence_no_);
            IF (so_state_ NOT IN ('Planned', 'Cancelled', 'Released')) THEN
               Error_SYS.Record_General(lu_name_, 'NOT_CANCEL_ALLOW_SO: It is not possible to cancel the customer order since the shop order :P1 created in site :P2 has already started processing. Please unpeg the shop order before canceling the customer order.',so_order_no_, so_contract_);
            END IF;
         $ELSE
            NULL;
         $END
      END IF;                                                                           
   END IF; 
END Pegged_Obj_Start_Operation___ ; 

PROCEDURE Handle_Staged_Billing___ (
  order_no_        IN VARCHAR2,
  line_no_         IN VARCHAR2,
  rel_no_          IN VARCHAR2,
  line_item_no_    IN NUMBER )
  
IS
   stage_invoiced_         NUMBER;
   CURSOR get_invoiced_stages IS
      SELECT 1
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_
      AND   rowstate     = 'Invoiced';
BEGIN
   OPEN get_invoiced_stages;
   FETCH get_invoiced_stages INTO stage_invoiced_;
   CLOSE get_invoiced_stages;
    
   IF stage_invoiced_ = 1 THEN
      Error_SYS.Record_General(lu_name_, 'INVSTAGEEXIST: The order line may not be cancelled when invoiced stages exist.');
   ELSE
      Order_Line_Staged_Billing_API.Remove_Stage_Lines(order_no_, line_no_, rel_no_, line_item_no_); 
    END IF;
 END Handle_Staged_Billing___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Cancel_Order_Line__
--   Cancel order row if possible.
--   Return new order line state.
--   Return status_code for the order row after cancellation.
PROCEDURE Cancel_Order_Line__ (
   head_objstate_    OUT VARCHAR2,
   line_state_       OUT VARCHAR2,
   info_             OUT VARCHAR2,
   order_no_         IN  VARCHAR2,
   line_no_          IN  VARCHAR2,
   rel_no_           IN  VARCHAR2,
   line_item_no_     IN  NUMBER,
   change_req_flag_  IN  VARCHAR2,
   replicate_change_ IN  VARCHAR2,
   unpeg_ipd_flag_   IN  VARCHAR2,
   change_wo_flag_   IN  VARCHAR2 DEFAULT NULL )
IS
   change_exchg_part_ VARCHAR2(5) := 'FALSE';
   supply_code_db_    VARCHAR2(3);
   po_order_no_       VARCHAR2(12);
   po_line_no_        VARCHAR2(4);
   po_rel_no_         VARCHAR2(4);
   purchase_type_     VARCHAR2(200);
   raise_updt_msg_    BOOLEAN := FALSE;
   raise_noupdt_msg_  BOOLEAN := FALSE;
   pkg_info_          VARCHAR2(32000);
   current_info_      VARCHAR2(32000);

   CURSOR get_supply_code IS
      SELECT supply_code
        FROM customer_order_line_tab
       WHERE order_no = order_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no = line_item_no_;
BEGIN
   head_objstate_ := Customer_Order_API.Get_Objstate(order_no_);
   line_state_    := Customer_Order_Line_API.Get_State(order_no_, line_no_, rel_no_, line_item_no_);

   OPEN get_supply_code;
   FETCH get_supply_code INTO supply_code_db_;
   CLOSE get_supply_code;

   IF (supply_code_db_ = 'DOP') THEN
      Customer_Order_Line_API.Clear_Current_Info();
   END IF;

   IF ((head_objstate_ != 'Planned') AND (replicate_change_ = 'FALSE')) THEN
      IF (supply_code_db_ IN ('PT', 'IPT', 'PD', 'IPD')) THEN
         Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no_, po_line_no_, po_rel_no_, purchase_type_,
                                                             order_no_, line_no_, rel_no_, line_item_no_);
         
         -- The demand information of the connected PO/PR should only be updated for transit deliveries,
         -- not for direct deliveries, becuase there's a possibility that in a PD or IPD order, a delivery
         -- has already been made. However, for a PD line, where only a PR is created so far, it is not needed
         -- to keep the demand info, thus, in such cases, the demand info would be updated.
         IF (supply_code_db_ IN ('PT', 'IPT')) THEN
            raise_updt_msg_ := TRUE;
         ELSIF (supply_code_db_ = 'IPD') THEN
            raise_noupdt_msg_ := TRUE;
         ELSIF (supply_code_db_ = 'PD') THEN
            IF (Purchase_Type_API.Encode(purchase_type_) = 'O') THEN
               raise_noupdt_msg_ := TRUE;
            ELSE
               raise_updt_msg_ := TRUE;
            END IF;
         END IF;
      END IF;
   END IF;
   $IF Component_Wo_SYS.INSTALLED $THEN
      IF(change_wo_flag_='true')THEN 
         Active_Separate_API.Cancel_Wo_For_Co_Line(order_no_, line_no_, rel_no_, line_item_no_);
      ELSIF(change_wo_flag_='false')THEN 
         Active_Separate_API.Disconnect_Wo_From_Co_Line(order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   $ELSE
      NULL;
   $END
   
   Cancel_Order_Line___(pkg_info_, order_no_, line_no_, rel_no_, line_item_no_, change_req_flag_, replicate_change_, change_exchg_part_, unpeg_ipd_flag_, 'FALSE');
   
   IF (supply_code_db_ = 'DOP') THEN
      Client_SYS.Clear_Info;
   END IF;

   IF (raise_updt_msg_) THEN
      Client_SYS.Add_Info(lu_name_, 'CON_POPR_UPDATED: Demand Code on the connected Purchase Order and/or Purchase Requisition has been updated. You may want to check the address related information on Purchase Order/Purchase Requisition :P1.', po_order_no_);
   END IF;
   IF (raise_noupdt_msg_) THEN
      Client_SYS.Add_Info(lu_name_, 'CON_POPR_NOT_UPDATED: This refers to a direct delivery where the connected Purchase Order/Purchase Requisition :P1 will not be updated automatically.', po_order_no_);
   END IF;

   current_info_  := App_Context_SYS.Find_Value('CUSTOMER_ORDER_LINE_API.CURRENT_INFO_');
   current_info_  := SUBSTR(current_info_, (INSTR(current_info_, CHR(31))+1), LENGTH(current_info_));
   info_     := current_info_ || pkg_info_ || Client_SYS.Get_All_Info; 
   pkg_info_ := NULL;
   
END Cancel_Order_Line__;


-- Cancel_Order__
--   Cancel all order lines for the specified order.
--   An order may be cancelled only if it has not been reserved.
--   An order may be cancelled only if no lines have been picked (inventory parts)
--   and now deliveries have been made (non inventory parts
--   Returns the new order state.
PROCEDURE Cancel_Order__ (
   state_            OUT VARCHAR2,
   info_             OUT VARCHAR2,
   order_no_         IN  VARCHAR2,
   change_req_flag_  IN  VARCHAR2,
   replicate_change_ IN  VARCHAR2 )
IS
   so_found_    BOOLEAN := FALSE;
   popr_found_  BOOLEAN := FALSE;
   order_state_ VARCHAR2(20);
   current_info_ VARCHAR2(32000);

   CURSOR connected_orders_exist IS
      SELECT DISTINCT (supply_code)
      FROM  customer_order_line_tab
      WHERE order_no = order_no_
      AND   qty_on_order > 0
      AND   supply_code IN ('SO', 'PT', 'IPT', 'PD', 'IPD');
BEGIN
   order_state_ := Customer_Order_API.Get_Objstate(order_no_);
   
   FOR order_rec_ IN connected_orders_exist LOOP
      IF (order_rec_.supply_code = 'SO') THEN
         so_found_ := TRUE;
      ELSIF (order_rec_.supply_code IN ('PT', 'IPT', 'PD', 'IPD')) THEN
         popr_found_ := TRUE;
      END IF;
   END LOOP;

   Cancel_Order___(order_no_, change_req_flag_, replicate_change_);
   IF (order_state_ != 'Planned') THEN
      IF (so_found_) THEN
         Client_SYS.Add_Info(lu_name_, 'CONNECTED_TO_OTHER: This order contains lines connected to Shop Order.');
      END IF;
      IF ((popr_found_) AND (replicate_change_ = 'FALSE')) THEN
         Client_SYS.Add_Info(lu_name_, 'CON_POPR_EXISTS: Connected Purchase Order(s) and/or Purchase Requisition(s) exists for this order, which you may want to check.');
      END IF;
   END IF;
   state_ := Customer_Order_API.Get_State(order_no_);
   current_info_  := App_Context_SYS.Find_Value('CUSTOMER_ORDER_LINE_API.CURRENT_INFO_');
   current_info_  := SUBSTR(current_info_, (INSTR(current_info_, CHR(31))+1), LENGTH(current_info_));
   info_     := current_info_ || Client_SYS.Get_All_Info;
END Cancel_Order__;

-- This method is called from the Aurena Client from the CancelCustomerOrder.
FUNCTION Cancel_Order__(   
   source_           IN VARCHAR2,
   cancel_reason_    IN VARCHAR2,
   change_req_flag_  IN VARCHAR2,
   replicate_flag_   IN VARCHAR2,
   unpeg_ipd_flag_   IN VARCHAR2,
   change_wo_answer_ IN VARCHAR2,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER ) RETURN VARCHAR2
IS 
   info_             VARCHAR2(32000);
   head_state_       customer_order_tab.rowstate%TYPE;
   line_state_       customer_order_line_tab.rowstate%TYPE;
   change_wo_flag_   VARCHAR2(5) := change_wo_answer_;
BEGIN
   IF (source_ = 'CO') THEN
      IF (cancel_reason_ IS NOT NULL) THEN      
         Customer_Order_API.Set_Cancel_Reason(order_no_, cancel_reason_);
      END IF; 
      Cancel_Customer_Order_API.Cancel_Order__(head_state_, info_, order_no_, change_req_flag_, replicate_flag_);
   ELSIF (source_ = 'COL') THEN
      IF (cancel_reason_ IS NOT NULL) THEN 
         Customer_Order_Line_API.Set_Cancel_Reason(order_no_, line_no_, rel_no_, line_item_no_, cancel_reason_);
      END IF;
      IF (unpeg_ipd_flag_ = 'TRUE') THEN
         change_wo_flag_ := NULL;
      END IF;
      Cancel_Customer_Order_API.Cancel_Order_Line__(head_state_, line_state_, info_, order_no_, line_no_, rel_no_, line_item_no_, change_req_flag_, replicate_flag_, unpeg_ipd_flag_, change_wo_flag_);
   END IF;
   RETURN info_;
END Cancel_Order__;



PROCEDURE Remove_Project_Rev_Conn__ (
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2,
   rel_no_   IN VARCHAR2)
IS 
  CURSOR get_line_pkg_lines IS
     SELECT activity_seq, line_no, rel_no, line_item_no  
       FROM customer_order_line_tab
      WHERE order_no = order_no_
        AND line_no  = line_no_
        AND rel_no   = rel_no_
        AND rowstate IN ('Released', 'Reserved')
        AND activity_seq > 0
        AND line_item_no != 0;
BEGIN
   $IF (Component_Proj_SYS.INSTALLED) $THEN
      FOR linerec_ IN get_line_pkg_lines LOOP
         -- Remove cost connection
         Project_Connection_Util_API.Remove_Connection(proj_lu_name_   => 'COLINE',
                                                       activity_seq_   => linerec_.activity_seq,
                                                       keyref1_        => order_no_,
                                                       keyref2_        => linerec_.line_no,
                                                       keyref3_        => linerec_.rel_no,
                                                       keyref4_        => linerec_.line_item_no,
                                                       keyref5_        => NULL,
                                                       keyref6_        => NULL);
         -- Remove revenue connection
         Project_Connection_Util_API.Remove_Connection(proj_lu_name_   => 'COLINEREV',
                                                       activity_seq_   => linerec_.activity_seq,
                                                       keyref1_        => order_no_,
                                                       keyref2_        => linerec_.line_no,
                                                       keyref3_        => linerec_.rel_no,
                                                       keyref4_        => linerec_.line_item_no,
                                                       keyref5_        => NULL,
                                                       keyref6_        => NULL);              
      END LOOP;
   $ELSE
      NULL;
   $END     
END Remove_Project_Rev_Conn__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Cancel_Order_Line
--   Cancel order line if possible.
PROCEDURE Cancel_Order_Line (
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   change_exchg_part_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
   pkg_info_         VARCHAR2(32000);
   po_order_no_      VARCHAR2(12);
   po_line_no_       VARCHAR2(4);
   po_rel_no_        VARCHAR2(4);
   purchase_type_    VARCHAR2(200);
   change_req_flag_  VARCHAR2(5);
   vendor_no_        VARCHAR2(20);
BEGIN
   Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no_, 
                                                       po_line_no_, 
                                                       po_rel_no_,
                                                       purchase_type_, 
                                                       order_no_, 
                                                       line_no_, 
                                                       rel_no_, 
                                                       line_item_no_);

   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (po_order_no_ IS NOT NULL) THEN      
         vendor_no_        := Purchase_Order_API.Get_Vendor_No(po_order_no_);
         change_req_flag_  := Supplier_API.Get_Send_Change_Message(vendor_no_);                 
      END IF;
   $END

   IF change_req_flag_ = Gen_Yes_No_API.Decode('Y') THEN
      change_req_flag_ := 'TRUE';
   ELSE
      change_req_flag_ := 'FALSE';
   END IF;

   -- Note: replicate change is set to true so connected objects are canceled.
   Cancel_Order_Line___(pkg_info_, order_no_, line_no_, rel_no_, line_item_no_, change_req_flag_, 'TRUE', change_exchg_part_, 'FALSE', 'FALSE');
END Cancel_Order_Line;


-- Cancel_Order
--   Cancel all order lines for the specified order.
--   An order may be cancelled only if it has not been reserved.
--   An order may be cancelled only if no lines have been picked (inventory parts)
--   and now deliveries have been made (non inventory parts).
PROCEDURE Cancel_Order (
   order_no_ IN  VARCHAR2 )
IS
BEGIN
   Cancel_Order___(order_no_, NULL, NULL);
END Cancel_Order;


-- Connected_To_Shop_Order
--   Checks whether a Customer Order is connected to a shop order.
FUNCTION Connected_To_Shop_Order (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR shop_connect IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE supply_code IN ('SO')
      AND order_no = order_no_;

   CURSOR check_lines IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    Qty_Assigned = 0
      AND    Qty_On_Order = 0;

   connected_ NUMBER;
   lines_     NUMBER;
BEGIN
   connected_ := 0;

   OPEN check_lines;
   FETCH check_lines INTO lines_;
   IF (check_lines%NOTFOUND) THEN
     OPEN shop_connect;
     FETCH shop_connect INTO connected_;
     IF (shop_connect%FOUND) THEN
        CLOSE shop_connect;
        CLOSE check_lines;
        RETURN 1;
     ELSE
        CLOSE shop_connect;
        CLOSE check_lines;
        RETURN 0;
     END IF;
   ELSE
      RETURN 0;
   END IF;
END Connected_To_Shop_Order;


-- Int_Cust_Ord_Line_Delivered
--   This method checks if the connected internal customer order has been
--   Reservered, Picked or Delivered. If so, returns a message. If the passed in CO
--   line is a package part line, it loops through all the component lines
--   to check if at least one comp line has its internal CO delivered.
--   This method take in the originating method call type andchecks if the
--   connected internal customer order has been Reservered, Picked or Delivered.
--   If so, returns a message. If the passed in CO
--   line is a package part line, it loops through all the component lines
--   to check if at least one comp line has its internal CO delivered.
FUNCTION Int_Cust_Ord_Line_Delivered (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS 
   warning_      VARCHAR2(2000);
   contract_     VARCHAR2(10);
   
   CURSOR int_component_lines IS
      SELECT line_item_no
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      AND    supply_code IN ('IPT', 'IPD')
      AND    rowstate != 'Cancelled';
BEGIN
    contract_ := Customer_Order_API.Get_Contract(order_no_);
   IF (line_item_no_ >= 0) THEN
      warning_ := Int_Cust_Ord_Line_State_Check(order_no_, line_no_, rel_no_, line_item_no_, contract_, 'CustomerOrderLine');
   ELSE
      FOR rec_ IN int_component_lines LOOP
         warning_ := Int_Cust_Ord_Line_State_Check(order_no_, line_no_, rel_no_, rec_.line_item_no, contract_, 'CustomerOrderLine');
         IF (warning_ IS NOT NULL) THEN
            EXIT;
         END IF;
      END LOOP;
   END IF;
   
   RETURN warning_;
END Int_Cust_Ord_Line_Delivered;


-- Int_Cust_Ord_Line_State_Check
--   This accepts customer order line details or purchase order line details.
--   If customer order details are received, fetches the connected purchase order line details and
--   recursively check for a internal customer order line with states PartiallyDelivered, Delivered, Invoiced, Reserved and Picked.
--   Returns a warning message if a internal customer order line exists with the above states.
--   There are additional checks for Transit and same company flows.
FUNCTION Int_Cust_Ord_Line_State_Check (
   order_ref1_  IN VARCHAR2,
   order_ref2_  IN VARCHAR2,
   order_ref3_  IN VARCHAR2,
   order_ref4_  IN VARCHAR2,
   demand_site_ IN VARCHAR2,
   order_type_  IN VARCHAR2 ) RETURN VARCHAR2
IS  
   warning_msg_      VARCHAR2(2000);
   int_order_no_     VARCHAR2(12);
   int_line_no_      VARCHAR2(4);
   int_rel_no_       VARCHAR2(4);
   int_line_item_no_ NUMBER;
   int_customer_no_  VARCHAR2(20);
   co_line_status_   VARCHAR2(20);
   po_order_no_      VARCHAR2(12);
   po_line_no_       VARCHAR2(4);
   po_rel_no_        VARCHAR2(4);
   supply_site_      VARCHAR2(5);
   demand_code_      VARCHAR2(20);
   part_no_          VARCHAR2(25);
   purchase_type_    VARCHAR2(20);
   inventory_part_   BOOLEAN := FALSE;   

   CURSOR get_internal_co_info(po_order_no_ IN VARCHAR2, po_line_no_ IN VARCHAR2, po_rel_no_ IN VARCHAR2) IS
      SELECT order_no, line_no, rel_no, line_item_no, customer_no, rowstate, contract, demand_code, part_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  demand_order_ref1 = po_order_no_
      AND    demand_order_ref2 = po_line_no_
      AND    demand_order_ref3 = po_rel_no_
      AND    demand_code IN ('IPT', 'IPD', 'IPT_RO')
      AND    rowstate != 'Cancelled';
BEGIN
   IF (order_type_ = 'CustomerOrderLine') THEN
      -- if customer order references are sent to the method, fetch the connected purchae order details
      Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no_,
                                                          po_line_no_,
                                                          po_rel_no_, 
                                                          purchase_type_, 
                                                          order_ref1_,      
                                                          order_ref2_,       
                                                          order_ref3_,      
                                                          order_ref4_);
      -- if connected purchase order details are not found, exit from the method.
      IF (po_order_no_ IS NULL) THEN
         RETURN NULL;
      END IF;      
   ELSE
      po_order_no_ := order_ref1_;
      po_line_no_  := order_ref2_;
      po_rel_no_   := order_ref3_;
   END IF;
   
   -- fetch internal customer order details using purchase order details
   OPEN  get_internal_co_info(po_order_no_, po_line_no_, po_rel_no_);
   FETCH get_internal_co_info INTO int_order_no_, int_line_no_, int_rel_no_, int_line_item_no_, int_customer_no_, co_line_status_, supply_site_, demand_code_, part_no_;
   CLOSE get_internal_co_info;
   
   IF (Site_Discom_Info_API.Get_Exec_Ord_Change_Online_Db(supply_site_) = 'TRUE' AND order_type_ != 'PurchaseOrderLine') THEN
      IF (Customer_Order_Transfer_API.Get_Auto_Change_Approval_User(supply_site_, int_customer_no_) IS NOT NULL) THEN
         RETURN NULL;
      END IF;
   END IF;
   inventory_part_ := Inventory_Part_API.Check_Exist(supply_site_, part_no_);
   
   IF (supply_site_ IS NOT NULL) AND (inventory_part_) AND (demand_code_ IN ('IPD', 'IPT', 'IPT_RO')) THEN
      IF (co_line_status_ IN ('PartiallyDelivered', 'Delivered', 'Invoiced', 'Reserved', 'Picked')) THEN
            warning_msg_ := Language_SYS.Translate_Constant(lu_name_, 'COLSTATEVALIDATE: Internal customer order line(s) in :P1 status exists. Do you still want to cancel? ', 
                                                            NULL, Customer_Order_Line_API.Finite_State_Decode__(co_line_status_));            
            -- if the required condition is satisfied exit from the method
            RETURN warning_msg_;
      ELSE
         --  recursive method call to the next level. For the next level demand site is the current supply site. Order_type is customer order
         --  since we are passing internal customer order line details into the message.
         warning_msg_ := Int_Cust_Ord_Line_State_Check(int_order_no_, int_line_no_, int_rel_no_, int_line_item_no_, supply_site_, 'CustomerOrderLine');
      END IF;
   END IF;
   RETURN warning_msg_; 
END Int_Cust_Ord_Line_State_Check;


FUNCTION Int_Cust_Ord_Delivered (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   warning_ VARCHAR2(2000);

   CURSOR get_co_lines IS 
      SELECT order_no, line_no, rel_no, line_item_no, contract
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    supply_code IN ('IPT', 'IPD')
      AND    rowstate != 'Cancelled';
BEGIN
   FOR rec_ IN get_co_lines LOOP
      warning_ := Int_Cust_Ord_Line_State_Check(order_no_, rec_.line_no,  rec_.rel_no, rec_.line_item_no, rec_.contract, 'CustomerOrderLine');
      IF (warning_ IS NOT NULL) THEN
         EXIT;
      END IF;
   END LOOP;

   RETURN warning_;
END Int_Cust_Ord_Delivered;


----------------------------------------------------------------------------------------------
-- Cancel_Simple_Line
--    This method cancels a customer order line.
--    This is a simplified public interface for Cancel_Simple_Line___.
----------------------------------------------------------------------------------------------
PROCEDURE Cancel_Simple_Line (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER)
IS
BEGIN
   Cancel_Simple_Line___(order_no_ ,
                         line_no_,
                         rel_no_,
                         line_item_no_,
                         'FALSE',
                         'FALSE',
                         'FALSE',
                         'FALSE',
                         'FALSE');
END Cancel_Simple_Line; 

