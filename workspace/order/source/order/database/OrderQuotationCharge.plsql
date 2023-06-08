-----------------------------------------------------------------------------
--
--  Logical unit: OrderQuotationCharge
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  210216  ApWilk   Bug 157735(SCZ-13503), Modified the method Add_Transaction_Tax_Info___() to fetch the correct tax_liability_type_db_.
--  210129  Skanlk  SCZ-13274, Modified the method Add_Transaction_Tax_Info() to update the tax code of charge lines when the sales charge type is taxable and the sales part of the order line connected to the charge line is not taxable.
--  210129           Modified the method Add_Transaction_Tax_Info___() to update the tax code from the order quotation header when the tax_liability_type_db_ is EXM, sales charge type is taxable and tax_from_defaults_ is TRUE.
--  200625  NiDalk   SCXTEND-4438, Modified Insert___ to avoid fetch of taxes during insert when company_tax_control.fetch_tax_on_line_entry for Avalara sales tax is set to false.
--  200625           Also When attr_ has UPDATE_TAX set to false in Insert___ and Update___ that means taxes are fetched from a bundle call.
--  200131  Erlise   SCXTEND-1768, Added evaluation of line connection changes in Update() to force a recalculation of the tax lines.
--  200127  Erlise   SCXTEND-1516, Modified method Add_Transaction_Tax_Info() to avoid unnecessary calls to the external tax system.
--  191022  Hairlk   SCXTEND-939, Modified Prepare_Insert___, added code to fetch CUSTOMER_TAX_USAGE_TYPE from the header and added it to the attr.
--  191003  Hairlk   SCXTEND-939, Avalara integration, Modified Insert___, Added code to fetch customer_tax_usage_type from customer if its not available in the attr. Modified Check_Update___ to prevent changing customer_tax_usage_type if the quotation is in Closed state.
--                   Modified Update___, added customer_tax_usage_type to the check which recalculates tax amounts if the calc method is set to external. Modified Transfer_To_Order and Transfer_To_Order_Line to include customer_tax_usage_type
--  190718  BudKlk   Bug 148970 (SCZ-5620), Modified the methods Check_Insert___() to only get a value for currency_rate and not to 
--  190718           replace newrec_.charge_amount from the new value to avoid rounding issues. 
--  181004  ErRalk   Bug 144394, Modified Copy_Lines__ and Insert___ methods to copy document text to charge line for Copy Quotation function.
--  180209  KoDelk  STRSC-15901, When creating tax lines for invoice use the current currency rate rather than using the source line currency rate.
--  171127  MAHPLK   STRFI-10886, Added new methods  Get_External_Tax_Info() and to Get_Line_Address_Info().
--  170530  NiLalk   STRSC-1719, Modified Copy_Lines_ by introducing curr_code_, customer_no_, rate_, conv_factor_ and curr_type_ variables and called
--  170530           Invoice_Library_API.Get_Currency_Rate_Defaults method to obtain the current currency rate. 
--  170524  SuCplk   STRSC-8670, Modified Copy_From_Sales_Part_Charge() to avoid creating charge line for rental parts. 
--  170305  SURBLK   Modified Do_Additional_Validations___() by changing the error message when charge_type_category_ is PROMOTION.
--  170215  AyAmlk   APPUXX-9350, Removed the restriction on self-billing lines from Check_Insert___ and Check_Update___.
--  170202  IsSalk   STRSC-5655, Modified Insert___() to prevent calculating prices when duplicating/copying percentage charge lines.
--  170125  slkapl  FINHR-5388, Implement Tax Structures in Sales Promotions
--  170110  slkapl  FINHR-5274, Implement Tax Structures in Sales Quotation/Charge
--  160920  NWeelk  FINHR-2990, Added method Get_Promo_Amounts to calculate gross_base and gross_curr amounts.
--  160711  AyAmlk   APPUXX-1830, Modified Delete___() to prevent raising errors when deleting charges created for a Shopping Cart SQ.
--  160531  SURBLK   Removed Get_Effective_Tax_Regime__
--  160510  SURBLK   Added Do_Additional_Validations___().
--  160314  IsSalk   FINHR-686, Moved server logic of QuoteLineTaxLines to Source Tax Item Order.
--  160215  IsSalk   FINHR-722, Renamed attribute FEE_CODE to TAX_CODE in ORDER_QUOTATION_LINE_TAB.
--  160202  ErFelk   Bug 123221, Modified Copy_Lines__() so that it copies line connected and header connected charge lines depending on the value of copy_lines_ parameter. 
--  160118  IsSalk   FINHR-657, Used FndBoolean in taxable attribute in Sales Charge Type.
--  160111  IsSalk   FINHR-581, Renamed column FEE_CODE to TAX_CODE in SALES_CHARGE_TYPE_TAB.
--  151030  MAHPLK   FINHR-140, Added new public method Get_Connected_Tax_Liability().
--  150908  Erlise   AFT-1528, Modified Validate_Fee_Code___(). Added handling of tax class.
--  150904  Erlise   AFT-2187, Modified Validate_Fee_Code___() to consider default info flag.
--  150821  Erlise   COB-416, Modified Get_Connected_Deliv_Country(). Added parameters rel_no and line_item_no, 
--  150821           and added logic to retreive the correct delivery country code.
--  150817  Erlise   COB-416, Modified Validate_Fee_Code___() to consider single occurrence address.
--  150603  NaLrlk   RED-333, Modified Check_Insert___() and Check_Update___() to restrict the rental line connection.
--  150214  MaIklk   PRSC-974, Used tax regime and tax fee code from company for prospect if delviery tax is missing in Validate_Fee_Code().
--  150213  MeAblk   PRSC-5753, Modified Transfer_To_Order in order to avoid setting SEQUENCE_NO.
--  141230  MaIklk   PRSC-974, Fixed to work for prospects.
--  140917  AyAmlk   Bug 115414, Modified Modify_Fee_Code__() by calling Validate_Fee_Code___() so that the tax code in charge lines will be updated correctly.
--  140611  ChJalk   PRSC-313, Added method Copy_Lines__.
--  140610  JanWse   PRSC-991, Include quotation_charge_no as sequence_no in Transfer_To_Order when calling Customer_Order_Charge_API.New
--  140417  MaRalk   Bug 114913 Merged to APP9. 
--  140417           Modified Validate_Fee_Code___()  to fetched the Sales Charge Tax code when the Sales Charge type is not taxable and the Customer tax regime is MIX as well. 
--  140417           Restructured method Validate_Fee_Code___(). Added sales_charge_rec_.taxable = 'TAXABLE' to a condition. 
--  140320  NiDalk   Bug 112499, Added function Get_Total_Tax_Amount_Base to calculate total tax amount per charge line in base currency.
--  131101  MaMalk   Made company mandatory and currency_rate not mandatory in the logc just after unpacking of attributes in insert and update.
--  130708  ChJalk   TIBE-1004, Removed global variable inst_Jinsui_.
--  130322  IsSalk   Bug 108922, Made implementation method Validate_Jinsui_Constraints___() private. Added parameter company_max_jinsui_amt_ to the method
--  130322           Validate_Jinsui_Constraints__(). Modified methods Validate_Jinsui_Constraints__(), Insert___() and Update___() in order to perform
--  130322           validation with the Jinsui Invoice Constraints for all the charge lines in a Quotation.
--  121211  MaIklk   Used customer category instead of customer type.
--  120924  SURBLK   Added Get_Net_Charge_Percent_Basis, Get_Gross_Charge_Percent_Basis; modified Get_Charge_Percent_Basis and Get_Charge_Line_Percent_Basis.
--  120910  HimRlk   Added new method Get_Total_Base_Amnt_Incl_Tax().
--  120813  JeeJlk   Modified Transfer_To_Order to set CHARGE_AMOUNT_INCL_TAX and BASE_CHARGE_AMT_INCL_TAX when creating customer order from quotation.
--  120808  SURBLK   Modified Copy_From_Sales_Part_Charge by adding CHARGE_AMOUNT_INCL_TAX and BASE_CHARGE_AMT_INCL_TAX. 
--  120803  HimRlk   Added new methods Calculate_Prices___ and Get_Total_Charge_Amnt_Incl_Tax(). Modified Modify_Fee_Code__() to calculate charge prices.
--  120730  SURBLK   Handled price fetching logic according to 'use price including tax'.
--  120713  HimRlk   Add new columns charge_amount_incl_tax and base_charge_amt_incl_tax.
--  120314  DaZase   Added Init_Method calls to methods Get_Promo_Gross_Amount_Base and Get_Promo_Gross_Amount_Curr since they cant have pragma.
--  111206  MaMalk   Added pragma to Get_Total_Base_Charged_Amount.
--  110930  MaMalk   Modified Transfer_To_Order to prevent transferring sales promotion charges to CO.
--  110713  JuMalk   Bug 97893, Modified method Transfer_To_Order. Added Customer_Order_Pricing_Api.Get_Base_Price_In_Currency to fetch the correct base price.
--  110712  ChJalk   Added user_allowed_site filter to the view ORDER_QUOTATION_CHARGE.
--  110701  KiSalk   Bug 96918, Set Get_Total_Charged_Amount to return 0 if CO is cancelled.
--  110524  MaMalk   Modified Validate_Fee_Code___ to consider the supply country when no value for the delivery country is found for the tax class.
--  110412  ShKolk   Added charge_price_list_no to Transfer_To_Order_Line().
--  110411  Mohrlk   Modified Validate_Fee_Code___. 
--  110330  MaMalk   Modified Validate_Fee_Code___ to correctly fetch the tax code related to tax class.
--  110321  MaMalk   Modified Validate_Fee_Code___, New and Unpack_Check_Update___ to fetch the taxes when the delivery type is changed.
--  110223  MaMalk   Replaced Customer_Info_Vat_API with new APIs.
--  110208  Mohrlk   DF-719, Derived the correct fee code after introducing multiple tax.
--  110201  Mohrlk   Added Tax_Class_Id as a public attribute and Added new functions Get_Connected_Tax_Liability__() and Modify_Tax_Class_Id__() .
--  101222  NaLrlk   Modified the method Modify__ to raise the error message when update promotion charge line.
--  101216  NaLrlk   Added private columns campaign_id and deal_id. Modified the methods Check_Delete___ and Remove.
--  101116  ChFolk   Modified Transfer_To_Order to prevent tranfering freight charges from quoation to Customer Order.
--  101104  ChFolk   Modified Unpack_Check_Update___ to allow to update correct charged_qty for unit freight charges.
--  100928  ChFolk   Added new function Get_Freight_Charge_Amount which freight type charge amount.
--  100520  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  100215  AmPalk   Bug 87931, Added currency_rate as a public attribute. Update of the column is with the changes to prices (charge amounts),
--  100215           charge quantity or connected order line on client windows. Removed Invoice_Library_API.Get_Currency_Rate_Defaults calls from data populates. Instead used saved value as the currency rate.
--  100310  KiSalk   charge (percentage) included in the condition to raise pack size charge change error in Modify__
--  100308  KiSalk   Corrected Get_Total_Charged_Amount.
--  091111  KiSalk   NVL added to fee_code comparision in modify__.
--  090922  AmPalk   Bug 70316, Modified Get_Total_Base_Charged_Amount to get rounding settings from company currency and do the calculation as in INVOIC side. Add rounding to Get_Total_Tax_Amount.
--  100202  ShKolk   Passed SERVER_DATA_CHANGE to function call Customer_Order_Charge_API.New.
--  091111  KiSalk   NVL added to fee_code comparision in modify__.
--  091007  DaZase   Modified the Unpack_Check_Update___ to allow changing charges of all categories.
--  090930  DaZase   Added length on view comment for charge_price_list_no
--  090820  HimRlk   Addes Server_data_change and modified Unpack_Check_Insert___ and Unpack_Check_Update___.
--  090210  SudJlk   Bug 80244, Added reference to line_item_no column comment in view Order_Quotation_Charge.
--  090131  MaRalk   Bug 79753, Modified methods Copy_From_Customer_Charge and Copy_From_Sales_Part_Charge to retrieve charge_cost correctly.
--  081215  ChJalk   Bug 77014, Modified and added General_SYS.Init_Method to Get_Total_Base_Charged_Amount.
--  081008  SaRilk   Bug 77601, Modified Copy_From_Customer_Charge procedure by deleting the line which adds FEE_CODE to the attr_.
--  081001  SuJalk   Bug 74635, Added delivery type to the LU. Also added method Check_Delivery_Type__. Added delivery type to methods Copy_From_Customer_Charge and
--  081001           Copy_From_Sales_Part_Charge in order to pass the delivery type when creating a new Order Quotation Charge. Added Delivery type to the Transfer_To_Order_Line and Transfer_To_Order method.
--  080626  ThAylk   Bug 74617, Modified method Copy_From_Sales_Part_Charge to avoid adding FEE_CODE to attr.
--  080619  ThAylk   Bug 74617, Added if condition to method Validate_Fee_Code___ to execute the code only if the customer type is 'NORMAL'.
--  090408  KiSalk   Modified the Transfer_To_Order_Line and Transfer_To_Order methods to add the correct charge and charge_cost_percent.
--  090406  KiSalk   Modified methods Copy_From_Customer_Charge and Copy_From_Sales_Part_Charge to retrieve charge_cost and charge_cost_percent correctly. 
--  090331  KiSalk   Added Get_Base_Charge_Percent_Basis and Get_Charge_Percent_Basis.
--  090331           Changed logic to set line_item_no in Unpack_Check_Insert___ and Unpack_Check_Update___ to allow connect package parts with no components.
--  090325  KiSalk   Modified Get_Total_Base_Charged_Amount, Get_Total_Charged_Amount and Get. Added Get_Charge, Get_Charge_Cost_Percent and Get_Total_Base_Charged_Cost.
--  090319  KiSalk   Added attributes charge and charge_cost_percent and made charge_cost, base_charge_amount and charge_amount nullable; added validations.
--  090109  NaLrlk   Added method Copy_Quote_Line_Tax_Lines to copy quotation line tax lines to pack size charge line.
--  090109           Modified the method Modify_Fee_Code__ to remove the fee_code validation.
--  081002  MaJalk   Added UNIT_CHARGE_DB to attr_ at Copy_From_Customer_Charge.
--  080901  MaJalk   Modified conditions to raise error message UPDATENOTALLOWED at Modify__.
--  080825  MaJalk   Changed method calls Get_Sales_Chg_Type_Category to Get_Sales_Chg_Type_Category_Db.
--    080820   MaJalk   Modified Remove() to remove charge tax lines.
--    080818   MaJalk   Modified Unpack_Check_Update___ and Modify__ to handle pack size charge lines.
--    080815   MaJalk   Moved method Get_Pack_Size_Charge_Attr___ to CustomerOrderChargeUtil.apy 
--    080815            and modified New() and Get_Pack_Size_Chg_Line_Quot_No().Added Remove() and Exist_Charge_On_Quot_Line().
--    080812   MaJalk   Set assignment for charged_qty at Unpack_Check_Insert___.
--    080806   MaJalk   Added methods Get_Pack_Size_Charge_Attr___ and Get_Pack_Size_Chg_Line_Quot_No. Modified method New.
--    080806            Added attribute charge_price_list_no.
--  080701  MaJalk   Merged APP75 SP2.
--  --------------------- APP75 SP2 Merge - End --------------------------------
--  080213  ThAylk   Bug 71246, Added functions Get_Total_Tax_Amount and Get_Gross_Amount_For_Col and method Validate_Jinsui_Constraints___.
--  --------------------- APP75 SP2 Merge - Start ------------------------------
--  080610  MiKulk   Modified the Transfer_To_Order_Line and Transfer_To_Order methods to add the correct unit_charge.
--  080603  MiKulk   Added the Unit Charge as a public attribute and modified Unpack_Check_Insert___ 
--  080605           and Unpack_Check_Update___ to add some validations for the charged qty modifications.
--  080605           Added a new method Update_Connected_Charged_Qty
--  ----------------------------NicePrice-----------------------------------------
--  070625  MaMalk   Bug 65856, Modified method Transfer_To_Order_Line to add NOTE_ID to the attribute string.
--  060621  MalLlk   Modified Get to include Intrastat_exempt to the cursor get_attr.
--  060621           Modified Transfer_To_Order and Transfer_To_Order_Line to add intrastate_exempt to attr_.
--  060621           Modified Copy_From_Customer_Charge to include Intrastat_exempt attr_.
--  060621           Modified Copy_From_Sales_Part_Charge to include Intrastat_exempt attr_.
--  060621           Modified Prepare_Insert___
--  060530   KanGlk   Renamed method Add_Customer_Charge to Copy_From_Customer_Charge.
--  060529  SeNslk   Modified Copy_From_Sales_Part_Charge and added Fee Code to the attribute string.
--  060524  RaKalk   Modified Add_Customer_Charge method to use charge_amount_base field of Customer_Charge_Table instead of charge_amount.
--  060523  RaKalk   Modified Delete___ to remove tax lines when the charge lines are being removed
--  060517  NaLrlk   Enlarge Address - Changed variable definitions.
--  060503   KanGlk   Added procedures New and Add_Customer_Charge.
--  060428   RaKalk   Modified method Copy_From_Sales_Part_Charge to use Sales_Part_Charge_API.Get_Default_Charges method.
--  060424   RaKalk   Added procedure Copy_From_Sales_Part_Charge.
--  060419  NaLrlk   Enlarge Customer - Changed variable definitions.
--  ------------------------- 13.4.0 -----------------------------------------
--  060228  MiKulk   Manual merge of 51197, Modified the tax fetching logic.
--  050921  NaLrlk   Removed unused variables.
--  041210  IsAnlk   Added method Modify_Fee_Code__.
--  031018  NuFilk   Added Function Get_Total_Charge_Tax_Pct and removed General_SYS.Init_Method from function Get_Total_Charged_Amount.
--  040611  MiKulk   Bug 43315, Modified the Unpack_Check_Insert___ by removing the method call to retrieve the value for the charge cost.
--  040603  GaJalk   Bug 43315, Modified the Unpack_Check_Update___.
--  040224  IsWilk   Removed the SUBSTRB from the view for Unicode Changes.
--  ------------------------------------13.3.0--------------------------------
--  021018  Prinlk   Modified the previous implementation.
--  021008  Prinlk   Added restictions when adding and modifying charges to a self billing order line.
--  ********************* VSHSB Merge *****************************
--  031013  PrJalk   Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  030912  MiKulk   Bug 38102, Modified the procedure Transfer_To_Order by adding the NOTE_ID to the attr_.
--  030513  ChFolk   Modified an error message in Validate_Fee_Code___.
--  030506  ChFolk   Call ID 96789. Modified the inconsistent error messages.
--  030502  ChFolk   Modified Validate_Fee_Code___ to add an error message when customer tax regime is VAT/MIX but fee_code is null.
--  030423  ChFolk   Modified parameters of PROCEDURE Add_All_Tax_Lines.
--  030417  ChFolk   Modified procedure Modify__ to added new if condition before adding new tax lines.
--  030411  ChFolk   Modified PROCEDUREs Add_Tax_Lines, Remove_Tax_Lines, Unpack_Check_Insert___, Insert___ and Modify__
--                   to remove the old functionality which are not applicable and modified according to new functional requirements.
--                   Added FUNCTION Get_Effective_Tax_Regime__ and PROCEDURE Add_All_Tax_Lines.
--  030404  ChFolk   Added FUNCTION Get_Connected_Address_Id__.
--  030401  ChFolk   Replaced SUBSTR with SUBSTRB.
--  030331  ChFolk   Modified Unpack_Check_Insert___ and Validate_Fee_Code___ to consider company tax regime when sales quotation is for Prospect customer.
--  030328  ChFolk   Added PROCEDURE Remove_Sales_Tax_Lines to remove only sales taxes
--                   Modified Validate_Fee_Code__ by adding a new IN parameter quotation_charge_no.
--                   Modified Validate_Fee_Code__ as Validate_Fee_Code___.
--                   Modified PROCEDURE Add_Tax_Lines and Remove_Tax_Lines.
--  030327  ChFolk   Modified Unpack_Check_Insert___ to handle the functionality when a charge line is connected to a quotation line.
--                   Added PROCEDUREs Get_Default_Charge_Attr___ and Validate_Fee_Code___.
--  030321  ChFolk   Modified PROCEDUREs Unpack_Check_Insert___, Unpack_Check_Update___ and Validate_Fee_Code__ to apply the change of DB values of Tax_Regime_API.
--  030320  ChFolk   Added new PROCEDUREs Validate_Fee_Code__ and Modify. Modified PROCEDURES Unpack_Check_Insert___ and Unpack_Check_Update___
--                   to validate fee code against the customer Tax Regime. Modified PROCEDURE Insert___ to insert tax lines.
--                   Modified the Prompt as Tax Code in view comments of Fee_Code.
--                   Modified PROCEDURE Modify__ to modify the first tax line according to the modification of fee code in charge line.
--                   Modified PROCEDURE Remove__ to remove all connected tax lines.
--  021213  Asawlk   Merged bug fixes in 2002-3 SP3
--  021129  CaRase   Bug 33864, Add charge amount/currency and charge amount/base in history/history line
--                   tab. Update of Sales Quotation revision when qty is updated.
--  021118  CaRase   Bug 33864, Add Charge Type to history when delete is performed.
--  021112  CaRase   Bug 33864, Add Charge Type information to the history.
--  020221  JeLise   Bug fix 27496, Added procedure Transfer_To_Order_Line.
--  011012  Memeus   Bug 25347, add validation on Add_tax_lines for charge_type = Taxable only.
--  010528  JSAnse   Bug fix 21463, Added call to General_SYS.Init_Method for Procedure Get_Total_Charged_Amount.
--  010109  JoAn     Sequence_no retrived from attr after creation of new charge in
--                   Transfer_To_Order.
--  001017  FBen     Changed parameters in call Customer_Order_Charge_API.New in Procedure Transfer_To_Order.
--  001006  FBen     Added CONTRACT add_to_attr in Prepare_Insert___. Call ID 47867.
--  000927  DaZa     Added line_item_no in attribute string back to client on
--                   insert and update.
--  000712  LUDI     Merged from Chameleon
-----------------------------------------------------------------------------
--  000607  LUDI    Update QuotationHistory by insert, delete and modify quantity
--  000516  TFU     Added Remove_Charge_Lines
--  000511  GBO     Added Transfer_To_Order
--  000416  JakH    Added logic from CustomerOrderCharge.
--  000411  LUDI    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Tax_Calc_Struct_Ref___ (
   newrec_ IN OUT NOCOPY ORDER_QUOTATION_CHARGE_TAB%ROWTYPE )
IS
BEGIN
   Tax_Calc_Structure_API.Validate_Tax_Structure_State(newrec_.company, newrec_.tax_calc_structure_id);
END Check_Tax_Calc_Struct_Ref___;

-- Validate_Charge_And_Cost___
--   Validates the use of charge and cost in amount and percentage forms.
PROCEDURE Validate_Charge_And_Cost___ (
   newrec_ IN ORDER_QUOTATION_CHARGE_TAB%ROWTYPE )
IS
BEGIN
   IF (newrec_.charge_cost IS NULL AND newrec_.charge_cost_percent IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NULL_COST_ERR: Either Charge Cost or Charge Cost % must have a value.');
   END IF;
   IF (newrec_.charge IS NULL AND newrec_.charge_amount IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NULL_CHARGE_ERR: Either Charge Price or Charge % must have a value.');
   END IF;
   IF (newrec_.charge_cost IS NOT NULL AND newrec_.charge_cost_percent IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'BOTH_COST_ERR: Both Charge Cost and Charge Cost % cannot have values at the same time.');
   END IF;
   IF (newrec_.charge IS NOT NULL AND newrec_.charge_amount IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'BOTH_CHARGE_ERR: Both Charge Price and Charge % cannot have values at the same time.');
   END IF;
   IF (newrec_.charged_qty != 1 AND newrec_.unit_charge != 'TRUE') THEN
      IF (NVL(newrec_.charge, 0) != 0 OR NVL(newrec_.charge_cost_percent, 0) != 0) THEN
         Error_SYS.Record_General(lu_name_, 'MULTIPERCENTUNIERR: Charged quantity should be 1 for non-unit charges when charge cost or charge price is entered as a percentage.');
      END IF;
   END IF;
END Validate_Charge_And_Cost___;


PROCEDURE Calculate_Prices___ (
   newrec_   IN OUT ORDER_QUOTATION_CHARGE_TAB%ROWTYPE )
IS
   quoterec_              Order_Quotation_API.Public_Rec;
   multiple_tax_          VARCHAR2(20);
BEGIN
   quoterec_            := Order_Quotation_API.Get(newrec_.quotation_no);   
   
   Tax_Handling_Order_Util_API.Get_Prices(newrec_.base_charge_amount,
                                          newrec_.base_charge_amt_incl_tax,
                                          newrec_.charge_amount,
                                          newrec_.charge_amount_incl_tax,
                                          multiple_tax_,
										            newrec_.tax_code,
                                          newrec_.tax_calc_structure_id,
                                          newrec_.tax_class_id,
                                          newrec_.quotation_no, 
                                          newrec_.quotation_charge_no, 
                                          '*',
                                          '*',
                                          '*',
                                          Tax_Source_API.DB_ORDER_QUOTATION_CHARGE,
                                          quoterec_.contract,
                                          quoterec_.customer_no,
                                          Get_Connected_Address_Id__(newrec_.quotation_no, newrec_.quotation_charge_no),
                                          Get_Conn_Planned_Ship_Date(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, quoterec_.contract, quoterec_.wanted_delivery_date),
                                          quoterec_.supply_country,
                                          NVL(newrec_.delivery_type, '*'),
                                          newrec_.charge_type,
                                          quoterec_.use_price_incl_tax,
                                          quoterec_.currency_code,
                                          newrec_.currency_rate,
                                          'FALSE',                                          
                                          Get_Connected_Tax_Liability(newrec_.quotation_no, newrec_.quotation_charge_no),
                                          Get_Conn_Tax_Liability_Type_Db(newrec_.quotation_no, newrec_.quotation_charge_no),
                                          delivery_country_db_ => NULL,
                                          ifs_curr_rounding_ => 16,
                                          tax_from_diff_source_ => 'FALSE',
                                          attr_ => NULL); 
END Calculate_Prices___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_                VARCHAR2(5);
   quotation_no_            VARCHAR2(12);
   customer_tax_usage_type_ VARCHAR2(5);
BEGIN
   quotation_no_            := Client_SYS.Get_Item_Value('QUOTATION_NO', attr_);
   contract_                := Order_Quotation_API.Get_Contract(quotation_no_);
   customer_tax_usage_type_ := Order_Quotation_API.Get_Customer_Tax_Usage_Type(quotation_no_);

   super(attr_);
   Client_SYS.Add_To_Attr('CHARGED_QTY', 1, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('UNIT_CHARGE_DB','FALSE', attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', customer_tax_usage_type_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ORDER_QUOTATION_CHARGE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   rev_no_                 NUMBER; 
   old_note_id_          NUMBER;
   jinsui_invoice_db_      VARCHAR2(20);
   tax_from_defaults_      BOOLEAN;
   original_quote_no_      VARCHAR2(12);
   original_charge_no_     VARCHAR2(50);
   add_tax_lines_          BOOLEAN;
   tax_from_external_system_ BOOLEAN := FALSE;
   fetch_external_tax_       BOOLEAN := TRUE;
   
   CURSOR get_seq_no(quotation_no_ IN VARCHAR2) IS
      SELECT nvl(MAX(quotation_charge_no) + 1, 1)
      FROM   ORDER_QUOTATION_CHARGE_TAB
      WHERE  quotation_no = quotation_no_;
   
   tax_method_    VARCHAR2(50);
BEGIN
   old_note_id_ := newrec_.note_id;
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   IF (old_note_id_ IS NOT NULL) THEN
      Document_Text_API.Copy_All_Note_Texts(old_note_id_, newrec_.note_id);
   END IF;
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);

   OPEN get_seq_no(newrec_.quotation_no);
   FETCH get_seq_no INTO newrec_.quotation_charge_no;
   CLOSE get_seq_no;
   Client_SYS.Add_To_Attr('QUOTATION_CHARGE_NO', newrec_.quotation_charge_no, attr_);
   original_quote_no_  := Client_SYS.Get_Item_Value('ORIGINAL_QUOTE_NO', attr_); 
   original_charge_no_ := Client_SYS.Get_Item_Value('ORIGINAL_CHARGE_NO', attr_); 
   IF (Client_SYS.Get_Item_Value('SET_TAX_FROM_ORIGINAL', attr_) = 'TRUE') AND 
      (Order_Quotation_API.Get_Customer_No(original_quote_no_) = Order_Quotation_API.Get_Customer_No(newrec_.quotation_no)) THEN
      newrec_.tax_class_id := Get_Tax_Class_Id(original_quote_no_, 
                                               original_charge_no_);  
   END IF; 
   
   IF (newrec_.customer_tax_usage_type IS NULL) THEN
      newrec_.customer_tax_usage_type := Order_Quotation_API.Get_Customer_Tax_Usage_Type(newrec_.quotation_no);
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);
   jinsui_invoice_db_ := Order_Quotation_API.Get_Jinsui_Invoice_Db(newrec_.quotation_no);
   IF jinsui_invoice_db_ ='TRUE' THEN
     Validate_Jinsui_Constraints__(newrec_.quotation_no,newrec_.quotation_charge_no, newrec_.line_no,
                                   newrec_.rel_no,newrec_.line_item_no, 0, FALSE);
   END IF;
   
   -- History
   rev_no_ := Order_Quotation_API.Get_Revision_No( newrec_.quotation_no );
   Order_Quotation_History_API.New( newrec_.quotation_no, '', '', '', 'CHARGE', newrec_.quotation_charge_no, rev_no_, 'New' );

   IF ((newrec_.line_no IS NULL) AND (newrec_.rel_no IS NULL)) THEN
      --Info about the sale quotation head.
      Order_Quotation_History_API.New(newrec_.quotation_no, 'CHARGE_TYPE', '', newrec_.charge_type, 'CHARGE', newrec_.quotation_charge_no, rev_no_, '');
      Order_Quotation_API.Quotation_Changed(newrec_.quotation_no);
   ELSE
      --Info about the sale quotation line.
      Order_Quote_Line_Hist_API.New( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, 'CHARGE_TYPE', '', newrec_.charge_type, 'CHARGE_LINE', ' ', rev_no_ );
      Order_Quotation_Line_API.Line_Changed(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   END IF;
      
   tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);
   IF (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
      tax_from_defaults_ := TRUE;
      tax_from_external_system_ := TRUE;
   ELSE      
      IF (NVL(Client_SYS.Get_Item_Value('COPY_QUOTATION_CHARGE', attr_), 'FALSE') = 'TRUE') THEN      
         tax_from_defaults_ := FALSE;
      ELSE
         IF (NVL(Client_SYS.Get_Item_Value('FETCH_TAX_CODES', attr_), 'TRUE') = 'TRUE') THEN
            IF (newrec_.tax_calc_structure_id IS NULL) THEN
               IF (newrec_.tax_code IS NULL) THEN
                  tax_from_defaults_ := TRUE;            
               ELSE
                  tax_from_defaults_ := FALSE;
               END IF;
            ELSE
               tax_from_defaults_ := FALSE;
            END IF;
         END IF;
      END IF;
   END IF;
   
   IF tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX 
      AND Company_Tax_Control_API.Get_Fetch_Tax_On_Line_Entry_Db(newrec_.company) = Fnd_Boolean_API.DB_FALSE THEN 
      fetch_external_tax_ := FALSE;
   END IF;
      
   -- If the line is copied or duplicated, taxes should be copied from the original line.
   IF (((Client_SYS.Get_Item_Value('SET_TAX_FROM_ORIGINAL', attr_) = 'TRUE') AND 
        (Order_Quotation_API.Get_Customer_No(original_quote_no_) = Order_Quotation_API.Get_Customer_No(newrec_.quotation_no)))
       OR
        -- in case we have multiple tax (neither tax code nor tax calculation structure on the charge line) 
        -- then when using RMB Copy Quotation... we should copy tax lines from the original quotation charge line
       ((NVL(Client_SYS.Get_Item_Value('COPY_QUOTATION_CHARGE', attr_), 'FALSE') = 'TRUE') AND
        newrec_.tax_calc_structure_id IS NULL AND
        newrec_.tax_code IS NULL)) AND (NOT tax_from_external_system_) THEN
        
      Tax_Handling_Order_Util_API.Transfer_Tax_lines(newrec_.company, 
                                                     Tax_Source_API.DB_ORDER_QUOTATION_CHARGE, 
                                                     original_quote_no_, 
                                                     original_charge_no_, 
                                                     '*', 
                                                     '*', 
                                                     '*',
                                                     Tax_Source_API.DB_ORDER_QUOTATION_CHARGE, 
                                                     newrec_.quotation_no, 
                                                     newrec_.quotation_charge_no, 
                                                     '*', 
                                                     '*', 
                                                     '*',
                                                     'TRUE',
                                                     'FALSE');
      IF (newrec_.charge IS NULL) THEN
         Calculate_Prices___(newrec_);
         Update_Line___(objid_, newrec_);
      END IF;
   ELSE
      IF (NVL(Client_SYS.Get_Item_Value('ADD_TAX_LINES', attr_), 'TRUE') = 'TRUE') THEN
         add_tax_lines_ := TRUE;
      ELSE
         add_tax_lines_ := FALSE;
      END IF;   
      IF fetch_external_tax_ THEN 
         Add_Transaction_Tax_Info___(newrec_ => newrec_,
                                     tax_from_defaults_ => tax_from_defaults_,
                                     add_tax_lines_ => add_tax_lines_,
                                     attr_ => NULL); 
      END IF;
   END IF;                           
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


PROCEDURE Update_Line___ (
   objid_  IN VARCHAR2,
   newrec_ IN ORDER_QUOTATION_CHARGE_TAB%ROWTYPE )
IS
BEGIN
   UPDATE ORDER_QUOTATION_CHARGE_TAB
      SET ROW = newrec_
      WHERE rowid = objid_;    
END Update_Line___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     ORDER_QUOTATION_CHARGE_TAB%ROWTYPE,
   newrec_     IN OUT ORDER_QUOTATION_CHARGE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   rev_no_                 NUMBER;
   jinsui_invoice_db_      VARCHAR2(20);
   use_price_incl_tax_     VARCHAR2(5);
   tax_code_changed_       VARCHAR2(5) := 'FALSE';
   freight_charges_recalc_ VARCHAR2(5) := 'FALSE';
   multiple_tax_lines_     VARCHAR2(20);
   tax_item_removed_       VARCHAR2(5) := 'FALSE';
   tax_method_             VARCHAR2(50);
   from_defaults_          BOOLEAN;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
      
   use_price_incl_tax_ := Order_Quotation_API.Get_Use_Price_Incl_Tax_Db(newrec_.quotation_no);   
   multiple_tax_lines_  := Client_SYS.Get_Item_Value('MULTIPLE_TAX_LINES', attr_);
   IF ((newrec_.tax_code IS NULL) AND (newrec_.tax_calc_structure_id IS NULL) 
      AND (multiple_tax_lines_ IS NOT NULL) AND (multiple_tax_lines_ = 'FALSE')) THEN
      
      tax_item_removed_ := 'TRUE';
      
      Source_Tax_Item_Order_API.Remove_Tax_Items(newrec_.company, 
                                                 Tax_Source_API.DB_ORDER_QUOTATION_CHARGE,
                                                 newrec_.quotation_no, 
                                                 TO_CHAR(newrec_.quotation_charge_no), 
                                                 '*', 
                                                 '*',
                                                 '*');
      Tax_Handling_Util_API.Validate_Tax_Code_Mandatory(newrec_.company, 'CUSTOMER_TAX');       
   END IF;
   IF ((tax_item_removed_ != 'TRUE') AND ((NVL(oldrec_.tax_code, ' ') != NVL(newrec_.tax_code, ' ')) OR
      (NVL(newrec_.tax_calc_structure_id, Database_SYS.string_null_) != NVL(oldrec_.tax_calc_structure_id, Database_SYS.string_null_)) OR      
      (newrec_.charge_type != oldrec_.charge_type) OR
      (NVL(oldrec_.line_no, ' ') != NVL(newrec_.line_no, ' ')) OR 
      (NVL(oldrec_.rel_no, ' ') != NVL(newrec_.rel_no, ' ')))) THEN

      -- Recalculate the tax if there has been a change in the line connection.
      IF ((NVL(oldrec_.line_no, ' ') != NVL(newrec_.line_no, ' ')) OR (NVL(oldrec_.rel_no, ' ') != NVL(newrec_.rel_no, ' '))) THEN
         from_defaults_ := TRUE;
      ELSE
         from_defaults_ := FALSE;
      END IF;

      Add_Transaction_Tax_Info___(newrec_ => newrec_,
                                  tax_from_defaults_ => from_defaults_,
                                  add_tax_lines_ => TRUE,
                                  attr_ => NULL);
   ELSIF ((newrec_.base_charge_amount != oldrec_.base_charge_amount OR newrec_.charge_amount != oldrec_.charge_amount) AND use_price_incl_tax_ = 'FALSE') OR
       (NVL(newrec_.customer_tax_usage_type,' ') != NVL(oldrec_.customer_tax_usage_type,' ')) OR
       ((newrec_.base_charge_amt_incl_tax != oldrec_.base_charge_amt_incl_tax OR newrec_.charge_amount_incl_tax != oldrec_.charge_amount_incl_tax) AND use_price_incl_tax_ = 'TRUE') OR
       (newrec_.charged_qty != oldrec_.charged_qty) OR (NVL(newrec_.charge, -9999999999999) != NVL(oldrec_.charge, -9999999999999)) THEN

      tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);
      IF (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
         from_defaults_ := TRUE;
         Add_Transaction_Tax_Info___(newrec_ => newrec_,
                                     tax_from_defaults_ => from_defaults_,
                                     add_tax_lines_ => TRUE,
                                     attr_ => NULL);
      ELSE
         Recalculate_Tax_Lines___(newrec_, from_defaults_, NULL);
      END IF;
   END IF;
   
   tax_code_changed_ := Client_Sys.Get_Item_Value('TAX_CODE_CHANGED', attr_);
   freight_charges_recalc_ := Client_Sys.Get_Item_Value('FREIGHT_CHARGES_RECALCULATED', attr_);
   IF ((NVL(tax_code_changed_, 'FALSE') = 'TRUE' AND newrec_.charge IS NULL) OR NVL(freight_charges_recalc_, 'FALSE') = 'TRUE') THEN
      Calculate_Prices___(newrec_);
      Update_Line___(objid_, newrec_);
   END IF;
   
   jinsui_invoice_db_ := Order_Quotation_API.Get_Jinsui_Invoice_Db(newrec_.quotation_no);
   IF jinsui_invoice_db_ ='TRUE' THEN
      Validate_Jinsui_Constraints__(newrec_.quotation_no,newrec_.quotation_charge_no, newrec_.line_no,
                                    newrec_.rel_no,newrec_.line_item_no, 0, FALSE);
   END IF;
   
-- History
   rev_no_ := Order_Quotation_API.Get_Revision_No( oldrec_.quotation_no );

   IF ((newrec_.line_no IS NULL) AND (newrec_.rel_no IS NULL)) THEN
      --Info about the sale quotation head.
      IF (nvl(oldrec_.charge_type, '0') != nvl(newrec_.charge_type, '0')) THEN
         Order_Quotation_History_API.New(newrec_.quotation_no, 'CHARGE_TYPE',
                                         oldrec_.charge_type, newrec_.charge_type,
                                         'CHARGE', newrec_.quotation_charge_no, rev_no_, '');
         Order_Quotation_API.Quotation_Changed(newrec_.quotation_no);
      END IF;
      IF ( NVL(oldrec_.charged_qty, 0) != NVL(newrec_.charged_qty, 0) ) THEN
--    Order_Quotation_History_API.New( newrec_.quotation_no, 'DESIRED_QTY', oldrec_.charged_qty, newrec_.charged_qty,
--    'QUOTATION', newrec_.quotation_charge_no, rev_no_, 'New' );
         Order_Quotation_History_API.New(newrec_.quotation_no, 'CHARGED_QTY', oldrec_.charged_qty, newrec_.charged_qty,
                                         'CHARGE', newrec_.quotation_charge_no, rev_no_, '' );
         Order_Quotation_API.Quotation_Changed(newrec_.quotation_no);
      END IF;
      IF ( NVL(oldrec_.charge_amount, 0) != NVL(newrec_.charge_amount, 0) ) THEN
         Order_Quotation_History_API.New(newrec_.quotation_no, 'CHARGE_AMOUNT', oldrec_.charge_amount, newrec_.charge_amount,
                                         'CHARGE', newrec_.quotation_charge_no, rev_no_, '' );
         Order_Quotation_API.Quotation_Changed(newrec_.quotation_no);
      END IF;

      IF ( NVL(oldrec_.base_charge_amount, 0) != NVL(newrec_.base_charge_amount, 0) ) THEN
         Order_Quotation_History_API.New(newrec_.quotation_no, 'BASE_CHARGE_AMOUNT', oldrec_.base_charge_amount, newrec_.base_charge_amount,
                                         'CHARGE', newrec_.quotation_charge_no, rev_no_, '' );
         Order_Quotation_API.Quotation_Changed(newrec_.quotation_no);
      END IF;
   ELSE
      --Info about the sale quotation line.
      IF ( NVL(oldrec_.charge_type, '0') != NVL(newrec_.charge_type, '0') ) THEN
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'CHARGE_TYPE', oldrec_.charge_type, newrec_.charge_type,
                                       'CHARGE_LINE', ' ', rev_no_ );
         Order_Quotation_Line_API.Line_Changed(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      END IF;
      IF ( NVL(oldrec_.charged_qty, 0) != NVL(newrec_.charged_qty, 0) ) THEN
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'CHARGED_QTY', oldrec_.charged_qty, newrec_.charged_qty,
                                       'CHARGE_LINE', ' ', rev_no_ );
         Order_Quotation_Line_API.Line_Changed(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      END IF;
      IF ( NVL(oldrec_.charge_amount, 0) != NVL(newrec_.charge_amount, 0) ) THEN
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'CHARGE_AMOUNT', oldrec_.charge_amount, newrec_.charge_amount,
                                       'CHARGE_LINE', ' ', rev_no_ );
         Order_Quotation_Line_API.Line_Changed(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      END IF;
      IF ( NVL(oldrec_.base_charge_amount, 0) != NVL(newrec_.base_charge_amount, 0) ) THEN
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'BASE_CHARGE_AMOUNT', oldrec_.base_charge_amount, newrec_.base_charge_amount,
                                       'CHARGE_LINE', ' ', rev_no_ );
         Order_Quotation_Line_API.Line_Changed(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      END IF;
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_          IN ORDER_QUOTATION_CHARGE_TAB%ROWTYPE,
   allow_promo_del_ IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (remrec_.campaign_id IS NOT NULL) AND (NOT allow_promo_del_) THEN
      Error_SYS.Record_General(lu_name_, 'NOREMOVEPROMOCHG: Sales promotion charge lines can only be removed by clearing the sales promotion calculations.');
   END IF;

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN ORDER_QUOTATION_CHARGE_TAB%ROWTYPE )
IS
   quotrec_   Order_Quotation_API.Public_Rec;
BEGIN   
   Remove_Tax_Lines(remrec_.quotation_no, remrec_.quotation_charge_no);
   
   super(objid_, remrec_);
  
   -- History
   quotrec_ := Order_Quotation_API.Get(remrec_.quotation_no);
   Order_Quotation_History_API.New(remrec_.quotation_no, '', '', '', 'CHARGE', remrec_.quotation_charge_no,
                                   quotrec_.revision_no, 'Deleted' );
   IF quotrec_.b2b_order = 'FALSE' THEN
      IF ((remrec_.line_no IS NULL) AND (remrec_.rel_no IS NULL)) THEN
         --Info about the sale quotation head.
         Order_Quotation_History_API.New(remrec_.quotation_no, 'CHARGE_TYPE',
                                         remrec_.charge_type, '',
                                         'CHARGE', remrec_.quotation_charge_no, quotrec_.revision_no, '');
         Order_Quotation_API.Quotation_Changed(remrec_.quotation_no);
      ELSE
         --Info about the sale quotation line.
         Order_Quote_Line_Hist_API.New(remrec_.quotation_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no,
                                       'CHARGE_TYPE', remrec_.charge_type, '',
                                       'CHARGE_LINE', ' ', quotrec_.revision_no );
         Order_Quotation_Line_API.Line_Changed(remrec_.quotation_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no);
      END IF;
   END IF;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT order_quotation_charge_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
   rows_                       NUMBER;
   objstate_                   VARCHAR2(20);
   quotrec_                    Order_Quotation_API.Public_Rec;
   line_rec_                   Order_Quotation_Line_API.Public_Rec;
   server_data_change_         VARCHAR2(5);
   sales_chg_type_category_db_ VARCHAR2(20);
   identity_                   VARCHAR2(20);
   temp_charge_line_           VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   error_text_                 VARCHAR2(100);
   planned_ship_date_          DATE;  
   charge_amount_              CUSTOMER_ORDER_CHARGE_TAB.charge_amount%TYPE; 

   CURSOR get_rows(quotation_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2) IS
      SELECT 1
      FROM   order_quotation_line_tab
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    rel_no  = rel_no_
      AND    line_item_no = -1;
BEGIN
   IF (NOT indrec_.charged_qty) THEN
      newrec_.charged_qty := 1;  
   END IF;   
   IF (NOT indrec_.company AND newrec_.company IS NULL) THEN
      newrec_.company := Site_API.Get_Company(newrec_.contract);
   END IF;   
   server_data_change_ := Client_SYS.Get_Item_Value('SERVER_DATA_CHANGE', attr_);
   temp_charge_line_   := Client_SYS.Get_Item_Value('TEMP_CHARGE_LINE', attr_);
   quotrec_            := Order_Quotation_API.Get(newrec_.quotation_no);

   -- adding charges to cancelled orders is not allowed
   objstate_ := Order_Quotation_API.Get_Objstate(newrec_.quotation_no);
   IF (objstate_ = 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_, 'QCHARGEWRSTATEHDIN: A charge can not be added when quotation has status Cancelled.');
   END IF;

   IF (newrec_.charged_qty = 0 AND temp_charge_line_ = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'CHARGEQTYNOTZERO: Charged quantity may not be zero.');
   END IF;

   -- fetch line_item_no
   IF (newrec_.line_item_no IS NULL AND newrec_.line_no IS NOT NULL AND newrec_.rel_no IS NOT NULL) THEN
      OPEN get_rows(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no);
      FETCH get_rows INTO rows_;
      IF get_rows%FOUND THEN
         newrec_.line_item_no := -1;
      ELSE 
         newrec_.line_item_no := 0;
      END IF;      
      CLOSE get_rows;
      Order_Quotation_Line_API.Exist(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   END IF;

   IF ((newrec_.line_no IS NULL) AND (newrec_.rel_no IS NULL)) THEN
      newrec_.line_item_no := NULL;
   -- checks so you dont try to connect to line with some of the keys null
   ELSIF (((newrec_.line_no IS NOT NULL) AND (newrec_.rel_no IS NULL)) OR ((newrec_.rel_no IS NOT NULL) AND (newrec_.line_no IS NULL))) THEN
      Error_SYS.Record_General(lu_name_, 'QCHARGEWRLINE: Quotation line does not exist');
   END IF;
   
   line_rec_ := Order_Quotation_Line_API.Get(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   
   IF (newrec_.line_no IS NOT NULL) THEN
   -- adding charges to cancelled/closed quotation lines is not allowed
      objstate_ := Order_Quotation_Line_API.Get_Objstate(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      IF (objstate_ IN ('Cancelled', 'Closed')) THEN
         Error_SYS.Record_General(lu_name_, 'QCHARGEWRSTATELNIN: A charge can not be added when the connected quotation line has status Cancelled or Closed.');
      END IF;
      IF (line_rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
         error_text_ := newrec_.quotation_no || '-' || newrec_.line_no ||'-' || newrec_.rel_no;
         Error_SYS.Record_General(lu_name_, 'QCHARGENOTALLOWRENT: You are not allowed to connect sales charge :P1 to sales quotation line :P2 since the quotation line is a rental line.',
                                  newrec_.charge_type, error_text_);
      END IF;
   END IF;

   sales_chg_type_category_db_ := Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, newrec_.charge_type);
   IF ((sales_chg_type_category_db_ != 'OTHER') AND (server_data_change_ IS NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALCHGTYPE: Only charges of the charge type category Other can be entered manually.');
   END IF;

   IF (newrec_.unit_charge = 'TRUE') THEN
      IF (newrec_.line_no IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'SHOULD_BE_CONNECTED: Charge Type with Unit Charge should be connected to a Order Quotation Line.');
      END IF;
      -- for the unit charges the charge qty should be equal to the Connected CO line's buy_qty_due.
      IF newrec_.charge_price_list_no IS NULL THEN
         newrec_.charged_qty := line_rec_.buy_qty_due;
      END IF;
   END IF;

   newrec_.date_entered := Site_API.Get_Site_Date(newrec_.contract);

   super(newrec_, indrec_, attr_);
   IF newrec_.currency_rate IS NULL THEN
      charge_amount_ := newrec_.charge_amount;
      identity_ := quotrec_.customer_no_pay;
      IF identity_ IS NULL THEN
         identity_ := quotrec_.customer_no;
      END IF;
      Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amount_, newrec_.currency_rate,
                                                             identity_, newrec_.contract, quotrec_.currency_code, 
                                                             newrec_.base_charge_amount);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'CURRENCY_RATE', newrec_.currency_rate);
   -- add line item no back to client to make e.g. the tax lines RMB work correctly
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', newrec_.line_item_no, attr_);

   Validate_Charge_And_Cost___(newrec_);

END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     order_quotation_charge_tab%ROWTYPE,
   newrec_ IN OUT order_quotation_charge_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   objstate_           VARCHAR2(20);
   rows_               NUMBER;
   tax_code_           VARCHAR2(20);  
   server_data_change_ VARCHAR2(5);
   quotrec_            Order_Quotation_API.Public_Rec;
   line_rec_           Order_Quotation_Line_API.Public_Rec;   
   error_text_         VARCHAR2(100);
   planned_ship_date_  DATE;   
   
   CURSOR get_rows (quotation_no_ VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2) IS
      SELECT 1
      FROM   order_quotation_line_tab
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    rel_no  = rel_no_
      AND    line_item_no = -1;
BEGIN  
   -- fetch company for old clients that don't have company in them
   IF (NOT indrec_.company AND newrec_.company IS NULL) THEN
      newrec_.company := Site_API.Get_Company(newrec_.contract);
   END IF;  
   IF (indrec_.tax_code) THEN
      tax_code_ := newrec_.tax_code;
   END IF;   
   server_data_change_ := Client_SYS.Get_Item_Value('SERVER_DATA_CHANGE', attr_);   
   -- changing charges to cancelled orders is not allowed
   objstate_ := Order_Quotation_API.Get_Objstate(newrec_.quotation_no);
   IF (objstate_ = 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_, 'QCHARGEWRSTATEHDUP: A charge can not be altered when quotation has status Cancelled.');
   END IF;

   -- set line_item_no
   IF (newrec_.line_item_no IS NULL AND newrec_.line_no IS NOT NULL AND newrec_.rel_no IS NOT NULL) THEN
      OPEN get_rows(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no);
      FETCH get_rows INTO rows_;
      IF get_rows%FOUND THEN
         newrec_.line_item_no := -1;
      ELSE 
         newrec_.line_item_no := 0;
      END IF;      
      CLOSE get_rows;
      Order_Quotation_Line_API.Exist(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   END IF;

   IF ((newrec_.line_no IS NULL) AND (newrec_.rel_no IS NULL)) THEN
      newrec_.line_item_no := NULL;
   -- checks so you don't try to connect to a line with some of the keys null
   ELSIF (((newrec_.line_no IS NOT NULL) AND (newrec_.rel_no IS NULL)) OR ((newrec_.rel_no IS NOT NULL) AND (newrec_.line_no IS NULL))) THEN
      Error_SYS.Record_General(lu_name_, 'QCHARGEWRLINE: Quotation line does not exist');
   END IF;
   
   line_rec_ := Order_Quotation_Line_API.Get(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   
   IF (newrec_.line_no IS NOT NULL) THEN
   -- changing charges to cancelled/closed quotation lines is not allowed
      objstate_ := Order_Quotation_Line_API.Get_Objstate(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      IF (objstate_ IN ('Cancelled', 'Closed')) THEN
         Error_SYS.Record_General(lu_name_, 'QCHARGEWRONGSTATELNUP: A charge can not be altered when the connected quotation line has status Cancelled or Closed.');
      END IF;
      IF (line_rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
         error_text_ := newrec_.quotation_no || '-' || newrec_.line_no ||'-' || newrec_.rel_no;
         Error_SYS.Record_General(lu_name_, 'QCHARGENOTALLOWRENT: You are not allowed to connect sales charge :P1 to sales quotation line :P2 since the quotation line is a rental line.',
                                  newrec_.charge_type, error_text_);
      END IF;
   END IF;

   IF (newrec_.unit_charge = 'TRUE') THEN
      IF (newrec_.line_no IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'SHOULD_BE_CONNECTED: Charge Type with Unit Charge should be connected to a Order Quotation Line.');
      END IF;
      IF (Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, newrec_.charge_type) != 'FREIGHT') AND
         (newrec_.unit_charge != oldrec_.unit_charge) OR
         (Validate_SYS.Is_Changed(newrec_.line_no, oldrec_.line_no)) OR
         (Validate_SYS.Is_Changed(newrec_.rel_no, oldrec_.rel_no)) THEN
         --Unit charge has been set to true or connected CO line has changed in this operation
         newrec_.charged_qty := line_rec_.buy_qty_due;

      ELSIF (NVL(newrec_.charged_qty,-1) != oldrec_.charged_qty) AND
         (Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, newrec_.charge_type) NOT IN ('PACK_SIZE', 'FREIGHT')) THEN
         -- Charge Qty has been changed while unit charge is true
         IF (NVL(newrec_.charged_qty, -1) != line_rec_.buy_qty_due) THEN
            Error_SYS.Record_General(lu_name_, 'CHARGE_QTY_CHANGED: Charged Quantity must be equal to the quantity on the connected Order Quotation Line when Unit Charge is used.');
         END IF;  
      END IF;
   END IF;

   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (indrec_.customer_tax_usage_type) THEN
      IF (Order_Quotation_API.Get_Objstate(newrec_.quotation_no) = 'Closed') THEN
         Error_SYS.Record_General(lu_name_, 'QCHARGEWRSTATECLSD: A charge can not be altered when quotation has status Closed.');
      END IF;
   END IF;  

   Error_SYS.Check_Not_Null(lu_name_, 'CURRENCY_RATE', newrec_.currency_rate);
   -- add line item no back to client to make e.g. the tax lines RMB work correctly
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', newrec_.line_item_no, attr_);
   
   IF indrec_.tax_code THEN
      Client_SYS.Add_To_Attr('TAX_CODE_CHANGED', 'TRUE', attr_);
   END IF;
   
   Validate_Charge_And_Cost___(newrec_); 
   
END Check_Update___;

-- Add_Transaction_Tax_Info___
--    Fetch and calculate taxes and add tax lines to source_tax_item_tab.
PROCEDURE Add_Transaction_Tax_Info___ (
   newrec_              IN OUT ORDER_QUOTATION_CHARGE_TAB%ROWTYPE,
   tax_from_defaults_   IN BOOLEAN,
   add_tax_lines_       IN BOOLEAN,
   attr_                IN VARCHAR2)
IS
   line_amount_rec_       Tax_Handling_Util_API.line_amount_rec;
   source_key_rec_        Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_    Tax_Handling_Order_Util_API.tax_line_param_rec;
   quoterec_              Order_Quotation_API.Public_Rec;
   multiple_tax_          VARCHAR2(20);
   tax_info_table_        Tax_Handling_Util_API.tax_information_table;
   tax_liability_type_db_ VARCHAR2(20);
   tax_liability_         VARCHAR2(20);
 	delivery_country_      VARCHAR2(5);
BEGIN
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_ORDER_QUOTATION_CHARGE,
                                                                      newrec_.quotation_no, 
                                                                      TO_CHAR(newrec_.quotation_charge_no), 
                                                                      '*', 
                                                                      '*',
                                                                      '*',
                                                                      attr_); 
                                      
   quoterec_       := Order_Quotation_API.Get(newrec_.quotation_no);
   
   tax_liability_    := Get_Connected_Tax_Liability(newrec_.quotation_no, newrec_.quotation_charge_no);
 	delivery_country_ := Get_Connected_Deliv_Country(newrec_.quotation_no, newrec_.quotation_charge_no);
 	tax_liability_type_db_  := Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_liability_, delivery_country_);
   
   IF (tax_liability_type_db_ = 'EXM') THEN
      IF (Sales_Charge_Type_API.Get_Taxable_Db(quoterec_.contract, newrec_.charge_type) = Fnd_Boolean_API.DB_TRUE AND tax_from_defaults_) THEN
         IF (quoterec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE) THEN
            newrec_.tax_code :=  Order_Quotation_API.Get_Vat_Free_Vat_Code(quoterec_.quotation_no);  
         END IF;
      END IF;
   END IF;
   
   tax_line_param_rec_.company               := newrec_.company;
   tax_line_param_rec_.contract              := quoterec_.contract;
   tax_line_param_rec_.customer_no           := quoterec_.customer_no;
   tax_line_param_rec_.ship_addr_no          := Get_Connected_Address_Id__(newrec_.quotation_no, newrec_.quotation_charge_no);
   tax_line_param_rec_.planned_ship_date     := Get_Conn_Planned_Ship_Date(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, quoterec_.contract, quoterec_.wanted_delivery_date);
   tax_line_param_rec_.supply_country_db     := quoterec_.supply_country;
   tax_line_param_rec_.delivery_type         := NVL(newrec_.delivery_type, '*');
   tax_line_param_rec_.object_id             := newrec_.charge_type;
   tax_line_param_rec_.use_price_incl_tax    := quoterec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code         := quoterec_.currency_code;
   tax_line_param_rec_.currency_rate         := newrec_.currency_rate;
   tax_line_param_rec_.tax_liability         := tax_liability_;
   tax_line_param_rec_.tax_liability_type_db := tax_liability_type_db_;    
   tax_line_param_rec_.from_defaults         := tax_from_defaults_;
   tax_line_param_rec_.tax_code              := newrec_.tax_code;
   tax_line_param_rec_.tax_calc_structure_id := newrec_.tax_calc_structure_id;
   tax_line_param_rec_.add_tax_lines         := add_tax_lines_;

   Tax_Handling_Order_Util_API.Add_Transaction_Tax_Info (line_amount_rec_,
                                                         multiple_tax_,
                                                         tax_info_table_,
                                                         tax_line_param_rec_,
                                                         source_key_rec_,
                                                         attr_);
END Add_Transaction_Tax_Info___;


PROCEDURE Recalculate_Tax_Lines___ (
   newrec_        IN OUT ORDER_QUOTATION_CHARGE_TAB%ROWTYPE,
   from_defaults_ IN BOOLEAN,
   attr_          IN VARCHAR2)
IS
   source_key_rec_              Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_          Tax_Handling_Order_Util_API.tax_line_param_rec;
   quoterec_                    Order_Quotation_API.Public_Rec;
BEGIN
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_ORDER_QUOTATION_CHARGE,
                                                                      newrec_.quotation_no, 
                                                                      TO_CHAR(newrec_.quotation_charge_no), 
                                                                      '*', 
                                                                      '*', 
                                                                      '*',
                                                                      attr_); 
                                      
   quoterec_       := Order_Quotation_API.Get(newrec_.quotation_no);
   
   tax_line_param_rec_.company               := newrec_.company;
   tax_line_param_rec_.contract              := quoterec_.contract;
   tax_line_param_rec_.customer_no           := quoterec_.customer_no;
   tax_line_param_rec_.ship_addr_no          := Get_Connected_Address_Id__(newrec_.quotation_no, newrec_.quotation_charge_no);
   tax_line_param_rec_.planned_ship_date     := Get_Conn_Planned_Ship_Date(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, quoterec_.contract, quoterec_.wanted_delivery_date);
   tax_line_param_rec_.supply_country_db     := quoterec_.supply_country;
   tax_line_param_rec_.delivery_type         := NVL(newrec_.delivery_type, '*');
   tax_line_param_rec_.object_id             := newrec_.charge_type;
   tax_line_param_rec_.use_price_incl_tax    := quoterec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code         := quoterec_.currency_code;
   tax_line_param_rec_.currency_rate         := newrec_.currency_rate;
   tax_line_param_rec_.tax_liability         := Get_Connected_Tax_Liability(newrec_.quotation_no, newrec_.quotation_charge_no);
   tax_line_param_rec_.tax_liability_type_db := Get_Conn_Tax_Liability_Type_Db(newrec_.quotation_no, newrec_.quotation_charge_no);   
   tax_line_param_rec_.from_defaults         := from_defaults_;
   tax_line_param_rec_.tax_code              := newrec_.tax_code;
   tax_line_param_rec_.tax_calc_structure_id := newrec_.tax_calc_structure_id;
   tax_line_param_rec_.add_tax_lines         := TRUE;

   Tax_Handling_Order_Util_API.Recalculate_Tax_Lines (source_key_rec_,
                                                      tax_line_param_rec_,
                                                      attr_);
END Recalculate_Tax_Lines___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_                 ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   newrec_                 ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;   
   charge_type_db_         VARCHAR2(25);
BEGIN
   IF (action_ = 'DO') THEN
      oldrec_ := Get_Object_By_Id___(objid_);
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      newrec_ := Get_Object_By_Id___(objid_);
      IF (newrec_.line_no != oldrec_.line_no OR 
         newrec_.rel_no != oldrec_.rel_no OR                  
         newrec_.charge_type != oldrec_.charge_type OR 
         NVL(newrec_.tax_code, Database_SYS.string_null_) != NVL(oldrec_.tax_code, Database_SYS.string_null_) OR
         NVL(newrec_.tax_class_id, Database_SYS.string_null_) != NVL(oldrec_.tax_class_id, Database_SYS.string_null_) OR
         NVL(newrec_.tax_calc_structure_id, Database_SYS.string_null_) != NVL(oldrec_.tax_calc_structure_id, Database_SYS.string_null_) OR
         newrec_.charge_cost != oldrec_.charge_cost OR 
         newrec_.charged_qty != oldrec_.charged_qty OR  
         newrec_.unit_charge != oldrec_.unit_charge OR 
         newrec_.intrastat_exempt != oldrec_.intrastat_exempt OR
         NVL(newrec_.charge, -9999999999999) != NVL(oldrec_.charge, -9999999999999) OR 
         NVL(newrec_.charge_amount, -9999999999999) != NVL(oldrec_.charge_amount, -9999999999999) OR
         NVL(newrec_.base_charge_amount, -9999999999999) != NVL(oldrec_.base_charge_amount, -9999999999999)) THEN
         charge_type_db_ := Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, oldrec_.charge_type);
         Do_Additional_Validations___(newrec_.charge_price_list_no, charge_type_db_);
      END IF; 
      info_ := info_ || Client_SYS.Get_All_Info;
   END IF;
END Modify__;

-- Modify_Fee_Code__
--   Modifies the charge line fee code
PROCEDURE Modify_Fee_Code__ (
   attr_                IN OUT VARCHAR2,
   quotation_no_        IN     VARCHAR2,
   quotation_charge_no_ IN     NUMBER )
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   oldrec_           ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   newrec_           ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   tax_code_         ORDER_QUOTATION_CHARGE_TAB.tax_code%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, quotation_charge_no_);
   oldrec_          := Lock_By_Id___(objid_, objversion_);
   newrec_          := oldrec_;
   tax_code_        := Client_Sys.Get_Item_Value('TAX_CODE',attr_);
   newrec_.tax_code := tax_code_;
   Client_SYS.Set_Item_Value('TAX_CODE_CHANGED', 'TRUE', attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Fee_Code__;


-- Get_Connected_Address_Id__
--   Called from ORDER_QUOTATION_CHARGE_API
--   This method returns the address id connected to a charge line.
FUNCTION Get_Connected_Address_Id__ (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN VARCHAR2
IS
   line_no_      ORDER_QUOTATION_CHARGE_TAB.line_no%TYPE;
   rel_no_       ORDER_QUOTATION_CHARGE_TAB.rel_no%TYPE;
   line_item_no_ ORDER_QUOTATION_CHARGE_TAB.line_item_no%TYPE;
   address_id_   ORDER_QUOTATION_TAB.ship_addr_no%TYPE;

   CURSOR get_quote_line_connection IS
      SELECT line_no, rel_no, line_item_no
      FROM   ORDER_QUOTATION_CHARGE_TAB
      WHERE  quotation_no = quotation_no_
      AND    quotation_charge_no = quotation_charge_no_;
BEGIN
   OPEN get_quote_line_connection;
   FETCH get_quote_line_connection INTO line_no_, rel_no_, line_item_no_;
   CLOSE get_quote_line_connection;
   IF (line_no_ IS NULL) THEN
      address_id_  := Order_Quotation_API.Get_Ship_Addr_No(quotation_no_);
   ELSE
      address_id_ := Order_Quotation_Line_API.Get_Ship_Addr_No(quotation_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   RETURN address_id_;
END Get_Connected_Address_Id__;


-- Check_Delivery_Type__
--   Checks if delivery_type exists. If found, print an error message.
--   Used for restricted delete check when removing delivery_type (INVOIC-module).
PROCEDURE Check_Delivery_Type__ (
   key_list_ IN VARCHAR2 )
IS
   company_       VARCHAR2(20);
   delivery_type_ ORDER_QUOTATION_CHARGE_TAB.delivery_type%TYPE;
   found_         NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   ORDER_QUOTATION_CHARGE_TAB
      WHERE  Site_API.Get_Company(contract) = company_
      AND    delivery_type = delivery_type_;
BEGIN
   company_       := SUBSTR(key_list_, 1, INSTR(key_list_, '^') - 1);
   delivery_type_ := SUBSTR(key_list_, INSTR(key_list_, '^') + 1, INSTR(key_list_, '^' , 1, 2) - (INSTR(key_list_, '^') + 1));

   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   IF found_ = 1 THEN
      Error_SYS.Record_General(lu_name_, 'NO_DEL_TYPE: Delivery Type :P1 exists on one or several Order Quotation Charge(s)', delivery_type_ );
   END IF;
END Check_Delivery_Type__;

-- Copy_Lines__
--   Copies all the charge lines in from_quotation_no_ to to_quotation_no_. If copy_pricing_ is FALSE then pricing is fetched 
--   instead of copying.
PROCEDURE Copy_Lines__ (
   from_quotation_no_   IN VARCHAR2,
   to_quotation_no_     IN VARCHAR2,   
   copy_pricing_        IN VARCHAR2,
   copy_lines_          IN VARCHAR2,
   copy_document_texts_ IN VARCHAR2) 
IS  
   TYPE quotation_chrg_tab IS TABLE OF ORDER_QUOTATION_CHARGE_TAB%ROWTYPE INDEX BY PLS_INTEGER;
   quote_charge_tab_    quotation_chrg_tab;
   attr_                VARCHAR2(2000);
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   newrec_              ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   oldrec_              ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   empty_rec_           ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   header_rec_          Order_Quotation_API.Public_Rec; 
   curr_code_           varchar2(3);
   customer_no_         varchar2(20);
   curr_rate_           number;
   conv_factor_         number;
   curr_type_           varchar2(10);
      
   CURSOR get_rec IS
      SELECT oqc.*
      FROM ORDER_QUOTATION_CHARGE_TAB oqc, SALES_CHARGE_TYPE_TAB sct
      WHERE quotation_no = from_quotation_no_
      AND oqc.charge_type = sct.charge_type
      AND oqc.contract = sct.contract
      AND sct.sales_chg_type_category = 'OTHER';
      
   CURSOR get_unconnected_charg_rec IS
      SELECT oqc.*
      FROM ORDER_QUOTATION_CHARGE_TAB oqc, SALES_CHARGE_TYPE_TAB sct
      WHERE quotation_no = from_quotation_no_
      AND oqc.charge_type = sct.charge_type
      AND oqc.contract = sct.contract
      AND sct.sales_chg_type_category = 'OTHER'
      AND oqc.line_no IS NULL;   
BEGIN   
   Order_Quotation_API.Exist(to_quotation_no_);
   header_rec_ := Order_Quotation_API.Get(to_quotation_no_);   
   IF (copy_lines_ = Fnd_Boolean_API.DB_TRUE) THEN 
      OPEN get_rec;
   ELSE 
      OPEN get_unconnected_charg_rec;
   END IF ;
   LOOP  
      IF (copy_lines_ = Fnd_Boolean_API.DB_TRUE) THEN 
         FETCH get_rec BULK COLLECT INTO quote_charge_tab_ LIMIT 1000;
      ELSE 
         FETCH get_unconnected_charg_rec BULK COLLECT INTO quote_charge_tab_ LIMIT 1000;
      END IF ;
      IF (quote_charge_tab_.COUNT >0) THEN             
         FOR j IN quote_charge_tab_.FIRST..quote_charge_tab_.LAST LOOP
            -- Reset variables
            attr_                := NULL;            
            Client_SYS.Add_To_Attr('COPY_QUOTATION_CHARGE', 'TRUE', attr_);   
            Client_SYS.Add_To_Attr('ORIGINAL_QUOTE_NO', from_quotation_no_, attr_);
            Client_SYS.Add_To_Attr('ORIGINAL_CHARGE_NO', quote_charge_tab_(j).quotation_charge_no, attr_);               
            newrec_              := empty_rec_;
            -- Assign copy record
            newrec_              := quote_charge_tab_(j);           
            newrec_.quotation_no := to_quotation_no_;               
            newrec_.rowkey       := NULL ; 
            curr_code_           := Order_Quotation_API.Get_Currency_Code(newrec_.quotation_no); 
            customer_no_         := Order_Quotation_API.Get_Customer_No (newrec_.quotation_no);
            Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, conv_factor_, curr_rate_, newrec_.company, curr_code_,
                                                           Site_API.Get_Site_Date(newrec_.contract), 'CUSTOMER', customer_no_);
            newrec_.currency_rate := curr_rate_ / conv_factor_;   
            IF (copy_document_texts_ = Fnd_Boolean_API.DB_FALSE) THEN
               newrec_.note_id := NULL;
            END IF;
            Insert___(objid_, objversion_, newrec_, attr_);            
            IF (copy_pricing_ = Fnd_Boolean_API.DB_FALSE) THEN
               Get_Id_Version_By_Keys___(objid_, objversion_, to_quotation_no_, newrec_.quotation_charge_no);
               oldrec_ := Lock_By_Id___(objid_, objversion_);
               newrec_ := oldrec_;
               Update___(objid_, oldrec_, newrec_, attr_, objversion_);           
            END IF;                       
            --Copy custom field values
            newrec_ := Get_Object_By_Id___(objid_);
            Custom_Objects_SYS.Copy_Cf_Instance(lu_name_, quote_charge_tab_(j).rowkey, newrec_.rowkey);                
            Recalculate_Tax_Lines___(newrec_, FALSE, NULL);
         END LOOP;
      END IF;            
      IF (copy_lines_ = Fnd_Boolean_API.DB_TRUE) THEN 
         EXIT WHEN get_rec%NOTFOUND;
      ELSE 
         EXIT WHEN get_unconnected_charg_rec%NOTFOUND;
      END IF ;
   END LOOP;
   IF (copy_lines_ = Fnd_Boolean_API.DB_TRUE) THEN 
      CLOSE get_rec;       
   ELSE 
      CLOSE get_unconnected_charg_rec;       
   END IF;       
END Copy_Lines__;

-- Get_Connected_Tax_Liability__
--   Called from CUSTOMER_ORDER_CHARGE_API.
--   This method returns the tax liability connected to a charge line.
@UncheckedAccess
FUNCTION Get_Connected_Tax_Liability__ (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   tax_liability_ ORDER_QUOTATION_TAB.tax_liability%TYPE;
BEGIN
   IF (line_no_ IS NULL) THEN
      tax_liability_ := Order_Quotation_Api.Get_Tax_Liability(quotation_no_);
   ELSE
      tax_liability_ := Order_Quotation_Line_Api.Get_Tax_Liability(quotation_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   RETURN tax_liability_;
END Get_Connected_Tax_Liability__;


-- Modify_Tax_Class_Id__
--   Modifies the charge line Tax Class Id
PROCEDURE Modify_Tax_Class_Id__ (
   attr_                IN OUT VARCHAR2,
   quotation_no_        IN     VARCHAR2,
   quotation_charge_no_ IN     NUMBER )
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   oldrec_           ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   newrec_           ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   tax_class_id_     ORDER_QUOTATION_CHARGE_TAB.tax_class_id%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, quotation_charge_no_);
   oldrec_              := Lock_By_Id___(objid_, objversion_);
   newrec_              := oldrec_;
   tax_class_id_        := Client_Sys.Get_Item_Value('TAX_CLASS_ID',attr_);
   newrec_.tax_class_id := tax_class_id_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Tax_Class_Id__;


@UncheckedAccess
FUNCTION Get_Connected_Deliv_Country__ (
   quotation_no_         IN VARCHAR2,
   quotation_charge_no_  IN VARCHAR2) RETURN VARCHAR2
IS
   delivery_country_db_   VARCHAR2(2);
   quot_chg_rec_          Order_Quotation_Charge_API.Public_Rec;
   quot_rec_              Order_Quotation_API.Public_Rec;   
BEGIN   
   quot_chg_rec_ := Order_Quotation_Charge_API.Get(quotation_no_, quotation_charge_no_);
   quot_rec_     := Order_Quotation_API.Get(quotation_no_);
   
   IF (quot_chg_rec_.line_no IS NOT NULL) THEN
      delivery_country_db_ := Order_Quotation_Line_API.Get_Ship_Country_Code(quotation_no_, quot_chg_rec_.line_no, quot_chg_rec_.rel_no, quot_chg_rec_.line_item_no);
   ELSIF (quot_rec_.single_occ_addr_flag = 'TRUE') THEN
      delivery_country_db_  := quot_rec_.ship_addr_country_code;
   ELSE
      delivery_country_db_ := Customer_Info_Address_API.Get_Country_Code(quot_rec_.customer_no, quot_rec_.ship_addr_no);
   END IF;
   RETURN delivery_country_db_;
END Get_Connected_Deliv_Country__;


-- Validate_Jinsui_Constraints__
--   Performs validation with the Junsi Invoice Constraints.
--   This method checks Jinsui maximum amount against Charges gross amount
--   in customer currency.
PROCEDURE Validate_Jinsui_Constraints__ (
   quotation_no_           IN VARCHAR2,
   quotation_charge_no_    IN NUMBER,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   company_max_jinsui_amt_ IN NUMBER,
   co_header_validation_   IN BOOLEAN )
IS
   company_                     VARCHAR2(20);
   company_maximum_amt_         NUMBER :=0;
   net_amount_                  NUMBER :=0;
   total_tax_pct_               NUMBER :=0;
   gross_charge_total_          NUMBER :=0;
   linr_net_amount_curr_        NUMBER :=0;
   line_total_tax_curr_         NUMBER :=0;
   gross_line_charge_amount_    NUMBER :=0;
   gross_line_total_base_curr_  NUMBER :=0;
   gross_line_toal_incl_charge_ NUMBER :=0;
BEGIN
   $IF Component_Jinsui_SYS.INSTALLED $THEN
      company_maximum_amt_ := company_max_jinsui_amt_;
      company_             := Get_Company(quotation_no_, quotation_charge_no_);
      IF (company_maximum_amt_ = 0 ) THEN
         company_maximum_amt_ := Js_Company_Info_API.Get_Virtual_Inv_Max_Amount(company_);         
      END IF;

      net_amount_         := Get_Total_Charged_Amount(quotation_no_, quotation_charge_no_);
      total_tax_pct_      := NVL(Get_Total_Charge_Tax_Pct(quotation_no_,quotation_charge_no_ ), 0);
      gross_charge_total_ := net_amount_ *(1+total_tax_pct_/100);
      IF (gross_charge_total_ > company_maximum_amt_) THEN
         IF (co_header_validation_) THEN
            Error_SYS.Record_General(lu_name_, 'OQCHGEXCEEDED: The total charge amount of sales quotation charge :P1 cannot be greater than the maximum amount for Jinsui invoice :P2 for the company :P3.', quotation_no_||'-'||quotation_charge_no_, company_maximum_amt_, company_);
         ELSE
            Error_SYS.Record_General(lu_name_, 'CHGEXCEEDED: The total charge amount cannot be greater than the maximum amount for Jinsui invoice :P1 for the company :P2.',company_maximum_amt_,company_);
         END IF;
      END IF;

      gross_line_charge_amount_    := Get_Gross_Amount_For_Col(quotation_no_,line_no_,rel_no_,line_item_no_);
      linr_net_amount_curr_        := Order_Quotation_Line_API.Get_Sale_Price_Total(quotation_no_,line_no_,rel_no_,line_item_no_);
      line_total_tax_curr_         := Order_Quotation_Line_API.Get_Total_Tax_Amount(quotation_no_,line_no_,rel_no_,line_item_no_);
      gross_line_total_base_curr_  := linr_net_amount_curr_ + line_total_tax_curr_;
      gross_line_toal_incl_charge_ := gross_line_total_base_curr_ + gross_line_charge_amount_;
      IF (gross_line_toal_incl_charge_ > company_maximum_amt_ ) THEN
         IF (co_header_validation_) THEN
            Error_SYS.Record_General(lu_name_, 'OQAMTLINECHEXCEED: The total charge and the connected line amount of sales quotation charge :P1 cannot be greater than the maximum amount for Jinsui invoice :P2 for the company :P3.', quotation_no_||'-'||quotation_charge_no_, company_maximum_amt_, company_);
         ELSE
            Error_SYS.Record_General(lu_name_, 'AMTLINECHEXCEED: The total charge and the connected line amount cannot be greater than the maximum amount for Jinsui invoice :P1 for the company :P2.',company_maximum_amt_,company_);
         END IF;
      END IF;
   $ELSE
      NULL;
   $END   
END Validate_Jinsui_Constraints__;


PROCEDURE Do_Additional_Validations___ (
   charge_price_list_no_   IN VARCHAR2,
   charge_type_category_   IN VARCHAR2)
IS
BEGIN
   IF charge_type_category_ = 'PROMOTION' THEN
      Error_SYS.Record_General(lu_name_, 'NOMODIFYCHARGETAXLINESPROMO: Charge line cannot be modified when sales charge type category is Promotion.');
   END IF;

   IF (charge_type_category_ = 'PACK_SIZE') AND charge_price_list_no_ IS NOT NULL THEN
      Error_Sys.Record_General(lu_name_, 'UPDATENOTALLOW: Charge line cannot be modified when Sales Charge Type Category is Pack Size.');      
   END IF;  
   
END Do_Additional_Validations___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Total_Charged_Amount
--   Calculates the total charged amount in Quotation currency using charged
--   amount and charged quantity.
@UncheckedAccess
FUNCTION Get_Total_Charged_Amount (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   total_charged_amount_ NUMBER;
   rec_                  ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   rounding_             NUMBER;
   currency_code_        VARCHAR2(3);
   use_price_incl_tax_   VARCHAR2 (20);
BEGIN
   IF (Order_Quotation_API.Get_Objstate(quotation_no_) = 'Cancelled' ) THEN
      total_charged_amount_ := 0;
   ELSE
      rec_                := Get_Object_By_Keys___(quotation_no_, quotation_charge_no_);
      currency_code_      := Order_Quotation_API.Get_Currency_Code(quotation_no_);
      rounding_           := Currency_Code_API.Get_Currency_Rounding(rec_.company, currency_code_);
      use_price_incl_tax_ := Order_Quotation_Api.Get_Use_Price_Incl_Tax_Db(quotation_no_);
      
      IF use_price_incl_tax_ = 'FALSE' THEN
         IF (rec_.charge_amount IS NULL) THEN
            total_charged_amount_ := rec_.charge * Get_Net_Charge_Percent_Basis(quotation_no_, quotation_charge_no_) * rec_.charged_qty / 100;
         ELSE
            total_charged_amount_ := rec_.charge_amount * rec_.charged_qty;
         END IF;
      ELSE
         total_charged_amount_ := Get_Total_Charge_Amnt_Incl_Tax(quotation_no_, quotation_charge_no_) - Get_Total_Tax_Amount(quotation_no_, quotation_charge_no_);
      END IF;
      total_charged_amount_ := NVL(total_charged_amount_, 0);
   END IF;
   RETURN ROUND(total_charged_amount_, rounding_);
END Get_Total_Charged_Amount;


@UncheckedAccess
FUNCTION Get_Total_Charge_Amnt_Incl_Tax (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   total_chrg_incl_tax_  NUMBER;
   rec_                  ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   rounding_             NUMBER;
   currency_code_        VARCHAR2(3);
   use_price_incl_tax_   VARCHAR2 (20);
BEGIN
   IF (Order_Quotation_API.Get_Objstate(quotation_no_) = 'Cancelled' ) THEN
      total_chrg_incl_tax_ := 0;
   ELSE
      rec_                := Get_Object_By_Keys___(quotation_no_, quotation_charge_no_);
      currency_code_      := Order_Quotation_API.Get_Currency_Code(quotation_no_);
      rounding_           := Currency_Code_API.Get_Currency_Rounding(rec_.company, currency_code_);
      use_price_incl_tax_ := Order_Quotation_Api.Get_Use_Price_Incl_Tax_Db(quotation_no_);

      IF use_price_incl_tax_ = 'FALSE' THEN
         total_chrg_incl_tax_ := Get_Total_Charged_Amount(quotation_no_, quotation_charge_no_) + Get_Total_Tax_Amount(quotation_no_, quotation_charge_no_);
      ELSE
         IF (rec_.charge_amount_incl_tax IS NULL) THEN
            total_chrg_incl_tax_ := rec_.charge * Get_Gross_Charge_Percent_Basis(quotation_no_, quotation_charge_no_) * rec_.charged_qty / 100;
         ELSE
            total_chrg_incl_tax_ := rec_.charge_amount_incl_tax * rec_.charged_qty;
         END IF;
      END IF;     
      total_chrg_incl_tax_ := NVL(total_chrg_incl_tax_, 0);      
   END IF;
   RETURN ROUND(total_chrg_incl_tax_, rounding_);
END Get_Total_Charge_Amnt_Incl_Tax;


-- Get_Total_Base_Amnt_Incl_Tax
--   Calculates the total charged amount incl tax in base currency using base charged
--   amount incl tax.
@UncheckedAccess
FUNCTION Get_Total_Base_Amnt_Incl_Tax (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   total_base_amnt_incl_tax_ NUMBER;
   rounding_                 NUMBER;
   charge_rec_               Public_Rec;
BEGIN
   IF Order_Quotation_API.Get_Use_Price_Incl_Tax_Db(quotation_no_) = 'FALSE' THEN
      total_base_amnt_incl_tax_ := Get_Total_Base_Charged_Amount(quotation_no_, quotation_charge_no_) + Get_Total_Tax_Amount_Base(quotation_no_, quotation_charge_no_);
   ELSE
      charge_rec_ := Get(quotation_no_, quotation_charge_no_);
      rounding_   := Currency_Code_API.Get_Currency_Rounding(charge_rec_.company, Company_Finance_API.Get_Currency_Code(charge_rec_.company));
      total_base_amnt_incl_tax_ := ROUND((Get_Total_Charge_Amnt_Incl_Tax(quotation_no_, quotation_charge_no_) *  charge_rec_.currency_rate), rounding_);
   END IF;   
   RETURN NVL(total_base_amnt_incl_tax_, 0);
END Get_Total_Base_Amnt_Incl_Tax;


-- Get_Total_Base_Charged_Amount
--   Calculates the total charged amount in base currency using base charged
--   amount and charged quantity.
@UncheckedAccess
FUNCTION Get_Total_Base_Charged_Amount (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   total_base_charged_amount_ NUMBER;
   rounding_                  NUMBER;
   charge_rec_                Public_Rec;
BEGIN
   IF Order_Quotation_API.Get_Use_Price_Incl_Tax_Db(quotation_no_) = 'FALSE' THEN
      charge_rec_ := Get(quotation_no_, quotation_charge_no_);
      rounding_   := Currency_Code_API.Get_Currency_Rounding(charge_rec_.company, Company_Finance_API.Get_Currency_Code(charge_rec_.company));
   -- The base amount needed to be derived from cuur amount like in the invoice. VIP when charge_amount have many decimals and rounding_ != currency_rounding_.
      total_base_charged_amount_ := ROUND( (Get_Total_Charged_Amount(quotation_no_, quotation_charge_no_) *  charge_rec_.currency_rate), rounding_);
   ELSE
      total_base_charged_amount_ := Get_Total_Base_Amnt_Incl_Tax(quotation_no_, quotation_charge_no_) - Get_Total_Tax_Amount_Base(quotation_no_, quotation_charge_no_);
   END IF;
   RETURN NVL(total_base_charged_amount_, 0);
END Get_Total_Base_Charged_Amount;


-- Get_Total_Base_Charged_Cost
--   Calculate and returns the effective charge cost in base currency
--   depending on the charge cost or percentage and line connection.
@UncheckedAccess
FUNCTION Get_Total_Base_Charged_Cost (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   total_base_charge_cost_ NUMBER;
   rec_                    ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   rounding_               NUMBER;
   currency_code_          VARCHAR2(3);
BEGIN
   rec_           := Get_Object_By_Keys___(quotation_no_, quotation_charge_no_);
   currency_code_ := Company_Finance_API.Get_Currency_Code(rec_.company);
   rounding_      := Currency_Code_API.Get_Currency_Rounding(rec_.company, currency_code_);

   IF (rec_.charge_cost IS NULL) THEN
      IF (rec_.line_no IS NULL) THEN
         total_base_charge_cost_ := rec_.charge_cost_percent * Order_Quotation_API.Get_Total_Base_Price(quotation_no_) / 100;
      ELSE
         total_base_charge_cost_ := rec_.charge_cost_percent * Order_Quotation_Line_API.Get_Base_Sale_Price_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no) / 100;
      END IF;
   ELSE
      total_base_charge_cost_ := rec_.charge_cost * rec_.charged_qty;
   END IF;
   RETURN ROUND(NVL(total_base_charge_cost_, 0), rounding_);
END Get_Total_Base_Charged_Cost;


-- Get_Charge_Type_Desc
--   Gets charge type description in quotation language if possible
@UncheckedAccess
FUNCTION Get_Charge_Type_Desc (
   contract_     IN VARCHAR2,
   quotation_no_ IN VARCHAR2,
   charge_type_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   language_code_    VARCHAR2(2);
   charge_desc_lang_ VARCHAR2(35);
BEGIN
   language_code_    := Order_Quotation_API.Get_Language_Code(quotation_no_);
   charge_desc_lang_ := Sales_Charge_Type_Desc_API.Get_Charge_Type_Desc(contract_, charge_type_, language_code_);
   -- show language specific description if possible
   IF (charge_desc_lang_ IS NOT NULL) THEN
      RETURN charge_desc_lang_;
   ELSE
      RETURN Sales_Charge_Type_API.Get_Charge_Type_Desc(contract_, charge_type_);
   END IF;
END Get_Charge_Type_Desc;


-- Get_Charge_Group_Desc
--   Gets charge group description in quotation language if possible
@UncheckedAccess
FUNCTION Get_Charge_Group_Desc (
   contract_     IN VARCHAR2,
   quotation_no_ IN VARCHAR2,
   charge_type_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   language_code_     VARCHAR2(2);
   charge_desc_lang_  VARCHAR2(35);
   charge_group_      VARCHAR2(25);
BEGIN
   charge_group_     := Sales_Charge_Type_API.Get_Charge_Group(contract_, charge_type_);
   language_code_    := Order_Quotation_API.Get_Language_Code(quotation_no_);
   charge_desc_lang_ := Sales_Charge_Group_Desc_API.Get_Charge_Group_Desc(language_code_, charge_group_);
   -- show language specific description if possible
   IF (charge_desc_lang_ IS NOT NULL) THEN
      RETURN charge_desc_lang_;
   ELSE
      RETURN Sales_Charge_Group_API.Get_Charge_Group_Desc(charge_group_);
   END IF;
END Get_Charge_Group_Desc;

-- Remove_Tax_Lines
--   Removes the tax lines for all charges connected to the bypassed quotation.
PROCEDURE Remove_Tax_Lines (
   quotation_no_ IN VARCHAR2 )
IS
   CURSOR get_quote_charge_no IS
      SELECT quotation_charge_no, company
      FROM ORDER_QUOTATION_CHARGE_TAB
      WHERE quotation_no = quotation_no_
      AND line_no IS NULL
      AND rel_no IS NULL
      AND line_item_no IS NULL;
BEGIN
   FOR rec_ IN get_quote_charge_no LOOP
      Remove_Transaction_Tax_Info___(rec_.company, quotation_no_, rec_.quotation_charge_no);
   END LOOP;
END Remove_Tax_Lines;


-- Remove_Tax_Lines
--   Removes the tax lines for all charges connected to the bypassed quotation.
PROCEDURE Remove_Tax_Lines (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER)
IS
   company_             VARCHAR2(20); 
BEGIN
   company_   := Get_Company(quotation_no_, quotation_charge_no_);
   Remove_Transaction_Tax_Info___(company_, quotation_no_, quotation_charge_no_);

END Remove_Tax_Lines;


-- Remove_Tax_Lines
--   Removes the tax lines for all charges connected to the bypassed quotation line.
PROCEDURE Remove_Tax_Lines (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   CURSOR get_quote_charge_no IS
      SELECT quotation_charge_no, company
      FROM ORDER_QUOTATION_CHARGE_TAB
      WHERE quotation_no = quotation_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;
BEGIN
   FOR rec_ IN get_quote_charge_no LOOP
      Remove_Transaction_Tax_Info___(rec_.company, quotation_no_, rec_.quotation_charge_no);
   END LOOP;
END Remove_Tax_Lines;


PROCEDURE Remove_Transaction_Tax_Info___ (
   company_                IN VARCHAR2,
   quotation_no_           IN VARCHAR2,
   quotation_charge_no_    IN VARCHAR2 )
IS   
BEGIN
   Source_Tax_Item_Order_API.Remove_Tax_Items(company_,
                                              Tax_Source_API.DB_ORDER_QUOTATION_CHARGE,
                                              quotation_no_,
                                              quotation_charge_no_,
                                              '*',
                                              '*',
                                              '*');
END Remove_Transaction_Tax_Info___;

-- Transfer_To_Order
--   Transfer quotation charge to customer order
PROCEDURE Transfer_To_Order (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER,
   con_order_no_        IN VARCHAR2 )
IS
   rec_           ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   attr_          VARCHAR2(32000);
   info_          VARCHAR2(2000);
   sequence_no_   CUSTOMER_ORDER_CHARGE_TAB.sequence_no%TYPE;
   currency_rate_ NUMBER;
   linerec_ Order_Quotation_Line_API.Public_Rec;
   tax_method_    VARCHAR2(50);
BEGIN
   rec_ := Get_Object_By_Keys___( quotation_no_, quotation_charge_no_ );

   Customer_Order_Pricing_API.Get_Base_Price_In_Currency(rec_.base_charge_amount,
                                                         currency_rate_,
                                                         nvl(Order_Quotation_API.Get_Customer_No_Pay(rec_.quotation_no), Order_Quotation_API.Get_Customer_No(rec_.quotation_no)),
                                                         rec_.contract,
                                                         Order_Quotation_API.Get_Currency_Code(rec_.quotation_no),
                                                         rec_.charge_amount);

   Customer_Order_Pricing_API.Get_Base_Price_In_Currency(rec_.base_charge_amt_incl_tax,
                                                         currency_rate_,
                                                         nvl(Order_Quotation_API.Get_Customer_No_Pay(rec_.quotation_no), Order_Quotation_API.Get_Customer_No(rec_.quotation_no)),
                                                         rec_.contract,
                                                         Order_Quotation_API.Get_Currency_Code(rec_.quotation_no),
                                                         rec_.charge_amount_incl_tax);
   
   IF ( Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(rec_.contract, rec_.Charge_Type) NOT IN ('FREIGHT', 'PROMOTION')) THEN
      Client_SYS.Clear_Attr( attr_ );
      -- Get default values
      Client_SYS.Add_To_Attr('ORDER_NO', con_order_no_, attr_ );
      Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_ );
      Client_SYS.Add_To_Attr('CHARGE_TYPE', rec_.charge_type, attr_ );
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT', rec_.charge_amount, attr_ );
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', rec_.charge_amount_incl_tax, attr_ );
      Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT', rec_.base_charge_amount, attr_ );
      Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', rec_.base_charge_amt_incl_tax, attr_ );
      Client_SYS.Add_To_Attr('CHARGE_PERCENT_BASIS', rec_.charge_percent_basis, attr_);
      Client_SYS.Add_To_Attr('CHARGE_COST', rec_.charge_cost, attr_ );
      Client_SYS.Add_To_Attr('CHARGE_COST_PERCENT', rec_.charge_cost_percent, attr_ );
      Client_SYS.Add_To_Attr('CHARGE', rec_.charge, attr_ );
      Client_SYS.Add_To_Attr('CHARGED_QTY', rec_.charged_qty, attr_ );
      Client_SYS.Add_To_Attr('SALES_UNIT_MEAS', rec_.sales_unit_meas, attr_ );
      Client_SYS.Add_To_Attr('TAX_CODE', rec_.tax_code, attr_ );
      Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB', rec_.print_charge_type, attr_ );
      Client_SYS.Add_To_Attr('COMPANY', rec_.company, attr_ );
      Client_SYS.Add_To_Attr('NOTE_ID', rec_.note_id, attr_ );
      Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', rec_.intrastat_exempt, attr_);
      Client_SYS.Add_To_Attr('UNIT_CHARGE_DB', rec_.unit_charge, attr_);
      Client_SYS.Add_To_Attr('CHARGE_PRICE_LIST_NO', rec_.charge_price_list_no, attr_);
   
      Client_SYS.Add_To_Attr('DELIVERY_TYPE', rec_.delivery_type, attr_ );
      Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', rec_.customer_tax_usage_type, attr_ );
   
      IF rec_.line_no IS NOT NULL THEN
         -- Get connected line_no, rel_no and line_item_no
         linerec_ := Order_Quotation_Line_API.Get( quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no );
         Client_SYS.Add_To_Attr('LINE_NO', linerec_.con_line_no, attr_ );
         Client_SYS.Add_To_Attr('REL_NO', linerec_.con_rel_no, attr_ );
         Client_SYS.Add_To_Attr('LINE_ITEM_NO', linerec_.con_line_item_no, attr_ );
      END IF;
   
      Client_SYS.Add_To_Attr('TAX_CODE', rec_.tax_code, attr_);
      Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 'TRUE',  attr_);
      Client_SYS.Add_To_Attr('TAX_CALC_STRUCTURE_ID', rec_.tax_calc_structure_id, attr_);
      Client_SYS.Add_To_Attr('FROM_ORDER_QUOTATION', 'TRUE', attr_);
      Client_SYS.Add_To_Attr('QUOTATION_NO', quotation_no_, attr_); 
      Client_SYS.Add_To_Attr('QUOTATION_CHARGE_NO', quotation_charge_no_, attr_);
      
      tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(rec_.company);
      IF tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX THEN
         Client_SYS.Add_To_Attr('UPDATE_TAX', 'FALSE', attr_);
      END IF;
   
      Customer_Order_Charge_API.New( info_, attr_ );                                                
   END IF;
END Transfer_To_Order;

-- Transfer_To_Order_Line
--   Transfer quotation charge to customer order line
PROCEDURE Transfer_To_Order_Line (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER,
   con_order_no_        IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   rec_           ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   attr_          VARCHAR2(32000);
   info_          VARCHAR2(2000);
   tax_method_    VARCHAR2(50);
BEGIN
   rec_ := Get_Object_By_Keys___( quotation_no_, quotation_charge_no_ );

   Client_SYS.Clear_Attr( attr_ );
   -- Get default values
   Client_SYS.Add_To_Attr('ORDER_NO', con_order_no_, attr_ );
   Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_ );
   Client_SYS.Add_To_Attr('CHARGE_TYPE', rec_.charge_type, attr_ );
   Client_SYS.Add_To_Attr('CHARGE_AMOUNT', rec_.charge_amount, attr_ );
   Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', rec_.charge_amount_incl_tax, attr_ );
   Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT', rec_.base_charge_amount, attr_ );
   Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', rec_.base_charge_amt_incl_tax, attr_ );
   Client_SYS.Add_To_Attr('CHARGE_PERCENT_BASIS', rec_.charge_percent_basis, attr_);
   Client_SYS.Add_To_Attr('CHARGE', rec_.charge, attr_ );
   Client_SYS.Add_To_Attr('CHARGE_COST', rec_.charge_cost, attr_ );
   Client_SYS.Add_To_Attr('CHARGE_COST_PERCENT', rec_.charge_cost_percent, attr_ );
   Client_SYS.Add_To_Attr('CHARGED_QTY', rec_.charged_qty, attr_ );
   Client_SYS.Add_To_Attr('SALES_UNIT_MEAS', rec_.sales_unit_meas, attr_ );
   Client_SYS.Add_To_Attr('TAX_CODE', rec_.tax_code, attr_ );
   Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB', rec_.print_charge_type, attr_ );
   Client_SYS.Add_To_Attr('COMPANY', rec_.company, attr_ );
   Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', rec_.intrastat_exempt, attr_);
   Client_SYS.Add_To_Attr('UNIT_CHARGE_DB', rec_.unit_charge, attr_);
   Client_SYS.Add_To_Attr('CHARGE_PRICE_LIST_NO', rec_.charge_price_list_no, attr_);
   Client_SYS.Add_To_Attr('NOTE_ID', rec_.note_id, attr_ );
   Client_SYS.Add_To_Attr('DELIVERY_TYPE', rec_.delivery_type, attr_ );
   Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', rec_.customer_tax_usage_type, attr_ );

   IF line_no_ IS NOT NULL THEN
      -- Get connected line_no, rel_no and line_item_no
      Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_ );
      Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_ );
      Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_ );
   END IF;
   Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 'TRUE',  attr_);
   Client_SYS.Add_To_Attr('TAX_CALC_STRUCTURE_ID', rec_.tax_calc_structure_id, attr_);     
   Client_SYS.Add_To_Attr('FROM_ORDER_QUOTATION', 'TRUE', attr_); 
   Client_SYS.Add_To_Attr('QUOTATION_NO', quotation_no_, attr_); 
   Client_SYS.Add_To_Attr('QUOTATION_CHARGE_NO', quotation_charge_no_, attr_);
   
   tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(rec_.company);
   IF tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX THEN
      Client_SYS.Add_To_Attr('UPDATE_TAX', 'FALSE', attr_);
   END IF;

   Customer_Order_Charge_API.New( info_, attr_ );
   
END Transfer_To_Order_Line;


-- Modify
--   Public interface to modify a new charge line.
PROCEDURE Modify (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER,
   attr_                IN VARCHAR2 )
IS
   objid_       ORDER_QUOTATION_CHARGE.objid%TYPE;
   objversion_  ORDER_QUOTATION_CHARGE.objversion%TYPE;
   oldrec_      ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   newrec_      ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   new_attr_    VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   new_attr_ := attr_;
   Get_Id_Version_By_Keys___ (objid_, objversion_, quotation_no_, quotation_charge_no_);
   oldrec_   := Lock_By_Id___(objid_, objversion_);
   newrec_   := oldrec_;
   Unpack___(newrec_, indrec_, new_attr_);
   Check_Update___(oldrec_, newrec_, indrec_, new_attr_);
   Update___(objid_, oldrec_, newrec_, new_attr_, objversion_);
END Modify;


-- Add_Transaction_Tax_Info
--   Called from ORDER_QUOTATION_API and ORDER_QUOTATION_LINE_API. To add all
--   tax lines, when changing the pay tax of an order quotation or 
--   an order quotation line connected to a charge line.
PROCEDURE Add_Transaction_Tax_Info (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS   
   CURSOR get_line_rec IS
      SELECT *
      FROM  ORDER_QUOTATION_CHARGE_TAB
      WHERE quotation_no = quotation_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;

   CURSOR get_unconnected_line_rec IS
      SELECT *
      FROM  ORDER_QUOTATION_CHARGE_TAB
      WHERE quotation_no = quotation_no_
      AND   line_no is null
      AND   rel_no is null
      AND   line_item_no is NULL;
      
   CURSOR get_taxable_charge_line_rec IS  
      SELECT t1.* 
      FROM  ORDER_QUOTATION_CHARGE_TAB t1, ORDER_QUOTATION_LINE_TAB t2
      WHERE t1.quotation_no = t2.quotation_no
      AND   t1.line_no = t2.line_no
      AND   t1.rel_no = t2.rel_no
      AND   t1.line_item_no = t2.line_item_no
      AND   Sales_Charge_Type_API.Get_Taxable_Db(t1.contract, t1.charge_type) = 'TRUE'
      AND   Sales_Part_API.Get_Taxable_Db(t2.contract, t2.catalog_no) = 'FALSE'
      AND   t1.tax_class_id IS NULL 
      AND   Order_Quotation_Charge_API.Get_Conn_Tax_Liability_Type_Db(t1.quotation_no, t1.line_no, t1.rel_no , t1.line_item_no) = 'EXM'
      AND   t2.tax_liability_type = 'EXM'
      AND   t1.quotation_no = quotation_no_;

BEGIN
   IF (line_no_ IS NULL AND rel_no_ IS NULL AND line_item_no_ IS NULL) THEN
      FOR rec_ IN get_unconnected_line_rec LOOP
         Add_Transaction_Tax_Info___(newrec_ => rec_,
                                     tax_from_defaults_ => TRUE,
                                     add_tax_lines_ => TRUE,
                                     attr_ => NULL);   
      END LOOP;
      
      FOR rec_ IN get_taxable_charge_line_rec LOOP
         Add_Transaction_Tax_Info___(newrec_ => rec_,
                                     tax_from_defaults_ => TRUE,
                                     add_tax_lines_ => TRUE,
                                     attr_ => NULL);   
      END LOOP;
   ELSE
      FOR rec_ IN get_line_rec LOOP
         Add_Transaction_Tax_Info___(newrec_ => rec_,
                                     tax_from_defaults_ => TRUE,
                                     add_tax_lines_ => TRUE,
                                     attr_ => NULL);   
      END LOOP;
   END IF;
END Add_Transaction_Tax_Info;


-- Get_Total_Charge_Tax_Pct
--   This method returns the total tax percentage for a particular charge line.
@UncheckedAccess
FUNCTION Get_Total_Charge_Tax_Pct (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   charge_rec_             ORDER_QUOTATION_CHARGE_API.Public_Rec;
   tax_percentage_         NUMBER;
BEGIN
   charge_rec_           := Order_Quotation_Charge_API.Get(quotation_no_, quotation_charge_no_);
   tax_percentage_       := Source_Tax_Item_API.Get_Total_Tax_Percentage(charge_rec_.company, Tax_Source_API.DB_ORDER_QUOTATION_CHARGE,quotation_no_, TO_CHAR(quotation_charge_no_), '*', '*', '*');
   RETURN tax_percentage_;
END Get_Total_Charge_Tax_Pct;


-- Copy_From_Sales_Part_Charge
--   For a given contract this adds default charges to sales part.
PROCEDURE Copy_From_Sales_Part_Charge (
   quotation_no_  IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER )
IS
   quotation_rec_       Order_Quotation_API.Public_Rec;
   quotation_line_rec_  Order_Quotation_Line_API.Public_Rec;
   charge_type_rec_     Sales_Charge_Type_API.Public_Rec;
   charge_amount_       NUMBER;
   charge_amt_incl_tax_ NUMBER;
   curr_rate_           NUMBER;

   newrec_              ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   objid_               VARCHAR2(100);
   objversion_          VARCHAR2(100);

   charge_tab_          Sales_Part_Charge_API.Sales_Part_Charge_Table;
   attr_                VARCHAR2(32000);
   indrec_              Indicator_Rec;
BEGIN

   quotation_rec_       := Order_Quotation_API.Get(quotation_no_);
   quotation_line_rec_  := Order_Quotation_Line_API.Get(quotation_no_,line_no_,rel_no_,line_item_no_);
   
   IF (quotation_line_rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      RETURN;
   END IF;
   
   charge_tab_          := Sales_Part_Charge_API.Get_Default_Charges(quotation_rec_.customer_no,
                                                                     quotation_line_rec_.catalog_no,
                                                                     quotation_line_rec_.contract);
   IF charge_tab_.COUNT>0 THEN
      FOR i_ IN charge_tab_.FIRST .. charge_tab_.LAST LOOP
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amount_,
                                                             curr_rate_,
                                                             quotation_rec_.customer_no,
                                                             quotation_line_rec_.contract,
                                                             quotation_rec_.currency_code,
                                                             charge_tab_(i_).charge_amount);

         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amt_incl_tax_,
                                                             curr_rate_,
                                                             quotation_rec_.customer_no,
                                                             quotation_line_rec_.contract,
                                                             quotation_rec_.currency_code,
                                                             charge_tab_(i_).charge_amount_incl_tax);

         charge_type_rec_  := Sales_Charge_Type_API.Get(quotation_line_rec_.contract,charge_tab_(i_).charge_type);

         Client_SYS.Clear_Attr(attr_);

         Client_SYS.Add_To_Attr('QUOTATION_NO',             quotation_no_,                            attr_);
         Client_SYS.Add_To_Attr('CHARGE_AMOUNT',            charge_amount_,                           attr_);
         Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',   charge_amt_incl_tax_,                     attr_);
         Client_SYS.Add_To_Attr('CHARGE',                   charge_tab_(i_).charge,                   attr_);
         Client_SYS.Add_To_Attr('CHARGED_QTY',              charge_tab_(i_).charged_qty,              attr_);
         Client_SYS.Add_To_Attr('SALES_UNIT_MEAS',          charge_type_rec_.sales_unit_meas,         attr_);
         Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT',       charge_tab_(i_).charge_amount,            attr_);
         Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', charge_tab_(i_).charge_amount_incl_tax,   attr_);
         Client_SYS.Add_To_Attr('CHARGE_COST',              charge_tab_(i_).charge_cost,              attr_);
         Client_SYS.Add_To_Attr('CHARGE_COST_PERCENT',      charge_tab_(i_).charge_cost_percent,      attr_);
         Client_SYS.Add_To_Attr('CHARGE_COST',              charge_tab_(i_).charge_cost,              attr_);
         Client_SYS.Add_To_Attr('LINE_NO',                  line_no_,                                 attr_);
         Client_SYS.Add_To_Attr('REL_NO',                   rel_no_,                                  attr_);
         Client_SYS.Add_To_Attr('LINE_ITEM_NO',             line_item_no_,                            attr_);
         Client_SYS.Add_To_Attr('CHARGE_TYPE',              charge_tab_(i_).charge_type,              attr_);
         Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB',     charge_tab_(i_).print_charge_type,        attr_);
         Client_SYS.Add_To_Attr('CONTRACT',                 quotation_line_rec_.contract,             attr_);
         Client_SYS.Add_To_Attr('COMPANY',                  quotation_line_rec_.company,              attr_);
         Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB',      charge_tab_(i_).intrastat_exempt,         attr_);
         Client_SYS.Add_To_Attr('UNIT_CHARGE_DB',           charge_tab_(i_).unit_charge,              attr_);
         Client_SYS.Add_To_Attr('DELIVERY_TYPE',            charge_type_rec_.delivery_type,           attr_);
         Client_SYS.Add_To_Attr('CURRENCY_RATE',            curr_rate_,                               attr_);

         Reset_Indicator_Rec___(indrec_);
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);         
         Insert___(objid_, objversion_, newrec_, attr_);
      END LOOP;
   END IF;
END Copy_From_Sales_Part_Charge;


-- New
--   Public interface for creating a new charge line.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   newrec_      ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   charge_type_ ORDER_QUOTATION_CHARGE_TAB.charge_type%TYPE;
   contract_    ORDER_QUOTATION_CHARGE_TAB.contract%TYPE;
   indrec_      Indicator_Rec;
BEGIN
   IF (Client_SYS.Get_Item_Value('DELIVERY_TYPE', attr_) IS NULL) THEN
      charge_type_ := Client_SYS.Get_Item_Value('CHARGE_TYPE', attr_);
      contract_    := Client_SYS.Get_Item_Value('CONTRACT', attr_);
      IF ((charge_type_ IS NOT NULL) AND (contract_ IS NOT NULL)) THEN
         Client_SYS.Add_To_Attr('DELIVERY_TYPE', Sales_Charge_Type_API.Get_Delivery_Type(contract_, charge_type_), attr_);
       END IF;
   END IF;
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Copy_From_Customer_Charge
--   For a given contract this adds default charges to customer.
PROCEDURE Copy_From_Customer_Charge (
   customer_no_  IN VARCHAR2,
   contract_     IN VARCHAR2,
   quotation_no_ IN VARCHAR2 )
IS
   attr_                   VARCHAR2(32000);
   charge_tab_             Customer_Charge_API.Customer_Charge_Table;
   charge_amount_          NUMBER;
   charge_amount_incl_tax_ NUMBER;
   curr_rate_              NUMBER;
   currency_code_          CUSTOMER_ORDER_TAB.currency_code%TYPE;
   rec_                    Sales_Charge_Type_API.Public_Rec;
   newrec_                 ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   objid_                  VARCHAR2(100);
   objversion_             VARCHAR2(100);
   indrec_                 Indicator_Rec;
BEGIN
   charge_tab_    := Customer_Charge_API.Get_Default_Charges(customer_no_, contract_);
   currency_code_ := Order_Quotation_API.Get_Currency_Code(quotation_no_);
   IF (charge_tab_.COUNT >0) THEN
      FOR i_ IN charge_tab_.FIRST..charge_tab_.LAST LOOP
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amount_,
                                                                curr_rate_,
                                                                customer_no_,
                                                                contract_,
                                                                currency_code_,
                                                                charge_tab_(i_).charge_amount_base);
         
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amount_incl_tax_,
                                                                curr_rate_,
                                                                customer_no_,
                                                                contract_,
                                                                currency_code_,
                                                                charge_tab_(i_).charge_amt_incl_tax_base);
         
         rec_      := Sales_Charge_Type_API.Get(contract_,charge_tab_(i_).charge_type);
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('QUOTATION_NO', quotation_no_, attr_ );
         Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_ );
         Client_SYS.Add_To_Attr('CHARGE_TYPE', charge_tab_(i_).charge_type, attr_);
         Client_SYS.Add_To_Attr('CHARGE_AMOUNT', charge_amount_, attr_ );
         Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', charge_amount_incl_tax_, attr_ );
         Client_SYS.Add_To_Attr('CHARGE', charge_tab_(i_).charge, attr_ );
         Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT', charge_tab_(i_).charge_amount_base, attr_ );
         Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', charge_tab_(i_).charge_amt_incl_tax_base, attr_ );
         Client_SYS.Add_To_Attr('CHARGED_QTY', charge_tab_(i_).charged_qty, attr_ );
         Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB', charge_tab_(i_).print_charge_type, attr_ );
         Client_SYS.Add_To_Attr('CHARGE_COST', charge_tab_(i_).charge_cost, attr_);
         Client_SYS.Add_To_Attr('CHARGE_COST_PERCENT', charge_tab_(i_).charge_cost_percent, attr_);
         Client_SYS.Add_To_Attr('CHARGE_COST', charge_tab_(i_).charge_cost, attr_ );
         Client_SYS.Add_To_Attr('SALES_UNIT_MEAS', rec_.sales_unit_meas, attr_ );
         Client_SYS.Add_To_Attr('COMPANY', rec_.company, attr_ );
         Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', charge_tab_(i_).intrastat_exempt, attr_);
         Client_SYS.Add_To_Attr('UNIT_CHARGE_DB', rec_.unit_charge, attr_ );
         Client_SYS.Add_To_Attr('DELIVERY_TYPE', rec_.delivery_type, attr_);
         Client_SYS.Add_To_Attr('CURRENCY_RATE', curr_rate_, attr_);

         Reset_Indicator_Rec___(indrec_);
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END LOOP;
   END IF;
END Copy_From_Customer_Charge;


-- Update_Connected_Charged_Qty
--   This method will update the connected charged for a given CO line,
--   with the given qty. This is used to synchonise the quantities for unit charges
PROCEDURE Update_Connected_Charged_Qty (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER,
   charged_qty_  IN NUMBER )
IS
   CURSOR get_attr IS
      SELECT quotation_charge_no
      FROM  ORDER_QUOTATION_CHARGE_TAB
      WHERE quotation_no = quotation_no_
      AND   line_no      = line_no_
      AND   rel_no       = release_no_
      AND   line_item_no = line_item_no_
      AND   unit_charge  ='TRUE';

   attr_          VARCHAR2(2000);
   newrec_        ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   oldrec_        ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   indrec_        Indicator_Rec;
BEGIN
   FOR rec_ IN get_attr LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CHARGED_QTY', charged_qty_, attr_);

      Get_Id_Version_By_Keys___ ( objid_, objversion_, quotation_no_, rec_.quotation_charge_no);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Reset_Indicator_Rec___(indrec_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END LOOP;
END Update_Connected_Charged_Qty;


-- Get_Total_Tax_Amount
--   This function returns total tax amount in customer currency.
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   total_tax_amount_    NUMBER :=0;
   rounding_            NUMBER;
   company_             VARCHAR2(20); 
   
BEGIN 
   
   company_          := Get_Company(quotation_no_, quotation_charge_no_);
   rounding_         := Currency_Code_API.Get_Currency_Rounding(company_,
                                                                Order_Quotation_API.Get_Currency_Code(quotation_no_));
   total_tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Curr_Amount(company_, 
                                                                      Tax_Source_API.DB_ORDER_QUOTATION_CHARGE,
                                                                      quotation_no_,
                                                                      TO_CHAR(quotation_charge_no_),
                                                                      '*',
                                                                      '*',
                                                                      '*');
   total_tax_amount_ := ROUND(total_tax_amount_, rounding_);
   RETURN total_tax_amount_;
END Get_Total_Tax_Amount ;


-- Get_Total_Tax_Amount_Base
--    This function returns total tax amount in base currency.
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount_Base (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   company_             VARCHAR2(20);
   tax_amount_          NUMBER := 0;
   rounding_            NUMBER;

   CURSOR get_line_detail IS
      SELECT company
      FROM   ORDER_QUOTATION_CHARGE_TAB
      WHERE  quotation_no        = quotation_no_
      AND    quotation_charge_no = quotation_charge_no_;

BEGIN
   OPEN get_line_detail;
   FETCH get_line_detail INTO company_;
   CLOSE get_line_detail;

   rounding_            := Currency_Code_API.Get_Currency_Rounding(company_, Order_Quotation_API.Get_Currency_Code(quotation_no_)); 
   tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Dom_Amount(company_, 
                                                               Tax_Source_API.DB_ORDER_QUOTATION_CHARGE,
                                                               quotation_no_,
                                                               TO_CHAR(quotation_charge_no_),
                                                               '*',
                                                               '*',
                                                               '*');
   tax_amount_ := ROUND(tax_amount_, rounding_);                                                             
   RETURN tax_amount_;
END Get_Total_Tax_Amount_Base;


-- Get_Gross_Amount_For_Col
--   This function returns Gross Charge amount connected to a Customer Quotation
--   Line in customer currency.
@UncheckedAccess
FUNCTION Get_Gross_Amount_For_Col (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   tot_amount_       NUMBER;
   tax_amount_       NUMBER;
   gross_amount_     NUMBER;
   tot_gross_amount_ NUMBER;

   check_null_       VARCHAR2(15) := Database_SYS.String_null_;

   CURSOR get_charges_connected_to_quo IS
      SELECT quotation_charge_no
        FROM order_quotation_charge_tab
       WHERE quotation_no = quotation_no_
         AND NVL(line_no,check_null_) = line_no_
         AND NVL(rel_no,check_null_) = rel_no_
         AND NVL(line_item_no,-9999999) = line_item_no;
BEGIN
   tot_gross_amount_ := 0;
   FOR chg_ IN get_charges_connected_to_quo LOOP
      tot_amount_       := Get_Total_Charged_Amount(quotation_no_,chg_.quotation_charge_no);
      tax_amount_       := Get_Total_Tax_Amount(quotation_no_,chg_.quotation_charge_no);
      gross_amount_     := tot_amount_ + tax_amount_;
      tot_gross_amount_ := tot_gross_amount_ +gross_amount_;
   END LOOP;
   RETURN tot_gross_amount_;
END Get_Gross_Amount_For_Col;


-- Get_Pack_Size_Chg_Line_Quot_No
--   This method returns quotation charge no of a SQ charge line which is connected to SQ line
--   and sales charge type category is PACK SIZE.
@UncheckedAccess
FUNCTION Get_Pack_Size_Chg_Line_Quot_No (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   quotation_charge_no_   NUMBER;
   CURSOR get_quot_chg_no IS
      SELECT quotation_charge_no
      FROM   order_quotation_charge_tab oqc, sales_charge_type_tab sct
      WHERE  oqc.quotation_no = quotation_no_
      AND    oqc.line_no      = line_no_
      AND    oqc.rel_no       = rel_no_
      AND    oqc.line_item_no = line_item_no_
      AND    oqc.charge_type = sct.charge_type
      AND    oqc.charge_price_list_no IS NOT NULL
      AND    sct.sales_chg_type_category = 'PACK_SIZE';
BEGIN
   OPEN get_quot_chg_no;
   FETCH get_quot_chg_no INTO quotation_charge_no_;
   CLOSE get_quot_chg_no;
   RETURN quotation_charge_no_;
END Get_Pack_Size_Chg_Line_Quot_No;


-- Exist_Charge_On_Quot_Line
--   Check for the existence of a charge line for an order quotation line.
@UncheckedAccess
FUNCTION Exist_Charge_On_Quot_Line (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   dummy_      NUMBER;
   CURSOR check_charge IS
      SELECT 1
      FROM   ORDER_QUOTATION_CHARGE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   OPEN check_charge;
   FETCH check_charge INTO dummy_;
   CLOSE check_charge;
   RETURN (NVL(dummy_,0));
END Exist_Charge_On_Quot_Line;


-- Remove
--   Public interface for removing an charge line.
PROCEDURE Remove (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER,
   allow_promo_del_     IN BOOLEAN DEFAULT FALSE )
IS
   remrec_     ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(quotation_no_, quotation_charge_no_);
   Check_Delete___(remrec_, allow_promo_del_);
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, quotation_charge_no_);
   Delete___(objid_, remrec_);
END Remove;


-- Copy_Quote_Line_Tax_Lines
--   This method copy all connected tax lines from specified quotation line
--   to the PACK SIZE charge line which is connected to same quotation line.
PROCEDURE Copy_Quote_Line_Tax_Lines (
   company_           IN VARCHAR2,
   quotation_no_      IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   to_quot_charge_no_ IN NUMBER )
IS
   attr_    VARCHAR2(2000);
BEGIN
   -- Copy all tax lines to charge line 
   Tax_Handling_Order_Util_API.Transfer_Tax_lines(company_, Tax_Source_API.DB_ORDER_QUOTATION_LINE, quotation_no_, line_no_, rel_no_, line_item_no_, '*', Tax_Source_API.DB_ORDER_QUOTATION_CHARGE, quotation_no_, to_quot_charge_no_, '*', '*', '*', 'TRUE', 'TRUE');
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('TAX_CODE', '', attr_);
   Modify_Fee_Code__(attr_, quotation_no_, to_quot_charge_no_);
END Copy_Quote_Line_Tax_Lines;


-- Get_Charge_Percent_Basis
--   Calculate and returns the  base value (in quotation curr) which is used to apply charge percentage on.
@UncheckedAccess
FUNCTION Get_Charge_Percent_Basis (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_               ORDER_QUOTATION_CHARGE_TAB.charge_percent_basis%TYPE;
   use_price_incl_tax_ VARCHAR2(20);
BEGIN
   use_price_incl_tax_ := Order_Quotation_Api.Get_Use_Price_Incl_Tax_Db(quotation_no_);
   IF (use_price_incl_tax_ = 'TRUE') THEN  
      temp_ := Get_Gross_Charge_Percent_Basis(quotation_no_, quotation_charge_no_);    
   ELSE
      temp_ := Get_Net_Charge_Percent_Basis(quotation_no_, quotation_charge_no_);
   END IF;   
   RETURN temp_;
END Get_Charge_Percent_Basis;


-- Get_Net_Charge_Percent_Basis
--   Calculate and returns the  base value (in quotation curr) which is used to apply net charge percentage on.
@UncheckedAccess
FUNCTION Get_Net_Charge_Percent_Basis (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ ORDER_QUOTATION_CHARGE_TAB.charge_percent_basis%TYPE;
   rec_  ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(quotation_no_, quotation_charge_no_);

   IF (rec_.charge_amount IS NULL) THEN
      IF (rec_.charge_percent_basis IS NULL) THEN
         IF (rec_.line_no IS NULL) THEN
            temp_ := Order_Quotation_API.Get_Total_Sale_Price__(quotation_no_);
         ELSE
            temp_ := Order_Quotation_Line_API.Get_Sale_Price_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
         END IF;
         IF rec_.charged_qty != 0 THEN
            temp_ := temp_ / rec_.charged_qty;
         END IF;
      ELSE
         temp_ := rec_.charge_percent_basis;
      END IF;
   END IF;
   RETURN temp_;
END Get_Net_Charge_Percent_Basis;


-- Get_Gross_Charge_Percent_Basis
--   Calculate and returns the  base value (in quotation curr) which is used to apply gross charge percentage on.
@UncheckedAccess
FUNCTION Get_Gross_Charge_Percent_Basis (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ ORDER_QUOTATION_CHARGE_TAB.charge_percent_basis%TYPE;
   rec_  ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(quotation_no_, quotation_charge_no_);

   IF (rec_.charge_amount IS NULL) THEN
      IF (rec_.charge_percent_basis IS NULL) THEN
         IF (rec_.line_no IS NULL) THEN
            temp_ := Order_Quotation_API.Get_Gross_Amount(quotation_no_);
         ELSE
            temp_ := Order_Quotation_Line_API.Get_Sale_Price_Incl_Tax_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
         END IF;
         IF rec_.charged_qty != 0 THEN
            temp_ := temp_ / rec_.charged_qty;
         END IF;
      ELSE
         temp_ := rec_.charge_percent_basis;
      END IF;
   END IF;
   RETURN temp_;
END Get_Gross_Charge_Percent_Basis;


-- Get_Base_Charge_Percent_Basis
--   Calculate and returns the  base value (in base curr) which is used to apply charge percentage on.
@UncheckedAccess
FUNCTION Get_Base_Charge_Percent_Basis (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ ORDER_QUOTATION_CHARGE_TAB.base_charge_percent_basis%TYPE;
   rec_  ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(quotation_no_, quotation_charge_no_);

   IF (rec_.base_charge_amount IS NULL) THEN
      IF (rec_.charge_percent_basis IS NULL) THEN
         IF (rec_.line_no IS NULL) THEN
            temp_ := Order_Quotation_API.Get_Total_Base_Price(quotation_no_);
         ELSE
            temp_ := Order_Quotation_Line_API.Get_Base_Sale_Price_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
         END IF;
         IF rec_.charged_qty != 0 THEN
            temp_ := temp_ / rec_.charged_qty;
         END IF;
      ELSE
         temp_ := rec_.base_charge_percent_basis;
      END IF;
   END IF;

   RETURN temp_;
END Get_Base_Charge_Percent_Basis;


@UncheckedAccess
FUNCTION Get_Freight_Charge_Amount (
   quotation_no_   IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER ) RETURN NUMBER
IS
   charge_group_chg_type_  VARCHAR2(20);
   charge_amt_             NUMBER;

   CURSOR get_lines IS
      SELECT charge_amount, contract, charge_type
      FROM  ORDER_QUOTATION_CHARGE_TAB
      WHERE quotation_no = quotation_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      AND   charge_price_list_no IS NOT NULL;
BEGIN
   FOR rec_ IN get_lines LOOP
      charge_group_chg_type_ := Sales_Charge_Group_API.Get_Sales_Chg_Type_Category_Db(Sales_Charge_Type_API.Get_Charge_Group(rec_.contract, rec_.charge_type));
      IF (charge_group_chg_type_ = Sales_Chg_Type_Category_API.DB_FREIGHT) THEN
         charge_amt_ := rec_.charge_amount;
         EXIT;
      END IF;
   END LOOP;
   RETURN charge_amt_;
END Get_Freight_Charge_Amount;


@UncheckedAccess
FUNCTION Get_Promo_Charged_Qty (
   quotation_no_ IN VARCHAR2,
   campaign_id_  IN NUMBER,
   deal_id_      IN NUMBER ) RETURN NUMBER
IS
   temp_ ORDER_QUOTATION_CHARGE_TAB.charged_qty%TYPE;
   CURSOR get_attr IS
      SELECT sum(charged_qty)
      FROM ORDER_QUOTATION_CHARGE_TAB
      WHERE quotation_no = quotation_no_
      AND   campaign_id = campaign_id_
      AND   deal_id = deal_id_
      GROUP BY quotation_no, campaign_id, deal_id;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN NVL(temp_,0);
END Get_Promo_Charged_Qty;


@UncheckedAccess
FUNCTION Get_Promo_Net_Amount_Curr (
   quotation_no_ IN VARCHAR2,
   campaign_id_  IN NUMBER,
   deal_id_      IN NUMBER ) RETURN NUMBER
IS
   company_         VARCHAR2(20);
   rounding_        NUMBER;
   currency_code_   VARCHAR2(3);   
   net_amount_curr_ NUMBER;

   CURSOR get_attr IS
      SELECT company, sum(charged_qty * charge_amount) 
      FROM ORDER_QUOTATION_CHARGE_TAB
      WHERE quotation_no = quotation_no_
      AND   campaign_id = campaign_id_
      AND   deal_id = deal_id_
      GROUP BY company, quotation_no, campaign_id, deal_id;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO company_, net_amount_curr_;
   CLOSE get_attr;
   currency_code_ := Order_Quotation_API.Get_Currency_Code(quotation_no_);
   rounding_      := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   RETURN NVL(ROUND(net_amount_curr_, rounding_), 0);
END Get_Promo_Net_Amount_Curr;


@UncheckedAccess
FUNCTION Get_Promo_Net_Amount_Base (
   quotation_no_ IN VARCHAR2,
   campaign_id_  IN NUMBER,
   deal_id_      IN NUMBER ) RETURN NUMBER
IS
   rounding_         NUMBER;
   company_          VARCHAR2(20);
   currency_rate_    NUMBER;

   CURSOR get_attr IS
      SELECT company, currency_rate 
      FROM ORDER_QUOTATION_CHARGE_TAB
      WHERE quotation_no = quotation_no_
      AND   campaign_id = campaign_id_
      AND   deal_id = deal_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO company_, currency_rate_;
   CLOSE get_attr;
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   -- Please Note : Since charge_amount (price each) can have as many decimals as you like when curr_rounding_ != rounding_
   -- the base amount needed to be derived from cuur amount like in the invoice. To tally with invoice figures.
   RETURN NVL(ROUND( (Get_Promo_Net_Amount_Curr(quotation_no_, campaign_id_, deal_id_) *  currency_rate_), rounding_),0);
END Get_Promo_Net_Amount_Base;


@UncheckedAccess
FUNCTION Get_Promo_Gross_Amount_Base (
   quotation_no_ IN VARCHAR2,
   campaign_id_  IN NUMBER,
   deal_id_      IN NUMBER ) RETURN NUMBER
IS
   gross_base_amount_   NUMBER;
   gross_curr_amount_   NUMBER; 
BEGIN
   Get_Promo_Amounts(gross_base_amount_, gross_curr_amount_, quotation_no_, campaign_id_, deal_id_);
   RETURN NVL(gross_base_amount_, 0);
END Get_Promo_Gross_Amount_Base;


@UncheckedAccess
FUNCTION Get_Promo_Gross_Amount_Curr (
   quotation_no_ IN VARCHAR2,
   campaign_id_  IN NUMBER,
   deal_id_      IN NUMBER ) RETURN NUMBER
IS
   gross_base_amount_   NUMBER;
   gross_curr_amount_   NUMBER; 
BEGIN
   Get_Promo_Amounts(gross_base_amount_, gross_curr_amount_, quotation_no_, campaign_id_, deal_id_);
   RETURN NVL(gross_curr_amount_, 0);
END Get_Promo_Gross_Amount_Curr;

PROCEDURE Get_Promo_Amounts (
   gross_base_amount_ OUT NUMBER, 
   gross_curr_amount_ OUT NUMBER,
   quotation_no_      IN  VARCHAR2,
   campaign_id_       IN  NUMBER,
   deal_id_           IN  NUMBER ) 
IS
   rounding_            NUMBER;
   company_             ORDER_QUOTATION_CHARGE_TAB.company%TYPE;
   quotation_charge_no_ ORDER_QUOTATION_CHARGE_TAB.quotation_charge_no%TYPE;
   charge_type_         ORDER_QUOTATION_CHARGE_TAB.charge_type%TYPE;
   quoterec_            Order_Quotation_API.Public_Rec;
   tax_dom_amount_    NUMBER := 0;   
   net_base_amount_   NUMBER := 0;
   tax_curr_amount_   NUMBER := 0; 
   net_curr_amount_   NUMBER := 0;
   
   CURSOR get_attr IS
      SELECT quotation_charge_no, company 
      FROM ORDER_QUOTATION_CHARGE_TAB
      WHERE quotation_no = quotation_no_
      AND   campaign_id = campaign_id_
      AND   deal_id = deal_id_;
BEGIN
   quoterec_ := Order_Quotation_API.Get(quotation_no_);
   OPEN get_attr;
   FETCH get_attr INTO quotation_charge_no_, company_;
   CLOSE get_attr;
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, quoterec_.currency_code);
   net_curr_amount_ := NVL(ROUND(Get_Promo_Net_Amount_Curr(quotation_no_, campaign_id_, deal_id_), rounding_), 0);
   Tax_Handling_Order_Util_API.Get_Amounts(tax_dom_amount_, 
                                           net_base_amount_, 
                                           gross_base_amount_, 
                                           tax_curr_amount_, 
                                           net_curr_amount_, 
                                           gross_curr_amount_, 
                                           company_, 
                                           Tax_Source_API.DB_ORDER_QUOTATION_CHARGE, 
                                           quotation_no_, 
                                           quotation_charge_no_, 
                                           NULL, 
                                           NULL,
                                           NULL);        
END Get_Promo_Amounts;


-- Remove_Charge_Lines
--   Remove charge tax lines and charges
PROCEDURE Remove_Charge_Lines (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   CURSOR get_sequence_no IS
      SELECT rowid objid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) objversion
      FROM ORDER_QUOTATION_CHARGE_TAB
      WHERE line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND quotation_no = quotation_no_;
   remrec_ ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
BEGIN
   FOR rec_ IN get_sequence_no LOOP
      -- Remove charge line
      remrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      Check_Delete___(remrec_);
      Delete___(rec_.objid, remrec_);
   END LOOP;
END Remove_Charge_Lines;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Fetch_Tax_Line_Param(   
   company_                IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2) RETURN Tax_Handling_Order_Util_API.tax_line_param_rec
IS
   quoterec_            Order_Quotation_API.Public_Rec;
   charge_rec_          Order_Quotation_Charge_API.Public_Rec;
   tax_line_param_rec_  Tax_Handling_Order_Util_API.tax_line_param_rec;
BEGIN
   quoterec_       := Order_Quotation_API.Get(source_ref1_);
   charge_rec_     := Order_Quotation_Charge_API.Get(source_ref1_, source_ref2_); 
   
   tax_line_param_rec_.company               := company_;
   tax_line_param_rec_.contract              := quoterec_.contract;
   tax_line_param_rec_.customer_no           := quoterec_.customer_no;
   tax_line_param_rec_.ship_addr_no          := Get_Connected_Address_Id__(source_ref1_, source_ref2_);
   tax_line_param_rec_.planned_ship_date     := Get_Conn_Planned_Ship_Date(charge_rec_.quotation_no, charge_rec_.line_no, charge_rec_.rel_no, charge_rec_.line_item_no, quoterec_.contract, quoterec_.wanted_delivery_date);
   tax_line_param_rec_.supply_country_db     := quoterec_.supply_country;
   tax_line_param_rec_.delivery_type         := NVL(charge_rec_.delivery_type, '*');
   tax_line_param_rec_.object_id             := charge_rec_.charge_type;
   tax_line_param_rec_.use_price_incl_tax    := quoterec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code         := quoterec_.currency_code;
   tax_line_param_rec_.currency_rate         := charge_rec_.currency_rate;
   tax_line_param_rec_.tax_liability         := Get_Connected_Tax_Liability(source_ref1_, source_ref2_);
   tax_line_param_rec_.tax_liability_type_db := Get_Conn_Tax_Liability_Type_Db(source_ref1_, source_ref2_);
   tax_line_param_rec_.tax_code              := charge_rec_.tax_code;
   tax_line_param_rec_.tax_calc_structure_id := charge_rec_.tax_calc_structure_id;
   tax_line_param_rec_.tax_class_id          := charge_rec_.tax_class_id;
   tax_line_param_rec_.taxable               := Sales_Charge_Type_API.Get_Taxable_Db(quoterec_.contract, charge_rec_.charge_type);
     
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
BEGIN
   gross_curr_amount_ := Order_Quotation_Charge_API.Get_Total_Charge_Amnt_Incl_Tax(source_ref1_, source_ref2_);
   net_curr_amount_  := Order_Quotation_Charge_API.Get_Total_Charged_Amount(source_ref1_, source_ref2_);
   tax_curr_amount_  := Order_Quotation_Charge_API.Get_Total_Tax_Amount(source_ref1_, source_ref2_);
END Fetch_Gross_Net_Tax_Amounts;


@UncheckedAccess
FUNCTION Get_Conn_Tax_Liability_Type_Db (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER) RETURN VARCHAR2
IS
   tax_liability_type_db_ VARCHAR2(20);
BEGIN
   IF (line_no_ IS NULL) THEN
      tax_liability_type_db_ := Order_Quotation_API.Get_Tax_Liability_Type_Db(quotation_no_);
   ELSE
      tax_liability_type_db_ := Order_Quotation_Line_API.Get_Tax_Liability_Type_Db(quotation_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   
   RETURN tax_liability_type_db_;
END Get_Conn_Tax_Liability_Type_Db;


@UncheckedAccess
FUNCTION Get_Connected_Tax_Liability (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN VARCHAR2
IS
   rec_ Public_Rec;
BEGIN
   rec_ := get (quotation_no_, quotation_charge_no_);
   RETURN Get_Connected_Tax_Liability__(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
END Get_Connected_Tax_Liability;

@UncheckedAccess
FUNCTION Get_Conn_Tax_Liability_Type_Db (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN VARCHAR2
IS
   rec_ Public_Rec;
BEGIN
   rec_ := get (quotation_no_, quotation_charge_no_);
   RETURN Get_Conn_Tax_Liability_Type_Db(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
END Get_Conn_Tax_Liability_Type_Db;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Get_Price_Total (
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Total_Charged_Amount(source_ref1_, source_ref2_);
END Get_Price_Total;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Get_Price_Incl_Tax_Total  (
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Total_Charge_Amnt_Incl_Tax(source_ref1_, source_ref2_);
END Get_Price_Incl_Tax_Total ;

-- Modify_Tax_Info
--   Modifies the tax information with the tax line tax information at the same time.
--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Modify_Tax_Info (
   attr_         IN OUT VARCHAR2,
   source_ref1_  IN VARCHAR2,
   source_ref2_  IN VARCHAR2,
   source_ref3_  IN VARCHAR2,
   source_ref4_  IN VARCHAR2 )
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   oldrec_           ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   newrec_           ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;   
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, source_ref1_, source_ref2_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.tax_code  := Client_Sys.Get_Item_Value('TAX_CODE', attr_);   
   newrec_.tax_class_id := Client_Sys.Get_Item_Value('TAX_CLASS_ID', attr_);
   Client_SYS.Set_Item_Value('TAX_CODE_CHANGED', 'TRUE', attr_);
   newrec_.tax_calc_structure_id  := Client_Sys.Get_Item_Value('TAX_CALC_STRUCTURE_ID', attr_);   
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Tax_Info;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_Tax_Info (
   attr_          OUT VARCHAR2,
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2)
IS
   linerec_                ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
   tax_liability_type_db_  VARCHAR2(20);
   tax_liability_          VARCHAR2(20);
   delivery_country_db_    VARCHAR2(2);
BEGIN
   linerec_        := Get_Object_By_Keys___(source_ref1_, source_ref2_);
   Client_SYS.Set_Item_Value('TAX_CODE', linerec_.tax_code, attr_);
   Client_SYS.Set_Item_Value('TAX_CLASS_ID', linerec_.tax_class_id, attr_);
   
   tax_liability_         := Get_Connected_Tax_Liability(source_ref1_, source_ref2_);
   tax_liability_type_db_ := Get_Conn_Tax_Liability_Type_Db(source_ref1_, source_ref2_);
   delivery_country_db_   := Get_Connected_Deliv_Country(source_ref1_, source_ref2_);
   
   Client_SYS.Set_Item_Value('TAX_LIABILITY', tax_liability_, attr_);   
   Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', tax_liability_type_db_, attr_);   
   Client_SYS.Set_Item_Value('DELIVERY_COUNTRY_DB', delivery_country_db_, attr_);
   Client_SYS.Set_Item_Value('IS_TAXABLE_DB', Sales_Charge_Type_API.Get_Taxable_Db(linerec_.contract, linerec_.charge_type), attr_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY_DATE', TRUNC(Site_API.Get_Site_Date(linerec_.contract)), attr_);
END Get_Tax_Info;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_External_Tax_Info (
   attr_          OUT VARCHAR2,
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2,
   company_       IN VARCHAR2)
IS
   linerec_     ORDER_QUOTATION_CHARGE_TAB%ROWTYPE;
BEGIN
   linerec_  := Get_Object_By_Keys___(source_ref1_, source_ref2_);
   Client_SYS.Set_Item_Value('QUANTITY', linerec_.charged_qty, attr_);   
END Get_External_Tax_Info;


@UncheckedAccess
FUNCTION Get_Connected_Deliv_Country (
   quotation_no_         IN VARCHAR2,
   quotation_charge_no_  IN VARCHAR2) RETURN VARCHAR2
IS
   delivery_country_db_    VARCHAR2(2);   
BEGIN   
   delivery_country_db_ := Get_Connected_Deliv_Country__(quotation_no_, quotation_charge_no_);
   
   RETURN delivery_country_db_;
END Get_Connected_Deliv_Country;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Validate_Source_Pkg_Info (
   source_ref1_  IN VARCHAR2,
   source_ref2_  IN VARCHAR2,
   source_ref3_  IN VARCHAR2,
   source_ref4_  IN VARCHAR2,
   attr_         IN VARCHAR2 )
IS
   charge_rec_                Order_Quotation_Charge_API.Public_Rec; 
   do_additional_validate_    VARCHAR2(5);
   sales_chg_type_category_   VARCHAR2(25);
BEGIN
   do_additional_validate_ := nvl(Client_SYS.Get_Item_Value('DO_ADDITIONAL_VALIDATE', attr_),'FALSE');
   
   IF (do_additional_validate_ = 'TRUE') THEN
      charge_rec_ := Get(source_ref1_, source_ref2_);
      sales_chg_type_category_ := Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(charge_rec_.contract, charge_rec_.charge_type);
      Do_Additional_Validations___(charge_rec_.charge_price_list_no, sales_chg_type_category_);
   END IF;
END Validate_Source_Pkg_Info;


PROCEDURE Recalc_Percentage_Charge_Taxes (
   quotation_no_      IN VARCHAR2,
   line_no_           IN VARCHAR2,
   tax_from_defaults_ IN BOOLEAN)
IS
   CURSOR get_charge IS
      SELECT *
      FROM   ORDER_QUOTATION_CHARGE_TAB
      WHERE  quotation_no  = quotation_no_
      AND    charge IS NOT NULL
      AND    (line_no = line_no_ OR line_no IS NULL);
BEGIN
   FOR rec_ IN get_charge LOOP
      Recalculate_Tax_Lines___(rec_, tax_from_defaults_, NULL);
   END LOOP;
END Recalc_Percentage_Charge_Taxes;


@UncheckedAccess
FUNCTION Get_Conn_Planned_Ship_Date (
   quotation_no_           IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   contract_               IN VARCHAR2,
   wanted_delivery_date_   IN DATE) RETURN VARCHAR2
IS
   planned_ship_date_ DATE;
BEGIN
   IF (line_no_ IS NULL) THEN
      planned_ship_date_ := Order_Quotation_Line_API.Get_Planned_Due_Date(quotation_no_, line_no_, rel_no_, line_item_no_);
   ELSE
      planned_ship_date_ := wanted_delivery_date_;
   END IF;
   
   RETURN NVL(planned_ship_date_, TRUNC(NVL(Site_API.Get_Site_Date(contract_), SYSDATE)));
END Get_Conn_Planned_Ship_Date;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
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
   address_rec_            Customer_Info_Address_API.Public_Rec; 
   quot_chg_rec_           Order_Quotation_Charge_API.Public_Rec;
   quot_rec_               Order_Quotation_API.Public_Rec;

BEGIN
   quot_chg_rec_ := Order_Quotation_Charge_API.Get(source_ref1_, source_ref2_);
   quot_rec_     := Order_Quotation_API.Get(source_ref1_);
   
   IF ((quot_chg_rec_.line_no IS NOT NULL) AND (quot_chg_rec_.rel_no IS NOT NULL)) THEN
      Order_Quotation_Line_API.Get_Line_Address_Info(address1_,
                                                   address2_,
                                                   country_code_,
                                                   city_,
                                                   state_ ,
                                                   zip_code_,
                                                   county_,
                                                   in_city_,
                                                   quot_chg_rec_.quotation_no,
                                                   quot_chg_rec_.line_no,
                                                   quot_chg_rec_.rel_no,
                                                   quot_chg_rec_.line_item_no,
                                                   company_);
   ELSIF (quot_rec_.single_occ_addr_flag = 'TRUE') THEN
      address1_      := quot_rec_.ship_address1;
      address2_      := quot_rec_.ship_address2;
      country_code_  := quot_rec_.ship_addr_country_code;
      city_          := quot_rec_.ship_addr_city;
      state_         := quot_rec_.ship_addr_state;
      zip_code_      := quot_rec_.ship_addr_zip_code;
      county_        := quot_rec_.ship_addr_county;
      in_city_       := quot_rec_.ship_addr_in_city;
   ELSE
      address_rec_   := Customer_Info_Address_API.Get(quot_rec_.customer_no, quot_rec_.ship_addr_no);
      address1_      := address_rec_.address1;
      address2_      := address_rec_.address2;
      zip_code_      := address_rec_.zip_code;
      city_          := address_rec_.city;
      state_         := address_rec_.state;
      county_        := address_rec_.county;
      country_code_  := address_rec_.country;
      in_city_       := address_rec_.in_city;
   END IF;
END Get_Line_Address_Info;


FUNCTION Get_Connected_Addr_Flag (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN VARCHAR2
IS
   line_no_      ORDER_QUOTATION_CHARGE_TAB.line_no%TYPE;
   rel_no_       ORDER_QUOTATION_CHARGE_TAB.rel_no%TYPE;
   line_item_no_ ORDER_QUOTATION_CHARGE_TAB.line_item_no%TYPE;
   addr_flag_    ORDER_QUOTATION_TAB.single_occ_addr_flag%TYPE;

   CURSOR get_quote_line_connection IS
      SELECT line_no, rel_no, line_item_no
      FROM   ORDER_QUOTATION_CHARGE_TAB
      WHERE  quotation_no = quotation_no_
      AND    quotation_charge_no = quotation_charge_no_;
BEGIN
   OPEN get_quote_line_connection;
   FETCH get_quote_line_connection INTO line_no_, rel_no_, line_item_no_;
   CLOSE get_quote_line_connection;
   IF (line_no_ IS NULL) THEN
      addr_flag_ := Order_Quotation_API.Get_Single_Occ_Addr_Flag(quotation_no_);
   ELSE
      addr_flag_ := Order_Quotation_Line_API.Get_Single_Occ_Addr_Flag(quotation_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   RETURN addr_flag_;
END Get_Connected_Addr_Flag;


-- Get_Objversion
--   Return the current objversion for line
FUNCTION Get_Objversion (
   quotation_no_        IN VARCHAR2,
   quotation_charge_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_  ORDER_QUOTATION_CHARGE_TAB.rowversion%TYPE;
   CURSOR get_attr IS
      SELECT rowversion
      FROM   ORDER_QUOTATION_CHARGE_TAB
      WHERE  quotation_no = quotation_no_
      AND    quotation_charge_no = quotation_charge_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN TO_CHAR(temp_, 'YYYYMMDDHH24MISS');
END Get_Objversion;
