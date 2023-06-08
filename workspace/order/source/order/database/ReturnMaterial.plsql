-----------------------------------------------------------------------------
--
--  Logical unit: ReturnMaterial
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210721  ChBnlk  SC21R2-2006, modified Check_Update___ by demoving duplicate message constants.
--  210302  RoJalk  Bug 156929 (SCZ-13820), Added Get_Return_Addr_Name() to fetch Return Address name.
--  201203  ErRalk  Bug 154854(SCZ-12479), Added Any_Order_Connected_Lines() to check whether the order connected RMA lines are exist for a given RMA.
--  201110  JeLise  SCZ-12157, Merged bug 155644
--  201110          ApWilk  Bug 155644 (SCZ-11198), Modified Release_Allowed___() to validate the return process when creating return transactions.
--  220711  NiDalk  SCXTEND-4446, Added Fetch_External_Tax and modified Update___ and Modify_Rma_Defaults___ to fetch taxes through a bundle call when AVALARA is used as the tax method.  
--  191008  Hairlk  SCXTEND-941, Avalara integration, Modified Insert___, Added code to fetch customer_tax_usage_type from customer if its not available in the attr.
--  190725  MaEelk  SCUXXW4-20211, Renameded the Get_Credit_Approve_Line_Status method as Approve_For_Credit_Lines
--  190723  MaEelk  SCUXXW4-20211, Modified Get_Credit_Approve_Line_Status to skip the xall to Invoice_Customer_Order_API.Get_Credited_Amt_Per_Ord_Line
--  190723          when the order_no has a null value.
--  190722  MaEelk  SCUXXW4-20211, Added WHERE Clause order_no IS NOT NULL to the cursor in Check_Line_Conn_Promo_Exist to skip rma lines not having an order no.
--  190712  MaEelk  SCUXXW4-20211, Re-structured the logic in Get_Customer_Address_Details__, Get_Rma_Customer_Defaults__ and  Get_Rma_Contract_Defaults__.
--  190701  MaEelk  SCUXXW4-20211, Modified Calculate_Totals to improve performance.
--  190523  MaEelk  SCUXXW4-20211, Added address information to Return_Material_API.Header_Information
--  190226  IzShlk  SCUXXW4-16810, Added Funtion Calculate_Totals() to support totals in ReturnMaterialAuthorizationHandling Projection.
--  181126  MaEelk  SCUXXW4-9372 Modified Prepare_Insert___ and added SUPPLY_COUNTRY_DB when it the method is called from a ODP Session.
--  181030  DilMlk  Bug 143810(SCZ-922), Modified Build_Attr_Supp_Rma_Head___() to fetch correct TAX_LIABILITY when creating receipt RMA.
--  180409  SBalLK  Bug 135006, Modified Check_Common___() method to fetch Customer Order Delivery Address or Shipment Delivery Address when Order ID or Shipment ID used accordingly in RMA.
--  180221  SucPlk  STRSC-17052, Added handling_unit_id to received_rma_rec. Modified Automatic_Process_Rma to use the value for handling_unit_id
--  180221          from received_rma_rec.
--  171016  DiKuLk  Bug 138039, Modified message constant of Check_Update___() from NOUPDAPPROV to NOUPDATECOORDINATOR to avoid overriding of language translations.
--  170926  RaVdlk  STRSC-11152,Removed Get_State and Get_Objstate functions, since they are generated from the foundation
--  160923  DilMlk  Bug 131547, Modified Inquire_Operation__ by removing tres_ variable which stores line number information to prevent getting a buffer overflow error
--  160923          while attempting to create a credit invoice for RMA with more than 40 lines.
--  160907  ApWilk  Bug 131231, Modified Refresh_State() to stop getting clear the info message when adding a new line into the Return Material Line table.
--  160809  TiRalk  STRSC-3812, Modified Validate_Order_No___ by avoiding the error for the Orders which are blocked from state PartiallyDelivered state.
--  160725  RoJalk  LIM-8141, Replaced the usage of Shipment_Line_API.Source_Exist with Shipment_Line_API.Source_Ref1_Exist.
--  160607  RoJalk  LIM-6975, Replaced the usage of Shipment_API.Get_State with Shipment_API.Get_Objstate.
--  160601  MAHPLK  FINHR-2018, Removed Validate_Tax_Calc_Basis___.
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  160516  reanpl  STRLOC-58, Added handling of new attributes address3, address4, address5, address6 
--  160426  RoJalk  LIM-6631, Modified get_ship_lines cursor in Validate_Shipment_Id___ to include NVL handling.
--  160419  IsSalk  FINHR-1589, Move server logic of RmaLineTaxLines to common LU (Source Tax Item Order)
--  160202  ThEdlk  Bug 126845, Modified Release_Allowed___(), Validate_Retn_To_Vendor_No___() and Modify_Rma_Line_Po_Info___() by changing the conditions of the error messages that raise 
--  160202          to validate the supplier entered in the RMA field with the Customer Order connected PO supplier in a Purch Order Dir flow.
--  160122  MaRalk  LIM-4161, Modified method Validate_Shipment_Id___ by moving the logic of Shipment_API.Rma_Connection_Allowed. 
--  160111  RoJalk  LIM-5816, Replaced Shipment_Line_API.Order_Exist_In_Shipment with Shipment_Line_API.Source_Exist
--  151110  KiSalk  Removed duplicated code from New and moved bug 122833 correction to Build_Attr_For_New___.
--  151110  MaIklk  LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  150910  NaLrlk  AFT-1529, Modified Automatic_Process_Rma() to stop creating demobilization WO when from rental transfer.
--  150907  NaLrlk  AFT-1515, Modified Check_Update___() to restrict rental lines when return to site is different site.
--  150619  ChBnlk  ORA-810, Modified Create_Supply_Site_Rma_Header() and New()by moving the attribute string manipulation to seperate methods. 
--  150619          Introduced new methods Build_Attr_Supp_Rma_Head___ and Build_Attr_For_New___.
--  150526  JaBalk  RED-361, Added Automatic_Process_Rma to create RMA and receive into inventory automatically.
--  150529  ChJalk  Bug 122833, Modified the method New to get the value of SUPPLY_COUNTRY from the attribute string if it has been sent.
--  150215  NaLrlk  PRSC-5900, Modified Get_Total_Base_Line__, Get_Total_Base_Line_Gross__, Get_Total_Sale_Line__, Get_Total_Sale_Line_Gross__, Get_Total_Base_Charge__
--  150215          Get_Total_Base_Charge_Gross__, Get_Total_Sale_Charge__, Get_Total_Sale_Charge_Gross__, Approve_For_Credit__ to exclude Cancelled RMA lines.
--  150127  Hairlk  PRSC-5400, Modified the error message in RMANOORDERNO
--  150112  IsSalk  Bug 120458, Modified Create_Supply_Site_Rma_Header() to avoid errors when releasing RMA with return to site is different than RMA site
--  150112          and CO supply code is in IPT, PD, and PT.
--  150102  ChJalk  PRSC-4834, Modified Release_Allowed___ to add the error message RMARELEASENOTALLOWEDTOFIELDSNULL. 
--  141216  KoDelk  PRSC-4626, Modified Validate_Tax_Calc_Basis___() to user the internal customers delivery address id when fetching the tax_regime_db_ value.
--  141209  ShKolk  PRSC-4290, Modified Restrict_Multi_Site_Update___() to restrict updating return_addr_flag on a Multi Site RMA header.
--  141028  SlKapl  PRFI-3039 - replaced Return_Material_Line_API.Get_Total_Tax_Amount by Return_Material_Line_API.Get_Total_Tax_Amount_Curr and
--                  Return_Material_Charge_API.Get_Total_Tax_Amount by Return_Material_Charge_API.Get_Total_Tax_Amount_Curr
--  140908  ShVese  Removed unused cursor get_charge_percents from Get_All_Totals.
--  140514  NIWESE  PBSC-8638 Added call to custom validation for Cancel Reason codes.
--  140509  ChFolk  Modified Create_Supply_Site_Rma_Header to get the doc address from internal customer when document address is not defined in internal CO.
--  140507  MeAblk  Modified Create_Supply_Site_Rma_Header in order to raise an error message when the return from site is not connectd an internal customer.
--  140507  ChFolk  Modified Cancel_All_Lines___ to add Denied state to the cursor when selecting the lines to be cancelled.
--  140502  UdGnlk  PBSC-8181, Mergd bug 115917, Removed method Check_Exp_Conn_And_Auth and added Is_Expctr_Connected to return true if the RMA is connected to an export license.
--  140331  RoJalk  Modified All_Lines_Planned_Or_Denied___ to include Cancelled state to be able to Deny in the header even when cancelled lines exist.
--  140206  ChFolk  Modified All_Lines_Completed___ to ignore Cancelled lines when setting the state Return Completed.
--  140303  NWeelk  Bug 113825, Added derived attribute disconnect_exp_license, Added method Check_Exp_Conn_And_Auth to enable changing
--  140303          license date when changing the date_requested if it is within the accepted range of the license.
--  140227  ChFolk  Modified Create_Supply_Site_Rma_Header to add value for use_price_incl_tax.
--  131121  NaLrlk  Modified Validate_Order_No___() to include for rental lines.
--  131107  MaMalk  Changed the length of rma_report_printed_db, supply_country_db, ship_addr_flag_db, return_addr_flag_db in view comments and made language_code mandatory.
--  130830  HimRlk  Modified Check_Delete___ by removing error messages.
--  130828  ChFolk  Modified attribute latest_return_date from private to public. Modified Unpack_Check_Update to replicate change of latest_return_date from demand site to supply site rma.
--  130826  ChFolk  Added new method Credit_Approved which checks at least one rma line is credit approved. Modified Unpack_Check_Update___ to allow to change the corrdinator
--  130826          even if in release state until the rma is credit approved.
--  130823  ShKolk  Modified Unpack_Check_Update___ to enable updating note_text even the RMA is in cancelled state.
--  130822  SURBLK  Added a validation in to Unpack_Check_Insert, Unpack_Check_Update to make sure that latest return date is greater than date requested.
--  130816  ChFolk  Modified Validate_Shipment_Id___ to correct state name Completed instead of Complete.
--  130814  JeeJlk  Modifed Unpack_Check_Update___ to reflect the single occurence address chages to receipt site.
--  130709  ChJalk  TIBE-1015, removed the global variables inst_CcCaseTask_, inst_jinsui_, inst_CcCaseBusinessObject_, inst_CcCaseSolBusinessObj_ and inst_CcSupKeyBusinessObj_.
--  130620  ChFolk  Added new method Modify_Rma_Line_Po_Info___ which updates rma line po information when rma header return_to_contract or return_to_vendor is changed.
--  130620          Modified Update___ to modify rma line po info when rma header return_to_contract or return_to_vendor is changed.
--  130618  ChFolk  Modified Release_Allowed___ to change the condition and message when supplier return reason is null.
--  130613  JeeJlk  Modified Validate_Retn_To_Vendor_No___ and Validate_Return_To_Contract___ so that materials can be return to any site as long as return_to_site
--  130613          and site within the same company.
--  130612  ChFolk  Modified Create_Supply_Site_Rma_Header to support creation of receipt RMA header when return to any site.
--  130612  JeeJlk  Modified Release_Allowed___, Validate_Return_To_Contract___ to return to any site when return_to_site and site are in the same company.
--  130507  JeeJlk  Added a new method Validate_Ship_Via_Del_Term___ to validate whether Ship Via Code and Delivery Term is mandatory. Modified
--  130507          Unpack_Check_Update___ and Create_Supply_Site_Rma_Header not to replicate Ship Via Code and Delivery Term to Receipt RMA. Removed
--  130507          logic fetching of default data to ship via and delivery term.
--  130426  ChFolk  Modified Get_Allowed_Operations__ to enable Release rmb without checking value for return_approver_id. Modified Release_Allowed___
--  130426          to raise an error message when return_approver_id is null.
--  130426  ChFolk  Added restricted reference to originating_rma_no and receipt_rma_no.
--  130401  UdGnlk  Added a parameter Return to Vendor No to Validate_Return_To_Contract___(). To raise an error on condition.
--  130329  UdGnlk  Modified Release_Allowed___() to change the condition of supply code from PD to IPD.
--  130327  ChFolk  Modified Unpack_Check_Insert___ to add default ship_via_code and delivery_terms from the rma customer when it is null.
--  130325  ChFolk  Modified Create_Supply_Site_Rma_Header to pass ship_via_code and delivery_terms from demand site to supply site when creating supply site rma.
--  130322  UdGnlk  Modified Release_Allowed___() to check for supplier return reason and Get_Allowed_Operations__() to RMB enable/disable.
--  130319  UdGnlk  Modified Finite_State_Machine___() to restructure a IF condition added for cancellation functionality.
--  130228  UdGnlk  Modified Release_Allowed___() and Restrict_Multi_Site_Update___() to check for NULL in IF condition.
--  130218  ChFolk  Removed method Create_Supply_Site_Rma___ asit is handled from the rma line.
--  130215  UdGnlk  Added Modify_Supply_Site_Rma___() and Restrict_MultiSite_Upd___() to replicate changes from deman site RMA to supply site RMA.
--  130215  ChFolk  Modified Create_Supply_Site_Rma_Header to get the tax_liability and Vat from the internal cutomer and ship_address instead of external customer same as it is done in internal CO.
--  130213  UdGnlk  Modified Release_Allowed___() to validate return to supplier and connected customer order functionality when releasing.
--  130211  ChFolk  Added new method Create_Supply_Site_Rma_Header which contains creation of supply site rma header. Modified Create_Supply_Site_Rma___ to use new method.
--  130211  UdGnlk  Modified Get_Allowed_Operations__() to restrict cancel and denied RMB's for supply site RMA in multi site functionality.
--  130208  ChFolk  Modified Validate_Return_Addr_No___ to validate return_to_address when multi site return is done. Modified Validate_Return_Addr_No___ to validate the return to address
--  130208          from the delivery address of the company connected to the return to contract.
--  130207  UdGnlk  Modified Return_To_Contract from private to public attribute. Added attributes to view RETURN_MATERIAL_JOIN_UIV.
--  130206  ChFolk  Modified Validate_Retn_To_Vendor_No___ to validate entered supplier when multi site return is done.
--  130201  ChFolk  Added new method Create_Supply_Site_Rma___ to create a new RMA in suppy site when releasing the rma in ordering site. Added new method Set_Receipt_Rma_No__ to set
--  130201          the value of receipt_rma_no in original rma.
--  130128  ChFolk  Added new attribute return_from_customer_no and update using existing values from customer_no. Replaced usages of customer_no in delivery address with return_from_customer_no.
--  130109  ChFolk  Modified Finite_State_Machine___ to set header state Denied at least one line(including charge line) in Denied status and all other lines in Cancelled state.
--  121126  UdGnlk  Modified Validate_Retn_To_Vendor_No___() to check only if order is line connected.
--  121121  GanNLK  Modified procedure Validate_Order_No___() to validate charge lines.
--  121101  GanNLK  Added procedure Has_Charge_Line___ to check charge line existence when changing to the cancel state and to display the error message.
--  121101  UdGnlk  Added methods Is_Release_Allowed() and Release_Allowed___() to valiidate return to supplier whether it is allowed to Release.
--  121101          Modified Finite_State_Machine___() adding an action ReleaseAllowed. Modified Validate_Retn_To_Vendor_No___().
--  121024  UdGnlk  Added Validate_Retn_To_Vendor_No___() to validate return to vendor no and modified accordingly.
--  121019  UdGnlk  Modified Return_To_Vendor_No from private to public attribute and changed accoringly.
--  121004  ChFolk  Modified ship_addr_city, ship_addr_state, ship_addr_zip_code and ship_addr_county as public to be used for tax calculation and do the related changes.
--  121003  ChFolk  Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to validate tax liability by using delivery country code for single occurence address.
--  120925  SURBLK  Modified Get_All_Totals by adding charge_total_gross_curr_and added new methods Get_Total_Sale_Charge_Gross__, Get_Total_Base_Charge_Gross__.
--  120919  SURBLK  Added unit_price_incl_tax and base_unit_price_incl_tax to VIEWJOINUIV.
--  120918  ShKolk  Added functions Get_Total_Sale_Line_Gross__ and Get_Total_Base_Line_Gross__. Modified Get_All_Totals() to return gross values.
--  120921  ChFolk  Added new public attributes ship_via_code, delivery_terms and intrastat_exempt to be used as intrastat infomation when
--  120921          RMA line is not order connected and RMA header is single occurence.
--  120920  UdGnlk  Modified Unpack_Check_Insert___(), Unpack_Check_Update___() and added Exist_Return_To_Vendor_No___() to check
--  120920          return_to_vendor_no is exists with dynamic code.
--  120920  ChFolk  ship_addr_country_code was made public and do the necessary changes
--  120917  GanNLK  Modified Unpack_Check_Insert___() and Unpack_Check_Update___() to raise error when invalid supplier address entered.
--  120911  JeeJlk  Added new column USE_PRICE_INCL_TAX.
--  120911  UdGnlk  Added private attributes return_addr_country_code, return_addr_name, return_address1,
--  120911          return_address2, return_addr_zip_code, return_addr_city, return_addr_state and return_addr_county.
--  120911          Modified methods accordingly.
--  120821  NaLrlk  Modified Finite_State_Machine___()  and added All_Lines_Denied_Or_Cancel___() to denied header.
--  120815  NaLrlk  Modified Validate_Order_No___(), Validate_Shipment_Id___ to exclude Cancelled and Denied RMA lines.
--  120813  NaLrlk  Modified Unpack_Check_Update___() to raise error when change Cancelled RMA.
--  120813  NaLrlk  Removed Log_Event___() and Modified Finite_State_Set___() and Insert___() to add the insertion of history log.
--  120810  UdGnlk  Modified Prepare_Insert___() to get default value for return_to_contract.
--  120808  ChFolk  Added new public attributes ship_addr_flag and return_addr_flag and modified methods accordingly.
--  120807  UdGnlk  Added Return_To_Vendor_No and Return_To_Contract private attributes and modified accordingly.
--  120806  ChFolk  Modified Unpack_Check_Update___() to remove the error message when modifying the cancelled rma as it is same as in customer order.
--  120731  UdGnlk  Modified Unpack_Check_Update___() to raise an error for cancellation logic.
--  120727  ChFolk  Modified Validate_Order_No___ to validate if different order_no is entered in RMA header.
--  120724  ChFolk  Addded new method Validate_Shipment_Id___ to validate the entered shipment_id in RMA.
--  120724  ChFolk  Added new method Validate_Order_No___ to validate the entered order_no in RMA.
--  120724  UdGnlk  Modified Get_Allowed_Operations__() to check what operations are allowed for Cancel RMB.
--  120724  UdGnlk  Modified Finite_State_Machine___() and added All_Lines_Cancel___() to support cancellation from header to lines and vice versa.
--  120723  UdGnlk  Modified Get_Allowed_Operations__() to check for credit allows for RMB Cancel and Finite_State_Machine___()
--  120723          to cancel lines. Added Cancel_All_Lines___().
--  120718  GanNLK  Added Cancel RMB
--  120717  ChFolk  Modified Finite_State_Machine___ to log event transition to cancel state.
--  120716  ErFelk  Added Order_No and Shipment_Id to Unpack_Check_Insert___, Insert___, Unpack_Check_Update___ and Update___.
--  120713  ChFolk  Added new method Set_Cancel_Reason which use to update the cancel reason in rma header.
--  120713  ErFelk  Added cancel_reason to RETURN_MATERIAL_JOIN_UIV view.
--  120712  ErFelk  Added Cancel_Reason to Unpack_Check_Insert___, Insert___, Unpack_Check_Update___ and Update___.
--  120711  ChFolk  Introduced new state Cancel and do necessay changes in Finite_State_Machine___. Allowed to cancel from Planned and Released states.
--  130912  SBalLK  Bug 112260, Modified Unpack_Check_Update___() method to validate export control connection when DATE_REQUESTED, CUSTOMER_NO_ADDR_NO, SHIP_ADDR_NO, SUPPLY_COUNTRY, SUPPLY_COUNTRY_DB
--  130912          attributes are change. Restructured export control codes.
--  130717  PraWlk  Bug 111158, Modified Check_Delete___() by adding conditional compilation instead of dynamic method calls.
--  130507  IsSalk  Bug 109597, Added Credit_Approve_Allowed___() and modified Get_Allowed_Operations__() to check the availability of RMB Approve for Credit functionality.
--  130218  SudJlk  Bug 108372, Modified Set_Rma_Printed__ to reflect length change in RETURN_MATERIAL_HISTORY_TAB.message_text.
--  130122  AwWelk  Bug 107413, Modified Unpack_Check_Update___() to update the license date in export license connect header if the date_requested has been changed.
--  121121  SWiclk  Bug 106608, Moved RETURN_MATERIAL_JOIN and RETURN_MATERIAL_JOIN_UIV views into ReturnMaterialLine.apy hence removed definitions of
--  121121          LINEOBJVERSION, LINEPKG, VIEWJOIN and VIEWJOINUIV.
--  120626  Darklk  Bug 103631, Modified the procedure New() in order to avoid the error when the document address is null in the CO. Modified Unpack_Check_Insert___
--  120626          and Unpack_Check_Update___ to validate the document address.
--  120629  NipKlk  Bug 102950, Added Check_Reference_Exist method calls in Check_Delete___  to validate if a Business Object Reference exists.
--  120313  MoIflk  Bug 99430, Added column inverted_conv_factor to the view RETURN_MATERIAL_JOIN and RETURN_MATERIAL_JOIN_UIV.
--  120220  MaMalk  Modified Approve_Charges__ and Remove_Credit_Approval__ to remove logging of history since this is handled in RMA Lines and Charges.
--  120126  ChJalk  Modified the view comments of supply_country and company columns in the base view.
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111205  MaMalk  Added pragma to Get_All_Totals and Get_Allowed_Operations__.
--  110930  MoIflk  Bug 99174, Modified Check_Debit_Inv_Numbers___ to allow, if none of the RMA Part lines have any Debit Invoice reference
--  110930          then should not consider the RMA Charge lines as having any Debit Invoice reference.
--  110914  HimRlk  Bug 98108, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ by changing the Exist check of document addresses to Customer_Info_Address_API.
--  110914          Changed the reference of customer_no_addr_no and customer_no_credit_addr_no to CustomerInfoAddress in base view.
--  110519  NWeelk  Bug 94874, Modified method Get_Rma_Total_Tax_Amount to calculate total_tax_amount_ correctly.
--  110514  MaMalk  Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to remove the messages given when no tax free tax code is found
--  110514          since the tax free tax code retrieval is based on the line delivery type used.
--  110420  MaMalk  Added Delivery_Type to views RETURN_MATERIAL_JOIN and RETURN_MATERIAL_JOIN_UIV.
--  110404  MaMalk  Modified Unpack_Check_Update___ to take the Iso_Country_API.Exist check out of the loop.
--  110304  MaMalk  Modified method New to get the supply country based on the contract passed.
--  110131  Nekolk  EANE-3744  added where clause to View RETURN_MATERIAL ,RETURN_MATERIAL_JOIN
--  110127  MaMalk  Added methods Get_Ship_Addr_Country and Get_Supply_Country_Db.
--  110125  MaMalk  Added tax liability to the RMA Header.
--  110106  Mohrlk  Added Supply_Country as an attribute.
--  101229  ChFolk  Added new function Check_Line_Conn_Promo_Exist to check at least one rma line connected order line is linked to a sales promotion line.
--  101104  SudJlk  Bug 93894, Added attribute Company to the view RETURN_MATERIAL and modified methods Prepare_Insert___, Unpack_Check_Insert___
--  101104          and Unpack_Check_Update___.
--  100830  JuMalk  Bug 92678, Added return material history record when the RMA is approved for credit and removing approval.
--  100830          Modified methods Approve_Charges__ and Remove_Credit_Approval().
--  100527  ShVese  Changed the code in Finite_State_Machine___ to match dev studio generated code by changing a 'Not' condition to 'NOT'.
--  100517  KRPELK  Merge Rose Method Documentation.
--  100721  AmPalk  Bug 92005, Changed New to give priority to passed in ship_addr_No and customer_no_addr_no.
--  100212  SuTHlk  Bug 88694, Added code segment in New() to get vat information of the customer.
--  100105  MaRalk  Modified the state machine according to the new developer studio template - 2.5.
--  091208  MaRalk  Added reference CustOrdCustomer to customer_no_credit column in RETURN_MATERIAL view and
--  091208          modified Unpack_Check_Insert___ and Unpack_Check_Update___ accordingly.
--  090930  MaMalk  Removed unused function All_Lines_Credit_Invoiced___ and constant state_separator_. Removed unused code in Finite_State_Init___.
--  ------------------------- 14.0.0 ------------------------------------------
--  100309  KiSalk  Re-wrote Get_Total_Sale_Charge__ to consider percentage charges.
--  090922  AmPalk  Bug 70316, Modified Get_All_Totals, Get_Total_Base_Charge__ and Get_Total_Base_Line__ to calculate the base amount using curr amount as in the invoice.
--  090922          Modified Get_Total_Base_Line__ to calculate total in base currency from RMA Line if the rounding settings are different.
--  090922          Changed Get_All_Totals to round total in base currency values accordingly to the decimal setting of company currency.
--  090922          In same method corrected the charge_total_base_ calculation. Modified Unpack_Check_Insert___ to add 'CURRENCY_ROUNDING' to the attr string.
--  090922          Modified Get_Total_Base_Charge__ to tally with CO charge base total.
--  090415  MaMalk  Bug 81620, Modified Get_All_Totals to return the correct base amounts.
--  090219  NWeelk  Bug 80212, Modified Procedure New to check the currency_code_.
--  090128  MaRalk  Bug 76921, Added functions Check_Debit_Inv_Numbers___ and Check_Debit_Inv_Numbers.
--  090128          Removed the function Check_Debit_Inv_Numbers__.
--  081215  ChJalk  Bug 77014, Modified Get_Total_Base_Line__ and Get_All_Totals replacing base_sale_unit_price with sale_unit_price * currency_rate.
--  081215          Also modified and added General_SYS.Init_Method to Get_All_Totals.
--  081008  SaRilk  Bug 76926, Added procedure Disconnect_Case_Task.
--  080624  MaRalk  Bug 74036, Modified function Check_Debit_Inv_Numbers__ in order to change the logic with some extra scenarios.
--  080623  ThAylk  Bug 73937, Modified function Check_Delete___ to stop deleting Return Material Authorization which connected to Case and Task.
--  080701  MaJalk   Merged APP75 SP2.
--  --------------------- APP75 SP2 Merge - End -------------------------------
--  080307  NaLrlk  Bug 69626, Increased the length of the cust_ref column to 30 in views RETURN_MATERIAL and RETURN_MATERIAL_JOIN.
--  --------------------- APP75 SP2 Merge - Start -----------------------------
--  080617  JeLise  Added rebate_builder and rebate_builder_db to RETURN_MATERIAL_JOIN.
--  ********************************* Nice Price ******************************
--  070626  MaJalk  Bug 65917, Removed the check for records in Cancelled state, in the cursor get_lines in the
--  070626          method Get_Rma_Total_Tax_Amount, since there is no such state in the corresponding state machine.
--  070626  MaJalk  Bug 65917, Modified the cursor get_lines in the method Get_Rma_Total_Tax_Amount.
--  070321  WaJalk  Bug 63429, Added Function Check_Debit_Inv_Numbers__.
--  070221  WaJalk  Bug 61985, Increased the length of column PURCHASE_ORDER_NO to 50 in view RETURN_MATERIAL_JOIN.
--  060608  MaMalk  Added function Is_Create_Credit_Allowed__.
--  060605  PrKolk  Bug 58370, Corrected Description of procedure Lock_By_Keys__.
--  060601  MiErlk  Enlarge Identity - Changed view comments - Description.
--  060601  PrKolk  Bug 58370, Added procedure Lock_By_Keys__.
--  060525  MaMalk  Removed method All_Approved_Connected___.
--  060524  MaMalk  Modified method Get_Allowed_Operations__ in order to enable RMB create credit invoice if atleast
--  060524          one RMA line or charge lines is approved.
--  060522  MaMalk  Added method Approve_Charges__. Modified All_Lines_Approved___ to exclude the RMA Lines
--  060522          and Charges in 'Planned' state from approval.
--  060522  NuFilk  Bug 57771, Restructured the method Get_Tot_Charge_Sale_Tax_Amt.
--  060517  MiErlk   Enlarge Identity - Changed view comment
--  060516  MiErlk  Enlarge Identity - Changed view comment
--  060503  JaBalk  Changed the parameter of Check_Exist_Rma_For_Invoice method.
--  060428  JaBalk  Modified Get_Allowed_Operations__ to handle status for RMB Create Correction Invoice.
--  060426  JaBalk  Added condition to enable Correction Invoice RMB in Get_Allowed_Operations__.
--  064024  MiKulk  Added the methods Check_Exist_Rma_For_Order and Check_Exist_Rma_For_Invoice
--  060424  NuFilk  Bug 54676, Added derived attribute update_line_taxes. Also added Modify_Rma_Defaults___
--  060424          and Child_Tax_Update_Possible__. Removed Update_Tax_Lines_For_Addr___.
--  060424          Modified Unpack_Check_Update___ and Update___.
--  060419  IsWilk  Enlarge Customer - Changed variable definitions.
--  060418  MaJalk  Enlarge Identity - Changed view comments customer_no_credit.
--  060412  RoJalk  Enlarge Identity - Changed view comments.
--  -------------------- 13.4.0 -----------------------------------------------
--  060328  KanGlk  Modified Get_Rma_Total_Tax_Amount function.
--  060327  KanGlk  Modified Get_Rma_Total_Tax_Amount function.
--  060225  SuJalk  Modified the prepare insert method to add VAT_DB and JINSUI_INVOICE_DB to the attr.
--  060130  MaJalk  Bug 55610, Reverse the correction done by bug 54677, to
--  060130          retrive the totals when invoices are connected to RMA.
--  060124  JaJalk  Added Assert safe annotation.
--  060119  SaJjlk  Added the returning clause to method Insert___.
--  051213  MaJalk  Bug 54677, Modified functions Get_Total_Base_Line__, Get_Total_Sale_Line__.
--  051124  MaJalk  Bug 54677, Modified function Get_All_Totals to calculate RMA line totals using CO line values.
--  050802  SaMelk  Modified the method Validate_Jinsui_Constraints___.
--  050713  MaMalk  Bug 52428, Increased the length of variable vat_free_vat_code_ in Unpack_Check_Insert___.
--  050713  SaMelk  Modified the method Validate_Jinsui_Constraints___.
--  050712  SaMelk  Put a dynamic call to the function Js_Customer_Info_API.Get_Create_Js_Invoice.
--  050711  SaLalk  Bug 51171, Added catalog_desc to RETURN_MATERIAL_JOIN.
--  050705  SaMelk  Added new method Validate_Jinsui_Constraints___ and new function Jinsui_Order_is_Connected___.
--  050704  SaMelk  Modified Methods Unpack_Check_Insert___ , Insert___, Unpack_Check_Update___ and Update___.
--  050629  SaMelk  Added new functions 'Get_Jinsui_Invoice' and 'Get_Jinsui_Invoice_Db'.
--  050629  SaMelk  Added JINSUI_INVOICE public not null attribute to the RETURN_MATERIAL view.
--  050526  SaLalk  Bug 49825, Changed the condition on vat in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  050503  NiRulk  Bug 50401, Removed method All_Lines_In_State___ and moved the required logic to calling functions,
--  050503          All_Lines_Denied___ and All_Lines_Completed___. Included event 'RefreshState' to 'Denied' state.
--  041213  KiSalk  Added method Update_Tax_Lines_For_Addr___ and called in Update___.
--  041123  KanGlk  Modified function Get_Gross_Amount.
--  041104  JaJalk  Modified Finite_State_Set___ to update the call center accordingly.
--  041025  KiSalk  Added attributes task_id, case_id and functions Get_Case_Id, Get_Task_Id.
--  041022  NaWalk  Added the function Get_Tot_Charge_Sale_Tax_Amt.
--  041019  KiSalk  Added methods Get_State  and New.
--  041019  NaWalk  Added functions Get_Rma_Total_Tax_Amount and Get_Gross_Amount.
--  040224  IsWilk  Removed SUBSTRB from the views for Unicode Changes.
--  ----------------EDGE Package Group 3 Unicode Changes------------------------
--  030904  PrTilk  Modified methods All_Lines_Approved___, Get_Allowed_Operations__, Remove_Credit_Approval__
--  030904          to exclude the exchane and no charge order lines.
--  030903  PrTilk  Modified methods All_Lines_Approved___, Get_Allowed_Operations__.
--  030820  PrTilk  Added condition_code to the RETURN_MATERIAL_JOIN view.
--  021021  JoAnSe  Removed condition_code from the RETURN_MATERIAL_JOIN view.
--  020919  JoAnSe  Merged the IceAge bugg corrections below onto the AD 2002-3 track.
--  020903  JoAnSe  Bug 32545 Corrected roundings in Get_Total_Base_Charge__, Get_Total_Base_Line__,
--  020903          Get_Total_Sale_Charge__, Get_Total_Sale_Line__ and Get_All_Totals.
--  020620  MIGUUS  Bug 31041, Modified All_Lines_In_State___ to exclude any check of Charges.
--  020515  Miguus  Bug fix 29259, Modified cursor get_incorrect_line in All_Lines_In_State___ to changed RMA
--                  state if all lines are completed or denied.
--  ---------------------------------- IceAge Merge End ------------------------------------
--  020618  MaEelk  Modified comments on CONDITION_CODE in RETURN_MATERIAL_JOIN.
--  020621  MaEelk  Added CONDITION_CODE to the view RETURN_MATERIAL_JOIN.
--  -------------------------------- AD 2002-3 Baseline ------------------------------------
--  011011  MaGu    Bug fix 24887. Removed the corrections from bug fix 19897 in methods
--                  Get_Total_Base_Line__ and Get_Total_Sale_Line__, so that price conversion factor will
--                  be used also for component parts.
--  010421  IsWilk  Bug Fix 19897, Modified the FUNCTION's get_total_base_line__, get_total_sale_line__ and
--                  removed the corrections in PROCEDURE Get_All_Totals.
--  010406  IsWilk  Bug Fix 19897, Modified the FUNCTION's get_total_base_line__, get_total_sale_line__ and
--                  modified the PROCEDURE Get_All_Totals.
--  001211  JoEd  Changed Set_Rma_Printed so that it only updates the printed flag once.
--  001027  JakH  Added Confguration ID joined view
--  000913  FBen  Added UNDEFINED.
--  000322  JakH  Added Get_Vat_Db
--  000229  JakH  Added logic to cope with allowed operations and non credited lines.
--  000228  JakH  Added refreshing logic  when approver ID is changed.
--  000225  JakH  Added price conv factor to sale total calculation for lines
--  000225  JakH  Added Get_All_Totals that fetches totals for lines and charges
--                and the rma total in both currencies.
--  000224  JakH  Added checks for updates of customer_no_credit checking if
--                already enetered lines are connected to order lines with
--                another payer.
--  000223  JakH  Added Checks when inserting currency code.
--                Added NOTE_ID to attr_ in insert___
--                Added validation for Currency.
--  000222  DaZa  Made note_id public. Added customer_no_addr_no and vat to VIEWJOIN.
--  000221  JakH  Filtered out invoiced lines and charges when adding and
--                removing credit approver.
--  000126  JakH  Init_Method fixes.
--  000125  JakH  Removing demand for connections to orders.
--  000118  JakH  Added a check in Unpack_Check_Insert___ and
--                Unpack_Check_Update___ to see whether 'vat free vat code'
--                is not blank for a vat paying customer when 'pay vat' is
--                unticked in the form frmMiscelleanous.
--  000113  JakH  Added Vat-flag, credited customer and adress numbers
--  991228  JakH  Added entries in RMA history.
--  991220  JakH  Removed invoicing routine, moved it to InvoiceCustomerOrder
--  991203  JakH  Added Get_Objstate function and Log_Event
--  991201  JakH  Added functions for fetching totals in sales and base currency
--  991129  JakH  Added Notes, Document tex and language code attributes
--  ------  ----  2000C release ---------------------------------------------
--  991112  JakH  CID 28228. Completing probs fixed.
--  991111  JakH  Changed Company length to 20.
--  991110  JakH  Made check against any updates in state denied.
--  991110  JakH  CID 27490 Corrected Inquire_Operation__ to return TRUE
--                instead of null
--  991109  JakH  CID 26783 Added state transition from released to planned if
--                all lines are denied or planned.
--  991108  JakH  CID 26779 Automatic transition to state denied if all lines
--                are denied. Added function All_Lines_In_State___
--  991105  JakH  Made all rma lines to get credit invoiced if crediting rma head.
--  991102  JakH  CID 25329, in inquire operation for crediting return which
--                rma lines that have not been invoiced prior to crediting
--  991101  JakH  CID 25325, 26780, etc added controls and warnings.
--  991028  JakH  Added set printed method.
--  991028  JakH  Changed Closed to ReturnCompleted, added RmaReportPrinted
--  990930  JakH  Added joined view.
--  990818  JakH  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE received_rma_rec IS RECORD
   (configuration_id  VARCHAR2(50),     
    location_no       VARCHAR2(35),
    lot_batch_no      VARCHAR2(20),
    serial_no         VARCHAR2(50),
    eng_chg_level     VARCHAR2(6),
    waiv_dev_rej_no   VARCHAR2(15),
    handling_unit_id  NUMBER,
    part_ownership    VARCHAR2(20),
    owning_vendor_no  VARCHAR2(20),
    received_qty      NUMBER,
    condition_code    VARCHAR2(50));
TYPE received_rma_table IS TABLE OF received_rma_rec INDEX BY BINARY_INTEGER;

TYPE address_rec IS RECORD
   (address1 VARCHAR2(35),
    address2 VARCHAR2(35),
    address3 VARCHAR2(100),
    address4 VARCHAR2(100),
    address5 VARCHAR2(100),
    address6 VARCHAR2(100),
    city     VARCHAR2(35),
    state    VARCHAR2(35),
    zip_code VARCHAR2(35),
    county   VARCHAR2(35),
    country  VARCHAR2(2)) ;
    
TYPE Calculated_Totals_Rec IS RECORD (
   total_line_base         NUMBER,
   total_charge_base       NUMBER,
   total_amount_base       NUMBER,
   total_line_curr         NUMBER,
   total_charge_curr       NUMBER,
   total_amount_curr       NUMBER,
   total_line_tax_curr     NUMBER,
   total_charge_tax_curr   NUMBER,   
   toatal_tax_amount_curr  NUMBER,
   total_line_gross_curr   NUMBER,
   total_charge_gross_curr NUMBER,
   total_gross_amount_curr NUMBER,
   charge_exist            NUMBER);
   
TYPE Calculated_Totals_Arr IS TABLE OF Calculated_Totals_Rec;

TYPE header_information_rec   IS RECORD (
   return_to_company          VARCHAR2(20),
   external_tax_cal_method    VARCHAR2(50),
   delivery_country           VARCHAR2(2),
   child_tax_update_possible  NUMBER,
   expctr_connected           VARCHAR2(5),
   address_name               VARCHAR2(100),
   address1                   VARCHAR2(35),
   address2                   VARCHAR2(35),
   address3                   VARCHAR2(100),
   address4                   VARCHAR2(100),
   address5                   VARCHAR2(100),
   address6                   VARCHAR2(100),
   zip_code                   VARCHAR2(35),   
   city                       VARCHAR2(35),
   state                      VARCHAR2(35),   
   county                     VARCHAR2(35),
   country_code               VARCHAR2(2),
   return_addr_name1          VARCHAR2(100),
   ret_address1               VARCHAR2(35),
   ret_address2               VARCHAR2(35),
   ret_address3               VARCHAR2(100),
   ret_address4               VARCHAR2(100),
   ret_address5               VARCHAR2(100),
   ret_address6               VARCHAR2(100),
   ret_addr_zip_code          VARCHAR2(35),   
   ret_addr_city              VARCHAR2(35),
   ret_addr_state             VARCHAR2(35),   
   ret_addr_county            VARCHAR2(35),
   ret_addr_country_code      VARCHAR2(2));

TYPE header_information_arr IS TABLE OF header_information_rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)  := Client_SYS.field_separator_;
string_null_       CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Cancel_All_Lines___ (
   rec_  IN OUT RETURN_MATERIAL_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   info_    VARCHAR2(2000);

   CURSOR get_lines IS
      SELECT rma_line_no
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rec_.rma_no
      AND rowstate NOT IN ('Cancelled', 'Denied');
BEGIN
   FOR next_line_ IN get_lines LOOP
      Return_Material_Line_API.Cancel_Line(info_, rec_.rma_no, next_line_.rma_line_no );
      Return_Material_Line_API.Set_Cancel_Reason(rec_.rma_no, next_line_.rma_line_no, rec_.cancel_reason );
   END LOOP;
END Cancel_All_Lines___;


-- All_Lines_Approved___
--   True if all lines are approved, i.e. has an approver connected.
FUNCTION All_Lines_Approved___ (
   rec_ IN OUT RETURN_MATERIAL_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   CURSOR get_incorrect_line  IS
      SELECT rma_line_no
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rec_.rma_no
      AND (credit_approver_id IS NULL)
      AND rowstate NOT IN ('Planned', 'Denied', 'Cancelled')
      AND rental = Fnd_Boolean_API.DB_FALSE;

   CURSOR get_incorrect_charge  IS
      SELECT 1
      FROM RETURN_MATERIAL_CHARGE_TAB
      WHERE rma_no = rec_.rma_no
      AND (credit_approver_id IS NULL)
      AND rowstate NOT IN ('Planned', 'Denied');

   dummy_   NUMBER;
   lines_exists_       BOOLEAN := any_lines_exists___(rec_.rma_no);
   charges_exists_     BOOLEAN := any_charges_exists___(rec_.rma_no);
   bad_lines_exists_   BOOLEAN := FALSE;
   bad_charges_exists_ BOOLEAN := FALSE;
BEGIN

   IF NOT ( lines_exists_ OR charges_exists_) THEN
      -- we found no lines at this rma
      RETURN FALSE;
   END IF;

   IF lines_exists_ THEN
      FOR line_rec_ IN get_incorrect_line LOOP
         IF (Return_Material_Line_API.Check_Exch_Charge_Order(rec_.rma_no, line_rec_.rma_line_no) = 'FALSE') THEN
            bad_lines_exists_:= TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;

   IF charges_exists_ THEN
      OPEN get_incorrect_charge;
      FETCH get_incorrect_charge INTO dummy_;
      bad_charges_exists_ := NOT (get_incorrect_charge%NOTFOUND);
      CLOSE get_incorrect_charge;
   END IF;

   IF NOT (bad_charges_exists_ OR bad_lines_exists_) THEN
      -- we found no lines that where not credit invoiced.
      RETURN TRUE;
   END IF;
   RETURN FALSE;
END All_Lines_Approved___;


PROCEDURE Has_Charge_Line___ (
   rec_  IN OUT RETURN_MATERIAL_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   dummy_              NUMBER;
   CURSOR has_denied_charged_lines IS
      SELECT 1
      FROM RETURN_MATERIAL_CHARGE_TAB
      WHERE rma_no = rec_.rma_no
      AND rowstate = 'Denied';
BEGIN

   OPEN has_denied_charged_lines;
   FETCH has_denied_charged_lines INTO dummy_;
   IF (has_denied_charged_lines%FOUND) THEN
      CLOSE has_denied_charged_lines;
      Error_SYS.Record_General(lu_name_, 'HASDENIEDCHARGELINE: The operation "Cancel" is not allowed for Credit Charges objects in state "Denied".');
   END IF;
   CLOSE has_denied_charged_lines;

   IF (Exist_Charges__(rec_.rma_no)=1) THEN
      Error_SYS.Record_General(lu_name_, 'HASCHARGELINE: Charge line(s) exists to this RMA. Remove the connected charge line(s) before cancellation.');
   END IF;
END Has_Charge_Line___;


-- Any_Lines_Exists___
--   Checks if there are RMA lines present for this RMA.
FUNCTION Any_Lines_Exists___ (
   rma_no_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rma_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Any_Lines_Exists___;


-- Release_Allowed___
--   To check whether its allowed to change the status Releases when return to
--   supplier is external
PROCEDURE Release_Allowed___ (
   rec_  IN OUT RETURN_MATERIAL_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   supplier_return_reason_ VARCHAR2(8);
   orderrow_rec_           Customer_Order_Line_API.Public_Rec;
   vendor_no_              VARCHAR2(20);

   CURSOR get_line IS
     SELECT rma_line_no, order_no, line_no, rel_no, line_item_no, supplier_return_reason
       FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rec_.rma_no
       AND rowstate = 'Planned';
BEGIN

   IF (rec_.return_approver_id IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'APPOVERID_CANNOT_NULL: The coordinator must be specified in order to release the RMA.');
   END IF;
   --Check whether Site and Return to Site are different
   IF (rec_.contract != NVL(rec_.return_to_contract, Database_SYS.string_null_)) THEN
      FOR line_rec_ IN get_line LOOP
         orderrow_rec_ := Customer_Order_line_API.Get(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
         vendor_no_:= Customer_Order_Pur_Order_API.Get_PO_Vendor_No(NULL, line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
         
         IF (orderrow_rec_.supply_code IN ('IPD', 'PD') AND orderrow_rec_.charged_item = 'ITEM NOT CHARGED' AND orderrow_rec_.catalog_type = 'INV') THEN
            Error_SYS.Record_General(lu_name_, 'NORETURNALLOWED: Cannot return purchase component parts directly to supplier.'); 
         END IF;

         --Check whether the Connected CO is direclty delivered by the supplier mentioned.
         IF (rec_.return_to_vendor_no IS NOT NULL AND rec_.return_to_vendor_no = NVL(vendor_no_, Database_SYS.string_null_) AND orderrow_rec_.supply_code IN ('PD', 'IPD')) THEN
            IF orderrow_rec_.supply_code = 'PD' THEN
               Return_Material_Line_API.Fetch_Supplier_Rtn_Reason__(rec_.rma_no, line_rec_.rma_line_no);
               supplier_return_reason_ := Return_Material_Line_API.Get_Supplier_Return_Reason(rec_.rma_no, line_rec_.rma_line_no);
            END IF;
            IF (NVL(supplier_return_reason_, line_rec_.supplier_return_reason) IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'NOPURCHRETURNREASON: RMA Line No :P1 is connected to a customer order line directly delivered by the return to supplier, and therefore requires a value in the Supplier Return Reason field', line_rec_.rma_line_no);
            END IF;
         ELSE
            IF (line_rec_.order_no IS NULL) THEN
               Error_SYS.Record_General (lu_name_, 'RMANOORDERNO: All RMA lines should be connected to a customer order line when materials are being returned to a different site or to an external supplier.');
            ELSE
               IF (rec_.return_to_contract IS NULL AND rec_.return_to_vendor_no IS NULL) THEN
                  Error_SYS.Record_General (lu_name_, 'RMARELEASENOTALLOWEDTOFIELDSNULL: Either the return-to-supplier or the return-to-site must have a value');
               ELSIF (Site_API.Get_Company(rec_.contract) != NVL(Site_API.Get_Company(rec_.return_to_contract), Database_SYS.string_null_)) THEN
                  Error_SYS.Record_General (lu_name_, 'RMARELEASENOTALLOWED: All RMA lines should be connected to a customer order line that have been directly delivered by the same supplier as specified in the Return to Supplier field, when the site and return-to site are in two companies.');
               END IF;
            END IF;
         END IF;
      END LOOP;
   END IF;
END Release_Allowed___;


-- Any_Charges_Exists___
--   Checks if there are charges connected to the RMA.
FUNCTION Any_Charges_Exists___ (
   rma_no_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   RETURN_MATERIAL_CHARGE_TAB
      WHERE rma_no = rma_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Any_Charges_Exists___;


-- Modify_Rma_Defaults___
--   Modifies rma header specific delivery information for all rma lines
--   having pay tax set to Yes.
PROCEDURE Modify_Rma_Defaults___ (
   rma_no_                    IN NUMBER,
   pay_tax_                   IN BOOLEAN,
   update_tax_from_ship_addr_ IN BOOLEAN,
   contract_                  IN VARCHAR2)
IS
   tax_method_                 VARCHAR2(50);
   update_tax_at_line_         BOOLEAN := TRUE;
   
   CURSOR get_rma_lines IS
      SELECT rma_line_no
        FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rma_no_;

   CURSOR get_rma_charge_lines IS
      SELECT rma_charge_no
        FROM RETURN_MATERIAL_CHARGE_TAB
       WHERE rma_no = rma_no_;
BEGIN
   tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(Site_API.Get_Company(contract_));
   
   IF tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX THEN 
      update_tax_at_line_ := FALSE;
   END IF;

   FOR rec_ IN get_rma_lines LOOP
      Return_Material_Line_API.Modify_Rma_Defaults__(rma_no_, rec_.rma_line_no, pay_tax_, update_tax_from_ship_addr_, update_tax_at_line_);
   END LOOP;

   FOR rec_ IN get_rma_charge_lines LOOP
      Return_Material_Charge_API.Modify_Rma_Defaults__(rma_no_, rec_.rma_charge_no, pay_tax_, update_tax_from_ship_addr_, update_tax_at_line_);
   END LOOP;
   
   IF NOT update_tax_at_line_ THEN
      Fetch_External_Tax(rma_no_);
   END IF;

END Modify_Rma_Defaults___;


FUNCTION All_Lines_Planned_Or_Denied___ (
   rec_  IN     RETURN_MATERIAL_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   CURSOR get_incorrect_line  IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rec_.rma_no
      AND rowstate NOT IN ('Planned', 'Denied', 'Cancelled');

   CURSOR get_incorrect_charge  IS
      SELECT 1
      FROM RETURN_MATERIAL_CHARGE_TAB
      WHERE rma_no = rec_.rma_no
      AND rowstate NOT IN ('Planned', 'Denied');

   dummy_              NUMBER;
   lines_exists_       BOOLEAN := any_lines_exists___(rec_.rma_no);
   charges_exists_     BOOLEAN := any_charges_exists___(rec_.rma_no);
   bad_lines_exists_   BOOLEAN := FALSE;
   bad_charges_exists_ BOOLEAN := FALSE;
BEGIN

   IF NOT ( lines_exists_ OR charges_exists_) THEN
      -- we found no lines at this rma
      RETURN FALSE;
   END IF;

   IF lines_exists_ THEN
      OPEN get_incorrect_line;
      FETCH get_incorrect_line INTO dummy_;
      bad_lines_exists_ := get_incorrect_line%FOUND;
      CLOSE get_incorrect_line;
   END IF;

   IF charges_exists_ THEN
      OPEN get_incorrect_charge;
      FETCH get_incorrect_charge INTO dummy_;
      bad_charges_exists_ := NOT (get_incorrect_charge%NOTFOUND);
      CLOSE get_incorrect_charge;
   END IF;

   IF NOT (bad_charges_exists_ OR bad_lines_exists_) THEN
      -- we found no lines that where not credit invoiced.
      RETURN TRUE;
   END IF;

   RETURN FALSE;
END All_Lines_Planned_Or_Denied___;


FUNCTION Some_Lines_Released___ (
   rec_  IN     RETURN_MATERIAL_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   CURSOR lines_exist  IS
     SELECT 1
       FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rec_.rma_no
       AND rowstate ='Released';

   CURSOR charges_exist  IS
     SELECT 1
       FROM RETURN_MATERIAL_CHARGE_TAB
       WHERE rma_no = rec_.rma_no
       AND rowstate ='Released';

   dummy_            NUMBER;
   released_exists_  BOOLEAN;
BEGIN

   OPEN lines_exist;
   FETCH lines_exist INTO dummy_;
   released_exists_ := lines_exist%FOUND;
   CLOSE lines_exist;

   IF released_exists_ THEN
      RETURN TRUE;
   END IF;

   OPEN charges_exist;
   FETCH charges_exist INTO dummy_;
   released_exists_ := charges_exist%FOUND;
   CLOSE charges_exist;

   -- we found at least a charge in state Released
   RETURN released_exists_;
END Some_Lines_Released___;


FUNCTION All_Lines_Cancel___ (
   rec_  IN     RETURN_MATERIAL_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   lines_exist_        BOOLEAN := Any_Lines_Exists___(rec_.rma_no);
   lines_cancelled_    BOOLEAN := TRUE;
   dummy_              NUMBER;

   CURSOR get_not_cancel_lines IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rec_.rma_no
      AND rowstate != 'Cancelled';
BEGIN
   IF NOT (lines_exist_) THEN
      -- no lines found
      RETURN FALSE;
   END IF;

   IF (lines_exist_) THEN
      OPEN get_not_cancel_lines;
      FETCH get_not_cancel_lines INTO dummy_;
      IF (get_not_cancel_lines%FOUND) THEN
         lines_cancelled_ := FALSE;
      END IF;
      CLOSE get_not_cancel_lines;
   END IF;

   IF (lines_cancelled_) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END All_Lines_Cancel___;


FUNCTION All_Lines_Denied___ (
   rec_  IN     RETURN_MATERIAL_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   lines_exist_        BOOLEAN := Any_Lines_Exists___(rec_.rma_no);
   charges_exist_      BOOLEAN := Any_Charges_Exists___(rec_.rma_no);
   lines_denied_       BOOLEAN := TRUE;
   charges_denied_     BOOLEAN := TRUE;
   dummy_              NUMBER;

   CURSOR get_not_denied_lines IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rec_.rma_no
      AND rowstate != 'Denied';

   CURSOR get_not_denied_charges IS
      SELECT 1
      FROM RETURN_MATERIAL_CHARGE_TAB
      WHERE rma_no = rec_.rma_no
      AND rowstate != 'Denied';
BEGIN
   IF NOT (lines_exist_ OR charges_exist_) THEN
      -- no lines found
      RETURN FALSE;
   END IF;

   IF (lines_exist_) THEN
      OPEN get_not_denied_lines;
      FETCH get_not_denied_lines INTO dummy_;
      IF (get_not_denied_lines%FOUND) THEN
         lines_denied_ := FALSE;
      END IF;
      CLOSE get_not_denied_lines;
   END IF;

   IF (charges_exist_) THEN
      OPEN get_not_denied_charges;
      FETCH get_not_denied_charges INTO dummy_;
      IF (get_not_denied_charges%FOUND) THEN
         charges_denied_ := FALSE;
      END IF;
      CLOSE get_not_denied_charges;
   END IF;

   IF (lines_denied_ AND charges_denied_) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END All_Lines_Denied___;


-- All_Lines_Denied_Or_Cancel___
--   Checks if all RMA lines are in Denied or Cancelled and
--   RMA charges are in Denied connected to the RMA.
FUNCTION All_Lines_Denied_Or_Cancel___ (
   rec_  IN     RETURN_MATERIAL_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   CURSOR get_incorrect_lines IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rec_.rma_no
      AND rowstate NOT IN ('Denied', 'Cancelled');

   CURSOR get_incorrect_charges IS
      SELECT 1
      FROM RETURN_MATERIAL_CHARGE_TAB
      WHERE rma_no = rec_.rma_no
      AND rowstate != 'Denied';

   dummy_                  NUMBER;
   bad_lines_exist_        BOOLEAN := FALSE;
   bad_charge_line_exist_  BOOLEAN := FALSE;
   lines_exists_           BOOLEAN := Any_Lines_Exists___(rec_.rma_no);
   charges_exists_         BOOLEAN := Any_Charges_Exists___(rec_.rma_no);
BEGIN

   -- IF no lines exist in rma
   IF NOT (lines_exists_ OR charges_exists_) THEN
      RETURN FALSE;
   END IF;

   IF (lines_exists_) THEN
      OPEN get_incorrect_lines;
      FETCH get_incorrect_lines INTO dummy_;
      bad_lines_exist_ := (get_incorrect_lines%FOUND);
      CLOSE get_incorrect_lines;
   END IF;

   IF (charges_exists_) THEN
      OPEN get_incorrect_charges;
      FETCH get_incorrect_charges INTO dummy_;
      bad_charge_line_exist_ := (get_incorrect_charges%FOUND);
      CLOSE get_incorrect_charges;
   END IF;

   IF NOT (bad_lines_exist_ OR bad_charge_line_exist_) THEN
      RETURN TRUE;
   END IF;
   RETURN FALSE;
END All_Lines_Denied_Or_Cancel___;


FUNCTION Line_Was_Received___ (
   rec_  IN     RETURN_MATERIAL_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   CURSOR get_received_line  IS
     SELECT 1
       FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rec_.rma_no
       AND rowstate IN ('PartiallyReceived','Received','ReturnCompleted');

     dummy_             NUMBER;
BEGIN
   OPEN get_received_line;
   FETCH get_received_line INTO dummy_;
   IF (get_received_line%NOTFOUND) THEN
      CLOSE get_received_line;
      -- we found no received lines at this rma
      RETURN FALSE;
   END IF;
   CLOSE get_received_line;
   RETURN TRUE;
END Line_Was_Received___;


FUNCTION All_Lines_Completed___ (
   rec_  IN     RETURN_MATERIAL_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   lines_exist_        BOOLEAN := Any_Lines_Exists___(rec_.rma_no);
   lines_completed_    BOOLEAN := TRUE;
   dummy_              NUMBER;

   CURSOR get_not_completed_lines IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rec_.rma_no
      AND rowstate NOT IN ('Denied', 'ReturnCompleted', 'Cancelled');
BEGIN
   IF NOT (lines_exist_) THEN
      -- no lines found
      RETURN FALSE;
   END IF;

   OPEN get_not_completed_lines;
   FETCH get_not_completed_lines INTO dummy_;
   IF (get_not_completed_lines%FOUND) THEN
      lines_completed_ := FALSE;
   END IF;
   CLOSE get_not_completed_lines;

   IF (lines_completed_) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END All_Lines_Completed___;


FUNCTION Fully_Received___ (
   rec_  IN     RETURN_MATERIAL_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   CURSOR get_incorrect_line  IS
     SELECT 1
       FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rec_.rma_no
       AND rowstate in ('PartiallyReceived', 'Planned', 'Released');
     dummy_             NUMBER;
BEGIN

   IF NOT any_lines_exists___(rec_.rma_no) THEN
      -- we found no lines at this rma
      RETURN FALSE;
   END IF;

   OPEN get_incorrect_line;
   FETCH get_incorrect_line INTO dummy_;
   IF (get_incorrect_line%NOTFOUND) THEN
      CLOSE get_incorrect_line;
      -- we found no lines in the other states
      RETURN TRUE;
   END IF;
   CLOSE get_incorrect_line;
   RETURN FALSE;
END Fully_Received___;


FUNCTION All_Received_Handled___ (
   rec_  IN     RETURN_MATERIAL_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   CURSOR get_incorrect_line  IS
     SELECT 1
       FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rec_.rma_no
       AND rowstate IN  ('Planned','Released','Received');

   CURSOR get_pr_line  IS
     SELECT qty_received, qty_scrapped, qty_returned_inv, conv_factor, catalog_no
       FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rec_.rma_no
       AND rowstate IN  ('PartiallyReceived');

   CURSOR get_Completed_lines  IS
     SELECT 1
       FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rec_.rma_no
       AND rowstate IN  ('ReturnCompleted');

     dummy_             NUMBER;
     line_handled_all_  BOOLEAN := FALSE;
     pr_lines_exist_    BOOLEAN := FALSE;
BEGIN
   OPEN get_incorrect_line;
   FETCH get_incorrect_line INTO dummy_;
   IF NOT (get_incorrect_line%NOTFOUND) THEN
      CLOSE get_incorrect_line ;
      -- we found a line in a state were it can impossibly be fully handled
      RETURN FALSE;
   END IF;
   CLOSE get_incorrect_line;

   FOR linerec_  IN get_pr_line LOOP
      -- non-inventory-part lines are also completable
      line_handled_all_ :=
        (Sales_Part_API.Get_Part_No(rec_.contract, linerec_.catalog_no) IS NULL)  OR
        linerec_.qty_received = ((nvl(linerec_.qty_scrapped,0) +
                                  nvl(linerec_.qty_returned_inv,0)) /
                                 linerec_.conv_factor);
      pr_lines_exist_ := TRUE;
      EXIT WHEN line_handled_all_ = FALSE;
   END LOOP;

   IF pr_lines_exist_ THEN
      IF NOT line_handled_all_ THEN
         -- we found a line with received qty that was not handled.
         RETURN FALSE ;
      END IF;
      RETURN TRUE;
   ELSE
      -- no Partially Received lines exists
      -- at least one line has to fulfil the requirement
      OPEN get_Completed_lines;
      FETCH get_Completed_lines INTO dummy_;
      IF NOT (get_Completed_lines%NOTFOUND) THEN
         CLOSE get_Completed_lines;
      -- we found no lines that were fully handled
         RETURN FALSE;
      END IF;
      CLOSE get_Completed_lines;
   END IF;
   -- We found some Completed lines
   RETURN TRUE;
END All_Received_Handled___;


FUNCTION Jinsui_Order_is_Connected___(rma_no_ IN NUMBER) RETURN BOOLEAN
IS
   jinsui_order_found_       BOOLEAN := FALSE;
   cust_ord_rec_             Customer_Order_API.Public_Rec;

   CURSOR get_connect_orders IS
     SELECT order_no
     FROM return_material_line_tab
     WHERE rma_no = rma_no_;

BEGIN
   FOR line_ IN get_connect_orders LOOP
      IF line_.order_no IS NOT NULL THEN
         cust_ord_rec_ := Customer_Order_API.Get(line_.order_no);
         IF cust_ord_rec_.Jinsui_Invoice ='TRUE' THEN
            jinsui_order_found_ := TRUE;
            EXIT;
         END IF;
      END IF;
   END LOOP;
   RETURN jinsui_order_found_;
END Jinsui_Order_is_Connected___;


-- Check_Debit_Inv_Numbers___
--   This method returns a number value depending on the connected debit invoice number
--   to each RMA line and charge line in a particular RMA. This returns,
--   0 - if all the RMA lines are not conneted to any debit invoice.
--   1 - if all the RMA lines/charge lines are connected to the same debit invoice number.
--   2 - if different debit invoices are connected to different RMA lines/charge lines or
--   if some are connected and some are not.
FUNCTION Check_Debit_Inv_Numbers___ (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   lines_                          NUMBER := 2;
   no_of_distinct_deb_inv_         NUMBER := 0;
   no_of_distinct_charge_deb_inv_  NUMBER := 0;
   connectionless_lines_exist_     NUMBER := 0;
   connectionless_charges_exist_   NUMBER := 0;

   -- This cursor will check the number of distinct debit invoice connected to RMA lines.
   -- if the counted value is 0 it means that the rma lines does not exists or they are connectionless.
   -- if the value is 1 then some or all rma lines are connected to 1 debit invoice.
   -- if the value is greated than 1 then more than one connection of course.
   CURSOR distinct_debit_invoices IS
      SELECT COUNT(DISTINCT(debit_invoice_no))
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no    = rma_no_
      AND    credit_invoice_no IS NULL
      AND    debit_invoice_no IS NOT NULL
      AND    rowstate NOT IN ('Denied', 'Cancelled');

   -- This cursor will return 1 if at least connectionless RMA line exist.
   CURSOR connectionless_lines_exist IS
      SELECT 1
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    debit_invoice_no IS NULL
      AND    credit_invoice_no IS NULL
      AND    rowstate NOT IN ('Denied', 'Cancelled');

   -- This cursor will check the number of distinct debit invoice connected to RMA charge lines.
   -- if the counted value is 0 it means that the rma charge lines does not exists or they are connectionless.
   -- if the value is 1 then some or all charge lines are connected to 1 debit invoice.
   -- if the value is greated than 1 then more than one connection of course.
   CURSOR distinct_charge_debit_invoices IS
      SELECT COUNT(DISTINCT(ii.invoice_id))
      FROM   CUSTOMER_ORDER_INV_ITEM ii, RETURN_MATERIAL_CHARGE_TAB ct
      WHERE  ct.rma_no        = rma_no_
      AND    ii.order_no      = ct.order_no
      AND    ii.charge_seq_no = ct.sequence_no
      AND    ii.company       = ct.company
      AND    ct.order_no IS NOT NULL
      AND    ct.credit_invoice_no IS NULL;

   -- This cursor will return 1 if at least connectionless RMA charge exist..
   CURSOR connectionless_charges_exist IS
      SELECT 1
      FROM   RETURN_MATERIAL_CHARGE_TAB
      WHERE  rma_no = rma_no_
      AND    order_no IS NULL
      AND    credit_invoice_no IS NULL
      AND    charge_amount != 0
      AND    rowstate != 'Denied';

   -- This cursor is called when we know that there is only one debit invoice is connected to RMA line(s)
   -- and there is only one debit invoice is connected to charge line(s)..
   -- Then we use this cursor to check whether the connected debit invoice no is same for
   -- both RMA line(s) and charge line(s).
   -- IF any record is found then both debit invoices are same. Otherwise they are differ.
   CURSOR check_same_deb_invoice IS
      SELECT DISTINCT(ii.invoice_id)
      FROM   CUSTOMER_ORDER_INV_ITEM ii, RETURN_MATERIAL_CHARGE_TAB ct
      WHERE  ct.rma_no        = rma_no_
      AND    ii.order_no      = ct.order_no
      AND    ii.charge_seq_no = ct.sequence_no
      AND    ii.company       = ct.company
      AND    ct.order_no IS NOT NULL
      AND    ct.credit_invoice_no IS NULL
         INTERSECT
      SELECT DISTINCT(ih.invoice_id)
      FROM   CUSTOMER_ORDER_INV_HEAD ih, RETURN_MATERIAL_LINE_TAB rm
      WHERE  rm.rma_no     = rma_no_
      AND    ih.invoice_no = rm.debit_invoice_no
      AND    ih.company    = rm.company
      AND    rm.debit_invoice_no IS NOT NULL
      AND    rm.credit_invoice_no IS NULL;

   deb_rec_  check_same_deb_invoice%ROWTYPE;
BEGIN
   OPEN  distinct_debit_invoices;
   FETCH distinct_debit_invoices INTO no_of_distinct_deb_inv_;
   CLOSE distinct_debit_invoices;

   OPEN  distinct_charge_debit_invoices;
   FETCH distinct_charge_debit_invoices INTO no_of_distinct_charge_deb_inv_;
   CLOSE distinct_charge_debit_invoices;

   IF (no_of_distinct_deb_inv_ = 0) THEN
      -- All rma_lines are connectionless.
     lines_ := 0;
   ELSIF (no_of_distinct_deb_inv_ = 1) OR (no_of_distinct_charge_deb_inv_ = 1) THEN
      OPEN  connectionless_lines_exist;
      FETCH connectionless_lines_exist INTO connectionless_lines_exist_;
      IF connectionless_lines_exist%NOTFOUND THEN
         connectionless_lines_exist_ := 0;
      END IF;
      CLOSE connectionless_lines_exist;

      OPEN  connectionless_charges_exist;
      FETCH connectionless_charges_exist INTO connectionless_charges_exist_;
      IF connectionless_charges_exist%NOTFOUND THEN
         connectionless_charges_exist_ := 0;
      END IF;
      CLOSE connectionless_charges_exist;

      IF (no_of_distinct_deb_inv_ = 1) AND (no_of_distinct_charge_deb_inv_ = 0) THEN
         IF (connectionless_lines_exist_ = 0) AND (connectionless_charges_exist_ = 0) THEN
            lines_ := 1;
         END IF;
      ELSIF (no_of_distinct_deb_inv_ = 1) AND (no_of_distinct_charge_deb_inv_ = 1) THEN
         IF (connectionless_lines_exist_ = 0) AND (connectionless_charges_exist_ = 0) THEN
            -- Check whether the connected debit invoice for both charge lines and rma lines is same.
            OPEN  check_same_deb_invoice;
            FETCH check_same_deb_invoice INTO deb_rec_;
            IF (check_same_deb_invoice%FOUND) THEN
               lines_ := 1;
            END IF;
            CLOSE check_same_deb_invoice;
         END IF;
      END IF;
   END IF;
   RETURN lines_;
END Check_Debit_Inv_Numbers___;


PROCEDURE Release_All_Lines___ (
   rec_  IN OUT RETURN_MATERIAL_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   CURSOR get_line IS
     SELECT
       rowid       objid,
       ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000))  objversion
       FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rec_.rma_no
       AND rowstate = 'Planned';

   CURSOR get_charge IS
     SELECT
       rowid       objid,
       ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000))  objversion
       FROM RETURN_MATERIAL_CHARGE_TAB
       WHERE rma_no = rec_.rma_no
       AND rowstate = 'Planned';

   info_  VARCHAR2(2000);
   lattr_ VARCHAR2(2000);
BEGIN
   FOR lin IN get_line LOOP
      Client_SYS.Clear_Attr(lattr_);
      Return_Material_Line_API.Release__
        ( info_, lin.objid, lin.objversion, lattr_, 'DO');
   END LOOP;
   FOR charge IN get_charge LOOP
      Client_SYS.Clear_Attr(lattr_);
      Return_Material_Charge_API.Release__
        ( info_, charge.objid, charge.objversion, lattr_, 'DO');
   END LOOP;
END Release_All_Lines___;


PROCEDURE Deny_All_Lines___ (
   rec_  IN OUT RETURN_MATERIAL_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   CURSOR get_line IS
     SELECT
       rowid       objid,
       ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000))  objversion
       FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rec_.rma_no
       AND rowstate = 'Planned';

   CURSOR get_charge IS
     SELECT
       rowid       objid,
       ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000))  objversion
       FROM RETURN_MATERIAL_CHARGE_TAB
       WHERE rma_no = rec_.rma_no
       AND rowstate = 'Planned';

   info_  VARCHAR2(2000);
   lattr_ VARCHAR2(2000);
BEGIN
   FOR lin IN get_line LOOP
      Client_SYS.Clear_Attr(lattr_);
      Return_Material_Line_API.Deny__
        ( info_, lin.objid, lin.objversion, lattr_, 'DO');
   END LOOP;
   FOR charg IN get_charge LOOP
      Client_SYS.Clear_Attr(lattr_);
      Return_Material_Charge_API.Deny__
        ( info_, charg.objid, charg.objversion, lattr_, 'DO');
   END LOOP;
END Deny_All_Lines___;


PROCEDURE Complete_All_Lines___ (
   rec_  IN OUT RETURN_MATERIAL_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   CURSOR get_pr_line  IS
     SELECT rma_line_no, qty_received, qty_scrapped, qty_returned_inv, conv_factor, catalog_no
       FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rec_.rma_no
       AND rowstate IN ('PartiallyReceived');
BEGIN
   -- qty_received > 0 since we are in state partially received
   FOR pr_line_ IN get_pr_line LOOP
      IF (Sales_Part_API.Get_Part_No(rec_.contract, pr_line_.catalog_no) IS NULL) OR
        (pr_line_.qty_received = ((nvl(pr_line_.qty_scrapped,0) + nvl(pr_line_.qty_returned_inv,0)) /
                                  pr_line_.conv_factor))
      THEN
         Return_Material_Line_API.Complete_Line__
           (rec_.rma_no, pr_line_.rma_line_no);
      END IF;
   END LOOP;
END Complete_All_Lines___;


PROCEDURE Validate_Jinsui_Constraints___(newrec_ IN RETURN_MATERIAL_TAB%ROWTYPE)
IS
    charge_exist_            NUMBER;
    company_                 VARCHAR2(20);
    payer_                   RETURN_MATERIAL_TAB.customer_no%TYPE;
    temp_customer_           RETURN_MATERIAL_TAB.customer_no%TYPE;
    acc_currency_            VARCHAR2(3);
    order_currency_          VARCHAR2(3);
    jinsui_order_connected_  BOOLEAN;
    jinsui_customer_         VARCHAR2(5);
    old_jinsui_db_           RETURN_MATERIAL_TAB.jinsui_invoice%TYPE;
    line_exist_              BOOLEAN := FALSE;

BEGIN

   old_jinsui_db_ := Get_Jinsui_Invoice_Db(newrec_.rma_no);

   IF (newrec_.rma_no IS NOT NULL) THEN
      IF (newrec_.rowstate ='Planned')OR (newrec_.rowstate ='Released') THEN
         IF (old_jinsui_db_ != newrec_.jinsui_invoice) AND (newrec_.jinsui_invoice = 'TRUE') THEN
            line_exist_ := Any_Lines_Exists___(newrec_.rma_no);
            IF (line_exist_ = TRUE) THEN
               Error_SYS.Record_General(lu_name_, 'NOJINSUISELECT1: It is not possible to select Jinsui Invoice as connected lines exist.');
            ELSE
               charge_exist_ := Exist_Charges__(newrec_.rma_no);
               IF (charge_exist_ != 0) THEN
                  Error_SYS.Record_General(lu_name_, 'NOJINSUISELECT2: It is not possible to select Jinsui Invoice as connected charge exist.');
               END IF;
            END IF;
         END IF;
      ELSE
         IF (old_jinsui_db_ != newrec_.jinsui_invoice) THEN
            Error_SYS.Record_General(lu_name_, 'JINSUINOCHANGE1: Jinsui status cannot be changed as RMA is in :P1 state.', newrec_.rowstate);
         END IF;
      END IF;
   END IF;

   IF newrec_.jinsui_invoice = 'TRUE' THEN
      payer_ := newrec_.customer_no_credit;
      IF payer_ IS NOT NULL THEN
         temp_customer_ := payer_;
      ELSE
         temp_customer_ := newrec_.customer_no;
      END IF;
      company_ := Site_API.Get_Company(newrec_.contract);
      $IF Component_Jinsui_SYS.INSTALLED $THEN
         jinsui_customer_ := Js_Customer_Info_API.Get_Create_Js_Invoice(company_, temp_customer_);
         jinsui_customer_ := NVL(jinsui_customer_,'FALSE');

         IF jinsui_customer_ = 'FALSE' THEN
            Error_SYS.Record_General(lu_name_, 'NOJINSUI1: You cannot have a Jinsui RMA when :P1 is not Jinsui enabled.',temp_customer_);
         END IF;
      $END
      Company_Finance_API.Get_Accounting_Currency(acc_currency_, company_);
      order_currency_ := newrec_.currency_Code;
      IF order_currency_ != acc_currency_ THEN
         Error_SYS.Record_General(lu_name_, 'NOJINSUI2: You cannot have a Jinsui RMA when order currency and accounting currency are not the same.');
      END IF;
   ELSE
      IF (newrec_.rma_no IS NOT NULL) THEN
         jinsui_order_connected_ := Jinsui_Order_Is_Connected___(newrec_.rma_no);
         IF jinsui_order_connected_ THEN
            Error_SYS.Record_General(lu_name_, 'JINSUINOCHANGE2: Jinsui status cannot be changed as connected line(s) are enabled for Jinsui.');
         END IF;
      END IF;
   END IF;
END Validate_Jinsui_Constraints___;


FUNCTION Credit_Approve_Allowed___ (
   rma_no_  IN NUMBER ) RETURN BOOLEAN
IS
   CURSOR approve_not_allowed_line  IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rma_no_
      AND (credit_approver_id IS NULL)
      AND rowstate NOT IN ('Planned', 'Denied', 'Cancelled')
      AND qty_to_return = 0;

   CURSOR approve_not_allowed_charge  IS
      SELECT 1
      FROM RETURN_MATERIAL_CHARGE_TAB
      WHERE rma_no = rma_no_
      AND (credit_approver_id IS NULL)
      AND rowstate NOT IN ('Planned', 'Denied')
      AND charged_qty = 0;

   dummy_                NUMBER;
   approve_not_allowed_  BOOLEAN;
BEGIN

   OPEN approve_not_allowed_line;
   FETCH approve_not_allowed_line INTO dummy_;
   approve_not_allowed_ := approve_not_allowed_line%FOUND;
   CLOSE approve_not_allowed_line;

   IF NOT approve_not_allowed_ THEN
      OPEN approve_not_allowed_charge;
      FETCH approve_not_allowed_charge INTO dummy_;
      approve_not_allowed_ := approve_not_allowed_charge%FOUND;
      CLOSE approve_not_allowed_charge;
   END IF;
   RETURN (NOT approve_not_allowed_);
END Credit_Approve_Allowed___;


-- Validate_Order_No___
--   This method is used to validate the entered order_no in RMA header.
PROCEDURE Validate_Order_No___ (
   rma_no_         IN NUMBER,
   rma_contract_   IN VARCHAR2,
   rma_curr_code_  IN VARCHAR2,
   rma_customer_   IN VARCHAR2,
   order_no_       IN VARCHAR2 )
IS
   order_rec_      Customer_Order_API.Public_Rec;
   order_state_    VARCHAR2(20);
   dummy_          NUMBER;

   CURSOR check_different_order IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rma_no_
      AND  order_no IS NOT NULL
      AND order_no != order_no_
      AND rowstate NOT IN ('Cancelled', 'Denied');

   CURSOR exist_invalid_charge_line IS
      SELECT 1
      FROM   RETURN_MATERIAL_CHARGE_TAB
      WHERE ORDER_NO IS NOT NULL
      AND ORDER_NO != order_no_
      AND RMA_NO = rma_no_
      AND rowstate != 'Denied';

BEGIN
   order_rec_   := Customer_Order_API.Get(order_no_);
   IF ((rma_contract_ != order_rec_.contract) OR (rma_curr_code_ != order_rec_.currency_code) OR (rma_customer_ != order_rec_.customer_no)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_ORDER: This Customer Order does not match the information on the RMA. Customer, Site or Currency Code.');
   END IF;

   order_state_ := Customer_Order_API.Get_Objstate(order_no_);
   -- Need to avoid the error for the COs which are blocked from PartiallyDelivered state and it should allow to create RMA.
   IF (order_state_ NOT IN ('Blocked', 'Delivered', 'PartiallyDelivered', 'Invoiced')) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_ORDER_STATE: Only delivered orders can be connected to RMA.');
   END IF;

   IF NOT (Customer_Order_API.Valid_Ownership_Del_Line_Exist(order_no_)) THEN
      Error_SYS.Record_General(lu_name_, 'EXT_OWNED_LINE: There are no delivered company-owned or rental customer order lines in the entered customer order.');
   END IF;

   OPEN check_different_order;
   FETCH check_different_order INTO dummy_;
   IF (check_different_order%FOUND) THEN
      CLOSE check_different_order;
      Error_SYS.Record_General(lu_name_, 'CONN_TO_DIFF_ORDER: The customer order number defined in the RMA header must be the same as the one connected to the RMA line.');
   END IF;
   CLOSE check_different_order;

   OPEN exist_invalid_charge_line;
   FETCH exist_invalid_charge_line INTO dummy_;
   IF (exist_invalid_charge_line%FOUND) THEN
      CLOSE exist_invalid_charge_line;
      Error_SYS.Record_General(lu_name_, 'INVALID_CHARGE_LINE: Customer order number defined in the RMA header must be same as the one connected to the RMA charge line.');
   END IF;
   CLOSE exist_invalid_charge_line;

END Validate_Order_No___;


-- Validate_Shipment_Id___
--   This method is used to validate the entered shipment_id in RMA header.
PROCEDURE Validate_Shipment_Id___ (
   rma_no_         IN NUMBER,
   rma_contract_   IN VARCHAR2,
   rma_customer_   IN VARCHAR2,
   shipment_id_    IN NUMBER )
IS
   shipment_rec_        Shipment_API.Public_Rec;
   shipment_state_      VARCHAR2(20);   
   dummy_               NUMBER;
   
   CURSOR get_line_order_no IS
      SELECT order_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    order_no IS NOT NULL
      AND    rowstate NOT IN ('Cancelled', 'Denied');      
    
    CURSOR get_ship_lines IS
      SELECT 1
      FROM shipment_line_pub sl, customer_order_line_tab col
      WHERE shipment_id = shipment_id_ 
      AND NVL(sl.source_ref1, string_null_) = col.order_no
      AND NVL(sl.source_ref2, string_null_) = col.line_no
      AND NVL(sl.source_ref3, string_null_) = col.rel_no
      AND NVL(sl.source_ref4, string_null_) = col.line_item_no     
      AND col.part_ownership = 'COMPANY OWNED'
      AND sl.source_ref_type_db =  Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND sl.qty_shipped > 0;     
BEGIN
   shipment_rec_ := Shipment_API.Get(shipment_id_);
   IF ((rma_contract_ != shipment_rec_.contract) OR (rma_customer_ != shipment_rec_.receiver_id)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_SHIPMENT: This Shipment does not match the information on the RMA. Deliver to Customer or Site.');
   END IF;

   shipment_state_ := Shipment_API.Get_Objstate(shipment_id_);
   IF (shipment_state_ NOT IN ('Completed', 'Closed')) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_SHIPMENT_STATE: Only Complete or Closed shipments can be connected to RMA.');
   END IF;
   
   -- Checking whether the given shipment contains deliveries which can be connected to RMA.  
   OPEN  get_ship_lines;
   FETCH get_ship_lines INTO dummy_;
   IF (get_ship_lines%NOTFOUND) THEN     
      CLOSE get_ship_lines; 
      Error_SYS.Record_General(lu_name_, 'NON_DELIV_SHIPMENT: There are no delivered company owned sales parts in this shipment.');
   END IF;
   CLOSE get_ship_lines; 

   FOR line_rec IN get_line_order_no LOOP
      IF (Shipment_Line_API.Source_Ref1_Exist(shipment_id_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, line_rec.order_no) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'ORDER_NOT_EXIST: Customer order numbers entered in the RMA lines should belong to the shipment entered in the RMA header.');
      END IF;
   END LOOP;
END Validate_Shipment_Id___;


PROCEDURE Exist_Return_To_Vendor_No___ (
   return_to_vendor_no_ IN VARCHAR2 )
IS
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      Supplier_API.Exist(return_to_vendor_no_);
   $ELSE
      NULL;
   $END
END Exist_Return_To_Vendor_No___;


-- Validate_Retn_To_Vendor_No___
--   This method is used to validate the entered return_to_vendor_no in RMA header.
PROCEDURE Validate_Retn_To_Vendor_No___ (
   rma_no_               IN NUMBER,
   return_to_vendor_no_  IN VARCHAR2 )
IS
   rec_                  RETURN_MATERIAL_TAB%ROWTYPE;
   ordrow_rec_           Customer_Order_Line_API.Public_Rec;
   vendor_no_            VARCHAR2(20);

   CURSOR get_line IS
     SELECT order_no, line_no, rel_no, line_item_no
     FROM RETURN_MATERIAL_LINE_TAB
     WHERE rma_no = rma_no_;
BEGIN
   rec_ := Get_Object_By_Keys___(rma_no_);

   IF return_to_vendor_no_ IS NOT NULL THEN
      Exist_Return_To_Vendor_No___(return_to_vendor_no_);
   END IF;
   IF (rec_.rowstate != 'Planned') THEN
       Error_SYS.Record_General(lu_name_, 'SUPPNOTALLOWUPDATE: The supplier can be modified only in the Planned status.');
   END IF;
   FOR line_rec_ IN get_line LOOP
      IF (line_rec_.order_no IS NOT NULL) THEN
         ordrow_rec_ := Customer_Order_line_API.Get(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
         vendor_no_:= Customer_Order_Pur_Order_API.Get_PO_Vendor_No(NULL, line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
         IF (return_to_vendor_no_ != vendor_no_ AND rec_.return_to_contract IS NULL) THEN
            Error_SYS.Record_General (lu_name_, 'SUPPLIERNOTALLOWED: There are RMA lines which are connected to customer order lines which have not been directly delivered by this supplier.');
         END IF;
      END IF;
   END LOOP;
END  Validate_Retn_To_Vendor_No___;


-- Validate_Return_Addr_No___
--   This method is used to validate the entered return_to_addr_no in RMA header.
PROCEDURE Validate_Return_Addr_No___ (
   rma_no_               IN NUMBER,
   return_addr_no_       IN VARCHAR2,
   return_to_vendor_no_  IN VARCHAR2,
   return_to_contract_   IN VARCHAR2 )
IS
   raise_error_    BOOLEAN := FALSE;

BEGIN

   IF (return_to_contract_ IS NULL AND return_to_vendor_no_ IS NOT NULL) THEN
      -- return to external supplier
      IF (Supplier_Info_Address_Type_API.Check_Exist(return_to_vendor_no_, return_addr_no_, Address_Type_Code_API.Decode('DELIVERY')) = 'FALSE') THEN
         raise_error_ := TRUE;
      END IF;
   ELSE
      IF (Company_Address_Type_API.Check_Exist(Site_API.Get_Company(return_to_contract_), return_addr_no_, Address_Type_Code_API.Decode('DELIVERY')) = 'FALSE') THEN
          raise_error_ := TRUE;
      END IF;
   END IF;

   IF raise_error_ THEN
      Error_SYS.Record_General(lu_name_, 'NOTVALIDSUPADR: Return address ID :P1 is not a valid address.', return_addr_no_);
   END IF;
END  Validate_Return_Addr_No___;


-- Validate_Return_To_Contract___
--   This method is used to validate the entered return_to_contract in RMA header.
PROCEDURE Validate_Return_To_Contract___ (
   rma_no_               IN NUMBER,
   contract_             IN VARCHAR2,
   return_to_contract_   IN VARCHAR2)
IS
   ord_line_rec_  Customer_Order_line_API.Public_Rec;
   rec_           RETURN_MATERIAL_TAB%ROWTYPE;

   CURSOR get_line IS
      SELECT order_no, line_no, rel_no, line_item_no
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rma_no_;
BEGIN
   rec_ := Get_Object_By_Keys___(rma_no_);

   IF (rec_.rowstate NOT IN ('Planned')) THEN
      Error_SYS.Record_General(lu_name_, 'RET_TO_SITE_UPDATE: The Return to Site field can be modified only in the Planned status.');
   END IF;
   IF (contract_ != NVL(return_to_contract_, Database_SYS.string_null_) AND Site_API.Get_Company(contract_) != Site_API.Get_Company(return_to_contract_)) THEN
      FOR line_rec_ IN get_line LOOP
         IF (line_rec_.order_no IS NOT NULL) THEN
            ord_line_rec_ := Customer_Order_line_API.Get(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
            IF (ord_line_rec_.supply_code = 'IPD'  AND ord_line_rec_.supply_site != return_to_contract_) THEN
               Error_SYS.Record_General(lu_name_, 'SITE_COMPANY_DIFF: The supply site of the connected customer order and the return-to site must be same when RMA lines are connected to customer order lines that have been delivered directly.');
            END IF;
         END IF;
      END LOOP;
   END IF;
END Validate_Return_To_Contract___;


-- Validate_Ship_Via_Del_Term___
--   This method check to whether Ship Via and Delivery Term are mandetory.
PROCEDURE Validate_Ship_Via_Del_Term___(
   rma_no_  IN   VARCHAR2)
IS
   dummy_   NUMBER;

   CURSOR get_line IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rma_no_
      AND   order_no IS NULL
      AND   rowstate NOT IN ('Planned', 'Denied', 'Cancelled' );
BEGIN
   OPEN  get_line;
   FETCH get_line INTO dummy_;
      IF (get_line%FOUND) THEN
         CLOSE get_line;
          Error_SYS.Record_General(lu_name_ ,'SHIPVIADELTERMMANDETORY: Values must be defined for the ship-via and delivery terms when, the return from address is a single occurrence, the intrastat is applicable, and an RMA line exists that is not connected to a customer order line.');
      END IF;
   CLOSE get_line;
END Validate_Ship_Via_Del_Term___;


-- Modify_Supply_Site_Rma___
--   This method is to update Supply Site RMA header.
PROCEDURE Modify_Supply_Site_Rma___ (
   rma_no_ IN NUMBER,
   attr_   IN OUT VARCHAR2,
   changed_rec_ IN Indicator_Rec,
   suppliy_site_rma_rec_ IN return_material_tab%ROWTYPE )
IS
   receipt_rma_no_ RETURN_MATERIAL_TAB.receipt_rma_no%TYPE;
   state_          RETURN_MATERIAL_TAB.rowstate%TYPE;
   newrec_         RETURN_MATERIAL_TAB%ROWTYPE;
   oldrec_         RETURN_MATERIAL_TAB%ROWTYPE;
   objid_          VARCHAR2(2000);
   objversion_     VARCHAR2(2000);
BEGIN
   state_          := Get_Objstate(rma_no_);
   receipt_rma_no_ := Get_Receipt_Rma_No(rma_no_);

   IF ((receipt_rma_no_ IS NOT NULL) AND (state_ NOT IN ('Denied', 'Cancelled'))) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, receipt_rma_no_);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;

      IF changed_rec_.ship_addr_no THEN
         newrec_.ship_addr_no := suppliy_site_rma_rec_.ship_addr_no;
      END IF;
      IF changed_rec_.ship_addr_flag THEN
         newrec_.ship_addr_flag := suppliy_site_rma_rec_.ship_addr_flag;
      END IF;
      IF changed_rec_.ship_addr_country_code THEN
         newrec_.ship_addr_country_code := suppliy_site_rma_rec_.ship_addr_country_code;
      END IF;
      IF changed_rec_.ship_addr_name THEN
         newrec_.ship_addr_name := suppliy_site_rma_rec_.ship_addr_name;
      END IF;
      IF changed_rec_.ship_address1 THEN
         newrec_.ship_address1 := suppliy_site_rma_rec_.ship_address1;
      END IF;
      IF changed_rec_.ship_address2 THEN
         newrec_.ship_address2 := suppliy_site_rma_rec_.ship_address2;
      END IF;
      IF changed_rec_.ship_address3 THEN
         newrec_.ship_address3 := suppliy_site_rma_rec_.ship_address3;
      END IF;
      IF changed_rec_.ship_address4 THEN
         newrec_.ship_address4 := suppliy_site_rma_rec_.ship_address4;
      END IF;
      IF changed_rec_.ship_address5 THEN
         newrec_.ship_address5 := suppliy_site_rma_rec_.ship_address5;
      END IF;
      IF changed_rec_.ship_address6 THEN
         newrec_.ship_address6 := suppliy_site_rma_rec_.ship_address6;
      END IF;
      IF changed_rec_.ship_addr_zip_code THEN
         newrec_.ship_addr_zip_code := suppliy_site_rma_rec_.ship_addr_zip_code;
      END IF;
      IF changed_rec_.ship_addr_city THEN
         newrec_.ship_addr_city := suppliy_site_rma_rec_.ship_addr_city;
      END IF;
      IF changed_rec_.ship_addr_state THEN
         newrec_.ship_addr_state := suppliy_site_rma_rec_.ship_addr_state;
      END IF;
      IF changed_rec_.latest_return_date THEN
         newrec_.latest_return_date := suppliy_site_rma_rec_.latest_return_date;
      END IF;
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Modify_Supply_Site_Rma___;


-- Restrict_Multi_Site_Update___
--   This method is to restrict Multi Site RMA header updation.
PROCEDURE Restrict_Multi_Site_Update___ (
   newrec_  IN RETURN_MATERIAL_TAB%ROWTYPE,
   oldrec_  IN RETURN_MATERIAL_TAB%ROWTYPE )
IS
BEGIN

   IF (NVL(newrec_.return_to_vendor_no, Database_SYS.string_null_) != NVL(oldrec_.return_to_vendor_no, Database_SYS.string_null_) OR
       NVL(newrec_.return_to_contract, Database_SYS.string_null_)  != NVL(oldrec_.return_to_contract, Database_SYS.string_null_)  OR
       NVL(newrec_.return_addr_no, Database_SYS.string_null_)      != NVL(oldrec_.return_addr_no, Database_SYS.string_null_) OR
       NVL(newrec_.return_addr_flag, Database_SYS.string_null_)    != NVL(oldrec_.return_addr_flag, Database_SYS.string_null_)) THEN
      IF (newrec_.receipt_rma_no IS NOT NULL) THEN
         Error_SYS.Record_General (lu_name_, 'ORGRMAHEADNOTUPDATER: This RMA is associated with a receipt RMA. The modification is not allowed.');
      ELSIF (newrec_.originating_rma_no IS NOT NULL) THEN
         Error_SYS.Record_General (lu_name_, 'ORGRMAHEADNOTUPDATEO: This RMA is associated with a originating RMA. The modification is not allowed.');
      END IF;
   END IF;
END Restrict_Multi_Site_Update___;


-- Modify_Rma_Line_Po_Info___
--   This method modifies PO info in rma line when return to different site.
PROCEDURE Modify_Rma_Line_Po_Info___ (
   rma_no_              IN NUMBER,
   return_to_contract_  IN VARCHAR2,
   return_to_vendor_no_ IN VARCHAR2 )
IS

   CURSOR get_rma_lines IS
      SELECT rma_line_no, order_no, line_no, rel_no, line_item_no
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rma_no_
      AND   rowstate = 'Planned';

   co_line_rec_   Customer_Order_Line_API.Public_Rec;
   po_order_no_   VARCHAR2(12);
   po_line_no_    VARCHAR2(4);
   po_rel_no_     VARCHAR2(4);
   purchase_type_ VARCHAR2(25);
   vendor_no_     VARCHAR2(20);

BEGIN

   FOR line_rec_ IN get_rma_lines LOOP
      co_line_rec_ := Customer_Order_Line_API.Get(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
      IF (co_line_rec_.supply_code IN ('PD', 'IPD')) THEN
         vendor_no_:= Customer_Order_Pur_Order_API.Get_PO_Vendor_No(NULL, line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
         IF ((vendor_no_ = return_to_vendor_no_) AND ((return_to_contract_ IS NULL) OR (return_to_contract_ = co_line_rec_.supply_site))) THEN
             Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no_, po_line_no_, po_rel_no_, purchase_type_, line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
         ELSE
            po_order_no_ := NULL;
            po_line_no_ := NULL;
            po_rel_no_ := NULL;
         END IF;
         Return_Material_Line_API.Modify_Po_Info__(rma_no_, line_rec_.rma_line_no, po_order_no_, po_line_no_, po_rel_no_);
      END IF;
   END LOOP;
END Modify_Rma_Line_Po_Info___;


@Override
PROCEDURE Finite_State_Set___ (
   rec_   IN OUT RETURN_MATERIAL_TAB%ROWTYPE,
   state_ IN     VARCHAR2 )
IS
   old_state_    RETURN_MATERIAL_TAB.rowstate%TYPE;
BEGIN
   old_state_      := Get_Objstate(rec_.rma_no);
   super(rec_, state_);

   -- When state changes happen, should be logged in history.
   IF (rec_.rowstate != old_state_) THEN
      Return_Material_History_API.New(rec_.rma_no);
   END IF;

   IF (rec_.case_id IS NOT NULL) AND (rec_.rowstate != 'Planned') THEN
      $IF Component_Callc_SYS.INSTALLED $THEN
         Cc_Case_Task_API.Handover_Status_Change(rec_.rma_no, 'RMA', rec_.rowstate);
      $ELSE
         NULL;
      $END
   END IF;

END Finite_State_Set___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_ RETURN_MATERIAL_TAB.contract%TYPE;
BEGIN
   super(attr_);
   contract_ := User_Default_API.Get_Contract;
   Client_SYS.Add_To_Attr('COMPANY', Site_API.Get_Company(contract_), attr_);
   Client_SYS.Add_To_Attr('DATE_REQUESTED', Site_API.Get_Site_Date(contract_), attr_);
   Client_SYS.Add_To_Attr('RETURN_APPROVER_ID', User_Default_API.Get_Authorize_Code, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('RETURN_TO_CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('RMA_REPORT_PRINTED_DB', 'NOT PRINTED', attr_);
   Client_SYS.Add_To_Attr('TAX_LIABILITY', 'EXEMPT', attr_);
   Client_SYS.Add_To_Attr('JINSUI_INVOICE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SHIP_ADDR_FLAG_DB', 'N', attr_);
   Client_SYS.Add_To_Attr('RETURN_ADDR_FLAG_DB', 'N', attr_);
   Client_SYS.Add_To_Attr('RETURN_ADDR_NO', NVL(Site_API.Get_Delivery_Address(contract_),Company_Address_Type_API.Get_Company_Address_Id(Site_API.Get_Company(contract_),Address_Type_Code_API.Decode('DELIVERY'),'TRUE')), attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', 'EXEMPT', attr_);
   IF (Fnd_Session_API.Is_Odp_Session) THEN
      Client_SYS.Add_To_Attr('SUPPLY_COUNTRY_DB', Company_Site_API.Get_Country_Db(contract_), attr_);
   ELSE
         Client_SYS.Add_To_Attr('SUPPLY_COUNTRY', Company_Site_API.Get_Country(contract_), attr_);   
   END IF;
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT RETURN_MATERIAL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_next_seq IS
     SELECT Rma_No_Seq.nextval
       FROM DUAL;
BEGIN
   -- Fetch next RMA-no from sequence.
   OPEN  get_next_seq ;
   FETCH get_next_seq INTO newrec_.rma_no;
   CLOSE get_next_seq;
   Client_SYS.Add_To_Attr('RMA_NO',newrec_.rma_no, attr_);

   newrec_.note_id := Document_Text_API.get_next_note_id;
   Client_SYS.Add_To_Attr('NOTE_ID',newrec_.note_id, attr_);

   IF (newrec_.customer_tax_usage_type IS NULL) THEN
         newrec_.customer_tax_usage_type := Customer_Info_API.Get_Customer_Tax_Usage_Type(newrec_.customer_no);
         Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE',newrec_.customer_tax_usage_type, attr_);
   END IF;

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     RETURN_MATERIAL_TAB%ROWTYPE,
   newrec_     IN OUT RETURN_MATERIAL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   update_line_taxes_          VARCHAR2(5);
   update_tax_from_ship_addr_  BOOLEAN := FALSE;
   pay_tax_                    BOOLEAN := FALSE;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   update_line_taxes_ := Client_SYS.Get_Item_Value('UPDATE_LINE_TAXES', attr_);
   IF (update_line_taxes_ IS NOT NULL) THEN
      update_tax_from_ship_addr_ := TRUE;
   END IF;

   IF (update_tax_from_ship_addr_) THEN
      Modify_Rma_Defaults___(newrec_.rma_no, pay_tax_, update_tax_from_ship_addr_, newrec_.contract);
   END IF;

   IF  ((NVL(oldrec_.return_to_contract, Database_SYS.string_null_) != NVL(newrec_.return_to_contract, Database_SYS.string_null_)) OR
        (NVL(oldrec_.return_to_vendor_no, Database_SYS.string_null_) != NVL(newrec_.return_to_vendor_no, Database_SYS.string_null_))) THEN
      Modify_Rma_Line_Po_Info___(newrec_.rma_no, newrec_.return_to_contract, newrec_.return_to_vendor_no);
   END IF;

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN RETURN_MATERIAL_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   $IF (Component_Callc_SYS.INSTALLED) $THEN
      Cc_Case_Business_Object_API.Check_Reference_Exist('RETURN_MATERIAL', remrec_.rma_no );
      Cc_Case_Sol_Business_Obj_API.Check_Reference_Exist('RETURN_MATERIAL', remrec_.rma_no );
   $END
   $IF (Component_Supkey_SYS.INSTALLED) $THEN
      Cc_Sup_Key_Business_Obj_API.Check_Reference_Exist('RETURN_MATERIAL', remrec_.rma_no );
   $END

END Check_Delete___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     return_material_tab%ROWTYPE,
   newrec_ IN OUT return_material_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (indrec_.order_no AND newrec_.order_no IS NOT NULL) THEN
      Validate_Order_No___(newrec_.rma_no, newrec_.contract, newrec_.currency_code, newrec_.customer_no, newrec_.order_no);
   END IF;

   IF (indrec_.shipment_id AND newrec_.shipment_id IS NOT NULL) THEN
      Validate_Shipment_Id___(newrec_.rma_no, newrec_.contract, newrec_.customer_no, newrec_.shipment_id);
   END IF;

   Super(oldrec_, newrec_, indrec_, attr_);
   
   IF ( NOT ( indrec_.ship_addr_no OR newrec_.ship_addr_flag = 'Y')) THEN
      IF ( indrec_.order_no AND newrec_.order_no IS NOT NULL ) THEN
         newrec_.ship_addr_no :=  Customer_Order_API.Get_Ship_Addr_No(newrec_.order_no);
         newrec_.ship_addr_flag := Customer_Order_API.Get_Addr_Flag_Db(newrec_.order_no);
      ELSIF(indrec_.shipment_id AND newrec_.shipment_id IS NOT NULL) THEN
         newrec_.ship_addr_no := Shipment_API.Get_Receiver_Addr_Id(newrec_.shipment_id);
         newrec_.ship_addr_flag := Shipment_API.Get_Addr_Flag_Db(newrec_.shipment_id);
      END IF;
   END IF;
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT return_material_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   today_                DATE;
   company_             VARCHAR2(20);
   delivery_country_db_  VARCHAR2(2);
BEGIN
   IF NOT(indrec_.rma_report_printed) THEN
      newrec_.rma_report_printed := 'NOT PRINTED';
   END IF;

   IF NOT(indrec_.tax_liability) then
      newrec_.tax_liability := 'EXEMPT';
   END IF;

   IF NOT(indrec_.ship_addr_flag)then
      newrec_.ship_addr_flag := 'N';
   END IF;

   IF NOT (indrec_.return_addr_flag) then
      newrec_.return_addr_flag := 'N';
   END IF;

   IF NOT (indrec_.intrastat_exempt) then
      newrec_.intrastat_exempt := 'EXEMPT';
   END IF;

   
   IF (trunc(newrec_.date_requested) > trunc(newrec_.latest_return_date)) THEN
      Error_SYS.Record_General(lu_name_, 'RTN_DATE_ERROR: Latest return date should be later than the date requested.');
   END IF;

   IF (newrec_.return_from_customer_no IS NULL) THEN
      newrec_.return_from_customer_no := newrec_.customer_no;
   END IF;

   IF (Client_SYS.Item_Exist('UPDATE_LINE_TAXES', attr_)) THEN
      Error_SYS.Item_Insert(lu_name_, 'UPDATE_LINE_TAXES');
   END IF;

   super(newrec_, indrec_, attr_);

   IF NOT (newrec_.tax_liability = 'TAX' OR newrec_.tax_liability = 'EXEMPT') THEN
      IF (newrec_.ship_addr_flag = 'N') THEN
         delivery_country_db_ := Cust_Ord_Customer_Address_API.Get_Country_Code(newrec_.return_from_customer_no, newrec_.ship_addr_no);
      ELSE
         delivery_country_db_ := newrec_.ship_addr_country_code;
      END IF;
      Tax_Handling_Order_Util_API.Validate_Tax_Liability(newrec_.tax_liability, delivery_country_db_);
   END IF;
   
   -- Return COMPANY and ROUNDING to client.
   company_ := Site_API.Get_Company(newrec_.contract);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('ROUNDING',
                          Currency_Code_API.Get_Currency_Rounding
                          (company_,
                           Company_Finance_API.Get_Currency_Code(company_)),
                          attr_);
   Client_SYS.Add_To_Attr('CURRENCY_ROUNDING',
                          Currency_Code_API.Get_Currency_Rounding(company_, newrec_.currency_code), attr_);
   today_ := Site_API.Get_Site_Date(newrec_.contract);
   IF (newrec_.date_requested > today_) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGDATE: The Date Requested can not be later than todays date.');
   END IF;

   IF (newrec_.ship_addr_no IS NOT NULL) THEN
      IF (Cust_Ord_Customer_Address_API.Is_Ship_Location
          (newrec_.return_from_customer_no, newrec_.ship_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTDELRMAADDR: Invalid delivery address specified.');
      END IF;
   END IF;

   IF (newrec_.contract != NVL(newrec_.return_to_contract, ' ') AND (newrec_.return_to_vendor_no IS NULL)) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         newrec_.return_to_vendor_no := Supplier_API.Get_Vendor_No_From_Contract(newrec_.return_to_contract);
      $ELSE
         NULL;
      $END
   END IF;
   IF (newrec_.customer_no_addr_no IS NOT NULL) THEN
      IF (Cust_Ord_Customer_Address_API.Is_Bill_Location(newrec_.customer_no, newrec_.customer_no_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTRMADOCADDR: The address :P1 is not specified as a document address for the customer :P2.',
                                       newrec_.customer_no_addr_no, newrec_.customer_no);
      END IF;
   END IF;

   $IF Component_Jinsui_SYS.INSTALLED $THEN
      Validate_Jinsui_Constraints___(newrec_);
   $END

   IF (newrec_.order_no IS NOT NULL) AND (newrec_.shipment_id IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'BOTH_NOT_ALLOWED: The customer order number and the shipment ID cannot be entered in the same instance.');
   END IF;

   IF (newrec_.return_to_vendor_no IS NOT NULL) THEN
      Validate_Retn_To_Vendor_No___(newrec_.rma_no, newrec_.return_to_vendor_no);
   END IF;

   IF (newrec_.return_to_contract IS NOT NULL) THEN
      Validate_Return_To_Contract___(newrec_.rma_no, newrec_.contract, newrec_.return_to_contract);
   END IF;

   IF (newrec_.return_addr_no IS NOT NULL) THEN
      Validate_Return_Addr_No___(newrec_.rma_no, newrec_.return_addr_no, newrec_.return_to_vendor_no, newrec_.return_to_contract);
   END IF;
   Tax_Handling_Order_Util_API.Validate_Calc_Base_In_Struct(company_, newrec_.customer_no, newrec_.ship_addr_no, newrec_.supply_country, newrec_.use_price_incl_tax, newrec_.tax_liability);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     return_material_tab%ROWTYPE,
   newrec_ IN OUT return_material_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   today_                    DATE;
   count_                    NUMBER;
   company_                  VARCHAR2(20);
   separator_                VARCHAR2(2) := '';
   has_different_payer_      VARCHAR2(200) := '';
   paying_customer_          RETURN_MATERIAL_TAB.customer_no%TYPE;
   delivery_country_db_      VARCHAR2(2);
   supply_attr_              VARCHAR2(32000);
   return_addr_country_code_ RETURN_MATERIAL_TAB.return_addr_country_code%TYPE;
   changed_rec_              Indicator_Rec;
   disconnect_exp_license_   VARCHAR2(5);

   $IF Component_Expctr_SYS.INSTALLED $THEN
      validate_export_license_ BOOLEAN := FALSE;
      connect_head_id_         NUMBER;
      date_requested_changed_  BOOLEAN := FALSE;
      connect_status_          VARCHAR2(30);

      CURSOR get_rma_line IS
         SELECT rml.rma_no,
                rml.rma_line_no
         FROM RETURN_MATERIAL_LINE_TAB rml
         WHERE rml.rma_no = newrec_.rma_no;
   $END

   CURSOR get_order_keys IS
      SELECT rma_line_no, order_no
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = newrec_.rma_no
      AND   order_no IS NOT NULL;

   CURSOR get_rental_lines_count IS
      SELECT COUNT(*)
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = newrec_.rma_no
      AND   rental = 'TRUE'
      AND   order_no IS NOT NULL;
BEGIN
   $IF Component_Expctr_SYS.INSTALLED $THEN
      IF (indrec_.date_requested OR indrec_.customer_no_addr_no OR indrec_.ship_addr_no OR indrec_.supply_country) THEN
         validate_export_license_ := TRUE;
      END IF;
      IF (indrec_.date_requested) THEN
         date_requested_changed_ := TRUE;
      END IF;
   $END

   IF (oldrec_.rowstate = 'Denied') THEN
      Error_SYS.Record_General(lu_name_, 'NOCHGDENIED: The RMA is denied and may not be changed.');
   END IF;

   company_ := Site_API.Get_Company(newrec_.contract);
   supply_attr_ := attr_;

   IF (newrec_.tax_liability IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'TAXLIABILITYNULL: There is no Tax Liability defined for delivery address :P1 and supply country :P2.', newrec_.ship_addr_no, Iso_Country_API.Get_Description(newrec_.supply_country, NULL));   
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);

   Iso_Country_Api.Exist(newrec_.supply_country);

   IF (newrec_.ship_addr_flag = 'N') THEN
     newrec_.ship_via_code := NULL;
     newrec_.delivery_terms := NULL;
   END IF;

   IF (trunc(newrec_.date_requested) > trunc(newrec_.latest_return_date)) THEN
      Error_SYS.Record_General(lu_name_, 'RTN_DATE_ERROR: Latest return date should be later than the date requested.');
   END IF;

   IF NOT (newrec_.tax_liability = 'TAX' OR newrec_.tax_liability = 'EXEMPT') THEN
      IF (newrec_.ship_addr_flag = 'N') THEN
         delivery_country_db_ := Cust_Ord_Customer_Address_API.Get_Country_Code(newrec_.return_from_customer_no, newrec_.ship_addr_no);
      ELSE
         delivery_country_db_ := newrec_.ship_addr_country_code;
      END IF;
      Tax_Handling_Order_Util_API.Validate_Tax_Liability(newrec_.tax_liability, delivery_country_db_);
   END IF;

   today_ := Site_API.Get_Site_Date(newrec_.contract);
   IF (newrec_.date_requested > today_) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGDATE: The Date Requested can not be later than todays date.');
   END IF;

   -- Update the license date in export license connect header if the date_requested has been changed.
   $IF Component_Expctr_SYS.INSTALLED $THEN
      IF (validate_export_license_ AND Customer_Order_Flow_API.Get_License_Enabled(newrec_.rma_no, 'INTERACT_RMA') = 'TRUE') THEN
         FOR line_ IN get_rma_line LOOP
            IF (newrec_.date_requested != oldrec_.date_requested) THEN
               connect_head_id_ := Exp_License_Connect_Head_API.Get_Connect_Id_From_Ref('RMA', newrec_.rma_no, line_.rma_line_no, NULL, NULL);
               connect_status_  := Exp_license_Connect_Head_API.Get_Objstate(connect_head_id_);
               -- Need to check both disconnect_ and connect_status_ since disconnect_ will be null when the status is Unconnected and Planned.
               IF (connect_head_id_ IS NOT NULL) AND ((disconnect_exp_license_ = 'TRUE') OR (connect_status_ IN ('Unconnected', 'Planned'))) THEN
                  Exp_License_Connect_Head_API.Set_License_Date(connect_head_id_, newrec_.date_requested);
               END IF;
            -- Checked date_requested_changed_ to avoid calling the method when user enters the same date_requested.
            ELSIF NOT date_requested_changed_ THEN
               Exp_License_Connect_Util_API.Check_Allow_Update(newrec_.rma_no, line_.rma_line_no, NULL, NULL, 'RMA');
            END IF;
         END LOOP;
       END IF;
   $END

   changed_rec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   IF (oldrec_.rowstate != 'Planned') AND (changed_rec_.return_approver_id) THEN
      Error_SYS.Record_General(lu_name_, 'NOUPDAPPROV: The approver ID may only be changed when status is planned.');
   END IF;
   IF (changed_rec_.return_approver_id AND (Credit_Approved(newrec_.rma_no) = 1 OR newrec_.rma_report_printed = Rma_Report_Printed_API.DB_PRINTED OR oldrec_.rowstate NOT IN('Planned', 'Released'))) THEN
      Error_SYS.Record_General(lu_name_, 'NOUPDATECOORDINATOR: The coordinator cannot be changed since the RMA has already been printed or credit approved.');
   END IF;

   IF (newrec_.ship_addr_no IS NOT NULL) THEN
      IF (Cust_Ord_Customer_Address_API.Is_Ship_Location
          (newrec_.return_from_customer_no, newrec_.ship_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTRMADELADDR: Invalid delivery address specified');
      END IF;
   END IF;

   IF (newrec_.customer_no_addr_no IS NOT NULL) THEN
      IF (Cust_Ord_Customer_Address_API.Is_Bill_Location(newrec_.customer_no, newrec_.customer_no_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTRMADOCADDR: The address :P1 is not specified as a document address for the customer :P2.',
                                    newrec_.customer_no_addr_no, newrec_.customer_no);
      END IF;
   END IF;

   -- validate update of customer to credit.
   IF (newrec_.customer_no_credit IS NOT NULL) THEN
      Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_NO_CREDIT_ADDR_NO', newrec_.customer_no_credit_addr_no);

      IF changed_rec_.customer_no_credit THEN
         -- changing customer to credit
         trace_sys.field(' changing customer to credit', newrec_.customer_no_credit);
         separator_           := '';
         has_different_payer_ := '';
         count_               := 0;
         FOR connected_order_ IN get_order_keys LOOP
            paying_customer_ := Customer_Order_API.Get_Customer_No_Pay(connected_order_.order_no);
            IF paying_customer_ IS NOT NULL THEN
               IF paying_customer_ != newrec_.customer_no_credit THEN
                  has_different_payer_ := (has_different_payer_ || separator_ ||
                                           to_char(connected_order_.rma_line_no) );
                  IF count_= 0 THEN
                     separator_ := ', ';
                  END IF;
                  count_ := count_ + 1;
               END IF;
            END IF;
         END LOOP;
         IF count_ = 1 THEN
            Client_SYS.Add_Warning(lu_name_, 'RMADIFFPAYER: ' ||
                                   'On the RMA line :P1, there is a connected order line that ' || chr(10) ||
                                   'were paid by another customer than the one to be credited; :P2.',
                                   p1_ => has_different_payer_,
                                   p2_ => newrec_.customer_no_credit);

         ELSIF count_> 1 THEN
            Client_SYS.Add_Warning(lu_name_, 'RMADIFFPAYERS: ' ||
                                   'On the RMA lines :P1, there are connected order lines ' || chr(10) ||
                                   'that were paid by other customers than the one to be credited :P2.',
                                   p1_ => has_different_payer_,
                                   p2_ => newrec_.customer_no_credit);
         END IF;
      END IF;
   END IF;

   IF (newrec_.contract != NVL(newrec_.return_to_contract, ' ') AND (newrec_.return_to_vendor_no IS NULL)) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         newrec_.return_to_vendor_no := Supplier_API.Get_Vendor_No_From_Contract(newrec_.return_to_contract);
      $ELSE
         NULL;
      $END
   END IF;
   
   IF Validate_SYS.Is_Changed(oldrec_.return_to_contract, newrec_.return_to_contract) AND 
      (newrec_.return_to_contract IS NOT NULL AND newrec_.contract != newrec_.return_to_contract) THEN
      OPEN get_rental_lines_count;
      FETCH get_rental_lines_count INTO count_;
      CLOSE get_rental_lines_count;
   
      IF (count_ > 0 ) THEN
         Error_SYS.Record_General(lu_name_,'EXISTRENTLINE: Changing the Return to Site field value is not allowed when the return material authorization includes rental lines.');
      END IF;
   END IF;

   $IF Component_Jinsui_SYS.INSTALLED $THEN
      Validate_Jinsui_Constraints___(newrec_);
   $END

   IF (newrec_.order_no IS NOT NULL) AND (newrec_.shipment_id IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'BOTH_NOT_ALLOWED: The customer order number and the shipment ID cannot be entered in the same instance.');
   END IF;

   IF changed_rec_.return_approver_id THEN
      Client_SYS.Add_To_Attr('REFRESH', 'TRUE', attr_);
   END IF;

   IF (newrec_.return_to_vendor_no IS NOT NULL AND changed_rec_.return_to_vendor_no) THEN
      Validate_Retn_To_Vendor_No___(newrec_.rma_no, newrec_.return_to_vendor_no);
   END IF;

   IF (newrec_.return_to_contract IS NOT NULL AND changed_rec_.return_to_contract) THEN
      Validate_Return_To_Contract___(newrec_.rma_no, newrec_.contract, newrec_.return_to_contract);
   END IF;

   IF changed_rec_.return_addr_no THEN
      Validate_Return_Addr_No___(newrec_.rma_no, newrec_.return_addr_no, newrec_.return_to_vendor_no, newrec_.return_to_contract);
   END IF;

   IF (newrec_.receipt_rma_no IS NOT NULL OR newrec_.originating_rma_no IS NOT NULL) THEN
      Restrict_Multi_Site_Update___(newrec_, oldrec_);
   END IF;

   IF ( changed_rec_.ship_addr_no OR changed_rec_.ship_addr_flag OR changed_rec_.ship_addr_country_code OR changed_rec_.ship_addr_name OR
        changed_rec_.ship_address1 OR changed_rec_.ship_address2 OR changed_rec_.ship_address3 OR changed_rec_.ship_address4 OR changed_rec_.ship_address5 OR changed_rec_.ship_address6 OR
        changed_rec_.ship_addr_zip_code OR changed_rec_.ship_addr_city OR changed_rec_.ship_addr_state OR changed_rec_.latest_return_date) THEN
      Modify_Supply_Site_Rma___(newrec_.rma_no, supply_attr_, changed_rec_, newrec_);
   END IF;

   IF (newrec_.ship_addr_flag = 'Y' AND newrec_.intrastat_exempt = 'INCLUDE' AND oldrec_.rowstate NOT IN ('Planned', 'Denied', 'Cancelled' ) AND
      (newrec_.ship_via_code IS NULL OR newrec_.delivery_terms IS NULL)) THEN
      return_addr_country_code_ := newrec_.return_addr_country_code;
      IF (return_addr_country_code_ IS NULL) THEN
         IF (newrec_.return_to_contract IS NULL) THEN
            return_addr_country_code_ := Supplier_Info_Address_API.Get_Country_Code(newrec_.return_to_vendor_no, newrec_.return_addr_no);
         ELSE
            return_addr_country_code_ := Company_Address_API.Get_Country_Db(Site_API.Get_Company(newrec_.return_to_vendor_no), newrec_.return_addr_no);
         END IF;
         IF (return_addr_country_code_ IS NULL) THEN
            return_addr_country_code_ := Company_Address_API.Get_Country_Db(Site_API.Get_Company(newrec_.contract), newrec_.return_addr_no);
         END IF;
      END IF;
      IF (return_addr_country_code_ != newrec_.ship_addr_country_code AND Iso_Country_API.Get_Eu_Member(return_addr_country_code_) = 'EU Member' AND Iso_Country_API.Get_Eu_Member(newrec_.ship_addr_country_code) = 'EU Member') THEN
         Validate_Ship_Via_Del_Term___(newrec_.rma_no);
      END IF;
   END IF;
END Check_Update___;

@Override
PROCEDURE Unpack___ (
   newrec_   IN OUT return_material_tab%ROWTYPE,
   indrec_   IN OUT Indicator_Rec,
   attr_     IN OUT VARCHAR2 )
IS
   ptr_           NUMBER;
   name_          VARCHAR2(30);
   value_         VARCHAR2(2000);
BEGIN
   IF (newrec_.rowstate IS NOT NULL) THEN
      IF (newrec_.rowstate = 'Cancelled') THEN
         ptr_ := NULL;
         WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
            IF (name_ NOT IN ('CANCEL_REASON', 'NOTE_TEXT')) THEN
               Error_SYS.Record_General(lu_name_, 'NOCHGCANCEL: The RMA is Canceled and may not be changed.');
            END IF;
         END LOOP;
      END IF;
   END IF;
   super(newrec_, indrec_, attr_);

END Unpack___;

-- Check_Cancel_Reason_Ref___
--   Perform validation on the CancelReasonRef reference.
PROCEDURE Check_Cancel_Reason_Ref___ (
   newrec_ IN OUT return_material_tab%ROWTYPE )
IS
BEGIN
   Order_Cancel_Reason_Api.Exist( newrec_.cancel_reason, Reason_Used_By_Api.DB_RETURN_MATERIAL );
END;

-- Build_Attr_For_New___ 
-- This method is used to build the attr_ which is used in method New.
FUNCTION Build_Attr_For_New___ (
	attr_ IN  VARCHAR2) RETURN VARCHAR2
IS
   new_attr_             VARCHAR2(32000);
   ptr_                  NUMBER;
   name_                 VARCHAR2(30);
   value_                VARCHAR2(2000);
   contract_             RETURN_MATERIAL_TAB.contract%TYPE;
   customer_no_          RETURN_MATERIAL_TAB.customer_no%TYPE;
   currency_code_        RETURN_MATERIAL_TAB.currency_code%TYPE;
   delivery_address_no_  RETURN_MATERIAL_TAB.ship_addr_no%TYPE;
   customer_no_addr_no_  RETURN_MATERIAL_TAB.customer_no_addr_no%TYPE;
   supply_country_       RETURN_MATERIAL.supply_country%TYPE;
   supply_country_db_    RETURN_MATERIAL_TAB.supply_country%TYPE;
   company_              VARCHAR2(20);
   return_from_customer_no_ RETURN_MATERIAL_TAB.return_from_customer_no%TYPE;
   use_price_incl_tax_db_   RETURN_MATERIAL_TAB.use_price_incl_tax%TYPE;
BEGIN
	-- Retrieve the default attribute values.
   Prepare_Insert___(new_attr_);

   contract_ := Client_SYS.Get_Item_Value('CONTRACT',attr_);
   customer_no_ := Client_SYS.Get_Item_Value('CUSTOMER_NO',attr_);
   return_from_customer_no_ := Client_SYS.Get_Item_Value('RETURN_FROM_CUSTOMER_NO',attr_);
   supply_country_db_ := Client_SYS.Get_Item_Value('SUPPLY_COUNTRY_DB',attr_);  
   IF supply_country_db_ IS NULL THEN
      supply_country_db_ :=  Company_Site_API.Get_Country_Db(contract_ );
   END IF;
   supply_country_ := ISO_Country_API.Decode(supply_country_db_);
   use_price_incl_tax_db_   := Client_SYS.Get_Item_Value('USE_PRICE_INCL_TAX_DB',attr_);

   IF (return_from_customer_no_ IS NULL) THEN
      return_from_customer_no_ := customer_no_;
   END IF;
   Client_SYS.Set_Item_Value('CUSTOMER_NO',customer_no_ , new_attr_);
   Client_SYS.Set_Item_Value('RETURN_FROM_CUSTOMER_NO', return_from_customer_no_ , new_attr_);
   Client_SYS.Set_Item_Value('CONTRACT',contract_ , new_attr_);
   Client_SYS.Set_Item_Value('SUPPLY_COUNTRY', supply_country_ , new_attr_);

   company_ := Site_API.Get_Company(contract_);
   Client_SYS.Set_Item_Value('USE_PRICE_INCL_TAX_DB', use_price_incl_tax_db_, new_attr_);
   Client_SYS.Set_Item_Value('DATE_REQUESTED',Site_API.Get_Site_Date(contract_), new_attr_);
   delivery_address_no_ := Client_SYS.Get_Item_Value('SHIP_ADDR_NO',attr_);
   IF (delivery_address_no_ IS NULL) THEN
     delivery_address_no_ := Cust_Ord_Customer_API.Get_Delivery_Address(return_from_customer_no_);
   END IF;
   Client_SYS.Set_Item_Value('TAX_LIABILITY', Tax_Handling_Util_API.Get_Customer_Tax_Liability(return_from_customer_no_, delivery_address_no_, company_, supply_country_db_), new_attr_);

   currency_code_ := Client_SYS.Get_Item_Value('CURRENCY_CODE',attr_);

   IF (currency_code_ IS NULL) THEN
      Client_SYS.Set_Item_Value('CURRENCY_CODE',Cust_Ord_Customer_API.Get_Currency_Code(customer_no_), new_attr_);
   END IF;

   Client_SYS.Set_Item_Value('SHIP_ADDR_NO', delivery_address_no_, new_attr_);
   customer_no_addr_no_ := Client_SYS.Get_Item_Value('CUSTOMER_NO_ADDR_NO',attr_);
   IF (customer_no_addr_no_ IS NULL) THEN
      customer_no_addr_no_ := Cust_Ord_Customer_API.Get_Document_Address(customer_no_);
   END IF;
   Client_SYS.Set_Item_Value('LANGUAGE_CODE',Cust_Ord_Customer_API.Get_Language_Code(customer_no_), new_attr_);

   --Replace the default attribute values with the ones passed in the inparameterstring.
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
   END LOOP;

   Client_SYS.Set_Item_Value('CUSTOMER_NO_ADDR_NO',customer_no_addr_no_, new_attr_);
   
   RETURN new_attr_;
END Build_Attr_For_New___;


-- Build_Attr_Supp_Rma_Head___ 
-- This method is used to build the attr_ which is used in method Create_Supply_Site_Rma_Header.
FUNCTION Build_Attr_Supp_Rma_Head___ (
	   rec_                IN  RETURN_MATERIAL_TAB%ROWTYPE,
      demand_rma_no_      IN  NUMBER,
      demand_rma_line_no_ IN  NUMBER) RETURN VARCHAR2
IS
   new_attr_              VARCHAR2(4000);
   rma_line_rec_          Return_Material_Line_API.Public_Rec;
   int_cust_order_no_     VARCHAR2(12);
   int_co_line_no_        VARCHAR2(4);
   int_co_rel_no_         VARCHAR2(4);
   int_co_line_item_no_   NUMBER;
   int_order_rec_         Customer_Order_API.Public_Rec;
   supply_country_db_     RETURN_MATERIAL_TAB.supply_country%TYPE;
   company_               VARCHAR2(20);
   int_cust_ship_addr_    VARCHAR2(50);
   int_customer_no_       RETURN_MATERIAL_TAB.customer_no%TYPE;
   currency_code_         RETURN_MATERIAL_TAB.currency_code%TYPE;
   customer_rec_          Cust_Ord_Customer_API.Public_Rec;
   cust_no_credit_        RETURN_MATERIAL_TAB.customer_no_credit%TYPE;
   cust_credit_addr_no_   RETURN_MATERIAL_TAB.customer_no_credit_addr_no%TYPE;
   cust_doc_address_      RETURN_MATERIAL_TAB.customer_no_addr_no%TYPE;
   jinsui_invoice_db_     RETURN_MATERIAL_TAB.jinsui_invoice%TYPE;
   supply_code_db_        VARCHAR2(3);
BEGIN
   Client_SYS.Clear_Attr(new_attr_);
   Client_SYS.Add_To_Attr('CONTRACT', rec_.return_to_contract, new_attr_);
   Client_SYS.Add_To_Attr('RETURN_TO_CONTRACT', rec_.return_to_contract, new_attr_);
   Client_SYS.Add_To_Attr('ORIGINATING_RMA_NO', demand_rma_no_, new_attr_);
   Client_SYS.Add_To_Attr('RETURN_APPROVER_ID', rec_.return_approver_id, new_attr_);
   Client_SYS.Add_To_Attr('LATEST_RETURN_DATE', rec_.latest_return_date, new_attr_);

   int_customer_no_ := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(rec_.contract);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', int_customer_no_, new_attr_);
   Client_SYS.Add_To_Attr('RETURN_FROM_CUSTOMER_NO', rec_.return_from_customer_no, new_attr_);

   rma_line_rec_ := return_Material_Line_API.Get(demand_rma_no_, demand_rma_line_no_);
   supply_code_db_ := Customer_Order_Line_API.Get_Supply_Code_Db(rma_line_rec_.order_no, rma_line_rec_.line_no, rma_line_rec_.rel_no, rma_line_rec_.line_item_no);

   IF ((rma_line_rec_.po_order_no IS NOT NULL) AND (supply_code_db_ IN ('IPD', 'IPT'))) THEN
      Customer_Order_Line_API.Get_Custord_From_Demand_Info(int_cust_order_no_, int_co_line_no_, int_co_rel_no_, int_co_line_item_no_, rma_line_rec_.po_order_no, rma_line_rec_.po_line_no, rma_line_rec_.po_rel_no, NULL, supply_code_db_);
      int_order_rec_ := Customer_Order_API.Get(int_cust_order_no_);
      currency_code_ := int_order_rec_.currency_code;
      cust_no_credit_ := int_order_rec_.customer_no_pay;
      cust_credit_addr_no_ := int_order_rec_.customer_no_pay_addr_no;
      cust_doc_address_ := NVL(int_order_rec_.bill_addr_no, Cust_Ord_Customer_API.Get_Document_Address(int_customer_no_));
      jinsui_invoice_db_ := int_order_rec_.jinsui_invoice;
   END IF;
   IF (int_cust_order_no_ IS NULL) THEN
      customer_rec_ := Cust_Ord_Customer_API.Get(int_customer_no_);
      currency_code_ := customer_rec_.currency_code;
      cust_doc_address_ := Cust_Ord_Customer_API.Get_Document_Address(int_customer_no_);
      jinsui_invoice_db_ := 'FALSE';
   END IF;

   Client_SYS.Add_To_Attr('CURRENCY_CODE', currency_code_, new_attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO_CREDIT', cust_no_credit_, new_attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO_CREDIT_ADDR_NO', cust_credit_addr_no_, new_attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO_ADDR_NO', cust_doc_address_, new_attr_);
   Client_SYS.Add_To_Attr('JINSUI_INVOICE_DB', jinsui_invoice_db_, new_attr_);
   Client_SYS.Set_Item_Value('DATE_REQUESTED', Site_API.Get_Site_Date(rec_.return_to_contract), new_attr_);
   Client_SYS.Set_Item_Value('LANGUAGE_CODE', Cust_Ord_Customer_API.Get_Language_Code(int_customer_no_), new_attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', Cust_Ord_Customer_Address_API.Get_Intrastat_Exempt_Db(rec_.return_from_customer_no,rec_.ship_addr_no), new_attr_);
   Client_SYS.Add_To_Attr('RMA_REPORT_PRINTED_DB', 'NOT PRINTED', new_attr_);

   supply_country_db_ := Iso_Country_API.Encode(Company_Site_API.Get_Country(rec_.return_to_contract));
   Client_SYS.Set_Item_Value('SUPPLY_COUNTRY_DB', supply_country_db_, new_attr_);
   Client_SYS.Add_To_Attr('SHIP_ADDR_NO', rec_.ship_addr_no, new_attr_);

   company_ := Site_API.Get_Company(rec_.return_to_contract);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(int_customer_no_, company_), new_attr_);
   int_cust_ship_addr_ := Cust_Ord_Customer_API.Get_Delivery_Address(int_customer_no_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY', NVL(Tax_Handling_Util_API.Get_Customer_Tax_Liability(int_customer_no_, int_cust_ship_addr_, company_, supply_country_db_), 'EXEMPT'), new_attr_);

   Client_SYS.Add_To_Attr('SHIP_ADDR_FLAG_DB', rec_.ship_addr_flag, new_attr_);

   IF (rec_.ship_addr_flag = 'Y') THEN
      Client_SYS.Add_To_Attr('SHIP_ADDRESS1', rec_.ship_address1, new_attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDRESS2', rec_.ship_address2, new_attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDRESS3', rec_.ship_address3, new_attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDRESS4', rec_.ship_address4, new_attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDRESS5', rec_.ship_address5, new_attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDRESS6', rec_.ship_address6, new_attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_ZIP_CODE', rec_.ship_addr_zip_code, new_attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_CITY', rec_.ship_addr_city, new_attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_STATE', rec_.ship_addr_state, new_attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_COUNTY', rec_.ship_addr_county, new_attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_COUNTRY_CODE', rec_.ship_Addr_country_code, new_attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_NAME', rec_.ship_addr_name, new_attr_);
   END IF;
   Client_SYS.Add_To_Attr('RETURN_ADDR_FLAG_DB', rec_.return_addr_flag, new_attr_);
   Client_SYS.Add_To_Attr('RETURN_ADDR_NO', rec_.return_addr_no, new_attr_);
   IF (rec_.return_addr_flag = 'Y') THEN
      Client_SYS.Add_To_Attr('RETURN_ADDRESS1', rec_.return_address1, new_attr_);
      Client_SYS.Add_To_Attr('RETURN_ADDRESS2', rec_.return_address2, new_attr_);
      Client_SYS.Add_To_Attr('RETURN_ADDRESS3', rec_.return_address3, new_attr_);
      Client_SYS.Add_To_Attr('RETURN_ADDRESS4', rec_.return_address4, new_attr_);
      Client_SYS.Add_To_Attr('RETURN_ADDRESS5', rec_.return_address5, new_attr_);
      Client_SYS.Add_To_Attr('RETURN_ADDRESS6', rec_.return_address6, new_attr_);
      Client_SYS.Add_To_Attr('RETURN_ADDR_ZIP_CODE', rec_.return_addr_zip_code, new_attr_);
      Client_SYS.Add_To_Attr('RETURN_ADDR_CITY', rec_.return_addr_city, new_attr_);
      Client_SYS.Add_To_Attr('RETURN_ADDR_STATE', rec_.return_addr_state, new_attr_);
      Client_SYS.Add_To_Attr('RETURN_ADDR_COUNTY', rec_.return_addr_county, new_attr_);
      Client_SYS.Add_To_Attr('RETURN_ADDR_COUNTRY_CODE', rec_.return_Addr_country_code, new_attr_);
      Client_SYS.Add_To_Attr('RETURN_ADDR_NAME', rec_.return_addr_name, new_attr_);
   END IF;
   RETURN new_attr_;
END Build_Attr_Supp_Rma_Head___;

FUNCTION Get_Company_Address___(
   company_     IN VARCHAR2,
   address_id_  IN VARCHAR2 )  RETURN Address_Rec
IS
   company_address_rec_   Company_Address_API.Public_Rec;
   address_rec_           Address_Rec;
BEGIN
   company_address_rec_ := Company_Address_API.Get(company_, address_id_); 
   address_rec_.address1 := company_address_rec_.address1;
   address_rec_.address2 := company_address_rec_.address2;
   address_rec_.address3 := company_address_rec_.address3;
   address_rec_.address4 := company_address_rec_.address4;
   address_rec_.address5 := company_address_rec_.address5;
   address_rec_.address6 := company_address_rec_.address6;
   address_rec_.city := company_address_rec_.city;
   address_rec_.state := company_address_rec_.state;
   address_rec_.zip_code := company_address_rec_.zip_code;
   address_rec_.county := company_address_rec_.county;
   address_rec_.country := company_address_rec_.country;   
   RETURN address_rec_;
END Get_Company_Address___;

FUNCTION Get_Customer_Address___(
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 )  RETURN Address_Rec
IS
   customer_address_rec_  Customer_Info_Address_API.Public_Rec;
   address_rec_           Address_Rec;
BEGIN
   customer_address_rec_ := Customer_Info_Address_API.Get(customer_id_, address_id_);
   address_rec_.address1 := customer_address_rec_.address1;
   address_rec_.address2 := customer_address_rec_.address2;
   address_rec_.address3 := customer_address_rec_.address3;
   address_rec_.address4 := customer_address_rec_.address4;
   address_rec_.address5 := customer_address_rec_.address5;
   address_rec_.address6 := customer_address_rec_.address6;
   address_rec_.city := customer_address_rec_.city;
   address_rec_.state := customer_address_rec_.state;
   address_rec_.zip_code := customer_address_rec_.zip_code;
   address_rec_.county := customer_address_rec_.county;
   address_rec_.country := customer_address_rec_.country;   
   RETURN address_rec_;
END Get_Customer_Address___;

FUNCTION Get_Customer_Order_Address___(
   order_no_ IN VARCHAR2 )  RETURN Address_Rec
IS
   order_address_rec_      Address_Rec;   
BEGIN
   order_address_rec_.address1 := Customer_Order_Address_API.Get_Address1(order_no_);
   order_address_rec_.address2 := Customer_Order_Address_API.Get_Address2(order_no_);
   order_address_rec_.address3 := Customer_Order_Address_API.Get_Address3(order_no_);
   order_address_rec_.address4 := Customer_Order_Address_API.Get_Address4(order_no_);
   order_address_rec_.address5 := Customer_Order_Address_API.Get_Address5(order_no_);
   order_address_rec_.address6 := Customer_Order_Address_API.Get_Address6(order_no_);
   order_address_rec_.city := Customer_Order_Address_API.Get_City(order_no_);
   order_address_rec_.state := Customer_Order_Address_API.Get_State(order_no_);
   order_address_rec_.zip_code := Customer_Order_Address_API.Get_Zip_Code(order_no_);
   order_address_rec_.county := Customer_Order_Address_API.Get_County(order_no_);
   order_address_rec_.country := Customer_Order_Address_API.Get_Country_Code(order_no_); 
   RETURN order_address_rec_;
END Get_Customer_Order_Address___;

$IF (Component_Purch_SYS.INSTALLED) $THEN
   FUNCTION Get_Supplier_Addr_Detail___(
      supplier_id_ IN VARCHAR2,
      address_id_  IN VARCHAR2 )  RETURN Address_Rec
   IS
      supplier_address_rec_  Supplier_Info_Address_API.Public_Rec;
      address_rec_           Address_Rec;
   BEGIN
      supplier_address_rec_ := Supplier_Info_Address_API.Get(supplier_id_, address_id_);
      address_rec_.address1 := supplier_address_rec_.address1;
      address_rec_.address2 := supplier_address_rec_.address2;
      address_rec_.address3 := supplier_address_rec_.address3;
      address_rec_.address4 := supplier_address_rec_.address4;
      address_rec_.address5 := supplier_address_rec_.address5;
      address_rec_.address6 := supplier_address_rec_.address6;
      address_rec_.city := supplier_address_rec_.city;
      address_rec_.state := supplier_address_rec_.state;
      address_rec_.zip_code := supplier_address_rec_.zip_code;
      address_rec_.county := supplier_address_rec_.county;
      address_rec_.country := supplier_address_rec_.country;  
      RETURN address_rec_;
   END Get_Supplier_Addr_Detail___;
$END
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Replacement_Order__
--   Create a Replacement order. Creates a customer order head. Returns the
--   Customer Order Number.
@UncheckedAccess
FUNCTION Create_Replacement_Order__ (
   rma_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN NULL;
END Create_Replacement_Order__;


-- Inquire_Operation__
--   Server side logic for what might have been hairy client evaluations.
@UncheckedAccess
FUNCTION Inquire_Operation__ (
   rma_no_    IN NUMBER,
   operation_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   result_ VARCHAR2(150) ;
   count_   NUMBER := 0;

   CURSOR get_lines IS
      SELECT rma_line_no
      FROM  RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rma_no_
      AND   credit_invoice_no IS NULL
      AND   order_no IS NOT NULL
      AND   rowstate NOT IN ('Denied', 'Cancelled');

BEGIN
   IF operation_ = 'CREDIT' THEN
      FOR lrec_  IN get_lines LOOP
         IF (Return_Material_Line_API.Inquire_Operation__(rma_no_, lrec_.rma_line_no, 'CREDIT') = 'FALSE' )
         THEN
            count_ := count_ + 1;
            IF(count_ > 0) THEN
               EXIT;
            END IF;
         END IF;
      END LOOP;
      IF count_ = 0 THEN
         result_ := 'TRUE';
      ELSE
         result_ := 'FALSE';
      END IF;
   END IF;
   
   RETURN result_;
END Inquire_Operation__;


-- Get_Allowed_Operations__
--   Returns a string used to determine which RMB operations should be allowed
--   for the specified return head.
@UncheckedAccess
FUNCTION Get_Allowed_Operations__ (
   rma_no_ IN NUMBER ) RETURN VARCHAR2
IS
   dummy_               NUMBER;
   operations_          VARCHAR2(20);
   rec_                 RETURN_MATERIAL_TAB%ROWTYPE;
   all_approved_        BOOLEAN;
   some_not_credited_   BOOLEAN := FALSE;
   some_credited_       BOOLEAN := FALSE;
   approve_allowed_     BOOLEAN := FALSE;

   CURSOR some_lines_not_credited IS
      SELECT rma_line_no
        FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rma_no_
         AND credit_invoice_no IS NULL
         AND credit_approver_id IS NOT NULL;

   CURSOR some_charges_not_credited IS
      SELECT 1
        FROM RETURN_MATERIAL_CHARGE_TAB
       WHERE rma_no = rma_no_
         AND credit_invoice_no IS NULL
         AND credit_approver_id IS NOT NULL;

   -- check for possible RMA lines to create correction invoice
   CURSOR line_exist_for_correction IS
      SELECT 1
        FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rma_no_
         AND debit_invoice_no IS NOT NULL
         AND credit_approver_id IS NOT NULL
         AND credit_invoice_no IS NULL;

   CURSOR some_lines_credited IS
      SELECT rma_line_no
        FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rma_no_
         AND credit_invoice_no IS NOT NULL
         AND credit_approver_id IS NOT NULL;

BEGIN

   rec_ := Get_Object_By_Keys___(rma_no_);
   --0 Release RMA
   IF (rec_.rowstate IN ('Planned')) THEN
      operations_ := 'R';
   ELSE
      operations_ := '*';
   END IF;

   --1 Deny RMA
   IF (rec_.rowstate IN ('Planned')) AND (All_Lines_Planned_Or_Denied___(rec_)) AND NOT(rec_.contract = rec_.return_to_contract AND rec_.originating_rma_no IS NOT NULL)
   THEN
      operations_ := operations_||'D';
   ELSE
      operations_ := operations_||'*';
   END IF;

    --2 Complete RMA
   IF (rec_.rowstate IN ('PartiallyReceived')) AND (All_Received_Handled___(rec_)) AND NOT(rec_.contract = rec_.return_to_contract AND rec_.originating_rma_no IS NOT NULL)
   THEN
      operations_ := operations_||'C';
   ELSE
      operations_ := operations_||'*';
   END IF;

   --3 Print RMA
   IF (rec_.rowstate NOT IN ('Denied', 'Planned', 'Cancelled')) THEN
      operations_ := operations_||'P';
   ELSE
      operations_ := operations_||'*';
   END IF;

   all_approved_ := All_Lines_Approved___(rec_);

   FOR line_rec_ IN some_lines_not_credited LOOP
      IF (Return_Material_Line_API.Check_Exch_Charge_Order(rec_.rma_no, line_rec_.rma_line_no) = 'FALSE') THEN
         some_not_credited_:= TRUE;
         EXIT;
      END IF;
   END LOOP;

   IF NOT some_not_credited_ THEN
      OPEN some_charges_not_credited;
      FETCH some_charges_not_credited INTO dummy_;
      some_not_credited_ := some_charges_not_credited%FOUND;
      CLOSE some_charges_not_credited;
   END IF;

   --4 Credit Invoice
   IF ((rec_.rowstate NOT IN ('Denied', 'Planned', 'Cancelled')) AND (some_not_credited_)) THEN
      operations_ := operations_||'I';
   ELSE
      operations_ := operations_||'*';
   END IF;

    IF NOT all_approved_ THEN
       approve_allowed_ := Credit_Approve_Allowed___(rec_.rma_no);
    END IF;

   --5 Approve For Credit
   IF ((rec_.rowstate NOT IN ('Denied', 'Planned', 'Cancelled'))
     AND (approve_allowed_))
   THEN
      operations_ := operations_||'A';
   ELSE
      operations_ := operations_||'*';
   END IF;

   --6 Remove Credit Approval
   IF (rec_.rowstate NOT IN ('Denied', 'Planned', 'Cancelled'))
     AND (all_approved_) AND some_not_credited_
   THEN
      operations_ := operations_||'M';
   ELSE
      operations_ := operations_||'*';
   END IF;

     --7 Correction Invoice
   IF (rec_.rowstate NOT IN ('Denied', 'Planned', 'Cancelled')) THEN
     -- check any appoved lines exist for RMA lines to create correction invoice
     OPEN line_exist_for_correction;
     FETCH line_exist_for_correction INTO dummy_;
     IF (line_exist_for_correction%FOUND) THEN
        operations_ := operations_||'C';
     ELSE
        operations_ := operations_||'*';
     END IF;
     CLOSE line_exist_for_correction;
   ELSE
     -- Planned/Denied state
     operations_ := operations_||'*';
   END IF;

   FOR line_rec_ IN some_lines_credited LOOP
      IF (Return_Material_Line_API.Check_Exch_Charge_Order(rec_.rma_no, line_rec_.rma_line_no) = 'FALSE') THEN
         some_credited_:= TRUE;
         EXIT;
      END IF;
   END LOOP;

   --8 Cancel RMA
   IF (rec_.rowstate IN ('Released', 'Planned'))
      AND NOT(rec_.rowstate IN ('Released') AND (some_not_credited_ OR some_credited_)) AND NOT(rec_.contract = rec_.return_to_contract AND rec_.originating_rma_no IS NOT NULL) THEN
      operations_ := operations_||'L';
   ELSE
      operations_ := operations_||'*';
   END IF;


   RETURN operations_;
END Get_Allowed_Operations__;


-- Set_Rma_Printed__
--   Call this function when the RMA has been printed to set the printed option.
--   Don't forget to refresh afterwards.
PROCEDURE Set_Rma_Printed__ (
   rma_no_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   message_    RETURN_MATERIAL_HISTORY_TAB.message_text%TYPE;
   newrec_     RETURN_MATERIAL_TAB%ROWTYPE;
   oldrec_     RETURN_MATERIAL_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   IF NOT Check_Exist___(rma_no_) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   ELSE
      oldrec_ := Get_Object_By_Keys___(rma_no_);
      IF (oldrec_.rma_report_printed = 'PRINTED') THEN
         Trace_SYS.Field('RMA_REPORT_PRINTED is already set to PRINTED for RMA_NO', rma_no_);
      ELSE
         Get_Id_Version_By_Keys___(objid_, objversion_, rma_no_);
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('RMA_REPORT_PRINTED_DB', 'PRINTED', attr_);
         newrec_ := oldrec_;
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

         message_ := Language_SYS.Translate_Constant(lu_name_, 'RMAPRINTED: RMA printed.');
         Return_Material_History_API.New(rma_no_, message_);
      END IF;
   END IF;
END Set_Rma_Printed__;


-- Exist_Charges__
--   Returns whether or not charges are used on an return.
@UncheckedAccess
FUNCTION Exist_Charges__ (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
  IF any_charges_exists___(rma_no_) THEN
     RETURN 1;
  ELSE
     RETURN 0;
  END IF;
END Exist_Charges__;


-- Get_Total_Base_Line__
--   Get the total line amount on the return in base currency.
@UncheckedAccess
FUNCTION Get_Total_Base_Line__ (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   total_base_price_ NUMBER := 0;
   CURSOR get_lines IS
      SELECT rma_no, rma_line_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   FOR rec_ IN get_lines LOOP
      -- In Return_Material_Line_API.Get_Line_Total_Base_Price base amount is derived from curr amount.
      total_base_price_ := total_base_price_ + Return_Material_Line_API.Get_Line_Total_Base_Price(rec_.rma_no, rec_.rma_line_no);
   END LOOP;
   RETURN NVL(total_base_price_,0);
END Get_Total_Base_Line__;


-- Get_Total_Base_Line_Gross__
--   Get the total line amount on the return in base currency.
@UncheckedAccess
FUNCTION Get_Total_Base_Line_Gross__ (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   total_base_line_gross_ NUMBER := 0;

   CURSOR get_lines IS
      SELECT rma_no, rma_line_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   FOR rec_ IN get_lines LOOP
      -- In Return_Material_Line_API.Get_Total_Base_Price_Incl_Tax base amount is derived from curr amount.
      total_base_line_gross_ := total_base_line_gross_ + Return_Material_Line_API.Get_Total_Base_Price_Incl_Tax(rec_.rma_no, rec_.rma_line_no);
   END LOOP;
   RETURN NVL(total_base_line_gross_,0);
END Get_Total_Base_Line_Gross__;


-- Get_Total_Sale_Line__
--   Get the total line amount on the return in return currency.
@UncheckedAccess
FUNCTION Get_Total_Sale_Line__ (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   total_sale_price_ NUMBER := 0;
   CURSOR get_lines IS
      SELECT rma_no, rma_line_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   FOR rec_ IN get_lines LOOP
      total_sale_price_ := total_sale_price_ + Return_Material_Line_API.Get_Line_Total_Price(rec_.rma_no, rec_.rma_line_no);
   END LOOP;
   RETURN NVL(total_sale_price_,0);
END Get_Total_Sale_Line__;


-- Get_Total_Sale_Line_Gross__
--   Get the total line amount including tax on the return in return currency.
@UncheckedAccess
FUNCTION Get_Total_Sale_Line_Gross__ (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   total_sale_price_ NUMBER := 0;
   CURSOR get_lines IS
      SELECT rma_no, rma_line_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   FOR rec_ IN get_lines LOOP
      total_sale_price_ := total_sale_price_ + Return_Material_Line_API.Get_Line_Total_Price_Incl_Tax(rec_.rma_no, rec_.rma_line_no);
   END LOOP;
   RETURN NVL(total_sale_price_,0);
END Get_Total_Sale_Line_Gross__;


-- Get_Total_Base_Charge__
--   Get the total charge amount on the return in base currency.
@UncheckedAccess
FUNCTION Get_Total_Base_Charge__ (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   total_base_charge_ NUMBER := 0;
   CURSOR get_charges IS
      SELECT rma_charge_no
      FROM   RETURN_MATERIAL_CHARGE_TAB
      WHERE  rma_no = rma_no_
      AND    rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   FOR rec_ IN get_charges LOOP
      -- In Return_Material_Charge_API.Get_Total_Base_Charged_Amount base amount is derived from curr amount.
      total_base_charge_ := Return_Material_Charge_API.Get_Total_Base_Charged_Amount(rma_no_, rec_.rma_charge_no) +  total_base_charge_;
   END LOOP;
   RETURN NVL(total_base_charge_, 0);
END Get_Total_Base_Charge__;


-- Get_Total_Base_Charge_Gross__
--   Get the total charge amount incl tax on the return in base currency.
@UncheckedAccess
FUNCTION Get_Total_Base_Charge_Gross__ (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   total_base_charge_gross_ NUMBER := 0;
   CURSOR get_charges IS
      SELECT rma_charge_no
      FROM   RETURN_MATERIAL_CHARGE_TAB
      WHERE  rma_no = rma_no_
      AND    rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   FOR rec_ IN get_charges LOOP
      -- In Return_Material_Charge_API.Get_Total_Base_Charged_Amount base amount is derived from curr amount.
      total_base_charge_gross_ := Return_Material_Charge_API.Get_Tot_Charged_Amt_Incl_Tax(rma_no_, rec_.rma_charge_no) +  total_base_charge_gross_;
   END LOOP;
   RETURN NVL(total_base_charge_gross_, 0);
END Get_Total_Base_Charge_Gross__;


-- Get_Total_Sale_Charge__
--   Get the total charge amount on the return in return currency.
@UncheckedAccess
FUNCTION Get_Total_Sale_Charge__ (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   total_sale_charge_ NUMBER := 0;

   CURSOR get_charges IS
      SELECT rma_charge_no
      FROM   RETURN_MATERIAL_CHARGE_TAB
      WHERE  rma_no = rma_no_
      AND    rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   FOR rec_ IN get_charges LOOP
      total_sale_charge_ := Return_Material_Charge_API.Get_Total_Charged_Amount(rma_no_, rec_.rma_charge_no) +  total_sale_charge_;
   END LOOP;
   RETURN NVL(total_sale_charge_, 0);
END Get_Total_Sale_Charge__;


-- Get_Total_Sale_Charge_Gross__
--   Get the total charge amount incl tax on the return in return currency.
@UncheckedAccess
FUNCTION Get_Total_Sale_Charge_Gross__ (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   total_sale_charge_gross_ NUMBER := 0;

   CURSOR get_charges IS
      SELECT rma_charge_no
      FROM   RETURN_MATERIAL_CHARGE_TAB
      WHERE  rma_no = rma_no_
      AND    rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   FOR rec_ IN get_charges LOOP
      total_sale_charge_gross_ := Return_Material_Charge_API.Get_Total_Charged_Amt_Incl_Tax(rma_no_, rec_.rma_charge_no) +  total_sale_charge_gross_;
   END LOOP;
   RETURN NVL(total_sale_charge_gross_, 0);
END Get_Total_Sale_Charge_Gross__;


-- Approve_For_Credit__
--   Called from client to approve a RMA for crediting. Iterates over the RMA
--   lines and Charges to set the apporver ID. If not allowed the procedure will fail.
PROCEDURE Approve_For_Credit__ (
   rma_no_ IN NUMBER )
IS

   CURSOR get_lines (rma_no_ NUMBER) IS
      SELECT rma_line_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    credit_invoice_no IS NULL
      AND    rowstate NOT IN ('Denied', 'Planned', 'Cancelled')
      AND    rental = Fnd_Boolean_API.DB_FALSE;

   CURSOR get_charges (rma_no_ NUMBER) IS
      SELECT rma_charge_no
      FROM   RETURN_MATERIAL_CHARGE_TAB
      WHERE  rma_no = rma_no_
      AND    credit_invoice_no IS NULL
      AND    rowstate NOT IN ('Denied', 'Planned');
BEGIN

   FOR line_rec_ IN get_lines(rma_no_) LOOP
      IF (Return_Material_Line_API.Check_Exch_Charge_Order(rma_no_,line_rec_.rma_line_no) = 'FALSE') THEN
         Return_Material_Line_API.Approve_For_Credit__(rma_no_,line_rec_.rma_line_no);
      END IF;
   END LOOP;

   FOR charge_rec_ IN get_charges(rma_no_) LOOP
      Return_Material_Charge_API.Approve_For_Credit__
        (rma_no_, charge_rec_.rma_charge_no);
   END LOOP;
END Approve_For_Credit__;


-- Child_Tax_Update_Possible__
--   Checks if at least one rma line/charge line exists that is not connected to order no,
--   debit invoice no credit invoice no and postings are not created for it.If found ,
--   it returns 1, otherwise 0.
@UncheckedAccess
FUNCTION Child_Tax_Update_Possible__ (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   update_possible_       NUMBER := 0;
   salerec_               Sales_Part_API.Public_Rec;
   dummy_                 NUMBER;

   CURSOR get_unconnected_rma_lines IS
      SELECT  contract,catalog_no, credit_invoice_no, qty_scrapped, qty_returned_inv, qty_received
        FROM  RETURN_MATERIAL_LINE_TAB
       WHERE  rma_no = rma_no_
         AND  order_no IS NULL
         AND  debit_invoice_no IS NULL
         AND  credit_invoice_no IS NULL;

   CURSOR unconnected_charges_exist IS
      SELECT  1
        FROM  RETURN_MATERIAL_CHARGE_TAB
       WHERE  rma_no = rma_no_
         AND  order_no IS NULL
         AND  credit_invoice_no IS NULL;

BEGIN
   --Check for rma lines
   FOR rec_ IN get_unconnected_rma_lines LOOP
      salerec_ := Sales_Part_API.Get(rec_.contract, rec_.catalog_no);

      --Checks if postings are created
      IF (NVL(rec_.qty_scrapped,0) > 0 ) OR (NVL(rec_.qty_returned_inv,0) > 0 ) OR
         ((NVL(rec_.qty_received,0) > 0) AND (salerec_.catalog_type ='NON'))  THEN
         update_possible_ := 0;
      ELSE
        update_possible_ := 1;
        EXIT;
      END IF;
   END LOOP;

   --Check for rma charges
   IF (update_possible_ = 0) THEN
      OPEN unconnected_charges_exist;
      FETCH unconnected_charges_exist INTO dummy_;
      IF (unconnected_charges_exist%FOUND) THEN
         update_possible_ := 1;
      END IF;
      CLOSE unconnected_charges_exist;
   END IF;

   RETURN update_possible_;
END Child_Tax_Update_Possible__;


-- Remove_Credit_Approval__
--   Called from client to remove approval for crediting. Iterates over the RMA
--   lines and Charges to reset the apporver ID. If not allowed the procedure will fail.
PROCEDURE Remove_Credit_Approval__ (
   rma_no_ IN NUMBER )
IS

   CURSOR get_lines (rma_no_ NUMBER) IS
      SELECT rma_line_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    credit_invoice_no IS NULL
      AND    rowstate NOT IN ('Denied', 'Cancelled', 'Planned')
      AND    rental = Fnd_Boolean_API.DB_FALSE;

   CURSOR get_charges (rma_no_ NUMBER) IS
      SELECT rma_charge_no
      FROM   RETURN_MATERIAL_CHARGE_TAB
      WHERE  rma_no = rma_no_
      AND    credit_invoice_no IS NULL
      AND    rowstate NOT IN ('Denied', 'Planned');
BEGIN
   FOR line_rec_ IN get_lines(rma_no_) LOOP
      IF (Return_Material_Line_API.Check_Exch_Charge_Order(rma_no_,line_rec_.rma_line_no) = 'FALSE') THEN
         Return_Material_Line_API.Remove_Credit_Approval__
           (rma_no_, line_rec_.rma_line_no);
      END IF;
   END LOOP;

   FOR charge_rec_ IN get_charges(rma_no_) LOOP
      Return_Material_Charge_API.Remove_Credit_Approval__
        (rma_no_, charge_rec_.rma_charge_no);
   END LOOP;
END Remove_Credit_Approval__;


-- Lock_By_Keys__
--   Server support to lock a specific instance of the logical unit.
PROCEDURE Lock_By_Keys__ (
   rma_no_ IN NUMBER )
IS
   rec_ RETURN_MATERIAL_TAB%ROWTYPE;
BEGIN
   -- Lock the RMA Header while it is being processed.
   rec_ := Lock_By_Keys___(rma_no_);
END Lock_By_Keys__;


-- Approve_Charges__
--   Approves charges connected to the RMA
PROCEDURE Approve_Charges__ (
   rma_no_ IN NUMBER )
IS
   CURSOR get_charges IS
      SELECT rma_charge_no
      FROM   RETURN_MATERIAL_CHARGE_TAB
      WHERE  rma_no = rma_no_
      AND    credit_approver_id IS NULL
      AND    rowstate NOT IN ('Denied','Planned');
BEGIN
   FOR charge_rec_ IN get_charges LOOP
      Return_Material_Charge_API.Approve_For_Credit__(rma_no_, charge_rec_.rma_charge_no);
   END LOOP;
END Approve_Charges__;


-- Is_Create_Credit_Allowed__
--   Checks whether a given RMA is eligible for create credit/correction invoice.
@UncheckedAccess
FUNCTION Is_Create_Credit_Allowed__ (
   rma_no_           IN NUMBER,
   invoice_category_ IN VARCHAR2 ) RETURN VARCHAR2
IS

   exist_ NUMBER;
   result_ VARCHAR2(5) := 'FALSE';

   CURSOR get_non_approved_lines_ IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rowstate NOT IN ('Denied', 'Cancelled')
      AND credit_approver_id IS NULL
      AND rma_no = rma_no_
      AND rental = Fnd_Boolean_API.DB_FALSE;

   CURSOR get_non_approved_charges_ IS
      SELECT 1
      FROM RETURN_MATERIAL_CHARGE_TAB
      WHERE rowstate != 'Denied'
      AND credit_approver_id IS NULL
      AND rma_no = rma_no_;


   CURSOR get_lines_for_corr IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE ((rowstate NOT IN ('Denied', 'Cancelled')
      AND credit_approver_id IS NULL)
      OR (credit_approver_id IS NOT NULL
      AND debit_invoice_no IS NULL
      AND credit_invoice_no IS NULL))
      AND rma_no = rma_no_
      AND rental = Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF (invoice_category_ = 'CREDIT') THEN
      OPEN get_non_approved_lines_;
      FETCH get_non_approved_lines_ INTO exist_;
      IF (get_non_approved_lines_%FOUND) THEN
         result_ := 'TRUE';
      ELSE
         OPEN get_non_approved_charges_;
         FETCH get_non_approved_charges_ INTO exist_;
         IF (get_non_approved_charges_%FOUND) THEN
            result_ := 'TRUE';
         END IF;
         CLOSE get_non_approved_charges_;
      END IF;
      CLOSE get_non_approved_lines_;
   ELSE
      OPEN get_lines_for_corr;
      FETCH get_lines_for_corr INTO exist_;
      IF (get_lines_for_corr%FOUND) THEN
         result_ := 'TRUE';
      END IF;
      CLOSE get_lines_for_corr;
   END IF;
   RETURN result_;
END Is_Create_Credit_Allowed__;


-- Set_Receipt_Rma_No__
--   This method is used to set the receipt_rma_no in given original rma.
PROCEDURE Set_Receipt_Rma_No__ (
   rma_no_         IN NUMBER,
   receipt_rma_no_ IN NUMBER )
IS
   newrec_      RETURN_MATERIAL_TAB%ROWTYPE;
   oldrec_      RETURN_MATERIAL_TAB%ROWTYPE;
   attr_        VARCHAR2(2000);
   objid_       RETURN_MATERIAL.objid%TYPE;
   objversion_  RETURN_MATERIAL.objversion%TYPE;
   indrec_      Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('RECEIPT_RMA_NO', receipt_rma_no_, attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_ , rma_no_);
   oldrec_ := Lock_By_Id___( objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Receipt_Rma_No__;

PROCEDURE Get_Customer_Address_Details__(
   default_value_structure_    IN OUT NOCOPY Return_Material_API.Default_Value_Struc_Rec,
   rma_addr_                   IN BOOLEAN DEFAULT FALSE,
   ship_addr_                  IN BOOLEAN DEFAULT FALSE,
   credit_addr_                IN BOOLEAN DEFAULT FALSE)
IS
   customer_address_rec_       Address_Rec;
   address_name_               Customer_Info_Address_Tab.name%TYPE;
   rma_addr_available_         BOOLEAN := FALSE;
   ship_addr_available_        BOOLEAN := FALSE;
   credit_addr_available_      BOOLEAN := FALSE;
   
   cust_ref_                   return_material_tab.cust_ref%TYPE :=  default_value_structure_.cust_ref;  
BEGIN
   IF (rma_addr_) THEN
      IF (default_value_structure_.customer_no_addr_no IS NULL) OR (default_value_structure_.customer_no IS NULL) THEN
         default_value_structure_.customer_no_addr_no := NULL;
         default_value_structure_.document_address_name := NULL;
      ELSE
         rma_addr_available_ := TRUE;
      END IF;
   END IF;
   
   IF (ship_addr_) THEN
      IF (default_value_structure_.ship_addr_no IS NULL) OR (default_value_structure_.customer_no IS NULL) THEN
         default_value_structure_.ship_addr_no := NULL;
         default_value_structure_.address_name := NULL;
      ELSE
         ship_addr_available_ := TRUE;
      END IF;
   END IF;
   
   IF (credit_addr_) THEN
      IF (default_value_structure_.customer_no_credit_addr_no IS NULL) OR (default_value_structure_.customer_no_credit IS NULL) THEN
         default_value_structure_.customer_no_credit_addr_no := NULL;
         default_value_structure_.credit_address_name := NULL;
      ELSE
         credit_addr_available_ := TRUE;
      END IF;     
   END IF;
   IF ((rma_addr_available_) OR (ship_addr_available_)) THEN
      address_name_ := NVL(Customer_Info_Address_API.Get_Name(default_value_structure_.customer_no, default_value_structure_.customer_no_addr_no), Cust_Ord_Customer_API.Get_Name(default_value_structure_.customer_no_addr_no));
      customer_address_rec_ := Get_Customer_Address___(default_value_structure_.customer_no, default_value_structure_.ship_addr_no); 
      default_value_structure_.address1 := customer_address_rec_.address1;
      default_value_structure_.address2 := customer_address_rec_.address2;
      default_value_structure_.address3 := customer_address_rec_.address3;
      default_value_structure_.address4 := customer_address_rec_.address4;
      default_value_structure_.address5 := customer_address_rec_.address5;
      default_value_structure_.address6 := customer_address_rec_.address6;
      default_value_structure_.city :=  customer_address_rec_.city;
      default_value_structure_.zip_code :=  customer_address_rec_.zip_code;
      default_value_structure_.county :=  customer_address_rec_.county;
      default_value_structure_.country_code :=  customer_address_rec_.country;
      IF (rma_addr_available_) THEN
         default_value_structure_.document_address_name := address_name_;
         IF (cust_ref_ IS NULL) THEN
           cust_ref_ := Cust_Ord_Customer_API.Fetch_Cust_Ref(default_value_structure_.customer_no, default_value_structure_.customer_no_addr_no, 'TRUE');
         END IF;
         default_value_structure_.reference_name := Contact_Util_API.Get_Cust_Contact_Name(default_value_structure_.customer_no, default_value_structure_.customer_no_addr_no, cust_ref_);
      END IF;
      IF (ship_addr_available_) THEN
         default_value_structure_.address_name := address_name_;
         default_value_structure_.delivery_country := Cust_Ord_Customer_Address_API.Get_Country_Code(default_value_structure_.customer_no, default_value_structure_.ship_addr_no);                             
         IF (default_value_structure_.tax_liability IS NULL) THEN
            default_value_structure_.tax_liability :=  Tax_Handling_Util_API.Get_Customer_Tax_Liability(default_value_structure_.customer_no, default_value_structure_.ship_addr_no, default_value_structure_.company, default_value_structure_.supply_country_db);
         END IF;
         IF (default_value_structure_.intrastat_exempt IS NULL) THEN
            default_value_structure_.intrastat_exempt := Cust_Ord_Customer_Address_API.Get_Intrastat_Exempt_Db(default_value_structure_.customer_no, default_value_structure_.ship_addr_no);
         END IF;
      END IF;
   END IF;
   IF (credit_addr_available_) THEN
      address_name_ := NVL(Customer_Info_Address_API.Get_Name(default_value_structure_.customer_no_credit, default_value_structure_.customer_no_credit_addr_no), Cust_Ord_Customer_API.Get_Name(default_value_structure_.customer_no_addr_no));
      customer_address_rec_ := Get_Customer_Address___(default_value_structure_.customer_no_credit, default_value_structure_.ship_addr_no); 
      default_value_structure_.address1 := customer_address_rec_.address1;
      default_value_structure_.address2 := customer_address_rec_.address2;
      default_value_structure_.address3 := customer_address_rec_.address3;
      default_value_structure_.address4 := customer_address_rec_.address4;
      default_value_structure_.address5 := customer_address_rec_.address5;
      default_value_structure_.address6 := customer_address_rec_.address6;
      default_value_structure_.city :=  customer_address_rec_.city;
      default_value_structure_.zip_code :=  customer_address_rec_.zip_code;
      default_value_structure_.county :=  customer_address_rec_.county;
      default_value_structure_.country_code :=  customer_address_rec_.country;
      
      default_value_structure_.credit_address_name := address_name_;
   END IF; 
END Get_Customer_Address_Details__;


PROCEDURE Get_Return_To_Information__(
   return_to_company_   OUT    VARCHAR2,
   return_addr_no_      OUT    VARCHAR2,
   return_addr_name_    OUT    VARCHAR2,
   address_rec_         OUT    Address_Rec,
   info_                OUT    VARCHAR2,
   return_to_contract_  IN OUT VARCHAR2,   
   return_to_vendor_no_ IN     VARCHAR2,   
   contract_            IN     VARCHAR2,
   company_             IN     VARCHAR2 ) 
IS  
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      pay_term_id_          VARCHAR2(20);
      supplier_category_db_ VARCHAR2(20);
   $END
BEGIN
   IF (return_to_vendor_no_ IS NOT NULL) THEN
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         Supplier_API.Get_Supplier_Payment_Term_Id(info_, pay_term_id_, company_, return_to_vendor_no_);
         IF (Supplier_API.Exists(return_to_vendor_no_)) THEN
            supplier_category_db_ := Supplier_API.Get_Category_Db(return_to_vendor_no_);
            IF (Supplier_API.Get_Category_Db(return_to_vendor_no_) = 'I') THEN 
               return_to_contract_ := Supplier_API.Get_Acquisition_Site(return_to_vendor_no_); 
               return_to_company_ := Site_API.Get_Company(return_to_contract_); 
               return_addr_no_ := NVL(Site_API.Get_Delivery_Address(return_to_contract_), Company_Address_Type_API.Get_Company_Address_Id(return_to_company_, Address_Type_Code_API.Decode('DELIVERY'),'TRUE')); 
               return_addr_name_ := Company_Address_Deliv_Info_API.Get_Address_Name(return_to_company_, return_addr_no_);
               address_rec_  := Get_Company_Address___(return_to_company_, return_addr_no_); 
            ELSE 
               return_to_contract_ := NULL;  
               return_to_company_ := company_; 
               return_addr_no_ := Supplier_Info_Address_API.Get_Default_Address(return_to_vendor_no_, Address_Type_Code_API.Decode('DELIVERY'));
               return_addr_name_ := Supplier_Info_Address_API.Get_Name(return_to_vendor_no_, return_addr_no_);
               address_rec_ := Get_Supplier_Addr_Detail___(return_to_vendor_no_, return_addr_no_); 
            END IF; 
         ELSE
               return_to_company_ := company_; 
               return_addr_no_ := Company_Address_Type_API.Get_Company_Address_Id(return_to_company_, Address_Type_Code_API.Decode('DELIVERY'),'TRUE'); 
               return_addr_name_ := Company_Address_Deliv_Info_API.Get_Address_Name(return_to_company_, return_addr_no_);
               address_rec_  := Get_Company_Address___(return_to_company_, return_addr_no_); 
         END IF;
      $ELSE
         Error_SYS.Record_General(lu_name_, 'PURCHNOTINSTALLED: Purch Component is not installed');
      $END
   ELSE
      IF (return_to_contract_ IS NULL) THEN
         return_to_contract_ := contract_;   
      END IF;
      return_to_company_ := Site_API.Get_Company(return_to_contract_); 
      return_addr_no_ := NVL(Site_API.Get_Delivery_Address(return_to_contract_), Company_Address_Type_API.Get_Company_Address_Id(return_to_company_, Address_Type_Code_API.Decode('DELIVERY'),'TRUE')); 
      return_addr_name_ := Company_Address_Deliv_Info_API.Get_Address_Name(return_to_company_, return_addr_no_);
      address_rec_  := Get_Company_Address___(return_to_company_, return_addr_no_); 
   END IF;
END Get_Return_To_Information__;

PROCEDURE Get_Return_Address__(
   return_addr_name_    OUT    VARCHAR2,
   address_rec_         OUT    Address_Rec,   
   return_addr_no_      IN VARCHAR2,
   return_to_vendor_no_ IN VARCHAR2,
   return_to_contract_  IN VARCHAR2,
   return_to_company_   IN VARCHAR2 )
IS
BEGIN
   IF (return_addr_no_ IS NOT NULL) THEN
      IF (return_to_contract_ IS NOT NULL) THEN
         return_addr_name_ := Company_Address_Deliv_Info_API.Get_Address_Name(return_to_company_, return_addr_no_);
         address_rec_  := Get_Company_Address___(return_to_company_, return_addr_no_); 
      ELSE
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            return_addr_name_ := Supplier_Info_Address_API.Get_Name(return_to_vendor_no_, return_addr_no_);
            address_rec_ := Get_Supplier_Addr_Detail___(return_to_vendor_no_, return_addr_no_); 
         $ELSE
            Error_SYS.Record_General(lu_name_, 'PURCHNOTINSTALLED: Purch Component is not installed');
         $END         
      END IF;
   ELSE
      return_addr_name_ := NULL;
      address_rec_.address1 := NULL;
      address_rec_.address2 := NULL;
      address_rec_.address3 := NULL;
      address_rec_.address4 := NULL;
      address_rec_.address5 := NULL;
      address_rec_.address6 := NULL;
      address_rec_.city := NULL;
      address_rec_.state := NULL;
      address_rec_.zip_code := NULL;
      address_rec_.county := NULL;
      address_rec_.country := NULL;        
   END IF;
END Get_Return_Address__;

PROCEDURE Get_Rma_Customer_Defaults__ (
   default_value_structure_ IN OUT NOCOPY Return_Material_API.Default_Value_Struc_Rec,
   contract_                IN VARCHAR2,
   customer_no_             IN VARCHAR2,
   supply_country_db_       IN VARCHAR2,
   company_                 IN VARCHAR2,
   order_no_                IN VARCHAR2,
   shipment_id_             IN VARCHAR2,
   ship_addr_no_            IN VARCHAR2)
IS
   cust_attr_    VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(cust_attr_);
   IF (customer_no_ IS NOT NULL) THEN
      -- Fetch Customer Defaults
      Client_SYS.Set_Item_Value('CONTRACT', contract_, cust_attr_);
      Client_SYS.Set_Item_Value('CUSTOMER_NO', customer_no_, cust_attr_);
      Client_SYS.Set_Item_Value('SUPPLY_COUNTRY', supply_country_db_, cust_attr_);  
   
      IF (order_no_ IS NULL) AND (shipment_id_ IS NULL) THEN
         Client_SYS.Set_Item_Value('SHIP_ADDR_NO', Cust_Ord_Customer_API.Get_Delivery_Address(customer_no_), cust_attr_);      
      ELSIF (ship_addr_no_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('SHIP_ADDR_NO', ship_addr_no_, cust_attr_);               
      END IF;
   
      Customer_Order_API.Get_Customer_Defaults__(cust_attr_);
      
      default_value_structure_.contract := contract_;      
      default_value_structure_.customer_no := customer_no_;
      default_value_structure_.supply_country_db := supply_country_db_;
      
      default_value_structure_.return_from_customer_no := customer_no_;
      default_value_structure_.company := company_;
      default_value_structure_.currency_code := Client_SYS.Get_Item_Value('CURRENCY_CODE', cust_attr_);
      
      default_value_structure_.customer_no_addr_no := Client_SYS.Get_Item_Value('BILL_ADDR_NO', cust_attr_);
      default_value_structure_.document_address_name := Client_SYS.Get_Item_Value('DOCUMENT_ADDRESS_NAME', cust_attr_);     
      default_value_structure_.ship_addr_no := Client_SYS.Get_Item_Value('SHIP_ADDR_NO', cust_attr_);
      default_value_structure_.address_name := Client_SYS.Get_Item_Value('ADDRESS_NAME', cust_attr_);
      default_value_structure_.customer_no_credit := Client_SYS.Get_Item_Value('CUSTOMER_NO_PAY', cust_attr_);
      default_value_structure_.customer_no_credit_addr_no := Client_SYS.Get_Item_Value('CUSTOMER_NO_PAY_ADDR_NO', cust_attr_);
      default_value_structure_.credit_address_name := Client_SYS.Get_Item_Value('CREDIT_ADDRESS_NAME', cust_attr_);
      default_value_structure_.language_code := Client_SYS.Get_Item_Value('LANGUAGE_CODE', cust_attr_);
      default_value_structure_.cust_ref := Client_SYS.Get_Item_Value('CUST_REF', cust_attr_);      
      default_value_structure_.reference_name := Client_SYS.Get_Item_Value('REFERENCE_NAME', cust_attr_);
      default_value_structure_.tax_liability := Client_SYS.Get_Item_Value('TAX_LIABILITY', cust_attr_);
      default_value_structure_.intrastat_exempt := Client_SYS.Get_Item_Value('INTRASTAT_EXEMPT_DB', cust_attr_);
      
      -- Fetch Address Related Details
      Get_Customer_Address_Details__(default_value_structure_, TRUE, TRUE, TRUE);
      default_value_structure_.use_price_incl_tax_db := (Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(default_value_structure_.customer_no, default_value_structure_.company) = 'TRUE');
   END IF;
END Get_Rma_Customer_Defaults__;

PROCEDURE Get_Rma_Contract_Defaults__(
   default_value_structure_ IN OUT     Return_Material_API.Default_Value_Struc_Rec,
   contract_                IN VARCHAR2,
   customer_no_             IN VARCHAR2,
   order_no_                IN VARCHAR2,
   shipment_id_             IN VARCHAR2,
   ship_addr_no_            IN VARCHAR2 )
IS
   company_                     VARCHAR2(20);
   supply_country_db_           return_material_tab.supply_country%TYPE; 
   return_address_rec_          Address_Rec;
   info_                        VARCHAR2(2000);

BEGIN
   company_ := Site_API.Get_Company(contract_);
   supply_country_db_ := Company_Site_API.Get_Country_Db(contract_);
   IF (customer_no_ IS NOT NULL) THEN
      Get_Rma_Customer_Defaults__ (default_value_structure_,
                                  contract_,
                                  customer_no_,
                                  supply_country_db_,
                                  company_,
                                  order_no_,
                                  shipment_id_,
                                  ship_addr_no_);
   ELSE
      default_value_structure_.contract := contract_;
      default_value_structure_.company := company_;
      default_value_structure_.supply_country_db := supply_country_db_;
      default_value_structure_.use_price_incl_tax_db := (Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(default_value_structure_.customer_no, default_value_structure_.company) = 'TRUE');
   END IF;
   default_value_structure_.return_to_contract := default_value_structure_.contract;
   
   -- Fetch Return To information
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      default_value_structure_.return_to_vendor_no := Supplier_API.Get_Vendor_No_From_Contract(contract_);
   $END
   Get_Return_To_Information__(default_value_structure_.return_to_company,
                               default_value_structure_.return_addr_no,
                               default_value_structure_.return_addr_name,
                               return_address_rec_,
                               info_,
                               default_value_structure_.return_to_contract,   
                               default_value_structure_.return_to_vendor_no,   
                               contract_,
                               company_);
   default_value_structure_.return_address1 := return_address_rec_.address1;
   default_value_structure_.return_address2 := return_address_rec_.address2;
   default_value_structure_.return_address3 := return_address_rec_.address3;
   default_value_structure_.return_address4 := return_address_rec_.address4;
   default_value_structure_.return_address5 := return_address_rec_.address5;
   default_value_structure_.return_address6 := return_address_rec_.address6;
   default_value_structure_.return_addr_city := return_address_rec_.city;
   default_value_structure_.return_addr_state :=  return_address_rec_.state;
   default_value_structure_.return_addr_zip_code := return_address_rec_.zip_code;
   default_value_structure_.return_addr_county := return_address_rec_.county;
   default_value_structure_.return_addr_country_code := return_address_rec_.country;
END Get_Rma_Contract_Defaults__;

PROCEDURE Get_Address_Related_Details__(
   single_occ_address_rec_  OUT Address_Rec,
   address_rec_             OUT Address_Rec,  
   ship_addr_name_          OUT VARCHAR2,
   document_address_name_   OUT VARCHAR2,
   address_name_            OUT VARCHAR2,
   ship_addr_flag_          OUT VARCHAR2,
   ship_addr_no_            IN OUT VARCHAR2,
   customer_no_addr_no_     IN OUT VARCHAR2,
   customer_no_             IN VARCHAR2,   
   return_from_customer_no_ IN VARCHAR2,
   order_no_                IN VARCHAR2,
   shipment_id_             IN NUMBER )
IS
   customer_order_rec_       Customer_Order_API.Public_Rec;
   shipment_rec_             Shipment_API.Public_Rec;
   connected_obj_addr_flag_  VARCHAR2(1);
BEGIN
   IF (order_no_ IS NOT NULL) THEN
      customer_order_rec_ := Customer_Order_API.Get(order_no_);
      ship_addr_no_ := customer_order_rec_.ship_addr_no;
      customer_no_addr_no_ := customer_order_rec_.bill_addr_no;
      connected_obj_addr_flag_ := customer_order_rec_.addr_flag;
      IF (customer_order_rec_.addr_flag = 'Y') THEN
         single_occ_address_rec_  := Get_Customer_Order_Address___( order_no_);   
         ship_addr_name_ := Customer_Order_Address_API.Get_Addr_1(order_no_);    
      END IF;
   ELSIF (shipment_id_ IS NOT NULL) THEN
      shipment_rec_ := Shipment_API.Get(shipment_id_);
      ship_addr_no_ := shipment_rec_.receiver_addr_id;
      connected_obj_addr_flag_ := shipment_rec_.addr_flag;
      IF (shipment_rec_.addr_flag = 'Y') THEN
         single_occ_address_rec_.address1 :=  shipment_rec_.Receiver_Address1;
         single_occ_address_rec_.address3 :=  shipment_rec_.Receiver_Address2;
         single_occ_address_rec_.address3 :=  shipment_rec_.Receiver_Address3;
         single_occ_address_rec_.address4 :=  shipment_rec_.Receiver_Address4;
         single_occ_address_rec_.address5 :=  shipment_rec_.Receiver_Address5;
         single_occ_address_rec_.address6 :=  shipment_rec_.Receiver_Address6;
         single_occ_address_rec_.city := shipment_rec_.receiver_city;
         single_occ_address_rec_.state := shipment_rec_.receiver_state;
         single_occ_address_rec_.zip_code := shipment_rec_.receiver_zip_code;
         single_occ_address_rec_.county := shipment_rec_.receiver_county;
         single_occ_address_rec_.country := shipment_rec_.receiver_country;
         ship_addr_name_ := Customer_Order_Address_API.Get_Addr_1(order_no_);    
      END IF;
   ELSIF (customer_no_ IS NOT NULL) THEN
      ship_addr_no_ := Cust_Ord_Customer_API.Get_Delivery_Address(customer_no_);
      customer_no_addr_no_ := Cust_Ord_Customer_API.Get_Document_Address(customer_no_);
      connected_obj_addr_flag_ := 'N';      
      single_occ_address_rec_.address1 :=  NULL;
      single_occ_address_rec_.address3 :=  NULL;
      single_occ_address_rec_.address3 :=  NULL;
      single_occ_address_rec_.address4 :=  NULL;
      single_occ_address_rec_.address5 :=  NULL;
      single_occ_address_rec_.address6 :=  NULL;
      single_occ_address_rec_.city := NULL;
      single_occ_address_rec_.state := NULL;
      single_occ_address_rec_.zip_code := NULL;
      single_occ_address_rec_.county := NULL;
      ship_addr_name_ := NULL;          
   END IF;
   IF (connected_obj_addr_flag_ = 'Y') THEN
      ship_addr_flag_ := 'Y';
   ELSE
      ship_addr_flag_ := 'N';
      address_rec_ := Get_Customer_Address___(return_from_customer_no_, ship_addr_no_);  
      address_name_ := NVL(Customer_Info_Address_API.Get_Name(return_from_customer_no_, ship_addr_no_), Cust_Ord_Customer_API.Get_Name(return_from_customer_no_));              
   END IF;
   document_address_name_ := NVL(Customer_Info_Address_API.Get_Name(customer_no_, customer_no_addr_no_), Cust_Ord_Customer_API.Get_Name(customer_no_addr_no_));   
END Get_Address_Related_Details__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist_Rma_For_Invoice
--   Check for any return material lines connected to the given invoice id and company
@UncheckedAccess
FUNCTION Check_Exist_Rma_For_Invoice (
   invoice_no_ IN VARCHAR2,
   company_ IN VARCHAR2) RETURN VARCHAR2
IS
   dummy_ NUMBER;

   CURSOR get_rma_lines IS
      SELECT 1
      FROM  return_material_line_tab
      WHERE debit_invoice_no = invoice_no_
      AND   company = company_ ;
BEGIN
   OPEN  get_rma_lines;
   FETCH get_rma_lines INTO dummy_;
   IF NOT get_rma_lines%FOUND THEN
      CLOSE get_rma_lines;
      RETURN 'FALSE';
   END IF;
   CLOSE get_rma_lines;
   RETURN 'TRUE';
END Check_Exist_Rma_For_Invoice;


-- Check_Exist_Rma_For_Order
--   Check for any return material lines connected to the given order number
@UncheckedAccess
FUNCTION Check_Exist_Rma_For_Order (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;

   CURSOR get_rma_lines IS
      SELECT 1
      FROM return_material_line_tab
      WHERE  order_no = order_no_;
BEGIN
   OPEN  get_rma_lines;
   FETCH get_rma_lines INTO dummy_;
   IF NOT get_rma_lines%FOUND THEN
      CLOSE get_rma_lines;
      RETURN 'FALSE';
   END IF;
   CLOSE get_rma_lines;
   RETURN 'TRUE';
END Check_Exist_Rma_For_Order;


@UncheckedAccess
FUNCTION Get_Ship_Addr_Country (
   rma_no_ IN NUMBER ) RETURN VARCHAR2
IS
  rec_   RETURN_MATERIAL_API.Public_Rec;
BEGIN
   rec_ := Get(rma_no_);
   RETURN Cust_Ord_Customer_Address_API.Get_Country_Code(rec_.return_from_customer_no, rec_.ship_addr_no);
END Get_Ship_Addr_Country;


-- Refresh_State
--   Refreshes the state. Called from lines when state changes on the linses
--   to make shure the state on the header is changed when it should.
PROCEDURE Refresh_State (
   rma_no_ IN NUMBER )
IS
   rec_        RETURN_MATERIAL_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Lock_By_Keys_Nowait___(rma_no_);
   Finite_State_Machine___(rec_, 'RefreshState', attr_);
   trace_sys.field (' RMA refresh state :', attr_);
END Refresh_State;


-- Is_Release_Allowed
--   To check whether it is allowed to perform Release
PROCEDURE Is_Release_Allowed (
   rma_no_ IN NUMBER )
IS
   rec_    RETURN_MATERIAL_TAB%ROWTYPE;
   attr_   VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Get_Object_By_Keys___(rma_no_);
   Release_Allowed___(rec_, attr_);
END Is_Release_Allowed;


-- Get_Total_Base_Price
--   Gets the total base price for the RMA.
@UncheckedAccess
FUNCTION Get_Total_Base_Price (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN get_total_base_line__(rma_no_)+get_total_base_charge__(rma_no_);
END Get_Total_Base_Price;


-- Get_Total_Sale_Price
--   Gets the total sale price for the RMA.
@UncheckedAccess
FUNCTION Get_Total_Sale_Price (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN get_total_sale_line__(rma_no_)+get_total_sale_charge__(rma_no_);
END Get_Total_Sale_Price;


@UncheckedAccess
PROCEDURE Get_All_Totals (
   line_total_curr_   OUT NUMBER,
   line_total_gross_curr_     OUT NUMBER,
   line_total_base_   OUT NUMBER,
   line_total_gross_base_     OUT NUMBER,
   charge_total_curr_ OUT NUMBER,
   charge_total_base_ OUT NUMBER,
   charge_total_gross_curr_   OUT NUMBER,
   total_curr_        OUT NUMBER,
   total_base_        OUT NUMBER,
   rma_no_            IN  NUMBER )
IS
BEGIN
   line_total_curr_   :=  NVL(Get_Total_Sale_Line__(rma_no_), 0);
   line_total_gross_curr_   := NVL(Get_Total_Sale_Line_Gross__(rma_no_), 0);
   line_total_base_   :=  NVL(Get_Total_Base_Line__(rma_no_), 0);
   line_total_gross_base_   := NVL(Get_Total_Base_Line_Gross__(rma_no_), 0);
   charge_total_curr_ :=  NVL(Get_Total_Sale_Charge__(rma_no_), 0);
   charge_total_base_ :=  NVL(Get_Total_Base_Charge__(rma_no_), 0);
   charge_total_gross_curr_ := NVL(Get_Total_Sale_Charge_Gross__(rma_no_), 0);

   total_curr_ := line_total_curr_ + charge_total_curr_;
   total_base_ := line_total_base_ + charge_total_base_;

END Get_All_Totals;

-- Get_Rma_Total_Tax_Amount
--   Returns the  total tax
--   Returns the  total tax in base currenvy
@UncheckedAccess
FUNCTION Get_Rma_Total_Tax_Amount (
   rma_no_ IN NUMBER ) RETURN NUMBER

IS
   total_tax_amount_  NUMBER := 0;
   ordrec_            RETURN_MATERIAL_TAB%ROWTYPE;
   company_           VARCHAR2(20);
   rounding_          NUMBER;

   CURSOR get_lines IS
      SELECT rma_no,rma_line_no , order_no ,currency_rate, conv_factor,company
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   ordrec_ := Get_Object_By_Keys___(rma_no_);
   company_ := Site_API.Get_Company(ordrec_.contract);
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_,ordrec_.currency_code);

   FOR next_line_ IN get_lines LOOP
      total_tax_amount_ := total_tax_amount_ + Return_Material_Line_API.Get_Total_Tax_Amount_Curr(rma_no_, next_line_.rma_line_no);
   END LOOP;
   total_tax_amount_ := ROUND(total_tax_amount_, rounding_);

   RETURN total_tax_amount_;
END Get_Rma_Total_Tax_Amount;


@UncheckedAccess
FUNCTION Get_Rma_Total_Tax_Amount_Base (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   total_tax_amount_base_  NUMBER := 0;
   ordrec_            RETURN_MATERIAL_TAB%ROWTYPE;
   company_           VARCHAR2(20);
   rounding_          NUMBER;

   CURSOR get_lines IS
      SELECT rma_line_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   ordrec_ := Get_Object_By_Keys___(rma_no_);
   company_ := Site_API.Get_Company(ordrec_.contract);
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, ordrec_.currency_code);

   FOR next_line_ IN get_lines LOOP
      total_tax_amount_base_ := total_tax_amount_base_ + Return_Material_Line_API.Get_Total_Tax_Amount_Base(rma_no_, next_line_.rma_line_no);
   END LOOP;

   RETURN ROUND(total_tax_amount_base_, rounding_);
END Get_Rma_Total_Tax_Amount_Base;


-- Get_Gross_Amount
--   Return the total Gross Amount
@UncheckedAccess
FUNCTION Get_Gross_Amount (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   total_net_amount_    NUMBER;
   total_tax_amount_    NUMBER;
   total_gross_amount_  NUMBER;
BEGIN
   total_net_amount_           := Get_Total_Sale_Line__(rma_no_);
   total_tax_amount_           := Get_Rma_Total_Tax_Amount(rma_no_) ;
   total_gross_amount_         := total_net_amount_ + total_tax_amount_;
   RETURN total_gross_amount_;
END Get_Gross_Amount;

-- New
--   Public interface for creating a new RMA.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS  
      new_attr_               VARCHAR2(32000);
      newrec_                 RETURN_MATERIAL_TAB%ROWTYPE;
      objid_                  RETURN_MATERIAL.objid%TYPE;
      objversion_             RETURN_MATERIAL.objversion%TYPE;
      indrec_      Indicator_Rec;
BEGIN
   new_attr_ := Build_Attr_For_New___(attr_);

   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);

   info_ := Client_SYS.Get_All_Info;
   attr_ := new_attr_;
END New;


-- Get_Tot_Charge_Sale_Tax_Amt
--   Returns the Total charge tax amount
@UncheckedAccess
FUNCTION Get_Tot_Charge_Sale_Tax_Amt (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   total_tax_amount_  NUMBER := 0;
   next_line_tax_     NUMBER := 0;

   CURSOR get_lines IS
      SELECT rma_charge_no
        FROM RETURN_MATERIAL_CHARGE_TAB
       WHERE rma_no = rma_no_;
BEGIN
   IF (Exist_Charges__(rma_no_) = 0) THEN
      total_tax_amount_ := 0;
   ELSE
      FOR next_line_ IN get_lines LOOP
         next_line_tax_ := Return_Material_Charge_API.Get_Total_Tax_Amount_Curr(rma_no_, next_line_.rma_charge_no);
         total_tax_amount_ := total_tax_amount_ + next_line_tax_;
      END LOOP;
   END IF;
   RETURN total_tax_amount_;
END Get_Tot_Charge_Sale_Tax_Amt;


-- Disconnect_Case_Task
--   This method updates the case_id and the task_id by the passed null values
PROCEDURE Disconnect_Case_Task (
   rma_no_  IN NUMBER,
   case_id_ IN NUMBER,
   task_id_ IN NUMBER )
IS
   oldrec_     RETURN_MATERIAL_TAB%ROWTYPE;
   newrec_     RETURN_MATERIAL_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(rma_no_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CASE_ID', case_id_  , attr_);
   Client_SYS.Add_To_Attr('TASK_ID', task_id_  , attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Disconnect_Case_Task;


-- Check_Debit_Inv_Numbers
--   Public method which internally calls the Check_Debit_Inv_Numbers___ and
--   returns a number value depending on the connected debit invoice number
--   to each RMA line and charge line in a particular RMA.
@UncheckedAccess
FUNCTION Check_Debit_Inv_Numbers (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN Check_Debit_Inv_Numbers___(rma_no_);
END Check_Debit_Inv_Numbers;


-- Check_Line_Conn_Promo_Exist
--   This method is used from client to check at least one rma line connected
--   order line is linked to a sales promotion line.
@UncheckedAccess
FUNCTION Check_Line_Conn_Promo_Exist (
   rma_no_   IN  NUMBER ) RETURN NUMBER

IS
   temp_    NUMBER;

   CURSOR get_lines IS
      SELECT order_no, line_no, rel_no, line_item_no
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rma_no = rma_no_
      AND   order_no IS NOT NULL;

BEGIN
   temp_ := 0;
   FOR line_rec_ IN get_lines LOOP
      IF (Sales_Promotion_Util_API.Check_Promo_Exist_For_Ord_Line(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no)) THEN
         temp_ := 1;
         EXIT;
      END IF;
   END LOOP;
   RETURN temp_;
END Check_Line_Conn_Promo_Exist;


-- Set_Cancel_Reason
--   This method is used to update the cancel reason in RMA header.
PROCEDURE Set_Cancel_Reason (
   rma_no_          IN VARCHAR2,
   cancel_reason_   IN VARCHAR2 )
IS
   oldrec_       RETURN_MATERIAL_TAB%ROWTYPE;
   newrec_       RETURN_MATERIAL_TAB%ROWTYPE;
   objid_        RETURN_MATERIAL.objid%TYPE;
   objversion_   RETURN_MATERIAL.objversion%TYPE;
   attr_         VARCHAR2(2000);
   indrec_       Indicator_Rec;
BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, rma_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Set_Item_Value('CANCEL_REASON', cancel_reason_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Cancel_Reason;


-- Create_Supply_Site_Rma_Header
--   This method is to create receipt rma header from demand rma header.
PROCEDURE Create_Supply_Site_Rma_Header (
   receipt_rma_no_     OUT NUMBER,
   demand_rma_no_      IN  NUMBER,
   demand_rma_line_no_ IN  NUMBER )
IS
   rec_                   RETURN_MATERIAL_TAB%ROWTYPE;
   new_attr_              VARCHAR2(4000);   
   newrec_                RETURN_MATERIAL_TAB%ROWTYPE;
   objid_                 VARCHAR2(2000);
   objversion_            VARCHAR2(2000);
   site_customer_no_      CUST_ORD_CUSTOMER_TAB.customer_no%TYPE;
   indrec_                Indicator_Rec;   
BEGIN
   rec_ := Get_Object_By_Keys___(demand_rma_no_);

   IF (rec_.contract != rec_.return_to_contract) THEN
      site_customer_no_ := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(rec_.contract);
      IF (site_customer_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOINTCUST: Site should be connected to an internal customer if the return-to-site is different.');
      END IF;
   END IF;   
   new_attr_ := Build_Attr_Supp_Rma_Head___(rec_, demand_rma_no_, demand_rma_line_no_);
   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);

   receipt_rma_no_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('RMA_NO', new_attr_));
END Create_Supply_Site_Rma_Header;


-- Credit_Approved
--   This method returns 1, if any rma line is credit approved. This is used when
--   allowing to update coordinator in RMA.
@UncheckedAccess
FUNCTION Credit_Approved (
   rma_no_ IN NUMBER ) RETURN NUMBER
IS
   exist_  NUMBER;

   CURSOR approved_line_exist IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE rowstate NOT IN ('Denied', 'Cancelled')
      AND credit_approver_id IS NOT NULL
      AND rma_no = rma_no_;
BEGIN
   OPEN approved_line_exist;
   FETCH approved_line_exist INTO exist_;
   IF (approved_line_exist%FOUND) THEN
      exist_ := 1;
      CLOSE approved_line_exist;
   ELSE
      exist_ := 0;
      CLOSE approved_line_exist;
   END IF;
   RETURN exist_;
END Credit_Approved;

@UncheckedAccess
FUNCTION Is_Expctr_Connected(
   rma_no_           IN  VARCHAR2) RETURN VARCHAR2

IS
   connection_exist_ VARCHAR2(5) := 'FALSE';
BEGIN
   $IF Component_Expctr_SYS.INSTALLED $THEN
      IF (Customer_Order_Flow_API.Get_License_Enabled(rma_no_, 'INTERACT_RMA') = 'TRUE') THEN
         connection_exist_ := Exp_License_Connect_Util_API.Is_Expctr_Connected(rma_no_, NULL, NULL, NULL, 'RMA');
      END IF;
   $ELSE
      NULL;
   $END
   RETURN connection_exist_;
END Is_Expctr_Connected;

-- Automatic_Process_Rma
--   This method is to create rma and receive it to inventory automatically.
PROCEDURE Automatic_Process_Rma(
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   received_qty_          IN NUMBER,
   received_rma_tab_      IN received_rma_table,
   rental_transfer_db_    IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE)   
IS
   inv_count_               NUMBER;
   rma_no_                  NUMBER;
   rma_line_no_             NUMBER;
   rma_attr_                VARCHAR2(2000);
   order_no_list_           VARCHAR2(2000);
   info_                    VARCHAR2(2000);
   objid_                   VARCHAR2(2000);
   objversion_              VARCHAR2(2000);
   attr_                    VARCHAR2(2000); 
   receipt_no_              NUMBER;
   line_rec_                Customer_Order_Line_API.Public_Rec; 
   sales_part_rec_          Sales_Part_API.Public_Rec;
   
BEGIN      
   Inventory_Event_Manager_API.Start_Session;
   line_rec_        := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);   
   sales_part_rec_  := Sales_Part_API.Get(line_rec_.contract, line_rec_.catalog_no);

   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, order_no_list_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, order_no_list_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, order_no_list_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, order_no_list_);   

   Customer_Order_Flow_API.Create_Rma_Header_From_Co (rma_no_, line_rec_.customer_no, line_rec_.contract, order_no_list_);
   
   Client_SYS.Add_To_Attr('RMA_NO', rma_no_, rma_attr_);
   Client_SYS.Add_To_Attr('CONTRACT', line_rec_.contract, rma_attr_);
   Client_SYS.Add_To_Attr('QTY_TO_RETURN', received_qty_/sales_part_rec_.conv_factor*sales_part_rec_.inverted_conv_factor, rma_attr_);
   Client_SYS.Add_To_Attr('QTY_TO_RETURN_INV_UOM', received_qty_, rma_attr_);
   
   Customer_Order_Flow_API.Create_Rma_Line_From_Co_Line (inv_count_, rma_line_no_, order_no_, line_no_, rel_no_, line_item_no_, rma_attr_);
   
   Get_Id_Version_By_Keys___ (objid_, objversion_, rma_no_);
   Release__ (info_, objid_, objversion_, attr_, 'DO');
        
   IF (received_rma_tab_.COUNT > 0) THEN
      FOR index_ IN received_rma_tab_.FIRST .. received_rma_tab_.LAST LOOP      
         Return_Material_Line_API.Create_Cust_Receipt(receipt_no_,
                                                      'RETURN',
                                                      rma_no_,
                                                      rma_line_no_,
                                                      line_rec_.catalog_no,
                                                      line_rec_.contract,
                                                      received_rma_tab_(index_).configuration_id,
                                                      to_date(NULL),
                                                      received_rma_tab_(index_).location_no,
                                                      received_rma_tab_(index_).lot_batch_no,
                                                      received_rma_tab_(index_).serial_no,
                                                      received_rma_tab_(index_).eng_chg_level,
                                                      received_rma_tab_(index_).waiv_dev_rej_no,
                                                      received_rma_tab_(index_).handling_unit_id,
                                                      received_rma_tab_(index_).part_ownership,
                                                      received_rma_tab_(index_).owning_vendor_no,
                                                      received_rma_tab_(index_).received_qty,
                                                      received_rma_tab_(index_).received_qty,
                                                      to_number(NULL),
                                                      NULL,
                                                      received_rma_tab_(index_).condition_code,
                                                      'FALSE',
                                                      rental_transfer_db_);                                  
      END LOOP;
   END IF;
   Inventory_Event_Manager_API.Finish_Session;
END Automatic_Process_Rma;

PROCEDURE Get_Credit_Approve_Line_Status (
   has_credited_lines_to_approve_   OUT BOOLEAN,
   has_normal_lines_to_approve_ OUT BOOLEAN,  
   rma_no_ IN NUMBER)
IS
   CURSOR get_lines (rma_no_ NUMBER) IS
      SELECT rma_line_no, order_no, line_no, rel_no, line_item_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    credit_invoice_no IS NULL
      AND    credit_approver_id IS NULL
      AND    rowstate NOT IN ('Denied', 'Planned', 'Cancelled')
      AND    rental = Fnd_Boolean_API.DB_FALSE;
BEGIN
   has_credited_lines_to_approve_ := FALSE;
   has_normal_lines_to_approve_ := FALSE; 
   
   FOR line_rec_ IN get_lines(rma_no_) LOOP
      IF (line_rec_.order_no IS NOT NULL) THEN
         IF (Invoice_Customer_Order_API.Get_Credited_Amt_Per_Ord_Line(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no) != 0) THEN
            has_credited_lines_to_approve_ := TRUE;
         ELSE
            has_normal_lines_to_approve_ := TRUE;
         END IF;
      ELSE
         has_normal_lines_to_approve_ := TRUE;
      END IF;
      IF (has_credited_lines_to_approve_) AND (has_normal_lines_to_approve_) THEN
         EXIT;   
      END IF;
   END LOOP;   
END Get_Credit_Approve_Line_Status;

FUNCTION  Calculate_Totals (
   rma_no_   IN  VARCHAR2) RETURN Calculated_Totals_Arr PIPELINED
IS
   rec_                Calculated_Totals_Rec;
   return_material_rec_  Public_Rec;
   company_           VARCHAR2(20);
   rounding_          NUMBER;
   
   total_base_price_       NUMBER := 0;
   total_sale_price_       NUMBER := 0;
   total_tax_amount_       NUMBER := 0;  
   total_sale_price_gross_ NUMBER := 0; 
   
   total_base_charge_ NUMBER := 0;
   total_sale_charge_ NUMBER := 0;
   total_charge_tax_amount_  NUMBER := 0;
   total_sale_charge_gross_ NUMBER := 0;
   
   CURSOR get_lines IS
      SELECT rma_no, rma_line_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    rowstate NOT IN ('Denied', 'Cancelled');
   
   CURSOR get_charges IS
      SELECT rma_charge_no
      FROM   RETURN_MATERIAL_CHARGE_TAB
      WHERE  rma_no = rma_no_
      AND    rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   return_material_rec_ := Get(rma_no_);
   company_ := Site_API.Get_Company(return_material_rec_.contract);
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_,return_material_rec_.currency_code);
  
   FOR line_rec_ IN get_lines LOOP
      total_base_price_ := total_base_price_ + Return_Material_Line_API.Get_Line_Total_Base_Price(line_rec_.rma_no, line_rec_.rma_line_no);
      total_sale_price_ := total_sale_price_ + Return_Material_Line_API.Get_Line_Total_Price(line_rec_.rma_no, line_rec_.rma_line_no);
      total_tax_amount_ := total_tax_amount_ + Return_Material_Line_API.Get_Total_Tax_Amount_Curr(line_rec_.rma_no, line_rec_.rma_line_no);
      total_sale_price_gross_ := total_sale_price_gross_ + Return_Material_Line_API.Get_Line_Total_Price_Incl_Tax(line_rec_.rma_no, line_rec_.rma_line_no);
   END LOOP;
 
   FOR charge_rec_ IN get_charges LOOP
      total_base_charge_ := total_base_charge_ + Return_Material_Charge_API.Get_Total_Base_Charged_Amount(rma_no_, charge_rec_.rma_charge_no);
      total_sale_charge_ := total_sale_charge_ + Return_Material_Charge_API.Get_Total_Charged_Amount(rma_no_, charge_rec_.rma_charge_no);
      total_charge_tax_amount_ := total_charge_tax_amount_ + Return_Material_Charge_API.Get_Total_Tax_Amount_Curr(rma_no_, charge_rec_.rma_charge_no);
      total_sale_charge_gross_ := total_sale_charge_gross_ + Return_Material_Charge_API.Get_Total_Charged_Amt_Incl_Tax(rma_no_, charge_rec_.rma_charge_no);

   END LOOP;

   
   rec_.total_line_base         := NVL(total_base_price_, 0);
   rec_.total_charge_base       := NVL(total_base_charge_, 0);
   rec_.total_amount_base       := rec_.total_line_base + rec_.total_charge_base;   
   
   rec_.total_line_curr         := NVL(total_sale_price_, 0);
   rec_.total_charge_curr       := NVL(total_sale_charge_, 0);
   rec_.total_amount_curr       := rec_.total_line_curr + rec_.total_charge_curr;                                         
      
   rec_.total_line_tax_curr     := NVL(ROUND(total_tax_amount_, rounding_), 0);
   rec_.total_charge_tax_curr   := NVL(total_charge_tax_amount_, 0);
   rec_.toatal_tax_amount_curr  := rec_.total_line_tax_curr + rec_.total_charge_tax_curr;
   
   rec_.total_line_gross_curr   := NVL(total_sale_price_gross_, 0);
   rec_.total_charge_gross_curr := NVL(total_sale_charge_gross_, 0);
   rec_.total_gross_amount_curr := rec_.total_line_gross_curr + rec_.total_charge_gross_curr;
   
   rec_.charge_exist            := Return_Material_API.Exist_Charges__(rma_no_);
 
   PIPE ROW (rec_);                                                                                     
END Calculate_Totals;

-- Since the pieline function has been removed this method would no longer be used
FUNCTION Header_Information (
   rma_no_    IN NUMBER) RETURN header_information_arr PIPELINED
IS
   return_material_rec_        Public_Rec;
   rec_                        header_information_rec;
   cust_ord_addr_rec_          Customer_Order_Address_API.Cust_Ord_Addr_Rec;
   customer_info_address_rec_  Customer_Info_Address_API.Public_Rec;
   shipment_rec_               Shipment_API.Public_Rec;
   company_address_rec_        Company_address_API.Public_Rec;
   $IF Component_Purch_SYS.INSTALLED $THEN
      supplier_info_address_rec_ Supplier_Info_Address_API.Public_Rec;
   $END
   company_ VARCHAR2(20);
BEGIN
   return_material_rec_ := Get(rma_no_);
   rec_.return_to_company := Site_API.Get_Company(return_material_rec_.return_to_contract);
   rec_.external_tax_cal_method := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(Site_API.Get_Company(return_material_rec_.contract));
   rec_.delivery_country := Cust_Ord_Customer_Address_API.Get_Country_Code(return_material_rec_.return_from_customer_no, return_material_rec_.ship_addr_no);
   rec_.child_tax_update_possible := Child_Tax_Update_Possible__(rma_no_);
   rec_.expctr_connected := Is_Expctr_Connected(rma_no_);
   
   customer_info_address_rec_ := Customer_Info_Address_API.Get(return_material_rec_.return_from_customer_no,return_material_rec_.ship_addr_no);
   rec_.address_name := customer_info_address_rec_.name;
   IF (rec_.address_name IS NULL) THEN
      rec_.address_name := Cust_Ord_Customer_API.Get_Name(return_material_rec_.return_from_customer_no); 
   END IF;
   IF (return_material_rec_.order_no IS NOT NULL) THEN
      cust_ord_addr_rec_ := Customer_Order_Address_API.Get_Cust_Ord_Addr(return_material_rec_.order_no);
      rec_.address1  := cust_ord_addr_rec_.address1;
      rec_.address2  := cust_ord_addr_rec_.address2;
      rec_.address3  := cust_ord_addr_rec_.address3;
      rec_.address4  := cust_ord_addr_rec_.address4;
      rec_.address5  := cust_ord_addr_rec_.address5;
      rec_.address6  := cust_ord_addr_rec_.address6;
      rec_.zip_code  := cust_ord_addr_rec_.zip_code;  
      rec_.city      := cust_ord_addr_rec_.city;  
      rec_.state     := cust_ord_addr_rec_.state;        
      rec_.county    := cust_ord_addr_rec_.county;  
      rec_.country_code  := cust_ord_addr_rec_.country_code;        
   ELSIF (return_material_rec_.shipment_id IS NOT NULL) THEN
      shipment_rec_ := Shipment_API.Get(return_material_rec_.shipment_id);
      rec_.address1  := shipment_rec_.receiver_address1;
      rec_.address2  := shipment_rec_.receiver_address2;
      rec_.address3  := shipment_rec_.receiver_address3;
      rec_.address4  := shipment_rec_.receiver_address4;
      rec_.address5  := shipment_rec_.receiver_address5;
      rec_.address6  := shipment_rec_.receiver_address6;
      rec_.zip_code  := shipment_rec_.receiver_zip_code;  
      rec_.city      := shipment_rec_.receiver_city;  
      rec_.state     := shipment_rec_.receiver_state;        
      rec_.county    := shipment_rec_.receiver_county;  
      rec_.country_code  := shipment_rec_.receiver_country;              
   ELSE
      rec_.address1  := customer_info_address_rec_.address1;
      rec_.address2  := customer_info_address_rec_.address2;
      rec_.address3  := customer_info_address_rec_.address3;
      rec_.address4  := customer_info_address_rec_.address4;
      rec_.address5  := customer_info_address_rec_.address5;
      rec_.address6  := customer_info_address_rec_.address6;
      rec_.zip_code  := customer_info_address_rec_.zip_code;  
      rec_.city      := customer_info_address_rec_.city;  
      rec_.state     := customer_info_address_rec_.state;        
      rec_.county    := customer_info_address_rec_.county;  
      rec_.country_code  := customer_info_address_rec_.country;                    
   END IF;

   IF (return_material_rec_.return_to_contract IS NOT NULL) THEN 
      rec_.return_addr_name1 := Company_Address_Deliv_Info_API.Get_Address_Name(rec_.return_to_company, return_material_rec_.return_addr_no);
      company_address_rec_ := Company_Address_API.Get(rec_.return_to_company, return_material_rec_.return_addr_no);                                                                          
      rec_.ret_address1 := company_address_rec_.address1;
      rec_.ret_address2 := company_address_rec_.address2;
      rec_.ret_address3 := company_address_rec_.address3;
      rec_.ret_address4 := company_address_rec_.address4;
      rec_.ret_address5 := company_address_rec_.address5;
      rec_.ret_address6 := company_address_rec_.address6; 
      rec_.ret_addr_zip_code  := company_address_rec_.zip_code;                                                            
      rec_.ret_addr_city := company_address_rec_.city;
      rec_.ret_addr_state  := company_address_rec_.state;      
      rec_.ret_addr_county := company_address_rec_.county;
      rec_.ret_addr_country_code := company_address_rec_.country;                                                            
   ELSIF  (return_material_rec_.return_to_vendor_no IS NOT NULL) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         supplier_info_address_rec_ := Supplier_Info_Address_API.Get(return_material_rec_.return_to_vendor_no, return_material_rec_.return_addr_no);
         rec_.return_addr_name1 := supplier_info_address_rec_.name;
         rec_.ret_address1 := supplier_info_address_rec_.address1;
         rec_.ret_address2 := supplier_info_address_rec_.address2;
         rec_.ret_address3 := supplier_info_address_rec_.address3;
         rec_.ret_address4 := supplier_info_address_rec_.address4;
         rec_.ret_address5 := supplier_info_address_rec_.address5;
         rec_.ret_address6 := supplier_info_address_rec_.address6; 
         rec_.ret_addr_zip_code  := supplier_info_address_rec_.zip_code;         
         rec_.ret_addr_city := supplier_info_address_rec_.city;
         rec_.ret_addr_state  := supplier_info_address_rec_.state;         
         rec_.ret_addr_county := supplier_info_address_rec_.county;
         rec_.ret_addr_country_code := supplier_info_address_rec_.country;
      $ELSE
         NULL;
      $END
   ELSE
      company_ := Site_API.Get_Company(return_material_rec_.contract);
      rec_.return_addr_name1 := Company_Address_Deliv_Info_API.Get_Address_Name(company_, return_material_rec_.return_addr_no);
      company_address_rec_ := Company_Address_API.Get(company_, return_material_rec_.return_addr_no);                                                                          
      rec_.ret_address1 := company_address_rec_.address1;
      rec_.ret_address2 := company_address_rec_.address2;
      rec_.ret_address3 := company_address_rec_.address3;
      rec_.ret_address4 := company_address_rec_.address4;
      rec_.ret_address5 := company_address_rec_.address5;
      rec_.ret_address6 := company_address_rec_.address6; 
      rec_.ret_addr_zip_code  := company_address_rec_.zip_code;                                                            
      rec_.ret_addr_city := company_address_rec_.city;
      rec_.ret_addr_state  := company_address_rec_.state;      
      rec_.ret_addr_county := company_address_rec_.county;
      rec_.ret_addr_country_code := company_address_rec_.country;                                                                  
   END IF;
   PIPE ROW (rec_);
END Header_Information;

-------------------------------------------------------------------
-- Fetch_External_Tax
--    Fetches tax information from external tax system.
--------------------------------------------------------------------
PROCEDURE Fetch_External_Tax (
   rma_no_      IN VARCHAR2 )
IS
   i_                      NUMBER := 1;
   company_                VARCHAR2(20);
   line_source_key_arr_    Tax_Handling_Util_API.source_key_arr;
   
   CURSOR get_rma_lines IS
      SELECT rma_line_no
        FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rma_no_
        AND order_no IS NULL 
        AND credit_invoice_no IS NULL 
        AND debit_invoice_no IS NULL;
      
   CURSOR get_rma_charge_lines IS
      SELECT rma_charge_no
        FROM RETURN_MATERIAL_CHARGE_TAB
       WHERE rma_no = rma_no_
        AND order_no IS NULL 
        AND credit_invoice_no IS NULL;
      
BEGIN
   company_                  := Site_API.Get_Company(Get_Contract(rma_no_)); 
   line_source_key_arr_.DELETE;
   FOR rec_ IN get_rma_lines LOOP
       line_source_key_arr_(i_) := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                                                              rma_no_, 
                                                                              rec_.rma_line_no, 
                                                                              '*', 
                                                                              '*', 
                                                                              '*',                                                                  
                                                                              attr_ => NULL);
      i_ := i_ + 1;
     
   END LOOP;
   
   FOR rec_ IN get_rma_charge_lines LOOP
      line_source_key_arr_(i_) := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                                                              rma_no_, 
                                                                              rec_.rma_charge_no, 
                                                                              '*', 
                                                                              '*', 
                                                                              '*',                                                                  
                                                                              attr_ => NULL);
     i_ := i_ + 1;
   END LOOP;
   
   IF line_source_key_arr_.COUNT >= 1 THEN 
      Tax_Handling_Order_Util_API.Fetch_External_Tax_Info(line_source_key_arr_,
                                                          company_);
   END IF;                                                    
   
   Return_Material_History_API.New(rma_no_, Language_Sys.Translate_Constant(lu_name_,'EXTAXBUNDLECALL: External Taxes Updated'));
END Fetch_External_Tax;


-- Check whether the order connected RMA lines are exist for a given RMA
@UncheckedAccess
FUNCTION Any_Order_Connected_Lines(
   rma_no_ IN VARCHAR2) RETURN VARCHAR2
IS
   dummy_             NUMBER;
   rma_lines_exist_   VARCHAR2(5);
   CURSOR order_connected_lines IS
      SELECT 1
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no   = rma_no_
      AND    order_no IS NOT NULL
      AND rowstate NOT IN ('Denied', 'Cancelled', 'ReturnCompleted');     
   
BEGIN
	OPEN  order_connected_lines;
   FETCH order_connected_lines INTO dummy_;
   
   IF (order_connected_lines%FOUND) THEN
      rma_lines_exist_ := 'TRUE';
   ELSE
      rma_lines_exist_ := 'FALSE';
   END IF;
   
   CLOSE order_connected_lines;   
   RETURN rma_lines_exist_;
   
END Any_Order_Connected_Lines;

-- Fetch the Return Address Name
@UncheckedAccess
FUNCTION Get_Return_Addr_Name(
   return_to_contract_   IN VARCHAR2,
   return_to_company_    IN VARCHAR2,
   return_addr_no_       IN VARCHAR2,
   return_to_vendor_no_  IN VARCHAR2,
   company_              IN VARCHAR2) RETURN VARCHAR2
IS
   address_name_  VARCHAR2 (2000);
BEGIN
   IF (return_to_contract_ IS NOT NULL) THEN 
      address_name_ := Company_Address_Deliv_Info_API.Get_Address_Name(return_to_company_, return_addr_no_);
   ELSIF  (return_to_vendor_no_ IS NOT NULL) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         address_name_ := Supplier_Info_Address_API.Get_Name(return_to_vendor_no_, return_addr_no_);
      $ELSE
         NULL;
      $END
   ELSE
      address_name_ := Company_Address_Deliv_Info_API.Get_Address_Name(company_, return_addr_no_);
   END IF;      
   RETURN address_name_;
END Get_Return_Addr_Name;
