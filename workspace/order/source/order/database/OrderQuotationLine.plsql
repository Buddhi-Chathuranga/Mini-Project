-----------------------------------------------------------------------------
--
--  Logical unit: OrderQuotationLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  220118  ShWtlk   MF21R2-6812, Modfied Update_Planning_Date__ to fix spellings in the info message.
--  220202  Sanvlk   CRM21R2-840, Added additional_discount to Insert_Business_Opp_Line___.
--  220131  ShWtlk   MF21R2-6749, Modified Check_Before_Update___ to remove the error message displayed when ctp_planned and relase_for_planning flags are true at the same time.
--  220124  Jayplk   MF21R2-6717, Modified Finite_State_Machine___, refactored so that ctp data will not be removed when a sales quotation is released.
--  220124  ShWtlk   MF21R2-6416, Modified Check_Update___ to remove interim order headers created by neither reserver nor allocate option in capability check.
--  220118  ShWtlk   MF21R2-6531, Modfied Update_Planning_Date__ to remove incorrect parts of the info message shown when running capability check.
--  220112  ShWtlk   MF21R2-6416, Modified Cancel_Planning___, Delete___ to remove interim order headers created by neither reserver nor allocate option in capability check.
--  220110  Sanvlk   CRM21R2-724, Added additional discount to Update_Business_Opp_Line___ to sync additional discount changes to BO.
--  211203  ShWtlk   MF21R2-6026, Modfied the info message in Update_Planning_Date__() used for capability check dialog.
--  211130  ChBnlk   SC21R2-6165, Modified Fetch_Tax_Line_Param() and Calculate_Prices() to accept currency_rate_ as a parameter and assign the passed currency rate to the tax_line_param_rec_.
--  211101  GISSLK   MF21R2-5854, Modify Cancel_Planning___() to change Control_Ms_Mrp_Consumption() method call parameters.
--  211015  KiSalk   Bug 161105(SC21R2-3192), Assigned newrec_.cost correctly for package header before calling Insert_Business_Opp_Line___ to update cost of business opportunity at and then the package line.
--  210818  KiSalk   Bug 160480(SCZ-15986), Modified Create_Order to transfer header/line connection of charge lines correctly from SQ to CO.
--  210818  NiDalk   SC21R2-2326, Modified Get_Line_Defaults___ to correct cost for none inventory parts.
--  210625  ErFelk   Bug 159328(SCZ-15311), Modified Get_Line_Defaults___() by passing condition code to Customer_Order_Pricing_API.Get_Quote_Line_Price_Info().
--  210428  ThKrlk   Bug 158718(SCZ-14503), Modified Update___() to run Modify_Discount__() immediate after tax line updates if price_source_refreshed_ is true.
--  210415  MaEelk   SC21R2-49, Modified Update___ and if the Discounted Price Rounded is enabled, assigned the Original Discount to the Discount field when the Discount field is changed with other operations.
--  210401  ThKrlk   Bug 158655(SCZ-14298), Modified Update___() to get the new buy_qty_due as new desired quantity if it is B2B shopping cart quantity change.
--  210129  Skanlk   SCZ-13274, Modified Update___()  method by adding a condition to check whether the default_addr_flag is N and tax method is NOT USED before updating the address of the sales quotation lines
--  210129           when copy_addr_to_line_ is true. Modified Modify_Quote_Line_Defaults___() by adding a condition to set the UPDATE_TAX as TRUE when the tax method is NOT USED and tax liability type is EXM.
--  210129           Modified Check_Update___() by adding conditions to check whether tax_changed_from_header_ is TRUE, copy_addr_to_line_ is TRUE and default_addr_flag is N before updating the tax code.
--  210125  NiDalk   SC2020R1-12158, Removed get methods where value can be fetched from public rec.
--  210118  ThKrlk   Bug 157060(SCZ-13013), In Update___, made tax refetching if planned_due_date is chageed when a tax class is used for the part.
--  210107  MaIklk   CRMZSPPT-112, Implemented to copy document text from BO.
--  201204  PamPlk   Bug 156222(SCZ-12747), Modified Update___()to fetch the default tax information when unchecking the single occurence check box and having a tax class is defined.
--  201029  MalLlk   GESPRING20-5276, Modified Check_Update___() to clear ctp record, after cancel interim order.
--  200917  MaEelk   GESPRING20-5399, Added Get_Displayed_Discount__ to show the original discount when using Discounted Price Rounded parameter enabled.
--  200917           Modified Update_Line___, Post_Insert_Actions___, Prepare_Insert___, Insert___, Update___, Build_Attr_For_Create_Line___, Modify_Discount__, Get_Sale_Price_Excl_Tax_Total, Get_Total_Discount
--  200715  NiDalk   SCXTEND-4526, Modified Build_Attr_For_Create_Line___ to add UPDATE_TAX as FALSE to attr_ for AVALARA companies
--  200715           Also When attr_ has UPDATE_TAX set to false in Insert___ and Update___ that means taxes are fetched from a bundle call.
--  200706  NiDalk   SCXTEND-4446, Modified Create_Order to fetch external taxes to customer order lines.
--  200706  AjShlk   Bug 148429 (SCZ-5154), Added UncheckedAccess annotation to Get_Quot_Line_Contribution().
--  200625  NiDalk   SCXTEND-4438, Modified Post_Insert_Actions___ and Update___ to avoid fetch of taxes during insert 
--  200625           when company_tax_control.fetch_tax_on_line_entry for Avalara sales tax is set to false.
--  200608  MalLlk   GESPRING20-4617, Removed Calc_Free_Of_Charge_Tax_Basis() amd moved the logic to Tax_Handling_Order_Util_API.Calc_And_Save_Foc_Tax_Basis().
--  200608           Added public method Modify_Foc_Tax_Basis().
--  200513  ThKrLk   Bug 153597 (SCZ-9929), Modified Get_Base_Sale_Price_Total() to filter only quotation lines which are not in Canceled state when calculating total base sales price.
--  200415  ThKrLk   Bug 152839(SCZ-9432), Modified Check_Insert___() by moving logic from Insert___() to Check_Insert___(),
--  200415           when default Info is unchecked and a single occurrence is checked, copy the single occurrence address from the header
--  200203  MalLlk   SCXTEND-2494, Avoid the duplicate requests to external tax systems, when discounts involved, upon saving.
--  200120  UtSwlk   Bug 151751, Added method Validate_before_Delete___() and a new parameter to Remove().
--  191205  ApWilk   Bug 150524(SCZ-7432), Modified Check_Supply_Code___ to check if the part is connected with a product structure which is a Manufactured type when the supply code is a Shop order.
--  191118  Hairlk   SCXTEND-1515, Avalara Integration. Refer to the comments in checkpoint EXTTAXSYS_ONE and checkpoint EXTTAXSYS_TWO.
--  191114  PamPlk   Bug 150639 (SCZ-7796), Modified Post_Insert_Actions___() in order to set the state of package header Reject to Revised, when changing the sales quotation header state from Reject to Revised.
--  191021  Hairlk   SCXTEND-939, Modified Prepare_Insert___, added code to fetch CUSTOMER_TAX_USAGE_TYPE from the header and added it to the attr.
--  191003  Hairlk   SCXTEND-939, Avalara integration, Modified Insert___, Added code to fetch customer_tax_usage_type from customer if its not available in the attr.
--                   Modified Check_Update___ to prevent changing customer_tax_usage_type if the quotation is in Closed or Cancelled state. Modified Build_Attr_For_Create_Line___ and Build_Attr_For_Copy_Line___, added CUSTOMER_TAX_USAGE_TYPE to the attr.
--  190930  DaZase   SCSPRING20-145, Added Raise_Price_Break_Error___ to solve MessageDefinitionValidation issue.
--  190923  UdGnlk   Bug 148052 (SCZ-5108), Modified Update___() to prevent refetching the tax code when the single occurence address
--  190923           is checked for a taxable part unless the sales part is using a tax class.
--  190524  NiDalk   Bug 148377(SCZ-4884), Added Get_Sales_Price_Totals to retun sales price and sales price including tax for an order quotation line
--  190502  DilMlk   Bug 147983(SCZ-4280), Modified Build_Attr_For_Copy_Line___() and Copy_Quotation_Line() to copy Configuration Id and Configuration prices when using RMB Copy Quotation.
--  190429  ChBnlk   SCUXXW4-8515, Corrected according to the code review suggestions of the Template assistant.
--  190320  ChBnlk   SCUXXW4-8517, Modified New() to pass back the quotation_no_ in the attr_ when it is called from AURENA.
--  190314  UdGnlk   Bug 147274, Modified Check_Supply_Code___() to add IPD and IPT supply codes for the condition when DOP parts. 
--  181020  ChBnlk   Bug 143415, Modified Cancel_Order_Line() by adding new OUT parameter cancel_info_ in order to display info messages properlly when cancelling a quotation line. 
--  181019  ErRalk   Bug 144656, Added Is_Number___ method and modified Check_Insert___ method to validate line_no and rel_no to check whether they are numeric values.
--  180904  SBalLK   Bug 143638, Modified Copy_Quotation_Line() and Post_Insert_Actions___() method to copy discount with relevant discount information separately.
--  180723  ChBnlk   Bug 142401, Modified Build_Attr_For_New___ by adding new condition to check if the sales price should be copied from another object and
--  180723           if so assign the sales price converted from the base price to the attr_ rather than directly assigning it, in order to get proper values based on currency rates.
--  180720  ChBnLK   Bug 143082, Modified Check_Before_Update___() to add conditions to check if the line is going to be cancelled or lost before validating price list 
--                   because if so there's no need to validate it.
--  180709  DiKuLk   Bug 142671, Moved the code to check rental null to top in Check_Insert___().
--  180514  CwIclk   Bug 141202, Modified the method Forecast_Consumption___ to correct the consume and un-consume on master scheduling. 
--  180313  KiSalk   Bug 140715, Modified Modify_Tax_Info to initialize attribute string parameter when Update___ is called in a loop for package components.
--  180228  AyAmlk   Modified Build_Attr_For_Create_Line___() to prevent stopping creating the CO through Shopping cart when priority reservation is used.
--  180221  DiKuLk   Bug 140020, Modified Fetch_Delivery_Attributes() and Get_Supply_Chain_Defaults___ to track if the ship via code is changed.
--  180209  KoDelk   STRSC-15901, When creating tax lines for invoice use the current currency rate rather than using the source line currency rate.
--  180110  DilMlk   Bug 139497, modified Update___ to prevent duplicate quotation line history records from being added, whenever Update_Line___ method is called inside Update___.
--  171219  DiKuLk   Bug 139211, Modified Fetch_Delivery_Attributes() procedure to get the user manually entered values for delivery_leadtime_ and picking_leadtime_
--  171219           from the client.
--  171114  RaVdlk   STRSC-12123, Set the multiple discounts to be fetched instead of summed discount line when copying the quotation without checking the Price and Discounts option.
--  171019  Nikplk   STRSC-10690, Modified Create_Order() method in order to recieve copy_contacts_ attribute and to pass that into Order_Quotation_API.Create_Order_Head__() method.
--  171009  RaVdlk   STRSC-12361, Avoided duplicating charge lines in copy quotation.
--  171004  JaThlk   Bug 137791, Modified Update___() to send a flag to Modify_Default_Qdiscount_Rec() when the customer is changed.
--  170926  RaVdlk   STRSC-11152,Removed Get_Objstate function, since it is generated from the foundation
--  170824  ShPrlk   Bug 136668, Modified Get_Line_Defaults___ and Check_Update___  to adjust parameters for the method call Sales_Price_List_API.Get_Valid_Price_List.
--  170815  JaBalk   Bug 136869, Modified Prepare_Insert___ to add the quotation_no to attr_ as it is cleared inside the base method.
--  170809  UdGnlk   Bug 137138, Modified Update___() condition to check instead of newrec_.revised_qty_due to newrec_.buy_qty_due for the message LTMINIMUMQTY.
--  170626  ErRalk   Bug 135979, Changed the error message constant from CONFIGSUPPSITE to CONFIGDELCTRY in Check_Update___ to eliminate duplication of message constant.
--  170517  AmPalk   STRMF-8163, Modified Update_Planning_Date__ by initializing the oldrec_.
--  170516  IzShlk   VAULT-2558, Handled logic in Create_Order___() to handle copy all representatives.
--  170512  Hairlk   STRSC-8079, Modified Check_Supply_Code___ to allow PT, PD, IPT, IPD order supply types for non-inventory configured parts.
--  170503  Sucplk   Bug STRSC-7428, Modified Get_Allowed_Operations__() to disable 'Quotation Won' RMB option for already won quotation lines. 
--  170418  NiDalk   Bug 135371, Modified Update_Business_Opp_Line___ to pass correct parameters to call Configured_Line_Price_API.Transfer_Pricing__.
--  170420  KiSalk   Bug 135429, Made Copy_Quotation_Line copy price break lines.
--  170322  SURBLK   Added Recalculate_Tax_Lines___ in Post_Insert_Actions___ after adding discounts.
--  170321  RuMelk   APPUXX-10011, Modified Build_Attr_For_Copy_Line___, Build_Attr_For_Create_Line___ and Pre_Unpack_Insert___ to handle SM Object information.
--  170215  ChJalk   Bug 134137, Modified the method Get_Line_Defaults___ to add the parameter rental_db_ to the call Sales_Part_API.Get_Default_Supply_Code.
--  170214  AyAmlk   APPUXX-9378, Modified Build_Attr_For_Create_Line___() by setting REL_MTRL_PLANNING to TRUE for non-inventory part lines when the order is created from B2B.
--  170131  WaSalk   STRSC-5566, Modified Get_Changed_State___() to check the discount percentage when creating the quotaion history lines.
--  170102  slkapl   FINHR-5271, Implement Tax Structures in Sales Quotation/Quotation Lines
--  161118  Hairlk   APPUXX-5312, Modified Check_Update___ to include Rejected state so that IEE will raise the meesgae SQLCCPLANNED for rejected lines also.
--  161104  Hairlk   APPUXX-5312, Modified Cancel_Planning___  where for package part line cancelled check, to consider rejected header state.
--  161104  Hairlk   APPUXX-5312, Modified Update___ to include rejected lines also in the check for Update_Planning___ when updating a quotation line.
--  161103  AyAmlk   APPUXX-5558, Modified Build_Attr_For_Create_Line___() by setting REL_MTRL_PLANNING to TRUE only for B2B OQ package part lines.
--  161028  Hairlk   APPUXX-5312, Modified Check_Quote_Line_For_Planning to include rejected lines also so that it won't allow the removal of online consumption
--                   flag in inventory part window if there are quotation lines with Rejected status
--  161027  Hairlk   APPUXX-5312, Minor Code refactoring
--  161023  Hairlk   APPUXX-5312, Modifications to include rejected lines in various flows. For a detailed info on what changed and why refere to the excel attached to the task.
--  161014  NiAslk   STRSC-2740, Update of Sales Quotation Address on default info unchecked line level from header 
--  161006  TiRalk   STRSC-4325, Modified Set_Cancelled to update cancel reason when cancelling the Sales Quotation.
--  161004  TiRalk   STRSC-4315, Modified Update_Bo_Line_Status___ to update lost reason, reason note, cancel reason and lost to in business opportunity line.
--  160926  Hairlk   APPUXX-4354, Added state Rejected and condition Header_Rejected___ to the state machine.
--  160923  ThEdlk   Bug 131645, Modified Copy_Quotation_Line() by allowing to copy custom fields values in sales quotation lines.
--  160915  AyAmlk   APPUXX-4650, Modified Get_Quote_Line_Price() in order to specify price_source_db_ in the ELSE condition to prevent setting a NULL value.
--  160908  ChJalk   Bug 130981, Modified Fetch_Delivery_Attributes to make the parameteres delivery_terms_ and del_terms_location_ IN OUT.
--  160907  NiAslk   STRSC-2740, Update of Sales Quotation Address on line level
--  160729  NiDalk   Bug 130511, Modified Create_Order_Line___ to set attribute UPDATED_FROM_CREATE_ORDER as TRUE before calling Update___. Added parameter updated_from_create_order_ to Update_Line___,
--  160729           Get_Changed_State___ and Check_Important_Fields___. Modified Get_Changed_State___ ignore checks when updated_from_create_order_ is TRUE.
--  160728  ThEdlk   Bug 130573, Modified Check_Before_Insert___() by adding the validation method Exist_Line_No() to check whether the line already exists. 
--  160715  ThEdlk   Bug 130341, Modified Exist_Line_No() to validate the existence of order quotation line based on its line_item_no.
--  160705  AyAmlk   APPUXX-2134, Modified Build_Attr_For_Create_Line___() by setting REL_MTRL_PLANNING as FALSE for all the CO lines created from a SQ created for a Shopping Cart.
--  160616  ChJalk   Bug 127627, Modified the method Fetch_Delivery_Attributes to change the OUT parameter forward_agent_id_ to IN OUT.
--  160609  AyAmlk   APPUXX-1530, Modified Check_Delete___() by adding a check to prevent raising error messages for SQs created from shopping cart.
--  160601  KiSlk    Bug 129566, Modified Change_Package_Structure___ not to raise division by 0 error on calculating desired_qty of components when it is 0 in package header.
--  160526  ErFelk   Bug 128475, Modified Build_Attr_For_Create_Line___() by adding CLASSIFICATION_STANDARD to the attr only if it has a value.
--  160519  ErFelk   Bug 127985, Modified Update___() to call Customer_Order_Pricing_API.Modify_Default_Qdiscount_Rec() when the header customer was changed.
--  160517  Chgulk   STRLOC-369, Added new address fields.
--  160506  Chgulk   STRLOC-369, used the correct package.
--  160427  NWeelk   STRLOC-360, Modified Get_Sale_Price_Total and Get_Sale_Price_Incl_Tax_Total to set order line totals correctly for free of charge lines.
--  160420  NWeelk   STRLOC-244, Modified Build_Attr_For_Create_Line___ by setting free of charge information for creating COL.
--  160419  NWeelk   STRLOC-243, Added method Calc_Free_Of_Charge_Tax_Basis and introduced free of charge logic into sales quotation.
--  160411  MalLlk   FINHR-1515, Added method Get_Total_Discount_Incl_Tax() to retrieve the total discount amount incluging tax for PIV scenario.
--  160321  KiSalk   Bug 122195, Modified Pre_Unpack_Insert___ to set newrec_.default_addr_flag depending on the EVALUATE_DEFAULT_INFO attribute value.
--  160317  SeJalk   Bug 126908, Modified Create_Order to change the cursor to get count of quotation lines which has created order lines.
--  160314  IsSalk   FINHR-686, Moved server logic of QuoteLineTaxLines to Source Tax Item Order.
--  160307  DipeLK   STRLOC-247,Change Validate_Address() method call to Address_validation_API.Validate_Address
--  160307  IsSalk   FINHR-686, Move server logic of QuoteLineTaxLines to common LUs SourceTaxItemOrder and TaxHandlingOrderUtil.
--  160307  MaIklk   LIM-4670, Used Get_Config_Weight_Net() in Part_Weight_Volume_Util_API.
--  160304  BudKlk   Bug 127277, Modified the method new() by extending the size of the variable new_attr_ to 32000 to make sure it can handle large attribute strings to avoid exceptions.
--  160229  IsSalk   FINHR-708, Added attribute Tax liability Type to the Order Quotation Line.
--  160215  IsSalk   FINHR-722, Renamed attribute FEE_CODE to TAX_CODE in ORDER_QUOTATION_LINE_TAB.
--  160202  ErFelk   Bug 123221, Modified Copy_Quotation_Line(), Build_Attr_For_Copy_Line___(), Check_Insert___(), Get_Line_Defaults___() and Post_Insert_Actions___() to facilitate Copy Quotation functionality.   
--  160114  ChWkLk   STRMF-1328, Added '*' in call to Level_1_Part_API.Get_Promise_Method_Db(). 
--  151216  ChJalk   Bug 125960, Modified Build_Attr_For_New___ to add the value of RENTAL_DB to the attribute string.
--  151109  AyAmlk   Bug 125624, Modified Get_Cust_Part_No_Defaults__() in order to set the correct values of a Sales part cross reference when there are multiple
--  151109           cross reference lines with the same customer no, contract and catalog no.
--  151103  IsSalk   FINHR-316, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Line.
--  151021  IsSalk   FINHR-197, Used FndBoolean in taxable attribute in sales part.
--  150930  KhVese   Bug 124761, Modified method Check_Default_Addr_Flag__() to public method and also all the call to this method. Also modifyed method Modify_Quote_Defaults__() 
--  150930           and Modify_Quote_Line_Defaults___() to handle Customer_no change on quotation lines. Added attribute forward_agent_id and moved attribute
--  150930           ext_transport_calendar_id in method Change_Package_Structure___() and changed if-condition in Delivery_Info_Match___(). 
--  150928  MeAblk   Bug 124760, Modified Get_Supply_Chain_Defaults___ to correctly set the header del terms and del terms location for the defualt info checked lines in acase of header modification.
--  150917  JanWse   AFT-5243, Modified Insert_Business_Opp_Line___ and Update_Business_Opp_Line___ to include PRICE_SOURCE_ID as well
--  150917  KhVese   AFT-1982, Modified Insert___() method. Added new condition before call to Copy_Singl_Occ_Addr_To_Line___() to prevent overwriting line SO Addr come from other functions (Exp. Copy Quotation).
--  150917  JanWse   AFT-5243, Modified Insert_Business_Opp_Line___ and Update_Business_Opp_Line___ to include PRICE_SOURCE_DB, PART_PRICE and PRICE_UNIT_MEAS
--  150904  Erlise   AFT-2047, Modify_Quote_Line_Defaults___ should only consider lines with default address flag checked.
--  150831  Wahelk   AFT-2238, Modified Insert_Business_Opp_Line___ to stop adding BO lines for rental lines
--  150826  KhVese   AFT-2231, Added logic to Check_Insert___() to consider single occurrence address when fetching freight information. 
--  150826  Erlise   AFT-1982, Modified Insert___(). Added call to Copy_Singl_Occ_Addr_To_Line___().
--  150819  KhVese   COB-418, Modified the interface and logic of Fetch_Delivery_Attributes() to consider single occurrence address. 
--  150819           Also modified Check_Update___() to recall Get_Supply_Chain_Defaults___() when single occurence address change to standard address.
--  150817  Erlise   COB-416, Modified Check_Update___(), Update___(), Validate_Fee_Code___(), Modify_Quote_Defaults__() and Modify_Quote_Line_Defaults___ to handle single occurrence address changes.
--  150813  KhVese   COB-682, Modified the Event parameter value when calling Order_Quote_Line_Hist_API.New() for Single-Occurence flag/address in the method Get_Changed_State___().
--  150716  KhVese   COB-557, Modified Build_Attr_For_Copy_Line___() method by adding the DEFAULT_ADDR_FLAG_DB to the attribute string and all the necessary data needed when default falg is not set.   
--  150714  KhVese   COB-683, Added single occurrence address validation to Check_Common___()
--  150714           COB-683, Modified Check_Update___ method to call Fetch_Zone_For_Addr_Details() if we have SO address also make sure refresh_fee_code_ is TRUE when SO become disabled.
--  150710  KhVese   COB-682, Modified Get_Changed_State___() method to add Single-Occurence flag/address changes to Order Quotation Line History. 
--  150710  KhVese   COB-79, Modified Get_Changed_State___() method to handle Revisions for Single-Occurence flag/address.
--  150704  NaLrlk   RED-589, Modified Update___() to handle revisions for rental fields.
--  150702  KhVeSE   COB-80, Moved the 'ADDR_FLAG' and ADDR_FLAG_DB attribute string manipulation from Create_Line___() to Build_Attr_For_Create_Line___().
--  150630  Vwloza   RED-594, Updated Update___() with rental change restriction.
--  150630  Vwloza   RED-478, Updated Get_Quote_Line_Price() to calculate price breaks per qty and duration.
--  150629  Vwloza   RED-480, Excluded rentals from cursor in Get_Possible_Sales_Promo_Deal().
--  150618  Erlise   COB-589, Added single occurrence handling to package part component lines.
--  150618           Modified Update_Lines___, Change_Package_Structure___, Insert_Package___.
--  150616  ChBnlk   ORA-397, Modified Create_Line___(), New() and Copy_Quotation_Line() by moving the attribute string manipulation to 
--  150616           seperate methods. Introduced new methods Build_Attr_For_Create_Line___, Build_Attr_For_New___ and Build_Attr_For_Copy_Line___
--  150612  Erlise   COB-555, Added method Single_Occ_Addr_Match___().
--  150611  KhVeSE   COB-80, Modified Create_Order() to call Change_Address() for lines that have SO Address and their default info are not set.
--  150611           Also modified Create_Line___() to add 'ADDR_FLAG' and 'ADDR_FLAG_DB' to attribute string when calling Customer_Order_Line_API.New();  
--  150610  Erlise   COB-333, Modified Pre_Unpack_Update___, Check_Default_Addr_Flag___.
--  150610           Added Copy_Delivery_Info_To_Line___, Remove_Single_Occ_Addr_Line___, 
--  150610           Delivery_Info_Match___, Copy_Singl_Occ_Addr_To_Line___.
--  150529  NaLrlk   RED-333, Modified Copy_Quotation_Line() to handle for rental lines.
--  150528  Erlise   COB-333, Single occurrence address handling.
--  150519  NaLrlk   RED-324, Added rental column to support for rentals.
--  150429  Erlise   COB-332, Modifed Modify_Quote_Defaults__(), added handling of single_occ_addr_flag_.
--  150424  Erlise   COB-328, Modified Check_Default_Addr_Flag___.

--  150831  ChWkLk   Bug 116050, Added Forecast_Consumption___() to make error message more meaningful according to the promise method. 
--  150831           Used in Update_Planning___() and Release_For_Planning___(). 
--  150831  SBalLK   Bug 124163, Modified Validate_Vendor_No___() to check if the vendor_no is valid.
--  150820  KiSalk   Bug 121242, In Post_Insert_Actions___, ignored info message US_NO_VALID_TAX for prospect customers without any Customer Tax Info
--  150819  PrYaLK   Bug 121587, Modified Update_Line___(), Insert___(), Update___(), Get_Line_Defaults___(), Get_Default_Part_Attributes___(),
--  150819           Check_Before_Update___(), Create_Line___() and Update_Grad_Price_Line() by adding new parameter cust_part_invert_conv_fact.
--  150818  JeeJlk   Bug 123949, Modified Create_Line___ not to add price effective date to transfer attr when price effective date is null.
--  150626  BudKlk   Bug 123185, Modified method Create_Line___() to add the COST when the Capability Check checkbox is checked.
--  150226  RasDlk   PRSC-4595, Added parameter refresh_vat_free_vat_code_ to the method Modify_Quote_Defaults__() and modified it in order to
--  150226           set the fee code of the sales quotation line according to sales quotation header.
--  150226           Added a check for supply country in Update___() when modifying order quotation charges.
--  150214  MaIklk   PRSC-974, Used tax regime and tax fee code from company for prospect if delviery tax is missing in Validate_Fee_Code().
--  150213  PraWlk   PRSC - 5401, Modified Get_Min_Promised_Delivery_Date() to include the Won Quotation lines as well in the condition.
--  150212  UdGnlk   PRSC-5680, Modified Copy_Quotation_Line() to retrieve prize freeze and discoun columns.
--  150209  MAHPLK   PRSC-4770, Added new method Modify_Line_Default_Addr_Flag() and Check_Default_Addr_Flag___() so that it correctly set the default address flag 
--  150209           by comparing the header and the line address details. Removed Modify_Line_Delivery_Info__().  
--  150130  ChJalk   PRSC-5828, Modified Copy_Quotation_Line to add 'PART_NO' when copy pricing is used.
--  141217  MaIklk   PRSC-974, Checked and handled the places where we can enable some logic for prospect since we have enabled customer/order tab for prospects.
--  141128  SBalLK   PRSC-3709, Modified Get_Supply_Chain_Defaults___() and Fetch_Delivery_Attributes() methods to fetch delivery terms and delivery terms location from supply chain matrix.
--  141128  MaIklk   PRSC-4469, Fixed to update BO references when creating CO from SQ.
--  141125  MaIklk   PRSC-1481, Used line_item_no in BO lines.
--  141124  MaIklk   EAP-776, Enabled to fetch pricelist for prospects.
--  141118  ChJalk   PRSC-3412, Modified Post_Insert_Actions___ to correctly create the default discount lines when not copying the discounts from BO.
--  141114  ChJalk   PRSC-4190, Modified the method New to add attribute COPY_STATUS into the Customer_Order_Pricing method.
--  141112  NiDalk   Bug 119475, Modified Get_Sale_Price_Incl_Tax_Total and Get_Sale_Price_Excl_Tax_Total to round total_gross_amount_ before calculating discounts.
--  141107  ChJalk   PRSC-3412, Modified the method New to change the default discount type when uses copy_discounts.
--  141029  Chfose   Removed 'Won' from the condition to throw error LINECHANGEDERROR in Line_Changed.
--  141022  ChJalk   PRSC-3789, Modified the method Update___ to remove the check to see the price_freeze flag and discount_freeze flag for re-calculating the discount.
--  141014  Chfose   PRSC-3591, Added customer_po_no_ in call to Order_Quotation_API.Create_Order_Head.
--  141013  UdGnlk   PRSC-3137, Modified Check_Before_Update___() to include the discount freeze functionality.
--  141007  UdGnlk   PRSC-3137, Modified Update___() to include the discount freeze functionality.
--  140911  UdGnlk   PRSC-311, Added Copy_Quotation_Line__() to support copy sales quotation functionality.   
--  140822  MAHPLK   PRSC-2227, Merged Bug 118118, Added new method Get_Quot_Line_Contribution() to calculate the contribution amount of an order quotation line. 
--  140812  MeAblk   Modified Post_Insert_Actions___ in order to make it possible to register a discount value when a new quotation line is entered. 
--  140808  PraWlk   PRSC-2145, Modified Check_Important_Fields___(), Check_Reason_Id_Ref___(), Pre_Unpack_Update___(), Modify_Quote_Defaults__(), Line_Changed(),  
--  140808           Modify_Additional_Discount__(), Check_Line_Total_Discount_Pct() and Recalc_Line_Tot_Net_Weight() by adding new state 'CO Created' to the conditions.
--  140714  MeAblk   Modified methods Check_Update___ and Update___in order to add, modify or remove discount line accordingly when discount % is modified.
--  140710  ChJalk   PRSC-1531, Modified Update_Business_Opp_Line___ to back update the price freeze flag.
--  140709  UdGnlk   PRSC-1536, Modified Get_Default_Part_Attributes___() to set the pricin when creating SQ from BO objects.
--  140704  MaEelk   Bug 117218, Modified Check_Update___() in order to prevent re-fetching the tax code when default info flag is unchecked.
--  140702  MaEdlk   Bug 117072, Removed rounding of adjusted_weight_net, adjusted_weight_gross, adjusted_volume and line_total_weight attributes in Check_Insert___ and Check_Update___.
--  140702  UdGnlk   PRSC-1596, Modified Check_Won_Reason___() and Check_Lost_Reason___() to check existance of reason id. 
--  140626  UdGnlk   PRSC-1535, Modified New() to fetch discount from BO to SQ.
--  140616  PraWlk   PRSC-316, Added new method Set_Quotation_Line_Won__() to call from the client upon RMB Won Quotation Line execute. 
--  140616           Modified Create_Order(), Create_Line___(), Finite_State_Machine___() and Create_Order_Line() to support that won 
--  140616           functionality. Renamed Check_Won_Reason___() to Update_Won_Reason___() as it is used to check and update 
--  140616           won information. Also modified Update_Bo_Line_Status___() to set the BO line to Won with ref type Customer Order.
--  140521  KoDelk   Bug 116634, Modified method Recalc_Line_Tot_Net_Weight to filter records by rowstate in the cursor get_co_lines.
--  140514  NIWESE   PBSC-8638 Added call to custom validation for Cancel Reason codes.
--  140508  HimRlk   Modified parameters of Get_Supply_Chain_Defaults___ to take in indrec_ instead of attr_.
--  140505  MaRalk   PBSC-8635, Modified Check_Update___ to assign a value to the variable header_rowstate_.  
--  140403  AyAmlk   Bug 114045, Modified Check_Before_Insert___() to pass sales_part_rec_.part_no when calling Check_Active_Part___().
--  140325  AndDse   PBMF-4700, Merged in LCS bug 113040, Passed FALSE as order_line_cancellation_ parameter to the calls Reserve_Customer_Order_API.Control_Ms_Mrp_Consumption().
--  140321  HimRlk   Modified logic to pass use_price_incl_tax value when fetching freight price lists.
--  140321  KiSalk   Bug 115190, In Post_Insert_Actions___, renamed menu name from "View Calculated Sales Promotions" to "Calculate and View Sales Promotions" in info messages.
--  140320  NiDalk   Bug 112499, Added function Get_Total_Tax_Amount_Base to clculate the total tax amount per quotation line in base currency.
--  140318  RuLiLk   Bug 114315, Modified method Get_Sale_Price_Incl_Tax_Total() to return total with tax when use price including tax is not specified.
--  140307  HimRlk   Bug 110133-PIV, Added new method Get_Sale_Price_Excl_Tax_Total
--  140307  HimRlk   Bug 110133-PIV, Modified methods Get_Sale_Price_Total, Get_Base_Sale_Price_Total by changing Calculation logic of line discount amount to be consistent with discount postings.
--  140307           Removed cursor get_total in method Get_Base_Sale_Price_Total.
--  140307  JanWse   PBSC-7333, Added private attribute End_Customer_Id and modified base methods. 
--  140307           Modified Prepare_Insert___ to add the END_CUSTOMER_ID value to the attribute string. 
--  140307  SBalLK   Bug 112938, Modified the INTORDEXISTS error message in Unpack_Check_Update___() method to be more descriptive.
--  140227  ErFelk   Bug 115041, Modified Check_Supply_Code___() to by pass the error CONFIGPART when supply code is 'IO' for inventory parts. 
--  140227           Modified Create_Line___() to set the value to REL_MTRL_PLANNING. 
--  140220  KiSalk   Bug 115357, Modified Unpack_Check_Update___ to add info message on qty or price change if connected sales promotion charge lines exist.
--  131106  MaMalk   Made delivery_leadtime and contract mandatory. Changed the length of release_planning_db, order_supply_type_db, catalog_type_db, price_freeze_db, default_addr_flag_db.
--  131023  KiSalk   Bug 113305, Added IF condition to bypass checking for existance of tax lines in the Vertex Sales Tax companies.
--  130905  MaRalk   CO-518, Added additional parameter values for the method call  Update_Line___ calling inside Insert_Business_Opp_Line___. 
--  130729  SURBLK   Changed forward_agent_id_ as OUT in Fetch_Delivery_Attributes().
--  130625  HimRlk   Added new method Modify_Line_Delivery_Info__().
--  120911  MeAblk   Added ship_inventory_location_no_ as a parameter to the method Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes.
--  120824  MeAblk   Added parameter shipment_type_ into the method Cust_Order_Leadtime_Util_API.Get_Ship_Via_Values.
--  120824  MaMalk   Added shipment_type as a parameter to method Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes.
--  120726  MAHPLK   Added parameter picking_leadtime_ to Fetch_Delivery_Attributes.
--  120726  MAHPLK   Added attribute picking lead time.
--  120702  MaMalk   Added route and forwarder to methods Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes, Get_Supply_Chain_Defaults and Get_Ship_Via_Values.
--  130717  UdGnlk   TIBE-1005, Removed global variable current_info_ therefore changed the logic accordingly.
--  130716  UdGnlk   TIBE-1005, Removed global variable block_component_info_ therefore changed the logic accordingly.
--  130712  UdGnlk   TIBE-1005, Removed global variable insert_package_mode_ therefore changed the logic accordingly.
--  130712  UdGnlk   TIBE-1003, Removed the global variable updated_from_wizard_ in OrderQuotation therefore changed the logic accordingly.
--  130705  UdGnlk   TIBE-1005, Removed global varaibles and modify to conditional compilation.
--  130613  Maabse   Added SALES_UNIT_MEAS and INSERT_ALLOWED to Insert_Business_Opp_Line___
--  130827  SudJlk   Bug 111962, Added alias column unformatted_discount to view Order_Quotation_Line and modified Unpack_Check_Insert___ and Unpack_Check_Update___ accordingly, to eliminate
--  130827           the ambiguous column binding to discount in tbwOrderQuotationLine.
--  130719  RuLiLk   Bug 110133, Modified methods Insert_Package___, Change_Package_Structure___ by changing Calculation logic of line discount amount to be consistent with discount postings. 
--  130719           Modified method Get_Total_Discount, when calculating discount percentages unrounded discount values are used, removed cursor get_total. 
--  130719           Modified method Get_Base_Sale_Price_Total by passing base currency rounding when calculating line discount amount in base currency. 
--  130725  NWeelk   Bug 111445, Modified method Unpack_Check_Insert___ by checking inv_part_cost_level_db_ as well before setting the cost to zero.  
--  130719  NWeelk   Bug 110975, Modified method Insert_Package___ to pass language_code when fetching sales_part_desc_ to get the sales_part_desc_ 
--  130719           for the language specified and passed correct customer_part_no_ to fetch cross reference catalog_desc_.
--  130712  SudJlk   Bug 111254, Modified Update_Package___() to handle null values for wanted_delivery_date and planned_delivery_date to replicate them to component lines as well.
--  130702  SWiclk   Bug 107700, Modified Create_Order() in order to reset CO number in order_coordinator_group_tab when an error occurred since CO creation used autonomous transaction.
--  130701  ErSrLK   Bug 110859, Modified view ORDER_QUOTE_LINE_CONFIG_USAGE by removing NVL clause on the part_no/catalog_no, and using
--  130701           a union of inventory and non-inventory parts in order to pick existing indexes when queries are made against it.
--  130630  RuLiLk   Bug 110133, Modified method Get_Sale_Price_Total, Get_Total_Discount, Get_Base_Sale_Price_Total by changing Calculation logic of line discount amount to be consistent with discount postings. 
--  130630           Removed cursor get_total in method Get_Base_Sale_Price_Total.
--  130626  SudJlk   Bug 110883, Modified Unpack_Check_Update___ to restrict recalculating of price when customer is changed from Prospect to Normal while price is frozen.  
--  130603  ChBnlk   Bug 109515, Added General_SYS.Init_Method() call to the function Get_Next_Rel_No and 
--                   modified it to display the proper error message when entering values beyond 9999 to the column rel_no.
--  130503  ErFelk   Bug 109827, Validate_Fee_Code___() to restrict fee_code getting fetched when the sales part is not taxable. 
--  130322  IsSalk   Bug 108922, Made implementation method Validate_Jinsui_Constraints___() private. Added parameter company_max_jinsui_amt_ to the method
--  130322           Validate_Jinsui_Constraints__(). Modified methods Validate_Jinsui_Constraints__(), Insert___() and Update___() in order to perform
--  130322           validation with the Jinsui Invoice Constraints for all the lines in a Quotation.
--  130314  HimRlk   Added new method Get_Base_Price_Incl_Tax_Total().
--  130313  Maabse   Moved call to Business_Opportunity_Line_API.Remove after the actual delete in Delete__
--  130311  JeeJlk   Modified Remove() by calling Quote_Line_Tax_Lines_API.Remove_Tax_Lines. 
--  130208  MalLlk   Bug 108126, Added method Check_Active_Part___ and called it in Check_Before_Insert___, Insert_Package___ and Get_Line_Defaults___ to check the inventory part is active.
--  130107  MaIklk   Added Update_Bo_Line_Status___() to sync state changes of SQ to BO.
--  130104  MaIklk   Handled to sync changes from Quotation to Business Opportunity and added Get_Ship_Address_Count().
--  130102  SeJalk   Bug 106826, Check sales qty is larger than available qty if part status is supplier not allowed, supply code is Invent Order and availablity check is applied 
--  130102           and display massage if so when insert or update.
--  121210  MaIklk   Added demand code and othe ref columns.
--  121204  MaIklk   Handled Prospect type customers and use of customer category.
--  121012  UdGnlk   Bug 102701, Added code to copy Technical_Object_Reference in Create_Line___.
--  121012  IsSalk   Bug 105837, Modified view ORDER_QUOTE_LINE_CONFIG_USAGE to use the catalog_no as part_no when part_no is null.
--  120907  HimRlk   Modified Update___ to recalculate tax lines if customer_no is modified.
--  120813  JeeJlk   Modified Create_Order_Line___ to set UNIT_PRICE_INCL_TAX when creating order from quotation.
--  120731  HimRlk   Modified Get_Total_Tax_Amount_Curr() to calculate tax amount considering use price incl tax value.
--  120726  ShKolk   Modified Update_Grad_Price_Line() to consider prices including tax.
--  120717  JeeJlk   Modified method Get_Default_Part_Attributes___ to assign converted value of unit_price_incl_tax to base_unit_price_incl_tax.
--  120717           Modifed New method by calling new Modified_Incl_Taxes___ sothat base/curr price_incl_tax values updated correctly.
--  120719  ShKolk   Added price including tax columns to methods which calculate prices.
--  120711  HimRlk   Added new columns unit_price_incl_tax and base_unit_price_incl_tax.
--  120608  MaAnlk   Bug 103216, Added new method Is_Change_Config_Allowed.
--  120601  GiSalk   Bug 102669, Modified Unpack_Check_Insert___(), Insert_Package___() and Change_Package_Structure___() not to inherit values for default_addr_flag, ship_via_code and 
--  120601           delivery_leadtime from package headers to their component parts.
--  120509  Hasplk   Modified method Check_Base_Part_Config__ to check configuration id or configuration state based on a setting in configuration family.
--  120412  AyAmlk   Bug 100608, Increased the column length of delivery_terms to 5 in view ORDER_QUOTATION_LINE.
--  120323  ChJalk   Modified the method Create_Order_Line___ to avoid removing CHR(30) from current_info_.
--  120302  Hasplk   Added function Check_Lines_Config_Valid to check the state of configuration.
--  120302  Hasplk   Modified method Check_Base_Part_Config__ to check configuration id instead of configuration state.
--  120313  MoIflk   Bug 99430, Added function Get_Inverted_Conv_Factor and Modified view ORDER_QUOTATION_LINE, 
--  120313           methods Prepare_Insert___, Unpack_Check_Insert___, Insert___, Unpack_Check_Update___, Update_Line___
--  120313           and include the inverted_conv_factor into calculation where conv_factor used.
--  120312  NaLrlk   Added method Get_Next_Rel_No to fetch correct rel_no to client.
--  120126  DaZase   Added method Get_Possible_Sales_Promo_Deal and a call to it from Post_Insert_Actions___.
--  111215  MaMalk   Modified Insert___ to remove the setting of objversion_ and move Get_Id_Version_By_Keys___ to the end of this procedure.
--  111018  MaRalk   Modified methods Unpack_Check_Update___,Get_Line_Defaults___, Update___, Post_Insert_Actions___ by adjusting the parameters  
--  111018           for the method calls in Sales_Price_List_API and Customer_Order_Pricing_API packages.
--  111018           Modified method Insert_Package___. Removed two IN parameters part_level_db_, part_level_id_ from Get_Quote_Line_Price method.
--  110930  MaMalk   Modified Create_Order to prevent transferring Sales Promotion Charges to the CO.
--  110929  MaRalk   Modified INVALID_PRICELIST as en error message in both Check_Before_Insert___ and Check_Before_Update___ methods.
--  110928  ChJalk   Added the column FEE_CODE_CHANGED and modified the methods Insert___, Unpack_Check_Insert___, Update___ and Unpack_Check_Update___ to handle it. Modified the method Modify_Fee_Code__ 
--  110928           value of it when changed fee_code. Modified Modify__ to handle removing adding tax lines when multiple tax lines are there.
--  110926  MaRalk   Modified methods Check_Before_Insert___ and Check_Before_Update___ by adding the check Sales_Price_List_API.Is_Valid_Assort 
--  110926           to avoid the info INVALID_PRICELIST for parts in an assortment node. 
--  110831  MaMalk   Modified Post_Insert_Actions___ to change the conditions for calling Customer_Order_Charge_Util_API.New_Quotation_Charge_Line.
--  110826  MaMalk   Modified Update___ to change the conditions for calling method Customer_Order_Charge_Util_API.New_Quotation_Charge_Line since in an 
--  110826           insert this method will be called twice due to the incorrect conditions we have in Update___.
--  110824  ChJalk   Bug 95597, Modified the methods Check_Before_Insert___ and Check_Before_Update___ to add IN parameter catalog_no to the method call Sales_Price_List_API.Is_Valid. 
--  110815  SudJlk   Bug 93948, Modified Unpack_Check_Update___ changing the method call to Set_Demand_Qty from Set_Demand_Qty_And_Date__.
--  110812  AmPalk   Bug 97354, Modified code to facilitate info. massages from multiple order lines but from a single order header. 
--  110812           Modified code in Create_Order, by setting current_info_ to null after creation of order line.
--  110805  Darklk   Bug 96328, Modified procedures Unpack_Check_Update___ and Update___ to recalculate sale_unit_price and base_sale_unit_price of configured sales part.
--  110707  ChJalk   Removed VIEW_UIV and added user_allowed_site filter to the base view. Modified the usage of base view with the order_quotation_line_tab.
--  110524  MaMalk   Modified Validate_Fee_Code___ to consider the supply country when no value for the delivery country is found for the tax class.
--  110523  JuMalk   Bug 94815, Modified method Update___ restructured the code and removed
--  110523           methods Quote_Line_Tax_Lines_API.Add_Sales_Tax_Lines and Quote_Line_Tax_Lines_API.Remove_Sales_Tax_Lines.
--  110510  MaMalk   Modified method Update___ to update the tax information of line connected charge lines.
--  110509  AmPalk   Bug 96073, Added Recalc_Line_Tot_Net_Weight.
--  110509  ChJalk   Modified the method Get_Supply_Chain_Defaults___ to avoid unnecessarily getting Ship Via Values.
--  110505  ChJalk   Modified the methods Insert___and Update___ to change the calculation of weight_net to consider the weight defined in configuration specification.
--  110427  NaLrlk   Modified the Unpack_Check_Update___ to refetch the sales price and price list when header customer is changed.
--  110411  Mohrlk   Modified Validate_Fee_Code___. 
--  110408  MaMalk   Modified Unpack_Check_Update___ to refetch taxes correctly when the supply country on the header is changed.
--  110406  UtSwlk   BP-4364, Modified Prepare_Insert___ to remove default freight infomation as it blocks fetching correct information from scm.
--  110331  AndDse   BP-4735, Modified check date on customer calendar for Insert___ and Update___;
--  110318  AndDse   BP-4453, Modified Get_Base_Sale_Price_Total to consider distribution calendar when adjusting for picking leadtime.
--  110318  MaMalk   Modified Unpack_Check_Update___ and Validate_Fee_Code___ to fetch the taxes correctly when the delivery_type is changed.
--  110316  MaMalk   Modified Validate_Fee_Code___ to execute a certain logic only when the new_fee_code_ is null.   
--  110302  Pawelk   EANE-3744  Removed where clause from ORDER_QUOTATION_LINE and added new view ORDER_QUOTATION_LINE_UIV.
--  110202  Nekolk   EANE-3744  added where clause to View ORDER_QUOTATION_LINE.
--  110223  MaMalk   Replaced Delivery_Fee_Code_Pub with Customer_Delivery_Fee_Code_Pub.
--  110216  AndDse   BP-4296, Fixed so there is a recalculation when the external transport calendar is removed.
--  110214  AndDse   BP-4146, Add info message when planned delivery date is moved within the date calculations.
--  110202  Mohrlk   DF-716, Added method Get_Tax_Class_Id() and Derived the correct fee code after introducing multiple tax.
--  110131  Mohrlk   Added Tax Class Id as an attribute.
--  110126  Mohrlk   Added Tax Liability as an attribute.
--  110203  AndDse   BP-3776, Modifications for external transport calendar implementation.
--  110105  AndDse   BP-3776, Added EXT_TRANSPORT_CALENDAR_ID to LU.
--  101228  AndDse   BP-3687, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to consider customer calendar.
--  101018  NWeelk   Bug 93620, Modified method Unpack_Check_Update___ by adding oldrec_.buy_qty_due and newrec_.buy_qty_due checks to the condition  
--  101217  NaLrlk   Modified the methods Check_Delete___ and Unpack_Check_Update___ to raise error message when quotation promotion exist.
--  101105  ChFolk   Added new action Consolidate_Freight___ when a quotation line is Lost.
--  101018  ChFolk   Added new function Get_Base_Sale_Price_Total which returns base price toatal for freight price list information.
--  100930  ShKolk   Modified Get_Line_Defaults___ to select input uom group passing the inventory part number.
--  100928  ChFolk   Added new public attribute freight_free and modified methods accordingly. Added new procedure Update_Freight_Free to update freight_free, based on the
--  100928           charge_amount of the connected freight charge. Added new function Get_Freight_Free_Db.
--  100924  ChFolk   Modified Update___ and Post_Insert_Actions___ to add, remove and modify freight charges.
--  100916  ChFolk   Added new attributes adjusted_weight_net, adjusted_weight_gross, adjusted_volume and modified corresponding methods.
--  100914  ChFolk   Added new procedure Fetch_Delivery_Attributes to fetch freight infomation in addition to leadtime paramerts in SCM. 
--  100914           Modified Prepare_Insert___ to insert freight infomation from header. Modified Unpack_Check_Insert___ and Unpack_Check_Update___
--  100914           to fetch freight information based on the delivery address.
--  100910  ChFolk   Added new attributes freight_map_id, zone_id and freight_price_list_no and modified corresponding methods. Modified Unpack_Check_Insert___
--  100910           and Unpack_Check_Update___ to update with the header value when default_addr_flag is checked.
--  100826  ChFolk   Modified Create_Line___ to pass forward_agent_id from quotation Line to CO line.
--  100823  ChFolk   Added new attribute forward_agent_id and modified corresponding methods. Modified Unpack_Check_Insert___ and Unpack_Check_Update___
--  100823           to update with the header value when default_addr_flag is checked.
--  100719  KiSalk   Added derived attribute server_data_change and used that to stop multiple info messages in updating.
--  101018           to prevent the information message popping up when the quantity is changed from zero to non zero value and vise versa.
--  101007  JuMalk   Bug 93363, Modified Check_Important_Fields___. Removed condition which checked the rowstate - Planned when calling method Get_Changed_State___.
--  101007           This will create history records even when the quotation line is in planned state. 
--  101005  JuMalk   Bug 93240, Added condition to check the header state in Get_Allowed_Operations__ when Cancelling the quotation
--  100930  SaJjlk   Bug 93168, Modified method Create_Line___ to add the COST only for configured parts with COST PER CONFIGURATION.
--  100927  JuMalk   Bug 93240, Added condition to check the header state in Get_Allowed_Operations__.
--  100806  AmPalk   Bug 91492, Added parameters to Create_Order.
--  100614  RaKalk   Bug 91144, Modified procedure Validate_Vendor_No___ to allow NULL vendor no for PD, PT supply codes.
--  100526  ShVese   Added the method Quotation_Changed___ and called it from Finite_State_Machine___.
--  100525  MaAnlk   Bug 90829, Removed function Get_Object_Version.
--  100520  KRPELK   Merge Rose Method Documentation.
--  100422  MaAnlk   Bug 79609, Added Get_Object_Version. Modified Unpack_Check_Update___.
--  100323  MaRalk   Bug 89666, Added procedure Get_Calculated_Pkg_Cost in order to use in client to calculate package part cost when changing the quantity.
--  100104  MaRalk   Modified the state machine according to the new developer studio template - 2.5.
--  091228  MaEelk   Replace obsolete calls Interim_Order_Int_API.Set_Demand_Qty_And_Date, Interim_Order_Int_API.Remove_Interim_Head_By_usage,
--  091228           Interim_Order_Int_API.Transfer_Usage and Interim_Order_Int_API.Get_Int_Head_By_Usage with 
--  091228           Interim_Demand_Head_API.Set_Demand_Qty_And_Date, Interim_Demand_Head_API.Remove_Interim_Head_By_usage,
--  091228           Interim_Demand_Head_API.Transfer_Usage and Interim_Demand_Head_API.Get_Int_Head_By_Usage respectively.
--  091124  MaRalk   Added reference CustomerOrderLine to the column con_line_item_no in the view ORDER_QUOTATION_LINE. 
--  090930  MaMalk   Removed constant state_separator_. Modified Insert_Package___, Check_Before_Insert___, Check_Before_Update___, Finite_State_Init___ 
--  090930           and Create_Order_Line___ to remove unused code.
--  ------------------------- 14.0.0 -------------------------------------------
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  100407  ShKolk   Modified Update___ to handle Pack size charge creation.
--  091203  ChJalk   Bug 86009, Added procedure Modify_Wanted_Delivery_Date__.
--  090922  AmPalk   Bug 70316, Made base amounts to get calculated using curr amounts as in the INVOIC side. Modified Get_Base_Sale_Price_Total and Get_Total_Tax_Amount.
--  090922           Added Get_Total_Tax_Amount_Curr.
--  090831  ChJalk   Bug 83838, Modified the method Update___ to modify discounts when price source is changed. 
--  090803  ChFolk   Bug 81668, Modified method Unpack_Check_Insert___ to avoid inserting expired tax codes. Modified Post_Insert_Actions___ in order to avoid invalid
--  090803           tax codes to be fetched from the customer and to raise an information message when no valid tax code is fetched.
--  091120  DaZase   Added price_source_net_price to the view.
--  090930  DaZase   Added length on view comment for input_unit_meas and input_variable_values,
--  090709  IrRalk   Bug 82835, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to round weight to 4 decimals.
--  090410  SuJalk   Bug 79924, Modified the Update___ method to save the correct value for sale_unit_price.
--  090316  SudJlk   Bug 80264, Modified Check_Before_Insert___ to modify value setting for del_terms_location when a customer agreement exists.
--  090130  SudJlk   Bug 76805, Modified methods Update_Planning___, Cancel_Planning___ and Release_For_Planning to display error messages 
--  090130           with a possible delivery date after online consumption check.
--  081215  ChJalk   Bug 77014, Modified Get_Base_Sale_Price_Total replacing base_sale_unit_price with sale_unit_price * currency_rate.
--  081205  ThAylk   Bug 78554, Modified method Get_Line_Defaults___ to add FEE_CODE to attr_. 
--  081015  ThAylk   Bug 74618, Added if condition to prevent setting delivery_date_changed_ to TRUE when the delivery leadtime and ship_via_code has not been changed. 
--  080818  DaZase   Bug 76376, Corrected declaration of fee_code_ in method Validate_Fee_Code___.
--  080806  ChJalk   Bug 76093, Modified the methods Insert___ and Update___ to take the weight_net from Inventory part if that information is not 
--  080806           available in sales part table.
--  090624  KiSalk   Changed call Customer_Order_Pricing_API.Get_Valid_Price_List to Sales_Price_List_API.Get_Valid_Price_List.
--  090401  DaZase   Added new columns part_level, part_level_id, customer_level and customer_level_id used these in calls to Get_Quote_Line_Price_Info. 
--  090401           Also added these columns to methods Create_Line___.
--  090122  DaZase   Resizing price_source_ variable in methods Insert_Package___, Get_Quote_Line_Price, Get_Line_Defaults___ and view comment.
--  090120  DaZase   Added parameters to call Customer_Order_Pricing_API.Get_Valid_Price_List inside method Get_Line_Defaults___.
--  081001  MaJalk   Set net_price_fetched_ as FALSE at Get_Quote_Line_Price and Get_Line_Defaults___.
--  080925  MaJalk   At Get_Line_Defaults___, check for cust_usage_allowed when adding INPUT_UNIT_MEAS and INPUT_CONV_FACTOR.
--  080912  MaJalk   Added zone details to call Cust_Order_Leadtime_Util_API.Get_Ship_Via_Values.
--  080911  MaJalk   Added zone_definition_id_ and zone_id_ to call Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Defaults at Get_Supply_Chain_Defaults___.
--  080902  MaJalk   At update___, set creation of charge lines when price_source_net_price is FALSE.
--  080829  MaJalk   Modified conditions to create charge lines at Update___.
--  080825  AmPalk   Changed Insert___ and Update___ by adding call  Sales_Weight_Volume_Util_API.Get_Total_Weight_Volume to get totals.
--  080818  MaJalk   Modified Cancel_Planning___ to remove connected charge lines. 
--  080815  MaJalk   Moved the logic which create, remove or modify charge line to Customer_Order_Charge_Util_API. 
--  080812  MaJalk   Corrected the call Cust_Ord_Customer_API.Get_Receive_Pack_Size_Chg to get Db value at Update___ and Post_Insert_Actions___.
--  080811  MaJalk   Added INPUT_UNIT_MEAS and INPUT_CONV_FACTOR to attr_ at Get_Line_Defaults___.
--  080808  MaJalk   Modified Update___ and Post_Insert_Actions___ to create or modify quotation charge lines.
--  080808       Added methods Get_Input_Qty, Get_Input_Unit_Meas, Get_Input_Conv_Factor and Get_Input_Variable_Values.
--  080714  MaJalk   Added input_qty, input_unit_meas, input_conv_factor, input_variable_values to attr at Create_Line___.
--  080701  MaJalk   Merged APP75 SP2.
--  --------------------- APP75 SP2 Merge - End --------------------------------
--  080515  SuJalk   Bug 70772, Added dummy_info_ as a variable within Create_Line___ method and passed it as a parameter to method call Configured_Line_Price_API.Transfer_Pricing__.
--  080228  ThAylk   Bug 71246, Added method Validate_Jinsui_Constraints___.
--  --------------------- APP75 SP2 Merge - Start ------------------------------
--  080625  MaJalk   Added attributes input_qty, input_unit_meas, input_conv_factor, input_variable_values.
--  080606  MiKulk   Modified the Unpack_Check_Update__ to modify the charged_qty of the connected charge lines accordingly.
--  080318  KiSalk   Added attributes classification_part_no, classification_unit_meas, classification_standard and methods Get_Classification_Part_No, Get_Classification_Standard.
--  080313  AmPalk   Merged APP75 SP1.
--  --------------------------------- APP75 SP1 merge - End --------------------
--  080130  NaLrlk   Bug 70005, Added public attribute del_terms_location and Modified methods Insert_Package___, Check_Before_Insert___, Check_Before_Update___
--  080130           Post_Insert_Actions___, Create_Line___, Modify_Quote_Defaults__ with del_terms_location attribute.
--  071227  ChJalk   Bug 69400, Added CATALOG_TYPE_DB into attr_ in Get_Line_Defaults___. Removed Error message NOT_ACTIVE from Check_Before_Insert___
--  071227           and Modified Modified Error message to an Info message in Get_Line_Defaults___.
--  071210  MaRalk   Bug 66201, Modified Insert___ and Update___ in order to correctly calculate net weight and volume of the quotation line.
--  071018  LeSvse   Bug 67815, Added warning message if quantity modified for configured line in Unpack_Check_Update.
--  --------------------------------- APP75 SP1 merge - Start --------------------
--  080216  AmPalk   Modified method calls to Get_Quote_Line_Price_Info receiving net_price_fetched value and inserted it to the Quotation Line.
--  080216  AmPalk   Added attribute price_source_net_price.
--  --------------------------------- NicePrice ----------------------------------
--  070913  ChBalk   Bug 67061, Modified method Check_Before_Insert___, validation was introduced for pkg parts.
--  070903  JaBalk   Added an error message CANTMODIFYOQ in Check_Important_Fields___ and CANTMODIFYCANLINE in Unpack_Check_Update___. 
--  070903           Corrected the error messages WRONG_PROBABILITY1, WRONG_PROBABILITY2 by merging the word 'can not' to 'cannot'
--  070629  MaJalk   Bug 64918, Removed 'P' from mrp_order_code list, for supply_code = 'DOP' check.  
--  070627  MiKulk   Bug 61765, Modified Update_Planning___, Cancel_Planning___ and Release_For_Planning___ by changing the Control_Ms_Mrp_Consumption__ as public method calls.
--  070626  MaMalk   Bug 65873, Modified method Check_Before_Insert___ to raise an error for inactive sales parts.
--  070620  NiDalk   Bug 65475, Modified Get_Changed_State___ to track the changes of Configuration id in quotation line.
--  070523  RaKalk   Modified Unpack_Check_Update___ to recalculate cost when quantity changes.
--  070519  RaKalk   Unpack_Check_Update___, Get_Line_Defaults___, Insert_Package___ to pass correct configuration_id to the Sales_Cost_Util_API.Get_Cost_Incl_Sales_Overhead method
--  070519  MiKulk   Modified the method Check_Important_Fields___ to call the Finite_State_Machine___ even for the Cancelled, Lostand Won quotation lines for pkg components,
--  070519           So that it will raise a proper error message informing the user that it is not allowed to update those component lines. 
--  070519  MaMalk   Modified Get_Changed_State___ and Check_Before_Update___ to prevent changing condition code when the status is cancelled, lost and won.
--  070516  AmPalk   Added parameter info_ to the procure Create_Order. Added code to capture the info_ param. from New - Customer_Order_Line in Create_Line___.
--  070516           Modified Create_Order_Line___ by calling Add_Info___ after call Create_Line___.
--  070515  NiDalk   Modified Get_Changed_State___ to consider package parts also when checking pices.
--  070508  AmPalk   Bug 64838, Modified the method Modify_Discount__ so that it will directly call Unpack_Check_Update___ and Update___ methods, without going through Modify_Line__.
--  070302  MaMalk   Bug 63189, Modified the condition that raises the error when discount exceeds 100, by removing the condition added by Bug 62020.
--  070130  NaWilk   Bug 62020, Modified Check_Before_Update___ to change the condition that raises the error when discount exceeds 100.
--  070130           Modified the error msg in both Check_Before_Insert___ and Check_Before_Update___ to be meaningful.
--  070129  NaWilk   Bug 62645, Modified cursor in Validate_Fee_Code___ to select from delivery_fee_code_pub only the values with party_type = 'CUSTOMER'.
--  070126  ChBalk   Added revised_qty_due when calculating Sales Overhead Cost.
--  070122  Cpeilk   Removed attributes ship_via_desc and delivery_terms_desc.
--  070118  SuSalk   Code cleanup, removed ship_via_desc external references & called Mpccom_Ship_Via_API.Get_Description.
--  070104  RaKalk   Added SalesQty parameter to the calls to Sales_Cost_Util_API.Get_Cost_Incl_Sales_Overhead method
--  061220  ChBalk   Replaced the call to method Inventory_Part_Cost_API.Get_Cost with call to Sales_Cost_Util_API.Get_Cost_Incl_Sales_Overhead.
--  061219  RaKalk   Made attribute Charged_Item public
--  061124  KaDilk   Bug 61506, Modifed the Unpack_Check_Update method to assign values to customer_no and ship_addr_no in newrec_ if they are null.
--  060804  NaWilk   Added lamguage code parameter in call to Sales_Part_API.Get_Catalog_Desc in method Get_Line_Defaults___.
--  060720  RoJalk   Centralized Part Desc - Use Sales_Part_API.Get_Catalog_Desc.
--  060728  ChJalk   Replaced Mpccom_Ship_Via_Desc and Order_Delivery_Term_Desc with Mpccom_Ship_Via and Order_Delivery_Term.
--  060728  KaDilk   Make ship via desc and delivery term desc language independant.
--  060602  MiErlk   Enlarge Description - Changed view comments .
--  060601  RoJalk   Enlarge Part Description - Changed variable definitions.
--  060517  MiErlk   Enlarge Identity - Changed view comment
--  060508  JaJalk   Modified the method Insert_Package___ to synchronize the tax free fee code with the order.
--  060508  KanGlk   Modified procedure Create_Line___.
--  060428  RaKalk   Modified Post_Insert_Action___ method to prevent it from creating charge lines for
--  060428           the components of the package lines.
--  060425  IsAnlk   Enlarge Supplier - Changed variable definitions.
--  060424  RaKalk   Modified Post_Insert_Actions___ method to call
--  060424           Order_Quotation_Charge_API.Copy_From_Sales_Part_Charge method
--  060419  NaLrlk   Enlarge Customer - Changed variable definitions.
--  060410  IsWilk   Enlarge Identity - Changed view comments of customer_no.
--  ------------------------- 13.4.0 -----------------------------------------
--  060223  MiKulk   Modified the Validate_Fee_Code to fetch the sales part fee code only in the VAT regime.
--  060222  MiKulk   Modified the Update___ to correctly handle the tax codes. Manual merge of 51197
--  060222  SaJjlk   Added further validations in method Validate_Fee_Code___ to correctly fetch the fee code when sales tax is used.
--  060221  MiKulk   Manual merge of the bug 51197.
--  060220  UsRalk   Modified Create_Line___ to transfer pricing details to Customer Order Line correctly.
--  060211  OsAllk   Added a method Cancel_Order_Line.
--  060209  Samnlk   Added a new function Get_Total_Discount, to calculate the total discount of order quotation line.
--  060130  IsWilk   Added the PROCEDURE Check_Delivery_Type__ and mofified the reference of delivery_type.
--  060124  JaJalk   Added Assert safe annotation.
--  060105  IsWilk   (LCS Patch 552901)Modified info messages NOTVATFREEVAT to NOTTAXFREETAX
--  060105           in PROCEDURE Check_Before_Insert___ , Check_Before_Update___.
--  051208  ChJalk   Bug 54709, Modified the Procedure Create_Line___, added CONFIGURATION_ID into the attribute string.
--  051208  MaJalk   Bug 54614, In function Check_Quote_Line_For_Planning, added Revised state to the cursor.
--  051207  ThGulk   Bug 54659, Modified method Modify_Quote_Defaults__, Modified WHERE condition and added an IF condition to check Customer_no
--  051125  MaMalk   Bug 54623, Modified Change_Package_Structure___ in order to fetch the value of Release_Planning from package header to the components.
--  051028  JeLise   Bug 54163, Replaced use of price_list_refresched with price_source_refreshed
--  051028           in Check_Before_Update___, Unpack_Check_Update___ and Update___.
--  051021  IsWilk   Modified the PROCEDURE Prepare_Insert___ to remove the delivery_type from attr_.
--  051021  IsWilk   Modified the PROCEDURE Unpack_Check_Insert to fetch the delivry_type from the Sales_Part_API.
--  051006  IsWilk   Modified the PROCEDURE Update_Line___ to add the cancel_reason.
--  051004  IsWilk   Added the PROCEDURE Set_Cancel_Reason.
--  051004  IsWilk   Added the public attribute cancel_reason.
--  051003  Cpeilk   Bug 53468, Modified Check_Before_Update___ to raise error messages only when delivery address gets modified.
--  050927  IsAnlk   Modified calls to Customer_Order_Pricing_API.Get_Base_Price_In_Currency, Get_Sales_Price_In_Currency to pass customer_no.
--  050921  NaLrlk   Removed unused variables.
--  050829  VeMolk   Bug 52955, Modified procedure Create_Line___ and removed BASE_SALE_UNIT_PRICE and CURRENCY_RATE
--  050829           from the attribute string sent to the method Customer_Order_Line_API.New.
--  050819  DaZase   Made changes in how delivery dates are handled in Create_Line___.
--  050817  DaZase   Added some history handling in method Update_Planning_Date__.
--  050701  DaZase   Moved ctp/interim order updates functionality from Update___ to Unpack_Check_Update___ because we
--                   need to do this before the date calculations so we can get new default dates.
--                   Also made Modify__ use current_info_ gathered from Unpack_Check_Update___.
--  050620  SeJalk   Bug 51906, Modified procudure Update___ to remove quatation line discount records when sales quantity is zero.
--  050609  DaZase   Added promised_delivery_date setting in method Update_Planning_Date__.
--  050607  RaSilk   Added null parameter to call Order_Config_Util_API.Update_Configuration__ in method Update___.
--  050531  IsWilk   Removed the column warranty.
--  050527  DaZase   Added planned_delivery_date to the attribute string in method Clear_Ctp_Planned.
--  050503  JoEd     Bug 49796. Added created_by_server default value in call to Get_Line_Defaults___
--                   from Get_Default_Part_Attributes___.
--  050404  JoEd     Bug 49796. Added fetch of primary supplier for PD and PT in Get_Line_Defaults___ -
--                   like it's already done for IPD and IPT.
--                   Also present a message if sourcing option 'PRIMARYSUPP...' and no
--                   primary supplier is found in Get_Line_Defaults___ and Insert_Package___.
--                   Added info handling for Get_Cust_Part_No_Defaults__.
--  050310  SaLalk   Bug 49337, Added an implementation method Header_Revised___ and modified Finite_State_Machine___.
--  050217  DaZase   Added method Get_Interim_Order_No. Added ctp_planned to call to Order_Config_Util_API.Update_Configuration__.
--  050207  SaJjlk   Removed unused method Recalculate_Salesprice.
--  050211  JICE     Bug 49187, Doesn't clear error message for minimum_qty when using package parts.
--  050203  JoEd     Added supply_site_due_date to Calc_Quotation_Dates call.
--  050203  NaLrlk   Removed views VIEW_QUOT_DEMAND,VIEW_QUOT_DEMAND_CUSTORD,VIEW_QUOT_MS,VIEW_QUOT_EXT.
--  050201  JICE     Bug 49187, Added handling of minimum_qty on SalesPart.
--  050131  JoEd     Changed calls to CustOrdDateCalculation.
--  050131  DaZase   Added allocate_db_ to Update_Planning_Date__ and Update_Planning_Date. Added latest_release_date in method Clear_Ctp_Planned.
--                   Added call to Clear_Ctp_Planned in Cancel_Planning___.
--  050112  DaZase   Made some changes on the error message QLCTPWRONGACQTYPE and added IPT/IPD on the check for this error.
--  050111  DaZase   Changed some old calls to Interim_Order_Int_API so they now instead call Interim_Ctp_Manager_API for capability checked lines.
--  041209  DaZase   Replaced earliest_start_date with latest_release_date. Removed the default value setting of earliest_start_date,
--  041209           latest_release_date will now only get a value from the Capability Check engine. Added latest_release_date
--  041209           as a param to Update_Planning_Date__ and Update_Planning_Date.
--  041209  IsAnlk   Modified Procedure Update___ to modify tax lines correclty.
--  041203  DaZase   Removed error message NODOPSUPPLY in Check_Supply_Code___ and replaced it with
--  041203           a new check on mrp_order_code and a new error message MRPCODEPNNOTALLOWED.
--  041123  NiRulk   Bug 44599, Modified procedure Update_Planning_Date__.
--  041112  DiVelk   Modified Check_Supply_Code___.
--  041109  ChBalk   Bug 47747, Added replacement part functionality. Modified Get_Line_Defaults___ and Insert_Package___ methods.
--  041027  JOHESE   Modified VIEW_DEMAND_CUSTORD and VIEW_EXT
--  041026  DiVelk   Modified Check_Supply_Code___.
--  041022  DiVelk   Modified Check_Supply_Code___.
--  041022  NuFilk   Added function Get_Total_Line_Tax_Pct and Get_Base_Sale_Price_Total and modified Get_Total_Tax_Amount and Get_Line_Defaults___.
--  041014  KeFelk   Added Get_Total_Tax_Amount.
--  040909  MaMalk   Bug 46595, Modified Check_Before_Insert___ and Check_Before_Update___ to raise error messages for invalid addresses.
--  040720  UsRalk   Merged LCS patch 45615.
--  040713  MiKulk   Bug 45615, Modified the methods Post_Insert_Actions___and Update__ to enable the discount calculation for the prospect customers.
--  040713           Also modified the Update__ to correctly calculate the quotation line discount when the price list no is deleted.
--  040628  AnHose   Bug 45489, Added supply type SRC, Automatic Sourcing in Check_Supply_Code___.
--  040609  Asawlk   Bug 44917, Modified Check_Before_Insert___ and Check_Before_Update___, raised errors when a
--  040609           Condition Code is entered for a Package Part or a Non Inventory Sales Part.
--  040511  JaJalk   Corrected the lead time lables.
--  040510  KaDilk   Bug 44464,Removed the dynamic call to Delivery_Fee_Code_API in procedure Post_Insert_Actions___.
--  040427  WaJalk   Modified method Get_Allowed_Operations__.
--  040426  MaMalk   Bug 37374, Removed Update_Package_Charprice___ and modified the procedures Update___,Post_Insert_Actions___, Delete___,
--  040426           Recalc_Package_Structure__  and Unpack_Check_Insert___.
--  040421  KiSalk   SCHT603 Supply Demand Views - Removed view SALES_QUOTATION_LINE_SIM.
--  040416  LoPrlk   SCHT603 Supply Demand Views - Removed the column wanted_due_date from all the views in change "040415  LoPrlk".
--  040415  KiSalk   SCHT603 Supply Demand Views - Added the column qty_reserved to the views SALES_QUOTATION_LINE_DEMAND, SALES_QUOTATION_LINE_DEMAND_OE,
--  040415           SALES_QUOTATION_LINE_MS and SALES_QUOTATION_LINE_EXT.
--  040415  LoPrlk   SCHT603 Supply Demand Views - Added the column wanted_due_date to the views SALES_QUOTATION_LINE_DEMAND, SALES_QUOTATION_LINE_DEMAND_OE,
--  040415           SALES_QUOTATION_LINE_MS and SALES_QUOTATION_LINE_EXT.
--  040415  NaWalk   SCHT603 Supply Demand Views - Added column qty_pegged to views SALES_QUOTATION_LINE_DEMAND,SALES_QUOTATION_LINE_DEMAND_OE
--  040415           SALES_QUOTATION_LINE_MS , SALES_QUOTATION_LINE_EXT .
--  040309  LoPrlk   Column comments were altered.Some calls to General_SYS.Init_Method and all calls to Trace_SYS were removed.
--  040309           Some comments were removed. Lengths of some variables were altered. Method Check_State was removed.
--  040303  LoPrlk   Merge split packages. Column comments were altered, some codes were merged and some of them were commented,
--  040303           some code errors were corrected, some codes were relocated and some comments were removed or altered.
--  040301  LoPrlk   Merge split packages. Removed PKG2 from the file.
--  040301  LoPrlk   Merge split packages. Moved the method Create_Line___ from PKG2 to PKG.
--  040301  LoPrlk   Merge split packages. Moved the method Create_Order_Line___(5 params) from PKG2 to PKG. Some codes were relocated.
--  040301  LoPrlk   Merge split packages. Moved the method Get_Changed_State___ from PKG2 to PKG.
--  040301  LoPrlk   Merge split packages. Moved the methods Get_Line_Defaults___ and Get_Default_Part_Attributes___ from PKG2 to PKG.
--  040301  LoPrlk   Merge split packages. Moved the method Add_Info___ from PKG2 to PKG.
--  040301  LoPrlk   Merge split packages. Removed PKG3 from the file.
--  040301  LoPrlk   Merge split packages. Moved the method Get_Supply_Chain_Defaults___ from PKG3 to PKG.
--  040301  LoPrlk   Merge split packages. Moved the methods Check_Supply_Code___, Check_Before_Insert___
--  040301           and Check_Before_Update___ from their corrosponding packages to PKG.
--  040227  LoPrlk   Merge split packages. Moved the method Prepare_Insert___ from PKG3 to PKG.
--  040227  LoPrlk   Merge split packages. Moved the methods Validate_Vendor_No___, Exist_Vendor_No___,
--  040227           Retrieve_Default_Vendor___ and Validate_Vendor_Category___ from PKG3 to PKG.
--  040227  LoPrlk   Merge split packages. Moved the methods Get_Object_By_Keys___, Unpack_Check_Insert___,
--  040227           Unpack_Check_Update___ and Calculate_Quote_Line_Dates___ from PKG3 to PKG.
--  040224  IsWilk   Removed the SUBSTRB from the view and modified the SUBSTR to SUBSTR for Unicode Changes.
--  040129  GeKalk   Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  040126  SeKalk   Bug 41397, Modified procedure Modify_Quote_Defaults__.
--  040116  SeKalk   Bug 41033, Modified procedures Check_Before_Insert___, Get_Supply_Chain_Defaults___
--  ********************* VSHSB Merge End *************************
--  021107  GeKalk   Added the length of the self_billing in the view comments of ORDER_QUOTATION_LINE view.
--  021018  Prinlk   Ammended definition for Quotation_Line_Charge_Lov modified. Made attribute self_billing public.
--  021010  GeKalk   Added the column self_billing to the Order_Quotation_line_tab and view.
--  021008  Prinlk   Added the column self_billing. Quotation_Line_Charge_Lov definition has been changed.
--  ********************* VSHSB Merge *****************************
--  040114  LoPrlk   Rmove public cursors, Method Insert_Package___ was altered, cursor get_pkg_ingridients was added
--  040114           and calls for Sales_Part_Package_API.Get_Package_Ingridients were substituted by calls to get_pkg_ingridients.
--  ************************* 13.3.0 ******************************
--  031022  DaZa     Added extra check on wanted_delivery_date in Change_Package_Structure___ before you call Calculate_Quote_Line_Dates___.
--  031022  JoAnSe   Added vendor_no in the UPDATE statement in Update_Line___
--  031021  JoAnSe   Removed defaults for SHIP_VIA_CODE, SHIP_VIA_DESC and DELIVERY_LEADTIME
--                   in Prepare_Insert__ and Unpack_Cheeck_Insert___.
--                   Default values will be generated when calling Get_Supply_Chain_Defaults___.
--  031017  JoAnSe   vendor_no passed to CO line when created in Create_Line___
--  031015  PrJalk   Bug Fix 106224, Corrected wrong General_Sys.Init_Method calls for Implementation methods delared in Package.
--  031013  PrJalk   Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  031009  JoEd     Changed date recalculation logic. Removed EARLY_DATE message.
--  031007  DaZa     Added handling of block_component_info_ so we can block unnecessary info messages from the component lines.
--  031002  JoEd     Changed parameters to Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Defaults.
--  030929  JoEd     Added public attribute VENDOR_NO.
--                   Cleaned up the code to correspond to the object model.
--                   Ran the file through IFS/Design.
--  030929  JaJalk   Modified the method Insert_Package___ to fetch the tax codes fo the components parts.
--  030918  JoEd     Added method Get_Supply_Chain_Defaults___ to fetch default ship via code
--                   and delivery leadtime on insert and update.
--  030915  JoEd     Added supplier part no to date calculation methods.
--  030903  JoAnSe   Changed the cost retrieval.
--  030902  ChBalk   CR Merge 02.
--  030827  NaWalk   Performed Code Review.
--  030827  UdGnlk   Added comment lines from CR.
--  030818  SaNalk   Performed CR Merge.
--  030716  NaWalk   Removed Bug coments.
--  030630  JoEd     Rewrote Calculate_Quote_Line_Dates___ and Update_Planning_Date__
--                   to use general date calculation methods. Removed Calculate_Planned_Due_Date___.
--                   Changed date calculation in Insert_Package___ and Change_Package_Structure___.
--  030512  JoEd     Changed supply_code logic. Removed use of so_flag and purchase_flag
--  030508  MiKulk   Bug 37141, Modified the procedure Create_Order_Line___, to get an error message
--  030508           when an order line is created for a salespart with a replacement part.
--  030505  DaZa     All occurences of acquisition type/mode changed to supply code.
--  ************************* CR Merge *******************************************
--  030814  ChIwlk   Modified procedures New__ and Update__ to remove information message on condition code pricing.
--  030730  AjShlk   Merged bug fixes in 2002-3 SP4
--  030729  ChIwlk   Modified procedures New__ and Update___ to add an information message.
--  030612  UsRalk   Bug 97966 - Added code to update Customer Order Line after transferring tax data from quotation line [Create_Order_Line___].
--  030610  ChIwlk   Changed procedure Get_Quote_Line_Price to add parameter condition_code_.
--  030609  SaAblk   Removed views SALES_QUOTATION_LINE_DEMAND1 and SALES_QUOTATION_LINE_MS2
--  030609           Removed methods Has_Options, Has_Options___, Clear_Options and Clear_Options___
--  030519  ChFolk   Applied code review changes.
--  030513  ChFolk   Modified an error message in Validate_Fee_Code__.
--  030508  MiKulk   Bug 37141, Modified the procedure Create_Order_Line___, to get an error message
--  030508           when an order line is created for a salespart with a replacement part.
--  030506  ChFolk   Call ID 96789. Modified the inconsistent error messages.
--  030502  ChFolk   Modified Validate_Fee_Code__ and it is called from Update___ instead of Unpack_Check_Update___.
--  030428  ChFolk   Modified Post_Insert_Actions___ to modify charge line fee code with the tax line fee_code when only one tax line exist.
--  030424  ChFolk   Modified PROCEDURE Modify__ to add/remove tax lines when changing of fee_code.
--  030417  ChFolk   Added FUNCTION Get_Effective_Tax_Regime__.
--                   Modified parameters of PROCEDURE Validate_Fee_Code__.
--  030411  ChFolk   Modified procedure Update___ to modify Add/Remove charge tax lines when pay tax or delivery address of a quotation line connected to a charge line is changed.
--  030404  MiKulk   Bug 36368, Increased the length of the Lose Win Note.
--  030402  SaNalk   Added the cursor 'min_tax_id' to PROCEDURE Modify__.
--  030401  SaNalk   Modified procedure Modify_Fee_Code to Modify_Fee_Code__.Modified adding tax lines in procedure Post_Insert_Actions___.
--  030328  ChFolk   Modified procedure Update___ to Add/Remove charge tax lines when pay tax or delivery address of a quotation line connected to a charge line is changed.
--  030328  SaNalk   Change the place of call to Validate_Fee_Code__ in Procedures Unpack_Check_Insert___ and Unpack_Check_Update___.
--  030327  SaNalk   Modified the PROCEDURE Modify__, to work with 'Pay Tax' check box.Added the parameter ship_addr_no_ to PROCEDURE Validate_Fee_Code__.
--  030324  SaNalk   Modified PROCEDURE Validate_Fee_Code__ for db values of customer tax regime.
--  030321  SaNalk   Modified the PROCEDURE Modify__ to modify the tax lines dialog box.Removed checks for company vat code in
--                   Procedures Check_Before_Insert___ and Check_Before_Update___.
--  030320  SaNalk   Removed Checks for Tax code in PROCEDURE Post_Insert_Actions___.
--  030319  SaNalk   Added the PROCEDURE Modify_Fee_Code.Added coding in Unpack_Check_Update___, to modify the dialog box fee codes , when the line fee code is modified.
--  030314  SaNalk   Added the PROCEDURE Validate_Fee_Code__ to validate tax codes according to Company and customer.
--                   Called this procedure in Unpack_Check_Insert___ & Unpack_Check_Update___
--  030311  SaNalk   Made a check for sales part VAT code if customer's tax regime is 'VAT' or 'Mixed', in PROCEDURE Check_Before_Insert___.
--                   Modified the PROCEDURE Update___ to consider Customer's tax regime.
--  030218  ChJalk   Bug 35851, Modified PROCEDURE Modify_Quote_Defaults__. This modified the corrections done for bug 33863 and Bug 29018.
--  030218  UdGnlk   Design History modification.
--  030214  UdGnlk   TSO Merge(From Take Off changes To Salsa).
--  030206  PrTilk   Bug 35314, Modified the PROCEDURE Create_Line___. Added values line_no, rel_no,
--  030206           line_item_no to the attr string when the line_item_no is <= to 0.
--  030131  ErSolk   Bug 35514, Added conditions in Update_Grad_Price_Line to update customer unit sales quantity.
--  030108  ErSolk   Bug 33457, Added conditions to display messages when updating qty on component part
--  021209  ChJalk   Bug 34472, Modified method Get_Sale_Price_Total.
--  020830  Nabeus   Moved the condition code validation to Check_Before_Update___ method.
--                   Added validation for change of condition code if Quotation is closed. Call 88274.
--  020828  Nabeus   Changed Get_Line_Defaults___ method to pass condition code in attr in order
--                   set for a new record. Changed Create_Line___ to pass the condition code from
--                   Order quotation to Customer order line. Call - 88304.
--  020711  NabeUs   Changed Unpack_Check_Insert___ and Unpack_Check_Update___ to validate
--                   part is condition code enabled or not.
--  020628  MaEelk   Change Comments on CONDITION_CODE in ORDER_QUOTATION_LINE.
--  020611  Maeelk   Added new public attribute CONDITION_CODE to the LU.
--  ------------------------------------- TSO Merge -----------------------------
--  030101  SaNalk   Merged SP3.
--  021210  SaNalk   Removed the previous function Get_Additional_Discount and added a public function Get_Additional_Discount.
--                   Added the procedure Modify_Additional_Discount__.Added Additional Discount to view order_quotation_line.
--                   Added Coding to Handle Additional_Discount in proc: Insert___, Update_Line___, Unpack_Check_Update___ and Unpack_Check_Insert___.
--  021203  SaNalk   Modified function Get_Sale_Price_Total for additional discount.
--  021118  JSAnse   Bug 33435, Modified the procedure Check_Before_Insert___ so the quotation row gets values from an agreement if there exist one.
--  021115  SaNalk   Removed the function Get_Total_Order_Discount.Modified the procedure Check_Line_Total_Discount_Pct.
--  021112  AjShlk   Bug 33863, modified Unpack_Check_Update___, Modify_Quote_Defaults__ to ignore canelled, lost and won
--  021112           order lines when updating.
--  021107  SaNalk   Added the Procedure Check_Line_Total_Discount_Pct.
--  021107  SaNalk   Modified the function Get_Additional_Discount for quotation line states.
--  021107  MKrase   Bug 33893, Modified views SALES_QUOTATION_LINE_DEMAND, SALES_QUOTATION_LINE_DEMAND_OE
--                   SALES_QUOTATION_LINE_EXT, SALES_QUOTATION_LINE_SIM, SALES_QUOTATION_LINE_MS.
--                   and SALES_QUOTATION_LINE_MS2.
--  021106  DhAalk   Bug 33000, Removed the table join from the cursor get_line_no in Check_Quote_Line_For_Planning.
--  021105  SaNalk   Added the functions Get_Additional_Discount and Get_Total_Order_Discount.
--                   Removed General_SYS.Init_Method from function Get_Objstate.
--  021104  CaRase   Bug 33864, Added Ship via Code and Ship Addr No in function Get_Changed_State
--  021016  JeLise   Bug 33571, Changed date format from 'DD-MON-YYYY' to 'DD-MM-YYYY' in Update___.
--  021016  JoAnSe   Replaced to_date('31-DEC-4712','DD-MON-YYYY') with
--                   to_date('31-12-4712', 'DD-MM-YYYY) to avoid language problems.
--  021007  CaRase   Bug 32724, When Price Unit Meas is null fetch the value from Sale Part.
--  020925  DhAalk   Bug 33000, Modified the where condition by adding a query to join the table ORDER_QUOTATION_TAB in Check_Quote_Line_For_Planning.
--  020917  JoAnSe   Merged the IceAge bugg corrections below onto the AD 2002-3 track.
--  020830  GaJalk   Bug 29409, Modified procedures Update___ and Post_Insert_Actions___.
--  020830  KiSalk   Bug 29380, In Create_Line___ added 'PRICE_UNIT_MEAS' to attribute string
--  020821  MaGu     Bug 30098. Added fetching of default price and discount if buy_qty_due or price_list_no
--  020821           has been refreshed, i.e., updated with the same value as in the old record.
--  020821           Modified methods Check_Before_Update___, Unpack_Check_Update___ and Update___.
--  020729  KiSalk   Bug 31772, In 'Create_Line___', added 'PLANNED_DELIVERY_DATE' &
--  020729           'PROMISED_DELIVERY_DATE' to attribute string on condition.
--  020726  Hecese   Bug 29138, Modified function Insert___, changed declaration of customer_part_no_ in
--                   procedure Get_Line_Defaults___.
--  020626  SuSalk   Bug 29476, Added parameters to the attr_ in procedure Get_Line_Defaults___.
--  020626           Removed parameters from the attr_ in procedure Get_Cust_Part_No_Defaults__.
--  020606  WaJalk   Bug 29901, Modified the procedure Create_Line___.
--  020523  KiSalk   Bug 29076, Modified Create_Line___ by converting the value of WANTED_DELIVERY_DATE to date value
--  020523           and assign the promised_delivery_date to wanted_delivery_date.Also modified Create_Order_Line___
--  020520  SuSalk   Bug 29067, Added FUNCTION Get_Min_Promised_Delivery_Date.
--  020514  CaStse   Bug fix 29018, Modified Modify_Quote_Defaults__.
--  020329  ViPalk   Bug fix 27514, Added public attribute price_unit_meas to Unpack_check_update___.
--  020327  ViPalk   Bug fix 27514, Added public attribute price_unit_meas.
--  020228  NaWalk   Bug fix 27451, Added Parameter check_status to the Function 'Create Order'
--  020226  JeLise   Bug fix 27496, Added call to Get in Create_Order.
--  020221  JeLise   Bug fix 27496, Added call to Order_Quotation_Charge_API.Transfer_To_Order_Line
--                   and different checks on charges in Create_Order.
--  011128  Memena   Bug fix 25680, Modified the procedure Update___, making it possible to change
--                   quantity on an orderline connected to an Interim order. Put nvl on date comparison.
--  011116  DaRulk   Bug fix 26088, Modified Insert_Package___ for 'PROSPECT' Customer Types.
--  011026  MaGu     Bug fix 24889. Removed all corrections for bug fix 24889.
--  011024  MaGu     Bug fix 24889. Removed corrections from methods Insert_Package___ and Change_Package_Structure___.
--  011017  MaGu     Bug fix 24889. Modified methods Insert_Package___, Change_Package_Structure___
--                   and Post_Insert_Actions___ so that discounts are not saved on component lines.
--  011016  MaGu     Bug fix 24887. Modified calculation of sale_unit_price for component parts
--                   in methods Insert_Package___ and Change_Package_Structure___.
--  011012  Memeus   Bug 25347, inside method update___, add remove_tax_lines and add_tax_line
--                   for Charge line which not connected to any Sales Quotation Line. Commented Remove_charge_lines.
--  011011  JICE     Bug fix 25345, Intrastat_Exempt not sent when creating customer order and default
--                   address not used on quotation line.
--  011008  CaSt     Bug fix 24842, Modified procedure Update__ to update the row discount when the price is changed.
--  010704  OsAllk   Bug Fix 20832,Added check in the PROCEDURE Create_Line___ before seting the dates to promised_delivery_date.
--  010619  JSAnse   Bug fix 21463, Added call to General_SYS.Init_Method for Check_Quote_Line_For_Planning.
--  010614  OsAllk   Bug fix 20832, wanted_delivery_date,Planned_delivery_date and are set to promised_delivery_date
--                   when calling to Customer_Order_Line_API.New in PROCEDURE Create_Line___and added FUNCTION Get_Max_Promised_Delivery_Date.
--  010528  JSAnse   Bug fix 21463, Improved the usage of General_SYS.Init_Method.
--  010522  JSAnse   Bug fix 21592, removed client_sys.attr_to_dbms_output.
--  010413  JaBa     Bug Fix 20598,Added new global lu constants in pkg,pkg2.
--  010403  RoAnse   Bug fix 19545, Added function Check_Quote_Line_For_Planning.
--  010226  JeAsse   Bug fix 19937, Added line to set newrec_.catalog_desc to the value of
--                   cross_rec_.catalog_desc to correct sales part description on package parts.
--  010215  RoAnse   Bug fix 19082, Added check for planned_delivery_date in PROCEDURE Get_Changed_State___.
--  010111  JoEd     Created package PKG3 and moved the Unpack_... and Check_Before_...
--                   methods to it because PKG and PKG2 were too large.
--  010105  JakH     Package components no longer needs to beremoved on the created order
--                   line since they are not added when the head is created when the quotation creates that line.
--  010104  JakH     Fetching part price for configured package components using normal price fetching.
--  010102  JakH     Modified Update_Package_State___ to not release released components.
--                   Also corrected cancellation bug (object removed by other user)
--  001221  JakH     Added call to change_package_structure___ in Update___ when cost is updated for a component.
--  001220  MaGu     Added price effectivity date to method Create_Line___.
--  001218  JoEd     Added use of order quotation package variable updated_from_wizard_
--                   to avoid setting quotation line status to Revised. Since the call
--                   is made in the middle of the "Create Order From Quotation" process.
--                   Added check in Get_Changed_State___.
--  001213  DaZa     Added nvl check in Update_Planning_Date__ for old_delivery_date_.
--  001212  CaRa     Set temporary variable dop_connection to zero in procedure Insert_Package___.
--  001211  DaZa     Added extra assignment of promised_delivery_date in method Update_Planning_Date__ when status is Planned.
--  001208  DaZa     Added default value for EARLIEST_START_DATE in Insert_Package___.
--  001201  JoAn     Added part_no as parameter to reference for configuration_id.
--  001130  JoEd     Changed fetch of catalog desc in Get_Line_Defaults___.
--  001129  JoEd     Added vat and default_addr_flag to attribute string in Create_Line___.
--  001128  JoEd     Added fetch of customer_part_no in Insert___ if no
--                   customer_part_no has been entered.
--                   Also added calculation of customer_part_buy_qty in Check_Before_Update___.
--  001128  CaSt     Cleanup. Removed not used procedures and functions.
--  001127  MaGu     Added price_effectivity_date when checking if price list is valid in Check_Before_Insert___
--                   and Check_Before_Update___.
--  001127  MaGu     Modified method Recalculate_Salesprice, added conversion to price_source_db.
--                   Corrected check on price breaks in Check_Before_Update___.
--  001124  MaGu     Modified in methods Get_Quote_Line_Price and Update_Grad_Price_Line to handle price breaks.
--  001123  CaSt     Attribute string was overwritten in Modify_Quote_Defaults__.
--  001123  MaGu     Modified method Get_Quote_Line_Price, added buy_qty_due in return attribute string.
--  001122  MaGu     Modified method Post_Insert_Actions so that no default line discount record is created
--                   if buy_qty_due is 0.
--  001122  JakH     Pass pricing information and configuration for configured lines.
--  001122  MaGu     Modified method Get_Quote_Line_Price, added parameter info_.
--  001122  MaGu     Changed to price source 'PRICE BREAKS' in method Update_Grad_Price_Line.
--                   Modified method Get_Quote_Line_Price to correct fetch of price from price breaks.
--  001121  JoEd     Added attribute DEFAULT_ADDR_FLAG. Added new default values for
--                   delivery information.
--                   Removed unused implementation methods.
--  001120  JakH     Added Configured_line_Price_id to returned attr_ on insert.
--  001117  MaGu     Added method Get_Quote_Line_Price.
--  001117  MaGu     Removed call to Customer_Order_Pricing_API.Get_Quote_Line_Price_Info from Insert_Package___.
--  001117  DaZa     Added call to Cancel_Planning___ in Finite_State_Machine___ when state 'Planned'
--                   and event 'Cancel'. Moved some code from Cancel__ to Cancel_Planning___.
--  001116  CaSt     Added call to Order_Quotation_API.Calculate_Discount__ in procedure Delete__.
--  001116  FBen     Fixed invalid cursor that did not check if it was closed or not, Call ID 52676 in Update___.
--  001115  JakH     Added code to stub Modify_Cost
--  001115  JakH     Added SHIP_ADDR_NO in parameters when order is created.
--  001115  JakH     Added call to care for actions related to changes of configuration_id in update___
--  001115  CaSt     Added logic to Check_Statutory_Fee__.
--  001114  CaSt     Added logic to Modify_Calc_Disc_Flag.
--  001114  MaGu     Added new parameter price_source_id to a number of calls in methods
--                   Insert_Package___, Recalculate_Salesprice and Get_Line_Defaults___.
--  001113  CaSt     Added logic to Modify_Quotation_Discount.
--  001110  DaZa     Removed Modify_Planned_Due_Date__. Added Update_Planning_Date__.
--                   Rewrote Calculate_Quote_Lines_Dates___. Added pkg_planned_delivery_date_
--                   to Insert_Package___, Update_Package___ and Change_Package_Structure___.
--  001108  DaZa     Added public attribute planned_delivery_date.
--  001107  MaGu     Added public attribute price_source_id.
--  001102  DaZa     Dynamic PL fixes in methods Delete___ and Cancel__.
--  001102  CaRa     In procedure Insert_Package___ insert handling of acquisition instead
--                   of only set the supply_code into 'Not Decided'.
--  001101  MaGu     Changed to new key discount_no in call to cust_order_line_discount and
--                   order_quote_line_discount in Create_Order_Line___.
--  001031  JoEd     Added NOCHECK flag on cust_warranty_id.
--  001031  DaZa     Added check in Check_Before_Update___ for ctp_planned and valid
--                   supply_code. Added dynamic calls in Update___ to PromiseOrder.
--  001029  JoEd     Added public attribute CUST_WARRANTY_ID.
--  001025  DaZa     Added methods Set_Ctp_Planned and Clear_Ctp_Planned.
--  001020  CaSt     Call ID 50346. Discount was not transferred to the order line.
--  001018  DaZa     Added check in Check_Before_Update___ for release_planning and ctp_planned flags.
--                   Added ctp_planned and earliest_start_date to Create_Line___. Added checks for
--                   ctp_planned in methods Delete___, Cancel__ and Create_Order_Line___.
--  001006  DaZa     Added earliest_start_date and ctp_planned.
--  001003  JakH     Added configured_line_price_id, removed references to ConfigSpecUsage
--  001001  JakH     Transfer_Usage in Interim_Order_Int_API
--  000929  JakH     Modified checks for valid configurations. Added ORDER_QUOTE_LINE_CONFIG_USAGE view
--  000920  JakH     Added configuration_id. Added it to supply demand views aswell.
--  000915  JakH     Changed Check_Supply_Code___ to allow configured services to be entered.
--  000913  FBen     Added UNDEFINE.
--  000908  CaRa     Added order supply type to returned attr_ from insert___ and update___
--  000907  JakH     Added Remove_From_Planning and Update_Planning_Date
--  000907  JakH     Added Line_item_no as DEMAND_ORDER_REF4 when creating a new order line.
--  000907  JakH     Added implementation to Has_Options, Clear_Options, Get_objversion
--                   removed Modify_Quote_Discount___ since it was local and not used.
--  000907  JakH     Added interfacing calls to planning
--  000906  JoEd     Cleanup.
--  000904  JoEd     Supply_code = 'Not Decided' for package components.
--  000823  JakH     Added error for include in planning on price breaked line, moved check for planned due
--                   date to check_release function.
--  000809  FBEN     Removed check on order_supply_type if 'Not Decided' if quotation is in status released.
--                   In method Check_Before_Insert___. Also changed check in method Check_Before_Update___
--                   so order_supply_type may be changed even in status released.
--  000807  FBEN     Added DOP check in Check_Before_Insert___ that checks if the inventory part is a DOP part.
--  000719  TFU      Merging from Chameleon
--  000719  LIN      Added cancel of configuration usage and interim order
--  000718  LIN      Modified updating discounts on quotation line.
--  000717  JakH     Changed discount updates on COL to call Calc_Discount_Upd_Co_Line
--  000717  JakH     Use of Transfer_Usage when creating order lines.
--  000713  LIN      Added update_package_charprice to delete___
--  000711  JakH     Added demand code CQ, (Customer Quote) when creating a customer order line
--  000711  LIN      Added rows in Create_Line___
--  000630  LIN      Added new rows and logic for CTO pricing
--  000628  BRO      Added creation of config usage in insert___
--                   Added global variable g_unsaved_config_id_
--  000627  LIN      Extended default setting for supply code (aquisition) for
--                   configured base items.
--  000619  GBO      Added Line_Changed
--  000615  GBO      Correct bug in Modify_Quote_Defaults___ ( attribute string was never cleared )
--  000614  TFU      Added the test of Sales Part is 'CONFIGURATED' in the PROCEDURE Create_Order_Line___
--  000609  LIN      Added procedure Update_Grad_Price_Line
--  000609  GBO      Added logic for disabling release of quotation line when configuration is not connected
--                   to a line ( see Is_Base_Part_Config_Valid__ )
--  000608  GBO      Uncommented views VIEW_DEMAND1 and VIEW_MS2
--                   Corrected bug with option when creating customer order
--                   Corrected another with PackageLineChanged -> should only be send
--                   when quotation was printed
--                   Added Check_Supply_Code___, Is_Base_Part_Config_Valid__ and Check_Base_Part_Config__
--  000608  TFU      Add the delete line for the Remove_Charge_Lines
--  000607  GBO      Corrected bug with PackageLineChanged in Check_Important_Fields___
--  000606  GBO      Change CUSTOMER_PART_BUY to CUSTOMER_PART_BUY_QTY in PKG2..Check_Important_Fields___
--                   Corrected bug with CUSTOMER_PART_UNIT_MEAS !
--                   No more history line with state = 'Planned'
--  000602  LIN      BUY_QTY_DUE may be zero
--  000525  LIN      Added function Exist_Lines
--  000525  GBO      Added logic for copying OrderQuotationOption when creating customer order
--                   Added PKG2..Create_Order_Line___
--                   Added logic for releasing created customer orders
--  000524  LIN      Added Recalculate_Salesprice logic
--  000523  JakH     Added supply/demand views
--  000522  LIN      Added checks for release planning
--  000518  LIN      Added parameter effectivity_date to customer_order_pricing
--  000516  GBO      Added logic in Get_Allowed_Operations
--                   Added PackageLineChanged logic
--  000516  TFU      Delete charge lines connected to quotation lines
--  000516  LIN      Changed logic for calculate_planned_due_date
--  000515  LIN      Added logic for prepare_insert
--  000515  GBO      Changed Create_Order_Line to Create_Line___
--                   Changed Create_Order to Create_Order_Line
--  000512  JakH     Moved Conditions from unpack_check_update___ to check before_update___.
--  000512  JakH     Moved Conditions from unpack_check_insert___ to check before_insert___.
--  000510  LIN      Added New/Modify_Default_Qdiscount_Rec logic
--  000509  GBO      Correct bug with line_total_qty and line_total_weigth
--                   Added check on probability to win
--  000508  LUDI     Added new LOV VIEW_CHARGE_LOV for QUOTATION CHARGE.
--  000508  GBO      Uncommented discount logic for lines.
--                   Restrict deletion of lines
--                   Correct Modify_Quote_Defaults for package component lines
--                   Create order from lines only
--  000505  GBO      Change logic for creating defaulted competitors
--  000505  LIN      Added Modify_Discount logic
--  000504  GBO      Added logic for creating order line
--  000504  LIN      Added Get_Objstate logic
--  000503  GBO      Added Set_Revised
--  000502  GBO      Remove closed_status. Merge new state diagram
--  000425  GBO      Added Set_Lose_Reason
--  000419  GBO      Added Get_Allowed_Operations__, Update_Package_State___
--  000418  GBO      Added closed_status, Get_Next_Line_No and Recalc_Package_Structure
--                   Added New, Modify and Delete for handling substitute part
--  000417  GBO      Add others default values
--                   Removed order_no and added con_order_no, con_line_no, con_rel_no
--                   and con_line_item_no
--  000414  GBO      Correct logic for inserting component part,
--                   Add update logic, deletion of package part
--  000413  GBO      Add insert logic
--  000412  GBO      Added some vat, ship_via_code and delivery_terms
--                   Add some logic
--  000411  ???      Created
--  ------------------------------ 13.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE array_string IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_Price_Break_Error___ 
IS 
BEGIN
   Error_SYS.Record_General(lu_name_, 'PRICEBREAKS: The entered sales quantity must be within the limits of the price breaks.');
END Raise_Price_Break_Error___;   

PROCEDURE Check_Tax_Calc_Struct_Ref___ (
   newrec_ IN OUT NOCOPY ORDER_QUOTATION_LINE_TAB%ROWTYPE )
IS
BEGIN
   Tax_Calc_Structure_API.Validate_Tax_Structure_State(newrec_.company, newrec_.tax_calc_structure_id);
END Check_Tax_Calc_Struct_Ref___;

-- Update_Line___
--   Method that simply updates the LU table.
--   Used to avoid eternal loop when Change_Package_Structure___ is called.
PROCEDURE Update_Line___ (
   objid_                     IN     VARCHAR2,
   oldrec_                    IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   newrec_                    IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   statemachine_              IN     BOOLEAN,
   updated_from_wizard_       IN     BOOLEAN,
   updated_from_create_order_ IN     BOOLEAN DEFAULT FALSE)
IS
BEGIN
   -- gelr:disc_price_rounded, added original_discount, original_add_discount, original_quotation_discount
   UPDATE order_quotation_line_tab
      SET quotation_no = newrec_.quotation_no,
          line_no = newrec_.line_no,
          rel_no = newrec_.rel_no,
          line_item_no = newrec_.line_item_no,
          base_sale_unit_price = newrec_.base_sale_unit_price,
          base_unit_price_incl_tax = newrec_.base_unit_price_incl_tax,
          buy_qty_due = newrec_.buy_qty_due,
          desired_qty = newrec_.desired_qty,
          catalog_desc = newrec_.catalog_desc,
          conv_factor = newrec_.conv_factor,
          cost = newrec_.cost,
          currency_rate = newrec_.currency_rate,
          date_entered = newrec_.date_entered,
          discount = newrec_.discount,
          line_total_qty = newrec_.line_total_qty,
          line_total_weight = newrec_.line_total_weight,
          note_text = newrec_.note_text,
          quotation_discount = newrec_.quotation_discount,
          planned_due_date = newrec_.planned_due_date,
          price_conv_factor = newrec_.price_conv_factor,
          promised_delivery_date = newrec_.promised_delivery_date,
          revised_qty_due = newrec_.revised_qty_due,
          sale_unit_price = newrec_.sale_unit_price,
          unit_price_incl_tax = newrec_.unit_price_incl_tax,
          wanted_delivery_date = newrec_.wanted_delivery_date,
          note_id = newrec_.note_id,
          customer_part_no = newrec_.customer_part_no,
          customer_part_conv_factor = newrec_.customer_part_conv_factor,
          customer_part_unit_meas = newrec_.customer_part_unit_meas,
          customer_part_buy_qty = newrec_.customer_part_buy_qty,
          delivery_leadtime = newrec_.delivery_leadtime,
          original_part_no = newrec_.original_part_no,
          probability_to_win = newrec_.probability_to_win,
          release_planning = newrec_.release_planning,
          order_supply_type = newrec_.order_supply_type,
          lost_to = newrec_.lost_to,
          reason_id = newrec_.reason_id,
          contract = newrec_.contract,
          company = newrec_.company,
          tax_code = newrec_.tax_code,
          tax_class_id = newrec_.tax_class_id,
          part_no = newrec_.part_no,
          catalog_no = newrec_.catalog_no,
          price_list_no = newrec_.price_list_no,
          customer_no = newrec_.customer_no,
          sales_unit_measure = newrec_.sales_unit_measure,
          delivery_type = newrec_.delivery_type,
          catalog_type = newrec_.catalog_type,
          tax_liability = newrec_.tax_liability,
          ship_via_code = newrec_.ship_via_code,
          delivery_terms = newrec_.delivery_terms,
          ship_addr_no = newrec_.ship_addr_no,
          charged_item = newrec_.charged_item,
          con_order_no = newrec_.con_order_no,
          con_line_no = newrec_.con_line_no,
          con_rel_no = newrec_.con_rel_no,
          con_line_item_no = newrec_.con_line_item_no,
          lose_win_note = newrec_.lose_win_note,
          part_price = newrec_.part_price,
          calc_char_price = newrec_.calc_char_price,
          char_price = newrec_.char_price,
          price_freeze = newrec_.price_freeze,
          price_source = newrec_.price_source,
          configuration_id = newrec_.configuration_id,
          configured_line_price_id = newrec_.configured_line_price_id,
          latest_release_date = newrec_.latest_release_date,
          ctp_planned = newrec_.ctp_planned,
          cust_warranty_id = newrec_.cust_warranty_id,
          price_source_id = newrec_.price_source_id,
          planned_delivery_date = newrec_.planned_delivery_date,
          default_addr_flag = newrec_.default_addr_flag,
          price_unit_meas =newrec_.price_unit_meas,
          additional_discount = newrec_.additional_discount,
          condition_code = newrec_.condition_code,
          vendor_no = newrec_.vendor_no,
          self_billing = newrec_.self_billing,
          cancel_reason = newrec_.cancel_reason,
          classification_part_no = newrec_.classification_part_no,
          classification_unit_meas = newrec_.classification_unit_meas,
          classification_standard = newrec_.classification_standard,
          input_qty = newrec_.input_qty,
          input_unit_meas = newrec_.input_unit_meas,
          input_conv_factor = newrec_.input_conv_factor,
          input_variable_values = newrec_.input_variable_values,
          price_source_net_price = newrec_.price_source_net_price,
          del_terms_location = newrec_.del_terms_location,
          part_level = newrec_.part_level,
          part_level_id = newrec_.part_level_id,
          customer_level = newrec_.customer_level,
          customer_level_id = newrec_.customer_level_id,
          forward_agent_id = newrec_.forward_agent_id,
          freight_map_id = newrec_.freight_map_id,
          zone_id = newrec_.zone_id,
          freight_price_list_no = newrec_.freight_price_list_no,
          adjusted_weight_net = newrec_.adjusted_weight_net,
          adjusted_weight_gross = newrec_.adjusted_weight_gross,
          adjusted_volume = newrec_.adjusted_volume,
          freight_free = newrec_.freight_free,
          ext_transport_calendar_id = newrec_.ext_transport_calendar_id,
          inverted_conv_factor = newrec_.inverted_conv_factor,
          demand_code = newrec_.demand_code,
          demand_order_ref1 = newrec_.demand_order_ref1,
          demand_order_ref2 = newrec_.demand_order_ref2,
          picking_leadtime = newrec_.picking_leadtime,
          end_customer_id = newrec_.end_customer_id,
          rental = newrec_.rental,
          single_occ_addr_flag = newrec_.single_occ_addr_flag,
          cust_part_invert_conv_fact = newrec_.cust_part_invert_conv_fact,
          tax_liability_type = newrec_.tax_liability_type,
          tax_calc_structure_id = newrec_.tax_calc_structure_id,
          -- gelr:disc_price_rounded:DIS005, begin
          original_quotation_discount = newrec_.original_quotation_discount,
          original_discount = newrec_.original_discount,
          original_add_discount = newrec_.original_add_discount,
          -- gelr:disc_price_rounded:DIS005, end          
          rowversion = newrec_.rowversion
          WHERE rowid = objid_;

      Check_Important_Fields___(oldrec_, newrec_, statemachine_, updated_from_wizard_, updated_from_create_order_);
END Update_Line___;


PROCEDURE Insert_Package___ (
   pkg_planned_delivery_date_    IN OUT DATE,
   pkg_contract_                 IN     VARCHAR2,
   pkg_catalog_no_               IN     VARCHAR2,
   pkg_quotation_no_             IN     VARCHAR2,
   pkg_line_no_                  IN     VARCHAR2,
   pkg_rel_no_                   IN     VARCHAR2,
   pkg_tax_code_                 IN     VARCHAR2,
   pkg_tax_class_                IN     VARCHAR2,
   pkg_currency_rate_            IN     NUMBER,
   pkg_revised_qty_due_          IN     NUMBER,
   pkg_buy_qty_due_              IN     NUMBER,
   pkg_sale_unit_price_          IN     NUMBER,
   pkg_unit_price_incl_tax_      IN     NUMBER,
   pkg_base_sale_unit_price_     IN     NUMBER,
   pkg_base_unit_price_incl_tax_ IN     NUMBER,
   pkg_wanted_delivery_date_     IN     DATE )
IS
   base_sale_unit_price_          NUMBER := 0;
   base_unit_price_incl_tax_      NUMBER := 0;
   sale_unit_price_               NUMBER := 0;
   unit_price_incl_tax_           NUMBER := 0;
   discount_                      NUMBER := 0;
   buy_qty_due_                   NUMBER := 0;
   desired_qty_                   NUMBER;
   revised_qty_due_               NUMBER := 0;
   cost_                          NUMBER := 0;
   pkg_cost_                      NUMBER := 0;
   supply_code_db_                VARCHAR2(3) := NULL;
   catalog_desc_                  ORDER_QUOTATION_LINE_TAB.catalog_desc%TYPE;
   sales_part_desc_               ORDER_QUOTATION_LINE_TAB.catalog_desc%TYPE;
   template_attr_                 VARCHAR2(32000);
   attr_                          VARCHAR2(32000);
   objid_                         VARCHAR2(2000);
   objversion_                    VARCHAR2(2000);
   component_no_                  VARCHAR2(25);
   original_part_no_              VARCHAR2(25);
   part_price_                    NUMBER := 0;
   price_source_                  VARCHAR2(200);
   price_source_id_               VARCHAR2(25);
   temp_base_sale_unit_price_     NUMBER;
   temp_base_unit_price_incl_tax_ NUMBER;
   temp_currency_rate_            NUMBER;
   temp_discount_                 NUMBER;
   header_rec_                    ORDER_QUOTATION_API.Public_Rec;
   sales_part_rec_                Sales_Part_API.Public_Rec;
   pkg_header_rec_                ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   newrec_                        ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   part_price_is_set_             BOOLEAN;
   condition_code_                ORDER_QUOTATION_LINE_TAB.condition_code%TYPE;      
   replace_part_                  VARCHAR2(25);
   replace_date_                  DATE;
   overload_count_                NUMBER := 0;
   net_price_fetched_             VARCHAR2(20);
   part_level_db_                 VARCHAR2(30);
   part_level_id_                 VARCHAR2(200);
   customer_level_db_             VARCHAR2(30);
   customer_level_id_             VARCHAR2(200);
   line_discount_amount_          NUMBER;
   customer_part_no_              ORDER_QUOTATION_LINE_TAB.customer_part_no%TYPE;
   customer_category_             CUSTOMER_INFO_TAB.customer_category%TYPE;
   indrec_                        Indicator_Rec;
   tax_liability_type_db_         VARCHAR2(20);
   multiple_tax_                  VARCHAR2(20);

   CURSOR get_pkg_ingridients(contract_ VARCHAR2, parent_part_ VARCHAR2)
   IS
      SELECT catalog_no, line_item_no, qty_per_assembly
      FROM   SALES_PART_PACKAGE_PUB
      WHERE  contract = contract_
      AND    parent_part= parent_part_
      ORDER BY line_item_no;

BEGIN

   -- Fetch the total package cost for each component.
   pkg_cost_ := 0;
   header_rec_ := ORDER_QUOTATION_API.Get(pkg_quotation_no_);
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(header_rec_.customer_no);
   FOR psrec_ IN get_pkg_ingridients(pkg_contract_, pkg_catalog_no_) LOOP
      sales_part_rec_  := Sales_Part_API.Get(pkg_contract_, psrec_.catalog_no);

      -- Check if it's a active inventory part.
      Check_Active_Part___(pkg_contract_, sales_part_rec_.part_no);

      -- Check if the component part has been replaced by a replacement part.
      replace_part_ := sales_part_rec_.replacement_part_no;
      replace_date_ := sales_part_rec_.date_of_replacement;
      -- Check if the specified sales part has been superseded by a replacement part.
      LOOP
         IF (replace_part_ IS NOT NULL) AND (replace_date_ <= (Site_API.Get_Site_Date(pkg_contract_))) THEN
            IF (overload_count_ = 10) THEN
               Error_SYS.Record_General(lu_name_, 'REPOVERLOADED: No of Part Replacements are exceeded, Please check your sales part replacement data.');
            ELSE
               original_part_no_ := replace_part_;
               sales_part_rec_  := Sales_Part_API.Get(pkg_contract_, original_part_no_);
               -- Fetch new replcement part
               replace_part_ := sales_part_rec_.replacement_part_no;
               replace_date_ := sales_part_rec_.date_of_replacement;
            END IF;
         ELSE
            EXIT;
         END IF;
         overload_count_ := overload_count_ + 1;
      END LOOP;

      revised_qty_due_ := pkg_buy_qty_due_ * psrec_.qty_per_assembly * sales_part_rec_.conv_factor / sales_part_rec_.inverted_conv_factor;
      IF (sales_part_rec_.part_no IS NULL) THEN
         cost_ := sales_part_rec_.cost;
         -- Note : Retrive the default condition code if used for this part
         IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(sales_part_rec_.part_no) = 'ALLOW_COND_CODE') THEN
            condition_code_ := Condition_Code_API.Get_Default_Condition_Code;
         ELSE
            condition_code_ := NULL;
         END IF;
         -- Note : Retrive cost for the part (and condition code if applicable)
         IF (revised_qty_due_ IS NOT NULL) THEN
            cost_ := Sales_Cost_Util_API.Get_Cost_Incl_Sales_Overhead(pkg_contract_,
                                                                      sales_part_rec_.part_no,
                                                                      '*',
                                                                      condition_code_,
                                                                      revised_qty_due_,
                                                                      'CHARGED ITEM',
                                                                      Order_Supply_Type_API.Encode(Sales_Part_API.Get_Default_Supply_Code(pkg_contract_, psrec_.catalog_no)),
                                                                      header_rec_.customer_no,
                                                                      NULL);
         ELSE
            cost_ := 0;
         END IF;
      END IF;
      pkg_cost_ := pkg_cost_ + cost_ * psrec_.qty_per_assembly * sales_part_rec_.conv_factor / sales_part_rec_.inverted_conv_factor;
   END LOOP;

   -- fetch package header to use with the components
   pkg_header_rec_ := Get_Object_By_Keys___(pkg_quotation_no_, pkg_line_no_, pkg_rel_no_, -1);

   -- Create a template that may be used for every component.
   Client_SYS.Clear_Attr(template_attr_);
   Client_SYS.Add_To_Attr('QUOTATION_NO', pkg_quotation_no_, template_attr_);
   Client_SYS.Add_To_Attr('LINE_NO', pkg_line_no_, template_attr_);
   Client_SYS.Add_To_Attr('REL_NO', pkg_rel_no_, template_attr_);
   Client_SYS.Add_To_Attr('CONTRACT', pkg_contract_, template_attr_);
   Client_SYS.Add_To_Attr('COMPANY', pkg_header_rec_.company, template_attr_);
   Client_SYS.Add_To_Attr('CURRENCY_RATE', pkg_currency_rate_, template_attr_);
   Client_SYS.Add_To_Attr('QUOTATION_DISCOUNT', 0, template_attr_);
   Client_SYS.Add_To_Attr('CHARGED_ITEM_DB', 'CHARGED ITEM', template_attr_);
   Client_SYS.Add_To_Attr('CATALOG_TYPE_DB', 'KOMP', template_attr_);
   Client_SYS.Add_To_Attr('TAX_CODE', pkg_tax_code_, template_attr_);
   Client_SYS.Add_To_Attr('TAX_CLASS_ID', pkg_tax_class_, template_attr_);
   Client_SYS.Add_To_Attr('SHIP_ADDR_NO', pkg_header_rec_.ship_addr_no, template_attr_);
   Client_SYS.Add_To_Attr('SINGLE_OCC_ADDR_FLAG', pkg_header_rec_.single_occ_addr_flag, template_attr_);
   Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', pkg_header_rec_.ext_transport_calendar_id, template_attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TERMS', pkg_header_rec_.delivery_terms, template_attr_);
   Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', pkg_header_rec_.del_terms_location, template_attr_);
   Client_SYS.Add_To_Attr('TAX_LIABILITY', pkg_header_rec_.tax_liability, template_attr_);
   Client_SYS.Add_To_Attr('PROBABILITY_TO_WIN', pkg_header_rec_.probability_to_win, template_attr_);
   Client_SYS.Add_To_Attr('RELEASE_PLANNING_DB', pkg_header_rec_.release_planning, template_attr_);
   Client_SYS.Add_To_Attr('PRICE_FREEZE_DB', 'FROZEN', template_attr_);
   Client_SYS.Add_To_Attr('CONFIGURATION_ID', '*', template_attr_);
   Client_SYS.Add_To_Attr('TAX_LIABILITY_TYPE_DB', Tax_Liability_API.Get_Tax_Liability_Type_Db(pkg_header_rec_.tax_liability, header_rec_.country_code), template_attr_);

   -- Create record for each component.
   FOR psrec_ IN get_pkg_ingridients(pkg_contract_, pkg_catalog_no_) LOOP
      sales_part_rec_  := Sales_Part_API.Get(pkg_contract_, psrec_.catalog_no);
      sales_part_desc_ := Sales_Part_API.Get_Catalog_Desc(pkg_contract_, psrec_.catalog_no, header_rec_.language_code);

      component_no_ := psrec_.catalog_no;
      original_part_no_ := NULL;

      -- Check if the component part has been replaced by a replacement part.
      replace_part_ := sales_part_rec_.replacement_part_no;
      replace_date_ := sales_part_rec_.date_of_replacement;
      overload_count_ := 0;
      -- Check if the specified sales part has been superseded by a replacement part.
      LOOP
         IF (replace_part_ IS NOT NULL) AND (replace_date_ <= (Site_API.Get_Site_Date(pkg_contract_))) THEN
            IF (overload_count_ = 10) THEN
               Error_SYS.Record_General(lu_name_, 'REPOVERLOADED: No of Part Replacements are exceeded, Please check your sales part replacement data.');
            ELSE
               original_part_no_ := component_no_;
               component_no_ := replace_part_;
               sales_part_rec_  := Sales_Part_API.Get(pkg_contract_, component_no_);
               sales_part_desc_ := Sales_Part_API.Get_Catalog_Desc(pkg_contract_, component_no_, header_rec_.language_code);
               -- Fetch new replcement part
               replace_part_ := sales_part_rec_.replacement_part_no;
               replace_date_ := sales_part_rec_.date_of_replacement;
            END IF;
         ELSE
            EXIT;
         END IF;
         overload_count_ := overload_count_ + 1;
      END LOOP;

      attr_ := template_attr_;
      part_price_is_set_ := FALSE;
      Client_SYS.Add_To_Attr('LINE_ITEM_NO', psrec_.line_item_no, attr_);
      Client_SYS.Add_To_Attr('CATALOG_NO', component_no_, attr_);
      Client_SYS.Add_To_Attr('CONV_FACTOR', sales_part_rec_.conv_factor, attr_);
      Client_SYS.Add_To_Attr('PRICE_CONV_FACTOR', sales_part_rec_.price_conv_factor, attr_);
      Client_SYS.Add_To_Attr('ORIGINAL_PART_NO', original_part_no_, attr_);
      Client_SYS.Add_To_Attr('INVERTED_CONV_FACTOR', sales_part_rec_.inverted_conv_factor, attr_);

      IF (customer_category_ = Customer_Category_API.DB_CUSTOMER) THEN
         -- Fetch correct description.
         customer_part_no_ := Sales_Part_Cross_Reference_API.Get_Customer_Part_No(header_rec_.customer_no, header_rec_.contract, component_no_);
         catalog_desc_ := Sales_Part_Cross_Reference_API.Get_Catalog_Desc(header_rec_.customer_no ,
                                                                          pkg_contract_, customer_part_no_ );

      ELSE
         catalog_desc_ := NULL;
      END IF;

      IF (catalog_desc_ IS NULL) THEN
         catalog_desc_:= Sales_Part_Language_Desc_API.Get_Catalog_Desc(pkg_contract_, component_no_,
                                                                       header_rec_.language_code);
         IF (catalog_desc_ IS NULL) THEN
            catalog_desc_ := sales_part_desc_;
         END IF;
      END IF;
      Client_SYS.Add_To_Attr('CATALOG_DESC', catalog_desc_, attr_);

      -- Fetch the condition code and cost for this component.
      IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(sales_part_rec_.part_no) = 'ALLOW_COND_CODE') THEN
         condition_code_ := Condition_Code_API.Get_Default_Condition_Code;
      ELSE
         condition_code_ := NULL;
      END IF;
      
      -- Set correct SUPPLY_CODE
      supply_code_db_ := Order_Supply_Type_API.Encode(Sales_Part_API.Get_Default_Supply_Code(pkg_contract_, component_no_));

      revised_qty_due_ := pkg_buy_qty_due_ * psrec_.qty_per_assembly * sales_part_rec_.conv_factor / sales_part_rec_.inverted_conv_factor;
      IF (sales_part_rec_.part_no IS NULL) THEN
         cost_ := sales_part_rec_.cost;
      ELSE
         IF (revised_qty_due_ IS NOT NULL) THEN
            -- Retrive cost for the part (and condition code if applicable)
            cost_ := Sales_Cost_Util_API.Get_Cost_Incl_Sales_Overhead(pkg_contract_,
                                                                      sales_part_rec_.part_no,
                                                                      '*',
                                                                      condition_code_,
                                                                      revised_qty_due_,
                                                                      'CHARGED ITEM',
                                                                      supply_code_db_,
                                                                      header_rec_.customer_no,
                                                                      NULL);
         ELSE
            cost_ := 0;
         END IF;
      END IF;

      Client_SYS.Add_To_Attr('COST', cost_, attr_);
      Client_SYS.Add_To_Attr('CONDITION_CODE', condition_code_, attr_);

      -- Display an error about the primary supplier missing - instead of just "Supply Code must have a value" later...
      IF (supply_code_db_ IS NULL) AND (sales_part_rec_.sourcing_option IN ('PRIMARYSUPPTRANSIT', 'PRIMARYSUPPDIRECT')) THEN
         Error_SYS.Record_General(lu_name_, 'NO_PRIMARY_SUPP: No primary supplier exists for purchase part :P1.', sales_part_rec_.purchase_part_no);
      END IF;

      IF (supply_code_db_ != 'DOP') AND (sales_part_rec_.catalog_type != 'NON') THEN
         IF (Sales_Part_API.Get_Configurable_Db(pkg_contract_, component_no_) = 'CONFIGURED') THEN
            -- fetch a valid part price to be used as a base for characteristic pricing offsets.

            customer_level_db_ := pkg_header_rec_.customer_level;
            customer_level_id_ := pkg_header_rec_.customer_level_id;

            sale_unit_price_     := NULL;
            unit_price_incl_tax_ := NULL;
            -- fetch a valid part price to be used as a base for characteristic pricing offsets.
            Customer_Order_Pricing_API.Get_Quote_Line_Price_Info
               ( sale_unit_price_, unit_price_incl_tax_, temp_base_sale_unit_price_, temp_base_unit_price_incl_tax_,
                 temp_currency_rate_, temp_discount_,
                 price_source_, price_source_id_, net_price_fetched_, 
                 part_level_db_, part_level_id_, customer_level_db_, customer_level_id_, 
                 pkg_quotation_no_, component_no_, psrec_.qty_per_assembly,
                 pkg_header_rec_.price_list_no, header_rec_.price_effectivity_date,
                 NULL, header_rec_.use_price_incl_tax);
            IF (header_rec_.use_price_incl_tax = 'TRUE') THEN
               part_price_ := unit_price_incl_tax_;
            ELSE
               part_price_ := sale_unit_price_;
            END IF;
            Client_SYS.Add_To_Attr('PART_PRICE', part_price_, attr_);
            Client_SYS.Add_To_Attr('PRICE_SOURCE', price_source_, attr_);
            Client_SYS.Add_To_Attr('PRICE_SOURCE_ID', price_source_id_, attr_);
            Client_SYS.Add_To_Attr('PRICE_SOURCE_NET_PRICE_DB', net_price_fetched_, attr_);
            Client_SYS.Add_To_Attr('PART_LEVEL_DB', part_level_db_, attr_);
            Client_SYS.Add_To_Attr('PART_LEVEL_ID', part_level_id_, attr_);
            Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_DB', customer_level_db_, attr_);
            Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_ID', customer_level_id_, attr_);
            part_price_is_set_ := TRUE;
         END IF;
      END IF;
      Client_SYS.Add_To_Attr('ORDER_SUPPLY_TYPE_DB', supply_code_db_, attr_);

      -- Calculate quantities.
      buy_qty_due_ := pkg_buy_qty_due_ * psrec_.qty_per_assembly;
      desired_qty_ := pkg_header_rec_.desired_qty * psrec_.qty_per_assembly;

      -- Calculate SALE_UNIT_PRICE and BASE_SALE_UNIT_PRICE.
      IF ((pkg_cost_ * pkg_revised_qty_due_) = 0) THEN
         sale_unit_price_ := 0;
         unit_price_incl_tax_ := 0;
         base_sale_unit_price_ := 0;
         base_unit_price_incl_tax_ := 0;
      ELSE
         line_discount_amount_ := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(pkg_quotation_no_, pkg_line_no_, pkg_rel_no_, -1, 
                                                                                       1, -- quantity
                                                                                       (sales_part_rec_.conv_factor / sales_part_rec_.inverted_conv_factor * cost_ * pkg_header_rec_.price_conv_factor) /(pkg_cost_ * sales_part_rec_.price_conv_factor));

         IF (header_rec_.use_price_incl_tax = 'TRUE') THEN
            unit_price_incl_tax_ := (sales_part_rec_.conv_factor / sales_part_rec_.inverted_conv_factor * cost_ * pkg_unit_price_incl_tax_ * pkg_header_rec_.price_conv_factor) /
                                    (pkg_cost_ * sales_part_rec_.price_conv_factor);
            IF (pkg_header_rec_.discount IS NOT NULL AND pkg_header_rec_.discount > 0) THEN
               -- Modified calculation logic of unit_price_incl_tax_
               unit_price_incl_tax_      := unit_price_incl_tax_ - line_discount_amount_;
            END IF;
         ELSE
            sale_unit_price_ := (sales_part_rec_.conv_factor / sales_part_rec_.inverted_conv_factor * cost_ * pkg_sale_unit_price_ * pkg_header_rec_.price_conv_factor) /
                                (pkg_cost_ * sales_part_rec_.price_conv_factor);         
            IF (pkg_header_rec_.discount IS NOT NULL AND pkg_header_rec_.discount > 0) THEN
               -- Modified calculation logic of sale_unit_price_ 
               sale_unit_price_ := sale_unit_price_ - line_discount_amount_;
            END IF;
         END IF;
         IF (Order_Supply_Type_API.Encode(pkg_header_rec_.demand_code) = 'IPD') THEN
            tax_liability_type_db_ := External_Cust_Order_Line_API.Get_Tax_Liability(pkg_quotation_no_, pkg_line_no_, pkg_rel_no_);
         ELSE
            tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(pkg_header_rec_.tax_liability, 
                                         NVL(pkg_header_rec_.ship_addr_country_code, header_rec_.country_code));
         END IF;

         Tax_Handling_Order_Util_API.Get_Prices(base_sale_unit_price_,
                                                base_unit_price_incl_tax_,
                                                sale_unit_price_,
                                                unit_price_incl_tax_,
                                                multiple_tax_,
												            pkg_header_rec_.tax_code,
                                                pkg_header_rec_.tax_calc_structure_id,
                                                pkg_header_rec_.tax_class_id,
                                                pkg_quotation_no_, 
                                                pkg_line_no_, 
                                                pkg_rel_no_, 
                                                -1,
                                                '*',
                                                Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                pkg_header_rec_.contract,
                                                header_rec_.customer_no,
                                                pkg_header_rec_.ship_addr_no,
                                                Site_API.Get_Site_Date(pkg_header_rec_.contract),
                                                header_rec_.supply_country,
                                                NVL(pkg_header_rec_.delivery_type, '*'),
                                                pkg_header_rec_.catalog_no,
                                                header_rec_.use_price_incl_tax,
                                                header_rec_.currency_code,
                                                pkg_header_rec_.currency_rate,
                                                'FALSE',                                                
                                                pkg_header_rec_.tax_liability,
                                                tax_liability_type_db_,
                                                delivery_country_db_ => NULL,
                                                ifs_curr_rounding_ => 16,
                                                tax_from_diff_source_ => 'FALSE',
                                                attr_ => NULL);
      END IF;

      discount_ := 0;

      Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE', base_sale_unit_price_, attr_);
      Client_SYS.Add_To_Attr('BASE_UNIT_PRICE_INCL_TAX', base_unit_price_incl_tax_, attr_);
      Client_SYS.Add_To_Attr('BUY_QTY_DUE', buy_qty_due_, attr_);
      Client_SYS.Add_To_Attr('DESIRED_QTY', desired_qty_, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
      Client_SYS.Add_To_Attr('PART_NO', sales_part_rec_.part_no, attr_);
      Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE', pkg_planned_delivery_date_, attr_);
      Client_SYS.Add_To_Attr('PROMISED_DELIVERY_DATE', pkg_planned_delivery_date_, attr_);
      Client_SYS.Add_To_Attr('REVISED_QTY_DUE', revised_qty_due_, attr_);
      Client_SYS.Add_To_Attr('SALES_UNIT_MEASURE', sales_part_rec_.sales_unit_meas, attr_);
      Client_SYS.Add_To_Attr('SALE_UNIT_PRICE', sale_unit_price_, attr_);
      Client_SYS.Add_To_Attr('UNIT_PRICE_INCL_TAX', unit_price_incl_tax_, attr_);
      Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', pkg_wanted_delivery_date_, attr_);

      IF NOT part_price_is_set_ THEN
         IF (header_rec_.use_price_incl_tax = 'TRUE') THEN
            part_price_ := unit_price_incl_tax_;
         ELSE
            part_price_ := sale_unit_price_;
         END IF;
         Client_SYS.Add_To_Attr('PART_PRICE', part_price_, attr_);
         Client_SYS.Add_To_Attr('PRICE_SOURCE_DB', pkg_header_rec_.price_source, attr_);
         Client_SYS.Add_To_Attr('PRICE_SOURCE_ID', pkg_header_rec_.price_source_id, attr_);
      END IF;
      
      IF (supply_code_db_ NOT IN ('IPD', 'PD')) THEN
         Client_SYS.Add_To_Attr('DEFAULT_ADDR_FLAG_DB', pkg_header_rec_.default_addr_flag, attr_);
         Client_SYS.Add_To_Attr('SHIP_VIA_CODE', pkg_header_rec_.ship_via_code, attr_);
         Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', pkg_header_rec_.delivery_leadtime, attr_);
         Client_SYS.Add_To_Attr('PICKING_LEADTIME', pkg_header_rec_.picking_leadtime, attr_);
      END IF;

      newrec_ := NULL;
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);       
      Insert___(objid_, objversion_, newrec_, attr_);
      --Clearing all info generated for components.
      Client_SYS.Clear_Info;
   END LOOP;
EXCEPTION
   WHEN zero_divide THEN
      Error_SYS.Record_General(lu_name_, 'WRONGCOST: The package is not permitted to have a standard cost of 0.');
END Insert_Package___;


-- Update_Package___
--   Updates the package structure
PROCEDURE Update_Package___ (
   pkg_promised_delivery_date_ IN OUT DATE,
   pkg_planned_delivery_date_  IN OUT DATE,
   pkg_planned_due_date_       IN OUT DATE,
   pkg_rec_                    IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   block_component_            IN     BOOLEAN )
IS
   oldrec_      ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   do_price_    BOOLEAN := FALSE;
   do_discount_ BOOLEAN := FALSE;
   do_planned_  BOOLEAN := FALSE;
   do_wanted_   BOOLEAN := FALSE;
   do_qty_      BOOLEAN := FALSE;
BEGIN

   oldrec_ := Get_Object_By_Keys___(pkg_rec_.quotation_no, pkg_rec_.line_no, pkg_rec_.rel_no, -1);

   IF ((oldrec_.buy_qty_due != pkg_rec_.buy_qty_due) OR
       (oldrec_.desired_qty != pkg_rec_.desired_qty)) THEN
      do_qty_ := TRUE;
   END IF;
   IF (oldrec_.discount != pkg_rec_.discount) THEN
      do_discount_ := TRUE;
      do_price_ := TRUE;
   END IF;
   IF ((oldrec_.base_sale_unit_price != pkg_rec_.base_sale_unit_price) OR
       (oldrec_.sale_unit_price != pkg_rec_.sale_unit_price)) THEN
      do_price_ := TRUE;
   END IF;
   IF (NVL(oldrec_.planned_delivery_date, Database_Sys.first_calendar_date_) != NVL(pkg_rec_.planned_delivery_date, Database_Sys.first_calendar_date_)) THEN
      do_planned_ := TRUE;
   END IF;
   IF (NVL(oldrec_.wanted_delivery_date, Database_Sys.first_calendar_date_) != NVL(pkg_rec_.wanted_delivery_date, Database_Sys.first_calendar_date_)) THEN
      do_wanted_ := TRUE;
   END IF;

   Change_Package_Structure___(pkg_promised_delivery_date_, pkg_planned_delivery_date_,
      pkg_planned_due_date_, pkg_rec_, do_qty_, do_price_, do_discount_, do_planned_, do_wanted_, TRUE, block_component_);
END Update_Package___;


-- Update_Package_Cost___
--   Updates the package cost when inserting, updating or deleting
--   the package structure.
PROCEDURE Update_Package_Cost___ (
   pkg_cost_     IN OUT NUMBER,
   pkg_quote_no_ IN     VARCHAR2,
   pkg_line_no_  IN     VARCHAR2,
   pkg_rel_no_   IN     VARCHAR2 )
IS
   revised_qty_due_ ORDER_QUOTATION_LINE_TAB.revised_qty_due%TYPE;
   CURSOR get_package_cost IS
      SELECT nvl(sum(revised_qty_due / revised_qty_due_ * cost), 0)
      FROM  ORDER_QUOTATION_LINE_TAB
      WHERE line_item_no > 0
      AND   rel_no = pkg_rel_no_
      AND   line_no = pkg_line_no_
      AND   quotation_no = pkg_quote_no_;
BEGIN
   revised_qty_due_ := ORDER_QUOTATION_LINE_API.Get_Revised_Qty_Due(pkg_quote_no_, pkg_line_no_, pkg_rel_no_, -1);
   OPEN  get_package_cost;
   FETCH get_package_cost INTO pkg_cost_;
   IF (get_package_cost%NOTFOUND) THEN
       pkg_cost_ := 0;
   END IF;
   CLOSE get_package_cost;
EXCEPTION
   WHEN zero_divide THEN
      Error_SYS.Record_General(lu_name_, 'WRONGCOST: The package is not permitted to have a standard cost of 0.');
END Update_Package_Cost___;


-- Change_Package_Structure___
--   Changes the package structure attributes when changing a package.
PROCEDURE Change_Package_Structure___ (
   pkg_promised_delivery_date_ IN OUT DATE,
   pkg_planned_delivery_date_  IN OUT DATE,
   pkg_planned_due_date_       IN OUT DATE,
   pkg_rec_                    IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   do_qty_                     IN     BOOLEAN,
   do_price_                   IN     BOOLEAN,
   do_discount_                IN     BOOLEAN,
   do_planned_                 IN     BOOLEAN,
   do_wanted_                  IN     BOOLEAN,
   statemachine_               IN     BOOLEAN,
   block_component_info_       IN     BOOLEAN )
IS
   newrec_                    ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   oldrec_                    ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   old_pkg_rec_               ORDER_QUOTATION_LINE_API.Public_Rec;
   header_rec_                ORDER_QUOTATION_API.Public_Rec;
   max_planned_delivery_date_ DATE;
   min_planned_due_date_      DATE;
   old_pkg_delivery_date_     DATE;
   max_date_                  DATE := SYSDATE - 10000;
   min_date_                  DATE := SYSDATE + 10000;
   header_objstate_           ORDER_QUOTATION_LINE_TAB.rowstate%TYPE;
   sales_rec_                 Sales_Part_API.Public_Rec;
   line_discount_amount_      NUMBER;   
   tax_liability_type_db_     VARCHAR2(20);
   multiple_tax_              VARCHAR2(20);

   CURSOR get_package_structure IS
      SELECT rowid objid
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  line_item_no > 0
      AND    line_no  = pkg_rec_.line_no
      AND    rel_no   = pkg_rec_.rel_no
      AND    quotation_no = pkg_rec_.quotation_no
      ORDER BY line_item_no;
BEGIN

   max_planned_delivery_date_ := max_date_;
   min_planned_due_date_      := min_date_;
   old_pkg_delivery_date_     := pkg_planned_delivery_date_;

   header_rec_      := ORDER_QUOTATION_API.Get(pkg_rec_.quotation_no);
   header_objstate_ := header_rec_.rowstate;
   old_pkg_rec_     := ORDER_QUOTATION_LINE_API.Get(pkg_rec_.quotation_no, pkg_rec_.line_no, pkg_rec_.rel_no, -1);

   FOR comprec_ IN get_package_structure LOOP
      newrec_ := Get_Object_By_Id___(comprec_.objid);
      oldrec_ := newrec_;
      -- set header values on all components in case they have changed
      newrec_.customer_no := pkg_rec_.customer_no;
      newrec_.ship_addr_no := pkg_rec_.ship_addr_no;
      newrec_.delivery_terms := pkg_rec_.delivery_terms;
      newrec_.del_terms_location := pkg_rec_.del_terms_location;
      newrec_.tax_liability := pkg_rec_.tax_liability; 
      newrec_.release_planning := pkg_rec_.release_planning;
      newrec_.single_occ_addr_flag := pkg_rec_.single_occ_addr_flag;
      newrec_.tax_liability_type := pkg_rec_.tax_liability_type;
      IF (newrec_.order_supply_type NOT IN ('IPD', 'PD')) THEN
         newrec_.default_addr_flag := pkg_rec_.default_addr_flag;
         newrec_.ship_via_code := pkg_rec_.ship_via_code;         
         newrec_.ext_transport_calendar_id := pkg_rec_.ext_transport_calendar_id;
         newrec_.forward_agent_id := pkg_rec_.forward_agent_id;
         newrec_.delivery_leadtime := pkg_rec_.delivery_leadtime;
         newrec_.picking_leadtime := pkg_rec_.picking_leadtime;
      END IF;

      IF do_qty_ THEN
         -- Recalculate quantities for package components
         newrec_.buy_qty_due := (pkg_rec_.buy_qty_due * newrec_.buy_qty_due) / old_pkg_rec_.buy_qty_due;
         IF pkg_rec_.desired_qty = 0 THEN
            -- desired_qty of package header is 0
            newrec_.desired_qty := 0;
         ELSIF old_pkg_rec_.desired_qty = 0 THEN
            -- desired_qty of package header has been changed from 0 to another value. So, use ratio from buy_qty_due to calculate for component
             newrec_.desired_qty := pkg_rec_.desired_qty * (newrec_.buy_qty_due / pkg_rec_.buy_qty_due);
         ELSE
            newrec_.desired_qty := (pkg_rec_.desired_qty * newrec_.desired_qty) / old_pkg_rec_.desired_qty;
         END IF;         
         newrec_.revised_qty_due := (pkg_rec_.revised_qty_due * newrec_.revised_qty_due) / old_pkg_rec_.revised_qty_due;
      END IF;

      IF do_wanted_ THEN
         newrec_.wanted_delivery_date := pkg_rec_.wanted_delivery_date;
      END IF;

      IF do_planned_ THEN
         newrec_.promised_delivery_date := pkg_promised_delivery_date_;
         newrec_.planned_delivery_date := pkg_planned_delivery_date_;

         IF (newrec_.wanted_delivery_date IS NOT NULL) THEN
            Calculate_Quote_Line_Dates___(newrec_);
         END IF;

         -- set date "bounds"
         max_planned_delivery_date_ := greatest(max_planned_delivery_date_, newrec_.planned_delivery_date);
         min_planned_due_date_ := least(min_planned_due_date_, newrec_.planned_due_date);
      END IF;

      IF do_discount_ THEN
         newrec_.discount := 0;
      END IF;

      sales_rec_:= Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);
      IF (pkg_rec_.catalog_type = 'PKG' AND pkg_rec_.price_freeze != 'FROZEN') THEN
         IF (newrec_.price_unit_meas != sales_rec_.price_unit_meas) THEN
            Client_SYS.Add_Info(lu_name_, 'PRICEUMCHG: Price unit of Measure has changed from :P1 to :P2 for component part :P3.',newrec_.price_unit_meas,sales_rec_.price_unit_meas,newrec_.catalog_no);
            newrec_.price_unit_meas := sales_rec_.price_unit_meas;
         END IF;
         IF (newrec_.sales_unit_measure != sales_rec_.sales_unit_meas) THEN
            Client_SYS.Add_Info(lu_name_, 'SALESUMCHG: Sales unit of Measure has changed from :P1 to :P2 for component part :P3.',newrec_.sales_unit_measure,sales_rec_.sales_unit_meas,newrec_.catalog_no);
            newrec_.sales_unit_measure := sales_rec_.sales_unit_meas;
         END IF;
         IF (newrec_.price_conv_factor != sales_rec_.price_conv_factor) THEN
            Client_SYS.Add_Info(lu_name_, 'PRICECONVCHG: Price Conversion factor has changed from :P1 to :P2 for component part :P3.',newrec_.price_conv_factor,sales_rec_.price_conv_factor,newrec_.catalog_no);
            newrec_.price_conv_factor := sales_rec_.price_conv_factor;
         END IF;
      END IF;

      IF do_price_ THEN
         IF (pkg_rec_.cost = 0) THEN
            newrec_.sale_unit_price := 0;
            newrec_.unit_price_incl_tax      := 0;
            newrec_.base_sale_unit_price := 0;
            newrec_.base_unit_price_incl_tax := 0;
         ELSE
            line_discount_amount_ := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(pkg_rec_.quotation_no, pkg_rec_.line_no, pkg_rec_.rel_no, -1, 
                                                                                            1, -- quantity
                                                                                           (newrec_.conv_factor / newrec_.inverted_conv_factor * newrec_.cost * pkg_rec_.price_conv_factor) /(pkg_rec_.cost * newrec_.price_conv_factor));

            IF (header_rec_.use_price_incl_tax = 'TRUE') THEN
               newrec_.unit_price_incl_tax := (newrec_.conv_factor / newrec_.inverted_conv_factor * newrec_.cost * pkg_rec_.unit_price_incl_tax * pkg_rec_.price_conv_factor) /
                                              (pkg_rec_.cost * newrec_.price_conv_factor);               

               IF (pkg_rec_.discount IS NOT NULL AND pkg_rec_.discount != 0) THEN
                  -- Modified calculation logic of newrec_.unit_price_incl_tax
                  newrec_.unit_price_incl_tax := newrec_.unit_price_incl_tax - line_discount_amount_;
               END IF;
            ELSE
               newrec_.sale_unit_price := (newrec_.conv_factor / newrec_.inverted_conv_factor * newrec_.cost * pkg_rec_.sale_unit_price * pkg_rec_.price_conv_factor) /
                      (pkg_rec_.cost * newrec_.price_conv_factor);

               IF (pkg_rec_.discount IS NOT NULL AND pkg_rec_.discount != 0) THEN
                  -- Modified calculation logic of newrec_.sale_unit_price 
                  newrec_.sale_unit_price := newrec_.sale_unit_price - line_discount_amount_;
               END IF;
            END IF;
            
            IF (Order_Supply_Type_API.Encode(old_pkg_rec_.demand_code) = 'IPD') THEN
               tax_liability_type_db_ := External_Cust_Order_Line_API.Get_Tax_Liability(pkg_rec_.quotation_no, pkg_rec_.line_no, pkg_rec_.rel_no);
            ELSE
               tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(old_pkg_rec_.tax_liability, 
                                            NVL(old_pkg_rec_.ship_addr_country_code, header_rec_.country_code));
            END IF;
           
            Tax_Handling_Order_Util_API.Get_Prices(newrec_.base_sale_unit_price,
                                                   newrec_.base_unit_price_incl_tax,
                                                   newrec_.sale_unit_price,
                                                   newrec_.unit_price_incl_tax,
                                                   multiple_tax_,
												               old_pkg_rec_.tax_code,
                                                   old_pkg_rec_.tax_calc_structure_id,
                                                   old_pkg_rec_.tax_class_id,
                                                   pkg_rec_.quotation_no, 
                                                   pkg_rec_.line_no, 
                                                   pkg_rec_.rel_no, 
                                                   -1,
                                                   '*',
                                                   Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                   old_pkg_rec_.contract,
                                                   header_rec_.customer_no,
                                                   old_pkg_rec_.ship_addr_no,
                                                   NVL(newrec_.planned_due_date, TRUNC(Site_API.Get_Site_Date(old_pkg_rec_.contract))),
                                                   header_rec_.supply_country,
                                                   NVL(old_pkg_rec_.delivery_type, '*'),
                                                   old_pkg_rec_.catalog_no,
                                                   header_rec_.use_price_incl_tax,
                                                   header_rec_.currency_code,
                                                   old_pkg_rec_.currency_rate,
                                                   'FALSE',                                                   
                                                   old_pkg_rec_.tax_liability,
                                                   tax_liability_type_db_,
                                                   delivery_country_db_ => NULL,
                                                   ifs_curr_rounding_ => 16,
                                                   tax_from_diff_source_ => 'FALSE',
                                                   attr_ => NULL);
         END IF;
      END IF;

      newrec_.rowversion := sysdate;
      Update_Line___(comprec_.objid, oldrec_, newrec_, statemachine_, FALSE);
   END LOOP;

   -- Fix PLANNED_DELIVERY_DATE and PLANNED_DUE_DATE for Package.
   IF (max_planned_delivery_date_ != max_date_) THEN
      pkg_planned_delivery_date_ := max_planned_delivery_date_;
      IF (header_objstate_ = 'Planned') THEN
         FOR comprec_ IN get_package_structure LOOP
            newrec_ := Get_Object_By_Id___(comprec_.objid);
            oldrec_ := newrec_;
            newrec_.promised_delivery_date := max_planned_delivery_date_;
            pkg_promised_delivery_date_ := max_planned_delivery_date_;
            newrec_.rowversion := sysdate;
            Update_Line___(comprec_.objid, oldrec_, newrec_, statemachine_, FALSE);
         END LOOP;
      END IF;
   END IF;
   IF (pkg_planned_delivery_date_ != old_pkg_delivery_date_) THEN
      Client_SYS.Add_Info(lu_name_, 'QLTARGETDATECHG: The target date has been changed from :P1 to :P2.',
         to_char(old_pkg_delivery_date_, 'YYYY-MM-DD HH24.MI'),
         to_char(pkg_planned_delivery_date_, 'YYYY-MM-DD HH24.MI'));
   END IF;

   -- Note: Remove all component infos that have been generated
   IF (block_component_info_) THEN
      Client_Sys.Clear_Info;
   END IF;

   IF (min_planned_due_date_ != min_date_) THEN
      pkg_planned_due_date_ := min_planned_due_date_;
   END IF;
EXCEPTION
   WHEN zero_divide THEN
      Error_Sys.Record_General(lu_name_, 'WRONGCOST: The package is not permitted to have a standard cost of 0.');
END Change_Package_Structure___;


-- Modify_Line___
--   General method for the public modify procedures
PROCEDURE Modify_Line___ (
   attr_         IN OUT VARCHAR2,
   quotation_no_ IN     VARCHAR2,
   line_no_      IN     VARCHAR2,
   rel_no_       IN     VARCHAR2,
   line_item_no_ IN     NUMBER )
IS
   objid_   ORDER_QUOTATION_LINE.objid%type;
   objver_  ORDER_QUOTATION_LINE.objversion%type;
   info_    VARCHAR2(32000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objver_, quotation_no_, line_no_, rel_no_, line_item_no_);
   Modify__(info_, objid_, objver_, attr_, 'DO');
   -- clear info value, since no use of that string here - and if updating via calendar_changed method
   -- in customer_order_api, it might "hit the roof" right away.
   Client_SYS.Clear_Info;
END Modify_Line___;


-- Get_Line_Defaults___
--   Field validation on column catalog_no from client.
PROCEDURE Get_Line_Defaults___ (
   attr_         IN OUT VARCHAR2,
   catalog_no_   IN OUT VARCHAR2,
   quotation_no_ IN     VARCHAR2 )
IS
   buy_qty_due_               NUMBER;
   currency_rate_             NUMBER;
   sale_unit_price_           NUMBER;
   unit_price_incl_tax_       NUMBER;
   base_sale_unit_price_      NUMBER;
   base_unit_price_incl_tax_  NUMBER;
   discount_                  NUMBER;
   price_source_              VARCHAR2(200);
   price_list_no_             ORDER_QUOTATION_LINE_TAB.price_list_no%TYPE;
   catalog_desc_              ORDER_QUOTATION_LINE_TAB.catalog_desc%TYPE;
   sales_part_desc_           ORDER_QUOTATION_LINE_TAB.catalog_desc%TYPE;
   cost_                      NUMBER;
   header_rec_                ORDER_QUOTATION_API.Public_Rec;
   sales_part_rec_            Sales_Part_API.Public_Rec;
   org_catalog_no_            ORDER_QUOTATION_LINE_TAB.catalog_no%TYPE;
   replaced_                  BOOLEAN := FALSE;
   supply_code_               ORDER_QUOTATION_LINE_TAB.order_supply_type%TYPE;
   supply_code_client_        VARCHAR2(200);
   price_source_id_           ORDER_QUOTATION_LINE_TAB.price_source_id%TYPE;
   customer_part_no_          ORDER_QUOTATION_LINE_TAB.customer_part_no%TYPE;
   cross_rec_                 Sales_Part_Cross_Reference_API.Public_Rec;
   customer_part_conv_factor_ NUMBER;
   customer_part_unit_meas_   VARCHAR2(50);
   condition_code_            ORDER_QUOTATION_LINE_TAB.condition_code%TYPE;
   vendor_no_                 ORDER_QUOTATION_LINE_TAB.vendor_no%TYPE;
   self_billing_db_           ORDER_QUOTATION_LINE_TAB.self_billing%TYPE;
   replace_part_              VARCHAR2(25);
   replace_date_              DATE;
   overload_count_            NUMBER := 0;
   created_by_server_         BOOLEAN;
   revised_qty_due_           NUMBER := 0;
   configuration_id_          ORDER_QUOTATION_LINE_TAB.configuration_id%TYPE;
   net_price_fetched_         VARCHAR2(20);
   input_unit_meas_group_id_  VARCHAR2(30);
   default_input_uom_         VARCHAR2(30);
   uom_rec_                   Input_Unit_Meas_API.Public_Rec;
   part_level_db_             VARCHAR2(30) := NULL;
   part_level_id_             VARCHAR2(200) := NULL;
   customer_level_db_         VARCHAR2(30) := NULL;
   customer_level_id_         VARCHAR2(200) := NULL;
   tax_code_                  ORDER_QUOTATION_LINE_TAB.tax_code%TYPE;
   tax_class_                 ORDER_QUOTATION_LINE_TAB.tax_class_id%TYPE;
   part_price_                NUMBER;
   customer_category_         CUSTOMER_INFO_TAB.customer_category%TYPE;
   rental_db_                 ORDER_QUOTATION_LINE_TAB.rental%TYPE;
   usage_                     VARCHAR2(20);
   sales_price_type_db_       VARCHAR2(20);
   dummy_rec_                 ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   rental_chargeable_days_    NUMBER;
   cust_part_inver_conv_fact_ NUMBER;

BEGIN

   header_rec_ := ORDER_QUOTATION_API.Get(quotation_no_);
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(header_rec_.customer_no);
   -- Fetch already entered defaults from the attribute-string.
   buy_qty_due_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('BUY_QTY_DUE', attr_));
   vendor_no_ := Client_SYS.Get_Item_Value('VENDOR_NO', attr_);

   created_by_server_ := (NVL(Client_SYS.Get_Item_Value('CREATED_BY_SERVER', attr_), '0') = '1');

   rental_db_ := NVL(Client_SYS.Get_Item_Value('RENTAL_DB', attr_), Fnd_Boolean_API.DB_FALSE);

   IF (rental_db_ = Fnd_Boolean_API.DB_FALSE) THEN
      usage_ := Sales_Type_API.DB_SALES_ONLY;
      sales_price_type_db_ := Sales_Price_Type_API.DB_SALES_PRICES;
   ELSE
      usage_ := Sales_Type_API.DB_RENTAL_ONLY;
      sales_price_type_db_ := Sales_Price_Type_API.DB_RENTAL_PRICES;
      rental_chargeable_days_ := Get_Latest_Rent_Charge_Days___(attr_, dummy_rec_);
   END IF;

   -- Check if it's a valid and active sales part.
   Sales_Part_API.Exist(header_rec_.contract, catalog_no_, usage_);

   -- Retrive information from the sales part
   sales_part_rec_  := Sales_Part_API.Get(header_rec_.contract, catalog_no_);
   sales_part_desc_ := Sales_Part_API.Get_Catalog_Desc(header_rec_.contract, catalog_no_, header_rec_.language_code);

   -- Check if the specified sales part has been superseded by a replacement part.
   replace_part_ := sales_part_rec_.replacement_part_no;
   replace_date_ := sales_part_rec_.date_of_replacement;
   -- Check if the specified sales part has been superseded by a replacement part.
   LOOP
      IF (replace_part_ IS NOT NULL) AND (replace_date_ <= (Site_API.Get_Site_Date(header_rec_.contract))) THEN
         IF (overload_count_ = 10) THEN
            Error_SYS.Record_General(lu_name_, 'REPOVERLOADED: No of Part Replacements are exceeded, Please check your sales part replacement data.');
         ELSE
            Client_SYS.Add_Info(lu_name_, 'REPLACED: The sales part :P1 on the order line has been superseded by replacement part :P2.', catalog_no_, replace_part_);
            org_catalog_no_ := catalog_no_;
            catalog_no_ := replace_part_;
            replaced_ := TRUE;

            sales_part_rec_  := Sales_Part_API.Get(header_rec_.contract, catalog_no_);
            sales_part_desc_ := Sales_Part_API.Get_Catalog_Desc(header_rec_.contract, catalog_no_, header_rec_.language_code);

            -- Fetch new replcement part
            replace_part_ := sales_part_rec_.replacement_part_no;
            replace_date_ := sales_part_rec_.date_of_replacement;
         END IF;
      ELSE
          EXIT;
      END IF;
      overload_count_ := overload_count_ + 1;
   END LOOP;

   IF (sales_part_rec_.activeind = 'N') THEN
      Client_SYS.Clear_Info;
      IF (replaced_ = TRUE) THEN
         -- Replacement part is not active.
         Client_SYS.Add_Info(lu_name_, 'NOT_ACTIVE2: The sales part :P1 has been superceded by a replacement part (:P2) that is not active for sale.', org_catalog_no_, catalog_no_ );
      ELSE
         Client_SYS.Add_Info(lu_name_, 'NOT_ACTIVE: The sales part :P1 is not active for sale', catalog_no_);
      END IF;
   END IF;

   -- fetch catalog description from the cross reference
   customer_part_no_ := Sales_Part_Cross_Reference_API.Get_Customer_Part_No(header_rec_.customer_no, header_rec_.contract, catalog_no_);

   IF (customer_part_no_ IS NOT NULL) THEN
      cross_rec_ := Sales_Part_Cross_Reference_API.Get(header_rec_.customer_no, header_rec_.contract, customer_part_no_);
      catalog_desc_ := cross_rec_.catalog_desc;
      customer_part_conv_factor_ := GREATEST(NVL(cross_rec_.conv_factor, 1), 0);
      cust_part_inver_conv_fact_ := greatest(NVL(cross_rec_.inverted_conv_factor, 1), 0);
      customer_part_unit_meas_ := NVL(cross_rec_.customer_unit_meas, Client_SYS.Get_Item_Value('SALES_UNIT_MEASURE', attr_));
   ELSE
      customer_part_conv_factor_ := NULL;
      customer_part_unit_meas_   := NULL;
      cust_part_inver_conv_fact_ := NULL;
   END IF;

   IF (catalog_desc_ IS NULL) THEN
      -- Fetch catalog description in the order's language
      catalog_desc_ := Sales_Part_Language_Desc_API.Get_Catalog_Desc(header_rec_.contract, catalog_no_, header_rec_.language_code);
   END IF;

   -- Use SalesPart's description as final value
   IF (catalog_desc_ IS NULL) THEN
      catalog_desc_ := sales_part_desc_;
   END IF;

   -- Check if it's a active inventory part.
   Check_Active_Part___(header_rec_.contract, sales_part_rec_.part_no);

   IF (sales_part_rec_.part_no IS NOT NULL) THEN
      IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(sales_part_rec_.part_no) = 'ALLOW_COND_CODE') THEN
         condition_code_ := Client_SYS.Get_Item_Value('CONDITION_CODE', attr_);
         IF (condition_code_ IS NULL) THEN
            condition_code_ := Condition_Code_API.Get_Default_Condition_Code;
         END IF;
      END IF;
   END IF;

   -- IF supply code is null, get the default supply code for the sales part
   supply_code_client_ := Client_SYS.Get_Item_Value('ORDER_SUPPLY_TYPE', attr_);

   IF (supply_code_client_ IS NULL) THEN
      -- Get the default supply code for the sales part
      supply_code_client_ := Sales_Part_API.Get_Default_Supply_Code(header_rec_.contract, catalog_no_, rental_db_);
      supply_code_ := Order_Supply_Type_API.Encode(supply_code_client_);

      -- if no supply code was "found" - i.e. sourcing option PRIMARYSUPP... is used and primary supplier is not connect to the part.
      IF (supply_code_ IS NULL) AND (sales_part_rec_.sourcing_option IN ('PRIMARYSUPPTRANSIT', 'PRIMARYSUPPDIRECT')) THEN
         IF created_by_server_ THEN
            Error_SYS.Record_General(lu_name_, 'NO_PRIMARY_SUPP: No primary supplier exists for purchase part :P1.', sales_part_rec_.purchase_part_no);
         ELSE
            Client_SYS.Add_Info(lu_name_, 'NO_PRIMARY_SUPP: No primary supplier exists for purchase part :P1.', sales_part_rec_.purchase_part_no);
         END IF;
      END IF;
   ELSE
      supply_code_ := Order_Supply_Type_API.Encode(supply_code_client_);
   END IF;

   -- Logic for Cost
   revised_qty_due_ := buy_qty_due_ * sales_part_rec_.conv_factor / sales_part_rec_.inverted_conv_factor;
   IF (sales_part_rec_.part_no IS NULL) THEN
      cost_ := NVL(sales_part_rec_.cost, 0);
   ELSE
      IF (revised_qty_due_ IS NOT NULL AND rental_db_ = Fnd_Boolean_API.DB_FALSE) THEN
         configuration_id_ := NVL(Client_SYS.Get_Item_Value('CONFIGURATION_ID', attr_),'*');
         cost_ := Sales_Cost_Util_API.Get_Cost_Incl_Sales_Overhead(header_rec_.contract,
                                                                   sales_part_rec_.part_no,
                                                                   configuration_id_,
                                                                   condition_code_,
                                                                   revised_qty_due_,
                                                                   'CHARGED ITEM',
                                                                   supply_code_,
                                                                   header_rec_.customer_no,
                                                                   NULL);
      ELSE
         cost_ := 0;
      END IF;
   END IF;

   -- In case we have a customer or prospect   
   -- Find default price list.
   Sales_Price_List_API.Get_Valid_Price_List(customer_level_db_,        customer_level_id_,                 price_list_no_, 
                                             header_rec_.contract,      catalog_no_,                        header_rec_.customer_no, 
                                             header_rec_.currency_code, header_rec_.price_effectivity_date, NULL,
                                             sales_price_type_db_);   

   IF (NVL(buy_qty_due_, 0) != 0) THEN
      sale_unit_price_     := Client_SYS.Get_Item_Value('SALE_UNIT_PRICE', attr_);
      unit_price_incl_tax_ := Client_SYS.Get_Item_Value('UNIT_PRICE_INCL_TAX', attr_);
      
      -- Values for the sale_unit_price_ and unit_price_incl_tax_ only comes in the copy quotation flow.  
      -- Find prices, currency and discount.
      Customer_Order_Pricing_API.Get_Quote_Line_Price_Info(sale_unit_price_, unit_price_incl_tax_, base_sale_unit_price_, base_unit_price_incl_tax_,
                                                           currency_rate_, discount_, price_source_, price_source_id_, net_price_fetched_, 
                                                           part_level_db_, part_level_id_, customer_level_db_, customer_level_id_,
                                                           quotation_no_, catalog_no_, buy_qty_due_, price_list_no_, header_rec_.price_effectivity_date,
                                                           condition_code_, header_rec_.use_price_incl_tax, rental_chargeable_days_);

   ELSE
      price_source_ := Pricing_Source_API.Decode('UNSPECIFIED');
      price_source_id_ := NULL;
      sale_unit_price_ := 0;
      unit_price_incl_tax_       := 0;
      base_sale_unit_price_ := 0;
      base_unit_price_incl_tax_  := 0;
      currency_rate_ := 1;
      discount_ := 0;
      net_price_fetched_ := 'FALSE';
   END IF;

   IF (supply_code_ IN ('IPT', 'IPD', 'PT', 'PD')) THEN
      -- Note : IF supply_code is IPD/IPT then get the Primary Supplier No for the purchase_part_no
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         IF (rental_db_ = Fnd_Boolean_API.DB_FALSE) THEN
            vendor_no_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(header_rec_.contract,
                                                                             sales_part_rec_.purchase_part_no);
         ELSE
            vendor_no_ := Purchase_Part_Supplier_API.Get_Primary_Rental_Supplier_No(header_rec_.contract,
                                                                                    sales_part_rec_.purchase_part_no);
         END IF;         
      $ELSE
         NULL;
      $END   
      END IF;

   self_billing_db_ := NVL(Sales_Part_Cross_Reference_API.Get_Self_Billing_Db(header_rec_.customer_no, header_rec_.contract, customer_part_no_), 'NOT SELF BILLING');
   
   IF (header_rec_.use_price_incl_tax = 'TRUE') THEN
      part_price_ := unit_price_incl_tax_;
   ELSE
      part_price_ := sale_unit_price_;
   END IF;
   
   tax_code_ := Client_SYS.Get_Item_Value('TAX_CODE', attr_);
   tax_class_ := Client_SYS.Get_Item_Value('TAX_CLASS_ID', attr_);

   -- Return all defaults using the attribute string.
   Client_SYS.Clear_Attr(attr_);

   IF (org_catalog_no_ IS NOT NULL) THEN
      -- The part has been replaced
      Client_SYS.Add_To_Attr('ORIGINAL_PART_NO', org_catalog_no_, attr_);
   END IF;

   Client_SYS.Add_To_Attr('CATALOG_DESC', catalog_desc_, attr_);
   Client_SYS.Add_To_Attr('BUY_QTY_DUE', buy_qty_due_, attr_);
   Client_SYS.Add_To_Attr('REVISED_QTY_DUE', buy_qty_due_ * sales_part_rec_.conv_factor / sales_part_rec_.inverted_conv_factor, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_RATE', currency_rate_, attr_);
   Client_SYS.Add_To_Attr('CONV_FACTOR', sales_part_rec_.conv_factor, attr_);
   Client_SYS.Add_To_Attr('PRICE_CONV_FACTOR', sales_part_rec_.price_conv_factor, attr_);
   Client_SYS.Add_To_Attr('PART_PRICE', part_price_, attr_);
   Client_SYS.Add_To_Attr('SALE_UNIT_PRICE', sale_unit_price_, attr_);
   Client_SYS.Add_To_Attr('UNIT_PRICE_INCL_TAX', unit_price_incl_tax_, attr_);
   Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE', base_sale_unit_price_, attr_);
   Client_SYS.Add_To_Attr('BASE_UNIT_PRICE_INCL_TAX', base_unit_price_incl_tax_, attr_);
   Client_SYS.Add_To_Attr('PRICE_SOURCE', price_source_, attr_);
   Client_SYS.Add_To_Attr('SALES_UNIT_MEASURE', sales_part_rec_.sales_unit_meas, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
   Client_SYS.Add_To_Attr('COST', cost_, attr_);
   Client_SYS.Add_To_Attr('PART_NO', sales_part_rec_.part_no, attr_);
   Client_SYS.Add_To_Attr('CATALOG_TYPE', Sales_Part_Type_API.Decode(sales_part_rec_.catalog_type), attr_);
   Client_SYS.Add_To_Attr('CATALOG_TYPE_DB', sales_part_rec_.catalog_type, attr_);
   Client_SYS.Add_To_Attr('PRICE_LIST_NO', price_list_no_, attr_);
   Client_SYS.Add_To_Attr('CHARGED_ITEM_DB', 'CHARGED ITEM', attr_);
   Client_SYS.Add_To_Attr('ORDER_SUPPLY_TYPE', supply_code_client_, attr_);
   Client_SYS.Add_To_Attr('PRICE_SOURCE_ID', price_source_id_, attr_);
   Client_SYS.Add_To_Attr('PRICE_SOURCE_NET_PRICE_DB', net_price_fetched_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PART_NO', customer_part_no_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PART_CONV_FACTOR', customer_part_conv_factor_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PART_UNIT_MEAS', customer_part_unit_meas_, attr_);
   Client_SYS.Add_To_Attr('CONDITION_CODE', condition_code_ , attr_);
   Client_SYS.Add_To_Attr('VENDOR_NO', vendor_no_, attr_);
   Client_SYS.Add_To_Attr('SELF_BILLING_DB', self_billing_db_, attr_);
   Client_SYS.Add_To_Attr('SELF_BILLING', Self_Billing_Type_API.Decode(self_billing_db_), attr_);
   Client_SYS.Add_To_Attr('PART_LEVEL_DB', part_level_db_, attr_);
   Client_SYS.Add_To_Attr('PART_LEVEL_ID', part_level_id_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_DB', customer_level_db_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_ID', customer_level_id_, attr_);
   Client_SYS.Add_To_Attr('INVERTED_CONV_FACTOR', sales_part_rec_.inverted_conv_factor, attr_);
   Client_SYS.Add_To_Attr('CUST_PART_INVERT_CONV_FACT', cust_part_inver_conv_fact_, attr_);

   input_unit_meas_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(header_rec_.contract, sales_part_rec_.part_no);
   IF input_unit_meas_group_id_ IS NOT NULL THEN
      default_input_uom_ := Input_Unit_Meas_API.Get_Default_Input_Uom(input_unit_meas_group_id_);
      IF default_input_uom_ IS NOT NULL THEN
         uom_rec_ := Input_Unit_Meas_API.Get(input_unit_meas_group_id_, default_input_uom_);
         IF (uom_rec_.cust_usage_allowed = 1) THEN
            Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS', default_input_uom_, attr_);
            Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR', uom_rec_.conversion_factor, attr_);
         END IF;
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('TAX_CODE', tax_code_, attr_);
   Client_SYS.Add_To_Attr('TAX_CLASS_ID', tax_class_, attr_);
   Client_SYS.Add_To_Attr('RENTAL_DB', rental_db_, attr_);
END Get_Line_Defaults___;


-- Get_Default_Part_Attributes___
--   Retrieve default attribute values for a sales part sales part.
--   All the default attributes retrieved will be merged with the
--   attribute string passed in.
PROCEDURE Get_Default_Part_Attributes___ (
   attr_ IN OUT VARCHAR2 )
IS
   quotation_no_              ORDER_QUOTATION_LINE_TAB.quotation_no%TYPE;
   line_no_                   ORDER_QUOTATION_LINE_TAB.line_no%TYPE;
   rel_no_                    ORDER_QUOTATION_LINE_TAB.REL_NO%TYPE;
   line_item_no_              ORDER_QUOTATION_LINE_TAB.LINE_ITEM_NO%TYPE;
   contract_                  ORDER_QUOTATION_LINE_TAB.contract%TYPE;
   buy_qty_due_               ORDER_QUOTATION_LINE_TAB.buy_qty_due%TYPE;
   catalog_no_                ORDER_QUOTATION_LINE_TAB.catalog_no%TYPE;
   catalog_desc_              ORDER_QUOTATION_LINE_TAB.catalog_desc%TYPE;
   customer_no_               ORDER_QUOTATION_LINE_TAB.customer_no%TYPE;
   customer_part_no_          ORDER_QUOTATION_LINE_TAB.customer_part_no%TYPE;
   customer_part_buy_qty_     ORDER_QUOTATION_LINE_TAB.customer_part_buy_qty%TYPE;
   customer_part_conv_factor_ ORDER_QUOTATION_LINE_TAB.customer_part_conv_factor%TYPE;
   customer_part_unit_meas_   ORDER_QUOTATION_LINE_TAB.customer_part_unit_meas%TYPE;
   customer_part_desc_        ORDER_QUOTATION_LINE_TAB.catalog_desc%TYPE;
   base_sale_unit_price_      ORDER_QUOTATION_LINE_TAB.base_sale_unit_price%TYPE;
   base_sale_unit_price_incl_tax_ ORDER_QUOTATION_LINE_TAB.base_unit_price_incl_tax%TYPE;
   sale_unit_price_           ORDER_QUOTATION_LINE_TAB.sale_unit_price%TYPE;
   unit_price_incl_tax_        ORDER_QUOTATION_LINE_TAB.unit_price_incl_tax%TYPE;
   cross_rec_                 SALES_PART_CROSS_REFERENCE_API.Public_Rec;
   default_attr_              VARCHAR2(2000);
   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);
   header_rec_                ORDER_QUOTATION_API.Public_Rec;
   currency_rate_             NUMBER;
   copy_status_               VARCHAR2(5);
   cust_part_invert_conv_fact_ CUSTOMER_ORDER_LINE_TAB.cust_part_invert_conv_fact%TYPE;
   
BEGIN
   quotation_no_ := Client_SYS.Get_Item_Value('QUOTATION_NO', attr_);
   line_no_      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   rel_no_       := Client_SYS.Get_Item_Value('REL_NO', attr_);
   line_item_no_ := Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_);
   copy_status_  := Client_SYS.Get_Item_Value('COPY_STATUS', attr_ );
   
   header_rec_ := ORDER_QUOTATION_API.Get(quotation_no_);

   customer_part_no_ := Client_SYS.Get_Item_Value('CUSTOMER_PART_NO', attr_);
   catalog_no_ := Client_SYS.Get_Item_Value('CATALOG_NO', attr_);
   catalog_desc_ := Client_SYS.Get_Item_Value('CATALOG_DESC', attr_);
   value_ := Client_SYS.Get_Item_Value('BUY_QTY_DUE', attr_);

   IF (value_ IS NOT NULL) THEN
      buy_qty_due_ := Client_SYS.Attr_Value_To_Number(value_);
   END IF;

   value_ := Client_SYS.Get_Item_Value('CUSTOMER_PART_BUY_QTY', attr_);
   IF (value_ IS NOT NULL) THEN
      customer_part_buy_qty_ := Client_SYS.Attr_Value_To_Number(value_);
   END IF;

   value_ := Client_SYS.Get_Item_Value('SALE_UNIT_PRICE', attr_);
   IF (value_ IS NOT NULL) THEN
      sale_unit_price_ := Client_SYS.Attr_Value_To_Number(value_);
   END IF;

   value_ := Client_SYS.Get_Item_Value('UNIT_PRICE_INCL_TAX', attr_);
   IF (value_ IS NOT NULL) THEN
      unit_price_incl_tax_ := Client_SYS.Attr_Value_To_Number(value_);
   END IF;
   value_ := Client_SYS.Get_Item_Value('BASE_SALE_UNIT_PRICE', attr_);
   IF (value_ IS NOT NULL) THEN
      base_sale_unit_price_ := Client_SYS.Attr_Value_To_Number(value_);
   END IF;
    value_ := Client_SYS.Get_Item_Value('BASE_UNIT_PRICE_INCL_TAX', attr_);
   IF (value_ IS NOT NULL) THEN
      base_sale_unit_price_incl_tax_ := Client_SYS.Attr_Value_To_Number(value_);
   END IF;

   customer_no_ := header_rec_.customer_no;
   contract_ := header_rec_.contract;

   -- IF a customer part number has been specified then check the sales part cross reference.
   IF (customer_part_no_ IS NOT NULL) THEN
      cross_rec_ := Sales_Part_Cross_Reference_API.Get(customer_no_, contract_, customer_part_no_);
      catalog_no_ := cross_rec_.catalog_no;
      customer_part_unit_meas_ := cross_rec_.customer_unit_meas;
      IF (catalog_desc_ IS NULL) THEN
         customer_part_desc_ := cross_rec_.catalog_desc;
      END IF;
      IF (customer_part_buy_qty_ IS NOT NULL) THEN
         customer_part_conv_factor_ := cross_rec_.conv_factor;
         cust_part_invert_conv_fact_ := cross_rec_.inverted_conv_factor;
         IF (customer_part_conv_factor_ IS NOT NULL) THEN
            buy_qty_due_ := (customer_part_buy_qty_ * customer_part_conv_factor_) / cust_part_invert_conv_fact_;
         ELSE
            buy_qty_due_ := customer_part_buy_qty_;
         END IF;
      END IF;
   END IF;

   Client_SYS.Clear_Attr(default_attr_);
   Client_SYS.Set_Item_Value('BUY_QTY_DUE', buy_qty_due_, default_attr_);
   Client_SYS.Set_Item_Value('CREATED_BY_SERVER', (Client_SYS.Get_Item_Value('CREATED_BY_SERVER', attr_)), default_attr_);
   -- Add rental_db value to check for valid and active sales part.
   Client_SYS.Set_Item_Value('RENTAL_DB', (Client_SYS.Get_Item_Value('RENTAL_DB', attr_)), default_attr_);

   Get_Line_Defaults___(default_attr_, catalog_no_, quotation_no_);

   -- Check if a price was passed with the attribute string.
   -- IF that was the case this price should override the default price
   IF (sale_unit_price_ IS NOT NULL) THEN
      -- Get the corresponding base sale unit price
      Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_sale_unit_price_, currency_rate_,
                                                            NVL(header_rec_.customer_no_pay, header_rec_.customer_no),
                                                            contract_,header_rec_.currency_code, sale_unit_price_);
      Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_sale_unit_price_incl_tax_, currency_rate_,
                                                            NVL(header_rec_.customer_no_pay, header_rec_.customer_no),
                                                            contract_,header_rec_.currency_code, unit_price_incl_tax_);
      Client_SYS.Set_Item_Value('BASE_SALE_UNIT_PRICE', base_sale_unit_price_, default_attr_);
      Client_SYS.Set_Item_Value('BASE_UNIT_PRICE_INCL_TAX', base_sale_unit_price_incl_tax_, default_attr_);
   ELSIF (base_sale_unit_price_ IS NOT NULL) THEN
      -- Get the corresponding sale unit price
      Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(sale_unit_price_, currency_rate_,
                                                             NVL(header_rec_.customer_no_pay, header_rec_.customer_no),
                                                             contract_,header_rec_.currency_code, base_sale_unit_price_);
      Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(unit_price_incl_tax_, currency_rate_,
                                                             NVL(header_rec_.customer_no_pay, header_rec_.customer_no),
                                                             contract_,header_rec_.currency_code, base_sale_unit_price_incl_tax_);
      Client_SYS.Set_Item_Value('SALE_UNIT_PRICE', sale_unit_price_, default_attr_);
      Client_SYS.Set_Item_Value('UNIT_PRICE_INCL_TAX', unit_price_incl_tax_, default_attr_);
   END IF;

   IF (copy_status_ = Fnd_Boolean_API.DB_TRUE) AND (unit_price_incl_tax_ IS NULL OR base_sale_unit_price_incl_tax_ IS NULL) THEN
      Calculate_Prices(sale_unit_price_, unit_price_incl_tax_, base_sale_unit_price_, base_sale_unit_price_incl_tax_, quotation_no_, line_no_, rel_no_, line_item_no_); 
      Client_SYS.Set_Item_Value('UNIT_PRICE_INCL_TAX', unit_price_incl_tax_, default_attr_);
      Client_SYS.Set_Item_Value('BASE_UNIT_PRICE_INCL_TAX', base_sale_unit_price_incl_tax_, default_attr_);   
   END IF;

   IF (customer_part_desc_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('CATALOG_DESC', customer_part_desc_, default_attr_);
   END IF;

   Client_SYS.Add_To_Attr('CONTRACT', contract_, default_attr_);
   Client_SYS.Add_To_Attr('CATALOG_NO', catalog_no_, default_attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PART_UNIT_MEAS', customer_part_unit_meas_, default_attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PART_CONV_FACTOR', customer_part_conv_factor_, default_attr_);
   Client_SYS.Add_To_Attr('CUST_PART_INVERT_CONV_FACT', cust_part_invert_conv_fact_, default_attr_);

   -- Merge the default attributes with the attribute string passed in
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(default_attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, attr_);
   END LOOP;
END Get_Default_Part_Attributes___;


-- Add_Info___
--   Help routine for handling the client info string. Makes sure the
--   string never exceed 2000 characters.
PROCEDURE Add_Info___ (
   info_                IN VARCHAR2,
   insert_package_mode_ IN BOOLEAN )
IS  
   current_info_ VARCHAR2(32000);
BEGIN
   IF NOT insert_package_mode_ THEN      
      current_info_ := App_Context_SYS.Find_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_');
      current_info_ := SUBSTR(current_info_ || info_, 1, 2000);
      App_Context_SYS.Set_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_',current_info_);
   END IF;
END Add_Info___;


-- Check_Before_Insert___
--   Perform checks needed before inserting a new record.
PROCEDURE Check_Before_Insert___ (
   attr_                IN OUT VARCHAR2,
   newrec_              IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   header_curr_code_    IN     VARCHAR2 )
IS
   sales_part_rec_         Sales_Part_API.Public_Rec;
   price_effectivity_date_ DATE;
   customer_agreement_     VARCHAR2(25);   
   delivery_terms_         ORDER_QUOTATION_LINE_TAB.delivery_terms%TYPE;
   agreement_rec_          Customer_Agreement_API.Public_Rec;
   quotation_rec_          Order_Quotation_API.Public_Rec;
   sales_price_type_db_    VARCHAR2(20);
BEGIN
   Check_Supply_Code___(newrec_);

   IF (newrec_.line_item_no > 0) THEN
      Sales_Part_API.Check_If_Valid_Component(newrec_.contract, newrec_.catalog_no, 'NO');
   ELSE
      Exist_Line_No(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, null);
   END IF;

   IF (newrec_.condition_code IS NOT NULL) THEN
      IF (newrec_.catalog_type = 'PKG') THEN
         Error_SYS.Record_General(lu_name_,'NO_COND_ON_PKG: Condition codes are not allowed for Package Parts.');
      ELSIF (newrec_.catalog_type = 'NON') THEN
         Error_SYS.Record_General(lu_name_,'NO_COND_ON_NON: Condition codes are not allowed for Non Inventory Sales Parts.');
      END if;
   END IF;

   IF ((newrec_.buy_qty_due < 0) AND (newrec_.order_supply_type != 'SEO')) THEN
      Error_SYS.Record_General(lu_name_, 'QQTY_LESS_THAN_ZERO: Quantity must be greater or equal to zero!');
   END IF;

   IF (newrec_.order_supply_type = 'PKG') AND (newrec_.buy_qty_due = 0) THEN
      Error_SYS.Record_General(lu_name_, 'QQTYPKGZERO: Package quantity may not be zero!');
   END IF;

   -- Check that percentage quotation_probability is between 0 % and 100 %.
   IF (newrec_.probability_to_win < 0) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_PROBABILITY1: The quotation probability cannot be less than 0 %.');
   ELSIF NOT (newrec_.probability_to_win <= 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_PROBABILITY2: The quotation probability cannot be more than 100 %.');
   END IF;

   IF (newrec_.base_sale_unit_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'PRICE_LESS_THAN_ZERO: Price must be greater than zero!');
   END IF;

   IF (newrec_.sale_unit_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'PRICE_LESS_THAN_ZERO: Price must be greater than zero!');
   END IF;

   -- Order discount may not be >= 100%
   IF (newrec_.quotation_discount >= 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGDISC: Quotation discount must be lower than 100%.');
   END IF;

   IF (newrec_.discount > 100) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISC: The total discount given cannot exceed the quotation line price.');
   END IF;

   sales_part_rec_ := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);
   
   IF (newrec_.rental = Fnd_Boolean_API.DB_FALSE) THEN
      sales_price_type_db_  := Sales_Price_Type_API.DB_SALES_PRICES;
   ELSE
      sales_price_type_db_  := Sales_Price_Type_API.DB_RENTAL_PRICES;
   END IF;
   
   IF (newrec_.price_list_no IS NOT NULL) THEN
      -- Check if valid
      price_effectivity_date_ := ORDER_QUOTATION_API.Get_Price_Effectivity_Date(newrec_.quotation_no);

      IF ((Sales_Price_List_API.Is_Valid(newrec_.price_list_no, newrec_.contract, newrec_.catalog_no, price_effectivity_date_, sales_price_type_db_) = FALSE) 
          AND (Sales_Price_List_API.Is_Valid_Assort(newrec_.price_list_no, newrec_.contract, newrec_.catalog_no, price_effectivity_date_) = FALSE) ) 
          OR (Sales_Price_List_API.Get_Sales_Price_Group_Id(newrec_.price_list_no) != sales_part_rec_.sales_price_group_id) THEN
         Error_Sys.Record_General(lu_name_, 'INVALID_PRICELIST: The selected sales price list has no valid part-based line or a valid assortment-node-based line for the sales part.'); 
      END IF;
   END IF;

   -- Make sure the specified address for the order line is valid.
   IF (newrec_.ship_addr_no IS NOT NULL) THEN
      IF (Cust_Ord_Customer_Address_API.Is_Ship_Location(newrec_.customer_no, newrec_.ship_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTDELADDR: Invalid delivery address specified.');
      END IF;

      IF (Cust_Ord_Customer_Address_API.Is_Valid(newrec_.customer_no, newrec_.ship_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDDELADDR: Delivery address :P1 is invalid. Check the validity period.', newrec_.ship_addr_no);
      END IF;
   END IF;

   -- Checks for release planning
   IF ((newrec_.release_planning = 'RELEASED') AND (newrec_.buy_qty_due = 0)) THEN
      Error_SYS.Record_General(lu_name_, 'QNORELEASE_PLAN2: Price breaked line cannot be included in planning.');
   END IF;

   -- Check if it's an active inventory part.
   Check_Active_Part___(newrec_.contract, sales_part_rec_.part_no);

   -- Info
   IF (newrec_.buy_qty_due = 0) THEN
       Client_SYS.Add_Info(lu_name_, 'QUNOQTY: No quantity on line. Check quantity or enter price breaks');
   END IF;

   IF (newrec_.configuration_id != '*') THEN
       Order_Config_Util_API.Configuration_Exist(nvl(newrec_.part_no, newrec_.catalog_no), newrec_.configuration_id);
   END IF;   

   IF (newrec_.price_source = 'AGREEMENT') THEN
      customer_agreement_ := newrec_.price_source_id;
   ELSE
      customer_agreement_ := NULL;
   END IF;
   
   IF (customer_agreement_ IS NOT NULL) THEN
      agreement_rec_ := Customer_Agreement_API.Get(customer_agreement_);
      quotation_rec_ := Order_Quotation_API.Get(newrec_.quotation_no);
      delivery_terms_ := agreement_rec_.delivery_terms;

      -- when a customer agreement exists.
      IF (delivery_terms_ IS NOT NULL) THEN
         newrec_.delivery_terms     := delivery_terms_;
         newrec_.del_terms_location := agreement_rec_.del_terms_location;
      ELSE
         newrec_.delivery_terms     := quotation_rec_.delivery_terms;
         newrec_.del_terms_location := quotation_rec_.del_terms_location;
      END IF;
      
      IF ((NVL(quotation_rec_.delivery_terms, ' ' )!= NVL(newrec_.delivery_terms, ' ' )) OR
          (NVL(quotation_rec_.del_terms_location, ' ' )!= NVL(newrec_.del_terms_location, ' ' )) OR
          (NVL(quotation_rec_.forward_agent_id, ' ' )!= NVL(newrec_.forward_agent_id, ' ' )) OR
          (NVL(quotation_rec_.freight_map_id, ' ' )!= NVL(newrec_.freight_map_id, ' ' )) OR
          (NVL(quotation_rec_.zone_id, ' ' )!= NVL(newrec_.zone_id, ' ' )) OR
          (NVL(quotation_rec_.freight_price_list_no, ' ' )!= NVL(newrec_.freight_price_list_no, ' ' ))) THEN
         newrec_.default_addr_flag := 'N';
      END IF;
      Client_SYS.Set_Item_Value('DELIVERY_TERMS', newrec_.delivery_terms, attr_);
      Client_SYS.Set_Item_Value('DEFAULT_ADDR_FLAG_DB', newrec_.default_addr_flag, attr_);
   END IF;
END Check_Before_Insert___;


-- Check_Before_Update___
--   Perform checks needed before updating a record.
PROCEDURE Check_Before_Update___ (
   attr_             IN OUT VARCHAR2,
   newrec_           IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   oldrec_           IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   header_curr_code_ IN     VARCHAR2,   
   header_rowstate_  IN     VARCHAR2 )
IS
   sales_part_rec_               Sales_Part_API.Public_Rec;
   rental_duration_changed_      BOOLEAN := FALSE;
   price_effectivity_date_       DATE;
   qty_refreshed_                NUMBER;
   price_source_refreshed_       NUMBER;
   server_data_change_           NUMBER;
   discount_freeze_db_           VARCHAR2(5);
   sales_price_type_db_          VARCHAR2(20);
   new_rental_duration_          NUMBER;
   old_rental_duration_          NUMBER;
BEGIN

   qty_refreshed_          := (NVL(Client_SYS.Get_Item_Value('QTY_REFRESHED', attr_), 0));
   price_source_refreshed_ := (NVL(Client_SYS.Get_Item_Value('PRICE_SOURCE_REFRESHED', attr_), 0));
   server_data_change_     := (NVL(Client_SYS.Get_Item_Value('SERVER_DATA_CHANGE', attr_), 0));
   
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         IF Client_Sys.Item_Exist('PLANNED_RENTAL_DURATION', attr_) THEN
            new_rental_duration_  := Client_SYS.Get_Item_Value('PLANNED_RENTAL_DURATION', attr_);
         END IF;
         old_rental_duration_     := Rental_Object_API.Get_Planned_Rental_Duration(Rental_Object_API.Get_Rental_No(newrec_.quotation_no, 
                                                                                                                   newrec_.line_no, 
                                                                                                                   newrec_.rel_no, 
                                                                                                                   newrec_.line_item_no, 
                                                                                                                   Rental_Type_API.DB_ORDER_QUOTATION));
         new_rental_duration_     := NVL(new_rental_duration_, old_rental_duration_);
         rental_duration_changed_ := Validate_SYS.Is_Changed(old_rental_duration_, new_rental_duration_);
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END
   END IF;

   IF (newrec_.condition_code IS NOT NULL) THEN
      IF (newrec_.catalog_type = 'PKG') THEN
         Error_SYS.Record_General(lu_name_,'NO_COND_ON_PKG: Condition codes are not allowed for Package Parts.');
      END IF;
      IF (newrec_.catalog_type = 'NON') THEN
         Error_SYS.Record_General(lu_name_,'NO_COND_ON_NON: Condition codes are not allowed for Non Inventory Sales Parts.');
      END IF;
   END IF;

   -- Supply code may not be changed when in status closed.
   IF Validate_SYS.Is_Changed(oldrec_.order_supply_type, newrec_.order_supply_type) THEN
      IF (header_rowstate_ = 'Closed') THEN
         Error_SYS.Record_General(lu_name_, 'NOSUPPCODEUPD: Supply code may not be updated when the quotation is in status Closed.');
      END IF;
      Check_Supply_Code___(newrec_);
   END IF;
   
   IF ((Validate_SYS.Is_Changed(oldrec_.buy_qty_due, newrec_.buy_qty_due)) OR (rental_duration_changed_)) AND (newrec_.buy_qty_due > 0) THEN
      -- If price breaks are defined, check if qty is within price breaks limits.
      -- For rental lines, check if qty and duration both are within price breaks limits.
      IF (Order_Quotation_Grad_Price_API.Grad_Price_Exist(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) = Fnd_Boolean_API.DB_TRUE) THEN
         IF (Order_Quotation_Grad_Price_API.Price_Qty_Exist(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, newrec_.buy_qty_due) = Fnd_Boolean_API.DB_FALSE) THEN
            Raise_Price_Break_Error___;
         END IF;
         IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
            IF (Order_Quotation_Grad_Price_API.Price_Qty_Duration_Exist(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, newrec_.buy_qty_due, new_rental_duration_) = Fnd_Boolean_API.DB_FALSE) THEN
               Error_SYS.Record_General(lu_name_, 'PRICEBREAKSDUR: The entered duration must be within the limits of the price breaks.');
            END IF;
         END IF;
      END IF;
   END IF;

   -- Check that percentage quotation_probability is between 0 % and 100 %.
   IF (newrec_.probability_to_win < 0) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_PROBABILITY1: The quotation probability cannot be less than 0 %.');
   ELSIF NOT (newrec_.probability_to_win <= 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_PROBABILITY2: The quotation probability cannot be more than 100 %.');
   END IF;

   IF (newrec_.promised_delivery_date != oldrec_.promised_delivery_date) AND (newrec_.planned_due_date IS NOT NULL) THEN
      Client_SYS.Add_Info(lu_name_, 'QPROMISEDCHANGE: The promised delivery date has changed. Check planned due date.');
   END IF;

   IF ((newrec_.buy_qty_due < 0) AND (newrec_.order_supply_type != 'SEO')) THEN
      Error_SYS.Record_General(lu_name_, 'QQTY_LESS_THAN_ZERO: Quantity must be greater or equal to zero!');
   END IF;

   IF (newrec_.order_supply_type = 'PKG') AND (newrec_.buy_qty_due = 0) THEN
      Error_SYS.Record_General(lu_name_, 'QQTYPKGZERO: Package quantity may not be zero!');
   END IF;

   IF (newrec_.buy_qty_due = 0) AND (server_data_change_ = 0) AND (Order_Quotation_Grad_price_API.Grad_Price_Exist(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) = 'FALSE') THEN
       Client_SYS.Add_Info(lu_name_, 'QUNOQTY: No quantity on line. Check quantity or enter price breaks');
   END IF;

   IF (newrec_.base_sale_unit_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'PRICE_LESS_THAN_ZERO: Price must be greater than zero!');
   END IF;

   IF (newrec_.sale_unit_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'PRICE_LESS_THAN_ZERO: Price must be greater than zero!');
   END IF;

   -- Order discount may not be >= 100%
   IF (newrec_.quotation_discount >= 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGDISC: Quotation discount must be lower than 100%.');
   END IF;

   IF (newrec_.discount > 100) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISC: The total discount given cannot exceed the quotation line price.');
   END IF;

   sales_part_rec_ := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);
   
   IF (newrec_.rental = Fnd_Boolean_API.DB_FALSE) THEN
      sales_price_type_db_  := Sales_Price_Type_API.DB_SALES_PRICES;
   ELSE
      sales_price_type_db_  := Sales_Price_Type_API.DB_RENTAL_PRICES;
   END IF;
   
   -- Check if right SUPPLY_CODE
   IF ((newrec_.price_list_no IS NOT NULL) AND ((newrec_.cancel_reason IS NULL) AND (newrec_.lost_to IS NULL)))THEN

      price_effectivity_date_ := ORDER_QUOTATION_API.Get_Price_Effectivity_Date(newrec_.quotation_no);

      -- Check if valid
      IF ((Sales_Price_List_API.Is_Valid(newrec_.price_list_no, newrec_.contract, newrec_.catalog_no, price_effectivity_date_, sales_price_type_db_) = FALSE) AND
         (Sales_Price_List_API.Is_Valid_Assort(newrec_.price_list_no, newrec_.contract, newrec_.catalog_no, price_effectivity_date_) = FALSE)) OR
         (Sales_Price_List_API.Get_Sales_Price_Group_Id(newrec_.price_list_no) != sales_part_rec_.sales_price_group_id) THEN
         Error_Sys.Record_General(lu_name_, 'INVALID_PRICELIST: The selected sales price list has no valid part-based line or a valid assortment-node-based line for the sales part.'); 
      END IF;
   END IF;
   -- Make sure the specified address for the order line is valid.
   IF (newrec_.ship_addr_no IS NOT NULL) THEN
      IF (NVL(newrec_.ship_addr_no, ' ') != NVL(oldrec_.ship_addr_no, ' ')) THEN
         IF (Cust_Ord_Customer_Address_API.Is_Ship_Location(newrec_.customer_no, newrec_.ship_addr_no) = 0) THEN
            Error_SYS.Record_General(lu_name_, 'NOTDELADDR: Invalid delivery address specified.');
         END IF;

         IF (Cust_Ord_Customer_Address_API.Is_Valid(newrec_.customer_no, newrec_.ship_addr_no) = 0) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDDELADDR: Delivery address :P1 is invalid. Check the validity period.', newrec_.ship_addr_no);
         END IF;
      END IF;
   END IF;

   --Discount ?
   -- Start. Added check on qty_refreshed_ and price_source_refreshed_.
   discount_freeze_db_ := Site_Discom_Info_API.Get_Discount_Freeze_Db(newrec_.contract);
   IF (newrec_.buy_qty_due != oldrec_.buy_qty_due) OR
      (NVL(newrec_.price_list_no, ' ') != NVL(oldrec_.price_list_no, ' ')
       OR (qty_refreshed_ = 1) OR (price_source_refreshed_ = 1)) THEN
      IF Order_Quote_Line_Discount_API.Check_Manual_Rows(newrec_.quotation_no, newrec_.line_no,
                                                         newrec_.rel_no, newrec_.line_item_no) THEN
         IF NOT(newrec_.price_freeze = 'FROZEN' AND discount_freeze_db_ = 'TRUE') THEN                                                
            Client_SYS.Add_Info(lu_name_, 'MANUAL: Manually entered discount exist. You may want to check the discount calculation.');
         END IF;
      END IF;
   END IF;

   -- Checks for inclusion in the planning
   IF (newrec_.release_planning = 'RELEASED') THEN
      IF (newrec_.buy_qty_due = 0) THEN
         Error_SYS.Record_General(lu_name_, 'QNORELEASE_PLAN2: Price breaked line cannot be included in planning.');
      ELSIF ((newrec_.planned_due_date IS NULL) AND (newrec_.rowstate IN ('Released', 'Revised', 'Rejected'))) THEN
         Error_SYS.Record_General(lu_name_, 'QPLANNODATE: Planned Due Date must be set when line is released for planning.');
      END IF;
   END IF;

   IF (newrec_.configuration_id != '*') THEN
       Order_Config_Util_API.Configuration_Exist(nvl(newrec_.part_no, newrec_.catalog_no), newrec_.configuration_id);
   END IF;

   -- check if row is CTP planned/reserved and is using correct supply code
   IF (newrec_.ctp_planned = 'Y' AND newrec_.order_supply_type NOT IN ('SO','DOP','IPT','IPD')) THEN
      Error_SYS.Record_General(lu_name_, 'QLCTPWRONGACQTYPE: Supply code :P1 is not valid when the quotation line is Capability Checked.',
                               Order_Supply_Type_API.Decode(newrec_.order_supply_type));
   END IF;

   -- send delivery info back to client if default_addr_flag has changed
   IF (newrec_.default_addr_flag != oldrec_.default_addr_flag) THEN
      Client_SYS.Set_Item_Value('DEFAULT_ADDR_FLAG_DB', newrec_.default_addr_flag, attr_);
      Client_SYS.Set_Item_Value('SHIP_ADDR_NO', newrec_.ship_addr_no, attr_);
      Client_SYS.Set_Item_Value('SHIP_VIA_CODE', newrec_.ship_via_code, attr_);
      Client_SYS.Set_Item_Value('EXT_TRANSPORT_CALENDAR_ID', newrec_.ext_transport_calendar_id, attr_);
      Client_SYS.Set_Item_Value('DELIVERY_TERMS', newrec_.delivery_terms, attr_);
      Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', newrec_.del_terms_location, attr_);
      Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', newrec_.delivery_leadtime, attr_);
      Client_SYS.Set_Item_Value('PICKING_LEADTIME', newrec_.picking_leadtime, attr_);
      Client_SYS.Set_Item_Value('TAX_LIABILITY', newrec_.tax_liability, attr_);
      Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', newrec_.forward_agent_id, attr_);
      Client_SYS.Set_Item_Value('FREIGHT_MAP_ID', newrec_.freight_map_id, attr_);
      Client_SYS.Set_Item_Value('ZONE_ID', newrec_.zone_id, attr_);
      Client_SYS.Set_Item_Value('FREIGHT_PRICE_LIST_NO', newrec_.freight_price_list_no, attr_);
      Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', newrec_.tax_liability_type, attr_);
   END IF;

   IF ((newrec_.customer_part_no IS NOT NULL) AND (NVL(server_data_change_,'0') = '1')) THEN
      -- if user has changed the buy_qty_due, the customer_part_buy_qty is emptied (in the client).
      -- Added newrec_.cust_part_invert_conv_fact to calculate the newrec_.customer_part_buy_qty
      IF (newrec_.customer_part_buy_qty IS NULL) THEN
         newrec_.customer_part_buy_qty := newrec_.buy_qty_due / NVL(newrec_.customer_part_conv_factor, 1) * NVL(newrec_.cust_part_invert_conv_fact, 1);
         Client_SYS.Set_Item_Value('CUSTOMER_PART_BUY_QTY', newrec_.customer_part_buy_qty, attr_);
      END IF;
   END IF;
   IF (NVL(oldrec_.condition_code, '*') != NVL(newrec_.condition_code, '*')) THEN
      IF (newrec_.part_no IS NOT NULL) THEN
         IF (newrec_.condition_code IS NOT NULL) THEN
            IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(newrec_.part_no) = 'NOT_ALLOW_COND_CODE') THEN
               Error_SYS.Record_General(lu_name_, 'COND_NOT_ALLOW: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
            ELSE
               Condition_Code_API.Exist(newrec_.condition_code);
            END IF;
         ELSE
            IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(newrec_.part_no) = 'ALLOW_COND_CODE') THEN
               Error_SYS.Record_General(lu_name_, 'COND_NOT_ALLOW0: Condition code functionality is enabled in the part catalog record for this part. You must enter a condition code.');
            END IF;
         END IF;
      END IF;
   END IF;
END Check_Before_Update___;


-- Post_Insert_Actions___
--   Perform checks and actions needed after inserting a new record.
PROCEDURE Post_Insert_Actions___ (
   attr_   IN OUT VARCHAR2,
   newrec_ IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE )
IS
   rowid_                    VARCHAR2(2000);
   rowversion_               VARCHAR2(2000);
   quote_rec_                ORDER_QUOTATION_API.Public_Rec;
   linerec_                  ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   pack_rec_                 ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   pack_attr_                VARCHAR2(32000);
   oldrec_                   ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   min_qty_                  NUMBER;
   insert_package_mode_      BOOLEAN := FALSE;
   block_component_info_     BOOLEAN; 
   copy_status_              VARCHAR2(5);
   rental_chargeable_days_   NUMBER;
   tax_from_defaults_        BOOLEAN;
   
   CURSOR get_head_competitor( quotation_no_ IN VARCHAR2 ) IS
      SELECT competitor_id, compete_id, note, main_competitor
      FROM ORDER_QUOTATION_COMPETITOR_TAB
      WHERE quotation_no = quotation_no_;

   info_                     VARCHAR2(2000);
   deal_description_         VARCHAR2(200);
   customer_category_        CUSTOMER_INFO_TAB.customer_category%TYPE;
   original_quote_no_        VARCHAR2(12);
   original_line_no_         VARCHAR2(4);
   original_rel_no_          VARCHAR2(4);
   original_line_item_no_    VARCHAR2(50);
   tax_class_id_             VARCHAR2(20); 
   tax_from_external_system_ BOOLEAN := FALSE;
   copy_quotation_           VARCHAR2(5);
   copy_price_               VARCHAR2(5);
   temp_sale_unit_price_          NUMBER; 
   temp_unit_price_incl_tax_      NUMBER;     
   temp_base_sale_unit_price_     NUMBER;
   temp_base_unit_price_incl_tax_ NUMBER;
   temp_currency_rate_            NUMBER;        
   discount_                      NUMBER;              
   temp_price_source_             VARCHAR2(200);
   temp_price_source_id_          VARCHAR2(25);
   temp_net_price_fetched_        VARCHAR2(20);
   temp_part_level_db_            VARCHAR2(30);
   temp_part_level_id_            VARCHAR2(200);
   temp_customer_level_db_        VARCHAR2(30);
   temp_customer_level_id_        VARCHAR2(200);
   fetch_external_tax_            VARCHAR2(5) := 'TRUE';
   company_tax_ctrl_rec_          Company_Tax_Control_API.Public_Rec;
   discount_type_                 CUST_ORD_CUSTOMER_TAB.discount_type%TYPE;
BEGIN

   SELECT rowid
   INTO  rowid_
   FROM  ORDER_QUOTATION_LINE_TAB
   WHERE line_item_no = newrec_.line_item_no
   AND   rel_no = newrec_.rel_no
   AND   line_no = newrec_.line_no
   AND   quotation_no = newrec_.quotation_no;

   quote_rec_ := ORDER_QUOTATION_API.Get(newrec_.quotation_no);
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);  
   -- Note: Set the block component info flag so we stop the component info messages generated from Change_Package_Structure___ later on
   IF (newrec_.order_supply_type = 'PKG') THEN
      block_component_info_ := TRUE;
   END IF;
   
   IF (newrec_.line_item_no <= 0) THEN
      ORDER_QUOTATION_API.Modify_Calc_Disc_Flag(newrec_.quotation_no, 'TRUE');
      Client_SYS.Set_Item_Value('DEFAULT_ADDR_FLAG_DB', newrec_.default_addr_flag, attr_);
      Client_SYS.Set_Item_Value('SHIP_ADDR_NO', newrec_.ship_addr_no, attr_);
      Client_SYS.Set_Item_Value('SHIP_VIA_CODE', newrec_.ship_via_code, attr_);
      Client_SYS.Set_Item_Value('EXT_TRANSPORT_CALENDAR_ID', newrec_.ext_transport_calendar_id, attr_);
      Client_SYS.Set_Item_Value('DELIVERY_TERMS', newrec_.delivery_terms, attr_);
      Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', newrec_.del_terms_location, attr_);
      Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', newrec_.delivery_leadtime, attr_);
      Client_SYS.Set_Item_Value('PICKING_LEADTIME', newrec_.picking_leadtime, attr_);
      Client_SYS.Set_Item_Value('TAX_LIABILITY', newrec_.tax_liability, attr_);
      Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', newrec_.tax_liability_type, attr_);
      
      company_tax_ctrl_rec_ := Company_Tax_Control_API.Get(newrec_.company);
      -- gelr:br_external_tax_integration, begin
      IF (company_tax_ctrl_rec_.external_tax_cal_method = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN
         -- Avalara Brazil only supports Customer Order lines and Invoice lines in initial release
         company_tax_ctrl_rec_.external_tax_cal_method := External_Tax_Calc_Method_API.DB_NOT_USED;
      END IF;
      -- gelr:br_external_tax_integration, end
      IF (company_tax_ctrl_rec_.external_tax_cal_method != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
         tax_from_defaults_ := TRUE;
         tax_from_external_system_ := TRUE;
      ELSE         
         IF (NVL(Client_SYS.Get_Item_Value('COPY_QUOTATION_LINE', attr_), 'FALSE') = 'TRUE') THEN      
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
      
      IF company_tax_ctrl_rec_.external_tax_cal_method = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX 
         AND company_tax_ctrl_rec_.fetch_tax_on_line_entry = Fnd_Boolean_API.DB_FALSE THEN  
         fetch_external_tax_ := 'FALSE';
      END IF;
      
      -- If the line is copied or duplicated, taxes should be copied from the original line.
      original_quote_no_     := Client_SYS.Get_Item_Value('ORIGINAL_QUOTE_NO', attr_);
      original_line_no_      := Client_SYS.Get_Item_Value('ORIGINAL_LINE_NO', attr_);
      original_rel_no_       := Client_SYS.Get_Item_Value('ORIGINAL_REL_NO', attr_);
      original_line_item_no_ := Client_SYS.Get_Item_Value('ORIGINAL_ITEM_NO', attr_);
                  
      IF (((Client_SYS.Get_Item_Value('SET_TAX_FROM_ORIGINAL', attr_) = 'TRUE') AND 
           (Order_Quotation_API.Get_Customer_No(original_quote_no_) = quote_rec_.customer_no)) 
          OR 
            -- in case we have multiple tax (neither tax code nor tax calculation structure on the line) 
            -- then when using RMB Copy Quotation... we should copy tax lines from the original quotation line          
          ((NVL(Client_SYS.Get_Item_Value('COPY_QUOTATION_LINE', attr_), 'FALSE') = 'TRUE') AND
           newrec_.tax_calc_structure_id IS NULL AND
           newrec_.tax_code IS NULL)) AND (NOT tax_from_external_system_) THEN
           
         tax_class_id_ := Get_Tax_Class_Id(original_quote_no_,
                                           original_line_no_,
                                           original_rel_no_,
                                           original_line_item_no_);  
         Tax_Handling_Order_Util_API.Transfer_Tax_lines(quote_rec_.company, 
                                                        Tax_Source_API.DB_ORDER_QUOTATION_LINE, 
                                                        original_quote_no_, 
                                                        original_line_no_, 
                                                        original_rel_no_, 
                                                        original_line_item_no_, 
                                                        '*',
                                                        Tax_Source_API.DB_ORDER_QUOTATION_LINE, 
                                                        newrec_.quotation_no, 
                                                        newrec_.line_no, 
                                                        newrec_.rel_no, 
                                                        newrec_.line_item_no, 
                                                        '*',
                                                        'TRUE',
                                                        'FALSE');
      ELSE
         discount_type_ := Cust_Ord_Customer_API.Get_Discount_Type(quote_rec_.customer_no);
         IF (tax_from_external_system_ AND newrec_.discount = 0 AND discount_type_ IS NULL) THEN
            -- Execute the price logic and get the discount value, in order to know any discount involved for the line.
            Customer_Order_Pricing_API.Get_Quote_Line_Price_Info(temp_sale_unit_price_,
                                                                 temp_unit_price_incl_tax_,
                                                                 temp_base_sale_unit_price_,
                                                                 temp_base_unit_price_incl_tax_,
                                                                 temp_currency_rate_,
                                                                 discount_,
                                                                 temp_price_source_,
                                                                 temp_price_source_id_,
                                                                 temp_net_price_fetched_,
                                                                 temp_part_level_db_,
                                                                 temp_part_level_id_,
                                                                 temp_customer_level_db_,
                                                                 temp_customer_level_id_,
                                                                 newrec_.quotation_no,
                                                                 newrec_.catalog_no,
                                                                 newrec_.buy_qty_due,
                                                                 newrec_.price_list_no,
                                                                 quote_rec_.price_effectivity_date,
                                                                 newrec_.condition_code,
                                                                 quote_rec_.use_price_incl_tax);
         END IF;
         -- When the tax is calculated from a external tax system and when there is a discount specified or applicable for the line, or in the customer  
         -- call to Add_Transaction_Tax_Info___ at this point will cause a unnecessary call to the external tax system where the tax is calculated for the un-discounted value.
         -- But this call is needed when there is no discount specified in the line or customer level.
         IF (NOT tax_from_external_system_ OR (discount_ = 0 AND newrec_.discount = 0 AND discount_type_ IS NULL AND fetch_external_tax_ = 'TRUE')) THEN
            Add_Transaction_Tax_Info___(newrec_, 
                                        quote_rec_.company,
                                        quote_rec_.supply_country,
                                        quote_rec_.use_price_incl_tax,
                                        quote_rec_.currency_code,
                                        tax_from_defaults_,                                  
                                        attr_   => NULL);
         END IF;
      END IF;      
      oldrec_ := newrec_;      
      newrec_ := Get_Object_By_Keys___(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      IF (tax_class_id_ IS NOT NULL) THEN
         newrec_.tax_class_id := tax_class_id_;
      END IF;
      Calculate_Prices___(newrec_);      
      
      Update_Line___(rowid_, oldrec_, newrec_, TRUE, FALSE);   
      
      Order_Quotation_Charge_API.Recalc_Percentage_Charge_Taxes(newrec_.quotation_no, newrec_.line_no, tax_from_external_system_);
   END IF;
   
   IF (NVL(Client_SYS.Get_Item_Value('COPY_QUOTATION_LINE', attr_), 'FALSE') = 'FALSE') THEN   
      IF (newrec_.order_supply_type = 'PKG') THEN
         IF NOT insert_package_mode_ THEN
            info_ := Client_SYS.Get_All_Info;
         END IF;
         Add_Info___(info_, insert_package_mode_);
         insert_package_mode_ := TRUE;
         Insert_Package___(newrec_.planned_delivery_date, newrec_.contract,
                           newrec_.catalog_no, newrec_.quotation_no, newrec_.line_no, newrec_.rel_no,
                           newrec_.tax_code, newrec_.tax_class_id, newrec_.currency_rate,
                           newrec_.revised_qty_due, newrec_.buy_qty_due, newrec_.sale_unit_price,
                           newrec_.unit_price_incl_tax, newrec_.base_sale_unit_price, newrec_.base_unit_price_incl_tax,
                           newrec_.wanted_delivery_date);
         insert_package_mode_ := FALSE;
         oldrec_ := newrec_;
         Update_Line___(rowid_, oldrec_, newrec_, TRUE, FALSE);
      END IF;
   END IF;

   IF (NOT insert_package_mode_) THEN
      IF (Check_Exist___(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, -1)) THEN
         IF ((newrec_.line_item_no > 0) OR (newrec_.order_supply_type = 'PKG')) THEN
            -- Modify cost for the order line
            IF (newrec_.line_item_no = -1) THEN
               linerec_ := newrec_;
            ELSE
               linerec_ := Get_Object_By_Keys___(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, -1);
            END IF;
            oldrec_ := linerec_;

            Update_Package_Cost___(linerec_.cost, linerec_.quotation_no, linerec_.line_no, linerec_.rel_no);
            Change_Package_Structure___(linerec_.promised_delivery_date, linerec_.planned_delivery_date,
                                        linerec_.planned_due_date, linerec_, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, block_component_info_);

            Get_Id_Version_By_Keys___(rowid_, rowversion_, newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, -1);
            linerec_.rowversion := sysdate;
            Update_Line___(rowid_, oldrec_, linerec_, TRUE, FALSE);

            -- Add the new cost value to the attribute string and fetch new objversion
            -- if insert of package order line just has been made
            IF (newrec_.order_supply_type = 'PKG') THEN
               Client_SYS.Set_Item_Value('COST', linerec_.cost, attr_);
               -- This is to correctly update cost of business opportunity at Insert_Business_Opp_Line___ and the package line
               newrec_.cost := linerec_.cost;
            END IF;
         END IF;
      END IF;
   END IF;

   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      rental_chargeable_days_ := Get_Latest_Rent_Charge_Days___(attr_, newrec_);
   END IF;
   copy_status_  := Client_SYS.Get_Item_Value('COPY_STATUS', attr_);   
   copy_quotation_ := NVL(Client_SYS.Get_Item_Value('COPY_QUOTATION_LINE', attr_), Fnd_Boolean_API.DB_FALSE) ;
   IF ( copy_quotation_ = Fnd_Boolean_API.DB_TRUE ) THEN
      original_quote_no_ := Client_SYS.Get_Item_Value('ORIGINAL_QUOTE_NO', attr_);
      copy_price_        := Client_SYS.Get_Item_Value('COPY_PRICING', attr_);
   END IF;
   
   IF ( copy_quotation_ = Fnd_Boolean_API.DB_TRUE AND original_quote_no_ IS NOT NULL AND copy_price_ = Fnd_Boolean_API.DB_TRUE ) THEN
      Order_Quote_Line_Discount_API.Copy_Quotation_Line_Discount(original_quote_no_, newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   ELSE
      IF ((newrec_.discount > 0) AND (NVL(copy_status_, 'TRUE') != 'FALSE')) THEN
         discount_type_ := Site_Discom_Info_API.Get_Discount_Type(newrec_.contract);
         Order_Quote_Line_Discount_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, discount_type_, newrec_.discount, Discount_Source_API.DB_MANUAL, Create_Partial_Sum_API.DB_NOT_PARTIAL_SUM, 1, NULL, NULL,  NULL, NULL, NULL, NULL, FALSE);    
         -- At this point a call to Add_Transaction_Tax_Info___ is needed since we avoided calculating tax when there is a discount specified in the line.
         -- This will calculate the tax for discounted amounts.
         IF (tax_from_external_system_ AND fetch_external_tax_ = 'TRUE') THEN
            Add_Transaction_Tax_Info___(newrec_, 
                                           quote_rec_.company,
                                           quote_rec_.supply_country,
                                           quote_rec_.use_price_incl_tax,
                                           quote_rec_.currency_code,
                                           tax_from_defaults_,                                  
                                           attr_   => NULL);
         END IF;
      ELSE   
         -- Default Discount
         -- Do not create any discount lines for component part quotation lines.
         -- Modified the condition to enable discount calculation for the prospect customers as well.      
         IF ((newrec_.buy_qty_due != 0) AND (newrec_.line_item_no <= 0)) THEN
            Customer_Order_Pricing_API.New_Default_Qdiscount_Rec(newrec_.quotation_no,
                                                                    newrec_.line_no,
                                                                    newrec_.rel_no,
                                                                    newrec_.line_item_no,
                                                                    newrec_.contract,
                                                                    newrec_.customer_no,
                                                                    quote_rec_.currency_code,
                                                                    quote_rec_.agreement_id,
                                                                    newrec_.catalog_no,
                                                                    newrec_.buy_qty_due,
                                                                    newrec_.price_list_no,
                                                                    quote_rec_.price_effectivity_date,
                                                                    newrec_.customer_level,
                                                                    newrec_.customer_level_id,
                                                                    rental_chargeable_days_, 
                                                                    update_tax_ => fetch_external_tax_);
         END IF;
      END IF;
   END IF;
   
   Recalculate_Tax_Lines___(newrec_,                                  
                           quote_rec_.company,                                  
                           quote_rec_.customer_no,
                           quote_rec_.ship_addr_no,
                           quote_rec_.supply_country,
                           quote_rec_.use_price_incl_tax,
                           quote_rec_.currency_code,
                           FALSE,
                           NULL);

   newrec_.discount := Get_Discount(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   Client_SYS.Add_To_Attr('DISCOUNT', newrec_.discount, attr_);
   -- gelr:disc_price_rounded, begin
   IF (Order_Quotation_API.Get_Discounted_Price_Rounded(newrec_.quotation_no)) THEN
      newrec_.original_discount := Get_Original_Discount(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   ELSE
      newrec_.original_discount := 0;
   END IF;
   -- gelr:disc_price_rounded, end

   -- Create competitor for line if defined in header only if it is a not a package component line
   IF (newrec_.line_item_no <= 0) THEN
      FOR comp_rec_ IN get_head_competitor(newrec_.quotation_no) LOOP
         Order_Quote_Line_Comptr_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                         comp_rec_.competitor_id, comp_rec_.compete_id, comp_rec_.note, comp_rec_.main_competitor);
      END LOOP;
   END IF;

   -- In case of package component, update package header if state is different of planned
   IF (newrec_.line_item_no > 0) THEN
      IF (Get_Objstate( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, -1 ) IN ('Released' , 'Rejected')) THEN
         -- Send LineChanged
         pack_rec_ := Lock_By_Keys___( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, -1 );
         Finite_State_Machine___( pack_rec_, 'PackageLineChanged', pack_attr_ );
      END IF;
   END IF;

   IF (newrec_.order_supply_type = 'PKG') THEN
      block_component_info_ := FALSE;
   END IF;

   min_qty_ := Sales_Part_API.Get_Minimum_Qty(newrec_.contract, newrec_.catalog_no);
   IF min_qty_ IS NOT NULL THEN
      IF min_qty_ > newrec_.buy_qty_due THEN
         Client_SYS.Add_Info(lu_name_, 'LTMINIMUMQTY: The minimum quantity when ordering Sales Part No :P1 is :P2 :P3.', newrec_.catalog_no, min_qty_, newrec_.sales_unit_measure);
      END IF;
   END IF;

   IF newrec_.line_item_no IN (-1,0) THEN
      IF (NVL(Client_SYS.Get_Item_Value('DEFAULT_CHARGES', attr_),'TRUE') = 'TRUE' ) THEN
         Order_Quotation_Charge_API.Copy_From_Sales_Part_Charge(newrec_.quotation_no,
                                                             newrec_.line_no,
                                                             newrec_.rel_no,
                                                             newrec_.line_item_no);
      END IF;   
   END IF;

   IF (newrec_.line_item_no <= 0) THEN
      Customer_Order_Charge_Util_API.New_Quotation_Charge_Line(newrec_);
   END IF;

   Update_Freight_Free(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);

   -- sales promotion check, if value on deal_description_ this quotation line have atleast one possible sales promotion deal
   IF (newrec_.free_of_charge = Fnd_Boolean_API.DB_FALSE) THEN
      deal_description_ := Get_Possible_Sales_Promo_Deal(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, newrec_.rowstate, newrec_.price_source_net_price, newrec_.charged_item, newrec_.self_billing, newrec_.rental);
   END IF;
   IF (deal_description_ = 'MULTIPLE_DEALS') THEN
      Client_SYS.Add_Info(lu_name_, 'MULTIPLESALESPROMOEXIST: The sales part is connected to multiple sales promotion deal, can be analyzed via operations menu Calculate and View Sales Promotions.');
   ELSIF (deal_description_ IS NOT NULL) THEN
      Client_SYS.Add_Info(lu_name_, 'POSSIBLESALESPROMOEXIST: The sales part is connected to a sales promotion deal :P1.', deal_description_);
   END IF;
   
   -- Insert BO line if CRM is installed.
   Insert_Business_Opp_Line___(newrec_, quote_rec_.business_opportunity_no, rowid_);            
END Post_Insert_Actions___;


-- Calculate_Quote_Line_Dates___
--   Calculate the planned delivery date and
--   planned due date to be set for a quotation line.
PROCEDURE Calculate_Quote_Line_Dates___ (
   newrec_ IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE )
IS
   supplier_part_no_  VARCHAR2(25);
   supply_site_due_date_ DATE;
BEGIN

   -- if inventory part on "our" site, use part_no, otherwise use purchase part no.
   IF (newrec_.part_no IS NOT NULL) THEN
      supplier_part_no_ := newrec_.part_no;
   ELSE
      supplier_part_no_ := Sales_Part_API.Get_Purchase_Part_No(newrec_.contract, newrec_.catalog_no);
   END IF;

   -- calculate ship date and due date backwards from delivery date.
   Cust_Ord_Date_Calculation_API.Calc_Quotation_Dates(newrec_.planned_delivery_date,
      newrec_.planned_due_date, supply_site_due_date_, newrec_.wanted_delivery_date, newrec_.date_entered,
      newrec_.customer_no, newrec_.ship_addr_no, newrec_.vendor_no, newrec_.ship_via_code,
      newrec_.delivery_leadtime, newrec_.picking_leadtime, newrec_.ext_transport_calendar_id, newrec_.order_supply_type, newrec_.contract, newrec_.part_no, supplier_part_no_);

   IF (ORDER_QUOTATION_API.Get_Objstate(newrec_.quotation_no) = 'Planned') THEN
      newrec_.promised_delivery_date := newrec_.planned_delivery_date;
   END IF;
END Calculate_Quote_Line_Dates___;


-- Get_Changed_State___
--   Two purposes:
--   if get_flag_ is true - check if we need to send event LineChanged
--   false - manage line history
PROCEDURE Get_Changed_State___ (
   oldrec_                       IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   newrec_                       IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   get_flag_                     IN     BOOLEAN,
   send_event_                   OUT    BOOLEAN,
   updated_from_wizard_          IN     BOOLEAN,
   updated_from_create_order_    IN     BOOLEAN )
IS
   id_key_      VARCHAR2(35) := ' ';
   revision_no_ ORDER_QUOTATION_TAB.revision_no%TYPE;
BEGIN
   revision_no_ := ORDER_QUOTATION_API.Get_Revision_No( newrec_.quotation_no );
   send_event_ := FALSE;

   -- do not send the event to the line when updating the lines from the
   -- create customer wizard and creating a customer order
   IF (get_flag_ AND (updated_from_wizard_ OR updated_from_create_order_)) THEN
      RETURN;
   END IF;
   
   -- Single Occurence Flag   
   IF NVL(oldrec_.single_occ_addr_flag, ' ') != NVL(newrec_.single_occ_addr_flag, ' ') THEN 
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'SINGLE_OCC_ADDR_FLAG', oldrec_.single_occ_addr_flag, newrec_.single_occ_addr_flag,'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;
   
   -- Single Occurence Address   
   IF (NVL(oldrec_.ship_addr_name, ' ') != NVL(newrec_.ship_addr_name, ' ') OR
        NVL(oldrec_.ship_address1, ' ') != NVL(newrec_.ship_address1, ' ') OR
        NVL(oldrec_.ship_address2, ' ') != NVL(newrec_.ship_address2, ' ') OR
        NVL(oldrec_.ship_address3, ' ') != NVL(newrec_.ship_address3, ' ') OR
        NVL(oldrec_.ship_address4, ' ') != NVL(newrec_.ship_address4, ' ') OR
        NVL(oldrec_.ship_address5, ' ') != NVL(newrec_.ship_address5, ' ') OR
        NVL(oldrec_.ship_address6, ' ') != NVL(newrec_.ship_address6, ' ') OR
        NVL(oldrec_.ship_addr_city, ' ') != NVL(newrec_.ship_addr_city, ' ') OR
        NVL(oldrec_.ship_addr_zip_code, ' ') != NVL(newrec_.ship_addr_zip_code, ' ') OR
        NVL(oldrec_.ship_addr_country_code, ' ') != NVL(newrec_.ship_addr_country_code, ' ') ) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'SINGLE_OCC_ADDRESS', '', '', 'QUOTATION_LINE', id_key_, revision_no_, 
                                       Language_SYS.Translate_Constant(lu_name_, 'LINE_SO_ADDR_CHANGED: Single Occurence address changed'));
      END IF;
   END IF;
   
   -- Quantity
   IF (NVL(oldrec_.buy_qty_due, 0) != NVL(newrec_.buy_qty_due, 0)) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'BUY_QTY_DUE', oldrec_.buy_qty_due, newrec_.buy_qty_due, 'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;
   IF (NVL(oldrec_.desired_qty, 0) != NVL(newrec_.desired_qty, 0)) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'DESIRED_QTY', oldrec_.desired_qty, newrec_.desired_qty, 'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;
   IF (NVL(oldrec_.customer_part_buy_qty, 0) != NVL(newrec_.customer_part_buy_qty, 0)) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'CUSTOMER_PART_BUY_QTY', oldrec_.customer_part_buy_qty, newrec_.customer_part_buy_qty,
                                       'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;
   
   -- Price
   IF (NVL(oldrec_.base_sale_unit_price, 0) != NVL(newrec_.base_sale_unit_price, 0)) AND (newrec_.line_item_no <= 0) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'BASE_SALE_UNIT_PRICE', oldrec_.base_sale_unit_price, newrec_.base_sale_unit_price,
                                       'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;
   IF (NVL(oldrec_.sale_unit_price, 0) != NVL(newrec_.sale_unit_price, 0)) AND (newrec_.line_item_no <= 0) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'SALE_UNIT_PRICE', oldrec_.sale_unit_price, newrec_.sale_unit_price,
                                       'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;
   
   -- Supply code
   IF (oldrec_.order_supply_type != newrec_.order_supply_type) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'ORDER_SUPPLY_TYPE', oldrec_.order_supply_type, newrec_.order_supply_type,
                                       'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;
   
   -- Wanted delivery date
   IF (NVL(oldrec_.wanted_delivery_date, TO_DATE('01-01-1990','DD-MM-YYYY')) !=
       NVL(newrec_.wanted_delivery_date, TO_DATE('01-01-1990','DD-MM-YYYY'))) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'WANTED_DELIVERY_DATE', oldrec_.wanted_delivery_date, newrec_.wanted_delivery_date,
                                       'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;
   
   -- Promised delivery date
   IF (NVL(oldrec_.promised_delivery_date, TO_DATE('01-01-1990','DD-MM-YYYY')) !=
       NVL(newrec_.promised_delivery_date, TO_DATE('01-01-1990','DD-MM-YYYY'))) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'PROMISED_DELIVERY_DATE', oldrec_.promised_delivery_date, newrec_.promised_delivery_date,
                                       'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;

   -- Planned delivery date
   IF (NVL(oldrec_.planned_delivery_date, TO_DATE('01-01-1990','DD-MM-YYYY')) !=
       NVL(newrec_.planned_delivery_date, TO_DATE('01-01-1990','DD-MM-YYYY'))) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'PLANNED_DELIVERY_DATE', oldrec_.planned_delivery_date, newrec_.planned_delivery_date,
                                       'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;

   -- Ship Via Code
   IF (NVL(oldrec_.ship_via_code, ' ') != NVL(newrec_.ship_via_code, ' ')) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'SHIP_VIA_CODE', oldrec_.ship_via_code, newrec_.ship_via_code,
                                       'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;

   -- Ship Addr No
   IF (NVL(oldrec_.ship_addr_no, ' ') != NVL(newrec_.ship_addr_no, ' ')) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'SHIP_ADDR_NO', oldrec_.ship_addr_no, newrec_.ship_addr_no,
                                       'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;

   -- Delivery term
   IF (NVL(oldrec_.delivery_terms, ' ') != NVL(newrec_.delivery_terms, ' ')) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'DELIVERY_TERMS', oldrec_.delivery_terms, newrec_.delivery_terms,
                                       'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;
   
   -- Delivery type
   IF (NVL(oldrec_.delivery_type, ' ') != NVL(newrec_.delivery_type, ' ')) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'DELIVERY_TYPE', oldrec_.delivery_type, newrec_.delivery_type,
                                       'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;

   IF (NVL(oldrec_.condition_code, ' ') != NVL(newrec_.condition_code, ' ')) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      END IF;
   END IF;

   -- Configuration id
   IF (NVL(oldrec_.configuration_id, ' ') != NVL(newrec_.configuration_id, ' ')) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'CONFIGURATION_ID', oldrec_.configuration_id, newrec_.configuration_id,
                                       'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;
   
   -- tax_calc structure id
   IF (NVL(oldrec_.tax_calc_structure_id, ' ') != NVL(newrec_.tax_calc_structure_id, ' ')) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                       'TAX_CALC_STRUCTURE_ID', oldrec_.tax_calc_structure_id, newrec_.tax_calc_structure_id,
                                       'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;   
   
   -- Discount
   IF (NVL(oldrec_.discount, 0) != NVL(newrec_.discount, 0)) THEN
      IF get_flag_ THEN
         send_event_ := TRUE;
         RETURN;
      ELSE
         Order_Quote_Line_Hist_API.New(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                         'SALE_UNIT_PRICE', oldrec_.discount,newrec_.discount,
                                         'QUOTATION_LINE', id_key_, revision_no_);
      END IF;
   END IF;
   
END Get_Changed_State___;


-- Create_Order_Line___
--   Create a new order line
--   Create a new order line
--   When creating a new quotation line, insert BO line if quotation is created from BO.
--   When updating the quotation line, update the BO line if quotation line is created from BO.
--   When updating the status of quotation line, update the status of BO line if quotation line is created from BO.
PROCEDURE Create_Order_Line___ (
   rec_              IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE,   
   con_order_no_     IN     VARCHAR2,
   con_line_no_      IN OUT VARCHAR2,
   con_rel_no_       IN OUT VARCHAR2,
   con_line_item_no_ IN OUT NUMBER )
IS
   newrec_           ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   optionattr_       VARCHAR2(32000);

   CURSOR GetOrderLineDiscountLine( order_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2,
                                    line_item_no_ IN VARCHAR2 ) IS
      SELECT discount_no
      FROM CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE line_item_no = line_item_no_
        AND rel_no = rel_no_
        AND line_no = line_no_
        AND order_no = order_no_;

   CURSOR GetQuoteLineDiscountLine( quotation_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2,
                                    line_item_no_ IN VARCHAR2 ) IS
      SELECT discount_no
      FROM ORDER_QUOTE_LINE_DISCOUNT_TAB
      WHERE line_item_no = line_item_no_
        AND rel_no = rel_no_
        AND line_no = line_no_
        AND quotation_no = quotation_no_;
BEGIN

   newrec_ := rec_;

   -- Remove discount lines
   FOR loop_rec_ IN GetOrderLineDiscountLine( con_order_no_, con_line_no_, con_rel_no_, con_line_item_no_ ) LOOP
      Cust_Order_Line_Discount_API.Remove_Discount_Row( con_order_no_, con_line_no_, con_rel_no_,
                                                        con_line_item_no_, loop_rec_.discount_no );
   END LOOP;

   -- Create discount lines from quotation
   FOR loop_rec_ IN GetQuoteLineDiscountLine( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no ) LOOP
      Order_Quote_Line_Discount_API.Transfer_To_Order( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no,
                                                       newrec_.line_item_no, loop_rec_.discount_no,
                                                       con_order_no_, con_line_no_, con_rel_no_, con_line_item_no_ );
   END LOOP;

   -- Recalculate discount
   Cust_Order_Line_Discount_API.Calc_Discount_Upd_Co_line__( con_order_no_, con_line_no_, con_rel_no_,
                                                             con_line_item_no_ );

   -- Copy options if available
   Client_SYS.Clear_Attr( optionattr_ );
   Client_SYS.Add_To_Attr( 'ORDER_NO', con_order_no_, optionattr_ );
   Client_SYS.Add_To_Attr( 'LINE_NO', con_line_no_, optionattr_ );
   Client_SYS.Add_To_Attr( 'REL_NO', con_rel_no_, optionattr_ );
   Client_SYS.Add_To_Attr( 'LINE_ITEM_NO', con_line_item_no_, optionattr_ );

   -- informing capability check that this quote line is creating a customer order line
   IF (rec_.ctp_planned = 'Y') THEN
      $IF (Component_Ordstr_SYS.INSTALLED) $THEN
         Interim_Ctp_Manager_API.Ctp_Quote_To_Order('CUSTOMERQUOTE', rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, 
                                                    'CUSTOMERORDER', con_order_no_, con_line_no_, con_rel_no_, con_line_item_no_);
      $ELSE
         NULL;
      $END
   END IF;


   -- Dynamic call for setting order line configuration ( creating a new usage )
   IF (rec_.configuration_id != '*' AND rec_.ctp_planned = 'N') THEN
      $IF (Component_Ordstr_SYS.INSTALLED) $THEN
         Interim_Demand_Head_API.Transfer_Usage('CUSTOMERQUOTE', rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, 
                                                'CUSTOMERORDER', con_order_no_, con_line_no_, con_rel_no_, con_line_item_no_);
      $ELSE
         NULL;
      $END  
   END IF;
END Create_Order_Line___;


-- Create_Order_Line___
--   Create a new order line
--   Create a new order line
--   When creating a new quotation line, insert BO line if quotation is created from BO.
--   When updating the quotation line, update the BO line if quotation line is created from BO.
--   When updating the status of quotation line, update the status of BO line if quotation line is created from BO.
PROCEDURE Create_Order_Line___ (
   rec_  IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   con_order_no_     CUSTOMER_ORDER_LINE_TAB.order_no%TYPE;
   con_line_no_      CUSTOMER_ORDER_LINE_TAB.line_no%TYPE;
   con_rel_no_       CUSTOMER_ORDER_LINE_TAB.rel_no%TYPE;
   con_line_item_no_ CUSTOMER_ORDER_LINE_TAB.line_item_no%TYPE;
   reason_id_        ORDER_QUOTATION_LINE_TAB.reason_id%TYPE;
   won_note_         ORDER_QUOTATION_LINE_TAB.lose_win_note%TYPE;
   attr2_            VARCHAR2(32000);
   newrec_           ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   oldrec_           ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   packhead_         ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   objid_            ORDER_QUOTATION_LINE.objid%TYPE;
   objversion_       ORDER_QUOTATION_LINE.objversion%TYPE;
   change_line_delivery_date_ VARCHAR2(10);
   sales_part_rec_   Sales_Part_API.Public_Rec;
   insert_package_mode_       BOOLEAN := FALSE;
   current_info_              VARCHAR2(32000);
   info_                      VARCHAR2(2000);   
   indrec_            Indicator_Rec;
BEGIN
   -- Set it to nolonger be included in plannnig, force unconsumtion.
   Client_SYS.Clear_Attr( attr2_ );
   Client_SYS.Add_To_Attr( 'RELEASE_PLANNING_DB', 'NOTRELEASED', attr2_ );

   newrec_ := rec_;
   sales_part_rec_ := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);
   IF (sales_part_rec_.replacement_part_no IS NOT NULL) AND (sales_part_rec_.date_of_replacement <= (Site_API.Get_Site_Date(newrec_.contract))) THEN
      Error_SYS.Record_General(lu_name_, 'REPPARTEXIST: Customer Order Cannot be created. The sales part :P1 in the Sales Quotation has been superseded by replacement part :P2.', newrec_.catalog_no, sales_part_rec_.replacement_part_no);
   END IF;   
   oldrec_ := newrec_;
   Unpack___(newrec_, indrec_, attr2_);
   Check_Update___(oldrec_, newrec_, indrec_, attr2_); 
   -- Set to indicate line is updated when creating the order
   Client_SYS.Add_To_Attr( 'UPDATED_FROM_CREATE_ORDER', 'TRUE', attr2_ );
   Update___( objid_, rec_, newrec_, attr2_, objversion_, TRUE );

   oldrec_ := newrec_;
   -- end of unconsumption

   con_order_no_ := Client_SYS.Get_Item_Value('ORDER_NO', attr_ );

   reason_id_ := Client_SYS.Get_Item_Value('REASON_ID', attr_ );
   won_note_ := Client_SYS.Get_Item_Value('LOSE_WIN_NOTE', attr_ );
   change_line_delivery_date_ :=Client_SYS.Get_Item_Value( 'CHANGE_LINE_DELIVERY_DATE', attr_ );
   IF (newrec_.wanted_delivery_date IS NULL) THEN
      newrec_.wanted_delivery_date := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('WANTED_DELIVERY_DATE', attr_ ));
   END IF;

   IF (newrec_.buy_qty_due = 0) THEN
      Error_SYS.Record_General(lu_name_, 'QUONOQTY: Line :P1 Del No :P2 without quantity.' ,rec_.line_no, rec_.rel_no);
   END IF;

   -- Create line
   IF (newrec_.line_item_no <= 0) THEN
      IF (change_line_delivery_date_ = 'YES') THEN
         Create_Line___(newrec_, con_order_no_, con_line_no_, con_rel_no_, con_line_item_no_, Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('WANTED_DELIVERY_DATE', attr_ )));
      ELSE
         Create_Line___(newrec_, con_order_no_, con_line_no_, con_rel_no_, con_line_item_no_);
      END IF;
   ELSE
      -- Package component
      -- Get connected data from package head
      packhead_ := Get_Object_By_Keys___( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, -1 );
      con_order_no_ := packhead_.con_order_no;
      con_line_no_ := packhead_.con_line_no;
      con_rel_no_ := packhead_.con_rel_no;
      con_line_item_no_ := newrec_.line_item_no;
      IF (change_line_delivery_date_ = 'YES') THEN
         Create_Line___(newrec_, con_order_no_, con_line_no_, con_rel_no_, con_line_item_no_, Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('WANTED_DELIVERY_DATE', attr_ )));
      ELSE
         Create_Line___(newrec_, con_order_no_, con_line_no_, con_rel_no_, con_line_item_no_);
      END IF;
   END IF;
   IF NOT insert_package_mode_ THEN
      info_ := Client_SYS.Get_All_Info;
   END IF;
   Add_Info___(info_, insert_package_mode_);
   Create_Order_Line___( rec_, con_order_no_, con_line_no_, con_rel_no_, con_line_item_no_ );

   -- Set it as won
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr( attr2_ );
   Client_SYS.Add_To_Attr( 'REASON_ID', reason_id_, attr2_ );
   Client_SYS.Add_To_Attr( 'LOSE_WIN_NOTE', won_note_, attr2_ );
   Client_SYS.Add_To_Attr( 'CON_ORDER_NO', con_order_no_, attr2_ );
   Client_SYS.Add_To_Attr( 'CON_LINE_NO', con_line_no_, attr2_ );
   Client_SYS.Add_To_Attr( 'CON_REL_NO', con_rel_no_, attr2_ );
   Client_SYS.Add_To_Attr( 'CON_LINE_ITEM_NO', con_line_item_no_, attr2_ );
   
   Unpack___(newrec_, indrec_, attr2_);
   Check_Update___(oldrec_, newrec_, indrec_, attr2_);   
   Update___( objid_, oldrec_, newrec_, attr2_, objversion_, TRUE );
   
   current_info_ :=  App_Context_SYS.Find_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_');
   IF (current_info_ IS NOT NULL) THEN
      IF (SUBSTR(current_info_,1,4) = 'INFO') THEN
         -- Remove INFO and stop at the space. Do not remove any chr from the message.
         current_info_ := LTRIM(current_info_, 'INFO');
      END IF;
      -- Now remove any CHR(31) - spaces at the beginning.
      current_info_ := LTRIM(current_info_, CHR(31));
      -- Add current_info_ to the Client_SYS then no worries when current_info_ gets reset..
      Client_SYS.Add_Info(lu_name_, SUBSTR(current_info_,1,1024));
      App_Context_SYS.Set_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_', current_info_);
   END IF;
END Create_Order_Line___;


-- Create_Line___
--   Create a customer order line from a quotation line.
PROCEDURE Create_Line___ (
   rec_              IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   con_order_no_     IN     VARCHAR2,
   con_line_no_      IN OUT VARCHAR2,
   con_rel_no_       IN OUT VARCHAR2,
   con_line_item_no_ IN OUT NUMBER,
   delivery_date_    IN     DATE DEFAULT NULL )
IS
   attr_          VARCHAR2(32000);
   info_          VARCHAR2(4000);
   new_price_id_  NUMBER;
   header_rec_    ORDER_QUOTATION_API.Public_Rec;
   attr2_         VARCHAR2(2000);
   dummy_info_    VARCHAR2(32000);   
   key_ref_from_          TECHNICAL_OBJECT_REFERENCE.key_ref%TYPE;
   key_ref_to_            TECHNICAL_OBJECT_REFERENCE.key_ref%TYPE;
   technical_spec_no_old_ TECHNICAL_OBJECT_REFERENCE.technical_spec_no%TYPE;
   technical_spec_no_new_ TECHNICAL_OBJECT_REFERENCE.technical_spec_no%TYPE;
   technical_class_       TECHNICAL_OBJECT_REFERENCE.technical_class%TYPE;
BEGIN

   header_rec_ := ORDER_QUOTATION_API.Get(rec_.quotation_no);

   -- Check state
   IF (rec_.rowstate NOT IN ('Released', 'Won')) THEN
      Error_SYS.Record_General(lu_name_, 'CRTORDLINE: Line :P1 of quotation :P2 should be in state released or won for creating an order',
      rec_.line_no, rec_.quotation_no);
   END IF;
   
   IF (rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         IF (Rental_Object_API.Get_Planned_Rental_Start_Date(Rental_Object_API.Get_Rental_No(rec_.quotation_no,
                                                                                             rec_.line_no,
                                                                                             rec_.rel_no,
                                                                                             rec_.line_item_no,
                                                                                             Rental_Type_API.DB_ORDER_QUOTATION)) IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOTPLANENDSTARTENDDATE: All rental lines should have planned rental start and end dates.');   
         END IF;
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END
   END IF;
   
   attr_ := Build_Attr_For_Create_Line___(rec_, header_rec_, con_order_no_, con_line_no_, con_rel_no_, con_line_item_no_, delivery_date_);

   Customer_Order_Line_API.New( info_, attr_);

   IF rec_.configured_line_price_id IS NOT NULL THEN
      new_price_id_ := Client_SYS.Attr_Value_To_Number( Client_SYS.Get_Item_Value('CONFIGURED_LINE_PRICE_ID', attr_));
      Configured_Line_Price_API.Transfer_Pricing__(dummy_info_, rec_.configured_line_price_id, new_price_id_, FALSE);
   END IF;

   -- Retrieve keys from attribute string
   con_line_no_ := NVL(Client_SYS.Get_Item_Value('LINE_NO', attr_), con_line_no_);
   con_rel_no_ := NVL(Client_SYS.Get_Item_Value('REL_NO', attr_), con_rel_no_);
   con_line_item_no_ := NVL(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_), con_line_item_no_);

   -- since promised delivery date always will be changed to the planned due date during the date calculations
   -- on the order line, we update afterwards with the correct promised delivery date from the quotation line
   IF (delivery_date_ IS NULL AND rec_.promised_delivery_date IS NOT NULL AND
       rec_.promised_delivery_date != rec_.planned_delivery_date) THEN
      Client_SYS.Clear_Attr(attr2_);
      Client_SYS.Add_To_Attr('PROMISED_DELIVERY_DATE', rec_.promised_delivery_date, attr2_);
      Customer_Order_Line_API.Modify(attr2_, con_order_no_, con_line_no_, con_rel_no_, con_line_item_no_);
   END IF;
   
   -- Copy the Technical_Object_Reference with attributes
   key_ref_from_ := Client_SYS.Get_Key_Reference(lu_name_, 'QUOTATION_NO',rec_.quotation_no, 'LINE_NO', rec_.line_no, 'REL_NO', rec_.rel_no, 'LINE_ITEM_NO', rec_.line_item_no);
   technical_spec_no_old_ := Technical_Object_Reference_API.Get_Technical_Spec_No(lu_name_, key_ref_from_);
   IF (technical_spec_no_old_ != -1) THEN
      technical_class_ := Technical_Object_Reference_API.Get_Technical_Class_With_Key(lu_name_, key_ref_from_);
      key_ref_to_  := Client_SYS.Get_Key_Reference('CustomerOrderLine', 'ORDER_NO', con_order_no_, 'LINE_NO', con_line_no_, 'REL_NO', con_rel_no_, 'LINE_ITEM_NO', con_line_item_no_);
      Technical_Object_Reference_API.Create_Reference(technical_spec_no_new_, 'CustomerOrderLine', key_ref_to_, technical_class_);
      -- Delete attributes copied from technical class, but removed in quotation line connection.
      Technical_Specification_API.Sync_Values(technical_spec_no_old_, technical_spec_no_new_);
      -- Copy attribute values
      Technical_Object_Reference_API.Copy_Values(key_ref_from_, key_ref_to_, 1, NULL, lu_name_, 'CustomerOrderLine');
   END IF;

   IF (info_ IS NOT NULL) THEN
      -- Remove INFO and stop at the space. Do not remove any chr from the message.
      info_ := LTRIM(info_, 'INFO');
      -- Now remove any CHR(31) - spaces at the beginning.
      info_ := LTRIM(info_, CHR(31));
      info_ := RTRIM(info_, CHR(30));
      Client_SYS.Add_Info(lu_name_, SUBSTR(info_,1,1024));
   END IF;

END Create_Line___;


-- Update_Package_State___
--   Updates the package state according to package header.
PROCEDURE Update_Package_State___ (
   pkg_quote_no_ IN     VARCHAR2,
   pkg_line_no_  IN     VARCHAR2,
   pkg_rel_no_   IN     VARCHAR2,
   pkg_event_    IN     VARCHAR2,
   pkg_attr_     IN OUT VARCHAR2 )
IS
   rec_              ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   update_component_ BOOLEAN;

   CURSOR Get_Package_Comp( quotation_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2 ) IS
      SELECT  rowstate, line_item_no
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE rowstate != 'Cancelled'
        AND line_item_no > 0
        AND rel_no = rel_no_
        AND line_no = line_no_
        AND quotation_no = quotation_no_;
BEGIN

   FOR comp_rec_ IN Get_Package_Comp( pkg_quote_no_, pkg_line_no_, pkg_rel_no_ ) LOOP
      update_component_ := TRUE;

      IF (pkg_event_ = 'PackageLineChanged') AND (comp_rec_.rowstate = 'Planned') THEN
         update_component_ := FALSE;
      END IF;

      IF (pkg_event_ = 'Release') AND (comp_rec_.rowstate = 'Released') THEN
         update_component_ := FALSE;
         -- if we try to release when line is already released
      END IF;

      IF update_component_ THEN
         rec_ := Lock_By_Keys___(pkg_quote_no_, pkg_line_no_, pkg_rel_no_, comp_rec_.line_item_no);
         Finite_State_Machine___(rec_, pkg_event_, pkg_attr_);
      END IF;

   END LOOP;
END Update_Package_State___;


-- Check_Important_Fields___
--   Check important fields for history reason and send LineChanged if necessary
PROCEDURE Check_Important_Fields___ (
   oldrec_                    IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   newrec_                    IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   statemachine_              IN     BOOLEAN DEFAULT TRUE,
   updated_from_wizard_       IN     BOOLEAN,
   updated_from_create_order_ IN     BOOLEAN,
   is_rental_modified_        IN     BOOLEAN DEFAULT FALSE)
IS
   send_event_ BOOLEAN;
   attr_       VARCHAR2(32000);
   packrec_    ORDER_QUOTATION_LINE_TAB%ROWTYPE;
BEGIN

   -- Check if we need to send LineChanged
   Get_Changed_State___( oldrec_, newrec_, TRUE, send_event_, updated_from_wizard_, updated_from_create_order_);
   IF (send_event_ AND statemachine_) OR (is_rental_modified_) THEN
      IF (Get_Objstate( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) IN ('CO Created','Lost')) THEN
         Error_SYS.Record_General(lu_name_, 'CANTMODIFYOQ: CO Created/Lost order quotation line may not be modified');
      END IF;
      IF newrec_.line_item_no <= 0 THEN
         -- Normal part or package head
         Finite_State_Machine___( newrec_, 'LineChanged', attr_ );
      ELSE
         -- Package part line
         -- We send PackageLineChange if the state of the head is released and quotation is printed OR the component line state is Cancelled, Rejected, Lost or CO Created
         IF Order_Quotation_API.Get_Printed_Db( newrec_.quotation_no ) = 'PRINTED' OR
            (Get_Objstate( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) IN ('Cancelled','CO Created','Lost','Rejected')) THEN
            -- Do not resend several times the message to the head !
            IF NOT ( Get_Objstate( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, -1 ) = 'Revised' ) THEN
               packrec_ := Lock_By_Keys___( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, -1);
               Finite_State_Machine___( packrec_, 'PackageLineChanged', attr_ );
            END IF;
         END IF;
      END IF;
   END IF;

   -- This will create history records even when the quotation line is in planned state.
   Get_Changed_State___( oldrec_, newrec_, FALSE, send_event_, FALSE, FALSE );
END Check_Important_Fields___;


-- Check_Supply_Code___
--   Method to check if the entered supply code is allowed - using a
--   variety of combination checks. DOP parts, configured parts and so on.
PROCEDURE Check_Supply_Code___ (
   newrec_       IN ORDER_QUOTATION_LINE_TAB%ROWTYPE )
IS
   sales_part_rec_    Sales_Part_API.Public_Rec;
   supply_code_cl_    VARCHAR2(200) := Order_Supply_Type_API.Decode(newrec_.order_supply_type);
   type_code_         VARCHAR2(20);
   inv_part_planning_rec_   Inventory_Part_Planning_API.Public_Rec;
   prod_structure_exist_  BOOLEAN := FALSE;

BEGIN
   -- Check if right SUPPLY_CODE
   IF (newrec_.order_supply_type NOT IN ('IO', 'SO', 'PT', 'PD', 'NO', 'PKG', 'IPT', 'IPD', 'SEO', 'DOP', 'ND', 'SRC','PS')) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_SUPPLY_CODE: Supply code ":P1" is not allowed for this part.', supply_code_cl_);
   END IF;

   sales_part_rec_ := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);

   -- Automatic sourcing is only allowed if sales part is set up to Use Sourcing Rule.
   IF (newrec_.order_supply_type = 'SRC') AND (sales_part_rec_.sourcing_option != 'USESOURCINGRULE') THEN
      Error_SYS.Record_General(lu_name_, 'AUTOSOURCING: Supply Code ":P1" is only allowed when sales part is set up to Use Sourcing Rule.', supply_code_cl_);
   END IF;

   -- DOP check
   -- IF inventory part is a DOP part, supply code may only be set to DOP or IO
   inv_part_planning_rec_ := Inventory_Part_Planning_API.Get(newrec_.contract, newrec_.part_no);
   IF (nvl(inv_part_planning_rec_.order_requisition, '*') = 'D') THEN
      IF (newrec_.order_supply_type NOT IN ('IO', 'DOP', 'IPT', 'IPD')) THEN
         Error_SYS.Record_General(lu_name_, 'DOPSUPPLY: Supply code ":P1" is not allowed for DOP parts.', supply_code_cl_);
      END IF;
   END IF;
   IF (newrec_.order_supply_type = 'DOP') AND (inv_part_planning_rec_.planning_method = 'N') THEN
      Error_SYS.Record_General(lu_name_, 'MRPCODEPNNOTALLOWED: Associated Inventory Part cannot have MRP order code ":P1" when using supply code ":P2".',
                          inv_part_planning_rec_.planning_method, supply_code_cl_);
   END IF;


   -- Check if right SUPPLY_CODE depending on CATALOG_TYPE
   IF (newrec_.catalog_type = 'INV') THEN
      -- CTO
      IF (Part_Catalog_API.Get_Configurable_Db(newrec_.part_no) = 'CONFIGURED') THEN
         IF (newrec_.order_supply_type NOT IN ('IO', 'SO', 'PT', 'PD', 'IPT', 'IPD', 'SEO', 'DOP', 'ND','SRC')) THEN
            Error_SYS.Record_General(lu_name_, 'CONFIGPART: Supply code ":P1" is not allowed for configured parts.', supply_code_cl_);
         END IF;
      END IF;
      IF (newrec_.order_supply_type IN ('NO', 'PKG')) THEN
         Error_SYS.Record_General(lu_name_, 'INVPART: Supply code ":P1" is not allowed for inventory sales parts.', supply_code_cl_);
      ELSIF (newrec_.order_supply_type = 'SO') THEN
         -- IF Manufactured (1) or Manufactured Recipe (2), Shop Order must be supplied
         type_code_ := Inventory_Part_API.Get_Type_Code_Db(newrec_.contract, newrec_.part_no);
         IF (type_code_ NOT IN ('1', '2')) THEN
            $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
               IF(Prod_Structure_Head_API.Product_Exist(newrec_.contract, newrec_.part_no, 'M') = 1) THEN
                  prod_structure_exist_ := TRUE;
               END IF;
            $END
            IF(prod_structure_exist_ = FALSE)THEN
               Error_SYS.Record_General(lu_name_, 'MANUFPART: Supply code ":P1" is only allowed for manufactured parts.', supply_code_cl_); 
            END IF;
         END IF;        
      END IF;
   ELSIF (newrec_.catalog_type = 'NON') THEN
      -- CTO
      IF (Part_Catalog_API.Get_Configurable_Db(newrec_.catalog_no) = 'CONFIGURED') THEN
         IF (newrec_.order_supply_type NOT IN ('NO', 'SEO', 'PT', 'PD', 'IPT', 'IPD')) THEN
            Error_SYS.Record_General(lu_name_, 'CONFIGPART: Supply code ":P1" is not allowed for configured parts.', supply_code_cl_);
         END IF;
      END IF;
      IF (newrec_.order_supply_type NOT IN ('PT', 'PD', 'NO', 'IPT', 'IPD', 'SEO', 'ND', 'SRC')) THEN
         Error_SYS.Record_General(lu_name_, 'NONINVENT: Supply code ":P1" is not allowed. You may only use purchase order supply or no supply for non-inventory parts.', supply_code_cl_);
      END IF;
   ELSIF (newrec_.catalog_type = 'PKG') THEN
      IF (newrec_.order_supply_type != 'PKG') THEN
         Error_SYS.Record_General(lu_name_, 'PACKAGEPART: Supply code ":P1" is not allowed for package parts.', supply_code_cl_);
      END IF;
   END IF;

   -- Production Schedule Check
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN  
      IF newrec_.order_supply_type = 'PS' THEN
         Production_Line_Part_API.Production_Schedules_Enabled(newrec_.contract, newrec_.part_no);     
      END IF;
   $END
END Check_Supply_Code___;


-- Get_Supply_Chain_Defaults___
--   Retrieve default values for supply chain parameters
PROCEDURE Get_Supply_Chain_Defaults___ (
   newrec_ IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   indrec_ IN     Indicator_Rec)
IS
   ship_via_code_              VARCHAR2(3);
   delivery_leadtime_          NUMBER;
   pkg_rec_                    ORDER_QUOTATION_LINE_API.Public_Rec;
   quote_rec_                  ORDER_QUOTATION_API.Public_Rec;
   distance_                   NUMBER;
   expected_additional_cost_   NUMBER;
   cost_curr_code_             VARCHAR2(3);
   internal_leadtime_          NUMBER;
   agreement_id_               VARCHAR2(10);
   ship_via_transit_           VARCHAR2(3);
   addr_flag_                  VARCHAR2(1) := 'N';
   ext_transport_calendar_id_  ORDER_QUOTATION_LINE_TAB.ext_transport_calendar_id%TYPE;
   customer_category_          CUSTOMER_INFO_TAB.customer_category%TYPE;
   route_id_                  VARCHAR2(12);
   picking_leadtime_           NUMBER;
   dummy_shipment_type_        VARCHAR2(3) := NULL;
   forward_agent_id_           VARCHAR2(20);
   delivery_terms_                  ORDER_QUOTATION_LINE_TAB.delivery_terms%TYPE;
   del_terms_location_              ORDER_QUOTATION_LINE_TAB.del_terms_location%TYPE;
   default_ship_via_code_           VARCHAR2(3);
   default_delivery_terms_          VARCHAR2(5);
   default_del_terms_location_      VARCHAR2(100);
   default_delivery_leadtime_       NUMBER;
   default_ext_transport_cal_id_    ORDER_QUOTATION_LINE_TAB.ext_transport_calendar_id%TYPE;
   default_picking_leadtime_        NUMBER;
   default_forward_agent_id_        ORDER_QUOTATION_LINE_TAB.forward_agent_id%TYPE;
BEGIN
   -- Any values passed in when the line was created should override the default values
   -- This could be the case when the order line is created via the New() method.
   -- Defaults could for example come from a quotation line
   IF (indrec_.ship_via_code ) THEN
      ship_via_code_ := newrec_.ship_via_code ; 
   END IF;
   IF (indrec_.delivery_leadtime ) THEN
      delivery_leadtime_ := newrec_.delivery_leadtime;
   END IF;
   IF (indrec_.ext_transport_calendar_id ) THEN
      ext_transport_calendar_id_ := newrec_.ext_transport_calendar_id;
   END IF;
   IF (indrec_.picking_leadtime ) THEN
      picking_leadtime_          := newrec_.picking_leadtime;
   END IF;
   IF (indrec_.forward_agent_id ) THEN
      forward_agent_id_          := newrec_.forward_agent_id;
   END IF;
   IF (indrec_.delivery_terms ) THEN
      delivery_terms_ := newrec_.delivery_terms;
   END IF;
   IF (indrec_.del_terms_location) THEN
      del_terms_location_ := newrec_.del_terms_location;
   END IF;

   quote_rec_ := ORDER_QUOTATION_API.Get(newrec_.quotation_no);
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(quote_rec_.customer_no);

   -- handle address as single occurence if Prospect customer
   IF newrec_.single_occ_addr_flag = 'TRUE' OR (customer_category_ = Customer_Category_API.DB_PROSPECT) THEN 
      addr_flag_ := 'Y';
   END IF;

   IF (ship_via_code_ IS NOT NULL) THEN
      IF ((delivery_leadtime_ IS NULL) OR (picking_leadtime_ IS NULL) OR
          (delivery_terms_ IS NULL) OR (del_terms_location_ IS NULL)) THEN
         newrec_.ship_via_code := ship_via_code_;
         -- Retrive default delivery leadtime / picking leadtime for the specified ship via code
         Cust_Order_Leadtime_Util_API.Get_Ship_Via_Values(route_id_, newrec_.forward_agent_id,
                                                          newrec_.delivery_leadtime,
                                                          newrec_.ext_transport_calendar_id,
                                                          distance_,
                                                          expected_additional_cost_,
                                                          cost_curr_code_,
                                                          internal_leadtime_,
                                                          ship_via_transit_,
                                                          newrec_.freight_map_id,
                                                          newrec_.zone_id,
                                                          newrec_.picking_leadtime,
                                                          dummy_shipment_type_,
                                                          newrec_.delivery_terms,
                                                          newrec_.del_terms_location,
                                                          newrec_.contract,
                                                          newrec_.customer_no,
                                                          newrec_.ship_addr_no,
                                                          addr_flag_,
                                                          newrec_.part_no,
                                                          newrec_.order_supply_type,
                                                          newrec_.vendor_no,
                                                          newrec_.ship_via_code,
                                                          NULL,
                                                          'TRUE');
         IF (delivery_terms_ IS NOT NULL) THEN
            -- If delivery terms is sent in the attribute string this should
            -- override the default value
            newrec_.delivery_terms := delivery_terms_;
         ELSIF newrec_.delivery_terms IS NULL THEN
            newrec_.delivery_terms := quote_rec_.delivery_terms;
         END IF;
         
         IF (del_terms_location_ IS NOT NULL) THEN
            -- IF a del term location was sent in the attribute string this should override the default value
            newrec_.del_terms_location := del_terms_location_;
         ELSIF newrec_.del_terms_location IS NULL THEN
            newrec_.del_terms_location := quote_rec_.del_terms_location;
         END IF;
         
         IF (delivery_leadtime_ IS NOT NULL) THEN
            -- IF a delivery leadtime was sent in the attribute string this should
            -- override the default value
            newrec_.delivery_leadtime := delivery_leadtime_;
         END IF;
         IF (ext_transport_calendar_id_ IS NOT NULL) THEN
            -- IF an external transport calendar was sent in the attribute string this should override the default value
            newrec_.ext_transport_calendar_id := ext_transport_calendar_id_;
         END IF;
         IF (picking_leadtime_ IS NOT NULL) THEN
            -- IF a picking leadtime was sent in the attribute string this should override the default value
            newrec_.picking_leadtime := picking_leadtime_;
      END IF;
         IF (forward_agent_id_ IS NOT NULL) THEN
            -- IF a forward agent  was sent in the attribute string this should override the default value
            newrec_.forward_agent_id := forward_agent_id_;
         END IF;
      END IF;
   ELSE
      -- Retrieve customer agrement for the part if any
      IF (newrec_.price_source = 'AGREEMENT') THEN
         agreement_id_ := newrec_.price_source_id;
      ELSE
         agreement_id_ := NULL;
      END IF;
      IF (newrec_.line_item_no > 0)  THEN
         -- The current line is a package component line, retrieve ship via code from package header
         pkg_rec_ := ORDER_QUOTATION_LINE_API.Get(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, -1);
         default_ship_via_code_           := pkg_rec_.ship_via_code;
         default_delivery_terms_          := pkg_rec_.delivery_terms;
         default_del_terms_location_      := pkg_rec_.del_terms_location;
         default_delivery_leadtime_       := pkg_rec_.delivery_leadtime;
         default_ext_transport_cal_id_    := pkg_rec_.ext_transport_calendar_id;
         default_picking_leadtime_        := pkg_rec_.picking_leadtime;
         default_forward_agent_id_        := pkg_rec_.forward_agent_id;
      ELSE
         IF (newrec_.single_occ_addr_flag = 'TRUE' AND newrec_.default_addr_flag = 'N') THEN
            default_ship_via_code_        := NVL(newrec_.ship_via_code, quote_rec_.ship_via_code);
            default_delivery_terms_       := NVL(newrec_.delivery_terms, quote_rec_.delivery_terms);
            default_del_terms_location_   := NVL(newrec_.del_terms_location, quote_rec_.del_terms_location);
            default_delivery_leadtime_    := NVL(newrec_.delivery_leadtime,quote_rec_.delivery_leadtime);
            default_ext_transport_cal_id_ := NVL(newrec_.ext_transport_calendar_id, quote_rec_.ext_transport_calendar_id);
            default_forward_agent_id_     := NVL(newrec_.forward_agent_id, quote_rec_.forward_agent_id);
            default_picking_leadtime_     := NVL(newrec_.picking_leadtime, quote_rec_.picking_leadtime);
         ELSE
            -- Retrieve defaults from order header
            default_ship_via_code_        := quote_rec_.ship_via_code;
            default_delivery_terms_       := quote_rec_.delivery_terms;
            default_del_terms_location_   := quote_rec_.del_terms_location;
            default_delivery_leadtime_    := quote_rec_.delivery_leadtime;
            default_ext_transport_cal_id_ := quote_rec_.ext_transport_calendar_id;
            default_forward_agent_id_     := quote_rec_.forward_agent_id;
            default_picking_leadtime_     := quote_rec_.picking_leadtime;
         END IF;
      END IF;

      newrec_.forward_agent_id := NULL;
      newrec_.ship_via_code    := NULL;
      newrec_.delivery_terms            := NULL;
      newrec_.del_terms_location        := NULL;
      newrec_.delivery_leadtime := NULL;
      newrec_.ext_transport_calendar_id := NULL;
      newrec_.picking_leadtime := NULL;

      -- Get supply chain defaults
      Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Defaults(route_id_, 
                                                             newrec_.forward_agent_id,
                                                             newrec_.ship_via_code,
                                                             newrec_.delivery_terms,
                                                             newrec_.del_terms_location,
                                                             ship_via_transit_,
                                                             newrec_.delivery_leadtime,
                                                             newrec_.ext_transport_calendar_id,
                                                             newrec_.default_addr_flag,
                                                             newrec_.freight_map_id,
                                                             newrec_.zone_id,
                                                             newrec_.picking_leadtime,
                                                             dummy_shipment_type_, 
                                                             newrec_.contract,
                                                             newrec_.customer_no,
                                                             newrec_.ship_addr_no,
                                                             addr_flag_,
                                                             newrec_.part_no,
                                                             newrec_.order_supply_type,
                                                             newrec_.vendor_no,
                                                             agreement_id_,
                                                             default_ship_via_code_,
                                                             default_delivery_terms_,
                                                             default_del_terms_location_,
                                                             default_delivery_leadtime_,
                                                             default_ext_transport_cal_id_, NULL, 
                                                             default_forward_agent_id_, 
                                                             default_picking_leadtime_, NULL,
                                                             quote_rec_.vendor_no);
      
      IF (picking_leadtime_ IS NOT NULL) THEN
         -- IF a picking leadtime was sent in the attribute string this should override the default value
         newrec_.picking_leadtime := picking_leadtime_;
   END IF;
   END IF;


END Get_Supply_Chain_Defaults___;


-- Check_Release___
--   Called from state machinery to check for consistency in data when
--   the release logic is run from planned or revised state.
--   Checks that configuration exists for Base Items and that wanted
--   delivery date exists for lines with the include in planning flag.
PROCEDURE Check_Release___ (
   rec_  IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   IF ((rec_.line_item_no = 0) AND (rec_.buy_qty_due = 0) AND
       (Order_Quotation_Grad_price_API.Grad_Price_Exist(rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no) = 'FALSE')) THEN
      Error_SYS.Record_General(lu_name_, 'QNOQTYR: Line :P1 Del No :P2 without quantity or price breaks. Release not allowed.',
         rec_.line_no, rec_.rel_no);
   END IF;

   IF ((rec_.release_planning = 'RELEASED') AND (rec_.planned_due_date IS NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'QNORELEASE_PLAN1: Line :P1 Del No :P2 cannot be included in planning when Planned Due Date is not set.', rec_.line_no, rec_.rel_no);
   END IF;

   -- Test for configured part.
   -- Configuration is mandatory for configurable parts when the quotation is no more in Planned state
   Check_Base_Part_Config__(rec_);
END Check_Release___;

-- Update_Won_Reason___
--   Called from state machinery to check for consistency in data when the 
--   line is Won. Checks reason code is valid and if yes update the quotation.
PROCEDURE Update_Won_Reason___ (
   rec_  IN OUT order_quotation_line_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_  ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   newrec_  ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   objid_   ORDER_QUOTATION_LINE.objid%TYPE;
   objver_  ORDER_QUOTATION_LINE.objversion%TYPE;
   reason_  ORDER_QUOTATION_LINE_TAB.reason_id%TYPE;
   indrec_  Indicator_Rec;
   attr1_   VARCHAR2(2000);  
BEGIN
   attr1_ := attr_;
   reason_ := Client_SYS.Get_Item_Value('REASON_ID', attr1_ );
    IF (reason_ IS NOT NULL ) THEN
        Lose_Win_Reason_Api.Exist( reason_, Reason_Used_By_Api.DB_SALES_QUOTATION, Lose_Win_Api.DB_WIN );
    END IF;
    -- Update reason_id, lost_to and lost_note
    oldrec_ := Lock_By_Keys___(rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no );
    newrec_ := oldrec_;
    Unpack___(newrec_, indrec_, attr1_);
    Check_Update___(oldrec_, newrec_, indrec_, attr1_);   
    Update___( objid_, oldrec_, newrec_, attr1_, objver_, TRUE);
 END Update_Won_Reason___;
 
-- Update_Lost_Reason___
--   Called from state machinery to check for consistency in data when a line
--   is Lost. Checks reason code is valid  and if yes update the quotation.
PROCEDURE Update_Lost_Reason___ (
   rec_  IN OUT order_quotation_line_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_  ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   newrec_  ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   objid_   ORDER_QUOTATION_LINE.objid%TYPE;
   objver_  ORDER_QUOTATION_LINE.objversion%TYPE;
   reason_  ORDER_QUOTATION_LINE_TAB.reason_id%TYPE;
   indrec_  Indicator_Rec;
   attr1_   VARCHAR2(2000);  
BEGIN
   attr1_ := attr_;
   reason_ := Client_SYS.Get_Item_Value('REASON_ID', attr1_ );
    IF (reason_ IS NOT NULL ) THEN
        Lose_Win_Reason_Api.Exist( reason_, Reason_Used_By_Api.DB_SALES_QUOTATION, Lose_Win_Api.DB_LOSE );
    END IF;
    -- Update reason_id, lost_to and lost_note
    oldrec_ := Lock_By_Keys___(rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no );
    newrec_ := oldrec_;
    Unpack___(newrec_, indrec_, attr1_);
    Check_Update___(oldrec_, newrec_, indrec_, attr1_);   
    Update___( objid_, oldrec_, newrec_, attr1_, objver_, TRUE);
 END Update_Lost_Reason___;

-- Update_Planning___
--   Depending on wether the part is having forecast flag and the
--   include in planning flag set the forcast and planning data
--   will be updated. This procedure is to be called when the line
--   is updated in state released, rejected or revised.
PROCEDURE Update_Planning___ (
   oldrec_     IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   newrec_     IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE )
IS
   new_date_     DATE    := newrec_.planned_due_date;
   old_date_     DATE    := oldrec_.planned_due_date;
   new_qty_      NUMBER  := newrec_.revised_qty_due;
   old_qty_      NUMBER  := oldrec_.revised_qty_due;
   new_released_ BOOLEAN := newrec_.release_planning = 'RELEASED';
   old_released_ BOOLEAN := oldrec_.release_planning = 'RELEASED';
   update_       BOOLEAN := FALSE;
BEGIN

   IF (Inventory_Part_API.Get_Forecast_Consump_Flag_Db(newrec_.contract, newrec_.part_no) = 'FORECAST') THEN

      IF new_released_ AND old_released_ THEN
         update_ := (new_date_ != old_date_) OR (new_qty_ != old_qty_);
      END IF;

      IF new_released_ AND NOT old_released_ THEN
         update_ := TRUE;
         old_qty_ := 0;
         old_date_ := new_date_;
      END IF;

      IF NOT new_released_ AND old_released_ THEN
         update_ := TRUE;
         new_qty_ := 0;
         new_date_ := old_date_;
      END IF;

      IF update_ THEN
         Forecast_Consumption___ (newrec_, oldrec_);  
      END IF;
      
   END IF;
   
END Update_Planning___;


-- Validate_Vendor_No___
--   Validate the supplier
PROCEDURE Validate_Vendor_No___ (
   vendor_no_   IN VARCHAR2,
   supply_code_ IN VARCHAR2,
   category_    IN VARCHAR2 )
IS
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      IF vendor_no_ IS NOT NULL THEN
         IF NOT (Supplier_API.Is_Valid(vendor_no_)) THEN
            Error_SYS.Record_General(lu_name_, 'SUPNOTVALID: The supplier :P1 expiry date has passed.', vendor_no_);
         END IF;
      END IF;
   $END
   -- Note : Vendor_no is mandatory if using Internal Purchase supply
   IF (supply_code_ IN ('IPT', 'IPD')) THEN
      Error_SYS.Check_Not_Null(lu_name_, 'VENDOR_NO', vendor_no_);
      -- Note : IF internal supply - internal vendor must be specified
      IF (NVL(category_, ' ') != 'I') THEN
         Error_SYS.Record_General(lu_name_, 'SUPPLIERCATEGORY: Internal supplier must be specified when supply code is Internal Purchase Order Transit/Direct.');
      END IF;
   ELSIF (supply_code_ IN ('PT', 'PD')) AND (vendor_no_ IS NOT NULL) AND (NVL(category_, ' ') != 'E') THEN
      -- Note : IF supply code is PD or PT an external vendor must be specified
      Error_SYS.Record_General(lu_name_, 'SUPPLIERCATEGORY2: Internal supplier may not be specified when supply code is Purchase Order Transit/Direct.');
   END IF;
END Validate_Vendor_No___;


-- Exist_Vendor_No___
--   Check exists for the supplier
PROCEDURE Exist_Vendor_No___ (
   vendor_no_        IN VARCHAR2,
   contract_         IN VARCHAR2,
   purchase_part_no_ IN VARCHAR2,
   rental_db_        IN VARCHAR2 )
IS
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (purchase_part_no_ IS NOT NULL) THEN
         IF (rental_db_ = Fnd_Boolean_API.DB_FALSE) THEN
            Purchase_Part_Supplier_API.Exist(contract_, purchase_part_no_, vendor_no_, Acquisition_Type_API.DB_PURCHASE_ONLY);
         ELSE
            Purchase_Part_Supplier_API.Exist(contract_, purchase_part_no_, vendor_no_, Acquisition_Type_API.DB_RENTAL_ONLY);
         END IF;
      ELSE
         Supplier_API.Exist(vendor_no_);        
      END IF;
   $ELSE
      NULL;
   $END
END Exist_Vendor_No___;


-- Retrieve_Default_Vendor___
--   Retrieve the default vendor (supplier)
PROCEDURE Retrieve_Default_Vendor___ (
   vendor_no_   OUT VARCHAR2,
   contract_    IN  VARCHAR2,
   part_no_     IN  VARCHAR2,
   supply_code_ IN  VARCHAR2,
   rental_db_   IN  VARCHAR2 )
IS
   default_vendor_no_ order_quotation_line_tab.vendor_no%TYPE := NULL;
   category_          VARCHAR2(20) := NULL;
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF rental_db_ = Fnd_Boolean_API.DB_FALSE THEN
         default_vendor_no_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(contract_, part_no_);
      ELSE
         default_vendor_no_ := Purchase_Part_Supplier_API.Get_Primary_Rental_Supplier_No(contract_, part_no_);
      END IF;
      category_ := Supplier_Category_API.Encode(Supplier_API.Get_Category(default_vendor_no_));               
      IF (default_vendor_no_ IS NOT NULL) THEN
         -- Note : Check the supplier category
         IF (((category_ = 'I') AND (supply_code_ IN ('IPT', 'IPD'))) OR
             ((category_ = 'E') AND (supply_code_ IN ('PD', 'PT')))) THEN
            vendor_no_ := default_vendor_no_;
         END IF;
      END IF;
   $END
   Validate_Vendor_No___(default_vendor_no_, supply_code_, category_);
END Retrieve_Default_Vendor___;


-- Validate_Vendor_Category___
--   Validate the vendor (supplier) category
PROCEDURE Validate_Vendor_Category___ (
   vendor_no_            IN VARCHAR2,
   supply_code_          IN VARCHAR2 )
IS
   category_ VARCHAR2(20) := NULL;
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      category_ := Supplier_Category_API.Encode(Supplier_API.Get_Category(vendor_no_));
   $END   
   Validate_Vendor_No___(vendor_no_, supply_code_, category_);
END Validate_Vendor_Category___;


PROCEDURE Quotation_Changed___ (
   rec_  IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
     ORDER_QUOTATION_API.Quotation_Changed(rec_.quotation_no);
END Quotation_Changed___;


FUNCTION Header_Revised___ (
   rec_  IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN (ORDER_QUOTATION_API.Get_Objstate( rec_.quotation_no ) = 'Revised');
END Header_Revised___;

FUNCTION Header_Rejected___ (
   rec_  IN     order_quotation_line_tab%ROWTYPE ) RETURN BOOLEAN
IS
   
BEGIN
   RETURN (ORDER_QUOTATION_API.Get_Objstate( rec_.quotation_no ) = 'Rejected');
END Header_Rejected___;

FUNCTION Printed___ (
   rec_  IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN (ORDER_QUOTATION_API.Get_Printed_Db( rec_.quotation_no ) = 'PRINTED');
END Printed___;


FUNCTION Is_Package_Header___ (
   rec_  IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN ((rec_.order_supply_type = 'PKG') OR (rec_.line_item_no > 0));
END Is_Package_Header___;


PROCEDURE Cancel_Planning___ (
   rec_  IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   packrec_    ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   packattr_   VARCHAR2(32000);
   dummy_      VARCHAR2(2000);
   connect_charge_line_ NUMBER;
   result_code_               VARCHAR2(2000);
   available_qty_             NUMBER := 0;
   earliest_available_date_   DATE;
   ctp_run_id_                NUMBER;
   interim_ord_id_            VARCHAR2(12);
   
BEGIN
   IF rec_.release_planning = 'RELEASED' AND (rec_.rowstate != 'Planned') THEN
      IF (Inventory_Part_API.Get_Forecast_Consump_Flag_Db(rec_.contract, rec_.part_no) = 'FORECAST') THEN
      -- Unconsume the planned quantity
         Reserve_Customer_Order_API.Control_Ms_Mrp_Consumption
            (result_code_ ,
             available_qty_,
             earliest_available_date_,
             rec_.contract, rec_.part_no, 0,
             0, rec_.revised_qty_due,
             rec_.planned_due_date, rec_.planned_due_date,
             'CQ', FALSE, NULL, NULL);
      END IF;
   END IF;
   
  interim_ord_id_:= Get_Interim_Order_No(rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.ctp_planned);

   -- cancel capability check reservations/allocations
   IF (rec_.ctp_planned = 'Y' OR (rec_.ctp_planned = 'N' AND interim_ord_id_ IS NOT NULL)) THEN
      $IF (Component_Ordstr_SYS.INSTALLED) $THEN
          Interim_Ctp_Manager_API.Cancel_Ctp(dummy_, rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, 'CUSTOMERQUOTE', rec_.order_supply_type);  
      $END   
      Clear_Ctp_Planned(rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
   END IF;

   -- Remove interim order and configuration specification
   IF (rec_.configuration_id != '*' AND rec_.ctp_planned = 'N') THEN
      $IF (Component_Ordstr_SYS.INSTALLED) $THEN
         Interim_Demand_Head_API.Remove_Interim_Head_By_Usage('CUSTOMERQUOTE', rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      $ELSE
         NULL;
      $END  
   END IF;
   
   $IF (Component_Ordstr_SYS.INSTALLED) $THEN
      -- Remove ctp record
      ctp_run_id_ := Interim_Ctp_Critical_Path_API.Get_Ctp_Run_Id('CUSTOMERQUOTE', rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      IF (ctp_run_id_ IS NOT NULL AND ctp_run_id_ > 0) THEN
         Interim_Ctp_Critical_Path_API.Clear_Ctp_Data(ctp_run_id_);
      END IF;
   $END

   -- Package part line cancelled ?
   IF (rec_.line_item_no > 0) THEN
      -- update package part
      Recalc_Package_Structure__( rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.calc_char_price, rec_.char_price  );

      IF Get_Objstate( rec_.quotation_no, rec_.line_no, rec_.rel_no, -1 ) IN ('Released','Rejected') THEN
         packrec_ := Lock_By_Keys___( rec_.quotation_no, rec_.line_no, rec_.rel_no, -1 );
         Finite_State_Machine___( packrec_, 'PackageLineChanged', packattr_ );
      END IF;
   END IF;

   -- Recalculation of dicount must be made.
   ORDER_QUOTATION_API.Modify_Calc_Disc_Flag(rec_.quotation_no, 'TRUE');

   connect_charge_line_ := Order_Quotation_Charge_API.Exist_Charge_On_Quot_Line(rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
   IF (connect_charge_line_ = 1) THEN
      Customer_Order_Charge_Util_API.Remove_Connected_QChg_Lines(rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
   END IF;
 
END Cancel_Planning___;


PROCEDURE Release_For_Planning___ (
   rec_  IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_ ORDER_QUOTATION_LINE_TAB%ROWTYPE;
BEGIN
   
   -- Do we have to look for Aquisition mode also? != 'ND' and != 'IO'
   -- Create forecast in MS or MRP if needed.
   IF rec_.release_planning = 'RELEASED' THEN
      IF (Inventory_Part_API.Get_Forecast_Consump_Flag_Db(rec_.contract, rec_.part_no) = 'FORECAST') THEN
         Forecast_Consumption___ (rec_, oldrec_);
      END IF;
   END IF;
   
END Release_For_Planning___;



-- Check_Active_Part___
--   Check if the inventory part is active or not.
PROCEDURE Check_Active_Part___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
BEGIN
   IF (part_no_ IS NOT NULL) THEN
      IF (Inventory_Part_Status_Par_API.Get_Demand_Flag_Db(Inventory_Part_API.Get_Part_Status(contract_, part_no_)) = 'N') THEN
         Error_SYS.Record_General(lu_name_, 'DEMAND_NOT_ALLOW: The inventory part requested has a status that does not allow new demands.');
      END IF;
   END IF;
END Check_Active_Part___;


PROCEDURE Insert_Business_Opp_Line___ (
   newrec_                    IN OUT   ORDER_QUOTATION_LINE_TAB%ROWTYPE,       
   business_opportunity_no_   IN       VARCHAR2,
   rowid_                     IN       VARCHAR2 )
IS
   bo_attr_                  VARCHAR2(32000);   
   bo_line_no_               NUMBER;
   oldrec_                   ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   info_                     VARCHAR2(2000);                     
BEGIN
   $IF Component_Crm_SYS.INSTALLED $THEN

      IF (business_opportunity_no_ IS NOT NULL AND newrec_.line_item_no <= 0 AND newrec_.rental = 'FALSE') THEN        
         -- The following check should be added in order to avoid recursive insertion in BO.
         IF NOT (Business_Opportunity_Line_API.Check_Exist(newrec_.demand_order_ref1, newrec_.demand_order_ref2)) THEN             
            Client_SYS.Clear_Attr(bo_attr_);            
            Client_SYS.Add_To_Attr('OPPORTUNITY_NO', business_opportunity_no_, bo_attr_);            
            Client_SYS.Add_To_Attr('CONTRACT', newrec_.contract, bo_attr_);
            Client_SYS.Add_To_Attr('CATALOG_NO', newrec_.catalog_no, bo_attr_);
            Client_SYS.Add_To_Attr('DESCRIPTION', newrec_.catalog_desc, bo_attr_);
            Client_SYS.Add_To_Attr('QTY', newrec_.buy_qty_due, bo_attr_);
            Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', newrec_.wanted_delivery_date, bo_attr_);
            Client_SYS.Add_To_Attr('SALE_UNIT_PRICE', newrec_.sale_unit_price, bo_attr_);
            Client_SYS.Add_To_Attr('SALES_UNIT_MEAS', newrec_.sales_unit_measure, bo_attr_);
            Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE', newrec_.base_sale_unit_price, bo_attr_);
            Client_SYS.Add_To_Attr('COST', newrec_.cost, bo_attr_);
            Client_SYS.Add_To_Attr('DISCOUNT', newrec_.discount, bo_attr_);
            Client_SYS.Add_To_Attr('ADDITIONAL_DISCOUNT', newrec_.additional_discount, bo_attr_);
            Client_SYS.Add_To_Attr('CON_OBJECT_TYPE_DB', Business_Object_Type_API.DB_SALES_QUOTATION, bo_attr_);
            Client_SYS.Add_To_Attr('CON_OBJECT_REF1', newrec_.quotation_no, bo_attr_);
            Client_SYS.Add_To_Attr('CON_OBJECT_REF2', newrec_.line_no, bo_attr_);
            Client_SYS.Add_To_Attr('CON_OBJECT_REF3', newrec_.rel_no, bo_attr_);
            Client_SYS.Add_To_Attr('CON_OBJECT_REF4', newrec_.line_item_no, bo_attr_);
            Client_SYS.Add_To_Attr('INSERT_ALLOWED','TRUE', bo_attr_);
            Client_SYS.Add_To_Attr('PRICE_SOURCE_DB', newrec_.price_source, bo_attr_);
            Client_SYS.Add_To_Attr('PART_PRICE', newrec_.part_price, bo_attr_);
            Client_SYS.Add_To_Attr('PRICE_UNIT_MEAS', newrec_.price_unit_meas, bo_attr_);
            Client_SYS.Add_To_Attr('PRICE_SOURCE_ID', newrec_.price_source_id, bo_attr_);
            Business_Opportunity_Line_API.New(info_, bo_attr_);

            -- Set the status to QuotationCreated
            bo_line_no_ := Client_SYS.Get_Item_Value('LINE_NO', bo_attr_);
            Business_Opportunity_Line_API.Line_In_Progress(business_opportunity_no_, Client_SYS.Attr_Value_To_Number(bo_line_no_));

            -- Update the reference in Order quotation    
            oldrec_ := newrec_;         
            newrec_.demand_code := Order_Supply_Type_API.DB_BUSINESS_OPPORTUNITY;
            newrec_.demand_order_ref1 := business_opportunity_no_;            
            newrec_.demand_order_ref2 := bo_line_no_;         
            Update_Line___(rowid_, oldrec_, newrec_, TRUE, FALSE);         
         END IF;
      END IF;
   $ELSE
      NULL;
   $END   
END Insert_Business_Opp_Line___;


PROCEDURE Update_Business_Opp_Line___ (
   newrec_                    IN OUT   ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   oldrec_                    IN       ORDER_QUOTATION_LINE_TAB%ROWTYPE )
IS
   bo_attr_                  VARCHAR2(32000);     
   info_                     VARCHAR2(2000);
   revision_no_              VARCHAR2(4);
BEGIN
   $IF Component_Crm_SYS.INSTALLED $THEN
      IF (newrec_.demand_code = Order_Supply_Type_API.DB_BUSINESS_OPPORTUNITY) THEN
         IF(Business_Opportunity_Line_API.Check_Exist(newrec_.demand_order_ref1, newrec_.demand_order_ref2)) THEN           
            -- Update BO line
            IF(oldrec_.catalog_desc != newrec_.catalog_desc) 
               OR (NVL(oldrec_.buy_qty_due,0) != NVL(newrec_.buy_qty_due,0))
               OR (NVL(oldrec_.wanted_delivery_date, Database_Sys.first_calendar_date_) != NVL(newrec_.wanted_delivery_date,Database_Sys.first_calendar_date_))
               OR (NVL(oldrec_.sale_unit_price,0) != NVL(newrec_.sale_unit_price,0))        
               OR (NVL(oldrec_.base_sale_unit_price,0) != NVL(newrec_.base_sale_unit_price,0))
               OR (NVL(oldrec_.cost,0) != NVL(newrec_.cost,0)) 
               OR (NVL(oldrec_.discount,0) != NVL(newrec_.discount,0))
               OR (NVL(oldrec_.additional_discount,0) != NVL(newrec_.additional_discount,0))
               OR (oldrec_.configuration_id != newrec_.configuration_id)
               OR (oldrec_.price_freeze != newrec_.price_freeze)THEN
               Client_SYS.Add_To_Attr('DESCRIPTION', newrec_.catalog_desc, bo_attr_);
               Client_SYS.Add_To_Attr('QTY', newrec_.buy_qty_due, bo_attr_);
               Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', newrec_.wanted_delivery_date, bo_attr_);
               Client_SYS.Add_To_Attr('SALE_UNIT_PRICE', newrec_.sale_unit_price, bo_attr_);
               Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE', newrec_.base_sale_unit_price, bo_attr_);
               Client_SYS.Add_To_Attr('COST', newrec_.cost, bo_attr_);
               Client_SYS.Add_To_Attr('DISCOUNT', newrec_.discount, bo_attr_);
               Client_SYS.Add_To_Attr('ADDITIONAL_DISCOUNT', newrec_.additional_discount, bo_attr_);
               Client_SYS.Add_To_Attr('CONFIGURATION_ID', newrec_.configuration_id, bo_attr_);
               Client_SYS.Add_To_Attr('PRICE_FREEZE', Freeze_Flag_Api.Decode(newrec_.price_freeze), bo_attr_);
               Client_SYS.Add_To_Attr('UPDATE_ALLOWED', 'TRUE', bo_attr_);
               Client_SYS.Add_To_Attr('PRICE_SOURCE_DB', newrec_.price_source, bo_attr_);
               Client_SYS.Add_To_Attr('PART_PRICE', newrec_.part_price, bo_attr_);
               Client_SYS.Add_To_Attr('PRICE_UNIT_MEAS', newrec_.price_unit_meas, bo_attr_);
               Client_SYS.Add_To_Attr('PRICE_SOURCE_ID', newrec_.price_source_id, bo_attr_);
               Business_Opportunity_Line_API.Modify(info_, bo_attr_, newrec_.demand_order_ref1, newrec_.demand_order_ref2);              
               IF (oldrec_.configuration_id != newrec_.configuration_id AND newrec_.configured_line_price_id IS NOT NULL) THEN
                  revision_no_ := Business_Opportun_Revision_API.Get_Active_Revision(newrec_.demand_order_ref1);
                  Configured_Line_Price_API.Transfer_Pricing__(info_, newrec_.configured_line_price_id, Business_Opportunity_Line_API.Get_Configured_Line_Price_Id(newrec_.demand_order_ref1, revision_no_, newrec_.demand_order_ref2), FALSE);
               END IF;
            END IF;            
         END IF;      
      END IF;            
   $ELSE
      NULL;
   $END   
END Update_Business_Opp_Line___;


PROCEDURE Update_Bo_Line_Status___ (
   rec_  IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS  
   reason_id_        order_quotation_line_tab.reason_id%TYPE;
   lose_win_note_    order_quotation_line_tab.lose_win_note%TYPE;
   lost_to_          order_quotation_line_tab.lost_to%TYPE;
   line_rec_         Order_Quotation_Line_API.Public_Rec;
BEGIN   
   $IF Component_Crm_SYS.INSTALLED $THEN
      IF (rec_.demand_code = Order_Supply_Type_API.DB_BUSINESS_OPPORTUNITY) THEN
         IF(Business_Opportunity_Line_API.Check_Exist(rec_.demand_order_ref1, rec_.demand_order_ref2)) THEN             
            -- Update BO line status
            IF rec_.rowstate = 'Cancelled' THEN
               -- Cancel BO line
               Business_Opportunity_Line_API.Set_Cancelled(rec_.demand_order_ref1, rec_.demand_order_ref2, rec_.cancel_reason, rec_.note_text);                   
            ELSIF rec_.rowstate = 'Won' THEN
               -- Set BO line to Won
               reason_id_        := Client_SYS.Get_Item_Value('REASON_ID', attr_ );
               lose_win_note_    := Client_SYS.Get_Item_Value('LOSE_WIN_NOTE', attr_ );
               Business_Opportunity_Line_API.Order_Line_Won(rec_.demand_order_ref1, rec_.demand_order_ref2, reason_id_, lose_win_note_, NULL, NULL, NULL, NULL);                   
            ELSIF rec_.rowstate = 'CO Created' THEN
               -- Set BO line to Won with reference type Customer Order
               reason_id_        := Client_SYS.Get_Item_Value('REASON_ID', attr_ );
               lose_win_note_         := Client_SYS.Get_Item_Value('LOSE_WIN_NOTE', attr_ );
               line_rec_         := Order_Quotation_Line_API.Get(rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);              
               Business_Opportunity_Line_API.Order_Line_Won(rec_.demand_order_ref1, rec_.demand_order_ref2, reason_id_, lose_win_note_, line_rec_.con_order_no, line_rec_.con_line_no, line_rec_.con_rel_no, line_rec_.con_line_item_no);                   
            ELSIF rec_.rowstate = 'Lost' THEN
               -- Set BO line to Lost
               reason_id_        := Client_SYS.Get_Item_Value('REASON_ID', attr_ );
               lost_to_          := Client_SYS.Get_Item_Value('LOST_TO', attr_ );
               lose_win_note_    := Client_SYS.Get_Item_Value('LOSE_WIN_NOTE', attr_ );
               Business_Opportunity_Line_API.Set_Lost(rec_.demand_order_ref1, rec_.demand_order_ref2, lost_to_, reason_id_, lose_win_note_);              
            END IF;            
         END IF;      
      END IF;            
   $ELSE
      NULL;
   $END   
END Update_Bo_Line_Status___;


@Override
PROCEDURE Finite_State_Set___ (
   rec_   IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   state_ IN     VARCHAR2 )
IS
BEGIN
   super(rec_, state_);
   -- History
   Order_Quote_Line_Hist_API.New( rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no );
END Finite_State_Set___;


@Override
PROCEDURE Finite_State_Machine___ (
   rec_   IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   event_ IN     VARCHAR2,
   attr_  IN OUT VARCHAR2 )
IS
   pkg_attr_    VARCHAR2(32000);
   ctp_run_id_  NUMBER;
BEGIN
   pkg_attr_ := attr_;   
   super(rec_, event_, attr_);
   
   -- Update package component if exists
   IF (rec_.order_supply_type = 'PKG') THEN
      Update_Package_State___( rec_.quotation_no, rec_.line_no, rec_.rel_no, event_, pkg_attr_ );
   END IF; 
END Finite_State_Machine___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   quotation_no_ ORDER_QUOTATION_LINE_TAB.quotation_no%TYPE;
   rental_db_    ORDER_QUOTATION_LINE_TAB.rental%TYPE;
   quote_rec_    ORDER_QUOTATION_API.Public_Rec;
BEGIN
   -- Fetch attributes already set in client by function DataRecordGetDefaults
   quotation_no_ := Client_SYS.Get_Item_Value('QUOTATION_NO', attr_);
   rental_db_    := NVL(Client_SYS.Get_Item_Value('RENTAL_DB', attr_), Fnd_Boolean_API.DB_FALSE);
   quote_rec_ := ORDER_QUOTATION_API.Get(quotation_no_);

   super(attr_);
   -- Added quotation_no to the attr_ as it is cleared inside the base method
   Client_SYS.Add_To_Attr('QUOTATION_NO', quote_rec_.quotation_no, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', quote_rec_.contract, attr_);
   Client_SYS.Add_To_Attr('COMPANY', quote_rec_.company, attr_);
   -- Do this for not overrinding wanted_delivery_date in frmQuotePackageStructure
   -- in case value from head is null
   IF (quote_rec_.wanted_delivery_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', quote_rec_.wanted_delivery_date, attr_);
      Client_SYS.Add_To_Attr('PROMISED_DELIVERY_DATE', quote_rec_.wanted_delivery_date, attr_);
      Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE', quote_rec_.wanted_delivery_date, attr_);
   END IF;

   Client_SYS.Add_To_Attr('PROBABILITY_TO_WIN', quote_rec_.quotation_probability, attr_ );
   Client_SYS.Add_To_Attr('COST', 0, attr_);
   Client_SYS.Add_To_Attr('BUY_QTY_DUE', 0, attr_);
   Client_SYS.Add_To_Attr('CONV_FACTOR', 1, attr_);
   Client_SYS.Add_To_Attr('PRICE_CONV_FACTOR', 0, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT', 0, attr_);
   Client_SYS.Add_To_Attr('QUOTATION_DISCOUNT', 0, attr_);
   Client_SYS.Add_To_Attr('RELEASE_PLANNING_DB', 'NOTRELEASED', attr_);
   Client_SYS.Add_To_Attr('CHARGED_ITEM_DB', 'CHARGED ITEM', attr_);
   Client_SYS.Add_To_Attr('PRICE_FREEZE_DB', 'FREE', attr_);
   Client_SYS.Add_To_Attr('CONFIGURATION_ID', '*', attr_);
   Client_SYS.Add_To_Attr('CTP_PLANNED_DB', 'N', attr_);
   Client_SYS.Add_To_Attr('INVERTED_CONV_FACTOR', 1, attr_);

   -- default delivery information from quotation header
   Client_SYS.Add_To_Attr('DEFAULT_ADDR_FLAG_DB', 'Y', attr_);
   Client_SYS.Add_To_Attr('SHIP_ADDR_NO', quote_rec_.ship_addr_no, attr_);
   Client_SYS.Add_To_Attr('END_CUSTOMER_ID', Customer_Info_Address_API.Get_End_Customer_Id(quote_rec_.customer_no, quote_rec_.ship_addr_no), attr_);
   Client_SYS.Add_To_Attr('TAX_LIABILITY', quote_rec_.tax_liability, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TERMS', quote_rec_.delivery_terms, attr_);
   Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', quote_rec_.del_terms_location, attr_);
   Client_SYS.Add_To_Attr('CLASSIFICATION_STANDARD', quote_rec_.classification_standard, attr_);
   Client_SYS.Add_To_Attr('SINGLE_OCC_ADDR_FLAG', quote_rec_.single_occ_addr_flag, attr_);
   Client_SYS.Add_To_Attr('SHIP_ADDR_IN_CITY', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('TAX_LIABILITY_TYPE_DB', Tax_Liability_API.Get_Tax_Liability_Type_Db(quote_rec_.tax_liability, quote_rec_.country_code), attr_);
   Client_SYS.Add_To_Attr('FREE_OF_CHARGE_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', quote_rec_.customer_tax_usage_type, attr_);
   IF (rental_db_ = Fnd_Boolean_API.DB_TRUE) THEN
      Prepare_Rental___(attr_);
   END IF;
   -- gelr:disc_price_rounded, begin
   IF (quote_rec_.disc_price_round = Fnd_Boolean_API.DB_TRUE AND quote_rec_.use_price_incl_tax = Fnd_Boolean_API.DB_FALSE) THEN
      Client_SYS.Add_To_Attr('ORIGINAL_DISCOUNT', 0, attr_);
      Client_SYS.Add_To_Attr('ORIGINAL_QUOTATION_DISCOUNT', 0, attr_);
   END IF;
   -- gelr:disc_price_rounded, end
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   sales_part_rec_                  Sales_Part_API.Public_Rec;
   headver_                         VARCHAR2(2000);
   cross_rec_                       Sales_Part_Cross_Reference_API.Public_Rec;
   temp_line_total_weight_gross_    NUMBER;
   quote_rec_                       ORDER_QUOTATION_API.Public_Rec;
   cust_calendar_id_                VARCHAR2(10);
   current_info_                    VARCHAR2(32000);
   old_note_id_                     NUMBER;
BEGIN   
   current_info_ := NULL;
   current_info_ := Client_SYS.Get_All_Info;
   App_Context_SYS.Set_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_', current_info_);
   quote_rec_ := ORDER_QUOTATION_API.Get(newrec_.quotation_no);

   -- if we have a configurable part, we will sooner or later create a configuration,
   -- then we need a price-id. Create it now so it is available when we call the configuration dialog.
   IF Sales_Part_API.Get_Configurable_Db(newrec_.contract, newrec_.catalog_no) = 'CONFIGURED' THEN
      newrec_.configured_line_price_id := Configured_Line_Price_API.New_Quote_Line_Price
         (newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      Client_SYS.Add_To_Attr('CONFIGURED_LINE_PRICE_ID', newrec_.configured_line_price_id, attr_);
   END IF;

   -- fetch customer part number if not entered - or invalid
   IF ((newrec_.customer_part_no IS NULL) OR
       (newrec_.catalog_no != nvl(Sales_Part_Cross_Reference_API.Get_Catalog_No(newrec_.customer_no, newrec_.contract,
                                                                            newrec_.customer_part_no), ' '))) THEN
      newrec_.customer_part_no := Sales_Part_Cross_Reference_API.Get_Customer_Part_No(newrec_.customer_no, newrec_.contract, newrec_.catalog_no);
      END IF;

      -- if part number was found, fetch unit and conv factor...
      IF (newrec_.customer_part_no IS NOT NULL) THEN
         cross_rec_ := Sales_Part_Cross_Reference_API.Get(newrec_.customer_no, newrec_.contract, newrec_.customer_part_no);
         IF (newrec_.customer_part_conv_factor IS NULL) THEN
            newrec_.customer_part_conv_factor := greatest(nvl(cross_rec_.conv_factor, 1), 0);
         END IF;
         IF (newrec_.cust_part_invert_conv_fact IS NULL) THEN
            newrec_.cust_part_invert_conv_fact := cross_rec_.inverted_conv_factor;
         END IF;
         IF (newrec_.customer_part_unit_meas IS NULL) THEN
            newrec_.customer_part_unit_meas := nvl(cross_rec_.customer_unit_meas, newrec_.sales_unit_measure);
         END IF;
         IF (newrec_.customer_part_buy_qty IS NULL) THEN
            -- Added cust_part_invert_conv_fact to modify the calculation of customer_part_buy_qty
            newrec_.customer_part_buy_qty := newrec_.buy_qty_due / newrec_.customer_part_conv_factor * newrec_.cust_part_invert_conv_fact;
         END IF;
         IF (newrec_.catalog_desc IS NULL) THEN
            newrec_.catalog_desc := cross_rec_.catalog_desc;
         END IF;
         --Get the self billing db value
         newrec_.self_billing := NVL(cross_rec_.self_billing, 'NOT SELF BILLING');

         Client_SYS.Set_Item_Value('CUSTOMER_PART_NO', newrec_.customer_part_no, attr_);
         Client_SYS.Set_Item_Value('CUSTOMER_PART_CONV_FACTOR', newrec_.customer_part_conv_factor, attr_);
         Client_SYS.Set_Item_Value('CUSTOMER_PART_UNIT_MEAS', newrec_.customer_part_unit_meas, attr_);
         Client_SYS.Set_Item_Value('CUSTOMER_PART_BUY_QTY', newrec_.customer_part_buy_qty, attr_);
         Client_SYS.Set_Item_Value('CUST_PART_INVERT_CONV_FACT', newrec_.cust_part_invert_conv_fact, attr_);
      ELSE
         -- Set the self billing db value to no self billing
         newrec_.self_billing := 'NOT SELF BILLING';
         newrec_.customer_part_conv_factor := NULL;
         newrec_.customer_part_unit_meas := NULL;
         newrec_.customer_part_buy_qty := NULL;
         newrec_.cust_part_invert_conv_fact := NULL;
   END IF;
   -- IF inserting a package component, set catalog_type as such
   IF (newrec_.line_item_no > 0) THEN
      newrec_.catalog_type := 'KOMP';
      Client_SYS.Set_Item_Value('CATALOG_TYPE', Sales_Part_Type_API.Decode(newrec_.catalog_type), attr_);
   END IF;

   old_note_id_    := newrec_.note_id;
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   IF (old_note_id_ IS NOT NULL ) THEN
      Document_Text_API.Copy_All_Note_Texts(old_note_id_, newrec_.note_id);
   END IF;
   Client_SYS.Set_Item_Value('NOTE_ID', newrec_.note_id, attr_);

   sales_part_rec_ := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);
   -- IID DI011 removed net weight from Invent Part and adds it to the Partcatalog.
   -- As a result now Sales Part's freight info can get fetched from on itself or from part catalog.
   -- Sales_Weight_Volume_Util_API.Get_Total_Weight_Volume does the necessary conresions and returns the values.

   Sales_Weight_Volume_Util_API.Get_Total_Weight_Volume(total_net_weight_ => newrec_.line_total_weight
                                                        , total_gross_weight_ =>  temp_line_total_weight_gross_
                                                        , total_volume_ => newrec_.line_total_qty
                                                        , adjusted_net_weight_ => newrec_.adjusted_weight_net 
                                                        , adjusted_gross_weight_ => newrec_.adjusted_weight_gross 
                                                        , adjusted_volume_ => newrec_.adjusted_volume
                                                        , contract_ => newrec_.contract
                                                        , catalog_no_ => newrec_.catalog_no
                                                        , part_no_ => sales_part_rec_.part_no
                                                        , buy_qty_due_ => newrec_.buy_qty_due
                                                        , configuration_id_ => newrec_.configuration_id
                                                        , input_unit_meas_ => NULL
                                                        , input_qty_ => NULL);
   
   newrec_.price_conv_factor := sales_part_rec_.price_conv_factor;

   newrec_.cust_warranty_id := sales_part_rec_.cust_warranty_id;

   -- Tell the warranty that it's shared
   IF (newrec_.cust_warranty_id IS NOT NULL) THEN
      Cust_Warranty_API.Inherit(newrec_.cust_warranty_id);
      Client_SYS.Add_To_Attr('CUST_WARRANTY_ID', newrec_.cust_warranty_id, attr_);
   END IF;

   newrec_.date_entered := Site_API.Get_Site_Date(newrec_.contract);

   Client_SYS.Add_To_Attr('DATE_ENTERED', newrec_.date_entered, attr_);
   
   IF (newrec_.customer_tax_usage_type IS NULL) THEN
      newrec_.customer_tax_usage_type := quote_rec_.customer_tax_usage_type;
   END IF;
   -- gelr:disc_price_rounded, begin
   IF (Order_Quotation_API.Get_Discounted_Price_Rounded(newrec_.quotation_no)) THEN
      -- user/system operates on additional_discount but it is saved in technical column: original_add_discount
      -- Initialize original_ column which is now empty
      newrec_.original_add_discount := newrec_.additional_discount;
      newrec_.additional_discount := Customer_Order_Pricing_API.Calculate_Additional_Discount(newrec_.contract,
                                                                   quote_rec_.currency_code,
                                                                   newrec_.additional_discount,
                                                                   newrec_.buy_qty_due,
                                                                   newrec_.price_conv_factor,
                                                                   newrec_.sale_unit_price,
                                                                   newrec_.discount);
      -- The same as previous
      newrec_.original_quotation_discount := newrec_.quotation_discount;
      
      newrec_.quotation_discount := Customer_Order_Pricing_API.Calculate_Additional_Discount(newrec_.contract,
                                                                   quote_rec_.currency_code,
                                                                   newrec_.quotation_discount,
                                                                   newrec_.buy_qty_due,
                                                                   newrec_.price_conv_factor,
                                                                   newrec_.sale_unit_price,
                                                                   newrec_.discount);
   ELSE
      newrec_.original_discount       := 0;
      newrec_.original_quotation_discount := 0;
      newrec_.original_add_discount   := 0;
   END IF;
   -- gelr:disc_price_rounded, end   
   
   super(objid_, objversion_, newrec_, attr_);
   
   IF quote_rec_.jinsui_invoice = 'TRUE' THEN
      Validate_Jinsui_Constraints__( newrec_, 0, FALSE);
   END IF;
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      New_Rental___(attr_, newrec_);
   END IF;

   Post_Insert_Actions___(attr_, newrec_);   

   Client_SYS.Add_To_Attr('HEADVER', headver_, attr_ );
   Client_SYS.Add_To_Attr('ORDER_SUPPLY_TYPE_DB', newrec_.order_supply_type, attr_ );

   IF (newrec_.planned_delivery_date IS NOT NULL) THEN      
      IF (NOT (newrec_.planned_delivery_date = NVL(newrec_.wanted_delivery_date, Database_Sys.first_calendar_date_)
               AND NVL(newrec_.wanted_delivery_date, Database_Sys.first_calendar_date_) = NVL(quote_rec_.wanted_delivery_date, Database_Sys.first_calendar_date_))
          OR NVL(newrec_.customer_no, Database_Sys.string_null_) != NVL(quote_rec_.customer_no, Database_Sys.string_null_)
          OR NVL(newrec_.ship_addr_no, Database_Sys.string_null_) != NVL(quote_rec_.ship_addr_no, Database_Sys.string_null_)) THEN
         IF (newrec_.planned_delivery_date IS NOT NULL AND newrec_.customer_no IS NOT NULL 
               AND newrec_.ship_addr_no IS NOT NULL) THEN
            cust_calendar_id_ := Cust_Ord_Customer_Address_API.Get_Cust_Calendar_Id(newrec_.customer_no, newrec_.ship_addr_no);
            Cust_Ord_Date_Calculation_API.Check_Date_On_Cust_Calendar_(newrec_.customer_no, cust_calendar_id_, newrec_.planned_delivery_date, 'PLANNED');
         END IF;
      END IF;
   END IF;

   IF (newrec_.ext_transport_calendar_id IS NOT NULL) THEN
      Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.ext_transport_calendar_id);
   END IF;

   -- Set out parameter values (might have changed in Post_Insert_Actions___)
   Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   newrec_     IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE)
IS
   quote_rec_                    ORDER_QUOTATION_API.Public_Rec;
   sales_part_rec_               Sales_Part_API.Public_Rec;
   linerec_                      ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   oldlinerec_                   ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   rowid_                        VARCHAR2(2000);
   rowversion_                   VARCHAR2(2000);
   headver_                      ORDER_QUOTATION_LINE.OBJVERSION%TYPE;
   pkg_changed_                  BOOLEAN := FALSE;
   discount_                     NUMBER;
   qty_refreshed_                NUMBER;
   price_source_refreshed_       NUMBER;
   current_info_temp_            VARCHAR2(2000);
   pack_line_rowid_              VARCHAR2(2000);
   temp_line_total_weight_gross_ NUMBER;
   exist_chg_on_quot_line_       NUMBER;
   pack_size_chg_line_quot_no_   NUMBER;
   cust_calendar_id_             VARCHAR2(10);
   refresh_config_price_         NUMBER;
   customer_category_            CUSTOMER_INFO_TAB.customer_category%TYPE;
   updated_from_wizard_          BOOLEAN := FALSE;
   block_component_info_         BOOLEAN;
   current_info_                 VARCHAR2(32000);
   discount_line_count_          NUMBER;
   discount_freeze_db_           VARCHAR2(5);
   new_rental_chargeable_days_   NUMBER;
   old_rental_chargeable_days_   NUMBER;         
   is_rental_modified_           BOOLEAN := FALSE;
   single_occ_addr_changed_      BOOLEAN := FALSE;
   tax_from_defaults_            BOOLEAN := FALSE;
   do_qty_                       BOOLEAN := FALSE;
   unit_price_                   NUMBER;
   dummy_total_disc_pct_         NUMBER;
   dummy_total_disc_amt_         NUMBER;
   updated_from_create_order_    BOOLEAN := FALSE;
   tax_code_changed_             VARCHAR2(5) := 'FALSE';
   copy_addr_to_line_          VARCHAR2(10) := 'FALSE';
   multiple_tax_lines_           VARCHAR2(20);
   tax_item_removed_             VARCHAR2(5) := 'FALSE';
   clear_manual_discount_        VARCHAR2(5);
   tax_method_                   VARCHAR2(50);
   changedrec_                   ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   tax_code_                     VARCHAR2(20);
   fetch_external_tax_           VARCHAR2(5) := 'TRUE';

  -- gelr:disc_price_rounded, begin
   discounted_price_rounded_      BOOLEAN := Order_Quotation_API.Get_Discounted_Price_Rounded(newrec_.quotation_no);
   -- gelr:disc_price_rounded, end
   
   CURSOR get_disc_no (
      quotation_no_ IN VARCHAR2,
      line_no_      IN VARCHAR2,
      rel_no_       IN VARCHAR2,
      line_item_no_ IN NUMBER)
   IS
      SELECT discount_no
      FROM order_quote_line_discount_tab
      WHERE quotation_no = quotation_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   current_info_ :=  App_Context_SYS.Find_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_');
   current_info_ :=  current_info_ || Client_SYS.Get_All_Info;
   App_Context_SYS.Set_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_', current_info_);

   quote_rec_ := ORDER_QUOTATION_API.Get(newrec_.quotation_no);
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(quote_rec_.customer_no);
   sales_part_rec_ := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);

   multiple_tax_lines_  := Client_SYS.Get_Item_Value('MULTIPLE_TAX_LINES', attr_);
   IF (newrec_.line_item_no <= 0) THEN
      IF ((newrec_.tax_code IS NULL) AND (newrec_.tax_calc_structure_id IS NULL) 
         AND (multiple_tax_lines_ IS NOT NULL) AND (multiple_tax_lines_ = 'FALSE')) THEN

         tax_item_removed_ := 'TRUE';

         Source_Tax_Item_Order_API.Remove_Tax_Items(newrec_.company, 
                                                   Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                   newrec_.quotation_no, 
                                                   newrec_.line_no, 
                                                   newrec_.rel_no, 
                                                   TO_CHAR(newrec_.line_item_no),
                                                   '*');
         Tax_Handling_Util_API.Validate_Tax_Code_Mandatory(newrec_.company, 'CUSTOMER_TAX');      
      END IF;
   END IF;
   Sales_Weight_Volume_Util_API.Get_Total_Weight_Volume(total_net_weight_ => newrec_.line_total_weight,
                                                        total_gross_weight_ =>  temp_line_total_weight_gross_,
                                                        total_volume_ => newrec_.line_total_qty,
                                                        adjusted_net_weight_ => newrec_.adjusted_weight_net,
                                                        adjusted_gross_weight_ => newrec_.adjusted_weight_gross,
                                                        adjusted_volume_ => newrec_.adjusted_volume,
                                                        contract_ => newrec_.contract,
                                                        catalog_no_ => newrec_.catalog_no,
                                                        part_no_ => sales_part_rec_.part_no,
                                                        buy_qty_due_ => newrec_.buy_qty_due,
                                                        configuration_id_ => newrec_.configuration_id,
                                                        input_unit_meas_ => NULL,
                                                        input_qty_ => NULL);

   qty_refreshed_ := (NVL(Client_SYS.Get_Item_Value('QTY_REFRESHED', attr_), 0));
   price_source_refreshed_ := (NVL(Client_SYS.Get_Item_Value('PRICE_SOURCE_REFRESHED', attr_), 0));
   refresh_config_price_ := (NVL(Client_SYS.Get_Item_Value('REFRESH_CONFIG_PRICE', attr_), 0));
   tax_code_changed_ := NVL(Client_SYS.Get_Item_Value('TAX_CODE_CHANGED', attr_), 'FALSE');
   
   -- For rental lines, the rental chargeable days retreived from the rental atrributes
   -- because rental object is updated after order quotation line.
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN      
      new_rental_chargeable_days_ := Get_Latest_Rent_Charge_Days___(attr_, newrec_);
      old_rental_chargeable_days_ := Get_Rental_Chargeable_Days___(newrec_.quotation_no, 
                                                                   newrec_.line_no, 
                                                                   newrec_.rel_no, 
                                                                   newrec_.line_item_no);
   END IF;
   
   IF (customer_category_ = Customer_Category_API.DB_CUSTOMER) THEN
      IF ((newrec_.customer_part_no IS NULL) OR
          (NOT (newrec_.catalog_no = Sales_Part_Cross_Reference_API.Get_Catalog_No(newrec_.customer_no, newrec_.contract, newrec_.customer_part_no)))) THEN
         newrec_.customer_part_no := NULL;
         newrec_.customer_part_conv_factor := NULL;
         newrec_.customer_part_unit_meas := NULL;
         newrec_.customer_part_buy_qty := NULL;
         newrec_.cust_part_invert_conv_fact := NULL;

         Client_SYS.Set_Item_Value('CUSTOMER_PART_NO', newrec_.customer_part_no, attr_);
         Client_SYS.Set_Item_Value('CUSTOMER_PART_CONV_FACTOR', newrec_.customer_part_conv_factor, attr_);
         Client_SYS.Set_Item_Value('CUSTOMER_PART_UNIT_MEAS', newrec_.customer_part_unit_meas, attr_);
         Client_SYS.Set_Item_Value('CUSTOMER_PART_BUY_QTY', newrec_.customer_part_buy_qty, attr_);
         Client_SYS.Set_Item_Value('CUST_PART_INVERT_CONV_FACT', newrec_.cust_part_invert_conv_fact, attr_);
      END IF;
   END IF;

   IF (newrec_.rowstate != 'Cancelled') THEN
      IF (newrec_.line_item_no <= 0) THEN
         IF (newrec_.order_supply_type = 'PKG') THEN
            block_component_info_ := TRUE;
            Update_Package___(newrec_.promised_delivery_date, newrec_.planned_delivery_date, newrec_.planned_due_date, newrec_, block_component_info_);
            block_component_info_ := FALSE;
         END IF;
      END IF;
   END IF;

   IF sales_part_rec_.minimum_qty IS NOT NULL AND newrec_.buy_qty_due != oldrec_.buy_qty_due THEN
      IF sales_part_rec_.minimum_qty > newrec_.buy_qty_due THEN
         Client_SYS.Add_Info(lu_name_, 'LTMINIMUMQTY: The minimum quantity when ordering Sales Part No :P1 is :P2 :P3.', newrec_.catalog_no, sales_part_rec_.minimum_qty, newrec_.sales_unit_measure);
      END IF;
   END IF;

   -- Get if non default add lines should be chaged to the header's address
   IF Client_SYS.Item_Exist('COPY_ADDR_TO_LINE', attr_) THEN 
      copy_addr_to_line_ := Client_SYS.Get_Item_Value('COPY_ADDR_TO_LINE', attr_); 
   END IF; 
   
   -- Single Occurrence Address
   IF (newrec_.line_item_no <= 0) THEN
      newrec_.default_addr_flag := Check_Default_Addr_Flag__(newrec_, newrec_.quotation_no, newrec_.default_addr_flag);
   
      IF (newrec_.default_addr_flag = 'N') THEN
         -- Default Info is unchecked.
         IF copy_addr_to_line_ = 'TRUE' AND newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE THEN
            --copy from header if the user selects to copy address reagrdless of default info
            --single occurrence address to single occurrence address OR delivery address to single occurrence address
            Copy_Singl_Occ_Addr_To_Line___(newrec_, quote_rec_);
         END IF;
         IF ((newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_FALSE) AND (oldrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE)) THEN
            -- Remove old single occurrence address, ShipAddrNo is used as address source.
            Remove_Single_Occ_Addr_Line___(newrec_);
         
         ELSIF (newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE AND oldrec_.default_addr_flag = 'Y') THEN
            -- Default Info flag is changed from checked to unchecked.
            -- Copy single occurrence address from the quotation.
            IF (Is_Single_Occ_Addr_Empty___(newrec_)) THEN
               Copy_Singl_Occ_Addr_To_Line___(newrec_, quote_rec_);
            END IF;
         END IF;
      ELSE
         -- Remove address
         Remove_Single_Occ_Addr_Line___(newrec_);
      END IF;
   END IF;   
   
   -- Recalculate sale_unit_price and base_sale_unit_price
   IF (newrec_.line_item_no <= 0) THEN
      IF (newrec_.price_freeze = 'FREE') AND (NVL(newrec_.char_price,0) != NVL(oldrec_.char_price,0)) THEN
         IF (quote_rec_.use_price_incl_tax = 'TRUE') THEN
            newrec_.unit_price_incl_tax := newrec_.part_price + NVL(newrec_.char_price, 0);
            IF (newrec_.unit_price_incl_tax != oldrec_.unit_price_incl_tax) THEN
               Customer_Order_Pricing_API.Get_Base_Price_In_Currency(newrec_.base_unit_price_incl_tax, newrec_.currency_rate,
                                                                     NVL(quote_rec_.customer_no_pay, newrec_.customer_no),
                                                                     newrec_.contract,
                                                                     quote_rec_.currency_code,
                                                                     newrec_.unit_price_incl_tax);
            END IF;
         ELSE
            newrec_.sale_unit_price := newrec_.part_price + NVL(newrec_.char_price, 0);
            IF (newrec_.sale_unit_price != oldrec_.sale_unit_price) THEN
               Customer_Order_Pricing_API.Get_Base_Price_In_Currency(newrec_.base_sale_unit_price, newrec_.currency_rate,
                                                                     NVL(quote_rec_.customer_no_pay, newrec_.customer_no),
                                                                     newrec_.contract,
                                                                     quote_rec_.currency_code,
                                                                     newrec_.sale_unit_price);
            END IF;
         END IF;
         Calculate_Prices___(newrec_);
         Client_SYS.Add_To_Attr('SALE_UNIT_PRICE', newrec_.sale_unit_price, attr_);
         Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE', newrec_.base_sale_unit_price, attr_);
         Client_SYS.Add_To_Attr('UNIT_PRICE_INCL_TAX', newrec_.unit_price_incl_tax, attr_);
         Client_SYS.Add_To_Attr('BASE_UNIT_PRICE_INCL_TAX', newrec_.base_unit_price_incl_tax, attr_);
      END IF;
   END IF;
   
   IF (Order_Quotation_API.Get_Tax_Liability_Type_Db(quote_rec_.quotation_no) != 'EXM') THEN
      IF(newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE) THEN      
         IF(newrec_.tax_class_id IS NOT NULL)THEN
            Client_SYS.Set_Item_Value('TAX_CODE', newrec_.tax_code, attr_);
         ELSE
            tax_code_ := Get_Tax_Code(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
            Client_SYS.Set_Item_Value('TAX_CODE', tax_code_, attr_);
            newrec_.tax_code := tax_code_;
         END IF;     
      END IF;
   END IF;
   
   IF ((oldrec_.buy_qty_due != newrec_.buy_qty_due) AND (quote_rec_.b2b_order = 'TRUE')) THEN
      newrec_.desired_qty :=  newrec_.buy_qty_due;
   END IF;
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF by_keys_ THEN
      Get_Id_Version_By_Keys___(rowid_, objversion_, newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   ELSE
      rowid_ := objid_;
   END IF;      
   Order_Config_Util_API.Update_Configuration__ ('CUSTOMERQUOTE', newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
                                                 oldrec_.configuration_id, newrec_.configuration_id, newrec_.ctp_planned, null);
   newrec_.rowversion := sysdate;
   
   IF (newrec_.buy_qty_due != 0) THEN   
      IF (Client_Sys.Item_Exist('DISCOUNT_LINE_COUNT', attr_) OR (newrec_.discount = 0 AND (oldrec_.discount != newrec_.discount))) THEN
         discount_line_count_ := Client_SYS.Get_Item_Value('DISCOUNT_LINE_COUNT', attr_);
         -- gelr:disc_price_rounded, begin
         IF (discounted_price_rounded_) THEN
            newrec_.discount := newrec_.original_discount;   
         END IF;
         -- gelr:disc_price_rounded, end         
         Order_quote_Line_Discount_API.Add_Remove_Update_Line(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, newrec_.discount, discount_line_count_, newrec_.contract);
         -- gelr:disc_price_rounded:DIS005, begin
         IF (discounted_price_rounded_) THEN
            IF Client_SYS.Item_Exist('DISCOUNT_LINE_COUNT', attr_) THEN
               -- we need to calculate discounts again to set original_discount
               Order_Quote_Line_Discount_API.Calc_Discount_Upd_Oq_Line__(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, update_tax_ => 'FALSE');
               newrec_.discount := Get_Discount(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
               newrec_.original_discount := Get_Original_Discount(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
            END IF;
         END IF;
         -- gelr:disc_price_rounded:DIS005, end         
      END IF;   
   END IF;
      
   IF (Client_SYS.Get_Item_Value('UPDATED_FROM_WIZARD', attr_) = 'TRUE') THEN
      updated_from_wizard_ := TRUE;      
   END IF;

   -- gelr:disc_price_rounded:DIS005, begin
   -- Recalculate additional_discount and quotation_discount to achive net value the same as rounded price
   -- All of this variables affects net value, therefore all of this can affect recalculated additional_discount and quotation_discount
   IF (discounted_price_rounded_) THEN
      IF ((newrec_.buy_qty_due != oldrec_.buy_qty_due) OR
          (newrec_.base_sale_unit_price != oldrec_.base_sale_unit_price) OR
          (newrec_.quotation_discount != oldrec_.quotation_discount) OR
          (newrec_.additional_discount != oldrec_.additional_discount) OR
          (newrec_.discount != oldrec_.discount)) THEN

         -- 1. additional_discount
         -- user/system operates on additional_discount but it is saved in technical column: original_add_discount
         -- I must initialize original_ column which is now empty
         IF (newrec_.additional_discount != oldrec_.additional_discount) THEN
            newrec_.original_add_discount := newrec_.additional_discount;
         ELSE
            -- the reason of recalculation was NOT changing of additional_discount but the other variable
            newrec_.original_add_discount := oldrec_.original_add_discount;
         END IF;
         Trace_SYS.Message('additional_discount before recalculation' || newrec_.additional_discount);
         newrec_.additional_discount := Customer_Order_Pricing_API.Calculate_Additional_Discount(newrec_.contract,
                                                                                              Order_Quotation_API.Get_Currency_Code(newrec_.quotation_no),
                                                                                              newrec_.original_add_discount,
                                                                                              newrec_.buy_qty_due,
                                                                                              newrec_.price_conv_factor,
                                                                                              newrec_.sale_unit_price,
                                                                                              newrec_.discount);
         -- 2. quotation_discount
         -- Read the comment upper
         IF (newrec_.quotation_discount != oldrec_.quotation_discount) THEN
            newrec_.original_quotation_discount := newrec_.quotation_discount;
         ELSE
            newrec_.quotation_discount := oldrec_.quotation_discount;
         END IF;
         newrec_.quotation_discount := Customer_Order_Pricing_API.Calculate_Additional_Discount(newrec_.contract,
                                                                                             Order_Quotation_API.Get_Currency_Code(newrec_.quotation_no),
                                                                                             newrec_.original_quotation_discount,
                                                                                             newrec_.buy_qty_due,
                                                                                             newrec_.price_conv_factor,
                                                                                             newrec_.sale_unit_price,
                                                                                             newrec_.discount);

         Update_Line___(rowid_, oldrec_, newrec_, TRUE, FALSE);
      END IF;
   END IF;
   -- discount and original_discount are handle in diffrent way in Modify_Discount__()
   -- they both comes from cust_order_line_discount_tab.
   -- Sometimes discount is not changed (because it comes from rounded price) but original should be.
   -- gelr:disc_price_rounded:DIS005, end
      
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         IF (Rental_Object_API.Is_Rental_Dates_Changed(newrec_.quotation_no, 
                                                       newrec_.line_no, 
                                                       newrec_.rel_no, 
                                                       newrec_.line_item_no, 
                                                       Rental_Type_API.DB_ORDER_QUOTATION, 
                                                       attr_)) OR (old_rental_chargeable_days_ != new_rental_chargeable_days_) THEN
            is_rental_modified_ := TRUE;
         END IF;         
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');                                
      $END      
   END IF;
  
   IF (Client_SYS.Get_Item_Value('UPDATED_FROM_CREATE_ORDER', attr_) = 'TRUE') THEN
      updated_from_create_order_ := TRUE;      
   END IF;

   Check_Important_Fields___(oldrec_, newrec_, TRUE, updated_from_wizard_, updated_from_create_order_, is_rental_modified_);
   -- Update_Line___(rowid_, oldrec_, newrec_, TRUE, updated_from_wizard_);
   -- Upto this level in the code, adding line history records is handled by Check_Important_Fields___. In the latter part of the code
   -- it will be handled inside Update_Line___.
   changedrec_ := newrec_;

   IF (newrec_.buy_qty_due = 0) THEN
      FOR discount_rec_  IN  get_disc_no(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) LOOP
         Order_Quote_Line_Discount_API.Remove_Discount_Row(newrec_.quotation_no, newrec_.line_no,
                                                           newrec_.rel_no,
                                                           newrec_.line_item_no,
                                                           discount_rec_.discount_no);
      END LOOP;
   END IF;

   IF (newrec_.line_item_no > 0) THEN
      linerec_ := Get_Object_By_Keys___(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, -1);
      oldlinerec_ := linerec_;
      IF (newrec_.cost != oldrec_.cost) OR (newrec_.buy_qty_due != oldrec_.buy_qty_due) OR (NVL(tax_code_changed_, 'FALSE') = 'TRUE')THEN
         IF (newrec_.cost != oldrec_.cost) OR (newrec_.buy_qty_due != oldrec_.buy_qty_due) THEN
            Update_Package_Cost___(linerec_.cost, newrec_.quotation_no, newrec_.line_no, newrec_.rel_no);
         END IF;
         IF (newrec_.buy_qty_due != oldrec_.buy_qty_due) THEN
            do_qty_ := TRUE;
         END IF;
         Change_Package_Structure___(linerec_.promised_delivery_date, linerec_.planned_delivery_date,
                                     linerec_.planned_due_date, linerec_,
                                     do_qty_, TRUE, FALSE, TRUE, FALSE, TRUE, block_component_info_);
         pkg_changed_ := TRUE;
      END IF;
      IF (NVL(newrec_.calc_char_price, 0) != NVL(oldrec_.calc_char_price, 0))
         OR (NVL(newrec_.char_price, 0) != NVL(oldrec_.char_price, 0))
      THEN
         linerec_.calc_char_price := 0;
         linerec_.char_price := 0;
         pkg_changed_ := TRUE;
      END IF;
      IF pkg_changed_ THEN
         Get_Id_Version_By_Keys___(pack_line_rowid_, rowversion_, newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, -1);
         linerec_.rowversion := sysdate;
         Update_Line___(pack_line_rowid_, oldlinerec_, linerec_, TRUE, updated_from_wizard_, updated_from_create_order_);
      END IF;
   END IF;
   
   IF ((newrec_.buy_qty_due != oldrec_.buy_qty_due) OR (NVL(newrec_.price_list_no, '0') != NVL(oldrec_.price_list_no, '0')) OR
      (qty_refreshed_ = 1) OR (price_source_refreshed_ = 1) OR (refresh_config_price_ = 1)) THEN
      IF (newrec_.configuration_id != '*') AND (newrec_.line_item_no <= 0) THEN
         Configured_Line_Price_API.Modify_Config_Line_Price (newrec_.char_price,newrec_.calc_char_price,newrec_.configuration_id,newrec_.configured_line_price_id,newrec_.catalog_no);
         IF (newrec_.price_freeze = 'FREE') THEN
            IF (newrec_.sale_unit_price != oldrec_.sale_unit_price) OR (newrec_.unit_price_incl_tax != oldrec_.unit_price_incl_tax) OR (refresh_config_price_ = 1) THEN                         
               IF (refresh_config_price_ = 1) THEN
                  IF (quote_rec_.use_price_incl_tax = 'TRUE') THEN
                     newrec_.unit_price_incl_tax := newrec_.part_price + NVL(newrec_.char_price, 0);
                     Customer_Order_Pricing_API.Get_Base_Price_In_Currency(newrec_.base_unit_price_incl_tax,
                                                                           newrec_.currency_rate,
                                                                           NVL(quote_rec_.customer_no_pay, newrec_.customer_no),
                                                                           newrec_.contract,
                                                                           quote_rec_.currency_code,
                                                                           newrec_.unit_price_incl_tax);
                  ELSE
                     newrec_.sale_unit_price := newrec_.part_price + NVL(newrec_.char_price, 0);
                     Customer_Order_Pricing_API.Get_Base_Price_In_Currency(newrec_.base_sale_unit_price,
                                                                           newrec_.currency_rate,
                                                                           NVL(quote_rec_.customer_no_pay, newrec_.customer_no),
                                                                           newrec_.contract,
                                                                           quote_rec_.currency_code,
                                                                           newrec_.sale_unit_price);
                  END IF;                 
               ELSE
                  IF (quote_rec_.use_price_incl_tax = 'TRUE') THEN
                     Customer_Order_Pricing_API.Get_Base_Price_In_Currency(newrec_.base_unit_price_incl_tax,
                                                                           newrec_.currency_rate,
                                                                           NVL(quote_rec_.customer_no_pay, newrec_.customer_no),
                                                                           newrec_.contract,
                                                                           quote_rec_.currency_code,
                                                                           newrec_.unit_price_incl_tax);
                  ELSE
                     Customer_Order_Pricing_API.Get_Base_Price_In_Currency(newrec_.base_sale_unit_price,
                                                                           newrec_.currency_rate,
                                                                           NVL(quote_rec_.customer_no_pay, newrec_.customer_no),
                                                                           newrec_.contract,
                                                                           quote_rec_.currency_code,
                                                                           newrec_.sale_unit_price);
                  END IF;
               END IF;
               Calculate_Prices___(newrec_);
               Client_SYS.Set_Item_Value('SALE_UNIT_PRICE', newrec_.sale_unit_price, attr_);
               Client_SYS.Set_Item_Value('BASE_SALE_UNIT_PRICE', newrec_.base_sale_unit_price, attr_);
               Client_SYS.Set_Item_Value('UNIT_PRICE_INCL_TAX', newrec_.unit_price_incl_tax, attr_);
               Client_SYS.Set_Item_Value('BASE_UNIT_PRICE_INCL_TAX', newrec_.base_unit_price_incl_tax, attr_);
            END IF;
         END IF;
         Client_SYS.Set_Item_Value('CHAR_PRICE', newrec_.char_price, attr_);
         Client_SYS.Set_Item_Value('CALC_CHAR_PRICE', newrec_.calc_char_price, attr_);
         newrec_.rowversion:= sysdate;
         Update_Line___(rowid_, changedrec_, newrec_, TRUE, FALSE, updated_from_create_order_);
         changedrec_ := newrec_;
      END IF;
   END IF;

   IF (newrec_.price_source_net_price = 'FALSE') THEN
      pack_size_chg_line_quot_no_ := Order_Quotation_Charge_API.Get_Pack_Size_Chg_Line_Quot_No(newrec_.quotation_no, 
                                                                                               newrec_.line_no, newrec_.rel_no, 
                                                                                               newrec_.line_item_no);
   END IF;

   Update_Freight_Free(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   
   -- Update the rental object details if istalled.
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN                                
      Modify_Rental___( attr_, newrec_);
   END IF;   
   
   -- Tax lines !!!
   IF (newrec_.line_item_no <= 0) THEN
      tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);
      -- gelr:br_external_tax_integration, begin
      IF (tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN
         -- Avalara Brazil only supports Customer Order lines and Invoice lines in initial release
         tax_method_ := External_Tax_Calc_Method_API.DB_NOT_USED;
      END IF;
      -- gelr:br_external_tax_integration, end
      
      -- When Avalara sales tax is used taxes are fetched as bundle calls when possible. Then in attr UPDATE_TAX is set as FALSE
      IF tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX THEN 
         fetch_external_tax_ := NVL(Client_SYS.Get_Item_Value('UPDATE_TAX', attr_), 'TRUE');
      END IF;
      
      IF (NVL(Client_SYS.Get_Item_Value('SINGLE_OCC_ADDR_CHANGED', attr_), Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_TRUE) THEN
         single_occ_addr_changed_ := TRUE;
      END IF;
      -- consider the situation where tax liability type, ship_addr_no or customer_no is changed
      newrec_.free_of_charge_tax_basis := NVL(Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('FREE_OF_CHARGE_TAX_BASIS', attr_)), newrec_.free_of_charge_tax_basis);
      
      IF ((NVL(newrec_.ship_addr_no, Database_SYS.String_Null_) != NVL(oldrec_.ship_addr_no, Database_SYS.String_Null_)) OR
          (NVL(newrec_.customer_no, Database_SYS.String_Null_) != NVL(oldrec_.customer_no, Database_SYS.String_Null_)) OR
          (newrec_.tax_liability_type != oldrec_.tax_liability_type) OR
          (NVL(newrec_.ship_addr_country_code, Database_SYS.String_Null_) != NVL(oldrec_.ship_addr_country_code, Database_SYS.string_null_)) OR
          (single_occ_addr_changed_ AND newrec_.default_addr_flag = 'Y') OR
          ((newrec_.single_occ_addr_flag != oldrec_.single_occ_addr_flag) AND (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED)) OR
          (NVL(newrec_.tax_code,Database_SYS.string_null_) != NVL(oldrec_.tax_code,Database_SYS.string_null_)) OR
          (NVL(newrec_.tax_calc_structure_id, Database_SYS.string_null_) != NVL(oldrec_.tax_calc_structure_id, Database_SYS.string_null_)) OR          
          (NVL(newrec_.free_of_charge_tax_basis, 0) != NVL(oldrec_.free_of_charge_tax_basis, 0)) OR
          ((NVL(Client_SYS.Get_Item_Value('SUPPLY_COUNTRY_CHANGED', attr_),'FALSE')) = 'TRUE') OR
          ((newrec_.single_occ_addr_flag != oldrec_.single_occ_addr_flag OR Validate_SYS.Is_Changed(newrec_.planned_due_date, oldrec_.planned_due_date)) AND (tax_method_ = External_Tax_Calc_Method_API.DB_NOT_USED) AND (newrec_.tax_class_id IS NOT NULL)) OR
          (newrec_.default_addr_flag = 'N' AND copy_addr_to_line_ = 'TRUE' AND tax_method_ = External_Tax_Calc_Method_API.DB_NOT_USED)) THEN
         
         IF fetch_external_tax_ = 'TRUE' THEN
            Order_Quotation_Charge_API.Add_Transaction_Tax_Info(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
         END IF;
         
         IF ((((NVL(Client_SYS.Get_Item_Value('SUPPLY_COUNTRY_CHANGED', attr_),'FALSE')) = 'TRUE') OR
              (NVL(newrec_.ship_addr_no, Database_SYS.String_Null_) != NVL(oldrec_.ship_addr_no, Database_SYS.String_Null_)) OR
              (NVL(newrec_.customer_no, Database_SYS.String_Null_) != NVL(oldrec_.customer_no, Database_SYS.String_Null_)) OR
              (newrec_.tax_liability_type != oldrec_.tax_liability_type) OR
              (single_occ_addr_changed_ AND newrec_.default_addr_flag = 'Y') OR
              ((newrec_.single_occ_addr_flag != oldrec_.single_occ_addr_flag) AND (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED)) OR
              (NVL(newrec_.ship_addr_country_code, Database_SYS.String_Null_) != NVL(oldrec_.ship_addr_country_code, Database_SYS.string_null_))
             ) AND nvl(Client_SYS.Get_Item_Value('FETCH_TAX_FROM_DEFAULTS', attr_), 'TRUE') = 'TRUE' OR
             ((newrec_.single_occ_addr_flag != oldrec_.single_occ_addr_flag OR Validate_SYS.Is_Changed(newrec_.planned_due_date, oldrec_.planned_due_date)) AND (tax_method_ = External_Tax_Calc_Method_API.DB_NOT_USED) AND (newrec_.tax_class_id IS NOT NULL))) THEN
            tax_from_defaults_ := TRUE;
         END IF;
         
         IF (quote_rec_.use_price_incl_tax = Fnd_Boolean_API.DB_FALSE) THEN
            unit_price_            := newrec_.sale_unit_price;
         ELSE
            unit_price_            := newrec_.unit_price_incl_tax;
         END IF;
         
         -- Update discount calculation basis before recalculate tax.
         Order_Quote_Line_Discount_API.Calculate_Discount__(dummy_total_disc_pct_, dummy_total_disc_amt_, 
                                                          newrec_.quotation_no, newrec_.line_no, 
                                                          newrec_.rel_no, newrec_.line_item_no,
                                                          unit_price_, newrec_.buy_qty_due,
                                                          newrec_.price_conv_factor, 'TRUE' );
         
         IF (tax_item_removed_ != 'TRUE' AND fetch_external_tax_ = 'TRUE') THEN
            Add_Transaction_Tax_Info___(newrec_,
                                        quote_rec_.company,
                                        quote_rec_.supply_country,
                                        quote_rec_.use_price_incl_tax,
                                        quote_rec_.currency_code,
                                        tax_from_defaults_,
                                        attr_    => NULL);
         END IF;
      -- If any of the attributes affecting the total line amount have been changed then
      -- tax lines connected to the quotation line will have to be recalculated
      -- since the tax amount may have to be updated
      ELSIF ((newrec_.buy_qty_due != oldrec_.buy_qty_due) OR
             (newrec_.base_sale_unit_price != oldrec_.base_sale_unit_price AND quote_rec_.use_price_incl_tax = 'FALSE' ) OR
             (newrec_.base_unit_price_incl_tax != oldrec_.base_unit_price_incl_tax AND  quote_rec_.use_price_incl_tax = 'TRUE') OR
             (newrec_.quotation_discount  != oldrec_.quotation_discount ) OR (newrec_.additional_discount != oldrec_.additional_discount) OR
             (NVL(newrec_.customer_tax_usage_type,' ') != NVL(oldrec_.customer_tax_usage_type,' ')) OR
             (newrec_.discount != oldrec_.discount) OR (newrec_.rental = Fnd_Boolean_API.DB_TRUE AND new_rental_chargeable_days_ != old_rental_chargeable_days_)) THEN
             
         IF (quote_rec_.use_price_incl_tax = Fnd_Boolean_API.DB_FALSE) THEN
            unit_price_            := newrec_.sale_unit_price;
         ELSE
            unit_price_            := newrec_.unit_price_incl_tax;
         END IF;
         
         -- Update discount calculation basis before recalculate tax.
         Order_Quote_Line_Discount_API.Calculate_Discount__(dummy_total_disc_pct_, dummy_total_disc_amt_, 
                                                          newrec_.quotation_no, newrec_.line_no, 
                                                          newrec_.rel_no, newrec_.line_item_no,
                                                          unit_price_, newrec_.buy_qty_due,
                                                          newrec_.price_conv_factor, 'TRUE' );
                                                          
         IF (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
            
            tax_from_defaults_ := TRUE;
            IF fetch_external_tax_ = 'TRUE' THEN 
               Add_Transaction_Tax_Info___(newrec_,
                                           quote_rec_.company,
                                           quote_rec_.supply_country,
                                           quote_rec_.use_price_incl_tax,
                                           quote_rec_.currency_code,
                                           tax_from_defaults_,
                                           attr_    => NULL);
            END IF;
         ELSE
            tax_from_defaults_ := FALSE;
            Recalculate_Tax_Lines___(newrec_,                                  
                                  quote_rec_.company,                                  
                                  quote_rec_.customer_no,
                                  quote_rec_.ship_addr_no,
                                  quote_rec_.supply_country,
                                  quote_rec_.use_price_incl_tax,
                                  quote_rec_.currency_code,
                                  tax_from_defaults_,
                                  NULL);
         END IF;
          
         Order_Quotation_Charge_API.Recalc_Percentage_Charge_Taxes(newrec_.quotation_no, newrec_.line_no, tax_from_defaults_);
      END IF;

      Client_SYS.Set_Item_Value('DEFAULT_ADDR_FLAG_DB', newrec_.default_addr_flag, attr_);
      Client_SYS.Set_Item_Value('SHIP_ADDR_NO', newrec_.ship_addr_no, attr_);
      Client_SYS.Set_Item_Value('SHIP_VIA_CODE', newrec_.ship_via_code, attr_);
      Client_SYS.Set_Item_Value('EXT_TRANSPORT_CALENDAR_ID', newrec_.ext_transport_calendar_id, attr_);
      Client_SYS.Set_Item_Value('DELIVERY_TERMS', newrec_.delivery_terms, attr_);
      Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', newrec_.del_terms_location, attr_);
      Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', newrec_.delivery_leadtime, attr_);
      Client_SYS.Set_Item_Value('TAX_LIABILITY', newrec_.tax_liability, attr_);
      Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', newrec_.forward_agent_id, attr_);
      Client_SYS.Set_Item_Value('PICKING_LEADTIME', newrec_.picking_leadtime, attr_);
      Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', newrec_.tax_liability_type, attr_);
      
      IF (NVL(tax_code_changed_, 'FALSE') = 'TRUE') THEN
         Calculate_Prices___(newrec_);
         Client_SYS.Set_Item_Value('SALE_UNIT_PRICE',          newrec_.sale_unit_price,          attr_);
         Client_SYS.Set_Item_Value('BASE_SALE_UNIT_PRICE',     newrec_.base_sale_unit_price,     attr_);
         Client_SYS.Set_Item_Value('UNIT_PRICE_INCL_TAX',      newrec_.unit_price_incl_tax,      attr_);
         Client_SYS.Set_Item_Value('BASE_UNIT_PRICE_INCL_TAX', newrec_.base_unit_price_incl_tax, attr_);
         newrec_.rowversion:= sysdate;
         Update_Line___(rowid_, changedrec_, newrec_, TRUE, FALSE, updated_from_create_order_);
      END IF;
   END IF;
   
   IF (price_source_refreshed_ = 1) THEN
      discount_ := Order_Quote_Line_Discount_API.Calculate_Discount__(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
      Modify_Discount__(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, discount_);
   END IF;
     
   exist_chg_on_quot_line_ := Order_Quotation_Charge_API.Exist_Charge_On_Quot_Line(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   IF (exist_chg_on_quot_line_ = 1) THEN
      Customer_Order_Charge_Util_API.Modify_Quotation_Charge_Line(newrec_, oldrec_, NVL(tax_code_changed_, 'FALSE'));
   ELSIF (newrec_.input_unit_meas IS NOT NULL AND oldrec_.input_unit_meas IS NULL) OR
         (newrec_.buy_qty_due != oldrec_.buy_qty_due) OR
         (newrec_.freight_map_id IS NOT NULL AND (NVL(oldrec_.freight_map_id, ' ') != newrec_.freight_map_id)) OR
         (newrec_.zone_id IS NOT NULL AND (NVL(oldrec_.zone_id, ' ') != newrec_.zone_id)) THEN
      Customer_Order_Charge_Util_API.New_Quotation_Charge_Line(newrec_);
   END IF;
   
   discount_freeze_db_ := Site_Discom_Info_API.Get_Discount_Freeze_Db(quote_rec_.contract);
   
   -- Moved discount calculation logic after Tax calculation logic. When price including tax is specified, final tax amount is used for discount calculations.
   IF (newrec_.buy_qty_due != oldrec_.buy_qty_due) OR (newrec_.sales_unit_measure != oldrec_.sales_unit_measure) OR
      (newrec_.sale_unit_price != oldrec_.sale_unit_price) OR (newrec_.base_sale_unit_price != oldrec_.base_sale_unit_price) OR
      (newrec_.unit_price_incl_tax != oldrec_.unit_price_incl_tax) OR (newrec_.base_unit_price_incl_tax != oldrec_.base_unit_price_incl_tax) OR
      (newrec_.quotation_discount != oldrec_.quotation_discount) OR (newrec_.price_conv_factor != oldrec_.price_conv_factor) OR
      (newrec_.discount != oldrec_.discount) THEN
      -- Recalculation of dicount must be made.      
      ORDER_QUOTATION_API.Modify_Calc_Disc_Flag(newrec_.quotation_no, 'TRUE');      
   END IF;
   
   IF ((oldrec_.customer_no != newrec_.customer_no) AND (Customer_Info_API.Get_Customer_Category_Db(oldrec_.customer_no) = Customer_Category_API.DB_CUSTOMER) AND 
      (Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no) = Customer_Category_API.DB_CUSTOMER)) THEN
       -- Note: If customer has been changed and both new and old customers are of category 'CUSTOMER', 
       -- price should be recalculated irrespective of freeze flag values.
       clear_manual_discount_ := 'TRUE';  
   END IF;
   
	-- Default Discount !!
   IF (newrec_.buy_qty_due != 0) AND (newrec_.price_source != 'PRICE BREAKS') THEN
      --  Added check on qty_refreshed_ and price_source_refreshed_.
      IF (newrec_.buy_qty_due != oldrec_.buy_qty_due) OR
         (NVL(newrec_.price_list_no, '0') != NVL(oldrec_.price_list_no, '0')) OR
         (qty_refreshed_ = 1) OR (price_source_refreshed_ = 1) OR (newrec_.price_source != oldrec_.price_source) OR
         (oldrec_.customer_no != newrec_.customer_no) THEN
         current_info_temp_ := current_info_temp_ || Client_SYS.Get_All_Info;
         IF (NOT(newrec_.price_freeze = 'FROZEN' AND discount_freeze_db_ = 'TRUE') OR (clear_manual_discount_ = 'TRUE')) THEN
             Customer_Order_Pricing_API.Modify_Default_Qdiscount_Rec(newrec_.quotation_no,
                                                                     newrec_.line_no,
                                                                     newrec_.rel_no,
                                                                     newrec_.line_item_no,
                                                                     newrec_.contract,
                                                                     newrec_.customer_no,
                                                                     quote_rec_.currency_code,
                                                                     quote_rec_.agreement_id,
                                                                     newrec_.catalog_no,
                                                                     newrec_.buy_qty_due,
                                                                     newrec_.price_list_no,
                                                                     quote_rec_.price_effectivity_date,
                                                                     newrec_.customer_level,
                                                                     newrec_.customer_level_id,
                                                                     new_rental_chargeable_days_,
                                                                     clear_manual_discount_);
         END IF;
      END IF;
   END IF;
   
   IF (newrec_.discount = oldrec_.discount) THEN
      -- Added the price lists for the existing condition
      IF ((newrec_.sale_unit_price != oldrec_.sale_unit_price) OR
          (newrec_.unit_price_incl_tax != oldrec_.unit_price_incl_tax) OR
          (newrec_.price_list_no IS NULL AND oldrec_.price_list_no IS NOT NULL)) THEN
         discount_ := Order_Quote_Line_Discount_API.Calculate_Discount__(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
         
         -- SCXTEND-1515, Added the condition to prevent overrding the existing discount value if the fetched value is zero.
         IF discount_ != 0 THEN
            Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
            Modify_Discount__(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, discount_);
         END IF;
      END IF;
   END IF;

   IF newrec_.rowstate IN ('Released', 'Revised', 'Rejected', 'Won') THEN
      Update_Planning___(oldrec_, newrec_);
   END IF;
   
   Client_SYS.Set_Item_Value('PROMISED_DELIVERY_DATE', newrec_.promised_delivery_date, attr_);
   Client_SYS.Set_Item_Value('PLANNED_DELIVERY_DATE', newrec_.planned_delivery_date, attr_);
   Client_SYS.Set_Item_Value('PLANNED_DUE_DATE', newrec_.planned_due_date, attr_);

   Finite_State_Add_To_Attr___(newrec_, attr_);
   IF quote_rec_.jinsui_invoice ='TRUE' THEN
      Validate_Jinsui_Constraints__(newrec_, 0, FALSE);
   END IF;

   -- Use this for checking if we need to repopulate the form or not !
   SELECT ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) INTO headver_
   FROM ORDER_QUOTATION_TAB
   WHERE quotation_no = newrec_.quotation_no;

   Client_SYS.Add_To_Attr('HEADVER', headver_, attr_ );
   Client_SYS.Add_To_Attr('ORDER_SUPPLY_TYPE_DB', newrec_.order_supply_type, attr_ );
   
   Client_SYS.Set_Item_Value('TAX_CODE', newrec_.tax_code, attr_);
   Client_SYS.Set_Item_Value('TAX_CLASS_ID', newrec_.tax_class_id, attr_);

   IF (NVL(newrec_.planned_delivery_date, Database_Sys.first_calendar_date_) != NVL(oldrec_.planned_delivery_date, Database_Sys.first_calendar_date_)
       OR NVL(newrec_.customer_no, Database_Sys.string_null_) != NVL(oldrec_.customer_no, Database_Sys.string_null_)
         OR NVL(newrec_.ship_addr_no, Database_Sys.string_null_) != NVL(oldrec_.ship_addr_no, Database_Sys.string_null_)) THEN

      IF (NOT (NVL(newrec_.planned_delivery_date, Database_Sys.first_calendar_date_) = NVL(newrec_.wanted_delivery_date, Database_Sys.first_calendar_date_) AND
               NVL(newrec_.wanted_delivery_date, Database_Sys.first_calendar_date_) = NVL(quote_rec_.wanted_delivery_date, Database_Sys.first_calendar_date_)) OR
          NVL(newrec_.customer_no, Database_Sys.string_null_) != NVL(quote_rec_.customer_no, Database_Sys.string_null_) OR
          NVL(newrec_.ship_addr_no, Database_Sys.string_null_) != NVL(quote_rec_.ship_addr_no, Database_Sys.string_null_)) THEN
         IF (newrec_.planned_delivery_date IS NOT NULL AND newrec_.customer_no IS NOT NULL 
             AND newrec_.ship_addr_no IS NOT NULL) THEN
            cust_calendar_id_ := Cust_Ord_Customer_Address_API.Get_Cust_Calendar_Id(newrec_.customer_no, newrec_.ship_addr_no);
            Cust_Ord_Date_Calculation_API.Check_Date_On_Cust_Calendar_(newrec_.customer_no, cust_calendar_id_, newrec_.planned_delivery_date, 'PLANNED');
         END IF;
      END IF;
   END IF;

   IF (NVL(newrec_.ext_transport_calendar_id, Database_Sys.string_null_) != NVL(oldrec_.ext_transport_calendar_id, Database_Sys.string_null_)) THEN
      Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.ext_transport_calendar_id);
   END IF;

   -- Update BO line if CRM is installed.
   Update_Business_Opp_Line___(newrec_, oldrec_);

   current_info_ :=  App_Context_SYS.Find_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_');   current_info_ := current_info_ || current_info_temp_;
   App_Context_SYS.Set_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_', current_info_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN ORDER_QUOTATION_LINE_TAB%ROWTYPE )
IS

BEGIN
   Validate_before_Delete___(remrec_, 'FALSE');

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN ORDER_QUOTATION_LINE_TAB%ROWTYPE )
IS

   CURSOR get_package IS
   SELECT rowid objid
      FROM  ORDER_QUOTATION_LINE_TAB
      WHERE line_item_no > 0
      AND   rel_no = remrec_.rel_no
      AND   line_no = remrec_.line_no
      AND   quotation_no = remrec_.quotation_no;

   linerec_          ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   pack_rec_         ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   pack_attr_        VARCHAR2(32000);
   dummy_            VARCHAR2(2000);
   ctp_run_id_       NUMBER;
   interim_ord_id_   VARCHAR2(12);
BEGIN
   -- Remove package component
   IF (remrec_.order_supply_type = 'PKG') THEN
      FOR pkgrec_ IN get_package LOOP
         linerec_ := Get_Object_By_Id___(pkgrec_.objid);
         Delete___(pkgrec_.objid, linerec_);
      END LOOP;
   END IF;
   interim_ord_id_:= Get_Interim_Order_No(remrec_.quotation_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no, remrec_.ctp_planned);
   -- cancel capability check reservations/allocations
   IF (remrec_.ctp_planned = 'Y' OR (remrec_.ctp_planned = 'N' AND interim_ord_id_ IS NOT NULL)) THEN
      $IF (Component_Ordstr_SYS.INSTALLED) $THEN
          Interim_Ctp_Manager_API.Cancel_Ctp(dummy_, remrec_.quotation_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no, 'CUSTOMERQUOTE', remrec_.order_supply_type);
      $ELSE
         NULL;
      $END   
   END IF;

   -- Remove interim order and configuration specification.
   IF (remrec_.configuration_id != '*' AND remrec_.ctp_planned = 'N') THEN
      $IF (Component_Ordstr_SYS.INSTALLED) $THEN
         Interim_Demand_Head_API.Remove_Interim_Head_By_Usage('CUSTOMERQUOTE', remrec_.quotation_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no);
      $ELSE
         NULL;
      $END    
   END IF;
   
   -- Remove ctp record
   $IF (Component_Ordstr_SYS.INSTALLED) $THEN
      ctp_run_id_ := Interim_Ctp_Critical_Path_API.Get_Ctp_Run_Id('CUSTOMERQUOTE', remrec_.quotation_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no);
      IF (ctp_run_id_ IS NOT NULL AND ctp_run_id_ > 0) THEN
         Interim_Ctp_Critical_Path_API.Clear_Ctp_Data(ctp_run_id_);
      END IF;
   $END
 
   super(objid_, remrec_);

   IF (remrec_.line_item_no <= 0) THEN
      ORDER_QUOTATION_API.Modify_Calc_Disc_Flag(remrec_.quotation_no, 'TRUE');
   END IF;

   -- Remove component part line
   IF ( remrec_.line_item_no > 0 AND
        Get_Objstate( remrec_.quotation_no, remrec_.line_no, remrec_.rel_no, -1 ) = 'Released' ) THEN
        pack_rec_ := Lock_By_Keys___( remrec_.quotation_no, remrec_.line_no, remrec_.rel_no, -1 );
        Finite_State_Machine___( pack_rec_, 'PackageLineChanged', pack_attr_ );
   END IF;
   
   $IF Component_Crm_SYS.INSTALLED $THEN
      IF (remrec_.demand_code = Order_Supply_Type_API.DB_BUSINESS_OPPORTUNITY) THEN
         IF(Business_Opportunity_Line_API.Check_Exist(remrec_.demand_order_ref1, remrec_.demand_order_ref2)) THEN           
            -- Remove BO line
            Business_Opportunity_Line_API.Remove(remrec_.demand_order_ref1, remrec_.demand_order_ref2);                   
         END IF;      
      END IF;   
   $END
   IF (remrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      Remove_Rental___(remrec_);
   END IF;
END Delete___;


@Override
PROCEDURE Unpack___ (
   newrec_   IN OUT NOCOPY order_quotation_line_tab%ROWTYPE,
   indrec_   IN OUT NOCOPY Indicator_Rec,
   attr_     IN OUT NOCOPY VARCHAR2 )
IS   
BEGIN
    IF (newrec_.rowstate IS NULL) THEN
       Pre_Unpack_Insert___(newrec_, attr_);
    ELSE
       Pre_Unpack_Update___(newrec_, attr_);
    END IF;
    super(newrec_, indrec_, attr_);
END Unpack___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     order_quotation_line_tab%ROWTYPE,
   newrec_ IN OUT order_quotation_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.ship_addr_in_city IS NULL) THEN
      newrec_.ship_addr_in_city := 'FALSE';
   END IF;
   
   IF newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE AND newrec_.default_addr_flag = 'N' THEN
      Address_Setup_API.Validate_Address(newrec_.ship_addr_country_code, newrec_.ship_addr_state, newrec_.ship_addr_county, newrec_.ship_addr_city);
   END IF; 
   
   IF (newrec_.free_of_charge IS NULL) THEN
      newrec_.free_of_charge := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (newrec_.free_of_charge = Fnd_Boolean_API.DB_TRUE) THEN
      IF (indrec_.sale_unit_price AND newrec_.sale_unit_price <> 0) OR 
         (indrec_.base_sale_unit_price AND newrec_.base_sale_unit_price <> 0) OR 
         (indrec_.discount AND newrec_.discount <> 0) THEN
         Error_SYS.Record_General(lu_name_, 'CANTCHGPRICE: Price information cannot be modified for free of charge lines.');
      END IF;       
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT order_quotation_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
   quote_rec_              ORDER_QUOTATION_API.Public_Rec;
   header_rowstate_        ORDER_QUOTATION_TAB.rowstate%TYPE;
   assortment_id_          ASSORTMENT_STRUCTURE_TAB.Assortment_id%TYPE;
   customer_category_      CUSTOMER_INFO_TAB.customer_category%TYPE;
   delivery_country_code_  VARCHAR2(2);
   inv_part_rec_           Inventory_Part_API.Public_Rec;
   avl_qty_                NUMBER;
   inv_part_cost_level_db_ VARCHAR2(50);
   supplier_site_          VARCHAR2(5) := NULL;
   zone_info_exist_        VARCHAR2(5) := 'FALSE';
   sales_part_rec_         Sales_Part_API.Public_Rec;
BEGIN  
   quote_rec_         := Order_Quotation_API.Get(newrec_.quotation_no);
   sales_part_rec_    := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);
   
   IF (newrec_.line_no IS NOT NULL) THEN
      IF NOT(Is_Number___(newrec_.line_no)) THEN
         Error_SYS.Record_General(lu_name_, 'NOTANUMBER: Line No and/or Delivery No must have numeric values.');
      END IF;
      newrec_.line_no := FLOOR(newrec_.line_no);
   END IF;
   
   IF (newrec_.rel_no IS NOT NULL) THEN
      IF NOT(Is_Number___(newrec_.rel_no)) THEN
         Error_SYS.Record_General(lu_name_, 'NOTANUMBER: Line No and/or Delivery No must have numeric values.');
      END IF;
      newrec_.rel_no := FLOOR(newrec_.rel_no);
   END IF;
   
   IF (newrec_.release_planning IS NULL) THEN
      newrec_.release_planning := 'NOTRELEASED';
   END IF;    
   IF (newrec_.charged_item IS NULL) THEN
      newrec_.charged_item := 'CHARGED ITEM';
   END IF;
   IF (newrec_.configuration_id IS NULL) THEN
      newrec_.configuration_id := '*';
   END IF;
   IF (newrec_.ctp_planned IS NULL) THEN
      newrec_.ctp_planned := 'N';
   END IF;
   IF (newrec_.inverted_conv_factor IS NULL) THEN
      newrec_.inverted_conv_factor := 1;
   END IF;
   IF (newrec_.quotation_discount IS NULL) THEN
      newrec_.quotation_discount := 0;
   END IF;
   IF (newrec_.price_freeze IS NULL) THEN
      newrec_.price_freeze := 'FREE';
   END IF;
   IF (newrec_.buy_qty_due IS NULL AND indrec_.buy_qty_due) THEN
      newrec_.buy_qty_due := 0;
   END IF;
   IF (newrec_.rental IS NULL) THEN
      newrec_.rental := 'FALSE';
   END IF;
   IF (newrec_.vendor_no IS NOT NULL AND indrec_.vendor_no) THEN
      Exist_Vendor_No___(newrec_.vendor_no, newrec_.contract, sales_part_rec_.purchase_part_no, newrec_.rental);
   END IF;
   
   IF (newrec_.freight_free IS NULL) THEN
      newrec_.freight_free := 'FALSE';
   END IF;
      
   IF (newrec_.freight_map_id IS NOT NULL AND newrec_.zone_id IS NOT NULL) THEN
      Freight_Zone_API.Exist(newrec_.freight_map_id, newrec_.zone_id);
   END IF;
   IF (newrec_.price_unit_meas IS NULL) THEN
      newrec_.price_unit_meas := sales_part_rec_.price_unit_meas;
   END IF;
   Iso_Unit_API.Exist(newrec_.price_unit_meas);

   IF (newrec_.price_source_net_price IS NULL) THEN
      newrec_.price_source_net_price := 'FALSE';
   END IF;

   IF (newrec_.catalog_desc IS NULL) THEN
      newrec_.catalog_desc := Sales_Part_API.Get_Catalog_Desc(newrec_.contract, newrec_.catalog_no);
   END IF;

   IF (newrec_.wanted_delivery_date IS NOT NULL AND newrec_.promised_delivery_date IS NULL) THEN
      newrec_.promised_delivery_date := newrec_.wanted_delivery_date;
   END IF;

   IF (newrec_.promised_delivery_date IS NOT NULL AND newrec_.planned_delivery_date IS NULL) THEN
      newrec_.planned_delivery_date := newrec_.promised_delivery_date;
   END IF;

   IF (newrec_.order_supply_type IN ('PT', 'PD', 'IPT', 'IPD')) THEN
      IF (newrec_.vendor_no IS NULL) THEN
         -- check if non-inventory sales part uses a purchase part
         Retrieve_Default_Vendor___(newrec_.vendor_no, newrec_.contract, sales_part_rec_.purchase_part_no, newrec_.order_supply_type, newrec_.rental);
      ELSE
         -- Validate the category for the specified vendor
         Validate_Vendor_Category___(newrec_.vendor_no, newrec_.order_supply_type);
      END IF;
   ELSE
      newrec_.vendor_no := NULL;
   END IF;

   -- Retrive default values for supply chain parameters
   Get_Supply_Chain_Defaults___(newrec_, indrec_);
   -- Check if the single occurrence address need to be copied to the quotaiton line.
   IF ((newrec_.default_addr_flag = 'N') AND (newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE) AND Is_Single_Occ_Addr_Empty___(newrec_)) THEN
      -- Default Info is unchecked and single occurrence is checked, copy the single occurrence address from the header.
      Copy_Singl_Occ_Addr_To_Line___(newrec_, quote_rec_);      
   END IF;
   IF (newrec_.single_occ_addr_flag = 'TRUE') THEN
      IF newrec_.default_addr_flag = 'N' THEN 
         Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details(newrec_.freight_map_id,
                                                           newrec_.zone_id,
                                                           zone_info_exist_,
                                                           newrec_.contract,
                                                           newrec_.ship_via_code,
                                                           newrec_.ship_addr_zip_code,
                                                           newrec_.ship_addr_city,
                                                           newrec_.ship_addr_county,
                                                           newrec_.ship_addr_state,
                                                           newrec_.ship_addr_country_code);
      ELSIF newrec_.default_addr_flag = 'Y' THEN
         Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details(newrec_.freight_map_id,
                                                           newrec_.zone_id,
                                                           zone_info_exist_,
                                                           newrec_.contract,
                                                           quote_rec_.ship_via_code,
                                                           quote_rec_.ship_addr_zip_code,
                                                           quote_rec_.ship_addr_city,
                                                           quote_rec_.ship_addr_county,
                                                           quote_rec_.ship_addr_state,
                                                           quote_rec_.ship_addr_country_code);
      END IF;
   ELSIF (newrec_.freight_map_id IS NULL AND newrec_.zone_id IS NULL) THEN
      Freight_Zone_Util_API.Fetch_Zone_For_Cust_Addr(newrec_.freight_map_id,
                                                     newrec_.zone_id,
                                                     newrec_.customer_no,
                                                     newrec_.ship_addr_no,
                                                     newrec_.contract,
                                                     newrec_.ship_via_code);
   END IF;   
   
   IF (newrec_.freight_map_id IS NOT NULL AND newrec_.zone_id IS NOT NULL) THEN
      IF (newrec_.order_supply_type IN ('PD', 'IPD') AND (newrec_.vendor_no IS NOT NULL)) THEN
         newrec_.freight_price_list_no := Freight_Price_List_Direct_API.Get_Active_Freight_List_No(newrec_.contract,
                                                                                                   newrec_.ship_via_code,
                                                                                                   newrec_.freight_map_id,
                                                                                                   newrec_.forward_agent_id,
                                                                                                   quote_rec_.use_price_incl_tax,
                                                                                                   newrec_.vendor_no);
      ELSE
         newrec_.freight_price_list_no := Freight_Price_List_API.Get_Active_Freight_List_No(newrec_.contract,
                                                                                            newrec_.ship_via_code,
                                                                                            newrec_.freight_map_id,
                                                                                            newrec_.forward_agent_id,
                                                                                            quote_rec_.use_price_incl_tax);
      END IF;
   ELSE
      newrec_.freight_price_list_no := NULL;
   END IF;
   
   -- Calculate all the dates on the new quotation line
   IF (newrec_.planned_due_date IS NULL AND newrec_.wanted_delivery_date IS NOT NULL) THEN
      Calculate_Quote_Line_Dates___(newrec_);
   END IF;

   IF ((newrec_.line_no IS NULL) AND (newrec_.rel_no IS NULL)) THEN
      ORDER_QUOTATION_API.Get_Next_Line_No(newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, newrec_.quotation_no,
                newrec_.contract, newrec_.catalog_no, Order_Supply_Type_API.Decode(newrec_.order_supply_type));
   ELSIF (newrec_.line_item_no <= 0) THEN
      IF (newrec_.order_supply_type = 'PKG') THEN
         newrec_.line_item_no := -1;
      ELSE
         newrec_.line_item_no := 0;
      END IF;
   END IF;

   IF (newrec_.part_no IS NOT NULL) THEN
      IF (newrec_.condition_code IS NOT NULL) THEN
         IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(newrec_.part_no) = 'NOT_ALLOW_COND_CODE') THEN
            Error_SYS.Record_General(lu_name_,'COND_NOT_ALLOW: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
         ELSE
            Condition_Code_API.Exist(newrec_.condition_code);
         END IF;
      ELSE
         IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(newrec_.part_no) = 'ALLOW_COND_CODE') THEN
            newrec_.condition_code := Condition_Code_API.Get_Default_Condition_Code;
         END IF;
      END IF;

      --Inventory part
      inv_part_rec_ := Inventory_Part_API.Get(newrec_.contract, newrec_.part_no);
      -- Check sales qty is larger than available qty if part status is supplier not allowed, supply code is Invent Order and availability check applied.
      IF (inv_part_rec_.onhand_analysis_flag = 'Y' AND Inventory_Part_Status_Par_API.Get_Supply_Flag_Db(inv_part_rec_.part_status) = 'N' AND newrec_.order_supply_type = 'IO') THEN
          avl_qty_ := Reserve_Customer_Order_API.Get_Available_Qty(newrec_.contract,
                                                     NVL(newrec_.part_no, newrec_.catalog_no),
                                                     newrec_.configuration_id,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     newrec_.order_supply_type,
                                                     'COMPANY OWNED',
                                                     NULL,
                                                     NULL,
                                                     newrec_.condition_code,
                                                     newrec_.vendor_no,
                                                     'FALSE');

         IF( newrec_.revised_qty_due > avl_qty_) THEN
            Client_SYS.Add_Info(lu_name_, 'PHASEDOUTPART: Supplies are not allowed for part :P1. Review the supply situation and/or look for an alternative part.', newrec_.part_no);
         END IF;
      END IF;
   END IF;

   IF (newrec_.classification_standard IS NOT NULL) THEN
      assortment_id_ := Assortment_Structure_API.Get_Assort_For_Classification(newrec_.classification_standard);
      IF (Customer_Assortment_Struct_API.Get_Classification_Standard(newrec_.customer_no, assortment_id_) IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'INVALID_CLASSIF: The classification standard :P1 is not connected to the customer :P2.',newrec_.classification_standard, newrec_.customer_no);
      END IF;
   END IF;
      
   $IF Component_Purch_SYS.INSTALLED $THEN
      supplier_site_ := Supplier_API.Get_Acquisition_Site(newrec_.vendor_no);     
   $END
   
   IF (customer_category_ = Customer_Category_API.DB_PROSPECT) THEN
      IF (newrec_.order_supply_type = 'IPD') THEN
         newrec_.picking_leadtime := NVL(Site_Invent_Info_API.Get_Picking_Leadtime(supplier_site_), 0);
      END IF;
   END IF;

   super(newrec_, indrec_, attr_);

   IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0) THEN
      Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'PICKVALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
   END IF;

   IF ((header_rowstate_ IN ('Planned','Released','Revised','Rejected')) AND (newrec_.part_no IS NOT NULL)) THEN
      inv_part_cost_level_db_ := Inventory_part_API.Get_Invent_Part_Cost_Level_Db(newrec_.contract, newrec_.part_no);
      IF (newrec_.configuration_id = '*') AND (inv_part_cost_level_db_ = 'COST PER CONFIGURATION') AND (Part_Catalog_API.Get_Configurable(newrec_.part_no) = Part_Configuration_API.Decode('CONFIGURED')) THEN
          newrec_.cost := 0;
      END IF;
   END IF;
   
   -- Cost is set to zero for rentals.
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      newrec_.cost := 0;
   END IF;

   IF (newrec_.delivery_type IS NULL) THEN
      newrec_.delivery_type := sales_part_rec_.delivery_type;
   END IF;

   Client_SYS.Add_To_Attr('LINE_NO', newrec_.line_no, attr_);
   Client_SYS.Add_To_Attr('REL_NO', newrec_.rel_no, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', newrec_.line_item_no, attr_);
   Client_SYS.Add_To_Attr('DESIRED_QTY', newrec_.desired_qty, attr_);
   newrec_.additional_discount := quote_rec_.additional_discount;
   Client_SYS.Add_To_Attr('ADDITIONAL_DISCOUNT', newrec_.additional_discount, attr_);
   -- Add conditions to the fields in the procedure below.

   Check_Before_Insert___(attr_, newrec_, quote_rec_.currency_code);

   IF (customer_category_ = Customer_Category_API.DB_CUSTOMER) THEN     
      IF NOT (newrec_.tax_liability_type = 'TAX' OR newrec_.tax_liability_type = 'EXM') THEN
         delivery_country_code_ := Cust_Ord_Customer_Address_API.Get_Country_Code(newrec_.customer_no, newrec_.ship_addr_no);
         Tax_Handling_Order_Util_API.Validate_Tax_Liability(newrec_.tax_liability, delivery_country_code_);
      END IF;      
   END IF;

   IF (newrec_.ext_transport_calendar_id IS NOT NULL) THEN
      Work_Time_Calendar_API.Check_Not_Generated(newrec_.ext_transport_calendar_id);
   END IF;

   Client_SYS.Add_To_Attr('VENDOR_NO', newrec_.vendor_no, attr_);
   Client_SYS.Add_To_Attr('SHIP_VIA_CODE', newrec_.ship_via_code, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', newrec_.delivery_leadtime, attr_);
   Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', newrec_.ext_transport_calendar_id, attr_);
   Client_SYS.Add_To_Attr('PICKING_LEADTIME', newrec_.picking_leadtime, attr_); 
   Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', newrec_.forward_agent_id, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     order_quotation_line_tab%ROWTYPE,
   newrec_ IN OUT order_quotation_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   quote_rec_                 ORDER_QUOTATION_API.Public_Rec;
   header_rowstate_           ORDER_QUOTATION_TAB.rowstate%TYPE;
   delivery_date_changed_     BOOLEAN := FALSE;      
   price_list_no_             ORDER_QUOTATION_LINE_TAB.price_list_no%TYPE;
   qty_refreshed_             BOOLEAN := FALSE;
   price_source_refreshed_    BOOLEAN := FALSE;
   dummy_                     VARCHAR2(2000);
   interim_head_id_           VARCHAR2(12);
   revised_qty_due_           NUMBER;
   inv_part_cost_level_db_    VARCHAR2(50);
   server_data_change_        NUMBER := 0;
   delivery_country_code_     VARCHAR2(2);
   delivery_type_changed_     BOOLEAN := FALSE;
   price_source_              VARCHAR2(200);
   oldsite_                   VARCHAR2(5);
   newsite_                   VARCHAR2(5);
   oldcountry_                VARCHAR2(2);
   newcountry_                VARCHAR2(2);
   refresh_config_price_      NUMBER;
   customer_category_         CUSTOMER_INFO_TAB.customer_category%TYPE;  
   inv_part_rec_              Inventory_Part_API.Public_Rec;
   avl_qty_                   NUMBER;
   updated_from_wizard_       VARCHAR2(5) := 'FALSE';
   insert_package_mode_       BOOLEAN := FALSE;   
   supplier_site_             VARCHAR2(5) := NULL;
   prospect_to_normal_        VARCHAR2(5) := 'FALSE';
   info_                      VARCHAR2(2000);
   discount_line_count_       NUMBER;
   sales_price_type_db_       VARCHAR2(20);
   rental_chargable_days_     NUMBER;
   sale_unit_price_           NUMBER;
   unit_price_incl_tax_       NUMBER;
   country_code_              VARCHAR2(2);
   ctp_run_id_                NUMBER;
   copy_addr_to_line_         VARCHAR2(5) := 'FALSE';
   tax_changed_from_header_   VARCHAR2(5) := 'FALSE';
   sales_part_rec_            Sales_Part_API.Public_Rec;
   interim_ord_id_            VARCHAR2(12);
BEGIN
   quote_rec_       := Order_Quotation_API.Get(newrec_.quotation_no);
   header_rowstate_ := quote_rec_.rowstate;
   IF (newrec_.customer_no IS NULL) THEN
      newrec_.customer_no := quote_rec_.customer_no;
      prospect_to_normal_ := 'TRUE';
   END IF;
   customer_category_   := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);
   updated_from_wizard_ := Client_SYS.Get_Item_Value('UPDATED_FROM_WIZARD', attr_);
      
   IF (indrec_.ext_transport_calendar_id) THEN
      IF (NVL(newrec_.ext_transport_calendar_id, Database_SYS.string_null_) != NVL(oldrec_.ext_transport_calendar_id, Database_SYS.string_null_)) THEN
         delivery_date_changed_ := TRUE;
      END IF;
   END IF;

   IF (indrec_.buy_qty_due) THEN
      IF (newrec_.buy_qty_due IS NULL) THEN
         newrec_.buy_qty_due := 0;
      END IF;
      -- Check if qty is refreshed, i.e., if qty has been updated with same value as in old record.
      -- Used for being able to trigger fetching of correct default prices and discounts.
      IF (oldrec_.buy_qty_due = newrec_.buy_qty_due) THEN
         -- buy_qty_due has been refreshed.
         qty_refreshed_ := TRUE;
      END IF;
   END IF;
   
   IF (newrec_.tax_code IS NOT NULL AND indrec_.tax_code) THEN
      Statutory_Fee_API.Exist(newrec_.company, newrec_.tax_code);
   END IF;
      
   IF (indrec_.tax_liability OR indrec_.ship_addr_country_code OR indrec_.ship_addr_no OR indrec_.default_addr_flag) THEN
      IF(newrec_.ship_addr_country_code IS NOT NULL) THEN
         country_code_ := newrec_.ship_addr_country_code;
      ELSIF(newrec_.default_addr_flag = 'Y') THEN 
         country_code_ := quote_rec_.country_code;
      ELSE
         country_code_ := Customer_Info_Address_API.Get_Country_Code(newrec_.customer_no, newrec_.ship_addr_no);
      END IF;
      newrec_.tax_liability_type := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, country_code_);
   END IF;
   
   sales_part_rec_ := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);

   IF (indrec_.vendor_no) THEN
      -- Note : If quotation has been released then supplier may be changed only if supply code is (was) Not Decided...
      IF ((header_rowstate_ = 'Planned') OR ((oldrec_.order_supply_type = 'ND') AND (header_rowstate_ NOT IN ('Cancelled', 'Closed') AND newrec_.rowstate NOT IN ('Won', 'Lost', 'Cancelled', 'CO Created')))) THEN         
         IF (newrec_.vendor_no IS NOT NULL) THEN
            Exist_Vendor_No___(newrec_.vendor_no, newrec_.contract, sales_part_rec_.purchase_part_no, newrec_.rental);
         END IF;
      ELSE
         Error_SYS.Record_General(lu_name_, 'CANNOTUPDSUPP: Supplier can be changed only when quotation has not been Released.');
      END IF;
   END IF;
   
   IF (indrec_.wanted_delivery_date OR 
       (indrec_.delivery_leadtime AND oldrec_.delivery_leadtime != newrec_.delivery_leadtime) OR
       (indrec_.ship_via_code AND (NVL(oldrec_.ship_via_code, Database_SYS.string_null_)) != (NVL(newrec_.ship_via_code, Database_SYS.string_null_))) OR
       indrec_.planned_delivery_date OR
       (indrec_.picking_leadtime AND oldrec_.picking_leadtime != newrec_.picking_leadtime)) THEN
      delivery_date_changed_ := TRUE;
   END IF;
   
   IF Client_SYS.Item_Exist('COPY_ADDR_TO_LINE', attr_) THEN 
     copy_addr_to_line_ := Client_SYS.Get_Item_Value('COPY_ADDR_TO_LINE', attr_); 
   END IF;
   IF Client_SYS.Item_Exist('UPDATE_TAX', attr_) THEN 
     tax_changed_from_header_ := NVL(Client_SYS.Get_Item_Value('UPDATE_TAX', attr_), 'FALSE');
   ELSIF (copy_addr_to_line_ = 'TRUE' AND newrec_.default_addr_flag = 'N') THEN
     tax_changed_from_header_ := 'TRUE';  
   END IF;
   
   --IF (newrec_.tax_code != quote_rec_.vat_free_vat_code AND newrec_.tax_liability = 'EXEMPT') THEN
   IF (newrec_.tax_liability_type = 'EXM') THEN
      IF (sales_part_rec_.taxable = Fnd_Boolean_API.DB_TRUE AND tax_changed_from_header_ = 'TRUE') THEN
         IF (newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE) THEN
            IF (newrec_.default_addr_flag = 'Y' OR (copy_addr_to_line_ = 'TRUE' AND newrec_.default_addr_flag = 'N')) THEN
               newrec_.tax_code := quote_rec_.vat_free_vat_code;            
            END IF;
         END IF;
      END IF;
   END IF;

   IF (indrec_.price_list_no) THEN
      -- Check if price list is refreshed, i.e., if price list has been updated with same value as in old record.
      -- Used for being able to trigger fetching of correct default prices and discounts.
      IF (oldrec_.price_list_no = newrec_.price_list_no) THEN
         -- price_list_no has been refreshed.
         price_source_refreshed_ := TRUE;
      END IF;
   END IF;

   IF (indrec_.delivery_type) THEN
      delivery_type_changed_ := TRUE;
   END IF;
   
   IF (indrec_.price_source) THEN
      -- Check if price source is refreshed, i.e., if price source has been updated with same value as in old record.
      -- Used for being able to trigger fetching of correct default prices and discounts.
      IF (oldrec_.price_source = newrec_.price_source) THEN
         price_source_refreshed_ := TRUE;
      END IF;
   END IF;

   IF (Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) THEN
      server_data_change_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SERVER_DATA_CHANGE', attr_));
   END IF;

   IF (Client_SYS.Item_Exist('REFRESH_CONFIG_PRICE', attr_)) THEN
      refresh_config_price_ := Client_SYS.Get_Item_Value('REFRESH_CONFIG_PRICE', attr_);
   END IF;
   
   IF (newrec_.freight_map_id IS NOT NULL AND newrec_.zone_id IS NOT NULL) THEN
      Freight_Zone_API.Exist(newrec_.freight_map_id, newrec_.zone_id);
   END IF;
   
   -- Test if customer order line exist if needed
   IF (indrec_.con_order_no OR indrec_.con_line_no OR indrec_.con_rel_no OR indrec_.con_line_item_no) THEN
      Customer_Order_Line_API.Exist( newrec_.con_order_no, newrec_.con_line_no, newrec_.con_rel_no, newrec_.con_line_item_no );
   END IF;

   IF (newrec_.price_source_net_price IS NULL) THEN
      newrec_.price_source_net_price := 'FALSE';
   END IF;

   IF (newrec_.wanted_delivery_date IS NOT NULL AND newrec_.promised_delivery_date IS NULL) THEN
      newrec_.promised_delivery_date := newrec_.wanted_delivery_date;
   END IF;

   IF (newrec_.promised_delivery_date IS NOT NULL AND newrec_.planned_delivery_date IS NULL) THEN
      newrec_.planned_delivery_date := newrec_.promised_delivery_date;
   END IF;

   -- If condition code or qty was changed, and this is not a configured part then retrive new cost
   -- (For configured parts cost should be calculated using the interim order functionality)
   revised_qty_due_ := newrec_.buy_qty_due * newrec_.conv_factor / newrec_.inverted_conv_factor;
   inv_part_cost_level_db_ := Inventory_part_API.Get_Invent_Part_Cost_Level_Db(newrec_.contract,newrec_.part_no);

   IF ((newrec_.condition_code != NVL(oldrec_.condition_code, 'NOT_NULL')) AND (inv_part_cost_level_db_ = 'COST PER CONDITION')) OR
       (( inv_part_cost_level_db_ != 'COST PER CONFIGURATION') AND (newrec_.buy_qty_due != oldrec_.buy_qty_due)) THEN

      IF (revised_qty_due_ IS NOT NULL) THEN
         newrec_.cost := Sales_Cost_Util_API.Get_Cost_Incl_Sales_Overhead(newrec_.contract,
                                                                          newrec_.part_no,
                                                                          newrec_.configuration_id,
                                                                          newrec_.condition_code,
                                                                          revised_qty_due_,
                                                                          newrec_.charged_item,
                                                                          newrec_.order_supply_type,
                                                                          newrec_.customer_no,
                                                                          NULL);
      ELSE
         newrec_.cost := 0;
      END IF;
      Client_SYS.Set_Item_Value('COST', newrec_.cost, attr_);
   END IF;

   IF (newrec_.order_supply_type != oldrec_.order_supply_type OR
       newrec_.ship_addr_no != oldrec_.ship_addr_no OR
       NVL(newrec_.vendor_no, ' ') != NVL(oldrec_.vendor_no, ' ') OR
       NVL(newrec_.ship_via_code, ' ') != NVL(oldrec_.ship_via_Code, ' ') OR
       newrec_.single_occ_addr_flag != oldrec_.single_occ_addr_flag) AND 
       newrec_.single_occ_addr_flag = 'FALSE' THEN
      IF (newrec_.order_supply_type IN ('PT', 'PD', 'IPT', 'IPD')) THEN
         IF (newrec_.vendor_no IS NULL) THEN
            -- Note : Retrieve the default vendor if any
            Retrieve_Default_Vendor___(newrec_.vendor_no, newrec_.contract, sales_part_rec_.purchase_part_no, newrec_.order_supply_type, newrec_.rental);
         ELSE
           -- Validate the category for the specified vendor
           Validate_Vendor_Category___(newrec_.vendor_no, newrec_.order_supply_type);
         END IF;
      ELSE
         newrec_.vendor_no := NULL;
      END IF;

      -- Retrieve new supply chain defaults
      Get_Supply_Chain_Defaults___(newrec_, indrec_);
      IF (newrec_.freight_map_id IS NULL AND newrec_.zone_id IS NULL) THEN
            Freight_Zone_Util_API.Fetch_Zone_For_Cust_Addr(newrec_.freight_map_id,
                                                           newrec_.zone_id,
                                                           newrec_.customer_no,
                                                           newrec_.ship_addr_no,
                                                           newrec_.contract,
                                                           newrec_.ship_via_code);
      END IF;

      IF (newrec_.freight_map_id IS NOT NULL AND newrec_.zone_id IS NOT NULL) THEN
         IF (newrec_.order_supply_type IN ('PD', 'IPD') AND (newrec_.vendor_no IS NOT NULL)) THEN
            newrec_.freight_price_list_no := Freight_Price_List_Direct_API.Get_Active_Freight_List_No(newrec_.contract,
                                                                                                      newrec_.ship_via_code,
                                                                                                      newrec_.freight_map_id,
                                                                                                      newrec_.forward_agent_id,
                                                                                                      quote_rec_.use_price_incl_tax,
                                                                                                      newrec_.vendor_no);
         ELSE
            newrec_.freight_price_list_no := Freight_Price_List_API.Get_Active_Freight_List_No(newrec_.contract,
                                                                                               newrec_.ship_via_code,
                                                                                               newrec_.freight_map_id,
                                                                                               newrec_.forward_agent_id,
                                                                                               quote_rec_.use_price_incl_tax);
         END IF;
      ELSE
         newrec_.freight_price_list_no := NULL;
      END IF;
      -- recalculate all dates since necessary parameter have been changed.
      delivery_date_changed_ := TRUE;
   END IF;

   IF (newrec_.configuration_id != '*' AND newrec_.buy_qty_due != oldrec_.buy_qty_due AND oldrec_.buy_qty_due != 0 AND newrec_.buy_qty_due != 0) THEN
         Client_SYS.Add_Info(lu_name_, 
          'CONFIGQTY: Quantity change may affect configuration. Edit configuration to verify characteristics.'); 
   END IF;
   
    $IF Component_Purch_SYS.INSTALLED $THEN
      supplier_site_ := Supplier_API.Get_Acquisition_Site(newrec_.vendor_no);     
   $END
   
   IF (newrec_.configuration_id != '*' AND Nvl(newrec_.vendor_no, '*') != Nvl(oldrec_.vendor_no, '*')) THEN
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         IF oldrec_.vendor_no IS NOT NULL THEN         
            oldsite_ := Supplier_API.Get_Acquisition_Site(oldrec_.vendor_no);
         ELSE
            oldsite_ := '*';
         END IF;
            IF newrec_.vendor_no IS NOT NULL THEN         
               newsite_ := supplier_site_;
            ELSE
               newsite_ := '*';
            END IF;
      $ELSE
         oldsite_ := '*';
         newsite_ := '*';
      $END 
      IF oldsite_ != newsite_ THEN
         Client_SYS.Add_Info(lu_name_, 'CONFIGSUPPSITE: Supply site change may affect configuration. Edit configuration to verify characteristics.');
      END IF;
   END IF;
   
  IF (customer_category_ = Customer_Category_API.DB_PROSPECT) THEN
      IF (newrec_.order_supply_type = 'IPD') THEN
         newrec_.picking_leadtime := NVL(Site_Invent_Info_API.Get_Picking_Leadtime(supplier_site_), 0);
      END IF;
   END IF;
   
   IF (newrec_.configuration_id != '*' AND (Nvl(newrec_.ship_addr_no, '*') != Nvl(oldrec_.ship_addr_no, '*') OR
       newrec_.single_occ_addr_flag != oldrec_.single_occ_addr_flag)) THEN
      IF oldrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE THEN 
         IF oldrec_.default_addr_flag = 'N' THEN
            oldcountry_ := oldrec_.ship_addr_country_code;
         ELSE 
            oldcountry_ := order_quotation_API.Get_Ship_Addr_Country_Code(oldrec_.quotation_no);
         END IF ; 
      ELSE 
         oldcountry_ := Cust_Ord_Customer_Address_API.Get_Country_Code(oldrec_.customer_no, oldrec_.ship_addr_no);
      END IF ;
   
      IF newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE THEN
         IF newrec_.default_addr_flag = 'N' THEN
            newcountry_ := newrec_.ship_addr_country_code;
         ELSE 
            newcountry_ := quote_rec_.ship_addr_country_code;
         END IF ; 
      ELSE
         newcountry_ := Cust_Ord_Customer_Address_API.Get_Country_Code(newrec_.customer_no, newrec_.ship_addr_no);            
      END IF;   

      IF Nvl(newcountry_, '*') != Nvl(oldcountry_, '*') THEN
         Client_SYS.Add_Info(lu_name_,
          'CONFIGDELCTRY: Delivery country change may affect configuration. Edit configuration to verify characteristics.');
      END IF;
   END IF;

   IF (NVL(newrec_.ext_transport_calendar_id, Database_SYS.string_null_) != NVL(oldrec_.ext_transport_calendar_id, Database_SYS.string_null_)) THEN
      Work_Time_Calendar_API.Check_Not_Generated(newrec_.ext_transport_calendar_id);
   END IF;

   -- Check sales qty is larger than available qty if part status is supplier not allowed, supply code is Invent Order and availability check applied.
   IF (newrec_.part_no IS NOT NULL AND newrec_.order_supply_type = 'IO' AND (oldrec_.revised_qty_due != newrec_.revised_qty_due OR (oldrec_.order_supply_type != newrec_.order_supply_type))) THEN
      --Inventory part
      inv_part_rec_ := Inventory_Part_API.Get(newrec_.contract, newrec_.part_no);     
      IF (inv_part_rec_.onhand_analysis_flag = 'Y' AND Inventory_Part_Status_Par_API.Get_Supply_Flag_Db(inv_part_rec_.part_status) = 'N') THEN
          avl_qty_ := Reserve_Customer_Order_API.Get_Available_Qty(newrec_.contract,
                                                     NVL(newrec_.part_no, newrec_.catalog_no),
                                                     newrec_.configuration_id,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     newrec_.order_supply_type,
                                                     'COMPANY OWNED',
                                                     NULL,
                                                     NULL,
                                                     newrec_.condition_code,
                                                     newrec_.vendor_no,
                                                     'FALSE');

         IF( newrec_.revised_qty_due > avl_qty_) THEN
            Client_SYS.Add_Info(lu_name_, 'PHASEDOUTPART: Supplies are not allowed for part :P1. Review the supply situation and/or look for an alternative part.', newrec_.part_no);
         END IF;
      END IF;
   END IF;
   
   IF (Get_Objstate( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) IN ('CO Created','Lost')) AND (NVL(newrec_.customer_tax_usage_type,' ') != NVL(oldrec_.customer_tax_usage_type, ' ') ) THEN
      Error_SYS.Record_General(lu_name_, 'CCANTMODIFYOQ: CO Created/Lost order quotation lines may not be modified');
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (indrec_.ship_addr_no) THEN
      newrec_.end_customer_id := Customer_Info_Address_API.Get_End_Customer_Id(newrec_.customer_no, newrec_.ship_addr_no);
   END IF;
   
   IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0) THEN
      Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'PICKVALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
   END IF;
   
   Client_SYS.Add_To_Attr( 'UPDATED_FROM_WIZARD', updated_from_wizard_, attr_ );
   
   -- if supply code changes from a valid CTP/CC code to a non valid and latest_release_date have value
   -- then set latest_release_date to null. This covers all 'NEITHER RESERVE NOR ALLOCATE' cases
   IF (oldrec_.order_supply_type IN ('SO','DOP','IPT','IPD','IO') AND
       newrec_.order_supply_type NOT IN ('SO','DOP','IPT','IPD','IO') AND newrec_.latest_release_date IS NOT NULL)  THEN
      newrec_.latest_release_date   := NULL;
      -- recalculate all dates
      delivery_date_changed_        := TRUE;
      newrec_.planned_delivery_date := newrec_.wanted_delivery_date;
   END IF;
   interim_ord_id_:= Get_Interim_Order_No(oldrec_.quotation_no, oldrec_.line_no, oldrec_.rel_no, oldrec_.line_item_no, oldrec_.ctp_planned);

   IF (newrec_.ctp_planned = 'Y' OR newrec_.latest_release_date IS NOT NULL OR (oldrec_.ctp_planned = 'N' AND interim_ord_id_ IS NOT NULL)) THEN
      -- handling of special updates that concerns Capability Check
      IF ((NVL(oldrec_.delivery_leadtime,-1) != NVL(newrec_.delivery_leadtime,-1)) OR
         (NVL(oldrec_.picking_leadtime,-1) != NVL(newrec_.picking_leadtime,-1)) OR
         (NVL(oldrec_.ship_via_code,' ') != NVL(newrec_.ship_via_code,' ')) OR
         (NVL(oldrec_.ext_transport_calendar_id, Database_SYS.string_null_) != NVL(newrec_.ext_transport_calendar_id, Database_SYS.string_null_)) OR
         (oldrec_.order_supply_type != newrec_.order_supply_type) OR
         (NVL(oldrec_.ship_addr_no,' ') != NVL(newrec_.ship_addr_no,' ')) OR
         (NVL(oldrec_.vendor_no,' ') != NVL(newrec_.vendor_no,' ')) OR
         (NVL(oldrec_.wanted_delivery_date, to_date('31-12-4712','DD-MM-YYYY')) != NVL(newrec_.wanted_delivery_date, to_date('31-12-4712','DD-MM-YYYY'))) OR
         (NVL(oldrec_.planned_delivery_date, to_date('31-12-4712','DD-MM-YYYY')) != NVL(newrec_.planned_delivery_date, to_date('31-12-4712','DD-MM-YYYY'))) OR
         (NVL(oldrec_.planned_due_date, to_date('31-12-4712','DD-MM-YYYY')) != NVL(newrec_.planned_due_date, to_date('31-12-4712','DD-MM-YYYY'))) OR
         (oldrec_.revised_qty_due != newrec_.revised_qty_due)) AND (newrec_.rowstate IN ('Planned', 'Released','Rejected'))THEN
            -- inform user that he needs to re-run the Capability Check to get correct delivery date when he changes dates or quantity
            Client_SYS.Add_Info(lu_name_, 'SQLCCPLANNED: This Sales Quotation Line was planned with a Capability Check. Dates will be reset and possible interim orders deleted. You can choose to run the Capability Check again.');
            -- cancel interim orders
            IF (newrec_.ctp_planned = 'Y' OR (oldrec_.ctp_planned = 'N' AND interim_ord_id_ IS NOT NULL)) THEN
               IF NOT insert_package_mode_ THEN
                  info_ := Client_SYS.Get_All_Info;
               END IF;
               Add_Info___( info_, insert_package_mode_);   -- cancel_ctp seems to do a clear info
               
               $IF (Component_Ordstr_SYS.INSTALLED) $THEN
                  Interim_Ctp_Manager_API.Cancel_Ctp(dummy_, newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, 'CUSTOMERQUOTE', newrec_.order_supply_type);
                  -- Remove ctp record
                  ctp_run_id_ := Interim_Ctp_Critical_Path_API.Get_Ctp_Run_Id('CUSTOMERQUOTE', newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
                  IF (ctp_run_id_ IS NOT NULL AND ctp_run_id_ > 0) THEN
                     Interim_Ctp_Critical_Path_API.Clear_Ctp_Data(ctp_run_id_);
                  END IF;
               $END             
            END IF;
            -- recalculate all dates
            delivery_date_changed_ := TRUE;
            newrec_.planned_delivery_date := newrec_.wanted_delivery_date;
            -- removed cc/ctp flags and latest release date
            newrec_.ctp_planned := 'N';
            newrec_.latest_release_date := NULL;
      END IF;
   ELSE
      IF (oldrec_.revised_qty_due != newrec_.revised_qty_due) THEN
         $IF (Component_Ordstr_SYS.INSTALLED) $THEN
            interim_head_id_ := Interim_Demand_Head_API.Get_Cust_Quote_Line_Int_Head(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
         $ELSE
            NULL;
         $END         
            IF (interim_head_id_ IS NOT NULL) THEN
            $IF (Component_Ordstr_SYS.INSTALLED) $THEN
               Interim_Demand_Head_API.Set_Demand_Qty(interim_head_id_, newrec_.revised_qty_due);
            $ELSE
               NULL;
            $END             
            END IF;
      ELSE
         -- Changed from "to_date('31-DEC-4712','DD-MON-YYYY')" to "to_date('31-12-4712','DD-MM-YYYY')"
         IF (NVL(oldrec_.wanted_delivery_date,to_date('31-12-4712','DD-MM-YYYY')) != NVL(newrec_.wanted_delivery_date,to_date('31-12-4712','DD-MM-YYYY'))) THEN
            $IF (Component_Ordstr_SYS.INSTALLED) $THEN
               interim_head_id_ := Interim_Demand_Head_API.Get_Cust_Quote_Line_Int_Head(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
            $END    
               IF (interim_head_id_ IS NOT NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'INTORDEXISTS: Date may not be changed when an Interim Order exists. Delete the Interim Order to proceed.');
               END IF;
            END IF;
         END IF;
      END IF;
   
   -- Calculate all the dates on the new quotation line
   IF (delivery_date_changed_ AND (newrec_.wanted_delivery_date IS NOT NULL)) THEN
      Calculate_Quote_Line_Dates___(newrec_);
   END IF;

   IF (qty_refreshed_) THEN
      Client_SYS.Add_To_Attr('QTY_REFRESHED', 1, attr_);
   END IF;

   IF (price_source_refreshed_) THEN
      Client_SYS.Add_To_Attr('PRICE_SOURCE_REFRESHED', 1, attr_);
   END IF;
   Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', server_data_change_, attr_);
   
   IF (newrec_.rental = Fnd_Boolean_API.DB_FALSE) THEN
      sales_price_type_db_ := Sales_Price_Type_API.DB_SALES_PRICES;
   ELSE
      sales_price_type_db_ := Sales_Price_Type_API.DB_RENTAL_PRICES;
   END IF;

   -- Note: When the header customer is changed, sales price need to be recalculated and the price list value also needs to be refetched
   -- for the new customer, if;
   --    1. normal customer is changed (price freeze is not considered).  
   --    2. customer is changed from Prospect to Normal and Price Freeze has been FREE.
   IF ((NVL(oldrec_.customer_no, Database_SYS.string_null_) != NVL(newrec_.customer_no, Database_SYS.string_null_)) AND (prospect_to_normal_ = 'FALSE')) 
      OR (prospect_to_normal_ = 'TRUE' AND oldrec_.price_freeze = 'FREE') THEN
      price_list_no_ := NULL;
      Sales_Price_List_API.Get_Valid_Price_List(customer_level_db_   => newrec_.customer_level,
                                                customer_level_id_   => newrec_.customer_level_id,
                                                price_list_no_       => price_list_no_,
                                                contract_            => newrec_.contract,
                                                catalog_no_          => newrec_.catalog_no,
                                                customer_no_         => newrec_.customer_no,
                                                currency_code_       => quote_rec_.currency_code,
                                                effectivity_date_    => quote_rec_.price_effectivity_date,
                                                price_qty_due_       => NULL,
                                                sales_price_type_db_ => sales_price_type_db_);
      newrec_.price_list_no := price_list_no_;
      
      -- For rental lines, the rental  chargable days retreived from the rental atrributes
      -- because rental object is updated after order quotation line.
      rental_chargable_days_ := NULL;
      IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
         rental_chargable_days_ := Get_Latest_Rent_Charge_Days___(attr_, newrec_);
      END IF;

      IF (NVL(newrec_.buy_qty_due, 0) != 0) THEN
         -- Find prices, currency and discount.
         Customer_Order_Pricing_API.Get_Quote_Line_Price_Info(sale_unit_price_          => sale_unit_price_,
                                                              unit_price_incl_tax_      => unit_price_incl_tax_,
                                                              base_sale_unit_price_     => newrec_.base_sale_unit_price,
                                                              base_unit_price_incl_tax_ => newrec_.base_unit_price_incl_tax,
                                                              currency_rate_            => newrec_.currency_rate,
                                                              discount_                 => newrec_.discount,
                                                              price_source_             => price_source_,
                                                              price_source_id_          => newrec_.price_source_id,
                                                              net_price_fetched_        => newrec_.price_source_net_price,
                                                              part_level_db_            => newrec_.part_level,
                                                              part_level_id_            => newrec_.part_level_id,
                                                              customer_level_db_        => newrec_.customer_level,
                                                              customer_level_id_        => newrec_.customer_level_id,
                                                              quotation_no_             => newrec_.quotation_no,
                                                              catalog_no_               => newrec_.catalog_no,
                                                              buy_qty_due_              => newrec_.buy_qty_due,
                                                              price_list_no_            => newrec_.price_list_no,
                                                              effectivity_date_         => quote_rec_.price_effectivity_date,
                                                              condition_code_           => NULL,
                                                              use_price_incl_tax_       => quote_rec_.use_price_incl_tax,
                                                              rental_chargable_days_    => rental_chargable_days_);
         newrec_.sale_unit_price     := sale_unit_price_;
         newrec_.unit_price_incl_tax := unit_price_incl_tax_;
         
         Calculate_Prices___(newrec_);
         IF (quote_rec_.use_price_incl_tax = 'TRUE') THEN
            newrec_.part_price := newrec_.unit_price_incl_tax;
         ELSE
            newrec_.part_price := newrec_.sale_unit_price;
         END IF;
         newrec_.price_source := Pricing_Source_API.Encode(price_source_);
      ELSE
         newrec_.price_source := Pricing_Source_API.db_unspecified;
         newrec_.price_source_id := NULL;
         newrec_.sale_unit_price := 0;
         newrec_.unit_price_incl_tax := 0;
         newrec_.base_sale_unit_price := 0;
         newrec_.base_unit_price_incl_tax := 0;
         newrec_.currency_rate := 0;
         newrec_.discount := 0;
         newrec_.price_source_net_price := Fnd_Boolean_API.db_false;
      END IF;
   ELSE
      IF (server_data_change_ != 1) THEN
         IF (newrec_.discount != oldrec_.discount AND newrec_.discount != 0) THEN
            discount_line_count_ := Order_Quote_Line_Discount_API.Get_Discount_Line_Count(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);  
            IF (discount_line_count_ > 1) THEN
               Error_Sys.Record_General(lu_name_, 'MANYDISCLINEXIST: Cannot update discount since there are multiple discount lines connected to the sales quotation line.');  
            ELSE
               Client_SYS.Add_To_Attr('DISCOUNT_LINE_COUNT', discount_line_count_, attr_); 
            END IF;     
         END IF;
      END IF;
   END IF;

   IF (customer_category_ = Customer_Category_API.DB_CUSTOMER) THEN
      IF NOT (newrec_.tax_liability_type = 'TAX' OR newrec_.tax_liability_type = 'EXM') THEN
         delivery_country_code_ := Cust_Ord_Customer_Address_API.Get_Country_Code(newrec_.customer_no, newrec_.ship_addr_no);
         Tax_Handling_Order_Util_API.Validate_Tax_Liability(newrec_.tax_liability, delivery_country_code_);
      END IF;      
   END IF;

   IF (Sales_Promotion_Util_API.Check_Promo_Exist_For_Quo_Line(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no)) THEN
      IF (oldrec_.buy_qty_due != newrec_.buy_qty_due OR oldrec_.sale_unit_price != newrec_.sale_unit_price OR oldrec_.base_sale_unit_price != newrec_.base_sale_unit_price) THEN
         Client_SYS.Add_Info(lu_name_, 'SALEPROMOEXISTQUOT: There are connected sales promotion charge lines existing for the quotation line :P1 that may have to be recalculated or reviewed.', newrec_.quotation_no||'-'||newrec_.line_no||'-'||newrec_.rel_no);
      END IF;
   END IF;

   -- Add conditions to the fields in the procedure below.
   Check_Before_Update___(attr_, newrec_, oldrec_, quote_rec_.currency_code, header_rowstate_);

   -- Attributes that might have changed passed back to the client
   Client_SYS.Add_To_Attr('VENDOR_NO', newrec_.vendor_no, attr_);   
   
   IF (refresh_config_price_ = 1) THEN
      Client_SYS.Add_To_Attr('REFRESH_CONFIG_PRICE', refresh_config_price_, attr_);
   END IF;
END Check_Update___;


PROCEDURE Check_Customer_No_Ref___ (
   newrec_ IN OUT NOCOPY order_quotation_line_tab%ROWTYPE )
IS
   customer_category_         CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   IF (newrec_.customer_no IS NOT NULL) THEN
      customer_category_  := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);
      IF customer_category_ = Customer_Category_API.DB_CUSTOMER THEN
         Cust_Ord_Customer_API.Exist(newrec_.customer_no);
      ELSE
         Customer_Info_API.Exist(newrec_.customer_no, customer_category_);
      END IF;
   END IF;
END Check_Customer_No_Ref___;


PROCEDURE Check_Ship_Addr_No_Ref___ (
   newrec_ IN OUT NOCOPY order_quotation_line_tab%ROWTYPE )
IS
   customer_category_         CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   IF (newrec_.ship_addr_no IS NOT NULL) THEN
      customer_category_  := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);
      IF (customer_category_ = Customer_Category_API.DB_CUSTOMER) THEN
         Cust_Ord_Customer_Address_API.Exist(newrec_.customer_no, newrec_.ship_addr_no);
      ELSE
         Customer_Info_Address_API.Exist(newrec_.customer_no, newrec_.ship_addr_no);
      END IF;
   END IF;
END Check_Ship_Addr_No_Ref___;



-- Check_Reason_Id_Ref___
--   Perform validation on the ReasonIdRef reference.
PROCEDURE Check_Reason_Id_Ref___ (
   newrec_ IN OUT order_quotation_line_tab%ROWTYPE )
IS
   lose_win_ VARCHAR2(20);
BEGIN
   IF ( newrec_.rowstate = 'Lost' ) THEN
      lose_win_ := Lose_Win_Api.DB_LOSE;
   ELSIF ( newrec_.rowstate IN  ('Won', 'CO Created')) THEN
      lose_win_ := Lose_Win_Api.DB_WIN;
   END IF;
   
   Lose_Win_Reason_Api.Exist( newrec_.reason_id, Reason_Used_By_Api.DB_SALES_QUOTATION, lose_win_ );
END;


-- Check_Cancel_Reason_Ref___
--   Perform validation on the CancelReasonRef reference.
PROCEDURE Check_Cancel_Reason_Ref___ (
   newrec_ IN OUT order_quotation_line_tab%ROWTYPE )
IS
BEGIN
   Order_Cancel_Reason_Api.Exist( newrec_.cancel_reason, Reason_Used_By_Api.DB_SALES_QUOTATION );
END;

-- Check_Catalog_No_Ref___
--   Perform validation on the CatalogNoRef reference.
PROCEDURE Check_Catalog_No_Ref___ (
   newrec_ IN OUT NOCOPY order_quotation_line_tab%ROWTYPE )
IS
   usage_   VARCHAR2(20);
BEGIN
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      usage_ := Sales_Type_API.DB_RENTAL_ONLY;
   ELSE
      usage_ := Sales_Type_API.DB_SALES_ONLY;
   END IF;
   Sales_Part_API.Exist(newrec_.contract, newrec_.catalog_no, usage_);
END Check_Catalog_No_Ref___;
   
PROCEDURE Pre_Unpack_Insert___ (
   newrec_   IN OUT NOCOPY order_quotation_line_tab%ROWTYPE,   
   attr_     IN OUT NOCOPY VARCHAR2 )
IS   
   quote_rec_              ORDER_QUOTATION_API.Public_Rec;
   packrec_                ORDER_QUOTATION_LINE_TAB%ROWTYPE;   
   duplicate_line_         BOOLEAN := FALSE;
   temprec_                ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   tax_liability_          VARCHAR2(20);
   delivery_country_db_    VARCHAR2(2);
BEGIN  
   -- Get values from quotation head
   quote_rec_ := ORDER_QUOTATION_API.Get(Client_SYS.Get_Item_Value('QUOTATION_NO', attr_));

   newrec_.customer_no := quote_rec_.customer_no;        

   newrec_.company := Client_SYS.Get_Item_Value('COMPANY', attr_);
   newrec_.contract := Client_SYS.Get_Item_Value('CONTRACT', attr_);

   -- Initialize desired_qty using buy_qty_due
   newrec_.desired_qty := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('BUY_QTY_DUE', attr_));

   newrec_.line_total_weight := 0;
   newrec_.line_total_qty := 0;
   newrec_.ctp_planned := 'N';
   newrec_.sm_connection   := 'NOT CONNECTED';

   IF (Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_)) > 0) THEN
      -- fetch package header line to assign the same values to the component.
      newrec_.quotation_no := Client_SYS.Get_Item_Value('QUOTATION_NO', attr_);
      newrec_.line_no := Client_SYS.Get_Item_Value('LINE_NO', attr_);
      newrec_.rel_no := Client_SYS.Get_Item_Value('REL_NO', attr_);
      packrec_ := Get_Object_By_Keys___(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, -1);
      IF (Client_SYS.Get_Item_Value('SUPPLY_CODE_DB', attr_) NOT IN ('IPD', 'PD')) THEN
         Client_SYS.Set_Item_Value('SHIP_VIA_CODE', packrec_.ship_via_code, attr_);
         Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', packrec_.delivery_leadtime, attr_);
         Client_SYS.Set_Item_Value('PICKING_LEADTIME', packrec_.picking_leadtime, attr_);
      END IF;
      Client_SYS.Set_Item_Value('DEFAULT_ADDR_FLAG_DB', packrec_.default_addr_flag, attr_);
      Client_SYS.Set_Item_Value('SHIP_ADDR_NO', packrec_.ship_addr_no, attr_);
      Client_SYS.Set_Item_Value('SINGLE_OCC_ADDR_FLAG', packrec_.single_occ_addr_flag, attr_);
      Client_SYS.Set_Item_Value('EXT_TRANSPORT_CALENDAR_ID', packrec_.ext_transport_calendar_id, attr_);
      Client_SYS.Set_Item_Value('DELIVERY_TERMS', packrec_.delivery_terms, attr_);
      Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', packrec_.del_terms_location, attr_);
      Client_SYS.Set_Item_Value('TAX_LIABILITY', packrec_.tax_liability, attr_);
      Client_SYS.Set_Item_Value('PROBABILITY_TO_WIN', packrec_.probability_to_win, attr_);
      Client_SYS.Set_Item_Value('QUOTATION_DISCOUNT', packrec_.quotation_discount, attr_ );
      Client_SYS.Set_Item_Value('RELEASE_PLANNING_DB', packrec_.release_planning, attr_ );
      Client_SYS.Set_Item_Value('CHARGED_ITEM_DB', packrec_.charged_item, attr_ );
      Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', packrec_.tax_liability_type, attr_);
   ELSE
      -- Retrive the ship address if any
      newrec_.ship_addr_no := Client_SYS.Get_Item_Value('SHIP_ADDR_NO', attr_);
      IF (NVL(newrec_.ship_addr_no, ' ') != quote_rec_.ship_addr_no) THEN
         -- The ship address for the line is different than the one on the order
         newrec_.default_addr_flag := 'N';
      ELSE
         IF (Client_SYS.Get_Item_Value('EVALUATE_DEFAULT_INFO', attr_) = 'TRUE') THEN
            duplicate_line_ := TRUE;
            attr_ := Client_SYS.Remove_Attr('EVALUATE_DEFAULT_INFO', attr_);
         END IF;
         IF (duplicate_line_) THEN
            temprec_.ship_addr_no              := Client_SYS.Get_Item_Value('SHIP_ADDR_NO', attr_);            
            temprec_.quotation_no              := Client_SYS.Get_Item_Value('QUOTATION_NO', attr_);
            temprec_.default_addr_flag         := Client_SYS.Get_Item_Value('DEFAULT_ADDR_FLAG_DB', attr_);
            temprec_.ship_via_code             := Client_SYS.Get_Item_Value('SHIP_VIA_CODE', attr_);
            temprec_.delivery_terms            := Client_SYS.Get_Item_Value('DELIVERY_TERMS', attr_);
            temprec_.del_terms_location        := Client_SYS.Get_Item_Value('DEL_TERMS_LOCATION', attr_);
            temprec_.forward_agent_id          := Client_SYS.Get_Item_Value('FORWARD_AGENT_ID', attr_);
            temprec_.delivery_leadtime         := Client_SYS.Get_Item_Value('DELIVERY_LEADTIME', attr_);
            temprec_.picking_leadtime          := Client_SYS.Get_Item_Value('PICKING_LEADTIME', attr_);
            temprec_.ext_transport_calendar_id := Client_SYS.Get_Item_Value('EXT_TRANSPORT_CALENDAR_ID', attr_);
            temprec_.freight_map_id            := Client_SYS.Get_Item_Value('FREIGHT_MAP_ID', attr_);
            temprec_.zone_id                   := Client_SYS.Get_Item_Value('ZONE_ID', attr_);
            temprec_.freight_price_list_no     := Client_SYS.Get_Item_Value('FREIGHT_PRICE_LIST_NO', attr_);
            temprec_.tax_liability             := Client_SYS.Get_Item_Value('TAX_LIABILITY', attr_);
            
            temprec_.ship_addr_country_code    := Client_SYS.Get_Item_Value('SHIP_ADDR_COUNTRY_CODE', attr_);
            temprec_.ship_addr_name            := Client_SYS.Get_Item_Value('SHIP_ADDR_NAME', attr_);
            temprec_.ship_address1             := Client_SYS.Get_Item_Value('SHIP_ADDRESS1', attr_);
            temprec_.ship_address2             := Client_SYS.Get_Item_Value('SHIP_ADDRESS2', attr_);
            temprec_.ship_address3             := Client_SYS.Get_Item_Value('SHIP_ADDRESS3', attr_);
            temprec_.ship_address4             := Client_SYS.Get_Item_Value('SHIP_ADDRESS4', attr_);
            temprec_.ship_address5             := Client_SYS.Get_Item_Value('SHIP_ADDRESS5', attr_);
            temprec_.ship_address6             := Client_SYS.Get_Item_Value('SHIP_ADDRESS6', attr_);
            temprec_.ship_addr_zip_code        := Client_SYS.Get_Item_Value('SHIP_ADDR_ZIP_CODE', attr_);
            temprec_.ship_addr_city            := Client_SYS.Get_Item_Value('SHIP_ADDR_CITY', attr_);
            temprec_.ship_addr_state           := Client_SYS.Get_Item_Value('SHIP_ADDR_STATE', attr_);
            temprec_.ship_addr_county          := Client_SYS.Get_Item_Value('SHIP_ADDR_COUNTY', attr_);
            temprec_.ship_addr_in_city         := Client_SYS.Get_Item_Value('SHIP_ADDR_IN_CITY', attr_);
            
            newrec_.default_addr_flag := Check_Default_Addr_Flag__(temprec_, temprec_.quotation_no, temprec_.default_addr_flag);
         END IF;   
      END IF;
      IF (newrec_.default_addr_flag IS NULL) THEN
         newrec_.default_addr_flag := Gen_Yes_No_API.Encode(Client_SYS.Get_Item_Value('DEFAULT_ADDR_FLAG', attr_));
      END IF;
      newrec_.default_addr_flag := NVL(newrec_.default_addr_flag, Client_SYS.Get_Item_Value('DEFAULT_ADDR_FLAG_DB', attr_));
      -- use default value...
      newrec_.default_addr_flag := NVL(newrec_.default_addr_flag, 'Y');

      IF (NVL(Client_SYS.Get_Item_Value('COPY_QUOTATION_LINE', attr_), 'FALSE') = 'FALSE') THEN
         -- if default flag is set, set quotation header values for the delivery address info
         -- ship_via_code, ship_via_desc and delivery_leadtime should not be set at this time, they
         -- will get their values when calling Get_Supply_Chain_Defaults___
         IF (newrec_.default_addr_flag = 'Y') THEN
            Client_SYS.Set_Item_Value('SHIP_ADDR_NO', quote_rec_.ship_addr_no, attr_);
            Client_SYS.Set_Item_Value('SINGLE_OCC_ADDR_FLAG', quote_rec_.single_occ_addr_flag, attr_);
            Client_SYS.Set_Item_Value('DELIVERY_TERMS', quote_rec_.delivery_terms, attr_);
            Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', quote_rec_.del_terms_location, attr_);
            Client_SYS.Set_Item_Value('TAX_LIABILITY', quote_rec_.tax_liability, attr_);
            Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', quote_rec_.forward_agent_id, attr_);
            Client_SYS.Set_Item_Value('FREIGHT_MAP_ID', quote_rec_.freight_map_id, attr_);
            Client_SYS.Set_Item_Value('ZONE_ID', quote_rec_.zone_id, attr_);
            Client_SYS.Set_Item_Value('FREIGHT_PRICE_LIST_NO', quote_rec_.freight_price_list_no, attr_);
            Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', Tax_Liability_API.Get_Tax_Liability_Type_Db(quote_rec_.tax_liability, quote_rec_.country_code), attr_);
         ELSE
            IF (Client_SYS.Get_Item_Value('TAX_LIABILITY', attr_) IS NULL) THEN
               Client_SYS.Set_Item_Value('TAX_LIABILITY', Tax_Handling_Util_API.Get_Customer_Tax_Liability(newrec_.customer_no, newrec_.ship_addr_no, quote_rec_.company, quote_rec_.supply_country), attr_);
            END IF;	

            tax_liability_       := Client_SYS.Get_Item_Value('TAX_LIABILITY', attr_);
            delivery_country_db_  := NVL(newrec_.ship_addr_country_code, Cust_Ord_Customer_Address_API.Get_Country_Code(newrec_.customer_no, newrec_.ship_addr_no));

            Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_liability_, delivery_country_db_), attr_);
         END IF;
      END IF;
   END IF;

   newrec_.conv_factor := 1;
   newrec_.inverted_conv_factor := 1; 
END Pre_Unpack_Insert___;


PROCEDURE Pre_Unpack_Update___ (
   newrec_   IN OUT NOCOPY order_quotation_line_tab%ROWTYPE,   
   attr_     IN OUT NOCOPY VARCHAR2 )
IS 
   ptr_                         NUMBER;
   name_                        VARCHAR2(30);
   value_                       VARCHAR2(4000);
   quote_rec_                   ORDER_QUOTATION_API.Public_Rec;
   oldrec_                      ORDER_QUOTATION_LINE_TAB%ROWTYPE;   
   new_default_addr_flag_       ORDER_QUOTATION_LINE_TAB.default_addr_flag%TYPE;     
   addr_flag_changed_in_client_ BOOLEAN := TRUE;
   copy_addr_to_line_          VARCHAR2(10) := 'FALSE';
BEGIN   
   -- Get values from quotation head
   quote_rec_ := ORDER_QUOTATION_API.Get(newrec_.quotation_no);

   oldrec_ := newrec_;
   
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
   -- Added new condition to check if the sales price should be copied from another object and
   -- if so to get the sales price by converting the base price.
      IF (newrec_.rowstate = 'Cancelled') THEN
         IF (name_ NOT IN ('CANCEL_REASON', 'NOTE_TEXT')) THEN
            Error_SYS.Record_General(lu_name_, 'CANTMODIFYCANLINE: Cancelled order quotation line may not be modified.');
         END IF;
      END IF;
   END LOOP;

   -- Get company
   newrec_.company := Client_SYS.Get_Item_Value( 'COMPANY', attr_ );
   IF (newrec_.company IS NULL) THEN
      newrec_.company := oldrec_.company;
   END IF;

   -- Get site
   newrec_.contract := Client_SYS.Get_Item_Value( 'CONTRACT', attr_ );
   IF (newrec_.contract IS NULL) THEN
      newrec_.contract := oldrec_.contract;
   END IF;
   IF (newrec_.ship_addr_no IS NULL) THEN
      newrec_.ship_addr_no := quote_rec_.ship_addr_no;
   END IF;

   -- Get if non default add lines should be chaged to the header's address
   IF Client_SYS.Item_Exist('COPY_ADDR_TO_LINE', attr_) THEN 
      copy_addr_to_line_ := Client_SYS.Get_Item_Value('COPY_ADDR_TO_LINE', attr_);
   END IF; 
   
   -- fetch new default flag from attr
   new_default_addr_flag_ := Client_SYS.Get_Item_Value('DEFAULT_ADDR_FLAG_DB', attr_);
   IF (new_default_addr_flag_ IS NULL) THEN
      new_default_addr_flag_ := Gen_Yes_No_API.Encode(Client_SYS.Get_Item_Value('DEFAULT_ADDR_FLAG', attr_));
   END IF;
   -- if not found, use old flag value
   IF (new_default_addr_flag_ IS NULL) THEN
      new_default_addr_flag_ := oldrec_.default_addr_flag;
       IF (newrec_.ship_addr_no != quote_rec_.ship_addr_no ) AND (new_default_addr_flag_  = 'Y') THEN
         addr_flag_changed_in_client_ := TRUE;
      ELSE
         addr_flag_changed_in_client_ := FALSE;
      END IF;
   END IF;
   
   -- Ignore cancelled, CO Created, won and lost order lines when modifying delivery terms.
    IF (new_default_addr_flag_ = 'Y' AND newrec_.rowstate NOT IN ('Cancelled', 'Lost', 'Won', 'CO Created')) THEN
      IF (addr_flag_changed_in_client_) THEN
         -- Copy Delivery Info to the line
         Copy_Delivery_Info_To_Line___(attr_, quote_rec_);
         Remove_Single_Occ_Addr_Line___(newrec_);
      END IF;
   END IF;
END Pre_Unpack_Update___;


-- Copy_Delivery_Info_To_Line___
-- Copy the delivery info data from the quotation header to the quotation line.
PROCEDURE Copy_Delivery_Info_To_Line___ (
   attr_ IN OUT VARCHAR2,
   quote_rec_ IN Order_Quotation_API.Public_Rec)
IS
BEGIN
   Client_SYS.Set_Item_Value('SHIP_ADDR_NO', quote_rec_.ship_addr_no, attr_);
   Client_SYS.Set_Item_Value('SINGLE_OCC_ADDR_FLAG', quote_rec_.single_occ_addr_flag, attr_);
   Client_SYS.Set_Item_Value('SHIP_VIA_CODE', quote_rec_.ship_via_code, attr_);
   Client_SYS.Set_Item_Value('EXT_TRANSPORT_CALENDAR_ID', quote_rec_.ext_transport_calendar_id, attr_);
   Client_SYS.Set_Item_Value('DELIVERY_TERMS', quote_rec_.delivery_terms, attr_);
   Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', quote_rec_.del_terms_location, attr_);
   Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', quote_rec_.delivery_leadtime, attr_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY', quote_rec_.tax_liability, attr_);
   Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', quote_rec_.forward_agent_id, attr_);
   Client_SYS.Set_Item_Value('FREIGHT_MAP_ID', quote_rec_.freight_map_id, attr_);
   Client_SYS.Set_Item_Value('ZONE_ID', quote_rec_.zone_id, attr_);
   Client_SYS.Set_Item_Value('FREIGHT_PRICE_LIST_NO', quote_rec_.freight_price_list_no, attr_);
   Client_SYS.Set_Item_Value('PICKING_LEADTIME', quote_rec_.picking_leadtime, attr_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', Tax_Liability_API.Get_Tax_Liability_Type_Db(quote_rec_.tax_liability, quote_rec_.country_code), attr_);
END Copy_Delivery_Info_To_Line___;


PROCEDURE Copy_Singl_Occ_Addr_To_Line___ (
   newrec_    IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   quote_rec_ IN Order_Quotation_API.Public_Rec)
IS
BEGIN
   newrec_.ship_address1 := quote_rec_.ship_address1;
   newrec_.ship_address2 := quote_rec_.ship_address2;
   newrec_.ship_address3 := quote_rec_.ship_address3;
   newrec_.ship_address4 := quote_rec_.ship_address4;
   newrec_.ship_address5 := quote_rec_.ship_address5;
   newrec_.ship_address6 := quote_rec_.ship_address6;
   newrec_.ship_addr_name := quote_rec_.ship_addr_name;
   newrec_.ship_addr_zip_code := quote_rec_.ship_addr_zip_code;
   newrec_.ship_addr_city := quote_rec_.ship_addr_city;
   newrec_.ship_addr_state := quote_rec_.ship_addr_state;
   newrec_.ship_addr_county := quote_rec_.ship_addr_county;
   newrec_.ship_addr_country_code := quote_rec_.ship_addr_country_code;
   newrec_.ship_addr_in_city := quote_rec_.ship_addr_in_city;
END Copy_Singl_Occ_Addr_To_Line___;


-- Remove_Single_Occ_Addr_Line___
-- Remove the quotation line single occurrence address.
-- Set all fields empty and ship_addr_in_city checkbox to FALSE.
PROCEDURE Remove_Single_Occ_Addr_Line___ (
   newrec_ IN OUT ORDER_QUOTATION_LINE_TAB%ROWTYPE)
IS
BEGIN
   newrec_.ship_address1 := '';
   newrec_.ship_address2 := '';
   newrec_.ship_address3 := '';
   newrec_.ship_address4 := '';
   newrec_.ship_address5 := '';
   newrec_.ship_address6 := '';
   newrec_.ship_addr_name := '';
   newrec_.ship_addr_zip_code := '';
   newrec_.ship_addr_city := '';
   newrec_.ship_addr_state := '';
   newrec_.ship_addr_county := '';
   newrec_.ship_addr_country_code := '';
   newrec_.ship_addr_in_city := Fnd_Boolean_API.DB_FALSE;
END Remove_Single_Occ_Addr_Line___;

-- Delivery_Info_Match___
-- Check if quotation line delivery info is identical to the quotation header.
FUNCTION Delivery_Info_Match___(
   line_rec_ IN ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   head_rec_ IN Order_Quotation_API.Public_Rec) RETURN BOOLEAN    
IS
BEGIN
   IF (Validate_SYS.Is_Equal(head_rec_.ship_via_code, line_rec_.ship_via_code) AND
       Validate_SYS.Is_Equal(head_rec_.delivery_terms, line_rec_.delivery_terms) AND
       Validate_SYS.Is_Equal(head_rec_.del_terms_location, line_rec_.del_terms_location) AND
       Validate_SYS.Is_Equal(head_rec_.forward_agent_id, line_rec_.forward_agent_id) AND
       Validate_SYS.Is_Equal(head_rec_.delivery_leadtime, line_rec_.delivery_leadtime) AND
       Validate_SYS.Is_Equal(head_rec_.picking_leadtime, line_rec_.picking_leadtime) AND
       Validate_SYS.Is_Equal(head_rec_.ext_transport_calendar_id, line_rec_.ext_transport_calendar_id) AND
       Validate_SYS.Is_Equal(head_rec_.freight_map_id, line_rec_.freight_map_id) AND
       Validate_SYS.Is_Equal(head_rec_.zone_id, line_rec_.zone_id) AND
       Validate_SYS.Is_Equal(head_rec_.freight_price_list_no, line_rec_.freight_price_list_no) AND
       Validate_SYS.Is_Equal(head_rec_.tax_liability, line_rec_.tax_liability)) THEN 
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Delivery_Info_Match___;


-- Single_Occ_Addr_Match_Quot___
-- Returns TRUE if the single occurrence address of the quotation header and the quotation line is identical.
FUNCTION Single_Occ_Addr_Match_Quot___ (
   line_rec_ IN ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   head_rec_ IN Order_Quotation_API.Public_Rec) RETURN BOOLEAN
IS
BEGIN
   IF (Is_Single_Occ_Addr_Empty___(line_rec_)) THEN
      -- The line does not have any single occurrence address data
      RETURN FALSE;
   ELSE
      -- Check if the line single occurrence differs from the quot header singel occurrence address.
      IF (Validate_SYS.Is_Different(head_rec_.ship_addr_country_code, line_rec_.ship_addr_country_code) OR
          Validate_SYS.Is_Different(head_rec_.ship_addr_name, line_rec_.ship_addr_name) OR
          Validate_SYS.Is_Different(head_rec_.ship_address1, line_rec_.ship_address1) OR
          Validate_SYS.Is_Different(head_rec_.ship_address2, line_rec_.ship_address2) OR
          Validate_SYS.Is_Different(head_rec_.ship_address3, line_rec_.ship_address3) OR
          Validate_SYS.Is_Different(head_rec_.ship_address4, line_rec_.ship_address4) OR
          Validate_SYS.Is_Different(head_rec_.ship_address5, line_rec_.ship_address5) OR
          Validate_SYS.Is_Different(head_rec_.ship_address6, line_rec_.ship_address6) OR
          Validate_SYS.Is_Different(head_rec_.ship_addr_zip_code, line_rec_.ship_addr_zip_code) OR
          Validate_SYS.Is_Different(head_rec_.ship_addr_city, line_rec_.ship_addr_city) OR
          Validate_SYS.Is_Different(head_rec_.ship_addr_state, line_rec_.ship_addr_state) OR
          Validate_SYS.Is_Different(head_rec_.ship_addr_county, line_rec_.ship_addr_county) OR
          Validate_SYS.Is_Different(head_rec_.ship_addr_in_city, line_rec_.ship_addr_in_city)) THEN
         RETURN FALSE;
      ELSE
         RETURN TRUE;
      END IF;
   END IF;
END Single_Occ_Addr_Match_Quot___;


-- Is_Single_Occ_Addr_Empty___
-- Check if the quotation line has single occurrence address data.
FUNCTION Is_Single_Occ_Addr_Empty___(
   line_rec_ IN ORDER_QUOTATION_LINE_TAB%ROWTYPE) RETURN BOOLEAN
IS
BEGIN
   -- If all address fields are empty, return TRUE.
   IF (line_rec_.ship_addr_country_code IS NULL AND
       line_rec_.ship_addr_name IS NULL AND
       line_rec_.ship_address1 IS NULL AND
       line_rec_.ship_address2 IS NULL AND
       line_rec_.ship_address3 IS NULL AND
       line_rec_.ship_address4 IS NULL AND
       line_rec_.ship_address5 IS NULL AND
       line_rec_.ship_address6 IS NULL AND
       line_rec_.ship_addr_zip_code IS NULL AND
       line_rec_.ship_addr_city IS NULL AND
       line_rec_.ship_addr_state IS NULL AND
       line_rec_.ship_addr_county IS NULL) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Single_Occ_Addr_Empty___;

-- Is_Number___
--   Method checkes whether the passes string is a numeric value.
--   Returns TRUE if it is a numeric value, FALSE otherwise.
FUNCTION Is_Number___ (
   string_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   c_    NUMBER;
BEGIN
   FOR i_ IN 1..LENGTH( string_ ) LOOP
      c_ := ASCII( SUBSTR( string_, i_, 1 ) );
      IF ( c_ < ASCII( '0' ) OR c_ > ASCII( '9' ) ) THEN
         RETURN FALSE;
      END IF;
   END LOOP;
   RETURN TRUE;
END Is_Number___;

PROCEDURE Modify_Quote_Line_Defaults___ (
   attr_                        IN OUT VARCHAR2, 
   default_addr_flag_           IN ORDER_QUOTATION_LINE_TAB.default_addr_flag%TYPE,
   delivery_type_               IN ORDER_QUOTATION_LINE_TAB.delivery_type%TYPE,
   oldrec_                      IN ORDER_QUOTATION_LINE_TAB%ROWTYPE, 
   quote_rec_                   IN ORDER_QUOTATION_API.Public_Rec,
   refresh_vat_free_vat_code_   IN VARCHAR2,
   single_occ_addr_changed_     IN BOOLEAN DEFAULT FALSE,
   customer_changed_            IN BOOLEAN DEFAULT FALSE,
   update_tax_                  IN BOOLEAN DEFAULT TRUE)
IS
   vat_free_vat_code_ VARCHAR2(20);
   tax_method_        VARCHAR2(50);
   tax_liability_type_  tax_liability_tab.tax_liability_type%TYPE;
BEGIN
   -- If customer change both default and non-default info lines should get update from header.
   IF (default_addr_flag_ = 'Y') OR customer_changed_ THEN
      IF (NVL(oldrec_.customer_no, Database_SYS.string_null_) != NVL(quote_rec_.customer_no, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('CUSTOMER_NO', quote_rec_.customer_no, attr_);
      END IF;

      IF (NVL(oldrec_.delivery_terms, Database_SYS.string_null_) != NVL(quote_rec_.delivery_terms, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('DELIVERY_TERMS', quote_rec_.delivery_terms, attr_);
      END IF;

      IF (NVL(oldrec_.del_terms_location, Database_SYS.string_null_) != NVL(quote_rec_.del_terms_location, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', quote_rec_.del_terms_location, attr_);
      END IF;

      IF (NVL(oldrec_.ship_addr_no, Database_SYS.string_null_) != NVL(quote_rec_.ship_addr_no, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('SHIP_ADDR_NO', quote_rec_.ship_addr_no, attr_);
      END IF;

      IF (NVL(oldrec_.ship_via_code, Database_SYS.string_null_) != NVL(quote_rec_.ship_via_code, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('SHIP_VIA_CODE', quote_rec_.ship_via_code, attr_);
      END IF;

      IF (NVL(oldrec_.ext_transport_calendar_id, Database_SYS.string_null_) != NVL(quote_rec_.ext_transport_calendar_id, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('EXT_TRANSPORT_CALENDAR_ID', quote_rec_.ext_transport_calendar_id, attr_);
      END IF;

      IF (NVL(oldrec_.delivery_leadtime, '0') != NVL(quote_rec_.delivery_leadtime, '0')) THEN
         Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', quote_rec_.delivery_leadtime, attr_);
      END IF;

      IF (NVL(oldrec_.picking_leadtime, '0') != NVL(quote_rec_.picking_leadtime, '0')) THEN
         Client_SYS.Set_Item_Value('PICKING_LEADTIME', quote_rec_.picking_leadtime, attr_);
      END IF;

      tax_liability_type_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(quote_rec_.tax_liability, quote_rec_.country_code);
      IF (NVL(oldrec_.tax_liability, Database_SYS.string_null_) != NVL(quote_rec_.tax_liability, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('TAX_LIABILITY', quote_rec_.tax_liability, attr_);
         Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', tax_liability_type_, attr_);
      END IF;

      IF (NVL(oldrec_.forward_agent_id, Database_SYS.string_null_) != NVL(quote_rec_.forward_agent_id, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', quote_rec_.forward_agent_id, attr_);
      END IF;

      IF (NVL(oldrec_.freight_map_id, Database_SYS.string_null_) != NVL(quote_rec_.freight_map_id, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('FREIGHT_MAP_ID', quote_rec_.freight_map_id, attr_);
      END IF;

      IF (NVL(oldrec_.zone_id, Database_SYS.string_null_) != NVL(quote_rec_.zone_id, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('ZONE_ID', quote_rec_.zone_id, attr_);
      END IF;

      IF (NVL(oldrec_.freight_price_list_no, Database_SYS.string_null_) != NVL(quote_rec_.freight_price_list_no, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('FREIGHT_PRICE_LIST_NO', quote_rec_.freight_price_list_no, attr_);
      END IF;       

      IF (NVL(oldrec_.single_occ_addr_flag, Database_SYS.string_null_) != NVL(quote_rec_.single_occ_addr_flag, Database_SYS.string_null_)) THEN 
         Client_SYS.Set_Item_Value('SINGLE_OCC_ADDR_FLAG', quote_rec_.single_occ_addr_flag, attr_);
      END IF;
   
      IF (single_occ_addr_changed_) THEN
         Client_SYS.Set_Item_Value('SINGLE_OCC_ADDR_CHANGED', 'TRUE', attr_);
      END IF;
      
      IF (refresh_vat_free_vat_code_ = 'TRUE' AND Sales_Part_API.Get_Taxable_Db(quote_rec_.contract, oldrec_.catalog_no) != Fnd_Boolean_API.DB_FALSE) THEN
         IF (tax_liability_type_ = 'EXM') THEN
            vat_free_vat_code_ := Customer_Tax_Free_Tax_Code_API.Get_Tax_Free_Tax_Code(quote_rec_.customer_no, quote_rec_.ship_addr_no, quote_rec_.company, quote_rec_.supply_country, NVL(delivery_type_, '*'));
         END IF;
         IF vat_free_vat_code_ IS NOT NULL THEN 
            Client_SYS.Set_Item_Value('TAX_CODE', vat_free_vat_code_, attr_);            
         END IF;
         Client_SYS.Set_Item_Value('SUPPLY_COUNTRY_CHANGED', 'TRUE', attr_);
      END IF;
      
      tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(quote_rec_.company);
      -- gelr:br_external_tax_integration, begin
      IF (tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN
         -- Avalara Brazil only supports Customer Order lines and Invoice lines in initial release
         tax_method_ := External_Tax_Calc_Method_API.DB_NOT_USED;
      END IF;
      -- gelr:br_external_tax_integration, end
      
      IF NOT update_tax_ THEN
         Client_SYS.Set_Item_Value('UPDATE_TAX', 'FALSE', attr_);
      ELSIF ((tax_method_ = External_Tax_Calc_Method_API.DB_NOT_USED) AND (tax_liability_type_ = 'EXM')) THEN
         Client_SYS.Set_Item_Value('UPDATE_TAX', 'TRUE', attr_);
      END IF;
   END IF;
END Modify_Quote_Line_Defaults___;

-- Prepare_Rental___
--   This method prepares default values to rental attrbutes.
PROCEDURE Prepare_Rental___ (
   attr_ IN OUT VARCHAR2)
IS
BEGIN
   $IF Component_Rental_SYS.INSTALLED $THEN
      Rental_Object_API.Prepare(attr_,
                                Rental_Type_API.DB_ORDER_QUOTATION);
   $ELSE
      Error_SYS.Component_Not_Exist('RENTAL');                                
   $END
END Prepare_Rental___;

-- New_Rental___
--   This method inserts a new rental record.
PROCEDURE New_Rental___ (
   attr_   IN VARCHAR2,
   newrec_ IN ORDER_QUOTATION_LINE_TAB%ROWTYPE)
IS
BEGIN
   $IF Component_Rental_SYS.INSTALLED $THEN
      Rental_Object_API.New(newrec_.quotation_no,
                            newrec_.line_no,
                            newrec_.rel_no,
                            newrec_.line_item_no,
                            Rental_Type_API.DB_ORDER_QUOTATION,
                            newrec_.contract,
                            attr_);
   $ELSE
      Error_SYS.Component_Not_Exist('RENTAL');
   $END
END New_Rental___;

-- Modify_Rental___
--   This method modifies a rental record.
PROCEDURE Modify_Rental___ (
   attr_   IN VARCHAR2,
   newrec_ IN ORDER_QUOTATION_LINE_TAB%ROWTYPE)
IS
BEGIN
    $IF Component_Rental_SYS.INSTALLED $THEN
       Rental_Object_API.Modify(newrec_.quotation_no,
                                newrec_.line_no,
                                newrec_.rel_no,
                                newrec_.line_item_no,
                                Rental_Type_API.DB_ORDER_QUOTATION,
                                attr_);
    $ELSE
       Error_SYS.Component_Not_Exist('RENTAL');
    $END
END Modify_Rental___;

-- Remove_Rental___
--   This method removes a rental record.
PROCEDURE Remove_Rental___ (
   remrec_ IN ORDER_QUOTATION_LINE_TAB%ROWTYPE)
IS
BEGIN
   $IF Component_Rental_SYS.INSTALLED $THEN
      Rental_Object_API.Remove(remrec_.quotation_no,
                               remrec_.line_no,
                               remrec_.rel_no,
                               remrec_.line_item_no,
                               Rental_Type_API.DB_ORDER_QUOTATION);
   $ELSE
      Error_SYS.Component_Not_Exist('RENTAL');
   $END
END Remove_Rental___;

-- Get_Rental_Chargeable_Days___
--   This method calculates and return rental chargeable days
--   for given rental references. This method should be used only for rental line.
--   Otherwise Get_Rental_Chargeable_Days public method must be used.
FUNCTION Get_Rental_Chargeable_Days___ (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   rental_chargeable_days_ NUMBER;
BEGIN
   $IF Component_Rental_SYS.INSTALLED $THEN
      rental_chargeable_days_ := Rental_Object_API.Get_Rental_Chargeable_Days(quotation_no_,
                                                                              line_no_,
                                                                              rel_no_,
                                                                              line_item_no_,
                                                                              Rental_Type_API.DB_ORDER_QUOTATION);
   $END
   RETURN rental_chargeable_days_;
END Get_Rental_Chargeable_Days___;

-- Get_Latest_Rent_Charge_Days___
--   This method calculates and return rental chargable days
--   from the modified rental attribute value
FUNCTION Get_Latest_Rent_Charge_Days___ (
   attr_    IN VARCHAR2,
   newrec_  IN ORDER_QUOTATION_LINE_TAB%ROWTYPE) RETURN NUMBER
IS
   rental_chargeable_days_ NUMBER;
BEGIN
   $IF Component_Rental_SYS.INSTALLED $THEN
      rental_chargeable_days_ := Rental_Object_API.Get_Rental_Chargeable_Days(newrec_.quotation_no,
                                                                              newrec_.line_no,
                                                                              newrec_.rel_no,
                                                                              newrec_.line_item_no,
                                                                              Rental_Type_API.DB_ORDER_QUOTATION,
                                                                              attr_);
   $END
   RETURN NVL(rental_chargeable_days_, 1);
END Get_Latest_Rent_Charge_Days___;

-- Build_Attr_For_Create_Line___ 
-- This method is used to build the attr_ which is used in method Create_Line___. 
FUNCTION Build_Attr_For_Create_Line___ (	
   rec_              IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   header_rec_       IN     ORDER_QUOTATION_API.Public_Rec,
   con_order_no_     IN     VARCHAR2,
   con_line_no_      IN     VARCHAR2,
   con_rel_no_       IN     VARCHAR2,
   con_line_item_no_ IN     NUMBER,
   delivery_date_    IN     DATE DEFAULT NULL) RETURN VARCHAR2
IS
   attr_                   VARCHAR2(32000);
   inv_part_cost_level_db_ VARCHAR2(50);
   alloc_assign_flag_      VARCHAR2(200);
   tax_method_             VARCHAR2(50);   
  -- gelr:disc_price_rounded, begin
   discounted_price_rounded_      BOOLEAN := Order_Quotation_API.Get_Discounted_Price_Rounded(header_rec_.quotation_no);
   -- gelr:disc_price_rounded, end
   
BEGIN
   Client_SYS.Clear_Attr( attr_ );
   Client_SYS.Add_To_Attr( 'ORDER_NO', con_order_no_, attr_ );
   IF (rec_.line_item_no > 0) THEN
      -- Package component
      Client_SYS.Add_To_Attr('LINE_NO', con_line_no_, attr_);
      Client_SYS.Add_To_Attr('REL_NO', con_rel_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_ITEM_NO', con_line_item_no_, attr_);
   ELSE
      Client_SYS.Add_To_Attr('LINE_NO', rec_.line_no, attr_);
      Client_SYS.Add_To_Attr('REL_NO', rec_.rel_no, attr_);
      Client_SYS.Add_To_Attr('LINE_ITEM_NO', rec_.line_item_no, attr_);
   END IF;
   Client_SYS.Add_To_Attr('BUY_QTY_DUE', rec_.buy_qty_due, attr_);
   Client_SYS.Add_To_Attr('CALC_CHAR_PRICE', rec_.calc_char_price, attr_);
   Client_SYS.Add_To_Attr('CATALOG_DESC', rec_.catalog_desc, attr_);
   Client_SYS.Add_To_Attr('CATALOG_NO', rec_.catalog_no, attr_);
   Client_SYS.Add_To_Attr('CHAR_PRICE', rec_.char_price, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   Client_SYS.Add_To_Attr('CONV_FACTOR', rec_.conv_factor, attr_);
   Client_SYS.Add_To_Attr('INVERTED_CONV_FACTOR', rec_.inverted_conv_factor, attr_);
   inv_part_cost_level_db_ := Inventory_Part_API.Get_Invent_Part_Cost_Level_Db(rec_.contract, rec_.part_no);
   IF (inv_part_cost_level_db_ = 'COST PER CONFIGURATION') THEN
      Client_SYS.Add_To_Attr('COST', rec_.cost, attr_);
   END IF;
   Client_SYS.Add_To_Attr('CTP_PLANNED_DB', rec_.ctp_planned, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PART_BUY_QTY', rec_.customer_part_buy_qty, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PART_CONV_FACTOR', rec_.customer_part_conv_factor, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PART_NO', rec_.customer_part_no, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PART_UNIT_MEAS', rec_.customer_part_unit_meas, attr_);
   Client_SYS.Add_To_Attr('CUST_WARRANTY_ID', rec_.cust_warranty_id, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TYPE', rec_.delivery_type, attr_);
   Client_SYS.Add_To_Attr('DESIRED_QTY', rec_.desired_qty, attr_);
   -- gelr:disc_price_rounded:DIS005, begin
   -- 1. During order line creation discount will be recalculated in the same way as form user entry, therefore need enter original value here
   -- 2. On the other hand, for setting discount unrounded original_discount = discount
   IF (discounted_price_rounded_) THEN
      Client_SYS.Add_To_Attr('DISCOUNT', rec_.original_discount, attr_);
   ELSE   
      Client_SYS.Add_To_Attr('DISCOUNT', rec_.discount, attr_);
   END IF;   
   -- gelr:disc_price_rounded:DIS005, end   
   Client_SYS.Add_To_Attr('LATEST_RELEASE_DATE', rec_.latest_release_date, attr_);
   Client_SYS.Add_To_Attr('TAX_CODE', rec_.tax_code, attr_);
   Client_SYS.Add_To_Attr('TAX_CLASS_ID', rec_.tax_class_id, attr_);
   Client_SYS.Add_To_Attr('LINE_TOTAL_QTY', rec_.line_total_qty, attr_);
   Client_SYS.Add_To_Attr('LINE_TOTAL_WEIGHT', rec_.line_total_weight, attr_);
   Client_SYS.Add_To_Attr('NOTE_ID', rec_.note_id, attr_);
   Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   -- gelr:disc_price_rounded:DIS005, begin
   IF (discounted_price_rounded_) THEN
      Client_SYS.Add_To_Attr('ORDER_DISCOUNT', rec_.original_quotation_discount, attr_);
   ELSE
      Client_SYS.Add_To_Attr('ORDER_DISCOUNT', rec_.quotation_discount, attr_);
   END IF;   
   -- gelr:disc_price_rounded:DIS005, end   Client_SYS.Add_To_Attr('ORIGINAL_PART_NO', rec_.original_part_no, attr_);
   Client_SYS.Add_To_Attr('PART_NO', rec_.part_no, attr_);
   Client_SYS.Add_To_Attr('PART_PRICE', rec_.part_price, attr_);
   Client_SYS.Add_To_Attr('PRICE_UNIT_MEAS', rec_.price_unit_meas, attr_);

   Client_SYS.Add_To_Attr('PLANNED_DUE_DATE', rec_.planned_due_date, attr_);
   Client_SYS.Add_To_Attr('PRICE_CONV_FACTOR', rec_.price_conv_factor, attr_);
   Client_SYS.Add_To_Attr('PRICE_FREEZE_DB', rec_.price_freeze, attr_);
   Client_SYS.Add_To_Attr('PRICE_LIST_NO', rec_.price_list_no, attr_);
   Client_SYS.Add_To_Attr('PRICE_SOURCE_DB', rec_.price_source, attr_);
   Client_SYS.Add_To_Attr('PRICE_SOURCE_ID', rec_.price_source_id, attr_);
   Client_SYS.Add_To_Attr('PART_LEVEL_DB', rec_.part_level, attr_);
   Client_SYS.Add_To_Attr('PART_LEVEL_ID', rec_.part_level_id, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_DB', rec_.customer_level, attr_);   
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_ID', rec_.customer_level_id, attr_);   
   Client_SYS.Add_To_Attr('REVISED_QTY_DUE', rec_.revised_qty_due, attr_);
   Client_SYS.Add_To_Attr('SALES_UNIT_MEAS', rec_.sales_unit_measure, attr_);
   Client_SYS.Add_To_Attr('SALE_UNIT_PRICE', rec_.sale_unit_price, attr_);
   Client_SYS.Add_To_Attr('UNIT_PRICE_INCL_TAX', rec_.unit_price_incl_tax, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_ADDR_FLAG_DB', rec_.default_addr_flag, attr_);
   Client_SYS.Add_To_Attr('TAX_LIABILITY', rec_.tax_liability, attr_);
   Client_SYS.Add_To_Attr('SHIP_ADDR_NO', rec_.ship_addr_no, attr_);
   IF rec_.end_customer_id IS NOT NULL THEN
      Client_SYS.Add_To_Attr('END_CUSTOMER_ID', rec_.end_customer_id, attr_);
   END IF;
   Client_SYS.Add_To_Attr('SHIP_VIA_CODE', rec_.ship_via_code, attr_);
   Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', rec_.ext_transport_calendar_id, attr_);
   IF (rec_.delivery_terms IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DELIVERY_TERMS', rec_.delivery_terms, attr_);
   END IF;
   IF (rec_.del_terms_location IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', rec_.del_terms_location, attr_);
   END IF;
   Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', rec_.forward_agent_id, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', rec_.delivery_leadtime, attr_);
   Client_SYS.Add_To_Attr('PICKING_LEADTIME', rec_.picking_leadtime, attr_);
   Client_SYS.Add_To_Attr('SUPPLY_CODE_DB', rec_.order_supply_type, attr_);

   IF header_rec_.b2b_order = 'TRUE' THEN
      alloc_assign_flag_ := Inventory_Part_API.Get_Oe_Alloc_Assign_Flag(rec_.contract, rec_.catalog_no);
      IF (alloc_assign_flag_ = Cust_Ord_Reservation_Type_API.Decode('N')) THEN
         alloc_assign_flag_ := Cust_Order_Type_API.Get_Oe_Alloc_Assign_Flag(Customer_Order_API.Get_Order_Id(con_order_no_));
      END IF;
      -- NOTE: Once the CO is created, this value for package part lines cannot be changed.
      --       Therefore it was made TRUE only for PKG lines so the CO can be released without any errors.
      --       If there is priority reservation enabled to either part or order type, when the CO line created it will be reserved.
      --       If REL_MTRL_PLANNING is FALSE an error will be raised and the CO will not be created. Hence it is set to TRUE when priority reservation is enabled.
      IF rec_.line_item_no = -1 OR NOT(Inventory_Part_API.Check_Stored(rec_.contract, rec_.catalog_no)) OR (alloc_assign_flag_ = Cust_Ord_Reservation_Type_API.Decode('Y')) THEN
         Client_SYS.Add_To_Attr('REL_MTRL_PLANNING', 'TRUE' , attr_);
      ELSE
         Client_SYS.Add_To_Attr('REL_MTRL_PLANNING', 'FALSE' , attr_);
      END IF;
   ELSE
      IF (Part_Catalog_API.Get_Configurable_Db(rec_.part_no) = 'CONFIGURED' AND rec_.order_supply_type = 'IO' ) THEN  
         IF (rec_.release_planning = 'RELEASED') THEN
            Client_SYS.Add_To_Attr('REL_MTRL_PLANNING', 'TRUE' , attr_);
         ELSE
            Client_SYS.Add_To_Attr('REL_MTRL_PLANNING', 'FALSE' , attr_);  
         END IF;
      END IF;
   END IF;

   IF (rec_.vendor_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('VENDOR_NO', rec_.vendor_no, attr_);
   END IF;

   IF (header_rec_.price_effectivity_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PRICE_EFFECTIVITY_DATE', header_rec_.price_effectivity_date, attr_);
   END IF;
   IF (delivery_date_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', delivery_date_, attr_);
      Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE', delivery_date_, attr_);
      Client_SYS.Add_To_Attr('PROMISED_DELIVERY_DATE', delivery_date_, attr_);
   ELSE  -- copy the line delivery dates to customer order
      Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', rec_.wanted_delivery_date, attr_);
      IF (rec_.promised_delivery_date IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('PROMISED_DELIVERY_DATE', rec_.promised_delivery_date, attr_);
      END IF;
      IF (rec_.planned_delivery_date IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE', rec_.planned_delivery_date, attr_);
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('DEMAND_CODE_DB', 'CQ', attr_);
   Client_SYS.Add_To_Attr('DEMAND_ORDER_REF1', rec_.quotation_no, attr_);
   Client_SYS.Add_To_Attr('DEMAND_ORDER_REF2', rec_.line_no, attr_);
   Client_SYS.Add_To_Attr('DEMAND_ORDER_REF3', rec_.rel_no, attr_);
   Client_SYS.Add_To_Attr('DEMAND_ORDER_REF4', rec_.line_item_no, attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT', Cust_Ord_Customer_Address_API.Get_Intrastat_Exempt(rec_.customer_no, rec_.ship_addr_no), attr_);
   Client_SYS.Add_To_Attr('CONDITION_CODE', rec_.condition_code, attr_);
   Client_SYS.Add_To_Attr('CONFIGURATION_ID', rec_.configuration_id, attr_);
   Client_SYS.Add_To_Attr('TAX_CODE', rec_.tax_code, attr_);
   Client_SYS.Add_To_Attr('TAX_CLASS_ID', rec_.tax_class_id, attr_);
   Client_SYS.Add_To_Attr( 'DEFAULT_CHARGES', 'FALSE', attr_);

   IF (rec_.classification_standard IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CLASSIFICATION_STANDARD', rec_.classification_standard, attr_);
   END IF;   
   Client_SYS.Add_To_Attr('CLASSIFICATION_PART_NO', rec_.classification_part_no, attr_);
   Client_SYS.Add_To_Attr('CLASSIFICATION_UNIT_MEAS', rec_.classification_unit_meas, attr_);

   Client_SYS.Add_To_Attr('INPUT_QTY', rec_.input_qty, attr_);
   Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS', rec_.input_unit_meas, attr_);
   Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR', rec_.input_conv_factor, attr_);
   Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES', rec_.input_variable_values, attr_);
   Client_SYS.Add_To_Attr('RENTAL_DB', rec_.rental, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE',rec_.customer_tax_usage_type , attr_);
   Client_SYS.Add_To_Attr('CUST_PART_INVERT_CONV_FACT', rec_.cust_part_invert_conv_fact, attr_); 
   Client_SYS.Add_To_Attr('TAX_LIABILITY_TYPE_DB', rec_.tax_liability_type, attr_);  
   
   IF rec_.single_occ_addr_flag = 'TRUE' THEN
      Client_SYS.Set_Item_Value('ADDR_FLAG', Gen_Yes_No_API.Decode('Y'), attr_);
      Client_SYS.Set_Item_Value('ADDR_FLAG_DB', 'Y', attr_);
   ELSE 
      Client_SYS.Set_Item_Value('ADDR_FLAG', Gen_Yes_No_API.Decode('N'), attr_);
      Client_SYS.Set_Item_Value('ADDR_FLAG_DB', 'N', attr_);
   END IF ;   
   -- Note: If the quotation line is rental, copy rental line information to the attr_.
   IF (rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         Rental_Object_Manager_API.Add_Rental_Info_To_Attr(attr_,
                                                           Rental_Object_API.Get_Rental_No(rec_.quotation_no,
                                                                                           rec_.line_no,
                                                                                           rec_.rel_no,
                                                                                           rec_.line_item_no,
                                                                                           Rental_Type_API.DB_ORDER_QUOTATION));
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END
   END IF;
   Client_SYS.Add_To_Attr('FREE_OF_CHARGE_DB', rec_.free_of_charge, attr_);  
   Client_SYS.Add_To_Attr('FREE_OF_CHARGE_TAX_BASIS', rec_.free_of_charge_tax_basis, attr_);  
   Client_SYS.Add_To_Attr('TAX_CALC_STRUCTURE_ID', rec_.tax_calc_structure_id, attr_); 
   Client_SYS.Add_To_Attr('SUP_SM_CONTRACT', rec_.sup_sm_contract, attr_);  
   Client_SYS.Add_To_Attr('SUP_SM_OBJECT', rec_.sup_sm_object, attr_);
   Client_SYS.Add_To_Attr('SM_CONNECTION', Service_Management_Connect_API.Decode(rec_.sm_connection), attr_);
   Client_SYS.Add_To_Attr('SM_CONNECTION_DB', rec_.sm_connection, attr_);
   Client_SYS.Add_To_Attr('FROM_ORDER_QUOTATION', 'TRUE', attr_); 
   Client_SYS.Add_To_Attr('QUOTATION_NO', rec_.quotation_no, attr_); 
   Client_SYS.Add_To_Attr('QUOTATION_LINE_NO', rec_.line_no, attr_); 
   Client_SYS.Add_To_Attr('QUOTATION_REL_NO', rec_.rel_no, attr_); 
   Client_SYS.Add_To_Attr('QUOTATION_LINE_ITEM_NO', rec_.line_item_no, attr_);
   
   tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(header_rec_.company);
   
   IF tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX THEN
      Client_SYS.Add_To_Attr('UPDATE_TAX', 'FALSE', attr_);
   END IF;
   
   RETURN attr_;          
   
END Build_Attr_For_Create_Line___ ;

-- Build_Attr_For_New___ 
-- This method is used to build the attr_ which is used in New.
PROCEDURE Build_Attr_For_New___ (
   discount_      OUT    NUMBER,   
	new_attr_      OUT    VARCHAR2,
   attr_          IN     VARCHAR2)
IS
   ptr_                 NUMBER;
   name_                VARCHAR2(30);
   value_               VARCHAR2(2000);
   quotation_no_        ORDER_QUOTATION_LINE_TAB.quotation_no%TYPE;
   rental_db_           VARCHAR2(5);
   sales_unit_price_        NUMBER;
   curr_rate_               NUMBER;
   quotation_rec_           Order_Quotation_API.Public_Rec;
   base_unit_price_         NUMBER;
   copy_status_             VARCHAR2(5);
BEGIN
   -- Retrieve the default attribute values, order_no must be passed to Prepare_Insert___
   quotation_no_ := Client_SYS.Get_Item_Value('QUOTATION_NO', attr_);
   Client_SYS.Add_To_Attr('QUOTATION_NO', quotation_no_, new_attr_);
   rental_db_ :=  Client_SYS.Get_Item_Value('RENTAL_DB', attr_);
   Client_SYS.Add_To_Attr('RENTAL_DB', rental_db_, new_attr_);
   Prepare_Insert___(new_attr_);

   base_unit_price_ := Client_SYS.Get_Item_Value('BASE_SALE_UNIT_PRICE', attr_);
   copy_status_ := Client_SYS.Get_Item_Value('COPY_STATUS', attr_);
   quotation_rec_ := Order_Quotation_API.Get(quotation_no_);
   -- Replace the default attribute values with the ones passed in the in parameter string
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CHARGED_ITEM') THEN
         Client_SYS.Set_Item_Value('CHARGED_ITEM_DB', Charged_Item_API.Encode(value_), new_attr_);
      ELSIF (name_ = 'DISCOUNT') THEN
         discount_ := Client_SYS.Attr_Value_To_Number(value_);       
      ELSE
         Client_SYS.Set_Item_Value(name_, value_, new_attr_);
      END IF;
   END LOOP;

   -- Add dummy attribut CREATED_BY_SERVER to indicate that the line was created
   -- using the public New method and not from the client.
   Client_SYS.Add_To_Attr('CREATED_BY_SERVER', 1, new_attr_);

   -- Add the default attributes for the sales part
   Get_Default_Part_Attributes___(new_attr_);

   -- Reapply the attributes passed as parameters in case theese were replaced by default values.
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      -- Added new condition to check if the sales price should be copied from another object and
      -- if so to get the sales price by converting the base price.
      IF ((name_ = 'SALE_UNIT_PRICE') AND (NVL(copy_status_, 'FALSE') = 'TRUE'))THEN
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(sales_unit_price_, curr_rate_, quotation_rec_.customer_no, quotation_rec_.contract, quotation_rec_.currency_code,
                                                                  base_unit_price_);         
         Client_SYS.Set_Item_Value('SALE_UNIT_PRICE', sales_unit_price_, new_attr_); 
      -- CATALOG no could have been replaced by a replacement part
      ELSIF (name_ NOT IN ('CATALOG_NO', 'DISCOUNT')) THEN
         Client_SYS.Set_Item_Value(name_, value_, new_attr_);
      END IF;
   END LOOP;
   
END Build_Attr_For_New___;

-- Build_Attr_For_Copy_Line___ 
-- This method is used to build the attr_ which is used in Copy_Quotation_Line.  
FUNCTION Build_Attr_For_Copy_Line___ (
   linerec_           IN     ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   quote_rec_         IN     ORDER_QUOTATION_API.Public_Rec,
   from_quotation_no_ IN     VARCHAR2,
   to_quotation_no_   IN     VARCHAR2,
   copy_pricing_      IN     VARCHAR2,
   copy_notes_        IN     VARCHAR2,
   rental_db_         IN     VARCHAR2 DEFAULT 'FALSE') RETURN VARCHAR2
IS
   attr_             VARCHAR2(32000);
   info_             VARCHAR2(2000);
   catalog_no_       VARCHAR2(25);
BEGIN
   catalog_no_ := linerec_.catalog_no;
   Client_SYS.Add_To_Attr('BUY_QTY_DUE', linerec_.buy_qty_due, attr_);
   Client_SYS.Add_To_Attr('RENTAL_DB', rental_db_, attr_);
      
   IF (copy_pricing_ = Fnd_Boolean_API.DB_TRUE) THEN
      IF (quote_rec_.use_price_incl_tax = Fnd_Boolean_API.DB_FALSE) THEN
         Client_SYS.Add_To_Attr('SALE_UNIT_PRICE', linerec_.sale_unit_price, attr_);
      END IF;
      Client_SYS.Add_To_Attr('UNIT_PRICE_INCL_TAX', linerec_.unit_price_incl_tax, attr_);
             
      Get_Line_Defaults__(info_, attr_, catalog_no_, to_quotation_no_);
      
      Client_SYS.Add_To_Attr('PRICE_CONV_FACTOR', linerec_.price_conv_factor, attr_);
      Client_SYS.Add_To_Attr('PART_PRICE', linerec_.part_price, attr_);        
      Client_SYS.Add_To_Attr('SALES_UNIT_MEASURE', linerec_.sales_unit_measure, attr_);
      Client_SYS.Add_To_Attr('PRICE_SOURCE_DB', linerec_.price_source, attr_);
      Client_SYS.Add_To_Attr('PRICE_SOURCE_ID', linerec_.price_source_id, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT', linerec_.discount, attr_);         
      Client_SYS.Add_To_Attr('PRICE_FREEZE_DB', linerec_.price_freeze, attr_);               
      Client_SYS.Add_To_Attr('PRICE_LIST_NO', linerec_.price_list_no, attr_);
      Client_SYS.Add_To_Attr('PRICE_UNIT_MEAS', linerec_.price_unit_meas, attr_);
      Client_SYS.Add_To_Attr('ADDITIONAL_DISCOUNT', linerec_.additional_discount, attr_);
      Client_SYS.Add_To_Attr('PRICE_SOURCE_NET_PRICE_DB', linerec_.price_source_net_price, attr_);
      Client_SYS.Add_To_Attr('PART_LEVEL_DB', linerec_.part_level, attr_);
      Client_SYS.Add_To_Attr('PART_LEVEL_ID', linerec_.part_level_id, attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_DB', linerec_.customer_level, attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_ID', linerec_.customer_level_id, attr_);
      Client_SYS.Add_To_Attr('QUOTATION_DISCOUNT', linerec_.quotation_discount, attr_);
      Client_SYS.Add_To_Attr('CALC_CHAR_PRICE', linerec_.calc_char_price, attr_);
      Client_SYS.Add_To_Attr('CHAR_PRICE', linerec_.char_price, attr_);
   ELSE   
      Get_Line_Defaults__(info_, attr_, catalog_no_, to_quotation_no_);
      Client_SYS.Add_To_Attr('COPY_STATUS', 'FALSE', attr_);      
   END IF;
    
   Client_SYS.Add_To_Attr('QUOTATION_NO', to_quotation_no_, attr_); 
   Client_SYS.Add_To_Attr('LINE_NO', linerec_.line_no, attr_);
   Client_SYS.Add_To_Attr('REL_NO', linerec_.rel_no, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', linerec_.line_item_no, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', linerec_.contract, attr_);
   Client_SYS.Add_To_Attr('COMPANY', linerec_.company, attr_);
   Client_SYS.Add_To_Attr('CATALOG_NO', linerec_.catalog_no, attr_);
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', linerec_.wanted_delivery_date, attr_);
   Client_SYS.Add_To_Attr('DESIRED_QTY', linerec_.desired_qty, attr_);           
   Client_SYS.Add_To_Attr('REVISED_QTY_DUE', linerec_.revised_qty_due, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', linerec_.delivery_leadtime, attr_);     
   Client_SYS.Add_To_Attr('PICKING_LEADTIME', linerec_.picking_leadtime, attr_);
   Client_SYS.Add_To_Attr('PROBABILITY_TO_WIN', quote_rec_.quotation_probability, attr_ );   
   Client_SYS.Add_To_Attr('SINGLE_OCC_ADDR_FLAG', linerec_.single_occ_addr_flag, attr_);   
   Client_SYS.Add_To_Attr('TAX_CLASS_ID', linerec_.tax_class_id, attr_);
   Client_SYS.Add_To_Attr('TAX_CODE', linerec_.tax_code, attr_);   
   Client_SYS.Add_To_Attr('ORDER_SUPPLY_TYPE_DB', linerec_.order_supply_type, attr_);
   Client_SYS.Add_To_Attr('SHIP_ADDR_NO', linerec_.ship_addr_no, attr_); 
   Client_SYS.Add_To_Attr('SHIP_VIA_CODE', linerec_.ship_via_code, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TERMS', linerec_.delivery_terms, attr_);
   Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', linerec_.del_terms_location, attr_);
   Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', linerec_.forward_agent_id, attr_);
   Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', linerec_.ext_transport_calendar_id, attr_);
   Client_SYS.Add_To_Attr('TAX_LIABILITY', linerec_.tax_liability, attr_); 
   Client_SYS.Add_To_Attr('CATALOG_DESC', linerec_.catalog_desc, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PART_NO', linerec_.customer_part_no, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PART_CONV_FACTOR', linerec_.customer_part_conv_factor, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PART_UNIT_MEAS', linerec_.customer_part_unit_meas, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PART_BUY_QTY', linerec_.customer_part_buy_qty, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', linerec_.customer_no, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TYPE', linerec_.delivery_type, attr_);
   Client_SYS.Add_To_Attr('CONDITION_CODE', linerec_.condition_code, attr_);
   Client_SYS.Add_To_Attr('VENDOR_NO', linerec_.vendor_no, attr_);
   Client_SYS.Add_To_Attr('SELF_BILLING_DB', linerec_.self_billing, attr_);
   Client_SYS.Add_To_Attr('CLASSIFICATION_STANDARD', linerec_.classification_standard, attr_);
   Client_SYS.Add_To_Attr('CLASSIFICATION_PART_NO', linerec_.classification_part_no, attr_);
   Client_SYS.Add_To_Attr('CLASSIFICATION_UNIT_MEAS', linerec_.classification_unit_meas, attr_);
   Client_SYS.Add_To_Attr('INPUT_QTY', linerec_.input_qty, attr_);
   Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS', linerec_.input_unit_meas, attr_);
   Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR', linerec_.input_conv_factor, attr_);
   Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES', linerec_.input_variable_values, attr_);   
   Client_SYS.Add_To_Attr('CATALOG_TYPE_DB', linerec_.catalog_type, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE',linerec_.customer_tax_usage_type , attr_);
   Client_SYS.Add_To_Attr('TAX_LIABILITY_TYPE_DB', linerec_.tax_liability_type, attr_);
   Client_SYS.Add_To_Attr('CONFIGURATION_ID', linerec_.configuration_id, attr_);
     
   IF linerec_.single_occ_addr_flag = 'TRUE' THEN 
      Client_SYS.Add_To_Attr('SHIP_ADDR_COUNTRY_CODE', linerec_.ship_addr_country_code, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_NAME', linerec_.ship_addr_name, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDRESS1', linerec_.ship_address1, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDRESS2', linerec_.ship_address2, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDRESS3', linerec_.ship_address3, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDRESS4', linerec_.ship_address4, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDRESS5', linerec_.ship_address5, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDRESS6', linerec_.ship_address6, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_ZIP_CODE', linerec_.ship_addr_zip_code, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_CITY', linerec_.ship_addr_city, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_STATE', linerec_.ship_addr_state, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_COUNTY', linerec_.ship_addr_county, attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_IN_CITY', linerec_.ship_addr_in_city, attr_);
   END IF ;
   
   -- Note: Add the rental information to the attr_
   IF (rental_db_ = Fnd_Boolean_API.DB_TRUE) THEN
      $IF (Component_Rental_SYS.INSTALLED) $THEN
         Rental_Object_Manager_API.Add_Rental_Info_To_Attr(attr_,
                                                           Rental_Object_API.Get_Rental_No(from_quotation_no_,
                                                                                           linerec_.line_no,
                                                                                           linerec_.rel_no,
                                                                                           linerec_.line_item_no,
                                                                                           Rental_Type_API.DB_ORDER_QUOTATION));
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END
   END IF;
   
   IF (copy_notes_ = Fnd_Boolean_API.DB_TRUE) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', linerec_.note_text, attr_);   
   END IF;
   Client_SYS.Add_To_Attr('COPY_QUOTATION_LINE', 'TRUE', attr_);   
   Client_SYS.Add_To_Attr('COPY_PRICING', copy_pricing_, attr_);
   Client_SYS.Add_To_Attr('TAX_CALC_STRUCTURE_ID', linerec_.tax_calc_structure_id, attr_);
   Client_SYS.Add_To_Attr('SUP_SM_CONTRACT', linerec_.sup_sm_contract, attr_);  
   Client_SYS.Add_To_Attr('SUP_SM_OBJECT', linerec_.sup_sm_object, attr_);
   Client_SYS.Add_To_Attr('SM_CONNECTION_DB', linerec_.sm_connection, attr_);   
   
   Client_SYS.Add_To_Attr('ORIGINAL_QUOTE_NO', from_quotation_no_, attr_);
   Client_SYS.Add_To_Attr('ORIGINAL_LINE_NO', linerec_.line_no, attr_);   
   Client_SYS.Add_To_Attr('ORIGINAL_REL_NO', linerec_.rel_no, attr_);   
   Client_SYS.Add_To_Attr('ORIGINAL_ITEM_NO', linerec_.line_item_no, attr_);   
    
   RETURN attr_;
END Build_Attr_For_Copy_Line___;

PROCEDURE Validate_before_Delete___  (
   remrec_              IN ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   remove_to_replace_   IN VARCHAR2)
IS
   CURSOR get_package IS
      SELECT rowid
         FROM  ORDER_QUOTATION_LINE_TAB
         WHERE line_item_no > 0
         AND   rel_no = remrec_.rel_no
         AND   line_no = remrec_.line_no
         AND   quotation_no = remrec_.quotation_no;

   linerec_ ORDER_QUOTATION_LINE_TAB%ROWTYPE;

BEGIN  
   -- this code is moved from check_delete___ method.
   IF (remrec_.rowstate != 'Planned') THEN
      -- error is raised if order line is not created by B2B and if its not called when replacing.
      IF (( Order_Quotation_API.Get_B2b_Order_Db(remrec_.quotation_no) != 'TRUE') AND (remove_to_replace_ = 'FALSE' OR (remove_to_replace_ = 'TRUE' AND remrec_.rowstate != 'Released')) ) THEN
         Error_SYS.Record_General(lu_name_, 'DELETEERROR: Lines can be removed only if quotation line is planned');
      END IF;
   END IF;
   -- IF the line is connected to a sales promotion calculation that has resulted in a sales promotion charge it can't be removed.
   IF Sales_Promotion_Util_API.Check_Promo_Exist_For_Quo_Line(remrec_.quotation_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no) THEN
      Error_SYS.Record_General(lu_name_, 'NODELPROMOCONN: The order line cannot be deleted unless sales promotions have been cleared first.');
   END IF;
   -- IF the line is a package part then check all component lines
   IF (remrec_.order_supply_type = 'PKG') THEN
      FOR pkgrec_ IN get_package LOOP
         linerec_ := Get_Object_By_Id___(pkgrec_.rowid);
         Check_Delete___(linerec_);
      END LOOP;
   END IF;
END Validate_before_Delete___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   insert_package_mode_   BOOLEAN := FALSE;
   current_info_          VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Info;
   current_info_ := NULL;
   App_Context_SYS.Set_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_', current_info_);
   super(info_, objid_, objversion_, attr_, action_);
   Add_Info___(info_, insert_package_mode_);
   current_info_ :=  App_Context_SYS.Find_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_');
   info_ := current_info_;
END New__;


@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   current_info_ VARCHAR2(32000);
BEGIN
   current_info_ := NULL;
   App_Context_SYS.Set_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_', current_info_);
   super(info_, objid_, objversion_, attr_, action_);
   current_info_ :=  App_Context_SYS.Find_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_');
   info_ := current_info_ || info_;
END Modify__;


@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ ORDER_QUOTATION_LINE_TAB%ROWTYPE;
BEGIN
   IF (action_ = 'DO') THEN
      remrec_ := Get_Object_By_Id___(objid_);
   END IF;
   super(info_, objid_, objversion_, action_);
   IF (action_ = 'DO') THEN  
      Source_Tax_Item_Order_API.Remove_Tax_Items(remrec_.company,
                                                 Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                 remrec_.quotation_no,
                                                 remrec_.line_no,
                                                 remrec_.rel_no,
                                                 TO_CHAR(remrec_.line_item_no),
                                                 '*');
      Order_Quotation_Charge_API.Recalc_Percentage_Charge_Taxes(remrec_.quotation_no, remrec_.line_no, TRUE);                                           
      info_ := info_ || Client_SYS.Get_All_Info;
   END IF;
END Remove__;

-- Modify_Wanted_Delivery_Date__
--   Modifies the wanted delivery date of the specified order quotation line.
PROCEDURE Modify_Wanted_Delivery_Date__ (
   quotation_no_          IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   wanted_delivery_date_  IN DATE,
   planned_delivery_date_ IN DATE )
IS
   attr_    VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', wanted_delivery_date_, attr_);
   Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE', planned_delivery_date_, attr_);
   
   IF (Get_Rental_Db(quotation_no_, line_no_, rel_no_, line_item_no_) = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         IF (Rental_Object_API.Get_Planned_Rental_Start_Date(Rental_Object_API.Get_Rental_No(quotation_no_,
                                                                                             line_no_,
                                                                                             rel_no_,
                                                                                             line_item_no_,
                                                                                             Rental_Type_API.DB_ORDER_QUOTATION)) IS NULL) THEN
            Client_SYS.Add_To_Attr('PLANNED_RENTAL_START_DATE', wanted_delivery_date_, attr_);
            Client_SYS.Add_To_Attr('PLANNED_RENTAL_START_TIME', wanted_delivery_date_, attr_);
         END IF;                                                                                             
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');                                
      $END
   END IF;
   Modify_Line___(attr_, quotation_no_, line_no_, rel_no_, line_item_no_);
END Modify_Wanted_Delivery_Date__;


-- Recalc_Package_Structure__
--   Recalculates a package structure after being modifyed
PROCEDURE Recalc_Package_Structure__ (
   quotation_no_    IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   calc_char_price_ IN NUMBER,
   char_price_      IN NUMBER )
IS
   linerec_    ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   oldrec_     ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   rowid_      VARCHAR2(2000);
   rowversion_ VARCHAR2(2000);
BEGIN
   linerec_ := Get_Object_By_Keys___(quotation_no_, line_no_, rel_no_, -1);
   oldrec_ := linerec_;
   -- Modify cost for the order line
   Update_Package_Cost___(linerec_.cost, quotation_no_, line_no_, rel_no_);
   Change_Package_Structure___(linerec_.promised_delivery_date, linerec_.planned_delivery_date,
                               linerec_.planned_due_date, linerec_,
                               FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE);

   Get_Id_Version_By_Keys___(rowid_, rowversion_, quotation_no_, line_no_, rel_no_, -1);
   linerec_.rowversion := sysdate;
   Update_Line___(rowid_, oldrec_, linerec_, TRUE, FALSE);
END Recalc_Package_Structure__;


-- Get_Cust_Part_No_Defaults__
--   Field validation on column customer_part_no from client.
PROCEDURE Get_Cust_Part_No_Defaults__ (
   info_             OUT    VARCHAR2,
   attr_             IN OUT VARCHAR2,
   quotation_no_     IN     VARCHAR2,
   customer_part_no_ IN     VARCHAR2 )
IS
   headrec_            ORDER_QUOTATION_API.Public_Rec;
   cross_rec_          SALES_PART_CROSS_REFERENCE_API.Public_Rec;
BEGIN
   headrec_ := ORDER_QUOTATION_API.Get(quotation_no_);
   Sales_Part_Cross_Reference_API.Exist(headrec_.customer_no, headrec_.contract, customer_part_no_);

   cross_rec_ := Sales_Part_Cross_Reference_API.Get(headrec_.customer_no, headrec_.contract, customer_part_no_);
   Get_Line_Defaults___(attr_, cross_rec_.catalog_no, quotation_no_);

   IF (cross_rec_.catalog_desc IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('CATALOG_DESC', cross_rec_.catalog_desc, attr_);
   END IF;
   Client_SYS.Set_Item_Value('CUSTOMER_PART_CONV_FACTOR', cross_rec_.conv_factor, attr_);
   Client_SYS.Set_Item_Value('CUST_PART_INVERT_CONV_FACT', cross_rec_.inverted_conv_factor, attr_);
   Client_SYS.Set_Item_Value('CUSTOMER_PART_UNIT_MEAS', NVL(cross_rec_.customer_unit_meas, Client_SYS.Get_Item_Value('SALES_UNIT_MEASURE', attr_)), attr_);

   Client_SYS.Add_To_Attr('CATALOG_NO', cross_rec_.catalog_no, attr_);
   info_ := Client_SYS.Get_All_Info;
END Get_Cust_Part_No_Defaults__;


-- Get_Line_Defaults__
--   Field validation on column catalog_no from client.
PROCEDURE Get_Line_Defaults__ (
   info_         OUT    VARCHAR2,
   attr_         IN OUT VARCHAR2,
   catalog_no_   IN OUT VARCHAR2,
   quotation_no_ IN     VARCHAR2 )
IS
BEGIN
   Get_Line_Defaults___(attr_, catalog_no_, quotation_no_);
   info_ := Client_SYS.Get_All_Info;
END Get_Line_Defaults__;

-- Set_Quotation_Line_Won__
--   Set Won information for the quotation line and change it's state to Won.
PROCEDURE Set_Quotation_Line_Won__ (
   info_         OUT VARCHAR2,
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   reason_id_    IN VARCHAR2,
   won_note_     IN VARCHAR2 )
IS
   attr_    VARCHAR2(32000);
   objid_   ORDER_QUOTATION_LINE.objid%TYPE;
   objver_  ORDER_QUOTATION_LINE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objver_, quotation_no_, line_no_, rel_no_, line_item_no_);
   Client_SYS.Clear_Attr( attr_ );
   Client_SYS.Add_To_Attr('REASON_ID', reason_id_, attr_ );
   Client_SYS.Add_To_Attr('LOSE_WIN_NOTE', won_note_, attr_ );
   Quotation_Line_Won__(info_, objid_, objver_, attr_, 'DO');
   $IF Component_Estman_SYS.INSTALLED $THEN
      Estimate_Deliverable_API.Add_SQ_State_Changed_Log(quotation_no_, 
                                                        line_no_, 
                                                        rel_no_, 
                                                        line_item_no_, 
                                                        Get_Customer_No(quotation_no_, line_no_, rel_no_, line_item_no_),
                                                        Get_Objstate(quotation_no_, line_no_, rel_no_, line_item_no_));
   $END
END Set_Quotation_Line_Won__;

-- Set_Quotation_Line_Lost__
--   Set lost information for the quotation line and change it's state to Lost.
PROCEDURE Set_Quotation_Line_Lost__ (
   info_         OUT VARCHAR2,
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   reason_id_    IN VARCHAR2,
   lost_to_      IN VARCHAR2,
   lost_note_    IN VARCHAR2 )
IS
   attr_    VARCHAR2(32000);
   objid_   ORDER_QUOTATION_LINE.objid%TYPE;
   objver_  ORDER_QUOTATION_LINE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objver_, quotation_no_, line_no_, rel_no_, line_item_no_);
   Client_SYS.Clear_Attr( attr_ );
   Client_SYS.Add_To_Attr('REASON_ID', reason_id_, attr_ );
   Client_SYS.Add_To_Attr('LOST_TO', lost_to_, attr_ );
   Client_SYS.Add_To_Attr('LOSE_WIN_NOTE', lost_note_, attr_ );
   Quotation_Line_Lost__(info_, objid_, objver_, attr_, 'DO');
   $IF Component_Estman_SYS.INSTALLED $THEN
      Estimate_Deliverable_API.Add_SQ_State_Changed_Log(quotation_no_, 
                                                        line_no_, 
                                                        rel_no_, 
                                                        line_item_no_, 
                                                        Get_Customer_No(quotation_no_, line_no_, rel_no_, line_item_no_),
                                                        Get_Objstate(quotation_no_, line_no_, rel_no_, line_item_no_));
   $END
END Set_Quotation_Line_Lost__;

-- Update_Planning_Date__
--   Method recalculates dates (forward) using a new planned_due_date.
PROCEDURE Update_Planning_Date__ (
   quotation_no_        IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   planned_due_date_    IN DATE,
   latest_release_date_ IN DATE,
   allocate_db_         IN VARCHAR2 )
IS
   objid_                     VARCHAR2(2000);
   rowversion_                VARCHAR2(2000);
   old_delivery_date_         DATE;
   max_planned_delivery_date_ DATE;
   max_planned_due_date_      DATE;
   newrec_                    ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   oldrec_                    ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   headrec_                   ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   quotation_state_           ORDER_QUOTATION_TAB.rowstate%TYPE;
   dummy_                     DATE;
   supplier_part_no_          VARCHAR2(25);
   max_latest_release_date_   DATE;
   message_                   VARCHAR2(80);
   ctp_run_id_                NUMBER;
   lowest_node_part_no_       VARCHAR2(25);
   lowest_node_contract_      VARCHAR2(5);
   lowest_node_finish_date_   DATE;
   lowest_node_count_         NUMBER;
   lowest_node_info_          VARCHAR2(200);
   cc_info_                   VARCHAR2(3200);

   CURSOR get_max_component IS
   SELECT planned_delivery_date, planned_due_date, latest_release_date
   FROM  ORDER_QUOTATION_LINE_TAB
   WHERE quotation_no = quotation_no_
   AND   line_no = line_no_
   AND   rel_no = rel_no_
   AND   line_item_no > 0
   ORDER BY planned_delivery_date DESC;

BEGIN

   newrec_ := Lock_By_Keys___(quotation_no_, line_no_, rel_no_, line_item_no_);
   oldrec_  := newrec_;
   quotation_state_ := ORDER_QUOTATION_API.Get_Objstate(newrec_.quotation_no);
   newrec_.planned_due_date := planned_due_date_;
   old_delivery_date_ := newrec_.planned_delivery_date;

   -- if inventory part on "our" site, use part_no, otherwise use purchase part no.
   IF (newrec_.part_no IS NOT NULL) THEN
      supplier_part_no_ := newrec_.part_no;
   ELSE
      supplier_part_no_ := Sales_Part_API.Get_Purchase_Part_No(newrec_.contract, newrec_.catalog_no);
   END IF;

   -- calculate ship date and delivery date forwards from due date.
   -- quotations doesn't use supplier ship via or route
   Cust_Ord_Date_Calculation_API.Calc_Order_Dates_Forwards(newrec_.planned_delivery_date, dummy_, newrec_.planned_due_date, dummy_,
      newrec_.wanted_delivery_date, newrec_.contract, newrec_.order_supply_type, newrec_.customer_no, newrec_.vendor_no,
      newrec_.part_no, supplier_part_no_, newrec_.ship_addr_no, newrec_.ship_via_code, 
      NULL, newrec_.delivery_leadtime, newrec_.picking_leadtime, newrec_.ext_transport_calendar_id, NULL);


   -- The time part of the planned delivery date should not be changed
   newrec_.planned_delivery_date := to_date(to_char(newrec_.planned_delivery_date, 'YYYY-MM-DD') || ' ' ||
                                    nvl(to_char(old_delivery_date_, 'HH24:MI:SS'),'00:00:00'), 'YYYY-MM-DD HH24:MI:SS');

   -- the capability check engine have returned a date and its one of the allocate/reserve cc alternatives, set the cc planned flag
   IF (latest_release_date_ IS NOT NULL AND allocate_db_ IN ('RESERVE AND ALLOCATE','ALLOCATE ONLY')) THEN
      newrec_.latest_release_date := latest_release_date_;
      newrec_.ctp_planned := 'Y';
   -- for the neither case set the latest_release_date and set flag to false
   ELSIF (latest_release_date_ IS NOT NULL AND allocate_db_ = 'NEITHER RESERVE NOR ALLOCATE') THEN
      newrec_.latest_release_date := latest_release_date_;
      newrec_.ctp_planned := 'N';
   END IF;
   -- set the promosied delivery date when using CC so the Customer Order Line later on will not use wrong dates
   IF (allocate_db_ IS NOT NULL) THEN
      newrec_.promised_delivery_date := newrec_.planned_delivery_date;
   END IF;

   IF (old_delivery_date_ != newrec_.planned_delivery_date AND newrec_.latest_release_date IS NOT NULL) THEN
      $IF (Component_Ordstr_SYS.INSTALLED) $THEN
         IF (App_Context_SYS.Find_Number_Value('CTP_RUN_ID') IS NOT NULL) THEN
            ctp_run_id_ := App_Context_SYS.Get_Number_Value('CTP_RUN_ID');
         END IF;
         IF (ctp_run_id_ > 0) THEN
            Interim_Ctp_Critical_Path_API.Update_Is_Deliverable(ctp_run_id_, Fnd_Boolean_API.DB_FALSE);
            Interim_Ctp_Critical_Path_API.Get_Lowest_Node_Details(lowest_node_part_no_, lowest_node_contract_, lowest_node_finish_date_, lowest_node_count_, ctp_run_id_);
               IF (lowest_node_count_ > 1) THEN
                  lowest_node_info_ := Language_SYS.Translate_Constant(lu_name_,'SEVLOWESTNODE: Several parts exist as lower nodes in the critical path. Would you like to analyze the capability check result?');
               ELSIF (lowest_node_count_ = 1) THEN
                  lowest_node_info_ := Language_SYS.Translate_Constant(lu_name_,'LOWESTNODEXIST: Would you like to analyze the capability check result?', NULL,lowest_node_part_no_, lowest_node_contract_, lowest_node_finish_date_);
               END IF;
         END IF;
      $END
      cc_info_:=  Language_SYS.Translate_Constant(lu_name_, 'QCCDELDATECHANGED: The planned delivery date will be changed from :P1 to :P2.', NULL,
                  to_char(old_delivery_date_, 'YYYY-MM-DD'), to_char(newrec_.planned_delivery_date, 'YYYY-MM-DD'));
      cc_info_ := cc_info_ || ' '|| lowest_node_info_;
      Client_SYS.Add_Info(lu_name_, cc_info_);
      message_ := SUBSTR(Language_SYS.Translate_Constant(lu_name_, 'DATESCHANGEDBYCC: Ran Capability Check. Planned Del Date changed from :P1 to :P2.',NULL,
                                       to_char(old_delivery_date_, 'YYYY-MM-DD'),
                                       to_char(newrec_.planned_delivery_date, 'YYYY-MM-DD')), 1, 80);
   ELSIF (newrec_.latest_release_date IS NOT NULL) THEN
      Client_SYS.Add_Info(lu_name_, 'QCCDELDATENOCHANGE: The delivery date can be fulfilled as planned.');
      $IF (Component_Ordstr_SYS.INSTALLED) $THEN
         IF (App_Context_SYS.Find_Number_Value('CTP_RUN_ID') IS NOT NULL) THEN
            ctp_run_id_ := App_Context_SYS.Get_Number_Value('CTP_RUN_ID');
         END IF;
         Interim_Ctp_Critical_Path_API.Update_Is_Deliverable(ctp_run_id_, Fnd_Boolean_API.DB_TRUE);
      $END
   END IF;

   Get_Id_Version_By_Keys___(objid_, rowversion_, quotation_no_, line_no_, rel_no_, line_item_no_);
   newrec_.rowversion := sysdate;
   Update_Line___(objid_, oldrec_, newrec_, TRUE, FALSE);

   -- package handling
   IF (line_item_no_ > 0) THEN
      headrec_ := Get_Object_By_Keys___(quotation_no_, line_no_, rel_no_, -1);
      OPEN  get_max_component;
      FETCH get_max_component into max_planned_delivery_date_,
                                   max_planned_due_date_,
                                   max_latest_release_date_;
      CLOSE get_max_component;
      -- update package head dates
      headrec_ := Lock_By_Keys___(quotation_no_, line_no_, rel_no_, -1);
      headrec_.planned_delivery_date := max_planned_delivery_date_;
      headrec_.planned_due_date := max_planned_due_date_;
      headrec_.latest_release_date := max_latest_release_date_;
      IF (quotation_state_ = 'Planned') THEN
         headrec_.promised_delivery_date := headrec_.planned_delivery_date;
      END IF;
      Get_Id_Version_By_Keys___(objid_, rowversion_, quotation_no_, line_no_, rel_no_, -1);
      headrec_.rowversion := sysdate;
      Update_Line___(objid_, oldrec_, headrec_, TRUE, FALSE);
   END IF;

   IF (message_ IS NOT NULL) THEN
      Order_Quote_Line_Hist_API.New(quotation_no_, line_no_, rel_no_, line_item_no_, message_);
   END IF;
END Update_Planning_Date__;


-- Check_Statutory_Fee__
--   Checks if the statutory_fee exists. If found, print an error message.
--   Used for restricted delete check when removing an statutory_fee (ACCRUL-module).
PROCEDURE Check_Statutory_Fee__ (
   key_list_ IN VARCHAR2 )
IS
   company_  VARCHAR2(20);
   tax_code_ ORDER_QUOTATION_LINE_TAB.tax_code%TYPE;
   found_    NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  Site_API.Get_Company(contract) = company_
      AND    tax_code = tax_code_;
BEGIN
   company_ := substr(key_list_, 1, instr(key_list_, '^') - 1);
   tax_code_ := substr(key_list_, instr(key_list_, '^') + 1, instr(key_list_, '^' , 1, 2) - (instr(key_list_, '^') + 1));

   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   IF (found_ = 1) THEN
      Error_SYS.Record_General(lu_name_, 'NO_FEE_CODE: Tax Code :P1 exists on one or several Order Quotation(s)', tax_code_);
   END IF;
END Check_Statutory_Fee__;


-- Modify_Quote_Defaults__
--   Modify quotation header specific delivery information for all quotation lines
--   having default_addr_flag set to Yes.
PROCEDURE Modify_Quote_Defaults__ (
   quotation_no_                IN VARCHAR2,
   refresh_vat_free_vat_code_   IN VARCHAR2,
   single_occ_addr_changed_     IN BOOLEAN DEFAULT FALSE,
   customer_changed_            IN BOOLEAN DEFAULT FALSE,
   update_tax_                  IN BOOLEAN DEFAULT TRUE )
IS
   head_attr_           VARCHAR2(32000);
   quote_rec_           ORDER_QUOTATION_API.Public_Rec;
   oldrec_              ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   newrec_              ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   indrec_              Indicator_Rec;
   ignore_def_flag_     NUMBER;
   
   -- Added Condition (1 = ignore_flag_) to the cursor to have control on lines that we want to fetch. 
   -- Cursor will fetch all lines if customer has changed (ignore_flag_ is 1 so it ignores condition "default_addr_flag = 'Y'")
   -- otherwise fetch only default lines 
   CURSOR get_quote_lines(ignore_flag_ IN NUMBER) IS
      SELECT rowid objid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) objversion, rowstate objstate, default_addr_flag , customer_no, delivery_type
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE line_item_no  <= 0
      AND quotation_no = quotation_no_
      AND ((1 = ignore_flag_) OR default_addr_flag = 'Y') 
      AND rowstate NOT IN ('Cancelled', 'Lost', 'Won', 'CO Created');
BEGIN
   Client_SYS.Clear_Attr(head_attr_);
   
   quote_rec_ := ORDER_QUOTATION_API.Get(quotation_no_);
   
   IF customer_changed_ THEN 
      ignore_def_flag_ := 1;
      Remove_Single_Occ_Addr_Line___(newrec_);
   ELSE 
      ignore_def_flag_ := 0;
   END IF; 
      
   FOR linerec_ IN get_quote_lines(ignore_def_flag_) LOOP
      Client_SYS.Clear_Attr(head_attr_);
      oldrec_ := Lock_By_Id___(linerec_.objid, linerec_.objversion);
      newrec_ := oldrec_;
      Reset_Indicator_Rec___(indrec_);
      -- If customer change, the "Delivery Addr/Single Occur Addr" should reset to header default for all lines despite of default address flag.
      IF customer_changed_ THEN 
         Remove_Single_Occ_Addr_Line___(newrec_);
      END IF; 
      Modify_Quote_Line_Defaults___(head_attr_, linerec_.default_addr_flag, linerec_.delivery_type, oldrec_, quote_rec_, refresh_vat_free_vat_code_, single_occ_addr_changed_, customer_changed_, update_tax_);
      IF(head_attr_ IS NOT NULL) THEN
         Unpack___(newrec_, indrec_, head_attr_);
         Check_Update___(oldrec_, newrec_, indrec_, head_attr_);
         Update___(linerec_.objid, oldrec_, newrec_, head_attr_, linerec_.objversion);
      END IF;
   END LOOP;
END Modify_Quote_Defaults__;

-- Modify_Discount__
--   Modify discount on quotation  line.
PROCEDURE Modify_Discount__ (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   discount_     IN NUMBER,
   update_tax_   IN VARCHAR2 DEFAULT 'TRUE')
IS
   attr_ VARCHAR2(2000);
   objid_       ORDER_QUOTATION_LINE.objid%type;
   objversion_  ORDER_QUOTATION_LINE.objversion%type;
   oldrec_      ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   newrec_      ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
   -- gelr:disc_price_rounded, begin
   discount_temp_  NUMBER;
   -- gelr:disc_price_rounded, end
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DISCOUNT', NVL(discount_, 0), attr_);
   -- gelr:disc_price_rounded:DIS005, begin
   IF (Order_Quotation_API.Get_Discounted_Price_Rounded(quotation_no_)) THEN
      discount_temp_ := Order_Quote_Line_Discount_API.Calculate_Original_Discount__(quotation_no_, line_no_, rel_no_, line_item_no_);
      Client_SYS.Add_To_Attr('ORIGINAL_DISCOUNT',  NVL(discount_temp_, 0), attr_);
   END IF;
   -- gelr:disc_price_rounded:DIS005, end
   Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 1, attr_);
   Client_SYS.Add_To_Attr('UPDATE_TAX', update_tax_, attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, line_no_, rel_no_, line_item_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Discount__;


-- Get_Allowed_Operations__
--   Returns a string used to determine which operations should be
--   allowed for the specified quotation.
@UncheckedAccess
FUNCTION Get_Allowed_Operations__ (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   rec_          ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   operations_   VARCHAR2(6);
   site_date_    DATE;
   expire_date_  DATE;
   head_rec_     Order_Quotation_API.Public_Rec;
BEGIN
   rec_ := Get_Object_By_Keys___(quotation_no_, line_no_, rel_no_, line_item_no_);
   head_rec_ := Order_Quotation_API.Get(quotation_no_);

   site_date_ := Site_API.Get_Site_Date( rec_.contract );
   expire_date_ := head_rec_.expiration_date;

   -- 0 Cancel quotation
   IF ( rec_.rowstate IN ('Planned', 'Released', 'Revised','Rejected') AND head_rec_.rowstate != 'Closed') THEN
      operations_ := 'C';
   ELSE
      operations_ := '*';
   END IF;

   -- 1 Release quotation
   IF ( ( rec_.rowstate IN ('Planned', 'Revised', 'Rejected') )) THEN
      operations_ := operations_  || 'R';
   ELSE
      operations_ := operations_  || '*';
   END IF;

   -- 2 Lost quotation
   IF ( rec_.rowstate IN ('Released', 'Rejected')) AND head_rec_.rowstate != 'Closed' THEN
      operations_ := operations_  || 'L';
   ELSE
      operations_ := operations_  || '*';
   END IF;

   -- 3 Create Order
   IF (rec_.rowstate IN ('Released', 'Won') AND 
         (Get_Con_Order_No(quotation_no_, line_no_, rel_no_, line_item_no_) IS NULL) AND
         head_rec_.rowstate = 'Released' AND
         (( trunc(site_date_) <= expire_date_ ) OR expire_date_ IS NULL) ) THEN
      operations_ := operations_  || 'O';
   ELSE
      operations_ := operations_  || '*';
   END IF;
   
   -- 4 Won quotation 
   IF (rec_.rowstate IN ('Released')) THEN
      operations_ := operations_ || 'W';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   operations_ := operations_  || 'A';

   RETURN operations_;
END Get_Allowed_Operations__;


-- Check_Base_Part_Config__
--   Check that the configuration of the configurable part is set if the
--   quotation is no more in the state 'planned' OR the configuration is created or not
--   based on parts' configuration family.
PROCEDURE Check_Base_Part_Config__ (
   rec_ IN ORDER_QUOTATION_LINE_TAB%ROWTYPE )
IS
BEGIN
   IF Sales_Part_API.Get_Configurable_Db( rec_.contract, rec_.catalog_no ) = 'CONFIGURED' THEN
      -- only need to check this for configurable parts
      IF (Order_Config_Util_API.Is_Allow_Create_Config_Order(Nvl (rec_.part_no, rec_.catalog_no)) = 1) THEN
         IF (rec_.configuration_id = '*') THEN
            Error_SYS.Record_General(lu_name_, 'MISSINGCONFIG1: A configuration should be defined for the base part :P1 as the quotation will not be any more in state Planned.', rec_.part_no);
         END IF;
      ELSE
         IF (Order_Config_Util_API.Is_Base_Part_Config_Valid(Nvl (rec_.part_no, rec_.catalog_no), rec_.configuration_id) = 0 ) THEN 
            $IF Component_Cfgchr_SYS.INSTALLED $THEN
               Error_SYS.Record_General(lu_name_, 'MISSINGCONFIG2: A complete configuration must be defined before release of the quotation, incomplete configurations are not allowed for configuration family :P1', Config_Part_Catalog_API.Get_Config_Family_Id(rec_.part_no));                            
            $ELSE
                NULL;    
            $END
         END IF;
      END IF;
   END IF;
END Check_Base_Part_Config__;


-- Modify_Additional_Discount__
--   Modifies the additional discount in Order Quotation Line,
--   If additonal discount is changed in Quotation header.
PROCEDURE Modify_Additional_Discount__ (
   quotation_no_ IN VARCHAR2,
   additional_discount_ IN NUMBER )
IS
  attr_   VARCHAR2(2000);
  tax_method_                 VARCHAR2(50);
  fetch_tax_on_line_update_   BOOLEAN := TRUE;
  company_                    VARCHAR2(50);

  CURSOR get_quotation_lines IS
     SELECT line_no,rel_no,line_item_no, additional_discount
     FROM   ORDER_QUOTATION_LINE_TAB
     WHERE  quotation_no = quotation_no_
     AND    line_item_no <= 0
     AND    rowstate NOT IN ('Cancelled','Won','Lost', 'CO Created');

BEGIN
   company_    := Site_API.Get_Company(Order_Quotation_API.Get_Contract(quotation_no_));
   tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);
   
   IF tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX THEN
      fetch_tax_on_line_update_ := FALSE;
   END IF;  
   
   Client_SYS.Clear_Attr(attr_);
   FOR  quotation_line_ IN get_quotation_lines LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ADDITIONAL_DISCOUNT', additional_discount_, attr_);
      
      IF NOT fetch_tax_on_line_update_ THEN
         Client_SYS.Add_To_Attr('UPDATE_TAX', 'FALSE', attr_);
      END IF; 
      
      Modify_Line___(attr_, quotation_no_, quotation_line_.line_no, quotation_line_.rel_no, quotation_line_.line_item_no);
   END LOOP;
   
   IF NOT fetch_tax_on_line_update_ THEN
      Order_Quotation_API.Fetch_External_Tax(quotation_no_, 'FALSE', 'FALSE' );
   END IF;
END Modify_Additional_Discount__;


-- Modify_Fee_Code__
--   Modifies the tax code with the tax line tax code at the same time
PROCEDURE Modify_Tax_Code__ (
   attr_ IN OUT VARCHAR2,
   quotation_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   oldrec_           ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   newrec_           ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   tax_code_         ORDER_QUOTATION_LINE_TAB.tax_code%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, line_no_, rel_no_, line_item_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   tax_code_ := Client_Sys.get_item_value('TAX_CODE',attr_);
   newrec_.tax_code := tax_code_;
   Client_SYS.Add_To_Attr('TAX_CODE_CHANGED', 'TRUE', attr_); 
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Tax_Code__;


-- Check_Delivery_Type__
--   Checks if delivery_type exists. If found, print an error message.
--   Used for restricted delete check when removing an delivery_type (INVOIC-module).
PROCEDURE Check_Delivery_Type__ (
   key_list_ IN VARCHAR2 )
IS
   company_       VARCHAR2(20);
   delivery_type_ ORDER_QUOTATION_LINE_TAB.delivery_type%TYPE;
   found_         NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  Site_API.Get_Company(contract) = company_
      AND    delivery_type = delivery_type_;

BEGIN
   company_ := substr(key_list_, 1, instr(key_list_, '^') - 1);
   delivery_type_ := substr(key_list_, instr(key_list_, '^') + 1, instr(key_list_, '^' , 1, 2) - (instr(key_list_, '^') + 1));

   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   IF found_ = 1 THEN
      Error_SYS.Record_General(lu_name_, 'NO_DEL_TYPE: Delivery Type :P1 exists on one or several Sales Quotation Line(s)', delivery_type_ );
   END IF;
END Check_Delivery_Type__;

-- Validate_Jinsui_Constraints__
--   Performs validation with the Junsi Invoice Constraints.
@UncheckedAccess


-- Validate_Jinsui_Constraints__
--   Performs validation with the Junsi Invoice Constraints.
PROCEDURE Validate_Jinsui_Constraints__(
   newrec_                 IN ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   company_max_jinsui_amt_ IN NUMBER,
   co_header_validation_   IN BOOLEAN )
IS
   company_                 VARCHAR2(20);
   company_maximum_amt_     NUMBER := 0;
   gross_charge_amount_     NUMBER := 0;
   gross_total_incl_charge_ NUMBER := 0;
   net_amount_curr_         NUMBER := 0;
   total_tax_curr_          NUMBER := 0;
   gross_total_base_curr_   NUMBER := 0;

BEGIN

   IF newrec_.self_billing = 'SELF BILLING' THEN
      Error_SYS.Record_General(lu_name_, 'SBNOTALLOWEED: Self billing is not allowed for a jinsui quotation.');
   END IF;

   company_maximum_amt_ := company_max_jinsui_amt_;
   company_ := Site_API.Get_Company(newrec_.contract);
   IF (company_maximum_amt_ = 0 ) THEN
      $IF Component_Jinsui_SYS.INSTALLED $THEN
         company_maximum_amt_ := Js_Company_Info_API.Get_Virtual_Inv_Max_Amount(company_);
      $ELSE
         company_maximum_amt_ := 0;
      $END
   END IF;

   gross_charge_amount_:= ORDER_QUOTATION_CHARGE_API.Get_Gross_Amount_For_Col(newrec_.quotation_no,
                                                       newrec_.line_no,newrec_.rel_no,newrec_.line_item_no);
   net_amount_curr_ := Get_Sale_Price_Total(newrec_.quotation_no,
                                                       newrec_.line_no,newrec_.rel_no,newrec_.line_item_no);
   total_tax_curr_  := Get_Total_Tax_Amount(newrec_.quotation_no,
                                                       newrec_.line_no,newrec_.rel_no,newrec_.line_item_no);
   gross_total_base_curr_ := net_amount_curr_+ total_tax_curr_;
   gross_total_incl_charge_ := gross_total_base_curr_ + gross_charge_amount_;

   IF (gross_total_base_curr_ > company_maximum_amt_) THEN
      IF (co_header_validation_) THEN
         Error_SYS.Record_General(lu_name_, 'OQAMTEXCEEDED: The total line amount of sales quotation line :P1 cannot be greater than the maximum amount for Jinsui invoice :P2 for the company :P3.', newrec_.quotation_no||'-'||newrec_.line_no||'-'||newrec_.rel_no, company_maximum_amt_, company_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'AMTEXCEEDED: The total line amount cannot be greater than the maximum amount for Jinsui invoice :P1 for the company :P2.',company_maximum_amt_,company_);
      END IF;
   ELSIF (gross_total_incl_charge_ > company_maximum_amt_ ) THEN
      IF (co_header_validation_) THEN
         Error_SYS.Record_General(lu_name_, 'OQAMTLINECHEXCEED: The total line and the connected charge amount of sales quotation line :P1 cannot be greater than the maximum amount for Jinsui invoice :P2 for the company :P3.', newrec_.quotation_no||'-'||newrec_.line_no||'-'||newrec_.rel_no, company_maximum_amt_, company_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'AMTLINECHEXCEED: The total line and the connected charge amount cannot be greater than the maximum amount for Jinsui invoice :P1 for the company :P2.',company_maximum_amt_,company_);
      END IF;
   END IF;
END Validate_Jinsui_Constraints__;


-- Check_Default_Addr_Flag__
-- Compare the header and the line address details and set the default address flag accordingly.
FUNCTION Check_Default_Addr_Flag__ (  
   line_rec_              IN ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   quotation_no_          IN VARCHAR2,
   default_addr_flag_     IN VARCHAR2 ) RETURN VARCHAR2    
IS
   head_rec_               Order_Quotation_API.Public_Rec;
   line_default_addr_flag_ VARCHAR2(1);
BEGIN
   line_default_addr_flag_ := default_addr_flag_;
   head_rec_               := Order_Quotation_API.Get(quotation_no_);
   IF (default_addr_flag_ = 'N' AND line_rec_.vendor_no = head_rec_.vendor_no) THEN
      line_default_addr_flag_ := 'Y';
   END IF;
   
   IF (Delivery_Info_Match___(line_rec_, head_rec_)) THEN 
      line_default_addr_flag_ := 'Y';
   ELSE
      line_default_addr_flag_ := 'N';
   END IF;
   
   IF (line_default_addr_flag_ = 'Y') THEN
      -- Check the customer quotation single occurrence address flag
      IF (head_rec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE) AND (line_rec_.single_occ_addr_flag = Fnd_Boolean_API.DB_FALSE) THEN
         -- Single Occurence address 
         line_default_addr_flag_ := 'N';
      ELSIF (head_rec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE) AND (line_rec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE) THEN
         IF (Single_Occ_Addr_Match_Quot___(line_rec_, head_rec_) OR Is_Single_Occ_Addr_Empty___(line_rec_)) THEN
            line_default_addr_flag_ := 'Y';
         ELSE
            line_default_addr_flag_ := 'N';
         END IF;
      ELSIF (head_rec_.single_occ_addr_flag = Fnd_Boolean_API.DB_FALSE) AND (line_rec_.single_occ_addr_flag = Fnd_Boolean_API.DB_FALSE) THEN
         IF (NVL(head_rec_.ship_addr_no, Database_SYS.string_null_) != NVL(line_rec_.ship_addr_no, Database_SYS.string_null_)) THEN
            line_default_addr_flag_ := 'N';
         END IF;
      ELSE
         -- Address Flag has been changed.
         line_default_addr_flag_ := 'N';
      END IF;
   END IF; 
   RETURN line_default_addr_flag_;
END Check_Default_Addr_Flag__;


-- Add_Transaction_Tax_Info___
--    Fetch and calculate taxes and add tax lines to source_tax_item_tab.
PROCEDURE Add_Transaction_Tax_Info___ (
   newrec_              IN ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   company_             IN VARCHAR2,
   supply_country_db_   IN VARCHAR2,  
   use_price_incl_tax_  IN VARCHAR2,
   currency_code_       IN VARCHAR2,
   tax_from_defaults_   IN BOOLEAN,  
   attr_                IN VARCHAR2)
IS   
   line_amount_rec_       Tax_Handling_Util_API.line_amount_rec;   
   source_key_rec_        Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_    Tax_Handling_Order_Util_API.tax_line_param_rec;
   delivery_country_db_   VARCHAR2(2);
   multiple_tax_          VARCHAR2(20);
   tax_info_table_        Tax_Handling_Util_API.tax_information_table;
BEGIN
   IF(newrec_.ship_addr_country_code IS NOT NULL) THEN
      delivery_country_db_ := newrec_.ship_addr_country_code;
   ELSIF(newrec_.default_addr_flag = 'Y') THEN 
      delivery_country_db_ := Order_Quotation_API.Get_Country_Code(newrec_.quotation_no);
   ELSE
      delivery_country_db_ := Customer_Info_Address_API.Get_Country_Code(newrec_.customer_no, newrec_.ship_addr_no);
   END IF;
   
   source_key_rec_      := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                                       newrec_.quotation_no, 
                                                                       newrec_.line_no, 
                                                                       newrec_.rel_no, 
                                                                       newrec_.line_item_no,
                                                                       '*',
                                                                       attr_); 
      
   tax_line_param_rec_  := Tax_Handling_Order_Util_API.Create_Tax_Line_Param_Rec (company_,
                                                                                  newrec_.contract,
                                                                                  newrec_.customer_no,
                                                                                  newrec_.ship_addr_no,
                                                                                  NVL(newrec_.planned_due_date, TRUNC(Site_API.Get_Site_Date(newrec_.contract))),
                                                                                  supply_country_db_,
                                                                                  NVL( newrec_.delivery_type, '*'),
                                                                                  newrec_.catalog_no,
                                                                                  use_price_incl_tax_,
                                                                                  currency_code_,
                                                                                  newrec_.currency_rate,                                                                                       
                                                                                  NULL,
                                                                                  tax_from_defaults_,
                                                                                  newrec_.tax_code,
                                                                                  newrec_.tax_calc_structure_id,
                                                                                  newrec_.tax_class_id,
                                                                                  newrec_.tax_liability,
                                                                                  newrec_.tax_liability_type,
                                                                                  delivery_country_db_,
                                                                                  add_tax_lines_             => TRUE,
                                                                                  net_curr_amount_           => NULL,
                                                                                  gross_curr_amount_         => NULL,
                                                                                  ifs_curr_rounding_         => NULL,
                                                                                  free_of_charge_tax_basis_  => newrec_.free_of_charge_tax_basis,
                                                                                  attr_                      => attr_);

   Tax_Handling_Order_Util_API.Add_Transaction_Tax_Info (line_amount_rec_,
                                                         multiple_tax_,
                                                         tax_info_table_,
                                                         tax_line_param_rec_,
                                                         source_key_rec_,
                                                         attr_);
END Add_Transaction_Tax_Info___;


PROCEDURE Recalculate_Tax_Lines___ (
   newrec_             IN order_quotation_line_tab%ROWTYPE,
   company_            IN VARCHAR2,
   customer_no_        IN VARCHAR2,
   ship_addr_no_       IN VARCHAR2,
   supply_country_db_  IN VARCHAR2,
   use_price_incl_tax_ IN VARCHAR2,
   currency_code_      IN VARCHAR2,
   from_defaults_      IN BOOLEAN,   
   attr_               IN VARCHAR2)
IS
   delivery_country_db_         VARCHAR2(2);
   source_key_rec_              Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_          Tax_Handling_Order_Util_API.tax_line_param_rec;
BEGIN
   delivery_country_db_ := NVL(newrec_.ship_addr_country_code, Order_Quotation_API.Get_Country_Code(newrec_.quotation_no));
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                                      newrec_.quotation_no, 
                                                                      newrec_.line_no, 
                                                                      newrec_.rel_no, 
                                                                      newrec_.line_item_no,
                                                                      '*',
                                                                      attr_); 
   
   tax_line_param_rec_ := Tax_Handling_Order_Util_API.Create_Tax_Line_Param_Rec (company_,
                                                                                 newrec_.contract,
                                                                                 customer_no_,
                                                                                 ship_addr_no_,
                                                                                 NVL(newrec_.planned_due_date, TRUNC(Site_API.Get_Site_Date(newrec_.contract))),
                                                                                 supply_country_db_,
                                                                                 newrec_.delivery_type,
                                                                                 newrec_.part_no,
                                                                                 use_price_incl_tax_,
                                                                                 currency_code_,
                                                                                 newrec_.currency_rate,                                                                                       
                                                                                 NULL,
                                                                                 from_defaults_,
                                                                                 newrec_.tax_code,
                                                                                 newrec_.tax_calc_structure_id,
                                                                                 newrec_.tax_class_id,
                                                                                 newrec_.tax_liability,
                                                                                 newrec_.tax_liability_type,
                                                                                 delivery_country_db_,
                                                                                 add_tax_lines_            => TRUE,
                                                                                 net_curr_amount_          => NULL,
                                                                                 gross_curr_amount_        => NULL,
                                                                                 ifs_curr_rounding_        => NULL,
                                                                                 free_of_charge_tax_basis_ => newrec_.free_of_charge_tax_basis,
                                                                                 attr_                     => attr_);

   Tax_Handling_Order_Util_API.Recalculate_Tax_Lines (source_key_rec_,
                                                      tax_line_param_rec_,
                                                      attr_);
END Recalculate_Tax_Lines___;

--   Modify the default_addr_flag attribute
PROCEDURE Modify_Default_Addr_Flag__ (
   quotation_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   default_addr_flag_ IN VARCHAR2 )
IS
   attr_  VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DEFAULT_ADDR_FLAG_DB', default_addr_flag_, attr_);
   Modify_Line___(attr_, quotation_no_, line_no_, rel_no_, line_item_no_);
END Modify_Default_Addr_Flag__;

PROCEDURE Calculate_Prices___ (
   newrec_     IN OUT order_quotation_line_tab%ROWTYPE )
IS
   quote_rec_             Order_Quotation_API.Public_Rec;
   tax_liability_type_db_ VARCHAR2(20);
   multiple_tax_          VARCHAR2(20);
BEGIN   
   quote_rec_  := Order_Quotation_API.Get(newrec_.quotation_no);
      
   IF (Order_Supply_Type_API.Encode(newrec_.demand_code) = 'IPD') THEN
      tax_liability_type_db_ := External_Cust_Order_Line_API.Get_Tax_Liability(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no);
   ELSE
      tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, 
                                   NVL(newrec_.ship_addr_country_code, quote_rec_.country_code));
   END IF;

   Tax_Handling_Order_Util_API.Get_Prices(newrec_.base_sale_unit_price,
                                          newrec_.base_unit_price_incl_tax,
                                          newrec_.sale_unit_price,
                                          newrec_.unit_price_incl_tax,
                                          multiple_tax_,
					                           newrec_.tax_code,
                                          newrec_.tax_calc_structure_id,
                                          newrec_.tax_class_id,
                                          newrec_.quotation_no, 
                                          newrec_.line_no, 
                                          newrec_.rel_no,
                                          newrec_.line_item_no,
                                          '*',
                                          Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                          quote_rec_.contract,
                                          quote_rec_.customer_no,
                                          quote_rec_.ship_addr_no,
                                          NVL(newrec_.planned_due_date, TRUNC(Site_API.Get_Site_Date(newrec_.contract))),
                                          quote_rec_.supply_country,
                                          NVL(newrec_.delivery_type, '*'),
                                          newrec_.catalog_no,
                                          quote_rec_.use_price_incl_tax,
                                          quote_rec_.currency_code,
                                          newrec_.currency_rate,
                                          'FALSE',                                          
                                          newrec_.tax_liability,
                                          tax_liability_type_db_,
                                          delivery_country_db_ => NULL,
                                          ifs_curr_rounding_ => 16,
                                          tax_from_diff_source_ => 'FALSE',
                                          attr_ => NULL); 
END Calculate_Prices___;

-- Modify_Delivery_Address__
-- Update the ship address number and the single occurance address flag
-- This method call from header to update line delivery address to header delivery 
-- addr for line with default info set to no but having same delivery address.
PROCEDURE Modify_Delivery_Address__ (
   quotation_no_        IN     VARCHAR2,
   line_no_             IN     VARCHAR2,
   rel_no_              IN     VARCHAR2,
   line_item_no_        IN     NUMBER,
   ship_addr_no_        IN     VARCHAR2,
   single_occ_addr_flag_       IN     VARCHAR2,
   update_tax_          IN     BOOLEAN DEFAULT TRUE )
IS
   objid_                  VARCHAR2(2000);
   objversion_             VARCHAR2(2000);
   oldrec_                 ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   newrec_                 ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   insert_package_mode_    VARCHAR2(5) := 'FALSE';
   attr_                   VARCHAR2(2000);
   indrec_                 Indicator_Rec;
   
BEGIN
   IF ship_addr_no_ IS NOT NULL THEN
      Client_SYS.Set_Item_Value('SHIP_ADDR_NO', ship_addr_no_, attr_);
   END IF ;
   IF single_occ_addr_flag_ IS NOT NULL THEN
      Client_SYS.Set_Item_Value('SINGLE_OCC_ADDR_FLAG', single_occ_addr_flag_, attr_);
   END IF ;   
   Client_SYS.Set_Item_Value('COPY_ADDR_TO_LINE', 'TRUE', attr_);
   
   IF NOT update_tax_ THEN 
      Client_SYS.Set_Item_Value('UPDATE_TAX', 'FALSE', attr_);
   END IF;
   
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, line_no_, rel_no_, line_item_no_);
   oldrec_              := Lock_By_Id___(objid_, objversion_);
   newrec_              := oldrec_;
   Client_SYS.Add_To_Attr('INSERT_PACKAGE_MODE_', insert_package_mode_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Delivery_Address__;

PROCEDURE Single_Occ_Addr_Match__ (
   line_rec_ IN ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   header_rec_        IN     Order_Quotation_API.Public_Rec,
   match_  IN OUT BOOLEAN )
IS
BEGIN
   match_ := Single_Occ_Addr_Match_Quot___(line_rec_, header_rec_);
END Single_Occ_Addr_Match__;

-- gelr:disc_price_rounded, begin
FUNCTION Get_Displayed_Discount__ (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER) RETURN NUMBER
IS
BEGIN
   IF (Order_Quotation_API.Get_Discounted_Price_Rounded(quotation_no_)) THEN
      RETURN Get_Original_Discount(quotation_no_, line_no_, rel_no_, line_item_no_);
   ELSE
      RETURN Get_Discount(quotation_no_, line_no_, rel_no_, line_item_no_);
   END IF;
END Get_Displayed_Discount__;
-- gelr:disc_price_rounded, end
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Fetch_Tax_Line_Param(   
   company_                IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2,
   currency_rate_          IN NUMBER DEFAULT NULL) RETURN Tax_Handling_Order_Util_API.tax_line_param_rec
IS
   quote_rec_           Order_Quotation_API.Public_Rec;
   quote_line_rec_      Order_Quotation_Line_API.Public_Rec;
   tax_line_param_rec_  Tax_Handling_Order_Util_API.tax_line_param_rec;
   tax_liability_type_db_  VARCHAR2(20);
BEGIN
   quote_rec_          := Order_Quotation_API.Get(source_ref1_);
   quote_line_rec_     := Order_Quotation_Line_API.Get(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      
   tax_line_param_rec_.company             := company_;
   tax_line_param_rec_.contract            := quote_rec_.contract;
   tax_line_param_rec_.customer_no         := quote_rec_.customer_no;
   tax_line_param_rec_.ship_addr_no        := quote_rec_.ship_addr_no;
   tax_line_param_rec_.planned_ship_date   := NVL(quote_line_rec_.planned_due_date, TRUNC(Site_API.Get_Site_Date(quote_rec_.contract)));
   tax_line_param_rec_.supply_country_db   := quote_rec_.supply_country;
   tax_line_param_rec_.delivery_type       := NVL(quote_line_rec_.delivery_type, '*');
   tax_line_param_rec_.object_id           := quote_line_rec_.catalog_no;
   tax_line_param_rec_.use_price_incl_tax  := quote_rec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code       := quote_rec_.currency_code;
   tax_line_param_rec_.currency_rate       := NVL(currency_rate_, quote_line_rec_.currency_rate);  
   tax_line_param_rec_.tax_liability       := quote_line_rec_.tax_liability;
   IF (Order_Supply_Type_API.Encode(quote_line_rec_.demand_code) = 'IPD') THEN
      tax_liability_type_db_ := External_Cust_Order_Line_API.Get_Tax_Liability(source_ref1_, source_ref2_, source_ref3_);
   ELSE
      tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(quote_line_rec_.tax_liability, 
                                   NVL(quote_line_rec_.ship_addr_country_code, quote_rec_.country_code));
   END IF;
   tax_line_param_rec_.tax_liability_type_db := tax_liability_type_db_;
   tax_line_param_rec_.tax_code              := quote_line_rec_.tax_code;
   tax_line_param_rec_.tax_calc_structure_id := quote_line_rec_.tax_calc_structure_id;
   tax_line_param_rec_.tax_class_id          := quote_line_rec_.tax_class_id;
   tax_line_param_rec_.taxable               := Sales_Part_API.Get_Taxable_Db(quote_rec_.contract, quote_line_rec_.part_no);

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
   gross_curr_amount_ := Order_Quotation_Line_API.Get_Sale_Price_Incl_Tax_Total(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
   net_curr_amount_  := Order_Quotation_Line_API.Get_Sale_Price_Total(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
   tax_curr_amount_  := Order_Quotation_Line_API.Get_Total_Tax_Amount_Curr(source_ref1_, source_ref2_, source_ref3_, source_ref4_); 
END Fetch_Gross_Net_Tax_Amounts;


-- Modify_Tax_Class_Id
--   Modifies the tax class id when the tax code is changed from the
--   Sales quotation tax lines dialog
PROCEDURE Modify_Tax_Class_Id (
   attr_ IN OUT VARCHAR2,
   quotation_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   oldrec_           ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   newrec_           ORDER_QUOTATION_LINE_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, line_no_, rel_no_, line_item_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.tax_class_id := Client_Sys.get_item_value('TAX_CLASS_ID',attr_); 
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Tax_Class_Id;


-- Modify_Quotation_Discount
--   Modify the discount of quotation
PROCEDURE Modify_Quotation_Discount (
   quotation_no_       IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   quotation_discount_ IN NUMBER,
   update_tax_         IN BOOLEAN DEFAULT TRUE)
IS
   attr_   VARCHAR2(2000);
   CURSOR get_package_lines IS
      SELECT line_item_no
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      AND    rowstate != 'Cancelled';
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QUOTATION_DISCOUNT', quotation_discount_, attr_);
   
   IF NOT update_tax_ THEN 
      Client_SYS.Add_To_Attr('UPDATE_TAX', 'FALSE', attr_);
   END IF;
   
   Modify_Line___(attr_, quotation_no_, line_no_, rel_no_, line_item_no_);
   IF (line_item_no_ = -1) THEN
      FOR component_ IN get_package_lines LOOP
         -- Reinitialize the attribute string as it might have been changed in the previous update
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('QUOTATION_DISCOUNT', quotation_discount_, attr_);
         
         IF NOT update_tax_ THEN 
            Client_SYS.Add_To_Attr('UPDATE_TAX', 'FALSE', attr_);
         END IF;
         
         Modify_Line___(attr_, quotation_no_, line_no_, rel_no_, component_.line_item_no);
      END LOOP;
   END IF;
END Modify_Quotation_Discount;


-- Modify_Cost
--   Modify cost for a quotation line
PROCEDURE Modify_Cost (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   cost_         IN NUMBER )
IS
   attr_  VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_to_Attr('COST', cost_, attr_);
   Modify_Line___(attr_, quotation_no_, line_no_, rel_no_,line_item_no_);
END Modify_Cost;


@UncheckedAccess
FUNCTION Get_Price_Total (
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Sale_Price_Total(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
END Get_Price_Total;


@UncheckedAccess
FUNCTION Get_Price_Incl_Tax_Total  (
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Sale_Price_Incl_Tax_Total (source_ref1_, source_ref2_, source_ref3_, source_ref4_);
END Get_Price_Incl_Tax_Total ;


-- Get_Sale_Price_Total
--   Retrive the total sale price for the specified quotation line
--   in quotation currency.
@UncheckedAccess
FUNCTION Get_Sale_Price_Total (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   rental_chargable_days_ IN NUMBER DEFAULT NULL) RETURN NUMBER
IS
   contract_                  Site_Tab.contract%TYPE;
   total_net_amount_          NUMBER;
   net_curr_amount_           NUMBER;
   new_rental_chargable_days_ NUMBER;
   total_discount_amount_     NUMBER;
   rounding_                  NUMBER;
   head_rec_                  Order_Quotation_API.Public_Rec;
   
   CURSOR get_total IS
      SELECT contract, buy_qty_due * price_conv_factor * sale_unit_price total_net_amount
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   IF (Get_Free_of_charge_Db(quotation_no_, line_no_, rel_no_, line_item_no_) = Fnd_Boolean_API.DB_TRUE) THEN
      net_curr_amount_ := 0;
   ELSE 
      head_rec_ := Order_Quotation_API.Get(quotation_no_);
      IF (head_rec_.use_price_incl_tax  = Fnd_Boolean_API.DB_TRUE) THEN
         net_curr_amount_ := Get_Sale_Price_Incl_Tax_Total(quotation_no_, line_no_, rel_no_, line_item_no_) - Get_Total_Tax_Amount_Curr(quotation_no_, line_no_, rel_no_, line_item_no_);
      ELSE
         OPEN get_total;
         FETCH get_total INTO contract_, total_net_amount_;
         CLOSE get_total;

         new_rental_chargable_days_ := NVL(rental_chargable_days_,  Get_Rental_Chargeable_Days(quotation_no_, line_no_, rel_no_, line_item_no_));      
         rounding_                  := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(contract_), head_rec_.currency_code);

         total_net_amount_          := total_net_amount_ * new_rental_chargable_days_;
         total_discount_amount_     := Get_Total_Discount_Amount(quotation_no_, line_no_, rel_no_, line_item_no_, total_net_amount_);
         total_net_amount_          := ROUND(total_net_amount_, rounding_);
         net_curr_amount_           := total_net_amount_ - total_discount_amount_;
      END IF;
   END IF;
   RETURN net_curr_amount_;
END Get_Sale_Price_Total;


-- Get_Sale_Price_Incl_Tax_Total
--   Retrive the total sale price incl tax for the specified quotation line
--   in quotation currency.
@UncheckedAccess
FUNCTION Get_Sale_Price_Incl_Tax_Total (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   contract_               Site_Tab.contract%TYPE;
   total_gross_amount_     NUMBER;
   net_curr_amount_        NUMBER;
   gross_curr_amount_      NUMBER;
   rounding_               NUMBER;
   rental_chargeable_days_ NUMBER;
   total_discount_amount_  NUMBER;
   head_rec_                  Order_Quotation_API.Public_Rec;
   
   CURSOR get_total IS
      SELECT contract, buy_qty_due * price_conv_factor * unit_price_incl_tax total_gross_amount
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   IF (Get_Free_of_charge_Db(quotation_no_, line_no_, rel_no_, line_item_no_) = Fnd_Boolean_API.DB_TRUE) THEN
      gross_curr_amount_ := Get_Total_Tax_Amount_Curr(quotation_no_, line_no_, rel_no_, line_item_no_);
   ELSE 
      head_rec_ := Order_Quotation_API.Get(quotation_no_);
      IF head_rec_.use_price_incl_tax = Fnd_Boolean_API.DB_TRUE THEN
         OPEN get_total;
         FETCH get_total INTO contract_, total_gross_amount_;
         CLOSE get_total;

         rounding_             := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(contract_), head_rec_.currency_code);
         -- For rental lines, rental_chargeable_days_ retreived from the rental object.
         -- Otherwise rental chargeable days equal 1.
         rental_chargeable_days_ := Get_Rental_Chargeable_Days(quotation_no_, line_no_, rel_no_, line_item_no_);

         total_gross_amount_     := ROUND((total_gross_amount_ * rental_chargeable_days_), rounding_);
         total_discount_amount_  := Get_Total_Discount_Amount(quotation_no_, line_no_, rel_no_, line_item_no_, total_gross_amount_);
         gross_curr_amount_      := total_gross_amount_ - total_discount_amount_;
      ELSE
         net_curr_amount_   := Get_Sale_Price_Total(quotation_no_, line_no_, rel_no_, line_item_no_);
         gross_curr_amount_ := net_curr_amount_ + Get_Total_Tax_Amount_Curr(quotation_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   END IF;
   RETURN gross_curr_amount_;
END Get_Sale_Price_Incl_Tax_Total;

-------------------------------------------------------------------------------
-- Get_Sales_Price_Totals
--   Return sales price and sales price including tax for an order quotation line.
-------------------------------------------------------------------------------
PROCEDURE Get_Sales_Price_Totals (
   sale_price_total_           OUT  NUMBER,
   sale_price_incl_tax_total_  OUT  NUMBER,
   quotation_no_               IN   VARCHAR2,
   line_no_                    IN   VARCHAR2,
   rel_no_                     IN   VARCHAR2,
   line_item_no_               IN   NUMBER )
is
   contract_                  Site_Tab.contract%TYPE;
   currency_code_             VARCHAR2(3);
   total_net_amount_          NUMBER;
   total_discount_amount_     NUMBER;
   rounding_                  NUMBER;
   total_gross_amount_        NUMBER;
   rental_chargeable_days_    NUMBER;
   head_rec_                  Order_Quotation_API.Public_Rec;
      
   CURSOR get_totals IS
       SELECT buy_qty_due * price_conv_factor * sale_unit_price total_net_amount, 
              buy_qty_due * price_conv_factor * unit_price_incl_tax total_gross_amount
       FROM   ORDER_QUOTATION_LINE_TAB
       WHERE  quotation_no = quotation_no_
       AND    line_no      = line_no_
       AND    rel_no       = rel_no_
       AND    line_item_no = line_item_no_;

BEGIN
   IF (Get_Free_of_charge_Db(quotation_no_, line_no_, rel_no_, line_item_no_) = Fnd_Boolean_API.DB_TRUE) THEN
      sale_price_incl_tax_total_ := Get_Total_Tax_Amount_Curr(quotation_no_, line_no_, rel_no_, line_item_no_);
      sale_price_total_          := 0;
   ELSE 
      OPEN get_totals;
      FETCH get_totals INTO total_net_amount_, total_gross_amount_;
      CLOSE get_totals;
      
      head_rec_               := Order_Quotation_API.Get(quotation_no_);
      currency_code_          := head_rec_.currency_code;
      rounding_               := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(head_rec_.contract), currency_code_);
      rental_chargeable_days_ := Get_Rental_Chargeable_Days(quotation_no_, line_no_, rel_no_, line_item_no_);
         
      IF head_rec_.use_price_incl_tax = Fnd_Boolean_API.DB_TRUE THEN
         total_gross_amount_         := ROUND((total_gross_amount_ * rental_chargeable_days_), rounding_);
         total_discount_amount_      := Get_Total_Discount_Amount(quotation_no_, line_no_, rel_no_, line_item_no_, total_gross_amount_);
         sale_price_incl_tax_total_  := total_gross_amount_ - total_discount_amount_;
         sale_price_total_           := sale_price_incl_tax_total_ - Get_Total_Tax_Amount_Curr(quotation_no_, line_no_, rel_no_, line_item_no_);
      ELSE
         total_net_amount_           := total_net_amount_ * rental_chargeable_days_;
         total_discount_amount_      := Get_Total_Discount_Amount(quotation_no_, line_no_, rel_no_, line_item_no_, total_net_amount_);
         total_net_amount_           := ROUND(total_net_amount_, rounding_);
         sale_price_total_           := total_net_amount_ - total_discount_amount_;
         sale_price_incl_tax_total_  := sale_price_total_ + Get_Total_Tax_Amount_Curr(quotation_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   END IF;
END Get_Sales_Price_Totals;

FUNCTION Get_Sale_Price_Excl_Tax_Total (
   quotation_no_   IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,
   tax_percentage_ IN NUMBER ) RETURN NUMBER
IS
   contract_               VARCHAR2(5);
   currency_code_          VARCHAR2(3);
   total_gross_amount_     NUMBER;
   total_net_amount_       NUMBER;
   discount_               NUMBER; 
   quote_discount_         NUMBER; 
   additional_discount_    NUMBER;
   line_discount_amount_   NUMBER;
   add_disc_amt_           NUMBER;
   quote_discount_amount_  NUMBER;
   net_curr_amount_        NUMBER;
   rounding_               NUMBER;
   total_discount_         NUMBER;   
   buy_qty_due_            NUMBER;
   price_conv_factor_      NUMBER;
   rental_chargeable_days_ NUMBER;
   head_rec_               Order_Quotation_API.Public_Rec;
   
   CURSOR get_total IS
      SELECT contract, buy_qty_due * price_conv_factor * unit_price_incl_tax total_gross_amount,
             discount, quotation_discount, buy_qty_due, price_conv_factor
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   OPEN get_total;
   FETCH get_total INTO contract_, total_gross_amount_, discount_, quote_discount_, buy_qty_due_, price_conv_factor_;
   CLOSE get_total;
   currency_code_         := head_rec_.currency_code;
   rounding_              := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(contract_), currency_code_);
   
   -- For rental lines, rental_chargeable_days_ retreived from the rental object.
   -- Otherwise rental chargeable days equal 1.
   rental_chargeable_days_ := Get_Rental_Chargeable_Days(quotation_no_, line_no_, rel_no_, line_item_no_);
   
   total_gross_amount_    := ROUND(total_gross_amount_ * rental_chargeable_days_, rounding_);
   total_net_amount_      := ROUND(total_gross_amount_ / (1 + (tax_percentage_/100)), rounding_);
   -- NOTE: Discounts are calculated using values including tax. Total discount without tax is obtained from Total discount with tax. 
   --       This is to be consistant with Sales quotation and Customer Invoice.
   -- gelr:disc_price_rounded:DIS005, begin
   IF (Order_Quotation_API.Get_Discounted_Price_Rounded(quotation_no_)) THEN
      -- Additional discount must be taken from line not from header, because at line it is recalculated and at header not
      additional_discount_ := Get_Additional_Discount(quotation_no_, line_no_, rel_no_, line_item_no_);
   ELSE
      additional_discount_   := head_rec_.additional_discount; 
   END IF;
   -- gelr:disc_price_rounded:DIS005, end   
   line_discount_amount_  := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(quotation_no_, line_no_, rel_no_, line_item_no_, 
                                                                                   buy_qty_due_, price_conv_factor_, rounding_);
   add_disc_amt_          := ROUND(((total_gross_amount_ - line_discount_amount_) * additional_discount_/100 ), rounding_);
   quote_discount_amount_ := ROUND((total_gross_amount_ - line_discount_amount_) * (quote_discount_/100), rounding_);

   -- discount without tax is calculated seperately for discount types
   line_discount_amount_  := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(quotation_no_, line_no_, rel_no_, line_item_no_, 
                                                                                   buy_qty_due_, price_conv_factor_, rounding_, tax_percentage_);
   add_disc_amt_          := ROUND(add_disc_amt_ / (1 + (tax_percentage_/100)), rounding_);
   quote_discount_amount_ := ROUND(quote_discount_amount_ / (1 + (tax_percentage_/100)), rounding_);
   total_discount_        := line_discount_amount_ + add_disc_amt_ + quote_discount_amount_; 
   net_curr_amount_       := total_net_amount_ - total_discount_;
   RETURN net_curr_amount_;
END Get_Sale_Price_Excl_Tax_Total;

-- Get_Next_Line_Item_No
--   Used from orderpkg.app:
--   Gets the next line item no for a package structure.
PROCEDURE Get_Next_Line_Item_No (
   line_item_no_ IN OUT NUMBER,
   quotation_no_ IN     VARCHAR2,
   line_no_      IN     VARCHAR2,
   rel_no_       IN     VARCHAR2 )
IS
   CURSOR get_line_item_no IS
   SELECT nvl(max(line_item_no + 1), 1)
   FROM   ORDER_QUOTATION_LINE_TAB
   WHERE  line_item_no != -1
   AND    rel_no = rel_no_
   AND    line_no = line_no_
   AND    quotation_no = quotation_no_;
BEGIN
   OPEN  get_line_item_no;
   FETCH get_line_item_no into line_item_no_;
   CLOSE get_line_item_no;
END Get_Next_Line_Item_No;


-- Exist_Line_No
--   Returns an error message if quotation line already exist.
PROCEDURE Exist_Line_No (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   dummy_   NUMBER;
   CURSOR exist_control IS
      SELECT 1
         FROM ORDER_QUOTATION_LINE_TAB
         WHERE quotation_no = quotation_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no = NVL(line_item_no_, line_item_no);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN 
      CLOSE exist_control;
      Error_SYS.Record_General(lu_name_, 'LINE_ALREADY_EXISTS: This quotation line already exists!');
      END IF;
   CLOSE exist_control;
END Exist_Line_No;


-- Exist_Lines
--   Checks wether there are quotation lines.
FUNCTION Exist_Lines (
   quotation_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_lines IS
      SELECT 1
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_;
BEGIN
   IF (quotation_no_ IS NULL) THEN
      RETURN 'FALSE';
   END IF;
   OPEN exist_lines;
   FETCH exist_lines INTO dummy_;
   IF (exist_lines%FOUND) THEN
      CLOSE exist_lines;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_lines;
   RETURN 'FALSE';
END Exist_Lines;


-- Set_Cancelled
--   Public interface used to generate the SetCancelled event and
--   pass it to the finite state machine for processing.
PROCEDURE Set_Cancelled (
   quotation_no_  IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   cancel_reason_ IN VARCHAR2 )
IS
   rec_  ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   attr_ VARCHAR2(32000);
BEGIN
   Set_Cancel_Reason(quotation_no_, line_no_, rel_no_, line_item_no_, cancel_reason_);
   -- Update reason_id, lost_to and lost_note
   rec_ := Lock_By_Keys___( quotation_no_, line_no_, rel_no_, line_item_no_ );
   Finite_State_Machine___( rec_, 'Cancel', attr_ );
END Set_Cancelled;


-- Set_Released
--   Public interface used to generate the Relase event and pass
--   it to the finite state machine for processing.
PROCEDURE Set_Released (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   rec_  ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   attr_ VARCHAR2(32000);
BEGIN

   -- Update reason_id, lost_to and lost_note
   rec_ := Lock_By_Keys___( quotation_no_, line_no_, rel_no_, line_item_no_ );
   Finite_State_Machine___( rec_, 'Release', attr_ );
END Set_Released;

-- Set_Rejected
--   Public interface used to generate the Reject event and pass
--   it to the finite state machine for processing.
PROCEDURE Set_Rejected (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   rec_  ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   attr_ VARCHAR2(32000);
BEGIN
   rec_ := Lock_By_Keys___( quotation_no_, line_no_, rel_no_, line_item_no_ );
   Finite_State_Machine___( rec_, 'Reject', attr_ );
END Set_Rejected;


-- New
--   Public interface for creating a new quotation line
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS 
   new_attr_            VARCHAR2(32000);
   newrec_              ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);   
   insert_package_mode_ BOOLEAN := FALSE;
   current_info_        VARCHAR2(2000);
   indrec_              Indicator_Rec;   
   discount_            NUMBER;
   copy_status_         VARCHAR2(5);
BEGIN

   Client_SYS.Clear_Info;
   current_info_ := NULL;
   App_Context_SYS.Set_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_', current_info_); 
   
   Build_Attr_For_New___(discount_, new_attr_, attr_);
   
   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);   
   Insert___(objid_, objversion_, newrec_, new_attr_);
   
   copy_status_ := Client_SYS.Get_Item_Value('COPY_STATUS', attr_);
   
   IF (((discount_ IS NOT NULL) AND (discount_ != newrec_.discount)) OR NVL(copy_status_, 'FALSE') = 'TRUE') THEN   
      Order_Quote_Line_Discount_API.Replace_Discount(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, discount_, copy_status_);
      Order_Quote_Line_Discount_API.Calc_Discount_Upd_Oq_Line__(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   END IF; 
   
   Calculate_Prices___(newrec_); 
   IF NOT insert_package_mode_ THEN
      info_ := Client_SYS.Get_All_Info;
   END IF;
   Add_Info___(info_, insert_package_mode_);
   current_info_ :=  App_Context_SYS.Find_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_');
   info_ := current_info_;
   IF (Client_SYS.Get_Item_Value('CREATE_TEMPLATE_FROM_AURENA', attr_) = 'TRUE') THEN
      Client_SYS.Add_To_Attr('QUOTATION_NO', newrec_.quotation_no, new_attr_);   
   END IF;
   attr_ := new_attr_;
END New;

-- Modify
--   Public interface for modifying a new customer quotation line
PROCEDURE Modify (
   attr_         IN OUT VARCHAR2,
   quotation_no_ IN     VARCHAR2,
   line_no_      IN     VARCHAR2,
   rel_no_       IN     VARCHAR2,
   line_item_no_ IN     NUMBER )
IS
BEGIN
   Modify_Line___(attr_, quotation_no_, line_no_, rel_no_, line_item_no_);
END Modify;


-- Remove
--   Public interface for removal of a quotation line.
PROCEDURE Remove (
   quotation_no_      IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   remove_to_replace_ IN VARCHAR2 DEFAULT 'FALSE')
IS
   remrec_     ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(quotation_no_, line_no_, rel_no_, line_item_no_);
   Validate_before_Delete___(remrec_, remove_to_replace_ );
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, line_no_, rel_no_, line_item_no_);
   Source_Tax_Item_Order_API.Remove_Tax_Items(remrec_.company,
                                              Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                              quotation_no_,
                                              line_no_,
                                              rel_no_,
                                              TO_CHAR(line_item_no_),
                                              '*');
   Delete___(objid_, remrec_);
END Remove;


-- Get_Objversion
--   Return the current objversion for line
FUNCTION Get_Objversion (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_  ORDER_QUOTATION_LINE_TAB.rowversion%TYPE;
   CURSOR get_attr IS
      SELECT rowversion
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN TO_CHAR(temp_, 'YYYYMMDDHH24MISS');
END Get_Objversion;

-- Copy_Quotation_Line
--   Copy sales quotation lines from a quotation number to another.
PROCEDURE Copy_Quotation_Line (
   from_quotation_no_     IN VARCHAR2,
   to_quotation_no_       IN VARCHAR2,
   wanted_delivery_date_  IN DATE,
   copy_pricing_          IN VARCHAR2,
   copy_document_texts_   IN VARCHAR2,
   copy_notes_            IN VARCHAR2,
   copy_charges_          IN VARCHAR2,
   rental_db_             IN VARCHAR2 DEFAULT 'FALSE')
IS
   objid_               ORDER_QUOTATION_LINE.objid%TYPE;
   objversion_          ORDER_QUOTATION_LINE.objversion%TYPE;
   attr_                VARCHAR2(32000);
   newrec_              ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   empty_rec_           ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   indrec_              Indicator_Rec;
   quote_rec_           ORDER_QUOTATION_API.Public_Rec;
   dummy_info_                    VARCHAR2(32000);
   original_config_line_price_id_ ORDER_QUOTATION_LINE_TAB.configured_line_price_id%TYPE;
   CURSOR get_rec IS
      SELECT *
      FROM  order_quotation_line_tab
      WHERE quotation_no = from_quotation_no_
      AND   rental = rental_db_;
BEGIN
   quote_rec_ := Order_Quotation_API.Get(from_quotation_no_);
   FOR linerec_ IN get_rec LOOP
      -- Reset variables
      newrec_ := empty_rec_;
      attr_ := NULL;
      IF wanted_delivery_date_ IS NOT NULL THEN
        linerec_.wanted_delivery_date := wanted_delivery_date_;
      ELSE
        linerec_.wanted_delivery_date := NULL;
      END IF;      
      
      attr_ := Build_Attr_For_Copy_Line___(linerec_, quote_rec_, from_quotation_no_, to_quotation_no_, copy_pricing_, copy_notes_, rental_db_);
      
      -- Configured Line Price
      IF copy_pricing_ = Fnd_Boolean_API.DB_TRUE THEN
         original_config_line_price_id_ := linerec_.configured_line_price_id;
      END IF;
      
      Unpack___(newrec_, indrec_, attr_);
      IF (NVL(copy_charges_, 'FALSE') = 'TRUE') THEN
         Client_SYS.Add_To_Attr( 'DEFAULT_CHARGES', 'FALSE', attr_);   
      END IF;
      Check_Insert___(newrec_, indrec_, attr_);
      newrec_.default_addr_flag := Check_Default_Addr_Flag__(newrec_, to_quotation_no_, newrec_.default_addr_flag);       
      Insert___(objid_, objversion_, newrec_, attr_);
   
      Custom_Objects_SYS.Copy_Cf_Instance(lu_name_, linerec_.rowkey, newrec_.rowkey);
      IF (copy_document_texts_ = Fnd_Boolean_API.DB_TRUE) THEN         
         Document_Text_API.Copy_All_Note_Texts(linerec_.note_id, newrec_.note_id); 
      END IF;
      
      -- Copy all price break lines
      IF copy_pricing_ = Fnd_Boolean_API.DB_TRUE THEN
         Order_Quotation_Grad_Price_API.Copy_All_Lines(linerec_.quotation_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no,
                                                       newrec_.quotation_no,  newrec_.line_no,  newrec_.rel_no,  newrec_.line_item_no);
      END IF;
      
      IF copy_pricing_ = Fnd_Boolean_API.DB_TRUE THEN
         -- Copy Configuration Line Price 
         Configured_Line_price_API.Transfer_Pricing__(dummy_info_, original_config_line_price_id_, newrec_.configured_line_price_id, FALSE);
      ELSE
         Configured_Line_price_API.Transfer_Pricing__(dummy_info_, original_config_line_price_id_, newrec_.configured_line_price_id, TRUE);
      END IF;
      
      Order_Quote_Line_Hist_API.New( newrec_.quotation_no, 
                                     newrec_.line_no, 
                                     newrec_.rel_no, 
                                     newrec_.line_item_no, 
                                     Language_SYS.Translate_Constant(lu_name_, 'COPIED_QUOT_LINE: Copy from quotation :P1', NULL, from_quotation_no_));
   END LOOP;   
END Copy_Quotation_Line;   

-- Create_Order
--   Create a customer order from selected quotation lines.
PROCEDURE Create_Order (
   info_                OUT VARCHAR2,
   order_no_            OUT VARCHAR2,
   pre_accounting_id_   OUT NUMBER,
   quotation_no_        IN  VARCHAR2,
   attr_                IN  VARCHAR2,
   check_status_        IN  VARCHAR2 DEFAULT NULL,
   skip_release_order_  IN  VARCHAR2 DEFAULT NULL,
   update_won_          IN  VARCHAR2 DEFAULT NULL)
IS
   names_                     Message_SYS.Name_Table;
   values_                    Message_SYS.Line_Table;
   count_                     NUMBER;
   line_count_                NUMBER;
   rel_nos_                   array_string;
   line_nos_                  array_string;
   line_item_nos_             array_string;
   line_no_                   ORDER_QUOTATION_LINE_TAB.line_no%TYPE;
   rel_no_                    ORDER_QUOTATION_LINE_TAB.rel_no%TYPE;
   line_item_no_              ORDER_QUOTATION_LINE_TAB.line_item_no%TYPE;
   reason_id_                 ORDER_QUOTATION_LINE_TAB.reason_id%TYPE;
   lose_win_note_             ORDER_QUOTATION_LINE_TAB.lose_win_note%TYPE;
   order_id_                  CUSTOMER_ORDER_TAB.order_id%TYPE;
   wanted_del_date_           CUSTOMER_ORDER_TAB.wanted_delivery_date%TYPE;
   line_attr_                 VARCHAR2(32000);
   def_attr_                  VARCHAR2(32000);
   rec_                       ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   change_line_delivery_date_ VARCHAR2(10);
   charge_rec_                Order_Quotation_Charge_API.Public_Rec;
   transfered_                NUMBER;
   line_rec_                  ORDER_QUOTATION_LINE_API.Public_Rec;
   auth_group_                VARCHAR2(2);
   current_co_no_             NUMBER;
   current_info_              VARCHAR2(32000);
   customer_po_no_            CUSTOMER_ORDER_TAB.customer_po_no%TYPE;
   line_so_attr_              VARCHAR2(32000);
   limit_sales_to_assortments_  CUSTOMER_ORDER_TAB.limit_sales_to_assortments%TYPE;
   copy_all_rep_              VARCHAR2(20);
   main_representative_       VARCHAR2(50);
   copy_contacts_             VARCHAR2(5);
   company_                   VARCHAR2(20);
   external_tax_calc_method_  VARCHAR2(50);
   head_rec_                  Order_Quotation_API.Public_Rec;

   CURSOR get_charges (quotation_no_ IN VARCHAR2) IS
      SELECT quotation_charge_no
      FROM  ORDER_QUOTATION_CHARGE_TAB
      WHERE quotation_no = quotation_no_;

   CURSOR get_transfered_charge IS
      SELECT count(*)
      FROM  ORDER_QUOTATION_LINE_TAB
      WHERE quotation_no = quotation_no_
      AND   rowstate = 'CO Created';

BEGIN
   -- Only selected lines should be transfered
   Message_SYS.Get_Attributes( attr_, count_, names_, values_ );
   line_count_ := 0;
   FOR index_ IN 1 .. count_ LOOP
      IF names_( index_ ) = 'REASON_ID' THEN
         reason_id_ := values_( index_ );
      ELSIF names_( index_ ) = 'ORDER_ID' THEN
         order_id_ := values_( index_ );
      ELSIF names_( index_ ) = 'WANTED_DELIVERY_DATE' THEN
         wanted_del_date_ := Client_SYS.Attr_Value_To_Date(values_( index_ ));
      ELSIF names_( index_ ) = 'WON_NOTE' THEN
         lose_win_note_ := values_( index_ );
      ELSIF names_( index_ ) = 'LINE_NO' THEN
         line_count_ := line_count_ + 1;
         line_nos_( line_count_ ) := values_( index_ );
      ELSIF names_( index_ ) = 'REL_NO' THEN
         rel_nos_( line_count_ ) := values_( index_ );
      ELSIF names_( index_ ) = 'LINE_ITEM_NO' THEN
         line_item_nos_( line_count_ ) := values_( index_ );
      ELSIF names_( index_ ) = 'CHANGE_LINE_DELIVERY_DATE' THEN
         change_line_delivery_date_ := values_( index_ );
      ELSIF names_ ( index_ ) = 'CUSTOMER_PO_NO' THEN
         customer_po_no_ := values_( index_ );
      ELSIF names_ (index_) = 'LIMIT_SALES_TO_ASSORTMENTS' THEN
         limit_sales_to_assortments_ := values_(index_);
      ELSIF names_ (index_) = 'COPY_ALL_REPRESENTATIVES' THEN
         copy_all_rep_ := values_(index_);
      ELSIF names_ (index_) = 'MAIN_REPRESENTATIVE' THEN
         main_representative_ := values_(index_);
      ELSIF names_ (index_) = 'COPY_CONTACTS' THEN
         copy_contacts_ := values_(index_);
      END IF;
   END LOOP;
   
   head_rec_      := Order_Quotation_API.Get(quotation_no_);
   auth_group_    := Order_Coordinator_API.Get_Authorize_Group(head_rec_.authorize_code);
   current_co_no_ := Order_Coordinator_Group_API.Get_Cust_Order_No(auth_group_);
   -- Create order head
   ORDER_QUOTATION_API.Create_Order_Head(order_no_, quotation_no_, order_id_, wanted_del_date_, 'FALSE', pre_accounting_id_, customer_po_no_, limit_sales_to_assortments_, copy_all_rep_, main_representative_, copy_contacts_);
   -- Create order lines
   Client_SYS.Clear_Attr( def_attr_ );
   Client_SYS.Add_To_Attr( 'ORDER_NO', order_no_, def_attr_ );
   Client_SYS.Add_To_Attr( 'WANTED_DELIVERY_DATE', wanted_del_date_, def_attr_ );
   Client_SYS.Add_To_Attr( 'CHANGE_LINE_DELIVERY_DATE', change_line_delivery_date_, def_attr_ );
   FOR index_ IN 1 .. line_count_ LOOP
      line_attr_ := def_attr_;
      line_no_ := line_nos_( index_ );
      rel_no_ := rel_nos_( index_ );
      line_item_no_ := TO_NUMBER( line_item_nos_( index_ ));
      rec_ := Lock_By_Keys___( quotation_no_, line_no_, rel_no_, line_item_no_ );
      IF (update_won_ = 'TRUE') THEN
         Client_SYS.Add_To_Attr( 'REASON_ID', reason_id_, line_attr_ );
         Client_SYS.Add_To_Attr( 'LOSE_WIN_NOTE', lose_win_note_, line_attr_ );
      ELSE
         IF (rec_.reason_id IS NULL) THEN
            Client_SYS.Add_To_Attr( 'REASON_ID', reason_id_, line_attr_ );
         ELSE
            Client_SYS.Add_To_Attr( 'REASON_ID', rec_.reason_id, line_attr_ );
         END IF;
         
         IF rec_.lose_win_note IS NULL THEN
            Client_SYS.Add_To_Attr( 'LOSE_WIN_NOTE', lose_win_note_, line_attr_ );
         ELSE
            Client_SYS.Add_To_Attr( 'LOSE_WIN_NOTE', rec_.lose_win_note, line_attr_ );
         END IF;
      END IF;
      Finite_State_Machine___( rec_, 'QuotationLineWithCo', line_attr_ );

      -- Create charges and delete defaulted charge tax lines.
      FOR c_rec_ IN get_charges(quotation_no_) LOOP
         charge_rec_ := Order_Quotation_Charge_API.Get(quotation_no_, c_rec_.quotation_charge_no);
         line_rec_ := Get(quotation_no_, line_no_, rel_no_, line_item_no_);

         IF ( Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(charge_rec_.contract, charge_rec_.Charge_Type) NOT IN ('FREIGHT','PROMOTION')) THEN
            IF line_no_ = charge_rec_.line_no AND rel_no_ = charge_rec_.rel_no AND line_item_no_ = charge_rec_.line_item_no THEN
               -- IF the charge is connected to the quotation line, transfer the charge
               Order_Quotation_Charge_API.Transfer_To_Order_Line(quotation_no_, c_rec_.quotation_charge_no, order_no_,
                                                                 line_rec_.con_line_no, line_rec_.con_rel_no, line_rec_.con_line_item_no);
            ELSIF charge_rec_.line_no IS NULL THEN
               -- IF a charge is not connected to a specific quotation line and it's not a charge percentage, it should only be transfered once
               IF (charge_rec_.charge IS NULL) THEN
                  OPEN get_transfered_charge;
                  FETCH get_transfered_charge INTO transfered_;
                  CLOSE get_transfered_charge;
               ELSE
                  -- Set transfered_ to 0, sh that a line of percentage type charge is created in CO.
                  transfered_ := 0;
               END IF;
               IF transfered_ <= 1 THEN
                  Order_Quotation_Charge_API.Transfer_To_Order(quotation_no_, c_rec_.quotation_charge_no, order_no_);
               END IF;
            END IF;
         END IF;
      END LOOP;
      
      Customer_Order_Charge_Util_API.Recalc_Percentage_Charge_Taxes(order_no_, line_no_, FALSE);      
      
      IF rec_.single_occ_addr_flag = 'TRUE' AND rec_.default_addr_flag = 'N' THEN 
         Client_SYS.Clear_Attr( line_so_attr_ );
         Client_SYS.Set_Item_Value('ADDR_FLAG', Gen_Yes_No_API.Decode('Y'), line_so_attr_);
         Client_SYS.Set_Item_Value('ADDR_FLAG_DB', 'Y', line_so_attr_ );
         Client_SYS.Add_To_Attr('COUNTRY_CODE', rec_.ship_addr_country_code, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDR_1', rec_.ship_addr_name, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDRESS1', rec_.ship_address1, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDRESS2', rec_.ship_address2, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDRESS3', rec_.ship_address3, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDRESS4', rec_.ship_address4, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDRESS5', rec_.ship_address5, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDRESS6', rec_.ship_address6, line_so_attr_);
         Client_SYS.Add_To_Attr('ZIP_CODE', rec_.ship_addr_zip_code, line_so_attr_);
         Client_SYS.Add_To_Attr('CITY', rec_.ship_addr_city, line_so_attr_);
         Client_SYS.Add_To_Attr('STATE', rec_.ship_addr_state, line_so_attr_);
         Client_SYS.Add_To_Attr('COUNTY', rec_.ship_addr_county, line_so_attr_);
         Client_SYS.Add_To_Attr('IN_CITY', rec_.ship_addr_in_city, line_so_attr_);
         Client_SYS.Add_To_Attr('COMPANY', rec_.company, line_so_attr_);
         Cust_Order_Line_Address_API.Change_Address(line_so_attr_, order_no_, line_no_, rel_no_, line_item_no_);
      END IF ;
      
   END LOOP;

   current_info_  := NULL;
   App_Context_SYS.Set_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_', current_info_);

   IF skip_release_order_ = 'FALSE' THEN
      IF order_no_ IS NOT NULL THEN 
         IF (check_status_ ='TRUE' ) THEN
            ORDER_QUOTATION_API.Release_Customer_Order__(order_no_);
         ELSE
           company_                  := Site_API.Get_Company(head_rec_.contract); 
           external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);

           IF (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX ) THEN 
              Customer_Order_API.Fetch_External_Tax(order_no_);
           END IF;
         END IF;

      END IF;
   END IF;
   
 info_ := Client_Sys.Get_All_Info();
EXCEPTION
   WHEN OTHERS THEN
      IF (current_co_no_ IS NOT NULL) THEN
         Order_Coordinator_Group_API.Reset_Cust_Order_No_Autonomous(auth_group_, current_co_no_);
      END IF;
      RAISE;
END Create_Order;


-- Create_Order_Line
--   Create a customer order line from a quotation order line quotation.
PROCEDURE Create_Order_Line (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   param_attr_   IN VARCHAR2 )
IS
   rec_  ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   temp_ VARCHAR2(32000);
BEGIN
   temp_ := param_attr_;
   rec_ := Lock_By_Keys___( quotation_no_, line_no_, rel_no_, line_item_no_ );
   Finite_State_Machine___( rec_, 'QuotationLineWithCo', temp_ );   
END Create_Order_Line;


-- Line_Changed
--   Send LineChanged event to OrderQuotationLine.
PROCEDURE Line_Changed (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   rec_  ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   attr_ VARCHAR2(32000);
BEGIN

   rec_ := Lock_By_Keys___( quotation_no_, line_no_, rel_no_, line_item_no_ );
   IF rec_.rowstate IN ('Cancelled', 'Lost', 'CO Created') THEN
      Error_SYS.Record_General(lu_name_, 'LINECHANGEDERROR: Error when sending LineChanged to Line :P1 Del No :P2.',rec_.line_no, rec_.rel_no);
   ELSE
      Finite_State_Machine___( rec_, 'LineChanged', attr_ );
   END IF;
END Line_Changed;


-- Update_Grad_Price_Line
--   Update buy qty due and sale_unit_price for line with grad price when
--   order quotation won to exclude finite state machine
PROCEDURE Update_Grad_Price_Line (
   quotation_no_        IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   buy_qty_due_         IN NUMBER,
   sale_unit_price_     IN NUMBER,
   unit_price_incl_tax_ IN NUMBER )
IS
   rowid_        ORDER_QUOTATION_LINE.objid%type;
   objversion_   ORDER_QUOTATION_LINE.objversion%type;
   oldrec_       ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   newrec_       ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   statemachine_ BOOLEAN;
   head_rec_     Order_Quotation_API.Public_Rec;
BEGIN

   oldrec_ := Lock_By_Keys___(quotation_no_, line_no_, rel_no_, line_item_no_);
   newrec_ := oldrec_;
   newrec_.buy_qty_due := buy_qty_due_;
   head_rec_ := Order_Quotation_API.Get(quotation_no_);
   IF (head_rec_.use_price_incl_tax = 'TRUE') THEN
      newrec_.part_price := unit_price_incl_tax_;
      newrec_.unit_price_incl_tax := unit_price_incl_tax_;
      Customer_Order_Pricing_API.Get_Base_Price_In_Currency( newrec_.base_unit_price_incl_tax, newrec_.currency_rate,
                                                             NVL(head_rec_.customer_no_pay, newrec_.customer_no),
                                                             newrec_.contract, head_rec_.currency_code,
                                                             unit_price_incl_tax_ );
   ELSE
      newrec_.part_price := sale_unit_price_;
      newrec_.sale_unit_price := sale_unit_price_;
      Customer_Order_Pricing_API.Get_Base_Price_In_Currency( newrec_.base_sale_unit_price, newrec_.currency_rate,
                                                             NVL(head_rec_.customer_no_pay, newrec_.customer_no),
                                                             newrec_.contract, head_rec_.currency_code,
                                                             sale_unit_price_ );
   END IF;
   Calculate_Prices___(newrec_);
   newrec_.revised_qty_due := buy_qty_due_ * newrec_.conv_factor / newrec_.inverted_conv_factor;
   newrec_.desired_qty := buy_qty_due_;
   newrec_.price_source := 'PRICE BREAKS';
   newrec_.price_freeze := 'FROZEN';
   -- Added cust_part_invert_conv_fact to modify the calculation of customer_part_buy_qty
   newrec_.customer_part_buy_qty := (newrec_.buy_qty_due / NVL(newrec_.customer_part_conv_factor, 1) * NVL(newrec_.cust_part_invert_conv_fact, 1));

   statemachine_ := FALSE;
   IF (newrec_.sale_unit_price != oldrec_.sale_unit_price OR newrec_.unit_price_incl_tax != oldrec_.unit_price_incl_tax OR 
       newrec_.buy_qty_due != oldrec_.buy_qty_due OR newrec_.price_freeze != oldrec_.price_freeze) THEN
      Get_Id_Version_By_Keys___( rowid_, objversion_, newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      Update_Line___(rowid_, oldrec_, newrec_, statemachine_, FALSE);
      IF (newrec_.order_supply_type = 'PKG') THEN
         Change_Package_Structure___(newrec_.promised_delivery_date, newrec_.planned_delivery_date,
                                     newrec_.planned_due_date, newrec_, TRUE, TRUE, FALSE, FALSE, FALSE, statemachine_, FALSE);
      END IF;
   END IF;
END Update_Grad_Price_Line;


-- Remove_From_Planning
--   Public method for removing forecast consumptions consumed when the
--   line was included in planning. Also resets the flag ReleasePlanning.
--   This method is to be called from MS or MRP.
PROCEDURE Remove_From_Planning (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   message_      IN VARCHAR2 )
IS
   oldrec_     ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   newrec_     ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___ ( quotation_no_, line_no_, rel_no_, line_item_no_);

   IF oldrec_.Release_Planning = 'RELEASED' THEN
      Client_SYS.Clear_Attr( attr_ );

      newrec_ := oldrec_;
      -- normal logic will force the unconsumption to occur.
      newrec_.release_planning := 'NOTRELEASED';

      Update___( objid_, oldrec_, newrec_, attr_, objversion_, TRUE );
      -- add the translated message  to the line history.
      Order_Quote_Line_Hist_API.New( quotation_no_, line_no_, rel_no_, line_item_no_, message_);
   END IF;
END Remove_From_Planning;


-- Update_Planning_Date
--   Public method for updating the date of forecast consumptions consumed
--   when the line was included in planning.
--   This method is to be called from MS or MRP for roll out.
PROCEDURE Update_Planning_Date (
   quotation_no_        IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   planning_date_       IN DATE,
   message_             IN VARCHAR2,
   latest_release_date_ IN DATE DEFAULT NULL,
   allocate_db_         IN VARCHAR2 DEFAULT NULL )
IS
   text_message_  VARCHAR2(80);
BEGIN
   Update_Planning_Date__(quotation_no_, line_no_, rel_no_, line_item_no_, planning_date_, latest_release_date_, allocate_db_ );
   text_message_ := SUBSTR(message_, 1, 80);
   Order_Quote_Line_Hist_API.New(quotation_no_, line_no_, rel_no_, line_item_no_, text_message_);
END Update_Planning_Date;


-- Set_Ctp_Planned
--   Sets CTP_Planned flag.
PROCEDURE Set_Ctp_Planned (
   quotation_no_     IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER )
IS
   attr_   VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CTP_PLANNED_DB', 'Y', attr_);
   Modify_Line___(attr_, quotation_no_, line_no_, rel_no_, line_item_no_);
END Set_Ctp_Planned;


-- Clear_Ctp_Planned
--   Clears CTP_Planned flag.
PROCEDURE Clear_Ctp_Planned (
   quotation_no_     IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER )
IS
   attr_   VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CTP_PLANNED_DB', 'N', attr_);
   Client_SYS.Add_To_Attr('LATEST_RELEASE_DATE', TO_DATE(NULL), attr_);
   -- adding new delivery date so we get some default dates back
   Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE', Get_Wanted_Delivery_Date(quotation_no_, line_no_, rel_no_, line_item_no_), attr_);
   Modify_Line___(attr_, quotation_no_, line_no_, rel_no_, line_item_no_);
END Clear_Ctp_Planned;


-- Get_Quote_Line_Price
--   Checks if price breaks exist for the current line. Fetches price
--   from price breaks or ordinary price logic.
PROCEDURE Get_Quote_Line_Price (
   attr_                   OUT VARCHAR2,
   quotation_no_           IN  VARCHAR2,
   line_no_                IN  VARCHAR2,
   rel_no_                 IN  VARCHAR2,
   line_item_no_           IN  NUMBER,
   catalog_no_             IN  VARCHAR2,
   buy_qty_due_            IN  NUMBER,
   price_list_no_          IN  VARCHAR2,
   price_effective_date_   IN  DATE,
   condition_code_         IN  VARCHAR2 DEFAULT NULL,
   customer_level_db_      IN  VARCHAR2,
   customer_level_id_      IN  VARCHAR2,
   rental_chargeable_days_ IN  NUMBER   DEFAULT NULL)
IS
   sale_unit_price_          NUMBER;
   unit_price_incl_tax_      NUMBER;
   base_sale_unit_price_     NUMBER;
   base_unit_price_incl_tax_ NUMBER;
   currency_rate_            NUMBER;
   discount_                 NUMBER;
   price_source_             VARCHAR2(200);
   price_source_db_          VARCHAR2(25);
   price_source_id_          VARCHAR2(25);
   contract_                 VARCHAR2(5);
   currency_code_            VARCHAR2(3);
   customer_no_pay_          ORDER_QUOTATION_TAB.customer_no_pay%TYPE;
   customer_no_              ORDER_QUOTATION_TAB.customer_no%TYPE;
   net_price_fetched_        VARCHAR2(20);
   temp_part_level_db_       VARCHAR2(30) := NULL;
   temp_part_level_id_       VARCHAR2(200) := NULL;
   temp_customer_level_db_   VARCHAR2(30) := customer_level_db_;
   temp_customer_level_id_   VARCHAR2(200) := customer_level_id_;
   
   CURSOR get_quotation_info IS
      SELECT contract, currency_code, customer_no_pay, customer_no
      FROM ORDER_QUOTATION_TAB
      WHERE quotation_no = quotation_no_;
BEGIN
   -- IF price breaks exist, fetch price from price breaks. Otherwise, use standard price functionality.
   IF (Order_Quotation_Grad_Price_API.Grad_Price_Exist(quotation_no_, line_no_, rel_no_, line_item_no_) = Fnd_Boolean_API.DB_TRUE) THEN
      Order_Quotation_Grad_Price_API.Calculate_Price(sale_unit_price_,
                                                     unit_price_incl_tax_,
                                                     quotation_no_,
                                                     line_no_,
                                                     rel_no_,
                                                     line_item_no_,
                                                     buy_qty_due_,
                                                     rental_chargeable_days_);
      IF (sale_unit_price_ IS NOT NULL) AND (unit_price_incl_tax_ IS NOT NULL) THEN
         OPEN get_quotation_info;
         FETCH get_quotation_info INTO contract_, currency_code_, customer_no_pay_, customer_no_;
         CLOSE get_quotation_info;
      
         Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_sale_unit_price_, currency_rate_,
                                                               NVL(customer_no_pay_, customer_no_),
                                                               contract_, currency_code_, sale_unit_price_);
         Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_unit_price_incl_tax_, currency_rate_,
                                                               NVL(customer_no_pay_, customer_no_),
                                                               contract_, currency_code_, unit_price_incl_tax_);
         
         price_source_db_   := Pricing_Source_API.DB_PRICE_BREAKS;
         price_source_      := Pricing_Source_API.Decode(price_source_db_);
         price_source_id_   := NULL;
         discount_          := 0;
         net_price_fetched_ := 'FALSE';
      ELSE
         Raise_Price_Break_Error___;
      END IF;

   ELSE
      Customer_Order_Pricing_API.Get_Quote_Line_Price_Info(sale_unit_price_, unit_price_incl_tax_, base_sale_unit_price_, base_unit_price_incl_tax_,
                                                           currency_rate_, discount_, price_source_,
                                                           price_source_id_, net_price_fetched_, 
                                                           temp_part_level_db_, temp_part_level_id_,
                                                           temp_customer_level_db_, temp_customer_level_id_,
                                                           quotation_no_, catalog_no_,
                                                           buy_qty_due_, price_list_no_, price_effective_date_, condition_code_,
                                                           ORDER_QUOTATION_API.Get_Use_Price_Incl_Tax_Db(quotation_no_),
                                                           rental_chargeable_days_);
      Calculate_Prices(sale_unit_price_, unit_price_incl_tax_, base_sale_unit_price_, base_unit_price_incl_tax_,
                       quotation_no_, line_no_, rel_no_, line_item_no_);
      price_source_db_ := Pricing_Source_API.Encode(price_source_);
   END IF;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('SALE_UNIT_PRICE', sale_unit_price_, attr_);
   Client_SYS.Add_To_Attr('UNIT_PRICE_INCL_TAX', unit_price_incl_tax_, attr_);
   Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE', base_sale_unit_price_, attr_);
   Client_SYS.Add_To_Attr('BASE_UNIT_PRICE_INCL_TAX', base_unit_price_incl_tax_, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_RATE', currency_rate_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
   Client_SYS.Add_To_Attr('PRICE_SOURCE', price_source_, attr_);
   Client_SYS.Add_To_Attr('PRICE_SOURCE_DB', price_source_db_, attr_);
   Client_SYS.Add_To_Attr('PRICE_SOURCE_ID', price_source_id_, attr_);
   Client_SYS.Add_To_Attr('PRICE_SOURCE_NET_PRICE_DB', net_price_fetched_, attr_);
   Client_SYS.Add_To_Attr('PART_LEVEL_DB', temp_part_level_db_, attr_);
   Client_SYS.Add_To_Attr('PART_LEVEL_ID', temp_part_level_id_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_DB', temp_customer_level_db_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_ID', temp_customer_level_id_, attr_);
END Get_Quote_Line_Price;


-- Check_Quote_Line_For_Planning
--   Checks if quotation lines exists.
FUNCTION Check_Quote_Line_For_Planning (
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2 ) RETURN BOOLEAN
IS
   temp_ ORDER_QUOTATION_LINE_TAB.line_item_no%TYPE;
   CURSOR get_line_no IS
      SELECT line_item_no
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE part_no  = part_no_
      AND   contract = contract_
      AND   rowstate IN ('Released','Revised','Rejected');
BEGIN
    OPEN get_line_no;
    FETCH get_line_no INTO temp_;
    IF (get_line_no%FOUND) THEN
       CLOSE get_line_no;
       RETURN TRUE;
    END IF;
    CLOSE get_line_no;
    RETURN FALSE;
END Check_Quote_Line_For_Planning;

-- Get_Min_Promised_Delivery_Date
--   Returns the min of the Promised Delivery Date of the given
FUNCTION Get_Min_Promised_Delivery_Date (
   quotation_no_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ ORDER_QUOTATION_LINE_TAB.promised_delivery_date%TYPE;
   CURSOR get_promised_delivery_date IS
      SELECT MIN(promised_delivery_date)
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE quotation_no = quotation_no_
      AND   rowstate IN ('Released', 'Won');
BEGIN
   OPEN get_promised_delivery_date;
   FETCH get_promised_delivery_date INTO temp_;
   CLOSE get_promised_delivery_date;
   RETURN temp_;
END Get_Min_Promised_Delivery_Date;


-- Check_Line_Total_Discount_Pct
--   Checks the sum of order discount and additional discount of an quotation
--   line.If it exceeds 100% it raises an error message.
PROCEDURE Check_Line_Total_Discount_Pct (
   quotation_no_        IN VARCHAR2,
   additional_discount_ IN NUMBER )
IS
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no, quotation_discount
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_item_no <= 0
      AND    rowstate NOT IN ('Cancelled','Won','Lost','CO Created');

    total_order_discount_  NUMBER:= 0;

BEGIN
    FOR next_line_ IN get_lines LOOP
      total_order_discount_ := next_line_.quotation_discount + additional_discount_;
      IF total_order_discount_ > 100 THEN
         Error_SYS.Record_General(lu_name_, 'LINEDISCOUNTEXCEED: Total Order Discount should not exceed 100% in line (Line No :P1, Del No :P2)', next_line_.line_no,next_line_.rel_no );
      END IF;
      total_order_discount_ := 0;
    END LOOP;
END Check_Line_Total_Discount_Pct;


-- Get_Total_Tax_Amount
--   Returns the total tax amount for a quotation line.
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   line_rec_                  ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   tax_amount_                NUMBER := 0;
   rounding_                  NUMBER;
   company_                   VARCHAR2(20);
   free_of_chg_tax_pay_party_ VARCHAR2(20);
BEGIN
   line_rec_ := Get_Object_By_Keys___(quotation_no_, line_no_, rel_no_, line_item_no_);
   company_  := Site_API.Get_Company(line_rec_.contract);
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_,Company_Finance_API.Get_Currency_Code(company_));
   free_of_chg_tax_pay_party_ := Order_Quotation_API.Get_Free_Of_Chg_Tax_Pay_Par_Db(quotation_no_);      
   
   IF (line_rec_.tax_liability_type = 'EXM') OR (line_rec_.free_of_charge = Fnd_Boolean_API.DB_TRUE AND free_of_chg_tax_pay_party_ = Tax_Paying_Party_API.DB_COMPANY)  THEN
      -- No tax will be paid for this quotation line
      tax_amount_ := 0;
   ELSE
      -- Please Note : Since sale_unit_price (price each) can have as many decimals as you like discounts and total_gross_base_amount_ needed to get rounded using Order Currency settings though the calculation is for base amounts. 
      -- The final line total base amount (gross_base_amount_) is rounded using accounting currency settings. This is to tally with invoice figures.
      tax_amount_ := ROUND(Get_Total_Tax_Amount_Curr(quotation_no_, line_no_, rel_no_, line_item_no_) * line_rec_.currency_rate, rounding_);
   END IF;
   RETURN NVL(tax_amount_,0);
END Get_Total_Tax_Amount;


-- Get_Total_Tax_Amount_Curr
--   Returns the total tax amount for a quotation line in quotation currency.
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount_Curr (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   line_rec_                  ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   tax_amount_                NUMBER := 0;
   rounding_                  NUMBER;
   company_                   VARCHAR2(20);
   tax_liability_type_db_     VARCHAR2(20);
   free_of_chg_tax_pay_party_ VARCHAR2(20);
   head_rec_                  Order_Quotation_API.Public_Rec;
BEGIN
   line_rec_ := Get_Object_By_Keys___(quotation_no_, line_no_, rel_no_, line_item_no_);
   head_rec_ := Order_Quotation_API.Get(quotation_no_);
   company_  := Site_API.Get_Company(line_rec_.contract);
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, head_rec_.currency_code);
   tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(line_rec_.tax_liability,
                                                                         NVL(line_rec_.ship_addr_country_code, head_rec_.country_code));
   free_of_chg_tax_pay_party_ := head_rec_.free_of_chg_tax_pay_party;      

   IF (tax_liability_type_db_ = 'EXM') OR (line_rec_.free_of_charge = Fnd_Boolean_API.DB_TRUE AND free_of_chg_tax_pay_party_ = Tax_Paying_Party_API.DB_COMPANY) THEN
      -- No tax paid for this order line
      tax_amount_ := 0;
   ELSE
      tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Curr_Amount(company_, 
                                                                   Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                                   quotation_no_,
                                                                   line_no_,
                                                                   rel_no_,
                                                                   TO_CHAR(line_item_no_),
                                                                   '*');
   END IF;

   tax_amount_ := ROUND(tax_amount_, rounding_);
   RETURN NVL(tax_amount_, 0);
END Get_Total_Tax_Amount_Curr;


-- Get_Total_Tax_Amount_Base
--   Returns the total tax amount for a quotation line in base currency.
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount_Base (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   company_                   Site_Tab.Company%TYPE;
   contract_                  Site_Tab.Contract%TYPE;
   tax_liability_type_        ORDER_QUOTATION_LINE_TAB.tax_liability_type%TYPE;
   tax_amount_                NUMBER := 0;
   rounding_                  NUMBER;
   free_of_chg_tax_pay_party_ VARCHAR2(20);
   free_of_charge_            VARCHAR2(5);
   
   CURSOR get_line_detail IS
      SELECT contract, tax_liability_type, free_of_charge
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE quotation_no = quotation_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_;

BEGIN
   OPEN get_line_detail;
   FETCH get_line_detail INTO contract_, tax_liability_type_, free_of_charge_;
   CLOSE get_line_detail;
   free_of_chg_tax_pay_party_ := Order_Quotation_API.Get_Free_Of_Chg_Tax_Pay_Par_Db(quotation_no_);

   IF (tax_liability_type_ = 'EXM') OR (free_of_charge_ = 'TRUE' AND free_of_chg_tax_pay_party_ = Tax_Paying_Party_API.DB_COMPANY) THEN
      tax_amount_ := 0;
   ELSE
      company_         := Site_API.Get_Company(contract_);
      rounding_        := Currency_Code_API.Get_Currency_Rounding(company_, Order_Quotation_API.Get_Currency_Code(quotation_no_));      

      tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Dom_Amount(company_, 
                                                                  Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                                  quotation_no_,
                                                                  line_no_,
                                                                  rel_no_,
                                                                  TO_CHAR(line_item_no_),
                                                                  '*');
      tax_amount_ := ROUND(tax_amount_, rounding_);                                                                
   END IF; 
   RETURN tax_amount_;
END Get_Total_Tax_Amount_Base;


-- Get_Base_Sale_Price_Total
--   This method returns the sales price total for a quotation line in base currency.
--   Gets the Sale_Price_Total in base Currency for freight price list
@UncheckedAccess
FUNCTION Get_Base_Sale_Price_Total (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   contract_      VARCHAR2(5);
   company_       VARCHAR2(20);
   currency_code_ VARCHAR2(3);
   rounding_      NUMBER;
   currency_rate_ NUMBER;
   CURSOR get_curr_rate IS
      SELECT currency_rate
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN

   OPEN  get_curr_rate;
   FETCH get_curr_rate INTO currency_rate_;
   CLOSE get_curr_rate;
   contract_ := Order_Quotation_API.Get_Contract(quotation_no_);
   company_  := Site_API.Get_Company(contract_);
   currency_code_ := Company_Finance_API.Get_Currency_Code(company_);
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   
   -- Please Note : Since sale_unit_price (price each) can have as many decimals as you like discounts and total_gross_base_amount_ needed to get rounded using Order Currency settings though the calculation is for base amounts. 
   -- The final line total base amount (net_base_amount_) is rounded using accounting currency settings. This is to tally with invoice figures.
   RETURN NVL(ROUND(Get_Sale_Price_Total(quotation_no_, line_no_, rel_no_, line_item_no_) * currency_rate_, rounding_), 0);
END Get_Base_Sale_Price_Total;


-- Get_Base_Sale_Price_Total
--   This method returns the sales price total for a quotation line in base currency.
--   Gets the Sale_Price_Total in base Currency for freight price list
FUNCTION Get_Base_Sale_Price_Total (
   quotation_no_          IN VARCHAR2,
   freight_map_id_        IN VARCHAR2,
   zone_id_               IN VARCHAR2,
   freight_price_list_no_ IN VARCHAR2,
   planned_ship_date_     IN DATE ) RETURN NUMBER
IS
   quote_rec_               Order_quotation_APi.Public_Rec;
   temp_                    NUMBER;
   company_                 VARCHAR2(20);
   rounding_                NUMBER;
   picking_lead_time_       NUMBER;
   planned_due_date_        DATE;
   line_discount_           NUMBER;
   price_total_             NUMBER :=0;
   price_curr_              NUMBER;
   base_rounding_           NUMBER;
   sale_amount_             NUMBER;
   rental_chargeable_days_  NUMBER;
   site_rec_                Site_API.Public_Rec;
   
   CURSOR get_line_data IS
      SELECT line_no, rel_no, line_item_no, buy_qty_due, price_conv_factor, currency_rate,
             (buy_qty_due * sale_unit_price * price_conv_factor) sale_amount,
             (buy_qty_due * unit_price_incl_tax * price_conv_factor) sale_amt_with_tax,
             quotation_discount, additional_discount
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    freight_map_id = freight_map_id_
      AND    zone_id = zone_id_
      AND    freight_price_list_no = freight_price_list_no_
      AND    planned_due_date = planned_due_date_
      AND    rowstate != 'Cancelled';
BEGIN
   quote_rec_         := Order_Quotation_API.Get(quotation_no_);
   site_rec_          := Site_API.Get(quote_rec_.contract);
   company_           := site_rec_.company;
   rounding_          := Currency_Code_API.Get_Currency_Rounding(company_, quote_rec_.currency_code);
   picking_lead_time_ := Site_Invent_Info_API.Get_Picking_Leadtime(quote_rec_.contract);
   planned_due_date_  := Cust_Ord_Date_Calculation_API.Get_Calendar_Start_Date(site_rec_.dist_calendar_id, planned_ship_date_, picking_lead_time_);
   base_rounding_     := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   
   FOR rec_ IN get_line_data LOOP
      -- For rental lines, rental_chargeable_days_ retreived from the rental object.
      -- Otherwise rental chargeable days will equal 1.
      rental_chargeable_days_ := Get_Rental_Chargeable_Days(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      
      IF quote_rec_.use_price_incl_tax  = Fnd_Boolean_API.DB_TRUE THEN
         sale_amount_ := rec_.sale_amt_with_tax * rental_chargeable_days_; 
      ELSE
         sale_amount_ := rec_.sale_amount * rental_chargeable_days_;
      END IF;
      line_discount_ := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, 
                                                                              rec_.buy_qty_due, rec_.price_conv_factor, rounding_);
      price_curr_    := ROUND((sale_amount_ - line_discount_) * (1-(rec_.quotation_discount + rec_.additional_discount)/100), rounding_);
      price_total_   := price_total_ + ROUND(price_curr_ * rec_.currency_rate, base_rounding_ ) ;
   END LOOP;
   IF price_total_ = 0 THEN
      temp_ := NULL;
   ELSE
      temp_ := price_total_; 
   END IF;
   RETURN temp_;
END Get_Base_Sale_Price_Total;


-- Get_Base_Price_Incl_Tax_Total
--   This method returns the sales price incl tax total for a quotation line in base currency.
@UncheckedAccess
FUNCTION Get_Base_Price_Incl_Tax_Total (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   contract_          VARCHAR2(5);
   company_           VARCHAR2(20);
   currency_code_     VARCHAR2(3);
   rounding_          NUMBER;
   currency_rate_     NUMBER;

   CURSOR get_curr_rate IS
      SELECT currency_rate
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN

   OPEN  get_curr_rate;
   FETCH get_curr_rate INTO currency_rate_;
   CLOSE get_curr_rate;
   contract_      := Order_Quotation_API.Get_Contract(quotation_no_);
   company_       := Site_API.Get_Company(contract_);
   currency_code_ := Company_Finance_API.Get_Currency_Code(company_);
   rounding_      := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   
   -- Please Note : Since unit_price_incl_tax (price each) can have as many decimals as you like discounts and total_gross_base_amount_ needed to get rounded using Order Currency settings though the calculation is for base amounts. 
   -- The final line total base amount (gross_base_amount_) is rounded using accounting currency settings. This is to tally with invoice figures.
   RETURN NVL(ROUND(Get_Sale_Price_Incl_Tax_Total(quotation_no_, line_no_, rel_no_, line_item_no_) * currency_rate_, rounding_), 0);
END Get_Base_Price_Incl_Tax_Total;


-- Get_Interim_Order_No
--   Returns any interim order no that is connected to this quotation line
@UncheckedAccess
FUNCTION Get_Interim_Order_No (
   quotation_no_     IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   ctp_planned_db_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   interim_ord_id_       VARCHAR2(12);
   order_usage_          VARCHAR2(20) := 'CUSTOMERQUOTE';
BEGIN
   IF NVL(ctp_planned_db_,'N') = 'N' THEN
      $IF (Component_Ordstr_SYS.INSTALLED) $THEN
         interim_ord_id_ := Interim_Demand_Head_API.Get_Int_Head_By_Usage(order_usage_, quotation_no_, line_no_, rel_no_, line_item_no_);
      $ELSE
         NULL;
      $END
   ELSIF ctp_planned_db_ = 'Y' THEN
      $IF (Component_Ordstr_SYS.INSTALLED) $THEN
          interim_ord_id_ := Interim_Ctp_Manager_API.Get_Top_Int_Head_By_Usage(order_usage_, quotation_no_, line_no_, rel_no_, line_item_no_);  
      $ELSE
         NULL;    
      $END    
   END IF;
   RETURN interim_ord_id_;
END Get_Interim_Order_No;


-- Set_Cancel_Reason
--   This method updates the cancel_reason column with the passed in value.
PROCEDURE Set_Cancel_Reason (
   quotation_no_  IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   cancel_reason_ IN VARCHAR2 )
IS
   attr_                VARCHAR2(2000);
   connect_charge_line_ NUMBER;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CANCEL_REASON', cancel_reason_, attr_);
   Modify_Line___(attr_, quotation_no_, line_no_, rel_no_, line_item_no_);

   connect_charge_line_ := Order_Quotation_Charge_API.Exist_Charge_On_Quot_Line(quotation_no_, line_no_, rel_no_, line_item_no_);
   IF (connect_charge_line_ = 1) THEN
      Customer_Order_Charge_Util_API.Remove_Connected_QChg_Lines(quotation_no_, line_no_, rel_no_, line_item_no_);
   END IF;

END Set_Cancel_Reason;


@UncheckedAccess
FUNCTION Get_Total_Discount (
   quotation_no_  IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER ) RETURN NUMBER
IS
   -- gelr:disc_price_rounded, added original_quotation_discount, original_add_discount
   CURSOR get_line_data IS
      SELECT buy_qty_due * sale_unit_price * price_conv_factor   price_curr,
             buy_qty_due * unit_price_incl_tax * price_conv_factor price_incl_tax_curr,
             buy_qty_due, price_conv_factor, currency_rate, quotation_discount, additional_discount, original_quotation_discount, original_add_discount   
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE quotation_no = quotation_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;

   rec_line_               get_line_data%ROWTYPE;
   line_discount_amount_   NUMBER;
   price_base_with_disc_   NUMBER;
   price_curr_with_disc_   NUMBER;
   price_curr_             NUMBER;
   price_base_             NUMBER;
   rental_chargeable_days_ NUMBER;
   use_price_incl_tax_     CUSTOMER_ORDER_TAB.use_price_incl_tax%TYPE;
   discount_               ORDER_QUOTATION_LINE_TAB.discount%TYPE;
BEGIN
   use_price_incl_tax_ :=  ORDER_QUOTATION_API.Get_Use_Price_Incl_Tax_Db(quotation_no_) ;
   OPEN get_line_data;
   FETCH get_line_data INTO rec_line_;
   CLOSE get_line_data;
   
   -- For rental lines, rental_chargeable_days_ retreived from the rental object.
   -- Otherwise rental chargeable days will equal 1.
   rental_chargeable_days_ := Get_Rental_Chargeable_Days(quotation_no_, line_no_, rel_no_, line_item_no_);
      
   IF (use_price_incl_tax_ = Fnd_Boolean_API.DB_TRUE) THEN
      price_curr_ := NVL(rec_line_.price_incl_tax_curr, 0) * rental_chargeable_days_;
   ELSE
      price_curr_ := NVL(rec_line_.price_curr, 0) * rental_chargeable_days_;      
   END IF;


   IF (price_curr_ <> 0) THEN
      -- Gets unrounded line discount amount to calculate discount percentage.
      -- Calculations are done using order currency, then final values are converted to base currency. 
      -- gelr:disc_price_rounded, begin
      -- use  original_quotation_discount, original_add_discount when using Discounted Price Rounded  
      IF (Order_Quotation_API.Get_Discounted_Price_Rounded(quotation_no_)) THEN
         line_discount_amount_ := Order_Quote_Line_Discount_API.Get_Original_Total_Line_Disc(quotation_no_, line_no_, rel_no_, line_item_no_, 
                                                                                            rec_line_.buy_qty_due, rec_line_.price_conv_factor);         
         price_curr_with_disc_ := (price_curr_ - line_discount_amount_) * (1 - (rec_line_.original_quotation_discount + rec_line_.original_add_discount) / 100);
      ELSE
      -- gelr:disc_price_rounded, end
         line_discount_amount_ := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(quotation_no_, line_no_, rel_no_, line_item_no_, 
                                                                          rec_line_.buy_qty_due, rec_line_.price_conv_factor);         
         price_curr_with_disc_ := (price_curr_ - line_discount_amount_) * (1 - (rec_line_.quotation_discount + rec_line_.additional_discount) / 100);
      -- gelr:disc_price_rounded, begin   
      END IF;
      -- gelr:disc_price_rounded, end
      price_base_           := price_curr_ * rec_line_.currency_rate;
      price_base_with_disc_ := price_curr_with_disc_ * rec_line_.currency_rate; 
      discount_             := ROUND(100 * (1 - (price_base_with_disc_ / price_base_)), 2);
   ELSE
      discount_ := 0;
   END IF;
   RETURN discount_;
END Get_Total_Discount;

PROCEDURE Cancel_Order_Line (
   cancel_info_   OUT VARCHAR2,
   quotation_no_  IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   objid_      ORDER_QUOTATION_LINE.objid%TYPE;
   objversion_ ORDER_QUOTATION_LINE.objversion%TYPE;
   info_       VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, line_no_, rel_no_,line_item_no_);   
   Cancel__(info_, objid_, objversion_,attr_,'DO');
   cancel_info_ := info_;
END Cancel_Order_Line;


-- Get_Calculated_Pkg_Cost
--   Calls the Update_Package_Cost___ implementation method to calculate the package cost for top part.
PROCEDURE Get_Calculated_Pkg_Cost (
   pkg_cost_         OUT NUMBER,
   pkg_quotation_no_ IN  VARCHAR2,
   pkg_line_no_      IN  VARCHAR2,
   pkg_rel_no_       IN  VARCHAR2) 
IS
BEGIN
   Update_Package_Cost___(pkg_cost_, pkg_quotation_no_, pkg_line_no_, pkg_rel_no_);
END Get_Calculated_Pkg_Cost;


-- Fetch_Delivery_Attributes
--   This method is used to retrieve delivery information based on the given delivery attributes.
--   If no Freight zone information is defined in supplier chain matrix, the delivery address is considered.
PROCEDURE Fetch_Delivery_Attributes (
   delivery_leadtime_         IN OUT NUMBER,
   ext_transport_calendar_id_ OUT VARCHAR2,
   freight_map_id_            OUT VARCHAR2,
   zone_id_                   OUT VARCHAR2,
   freight_price_list_no_     OUT VARCHAR2,
   picking_leadtime_          IN OUT NUMBER,
   delivery_terms_            IN OUT VARCHAR2,
   del_terms_location_        IN OUT VARCHAR2,
   forward_agent_id_          IN OUT VARCHAR2,
   quotation_no_              IN  VARCHAR2,
   line_no_                   IN  VARCHAR2,
   rel_no_                    IN  VARCHAR2,
   contract_                  IN  VARCHAR2,
   customer_no_               IN  VARCHAR2,
   ship_addr_no_              IN  VARCHAR2,
   ship_via_code_             IN  VARCHAR2,
   part_no_                   IN  VARCHAR2,
   supply_code_               IN  VARCHAR2,
   vendor_no_                 IN  VARCHAR2,
   single_occ_addr_flag_      IN  VARCHAR2,
   ship_addr_zip_code_        IN  VARCHAR2 DEFAULT NULL,
   ship_addr_city_            IN  VARCHAR2 DEFAULT NULL,
   ship_addr_county_          IN  VARCHAR2 DEFAULT NULL,
   ship_addr_state_           IN  VARCHAR2 DEFAULT NULL,
   ship_addr_country_code_    IN  VARCHAR2 DEFAULT NULL,
   ship_via_code_changed_     IN  VARCHAR2 DEFAULT 'FALSE')
IS
   addr_flag_                  VARCHAR2(1) := 'N';
   customer_category_          CUSTOMER_INFO_TAB.customer_category%TYPE;
   route_id_                   VARCHAR2(12);
   shipment_type_              VARCHAR2(3);
   ship_inventory_location_no_ VARCHAR2(35);
   use_price_incl_tax_db_      Order_Quotation_TAB.use_price_incl_tax%TYPE;
   zone_info_exist_   		   VARCHAR2(5) := 'FALSE';
   line_item_no_               NUMBER := 0;
   line_rec_                   ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   so_addr_flag_               VARCHAR2(5) :=  single_occ_addr_flag_;
   so_zip_code_                VARCHAR2(35) :=  ship_addr_zip_code_;
   so_city_                    VARCHAR2(35) :=  ship_addr_city_;
   so_county_                  VARCHAR2(35) :=  ship_addr_county_;
   so_state_                   VARCHAR2(35) :=  ship_addr_state_;
   so_country_code_            VARCHAR2(2) :=  ship_addr_country_code_;
BEGIN
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(customer_no_);
   
   IF (ship_addr_country_code_ IS NULL AND 
       ship_addr_zip_code_ IS NULL AND 
       ship_addr_city_ IS NULL AND 
       ship_addr_zip_code_ IS NULL AND 
       ship_addr_state_ IS NULL) THEN 
      line_rec_        := Get_Object_By_Keys___(quotation_no_, line_no_, rel_no_, line_item_no_);
      so_zip_code_     :=  line_rec_.ship_addr_zip_code;
      so_city_         :=  line_rec_.ship_addr_city;
      so_county_       :=  line_rec_.ship_addr_county;
      so_state_        :=  line_rec_.ship_addr_state;
      so_country_code_ :=  line_rec_.ship_addr_country_code;
   END IF; 
   
   IF single_occ_addr_flag_ = 'TRUE' OR (customer_category_ = Customer_Category_API.DB_PROSPECT) THEN 
      addr_flag_ := 'Y';
   END IF;
   Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes(route_id_,
                                                          forward_agent_id_,
                                                          delivery_leadtime_,
                                                          ext_transport_calendar_id_,
                                                          freight_map_id_,
                                                          zone_id_,
                                                          picking_leadtime_,
                                                          shipment_type_,
                                                          ship_inventory_location_no_,
                                                          delivery_terms_,
                                                          del_terms_location_,
                                                          contract_,
                                                          customer_no_,
                                                          ship_addr_no_,
                                                          addr_flag_,
                                                          ship_via_code_,
                                                          part_no_,
                                                          supply_code_,
                                                          vendor_no_,
                                                          NULL,
                                                          ship_via_code_changed_);

      
   IF (single_occ_addr_flag_ = 'TRUE') THEN
     Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details(freight_map_id_,
                                                       zone_id_,
                                                       zone_info_exist_,
                                                       contract_,
                                                       ship_via_code_,
                                                       so_zip_code_,
                                                       so_city_,
                                                       so_county_,
                                                       so_state_,
                                                       so_country_code_);
   ELSIF (freight_map_id_ IS NULL) AND (zone_id_ IS NULL) THEN
     Freight_Zone_Util_API.Fetch_Zone_For_Cust_Addr(freight_map_id_,
                                                    zone_id_,
                                                    customer_no_,
                                                    ship_addr_no_,
                                                    contract_,
                                                    ship_via_code_);
  
   END IF;
   IF (freight_map_id_ IS NOT NULL AND zone_id_ IS NOT NULL) THEN
         use_price_incl_tax_db_ := ORDER_QUOTATION_API.Get_Use_Price_Incl_Tax_Db(quotation_no_);
      IF (supply_code_ IN ('PD', 'IPD') AND (vendor_no_ IS NOT NULL)) THEN
         freight_price_list_no_ := Freight_Price_List_Direct_API.Get_Active_Freight_List_No(contract_,
                                                                                            ship_via_code_,
                                                                                            freight_map_id_,
                                                                                            forward_agent_id_,
                                                                                            use_price_incl_tax_db_,
                                                                                            vendor_no_);
      ELSE
         freight_price_list_no_ := Freight_Price_List_API.Get_Active_Freight_List_No(contract_,
                                                                                     ship_via_code_,
                                                                                     freight_map_id_,
                                                                                     forward_agent_id_,
                                                                                     use_price_incl_tax_db_);
      END IF;
   END IF;
END Fetch_Delivery_Attributes;


PROCEDURE Update_Freight_Free (
   quotation_no_  IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER )
IS
   charge_amount_   NUMBER;
   freight_free_    VARCHAR2(5);
   objid_           ORDER_QUOTATION_LINE.objid%type;
   objversion_      ORDER_QUOTATION_LINE.objversion%type;
   oldrec_          ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   newrec_          ORDER_QUOTATION_LINE_TAB%ROWTYPE;
BEGIN
   
   charge_amount_ := Order_Quotation_Charge_API.Get_Freight_Charge_Amount(quotation_no_, line_no_, rel_no_, line_item_no_);

   IF (charge_amount_ = 0) THEN
      freight_free_ := 'TRUE';
   ELSE
      freight_free_ := 'FALSE';
   END IF;
   
   IF (Get_Freight_Free_Db(quotation_no_, line_no_, rel_no_, line_item_no_) != freight_free_) THEN
      newrec_ := Get_Object_By_Keys___(quotation_no_, line_no_, rel_no_, line_item_no_);
      oldrec_ := newrec_;
      Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, line_no_, rel_no_, line_item_no_);
      newrec_.rowversion := sysdate;
      newrec_.freight_free := freight_free_;
      Update_Line___(objid_, oldrec_, newrec_, TRUE, FALSE);
   END IF;
END Update_Freight_Free;


-- Recalc_Line_Tot_Net_Weight
--   Recalculates line total net weight.
PROCEDURE Recalc_Line_Tot_Net_Weight (
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2 )
IS
   line_total_weight_ NUMBER := NULL;
   objid_             VARCHAR2(2000);
   rowversion_        VARCHAR2(2000);
   line_rec_          ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   oldrec_            ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   sales_part_rec_    Sales_Part_API.Public_Rec;

   CURSOR get_co_lines IS
      SELECT quotation_no, line_no, rel_no, line_item_no, contract, catalog_no, buy_qty_due 
        FROM ORDER_QUOTATION_LINE_TAB
       WHERE configuration_id = configuration_id_
         AND part_no = part_no_
         AND rowstate NOT IN ('Won', 'Lost', 'Cancelled', 'CO Created');
BEGIN

   FOR rec_ IN get_co_lines LOOP
      sales_part_rec_    := Sales_Part_API.Get(rec_.contract, rec_.catalog_no);
      line_rec_ := Lock_By_Keys___(rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      oldrec_ := line_rec_;
      line_total_weight_ := Part_Weight_Volume_Util_API.Get_Config_Weight_Net(line_rec_.contract, line_rec_.catalog_no, configuration_id_, sales_part_rec_.part_no, sales_part_rec_.sales_unit_meas,  sales_part_rec_.conv_factor, sales_part_rec_.inverted_conv_factor, Company_Invent_Info_API.Get_Uom_For_Weight(Site_API.Get_Company(line_rec_.contract))) * line_rec_.buy_qty_due;
      line_rec_.line_total_weight := line_total_weight_;
      Get_Id_Version_By_Keys___(objid_, rowversion_, rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      line_rec_.rowversion := SYSDATE;
      -- This will not clear the info_. This is necessary because this method is used in CFGCHR.
      Update_Line___(objid_, oldrec_, line_rec_, TRUE, FALSE);
   END LOOP;

END Recalc_Line_Tot_Net_Weight;


FUNCTION Check_Lines_Config_Valid (
   quotation_no_          IN VARCHAR2) RETURN NUMBER
IS   
   CURSOR get_line IS
    SELECT quotation_no, line_no, rel_no, line_item_no, catalog_no, part_no, configuration_id, contract
    FROM ORDER_QUOTATION_LINE_TAB
    WHERE quotation_no = quotation_no_;
BEGIN

   FOR rec_ IN get_line LOOP
      IF Sales_Part_API.Get_Configurable_Db( rec_.contract, rec_.catalog_no ) = 'CONFIGURED' THEN
         IF rec_.configuration_id = '*' THEN
            RETURN -1;
         ELSIF (Order_Config_Util_API.Is_Base_Part_Config_Valid(NVL(rec_.part_no, rec_.catalog_no), rec_.configuration_id)= 0) THEN
            RETURN 0;
         END IF;
      END IF;
   END LOOP;
   RETURN 1;
END Check_Lines_Config_Valid;


@UncheckedAccess
FUNCTION Get_Possible_Sales_Promo_Deal (
   quotation_no_               IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   rel_no_                     IN VARCHAR2,
   line_item_no_               IN NUMBER,
   rowstate_                   IN VARCHAR2,
   price_source_net_price_db_  IN VARCHAR2,
   charged_item_db_            IN VARCHAR2,
   self_billing_db_            IN VARCHAR2,
   rental_db_                  IN VARCHAR2 ) RETURN VARCHAR2   
IS
   deal_description_    VARCHAR2(200);
BEGIN
   -- any changes in these conditions could also affect where statements in cursor get_possible_quote_lines in methods Sales_Promotion_Util_API.Calculate_Quote_Deal_Buy___/Calculate_Quote_Deal_Get___
   IF (rowstate_ NOT IN ('Cancelled', 'Lost') AND
       price_source_net_price_db_ = 'FALSE' AND
       charged_item_db_ = 'CHARGED ITEM' AND
       self_billing_db_ = 'NOT SELF BILLING' AND
       line_item_no_ <= 0 AND
       rental_db_ = Fnd_Boolean_API.DB_FALSE) THEN
      deal_description_ := Sales_Promotion_Util_API.Get_Possible_Sales_Promo_Deal(quotation_no_, line_no_, rel_no_, line_item_no_, 'QUOTATION');
   END IF;

   RETURN deal_description_;
END Get_Possible_Sales_Promo_Deal;


-- Get_Next_Rel_No
--   Get next rel_no
FUNCTION Get_Next_Rel_No (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   line_item_no_ IN NUMBER,
   contract_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_rel_no IS
      SELECT to_char(max(to_number(rel_no)))
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    contract || '' = contract_
      AND    line_item_no <= 0;
   
   CURSOR count_rel_no IS
      SELECT count(DISTINCT(to_number(rel_no)))
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    contract || '' = contract_;

   rel_no_       ORDER_QUOTATION_LINE_TAB.rel_no%TYPE;
   rel_no_count_ NUMBER;
BEGIN
   IF (line_no_ IS NOT NULL) THEN
      OPEN get_rel_no;
      FETCH get_rel_no INTO rel_no_;
      CLOSE get_rel_no;
      IF (rel_no_ IS NOT NULL) THEN
         IF (to_number(rel_no_) + 1 > 9999) THEN
            OPEN count_rel_no;
            FETCH count_rel_no INTO rel_no_count_;
            CLOSE count_rel_no;          
            
            IF (rel_no_count_ < 9999) THEN               
               Error_Sys.Record_General(lu_name_,'RELNOMAX: The maximum limit of the delivery number has been reached. Enter a value less than 9999 in the Del No field manually.');
            ELSE
               Error_Sys.Record_General(lu_name_,'NOMORERELNO: The maximum limit of the delivery number has been reached.');
            END IF;
        END IF;
         rel_no_ := to_char(to_number(rel_no_) + 1);
      ELSE
         rel_no_  := '1';
      END IF;      
   END IF;
   RETURN rel_no_;
END Get_Next_Rel_No;


-- Is_Change_Config_Allowed
--   Returns TRUE if the sales quotation line can have its connected
--   configuration modified.
@UncheckedAccess
FUNCTION Is_Change_Config_Allowed (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN BOOLEAN
IS
   change_allowed_   BOOLEAN := FALSE;
   part_no_          ORDER_QUOTATION_LINE_TAB.part_no%TYPE;
   catalog_no_       ORDER_QUOTATION_LINE_TAB.catalog_no%TYPE;
   rowstate_         ORDER_QUOTATION_LINE_TAB.rowstate%TYPE;
   
   CURSOR get_rec IS
      SELECT part_no, catalog_no, rowstate
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   OPEN  get_rec;
   FETCH get_rec INTO part_no_, catalog_no_, rowstate_;
   IF (get_rec%FOUND) THEN
      change_allowed_ := ((rowstate_ IN ('Planned', 'Released', 'Revised','Rejected')) AND (Part_Catalog_API.Get_Configurable_Db(NVL(part_no_, catalog_no_)) = 'CONFIGURED'));
   END IF;
   CLOSE get_rec;

   RETURN change_allowed_;
END Is_Change_Config_Allowed;


-- Calculate_Prices
--   Calculates price columns of the quotation line.
--   if use_price_incl_tax_ is checked, price excluding tax will be calculated using price including tax
--   else price including tax will be calculated using price excluding tax.
PROCEDURE Calculate_Prices (
   sale_unit_price_            IN OUT NUMBER,
   unit_price_incl_tax_        IN OUT NUMBER,
   base_sale_unit_price_       IN OUT NUMBER,
   base_unit_price_incl_tax_   IN OUT NUMBER,
   quotation_no_               IN     VARCHAR2,
   line_no_                    IN     VARCHAR2,
   rel_no_                     IN     VARCHAR2,
   line_item_no_               IN     NUMBER,
   currency_rate_              IN     NUMBER DEFAULT NULL)
IS
   tax_line_param_rec_    Tax_Handling_Order_Util_API.tax_line_param_rec;
   multiple_tax_          VARCHAR2(20);
BEGIN
   tax_line_param_rec_ := Fetch_Tax_Line_Param(Get_Company(quotation_no_, line_no_, rel_no_, line_item_no_), 
                                               quotation_no_, line_no_, rel_no_, line_item_no_,currency_rate_);

   Tax_Handling_Order_Util_API.Get_Prices(base_sale_unit_price_,
                                          base_unit_price_incl_tax_,
                                          sale_unit_price_,
                                          unit_price_incl_tax_,
                                          multiple_tax_,
										            tax_line_param_rec_.tax_code,
                                          tax_line_param_rec_.tax_calc_structure_id,
                                          tax_line_param_rec_.tax_class_id,
                                          quotation_no_, 
                                          line_no_, 
                                          rel_no_,
                                          line_item_no_,
                                          '*',
                                          Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                          tax_line_param_rec_.contract,
                                          tax_line_param_rec_.customer_no,
                                          tax_line_param_rec_.ship_addr_no,
                                          tax_line_param_rec_.planned_ship_date,
                                          tax_line_param_rec_.supply_country_db,
                                          tax_line_param_rec_.delivery_type,
                                          tax_line_param_rec_.object_id,
                                          tax_line_param_rec_.use_price_incl_tax,
                                          tax_line_param_rec_.currency_code,
                                          tax_line_param_rec_.currency_rate,
                                          'FALSE',                                          
                                          tax_line_param_rec_.tax_liability,
                                          tax_line_param_rec_.tax_liability_type_db,
                                          delivery_country_db_ => NULL,
                                          ifs_curr_rounding_ => 16,
                                          tax_from_diff_source_ => 'FALSE',
                                          attr_ => NULL); 
END Calculate_Prices;


-- Get_Ship_Address_Count
--   Get no of ship address exist in quotation lines.
@UncheckedAccess
FUNCTION Get_Ship_Address_Count (
   customer_no_   IN  VARCHAR2,
   address_no_    IN  VARCHAR2) RETURN NUMBER
IS
   count_       NUMBER;
   CURSOR get_count IS
      SELECT count(*)
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE customer_no = customer_no_
      AND ship_addr_no = address_no_;      
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Ship_Address_Count;

----------------------------------------------------------------
--  Get_Quot_Line_Contribution
--    This method is used to get the contribution margin of the 
--  order quotation line.
----------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_Quot_Line_Contribution (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   line_cost_     NUMBER;
   company_       VARCHAR2(20);
   rounding_      NUMBER;
   contribution_  NUMBER;
   
   CURSOR get_cost IS   
      SELECT ROUND((cost * buy_qty_due * conv_factor / inverted_conv_factor), rounding_)
      FROM  ORDER_QUOTATION_LINE_TAB
      WHERE rowstate != 'Cancelled'
      AND   line_item_no <= 0
      AND   quotation_no = quotation_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   company_ := Site_API.Get_Company(Get_Contract(quotation_no_, line_no_, rel_no_, line_item_no_));
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   OPEN get_cost;
   FETCH get_cost INTO line_cost_;
   IF (get_cost%NOTFOUND) THEN
      line_cost_ := 0;
   END IF;
   CLOSE get_cost;
   contribution_ := Get_Base_Sale_Price_Total(quotation_no_, line_no_, rel_no_, line_item_no_) - line_cost_;      
   RETURN contribution_;
END Get_Quot_Line_Contribution;

PROCEDURE Modify_Line_Default_Addr_Flag(
   line_rec_              IN ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   quotation_no_          IN VARCHAR2,
   new_default_addr_flag_ IN VARCHAR2) 
IS
   temp_default_addr_flag_ VARCHAR2(1);
   oldrec_                ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   newrec_                ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   objid_                 VARCHAR2(2000);
   objversion_            VARCHAR2(2000);
   attr_                  VARCHAR2(32000);
   indrec_                Indicator_Rec;
BEGIN
   temp_default_addr_flag_ := Check_Default_Addr_Flag__(line_rec_, quotation_no_, new_default_addr_flag_);
   IF (temp_default_addr_flag_ != new_default_addr_flag_) THEN
      Client_SYS.Clear_Attr(attr_);
      Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
      oldrec_ := Lock_By_Keys___(quotation_no_, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
      newrec_ := oldrec_;
      Client_SYS.Add_To_Attr('DEFAULT_ADDR_FLAG_DB', temp_default_addr_flag_, attr_);
      Unpack___(newrec_, indrec_, attr_);      
      Check_Update___(oldrec_, newrec_, indrec_, attr_);      
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;      
END Modify_Line_Default_Addr_Flag;

PROCEDURE Forecast_Consumption___ (
   rec_                       IN ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   oldrec_                    IN ORDER_QUOTATION_LINE_TAB%ROWTYPE)
IS
   available_qty_             NUMBER := 0;
   early_delivery_date_       DATE;
   earliest_available_date_   DATE;
   early_ship_date_           DATE;
   dummy_                     DATE;
   result_code_               VARCHAR2(2000);
   dummy_1_                   VARCHAR2(2000);
   promise_method_db_         VARCHAR2(20);
   supplier_part_no_          VARCHAR2(25);
   new_qty_                   NUMBER := 0;
   old_qty_                   NUMBER := 0;
BEGIN

   supplier_part_no_ := NVL(rec_.part_no, Sales_Part_API.Get_Purchase_Part_No(rec_.contract, rec_.catalog_no));
   
   IF (rec_.release_planning = 'RELEASED' AND (oldrec_.release_planning = 'NOTRELEASED' OR oldrec_.release_planning IS NULL )) THEN
      new_qty_ := rec_.revised_qty_due; 
      old_qty_ := 0; 
   ELSIF (rec_.release_planning = 'NOTRELEASED' AND oldrec_.release_planning = 'RELEASED')THEN 
      new_qty_ := 0;
      old_qty_ := oldrec_.revised_qty_due;
   ELSIF (rec_.release_planning = oldrec_.release_planning)THEN
      new_qty_ := rec_.revised_qty_due;
      old_qty_ := oldrec_.revised_qty_due;
   END IF;
   
   -- Consume the planned quantity
   Reserve_Customer_Order_API.Control_Ms_Mrp_Consumption (result_code_, available_qty_,
                                                          earliest_available_date_,
                                                          rec_.contract, rec_.part_no, 0,
                                                          new_qty_, old_qty_,
                                                          rec_.planned_due_date, oldrec_.planned_due_date,
                                                          'CQ', FALSE, NULL, NULL);  
                                                          
   IF (result_code_ != 'SUCCESS') THEN
      Cust_Ord_Date_Calculation_API.Calc_Order_Dates_Forwards(early_delivery_date_, early_ship_date_ , earliest_available_date_, dummy_,
                                                              rec_.wanted_delivery_date, rec_.contract, rec_.order_supply_type, 
                                                              rec_.customer_no, rec_.vendor_no,
                                                              rec_.part_no, supplier_part_no_, rec_.ship_addr_no, 
                                                              rec_.ship_via_code,  
                                                              NULL, rec_.delivery_leadtime, rec_.picking_leadtime, rec_.ext_transport_calendar_id, NULL);
      
      -- Combined the phrases in order to resolve the translation issues  

      dummy_1_ := Language_SYS.Translate_Constant(lu_name_,
                  'ATPCHECKFAIL6B: For Site/Part :P1, the quantity available on :P2 is :P3 is the possible delivery date for the desired quantity. Either target date/planned delivery date or ordered quantity has to be changed.',                               
                  Language_SYS.Get_Language,
                  rec_.contract ||'/'||supplier_part_no_,
                  rec_.planned_due_date,
                  available_qty_ ||'.'||chr(13)||chr(10) ||early_delivery_date_);

      $IF (Component_Massch_SYS.INSTALLED) $THEN
      
         promise_method_db_ := Level_1_Part_API.Get_Promise_Method_Db(rec_.contract, rec_.part_no,'*');
         -- Message wording will decided on the promised method
         IF (promise_method_db_ = 'UCF') THEN
            dummy_1_ := Language_SYS.Translate_Constant(lu_name_,
                        'ATPCHECKFAIL61B: For Site/Part :P1, the remaining unconsumed forecast on :P2 is :P3 is the possible delivery date for the desired quantity. Either target date/planned delivery date or ordered quantity has to be changed.',
                        Language_SYS.Get_Language,
                        rec_.contract ||'/'||supplier_part_no_,
                        rec_.planned_due_date,
                        available_qty_ ||'.'||chr(13)||chr(10)||early_delivery_date_);
         ELSIF (promise_method_db_ = 'ATP') THEN
            dummy_1_ := Language_SYS.Translate_Constant(lu_name_,
                        'ATPCHECKFAIL62B: For Site/Part :P1, the remaining unconsumed supply on :P2 is :P3 is the possible delivery date for the desired quantity. Either target date/planned delivery date or ordered quantity has to be changed.',
                        Language_SYS.Get_Language,
                        rec_.contract ||'/'||supplier_part_no_,
                        rec_.planned_due_date,
                        available_qty_ ||'.'||chr(13)||chr(10)||early_delivery_date_);
         END IF;
         
      $END   

      Error_SYS.Appl_General(
         lu_name_,
         'ATPCHECKFAIL7: :P1',
         dummy_1_);  
         
   END IF;
   
END Forecast_Consumption___ ;

-- Get_Rental_Chargeable_Days
--   This method calculates and return rental chargeable days
--   for given rental references.
@UncheckedAccess
FUNCTION Get_Rental_Chargeable_Days (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER  ) RETURN NUMBER
IS
   rental_chargeable_days_ NUMBER;
BEGIN
   IF (Get_Rental_Db(quotation_no_, line_no_, rel_no_, line_item_no_) = Fnd_Boolean_API.DB_FALSE) THEN
      rental_chargeable_days_ := 1;
   ELSE
      rental_chargeable_days_ := Get_Rental_Chargeable_Days___(quotation_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   RETURN rental_chargeable_days_;
END Get_Rental_Chargeable_Days;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_Tax_Info (
   attr_          OUT VARCHAR2,
   quotation_no_  IN  VARCHAR2,
   line_no_       IN  VARCHAR2,
   rel_no_        IN  VARCHAR2,
   line_item_no_  IN  NUMBER)
IS
   linerec_                ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   tax_liability_type_db_  VARCHAR2(20);
   country_code_           ORDER_QUOTATION_LINE_TAB.Ship_Addr_Country_Code%TYPE;
   tax_paying_party_       VARCHAR2(20);
BEGIN
   linerec_      := Get_Object_By_Keys___(quotation_no_, line_no_, rel_no_, line_item_no_);
   IF(linerec_.ship_addr_country_code IS NOT NULL) THEN
      country_code_ := linerec_.ship_addr_country_code;
   ELSIF(linerec_.default_addr_flag = 'Y') THEN 
      country_code_ := Order_Quotation_API.Get_Country_Code(linerec_.quotation_no);
   ELSE
      country_code_ := Customer_Info_Address_API.Get_Country_Code(linerec_.customer_no, linerec_.ship_addr_no);
   END IF;
   Client_SYS.Set_Item_Value('TAX_CODE', linerec_.tax_code, attr_);
   Client_SYS.Set_Item_Value('TAX_CLASS_ID', linerec_.tax_class_id, attr_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY', linerec_.tax_liability, attr_);
   
   IF (Order_Supply_Type_API.Encode(linerec_.demand_code) = 'IPD') THEN
      tax_liability_type_db_ := External_Cust_Order_Line_API.Get_Tax_Liability(quotation_no_, line_no_, rel_no_);
   ELSE
      tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(linerec_.tax_liability, country_code_);
   END IF;
   
   Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', tax_liability_type_db_, attr_);
   Client_SYS.Set_Item_Value('DELIVERY_COUNTRY_DB', country_code_, attr_);
   Client_SYS.Set_Item_Value('IS_TAXABLE_DB', Sales_Part_API.Get_Taxable_Db(linerec_.contract, linerec_.part_no), attr_);
   IF (linerec_.free_of_charge = Fnd_Boolean_API.DB_TRUE) THEN
      Client_SYS.Set_Item_Value('FREE_OF_CHARGE', linerec_.free_of_charge, attr_);
      Client_SYS.Set_Item_Value('FREE_OF_CHARGE_TAX_BASIS', linerec_.free_of_charge_tax_basis, attr_);
      tax_paying_party_ := Order_Quotation_API.Get_Free_Of_Chg_Tax_Pay_Par_Db(quotation_no_);
      Client_SYS.Set_Item_Value('FREE_OF_CHG_TAX_PAY_PARTY', tax_paying_party_, attr_);
   END IF;
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
   linerec_     ORDER_QUOTATION_LINE_TAB%ROWTYPE;
BEGIN
   linerec_  := Get_Object_By_Keys___(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
   Client_SYS.Set_Item_Value('QUANTITY', linerec_.buy_qty_due, attr_); 
END Get_External_Tax_Info;


-- Get_Total_Discount_Amount
--   Retrieve the total discount amount for given net/PIV amount.
--   Line, additional and order discounts are rounded separately and add together.
FUNCTION Get_Total_Discount_Amount (
   quotation_no_          IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   total_amount_          IN NUMBER ) RETURN NUMBER
IS
   rec_                       Public_Rec;
   currency_code_             VARCHAR2(3);
   rounding_                  NUMBER;
   line_discount_amount_      NUMBER;
   additional_disc_amount_    NUMBER;
   quotation_discount_amount_ NUMBER;
   total_discount_amount_     NUMBER;
BEGIN
   rec_           := Get(quotation_no_, line_no_, rel_no_, line_item_no_);      
   currency_code_ := Order_Quotation_API.Get_Currency_Code(quotation_no_);
   rounding_      := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(rec_.contract), currency_code_);   
   
   line_discount_amount_   := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(quotation_no_, 
                                                                                    line_no_, 
                                                                                    rel_no_, 
                                                                                    line_item_no_, 
                                                                                    rec_.buy_qty_due, 
                                                                                    rec_.price_conv_factor, 
                                                                                    rounding_ );
   additional_disc_amount_    := ROUND(((total_amount_ - line_discount_amount_) * rec_.additional_discount/100 ), rounding_);
   quotation_discount_amount_ := ROUND(((total_amount_ - line_discount_amount_) * rec_.quotation_discount /100), rounding_);
   total_discount_amount_     := line_discount_amount_ + additional_disc_amount_ +  quotation_discount_amount_;
  
   RETURN total_discount_amount_;
END Get_Total_Discount_Amount;


-- Get_Total_Discount_Incl_Tax
--   Retrieve the total discount amount incluging tax for PIV scenario.
FUNCTION Get_Total_Discount_Incl_Tax (
   quotation_no_  IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER ) RETURN NUMBER
IS
   contract_               Site_Tab.contract%TYPE;
   currency_code_          VARCHAR2(3);
   total_gross_amount_     NUMBER;
   rounding_               NUMBER;
   rental_chargeable_days_ NUMBER;
   total_discount_amount_  NUMBER;
   
   CURSOR get_total IS
      SELECT contract, buy_qty_due * price_conv_factor * unit_price_incl_tax total_gross_amount
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   OPEN get_total;
   FETCH get_total INTO contract_, total_gross_amount_;
   CLOSE get_total;

   currency_code_          := Order_Quotation_API.Get_Currency_Code(quotation_no_);
   rounding_               := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(contract_), currency_code_);
   rental_chargeable_days_ := Get_Rental_Chargeable_Days(quotation_no_, line_no_, rel_no_, line_item_no_);
   total_gross_amount_     := ROUND((total_gross_amount_ * rental_chargeable_days_), rounding_);
   total_discount_amount_  := Get_Total_Discount_Amount(quotation_no_, line_no_, rel_no_, line_item_no_, total_gross_amount_);    
   RETURN total_discount_amount_;
END Get_Total_Discount_Incl_Tax;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Validate_Source_Pkg_Info (
   source_ref1_  IN VARCHAR2,
   source_ref2_  IN VARCHAR2,
   source_ref3_  IN VARCHAR2,
   source_ref4_  IN VARCHAR2,
   attr_         IN VARCHAR2 )
IS
   do_additional_validate_  VARCHAR2(5):= 'FALSE';
BEGIN
   do_additional_validate_ := nvl(Client_SYS.Get_Item_Value('DO_ADDITIONAL_VALIDATE', attr_),'TRUE');
   
   IF (do_additional_validate_ = 'TRUE') THEN
      IF (Sales_Promotion_Util_API.Check_Promo_Exist_For_Quo_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_)) THEN
         Error_SYS.Record_General(lu_name_, 'NOCHGTAXCODEPROMO: The tax code cannot be changed unless sales promotion calculations have been cleared.');
      END IF;
   END IF;
END Validate_Source_Pkg_Info;


-- Modify_Tax_Info
--   Modifies the tax information with the tax line tax information at the same time.
--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Modify_Tax_Info (
   attr_         IN OUT VARCHAR2,
   quotation_no_ IN     VARCHAR2,
   line_no_      IN     VARCHAR2,
   rel_no_       IN     VARCHAR2,
   line_item_no_ IN     NUMBER )
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   oldrec_           ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   newrec_           ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   tax_class_id_     VARCHAR2(20);
   component_attr_   VARCHAR2(2400);
   
   CURSOR get_package_lines IS
      SELECT line_item_no
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      AND    rowstate != 'Cancelled';
      
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, line_no_, rel_no_, line_item_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.tax_code  := Client_Sys.Get_Item_Value('TAX_CODE', attr_);
   Client_SYS.Add_To_Attr('TAX_CODE_CHANGED', 'TRUE', attr_); 
   tax_class_id_:= Client_Sys.Get_Item_Value('TAX_CLASS_ID', attr_);    
   IF (oldrec_.tax_code = newrec_.tax_code) AND (newrec_.tax_code IS NOT NULL AND oldrec_.tax_code IS NOT NULL) 
      AND (tax_class_id_ IS NULL) THEN
      --Assign to oldrec_.tax_class_id to prevent overriding when set default tax information.
      newrec_.tax_class_id := oldrec_.tax_class_id;
   ELSE
      newrec_.tax_class_id := tax_class_id_;
   END IF;
   newrec_.tax_calc_structure_id  := Client_Sys.Get_Item_Value('TAX_CALC_STRUCTURE_ID', attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   
   IF (line_item_no_ = -1) THEN
      Client_SYS.Add_To_Attr('TAX_CODE_CHANGED', 'TRUE', attr_);
      FOR component_ IN get_package_lines LOOP
         Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, line_no_, rel_no_, component_.line_item_no);
         oldrec_ := Lock_By_Id___(objid_, objversion_);
         newrec_ := oldrec_;
         component_attr_ := attr_;
         Update___(objid_, oldrec_, newrec_, component_attr_, objversion_);
      END LOOP;
   END IF;
END Modify_Tax_Info;


-- Modify_Foc_Tax_Basis
--   Update the free_of_charge_tax_basis attribute.
--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Modify_Foc_Tax_Basis (
   quotation_no_  IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   foc_tax_basis_ IN NUMBER )
IS
   attr_          VARCHAR2(2000);
BEGIN   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('FREE_OF_CHARGE_TAX_BASIS', foc_tax_basis_, attr_);
   Modify_Line___(attr_, quotation_no_, line_no_, rel_no_, line_item_no_);
END Modify_Foc_Tax_Basis;


--------------------------------------------------------------------------
-- Get_Comp_Bearing_Tax_Amount
--    Returns the total tax amount (VAT or Sales Tax) for a quotation line
--    in base currency. This is the amount the company should bear if 
--    the company pays tax for free of charge goods.
-----------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_Comp_Bearing_Tax_Amount (
   quotation_no_ IN     VARCHAR2,
   line_no_      IN     VARCHAR2,
   rel_no_       IN     VARCHAR2,
   line_item_no_ IN     NUMBER ) RETURN NUMBER
IS
   line_rec_          ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   tax_amount_        NUMBER := 0;
   rounding_          NUMBER;
   company_           VARCHAR2(20);
   tax_paying_party_  VARCHAR2(20);   
BEGIN
   line_rec_         := Get_Object_By_Keys___(quotation_no_, line_no_, rel_no_, line_item_no_);
   company_          := Site_API.Get_Company(line_rec_.contract);
   rounding_         := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   tax_paying_party_ := Order_Quotation_API.Get_Free_Of_Chg_Tax_Pay_Par_Db(quotation_no_);
         
   IF (line_rec_.free_of_charge = Fnd_Boolean_API.DB_TRUE AND tax_paying_party_ = Tax_Paying_Party_API.DB_COMPANY) THEN
      IF (line_rec_.tax_liability_type = 'EXM') THEN
         -- No tax paid for this line
         tax_amount_ := 0;
      ELSE
         tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Dom_Amount(company_, 
                                                                     Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                                     quotation_no_,
                                                                     line_no_,
                                                                     rel_no_,
                                                                     TO_CHAR(line_item_no_),
                                                                     '*');         
      END IF;   
      tax_amount_ := ROUND(tax_amount_, rounding_);
   ELSE
      tax_amount_ := NULL;
   END IF;
   RETURN tax_amount_;
END Get_Comp_Bearing_Tax_Amount;


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
   quot_line_rec_          Order_Quotation_Line_API.Public_Rec;
   quot_rec_               Order_Quotation_API.Public_Rec;

BEGIN
   quot_line_rec_ := Order_Quotation_Line_API.Get(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
   quot_rec_      := Order_Quotation_API.Get(source_ref1_);
   
   IF (quot_line_rec_.single_occ_addr_flag = 'TRUE') AND (quot_line_rec_.default_addr_flag = 'N') THEN
      address1_      := quot_line_rec_.ship_address1;
      address2_      := quot_line_rec_.ship_address2;
      country_code_  := quot_line_rec_.ship_addr_country_code;
      city_          := quot_line_rec_.ship_addr_city;
      state_         := quot_line_rec_.ship_addr_state;
      zip_code_      := quot_line_rec_.ship_addr_zip_code;
      county_        := quot_line_rec_.ship_addr_county;
      in_city_       := quot_line_rec_.ship_addr_in_city;
   ELSIF ((quot_line_rec_.default_addr_flag = 'Y') AND (quot_rec_.single_occ_addr_flag = 'TRUE')) OR 
      (source_ref1_ IS NOT NULL AND source_ref2_ IS NULL) THEN
      address1_      := quot_rec_.ship_address1;
      address2_      := quot_rec_.ship_address2;
      country_code_  := quot_rec_.ship_addr_country_code;
      city_          := quot_rec_.ship_addr_city;
      state_         := quot_rec_.ship_addr_state;
      zip_code_      := quot_rec_.ship_addr_zip_code;
      county_        := quot_rec_.ship_addr_county;
      in_city_       := quot_rec_.ship_addr_in_city;
   ELSE
      address_rec_   := Customer_Info_Address_API.Get(NVL(quot_line_rec_.customer_no, quot_rec_.customer_no), 
                                                      NVL(quot_line_rec_.ship_addr_no, quot_rec_.ship_addr_no));
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


FUNCTION Get_Ship_Country_Code (
   quotation_no_  IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER ) RETURN VARCHAR2
IS
   dummy_         VARCHAR2(200);
   country_code_  VARCHAR2(2);
BEGIN
   Get_Line_Address_Info (address1_      => dummy_,
                          address2_      => dummy_,
                          country_code_  => country_code_,
                          city_          => dummy_,
                          state_         => dummy_,
                          zip_code_      => dummy_,
                          county_        => dummy_,
                          in_city_       => dummy_,
                          source_ref1_   => quotation_no_,
                          source_ref2_   => line_no_,
                          source_ref3_   => rel_no_,
                          source_ref4_   => line_item_no_,
                          company_       => dummy_);
   RETURN country_code_;
END Get_Ship_Country_Code;

