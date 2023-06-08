-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderFlow
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220125  ErFelk  Bug 161918(SC21R2-7337), Modified Print_Invoices___() to include PRINT_METHOD as PRINT_BACKGROUND for ELSE so that notification is not send when printing.
--  211228  NiDalk  Bug 161737(SCZ-17041), Removed Calc_Charge_Gross_Amount___ and called Customer_Order_Charge_API.Get_Tot_Base_Chg_Amt_Incl_Tax to get the charge value.
--  211206  ThKrlk  Bug 160468(SC21R2-6166), Modified Create_Report_Settings() to get the email if the report id is CUSTOMER_ORDER_IVC_REP  and the email is NULL.
--  211022  ChBnlk   SC21R2-1083, Added Print_Order_Confirmation__ in order to print order confirmation when quick register customer orders.
--  210729  PraWlk  FI21R2-3355, Modified Prepare_Batch_Print__() to exclude orders being selected for the batch if outgoing fiscal note functionality is enabled.
--  210607  KETKLK  PJ21R2-749, Replaced Project Delivery supply code 'PRD' with Project Deliverables supply code 'PJD' as Project Delivery functionality will be removed.
--  210305  ErRalk  Bug 156764(SCZ-13895), Modified Credit_Check() method by deducting prepayment based gross amount from order total and invoiced amount from other_order_totals and removed connected_payments 
--  210305          to prevent the problem with credit limit control.
--  210305  PamPlk  Bug 157341(SCZ-13917), Modified Print_Invoices___() to include PRINT_METHOD so that it can be used to bypass the history comment when an email is not sent.
--  210218  MaRalk  SC2020R1-12637, Modified Proceed_After_Print_Del_Note__ by taking the customer_order_rec_ variable outside conditional compilation block.
--  210208  MaEelk  SC2020R1-12160, Modified Process_All_Orders___, Release___, Print_Delivery_Note___, Calculate_Credit_Used___, Calc_Charge_Credit_Used___, Reserve_Order_Lines__,
--  210208          Proceed_After_Print_Conf__, Proceed_After_Print_Del_Note__ and replaced the calls to Customer_Order_API Get methods with customer_order_rec_. 
--  210208          Modified Calc_Charge_Credit_Used___ and removed the unnecessary call to Payment_Term_API.Get_Exclude_Credit_Limit placed before starting the loop.
--  210208          Modified Calc_Charge_Credit_Used___ and removed the unnecessary call to Return_Material_API.Get_Currency_Code, Return_Material_API.Get_Customer_No_Credit, Return_Material_API.Get_Customer_No.
--  210208          Modified Email_Pro_Forma_Allowed___, Create_Invoice_Allowed__ and replaced the call to Customer_Order_API.Get_Objstate with existing rec_.rowstate.
--  210208          Modified Check_Order_For_Credit_Check and replaced the call Credit_Control_Group_API.Get_Ext_Cust_Crd_Chk_Db with existing credit_control_group_rec_
--  210208          Modified Create_Rma_From_Co_Lines and removed one method call Return_Material_Line_API.Get_Qty_To_Return.
--  210208          Modofied Print_Pick_List and replaced the calls Customer_Order_Pick_List_API Get methods with customer_order_pick_list_rec_. 
--  210208          Modified Create_Rma_Header_From_Co and replaced calls to Site_API Get methods with site_rec_. 
--  210126  Erlise  Bug 157513(SCZ-13293), Modified Release___() to call Customer_Order_API.Check_Rel_Mtrl_Planning() unconditionally so that Release For Material Planning is set when the order is Released.
--  210104  ErRalk  Bug 155652(SCZ-12552), Modified Create_Report_Settings() by removing ClientPrint default parameter and setting PDF_EVENT_PARAM_11 as TRUE.  
--  210104  ChBnlk  SCZ-12704, Modified Manual_Credit_Check__ in order to give InfoMessage when block reason is 'FALSE'.
--  200709  BudKlk  Bug 151107 (SCZ-8062), Modified Email_Order_Report__ and Create_Report_Settings() to append order_no / invoice_no as the report file name using PDF_FILE_NAME parameter.
--  200306  ApWilk  Bug 148585 (SCZ-5249), Modified Process_All_Orders___()in order to handle unconnected charges with the automatic release process.
--  200306  Apwilk  Bug 142414, Modified Process_All_Orders___() and Process_Order__() in order to handle unconnected charges with the automatic release process.
--  200306  ApWilk  Bug 142414, Modified Create_Invoice_Allowed__() to finetune the charge handling functionality.
--  200305  ApWilk  Bug 140700, Modified Create_Invoice_Allowed__() by indroducing a new parameter ivc_unconct_chg_seperatly_ to control and differenciate the 
--  200305          normal and batch process when invoicing the unconnected charges for both normal and collective customers with the newly introduced company level parameter. Also modified Process_Order__()  and Get_Allowed_Operations__()
--  200305          to pass the new parameter where it invokes the method Create_Invoice_Allowed__().
--  200227  Utbalk  GEFALL20-123, Added Start_Print_Invoice method to print and post customer order invoices automatically when Brazilian tax authority approves the fiscal note(invoice) 
--  200113  ErFelk  Bug 151797(SCZ-8457), Modified Email_Order_Report__() by removing the PDF_EVENT_PARAM_11 entry as it is not needed when sending the email. 
--  200102  ErFelk  Bug 151628(SCZ-8094), Modified Email_Order_Report__() by sending TRUE for PDF_EVENT_PARAM_11.
--  191106  Kgamlk  Bug 150846(FIZ-4539), Modified Calc_Line_Gross_Amount___() by considering price_conv_factor_ when calculating tax amount.
--  191011  ErFelk  Bug 149961(SCZ-6400), Modified Reserve_Order_Lines__() by adding Is_Session_Deferred check in the exception block so that the error messages are raised without been cleared off. 
--  191003  Hairlk  SCXTEND-876, Avalara integration, Modified Create_Rma_Charge_Lines__ , Build_Attr_Create_Rma_Lines___ and Create_Rma_Header_From_Co to include CUSTOMER_TAX_USAGE_TYPE to the attr.
--  190930  SURBLK  Added Raise_Report_Picking_Msg___ to handle error messages and avoid code duplication.
--  190709  KiSalk  Bug 149120(SCZ-5052) Modified Modify_License_Address adding parameters demand_code_, demand_order_ref1_, demand_order_ref2_ , demand_order_ref3_ not to fetch again when called in large loops.
--  190606  KiSalk  Bug 148608(SCZ-5328), Reversed the additional changes committed with bug 148475.
--  190528  KiSalk  Bug 148475(SCZ-5184), Replaced obsolete customer order status 'CreditBlocked' with 'Blocked'.
--  190419  Cpeilk  Bug 146399 (SCZ-3367), Modified Deliver_Line_Allowed(), Deliver_Allowed__() and Deliver_With_Diff_Allowed__() by adding condition not to allow deliver
--  190419          the customer order. Modified Allow_Non_Inv_Delivery___() cursor non_inv_delivery_allowed by adding condition to check shipment connection is FALSE.
--  190313  NiNilk  Bug 144016, Modified Create_Report_Settings() method to indicate printing through client print dialog the PDF_EVENT_PARAM_11 to have control on PDF event actions.
--  180830  SeJalk  SCUXXW4-8487, Added Method Get_Allowed_Operations_Desc__.
--  190206  NiNilk  Bug 146641 (SCZ-3132), Modified Create_Report_Settings() by increasing the length of the variable local_email_ to avoid oracle error character buffer too small.
--  180622  ChBnlk  Bug 142668, Modified Calculate_Credit_Used___() by moving the code of fetching curr_rounding_ and use_price_incl_tax_ inside the for loop of 
--  180622          customer order lines in order to fetch them according to the proper order_no.
--  180412  ChJalk  Bug 140475, Modified the method Process_All_Orders___ to raise the error message NOCFGDEFINED only when releasing a customer order.
--  180228  MaEelk  STRSC-17365, Modified Create_Rma_Charge_Lines___ to fetch currency rate from Customer Order Line.
--  180220  MaEelk  STRSC-16336, Added CURRENCY_RATE to the line_attr_ in Build_Attr_Create_Rma_Lines___
--  180215  MAHPLK  STRSC-16909, Modified Calc_Line_Gross_Amount___ and Calc_Charge_Gross_Amount___ to improve performance when calculating tax_dom_amount.
--  180214  SBalLK  Bug 140004, Modified Start_Plan_Picking___() method to execute reservation process online or background according to the order type.
--  171220  RuLiLk  Bug 137426, Modified method Reserve_Order_Lines__ to fetch credit blocked parent details and raise error message accordingly.
--  180117  AsZeLK  Bug 139158, Modified Check_All_License_Connected___ in order to check connected license for non-inventory part.
--  180105  RaVdlk  STRSC-15505, Added conditional compilation to Purchase_Order_API
--  171211  SBalLK  Bug 137084, Added UncheckedAccess annotation to Create_Report_Settings() to skip security check from the client and allowed to fetch contact and email address when needed.
--  171207  SBalLK  Bug 138918, Modified Release___() method to reset mtrl planning flag before creating the connected purchase order for avoid creating change orders.
--  171128  BudKlk  Bug 132164, Modified Print_Invoices___() method to raise the error message NOCORREASON. 
--  171009  NiLalk  Bug 137860, Modified Entire_Order_Reserved__() method call by passing additional parameter for init_shipment_creation.
--  170928  AsZelk  Bug 137972, Modified Print_Order_Confirmation___() and Create_Print_Jobs() in order fix the Number format issue in automatic printed reports.
--  170707  MeAblk  Bug 136433, Modified Create_Print_Pick_List_Hist__() to avoid repeating the order history records for the same picklist no in the same order.
--  170628  MeAblk  Bug 136467, Modified Create_Report_Settings() to avoid setTING PDF_EVENT_PARAM_1 as the customer contact email in order to avoid sending the picklist report to the customer.
--  170523  MeAblk  Bug 135713, Modified Credit_Check_Order() and Reserve_Order_Lines__() to correctly credit block the external CO when processing the internal CO having manually blocked the external customer in an inter-site flow.
--  170515  TiRalk  LIM-11429, Modified Create_Delivery_Notes___ removing IPD check and used deliver_to_customer from delivery note when creating dispatch advice.
--  170510  RaKalk  STRMF-11587, Modified Process_All_Orders___, Release_Order to handle deferred_call parameter.
--  170506  SeJalk  Bug 135341, Modified Calc_Line_Gross_Amount___ by adding parameter rental to prevent calling Rental_Transaction_Manager_API.Sum_Total_Chrg_Days if not a rental line.
--  170506          to improve performance.
--  170504  TiRalk  LIM-11429, Reversed the previous correction.
--  170502  TiRalk  LIM-11429, Modified Create_Delivery_Notes___ to send dispatch advice for direct delivery flows as well.
--  170502  MaRalk  LIM-11449, Modified Print_Pick_List in order to print Consolidated Pick List for Shipment(CO) instead of 
--  170502          Consolidated Pick List for Customer Order for Shipment pick list when printing the report from Shipments overview.
--  170426  BudKlk  Bug 135407, Modified the methods Create_Rma_From_Co_Header() and Create_Rma_From_Co_Lines() to make sure that the default quantity showed in the RMA line and 
--  170426          the RMA charge line are same when the unit charges applied.
--  170403  NiDalk  STRSC-6630, Modified Release___ not to call Customer_Order_API.Calculate_Order_Discount__ when discounts are already calculated.
--  170320  ChBnlk  Bug 128400, Modified Print_Invoices___() to pass the value of 'PRINT_ONLINE' in to the attribute string and modified Create_Print_Jobs() to
--  170320          create the print job only if the report isn't printed online.
--  170307  ShPrlk  Bug 134061, Modified Close_Allowed__ to enable Close in header RMB when 'Cancelled', 'Invoiced/Closed' lines exist.
--  170214  RasDlk  Bug 134087, Modified Modify_License_Address() by adding a condition to call the method Exp_License_Connect_Head_API.Set_Cust_Addr_For_Pkg_Parts()
--  170214          when the customer order line has a package part.
--  170209  MeAblk  STRSC-5724, Modified methods Create_Rma_Charge_Lines___() and Build_Attr_Create_Rma_Lines___() to correctly re-calculate the currency rate when creating the RMA lines from CO.
--  170125  ChBnlk  STRSC-5289, Added new methods Handle_Rma_Allowed___(), Create_Rma_Allowed___() and Edit_Rma_Allowed___() and modifed the method Get_Allowed_Operations__() 
--  170125          to support the RMB operations handle return material authorization, create return material authorization and view/edit return material authorization.
--  161214  MeAblk  Bug 133021, Modified Create_Rma_Charge_Lines___() to avoid passing base_charge_amount since it will be recalculated when creating the RMA line.
--  161208  SeJalk  STRSC-4497, Allowed re reservations for supply types SO and DOP from reserve customer order windows if manually unreserved from customer order.
--  160928  MaEelk  LIM-8868,   Made Print Pick Report functionality worked for the Shipment Flow.
--  160923  DilMlk  Bug 131342, Modified methods Print_Delivery_Note___, Proceed_After_Print_Del_Note__ and Print_Pick_List to assign and pass NULL as result_ variable 
--  160923          for the method call Create_Print_Jobs in order to create and print correct number of instances (delivery note copies) when printing delivery notes.
--  160922  MaEelk  LIM-8562,   Modified Print_Pick_List to print pick list or handling unit pick list according to the option 
--  160922          given in Site/Extended/Sales and Procurement/General Tab.  
--  160912  RoJalk  STRSC-3952, Modified Report_Reserved_As_Picked__ and fixed the issue with parameter order.
--  160831  ChJalk  Bug 130966, Modified Process_Order__ to add order_no_ into the messages RESERVMISSING1 and RESERVMISSING2. 
--  160830  TiRalk  STRSC-3908, Modified Create_Invoice_Allowed__ to avoid creating final invoices when order is manually blocked.
--  160808  TiRalk  STRSC-3788, Modified Create_Manual_Credit_Msg___ by changing messages relevant to manual blocking.
--  160728  TiRalk  STRSC-2799, Added seperate method Customer_Order_Manual_Block to centralise the code for manual blocking.
--  160727  TiRalk  STRSC-2799, Modified Credit_Check_Order to generalise the code for all the blocking types.
--  160725  TiRalk  STRSC-3681, Modified Credit_Check_Order to exclude credit control group for manual blocking.
--  160722  IzShlk  STRSC-3659, Added Validate_Ext_Cust_Ord_Block method to notify, ext cust ord will not blocked automatically when the int cust ord is blocked.
--  160720  Chfose  LIM-7517, Added inventory_event_id to Report_Reserved_As_Picked__ to combine multiple calls to Pick_Customer_Order_API calls a single inventory_event_id.
--  160720  IzShlk  STRSC-3659, Added Manually_Block_Internal_Cust method to manualy block an internal customer.
--  160718  TiRalk  STRSC-2733, Modified Create_Manual_Credit_Msg___ by handling necessary messages if the order is manually blocked.
--  160718  IzShlk  STRSC-3556, Added an additional parameter block_type_ to Check_Order_For_Blocking___ and modified its occurences. 
--  160714  MaEelk  LIM-6499, Added code to create the Handling Unit Pick List in Print_Pick_list.
--  160706  ErFelk  Bug 129892, Modified Reserve_Order_Lines__() by adding 0 instead of -9 to the NVL condition of the Shipment_Id.
--  160705  TiRalk  STRSC-1189, Modified the places where it used Customer_Order_API.Set_Credit_Blocked to Customer_Order_API.Set_Blocked.
--  160704  MaRalk  LIM-7671, Modified Create_Delivery_Notes___ in order to change the parameter source_lang_code_ 
--  160704          for the method call Delivery_Note_API.New.
--  160629  TiRalk  STRSC-2702, Changed the places where it has used CreditBlocked from CustomerOrder has changed to state Blocked.
--  160623  SudJlk  STRSC-2697, Replaced customer_Order_Address_API.Public_Rec with customer_Order_Address_API.Cust_Ord_Addr_Rec and 
--  160623          customer_Order_Address_API.Get() with customer_Order_Address_API.Get_Cust_Ord_Addr().
--  160613  RoJalk  LIM-7680, Replaced Customer_Order_Transfer_API.Send_Dispatch_Advice with Dispatch_Advice_Utility_API.Send_Dispatch_Advice.
--  160608  MaIklk  LIM-7442, Fixed the usages of renaming Customer_Order_Deliv_Note to Delivery_Note.
--  160513  KiSalk  Bug 129163, Since PDF_EVENT_PARAM_4 sends person_id of the contact, if it's not a comm. method, added PDF_EVENT_PARAM_8 to send name of comm. method or name of the contact person.
--  160511	MeAblk  Bug 128921, Converted the method Advance_Invoice_Pay_Check___() into public and modified the file to correctly set the value for blocked_from_state when doing credit block.
--  160308	MeAblk  Bug 127480, Modified Calc_Charge_Credit_Used___, Get_Uninvoiced_Charge_Value___, Create_Invoice_Allowed__ to correctly handle negative charged_qty.
--  160304  ChJalk  Bug 127001, Modifed the method Process_Order___ to add the error message NOINVOICETEXT.
--  160226  RoJalk  LIM-4178, Called Shipment_Order_Utility_API.Start_Shipment_Flow from Process_Order__.
--  160219  MaIklk  LIM-4134, Moved Pick_Shipment_Rec to Shipment Flow and made changes accordingly.
--  160210  MaIklk  LIM-6229, Changed to check the CreditBlocked status in Reserve_Order_Line_Allowed().
--  160201  AyAmlk  Bug 126836, Modified Reserve_Allowed__() in order to prevent returning TRUE for the COs which are credit blocked as they cannot be reserved.
--  160201  MaIklk  STRSC-386, Removed function calls in no_configuration_defined cursor (in Process_All_Orders()) and instead moved that conditions to logic.
--  160201  MeAblk  Bug 126778, Added values for the paramter checking_state_ in the method calls of Customer_Order_API.Set_Credit_Blocked.
--  160201  RasDlk  Bug 126224, Modified Process_Order__ by removing export control check and modified Check_All_License_Connected___
--  160201          to set variables according to the authority level and license connection to be used in client.
--  160128  SeJalk  Bug 125078, Modified Prepare_Batch_Print__ to get the value of the company before the loop.
--  160105  BudKlk  Bug 125949, Modified the method Create_Invoice_Allowed__() by adding a condidtion to return false when the sales contarct is not null, in order to make sure no invoice will create.
--  160104  RoJalk  LIM-5717, Replaced Shipment_Handling_Utility_API.Create_Automatic_Shipments with Shipment_Order_Utility_API.Create_Automatic_Shipments.
--  151222  AyAmlk  Bug 126104, Added the new method Proceed_After_Print_Del_Note__() in order to print the PURCH_MISCELLANEOUS_PART_REP and process the rest of the order flow.
--  151203  KiSalk  Bug 125640, Removed duplicated codes and moved 122833 correction to Create_Rma_Header_From_Co method.
--	151229	HiFelk  STRFI-20, Replaced Customer_info_API.Get_Default_Language_Code with Customer_info_API.Get_Default_Language_Db
--  151221  SeJalk  Bug 125890, Modified Check_Order_For_Credit_Check to over ruled release from credit checked if the manual credit check is performed.
--  151202  RoJalk  LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202          SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151109  MaEelk  LIM-4453, Removed pallet_id from Process_Rental_Transfer_Order.
--  151109  SeJalk  Bug 125508, Modified Print_Invoices___ by changing the name and value of attribute ORIGIN to PRINT_ONLINE to fix the misleading when applying to extensions and customizations.
--  151022  ChJalk  Bug 123410, Modified Prepare_Batch_Print__ to send the value of COMPANY in the attribute string and modified Print_Invoices___ to raise the error message NOINVOICETEXT. 
--  151019  Chfose  LIM-3893, Removed pallet location types in call to Inventory_Part_In_Stock_API.Get_Inventory_Quantity.
--  150915  NaSalk  AFT-1521, Modified Calc_Line_Gross_Amount___. 
--  150910  NaLrlk  AFT-4505, Modified Check_Co_To_Return to disable RMA create option only rental lines exist.
--  150903  MaRalk  AFT-3397, Modified cursor seo_order_delivery_allowed in Allow_Service_Ord_Delivery___ method by
--  150903          replacing the usage of customer_order_join with customer_order_line_tab and customer_order_tab
--  150903          in order to avoid an installation error.
--  150710  Vwloza  RED-414, Updated Calc_Line_Gross_Amount___() with call to Rental_Transaction_Manager_API.Sum_Total_Chrg_Days().
--  150526  IsSalk  KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  150702  JaBalk  RED-496, Modified Process_Rental_Transfer_Order to pass ONLINE_ORDRSP_PROCESSING to rollback the transaction if any errors occur.
--  150702          Passed rental_flag_db_ parameter to Create_Shipment_Pick_Lists__ if the shipment creation is set to At Pick List Creation to make the flow online.
--  150622  JaBalk  RED-557, Added Reserve_Customer_Order_API.Line_Is_Fully_Reserved before deliver the CO line in Process_Rental_Transfer_Order.
--  150619  JaBalk  RED-557, Removed the condition Entire_Order_Reserved__ from Process_Rental_Transfer_Order and added rental_transfer_db_ check 
--  150619          to stop the reservation done in Process_Order__ for rental transfers.
--  150611  ChBnlk  ORA-430, Modified Create_Rma_Lines___() by moving the attribute string manipulation to seperate method. Introduced new method Build_Attr_Create_Rma_Lines___()
--  150611           for the attr_ manipulation. 
--  150605  JaBalk  RED-361, Modified Process_Order__ to by pass the stop of order type event for rental transfer. Sent the rental transfer value to Start_Shipment_Flow.
--  150526  JaBalk  RED-361, Added a new method Create_Rma_Header_From_Co and modified Create_Rma_From_Co_Header, Create_Rma_From_Co_Lines to use this method
--  150526          instead of duplicating codes. Create_Rma_Header_From_Co will be used to create RMA from rental transfer. Added a method Process_Rental_Transfer_Order
--  150526          to reserve the customer order line generated by rental transfer.
--  150429  NWeelk  Bug 122325, Modified Calc_Charge_Credit_Used___, Get_Uninvoiced_Charge_Value___ and Create_Invoice_Allowed__ to retrieve un-invoiced charge lines 
--  150429          correctly by selecting records which has invoiced_qty less than charged_qty instead of using not equal sign.
--  150317  JeLise  COB-143, Moved the fetch of check_ext_customer_ out of the CASE section in Check_Order_For_Credit_Check.
--  150317  Vwloza  PRPJ-167, Added ELSE condition with an error message in Process_Order__().
--  150820  JeeJlk  Bug 122977, Modified Deliver_Allowed__ and added Allow_Service_Ord_Delivery___ to enable deliver when two stagepicking is enabled and order lines are from a service order.
--  150820  ErFelk  Bug 123331, Modified Reserve_Order_Lines__() so that it prevent calling Proceed_After_Pick_Planning__() if the CO line is connected to a shipment.
--  150817  RasDlk  Bug 120649, Modified Check_All_License_Connected___, Check_Export_Controlled___, Check_Order_Release_Allowed__ 
--  150817          and Modify_License_Address to set the licensed_order_type_ correctly.
--  150728  ShKolk  Bug 123092, Modified Create_Print_Jobs() to set COPIES option to support StreamServe reports.
--  150618  NWeelk  Bug 123054, Modified Print_Invoices___ by making attr_ an IN OUT parameter and called Print_Invoices online if the origin is from frmChangeCustomerInvoice,
--  150618          modified Create_Print_Jobs by making result_ an IN OUT parameter to pass result_key_ to print invoice online.
--  150528  ChJalk  Bug 122833, Modified the methods Create_Rma_From_Co_Lines and Create_Rma_From_Co_Header to add field SUPPLY_COUNTRY_DB into the attribute string for creating the Return Material Header.
--  150429  NWeelk  Bug 122325, Modified Calc_Charge_Credit_Used___, Get_Uninvoiced_Charge_Value___ and Create_Invoice_Allowed__ to retrieve un-invoiced charge lines 
--  150429          correctly by selecting records which has invoiced_qty less than charged_qty instead of using not equal sign.
--  150226  NaLrlk  PRSC-6295, Modified Check_Co_To_Return(), Create_Rma_From_Co_Header() and Check_Co_Lines_To_Return() to allow CRA ownership for non rentals.
--  150220  JeLise  PRSC-5837, Modified Manual_Credit_Check__, Credit_Check and Check_Order_For_Credit_Check.
--  150218  MeAblk  EAP-1042, Modified Print_Order_Confirmation___ in order to avoid sending pdf info when printing the order confirmation if the emaling is not ebaled for the customer.
--  150215  HimRlk  Modified Create_Rma_Charge_Lines___() to pass currency_rate when creating a new RMA charge line.
--  150210  KiSalk  Bug 120976, Added Print_Invoices___ and called it in Start_Print_Invoice__ to create a printing background job per every invoice, to reduce waiting time for  
--  150210          the job execution, if large number of invoices printed in one call.
--  141219  KoDelk  Bug 120305, Modified Prepare_Batch_Print__() only to call the Start_Print_Invoice__() when print_attr_ is not null.
--  141218  RuLiLk  PRSC-2213, Added new method Get_Translated_State() which gives the client value of the db_state of a given logical unit in the given language.
--  141217  JeLise  PRSC-2190, Added parameter prefix_ to Create_Manual_Credit_Msg___ to add internal/external to make the messages more clear.
--  141212  MaIklk  EAP-835, Removed email checks (defined in customer/order/misc) related to email performa invoice and order confirmation operations.
--  141211  KiSalk  PRSC-2839, In Print_Invoice___ stop sending email address in attribute string to Customer_Order_Inv_Head_API.Print_Invoices call when media_code_ has value. 
--  141208  JeLise  PRSC-2190, Added call to Check_Order_For_Credit_Check and Customer_Order_Line_API.Get_External_Cust_Order in 
--  141208          Manual_Credit_Check__, to make the manual credit check work more in line with the automatic credit check.
--  141127  MAHPLK  PRSC-2774, Modified Check_No_Previous_Execution___ method to use overloaded 
--  141127          Transaction_SYS.Get_Posted_Job_Arguments which returns plsql table.
--  141126  DilMlk  Bug 117609, Modified Create_Rma_Lines___() to pass the PRICE_CONV_FACTOR.
--  141121  NWeelk  Bug 119845, Modified Create_Report_Settings to handle pick list reports as well and called Create_Report_Settings from Print_Pick_List to set the pdf parameters when printing the pick list reports.  
--  141028  KoDelk Bug 119343, Modified Create_Rma_Lines___ using attribute values instead of Customer_Order_API.Get() because they are now fetched by Return_Material_Line_API.Get_Co_Line_Data()
--  141020  MalLlk  Bug 119205, Modified Create_Rma_Lines___() and Create_Rma_From_Co_Lines() to consider multiple values of 
--  141020          internal_po_no and customer_po_no when creating RMA lines from CO lines.  
--  140820  KiSalk  Bug 117755, Moved history creation in Print_Pick_List to new method Create_Print_Pick_List_Hist__. 
--  140815  ErFelk  Bug 118240, Modified Check_Dist_Order_State___() by adding a condition to cursor get_do_details to filter out Cancelled demand orders.  
--  140730  RoJalk  Modified session_id_ parameter to be NOT NULL in Customer_Order_Transfer_API.Send_Direct_Delivery.
--  140710  TiRalk  Bug 117129, Modified Email_Order_Report__ by adding print_job_id_.
--  140421  AyAmlk  Bug 116437, Modified Process_Order__() so that the Direct Delivery message will not be sent when the delivery refers to a transit delivery.
--  140415  ShVese  Replaced the usage of CUSTOMER_ORDER_JOIN in Deliver_Allowed__,Deliver_With_Diff_Allowed__ and Deliver_Line_Allowed.
--  140415  ShVese  Added method Allow_Non_Inv_Delivery___.
--  140409  NipKlk  Bug 115981, Added a the CUSTOMER_ORDER_COLL_IVC_REP to the if statement when emailing the invoice specification in the method Email_Order_Report__() 
--  140409  NipKlk  Bug 115981, Added a call to Customer_Order_Inv_Head_API.Create_Invoice_Appendices method from the Email_Order_Report__ method  to print and email invoice specification whenever a invoice is emailed.     
--  140404  PeSulk  Modified Calc_Line_Gross_Amount___ to use rental_chargeable_days_ when calculating amounts for rental lines.
--  140407  BudKlk  Bug 114536, Removed the staged_lines_to_invoice cursor from Create_Invoice_Allowed__() method and created an implementaion method Staged_Lines_To_Invoice___(), 
--  140407          with that cursor in order to display a warning message, when try to create an invoice for a collective invoice.
--  140401  NWeelk  Bug 112778, Modified methods Release_Order, Process_Order__ and Check_Export_Controlled___ to prevent automatically releasing and reserving
--  140401          a CO created from PO when the part is export controlled.
--  140326  AyAmlk  Bug 113893, Modified Deliver___() by removing the Cust_Order_Event_Creation_API.Order_Delivered() method call since this
--  140326          is handled in Customer_Order0_API.Finite_State_Machine___().
--  140321  NWeelk  Bug 110675, Modified method Create_Print_Jobs by adding parameter pdf_info_ to get the pdf parameters when 
--  140321          printing the report and added method Create_Report_Settings.
--  140318  NaSalk Modified Process_Order__ to check invoiceable lines before invoice creation.
--  140307  BudKlk Bug 115788, Modified the Process_Order__ method in order to send email order confirmation in the quick order floor, 
--  140307         when the print order confirmation is unchecked and email order confirmation is checked.
--  140210  ChBnlk Bug 113704, Modified Process_Order__() to add a warning message to be displayed at pick list creation if there's a 
--  140210         configuration mismatch between customer order lines in demand and supply sites. 
--  140205  BudKlk Bug 115052, Modified the Prepare_Batch_Print__() method by adding a check only to send the emails for the customers who have invoices emailed checked.  
--  131203  SBalLK Bug 114134, Modified Credit_Check() method to consider invoicing customer when order validate for credit amount.
--  131105  MalLlk Bug 113403, Modified Prepare_Batch_Print__ to use customer no correctly when fetching the customer's email. Renamed the variable temp_customer_no as temp_customer_no_. 
--  131016  SURBLK Modified info_msg_ in Create_Manual_Credit_Msg___() and Manual_Credit_Check__() to add release order from block state in manual credit check. 
--  130830  HimRlk Merged Bug 110133-PIV, Modified method Calc_Line_Gross_Amount___ by renaming base_sale_unit_price_ to sale_unit_price_ and adding unit_price_incl_tax_, 
--  130830         calculations are done using order currency, then final values are converted to base currency.
--  130830         Calculation logic of the method is modified to consider price including tax and modified discount calculations to tally with invoice postings.
--  130830         Modified methods  Calculate_Credit_Used___, Get_Uninvoiced_Order_Value___ to pass sale_unit_price to Calc_Line_Gross_Amount___ instead of  base_sale_unit_price and to pass unit_price_incl_tax_.
--  131021  RoJalk   Corrected code indentation issues after merge.
--  130909  ChBnlk Bug 112076, Added new method Proceed_After_Print_Conf__ to continue the customer order flow after printing the order confirmation.
--  130819  TiRalk Bug 109294, Modified Print_Order_Confirmation___, Print_Delivery_Note___, Do_Print_Proforma_Invoice__, Print_Pick_List by removing 
--  130819         common code and moved that code to Create_Print_Jobs  and Printing_Print_Jobs to handle creating/printing new print jobs. 
--  130819         Also when fetching the printer_id it was added the language code to fetch the default printer correctly.
--  130815  KiSalk Bug 109618, Modified Calc_Line_Gross_Amount___ and Calc_Charge_Gross_Amount___ to fetch tax percentage from cust_order_line_tax_lines_tab and cust_ord_charge_tax_lines_tab
--  130815         because records are always stored for taxable part and charge lines. Removed unnecessary parameter fetching and passing through other methods those call these methods.
--  130730  RuLiLk Bug 110133, Modified logic of method Calc_Line_Gross_Amount___, Calculations are done using order currency, then final values are converted to base currency.
--  130730         Modified methods  Calculate_Credit_Used___, Get_Uninvoiced_Order_Value___ to pass sale_unit_price to Calc_Line_Gross_Amount___ instead of  base_sale_unit_price.
--  130702  SWiclk Bug 107700, Modified Process_Order__() in order to reset purch number in order_coordinator_group_tab if something goes wrong when 
--  130220         releasing a customer order in intersite flow.
--  130630  RuLiLk Bug 110133, Modified method Calc_Line_Gross_Amount___() by modifying Calculation logic of line discount amount to be consistent with discount postings.
--  130625  AyAmlk Bug 108970, Modified Create_Rma_Lines___() and Check_Co_Lines_To_Return() to pass NULL for rma_no_ and rma_line_no_ in Get_Ivc_Line_Data() and Get_Co_Line_Data() method calls.
--  130620  AyAmlk Bug 110764, Modified Generate_Next_Level_Demands___() by filtering the CURSOR query by part_ownership.
--  130617  ChBnlk Bug 110313, Modified Prepare_Batch_Print__() by removing the checks for order_id_ when unpacking invoice types.
--  130613  IsSalk Bug 110270, Modified method Release___() to set Release for Material Planning during the CO release.
--  130916  MAWILK BLACK-566, Replaced Component_Pcm_SYS.
--  130719  NaSalk Modifed Process_Order__ to create rental transactions if any due transactions exist.
--  130618  NaSalk Modified Create_Invoice_Allowed__ to consider rental transactions.
--  130513  NaSalk Modified Create_Rma_From_Co_Lines to allow creating RMA lines for rental ownerships.
--  130705  MaIklk TIBE-978, Removed global constants and used conditional compilation instead.
--  130903  MAHPLK Modified Process_Order__ to trigger the shipment flow if the order type uses priority reservations.
--  130813  SURBLK Renamed Check_Order_For_Blocking as Check_Order_For_Blocking___ and added parameter checking_state_. 
--  130718  MAHPLK Modified Print_Pick_List method to use report_id SHIPMENT_CONSOL_PICK_LIST_REP for shipment consolidated pick lists.
--  130715  JeeJlk Added new method Create_Manual_Credit_Msg___ and Manual_Credit_Check__ to support manual credit check.
--  130620  ChFolk Modified Create_Rma_Lines___ to exclude PO info when rma line is created from CO as it is only valid when returning to the same delivery site or the supplier.
--  130515  SURBLK Modified Advance_Invoice_Pay_Check___ and Modified Credit_Check_Order() to credit check in external customer as well.
--  130424  MaMalk Modified several methods needed to support for combining 2 shipment creation methods exist for pick list creation to 1.
--  130417  JeeJlk Modified Create_Delivery_Notes___ to pass originating_co_lang_code to Customer_Order_Deliv_Note_API.New.
--  130405  MAHPLK Modified parameter list of the Create_Pick_List_API.Create_Shipment_Pick_Lists__ in Process_Order__.
--  130228  UdGnlk Added comments to Create_Rma_Lines___().   
--  130327  ChFolk Reverse previous correction done in Create_Rma_From_Co_Header and Create_Rma_From_Co_Lines as it is handled in RMA.
--  130327  UdGnlk Modified Create_Rma_Lines___() to pass the correct qty to return inv uom when multisite functionality.
--  130325  ChFolk Modified Create_Rma_From_Co_Header and Create_Rma_From_Co_Lines to get the ship_via_code and delivery_terms from customer when creating rma from CO or CO line.
--  130313  UdGnlk Modified Create_Rma_Lines___() to pass the correct qty to return when multisite functionality.  
--  130306  UdGnlk Added receipt_rma_line_no_ OUT parameter to Create_Rma_Line_From_Co_Line() and Create_Rma_Lines___().  
--  130214  ChFolk Modified Create_Rma_From_Co_Lines and Create_Rma_From_Co_Header to add retrun_address nto the message attribute.
--  130201  ChFolk Added new method Create_Rma_Line_From_Co_Line which is a public interface to Create_Rma_Lines___. Modified Create_Rma_Lines___ to use qty_to_return if it is send in rma_attr_.
--  130130  ChFolk Modified Create_Rma_From_Co_Header and Create_Rma_From_Co_Lines to include attribute return_from_custome_no.
--  120123  MaMalk Modified Process_Order__ to add another paramater to Create_Pick_List_API.Create_Shipment_Pick_Lists__.
--  130118  RoJalk Modified Create_Pick_List_Allowed__ and included the condition cor.shipment_id = 0.
--  130111  RoJalk Modified Create_Pick_List_Allowed__ to enable pick list creation if the order line is shipment connected
--  130111         with shipment_creation in CREATE NEW AT PICKLIST, ADD TO EXIST AT PICKLIST. 
--  130109  ChFolk Modified Create_Rma_From_Co_Header and Create_Rma_From_Co_Lines to include return_to_contract.
--  121120  MeAblk Added parameter shipment_id_ into the method call Customer_Order_Line_API.Make_Service_Deliverable__.
--  121113  UdGnlk Modified Create_Rma_Lines___ to pass purchasing information to rma line.
--  121102  RoJalk Allow connecting a customer order line to several shipment lines - modified Reserve_Order_Lines__, Start_Plan_Picking__, Start_Plan_Picking___ to handle shipment id.  
--  121030  MaMalk Modified methods Report_Reserved_As_Picked__ and Reserved_As_Picked_Allowed__ to exclude the shipment connected lines when pick report the reserved quantity directly.
--  121101  ChFolk Modified Create_Rma_Lines___ to pass conv_factor and inverted_conv_factor from CO to rma when create rma from CO.
--  120918  ChFolk Modified Create_Rma_From_Co_Header and Create_Rma_From_Co_Lines to add order_no in rma header if only one order is selected.
--  120829  MaEelk Modified Process_Order__ to remove the condition checked if the entire order is shipment connected in the during the Reserve Operation.
--  120824  MeAblk Removed shipment type parameter from the methods Shipment_Handling_Utility_API.Create_Automatic_Shipments, Release___.
--  120730  MaEelk Modified Process_Order__ not to allow the reserve operation when the entire order is shipment connected.
--  120712  MaEelk Added condition to Start_Plan_Picking___ that would make a check for the online processing in shipment flow.
--  120711  RoJalk Added the shipment type parameter to the Shipment_Handling_Utility_API.Create_Automatic_Shipments method calls.Added shipment_type_ parameter to the Release___ method. 
--  120710  MaEelk Added condition Transaction_SYS.Is_Session_Deferred to Start_Plan_Picking___ not to start another background job 
--  120710         when another background job already exists in the session.
--  130530  PraWlk Bug 109943, Modified Generate_Next_Level_Demands___() by adding condition_code and removing the parameter disp_qty_ when calling Order_Supply_Demand_API.
--  130530         Generate_Next_Level_Demands() as the disp_qty_ calculation logic moved to Order_Supply_Demand_API.Generate_Next_Level_Demands. 
--  130521  ChJalk EBALL-72, Modified methods Check_Co_Lines_To_Return and Create_Rma_From_Co_Header to avoide creating Return Material Lines for part exchange order lines.
--  130508  KiSalk Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  130411  SWiclk Bug 109080, Modified Create_Rma_Lines___() in order to pass the correct attribute string.
--  130325  SWiclk Bug 109080, Modified Create_Rma_Charge_Lines___() in order to pass the tax liability correctly. 
--  130211  SBalLK Bug 107364, Modified Release___() to stop create shipment when customer is credit blocked.
--  130124  Erlise Bug 107414, In method Report_Reserved_As_Picked__, removed call to Check_All_License_Connected___.
--                 The export control check is done in the client instead. New method Check_All_License_Connected.
--  121107  PraWlk Bug 105742, Optimized method Print_Pick_List_Allowed__() by combining cursors get_pick_list_no and is_consolidated_picked.
--  121107         Also modified Get_Allowed_Operations__() to avoid irrelevent operations when executing through customer order header.
--  121005  RoJalk Bug 100221, Modified Get_Allowed_Operations__ and added new methods Email_Order_Conf_Allowed___, Email_Pro_Forma_Allowed___ 
--  121005         to include validations for email order confirmation and email pro forma invoice. Added method Get_Email_Address__ to get 
--  121005         email address of the internal purchase order ref or the customers email address for a specified order.   
--  121016  GiSalk Bug 105492, Added new procedure Check_No_Previous_Execution. Added new implementation function Get_Job_Arguments___ and implementation procedure 
--  121016         Check_No_Previous_Execution___ and removed the implementation  procedure Check_No_Previous_Execution___ introduced by the bug 103639.
--  121016         Modified Process_All_Orders___ by calling Check_No_Previous_Execution() before calling the deferred call for Customer Order release.
--  120925  SURBLK Modified Create_Rma_Charge_Lines___ by adding CHARGE_AMOUNT_INCL_TAX and BASE_CHARGE_AMT_INCL_TAX.
--  120924  JeeJlk Modified Create_Rma_From_Co_Header to send use price.
--  120924  JeeJlk Modified Create_Rma_From_Co_Header, Create_Rma_From_Co_Lines to send use price incl tax value.
--  120903  SeJalk Bug 103639, Added Check_Previous_Execution___() and modified Process_All_Orders___() to avoid creating more than one background job for method
--  120903         Process_From_Release_Order__ and prevent e-mailing multiple customer order conformations.
--  120827  NiDalk Bug 103690, Modified Process_Order__ by rearranging the code which has been added for credit block flow
--  120827         to prevent proceed the credit block CO until closed, when there are more than one background job.   
--  120823  KiSalk Bug 104802, In Process_All_Orders___, changed if conditions so that order_no_ is assigned with a value when name_ = 'ORDER_NO' irrespective of availability of LU ConfigurationSpec.
--  120424  JeeJlk Modified method Prepare_Batch_Print__ to sort the invoices by invoice customer identiy so that invoices may 
--  120424         be printed in the order of invoice customer name.
--  120319  RoJalk Modified Create_Delivery_Notes___ and passed the correct values to fetch the media code.  
--  120312  MaMalk Bug 99430, Modified the code to consider inverted_conv_factor where conv_factor has been considered.
--  120312  RoJalk Modified the method call Customer_Order_API.Calculate_Order_Discount__ to support default null parameters.
--  120229  TiRalk Reversed the Bug 77713 since the print server is no longer available in APP8.
--  120213  NaLrlk Bug 96456, Modified methods Print_Invoice___ and Process_Order__ to enable emailing of invoice and order confirmation only if the customer
--  120213         is allowed to receive them through email.
--  120124  IsSalk Bug 100671, Modified method Reserve_Order_Lines__ by adding new status info for blocked orders.
--  120118  DaZase Added calls to Sales_Promotion_Util_API.Check_Unutilized_O_Deals_Exist/Cust_Order_Event_Creation_API.Unutilized_Promo_Deal_At_Release in Relase___ method.
--  120112  MAHPLK Modified Credit_Check method to handle the credit check.
--  120103  DaZase Added unpacking of new attribute SALES_PROMOTION_CALCULATED in Process_Order__ and send this new flag as parameter into method Release___ to avoid extra sales promotion calculations when doing release from client.
--  111219  Darklk Reversed previous correction modifying the method Release_Allowed__ to enable releasing the CO without any lines.
--  111205  MaMalk Added pragma to Get_Allowed_Operations__.
--  111202  MaMalk Added pragma to Check_Co_To_Return and Check_Co_Lines_To_Return.
--  111201  MaMalk Removed General_SYS in Create_Invoice_Allowed__ since we added pragma to the method specification.
--  111013  JaBalk Modified Prepare_Batch_Print__ to pass the correct invoice type. 
--  111001  NaLrlk Bug 93036, Modified the function Process_Order__ to get the default media code when the message class is INVOIC.
--  110825  JaBalk Modified Prepare_Batch_Print__ to print the invoices if media code is null when selecting Print Only option.
--  110822  SaJjlk Bug 94883, Modified method Email_Order_Report__ to send the customer language for the report_attr_.
--  110816  JaBalk Modified Prepare_Batch_Print__ to print the invoices according to the value entered in invoice date offset field.
--  110815  ChJalk Bug 93946, Restructured the method Create_Rma_Lines___ to get the required values from the method 
--  110815         Return_Material_Line_API.Get_Co_Line_Data instead of getting values from several method calls. Modified the methods Create_Rma_From_Co_Header 
--  110815         and Create_Rma_From_Co_Lines to construct the attr_ out side the loops.
--  110811  JaBalk Modified Prepare_Batch_Print__ to fetch the Company_Invoice_Info_API.Get(company_) inside the company param.
--  110809  JaBalk Modified Prepare_Batch_Print__ to add media code condition to Email selection.
--  110808  JaBalk Modified Prepare_Batch_Print__ to select the records according to the value in order_id_.
--  110804  JaBalk Added methods Prepare_Batch_Print__, Validate_Params in order to schedule the print jobs.
--  110802  MaEelk Replaced the obsolete method call Print_Server_SYS.Enumerate_Printer_Id with Logical_Printer_API.Enumerate_Printer_Id.
--  110726  SudJlk Bug 97685, Modified Process_Order__ to pass NULL as location_group to Create_Pick_List_API.Create_Shipment_Pick_Lists__.
--  110701  JuMalk Bug 96811, Modified cursor get_order_lines in method Check_Mandatory_Postings___.
--  110701  JuMalk Bug 97017, Modified methods Create_Rma_From_Co_Header and Create_Rma_From_Co_Lines by adding JINSUI_INVOICE_DB to the attribute string. 
--  110629  TiRalk Bug 77713, Modified procedure Print_Pick_List to create new print job based on foundation1 parameter 
--  110629         'Print Server Pdf-archiving setup' using Print_Job_API.New_Print_Job().
--  110629  PraWlk Bug 77713, Modified procedure Print_Delivery_Note___ to create new print job based on foundation1 parameter 
--  110629         'Print Server Pdf-archiving setup' using Print_Job_API.New_Print_Job().  
--  110530  RiLase Added constant db_true_.
--  110526  RiLase Modified Process_All_Orders___ to process all steps online if online processing is set on the order type.
--  110524  IsSalk Bug 97128, Modified Create_Delivery_Notes___ to include component parts of package parts by removing codes added by bug 93524.
--  110510  NaLrlk Modified the method Release_Allowed__ to check for at least order lines or charge lines exist.
--  110420  MaMalk Modified Create_Rma_Lines___ and Create_Rma_Charge_Lines___ to pass the Delivery_Type to the RMA Line and RMA Charge. 
--  110120  LaRelk Merged bug 78644 to solve error in best price feature branch.
--  110303  MaMalk Passed the tax liability of the CO Line when the RMA Line is created from a CO.
--  101109  Cpeilk Bug 94151, Changed the view name from sales_part to sales_part_pub.
--  101018  ChFolk Modified Release___ to add the new parameter for method call  Customer_Order_Charge_Util_API.Calc_Consolidate_Charges.
--  100727  AmPalk Bug 92006, In Create_Rma_From_Co_Header and Create_Rma_From_Co_Lines, allowed all the charges to be included, 
--  100727         since order lines from PartiallyDelivered state get added to the RMA.
--  100713  ChFolk Removed method Calculate_Discount_Allowed__ as bonus functionality is obsoleted.
--  100622  RaKalk Bug 88111, Instead using 3 dynamic calls used call Customer_Credit_Info_API.Fetch_Credit_Info in Credit_Check. 
--  100622         A performance increase expected in CO reservation process with bulcky data set.
--  100920  PaWelk Modified Credit_Check() by reversing the correction done in bug 88111.
--  101103  NiDalk Bug 93981, Modified Email_Order_Report__ to include REPLY_TO_USER parameter.
--  101027  Cpeilk Bug 93658, Allowed non inventory part delivery when two stage picking is allowed in methods Deliver_Allowed__, 
--  101027         Deliver_With_Diff_Allowed__ and Deliver_Line_Allowed. 
--  101025  NiDalk Bug 93524, Modified Create_Delivery_Notes___ to exclude component parts from the cusror get_line.
--  100823  AmPalk Bug 92005, Modified Create_Rma_Lines___ to add internal_po_no_,  or Customer_Po_No.
--  100727  AmPalk Bug 92006, In Create_Rma_From_Co_Header and Create_Rma_From_Co_Lines, allowed all the charges to be included, 
--  100727         since order lines from PartiallyDelivered state get added to the RMA.
--  100721  AmPalk Bug 92005, Modified Create_Rma_From_Co_Header and Create_Rma_From_Co_Lines by sending 
--  100721         customer ref, document and delivery addresses from the 1st order header that creates RMA. Modified Create_Rma_Lines___ to add Customer_Po_No.
--  100623  ChJalk Bug 78644, Modified method Create_Rma_Lines___ to add QTY_TO_RETURN_INV_UOM when creating a RMA Line.
--  100621  NWeelk Bug 89889, Modified method Process_Order__ to send the invoice_id to PCMSCI side once the invoice is created.
--  100513  Cpeilk Bug 90573, Modified Create_Rma_Lines___ to include configuration id when creating a new Return Material line.
--  100614  JeLise Added charge_cost_percent_, charge_percent_basis_ and base_charge_percent_basis_ in Create_Rma_Charge_Lines___.
--  100517  Ajpelk Merge rose method documentation
--  100430  NuVelk Merged Twin Peaks.
--  100506  RaKalk Bug 90314, Modified Reserve_Order_Lines__ function to check the credit blocked flag of ordering customer.
--          RaKalk Bug 90314, Modified Credit_Check procedure to check if the ordering customer is credit blocked.
--  100426  MaMalk Bug 90223, Modified Email_Order_Report__ to send the Purchase Order No when emailing Customer Order Reports.
--  100318  MalLlk Bug 88626, Modified Email_Order_Report__ to send order no or (series id + invoice no) as the PDF_EVENT_PARAM_6.
--  100308  JuMalk Bug 88889, Modified code to add a condition before check for mandatory postings in Check_Mandatory_Postings___.
--  100218  SuThlk Bug 88694, Added logic to send the Pay Tax information to Rma Lines in Create_Rma_Lines___.
--  100119  AmPalk Bug 88111, Instead using 3 dynamic calls used call Customer_Credit_Info_API.Fetch_Credit_Info in Credit_Check. 
--  100119         A performance increase expected in CO reservation process with bulcky data set.
--  100118  AmPalk Bug 88299, Modified Process_Order__ to create shipments only if the CO status is not CreditBlocked in the CREATE_PICK_LIST event.
--  100115  SuJalk Added a condition to stop orders from being released if CO lines with configured parts have incomplete configurations.
--  090429  Ersruk Added validations for project unique sale in Release___.
--  091222  KiSalk Changed Sort_Lines_By_Date_Entered___ re-insert data starting from oth row.
--  090930  MaMalk Removed unused function Get_Invoiced_Unposted_Total___. Modified Sort_Lines_By_Date_Entered___, Release___, Create_Rma_Charge_Lines___, Create_Invoice_Allowed__,
--  090930         Report_Reserved_As_Picked__, Credit_Check, Check_Order_For_Credit_Check, Create_Rma_From_Co_Lines and Create_Rma_Charge_Lines___ to remove unused code.
--  --------------------------------- 14.0.0 ---------------------------------
--  100309  Kisalk Added CHARGE to attribute string in Create_Rma_Charge_Lines___.
--  100111  SudJlk Bug 87997, Modified method Create_Invoice_Allowed__ to include invoicing customer in the invoicing allowing logic.
--  091222  SudJlk Bug 87997, Reverse bug 86969 and modified method Create_Invoice_Allowed__.
--  091217  SudJlk Bug 86969, Modified method Create_Invoice_Allowed__ to correctly handle invoicing allowing logic.
--  091210  JuMalk Bug 85282, Modified the WHERE condition in cursor plan_pick in method Reserve_Allowed__ to consider the supply code 'IPT' and 'PT' 
--  091210         when there is a qty to reserve and added qty_assigned when considering supply_code 'PT'.
--  091202  ShKolk Bug 86199, Rollback bug 69675.
--  091123  ErFelk Bug 86516, Modified Process_Order__ by changing the condition which was added previously. 
--  091112  SudJlk Bug 86969, Modified method Create_Invoice_Allowed__ to to handle NULL values when checking companies to see if invoice creation is allowed.
--  091111  SudJlk Bug 86969, Modified method Create_Invoice_Allowed__ to restrict invoice creation for internal COs in the same company with an external invoicing customer.
--  091110  NWeelk Bug 86942, Modified Process_Order__ to retrieve the correct e-mail address when there exist a separate invoice customer. 
--  091026  ErFelk Bug 86516, Modified Process_Order__ by restricting Shipment Creation when order is partially reserved and backorder option is
--  091026         'NO PARTIAL DELIVERIES' or 'ALLOW PARTIAL ORDER DELIVERY'.
--  091014  AndDse Bug 86306, Modified procedure Check_Mandatory_Postings___.
--  091008  NWeelk Bug 86342, Modified Create_Rma_From_Co_Lines by introducing a PL/SQL table Ord_Line_Details_Table to store
--  091008         the details of customer order line sent from the Overview - Customer Order Lines to create the RMA. 
--  090901  ChJalk Bug 82611, Added methods Print_Proforma_Invoice__ and Do_Print_Proforma_Invoice__.
--  090819  ChJalk Bug 80025, Modified cursors get_pkg_comp_lines and get_charge_lines in method Create_Rma_From_Co_Lines.  
--  090804  ChJalk Bug 80025, Added IN parameter add_charge_lines_ to the methods Create_Rma_From_Co_Header and Create_Rma_From_Co_Lines 
--  090804         and modified those methods to add charge lines into the RMA depending on the values of that parameter.
--  090804         Added method Create_Rma_Charge_Lines___. 
--  090720  NaLrlk Bug 78948, Modified the method Start_Print_Invoice__ to handle background description for resend invoice.
--  090720  NaLrlk Bug 78948, Modified the method Process_Order__ to check whether the DIRDEL is setup for the customer when Customer_Order_Transfer_API.Send_Direct_Delivery() is called.
--  090720         Added attr value CONNECTED_OBJECTS in method Print_Invoice___ to handle connect documents in the automatic customer order flow.
--  091021  RiLase Added check in Release__ when calling Sales_Promotion_Util_Api.Calculate_Sales_Promotion().
--  090618  SudJlk Bug 83945, Modified methods Sort_Lines_By_Date_Entered___, Start_Plan_Picking___ and Start_Plan_Picking__.
--  090810  DaGulk Bug 83694, Modified SELECT statement in method Cancel_Allowed__ to check whether pick_list_no exist in customer_order_reservation_tab.
--  090528  SudJlk Bug 80756, Modified method Cancel_Allowed__ to enable Cancel Order option for reserved customer orders.
--  090406  SudJlk Bug 80630, Modified methods Start_Plan_Picking__ and Sort_Lines_By_Date_Entered___ and added overloaded method Start_Plan_Picking__ and implementation method Start_Plan_Picking___.
--  090401  SudJlk Bug 81698, Modified method Validate_Struc_Ownership to handle serial parts with consignment as ownership.
--  090401  NWeelk Bug 80130, Modified the Function Create_Invoice_Allowed__ to check whether a prepayment invoice is available. 
--  090219  NWeelk Bug 80212, Modified procedures Create_Rma_From_Co_Header and Create_Rma_From_Co_Lines 
--  090219         to add CUSTOMER_NO_CREDIT, CUSTOMER_NO_CREDIT_ADDR_NO and CURRENCY_CODE to attr_ and
--  090219         modified Procedure Create_Rma_Lines___ by adding CURRENCY_RATE to the parameter list.  
--  090211  ChJalk Bug 79802, Modified the method Credit_Check to avoid sending unposted_totals into Cust_Credit_Info_Util 
--  090211         when checking credit as it is calculated in Cust_Credit_Info_Util methods.
--  090116  MalLlk Bug 78783, Modified the data type of work_order_no_ to NUMBER in Print_Pick_List and Print_Delivery_Note___.
--  081216  SaJjlk Bug 78884, Modified method Print_Pick_List___ to be a public method.
--  081201  SaRilk Bug 77918, Modified Process_Order__ to handle Create_Pick_List_API.Create_Pick_List__ out parameter of Create_Pick_List_API.Pick_List_Table type.
--  081104  ChJalk Bug 76959, Renamed Create_Rma_From_Lines to Create_Rma_From_Co_Lines and made the method Create_Rma_Lines an implementation method.
--  081104         Modified the methods Create_Rma_From_Co_Header and Create_Rma_From_Co_Lines. 
--  081031  ChJalk Bug 76959, Added methods Check_Co_To_Return, Check_Co_Lines_To_Return, Create_Rma_From_Co_Header, Create_Rma_From_Lines and Create_Rma_Lines.
--  081025  MaMalk Bug 78015, Modified Email_Order_Report__ to send the our reference as the PDF_EVENT_PARAM_5.
--  081007  MaMalk Bug 76899, Modified cursor reserve_allowed in Reserve_Order_Line_Allowed and plan_pick cursor in Reserve_Allowed__ to remove the part no check for supply code SEO.
--  081007         Modified Reserve_Order_Lines__ to call Customer_Order_Line_API.Make_Service_Deliverable__ for supply code SEO.
--  081006  NaLrlk Bug 77264, Reverse some changes done in bug 72413 in the methods Calculate_Credit_Used___, Calc_Charge_Credit_Used___, Get_Uninvoiced_Order_Value___
--  081006         and Get_Uninvoiced_Charge_Value___.
--  081001  DaZase Bug 76868, Modified method Reserved_As_Picked_Allowed__ so Shipment creation at pick list stage is not allowed.
--  080723  MaRalk Bug 75379, Modified cursor reserve_allowed in Reserve_Order_Line_Allowed and plan_pick cursor in Reserve_Allowed__.
--  090702  RiLase Added call to Sales_Promotion_Util_Api.Calculate_Sales_Promotion() in Release__.
--  090701  MiKulk Modified the function Create_Invoice_Allowed__, to avoid allowing invoices when only Promotion type charges exist.
--  081223  KiSalk In Release___, condition removed from Customer_Order_Charge_Util_API.Calc_Consolidate_Charges call.
--  081028  MaJalk In Process_Order__, Set online order release when order type is online processing.
--  080930  KiSalk In Process_Order__, the error message raised if not a deferred call. 
--  080918  AmPalk Modified Release___ by adding code to consolidate freight charges.
--  080516  KaEllk Bug 73810, Modified method Release___ to refresh cost for project connected order lines after Customer Order is released.
--  080416  NaLrlk Bug 72413, Modified methods Calculate_Credit_Used___, Calc_Charge_Credit_Used___, Get_Uninvoiced_Order_Value___ and Get_Uninvoiced_Charge_Value___ to move 
--  080416         the calls Get_Pay_Term_Id and Get_Exclude_Credit_Limit outside the loops in order to performance enhance.
--  080305  Asawlk Bug 71806, Modified method Process_Order__ to print or send a delivery note printed or sent before.
--  080201  ChJalk Bug 70889, Modified Process_Order__ to call Cust_Ord_Customer_Address_API.Get_Email instead of Customer_Order_API.Validate_Email__.
--  080130  NaLrlk Bug 70005, Added parameter del_terms_location to server call Customer_Order_Deliv_Note_API.New() in tme method Create_Delivery_Notes___.
--  080123  ThAylk Bug 69675, Modified procedure Process_Order__ and added parameter modified_report_ to Print_Delivery_Note___.
--  071231  MaJalk Bud 69814, Modified method Process_Order__ to be able to email Order Confirmation Report as an attached pdf file.  
--  071231         Added cust_email_addr_ as a parameter to the method Print_Invoice___ and modified. 
--  071221  MaMalk Bug 68249, Modified Calculate_Credit_Used___ to remove the prepayment amounts considered when calculating the credit used.  
--  071221         Modified the Credit_Check to deduct the payments from open_order_value.       
--  071218  MaJalk Bug 69814, Changed method Email_Order_Report as private.
--  071211  MaJalk Bug 69814, Added new method Email_Order_Report to be able to send email to customer contact email address with attached pdf.
--  071130  NaLrlk Bug 69207, Modified the method Calculate_Credit_Used to correct the return value.
--  070801  NuVelk Bug 65015, Modified the cursor reserve_allowed in the function Reserve_Allowed__.
--  070625  ChBalk Bug 64900, Modified procedure Print_Order_Confirmation___ to create new print job based on
--  070625         foundation1 parameter 'Print Server Pdf-archiving setup' using Print_Job_API.New_Print_Job
--  070519  NiDalk Modified Report_Reserved_As_Picked__ to consider back_order_option.
--  070515  Cpeilk Bug 60944, Modified procedure Print_Pick_List___ to avoid repeating Picklist Printed history message in the order line history for serial parts.
--  070514  JoAnSE Added check for NOT NULL invoice_id_ before printing invoice from Process_Order__
--  070512  SenSlk LCS Merge 62880, Modified the cursor in Create_delivary_note__ to select demand code of the customer order.
--  070512         Move the automatic dispatch advice code part in to the loop.
--  070509  Cpeilk Modified method Reserve_Order_Lines__ and Check_Order_For_Credit_Check.
--  070425  NiDalk Added methods Report_Reserved_As_Picked__ and Reserved_As_Picked_Allowed__.
--  070328  SuSalk LCS Merge 63028, Modified Process_Order__ to add the new parameter order_no_ to calls Send_Direct_Delivery.
--  070306  NaLrlk Added the new method Print_Delivery_Note, Modified the method Create_Delivery_Notes___.
--  070227  AmPalk Modified Deliver_With_Diff_Allowed__, Deliver_Allowed__ and Deliver_Line_Allowed to return 0 if Use_Pre_Ship_Del_Note_Db is 'TRUE' at the Customer Order.
--  070215  ChBalk Modified Calculate_Credit_Used___ to support credit management when PBI invoice.
--  070214  ChBalk Modified Start_Print_Invoice__ method which now can be possible to Send Invoices for the second time.
--  070208  NaLrlk B140590-Added new methods Process_From_Reserve__, Start_Reserve_Order__ and Modified the method Process_All_Orders___.
--  070205  PrPrlk Reordered the parameters in the calls to Shipment_Handling_Utility_API.Create_Automatic_Shipments.
--  070205  PrPrlk Made changes to the method Process_Order__ when the event is "CREATE_PICK_LIST" to call the method Create_Pick_List_API.Create_Shipment_Pick_Lists__.
--  070130  PrPrlk Made changes to the method Process_Order__ when the event is "CREATE_PICK_LIST" to handle connecting of CO Lines to shipments
--  070130         and creating Shipment Pick Lists for them where shipment creation method is specified to be 'CREATE NEW AT PICKLIST' or 'ADD TO EXIST AT PICKLIST'.
--  070130         Added additional check consolidation != 'SHIPMENT' to the method Print_Pick_List_Allowed__ to prevent the Shipment Pick Lists from being printed automatically.
--  070125  NaWilk Bug 62555, Modified method Credit_Check to prevent checking credit for orders that have a
--  070125         Payment Term with 'Exclude from Credit Limit Control' ticked.
--  070122  NaWilk Removed parameters Del_terms_desc and Ship_via_desc from Customer_Order_Deliv_Note_API.Get_Preliminary_Delnote_No
--  070122         and Customer_Order_Deliv_Note_API.New.
--  070122  MaJalk Renamed Pick_Plan_Order_Lines__, Plan_Picking_Allowed__ to Reserve_Order_Lines__, Reserve_Allowed__.
--  070110  NaLrlk Removed the ALLOW PARTIAL ORDER DELIVERY backorder_option in next_event = &RESERVE Process_Order__.
--  070109  NiDalk Modified Deliver_Line_Allowed to handle package components for package parts.
--  070108  NiDalk Renamed method Plan_Picking_Of_Line_Allowed to Reserve_Order_Line_Allowed.
--  061228  NiDalk Modified Pick_Plan_Order_Lines__ to reserve package parts as whole and modified Plan_Picking_Of_Line_Allowed.
--  061227  NiDalk Modified Deliver_Line_Allowed and Plan_Picking_Of_Line_Allowed to include package parts.
--  061220  NaLrlk Modified the info message in next_event = &RESERVE Process_Order__
--  061127  MaJalk Added ALLOW PARTIAL ORDER DELIVERY at method Process_Order__.
--  061125  KaDilk Bug 61168, Modified functions Deliver_With_Diff_Allowed__ and Plan_Picking_Allowed__.
--  061114  NaLrlk Removed parameter allow_backorders_ in Start_Plan_Picking__ and attr ALLOW_LINE_BACKORDERS from Pick_Plan_Order_Lines__.
--  061110  MiErlk Bug 59639, Modified the method call Reserve_Order_Line__ in Pick_Plan_Order_Lines__.
--  061023  ChBalk Modified Advance_Invoice_Pay_Check___ method to facilitate unpaid prepayment invoices.
--  061023  NaLrlk B139829, Changed error message to warning message in Check_Manual_Tax_Lia_Date___.
--  061012  MaJalk Changed error message at Check_Manual_Tax_Lia_Date___.
--  061009  MaJalk Added new function Check_Manual_Tax_Lia_Date___.
--  060828  IsWilk Bug 59520, Removed wrong parameter when calling Inventory_Part_In_Stock_API.Get_Inventory_Quantity
--  060828         in PROCEDURE Generate_Next_Level_Demands___.
--  060824  Cpeilk Modified method Check_Order_For_Credit_Check.
--  060822  Cpeilk Added methods Credit_Check_Order, Check_Order_For_Credit_Check. Modified method Check_Order_For_Blocking. Added new
--                 parameter to method Check_Order_for_Blocking inside methods Release___ and Release_Source_Line__.
--  060811  DaZase Added an extra check in Process_All_Orders___ so we dont start another background job when already in a background job.
--  060615  MaJalk Bug 58475, At Pick_Plan_Order_Lines__, Added method call Customer_Order_API.Set_Credit_Blocked when customer is credit blocked.
--  060524  MiKulk  Changed the coding to remove LU dependancies.
--  060424  IsAnlk Enlarge Supplier - Changed variable definitions.
--  060420  MaJalk Enlarge Customer - Changed variable definitions.
--  --------------------------------- 13.4.0 ---------------------------------
--  060310  DaZase Removed handling of print_tax_db_ in some methods.
--  060216  MaRalk Bug 55958, Modified PROCEDURE Create_Delivery_Notes___.
--  060215  IsAnlk Modified Close_Allowed__to avoid component parts.
--  060124  JaJalk Added Assert safe annotation.
--  060104  JaJalk Removed the obsolete method Batch_Pick_Plan_Orders__ which was used to create Shedule task
--  060104         as it is no longer used with the new implementation of Schedule tasks.
--  060102  IsAnlk Modified Create_Invoice_Allowed__ to improve the performance.
--  051129  ThGulk   Bug 54587, Modified Method Release__, added an error message for condition_code and restructured the code.
--  051104  GeKalk Removed onhand_analysis_flag parameter from Pick_Plan_Order_Lines__ and Batch_Pick_Plan_Orders__.
--  051103  GeKalk Removed onhand_analysis_flag parameter from the start_pick_plan method.
--  051101  IsAnlk Made Credit_Check__ as public and added new methods Advance_Invoice_Pay_Check___, Check_Order_for_Blocking.
--  051013  ChJalk Bug 53718, Modified PROCEDURE Credit_Check__ to get the credit limit considering the company credit limit as well.
--  051011  Cpeilk Bug 53688, Added a new method Sort_Lines_By_Date_Entered___ and removed method Sort_Lines_By_Order___
--  051011  KeFelk Added Site_Discom_Info_API in some places for Site_API.
--  051003  SuJalk Changed Reference in cursor get_valid_sites to user_allowed_site_pub.
--  050921  NaLrlk Removed unused variables.
--  050729  SaJjlk Modified method Create_Delivery_Notes___ to send despatch advice automatically.
--  050621  IsAnlk Added where condition col.provisional_price ='FALSE'
--                 to the cusrsor staged_lines_to_invoice in Create_Invoice_Allowed__.
--  050607  IsAnlk Added WHERE condition col.provisional_price_db ='FALSE'
--  050607         to the cursor deliveries_to_invoice in Create_Invoice_Allowed__.
--  050527  MaEelk Added WHERE condition col.blocked_for_invoicing_db ='FALSE
--  050527         to the cursor deliveries_to_invoice in Create_Invoice_Allowed__
--  050505  LaBolk   Bug 50111, Added method Close_Line_Allowed__. Restructured logic of Close_Allowed__.
--  050505           Modified a cursor in Create_Invoice_Allowed__ to disallow creation of invoices when the staged billing line is already invoiced.
--  050422  JoEd   Added check on incorrect flag in Create_Invoice_Allowed__.
--  050411  JoEd   Added Delivery Confirmation check to Get_Allowed_Operations__.
--  050404  GeKalk Modified Deliver_Line_Allowed to check if an order line not connected to shipment is allowed to be delivered.
--  050328  PrPrlk Bug 49003, Removed the check done for closed tolerence in method Deliver_Allowed__.
--  050314  GeKalk Added new method Check_Dist_Order_State___ and modified Release___ to release the connected Dos.
--  050308  MaMalk Bug 49387, Modified the procedure Create_Delivery_Notes___ in order to improve the performance of cursor get_line.
--  050304  GeKalk Modified Create_Pick_List_Line_Allowed to return the correct value.
--  050222  GeKalk Modified Create_Pick_List_Line_Allowed to simplify the cursor.
--  050216  IsAnlk Modified SHIPMENT_CONNECTED as VARCHAR2 and changed the code accordingly.
--  050215  GeKalk Added new methods Plan_Picking_Of_Line_Allowed, Create_Pick_List_Line_Allowed, Report_Picking_Of_Line_Allowed,
--  050215         Create_Del_Note_Line_Allowed, Start_Create_Pick_List, Start_Create_Delivery_Note.
--  050128  DaZase Moved Release_Ctp_Planned_Lines___ to Connect_Customer_Order_API and removed
--                 all calls to this method since it will now be called from Generate_Connected_Orders.
--  050121  ChJalk   Bug 49032, Modified PROCEDURE Process_Order__ to exit the loop if the Customer Order is Credit Blocked.
--  050117  NuFilk Modified Create_Pick_List_Allowed__.
--  050113  DaZase Added error check in Release_Ctp_Planned_Lines___ to check on latest_release_date.
--  050113  SaJjlk Removed methods Deliver_Shipment_Allowed__, Get_Allowed_Ship_Operations__,
--                 Pick_Plan_Shipment__, Pick_Report_Shipment_Aloowed__ and Plan_Pick_Shipment_Allowed__.
--  050112  HoInlk Bug 48912, Modified Print_Pick_List___ to add order line history for consolidated pick lists.
--  050110  DaZase Modified Release_Ctp_Planned_Lines___ so it now calls method in Interim_Ctp_Manager_API instead of Interim_Order_Int_API.
--  050105  IsAnlk Modified cursors in Pick_Plan_Shipment__ and Create_Invoice_Allowed__ to allow normal creation of invoice.
--  050103  JaBalk Modified Release___ to create shipment.
--  041228  MaJalk Bug 48481, Added a condition for the event RESERVE in procedure Process_Order__.
--  041217  ChJalk Bug 47792, Modifeid Calc_Line_Gross_Amount___ to consider Additional Discount in calculting net_base_amount_ .
--  041215  ToBeSe Bug 48597, Modified Print_Deliv_Note_Allowed__ to not allow delivery notes in state 'Printed'.
--  041130  IsAnlk Modified Start_Print_invoice__() to send more than one invoices.
--  041101  DiVelk Added 'PS' to cursors in Plan_Picking_Allowed__ and Plan_Pick_Shipment_Allowed__.
--  041018  DaZase Added 'PI' and 'PRD' to cursor in method Plan_Picking_Allowed__.
--  040930  SaRalk Modified procedures Process_Order__ and Print_Order_Confirmation___.
--  040908  DiVelk Removed method Start_Pick_Plan_Orders__.
--  040831  KeFelk Removed contact & modified deliver_to_customer_no in Create_Delivery_Notes___.
--  040826  GeKalk Added an ew public method Close_Allowed.
--  040824  ChBalk Bug 45847, Added more parameters in Get_Inventory_Quantity, so next_level_demand will generate correctly with correct qty_on_hand.
--  040817  DhWilk Inserted General_SYS.Init_Method to Get_Allowed_Operations__ & Create_Invoice_Allowed__
--  040812  MaJalk Bug 46348, Added ROLLBACK to procedure Pick_Plan_Order_Lines__.
--  040812  GeKalk Modified Release___ to modify the call to Distribution Order.
--  040728  WaJalk Modified procedure Create_Delivery_Notes___.
--  040709  GeKalk Modified Finite_State_Set___ to call the check_state of Distribution Order.
--  040701  IsJalk Modified  Credit_Check__ to handle enhanced customer credit control (for allowed overdue amount and days).
--  040630  GeKalk Removed Release_Connected_Do_Po___ .
--  040629  WaJalk Modified procedure Create_Delivery_Notes___.
--  040629  GeKalk Add a check before Release_Connected_Do_Po___ in Process_Order__.
--  040625  GeKalk Added new method Release_Connected_Do_Po___.
--  040622  GeKalk Modified Release___ to release Connected Distribution Order.
--  040622  LaBolk Modified parameter of method Process_From_Release_Order and restructured the code.
--  040616  GeKalk Added public method Process_From_Release_Order to call the private method Process_From_Release_Order__ from out side the module.
--  040610  MiKalk Bug 41488, Modified method Create_Invoice_Allowed__ to check the state of the order and return FALSE if it's
--  040610         in state 'Invoiced'. Modified 'collect' to 'COLLECT' in the cursor charges_to_invoice in Create_Invoice_Allowed__.
--  040609  VeMolk Bug 45251, Modified the method Plan_Picking_Allowed__ to allow the reservation for orders with supply code 'SEO'.
--  040603  Asawlk Bug 44860, Modified procedure Process_Order__, made exit_loop_ TRUE only when CO is in state 'Planned'.
--  040531  Asawlk Bug 44860, Modified procedure Process_Order__.
--  040429  IsWilk Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs.
--  040426  MaMalk   Bug 37374, Modified Process_All_Orders___ to change the error message.
--  040331  ChJalk   Bug 43762, Removed FUNCTION Create_Del_Note_Allowed.
--  ************************ Touch Down Merge End******************************
--  040224  GaJalk   Modified the function Create_Invoice_Allowed__.
--  040202  GaJalk   Modified the function Create_Invoice_Allowed__.
--  ************************ Touch Down Merge Begin****************************
--  040414  LaBolk Modified method Start_Pick_Plan_Orders__ to change the validation of contract in accordance with Scheduled Task validation.
--  040315  ChJalk Bug 42562, Added FUNCTION Create_Del_Note_Allowed.
--  040224  IsWilk Removed the SUBSTRB from the view for Unicode Changes.
--  040211  PrTilk Bug 41402, Mpdified methods Print_Pick_List___, Print_Pick_List_Allowed__. Added code to get the
--  040211         consolidated data from the new ConsolidatedOrders lu.
--  040129  GeKalk Rewrote the DBMS_SQL to Native dynamic SQL and remove the length parameter of existing
--                 IN bind variables for UNICODE modifications.
--  ********************* VSHSB Merge END  *************************
--  021120  PrInLk Modified the method Pick_Report_Shipment_Allowed__ to avoid picking and reserving
--                 at shipment state in 'Complete'.
--  021113  PrInLk Modified the method Plan_Pick_Shipment_Allowed__ to avoid picking and reserving
--                 at shipment state 'Close' and 'Complete'.
--  020318  GeKa  Changed the CURSOR deliveries_to_invoice in FUNCTION Create_Invoice_Allowed__.
--  020314  GeKa  Changed the CURSOR deliveries_to_invoice in FUNCTION Create_Invoice_Allowed__.
--  020312  GeKa  Changed the CURSOR deliveries_to_invoice in FUNCTION Create_Invoice_Allowed__.
--  020503  MaGu  Added call to General_SYS.Init_Method in methods Get_Allowed_Ship_Operations__,
--                Plan_Pick_Shipment_Allowed__, Pick_Report_Shipment_Allowed__ and Deliver_Shipment_Allowed__.
--  020423  MaGu  Modified method Get_Allowed_Ship_Operations__.
--  020411  MaGu  Added methods Get_Allowed_Ship_Operations__, Plan_Pick_Shipment_Allowed__,
--                Pick_Report_Shipment_Allowed__ and Deliver_Shipment_Allowed__.
--  020212  MaGu  Added method Pick_Plan_Shipment__.
--  020301  MaGu  Added checks so that order lines connected to a Shipment are prevented from entering
--                the standard order flow. Checks added in methods Report_Picking_Allowed__,
--                Deliver_Allowed__, Create_Delivery_Notes___, Deliver_With_Diff_Allowed__ and
--                Create_Invoice_Allowed__.
--  ********************* VSHSB Merge *****************************
--  040120  GeKalk   Replaced INSTRB with INSTR for UNICODE modifications.
--  --------------------------------------- 13.3.0 ------------------------------------------
--  031106  SeKalk   Modified information messages in procedure Validate_Struc_Ownership
--  031104  NuFilk   LCS 37855, Modified the procedure Process_Order__ to handle delivery note printing and sending.
--  031104           The patch has been modified and applied as suitable for the new functionalities introduced.
--  031022  JoEd     Removed unnecessary package logic in Release___.
--  031008  PrJalk   Bug Fix 106224, Changed incorrect General_Sys.Init_Method calls.
--  031002  ZiMoLk   Removed the patch for BUG 37855 and the post corrections done to the patch.
--  031002           And Applied the Bug 36032 correction.
--  030901  NuFilk   CR Merge 02
--  030827  NaWalk   Code Review Performed.
--  **************************** CR Merge 02 ************************************
--  030820  ChBalk   Merge changes from Chain Reaction project.
--  030729  ThGulk   Open Cursors Closed.
--  030716  NaWalk   Removed Bug coments.
--  030707  NuFilk   Merged Bugs 37102, 36907, 36301, 36560, 35939, 34466, 34728, and 34824,
--  030610  NuFilk   Added method Release_Source_Line__ and Modified Release_Source_Line.
--  030603  WaJalk   Modified Release_Source_Line to give an error message.
--  030529  NuFilk   Modified Release___ and Release_Source_Line to consider Revised Qty Due instead of Buy Qty Due.
--  030526  WaJalk   Modified General_SYS.Init_Method in Release_Source_Line.
--  030523  WaJalk   Added method Release_Source_Line.
--  030522  NuFilk   Modified method Release___ to create CO lines for fully sourced CO lines,
--  030522           and to modify package part details also.
--  030505  DaZa     All occurences of acquisition type/mode changed to supply code.
--  ----------------------------------- CR MERGE -------------------------------
--  030806  MaGulk   Bug 100586, Modified Validate_Struc_Ownership string manipulation
--  030730  SaNalk   Performed SP4 Merge.
--  030728  SuAmlk   Modified type of variable number_series_ in the Procedure Create_Delivery_Notes___.
--  030724  MaEelk   Added Tags to information messages in Validate_Struc_Ownership.
--  030721  MaGulk   Added Validate_Struc_Ownership for persistent part ownership check
--  030718  GeKalk   Changed a method in Generate_Next_Level_Demands___ with the new method Inventory_Part_In_Stock_API.Get_Inventory_Quantity().
--  030708  ChFolk   Reversed the changes that have been done for Advance Payments.
--  030529  SuAmlk   Modified the position of creating the Miscellaneous Part Appendix report in
--                   procedures Print_Pick_List___ & Print_Delivery_Note___.
--  030527  SuAmlk   Added report_type to the parameter_attr_ for PURCH_MISCELLANEOUS_PART_REP in Print_Pick_List___.
--  030523  SuAmlk   Modified Procedure Print_Delivery_Note___ & Print_Pick_List___ to print Miscellaneous Part Report.
--  030522  SuAmlk   Modified Procedure Print_Pick_List___ to print Miscellaneous Part Report (Pick List Appendex).
--  030510  ThPalk   Bug 37102, Added an error message to Start_Pick_Plan_Orders__ and Batch_Pick_Plan_Orders__ when site is invalid.
--  030422  KaDilk   Bug 36907, Modified the function Close_Allowed__ to compare the
--  030422           qty_picked with buy_qty_due.
--  030402  SuAmlk   Moved two more lines to the FOR LOOP in the procedure Print_Delivery_Note___.
--  030401  ErSolk   Bug 36301, Modified function Close_Allowed__.
--  030328  JaBalk   Bug 36560, Reverse the correction of bug 34728.
--  030328  SaRalk   Bug 35939, Removed cursors get_delivery_terms, get_ship_via_desc and variable ship_via_desc_,
--                   delivery_terms_ and delivery_terms_desc_ in Procedure Create_Delivery_Notes___.
--  030327  SuAmlk   Modified the position of FOR LOOP in the procedure Print_Delivery_Note___.
--  030321  ChIwlk   Added a FOR LOOP inside procedure Print_Delivery_Note___ to print multiple
--                   delivery note copies.
--  030320  SaRalk   Bug 35939, Modified the Procedure Create_Delivery_Notes___.
--  030226  ThAjLk   Bug 35939, Modified the Procedure Create_Delivery_Notes___.
--  030113  KaDilk   Bug,34466, Modified the function Close_Allowed__() to disable RMB 'Close Order'
--  030113           when the header state is 'Invoiced' or 'Cancelled'.
--  030312  Ravilk   Modified the Procedure Calc_Charge_Credit_Used___and two functions Get_Uninvoiced_Charge_Value___,Get_Uninvoiced_Order_Value___.
--  030228  SuAmlk   Code Review.
--  030211  PrJalk   Merged TakeOff changes
--  020910  JoAnSe   Replaced view with table in cursor get_tax_lines in Calc_Line_Gross_Amount___
--  -----------------------TSO Merge---------------------------------------------
--  030130  SuAmlk   Modified Procedure Create_Delivery_Notes___ to generate Alternative Delivery Note Number.
--  030129  AjShlk   Code Review.
--  030121  Ravilk   Modified the Procedure Calculate_Credit_Used___.
--  030103  KaDilk   Bug,34466, Modified the function Close_Allowed__() to include rowstate 'Invoiced'
--  030103           that enables RMB 'Close Order'.
--  030102  SaRalk   Bug 34728, Modified function Create_Invoice_Allowed__.
--  021220  ChJalk   Bug 34824, Modified WHERE condition of the CURSOR credit_used in Calculate_Credit_Used___ and
--  021220           CURSOR charge_credit_used in Calc_Charge_Credit_Used___.
--  021213  Asawlk   Merged bug fixes in 2002-3 SP3
--  021212  KaDilk   Bug 34466, Modified the function  Close_Allowed__() to include rowstate 'Cancelled'
--  021212           that enables RMB 'Close Order'.
--  021230  UsRalk   Merged SP3 changes.
--  021002  Hecese   Bug 32477, Rewrote function Close_Allowed__ so it will go through the the order lines to
--                   check if Close Order is allowed on the header.
--  020917  JoAnSe   Merged the IceAge bugg corrections below onto the AD 2002-3 track.
--  ------------------------------------- IceAge Merge End ----------------------
--  020628  MIGUUS   Bug 31336, Added error message in Pick_Plan_Order_Lines__ when customer is credit block.
--  020410  RoAnse   Made calls to Customer_Credit_Info_API dynamic in PROCEDURE Credit_Check__
--                   in order to avoid installation errors.
--  020319  MAJE     Bug 28506, Print Delivery Note even when sending Direct Delivery message.
--  020325  ROALUS   Call 80237 Release___ method modified to change spelling of Acquisition
--  020322  ROALUS   Call 80038 revisited for cosmetic message change.
--  020322 SaKaLk    Call 77116(Foreign Call 28170). Added county to calling methods in Customer_Order_Deliv_Note_API
--                   'New' and 'Get_Preliminary_Delnote_No' parameter list.
--  020621  Memeus   Bug 28188, added validation on cursor get_order_lines inside method Check_Mandatory_Postings___.
--  020621  Memeus   Bug 28190, added validation on cursor check_not_decided inside method Release___.
--  020319  ROALUS   Call 80038, Process_All_Orders___ modified to display error for cfg parts without cfg during Release
--  020319  MAJE     Bug 28506, Print Delivery Note even when sending Direct Delivery message.
--  020304  CaStse   Modified cursor credit_used in Calculate_Credit_Used___ and charge_credit_used in Calc_Charge_Credit_Used___
--                   for performance reasons. Added check if credit limit is used in Credit_Check__.
--  020226  Memeus   Bug 28149, corrected misspelled oreder.
--  020226  CaStse   Bug fix 18709, Modified cursor deliver_allowed in Deliver_Allowed__.
--  020109  GaJalk   Bug fix 27084, Added the ship_via_desc in the cursor get_line in the procedure Create_Delivery_Notes___.
--                   The selected ship_via_desc is passed in the call to Customer_Order_Deliv_Note_API.Get_Preliminary_Delnote_No.
--  010123  NaWalk   Bug fix 25302, Allowed recoreds in status Planed to be reprinted,in function Reprint_Order_Conf_Allowed___().
--  011010  DaZa     Bug fix 23647, a small fix in methods Calculate_Credit_Used___ and Calc_Charge_Credit_Used___.
--  010926  DaZa     Bug fix 23647, Added new methods Calc_Charge_Credit_Used___, Get_Uninvoiced_Charge_Value___
--                   and Calc_Charge_Gross_Amount___ so credit control can handle charges also.
--  010925  DaZa     Bug fix 23647, Added new method Calc_Line_Gross_Amount___, and changed methods
--                   Get_Uninvoiced_Order_Value___ and Calculate_Credit_Used___ so they use the new method
--                   for order line calculation.
--  010919  JoAn     Bug fix 22731 Replaced code previously written to fix the problem with call
--                   to new function Get_Invoiced_Unposted_Total___
--  010917  JoAn     Bug fix 24250 Credit check not made correctly for partially invoiced orders.
--                   Amount already invoiced should not be included in open order amount.
--                   Added new function Get_Uninvoiced_Order_Value___
--  010824  PuILLK   Bug fix 22731, modify procedure Credit_Check__ by adding a 'Printed' to clint_state in the cursor cr_cust_inv_id.
--  010817  OsAllk   Bug Fix 22168, Exception Handling is done in the Procedure Pick_Plan_Order_Lines__ .
--  010711  PuILLK   Bug fix 22731, modify procedure Credit_Check__ by adding a cursor and dynamic call to invoice to get 'Preliminary' invoiced order totals
--                   to calculate credit total for customer to make credit blocks.
--  010531  IsWilk   Bug Fix 21433, Modified the Print_Pick_List___ for adding the information to Customer Order Line History.
--  010514  MaGu     Bug fix 21382. Replaced function call in where statement of cursor
--                   credit_used with subselect, for performance reasons. Method Calculate_Credit_Used___.
--  010413  JaBa     Bug Fix 20598,added new global lu constants.
--  010402  LeIsse   Bug fix 19115, Added close tolerance check to cursor deliver_allowed
--                   in Deliver_Allowed__ and in Deliver_With_Diff_Allowed__.
--  010216  JoAn     Bug Id 20037 Added COMMIT and relocking of order after each step in the order flow
--                   in Process_Order__.
--  010215  JoAn     Bug Id 20036 New logic for automatic reserval of orders in the order flow.
--                   Added new method Reserve___ called from Process_Order___.
--  001206  JoAn     Bug Id 18537 Corrected cursor in Deliver_With_Diff_Allowed__
--                   replaced buy_qty_due with revised_qty_due.
--  001108  JakH     Added configuration_id handling in Generate_Next_Level_Demands___
--                   substituted Inventory_Part_In_Stock_API fo Inventory_Part_Location_API
--  001101  DaZa     Added Release_Ctp_Planned_Lines___.
--  000922  MaGu     Changed to new address format in Create_Delivery_Notes___.
--  000913  FBen     Added UNDEFINED.
--  000908  JoEd     Added cursor NOTFOUND check in Release___.
--  000906  FBen     Removed check if supply_code = 'ND' in Release_Allowed__.
--                   Added check Release___ if supply_code = 'ND', an Error msg will be raised.
--  000712  GBO      Merged from Chameleon
--                   Removed Start_Release_Quoted_Order__, Release_Quoted_Allowed__,
--                   Print_Quotation_Allowed__, quote support ( RELEASE_QUOTED ),
--                   Process_From_Release_Quoted__
--  --------------   ------------- 12.1 ----------------------------------------
--  000602  JoAn     Changed Release_Order so that the method Process_All_Orders___
--                   is called to initiate the processing.
--  000526  PaLj     Changed connection of staged billing appendix in Print_Order_Confirmation___.
--  000510  JoAn     Added new methods Process_From_Release__, Process_From_Print_Ord_Conf__ etc
--                   The methods are called from Process_All_Orders___ when initiating the order
--                   flow for one order. The purpose of the new methods is to make it possible
--                   to assign different steps in the order flow to different batch jobs.
--                   Removed obsolete method Release_Quoted_Order___
--  000426  PaLj     Changed check for installed logical units. A check is made when API is instantiatet.
--                   See beginning of api-file.
--  000419  PaLj     Corrected Init_Method Errors
--  000327  JoAn     Replaced call to Inventory_Part_Location_API.Get_Total_Qty_Onhand
--                   with Get_Inventory_Qty_Onhand.
--  000309  JoEd     Added check on qty_to_ship for non-inventory parts in
--                   Plan_Picking_Allowed__.
--  000222  PaLj     Changed cursor staged_lines_to_invoice in Create_Invoice_Allowed.
--  000119  DaZa     Added method Check_Project_Approved___ and call to it in Release___.
--  000117  JoEd     Bug fix 12881. Changed cursor plan_pick - the supply code check -
--                   in Plan_Picking_Allowed__.
--  000110  PaLj     Changes in Create_Invoice_Allowed__ to handle staged billing.
--  991221  PaLj     Changed the function Print_Order_Confirmation.
--  --------------   ------------- 12.0 ----------------------------------------
--  991111  JoEd     Changed datatype length on company_ variables.
--  991028  DaZa     Added a charge cursor for Create_Invoice_Allowed__ so "charge only orders"
--                   can be invoiced also.
--  991025  JoEd     Changed where clause in Deliver_With_Diff_Allowed__'s cursor.
--  991025  PaLj     CID 24976 Changed Print_Order_Conf_Allowed__.
--  991021  PaLj     Changed Print_Pick_List_Allowed and Report_Picking_Allowed to support consolidated pick lists
--  991020  JoEd     Added ship_via_desc when creating delivery note(s).
--  991019  JoAn     Added check for 'ND' order lines to Release_Quoted_Allowed__
--  991019  JoAn     Removed HWB prefix in function call made in Deliver_Line_Allowed__
--  991019  PaLj     Added function Deliver_Line_Allowed__
--  991007  JoEd     Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990913  JoEd     Changed creating of delivery notes.
--                   Replaced Utility_SYS calls with Fnd_Session_API calls to fetch username.
--  990901  sami     Release_allowed__ is moodificated that it won't be available when an order line has supply code ND
--  990831  PaLj     Moved Create_Pick_List___ to LU CreatePickList.
--  990823  PaLj     Added function Print_Consol_Pick_List__ and changed Print_Pick_List___
--  --------------   ------------- 11.1 ----------------------------------------
--  990617  JoAn     Event server message generated when order is credit stopped.
--  990611  JoEd     Call id 19810: Added send of invoices in Print_Invoice___.
--  990610  JoAn     Removed automatic generation of Dispatch Advise message in Process_Order__.
--  990528  JoAn     CID 16630 changed message PICKPRINT to avoid translatation problems.
--                   CID 17699 Corrected no_of_lines passed when creating warehouse task.
--  990528  JoAn     CID 18773 Order state changed to Credit Blocked if credit check
--                   fails.
--  990527  JoEd     Changed error message NOPICKING to work with Localize.
--  990526  JoEd     Call id 17977: Corrected cursor in Print_Deliv_Note_Allowed__.
--  990521  JoAn     CID 17912 Corrected cursor in Plan_Picking_Allowed___.
--  990423  RaKu     Y.Corrections.
--  990420  JoAn     Added Release_Order.
--  990415  JoAn     Made use of the new public Get methods.
--  990414  JoAn     Performance improvements. Rewrote several cursors and removed
--                   function calls where possible.
--                   Removed obsolete method Generates_Backorder__
--  990412  JoEd     Y.Call id 11880: Rebuild Sort_Lines_By_Order___ to sort
--                   by part_no as well as order_no.
--  990409  JakH     Use of tables instead of views.
--  990406  JakH     Y.CID 10582 Removed use of Gen_Def_Key_value. use '*' where possible.
--  990406  JoAn     Corrected Check_Mandatory_Postings___
--  990401  JoAn     Added call to Payment method Customer_Order_Check_Credit
--  990329  JoAn     Changed Proceed_After_Credit_Block.
--  990324  RaKu     Changed call to CustomerOrder in procedure Lock_Order___.
--  990324  JoAn     Picking not allowed if the customer is credit blocked.
--  990322  JoAn     Changes due to redesign of the credit check. All credit checking
--                   now done by Payment. Removed several methods.
--                   Also added code to pass value for requested_date_finished_ when creating
--                   a new warehouse task.
--  990316  JoAn     CID 10580 Connected orders not created if the credit check fails
--                   in Release___.
--  990311  JoAn     Added code needed to retrieve credit info from payment in Credit_Check___.
--                   Added new methods Cr_Limit_Set_By_Finance___ and Get_Finance_Credit_Info___.
--  990303  JakH     Call 11078 Printing unprinted picklists are allowed to Start the
--                   the processing of an order. State 80 corrected in Process_order__
--  990225  JoAn     Changed call to Customer_Order_Reservation_Reserve_Order_Line__
--  990208  JoAn     Added method Check_Mandatory_Postings___.
--  990202  JoAn     Corrected call to Init_Method in Start_Print_Invoice__
--  990201  CAST     Adjustment of conv-factors.
--  990128  PaLj     Added new function Deliver_With_Diff_Allowed
--  990125  PaLj     Added call to Customer_Order_Line_API.Make_Service_Deliverable
--                   in Pick_Plan_Order_Lines
--  990119  JoAn     Added new method Calculate_Credit_Used.
--  990118  PaLj     changed sysdate to Site_API.Get_Site_Date(contract)
--  990118  RaKu     Added 'Send_Dispatch_Advice'-logic in the order-flow.
--  990114  JoAn     Added new method Calculate_Credit_Used___ and rewrote the logic
--                   for the credit check.
--                   Changed Customer_Order_Transfer_API.Send_Dispatch_Advice to
--                   Send_Direct_Delivery.
--  990111  JoEd     Added calls to Warehouse_Task_API in Create_Pick_List___.
--  990108  JoEd     Changed Create_Pick_List___ and Process_Order__.
--  981218  JICE     Changed condition in Pring_Order_Conf_Allowed for Configurator
--                   interface.
--  981203  RaKu     Replaced Get_Printed_Flag with Get_Objstate in call to
--                   Customer_Order_Deliv_Note.
--  980818  JOHW     Changed Inventory_Part_API.Get_Mrp_Order_Code to Inventory_Part_Planning_API.Get...
--  980422  RaKu     SID 1694. Added contract as parameter in Start_Pick_Plan_Orders__
--                   and Batch_Pick_Plan_Orders__.
--  980409  JoAn     SID 1659 Cleanup of history record creation.
--                   Moved creation of history record for order line when pick list
--                   is created to ordrow.
--  980324  JoAn     Moved Generate_Connected_Orders___, Create_Internal_Pur_Order___
--                   and Release_Internal_Pur_Orders___ to ConnectCustomerOrder LU.
--  980313  JoEd     Support ID 1433. Not allowed to print order confirmation when
--                   credit blocked.
--                   Added check on state CreditBlocked in Print_Order_Conf_Allowed__.
--                   Added check on order_conf in Reprint_Order_Conf_Allowed___.
--  980310  RaKu     Changed call ..Make_Purchase_Requisition to
--                   Connect_Customer_Order_API.Create_Purchase_Requisition.
--  980306  RaKu     Changed call ..Make_Shop_Order to Connect_Customer_Order.Create_Shop_Order.
--  980306  RaKu     Added method for creating DOP-order when doing release
--                   (Changes in Generate_Connected_Orders___).
--  980304  MNYS     Added a call to Cust_Order_Event_Creation_API.Order_Credit_Blocked
--                   in procedure Credit_Check__ .
--                   Added call to Cust_Order_Event_Creation_API.Order_Processing_Error
--                   in procedure Process_Order__.
--                   Added call Cust_Order_Event_Creation_API.Order_Delivered in
--                   procedure Deliver___.
--  980304  JoAn     Moved print job creation and printing from Print_Invoice___
--                   to Customer_Order_Invoice_Head_API.Print_Invoices
--                   Added call to Customer_Order_Event_Creation when a pick list
--                   has been created.
--  980302  JoEd     Added media code check when printing order confirmation and
--                   delivery note to send or print the documents.
--  980227  JoAn     Removed Confirm_Internal_Pur_Order___, this method should
--                   now be replaced with EDI/MHS message ORDRSP.
--  980224  DaZa     Added function Print_Quotation_Allowed__ and used it
--                   in Get_Allowed_Operations__
--  980220  MNYS     In Create_Invoice_Allowed__ is call Cust_Ord_Customer_API.
--                   Get_Customer_No_Pay(customer_no_) changed to
--                   Customer_Order_API.Get_Customer_No_Pay(order_no_).
--  980210  JOHNI    New way of storing error messages from batches.
--  971229  JoAn     Added Release_Internal_Pur_Orders___ and Confirm_Internal_Pur_Order___
--                   Renamed Create_Int_Purch_Order___ to Create_Internal_Pur_Order___
--                   Added code for confirmation of internal purchase order in
--                   Print_Order_Confirmation___
--  971222  JoAn     Rewrote Check_Po_Pr_So_Prc___ and changed the name to
--                   Generate_Connected_Orders___
--  971205  JoAn     Changed parameters in call to Customer_Order_Line_API.Make_Shop_Order__
--  971202  RaKu     Bug 2414. Removed procedure Check_Non_Inv_Ready_To_Ship___.
--  971201  JoAn     Bug 2373 Added condition col.objstate != 'Cancelled' to cursor
--                   in Check_Non_Inv_Ready_To_Ship___
--  971120  RaKu     Changed to FND200 Templates.
--  971103  JOHNI    Corrected call to Batch_SYS.
--  971029  RaKu     Changed from 'Y' to 'N' in cursor prevent_backorder.
--  971024  JoAn     Changed where clauses in cursors to use db values instead
--                   of client values.
--  971022  JoAn     Corrected calculation of receipt date for PO and PR with
--                   direct delivery in Check_PO_PR_SO_Prc___.
--                   Made changes in the same procedure so that lines are not
--                   appended to internal PO:s created if the supply code is
--                   not the same for CO lines.
--                   been created or printed.
--  971009  JoAn     Added copying of pre accountings in Check_PO_PR_SO_Prc___
--                   Added creation of history record when creating internal PO.
--  970930  JoAn     Changed Check_PO_PR_SO_Prc___ to handle all supply codes even if
--                   the activated CO was generated by another CO.
--  970925  JoAn     Corrected bug in Create_Invoice_Allowed__
--  970915  RoNi     Bug 97-0102: internal_customer_no added in Check_PO_PR_SO_Prc___ to
--                   get the right customer for the customer order
--  970818  RaKu     Added call to Calculate_Discount_Bonus before creating invoice. (The same
--                   functionality as in the old forms).
--  970813  JoAn     Bug 97-0083 Changed internal purchase order generation in Check_PO_PR_SO_Prc___
--                   so that new lines are appended to an existing purchase order only when the vendor_no
--                   is the same for the customer order lines.
--                   Changes also made as to when internal_po_no in the created customer order is modified.
--  970722  PHDE     Added a null value for qty_to_be_reserved to be passed in the call to
--                   Reserve_Customer_Order_API.Reserve_Order_Line__.
--  970625  JoAn     Added call to calculate discount and bonus when order is released.
--  970618  JoAn     Added method Reprint_Order_Conf_Allowed___ used in Get_Allowed_Operations__.
--                   Changed Print_Order_Conf_Allowed__ so that order confirmation
--                   may be printed when the order is 'CreditBlocked'.
--                   Added call to Print_Job_API.Print for all reports generated.
--  970612  JoAn     Credit_Check__ made a private method.
--  970610  JoAn     Added NULL assignment to ptr_ in Sort_Lines_By_Order___
--  970605  JoAn     Changed Print_Order_Conf_Allowed__ not allowing printout when
--                   order is credit blocked.
--  970604  JoAn     Initializing purchase_type passed to Customer_Order_Pur_Order_API.New
--                   Corrected retrieval of order_id_ in Process_Order__
--  970603  JoAn     Added method Lock___ called when processing order or order lines.
--  970603  JoAn     Removed ampersand in comments. (Problems when installing from SQLPlus)
--  970530  JoAn     Bound addr_1 ... addr_6 before dynamic call to
--                   Site_Delivery_Address_API in Check_PO_PR_SO_Prc___
--                   Added checks for internal invoicing in Create_Invoice_Allowed___
--  970526  JoAn     Removed extra quotes in error messages.
--  970520  JoAn     Fixed bug in Get_Allowed_Operations__
--  970518  RaKu     Changed cursor in function Deliver_Allowed__.
--  970516  JoAn     Added method Generate_Next_Level_Demands___ called when
--                   releasing order lines.
--  970515  JoAn     Added method Check_Non_Inv_Ready_To_Ship___.
--  970515  JoEd     Removed parameters from Start_Pick_Plan_Orders__.
--                   Added method Batch_Pick_Plan_Orders__.
--                   Method Customer_Order_API.Modify_Internal_Po_No is public.
--                   Fixed error message sent to user console in Process_Order__.
--  970514  JoEd     Added parameters to Start_Pick_Plan_Orders__.
--  970512  RaKu     Wrote dynamic call in Create_Int_Purch_Order___ to fetch
--                   data from PURCH.
--  970510  JoAn     Activated deferred calls.
--  970509  JoAn     Changes in methods for internal order processing.
--  970410  JoAn     Recreated
-- ---------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_                     CONSTANT VARCHAR2(4)   := Fnd_Boolean_API.db_true;
db_false_                     CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;
TYPE tab_order_no IS TABLE OF VARCHAR2(12) INDEX BY BINARY_INTEGER;
TYPE tab_line_no IS TABLE OF VARCHAR2(4) INDEX BY BINARY_INTEGER;
TYPE tab_rel_no IS TABLE OF VARCHAR2(4) INDEX BY BINARY_INTEGER;
TYPE tab_line_item_no IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE tab_contpart IS TABLE OF VARCHAR2(31) INDEX BY BINARY_INTEGER;
TYPE tab_date_entered IS TABLE OF VARCHAR2(25) INDEX BY BINARY_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Process_All_Orders___
--   Unpack the attribute string containing all orders to be processed and
--   the parameters needed for the processing.
--   Process the orders one by one by calling the Process_Order__ method.
PROCEDURE Process_All_Orders___ (
   attr_ IN OUT VARCHAR2 )
IS
   start_event_              NUMBER;
   ptr_                      NUMBER;
   name_                     VARCHAR2(30);
   value_                    VARCHAR2(2000);
   order_attr_               VARCHAR2(2000);
   description_              VARCHAR2(200);

   order_no_                 VARCHAR2(12);
   online_processing_        VARCHAR2(5);
   process_in_background_    VARCHAR2(20);

   display_line_             VARCHAR2(4);
   display_rel_              VARCHAR2(4);
   found_                    NUMBER := 0;
   online_ordrsp_processing_ VARCHAR2(5);
   ordrsp_site_              VARCHAR2(5);
   customer_order_rec_                Customer_Order_API.Public_Rec;   

   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
      CURSOR no_configuration_defined IS
         SELECT line_no,rel_no, part_no, catalog_no, configuration_id
         FROM   customer_order_line_tab
         WHERE  order_no = order_no_                  
         AND    rowstate != 'Cancelled';         
   $END
BEGIN
   -- Retrieve all the orders to be processed and process the orders one by one
   Client_SYS.Clear_Attr(order_attr_);
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'START_EVENT') THEN
         start_event_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;     

      -- 'END' should be the last parameter passed for each order
      IF (name_ = 'END') THEN 
         customer_order_rec_ := Customer_Order_API.Get(order_no_);
         -- Check if the transaction must be foced to background
         IF NVL(process_in_background_,db_false_) = db_false_ THEN
            online_processing_ := Cust_Order_Type_API.Get_Online_Processing_Db(customer_order_rec_.order_id);
         ELSE            
            online_processing_ := db_false_;
         END IF;
         
         IF (start_event_ = 20) THEN
            $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
               FOR rec_ IN no_configuration_defined LOOP
                  IF(Part_Catalog_API.Get_Configurable_Db(rec_.part_no) = 'CONFIGURED' 
                     AND ((rec_.configuration_id = '*') OR ((rec_.configuration_id != '*') AND (Configuration_Spec_API.Get_Objstate(rec_.catalog_no, rec_.configuration_id) != 'Completed')))) THEN
                     found_ := 1;
                     display_line_ := rec_.line_no;
                     display_rel_  := rec_.rel_no;
                     EXIT;
                  END IF;
               END LOOP;               
               IF found_ = 1 THEN
                  Error_SYS.Record_General(lu_name_, 'NOCFGDEFINED: Customer order line :P1 - :P2 has not been configured. All configurable parts must be configured before any further processing of the Customer Order.',display_line_,display_rel_ );
               END IF;
            $END
            IF (Transaction_SYS.Is_Session_Deferred OR online_processing_ = db_true_) THEN
               -- dont start another background job when already in a background job, like for example when you
               -- come from the automatic approval process and also use automatic release of the CO
               Client_SYS.Add_To_Attr('IVC_UNCON_CHG_SEP', -1 , order_attr_);
               Process_From_Release_Order__(order_attr_);
            ELSE
               description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_RELEASE: Release Customer Order');
               Client_SYS.Add_To_Attr('IVC_UNCON_CHG_SEP', -1 , order_attr_);
               Check_No_Previous_Execution(order_no_, 'RELEASE');
               Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Process_From_Release_Order__', order_attr_, description_);
            END IF;
         ELSIF (start_event_ = 40) THEN
            IF Client_SYS.Item_Exist('ONLINE_ORDRSP_PROCESSING', order_attr_) THEN
               Process_From_Print_Ord_Conf__(order_attr_);
            ELSE
               ordrsp_site_ := NVL(Cust_Ord_Customer_API.Get_Acquisition_Site(customer_order_rec_.customer_no),  customer_order_rec_.contract);
               IF Site_Discom_Info_API.Get_Exec_Ord_Change_Online_Db(ordrsp_site_) = db_true_ THEN
                  online_ordrsp_processing_ := db_true_;                  
               END IF;
               IF (online_ordrsp_processing_ = db_true_) AND (online_processing_ = db_true_) THEN 
                  Client_SYS.Add_To_Attr('ONLINE_ORDRSP_PROCESSING', online_ordrsp_processing_, order_attr_);
               END IF;
               IF (online_processing_ = db_true_) THEN
                  Process_From_Print_Ord_Conf__(order_attr_);
               ELSE
                  description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_PRINT_ORD_CONF: Print Order Confirmation');
                  Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Process_From_Print_Ord_Conf__', order_attr_, description_);
               END IF;
            END IF;
         ELSIF (start_event_ = 60) THEN
            IF (online_processing_ = db_true_) THEN
               Process_From_Reserve__(order_attr_);
            ELSE
               description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_RESERVE: Reserve Customer Order');
               Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Process_From_Reserve__', order_attr_, description_);
            END IF;
         ELSIF (start_event_ = 70) THEN
            IF (online_processing_ = db_true_) THEN
               Process_From_Create_Pick_Lst__(order_attr_);
            ELSE
               description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_CREATE_PICK_LST: Create Pick List for Customer Order');
               Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Process_From_Create_Pick_Lst__', order_attr_, description_);
            END IF;
         ELSIF (start_event_ = 80) THEN
            IF (online_processing_ = db_true_) THEN
               Process_From_Print_Pick_List__(order_attr_);
            ELSE
               description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_PRINT_PICK_LIST: Print Pick List for Customer Order');
               Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Process_From_Print_Pick_List__', order_attr_, description_);
            END IF;
         ELSIF (start_event_ = 85) THEN
            IF (online_processing_ = db_true_) THEN
               Process_From_Report_Picking__(order_attr_);
            ELSE
               description_ := Raise_Report_Picking_Msg___;
               Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Process_From_Report_Picking__', order_attr_, description_);
            END IF;
         ELSIF (start_event_ = 90) THEN
            IF (online_processing_ = db_true_) THEN
               Process_From_Deliver__(order_attr_);
            ELSE
               description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_DELIVER: Deliver');
               Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Process_From_Deliver__', order_attr_, description_);
            END IF;
         ELSIF (start_event_ = 100) THEN
            IF (online_processing_ = db_true_) THEN
               Process_From_Create_Del_Note__(order_attr_);
            ELSE
               description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_CREATE_DEL_NOTE: Create Delivery Note for Customer Order');
               Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Process_From_Create_Del_Note__', order_attr_, description_);
            END IF;
         ELSIF (start_event_ = 110) THEN
            IF (online_processing_ = db_true_) THEN
               Process_From_Print_Del_Note__(order_attr_);
            ELSE
               description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_PRINT_DEL_NOTE: Print Delivery Note for Customer Order');
               Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Process_From_Print_Del_Note__', order_attr_, description_);
            END IF;
         ELSIF (start_event_ = 500) THEN
            IF (online_processing_ = db_true_) THEN
               Process_From_Create_Invoice__(order_attr_);
            ELSE
               description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_CREATE_INVOICE: Create Invoice for Customer Order');
               Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Process_From_Create_Invoice__', order_attr_, description_);
            END IF;
         ELSE
            Client_SYS.Add_To_Attr(name_, value_, order_attr_);
            IF (online_processing_ = db_true_) THEN
               Process_Order__(order_attr_);
            ELSE
               description_ := Language_SYS.Translate_Constant(lu_name_, 'PROCESS_ORDERS: Process Customer Order');
               Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Process_Order__', order_attr_, description_);
            END IF;
         END IF;
--         Process_Order__(order_attr_);
         Client_SYS.Clear_Attr(order_attr_);
      ELSIF (name_ = 'PROCESS_IN_BACKGROUND') THEN
         process_in_background_ := value_; -- If 'TRUE' transaction must be done in background.
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, order_attr_);
      
         IF name_ = 'ORDER_NO' THEN
            order_no_ := value_;
         END IF;
      END IF;
   END LOOP;
END Process_All_Orders___;


-- Sort_Lines_By_Date_Entered___
--   Sort all lines in the attribute string first by date entered, if equal
--   sort by order no then by site/part number.
PROCEDURE Sort_Lines_By_Date_Entered___ (
   ord_ship_tab_ IN OUT Reserve_Shipment_API.Reserve_Shipment_Table )
IS
   n_            BINARY_INTEGER := 0;
   total_        BINARY_INTEGER;
   total_1_      BINARY_INTEGER;
   order_arr_    tab_order_no;
   line_arr_     tab_line_no;
   rel_arr_      tab_rel_no;
   item_arr_     tab_line_item_no;
   contpart_arr_ tab_contpart;
   date_ent_arr_ tab_date_entered;
   sorted_       BOOLEAN := FALSE;
   temp_str_     VARCHAR2(31);
   temp_no_      NUMBER;
BEGIN
   -- unpack the attributes into the different arrays. The different attribute "records" starts with
   -- order no. Therefor only increase the index counter before that value (initialized to zero).
   FOR index_ IN ord_ship_tab_.FIRST..ord_ship_tab_.LAST LOOP
      n_                := n_ + 1;
      order_arr_(n_)    := ord_ship_tab_(index_).source_ref1;
      date_ent_arr_(n_) := TO_CHAR(Customer_Order_API.Get_Date_Entered(ord_ship_tab_(index_).source_ref1), 'YYMMDDHH24MISS');
      line_arr_(n_)     := ord_ship_tab_(index_).source_ref2;
      rel_arr_(n_)      := ord_ship_tab_(index_).source_ref3;
      item_arr_(n_)     := ord_ship_tab_(index_).source_ref4;
      contpart_arr_(n_) := ord_ship_tab_(index_).contract;
      -- append part no. If a non-inventory part, part is NULL.
      -- Use field separator value to sort them first in the part order.
      IF (ord_ship_tab_(index_).inventory_part_no IS NULL) THEN
         contpart_arr_(n_) := Client_SYS.field_separator_;
      ELSE
         contpart_arr_(n_) := contpart_arr_(n_) || '^' || ord_ship_tab_(index_).inventory_part_no;
      END IF;
   END LOOP;

   -- store number of elements in the "arrays"
   total_ := n_;

   WHILE NOT sorted_ LOOP
      sorted_  := TRUE;
      total_1_ := (n_ - 1);

      -- sort by date entered, order no and contract+part_no
      FOR n_ IN 1..total_1_ LOOP
         IF (date_ent_arr_(n_) > date_ent_arr_(n_ + 1)) OR
             ((date_ent_arr_(n_) = date_ent_arr_(n_ + 1)) AND (order_arr_(n_) > order_arr_(n_ + 1))) OR
             ((date_ent_arr_(n_) = date_ent_arr_(n_ + 1)) AND (order_arr_(n_) = order_arr_(n_ + 1)) AND (contpart_arr_(n_) > contpart_arr_(n_ + 1))) THEN
            sorted_               := FALSE;

            temp_str_             := date_ent_arr_(n_);
            date_ent_arr_(n_)     := date_ent_arr_(n_ + 1);
            date_ent_arr_(n_ + 1) := temp_str_;

            temp_str_             := order_arr_(n_);
            order_arr_(n_)        := order_arr_(n_ + 1);
            order_arr_(n_ + 1)    := temp_str_;

            temp_str_             := line_arr_(n_);
            line_arr_(n_)         := line_arr_(n_ + 1);
            line_arr_(n_ + 1)     := temp_str_;

            temp_str_             := rel_arr_(n_);
            rel_arr_(n_)          := rel_arr_(n_ + 1);
            rel_arr_(n_ + 1)      := temp_str_;

            temp_no_              := item_arr_(n_);
            item_arr_(n_)         := item_arr_(n_ + 1);
            item_arr_(n_ + 1)     := temp_no_;

            temp_str_             := contpart_arr_(n_);
            contpart_arr_(n_)     := contpart_arr_(n_ + 1);
            contpart_arr_(n_ + 1) := temp_str_;
         END IF;
      END LOOP;
   END LOOP;

   -- Only return the order line keys (not the site/part no combination)
   FOR n_ IN 1..total_ LOOP
      ord_ship_tab_(n_ - 1).source_ref1     := order_arr_(n_);
      ord_ship_tab_(n_ - 1).source_ref2      := line_arr_(n_);
      ord_ship_tab_(n_ - 1).source_ref3       := rel_arr_(n_);
      ord_ship_tab_(n_ - 1).source_ref4 := item_arr_(n_);
   END LOOP;
END Sort_Lines_By_Date_Entered___;


-- Release___
--   Release an order. If the state after releasing is 'Released' or 'Reserved'
--   then execute a credit check for the order.
PROCEDURE Release___ (
   order_no_                   IN VARCHAR2,
   sales_promotion_calculated_ IN BOOLEAN,
   discount_calculated_        IN BOOLEAN)
IS

   CURSOR get_order_lines IS
      SELECT part_no, line_no, rel_no, line_item_no, revised_qty_due, supply_code, condition_code, activity_seq
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    rowstate != 'Cancelled';

   objstate_                VARCHAR2(20);
   total_sourced_qty_       NUMBER;
   created_flag_            VARCHAR2(5);
   demand_code_             CUSTOMER_ORDER_LINE_TAB.demand_code%TYPE;
   condition_code_usage_db_ VARCHAR2(20);   
   shipment_id_tab_         Shipment_API.Shipment_Id_Tab;
   cust_contract_           VARCHAR2(5);
   ctp_run_id_              NUMBER;
   customer_order_rec_      Customer_Order_API.Public_Rec;
BEGIN
   -- Create new order lines for fully sourced - Not Decided - lines only.
   FOR rec_ IN get_order_lines LOOP
       condition_code_usage_db_ := Part_Catalog_API.Get_Condition_Code_Usage_Db(rec_.part_no);
       IF ( condition_code_usage_db_ = 'ALLOW_COND_CODE') THEN
          IF (rec_.condition_code IS NULL) THEN
             Error_SYS.Record_General(lu_name_, 'CONDCODEREQUIRED: Condition code functionality is enabled in the part catalog record for this part. You must enter a condition code');
          END IF;
       END IF;
       IF (rec_.supply_code = 'ND') THEN
          total_sourced_qty_ := Sourced_Cust_Order_Line_API.Get_Total_Sourced_Qty(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
          IF (rec_.revised_qty_due = total_sourced_qty_) THEN
             Customer_Order_Line_API.Create_Sourced_Co_Lines(created_flag_, order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
          END IF;
       END IF;
   END LOOP;

   Customer_Order_API.Set_Released(order_no_);
   customer_order_rec_ := Customer_Order_API.Get(order_no_);
   -- Consolidate freight chagres ..
   -- Fetch zone details to the single occurrence addresses and then consolidate freight charges.
   Customer_Order_Charge_Util_API.Calc_Consolidate_Charges(order_no_, NULL);

   FOR rec_ IN get_order_lines LOOP
      -- Calculate and refresh project costs for project connected order lines
      IF (rec_.activity_seq IS NOT NULL) THEN
         Customer_Order_Line_API.Calculate_Cost_And_Progress(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      ELSE
         IF (customer_order_rec_.project_id IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'PROJCONNNOTEXIST: All lines should be connected to the project specified in the customer order reference tab before releasing the customer order.');
         END IF;
      END IF;
      -- Remove ctp record
      $IF (Component_Ordstr_SYS.INSTALLED) $THEN
         ctp_run_id_ := Interim_Ctp_Critical_Path_API.Get_Ctp_Run_Id('CUSTOMERORDER', order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
         IF (ctp_run_id_ IS NOT NULL AND ctp_run_id_ > 0) THEN
            Interim_Ctp_Critical_Path_API.Clear_Ctp_Data(ctp_run_id_);
         END IF;
      $END
   END LOOP;
   
   -- If the state after releasing is 'Released' then execute the credit check
   objstate_ := customer_order_rec_.rowstate;

   IF (objstate_ IN ('Released', 'Reserved')) THEN
      -- Check so any project connected to this order have been approved before this release
      Check_Project_Approved___(order_no_);
      -- Make sure that all mandatory postings have been made for the order header and order lines
      Check_Mandatory_Postings___(order_no_);
      
      -- Calculate discount for this order
      IF (NOT discount_calculated_) THEN
         Customer_Order_API.Calculate_Order_Discount__(order_no_ => order_no_);
      END IF;
      
      -- Calculate Sales Promotion
      cust_contract_ := Cust_Ord_Customer_API.Get_Acquisition_Site(customer_order_rec_.customer_no);
      IF (NVL(Site_API.Get_Company(cust_contract_), ' ')) != (Site_API.Get_Company(customer_order_rec_.contract)) THEN
          
         IF (NOT sales_promotion_calculated_) THEN
            -- Calculate Sales Promotion
            Sales_Promotion_Util_API.Calculate_Order_Promotion(order_no_);
         END IF;
         IF (Sales_Promotion_Util_API.Check_Unutilized_O_Deals_Exist(order_no_, TRUE) = 'TRUE') THEN
            Cust_Order_Event_Creation_API.Unutilized_Promo_Deal_Release(order_no_, sales_promotion_calculated_);
         END IF;
      END IF;    

      -- Execute the credit check
      Credit_Check_Order(order_no_, 'RELEASE_ORDER');

      objstate_ := Customer_Order_API.Get_Objstate(order_no_);
      -- If the order was credit blocked then no connected orders should be created.
      IF (objstate_ != 'Blocked') THEN
         Customer_Order_API.Check_Rel_Mtrl_Planning(order_no_, Fnd_Boolean_API.DB_FALSE);
         -- Check if there are any Internal Purchase Order Direct (IPD),
         -- Internal Purchase Order Transit (IPT), Purchase Order Direct (PD),
         -- Purchase Order Transit (PT) or Shop Order (SO) acquisition codes to be handled.
         Connect_Customer_Order_API.Generate_Connected_Orders(order_no_);

         -- If the order was credit blocked then no shipment should be created.
         -- Call to create new shipment or add to existing shipment when releasing customer order
         -- according to the shipment creation db value
         Shipment_Order_Utility_API.Create_Automatic_Shipments(shipment_id_tab_, order_no_);
      END IF;

      -- Generate next level demands for order lines with inventory parts having MRP order code = 'N'
      -- The reason this is done even if the order was credit blocked is that there is no way
      -- of knowing whether demands have already been generated or not for a released order.
      -- If the demands were generated in Proceed_After_Credit_Check there is a risk that
      -- they would be generated more than once for the same order.
      Generate_Next_Level_Demands___(order_no_);      

      -- Call to Event Server.
      Cust_Order_Event_Creation_API.Order_Released(order_no_);
   END IF;

   -- Release the Distribution Order if one exist for the order when releasing the customer order.
   demand_code_ := Order_Supply_Type_API.Encode(Customer_Order_Line_API.Get_Demand_Code(order_no_,'1','1',0));
   IF (demand_code_ = 'DO') THEN
      $IF (Component_Disord_SYS.INSTALLED) $THEN
         Check_Dist_Order_State___(order_no_);
      $ELSE
         NULL;
      $END
   END IF;
END Release___;


-- Print_Order_Confirmation___
--   Print the order confirmation for an order.
--   If this order was generated by an internal purchase order then that
--   purchase order will be confirmed.
PROCEDURE Print_Order_Confirmation___ (
   order_no_ IN VARCHAR2 )
IS
   parameter_attr_      VARCHAR2(2000);
   print_job_id_        NUMBER;
   staged_              NUMBER;
   pdf_info_            VARCHAR2(4000);
   order_rec_           Customer_Order_API.Public_Rec;
   cust_email_addr_     VARCHAR2(200);
   email_order_conf_db_ cust_ord_customer_tab.email_order_conf%TYPE;
   result_          NUMBER;

   CURSOR get_staged_billing IS
      SELECT 1
      FROM customer_order_line_tab
      WHERE order_no = order_no_
      AND staged_billing = 'STAGED BILLING';
BEGIN
   Client_SYS.Clear_Attr(parameter_attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, parameter_attr_);
   order_rec_           := Customer_Order_API.Get(order_no_);
   Client_Sys.Add_To_Attr('LANG_CODE', Customer_Info_API.Get_Default_Language_Db(order_rec_.customer_no), parameter_attr_);
   cust_email_addr_     := Cust_Ord_Customer_Address_API.Get_Email(order_rec_.customer_no, order_rec_.cust_ref, order_rec_.bill_addr_no);
   email_order_conf_db_ := Cust_Ord_Customer_API.Get_Email_Order_Conf_Db(order_rec_.customer_no);

   IF (email_order_conf_db_ = 'TRUE') THEN
      Create_Report_Settings(pdf_info_, order_no_, order_rec_.cust_ref, order_rec_.contract, cust_email_addr_, order_rec_.customer_no, 'CUSTOMER_ORDER_CONF_REP');  
      Create_Print_Jobs(print_job_id_, result_, 'CUSTOMER_ORDER_CONF_REP', parameter_attr_, pdf_info_);
   ELSE
      Create_Print_Jobs(print_job_id_, result_, 'CUSTOMER_ORDER_CONF_REP', parameter_attr_);
   END IF; 
   Printing_Print_Jobs(print_job_id_);
   -- Since seperate print job creates for appendix report, print_job_id_ should be empty
   print_job_id_ := NULL;   

   OPEN get_staged_billing;
   FETCH get_staged_billing INTO staged_;
   IF (get_staged_billing%NOTFOUND) THEN
      staged_ := 0;
   END IF;
   CLOSE get_staged_billing;

   IF (staged_ = 1) THEN
      -- Create the Staged Billing Appendix report
      Client_SYS.Clear_Attr(parameter_attr_);
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, parameter_attr_);      
      -- Create seperate print job for Staged Billing Appendix report
      Create_Print_Jobs(print_job_id_, result_, 'ORDER_STAGED_BILLING_REP', parameter_attr_);
      Printing_Print_Jobs(print_job_id_);
   END IF;
END Print_Order_Confirmation___;


-- Reserve___
--   Reserve the entire order.
PROCEDURE Reserve___ (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   Reserve_Customer_Order_API.Reserve_Order__(order_no_);
END Reserve___;


-- Report_Picking___
--   Report picking for an entire order or a pick list.
PROCEDURE Report_Picking___ (
   order_no_     IN VARCHAR2,
   pick_list_no_ IN VARCHAR2,
   location_no_  IN VARCHAR2 )
IS
BEGIN
   Pick_Customer_Order_API.Report_Picking__(order_no_, pick_list_no_, location_no_);
END Report_Picking___;


-- Deliver___
--   Deliver an order.
PROCEDURE Deliver___ (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   Deliver_Customer_Order_API.Deliver_Order__(order_no_);
END Deliver___;


-- Create_Delivery_Notes___
--   Find all 'Preliminary' delivery notes for specified order and
--   change the state to 'Created'.
--   If no 'Preliminary' delivery notes exist, create them first.
--   The delivery note numbers for the delivery notes will be returned in
--   the delnote_no_list_ parameter.
PROCEDURE Create_Delivery_Notes___ (
   order_no_ IN VARCHAR2 )
IS
   delnote_no_         VARCHAR2(15);
   media_code_         VARCHAR2(30);
   customer_order_rec_ CUSTOMER_ORDER_API.Public_Rec;

   CURSOR get_line IS
      SELECT DISTINCT col.ship_addr_no, col.addr_flag,
             cola.addr_1, cola.address1, cola.address2, cola.address3, cola.address4, cola.address5, cola.address6, cola.zip_code,
             cola.city, cola.state, cola.county, cola.country_code,
             col.route_id, col.forward_agent_id, col.ship_via_code, col.delivery_terms,
             col.del_terms_location, col.deliver_to_customer_no, 
             DECODE(col.demand_code, 'IPD', 'IPD', 'OTHER') demand_code, col.originating_co_lang_code
        FROM customer_order_line_tab col, cust_order_line_address_2 cola
       WHERE (col.order_no, col.line_no, col.rel_no, col.line_item_no) IN
             (SELECT order_no, line_no, rel_no, line_item_no
                FROM customer_order_delivery_tab
               WHERE delnote_no IS NULL
                 AND order_no  = order_no_
                 AND cancelled_delivery = 'FALSE' )
         AND  col.line_item_no = cola.line_item_no
         AND  col.rel_no   = cola.rel_no
         AND  col.line_no  = cola.line_no
         AND  col.order_no = cola.order_no
         AND  col.order_no = order_no_
         AND  col.shipment_connected = 'FALSE'
         AND  col.supply_code NOT IN ('PD','IPD');
BEGIN
   FOR linerec_ IN get_line LOOP
      Delivery_Note_API.New(delnote_no_, order_no_, linerec_.ship_addr_no,
               linerec_.addr_flag, linerec_.addr_1, linerec_.address1, linerec_.address2, linerec_.address3,linerec_.address4,linerec_.address5,linerec_.address6,
               linerec_.zip_code, linerec_.city, linerec_.state, linerec_.county, linerec_.country_code,
               linerec_.route_id, linerec_.forward_agent_id, linerec_.ship_via_code, linerec_.delivery_terms,
               NULL, linerec_.deliver_to_customer_no, 
               pre_ship_invent_loc_no_ => NULL,
               del_terms_location_ => linerec_.del_terms_location,
               source_lang_code_ => linerec_.originating_co_lang_code);
      
      IF (Cust_Ord_Customer_API.Get_Auto_Despatch_Adv_Send(linerec_.deliver_to_customer_no) = 'Y') THEN
         media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(linerec_.deliver_to_customer_no, 'DESADV');
         IF (media_code_ IS NOT NULL AND delnote_no_ IS NOT NULL) THEN
            Dispatch_Advice_Utility_API.Send_Dispatch_Advice(delnote_no_, media_code_);
         END IF;
      END IF;
   END LOOP;
END Create_Delivery_Notes___;


-- Print_Delivery_Note___
--   Print the specified delivery note.
PROCEDURE Print_Delivery_Note___ (
   delnote_no_ IN VARCHAR2 )
IS
   parameter_attr_       VARCHAR2(2000);
   print_job_id_         NUMBER;
   no_of_delnote_copies_ NUMBER;
   order_no_             customer_order_tab.order_no%TYPE;
   work_order_no_        NUMBER;
   purchase_order_no_    VARCHAR2(12);
   nopart_lines_exist_   NUMBER;   
   pur_order_no_         VARCHAR2(12);
   result_               NUMBER;
   customer_order_rec_   Customer_Order_API.Public_Rec;
   
   CURSOR get_mro_lines IS
      SELECT col.demand_order_ref1
      FROM customer_order_line_tab col, customer_order_delivery_tab cod
      WHERE cod.order_no = order_no_
      AND col.order_no = cod.order_no
      AND col.line_no = cod.line_no
      AND col.rel_no = cod.rel_no
      AND col.line_item_no = cod.line_item_no
      AND col.supply_code = 'MRO'
      AND cod.cancelled_delivery = 'FALSE';
BEGIN
   order_no_             := Delivery_Note_API.Get_Order_No(delnote_no_);
   customer_order_rec_   := Customer_Order_API.Get(order_no_);
   no_of_delnote_copies_ := NVL(Cust_Ord_Customer_API.Get_No_Delnote_Copies(customer_order_rec_.customer_no), 0);
   
   FOR delnote_copy_no_ IN 0..no_of_delnote_copies_ LOOP
      --Note: Create the report
      Client_SYS.Clear_Attr(parameter_attr_);
      Client_SYS.Add_To_Attr('DELNOTE_NO', delnote_no_, parameter_attr_);
      Client_SYS.Add_To_Attr('DELNOTE_COPY_NO', delnote_copy_no_, parameter_attr_);
      -- Create one print job for original report and attach print job instances to same print job if there are no of copies 
      result_ := NULL;
      Create_Print_Jobs(print_job_id_, result_, 'CUSTOMER_ORDER_DELIV_NOTE_REP', parameter_attr_);
   END LOOP;

   Printing_Print_Jobs(print_job_id_);
   -- Since a new print job creates for appendix report, print_job_id_ should be empty
   print_job_id_ := NULL;   
   
   $IF (Component_Wo_SYS.INSTALLED) AND (Component_Purch_SYS.INSTALLED) $THEN  
      -- Note: Get MRO order lines for Miscellaneous Part Report.
      FOR mro_line_ IN get_mro_lines LOOP
         work_order_no_      := TO_NUMBER(mro_line_.demand_order_ref1);
         pur_order_no_       := Active_Work_Order_API.Get_Receive_Order_No(work_order_no_);
         purchase_order_no_  := pur_order_no_;
         nopart_lines_exist_ := Purchase_Order_API.Check_Nopart_Lines_Exist(pur_order_no_);           

         IF nopart_lines_exist_ != 0 THEN
            -- Note: Create the Delivery Note Appendix report
            Client_SYS.Clear_Attr(parameter_attr_);
            Client_SYS.Add_To_Attr('ORDER_NO', purchase_order_no_, parameter_attr_);
            Client_SYS.Add_To_Attr('REPORT_TYPE', 'DELIV NOTE', parameter_attr_);
            -- Create one print job for appendix report and attach print job instances to same print job if multiple MRO lines exist 
            result_ := NULL;
            Create_Print_Jobs(print_job_id_, result_, 'PURCH_MISCELLANEOUS_PART_REP', parameter_attr_);
         END IF;
      END LOOP;
   $END

   IF print_job_id_ IS NOT NULL THEN
      Printing_Print_Jobs(print_job_id_);
   END IF;
   
   -- gelr:warhouse_journal, begin
   IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(customer_order_rec_.contract, 'WAREHOUSE_JOURNAL') = Fnd_Boolean_API.DB_TRUE) THEN
      Customer_Order_Delivery_API.Modify_Delivery_Info(customer_order_rec_.contract,order_no_,'CUSTOMER_ORDER', delnote_no_);
   END IF;
   -- gelr:warhouse_journal, end   
END Print_Delivery_Note___;


-- Create_Invoice___
--   Create invoice for an order.
--   The invoice id for the created invoice will be returned in the
--   invoice_id parameter.
PROCEDURE Create_Invoice___ (
   invoice_id_ IN OUT VARCHAR2,
   order_no_   IN     VARCHAR2 )
IS
BEGIN
   Invoice_Customer_Order_API.Create_Invoice__(invoice_id_, order_no_);
END Create_Invoice___;


-- Print_Invoice___
--   Print the specified invoice.
PROCEDURE Print_Invoice___ (
   invoice_id_       IN VARCHAR2,
   media_code_       IN VARCHAR2,
   cust_email_addr_  IN VARCHAR2,
   email_invoice_    IN VARCHAR2 )
IS
   attr_ VARCHAR2(2000);
BEGIN
   -- Print the invoice
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
   -- Add media code if not null. The invoice is then sent instead of printed.
   Trace_SYS.Field('MEDIA_CODE', media_code_);
   IF (media_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MEDIA_CODE', media_code_, attr_);
      -- The connected objects value should be TRUE for media code E-Invoice
      -- in the automatic customer order flow. Otherwise FALSE.
      IF (media_code_ = 'E-INVOICE') THEN
         Client_SYS.Add_To_Attr('CONNECTED_OBJECTS', 'TRUE', attr_);
      ELSE
         Client_SYS.Add_To_Attr('CONNECTED_OBJECTS', 'FALSE', attr_);
      END IF;
   ELSIF (cust_email_addr_ IS NOT NULL AND email_invoice_ = 'TRUE') THEN
      -- When there is a media code, email not sent in automatic flow
      Client_SYS.Add_To_Attr('EMAIL_ADDR', cust_email_addr_, attr_);
   END IF;
   Customer_Order_Inv_Head_API.Print_Invoices(attr_);
END Print_Invoice___;


-- Staged_Lines_To_Invoice___
--    If provisional_price column is false then return 1 else return 0. 
FUNCTION Staged_Lines_To_Invoice___ (
   order_no_ IN VARCHAR2) RETURN NUMBER
IS 
   staged_lines_exist_ NUMBER;
   
   CURSOR staged_lines_to_invoice IS
      SELECT 1
      FROM ORDER_LINE_STAGED_BILLING_TAB osb, CUSTOMER_ORDER_LINE_TAB col
      WHERE osb.order_no          = order_no_
      AND   col.rowstate          NOT IN ('Cancelled', 'Invoiced')
      AND   col.provisional_price = 'FALSE'
      AND   osb.order_no          = col.order_no
      AND   osb.line_no           = col.line_no
      AND   osb.rel_no            = col.rel_no
      AND   osb.line_item_no      = col.line_item_no
      AND   osb.rowstate          = 'Approved';
BEGIN
   OPEN staged_lines_to_invoice;
   FETCH staged_lines_to_invoice INTO staged_lines_exist_;
   IF (staged_lines_to_invoice%NOTFOUND) THEN
      staged_lines_exist_ := 0;
   ELSE
      staged_lines_exist_:= 1;
   END IF;
   CLOSE staged_lines_to_invoice;
   
   RETURN staged_lines_exist_;
END Staged_Lines_To_Invoice___;


-- Lock_Order___
--   Lock the specified order while it is being processed.
PROCEDURE Lock_Order___ (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   -- Lock the order while it is being processed
   Customer_Order_API.Lock_By_Keys__(order_no_);
END Lock_Order___;


-- Reprint_Order_Conf_Allowed___
--   Return TRUE (1) if printing the Order Confirmation should be allowed
--   for the specified  order. This function will return TRUE even when
--   the order confirmation has already been printed.
FUNCTION Reprint_Order_Conf_Allowed___ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER;

   CURSOR order_conf IS
      SELECT 1
      FROM   customer_order_tab
      WHERE  rowstate NOT IN ('Cancelled')
      AND    order_no = order_no_
      AND    order_conf_flag = 'Y'
      AND    order_conf = 'Y';
BEGIN
   OPEN order_conf;
   FETCH order_conf INTO allowed_;
   IF (order_conf%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE order_conf;
   RETURN allowed_;
END Reprint_Order_Conf_Allowed___;


-- Create_Manual_Credit_Msg___
--   This method decide message to be passed to the client based on the block reason and the order state.
PROCEDURE Create_Manual_Credit_Msg___(
   info_msg_     OUT    VARCHAR2,
   block_reason_ IN OUT VARCHAR2,
   objstate_     IN     VARCHAR2,
   prefix_       IN     VARCHAR2,
   blocked_type_ IN     VARCHAR2)
IS 
BEGIN  
   IF (block_reason_ != 'FALSE' AND block_reason_ IS NOT NULL) THEN      
      CASE block_reason_
         WHEN ('BLKFORCRE') THEN
            IF (objstate_ = 'Planned') THEN
               info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'PLANCREDITBLK: The :P1 customer is credit-blocked. However, the customer order will not be blocked as the customer order is in state Planned.', NULL, prefix_);
            ELSIF (objstate_ = 'Blocked') THEN               
               IF blocked_type_ = Customer_Order_Block_Type_API.DB_MANUAL_BLOCKED THEN
                  info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'MANBLOCKCREDITBLK: The :P1 customer is credit blocked. However, this customer order is manually blocked.', NULL, prefix_);
               ELSE
                  info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'BLOCKCREDITBLK: Customer order is still blocked since the :P1 customer is credit-blocked.', NULL, prefix_);
               END IF;
            ELSE
               info_msg_     := Language_SYS.Translate_Constant(lu_name_, 'QUECREDITBLK: The :P1 customer is credit-blocked. Do you want to block the customer order?', NULL, prefix_);
               block_reason_ := 'BLKFORCREMANUAL';
            END IF;
         WHEN ('BLKCRELMT') THEN
            IF (objstate_ = 'Planned') THEN
               info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'PLANCREDITLMT: The :P1 customer''s credit limit is being exceeded. However, the customer order will not be blocked as the customer order is in state Planned.', NULL, prefix_);
            ELSIF (objstate_ = 'Blocked') THEN
               IF blocked_type_ = Customer_Order_Block_Type_API.DB_MANUAL_BLOCKED THEN
                  info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'MANBLOCKCREDITLMT: The :P1 customer''s credit limit is being exceeded. However, this customer order is manually blocked.', NULL, prefix_);
               ELSE
                  info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'BLOCKCREDITLMT: The :P1 customer order is still blocked as the credit limit is being exceeded.', NULL, prefix_);
               END IF;               
            ELSE
               info_msg_     := Language_SYS.Translate_Constant(lu_name_, 'QUECREDITLMT: The :P1 customer''s credit limit is being exceeded. Do you want to block the customer order?', NULL, prefix_);
               block_reason_ := 'BLKCRELMTMANUAL';
            END IF;
         WHEN ('BLKFORADVPAY') THEN
            IF (objstate_ = 'Planned') THEN
               info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'PLANCREDITADVPAY: The required advanced payment has not been fully paid by the :P1 customer. However, the customer order will not be blocked as the customer order is in state Planned.', NULL, prefix_);
            ELSIF (objstate_ = 'Blocked') THEN
               IF blocked_type_ = Customer_Order_Block_Type_API.DB_MANUAL_BLOCKED THEN
                  info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'MANBLKCREDITADVPAY: The required advanced payment has not been fully paid by the :P1 customer. However, this customer order is manually blocked.', NULL, prefix_);
               ELSE
                  info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'BLKCREDITADVPAY: The :P1 customer order is still blocked as unpaid advance invoices exist.', NULL, prefix_);
               END IF;               
            ELSE
               info_msg_     := Language_SYS.Translate_Constant(lu_name_, 'QUECREDITADVPAY: The required advanced payment has not been fully paid by the :P1 customer. Do you want to block the customer order?', NULL, prefix_);
               block_reason_ := 'BLKFORADVPAYMANUAL';
            END IF;
         WHEN ('BLKFORPREPAY') THEN
            IF (objstate_ = 'Planned') THEN
               info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'PLANCREDITPREPAY: The required prepayment amount has not been fully paid by the :P1 customer. However, the customer order will not be blocked as the customer order is in state Planned.', NULL, prefix_);
            ELSIF (objstate_ = 'Blocked') THEN
               IF blocked_type_ = Customer_Order_Block_Type_API.DB_MANUAL_BLOCKED THEN
                  info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'MANBLKCREDITPREPAY: The required prepayment amount has not been fully paid by the :P1 customer. However, this customer order is manually blocked.', NULL, prefix_);
               ELSE
                  info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'BLKCREDITPREPAY: The :P1 customer order is still blocked. The required prepayment amount has not been fully paid.', NULL, prefix_);
               END IF;               
            ELSE
               info_msg_     := Language_SYS.Translate_Constant(lu_name_, 'QUECREDITPREPAY: The required prepayment amount has not been fully paid by the :P1 customer. Do you want to block the customer order?', NULL, prefix_);
               block_reason_ := 'BLKFORPREPAYMANUAL';
            END IF;
         ELSE
            IF (objstate_ = 'Blocked') THEN
               info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'MANUALBLOCK: The customer order is manually blocked.', NULL, prefix_);
            ELSE
               NULL;
            END IF;
      END CASE;
   ELSE
      IF (objstate_ = 'Blocked') THEN
         IF blocked_type_ = Customer_Order_Block_Type_API.DB_MANUAL_BLOCKED THEN
            info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'CREDITOKRELMANBLOCK: The customer order is not credit-blocked. However, this customer order is manually blocked. Do you want to release the blocked order?', NULL);         
         ELSE            
            info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'BLOCKCREDITOK: This customer order is not credit-blocked. Do you want to release from the blocked order?', NULL);         
         END IF;
      ELSE
         info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'CREDITCHECKOK: Customer order is not credit-blocked.', NULL);
      END IF;
   END IF;
END Create_Manual_Credit_Msg___;


-- Generate_Next_Level_Demands___
--   Generate next level supply demands for parts having MRP order code = 'N'
PROCEDURE Generate_Next_Level_Demands___ (
   order_no_ IN VARCHAR2 )
IS
   disp_qty_ NUMBER;
   
   CURSOR get_lines IS
      SELECT revised_qty_due, planned_due_date,
             contract, part_no, configuration_id, part_ownership, condition_code
      FROM customer_order_line_tab
      WHERE order_no = order_no_
      AND   supply_code = 'IO'
      AND   part_ownership = 'COMPANY OWNED';
BEGIN
   FOR line_rec_ IN get_lines LOOP
      IF ((Inventory_Part_Planning_API.Get_Planning_Method(line_rec_.contract, line_rec_.part_no) = 'N') AND 
          (line_rec_.part_ownership = Part_Ownership_API.DB_COMPANY_OWNED)) THEN
         disp_qty_ := Inventory_Part_In_Stock_API.Get_Inventory_Quantity(contract_           => line_rec_.contract,
                                                                         part_no_            => line_rec_.part_no,
                                                                         configuration_id_   => line_rec_.configuration_id,
                                                                         qty_type_           => 'ONHAND',
                                                                         expiration_control_ => 'NOT EXPIRED',
                                                                         supply_control_db_  => 'NETTABLE',
                                                                         ownership_type1_db_ => Part_Ownership_API.DB_COMPANY_OWNED,
                                                                         ownership_type2_db_ => Part_Ownership_API.DB_CONSIGNMENT,
                                                                         ownership_type3_db_ => Part_Ownership_API.DB_SUPPLIER_LOANED,
                                                                         ownership_type4_db_ => Part_Ownership_API.DB_CUSTOMER_OWNED,
                                                                         location_type1_db_  => 'PICKING',
                                                                         location_type2_db_  => 'F',
                                                                         location_type3_db_  => 'MANUFACTURING',
                                                                         location_type4_db_  => 'SHIPMENT');
         Order_Supply_Demand_API.Generate_Next_Level_Demands(line_rec_.revised_qty_due,
                                                             line_rec_.planned_due_date,
                                                             line_rec_.contract,
                                                             line_rec_.part_no,
                                                             line_rec_.configuration_id,
                                                             line_rec_.condition_code);
      END IF;
   END LOOP;
END Generate_Next_Level_Demands___;


-- Calculate_Credit_Used___
--   Calculate the amount of credit used by the specified customer on orders
--   not yet invoiced. If an order_no is passed in this order will be
--   excluded from the calculation
FUNCTION Calculate_Credit_Used___ (
   company_     IN VARCHAR2,
   customer_no_ IN VARCHAR2,
   order_no_    IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   credit_amount_        NUMBER := 0;
   rounding_             NUMBER;
   exclude_credit_limit_ VARCHAR2(5); 
   pay_term_id_          VARCHAR2(20);
   curr_rounding_        NUMBER;
   customer_order_rec_   Customer_Order_API.Public_Rec;
   
   CURSOR credit_used IS
      SELECT col.order_no,
             col.line_no,
             col.rel_no,
             col.line_item_no,
             col.revised_qty_due,
             col.qty_shipdiff,
             col.conv_factor,
             col.inverted_conv_factor,
             col.price_conv_factor,
             col.qty_invoiced,
             col.sale_unit_price,
             col.unit_price_incl_tax,
             col.currency_rate,
             col.order_discount,
             col.additional_discount,             
             col.rental,
             col.buy_qty_due,
             co.pay_term_id
      FROM   customer_order_line_tab col, customer_order_tab co, site_public s
      WHERE  co.contract = s.contract
      AND    s.company = company_
      AND    ((co.customer_no_pay = customer_no_ AND co.customer_no_pay IS NOT NULL) OR (co.customer_no = customer_no_ AND co.customer_no_pay IS NULL))
      AND    co.rowstate IN ('Blocked', 'Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
      AND    co.order_no = col.order_no
      AND    col.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
      AND    col.line_item_no <= 0
      AND    (order_no_ IS NULL OR co.order_no != order_no_);
BEGIN
   rounding_             := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));      

   FOR ordrowrec_ IN credit_used LOOP
      exclude_credit_limit_ := Payment_Term_API.Get_Exclude_Credit_Limit(company_, ordrowrec_.pay_term_id);
      customer_order_rec_            := Customer_Order_API.Get(ordrowrec_.order_no);
      curr_rounding_        := Currency_Code_API.Get_Currency_Rounding(company_, customer_order_rec_.currency_code);
      
      IF exclude_credit_limit_= 'FALSE' THEN
         credit_amount_ := credit_amount_ + Calc_Line_Gross_Amount___(
                                                company_,
                                                ordrowrec_.order_no,
                                                ordrowrec_.line_no,
                                                ordrowrec_.rel_no,
                                                ordrowrec_.line_item_no,
                                                ordrowrec_.revised_qty_due,
                                                ordrowrec_.qty_shipdiff,
                                                ordrowrec_.conv_factor,
                                                ordrowrec_.inverted_conv_factor,
                                                ordrowrec_.price_conv_factor,
                                                ordrowrec_.qty_invoiced,
                                                ordrowrec_.sale_unit_price,
                                                ordrowrec_.unit_price_incl_tax,
                                                ordrowrec_.currency_rate,
                                                ordrowrec_.order_discount,
                                                ordrowrec_.additional_discount,
                                                ordrowrec_.rental,
                                                rounding_,
                                                curr_rounding_,
                                                customer_order_rec_.use_price_incl_tax,
                                                ordrowrec_.buy_qty_due);
      END IF;
   END LOOP;
   credit_amount_ := nvl(credit_amount_, 0);
   
   RETURN credit_amount_;
END Calculate_Credit_Used___;


-- Calc_Charge_Credit_Used___
--   Calculate the amount of charge credit used by the specified customer on
--   orders not yet invoiced.
--   If an order_no is passed in this order will be excluded from the
FUNCTION Calc_Charge_Credit_Used___ (
   company_     IN VARCHAR2,
   customer_no_ IN VARCHAR2,
   order_no_    IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   rounding_                     NUMBER;
   credit_amount_                NUMBER := 0;
   exclude_credit_limit_         VARCHAR2(5);
   
   CURSOR charge_credit_used IS
      SELECT coc.order_no,
             coc.sequence_no,
             coc.charged_qty,
             coc.charge,
             coc.currency_rate,
             co.pay_term_id,
             coc.charge_amount,
             coc.charge_amount_incl_tax,
             co.use_price_incl_tax
      FROM   CUSTOMER_ORDER_CHARGE_TAB coc, customer_order_tab co, site_public s
      WHERE  co.contract = s.contract
      AND    s.company = company_
      AND    ((co.customer_no_pay = customer_no_ AND co.customer_no_pay IS NOT NULL) OR (co.customer_no = customer_no_ AND co.customer_no_pay IS NULL))
      AND    co.rowstate IN ('Blocked', 'Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
      AND    co.order_no = coc.order_no
      AND    (ABS(coc.invoiced_qty) < ABS(coc.charged_qty) AND coc.invoiced_qty IS NOT NULL)
      AND    collect = 'INVOICE'
      AND    (order_no_ IS NULL OR co.order_no != order_no_);
BEGIN
   rounding_             := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   
   FOR chargerec_ IN charge_credit_used LOOP
      exclude_credit_limit_ := Payment_Term_API.Get_Exclude_Credit_Limit(company_, chargerec_.pay_term_id);
      IF exclude_credit_limit_= 'FALSE' THEN      
         credit_amount_ := credit_amount_ + Customer_Order_Charge_API.Get_Tot_Base_Chg_Amt_Incl_Tax (chargerec_.order_no,
                                                                                                     chargerec_.sequence_no,
                                                                                                     company_,
                                                                                                     chargerec_.charged_qty,
                                                                                                     chargerec_.charge_amount,
                                                                                                     chargerec_.charge_amount_incl_tax,
                                                                                                     chargerec_.charge,
                                                                                                     chargerec_.currency_rate,
                                                                                                     rounding_,
                                                                                                     chargerec_.use_price_incl_tax);
      END IF;
   END LOOP;
   RETURN nvl(credit_amount_, 0);
END Calc_Charge_Credit_Used___;


-- Check_Mandatory_Postings___
--   Make sure that all mandatory pre postings have been made for the order
--   This check should be made when the order is released.
PROCEDURE Check_Mandatory_Postings___ (
   order_no_ IN VARCHAR2 )
IS
   order_rec_         Customer_Order_API.Public_Rec;
   company_           VARCHAR2(20);
   source_id_         VARCHAR2(200);
   customer_company_  VARCHAR2(20);
   check_code_parts_  BOOLEAN := TRUE; 
   
   purchase_order_no_ VARCHAR2(12) := NULL;
   order_code_        VARCHAR2(20) := NULL;
   dummy_             NUMBER;
   dummy1_            VARCHAR2(4);
   CURSOR get_order_lines IS
      SELECT line_no, rel_no, pre_accounting_id
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND rowstate != 'Cancelled'
      AND charged_item = 'CHARGED ITEM'
      AND exchange_item = 'ITEM NOT EXCHANGED';
BEGIN
   order_rec_ := Customer_Order_API.Get(order_no_);
   company_   := Site_API.Get_Company(order_rec_.contract);

   $IF (Component_Purch_SYS.INSTALLED) $THEN       
      Pur_Order_Cust_Order_Comp_API.Get_Order_no(purchase_order_no_, order_no_);
      order_code_ := Purchase_Order_API.Get_Order_Code(purchase_order_no_);                 
   $END
  
   customer_company_ := Site_API.Get_Company(Cust_Ord_Customer_API.Get_Acquisition_Site(order_rec_.customer_no));
   
   -- Do not check postings if order is internal and customer and acquisition site are the same.
   -- Order is internal if there is an acquisition site to compare with, so this condition is enough.
   IF (company_ = customer_company_ OR (purchase_order_no_ IS NOT NULL AND order_code_= '6')) THEN
      check_code_parts_ := FALSE;
   END IF;   

   IF (check_code_parts_) THEN
      OPEN get_order_lines;
      FETCH get_order_lines INTO dummy1_,dummy1_,dummy_;
      IF (get_order_lines%NOTFOUND) THEN
         check_code_parts_ := FALSE;
      END IF;
      CLOSE get_order_lines;
   END IF;

   -- Check Mandatory postings on order head
   IF (check_code_parts_) THEN
      source_id_ := Language_SYS.Translate_Constant(lu_name_, 'SOURCEID_1: Customer Order :P1', NULL, order_no_);
      Pre_Accounting_Api.Check_Mandatory_Code_Parts(order_rec_.pre_accounting_id, 'M103', company_, source_id_);

      -- Check mandatory postings on all order lines.
      FOR next_line_ in get_order_lines LOOP
         source_id_ := Language_SYS.Translate_Constant(lu_name_, 'SOURCEID_2: Customer Order :P1 Line No :P2 Del No :P3',
                                                       NULL, order_no_, next_line_.line_no, next_line_.rel_no);
         Pre_Accounting_Api.Check_Mandatory_Code_Parts(next_line_.pre_accounting_id, 'M104', company_, source_id_);
      END LOOP;
   END IF;
END Check_Mandatory_Postings___;


-- Check_Project_Approved___
--   Make sure that any project connected to this order have been approved
--   This check should be made when the order is released.
PROCEDURE Check_Project_Approved___ (
   order_no_ IN VARCHAR2 )
IS
   order_rec_   Customer_Order_API.Public_Rec;
   is_approved_ NUMBER;
BEGIN
   order_rec_ := Customer_Order_API.Get(order_no_);
   IF (order_rec_.project_id IS NOT NULL) THEN
      $IF (Component_Proj_SYS.INSTALLED) $THEN
         is_approved_ := Project_API.Is_Approved(order_rec_.project_id); 
      $END
      -- raise error if project is not approved
      IF (is_approved_ = 0) THEN
         Error_SYS.Record_General(lu_name_, 'COPROJNOTAPPROVED: Connected Project have not been approved yet');
      END IF;
   END IF;
END Check_Project_Approved___;


-- Get_Uninvoiced_Order_Value___
--   Calculate the uninvoived order value for the specified order.
FUNCTION Get_Uninvoiced_Order_Value___ (
   company_  IN VARCHAR2,
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   rounding_             NUMBER;
   total_uninvoiced_     NUMBER := 0;
   exclude_credit_limit_ VARCHAR2(5);
   curr_rounding_        NUMBER;
   customer_order_rec_   Customer_Order_API.Public_Rec;
   
   -- Get the total value for goods remaining to be invoiced
   -- Take in account any shipping differences made and do not include what has already been invoiced
   CURSOR get_uninvoiced_totals IS
      SELECT line_no,
             rel_no,
             line_item_no,
             revised_qty_due,
             qty_shipdiff,
             conv_factor,
             inverted_conv_factor,
             price_conv_factor,
             qty_invoiced,
             sale_unit_price,
             unit_price_incl_tax,
             currency_rate,
             order_discount,
             additional_discount,
             rental,
             buy_qty_due
      FROM  CUSTOMER_ORDER_LINE_TAB
      WHERE rowstate NOT IN ('Cancelled', 'Invoiced')
      AND   line_item_no <= 0
      AND   order_no = order_no_;
BEGIN
   rounding_             := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   customer_order_rec_   := Customer_Order_API.Get(order_no_);
   exclude_credit_limit_ := Payment_Term_API.Get_Exclude_Credit_Limit(company_, customer_order_rec_.pay_term_id);
   curr_rounding_        := Currency_Code_API.Get_Currency_Rounding(company_, customer_order_rec_.Currency_Code);
   
   IF exclude_credit_limit_= 'FALSE' THEN
      -- First retrive the order value not yet invoiced for the specified order
      FOR ordrowrec_ IN get_uninvoiced_totals LOOP
         total_uninvoiced_ := total_uninvoiced_ + Calc_Line_Gross_Amount___(
                                                      company_,
                                                      order_no_,
                                                      ordrowrec_.line_no,
                                                      ordrowrec_.rel_no,
                                                      ordrowrec_.line_item_no,
                                                      ordrowrec_.revised_qty_due,
                                                      ordrowrec_.qty_shipdiff,
                                                      ordrowrec_.conv_factor,
                                                      ordrowrec_.inverted_conv_factor,
                                                      ordrowrec_.price_conv_factor,
                                                      ordrowrec_.qty_invoiced,
                                                      ordrowrec_.sale_unit_price,
                                                      ordrowrec_.unit_price_incl_tax,
                                                      ordrowrec_.currency_rate,
                                                      ordrowrec_.order_discount,
                                                      ordrowrec_.additional_discount,
                                                      ordrowrec_.rental,
                                                      rounding_,
                                                      curr_rounding_,
                                                      customer_order_rec_.use_price_incl_tax,
                                                      ordrowrec_.buy_qty_due);
      END LOOP;
   END IF;
   RETURN nvl(total_uninvoiced_, 0);
END Get_Uninvoiced_Order_Value___;


-- Get_Uninvoiced_Charge_Value___
--   Calculate the uninvoived charges value for the specified order
--   and returns it
FUNCTION Get_Uninvoiced_Charge_Value___ (
   company_  IN VARCHAR2,
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   rounding_                     NUMBER;
   total_uninvoiced_             NUMBER := 0;
   exclude_credit_limit_         VARCHAR2(5);
   order_rec_                    Customer_Order_API.Public_Rec;
   
   -- Get the total value for charges remaining to be invoiced
   CURSOR get_uninvoiced_charges IS
      SELECT sequence_no,
             charged_qty,
             charge_amount,
             charge_amount_incl_tax,
             charge,
             currency_rate
      FROM  CUSTOMER_ORDER_CHARGE_TAB
      WHERE (ABS(invoiced_qty) < ABS(charged_qty) AND invoiced_qty IS NOT NULL)
      AND   collect  = 'INVOICE'
      AND   order_no = order_no_;
BEGIN
   rounding_             := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   order_rec_            := Customer_Order_API.Get(order_no_);
   exclude_credit_limit_ := Payment_Term_API.Get_Exclude_Credit_Limit(company_, order_rec_.pay_term_id);
   
   IF exclude_credit_limit_= 'FALSE' THEN
      -- First retrive the charge value not yet invoiced for the specified order
      FOR chargerec_ IN get_uninvoiced_charges LOOP

         total_uninvoiced_ := total_uninvoiced_ + Customer_Order_Charge_API.Get_Tot_Base_Chg_Amt_Incl_Tax (order_no_,
                                                                                                           chargerec_.sequence_no,
                                                                                                           company_,
                                                                                                           chargerec_.charged_qty,
                                                                                                           chargerec_.charge_amount,
                                                                                                           chargerec_.charge_amount_incl_tax,
                                                                                                           chargerec_.charge,
                                                                                                           chargerec_.currency_rate,
                                                                                                           rounding_,
                                                                                                           order_rec_.use_price_incl_tax);
      END LOOP;
   END IF;
   RETURN nvl(total_uninvoiced_, 0);
END Get_Uninvoiced_Charge_Value___;


-- Calc_Line_Gross_Amount___
--   Calculate a line's total gross amount (including vats/us sales tax
--   and discounts)
FUNCTION Calc_Line_Gross_Amount___ (
   company_              IN VARCHAR2,
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER,
   revised_qty_due_      IN NUMBER,
   qty_shipdiff_         IN NUMBER,
   conv_factor_          IN NUMBER,
   inverted_conv_factor_ IN NUMBER,
   price_conv_factor_    IN NUMBER,
   qty_invoiced_         IN NUMBER,
   sale_unit_price_      IN NUMBER,
   unit_price_incl_tax_  IN NUMBER,
   currency_rate_        IN NUMBER,
   order_discount_       IN NUMBER,
   add_discount_         IN NUMBER,
   rental_               IN VARCHAR2,
   rounding_             IN NUMBER,
   curr_rounding_        IN NUMBER,
   use_price_incl_tax_   IN VARCHAR2,
   buy_qty_due_          IN NUMBER) RETURN NUMBER
IS
   net_base_amount_         NUMBER := 0;
   line_discount_           NUMBER;
   quantity_                NUMBER;
   net_amount_              NUMBER := 0;
   gross_amount_            NUMBER := 0;   
   gross_base_amount_       NUMBER;
   add_disc_amt_            NUMBER;
   order_disc_amt_          NUMBER;
   total_discount_          NUMBER;
   rental_transaction_days_ NUMBER;
   rental_planned_days_     NUMBER;
   total_rental_days_       NUMBER;
   
BEGIN
   $IF Component_Rental_SYS.INSTALLED $THEN     
      IF rental_ = 'TRUE' THEN
         rental_transaction_days_ := NVL(Rental_Transaction_Manager_API.Sum_Total_Chrg_Days(order_no_, line_no_, rel_no_, line_item_no_, Rental_Type_API.DB_CUSTOMER_ORDER),1);
         rental_planned_days_     := NVL(Rental_Object_API.Get_Chargeable_Days(Rental_Object_API.Get_Rental_No(order_no_, line_no_, rel_no_, line_item_no_, Rental_Type_API.DB_CUSTOMER_ORDER)),1);
         total_rental_days_       := GREATEST(rental_planned_days_, rental_transaction_days_); 
      ELSE
         total_rental_days_       := 1;
      END IF;
   $ELSE
      rental_transaction_days_ := 1;
      rental_planned_days_     := 1;
      total_rental_days_       := 1;
   $END
     
   quantity_               := ((((revised_qty_due_ * total_rental_days_) + qty_shipdiff_) / conv_factor_ * inverted_conv_factor_ * price_conv_factor_ ) - (qty_invoiced_ * price_conv_factor_)) ;
   line_discount_          := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(order_no_, line_no_, rel_no_, line_item_no_, 
                                                                                   quantity_, 1, curr_rounding_);
   IF (use_price_incl_tax_ = 'TRUE') THEN
      gross_amount_      := (quantity_ * unit_price_incl_tax_ );
      -- Calculate discounts with tax
      add_disc_amt_      := ROUND((gross_amount_ - line_discount_)*add_discount_/100,curr_rounding_); 
      order_disc_amt_    := ROUND((gross_amount_ - line_discount_)*order_discount_/100,curr_rounding_);
      total_discount_    := line_discount_ + add_disc_amt_ + order_disc_amt_;
      gross_amount_      := ROUND(gross_amount_, curr_rounding_) - total_discount_;
      gross_base_amount_ := ROUND( NVL(gross_amount_,0) * currency_rate_, rounding_);
   ELSE
      net_amount_      := ROUND(NVL(((quantity_ * sale_unit_price_)  - line_discount_) * (1 - (order_discount_ + add_discount_) / 100), 0), curr_rounding_ );
      -- calculate net base amount
      net_base_amount_ := ROUND( net_amount_ * currency_rate_, rounding_);
      -- Tax details of customer order line, have calculated and saved by the amounts calculated based on buy_qty_due. 
      -- When calculate tax_dom_amount for non-invoiced quantity, it is sufficient to get proportional value based on quantity,
      -- rather than doing the whole calculation again.
      IF buy_qty_due_ != 0 THEN
	 -- Considered price_conv_factor_ along with buy_qty_due_ when calculating tax amount which is used to calculate gross_base_amount_.
         gross_base_amount_ := net_base_amount_ + ROUND((Source_Tax_Item_API.Get_Total_Tax_Dom_Amount(company_, 
                                                                                                Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                                                                order_no_, 
                                                                                                line_no_, 
                                                                                                rel_no_, 
                                                                                                line_item_no_, 
                                                                                                '*') * quantity_ )/ (buy_qty_due_ * price_conv_factor_), rounding_);
      END IF;
      gross_base_amount_ := NVL(gross_base_amount_,0);
   END IF;
   --Correction: negative amounts not allowed.
   IF gross_base_amount_ < 0 THEN
      gross_base_amount_ := 0;
   END IF;
   RETURN gross_base_amount_;
END Calc_Line_Gross_Amount___;


-- Check_Dist_Order_State___
--   Check the state of the Distribution Order and change it's state
--   according to the Customer Order state.
PROCEDURE Check_Dist_Order_State___ (
   order_no_ IN VARCHAR2 )
IS
   CURSOR get_do_details IS
      SELECT demand_order_ref1
        FROM customer_order_line_tab
       WHERE order_no  = order_no_
         AND rowstate != 'Cancelled';

   objstate_   VARCHAR2(20);
   stmt_       VARCHAR2(2000);
BEGIN
   objstate_ := Customer_Order_API.Get_Objstate(order_no_);
   IF (objstate_ IN ('Released','Reserved')) THEN
      FOR do_rec_ IN get_do_details LOOP
         stmt_ := 'BEGIN Distribution_Order_API.Check_State(:order_no, :event); END;';
         @ApproveDynamicStatement(2006-01-24,JaJalk)
         EXECUTE IMMEDIATE stmt_ USING IN do_rec_.demand_order_ref1, IN 'Release';
      END LOOP;
   END IF;
END Check_Dist_Order_State___;


-- Check_Manual_Tax_Lia_Date___
--   Check for tax codes with tax liability date type Manual.
PROCEDURE Check_Manual_Tax_Lia_Date___ (
   invoice_id_ IN NUMBER,
   order_no_   IN VARCHAR2 )
IS
   invoice_type_           CUSTOMER_ORDER_INV_HEAD.invoice_type%TYPE;
   company_                CUSTOMER_ORDER_INV_HEAD.company%TYPE;
   invoice_series_id_      CUSTOMER_ORDER_INV_HEAD.series_id%TYPE;
   has_man_tax_liab_lines_ VARCHAR2(5);
   info_                   VARCHAR2(2000);

   CURSOR get_item_rec IS
      SELECT item_id,man_tax_liability_date
      FROM   cust_invoice_pub_util_item
      WHERE  company    = company_
      AND    invoice_id = invoice_id_;
BEGIN
   company_      := Site_API.Get_Company(Customer_Order_API.Get_Contract(order_no_));
   invoice_type_ := Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, invoice_id_);

   FOR item_rec_ IN get_item_rec LOOP
      IF (item_rec_.man_tax_liability_date IS NULL) THEN
         has_man_tax_liab_lines_ := Customer_Order_Inv_Item_API.Has_Manual_Tax_Liablty_Lines(company_,invoice_id_,item_rec_.item_id,invoice_type_);
         IF (has_man_tax_liab_lines_ = 'TRUE') THEN
            invoice_series_id_ := Customer_Order_Inv_Head_API.Get_Series_Id(company_,NULL, NULL, invoice_id_);
            info_              := Language_SYS.Translate_Constant(lu_name_, 'NOMANTAXLIADATE: This invoice has a tax code defined with Tax Liability Date type as Manual. But no tax liability date specified on invoice/tax lines for invoice :P1 :P2.', NULL, invoice_series_id_, invoice_id_);
            Transaction_SYS.Set_Status_Info(info_);
         END IF;
      END IF;
   END LOOP;
END Check_Manual_Tax_Lia_Date___;


-- Create_Rma_Lines___
--   This method is called when creating the RMA from CO header / CO line.
--   Also in the multisite return hanlding flow, we use this to create the
--   recipt RMA from demand rma, which can be differenciated by the existance
--   of the org_rma_line_no_
PROCEDURE Create_Rma_Lines___ (
   inv_count_           OUT NUMBER,
   receipt_rma_line_no_ OUT NUMBER,
   order_no_            IN  VARCHAR2,
   line_no_             IN  VARCHAR2,
   rel_no_              IN  VARCHAR2,
   line_item_no_        IN  NUMBER,
   rma_attr_            IN  VARCHAR2 ) 
IS   
   info_                  VARCHAR2(2000);   
   line_attr_             VARCHAR2(2000);    
BEGIN
   Build_Attr_Create_Rma_Lines___(line_attr_, inv_count_, rma_attr_, order_no_, line_no_, rel_no_, line_item_no_); 
      
   IF Client_SYS.Get_Item_Value('QTY_TO_RETURN', line_attr_) > 0 THEN
      Return_Material_Line_API.New(info_, line_attr_);
      receipt_rma_line_no_ := Client_SYS.Get_Item_Value('RMA_LINE_NO', line_attr_); 
   END IF;
END Create_Rma_Lines___;


-- Start_Plan_Picking___
--   Pick plan all lines passed from the client.
--   Make one deferred call for each order processed if the data is retreived through
--   the attribute string.
--   Make one deferred call for each order processed or when the order_attr_ length exceeds 2000.
PROCEDURE Start_Plan_Picking___ (
   attr_         IN OUT VARCHAR2,
   ord_ship_tab_ IN     Reserve_Shipment_API.Reserve_Shipment_Table,
   shipment_id_  IN     NUMBER )
IS
   curr_order_no_              VARCHAR2(12);
   order_attr_                 VARCHAR2(32000);
   ptr_                        NUMBER;
   name_                       VARCHAR2(30);
   value_                      VARCHAR2(2000);
   description_                VARCHAR2(200);
   temp_attr_                  VARCHAR2(32000);
   ord_ship_tab1_              Reserve_Shipment_API.Reserve_Shipment_Table;
   row_count_                  NUMBER := 0;
   online_process_db_          VARCHAR2(5);
BEGIN
   -- Add the order lines retrieved from attr_/data table to ord_ship_tab1_.
   IF (attr_ IS NOT NULL) THEN
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'ORDER_NO') THEN
            ord_ship_tab1_(row_count_).source_ref1          := value_;
         ELSIF (name_ = 'LINE_NO') THEN
            ord_ship_tab1_(row_count_).source_ref2          := value_;
         ELSIF (name_ = 'REL_NO') THEN
            ord_ship_tab1_(row_count_).source_ref3          := value_;
         ELSIF (name_ = 'LINE_ITEM_NO') THEN
            ord_ship_tab1_(row_count_).source_ref4          := value_;
         ELSIF (name_ = 'CONTRACT') THEN
            ord_ship_tab1_(row_count_).contract             := value_;
         ELSIF (name_ = 'PART_NO') THEN
            ord_ship_tab1_(row_count_).inventory_part_no    := value_;
            row_count_ := row_count_ + 1;
         END IF;
      END LOOP;
   ELSE
      ord_ship_tab1_ := ord_ship_tab_; 
      IF (ord_ship_tab1_.COUNT > 0) THEN
         online_process_db_ := Shipment_Type_API.Get_Online_Processing_Db(Customer_Order_API.Get_Shipment_Type(ord_ship_tab1_(ord_ship_tab1_.FIRST).source_ref1));
      END IF;
   END IF;

   -- Added ord_ship_tab1_ to the parameter list.
   -- Sort the lines by date entered, order no, site and part number.
   Sort_Lines_By_Date_Entered___(ord_ship_tab1_);
   Client_SYS.Clear_Attr(order_attr_);
   description_   := Language_SYS.Translate_Constant(lu_name_, 'PICKPLAN_LINES: Reserve Customer Orders');
   
   curr_order_no_ := ord_ship_tab1_(ord_ship_tab1_.FIRST).source_ref1;
   IF ( shipment_id_ = 0 ) THEN
      online_process_db_ := Cust_Order_Type_API.Get_Online_Processing_Db(Customer_Order_API.Get_Order_Id(curr_order_no_));
   END IF;
   Client_SYS.Add_To_Attr('ORDER_NO', ord_ship_tab1_(ord_ship_tab1_.FIRST).source_ref1, order_attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_,                                  order_attr_);

   FOR index_ IN ord_ship_tab1_.FIRST..ord_ship_tab1_.LAST LOOP
      IF (ord_ship_tab1_(index_).source_ref1 != curr_order_no_) THEN
         -- New order number => make deferred call for the previous order
         IF (Transaction_SYS.Is_Session_Deferred) OR ( online_process_db_ = db_true_) THEN
            Customer_Order_Flow_API.Reserve_Order_Lines__(order_attr_);
         ELSE   
            Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Reserve_Order_Lines__', order_attr_, description_);
         END IF;
         Client_SYS.Clear_Attr(order_attr_);
         Client_SYS.Add_To_Attr('ORDER_NO', ord_ship_tab1_(index_).source_ref1, order_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID',  shipment_id_,                        order_attr_);
         Client_SYS.Add_To_Attr('LINE_NO', ord_ship_tab1_(index_).source_ref2, order_attr_);
         Client_SYS.Add_To_Attr('REL_NO', ord_ship_tab1_(index_).source_ref3, order_attr_);
         Client_SYS.Add_To_Attr('LINE_ITEM_NO', ord_ship_tab1_(index_).source_ref4, order_attr_);
         curr_order_no_ := ord_ship_tab1_(index_).source_ref1;
         IF ( shipment_id_ = 0 ) THEN
            online_process_db_ := Cust_Order_Type_API.Get_Online_Processing_Db(Customer_Order_API.Get_Order_Id(curr_order_no_));
         END IF;
      ELSE
         Client_SYS.Clear_Attr(temp_attr_);
         Client_SYS.Add_To_Attr('LINE_NO', ord_ship_tab1_(index_).source_ref2, temp_attr_);
         Client_SYS.Add_To_Attr('REL_NO', ord_ship_tab1_(index_).source_ref3, temp_attr_);
         Client_SYS.Add_To_Attr('LINE_ITEM_NO', ord_ship_tab1_(index_).source_ref4, temp_attr_); 

         IF (length(order_attr_ || temp_attr_) <= 2000) THEN
            order_attr_ := order_attr_ || temp_attr_;
         ELSE
            -- if the attribute string length will exceed 2000, 
            -- make deferred call for the data already in the attribute string.
            IF (Transaction_SYS.Is_Session_Deferred) OR ( online_process_db_ = db_true_) THEN
               Customer_Order_Flow_API.Reserve_Order_Lines__(order_attr_);
            ELSE               
               Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Reserve_Order_Lines__', order_attr_, description_);
            END IF;
            Client_SYS.Clear_Attr(order_attr_);
            Client_SYS.Add_To_Attr('ORDER_NO', ord_ship_tab1_(index_).source_ref1, order_attr_);
            Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_,                 order_attr_);
            order_attr_ := order_attr_ || temp_attr_;
         END IF;
      END IF;
   END LOOP; 

   -- Process the last order
   IF (Transaction_SYS.Is_Session_Deferred) OR ( online_process_db_ = db_true_) THEN
      Customer_Order_Flow_API.Reserve_Order_Lines__(order_attr_);
   ELSE      
      Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Reserve_Order_Lines__', order_attr_, description_);           
   END IF;      
END Start_Plan_Picking___;


-- Create_Rma_Charge_Lines___
--   Adds Return Material Lines related to the given Customer Order Line.
PROCEDURE Create_Rma_Charge_Lines___ (
   order_no_      IN VARCHAR2,
   sequence_no_   IN NUMBER,
   rma_no_        IN VARCHAR2,
   contract_      IN VARCHAR2,
   charge_type_   IN VARCHAR2,
   qty_to_return_ IN NUMBER ) 
IS
   attr_                      VARCHAR2(32000);
   info_                      VARCHAR2(2000);
   base_charge_amount_        NUMBER;
   base_charge_amt_incl_tax_  NUMBER;
   charge_cost_               NUMBER;
   charge_amount_             NUMBER;
   charge_amount_incl_tax_    NUMBER;
   charge_                    NUMBER;
   sales_unit_meas_           VARCHAR2(30);
   charge_cost_percent_       NUMBER;
   charge_percent_basis_      NUMBER;
   base_charge_percent_basis_ NUMBER;
   company_                   VARCHAR2(20);
   use_price_incl_tax_        VARCHAR2(20);
   tax_liability_             VARCHAR2(20);
   curr_rate_                 NUMBER;
   cust_tax_usage_type_       VARCHAR2(5);
BEGIN
   use_price_incl_tax_        := Return_Material_API.Get_Use_Price_Incl_Tax_Db(rma_no_);
   Return_Material_Charge_API.Get_Co_Charge_Info(attr_, contract_, charge_type_, order_no_, sequence_no_, use_price_incl_tax_);
   
   base_charge_amount_        := Client_SYS.Get_Item_Value('BASE_CHARGE_AMOUNT', attr_);
   base_charge_amt_incl_tax_  := Client_SYS.Get_Item_Value('BASE_CHARGE_AMT_INCL_TAX', attr_);
   charge_cost_               := Client_SYS.Get_Item_Value('CHARGE_COST', attr_);
   charge_amount_             := Client_SYS.Get_Item_Value('CHARGE_AMOUNT', attr_);
   charge_amount_incl_tax_    := Client_SYS.Get_Item_Value('CHARGE_AMOUNT_INCL_TAX', attr_);
   charge_                    := Client_SYS.Get_Item_Value('CHARGE', attr_);
   sales_unit_meas_           := Client_SYS.Get_Item_Value('SALES_UNIT_MEAS', attr_);
   charge_cost_percent_       := Client_SYS.Get_Item_Value('CHARGE_COST_PERCENT', attr_);
   charge_percent_basis_      := Client_SYS.Get_Item_Value('CHARGE_PERCENT_BASIS', attr_);
   base_charge_percent_basis_ := Client_SYS.Get_Item_Value('BASE_CHARGE_PERCENT_BASIS', attr_);
   company_                   := Site_API.Get_Company(contract_);
   tax_liability_             := Client_SYS.Get_Item_Value('TAX_LIABILITY', attr_); 
   curr_rate_                 := Client_SYS.Get_Item_Value('CURRENCY_RATE', attr_);
   cust_tax_usage_type_       := Client_SYS.Get_Item_Value('CUSTOMER_TAX_USAGE_TYPE', attr_);
   
   Client_SYS.Clear_Attr(attr_);
   
   IF (qty_to_return_ > 0) THEN      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('RMA_NO',rma_no_ , attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
      Client_SYS.Add_To_Attr('CHARGE_TYPE',charge_type_ , attr_);
      Client_SYS.Add_To_Attr('ORDER_NO',order_no_ , attr_);
      Client_SYS.Add_To_Attr('SEQUENCE_NO',sequence_no_ , attr_);
      Client_SYS.Add_To_Attr('CHARGED_QTY',qty_to_return_ , attr_);
      Client_SYS.Add_To_Attr('COMPANY',company_ , attr_);
      Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', base_charge_amt_incl_tax_, attr_);
      Client_SYS.Add_To_Attr('CHARGE_COST',charge_cost_ , attr_);
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT',charge_amount_ , attr_);
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',charge_amount_incl_tax_ , attr_);
      Client_SYS.Add_To_Attr('CHARGE',charge_ , attr_);
      Client_SYS.Add_To_Attr('SALES_UNIT_MEAS',sales_unit_meas_ , attr_);
      Client_SYS.Add_To_Attr('CHARGE_COST_PERCENT',charge_cost_percent_ , attr_);
      Client_SYS.Add_To_Attr('CHARGE_PERCENT_BASIS',charge_percent_basis_ , attr_);
      Client_SYS.Add_To_Attr('BASE_CHARGE_PERCENT_BASIS',base_charge_percent_basis_ , attr_);
      Client_SYS.Add_To_Attr('DATE_ENTERED',Site_API.Get_Site_Date(contract_) , attr_);
      Client_SYS.Add_To_Attr('DELIVERY_TYPE', Customer_Order_Charge_API.Get_Delivery_Type(order_no_, sequence_no_) , attr_);
      Client_SYS.Add_To_Attr('TAX_LIABILITY', tax_liability_ , attr_);
      Client_SYS.Add_To_Attr('CURRENCY_RATE', curr_rate_, attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', cust_tax_usage_type_, attr_);
      
      Return_Material_Charge_API.New(info_, attr_);
   END IF;
END Create_Rma_Charge_Lines___;


PROCEDURE Add_Invoice_Type___ (
   invoice_type_list_ IN OUT VARCHAR2,
   invoice_type_      IN     VARCHAR2 ) 
IS
BEGIN
   IF (invoice_type_ IS NOT NULL) THEN
      IF (invoice_type_list_ IS NULL) THEN
         invoice_type_list_ := invoice_type_list_ || invoice_type_;
      ELSE
         invoice_type_list_ := invoice_type_list_ || ''','''|| invoice_type_;
      END IF;
   END IF;
END Add_Invoice_Type___;


-- Check_No_Previous_Execution___
--   This procedure checks whether another method is "Posted" or "Executing"
--   in parallel in background jobs with the same order_no.
PROCEDURE Check_No_Previous_Execution___ (
   order_no_       IN VARCHAR2,
   deferred_call_  IN VARCHAR2 )
IS
   msg_            VARCHAR2(32000);
   current_job_id_ NUMBER := NULL;
   job_id_value_   VARCHAR2(35);
   arg_tab_        Transaction_SYS.Arguments_Table;
   job_order_no_   VARCHAR2(12);
BEGIN
   -- Get current job_id
   current_job_id_ := Transaction_SYS.Get_Current_Job_Id;

   -- Get current 'Posted' job arguments
   arg_tab_:= Transaction_SYS.Get_Posted_Job_Arguments(deferred_call_, NULL);
   
   IF (arg_tab_.COUNT > 0) THEN
      FOR i_ IN arg_tab_.FIRST..arg_tab_.LAST LOOP
         job_order_no_ := Client_SYS.Get_Item_Value('ORDER_NO',arg_tab_(i_).arguments_string);
         
         IF ((NVL(current_job_id_, '-1') != NVL(arg_tab_(i_).job_id, '-1')) AND (job_order_no_ = order_no_)) THEN
            Error_SYS.Record_General(lu_name_, 'SAMEORDEREXIST: The customer order :P1 has already been processed by another user and added to the background job :P2.', order_no_, TO_CHAR(arg_tab_(i_).job_id));
         END IF;
         IF (job_order_no_ != Database_SYS.string_null_) THEN
            job_order_no_ := Database_SYS.string_null_;
         END IF;
      END LOOP;
   END IF;
   
   -- Get current 'Executing' job arguments
   Transaction_SYS.Get_Executing_Job_Arguments(msg_, deferred_call_);
   IF Get_Job_Arguments___(msg_, job_id_value_, order_no_, current_job_id_) IS NOT NULL THEN
      Error_SYS.Record_General(lu_name_, 'SAMEORDEREXIST: The customer order :P1 has already been processed by another user and added to the background job :P2.', order_no_, TO_CHAR(job_id_value_));
   END IF;  
END Check_No_Previous_Execution___;


-- Get_Job_Arguments___
--   This function returns background job ids included in JOB_ARGUMENTS string
--   msg_, which belong to a given customer order.
FUNCTION Get_Job_Arguments___ (
   msg_            IN OUT VARCHAR2,
   job_id_value_   IN OUT VARCHAR2,
   order_no_       IN     VARCHAR2,
   current_job_id_ IN     NUMBER) RETURN NUMBER
IS
   attrib_value_ VARCHAR2(32000);
   value_        VARCHAR2(2000);   
   name_         VARCHAR2(30);
   job_id_tab_   Message_SYS.Name_Table;
   attrib_tab_   Message_SYS.Line_Table;
   job_order_no_ VARCHAR2(12); 
   count_        NUMBER;
   ptr_          NUMBER;
BEGIN
   Message_SYS.Get_Attributes(msg_, count_, job_id_tab_, attrib_tab_);
   FOR i_ IN 1..count_ LOOP
      job_id_value_ := job_id_tab_(i_);
      attrib_value_ := attrib_tab_(i_);

      ptr_ := NULL;
      -- Loop through the parameter list to check whether order_no exists
      WHILE (Client_SYS.Get_Next_From_Attr(attrib_value_, ptr_, name_, value_)) LOOP
         IF (name_ = 'ORDER_NO') THEN
            job_order_no_ := value_;
         END IF;

         -- Check to see if another job of this type exists
         IF ((NVL(current_job_id_, '-1') != NVL(job_id_value_,'-1')) AND (job_order_no_ = order_no_)) THEN
            -- Return previous Execution
            RETURN  job_id_value_;
         END IF;

         IF (job_order_no_ != Database_SYS.string_null_) THEN
            job_order_no_ := Database_SYS.string_null_;
         END IF;
      END LOOP;                          
   END LOOP;
   RETURN NULL;
END Get_Job_Arguments___;


-- Email_Order_Conf_Allowed___
--   Return TRUE (1) if the Email Order Confirmation operation is allowed
--   for a specified order.
FUNCTION Email_Order_Conf_Allowed___ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   email_ VARCHAR2(200) := NULL;
BEGIN
   email_ := Get_Email_Address__(order_no_); 
   IF (email_ IS NOT NULL) THEN
      RETURN 1;
   ELSE
      RETURN 0;  
   END IF;
END Email_Order_Conf_Allowed___;  


-- Email_Pro_Forma_Allowed___
--   Return TRUE (1) if the Email Pro Forma Invoice operation is allowed
--   for a specified order.
FUNCTION Email_Pro_Forma_Allowed___ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   rec_     CUSTOMER_ORDER_API.Public_Rec;
   allowed_ NUMBER := 0;
BEGIN
   rec_ := Customer_Order_API.Get(order_no_);
   IF (rec_.rowstate NOT IN ('Invoiced', 'Cancelled')) THEN     
      IF (Cust_Ord_Customer_Address_API.Get_Email(rec_.customer_no, rec_.cust_ref, rec_.bill_addr_no ) IS NOT NULL) THEN 
         allowed_ := 1;
      END IF;
   END IF;
   RETURN allowed_;
END Email_Pro_Forma_Allowed___;


-- Check_Order_For_Blocking___
--   Check whether the Customer Order has any unpaid advance/prepay invoices else credit check.
PROCEDURE Check_Order_For_Blocking___ (
   block_reason_   OUT VARCHAR2,   
   credit_check_   IN  VARCHAR2,
   checking_state_ IN  VARCHAR2,
   order_no_       IN  VARCHAR2 )
IS
BEGIN
   block_reason_ := NULL;    

   -- Check whether there are unpaid advance/prepayment invoices   
   IF checking_state_ IN ('RELEASE_ORDER', 'PICK_PROPOSAL', 'MANUAL') OR (checking_state_ = 'SKIP_CHECK' AND Customer_Order_API.Get_Objstate(order_no_) = 'Released')  THEN
      Advance_Invoice_Pay_Check(block_reason_, order_no_);
   END IF;   
   
   -- If no unpaid advance/prepayment invoices then check for credit block
   IF block_reason_ IS NULL AND credit_check_ = 'TRUE' THEN
      Credit_Check(block_reason_, order_no_);
   END IF;
   
END Check_Order_For_Blocking___;

-- Check_All_License_Connected___
--  This method will set the display_info_ according to the license connection
--  and user authority level. display_info_ will be used in the client to 
--  display various messages depending on its value. 
PROCEDURE Check_All_License_Connected___ (
   display_info_ IN OUT NUMBER,
   order_no_     IN     VARCHAR2 )
IS
BEGIN
   IF (Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN
         DECLARE
            order_rec_                 Customer_Order_API.Public_Rec;
            stop_after_release_        NUMBER := NULL;
            stop_after_print_ord_conf_ NUMBER := NULL;
            stop_after_reserve_        NUMBER := NULL;
            all_license_connected_     VARCHAR2(10):= 'TRUE';
            raise_message_             VARCHAR2(5) := 'FALSE';
            all_lines_expctr_          VARCHAR2(5) := 'TRUE';
            connected_                 VARCHAR2(5) := 'FALSE';
            CURSOR get_lines IS
               SELECT line_no, rel_no, line_item_no, rowstate, shipment_creation, catalog_type
               FROM   customer_order_line_tab
               WHERE  order_no = order_no_;
         BEGIN
            order_rec_                 := Customer_Order_API.Get(order_no_);
            stop_after_release_        := cust_order_type_event_API.Get_Next_Event(order_rec_.order_id, 20);
            stop_after_print_ord_conf_ := cust_order_type_event_API.Get_Next_Event(order_rec_.order_id, 40);
            stop_after_reserve_        := cust_order_type_event_API.Get_Next_Event(order_rec_.order_id, 60);   
            FOR line_rec_ IN get_lines LOOP
               -- If the order type has stops at release, print order confirmation and reserve order, information messages should not be raised.
               -- Also if the shipment_creation method is at ORDER_RELEASE, messages should be raised from the shipment. Since picking is carried out from shipment.
               IF (line_rec_.rowstate = 'Released' AND stop_after_release_ IS NOT NULL 
                   AND stop_after_reserve_ IS NOT NULL AND stop_after_print_ord_conf_ IS NOT NULL 
                   AND line_rec_.shipment_creation != 'ORDER_RELEASE') 
                   OR (order_rec_.rowstate != 'Planned' AND (line_rec_.rowstate = 'Reserved' OR (line_rec_.rowstate = 'Released' AND line_rec_.catalog_type = 'NON'))) THEN
                  Exp_License_Connect_Util_API.Get_Order_License_Connect_Info(all_license_connected_, raise_message_, order_no_, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
                  IF raise_message_ = 'TRUE' THEN 
                     IF all_license_connected_ = 'TRUE' THEN
                        -- License are not connected but user has override license connection rights.
                        display_info_ := 1;
                     ELSE 
                        -- License are not connected and user does not have override license connection rights.
                        display_info_ := 2;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
            Customer_Order_API.All_Lines_Expctr(all_lines_expctr_, connected_, order_no_); 
            IF all_lines_expctr_ = 'TRUE' AND display_info_ = 2 THEN
               IF connected_ = 'TRUE' THEN
                  -- All lines of the order is export controlled and user does not have override license connection rights.
                  -- But some are license connected. Those should proceed the flow.
                  display_info_ := 2;
               ELSE 
                  -- All lines of the order is export controlled and user does not have override license connection rights.
                  display_info_ := 3;
               END IF;
            END IF;       
         END;
      $ELSE
         NULL;
      $END
   END IF;
END Check_All_License_Connected___;


PROCEDURE Check_Export_Controlled___ (
   proceed_order_      IN OUT VARCHAR2,
   order_no_           IN     VARCHAR2,
   server_data_change_ IN     VARCHAR2 ) 
IS
BEGIN
   IF (Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN
         DECLARE
            licensed_order_type_ VARCHAR2(25);
            CURSOR get_lines IS
               SELECT line_no, rel_no, line_item_no, demand_code, demand_order_ref1, demand_order_ref2, demand_order_ref3
               FROM   customer_order_line_tab
               WHERE  order_no = order_no_;
         BEGIN
            FOR line_rec_ IN get_lines LOOP
               BEGIN
                  licensed_order_type_ := Customer_Order_Line_API.Get_Expctr_License_Order_Type(line_rec_.demand_code, line_rec_.demand_order_ref1, line_rec_.demand_order_ref2, line_rec_.demand_order_ref3);
                  Exp_License_Connect_Util_API.Check_Order_Proceed_Allowed(order_no_, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no, licensed_order_type_);
               EXCEPTION
                  WHEN OTHERS THEN
                     IF server_data_change_ = 'TRUE' THEN
                        proceed_order_ := 'FALSE';
                     ELSE
                        RAISE;
                     END IF;
               END;
            END LOOP;
         END;
      $ELSE
         NULL;
      $END
   END IF;
END Check_Export_Controlled___;


FUNCTION Allow_Non_Inv_Delivery___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;

   CURSOR non_inv_delivery_allowed IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB col
      WHERE col.rowstate     != 'Cancelled'
       AND  col.qty_to_ship  != 0
       AND  col.catalog_type  = 'NON'
       AND (col.line_no = line_no_  OR line_no_ IS NULL)
       AND (col.rel_no = rel_no_  OR rel_no_ IS NULL)
       AND (col.line_item_no = line_item_no_ OR line_item_no_ IS NULL)
       AND shipment_connected = 'FALSE'
       AND EXISTS (SELECT 1
           FROM CUSTOMER_ORDER_TAB co
           WHERE co.order_no = col.order_no
           AND   co.order_no = order_no_
           AND   rowstate NOT IN ('Planned', 'Blocked'));
BEGIN
  OPEN non_inv_delivery_allowed;
  FETCH non_inv_delivery_allowed INTO allowed_;
  IF (non_inv_delivery_allowed%FOUND) THEN
    allowed_ := 1;
  ELSE
    allowed_ := 0;
  END IF;
  CLOSE non_inv_delivery_allowed;
  RETURN allowed_;
END Allow_Non_Inv_Delivery___;

FUNCTION Allow_Service_Ord_Delivery___(
   order_no_     IN VARCHAR2   ) RETURN VARCHAR2
IS 
   allowed_ NUMBER;
   CURSOR seo_order_delivery_allowed  IS 
   SELECT 1
      FROM   customer_order_line_tab col
      WHERE  col.rowstate     != 'Cancelled'
      AND    col.qty_to_ship > 0
      AND    col.supply_code = 'SEO'
      AND EXISTS (SELECT 1
                  FROM customer_order_tab co
                  WHERE co.order_no = col.order_no
                  AND   co.order_no = order_no_
                  AND   rowstate NOT IN ('Planned', 'Blocked'));
   BEGIN
      OPEN seo_order_delivery_allowed;
      FETCH seo_order_delivery_allowed INTO allowed_;
      IF (seo_order_delivery_allowed%FOUND) THEN
        allowed_ := 1;
      ELSE
        allowed_ := 0;
      END IF;
      CLOSE seo_order_delivery_allowed;
      RETURN allowed_;
END Allow_Service_Ord_Delivery___;


-- Print_Invoices___
-- Break the attr_ to different attribute strings per invoice and register background jobs
 PROCEDURE Print_Invoices___ (
   attr_            IN OUT VARCHAR2,
   job_description_ IN     VARCHAR2 )
IS
   ptr_           NUMBER;
   name_          VARCHAR2(30);
   value_         VARCHAR2(2000);
   temp_attr_     VARCHAR2(4000);
   print_attr_    VARCHAR2(4000);
   print_method_  VARCHAR2(16);   
   invoice_id_    NUMBER;
   company_       VARCHAR2(20);
   set_email_addr_ VARCHAR2(5) := 'FALSE';
BEGIN
   -- Collect all the attributes except invoice_id from attr_.
   IF Client_SYS.Item_Exist('START_EVENT', attr_) THEN
      Client_SYS.Add_To_Attr('START_EVENT', Client_SYS.Get_Item_Value('START_EVENT', attr_), temp_attr_);
   END IF;
   IF Client_SYS.Item_Exist('MEDIA_CODE', attr_) THEN
      Client_SYS.Add_To_Attr('MEDIA_CODE', Client_SYS.Get_Item_Value('MEDIA_CODE', attr_), temp_attr_);
   END IF;
   IF Client_SYS.Item_Exist('SEND', attr_) THEN
      Client_SYS.Add_To_Attr('SEND', Client_SYS.Get_Item_Value('SEND', attr_), temp_attr_);
   END IF;
   IF Client_SYS.Item_Exist('SEND_AND_PRINT', attr_) THEN
      Client_SYS.Add_To_Attr('SEND_AND_PRINT', Client_SYS.Get_Item_Value('SEND_AND_PRINT', attr_), temp_attr_);
   END IF;
   IF Client_SYS.Item_Exist('PRINT_TYPE', attr_) THEN
      Client_SYS.Add_To_Attr('PRINT_TYPE', Client_SYS.Get_Item_Value('PRINT_TYPE', attr_), temp_attr_);
   END IF;
   IF Client_SYS.Item_Exist('EMAIL_ADDR', attr_) THEN
      Client_SYS.Add_To_Attr('EMAIL_ADDR', Client_SYS.Get_Item_Value('EMAIL_ADDR', attr_), temp_attr_);
      set_email_addr_ := 'TRUE';
   END IF;
   IF Client_SYS.Item_Exist('CONNECTED_OBJECTS', attr_) THEN
      Client_SYS.Add_To_Attr('CONNECTED_OBJECTS', Client_SYS.Get_Item_Value('CONNECTED_OBJECTS', attr_), temp_attr_);
   END IF;
   IF Client_SYS.Item_Exist('USER_GROUP', attr_) THEN
      Client_SYS.Add_To_Attr('USER_GROUP', Client_SYS.Get_Item_Value('USER_GROUP', attr_), temp_attr_);
   END IF;
   IF Client_SYS.Item_Exist('VALIDATEBG', attr_) THEN
      Client_SYS.Add_To_Attr('VALIDATEBG', Client_SYS.Get_Item_Value('VALIDATEBG', attr_), temp_attr_);
   END IF;

   print_method_ := Client_SYS.Get_Item_Value('PRINT_METHOD', attr_);
   company_ := Client_SYS.Get_Item_Value('COMPANY', attr_);
   IF print_method_ = 'PRINT_ONLINE' THEN
      Client_SYS.Add_To_Attr('PRINT_METHOD', print_method_, temp_attr_);
      print_attr_ := temp_attr_;
      invoice_id_ := Client_SYS.Get_Item_Value('INVOICE_ID', attr_);
      Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, print_attr_);
      Client_SYS.Add_To_Attr('END', '', print_attr_);
      Customer_Order_Inv_Head_API.Print_Invoices(print_attr_);      
      attr_ := print_attr_;      
   ELSE
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'INVOICE_ID') THEN
            print_attr_ := temp_attr_;
            IF (Customer_Order_Inv_Head_API.Validate_Invoice_Text(company_, value_) = 'FALSE') THEN
               Error_SYS.Record_General(lu_name_, 'NOINVOICETEXT: Invoice text is required when printing, sending or emailing credit invoices.');
            END IF;
            IF (Customer_Order_Inv_Head_API.Validate_Corr_Reason(company_, value_) = 'FALSE') THEN
               Error_SYS.Record_General(lu_name_, 'NOCORREASON: Correction Reason is required when printing, sending or emailing credit invoices');
            END IF;
            Client_SYS.Add_To_Attr('INVOICE_ID', value_, print_attr_);
            IF (set_email_addr_ = 'TRUE') THEN
               Client_SYS.Add_To_Attr('PRINT_METHOD', print_method_, print_attr_);
            ELSE 
               Client_SYS.Add_To_Attr('PRINT_METHOD', 'PRINT_BACKGROUND', print_attr_);
            END IF; 
            Client_SYS.Add_To_Attr('END', '', print_attr_);
            -- Create background job per invoice
            Transaction_SYS.Deferred_Call('Customer_Order_Inv_Head_API.Print_Invoices', print_attr_, job_description_);
         END IF;
      END LOOP;
   END IF;
END Print_Invoices___;


-- Build_Attr_Create_Rma_Lines___ 
-- This method is used to build the attr_ which is used in method Create_Rma_Lines___. 
PROCEDURE Build_Attr_Create_Rma_Lines___ (
	line_attr_    OUT   VARCHAR2,
   inv_count_    OUT   NUMBER, 
   rma_attr_     IN    VARCHAR2,
   order_no_     IN    VARCHAR2,
   line_no_      IN    VARCHAR2,
   rel_no_       IN    VARCHAR2,
   line_item_no_ IN    NUMBER )
IS
   attr_                  VARCHAR2(2000);
   catolog_desc_          VARCHAR2(200);
   invoice_no_            VARCHAR2(50);
   series_id_             VARCHAR2(20);
   item_id_               NUMBER;
   poss_qty_to_return_    NUMBER;
   configuration_id_      VARCHAR2(50);
   qty_to_return_inv_uom_ NUMBER;
   customer_po_no_        VARCHAR2(50);
   line_rec_              Customer_Order_Line_API.Public_Rec;
   inv_line_rec_          Customer_Order_Inv_Item_API.Public_Rec;
   invoice_id_            NUMBER;
   company_               VARCHAR2(20);
   currency_rate_         NUMBER;
   catalog_no_            CUSTOMER_ORDER_LINE_TAB.Part_No%TYPE;
   reason_code_           VARCHAR2(10);
   contract_              VARCHAR2(5);
   qty_to_return_         NUMBER;
   org_rma_line_no_       NUMBER;
   rma_no_                NUMBER;  
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Clear_Attr(line_attr_);

   rma_no_                := Client_SYS.Get_Item_Value('RMA_NO', rma_attr_);
   contract_              := Client_SYS.Get_Item_Value('CONTRACT', rma_attr_);
   reason_code_           := Client_SYS.Get_Item_Value('RETURN_REASON_CODE', rma_attr_);

   -- The following values are passed in the multisite receipt RMA creation or RMA creation via rental transfer
   qty_to_return_         := Client_SYS.Get_Item_Value('QTY_TO_RETURN', rma_attr_);
   qty_to_return_inv_uom_ := Client_SYS.Get_Item_Value('QTY_TO_RETURN_INV_UOM', rma_attr_);
   -- The org_rma_line_no_ value is passed in the multisite receipt RMA creation 
   org_rma_line_no_       := Client_SYS.Get_Item_Value('ORIGINATING_RMA_LINE_NO', rma_attr_);

   Invoice_Customer_Order_API.Get_Invoice_For_Rma(inv_count_, invoice_no_, item_id_, series_id_, order_no_, line_no_, rel_no_, line_item_no_);
   IF ((invoice_no_ IS NOT NULL) AND (item_id_ != 0) AND (series_id_ IS NOT NULL)) THEN
      company_      := Site_API.Get_Company(contract_);
      invoice_id_   := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, invoice_no_, series_id_);
      inv_line_rec_ := Customer_Order_Inv_Item_API.Get(company_, invoice_id_, item_id_);
      Client_SYS.Add_To_Attr('DEBIT_INVOICE_NO',invoice_no_ , line_attr_);
      Client_SYS.Add_To_Attr('DEBIT_INVOICE_ITEM_ID',item_id_ , line_attr_);
      Client_SYS.Add_To_Attr('DEBIT_INVOICE_SERIES_ID',series_id_ , line_attr_);
      Client_SYS.Set_Item_Value('DELIVERY_TYPE', inv_line_rec_.deliv_type_id, attr_);
      Return_Material_Line_API.Get_Ivc_Line_Data(attr_, order_no_, line_no_, rel_no_, line_item_no_, invoice_no_, NULL, series_id_, company_, NULL, NULL);
   ELSE
      Return_Material_Line_API.Get_Co_Line_Data(attr_, order_no_, line_no_, rel_no_, line_item_no_, NULL, NULL);
   END IF;
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   
   IF (org_rma_line_no_ IS NOT NULL OR qty_to_return_ > 0) THEN
      -- When creating the receipt rma, the qty_to_return should be used for multisite receipt RMA creation or RMA creation via rental transfer
      poss_qty_to_return_    := qty_to_return_;
      Client_SYS.Add_To_Attr('QTY_EDITED_FLAG', 'EDITED', line_attr_);
   ELSE
      poss_qty_to_return_    := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('POSS_QTY_TO_RETURN', attr_));
      qty_to_return_inv_uom_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('QTY_TO_RETURN_INV_UOM', attr_));
   END IF;

   configuration_id_ := Client_SYS.Get_Item_Value('CONFIGURATION_ID', attr_);
   catalog_no_       := Client_SYS.Get_Item_Value('CATALOG_NO', attr_);
   catolog_desc_     := Client_SYS.Get_Item_Value('CATALOG_DESC', attr_);
   currency_rate_    := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('CURRENCY_RATE', attr_));
   Client_SYS.Add_To_Attr('CURRENCY_RATE', currency_rate_ , line_attr_);        
   
   IF poss_qty_to_return_ > 0 THEN
      IF (Client_SYS.Item_Exist('PURCHASE_ORDER_NO', rma_attr_)) THEN
         customer_po_no_ := Client_SYS.Get_Item_Value('PURCHASE_ORDER_NO', rma_attr_);
      ELSE
         customer_po_no_ := NVL(Client_SYS.Get_Item_Value('INTERNAL_PO_NO', attr_), Client_SYS.Get_Item_Value('CUSTOMER_PO_NO', attr_));
      END IF;
      
      Client_SYS.Add_To_Attr('RMA_NO',rma_no_ , line_attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, line_attr_);
      Client_SYS.Add_To_Attr('CATALOG_NO',catalog_no_ , line_attr_);
      Client_SYS.Add_To_Attr('CATALOG_DESC', catolog_desc_, line_attr_);
      Client_SYS.Add_To_Attr('ORDER_NO',order_no_ , line_attr_);
      Client_SYS.Add_To_Attr('LINE_NO',line_no_ , line_attr_);
      Client_SYS.Add_To_Attr('REL_NO',rel_no_ , line_attr_);
      Client_SYS.Add_To_Attr('LINE_ITEM_NO',line_item_no_ , line_attr_);
      Client_SYS.Add_To_Attr('RETURN_REASON_CODE',reason_code_ , line_attr_);
      Client_SYS.Add_To_Attr('QTY_TO_RETURN',poss_qty_to_return_ , line_attr_);
      Client_SYS.Add_To_Attr('PURCHASE_ORDER_NO', customer_po_no_, line_attr_);
      Client_SYS.Add_To_Attr('TAX_LIABILITY', line_rec_.tax_liability, line_attr_);
      Client_SYS.Add_To_Attr('CONFIGURATION_ID', configuration_id_, line_attr_);
      Client_SYS.Add_To_Attr('QTY_TO_RETURN_INV_UOM', qty_to_return_inv_uom_, line_attr_);
      Client_SYS.Add_To_Attr('DELIVERY_TYPE', line_rec_.delivery_type, line_attr_);
      Client_SYS.Add_To_Attr('CONV_FACTOR', line_rec_.conv_factor, line_attr_);
      Client_SYS.Add_To_Attr('INVERTED_CONV_FACTOR', line_rec_.inverted_conv_factor, line_attr_);
      Client_SYS.Add_To_Attr('ORIGINATING_RMA_LINE_NO', org_rma_line_no_, line_attr_);
      Client_SYS.Add_To_Attr('PRICE_CONV_FACTOR', Client_SYS.Get_Item_Value('PRICE_CONV_FACTOR', rma_attr_), line_attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', line_rec_.customer_tax_usage_type, line_attr_); 
   END IF;
   
END Build_Attr_Create_Rma_Lines___;

-- Handle_Rma_Allowed___ 
--   Return TRUE (1) if the Handle Return Material Authorization operation is allowed
--   for a specified order.
FUNCTION Handle_Rma_Allowed___ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER := 0;
BEGIN
   IF ((Create_Rma_Allowed___(order_no_) = 1)  OR (Edit_Rma_Allowed___(order_no_) = 1) )THEN
      allowed_ := 1;   
   END IF;    
	RETURN allowed_;
END Handle_Rma_Allowed___;

 
-- Create_Rma_Allowed___ 
--   Return TRUE (1) if the Create Return Material Authorization operation is allowed
--   for a specified order.
FUNCTION Create_Rma_Allowed___ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER := 0;
BEGIN
   IF (Customer_Order_Flow_API.Check_Co_To_Return(order_no_) != 0)THEN
      allowed_ := 1;   
   END IF;    
	RETURN allowed_;
END Create_Rma_Allowed___;


-- Edit_Rma_Allowed___ 
--   Return TRUE (1) if the View/Edit Return Material Authorization operation is allowed
--   for a specified order.
FUNCTION Edit_Rma_Allowed___ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER := 0;
BEGIN
   IF (Return_Material_API.Check_Exist_Rma_For_Order(order_no_) = 'TRUE')THEN
      allowed_ := 1;   
   END IF;    
	RETURN allowed_;
END Edit_Rma_Allowed___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Process_From_Release_Order__
--   Process one order starting with the Release step in the order flow.
--   This method exists only to make it possible to connect different
--   steps in the order flow to different batch queues.
PROCEDURE Process_From_Release_Order__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_Order__(attr_);
END Process_From_Release_Order__;


-- Process_From_Print_Ord_Conf__
--   Process one order starting with the Print Order Confirmation step
--   in the order flow.
--   This method exists only to make it possible to connect different
--   steps in the order flow to different batch queues.
PROCEDURE Process_From_Print_Ord_Conf__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_Order__(attr_);
END Process_From_Print_Ord_Conf__;


-- Process_From_Reserve__
--   Process one order starting with the Reserve step in the order flow.
--   This method exists only to make it possible to connect different
--   steps in the order flow to different batch queues.
PROCEDURE Process_From_Reserve__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_Order__(attr_);
END Process_From_Reserve__;


-- Process_From_Create_Pick_Lst__
--   Process one order starting with the Create Pick  List step in the order flow. This method exists only to make it possible to connect different steps in the order flow to different batch queues.
PROCEDURE Process_From_Create_Pick_Lst__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_Order__(attr_);
END Process_From_Create_Pick_Lst__;


-- Process_From_Print_Pick_List__
--   Process one order starting with the Print Pick List step in the order flow. This method exists only to make it possible to connect different steps in the order flow to different batch queues.
PROCEDURE Process_From_Print_Pick_List__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_Order__(attr_);
END Process_From_Print_Pick_List__;


-- Process_From_Report_Picking__
--   Process one order starting with the Report Picking step in the order flow. This method exists only to make it possible to connect different steps in the order flow to different batch queues.
PROCEDURE Process_From_Report_Picking__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_Order__(attr_);
END Process_From_Report_Picking__;


-- Process_From_Deliver__
--   Process one order starting with the Deliver step in the order flow. This method exists only to make it possible to connect different steps in the order flow to different batch queues.
PROCEDURE Process_From_Deliver__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_Order__(attr_);
END Process_From_Deliver__;


-- Process_From_Create_Del_Note__
--   Process one order starting with the Create Delivery Note step in the order flow. This method exists only to make it possible to connect different steps in the order flow to different batch queues.
PROCEDURE Process_From_Create_Del_Note__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_Order__(attr_);
END Process_From_Create_Del_Note__;


-- Process_From_Print_Del_Note__
--   Process one order starting with the Print Delivery Note step in the order flow. This method exists only to make it possible to connect different steps in the order flow to different batch queues.
PROCEDURE Process_From_Print_Del_Note__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_Order__(attr_);
END Process_From_Print_Del_Note__;


-- Process_From_Create_Invoice__
--   Process one order starting with Release, Release Quoted etc step.
--   These method exists only to make it possible to connect different
--   steps in the order flow to different batch queues.
--   Process one order starting with the Create Invoice step in the order flow. This method exists only to make it possible to connect different steps in the order flow to different batch queues.
PROCEDURE Process_From_Create_Invoice__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_Order__(attr_);
END Process_From_Create_Invoice__;


-- Process_Order__
--   Process one order.
--   The attribute string passed as a parameter should contain the parameters needed for the processing.
PROCEDURE Process_Order__ (
   attr_ IN OUT VARCHAR2 )
IS
   order_rec_                   Customer_Order_API.Public_Rec;
   order_type_rec_              Cust_Order_Type_API.Public_Rec;
   start_event_                 NUMBER;
   next_event_                  NUMBER;
   ptr_                         NUMBER;
   name_                        VARCHAR2(30);
   value_                       VARCHAR2(2000);
   order_no_                    VARCHAR2(12);
   pick_list_no_                VARCHAR2(15);
   location_no_                 VARCHAR2(35);
   delnote_no_                  VARCHAR2(15);
   invoice_id_                  NUMBER;
   error_message_               VARCHAR2(2000);
   info_                        VARCHAR2(2000);
   exit_loop_                   BOOLEAN := FALSE;
   media_code_                  VARCHAR2(30) := NULL;
   pick_list_no_list_           Create_Pick_List_API.Pick_List_Table;
   print_only_                  BOOLEAN := FALSE;
   is_manual_                   BOOLEAN := FALSE;
   internal_transit_deliv_      NUMBER := 0;
   shipment_id_tab_             Shipment_API.Shipment_Id_Tab;
   cust_email_addr_             VARCHAR2(200);
   identity_                    VARCHAR2(20);
   your_reference_              VARCHAR2(30);
   inv_addr_id_                 VARCHAR2(50);
   invoice_type_                VARCHAR2(20);
   company_                     VARCHAR2(20);
   sales_promotion_calculated_  BOOLEAN := FALSE;
   customer_rec_                Cust_Ord_Customer_API.Public_Rec;
   email_invoice_               VARCHAR2(5) := NULL;
   create_rental_trans_         VARCHAR2(5) := 'FALSE';
   shipment_flow_not_triggered_ BOOLEAN := FALSE;    
   auth_group_                  VARCHAR2(2);
   current_po_no_               NUMBER;
   dummy_                       NUMBER;
   proceed_order_               VARCHAR2(5) := 'TRUE';
   server_data_change_          VARCHAR2(5) := 'FALSE';
   staged_lines_exist_          NUMBER;
   adv_pre_paym_inv_available_  VARCHAR2(5);
   invoice_sort_                VARCHAR2(20);
   process_online_              BOOLEAN := FALSE;
   rental_transfer_db_          VARCHAR2(5) := 'FALSE';
   discount_calculated_         BOOLEAN := FALSE;
   ivc_unconctd_chg_seperately_ NUMBER;
   comp_uncon_chg_sep_          NUMBER;
   created_from_quick_co_reg_ VARCHAR2(5) := 'FALSE';
   
   CURSOR check_col_supply_code IS
      SELECT 1
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    supply_code IN ('IPD', 'IPT')
      AND    line_item_no >= 0;

   CURSOR get_delnotes(order_no_ IN VARCHAR2) IS
      SELECT delnote_no
      FROM   Customer_Order_Deliv_Note_Main
      WHERE  objstate = 'Created'
      AND    order_no = order_no_;

   CURSOR get_inv_details(invoice_id_ IN VARCHAR2, company_ IN VARCHAR2) IS
      SELECT identity, your_reference, invoice_address_id, invoice_type
      FROM   customer_order_inv_head
      WHERE  invoice_id = invoice_id_
      AND    company    = company_;  
   
   CURSOR get_col_data(order_no_ IN VARCHAR2) IS
      SELECT supply_code, ref_id, line_no, rel_no, line_item_no
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_;
BEGIN   
   Trace_SYS.Field('attr_', attr_);

   -- Retrieve parameters from the attribute string
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'START_EVENT') THEN
         start_event_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'ORDER_NO') THEN
         order_no_ := value_;
      ELSIF (name_ = 'PICK_LIST_NO') THEN
         pick_list_no_ := value_;
      ELSIF (name_ = 'LOCATION_NO') THEN
         location_no_ := value_;
      ELSIF (name_ = 'DELNOTE_NO') THEN
         delnote_no_ := value_;
      ELSIF (name_ = 'MEDIA_CODE') THEN  -- this item is only sent from the client Send dialog
         media_code_ := value_;
      -- Note: this value is being used to identify print only delivery notes
      ELSIF (name_ = 'PRINT') THEN
         is_manual_  := TRUE ;
         IF (value_ IS NOT NULL ) THEN
            print_only_ := TRUE;
         END IF;
      ELSIF (name_ = 'SALES_PROMOTION_CALCULATED') THEN
         sales_promotion_calculated_ := TRUE;
      ELSIF (name_ = 'CREATE_RENTAL_TRANS') THEN
         create_rental_trans_ := value_;
      ELSIF (name_ = 'ONLINE_ORDRSP_PROCESSING') THEN
         process_online_ := TRUE;
      ELSIF (name_ = 'RENTAL_TRANSFER_DB') THEN
         rental_transfer_db_ := value_;  
      ELSIF (name_ = 'DISCOUNT_CALCULATED') THEN
         discount_calculated_ := TRUE;
      ELSIF(name_ = 'IVC_UNCON_CHG_SEP') THEN
         ivc_unconctd_chg_seperately_ := value_;
      ELSIF (name_ =  'CREATED_FROM_QUICK_CO_REG') THEN
         created_from_quick_co_reg_ := value_;     
      END IF;
   END LOOP;

   order_rec_       := Customer_Order_API.Get(order_no_);
   cust_email_addr_ := Cust_Ord_Customer_Address_API.Get_Email(order_rec_.customer_no, order_rec_.cust_ref, order_rec_.bill_addr_no);
   company_         := Site_API.Get_Company(order_rec_.contract);
   customer_rec_    := Cust_Ord_Customer_API.Get(order_rec_.customer_no); 
   IF(ivc_unconctd_chg_seperately_ = -1)THEN
      comp_uncon_chg_sep_ := ivc_unconctd_chg_seperately_;
   ELSE
      comp_uncon_chg_sep_ := 1;
   END IF;
   
   IF NOT process_online_ THEN
      @ApproveTransactionStatement(2012-01-24,GanNLK)
      SAVEPOINT event_processed;
      Trace_SYS.Field('attr_', attr_);
   END IF;
   
   next_event_ := start_event_;
   WHILE (next_event_ IS NOT NULL AND NOT exit_loop_) LOOP
      -- Lock the current order for processing
      -- The order needs to be relocked before each step because each step ends with a COMMIT
      Lock_Order___(order_no_);

      Trace_SYS.Field('next_event_', next_event_);
      IF (next_event_ = 20) THEN
         -- Release order
         -- Check if the order may be released
         IF (Release_Allowed__(order_no_) = 1) THEN
            server_data_change_ := Client_SYS.Get_Item_Value('SERVER_DATA_CHANGE', attr_);
            -- Export control check.
            Check_Export_Controlled___(proceed_order_, order_no_, server_data_change_);
            IF proceed_order_ = 'TRUE' THEN
               -- Note: Need to get the current po number from order_coordinator_group_tab only when internal purchase orders can be created.
               OPEN check_col_supply_code;
               FETCH check_col_supply_code INTO dummy_;
               CLOSE check_col_supply_code;
               IF (dummy_ = 1) THEN
                  auth_group_    := Order_Coordinator_API.Get_Authorize_Group(order_rec_.authorize_code);
                  current_po_no_ := Order_Coordinator_Group_API.Get_Purch_Order_No(auth_group_);
               END IF; 
               -- Release order
               Release___(order_no_, sales_promotion_calculated_, discount_calculated_);
            END IF;
         END IF;
         IF (Customer_Order_API.Get_Objstate(order_no_) = 'Blocked') THEN
            exit_loop_ := TRUE;
         END IF;
      ELSIF (next_event_ = 40) THEN
         -- Print order confirmation
         IF ((start_event_ = 40) AND
             (order_rec_.order_conf = 'Y')) THEN
            -- The order confirmation has been previously printed or sent.
            -- This printout should not lead to any subsequent processing in the event loop.
            exit_loop_ := TRUE;
            IF (created_from_quick_co_reg_ = 'FALSE') THEN 
               IF (media_code_ IS NOT NULL) THEN
                  Customer_Order_Transfer_API.Send_Order_Confirmation(order_no_, media_code_);
               ELSIF (cust_email_addr_ IS NOT NULL AND (NOT print_only_) AND customer_rec_.email_order_conf = 'TRUE') THEN
                  Email_Order_Report__(order_no_, order_rec_.cust_ref, order_rec_.contract,
                                    cust_email_addr_, order_rec_.customer_no, 'CUSTOMER_ORDER_CONF_REP');
               ELSE
                  Print_Order_Confirmation___(order_no_);
               END IF;
            END IF;
         ELSE
            -- Check if the order confirmation should be printed
            IF (Print_Order_Conf_Allowed__(order_no_) = 1) THEN
               IF (start_event_ != 40) THEN
                  -- Check if it's allowed to send confirmation via media for this order
                  IF (Customer_Order_Transfer_API.Allowed_To_Send(order_no_, 'ORDRSP') = 1) THEN
                     media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(order_rec_.customer_no, 'ORDRSP');
                  ELSE
                     media_code_ := NULL;
                  END IF;
               ELSE
                 IF Customer_Order_API.Get_Objstate (order_no_) = 'Planned' THEN
                    exit_loop_ := TRUE;
                 END IF;
              END IF;
              IF (created_from_quick_co_reg_ = 'FALSE') THEN 
                  IF (media_code_ IS NOT NULL) THEN
                     Customer_Order_Transfer_API.Send_Order_Confirmation(order_no_, media_code_);
                  ELSIF (cust_email_addr_ IS NOT NULL AND (NOT print_only_) AND customer_rec_.email_order_conf = 'TRUE') THEN
                     Email_Order_Report__(order_no_, order_rec_.cust_ref, order_rec_.contract,
                                       cust_email_addr_, order_rec_.customer_no, 'CUSTOMER_ORDER_CONF_REP');
                  ELSE
                     Print_Order_Confirmation___(order_no_);
                  END IF;
               END IF;
            ELSE 
               IF ((cust_email_addr_ IS NOT NULL AND (NOT print_only_) AND customer_rec_.email_order_conf = 'TRUE')
                  AND (created_from_quick_co_reg_ = 'FALSE') )THEN
                  Email_Order_Report__(order_no_, order_rec_.cust_ref, order_rec_.contract,
                                       cust_email_addr_, order_rec_.customer_no, 'CUSTOMER_ORDER_CONF_REP');
               END IF;
            END IF;
         END IF;
      ELSIF (next_event_ = 60) THEN
         -- Export control check.
         Check_Export_Controlled___(proceed_order_, order_no_, server_data_change_);
         IF proceed_order_ = 'TRUE' THEN
            -- Create reservations
            IF ((NOT Reserve_Customer_Order_API.Entire_Order_Reserved__(order_no_, 'FALSE')) AND rental_transfer_db_ = 'FALSE') THEN
               Reserve___(order_no_);
            ELSE
               IF order_rec_.shipment_creation = 'ORDER_RELEASE' THEN
                  shipment_flow_not_triggered_ := TRUE;
               END IF;
            END IF;

            -- Note: If priority reservations are used or no partial deliveries are allowed the entire order should be reserved
            -- Note: before proceeding with the next step.
            order_type_rec_ := Cust_Order_Type_API.Get(order_rec_.order_id);
            IF (order_rec_.backorder_option = 'NO PARTIAL DELIVERIES ALLOWED' OR order_type_rec_.oe_alloc_assign_flag = 'Y') THEN
               IF (NOT Reserve_Customer_Order_API.Entire_Order_Reserved__(order_no_, 'FALSE')) THEN
                  IF (order_rec_.backorder_option = 'NO PARTIAL DELIVERIES ALLOWED')  THEN
                     -- No Partial Deliveries allowed
                     info_ := Language_SYS.Translate_Constant(lu_name_, 'RESERVMISSING1: Reservations have not been made for the order :P1. Check the Customer Order Shortages for more info.', NULL, order_no_);
                  ELSE
                     -- Priority reservations
                     info_ := Language_SYS.Translate_Constant(lu_name_, 'RESERVMISSING2: All reservations have not been made for the order :P1 as specified by the order type', NULL, order_no_);
                  END IF;
                  -- No error is raised in this case because we do not want the rollback to remove
                  -- shortage records which might have been created.
                  -- Only set the warning status on the background job.
                  Transaction_SYS.Set_Status_Info(info_);
                  Cust_Order_Event_Creation_API.Order_Processing_Error(order_no_, info_);
                  -- No further processing should be done
                  exit_loop_ := TRUE;
               END IF;
            END IF;
            
            -- Trigger shipment process for order line connected shipments.(If the order type use priority reservations)
            IF shipment_flow_not_triggered_ THEN
               Shipment_Order_Utility_API.Start_Shipment_Flow(order_no_, 10, rental_transfer_db_); 
            END IF;
            
         END IF;
      ELSIF (next_event_ = 70) THEN
         -- Create new pick lists for an order
         IF (Create_Pick_List_Allowed__(order_no_) = 1) THEN
            IF (Order_Config_Util_API.Check_Cust_Ord_Config_Mismatch(order_no_) = 'TRUE') THEN                
               Error_SYS.Record_General(lu_name_, 'CONFIGMISMATCH: Pick list creation is not allowed since supply site configuration is different from demand site configuration.');
            END IF;
            IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') THEN
               -- In this the Objstate of CO can becomes 'Blocked' 
               Credit_Check_Order(order_no_,'CREATE_PICK_LIST');
            END IF;

            IF (Customer_Order_API.Get_Objstate(order_no_) != 'Blocked') THEN
            -- If any CO lines exist with shipment creation method containing 'PICK_LIST_CREATION' first create/connect the lines to the shipments before creating the picklists.
               IF (order_rec_.backorder_option = 'NO PARTIAL DELIVERIES ALLOWED') THEN
                  IF (Reserve_Customer_Order_API.Entire_Order_Reserved__(order_no_, 'TRUE')) THEN
                     Shipment_Order_Utility_API.Create_Automatic_Shipments(shipment_id_tab_      => shipment_id_tab_,
                                                                              order_no_             => order_no_,
                                                                              on_picklist_creation_ => TRUE);
                  END IF;
               ELSE
                  Shipment_Order_Utility_API.Create_Automatic_Shipments(shipment_id_tab_      => shipment_id_tab_,
                                                                           order_no_             => order_no_,
                                                                           on_picklist_creation_ => TRUE );
               END IF;            

               -- Call Create_Shipment_Pick_Lists__ to handle creation of consolidated picklists for CO lines that were connected to shipments.
               IF (shipment_id_tab_.COUNT > 0) THEN
                  FOR i_ IN shipment_id_tab_.FIRST..shipment_id_tab_.LAST LOOP
                     Create_Pick_List_API.Create_Shipment_Pick_Lists__ ( pick_list_no_list_, shipment_id_tab_(i_), NULL, FALSE, rental_transfer_db_);
                  END LOOP; 
               END IF;
            END IF;

            Create_Pick_List_API.Create_Pick_List__(pick_list_no_list_, order_no_);
         END IF;
      ELSIF (next_event_ = 80) THEN
         -- Print pick list
         IF (start_event_ = 80) THEN
            IF (Customer_Order_Pick_List_API.Get_Printed_Flag(pick_list_no_) = Pick_List_Printed_API.Decode('Y')) THEN
               -- The pick list has been previously printed.
               -- This printout should not lead to any subsequent processing in the event loop.
               exit_loop_ := TRUE;
            END IF;
            -- Print the specified pick list
            Print_Pick_List(pick_list_no_);
         ELSE
            IF (Print_Pick_List_Allowed__(order_no_) = 1) THEN
               IF (pick_list_no_list_.COUNT > 0) THEN
                  -- Print each pick list
                  FOR i_ IN pick_list_no_list_.FIRST..pick_list_no_list_.LAST LOOP
                     Print_Pick_List(pick_list_no_list_(i_));
                  END LOOP;
               END IF;
            END IF;
         END IF;
      ELSIF (next_event_ = 85) THEN
         -- Report picking
         -- To report the entire order, send order_no_ = order_no, pick_list_ = NULL,
         -- To report only one picklist, send order_no_ = order_no, pick_list_ = pick_list_no
         -- location_no is NULL if ordinary inventory location is used otherwise it's set
         -- to the shipment inventorys location_no.
         IF (Report_Picking_Allowed__(order_no_) = 1) THEN
            IF (pick_list_no_list_.COUNT > 0) THEN
               -- Report each pick list
               FOR i_ IN pick_list_no_list_.FIRST..pick_list_no_list_.LAST LOOP
                  Report_Picking___(order_no_, pick_list_no_list_(i_), location_no_);
               END LOOP;
            ELSE
               Report_Picking___(order_no_, pick_list_no_, location_no_);
            END IF;
         END IF;
      ELSIF (next_event_ = 90) THEN
         -- Deliver
         IF (Deliver_Allowed__(order_no_) = 1) THEN
            Deliver___(order_no_);
         END IF;
      ELSIF (next_event_ = 100) THEN
         -- Create delivery note
         IF (Create_Deliv_Note_Allowed__(order_no_) = 1) THEN
            Create_Delivery_Notes___(order_no_);
         END IF;
      ELSIF (next_event_ = 110) THEN
         IF delnote_no_ IS NOT NULL THEN
            internal_transit_deliv_ := Deliver_Customer_Order_API.Is_Internal_Transit_Delivery(order_no_,delnote_no_);
         END IF;
         -- Print delivery note
         IF ((start_event_ = 110) AND
             (Delivery_Note_API.Get_Objstate(delnote_no_) = 'Printed')) THEN
            exit_loop_ := TRUE;
            IF (print_only_) THEN
               Print_Delivery_Note___(delnote_no_);                      
            ELSIF (Customer_Order_Transfer_API.Allowed_To_Send(order_no_, 'DIRDEL') = 1) THEN
               media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(order_rec_.customer_no, 'DIRDEL');
               Customer_Order_Transfer_API.Send_Direct_Delivery(delnote_no_ => delnote_no_,
                                                                order_no_   => order_no_,
                                                                media_code_ => media_code_,
                                                                session_id_ => NULL);
            END IF;
         ELSIF (Print_Deliv_Note_Allowed__(order_no_) = 1) THEN
            IF (start_event_ != 110) THEN
               FOR delrec_ IN get_delnotes(order_no_) LOOP
                  Print_Delivery_Note___(delrec_.delnote_no);
                  internal_transit_deliv_ := Deliver_Customer_Order_API.Is_Internal_Transit_Delivery(order_no_,delrec_.delnote_no);
                  IF ( internal_transit_deliv_ != 1 ) THEN
                     IF (Customer_Order_Transfer_API.Allowed_To_Send(order_no_, 'DIRDEL') = 1) THEN
                        media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(order_rec_.customer_no, 'DIRDEL');
                        Customer_Order_Transfer_API.Send_Direct_Delivery(delnote_no_ => delrec_.delnote_no, 
                                                                         order_no_   => order_no_,
                                                                         media_code_ => media_code_,
                                                                         session_id_ => NULL );
                     END IF;
                  END IF;
               END LOOP;
            ELSIF ( internal_transit_deliv_ = 1 ) THEN
               IF ( is_manual_ ) THEN
                  IF (print_only_) THEN
                     Print_Delivery_Note___(delnote_no_);
                  ELSIF (media_code_ IS NOT NULL) THEN
                     Print_Delivery_Note___(delnote_no_);
                  ELSIF (Customer_Order_Transfer_API.Allowed_To_Send(order_no_, 'DIRDEL') = 1) THEN
                     media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(order_rec_.customer_no, 'DIRDEL');
                     Customer_Order_Transfer_API.Send_Direct_Delivery(delnote_no_ => delnote_no_, 
                                                                      order_no_   => order_no_, 
                                                                      media_code_ => media_code_,
                                                                      session_id_ => NULL );
                  END IF;
               ELSE
                  Print_Delivery_Note___(delnote_no_);
               END IF;
            ELSE
               Print_Delivery_Note___(delnote_no_);
               -- Always send MHS if DIRDEL (media_code_ is not null)
               IF (Customer_Order_Transfer_API.Allowed_To_Send(order_no_, 'DIRDEL') = 1) THEN
                  media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(order_rec_.customer_no, 'DIRDEL');
                  Customer_Order_Transfer_API.Send_Direct_Delivery(delnote_no_ => delnote_no_, 
                                                                   order_no_   => order_no_, 
                                                                   media_code_ => media_code_,
                                                                   session_id_ => NULL); 
               END IF;
            END IF;
         ELSE
            IF (Customer_Order_Transfer_API.Allowed_To_Send(order_no_, 'DIRDEL') = 1) THEN
               media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(order_rec_.customer_no, 'DIRDEL');
               IF (delnote_no_ IS NOT NULL) AND (internal_transit_deliv_ != 1) THEN
                  Customer_Order_Transfer_API.Send_Direct_Delivery(delnote_no_ => delnote_no_,
                                                                   order_no_   => order_no_, 
                                                                   media_code_ => media_code_,
                                                                   session_id_ => NULL);
               ELSE
                  FOR delrec_ IN get_delnotes(order_no_) LOOP
                     internal_transit_deliv_ := Deliver_Customer_Order_API.Is_Internal_Transit_Delivery(order_no_, delrec_.delnote_no);
                     IF (internal_transit_deliv_ != 1) THEN
                        Customer_Order_Transfer_API.Send_Direct_Delivery(delnote_no_ => delrec_.delnote_no,
                                                                        order_no_    => order_no_, 
                                                                        media_code_  => media_code_, 
                                                                        session_id_  => NULL);
                     END IF;
                  END LOOP;
               END IF;
            END IF;
         END IF;
      ELSIF (next_event_ = 500) THEN
         -- Create invoice
         invoice_sort_               := Cust_Ord_Customer_API.Get_Invoice_Sort_Db(NVL(order_rec_.customer_no_pay, order_rec_.customer_no));
         adv_pre_paym_inv_available_ := Customer_Invoice_Pub_Util_API.Has_Adv_Or_Prepaym_Inv(order_no_);
         IF (invoice_sort_ = 'C') AND (adv_pre_paym_inv_available_ = 'FALSE') THEN
            staged_lines_exist_ := Staged_Lines_To_Invoice___(order_no_); 
            IF(staged_lines_exist_ = 1)THEN
               Error_SYS.Record_General(lu_name_, 'NOTCOLLECTIVEINVOICE: A customer invoice cannot be created by the stage billing profile as the invoicing customer is of Collective Invoicing type.');  
            END IF;  
         END IF;
         
         IF (create_rental_trans_ = 'TRUE' )THEN
               $IF Component_Rental_SYS.INSTALLED $THEN   
                  Rental_Transaction_Manager_API.Generate_Transactions(order_no_,
                                                                       Rental_Type_API.DB_CUSTOMER_ORDER);   
               $ELSE
                  NULL;
               $END    
            END IF;
         -- 142441, Passed the parameter comp_uncon_chg_sep_ to Create_Invoice_Allowed__().
         -- 140700, Passed the parameter as 1 to Create_Invoice_Allowed__().
         -- Create_Invoice_Allowed__ is checked excluding due rental transactions after the transactions were generated.   
         IF (Create_Invoice_Allowed__(order_no_, FALSE, comp_uncon_chg_sep_) = 1) THEN
            Customer_Order_API.Calculate_Order_Discount__(order_no_ => order_no_);
            Create_Invoice___(invoice_id_, order_no_);
            $IF (Component_Pcmsci_SYS.INSTALLED) $THEN
               FOR colrec_ IN get_col_data(order_no_) LOOP
                  IF (colrec_.supply_code = 'SEO') THEN
                     Psc_Contr_Product_Invline_API.Set_Invoice_Id_From_Order(colrec_.ref_id, order_no_, colrec_.line_no, colrec_.rel_no, colrec_.line_item_no, invoice_id_);                          
                  END IF;
               END LOOP;
            $END
         END IF;
      ELSIF (next_event_ = 510) THEN
         -- Print or send invoice
         IF ((invoice_id_ IS NOT NULL) AND (Print_Invoice_Allowed__(order_no_) = 1)) THEN
            IF (start_event_ != 510) THEN
               -- Invoice header's "identity" is used as customer => nvl(paying customer, customer) from the order
               media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(NVL(order_rec_.customer_no_pay, order_rec_.customer_no), 'INVOIC', company_);
            END IF;
            Trace_SYS.Field('MEDIA_CODE', media_code_);
            Check_Manual_Tax_Lia_Date___(invoice_id_, order_no_);
            IF (order_rec_.customer_no_pay IS NOT NULL) THEN
               OPEN get_inv_details(invoice_id_, company_);
               FETCH get_inv_details INTO identity_, your_reference_, inv_addr_id_, invoice_type_; 
               CLOSE get_inv_details;

               IF (invoice_type_ = 'CUSTORDDEB') THEN  
                  cust_email_addr_ :=  Cust_Ord_Customer_Address_API.Get_Email(identity_, your_reference_, inv_addr_id_); 
                  email_invoice_   :=  Cust_Ord_Customer_API.Get_Email_Invoice_Db(identity_);
               END IF;
            END IF; 
            IF (Customer_Order_Inv_Head_API.Validate_Invoice_Text(company_, invoice_id_) = 'FALSE') THEN
               Error_SYS.Record_General(lu_name_, 'NOINVOICETEXT: Invoice text is required when printing, sending or emailing credit invoices.');
            END IF;
            Print_Invoice___(invoice_id_, media_code_, cust_email_addr_, NVL(email_invoice_, customer_rec_.email_invoice));
         END IF;
      END IF;

      IF NOT process_online_ THEN
         -- Commit changes made so far to avoid long transactions for fast order types
         @ApproveTransactionStatement(2012-01-24,GanNLK)
         COMMIT;
      END IF;

      IF NOT process_online_ THEN
         -- Set before processing next event
         @ApproveTransactionStatement(2012-01-24,GanNLK)
         SAVEPOINT event_processed;
      END IF;

      next_event_ := Cust_Order_Type_Event_API.Get_Next_Event(order_rec_.order_id, next_event_, rental_transfer_db_);
   END LOOP;
EXCEPTION
   WHEN others THEN
      IF process_online_ THEN
         -- Raise the error
         RAISE;
      ELSE
         error_message_ := sqlerrm;
         -- Rollback to the last savepoint
         @ApproveTransactionStatement(2012-01-24,GanNLK)
         ROLLBACK to event_processed;
         IF (current_po_no_ IS NOT NULL) THEN
            Order_Coordinator_Group_API.Reset_Purch_Ord_No_Autonomous(auth_group_, current_po_no_);
         END IF;
         IF (Transaction_SYS.Is_Session_Deferred) THEN
            -- Logg the error
            info_ := Language_SYS.Translate_Constant(lu_name_, 'ORDERERR: Order: :P1   :P2',
                                                     NULL, order_no_, error_message_);
            Transaction_SYS.Set_Status_Info(info_);
            Cust_Order_Event_Creation_API.Order_Processing_Error(order_no_, error_message_);
         ELSE
            -- Raise the error
            RAISE;
         END IF;
      END IF;
END Process_Order__;

   
-- Reserve_Order_Lines__
--   Pick plan lines for one order.
PROCEDURE Reserve_Order_Lines__ (
   attr_ IN OUT VARCHAR2 )
IS
   order_no_         VARCHAR2(12);
   line_no_          VARCHAR2(4);
   rel_no_           VARCHAR2(4);
   line_item_no_     NUMBER;
   name_             VARCHAR2(30);
   value_            VARCHAR2(2000);
   ptr_              NUMBER;
   curr_order_no_    VARCHAR2(12);
   error_message_    VARCHAR2(2000);
   info_             VARCHAR2(2000);
   objstate_         CUSTOMER_ORDER.objstate%TYPE;
   credit_blocked_   BOOLEAN := FALSE;
   qty_assigned_     NUMBER;
   order_line_rec_   Customer_Order_Line_API.Public_Rec;  
   reservation_info_ VARCHAR2(1000) := NULL;
   shipment_id_      NUMBER;
   credit_control_group_id_  VARCHAR2(40);
   check_ext_customer_       VARCHAR2(5);
   ext_order_no_             VARCHAR2(20);
   customer_credit_blocked_  VARCHAR2(25);
   ext_cust_credit_blocked_  VARCHAR2(25);
   customer_no_              VARCHAR2(20);
   customer_no_pay_          VARCHAR2(20);
   blocked_order_no_         VARCHAR2(12);
   parent_customer_          VARCHAR2(20);
   credit_attr_              VARCHAR2(2000);
   customer_order_rec_       Customer_Order_API.Public_Rec;
BEGIN
   curr_order_no_ := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
   shipment_id_   := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SHIPMENT_ID', attr_));

   -- Lock the first order
   Lock_Order___(curr_order_no_);

   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Trace_SYS.Field('Name', name_);
      Trace_SYS.Field('Value', value_);

      IF (name_ = 'ORDER_NO') THEN
         order_no_ := value_;
         Customer_Order_API.Check_Customer_Credit_Blocked(customer_credit_blocked_, credit_attr_, order_no_, 'FALSE');
         customer_order_rec_      := Customer_Order_API.Get(order_no_);
         customer_no_             := customer_order_rec_.customer_no;
         customer_no_pay_         := customer_order_rec_.customer_no_pay;
   
         IF (customer_credit_blocked_ = 'FALSE') THEN
            credit_control_group_id_ := Cust_Ord_Customer_API.Get_Credit_Control_Group_Id(NVL(customer_no_pay_, customer_no_));
            IF (credit_control_group_id_ IS NOT NULL) THEN
               check_ext_customer_   := Credit_Control_Group_API.Get_Ext_Cust_Crd_Chk_Db(credit_control_group_id_);
            END IF;

            IF check_ext_customer_ = 'TRUE' THEN 
                  Customer_Order_Line_API.Get_External_Cust_Order(ext_order_no_, order_no_);
               IF ext_order_no_ IS NOT NULL AND ext_order_no_ != order_no_ THEN
                  Customer_Order_API.Check_Customer_Credit_Blocked(ext_cust_credit_blocked_, credit_attr_, ext_order_no_);
                     
                  IF (ext_cust_credit_blocked_ != 'FALSE') THEN
                        customer_order_rec_      := Customer_Order_API.Get(ext_order_no_);
                        customer_no_             := customer_order_rec_.customer_no;
                        customer_no_pay_         := customer_order_rec_.customer_no_pay; 
                        blocked_order_no_        := ext_order_no_;
                        customer_credit_blocked_ := ext_cust_credit_blocked_;
                     END IF;   
                  END IF;   
            END IF;
         ELSE
            blocked_order_no_ := order_no_;
         END IF;
         
         IF Client_SYS.Item_Exist('PARENT_IDENTITY', credit_attr_) THEN
            parent_customer_ := Client_SYS.Get_Item_Value('PARENT_IDENTITY', credit_attr_); 
         END IF;
         
         -- First make sure the customer is not credit blocked
         CASE (customer_credit_blocked_)
            WHEN 'CUSTOMER_BLOCKED' THEN
               credit_blocked_ := TRUE;               
               IF parent_customer_ IS NULL THEN
                  Error_SYS.Record_General(lu_name_, 'NOPICKCUSTCREBLK: The customer :P1 for order :P2 is credit blocked. New reservations not allowed.', customer_no_, blocked_order_no_);
               ELSE
                  Error_SYS.Record_General(lu_name_, 'NOPICKPRCUSTCREBLK: The parent :P1 of the customer for order :P2 is credit blocked. New reservations not allowed.', parent_customer_, blocked_order_no_);
               END IF;
            WHEN 'PAY_CUSTOMER_BLOCKED' THEN
               credit_blocked_ := TRUE;
               IF parent_customer_ IS NULL THEN
                  Error_SYS.Record_General(lu_name_, 'NOPICKING: The paying customer :P1 for order :P2 is credit blocked. New reservations not allowed.', customer_no_pay_, blocked_order_no_);
               ELSE
                  Error_SYS.Record_General(lu_name_, 'NOPICKINGPAR: The parent :P1 of the paying customer for order :P2 is credit blocked. New reservations not allowed.', parent_customer_, blocked_order_no_);
               END IF;
            ELSE
               NULL;
         END CASE;

         IF (order_no_ != curr_order_no_) THEN
            curr_order_no_ := order_no_;
            -- Lock the current order
            Lock_Order___(curr_order_no_);
         END IF;
      ELSIF (name_ = 'LINE_NO') THEN
         line_no_ := value_;
      ELSIF (name_ = 'REL_NO') THEN
         rel_no_ := value_;
      ELSIF (name_ = 'LINE_ITEM_NO') THEN
         line_item_no_ := Client_SYS.Attr_Value_To_Number(value_);
         objstate_     := Customer_Order_API.Get_Objstate(order_no_);
         IF (objstate_ != 'Blocked') THEN
            order_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
            IF  (line_item_no_ = -1) THEN
               Reserve_Customer_Order_API.Reserve_Package__(order_no_, line_no_, rel_no_, shipment_id_);
            ELSIF  ((line_item_no_ = 0) AND
                ((order_line_rec_.part_no IS NULL) OR (order_line_rec_.supply_code = 'SEO')))  THEN
                Customer_Order_Line_API.Make_Service_Deliverable__(order_no_, line_no_, rel_no_, line_item_no_, shipment_id_);
            ELSE
                -- Pass in a NULL value for qty_to_reserve in order to reserve the whole quantity.
                Reserve_Customer_Order_API.Reserve_Order_Line__(qty_assigned_,
                                                                order_no_, line_no_, rel_no_,
                                                                line_item_no_, NULL, shipment_id_);
            END IF;
         ELSE
            info_             := order_no_ ||' '|| line_no_ ||' '|| rel_no_||' '||line_item_no_;
            reservation_info_ := Language_SYS.Translate_Constant(lu_name_, 'CANNOTRESBLOCKED: Customer order line :P1 cannot be reserved since the order is credit-blocked.',
                                                                 NULL, info_);
            Transaction_SYS.Set_Status_Info(reservation_info_);
         END IF;
      END IF;
   END LOOP;
   
   IF (NVL(shipment_id_, 0) = 0) THEN   
      -- Continue with the event following pick planning
      Proceed_After_Pick_Planning__(order_no_);
   END IF;
EXCEPTION
   WHEN others THEN
      error_message_ := sqlerrm;
      @ApproveTransactionStatement(2012-01-24,GanNLK)
      ROLLBACK;
      IF (Transaction_SYS.Is_Session_Deferred) THEN
         -- Logg the error
         info_ := Language_SYS.Translate_Constant(lu_name_, 'ORDERERR: Order: :P1   :P2',
                                                  NULL, order_no_, error_message_);
         Transaction_SYS.Set_Status_Info(info_);
         IF (credit_blocked_) THEN
            IF (ext_cust_credit_blocked_ != 'FALSE') THEN
               Customer_Order_API.Set_Blocked(order_no_,     'BLKFORCREEXT', NULL);
               Customer_Order_API.Set_Blocked(ext_order_no_, 'BLKFORCRE', NULL);
            ELSE
               Customer_Order_API.Set_Blocked(order_no_, 'BLKFORCRE', NULL);
            END IF;
         END IF;
         Cust_Order_Event_Creation_API.Order_Processing_Error(order_no_, error_message_);
      ELSE
         -- Raise the error
         RAISE;
      END IF;   
    
END Reserve_Order_Lines__;
   
   
-- Start_Release_Order__
--   Release all orders enumerated in the attribute string.
PROCEDURE Start_Release_Order__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_All_Orders___(attr_);
END Start_Release_Order__;


-- Start_Print_Order_Conf__
--   Print the order confirmation for all orders enumerated in the attribute string.
PROCEDURE Start_Print_Order_Conf__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_All_Orders___(attr_);
END Start_Print_Order_Conf__;


-- Start_Reserve_Order__
--   Reserve all orders enumerated in the attribute string.
PROCEDURE Start_Reserve_Order__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_All_Orders___(attr_);
END Start_Reserve_Order__;


-- Start_Plan_Picking__
--   Send all lines passed from the client for sorting and pick planning.
PROCEDURE Start_Plan_Picking__ (
   attr_ IN OUT VARCHAR2 )
IS
   ord_ship_tab_  Reserve_Shipment_API.Reserve_Shipment_Table; 
BEGIN
   Start_Plan_Picking___(attr_, ord_ship_tab_, 0);
END Start_Plan_Picking__;


-- Start_Plan_Picking__
--   Send all lines passed from shipment flow for sorting and pick planning.
PROCEDURE Start_Plan_Picking__ (
   ord_ship_tab_ IN OUT Reserve_Shipment_API.Reserve_Shipment_Table,
   shipment_id_  IN     NUMBER )
IS
   attr_ VARCHAR2(32000) := NULL;
BEGIN
   Start_Plan_Picking___(attr_, ord_ship_tab_, shipment_id_);         
END Start_Plan_Picking__;


-- Start_Create_Pick_List__
--   Create pick list for all orders enumerated in the attribute string.
PROCEDURE Start_Create_Pick_List__ (
   attr_ IN OUT VARCHAR2 )
IS
   order_no_ VARCHAR2(12);
BEGIN
   order_no_ := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
   IF Customer_Order_Reservation_API.Manual_Pick_Lines_Exist(order_no_) = 1 THEN
      Error_SYS.Record_General(lu_name_, 'MANUPICKERR: The customer order :P1 has reservation line(s) connected to manual consolidated pick list(s).', order_no_);
   END IF;
   Process_All_Orders___(attr_);
END Start_Create_Pick_List__;


-- Start_Print_Pick_List__
--   Print all pick lists enumerated in the attribute string
PROCEDURE Start_Print_Pick_List__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_All_Orders___(attr_);
END Start_Print_Pick_List__;


-- Start_Report_Picking__
--   Report picking for all orders enumerated in the attribute string
PROCEDURE Start_Report_Picking__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_All_Orders___(attr_);
END Start_Report_Picking__;


-- Start_Deliver__
--   Deliver all orders enumerated in the attribute string
PROCEDURE Start_Deliver__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_All_Orders___(attr_);
END Start_Deliver__;


-- Start_Create_Delivery_Note__
--   Create delivery note for all orders enumerated in the attribute string
PROCEDURE Start_Create_Delivery_Note__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_All_Orders___(attr_);
END Start_Create_Delivery_Note__;


-- Start_Print_Delivery_Note__
--   Print all delivery notes enumerated in the attribute string
PROCEDURE Start_Print_Delivery_Note__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_All_Orders___(attr_);
END Start_Print_Delivery_Note__;


-- Start_Create_Invoice__
--   Create invoice for all orders enumerated in the attribute string
PROCEDURE Start_Create_Invoice__ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Process_All_Orders___(attr_);
END Start_Create_Invoice__;


-- Start_Print_Invoice__
--   Print all invoices enumerated in the attribute string
PROCEDURE Start_Print_Invoice__ (
   attr_ IN OUT VARCHAR2 )
IS
   description_ VARCHAR2(200);
   send_        VARCHAR2(5) := Client_SYS.Get_Item_Value('SEND', attr_);
   resend_      VARCHAR2(5) := 'FALSE';
BEGIN
   -- Printout of invoices can not be done in the flow because collective invoices
   -- are not connected to one single order.
   Trace_SYS.Field('ATTR', attr_);
   Trace_SYS.Field('SEND', send_);
   resend_ := NVL(Client_SYS.Get_Item_Value('RESEND', attr_), 'FALSE');

   IF (send_ IS NULL) THEN
      description_ := Language_SYS.Translate_Constant(lu_name_, 'PRINT_INVOICES: Print Customer Order Invoices');
   ELSE
      IF (resend_ = 'TRUE') THEN
         description_ := Language_SYS.Translate_Constant(lu_name_, 'RESEND_INVOICE: Resend Customer Order Invoice');
      ELSE
         description_ := Language_SYS.Translate_Constant(lu_name_, 'SEND_INVOICE: Send Customer Order Invoice');
      END IF;
   END IF;

   IF (resend_ = 'TRUE') THEN
      Transaction_SYS.Deferred_Call('Customer_Order_Inv_Head_API.Send_Invoices', attr_, description_);
   ELSE
      Print_Invoices___(attr_, description_);
   END IF;
END Start_Print_Invoice__;


-- Proceed_After_Pick_Planning__
--   Called from ReserveCustomerOrder when an entire order has been pick
--   planned. This procedure will enter the flow att the event corresponding
--   to pick list creation.
--   Called when an entire order has been pick planned. This procedure will enter the flow att the event corresponding to pick list creation.
PROCEDURE Proceed_After_Pick_Planning__ (
   order_no_ IN VARCHAR2 )
IS
   attr_     VARCHAR2(2000);
   order_id_ VARCHAR2(3);
BEGIN
   order_id_ := Customer_Order_API.Get_Order_Id(order_no_);
   IF (Cust_Order_Type_Event_API.Get_Next_Event(order_id_, 60) IS NOT NULL) THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('START_EVENT', 70, attr_);
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
      Client_SYS.Add_To_Attr('END', '', attr_);
      Process_Order__(attr_);
   END IF;
END Proceed_After_Pick_Planning__;


-- Get_Allowed_Operations__
--   Returns a string used to determine which operations should be allowed for the specified order
@UncheckedAccess
FUNCTION Get_Allowed_Operations__ (
   order_no_       IN VARCHAR2,
   from_co_header_ IN VARCHAR2 DEFAULT 'FALSE' ) RETURN VARCHAR2
IS
   operations_ VARCHAR2(20);
BEGIN
   -- Release order
   IF (Release_Allowed__(order_no_) = 1) THEN
      operations_ := '0';
   ELSE
      operations_ := '*';
   END IF;

   -- Don't allow Release Quoted Order, since it's not used any more
   operations_ := operations_ || '*';

   -- Print order confirmation
   IF (Print_Order_Conf_Allowed__(order_no_)  = 1) THEN
      operations_ := operations_ || '2';
   ELSIF (Reprint_Order_Conf_Allowed___(order_no_)  = 1) THEN
      -- Reprint of the order confirmation is allowed
      operations_ := operations_ || 'R';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   IF (from_co_header_ = 'TRUE') THEN
      operations_ := operations_ ||'********';
   ELSE
      -- Plan picking
      IF (Reserve_Allowed__(order_no_)  = 1) THEN
         operations_ := operations_ || '3';
      ELSE
         operations_ := operations_ || '*';
      END IF;
   
      -- Create picklist
      IF (Create_Pick_List_Allowed__(order_no_) = 1) THEN
         operations_ := operations_ || '4';
      ELSE
         operations_ := operations_ || '*';
      END IF;
   
      -- Print picklist
      IF (Print_Pick_List_Allowed__(order_no_) = 1) THEN
         operations_ := operations_ || '5';
      ELSE
         operations_ := operations_ || '*';
      END IF;
   
      -- Report picking
      IF (Report_Picking_Allowed__(order_no_) = 1) THEN
         operations_ := operations_ || '6';
      ELSE
         operations_ := operations_ || '*';
      END IF;
   
      -- Deliver order
      IF (Deliver_Allowed__(order_no_) = 1) THEN
         operations_ := operations_ || '7';
      ELSE
         operations_ := operations_ || '*';
      END IF;
   
      -- Create delivery note
      IF (Create_Deliv_Note_Allowed__(order_no_) = 1) THEN
         operations_ := operations_ || '8';
      ELSE
         operations_ := operations_ || '*';
      END IF;
   
      -- Print delivery note
      IF (Print_Deliv_Note_Allowed__(order_no_) = 1) THEN
         operations_ := operations_ || '9';
      ELSE
         operations_ := operations_ || '*';
      END IF;
   
      -- Create invoice
      IF (Create_Invoice_Allowed__(order_no_, TRUE, -1) = 1) THEN
         operations_ := operations_ || 'A';
      ELSE
         operations_ := operations_ || '*';
      END IF;
   END IF;

   -- Cancel
   IF (Cancel_Allowed__(order_no_) = 1) THEN
      operations_ := operations_ || 'B';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Close
   IF (Close_Allowed__(order_no_) = 1) THEN
      operations_ := operations_ || 'C';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Don't allow Print Quoted Order, since it's not used any more
   operations_ := operations_ || '*';

   -- Delivery Confirmation (step performed between Delivery and Create Invoice)
   IF (Deliv_Confirm_Cust_Order_API.Deliv_Confirm_Allowed(order_no_) = 1) THEN
      operations_ := operations_ || 'F';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Email order confirnation
   IF (Email_Order_Conf_Allowed___(order_no_)  = 1) THEN
      operations_ := operations_ || 'G';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Email pro forma invoice
   IF (Email_Pro_Forma_Allowed___(order_no_)  = 1) THEN
      operations_ := operations_ || 'H';
   ELSE
      operations_ := operations_ || '*';
   END IF;
   
   -- Handle return material authorization
   IF (Handle_Rma_Allowed___(order_no_) = 1) THEN
      operations_ := operations_ || 'I';
   ELSE
      operations_ := operations_ || '*';
   END IF;
   
   -- Create return material authorization
   IF (Create_Rma_Allowed___(order_no_) = 1) THEN
      operations_ := operations_ || 'J';
   ELSE
      operations_ := operations_ || '*';   
   END IF;
   
   -- View/Edit return material authorization
   IF (Edit_Rma_Allowed___(order_no_) = 1) THEN
      operations_ := operations_ || 'K';
   ELSE
      operations_ := operations_ || '*';   
   END IF;

   RETURN operations_;
END Get_Allowed_Operations__;


-- Returns comma seperated list of allowed operations in customer order
FUNCTION Get_Allowed_Operations_Desc__ (
      order_no_       IN VARCHAR2,
      from_co_header_ IN VARCHAR2 DEFAULT 'FALSE' ) RETURN VARCHAR2
   IS
      operations_ VARCHAR2(2000) := '';
      seperator_  VARCHAR2(3) := '';
   BEGIN
      -- Release order
      IF (Release_Allowed__(order_no_) = 1) THEN
         operations_ := Order_Flow_Activities_API.Get_Client_Value(0);
         seperator_ := ', ';
      END IF;
   
      -- Print order confirmation
      IF (Print_Order_Conf_Allowed__(order_no_)  = 1) THEN
         operations_ := operations_ || seperator_ || Order_Flow_Activities_API.Get_Client_Value(2);
         seperator_ := ', ';
      END IF;
   
       -- Plan picking
       IF (Reserve_Allowed__(order_no_)  = 1) THEN
         operations_ := operations_ || seperator_ || Order_Flow_Activities_API.Get_Client_Value(3);
         seperator_ := ', ';
       END IF;
        
       -- Create picklist
       IF (Create_Pick_List_Allowed__(order_no_) = 1) THEN
          operations_ := operations_ || seperator_ || Order_Flow_Activities_API.Get_Client_Value(4);
          seperator_ := ', ';
       END IF;
        
       -- Print picklist
       IF (Print_Pick_List_Allowed__(order_no_) = 1) THEN
          operations_ := operations_ || seperator_ || Order_Flow_Activities_API.Get_Client_Value(5);
          seperator_ := ', ';
       END IF;
        
       -- Report picking
       IF (Report_Picking_Allowed__(order_no_) = 1) THEN
          operations_ := operations_ || seperator_ || Order_Flow_Activities_API.Get_Client_Value(6);
          seperator_ := ', ';
       END IF;
        
       -- Deliver order
       IF (Deliver_Allowed__(order_no_) = 1) THEN
         operations_ := operations_ || seperator_ || Order_Flow_Activities_API.Get_Client_Value(7);
         seperator_ := ', ';
       END IF;
        
       -- Create delivery note
       IF (Create_Deliv_Note_Allowed__(order_no_) = 1) THEN
          operations_ := operations_ || seperator_ || Order_Flow_Activities_API.Get_Client_Value(8);
          seperator_ := ', ';
       END IF;
        
       -- Print delivery note
       IF (Print_Deliv_Note_Allowed__(order_no_) = 1) THEN
          operations_ := operations_ || seperator_ || Order_Flow_Activities_API.Get_Client_Value(9);
          seperator_ := ', ';
       END IF;
        
       -- Create invoice
       IF (Create_Invoice_Allowed__(order_no_, TRUE, -1) = 1) THEN
          operations_ := operations_ || seperator_ || Order_Flow_Activities_API.Get_Client_Value(10);
          seperator_ := ', ';
       END IF; 
      RETURN operations_;
   END Get_Allowed_Operations_Desc__;



-- Release_Allowed__
--   Return TRUE (1) if the Release operation is allowed for the specified order
@UncheckedAccess
FUNCTION Release_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER;
   CURSOR release_order IS
      SELECT 1
      FROM   customer_order_tab
      WHERE  rowstate = 'Planned'
      AND    order_no = order_no_ ;
BEGIN
   OPEN release_order;
   FETCH release_order INTO allowed_;
   IF (release_order%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE release_order;
   RETURN allowed_;
END Release_Allowed__;



-- Print_Order_Conf_Allowed__
--   Return and sign plus TRUE (1) if the Print Order Confirmation operation is allowed for the specified order
@UncheckedAccess
FUNCTION Print_Order_Conf_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER;

   CURSOR order_conf IS
      SELECT 1
      FROM   customer_order_tab
      WHERE  rowstate NOT IN ('Blocked', 'Cancelled')
      AND    order_no = order_no_
      AND    order_conf_flag = 'Y'
      AND    order_conf = 'N';
BEGIN
   OPEN order_conf;
   FETCH order_conf INTO allowed_;
   IF (order_conf%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE order_conf;
   RETURN allowed_;
END Print_Order_Conf_Allowed__;


-- Reserve_Allowed__
--   Return and sign plus TRUE (1) if the Plan Picking operation is allowed for the specified order
@UncheckedAccess
FUNCTION Reserve_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_   NUMBER;
  
   -- Note : Modified the WHERE condition by adding supply code 'IPT' and 'PT' when there is a qty to reserve
   -- and added qty_assigned when considering supply_code 'PT'. Removed the part_no check for supply code SEO.
   -- Modified supply code check to exclude inventory parts with supply code 'SEO'.
   -- Modified cursor by adding PRJ and removing PRD in supply code and by restructuring the qty values.   
   CURSOR plan_pick IS
      SELECT 1
      FROM   customer_order_tab co, customer_order_line_tab col
      WHERE  co.order_no = order_no_
      AND    co.rowstate NOT IN ('Planned', 'Blocked')
      AND    col.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND    col.order_no = co.order_no
      AND    line_item_no >= 0
      AND    ((revised_qty_due - qty_assigned - qty_shipped + qty_shipdiff > 0 AND
             supply_code IN ('IO', 'PI', 'PS', 'PJD'))
             OR
             (revised_qty_due - qty_to_ship - qty_shipped + qty_shipdiff > 0 AND
             (supply_code IN ('NO', 'PRJ', 'SEO'))
             OR
             (revised_qty_due - qty_assigned - qty_to_ship - qty_shipped + qty_shipdiff > qty_on_order AND 
             supply_code IN ('PT', 'IPT', 'SO', 'DOP'))));
BEGIN
   OPEN plan_pick;
   FETCH plan_pick INTO allowed_;
   IF (plan_pick%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE plan_pick;
   RETURN allowed_;
END Reserve_Allowed__;


-- Create_Pick_List_Allowed__
--   Return and sign plus TRUE (1) if the Create Pick List operation is allowed for the specified order
@UncheckedAccess
FUNCTION Create_Pick_List_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER;
   -- The index on pick_list_no should not be used by this cursor
   CURSOR cre_pick IS
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
   OPEN cre_pick;
   FETCH cre_pick INTO allowed_;
   IF (cre_pick%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE cre_pick;
   RETURN allowed_;
END Create_Pick_List_Allowed__;



-- Print_Pick_List_Allowed__
--   Return and sign plus TRUE (1) if the Print Pick List operation is allowed for the specified order
@UncheckedAccess
FUNCTION Print_Pick_List_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER;

   CURSOR pick_list IS
      SELECT 1
      FROM   customer_order_tab
      WHERE  rowstate NOT IN ('Delivered', 'Invoiced', 'Cancelled')
      AND    order_no = order_no_
      AND    pick_list_flag = 'Y'
      AND    EXISTS (SELECT 1
                     FROM   customer_order_pick_list_tab
                     WHERE  order_no = order_no_
                     AND    printed_flag = 'N'
                     AND    consolidated_flag = 'NOT CONSOLIDATED');

   CURSOR is_consolidated_picked IS
      SELECT 1
      FROM   customer_order_pick_list_tab
      WHERE  pick_list_no IN (SELECT pick_list_no
                              FROM   consolidated_orders_tab
                              WHERE  order_no = order_no_)
      AND    consolidated_flag = 'CONSOLIDATED'
      AND    picking_confirmed = 'PICKED'
      AND    printed_flag = 'N'
      AND    consolidation != 'SHIPMENT';
BEGIN
   OPEN pick_list;
   FETCH pick_list INTO allowed_;
   IF (pick_list%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE pick_list;

   IF (allowed_ = 0) THEN
      OPEN is_consolidated_picked;
      FETCH is_consolidated_picked INTO allowed_;
      CLOSE is_consolidated_picked;
   END IF;
   RETURN allowed_;
END Print_Pick_List_Allowed__;


-- Report_Picking_Allowed__
--   Return and sign plus TRUE (1) if the Report Picking operation is allowed for the specified order
@UncheckedAccess
FUNCTION Report_Picking_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER;
   -- Report picking is allowed if qty_assigned > qty_picked and a nonreported
   -- nonconsolidated pick list exists
   CURSOR report_picking IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    qty_assigned > qty_picked
      AND    shipment_connected = 'FALSE'
      AND    EXISTS (SELECT 1
                     FROM   CUSTOMER_ORDER_PICK_LIST_TAB
                     WHERE  order_no = order_no_
                     AND    picking_confirmed = 'UNPICKED'
                     AND    consolidated_flag = 'NOT CONSOLIDATED');
BEGIN
   OPEN report_picking;
   FETCH report_picking INTO allowed_;
   IF (report_picking%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE report_picking;
   RETURN allowed_;
END Report_Picking_Allowed__;


-- Report_Picking_Ok__
--   Return and sign plus TRUE (1) if the Report Picking operation is allowed for the specified picklist
@UncheckedAccess
FUNCTION Report_Picking_Ok__ (
   pick_list_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER;
   -- Report picking is allowed if qty_assigned > qty_picked and a nonreported pick list exists
   CURSOR report_picking IS
      SELECT 1
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  pick_list_no = pick_list_no_
      AND    qty_assigned > qty_picked
      AND    EXISTS (SELECT 1
                     FROM   CUSTOMER_ORDER_PICK_LIST_TAB
                     WHERE  pick_list_no = pick_list_no_
                     AND    picking_confirmed = 'UNPICKED');
BEGIN
   OPEN report_picking;
   FETCH report_picking INTO allowed_;
   IF (report_picking%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE report_picking;
   RETURN allowed_;
END Report_Picking_Ok__;


-- Deliver_Allowed__
--   Return and sign plus TRUE (1) if the Deliver operation is allowed for the specified order
@UncheckedAccess
FUNCTION Deliver_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER;
   order_rec_  Customer_Order_API.Public_Rec;
   -- Delivery of an order line is allowed if the line is not connected to a load list
   -- and qty_picked > 0 (inventory parts) or qty_to_ship != 0 (noninventory parts)
   -- Negative quantities are allowed for noninventory parts when the line has been created
   -- from service management
   CURSOR deliver_allowed IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB col
      WHERE  col.order_no = order_no_
        AND  (qty_picked > 0 OR qty_to_ship != 0)
        AND  (qty_shipped < revised_qty_due OR qty_to_ship < 0)
        AND  shipment_connected = 'FALSE'
        AND  NOT EXISTS (SELECT 1
                         FROM   CUST_ORDER_LOAD_LIST_TAB ll,
                                CUST_ORDER_LOAD_LIST_LINE_TAB lll
                         WHERE  ll.load_id = lll.load_id
                         AND    ll.load_list_state = 'NOTDEL'
                         AND    lll.order_no = col.order_no
                         AND    lll.line_no = col.line_no
                         AND    lll.rel_no = col.rel_no
                         AND    lll.line_item_no = col.line_item_no);
BEGIN
   order_rec_       := Customer_Order_API.Get(order_no_);   
   IF (order_rec_.use_pre_ship_del_note = 'TRUE') THEN
      allowed_ := Allow_Non_Inv_Delivery___ (order_no_,NULL,NULL,NULL);
      IF (allowed_ = 0) THEN
         allowed_ := Allow_Service_Ord_Delivery___(order_no_);   
      END IF;
   ELSE
      IF (order_rec_.rowstate NOT IN ('Planned', 'Blocked')) THEN
         OPEN deliver_allowed;
         FETCH deliver_allowed INTO allowed_;
         IF (deliver_allowed%NOTFOUND) THEN
            allowed_ := 0;
         END IF;
         CLOSE deliver_allowed;
      END IF;
   END IF;
   RETURN allowed_;
END Deliver_Allowed__;



-- Deliver_With_Diff_Allowed__
--   Return and sign plus TRUE (1) if the Deliver with differences operation is allowed for the specified order.
--   The difference between this method and DeliverAllowed is that this service order lines with qty_to_ship = 0 are considered possible to deliver with difference.
@UncheckedAccess
FUNCTION Deliver_With_Diff_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER;
   order_rec_  Customer_Order_API.Public_Rec;

   CURSOR deliver_allowed IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB col
      WHERE  col.order_no = order_no_
        AND  ((qty_picked > 0) OR (qty_to_ship > 0) OR
              (supply_code IN ('NO', 'SEO', 'PRJ') AND (revised_qty_due - qty_shipped + qty_shipdiff) > 0))
        AND  (qty_shipped < (revised_qty_due *(1-close_tolerance/100)))
        AND  col.shipment_connected = 'FALSE'
        AND  NOT EXISTS (SELECT 1
                         FROM   CUST_ORDER_LOAD_LIST_TAB ll,
                                CUST_ORDER_LOAD_LIST_LINE_TAB lll
                         WHERE  ll.load_id = lll.load_id
                         AND    ll.load_list_state = 'NOTDEL'
                         AND    lll.order_no = col.order_no
                         AND    lll.line_no = col.line_no
                         AND    lll.rel_no = col.rel_no
                         AND    lll.line_item_no = col.line_item_no);
BEGIN
   order_rec_       := Customer_Order_API.Get(order_no_);   
   IF (order_rec_.use_pre_ship_del_note = 'TRUE') THEN
      allowed_ := Allow_Non_Inv_Delivery___ (order_no_,NULL,NULL,NULL); 
   ELSE
      IF (order_rec_.rowstate NOT IN ('Planned', 'Blocked')) THEN
         OPEN deliver_allowed;
         FETCH deliver_allowed INTO allowed_;
         IF (deliver_allowed%NOTFOUND) THEN
            allowed_ := 0;
         END IF;
         CLOSE deliver_allowed;
      END IF;
   END IF;
   RETURN allowed_;
END Deliver_With_Diff_Allowed__;


-- Create_Deliv_Note_Allowed__
--   Return and sign plus TRUE (1) if the Create Delivery Note operation is allowed for the specified order
@UncheckedAccess
FUNCTION Create_Deliv_Note_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Deliver_Customer_Order_API.Delivery_Note_To_Be_Created(order_no_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Create_Deliv_Note_Allowed__;


-- Print_Deliv_Note_Allowed__
--   Return and sign plus TRUE (1) if the Print Delivery Note operation is allowed for the specified order
@UncheckedAccess
FUNCTION Print_Deliv_Note_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER;

   CURSOR delivery_note IS
      SELECT 1
      FROM   customer_order_tab
      WHERE  rowstate != 'Cancelled'
      AND    order_no = order_no_
      AND    pack_list_flag = 'Y'
      AND    EXISTS (SELECT 1
                     FROM   delivery_note_tab
                     WHERE  order_no = order_no_
                     AND    rowstate NOT IN ('Preliminary', 'Printed'));
BEGIN
   OPEN delivery_note;
   FETCH delivery_note INTO allowed_;
   IF (delivery_note%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE delivery_note;
   RETURN allowed_;
END Print_Deliv_Note_Allowed__;



-- Create_Invoice_Allowed__
--   Return and sign plus TRUE (1) if the Create Invoice operation is allowed for the specified order
@UncheckedAccess
FUNCTION Create_Invoice_Allowed__ (
   order_no_              IN VARCHAR2,
   incl_rental_due_trans_ IN BOOLEAN DEFAULT TRUE,
   ivc_unconct_chg_seperatly_ IN NUMBER  DEFAULT 1) RETURN NUMBER
IS
   order_rec_                  Customer_Order_API.Public_Rec;
   allowed_                    NUMBER := 0;   
   date_confirmed_             DATE;
   incorrect_del_confirmation_ VARCHAR2(5);
   adv_pre_paym_inv_available_ VARCHAR2(5);
   invoice_sort_               VARCHAR2(20);
   ordering_company_           VARCHAR2(20);
   comp_ivc_unconct_chg_seprtly_   VARCHAR2(20); 
   cust_order_line_no_             VARCHAR2(20);
   
   CURSOR deliveries_to_invoice IS
      SELECT cod.date_confirmed, cod.incorrect_del_confirmation
      FROM   customer_order_delivery_tab cod, customer_order_line_tab col
      WHERE  col.order_no = order_no_
      AND    col.rowstate NOT IN ('Invoiced', 'Cancelled')
      AND    cod.order_no = col.order_no
      AND    cod.line_no = col.line_no
      AND    cod.rel_no = col.rel_no
      AND    cod.line_item_no = col.line_item_no
      AND    col.self_billing = Self_Billing_Type_API.DB_NOT_SELF_BILLING
      AND    col.blocked_for_invoicing = Fnd_Boolean_API.DB_FALSE
      AND    col.provisional_price = Fnd_Boolean_API.DB_FALSE
      AND    col.rental = Fnd_Boolean_API.DB_FALSE 
      AND    ((cod.line_item_no <= 0 AND cod.qty_to_invoice != cod.qty_invoiced) OR
              (cod.line_item_no > 0 AND
              (cod.component_invoice_flag = 'Y')))
      AND    cod.cancelled_delivery = 'FALSE';

   CURSOR charges_to_invoice IS
      SELECT 1
      FROM   customer_order_charge_tab coc, customer_order_tab co
      WHERE  co.rowstate NOT IN ('Cancelled', 'Planned')
      AND    co.order_no = coc.order_no
      AND    coc.line_no IS NULL                 -- not connected to an order line
      AND    ABS(coc.invoiced_qty) < ABS(coc.charged_qty)  -- not invoiced
      AND    coc.collect != 'COLLECT'            -- collect charges will not be invoiced
      AND    coc.campaign_id IS NULL             -- if the charge line has a campaign id for the time being it is a promotion charge
      AND    coc.order_no = order_no_;
      
   -- Retrieved the charges where CO line does not exist.
   CURSOR co_lines_exist IS
      SELECT col.order_no
      FROM   customer_order_line_tab col
      WHERE  col.rowstate IN ( 'Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered' )
      AND    col.order_no = order_no_; 
BEGIN
   order_rec_        := Customer_Order_API.Get(order_no_);
   IF ( order_rec_.rowstate = 'Invoiced' OR order_rec_.sales_contract_no IS NOT NULL OR order_rec_.blocked_type = Customer_Order_Block_Type_API.DB_MANUAL_BLOCKED) THEN
      RETURN 0;
   END IF;

   invoice_sort_     := Cust_Ord_Customer_API.Get_Invoice_Sort_Db(NVL(order_rec_.customer_no_pay, order_rec_.customer_no));
   ordering_company_ := Site_API.Get_Company(order_rec_.contract);
   
   -- Added the condition for checking ivc_unconct_chg_seperatly_ as -1 when it executes through the quick order flow and as 1 when 
   -- executes through the batch process.
   IF(ivc_unconct_chg_seperatly_ = -1) THEN
      comp_ivc_unconct_chg_seprtly_ := Company_Order_Info_API.Get_Ivc_Unconct_Chg_Seperat_Db(ordering_company_);
      IF(comp_ivc_unconct_chg_seprtly_ = 'TRUE')THEN
         comp_ivc_unconct_chg_seprtly_ := 1;
      ELSE 
         comp_ivc_unconct_chg_seprtly_ := 0;
      END IF;
   ELSE
      comp_ivc_unconct_chg_seprtly_ := ivc_unconct_chg_seperatly_;
   END IF;

   adv_pre_paym_inv_available_ := Customer_Invoice_Pub_Util_API.Has_Adv_Or_Prepaym_Inv(order_no_);

   IF (invoice_sort_ = 'C') AND (adv_pre_paym_inv_available_ = 'FALSE') THEN
      -- The paying customer has collective invoicing => return FALSE
      allowed_ := 0;

   -- Invoice should be created if:
   -- 1. The customer is external
   -- 2. The customer is internal and connected to a site associated with another company.
   ELSIF NOT ((NVL(Site_API.Get_Company(Cust_Ord_Customer_API.Get_Contract_From_Customer_No(order_rec_.customer_no)), Database_SYS.string_null_) = ordering_company_)
      OR (NVL(Site_API.Get_Company(Cust_Ord_Customer_API.Get_Contract_From_Customer_No(order_rec_.customer_no_pay)), Database_SYS.string_null_) = ordering_company_)) THEN
      IF order_rec_.confirm_deliveries = 'FALSE' THEN
         OPEN deliveries_to_invoice;
         FETCH deliveries_to_invoice INTO date_confirmed_, incorrect_del_confirmation_;
         IF (deliveries_to_invoice%FOUND) THEN
            allowed_ := 1;
         END IF;
         CLOSE deliveries_to_invoice;
      ELSE
         FOR deliveries_to_invoice_ IN deliveries_to_invoice LOOP
            IF (deliveries_to_invoice_.date_confirmed IS NOT NULL
                AND deliveries_to_invoice_.incorrect_del_confirmation = 'FALSE') THEN
               allowed_ := 1;
               EXIT;
            END IF;
         END LOOP;
      END IF;
      
      -- Modified the IF condition by checking the value of comp_ivc_unconct_chg_seprtly_ and added the ELSIF in order to support the
      -- flow when there are no charges connected.
      IF (allowed_ = 0 AND comp_ivc_unconct_chg_seprtly_ = 1) THEN
         OPEN charges_to_invoice;
         FETCH charges_to_invoice INTO allowed_;
         IF (charges_to_invoice%NOTFOUND) THEN
            -- additional check on staged billing
            allowed_ := Staged_Lines_To_Invoice___(order_no_);
         END IF;
         CLOSE charges_to_invoice;
      ELSIF(allowed_ = 0) THEN
         allowed_ := Staged_Lines_To_Invoice___(order_no_);
      END IF;
      
      OPEN co_lines_exist;
         FETCH co_lines_exist INTO cust_order_line_no_;
         IF (co_lines_exist%NOTFOUND) THEN
            OPEN charges_to_invoice;
            FETCH charges_to_invoice INTO allowed_;
            CLOSE charges_to_invoice;
         END IF;
      CLOSE co_lines_exist;
      
      $IF Component_Rental_SYS.INSTALLED $THEN
         IF (allowed_ = 0 AND (Customer_Order_API.Rental_Lines_Exist(order_no_) = Fnd_Boolean_API.DB_TRUE)) THEN
            allowed_ := Rental_Transaction_Manager_API.Create_Invoice_Allowed(order_no_, NULL, NULL, NULL, Rental_Type_API.DB_CUSTOMER_ORDER, incl_rental_due_trans_);   
         END IF;
      $END
   ELSE
      allowed_ := 0;
   END IF;
   RETURN allowed_;
END Create_Invoice_Allowed__;


-- Print_Invoice_Allowed__
--   Return and sign plus TRUE (1) if the Print Invoice operation is allowed for the specified order
@UncheckedAccess
FUNCTION Print_Invoice_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Customer_Order_Inv_Head_API.Allowed_To_Print(order_no_) = order_no_) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Print_Invoice_Allowed__;


-- Cancel_Allowed__
--   Return and sign plus TRUE (1) if the Cancel operation is allowed for the specified order
@UncheckedAccess
FUNCTION Cancel_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_ NUMBER;

   CURSOR cancel IS
      SELECT 1
      FROM   customer_order_tab
      WHERE  (rowstate IN ('Planned', 'Released', 'Blocked') OR
              (rowstate = 'Reserved' AND NOT EXISTS (SELECT 1 
                                                     FROM   customer_order_reservation_tab
                                                     WHERE  order_no = order_no_
                                                     AND    pick_list_no != '*')))
      AND    order_no = order_no_;
BEGIN
   OPEN cancel;
   FETCH cancel INTO allowed_;
   IF (cancel%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE cancel;
   RETURN allowed_;
END Cancel_Allowed__;


-- Close_Allowed__
--   Return and sign plus TRUE (1) if the Close operation is allowed for the specified order
@UncheckedAccess
FUNCTION Close_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_        NUMBER := 0;
   allowed_header_ NUMBER := 1;

   -- The following cursor is used to check if close is allowed on the order lines.
   CURSOR close_order_lines IS
     SELECT line_no, rel_no, line_item_no
     FROM   customer_order_line_tab
     WHERE  order_no = order_no_
     AND    line_item_no <= 0
     AND    rowstate NOT IN ('Cancelled','Invoiced');

   -- This cursor is used to prevent that close is allowed on orders without any lines.
   CURSOR close_order_header IS
     SELECT 1
     FROM   customer_order_tab
     WHERE  order_no = order_no_
     AND    rowstate IN ('Planned', 'Invoiced', 'Cancelled');
BEGIN
   FOR line_rec_ IN close_order_lines LOOP
      IF (Close_Line_Allowed__(order_no_, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no) != 1) THEN
         allowed_ := 0;
         EXIT;
      ELSE 
         allowed_ := 1; 
      END IF;
   END LOOP;

   OPEN close_order_header;
   FETCH close_order_header INTO allowed_header_;
   IF (close_order_header%FOUND) THEN
      allowed_header_ := 0;
   END IF;
   CLOSE close_order_header;

   IF (allowed_ = 1 AND allowed_header_ = 1) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Close_Allowed__;


-- Start_Print_Consol_Pl__
--   Print a Consolidated Pick List, may contain several orders. Starts a background job
PROCEDURE Start_Print_Consol_Pl__ (
   attr_ IN OUT VARCHAR2 )
IS
   description_ VARCHAR2(200);
BEGIN
   Trace_SYS.Field('attr_', attr_);
   description_ := Language_SYS.Translate_Constant(lu_name_, 'PRINT_CONSOLIDATED: Print Consolidated Pick List');
   Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Print_Consol_Pick_List__', attr_, description_);
--   Print_Consol_Pick_List___(attr_);
END Start_Print_Consol_Pl__;


-- Print_Consol_Pick_List__
--   Print a Consolidated Pick List, may contain several orders
PROCEDURE Print_Consol_Pick_List__ (
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
         Print_Pick_List(pick_list_no_);
         Trace_SYS.Field('pick_list_no_', pick_list_no_);
      END IF;
   END LOOP;
END Print_Consol_Pick_List__;


-- Release_Source_Line__
--   Private method handling the deferred call to Release_Source_Line,
--   Creates new Co lines if the order line is fully sourced.
--   This procedure is to release remaining fully sourced CO lines, when the order header is in Released state.
PROCEDURE Release_Source_Line__ (
   attr_ IN VARCHAR2 )
IS
   objstate_           CUSTOMER_ORDER_TAB.rowstate%TYPE;
   ptr_                NUMBER;
   name_               VARCHAR2(30);
   value_              VARCHAR2(2000);
   order_no_           VARCHAR2(12);
   line_no_            VARCHAR2(4);
   rel_no_             VARCHAR2(4);
   line_item_no_       NUMBER;
   order_line_qty_     NUMBER;
   total_sourced_qty_  NUMBER;
   created_flag_       VARCHAR2(5);
BEGIN
   -- Retrieve parameters from the attribute string
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'ORDER_NO') THEN
         order_no_ := value_;
      ELSIF (name_ = 'LINE_NO') THEN
         line_no_ := value_;
      ELSIF (name_ = 'REL_NO') THEN
         rel_no_ := value_;
      ELSIF (name_ = 'LINE_ITEM_NO') THEN
         line_item_no_ := value_;
      END IF;
   END LOOP;

   objstate_          := Customer_Order_API.Get_Objstate(order_no_);
   order_line_qty_    := Customer_Order_Line_API.Get_Revised_Qty_Due( order_no_, line_no_, rel_no_, line_item_no_);
   total_sourced_qty_ := Sourced_Cust_Order_Line_API.Get_Total_Sourced_Qty ( order_no_, line_no_, rel_no_, line_item_no_);
   IF order_line_qty_ = total_sourced_qty_ THEN
      Customer_Order_Line_API.Create_Sourced_CO_Lines(created_flag_, order_no_, line_no_, rel_no_, line_item_no_ );

      IF (objstate_ IN ('Released', 'Reserved')) THEN
         -- Check so any project connected to this order have been approved before this release
         Check_Project_Approved___(order_no_);
         -- Make sure that all mandatory postings have been made for the order header and order lines
         Check_Mandatory_Postings___(order_no_);
         -- Calculate discount for this order
         Customer_Order_API.Calculate_Order_Discount__(order_no_ => order_no_);
         -- Execute the credit check
         Credit_Check_Order(order_no_, 'RELEASE_ORDER');

         objstate_ := Customer_Order_API.Get_Objstate(order_no_);

         -- If the order was credit blocked then no connected orders should be created.
         IF (objstate_ != 'Blocked') THEN
            -- Check if there are any Internal Purchase Order Direct (IPD),
            -- Internal Purchase Order Transit (IPT), Purchase Order Direct (PD),
            -- Purchase Order Transit (PT) or Shop Order (SO) supply codes to be handled.
            Connect_Customer_Order_API.Generate_Connected_Orders(order_no_);
         END IF;

         -- Generate next level demands for order lines with inventory parts having MRP order code = 'N'
         -- The reason this is done even if the order was credit blocked is that there is no way
         -- of knowing whether demands have already been generated or not for a released order.
         -- If the demands were generated in Proceed_After_Credit_Check there is a risk that
         -- they would be generated more than once for the same order.
         Generate_Next_Level_Demands___(order_no_);
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOTFULLYSOURCED: Order line sales quantity is not fully sourced. Please check source lines.');
   END IF;
END Release_Source_Line__;


-- Close_Line_Allowed__
--   This function returns 1 if the customer order line corresponding to the given order number, line number, release number and line item number is allowed to be closed, 0 otherwise.
@UncheckedAccess
FUNCTION Close_Line_Allowed__ (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER ) RETURN NUMBER
IS
   rev_qty_due_   NUMBER;
   qty_picked_    NUMBER;
   qty_shipped_   NUMBER;
   qty_invoiced_  NUMBER;
   qty_shipdiff_  NUMBER;
   close_allowed_ NUMBER := 0;
   rowstate_      VARCHAR2(20);

   CURSOR get_line_details IS
      SELECT rowstate, revised_qty_due, qty_picked, qty_shipped, qty_invoiced, qty_shipdiff
        FROM customer_order_line_tab
       WHERE order_no = order_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no = line_item_no_;
BEGIN
   OPEN get_line_details;
   FETCH get_line_details INTO rowstate_, rev_qty_due_, qty_picked_, qty_shipped_, qty_invoiced_, qty_shipdiff_;
   CLOSE get_line_details;
   IF ((qty_picked_ + qty_shipped_ - qty_shipdiff_) < rev_qty_due_) THEN
      IF ((rowstate_ = 'PartiallyDelivered') OR
          ((rowstate_ = 'Picked') AND (qty_picked_ < rev_qty_due_)) OR
          ((rowstate_ = 'Released') AND (qty_shipped_ = 0) AND (qty_invoiced_ > 0))) THEN
         close_allowed_ := 1;
      END IF;
   END IF;
   RETURN close_allowed_;
END Close_Line_Allowed__;


-- Report_Reserved_As_Picked__
--   Pick report the reserved quantities in the order lines directly.
PROCEDURE Report_Reserved_As_Picked__ (
   order_no_    IN VARCHAR2,
   location_no_ IN VARCHAR2 )
IS
   description_         VARCHAR2(200);
   order_rec_           Customer_Order_API.Public_Rec; 

   CURSOR get_lines IS
      SELECT order_no, line_no, rel_no, line_item_no
        FROM customer_order_line_tab
       WHERE order_no  = order_no_
         AND catalog_type != 'NON'
         AND shipment_connected = 'FALSE'
         AND rowstate NOT IN ('Cancelled', 'Invoiced');
BEGIN
   order_rec_ := Customer_Order_API.Get(order_no_);

   --  Check if a backorder would be generated
   IF ((order_rec_.backorder_option = 'NO PARTIAL DELIVERIES ALLOWED')
       AND Create_Pick_List_API.Check_Order_For_Backorder__(order_no_)) THEN
      Error_SYS.Record_General(lu_name_,
                               'NOBACKORDER: Partial deliveries not allowed for order :P1. The order must be fully reserved before executing Report Reserved Quantities as Picked.',
                               order_no_);
   END IF;

   Inventory_Event_Manager_API.Start_Session;
   FOR line_rec_ IN get_lines LOOP
      Pick_Customer_Order_API.Report_Reserved_As_Picked__(order_no_          => line_rec_.order_no,
                                                          line_no_           => line_rec_.line_no,
                                                          rel_no_            => line_rec_.rel_no,
                                                          line_item_no_      => line_rec_.line_item_no,
                                                          location_no_       => location_no_,
                                                          shipment_id_       => 0);
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;

   description_ := Raise_Report_Picking_Msg___;
   Transaction_SYS.Deferred_Call('PICK_CUSTOMER_ORDER_API.To_Order_Flow_When_Picked__', order_no_, description_);
END Report_Reserved_As_Picked__;


-- Reserved_As_Picked_Allowed__
--   Checks if the CO Lines in the order has reservations for which a pick list has not yet been created.
@UncheckedAccess
FUNCTION Reserved_As_Picked_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   return_val_ VARCHAR2(5) := 'FALSE';
   temp_       NUMBER;

   CURSOR get_lines IS
      SELECT order_no, line_no, rel_no, line_item_no
        FROM customer_order_line_tab
       WHERE order_no  = order_no_
         AND shipment_connected = 'FALSE'
         AND rowstate != 'Cancelled'
         AND catalog_type != 'NON';
  
   CURSOR check_shipment_creation IS
      SELECT 1
        FROM customer_order_line_tab
       WHERE order_no  = order_no_
         AND rowstate != 'Cancelled'
         AND shipment_creation = 'PICK_LIST_CREATION';
BEGIN
   -- Shipment creation at pick list stage is not allowed for this RMB
   OPEN check_shipment_creation;
   FETCH check_shipment_creation INTO temp_;
   IF (check_shipment_creation%FOUND) THEN
      CLOSE check_shipment_creation;
      RETURN return_val_;
   END IF;
   CLOSE check_shipment_creation;

   FOR line_rec_ IN get_lines LOOP
      return_val_ := Pick_Customer_Order_API.Reserved_As_Picked_Allowed__(line_rec_.order_no,
                                                                          line_rec_.line_no,
                                                                          line_rec_.rel_no,
                                                                          line_rec_.line_item_no);
      IF return_val_ = 'TRUE' THEN
         EXIT;
      END IF;
   END LOOP;

   RETURN return_val_;
END Reserved_As_Picked_Allowed__;


-- Email_Order_Report__
--   Send email to customer contact email address with attached pdf file for customer order confirmation, Pro Forma Invoice and Invoice.
PROCEDURE Email_Order_Report__ (
   order_no_    IN VARCHAR2,
   contact_     IN VARCHAR2,
   contract_    IN VARCHAR2,
   email_       IN VARCHAR2,
   customer_no_ IN VARCHAR2,
   report_id_   IN VARCHAR2 )
IS
   fnd_user_            VARCHAR2(30)         := Fnd_Session_API.Get_Fnd_User;
   field_separator_     CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;
   report_attr_         VARCHAR2(2000);
   parameter_attr_      VARCHAR2(2000);
   message_attr_        VARCHAR2(2000);
   archiving_attr_      VARCHAR2(2000);
   schedule_name_       VARCHAR2(200);
   msg_                 VARCHAR2(2000);
   pdf_archiving_       VARCHAR2(5)       := 'TRUE';
   start_date_          DATE              := SYSDATE;
   next_execution_date_ DATE;
   schedule_id_         NUMBER;
   seq_no_              NUMBER;
   invoice_number_      VARCHAR2(70);
   our_reference_       VARCHAR2(100);   
   company_             VARCHAR2(20);   
   print_job_id_        NUMBER;
   temp_contact_        VARCHAR2(200);
   bill_addr_no_        VARCHAR2(50);
      
   CURSOR get_invoice_details IS
      SELECT our_reference, series_id, invoice_no, creators_reference order_no, rma_no, identity,prepaym_adv_invoice, invoice_address_id
      FROM   customer_order_inv_head
      WHERE  company    = company_
      AND    invoice_id = order_no_;

   CURSOR get_order_details(co_no_ IN VARCHAR2) IS
      SELECT authorize_code, internal_po_no, customer_po_no, language_code, bill_addr_no
      FROM   customer_order_tab
      WHERE  order_no = co_no_;
   
   inv_rec_             get_invoice_details%ROWTYPE;
   co_rec_              get_order_details%ROWTYPE;
   customer_po_no_      VARCHAR2(50);
   customer_language_   VARCHAR2(2) := NULL;
BEGIN
   Client_SYS.Clear_Attr(report_attr_);
   Client_SYS.Add_To_Attr('REPORT_ID', report_id_,  report_attr_);
   Client_SYS.Add_To_Attr('LU_NAME', 'CustomerOrder',  report_attr_);

   Client_SYS.Clear_Attr(parameter_attr_);

   IF (report_id_ = 'CUSTOMER_ORDER_CONF_REP') OR (report_id_ = 'PROFORMA_INVOICE_REP') THEN
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, parameter_attr_);
      OPEN get_order_details(order_no_);
      FETCH get_order_details INTO co_rec_;
      IF (get_order_details%FOUND) THEN
         customer_po_no_ := NVL(co_rec_.internal_po_no, co_rec_.customer_po_no);
         our_reference_  := Order_Coordinator_API.Get_Name(co_rec_.authorize_code);
         bill_addr_no_   := co_rec_.bill_addr_no;
      END IF;
      CLOSE get_order_details;
   ELSE
      Client_SYS.Add_To_Attr('INVOICE_ID', order_no_, parameter_attr_);
      Client_SYS.Add_To_Attr('PRINT_OPTION', 'Original', parameter_attr_);
      company_ := Site_API.Get_Company(contract_);
      
      OPEN get_invoice_details;
      FETCH get_invoice_details INTO inv_rec_;            
      IF (get_invoice_details%FOUND) THEN
         our_reference_  := inv_rec_.our_reference;
         invoice_number_ := inv_rec_.series_id || inv_rec_.invoice_no;
         IF ((inv_rec_.order_no IS NOT NULL) AND (inv_rec_.rma_no IS NULL)) THEN
            OPEN get_order_details(inv_rec_.order_no);
            FETCH get_order_details INTO co_rec_;
            IF (get_order_details%FOUND) THEN
               IF (inv_rec_.prepaym_adv_invoice = 'TRUE') THEN
                  customer_po_no_ := co_rec_.customer_po_no;
               ELSE
                  customer_po_no_ := NVL(co_rec_.internal_po_no, co_rec_.customer_po_no);
               END IF;         
            END IF;
            CLOSE get_order_details;
         ELSE
            customer_language_ := Customer_Info_api.Get_Default_Language_Db(inv_rec_.identity);
         END IF;
         bill_addr_no_   := inv_rec_.invoice_address_id;
      END IF;
      CLOSE get_invoice_details; 
   END IF;
   -- Find the next execution date from the execution plan (if this is not done, the schedule will execute immediately)
   next_execution_date_ := Batch_SYS.Get_Next_Exec_Time__('ASAP', start_date_);
   schedule_name_       := Report_Definition_API.Get_Translated_Report_Title(report_id_);
   -- Create the new scheduled report.
   Batch_SYS.New_Batch_Schedule(schedule_id_,
                                next_execution_date_,
                                start_date_,
                                NULL,
                                schedule_name_,
                                'Archive_API.Create_And_Print_Report__',
                                'TRUE',
                                'ASAP',
                                NULL,
                                NULL,
                                report_id_);

   -- Add the id of the created scheduled task to report attribute string.
   Client_SYS.Set_Item_Value('SCHEDULE_ID', schedule_id_, report_attr_);
   Client_SYS.Set_Item_Value('LAYOUT_NAME', Report_Layout_Definition_API.Get_Default_Layout(report_id_), report_attr_);
   -- Add the language code for this session to the report attribute string if no language has been choosen
   Client_SYS.Set_Item_Value('LANG_CODE', Fnd_Session_API.Get_Language, report_attr_);
   Client_SYS.Set_Item_Value('ORDER_LANGUAGE', NVL(co_rec_.language_code, customer_language_) , report_attr_);

   -- Creating the message attr
   Client_SYS.Clear_Attr(message_attr_);
   Client_SYS.Add_To_Attr('MESSAGE_TYPE', 'NONE', message_attr_);

   -- Creating the pdf archiving attr
   Client_SYS.Clear_Attr(archiving_attr_);
   Client_SYS.Add_To_Attr('PDF_ARCHIVING', pdf_archiving_, archiving_attr_);

   IF contact_ IS NOT NULL THEN
      IF Comm_Method_API.Get_Default_Value('CUSTOMER', customer_no_,'E_MAIL', bill_addr_no_, NULL, contact_) IS NULL THEN
         temp_contact_ := Contact_Util_API.Get_Cust_Contact_Name(customer_no_, bill_addr_no_, contact_); 
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_1', email_, archiving_attr_);
   Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_2', customer_no_, archiving_attr_);
   Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_3', contract_, archiving_attr_);
   Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_4', contact_, archiving_attr_);
   Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_5', our_reference_, archiving_attr_);
   IF (report_id_ = 'CUSTOMER_ORDER_CONF_REP') OR (report_id_ = 'PROFORMA_INVOICE_REP') THEN
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_6', order_no_, archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_FILE_NAME', schedule_name_ || '_' || order_no_, archiving_attr_);    
   ELSE
      -- For Customer Invoice
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_6', invoice_number_, archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_FILE_NAME', schedule_name_ || '_' || invoice_number_, archiving_attr_);
   END IF;

   IF (customer_po_no_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_7', customer_po_no_, archiving_attr_);
   END IF;
   Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_8', NVL(temp_contact_, contact_), archiving_attr_);
   
   Client_SYS.Add_To_Attr('REPLY_TO_USER', Person_Info_API.Get_User_Id(co_rec_.authorize_code), archiving_attr_);

   -- Add the parameters
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'REPORT_ATTR', report_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'PARAMETER_ATTR', parameter_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'MESSAGE_ATTR', message_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'ARCHIVING_ATTR', archiving_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'DISTRIBUTION_LIST', fnd_user_|| field_separator_);

   -- Add a new entry to Customer Order History
   IF (report_id_ = 'CUSTOMER_ORDER_CONF_REP') THEN
      msg_ := Language_SYS.Translate_Constant(lu_name_, 'ORDCONFEMAIL: Order confirmation E-mailed to :P1', NULL, email_);
      Customer_Order_History_API.New(order_no_, msg_);
   ELSIF (report_id_ = 'PROFORMA_INVOICE_REP') THEN
      msg_ := Language_SYS.Translate_Constant(lu_name_, 'ORDPROFORMAEMAIL: Pro Forma Invoice E-mailed to :P1', NULL, email_);
      Customer_Order_History_API.New(order_no_, msg_);
   END IF;
   
   -- This mehtod call is to print the invoice specification whenever the invoice is printed.
   IF (report_id_ IN ('CUSTOMER_ORDER_IVC_REP', 'CUSTOMER_ORDER_COLL_IVC_REP')) THEN 
      Customer_Order_Inv_Head_API.Create_Invoice_Appendices(print_job_id_, order_no_, 1, contact_, contract_, invoice_number_, email_, customer_no_, our_reference_);
   END IF;
END Email_Order_Report__;


-- Print_Proforma_Invoice__
--   This method puts a Deferred Call to the method Do_Print_Proforma_Invoice__
--   to print the Customer Order Proforma Invoice.
PROCEDURE Print_Proforma_Invoice__ (
   delnote_no_ IN VARCHAR2 )
IS
   description_ VARCHAR2(2000);
BEGIN
   description_ := Language_SYS.Translate_Constant(lu_name_, 'PRINT_PROFORMA_IVC: Print Pro Forma Invoice for Delivery Note');
   Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Do_Print_Proforma_Invoice__', delnote_no_, description_);
END Print_Proforma_Invoice__;


-- Do_Print_Proforma_Invoice__
--   Print the proforma invoice for the specified delivery note.
PROCEDURE Do_Print_Proforma_Invoice__ (
   delnote_no_ IN VARCHAR2 )
IS
   parameter_attr_ VARCHAR2(2000);
   print_job_id_   NUMBER;
   result_         NUMBER;
BEGIN
   --Note: Create the report
   Client_SYS.Clear_Attr(parameter_attr_);
   Client_SYS.Add_To_Attr('DELNOTE_NO', delnote_no_, parameter_attr_);
   -- Create the print job
   Create_Print_Jobs(print_job_id_, result_, 'CUST_ORDER_PROFORMA_IVC_REP', parameter_attr_);
   Printing_Print_Jobs(print_job_id_);
END Do_Print_Proforma_Invoice__;


-- Get_Email_Address__
--   Returns the email address of the internal purchase order ref or the
--   customers email address if defined, for a specified order.
@UncheckedAccess
FUNCTION Get_Email_Address__ (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2  
IS
   order_rec_  CUSTOMER_ORDER_API.Public_Rec;  
   email_      VARCHAR2(200) := NULL;  
   purch_addr_ VARCHAR2(50);
BEGIN
   order_rec_ := Customer_Order_API.Get(order_no_);
   IF (order_rec_.rowstate NOT IN ('Blocked', 'Cancelled')) THEN   
      IF (order_rec_.internal_ref IS NOT NULL) THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            purch_addr_ := Purchase_Order_API.Get_Delivery_Address(order_rec_.internal_po_no);                                                                         
         $END
         email_ := Comm_Method_API.Get_Name_Value('COMPANY', Site_API.Get_Company(order_rec_.contract), 'E_MAIL', order_rec_.internal_ref, purch_addr_);  
      ELSE  
         email_ := Cust_Ord_Customer_Address_API.Get_Email(order_rec_.customer_no, order_rec_.cust_ref, order_rec_.bill_addr_no) ;         
      END IF;
   END IF;
   RETURN email_;
END Get_Email_Address__;   


-- Manual_Credit_Check__
--   This method return a question/information to the client based on the credit check.
PROCEDURE Manual_Credit_Check__(
   info_msg_     OUT VARCHAR2,
   msg_type_     OUT VARCHAR2,
   block_reason_ OUT VARCHAR2,
   order_no_     IN  VARCHAR2 )
IS 
   order_rec_          Customer_Order_API.Public_Rec;
   check_credit_       VARCHAR2(20) := 'FALSE';
   check_ext_customer_ VARCHAR2(20) := 'FALSE';
   ext_order_no_       VARCHAR2(20);
   prefix_             VARCHAR2(50);   
BEGIN
   block_reason_ := NULL;
   order_rec_    := Customer_Order_API.Get(order_no_);
   Check_Order_For_Credit_Check(check_credit_, check_ext_customer_, order_no_, 'MANUAL');
   
   IF (check_ext_customer_ = 'TRUE') THEN 
      Customer_Order_Line_API.Get_External_Cust_Order(ext_order_no_, order_no_);
      IF ext_order_no_ IS NOT NULL AND ext_order_no_ != order_no_ THEN
         Check_Order_For_Blocking___(block_reason_, check_credit_, 'MANUAL', ext_order_no_);
         prefix_ := Language_SYS.Translate_Constant(lu_name_, 'EXTERNAL: external', NULL);
         IF (block_reason_ IS NOT NULL) THEN
            order_rec_ := Customer_Order_API.Get(ext_order_no_);
         END IF;
      END IF;
   END IF;
   
   IF (block_reason_ IS NULL) THEN
      Check_Order_For_Blocking___(block_reason_, 'TRUE', 'MANUAL', order_no_);
      IF (Cust_Ord_Customer_API.Get_Category_Db(order_rec_.customer_no) = 'I') THEN
         prefix_ := Language_SYS.Translate_Constant(lu_name_, 'INTERNAL: internal', NULL);
      ELSE
         prefix_ := Language_SYS.Translate_Constant(lu_name_, 'EXTERNAL: external', NULL);
      END IF;         
   END IF;
   
   Create_Manual_Credit_Msg___(info_msg_, block_reason_, order_rec_.rowstate, prefix_, order_rec_.blocked_type);
   IF ((order_rec_.rowstate = 'Blocked' AND block_reason_ IS NULL) OR (order_rec_.rowstate = 'Blocked' AND block_reason_ = 'FALSE'))  THEN
      msg_type_ := 'QuestionBlockRelease';
   ELSIF ((order_rec_.rowstate IN ('Planned', 'Blocked')) OR (block_reason_ IS NULL) OR (block_reason_ = 'FALSE')) THEN
      msg_type_ := 'InfoMessage';
      Customer_Order_API.Log_Manual_Credit_Check_Hist__(order_no_, 'OK');
   ELSE
      msg_type_ := 'Question';
   END IF; 
END Manual_Credit_Check__;


-- Check_Order_Release_Allowed__
--   Return 'TRUE' if export license enabled for the RMA or customer order
--   flow for the specified  site.
FUNCTION Check_Order_Release_Allowed__ (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   flag_ VARCHAR2(5) := 'TRUE';
BEGIN
   IF (Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN
         DECLARE
            licensed_order_type_ VARCHAR2(25);
            CURSOR get_lines IS
               SELECT line_no, rel_no, line_item_no, demand_code, demand_order_ref1, demand_order_ref2, demand_order_ref3
               FROM   customer_order_line_tab
               WHERE  order_no = order_no_;
         BEGIN
            FOR line_rec_ IN get_lines LOOP
               BEGIN
                  licensed_order_type_ := Customer_Order_Line_API.Get_Expctr_License_Order_Type(line_rec_.demand_code, line_rec_.demand_order_ref1, line_rec_.demand_order_ref2, line_rec_.demand_order_ref3);
                  Exp_License_Connect_Util_API.Check_Order_Proceed_Allowed( order_no_, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no, licensed_order_type_);
               EXCEPTION
                  WHEN OTHERS THEN
                  flag_ := 'FALSE';
               END;
            END LOOP;
         END;
      $ELSE
         NULL;
      $END
   END IF;

   RETURN flag_;
END Check_Order_Release_Allowed__;


-- Proceed_After_Print_Conf__
--   After printing the Order Confirmation, execute the rest of the Customer Order Flow
--   from Reserve Order.
PROCEDURE Proceed_After_Print_Conf__ (
   order_no_ IN VARCHAR2 )
IS 
   attr_                 VARCHAR2(2000);
   customer_order_rec_   Customer_Order_API.Public_Rec;
BEGIN
   customer_order_rec_ := Customer_Order_API.Get(order_no_);
   IF (customer_order_rec_.rowstate = 'Released') THEN
      IF (Cust_Order_Type_Event_API.Get_Next_Event(customer_order_rec_.order_id, 40) IS NOT NULL) THEN
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('START_EVENT', 60,         attr_);
         Client_SYS.Add_To_Attr('ORDER_NO',    order_no_,  attr_);
         Client_SYS.Add_To_Attr('END',         '',         attr_);         
         Customer_Order_Flow_API.Start_Reserve_Order__(attr_);
      END IF;
   END IF;
END Proceed_After_Print_Conf__;


-- Prepare_Batch_Print__
--   Print or Send or Email or Print and Send customer order connected invoices
--   based on the selection in schedule window
PROCEDURE Prepare_Batch_Print__ (
   message_ IN VARCHAR2 )
IS
   TYPE print_job_rec IS REF CURSOR;
   print_rec_                print_job_rec;
   name_arr_                 Message_SYS.name_table;
   value_arr_                Message_SYS.line_table;
   count_                    NUMBER;
   stmt_                     VARCHAR2(32000);
   company_                  CUSTOMER_ORDER_INV_HEAD.company%TYPE;
   invoice_id_               CUSTOMER_ORDER_INV_HEAD.invoice_id%TYPE;
   order_id_                 CUSTOMER_ORDER_TAB.order_id%TYPE;
   customer_no_              CUSTOMER_ORDER_TAB.customer_no%TYPE;
   temp_customer_no_         CUSTOMER_ORDER_TAB.customer_no%TYPE;
   invoice_cust_no_          CUSTOMER_ORDER_TAB.customer_no%TYPE;
   temp_invoice_cust_no_     CUSTOMER_ORDER_TAB.customer_no%TYPE;
   temp_contract_            CUSTOMER_ORDER_TAB.contract%TYPE;
   your_reference_           CUSTOMER_ORDER_INV_HEAD.your_reference%TYPE;
   invoice_address_id_       CUSTOMER_ORDER_INV_HEAD.invoice_address_id%TYPE;
   contract_                 VARCHAR2(5);
   invoice_type_list_        VARCHAR2(32000);
   print_attr_               VARCHAR2(32000); 
   media_code_               VARCHAR2(30);
   printonly_                BOOLEAN:= FALSE;  
   sendonly_                 BOOLEAN:= FALSE;  
   printorsend_              BOOLEAN:= FALSE;  
   printandsend_             BOOLEAN:= FALSE;           
   email_                    BOOLEAN:= FALSE;
   email_address_            VARCHAR2(200);                 
   conobj_                   BOOLEAN:= FALSE;
   company_def_inv_type_rec_ Company_Def_Invoice_Type_API.Public_Rec;        
   string_null_              VARCHAR2(15):= Database_SYS.string_null_;
   invoice_date_             DATE;
   email_invoice_            VARCHAR2(5) := NULL;
   -- gelr:outgoing_fiscal_note, begin
   outgoing_fiscal_note_enabled_  company_localization_info_tab.parameter_value%TYPE; 
   -- gelr:outgoing_fiscal_note, end
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   company_ := Message_Sys.Find_Attribute(message_, 'COMPANY','');
   company_def_inv_type_rec_ := Company_Def_Invoice_Type_API.Get(company_);
   
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY') THEN
         NULL;
      ELSIF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := NVL(value_arr_(n_),'%');
      ELSIF (name_arr_(n_) = 'CUSTOMER_NO') THEN
         customer_no_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'INVOICE_CUSTOMER_NO') THEN
         invoice_cust_no_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'ORDER_ID') THEN
         order_id_ := NVL(value_arr_(n_),'%');
      ELSIF (name_arr_(n_) = 'INVOICE_DATE_OFFSET') THEN
         invoice_date_ := TRUNC(SYSDATE) +  NVL(Client_SYS.Attr_Value_To_Number(value_arr_(n_)),0);
      ELSIF (name_arr_(n_) = 'ADVANCED_CO_DEB') THEN
         IF (value_arr_(n_) = '1') THEN
            Add_Invoice_Type___(invoice_type_list_, company_def_inv_type_rec_.def_adv_co_dr_inv_type);
         END IF;   
      ELSIF (name_arr_(n_) = 'ADVANCED_CO_CRE') THEN
         IF (value_arr_(n_) = '1') THEN         
            Add_Invoice_Type___(invoice_type_list_, company_def_inv_type_rec_.def_adv_co_cr_inv_type);
         END IF;         
      ELSIF (name_arr_(n_) = 'PREPAYMENT_DEB') THEN
         IF (value_arr_(n_) = '1') THEN
            Add_Invoice_Type___(invoice_type_list_, company_def_inv_type_rec_.def_co_prepay_deb_inv_type);
         END IF;
      ELSIF (name_arr_(n_) = 'PREPAYMENT_CRE') THEN
         IF (value_arr_(n_) = '1') THEN
            Add_Invoice_Type___(invoice_type_list_, company_def_inv_type_rec_.def_co_prepay_cre_inv_type);
         END IF;
      ELSIF (name_arr_(n_) = 'CUSTORDCOR') THEN
         IF (value_arr_(n_) = '1') THEN
            Add_Invoice_Type___(invoice_type_list_, NVL(company_def_inv_type_rec_.def_co_cor_inv_type,'CUSTORDCOR'));
         END IF;
      ELSIF (name_arr_(n_) = 'CUSTCOLCOR') THEN         
         IF (value_arr_(n_) = '1') THEN
            Add_Invoice_Type___(invoice_type_list_, NVL(company_def_inv_type_rec_.def_col_cor_inv_type,'CUSTCOLCOR'));
         END IF;               
      ELSIF (name_arr_(n_) = 'REBATECRE') THEN
         IF (value_arr_(n_) = '1' AND contract_ = '%') THEN
            Add_Invoice_Type___(invoice_type_list_, company_def_inv_type_rec_.co_rebate_cre_inv_type);
         END IF; 
      ELSIF (name_arr_(n_) = 'CUSTORDDEB') THEN
         IF (value_arr_(n_) = '1') THEN
            Add_Invoice_Type___(invoice_type_list_, 'CUSTORDDEB');
         END IF;
      ELSIF (name_arr_(n_) = 'CUSTORDCRE') THEN
         IF (value_arr_(n_) = '1') THEN
            Add_Invoice_Type___(invoice_type_list_, 'CUSTORDCRE');
         END IF;                             
      ELSIF (name_arr_(n_) = 'SELFBILLDEB') THEN
         IF (value_arr_(n_) = '1') THEN
            Add_Invoice_Type___(invoice_type_list_, 'SELFBILLDEB');
         END IF;
      ELSIF (name_arr_(n_) = 'SELFBILLCRE') THEN
         IF (value_arr_(n_) = '1')  THEN
            Add_Invoice_Type___(invoice_type_list_, 'SELFBILLCRE');
         END IF;      
      ELSIF (name_arr_(n_) = 'CUSTCOLDEB') THEN
         IF (value_arr_(n_) = '1') THEN
            Add_Invoice_Type___(invoice_type_list_, 'CUSTCOLDEB');
         END IF;
      ELSIF (name_arr_(n_) = 'CUSTCOLCRE') THEN
         IF (value_arr_(n_) = '1') THEN
            Add_Invoice_Type___(invoice_type_list_, 'CUSTCOLCRE');
         END IF;               
      ELSIF (name_arr_(n_) = 'PRINTONLY') THEN
         IF (value_arr_(n_) = '1') THEN
            printonly_ := TRUE;  
         END IF;    
      ELSIF (name_arr_(n_) = 'SENDONLY') THEN
         IF (value_arr_(n_) = '1') THEN
            sendonly_ := TRUE;  
         END IF;    
      ELSIF (name_arr_(n_) = 'PRINTORSEND') THEN
         IF (value_arr_(n_) = '1') THEN
            printorsend_ := TRUE;  
         END IF;    
      ELSIF (name_arr_(n_) = 'PRINTANDSEND') THEN
         IF (value_arr_(n_) = '1') THEN
            printandsend_ := TRUE;  
         END IF;    
      ELSIF (name_arr_(n_) = 'EMAIL') THEN
         IF (value_arr_(n_) = '1') THEN
            email_ := TRUE;  
         END IF;
      ELSIF (name_arr_(n_) = 'CONNOBJ') THEN
         IF (value_arr_(n_) = '1') THEN
            conobj_ := TRUE;  
         END IF;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_arr_(n_), value_arr_(n_));
      END IF;
   END LOOP;  
   -- gelr:outgoing_fiscal_note, Added if confition to prevent print if outgoing fiscal note is enabled
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'OUTGOING_FISCAL_NOTE') = Fnd_Boolean_API.DB_FALSE) THEN
      IF (order_id_ = '%') THEN
         stmt_ := 'SELECT invoice_id, identity, your_reference, invoice_address_id, delivery_identity, contract
                FROM   customer_order_inv_head
                WHERE  company = :company
                AND    NVL(contract,''%'') LIKE :contract
                AND    invoice_type IN (''' || invoice_type_list_ ||''')
                AND    identity LIKE :invoice_cust_no
                AND    delivery_identity LIKE :customer_no
                AND    objstate = ''Preliminary''
                AND    invoice_date <= :invoice_date
                AND EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE SUBSTR(contract,1,5) = site OR SUBSTR(contract,1,5) IS NULL)';
         IF (invoice_cust_no_ = '%') THEN
            stmt_ := stmt_ || ' ORDER BY identity';
         END IF;
      ELSE
         stmt_ := 'SELECT ih.invoice_id, ih.identity, ih.your_reference, ih.invoice_address_id, ih.delivery_identity, ih.contract
                FROM   customer_order_inv_head ih, customer_order_tab co
                WHERE  ih.company = :company
                AND    NVL(ih.contract,''%'') LIKE :contract
                AND    ih.invoice_type IN (''' || invoice_type_list_ ||''')
                AND    ih.identity LIKE :invoice_cust_no
                AND    ih.delivery_identity LIKE :customer_no
                AND    co.order_id LIKE :order_id
                AND    co.order_no = NVL(ih.creators_reference, :string_null)
                AND    objstate = ''Preliminary''
                AND    invoice_date <= :invoice_date            
                AND EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE SUBSTR(ih.contract,1,5) = site OR SUBSTR(ih.contract,1,5) IS NULL)';
         IF (invoice_cust_no_ = '%') THEN
            stmt_ := stmt_ || ' ORDER BY identity';
         END IF;
      END IF;   

      IF (order_id_ = '%') THEN
         @ApproveDynamicStatement(2011-09-19,MaHplk)
         OPEN print_rec_ FOR stmt_ USING company_, contract_, invoice_cust_no_, customer_no_, invoice_date_;
      ELSE
         @ApproveDynamicStatement(2011-09-19,MaHplk)
         OPEN print_rec_ FOR stmt_ USING company_, contract_, invoice_cust_no_, customer_no_, order_id_, string_null_, invoice_date_;
      END IF;
      LOOP
         FETCH print_rec_ INTO invoice_id_, temp_invoice_cust_no_, your_reference_, invoice_address_id_, temp_customer_no_, temp_contract_;
         EXIT WHEN print_rec_%NOTFOUND;   

         Client_SYS.Clear_Attr(print_attr_);
         media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(NVL(temp_invoice_cust_no_, temp_customer_no_), 'INVOIC', company_);
         IF (printonly_) THEN 
            IF (media_code_ IS NULL) THEN
               Client_SYS.Add_To_Attr('START_EVENT', 510, print_attr_);
               Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, print_attr_);
               Client_SYS.Add_To_Attr('COMPANY', company_, print_attr_);
               Client_SYS.Add_To_Attr('END', '', print_attr_);
            END IF;
         ELSIF (sendonly_) THEN
            IF (media_code_ IS NOT NULL) THEN          
               Client_SYS.Add_To_Attr('START_EVENT', 510, print_attr_);
               Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, print_attr_); 
               Client_SYS.Add_To_Attr('COMPANY', company_, print_attr_);
               Client_SYS.Add_To_Attr('MEDIA_CODE', media_code_, print_attr_);
               Client_SYS.Add_To_Attr('SEND', 'TRUE', print_attr_);
               IF (conobj_ AND media_code_ = 'E-INVOICE') THEN
                  Client_SYS.Add_To_Attr('CONNECTED_OBJECTS', 'TRUE', print_attr_);
               END IF;   
               Client_SYS.Add_To_Attr('END', '', print_attr_);
            END IF;   
         ELSIF (printorsend_) THEN
            Client_SYS.Add_To_Attr('START_EVENT', 510, print_attr_);
            Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, print_attr_);
            Client_SYS.Add_To_Attr('COMPANY', company_, print_attr_);
            IF (media_code_ IS NOT NULL) THEN          
               Client_SYS.Add_To_Attr('MEDIA_CODE', media_code_, print_attr_);
               Client_SYS.Add_To_Attr('SEND', 'TRUE', print_attr_);
               IF (conobj_ AND media_code_ = 'E-INVOICE') THEN
                  Client_SYS.Add_To_Attr('CONNECTED_OBJECTS', 'TRUE', print_attr_);
               END IF;
            END IF;
            Client_SYS.Add_To_Attr('END', '', print_attr_);
         ELSIF (printandsend_) THEN
            IF (media_code_ IS NOT NULL) THEN          
               Client_SYS.Add_To_Attr('START_EVENT', 510, print_attr_);
               Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, print_attr_);            
               Client_SYS.Add_To_Attr('COMPANY', company_, print_attr_);
               Client_SYS.Add_To_Attr('MEDIA_CODE', media_code_, print_attr_);
               Client_SYS.Add_To_Attr('SEND', 'TRUE', print_attr_);
               Client_SYS.Add_To_Attr('SEND_AND_PRINT', 'TRUE', print_attr_);
               IF (conobj_ AND media_code_ = 'E-INVOICE') THEN
                  Client_SYS.Add_To_Attr('CONNECTED_OBJECTS', 'TRUE', print_attr_);
               END IF;
               Client_SYS.Add_To_Attr('END', '', print_attr_);
            END IF;      
         ELSIF (email_) THEN 
            -- Used customer no from print_rec_ to fetch the email.
            email_address_ := Cust_Ord_Customer_Address_API.Get_Email(NVL(temp_invoice_cust_no_, temp_customer_no_), your_reference_, invoice_address_id_);   
            email_invoice_ :=  Cust_Ord_Customer_API.Get_Email_Invoice_Db(NVL(temp_invoice_cust_no_, temp_customer_no_));
            IF (email_invoice_ = 'TRUE') THEN 
               IF (email_address_ IS NOT NULL AND media_code_ IS NULL) THEN
                  Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, print_attr_);
                  Client_SYS.Add_To_Attr('COMPANY', company_, print_attr_);
                  Client_SYS.Add_To_Attr('CUSTOMER_REF', your_reference_, print_attr_);
                  Client_SYS.Add_To_Attr('CONTRACT', temp_contract_, print_attr_);
                  Client_SYS.Add_To_Attr('EMAIL_ADDR', email_address_, print_attr_);
                  Client_SYS.Add_To_Attr('EMAIL', 'TRUE', print_attr_);
                  Client_SYS.Add_To_Attr('END', '', print_attr_);
               END IF;
            END IF;
         END IF;     
         IF (print_attr_ IS NOT NULL) THEN
            Start_Print_Invoice__(print_attr_); 
         END IF;
      END LOOP;
      CLOSE print_rec_;
   END IF;
END Prepare_Batch_Print__;

----------------------------------------------------------------------------
-- Create_Print_Pick_List_Hist__
-- To be called after printing the picklist. Write history to CO header
-- and CO line that Picklist was printed.
----------------------------------------------------------------------------
PROCEDURE Create_Print_Pick_List_Hist__ (
   pick_list_no_         IN VARCHAR2,
   consolidated_flag_db_ IN VARCHAR2 )
IS
   msg_      VARCHAR2(200);
   order_no_ VARCHAR2(12);

   CURSOR line_details IS
      SELECT DISTINCT line_no, rel_no, line_item_no
      FROM create_pick_list_join_new
      WHERE order_no = order_no_
      AND   pick_list_no = pick_list_no_;

  CURSOR get_con_orders IS
      SELECT order_no
      FROM consolidated_orders_tab
      WHERE pick_list_no = pick_list_no_;
BEGIN
   msg_ := Language_SYS.Translate_Constant(lu_name_, 'PICKPRINT: Picklist :P1 printed', NULL, pick_list_no_);
   IF consolidated_flag_db_ = 'CONSOLIDATED' THEN
      FOR ord_ IN get_con_orders LOOP
         IF (NVL(order_no_, Database_Sys.string_null_) != ord_.order_no) THEN
            Customer_Order_History_API.New(ord_.order_no, msg_);
         END IF;
         order_no_ := ord_.order_no;
         FOR linerec_ IN line_details LOOP
             --Add a new record in Customer Order Line History
             Customer_Order_Line_Hist_API.New(order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, msg_);
         END LOOP;
      END LOOP;
   ELSE
      order_no_ := Customer_Order_Pick_List_API.Get_Order_No(pick_list_no_);
      Customer_Order_History_API.New(order_no_, msg_);
      
      FOR linerec_ IN line_details LOOP
         --Add a new record in Customer Order Line History
         msg_ := Language_SYS.Translate_Constant(lu_name_, 'PICKPRINT: Picklist :P1 printed', NULL, pick_list_no_);
         Customer_Order_Line_Hist_API.New(order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, msg_);
      END LOOP;
   END IF;
END Create_Print_Pick_List_Hist__;

----------------------------------------------------------------------------
-- Proceed_After_Print_Del_Note__
-- After printing the Delivery Note, execute the rest of the Customer Order Flow
-- from  Create Invoice.
----------------------------------------------------------------------------
PROCEDURE Proceed_After_Print_Del_Note__ (
   order_no_           IN VARCHAR2,
   delnote_no_         IN VARCHAR2,
   old_del_note_state_ IN VARCHAR2 DEFAULT NULL)
IS 
   attr_               VARCHAR2(2000);
   del_note_state_     VARCHAR2(20);
   customer_order_rec_ Customer_Order_API.Public_Rec;
   $IF (Component_Wo_SYS.INSTALLED) AND (Component_Purch_SYS.INSTALLED) $THEN
   work_order_no_      NUMBER;
   purchase_order_no_  VARCHAR2(12);
   nopart_lines_exist_ NUMBER;
   parameter_attr_     VARCHAR2(2000);
   print_job_id_       NUMBER;
   result_             NUMBER;   
   
   CURSOR get_mro_lines IS
      SELECT col.demand_order_ref1
      FROM customer_order_line_tab col, customer_order_delivery_tab cod
      WHERE cod.order_no = order_no_
      AND col.order_no = cod.order_no
      AND col.line_no = cod.line_no
      AND col.rel_no = cod.rel_no
      AND col.line_item_no = cod.line_item_no
      AND col.supply_code = 'MRO'
      AND cod.cancelled_delivery = 'FALSE';
   $END
BEGIN
   
   del_note_state_ := Delivery_Note_API.Get_Objstate(delnote_no_);
   customer_order_rec_ := Customer_Order_API.Get(order_no_);
   -- gelr:modify_date_applied, begin
   IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(customer_order_rec_.contract, 'MODIFY_DATE_APPLIED') = Fnd_Boolean_API.DB_TRUE) THEN
      IF (del_note_state_ = 'Printed') AND (old_del_note_state_ = 'Created') THEN
         Customer_Order_Delivery_API.Modify_Date_Applied(customer_order_rec_.contract,order_no_,'CUSTOMER_ORDER', delnote_no_);
      END IF;   
   END IF;
   -- gelr:modify_date_applied, end
   -- gelr:warehouse_journal, begin
   IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(customer_order_rec_.contract, 'WAREHOUSE_JOURNAL') = Fnd_Boolean_API.DB_TRUE) THEN
     IF (del_note_state_ = 'Printed') AND (old_del_note_state_ = 'Created') THEN
         Customer_Order_Delivery_API.Modify_Delivery_Info(customer_order_rec_.contract,order_no_,'CUSTOMER_ORDER', delnote_no_);
     END IF;   
   END IF;
   -- gelr:warehouse_journal, end
   IF (del_note_state_ = 'Printed') THEN
      
      $IF (Component_Wo_SYS.INSTALLED) AND (Component_Purch_SYS.INSTALLED) $THEN
         -- Note: Get MRO order lines for Miscellaneous Part Report.
         FOR mro_line_ IN get_mro_lines LOOP
            work_order_no_      := TO_NUMBER(mro_line_.demand_order_ref1);
            purchase_order_no_  := Active_Work_Order_API.Get_Receive_Order_No(work_order_no_);
            nopart_lines_exist_ := Purchase_Order_API.Check_Nopart_Lines_Exist(purchase_order_no_);           
   
            IF nopart_lines_exist_ != 0 THEN
               -- Note: Create the Delivery Note Appendix report
               Client_SYS.Clear_Attr(parameter_attr_);
               Client_SYS.Add_To_Attr('ORDER_NO', purchase_order_no_, parameter_attr_);
               Client_SYS.Add_To_Attr('REPORT_TYPE', 'DELIV NOTE', parameter_attr_);
               -- Create one print job for appendix report and attach print job instances to same print job if multiple MRO lines exist 
               result_ := NULL;
               Create_Print_Jobs(print_job_id_, result_, 'PURCH_MISCELLANEOUS_PART_REP', parameter_attr_);
            END IF;
         END LOOP;
         
         IF print_job_id_ IS NOT NULL THEN
            Printing_Print_Jobs(print_job_id_);
         END IF;
      $END
      
      IF (customer_order_rec_.rowstate = 'Delivered') THEN
         IF (Cust_Order_Type_Event_API.Get_Next_Event(customer_order_rec_.order_id, 110) IS NOT NULL) THEN
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('START_EVENT', 500,        attr_);
            Client_SYS.Add_To_Attr('ORDER_NO',    order_no_,  attr_);
            Client_SYS.Add_To_Attr('END',         '',         attr_);

            Customer_Order_Flow_API.Start_Create_Invoice__(attr_);
         END IF;
      END IF;
   END IF;
   
END Proceed_After_Print_Del_Note__;


FUNCTION Raise_Report_Picking_Msg___ RETURN VARCHAR2
IS
BEGIN
   RETURN Language_SYS.Translate_Constant(lu_name_, 'FROM_REPORT_PICKING: Report Picking for Customer Order');
END Raise_Report_Picking_Msg___;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Calculate_Credit_Used
--   Calculate the amount of credit used by the specified customer on orders
--   not yet invoiced. Called from Payment when executing the credit check.
--   Calculate the credit used on noninvoiced orders by the specified customer in the specified company. If an order number is passed in this order will be excluded from the calculation.
@UncheckedAccess
FUNCTION Calculate_Credit_Used (
   company_     IN VARCHAR2,
   customer_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   non_inv_orders_ NUMBER := 0;
BEGIN
   non_inv_orders_ := Calculate_Credit_Used___(company_, customer_no_) +
                         Calc_Charge_Credit_Used___(company_, customer_no_);
   RETURN non_inv_orders_;
END Calculate_Credit_Used;


-- Proceed_After_Credit_Block
--   Should be called when a credit blocked order has been released.
--   Will create connected orders if not already created.
PROCEDURE Proceed_After_Credit_Block (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   -- Create connected orders where needed
   Connect_Customer_Order_API.Generate_Connected_Orders(order_no_);
END Proceed_After_Credit_Block;


-- Release_Order
--   Public interface for releasing a customer order.
--   Used from Purchasing when creating customer order lines for purchase
--   order lines. May also be used from other modules after automatic
--   creation of order and order lines.
--   Release will be done as a background process.
PROCEDURE Release_Order (
   order_no_                  IN VARCHAR2,
   process_in_background_     IN VARCHAR2 DEFAULT 'FALSE',
   created_from_quick_co_reg_ IN VARCHAR2 DEFAULT 'FALSE')
IS
   attr_ VARCHAR2(200);
BEGIN
   Client_SYS.Add_To_Attr('START_EVENT', 20, attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('PROCESS_IN_BACKGROUND', process_in_background_, attr_);
   Client_SYS.Add_To_Attr('CREATED_FROM_QUICK_CO_REG', created_from_quick_co_reg_, attr_);
   Client_SYS.Add_To_Attr('END', '', attr_);
   Process_All_Orders___(attr_);
END Release_Order;


-- Credit_Check
--   Execute credit check for an order.
--   If the Payment module is installed a complete credit check should be made
--   in Payment. If Payment is not available the only check made is to see
--   if the customer is credit blocked.
PROCEDURE Credit_Check (
   credit_block_reason_ IN OUT VARCHAR2,
   order_no_            IN     VARCHAR2 )
IS
   order_rec_            Customer_Order_API.Public_Rec;
   customer_no_          CUSTOMER_ORDER.customer_no%TYPE;
   contract_             CUSTOMER_ORDER.contract%TYPE;
   exclude_credit_limit_ VARCHAR2(20);   
   company_              VARCHAR2(20);
   order_total_          NUMBER;
   other_orders_total_   NUMBER;
   open_order_value_     NUMBER;
   credit_limit_         NUMBER;
   credit_block_         VARCHAR2(20);   
   allowed_od_amt_       NUMBER := NULL;
   acquisition_site_     CUSTOMER_ORDER.contract%TYPE;
   acquisition_company_  VARCHAR2(20);
   prepaym_gross_amt_    NUMBER;
   consumed_line_amt_    NUMBER;
   rounding_             NUMBER;
   prepaym_other_ord_amt_ NUMBER;
   currency_rate_        NUMBER;
   curr_type_            VARCHAR2(10);
   conv_factor_          NUMBER;
BEGIN
   order_rec_            := Customer_Order_API.Get(order_no_);
   customer_no_          := nvl(order_rec_.customer_no_pay, order_rec_.customer_no);
   contract_             := order_rec_.contract;
   company_              := Site_API.Get_Company(contract_);
   exclude_credit_limit_ := Payment_Term_API.Get_Exclude_Credit_Limit(company_, order_rec_.pay_term_id);
   acquisition_site_     := Cust_Ord_Customer_API.Get_Acquisition_Site(customer_no_);
   acquisition_company_  := Site_API.Get_Company(acquisition_site_);
   Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, conv_factor_, currency_rate_, company_, order_rec_.currency_code,
                                                     order_rec_.date_entered, 'CUSTOMER', customer_no_);
   currency_rate_        := currency_rate_ / conv_factor_;
   rounding_             := Currency_Code_API.Get_Currency_Rounding(company_, order_rec_.currency_code);
   IF ((company_ != acquisition_company_) OR (acquisition_site_ IS NULL)) THEN 
      -- Check if the ordering customer is credit blocked
      -- if that is the case order is credit blocked
      -- Passed order customer to check the customer is blocked.
      IF (Cust_Ord_Customer_API.Customer_Is_Credit_Stopped(order_rec_.customer_no, company_) = 1) THEN
         credit_block_reason_ := 'BLKFORCRE';
      ELSE
         $IF (Component_Payled_SYS.INSTALLED) $THEN
            -- No need to sum credit for customer if credit limit not used for customer!!!
               Customer_Credit_Info_API.Fetch_Credit_Info(credit_limit_, credit_block_, allowed_od_amt_, company_, customer_no_);         
            IF (credit_block_ = 'TRUE') THEN
               credit_block_reason_ := 'BLKFORCRE';
            ELSIF ((credit_limit_ IS NOT NULL OR allowed_od_amt_ IS NOT NULL) AND (exclude_credit_limit_ = 'FALSE')) THEN
               consumed_line_amt_   := ROUND( Invoice_Customer_Order_API.Get_Consumed_Line_Amt__(order_no_) * currency_rate_, rounding_);
               prepaym_gross_amt_   := ROUND( Invoice_Customer_Order_API.Get_Prepaym_Based_Gross_Amt__(company_, order_no_) * currency_rate_, rounding_) - consumed_line_amt_;
               -- The credit check should be executed in Payment
               -- Calculate the total uninvoiced order value for the current order
               order_total_         := Get_Uninvoiced_Order_Value___(company_, order_no_) - prepaym_gross_amt_;
               Trace_SYS.Field('credit control: order_total_ ', order_total_);
               -- Calculate the total uninvoiced charge value for the current order
               order_total_         := order_total_ + Get_Uninvoiced_Charge_Value___(company_, order_no_);
               Trace_SYS.Field('credit control: order_total_ with charges ', order_total_);

               -- Get the total order value for other orders not yet invoiced
               other_orders_total_  := Calculate_Credit_Used___(company_, customer_no_, order_no_);
               Trace_SYS.Field('credit control: other_orders_total_ ', other_orders_total_);
               -- Get the total charge value for other orders not yet invoiced
               other_orders_total_  := other_orders_total_ + Calc_Charge_Credit_Used___(company_, customer_no_, order_no_);
               Trace_SYS.Field('credit control: other_orders_total_ with charges ', other_orders_total_);

               prepaym_other_ord_amt_ := ROUND( Invoice_Customer_Order_API.Get_Prepaym_Based_Other_Amt__(company_, order_no_, customer_no_) * currency_rate_, rounding_);
               open_order_value_    := other_orders_total_ - prepaym_other_ord_amt_;
               credit_block_reason_ := Cust_Credit_Info_Util_API.Customer_Order_Check_Credit(company_, customer_no_, order_no_, order_total_, open_order_value_ ); 
            END IF;
         $ELSE
            NULL;
         $END
      END IF;
   END IF;
END Credit_Check;


-- Deliver_Line_Allowed
--   Checks if an order line is allowed to be delivered
@UncheckedAccess
FUNCTION Deliver_Line_Allowed (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   allowed_    NUMBER := 0;
   line_found_ NUMBER := 0;
   order_rec_  Customer_Order_API.Public_Rec;

   CURSOR get_line IS
      SELECT 1
        FROM CUSTOMER_ORDER_LINE_TAB
       WHERE order_no               = order_no_
         AND line_no                = line_no_
         AND rel_no                 = rel_no_
         AND line_item_no           = line_item_no_
         AND shipment_connected     = 'FALSE'
         AND rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
         AND (qty_picked > 0 OR (supply_code != 'PD' AND qty_to_ship > 0));

   CURSOR get_pkg_line IS
      SELECT line_item_no
        FROM CUSTOMER_ORDER_LINE_TAB
       WHERE order_no               = order_no_
         AND line_no                = line_no_
         AND rel_no                 = rel_no_
         AND shipment_connected     = 'FALSE'
         AND rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
         AND (qty_picked > 0 OR (supply_code != 'PD' AND qty_to_ship > 0)); 
BEGIN
   order_rec_       := Customer_Order_API.Get(order_no_);   
   IF (order_rec_.use_pre_ship_del_note = 'TRUE') THEN
      allowed_ := Allow_Non_Inv_Delivery___ (order_no_, line_no_, rel_no_, line_item_no_); 
   ELSE
      IF (order_rec_.rowstate NOT IN ('Planned', 'Blocked')) THEN
         IF line_item_no_ = -1 THEN
            FOR line_rec_ IN get_pkg_line LOOP
               IF Cust_Order_Load_List_API.Get_Load_Id(order_no_, line_no_, rel_no_, line_rec_.line_item_no) IS NULL THEN
                  allowed_ := 1;
                  -- when allowed has been set, we don't need to find other order lines - exit loop
                  EXIT;
               END IF;
            END LOOP;
         ELSE
            OPEN get_line;
            FETCH get_line INTO line_found_;
            IF (get_line %FOUND) THEN
               IF Cust_Order_Load_List_API.Get_Load_Id(order_no_, line_no_, rel_no_, line_item_no_) IS NULL THEN
                  allowed_ := 1;
               END IF;
            END IF;
            CLOSE get_line;
         END IF;
      END IF;
   END IF;
   RETURN allowed_;
END Deliver_Line_Allowed;


PROCEDURE Validate_Struc_Ownership(
   info_           OUT VARCHAR2,
   order_no_       IN  VARCHAR2,
   part_no_        IN  VARCHAR2,
   serial_no_      IN  VARCHAR2,
   lot_batch_no_   IN  VARCHAR2,
   part_ownership_ IN  VARCHAR2,
   part_owner_     IN  VARCHAR2)
IS
   part_ownership_db_         VARCHAR2(20);
   owning_customer_no_        CUSTOMER_ORDER_LINE_TAB.owning_customer_no%TYPE := NULL;
   owning_vendor_no_          CUSTOMER_ORDER_LINE_TAB.vendor_no%TYPE := NULL;
   has_single_ownership_      VARCHAR2(10) := 'TRUE';
   contains_company_owned_    VARCHAR2(10) := 'FALSE';
   contains_supplier_loaned_  VARCHAR2(10) := 'FALSE';
   contains_customer_owned_   VARCHAR2(10) := 'FALSE';
   owning_vendor_no_list_     VARCHAR2(32000);
   owning_customer_no_list_   VARCHAR2(32000);
   order_customer_no_         CUSTOMER_ORDER_TAB.customer_no%TYPE;
   delim_                     CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;
   part_serial_               VARCHAR2(50);
   customer_count_            NUMBER;
   vendor_count_              NUMBER;
   contains_line_customer_    BOOLEAN := FALSE;
   contains_header_customer_  BOOLEAN := FALSE;
   contains_line_vendor_      BOOLEAN := FALSE;
   do_check_                  BOOLEAN := TRUE;
   do_warn_                   BOOLEAN := FALSE;
   cs_vendor_no_list_         VARCHAR2(32000) := NULL;
   cs_customer_no_list_       VARCHAR2(32000) := NULL;
   part_serial_ownership_db_  VARCHAR2(20);
BEGIN
   Client_SYS.Clear_Attr(info_);

   part_ownership_db_ := Part_Ownership_API.Encode(part_ownership_);

   IF (part_ownership_db_ = Part_Ownership_API.DB_CUSTOMER_OWNED) THEN
      owning_customer_no_ := part_owner_;
   ELSIF part_ownership_db_ = Part_Ownership_API.DB_SUPPLIER_LOANED THEN
      owning_vendor_no_ := part_owner_;
   END IF;

   order_customer_no_ := Customer_Order_API.Get_Customer_No(order_no_);

   IF serial_no_ != '*' THEN
      part_serial_ownership_db_ := Part_Ownership_API.Encode(Part_Serial_Catalog_API.Get_Part_Ownership (part_no_, serial_no_));
      IF (part_serial_ownership_db_ =  Part_Ownership_API.DB_CONSIGNMENT AND part_ownership_db_ = Part_Ownership_API.DB_COMPANY_OWNED) THEN
         part_ownership_db_ := part_serial_ownership_db_;
      END IF;

      Part_Serial_Catalog_API.Get_Structure_Ownership(has_single_ownership_,
                                                      contains_company_owned_,
                                                      contains_supplier_loaned_,
                                                      contains_customer_owned_,
                                                      owning_vendor_no_list_,
                                                      owning_customer_no_list_,
                                                      part_no_,
                                                      serial_no_,
                                                      part_ownership_db_,
                                                      owning_vendor_no_,
                                                      owning_customer_no_);
   ELSIF lot_batch_no_ != '*' THEN
      Lot_Batch_Master_API.Get_Structure_Ownership(has_single_ownership_,
                                                      contains_company_owned_,
                                                      contains_supplier_loaned_,
                                                      contains_customer_owned_,
                                                      owning_vendor_no_list_,
                                                      owning_customer_no_list_,
                                                      part_no_,
                                                      lot_batch_no_,
                                                      part_ownership_db_,
                                                      owning_vendor_no_,
                                                      owning_customer_no_);
   ELSE
      do_check_ := FALSE;
   END IF;

   IF (do_check_) THEN
      IF owning_vendor_no_list_ IS NOT NULL THEN
         --check if vendor list contains CO line part owner
         IF (INSTR(owning_vendor_no_list_, delim_ || owning_vendor_no_ || delim_) > 0 ) THEN
            contains_line_vendor_ := TRUE;
         END IF;
         --remove starting and ending delimiters
         owning_vendor_no_list_ := SUBSTR(owning_vendor_no_list_, 2, LENGTH(owning_vendor_no_list_)-2);
         -- Count vendors
         vendor_count_ := 1;
         WHILE (INSTR(owning_vendor_no_list_, delim_, 1, vendor_count_) > 0) LOOP
            vendor_count_ := vendor_count_ + 1;
         END LOOP;

         --prepare comma seperated list
         cs_vendor_no_list_ := REPLACE(owning_vendor_no_list_, delim_, ', ');
      ELSE
         vendor_count_ := 0;
      END IF;

      IF owning_customer_no_list_ IS NOT NULL THEN
         --check if customer list contains CO line part owner
         IF (INSTR(owning_customer_no_list_, delim_ || owning_customer_no_ || delim_) > 0 ) THEN
            contains_line_customer_ := TRUE;
         END IF;

         --check if customer list contains CO customer
         IF (INSTR(owning_customer_no_list_, delim_ || order_customer_no_ || delim_) > 0 ) THEN
            contains_header_customer_ := TRUE;
         END IF;

         --remove starting and ending delimiters
         owning_customer_no_list_ := SUBSTR(owning_customer_no_list_, 2, LENGTH(owning_customer_no_list_)-2);
         --count customers
         customer_count_          := 1;
         WHILE (INSTR(owning_customer_no_list_, delim_, 1, customer_count_) > 0) LOOP
            customer_count_ := customer_count_ + 1;
         END LOOP;

         cs_customer_no_list_ := REPLACE(owning_customer_no_list_, delim_, ', ');
      ELSE
         customer_count_ := 0;
      END IF;

      IF part_ownership_db_ = Part_Ownership_API.DB_CUSTOMER_OWNED THEN
         IF (has_single_ownership_ = 'FALSE') THEN
            IF (contains_supplier_loaned_ = 'FALSE') THEN
               IF ((customer_count_ = 1) AND (NOT contains_line_customer_))
                   OR (customer_count_ > 1) THEN
                  do_warn_ := TRUE;
               END IF;
            ELSE
               do_warn_ := TRUE;
            END IF;
         END IF;
      ELSIF part_ownership_db_ = Part_Ownership_API.DB_COMPANY_OWNED THEN
         IF (has_single_ownership_ = 'FALSE') THEN
            IF (contains_supplier_loaned_ = 'FALSE') THEN
               IF ((customer_count_ = 1) AND (NOT contains_header_customer_))
                   OR (customer_count_ > 1) THEN
                  do_warn_ := TRUE;
               END IF;
            ELSE
               do_warn_ := TRUE;
            END IF;
         END IF;
      ELSIF part_ownership_db_ = Part_Ownership_API.DB_SUPPLIER_LOANED THEN
         IF (has_single_ownership_ = 'FALSE') THEN
            IF (contains_customer_owned_ = 'FALSE') THEN
               IF ((vendor_count_ = 1) AND (NOT contains_line_vendor_))
                   OR (customer_count_ > 1) THEN
                  do_warn_ := TRUE;
               END IF;
            ELSE
               do_warn_ := TRUE;
            END IF;
         END IF;
      END IF;
   END IF;

   IF (do_warn_) THEN
      Client_SYS.Clear_Info;

      part_serial_ := part_no_ || '/' || serial_no_;

      IF (cs_vendor_no_list_ IS NULL) THEN
         Client_SYS.Add_Warning(lu_name_, 'HASCUSOWNED: The Part/Serial No :P1 item contains customer owned components which are owned by customer(s) :P2 . Do you want to continue with transaction?', part_serial_, cs_customer_no_list_);
      ELSIF (cs_customer_no_list_ IS NULL) THEN
         Client_SYS.Add_Warning(lu_name_, 'HASSUPPLOANED: The Part/Serial No :P1 item contains supplier loaned components which are owned by supplier(s) :P2 . Do you want to continue with transaction?', part_serial_, cs_vendor_no_list_);
      ELSE
         Client_SYS.Add_Warning(lu_name_, 'HASCUSSUPPOWNED: The Part/Serial No :P1 item contains customer owned components which are owned by customer(s) :P2 , and supplier loaned components which are owned by supplier(s) :P3 . Do you want to continue with transaction?', part_serial_, cs_customer_no_list_, cs_vendor_no_list_);
      END IF;

      info_ := Client_SYS.Get_All_Info;
   END IF;
END Validate_Struc_Ownership;


-- Release_Source_Line
--   Public interface for releasing a remaining source line with supply code
--   'Not Decided' when order is released.
--   This procedure is used to call the private procedure with a deferred call to release remaining fully sourced CO lines, when the order header is in Released state.
PROCEDURE Release_Source_Line (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   attr_        VARCHAR2(2000);
   description_ VARCHAR2(200);
BEGIN
   attr_ := NULL;
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);

   description_ := Language_SYS.Translate_Constant(lu_name_, 'RELEASE_SOURCED_LINE: Release Sourced Customer Order Line');
   Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Release_Source_Line__', attr_, description_);
END Release_Source_Line;


-- Process_From_Release_Order
--   Public method to call private method ProcessFromReleaseOrder from outside the module.
PROCEDURE Process_From_Release_Order (
   order_no_ IN VARCHAR2 )
IS
   order_attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(order_attr_);
   Client_SYS.Add_To_Attr('START_EVENT', 20, order_attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, order_attr_);
   Client_SYS.Add_To_Attr('END', '', order_attr_);

   Process_From_Release_Order__(order_attr_);
END Process_From_Release_Order;


-- Close_Allowed
--   Return and sign plus TRUE (1) if the Close operation is allowed for the specified  order.
@UncheckedAccess
FUNCTION Close_Allowed (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Close_Allowed__(order_no_);
END Close_Allowed;


-- Reserve_Order_Line_Allowed
--   Return and sign plus TRUE (1) if the Plan Picking operation is allowed for the specified order line.
@UncheckedAccess
FUNCTION Reserve_Order_Line_Allowed (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;
   
   CURSOR reserve_allowed IS
      SELECT 1
        FROM customer_order_line_tab col
       WHERE col.order_no     = order_no_
         AND col.line_no      = line_no_
         AND col.rel_no       = rel_no_
         AND col.line_item_no = line_item_no_
         AND col.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')         
         AND (col.revised_qty_due - col.qty_assigned - col.qty_to_ship - col.qty_on_order - col.qty_shipped + col.qty_shipdiff) > 0
         AND (supply_code IN ('IO', 'NO', 'PI', 'PJD', 'PRJ', 'PS','SEO'));

   CURSOR reserve_pkg_allowed IS
      SELECT 1
        FROM customer_order_line_tab col
       WHERE col.order_no     = order_no_
         AND col.line_no      = line_no_
         AND col.rel_no       = rel_no_
         AND col.line_item_no > 0
         AND col.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
          AND (col.revised_qty_due - col.qty_assigned - col.qty_to_ship - col.qty_on_order - col.qty_shipped + col.qty_shipdiff) > 0
         AND supply_code IN ('IO', 'NO','SEO', 'PI', 'PJD', 'PRJ', 'PS');
BEGIN
   --Credit blocked status can be considered here by fetching the customer order header status
   --since it the line IS being considered
   IF (Customer_Order_API.Get_Objstate(order_no_) = 'Blocked') THEN
       RETURN 0;
   END IF;
   IF line_item_no_ = -1 THEN
      OPEN reserve_pkg_allowed;
      FETCH reserve_pkg_allowed INTO allowed_;
      IF (reserve_pkg_allowed %NOTFOUND) THEN
         allowed_ := 0;
      END IF;
      CLOSE reserve_pkg_allowed;
   ELSE
      OPEN reserve_allowed;
      FETCH reserve_allowed INTO allowed_;
      IF (reserve_allowed %NOTFOUND) THEN
         allowed_ := 0;
      END IF;
      CLOSE reserve_allowed;
   END IF;
   RETURN allowed_;
END Reserve_Order_Line_Allowed;


-- Create_Pick_List_Line_Allowed
--   Return and sign plus TRUE (1) if the Create Pick List operation is allowed for the specified order line.
@UncheckedAccess
FUNCTION Create_Pick_List_Line_Allowed (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   allowed_   NUMBER;
   line_rec_  Customer_Order_Line_API.Public_Rec;

   CURSOR cre_pick_allowed IS
      SELECT 1
        FROM customer_order_reservation_tab cor
       WHERE cor.order_no     = order_no_
         AND cor.line_no      = line_no_
         AND cor.rel_no       = rel_no_
         AND cor.line_item_no = line_item_no_
         AND cor.pick_list_no || '' = '*';
BEGIN
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   -- If the line is connected to a shipment report picking will have to be done from the shipment
   IF (line_rec_.shipment_connected = 'TRUE') THEN
      allowed_ := 0;
   ELSE
      OPEN cre_pick_allowed ;
      FETCH cre_pick_allowed  INTO allowed_;
      IF (cre_pick_allowed %NOTFOUND) THEN
         allowed_ := 0;
      END IF;
      CLOSE cre_pick_allowed ;
   END IF;
   RETURN allowed_;
END Create_Pick_List_Line_Allowed;



-- Report_Picking_Of_Line_Allowed
--   Return and sign plus TRUE (1) if the Report Picking operation is allowed for the specified order line.
@UncheckedAccess
FUNCTION Report_Picking_Of_Line_Allowed (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;
   -- Report picking is allowed if qty_assigned > qty_picked and a nonreported
   -- nonconsolidated pick list exists to the connected order line
   CURSOR report_picking_allowed IS
      SELECT 1
        FROM CUSTOMER_ORDER_RESERVATION_TAB cor
       WHERE order_no     = order_no_
         AND line_no      = line_no_
         AND rel_no       = rel_no_
         AND line_item_no = line_item_no_
         AND qty_assigned > qty_picked
         AND pick_list_no != '*'
         AND EXISTS (SELECT 1
                       FROM  CUSTOMER_ORDER_PICK_LIST_TAB
                      WHERE  pick_list_no      = cor.pick_list_no
                        AND  picking_confirmed = 'UNPICKED'
                        AND  consolidated_flag = 'NOT CONSOLIDATED');
BEGIN
   OPEN report_picking_allowed;
   FETCH report_picking_allowed INTO allowed_;
   IF (report_picking_allowed%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE report_picking_allowed;
   RETURN allowed_;
END Report_Picking_Of_Line_Allowed;



-- Create_Del_Note_Line_Allowed
--   Return and sign plus TRUE (1) if the Create Delivery Note operation is allowed for the specified order line.
@UncheckedAccess
FUNCTION Create_Del_Note_Line_Allowed (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;

   CURSOR create_delnote_allowed IS
      SELECT 1
       FROM customer_order_delivery_tab cod, customer_order_line_tab col
      WHERE col.order_no     = order_no_
        AND col.line_no      = line_no_
        AND col.rel_no       = rel_no_
        AND col.line_item_no = line_item_no_
        AND col.order_no     = cod.order_no
        AND col.line_no      = cod.line_no
        AND col.rel_no       = cod.rel_no
        AND col.line_item_no = cod.line_item_no
        AND col.supply_code NOT IN('PD', 'IPD')
        AND cod.delnote_no IS NULL
        AND cod.cancelled_delivery = 'FALSE';
BEGIN
   OPEN create_delnote_allowed ;
   FETCH create_delnote_allowed  INTO allowed_;
   IF (create_delnote_allowed %NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE create_delnote_allowed ;
   RETURN allowed_;
END Create_Del_Note_Line_Allowed;



-- Start_Create_Pick_List
--   Create pick list for all orders enumerated in the attribute string.
PROCEDURE Start_Create_Pick_List (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Start_Create_Pick_List__(attr_);
END Start_Create_Pick_List;


-- Start_Create_Delivery_Note
--   Create delivery note for all orders enumerated in the attribute string.
PROCEDURE Start_Create_Delivery_Note (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Start_Create_Delivery_Note__(attr_);
END Start_Create_Delivery_Note;


-- Credit_Check_Order
--   CO and connected external CO will credit check and if there is a credit block reason,
--   it will get credit blocked.
PROCEDURE Credit_Check_Order (
   order_no_       IN  VARCHAR2,
   checking_state_ IN  VARCHAR2 )
IS
   objstate_                CUSTOMER_ORDER_TAB.rowstate%TYPE;
   check_credit_            VARCHAR2(20) := 'FALSE';
   check_credit_ext_cust_   VARCHAR2(20) := 'FALSE';
   check_ext_customer_      VARCHAR2(20) := 'FALSE';
   ext_order_no_            VARCHAR2(20);
   credit_block_reason_     VARCHAR2(15) := '';
   ext_credit_block_reason_ VARCHAR2(15) := '';
   ext_block_type_          VARCHAR2(15) := '';   
   ext_manually_blocked_    BOOLEAN := FALSE;
BEGIN   
   -- If there is an external customer order it is needed to check it is manually blocked
   Customer_Order_Line_API.Get_External_Cust_Order(ext_order_no_, order_no_);
   IF (ext_order_no_ IS NOT NULL AND ext_order_no_ != order_no_) THEN
      ext_block_type_ := Customer_Order_API.Get_Blocked_Type_Db(ext_order_no_);
      IF (ext_block_type_ = Customer_Order_Block_Type_API.DB_MANUAL_BLOCKED) THEN
         -- Need to skip credit control group as the external customer order is manually blocked         
         ext_manually_blocked_ := TRUE;
         credit_block_reason_ := 'BLKFORMANUALEXT';
         -- block internal CO
         Customer_Order_API.Set_Blocked(order_no_, credit_block_reason_, checking_state_);         
         -- block internal CO conntected line parents
         Customer_Order_API.Block_Connected_Orders(order_no_, credit_block_reason_);
      END IF;
   END IF;   
   
   IF NOT(ext_manually_blocked_) THEN      
      -- If it comes from 'handle block customer order' in IPD, always credit check will be done.
      IF (checking_state_ NOT IN ('SKIP_CHECK', 'FROM_CO_RELEASE_CREDIT_BLOCK')) THEN
         Check_Order_For_Credit_Check(check_credit_, check_ext_customer_, order_no_, checking_state_);
      ELSE
         -- credit control group will skip
         check_credit_ := 'TRUE';
         check_ext_customer_ := 'FALSE';
      END IF;  
   
      -- Checking external CO for credit block 
      IF (check_ext_customer_ = 'TRUE') THEN      
         IF ext_order_no_ IS NOT NULL AND ext_order_no_ != order_no_ THEN
            IF (Customer_Order_API.Is_Customer_Credit_Blocked(ext_order_no_) != 'FALSE') THEN
               check_credit_ext_cust_ := 'TRUE';
            ELSE
               check_credit_ext_cust_ := check_credit_;
            END IF;
            Check_Order_For_Blocking___(ext_credit_block_reason_, check_credit_ext_cust_, checking_state_, ext_order_no_);
            -- If external credit block reason is not null and not equal to FALSE then
            -- internal CO credit block reason will be assigned.   
            IF ext_credit_block_reason_ IS NOT NULL AND ext_credit_block_reason_ != 'FALSE' THEN            
               IF ext_credit_block_reason_ = 'BLKFORADVPAY' THEN
                  credit_block_reason_ := 'BLKFORADVPAYEXT';
               ELSIF ext_credit_block_reason_ = 'BLKFORPREPAY' THEN
                  credit_block_reason_ := 'BLKFORPREPAYEXT';
               ELSIF ext_credit_block_reason_ = 'BLKFORCRE' THEN
                  credit_block_reason_ := 'BLKFORCREEXT';
               ELSIF ext_credit_block_reason_ = 'BLKCRELMT' THEN
                  credit_block_reason_ := 'BLKCRELMTEXT';
               END IF;            
            END IF;
         END IF;

         IF ext_credit_block_reason_ IS NOT NULL AND ext_credit_block_reason_ != 'FALSE' THEN 
            -- If any block reason is found block the external CO
            Customer_Order_API.Set_Blocked(ext_order_no_, ext_credit_block_reason_, checking_state_);
            -- Block internal CO as the external CO was eligible to blocked
            Customer_Order_API.Set_Blocked(order_no_, credit_block_reason_, checking_state_);            
            -- block internal CO conntected line parents
            Customer_Order_API.Block_Connected_Orders(order_no_, credit_block_reason_);
         END IF;
      END IF;

      -- This code block will be run for two purposes.
      --    1. If internal CO is not blocked due to external CO, it will do the credit check again.
      --    2. If the order_no_ is external CO
      objstate_ := Customer_Order_API.Get_Objstate(order_no_);
      IF (objstate_ != 'Blocked') OR (checking_state_ = 'FROM_CO_RELEASE_CREDIT_BLOCK') THEN 
         Check_Order_For_Blocking___(credit_block_reason_, check_credit_, checking_state_, order_no_);
         IF (credit_block_reason_ IS NOT NULL AND credit_block_reason_ != 'FALSE') THEN
            Customer_Order_API.Set_Blocked(order_no_, credit_block_reason_, checking_state_);
         END IF;  
      END IF;
   END IF;
END Credit_Check_Order;

-- Check_Order_For_Credit_Check
--   Check at which stages credit check should be performed.
--   And check whether connected external CO exist
@UncheckedAccess
PROCEDURE Check_Order_For_Credit_Check (
   check_credit_       IN OUT VARCHAR2,
   check_ext_customer_ IN OUT VARCHAR2,
   order_no_           IN     VARCHAR2,
   checking_state_     IN     VARCHAR2 )
IS
   customer_no_              CUSTOMER_ORDER_TAB.customer_no%TYPE;
   order_rec_                Customer_Order_API.Public_Rec;
   credit_control_group_rec_ Credit_Control_Group_API.Public_rec;
   credit_control_group_id_  VARCHAR2(40);
BEGIN   
   order_rec_ := Customer_Order_API.Get(order_no_);
   IF (order_rec_.released_from_credit_check = 'FALSE' OR checking_state_ = 'MANUAL') THEN
      customer_no_ := NVL(order_rec_.customer_no_pay, order_rec_.customer_no);
      -- Check wheter customer is credit blocked.
      IF (Customer_Order_API.Is_Customer_Credit_Blocked(order_no_) != 'FALSE') THEN
         check_credit_ := 'TRUE';
      END IF;

      credit_control_group_id_ := Cust_Ord_Customer_API.Get_Credit_Control_Group_Id(customer_no_);

      IF (credit_control_group_id_ IS NOT NULL) THEN
         credit_control_group_rec_ := Credit_Control_Group_API.Get(credit_control_group_id_);   
      END IF;
      
      IF check_credit_ = 'FALSE' THEN
         IF (credit_control_group_id_ IS NOT NULL) THEN
            check_ext_customer_       := credit_control_group_rec_.ext_cust_crd_chk;
            CASE checking_state_
               WHEN 'RELEASE_ORDER' THEN
                  IF credit_control_group_rec_.do_check_when_release = 'TRUE' THEN
                     check_credit_ := 'TRUE';
                  END IF;
               WHEN 'PICK_PROPOSAL' THEN
                  IF credit_control_group_rec_.do_check_when_pick_plan = 'TRUE' THEN
                     check_credit_ := 'TRUE';
                  END IF;
               WHEN 'CREATE_PICK_LIST' THEN
                  IF credit_control_group_rec_.do_check_when_pick_list = 'TRUE' THEN
                     check_credit_ := 'TRUE';
                  END IF;
               WHEN 'DELIVER' THEN
                  IF credit_control_group_rec_.do_check_when_deliver = 'TRUE' THEN
                     check_credit_ := 'TRUE';
                  END IF;
               WHEN 'MANUAL' THEN
                  check_credit_ := 'TRUE';
            END CASE;
         ELSIF (checking_state_ = 'MANUAL') THEN
            check_ext_customer_ := 'FALSE';
            check_credit_       := 'TRUE'; 
         END IF;
      ELSIF (credit_control_group_id_ IS NOT NULL) THEN
         check_ext_customer_ := credit_control_group_rec_.ext_cust_crd_chk;
      END IF;
   END IF;
END Check_Order_For_Credit_Check;


PROCEDURE Print_Delivery_Note (
   delnote_no_ IN VARCHAR2 )
IS
BEGIN
   Print_Delivery_Note___(delnote_no_);
END Print_Delivery_Note;


-- Check_Co_To_Return
--   This method checks whether there is a quantity to return for the given order Number.
--   If there is at least one customer order line which has a quantity to return it will return 1.
--   If there are no lines that can be returned then it will return 0.
@UncheckedAccess
FUNCTION Check_Co_To_Return (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   line_to_return_ NUMBER;

   CURSOR  get_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM customer_order_line_tab
      WHERE order_no = order_no_
      AND line_item_no <= 0
      AND part_ownership IN (Part_Ownership_API.DB_COMPANY_OWNED, 
                             Part_Ownership_API.DB_COMPANY_RENTAL_ASSET)      
      AND rental = Fnd_Boolean_API.DB_FALSE;
BEGIN
   FOR rec_ IN get_lines LOOP
      line_to_return_ := Check_Co_Lines_To_Return(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      IF (line_to_return_ = 1) THEN
         RETURN line_to_return_;
      END IF;
   END LOOP;
   RETURN 0;
END Check_Co_To_Return;


-- Check_Co_Lines_To_Return
--   This method checks whether there is a quantity to return for the given Customer Order Line.
--   If it has a quantity to return it will return 1. Otherwise returns 0. For the package parts
--   it will check whether there are component parts that can be returned.
@UncheckedAccess
FUNCTION Check_Co_Lines_To_Return (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   attr_                VARCHAR2(2000);
   poss_qty_to_return_  NUMBER;
   line_rec_            Customer_Order_Line_API.Public_Rec;

   CURSOR  get_pkg_comp_lines IS
      SELECT line_item_no
      FROM customer_order_line_tab
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no > 0; 
BEGIN
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   IF (line_rec_.part_ownership IN (Part_Ownership_API.DB_COMPANY_OWNED, Part_Ownership_API.DB_COMPANY_RENTAL_ASSET) OR line_rec_.rental = Fnd_Boolean_API.DB_TRUE) AND (NVL(line_rec_.demand_code, '*') != 'CRE') THEN
      IF (line_item_no_ = 0) THEN
         Return_Material_Line_API.Get_Co_Line_Data(attr_, order_no_, line_no_, rel_no_, line_item_no_, NULL, NULL);   
         poss_qty_to_return_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('POSS_QTY_TO_RETURN', attr_));
         IF (poss_qty_to_return_ > 0) THEN                        
            RETURN 1;
         END IF; 
      ELSE
         FOR pkg_rec_ IN get_pkg_comp_lines LOOP
            Return_Material_Line_API.Get_Co_Line_Data(attr_, order_no_, line_no_, rel_no_, pkg_rec_.line_item_no, NULL, NULL);   
            poss_qty_to_return_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('POSS_QTY_TO_RETURN', attr_));
            IF (poss_qty_to_return_ > 0) THEN                        
               RETURN 1;
            END IF;
         END LOOP;
      END IF;
   END IF;
   RETURN 0;
END Check_Co_Lines_To_Return;


-- Create_Rma_From_Co_Header
--   This method will create a Return Material for all the Customer Order Lines that can be returned in the given Customer Orders List. There will be
--   corresponding one Return Material Line for each Customer Order Line. The return reason for all the Return Material Lines will be same.
PROCEDURE Create_Rma_From_Co_Header (
   inv_count_        OUT    NUMBER,
   rma_no_           IN OUT NUMBER,
   customer_no_      IN     VARCHAR2,
   contract_         IN     VARCHAR2,
   reason_code_      IN     VARCHAR2,
   add_charge_lines_ IN     VARCHAR2,
   order_no_list_    IN     VARCHAR2 )
IS 
   attr_                VARCHAR2(2000);
   order_no_            VARCHAR2(12);
   ptr_                 NUMBER := NULL;
   name_                VARCHAR2(30);
   value_               VARCHAR2(2000);
   customer_order_rec_  Customer_Order_API.Public_Rec;
   qty_to_return_       NUMBER;   
   receipt_rma_line_no_ NUMBER;

   CURSOR get_order_lines(order_no_  VARCHAR2) IS
      SELECT line_no, rel_no, line_item_no
      FROM customer_order_line_tab
      WHERE order_no = order_no_
      AND line_item_no >= 0
      AND rental = Fnd_Boolean_API.DB_FALSE
      AND part_ownership IN (Part_Ownership_API.DB_COMPANY_OWNED, Part_Ownership_API.DB_COMPANY_RENTAL_ASSET)
      AND rowstate IN ('PartiallyDelivered', 'Delivered', 'Invoiced')
      AND NVL(demand_code, '*') != 'CRE';

   -- Allowed all connected/available [not cllect] to be included, since order lines from PartiallyDelivered state get added to the RMA.
   CURSOR get_all_header_charges(order_no_  VARCHAR2) IS
      SELECT sequence_no, line_no, rel_no, line_item_no, charge_type, charged_qty, qty_returned
      FROM customer_order_charge_tab
      WHERE order_no = order_no_
      AND (charged_qty - qty_returned) > 0
      AND line_no IS NULL
      AND collect != 'COLLECT';
   
   CURSOR get_created_rma_lines IS
      SELECT DISTINCT line_no, rel_no, qty_to_return
      FROM return_material_line_tab 
      WHERE rma_no =  rma_no_;       
         
   CURSOR get_added_line_charges(order_no_  VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2) IS
      SELECT ct.sequence_no, ct.line_no, ct.rel_no, ct.line_item_no, ct.charge_type, ct.charged_qty, ct.qty_returned, ct.unit_charge
      FROM customer_order_charge_tab ct
      WHERE ct.order_no = order_no_
      AND (ct.charged_qty - ct.qty_returned) > 0
      AND ct.line_no IS NOT NULL
      AND ct.line_no = line_no_
      AND ct.rel_no = rel_no_
      AND ct.collect != 'COLLECT';
BEGIN
   order_no_           := Client_SYS.Get_Item_Value('ORDER_NO',order_no_list_);
   customer_order_rec_ := Customer_Order_API.Get(order_no_);
   
   IF (NVL(rma_no_,0) = 0) THEN
      Create_Rma_Header_From_Co (rma_no_, customer_no_, contract_, order_no_list_);
   END IF;
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('RMA_NO',rma_no_ , attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('RETURN_REASON_CODE',reason_code_ , attr_);
   Client_SYS.Add_To_Attr('PURCHASE_ORDER_NO', NVL(customer_order_rec_.internal_po_no,customer_order_rec_.customer_po_no), attr_);

   IF (order_no_list_ IS NOT NULL) THEN
      WHILE (Client_SYS.Get_Next_From_Attr(order_no_list_, ptr_, name_, value_)) LOOP
         IF (name_ = 'ORDER_NO') THEN
            order_no_ := value_;
            FOR rec_lines_ IN get_order_lines(order_no_) LOOP
               Create_Rma_Lines___(inv_count_, receipt_rma_line_no_, order_no_, rec_lines_.line_no, rec_lines_.rel_no, rec_lines_.line_item_no, attr_);
            END LOOP;
            IF (add_charge_lines_ = 'TRUE') THEN
               FOR rec_charges_ IN get_all_header_charges(order_no_) LOOP
                  qty_to_return_ := (rec_charges_.charged_qty - rec_charges_.qty_returned);
                  Create_Rma_Charge_Lines___(order_no_, rec_charges_.sequence_no, rma_no_, contract_, rec_charges_.charge_type, qty_to_return_);
               END LOOP;
               FOR created_line_ IN get_created_rma_lines LOOP
                  FOR rec_charges_ IN get_added_line_charges(order_no_, created_line_.line_no, created_line_.rel_no) LOOP
                     qty_to_return_ := (rec_charges_.charged_qty - rec_charges_.qty_returned);
                     IF (rec_charges_.unit_charge = 'TRUE' AND (created_line_.qty_to_return < qty_to_return_)) THEN
                        qty_to_return_ := created_line_.qty_to_return;
                     END IF;
                     Create_Rma_Charge_Lines___(order_no_, rec_charges_.sequence_no, rma_no_, contract_, rec_charges_.charge_type, qty_to_return_);
                  END LOOP;
               END LOOP;
            END IF;
         END IF;
      END LOOP;
   END IF;
END Create_Rma_From_Co_Header;


-- Create_Rma_From_Co_Lines
--   This method will create a Return Material for the given Customer Order Line list
--   if there is any qty that can be returned.
PROCEDURE Create_Rma_From_Co_Lines (
   inv_count_         OUT    NUMBER,
   rma_no_            IN OUT NUMBER,
   customer_no_       IN     VARCHAR2,
   contract_          IN     VARCHAR2,
   reason_code_       IN     VARCHAR2,
   add_charge_lines_  IN     VARCHAR2,
   co_list_           IN     VARCHAR2 ) 
IS
   line_rec_               Customer_Order_Line_API.Public_Rec;
   attr_                   VARCHAR2(2000);
   order_no_               VARCHAR2(12);
   ptr_                    NUMBER := NULL;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
   customer_order_rec_     Customer_Order_API.Public_Rec;
   qty_to_return_          NUMBER;
   receipt_rma_line_no_    NUMBER;
   rma_line_qty_to_return_ NUMBER;
   
   TYPE Order_Line_Rec IS RECORD
      (order_no      customer_order_line_tab.order_no%TYPE,
      line_no        customer_order_line_tab.line_no%TYPE,
      rel_no         customer_order_line_tab.rel_no%TYPE,
      line_item_no   customer_order_line_tab.line_item_no%TYPE);
    
   TYPE Ord_Line_Details_Table IS TABLE OF Order_Line_Rec INDEX BY BINARY_INTEGER;

   ord_details_tabl_    Ord_Line_Details_Table;
   row_count_           NUMBER := 0;
      
   CURSOR  get_pkg_comp_lines(order_no_ VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2) IS
      SELECT line_item_no
      FROM customer_order_line_tab
      WHERE order_no = order_no_
        AND line_no = line_no_
        AND rel_no = rel_no_
        AND line_item_no > 0
        AND part_ownership = Part_Ownership_API.DB_COMPANY_OWNED
        AND rowstate IN ('PartiallyDelivered', 'Delivered', 'Invoiced');

   -- Allowed all connected/available [not collect] to be included, since order lines from PartiallyDelivered state get added to the RMA.
   CURSOR get_charge_lines(order_no_  VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2, line_item_no_ NUMBER) IS
      SELECT sequence_no, line_no, rel_no, line_item_no, charge_type, charged_qty, qty_returned, unit_charge
        FROM customer_order_charge_tab
       WHERE order_no = order_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no = line_item_no_
         AND (charged_qty - qty_returned) > 0
         AND collect != 'COLLECT';
BEGIN
   order_no_           := Client_SYS.Get_Item_Value('ORDER_NO',co_list_);         
   customer_order_rec_ := Customer_Order_API.Get(order_no_);
   
   IF (NVL(rma_no_, 0) = 0) THEN
      Create_Rma_Header_From_Co (rma_no_, customer_no_, contract_, co_list_);
   END IF;

   IF (co_list_ IS NOT NULL) THEN
      WHILE (Client_SYS.Get_Next_From_Attr(co_list_, ptr_, name_, value_)) LOOP
         IF (name_ = 'ORDER_NO') THEN
            ord_details_tabl_(row_count_).order_no     := value_;
         ELSIF (name_ = 'LINE_NO') THEN
            ord_details_tabl_(row_count_).line_no      := value_;
         ELSIF (name_ = 'REL_NO') THEN
            ord_details_tabl_(row_count_).rel_no       := value_;
         ELSIF (name_ = 'LINE_ITEM_NO') THEN
            ord_details_tabl_(row_count_).line_item_no := Client_SYS.Attr_Value_To_Number(value_);
            row_count_ := row_count_ + 1;
         END IF;
      END LOOP;
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('RMA_NO',rma_no_ , attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('RETURN_REASON_CODE',reason_code_ , attr_);

   IF (ord_details_tabl_.COUNT > 0) THEN   
      FOR index_ IN ord_details_tabl_.FIRST..ord_details_tabl_.LAST LOOP   
         IF (ord_details_tabl_(index_).line_item_no < 0) THEN
            FOR pkg_rec_ IN get_pkg_comp_lines(ord_details_tabl_(index_).order_no, ord_details_tabl_(index_).line_no, ord_details_tabl_(index_).rel_no) LOOP
               Create_Rma_Lines___(inv_count_, receipt_rma_line_no_, ord_details_tabl_(index_).order_no, ord_details_tabl_(index_).line_no, ord_details_tabl_(index_).rel_no, pkg_rec_.line_item_no, attr_);
            END LOOP;
         ELSE
            line_rec_ := Customer_Order_Line_API.Get(ord_details_tabl_(index_).order_no, ord_details_tabl_(index_).line_no, ord_details_tabl_(index_).rel_no, ord_details_tabl_(index_).line_item_no);
            IF (line_rec_.part_ownership IN (Part_Ownership_API.DB_COMPANY_OWNED, Part_Ownership_API.DB_COMPANY_RENTAL_ASSET, Part_Ownership_API.DB_SUPPLIER_RENTED)) THEN
               Create_Rma_Lines___(inv_count_, receipt_rma_line_no_, ord_details_tabl_(index_).order_no, ord_details_tabl_(index_).line_no, ord_details_tabl_(index_).rel_no, ord_details_tabl_(index_).line_item_no, attr_);
            END IF;
         END IF;
         IF (add_charge_lines_ = 'TRUE') THEN
            FOR rec_charges_ IN get_charge_lines(ord_details_tabl_(index_).order_no, ord_details_tabl_(index_).line_no, ord_details_tabl_(index_).rel_no, ord_details_tabl_(index_).line_item_no) LOOP
               qty_to_return_ := (rec_charges_.charged_qty - rec_charges_.qty_returned);
               rma_line_qty_to_return_ := Return_Material_Line_API.Get_Qty_To_Return(rma_no_, receipt_rma_line_no_ );
               IF (rec_charges_.unit_charge = 'TRUE' AND (rma_line_qty_to_return_ < qty_to_return_)) THEN 
                  qty_to_return_ := rma_line_qty_to_return_;
               END IF;
               Create_Rma_Charge_Lines___(ord_details_tabl_(index_).order_no, rec_charges_.sequence_no, rma_no_, contract_, rec_charges_.charge_type, qty_to_return_);
            END LOOP; 
         END IF;
      END LOOP;
   END IF;
END Create_Rma_From_Co_Lines;     


-- Print_Pick_List
--   Print the specified pick list.
PROCEDURE Print_Pick_List (
   pick_list_no_  IN VARCHAR2 )
IS
   printer_id_            VARCHAR2(100);
   attr_                  VARCHAR2(200);
   report_attr_           VARCHAR2(2000);
   parameter_attr_        VARCHAR2(2000);
   print_job_id_          NUMBER;
   order_no_              VARCHAR2(12);
   work_order_no_         NUMBER;
   purchase_order_no_     VARCHAR2(12);
   nopart_lines_exist_    NUMBER;   
   pur_order_no_          VARCHAR2(12);
   report_id_             VARCHAR2(30);
   pdf_info_              VARCHAR2(4000);
   order_rec_             Customer_Order_API.Public_Rec;
   cust_email_addr_       VARCHAR2(200);
   result_                NUMBER;
   result_key_            NUMBER;
   print_pick_report_db_  site_discom_info_tab.print_pick_report%TYPE;
   customer_order_pick_list_rec_ Customer_Order_Pick_List_API.Public_Rec;
   pick_list_printed_     BOOLEAN := FALSE;
   
   CURSOR get_mro_lines IS
      SELECT col.demand_order_ref1
      FROM customer_order_line_tab col, create_pick_list_join_new cpl
      WHERE cpl.order_no   = order_no_
      AND col.order_no     = cpl.order_no
      AND col.line_no      = cpl.line_no
      AND col.rel_no       = cpl.rel_no
      AND col.line_item_no = cpl.line_item_no
      AND col.supply_code  = 'MRO';
BEGIN
   Trace_SYS.Field('In Print_Pick_List__ ', pick_list_no_);
   customer_order_pick_list_rec_ :=  Customer_Order_Pick_List_API.Get(pick_list_no_);     
   order_no_               := customer_order_pick_list_rec_.order_no;
   print_pick_report_db_   := Site_Discom_Info_API.Get_Print_Pick_Report_Db(customer_order_pick_list_rec_.contract);

   
   IF print_pick_report_db_ IN (Invent_Report_Print_Option_API.DB_DETAILED, Invent_Report_Print_Option_API.DB_BOTH) THEN
      IF (customer_order_pick_list_rec_.consolidated_flag = 'CONSOLIDATED') THEN
         Trace_SYS.Message('Consolidated Pick List');
         -- Generate a new print job id
         IF (customer_order_pick_list_rec_.shipments_consolidated IS NOT NULL) THEN
            report_id_  := 'SHIPMENT_CONSOL_PICK_LIST_REP';
            printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, report_id_);
         ELSE
            report_id_  := 'CUST_ORD_CONSOL_PICK_LIST_REP';
            printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, report_id_);
         END IF;

         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, attr_);
         Print_Job_API.New(print_job_id_, attr_);
         -- Create the Consolidated report
         Client_SYS.Clear_Attr(report_attr_);
         Client_SYS.Add_To_Attr('REPORT_ID', report_id_, report_attr_);
      ELSE
         Trace_SYS.Message('Normal Pick List');
         report_id_ := 'CUSTOMER_ORDER_PICK_LIST_REP';
      END IF;
      -- Generate a new print job id
      Client_SYS.Clear_Attr(parameter_attr_);
      Client_SYS.Add_To_Attr('PICK_LIST_NO', pick_list_no_, parameter_attr_);
      order_rec_              := Customer_Order_API.Get(order_no_);
      cust_email_addr_ := Cust_Ord_Customer_Address_API.Get_Email(order_rec_.customer_no, order_rec_.cust_ref, order_rec_.bill_addr_no);

      Create_Report_Settings(pdf_info_, order_no_, order_rec_.cust_ref, order_rec_.contract, cust_email_addr_, order_rec_.customer_no, report_id_);
      Create_Print_Jobs(print_job_id_, result_, report_id_, parameter_attr_, pdf_info_);
      Printing_Print_Jobs(print_job_id_);
      pick_list_printed_ := TRUE;
      -- Since a new print job creates for appendix report, print_job_id_ should be empty
      print_job_id_ := NULL;   
   END IF;
   
   IF print_pick_report_db_ IN (Invent_Report_Print_Option_API.DB_AGGREGATED, Invent_Report_Print_Option_API.DB_BOTH) THEN
      -- Create the report for aggregated handling units 
      Client_SYS.Clear_Attr(report_attr_);
      Client_SYS.Add_To_Attr('REPORT_ID', 'HANDLING_UNIT_PICK_LIST_REP', report_attr_);
      Client_SYS.Clear_Attr(parameter_attr_);
      Client_SYS.Add_To_Attr('PICK_LIST_NO', pick_list_no_, parameter_attr_);
      Archive_API.New_Instance(result_key_, report_attr_, parameter_attr_);
      Printing_Print_Jobs(print_job_id_);
      pick_list_printed_ := TRUE;
      print_job_id_ := NULL;   
   END IF;
   
   $IF (Component_Wo_SYS.INSTALLED) AND (Component_Purch_SYS.INSTALLED) $THEN
      -- Note: Get MRO order lines for Miscellaneous Part Report.
      FOR mro_line_ IN get_mro_lines LOOP
         work_order_no_      := TO_NUMBER(mro_line_.demand_order_ref1);
         pur_order_no_       := Active_Work_Order_API.Get_Receive_Order_No(work_order_no_);
         purchase_order_no_  := pur_order_no_;
         nopart_lines_exist_ := Purchase_Order_API.Check_Nopart_Lines_Exist(pur_order_no_);                      
         IF nopart_lines_exist_ != 0 THEN
            -- Note: Create the Pick_List Appendix report
            Client_SYS.Clear_Attr(parameter_attr_);
            Client_SYS.Add_To_Attr('ORDER_NO', purchase_order_no_, parameter_attr_);
            Client_SYS.Add_To_Attr('REPORT_TYPE', 'PICK LIST', parameter_attr_);
            -- Create one print job for appendix report and attach print job instances to same print job if multiple MRO lines exist 
            result_ := NULL;
            Create_Print_Jobs(print_job_id_, result_, 'PURCH_MISCELLANEOUS_PART_REP', parameter_attr_);
         END IF;
      END LOOP;
   $END

   IF print_job_id_ IS NOT NULL THEN
      Printing_Print_Jobs(print_job_id_);
      pick_list_printed_ := TRUE;
   END IF;

   -- Add a new record in customer order history. May be several order when using consolidated Pick Lists
   IF (pick_list_printed_) THEN
      Create_Print_Pick_List_Hist__ ( pick_list_no_, customer_order_pick_list_rec_.consolidated_flag);
   END IF;
END Print_Pick_List;


-- Validate_Params
--   This procedure is called by Batch Print Customer Invoices Schedule to validate the parameters
PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_               NUMBER;
   name_arr_            Message_SYS.name_table;
   value_arr_           Message_SYS.line_table;
   contract_            VARCHAR2(5);
   invoice_type_        CUSTOMER_ORDER_INV_HEAD.invoice_type%TYPE;
   company_             CUSTOMER_ORDER_INV_HEAD.company%TYPE;
   invoice_series_id_   CUSTOMER_ORDER_INV_HEAD.series_id%TYPE;
   order_id_            CUSTOMER_ORDER_TAB.order_id%TYPE;
   customer_no_         CUSTOMER_ORDER_TAB.customer_no%TYPE;
   invoice_cust_no_     CUSTOMER_ORDER_TAB.customer_no%TYPE;
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY') THEN
         company_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'INVOICE_TYPE') THEN
         invoice_type_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SERIES_ID') THEN
         invoice_series_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ORDER_ID') THEN
         order_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CUSTOMER_NO') THEN
         customer_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'INVOICE_CUSTOMER_NO') THEN
         invoice_cust_no_ := value_arr_(n_);
      END IF;
   END LOOP;

   IF (company_ IS NOT NULL) THEN   
      Company_API.Exist(company_);
      Company_Finance_API.Exist(company_);
   END IF;

   IF (contract_ IS NOT NULL AND contract_ != '%') THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;

   IF (order_id_ IS NOT NULL AND order_id_ != '%')THEN
      Cust_Order_Type_API.Exist(order_id_);
   END IF;

   IF (customer_no_ IS NOT NULL AND customer_no_ != '%') THEN
      Cust_Ord_Customer_API.Exist(customer_no_);
   END IF;

   IF (invoice_cust_no_ IS NOT NULL AND invoice_cust_no_ != '%') THEN
      Cust_Ord_Customer_API.Exist(invoice_cust_no_);
   END IF;
END Validate_Params;


-- Check_No_Previous_Execution
--   This procudure checks whether there is no another background job is "Posted"
--   or "Executing", parallel to which, target_action_ cannot be executed.
PROCEDURE Check_No_Previous_Execution (
   order_no_       IN VARCHAR2,
   target_action_  IN VARCHAR2 ) 
IS
   order_state_ VARCHAR2(20);
BEGIN
   IF target_action_  = 'RELEASE' THEN
      Check_No_Previous_Execution___(order_no_, 'CUSTOMER_ORDER_FLOW_API.Process_From_Release_Order__'); 
      order_state_ := Customer_Order_API.Get_Objstate(order_no_);
      IF order_state_ != 'Planned' THEN
         Error_SYS.Record_General(lu_name_, 'ORDALREADYRELEASED: The customer order :P1 has already been processed by another user.', order_no_);
      END IF;      
   ELSIF target_action_ = 'CANCEL' THEN
      Check_No_Previous_Execution___(order_no_, 'CUSTOMER_ORDER_FLOW_API.Process_From_Release_Order__'); 
      Check_No_Previous_Execution___(order_no_, 'CUSTOMER_ORDER_FLOW_API.Process_From_Reserve__');
      Check_No_Previous_Execution___(order_no_, 'CUSTOMER_ORDER_FLOW_API.Process_From_Create_Pick_Lst__');
   END IF;   
END Check_No_Previous_Execution;


-- Create_Rma_Line_From_Co_Line
--   This is a public interface to create return material line related to the
--   given customer order Line.
PROCEDURE Create_Rma_Line_From_Co_Line (
   inv_count_           OUT NUMBER,
   receipt_rma_line_no_ OUT NUMBER,
   order_no_            IN  VARCHAR2,
   line_no_             IN  VARCHAR2,
   rel_no_              IN  VARCHAR2,
   line_item_no_        IN  NUMBER,
   rma_attr_            IN  VARCHAR2 )
IS
BEGIN
   Create_Rma_Lines___(inv_count_, receipt_rma_line_no_, order_no_, line_no_, rel_no_, line_item_no_, rma_attr_);
END Create_Rma_Line_From_Co_Line;


-- Check_Delete_Exp_License
--   This method will check whether there are any connected Export Licenses before cancelling/deleting the line.
--   If there are any, cancel/delete will not be allowed until all connected licenses are disconnected.
PROCEDURE Check_Delete_Exp_License (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   licensed_order_type_ IN VARCHAR2 )
IS
BEGIN
   IF (Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN
         Exp_License_Connect_Util_API.Check_Allow_Update(order_no_, line_no_, rel_no_, line_item_no_, licensed_order_type_);
      $ELSE
         NULL;
      $END
   END IF;
END Check_Delete_Exp_License;


-- Remove_Connected_Exp_Licenses
--   Removes connected export licenses.
PROCEDURE Remove_Connected_Exp_Licenses (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   licensed_order_type_ IN VARCHAR2 )
IS
BEGIN
   IF (Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN
         Exp_License_Connect_Head_API.Remove_By_Ref(order_no_, line_no_, rel_no_, line_item_no_, licensed_order_type_);
      $ELSE
         NULL;
      $END
   END IF;
END Remove_Connected_Exp_Licenses;


-- Modify_License_Address
--   This method will modify the Customer Address in export license when modifying the Customer Order Line address.
PROCEDURE Modify_License_Address (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   demand_code_       IN VARCHAR2 DEFAULT NULL,
   demand_order_ref1_ IN VARCHAR2 DEFAULT NULL,
   demand_order_ref2_ IN VARCHAR2 DEFAULT NULL,
   demand_order_ref3_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   IF (Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN
         DECLARE
            address1_            CUST_ORDER_LINE_ADDRESS_TAB.Address1%TYPE;
            address2_            CUST_ORDER_LINE_ADDRESS_TAB.Address2%TYPE;
            city_                CUST_ORDER_LINE_ADDRESS_TAB.CITY%TYPE;
            zip_code_            CUST_ORDER_LINE_ADDRESS_TAB.Zip_Code%TYPE;
            country_             CUST_ORDER_LINE_ADDRESS_TAB.Country_Code%TYPE;
            connect_head_id_     NUMBER;
            licensed_order_type_ VARCHAR2(25);
            line_rec_            Customer_Order_Line_API.Public_Rec;
            
            CURSOR get_line_address IS
               SELECT cola.address1, cola.address2, cola.city, cola.zip_code, cola.country_code
               FROM Cust_Order_Line_Address_2 cola
               WHERE cola.order_no = order_no_
               AND   cola.line_no  = line_no_
               AND   cola.rel_no   = rel_no_
               AND   cola.line_item_no = line_item_no_;
         BEGIN
            IF (demand_order_ref1_ IS NULL) THEN
               line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);            
            ELSE
               line_rec_.demand_code       := demand_code_;
               line_rec_.demand_order_ref1 := demand_order_ref1_;
               line_rec_.demand_order_ref2 := demand_order_ref2_;
               line_rec_.demand_order_ref3 := demand_order_ref3_;
            END IF;
            IF (line_item_no_ != -1) THEN
               licensed_order_type_ := Customer_Order_Line_API.Get_Expctr_License_Order_Type(line_rec_.demand_code, line_rec_.demand_order_ref1, line_rec_.demand_order_ref2, line_rec_.demand_order_ref3);
               connect_head_id_ := Exp_License_Connect_Head_API.Get_Connect_Id_From_Ref(licensed_order_type_, order_no_, line_no_, rel_no_, line_item_no_);
            END IF;
            IF ((line_item_no_ = -1) OR (connect_head_id_ IS NOT NULL)) THEN
               OPEN get_line_address;
               FETCH get_line_address INTO address1_, address2_, city_, zip_code_, country_;  
               CLOSE get_line_address;
            END IF;
            IF (line_item_no_ = -1) THEN
               Exp_License_Connect_Head_API.Set_Cust_Addr_For_Pkg_Parts(order_no_, line_no_, rel_no_, address1_, address2_, city_, zip_code_, country_);               
            ELSE 
               IF connect_head_id_ IS NOT NULL THEN
                  Exp_License_Connect_Head_API.Set_Customer_Address(connect_head_id_, address1_, address2_, city_, zip_code_, country_);
               END IF;
            END IF;
         END;
      $ELSE
         NULL;
      $END       
   END IF;
END Modify_License_Address;


-- Get_License_Enabled
--   Return 'TRUE' if export license enabled for the RMA or customer order
--   flow for the specified  site.
@UncheckedAccess
FUNCTION Get_License_Enabled (
    order_no_       IN VARCHAR2,
    sys_param_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_ VARCHAR2(5);
   temp_     VARCHAR2(5) := 'FALSE';
BEGIN
   IF (sys_param_code_='INTERACT_CUST_ORD') THEN
      contract_ := Customer_Order_API.Get_Contract(order_no_);
   ELSIF (sys_param_code_='INTERACT_RMA') THEN
      contract_ := Return_Material_API.Get_Contract(order_no_);
   END IF;

   $IF Component_Expctr_SYS.INSTALLED $THEN
      temp_ := Expctr_System_Parameter_API.Validate_Export_License(sys_param_code_, contract_);
   $END
   
   RETURN temp_;
END Get_License_Enabled;



-- Check_All_License_Connected
--   Check if export license is connected.
PROCEDURE Check_All_License_Connected (
   display_info_  IN OUT NUMBER,
   order_no_      IN     VARCHAR2)
IS
BEGIN
   Check_All_License_Connected___(display_info_, order_no_);
END Check_All_License_Connected;


-- Create_Print_Jobs
--   Create print job for a report. Only one job will be created for a particular report.
--   If a report has more than one result key then rest of the result keys will be
--   attached as pirnt job instances.
--   For an example: Create a print job for a Customer Invoice and print job instances
--   for invoice copies.
PROCEDURE Create_Print_Jobs (
   print_job_id_      IN OUT NUMBER,   
   result_            IN OUT NUMBER,
   report_            IN     VARCHAR2,
   in_parameter_attr_ IN     VARCHAR2,
   pdf_info_          IN     VARCHAR2 DEFAULT NULL ) 
IS
   report_attr_       VARCHAR2(32000);
   result_key_        NUMBER;   
   printer_id_        VARCHAR2(250);
   parameter_attr_    VARCHAR2(32000);
   job_attr_          VARCHAR2(2000);   
   job_contents_attr_ VARCHAR2(2000);
   print_job_ids_     VARCHAR2(25);
   instance_attr_     VARCHAR2(32000);
   lang_code_         VARCHAR2(2);
BEGIN
   parameter_attr_ := in_parameter_attr_;
   Client_SYS.Clear_Attr(report_attr_);
   Client_SYS.Add_To_Attr('REPORT_ID', report_, report_attr_);
   Client_Sys.Add_To_Attr('LANG_CODE', Client_Sys.Get_Item_Value('LANG_CODE', parameter_attr_), report_attr_);
   IF result_ IS NULL THEN
      Archive_API.New_Instance(result_key_, report_attr_, parameter_attr_);
   ELSE
      result_key_ := result_;
   END IF;
   
   --Note: Get the language code from archive instance
   Client_SYS.Clear_Attr(instance_attr_);
   Client_SYS.Clear_Attr(parameter_attr_);
   Archive_API.Get_Info(instance_attr_, parameter_attr_, result_key_);
   lang_code_ := Client_SYS.Get_Item_Value('LANG_CODE', instance_attr_);
   
   --Note: Get the printer which is defined in Priter Definition window
   printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, 
                                                             report_,
                                                             language_code_ => lang_code_);
   
   Client_SYS.Clear_Attr(job_attr_);
   Client_SYS.Add_To_Attr('SETTINGS', pdf_info_, job_attr_);
   Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, job_attr_);
   
   Client_SYS.Clear_Attr(job_contents_attr_);
   Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, job_contents_attr_);   
   Client_SYS.Add_To_Attr('OPTIONS',    'COPIES(1)', job_contents_attr_);
   Client_SYS.Add_To_Attr('LANG_CODE', lang_code_, job_contents_attr_);
   
   IF (NVL(Client_SYS.Get_Item_Value('PRINT_ONLINE', in_parameter_attr_), 'FALSE') = 'FALSE') THEN
      -- Generate a new print job ids and Connect the created report
      IF print_job_id_ IS NULL THEN
         Print_Job_API.New_Print_Job(print_job_ids_, job_attr_, job_contents_attr_);
         -- Separate print job ids 
         IF print_job_ids_ IS NOT NULL THEN
            print_job_id_ := print_job_ids_;
         END IF;
      ELSE
         -- If a report has more than one result key, the rest of the result keys, attach as print job instances to same print job
         Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, job_contents_attr_);
         Print_Job_Contents_API.New_Instance(job_contents_attr_);
      END IF;
   END IF;
   result_ := result_key_;
END Create_Print_Jobs;


PROCEDURE Printing_Print_Jobs (
   print_job_id_ IN NUMBER )
IS
   printer_id_list_ VARCHAR2(32000);
BEGIN
   -- Send the print job to the printer.
   Logical_Printer_API.Enumerate_Printer_Id(printer_id_list_);
   IF (printer_id_list_ IS NOT NULL) THEN
      IF (print_job_id_ IS NOT NULL) THEN
         Print_Job_API.Print(print_job_id_);
      END IF;
   END IF;
END Printing_Print_Jobs;


-- Create_Report_Settings
--   Creates pdf_info_ attribute string to be used to set pdf parameters when prinitng reports.
@UncheckedAccess
PROCEDURE Create_Report_Settings (
   pdf_info_     OUT VARCHAR2,
   order_no_     IN  VARCHAR2,
   contact_      IN  VARCHAR2,
   contract_     IN  VARCHAR2,
   email_        IN  VARCHAR2,
   customer_no_  IN  VARCHAR2,
   report_id_    IN  VARCHAR2)
IS
   invoice_number_    VARCHAR2(70);
   our_reference_     VARCHAR2(100);   
   company_           VARCHAR2(20);   
      
   CURSOR get_invoice_details IS
      SELECT our_reference, series_id, invoice_no, creators_reference order_no, rma_no, identity,prepaym_adv_invoice, invoice_address_id
      FROM customer_order_inv_head
      WHERE company    = company_
      AND   invoice_id = order_no_;

   CURSOR get_order_details(co_no_ IN VARCHAR2) IS
      SELECT authorize_code, internal_po_no, customer_po_no, language_code, bill_addr_no, customer_no
      FROM customer_order_tab
      WHERE order_no = co_no_;
   
   inv_rec_           get_invoice_details%ROWTYPE;
   co_rec_            get_order_details%ROWTYPE;
   customer_po_no_    VARCHAR2(50);
   customer_language_ VARCHAR2(2) := NULL;
   temp_contact_      VARCHAR2(200);
   bill_addr_no_      VARCHAR2(50);
   local_contact_     VARCHAR2(100);
   local_email_       VARCHAR2(200);
   delivery_address_  VARCHAR2(50);
   report_name_       VARCHAR2(200);
BEGIN
   IF (report_id_ IN ('CUSTOMER_ORDER_CONF_REP', 'PROFORMA_INVOICE_REP', 'CUSTOMER_ORDER_PICK_LIST_REP', 'CUST_ORD_CONSOL_PICK_LIST_REP')) THEN
      OPEN get_order_details(order_no_);
      FETCH get_order_details INTO co_rec_;
      IF (get_order_details%FOUND) THEN
         customer_po_no_ := NVL(co_rec_.internal_po_no, co_rec_.customer_po_no);
         our_reference_  := Order_Coordinator_API.Get_Name(co_rec_.authorize_code);
         bill_addr_no_   := co_rec_.bill_addr_no;
      END IF;
      CLOSE get_order_details;
   ELSE
      company_ := Site_API.Get_Company(contract_);
      
      OPEN get_invoice_details;
      FETCH get_invoice_details INTO inv_rec_;            
      IF (get_invoice_details%FOUND) THEN
         our_reference_  := inv_rec_.our_reference;
         invoice_number_ := inv_rec_.series_id || inv_rec_.invoice_no;
         IF ((inv_rec_.order_no IS NOT NULL) AND (inv_rec_.rma_no IS NULL)) THEN
            OPEN get_order_details(inv_rec_.order_no);
            FETCH get_order_details INTO co_rec_;
            IF (get_order_details%FOUND) THEN
               IF (inv_rec_.prepaym_adv_invoice = 'TRUE') THEN
                  customer_po_no_ := co_rec_.customer_po_no;
               ELSE
                  customer_po_no_ := NVL(co_rec_.internal_po_no, co_rec_.customer_po_no);
               END IF;         
            END IF;
            CLOSE get_order_details;
         ELSE
            customer_language_ := Customer_Info_api.Get_Default_Language_Db(inv_rec_.identity);
         END IF;
         bill_addr_no_   := inv_rec_.invoice_address_id;
      END IF;
      CLOSE get_invoice_details; 
   END IF;
   
   local_contact_ := contact_;
   IF(local_contact_ IS NULL AND order_no_ IS NOT NULL) THEN
      local_contact_ := Customer_Order_API.Get_Cust_Ref(order_no_);
   END IF;
   
   IF local_contact_ IS NOT NULL THEN
      IF Comm_Method_API.Get_Default_Value('CUSTOMER', customer_no_,'E_MAIL', bill_addr_no_, NULL, local_contact_) IS NULL THEN
         temp_contact_ := Contact_Util_API.Get_Cust_Contact_Name(customer_no_, bill_addr_no_, local_contact_); 
      END IF;
   END IF;
   
   pdf_info_ := Message_SYS.Construct('PDF');
   
   IF (report_id_ NOT IN ('CUSTOMER_ORDER_PICK_LIST_REP', 'CUST_ORD_CONSOL_PICK_LIST_REP')) THEN
      local_email_ := email_;
      IF( local_email_ IS NULL AND local_contact_ IS NOT NULL ) THEN
         IF (report_id_ = 'CUSTOMER_ORDER_CONF_REP') THEN
            local_email_ := Cust_Ord_Customer_Address_API.Get_Email(co_rec_.customer_no, local_contact_, bill_addr_no_);
            IF ( local_email_ IS NULL ) THEN
               $IF (Component_Purch_SYS.INSTALLED) $THEN
                  delivery_address_ := Purchase_Order_API.Get_Delivery_Address(customer_po_no_);
               $END
               local_email_:= Comm_Method_API.Get_Name_Value('COMPANY', company_, 'E_MAIL', local_contact_, delivery_address_);
            END IF;
         ELSIF(report_id_ = 'PROFORMA_INVOICE_REP') THEN
            $IF (Component_Purch_SYS.INSTALLED) $THEN
               delivery_address_ := Purchase_Order_API.Get_Delivery_Address(customer_po_no_);
            $END
            local_email_:= Comm_Method_API.Get_Name_Value('COMPANY', company_, 'E_MAIL', local_contact_, delivery_address_);
         ELSIF (report_id_ = 'CUSTOMER_ORDER_IVC_REP') THEN
            local_email_:= Cust_Ord_Customer_Address_API.Get_Email(inv_rec_.identity, local_contact_, bill_addr_no_);
         END IF;
      END IF;
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_1', local_email_);
   END IF;
   
   Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_2', customer_no_);
   Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_3', contract_);
   Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_4', local_contact_);
   Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_5', our_reference_);
   report_name_ := Report_Definition_API.Get_Translated_Report_Title(report_id_);
   
   IF (report_id_ IN ('CUSTOMER_ORDER_CONF_REP', 'PROFORMA_INVOICE_REP', 'CUSTOMER_ORDER_PICK_LIST_REP', 'CUST_ORD_CONSOL_PICK_LIST_REP')) THEN
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_6', order_no_);
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_FILE_NAME', report_name_ || '_' || order_no_);
   ELSE
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_6', invoice_number_);
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_FILE_NAME', report_name_ || '_' || invoice_number_);
   END IF;
   
   IF (customer_po_no_ IS NOT NULL) THEN
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_7', customer_po_no_);
   END IF;
   Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_8', NVL(temp_contact_, local_contact_));
   Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_11', Fnd_Boolean_API.DB_TRUE);
   Message_SYS.Add_Attribute(pdf_info_, 'REPLY_TO_USER', Person_Info_API.Get_User_Id(co_rec_.authorize_code));
END Create_Report_Settings;


-- Get_Translated_State
--    This method returns the language specific state related to the database state of a given domain.
@UncheckedAccess
FUNCTION Get_Translated_State(
   domain_     IN VARCHAR2,
   db_state_   IN VARCHAR2,
   lng_code_   IN VARCHAR2 DEFAULT NULL)RETURN VARCHAR2
IS   
BEGIN
   RETURN(Domain_SYS.Decode_(Domain_SYS.Get_Translated_Values(domain_, lng_code_), Domain_SYS.Get_Db_Values(domain_), db_state_));
END Get_Translated_State;

-- Create_Rma_Header_From_Co
--    This method creates RMA header using CO information.
PROCEDURE Create_Rma_Header_From_Co (
   rma_no_        OUT NUMBER,
   customer_no_   IN VARCHAR2,
   contract_      IN VARCHAR2,
   order_no_list_ IN VARCHAR2 )   
IS 
   info_                  VARCHAR2(2000);
   attr_                  VARCHAR2(2000);
   order_no_              VARCHAR2(12);
   customer_order_rec_    Customer_Order_API.Public_Rec;
   cust_order_add_rec_    Customer_Order_Address_API.Cust_Ord_Addr_Rec;
   add_order_no_to_rma_   BOOLEAN := TRUE;
   ptr_                   NUMBER := NULL;
   name_                  VARCHAR2(30);
   value_                 VARCHAR2(2000);
   site_rec_              Site_API.Public_Rec;
BEGIN   
   Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_no_ , attr_);
   Client_SYS.Add_To_Attr('RETURN_FROM_CUSTOMER_NO', customer_no_ , attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_ , attr_);
   Client_SYS.Add_To_Attr('RETURN_TO_CONTRACT', contract_ , attr_);

   order_no_           := Client_SYS.Get_Item_Value('ORDER_NO',order_no_list_);         
   customer_order_rec_ := Customer_Order_API.Get(order_no_);

   Client_SYS.Add_To_Attr('CUSTOMER_NO_CREDIT', customer_order_rec_.customer_no_pay, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO_CREDIT_ADDR_NO', customer_order_rec_.customer_no_pay_addr_no, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_CODE', customer_order_rec_.currency_code, attr_);
   Client_SYS.Add_To_Attr('SHIP_ADDR_NO', customer_order_rec_.ship_addr_no, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO_ADDR_NO', customer_order_rec_.bill_addr_no, attr_);
   -- Internal ref (Internal PO ref value from intersite flow) has been prioritized over customer order header reference.
   Client_SYS.Add_To_Attr('CUST_REF', NVL(customer_order_rec_.internal_ref, customer_order_rec_.cust_ref), attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE',  customer_order_rec_.customer_tax_usage_type, attr_);   

   site_rec_ := Site_API.Get(contract_);
   Client_SYS.Add_To_Attr('RETURN_ADDR_NO', NVL(site_rec_.delivery_address, Company_Address_Type_API.Get_Company_Address_Id(site_rec_.company, Address_Type_Code_API.Decode('DELIVERY'),'TRUE')), attr_);
   Client_SYS.Add_To_Attr('JINSUI_INVOICE_DB', customer_order_rec_.jinsui_invoice, attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', customer_order_rec_.use_price_incl_tax, attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', Cust_Ord_Customer_Address_API.Get_Intrastat_Exempt_Db(customer_no_, customer_order_rec_.ship_addr_no), attr_);
   Client_SYS.Add_To_Attr('SUPPLY_COUNTRY_DB', customer_order_rec_.supply_country, attr_);
   IF customer_order_rec_.addr_flag = 'Y' THEN       
      cust_order_add_rec_ := Customer_Order_Address_API.Get_Cust_Ord_Addr(order_no_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_FLAG_DB', 'Y', attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDRESS1', cust_order_add_rec_.address1, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDRESS2', cust_order_add_rec_.address2, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_ZIP_CODE', cust_order_add_rec_.zip_code, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_CITY', cust_order_add_rec_.city, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_STATE', cust_order_add_rec_.state, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_COUNTY', cust_order_add_rec_.county, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_COUNTRY_CODE', cust_order_add_rec_.country_code, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_NAME', cust_order_add_rec_.addr_1, attr_);
   END IF;

   IF (order_no_list_ IS NOT NULL) THEN
      WHILE (Client_SYS.Get_Next_From_Attr(order_no_list_, ptr_, name_, value_)) LOOP
         IF (name_ = 'ORDER_NO') THEN
            IF (order_no_ != value_) THEN
               add_order_no_to_rma_ := FALSE;
               EXIT;
            END IF;
         END IF;
      END LOOP;
   END IF;

   IF add_order_no_to_rma_ THEN
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   END IF;

   Return_Material_API.New(info_, attr_);
   rma_no_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('RMA_NO', attr_));
END Create_Rma_Header_From_Co;


PROCEDURE Process_Rental_Transfer_Order (
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
   attr_ VARCHAR2(2000);
BEGIN   
   Reserve_Customer_Order_API.Create_Reservations__ (order_no_,
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
                                                     qty_to_assign_,
                                                     configuration_id_,
                                                     condition_code_,
                                                     handling_unit_id_); 
   
   IF (Reserve_Customer_Order_API.Line_Is_Fully_Reserved(order_no_, line_no_, rel_no_, line_item_no_ )= 1) THEN
      -- Deliver the customer order line
      Client_SYS.Add_To_Attr('START_EVENT', 60, attr_);
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
      Client_SYS.Add_To_Attr('ONLINE_ORDRSP_PROCESSING', 'TRUE', attr_);
      Client_SYS.Add_To_Attr('RENTAL_TRANSFER_DB', 'TRUE', attr_);
      Client_SYS.Add_To_Attr('END', '', attr_);
      Customer_Order_Flow_API.Process_From_Reserve__ (attr_);                           
   END IF;
END Process_Rental_Transfer_Order;


-- Check whether the Customer Order has any unpaid advance invoices.
PROCEDURE Advance_Invoice_Pay_Check(
   block_reason_ OUT VARCHAR2,
   order_no_     IN  VARCHAR2 )
IS
   customer_rec_   Cust_Ord_Customer_API.Public_Rec;
   cust_order_rec_ Customer_Order_API.Public_Rec;
BEGIN
   cust_order_rec_ := Customer_Order_API.Get(order_no_);
   customer_rec_   := Cust_Ord_Customer_API.Get(NVL(cust_order_rec_.customer_no_pay, cust_order_rec_.customer_no));

   IF (Company_Order_Info_API.Get_Prepayment_Inv_Method_Db(Site_API.Get_Company(cust_order_rec_.contract)) = 'ADVANCE_INVOICE') THEN
      IF ((customer_rec_.adv_inv_full_pay = 'TRUE') AND
          (Customer_Order_Inv_Head_API.Check_Unpaid_Advance_Inv_Exist(order_no_))) THEN
         block_reason_ := 'BLKFORADVPAY';
      END IF;
   ELSE
      IF (Invoice_Customer_Order_API.Check_Req_Prepayments_Unpaid(order_no_) = 'FALSE') THEN
         block_reason_ := 'BLKFORPREPAY';
      END IF;
   END IF;
END Advance_Invoice_Pay_Check;

-- Customer_Order_Manual_Block
--    This method will manually block the customer order.
PROCEDURE Customer_Order_Manual_Block (
   info_             OUT VARCHAR2,
   order_no_         IN  VARCHAR2,
   block_reason_     IN  VARCHAR2) 
IS   
   ext_order_no_                 VARCHAR2(20);
   co_state_                     customer_order_tab.rowstate%TYPE; 
   int_cust_ord_block_reason_    customer_order_tab.blocked_reason%TYPE; 
   info_msg_                     VARCHAR2(32000);   
   
   CURSOR get_internal_cust_ord_no  IS
      SELECT DISTINCT order_no
      FROM   customer_order_line_tab
      WHERE  demand_code IN ('IPT', 'IPD', 'PO')
      AND    demand_order_ref1 IN (SELECT DISTINCT po_order_no
                                   FROM   customer_order_pur_order_tab
                                   WHERE  oe_order_no   = order_no_
                                   AND    purchase_type = 'O');
BEGIN   
   -- Manual block the internal customer orders. It won't block the external customer order automatically.   
   Customer_Order_Line_API.Get_External_Cust_Order(ext_order_no_, order_no_);
   IF ext_order_no_ IS NOT NULL AND ext_order_no_ != order_no_ THEN
      -- Only internal customer order will be manually blocked.
      Customer_Order_API.Set_Blocked(order_no_, block_reason_, NULL);
      co_state_ := Customer_Order_API.Get_Objstate(ext_order_no_); 
      IF co_state_ != 'Blocked' THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'EXTCONOTBLK: Pegged external customer order :P1 will not be blocked automatically.', NULL, ext_order_no_) || CLIENT_SYS.text_separator_;
      END IF;
   ELSE
      -- Manual block the external customer orders.   
      
      -- If the manual block reason is with exclude_mtrl_planning check box is selected, CO lines rel_mtrl_planning 
      -- should be unchecked only for CO status planned or released.
      Customer_Order_API.Uncheck_Rel_Mtrl_Planning(order_no_, block_reason_);
      -- Block the external customer order
      Customer_Order_API.Set_Blocked(order_no_, block_reason_, NULL);

      -- It will validate the internal customer order(s) and block conditionally         
      FOR next_ IN get_internal_cust_ord_no  LOOP            
         co_state_  := Customer_Order_API.Get_Objstate(next_.order_no);
         IF co_state_ = 'Blocked' THEN               
            info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'INTCOBLK: Pegged internal customer order :P1 is already blocked.', NULL, next_.order_no) || CLIENT_SYS.text_separator_;
         ELSIF co_state_ = 'Delivered' OR co_state_ = 'Invoiced' THEN               
            info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'INTCODEL: Pegged internal customer order :P1 will not be blocked since the order is in :P2 status.', NULL, next_.order_no, co_state_) || CLIENT_SYS.text_separator_;
         ELSE
            int_cust_ord_block_reason_ := 'BLKFORMANUALEXT';               
            info_msg_ := Language_SYS.Translate_Constant(lu_name_, 'INTCOWILLBLK: Pegged internal customer order :P1 will be blocked.', NULL, next_.order_no) || CLIENT_SYS.text_separator_;
            Customer_Order_API.Set_Blocked(next_.order_no, int_cust_ord_block_reason_, NULL);
         END IF;
         info_ := info_ || info_msg_;
      END LOOP;      
   END IF;
END Customer_Order_Manual_Block;

-- gelr:outgoing_fiscal_note, begin
PROCEDURE Start_Print_Invoice (
   start_event_   IN NUMBER,
   invoice_id_    IN NUMBER,
   company_       IN VARCHAR2,
   validatebg_    IN VARCHAR2,
   print_online_  IN VARCHAR2,
   end_           IN VARCHAR2)
IS
   parameter_attr_   VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(parameter_attr_);
   Client_SYS.Add_To_Attr('START_EVENT', start_event_, parameter_attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, parameter_attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, parameter_attr_);
   Client_SYS.Add_To_Attr('VALIDATEBG', validatebg_, parameter_attr_);
   Client_SYS.Add_To_Attr('PRINT_ONLINE', print_online_, parameter_attr_); 
   Client_SYS.Add_To_Attr('END', end_, parameter_attr_);
   Start_Print_Invoice__(parameter_attr_);
END Start_Print_Invoice;
-- gelr:outgoing_fiscal_note, end

@IgnoreUnitTest TrivialFunction
PROCEDURE Print_Order_Confirmation__ (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   Print_Order_Confirmation___(order_no_);
END Print_Order_Confirmation__;
   