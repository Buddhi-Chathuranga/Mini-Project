-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderInvItem
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220131  MiKulk   SC21R2-7360, Modified the Modify_Invoice_Item___ to handle the invoice_qty = 0 scenario.
--  220126  KiSalk   Bug 161969(SC21R2-7035), Modified Create_Credit_Invoice_Items with new parameter exclude_service_items_ to filter out service order items and create credit invoice for rest of the items. 
--  220125  KiSalk   Bug 162116(PJZ-10252), Modified Do_Str_Event_Acc___ by adding parameter refresh_proj_revenue_ and check its value to handle error, so that the correct errors set in Project Connection Refresh Runs.
--  220125           Passed that parameter refresh_proj_revenue_ to Do_Str_Event_Acc___ from Create_Postings__, via Create_Discount_Postings___, Create_Free_Of_Chg_Postings___ and Create_Rebate_Postings___.
--  210111  NiDalk   Bug 162100(SCZ-17352), Modified Modify_Invoice_Item___ not to fetch external taxes for advance invoice. Also replaced hardcoded COADVDEB with value in COMPANY_DEF_INVOICE_TYPE_TAB.
--  220110  Hiralk   FI21R2-6563, Added prepayment_tax_document functionality.
--  211124  ThKrlk   Bug 161706(SC21R2-6179), Modified Create_Invoice_Item(), by adding new method call to get the max pos no.
--  211202  KiSalk   Bug 161716(SC21R2-6242), Modified Create_Postings__ to fetch the first tax code when multiple taxes exist.
--  211102  MaEelk   SC21R2-5668, Replaced control_type_key_rec_.oe_tax_code_ with control_type_key_rec_.tax_code_ in Create_Postings__
--  211014  cecobr   FI21R2-4615, Move Entity and associated clint/logic of BusinessTransactionCode from MPCCOM to DISCOM
--  210921  Hahalk   Bug 159177 (SC21R2-2535), Removed a condition added from 147782 in Create_Rebate_Postings___ to avoid the postings imbalance.
--  210817  Waudlk   Bug 158632 (FI21R2-3770), Modified Recalculate_Line_Amounts__ to fetch the correct tax_dom_amount when handling prepayment based invoice.
 -- 210805  KiSalk   Bug 160297(SCZ-15850), Added company_id_ parameter to Get_First_Order.
--  210810  MaEelk   SC21R2-2244, Modified Build_Item_Attr_String___ and assigned ORIGINAL_DISCOUNT, ORIGINAL_ADD_DISCOUNT and ORIGINAL_ORDER_DISCOUNT to N20, N21 and N22 respectively.
--  210720  Chgulk   FI21R2-3530, Allowed to Modify the Domestic tax amount in invoice line section only for self-billing invoices.
--  210804  KiSalk   SCZ-15756 (Bug 160230 and 159114), In Calc_Line_Amount_For_Prepay___, multiplied TAX_BASE_CURR_AMOUNT and TAX_BASE_PARALLEL_AMOUNT by -1 as added to tax_msg_.
--  210804           Modified Build_Item_Attr_String___ by adding parameter objid_ and comparing the attribute value with current table value if called from Aurena client
--  210804           to set flag recalc_tax_. This is because Aurena client sends unchanged attributes too when modifying and it is risky to change behaviour due to unknown impact.
--  210628  ChFolk   SCZ-15338(Bug 159858), Modified Fetch_Unknown_Head_Attributes to fetch document text from rma line when invoice is created from rma.
--  210618  MaEelk   SC21R2-1075, Added DELIV_TYPE_ID to line_attr_ in Create_Prepayment_Inv_Lines and ite_rec_ in Create_Prepayment_Inv_Line__.
--  210615  ApWilk   Bug 158977(SCZ-15150), Modified Create_Prepayment_Inv_Line__() and Create_Credit_Prepaym_Item___() to pass the correct tax amounts when creating the prepayment invoice line.
--  210506  NiDalk   Bug 158933(SCZ-14121), Modified Get_External_Tax_Info to add PREL_UPDATE_ALLOWED to attr.
--  210505  ErFelk   Bug 159060(SCZ-14626), Modified Create_Postings__() to skip the normal correction invoice logic for rebate invoice.
--  210505  Hahalk   Bug 159052(SCZ-14545), Modified Create_Credit_Prepaym_Item___() to create prepayment based credit invoice when amount is not fully consumed.
--  210402  KiSalk   Bug 158629(SCZ-14253), Added out paramenter recalc_tax_ to denote if the attribute value need tax recalculation upon change and used it in Modify_Invoice_Item___ as a check for tax resetting.
--  210330  ChFolk   Bug 158699(SCZ-14309), Modified Create_Credit_Invoice_Item___ not to make rma_no to null for credit invoice.
--  210305  ErFelk   Bug 156198(SCZ-12927), Modified Modify_Invoice_Item___() to auto update the connected unit chrage lines when invoice lines amount got changed. Added new method Modify_Charge_Item___().
--  210305           Modified Create_Postings__() by passing inv_net_curr_amount_ and invoiced_quantity_ to a method so that Base_Charged_Cost is calculated correctly. Modified
--  210305           Create_Invoice_Item() to correctly calculate the temp_sale_unit_price_ when charge_percent_ has a value.
--  210222  ApWilk   Bug 157765(SCZ-13560), Modified Public_Rec to increase the variable length of the catalog_no and modified Create_Postings__() to prevent assignment of catalog_no 
--  210222           when having a rebate credit invoice
--  210215  NiDalk   Bug 157456(SCZ-13280), Modified Calculate_Line_And_Tax_Amts___ and  Modify_Invoice_Item___ to fetch taxes correctly when external taxes are used and taxable changeds in sales part.
--  210201  MalLlk   SC2020R1-12227, Removed two obsoleted methods Get_Vat_Code().
--  210113  ApWilk   Bug 157271(SCZ-13206), Modified Is_Co_Charge_Connected() to retrieve the correct sales object type when registering the external tax and to post the credit invoice without any error
--  210113           when having a RMA which includes Avalara Tax.
--  201221  ErRalk   Bug 156317(SCZ-12591), Modified Create_Postings__() and Create_Rebate_Postings___() so that rebate transactions are created for Collective Correction Invoice type.
--  201202  MiKulk   SC2020R1-11177(Bug-155159), Modified Fetch_Unknown_Item_Attributes(). Added two attributes for customer order invoice, SOURCE_UNIT_MEAS and INVOICED_SOURCE_QTY.
--  201027  RasDlk   SCZ-11051, Added the missing annotations for Enumerate_States__ and Language_Refreshed to solve MissingAnnotation issue.
--  200911  MaEelk   GESPRING20-5400, added Get_Discounted_Price_Rounded, Get_Displayed_Discount__ and Get_Line_Discount_Amount___
--  200911           Modified Public_Rec, Build_Item_Attr_String___, Modify_Invoice_Item___, Create_Credit_Invoice_Item___, 
--  200911           Calc_Inv_Discount_Detail___, Create_Invoice_Item, Get_Tot_Discount_For_Ivc_Item and Get 
--  200911           to support Discounted Price Rounded Localization Parameter.. 
--  220716  NiDalk   SCXTEND-4526, Modified Modify_Invoice_Item___ to avoid external tax call when cust_tax_usage_type_ is not changed.
--  200715  KiSalk   Bug 154819, Added Finite_State_Encode__ and Enumerate_States__ to pass PLSQL model compliance test.
--  200712  DiJwlk   Bug 152810(SCZ-9709), Modify_Invoice_Item___(), gross_order_amount_ and total_tax_amount_ is calculated with the sales price not with base price.
--                   Modified validation when base_for_adv_invoice_ = 'NET AMOUNT' and 'GROSS AMOUNT'
--  200626  KiSalk   Bug 153956(SCZ-9900), Changed Get_Sale_Unit_Price and Get_Unit_Price_Incl_Tax a little; Commented them and Get_Unit_Price_Incl_Tax, two overloads of Get_Vat_Code, one Get_Net_Curr_Amount 
--  200626           as obsolete, because it's not possible to delete methods from a released version. Created Get_Item_Sale_Unit_Price to be used instead of Get_Sale_Unit_Price.
--  200624  ApWilk   Bug 153456(SCZ-9726), Modified Modify_Invoice_Item___() to prevent deleting invoice fee when the rounding level is TOTAL.
--  200604  fiallk   GEFALL20-2627, Modified method Build_Item_Attr_String___ by adding acquisition_origin, business_operation, statistical_code when creating the attr.
--                   GEFALL20-2627, Modified method Create_Invoice_Item, added param acquisition_origin, statistical_code.
--  200225  ErFelk   Bug 152250(SCZ-8648), Modified Modify_Invoice_Item___() to raise, error message CHARGEPERCENTONLY and info message UNITCHRGCHGINFO when changing the invoiced_quantity.
--  200205  ThKrLk   Bug 150623(SCZ-7909), Modified Create_Postings__() to retrieve charged cost from Customer_Order_Charge_API when it uses debit invoice's invoice date.
--  200127  ThKrLk   Bug 150623(SCZ-7909), Modified Create_Postings__() to get the correct invoice date to calculate the RMA charge cost.
--  200127  ThKrLk   Bug 151866(SCZ-8646), Added another filter to the cursor in Get_Item_Id().
--  200113  Hairlk   SCXTEND-1916, Added code to fetch address info from the shipment header for customer order line, charge line if its connected to a shipment. This is needed when creating a shipment invoice.
--  191219  ApWilk   Bug 151274 (SCZ-7922), Modified Create_Credit_Invoice_Item___ to allow recalculating tax amounts when creating a correction invoice through RMA.
--  191213  KiSalk   Bug 151413(SCZ-8127) In Modify__, stopped calling Modify_Invoice_Item___ if attr_ IS NULL, so that custom fields can be proceeded with editing.
--  191127  ErFelk   Bug 150751(SCZ-7641), Modified Create_Rebate_Postings___() so that correct control type value is been passed to create the postings for M204. 
--  191125  ErFelk   Bug 150796(SCZ-7687), Modified Create_Rebate_Postings___() to handle the rebate difference. 
--  191114  THKRLK   Bug 150623(SCZ-7519), Modified Create_Postings__ to get the correct invoice date to calculate the RMA charge cost.
--  191023  BudKLK   Bug 149865 (FIZ-3169), Modified the method Create_Invoice_Item() to pass the delivery_country.
--  191012  fiallk   GEFALL20-475, Modified Create_Invoice_Item to add acquisition_origin for invoice lines
--  191003  Hairlk   SCXTEND-876, Avalara integration, modified Cust_Order_Inv_Item_Uiv_All and Customer_Order_Inv_Item to include customer_tax_usage_type attribute.
--                   Modified Calculate_Line_And_Tax_Amts___, added param cust_tax_usage_type_ which will be used for fetching external tax calculations.
--                   Modified Modify_Invoice_Item___, added param cust_tax_usage_type_ which will be used to decide if a user is allowed to change the customer tax usage type depending on the invoice status.
--                   Modified Create_Invoice_Item, added param customer_tax_usage_type_
--  190820  ISLILK   Bug 149564 (PJZ-2515), Use declarations defined in PublicDeclarations.plsql instead of declarations in Project_Connection_Util_API to remove unnecessary conditional code for PROJ module.
--  190802  DiKulk   Bug 149112 (SCZ-5797), Modified Create_Credit_Invoice_Item___() to pass parameter invoice_rec_.series_id.
--  190611  ErFelk   Bug 147782(SCZ-4243), Modified Create_Postings__() and Create_Rebate_Postings___() to handle the rebate difference if an update was done in Periodic or final rebate invoices.
--  190226  KHVESE   SCUXXW4-764, Added methods Get_Amounts__, Add_Transaction_Tax_Info___ and modified method Modify_Invoice_Item___ to call to Reconsume_Prepaym_Inv_Lines__ when method has been called from Aurena.
--  190125  ErFelk   Bug 145554(SCZ-2348), Modified Recalculate_Line_Amounts__() so that final net_curr_amount_ will become negative for Rebate Invoice(COREBCRE).
--  190123  KiSalk   Bug 146450(SCZ-2643), Modified Get_Rent_Trans_Net_Dom_Amount and Get_Rent_Trans_Gross_Dom_Amnt(keeping reverse compatibility) adding order_no check condition to cursor to stop full table scan.
--  190122  DilMlk   Bug 143413(SCZ-746), Added new method Validate_Source_Pkg_Info. Modified methods Get_Tax_Info and Create_Credit_Invoice_Item___ to copy values from debit invoice to credit 
--  190122           invoice without recalculating tax amounts when user manually edit tax amounts in debit invoice tax lines.
--  180928  ErFelk   Bug 143837, Modified Create_Postings__() by changing a condition to check base_charge_cost_ is null instead of zero if coming from RMA.
--  180913  ChBnlk   Bug 143864, Modified Recalculate_Line_Amounts__() in order to check the proper value of free_of_charge_tax_basis when calculating net and tax amounts with free of charge.
--  180831  DiKulk   Bug 136076, Modified Modify_Invoice_Item___() to set line_exclusion_flag after changing price values.
--  180706  KHVESE   SCUXXW4-12390, Added methods Finite_State_Decode__, Get_Client_Values___, Get_Db_Values___, Finite_State_Events__, Language_Refreshed
--  180705  ChBnlk   Bug 142562, Modified Calc_Line_Amount_For_Prepay___() by replacing deb_item_id_ by cre_item_id_ when getting the headrec_.
--  180705           Modified Create_Postings__() in order to pass 0 instead of NULL for the value_ parameter to avoid posting errors when there is a prepayment currency difference. 
--  180522  AsZelk   Bug 141237, Used source_tax_item_base_pub view instead of source_tax_item_order.
--  180425  reanpl   Bug 141485, Free of Charge enhancement in customer invoice line
--  180306  KiSalk   STRSC-17457, In Create_Free_Of_Chg_Postings___, booking changed to 40 (related to M263) as it was changed in Mpccom.
--  180228  KiSalk   STRSC-8854, In Create_Postings__, booking for 'Gross Price Item' changed to 39 from 43 as it was changed in Mpccom.
--  180222  MaEelk   STRSC-16934, Added parameter use_ref_inv_rates_ Create_Credit_Invoice_Items and Create_Credit_Invoice_Item___.
--  180208  NaLrlk   STRSC-16350, Modified Create_Credit_Invoice_Item___() to allow neagtive invoice qty for rental neagtive durations.
--  180123  MaEelk   STRSC-15395, Removed the code setting charge_percent_basis NULL in Modify_Invoice_Item___
--  171215  MaEelk   STRSC-14742, Removed the validation for Invoice_API.Is_Rate_Correction_Invoice(company_, copy_to_source_key_rec_.source_ref1) in 
--  171215           Create_Credit_Invoice_Item___ and passed item_rec_.invoice_id to Tax_Handling_Order_Util_API.Transfer_Tax_lines and Customer_Invoice_Pub_Util_API.Create_Cor_Inv_Wht_Tax_Item.
--  171128  BudKlk   Bug 132164, Added methods Check_Corr_Reason_Exists(). 
--  171127  MAHPLK   STRFI-10886, Added new method Get_External_Tax_Info(), Added two our parameters to Get_Line_Address_Info(). 
--  171122  JaThlk   Bug 138787, Modified Modify_Invoice_Item___ to restrict the advance invoice value exceeding the customer order value.
--  171024  MalLlk   STRSC-12754, Removed the methods Get_Line_Total_Base_Amount().
--  170803  ChBnlk   Bug 137169, Modified Get_Rental_Transaction_Id() by adding conditional compilation to execute the cursor get_attr only when Rental component is installed.
--  170630  NipKlk   STRSC-2566, Added new parameter invoice_category_ to the method Create_Credit_Invoice_Items() and changed the code to execute debit and credit lines depending on the value of the parameter invoice_category_ 
--  170630           when there is a currency rate correction being executed and passed tax curr rate instead of curr rate for the tax currency rate in the method Fetch_Tax_Line_Param() .
--  170627  ErFelk   Bug 136518, Modified get_attr cursor in method Get_Invoiced_Qty() by adding prel_update_allowed to the condition to fetch the debit line.    
--  170615  KiSalk   Bug 136124, Modified Create_Postings__ to create M291/M292 postings for Gross Price Item lines too.
--  170531  RasDlk   Bug 129626, Reversed the correction.
--  170504  MeAblk   Bug 135583, Modified Get_Total_Cost() by removing the check on prel_update_allowed_ to capture the cost correctly for the debit lines of the correction/credit invoices.
--  170420  MeAblk   Bug 135405, Modified Create_Credit_Invoice_Items() in order to recalculate the respective commission lines when a credit invoice is created.
--  170310  ThImlk   STRMF-9785, Modified Create_Rebate_Postings___() to handle rebate postings when multiple currencies used.
--  170208  AmPalk   STRMF-6864, Modified Create_Rebate_Postings___ to do flexible postings for rebate created invoices.
--  170208           Added Add_Reb_Aggr_Line_Post___ to sub group and sum the rebate transactions for the flexible posting creation process.
--  170208           Moved implementation in Get_Ctrl_Type_Values to the method Get_Ctrl_Type_Value_Oeorder in OrderPostingCtrlUtil LU.
--  170202  JeeJlk   Bug 131867, Modified Modify_Invoice_Item___, Create_Credit_Prepaym_Item___, Recalculate_Line_Amounts__, Create_Prepayment_Inv_Line__
--  170202           and Create_Invoice_Item to save invoiced qty to N17 column and this original invoiced qty will be used to reduce from invoiced qty in 
--  170202           CO line when canceling preliminary invoices and introduced N18 to save comp_bearing_tax_amt_.
--  161214  ThEdlk   Bug 133020, Modified Fetch_Unknown_Item_Attributes() to stop fetching customer's part number and customer's part description for charge lines.
--  161028  ChJalk   Bug 131762, Modified the error message NEGATIVEQTYCORR to show the debit invoice number and the invoice line number.
--  160930  MalLlk   FINHR-2652, Added methods Get_Line_Total_Base_Amount and Get_Line_Address_Info.
--  160804  KiSalk   Bug 130745, Modified Create_Credit_Invoice_Items to allow process if connected CO line has demand code Component Repair Order.
--  160622  MeAblk   Bug 129835, Modified Get_Total_Cost() to avoid converting the cost into a negative value when creating any invoiced which is considered as a correction invoice.
--  160622  RasDlk   Bug 129626, Modified Create_Postings__() by moving a condition so that postings will be created when there's a change in parallel currency as well.
--  160608  MaIklk   LIM-7442, Fixed the usages of renaming Customer_Order_Deliv_Note to Delivery_Note.
--  160526  NWeelk   STRLOC-344, Modified Create_Free_Of_Chg_Postings___ to convert base_comp_bearing_tax_amt_ to order currency when there is a currency difference.
--  160520  NWeelk   STRLOC-358, Modified Create_Invoice_Item and Fetch_Tax_Line_Param by setting free_of_charge_tax_basis_.
--  160407  NiDalk   Bug 127211, Modified Create_Rebate_Postings___ to include costs to M204 if cost are not accounted when running periodic settlement.
--  160330  DipeLk   STRLOC-274, Added Create_Free_Of_Chg_Postings___ to handle free of charge postings when company bearing tax.
--  160330  NWeelk   STRLOC-242, Reversed the correction done to set comp_bearing_tax_amt_.  
--  160328  NWeelk   STRLOC-242, Modified Create_Invoice_Item to set comp_bearing_tax_amt_ for free of charge lines. 
--  160314  NWeelk   STRLOC-262, Modified Calculate_Line_Amounts___ by adding parameter free_of_charge_tax_basis_ to use when calculating amounts for free of charge lines.
--  160201  SBalLK   Bug 125958, Modified Get_Total_Cost() and Create_Postings__() methods to get the charge cost from base currency according to the currency rate related to the invoice date.
--  160128  SeJalk   Bug 126806, Modified Do_Str_Event_Acc___ to raise the error if exists, without generating revenue elements in order simulation flow.
--  160118  IsSalk   FINHR-657, Used FndBoolean in taxable attribute in Sales Charge Type.
--  151231  SeJalk   Bug 125698, Modified Create_Credit_Invoice_Item___ , Create_Credit_Invoice_Items, Get_Total_Net_Invoice_Amount to improve performance. 
--  151110  MaIklk   LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--- 151028  MeAblk   Bug 125402, Modified Get_Total_Cost() in order to correctly get the cost when delivering package component lines.
--  151021  IsSalk   FINHR-197, Used FndBoolean in taxable attribute in sales part.
--  150901  Umdolk   AFT-3107, Modified Modify_Invoice_Item___() method to check the db value of the invoice.
--  150610  KaGalk   Bug 120924, Modified Fetch_Unknown_Item_Attributes to seperately send the different discount amounts.
--  150526  IsSalk   KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  150309  CPriLK   ANPJ-22, Added Get_State() and relevant changers to get the state of the Customer Order Invoice Line line.
--  150216  KiSalk   Bug 121106, In Create_Rebate_Postings___, made the sum of M204 and M205 postings equals net_curr_amount of invoice to stop rounding error in postings.
--  150212  Chfose   PRSC-5887, Added div_factor in calculation of transactions in Refresh_Project_Connection
--  150120  KiSalk   Bug 120646, Added Is_Order_Revenue_Simulation___ and modified Do_Str_Event_Acc___, not to stop invoice creation when an posing error occurred.
--  140128  Ersruk   PRPJ-4330, Used plsql table instead of temp table in Refresh_Project_Connection. 
--  141218  RULiLk   PRSC-4694, Modified method to get configuration_id stored in RMA line.
--  141217  Nirylk   PRFI-3962, Modified Create_Postings__() to check parallel currency difference in prepayment invoice with the final posted invoice of a customer order.
--  141208  SlKapl   PRFI-3916, Modified Modify_Invoice_Item___ to avoid problem with difference between tax details and tax amount on CO invoice line 
--  141121  NiDalk   Bug 119475, Modified methods Calculate_Line_Amounts___ to round total_gross_ampunt_at the begining to consitent with discount postings.
--  141121           Also modified Create_Postings__ to round gross amount when calculating sale value to be consistent with customer order line calculations.
--  141120  RoJalk   PRSC-4338, Modified Create_Credit_Invoice_Item___ and included conditional compilation for RENTAL.
--  141104  Hawalk   Bug 117783 (merged via PRFI-3257), The resulting amounts arising out of currency rate changes between pre-payment based invoice   
--  141104           creation and final invoice creation, are posted to separate invoice postings 'IP29'/'IP30', but not to sales postings 'M28'/'M30'.
--  141104           Removed the call to Do_Str_Event_Acc___(), which created the currency diff 'M28'/'M30' prior to this correction, from inside Create_Postings__().
--  141029  KiSalk   Bug 119347, Modified Create_Credit_Invoice_Items to raise error if connected CO line has supply code Service Order.
--  141021  NaLrlk   Modified Create_Credit_Invoice_Item___() to allow create credit invoice for invoiced rentals.
--  140925  NaLrlk   Modified Create_Credit_Invoice_Item___() to correctly use the rental conditional compilation code block.
--  140912  Asawlk   PRSC-1950, Replaced the usages of Mpccom_Accounting_API.Control_Type_Key_Rec with local variables or parameters of same type.
--  140825  AyAmlk   Bug 118068, Added two parameters pos and header_rma_no to Get_Total_Cost() and modified Modify_Invoice_Statistics() and Get_Total_Cost() to pass the values 
--  140825           for the two parameters. Added the Check_Zero_Cost_And_Qty(). Modified Get_Total_Cost() in order to treat Correction Invoice lines and Collective Correction 
--  140825           Invoice lines which are not connected to RMA although the header has an RMA reference, as Price adjusted lines.
--  140729  HimRlk   Modified Complete_Check_Accounting___ to fetch user_group_ from App_context.
--  140729  Asawlk   PRSC-1949, Replaced the usages of Mpccom_Accounting_API.Codestring_Rec with local variables or parameters of same type.
--  140612  Jeguse   PRPJ-541, Modified Calculate_Prel_Revenue__ and added Refresh_Connection
--  140602  NaSalk   Modifed Create_Credit_Invoice_Item___ to pass currency rate and conv factor for rental transactions. 
--  140527  ChFolk   Modified Create_Invoice_Item to set the charge price including tax value for new_charge_percent_basis_ when use_price_incl_tax is TRUE.
--  140516  NaSalk   Modified Create_Credit_Invoice_Item___ to link rental transactions created for credit invoices. Modfied Remove to remove them.
--  140428  NWeelk   Bug 116523, Modified method Create_Credit_Invoice_Items by adding ORDER BY to the cursor get_invoice_item_ids in order to get the tax items inserted in the correct order.
--  140410  KiSalk   Bug 115978, In Do_Str_Event_Acc___, posting_rec_.project_activity_id set to null before posting_rec_ is used for creating postings for the charges and pre-payments to stop posting error in voucher creation.
--  140410  NaSalk   Modified Create_Credit_Invoice_Item___ to update qty invoiced in COL for credit invoices.
--  140324  RoJalk   Replaced the usage of Statutory_Fee_API.Get_Fee_Type with Statutory_Fee_API.Get_Fee_Type_Db.
--  140320  RuLiLk   Bug 111355, Modified method Create_Postings__, fetch tax percentage from charge line when postings for charges are created.
--  140317  NaSalk   Modifed Create_Postings__ and Create_Discount_Postings___ to use rental posting types when revenue simulation is used.
--  130830  HimRlk   Merged Bug 110133-PIV, Modified methods Calculate_Line_Amounts___ by changing calculation logic of line discount amount to be consistent with discount postings. 
--  130830           Parameter discount_ will take discount amount, not discount percentage. If discount_ is NULL, discount amount will be calculated using Customer Invoice Item Discount. 
--  130830           Added new parameter disc_without_tax_. disc_without_tax_ is used when calculating net_curr_amount.
--  130830           Modified methods Fetch_Unknown_Item_Attributes, Get_Tot_Discount_For_Ivc_Item, Modify_Invoice_Statistics by changing calculation logic of line discount amount to be consistent with discount postings. 
--  130830           Modified methods Recalculate_Line_Amounts__(), Modify_Invoice_Item___() by passing NULL as discount amount when calling Calculate_Line_Amounts___().
--  130830           Modified method Create_Invoice_Item(), when creating debit invoice, discount amount is calculated using customer order line discount. 
--  130830           When creating credit invoice, discount amount is calculated using related debit invoicee discount. Otherwise it is calculated in Calculate_Line_Amounts___(). 
--  140304  RuLiLk   Bug 110447, Modified method Calculate_Line_Amounts___, when price including tax is used, unrounded gross amount is used to calculate total discount amount and net current amount.
--  140304           Modified method Create_Postings__, when creating postings, Gross curr amount is calculated by applying tax percentage on Gross curr amount with tax for price including tax. 
--  140304           Modified method Create_Discount_Postings___(). Tax percentage should not be fetched twice.
--  140227  RuLiLk   Bug 109596, Modified method by passing customer order line tax percentage if invoice tax percentage is null when using price including tax.
--  140221  PeSulk   Modified Create_Discount_Postings___ to create postings for rental discounts.
--  140121  NaLrlk   Added method Get_Rent_Trans_Gross_Dom_Amnt().
--  140121  RoJalk   Modified Calculate_Prel_Revenue__ and replaced teh usage of Project_Cost_Element_API.Get_Element_Type with Get_Element_Type_Db.
--  131224  MalLlk   Added Remove method to delete CustInvoiceItemDiscount records for CO Invoice Item. Added Check_Remove method
--  131224           to check if CustDeliveryInvRef, CustPrepaymConsumption and OutstandingSales records exist for CO Invoice Item.
--  131211  RoJalk   Replaced the usage of Get_Addr_Flag with Get_Addr_Flag_Db.
--  120926  ShKolk   Added unit_price_incl_tax and use_price_incl_tax to price calculations.
--  130904  Vwloza   Updated N15 references to N16.
--  130614  MaKrlk   Added the column rental_transaction_id to CUSTOMER_ORDER_INV_ITEM and CUSTOMER_ORDER_INV_ITEM_UIV
--  130828  Asawlk   TIBE-2517, Removed calls to obsolete method Mpccom_Accounting_API.End_Booking.
--  130806  Shdilk   TIBE-1978, Added parameters to Customer_Invoice_Pub_Util_API.Modify_Invoice_Complete to remove g_invoice_head global variable.
--  130731  Shdilk   TIBE-1978, Modified Recalculate_Line_Amount and Modify_Invoice_Item___ to remove g_invoice_head global variable
--  130708  AwWelk   TIBE-981, Removed global variables inst_Jinsui_, inst_Project_, inst_ProjAccounting_ and introduced conditional compilation.
--  130926  NWeelk   Bug 111252, Added OUT parameter additional_disc_ to the method Get_Price_Info and set additional discount to pass when 
--  130926           updating statistics in method Modify_Invoice_Statistics.  
--  130923  JuMalk   Bug 109040, Modified view CUSTOMER_ORDER_INV_ITEM, removed SUBSTR from column catalog_no due to performance issues.
--  130827  NWeelk   Bug 111252, Modified method Build_Item_Attr_String___ by adding additional discount when creating the attr, Modified Modify_Invoice_Item___, Modify_Invoice_Statistics 
--  130827           and Create_Discount_Postings___ to get the additional discount from the invoice item, added function Get_Additional_Discount and removed Get_Add_Discount_For_Invoice. 
--  130730  RuLiLk   Bug 110133, Modified methods Fetch_Unknown_Item_Attributes, Get_Tot_Discount_For_Ivc_Item, Modify_Invoice_Statistics 
--  130730           by changing Calculation logic of line discount amount to be consistent with discount postings. 
--  130630  RuLiLk   Bug 110133, Modified method Calculate_Line_Amounts___() by changing  Calculation logic of line discount amount to  be consistent with discount postings. 
--  130630           Parameter discount_ will take discount amount, not discount percentage. If discount_ is NULL, discount amount will be calculated using Customer  Invoice Item Discount. 
--  130630           Modified methods Recalculate_Line_Amounts__(), Modify_Invoice_Item___() by passing NULL as discount amount when calling Calculate_Line_Amounts___().
--  130630           Modified method Create_Invoice_Item(), when creating debit invoice, discount amount is calculated using customer order line discount. 
--  130630           Otherwise it is calculated in Calculate_Line_Amounts___(). 
--  130508  MalLlk   Bug 107841, Modified Create_Invoice_Item() to add cursors get_cor_debit_pos and get_cor_credit_pos to genarate pos values for correction invoice lines.
--  121203  Darklk   Bug 99815, Added Get_Total_Cost.
--  130118  ErFelk   Bug 107451, Modified Create_Rebate_Postings___ so that it correctly compares amounts in accounting and invoice currencies.
--  121203  JaRalk   Bug 106792, Removed passing vat_dom_amount from Create_Credit_Prepaym_Item___ and Modify_Invoice_Item___ to INVOIC side. Removed  calculation of vat dom amount in 
--  121203  JaRalk               Calc_Line_Amount_For_Prepay___. Also corrected the parameters in the places where Calc_Line_Amount_For_Prepay___ is called. 
--  121219  GiSalk   Bug 106667, Modified Fetch_Unknown_Item_Attributes to fetch branch specific value for delnote_no.
--  120919  RuLiLk   Bug 105309, Modified method Do_Str_Event_Acc___. Added 'M71' and 'M72' posting types to handle postings of Charges in credit invoices.
--  120803  RoJalk   Bug 102751, Calculate_Prel_Revenue__ and restructured the code to fetch base_to_trans_currency_rate_ and removed the check for supply code and part type.
--  120619  GiSalk   Bug 103425, Modified the view CUSTOMER_ORDER_INV_JOIN by adding the column invoice_date.
--  120615  NaLrlk   Bug 103276, Modified function Remove__() to raise an error message when deleting self-billing debit invoice lines.
--  120426  MaMalk   Modified Complete_Check_Accounting___ to set a complete value for account_err_desc_.
--  120404  NWeelk   Bug 101623, Modified Do_Str_Event_Acc___ by increasing variable length of account_err_desc_ to 2000 to facilitate the account_err_desc_ 
--  120404           coming from Mpccom_Accounting_API.Get_Code_String.  
--  120313  MaMalk   Bug 99430, Modified the code to consider inverted_conv_factor where conv_factor has been considered.
--  120308  Darklk   Bug 101588, Modified method Fetch_Unknown_Item_Attributes by changing the total discount calculation according to the discount posting calculatoin.
--  120301  NWeelk   Bug 100633, Modified Is_Manual_Liablty_Taxcode by adding pre_deb_inv_type_ and pre_cre_inv_type_ to the conditions and modified
--  120301           the condition and the error message PREPAYDEBNOUPDATE to allow updating man_tax_liability_date, 
--  120301           modified Modify_Invoice_Item___ by adding a condition to stop setting unnecessary columns for Prepayment based debit invoices.
--  120130  NaLrlk   Replaced the method call Part_Catalog_API.Get_Active_Gtin_No with Part_Gtin_API.Get_Default_Gtin_No.
--  120112  ChJalk   Removed objid, objversion and refbase from view comments of CUSTOMER_ORDER_INV_ITEM_UIV.
--  111114  ChJalk   Added view CUSTOMER_ORDER_INV_ITEM_UIV.
--  110926  ChJalk   Replaced Part_Catalog_API.Get_Gtin_No with Part_Catalog_API.Get_Active_Gtin_No.
--  110922  JeLise   Changed the calculation of booking_cost_ for M205 in Create_Rebate_Postings___, to avoid posting errors due to rounding.
--  110830  NWeelk   Bug 93145, Modified methods Create_Postings__ and Create_Rebate_Postings___ to create postings correctly for correction invoices.  
--  110829  SWiclk   Bug 91889, Modified the cursor get_inv_lines in Modify_Invoice_Statistics to replace the item_id_ with item_id in Where clause.
--  110817  KiSalk   Bug 98178, Calculation of tax_dom_amount and tax_curr_amount done from un-rounded values in Create_Credit_Invoice_Item___.
--  110815  NaLrlk   Bug 94578, Modified Modify_Invoice_Item___ to set item value ALLOCATION_ID appropriately.
--  110808  NaLrlk   Bug 98049, Modified Create_Prepayment_Inv_Line__ to get rid of error, divisor is equal to zero.
--  110531  MaMalk   Modified Modify_Invoice_Item___  to fetch the tax free tax code when the delivery type is changed for normal and collective invoices.
--  110526  ShKolk   Added General_SYS for Calculate_Revenue().
--  110523  NaLrlk   Modified the method Calc_Line_Amount_For_Prepay___ to rounding the vat_dom_amount_ based in company currency.
--  110513  MiKulk   Modified the method Recalculate_Line_Amounts__ by modifying the condition to excute the prepayment calcualtion correctly.
--  110512  AmPalk   Bug 95417, Made item Description to be varchar2(2000). 
--  110512  NaLrlk   Modified the method Modify_Invoice_Item___ to correct the mispelling in attr value.
--  110510  JeLise   Removed calls to Company_Invoice_Info_API getting invoice types, using comp_inv_rec_ instead in Create_Postings__.
--  110420  MaMalk   Modified Get_Item_Id to consider only the order lines in invoice items.
--  110315  Darklk   Bug 96033, Modified the procedure Complete_Check_Accounting___ to add a DUMMY value to the variable codestr_rec_.text.
--  110223  Saallk   Added new methods Calculate_Revenue() and Calculate_Prel_Revenue__().
--  110131  Nekolk   EANE-3744  added where clause to View CUSTOMER_ORDER_INV_JOIN.
--  101231  PAWELK   EAPM-8563, Modified Remove__() by changing the party_type to upper case in attribute string.
--  101230  MiKulk   Replaced the calls to Customer_Info_Vat_API with new method calls
--  101019  ShKolk   Called function Part_Catalog_API.Get_Gtin_No instead of Sales_Part_API.Get_Gtin_No.
--  100928  THTHLK   HIGHPK-2220, MOdified PROCEDURE Calculate_Prel_Revenue__.
--  100908  MUSHLK   EAPM-4074, Added columns sales_part_rebate_group, assortment_id, assortment_node_id, charge_percent and charge_percent_basis to VIEWJOIN.
--  100709  THTHLK   HIGHPK-1241, Modified PROCEDURE Calculate_Prel_Revenue__ to report transaction currency.
--  100520  KRPELK   Merge Rose Method Documentation.
--  100430  NuVelk   Merged Twin Peaks.
--  100310  AmPalk   Bug 87750, Added CUSTOMER_ORDER_INV_JOIN. This will be used for tbwOverviewCustomerInvoiceItem.
--  100310           On that form, when querying for an invoice no, a performance gain is expected.
--  091109  Nirslk   Modified Calculate_Prel_Revenue__ to handle revenue elements and cost elements separately.
--  091110  RoJalk   Modified Do_Str_Event_Acc___ to return after calling Order_Proj_Revenue_Manager_API.Generate_Revenue_Element.
--  091103  RoJalk   Modified method call Order_Proj_Revenue_Manager_API.Generate_Revenue_Element in Do_Str_Event_Acc___ and passed item_id_.
--  091028  KaEllk   Removed order ref parameters from Calculate_Prel_Revenue__ and modified to consider Invoice state. Overloaded 
--                   Calculate_Prel_Revenue__. Added parameter revenue_simulation_ to Do_Str_Event_Acc___, Create_Discount_Postings___ and Create_Postings__.
--  091007  RoJalk   Removed the method call Order_proj_Revenue_Manager_API.Clear_Temporary_Table from Calculate_Prel_Revenue__.
--  091002  KaEllk   Modified condition in Modify_Invoice_Item___.
--  090930  RoJalk   Changed the calling place of Order_Proj_Revenue_Manager_API.Generate_Revenue_Element inside Do_Str_Event_Acc___. 
--  090928  RoJalk   Removed the parameter qty_to_simulate_ from Create_Postings__.
--  090924  Ersruk   Modified Do_Str_Event_Acc___ to remove porject preposting for charges with order header.  
--  090922  KaEllk   Added Remove_Project_Connection__ and Calculate_Prel_Revenue__. Modified Remove__, Modify_Invoice_Item___, Create_Credit_Invoice_Item___.
--  090921  RoJalk   Modified Do_Str_Event_Acc___ and called Order_Proj_Revenue_Manager_API.Generate_Revenue_Element
--  090921           to support project revenue calculation. Added parameter qty_to_simulate_to the method Create_Postings__.
--  091228  KiSalk   Removed obsolete attribute party, methods Get_Price_Invoiced_Qty and Get_Price_Per_Unit and parameter party_ from Fetch_Unknown_Item_Attributes. 
--  090930  MaMalk   Modified Create_Credit_Prepaym_Item___, Create_Credit_Prepaym_Items___, Modify_Invoice_Item___, Do_Str_Event_Acc___, Create_Invoice_Item, Create_Credit_Invoice_Items,
--  090930           Calc_Line_Amount_For_Prepay___ and Calculate_Line_Amounts___ to remove unused code.
--  ------------------------- 14.0.0 ----------------------------------------------
--  100311  ShKolk   Modified Create_Postings__() to consider Shipment charges.
--  091009  SaJjlk   Bug 86190, Modified method Get_Add_Discount_For_Invoice and removed code for setting additional_discount_ to zero for RMA connected order lines.
--  091009           Removed variable origin_is_rma_connected_ from method Get_Add_Discount_For_Invoice. Modified method Create_Discount_Postings___
--  091009           to check whether additional discount percentage is stated on the invoice line before creating posting for it.
--  090806  MaMalk   Bug 84330, Modified Create_Postings__ to retrieve the vat type fee_code to create postings when the invoice line fee code is null in a vat environment.
--  090713  MaMalk   Bug 83680, Modified methods Modify_Invoice_Item___ and Recalculate_Line_Amounts__ and added method Modify_Invoice_Statistics
--  090713           to update invoice statistics correctly.
--  091005  KiSalk   Added CO connected Unit charge Qty change info message, UNITCHRGCHGINFO in Modify_Invoice_Item___.
--  090616  ChJalk   Bug 81706, Modified Create_Rebate_Postings___ to consider invoice net_curr_amounts if there when creating rebate postings.
--  090512  ChJalk   Bug 81706, Modified Modify_Invoice_Item___ to consider rebate credit invoice type when setting the quantity.
--  090525  ChJalk   Bug 81683, Modified the method Modify_Invoice_Item___ to calculate the value of invoiced_qty based on the Invoice Type.
--  090515  ChJalk   Bug 81683, Modified the method Recalculate_Line_Amounts__ to declare new_item_rec_ after the CURSOR get_item.
--  090514  ChJalk   Bug 81683, Modified the method Recalculate_Line_Amounts__ to update base amounts in the statistics when updating the invoiced date and 
--  090514           modified Modify_Invoice_Item___ to update statistics record correctly based on the value of price_adjustment.  
--  090504  ChJalk   Bug 81683, Modified the method Remove__ to remove related invoice statistics when removing an invoice line
--  090504           and modified Recalculate_Line_Amounts__ and Modify_Invoice_Item___ to update the statistics record when updating fields in invoice lines.
--  090415  SaJjlk   Bug 81673, Modified method Remove__ to update the return material line information when deleting invoice lines connected to RMA.
--  090220  MaMalk   Bug 80722, Modified the length given in view comments for description in Customer_Order_Inv_Item.
--  090206  MaMalk   Bug 74793, Modified method Fetch_Unknown_Item_Attributes to add LINE_DOC_TEXT.
--  090206  MaRalk   Bug 75617, Modified method Create_Invoice_Item in order to add Debit Invoice Referance to invoice lines for charges.  
--  090128  MaRalk   Bug 76921, Added method Is_Co_Charge_Line_Invoiced.
--  081013  MaMalk   Bug 77555, Modified Fetch_Unknown_Item_Attributes to correct the value passed for discount_amount.
--  080811  MaRalk   Bug 75830, Added new function Get_Charge_Reference.
--  080808  MaMalk   Bug 74089, Modified Fetch_Unknown_Item_Attributes to pass the delivery_note_ref in the INVOIC message.
--  080805  MaMalk   Bug 75689, Modified Create_Postings__ to stop passing a tax code when creating postings for charge cost.
--  080804  ThAylk   Bug 68944, Modified method Modify_Invoice_Item___ to allow changes when jinsui status 'Transferred' in the customer invoice 
--  080804           and modified condition for raising error messages for Jinsui invoices.
--  080702  ChJalk   Bug 74652, Modified the method Modify_Invoice_Item___ to modify the invoice when changed vat_code, net_curr_amount or vat_curr_amount.
--  090420  KiSalk   Added charge_percent and charge_percent_basis in method Fetch_Unknown_Item_Attributes.
--  090417  KiSalk   Replaced sale_unit_price usages with NVL(sale_unit_price, charge_percent * charge_percent_basis / 100).
--  090406  KiSalk   Added charge_percent and charge_percent_basis to CUSTOMER_ORDER_INV_ITEM as attributes and to Create_Invoice_Item as parameters.
--  090406           Added N13 to sttribute string in Build_Item_Attr_String___.
--  081024  JeLise   Added nvl when fetching the value for rebate_cr_inv_type_ in Create_Postings__. This has been
--  081024           done to make sure that invoices will get Posted even if rebate_cr_inv_type_ has not been added
--  081024           on the company. 
--  081014  JeLise   Added method Calc_Rebate_Booking_In_Curr___ and calls to it in Create_Rebate_Postings___.
--  081010  JeLise   Added calculation of cost in invoice currency in Create_Rebate_Postings___.
--  081010  JeLise   Removed the multiplication with invoiced_qty_ when getting the booking_cost_
--  081010           in Create_Rebate_Postings___.
--  081003  JeLise   Added Get_ methods for sales_part_rebate_group, assortment_id, assortment_node_id.
--  081001  JeLise   Added assortment_id and assortment_node_id to Get method. Also added
--  081001           item_rec_.sales_part_rebate_group, item_rec_.assortment_id, item_rec_.assortment_node_id
--  081001           in call to Create_Invoice_Item in Create_Credit_Invoice_Item___.
--  080822  JeLise   Added sales_part_rebate_group_, assortment_id_ and assortment_node_id_ as in
--  080822           parameters to Create_Invoice_Item and removed Get_Rebate_Info___.
--  080820  JeLise   Added EXIT WHEN in search for active_agreement_ in Get_Rebate_Info___.
--  080818  JeLise   Added check on valid_line_ in Get_Rebate_Info___.
--  080818           Also modified cursor get_final_settlement in Get_Rebate_Info___ to use the view.
--  080723  MaHplk   Modified get_final_settlement cursor in Get_Rebate_Info___ method to use table.
--  080702  JeLise   Merged APP75 SP2.
--  ----------------------- APP75 SP2 merge - End ---------------------------------
--  080516  MaMalk   Bug 73903, Modified Fetch_Unknown_Item_Attributes to fetch the correct invoice line total discount.
--  080303  NaLrlk   Bug 71873, Modified the method Create_Discount_Postings___ to correctly calculating the discounts.
--  080229  NaLrlk   Bug 71873, Modified the method Create_Discount_Postings___ to correct the discount amount for additional and group discounts when booking.
--  ----------------------- APP75 SP2 Merge - Start -------------------------------
--  080625  JeLise   Added convertion of booking_cost for credit invoices in Create_Rebate_Postings___.
--  080625           Added loop to find parents active_agreement_ in Get_Rebate_Info___.
--  080624  JeLise   Added more invoice types in check in both Create_Rebate_Postings___ and Create_Postings__.
--  080623  JeLise   Changed rma_no_ from varchar2 to number in Get_Rebate_Info___.
--  080617  JeLise   Added rma_no_ to Get_Rebate_Info___.
--  080604  JeLise   Added M205 for final_settlements in Create_Rebate_Postings___. And added new method Get_Rebate_Info___.
--  080603  JeLise   Added cursor to get the assortment_node_id for periodic lines in Create_Invoice_Item.
--  080602  JeLise   Added cursors get_final_settlement and get_assortment_node in Create_Invoice_Item.
--  080527  JeLise   Changed from calling Get_Parent_Node_For_Part to calling Get_Parent_Node in Create_Invoice_Item.
--  080521  KiSalk   Added classification_standard, classification_part_no and classification_unit_meas in method Fetch_Unknown_Item_Attributes.
--  080519  JeLise   Updated code to check if assortment or not used in Create_Invoice_Item.
--  080515  MaJalk   Changed sales_part_ean_no to gtin_no at method Fetch_Unknown_Item_Attributes.
--  080508  ShVese   Added sales_part_rebate_group to Get method.Changed logic for posting M204.
--  080506  ShVese   Added parameter line_item_no_ and corrected the logic in Create_Rebate_Postings.
--                   In Create_Invoice_Item, fetched sales_part_rebate_group from Rebate_Periodic_Agg_Line_API.
--  080506  MaHplk   Modified rebate_group_deal_exist cursor in Create_Invoice_Item mehod to use table.
--  080502  AmPalk   Renamed rebate_settlement_ to aggregation_no_.
--  080430  ShVese   Added parameters invoice_type_ and rebate_settlement_ to Create_Rebate_Postings.
--                   Handled aggregation of periodic settlement postings in Create_Rebate_Postings.
--  080429  JeLise   Changed check on active_agreement_ in Create_Invoice_Item.
--  080425  JeLise   Added check on if active_agreement_ = 'FALSE' in Create_Invoice_Item.
--  080422  RiLase   Added company_ as in parameter in Create_Invoice_Item.
--  080411  JeLise   Changed where statement in cursor get_rebate_transactions and fetch of invoice_no_ in Create_Rebate_Postings___.
--  080328  MaHplk   Modified get_rebate_transactions cursor in Create_Rebate_Postings___ mothod to use table instead of views.
--  080312  JeLise   Changed view in cursor rebate_group_deal_exist in Create_Invoice_Item.
--  080311  RiLase   APP75 SP1 merged.
--  ------------------------- APP75 SP1 merge - End ----------------------------------------------
--  080206  SaJjlk   Bug 71023, Modified method Get_Tot_Discount_For_Ivc_Item to exclude invoice types from the where clause in cursor.
--  080203  LaBolk   Bug 70820, Modified Recalculate_Line_Amounts__ to call the correct recalculation method for pre-payment invoices.
--  080201  MaMalk   Bug 69778, Modified Create_Postings__ to handle pre posting for prepayment lines.
--  080112  LaBolk   Bug 68627, Modified method Create_Prepayment_Inv_Line__ to pass values for n3(price_conv), n5(discount),
--  080112           n6(order_discount) and n12(additional_discount) when creating prepayment inv lines.
--  071224  MaRalk   Bug 64486, Modified the function Create_Postings__ to consider currency rate type of the CO when calculate price in currency.
--  071217  MaMalk   Bug 68248, Modified Create_Postings__ to post additional postings when the currency rate of the final and the prepayment invoice differs.
--  071211  RoJalk   Bug 69803, Added allocation_id to CUSTOMER_ORDER_INV_ITEM and modified Create_Invoice_Item to handle allocation_id,
--  071126  PrPrlk   Bug 68771, Made changes to the method Fetch_Unknown_Item_Attributes to fetch the delivery note no's and EAN no.
--  071022  MaMalk   Bug 68043, Modified Create_Postings__ to create postings correctly when negative charge cost exists.
--  071017  SaJjlk   Bug 67211, Rearranged order of calculation of gross_curr_amount, sale_ur and price_base in the cursors in methods
--  071017           Calculate_Line_Amounts___, Create_Discount_Postings___, Create_Postings__ and Get_Tot_Discount_For_Ivc_Item.
--  071015  RaKalk   Bug 67954, Changed fetch of customer_part_no_ from Sales_Part_Cross_Reference_API to Customer_Order_Line_API
--  071015           and added check on customer_part_no_ and customer part desc in Fetch_Unknown_Item_Attributes.
--  ------------------------- APP75 SP1 merge - Start ----------------------------------------------
--  080307  RiLase   Removed co_line_entered_ and used TRUNC(SYSDATE) in Get_Active_Agreement_Call in Create_Invoice_Item.
--  080227  RiLase   Added Create_Rebate_Postings and call to that function in Create_Postings.
--  080226  RiLase   Added sales_part_rebate_group logic to Create_Invoice_Item.
--  ------------------------- Nice Price ----------------------------------------------
--  070912  NuVelk   Bug 66972, Added new function Get_Tot_Discount_For_Ivc_Item.
--  070829  MaJalk   Changed the length of the variable delivery_address_ at procedure Fetch_Unknown_Item_Attributes.
--  070822  RaKalk   Removed unwanted code from Fetch_Unknown_Item_Attributes function
--  070815  RaKalk   Bug 63323, Modified the method Fetch_Unknown_Item_Attributes to retrieve some additional attributes.
--  070619  WaJalk   Bug 64724, In Create_Postings__ method, assigned the value of the company to the variable Control_Type_Key_Rec.company_.
--  070607  MaJalk   Modified Recalculate_Line_Amounts__ to calculate amounts for prepayment.
--  070530  ChBalk   Bug 64640, Removed General_SYS.Init_Method from function Has_Invoice_Tax_Lines.
--  070506  AmPalk   Modified Create_Discount_Postings___ to multiply discount_amount_ by -1 for correction invoice credit type lines.
--  070302  WaJalk   Bug 61985, Modified view CUSTOMER_ORDER_INV_ITEM, to increase length of column customer_po_no from 15 to 50 in view comments.
--  070302  MaMalk   Bug 63189, Modified the condition that raises the error when discount exceeds 100, by removing the condition added by Bug 62020.
--  070227  NuVelk   Mapped the C14 and C15 columns of CUST_INVOICE_PUB_UTIL_ITEM to represent Prepay_Invoice_No and Prepay_Invoice_Series_Id,
--  070227           in VIEW CUSTOMER_ORDER_INV_ITEM and modified the PROCEDURE Create_Prepayment_Inv_Line__ to insert values for c14 and c15.
--  070227  ChBalk   Modified Is_Manual_Liablty_Taxcode, where it uses client value instead of db_values.
--  070226  ChBalk   Only Correction credit lines must have the prel_update_allowed 'FALSE'.
--  070130  NaWilk   Bug 62020, Modified Modify_Invoice_Item___ to change the condition that raises the error when discount exceeds 100.
--  070130           Modified the error msg to be meaningful.
--  061212  Cpeilk   Reduced the length of constant PREPAYDEBNOUPDATE in Modify_Invoice_Item___.
--  061130  ChBalk   Made gross_curr_amount public, modified code to credit invoice creation possible.
--  061128  RoJalk   Modifications to the Create_Postings__.
--  061122  ChBalk   Prepayment Credit Invoice creation and modification changes.
--                   Added new methods Create_Credit_Prepaym_Item___, Create_Credit_Prepaym_Items___ and Calc_Line_Amount_For_Prepay___.
--  061121  Cpeilk   DIPL606A, Added method Is_Prepaym_Lines_Exist.
--  061115  ChBalk   Bug 60377, Modified Modify_Invoice_Item___ and Create_Postings__ to remove checking hard-coded values for advance credit invoice type.
--  061113  Cpeilk   DIPL606A, Modified NET_AMOUNT to NET_CURR_AMOUNT in methods Create_Prepayment_Inv_Lines and Create_Prepayment_Inv_Line__.
--  061110  ChJalk   Modified variable naming of invoive_no_ in Create_Credit_Invoice_Item___.
--  061110  Cpeilk   DIPL606A, Modified methods Create_Prepayment_Inv_Lines and Create_Prepayment_Inv_Line__.
--  061110  ChJalk   Modified variable naming of invoive_no_ in Create_Credit_Invoice_Item___.
--  061108  Cpeilk   DIPL606A, Added new methods Create_Prepayment_Inv_Lines and Create_Prepayment_Inv_Line__.
--  061108           Removed hard coded correction invoice types.
--  061024  MaJalk   Added function Get_Man_Tax_Liab_Date.
--  061023  NaLrlk   B139829,Modified the method Is_Manual_Liablty_Taxcode included Collective tax codes for IF condition.
--  061020  ChJalk   Modified Do_Str_Event_Acc___.
--  061018  NaLrlk   Modified the method Modify_Liab_Dt_Corrinv_Crel___ .
--  061011  NaLrlk   Added the new Implementation method Modify_Liab_Dt_Corrinv_Crel___ and modified the method Modify_Invoice_Item___.
--  061005  NaLrlk   Added new Function Is_Manual_Liablty_Taxcode and Has_Manual_Tax_Liablty_Lines.
--  061002  MaJalk   Added man_tax_liability_date to view CUSTOMER_ORDER_INV_ITEM
--  061002           and MAN_TAX_LIABILITY_DATE to method Build_Item_Attr_String___.
--  060718  MiKulk   Modified the method Do_Str_Event_Acc___ to calculate the correct accounting value for the charge costs.
--  060706  ChJalk   Removed series_id and invoice_no from the public Get method due to SP1 merge.
--  060706           Also modified Create_Credit_Invoice_Item___ to get the invoice no using the invoice id to pass as a parameter in call
--  060706           Return_Material_Line_API.Get_Inv_Connected_Rma_Line_No.
--  060619  ChJalk   Series_reference was directly taken from Return_Material_Line in Create_Invoice_Item.
--  060615  PrPrlk   Bug 58784, Removed the unused method Fetch_Invoice_Info.
--  060612  MiKulk   Modified the Create_Credit_Invoie_Item__ NOT to set the rma details for the credit types lines in Correction invoices.
--  060612  MaMalk   Modified Remove__ to add an error message when we call Remove__ with action 'DO'.
--  060609  ChJalk   Modified Create_Credit_Invoice_Item___ make tax_amounts zero in correction invoices when the debit invoice qty is zero.
--  060602  MiKulk   Changed the name of the method from Modify_Invoice_Item__ to Recalculate_Line_Amounts__.
--  060602  NaLrlk   Enlarge Part Desc- Changed variable definitions.
--  060602  ChJalk   Modified Create_Credit_Invoice_Item___ to correct the tax calculation for the correction invoices created from RMA.
--  060601  JaBalk   Added Get_Prel_Update_Allowed method and multiply the value_ * -1
--  060601           only for prel_update_allowed_ = TRUE lines in Do_Str_Event_Acc___ method.
--  060601  ChJalk   Modifie the method Create_Postings__ to create postings for credit charges in correction invoices.
--  060531  KaDilk   Modified method Remove__.Restrict deleting of correction invoice lines.
--  060531  MaMalk   Modified Modify_Invoice_Item___ to change the error message given when updating a prel_update_allowed false line.
--  060530  PrKolk   Bug 58259, Added invoice type 'CUSTCOLCRE' in order to create postings, when printing a credit invoice.
--  060529  MaJalk   Bug 58060, At method Create_Invoice_Item, removed code that sets net_curr_amount_ and vat_curr_amount_ for adv payment.
--  060526  JaBalk   Added error message NEGATIVEQTYCORR in Create_Credit_Invoice_Item___.
--  060525  MiKulk   Modified the method Create_Credit_Invoice_Item___ to set the correct value for the DEBIT line.
--  060525  SaRalk   Modified procedure Fetch_Invoice_Info.
--  060524  PrPrlk   Bug 54753, Modified the view CUSTOMER_ORDER_INV_ITEM and made changes to the method Fetch_Invoice_Info.
--  060523  MiKulk   Added a private method as Modify_Invoice_Item__ which will be calling that Impl method.
--  060523           Also update the Create_Postings__ to set the correct value to INVOICE-C type postings for correction invs.
--  060518  MaJalk   Bug 58060, Added price_conv_factor_ to net amount calculation at method Create_Invoice_Item.
--  060517  MarSlk   Bug 56441, Modified Create_Postings__ and added code to clear the Control_Type_Key fields
--  060516  JaBalk   Modified Create_Credit_Invoice_Item___ to avoid charge lines.
--  060509  JaBalk   Modififed Create_Credit_Invoice_Item___ to set the negative quantity only for correction invoice.
--  060504  JaBalk   Modified Create_Credit_Invoice_Item___ to set the RMA line details for DEBIT and CREDIT lines.
--  060503  prKolk   Bug 55807, Modified the method Create_Invoice_Item to get the series_id directly from RMA Line.
--  060503  JaBalk   Modified Modify_Invoice_Item___ method to raise an error message UPDATENOTALLOWED.
--  060428  JaBalk   Called the Return_Material_Line_API.Modify_Cr_Invoice_Fields from Create_Credit_Invoice_Item___ method
--  060428           to set the credit detail to rma_line for correction invoice.
--  060426  JaBalk   Set the event code for CUSTORDCOR, CUSTCOLCOR in the method Create_Postings__.
--  060420  MiKulk   Modified the Public_Rec, Removed the method Create_Credit_Invoice_Item
--  060420           and split the logic in that method into two methods Create_Credit_Invoice_Items
--  060420           and Create_Credit_Invoice_Item. Added more attributes to the Get method.
--  060420           Modified the parameters in calls to Customer_Order_Inv_Head_API.Get_Invoice_Type.
--  060420           Added the prel_update_allowed to the customer_order_inv_item view.
--  060420  RoJalk   Enlarge Customer - Changed variable definitions.
--  ------------------------- 13.4.0 ----------------------------------------------
--  060327  SuJalk   Modified the error message to be more specific to the invoice.
--  060316  SuJalk   Added some checks to see whether Jinsui is installed and the invoice is jinsui is enabled before checking for the jinsui amount.
--  060316  SuJalk   Modified the error message to include the maximum jinsui amount when modifying an invoice line.
--  060309  SuJalk   Modified the procedure Modify_Invoice_Item___ to give an error message if the jinsui amount is less than the gross amount.
--  060119  PrKolk   Bug 55606, Modified cusrsor get_item_data in procedure Modify_Invoice_Item___ to fetch additional_discount. Replace argument value for add_discount_
--  060119           with NVL function in Calculate_Line_Amounts___ inside the procedure Modify_Invoice_Item___, in order to correct the discount calculation.
--  051227  PrKolk   Bug 55211, Modified, fetching value for 'add_discount_' from 'Customer_Order_Line_API' to Client side attribute string in 'Modify_Invoice_Item___'.
--  051209  UsRalk   Included invoice type SELFBILLCRE in credit invoice check.
--  051010  MaJalk   Bug 53799, Modified Create_Credit_Invoice_Item in order to fetch the additional discount from the debit invoice item.
--  051006  IsAnlk   Modified Create_Invoice_Item to avoid accessing Customer_Order_Inv_Head view.
--  050928  IsAnlk   Added customer_no_pay as parameter to customer_Order_Pricing_API.Get_Sales_Price_In_Currency call.
--  050922  NaLrlk   Removed unused variables.
--  050906  IsAnlk   Modified Get_Add_Discount_For_Invoice to ignore discount for SB invoice.
--  050902  VeMolk   Bug 52977, Modified the method Do_Str_Event_Acc___ to update error flag when error occurs.
--  050830  KaDilk   Bug 52783, Increased the length of the variable user_group_ in procedure Complete_Check_Accounting___.
--  050829  ThGulk   Bug 53026, Modified cursor get_Invoice_head_data in Create_Invoice_Item
--  050822  PrPrlk   Bug 51438, Added a new function Connected_To_Single_Occ_Addr in order to check for single occurence address in customer orders.
--  050706  RaSilk   Added pay_reference to VIEW CUSTOMER_ORDER_INV_ITEM.
--  050622  ThGulk   Bug 50512, Added series_referencem, number_reference to CUSTOMER_ORDER_INV_ITEM view, Modified Create_Invoice_Item.
--  050614  AnLaSe   Added Get_Price_Conv_Factor.
--  050525  AnLaSe   Added Get_Order_Discount.
--  050512  PrPrlk   Bug 51166, Made changes and added a new parameter item_id, to the method Has_Invoice_Tax_Lines.
--  050510  ChJalk   Bug 51059, Moved the Function Get_Total_Discount added in Bug 48259 into Customer_Order_Inv_Head_API.
--  050506  JOHESE   Added tax code value to Mpccom_Accounting_API.Control_Type_Key_Rec.oe_tax_code_ in Create_Postings__
--  050505  MaMalk   Bug 50637, Added method Get_Condition_Code in order to fetch the correct condition code for the customer invoice line.
--  050413  JoEd     Added Get_Net_Dom_Amount.
--  050204  AsJalk   FITH351, Modified method Build_Item_Attr_String___.
--  050125  MaGuse   Bug 48259, Modified method Modify_Invoice_Item___, added setting of commission recalculation flag.
--  050120           Added method Get_Total_Discount.
--  050119  ToBeSe   Bug 49039, Modified calculation of net_curr_amount_ in Calculate_Line_Amounts___.
--  041210  VeMolk   Bug 48495, Modified the method Create_Discount_Postings___ in order to avoid postings related to additional discounts for co charges.
--  040913  VeMolk   Bug 46463, Removed the method Fetch_Invoice_Info Which was added by the bug 41559.
--  040913           Added the method Is_Valid_Co_Line.
--  040830  KeFelk   B115186, Addded event code settings for Adv Invoice in Create_Postings__.
--  040524  JeLise   Bug 42479, Added delivery_date and discount_amount in Fetch_Unknown_Item_Attributes.
--  040511  UdGnlk   Bug 41757, Modified Create_Credit_Invoice_Head, Create_History_When_Printed___, Get_Price_Invoiced_Qty
--  040511           and Modify_Invoice_Item___ in order to handle new  collective invoice type CUSTCOLCRE and CUSTORDDEB.
--  040316  IsAnlk   B113369 , Made changes to enable edit of Advance Credit Invoices in Modify_Invoice_Item___.
--  040305  HeWelk   Removed the function Get_Advance_Total.
--  040225  AjShlk   Performed code review
--  040212  AjShlk   Changed Create_Invoice_Item() to create advance credit invoice item
--  040130  AjShlk   Changed Create_Invoice_Item() to create advance debit invoice item
--  040128  GaJalk   Added the function Get_Advance_Total.
--  ----------------------------TouchDown Start------------------------------
--  040220  IsWilk   Removed the SUBSTRB from the view for Unicode Changes.
--  040203  WaJalk   Bug 41559, Added method Fetch_Invoice_Info.
--  ********************* VSHSB Merge End*****************************
--  020523  GEKA  Modified Create_Postings__ to handle self billing invoice types.
--  ********************* VSHSB Merge Start*****************************
--  040113  LaBolk   Removed the call to public cursor get_str_event_acc in Do_Str_Event_Acc___ and used a local cursor instead.
--  031029  NuFilk   LCS 39163, Added column c13 for delivery customer in view CUSTOMER_ORDER_INV_ITEM and
--  031029           modified the PROCEDURE Create_Invoice_Item to insert values for c13 for newly created
--  031020  SaNalk   Added Additional discount to view CUSTOMER_ORDER_INV_ITEM.Modified procedure Create_Invoice_Item for this change.
--  031017  JaJalk   Modified the method Modify_Invoice_Item___ to get the line additional discount.
--  031008  PrJalk   Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  030917  GaJalk   Merged Bug 37955, Removed corrections for Bug# 34582 and modified code to fetch Part_No and Part_Description from Sales Part Cross Reference.
--  030916  BhRalk   Merged Bug 38236, Added call to Customer_Invoice_Pub_Util_API.Modify_Invoice_Complete('&PKG') in method Modify_Invoice_Item___.
--  030916  JaBalk   Bug 37779, Changed Get_Total_Gross_Invoice_Amount to Get_Total_Net_Invoice_Amount and restructured the method.
--  030730  GaJalk   Performed SP4 Merge.
--  030715  ChFolk   Modified method Create_Credit_Invoice_Item to get parent_fee_code when creating invoice tax item.
--  030708  ChFolk   Reversed the changes that have been done for Advance Payment.
--  030516  JaBalk   Bug 36352, Added Get_Order_Line_Invoice_Date.
--  030515  CaRase   Bug 31060, Set Substrb for substrb(c5,1,25) catalog_no in view CUSTOMER_ORDER_INV_ITEM.
--  030512  ThJalk   Bug 34582, Added dynamic sql to fetch PURCHASE_PART and PURCHASE_PART_DESCRIPTION in method Fetch_Unknown_Item_Attributes.
--  030511  KaDilk   Bug 35402, Added Get_Total_Gross_Invoice_Amount to get the gross amount.
--  030415  CaRase   Bug 31060, Remove Substrb for c1,c2,c4,c5,c6,c7,c8,c9,c10,c11,c12 in view CUSTOMER_ORDER_INV_ITEM.
--  030402  UdGnlk   Code Review.
--  030324  UdGnlk   Modified Calculate_Line_Amounts___ to calculate only from tax item avoiding the invoice line and
--                   Create_Credit_Invoice_Item avoiding company_pays_vat condition.
--  030319  UdGnlk   Modified Create_Invoice_Item procedure since duplicate records are writing to the invoice line.
--  030310  UdGnlk   Added a function Has_Invoice_Tax_Lines to check, multiple tax lines available.
--  030227  SuAmlk   Code Review.
--  030120  SaNalk   Modified the additional discount calculation in PROCEDURE Create_Discount_Postings___.
--  030119  AjShlk   Performed code review.
--  030113  SaNalk   Round off the add_disc_amt_ in PROCEDURE Calculate_Line_Amounts___.
--  030108  NaWalk   Bug 33833, Passed the codes including quantity to the codestr_rec.
--  030102  SaNalk   Performed code review.
--  021230  UsRalk   Merged with SP3 Changes.
--  021223  ThJalk   Bug 34349, Removed call to Customer_Invoice_Pub_Util_API.Modify_Invoice_Complete('&PKG') in Modify_Invoice_Item___.
--  021218  SaNalk   Modified the function Get_Add_Discount_For_Invoice for Charges.
--  021217  DaZa     Bug 34843, removed some code in Create_Discount_Postings___.
--  021216  SaNalk   Added the function Get_Add_Discount_For_Invoice.Added a check for RMA in additional discount calculation in procedure
--                   Create_Discount_Postings___.Added an error message for total order discount in procedure Modify_Invoice_Item___.
--  021213  SaNalk   Commented a check for event code 'INVOICE-C', in procedure Create_Discount_Postings___.Modified the cursor get_invoice_item_data.
--  021211  SaNalk   Added additional discount in PROCEDURE Create_Credit_Invoice_Item.Modified PROCEDURE Create_Discount_Postings___
--                   for postings of additional discount.
--  021202  SaNalk   Added parameter add_discount_ in proc: Create_Invoice_Item and Calculate_Line_Amounts___.
--  021128  JeLise   Bug 34532, Moved view CUSTOMER_ORDER_INV_ITEM_JOIN to InvoiceCustomerOrder.
--  021015  DaZa     Bug 34044 added Credit Invoice handling on the CUSTOMER_ORDER_INV_ITEM_JOIN
--                   thru an extra join to CUSTOMER_ORDER_INV_HEAD and extra decodes on invoiced_qty
--                   and base_sale_unit_price. Added invoice_type to this view also.
--  020904  JoAnSe   Bug fix 31296 Rewrote Calculate_Line_Amounts___ from scratch and
--  020904           changed all the calls made to the method.
--  020904           Added Get_Discount
--  020904           Corrected calculations of discount amount in Create_Discount_Postings___
--  020904           Added new conditions for discount recalculation in Modify_Invoice_Item___.
--  020703  JeLise   Bug fix 31292, Added one IN parameters in Calculate_Line_Amounts___, and added check on rma_no_.
--  020701  JeLise   Bug fix 31292, Added two IN parameters in Create_Invoice_Item and Calculate_Line_Amounts___,
--  020701           also made changes in discount calculations in Calculate_Line_Amounts___.
--  020523  JeLise   Bug fix 29109, Added four IN parameters in Calculate_Line_Amounts___, also added
--  020523           cursor get_order_line_discounts. Added the new parameters in calls to Calculate_Line_Amounts___
--  020523           in Create_Invoice_Item and Modify_Invoice_Item___.
--  020508  JeLise   Bug fix 28989, Changed the calculation with discount_amount_ in Calculate_Line_Amounts___.
--  020328  JeLise   Bug 28523, Added check on if discount_ > 100 in Modify_Invoice_Item___.
--  020318  ROALUS   Call 79823, CUSTOMER_ORDER_INV_ITEM series_id,objstate_head,taxable_db added.
--  020315  JeLise   Bug fix 26163, Made more changes in Calculate_Line_Amounts___.
--  020313  KiSalk   Bug fix 27058 , Modified earlier bug fix in Modify_Invoice_Item___ not to refer 'CUSTOMER_ORDER_INV_HEAD' to avoid possible error on fresh installation.
--  020227  ROALUS   Bug 27212, Create_Credit_Invoice_Item() method changed to use temp_item_id_
--  020226  JeLise   Bug fix 26163, Changed calculation of net_curr_amount in Calculate_Line_Amounts___.
--  011221  KiSalk   Bug fix 27058 , Added an error message in Modify_Invoice_Item___
--                    to avoid modifying lines when header is in 'Preliminary' state.
--  011128  JeLise   Bug fix 26217, Added another union in CUSTOMER_ORDER_INV_ITEM_JOIN view.
--  011019  OsAllk   Bug fix 18710,Modified the procedure Create_Invoice_Item to fetch price_uom when there is no order connection.
--  011018  RoAnse   Bug fix 25608, changed IF discount_rec_.discount > 0 to IF discount_rec_.discount != 0 in
--                   PROCEDURE Create_Discount_Postings___.
--  011017  DaZa     Bug Fix 24920, changes in CUSTOMER_ORDER_INV_ITEM_JOIN so we fetch customer_no for identity,
--                   also added an extra join to CUSTOMER_ORDER in the second part of the UNION in CUSTOMER_ORDER_INV_ITEM_JOIN.
--  011015  MaGu     Bug Fix 24887. Removed corrections for bug fix 19897 in methods Create_Invoice_Item
--                   and Modify_Invoice_item___, so that price conversion factor is used also for
--                   component parts.
--  011009  JeLise   Bug fix 24480, Added union in CUSTOMER_ORDER_INV_ITEM_JOIN view, also added
--                   decode on base_sale_unit_price.
--  011008  DaZa     Bug Fix 24920, changes in the CUSTOMER_ORDER_INV_ITEM_JOIN view, added base_sale_unit_price,
--                   included company_finance to the join and the base currency code taken from that view,
--                   added nvl check in where statement for cip.identity so we now include lines with different payer.
--  010919  JoAn     Bug Fix 24185 Added Get_Price_Info
--  010714  CaRa     Bug fix 21492. Added IF statement, modified the calculation and inserted
--                   rounding in calculation of discount_amount_ in Create_Discount_Postings___.
--  010427  MaGu     Bug fix 21250. Added value '####' to code part A if NULL, in method
--                   Do_Str_Event_Acc___.
--  010423  JeLise   Bug fix 21239, Added view CUSTOMER_ORDER_INV_ITEM_JOIN.
--  010421  IsWilk   Bug Fix 19897, Removed the corrections of bug id 19897 in the PROCEDURE Calculate_Line_Amounts___ and
--                   Modified the PROCEDURE's Create_Invoice_Item and Modify_Invoice_Item___.
--  010406  IsWilk   Bug Fix 19897, Modified the PROCEDURE Calculate_Line_Amounts___.
--  010321  RoAnse   Bug fix 20770, Procedure Create_Invoice_Item, added 'CO-' when creating reference_.
--  010306  IsAn     Bug fix 18710 , Added coding to get Price_Um from customer_order_line_tab in procedure Create_Invoice_Item.
--  010219  LeIsse   Bug fix 18966,  Removed rounding from calculation of
--                   discount_amount_ in Create_Discount_Postings___.
--  001218  JoAn     CID 57240 Corrected postings for negative discounts in Create_Discount_Postings___
--                   Always use booking 5 and 6 (15 and 16 removed).
--  001108  JakH     Added configuration_id to view and to use field C12.
--  001102  JoEd     Bug fix 17950. Added fetch of vat_code in Modify_Invoice_Item___.
--  001101  JoEd     Changed use of Cust_Invoice_Item_Discount in Create_Discount_Postings___.
--  000913  FBen     Added UNDEFINE.
--  --------------------------- 12.1 ----------------------------------------
--  000613  JoAn     CID 35173 Corrected discount postings created for credit invoice
--                   in Create_Discount_Postings___
--  000605  PaLj     Added Error message when trying to save orderdiscount without an
--                   orderconnection in Modify_Invoice_Item___.
--  000206  MaGu     CID 40518. Added price_conv_factor_ to calculation of discount_amount_ in
--                   Create_Discount_Postings___.
--  000417  JoAn     Added new parameters to call to Pre_Accounting_API.Do_Pre_Accounting in
--                   Do_Str_Event_Acc___
--  000317  JoAn     CID 37042 Corrected Create_Discount_Postings___
--  000310  JoEd     Changed to correct invoiced qty and sale unit price in
--                   Calculate_Line_Amounts___. Use the modified values (new values)
--                   instead of the already saved values.
--  000309  JoAn     Corrected retrieval of part_no for invoice line originated from RMA
--                   in Create_Postings__
--  000307  JoEd     Changed calculation of sales tax amount in Calculate_Line_Amounts___.
--  000307  JoAn     CID 35173 Corrected discount postings for credit invoice.
--  000303  JoAn     Changed the order of parameters in the call to Accounting_Codestr_API.Complete_Codestring
--  000303  JoAn     CID 33815 Corrected calculation of discount postings for order discount.
--  000302  JoAn     CID 33032 Changed Create_Postings to handle cost for charges on RMA.
--                   CID 34158 Added new cusrsor for tax lines in Create_Postings__.
--                   Preaccounting retrieved for charge lines.
--  000229  PaLj     Avoid to create tax items for the VAT case in Create_Credit_Invoice_Item.
--  000229  PaLj     CID 32887 Multiplied amount by -1 in Create_Credit_Invoice_Item when creating tax_items.
--  000229  JoAn     Cid 33030 Control_Type_Key_Rec.conttract assigned a value when
--                   invoice item is a charge.
--  000228  JoEd     Changed Calculate_Line_Amounts___ to work as in the client IVCCHG.APT.
--  000228  PaLj     CID 33040. Moved creation of VAT taxlines from several functions in ordivc
--                   to Create_Invoice_Item.
--  000228  PaLj     CID 33029 Changed Procedure Remove__. 'CUSTOMER' instead of remrec_.party_type
--  000225  JoEd     Changed fetch of currency code in Modify_Invoice_Item___.
--  000218  JoAn     Changed calls to Customer_Invoice_Info_Pub_Util (now all procedures)
--  000218  JoEd     Changed amount titles with VAT to Tax.
--  000216  JoAn     Set party to NULL in the view. The column should be removed,
--                   but is still used in a number of client forms.
--                   Created new method Calculate_Line_Amounts___ used when creating
--                   or modifying an invoice item.
--                   Calls to Invoice made using Customer_Invoice_Pub_Util_API.
--  000215  JoAn     Added Get_Vat_Code with keys as parameters.
--                   Added Exist and Check_Exist___ methods.
--                   Assigned invoice_id and item_id to ControlTypeKey rec in Create_Postings.
--  000210  JoEd     Added call to Create_Invoice_Tax_Item in Create_Credit_Invoice_Item.
--  000209  JoAn     Added logic for creating discount postings in Create_Discount_Postings___
--  000201  JakH     Added booking logic for orderless credits in Create_Postings
--  000131  JoAn     The view in this LU is now based on CUST_INVOICE_PUB_UTIL_ITEM
--                   Party retrieved from Customer_Info_API for now, but should be removed.
--                   Removed party and party_type from Get_XXX method cursors.
--  000126  JakH     comments on view for RMA-keys.
--  000125  JakH     when fee-code is NULL the VAT_CURR_AMOUNT is set to 0 instead of NULL
--  000119  JoAn     catalog_desc passed in item_rec_.c6 in Create_Invoice_Item
--                   Added RMA keys to Create_Invoice_Item. The keys are also stored
--                   on the invoice item.
--                   Removed Fetch_Postings (replaced by Create_Postings__)
--  000118  DaZa     Fix in Create_Invoice_Item so Price U/M gets value from
--                   Sales U/M when the item is a charge.
--  000112  JoAn     Added creator to record passed to invoice in Create_Invoice_Item.
--                   Changed calls to Customer_Invoice_Pub_Util_API (methods instead of functions).
--  000112  JoEd     Removed parameter extra_discount from Create_Invoice_Item.
--  000103  JoAn     New method Create_Postings__ replaces Fetch_Postings.
--                   Postings passed to Invoice using new record interface.
--  991217  JoAn     Added Create_Discount_Postings___
--  991210  JoEd     Changed back to original code in Create_Invoice_Item.
--  9911xx  JoEd     Added modify of discount records when changing price on an item.
--                   Changed column comments for party and party_type.
--                   Added copy of discount lines in Create_Credit_Invoice_Item.
--  ----------------------------- 12.0 ------------------------------------
--  991111  JoEd     Changed datatype length on company view comment.
--  991028  JoEd     Bug fix 10934, Changed so that currency_code_ is fetched from
--                   the Customer Order instead of the base currency in Create_Invoice_Item.
--  991020  JakH     Bug fix 11167: In procedure Create_Invoice_Item, altered reference
--                   string when creating invoice items to contain a sequence number instead
--                   of date/time. Modified Function Get_Vat_Code accordingly.
--  991011  DaZa     Changed in Fetch_Postings so charge cost i calculated in sales currency.
--  991007  JoEd     Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  991007  JoEd     Call Id 21210: Corrected double-byte problems.
--  990930  DaZa     Added charge_group_ to Create_Invoice_Item and the view.
--  990925  DaZa     Added bookings for charges in Fetch_Postings.
--  990917  DaZa     Added charge_seq_no to view and method Create_Invoice_Item. Changed
--                   so pos no longer is the same as line_no, since charges may not have
--                   a line_no. Changed Get_Vat_Code so it doesn't use reference_key, since
--                   it doesn't help much to use it, also added a new Get_Vat_Code for charges.
--  990826  JoAn     Removed check for zero value invoice lines in Create_Invoice_Item.
--  ----------------------------- 11.1 ------------------------------------
--  990616  JoAn     CID 18236. Added vat_code to Do_Str_Event_Acc___, and added
--                   OPTIONAL_CODE to the attribute string created in the same method.
--  990610  PaLj     CID 18726. Added Identity in VIEW. Added identity and party_type to remattr in Remove_
--  990609  PaLj     CID 18726. Added Check for 'CHECK' in Remove__ method.
--  990521  JoAn     Bug Id 10569 Added rounding on NET_CURR_AMOUNT and VAT_CURR_AMOUNT
--                   in Build_Item_Attr_String___, added new parameter currency_code_.
--  990420  JakH     Y.Removed function calls in cursors.
--  990415  RaKu     Removed obsolete functions Get_Instance___ and Get_Record___.
--                   Minor cleanup of LU.
--  990412  JoEd     Y.Call id 14004: Added column c10 as contract to view and
--                   use that on invoice line.
--  990331  RaKu     Removed underscore from concatination of reference
--                   in Get_Vat_Code and Create_Invoice_Item.
--  990330  JakH     CID 14600. Added use of stored conv-factor in Get_Price_Per_Unit.
--  990329  RaKu     CID 13989. Changes in Get_Vat_Code.
--  990301  RaKu     Added functions Get_Price_Invoiced_Qty and Get_Price_Per_Unit.
--  990217  PaLj     Bug fix 3452 = Call Id 4183 Added line (catalog_no) in Fetch_Postings
--  990215  PaLj     Bug fix 7410, Open up possibility to have negative discount.
--  990208  Jakh     CID 8035, Corrected Build_Item_Attr_String___ to map the new dummy columns.
--                   added invoice_no in view. Changed call for INVOICE_NO in Remove__ to
--                   use the added view INVOICE_NO instead of function. Changed the view
--                   CUSTOMER_ORDER_INV_ITEM to use new invoice columns instead of ITEM_DATA
--                   column. Also changed the building of the string to use new columns.
--  990128  JoAn     Changed order of parameters in Fetch_Unknown_Item_Attributes.
--                   removed obsolete columns net_amount and vat_amount.
--  990128  JoAn     Added PROJECT_ACTIVITY_ID to the attribute string returned
--                   by Do_Str_Event_Acc___.
--  990126  JoAn     Added Fetch_Unknown_Item_Attributes.
--  990118  PaLj     changed sysdate to Site_API.Get_Site_Date(contract)
--  990104  JoEd     Added procedure Fetch_Order_Keys.
--  981208  JoEd     Changed comments for some numeric columns (e.g. amounts).
--  980527  JOHW     Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  980421  JoAn     Corrected cursor in Fetch_Postings (fee_rate)
--  980420  DaZa     SID 4188, added net_dom_amount and vat_dom_amount to view.
--  980420  JoAn     SID 4063 Wrong posting types if vat_code != '1'.
--                   Corrected in Fetch_Postings, using vat_rate instead of vat_code
--                   to determine the bookings.
--  980417  JoAn     SID 3918 Corrected rounding in Create_invoice_Item so that
--                   the rounding is made the same way as in Fetch_Postings
--  980416  JoAn     SID 1659 Removed Insert_Collect_Ivc_Head_Hist.
--  980409  JoAn     SID 1659 Clenup of history record generation.
--                   Removed history record creation for order lines when creating
--                   credit invoice.
--  980305  JoAn     Added Get_Item_Id, Get_Sale_Unit_Price, Get_Net_Curr_Amount
--                   and Get_Invoiced_Qty.
--  980302  ToOs     Bug fix 2732. Changed calculation of discount in Create_invoice_item and Fetch_Postings.
--  980227  MNYS     Bug fix 2855. Replaced USER with Utility_SYS.Get_User in
--                   Complete_Check_Accounting___.
--  980223  ToOs     Changed in procedure Fetch_Postings so that alsa package_part and
--                   Catalog_Part gets the catalog_no.
--                   IF (catalog_type_ != Sales_Part_Type_API.Get_Client_Value(0))
--                   instead of IF (catalog_type_ = Sales_Part_Type_API.Get_Client_Value(1))
--  980211  ToOs     Changed roundings to get_currency_rounding
--  970126  JoAn     Changed Create_Invoice_Item to handle lines with price = 0
--  971120  RaKu     Changed to FND200 Templates.
--  971031  RaKu     Changed length on unit_codes in view from 4 to 10.
--  971020  GOPE     Removed the zero account line made for discount in method
--                   fetch_postings
--  971001  JoAn     Corrected calculation of net_curr_amount_ and vat_curr_amount_
--                   in Create_Invoice_Item (Rounding caused problems when comparing
--                   amount to postings)
--  970908  MAJE     Changed unit of measure references to 10 character, mixed case, IsoUnit ref
--  970905  JoAn     Added objstate to view (Needed in client when launching
--                   sales tax dialog).
--  970905  JoAn     Added handling of attribute TAXABLE to Create_Invoice_Item
--  970625  RaKu     Added order_discount in Fetch_Postings. Was not handled before.
--  970606  JOHNI    Removed substitution variable PRODUCT_CODE.
--  970508  JoAn     Changes due to Finance8.1 integration
--  970417  JOED     Removed objstate from Customer_Order_History_API.New and
--                   Customer_Order_Line_Hist_API.New
--  970416  JOED     Changed call to Customer_Order_History_API.
--                   Changed call to Customer_Order_Line_Hist_API.
--  970220  ASBE     BUG 97-0029 Invoice lines can only be removed if it is not
--                   a debit invoice.
--  961211  JOED     Replaced the Get_Values_For_Postings to Get_Pre_Accounting_Id,
--                   Get_Part_No and Get_Contract functions.
--  961206  JOED     Removed company from call to Mpccom_Accounting_API.Get_Code_String
--  961120  JOED     Made Workbench-compatible.
--  961114  JOAN     Replaced Customer_Order_Delivery_API.Get_First_Deliv_No
--                   with sysdate in assignment to reference_ in Create_Invoice_Item.
--  961107  JOED     Replaced Sales_Part_API.Get_Part_Information procedure with
--                   Sales_Part_API.Get_Catalog_Type function.
--  961105  JOED     Renamed Sales_Part_API function calls.
--  961101  JOBE     Renamed Vat_Rate_API function calls.
--  961029  RAKU     Removed parameter USER in call to
--                   Customer_Order_Line_Hist_API.New.
--  961018  RAKU     Changed all dbms_output to Trace_SYS.
--  971017  GOPE     Correction in method fetch_postings the vat_code check
--  961016  JOED     Changed call to Get_Status_Code in Customer_Order_Line_API.
--  961011  JOED     Changed comment on catalog_no.
--  961003  RAKU     Added function Get_First_Order.
--  961002  RAKU     Changed creator calls to &PKG and viewname from
--                   inc_invoice_util_inv_item to out_invoice_......
--  961001  RAKU     Changed invoice_no to invoice_id in Create_Invoice_Item &
--                   Create_Credit_Invoice_Item.
--  961001  RAKU     Added 'DELIV_NO' in "reference" in Create_Invoice_Item.
--  961001  MAOR     Changed call to Out_Invoice_Util_API.Create_Invoice_Item_.
--  960930  MAOR     Added call to Out_Invoice_Util_API.Create_Invoice_Item_.
--  960930  PEKR     Do_Str_Event_Acc___ modified. Complete_Check_Accounting___
--                   shouldn't be executed if error has occured.
--  960930  MAOR     Removed usage of rcode.
--  960930  MAOR     Added procedure Insert_Collect_Ivc_Head_Hist.
--  960927  MAOR     Added procedure Create_Credit_Invoice_Item.
--  960926  RAKU     Modifyed procedure Build_Item_Attr_String___.
--  960926  RAKU     Changed view name from Invoice_Utility_Inv_Item to
--                   Inc_Invoice_Util_Inv_Item. Changed LU name Invoice_Utility_API
--                   to Out_Invoice_Util_API.
--  960926  PEKR     Add Fetch_Postings, Get_Vat_Code, Do_Str_Event_Acc___,
--                   Complete_Check_Accounting___.
--  960913  RAKU     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
-- gelr:prepayment_tax_document, added prepay_tax_base_curr_amt, prepay_tax_curr_amount, prepay_tax_document_id
-- gelr:disc_price_rounded, added original_discount, original_add_discount, original_order_discount
TYPE Public_Rec IS RECORD
   (company             VARCHAR2(20),
    invoice_id          NUMBER(20),
    item_id             NUMBER(20),
    contract            VARCHAR2(100),
    identity            customer_info_public.customer_id%TYPE,
    deliv_type_id       VARCHAR2(20),
    vat_code            VARCHAR2(20),
    vat_rate            NUMBER,
    net_curr_amount     NUMBER,
    vat_curr_amount     NUMBER,
    gross_curr_amount   NUMBER,
    net_dom_amount      NUMBER,
    vat_dom_amount      NUMBER,
    reference           VARCHAR2(200),
    order_no            VARCHAR2(100),
    line_no             VARCHAR2(100),
    release_no          VARCHAR2(4),
    line_item_no        NUMBER,
    pos                 VARCHAR2(100),
    catalog_no          VARCHAR2(2000),
    description         VARCHAR2(2000),
    invoiced_qty        NUMBER,
    sale_um             VARCHAR2(100),
    price_conv          NUMBER,
    price_um            VARCHAR2(100),
    sale_unit_price     NUMBER,
    unit_price_incl_tax NUMBER,
    discount            NUMBER,
    order_discount      NUMBER,
    customer_po_no      VARCHAR2(100),
    charge_seq_no       NUMBER,
    charge_group        VARCHAR2(100),
    stage               NUMBER,
    additional_discount NUMBER,
    prel_update_allowed VARCHAR2(5),
    prepay_invoice_no   VARCHAR2(50),
    prepay_invoice_series_id VARCHAR2(20),
    sales_part_rebate_group VARCHAR2(10),
    assortment_id           VARCHAR2(50),
    assortment_node_id      VARCHAR2(50),
    ship_addr_no            VARCHAR2(100),
    charge_percent NUMBER ,
    charge_percent_basis NUMBER,
    rental_transaction_id NUMBER,
    income_type_id        VARCHAR2(20),
    tax_calc_structure_id VARCHAR2(20),
    rma_no              NUMBER,
    free_of_charge            VARCHAR2(5),
    free_of_charge_tax_basis  NUMBER,
    base_comp_bearing_tax_amt NUMBER,
    customer_tax_usage_type VARCHAR2(5),
    original_discount            NUMBER,
    original_add_discount        NUMBER,
    original_order_discount      NUMBER,
    acquisition_origin           NUMBER,
    statistical_code             VARCHAR2(15),    
    prepay_tax_base_curr_amt     NUMBER, 
    prepay_tax_curr_amount       NUMBER, 
    prepay_tax_document_id       NUMBER);

-------------------- PRIVATE DECLARATIONS -----------------------------------
pc_tax_round_item_start_           CONSTANT NUMBER        := 100100;
pc_rounding_diff_start_            CONSTANT NUMBER        := 500000;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Calc_Line_Net_Gross_Amts___ (
   gross_curr_amount_   IN OUT NUMBER,
   net_curr_amount_     IN OUT NUMBER ,
   company_             IN     VARCHAR2,
   invoice_id_          IN     NUMBER, 
   item_id_             IN     NUMBER,  
   invoiced_qty_        IN     NUMBER ,
   unit_price_incl_tax_ IN     NUMBER,
   sale_unit_price_     IN     NUMBER,
   discount_            IN     NUMBER,
   order_discount_      IN     NUMBER,
   add_discount_        IN     NUMBER,
   price_conv_factor_   IN     NUMBER,
   currency_rounding_   IN     NUMBER,
   use_price_incl_tax_  IN     VARCHAR2)
IS
   line_discount_amount_  NUMBER;
   total_net_amount_      NUMBER;
   total_gross_amount_    NUMBER;
   add_disc_amt_          NUMBER;
   order_discount_amount_ NUMBER;
   total_discount_        NUMBER;
BEGIN
   IF discount_ IS NULL THEN
      line_discount_amount_ := Cust_Invoice_Item_Discount_API.Get_Total_Line_Discount(company_, invoice_id_, item_id_, invoiced_qty_,
                                                                                      price_conv_factor_, currency_rounding_);
   
   ELSE
      line_discount_amount_ := discount_;
   END IF;
   IF (use_price_incl_tax_ = 'TRUE') THEN
         -- Calculate the invoice item totals
         total_gross_amount_    := invoiced_qty_ * price_conv_factor_ * unit_price_incl_tax_;
         -- total_gross_amount_ is rounded before calculations to align with discounts
         total_gross_amount_    := ROUND(total_gross_amount_, currency_rounding_);
         add_disc_amt_          := ROUND (((total_gross_amount_ - line_discount_amount_) * NVL(add_discount_,0)/100 ), currency_rounding_);
         order_discount_amount_ := (total_gross_amount_ - line_discount_amount_) * (order_discount_/100);
         order_discount_amount_ := ROUND(order_discount_amount_, currency_rounding_);
         -- The rounding of total_net_amount_ must be done after calculating discount amounts      
         total_discount_        := line_discount_amount_ + order_discount_amount_ + add_disc_amt_;
         gross_curr_amount_     := total_gross_amount_ - total_discount_;
      ELSE
         -- Calculate the invoice item totals
         total_net_amount_      := invoiced_qty_ * price_conv_factor_ * sale_unit_price_;
         add_disc_amt_          := ROUND (((total_net_amount_ - line_discount_amount_) * NVL(add_discount_,0)/100 ), currency_rounding_);
         order_discount_amount_ := (total_net_amount_ - line_discount_amount_) * (order_discount_/100);
         order_discount_amount_ := ROUND(order_discount_amount_, currency_rounding_);
         -- The rounding of total_net_amount_ must be done after calculating discount amounts
         total_net_amount_      := ROUND(total_net_amount_, currency_rounding_);
         total_discount_        := line_discount_amount_ + order_discount_amount_ + add_disc_amt_;
         net_curr_amount_       := total_net_amount_ - total_discount_;

      END IF;
END Calc_Line_Net_Gross_Amts___;

-- gelr:br_external_tax_integration, added acquisition_origin_, statistical_code_
PROCEDURE Calculate_Line_And_Tax_Amts___ (
   tax_percentage_                 OUT NUMBER,
   multiple_tax_                   OUT VARCHAR2,
   line_tax_curr_amount_           OUT NUMBER,
   line_tax_dom_amount_            OUT NUMBER,
   line_tax_para_amount_           OUT NUMBER,
   line_gross_curr_amount_      IN OUT NUMBER,
   line_net_curr_amount_        IN OUT NUMBER,
   tax_msg_                     IN OUT VARCHAR2,
   tax_code_                    IN OUT VARCHAR2,
   tax_calc_structure_id_       IN OUT VARCHAR2,
   company_                     IN     VARCHAR2,
   invoice_id_                  IN     NUMBER,
   item_id_                     IN     NUMBER,
   identity_                    IN     VARCHAR2,
   contract_                    IN     VARCHAR2,
   invoice_type_                IN     VARCHAR2,
   party_type_db_               IN     VARCHAR2,
   catalog_no_                  IN     VARCHAR2,
   deliv_type_id_               IN     VARCHAR2,
   invoiced_qty_                IN     NUMBER ,
   buy_qty_due_                 IN     NUMBER ,
   unit_price_incl_tax_         IN     NUMBER,
   sale_unit_price_             IN     NUMBER,
   discount_                    IN     NUMBER,
   order_discount_              IN     NUMBER,
   add_discount_                IN     NUMBER,
   price_conv_factor_           IN     NUMBER,
   currency_rounding_           IN     NUMBER,
   use_price_incl_tax_          IN     VARCHAR2,
   free_of_charge_tax_basis_    IN     NUMBER,
   fetch_tax_from_external_     IN     BOOLEAN,
   consider_ext_tax_curr_amt_   IN     BOOLEAN,
   cust_tax_usage_type_         IN     VARCHAR2 DEFAULT NULL,
   acquisition_origin_          IN     VARCHAR2 DEFAULT NULL,
   statistical_code_            IN     VARCHAR2 DEFAULT NULL )
IS
   attr_                         VARCHAR2(2000);
   tax_info_attr_                VARCHAR2(2000);
   tax_class_id_                 VARCHAR2(20);
   tax_method_                   VARCHAR2(20); 
   tax_method_db_                VARCHAR2(20);
   tax_type_db_                  VARCHAR2(10);     
   line_cost_curr_amount_        NUMBER;
   line_non_ded_tax_curr_amount_ NUMBER;
   line_total_tax_curr_amount_   NUMBER;
   line_non_ded_tax_dom_amount_  NUMBER;
   line_non_ded_tax_para_amount_ NUMBER;
   calc_base_                    VARCHAR2(20);
   head_rec_                     Invoice_API.Public_Rec;
   tax_liability_type_db_        VARCHAR2(20);
   reb_cre_inv_type_             VARCHAR2(20);
   in_tax_msg_                   VARCHAR2(32000);
   action_                       VARCHAR2(50);
   threshold_amount_             NUMBER;
BEGIN
   head_rec_ := Invoice_API.Get(company_,invoice_id_);
   
   IF cust_tax_usage_type_ IS NOT NULL THEN
      Client_SYS.Set_Item_Value('CUSTOMER_TAX_USAGE_TYPE', cust_tax_usage_type_, attr_); 
   END IF;
   -- gelr:br_external_tax_integration, begin
   IF acquisition_origin_ IS NOT NULL THEN
      Client_SYS.Set_Item_Value('ACQUISITION_ORIGIN', acquisition_origin_, attr_);
   END IF;
   IF statistical_code_ IS NOT NULL THEN
      Client_SYS.Set_Item_Value('STATISTICAL_CODE', statistical_code_, attr_);
   END IF;
   -- gelr:br_external_tax_integration, end
   
   IF (free_of_charge_tax_basis_ IS NOT NULL) THEN
      Company_Tax_Discom_Info_API.Calc_Threshold_Amount_Curr(threshold_amount_, 
                                                             company_,
                                                             identity_,
                                                             contract_,
                                                             head_rec_.currency);
      IF (ABS(free_of_charge_tax_basis_) >= threshold_amount_) THEN
         line_net_curr_amount_  :=  free_of_charge_tax_basis_;           
      ELSE
         line_net_curr_amount_ := 0;
      END IF;                                                             
      line_net_curr_amount_  :=  ROUND(line_net_curr_amount_, currency_rounding_);
      calc_base_ := 'NET_BASE';
   ELSE 
      Calc_Line_Net_Gross_Amts___(line_gross_curr_amount_,line_net_curr_amount_,company_,invoice_id_,item_id_,invoiced_qty_,
                                  unit_price_incl_tax_,sale_unit_price_,discount_,order_discount_,add_discount_,
                                  price_conv_factor_,currency_rounding_,use_price_incl_tax_);
      IF (use_price_incl_tax_ = 'TRUE') THEN
         calc_base_ := 'GROSS_BASE';
      ELSE  
         calc_base_ := 'NET_BASE';
      END IF;
   END IF;
   Get_Tax_Info(tax_info_attr_, company_, invoice_id_, item_id_);
   tax_liability_type_db_ := Client_SYS.Get_Item_Value('TAX_LIABILITY_TYPE_DB', tax_info_attr_);
   
   IF consider_ext_tax_curr_amt_ THEN
      action_ := 'EXTERNAL_TAX_CURR_AMOUNT';
   END IF;
   IF fetch_tax_from_external_ THEN
      -- gelr:br_external_tax_integration, added acquisition_origin_, statistical_code_
      IF cust_tax_usage_type_ IS NULL AND acquisition_origin_ IS NULL AND statistical_code_ IS NULL THEN
         Client_SYS.Clear_Attr(attr_);
      END IF;

      Tax_Handling_Order_Util_API.Fetch_External_Tax_Info(tax_msg_            => in_tax_msg_,
                                                         line_net_curr_amount_ =>line_net_curr_amount_,
                                                         source_ref1_         => invoice_id_,
                                                         source_ref2_         => item_id_,
                                                         source_ref3_         => '*',
                                                         source_ref4_         => '*',
                                                         source_ref5_         => '*',
                                                         source_ref_type_     => Tax_Source_API.DB_INVOICE,
                                                         company_             => company_,
                                                         contract_            => contract_,
                                                         customer_no_         => identity_,   
                                                         object_id_           => catalog_no_,
                                                         quantity_            => invoiced_qty_,
                                                         tax_liability_       => head_rec_.tax_liability,
                                                         tax_liability_type_db_ => tax_liability_type_db_,
                                                         attr_                => attr_);
                                                         
       -- Remove taxes when in_tax_msg_ is NULL. in_tax_msg_ is set to NULL when invoice line has no taxes.
      IF in_tax_msg_ IS NULL AND 
         Source_Tax_Item_API.Tax_Items_Exist(company_, Tax_Source_API.DB_INVOICE, invoice_id_, item_id_, '*', '*', '*') = Fnd_Boolean_API.DB_TRUE THEN 
         Source_Tax_Item_Invoic_API.Remove_Tax_Items( company_,
                                                      Tax_Source_API.DB_INVOICE,
                                                      invoice_id_,
                                                      item_id_,
                                                      '*',
                                                      '*',
                                                      '*');
      END IF;                                                    
   END IF;
   Tax_Handling_Invoic_Util_API.Add_Transaction_Tax_Info(tax_msg_,
                                                         tax_class_id_,
                                                         multiple_tax_,
                                                         tax_method_,
                                                         tax_method_db_,
                                                         tax_type_db_,
                                                         tax_percentage_,
                                                         line_tax_curr_amount_,
                                                         line_tax_dom_amount_,
                                                         line_tax_para_amount_,
                                                         line_cost_curr_amount_,
                                                         line_total_tax_curr_amount_,
                                                         line_non_ded_tax_curr_amount_,
                                                         line_non_ded_tax_dom_amount_,
                                                         line_non_ded_tax_para_amount_,
                                                         line_gross_curr_amount_,
                                                         line_net_curr_amount_,
                                                         tax_code_,
                                                         tax_calc_structure_id_,
                                                         attr_,
                                                         company_,
                                                         identity_,
                                                         invoice_type_,
                                                         party_type_db_,
                                                         head_rec_.currency,
                                                         head_rec_.supply_country,
                                                         head_rec_.tax_liability,
                                                         tax_liability_type_db_,
                                                         head_rec_.delivery_address_id,
                                                         'FALSE',
                                                         NULL,
                                                         head_rec_.creator,
                                                         head_rec_.adv_inv,
                                                         catalog_no_,
                                                         deliv_type_id_,
                                                         calc_base_,
                                                         action_,
                                                         in_tax_msg_,
                                                         invoice_id_,
                                                         item_id_,
                                                         head_rec_.curr_rate,
                                                         head_rec_.tax_curr_rate,
                                                         head_rec_.div_factor,
                                                         head_rec_.parallel_curr_rate,
                                                         head_rec_.parallel_div_factor,
                                                         head_rec_.invoice_date);
   
   -- Need to update taxes and fetch the prices correctly for external taxes.
   IF fetch_tax_from_external_ THEN                                                     
      Modify_Inv_Tax_Item___(company_, 
                             invoice_id_, 
                             item_id_, 
                             tax_msg_,
                             identity_);  
                                
      Invoice_Item_API.Modify_Line_Level_Tax_Info(company_, calc_base_, head_rec_.creator, NULL, invoice_id_, item_id_);                                                                                      
   END IF;  
   
   -- Exclude tax code mandatory validation for rebate credit invoice.
   reb_cre_inv_type_ := Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(company_);
   IF ((multiple_tax_ ='FALSE' AND tax_code_ IS NULL ) AND (invoice_type_ != reb_cre_inv_type_))THEN 
      Tax_Handling_Util_API.Validate_Tax_Code_Mandatory(company_, 'CUSTOMER_TAX'); 
   END IF;                                                      
                                                
END Calculate_Line_And_Tax_Amts___;

PROCEDURE Calculate_Adv_Inv_Amts___ (
   tax_calc_structure_id_    OUT VARCHAR2,
   line_net_curr_amount_     OUT NUMBER,
   line_tax_curr_amount_     OUT NUMBER,
   line_tax_dom_amount_      OUT NUMBER,
   line_tax_para_amount_     OUT NUMBER,
   tax_info_table_           OUT Tax_Handling_Util_API.tax_information_table,
   tax_msg_               IN     VARCHAR2,
   company_               IN     VARCHAR2,
   invoice_id_            IN     NUMBER, 
   invoice_date_          IN     DATE,
   currency_rate_         IN     NUMBER,
   identity_              IN     VARCHAR2,
   unit_price_incl_tax_   IN     NUMBER,
   sale_unit_price_       IN     NUMBER,
   currency_code_         IN     VARCHAR2,
   ship_addr_no_          IN     VARCHAR2)
IS
   base_for_adv_invoice_      VARCHAR2(35);
   price_type_                VARCHAR2(20);
   line_amount_rec_           Tax_Handling_Util_API.line_amount_rec;
   ifs_curr_rounding_         NUMBER;
   attr_                      VARCHAR2(2000);
BEGIN
   
   base_for_adv_invoice_ := Company_Order_Info_API.Get_Base_For_Adv_Invoice_Db(company_);           
   IF (base_for_adv_invoice_ = 'NET AMOUNT' OR base_for_adv_invoice_ = 'NET AMOUNT WITH CHARGES') THEN
      price_type_ := 'NET_BASE';
   ELSIF  (base_for_adv_invoice_ = 'GROSS AMOUNT' OR base_for_adv_invoice_ = 'GROSS AMOUNT WITH CHARGES') THEN
      price_type_ := 'GROSS_BASE';    
   END IF;
   Tax_Handling_Order_Util_API.Fetch_And_Calc_Tax_From_Msg (line_amount_rec_ ,
                                                            tax_info_table_ ,
                                                            attr_,
                                                            tax_msg_,
                                                            company_,
                                                            unit_price_incl_tax_,
                                                            sale_unit_price_,
                                                            price_type_,
                                                            'FALSE',
                                                            invoice_date_,
                                                            currency_rate_,
                                                            Tax_Source_API.DB_INVOICE,
                                                            invoice_id_, 
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            identity_,
                                                            currency_code_,
                                                            ship_addr_no_,
                                                            ifs_curr_rounding_);	
   IF (tax_info_table_.COUNT > 0)THEN
      tax_calc_structure_id_ := tax_info_table_(1).tax_calc_structure_id;
   END IF; 
   line_tax_dom_amount_  := line_amount_rec_.line_tax_dom_amount;
   line_net_curr_amount_ := line_amount_rec_.line_net_curr_amount;
   line_tax_curr_amount_ := line_amount_rec_.line_tax_curr_amount;                                              
   line_tax_para_amount_ := line_amount_rec_.line_tax_para_amount;                                              
END Calculate_Adv_Inv_Amts___;

PROCEDURE Modify_Inv_Tax_Item___ (company_    IN VARCHAR2,
                                  invoice_id_ IN NUMBER,
                                  item_id_    IN NUMBER,
                                  tax_msg_    IN VARCHAR2,
                                  identity_   IN VARCHAR2 )
IS 
BEGIN

   Source_Tax_Item_Invoic_API.Create_Tax_Items_From_Msg(company_,
                                                        Tax_Source_API.DB_INVOICE,
                                                        TO_CHAR(invoice_id_),
                                                        TO_CHAR(item_id_),
                                                        '*',
                                                        '*',
                                                        '*',
                                                        tax_msg_);
   Invoice_API.Update_Invoice_Head(company_,
                                   identity_,                                   
                                   invoice_id_);                                                                                                           
END Modify_Inv_Tax_Item___;

PROCEDURE Fetch_Keys_In_Inv_Type___ (
   is_adv_deb_inv_    OUT VARCHAR2,
   source_key_rec_    OUT Tax_Handling_Util_API.source_key_rec,
   company_        IN     VARCHAR2,
   inv_type_       IN     VARCHAR2,
   order_no_       IN     VARCHAR2,
   line_no_        IN     VARCHAR2,
   rel_no_         IN     VARCHAR2 ,
   line_item_no_   IN     NUMBER,
   charge_seq_no_  IN     NUMBER,
   rma_no_         IN     NUMBER,
   rma_line_no_    IN     NUMBER,
   rma_charge_no_  IN     NUMBER,
   shipment_id_    IN     VARCHAR2,
   invoice_id_     IN     NUMBER,
   deb_invoice_id_ IN     NUMBER,
   deb_item_id_    IN     NUMBER) 
IS 
   correction_inv_type_      VARCHAR2(20);
   col_cor_inv_type_         VARCHAR2(20);
   reb_cre_inv_type_         VARCHAR2(20);
   adv_deb_inv_type_         VARCHAR2(20);
   adv_cre_inv_type_         VARCHAR2(20);
   -- gelr:prepayment_tax_document, begin
   tax_doc_cre_inv_type_     VARCHAR2(20);
   -- gelr:prepayment_tax_document, end
BEGIN
   correction_inv_type_  := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   col_cor_inv_type_     := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);
   reb_cre_inv_type_     := Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(company_);
   adv_deb_inv_type_     := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Dr_Inv_Type(company_);
   adv_cre_inv_type_     := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Cr_Inv_Type(company_);
   -- gelr:prepayment_tax_document, begin
   tax_doc_cre_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cre_Tax_Doc_Type(company_);
   -- gelr:prepayment_tax_document, end
   IF (inv_type_ = adv_deb_inv_type_) THEN
      is_adv_deb_inv_ := 'TRUE';
   ELSE 
      is_adv_deb_inv_ := 'FALSE';
      -- credit invoices
      IF (inv_type_ IN (correction_inv_type_, col_cor_inv_type_ ,'CUSTORDCRE','CUSTCOLCRE', adv_cre_inv_type_, tax_doc_cre_inv_type_)) AND (rma_no_ IS NULL) THEN
         source_key_rec_.source_ref1  := TO_CHAR(deb_invoice_id_);
         source_key_rec_.source_ref2  := TO_CHAR(deb_item_id_);          
         source_key_rec_.source_ref3  := '*';       
         source_key_rec_.source_ref4  := '*';      
         source_key_rec_.source_ref5  := '*';      
         source_key_rec_.source_ref_type := Tax_Source_API.DB_INVOICE;
      --special handiling for rebate credit invoices   
      ELSIF (inv_type_ = reb_cre_inv_type_) THEN
         source_key_rec_.source_ref1  := TO_CHAR(invoice_id_);     
         source_key_rec_.source_ref_type := Tax_Source_API.DB_INVOICE;     
      -- RMA Line   
      ELSIF (rma_no_ IS NOT NULL AND rma_line_no_ IS NOT NULL AND rma_charge_no_ IS NULL)THEN      
         source_key_rec_.source_ref1  := TO_CHAR(rma_no_);
         source_key_rec_.source_ref2  := TO_CHAR(rma_line_no_);          
         source_key_rec_.source_ref3  := '*';       
         source_key_rec_.source_ref4  := '*'; 
         source_key_rec_.source_ref5  := '*'; 
         source_key_rec_.source_ref_type := Tax_Source_API.DB_RETURN_MATERIAL_LINE;    

      -- RMA Charge
      ELSIF (rma_no_ IS NOT NULL AND rma_charge_no_ IS NOT NULL) THEN      
         source_key_rec_.source_ref1  := TO_CHAR(rma_no_);
         source_key_rec_.source_ref2  := TO_CHAR(rma_charge_no_);          
         source_key_rec_.source_ref3  := '*';       
         source_key_rec_.source_ref4  := '*';  
         source_key_rec_.source_ref5  := '*'; 
         source_key_rec_.source_ref_type := Tax_Source_API.DB_RETURN_MATERIAL_CHARGE;   

      -- Customer Order Line   
      ELSIF (order_no_ IS NOT NULL AND line_no_ IS NOT NULL AND rel_no_ IS NOT NULL AND charge_seq_no_ IS NULL) THEN
         source_key_rec_.source_ref1  := order_no_;
         source_key_rec_.source_ref2  := line_no_;          
         source_key_rec_.source_ref3  := rel_no_;       
         source_key_rec_.source_ref4  := TO_CHAR(line_item_no_);    
         source_key_rec_.source_ref5  := '*'; 
         source_key_rec_.source_ref_type := Tax_Source_API.DB_CUSTOMER_ORDER_LINE;     
      -- Customer Order Charge
      ELSIF (order_no_ IS NOT NULL AND charge_seq_no_ IS NOT NULL) THEN
         source_key_rec_.source_ref1  := order_no_;
         source_key_rec_.source_ref2  := TO_CHAR(charge_seq_no_);      
         source_key_rec_.source_ref3  := '*';       
         source_key_rec_.source_ref4  := '*';     
         source_key_rec_.source_ref5  := '*'; 
         source_key_rec_.source_ref_type := Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE;  

       -- Shipment Freight Charge Invoice
      ELSIF (order_no_ IS NULL AND shipment_id_ IS NOT NULL AND charge_seq_no_ IS NOT NULL) THEN
         source_key_rec_.source_ref1  := shipment_id_;
         source_key_rec_.source_ref2  := TO_CHAR(charge_seq_no_);      
         source_key_rec_.source_ref3  := '*';       
         source_key_rec_.source_ref4  := '*';    
         source_key_rec_.source_ref5  := '*'; 
         source_key_rec_.source_ref_type := Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE; 
      END IF; 
   END IF;   
END Fetch_Keys_In_Inv_Type___;

-- Build_Item_Attr_String___
--   Unpacks bypassed attr_ string and sends it back after Exist controls are
PROCEDURE Build_Item_Attr_String___ (
   recalc_tax_  OUT BOOLEAN,
   item_attr_     OUT VARCHAR2,
   company_       IN  VARCHAR2,
   currency_code_ IN  VARCHAR2,
   attr_          IN  VARCHAR2,
   objid_         IN  VARCHAR2)
IS
   ptr_               NUMBER;
   name_              VARCHAR2(30);
   value_             VARCHAR2(2000);
   temp_attr_         VARCHAR2(32000);
   currency_rounding_ NUMBER;
   disc_changed_      BOOLEAN := FALSE;
   
   CURSOR get_item_data IS
      SELECT invoice_id, invoiced_qty, sale_unit_price, unit_price_incl_tax, discount, order_discount, 
             additional_discount, vat_code, tax_calc_structure_id, deliv_type_id, 
             net_curr_amount, vat_curr_amount, vat_dom_amount, catalog_no, charge_percent, contract, 
             customer_tax_usage_type, charge_percent_basis, man_tax_liability_Date
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  OBJID = objid_;
   oldrec_            get_item_data%ROWTYPE;
   
   -- Aurena client sends all the attributes in attr_ whether they are changed or not. Therefore, check if the value sent in attr_ differs from the previous value of the record.
   -- Returns true if the value is actually changed in client or the method not called from Aurena client where old_value_ is NULL. 
   FUNCTION Get_Recalc_Tax___ (attr_val_  IN VARCHAR2,
                               old_value_ IN VARCHAR2) RETURN BOOLEAN
   IS
BEGIN
      IF (recalc_tax_ OR oldrec_.invoiced_qty IS NULL) THEN
         RETURN TRUE;
      ELSE
         RETURN Validate_SYS.Is_Changed(old_value_, attr_val_);
      END IF;
   END Get_Recalc_Tax___;
BEGIN

   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   recalc_tax_ := FALSE;
   IF (Fnd_Session_API.Is_Odp_Session) THEN
      OPEN get_item_data;
      FETCH get_item_data INTO oldrec_;
      CLOSE get_item_data;
   END IF;
   
   ptr_ := NULL;
   Client_SYS.Clear_Attr(temp_attr_);
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'INVOICED_QTY') THEN
         Client_SYS.Add_To_Attr('N2', value_, temp_attr_);
         disc_changed_ := TRUE;
         recalc_tax_ := Get_Recalc_Tax___(value_, to_char(oldrec_.invoiced_qty));
      ELSIF (name_ = 'SALE_UNIT_PRICE') THEN
         Client_SYS.Add_To_Attr('N4', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, to_char(oldrec_.sale_unit_price));
      ELSIF (name_ = 'UNIT_PRICE_INCL_TAX') THEN
         Client_SYS.Add_To_Attr('N15', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, to_char(oldrec_.unit_price_incl_tax));
      ELSIF (name_ = 'DISCOUNT') THEN
         Client_SYS.Add_To_Attr('N5', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, to_char(oldrec_.discount));
      ELSIF (name_ = 'ORDER_DISCOUNT') THEN
         Client_SYS.Add_To_Attr('N6', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, to_char(oldrec_.order_discount));
      ELSIF (name_ = 'ADDITIONAL_DISCOUNT') THEN
         Client_SYS.Add_To_Attr('N12', value_ , temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, to_char(oldrec_.additional_discount));
      ELSIF (name_ = 'VAT_CODE') THEN
         IF (value_ IS NOT NULL) THEN
            Statutory_Fee_API.Exist(company_, value_);
         END IF;
         Client_SYS.Add_To_Attr('VAT_CODE', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, oldrec_.vat_code);
      ELSIF (name_ = 'TAX_CALC_STRUCTURE_ID') THEN
         Client_SYS.Add_To_Attr('TAX_CALC_STRUCTURE_ID', value_, temp_attr_);   
         recalc_tax_ := Get_Recalc_Tax___(value_, oldrec_.tax_calc_structure_id);
      ELSIF (name_ = 'DELIV_TYPE_ID') THEN
         IF (value_ IS NOT NULL) THEN
            Delivery_Type_API.Exist(company_, value_);
         END IF;
         Client_SYS.Add_To_Attr('DELIV_TYPE_ID', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, oldrec_.deliv_type_id);
      ELSIF (name_ = 'NET_CURR_AMOUNT') THEN
         value_ := ROUND(value_, currency_rounding_);
         Client_SYS.Add_To_Attr('NET_CURR_AMOUNT', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, to_char(oldrec_.net_curr_amount));
      ELSIF (name_ = 'VAT_CURR_AMOUNT') THEN
         value_ := ROUND(value_, currency_rounding_);
         Client_SYS.Add_To_Attr('VAT_CURR_AMOUNT', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, to_char(oldrec_.vat_curr_amount));
      ELSIF (name_ = 'VAT_DOM_AMOUNT') THEN
         value_ := ROUND(value_, currency_rounding_);
         Client_SYS.Add_To_Attr('VAT_DOM_AMOUNT', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, to_char(oldrec_.vat_dom_amount));
      ELSIF (name_ = 'POS') THEN
         Client_SYS.Add_To_Attr('C4', value_, temp_attr_);
      ELSIF (name_ = 'CATALOG_NO') THEN
         Client_SYS.Add_To_Attr('C5', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, oldrec_.catalog_no);
      ELSIF (name_ = 'DESCRIPTION') THEN
         Client_SYS.Add_To_Attr('C6', value_, temp_attr_);
      ELSIF (name_ = 'SALE_UM') THEN
         Client_SYS.Add_To_Attr('C7', value_, temp_attr_);
      ELSIF (name_ = 'PRICE_CONV') THEN
         Client_SYS.Add_To_Attr('N3', value_, temp_attr_);
      ELSIF (name_ = 'PRICE_UM') THEN
         Client_SYS.Add_To_Attr('C8', value_, temp_attr_);
      ELSIF (name_ = 'CUSTOMER_PO_NO') THEN
         Client_SYS.Add_To_Attr('C9', value_, temp_attr_);
      ELSIF (name_ = 'ORDER_NO') THEN
         Client_SYS.Add_To_Attr('C1', value_, temp_attr_);
      ELSIF (name_ = 'LINE_NO') THEN
         Client_SYS.Add_To_Attr('C2', value_, temp_attr_);
      ELSIF (name_ = 'RELEASE_NO') THEN
         Client_SYS.Add_To_Attr('C3', value_, temp_attr_);
      ELSIF (name_ = 'LINE_ITEM_NO') THEN
         Client_SYS.Add_To_Attr('N1', value_, temp_attr_);
      ELSIF (name_ = 'CHARGE_PERCENT') THEN
         Client_SYS.Add_To_Attr('N13', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, to_char(oldrec_.charge_percent));
      ELSIF (name_ = 'CONTRACT') THEN
         Client_SYS.Add_To_Attr('C10', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, oldrec_.contract);
      ELSIF (name_ = 'MAN_TAX_LIABILITY_DATE') THEN
         Client_SYS.Add_To_Attr('MAN_TAX_LIABILITY_DATE', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, oldrec_.man_tax_liability_Date);
      ELSIF (name_ = 'INCOME_TYPE_ID') THEN
         Client_SYS.Add_To_Attr('IRS1099_TYPE_ID', value_, temp_attr_);
      ELSIF (name_ = 'INVOICE_TEXT_ID') THEN         
         Client_SYS.Add_To_Attr('C20', value_, temp_attr_);
      ELSIF (name_ = 'INVOICE_TEXT') THEN
         Client_SYS.Add_To_Attr('C21', value_, temp_attr_);
      ELSIF (name_ = 'CORRECTION_REASON_ID') THEN
         Client_SYS.Add_To_Attr('CORRECTION_REASON_ID', value_, temp_attr_);
      ELSIF (name_ = 'CORRECTION_REASON') THEN
         Client_SYS.Add_To_Attr('CORRECTION_REASON', value_, temp_attr_);
      ELSIF (name_ = 'CUSTOMER_TAX_USAGE_TYPE') THEN
         Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, oldrec_.customer_tax_usage_type);
      -- gelr: br_business_operation, begin
      ELSIF (name_ = 'BUSINESS_OPERATION') THEN
         IF (value_ IS NOT NULL) THEN
            Business_Operation_API.Exist(company_, value_);
         END IF;
         Client_SYS.Add_To_Attr('BUSINESS_OPERATION', value_, temp_attr_);
      -- gelr: br_business_operation, end
      -- gelr: acquisition_origin, begin
      ELSIF (name_ = 'ACQUISITION_ORIGIN') THEN
         IF (value_ IS NOT NULL) THEN
            Acquisition_Origin_API.Exist(company_, value_);
         END IF;
         Client_SYS.Add_To_Attr('ACQUISITION_ORIGIN', value_, temp_attr_);
      -- gelr: acquisition_origin, end
      -- gelr:good_service_statistical_code, begin
      ELSIF (name_ = 'STATISTICAL_CODE') THEN
         IF (value_ IS NOT NULL) THEN
            Statistical_Code_API.Exist(company_, value_);
         END IF;
         Client_SYS.Add_To_Attr('STATISTICAL_CODE', value_, temp_attr_);
      -- gelr:good_service_statistical_code, end
      -- gelr:disc_price_rounded, begin
      ELSIF (name_ = 'ORIGINAL_DISCOUNT') THEN
         Client_SYS.Add_To_Attr('N20', value_, temp_attr_);
         recalc_tax_ := TRUE;
      ELSIF (name_ = 'ORIGINAL_ADD_DISCOUNT') THEN
         Client_SYS.Add_To_Attr('N21', value_, temp_attr_);
         recalc_tax_ := TRUE;
      ELSIF (name_ = 'ORIGINAL_ORDER_DISCOUNT') THEN
         Client_SYS.Add_To_Attr('N22', value_, temp_attr_);
         recalc_tax_ := TRUE;
      -- gelr:disc_price_rounded, end     
      ELSIF (name_ = 'CHARGE_PERCENT_BASIS') THEN 
         Client_SYS.Add_To_Attr('N14', value_, temp_attr_);
         recalc_tax_ := Get_Recalc_Tax___(value_, to_char(oldrec_.charge_percent_basis));
      -- gelr:prepayment_tax_document, begin
      ELSIF (name_ = 'PREPAY_TAX_BASE_CURR_AMT') THEN
         Client_SYS.Add_To_Attr('PREPAY_TAX_BASE_CURR_AMT', value_, temp_attr_);
      ELSIF (name_ = 'PREPAY_TAX_CURR_AMOUNT') THEN
         Client_SYS.Add_To_Attr('PREPAY_TAX_CURR_AMOUNT', value_, temp_attr_);         
      -- gelr:prepayment_tax_document, end   
      END IF;
   END LOOP;
   item_attr_ := temp_attr_;
END Build_Item_Attr_String___;


-- Modify_Invoice_Item___
--   Calls Customer_Invoice_Pub_Util for modifying an invoice item.
PROCEDURE Modify_Invoice_Item___ (
   objid_ IN VARCHAR2,
   attr_  IN VARCHAR2 )
IS
   item_attr_                VARCHAR2(32000);
   currency_rounding_        NUMBER;
   discount_                 NUMBER;
   net_curr_amount_          NUMBER;
   vat_curr_amount_          NUMBER;
   dummy_attr_               VARCHAR2(2000);
   headrec_                  Customer_Order_Inv_Head_API.Public_Rec;
   qty_                      NUMBER;
   price_                    NUMBER;
   price_incl_tax_           NUMBER;
   charge_percent_           NUMBER;
   order_discount_           NUMBER;
   price_conv_               NUMBER;
   vat_code_                 VARCHAR2(20) := NULL;
   add_discount_             NUMBER;
   total_order_disc_         NUMBER;
   max_jinsui_amnt_          NUMBER;
   gross_amnt_               NUMBER;
   exist_tax_manual_         VARCHAR2(10);
   server_change_            VARCHAR2(10);
   creline_update_allow_     BOOLEAN :=FALSE;
   new_tax_manual_           BOOLEAN :=FALSE;
   man_tax_liab_date_        CUSTOMER_ORDER_INV_ITEM.man_tax_liability_date%TYPE;
   cor_inv_type_             VARCHAR2(20);
   col_inv_type_             VARCHAR2(20);
   advance_cr_inv_type_      VARCHAR2(20);
   advance_dr_inv_type_      VARCHAR2(20);
   reb_cre_inv_type_         VARCHAR2(20);
   debit_invoice_id_         NUMBER;
   debit_gross_curr_amount_  NUMBER;
   old_gross_curr_amount_    NUMBER;
   new_gross_curr_amount_    NUMBER;
   total_consumed_amount_    NUMBER;
   dummy_net_curr_amount_    NUMBER;
   dummy_vat_curr_amount_    NUMBER;
   fee_percentage_           NUMBER;
   cons_attr_                VARCHAR2(1000);
   allow_changes_            VARCHAR2(5);
   js_invoice_state_db_      VARCHAR2(3);
   rebate_cr_inv_type_       VARCHAR2(20);
   linerec_                  Customer_Order_Line_API.Public_Rec;
   qty_changed_              BOOLEAN;
   buy_qty_due_              NUMBER;
   delivery_type_            VARCHAR2(20);
   vat_free_vat_code_        VARCHAR2(20);
   temp_allocation_id_       NUMBER;
   tax_percentage_           NUMBER;
   tax_dom_amount_           NUMBER;
   tax_para_amount_          NUMBER;
   gross_curr_amount_        NUMBER;
   free_of_charge_tax_basis_ NUMBER;
   comp_bearing_tax_amt_     NUMBER;
   multiple_tax_             VARCHAR2(5);
   tax_msg_                  VARCHAR2(32000);
   prepay_cre_inv_type_      VARCHAR2(20);
   tax_calc_structure_id_    VARCHAR2(20);
   multiple_tax_lines_       VARCHAR2(20);
   dummy_tax_info_table_     Tax_Handling_Util_API.tax_information_table;
   base_for_adv_invoice_     VARCHAR2(25);
   gross_order_amount_       NUMBER;
   total_tax_amount_         NUMBER;
   gross_amt_incl_charges_   NUMBER; 
   tot_sale_charge_          NUMBER;
   tot_sale_charge_gross_    NUMBER; 
   price_changed_            BOOLEAN;
   fetch_tax_from_external_  BOOLEAN := FALSE;
   external_tax_calc_method_ VARCHAR2(50);
   consider_ext_tax_curr_amt_ BOOLEAN := FALSE;
   cust_tax_usage_type_       VARCHAR2(5); 
   cust_tax_roundng_level_  customer_tax_info_tab.tax_rounding_level%TYPE;
   charge_percent_basis_      NUMBER; 
   recalc_tax_               BOOLEAN;
   -- gelr:br_external_tax_integration, begin
   acquisition_origin_       NUMBER;
   statistical_code_         VARCHAR2(15);
   br_specific_changed_      BOOLEAN := FALSE;
   -- gelr:br_external_tax_integration, end

   -- gelr:prepayment_tax_document, added prepay_tax_document_id
   -- gelr:br_external_tax_integration, added acquisition_origin_, statistical_code_
   -- gelr:disc_price_rounded, added original_discount, original_add_discount, original_order_discount.
   CURSOR get_item_data IS
      SELECT company, order_no, reference, discount, order_discount, additional_discount,
             vat_code, tax_calc_structure_id, invoiced_qty, price_conv, invoice_id,invoice_type, man_tax_liability_date, contract,
             item_id, sale_unit_price, unit_price_incl_tax, line_no, release_no,line_item_no, prel_update_allowed,
             series_reference, number_reference, party_type, identity, net_curr_amount, vat_curr_amount,
             charge_percent, charge_percent_basis, gross_curr_amount, net_dom_amount, vat_dom_amount, 
             catalog_no, charge_seq_no, rma_no, objstate, deliv_type_id, allocation_id, rental_transaction_id,
             free_of_charge, free_of_charge_tax_basis, customer_tax_usage_type, original_discount, original_add_discount, original_order_discount,
             acquisition_origin, statistical_code, prepay_tax_document_id
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  OBJID = objid_;

   newrec_                  get_item_data%ROWTYPE;
   oldrec_                  get_item_data%ROWTYPE;
   
BEGIN
   OPEN get_item_data;
   FETCH get_item_data INTO oldrec_;
   IF (get_item_data%NOTFOUND) THEN
      Error_SYS.Record_Removed(lu_name_);
   END IF;
   CLOSE get_item_data;

   IF NOT (Customer_Order_Inv_Head_API.Get_Invoice_Status_Db(oldrec_.company, oldrec_.invoice_id) = 'Preliminary') THEN
      Error_SYS.Record_General(lu_name_,'NOTPRELINVOICE: Only invoices in state Preliminary can be changed.');
   END IF;
   -- Fetch the currency code from the invoice header
   headrec_           := Customer_Order_Inv_Head_API.Get(oldrec_.company, oldrec_.invoice_id);
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(oldrec_.company, headrec_.currency_code);
   
   IF Client_SYS.Item_Exist('CUSTOMER_TAX_USAGE_TYPE', attr_) THEN
      cust_tax_usage_type_ := Client_SYS.Get_Item_Value('CUSTOMER_TAX_USAGE_TYPE', attr_);
   END IF;
   IF ((NVL(cust_tax_usage_type_,' ') <> NVL(oldrec_.customer_tax_usage_type,' ')) AND (headrec_.objstate IN ('Posted','PostedAuth','PaidPosted','PartlyPaidPosted'))) THEN 
      Error_SYS.Record_General(lu_name_,'INVUPATENTALLOWED: Customer Tax Usage Type cannot be modified for Posted Invoices.'); 
   ELSIF ((NVL(cust_tax_usage_type_,' ') <> NVL(oldrec_.customer_tax_usage_type,' ')) AND (oldrec_.prel_update_allowed = 'FALSE')) THEN
      Error_SYS.Record_General(lu_name_,'CUPDATENTALLOWED: Customer Tax Usage Type can only be modified in debit lines in correction invoices.');
   END IF;

   IF Client_SYS.Item_Exist('SERVER_CHANGE', attr_) THEN
      server_change_ := Client_SYS.Get_Item_Value('SERVER_CHANGE', attr_);
   END IF;

   IF (oldrec_.prel_update_allowed = 'FALSE' AND server_change_ ='FALSE') THEN
      Error_SYS.Record_General(lu_name_,'UPDATENOTALLOWED: Credit lines cannot be modified. Only debit lines are allowed for modifying.');
   END IF;
   IF (oldrec_.rental_transaction_id IS NOT NULL AND server_change_ ='FALSE' AND headrec_.objstate = 'Preliminary') THEN 
      Error_SYS.Record_General(lu_name_,'RENTALNOTUPDATEABLE: Rental invoice lines cannot be updated on the invoice.');   
   END IF;
   
   IF (headrec_.invoice_type = Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(oldrec_.company) AND (NOT Client_SYS.Item_Exist('MAN_TAX_LIABILITY_DATE', attr_) AND (NOT Client_SYS.Item_Exist('INVOICE_TEXT', attr_)))) THEN
     Error_SYS.Record_General(lu_name_,'PREPAYDEBNOUPDATE: Prepayment based debit invoice line information cannot be modified except for the tax liability date.');
   END IF;

   Trace_SYS.Field('attr', attr_);
   Build_Item_Attr_String___(recalc_tax_, item_attr_, oldrec_.company, headrec_.currency_code, attr_, objid_);

   -- fetch modified values
   discount_       := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('DISCOUNT', attr_));
   order_discount_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ORDER_DISCOUNT', attr_));
   add_discount_   := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ADDITIONAL_DISCOUNT', attr_));

   IF (oldrec_.order_no IS NULL) AND (order_discount_ != 0) THEN
      Error_SYS.Record_General(lu_name_, 'NOORDDISC: Order Discount may not be used when the invoice line has no order connection');
   END IF;
   charge_percent_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('CHARGE_PERCENT', attr_));
   price_          := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SALE_UNIT_PRICE', attr_));
   price_incl_tax_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('UNIT_PRICE_INCL_TAX', attr_));
   IF (oldrec_.free_of_charge = 'TRUE') THEN
      IF (NVL(price_, 0) != 0 OR NVL(price_incl_tax_, 0) != 0) THEN 
         Error_SYS.Record_General(lu_name_, 'CANTCHGPRICE: Price information cannot be modified for free of charge lines.');     
      END IF;
   END IF;
   
   IF (charge_percent_ IS  NULL) AND (NVL(price_,oldrec_.sale_unit_price) IS NULL) AND (NVL(price_incl_tax_,oldrec_.unit_price_incl_tax) IS NULL)THEN 
      charge_percent_ := NVL(charge_percent_, oldrec_.charge_percent);
   END IF;
   price_changed_ := (NVL(charge_percent_, oldrec_.charge_percent) != oldrec_.charge_percent) OR 
                     (NVL(price_,oldrec_.sale_unit_price) != oldrec_.sale_unit_price);
   
   IF (charge_percent_ IS NOT NULL) THEN
      price_ := charge_percent_ * oldrec_.charge_percent_basis / 100;
      price_incl_tax_ := charge_percent_ * oldrec_.charge_percent_basis / 100;
   END IF;
   
   -- fetch modified quantity
   qty_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('INVOICED_QTY', attr_));
   IF (qty_ IS NULL) THEN
      qty_ := oldrec_.invoiced_qty;
   ELSE
      qty_changed_ := qty_ != oldrec_.invoiced_qty;
   END IF;

   advance_cr_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Cr_Inv_Type(oldrec_.company);
   rebate_cr_inv_type_  := NVL(Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(oldrec_.company), 'COREBCRE');
   IF (headrec_.invoice_type IN ('CUSTORDCRE', 'CUSTCOLCRE', 'SELFBILLCRE', advance_cr_inv_type_, rebate_cr_inv_type_)) THEN
      qty_ := qty_ * -1;
   END IF;
   
   price_conv_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('PRICE_CONV', attr_));

   -- Discount may not be larger than 100
   IF (discount_ > 100) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISC: The total discount given cannot exceed the invoice line price.');
   END IF;

   -- Total order discount may not ben larger than 100
   total_order_disc_ := order_discount_ + add_discount_;
   IF total_order_disc_ > 100 THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDTOTDIS: Total Order Discount should not exceed 100!');
   END IF;

   IF recalc_tax_ then
      IF (Client_SYS.Item_Exist('VAT_CODE',attr_)) THEN
         vat_code_ := Client_SYS.Get_Item_Value('VAT_CODE', attr_);
         IF (Is_Manual_Liablty_Taxcode(oldrec_.company,vat_code_,headrec_.invoice_type) ='TRUE') THEN
            new_tax_manual_ := TRUE;
         ELSE
            Client_SYS.Set_Item_Value('MAN_TAX_LIABILITY_DATE', Client_Sys.Attr_Value_To_Date(NULL), item_attr_);
         END IF;
      ELSE 
         delivery_type_ :=  Client_SYS.Get_Item_Value('DELIV_TYPE_ID', attr_);         
         IF  (Client_SYS.Item_Exist('DELIV_TYPE_ID',attr_)) AND (NVL(oldrec_.deliv_type_id, Database_SYS.string_null_) != NVL(delivery_type_, Database_SYS.string_null_))
             AND (headrec_.invoice_type IN ('CUSTORDDEB', 'CUSTCOLDEB')) THEN      
            IF (Customer_Order_Charge_API.Get_Conn_Tax_Liability_Type_Db(oldrec_.order_no, oldrec_.charge_seq_no) = 'EXM') OR (Customer_Order_Charge_API.Get_Conn_Tax_Liability_Type_Db(oldrec_.order_no, oldrec_.line_no, oldrec_.release_no, oldrec_.line_item_no, NULL, NULL) = 'EXM') THEN   
               vat_free_vat_code_ := Customer_Tax_Free_Tax_Code_API.Get_Tax_Free_Tax_Code(headrec_.delivery_identity, headrec_.delivery_address_id, oldrec_.company, headrec_.supply_country, NVL(delivery_type_, '*'));    
               IF (vat_free_vat_code_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'NOTAXFREECODE: A tax liability with Exempt liability type is used for this invoice line but Tax Free Tax Code is missing.');
               ELSE
                  Client_SYS.Set_Item_Value('VAT_CODE', vat_free_vat_code_, item_attr_);            
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   cor_inv_type_        := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(oldrec_.company);
   col_inv_type_        := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(oldrec_.company);
   reb_cre_inv_type_    := Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(oldrec_.company);
   advance_dr_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Dr_Inv_Type(oldrec_.company);
   prepay_cre_inv_type_ := NVL(Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type(oldrec_.company), 'COPREPAYCRE');

   IF (Client_SYS.Item_Exist('MAN_TAX_LIABILITY_DATE',attr_) AND recalc_tax_) THEN
      man_tax_liab_date_ := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('MAN_TAX_LIABILITY_DATE', attr_));
      exist_tax_manual_  := Has_Manual_Tax_Liablty_Lines(oldrec_.company, oldrec_.invoice_id, oldrec_.item_id, headrec_.invoice_type);
      IF (oldrec_.prel_update_allowed = 'TRUE') THEN
         IF (vat_code_ IS NOT NULL AND new_tax_manual_ = FALSE) THEN
            Client_SYS.Set_Item_Value('MAN_TAX_LIABILITY_DATE', Client_Sys.Attr_Value_To_Date(NULL), item_attr_);
            creline_update_allow_ := FALSE;
            -- Skip the error message when exist and new tax manual dates are FALSE
            new_tax_manual_ := TRUE;
         ELSIF (headrec_.invoice_type IN (cor_inv_type_, col_inv_type_)) THEN
            creline_update_allow_ := TRUE;
         END IF;
      END IF;
      IF (exist_tax_manual_ = 'FALSE' AND new_tax_manual_ = FALSE ) THEN
         Error_SYS.Record_General(lu_name_, 'MANUALUPDATENOTALLO: Tax Liability Date cannot be modified when the tax code is not defined with Tax Liability Date type as Manual.');
      END IF;
   END IF;
   IF (Client_SYS.Item_Exist('VAT_CODE',attr_)) THEN
      vat_code_ := Client_SYS.Get_Item_Value('VAT_CODE', attr_);
   ELSE
      vat_code_ := oldrec_.vat_code;
   END IF;
   IF (Client_SYS.Item_Exist('TAX_CALC_STRUCTURE_ID',attr_)) THEN
      tax_calc_structure_id_ := Client_SYS.Get_Item_Value('TAX_CALC_STRUCTURE_ID', attr_);
   ELSE
      tax_calc_structure_id_ := oldrec_.tax_calc_structure_id;
   END IF;
   
   multiple_tax_lines_  := Client_SYS.Get_Item_Value('MULTIPLE_TAX_LINES', attr_);
   IF (vat_code_ IS NULL) AND (tax_calc_structure_id_ IS NULL)       
      AND (multiple_tax_lines_ IS NOT NULL) AND (multiple_tax_lines_ = 'FALSE') THEN
      
      -- Set tax_info_table_ parameter to NULL (dummy_tax_info_table_) to remove tax lines
      Tax_Handling_Util_API.Create_Tax_Message(tax_msg_, oldrec_.company, NULL, dummy_tax_info_table_);      
      Source_Tax_Item_Invoic_API.Create_Tax_Items_From_Msg(oldrec_.company, 
                                                           Tax_Source_API.DB_INVOICE, 
                                                           To_CHAR(oldrec_.invoice_id), 
                                                           To_CHAR(oldrec_.item_id), 
                                                           '*', 
                                                           '*', 
                                                           '*', 
                                                           tax_msg_);
   END IF;
   
   buy_qty_due_              := Customer_Order_Line_API.Get_Buy_Qty_Due(oldrec_.order_no, oldrec_.line_no, oldrec_.release_no, oldrec_.line_item_no);   
   IF (oldrec_.free_of_charge = 'TRUE') THEN
      IF (Client_SYS.Item_Exist('FREE_OF_CHARGE_TAX_BASIS', attr_)) THEN
         free_of_charge_tax_basis_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('FREE_OF_CHARGE_TAX_BASIS', attr_));
         Client_SYS.Set_Item_Value('N19', free_of_charge_tax_basis_, item_attr_);
      ELSIF qty_changed_ THEN
         free_of_charge_tax_basis_ := Customer_Order_Line_API.Get_Free_Of_Charge_Tax_Basis(oldrec_.order_no, oldrec_.line_no, oldrec_.release_no, oldrec_.line_item_no);
         free_of_charge_tax_basis_ := ROUND((free_of_charge_tax_basis_/ buy_qty_due_) * qty_, currency_rounding_);
         Client_SYS.Set_Item_Value('N19', free_of_charge_tax_basis_, item_attr_);
      ELSE
         free_of_charge_tax_basis_ := oldrec_.free_of_charge_tax_basis;
      END IF;
   END IF;

   -- gelr:disc_price_rounded, begin
   external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(oldrec_.company);
   IF (headrec_.invoice_type NOT IN (advance_cr_inv_type_, advance_dr_inv_type_ )) THEN 
      consider_ext_tax_curr_amt_ := (external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED);
   END IF;
   -- gelr:disc_price_rounded, end

   -- gelr:br_external_tax_integration, begin
   IF external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL THEN
      IF Client_SYS.Item_Exist('ACQUISITION_ORIGIN', attr_) THEN
         acquisition_origin_ := Client_SYS.Get_Item_Value('ACQUISITION_ORIGIN', attr_);
         br_specific_changed_ := TRUE;
      END IF;
      IF Client_SYS.Item_Exist('STATISTICAL_CODE', attr_) THEN
         statistical_code_ := Client_SYS.Get_Item_Value('STATISTICAL_CODE', attr_);
         br_specific_changed_ := TRUE;
      END IF;
   END IF;
   -- gelr:br_external_tax_integration, end
   
   -- NULL is sent as discount_. Discount amount is calculated in Calculate_Line_Amounts___()
   -- Calculate the net curr amount and vat curr amount
   IF (headrec_.invoice_type != prepay_cre_inv_type_) THEN
      -- gelr:br_external_tax_integration, added br_specific_changed_
      -- gelr:disc_price_rounded, replaced (external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) with consider_ext_tax_curr_amt_
      fetch_tax_from_external_  := (consider_ext_tax_curr_amt_) AND (qty_changed_ OR price_changed_ OR (cust_tax_usage_type_ IS NOT NULL AND (cust_tax_usage_type_ != NVL(oldrec_.customer_tax_usage_type,' '))) OR br_specific_changed_);
      -- gelr:br_external_tax_integration, added acquisition_origin_, statistical_code_
      Calculate_Line_And_Tax_Amts___(tax_percentage_ , multiple_tax_, vat_curr_amount_, tax_dom_amount_ , tax_para_amount_,
                                     gross_curr_amount_, net_curr_amount_, tax_msg_, vat_code_, tax_calc_structure_id_,
                                     oldrec_.company, oldrec_.invoice_id, oldrec_.item_id,
                                     oldrec_.identity, oldrec_.contract, headrec_.invoice_type, Party_Type_API.Encode(oldrec_.party_type),
                                     oldrec_.catalog_no, oldrec_.deliv_type_id, qty_, buy_qty_due_,
                                     NVL(price_incl_tax_, oldrec_.unit_price_incl_tax), NVL(price_, oldrec_.sale_unit_price),
                                     NULL, NVL(order_discount_, oldrec_.order_discount), NVL(add_discount_, oldrec_.additional_discount),
                                     NVL(price_conv_, oldrec_.price_conv), currency_rounding_, headrec_.use_price_incl_tax, free_of_charge_tax_basis_, fetch_tax_from_external_, consider_ext_tax_curr_amt_, 
                                     cust_tax_usage_type_, acquisition_origin_, statistical_code_);
                                     
      IF (Invoice_Customer_Order_API.Check_Tax_Dom_Amount_Editable(oldrec_.company, vat_code_, headrec_.currency_code, headrec_.objstate, multiple_tax_, headrec_.invoice_type) = 'TRUE' AND NVL(tax_dom_amount_,0) != NVL(Client_SYS.Get_Item_Value_To_Number('VAT_DOM_AMOUNT',item_attr_,lu_name_),0)) THEN                                                               
         Invoice_Customer_Order_API.Override_Self_Bill_Tax_Dom__(tax_msg_,
                                                                 tax_dom_amount_,
                                                                 oldrec_.company,
                                                                 oldrec_.invoice_id,
                                                                 vat_code_,
                                                                 oldrec_.identity,
                                                                 net_curr_amount_,
                                                                 vat_curr_amount_,
                                                                 NVL(Client_SYS.Get_Item_Value_To_Number('VAT_DOM_AMOUNT',item_attr_,lu_name_),0),
                                                                 tax_percentage_);
      END IF;
   END IF;
   
   base_for_adv_invoice_   := Company_Order_Info_API.Get_Base_For_Adv_Invoice_Db(oldrec_.company);
   gross_order_amount_     := Customer_Order_API.Get_Ord_Gross_Amount(oldrec_.order_no);
   gross_amt_incl_charges_ := Customer_Order_API.Get_Gross_Amt_Incl_Charges(oldrec_.order_no);
   tot_sale_charge_        := Customer_Order_API.Get_Total_Sale_Charge__(oldrec_.order_no);
   tot_sale_charge_gross_  := Customer_Order_API.Get_Total_Sale_Charge_Gross__(oldrec_.order_no);
   total_tax_amount_       := Customer_Order_API.Get_Ord_Tax_Amt_Excl_Item__(oldrec_.order_no);
   
   IF (headrec_.invoice_type = advance_dr_inv_type_ AND base_for_adv_invoice_ = 'NET AMOUNT' AND (net_curr_amount_ - tot_sale_charge_) > (gross_order_amount_ - total_tax_amount_)) THEN
         Error_SYS.Record_General(lu_name_, 'ADVINVEXCEED: Advance Invoice value cannot exceed the customer order value.');
   END IF;
   IF (headrec_.invoice_type = advance_dr_inv_type_ AND base_for_adv_invoice_ = 'GROSS AMOUNT' AND (gross_curr_amount_ - tot_sale_charge_gross_) > gross_order_amount_ )THEN
         Error_SYS.Record_General(lu_name_, 'ADVINVEXCEED: Advance Invoice value cannot exceed the customer order value.');
   END IF;
   IF (headrec_.invoice_type = advance_dr_inv_type_ AND base_for_adv_invoice_ = 'NET AMOUNT WITH CHARGES' AND net_curr_amount_  > (gross_order_amount_ - total_tax_amount_ + tot_sale_charge_)) THEN
         Error_SYS.Record_General(lu_name_, 'ADVINVEXCEED: Advance Invoice value cannot exceed the customer order value.');
   END IF;  
   IF (headrec_.invoice_type = advance_dr_inv_type_ AND base_for_adv_invoice_ = 'GROSS AMOUNT WITH CHARGES' AND (net_curr_amount_ + vat_curr_amount_) > gross_amt_incl_charges_) THEN
         Error_SYS.Record_General(lu_name_, 'ADVINVEXCEED: Advance Invoice value cannot exceed the customer order value.');
   END IF;

   IF (oldrec_.invoice_type IN('CUSTORDDEB','CUSTCOLDEB',cor_inv_type_, col_inv_type_,'CUSTORDCRE','CUSTCOLCRE',reb_cre_inv_type_, advance_dr_inv_type_, advance_cr_inv_type_))THEN
      IF (multiple_tax_ = 'TRUE') THEN
         tax_percentage_ := Source_Tax_Item_API.Get_Total_Tax_Percentage (oldrec_.company,
                                                                          Tax_Source_API.DB_INVOICE,
                                                                          To_CHAR(oldrec_.invoice_id),
                                                                          To_CHAR(oldrec_.item_id),
                                                                          '*',
                                                                          '*',
                                                                          '*');
      ELSE
         tax_percentage_ := NVL(tax_percentage_,0);  
      END IF;
      IF (free_of_charge_tax_basis_ IS NOT NULL) THEN
         IF (Customer_Order_API.Get_Free_Of_Chg_Tax_Pay_Par_Db(oldrec_.order_no) = Tax_Paying_Party_API.DB_COMPANY) THEN
            comp_bearing_tax_amt_ := tax_dom_amount_;
            vat_curr_amount_      := 0;
            tax_dom_amount_       := 0; 
            tax_para_amount_      := 0; 
         END IF;
         net_curr_amount_ := 0;             
      END IF;
      Client_SYS.Set_Item_Value('N18', comp_bearing_tax_amt_, item_attr_);
      Client_SYS.Set_Item_Value('VAT_DOM_AMOUNT', tax_dom_amount_, item_attr_);
      Client_SYS.Set_Item_Value('VAT_PARALLEL_AMOUNT', tax_para_amount_, item_attr_);

   END IF;  
   -- gelr:prepayment_tax_document, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(oldrec_.company, 'PREPAYMENT_TAX_DOCUMENT') = Fnd_Boolean_API.DB_TRUE AND 
      (oldrec_.invoice_type IN (Company_Def_Invoice_Type_API.Get_Def_Co_Tax_Doc_Type(oldrec_.company), Company_Def_Invoice_Type_API.Get_Def_Co_Cre_Tax_Doc_Type(oldrec_.company)) OR oldrec_.prepay_tax_document_id IS NOT NULL)) THEN
      net_curr_amount_ := 0;
      vat_curr_amount_ := 0;
   END IF;
   -- gelr:prepayment_tax_document, end
   IF (headrec_.invoice_type != NVL(Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(oldrec_.company), 'COPREPAYDEB')) THEN   
      Client_SYS.Set_Item_Value('NET_CURR_AMOUNT', net_curr_amount_, item_attr_);
      Client_SYS.Set_Item_Value('VAT_CURR_AMOUNT', vat_curr_amount_, item_attr_);
   END IF;
   
   -- Dummy call to change the status of package globals in Invoice
   Client_SYS.Add_To_Attr('COMPANY', oldrec_.company, dummy_attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', oldrec_.invoice_id, dummy_attr_);
   Customer_Invoice_Pub_Util_API.Modify_Invoice_Head(dummy_attr_, 'CUSTOMER_ORDER_INV_ITEM_API');

   Client_SYS.Add_To_Attr('REFERENCE', oldrec_.reference, item_attr_);
   Trace_SYS.Field('item_attr', item_attr_);

   IF (Invoice_API.Get_Prepay_Based_Inv_Db(oldrec_.company, oldrec_.invoice_id) = 'TRUE') THEN
      -- Only for prepayment based credit invoices
      IF (headrec_.invoice_type = prepay_cre_inv_type_) THEN
         old_gross_curr_amount_ := oldrec_.net_curr_amount + oldrec_.vat_curr_amount;
         old_gross_curr_amount_ := old_gross_curr_amount_ * -1;

         --new_gross_curr_amount_ := net_curr_amount_ + vat_curr_amount_;
         new_gross_curr_amount_ := Client_SYS.Get_Item_Value('GROSS_CURR_AMOUNT', attr_);
         new_gross_curr_amount_ := new_gross_curr_amount_  * -1;

         debit_invoice_id_ := Invoice_API.Get_Invoice_Id(oldrec_.company, oldrec_.identity,
                                                         oldrec_.party_type, oldrec_.series_reference,
                                                         oldrec_.number_reference, 'TRUE');
         IF (old_gross_curr_amount_ < new_gross_curr_amount_) THEN
            debit_gross_curr_amount_ := Get_Net_Curr_Amount(oldrec_.company, debit_invoice_id_, oldrec_.item_id, oldrec_.party_type, oldrec_.identity) +
                                        Get_Vat_Curr_Amount(oldrec_.company, debit_invoice_id_, oldrec_.item_id, oldrec_.party_type, oldrec_.identity);

            total_consumed_amount_ := Cust_Prepaym_Consumption_API.Get_Total_Consumed_Amount(oldrec_.company, debit_invoice_id_, oldrec_.item_id);

            -- If (Total consumed amount + modified extra gross amount) is greated than debit prepay gross amount, its wrong
            IF (debit_gross_curr_amount_ < (total_consumed_amount_ + (new_gross_curr_amount_ - old_gross_curr_amount_))) THEN
               Error_SYS.Record_General(lu_name_, 'CONSAMOUNTGREATER: Cannot exceed the amount to be consumed!');
            END IF;
         END IF; 
         Calc_Line_Amount_For_Prepay___(dummy_net_curr_amount_, 
                                        dummy_vat_curr_amount_, 
                                        fee_percentage_,
                                        tax_msg_,
                                        new_gross_curr_amount_, 
                                        oldrec_.company, 
                                        oldrec_.invoice_id, 
                                        oldrec_.item_id,
                                        NULL,
                                        NULL,
                                        oldrec_.vat_code,
                                        currency_rounding_,
                                        FALSE);                         

         Client_SYS.Set_Item_Value('NET_CURR_AMOUNT', NVL(dummy_net_curr_amount_ * -1, 0), item_attr_);
         Client_SYS.Set_Item_Value('VAT_CURR_AMOUNT', NVL(dummy_vat_curr_amount_ * -1, 0), item_attr_);

         Client_SYS.Clear_Attr(cons_attr_);
         Client_SYS.Add_To_Attr('CONSUMED_AMOUNT', NVL(new_gross_curr_amount_, 0), cons_attr_);

         Cust_Prepaym_Consumption_API.Modify(oldrec_.company,
                                             debit_invoice_id_,
                                             oldrec_.item_id,
                                             oldrec_.invoice_id,
                                             oldrec_.item_id,
                                             cons_attr_);
      END IF;
   END IF;

   IF (NVL(Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('NET_CURR_AMOUNT', item_attr_)), 0) != 0) AND
      (oldrec_.allocation_id IS NULL) AND (oldrec_.order_no IS NOT NULL) AND (oldrec_.line_no IS NOT NULL) AND
      (oldrec_.release_no IS NOT NULL) AND (oldrec_.line_item_no IS NOT NULL) THEN
         temp_allocation_id_ := Customer_Order_Line_API.Get_Allocation_Id(oldrec_.order_no, oldrec_.line_no, oldrec_.release_no, oldrec_.line_item_no);
         IF (temp_allocation_id_ IS NOT NULL) THEN
            Client_SYS.Set_Item_Value('ALLOCATION_ID', temp_allocation_id_, item_attr_);
         END IF;
   END IF;
   
   Client_SYS.Add_To_Attr('COMPANY', oldrec_.company, item_attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', oldrec_.invoice_id, item_attr_);
   Customer_Invoice_Pub_Util_API.Modify_Invoice_Item(item_attr_, 'CUSTOMER_ORDER_INV_ITEM_API');
   
   -- When fetch_tax_from_external_ is true Modify_Inv_Tax_Item___ is called inside Calculate_Line_And_Tax_Amts___
   IF (recalc_tax_ AND NOT fetch_tax_from_external_) THEN 
      Modify_Inv_Tax_Item___(oldrec_.company, 
                             oldrec_.invoice_id, 
                             oldrec_.item_id, 
                             tax_msg_,
                             oldrec_.identity);
   END IF;                          
                             
   OPEN get_item_data;
   FETCH get_item_data INTO newrec_;
   CLOSE get_item_data;
   
   -- gelr:disc_price_rounded, begin
   IF (Customer_Order_API.Get_Discounted_Price_Rounded(oldrec_.order_no)) THEN
      -- Recalculate order and additional discounts
      -- Data (discount) might be changed by Calculate_Discount__

      IF (oldrec_.sale_unit_price != newrec_.sale_unit_price) OR
         (oldrec_.invoiced_qty != newrec_.invoiced_qty) OR
         (oldrec_.discount != newrec_.discount) OR
         (oldrec_.original_order_discount != newrec_.original_order_discount) OR
         (NVL(oldrec_.original_add_discount, 0) != NVL(newrec_.original_add_discount, 0)) THEN

         -- original_order_discount may be modified from client 
         order_discount_ := Customer_Order_Pricing_API.Calculate_Additional_Discount(newrec_.contract,
                                                                                  headrec_.currency_code,
                                                                                  newrec_.original_order_discount,
                                                                                  newrec_.invoiced_qty,
                                                                                  newrec_.price_conv,
                                                                                  newrec_.sale_unit_price,
                                                                                  newrec_.discount);

         -- original_add_discount may be modified from client
         add_discount_ := Customer_Order_Pricing_API.Calculate_Additional_Discount(newrec_.contract,
                                                                                headrec_.currency_code,
                                                                                newrec_.original_add_discount,
                                                                                newrec_.invoiced_qty,
                                                                                newrec_.price_conv,
                                                                                newrec_.sale_unit_price,
                                                                                newrec_.discount);
         fetch_tax_from_external_   := (consider_ext_tax_curr_amt_) AND (qty_changed_ OR price_changed_);

         -- pass the NULL as discount. line_discount_amount_ should be calculated again inside Calculate_Line_Amounts___ by Get_Total_Line_Discount
         Calculate_Line_And_Tax_Amts___(tax_percentage_ , multiple_tax_, vat_curr_amount_, tax_dom_amount_ , tax_para_amount_,
                                        gross_curr_amount_, net_curr_amount_, tax_msg_, vat_code_, tax_calc_structure_id_,
                                        oldrec_.company, oldrec_.invoice_id, oldrec_.item_id,
                                        oldrec_.identity, oldrec_.contract, headrec_.invoice_type, Party_Type_API.Encode(oldrec_.party_type),
                                        oldrec_.catalog_no, oldrec_.deliv_type_id, qty_, buy_qty_due_,
                                        NVL(price_incl_tax_, oldrec_.unit_price_incl_tax), NVL(price_, oldrec_.sale_unit_price),
                                        NULL, NVL(order_discount_, oldrec_.order_discount), NVL(add_discount_, oldrec_.additional_discount),
                                        NVL(price_conv_, oldrec_.price_conv), currency_rounding_, headrec_.use_price_incl_tax, free_of_charge_tax_basis_, fetch_tax_from_external_, consider_ext_tax_curr_amt_, cust_tax_usage_type_);   
         Client_SYS.Clear_Attr(item_attr_);
         Client_SYS.Add_To_Attr('COMPANY',               oldrec_.company,     item_attr_);
         Client_SYS.Add_To_Attr('INVOICE_ID',            oldrec_.invoice_id,  item_attr_);
         Client_SYS.Add_To_Attr('REFERENCE',             oldrec_.reference,   item_attr_);
         Client_SYS.Add_To_Attr('N6',                    order_discount_,     item_attr_);
         Client_SYS.Add_To_Attr('N12',                   add_discount_,       item_attr_);
         IF (headrec_.invoice_type != NVL(Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(oldrec_.company), 'COPREPAYDEB')) THEN
            Client_SYS.Add_To_Attr('NET_CURR_AMOUNT',       net_curr_amount_,    item_attr_);
            Client_SYS.Add_To_Attr('VAT_CURR_AMOUNT',       vat_curr_amount_,    item_attr_);
         END IF;
         Customer_Invoice_Pub_Util_API.Modify_Invoice_Item(item_attr_, 'CUSTOMER_ORDER_INV_ITEM_API');
         -- read the data again
         OPEN get_item_data;
         FETCH get_item_data INTO newrec_;
         CLOSE get_item_data;
      END IF;
   END IF;
   -- gelr:disc_price_rounded, end
   
   gross_amnt_ := abs(net_curr_amount_) + vat_curr_amount_;

   $IF (Component_Jinsui_SYS.INSTALLED) $THEN 
       max_jinsui_amnt_ := Js_Company_Info_API.Get_Virtual_Inv_Max_Amount(oldrec_.company);
       allow_changes_   := Js_Customer_Info_API.Get_Allow_Changes_To_Prel_Inv(oldrec_.company, headrec_.customer_no); 
       
      IF Invoice_Api.Is_Jinsui_Invoice(oldrec_.company,oldrec_.invoice_id) THEN
         IF (gross_amnt_ > max_jinsui_amnt_) THEN
            Error_SYS.Record_General(lu_name_, 'WRONGGROSSAMNT: Invoice gross amount cannot be greater than the Maximum Amount for Jinsui Transfer Batch :P1 for company :P2.' ,max_jinsui_amnt_ , oldrec_.company);
         END IF;
      END IF;       
   $END 

   allow_changes_       := NVL(allow_changes_, 'TRUE');
   js_invoice_state_db_ := Invoice_API.Get_Js_Invoice_State_Db(oldrec_.company, oldrec_.invoice_id);
   IF (js_invoice_state_db_ IN ('RJS','UJS')) THEN
      Error_SYS.Record_General(lu_name_, 'JINSUINOTOPEN: Jinsui invoices in state Ready For Transfer and Updated may not be changed.');
   ELSIF (js_invoice_state_db_ = 'TJS' AND allow_changes_ = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'JINSUICHANGE: Jinsui invoices in state Transferred cannot be changed when Allow Changes to Transferred Jinsui Invoices option is not selected for the company.');
   END IF;
 
   cust_tax_roundng_level_ := Customer_Tax_Info_API.Get_Tax_Rounding_Level_Db(headrec_.customer_no, headrec_.delivery_address_id, newrec_.company);
   
   IF (oldrec_.sale_unit_price     != newrec_.sale_unit_price) OR
      (oldrec_.unit_price_incl_tax != newrec_.unit_price_incl_tax) OR
      (oldrec_.invoiced_qty        != newrec_.invoiced_qty) OR
      (oldrec_.discount            != newrec_.discount) OR
      (oldrec_.vat_code            != newrec_.vat_code) OR
      (oldrec_.order_discount      != newrec_.order_discount) OR
      (oldrec_.net_dom_amount      != newrec_.net_dom_amount) OR
      ((oldrec_.vat_dom_amount      != newrec_.vat_dom_amount) AND 
      (cust_tax_roundng_level_ = 'TOTAL_LEVEL') AND 
      ((oldrec_.vat_dom_amount - newrec_.vat_dom_amount) >= 1)) OR
      (oldrec_.net_curr_amount     != newrec_.net_curr_amount) OR
      (oldrec_.vat_curr_amount     != newrec_.vat_curr_amount) OR
      (oldrec_.gross_curr_amount   != newrec_.gross_curr_amount) OR
      (oldrec_.additional_discount != newrec_.additional_discount) THEN

      IF (oldrec_.sale_unit_price     != newrec_.sale_unit_price) OR
         (oldrec_.unit_price_incl_tax != newrec_.unit_price_incl_tax) OR
         (oldrec_.invoiced_qty        != newrec_.invoiced_qty) OR
         (oldrec_.discount            != newrec_.discount) THEN
         IF (Cust_Invoice_Item_Discount_API.Check_Manual_Rows(newrec_.company, newrec_.invoice_id, newrec_.item_id)) THEN
            Client_SYS.Add_Info(lu_name_, 'MANUAL: Manually entered discount exist. You may want to check the discount calculation.');
         END IF;
         Order_Line_Commission_API.Set_Order_Com_Lines_Changed(newrec_.order_no, newrec_.line_no, newrec_.release_no, newrec_.line_item_no);
         Order_Line_Commission_API.Set_Line_Exclude_Flag(newrec_.order_no, newrec_.line_no, newrec_.release_no, newrec_.line_item_no, 'TRUE');
         Cust_Invoice_Item_Discount_API.Calculate_Discount__(newrec_.company, newrec_.invoice_id, newrec_.item_id);
      END IF;
      Customer_Invoice_Pub_Util_API.Modify_Invoice_Complete('CUSTOMER_ORDER_INV_ITEM_API', newrec_.company, newrec_.invoice_id, TRUE);
      Modify_Invoice_Statistics(newrec_.company, newrec_.invoice_id, newrec_.item_id, FALSE);
      
      IF Fnd_Session_API.Is_Odp_Session THEN 
         IF oldrec_.invoice_type = 'CUSTORDDEB' THEN
            IF (Customer_Order_Inv_Item_API.Is_Prepaym_Lines_Exist(newrec_.company, newrec_.invoice_id) = 'TRUE' ) THEN
               Invoice_Customer_Order_API.Reconsume_Prepaym_Inv_Lines__(newrec_.company, newrec_.invoice_id, Customer_Order_Inv_Head_API.Get_Creators_Reference(oldrec_.company, oldrec_.invoice_id));
            END IF;
         END IF;	
      END IF;      
      
   END IF;

   linerec_ := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.release_no, newrec_.line_item_no);
   -- If revenue has changed and CO Line is project connected, refresh project revenue for CO Invoice Line
   IF ((oldrec_.sale_unit_price     != newrec_.sale_unit_price)     OR
       (oldrec_.unit_price_incl_tax != newrec_.unit_price_incl_tax) OR
       (oldrec_.invoiced_qty        != newrec_.invoiced_qty)        OR
       (oldrec_.discount            != newrec_.discount)            OR
       (oldrec_.order_discount      != newrec_.order_discount)) AND NVL(linerec_.activity_seq, 0) > 0 THEN
      
      Calculate_Prel_Revenue__(newrec_.company, newrec_.invoice_id, newrec_.item_id, linerec_.activity_seq);
   END IF;

   --Update the corresponding CRELINE Manual Tax Liability Date
   IF (creline_update_allow_) THEN
      Modify_Liab_Dt_Corrinv_Crel___(oldrec_.company, oldrec_.invoice_id, oldrec_.item_id, man_tax_liab_date_);      
   END IF;
   
   -- Fetched the final saved values after calculating the discount. Then net_curr_amount and gross_curr_amount will show the correct values.
   OPEN get_item_data;
   FETCH get_item_data INTO newrec_;
   CLOSE get_item_data;
   
   -- When there is an amount change, need to trigger the auto update of connected unit charge lines.
   IF (oldrec_.net_curr_amount != newrec_.net_curr_amount) OR (oldrec_.gross_curr_amount != newrec_.gross_curr_amount) THEN   
      IF ((newrec_.charge_seq_no IS NULL) AND (oldrec_.prel_update_allowed = 'TRUE') AND (headrec_.invoice_type NOT IN ('SELFBILLDEB', 'SELFBILLCRE'))) THEN
         IF (Customer_Order_Charge_API.Check_Connected_Unit_Charges(newrec_.order_no, newrec_.line_no, newrec_.release_no, newrec_.line_item_no) = 'TRUE') THEN           
            IF newrec_.invoiced_qty = 0 THEN
               charge_percent_basis_ := 0;
            ELSE   
               IF (Customer_Order_Inv_Head_API.Get_Use_Price_Incl_Tax_Db(oldrec_.company, oldrec_.invoice_id) = 'TRUE') THEN              
                  charge_percent_basis_ := abs(newrec_.gross_curr_amount)/newrec_.invoiced_qty;
               ELSE               
                  charge_percent_basis_ := abs(newrec_.net_curr_amount)/newrec_.invoiced_qty;
               END IF;
            END IF;   
            -- When invoiced qty, price or discount got changed connected charge lines needs to get auto updated.
            Modify_Charge_Item___(newrec_.company, newrec_.invoice_id, newrec_.order_no, newrec_.line_no, newrec_.release_no, newrec_.line_item_no, newrec_.invoiced_qty, charge_percent_basis_);
         END IF;   
      END IF;   
   END IF;
   
   IF (qty_changed_) THEN
      IF (newrec_.charge_seq_no IS NOT NULL) THEN
         IF (Customer_Order_Charge_API.Get_Unit_Charge_Db(newrec_.order_no, newrec_.charge_seq_no) = 'FALSE') AND (newrec_.charge_percent IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'CHARGEPERCENTONLY: Invoiced quantity cannot be updated for an invoice line referring to a % charge.');     
         END IF;                  
      END IF;  
   END IF; 
END Modify_Invoice_Item___;

PROCEDURE Modify_Charge_Item___ (
   company_              IN VARCHAR2,
   invoice_id_           IN NUMBER,
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   release_no_           IN VARCHAR2,
   line_item_no_         IN VARCHAR2,   
   invoiced_qty_         IN NUMBER,
   charge_percent_basis_ IN NUMBER )
IS
   charge_rec_    Customer_Order_Charge_API.Public_Rec;
   attr_          VARCHAR2(32000);
   
   CURSOR get_charge_item_data IS
      SELECT objid, charge_seq_no, prel_update_allowed, charge_percent
      FROM   customer_order_inv_item coi
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    release_no = release_no_
      AND    line_item_no = line_item_no_
      AND    charge_seq_no IS NOT NULL
      AND EXISTS ( SELECT 1 
                   FROM   Customer_Order_Charge_tab coc 
                   WHERE  coc.order_no = coi.order_no 
                   AND    coc.sequence_no = coi.charge_seq_no 
                   AND    coc.unit_charge = 'TRUE' );
BEGIN
   -- Update all connected charge lines.
   FOR rec_ IN get_charge_item_data LOOP
      Client_SYS.Clear_Attr(attr_);
      IF (rec_.charge_percent IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('CHARGE_PERCENT_BASIS', charge_percent_basis_, attr_);
         Client_SYS.Add_To_Attr('SALE_UNIT_PRICE', (rec_.charge_percent * charge_percent_basis_/100), attr_);
         Client_SYS.Add_To_Attr('UNIT_PRICE_INCL_TAX', (rec_.charge_percent * charge_percent_basis_/100), attr_);
      END IF;   
      Client_SYS.Add_To_Attr('INVOICED_QTY', invoiced_qty_, attr_);
      
      charge_rec_ := Customer_Order_Charge_API.Get(order_no_, rec_.charge_seq_no);      
      IF (Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(charge_rec_.contract, charge_rec_.charge_type) = 'OTHER') AND
         (rec_.prel_update_allowed = 'TRUE') THEN
         Modify_Invoice_Item___(rec_.objid, attr_);
      END IF;   
   END LOOP; 
END Modify_Charge_Item___;

-- Cancel_Prelim_Item___
--   Calls Customer_Invoice_Pub_Util for cancellation.
PROCEDURE Cancel_Prelim_Item___ (
   attr_ IN VARCHAR2 )
IS
   temp_attr_ VARCHAR2(2000);
BEGIN
   temp_attr_ := attr_;
   Customer_invoice_Pub_Util_API.Cancel_Prelim_Item(temp_attr_, 'CUSTOMER_ORDER_INV_ITEM_API');
END Cancel_Prelim_Item___;


-- Complete_Check_Accounting___
--   Checks the code string and returns an error message if it went wrong.
PROCEDURE Complete_Check_Accounting___ (
   account_err_desc_ OUT VARCHAR2,
   company_          IN  VARCHAR2,
   voucher_date_     IN  DATE,
   str_code_         IN  VARCHAR2,
   codestr_rec_      IN  OUT Accounting_Codestr_API.CodestrRec)
IS
   user_group_      VARCHAR2(30);
   accounting_error EXCEPTION;
   pragma           exception_init(accounting_error, -20105);
BEGIN

   user_group_ := NVL(App_Context_SYS.Find_Value('CUSTOMER_ORDER_INV_ITEM_API.user_group_'), User_Group_Member_Finance_API.Get_Default_Group(company_, Fnd_Session_API.Get_Fnd_User));
   Accounting_Codestr_API.Complete_Codestring(codestr_rec_, company_,
                                              str_code_, voucher_date_);
   codestr_rec_.text := 'DUMMY';
   Accounting_Codestr_API.Validate_Codestring(codestr_rec_, company_,
                                              voucher_date_, user_group_);

   account_err_desc_ := NULL;
EXCEPTION
   WHEN accounting_error THEN
      account_err_desc_ := substr(sqlerrm, instr(sqlerrm, ':') + 1, 2000);
END Complete_Check_Accounting___;


-- Create_Credit_Invoice_Item___
--   Creates Invoice Item for the correction/credit invoices in module INVOICE.
--   The debit type line in the correction invoice is also handled from this method.
--   This will also handle the taxes, discounts for the invoice line.
PROCEDURE Create_Credit_Invoice_Item___ (
   item_rec_              IN    Public_Rec,
   cre_invoice_id_        IN    NUMBER,
   line_type_             IN    VARCHAR2,
   use_ref_inv_curr_rate_ IN VARCHAR2)
IS
   credit_head_rec_           Customer_Order_Inv_Head_API.Public_Rec;
   temp_item_id_              CUSTOMER_ORDER_INV_ITEM.item_id%TYPE;
   item_id_                   CUSTOMER_ORDER_INV_ITEM.item_id%TYPE;
   invoiced_qty_              NUMBER;
   rma_line_no_               NUMBER;
   rma_no_                    NUMBER;
   invoice_qty_count_         NUMBER;
   invoice_rec_               Customer_Order_Inv_Head_API.Public_Rec;
   cor_inv_type_              VARCHAR2(20);
   col_inv_type_              VARCHAR2(20);
   rent_trans_id_             NUMBER;   
   tmp_rent_trans_id_         NUMBER;
   transaction_type_          VARCHAR2(20);
   line_rec_                  Customer_Order_Line_API.Public_Rec;
   new_qty_invoiced_          NUMBER;
   recreated_invoiceable_db_  VARCHAR2(5);
   refresh_curr_rate_         VARCHAR2(5) := 'TRUE'; 
   recalc_tax_amnt_           VARCHAR2(5) := 'FALSE';
BEGIN
   IF (use_ref_inv_curr_rate_ = 'TRUE') THEN
      refresh_curr_rate_ := 'FALSE';   
   END IF;
   -- Update the RMA line details for both debit and credit type lines
   credit_head_rec_ := Customer_Order_Inv_Head_API.Get(item_rec_.company, cre_invoice_id_);
   rma_no_          := credit_head_rec_.rma_no;
   cor_inv_type_    := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(item_rec_.company);
   col_inv_type_    := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(item_rec_.company);
   line_rec_        := Customer_Order_Line_API.Get(item_rec_.order_no, item_rec_.line_no, item_rec_.release_no, item_rec_.line_item_no);
   
   IF (rma_no_ IS NOT NULL) THEN
      invoice_rec_     := Customer_Order_Inv_Head_API.Get(item_rec_.company, item_rec_.invoice_id);
      rma_line_no_ := Return_Material_Line_API.Get_Inv_Connected_Rma_Line_No(rma_no_,
                                                                            item_rec_.company,
                                                                            invoice_rec_.invoice_no,
                                                                            item_rec_.item_id,
                                                                            invoice_rec_.series_id);
      IF (credit_head_rec_.invoice_type IN (cor_inv_type_, col_inv_type_)) THEN
         IF rma_line_no_ IS NULL THEN
            -- charge lines will be ignored in correction invoices created from RMA.
            -- No need to update the RMA no connection for charge lines.
            rma_no_ := NULL;
         END IF;
      END IF;
   END IF;

   IF line_type_ = 'DEBIT' THEN
      -- if this correction invoice line created from RMA reduce the returned qty
      invoiced_qty_ := item_rec_.invoiced_qty - NVL(Return_Material_Line_API.Get_Qty_To_Return(rma_no_,rma_line_no_),0);
      IF (item_rec_.rental_transaction_id IS NULL AND invoiced_qty_ <0) THEN
         Error_SYS.Record_General(lu_name_, 'NEGATIVEQTYCORR: The correction invoice cannot be created as the quantity to return is greater than quantity on debit line :P1 - :P2.', invoice_rec_.invoice_no, item_rec_.item_id);
      END IF;
      invoice_qty_count_ := invoiced_qty_;
   ELSE
      invoice_qty_count_ := item_rec_.invoiced_qty * -1;
      IF credit_head_rec_.invoice_type IN (cor_inv_type_, col_inv_type_) THEN
         -- for correction iinvoices the CREDIT line must have a negative quantity
         invoiced_qty_ := item_rec_.invoiced_qty * (-1);
      ELSE
         -- for credit iinvoices the CREDIT line must have a positive quantity
         invoiced_qty_ := item_rec_.invoiced_qty;
      END IF;
   END IF;
   
   rent_trans_id_ := item_rec_.rental_transaction_id;
   
   IF (rent_trans_id_ IS NOT NULL )THEN
      $IF Component_Rental_SYS.INSTALLED $THEN      
         IF (credit_head_rec_.invoice_type IN ('CUSTORDCRE', 'CUSTCOLCRE')) THEN
            IF (line_rec_.rowstate = 'Invoiced') THEN
               recreated_invoiceable_db_ := Fnd_Boolean_API.DB_TRUE;
            ELSE
               recreated_invoiceable_db_ := Fnd_Boolean_API.DB_FALSE;
            END IF;
            
            Rental_Transaction_Manager_API.Generate_Debit_Credit_Trans(rent_trans_id_, 
                                                                       Rental_Transaction_Type_API.DB_DURATION_CREDIT,
                                                                       Fnd_Boolean_API.DB_TRUE, 
                                                                       TRUE,
                                                                       credit_head_rec_.fin_curr_rate, 
                                                                       credit_head_rec_.div_factor); 
            tmp_rent_trans_id_ := rent_trans_id_;
            rent_trans_id_     := item_rec_.rental_transaction_id;
            Rental_Transaction_Manager_API.Generate_Debit_Credit_Trans(rent_trans_id_, 
                                                                       Rental_Transaction_Type_API.DB_RECREATED,
                                                                       recreated_invoiceable_db_, 
                                                                       FALSE,
                                                                       credit_head_rec_.fin_curr_rate, 
                                                                       credit_head_rec_.div_factor);
            Rental_Transaction_API.Modify_Ref_Transaction_Id(tmp_rent_trans_id_, rent_trans_id_);
         ELSIF (credit_head_rec_.invoice_type IN ('CUSTORDCOR', 'CUSTCOLCOR')) THEN
            IF (line_type_ = 'DEBIT') THEN
               transaction_type_ := Rental_Transaction_Type_API.DB_RECREATED;
            ELSE
               transaction_type_ := Rental_Transaction_Type_API.DB_DURATION_CREDIT;                  
            END IF;
            Rental_Transaction_Manager_API.Generate_Debit_Credit_Trans(rent_trans_id_,
                                                                       transaction_type_,
                                                                       Fnd_Boolean_API.DB_TRUE, 
                                                                       TRUE, 
                                                                       credit_head_rec_.fin_curr_rate, 
                                                                       credit_head_rec_.div_factor); 
            tmp_rent_trans_id_ := rent_trans_id_;          
         END IF;
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END
   END IF;

   temp_item_id_ := item_rec_.item_id;
   -- gelr:prepayment_tax_document, added prepay_tax_base_curr_amt, prepay_tax_curr_amount and prepay_tax_document_id
   -- gelr:disc_price_rounded, added original_discount, original_add_discount and original_order_discount
   Create_Invoice_Item(temp_item_id_,
                       cre_invoice_id_, item_rec_.company, item_rec_.order_no,
                       item_rec_.line_no, item_rec_.release_no, item_rec_.line_item_no,
                       item_rec_.contract,
                       item_rec_.catalog_no, item_rec_.description, item_rec_.sale_um,
                       item_rec_.price_conv, item_rec_.sale_unit_price, item_rec_.unit_price_incl_tax, item_rec_.discount,
                       item_rec_.order_discount, item_rec_.vat_code, NULL, invoiced_qty_,
                       item_rec_.customer_po_no, item_rec_.deliv_type_id,
                       invoice_qty_count_, item_rec_.charge_seq_no, item_rec_.charge_group, item_rec_.stage,
                       item_rec_.prel_update_allowed, rma_no_, rma_line_no_, null, item_rec_.invoice_id,
                       item_rec_.item_id,item_rec_.additional_discount, item_rec_.sales_part_rebate_group,
                       item_rec_.assortment_id, item_rec_.assortment_node_id, item_rec_.charge_percent, item_rec_.charge_percent_basis, 
                       tmp_rent_trans_id_, NVL(line_rec_.ship_addr_no,credit_head_rec_.delivery_address_id), item_rec_.income_type_id,
                       free_of_charge_tax_basis_ => item_rec_.free_of_charge_tax_basis,
                       deb_inv_quantity_ => item_rec_.invoiced_qty,
                       customer_tax_usage_type_ => item_rec_.customer_tax_usage_type,
                       original_discount_       => item_rec_.original_discount,      
                       original_add_discount_   => item_rec_.original_add_discount,
                       original_order_discount_ => item_rec_.original_order_discount,
                       prepay_tax_base_curr_amt_ => item_rec_.prepay_tax_base_curr_amt, 
                       prepay_tax_curr_amount_   => item_rec_.prepay_tax_curr_amount, 
                       prepay_tax_document_id_   => item_rec_.prepay_tax_document_id);

   item_id_ := temp_item_id_;

   -- copy discount lines from reference invoice item to this credit/corr invoice item
   Cust_Invoice_Item_Discount_API.Copy_Discount_Credit(item_rec_.company, cre_invoice_id_, item_id_, item_rec_.invoice_id, item_rec_.item_id);
 
   IF (rma_no_ IS NOT NULL AND rma_line_no_ IS NOT NULL) THEN
      recalc_tax_amnt_ := 'TRUE';
   END IF;
   -- copy tax lines from reference invoice item to this credit/corr invoice item
   Tax_Handling_Order_Util_API.Transfer_Tax_lines(item_rec_.company, 
                                                  Tax_Source_API.DB_INVOICE,
                                                  item_rec_.invoice_id,
                                                  item_rec_.item_id,
                                                  '*',
                                                  '*',
                                                  '*',
                                                  Tax_Source_API.DB_INVOICE,
                                                  cre_invoice_id_,
                                                  item_id_,
                                                  '*',
                                                  '*',
                                                  '*',
                                                  recalc_tax_amnt_,
                                                  refresh_curr_rate_);  
   -- Create the witholding tax for the correction/credit invoice
   Customer_Invoice_Pub_Util_API.Create_Cor_Inv_Wht_Tax_Item(item_rec_.company,
                                                             item_rec_.identity,
                                                             line_type_,
                                                             item_rec_.invoice_id,
                                                             item_rec_.item_id,
                                                             cre_invoice_id_,
                                                             item_id_); 
   
   -- Modify the credit invoice no and credit invoice item id for correction invoice created from RMA
   IF credit_head_rec_.invoice_type IN (cor_inv_type_, col_inv_type_) THEN
      IF (line_type_ = 'DEBIT' AND rma_line_no_ IS NOT NULL) THEN
         Return_Material_Line_API.Modify_Cr_Invoice_Fields(rma_no_, rma_line_no_,
                                                           cre_invoice_id_, item_id_);
      END IF;
   END IF;

   -- If CO Line is project connected, then refresh project revenue for CO Invoice Line
   IF (item_rec_.order_no IS NOT NULL) AND (item_rec_.line_no IS NOT NULL) AND 
      (item_rec_.release_no IS NOT NULL) AND (item_rec_.line_item_no IS NOT NULL) THEN
    
      Calculate_Prel_Revenue__(item_rec_.company, cre_invoice_id_, item_id_, 
                               item_rec_.order_no, item_rec_.line_no, 
                               item_rec_.release_no, item_rec_.line_item_no);
   END IF;
   IF (item_rec_.rental_transaction_id IS NOT NULL) THEN 
      $IF Component_Rental_SYS.INSTALLED $THEN  
         IF (credit_head_rec_.invoice_type IN ('CUSTORDCRE', 'CUSTCOLCRE')) THEN
            -- When recreated transaction is invoiceable, then reopened the rental before qty_invoiced value update.
            IF (recreated_invoiceable_db_ = Fnd_Boolean_API.DB_TRUE) THEN
               Customer_Order_API.Set_Rent_Line_Reopened(item_rec_.order_no, 
                                                         item_rec_.line_no, 
                                                         item_rec_.release_no, 
                                                         item_rec_.line_item_no);
            END IF;
            --In credit invoices, qty invoiced is positive. 
            new_qty_invoiced_ := line_rec_.qty_invoiced + (-1 * invoiced_qty_);
            Customer_Order_API.Set_Line_Qty_Invoiced(item_rec_.order_no, 
                                                     item_rec_.line_no, 
                                                     item_rec_.release_no, 
                                                     item_rec_.line_item_no, 
                                                     new_qty_invoiced_);
            -- When recreated transaction is invoiceable, set it invoiceable flag to False.
            IF (recreated_invoiceable_db_ = Fnd_Boolean_API.DB_TRUE) THEN
               Rental_Transaction_API.Modify_Invoiceable_Db(rent_trans_id_, Fnd_Boolean_API.DB_FALSE);
            END IF;
         END IF; 
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END
   END IF;
END Create_Credit_Invoice_Item___;

-- Do_Str_Event_Acc___
--   Create postings and call End_Booking for each hit on a
--   specified event_code.
PROCEDURE Do_Str_Event_Acc___ (
   control_type_key_rec_ IN Mpccom_Accounting_API.Control_Type_Key,
   invoice_id_           IN NUMBER,
   item_id_              IN NUMBER,
   company_              IN VARCHAR2,
   event_code_           IN VARCHAR2,
   booking_              IN NUMBER,
   quantity_             IN NUMBER,
   value_                IN NUMBER,
   accounting_date_      IN DATE,
   vat_code_             IN VARCHAR2,
   revenue_simulation_   IN BOOLEAN,
   refresh_proj_revenue_ IN BOOLEAN)
IS
   dummy_                 VARCHAR2(80);
   account_value_         NUMBER;
   pre_accounting_exist_  NUMBER;
   account_err_desc_      VARCHAR2(2000);
   activity_seq_          NUMBER;
   activity_seq_temp_     NUMBER;
   posting_rec_           Customer_Invoice_Pub_Util_API.customer_invoice_posting_rec;
   codestr_rec_           Accounting_Codestr_API.CodestrRec;   
   project_code_part_     VARCHAR2(1);
   order_inv_item_rec_    Public_Rec;
   proj_code_value_       VARCHAR2(10);
   distr_proj_code_value_ VARCHAR2(10);
   external_project_flag_ VARCHAR2(1);
   error_                 VARCHAR2(10);
   -- PRSC-1949, start
   -- This local variable replaced the usages of Mpccom_Accounting_API.Codestring_Rec. 
   codestring_rec_         Accounting_Codestr_API.CodestrRec;
   -- PRSC-1949, end   
   local_control_type_key_rec_  Mpccom_Accounting_API.Control_Type_Key := control_type_key_rec_;    
      
   CURSOR get_str_event_acc IS
      SELECT str_code, booking, pre_accounting_flag_db, debit_credit_db, project_accounting_flag_db
      FROM ACC_EVENT_POSTING_TYPE_PUB
      WHERE  event_code = event_code_;

BEGIN
   
   FOR eventrec_ IN get_str_event_acc LOOP
      IF (eventrec_.booking = booking_) THEN   
         -- PRSC-1949, Passed parameter codestring_rec_. 
         Mpccom_Accounting_API.Get_Code_String(account_err_desc_,
                                               dummy_,
                                               codestring_rec_,
                                               local_control_type_key_rec_,
                                               company_,
                                               eventrec_.str_code,
                                               accounting_date_);

         IF (account_err_desc_ IS NOT NULL) THEN
            error_ := 'TRUE';
         ELSE
            error_ := NULL;
         END IF;

         IF (eventrec_.debit_credit_db = 'C') THEN
            -- Convert all the positive line to negative if the debit_credit_db = 'C'
            account_value_ := value_ * -1;
         ELSE
            account_value_ := value_;
         END IF;

         pre_accounting_exist_ := Pre_Accounting_API.Pre_Accounting_Exist(local_control_type_key_rec_.pre_accounting_id_);

         IF (pre_accounting_exist_ = 0) THEN            
            local_control_type_key_rec_.pre_accounting_id_ := Pre_Accounting_API.Get_Pre_Accounting_Id(local_control_type_key_rec_);
         END IF;
         
         order_inv_item_rec_ := Get ( company_, invoice_id_, item_id_);
         
         -- Do pre accounting if it exists.
         IF (local_control_type_key_rec_.pre_accounting_id_ IS NOT NULL) THEN            
            -- PRSC-1949, Passed parameter codestring_rec_. 
            Pre_Accounting_API.Do_Pre_Accounting(activity_seq_,
                                                 codestring_rec_,
                                                 local_control_type_key_rec_,                                                 
                                                 local_control_type_key_rec_.pre_accounting_id_,
                                                 eventrec_.pre_accounting_flag_db,
                                                 eventrec_.project_accounting_flag_db);
            activity_seq_temp_ := activity_seq_;                   
            ----------------------------------------------------------------
            --Part1. For Charges
            --Charges do not need to be pre posted with the project ID when creating a invoice if the connected project is of project origin ENGINEERING
            -- preaccounting from order head for charge connected to order used when order_no is NOT NULL and charge_seq_no is NOT NULL and line_no is NULL.
            --Part2. For Prepayment based invoice
            --If posting type M192 or M193 and preposting is copied from the order header, project pre posting should be removed.
            --Because these project pre posting was not possible before our changes.
            ----------------------------------------------------------------         
            IF ((eventrec_.str_code IN ('M67', 'M68','M69','M70', 'M71', 'M72')) AND (order_inv_item_rec_.order_no IS NOT NULL) AND (order_inv_item_rec_.charge_seq_no IS NOT NULL) AND (order_inv_item_rec_.line_no IS NULL))
               OR (eventrec_.str_code IN ('M192', 'M193')) THEN
            
               Pre_Accounting_API.Get_Project_Code_Value (  proj_code_value_,
                                                            distr_proj_code_value_,
                                                            company_,
                                                            local_control_type_key_rec_.pre_accounting_id_ );
               IF (proj_code_value_ IS NOT NULL) THEN
                  $IF (Component_Genled_SYS.INSTALLED)$THEN 
                     external_project_flag_ := Accounting_Project_API.Get_Externally_Created(company_, proj_code_value_);
                     project_code_part_     := Accounting_Code_Parts_API.Get_Codepart_Function(company_,'PRACC');
                  $END 
      
                  IF (NVL(external_project_flag_,'N') = 'Y') THEN
                     --external project, then remove project code part value 
                     CASE project_code_part_
                        WHEN 'A' THEN codestring_rec_.code_a := NULL;
                        WHEN 'B' THEN codestring_rec_.code_b := NULL;
                        WHEN 'C' THEN codestring_rec_.code_c := NULL;
                        WHEN 'D' THEN codestring_rec_.code_d := NULL;
                        WHEN 'E' THEN codestring_rec_.code_e := NULL;
                        WHEN 'F' THEN codestring_rec_.code_f := NULL;
                        WHEN 'G' THEN codestring_rec_.code_g := NULL;
                        WHEN 'H' THEN codestring_rec_.code_h := NULL;
                        WHEN 'I' THEN codestring_rec_.code_i := NULL;
                        WHEN 'J' THEN codestring_rec_.code_j := NULL;
                     END CASE;
                     -- Assigning NULL to get rid of Posting errors for the project connected customer orders upgraded from IFS Applications 2004-1 
                     -- because they have activity sequence in pre posting of the CO header.
                     activity_seq_temp_ := NULL;   
                  END IF;
               END IF;
            END IF;
            --------------------------------------------------------------
         END IF;
         IF (error_ IS NULL) THEN
            codestr_rec_.code_a   := codestring_rec_.code_a;
            codestr_rec_.code_b   := codestring_rec_.code_b;
            codestr_rec_.code_c   := codestring_rec_.code_c;
            codestr_rec_.code_d   := codestring_rec_.code_d;
            codestr_rec_.code_e   := codestring_rec_.code_e;
            codestr_rec_.code_f   := codestring_rec_.code_f;
            codestr_rec_.code_g   := codestring_rec_.code_g;
            codestr_rec_.code_h   := codestring_rec_.code_h;
            codestr_rec_.code_i   := codestring_rec_.code_i;
            codestr_rec_.code_j   := codestring_rec_.code_j;
            codestr_rec_.quantity := quantity_;

            Complete_Check_Accounting___(account_err_desc_,company_,
                                         accounting_date_, eventrec_.str_code ,codestr_rec_);
            
            IF (account_err_desc_ IS NOT NULL) THEN
               error_ := 'TRUE';
            ELSE
               error_ := NULL;
            END IF;

            codestring_rec_.code_a := codestr_rec_.code_a;
            codestring_rec_.code_b := codestr_rec_.code_b;
            codestring_rec_.code_c := codestr_rec_.code_c;
            codestring_rec_.code_d := codestr_rec_.code_d;
            codestring_rec_.code_e := codestr_rec_.code_e;
            codestring_rec_.code_f := codestr_rec_.code_f;
            codestring_rec_.code_g := codestr_rec_.code_g;
            codestring_rec_.code_h := codestr_rec_.code_h;
            codestring_rec_.code_i := codestr_rec_.code_i;
            codestring_rec_.code_j := codestr_rec_.code_j;
         END IF;

         IF (revenue_simulation_ AND activity_seq_ IS NOT NULL) THEN
            -- If there is an error, proceed only if called from revenue simulation of CO line 

            IF (error_ IS NULL OR refresh_proj_revenue_ OR Is_Order_Revenue_Simulation___(order_inv_item_rec_.order_no, order_inv_item_rec_.line_no, order_inv_item_rec_.release_no, order_inv_item_rec_.line_item_no)) THEN
               IF error_ IS NULL THEN
                  Order_Proj_Revenue_Manager_API.Generate_Revenue_Element(invoice_id_, codestr_rec_, account_value_, company_, eventrec_.str_code, item_id_);
               ELSE
                  Error_SYS.Record_General(lu_name_, account_err_desc_);
               END IF;
            END IF;
            RETURN;
         END IF;

         -- Pass postings to Invoice
         posting_rec_.company    := company_;
         posting_rec_.invoice_id := invoice_id_;
         posting_rec_.item_id    := item_id_;
         posting_rec_.codepart_a := codestring_rec_.code_a;

         IF (posting_rec_.codepart_a IS NULL) THEN
            posting_rec_.codepart_a := '####';
         END IF;

         posting_rec_.codepart_b          := codestring_rec_.code_b;
         posting_rec_.codepart_c          := codestring_rec_.code_c;
         posting_rec_.codepart_d          := codestring_rec_.code_d;
         posting_rec_.codepart_e          := codestring_rec_.code_e;
         posting_rec_.codepart_f          := codestring_rec_.code_f;
         posting_rec_.codepart_g          := codestring_rec_.code_g;
         posting_rec_.codepart_h          := codestring_rec_.code_h;
         posting_rec_.codepart_i          := codestring_rec_.code_i;
         posting_rec_.codepart_j          := codestring_rec_.code_j;
         posting_rec_.project_activity_id := activity_seq_temp_;
         posting_rec_.amount              := account_value_;
         posting_rec_.quantity            := quantity_;
         posting_rec_.optional_code       := vat_code_;
         
         Trace_SYS.Field('booking', booking_);

         -- If no error description has been created for the current account the text attribute
         -- should contain the customers name.
         IF (account_err_desc_ IS NOT NULL ) THEN
            posting_rec_.text := account_err_desc_;
         ELSE
            posting_rec_.text := Customer_Order_Inv_Head_API.Get_Name(company_, invoice_id_);
         END IF;

         posting_rec_.error := error_;
         posting_rec_.posting_type := eventrec_.str_code;

         Trace_SYS.Field('company', posting_rec_.company);
         Trace_SYS.Field('invoice_id', posting_rec_.invoice_id);
         Trace_SYS.Field('item_id', posting_rec_.item_id);
         Trace_SYS.Field('row_id', posting_rec_.row_id);
         Trace_SYS.Field('codepart_a', posting_rec_.codepart_a);
         Trace_SYS.Field('codepart_b', posting_rec_.codepart_b);
         Trace_SYS.Field('codepart_c', posting_rec_.codepart_c);
         Trace_SYS.Field('codepart_d', posting_rec_.codepart_d);
         Trace_SYS.Field('codepart_e', posting_rec_.codepart_e);
         Trace_SYS.Field('codepart_f', posting_rec_.codepart_f);
         Trace_SYS.Field('codepart_g', posting_rec_.codepart_g);
         Trace_SYS.Field('codepart_h', posting_rec_.codepart_h);
         Trace_SYS.Field('codepart_i', posting_rec_.codepart_i);
         Trace_SYS.Field('codepart_j', posting_rec_.codepart_j);
         Trace_SYS.Field('project_activity_id', posting_rec_.project_activity_id);
         Trace_SYS.Field('optional_code', posting_rec_.optional_code);
         Trace_SYS.Field('amount', posting_rec_.amount);
         Trace_SYS.Field('quantity', posting_rec_.quantity);
         Trace_SYS.Field('text', posting_rec_.text);
         Trace_SYS.Field('error', posting_rec_.error);
         Trace_SYS.Field('posting_type', posting_rec_.posting_type);

         -- Create the posting
         Customer_Invoice_Pub_Util_API.Create_Posting(posting_rec_, TRUE);
      END IF;
   END LOOP;
END Do_Str_Event_Acc___;

-- Create_Discount_Postings___
--   Create all discount postings for an invoice item
PROCEDURE Create_Discount_Postings___ (
   control_type_key_rec_    IN Mpccom_Accounting_API.Control_Type_Key,
   line_disc_detail_table_  IN Cust_Invoice_Item_Discount_API.discount_detail_table,
   order_discount_amt_      IN NUMBER, 
   add_discount_amt_        IN NUMBER,
   company_                 IN VARCHAR2,
   invoice_id_              IN NUMBER,
   item_id_                 IN NUMBER,
   invoice_date_            IN DATE,
   event_code_              IN VARCHAR2,
   vat_code_                IN VARCHAR2,
   taxable_sales_           IN NUMBER,
   rma_unconnected_         IN BOOLEAN,
   revenue_simulation_      IN BOOLEAN,
   refresh_proj_revenue_    IN BOOLEAN)
IS
   order_no_                       CUSTOMER_ORDER_INV_ITEM.order_no%TYPE;
   booking_                        NUMBER;
   discount_amount_                NUMBER;
   invoiced_qty_                   CUSTOMER_ORDER_INV_ITEM.invoiced_qty%TYPE;
   line_no_                        CUSTOMER_ORDER_INV_ITEM.order_no%TYPE;
   release_no_                     CUSTOMER_ORDER_INV_ITEM.release_no%TYPE;
   line_item_no_                   CUSTOMER_ORDER_INV_ITEM.line_item_no%TYPE;
   prel_update_allowed_            CUSTOMER_ORDER_INV_ITEM.prel_update_allowed%TYPE;
   invoice_type_                   VARCHAR2(20);
   correction_inv_type_            VARCHAR2(20);
   col_cor_inv_type_               VARCHAR2(20);   
   local_control_type_key_rec_     Mpccom_Accounting_API.Control_Type_Key := control_type_key_rec_;    
   linerec_                        Customer_Order_Line_API.Public_Rec;
   CURSOR get_invoice_item_data IS
      SELECT order_no,
             line_no,
             release_no,
             line_item_no,
             invoiced_qty,
             prel_update_allowed
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_;
   
BEGIN
   invoice_type_        := Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, invoice_id_);
   correction_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   col_cor_inv_type_    := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);
 
   -- Get invoice item data
   OPEN get_invoice_item_data;
   FETCH get_invoice_item_data INTO order_no_,line_no_,release_no_,line_item_no_, invoiced_qty_, prel_update_allowed_;
   CLOSE get_invoice_item_data;
   linerec_             := Customer_Order_Line_API.Get(order_no_, line_no_, release_no_, line_item_no_);
   
   -- Create postings for each line discount record
   IF (line_disc_detail_table_.COUNT >0) THEN
      FOR i IN 1..line_disc_detail_table_.COUNT LOOP
         discount_amount_ := line_disc_detail_table_(i).discount_amount; 
         IF (invoice_type_ IN (correction_inv_type_, col_cor_inv_type_)) THEN
            IF prel_update_allowed_ != 'TRUE' THEN
               discount_amount_ := discount_amount_ * (-1);
            END IF;
         END IF;
         local_control_type_key_rec_.oe_discount_no_   := line_disc_detail_table_(i).discount_no;
         local_control_type_key_rec_.oe_discount_type_ := line_disc_detail_table_(i).discount_type;
         IF (NOT rma_unconnected_) THEN
            -- The normal case
            IF (taxable_sales_ = 1) THEN
               booking_ := 5;
               IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
                  booking_ := 33;
               END IF;
            ELSE
               booking_ := 6;
               IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
                  booking_ := 34;
               END IF;
            END IF;

            Do_Str_Event_Acc___(local_control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
                                invoiced_qty_, discount_amount_, invoice_date_, vat_code_, revenue_simulation_, refresh_proj_revenue_);
         ELSE
         -- This is a special case for discounts manually added to the credit invoice created
         -- for a RMA line not connected to an order line
            IF (taxable_sales_ = 1) THEN
               booking_ := 22;
            ELSE
               booking_ := 23;
            END IF;

            Do_Str_Event_Acc___(local_control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
                                invoiced_qty_, discount_amount_,
                                invoice_date_, vat_code_, revenue_simulation_, refresh_proj_revenue_);
         END IF;
      END LOOP;    
   END IF;
   
   -- Create postings for order discount
   IF (order_discount_amt_ IS NOT NULL) THEN 
      
      discount_amount_ := order_discount_amt_;
      IF (invoice_type_ IN (correction_inv_type_, col_cor_inv_type_)) THEN
         IF prel_update_allowed_ != 'TRUE' THEN
            discount_amount_ := discount_amount_ * (-1);
         END IF;
      END IF;
      IF (taxable_sales_ = 1) THEN
         booking_ := 13;
         IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
            booking_ := 35;
         END IF;
      ELSE
         booking_ := 14;  
         IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
            booking_ := 36;
         END IF;
      END IF;
      IF (discount_amount_ != 0) THEN
         Do_Str_Event_Acc___(local_control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_, invoiced_qty_,
                             discount_amount_, invoice_date_, vat_code_, revenue_simulation_, refresh_proj_revenue_);
      END IF;
   END IF;
   
   -- Create postings for additional discount
   IF (add_discount_amt_ IS NOT NULL ) THEN 
      discount_amount_ := add_discount_amt_;
      IF (invoice_type_ IN (correction_inv_type_, col_cor_inv_type_)) THEN
         IF prel_update_allowed_ != 'TRUE' THEN
            discount_amount_ := discount_amount_ * (-1);
         END IF;
      END IF;
      IF (taxable_sales_ = 1) THEN
         booking_ := 24;
         IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN           
            booking_ := 37;
         END IF;
      ELSE
         booking_ := 25;
         IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
            booking_ := 38;
         END IF;
      END IF;
      IF (discount_amount_ != 0) THEN
         Do_Str_Event_Acc___(local_control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_, invoiced_qty_,
                          discount_amount_, invoice_date_, vat_code_, revenue_simulation_, refresh_proj_revenue_);
      END IF;
   END IF;
END Create_Discount_Postings___;


PROCEDURE Calc_Inv_Discount_Detail___(
   line_disc_detail_table_    OUT Cust_Invoice_Item_Discount_API.discount_detail_table,
   tot_line_discount_         OUT NUMBER,
   order_discount_amt_        OUT NUMBER, 
   add_discount_amt_          OUT NUMBER,
   company_                IN     VARCHAR2,
   invoice_id_             IN     NUMBER,
   item_id_                IN     NUMBER,
   currency_rounding_      IN     NUMBER ) 
IS 
   order_discount_                 CUSTOMER_ORDER_INV_ITEM.order_discount%TYPE;
   invoiced_qty_                   CUSTOMER_ORDER_INV_ITEM.invoiced_qty%TYPE;
   price_conv_factor_              CUSTOMER_ORDER_INV_ITEM.price_conv%TYPE;
   discount_amount_                NUMBER;
   discount_net_amount_            NUMBER;
   net_amount_                     NUMBER;
   gross_amount_                   NUMBER;
   total_line_discount_incl_tax_   NUMBER := 0;
   total_line_discount_excl_tax_   NUMBER := 0;
   inv_line_add_discount_          NUMBER;
   use_price_incl_tax_             VARCHAR2(20); 
   count_                          NUMBER := 1;
   tax_info_table_                 Tax_Handling_Util_API.tax_information_table;
   line_disc_tax_info_table_       Tax_Handling_Util_API.tax_information_table;
   tax_line_param_rec_             Tax_Handling_Order_Util_API.tax_line_param_rec;
   
   CURSOR get_invoice_item_data IS
      SELECT order_discount,
             invoiced_qty,
             price_conv,
            (invoiced_qty * price_conv * NVL(sale_unit_price, charge_percent * charge_percent_basis / 100)) net_curr_amount,
            (invoiced_qty * price_conv * NVL(unit_price_incl_tax, charge_percent * charge_percent_basis / 100)) gross_curr_amount,
             additional_discount
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
      
   CURSOR get_line_discounts IS
      SELECT discount_no, discount_type, discount,
             (calculation_basis * NVL(discount, 0)/100 + NVL(discount_amount, 0))  discount_amount
      FROM   CUST_INVOICE_ITEM_DISCOUNT_TAB
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_; 
      
BEGIN
   use_price_incl_tax_  := Customer_Order_Inv_Head_API.Get_Use_Price_Incl_Tax_Db(company_, invoice_id_);
   -- Get invoice item data
   OPEN get_invoice_item_data;
   FETCH get_invoice_item_data INTO order_discount_, invoiced_qty_, price_conv_factor_, 
                                    net_amount_, gross_amount_, inv_line_add_discount_;
   CLOSE get_invoice_item_data;
   
   IF (use_price_incl_tax_ = 'TRUE') THEN
      Trace_SYS.Message('****************************Fetching Tax Information For Calculating Discount Amounts****************************');                                                              
      tax_line_param_rec_ := Fetch_Tax_Line_Param (company_, invoice_id_, item_id_, '*', '*'); 
      tax_line_param_rec_.from_defaults := FALSE;
      tax_info_table_     := Tax_Handling_Order_Util_API.Get_Saved_Tax_Detail(Tax_Source_API.DB_INVOICE, invoice_id_, item_id_, '*', '*', '*', tax_line_param_rec_);
   END IF;
   
   -- Calculate Line Discounts and insrting to the line discount detail table
   FOR discount_rec_ IN get_line_discounts LOOP

      IF (use_price_incl_tax_ = 'TRUE') THEN
         line_disc_tax_info_table_     := tax_info_table_;
         discount_amount_              := discount_rec_.discount_amount * invoiced_qty_ * price_conv_factor_;
         discount_amount_              := ROUND(discount_amount_, currency_rounding_);
         total_line_discount_incl_tax_ := total_line_discount_incl_tax_ + discount_amount_;
         Tax_Handling_Order_Util_API.Calc_Total_Net_Gross_curr_Amt (discount_amount_, 
                                                                    discount_net_amount_, 
                                                                    line_disc_tax_info_table_,
                                                                    tax_line_param_rec_,
                                                                    Tax_Source_API.DB_INVOICE,
                                                                    invoice_id_,
                                                                    item_id_,
                                                                    '*',
                                                                    '*',
                                                                    '*');
      ELSE
         -- gelr:disc_price_rounded: if Discounted Price Roundedm, calculate according to the new logic
         IF (Get_Discounted_Price_Rounded(company_, invoice_id_, item_id_)) THEN
            discount_net_amount_ := Get_Line_Discount_Amount___(company_, invoice_id_, item_id_, discount_rec_.discount_no, invoiced_qty_, price_conv_factor_, currency_rounding_);
         ELSE
            discount_net_amount_              := discount_rec_.discount_amount * invoiced_qty_ * price_conv_factor_;
         END IF;
         discount_net_amount_              := ROUND(discount_net_amount_, currency_rounding_);
         
         total_line_discount_excl_tax_ := total_line_discount_excl_tax_ + discount_net_amount_;
      END IF;
      tot_line_discount_ := NVL(tot_line_discount_,0) + discount_net_amount_;   
      line_disc_detail_table_(count_).discount_amount := discount_net_amount_;
      line_disc_detail_table_(count_).discount_no     := discount_rec_.discount_no;
      line_disc_detail_table_(count_).discount_type   := discount_rec_.discount_type;
      discount_net_amount_ := 0;
      discount_amount_     := 0;
      count_ := count_ + 1;
   END LOOP;
   
   -- Calculate the discount amount for order_discount
   IF (order_discount_ > 0) THEN
      IF (use_price_incl_tax_ = 'TRUE') THEN
         discount_amount_ := (gross_amount_ - total_line_discount_incl_tax_) * (order_discount_/100);
         discount_amount_ :=  ROUND(discount_amount_, currency_rounding_);
         Tax_Handling_Order_Util_API.Calc_Total_Net_Gross_curr_Amt (discount_amount_, 
                                                                    discount_net_amount_, 
                                                                    tax_info_table_,
                                                                    tax_line_param_rec_,
                                                                    Tax_Source_API.DB_INVOICE,
                                                                    invoice_id_,
                                                                    item_id_,
                                                                    '*',
                                                                    '*',
                                                                    '*');
      ELSE
         discount_net_amount_ := (net_amount_ - total_line_discount_excl_tax_) * (order_discount_/100);
         discount_net_amount_ := ROUND(discount_net_amount_, currency_rounding_);
      END IF;
      order_discount_amt_ := discount_net_amount_;
   END IF;
   
   -- Calculate the discount amount for additional_discount
   IF (inv_line_add_discount_ > 0) THEN    
      IF (use_price_incl_tax_ = 'TRUE') THEN
         discount_amount_ := (gross_amount_ - total_line_discount_incl_tax_ ) * (inv_line_add_discount_/100);
         discount_amount_ := ROUND(discount_amount_, currency_rounding_);
         Tax_Handling_Order_Util_API.Calc_Total_Net_Gross_curr_Amt (discount_amount_, 
                                                                    discount_net_amount_, 
                                                                    tax_info_table_,
                                                                    tax_line_param_rec_,
                                                                    Tax_Source_API.DB_INVOICE,
                                                                    invoice_id_,
                                                                    item_id_,
                                                                    '*',
                                                                    '*',
                                                                    '*');
      ELSE
         discount_net_amount_ := (net_amount_ - total_line_discount_excl_tax_ ) * (inv_line_add_discount_/100);
         discount_net_amount_ := ROUND(discount_net_amount_, currency_rounding_);
      END IF;
      add_discount_amt_ := discount_net_amount_;
   END IF;

END Calc_Inv_Discount_Detail___;

-- Create_Free_Of_Chg_Postings___
-- Create postings for free of charge goods when company paying tax
PROCEDURE Create_Free_Of_Chg_Postings___ (
   control_type_key_rec_    IN Mpccom_Accounting_API.Control_Type_Key,
   company_                 IN VARCHAR2,
   invoice_id_              IN NUMBER,
   item_id_                 IN NUMBER,
   invoice_date_            IN DATE,
   event_code_              IN VARCHAR2,
   vat_code_                IN VARCHAR2,
   revenue_simulation_      IN BOOLEAN,
   refresh_proj_revenue_    IN BOOLEAN)
IS
   order_no_                       CUSTOMER_ORDER_INV_ITEM.order_no%TYPE;
   base_comp_bearing_tax_amt_      NUMBER;
   booking_                        NUMBER;
   invoiced_qty_                   CUSTOMER_ORDER_INV_ITEM.invoiced_qty%TYPE;
   line_no_                        CUSTOMER_ORDER_INV_ITEM.order_no%TYPE;
   release_no_                     CUSTOMER_ORDER_INV_ITEM.release_no%TYPE;
   line_item_no_                   CUSTOMER_ORDER_INV_ITEM.line_item_no%TYPE;
   prel_update_allowed_            CUSTOMER_ORDER_INV_ITEM.prel_update_allowed%TYPE;
   invoice_type_                   VARCHAR2(20);
   correction_inv_type_            VARCHAR2(20);
   col_cor_inv_type_               VARCHAR2(20);
   local_control_type_key_rec_     Mpccom_Accounting_API.Control_Type_Key := control_type_key_rec_; 
   curr_code_                      VARCHAR2(3);
   identity_                       VARCHAR2(20);
   CURSOR get_invoice_item_data IS
      SELECT order_no,
             line_no,
             release_no,
             line_item_no,
             base_comp_bearing_tax_amt,
             invoiced_qty,
             prel_update_allowed,
             identity
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_;

BEGIN
   invoice_type_        := Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, invoice_id_);
   correction_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   col_cor_inv_type_    := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);
 
   -- Get invoice item data
   OPEN get_invoice_item_data;
   FETCH get_invoice_item_data INTO order_no_, line_no_, release_no_, line_item_no_, base_comp_bearing_tax_amt_,
                                    invoiced_qty_, prel_update_allowed_, identity_;
   CLOSE get_invoice_item_data;
   IF (base_comp_bearing_tax_amt_ IS NOT NULL) THEN
      curr_code_ := Customer_Order_API.Get_Currency_Code(order_no_);
      -- If the order currency and company currency are different, base_comp_bearing_tax_amt_ should be converted to order currency. 
      IF (Company_Finance_API.Get_Currency_Code(company_) != curr_code_) THEN
         base_comp_bearing_tax_amt_ := Source_Tax_Item_API.Get_Total_Tax_Curr_Amount(company_, Tax_Source_API.DB_INVOICE, TO_CHAR(invoice_id_), TO_CHAR(item_id_), '*', '*', '*');
      END IF;
      -- For the correction invoice credit type lines the invoiced_qty_ is negative,
      -- Hence the base_comp_bearing_tax_amt is already negative, make it positive to book the correct postings.
      IF (invoice_type_ IN (correction_inv_type_, col_cor_inv_type_)) THEN
         IF prel_update_allowed_ != 'TRUE' THEN
            base_comp_bearing_tax_amt_ := base_comp_bearing_tax_amt_ * (-1);
         END IF;
      END IF;       
      -- hardcoded invoice types 'CUSTORDCRE', 'CUSTCOLCRE' are used as when creating CO Credit Invoice also hardcoded value is used (see method Invoice_Customer_Order_API.Create_Credit_Invoice__)
      IF (invoice_type_ IN ('CUSTORDCRE', 'CUSTCOLCRE')) THEN
         base_comp_bearing_tax_amt_ := base_comp_bearing_tax_amt_ * (-1);         
      END IF;   
      booking_ := 40;
      Do_Str_Event_Acc___(local_control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
                          invoiced_qty_, base_comp_bearing_tax_amt_, invoice_date_, vat_code_, revenue_simulation_, refresh_proj_revenue_);
   END IF;
END Create_Free_Of_Chg_Postings___;


-- Create_Rebate_Postings___
--   Create all rebate postings for an invoice item
PROCEDURE Create_Rebate_Postings___ (
   control_type_key_rec_ IN Mpccom_Accounting_API.Control_Type_Key,
   company_              IN VARCHAR2,
   invoice_id_           IN NUMBER,
   item_id_              IN NUMBER,
   invoice_date_         IN DATE,
   event_code_           IN VARCHAR2,
   vat_code_             IN VARCHAR2,
   currency_rounding_    IN NUMBER,
   invoiced_qty_         IN NUMBER,
   invoice_type_         IN VARCHAR2,
   aggregation_no_       IN NUMBER,
   line_item_no_         IN NUMBER, -- in Rebate_Credit_Invoice line_item_no_ has the aggr_line
   final_settlement_     IN VARCHAR2,
   sales_amount_         IN NUMBER,
   refresh_proj_revenue_ IN BOOLEAN)
IS
   booking_                 NUMBER;
   booking_cost_            NUMBER;
   rebate_cost_base_        NUMBER;
   booking_cost_inv_curr_   NUMBER;
   headrec_                 Customer_Order_Inv_Head_API.Public_Rec;
   dummy_                   NUMBER;
   rebate_periodic_agg_rec_ Rebate_Periodic_Agg_Line_API.Public_Rec;
   rebate_final_agg_rec_    Rebate_Final_Agg_Line_API.Public_Rec;
   cor_inv_type_            VARCHAR2(20);
   prel_update_allowed_     VARCHAR2(5);   
   local_control_type_key_rec_  Mpccom_Accounting_API.Control_Type_Key := control_type_key_rec_; 
   remaining_cost_          NUMBER := 0;
   remaining_cost_inv_curr_ NUMBER := 0;
   aggr_line_remain_cost_   NUMBER := 0;
   do_booking_using_cost_   BOOLEAN := FALSE;
   do_booking_for_30_       BOOLEAN := FALSE;
   agreement_currency_code_ VARCHAR2(3);
   inv_head_currency_code_  VARCHAR2(3);
   company_currency_code_   VARCHAR2(3);
   rebate_difference_       NUMBER := 0;
   rebate_total_            NUMBER := 0;
   col_cor_inv_type_        VARCHAR2(20);
      
   CURSOR get_rebate_transactions IS
      SELECT total_rebate_cost_amount, transaction_id, order_no, agreement_id
      FROM   rebate_transaction_tab
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_
      AND    rebate_type != '*';
      
   CURSOR get_aggr_line_postings (aggregation_no_ IN NUMBER, aggr_line_no_ IN NUMBER, is_final_ IN VARCHAR2, do_booking_ IN NUMBER) IS 
      SELECT *
      FROM reb_aggr_line_posting_tmp
      WHERE aggregation_no = aggregation_no_
      AND aggr_line_no = aggr_line_no_
      AND is_final = is_final_
      AND company = company_
      AND booking = do_booking_;
BEGIN

   cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   col_cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);
   company_currency_code_    := Company_Finance_API.Get_Currency_Code(company_);

   IF invoice_type_ IN ('CUSTORDDEB','CUSTCOLDEB','SELFBILLDEB','CUSTORDCRE','CUSTCOLCRE','SELFBILLCRE', cor_inv_type_, col_cor_inv_type_) THEN
      -- Customer Order Debit and Credit Invoices
      -- Loop through the transactions for this invoice line and fetch the rebate cost
      FOR rebate_transaction_ IN get_rebate_transactions LOOP
         booking_cost_        := rebate_transaction_.total_rebate_cost_amount;
         prel_update_allowed_ := Get_Prel_Update_Allowed(company_, invoice_id_, item_id_);
         -- Convert the booking_cost if credit invoice, due to calculation in Do_Str_Event_Acc___
         IF (invoice_type_ IN ('CUSTORDCRE','CUSTCOLCRE','SELFBILLCRE')) OR (prel_update_allowed_ = 'FALSE') THEN
            booking_cost_ := booking_cost_ * -1;
         END IF;

         -- Calculate the cost in invoice currency
         headrec_      := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);
         agreement_currency_code_  := Rebate_Agreement_API.Get_Currency_Code(rebate_transaction_.agreement_id);
         inv_head_currency_code_   := headrec_.currency_code;

         IF(agreement_currency_code_ != inv_head_currency_code_)THEN
            IF(inv_head_currency_code_ = company_currency_code_) THEN
               Customer_Order_Pricing_API.Get_Base_Price_In_Currency(booking_cost_, dummy_, headrec_.customer_no, headrec_.contract, agreement_currency_code_, booking_cost_);
            ELSIF(inv_head_currency_code_ != company_currency_code_)THEN
               Customer_Order_Pricing_API.Get_Base_Price_In_Currency(rebate_cost_base_, dummy_, headrec_.customer_no, headrec_.contract, agreement_currency_code_, booking_cost_);
               Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(booking_cost_, dummy_, headrec_.customer_no, headrec_.contract, headrec_.currency_code, rebate_cost_base_, headrec_.currency_rate_type);   
            ELSIF(agreement_currency_code_ = company_currency_code_) THEN
               Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(booking_cost_, dummy_, headrec_.customer_no, headrec_.contract, headrec_.currency_code, booking_cost_, headrec_.currency_rate_type);
            END IF; 
         END IF;   
         booking_cost_ := ROUND(booking_cost_, currency_rounding_);

         IF (booking_cost_ != 0) THEN
            -- Assign the Rebate Transaction Id to the global record
            local_control_type_key_rec_.transaction_id_ := rebate_transaction_.transaction_id;
            -- Posting type M203 - Rebate Expense (Credit)
            booking_ := 28;
            -- The revenue_simulation_ parameter value passed as FALSE
            Do_Str_Event_Acc___(local_control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
                                invoiced_qty_, booking_cost_, invoice_date_, vat_code_, FALSE, refresh_proj_revenue_);

            -- Posting type M204 - Rebate Accruals (Debit)
            booking_ := 29;
            -- The revenue_simulation_ parameter value passed as FALSE
            Do_Str_Event_Acc___(local_control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
                                invoiced_qty_, booking_cost_, invoice_date_, vat_code_, FALSE, refresh_proj_revenue_);
         END IF; 
         
         
      END LOOP;
   ELSE
      -- Customer Rebate Credit Invoices
      -- This was written to stop the duplicate postings being inserted, when this method gets rerun if there is a posting error.
      DELETE 
      FROM reb_aggr_line_posting_tmp
      WHERE aggregation_no = aggregation_no_
      AND   aggr_line_no   = line_item_no_;
      IF final_settlement_ = 'FALSE' THEN
         
         rebate_periodic_agg_rec_ := Rebate_Periodic_Agg_Line_API.Get(aggregation_no_, line_item_no_);
         
         IF rebate_periodic_agg_rec_.total_rebate_cost_amount IS NOT NULL AND rebate_periodic_agg_rec_.total_rebate_amount IS NOT NULL THEN
         
            IF rebate_periodic_agg_rec_.total_rebate_amount > rebate_periodic_agg_rec_.total_rebate_cost_amount THEN
                  do_booking_using_cost_ := TRUE;
               IF (rebate_periodic_agg_rec_.total_rebate_amount - rebate_periodic_agg_rec_.total_rebate_cost_amount > 0) THEN
                  do_booking_for_30_         := TRUE;
               ELSE 
                  do_booking_for_30_         := FALSE; 
               END IF; 

            ELSE
                  do_booking_using_cost_     := FALSE;
                  do_booking_for_30_         := FALSE; 
            END IF;

            -- booking := 29
            Add_Reb_Aggr_Line_Post___(aggregation_no_, 
                                       line_item_no_,
                                       final_settlement_,
                                       invoice_id_,
                                       item_id_,
                                       company_,
                                       event_code_,
                                       29,
                                       invoice_date_);

            FOR posting_ IN get_aggr_line_postings(aggregation_no_, line_item_no_, 'FALSE', 29) LOOP
               IF (do_booking_using_cost_) THEN
                  booking_cost_inv_curr_ := ROUND(posting_.total_rebate_cost_amount, currency_rounding_);
               ELSE
                  booking_cost_inv_curr_ := ROUND(posting_.total_rebate_amount, currency_rounding_);
               END IF;
               rebate_total_ := rebate_total_ + ROUND(posting_.total_rebate_amount, currency_rounding_);
               booking_ := 29;

               local_control_type_key_rec_.reb_aggr_posting_id_ := posting_.reb_aggr_posting_id;
               local_control_type_key_rec_.contract_ := NVL(posting_.c5, local_control_type_key_rec_.contract_); -- C5

               IF (booking_cost_inv_curr_ != 0) THEN
                  Do_Str_Event_Acc___(local_control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
                                       invoiced_qty_, booking_cost_inv_curr_, invoice_date_, vat_code_, FALSE, refresh_proj_revenue_);
               END IF; 
            END LOOP;
            
            IF (booking_ = 29) THEN
               rebate_difference_ := sales_amount_ - rebate_total_ ;
               -- Difference should be posted to M205. Therefore booking 30 is used.
               booking_ := 30;    
               IF (rebate_difference_ != 0) THEN 
                  local_control_type_key_rec_.reb_aggr_posting_id_ := NULL;
                  local_control_type_key_rec_.contract_ := NULL;
                  -- Rebate difference is posted to M205 with a default control type, so that IP could be balance.
                  Do_Str_Event_Acc___(local_control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
                                       invoiced_qty_, rebate_difference_, invoice_date_, vat_code_, FALSE, refresh_proj_revenue_);
                END IF;
            END IF;   

            IF (do_booking_for_30_) THEN
               rebate_total_ := 0;

               -- booking := 30
               Add_Reb_Aggr_Line_Post___(aggregation_no_, 
                                          line_item_no_,
                                          final_settlement_,
                                          invoice_id_,
                                          item_id_,
                                          company_,
                                          event_code_,
                                          30,
                                          invoice_date_);
               FOR posting_ IN get_aggr_line_postings(aggregation_no_, line_item_no_, 'FALSE', 30) LOOP
                  booking_cost_inv_curr_ := ROUND(posting_.total_rebate_amount, currency_rounding_) 
                                             - ROUND(posting_.total_rebate_cost_amount, currency_rounding_);
                  rebate_total_ := rebate_total_ + ROUND(posting_.total_rebate_amount, currency_rounding_);
                  booking_ := 30;

                  local_control_type_key_rec_.reb_aggr_posting_id_ := posting_.reb_aggr_posting_id;
                  local_control_type_key_rec_.contract_ := NVL(posting_.c5, local_control_type_key_rec_.contract_); -- C5

                  Do_Str_Event_Acc___( local_control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
                                       invoiced_qty_, booking_cost_inv_curr_, invoice_date_, vat_code_, FALSE, refresh_proj_revenue_);
               END LOOP;
            END IF; 
         END IF;
      ELSE
         rebate_final_agg_rec_ := Rebate_Final_Agg_Line_API.Get(aggregation_no_, line_item_no_);
         IF ( rebate_final_agg_rec_.amount_to_invoice > 0) THEN
            aggr_line_remain_cost_ := Rebate_Final_Agg_Line_API.Get_Remaining_Cost(aggregation_no_, line_item_no_);
            IF (aggr_line_remain_cost_ > 0) THEN
               --booking_ := 29
               Add_Reb_Aggr_Line_Post___(aggregation_no_, 
                                          line_item_no_,
                                          final_settlement_,
                                          invoice_id_,
                                          item_id_,
                                          company_,
                                          event_code_,
                                          29,
                                          invoice_date_);
               FOR posting_ IN get_aggr_line_postings(aggregation_no_, line_item_no_, 'TRUE', 29) LOOP
                  remaining_cost_ := posting_.total_rebate_cost_amount; -- total_rebate_cost_amount, handled in reb_aggr_line_cntrl_type_tmp level to have the remaining cost.
                  local_control_type_key_rec_.reb_aggr_posting_id_ := posting_.reb_aggr_posting_id;
                  local_control_type_key_rec_.contract_ := NVL(posting_.c5, local_control_type_key_rec_.contract_);
                  
                  -- Posting type M204 - Rebate Accruals (Debit). M204 is debitted only when there is costs to be accounted.                  
                  IF remaining_cost_ > 0 THEN
                     remaining_cost_inv_curr_ := ROUND(remaining_cost_, currency_rounding_);
                     booking_ := 29;
                     Do_Str_Event_Acc___(local_control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
                                         invoiced_qty_, remaining_cost_inv_curr_, invoice_date_, vat_code_, FALSE, refresh_proj_revenue_);
                  END IF;
               END LOOP;
            END IF; 
            
            --booking_ := 30
            Add_Reb_Aggr_Line_Post___(aggregation_no_, 
                                       line_item_no_,
                                       final_settlement_,
                                       invoice_id_,
                                       item_id_,
                                       company_,
                                       event_code_,
                                       30,
                                       invoice_date_);
            FOR posting_ IN get_aggr_line_postings(aggregation_no_, line_item_no_, 'TRUE', 30) LOOP
               local_control_type_key_rec_.reb_aggr_posting_id_ := posting_.reb_aggr_posting_id;
               local_control_type_key_rec_.contract_ := NVL(posting_.c5, local_control_type_key_rec_.contract_);
               -- Posting type M205 - Additional Rebate Costs (Debit)
               remaining_cost_ := posting_.total_rebate_cost_amount; -- total_rebate_cost_amount, handled in reb_aggr_line_cntrl_type_tmp level to have the remaining cost.
               remaining_cost_inv_curr_ := ROUND(remaining_cost_, currency_rounding_);
               booking_cost_ := posting_.total_rebate_amount;
               booking_cost_ := ROUND(booking_cost_, currency_rounding_);
               rebate_total_ := rebate_total_ + booking_cost_;
               booking_cost_ := booking_cost_ - remaining_cost_inv_curr_;
               
               IF (booking_cost_ != 0) THEN
                  booking_ := 30;
                  -- The revenue_simulation_ parameter value passed as FALSE
                  Do_Str_Event_Acc___(local_control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
                                      invoiced_qty_, booking_cost_, invoice_date_, vat_code_, FALSE, refresh_proj_revenue_);
               END IF; 
               
            END LOOP;
            -- If there is a rebate_difference_ an update has been done.
            rebate_difference_ := sales_amount_ - rebate_total_ ;
            IF (rebate_difference_ != 0) THEN               
               local_control_type_key_rec_.reb_aggr_posting_id_ := NULL;
               local_control_type_key_rec_.contract_ := NULL; 
               booking_ := 30;
               -- Rebate difference is posted to M205 with a default control type, so that IP could be balance.
               Do_Str_Event_Acc___( local_control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
                                    invoiced_qty_, rebate_difference_, invoice_date_, vat_code_, FALSE, refresh_proj_revenue_);
            END IF ;
         END IF; 
      END IF;
   END IF;
END Create_Rebate_Postings___;


-- Calculate_Line_Amounts___
-- Calculate the net amount and vat amounts for an invoice item
-- when created or updated.
PROCEDURE Calculate_Line_Amounts___ (
   tax_calc_structure_id_       OUT VARCHAR2,
   line_tax_dom_amount_         OUT NUMBER,
   net_curr_amount_          IN OUT NUMBER,
   vat_curr_amount_          IN OUT NUMBER,
   company_                  IN     VARCHAR2,
   invoice_id_               IN     NUMBER,
   item_id_                  IN     NUMBER,
   source_ref1_              IN     VARCHAR2,
   source_ref2_              IN     VARCHAR2,
   source_ref3_              IN     VARCHAR2,
   source_ref4_              IN     VARCHAR2,
   source_ref5_              IN     VARCHAR2,
   source_ref_type_          IN     VARCHAR2,
   invoiced_qty_             IN     NUMBER,
   price_conv_factor_        IN     NUMBER,
   sale_unit_price_          IN     NUMBER,
   unit_price_incl_tax_      IN     NUMBER,
   entered_tax_code_         IN     VARCHAR2,
   discount_                 IN     NUMBER,   
   order_discount_           IN     NUMBER,
   currency_rounding_        IN     NUMBER,
   add_discount_             IN     NUMBER,
   use_price_incl_tax_       IN     VARCHAR2,
   free_of_charge_tax_basis_ IN     NUMBER,
   currency_rate_            IN     NUMBER )
IS
   tax_line_param_rec_     Tax_Handling_Order_Util_API.tax_line_param_rec;
   gross_curr_amount_      NUMBER;
   line_net_dom_amount_    NUMBER;
   line_gross_dom_amount_  NUMBER;
   source_pkg_             VARCHAR2(30);
   stmt_                   VARCHAR2(2000);
   external_tax_calc_method_ VARCHAR2(50);
   tax_from_defaults_      VARCHAR2(5);
BEGIN
   external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);
   tax_from_defaults_        := 'FALSE';

   Calc_Line_Net_Gross_Amts___(gross_curr_amount_,net_curr_amount_,company_,invoice_id_,item_id_,invoiced_qty_,
                               unit_price_incl_tax_,sale_unit_price_,discount_,order_discount_,add_discount_,
                               price_conv_factor_,currency_rounding_,use_price_incl_tax_); 

   source_pkg_  := Tax_Handling_Order_Util_API.Get_Source_Pkg(source_ref_type_); 
   Assert_Sys.Assert_Is_Package(source_pkg_);    
   stmt_  := 'BEGIN :tax_line_param_rec := '||source_pkg_||'.Fetch_Tax_Line_Param(:company, :source_ref1,
                                           :source_ref2, :source_ref3, :source_ref4); END;';
   @ApproveDynamicStatement(2016-04-19,DIPELK) 
   EXECUTE IMMEDIATE stmt_
      USING  OUT tax_line_param_rec_,
             IN  company_,
             IN  source_ref1_,
             IN  source_ref2_,
             IN  source_ref3_,
             IN  source_ref4_;
   -- Note: To support the functionality of overwriting debit invoice currency rate for credit/correction invoices,
   --       we need to use currency rate saved in credit/correction invoice head instead of debit invoice currency rate.               
   Tax_Handling_Order_Util_API.Get_Amounts(line_tax_dom_amount_,
                                           line_net_dom_amount_,
                                           line_gross_dom_amount_,
                                           vat_curr_amount_,
                                           net_curr_amount_,
                                           gross_curr_amount_,
                                           tax_line_param_rec_.tax_calc_structure_id,
                                           source_ref1_,
                                           source_ref2_,
                                           source_ref3_,
                                           source_ref4_,
                                           source_ref5_,
                                           source_ref_type_,
                                           tax_line_param_rec_.company,
                                           tax_line_param_rec_.contract,
                                           tax_line_param_rec_.customer_no,
                                           tax_line_param_rec_.ship_addr_no,
                                           tax_line_param_rec_.planned_ship_date,
                                           tax_line_param_rec_.supply_country_db,
                                           tax_line_param_rec_.delivery_type,
                                           tax_line_param_rec_.object_id,
                                           use_price_incl_tax_,
                                           tax_line_param_rec_.currency_code,
                                           tax_line_param_rec_.currency_rate,   
                                           tax_from_defaults_,   
                                           entered_tax_code_,
                                           tax_line_param_rec_.tax_liability,
                                           tax_line_param_rec_.tax_liability_type_db,
                                           tax_line_param_rec_.delivery_country_db,   
                                           free_of_charge_tax_basis_,
                                           'FALSE',
										             NULL,
                                           invoiced_qty_,
                                           NULL); 
   tax_calc_structure_id_ := tax_line_param_rec_.tax_calc_structure_id;                                           
END Calculate_Line_Amounts___;


-----------------------------------------------------------------------------
-- Is_Order_Revenue_Simulation___
--    Returns true if CUSTOMER_ORDER_LINE_API.Calculate_Revenue__ is being executed  
--    as a background job with given order line details.
-----------------------------------------------------------------------------
FUNCTION Is_Order_Revenue_Simulation___ (
   order_no_      IN     VARCHAR2,
   line_no_       IN     VARCHAR2,
   rel_no_        IN     VARCHAR2,   
   line_item_no_  IN     NUMBER ) RETURN BOOLEAN
IS
   current_job_id_        NUMBER;
   name_                  VARCHAR2(30);
   ptr_                   NUMBER;
   msg_                   VARCHAR2(32000);
   msg_value_             VARCHAR2(32000);
   parameter_value_       VARCHAR2(2000);
   co_revenue_calc_       BOOLEAN := FALSE;

BEGIN
   
   IF Transaction_SYS.Is_Session_Deferred THEN
      current_job_id_ := Transaction_SYS.Get_Current_Job_Id;
      Transaction_SYS.Get_Executing_Job_Arguments(msg_, 'CUSTOMER_ORDER_LINE_API.Calculate_Revenue__'); 
      IF msg_ IS NOT NULL THEN
        -- Get the Atguments of current background job execution
         Message_SYS.Get_Attribute(msg_, to_char(current_job_id_), msg_value_);
         IF msg_value_ IS NOT NULL THEN
            co_revenue_calc_ := TRUE;
         END IF;
         -- Loop through the parameter list to check whether order line matches
         WHILE (Client_SYS.Get_Next_From_Attr(msg_value_, ptr_, name_, parameter_value_)) LOOP
           IF (name_ = 'ORDER_NO') THEN
              IF order_no_ != parameter_value_ THEN
                 co_revenue_calc_ := FALSE;
                 EXIT;
              END IF;   
           ELSIF (name_ = 'LINE_NO') THEN
              IF line_no_ != parameter_value_ THEN
                 co_revenue_calc_ := FALSE;
                 EXIT;
              END IF;   
           ELSIF (name_ = 'REL_NO') THEN
              IF rel_no_ != parameter_value_ THEN
                 co_revenue_calc_ := FALSE;
                 EXIT;
              END IF;   
           ELSIF (name_ = 'LINE_ITEM_NO') THEN
              IF line_item_no_ != parameter_value_ THEN
                 co_revenue_calc_ := FALSE;
                 EXIT;
              END IF;   
           END IF;
        END LOOP;                          
          
      END IF;
   END IF;

   RETURN co_revenue_calc_;
END Is_Order_Revenue_Simulation___;

-- Modify_Liab_Dt_Corrinv_Crel___
--   Modified corresponding CRELINE when Manual Liability Date for DEBLINE is modified, .
PROCEDURE Modify_Liab_Dt_Corrinv_Crel___ (
   company_           IN VARCHAR2,
   invoice_id_        IN NUMBER,
   item_id_           IN NUMBER,
   man_tax_liab_date_ IN DATE )
IS
   rows_            NUMBER;
   creline_item_id_ NUMBER;
   attr_            VARCHAR2(10000);
   ref_             CUSTOMER_ORDER_INV_ITEM.reference%TYPE;
   objid_           CUSTOMER_ORDER_INV_ITEM.objid%TYPE;
   invoice_type_    CUSTOMER_ORDER_INV_ITEM.invoice_type%TYPE;
   
   CURSOR get_item IS
      SELECT count(*)
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_
      AND    company = company_;
   
   CURSOR get_ref_data(cre_item_id_ IN NUMBER) IS
      SELECT reference, objid, invoice_type
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_
      AND    company = company_
      AND    item_id = cre_item_id_;
BEGIN
   OPEN get_item;
   FETCH get_item INTO rows_;
   CLOSE get_item;
   -- Select the Corresponding CRELINE for the DEBLINE.
   creline_item_id_ := item_id_ + (rows_/2);
   OPEN  get_ref_data(creline_item_id_);
   FETCH get_ref_data INTO ref_, objid_, invoice_type_;
   CLOSE get_ref_data;
   -- Only modify the DEBLINE when taxcode is manual
   IF (Has_Manual_Tax_Liablty_Lines(company_, invoice_id_, creline_item_id_, invoice_type_ ) = 'TRUE') THEN
      Client_Sys.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('REFERENCE', ref_, attr_);
      Client_SYS.Add_To_Attr('MAN_TAX_LIABILITY_DATE', man_tax_liab_date_, attr_);
      Client_SYS.Add_To_Attr('SERVER_CHANGE', 'TRUE', attr_);
      Modify_Invoice_Item___(objid_, attr_);
   END IF;
END Modify_Liab_Dt_Corrinv_Crel___;


-- Create_Credit_Prepaym_Item___
--   Create credit invoice line for a prepayment invoice line.
PROCEDURE Create_Credit_Prepaym_Item___ (
   item_id_             IN OUT NUMBER,
   invoice_id_          IN NUMBER,
   price_conv_factor_   IN NUMBER,
   sale_unit_price_     IN NUMBER,
   unit_price_incl_tax_ IN NUMBER,
   invoiced_qty_        IN NUMBER,
   stage_               IN NUMBER,
   deb_invoice_id_      IN NUMBER,
   deb_item_id_         IN NUMBER,
   contract_            IN VARCHAR2,
   order_no_            IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   catalog_desc_        IN VARCHAR2,
   tax_code_            IN VARCHAR2,
   customer_po_no_      IN VARCHAR2,
   sales_unit_meas_     IN VARCHAR2,
   deliv_type_id_       IN VARCHAR2,
   prel_update_allowed_ IN VARCHAR2 )
IS
   reference_               VARCHAR2(100);
   debit_invoice_no_        VARCHAR2(50);
   series_id_               VARCHAR2(20);
   chk_ser_ref_             VARCHAR2(20);
   customer_no_             VARCHAR2(50);
   cons_attr_               VARCHAR2(2000);
   company_                 CUSTOMER_ORDER_INV_ITEM.company%TYPE;
   pos_                     CUSTOMER_ORDER_INV_ITEM.pos%TYPE;
   item_rec_                Customer_Invoice_Pub_Util_API.customer_invoice_item_rec;
   price_um_                CUSTOMER_ORDER_INV_ITEM.price_um%TYPE;
   headrec_                 Invoice_API.Public_Rec;
   tax_rec_                 source_tax_item_tab%ROWTYPE;
   net_curr_amount_         NUMBER;
   tax_curr_amount_         NUMBER;
   gross_curr_amount_       NUMBER;
   currency_rounding_       NUMBER;
   ivc_item_seq_no_         NUMBER;
   tax_percentage_          NUMBER;
   unconsumed_gross_amount_ NUMBER;
   consumed_amount_         NUMBER;
   max_item_id_             NUMBER;

   CURSOR get_pos IS
      SELECT to_char(max(to_number(pos)))
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_;


BEGIN

   OPEN get_pos;
   FETCH get_pos INTO pos_;
   IF (pos_ IS NOT NULL) THEN
      pos_ := to_char(to_number(pos_) + 1);
   ELSE
      pos_ := '1';
   END IF;
   CLOSE get_pos;
   
   company_           := Site_API.Get_Company(contract_);
   headrec_           := Invoice_API.Get(company_, invoice_id_);
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, headrec_.currency);
   customer_no_       := Customer_Order_API.Get_Customer_No(order_no_);
   gross_curr_amount_ := Get_Gross_Curr_Amount (company_, deb_invoice_id_, deb_item_id_);

   consumed_amount_         := Cust_Prepaym_Consumption_API.Get_Total_Consumed_Amount(company_, deb_invoice_id_, deb_item_id_);
   unconsumed_gross_amount_ := gross_curr_amount_ - consumed_amount_;
   
   max_item_id_ := Invoice_Item_API.Get_Max_Item_Id(company_, invoice_id_);
   item_id_     := 1 + max_item_id_;

   IF (unconsumed_gross_amount_ != 0) THEN
      -- Prepayment based credit invoice specific line amounts calculations.
      Calc_Line_Amount_For_Prepay___ (net_curr_amount_,
                                      tax_curr_amount_,
                                      tax_percentage_,
                                      unconsumed_gross_amount_,
                                      company_,                                
                                      tax_code_, 
                                      currency_rounding_);                                 
      price_um_    := sales_unit_meas_;
      chk_ser_ref_ := Customer_Order_Inv_Head_API.Get_Series_Reference__(company_, invoice_id_);

      IF (chk_ser_ref_ IS NULL) THEN
         debit_invoice_no_ := Invoice_API.Get_Invoice_No(company_, deb_invoice_id_);
         IF (debit_invoice_no_ IS NOT NULL) THEN
             series_id_ := Invoice_API.Get_Series_Id(company_, deb_invoice_id_);
         END IF;
      END IF;

      item_rec_.company             := company_;
      item_rec_.invoice_id          := invoice_id_;
      item_rec_.creator             := 'CUSTOMER_ORDER_INV_ITEM_API';
      item_rec_.c1                  := order_no_;
      item_rec_.c4                  := pos_;
      item_rec_.c5                  := catalog_no_;
      item_rec_.c6                  := catalog_desc_;
      item_rec_.n2                  := invoiced_qty_;
      item_rec_.n17                 := invoiced_qty_; 
      item_rec_.c7                  := sales_unit_meas_;
      item_rec_.n3                  := price_conv_factor_;
      item_rec_.c8                  := price_um_;
      item_rec_.n4                  := sale_unit_price_;
      item_rec_.n15                 := unit_price_incl_tax_;
      item_rec_.c9                  := customer_po_no_;
      item_rec_.c10                 := contract_;
      item_rec_.n8                  := stage_;
      item_rec_.net_curr_amount     := net_curr_amount_ * -1;
      item_rec_.vat_curr_amount     := tax_curr_amount_ * -1;
      item_rec_.vat_code            := tax_code_;
      item_rec_.series_reference    := series_id_;
      item_rec_.number_reference    := debit_invoice_no_;
      item_rec_.prel_update_allowed := prel_update_allowed_;
      item_rec_.c12                 := '*';

      IF (order_no_ IS NOT NULL) THEN
         item_rec_.c13 := customer_no_;
      END IF;
      item_rec_.taxable := 'FALSE';
      item_rec_.deliv_type_id := deliv_type_id_;

      -- Create reference (The key to identify from creating module)
      -- Fetch next ivc item no from sequence.

      SELECT customer_order_inv_item_seq.nextval
      INTO ivc_item_seq_no_
      FROM dual;

      reference_ := 'CO-' || TO_CHAR(ivc_item_seq_no_);
      item_rec_.reference := reference_;

      tax_rec_.company := company_; 
      tax_rec_.source_ref_type := Tax_Source_API.DB_INVOICE;
      tax_rec_.source_ref1 := invoice_id_;
      tax_rec_.source_ref2 := item_id_; 
      tax_rec_.source_ref3 := '*';
      tax_rec_.source_ref4 := '*';
      tax_rec_.source_ref5 := '*';
      tax_rec_.tax_item_id := 1;
      tax_rec_.tax_code := tax_code_; 
      tax_rec_.tax_percentage := tax_percentage_;
      tax_rec_.tax_curr_amount := tax_curr_amount_ * -1;
      --tax_rec_.total_tax_curr_amount := tax_curr_amount_ * -1;
      tax_rec_.tax_base_curr_amount := net_curr_amount_ * -1;
   
      Tax_Handling_Invoic_Util_API.Calc_Tax_Dom_Amount(tax_rec_.tax_dom_amount, 
                                                tax_rec_.tax_dom_amount,
                                                tax_rec_.non_ded_tax_dom_amount,
                                                tax_rec_.tax_base_dom_amount,                                              
                                                company_,
                                                Party_Type_API.DB_CUSTOMER,
                                                headrec_.currency, 
                                                headrec_.adv_inv,
                                                headrec_.creator,   
                                                tax_rec_.tax_code,
                                                tax_curr_amount_,
                                                tax_curr_amount_,
                                                tax_curr_amount_,
                                                net_curr_amount_,
                                                tax_rec_.tax_percentage,
                                                headrec_.curr_rate,
                                                headrec_.tax_curr_rate,   
                                                headrec_.div_factor);
   
      tax_rec_.tax_dom_amount          := tax_rec_.tax_dom_amount * -1;
      tax_rec_.non_ded_tax_dom_amount  := tax_rec_.non_ded_tax_dom_amount * -1;
      tax_rec_.tax_base_dom_amount     := tax_rec_.tax_base_dom_amount * -1;
      
      item_rec_.vat_dom_amount := tax_rec_.tax_dom_amount;
      -- Create the invoice item in the Invoice module
      Customer_Invoice_Pub_Util_API.Create_Invoice_Item(item_rec_);
                                             
      Source_Tax_Item_Invoic_API.New(tax_rec_);

      -- Inserting a record to the cust_prepaym_consumption_tab
      Client_SYS.Clear_Attr(cons_attr_);
      Client_SYS.Add_To_Attr('COMPANY', company_, cons_attr_);
      Client_SYS.Add_To_Attr('PREPAYMENT_INVOICE_ID', deb_invoice_id_ , cons_attr_);
      Client_SYS.Add_To_Attr('PREPAYMENT_INVOICE_ITEM', deb_item_id_ , cons_attr_);
      Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, cons_attr_);
      Client_SYS.Add_To_Attr('ITEM_ID', item_id_, cons_attr_);
      Client_SYS.Add_To_Attr('CONSUMED_AMOUNT', unconsumed_gross_amount_, cons_attr_);

      Cust_Prepaym_Consumption_API.New(cons_attr_);
   END IF;
EXCEPTION
   WHEN others THEN
      RAISE;
END Create_Credit_Prepaym_Item___;


-- Create_Credit_Prepaym_Items___
--   General method for create credit invoice lines for all the prepayment invoices.
PROCEDURE Create_Credit_Prepaym_Items___ (
   item_rec_       IN Public_Rec,
   cre_invoice_id_ IN NUMBER )
IS
   temp_item_id_      CUSTOMER_ORDER_INV_ITEM.item_id%TYPE;   
   invoiced_qty_      NUMBER;

BEGIN
   invoiced_qty_ := item_rec_.invoiced_qty;
   temp_item_id_ := item_rec_.item_id;
   -- Call to Item method.
   Create_Credit_Prepaym_Item___ (temp_item_id_, cre_invoice_id_, item_rec_.price_conv,
                                  NVL(item_rec_.sale_unit_price, item_rec_.charge_percent * item_rec_.charge_percent_basis / 100), 
                                  NVL(item_rec_.unit_price_incl_tax, item_rec_.charge_percent * item_rec_.charge_percent_basis / 100),
                                  invoiced_qty_, item_rec_.stage, item_rec_.invoice_id, item_rec_.item_id,
                                  item_rec_.contract, item_rec_.order_no, item_rec_.catalog_no,
                                  item_rec_.description, item_rec_.vat_code, item_rec_.customer_po_no,
                                  item_rec_.sale_um, item_rec_.deliv_type_id, item_rec_.prel_update_allowed);
   
END Create_Credit_Prepaym_Items___;


-- Calc_Line_Amount_For_Prepay___
--   This method will calculate line amount and tax amounts for credit
--   prepayment credit invoices.
PROCEDURE Calc_Line_Amount_For_Prepay___ (
   net_curr_amount_   OUT NUMBER,
   vat_curr_amount_   OUT NUMBER,
   tax_percentage_    OUT NUMBER,
   gross_curr_amount_ IN  NUMBER,
   company_           IN  VARCHAR2,
   tax_code_          IN  VARCHAR2,
   currency_rounding_ IN  NUMBER )
IS
BEGIN
   tax_percentage_  := Statutory_Fee_API.Get_Percentage(company_, tax_code_);
   net_curr_amount_ := ROUND((gross_curr_amount_ * 100)/(tax_percentage_ + 100), currency_rounding_);
   vat_curr_amount_ := gross_curr_amount_ - net_curr_amount_;
END Calc_Line_Amount_For_Prepay___;


-- Calc_Line_Amount_For_Prepay___
--   This method will calculate line amount and tax amounts for credit
--   prepayment credit invoices.
PROCEDURE Calc_Line_Amount_For_Prepay___ (
   net_curr_amount_   OUT NUMBER,
   vat_curr_amount_   OUT NUMBER,
   tax_percentage_    OUT NUMBER,
   tax_msg_           IN  OUT VARCHAR2,
   gross_curr_amount_ IN  NUMBER,
   company_           IN  VARCHAR2,
   cre_invoice_id_    IN  NUMBER,
   cre_item_id_       IN  NUMBER,
   deb_invoice_id_    IN  NUMBER,
   deb_item_id_       IN  NUMBER,
   tax_code_          IN  VARCHAR2,
   currency_rounding_ IN  NUMBER,
   from_create_cre_prepaym_ IN BOOLEAN)
IS
   headrec_         Invoice_API.Public_Rec;
   total_tax_dom_amount_      NUMBER;
   tax_dom_amount_            NUMBER;
   non_ded_tax_dom_amount_    NUMBER;
   tax_base_dom_amount_       NUMBER;
   dummy_attr_                VARCHAR2(200);
   tax_parallel_amount_       NUMBER; 
   non_ded_tax_parallel_amount_ NUMBER; 
   tax_base_parallel_amount_  NUMBER;
BEGIN
   tax_percentage_  := Statutory_Fee_API.Get_Percentage(company_, tax_code_);
   net_curr_amount_ := ROUND((gross_curr_amount_ * 100)/(tax_percentage_ + 100), currency_rounding_);
   vat_curr_amount_ := gross_curr_amount_ - net_curr_amount_;
   
   IF from_create_cre_prepaym_ THEN
      Source_Tax_Item_API.Get_Tax_Item_Msg(tax_msg_, company_, Tax_Source_API.DB_INVOICE, To_CHAR(deb_invoice_id_), To_CHAR(deb_item_id_), '*', '*', '*');
      headrec_   := Invoice_API.Get(company_, deb_invoice_id_);
   ELSE
      Source_Tax_Item_API.Get_Tax_Item_Msg(tax_msg_, company_, Tax_Source_API.DB_INVOICE, To_CHAR(cre_invoice_id_), To_CHAR(cre_item_id_), '*', '*', '*');
      headrec_   := Invoice_API.Get(company_, cre_invoice_id_);
   END IF;
         
   -- Pre-payment invoice line could have only one tax code.
   Message_SYS.Set_Attribute(tax_msg_, 'TAX_CODE', tax_code_);
   Message_SYS.Set_Attribute(tax_msg_, 'TAX_PERCENTAGE', tax_percentage_);
   Message_SYS.Set_Attribute(tax_msg_, 'TAX_CURR_AMOUNT', vat_curr_amount_ * -1);
   Message_SYS.Set_Attribute(tax_msg_, 'TAX_BASE_CURR_AMOUNT', net_curr_amount_ * -1);

   Tax_Handling_Invoic_Util_API.Calc_Tax_Dom_Amount(total_tax_dom_amount_, 
                                       tax_dom_amount_,
                                       non_ded_tax_dom_amount_,
                                       tax_base_dom_amount_,                                              
                                       company_,
                                       Party_Type_API.DB_CUSTOMER,
                                       headrec_.currency, 
                                       headrec_.adv_inv,
                                       headrec_.creator,   
                                       tax_code_,
                                       vat_curr_amount_,
                                       vat_curr_amount_,
                                       vat_curr_amount_,
                                       net_curr_amount_,
                                       tax_percentage_,
                                       headrec_.curr_rate,
                                       headrec_.tax_curr_rate,   
                                       headrec_.div_factor);
                                       
   Tax_Handling_Util_API.Calc_Tax_Para_Amount(tax_parallel_amount_, 
                                             tax_parallel_amount_, 
                                             non_ded_tax_parallel_amount_, 
                                             tax_base_parallel_amount_, 
                                             dummy_attr_, 
                                             company_, 
                                             headrec_.currency, 
                                             'TRUE', 
                                             vat_curr_amount_, 
                                             tax_dom_amount_, 
                                             vat_curr_amount_, 
                                             tax_dom_amount_, 
                                             gross_curr_amount_, 
                                             tax_base_dom_amount_, 
                                             headrec_.parallel_curr_rate, 
                                             headrec_.parallel_div_factor);                                     

   Message_SYS.Set_Attribute(tax_msg_, 'TAX_DOM_AMOUNT', tax_dom_amount_ * -1);
   Message_SYS.Set_Attribute(tax_msg_, 'TAX_BASE_DOM_AMOUNT', tax_base_dom_amount_ *-1);
   
   Message_SYS.Set_Attribute(tax_msg_, 'TAX_PARALLEL_AMOUNT', tax_parallel_amount_ * -1);
   Message_SYS.Set_Attribute(tax_msg_, 'TAX_BASE_PARALLEL_AMOUNT', tax_base_parallel_amount_ * -1);
         
END Calc_Line_Amount_For_Prepay___;


FUNCTION Calc_Rebate_Booking_In_Curr___ (
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   booking_cost_ IN NUMBER ) RETURN NUMBER
IS
   headrec_       Customer_Order_Inv_Head_API.Public_Rec;
   curr_type_     VARCHAR2(10);
   conv_factor_   NUMBER;
   rate_          NUMBER;
   booking_       NUMBER;
BEGIN
   headrec_   := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);
   curr_type_ := headrec_.currency_rate_type;
   Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, conv_factor_, rate_, company_, headrec_.currency_code,
                                                  SYSDATE, 'CUSTOMER', headrec_.customer_no);
   rate_ := rate_ / conv_factor_;

   IF (Company_Finance_API.Get_Currency_Code(company_) = headrec_.currency_code) THEN
      booking_ := booking_cost_;
   ELSE
      IF (rate_ = 0) THEN
         booking_ := 0;
      ELSE
         booking_ := booking_cost_ / rate_;
      END IF;
   END IF;
   RETURN booking_;
END Calc_Rebate_Booking_In_Curr___;


-- Check_Exist___
--   Check if a specific LU-instance already exist in the database.
FUNCTION Check_Exist___ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Exist___;


PROCEDURE Fetch_Tax_Liability_Info___ (
   tax_liability_          OUT VARCHAR2,
   tax_liability_type_db_  OUT VARCHAR2,
   taxable_db_             OUT VARCHAR2,
   company_                IN VARCHAR2,
   invoice_id_             IN  NUMBER,
   item_id_                IN  NUMBER )
IS
   order_line_rec_         Customer_Order_Line_API.Public_Rec;
   order_no_               VARCHAR2(12);
   line_no_                VARCHAR2(5);
   rel_no_                 VARCHAR2(5);
   line_item_no_           NUMBER;
   chg_seq_no_             NUMBER;
   rma_no_                 NUMBER;
   rma_line_no_            NUMBER;
   rma_charge_no_          NUMBER; 
   shipment_id_            NUMBER;
   headrec_                Customer_Order_Inv_Head_API.Public_Rec;
      
   CURSOR get_cust_ord_invoice_info IS
      SELECT rma_no, rma_line_no, rma_charge_no, order_no, line_no, release_no, line_item_no, charge_seq_no, taxable_db
      FROM   customer_order_inv_item 
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
BEGIN
   headrec_ := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);
   
   OPEN get_cust_ord_invoice_info;
   FETCH get_cust_ord_invoice_info INTO rma_no_, rma_line_no_, rma_charge_no_, order_no_, line_no_, rel_no_, line_item_no_, chg_seq_no_, taxable_db_;
   CLOSE get_cust_ord_invoice_info;
   
   -- RMA Line Invoice
   IF (rma_no_ IS NOT NULL AND rma_line_no_ IS NOT NULL AND rma_charge_no_ IS NULL)THEN      
      tax_liability_         := Return_Material_Line_API.Get_Tax_Liability(rma_no_, rma_line_no_);
      tax_liability_type_db_ := Return_Material_Line_API.Get_Tax_Liability_Type_Db(rma_no_, rma_line_no_);
   
   -- RMA Charge Invoice
   ELSIF (rma_no_ IS NOT NULL AND rma_charge_no_ IS NOT NULL) THEN      
      tax_liability_         := Return_Material_Charge_API.Get_Tax_Liability(rma_no_, rma_charge_no_);
      tax_liability_type_db_ := Return_Material_Charge_API.Get_Tax_Liability_Type_Db(rma_no_, rma_charge_no_);
      
   -- Customer Order Line Invoice
   ELSIF (order_no_ IS NOT NULL AND line_no_ IS NOT NULL AND rel_no_ IS NOT NULL AND chg_seq_no_ IS NULL) THEN      
      order_line_rec_        := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
      tax_liability_         := order_line_rec_.tax_liability;
      IF (Order_Supply_Type_API.Encode(order_line_rec_.demand_code) = 'IPD') THEN
         tax_liability_type_db_ := External_Cust_Order_Line_API.Get_Tax_Liability(order_no_, line_no_, rel_no_);
      ELSE
         tax_liability_type_db_ := order_line_rec_.tax_liability_type;
      END IF;
      
   -- Customer Order Charge Invoice
   ELSIF (order_no_ IS NOT NULL AND chg_seq_no_ IS NOT NULL) THEN
      tax_liability_         := Customer_Order_Charge_API.Get_Connected_Tax_Liability(order_no_, chg_seq_no_);
      tax_liability_type_db_ := Customer_Order_Charge_API.Get_Conn_Tax_Liability_Type_Db(order_no_, chg_seq_no_);
      
   -- Shipment Freight Charge Invoice
   ELSIF (order_no_ IS NULL AND shipment_id_ IS NOT NULL AND chg_seq_no_ IS NOT NULL) THEN
      tax_liability_         := Shipment_Freight_Charge_API.Get_Tax_Liability(shipment_id_, chg_seq_no_);
      tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_liability_, Shipment_API.Get_Receiver_Country(shipment_id_)); 
     
   -- Rebate Invoice
   ELSIF (order_no_ IS NULL AND rma_no_ IS NULL AND shipment_id_ IS NULL) THEN
      Tax_Handling_Util_API.Get_Cust_Tax_Liability_Info(tax_liability_, tax_liability_type_db_,
                                                        headrec_.delivery_identity, headrec_.delivery_address_id,
                                                        company_, headrec_.supply_country, 
                                                        Customer_Info_Address_API.Get_Country_Code(headrec_.delivery_identity, headrec_.delivery_address_id));
      
   END IF;
END Fetch_Tax_Liability_Info___;


----------------------------------------------------------------------------
-- Add_Reb_Aggr_Line_Postings___
--    This procedure adds lines to the reb_aggr_line_posting_tmp for used in rebate settlement postings. 
----------------------------------------------------------------------------
 
PROCEDURE Add_Reb_Aggr_Line_Post___ (
   aggregation_no_            IN NUMBER,
   aggr_line_no_              IN NUMBER,
   is_final_                  IN VARCHAR2,
   invoice_id_                IN NUMBER,
   invoice_item_id_           IN NUMBER, 
   company_                   IN VARCHAR2,
   event_code_                IN VARCHAR2,
   booking_                   IN NUMBER, 
   accounting_date_           IN DATE 
   ) 
IS
   stmt_                      VARCHAR2(32000) := NULL;
   stmt1_                     VARCHAR2(4000) := NULL ;
   columns_                   VARCHAR2(4000) := NULL;
   j_                         VARCHAR2(20);
   str_code_                  VARCHAR2(10);
   code_part_name_            VARCHAR2(20);
   control_type_value_table_  Posting_Ctrl_Public_API.control_type_value_table;
           
   CURSOR get_str_code IS
      SELECT DISTINCT(str_code) 
      FROM ACC_EVENT_POSTING_TYPE_PUB
      WHERE event_code = event_code_
      AND booking = booking_;   

BEGIN
   
   OPEN get_str_code;
   FETCH get_str_code INTO str_code_; -- posting type
   CLOSE get_str_code;
   
   IF (Posting_Ctrl_Allowed_Comb_API.Any_Posting_Type_Exist(str_code_) = 'TRUE') THEN
      IF NOT (Posting_Ctrl_API.Posting_Type_Exist(company_, 'A', str_code_)) THEN
         code_part_name_ := Accounting_Code_Parts_API.Get_Name(company_, 'A');
         Error_SYS.Appl_General(lu_name_, 'NOPOSTINGTYPE: Posting type :P1 is missing in Posting Control for company :P2 and code part :P3.', str_code_, company_, code_part_name_);
      END IF;
   END IF;
   
   
   Posting_Ctrl_Public_API.Get_Control_Type(control_type_value_table_,
                                             str_code_,
                                             company_,
                                             accounting_date_);
                                             
   j_ := control_type_value_table_.FIRST;
   WHILE j_ IS NOT NULL LOOP
      IF (columns_ IS NULL) THEN
        columns_ := j_;
      ELSE
        columns_ := columns_ || ', ' || j_;
      END IF;
      IF stmt1_ IS NULL THEN
         stmt1_ := 'invoiced_periodic_lines_.' || j_;
      ELSE
         stmt1_ := stmt1_ || ', ' || 'invoiced_periodic_lines_.' || j_;
      END IF;
      j_ := control_type_value_table_.NEXT(j_);
   END LOOP;
   
   stmt_ := 'DECLARE
                CURSOR get_invoiced_lines  IS
                     SELECT ' ||  columns_ || ', SUM(TOTAL_REBATE_COST_AMOUNT) total_rebate_cost_amount, SUM(TOTAL_REBATE_AMOUNT) total_rebate_amount
                     FROM reb_aggr_line_cntrl_type_tmp
                     WHERE aggregation_no = :aggregation_no
                     AND aggr_line_no = :aggr_line_no
                     AND company = :company
                     AND is_final = :is_final
                     AND booking = :booking
                     GROUP BY ' ||  columns_ || ';   
            BEGIN
                FOR invoiced_periodic_lines_ IN get_invoiced_lines LOOP
                    INSERT INTO reb_aggr_line_posting_tmp (
                     reb_aggr_posting_id, aggregation_no, aggr_line_no, company, is_final, booking, invoice_id, invoice_item_id, 
                     posting_type, total_rebate_cost_amount,  total_rebate_amount, ' || columns_ || ' )
                     values 
                     (REB_AGGR_LINE_POSTING_SEQ.nextval, :aggregation_no, :aggr_line_no, :company, :is_final, :booking, :invoice_id, :invoice_item_id, 
                      :posting_type, invoiced_periodic_lines_.total_rebate_cost_amount, invoiced_periodic_lines_.total_rebate_amount, ' || stmt1_ || ' );
                      null;

                END LOOP;
            END;';
            @ApproveDynamicStatement(2016-12-31,AmPalk) 
            EXECUTE IMMEDIATE stmt_
               USING IN aggregation_no_,
                     IN aggr_line_no_,
                     IN company_,
                     IN is_final_,
                     IN booking_,
                     IN invoice_id_,
                     IN invoice_item_id_,
                     IN str_code_ ;
   
END Add_Reb_Aggr_Line_Post___;


PROCEDURE Add_Transaction_Tax_Info___(
   vat_curr_amount_       IN OUT NUMBER,
   vat_dom_amount_        IN OUT NUMBER, -- missing parameter in the customer invoice line overview
   gross_curr_amount_     IN OUT NUMBER,
   net_curr_amount_       IN OUT NUMBER,
   tax_code_              IN OUT VARCHAR2,
   tax_calc_structure_id_ IN OUT VARCHAR2,
   company_               IN     VARCHAR2,
   invoice_id_            IN     NUMBER,
   item_id_               IN     NUMBER,
   calc_base_             IN     VARCHAR2,
   identity_              IN     VARCHAR2,
   currency_              IN     VARCHAR2,
   inv_curr_rate_         IN     NUMBER,
   tax_curr_rate_         IN     NUMBER,
   invoice_date_          IN     DATE ) 
IS
   tax_calc_method_       VARCHAR2(50);
   advance_prepay_inv_    VARCHAR2(5);
   old_tax_code_          VARCHAR2(20);
   dummy_string_          VARCHAR2(20000);
   dummy_attr_            VARCHAR2(32000);
   dummy_number_          NUMBER ;
   invoice_id_local_      NUMBER := invoice_id_;
   item_id_local_         NUMBER := item_id_;
BEGIN
   old_tax_code_ := Get_Vat_Code(company_, invoice_id_, item_id_);
   -- the following block is missing in the customer invoice line overview
   -- start
   tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);

   IF (tax_code_ != old_tax_code_ AND tax_calc_method_ = 'NOT_USED') THEN 
      invoice_id_local_ := null;
      item_id_local_    := null;
   END IF;
   -- end   
   advance_prepay_inv_ := Invoice_API.Is_Adv_Or_Prepay_Based_Inv(company_, invoice_id_);
   
   Tax_Handling_Invoic_Util_API.Add_Transaction_Tax_Info(dummy_string_,
                                                         dummy_string_,
                                                         dummy_string_,
                                                         dummy_string_,
                                                         dummy_string_,
                                                         dummy_string_,
                                                         dummy_number_,
                                                         vat_curr_amount_,
                                                         vat_dom_amount_, -- this parameter has been sent as number null in the customer invoice overview
                                                         dummy_number_,
                                                         dummy_number_,
                                                         dummy_number_,
                                                         dummy_number_,
                                                         dummy_number_,
                                                         dummy_number_,
                                                         gross_curr_amount_,
                                                         net_curr_amount_,
                                                         tax_code_,
                                                         tax_calc_structure_id_,
                                                         dummy_attr_,
                                                         company_,
                                                         identity_,
                                                         '',
                                                         'CUSTOMER',
                                                         currency_,
                                                         '',
                                                         '',
                                                         '',
                                                         '',
                                                         'FALSE',
                                                         NULL,
                                                         'CUSTOMER_ORDER_INV_HEAD_API',
                                                         advance_prepay_inv_,
                                                         '',
                                                         '',
                                                         calc_base_,
                                                         '',
                                                         '',
                                                         invoice_id_,
                                                         item_id_,
                                                         inv_curr_rate_, -- this parameter has been sent as string null in the customer invoice overview
                                                         tax_curr_rate_, -- this parameter has been sent as string null in the customer invoice overview
                                                         '',
                                                         '',
                                                         '',
                                                         invoice_date_);
END Add_Transaction_Tax_Info___;

-- gelr:disc_price_rounded, begin
-- Call this method only if the Discounted Price Rounded is enabled and no Price incl Tax.
FUNCTION Get_Line_Discount_Amount___(
   company_           IN VARCHAR2,
   invoice_id_        IN NUMBER,
   item_id_           IN NUMBER,
   discount_no_       IN NUMBER,
   invoiced_qty_      IN NUMBER,
   price_conv_factor_ IN NUMBER,
   currency_rounding_ IN NUMBER) RETURN NUMBER
IS
   CURSOR get_line_discount IS
      SELECT ROUND(calculation_basis, currency_rounding_) price_before_disc,
             ROUND(price_currency, currency_rounding_) price_after_disc,
             discount_line_no
      FROM   cust_invoice_item_discount_tab t
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_
      AND    discount_no = discount_no_;

   CURSOR get_prev_price_after_disc(discount_line_no_ NUMBER) IS
      SELECT ROUND(price_currency, currency_rounding_) price_after_disc
      FROM   cust_invoice_item_discount_tab t
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_
      AND    discount_line_no < discount_line_no_
      ORDER BY discount_line_no DESC;

   discount_rec_     get_line_discount%ROWTYPE;
   net_before_disc_  NUMBER;
   net_after_disc_   NUMBER;
   discount_amount_  NUMBER;
   price_before_disc_ NUMBER;
BEGIN
   OPEN get_line_discount;
   FETCH get_line_discount INTO discount_rec_;
   CLOSE get_line_discount;
   
   OPEN get_prev_price_after_disc(discount_rec_.discount_line_no);
   FETCH get_prev_price_after_disc INTO price_before_disc_;
   IF (get_prev_price_after_disc%NOTFOUND) THEN
      price_before_disc_ := discount_rec_.price_before_disc;
   END IF;
   CLOSE get_prev_price_after_disc;
   
   net_before_disc_ := ROUND(             price_before_disc_ * invoiced_qty_, currency_rounding_) * price_conv_factor_;
   net_after_disc_  := ROUND(discount_rec_.price_after_disc  * invoiced_qty_, currency_rounding_) * price_conv_factor_;
   discount_amount_ := net_before_disc_ - net_after_disc_;
   
   RETURN discount_amount_;
END Get_Line_Discount_Amount___;
-- gelr:disc_price_rounded, end

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
@UncheckedAccess
FUNCTION Finite_State_Decode__ (
   db_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN   
   RETURN(Domain_SYS.Decode_(Domain_SYS.Get_Translated_Values(lu_name_), Get_Db_Values___, db_state_));
END Finite_State_Decode__;

-- These methods were added as a temporary solution to pass PLSQL model compliance test, because false state machine included in the LU.
@UncheckedAccess
FUNCTION Finite_State_Encode__ (
   client_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN   
   RETURN(Domain_SYS.Encode_(Domain_SYS.Get_Translated_Values(lu_name_), Get_Db_Values___, client_state_));
END Finite_State_Encode__;

@UncheckedAccess
PROCEDURE Enumerate_States__ (
   client_values_ OUT VARCHAR2 )
IS
BEGIN
   client_values_ := Domain_SYS.Enumerate_(Domain_SYS.Get_Translated_Values(lu_name_));
END Enumerate_States__;

FUNCTION Get_Client_Values___ RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN('Prepared^Unposted^Posted^Cancelled^');
END Get_Client_Values___;

FUNCTION Get_Db_Values___ RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN('Prepared^Unposted^Posted^Cancelled^');
END Get_Db_Values___;

@UncheckedAccess
FUNCTION Finite_State_Events__ (
   db_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN NULL;
END Finite_State_Events__;

@UncheckedAccess
PROCEDURE Language_Refreshed
IS
BEGIN
   NULL;
END Language_Refreshed;


-- Modify__
--   Client-support interface to modify attributes for LU instances.
--   action_ = 'CHECK'
--   Check all attributes before modifying an existing object and
--   handle of information to client. The attribute list is unpacked,
--   checked and prepared(defaults) in procedure Unpack_Check_Update___.
--   action_ = 'DO'
--   Modification of an existing instance of the logical unit. The
--   procedure unpacks the attributes, checks all values before
--   procedure Update___ is called.
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   
   IF (action_ = 'DO') THEN
      IF (attr_ IS NOT NULL ) THEN 
         Modify_Invoice_Item___(objid_, attr_);
      END IF;
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Modify__;


-- Remove__
--   Client-support interface to remove LU instances.
--   action_ = 'CHECK'
--   Check whether a specific LU-instance may be removed or not.
--   The procedure fetches the complete record by calling procedure
--   Get_Object_By_Id___. Then the check is made by calling procedure
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_       CUSTOMER_ORDER_INV_ITEM%ROWTYPE;
   remattr_      VARCHAR2(2000);
   headrec_      Customer_Order_Inv_Head_API.Public_Rec;
   cor_inv_type_ VARCHAR2(20);
   col_inv_type_ VARCHAR2(20);
   message_      VARCHAR2(2000);

   CURSOR getrec IS
      SELECT *
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  objid = objid_;
BEGIN

   OPEN getrec;
      FETCH getrec INTO remrec_;
      IF (getrec%NOTFOUND) THEN
         Error_SYS.Record_Removed(lu_name_);
      END IF;
      CLOSE getrec;

   headrec_      := Customer_Order_Inv_Head_API.Get(remrec_.company, remrec_.invoice_id);
   cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(remrec_.company);
   col_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(remrec_.company);

   IF (action_ = 'CHECK') THEN
      -- Check if debit invoice
      IF (headrec_.invoice_type IN ('CUSTORDDEB', 'CUSTCOLDEB', 'SELFBILLDEB')) THEN
        Error_SYS.Record_General(lu_name_, 'NOTDELETEDEBIT: Invoice lines for a debit invoice cannot be removed.');
      END IF;
      -- Check if correction invoice
      IF (headrec_.invoice_type IN (cor_inv_type_, col_inv_type_)) THEN
         Error_sys.Record_General(lu_name_, 'NOTDELETEDCOR: Invoice lines for a correction invoice cannot be removed.');
      END IF;
   ELSIF (action_ = 'DO') THEN
      -- Check if debit invoice
      IF (headrec_.invoice_type IN ('CUSTORDDEB','CUSTCOLDEB', 'SELFBILLDEB')) THEN
        Error_SYS.Record_General(lu_name_, 'NOTDELETEDEBIT: Invoice lines for a debit invoice cannot be removed.');
      END IF;

      -- Check if correction invoice
      IF (headrec_.invoice_type IN (cor_inv_type_, col_inv_type_)) THEN
         Error_sys.Record_General(lu_name_, 'NOTDELETEDCOR: Invoice lines for a correction invoice cannot be removed.');
      END IF;

      IF (remrec_.rma_no IS NOT NULL) THEN
         IF (remrec_.rma_charge_no IS NULL) THEN
            Return_Material_Line_API.Modify_Cr_Invoice_Fields(remrec_.rma_no, remrec_.rma_line_no, NULL, NULL);
         ELSE
            Return_Material_Charge_API.Modify_Cr_Invoice_Fields(remrec_.rma_no, remrec_.rma_charge_no, NULL, NULL);
         END IF;
         IF (remrec_.order_no IS NOT NULL) THEN
            message_ := Language_SYS.Translate_Constant(lu_name_, 'REMORDERCREIVC: Removed from credit invoice :P1.', p1_ => headrec_.invoice_no);
            Customer_Order_History_API.New(remrec_.order_no, message_);
         END IF;
      END IF;
 
      Client_SYS.Clear_Attr(remattr_);
      Client_SYS.Add_To_Attr('COMPANY', remrec_.company, remattr_);
      Client_SYS.Add_To_Attr('SERIES_ID', headrec_.series_id, remattr_);
      Client_SYS.Add_To_Attr('INVOICE_NO', headrec_.invoice_no, remattr_);
      Client_SYS.Add_To_Attr('REFERENCE', remrec_.reference, remattr_);
      Client_SYS.Add_To_Attr('PARTY_TYPE', party_type_API.Decode('CUSTOMER'), remattr_);
      Client_SYS.Add_To_Attr('IDENTITY', remrec_.identity, remattr_);
      Trace_SYS.Field('remattr', remattr_);
      Cancel_Prelim_Item___(remattr_);
      -- Remove the Statistics entry if there is any.
      Cust_Ord_Invo_Stat_API.Remove_Invoice_Statistics(remrec_.company, remrec_.invoice_id, remrec_.item_id);

      -- Remove the project connection
      Remove_Project_Connection__(remrec_.company, remrec_.invoice_id,remrec_.item_id, 
                                  remrec_.order_no, remrec_.line_no, 
                                  remrec_.release_no, remrec_.line_item_no); 

   END IF;
   info_ := Client_SYS.Get_All_Info;
END Remove__;


-- Recalculate_Line_Amounts__
--   This method will only call the Calculate_Line_Amount___ and is mainly used
--   to update the line amounts based on the changed currency rates, tax rates.
PROCEDURE Recalculate_Line_Amounts__ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER )
IS

   currency_rounding_         NUMBER;
   net_curr_amount_           NUMBER;
   vat_curr_amount_           NUMBER;
   dummy_net_curr_amount_     NUMBER;
   dummy_vat_curr_amount_     NUMBER;
   gross_curr_amount_         NUMBER;   
   item_attr_                 VARCHAR2(2000);
   currency_                  VARCHAR2(3);
   invoice_type_              VARCHAR2(20);
   advance_cr_inv_type_       VARCHAR2(20);
   qty_                       NUMBER;
   prepay_deb_inv_type_       VARCHAR2(20);
   prepay_cre_inv_type_       VARCHAR2(20);
   stat_attr_                 VARCHAR2(32000);
   headrec_                   Customer_Order_Inv_Head_API.Public_Rec;
   buy_qty_due_               NUMBER;
   tax_percentage_            NUMBER;
   tax_dom_amount_            NUMBER;
   tax_para_amount_           NUMBER;   
   comp_bearing_tax_amt_      NUMBER;
   multiple_tax_              VARCHAR2(5);
   tax_msg_                   VARCHAR2(32000); 
   consider_ext_tax_curr_amt_ BOOLEAN;
   co_rebate_cre_inv_type_    VARCHAR2(20);
   prepay_calculation_        BOOLEAN := FALSE;

   -- gelr:prepayment_tax_document, added prepay_tax_document_id
   CURSOR get_item IS
      SELECT order_no, reference, discount, order_discount, additional_discount,
             vat_code, tax_calc_structure_id, invoiced_qty, price_conv, invoice_id,
             catalog_no, deliv_type_id, item_id, sale_unit_price, unit_price_incl_tax, line_no, release_no, line_item_no, prel_update_allowed,
             gross_curr_amount, contract, identity, charge_percent, charge_percent_basis, net_curr_amount, net_dom_amount, vat_dom_amount,
             free_of_charge_tax_basis, prepay_invoice_no, prepay_tax_document_id
      FROM   customer_order_inv_item
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_;

   item_rec_     get_item%ROWTYPE;
   new_item_rec_ get_item%ROWTYPE;
BEGIN

   headrec_ := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);

   OPEN get_item;
   FETCH get_item INTO item_rec_;
   CLOSE get_item;

   currency_            := Customer_Order_Inv_Head_API.Get_Currency(company_, invoice_id_);
   currency_rounding_   := Currency_Code_API.Get_Currency_Rounding(company_, currency_);
   invoice_type_        := Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, invoice_id_);
   qty_                 := item_rec_.invoiced_qty;
   advance_cr_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Cr_Inv_Type(company_);
   prepay_deb_inv_type_ := NVL(Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_), 'COPREPAYDEB');
   prepay_cre_inv_type_ := NVL(Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type(company_), 'COPREPAYCRE');
   co_rebate_cre_inv_type_ := NVL(Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(company_), 'COREBCRE');
   IF (invoice_type_ IN ('CUSTORDCRE', 'CUSTCOLCRE', 'SELFBILLCRE', advance_cr_inv_type_, co_rebate_cre_inv_type_)) THEN
      qty_ := qty_ * -1;
   END IF;
   
   IF (item_rec_.prepay_invoice_no IS NOT NULL AND invoice_type_ IN ('CUSTORDDEB', 'CUSTCOLDEB', 'SELFBILLDEB')) THEN
      prepay_calculation_ := TRUE;
   END IF; 

   -- Calculate the net curr amount and vat curr amount
   IF (item_rec_.prel_update_allowed = 'TRUE' OR prepay_calculation_) THEN
      IF (invoice_type_ IN (prepay_deb_inv_type_, prepay_cre_inv_type_) OR prepay_calculation_) THEN
         gross_curr_amount_ := item_rec_.gross_curr_amount  * -1;
         Calc_Line_Amount_For_Prepay___ (dummy_net_curr_amount_, 
                                         dummy_vat_curr_amount_,
                                         tax_percentage_,
                                         tax_msg_, 
                                         gross_curr_amount_, 
                                         company_, 
                                         invoice_id_, 
                                         item_id_,
                                         NULL,
                                         NULL,
                                         item_rec_.vat_code, 
                                         currency_rounding_,
                                         FALSE); 
                                         
         Client_SYS.Set_Item_Value('NET_CURR_AMOUNT', dummy_net_curr_amount_ * -1, item_attr_);
         Client_SYS.Set_Item_Value('VAT_CURR_AMOUNT', dummy_vat_curr_amount_ * -1, item_attr_);
      ELSE
         buy_qty_due_              := Customer_Order_Line_API.Get_Buy_Qty_Due(item_rec_.order_no, item_rec_.line_no, item_rec_.release_no, item_rec_.line_item_no);
         consider_ext_tax_curr_amt_ := (Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_) != External_Tax_Calc_Method_API.DB_NOT_USED);
         
         Calculate_Line_And_Tax_Amts___(tax_percentage_ ,multiple_tax_, vat_curr_amount_, tax_dom_amount_ , tax_para_amount_,
                                       gross_curr_amount_, net_curr_amount_, tax_msg_, item_rec_.vat_code,
                                       item_rec_.tax_calc_structure_id, company_, invoice_id_, item_id_,
                                       item_rec_.identity, item_rec_.contract, headrec_.invoice_type, Party_Type_API.DB_CUSTOMER,
                                       item_rec_.catalog_no, item_rec_.deliv_type_id, qty_, buy_qty_due_,
                                       NVL(item_rec_.unit_price_incl_tax, item_rec_.charge_percent * item_rec_.charge_percent_basis / 100),
                                       NVL(item_rec_.sale_unit_price, item_rec_.charge_percent * item_rec_.charge_percent_basis / 100),
                                       NULL, item_rec_.order_discount, item_rec_.additional_discount,
                                       item_rec_.price_conv, currency_rounding_, headrec_.use_price_incl_tax, item_rec_.free_of_charge_tax_basis, FALSE, consider_ext_tax_curr_amt_);
         
         tax_percentage_ := NVL(tax_percentage_, Source_Tax_Item_API.Get_Total_Tax_Percentage (company_,
                                                                                               Tax_Source_API.DB_INVOICE,
                                                                                               To_CHAR(invoice_id_),
                                                                                               To_CHAR(item_id_),
                                                                                               '*',
                                                                                               '*',
                                                                                               '*')); 
         IF (item_rec_.free_of_charge_tax_basis IS NOT NULL) THEN
            IF (Customer_Order_API.Get_Free_Of_Chg_Tax_Pay_Par_Db(item_rec_.order_no) = Tax_Paying_Party_API.DB_COMPANY) THEN
               comp_bearing_tax_amt_ := tax_dom_amount_;
               vat_curr_amount_      := 0;
               tax_dom_amount_       := 0; 
               tax_para_amount_      := 0; 
            END IF;
            net_curr_amount_ := 0;             
         END IF;
         Client_SYS.Set_Item_Value('N18', comp_bearing_tax_amt_, item_attr_);
         Client_SYS.Set_Item_Value('VAT_DOM_AMOUNT', tax_dom_amount_, item_attr_);
         Client_SYS.Set_Item_Value('VAT_PARALLEL_AMOUNT', tax_para_amount_, item_attr_); 
         -- gelr:prepayment_tax_document, begin
         IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'PREPAYMENT_TAX_DOCUMENT') = Fnd_Boolean_API.DB_TRUE AND 
            (item_rec_.prepay_tax_document_id IS NOT NULL OR 
            invoice_type_ = Company_Def_Invoice_Type_API.Get_Def_Co_Tax_Doc_Type(company_) OR invoice_type_ = Company_Def_Invoice_Type_API.Get_Def_Co_Cre_Tax_Doc_Type(company_))) THEN
            Client_SYS.Set_Item_Value('NET_CURR_AMOUNT', 0, item_attr_);
         ELSE 
            Client_SYS.Set_Item_Value('NET_CURR_AMOUNT', net_curr_amount_, item_attr_);
         END IF;
         -- gelr:prepayment_tax_document, end  
         Client_SYS.Set_Item_Value('VAT_CURR_AMOUNT', vat_curr_amount_, item_attr_); 
      END IF; 
   END IF;

   Client_SYS.Add_To_Attr('REFERENCE', item_rec_.reference, item_attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, item_attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, item_attr_);

   Customer_Invoice_Pub_Util_API.Modify_Invoice_Item(item_attr_, 'CUSTOMER_ORDER_INV_ITEM_API');
   
   Modify_Inv_Tax_Item___(company_, 
                          invoice_id_, 
                          item_id_, 
                          tax_msg_,
                          item_rec_.identity);
   OPEN get_item;
   FETCH get_item INTO new_item_rec_;
   CLOSE get_item;
   
   IF (item_rec_.net_curr_amount != new_item_rec_.net_curr_amount) OR 
      (item_rec_.net_dom_amount != new_item_rec_.net_dom_amount) OR
      (item_rec_.vat_dom_amount != new_item_rec_.vat_dom_amount) OR
      (item_rec_.sale_unit_price != new_item_rec_.sale_unit_price) OR
      (item_rec_.unit_price_incl_tax != new_item_rec_.unit_price_incl_tax) THEN

      Client_SYS.Clear_Attr(stat_attr_);
      Client_SYS.Add_To_Attr('NET_CURR_AMOUNT', new_item_rec_.net_curr_amount, stat_attr_);
      Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE', new_item_rec_.sale_unit_price * (headrec_.curr_rate / headrec_.div_factor), stat_attr_);
      --Client_SYS.Add_To_Attr('BASE_UNIT_PRICE_INCL_TAX', new_item_rec_.unit_price_incl_tax * (headrec_.curr_rate / headrec_.div_factor), stat_attr_);  -- SHKOLK statistics?
      Client_SYS.Add_To_Attr('GROSS_AMOUNT', new_item_rec_.net_dom_amount + new_item_rec_.vat_dom_amount, stat_attr_);
      Client_SYS.Add_To_Attr('NET_AMOUNT', new_item_rec_.net_dom_amount, stat_attr_);
      Cust_Ord_Invo_Stat_API.Modify_Invoice_Statistics(stat_attr_, company_, invoice_id_, item_id_);
   END IF;
END Recalculate_Line_Amounts__;


-- Create_Prepayment_Inv_Line__
--   This will create a prepayment invoice line and tax for it.
PROCEDURE Create_Prepayment_Inv_Line__ (
   attr_ IN VARCHAR2 )
IS
   company_                   CUSTOMER_ORDER_INV_ITEM.company%TYPE;
   invoice_id_                CUSTOMER_ORDER_INV_ITEM.invoice_id%TYPE;
   pos_                       CUSTOMER_ORDER_INV_ITEM.pos%TYPE;
   order_no_                  CUSTOMER_ORDER_INV_ITEM.order_no%TYPE;
   description_               CUSTOMER_ORDER_INV_ITEM.description%TYPE;
   reference_                 VARCHAR2(100);
   tax_code_                  VARCHAR2(20);
   deb_invoice_type_          VARCHAR2(20);
   invoice_type_              VARCHAR2(20);
   tax_percentage_            NUMBER;
   net_curr_amount_           NUMBER;
   tax_curr_amount_           NUMBER;
   gross_curr_amount_         NUMBER;
   ivc_item_seq_no_           NUMBER;
   payment_date_              DATE;
   prepay_invoice_no_         VARCHAR2(50);
   prepay_invoice_series_id_  VARCHAR2(20);
   item_rec_                  Customer_Invoice_Pub_Util_API.customer_invoice_item_rec;   
   tax_rec_                   source_tax_item_tab%ROWTYPE;
   co_rec_                    Customer_Order_API.Public_Rec;
   customer_no_               CUSTOMER_ORDER_TAB.customer_no%TYPE;
   headrec_         Invoice_API.Public_Rec;
   dummy_attr_                VARCHAR2(200);
   max_item_id_               NUMBER;
   item_id_                   NUMBER;
   -- gelr:delivery_types_in_pbi, begin
   deliv_type_id_             VARCHAR2(20);
   -- gelr:delivery_types_in_pbi, end
   CURSOR get_pos IS
      SELECT to_char(max(to_number(pos)))
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_;

BEGIN

   company_                   := Client_SYS.Get_Item_Value('COMPANY', attr_);
   invoice_id_                := Client_SYS.Get_Item_Value('INVOICE_ID', attr_);
   order_no_                  := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
   payment_date_              := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('PAYMENT_DATE', attr_));
   prepay_invoice_no_         := Client_SYS.Get_Item_Value('PREPAY_INVOICE_NO', attr_);
   prepay_invoice_series_id_  := Client_SYS.Get_Item_Value('PREPAY_INVOICE_SERIES_ID', attr_);
   tax_code_                  := Client_SYS.Get_Item_Value('FEE_CODE', attr_);
   tax_percentage_            := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('FEE_PERCENTAGE', attr_));
   net_curr_amount_           := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('NET_CURR_AMOUNT', attr_));
   tax_curr_amount_           := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('TAX_CURR_AMOUNT', attr_));
   gross_curr_amount_         := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('GROSS_CURR_AMOUNT', attr_));
   description_               := Client_SYS.Get_Item_Value('DESCRIPTION', attr_);
   -- gelr:delivery_types_in_pbi, begin
   deliv_type_id_             := Client_SYS.Get_Item_Value('DELIV_TYPE_ID', attr_);
   -- gelr:delivery_types_in_pbi, end   
   deb_invoice_type_          := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_);

   OPEN get_pos;
   FETCH get_pos INTO pos_;
   IF (pos_ IS NOT NULL) THEN
      pos_ := to_char(to_number(pos_) + 1);
   ELSE
      pos_ := '1';
   END IF;
   CLOSE get_pos;
   
   max_item_id_  := Invoice_Item_API.Get_Max_Item_Id(company_, invoice_id_);
   item_id_      := 1 + max_item_id_;

   item_rec_.company         := company_;
   item_rec_.invoice_id      := invoice_id_;
   item_rec_.creator         := 'CUSTOMER_ORDER_INV_ITEM_API';
   item_rec_.c1              := order_no_;
   item_rec_.c4              := pos_;
   item_rec_.c5              := NULL;
   item_rec_.c6              := description_;
   item_rec_.c10             := Customer_Order_API.Get_Contract(order_no_);
   item_rec_.c13             := Customer_Order_API.Get_Customer_No(order_no_);
   item_rec_.d4              := payment_date_;
   item_rec_.c14             := prepay_invoice_no_;
   item_rec_.c15             := prepay_invoice_series_id_;
   item_rec_.n2              := 1;
   item_rec_.n17             := 1;
   item_rec_.n3              := 1; -- price_conv
   item_rec_.n4              := 0;
   item_rec_.n15             := 0;
   item_rec_.n5              := 0; -- discount
   item_rec_.n6              := 0; -- order_discount
   item_rec_.n12             := 0; -- additional_discount
   item_rec_.net_curr_amount := net_curr_amount_;
   item_rec_.vat_curr_amount := tax_curr_amount_;
   item_rec_.vat_code        := tax_code_;
   -- gelr:delivery_types_in_pbi, begin
   item_rec_.deliv_type_id   := deliv_type_id_;
   -- gelr:delivery_types_in_pbi, end      
   invoice_type_             := Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, invoice_id_);

   IF (deb_invoice_type_ = invoice_type_) THEN
      item_rec_.prel_update_allowed := 'TRUE';
   ELSE
      item_rec_.prel_update_allowed := 'FALSE';
   END IF;
   
   -- Fetch the delivery address to store in invoice_item_tab for the final invoice prepayment lines
   IF (prepay_invoice_no_ IS NOT NULL) THEN
      item_rec_.c19 := Customer_Order_API.Get_Ship_Addr_No(order_no_);
   END IF;
   -- Fetch next ivc item no from sequence.
   SELECT customer_order_inv_item_seq.nextval
   INTO ivc_item_seq_no_
   FROM dual;

   reference_          := 'CO-' || TO_CHAR(ivc_item_seq_no_);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
   item_rec_.reference := reference_;

   co_rec_ := Customer_Order_API.Get( order_no_ );
   customer_no_ := nvl(co_rec_.customer_no_pay, co_rec_.customer_no);
   
   --headrec_ := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);
   headrec_   := Invoice_API.Get(company_, invoice_id_);
   
   tax_rec_.company := company_; 
   tax_rec_.source_ref_type := Tax_Source_API.DB_INVOICE;
   tax_rec_.source_ref1 := invoice_id_;
   tax_rec_.source_ref2 := item_id_; 
   tax_rec_.source_ref3 := '*';
   tax_rec_.source_ref4 := '*';
   tax_rec_.source_ref5 := '*';
   tax_rec_.tax_item_id := 1;
   tax_rec_.tax_code := tax_code_; 
   tax_rec_.tax_percentage := tax_percentage_;
   tax_rec_.tax_curr_amount := tax_curr_amount_;
   --tax_rec_.total_tax_curr_amount := tax_curr_amount_;
   tax_rec_.tax_base_curr_amount := net_curr_amount_;
   
   Tax_Handling_Invoic_Util_API.Calc_Tax_Dom_Amount(tax_rec_.tax_dom_amount, 
                                             tax_rec_.tax_dom_amount,
                                             tax_rec_.non_ded_tax_dom_amount,
                                             tax_rec_.tax_base_dom_amount,                                              
                                             company_,
                                             Party_Type_API.DB_CUSTOMER,
                                             headrec_.currency, 
                                             headrec_.adv_inv,
                                             headrec_.creator,   
                                             tax_rec_.tax_code,
                                             tax_rec_.tax_curr_amount,
                                             tax_rec_.tax_curr_amount,
                                             tax_rec_.tax_curr_amount,
                                             tax_rec_.tax_base_curr_amount,
                                             tax_rec_.tax_percentage,
                                             headrec_.curr_rate,
                                             headrec_.tax_curr_rate,   
                                             headrec_.div_factor);
                                             
   Tax_Handling_Util_API.Calc_Tax_Para_Amount(tax_rec_.tax_parallel_amount, 
                                             tax_rec_.tax_parallel_amount, 
                                             tax_rec_.non_ded_tax_parallel_amount, 
                                             tax_rec_.tax_base_parallel_amount, 
                                             dummy_attr_, 
                                             company_, 
                                             headrec_.currency, 
                                             'TRUE', 
                                             tax_rec_.tax_curr_amount, 
                                             tax_rec_.tax_dom_amount, 
                                             tax_rec_.tax_curr_amount, 
                                             tax_rec_.tax_dom_amount, 
                                             tax_rec_.tax_base_curr_amount, 
                                             tax_rec_.tax_base_dom_amount, 
                                             headrec_.parallel_curr_rate, 
                                             headrec_.parallel_div_factor);  
                                             
   item_rec_.vat_dom_amount      :=  tax_rec_.tax_dom_amount;
   item_rec_.vat_parallel_amount :=  tax_rec_.tax_parallel_amount;
   
   -- Create the invoice item in the Invoice module
   Customer_Invoice_Pub_Util_API.Create_Invoice_Item(item_rec_);                                          

   Source_Tax_Item_Invoic_API.New(tax_rec_);
   
EXCEPTION
   WHEN others THEN
      RAISE;
END Create_Prepayment_Inv_Line__;


-- Reconsume_Prepaym_Inv_Lines__
--   Interface method to call Reconsume_Prepaym_Inv_Lines__ in
PROCEDURE Reconsume_Prepaym_Inv_Lines__ (
   company_    IN VARCHAR2,
   invoice_id_ IN VARCHAR2,
   order_ref_  IN VARCHAR2 )
IS
   invoice_type_        VARCHAR2(20);
   prepay_deb_inv_type_ VARCHAR2(20);
   prepay_cre_inv_type_ VARCHAR2(20);

BEGIN
   invoice_type_        := Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, invoice_id_);
   prepay_deb_inv_type_ := NVL(Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_), 'COPREPAYDEB');
   prepay_cre_inv_type_ := NVL(Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type(company_), 'COPREPAYCRE');

   IF (invoice_type_ NOT IN (prepay_deb_inv_type_, prepay_cre_inv_type_)) THEN
      IF (Customer_Order_Inv_Item_API.Is_Prepaym_Lines_Exist(company_, invoice_id_) = 'TRUE') THEN
         Invoice_Customer_Order_API.Reconsume_Prepaym_Inv_Lines__(company_, invoice_id_, order_ref_);
      END IF;
   END IF;
END Reconsume_Prepaym_Inv_Lines__;


PROCEDURE Create_Postings__ (
   company_            IN VARCHAR2,
   invoice_id_         IN NUMBER,
   item_id_            IN NUMBER,
   revenue_simulation_ IN BOOLEAN DEFAULT FALSE,
   refresh_proj_revenue_ IN BOOLEAN DEFAULT FALSE)
IS
   part_no_                   VARCHAR2(25);
   catalog_type_              VARCHAR2(20);
   event_code_                VARCHAR2(20);
   booking_                   NUMBER;
   event_code_debit_          VARCHAR2(20) := 'INVOICE-D';
   event_code_credit_         VARCHAR2(20) := 'INVOICE-C';
   currency_rounding_         NUMBER;
   sale_                      NUMBER;
   linerec_                   Customer_Order_Line_API.Public_Rec;
   inventory_                 VARCHAR2(200) := Sales_Part_Type_API.Decode('INV');
   taxable_sales_             NUMBER;
   base_charge_cost_          NUMBER := 0;
   sale_charge_cost_          NUMBER := 0;
   tot_cost_                  NUMBER := 0;
   dummy_                     NUMBER;
   origin_is_rma_unconnected_ BOOLEAN := FALSE;
   headrec_                   Customer_Order_Inv_Head_API.Public_Rec;
   cor_inv_type_              VARCHAR2(20);
   col_inv_type_              VARCHAR2(20);
   advance_cr_inv_type_       VARCHAR2(20);
   advance_dr_inv_type_       VARCHAR2(20);
   prepay_deb_inv_type_       VARCHAR2(20);
   prepay_cre_inv_type_       VARCHAR2(20);
   comp_def_inv_type_rec_     Company_Def_Invoice_Type_API.Public_Rec;
   vat_code_                  CUSTOMER_ORDER_INV_ITEM.vat_code%TYPE;
   control_type_key_rec_      Mpccom_Accounting_API.Control_Type_Key;  
   saved_tax_code_msg_        VARCHAR2(32000);
   saved_tax_code_            VARCHAR2(20);
   saved_tax_calc_struct_id_  VARCHAR2(20);
   saved_tax_percentage_      NUMBER;
   line_disc_detail_table_    Cust_Invoice_Item_Discount_API.discount_detail_table;
   tot_line_discount_         NUMBER;
   order_discount_amt_        NUMBER;
   add_discount_amt_          NUMBER;
   net_curr_amount_           NUMBER;
   tax_base_curr_amount_      NUMBER;
   is_rebate_credit_inv_      BOOLEAN := FALSE;   
   ref_invoice_id_            NUMBER;
   ref_invoice_date_          DATE;
   inv_net_curr_amount_       NUMBER;
   invoiced_quantity_         NUMBER;
         
   CURSOR get_item IS
      SELECT     vat_code, 
             c1  order_no, 
             c2  line_no, 
             SUBSTR(c3,1,4) release_no,
             n1  line_item_no,
             c5  catalog_no, 
             n2  invoiced_qty, 
                 net_curr_amount,
             n3  price_conv, 
             n7  charge_seq_no, 
             c10 contract,
             n9  rma_no, 
             n10 rma_line_no, 
             n11 rma_charge_no, 
                 prel_update_allowed,
             c14 prepay_invoice_no,
             c15 prepay_invoice_series_id, 
             n16 rental_transaction_id,
             item_data
      FROM   cust_invoice_pub_util_item
      WHERE  invoice_id = invoice_id_
      AND    item_id = item_id_
      AND    company = company_;
      
   CURSOR get_invoiced_line (order_no_ IN VARCHAR2, line_no_ IN VARCHAR2, release_no_ IN VARCHAR2, line_item_no_ IN NUMBER, prel_update_falg_ IN VARCHAR2) IS
         SELECT  n2  invoiced_qty, net_curr_amount             
         FROM   cust_invoice_pub_util_item
         WHERE  invoice_id = invoice_id_
         AND    company    = company_
         AND    c1         = order_no_
         AND    c2         = line_no_
         AND    SUBSTR(c3,1,4) = release_no_
         AND    n1         = line_item_no_
         AND    n7 IS NULL
         AND    prel_update_allowed = prel_update_falg_;   

BEGIN

   headrec_               := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);
   comp_def_inv_type_rec_ := Company_Def_Invoice_Type_API.Get(company_);
   cor_inv_type_          := NVL(comp_def_inv_type_rec_.def_co_cor_inv_type, 'CUSTORDCOR');
   col_inv_type_          := NVL(comp_def_inv_type_rec_.def_col_cor_inv_type, 'CUSTCOLCOR');
   advance_cr_inv_type_   := NVL(comp_def_inv_type_rec_.def_adv_co_cr_inv_type, 'COADVCRE');
   advance_dr_inv_type_   := NVL(comp_def_inv_type_rec_.def_adv_co_dr_inv_type, 'COADVDEB');
   prepay_deb_inv_type_   := NVL(comp_def_inv_type_rec_.def_co_prepay_deb_inv_type, 'COPREPAYDEB');
   prepay_cre_inv_type_   := NVL(comp_def_inv_type_rec_.def_co_prepay_cre_inv_type, 'COPREPAYCRE');
   is_rebate_credit_inv_  := (headrec_.aggregation_no IS NOT NULL) OR (headrec_.final_settlement = 'TRUE');
      
   --added the condition to handle the new invoice type created for SBI.
   IF (headrec_.invoice_type IN ('CUSTORDDEB', 'COADVDEB', 'SELFBILLDEB', 'CUSTCOLDEB', prepay_deb_inv_type_)) THEN
      event_code_ := event_code_debit_;
   ELSIF (headrec_.invoice_type IN ('CUSTORDCRE', 'SELFBILLCRE','CUSTCOLCRE', advance_cr_inv_type_, prepay_cre_inv_type_)) OR (is_rebate_credit_inv_) THEN
      event_code_ := event_code_credit_;
   END IF;

   -- Check if postings for taxable or non-taxable sales should be generated.
   IF (Source_Tax_Item_API.Tax_Items_Taxable_Exist(company_, Tax_Source_API.DB_INVOICE, To_CHAR(invoice_id_), To_CHAR(item_id_), '*', '*', '*') = 'TRUE') THEN
      taxable_sales_:= 1;
   ELSE
      -- if invoice_id is a tax rounding item any way it is a taxable sale
      IF (item_id_  BETWEEN pc_tax_round_item_start_ AND pc_rounding_diff_start_)THEN
         taxable_sales_:= 1;
      ELSE               
         taxable_sales_:= 0;
      END IF;
   END IF;
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, headrec_.currency_code);
   
   FOR itemrec_ IN get_item LOOP
      linerec_ := Customer_Order_Line_API.Get(itemrec_.order_no, itemrec_.line_no, itemrec_.release_no, itemrec_.line_item_no);
      Calc_Inv_Discount_Detail___(line_disc_detail_table_,
                                  tot_line_discount_,
                                  order_discount_amt_, 
                                  add_discount_amt_,
                                  company_,
                                  invoice_id_,
                                  item_id_,
                                  currency_rounding_);                                              
      --Special handling for credit invoices since invoice line net amount is negative for credit invoices                          
      IF (headrec_.invoice_type IN ('CUSTORDCRE', 'SELFBILLCRE','CUSTCOLCRE', advance_cr_inv_type_, prepay_cre_inv_type_)) OR (is_rebate_credit_inv_) THEN
         --IF one of these invoice types used as correction invoices the net amount should be the same.
         -- The Gross Price Item record to fix tax rounding error is also has the correct sign.
         IF (NOT (is_rebate_credit_inv_)) AND (itemrec_.item_data = 'Gross Price Item' OR Invoice_Type_API.Get_Correction_Invoice_Db(company_,Party_type_API.DB_CUSTOMER,headrec_.invoice_type) = 'TRUE')THEN
            net_curr_amount_ := itemrec_.net_curr_amount;
         ELSE
            net_curr_amount_ := itemrec_.net_curr_amount * (-1);  
         END IF;          
      ELSE
         net_curr_amount_ := itemrec_.net_curr_amount;
      END IF;                            
      sale_ := (ROUND(net_curr_amount_, currency_rounding_) + NVL(tot_line_discount_,0) + NVL(order_discount_amt_,0) + NVL(add_discount_amt_,0));        
      -- for correction invoices the event code will vary according to the value of prel_update_allowed
      IF (headrec_.invoice_type IN (cor_inv_type_, col_inv_type_, 'CUSTORDDEB')) THEN
         IF itemrec_.prel_update_allowed = 'TRUE' THEN
            event_code_ := event_code_debit_;
         ELSE
            event_code_ := event_code_credit_;
            -- For the correction invoice credit type lines the quantity is negative, except for the Gross Price Item record to fix tax rounding error.
            -- Hence the sale is already negative for normal records, make it positive to book the correct postings.
            IF (NVL(itemrec_.item_data, Database_SYS.string_null_) != 'Gross Price Item') THEN
               sale_ := sale_ * (-1);
            END IF;
         END IF;
      END IF;

      -- Retrieve the charge cost
      IF (itemrec_.rma_charge_no IS NOT NULL) THEN
         base_charge_cost_ := Return_Material_Charge_API.Get_Charge_Cost(itemrec_.rma_no, itemrec_.rma_charge_no);
         IF (base_charge_cost_ IS NULL) THEN
            -- Retrieve charged cost from Customer_Order_Charge_API when it uses debit invoice's invoice date
            IF(headrec_.use_ref_inv_curr_rate = 'TRUE' ) THEN 
               Customer_Order_Charge_API.Get_Base_Charged_Cost( base_charge_cost_, itemrec_.order_no, itemrec_.charge_seq_no,
                                                               invoice_id_,        item_id_,         company_,               TRUE);                     
            ELSE
               base_charge_cost_ := Return_Material_Charge_API.Get_Total_Base_Charged_Cost(itemrec_.rma_no, itemrec_.rma_charge_no); 
            END IF;
         END IF;
      ELSIF (itemrec_.charge_seq_no IS NOT NULL) THEN
         IF itemrec_.order_no IS NOT NULL THEN         
            IF ((Customer_Order_Charge_API.Get_Unit_Charge_Db(itemrec_.order_no, itemrec_.charge_seq_no) = 'TRUE') AND
               (Customer_Order_Charge_API.Get_Charge_Cost_Percent(itemrec_.order_no, itemrec_.charge_seq_no) IS NOT NULL )) THEN
               -- When calculating the cost of the charge line (credit/correction) we need to take the amount from the corresponding part line of the invoice.   
               OPEN get_invoiced_line (itemrec_.order_no, itemrec_.line_no, itemrec_.release_no, itemrec_.line_item_no, itemrec_.prel_update_allowed);
               FETCH get_invoiced_line INTO invoiced_quantity_, inv_net_curr_amount_;
               CLOSE get_invoiced_line;
            END IF;

            Customer_Order_Charge_API.Get_Base_Charged_Cost( base_charge_cost_, itemrec_.order_no, itemrec_.charge_seq_no,
                                                             invoice_id_,        item_id_,         company_,               TRUE,
                                                             inv_net_curr_amount_, invoiced_quantity_);
         ELSE
            base_charge_cost_ := Shipment_Freight_Charge_API.Get_Charge_Cost(headrec_.shipment_id, itemrec_.charge_seq_no);
         END IF;
      END IF;

      -- Calculate the cost in invoice currency
      IF (base_charge_cost_ != 0) THEN         
         IF(headrec_.use_ref_inv_curr_rate = 'TRUE') THEN
            ref_invoice_id_   := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, headrec_.number_reference, headrec_.series_reference);
            ref_invoice_date_ := Customer_Order_Inv_Head_API.Get_Invoice_Date(company_, ref_invoice_id_);
         END IF;
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(sale_charge_cost_, dummy_, headrec_.customer_no, itemrec_.contract,
                                                                headrec_.currency_code, base_charge_cost_, headrec_.currency_rate_type, NVL(ref_invoice_date_, headrec_.invoice_date));
         tot_cost_ := round((NVL(sale_charge_cost_, 0) * itemrec_.price_conv * NVL(itemrec_.invoiced_qty, 0)), currency_rounding_);
         -- For the correction invoice credit type lines the quantity is negative,
         -- As the tot_cost_ is already negative, make it positive to book the correct postings.
         IF (headrec_.invoice_type IN (cor_inv_type_, col_inv_type_)) THEN
            IF (itemrec_.prel_update_allowed != 'TRUE') THEN
               tot_cost_ := tot_cost_ * (-1);
            END IF;
         END IF;
      END IF;

      part_no_ := NULL;

      IF (itemrec_.order_no IS NOT NULL) AND (itemrec_.line_no IS NOT NULL) THEN
         -- Preaccount for order line used also for charges connected to the line.
         control_type_key_rec_.pre_accounting_id_ := linerec_.pre_accounting_id;
         part_no_ := linerec_.part_no;
      ELSIF (itemrec_.order_no IS NOT NULL) AND (itemrec_.charge_seq_no IS NOT NULL) THEN 
         -- Use preaccounting from order head for charge connected to order
         control_type_key_rec_.pre_accounting_id_ := Customer_Order_API.Get_Pre_Accounting_Id(itemrec_.order_no);
      ELSIF (itemrec_.rma_no IS NOT NULL) AND (itemrec_.rma_line_no IS NOT NULL) THEN
         -- Retrieve inventory part for sales part number
         part_no_ := Sales_Part_API.Get_Part_No(itemrec_.contract, itemrec_.catalog_no);
      ELSIF ((headrec_.invoice_type IN (prepay_deb_inv_type_, prepay_cre_inv_type_))
             OR ((headrec_.invoice_type = 'CUSTORDDEB') AND (itemrec_.prel_update_allowed = 'FALSE')))  THEN
          -- Use preaccounting from order head for prepayment connected to the order
         control_type_key_rec_.pre_accounting_id_ := Customer_Order_API.Get_Pre_Accounting_Id(itemrec_.order_no);
      END IF;

      control_type_key_rec_.contract_ := itemrec_.contract;

      -- Catalog type only valid for sales parts, not for charges.
      IF (itemrec_.charge_seq_no IS NULL) THEN
         catalog_type_ := Sales_Part_API.Get_Catalog_Type(itemrec_.contract, itemrec_.catalog_no);
         IF (catalog_type_ != inventory_) THEN
            control_type_key_rec_.part_no_ := itemrec_.catalog_no;
         ELSE
            control_type_key_rec_.part_no_ := part_no_;
         END IF;
      END IF;

      control_type_key_rec_.company_            := company_;
      control_type_key_rec_.oe_invoice_id_      := invoice_id_;
      control_type_key_rec_.oe_invoice_item_id_ := item_id_;
      IF(is_rebate_credit_inv_ = FALSE)THEN
         control_type_key_rec_.catalog_no_      := itemrec_.catalog_no;
      END IF;
      control_type_key_rec_.oe_order_no_        := itemrec_.order_no;
      control_type_key_rec_.oe_line_no_         := itemrec_.line_no;
      control_type_key_rec_.oe_rel_no_          := itemrec_.release_no;
      control_type_key_rec_.oe_line_item_no_    := itemrec_.line_item_no;
      control_type_key_rec_.oe_charge_seq_no_   := itemrec_.charge_seq_no;

      control_type_key_rec_.oe_rma_no_          := itemrec_.rma_no;
      control_type_key_rec_.oe_rma_line_no_     := itemrec_.rma_line_no;
      control_type_key_rec_.oe_rma_charge_no_   := itemrec_.rma_charge_no;      

      vat_code_ := itemrec_.vat_code;
      IF ( vat_code_ IS NULL) THEN
         saved_tax_code_ := Tax_Handling_Order_Util_API.Get_First_Tax_Code(company_, 
                                                                           Tax_Source_API.DB_INVOICE,
                                                                           To_CHAR(invoice_id_), 
                                                                           To_CHAR(item_id_), 
                                                                           '*', 
                                                                           '*');
         IF (saved_tax_code_msg_ IS NULL) AND (Statutory_Fee_API.Get_Fee_Type_Db(company_, saved_tax_code_) IN ('TAX'))THEN
            vat_code_ := saved_tax_code_;
         END IF;
      END IF;

      control_type_key_rec_.tax_code_ := vat_code_;

      IF NOT is_rebate_credit_inv_ THEN   
         -- booking for the prepayment invices..
         IF (headrec_.invoice_type IN (prepay_deb_inv_type_, prepay_cre_inv_type_)
            OR (headrec_.invoice_type = 'CUSTORDDEB' AND itemrec_.prel_update_allowed = 'FALSE')) THEN
            IF (taxable_sales_ = 1) THEN
               booking_ := 26; -- booking for taxable future sales
            ELSE
               booking_ := 27; -- booking for non-taxable future sales
            END IF;
         ELSE
            IF (itemrec_.charge_seq_no IS NULL) THEN
            -- Booking sale
               IF (taxable_sales_ = 1) THEN
                  booking_ := 1;
                  IF itemrec_.item_data = 'Gross Price Item' THEN
                     booking_ := 39;
                  ELSIF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
                     booking_ := 31;  
                  END IF;
               ELSE
                  booking_ := 2;
                  IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
                     booking_ := 32;  
                  END IF;
               END IF;
            ELSE
            -- Booking charge
               IF (taxable_sales_ = 1) THEN
                  booking_ := 10;
               ELSE
                  booking_ := 11;
               END IF;
            END IF;
         END IF;

         origin_is_rma_unconnected_ := (itemrec_.rma_no IS NOT NULL) AND (itemrec_.order_no IS NULL);

         -- check booking for a RMA line or charge
         IF origin_is_rma_unconnected_ THEN
            IF itemrec_.rma_charge_no IS NULL THEN
            -- rma lines
               IF (taxable_sales_ = 1) THEN
                  booking_ := 17; -- Crediting VAT sales - orderless
               ELSE
                  booking_ := 18; -- Crediting VAT free sales - orderless
               END IF;
            ELSE
            -- rma charges
               IF (taxable_sales_ = 1) THEN
                  booking_ := 19; -- Crediting VAT sales charges - orderless
               ELSE
                  booking_ := 20; -- Crediting VAT free sales charges - orderless
               END IF;
            END IF;
         END IF ;
         Do_Str_Event_Acc___(control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
                             itemrec_.invoiced_qty, sale_, headrec_.invoice_date,
                             vat_code_, revenue_simulation_, refresh_proj_revenue_);

         -- Booking charge cost
         IF ((itemrec_.charge_seq_no IS NOT NULL) OR (itemrec_.rma_charge_no IS NOT NULL)) THEN
            IF (tot_cost_ != 0) THEN
               IF (itemrec_.rma_no IS NULL) OR (itemrec_.order_no IS NOT NULL) THEN
                  booking_ := 12;
               ELSE
               -- RMA without order connection
                  booking_ := 21;
               END IF;

               Do_Str_Event_Acc___(control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
                                   itemrec_.invoiced_qty, tot_cost_, headrec_.invoice_date,
                                   NULL, revenue_simulation_, refresh_proj_revenue_);
             END IF;
          END IF;
         -- Create postings for free of charge goods.
         Create_Free_Of_Chg_Postings___ (control_type_key_rec_, company_, invoice_id_, item_id_, headrec_.invoice_date,
                                         event_code_, vat_code_, revenue_simulation_, refresh_proj_revenue_); 
         -- Create postings for discounts.
         Create_Discount_Postings___(control_type_key_rec_, line_disc_detail_table_, order_discount_amt_, 
                                     add_discount_amt_, company_, invoice_id_, item_id_, headrec_.invoice_date,
                                     event_code_, vat_code_, taxable_sales_, origin_is_rma_unconnected_, revenue_simulation_, refresh_proj_revenue_);
      END IF;

      -- Create postings for rebates.
      IF (headrec_.invoice_type IN ('CUSTORDDEB','CUSTCOLDEB','SELFBILLDEB','CUSTORDCRE','CUSTCOLCRE','SELFBILLCRE', cor_inv_type_, col_inv_type_)) OR (is_rebate_credit_inv_) THEN
         Create_Rebate_Postings___(control_type_key_rec_, company_, invoice_id_, item_id_, headrec_.invoice_date,
                                   event_code_, itemrec_.vat_code, currency_rounding_,
                                   itemrec_.invoiced_qty, headrec_.invoice_type, headrec_.aggregation_no,
                                   itemrec_.line_item_no, headrec_.final_settlement, sale_, refresh_proj_revenue_);
      END IF;

      -- Update dom amount on postings if there is a difference between invoice line and line postings      
	  IF headrec_.currency_code != Currency_Code_API.Get_Currency_Code(company_) THEN
		 IF (itemrec_.prepay_invoice_no IS NOT NULL) THEN
      IF (Customer_Order_Inv_Head_API.Prepayment_Curr_Diff(company_, invoice_id_, itemrec_.prepay_invoice_no, itemrec_.prepay_invoice_series_id)) THEN
			   Do_Str_Event_Acc___(control_type_key_rec_, invoice_id_, item_id_, company_, event_code_, booking_,
								   itemrec_.invoiced_qty, 0, headrec_.invoice_date,
								   vat_code_, revenue_simulation_, refresh_proj_revenue_);
			END IF;
		 END IF;
         Customer_Invoice_Pub_Util_API.Balance_Dom_Amount(company_, invoice_id_, item_id_);
      END IF;
   END LOOP;
   
END Create_Postings__;


-- Calculate_Prel_Revenue__
--   This procedure will find the ActivitySeq of the Customer order line connected to the invoice line.
--   If CO line is project connected, then creates or refreshes the preliminary revenue of the invoice line.
--   This procedure will find follow up elements of the invoice line and
--   create or refresh connection with Project.
--   This procedure will remove the project connection,
--   if the CO line of the invoice line is project connected.
PROCEDURE Calculate_Prel_Revenue__ (
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   item_id_      IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   co_line_rec_  Customer_Order_Line_API.Public_Rec;
   activity_info_tab_            Public_Declarations_API.PROJ_Project_Conn_Cost_Tab;
   activity_revenue_info_tab_    Public_Declarations_API.PROJ_Project_Conn_Revenue_Tab;
   attributes_                   Public_Declarations_API.PROJ_Project_Conn_Attr_Type;
BEGIN
   co_line_rec_ := Customer_Order_Line_API.Get (order_no_, line_no_, rel_no_, line_item_no_);
   IF (NVL(co_line_rec_.activity_seq, 0) > 0) THEN
      Refresh_Project_Connection (activity_info_tab_         => activity_info_tab_,
                                  activity_revenue_info_tab_ => activity_revenue_info_tab_,
                                  attributes_                => attributes_,
                                  activity_seq_              => co_line_rec_.activity_seq,
                                  keyref1_                   => company_,
                                  keyref2_                   => invoice_id_,
                                  keyref3_                   => item_id_,
                                  keyref4_                   => '*',
                                  keyref5_                   => '*',
                                  keyref6_                   => '*',
                                  refresh_old_data_          => 'FALSE');
   END IF;
END Calculate_Prel_Revenue__;


-- Calculate_Prel_Revenue__
--   This procedure will find the ActivitySeq of the Customer order line connected to the invoice line.
--   If CO line is project connected, then creates or refreshes the preliminary revenue of the invoice line.
--   This procedure will find follow up elements of the invoice line and
--   create or refresh connection with Project.
--   This procedure will remove the project connection,
--   if the CO line of the invoice line is project connected.
PROCEDURE Calculate_Prel_Revenue__ (
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   item_id_      IN NUMBER,
   activity_seq_ IN NUMBER )
IS
   activity_info_tab_            Public_Declarations_API.PROJ_Project_Conn_Cost_Tab;
   activity_revenue_info_tab_    Public_Declarations_API.PROJ_Project_Conn_Revenue_Tab;
   attributes_                   Public_Declarations_API.PROJ_Project_Conn_Attr_Type;
BEGIN
   Refresh_Project_Connection (activity_info_tab_         => activity_info_tab_,
                               activity_revenue_info_tab_ => activity_revenue_info_tab_,
                               attributes_                => attributes_,
                               activity_seq_              => activity_seq_,
                               keyref1_                   => company_,
                               keyref2_                   => invoice_id_,
                               keyref3_                   => item_id_,
                               keyref4_                   => '*',
                               keyref5_                   => '*',
                               keyref6_                   => '*',
                               refresh_old_data_          => 'FALSE');
END Calculate_Prel_Revenue__;


PROCEDURE Remove_Project_Connection__(
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   item_id_      IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   activity_seq_ NUMBER;
BEGIN

   $IF (Component_Proj_SYS.INSTALLED)$THEN
      activity_seq_ := Customer_Order_Line_API.Get_Activity_Seq(order_no_, 
                                                                line_no_, 
                                                                rel_no_, 
                                                                line_item_no_ );
      IF (activity_seq_ IS NOT NULL) THEN
         Project_Connection_Util_API.Remove_Connection ('COINVLINE',
                                                        activity_seq_,
                                                        company_,
                                                        invoice_id_,
                                                        item_id_,
                                                        NULL,
                                                        NULL,
                                                        NULL); 
      END IF;
   $ELSE 
      NULL;
   $END 
END Remove_Project_Connection__;

PROCEDURE Check_Order_Tax_Combination__ (
   same_tax_combination_ OUT    VARCHAR2,
   tax_calc_struct_id_   OUT    VARCHAR2,
   company_                  IN VARCHAR2,
   order_no_                 IN VARCHAR2,
   with_charges_             IN VARCHAR2)
IS
   CURSOR get_data_grp IS   
      SELECT sto.source_ref1           order_no,
             sto.source_ref2           line_no, 
             sto.source_ref3           release_no,
             sto.source_ref4           line_item_no,
             sto.tax_code              tax_code,
             sto.tax_percentage        tax_percentage,
             sto.tax_calc_structure_id tax_calc_structure_id
      FROM  source_tax_item_base_pub sto
      WHERE sto.source_ref1        = order_no_
      AND   sto.source_ref_type_db IN (SELECT 'CUSTOMER_ORDER_LINE'  
                                     FROM   customer_order_line_tab col 
                                     WHERE  sto.source_ref1 = col.order_no
                                     AND    sto.source_ref2 = col.line_no
                                     AND    sto.source_ref3 = col.rel_no
                                     AND    sto.source_ref4 = col.line_item_no
                                     AND    col.rowstate != 'Cancelled' 
                                 UNION ALL 
                                     SELECT 'CUSTOMER_ORDER_CHARGE'
                                     FROM customer_order_charge_tab coc
                                     WHERE  with_charges_   = 'TRUE'
                                     AND    sto.source_ref1 = coc.order_no
                                     AND    sto.source_ref2 = coc.sequence_no)
      ORDER BY sto.source_ref_type_db,sto.source_ref1, sto.source_ref2, sto.source_ref3, sto.source_ref4, sto.tax_code;
   
   curr_rec_                 get_data_grp%ROWTYPE;
   prev_rec_                 get_data_grp%ROWTYPE;
   new_tax_code_grp_         VARCHAR2(4000);
   prev_tax_code_grp_        VARCHAR2(4000); 
   new_tax_calc_struct_id_   VARCHAR2(20);
   prev_tax_calc_struct_id_  VARCHAR2(20);
BEGIN
   OPEN get_data_grp;
   FETCH get_data_grp INTO curr_rec_;
   WHILE (get_data_grp%FOUND) LOOP
       prev_rec_ := curr_rec_;
       WHILE ((prev_rec_.order_no = curr_rec_.order_no) AND (prev_rec_.line_no = curr_rec_.line_no) AND (prev_rec_.release_no = curr_rec_.release_no) AND (prev_rec_.line_item_no = curr_rec_.line_item_no) AND(get_data_grp%FOUND)) LOOP
          IF new_tax_code_grp_ IS NULL THEN
             new_tax_code_grp_       := curr_rec_.tax_code || CHR(14) || curr_rec_.tax_percentage;
          ELSE
             new_tax_code_grp_       := new_tax_code_grp_ || CHR(14) || curr_rec_.tax_code || CHR(14) || curr_rec_.tax_percentage;
          END IF;
          new_tax_calc_struct_id_ := curr_rec_.tax_calc_structure_id;
          FETCH get_data_grp INTO curr_rec_;
       END LOOP;
      IF((prev_tax_code_grp_ IS NOT NULL) AND ((prev_tax_code_grp_ != new_tax_code_grp_) OR (NVL(new_tax_calc_struct_id_,Database_SYS.string_null_) != NVL(prev_tax_calc_struct_id_,Database_SYS.string_null_)))) THEN
         same_tax_combination_ := 'FALSE';
         CLOSE get_data_grp;
         RETURN;
      ELSE
         same_tax_combination_ := 'TRUE';
         tax_calc_struct_id_ := new_tax_calc_struct_id_;
      END IF;
      prev_tax_calc_struct_id_ := new_tax_calc_struct_id_;
      prev_tax_code_grp_ := new_tax_code_grp_;
      new_tax_code_grp_  := NULL;
   END LOOP;
   same_tax_combination_ := 'TRUE';
   CLOSE get_data_grp;
END Check_Order_Tax_Combination__;

--This method has been implemented based on the client code the line table in the customer invoice page
PROCEDURE Get_Amounts__(
   vat_curr_amount_           IN OUT NUMBER,
   vat_dom_amount_            IN OUT NUMBER,  -- missing parameter in the customer invoice line overview
   gross_curr_amount_         IN OUT NUMBER,
   net_curr_amount_           IN OUT NUMBER,
   tax_code_                  IN OUT VARCHAR2,
   tax_calc_structure_id_     IN OUT VARCHAR2,
   company_                   IN     VARCHAR2,
   invoice_id_                IN     NUMBER,
   item_id_                   IN     NUMBER,
   price_qty_                 IN     NUMBER,
   unit_price_incl_tax_       IN     NUMBER,
   sale_unit_price_           IN     NUMBER,
   charge_percent_basis_      IN     NUMBER,
   charge_percent_            IN     NUMBER,
   order_discount_            IN     NUMBER,
   discount_                  IN     NUMBER,
   additional_discount_       IN     NUMBER )
IS
   calc_base_                 VARCHAR2(20);
   sales_price_               NUMBER :=0;
   curr_amount_               NUMBER :=0;
   discount_local_            NUMBER := NVL(discount_, 0);
   additional_discount_local_ NUMBER := NVL(additional_discount_, 0);
   order_discount_local_      NUMBER := NVL(order_discount_, 0);
   rounding_                  NUMBER;
   header_rec_                CUST_ORDER_INV_HEAD_UIV_ALL%ROWTYPE;
   
   CURSOR get_co_inv_head_rec IS
      SELECT *
        FROM CUST_ORDER_INV_HEAD_UIV_ALL 
       WHERE company = company_
         AND invoice_id = invoice_id_;   
BEGIN
   OPEN get_co_inv_head_rec;
   FETCH get_co_inv_head_rec INTO header_rec_;
   CLOSE get_co_inv_head_rec;
   
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, header_rec_.currency);

   IF (charge_percent_ IS NOT NULL )THEN 
      sales_price_ := charge_percent_basis_ * charge_percent_ / 100 ;  
   ELSIF(header_rec_.use_price_incl_tax_db = 'TRUE')THEN
      sales_price_ := price_qty_ * unit_price_incl_tax_ ;
   ELSE
      sales_price_ := price_qty_ * sale_unit_price_ ;
   END IF;   

   discount_local_              := ROUND(sales_price_ * (discount_local_ / 100),rounding_);
   --discount_local_ has been calculate as below in the invoice line overview
   --discount_local_              := ROUND(sales_price_ - (sales_price_ * (1 - discount_local_ / 100) * (1 - order_discount_local_ / 100)),rounding_);

   -- additional_discount_local_ calculation is missing in the invoce lines overview
   additional_discount_local_   := ROUND((sales_price_ - discount_local_) * (additional_discount_local_ / 100),rounding_); 
   -- order_discount_local_ calculation is missing in the invoce lines overview
   order_discount_local_        := ROUND((sales_price_ - discount_local_) * (order_discount_local_ / 100),rounding_);
   sales_price_                 := ROUND(sales_price_,rounding_); 
   curr_amount_                 := sales_price_ - discount_local_ - additional_discount_local_ - order_discount_local_;
   --curr_amount_ has been calculate as below in the invoice line overview
   --curr_amount_                 := ROUND((sales_price_ - discount_local_),rounding_);

   IF(header_rec_.use_price_incl_tax_db = 'TRUE')THEN
      gross_curr_amount_         := curr_amount_;
      calc_base_                 := 'GROSS_BASE';
   ELSE 
      net_curr_amount_           := curr_amount_;
      calc_base_                 := 'NET_BASE';
   END IF;   
   
   Add_Transaction_Tax_Info___(vat_curr_amount_, vat_dom_amount_, gross_curr_amount_, net_curr_amount_, tax_code_,  
                               tax_calc_structure_id_, company_, invoice_id_, item_id_, calc_base_, header_rec_.identity, 
                               header_rec_.currency, header_rec_.fin_curr_rate, header_rec_.tax_curr_rate, header_rec_.invoice_date);
      
   IF header_rec_.invoice_type IN ('CUSTORDCRE','CUSTCOLCRE','COADVCRE','SELFBILLCRE') OR -- Types 'COADVCRE','SELFBILLCRE' are missing in the invoice line overview
      header_rec_.invoice_type = Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(company_) THEN
      vat_dom_amount_    := - vat_dom_amount_; -- missing parameter in the customer invoice line overview
      vat_curr_amount_   := - vat_curr_amount_;
      gross_curr_amount_ := - gross_curr_amount_;
      net_curr_amount_   := - net_curr_amount_;
   END IF ;
END Get_Amounts__;

-- gelr:disc_price_rounded, begin
FUNCTION Get_Displayed_Discount__ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER) RETURN NUMBER
IS
   CURSOR get_item_rec IS
      SELECT discount, original_discount
      FROM   customer_order_inv_item
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_;
      
   item_rec_ get_item_rec%ROWTYPE;
BEGIN
   OPEN get_item_rec;
   FETCH get_item_rec INTO item_rec_;
   CLOSE get_item_rec;
   
   IF (Get_Discounted_Price_Rounded(company_, invoice_id_, item_id_)) THEN
      RETURN item_rec_.original_discount;
   ELSE
      RETURN item_rec_.discount;
   END IF;
END Get_Displayed_Discount__;
-- gelr:disc_price_rounded, end

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Exist
--   Checks if a given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER )
IS
BEGIN
   IF (NOT Check_Exist___(company_, invoice_id_, item_id_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
END Exist;


-- Get_Vat_Code
--   Returns the vat_code for a invoice item.
--   This method should be used from Mpccom.
--   Return tax code - used for ordinary customer order lines.
--   Return tax code - used for customer order charge lines
@UncheckedAccess
FUNCTION Get_Vat_Code (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_ITEM.vat_code%TYPE;

   CURSOR get_attr IS
      SELECT vat_code
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Vat_Code;


@UncheckedAccess
FUNCTION Get_Gross_Curr_Amount (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_ITEM.gross_curr_amount%TYPE;
   CURSOR get_attr IS
      SELECT gross_curr_amount
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Gross_Curr_Amount;



-- Get_Net_Dom_Amount
--   Returns the net amount in base currency
@UncheckedAccess
FUNCTION Get_Net_Dom_Amount (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   temp_  CUSTOMER_ORDER_INV_ITEM.net_dom_amount%TYPE;

   CURSOR get_attr IS
      SELECT net_dom_amount
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Net_Dom_Amount;


@UncheckedAccess
FUNCTION Get_Rent_Trans_Net_Dom_Amount (
   transaction_id_    IN NUMBER,
   order_no_          IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   temp_  CUSTOMER_ORDER_INV_ITEM.net_dom_amount%TYPE;

   -- Cursor get_attr is kept for reverse compatibility, though it causes full table scan in invoice_item_tab
   CURSOR get_attr IS
      SELECT net_dom_amount
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  rental_transaction_id    = transaction_id_;
   CURSOR get_net_dom_amount IS
      SELECT net_dom_amount
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  rental_transaction_id = transaction_id_
      AND    order_no              = order_no_;
BEGIN
   IF (order_no_ IS NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   ELSE
      OPEN get_net_dom_amount;
      FETCH get_net_dom_amount INTO temp_;
      CLOSE get_net_dom_amount;
   END IF;
   RETURN temp_;
END Get_Rent_Trans_Net_Dom_Amount;


@UncheckedAccess
FUNCTION Get_Rent_Trans_Gross_Dom_Amnt (
   transaction_id_    IN NUMBER,
   order_no_          IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   temp_  CUSTOMER_ORDER_INV_ITEM.gross_curr_amount%TYPE;

   -- Cursor get_attr is kept for reverse compatibility, though it causes full table scan in invoice_item_tab
   CURSOR get_attr IS
   SELECT (net_dom_amount + vat_dom_amount)
   FROM   CUSTOMER_ORDER_INV_ITEM
   WHERE  rental_transaction_id = transaction_id_;
   CURSOR get_gross_dom_amount IS
      SELECT (net_dom_amount + vat_dom_amount)
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  rental_transaction_id = transaction_id_
      AND    order_no = order_no_;
BEGIN
   IF (order_no_ IS NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   ELSE
      OPEN get_gross_dom_amount;
      FETCH get_gross_dom_amount INTO temp_;
      CLOSE get_gross_dom_amount;
   END IF;
   RETURN temp_;
END Get_Rent_Trans_Gross_Dom_Amnt;

@UncheckedAccess
FUNCTION Get_Prel_Update_Allowed (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_ITEM.prel_update_allowed%TYPE;
   CURSOR get_attr IS
      SELECT prel_update_allowed
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Prel_Update_Allowed;



@UncheckedAccess
FUNCTION Get_Sales_Part_Rebate_Group (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_ITEM.sales_part_rebate_group%TYPE;
   CURSOR get_attr IS
      SELECT sales_part_rebate_group
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Sales_Part_Rebate_Group;



@UncheckedAccess
FUNCTION Get_Assortment_Id (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_ITEM.assortment_id%TYPE;
   CURSOR get_attr IS
      SELECT assortment_id
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Assortment_Id;



@UncheckedAccess
FUNCTION Get_Assortment_Node_Id (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_ITEM.assortment_node_id%TYPE;
   CURSOR get_attr IS
      SELECT assortment_node_id
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Assortment_Node_Id;



-- Get_Order_Discount
--   Returns the order discount %
@UncheckedAccess
FUNCTION Get_Order_Discount (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   temp_  CUSTOMER_ORDER_INV_ITEM.order_discount%TYPE;

   CURSOR get_attr IS
      SELECT order_discount
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Order_Discount;



-- Get_Price_Conv_Factor
--   Returns the price conversion factor
@UncheckedAccess
FUNCTION Get_Price_Conv_Factor (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   temp_  CUSTOMER_ORDER_INV_ITEM.price_conv%TYPE;

   CURSOR get_attr IS
      SELECT price_conv
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Price_Conv_Factor;



-- Get_Discount
--   Returns the discount percentage for an invoice item.
@UncheckedAccess
FUNCTION Get_Discount (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_ITEM.discount%TYPE;

   CURSOR get_attr IS
      SELECT discount
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Discount;



-- Create_Invoice_Item
--   Creates Invoice_Item in module INVOICE
-- gelr:disc_price_rounded, added 
-- gelr:prepayment_tax_document, added prepay_tax_base_curr_amt, prepay_tax_curr_amount, prepay_tax_document_id
PROCEDURE Create_Invoice_Item (
   item_id_                 IN OUT NUMBER,
   invoice_id_              IN     NUMBER,
   company_                 IN     VARCHAR2,
   order_no_                IN     VARCHAR2,
   line_no_                 IN     VARCHAR2,
   rel_no_                  IN     VARCHAR2,
   line_item_no_            IN     NUMBER,
   contract_                IN     VARCHAR2,
   catalog_no_              IN     VARCHAR2,
   catalog_desc_            IN     VARCHAR2,
   sales_unit_meas_         IN     VARCHAR2,
   price_conv_factor_       IN     NUMBER,
   sale_unit_price_         IN     NUMBER,
   unit_price_incl_tax_     IN     NUMBER,
   discount_                IN     NUMBER,
   order_discount_          IN     NUMBER,
   tax_code_                IN     VARCHAR2,
   total_tax_percentage_    IN     NUMBER,
   invoiced_qty_            IN     NUMBER,
   customer_po_no_          IN     VARCHAR2,
   deliv_type_id_           IN     VARCHAR2,
   invoiced_qty_count_      IN     NUMBER,
   charge_seq_no_           IN     NUMBER,
   charge_group_            IN     VARCHAR2,
   stage_                   IN     NUMBER,
   prel_update_allowed_     IN     VARCHAR2,
   rma_no_                  IN     NUMBER   DEFAULT NULL,
   rma_line_no_             IN     NUMBER   DEFAULT NULL,
   rma_charge_no_           IN     NUMBER   DEFAULT NULL,
   deb_invoice_id_          IN     NUMBER   DEFAULT NULL,
   deb_item_id_             IN     NUMBER   DEFAULT NULL,
   add_discount_            IN     NUMBER   DEFAULT 0,
   sales_part_rebate_group_ IN     VARCHAR2 DEFAULT NULL,
   assortment_id_           IN     VARCHAR2 DEFAULT NULL,
   assortment_node_id_      IN     VARCHAR2 DEFAULT NULL,
   charge_percent_          IN     NUMBER   DEFAULT NULL,
   charge_percent_basis_    IN     NUMBER   DEFAULT NULL,
   rental_transaction_id_   IN     NUMBER   DEFAULT NULL,
   delivery_address_id_     IN     VARCHAR2 DEFAULT NULL,
   income_type_id_          IN     VARCHAR2 DEFAULT NULL,
   shipment_id_             IN     VARCHAR2 DEFAULT NULL,
   adv_inv_tax_msg_         IN     VARCHAR2 DEFAULT NULL,
   free_of_charge_tax_basis_    IN NUMBER   DEFAULT NULL,
   deb_inv_quantity_        IN     NUMBER   DEFAULT NULL,
   customer_tax_usage_type_ IN     VARCHAR2 DEFAULT NULL,
   original_discount_       IN     NUMBER   DEFAULT 0,
   original_add_discount_   IN     NUMBER   DEFAULT 0,
   original_order_discount_ IN     NUMBER   DEFAULT 0,
   prepay_tax_base_curr_amt_ IN    NUMBER   DEFAULT NULL,
   prepay_tax_curr_amount_  IN    NUMBER    DEFAULT NULL,
   prepay_tax_document_id_  IN    NUMBER    DEFAULT NULL)
IS
   reference_                VARCHAR2(100);
   net_curr_amount_          NUMBER;
   vat_curr_amount_          NUMBER;
   vat_dom_amount_           NUMBER;
   vat_para_amount_          NUMBER;
   currency_rounding_        NUMBER;
   ivc_item_seq_no_          NUMBER;
   pos_                      CUSTOMER_ORDER_INV_ITEM.pos%TYPE;
   item_rec_                 Customer_Invoice_Pub_Util_API.customer_invoice_item_rec;
   price_um_                 CUSTOMER_ORDER_INV_ITEM.price_um%TYPE;
   headrec_                  Customer_Order_Inv_Head_API.Public_Rec;
   linerec_                  Customer_Order_Line_API.Public_Rec;
   debit_invoice_no_         VARCHAR2(50);   
   series_id_                VARCHAR2(20);
   chk_ser_ref_              VARCHAR2(20);
   tax_calc_structure_id_    VARCHAR2(20);
   temp_sale_unit_price_     NUMBER;
   temp_unit_price_incl_tax_ NUMBER;
   new_charge_percent_basis_ NUMBER;
   correction_inv_type_      VARCHAR2(20);
   col_cor_inv_type_         VARCHAR2(20);
   total_line_discount_      NUMBER :=0;
   line_discount_pct_        NUMBER;
   comp_bearing_tax_amt_     NUMBER;
   is_adv_deb_inv_           VARCHAR2(5);
   source_key_rec_           Tax_Handling_Util_API.source_key_rec;
   adv_inv_tax_info_table_   Tax_Handling_Util_API.tax_information_table;
   -- gelr:disc_price_rounded, begin 
   discounted_price_rounded_ BOOLEAN := Customer_Order_API.Get_discounted_Price_Rounded(order_no_);
   -- gelr:disc_price_rounded, end
   -- gelr:prepayment_tax_document, begin   
   matched_offset_amount_         NUMBER; 
   matched_tax_amount_            NUMBER;   
   not_matched_amount_            NUMBER;   
   unused_prepay_tax_base_        NUMBER;
   unused_prepay_tax_amount_      NUMBER;
   -- gelr:prepayment_tax_document, end

   CURSOR get_cor_pos (invoice_type_ IN VARCHAR2) IS
      SELECT to_char(MAX(to_number(pos)))
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id   = invoice_id_
      AND    invoice_type = invoice_type_
      AND    prel_update_allowed = prel_update_allowed_;

BEGIN
   headrec_ := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);
   linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   correction_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   col_cor_inv_type_    := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);
   
   IF (headrec_.invoice_type IN (correction_inv_type_, col_cor_inv_type_)) THEN
      -- Correction invoices
      OPEN  get_cor_pos (headrec_.invoice_type);
      FETCH get_cor_pos INTO pos_;
      CLOSE get_cor_pos;
   ELSE
      -- Other than correction invoices
      pos_ := Customer_Invoice_Pub_Util_API.Get_Max_Pos_No(company_, invoice_id_);
   END IF;

   IF (pos_ IS NOT NULL) THEN
      pos_ := to_char(to_number(pos_) + 1);
   ELSE
      pos_ := '1';
   END IF;

   currency_rounding_        := Currency_Code_API.Get_Currency_Rounding(company_, headrec_.currency_code);
   
   IF (charge_percent_ IS NULL) THEN
      temp_sale_unit_price_     := sale_unit_price_;
      temp_unit_price_incl_tax_ := unit_price_incl_tax_;
   ELSE
      temp_sale_unit_price_     := (charge_percent_basis_ * charge_percent_ / 100);
      temp_unit_price_incl_tax_ := (charge_percent_basis_ * charge_percent_ / 100);
   END IF;
   
   line_discount_pct_        := Customer_Order_Line_Api.Get_Discount(order_no_,line_no_,rel_no_,line_item_no_);
   -- NOTE: If discount_ has a percentage, line discount amount is calculated, using Customer Order Line Discounts.
   --       If discount_ has no impact on calculating line amounts, 0 is passed. That is when creating invoices for charge items,
   --       credit return, credit return charge, advance invoices, rebate credit invoices. 
   IF discount_ IS NOT NULL AND discount_ = 0 THEN
      total_line_discount_ := 0;   
   ELSE
      IF deb_invoice_id_ IS NULL THEN
         IF (rental_transaction_id_ IS NULL) THEN
            total_line_discount_ := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(order_no_,line_no_,rel_no_,line_item_no_, invoiced_qty_count_, 
                                                                                         price_conv_factor_, currency_rounding_);
         ELSE
            -- gelr:disc_price_rounded, passed discounted_price_rounded_ to Rental_Transaction_API.Get_Total_Order_Line_Discount
            $IF Component_Rental_SYS.INSTALLED $THEN
               total_line_discount_ := Rental_Transaction_API.Get_Total_Order_Line_Discount(rental_transaction_id_, line_discount_pct_, price_conv_factor_, currency_rounding_, discounted_price_rounded_ => discounted_price_rounded_);
            $ELSE
               Error_SYS.Component_Not_Exist('RENTAL');
            $END
         END IF;
      ELSE                                                                             
         -- NOTE: When creating credit/ correction invoice, discount details are fetched from connected debit invoice
         total_line_discount_ := Cust_Invoice_Item_Discount_API.Get_Total_Line_Discount(company_, deb_invoice_id_, deb_item_id_, invoiced_qty_count_, 
                                                                                        price_conv_factor_, currency_rounding_);
      END IF;
   END IF;
   Fetch_Keys_In_Inv_Type___ (is_adv_deb_inv_, source_key_rec_, company_, headrec_.invoice_type, order_no_, line_no_, rel_no_,
                              line_item_no_, charge_seq_no_, rma_no_ , rma_line_no_, rma_charge_no_, shipment_id_, invoice_id_,
                              deb_invoice_id_, deb_item_id_  ); 
   linerec_.free_of_charge_tax_basis  := NVL(free_of_charge_tax_basis_, linerec_.free_of_charge_tax_basis);
   IF linerec_.free_of_charge_tax_basis IS NOT NULL THEN
      linerec_.free_of_charge_tax_basis := ROUND((linerec_.free_of_charge_tax_basis/ NVL(deb_inv_quantity_, linerec_.buy_qty_due)) * invoiced_qty_count_, currency_rounding_);
   END IF;
   IF (is_adv_deb_inv_ = 'TRUE')THEN
      Trace_SYS.Message('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$Calculate_Adv_Inv_Amts___$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
      -- Calculate the net curr amount and vat curr amount and tax information for advance invoices
      Calculate_Adv_Inv_Amts___ (tax_calc_structure_id_, net_curr_amount_, vat_curr_amount_, vat_dom_amount_, vat_para_amount_, adv_inv_tax_info_table_, adv_inv_tax_msg_,
                                 company_, invoice_id_,  headrec_.invoice_date, headrec_.curr_rate, headrec_.customer_no, temp_unit_price_incl_tax_,
                                 temp_sale_unit_price_, headrec_.currency_code, delivery_address_id_);
   temp_unit_price_incl_tax_ := net_curr_amount_ + vat_curr_amount_;
   temp_sale_unit_price_     := net_curr_amount_;
   ELSE
      -- Calculate the net curr amount and vat curr amount
      -- Send calculated line discount amount with tax and without tax instead of discount percentage. 
      Calculate_Line_Amounts___(tax_calc_structure_id_, vat_dom_amount_, net_curr_amount_, vat_curr_amount_, company_, invoice_id_,
                                item_id_, source_key_rec_.source_ref1, source_key_rec_.source_ref2, source_key_rec_.source_ref3, source_key_rec_.source_ref4, source_key_rec_.source_ref5, source_key_rec_.source_ref_type, invoiced_qty_count_, price_conv_factor_, 
                                temp_sale_unit_price_, temp_unit_price_incl_tax_, tax_code_,
                                total_line_discount_, order_discount_, currency_rounding_, add_discount_,
                                headrec_.use_price_incl_tax, linerec_.free_of_charge_tax_basis, headrec_.curr_rate);
   END IF;
   Trace_SYS.Field('vat_dom_amount_',vat_dom_amount_);
   Trace_SYS.Field('net_curr_amount_',net_curr_amount_);
   Trace_SYS.Field('vat_curr_amount_',vat_curr_amount_);
      
   IF (linerec_.free_of_charge_tax_basis IS NOT NULL) AND (Customer_Order_API.Get_Free_Of_Chg_Tax_Pay_Par_Db(order_no_) = Tax_Paying_Party_API.DB_COMPANY) THEN
      comp_bearing_tax_amt_ := vat_dom_amount_;
      vat_curr_amount_ := 0;
      vat_dom_amount_  := 0;
   END IF;
   IF (headrec_.use_price_incl_tax = 'TRUE') THEN
      new_charge_percent_basis_ := ROUND(charge_percent_basis_, currency_rounding_);
   ELSE
      new_charge_percent_basis_ := charge_percent_basis_;
   END IF;

   -- If item is a charge, get Price U/M from Sales U/M instead
   IF (charge_seq_no_ IS NULL AND rma_charge_no_ IS NULL) THEN
      IF (order_no_ IS NOT NULL) THEN
         price_um_ := Customer_Order_Line_API.Get_Price_Unit_Meas(order_no_,line_no_,rel_no_,line_item_no_);
      ELSE
         price_um_ := Sales_Part_API.Get_Price_Unit_Meas(contract_,catalog_no_);
      END IF;
   ELSE
      price_um_ := sales_unit_meas_;
   END IF;

   chk_ser_ref_ := Customer_Order_Inv_Head_API.Get_Series_Reference__(company_, invoice_id_);

   IF (chk_ser_ref_ IS NULL) THEN
      debit_invoice_no_ := Return_Material_Line_API.Get_Debit_Invoice_No(rma_no_,rma_line_no_);
      IF (debit_invoice_no_ IS NOT NULL) THEN
          series_id_ := Return_Material_Line_API.Get_Debit_Invoice_Series_Id(rma_no_,rma_line_no_);
      END IF;

      IF(rma_charge_no_ IS NOT NULL) THEN 
         headrec_          := Customer_Order_Inv_Head_API.Get(company_, deb_invoice_id_);
         debit_invoice_no_ := headrec_.invoice_no;
         series_id_        := headrec_.series_id;
      END IF; 
    END IF;

   item_rec_.company             := company_;
   item_rec_.invoice_id          := invoice_id_;
   item_rec_.creator             := 'CUSTOMER_ORDER_INV_ITEM_API';
   item_rec_.c1                  := order_no_;
   item_rec_.c2                  := line_no_;
   item_rec_.c3                  := rel_no_;
   item_rec_.n1                  := line_item_no_;
   item_rec_.c4                  := pos_;
   item_rec_.c5                  := catalog_no_;
   item_rec_.c6                  := catalog_desc_;
   item_rec_.n2                  := invoiced_qty_;
   item_rec_.c7                  := sales_unit_meas_;
   item_rec_.n3                  := price_conv_factor_;
   item_rec_.c8                  := price_um_;
   item_rec_.n4                  := temp_sale_unit_price_;
   item_rec_.n15                 := temp_unit_price_incl_tax_;
   item_rec_.n5                  := discount_;
   item_rec_.n6                  := order_discount_;
   item_rec_.c9                  := customer_po_no_;
   item_rec_.c10                 := contract_;
   item_rec_.n7                  := charge_seq_no_;
   item_rec_.c11                 := charge_group_;
   item_rec_.n8                  := stage_;
   item_rec_.n9                  := rma_no_;
   item_rec_.n10                 := rma_line_no_;
   item_rec_.n11                 := rma_charge_no_;
   item_rec_.n12                 := add_discount_;
   item_rec_.n13                 := charge_percent_;
   item_rec_.n14                 := new_charge_percent_basis_;
   item_rec_.n16                 := rental_transaction_id_;
   item_rec_.n17                 := invoiced_qty_;
   item_rec_.n18                 := comp_bearing_tax_amt_;
   item_rec_.c22                 := linerec_.free_of_charge;
   item_rec_.n19                 := linerec_.free_of_charge_tax_basis;   
   -- gelr:disc_price_rounded, begin
   item_rec_.n20                 := original_discount_;
   item_rec_.n21                 := original_add_discount_;
   item_rec_.n22                 := original_order_discount_;   
   -- gelr:disc_price_rounded, end
   
   -- gelr: acquisition_origin, begin
   item_rec_.acquisition_origin  := linerec_.acquisition_origin;
   -- gelr: acquisition_origin, end
   -- gelr:good_service_statistical_code, begin
   item_rec_.statistical_code    := linerec_.statistical_code;
   -- gelr:good_service_statistical_code, end
   item_rec_.net_curr_amount     := net_curr_amount_;
   item_rec_.vat_curr_amount     := vat_curr_amount_;
   item_rec_.vat_dom_amount      := vat_dom_amount_;
   item_rec_.vat_parallel_amount := vat_para_amount_;
   item_rec_.vat_code            := tax_code_;
   item_rec_.series_reference    := series_id_;
   item_rec_.number_reference    := debit_invoice_no_;
   item_rec_.prel_update_allowed := prel_update_allowed_;
   item_rec_.c16                 := sales_part_rebate_group_;
   item_rec_.c17                 := assortment_id_;
   item_rec_.c18                 := assortment_node_id_;
   item_rec_.c19                 := delivery_address_id_; 
   item_rec_.income_type_id      := income_type_id_;
   item_rec_.tax_calc_structure_id := tax_calc_structure_id_;
   
   -- gelr:prepayment_tax_document, begin  
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'PREPAYMENT_TAX_DOCUMENT') = Fnd_Boolean_API.DB_TRUE) THEN
      IF (headrec_.prepay_adv_inv_id IS NOT NULL) THEN
         -- Create credit tax documents
         Tax_Document_Offset_API.Get_Total_Amounts(matched_offset_amount_, matched_tax_amount_, company_, deb_invoice_id_);         
         IF (matched_offset_amount_ != 0 AND matched_tax_amount_ != 0) THEN
            not_matched_amount_                := Tax_Document_Offset_API.Get_Remaining_Curr_Amount(company_, deb_invoice_id_, tax_code_);            
            unused_prepay_tax_amount_          := Tax_document_offset_API.Get_Remaining_Tax_Curr_Amount(company_, deb_invoice_id_, tax_code_);
            unused_prepay_tax_base_            := not_matched_amount_ - unused_prepay_tax_amount_;                           
            item_rec_.prepay_tax_base_curr_amt := - unused_prepay_tax_base_; 
            item_rec_.prepay_tax_curr_amount   := - unused_prepay_tax_amount_;              
         ELSE    
            item_rec_.prepay_tax_base_curr_amt := - prepay_tax_base_curr_amt_; 
            item_rec_.prepay_tax_curr_amount   := - prepay_tax_curr_amount_;                      
         END IF;         
      ELSE 
         IF (prel_update_allowed_ = 'FALSE' OR headrec_.invoice_type = 'CUSTORDCRE') THEN
            item_rec_.prepay_tax_base_curr_amt := - prepay_tax_base_curr_amt_; 
            item_rec_.prepay_tax_curr_amount   := - prepay_tax_curr_amount_;          
         ELSE 
            item_rec_.prepay_tax_base_curr_amt := prepay_tax_base_curr_amt_; 
            item_rec_.prepay_tax_curr_amount   := prepay_tax_curr_amount_;                      
         END IF;
         item_rec_.prepay_tax_document_id := prepay_tax_document_id_;                
      END IF;
   END IF;   
   -- gelr:prepayment_tax_document, end
   
   IF (order_no_ IS NOT NULL) AND (line_no_ IS NOT NULL) AND (rel_no_ IS NOT NULL) AND (line_item_no_ IS NOT NULL) THEN
      item_rec_.c12           := linerec_.configuration_id;
      item_rec_.allocation_id := linerec_.allocation_id;
   ELSIF (rma_no_ IS NOT NULL) AND (rma_line_no_ IS NOT NULL) THEN
      item_rec_.c12           := Return_Material_Line_API.Get_Configuration_Id(rma_no_, rma_line_no_);   
   ELSE
      item_rec_.c12 := '*';
   END IF;

   IF (order_no_ IS NOT NULL) THEN
      item_rec_.c13 := Customer_Order_API.Get_Customer_No(order_no_);
   ELSIF (rma_no_ IS NOT NULL) THEN
      item_rec_.c13 := Return_Material_API.Get_Customer_No(rma_no_);
   ELSIF (shipment_id_ IS NOT NULL) THEN
      item_rec_.c13 := Shipment_API.Get_Receiver_Id(shipment_id_);
   END IF;

   IF (charge_seq_no_ IS NULL AND rma_charge_no_ IS NULL) THEN
      IF (Sales_Part_API.Get_Taxable_Db(contract_, catalog_no_) = Fnd_Boolean_API.DB_TRUE) THEN
         item_rec_.taxable := 'TRUE';
      ELSE
         item_rec_.taxable := 'FALSE';
      END IF;
   ELSIF (charge_seq_no_ IS NOT NULL) THEN
      -- customer order charge line
      IF (Sales_Charge_Type_API.Get_Taxable_Db(contract_, Customer_Order_Charge_API.Get_Charge_Type(order_no_, charge_seq_no_)) = Fnd_Boolean_API.DB_TRUE) THEN
         item_rec_.taxable := 'TRUE';
      ELSE
         item_rec_.taxable := 'FALSE';
      END IF;
   ELSE
      -- Sales Tax for returned charghes without order connection not yet implemented.
      item_rec_.taxable := 'FALSE';
   END IF;

   item_rec_.deliv_type_id := deliv_type_id_;
   item_rec_.delivery_country   := linerec_.country_code;
   -- Create reference (The key to identify from creating module)
   -- Fetch next ivc item no from sequence.
   SELECT customer_order_inv_item_seq.nextval
   INTO ivc_item_seq_no_
   FROM dual;

   reference_ := 'CO-' || TO_CHAR(ivc_item_seq_no_);
   item_rec_.reference := reference_;

   IF customer_tax_usage_type_ IS NULL THEN
      item_rec_.cust_tax_usage_type := Tax_Handling_Order_Util_API.Get_Cust_Tax_Usage_Type(source_key_rec_,
                                                                                           company_,
                                                                                           item_rec_.c13);
   ELSE
      item_rec_.cust_tax_usage_type := customer_tax_usage_type_;
   END IF;
   
   -- Create the invoice item in the Invoice module
   Customer_Invoice_Pub_Util_API.Create_Invoice_Item(item_rec_);

   item_id_ := item_rec_.item_id;
   IF (is_adv_deb_inv_ = 'TRUE') THEN
      Invoice_Customer_Order_API.Create_Adv_Inv_Tax_Item(adv_inv_tax_info_table_, company_,invoice_id_,item_id_);
   END IF;
EXCEPTION
   WHEN others THEN
      RAISE;
END Create_Invoice_Item;


-- Create_Credit_Invoice_Items
--   This method will create all the invoice lines for the credit and correction invoices.
--   The term 'Credit' is included in the method name since we thought
--   correction invoice could also be looked as another invoice to handle some credit information.
PROCEDURE Create_Credit_Invoice_Items (
   company_                 IN VARCHAR2,
   credit_invoice_id_       IN NUMBER,
   ref_invoice_id_          IN NUMBER,
   invoice_category_        IN VARCHAR2 DEFAULT NULL,
   use_ref_inv_curr_rate_   IN VARCHAR2 DEFAULT 'TRUE',
   exclude_service_items_   IN VARCHAR2 DEFAULT 'FALSE' )
IS
   -- avoid crelines of correction invoice
   CURSOR get_invoice_item_ids IS
      SELECT item_id
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = ref_invoice_id_
      AND    company = company_
      AND    prel_update_allowed = 'TRUE'
      ORDER BY item_id;

   item_rec_          Public_Rec;
   line_type_         VARCHAR2(6);
   invoice_type_      VARCHAR2(20);
   cor_inv_type_      VARCHAR2(20);
   col_inv_type_      VARCHAR2(20);
   is_prep_based_inv_ VARCHAR2(5);
   linerec_      Customer_Order_Line_API.Public_Rec;
   invoice_category_check_  VARCHAR2(52);
   include_item_      BOOLEAN;
BEGIN

   invoice_type_ := Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, credit_invoice_id_);
   cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   col_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);   
   
   IF (invoice_category_ = 'RATE1' OR invoice_category_ = 'RATE2') THEN
      invoice_category_check_ := invoice_category_;
   ELSE
      invoice_category_check_ := NULL;
   END IF;
   IF (invoice_category_check_ IS NULL OR invoice_category_check_ = 'RATE2' ) THEN
      IF invoice_type_ IN (cor_inv_type_, col_inv_type_)THEN
         -- Inside this loop we'll be creating the debit lines of the correction invoice.
         -- The item ids of the debit type lines should be lesser than the credit type lines
         FOR inv_rec_ IN get_invoice_item_ids LOOP
            item_rec_      :=  Get(company_, ref_invoice_id_, inv_rec_.item_id);            
            linerec_       :=  Customer_Order_Line_API.Get(item_rec_.order_no, item_rec_.line_no, item_rec_.release_no, item_rec_.line_item_no);
            include_item_  := TRUE;
            IF (linerec_.supply_code = 'SEO' AND linerec_.demand_code != 'CRO') THEN
               IF (exclude_service_items_ = 'FALSE') THEN
                  Error_SYS.Record_General(lu_name_, 'SERVICECREDITERR: Creating a credit/correction invoice is not allowed. Service crediting/corrections should be handled from the service itself.');
               ELSE
                  include_item_ := FALSE;
               END IF;
            END IF;
            IF (include_item_) THEN
               item_rec_.prel_update_allowed := 'TRUE';
               -- line_type_ is not related to a database column, but this is used to denote the line type
               -- when calculating the quantities, etc in the Create_Crdit_Invoice_Item___ method.
               line_type_                    := 'DEBIT';
               Create_Credit_Invoice_Item___(item_rec_, credit_invoice_id_, line_type_, use_ref_inv_curr_rate_);
            END IF;
         END LOOP;
      END IF;
   END IF;

   is_prep_based_inv_ := Invoice_API.Get_Prepay_Based_Inv_Db(company_, ref_invoice_id_);
   -- Inside this loop we'll be creating the credit lines of the correction invoice and
   -- all the lines in the credit invoices.
   IF (invoice_category_check_ IS NULL OR invoice_category_check_ = 'RATE1' ) THEN 
      FOR inv_rec_ IN get_invoice_item_ids LOOP
         item_rec_ := Get(company_, ref_invoice_id_, inv_rec_.item_id);
         linerec_  :=  Customer_Order_Line_API.Get(item_rec_.order_no, item_rec_.line_no, item_rec_.release_no, item_rec_.line_item_no);
         include_item_ := TRUE;
         IF (linerec_.supply_code = 'SEO' AND linerec_.demand_code != 'CRO') THEN
            IF (exclude_service_items_ = 'FALSE') THEN
               Error_SYS.Record_General(lu_name_, 'SERVICECREDITERR: Creating a credit/correction invoice is not allowed. Service crediting/corrections should be handled from the service itself.');
            ELSE
               include_item_ := FALSE;
            END IF;
         END IF;
         IF (include_item_) THEN
            -- line_type_ will be CREDIT for credit lines in both correction and credit invoice.
            -- we can use the line type to calcualte quantities and tax amounts
            line_type_ := 'CREDIT';
            IF (invoice_type_ IN (cor_inv_type_, col_inv_type_)) THEN
               -- credit type lines in the correction invoice should not be updatable at the 'Preliminary' state
               item_rec_.prel_update_allowed := 'FALSE';
            ELSE
               item_rec_.prel_update_allowed := 'TRUE';
            END IF;

            IF (item_rec_.order_no IS NOT NULL) THEN
               Order_Line_Commission_API.Set_Order_Com_Lines_Changed(item_rec_.order_no, item_rec_.line_no, item_rec_.release_no, item_rec_.line_item_no);
            END IF;

            -- If Prepayment based invoice, then credit invoice creation process will redirect to a new method.
            -- Else follow the normal path
            IF (is_prep_based_inv_ = 'TRUE') THEN
               Create_Credit_Prepaym_Items___ (item_rec_, credit_invoice_id_);
            ELSE
               Create_Credit_Invoice_Item___(item_rec_, credit_invoice_id_, line_type_, use_ref_inv_curr_rate_);
            END IF;
         END IF;
      END LOOP;
      END IF;
END Create_Credit_Invoice_Items;


-- Get_First_Order
--   Returns order_no for a specified invoice id.
@UncheckedAccess
FUNCTION Get_First_Order (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   first_order_ CUSTOMER_ORDER_INV_ITEM.order_no%TYPE;
   CURSOR get_order IS
      SELECT order_no
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE invoice_id = invoice_id_
      AND company = company_;
BEGIN
   OPEN get_order;
   FETCH get_order INTO first_order_;
   IF get_order%NOTFOUND THEN
      first_order_ := NULL;
   END IF;
   CLOSE get_order;
   RETURN first_order_;
END Get_First_Order;



-- Get_Item_Id
--   Return the item_id for the specified order line on the specified
--   invoice. If the line is not on the invoice return NULL.
@UncheckedAccess
FUNCTION Get_Item_Id (
   invoice_id_   IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_ITEM.item_id%TYPE;
   
   CURSOR get_attr IS
      SELECT item_id
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    release_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    charge_seq_no IS NULL
      AND    prel_update_allowed = 'TRUE';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%NOTFOUND THEN
      temp_ := NULL;
   END IF;
   CLOSE get_attr;
   RETURN temp_;
END Get_Item_Id;


-- Get_Sale_Unit_Price
--   *******************************************************************************************************************************************************
--   *** This method was kept for reverse compatibility, and DO NOT USE in aplication because cursor can fetch multiple records. PLEASE REMOVE IN PROJECT***
--   *******************************************************************************************************************************************************
--   Return the first available sale_unit_price for the specified order line on the specified
--   invoice with no specific priority. If the line is not on the invoice return NULL.
@UncheckedAccess
FUNCTION Get_Sale_Unit_Price (
   invoice_id_   IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_ITEM.sale_unit_price%TYPE;
   CURSOR get_attr IS
      SELECT sale_unit_price
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    release_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    charge_seq_no IS NULL
      AND    prel_update_allowed = 'TRUE';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%NOTFOUND THEN
      temp_ := NULL;
   END IF;
   CLOSE get_attr;
   RETURN temp_;
END Get_Sale_Unit_Price;

-- Get_Item_Sale_Unit_Price
--   Return the sale_unit_price for the specified invoice item; if not found, return 0.
@UncheckedAccess
FUNCTION Get_Item_Sale_Unit_Price (
   company_     IN VARCHAR2,
   invoice_id_  IN NUMBER,
   item_id_     IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_ITEM.sale_unit_price%TYPE;

   CURSOR get_attr IS
      SELECT sale_unit_price
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_
      AND    item_id    = item_id_
      AND    company    = company_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%NOTFOUND THEN
      temp_ := 0;
   END IF;
   CLOSE get_attr;
   RETURN temp_;
END Get_Item_Sale_Unit_Price;

-- Get_Unit_Price_Incl_Tax
--   *******************************************************************************************************************************************************
--   *** This method was kept for reverse compatibility, and DO NOT USE in aplication because cursor can fetch multiple records. PLEASE REMOVE IN PROJECT***
--   *******************************************************************************************************************************************************
--   Return the unit_price_incl_tax for the specified order line on the specified
--   invoice. If the line is not on the invoice return NULL.
@UncheckedAccess
FUNCTION Get_Unit_Price_Incl_Tax (
   invoice_id_   IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_ITEM.unit_price_incl_tax%TYPE;
   CURSOR get_attr IS
      SELECT unit_price_incl_tax
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE invoice_id = invoice_id_
      AND   order_no = order_no_
      AND   line_no = line_no_
      AND   release_no = rel_no_
      AND   line_item_no = line_item_no_
      AND   charge_seq_no IS NULL
      AND   prel_update_allowed = 'TRUE';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%NOTFOUND THEN
      temp_ := NULL;
   END IF;
   CLOSE get_attr;
   RETURN temp_;
END Get_Unit_Price_Incl_Tax;


-- Get_Net_Curr_Amount
--   *******************************************************************************************************************************************************
--   *** This method was kept for reverse compatibility, and DO NOT USE in aplication because cursor can fetch multiple records. PLEASE REMOVE IN PROJECT***
--   *******************************************************************************************************************************************************
--   Return the net_curr_amount for the specified order line on the specified
--   invoice. If the line is not on the invoice return NULL.
--   Get net_curr_amount using invoice details. Return the net amount
--   in invoice currency for the specified order line on the specified
--   invoice. If the order line is not on the invoice return NULL.
@UncheckedAccess
FUNCTION Get_Net_Curr_Amount (
   invoice_id_   IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_  CUSTOMER_ORDER_INV_ITEM.net_curr_amount%TYPE;

   CURSOR get_attr IS
      SELECT net_curr_amount
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    release_no = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%NOTFOUND THEN
      temp_ := NULL;
   END IF;
   CLOSE get_attr;
   RETURN temp_;
END Get_Net_Curr_Amount;



-- Get_Net_Curr_Amount
--   Return the net_curr_amount for the specified order line on the specified
--   invoice. If the line is not on the invoice return NULL.
--   Get net_curr_amount using invoice details. Return the net amount
--   in invoice currency for the specified order line on the specified
--   invoice. If the order line is not on the invoice return NULL.
@UncheckedAccess
FUNCTION Get_Net_Curr_Amount (
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   invoice_item_ IN NUMBER,
   party_type_   IN VARCHAR2,
   identity_     IN VARCHAR2 ) RETURN NUMBER
IS
   temp_  CUSTOMER_ORDER_INV_ITEM.net_curr_amount%TYPE;

   CURSOR get_attr IS
      SELECT net_curr_amount
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = invoice_item_
      AND    party_type = party_type_
      AND    identity = identity_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Net_Curr_Amount;


@UncheckedAccess
FUNCTION Get_Net_Curr_Amount (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_ITEM.net_curr_amount%TYPE;
   CURSOR get_attr IS
      SELECT net_curr_amount
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Net_Curr_Amount;


-- Get_Invoiced_Qty
--   Return the invoiced_qty for the specified order line on the specified
--   invoice. If the line is not on the invoice return 0.
@UncheckedAccess
FUNCTION Get_Invoiced_Qty (
   invoice_id_   IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_  CUSTOMER_ORDER_INV_ITEM.invoiced_qty%TYPE;

   CURSOR get_attr IS
      SELECT invoiced_qty
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    release_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    prel_update_allowed = 'TRUE';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%NOTFOUND THEN
      temp_ := 0;
   END IF;
   CLOSE get_attr;
   RETURN temp_;
END Get_Invoiced_Qty;



-- Fetch_Order_Keys
--   Return the customer order line key values for the specified invoice item.
PROCEDURE Fetch_Order_Keys (
   order_no_     OUT VARCHAR2,
   line_no_      OUT VARCHAR2,
   rel_no_       OUT VARCHAR2,
   line_item_no_ OUT NUMBER,
   invoice_id_   IN  NUMBER,
   item_id_      IN  NUMBER )
IS
   CURSOR get_keys IS
      SELECT order_no, line_no, release_no, line_item_no
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE item_id = item_id_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_keys;
   FETCH get_keys INTO order_no_, line_no_, rel_no_, line_item_no_;
   IF (get_keys%NOTFOUND) THEN
      order_no_ := NULL;
   END IF;
   CLOSE get_keys;
END Fetch_Order_Keys;


PROCEDURE Fetch_Unknown_Item_Attributes (
   order_attributes_ IN OUT VARCHAR2,
   company_          IN     VARCHAR2,
   dummy_            IN     VARCHAR2,
   party_type_       IN     VARCHAR2,
   invoice_id_       IN     NUMBER,
   item_id_          IN     NUMBER )
IS
   order_no_               CUSTOMER_ORDER_INV_ITEM.order_no%TYPE;
   line_no_                CUSTOMER_ORDER_INV_ITEM.line_no%TYPE;
   release_no_             CUSTOMER_ORDER_INV_ITEM.release_no%TYPE;
   catalog_no_             CUSTOMER_ORDER_INV_ITEM.catalog_no%TYPE;
   description_            CUSTOMER_ORDER_INV_ITEM.description%TYPE;
   invoiced_qty_           NUMBER;
   sale_um_                CUSTOMER_ORDER_INV_ITEM.sale_um%TYPE;
   sale_unit_price_        NUMBER;
   unit_price_incl_tax_    NUMBER;
   price_um_               CUSTOMER_ORDER_INV_ITEM.price_um%TYPE;
   price_conv_             NUMBER;
   discount_               NUMBER;
   order_discount_         NUMBER;
   customer_po_no_         CUSTOMER_ORDER_INV_ITEM.customer_po_no%TYPE;
   customer_part_no_       VARCHAR2(45);
   salespart_cr_rec_       SALES_PART_CROSS_REFERENCE_API.Public_Rec;
   linerec_                Customer_Order_Line_API.Public_Rec;
   identity_               CUSTOMER_ORDER_INV_ITEM.identity%TYPE;
   contract_               VARCHAR2(100);
   line_item_no_           NUMBER;
   additional_discount_    NUMBER;
   real_ship_date_         DATE;
   currency_rounding_      NUMBER;
   total_order_discount_   NUMBER;
   sales_price_            NUMBER;
   discount_amount_        NUMBER;
   charge_percent_         NUMBER;
   charge_percent_basis_   NUMBER;
   delivery_address_       VARCHAR2(100);
   ship_addr_no_           VARCHAR2(50);
   ship_address1_          VARCHAR2(50);
   ship_address2_          VARCHAR2(50);
   ship_zip_code_          VARCHAR2(50);
   ship_city_              VARCHAR2(50);
   ship_state_             VARCHAR2(50);
   ship_county_            VARCHAR2(50);
   ship_country_code_      VARCHAR2(50);
   delnotes_               VARCHAR2(2000) := NULL;
   note_id_                NUMBER;
   notes_                  VARCHAR2(2000);
   document_code_          VARCHAR2(3);
   invoice_type_           CUSTOMER_ORDER_INV_ITEM.invoice_type%TYPE;
   net_curr_amount_        CUSTOMER_ORDER_INV_ITEM.net_curr_amount%TYPE;
   company_def_inv_type_rec_   Company_Def_Invoice_Type_API.Public_Rec;
   additional_disc_amount_ NUMBER;
   group_disc_amount_      NUMBER;
   charge_seq_no_          NUMBER;
   rma_no_                 NUMBER;
   rma_line_no_            NUMBER;
   
   CURSOR get_item_data IS
      SELECT order_no,
             line_no,
             release_no,
             catalog_no,
             description,
             invoiced_qty,
             sale_um,
             NVL(sale_unit_price, charge_percent * charge_percent_basis / 100),
             NVL(unit_price_incl_tax, charge_percent * charge_percent_basis / 100),
             price_um,
             price_conv,
             discount,
             order_discount,
             customer_po_no,
             identity,
             contract,
             line_item_no,
             additional_discount,
             charge_percent,
             charge_percent_basis,
             invoice_type,
             charge_seq_no,
             rma_no,
             rma_line_no
      FROM  CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;

   CURSOR get_del_addr IS
      SELECT addr_1,
             ship_addr_no,
             address1,
             address2,
             zip_code,
             city,
             state,
             county,
             country_code
      FROM cust_order_line_address_2
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no= release_no_
      AND line_item_no = line_item_no_;

   CURSOR Get_Delivery_Notes IS
      SELECT DISTINCT delnote_no
      FROM  customer_order_delivery_tab cod,  cust_delivery_inv_ref_tab cdi
      WHERE cod.deliv_no   = cdi.deliv_no
      AND   cdi.company    = company_
      AND   cdi.invoice_id = invoice_id_
      AND   cdi.item_id    = item_id_
      AND   cod.cancelled_delivery = 'FALSE';
   
   CURSOR get_delivery_note_ref  IS
      SELECT DISTINCT delivery_note_ref
      FROM   customer_order_delivery_tab cod,  cust_delivery_inv_ref_tab cdi
      WHERE  cod.deliv_no   = cdi.deliv_no
      AND    cdi.company    = company_
      AND    cdi.invoice_id = invoice_id_
      AND    cdi.item_id    = item_id_
      AND    cod.cancelled_delivery = 'FALSE';

   total_tax_pct_   NUMBER;
BEGIN
   OPEN get_item_data;
   FETCH get_item_data INTO order_no_, line_no_, release_no_,
                            catalog_no_, description_, invoiced_qty_,
                            sale_um_, sale_unit_price_, unit_price_incl_tax_, price_um_,
                            price_conv_, discount_, order_discount_,
                            customer_po_no_, identity_, contract_,
                            line_item_no_, additional_discount_,
                            charge_percent_, charge_percent_basis_, invoice_type_, charge_seq_no_,
                            rma_no_, rma_line_no_;
   CLOSE get_item_data;

   linerec_          := Customer_Order_Line_API.Get(order_no_, line_no_, release_no_, line_item_no_);
   IF (charge_seq_no_ IS NULL) THEN
      customer_part_no_ :=  linerec_.customer_part_no;
      salespart_cr_rec_ :=  Sales_Part_Cross_Reference_API.Get(identity_,contract_,customer_part_no_);
   ELSE
      customer_part_no_ := NULL;
      salespart_cr_rec_ := NULL;
   END IF;

   IF (customer_part_no_ IS NOT NULL) AND (salespart_cr_rec_.catalog_desc IS NULL) THEN
      salespart_cr_rec_.catalog_desc := SUBSTR(description_,1,200);
   END IF;

   Client_SYS.Clear_Attr(order_attributes_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, order_attributes_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, order_attributes_);
   Client_SYS.Add_To_Attr('RELEASE_NO', release_no_, order_attributes_);
   Client_SYS.Add_To_Attr('CATALOG_NO', catalog_no_, order_attributes_);
   Client_SYS.Add_To_Attr('DESCRIPTION', description_, order_attributes_);
   Client_SYS.Add_To_Attr('INV_QTY', invoiced_qty_, order_attributes_);
   Client_SYS.Add_To_Attr('SALES_UNIT_MEAS', sale_um_, order_attributes_);
   Client_SYS.Add_To_Attr('SALES_UNIT_PRICE', sale_unit_price_, order_attributes_);
   --Client_SYS.Add_To_Attr('SALES_UNIT_PRICE', sale_unit_price_, order_attributes_);         -- SHKOLK SALES??
   Client_SYS.Add_To_Attr('PRICE_UNIT_MEAS', price_um_, order_attributes_);
   Client_SYS.Add_To_Attr('PRICE_CONV', price_conv_, order_attributes_);
   Client_SYS.Add_To_Attr('DISCOUNT', discount_, order_attributes_);
   Client_SYS.Add_To_Attr('ORDER_DISCOUNT', order_discount_, order_attributes_);
   Client_SYS.Add_To_Attr('CUSTOMER_PO_NO', customer_po_no_, order_attributes_);
   Client_SYS.Add_To_Attr('PURCHASE_PART', customer_part_no_, order_attributes_);
   Client_SYS.Add_To_Attr('PURCHASE_PART_DESCRIPTION', salespart_cr_rec_.catalog_desc, order_attributes_);
   Client_SYS.Add_To_Attr('SOURCE_UNIT_MEAS', linerec_.customer_part_unit_meas, order_attributes_);
   Client_SYS.Add_To_Attr('INVOICED_SOURCE_QTY', linerec_.customer_part_buy_qty, order_attributes_);
   real_ship_date_       := customer_order_line_api.get_real_ship_date(order_no_, line_no_, release_no_, line_item_no_);
   Client_SYS.Add_To_Attr('DELIVERY_DATE', real_ship_date_, order_attributes_);
   currency_rounding_    := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   total_order_discount_ := Get_Tot_Discount_For_Ivc_Item(company_, invoice_id_, item_id_);

   -- When price including tax is specified discount_amount_ will contain discount with tax.
   discount_amount_        := Cust_Invoice_Item_Discount_API.Get_Total_Line_Discount(company_, invoice_id_, item_id_, invoiced_qty_, price_conv_, 
                                                                                     currency_rounding_);
   -- Modified the calculation logic of discounts. When price including tax is specified, discount without tax is obtained from discount with tax.
   -- Calculation logic of discount_amount_ is modified to tally with invoice postings. 
   IF (Customer_Order_Inv_Head_API.Get_Use_Price_Incl_Tax_Db(company_, invoice_id_) = 'TRUE') THEN
      sales_price_            := price_conv_ * invoiced_qty_ * unit_price_incl_tax_;
      
      total_tax_pct_ :=  NVL(Source_Tax_Item_API.Get_Total_Tax_Percentage (company_,Tax_Source_API.DB_INVOICE,
                                                                           TO_CHAR(invoice_id_), TO_CHAR(item_id_),
                                                                           '*','*','*'),0);
      
      -- Additional and group discounts with tax
      additional_disc_amount_ := ROUND((sales_price_ - discount_amount_) * additional_discount_/100, currency_rounding_);
      group_disc_amount_ := ROUND((sales_price_ - discount_amount_) * order_discount_/100, currency_rounding_);
      
      -- Additional and group discounts without tax
      additional_disc_amount_ := ROUND(additional_disc_amount_/(1+total_tax_pct_/100),currency_rounding_);
      group_disc_amount_ := ROUND(group_disc_amount_/(1+total_tax_pct_/100),currency_rounding_);
      
      -- Fetch line discount without tax
      discount_amount_        := Cust_Invoice_Item_Discount_API.Get_Total_Line_Discount(company_, invoice_id_, item_id_, invoiced_qty_, price_conv_, 
                                                                                     currency_rounding_, total_tax_pct_);                                                                                     
   ELSE
      sales_price_            := price_conv_ * invoiced_qty_ * sale_unit_price_;
      additional_disc_amount_ := ROUND((sales_price_ - discount_amount_) * additional_discount_/100, currency_rounding_);
      group_disc_amount_      := ROUND((sales_price_ - discount_amount_) * order_discount_/100, currency_rounding_);
   END IF;                                                                                        
   
   Client_SYS.Add_To_Attr('LINE_DISCOUNT_AMT', discount_amount_, order_attributes_);
   Client_SYS.Add_To_Attr('ADD_DISCOUNT_AMT', additional_disc_amount_, order_attributes_);
   Client_SYS.Add_To_Attr('GROUP_DISCOUNT_AMT', group_disc_amount_, order_attributes_);
   discount_amount_        := discount_amount_ + additional_disc_amount_ + group_disc_amount_;

   Client_SYS.Add_To_Attr('DISCOUNT_AMOUNT', discount_amount_, order_attributes_);

   OPEN get_del_addr;
   FETCH get_del_addr INTO delivery_address_, ship_addr_no_, ship_address1_, ship_address2_, ship_zip_code_,
                           ship_city_, ship_state_, ship_county_, ship_country_code_;
   CLOSE get_del_addr;

   Client_SYS.Add_To_Attr('ADDITIONAL_DISCOUNT', additional_discount_, order_attributes_);
   Client_SYS.Add_To_Attr('TOTAL_DISCOUNT', total_order_discount_, order_attributes_);
   Client_SYS.Add_To_Attr('DELIVERY_ADDRESS', delivery_address_, order_attributes_);
   Client_SYS.Add_To_Attr('DELIVERY_ADDRESS_ID', ship_addr_no_, order_attributes_);
   Client_SYS.Add_To_Attr('DELIVERY_ADDRESS1', ship_address1_, order_attributes_);
   Client_SYS.Add_To_Attr('DELIVERY_ADDRESS2', ship_address2_, order_attributes_);
   Client_SYS.Add_To_Attr('DELIVERY_ADDRESS3', ship_zip_code_, order_attributes_);
   Client_SYS.Add_To_Attr('DELIVERY_ADDRESS4', ship_city_, order_attributes_);
   Client_SYS.Add_To_Attr('DELIVERY_ADDRESS5', ship_state_, order_attributes_);
   Client_SYS.Add_To_Attr('DELIVERY_ADDRESS6', ship_county_, order_attributes_);
   Client_SYS.Add_To_Attr('DELIVERY_COUNTRY',  ship_country_code_, order_attributes_);

   FOR get_deliver IN Get_Delivery_Notes LOOP
      IF get_deliver.delnote_no IS NOT NULL THEN
         delnotes_ := SUBSTR (delnotes_ || Delivery_Note_API.Get_Alt_Delnote_No(get_deliver.delnote_no) || ', ' , 1, 100);
      END IF;
   END LOOP;

   IF (delnotes_ IS NULL) THEN
      FOR get_deliver IN get_delivery_note_ref  LOOP
         IF get_deliver.delivery_note_ref IS NOT NULL THEN
            delnotes_ := SUBSTR (delnotes_ || get_deliver.delivery_note_ref || ', ' , 1, 2000);
         END IF;
      END LOOP;   
   END IF;
                   
   delnotes_ := RTRIM(RTRIM(delnotes_), ',');
   
   Client_SYS.Add_To_Attr('DELIVERY_NOTE_NOS', delnotes_, order_attributes_); -- List of Delivery Note numbers for the particular invoice line
   Client_SYS.Add_To_Attr('GTIN_NO', Part_Gtin_API.Get_Default_Gtin_No(catalog_no_), order_attributes_);
   Client_SYS.Add_To_Attr('CLASSIFICATION_STANDARD', linerec_.classification_standard, order_attributes_);
   Client_SYS.Add_To_Attr('CLASSIFICATION_PART_NO', linerec_.classification_part_no, order_attributes_);
   Client_SYS.Add_To_Attr('CLASSIFICATION_UNIT_MEAS', linerec_.classification_unit_meas, order_attributes_);
   Client_SYS.Add_To_Attr('CHARGE_PERCENT', charge_percent_, order_attributes_);
   Client_SYS.Add_To_Attr('CHARGE_PERCENT_BASIS', charge_percent_basis_, order_attributes_);
   
   company_def_inv_type_rec_ := Company_Def_Invoice_Type_API.Get(company_);
  
   IF (invoice_type_ IN ('CUSTORDDEB', 'CUSTCOLDEB', 'SELFBILLDEB')) THEN
      document_code_ := '4';
   ELSIF (invoice_type_ IN ('CUSTORDCRE', 'CUSTCOLCRE', 'SELFBILLCRE')) THEN
      document_code_ := '5';   
   ELSIF (invoice_type_ IN (company_def_inv_type_rec_.def_co_cor_inv_type, company_def_inv_type_rec_.def_col_cor_inv_type)) THEN
      net_curr_amount_ := Customer_Order_Inv_Head_API.Get_Net_Curr_Amount(company_, invoice_id_);
      IF (net_curr_amount_ >= 0) THEN
         document_code_ := '4';
      ELSE
         document_code_ := '5';
      END IF;
   END IF;

   IF (rma_no_ IS NOT NULL AND rma_line_no_ IS NOT NULL) THEN
      note_id_ := Return_Material_Line_API.Get_Note_Id(rma_no_, rma_line_no_);
   ELSE
      note_id_ := Customer_Order_Line_API.Get_Note_Id(order_no_, line_no_, release_no_, line_item_no_);
   END IF;
   notes_   := Document_Text_API.Get_All_Notes(note_id_, document_code_);

   Client_SYS.Add_To_Attr('LINE_DOC_TEXT', notes_, order_attributes_);
END Fetch_Unknown_Item_Attributes;


-- Get_Price_Info
--   Retrieve price and discount information for the specified invoice item.
PROCEDURE Get_Price_Info (
   sale_unit_price_     OUT NUMBER,
   unit_price_incl_tax_ OUT NUMBER,
   discount_            OUT NUMBER,
   order_discount_      OUT NUMBER,
   additional_disc_     OUT NUMBER,
   company_             IN  VARCHAR2,
   invoice_id_          IN  NUMBER,
   item_id_             IN  NUMBER )
IS
   CURSOR get_price_info IS
      SELECT NVL(sale_unit_price, charge_percent * charge_percent_basis / 100), 
			 NVL(unit_price_incl_tax, charge_percent * charge_percent_basis / 100),
			 discount, order_discount, additional_discount
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
BEGIN
   OPEN get_price_info;
   FETCH get_price_info INTO sale_unit_price_, unit_price_incl_tax_, discount_, order_discount_, additional_disc_;
   IF get_price_info%NOTFOUND THEN
      sale_unit_price_     := 0;
      unit_price_incl_tax_ := 0;
      discount_            := 0;
      order_discount_      := 0;
      additional_disc_ := 0;
   END IF;
   CLOSE get_price_info;
END Get_Price_Info;


-- Get_Order_Line_Invoice_Date
--   This function will return the first invoice date
@UncheckedAccess
FUNCTION Get_Order_Line_Invoice_Date (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN DATE
IS
   invoice_date_ DATE;
   invoice_id_   NUMBER;
   CURSOR get_first_invoice IS
      SELECT MIN(invoice_id)
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    release_no = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   OPEN get_first_invoice;
   FETCH get_first_invoice INTO invoice_id_;
   CLOSE get_first_invoice;
   invoice_date_ := Customer_Order_Inv_Head_API.Get_Invoice_Date(Site_API.Get_Company(Customer_Order_Line_API.Get_Contract(order_no_, line_no_, rel_no_, line_item_no_)),invoice_id_);
   RETURN invoice_date_;
END Get_Order_Line_Invoice_Date;



-- Get_Total_Net_Invoice_Amount
--   This method will return the sum of gross invoice amount of the particular
--   order line in base currency.
@UncheckedAccess
FUNCTION Get_Total_Net_Invoice_Amount (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_total_invoiced_amount IS
      SELECT SUM(net_dom_amount)
      FROM  CUSTOMER_ORDER_INV_ITEM
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   release_no = rel_no_
      AND   line_item_no = line_item_no_;
  
   total_net_dom_amount_ NUMBER:=0;

BEGIN
   OPEN get_total_invoiced_amount;
   FETCH get_total_invoiced_amount INTO total_net_dom_amount_;
   CLOSE get_total_invoiced_amount;
   
   RETURN NVL(total_net_dom_amount_, 0);
END Get_Total_Net_Invoice_Amount;


-- Is_Valid_Co_Line
--   Checks whether the invoice line and the customer order line details
--   those are passed to the method match. Returns 1 If the specified
--   invoice line matches with the order line. Returns 0 otherwise.
@UncheckedAccess
FUNCTION Is_Valid_Co_Line (
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   item_id_      IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR get_invoice_line IS
      SELECT   1
      FROM     customer_order_inv_item
      WHERE    company      = company_
      AND      invoice_id   = invoice_id_
      AND      item_id      = item_id_
      AND      order_no     = order_no_
      AND      line_no      = line_no_
      AND      release_no   = rel_no_
      AND      line_item_no = line_item_no_;
BEGIN
   OPEN get_invoice_line;
   FETCH get_invoice_line INTO dummy_;
   IF (get_invoice_line%FOUND) THEN
      CLOSE get_invoice_line;
      RETURN 1;
   END IF;
   CLOSE get_invoice_line;
   RETURN 0;
END Is_Valid_Co_Line;



-- Connected_To_Single_Occ_Addr
--   The method will check whether a single occurence address exist for a connected custome order or order line.
@UncheckedAccess
FUNCTION Connected_To_Single_Occ_Addr (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN VARCHAR2
IS
   order_no_        CUSTOMER_ORDER_INV_ITEM.order_no%TYPE;
   line_no_         CUSTOMER_ORDER_INV_ITEM.line_no%TYPE;
   release_no_      CUSTOMER_ORDER_INV_ITEM.release_no%TYPE;
   line_item_no_    NUMBER;   

   CURSOR get_order_details IS
      SELECT order_no, line_no, release_no, line_item_no
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
BEGIN
   OPEN get_order_details;
   FETCH get_order_details INTO order_no_, line_no_, release_no_, line_item_no_;
   CLOSE get_order_details;
   RETURN Customer_Order_API.Is_Single_Occ_Addr_Connected(order_no_, line_no_, release_no_, line_item_no_);   
END Connected_To_Single_Occ_Addr;



-- Is_Manual_Liablty_Taxcode
--   The method will check whether a tax code of the connected invoice
--   line method is defined with Manual Tax Liability Date 'Manual'.
@UncheckedAccess
FUNCTION Is_Manual_Liablty_Taxcode (
   company_      IN VARCHAR2,
   fee_code_     IN VARCHAR2,
   invoice_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   liablty_date_  TAX_LIABLTY_DATE_EXCEPTION_TAB.customer_liability_date%TYPE;
   cor_inv_type_  VARCHAR2(20);
   col_inv_type_  VARCHAR2(20);
   pre_deb_inv_type_ VARCHAR2(20);
   pre_cre_inv_type_ VARCHAR2(20);
BEGIN
   cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   col_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);
   pre_deb_inv_type_ := NVL(Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_), 'COPREPAYDEB');
   pre_cre_inv_type_ := NVL(Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type (company_), 'COPREPAYCRE');
   IF (invoice_type_ IN ('CUSTORDDEB','CUSTCOLDEB', pre_deb_inv_type_)) THEN
	   liablty_date_ := Tax_Liability_Date_API.Encode(Tax_Liablty_Date_Exception_API.Get_Customer_Liability_Date(company_, fee_code_));
   ELSIF (invoice_type_ IN ('CUSTORDCRE', cor_inv_type_, 'CUSTCOLCRE', col_inv_type_, pre_cre_inv_type_)) THEN
	   liablty_date_ := Tax_Liability_Date_API.Encode(Tax_Liablty_Date_Exception_API.Get_Customer_Crdt_Liablty_Date(company_, fee_code_));
   END IF;
   IF (liablty_date_ = 'MANUAL') THEN
      RETURN 'TRUE';
   END IF;
   RETURN 'FALSE';
END Is_Manual_Liablty_Taxcode;



-- Has_Manual_Tax_Liablty_Lines
--   The method will check whether a connected invoice line having
--   multiple tax lines, if at least one tax code method is defined
--   with Manual Tax Liability Date 'Manual'.
@UncheckedAccess
FUNCTION Has_Manual_Tax_Liablty_Lines (
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   item_id_      IN NUMBER,
   invoice_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   tax_table_           Source_Tax_Item_API.source_tax_table;
BEGIN
   tax_table_ := Source_Tax_Item_API.Get_Tax_Items(company_, Tax_Source_API.DB_INVOICE, To_CHAR(invoice_id_), To_CHAR(item_id_), '*', '*', '*');
   IF (tax_table_.COUNT > 0)THEN
      FOR i IN 1..tax_table_.COUNT LOOP
         IF (Is_Manual_Liablty_Taxcode(company_, tax_table_(i).tax_code, invoice_type_) = 'TRUE') THEN
            RETURN 'TRUE';
         END IF;
      END LOOP;
   END IF;
   RETURN 'FALSE';
END Has_Manual_Tax_Liablty_Lines;



-- Create_Prepayment_Inv_Lines
--   This will be used to create prepayment invoice lines.
PROCEDURE Create_Prepayment_Inv_Lines (
   company_            IN VARCHAR2,
   invoice_id_         IN VARCHAR2,
   order_no_           IN VARCHAR2,
   payment_date_       IN DATE,
   prepaym_lines_attr_ IN VARCHAR2 )
IS
   line_attr_ VARCHAR2(32000);
   ptr_       NUMBER := NULL;
   name_      VARCHAR2(30);
   value_     VARCHAR2(2000);
BEGIN

   Client_SYS.Clear_Attr(line_attr_);
   WHILE (Client_SYS.Get_Next_From_Attr(prepaym_lines_attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'FEE_CODE') THEN
         Client_SYS.Add_To_Attr('FEE_CODE', value_, line_attr_);
      ELSIF (name_ = 'FEE_PERCENTAGE') THEN
         Client_SYS.Add_To_Attr('FEE_PERCENTAGE', value_, line_attr_);
      -- gelr:delivery_types_in_pbi, begin
      ELSIF (name_ = 'DELIVERY_TYPE') THEN
         Client_SYS.Add_To_Attr('DELIV_TYPE_ID', value_, line_attr_);
      -- gelr:delivery_types_in_pbi, end      
      ELSIF (name_ = 'NET_CURR_AMOUNT') THEN
         Client_SYS.Add_To_Attr('NET_CURR_AMOUNT', value_, line_attr_);
      ELSIF (name_ = 'TAX_CURR_AMOUNT') THEN
         Client_SYS.Add_To_Attr('TAX_CURR_AMOUNT', value_, line_attr_);
      ELSIF (name_ = 'GROSS_CURR_AMOUNT') THEN
         Client_SYS.Add_To_Attr('GROSS_CURR_AMOUNT', value_, line_attr_);
      ELSIF (name_ = 'DESCRIPTION') THEN
         Client_SYS.Add_To_Attr('DESCRIPTION', value_, line_attr_);
      ELSIF (name_ = 'END_OF_LINE') THEN
         Client_SYS.Add_To_Attr('COMPANY', company_, line_attr_);
         Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, line_attr_);
         Client_SYS.Add_To_Attr('ORDER_NO', order_no_, line_attr_);
         Client_SYS.Add_To_Attr('PAYMENT_DATE', payment_date_, line_attr_);
         Create_Prepayment_Inv_Line__(line_attr_);
         Client_SYS.Clear_Attr(line_attr_);
      END IF;
   END LOOP;
END Create_Prepayment_Inv_Lines;


-- Is_Prepaym_Lines_Exist
--   This method checks whether prepayment lines exist for a particular
--   invoice. If exists it will return TRUE otherwise FALSE.
@UncheckedAccess
FUNCTION Is_Prepaym_Lines_Exist (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   dummy_ NUMBER := 0;
   CURSOR exist_control IS
      SELECT DISTINCT 1
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    prel_update_allowed ='FALSE';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_control;
   RETURN 'FALSE';
END Is_Prepaym_Lines_Exist;



-- Get_Vat_Curr_Amount
--   Get vat_curr_amount using invoice details
@UncheckedAccess
FUNCTION Get_Vat_Curr_Amount (
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   invoice_item_ IN NUMBER,
   party_type_   IN VARCHAR2,
   identity_     IN VARCHAR2 ) RETURN NUMBER
IS
   temp_  CUSTOMER_ORDER_INV_ITEM.vat_curr_amount%TYPE;

   CURSOR get_attr IS
      SELECT vat_curr_amount
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = invoice_item_
      AND    party_type = party_type_
      AND    identity = identity_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Vat_Curr_Amount;



-- Get_Tot_Discount_For_Ivc_Item
--   Returns the total invoice item discount for a given invoice item line.
@UncheckedAccess
FUNCTION Get_Tot_Discount_For_Ivc_Item (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   discount_ NUMBER := 0;
   -- gelr:disc_price_rounded, added original_order_discount, original_add_discount
   CURSOR get_attr IS               
      SELECT (invoiced_qty * NVL(sale_unit_price, charge_percent * charge_percent_basis / 100) * price_conv)            price_base,
             (invoiced_qty * NVL(unit_price_incl_tax, charge_percent * charge_percent_basis / 100) * price_conv)        price_incl_tax_base,
             invoiced_qty, price_conv, order_discount, additional_discount, original_order_discount, original_add_discount
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;

   rec_ get_attr%ROWTYPE;
   line_discount_        NUMBER;
   price_base_           NUMBER;
   price_base_with_disc_ NUMBER;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO rec_;
   CLOSE get_attr;

   IF (CUSTOMER_ORDER_INV_HEAD_API.Get_Use_Price_Incl_Tax_Db(company_, invoice_id_) = 'TRUE') THEN
      price_base_ := NVL(rec_.price_incl_tax_base, 0); 
   ELSE
      price_base_ := NVL(rec_.price_base, 0);
   END IF;
   IF (price_base_ <> 0) THEN
      -- gelr:disc_price_rounded, begin
      -- use  original_quotation_discount, original_add_discount when using Discounted Price Rounded  
      IF (Get_Discounted_Price_Rounded(company_, invoice_id_, item_id_)) THEN
         line_discount_ := Cust_Invoice_Item_Discount_API.Get_Original_Total_Line_Disc(company_, invoice_id_, item_id_, rec_.invoiced_qty, rec_.price_conv);
         price_base_with_disc_ := ((price_base_ -  line_discount_) * (1 - (rec_.original_order_discount + NVL(rec_.original_add_discount, 0)) / 100)) ;      
      ELSE
      -- gelr:disc_price_rounded, end
         line_discount_ := Cust_Invoice_Item_Discount_API.Get_Total_Line_Discount(company_, invoice_id_, item_id_, rec_.invoiced_qty, rec_.price_conv);
         price_base_with_disc_ := ((price_base_ -  line_discount_) * (1 - (rec_.order_discount + NVL(rec_.additional_discount, 0)) / 100)) ;
      -- gelr:disc_price_rounded, begin         
      END IF;
      -- gelr:disc_price_rounded, end
      discount_ := ROUND(100 * (1 - (price_base_with_disc_/ price_base_)), 2);
   END IF;

   RETURN discount_;
END Get_Tot_Discount_For_Ivc_Item;

@UncheckedAccess
FUNCTION Check_Invoice_Text_Exists (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER) RETURN VARCHAR2
IS   
   CURSOR InvoiceText IS 
      SELECT invoice_text
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id   = item_id_;   
   temp_ VARCHAR2(2000);
BEGIN   
   OPEN InvoiceText;
   FETCH InvoiceText INTO temp_;
   CLOSE InvoiceText;
   
   IF temp_ IS NULL THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Check_Invoice_Text_Exists;

@UncheckedAccess
FUNCTION Get (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN Public_Rec
IS
   temp_ Public_Rec;
   -- gelr:prepayment_tax_document, added prepay_tax_base_curr_amt, prepay_tax_curr_amount, prepay_tax_document_id
   -- gelr:disc_price_rounded, added original_discount, original_add_discount, original_order_discount
   CURSOR get_attr IS
      SELECT company, invoice_id, item_id, contract, identity,
             deliv_type_id, vat_code, vat_rate, net_curr_amount, vat_curr_amount, gross_curr_amount,
             net_dom_amount, vat_dom_amount, reference, order_no,line_no, release_no, line_item_no,
             pos, catalog_no, description, invoiced_qty, sale_um, price_conv, price_um, sale_unit_price, unit_price_incl_tax,
             discount, order_discount, customer_po_no, charge_seq_no, charge_group, stage,
             additional_discount, prel_update_allowed ,prepay_invoice_no, prepay_invoice_series_id,
             sales_part_rebate_group, assortment_id, assortment_node_id, ship_addr_no, charge_percent, charge_percent_basis, rental_transaction_id, income_type_id, tax_calc_structure_id, rma_no,
             free_of_charge, free_of_charge_tax_basis, base_comp_bearing_tax_amt, customer_tax_usage_type, original_discount, original_add_discount, original_order_discount,
             acquisition_origin, statistical_code, prepay_tax_base_curr_amt, prepay_tax_curr_amount, prepay_tax_document_id
      FROM  CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get;



-- Get_Condition_Code
--   The method will retrieve the condition code entered on the Return Material Line
--   or the Customer Order Line which is connected to a particular Customer Invoice Line
@UncheckedAccess
FUNCTION Get_Condition_Code (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_invoice_line IS
      SELECT order_no, line_no, release_no, line_item_no, charge_seq_no, rma_no, rma_line_no
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;

   inv_line_rec_   get_invoice_line%ROWTYPE;
   condition_code_ VARCHAR2(10);

BEGIN
   OPEN get_invoice_line;
   FETCH get_invoice_line INTO inv_line_rec_;
   CLOSE get_invoice_line;

   IF (inv_line_rec_.rma_line_no IS NOT NULL) THEN
      condition_code_ := Return_Material_Line_API.Get_Condition_Code(inv_line_rec_.rma_no, inv_line_rec_.rma_line_no);
   ELSIF ((inv_line_rec_.line_no IS NOT NULL) AND (inv_line_rec_.charge_seq_no IS NULL)) THEN
      condition_code_ := Customer_Order_Line_API.Get_Condition_Code(inv_line_rec_.order_no, inv_line_rec_.line_no, inv_line_rec_.release_no, inv_line_rec_.line_item_no);
   END IF;

   RETURN condition_code_;
END Get_Condition_Code;



-- Get_Man_Tax_Liab_Date
--   Returns Manual Tax Liability Date.
@UncheckedAccess
FUNCTION Get_Man_Tax_Liab_Date (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN DATE
IS
   temp_  CUSTOMER_ORDER_INV_ITEM.man_tax_liability_date%TYPE;

   CURSOR get_liab_date IS
      SELECT man_tax_liability_date
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
BEGIN
   OPEN get_liab_date;
   FETCH get_liab_date INTO temp_;
   CLOSE get_liab_date;
   RETURN temp_;
END Get_Man_Tax_Liab_Date;



-- Get_Charge_Reference
--   Returns Charge Seq No. When Charge Seq No is NULL the function
--   returns Rma Charge No.
@UncheckedAccess
FUNCTION Get_Charge_Reference (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   temp1_ CUSTOMER_ORDER_INV_ITEM.charge_seq_no%TYPE;
   temp2_ CUSTOMER_ORDER_INV_ITEM.rma_charge_no%TYPE;

   CURSOR get_attr IS
      SELECT charge_seq_no, rma_charge_no
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;

BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp1_, temp2_;
   IF get_attr%NOTFOUND THEN
      CLOSE get_attr;
      RETURN NULL;
   END IF;
   CLOSE get_attr;
   RETURN NVL(temp1_, temp2_);
END Get_Charge_Reference;



-- Is_Co_Charge_Line_Invoiced
--   Returns whether or not a invoice is created to a specific
--   order_no and charge_seq_no.
@UncheckedAccess
FUNCTION Is_Co_Charge_Line_Invoiced (
   company_       IN VARCHAR2,
   order_no_      IN VARCHAR2,
   charge_seq_no_ IN NUMBER ) RETURN NUMBER
IS
   found_  NUMBER;
   CURSOR get_invoice_line IS
      SELECT 1
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company       = company_
      AND    order_no      = order_no_
      AND    charge_seq_no = charge_seq_no_;
BEGIN
   OPEN  get_invoice_line;
   FETCH get_invoice_line INTO found_;
   IF get_invoice_line%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE get_invoice_line;
   RETURN found_;
END Is_Co_Charge_Line_Invoiced;


-- Is_Co_Charge_Connected
--   Returns whether or not a selected invoice line is connected to a charge
@UncheckedAccess
FUNCTION Is_Co_Charge_Connected (
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER,
   item_id_       IN NUMBER ) RETURN VARCHAR2
IS
   found_  VARCHAR2(5);
   temp_   NUMBER;
   CURSOR get_invoice_line IS
      SELECT 1
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company     = company_
      AND    invoice_id  = invoice_id_
      AND    item_id     = item_id_
      AND    (charge_seq_no IS NOT NULL OR rma_charge_no IS NOT NULL);
BEGIN
   OPEN  get_invoice_line;
   FETCH get_invoice_line INTO temp_;
   IF get_invoice_line%NOTFOUND THEN
      found_ := 'FALSE';
   ELSE
      found_ := 'TRUE'; 
   END IF;
   CLOSE get_invoice_line;
   RETURN found_;
END Is_Co_Charge_Connected;

-- Modify_Invoice_Statistics
--   Modify the invoice statistics according to the modified data in invoice line.
PROCEDURE Modify_Invoice_Statistics (
   company_              IN VARCHAR2,
   invoice_id_           IN NUMBER,
   item_id_              IN NUMBER,
   price_adjust_updated_ IN BOOLEAN )
IS
   invline_rec_         CUSTOMER_ORDER_INV_ITEM%ROWTYPE;
   headrec_             Customer_Order_Inv_Head_API.Public_Rec;
   cost_                NUMBER := 0;
   invoiced_qty_        NUMBER := 0;
   price_qty_           NUMBER := 0;
   curr_discount_       NUMBER := 0;
   order_curr_discount_ NUMBER := 0; 
   add_curr_discount_   NUMBER := 0;
   stat_attr_           VARCHAR2(32000);  

   CURSOR get_inv_lines IS
      SELECT *
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
BEGIN


   headrec_ := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);

   OPEN get_inv_lines;
   FETCH get_inv_lines INTO invline_rec_;
   CLOSE get_inv_lines;

   Client_SYS.Clear_Attr(stat_attr_);

   IF (invline_rec_.order_no IS NULL) THEN
      IF (invline_rec_.rma_no IS NOT NULL) THEN         
         cost_ := Get_Total_Cost(company_,
                  invoice_id_,
                  item_id_,
                  invline_rec_.order_no,
                  invline_rec_.line_no,
                  invline_rec_.release_no,
                  invline_rec_.line_item_no,
                  invline_rec_.charge_seq_no,
                  invline_rec_.rma_no,
                  invline_rec_.rma_line_no,
                  invline_rec_.rma_charge_no,
                  invline_rec_.catalog_no,
                  invline_rec_.invoiced_qty,
                  invline_rec_.prel_update_allowed,
                  invline_rec_.net_dom_amount,
                  invline_rec_.invoice_type,
                  invline_rec_.pos,
                  headrec_.rma_no);

         invoiced_qty_ := invline_rec_.invoiced_qty;
         IF (invline_rec_.net_curr_amount <= 0) THEN            
            invoiced_qty_ := -1 * invoiced_qty_;
         END IF;

         price_qty_           := NVL(invoiced_qty_, 0) * invline_rec_.price_conv;
         curr_discount_       := Cust_Invoice_Item_Discount_API.Get_Total_Line_Discount(company_, invoice_id_, item_id_, price_qty_, 1);

         IF (CUSTOMER_ORDER_INV_HEAD_API.Get_Use_Price_Incl_Tax_Db(company_, invoice_id_) = 'TRUE') THEN
            order_curr_discount_ := (invline_rec_.order_discount * 0.01) * (invline_rec_.unit_price_incl_tax * price_qty_ - curr_discount_);
         ELSE            
            order_curr_discount_ := (invline_rec_.order_discount * 0.01) * (invline_rec_.sale_unit_price * price_qty_ - curr_discount_);
         END IF;

         Client_SYS.Add_To_Attr('INVOICED_QTY', invoiced_qty_, stat_attr_);
         Client_SYS.Add_To_Attr('PRICE_QTY', price_qty_, stat_attr_);
         Client_SYS.Add_To_Attr('COST', cost_, stat_attr_);
         Client_SYS.Add_To_Attr('CURR_DISCOUNT', curr_discount_, stat_attr_);
         Client_SYS.Add_To_Attr('ORDER_CURR_DISCOUNT', order_curr_discount_, stat_attr_); 
      END IF;
   ELSE
      IF (headrec_.price_adjustment = 'FALSE') THEN
         cost_ := Get_Total_Cost(company_,
                  invoice_id_,
                  item_id_,
                  invline_rec_.order_no,
                  invline_rec_.line_no,
                  invline_rec_.release_no,
                  invline_rec_.line_item_no,
                  invline_rec_.charge_seq_no,
                  invline_rec_.rma_no,
                  invline_rec_.rma_line_no,
                  invline_rec_.rma_charge_no,
                  invline_rec_.catalog_no,
                  invline_rec_.invoiced_qty,
                  invline_rec_.prel_update_allowed,
                  invline_rec_.net_dom_amount,
                  invline_rec_.invoice_type,
                  invline_rec_.pos,
                  headrec_.rma_no);

         invoiced_qty_ := invline_rec_.invoiced_qty;
         IF ((invline_rec_.net_curr_amount <= 0) AND (headrec_.invoice_type IN ('CUSTORDCRE', 'CUSTCOLCRE', 'SELFBILLCRE'))) THEN            
            invoiced_qty_ := -1 * invoiced_qty_;         
         END IF;

         price_qty_           := NVL(invoiced_qty_ , 0) * invline_rec_.price_conv;
         curr_discount_       := Cust_Invoice_Item_Discount_API.Get_Total_Line_Discount(company_, invoice_id_, item_id_, price_qty_, 1);
         IF (CUSTOMER_ORDER_INV_HEAD_API.Get_Use_Price_Incl_Tax_Db(company_, invoice_id_) = 'TRUE') THEN
            order_curr_discount_ := (invline_rec_.order_discount * 0.01) * (invline_rec_.unit_price_incl_tax * price_qty_ - curr_discount_);
            add_curr_discount_   := (((invline_rec_.unit_price_incl_tax * price_qty_) - curr_discount_) * (Get_Additional_Discount(company_, invoice_id_, item_id_) * 0.01));
         ELSE
            order_curr_discount_ := (invline_rec_.order_discount * 0.01) * (invline_rec_.sale_unit_price * price_qty_ - curr_discount_);
            add_curr_discount_   := (((invline_rec_.sale_unit_price * price_qty_) - curr_discount_) * (invline_rec_.additional_discount * 0.01));
         END IF;
         
      END IF;
         
      Client_SYS.Add_To_Attr('INVOICED_QTY', invoiced_qty_, stat_attr_);
      Client_SYS.Add_To_Attr('PRICE_QTY', price_qty_, stat_attr_);
      Client_SYS.Add_To_Attr('COST', cost_, stat_attr_);    
      Client_SYS.Add_To_Attr('CURR_DISCOUNT', curr_discount_, stat_attr_);         
      Client_SYS.Add_To_Attr('ORDER_CURR_DISCOUNT', order_curr_discount_, stat_attr_);
      Client_SYS.Add_To_Attr('ADDITIONAL_CURR_DISCOUNT', add_curr_discount_, stat_attr_);  
   END IF;  
   
   IF (NOT price_adjust_updated_) THEN
      Client_SYS.Add_To_Attr('SALE_UNIT_PRICE', invline_rec_.sale_unit_price, stat_attr_);
      --Client_SYS.Add_To_Attr('UNIT_PRICE_INCL_TAX', invline_rec_.unit_price_incl_tax, stat_attr_);                                                    -- SHKOLK statistics?
      Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE', invline_rec_.sale_unit_price * (headrec_.curr_rate / headrec_.div_factor), stat_attr_);
      --Client_SYS.Add_To_Attr('BASE_UNIT_PRICE_INCL_TAX', invline_rec_.unit_price_incl_tax * (headrec_.curr_rate / headrec_.div_factor), stat_attr_);  -- SHKOLK statistics?
      Client_SYS.Add_To_Attr('DISCOUNT', invline_rec_.discount, stat_attr_);   
      Client_SYS.Add_To_Attr('ORDER_DISCOUNT', invline_rec_.order_discount, stat_attr_);   
      Client_SYS.Add_To_Attr('ADDITIONAL_DISCOUNT', invline_rec_.additional_discount, stat_attr_);   
      Client_SYS.Add_To_Attr('NET_AMOUNT', invline_rec_.net_dom_amount, stat_attr_);
      Client_SYS.Add_To_Attr('NET_CURR_AMOUNT', invline_rec_.net_curr_amount, stat_attr_);
      Client_SYS.Add_To_Attr('GROSS_AMOUNT', invline_rec_.net_dom_amount + invline_rec_.vat_dom_amount, stat_attr_);
      Client_SYS.Add_To_Attr('GROSS_CURR_AMOUNT', invline_rec_.gross_curr_amount, stat_attr_);   
   END IF;   
   
   IF (stat_attr_ IS NOT NULL) THEN  
      Cust_Ord_Invo_Stat_API.Modify_Invoice_Statistics(stat_attr_, company_, invoice_id_, item_id_); 
   END IF;
END Modify_Invoice_Statistics;


-- Get_Total_Cost
--   Returns the total cost for a given invoice item line.
FUNCTION Get_Total_Cost (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   invrec_              CUSTOMER_ORDER_INV_ITEM%ROWTYPE;
   cost_                NUMBER := 0;
   CURSOR get_inv_lines IS
      SELECT *
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id   = item_id_;

BEGIN
   OPEN get_inv_lines;
   FETCH get_inv_lines INTO invrec_;
   CLOSE get_inv_lines;
   cost_ := Get_Total_Cost(
                  company_,
                  invoice_id_,
                  item_id_,
                  invrec_.order_no,
                  invrec_.line_no,
                  invrec_.release_no,
                  invrec_.line_item_no,
                  invrec_.charge_seq_no,
                  invrec_.rma_no,
                  invrec_.rma_line_no,
                  invrec_.rma_charge_no,
                  invrec_.catalog_no,
                  invrec_.invoiced_qty,
                  invrec_.prel_update_allowed,
                  invrec_.net_dom_amount,
                  invrec_.invoice_type,
                  invrec_.pos,
                  Customer_Order_Inv_Head_API.Get_Rma_No(company_, invoice_id_));
   RETURN cost_;
END Get_Total_Cost;


-- Get_Total_Cost
--   Returns the total cost for a given invoice item line.
FUNCTION Get_Total_Cost (
   company_             IN     VARCHAR2,
   invoice_id_          IN     NUMBER,
   item_id_             IN     NUMBER,
   order_no_            IN     VARCHAR2,
   line_no_             IN     VARCHAR2,
   rel_no_              IN     VARCHAR2,
   line_item_no_        IN     NUMBER,
   charge_seq_no_       IN     NUMBER,
   rma_no_              IN     NUMBER,
   rma_line_no_         IN     NUMBER,
   rma_charge_no_       IN     NUMBER,
   catalog_no_          IN     VARCHAR2,
   invoiced_qty_        IN     NUMBER,
   prel_update_allowed_ IN     VARCHAR2,
   net_dom_amount_      IN     NUMBER,
   invoice_type_        IN     VARCHAR2,
   pos_                 IN     NUMBER,
   header_rma_no_       IN     NUMBER   ) RETURN NUMBER
IS
   rmalinerec_          Return_Material_Line_API.Public_Rec;
   salerec_             Sales_Part_API.Public_Rec;
   linerec_             Customer_Order_Line_API.Public_Rec;
   cost_                NUMBER := 0;
   part_cost_           NUMBER := 0;
   set_zero_cost_and_qty_     BOOLEAN;
   correction_invoice_ VARCHAR2(5);

BEGIN
   IF (order_no_ IS NULL) THEN
      IF (rma_no_ IS NOT NULL) THEN
         IF (rma_charge_no_ IS NOT NULL) THEN
               cost_ := Return_Material_Charge_API.Get_Total_Base_Charged_Cost(rma_no_, rma_charge_no_);
         ELSE
            rmalinerec_ := Return_Material_Line_API.Get(rma_no_, rma_line_no_);
            salerec_    := Sales_Part_API.Get(rmalinerec_.contract, catalog_no_);
            IF ((rmalinerec_.qty_returned_inv > 0) OR (rmalinerec_.qty_scrapped > 0) OR (salerec_.catalog_type = 'NON' AND rmalinerec_.qty_received > 0)) THEN
                  cost_ := Inventory_Transaction_Hist_API.Get_Total_Source_Ref_Amount(rma_no_, NULL, NULL, rma_line_no_, 'RMA');
            ELSE
               IF salerec_.catalog_type = 'NON' THEN
                  cost_ := salerec_.cost * (invoiced_qty_ * rmalinerec_.conv_factor / rmalinerec_.inverted_conv_factor);
               ELSE
                  part_cost_ := Inventory_Part_Cost_API.Get_Cost(rmalinerec_.contract, salerec_.part_no, rmalinerec_.configuration_id, rmalinerec_.condition_code);
                  cost_ := part_cost_ * (invoiced_qty_ * rmalinerec_.conv_factor  / rmalinerec_.inverted_conv_factor);
               END IF;
            END IF;
         END IF;
         IF (net_dom_amount_ <= 0) THEN
            cost_        := -1 * cost_;
         END IF;
      END IF;
   ELSE
      IF (charge_seq_no_ IS NOT NULL) THEN
         IF (invoice_type_ IN (Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_), Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_))) AND prel_update_allowed_ != 'FALSE' THEN
            cost_ := 0;
         ELSE            
            Customer_Order_Charge_API.Get_Base_Charged_Cost(cost_, order_no_, charge_seq_no_, invoice_id_, item_id_, company_, FALSE);
         END IF;
      ELSIF (invoice_type_ IN (Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_), Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_))) THEN
         -- Note : When a correction invoice is created from a RMA and if there are invoice lines that were not included
         --        in the RMA, these correction invoice line should be treated as price adjusted.
         set_zero_cost_and_qty_ := Check_Zero_Cost_And_Qty(company_, invoice_id_, item_id_, pos_, header_rma_no_, rma_no_);
         IF (set_zero_cost_and_qty_) THEN
            cost_ := 0;
         ELSE
            linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
            cost_ := linerec_.cost * (invoiced_qty_ * linerec_.conv_factor / linerec_.inverted_conv_factor);
         END IF;
      ELSIF (rma_no_ IS NOT NULL) THEN
         rmalinerec_ := Return_Material_Line_API.Get(rma_no_, rma_line_no_);
         salerec_    := Sales_Part_API.Get(rmalinerec_.contract, catalog_no_);
         IF ((rmalinerec_.qty_returned_inv > 0) OR (rmalinerec_.qty_scrapped > 0) OR (salerec_.catalog_type = 'NON' AND rmalinerec_.qty_received > 0)) THEN
            cost_ := Inventory_Transaction_Hist_API.Get_Total_Source_Ref_Amount(rma_no_, NULL, NULL, rma_line_no_, 'RMA');
         ELSE
            linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
            cost_ := linerec_.cost * (invoiced_qty_ * rmalinerec_.conv_factor / rmalinerec_.inverted_conv_factor);
         END IF;
      ELSE
         linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
         IF (invoice_type_ IN ('CUSTORDCRE','CUSTCOLCRE')) THEN
            cost_ := linerec_.cost * (invoiced_qty_ * linerec_.conv_factor / linerec_.inverted_conv_factor);
         ELSE
            IF (line_item_no_ <= 0) THEN
               cost_ := Cust_Delivery_Inv_Ref_API.Get_Total_Cost_Invoice_Item(company_, invoice_id_, item_id_,
                                                               (invoiced_qty_ * linerec_.conv_factor / linerec_.inverted_conv_factor));
            ELSE
               -- For package component deliveries, directly refer the customer_order_delivery_tab.
               cost_ := Customer_Order_Delivery_API.Get_Pkg_Comp_Total_Inv_Cost(order_no_, line_no_, rel_no_, line_item_no_, (invoiced_qty_ * linerec_.conv_factor / linerec_.inverted_conv_factor));
            END IF;      
         END IF;
      END IF;

      IF ((net_dom_amount_ <= 0) AND (invoice_type_ IN ('CUSTORDCRE', 'CUSTCOLCRE', 'SELFBILLCRE'))) THEN
         correction_invoice_ := Invoice_API.Is_Correction_Invoice(company_, invoice_id_);
         IF (correction_invoice_ = 'FALSE') THEN
            cost_ := -1 * cost_;
         END IF;
      END IF;
   END IF;
   RETURN cost_;
END Get_Total_Cost;


-- Get_Additional_Discount
--   Returns the Additional Discount of the invoice line.
@UncheckedAccess
FUNCTION Get_Additional_Discount (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   additional_disc_     CUSTOMER_ORDER_INV_ITEM.additional_discount%TYPE;
   
   CURSOR get_add_disc IS
      SELECT additional_discount
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id   = item_id_;

BEGIN
   OPEN get_add_disc;
   FETCH get_add_disc INTO additional_disc_;
   CLOSE get_add_disc;
   
   RETURN additional_disc_;
END Get_Additional_Discount;




-- Check_Remove
--   Checks if CustDeliveryInvRef, CustPrepaymConsumption and OutstandingSales records exist for CO Invoice Item. 
--   If found, print an error message. Used for restricted delete check when removing a Invoice Item (INVOIC module).
PROCEDURE Check_Remove (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER )
IS
BEGIN
   Cust_Delivery_Inv_Ref_API.Check_Remove(company_, invoice_id_, item_id_);
   Cust_Prepaym_Consumption_API.Check_Remove(company_, invoice_id_, item_id_);
   Outstanding_Sales_API.Check_Remove(company_, invoice_id_, item_id_);
END Check_Remove;


-- Remove
--   Delete CustInvoiceItemDiscount records for CO Invoice Item.
--   Used for cascade delete when removing a Invoice Items (INVOIC module).
PROCEDURE Remove (
   company_               IN VARCHAR2,
   invoice_id_            IN NUMBER,
   item_id_               IN NUMBER,
   rental_transaction_id_ IN NUMBER DEFAULT NULL)
IS
 BEGIN
   Cust_Invoice_Item_Discount_API.Remove(company_, invoice_id_, item_id_);
   IF (rental_transaction_id_ IS NOT NULL AND Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, invoice_id_) IN ('CUSTORDCRE', 'CUSTCOLCRE', 'CUSTORDCOR', 'CUSTCOLCOR')) THEN 
       $IF Component_Rental_SYS.INSTALLED $THEN
          Rental_Transaction_API.Handle_Credit_Trans_Remove(rental_transaction_id_); 
       $ELSE
          NULL;
       $END   
   END IF;
END Remove;

-- Get_Rental_Transaction_Id
--   Return the rental transaction id for the given inv line.
@UncheckedAccess
FUNCTION Get_Rental_Transaction_Id (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_ITEM.rental_transaction_id%TYPE;

   CURSOR get_attr IS
      SELECT rental_transaction_id
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN   
   $IF (Component_Rental_SYS.INSTALLED) $THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   $END
   RETURN temp_;
END Get_Rental_Transaction_Id;


PROCEDURE Refresh_Project_Connection (
   activity_info_tab_         IN OUT NOCOPY Public_Declarations_API.PROJ_Project_Conn_Cost_Tab,
   activity_revenue_info_tab_ IN OUT NOCOPY Public_Declarations_API.PROJ_Project_Conn_Revenue_Tab,
   attributes_                IN OUT NOCOPY Public_Declarations_API.PROJ_Project_Conn_Attr_Type,
   activity_seq_              IN     NUMBER,
   keyref1_                   IN     VARCHAR2,
   keyref2_                   IN     VARCHAR2,
   keyref3_                   IN     VARCHAR2,
   keyref4_                   IN     VARCHAR2,
   keyref5_                   IN     VARCHAR2,
   keyref6_                   IN     VARCHAR2,
   refresh_old_data_          IN     VARCHAR2 DEFAULT 'FALSE' )
IS
   company_                          VARCHAR2(20) := keyref1_;
   invoice_id_                       NUMBER       := TO_NUMBER(keyref2_);
   item_id_                          NUMBER       := TO_NUMBER(keyref3_);
   prel_revenue_elements_tab_        Order_Proj_Revenue_Manager_API.Project_Revenue_Element_Tab;
   co_inv_head_rec_                  Customer_Order_Inv_Head_API.Public_Rec;
   transaction_currency_code_        VARCHAR2(3);
   transaction_currency_rate_        NUMBER;   
   count_                            PLS_INTEGER := 0;
   countr_                           PLS_INTEGER := 0;

   CURSOR get_project_revenue_elements IS
      SELECT project_revenue_element   project_revenue_element,
             SUM(amount)               preliminary_amount
      FROM TABLE(prel_revenue_elements_tab_)
      GROUP BY project_revenue_element;

BEGIN
   co_inv_head_rec_              := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);
   transaction_currency_code_    := co_inv_head_rec_.currency_code;
   transaction_currency_rate_    := 1 / (co_inv_head_rec_.curr_rate / co_inv_head_rec_.div_factor);
   -- Check Invoice state to find if Vouchers are created.
   -- If, Vouchers created. Preliminary Revenue should be cleared. Then, empty activity_revenue_info_tab_ will be passed.
   IF (co_inv_head_rec_.objstate IN ('Preliminary', 'Printed')) THEN
      -- Vouchers not created yet. Simulate revenue postings and get revenue elements into the temporary table.
      
      prel_revenue_elements_tab_ := Order_Proj_Revenue_Manager_API.Get_Prel_Revenue_Elements (invoice_id_, company_, item_id_);
   END IF;
   count_                                                                 := activity_info_tab_.COUNT;
   countr_                                                                := activity_revenue_info_tab_.COUNT;
   FOR proj_revenue_element_rec_ IN get_project_revenue_elements LOOP
      IF (Project_Cost_Element_API.Get_Element_Type_Db (company_, proj_revenue_element_rec_.project_revenue_element) = 'REVENUE') THEN
         IF (nvl(proj_revenue_element_rec_.preliminary_amount, 0) != 0) THEN
            activity_revenue_info_tab_(countr_).control_category          := proj_revenue_element_rec_.project_revenue_element;
            activity_revenue_info_tab_(countr_).preliminary_revenue       := proj_revenue_element_rec_.preliminary_amount;
            activity_revenue_info_tab_(countr_).preliminary_transaction   := proj_revenue_element_rec_.preliminary_amount * transaction_currency_rate_;
            activity_revenue_info_tab_(countr_).transaction_currency_code := transaction_currency_code_;                              
            countr_                                                       := countr_ + 1;
         END IF;
      ELSE
         IF (nvl(proj_revenue_element_rec_.preliminary_amount, 0) != 0) THEN
            activity_info_tab_(count_).control_category                   := proj_revenue_element_rec_.project_revenue_element;
            activity_info_tab_(count_).committed                          := -1 * proj_revenue_element_rec_.preliminary_amount;
            activity_info_tab_(count_).committed_transaction              := -1 * proj_revenue_element_rec_.preliminary_amount * transaction_currency_rate_;
            activity_info_tab_(count_).transaction_currency_code          := transaction_currency_code_;
            count_                                                        := count_ + 1;
         END IF;
      END IF;
   END LOOP;
   
   IF (refresh_old_data_ = 'FALSE') THEN
      $IF Component_Proj_SYS.INSTALLED $THEN
         IF (Project_Connection_Util_API.Exist_Project_Connection (activity_seq_ => activity_seq_,
                                                                   keyref1_      => company_,
                                                                   keyref2_      => invoice_id_,
                                                                   keyref3_      => item_id_,
                                                                   keyref4_      => NULL,
                                                                   keyref5_      => NULL,
                                                                   keyref6_      => NULL,
                                                                   proj_lu_name_ => 'COINVLINE') = 'TRUE') THEN

            Project_Connection_Util_API.Refresh_Connection (proj_lu_name_              => 'COINVLINE',
                                                            activity_seq_              => activity_seq_,
                                                            keyref1_                   => company_,
                                                            keyref2_                   => invoice_id_,
                                                            keyref3_                   => item_id_,
                                                            keyref4_                   => '*',
                                                            keyref5_                   => '*',
                                                            keyref6_                   => '*',
                                                            object_description_        => lu_name_,
                                                            activity_info_tab_         => activity_info_tab_,
                                                            activity_revenue_info_tab_ => activity_revenue_info_tab_);
         ELSE
            Project_Connection_Util_API.Create_Connection (proj_lu_name_              => 'COINVLINE',
                                                           activity_seq_              => activity_seq_,
                                                           system_ctrl_conn_          => 'TRUE',
                                                           keyref1_                   => company_,
                                                           keyref2_                   => invoice_id_,
                                                           keyref3_                   => item_id_,
                                                           keyref4_                   => NULL,
                                                           keyref5_                   => NULL,
                                                           keyref6_                   => NULL,
                                                           object_description_        => lu_name_,
                                                           activity_info_tab_         => activity_info_tab_,
                                                           activity_revenue_info_tab_ => activity_revenue_info_tab_);
         END IF; 
      $ELSE
         NULL;
      $END
   END IF;  

END Refresh_Project_Connection;

-- Check_Zero_Cost_And_Qty
--   This method will return TRUE if the invoice line does not have an RMA reference.
@UncheckedAccess
FUNCTION Check_Zero_Cost_And_Qty (
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER,
   item_id_       IN NUMBER,
   pos_           IN NUMBER,
   header_rma_no_ IN NUMBER,
   line_rma_no_   IN NUMBER ) RETURN BOOLEAN
IS
   -- Note : This cursor is written to check whether a line in a correction invoice corresponds to
   --        a debit line that has a RMA reference.
   CURSOR check_inv_line_has_rma_no IS
      SELECT 1
      FROM  customer_order_inv_item i
      WHERE i.company    = company_
        AND i.invoice_id = invoice_id_
        AND i.item_id   != item_id_
        AND i.pos        = pos_
        AND i.rma_no IS NOT NULL;

   found_                     NUMBER;
   set_zero_cost_and_qty_     BOOLEAN;
BEGIN
   IF ((header_rma_no_ IS NOT NULL) AND (line_rma_no_ IS NULL)) THEN
      OPEN check_inv_line_has_rma_no;
      FETCH check_inv_line_has_rma_no INTO found_;
      IF (check_inv_line_has_rma_no%NOTFOUND) THEN
         set_zero_cost_and_qty_ := TRUE;
      ELSE
         set_zero_cost_and_qty_ := FALSE;
      END IF;
      CLOSE check_inv_line_has_rma_no;
   ELSE
      set_zero_cost_and_qty_ := FALSE;
   END IF;
   
   RETURN set_zero_cost_and_qty_;
END Check_Zero_Cost_And_Qty;

-- Used in Project_Connection_API.Get_Object_Status()
@UncheckedAccess
FUNCTION Get_State (
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   item_id_      IN NUMBER ) RETURN VARCHAR2
IS   
   co_inv_head_rec_             Customer_Order_Inv_Head_API.Public_Rec;
   objstate_                    CUSTOMER_ORDER_INV_ITEM.objstate%TYPE;   
BEGIN
   co_inv_head_rec_    := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);
   IF (co_inv_head_rec_.objstate IN ('Preliminary', 'Printed')) THEN
      -- Invoice line status is Unposted
      objstate_ := Language_SYS.Translate_Constant(lu_name_, 'UNPOSTED: Unposted');
   ELSE
      -- Invoice line status is Posted
      objstate_ := Language_SYS.Translate_Constant(lu_name_, 'POSTED: Posted');
   END IF;
   RETURN objstate_;
END Get_State;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
-- Ans also it used in Invoice_Item_API.Modify_Line_Level_Tax_Info as well
@UncheckedAccess
FUNCTION Fetch_Tax_Line_Param(
   company_                IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2) RETURN Tax_Handling_Order_Util_API.tax_line_param_rec
IS
   invoice_rec_            Customer_Order_Inv_Head_API.Public_Rec;
   invoice_line_rec_       Customer_Order_Inv_Item_API.Public_Rec;
   tax_line_param_rec_     Tax_Handling_Order_Util_API.tax_line_param_rec;
   compfin_rec_            Company_Finance_API.Public_Rec;
   inv_rec_                Invoice_API.Public_Rec;
   tax_liability_          VARCHAR2(20);
   tax_liability_type_db_  VARCHAR2(20);
   reb_cre_inv_type_       VARCHAR2(20);
   taxable_db_             VARCHAR2(20);
   para_curr_rounding_     NUMBER;
   parallel_curr_rate_     NUMBER;
   para_conv_factor_       NUMBER;
BEGIN
   inv_rec_              := Invoice_API.Get(company_, source_ref1_);
   invoice_rec_          := Customer_Order_Inv_Head_API.Get(company_, source_ref1_);
   invoice_line_rec_     := Customer_Order_Inv_Item_API.Get(company_, source_ref1_, source_ref2_);
   reb_cre_inv_type_     := Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(company_);
   tax_line_param_rec_.company             := company_;
   tax_line_param_rec_.contract            := invoice_rec_.contract;
   tax_line_param_rec_.customer_no         := invoice_rec_.customer_no;
   tax_line_param_rec_.ship_addr_no        := invoice_rec_.delivery_address_id;
   IF (invoice_rec_.invoice_type = reb_cre_inv_type_) THEN
      tax_line_param_rec_.planned_ship_date   := invoice_rec_.invoice_date;
   ELSE
      tax_line_param_rec_.planned_ship_date   := NVL(Customer_Order_Line_API.Get_Planned_Ship_Date(invoice_line_rec_.order_no, invoice_line_rec_.line_no, 
                                                                    invoice_line_rec_.release_no, invoice_line_rec_.line_item_no),
                                                                    TRUNC(Site_API.Get_Site_Date(invoice_rec_.contract)));
   END IF;
   tax_line_param_rec_.supply_country_db     := invoice_rec_.supply_country;
   tax_line_param_rec_.delivery_type         := NVL(invoice_line_rec_.deliv_type_id, '*');
   tax_line_param_rec_.object_id             := invoice_line_rec_.catalog_no;
   tax_line_param_rec_.use_price_incl_tax    := invoice_rec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code         := invoice_rec_.currency_code;
   tax_line_param_rec_.currency_rate         := invoice_rec_.curr_rate;   
   tax_line_param_rec_.conv_factor           := inv_rec_.div_factor;
   tax_line_param_rec_.tax_code              := invoice_line_rec_.vat_code;
   tax_line_param_rec_.tax_calc_structure_id := invoice_line_rec_.tax_calc_structure_id;
   Fetch_Tax_Liability_Info___(tax_liability_, tax_liability_type_db_, taxable_db_, company_, source_ref1_, source_ref2_);
   tax_line_param_rec_.taxable               := taxable_db_;
                               
   tax_line_param_rec_.tax_liability         := tax_liability_;
   tax_line_param_rec_.tax_liability_type_db := tax_liability_type_db_;
   tax_line_param_rec_.free_of_charge           := invoice_line_rec_.free_of_charge;
   tax_line_param_rec_.free_of_charge_tax_basis := invoice_line_rec_.free_of_charge_tax_basis;
   
   -- From RMA
   IF invoice_line_rec_.rma_no IS NOT NULL THEN
      tax_line_param_rec_.delivery_country_db := Return_Material_API.Get_Ship_Addr_Country_Code(invoice_line_rec_.rma_no);
   -- From Customer Order Line
   ELSIF (invoice_line_rec_.order_no IS NOT NULL AND invoice_line_rec_.line_no IS NOT NULL AND 
          invoice_line_rec_.release_no IS NOT NULL AND invoice_line_rec_.charge_seq_no IS NULL) THEN  
      tax_line_param_rec_.delivery_country_db := Customer_Order_Line_API.Get_Country_Code(invoice_line_rec_.order_no, invoice_line_rec_.line_no, 
                                                                                          invoice_line_rec_.release_no, invoice_line_rec_.line_item_no);
   -- From Customer Order Charge
   ELSIF (invoice_line_rec_.order_no IS NOT NULL AND invoice_line_rec_.line_no IS NULL AND 
          invoice_line_rec_.release_no IS NULL AND invoice_line_rec_.charge_seq_no IS NOT NULL) THEN   
       tax_line_param_rec_.delivery_country_db := Customer_Order_Charge_API.Get_Connected_Deliv_Country(invoice_line_rec_.order_no, invoice_line_rec_.charge_seq_no);
   -- From Shipment
   ELSIF (invoice_line_rec_.order_no IS NULL AND invoice_rec_.shipment_id IS NOT NULL AND invoice_line_rec_.charge_seq_no IS NOT NULL) THEN
       tax_line_param_rec_.delivery_country_db := Shipment_API.Get_Receiver_Country(invoice_rec_.shipment_id);
   END IF;
      
   --fetch parallel currency specific values
   compfin_rec_ := Company_Finance_API.Get(company_);
   IF compfin_rec_.parallel_acc_currency IS NOT NULL THEN 
      para_curr_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, compfin_rec_.parallel_acc_currency);
      parallel_curr_rate_ := inv_rec_.parallel_curr_rate;
      para_conv_factor_   := inv_rec_.parallel_div_factor;
      tax_line_param_rec_.calculate_para_amount := 'TRUE';
      tax_line_param_rec_.para_curr_rate        := parallel_curr_rate_;
      tax_line_param_rec_.para_conv_factor      := para_conv_factor_;
      tax_line_param_rec_.para_curr_rounding    := para_curr_rounding_;
   ELSE
      tax_line_param_rec_.calculate_para_amount := 'FALSE';
   END IF;
   
   IF (Fnd_Session_API.Is_Odp_Session) THEN
       tax_line_param_rec_.tax_curr_rate  := invoice_rec_.tax_curr_rate;
       tax_line_param_rec_.advance_invoice := invoice_rec_.advance_invoice;
   END IF;
   RETURN tax_line_param_rec_;
      
END Fetch_Tax_Line_Param;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Fetch_Gross_Net_Tax_Amounts(
   gross_curr_amount_      OUT NUMBER,
   net_curr_amount_        OUT NUMBER,
   tax_curr_amount_        OUT NUMBER,
   company_                IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2) 
IS 
   CURSOR get_co_inv_item IS
   SELECT gross_curr_amount, net_curr_amount, vat_curr_amount
     FROM CUST_ORDER_INV_ITEM_UIV_ALL 
    WHERE company = company_
      AND invoice_id = source_ref1_
      AND item_id = source_ref2_;
BEGIN
   
   OPEN get_co_inv_item;
   FETCH get_co_inv_item INTO gross_curr_amount_, net_curr_amount_, tax_curr_amount_;
   CLOSE get_co_inv_item;  
END Fetch_Gross_Net_Tax_Amounts;

@UncheckedAccess
PROCEDURE Get_Tax_Info (
   attr_          OUT VARCHAR2,
   company_       IN  VARCHAR2,
   invoice_id_    IN  NUMBER,
   item_id_       IN  NUMBER)
IS
   tax_liability_type_db_  VARCHAR2(20);
   order_no_               VARCHAR2(12);
   line_no_                VARCHAR2(4);
   release_no_             VARCHAR2(4);
   line_item_no_           NUMBER;
   taxable_db_             VARCHAR2(20);
   tax_code_               VARCHAR2(20);
   tax_liability_          VARCHAR2(20);
   reb_cre_inv_type_       VARCHAR2(20);
   deliv_type_id_          VARCHAR2(20);
   delivery_country_db_    VARCHAR2(2);
   rma_no_                 NUMBER;
   charge_seq_no_          NUMBER;
   planned_ship_date_      DATE;
   headrec_      Customer_Order_Inv_Head_API.Public_Rec;
      
   CURSOR get_ord_info IS
      SELECT rma_no, order_no, line_no, release_no, line_item_no, charge_seq_no, vat_code, deliv_type_id
      FROM   customer_order_inv_item 
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
BEGIN

   headrec_ := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);
   reb_cre_inv_type_ := Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(company_);   
   OPEN get_ord_info;
   FETCH get_ord_info INTO rma_no_, order_no_, line_no_, release_no_, line_item_no_, charge_seq_no_, tax_code_, deliv_type_id_;
   CLOSE get_ord_info;
   
   Fetch_Tax_Liability_Info___(tax_liability_, tax_liability_type_db_, taxable_db_, company_, invoice_id_, item_id_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY', tax_liability_, attr_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', tax_liability_type_db_, attr_);   
   Client_SYS.Set_Item_Value('IS_TAXABLE_DB', taxable_db_, attr_);   
   Client_SYS.Set_Item_Value('TAX_CODE', tax_code_, attr_);
   Client_SYS.Set_Item_Value('SHIP_ADDR_NO', headrec_.delivery_address_id, attr_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY_DATE', headrec_.invoice_date , attr_);
   IF (headrec_.invoice_type = reb_cre_inv_type_) THEN
      planned_ship_date_   := headrec_.invoice_date;
   ELSE
      planned_ship_date_   := NVL(Customer_Order_Line_API.Get_Planned_Ship_Date(order_no_, line_no_, release_no_, line_item_no_),
                                                                    TRUNC(Site_API.Get_Site_Date(headrec_.contract)));
   END IF;
   Client_SYS.Set_Item_Value('PLANNED_SHIP_DATE', planned_ship_date_, attr_);                            
   Client_SYS.Set_Item_Value('SUPPLY_COUNTRY_DB', headrec_.supply_country , attr_);
   Client_SYS.Set_Item_Value('DELIVERY_TYPE', NVL(deliv_type_id_, '*'), attr_);
   
   -- From RMA
   IF rma_no_ IS NOT NULL THEN
      delivery_country_db_ := Return_Material_API.Get_Ship_Addr_Country_Code(rma_no_);
   -- From Customer Order Line
   ELSIF (order_no_ IS NOT NULL AND line_no_ IS NOT NULL AND release_no_ IS NOT NULL AND charge_seq_no_ IS NULL) THEN  
      delivery_country_db_ := Customer_Order_Line_API.Get_Country_Code(order_no_, line_no_, release_no_, line_item_no_);
   -- From Customer Order Charge
   ELSIF (order_no_ IS NOT NULL AND line_no_ IS NULL AND release_no_ IS NULL AND charge_seq_no_ IS NOT NULL) THEN   
       delivery_country_db_ := Customer_Order_Charge_API.Get_Connected_Deliv_Country(order_no_, charge_seq_no_);
   -- From Shipment
   ELSIF (order_no_ IS NULL AND headrec_.shipment_id IS NOT NULL AND charge_seq_no_ IS NOT NULL) THEN
       delivery_country_db_ := Shipment_API.Get_Receiver_Country(headrec_.shipment_id);
   END IF;
   Client_SYS.Set_Item_Value('DELIVERY_COUNTRY_DB', delivery_country_db_, attr_);
END Get_Tax_Info;


@UncheckedAccess
PROCEDURE Get_Tax_Info (
   tax_liability_type_db_ OUT VARCHAR2,
   taxable_db_            OUT VARCHAR2,
   company_               IN  VARCHAR2,
   invoice_id_            IN  NUMBER,
   item_id_               IN  NUMBER)
IS
   tax_liability_         VARCHAR2(20);
BEGIN   
   Fetch_Tax_Liability_Info___(tax_liability_, tax_liability_type_db_, taxable_db_, company_, invoice_id_, item_id_);
END Get_Tax_Info;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_External_Tax_Info (
   attr_          OUT VARCHAR2,
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2,
   company_       IN  VARCHAR2)
IS
   headrec_                Customer_Order_Inv_Head_API.Public_Rec;
   itemrec_                Customer_Order_Inv_Item_API.Public_Rec;

   tax_liability_          VARCHAR2(20);
   tax_liability_type_db_  VARCHAR2(20);
   taxable_db_             VARCHAR2(20);

BEGIN
   headrec_ := Customer_Order_Inv_Head_API.Get(company_, source_ref1_);
   itemrec_ := Customer_Order_Inv_Item_API.Get(company_, source_ref1_, source_ref2_);
   
   Fetch_Tax_Liability_Info___(tax_liability_, tax_liability_type_db_, taxable_db_, company_, source_ref1_, source_ref2_);
      
   Client_SYS.Set_Item_Value('QUANTITY',              itemrec_.invoiced_qty,        attr_);
   Client_SYS.Set_Item_Value('POS',                   itemrec_.pos,                 attr_);
   Client_SYS.Set_Item_Value('INVOICE_DATE',          headrec_.invoice_date,        attr_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', tax_liability_type_db_,       attr_);
   Client_SYS.Set_Item_Value('PREL_UPDATE_ALLOWED',   itemrec_.prel_update_allowed, attr_);

   -- gelr:br_external_tax_integration, begin
   IF Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_) = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL THEN
      Client_SYS.Set_Item_Value('SHIP_ADDR_NO',            itemrec_.ship_addr_no,       attr_);
      Client_SYS.Set_Item_Value('DOC_ADDR_NO',             headrec_.invoice_address_id, attr_);
      Client_SYS.Set_Item_Value('INVOICE_SERIAL',          headrec_.component_a,        attr_);
      Client_SYS.Set_Item_Value('INVOICE_NUMBER',          headrec_.serial_number,      attr_);
      Client_SYS.Set_Item_Value('DOCUMENT_CODE',           REPLACE(company_,' ')||headrec_.component_a||headrec_.serial_number, attr_);
      Client_SYS.Set_Item_Value('SALE_UNIT_PRICE',         itemrec_.sale_unit_price,    attr_);
      --Client_SYS.Set_Item_Value('LINE_TAXED_DISCOUNT',   Cust_Order_Line_Discount_API.Get_Total_Line_Discount__(source_ref1_, source_ref2_, source_ref3_, source_ref4_, linerec_.buy_qty_due, linerec_.price_conv_factor), attr_); -- TODO
      Client_SYS.Set_Item_Value('EXTERNAL_USE_TYPE',       Acquisition_Reason_API.Get_External_Use_Type_Db(company_, Customer_Order_Line_API.Get_Acquisition_Reason_Id(itemrec_.order_no, itemrec_.line_no, itemrec_.release_no, itemrec_.line_item_no)), attr_);
      Client_SYS.Set_Item_Value('BUSINESS_TRANSACTION_ID', Business_Transaction_Id_API.Get_External_Tax_System_Ref(company_, Customer_Order_API.Get_Business_Transaction_Id(itemrec_.order_no)), attr_);
      Client_SYS.Set_Item_Value('AVALARA_TAX_CODE',        Sales_Part_Ext_Tax_Params_API.Get_Avalara_Tax_Code(itemrec_.contract, itemrec_.catalog_no), attr_);
      Client_SYS.Set_Item_Value('STATISTICAL_CODE',        itemrec_.statistical_code,   attr_);
      Client_SYS.Set_Item_Value('CEST_CODE',               Part_Br_Spec_Attrib_API.Get_Cest_Code(Sales_Part_API.Get_Part_No(itemrec_.contract, itemrec_.catalog_no)), attr_);
      Client_SYS.Set_Item_Value('SALES_UNIT_MEAS',         itemrec_.sale_um,            attr_);
      Client_SYS.Set_Item_Value('ACQUISITION_ORIGIN',      itemrec_.acquisition_origin, attr_);
      Client_SYS.Set_Item_Value('PRODUCT_TYPE_CLASSIF',    Part_Br_Spec_Attrib_API.Get_Product_Type_Classif_Db(Sales_Part_API.Get_Part_No(itemrec_.contract, itemrec_.catalog_no)), attr_);
   END IF;
   -- gelr:br_external_tax_integration, end
END Get_External_Tax_Info;


-- source_ref1_ = company
-- source_ref2_ = invoice_id
-- source_ref3_ = item_id
--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_Tax_Info (
   attr_          OUT VARCHAR2,
   source_ref1_   IN  VARCHAR2,
   source_ref2_   IN  VARCHAR2,
   source_ref3_   IN  VARCHAR2,
   source_ref4_   IN  VARCHAR2)
IS
BEGIN
   Get_Tax_Info(attr_, source_ref1_, TO_NUMBER(source_ref2_), TO_NUMBER(source_ref3_));
END Get_Tax_Info;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Get_Price_Total (
   company_       IN VARCHAR2,
   invoice_id_    IN VARCHAR2,
   item_id_       IN VARCHAR2,
   dummy_         IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Net_Curr_Amount(company_, TO_NUMBER(invoice_id_), TO_NUMBER(item_id_));
END Get_Price_Total;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Get_Price_Incl_Tax_Total (
   company_       IN VARCHAR2,
   invoice_id_    IN VARCHAR2,
   item_id_       IN VARCHAR2,
   dummy_         IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Gross_Curr_Amount(company_, TO_NUMBER(invoice_id_), TO_NUMBER(item_id_));
END Get_Price_Incl_Tax_Total;

-- Get_Line_Address_Info
--   Returns Customer Order Invoice line Address information.
--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_Line_Address_Info (
   address1_      OUT VARCHAR2,
   address2_      OUT VARCHAR2,
   country_code_  OUT VARCHAR2,
   city_          OUT VARCHAR2,
   state_         OUT VARCHAR2,
   zip_code_      OUT VARCHAR2,
   county_        OUT VARCHAR2,
   in_city_       OUT VARCHAR2,
   source_ref1_   IN  VARCHAR2,
   source_ref2_   IN  VARCHAR2,
   source_ref3_   IN  VARCHAR2,
   source_ref4_   IN  VARCHAR2,
   company_       IN  VARCHAR2)
IS
   source_key_rec_ Tax_Handling_Util_API.source_key_rec;
   addr_rec_       Customer_Info_Address_API.Public_Rec;   
   headrec_        Customer_Order_Inv_Head_API.Public_Rec;
   shipment_rec_   Shipment_API.Public_Rec;
   source_pkg_     VARCHAR2(30);
   order_no_       VARCHAR2(12);
   line_no_        VARCHAR2(5);
   rel_no_         VARCHAR2(5);
   stmt_           VARCHAR2(2000);
   line_item_no_   NUMBER;
   chg_seq_no_     NUMBER;
   rma_no_         NUMBER;
   rma_line_no_    NUMBER;
   rma_charge_no_  NUMBER;
      
   CURSOR get_cust_ord_invoice_info IS
      SELECT order_no, line_no, release_no, line_item_no, charge_seq_no, rma_no, rma_line_no, rma_charge_no
      FROM   customer_order_inv_item 
      WHERE  company    = company_
      AND    invoice_id = source_ref1_
      AND    item_id    = source_ref2_;
      
BEGIN
   headrec_ := Customer_Order_Inv_Head_API.Get(company_, source_ref1_);   
   OPEN get_cust_ord_invoice_info;
   FETCH get_cust_ord_invoice_info INTO order_no_, line_no_, rel_no_, line_item_no_, chg_seq_no_, rma_no_, rma_line_no_, rma_charge_no_;
   CLOSE get_cust_ord_invoice_info;
   
   -- RMA Line Invoice
   IF (rma_no_ IS NOT NULL AND rma_line_no_ IS NOT NULL AND rma_charge_no_ IS NULL)THEN      
      source_key_rec_.source_ref1  := TO_CHAR(rma_no_);
      source_key_rec_.source_ref2  := TO_CHAR(rma_line_no_);
      source_key_rec_.source_ref3  := '*';       
      source_key_rec_.source_ref4  := '*';      
      source_key_rec_.source_ref_type := Tax_Source_API.DB_RETURN_MATERIAL_LINE;
   
   -- RMA Charge Invoice
   ELSIF (rma_no_ IS NOT NULL AND rma_charge_no_ IS NOT NULL) THEN      
      source_key_rec_.source_ref1  := TO_CHAR(rma_no_);
      source_key_rec_.source_ref2  := TO_CHAR(rma_charge_no_);          
      source_key_rec_.source_ref3  := '*';       
      source_key_rec_.source_ref4  := '*';      
      source_key_rec_.source_ref_type := Tax_Source_API.DB_RETURN_MATERIAL_CHARGE;
      
   -- Customer Order Line Invoice
   ELSIF (order_no_ IS NOT NULL AND line_no_ IS NOT NULL AND rel_no_ IS NOT NULL AND chg_seq_no_ IS NULL) THEN      
      source_key_rec_.source_ref1  := order_no_;
      source_key_rec_.source_ref2  := line_no_;          
      source_key_rec_.source_ref3  := rel_no_;       
      source_key_rec_.source_ref4  := TO_CHAR(line_item_no_);      
      source_key_rec_.source_ref_type := Tax_Source_API.DB_CUSTOMER_ORDER_LINE;
      
   -- Customer Order Charge Invoice
   ELSIF (order_no_ IS NOT NULL AND chg_seq_no_ IS NOT NULL) THEN
      source_key_rec_.source_ref1  := order_no_;
      source_key_rec_.source_ref2  := TO_CHAR(chg_seq_no_);      
      source_key_rec_.source_ref3  := '*';       
      source_key_rec_.source_ref4  := '*';      
      source_key_rec_.source_ref_type := Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE;
      
   -- Shipment Freight Charge Invoice
   ELSIF (order_no_ IS NULL AND headrec_.shipment_id IS NOT NULL AND chg_seq_no_ IS NOT NULL) THEN
      source_key_rec_.source_ref1  := headrec_.shipment_id;
      source_key_rec_.source_ref2  := TO_CHAR(chg_seq_no_);      
      source_key_rec_.source_ref3  := '*';       
      source_key_rec_.source_ref4  := '*';      
      source_key_rec_.source_ref_type := Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE;
      
   -- Rebate Invoice
   ELSE
      addr_rec_     := Customer_Info_Address_API.Get(headrec_.customer_no, headrec_.delivery_address_id);
      country_code_ := Customer_Info_Address_API.Get_Country_Code(headrec_.customer_no, headrec_.delivery_address_id);      
      address1_     := addr_rec_.address1;
      address2_     := addr_rec_.address2;
      city_         := addr_rec_.city;
      state_        := addr_rec_.state;
      zip_code_     := addr_rec_.zip_code;
      county_       := addr_rec_.county;
      in_city_      := addr_rec_.in_city;
   END IF;
         
   source_pkg_  := Tax_Handling_Order_Util_API.Get_Source_Pkg(source_key_rec_.source_ref_type);
   IF (source_key_rec_.source_ref_type IN (Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                           Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                           Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                           Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                           Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                           Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                           Tax_Source_API.DB_ORDER_QUOTATION_CHARGE)) THEN
      
      --Added code to check if a Customer Order Line or Customer Order Charge is connected to a shipment, then get the receiver address info from the shipment header rather than from the source lines.
      --This is applicable when creating the shipment invoice so that we fetch the right tax values for invoice lines with the correct address info.
      IF (headrec_.shipment_id IS NOT NULL AND source_key_rec_.source_ref_type IN (Tax_Source_API.DB_CUSTOMER_ORDER_LINE, Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE)) THEN
         shipment_rec_ := Shipment_API.Get(headrec_.shipment_id);
         
         address1_     := shipment_rec_.receiver_address1;
         address2_     := shipment_rec_.receiver_address2;
         country_code_ := shipment_rec_.receiver_country;
         city_         := shipment_rec_.receiver_city;
         state_        := shipment_rec_.receiver_state;
         zip_code_     := shipment_rec_.receiver_zip_code;
         county_       := shipment_rec_.receiver_county;
      ELSE
         Assert_Sys.Assert_Is_Package(source_pkg_);
         stmt_  := 'BEGIN
                       '||source_pkg_||'.Get_Line_Address_Info(:address1, :address2, :country_code, :city, :state, :zip_code, :county, :in_city,
                                                               :source_ref1, :source_ref2, :source_ref3, :source_ref4, :company);                 
                    END;';
         @ApproveDynamicStatement(2016-09-29,MalLlk) 
         EXECUTE IMMEDIATE stmt_
                 USING OUT address1_,
                       OUT address2_,
                       OUT country_code_,
                       OUT city_,
                       OUT state_,
                       OUT zip_code_,
                       OUT county_,
                       OUT in_city_,
                       IN  source_key_rec_.source_ref1,
                       IN  source_key_rec_.source_ref2,
                       IN  source_key_rec_.source_ref3,
                       IN  source_key_rec_.source_ref4,
                       IN  company_;
         END IF;
      END IF;
END Get_Line_Address_Info;

-----------------------------------------------------------------------------
-- Check_Corr_Reason_Exists
--   Return TRUE if correction reason exists in the view.
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Check_Corr_Reason_Exists (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER) RETURN VARCHAR2
IS   
   CURSOR CorrReason IS 
      SELECT correction_reason
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id   = item_id_;   
   temp_ VARCHAR2(2000);
BEGIN   
   OPEN  CorrReason;
   FETCH CorrReason INTO temp_;
   CLOSE CorrReason;
   
   IF temp_ IS NULL THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Check_Corr_Reason_Exists;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Validate_Source_Pkg_Info (
   source_ref1_  IN VARCHAR2,
   source_ref2_  IN VARCHAR2,
   source_ref3_  IN VARCHAR2,
   source_ref4_  IN VARCHAR2,
   attr_         IN VARCHAR2)
IS
BEGIN
   NULL;
END Validate_Source_Pkg_Info;


-- Get_Objversion
--   Return the current objversion for line
FUNCTION Get_Objversion (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN VARCHAR2
IS
   temp_  VARCHAR2(20);
   CURSOR get_attr IS
      SELECT objversion
      FROM  CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Objversion;

-- gelr:disc_price_rounded, begin
FUNCTION Get_Discounted_Price_Rounded(
   company_           IN VARCHAR2,
   invoice_id_        IN NUMBER,
   item_id_           IN NUMBER) RETURN BOOLEAN
IS
   CURSOR get_item_rec IS
      SELECT order_no
      FROM   customer_order_inv_item
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_;
      
   order_no_ VARCHAR2(12);
BEGIN
   OPEN get_item_rec;
   FETCH get_item_rec INTO order_no_;
   CLOSE get_item_rec;

   RETURN Customer_Order_API.Get_Discounted_Price_Rounded(order_no_);
END Get_Discounted_Price_Rounded;
-- gelr:disc_price_rounded, end

-- gelr:prepayment_tax_document, begin
@IgnoreUnitTest TrivialFunction 
@UncheckedAccess
FUNCTION Get_Next_Reference_Seq RETURN VARCHAR2
IS
   reference_seq_no_ NUMBER;
   reference_        VARCHAR2(200);   
   CURSOR get_id IS
      SELECT customer_order_inv_item_seq.nextval      
      FROM dual; 
BEGIN
   OPEN get_id;
   FETCH get_id INTO reference_seq_no_;
   CLOSE get_id;   
   reference_ := 'CO-' || TO_CHAR(reference_seq_no_);  
   RETURN reference_;
END Get_Next_Reference_Seq;   
-- gelr:prepayment_tax_document, end
