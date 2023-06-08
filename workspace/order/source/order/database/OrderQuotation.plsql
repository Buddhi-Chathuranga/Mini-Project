-----------------------------------------------------------------------------
--
--  Logical unit: OrderQuotation
--  Component:    ORDER
--
--  IFS Developer Studio Template Verssion 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  220201  ShWtlk   MF21R2-6721, Added Remove_Intrm_Order_Resrv___() in Loose_Lines___() and Set_Close_Info___() to remove interim order structures when closing the sales quotation.
--  211206  ThKrlk   Bug 160468(SC21R2-6166), Modified Generate_Pdf_Parameters() to facilitate cloud requests.
--  211130  Sanvlk   CRM21R2-419, Changed Journal entry categories according to new event types in Crm_Cust_Info_History_API.New_Even
--  211130  ChBnlk   SC21R2-6165, Modified Update___() to pass currency_rate_ to the metod call Order_Quotation_Line_API.Calculate_Prices() in order to 
--  211130           fetch the proper price when the currency code is changed.
--  210915  Lmutlk   CRM21R2-287, rename customer to account in Crm_Cust_Info_History_API.New_Event action 
--  210506  ChBnlk   SC2021R1-373, Modified Create_Order() in order to assign the value in lose_win_reject_note to the proper attribute LOSE_WIN_REJECT_NOTE.
--  210129  Skanlk   SCZ-13274, Modified Update___()  method to prevent updating charge lines when the header single occurrence is FALSE, tax liability is EXEMPT and tax method is NOT USED.
--  210107  MaIklk   CRMZSPPT-112, Implemented to copy document text from BO.
--  210104  ErRalk   Bug 155652(SCZ-12552), Modified Generate_Pdf_Parameters() by removing ClientPrint default parameter and setting PDF_EVENT_PARAM_11 as TRUE.
--  200916  MaEelk   GESPRING20-5398, Added assigned TRUE or FALSE to DISC_PRICE_ROUND 
--  200916           according to the Discounted Price Rounded Localization Parameter. Added Get_Discounted_Price_Rounded.
--  200715  RoJalk   Bug 154273 (SCZ-10310), Modified Get_Delivery_Information to pass the new parameter ship_addr_no_changed_ to indicate delivery address change 
--  200715           and also include current delivery leadtime and picking leadtime values for the parameters.
--  200715  NiDalk   SCXTEND-4526, Moved Order_Quotation_Line_API.Modify_Additional_Discount__ to Update_ as lines are updated twice when in Check_Update___
--  200711  NiDalk   SCXTEND-4446, Modified Update___ and Fetch_External_Tax to fetch external taxes through a bundle call when address is changed.
--  200709  BudKlk   Bug 151107 (SCZ-8062) Modified Generate_Pdf_Parameters to append quotation_no_ as the report file name using PDF_FILE_NAME parameter.
--  200706  NiDalk   SCXTEND-4446, Modified Create_Order and Release_Lines___ to fetch external taxes to customer order lines.
--  200706  NiDalk   SCXTEND-4444, Added Update_External_Tax_Info to fetch tax information from external tax system.
--  200608  MalLlk   GESPRING20-4617, Modified Tax_Paying_Party_Changed___() to redirect the call to Tax_Handling_Order_Util_API.Calc_And_Save_Foc_Tax_Basis(), 
--  200608           in order to calculate and save free of charge tax basis.
--  200504  ThKrLk   Bug 152816(SCZ-9901), Modified Update___() by calling Add_Charges_On_Cust_Change___() and Sales_Promotion_Util_Api.Clear_Quote_Promotion() if customer changes. 
--  200504           And added new Add_Charges_On_Cust_Change___() method.
--  200319  Maralk   SCXTEND-2838, Merged Bug 152454 (SCZ-9044), Modified the log in Get_Delivery_Information to align the delivery information fetching with Customer Order.
--  200220  MaRalk   SCXTEND-2838, Merged Bug 147950(SCZ-4398), Modified method Get_Delivery_Information() to avoid call to the Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults() method 
--  200220           when agreement's Exclude from auto pricing is checked and used by Order/Quotation header is unchecked and passed values to the out attr_ to 
--  200220           retain client values when they are not fetch from the server.
--  200217  NipKlk   Bug 152454 (SCZ-9044), Modified the log in Get_Delivery_Information to align the delivery information fetching with Customer Order.
--  200217  NipKlk   Bug 152454 (SCZ-9044), Re-applied the correction of the bug 147950 (SCZ-4398) since it was reversed  in the Xtend delivery to support for UPD 7.
--  200205  RaVdlk   SCXTEND-3100, Modified Check_Update to validate the invoice customer value with the payment term
--  191003  Hairlk   SCXTEND-939, Avalara integration, Modified Insert___, Added code to fetch customer_tax_usage_type from customer if its not available in the attr.
--                   Modified Check_Update___ to prevent changing customer_tax_usage_type if the quotation is in Closed or Cancelled state. Modified Build_Attr_Copy_Quotation___ and Build_Attr_Create_Ord_Head___, added CUSTOMER_TAX_USAGE_TYPE to the attr.
--  190905  NiDalk   Bug 149773 (SCZCRM-712), Modified New and Build_Attr_For_New___ to increase new_attr_ to 32000.
--  190610  DilMlk   Bug 148572 (SCZ-4938), Modified Update___() to refetch customer part no and description when customer no is modified by the user.
--  190313  NiNilk   Bug 144016, Modified Generate_Pdf_Parameters() method to indicate printing through client print dialog the PDF_EVENT_PARAM_11 to have control on PDF event actions.
--  181214  SeJalk   SCUXXW4-9277, Added Funtion Calculate_Totals() to support totals in SalesQuotationHandling Projection.
--  190307  NiDalk   Bug 147218 (SCZCRM-410), Modified Check_Common___ to add a check for expire date of customer.
--  190206  NiNilk   Bug 146641 (SCZ-3132), Modified Generate_Pdf_Parameters() by increasing the length of the variable local_email_ to avoid oracle error character buffer too small.
--  181004  ErRalk   Bug 144394, Modified Copy_Quotation__ method to copy document text in charge line only when 'document text' checkbox is checked in copy quotation function.
--  180824  ChBnlk   Bug 143409, Modified Get_Bo_Connected_Quote_No() in order to increase the size of the variable quotation_no_.
--  180720  ChBnlk   Bug 143017, Modified Check_Update___() by checked if the customer_no is changed with the agreement_id before fetching the default delivery information.
--  180427  DilMlk   Bug 140829, Modified Get_Quote_Defaults___ to pass picking_leadtime_, when Sales Quotation is created from Business Opportunity window.
--  180504  AyAmlk   SCUXX-3519, Passed values for is_third_party_contact_ parameter in Modify_Main_Contact().
--  180221  DiKuLk   Bug 140020, Modified Fetch_Delivery_Attributes() to track if the ship via code is changed.
--  180213  IzShlk   STRSC-17007, Modified Check_Insert___ to Validate Customer tax information for customer type other than Prospect.
--  180207  NiEdLk   SCUXX-2955, Modified Insert___ to add an interaction record to the customer when a sales quotation is created.
--  171229  MaEelk   STRSC-15440, Replaced Customer_Agreement_API.Get_State with Customer_Agreement_API.Get_Objstate in Validate_Customer_Agreement___.
--  171219  DiKuLk   Bug 139211, Modified Fetch_Delivery_Attributes() procedure to get the user manually entered values from the client.
--  171211  SBalLK   Bug 137084, Added Generate_Pdf_Parameters() and modified Email_Sales_Quotation__() method to generate PDF Parameter string.
--  171019  Nikplk   TRSC-10690, Modified Create_Order__() method and Create_Order_Head__() method in order to copy contacts from Sales Quotation to Customer Order.
--  171012  RaVdlk   STRSC-12276, Updated the order of the history lines in the SQ when copied. 
--  171009  RaVdlk   STRSC-12361, Avoided duplicating charge lines in copy quotation.
--  170927  Jhalse   SCUXX-681, Moved null checks for delivery address above super calls in check_update___ and check_insert___.
--  170926  RaVdlk   STRSC-11152,Removed Get_State and Get_Objstate functions, since they are generated from the foundation
--  170907  IzShlk   STRSC-11319, Added validation for Get_Customer_Defaults___ to check access for customer brfore it fetch default values to customer order.
--  170824  ShPrlk   Bug 136668, Modified Update___  to adjust parameters for the method call Sales_Price_List_API.Get_Valid_Price_List.
--  180814  SBalLK   Bug 137300, Modified Get_Quote_Defaults___() method to set NULL for tax liability for the customer/end customer and 'EXEMPT' for the prospect customer when there is no valid tax liability.
--  170801  KiSalk   Bug 137050, Added method Rental_Order_Creatable. Made Won SQ lines considered as updatable in Modify_Wanted_Delivery_Date__ and Updatable_Lines_Exist.
--  170714  IzShlk   STRSC-10803, Generic method Get_Eligible_Representative() has been called to select main representative when we create a SQ.
--  170626  ErRalk   Bug 135979, Modified the NOTDOCADDR error message to have a full stop at the end in and Check_Insert___ in Check_Update___.
--  170601  Hairlk   STRSC-6022, Reversing the correction done for this bug previously with revision 772646
--  170526  IzShlk   VAULT-2657, Handled logic to change main representative when creating CO from SQ.
--  170516  IzShlk   VAULT-2558, Handled logic in Create_Order___() to handle copy all representatives.
--  170512  AyAmlk   APPUXX-11619, Removed Get_Specific_Delivery_Info() since its no longer used.
--  170510  SeJalk   STRSC-7670, Modified Create_Order_Head  to set correct Representative role when creating customer order from quotation.
--  170504  Sucplk   Bug STRSC-7428, Modified length of line_op_ from 5 to 6 in Get_Allowed_Operations__ in order align it with changes done in Order_Quotation_Line_API related to this bug.
--  170417  SudJlk   STRSC-7118, Added RMCOM dynamic component check in Insert___ for BUS_OBJ_REPRESENTATIVE_TAB.
--  170404  KiSalk   Bug 135001, Allowed agreements of hierachy parents in Validate_Customer_Agreement___.
--  170403  KoDelk   STRSC-6363, Rename BusinessObjectRep to BusObjRepresentative
--  170329  Hairlk   APPUXX-10876, Modified Build_Attr_For_New___ to set value for USE_PRICE_INCL_TAX_DB emulating the behaviour in frmOrderQuotationWindow GetUsePriceInclTax method.
--  170223  JanWse   VAULT-2472, Always add the logged in user as a representative to give him/her rights on the new object (applies only if the user is a representative)
--  170217  JanWse   VAULT-2472, When an object is copied add the logged in user as a representative on the new copied to give him/her rights on the new object
--  170209  IsSalk   STRSC-6022, Modified New_Revision___() to avoid adding revision when all lines are cancelled.
--  170208  Hairlk   APPUXX-7278, Modified PROCEDURE Update___, added if condition to check for change of agreement id. Otherwise the logic will run even if the price effective date 
--                   is changed which will cause lines to fetch delivery information again which might differ from header delivery info. This is how its handeled in customer order.
--  170127  LaThlk   Bug 131981, Modified Get_New_Quotation_No___() in order to pass order_no_ when calling Incr_Quotation_No_Autonomous() and Increase_Quotation_No().
--  170127  SudJlk   VAULT-2418, Changed the order of code in Insert___ to have the main repreesntative saved as soon as the header is saved (needed for access)
--  161118  Hairlk   APPUXX-6164, Modified New_Revision___ to lock the record before updating
--  161102  SudJlk   VAULT-1905, Modified Build_Attr_Create_Ord_Head___ to pass on the main representative to CO.
--  161102  Hairlk   APPUXX-5878, Modified Get_Allowed_Operations__ to include Reject operation and Refactored Set_Rejected method to align with other state related methods
--  161102  Hairlk   APPUXX-5312, modified Check_Before_Close__ to consider rejected lines also since its not possible to Close a rejected quotation with Close RMB
--  161028  AyAmlk   APPUXX-5318, Modified Copy_Quotation__() in order to prevent copying B2B OQs created for shopping cart.
--  161025  Hairlk   APPUXX-5281, Added Clear_Rejected_Reason___ as a event.
--  161023  Hairlk   APPUXX-5281, Removed Clear_Rejected_Reason___
--  161006  TiRalk   STRSC-4325, Modified Cancel_Lines___ to update the cancal reason in lines and removed the Cancel_Lines method as it has not been used anywhere.
--  160926  Hairlk   APPUXX-4354, Added public method Get_Lose_Win_Reject_Note and renamed column LOSE_WIN_NOTE to LOSE_WIN_REJECT_NOTE
--  160929  Matkse   APPUXX-5137, Reverted APPUXX-3051, use Cust_Order_B2b_Shop_Cart_API instead of b2b_order column since change request also use this logic.
--  160926  Hairlk   APPUXX-4354, Added state Rejected and actions Reject_Released_Lines___, Update_Rejected_Reason___, Clear_Rejected_Reason___ to the state machine.
--                   added rejected reason column to the ORDER_QUOTATION_TAB
--  160914  RasDlk   Bug 131441, Modified Copy_Quotation__ to copy sales quotation header custom field values.
--  160913  matkse   APPUXX-4724, Modified Build_Attr_Create_Ord_Head___ to set B2B_ORDER when the CO is created.
--  160909  SudJlk   STRSC-4046, Modified Get_Quote_Defaults___ to fetch agreement only if it is to be used by SQ header.
--  160908  ChJalk   Bug 130981, Modified Fetch_Delivery_Attributes to make the parameteres delivery_terms_ and del_terms_location_ IN OUT.
--  160907  NiAslk   STRSC-2740, Update of Sales Quotation Address on line level
--  160826  Dinklk   APPUXX-3413, Added Check_Diff_Delivery_Info.
--  160822  NiAslk   STRSC-2740, Added new method Has_Non_Def_Info_Lines to check if there is any line with same address as header.
--  160819  RasDlk   Bug 130805, Modified Update___ to perform recalculation of prices, discounts and charges when the currency_code has changed in quotation header.
--  160819           Modified Check_Update___ to check whether the currency code is changed on closed quotations.
--  160809  Hairlk   APPUXX-3124, Added Released_Quotation_Lines_Exist to check if there are anylines in released state for a given quotation
--  160805  Maabse   APPUXX-3051 Replaced Cust_Order_B2b_Shop_Cart_API with use of b2b_order column.
--  160804  Maabse   APPUXX-2767 Replaced Order_Quote_Shop_Cart_API with Cust_Order_B2b_Shop_Cart_API
--  160729  RasDlk   Bug 130036, Added Check_Before_Close__() in order to check whther there are any Released or Planned quotation lines.
--  160722  SudJlk   STRSC-3514, Added UncheckAccess to Get_Bo_Connected_Quote_No.
--  160712  Matkse   APPUXX-271, Modified Unpack___ by keeping PRICE_EFFECTIVITY_DATE in sync with WANTED_DELIVERY_DATE on B2B sales quotations.
--  160708  Matkse   APPUXX-2144. Added Get_Specific_Delivery_Info, to fetch specific delivery info attributes.
--  160621  Hairlk   APPUXX-1725, Added B2B_ORDER parameter to Get_Quote_Defaults___ which indicates the created sales quotation is originated from sales quotation or not
--  160616  ChJalk   Bug 127627, Modified the method Fetch_Delivery_Attributes to change the OUT parameter forward_agent_id_ to IN OUT.
--  160609  Matkse   APPUXX-1543, Added Get_Net_Amount.
--  160601  NWeelk   FINHR-2068, Modified Check_Common___ by removing tax regime related codes.
--  160601  MAHPLK   FINHR-2018, Removed Validate_Tax_Calc_Basis___.
--  160527  AyAmlk   APPUXX-1247, Added Remove() public method. 
--  160518  SWeelk   Bug 128826, Modified Update__() by adding 'SERVER_DATA_CHANGE' to the attribute string to make possible to edit quotation lines when
--  160518           changing the price_effective_date in the header
--  160513  KiSalk   Bug 129163, Since PDF_EVENT_PARAM_4 sends person_id of the contact, if it's not a comm. method, added PDF_EVENT_PARAM_8 to send name of comm. method or name of the contact person.
--  160517  Chgulk   STRLOC-80, Added New Address fields.
--  160506  Chgulk   STRLOC-369, used the correct package.
--  160420  NWeelk   STRLOC-244, Modified method Build_Attr_Create_Ord_Head___ to set FREE_OF_CHG_TAX_PAY_PARTY_DB when the CO is created.
--  160419  NWeelk   STRLOC-243, Added method Tax_Paying_Party_Changed___ to call when the free of charge tax pay party is changed. 
--  160329  NiDalk   Bug 127893, Modified Update___ and Check_Update___ to remove changes done in 127181 and 126441 as POST_Order_ConvertOrderQuotationProspect 
--  160329           is modified to use direct updates for order_quotation_tab and order_quotation_line_tab.
--  160324  TiRalk   STRSC-1581, Modified Business_Object_Contact_API.Copy_Contact__ instances since it changed to a public method.
--  160309  NiNilk   Bug 126441, Modified Update___ to ignore state change for Closed and Cancelled records when updating from POST_Order_ConvertOrderQuotationProspect.sql.
--  160309           Also modified Check_Update___ to ignore checks when updating from POST_Order_ConvertOrderQuotationProspect for Closed and Cancelled records.
--  160307  DipeLK  STRLOC-247,Change Validate_Address() method call to Address_validation_API.Validate_Address
--  160219  TiRalk   STRSC-914, Modified Business_Object_Contact_API calls references due to key changes.
--  160217  NipKlk   Bug 127372, Removed unnecessary duplicate code which checks the quotation is closed and fires an error when updating in the method Check_Update()___.
--  160202  ErFelk   Bug 123221, Modified Copy_Quotation__() and Build_Attr_Copy_Quotation___() by adding attributes so that copy quotation functionality works correctly.   
--  160202           Modified Check_Insert___() by adding default values to mandatory fields.
--  150930  KhVese   Bug 124761, Modified Update___() method to to handle line-level update when customer_no change on header. 
--  150917  KhVese   AFT-5439, Modified the logic of Get_Quote_Defaults___() to retrive use_price_incl_tax_db_ from contract if it is null and fetch correct freight price list. 
--  150826  KhVese   AFT-1612, Modified Update___() to save the CLIENT_SYS.current_info_ to avoid loosing it when calling Modify_Quote_Defaults__() method.
--  150820  MaRalk   BLU-1154, Modified method Insert__ by replacing the method call 
--  150820           Business_Object_Rep_API.New_Business_Object_Main_Rep with Business_Object_Rep_API.New_Business_Object_Rep. 
--  150819  KhVese   COB-418, Modified the logic of Get_Quote_Defaults___() and the interface and logic of Fetch_Delivery_Attributes() to consider single occurrence address. 
--  150817  Erlise   COB-416, Modified Check_Update___(), Update___() to consider single occurrence address changes.
--  150813  KhVese   COB-688, In method Update___() set the default value of variable updated_from_wizard_ to FALSE to triger Finite_State_Machine___() call when it is necessary.
--  150813  KhVese   COB-682, Modified the Event parameter value when calling Order_Quotation_History_Api.New() for Single-Occurence flag/address in the method Update___()
--  150730  Erlise   COB-416, Included single occurrence country code in Check_Common___ method.
--  150727  MaRalk   BLU-977, Added method Check_Edit_Allowed in order to use in crm/BusinessObjectRep - Check_Insert___ method.
--  150724  Wahelk   BLU-1085, Modified method Build_Attr_Create_Ord_Head___ to pass Sales Quotation No to add in customer order header
--  150714  KhVese   COB-692,COB-516 SHIP_ADDR_COUNTRY_CODE and VAT_FREE_VAT_CODE added to the list of attributes in Build_Attr_Copy_Quotation___() method.
--  150714  KhVese   COB-683, Added single occurrence address validation to Check_Common___()
--  150714           COB-683, Modified Check_Update___ method to check if single occurrence country code has defined Tax-liability.
--  150714  MaRalk   BLU-974, Added annotation @UncheckedAccess to the method Get_State in order to use in REPRRSENTATIVE_ORD_QUOT view definition.
--  150710  KhVese   COB-682, Modified Update___() method to add Single-Occurence flag/address changes to Order Quotation History. 
--  150709  KhVese   COB-554, Modified Create_Order_Head() method to pass tax_free_tax_code when call Customer_Order_Address_API.New(). 
--  150709  KhVese   COB-82, Modified Check_Common___() method to validate Tax_Free_Tax_Code belong to single-occurence address.
--  150619  ChBnlk   ORA-828, Modified Copy_Quotation__(),  Create_Order_Head() and New()by moving the attribute string manipulation to seperate methods. 
--  150619           Introduced new methods Build_Attr_Copy_Quotation___(), Build_Attr_Create_Ord_Head___() and Build_Attr_For_New___.
--  150616  NaLrlk   RED-475, Modified Copy_Quotation__() to include rental lines when coping.
--  150611  KhVeSE   COB-80, Modified Create_Order_Head() to call Customer_Order_Address_API.New() when order has SO Address.
--  150611           Also Modified Create_Order___() to call Change_Address() for lines that have SO Address and their default info are not set.
--  150526  NaLrlk   RED-335, Modified Calculate_Line_Disc___, Get_Quote_Line_Totals__, Get_Total_Add_Discount_Amount to include rental chargeable days for rentals.
--  150525  Erlise   COB-333, Added single occurrence address fields in method Copy_Quotation__():
--  150519  RoJalk   ORA-161, Modified Get_Quote_Defaults___ and replaced the logic to fetch cust ref with Cust_Ord_Customer_API.Fetch_Cust_Ref. 
--  150429  Erlise   COB-332, Modifed Update___(), added evaluation of single_occ_addr_flag_ in call to Order_Quotation_Line_API.Modify_Quote_Defaults__.
--  150317  Erlise   COB-66, Added Single occurence address on Sales Quotation header.
--  150727  NipKlk   Bug 122680, Added REPLY_TO_USER to the archiving_attr_ in the method Email_Sales_Quotation__ to correctly fetch the authorizer to the variable REPLY_TO_USER.
--  150313  MeAblk   Bug 121463, Modified Calculate_Line_Disc___ in order to update the discount when there is a change on it.
--  150226  JeLise   PRSC-6291, Added override of Check_Common___ to check that supplier is not internal supplier on the same site as the quotation.
--  150226  RasDlk   PRSC-4595, Modified Update___() to set the fee code of the sales quotation line according to sales quotation header if there is a change in supply country.
--  150213  PraWlk   PRSC-5863, Modified Copy_Quotation__() to transfer the modified dates to the new quotation when the general  
--  150213           check box is not marked in the copy quotation dialog box.
--  150209  MAHPLK   PRSC-4770, Modified Update___() so that Modify_Line_Default_Addr_Flag() is called when header vendor no is changed. 
--  150207  MAHPLK   PRSC-4770, Modified Get_Delivery_Information to consider the incoming VENDOR_NO.
--  141217  MaIklk   PRSC-974, Checked and handled the places where we can enable some logic for prospect since we have enabled customer/order tab for prospects.
--  141216  SBalLK   PRSC-3709, Modified Get_Quote_Defaults___() method to use client values fro delivery terms location when there exist a delivery term defined in client.
--  141215  MaIklk   PRSC-965, Handled to set the opportunity header staus to confirmed when all references are lost/rejected, cancelled or removed.
--  141212  MaIklk   EAP-835, Removed the check Cust_Ord_Customer_API.Get_Email_Quotation_Db() in Email_Quotation_Allowed___().
--  141128  SBalLK   PRSC-3709, Modified Get_Quote_Defaults___(), Update___(), Check_Update___() Get_Delivery_Information() and Fetch_Delivery_Attributes() methods to fetch delivery terms
--  141128           and delivery terms location from supply chain matrix.
--  141030  PraWlk   PRSC-209, Modified Check_Update___() to update the main contact in Contacts tab when the reference filed is modified in SQ header.
--  141029  ChJalk   PRSC-3984, Added new IN parameter copy_contacts_ into the method Copy_Quotation__() to add contacts when copying.
--  141014  Chfose   PRSC-3591, Added new IN parameter customer_po_no_ to Create_Order_Head and updated Create_Order___ accordingly.
--  141007  UdGnlk   PRSC-3137, Modified Calculate_Line_Disc___() and Update___() to include the discount freeze functionality.
--  140916  UdGnlk   PRSC-311, Modified Get_Quote_Defaults___() by adding a NULL condition to bill_addr_no_.
--  140912  MaRalk   PRSC-2436, Modified method Get_Quote_Defaults___ to avoid resetting tax liability when 
--  140912           customer Delivery Tax information is not defined.
--  140911  UdGnlk   PRSC-309, Modified Copy_Quotation__() to support copy sales quotation functionality.
--  140909  ChJalk   EAP-321, Added new method Co_Created_Line_Exist.
--  140826  RoJalk   Modified Copy_Quotation__ and used conditional compilation for the  Business_Object_Rep_API.Copy_Representative__ method call.
--  140808  PraWlk   PRSC-2145, Modified Cancel_Lines___(), Release_Lines___(), Loose_Lines___(), Validate_Jinsui_Constraints___(), Update___(),  
--  140808           Check_Update___(), Get_Allowed_Operations__(), Close_Quotation__(), Modify_Wanted_Delivery_Date__(). Updatable_Lines_Exist()  
--  140808           and Update_Freight_Free_On_Lines() by adding new state 'CO Created' to the conditions.
--  140728  Hecolk   PRFI-41, Replaced usage of Party_Identity_Series_API.Update_Next_Identity with Party_Identity_Series_API.Update_Next_Value
--  140728  MaRalk   PRSC-1931, Modified method Get_Quote_Defaults___ to avoid resetting tax liability when 
--  140728           customer Delivery Tax information is not defined.
--  140718  PraWlk   PRSC-316, Modified Create_Order() to call Finite_State_Machine___() with 'QuotationOrderCreated' and  
--  140718           added Set_Quotation_Close__() and Set_Close_Info___() to support the close operation of SQ header. 
--  140718  PraWlk   PRSC-316, Added Won_Lines___() and Set_Quotation_Won__() and modified Create_Order___() and
--  140718           Get_Allowed_Operations__() to support the newly implemented RMB won Quotation in SQ header.
--  140603  MaEdlk   Bug 117072, Removed rounding of variable total_weight_ in method Get_Total_Weight__.
--  140523  MaIklk   PBSC-8865, Added Main rep in Prepare_Insert().
--  140514  NIWESE   PBSC-8638 Added call to custom validation for Cancel Reason codes.
--  140428  RoJalk   Modified the parameter order in Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults called from Check_Update___.
--  140423  MaRalk   PBSC-8242, Modified error message texts for NOTNULLSHIPNO.
--  140321  HimRlk   Modified logic to pass use_price_incl_tax value when fetching freight price lists.
--  140321  KiSalk   Bug 115190, In Calculate___, renamed menu name from "View Calculated Sales Promotions" to "Calculate and View Sales Promotions" in info messages.
--  140318  MaIklk   PBSC-7577, Implemented to create prospect using a template customer id.
--  140311  ShVese   Removed the override annotation from the method Check_Customer_No_Ref___.
--  140307  HimRlk   Merged Bug 110133-PIV, Modified method Calculate_Line_Disc___,  calculations are done using order currency, then final values are converted to base currency and removed cursor get_total_base_price.
--  140307           Modified discount calculations of  Calculate_Line_Disc___(), Get_Quote_Line_Totals__() and Get_Total_Add_Discount_Amount(),discount amount should be consistent with discount postings.
--  140307  MaRalk   PBSC-6360, Added method Exist_Sales_Quotations to check the existence of sales quotations for a specified customer.
--  140305  SURBLK   Change Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Db in to Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db.
--  140226  RoJalk   Modified Modify_Main_Representative and replaced Unpack_Check_Update___ with Unpack___/Check_Update___.
--  140205  Maabse   Modified parameters to Modify_Main_Representative to enable remove of main representative
--  140203  Maabse   Modified parameters to Modify_Main_Representative
--  131021  RoJalk   Corrected code indentation issues after merge.
--  130827  MaMalk   Removed the packing of SHIPMENT_TYPE in several methods since it is not a part of OrderQuotation LU.
--  130729  SURBLK   Set forward_agent_id_ as INOUT in Fetch_Delivery_Attributes ().
--  130712  HimRlk   Replaced Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes() with Cust_Order_Leadtime_Util_API.Fetch_Head_Delivery_Attributes().
--  130627  HimRlk   Modified Create_Order_Head() to pass vendor_no to the new customer order.
--  130612  HimRlk   Added new field vendor_no.
--  130521  HimRlk   Passed NULL for vendor_no in method call Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults. 
--  130314  HimRlk   Added new method Get_Quote_Line_Totals__ to return totals. 
--  120911  MeAblk   Added ship_inventory_location_no_ as a parameter to methods Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults, Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes.
--  120824  MeAblk   Added parameter shipment_type_ into the method Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults.
--  120824  MaMalk   Added shipment_type as a parameter to method Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes.
--  120726  MAHPLK   Added parameter picking_leadtime_ to Fetch_Delivery_Attributes.
--  120725  MAHPLK   Added attribute picking lead time.
--  120702  MaMalk   Added route and forwarder as parameters in method Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes, Get_Supply_Chain_Defaults and Get_Supply_Chain_Head_Defaults.
--  120823  HimRlk   Changed use_price_incl_tax column to be update allowed.
--  120813  JeeJlk   Modified Create_Order_Head to set USE_PRICE_INCL_TAX_DB when creating order from quotation.
--  120719  ShKolk   Added price including tax columns to methods which calculate prices.
--  120710  ShKolk   Added column use_price_incl_tax.
--  130717  UdGnlk   TIBE-1005, Removed global variable current_info_in OrderQuotationLine therefore changed the logic accordingly.
--  130712  UdGnlk   TIBE-1003, Removed the global variable updated_from_wizard_ therefore logic changed accordingly.
--  130709  UdGnlk   Removed global variables and modify conditional compilation.
--  130730  RuLiLk   Bug 110133, Modified method Calculate_Line_Disc___, Calculations are done using order currency, then final values are converted to base currency. 
--  130702  SWiclk   Bug 107700, Added method Get_New_Quotation_No___() and new attribute source order. Modified Unpack_Check_Insert___(), Unpack_Check_Update___() and Insert___()  
--  130702           in order to use autonomous transaction when the order quotation creation is sourced from Incoming Customer Order approval. Modified Create_Order() and Create_Order_Head()  
--  130702           in order to use autonomous transaction when creating customer Order header since quotation with multiple lines may lock the order_coordinator_group_tab for considerable time.
--  130603  RuLiLk   Bug 110133, Modified methods Get_Total_Add_Discount_Amount(),  Calculate_Line_Disc___()
--  130603           by changing Calculation logic of line discount amount to be consistent with discount postings. Removed cursor get_total_base_price in method Calculate_Line_Disc___.
--  130603  ChBnlk   Bug 109515, Modified procedure Get_Next_Line_No to display the proper error message when entering values beyond 9999 to the column rel_no.
--  130322  IsSalk   Bug 108922, Modified methods Unpack_Check_Update___(), Unpack_Check_Insert___() and Validate_Jinsui_Constraints___() to enable 
--  130322           Jinsui Invoicing for Sales Quotation with Quotation lines and charges.
--  130104  MaIklk   Added Get_Customer_Count() and Get_Ship_Address_Count().
--  121214  MaIklk   Removed customer_name and quotation_customer_type from business logic.
--  121210  MaIklk   Added Opportunity No column.
--  121204  MaIklk   Handled Prospect type customers and use of customer category.
--  121005  RoJalk   Bug 100221, Modified method Get_Allowed_Operations__ and added new method Email_Quotation_Allowed__ to include validations of email quotation 
--  120612           and print quotation.
--  121004  AyAmlk   Bug 105605, Modified Validate_Customer_Agreement___() in order to prevent an oracle error comes due to an addition of 1 to the valid_until date when it is the last calendar date.
--  120816  JICE     Added public method Set_Released for BizAPIs.
--  120809  SudJlk   Bug 103412, Modified Unpack_Check_Insert___ to check if the quotation_no has leading or trailing spaces.
--  120611  JICE     Set Cust_Ref public for B2B BizAPIs
--  120423  IsSalk   Bug 101578, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ by replacing Client_SYS.Add_Info with Client_SYS.Add_Warning to give a warning message
--  120423           when dupplicating same customer and REQ number combination.
--  120412  AyAmlk   Bug 100608, Increased the length to 5 of the column delivery_terms in views ORDER_QUOTATION and deliv_term_ in Get_Delivery_Information().
--  120308  MaRalk   Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___ to restrict saving a record with freight zone id without a freight map id.
--  120126  ChJalk   Added ENUMERATION to the column supply_country in the base view.
--  120110  Darklk   Bug 100661, Added the function Check_Customer_Quo_No___ and modified Unpack_Check_Insert___ and Unpack_Check_Update___ to check whether
--  120110           the same customer has got the same customer's RFQ number.
--  120102  DaZase   Added call to Sales_Promotion_Util_API.Check_Unutilized_Q_Deals_Exist in Release__ and a new info message in the same method.
--  111215  MaMalk   Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111206  MaMalk   Added pragma to Get_Total_Base_Charge__.
--  111018  MaRalk   Modified method Update___ by adjusting the parameters for the method calls Sales_Price_List_API.Get_Valid_Price_List and 
--  111018           Customer_Order_Pricing_API.Modify_Default_Qdiscount_Rec.
--  111018  GiSalk   SSC-9, Modified Get_Quote_Defaults___ to retrieve the company value corresponding to the contract and added it to the attr_. Modified New to retrieve 
--  111018           the supply country value corresponding to the contract and added it to the attr_. Modified Prepare_Insert___ to stop adding company to attr_.
--  110919  MaMalk   Increased the length of CUSTOMER_QUO_NO to 50.
--  110914  HimRlk   Bug 98108, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ by changing the Exist check of document address to Customer_Info_Address_API.
--  110914           Changed the reference of bill_addr_no and customer_no_pay_addr_no to CustomerInfoAddress in base view.
--  101215  Cpeilk   Bug 93860, Modified method Insert___ to add CURRENCY_ROUNDING to the attr.
--  110818  NaLrlk   Bug 95520, Modified the procedure Update___ to modify the charges lines when the customer_no and currency_code is changed and modified the Unpack_Check_Update___
--  110818           to avoid updating the sales quotaion since at least one of the sales quotation lines in 'LOST' or 'WON' states.
--  110818           Added a new condition to modify the sales quotation lines according to the changed customer_no.
--  110812  AmPalk   Bug 97354, Modified Create_Order___, by setting Order_Quotation_Line_API.current_info_ to null after creation of all lines for the header. 
--  110812           This will facilitate multiple info from lines relevant for the order header only. 
--  110805  Darklk   Bug 96328, Modified the procedure Update___ to consider the configured sales part when updating the sales quotaion lines.
--  110728  IsSalk   Bug 97918, Modified method Get_Quote_Defaults___ to get the correct invoice customer's default document address and methods Unpack_Check_Insert___
--  110728           and Unpack_Check_Update___ to check whether the invoicing customer Addr Id type is document.
--  110712  ChJalk   Added user_allowed_site filter to the view SITEVIEW.
--  110707  ChJalk   Removed view VIEW_UIV and added user_allowed_site filter to the base view.
--  110701  KiSalk   Bug 96918, In Get_Total_Sale_Charge__ and Get_Tot_Charge_Sale_Tax_Amt added rowstate != 'Cancelled' check.
--  110609  ShKolk   Added error message CANNOTUPDFIXDELFRE to Unpack_Check_Insert___ and Unpack_Check_Update___.
--  110601  NaLrlk   Modified the methods Create_Order_Head, Create_Order___ and Create_Order to handle the info_.
--  110524  MaMalk   Modified Update___ to refetch taxes for charges when supply country is changed.
--  110510  MaMalk   Modified method Update___ to update the tax information of quotation header connected charge lines.
--  110504  MaMalk   Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___ to remove the message raised when a tax free tax code could not be found,
--  110504           since the line level tax free tax code will be refetched according to the delivery type used in the line level and at the point of header creation
--  110504           this message does not make sense.
--  110426  AmPalk   Bug 94785, Made language_code editable on closed quotations.
--  110422  ChJalk   EASTONE-16125, Modified the methods Get_Tot_Charge_Sale_Tax_Amt and Get_Total_Sale_Charge__ to calculate the charge totals correctly.
--  110421  MaMalk   Modified Unpack_Check_Update___ to raise some validation messages on supply country.
--  110408  MaMalk   Modified Update___ to refetch taxes of quotation lines when the tax liability or the supply country is changed.
--  110404  MaMalk   Modified Unpack_Check_Update___ to take the Iso_Country_API.Exist check out of the loop.
--  110330  AndDse   BP-4760, Modified Unpack_Check_Update___ due to changes in Cust_Ord_Date_Calculation.
--  110302  PAWELK   EANE-3744  Removed user_allowed_site filter from View ORDER_QUOTATION. Added new view ORDER_QUOTATION_UIV.
--  110202  Nekolk   EANE-3744  added where clause to View ORDER_QUOTATION.
--  110221  UTSWLK   Added code to send EXT_TRANSPORT_CALENDAR_ID defined in quotation header when create customer order from Create_Order_Head.
--  110214  AndDse   BP-4146, Modifications for info message handeling on calendar functionality.
--  110105  AndDse   BP-3776, Added EXT_TRANSPORT_CALENDAR_ID to LU.
--  110104  ChFolk   Modified Release__ to calculate sales promotion when releasing the quotation.
--  101223  AndDse   BP-3686, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to show warning if wanted delivery date is on a non working day.
--  101208  ChFolk   Added new function Won_Line_Exist.
--  101117  ChFolk   Modified Release__ to do freight consolidation when releasing the quotation header.
--  101116  ChFolk   Added new parameter create_from_header_ into Create_Order_Head and re-arranged the parameter order.
--  101116           Modified Create_Order to pass the parameter value for create_from_header.
--  101109  ChFolk   Added new public attributes apply_fix_deliv_freight and fix_deliv_freight.
--  101105  ChFolk   Modified Get_Quote_Defaults___ to get the valie for ship_via_code_ from the attr.
--  101018  Chfolk   Added new procedure Update_Freight_Free_On_Lines.
--  100908  ChFolk   Added new procedure Fetch_Delivery_Attributes which retrieve delivery information based on the given delivery attributes. 
--  100902  ChFolk   Added new columns freight_map_id, zone_id and freight_price_list_no and do necessary changes in methods.
--  100826  ChFolk   Modified Create_Order_Head to pass forward_agent_id from quotation header to CO header.
--  100820  ChFolk   Added new column forward_agent_id and do necessary changes in methods. Modified Get_Quote_Defaults___ to set the default value for forward_agent_d.
--  ------  ----     -----------------------------------------------------------
--  110128  Mohrlk   DF-774, Modified Get_Customer_Defaults__() to set the customers default value for the tax_liablility.
--  110120  Mohrlk   Added Tax Liability as an attribute.
--  101230  Mohrlk   Added Supply_Country as an attribute.
--  100603  MaMalk   Replaced ApplicationCountry with IsoCountry to represent correct relationship in overviews.
--  101007           This was done to all attributes which can create order quotation history records.
--  100806  AmPalk   Bug 91492, Added Release_Customer_Order__. Added new parameters to Create_Order and Create_Order_Head.
--  100525  MaAnlk   Bug 90829, Modified procedure Modify_Wanted_Delivery_Date__.
--  100520  KRPELK   Merge Rose Method Documentation.
--  100111  MaRalk   Modified Not as NOT in the state machine when the state_ = 'Released' and event_ = 'QuotationChanged'.
--  100510  MaGuse   Bug 89794, Modified cursor GetCharges in Transfer_Charge_To_Order.
--  100504  MaGuse   Bug 89794, Modified cursor GetCharges to retrive only the charges which are not attached to a lost line in Transfer_Charge_To_Order().
--  100426  MaMalk   Bug 90223, Modified Email_Sales_Quotation__ to include CUSTOMER_QUO_NO when emailing the Order Quotation.
--  100422  MaAnlk   Bug 79609, Modified Modify_Wanted_Delivery_Date__ to raise error and information messages when date change affects valid base part revision used for the configuration.
--  100406  SuThlk   Bug 89693, Handled the value overflow scenario of the next line no value in Get_Next_Line_No.
--  100318  MalLlk   Bug 88626, Modified Email_Sales_Quotation__ to send quotation no as the PDF_EVENT_PARAM_5.
--  100304  SaJjlk   Bug 88760, Modified method Update___ to remove call to Order_Quotation_Charge_API.Remove_Tax_Lines when vat column has not changed.
--  100304           Modified parameters of method call to Order_Quotation_Charge_API.Add_Tax_Lines to execute the other overloaded method.
--  100105  MaRalk   Modified the state machine according to the new developer studio template - 2.5.
--  090930  MaMalk   Removed constants state_separator_ and inst_CreateCompanyTem_. Removed unused code in Get_Jinsui_Invoice_Defaults___,
--  090930           Email_Sales_Quotation__, Get_Total_Tax_Amount and Finite_State_Init___.
--  ------------------------- 14.0.0 -----------------------------------------
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  100308  Kisalk   Modified Get_Tot_Charge_Sale_Tax_Amt to compensate for SP5 merge with charge percentage.
--  100215  JuMalk   Bug 87879, Modified the way of calculating add_discount_amt_ in Get_Total_Add_Discount_Amount by getting the required values separately through the  
--  100215           cursor and calculate add_discount_amt_. 
--  091203  ChJalk   Bug 86009, Added procedure Modify_Wanted_Delivery_Date__ and function Updatable_Lines_Exist. 
--  091203           Also modified Unpack_Check_Insert___ and Unpack_Check_Update___ to handle CHANGE_LINE_DATE and PLANNED_DELIVERY_DATE.
--  091127  ChJalk   Bug 86871, Removed General_SYS.Init_Method from the function Get_Ship_Addr_No.
--  091120  ChJalk   Bug 86871, Removed General_SYS.Init_Method from the function Get_Latest_Quotation_No.
--  091120  ChJalk   Bug 86871, Removed General_SYS.Init_Method from the functions Get_Customer_Name and Quotation_Lines_Exist.
--  090922  AmPalk   Bug 70316, Modified Get_Total_Base_Charge__ to get the value from Order_Quotation_Charge_API.Get_Total_Base_Charged_Amount.
--  090922           Modified Get_Total_Sale_Price__ and Get_Total_Base_Price by calling order line's get total methods, hence the calculation will be in a cenralized place.
--  090922           Modified Get_Total_Tax_Amount to do currency conversion using Order_Quotation_Line_API.Get_Total_Tax_Amount_Curr.
--  090715  NiBalk   Bug 84730, Added columns cust_ref_name and text_id$ needed for Search Domain to ORDER_QUOTATION view.
--  090709  IrRalk   Bug 82835, Modified method Get_Total_Weight__ to round weight to 4 decimals.
--  090527  SuJalk   Bug 83173, Modified the NOTDOCADDR and NOTDELADDR error messages to have a full stop at the end in Unpack_Check_Update___. 
--  090316  SudJlk   Bug 80264, Modified Update___, Get_Quote_Defaults___ and Get_Delivery_Information to modify value setting for del_terms_location when a customer agreement exists.
--  081215  ChJalk   Bug 77014, In Get_Total_Base_Price and Get_Total_Base_Price, used sale_unit_price and currency_rate instead of base_sale_unit_price.
--  090624  KiSalk   Changed call Customer_Order_Pricing_API.Get_Valid_Price_List to Sales_Price_List_API.Get_Valid_Price_List.
--  090401  DaZase   Added parameters to call Customer_Order_Pricing_API.Get_Quote_Line_Price_Info.
--  090330  KiSalk   Modified Get_Total_Base_Charge__, Get_Total_Sale_Charge__ and Get_Tot_Charge_Sale_Tax_Amt to calculate values using charge percentage.
--  090119  DaZase   Added parameters to call Customer_Order_Pricing_API.Get_Valid_Price_List inside method Update___.
--  080911  MaJalk   Added zone_definition_id_ and zone_id_ to method calls at Unpack_Check_Update___, 
--  080911           Udate___, Get_Quote_Defaults___ and Get_Delivery_Information.
--  080701  MaJalk   Merged APP75 SP2.
--  --------------------- APP75 SP2 Merge - End --------------------------------
--  080514  ChJalk   Bug 73615, Modified Get_Total_Tax_Amount to return the correct tax total when the conversion factor is > 1.
--  080423  MaRalk   Bug 72472, Modified the prompt of the view ORDER_QUOTATION as Sales Quotation. 
--  080307  NaLrlk   Bug 69626, Increased the length of the cust_ref column to 30. Removed the substr function call for cust_ref within function Get_Quote_Defaults___.
--  080227  ThAylk   Bug 71246, Added Function Get_Jinsui_Invoice_Db and modified method Validate_Jinsui_Constraints___.
--  --------------------- APP75 SP2 Merge - Start ------------------------------
--  080609  JeLise   Added rebate_customer in Create_Order_Head.
--  080605  JeLise   Added rebate_customer.
--  080318  KiSalk   Added attribute classification_standard and method Get_Classification_Standard.
--  080313  MaJalk   Merged APP 75 SP1.
--  --------------------------- APP 75 SP1 merge - End -------------------------
--  080207  NaLrlk   Bug 70005, Modified del_terms_location value in method Update___ and Get_Delivery_Information.
--  080206  ThAylk   Bug 70627, Added column JINSUI_INVOICE, Functions Get_Jinsui_Invoice, Get_Jinsui_Invoice_Defaults___
--  080206           and Procedure Validate_Jinsui_Constraints___.
--  080205  NaLrlk   Bug 70005, Added DEL_TERMS_LOCATION to Msg in Get_Packed_Customer_Data.
--  080201  PrPrlk   Bug 70382, Modified the method Update___ to call Order_Quotation_Charge_API.Add_Tax_Lines that will correctly fetch the tax codes when the delivery address is changed.
--  080201  ChJalk   Bug 70889, Removed Function Validate_Email__.
--  080130  NaLrlk   Bug 70005, Added public attribute del_terms_location and Modified the methods Get_Quote_Defaults___,
--  080130           Get_Delivery_Information and Create_Order_Head with del_terms_location attribute.
--  071218  MaJalk   Bug 69814, Changed methods Email_Sales_Quotation and Validate_Email as private.
--  071213  MaJalk   Bug 69814, Added new procedure Email_Sales_Quotation to send email to customer contact email address
--  071213           with attached pdf file for customer order sales quotation and added new method Validate_Email.
--  071210  MaRalk   Bug 66201, Modified functions Get_Total_Weight__ and Get_Total_Qty__ to return NULL as well.
--  --------------------------- APP 75 SP1 merge - Start -----------------------
--  080228  MaJalk   Changed validation method for contract_ at Validate_Customer_Agreement___.
--  080216  AmPalk   In Update___ modified method call to Get_Quote_Line_Price_Info receiving net_price_fetched value and inserted it to the Quotation Line.
--  -------------------------------- Nice Price --------------------------------
--  070910  JaBalk   Correceted the error message CANTCREATECO not to consider the charge lines
--  070904  JaBalk   Added an error message CANTCREATECO if no lines exists to create a customer order
--  070831  JaBalk   Raised an error message in Create_Order_Head when creating the customer order
--  070831           if the order quotation is cancelled/closed
--  070831  JaBalk   Raised an error message in Create_Order, Set_Lose_Reason when creating the customer order
--  070831           or lose the quotation if the order quotation is cancelled/closed
--  070516  AmPalk   Added parameter info_ to the procure Create_Order.
--  070507  MaMalk   Bug 64958, Modified Get_Quote_Defaults___ to correct some coding errors.
--  070223  MaMalk   Bug 63364, Modified Get_Quote_Defaults___ and removed the default value of VAT_DB in Prepare_Insert___.
--  070122  Cpeilk   Removed attributes ship_via_desc and delivery_terms_desc.
--  070118  SuSalk   Modified Mpccom_Ship_Via_API.Get_Description method calls.
--  060728  ChJalk   Replaced Mpccom_Ship_Via_Desc and Order_Delivery_Term_Desc with Mpccom_Ship_Via and Order_Delivery_Term.
--  060725  KaDilk   Made ShipViaCodeDesc and OrderDeliveryTermDesc Language independant.
--  060530  KanGlk   Modified Insert___ - Renamed method call Customer_Order_Charge_API  Add_Customer_Charge to Copy_From_Customer_Charge.
--  060517  MiErlk   Enlarge Identity - Changed view comment
--  060516  MiErlk   Enlarge Identity - Changed view comment
--  060503  KanGlk   Modified procedure Create_Order_Head.
--  060503  KanGlk   Modified Insert___ to add default customer charges.
--  060419  NaLrlk   Enlarge Customer - Changed variable definitions.
--  060418  IsWilk   Enlarge Identity - Changed view comments of customer_no, customer_no_pay.
--  ----------------------------13.4.0------------------------------------------
--  060315  MaRalk   Bug 56401, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to avoid receiving the NOTVATFREEVAT info message unnecessary times.
--  060306  MaHplk   Added CUSTOMER_NO_PAY & CUSTOMER_NO_PAY_ADDR_NO values to attr_ in Create_Order_Head function.
--  060221  MiKulk   Modified the conditions to raise the error for the non existing vat free vat code. Manual merge of 51197.
--  060220  JaBalk   Added NOSHIPORBILLADDR to Unpack_Check_Insert___ and Unpack_Check_Update___.
--  060102  ShKolk   Bug 55290, Modified info messages in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  051208  ThGulk   Bug 54659, Modified method Update__, Added code to update Customer_No.
--  051121  MaJalk   Bug 54342, Modified functions Get_Total_Base_Price and Get_Total_Sale_Price__ .
--  051021  IsWilk   Removed the attribute delivery_type.
--  051010  ChJalk   Bug 53767, Modified Procedure Update___ to create a new revision when the Additional Discount is modified.
--  051006  IsWilk   Added the PROCEDURE Cancel_Lines.
--  051004  IsWilk   Added the PROCEDURE Set_Cancel_Reason.
--  051004  IsWilk   Added the public attribute cancel_reason.
--  051003  Cpeilk   Bug 53468, Modified Unpack_Check_Update___ to raise error messages only when document or delivery address gets modified.
--  050929  KeFelk   Removed red codes in the cat.
--  050926  IsAnlk   Added customer_no as parameter to Customer_Order_Pricing_API.Get_Base_Price_In_Currency call.
--  050921  IsAnlk   Modified Get_Packed_Customer_Data to add ean_location to the message.
--  050920  NaLrlk   Removed unused variables.
--  050714  HaPulk   Removed Hint '--+INDEX(ORDER_QUOTATION_LINE_TAB ORDER_QUOTATION_LINE_PK)' in Get_Next_Line_No.
--  050628  ToBeSe   Bug 52000, Modified Cancel_Lines___ to include lines in state Planned.
--  050622  PrPrlk   Bug 51052, Made changes in methods Unpack_Check_Insert___ , Unpack_Check_Update___ and Get_Quote_Defaults___ to handle PAY_TERM_ID when changing customers.
--  050614  ChJalk   Bug 51640, Modified the FUNCTION Get_Total_Cost__ to avoid considering cost of component parts.
--  050207  NaLrLk   Removed the public cursor get_order_demand.
--  050113  JICE     Added methods Get_Total_Contribution__ and Get_Total_Cost__.
--  041210  IsAnlk   Modified procedure Update___ to set tax codes correctly.
--  041207  ErFelk   Bug 48361, Modified Get_Packed_Customer_Data by restructuring the loop for getting the next identity for the customer.
--  041018  NuFilk   Added Get_Tot_Charge_Sale_Tax_Amt.
--  041014  KeFelk   Added Get_Total_Tax_Amount and Get_Gross_Amount.
--  040909  MaMalk   Bug 46595, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to raise error messages for invalid addresses.
--  040722  MaJalk   Bug 45623, Removed the null check of DELIVERY_LEADTIME from While Loop in Unpack_Check_Insert___ and
--                   add it after the while loop.
--  040722  KeFelk   Changed Get_Quote_Defaults___ regarding CUST_REF.
--  040713  NiRulk   Bug 36368, Modified the PROCEDURE Unpack_Check_Update___ to allow editing the Lose Win Note
--  040713           even after the Quotation is closed.
--  040614  WaJalk   Modified method Get_Quote_Defaults___ to fetch customer contact to CUST_REF.
--  040609  NiRulk   Bug 43785, Modified procedures Unpack_Check_Insert___ and Unpack_Check_Update___.
--  040511  JaJalk   Corrected the lead time lables.
--  040506  DaRulk   Renamed 'Delivery Date' to 'Wanted Delivery Date'
--  040426  MaMalk   Bug 37374, Modified the procedure Update___.
--  ----------------------------13.3.0------------------------------------------
--  040311  WaJalk   Bug 41397, Changed procedure Update___ to fetch correct ship via code and leadtime.
--  040226  AsAwlk   Bug 33864, Added new revision creation info message in procedure New_Revision___.
--  040226           Modified the NVL for oldrec_.wanted_delivery_date in Update___.
--  040224  IsWilk   Removed the SUBSTRB from the view for Unicode Changes.
--  041213  SeKalk   Bug 41397, Added a NVL function to  delivery leadtime in procedure Update___.
--  040212  WaJalk   Bug 42373, Modified procedure Update___ in order to pass condition code for price calculations.
--  040210  KaDilk   Bug 40378, Modified the function Create_Order_Head and Unpack_Check_Update___.
--  040126  SeKalk   Bug 41397, Modified the procedure Update___.
--  040105  SuAmlk   Bug 40740, Added attributes Customer_No_Pay and Customer_No_Pay_Addr_No and modified PROCEDURE Get_Quote_Defaults___
--  040105           and Create_Order_Head to consider payer information in sales quotations.
--  031013  PrJalk   Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  030917  JoEd     Restructured the code for retrieval of ship_via_code and delivery_leadtime.
--                   Removed info message previously created when no leadtimes were found.
--  030904  SaNalk   Set the zero value for Additional Discount when it is NULL in procedure Unpack_Check_Update___.
--  030818  SaNalk   Performed CR Merge.
--  030716  NaWalk   Removed Bug coments.
--  030505  DaZa     All occurences of acquisition type/mode changed to supply code.
--  030423  NuFilk   Modified method Unpack_Check_Update___ and Get_Quote_Defaults____ get delivery_leadtime correctly.
--  ************************* CR Merge *******************************************
--  030729  AjShlk   Merged bug fixes in 2002-3 SP4
--  030423  ChFolk   Modified parameters of Order_Quotation_Charge_API.Add_All_Tax_Lines in procedure Update___.
--  030411  ChFolk   Modified PROCEDURE Update___ to modify Add/Remove charge tax lines when change of delivery address or Pay tax.
--  030401  MiKulk   Bug 36368, Modified the PROCEDURE Unpack_Check_Update___ to allow editing the Lose Win Note
--  030401           even after the Quotation is closed and also increased the length of the Lose Win Note.
--  030328  ChFolk   Modified PROCEDURE Update___ to Add/Remove charge tax lines when change of delivery address or Pay tax.
--  030217  UdGnlk   TSO Merge. (From Take Off changes To Salsa)
--  030217  UdGnlk   Bug Fix 19140 corrected by removing public function Get_Cust_Ref.
--  030210  BhRalk   Bug 35764, Modified Methods Get_Allowed_Operations__  and Finite_State_Machine___.
--  030206  PrTilk   Bug 35314, Modified the cursor get_lines in the PROCEDURE Create_Order___. Added
--  030206           the ABS function to select the line numbers in ascending order.
--  021017  JoAnSe   Changed Get_Allowed_Operations__, changes made for Create Order and
--                   Lost Quotation.
--  --------------------------TSO Merge -----------------------------------------
--  030101  SaNalk   Merged SP3.
--  021210  SaNalk   Modified Cursors in functions Get_Total_Base_Price,Get_Total_Sale_Price__ & Get_Total_Add_Discount_Amount
--                   Added the function Quotation_Lines_Exist.Added a check in procedure Unpack_Check_Update___ to modify additional
--                   discount in quotation line when additional discount disocunt is changed in quotation header.
--  021122  RaSilk   Bug 34289, Modified the correction of Bug 29409.
--  021121  SaNalk   Added a check in procedure Unpack_Check_Insert___ for NULL value of additoinal discount.
--  021120  SaNalk   Modified the cursor get_add_disc_amt in function Get_Total_Add_Discount_Amount.
--  021118  SaNalk   Changed the functions Get_Total_Sale_Price__,Get_Total_Base_Price to include additional discount amount
--                   in calculatons.Modified the function Get_Total_Add_Discount_Amount.Added a check in procedure Unpack_Check_Update___
--                   for NULL value of additoinal discount.
--  021115  SaNalk   Added the description of functions Get_Total_Add_Discount_Amount and Get_Additional_Discount.
--  021113  NaMolk   Removed Red codes.
--  021108  SaNalk   Added Additional Discount to Proc: Create_Order_Head.
--  021107  SaNalk   Added a check in Proc: Unpack_Check_Update___ for line discount totals.
--  021107  SaNalk   Added an Error Message in PROCEDURE Calculate_Line_Disc___, when total order discount is greater than 100%.
--  021106  SaNalk   Added the function Get_Total_Add_Discount_Amount.
--  021106  CaRase   Bug 33864, Added SHIP_ADDR_NO, WANTED_DELIVERY_DATE, SALESMAN_CODE in Procedure Update___. Added NVL function
--                   for oldrec.expiration_date, authorize_code,wanted_deliver_date. Removed DELIVERY_TYPE
--  021104  SaNalk   Added the function Get_Additional_Discount.Added Coding to Handle Additional_Discount in
--                   proc: Prepare_Insert___,Unpack_Check_Update___ and Unpack_Check_Insert___.
--  020828  SaRalk   Bug 32349, Roll back of correction made in bug 29485.
--  020812  GaJalk   Bug 29409, Modified procedure Create_Order_Head.
--  020807  SaRalk   Bug 29485, Modified procedures Get_Customer_Defaults__ and Set_Customer_No.
--  020624  JOHESE   Bug 29318, Added county to return parameter in Get_Packed_Customer_Data
--  020620  ErFi     Added Find_External_Ref_Quote, Set_Cancelled, Get_State
--  020523  KiSalk   Bug 29076, Modified PROCEDURE Create_Order___
--  020313  ROALUS   Call 74399 Get_Customer_Name modified to make customer name visible.
--  020222  NaWalk   Bug fix 27451, Added Parameter check_status to the Procedure 'Create Order'
--  020103  KiSalk   Bug 26847, Added Contract to attribute string in 'Set_Customer_No'
--  020102  MKrase   Bug 27117, Added 'trunc' on Site-date in FUNCTION Get_Allowed_Operations__ and PROCEDURE Create_Order.
--  011211  MGUO     Bug fix 26565, Put a check in Create_Order_Head to avoid null value of ship_addr_no.
--  011210  MGUO     Bug fix 26556, Check the existent of contract in Get_Quote_Defaults___.
--  011003  JoEd     Bug 23827. Removed default value for language_code.
--  010920  JoEd     Bug 23827. Added default value for language_code in Prepare_Insert___.
--                   Added default value from Party_Identity_Series in Get_Packed_Customer_Data.
--  010725  OsAllk   Bug Fix 20156, Added Language_SYS.Translate_Constant(lu_name_,'NEWQUOTE:New Quotation') before calling
--                   Order_Quotation_History_Api.New;
--  010716  SaNalk   Bug Fix 19140, Reversed the previous correction.Removed the public function Get_Cust_Ref.
--  010622  ViPalk   Bug fix 22076, In Update___ procedure added nvl when comparing the ship_addr_no and the delivery_terms.
--  010528  JSAnse   Bug Fix 21463, Added call to  General_SYS.Init_Method for procedures Get_Latest_Quotation_No and Find_External_Ref_Quote.
--  010522  JSAnse   Bug Fix 21592, Removed Client_SYS.Attr_To_Dbms_Output from Procedure CreateOrderLine
--  010511  JaBa     Bug Fix 19140, Added a  public function Get_Cust_Ref.
--  010510  JSAnse   Bug fix 20175, Added "AND   CTP_PLANNED = 'N'" in Cursor get_order_demand.
--  010315  SoPrus   Bug fix 19539, Modified cursor Get_Order_Demand for MRP.
--  010219  RoAnse   Bug fix 19070, Modified PROCEDURE Set_Customer_No, adding DELIVERY_LEADTIME to attr_.
--  010213  RoAnse   Bug fix 19065, Added procedure Close__, modified procedure Finite_State_Machine___.
--  010129  JoEd     Bug fix 19077. Added check on Lost and Won status in
--                   Get_Allowed_Operations__.
--  010104  JoEd     Added check on update_from_wizard_ variable in call to state
--                   machine while processing method Set_Customer_No.
--  010103  MaGu     Added check on agreement_id in method Create_Order_Head. Agreement id is only copied to the
--                   customer order if the agreement is valid on current site date. This is to prevent error when
--                   creating order head.
--  001222  MaGu     Changed validation of customer agreement on quotation header so that only agreements that
--                   are valid on site date can be used as default agreement. This is done to match rules when creating
--                   an order header from quotation. Changed methods Unpack_Check_Insert, Unpack_Check_Update___ and
--                   Validate_Customer_Agreement__.
--  001218  JoEd     Added package variable updated_from_wizard_ to avoid
--                   setting quotation line status to Revised when processing the
--                   method Set_Customer_No.
--  001214  DaZa     Added fix in Get_Quote_Defaults___ so contract_ is fetched correctly from attr_.
--  001213  MaGu     Added fetch of new default price list when updating price effectivity date in method Update___.
--  001206  MaGu     Added recalculation of price and discount on quotation lines when agreement or
--                   or price effectivity date is changed. Added in method Update___.
--  001205  MaGu     Added new parameter effective date to method Validate_Customer_Agreement___.
--  001127  DaZa     Added new field Print_Control_Code.
--  001122  JoAn     CID 54445 Corrected Modify_Printed_Flag.
--  001120  JoEd     Changed Modify_Quote_Defaults__ conditions.
--  001120  CaSt     Ship_addr_no was not in the right place in function Get.
--  001116  JoEd     Added history message CONVERTED_ORDER in Create_Order_Head.
--                   Also added the created order number back to the client in
--                   method Create_Order___.
--  001115  CaSt     Cleanup. Removed procedures and functions that were not used.
--  001115  CaSt     Added logic to Validate_Customer_Agreement___, Check_Delivery_Type__, Check_Payment_Term__,
--                   Get_Delivery_Information, Get_Delivery_Time.
--  001114  CaSt     Added new attribute CALC_DISC_FLAG to ORDER_QUOTATION_TAB.
--  001113  CaSt     Adjustments in Calculate_Discount__ and Calculate_Line_Disc___.
--  001109  CaSt     Added logic to Calculate_Discount__ and Calculate_Line_Disc___.
--  001031  CaSt     Modified Get_Quote_Defaults___. When a customer order is created from the quotation,
--                   a customer is created from Create Customer Wizard. Customer data must be fetched to the quotation.
--  001023  CaSt     Modified can_close_ value in Get_Allowed_Operations__.
--  001020  CaSt     Added procedure Close_Quotation__.
--  001009  FBen     Added decode to QUOTATION_CUSTOMER_TYPE in prepare_insert___. (CID 47857)
--  001003  FBen     Added bill_addr_no and ship_addr_no to procedure Create_Order_Head. (CID 47869)
--  001002  CaSt     Added cust_ref to Get_Packed_Customer_Data.
--  000929  CaSt     Changed Get_Packed_Address to Get_Packed_Customer_Data. Added customer data attributes
--                   in Get_Packed_Customer_Data.
--  000913  FBen     Added UNDEFINE.
--  000908  CaSt     Changed comment on lost_to and reason_id to uppercase.
--  000907  CARA     Added Check_Acquisition.
--  000712  LUDI     Merged from Chameleon
--  --------------   -----------------------------------------------------------
--  000810  FBen     Modified quotation_customer_type in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  000609  GBO      Add logic for testing that lines have a configuration in Release_Lines___
--  000607  GBO      Modify order of parameter for call of Order_Quotation_API.New
--                   Added Find_External_Ref_Quote
--  000607  GBO      Added procedure New
--  000605  GBO      Added Get_Latest_Quotation_No
--                   Added view QUOTATION_PER_VIEW_LOV
--  000525  GBO      Added logic for releasing created customer orders
--  000523  LIN      Added logic for price recalculation
--  000518  LIN      Added price_effectivity_date in GET function
--  000518  GBO      Corrected bug with history when creating a new quotation
--  000518  JakH     Added public cursor for get_order_demand for mrp
--  000517  GBO      Added Get_Printed_Db
--  000515  GBO      Correct bug with printed flag setting. Added test on expiration_date
--  000511  GBO      Added Get_Quotation_Date, remove infinite loop when calling QuotationChanged, Transfer_Charge_To_Order
--                   from OrderQuotationLine
--  000510  GBO      Removed reminder_date
--  000504  GBO      Added logic for creating order lines
--  000503  GBO      Added Modify_Printed_Flag
--  000502  GBO      Added Quotation_Changed
--  000427  GBO      Added CustomerName
--  000426  GBO      Added state logic
--  000418  GBO      Added Get_Allowed_Operations__
--  000417  GBO      Added reason_id
--  000416  JakH     Added Get_Vat_Db
--  000413  GBO      Added Get_Next_Line_No
--  000412  GBO      Manage correctly LogEvent, added default delivery leadtime for prospect in
--                   Get_Quote_Defaults___. Add logic for customer_no and prospect
--  000411  GBO      Add bill_addr_no and ship_addr_no, vat, quotation_customer_type, revision_no fields
--                   Define TRUE and FALSE
--                   Add logic to unpack_check_insert___, insert___,
--                   unpack_check_update___, update___ from CustomerOrder
--                   Modify Construct_Delivery_Time___
--  000410  GBO      Add default values in Prepare_Insert__,
--                   Get_Quote_Defaults___ and salesman_code field
--  000406  JakH     Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Calculated_Totals_Rec IS RECORD (
   quotation_total_base_       NUMBER,
   quotation_total_            NUMBER,
   tax_amount_                 NUMBER,
   gross_amount_               NUMBER,
   additional_discount_amount_ NUMBER,
   quotation_weight_           NUMBER,
   quotation_volume_           NUMBER,
   total_contribution_amount_  NUMBER,
   total_cost_amount_          NUMBER,
   total_charge_base_          NUMBER,
   total_charge_               NUMBER,
   total_charge_gross_         NUMBER,
   total_cha_tax_              NUMBER,
   total_contribution_percent_ NUMBER,
   total_base_amt_             NUMBER,
   total_amt_                  NUMBER,
   toatal_tax_amt_             NUMBER,
   total_gross_amt_            NUMBER   
   );
TYPE Calculated_Totals_Arr IS TABLE OF Calculated_Totals_Rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_                  CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

db_true_                      CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;

db_false_                     CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;

state_separator_              CONSTANT VARCHAR2(1)  := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Calculate___ (
   rec_  IN OUT ORDER_QUOTATION_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Calculate_Discount__(rec_.quotation_no);
   Customer_Order_Charge_Util_API.Calc_Consolidate_Charges(NULL, rec_.quotation_no);
   Sales_Promotion_Util_API.Calculate_Quote_Promotion(rec_.quotation_no);
   IF (Sales_Promotion_Util_API.Check_Unutilized_Q_Deals_Exist(rec_.quotation_no) = 'TRUE') THEN 
      Client_SYS.Add_Info(lu_name_, 'UNUTILQPROMO: Unutilized sales promotion deal(s) exist, can be analyzed via operations menu Calculate and View Sales Promotions.');
   END IF;
END Calculate___;  

PROCEDURE Won_Lines___ (
   rec_  IN OUT order_quotation_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
   newrec_      ORDER_QUOTATION_TAB%ROWTYPE;
   oldrec_      ORDER_QUOTATION_TAB%ROWTYPE;
   info_        VARCHAR2(32000);
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no
        FROM ORDER_QUOTATION_LINE_TAB
       WHERE rowstate = 'Released'
         AND line_item_no <= 0
         AND quotation_no = rec_.quotation_no
       ORDER BY ABS(line_no), rel_no;
   
   reason_id_ ORDER_QUOTATION_LINE_TAB.reason_id%TYPE;
   won_note_  ORDER_QUOTATION_LINE_TAB.lose_win_note%TYPE;
BEGIN
   -- Update quotation header
   oldrec_    := Lock_By_Keys___( rec_.quotation_no );
   newrec_    := oldrec_;
   reason_id_ := Client_SYS.Get_Item_Value('REASON_ID', attr_ );
   won_note_  := Client_SYS.Get_Item_Value('LOSE_WIN_REJECT_NOTE', attr_ );
   
   Client_SYS.Add_To_Attr('CLOSED_STATUS_DB', 'WON', attr_ );
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___( objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   
   --Update quotation lines
   FOR linerec_ IN get_lines LOOP
      Order_Quotation_Line_API.Set_Quotation_Line_Won__( info_, rec_.quotation_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, reason_id_, won_note_);
   END LOOP;
   
END Won_Lines___;

PROCEDURE Set_Close_Info___(
   rec_  IN OUT order_quotation_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
   newrec_      ORDER_QUOTATION_TAB%ROWTYPE;
   oldrec_      ORDER_QUOTATION_TAB%ROWTYPE;
BEGIN
   oldrec_ := Lock_By_Keys___( rec_.quotation_no );
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___( objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   
   Remove_Intrm_Order_Resrv___(rec_.quotation_no);   
   
END Set_Close_Info___;

-- Calculate_Line_Disc___
--   Calculate quotation_discount for all quotation lines for the specified
--   quotation. Updates OrderQuotationLine.
PROCEDURE Calculate_Line_Disc___ (
   quotation_no_ IN VARCHAR2 )
IS
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no, catalog_no, contract,
             buy_qty_due, price_conv_factor, discount, currency_rate, sale_unit_price, unit_price_incl_tax,
             price_freeze, quotation_discount,rental
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_item_no <= 0
      AND    rowstate NOT IN ('Cancelled', 'Lost');
   
   quotation_discount_     NUMBER;
   discount_code_          VARCHAR2(20);
   quotation_rec_          ORDER_QUOTATION_TAB%ROWTYPE;
   company_                VARCHAR2(20);
   rounding_               NUMBER;
   quotation_total_value_  NUMBER;
   total_base_price_       NUMBER := 0;
   sales_part_rec_         Sales_Part_API.Public_Rec;
   additional_discount_    NUMBER;
   total_order_discount_   NUMBER;
   line_discount_          NUMBER;
   order_price_            NUMBER := 0;
   curr_rounding_          NUMBER;
   discount_freeze_db_     VARCHAR2(5);
   rental_chargeable_days_ NUMBER; 
   line_source_key_arr_    Tax_Handling_Util_API.source_key_arr;
   tax_method_             VARCHAR2(50);
   update_tax_at_line_     BOOLEAN := TRUE;
   i_                      NUMBER := 0;
BEGIN
   quotation_rec_      := Get_Object_By_Keys___(quotation_no_);
   company_            := Site_API.Get_Company(quotation_rec_.contract);
   rounding_           := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   discount_freeze_db_ := Site_Discom_Info_API.Get_Discount_Freeze_Db(quotation_rec_.contract);
   curr_rounding_      := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   tax_method_         := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);
   
   IF tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX THEN
      update_tax_at_line_ := FALSE;
   END IF; 
   
   -- Retrieve the total value for the quotation not considering the quotation discounts
   FOR rec_ IN get_lines LOOP
      line_discount_ := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no,
                                                                              rec_.buy_qty_due, rec_.price_conv_factor, curr_rounding_);
      
      rental_chargeable_days_ := Order_Quotation_Line_API.Get_Rental_Chargeable_Days(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      
      IF (quotation_rec_.use_price_incl_tax = Fnd_Boolean_API.DB_TRUE) THEN
         order_price_ := ROUND((rec_.buy_qty_due * rec_.price_conv_factor * rec_.unit_price_incl_tax * rental_chargeable_days_), curr_rounding_) - line_discount_;
      ELSE
         order_price_ := ROUND((rec_.buy_qty_due * rec_.price_conv_factor * rec_.sale_unit_price * rental_chargeable_days_), curr_rounding_) - line_discount_;
      END IF;
      
      total_base_price_ := total_base_price_ + ROUND(order_price_ * rec_.currency_rate, rounding_);
   END LOOP;
   
   FOR next_line_ IN get_lines LOOP
      -- Calculate order discount
      discount_code_      := NULL;
      quotation_discount_ := 0;
      sales_part_rec_     := Sales_Part_API.Get(next_line_.contract, next_line_.catalog_no);
      IF (sales_part_rec_.discount_group IS NOT NULL) THEN
         discount_code_ := Discount_Basis_Code_API.Encode(Sales_Discount_Group_API.Get_Discount_Code(sales_part_rec_.discount_group));
         IF (discount_code_ IS NOT NULL) THEN
            IF (discount_code_ = 'V') THEN
               quotation_total_value_ := total_base_price_;
            ELSIF (discount_code_ = 'W') THEN
               quotation_total_value_ := Get_Total_Weight__(quotation_no_);
            ELSE
               quotation_total_value_ := Get_Total_Qty__(quotation_no_);
            END IF;
            quotation_discount_   := Sales_Discount_Group_API.Get_Amount_Discount(sales_part_rec_.discount_group, quotation_total_value_, discount_code_, quotation_rec_.use_price_incl_tax);
            --Check that total order discount is not greater than 100 %.
            additional_discount_  := Get_Additional_Discount(quotation_no_);
            total_order_discount_ := quotation_discount_ + additional_discount_;
            IF total_order_discount_ > 100 THEN
               Error_SYS.Record_General(lu_name_, 'DISCOUNTEXCEED: Total Order Discount should not exceed 100% in line (Line No :P1, Del No :P2)', next_line_.line_no,next_line_.rel_no );
            END IF;
         END IF;
      END IF;
      -- Update the quotation_discount attribute in OrderQuotationLine
      IF NOT(next_line_.price_freeze = 'FROZEN' AND discount_freeze_db_ = 'TRUE') THEN
         -- Check whether there is a change in the discount.
         IF (next_line_.quotation_discount != quotation_discount_) THEN
            Order_Quotation_Line_API.Modify_Quotation_Discount(quotation_no_, next_line_.line_no, next_line_.rel_no, next_line_.line_item_no, quotation_discount_, update_tax_at_line_);
            
            IF NOT update_tax_at_line_ THEN
               i_ :=  i_ + 1;
               line_source_key_arr_(i_) := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                                                       quotation_no_, 
                                                                                       next_line_.line_no, 
                                                                                       next_line_.rel_no, 
                                                                                       next_line_.line_item_no, 
                                                                                       '*',                                                                  
                                                                                       attr_ => NULL);
            END IF;
         END IF;   
      END IF;
   END LOOP;
   
   IF i_ > 0 THEN
      IF line_source_key_arr_.COUNT >= 1 THEN 
      Tax_Handling_Order_Util_API.Fetch_External_Tax_Info(line_source_key_arr_,
                                                          company_);
   END IF;                                                    
   
   Order_Quotation_History_Api.New(quotation_no_, Language_Sys.Translate_Constant(lu_name_,'EXTAXBUNDLECALL: External Taxes Updated'));
   END IF;
END Calculate_Line_Disc___;


-- Construct_Delivery_Time___
--   Add the default delivery time if any to the delivery date if no time
--   (ie 00.00.00) has been specified for the delivery date.
FUNCTION Construct_Delivery_Time___ (
   delivery_date_ IN DATE,
   customer_no_   IN VARCHAR2,
   ship_addr_no_  IN VARCHAR2 ) RETURN DATE
IS
   time_      DATE;
   timestamp_ VARCHAR2(20);
BEGIN
   IF (delivery_date_ IS NULL) THEN
      RETURN NULL;
      -- IF midnight, the time "hasn't been entered". Retreive default delivery time from customer's delivery address.
   ELSIF (to_char(delivery_date_, 'HH24:MI') = '00:00') THEN
      timestamp_ := to_char(trunc(delivery_date_), Report_SYS.datetime_format_);
      -- single occurence addresses doesn't have a delivery time      
      time_ := Cust_Ord_Customer_Address_API.Get_Delivery_Time(customer_no_, ship_addr_no_);
      IF ((time_ IS NOT NULL) AND (to_char(time_, 'HH24:MI') != '00:00')) THEN
         -- replace with the address's time - remove the seconds in case the user has entered them.
         timestamp_ := replace(timestamp_, '00:00:00', to_char(time_, 'HH24:MI') || ':00');         
      END IF;
   ELSE
      timestamp_ := to_char(delivery_date_, Report_SYS.datetime_format_);
   END IF;
   RETURN to_date(timestamp_, Report_SYS.datetime_format_);
END Construct_Delivery_Time___;


-- Get_Quote_Defaults___
--   Attaches all defaults needed to the attr_-string after the parameter
--   customer_no has been typed.
PROCEDURE Get_Quote_Defaults___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_                  ORDER_QUOTATION_TAB.contract%TYPE;
   customer_no_               ORDER_QUOTATION_TAB.customer_no%TYPE;
   company_                   ORDER_QUOTATION_TAB.company%TYPE;
   pay_term_id_               ORDER_QUOTATION_TAB.pay_term_id%TYPE;
   ship_addr_no_              ORDER_QUOTATION_TAB.ship_addr_no%TYPE;
   addr_flag_                 VARCHAR2(1) := 'N';
   bill_addr_no_              ORDER_QUOTATION_TAB.bill_addr_no%TYPE;
   currency_code_             ORDER_QUOTATION_TAB.currency_code%TYPE;
   language_code_             ORDER_QUOTATION_TAB.language_code%TYPE;
   ship_via_code_             ORDER_QUOTATION_TAB.ship_via_code%TYPE;
   delivery_terms_            ORDER_QUOTATION_TAB.delivery_terms%TYPE;
   agreement_id_              ORDER_QUOTATION_TAB.agreement_id%TYPE;
   delivery_leadtime_         NUMBER := NULL;
   date_string_               VARCHAR2(25);
   wanted_delivery_date_      DATE;
   in_attr_                   VARCHAR2(32000);
   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);
   agreement_found_           BOOLEAN := FALSE;
   timestamp_                 VARCHAR2(20);
   customer_rec_              Cust_Ord_Customer_API.Public_Rec;
   address_rec_               Cust_Ord_Customer_Address_API.Public_Rec;
   customer_no_pay_           ORDER_QUOTATION_TAB.customer_no_pay%TYPE;
   customer_no_pay_addr_no_   ORDER_QUOTATION_TAB.customer_no_pay_addr_no%TYPE;
   tax_liability_             VARCHAR2(20);
   jinsui_invoice_            VARCHAR2(20);
   freight_map_id_            VARCHAR2(15);
   zone_id_                   VARCHAR2(15);
   agreement_rec_             Customer_Agreement_API.Public_Rec;
   del_terms_location_        VARCHAR2(100);
   supply_country_            ORDER_QUOTATION_TAB.supply_country%TYPE;
   forward_agent_id_          ORDER_QUOTATION_TAB.forward_agent_id%TYPE;
   leadtime_for_ship_via_     NUMBER;
   freight_price_list_no_     VARCHAR2(10);
   ext_transport_calendar_id_ VARCHAR2(10);
   customer_category_         CUSTOMER_INFO_TAB.customer_category%TYPE;   
   route_id_                   VARCHAR2(12);
   picking_leadtime_           NUMBER;
   shipment_type_              VARCHAR2(3);
   ship_inventory_location_no_ VARCHAR2(35);
   vendor_no_                  VARCHAR2(20);
   use_price_incl_tax_db_      ORDER_QUOTATION_TAB.use_price_incl_tax%TYPE;
   ship_addr_zip_code_         VARCHAR2(35);
   ship_addr_city_             VARCHAR2(35);
   ship_addr_state_            VARCHAR2(35);
   ship_addr_county_           VARCHAR2(35);
   ship_addr_country_code_     VARCHAR2(35);
   single_occ_addr_flag_       VARCHAR2(5);
   zone_info_exist_            VARCHAR2(5) := 'FALSE';
   b2b_order_                  VARCHAR2(5) := 'FALSE';
BEGIN
   -- Make a copy of the in parameter attribute string
   in_attr_ := attr_;
   
   Client_SYS.Set_Item_Value('CALC_DISC_FLAG', db_false_, attr_);
   
   contract_              := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   ship_via_code_         := Client_SYS.Get_Item_Value('SHIP_VIA_CODE', attr_);
   delivery_terms_        := Client_SYS.Get_Item_Value('DELIVERY_TERMS', attr_);
   del_terms_location_    := Client_SYS.Get_Item_Value('DEL_TERMS_LOCATION', attr_);
   Site_API.Exist(contract_);
   customer_no_           := Client_SYS.Get_Item_Value('CUSTOMER_NO', attr_);
   -- customer category
   customer_category_     := Customer_Info_API.Get_Customer_Category_Db(customer_no_);
   vendor_no_             := Client_SYS.Get_Item_Value('VENDOR_NO', attr_);
   use_price_incl_tax_db_ := NVL(Client_SYS.Get_Item_Value('USE_PRICE_INCL_TAX_DB', attr_),
                                 Fnd_Boolean_API.Encode(Client_SYS.Get_Item_Value('USE_PRICE_INCL_TAX', attr_)));   
   single_occ_addr_flag_  := Client_SYS.Get_Item_Value('SINGLE_OCC_ADDR_FLAG', attr_);
   ship_addr_zip_code_    := Client_SYS.Get_Item_Value('SHIP_ADDR_ZIP_CODE', attr_);
   ship_addr_city_        := Client_SYS.Get_Item_Value('SHIP_ADDR_CITY', attr_);
   ship_addr_state_       := Client_SYS.Get_Item_Value('SHIP_ADDR_STATE', attr_);
   ship_addr_county_      := Client_SYS.Get_Item_Value('SHIP_ADDR_COUNTY', attr_);
   ship_addr_country_code_ := Client_SYS.Get_Item_Value('SHIP_ADDR_COUNTRY_CODE', attr_);
   
   IF (customer_category_ = Customer_Category_API.DB_END_CUSTOMER) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDCUSTCATEGORY: Customer :P1 is not of category :P2 or :P3.', customer_no_, Customer_Category_API.Decode(Customer_Category_API.DB_CUSTOMER), Customer_Category_API.Decode(Customer_Category_API.DB_PROSPECT)); 
   END IF;
   
   -- In case it is a customer and not a prospect
   -- OR a prospect which is just about to turn into a customer (created from the Create Customer Wizard)
   
   -- Only check for customer type. For prospect order related information is optional.
   IF (customer_category_ = Customer_Category_API.DB_CUSTOMER) THEN
      Cust_Ord_Customer_API.Exist(customer_no_);
   END IF;
   
   -- Check if the ship address was passed in the attribute string.
   ship_addr_no_ := Client_SYS.Get_Item_Value('SHIP_ADDR_NO', attr_);
   
   -- IF no ship address was passed in retrive the default.
   IF (ship_addr_no_ IS NULL) THEN
      ship_addr_no_ := Cust_Ord_Customer_API.Get_Delivery_Address(customer_no_);
   END IF;
   
   customer_rec_    := Cust_Ord_Customer_API.Get(customer_no_);
   customer_no_pay_ := customer_rec_.customer_no_pay;
   
   IF (customer_no_pay_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('CUSTOMER_NO_PAY', customer_no_pay_, attr_);
      customer_no_pay_addr_no_ := Cust_Ord_Customer_API.Get_Document_Address(customer_no_pay_);
      IF (customer_no_pay_addr_no_ IS NULL) THEN
         -- This method will check for CRM Access for Paying Customer.
         Cust_Ord_Customer_API.Check_Access_For_Customer(customer_no_pay_, 'Paying Customer');
         Error_SYS.Record_General(lu_name_, 'NO_PAY_ADDR_NO: Paying customer :P1 has no document address with order specific attributes specified',
                                  customer_no_pay_);
      END IF;
      Client_SYS.Set_Item_Value('CUSTOMER_NO_PAY_ADDR_NO', customer_no_pay_addr_no_, attr_);
   END IF;
   
   language_code_ := Cust_Ord_Customer_API.Get_Language_Code(customer_no_);
   IF (bill_addr_no_ IS NULL) THEN
      bill_addr_no_ := Cust_Ord_Customer_API.Get_Document_Address(customer_no_);
   END IF;
   currency_code_ := customer_rec_.currency_code;
   address_rec_   := Cust_Ord_Customer_Address_API.Get(customer_no_, ship_addr_no_);
   
   Client_SYS.Set_Item_Value('LANGUAGE_CODE', language_code_, attr_);
   Client_SYS.Set_Item_Value('SALESMAN_CODE', customer_rec_.salesman_code, attr_);
   Client_SYS.Set_Item_Value('CUST_REF', Cust_Ord_Customer_API.Fetch_Cust_Ref(customer_no_, bill_addr_no_, 'TRUE'), attr_);
   Client_SYS.Set_Item_Value('MARKET_CODE', customer_rec_.market_code, attr_);
   Client_SYS.Set_Item_Value('PRINT_CONTROL_CODE', customer_rec_.print_control_code, attr_);
   Client_SYS.Set_Item_Value('BILL_ADDR_NO', bill_addr_no_, attr_);
   Client_SYS.Set_Item_Value('SHIP_ADDR_NO', ship_addr_no_, attr_);
   
   -- Get the default value for pay terms
   company_ := Site_API.Get_Company(contract_);
   Client_SYS.Set_Item_Value('COMPANY', company_, attr_);
   
   customer_no_pay_ := Client_SYS.Get_Item_Value('CUSTOMER_NO_PAY', attr_ );
   pay_term_id_     := Identity_Invoice_Info_API.Get_Pay_Term_Id(company_, NVL(customer_no_pay_, customer_no_), Party_Type_API.Decode('CUSTOMER'));
   
   -- Only consider pay terms for customer type
   IF (pay_term_id_ IS NULL AND customer_category_ = Customer_Category_API.DB_CUSTOMER) THEN
      Error_SYS.Record_General(lu_name_, 'NO_PAY_TERMS: Payment terms have not been defined for the paying customer :P1.',
                               NVL(customer_no_pay_, customer_no_));
   END IF;
   Client_SYS.Set_Item_Value('PAY_TERM_ID', pay_term_id_, attr_);
   
   supply_country_ := Iso_Country_API.Encode(Client_SYS.Get_Item_Value('SUPPLY_COUNTRY', attr_));  
   
   IF supply_country_ IS NULL THEN
      supply_country_ := Company_Site_API.Get_Country_Db(contract_);
      Client_SYS.Set_Item_Value('SUPPLY_COUNTRY', Iso_Country_API.Decode(supply_country_), attr_);       
   END IF;
   
   tax_liability_ := Tax_Handling_Util_API.Get_Customer_Tax_Liability(customer_no_, ship_addr_no_, company_, supply_country_);
   IF ( tax_liability_ IS NULL AND customer_category_ = Customer_Category_API.DB_PROSPECT ) THEN
      Client_SYS.Set_Item_Value('TAX_LIABILITY', 'EXEMPT', attr_);
   ELSE
      Client_SYS.Set_Item_Value('TAX_LIABILITY', tax_liability_, attr_);
   END IF;
   
   IF (ship_addr_no_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('COUNTRY_CODE', Cust_Ord_Customer_Address_API.Get_Country_Code(customer_no_, ship_addr_no_), attr_);
      Client_SYS.Set_Item_Value('REGION_CODE', address_rec_.region_code, attr_);
      Client_SYS.Set_Item_Value('DISTRICT_CODE', address_rec_.district_code, attr_);
   END IF;
   
   -- Get default value for agreement_id.
   currency_code_ := NVL(Client_SYS.Get_Item_Value('CURRENCY_CODE', attr_), currency_code_);
   Client_SYS.Set_Item_Value('CURRENCY_CODE', currency_code_, attr_ );
   -- IF agreement id is passed in the attribute string use that agreement id (even if the value passed is null)
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(in_attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'AGREEMENT_ID') THEN
         agreement_id_ := value_;
         agreement_found_ := TRUE;
      END IF;
   END LOOP;
   
   IF NOT agreement_found_ THEN
      agreement_id_ := Customer_Agreement_API.Get_First_Valid_Agreement(customer_no_, contract_, currency_code_, trunc(Site_API.Get_Site_Date(contract_)), 'FALSE');
      --Client_SYS.Add_To_Attr('AGREEMENT_ID', agreement_id_, attr_);
   END IF;
   IF (Customer_Agreement_API.Get_Use_By_Object_Head_Db(agreement_id_) = Fnd_Boolean_API.DB_FALSE) THEN
      agreement_id_    := NULL;
   END IF;
   Client_SYS.Set_Item_Value('AGREEMENT_ID', agreement_id_, attr_);
   
   IF (ship_via_code_ IS NULL) THEN                
      Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults(ship_via_code_, delivery_terms_, del_terms_location_, freight_map_id_, zone_id_,
                                                                  delivery_leadtime_, ext_transport_calendar_id_, 
                                                                  route_id_, forward_agent_id_, picking_leadtime_, shipment_type_,
                                                                  ship_inventory_location_no_, contract_, customer_no_, ship_addr_no_, addr_flag_, 
                                                                  agreement_id_, vendor_no_);
      
      Client_SYS.Set_Item_Value('SHIP_VIA_CODE', ship_via_code_, attr_);
      Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', delivery_leadtime_, attr_);
      Client_SYS.Set_Item_Value('EXT_TRANSPORT_CALENDAR_ID', ext_transport_calendar_id_, attr_);
   ELSE
      Cust_Order_Leadtime_Util_API.Fetch_Head_Delivery_Attributes(route_id_, 
                                                                  forward_agent_id_,
                                                                  leadtime_for_ship_via_,
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
                                                                  vendor_no_);
   END IF;
   
   Client_SYS.Set_Item_Value('PICKING_LEADTIME', picking_leadtime_, attr_);
   
   IF (single_occ_addr_flag_ = 'TRUE') THEN
      Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details(freight_map_id_,
                                                        zone_id_,
                                                        zone_info_exist_,
                                                        contract_,
                                                        ship_via_code_,
                                                        ship_addr_zip_code_,
                                                        ship_addr_city_,
                                                        ship_addr_county_,
                                                        ship_addr_state_,
                                                        ship_addr_country_code_);
   ELSIF (freight_map_id_ IS NULL) AND (zone_id_ IS NULL) THEN
      Freight_Zone_Util_API.Fetch_Zone_For_Cust_Addr(freight_map_id_,
                                                     zone_id_,
                                                     customer_no_,
                                                     ship_addr_no_,
                                                     contract_,
                                                     ship_via_code_);
   END IF;
   
   IF (freight_map_id_ IS NOT NULL AND zone_id_ IS NOT NULL) THEN
      IF use_price_incl_tax_db_ IS NULL THEN 
         use_price_incl_tax_db_ := Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(contract_);
      END IF ; 
      
      IF (vendor_no_ IS NOT NULL) THEN
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
   
   Client_SYS.Set_Item_Value('FREIGHT_MAP_ID', freight_map_id_, attr_);
   Client_SYS.Set_Item_Value('ZONE_ID', zone_id_, attr_);
   Client_SYS.Set_Item_Value('FREIGHT_PRICE_LIST_NO', freight_price_list_no_, attr_);
   
   IF (agreement_id_ IS NOT NULL) THEN
      agreement_rec_ := Customer_Agreement_API.Get(agreement_id_);
      
      -- IF the agreement has delivery terms get delivery_term and del_terms_location from agreement
      -- if not retrieve delivery term and location from Customer.
      IF (agreement_rec_.delivery_terms IS NOT NULL) THEN
         delivery_terms_     := agreement_rec_.delivery_terms;
         del_terms_location_ := agreement_rec_.del_terms_location;
      ELSE
         IF ( delivery_terms_ IS NULL ) THEN
            delivery_terms_     := address_rec_.delivery_terms;
            del_terms_location_ := address_rec_.del_terms_location;
         END IF;
      END IF;
   ELSE
      IF ( delivery_terms_ IS NULL ) THEN
         delivery_terms_     := address_rec_.delivery_terms;
         del_terms_location_ := address_rec_.del_terms_location;
      END IF;
   END IF;
   
   Client_SYS.Set_Item_Value('DELIVERY_TERMS', delivery_terms_, attr_);
   Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', del_terms_location_, attr_);
   
   IF (ship_addr_no_ IS NOT NULL) THEN
      -- Calculate wanted_delivery_date if not specified
      date_string_ := Client_SYS.Get_Item_Value('WANTED_DELIVERY_DATE', attr_);
      IF (date_string_ IS NOT NULL) THEN
         wanted_delivery_date_ := Client_SYS.Attr_Value_To_Date(date_string_);
      END IF;
      
      IF (delivery_terms_ IS NULL) THEN
         Client_SYS.Set_Item_Value('DELIVERY_TERMS', address_rec_.delivery_terms, attr_);
         Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', address_rec_.del_terms_location, attr_);
      END IF;
   ELSIF(customer_category_ = Customer_Category_API.DB_CUSTOMER) THEN
      Error_SYS.Record_General(lu_name_, 'NO_SHIP_ADDR: Customer :P1 has no delivery address with order specific attributes specified.', customer_no_);
   END IF;
   
   IF(Client_SYS.Get_Item_Value('DELIVERY_TERMS', in_attr_) IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', Client_SYS.Get_Item_Value('DEL_TERMS_LOCATION', in_attr_), attr_);
   END IF;
   
   -- calculate wanted delivery date's time using customer address's delivery time.
   timestamp_ := to_char(trunc(wanted_delivery_date_), Report_SYS.datetime_format_);
   IF ((address_rec_.delivery_time IS NOT NULL) AND (to_char(address_rec_.delivery_time, 'HH24:MI') != '00:00')) THEN
      -- replace with the address's time - remove the seconds.
      timestamp_ := replace(timestamp_, '00:00:00', to_char(address_rec_.delivery_time, 'HH24:MI') || ':00');
   END IF;
   Client_SYS.Set_Item_Value('WANTED_DELIVERY_DATE', to_date(timestamp_, Report_SYS.datetime_format_), attr_);
   jinsui_invoice_ := Client_SYS.Get_Item_Value('JINSUI_INVOICE_DB', attr_);
   IF (jinsui_invoice_ IS NULL) THEN
      --Get the default value for create jinsui info.
      jinsui_invoice_ := Get_Jinsui_Invoice_Defaults___(company_, customer_no_);
   END IF;
   Client_SYS.Set_Item_Value('JINSUI_INVOICE_DB', jinsui_invoice_, attr_);
   
   Client_SYS.Set_Item_Value('CLASSIFICATION_STANDARD', Assortment_Structure_API.Get_Classification_Standard(Customer_Assortment_Struct_API.Find_Default_Assortment(customer_no_)), attr_);
   
   Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', forward_agent_id_, attr_);  
   
   -- Make sure the attributes in the in parameter attribute string override the defaults
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(in_attr_, ptr_, name_, value_)) LOOP
      IF(value_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value(name_, value_, attr_);
      END IF;   
   END LOOP;    
   
   IF Client_SYS.Get_Item_Value('B2B_ORDER_DB', attr_) IS NULL THEN
      Client_SYS.Set_Item_Value('B2B_ORDER_DB', b2b_order_, attr_);  
   END IF;
END Get_Quote_Defaults___;


-- Validate_Customer_Agreement___
--   Contract, Customer_No and Currency_Code must have the same
--   values on the Order Quotation as on the Customer Agreement.
--   Works just like the Is_Valid method in CustomerAgreement.
PROCEDURE Validate_Customer_Agreement___ (
   agreement_id_  IN VARCHAR2,
   contract_      IN VARCHAR2,
   customer_no_   IN VARCHAR2,
   currency_code_ IN VARCHAR2 )
IS
   agreement_rec_ Customer_Agreement_API.Public_Rec;
   date_          DATE;
BEGIN
   IF (agreement_id_ IS NOT NULL) THEN
      agreement_rec_ := Customer_Agreement_API.Get(agreement_id_);
      date_          := TRUNC(Site_API.Get_Site_Date(contract_));
      
      IF NOT (Customer_Agreement_Site_API.Check_Exist(contract_, agreement_id_)) THEN
         Error_SYS.Record_General(lu_name_, 'NOTSAMECUST: Agreement :P1 is not valid for Customer :P2 and site :P3.', agreement_id_, customer_no_, contract_);
      ELSIF (agreement_rec_.customer_no != customer_no_) THEN
         IF Customer_Agreement_API.Validate_Hierarchy_Customer(agreement_id_, customer_no_) = 0 THEN
            Error_SYS.Record_General(lu_name_, 'NOTSAMECUST: Agreement :P1 is not valid for Customer :P2 and site :P3.', agreement_id_, customer_no_, contract_);
         END IF;   
      ELSIF (agreement_rec_.currency_code != currency_code_) THEN
         Error_SYS.Record_General(lu_name_, 'NOTSAMECURR: Invalid currency for the Agreement :P1.', agreement_id_);
      ELSIF (Customer_Agreement_API.Get_Objstate(agreement_id_) != 'Active') THEN
         Error_SYS.Record_General(lu_name_, 'NOTACTIVE: The Agreement :P1 is not Active!', agreement_id_);
      ELSIF (agreement_rec_.valid_from > date_) OR (NVL(agreement_rec_.valid_until, date_) < date_) THEN
         Error_SYS.Record_General(lu_name_, 'NOTVALIDDATE: The Agreement :P1 has an invalid date!', agreement_id_);
      END IF;
   END IF;
END Validate_Customer_Agreement___;

FUNCTION Can_Close___ (
   rec_ IN ORDER_QUOTATION_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   dummy_ NUMBER := 0;
   CURSOR check_lines( quotation_no_ IN VARCHAR2 ) IS
      SELECT 1
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE rowstate IN ('Planned')
      AND line_item_no <= 0
      AND quotation_no = quotation_no_;
BEGIN
   OPEN check_lines(rec_.quotation_no);
   FETCH check_lines INTO dummy_;
   IF (check_lines%NOTFOUND) THEN
      dummy_ :=0;
   END IF;
   CLOSE check_lines;
   IF ( dummy_ = 1 ) THEN
      RETURN FALSE;
   END IF;
   RETURN TRUE;
END Can_Close___;


FUNCTION Printed___ (
   rec_ IN ORDER_QUOTATION_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN (rec_.printed = 'PRINTED');
END Printed___;


PROCEDURE Cancel_Lines___ (
   rec_  IN OUT ORDER_QUOTATION_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE rowstate NOT IN ('Cancelled', 'Won', 'Lost', 'CO Created')
      AND line_item_no <= 0
      AND quotation_no = rec_.quotation_no;
BEGIN
   FOR linerec_ IN get_lines LOOP
      Order_Quotation_Line_API.Set_Cancelled( rec_.quotation_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, rec_.cancel_reason);
   END LOOP;
END Cancel_Lines___;


PROCEDURE Release_Lines___ (
   rec_  IN OUT ORDER_QUOTATION_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   company_                   VARCHAR2(20);
   external_tax_calc_method_  VARCHAR2(50);
   fetch_tax_on_line_entry_   VARCHAR2(5);
  
   CURSOR get_lines IS
      SELECT *
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE rowstate NOT IN ('Cancelled', 'Won', 'Lost', 'Released', 'CO Created')
      AND line_item_no <= 0
      AND quotation_no = rec_.quotation_no;
BEGIN
   FOR linerec_ IN get_lines LOOP
      -- Test that line has a configuration
      Order_Quotation_Line_API.Check_Base_Part_Config__( linerec_ );
      Order_Quotation_Line_API.Set_Released( linerec_.quotation_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
   END LOOP;
   
   company_                  := Site_API.Get_Company(Get_Contract(rec_.quotation_no)); 
   external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);
   fetch_tax_on_line_entry_  := Company_Tax_Control_API.Get_Fetch_Tax_On_Line_Entry_Db(company_);

   IF (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX AND fetch_tax_on_line_entry_ = Fnd_Boolean_API.DB_FALSE) THEN 
      Fetch_External_Tax(rec_.quotation_no);
   END IF;
    
END Release_Lines___;

PROCEDURE Reject_Released_Lines___ (
   rec_  IN OUT NOCOPY order_quotation_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   CURSOR get_released_lines IS
      SELECT *
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE rowstate ='Released'
      AND line_item_no <= 0
      AND quotation_no = rec_.quotation_no;
BEGIN
   FOR linerec_ IN get_released_lines LOOP
      Order_Quotation_Line_API.Set_Rejected(linerec_.quotation_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
   END LOOP;
END Reject_Released_Lines___;

PROCEDURE Update_Rejected_Reason___ (
   rec_  IN OUT NOCOPY order_quotation_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
   newrec_     ORDER_QUOTATION_TAB%ROWTYPE;
   oldrec_     ORDER_QUOTATION_TAB%ROWTYPE;
BEGIN
   -- Update quotation header, Add rejected reason to lose_win_reject_note
   oldrec_    := Lock_By_Keys___( rec_.quotation_no );
   newrec_    := oldrec_;
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___( objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   
END Update_Rejected_Reason___;

PROCEDURE Clear_Rejected_Reason___ (
   rec_  IN OUT NOCOPY order_quotation_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
   newrec_     ORDER_QUOTATION_TAB%ROWTYPE;
   oldrec_     ORDER_QUOTATION_TAB%ROWTYPE;
BEGIN
   -- Update quotation header, clear lose_win_reject_note
   oldrec_    := Lock_By_Keys___( rec_.quotation_no );
   newrec_    := oldrec_;
   
   Client_SYS.Add_To_Attr('LOSE_WIN_REJECT_NOTE', '', attr_ );
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___( objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Clear_Rejected_Reason___;

PROCEDURE Log_Event___ (
   rec_  IN OUT ORDER_QUOTATION_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   rejected_revision_info_ VARCHAR2(3200);
BEGIN
   IF (rec_.rowstate = 'Rejected') THEN
      rejected_revision_info_ := Get_Lose_Win_Reject_Note(rec_.quotation_no);
      
      Order_Quotation_History_API.New( rec_.quotation_no, rejected_revision_info_);
   ELSIF (rec_.rowstate != 'Planned') THEN
      Order_Quotation_History_API.New( rec_.quotation_no );
   END IF;
END Log_Event___;


PROCEDURE Loose_Lines___ (
   rec_  IN OUT ORDER_QUOTATION_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
   newrec_     ORDER_QUOTATION_TAB%ROWTYPE;
   oldrec_     ORDER_QUOTATION_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE rowstate NOT IN ('Cancelled', 'Won', 'Lost', 'CO Created')
      AND line_item_no <= 0
      AND quotation_no = rec_.quotation_no;
   
   reason_id_  ORDER_QUOTATION_LINE_TAB.reason_id%TYPE;
   lost_to_    ORDER_QUOTATION_LINE_TAB.lost_to%TYPE;
   lost_note_  ORDER_QUOTATION_LINE_TAB.lose_win_note%TYPE;
BEGIN
   -- Update quotation header
   oldrec_    := Lock_By_Keys___( rec_.quotation_no );
   newrec_    := oldrec_;
   reason_id_ := Client_SYS.Get_Item_Value('REASON_ID', attr_ );
   lost_to_   := Client_SYS.Get_Item_Value('LOST_TO', attr_ );
   lost_note_ := Client_SYS.Get_Item_Value('LOSE_WIN_REJECT_NOTE', attr_ );
   
   Client_SYS.Add_To_Attr('CLOSED_STATUS_DB', 'LOST', attr_ );
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___( objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   
   FOR linerec_ IN get_lines LOOP
      Order_Quotation_Line_API.Set_Quotation_Line_Lost__( info_, rec_.quotation_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, reason_id_, lost_to_, lost_note_);
   END LOOP;
   
   Remove_Intrm_Order_Resrv___(rec_.quotation_no);
END Loose_Lines___;

PROCEDURE Create_Order___ (
   rec_  IN OUT ORDER_QUOTATION_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   order_id_                  CUSTOMER_ORDER_TAB.order_id%TYPE;
   wanted_del_date_           CUSTOMER_ORDER_TAB.wanted_delivery_date%TYPE;
   order_no_                  CUSTOMER_ORDER_TAB.order_no%TYPE;
   customer_po_no_            CUSTOMER_ORDER_TAB.customer_po_no%TYPE;
   reason_id_                 ORDER_QUOTATION_TAB.reason_id%TYPE;
   won_note_                  ORDER_QUOTATION_TAB.lose_win_reject_note%TYPE;
   attr2_                     VARCHAR2(32000);
   newrec_                    ORDER_QUOTATION_TAB%ROWTYPE;
   oldrec_                    ORDER_QUOTATION_TAB%ROWTYPE;
   objid_                     VARCHAR2(2000);
   objversion_                VARCHAR2(2000);
   change_line_delivery_date_ VARCHAR2(10);
   create_from_header_        VARCHAR2(5);
   pre_accounting_id_         NUMBER;
   info_                      VARCHAR2(32000);
   current_info_              VARCHAR2(32000);
   indrec_                    Indicator_Rec;
   copy_all_rep_              VARCHAR2(20);
   main_representative_       VARCHAR2(50);
   copy_contacts_             VARCHAR2(5);
   
   CURSOR get_lines( quotation_no_ IN VARCHAR2 ) IS
      SELECT line_no, rel_no, line_item_no, single_occ_addr_flag, default_addr_flag, ship_addr_country_code, 
             ship_addr_name , ship_address1, ship_address2,ship_address3,ship_address4,ship_address5,ship_address6, ship_addr_zip_code, ship_addr_city , 
             ship_addr_state , ship_addr_county , ship_addr_in_city, company            
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE rowstate IN  ('Released', 'Won')
      AND line_item_no <= 0
      AND quotation_no = quotation_no_
      ORDER BY ABS(line_no), rel_no;
   
   line_attr_                   VARCHAR2(32000);
   line_so_attr_                VARCHAR2(32000);
   lines_found_                 BOOLEAN := FALSE;
   limit_sales_toy_assortments_ VARCHAR2(5);
BEGIN
   -- Get order_id
   order_id_                  := Client_SYS.Get_Item_Value('ORDER_ID', attr_ );
   wanted_del_date_           := Client_SYS.Attr_Value_To_Date( Client_SYS.Get_Item_Value('WANTED_DELIVERY_DATE', attr_ ) );
   change_line_delivery_date_ := Client_SYS.Get_Item_Value('CHANGE_LINE_DELIVERY_DATE', attr_ );
   -- Get customer purchase order number
   customer_po_no_            := Client_SYS.Get_Item_Value('CUSTOMER_PO_NO', attr_);
   -- Get won reason and note
   reason_id_                 := Client_SYS.Get_Item_Value('REASON_ID', attr_ );
   won_note_                  := Client_SYS.Get_Item_Value('LOSE_WIN_REJECT_NOTE', attr_ );
   create_from_header_        := Client_SYS.Get_Item_Value('CREATE_FROM_HEADER', attr_ );
   limit_sales_toy_assortments_ := Client_SYS.Get_Item_Value('LIMIT_SALES_TO_ASSORTMENTS', attr_);
   copy_all_rep_              := Client_SYS.Get_Item_Value('COPY_ALL_REPRESENTATIVES', attr_ );
   main_representative_       := Client_SYS.Get_Item_Value('MAIN_REPRESENTATIVE', attr_ );
   copy_contacts_             := Client_SYS.Get_Item_Value('COPY_CONTACTS', attr_);
   
   -- Create header
   Create_Order_Head( order_no_, rec_.quotation_no, order_id_, wanted_del_date_, create_from_header_, pre_accounting_id_, customer_po_no_, limit_sales_toy_assortments_, copy_all_rep_, main_representative_, copy_contacts_);
   
   -- Note: We only consider the customer order header creation info in this flow.
   info_ := Client_SYS.Get_All_Info;
   
   -- Create lines
   Client_SYS.Clear_Attr( line_attr_ );
   Client_SYS.Add_To_Attr( 'ORDER_NO', order_no_, line_attr_ );
   Client_SYS.Add_To_Attr( 'WANTED_DELIVERY_DATE', wanted_del_date_, line_attr_ );
   Client_SYS.Add_To_Attr( 'REASON_ID', reason_id_, line_attr_ );
   Client_SYS.Add_To_Attr( 'LOSE_WIN_NOTE', won_note_, line_attr_ );
   Client_SYS.Add_To_Attr( 'CHANGE_LINE_DELIVERY_DATE',change_line_delivery_date_, line_attr_ );   
   
   FOR linerec_ IN get_lines(rec_.quotation_no) LOOP
      lines_found_ := TRUE;
      Order_Quotation_Line_API.Create_Order_Line(rec_.quotation_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, line_attr_);
      IF linerec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE AND linerec_.default_addr_flag = 'N' THEN 
         Client_SYS.Clear_Attr( line_so_attr_ );
         Client_SYS.Set_Item_Value('ADDR_FLAG', Gen_Yes_No_API.Decode('Y'), line_so_attr_);
         Client_SYS.Set_Item_Value('ADDR_FLAG_DB', 'Y', line_so_attr_ );
         Client_SYS.Add_To_Attr('COUNTRY_CODE', linerec_.ship_addr_country_code, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDR_1', linerec_.ship_addr_name, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDRESS1', linerec_.ship_address1, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDRESS2', linerec_.ship_address2, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDRESS3', linerec_.ship_address3, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDRESS4', linerec_.ship_address4, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDRESS5', linerec_.ship_address5, line_so_attr_);
         Client_SYS.Add_To_Attr('ADDRESS6', linerec_.ship_address6, line_so_attr_);
         Client_SYS.Add_To_Attr('ZIP_CODE', linerec_.ship_addr_zip_code, line_so_attr_);
         Client_SYS.Add_To_Attr('CITY', linerec_.ship_addr_city, line_so_attr_);
         Client_SYS.Add_To_Attr('STATE', linerec_.ship_addr_state, line_so_attr_);
         Client_SYS.Add_To_Attr('COUNTY', linerec_.ship_addr_county, line_so_attr_);
         Client_SYS.Add_To_Attr('IN_CITY', linerec_.ship_addr_in_city, line_so_attr_);
         Client_SYS.Add_To_Attr('COMPANY', linerec_.company, line_so_attr_);
         Cust_Order_Line_Address_API.Change_Address(line_so_attr_, order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no); 
      END IF ;
      
   END LOOP;
   
   IF NOT (lines_found_) THEN
      Error_SYS.Record_General(lu_name_, 'CANTCREATECO: Order Quotation must have a valid quotation line to create a Customer Order.');
   ELSE
      current_info_ := NULL;
      App_Context_SYS.Set_Value('ORDER_QUOTATION_LINE_API.CURRENT_INFO_', current_info_);
   END IF;
   
   -- Create charges
   Transfer_Charge_To_Order( rec_.quotation_no, order_no_);
   
   -- Set it as won
   newrec_ := rec_;
   oldrec_ := newrec_;
   Client_SYS.Clear_Attr( attr2_ );
   Client_SYS.Add_To_Attr( 'REASON_ID', reason_id_, attr2_ );
   Client_SYS.Add_To_Attr( 'LOSE_WIN_REJECT_NOTE', won_note_, attr2_ );
   Client_SYS.Add_To_Attr( 'CLOSED_STATUS_DB', 'WON', attr2_ );
   Unpack___(newrec_, indrec_, attr2_);
   Check_Update___(oldrec_, newrec_, indrec_, attr2_);   
   Update___( objid_, rec_, newrec_, attr2_, objversion_, TRUE );
   
   -- Release order
   -- This part is moved to Procedure Create Order()
   -- Add the created order number back to the client so that a message can be displayed,
   -- telling the user the newly created order number.
   Client_SYS.Add_To_Attr('CREATED_ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('PRE_ACCOUNTING_ID', pre_accounting_id_, attr_);
   
   IF (info_ IS NOT NULL) THEN
      IF (SUBSTR(info_, 1, 5) = 'INFO' || Client_SYS.field_separator_) THEN
         Client_SYS.Add_Info(lu_name_, SUBSTR(info_, 6, LENGTH(info_) - 7));
      END IF;
   END IF;
END Create_Order___;


PROCEDURE New_Revision___ (
   rec_  IN OUT ORDER_QUOTATION_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_   ORDER_QUOTATION_TAB%ROWTYPE;
   newrec_   ORDER_QUOTATION_TAB%ROWTYPE;
   objid_    ROWID;
   objver_   ORDER_QUOTATION.OBJVERSION%TYPE;
BEGIN
   oldrec_ := Lock_By_Keys___(rec_.quotation_no);
   newrec_ := oldrec_;
   
   newrec_.revision_no := newrec_.revision_no + 1;
   newrec_.printed := 'NOTPRINTED';
   Update___( objid_, oldrec_, newrec_, attr_, objver_, TRUE );
   
   Client_SYS.Add_Info(lu_name_,'REVISION_CREATED: A New revision will be created for Quotation No :P1 ',newrec_.quotation_no );
   Client_SYS.Add_To_Attr( 'PRINTED_DB', 'NOTPRINTED', attr_ );
END New_Revision___;


-- Get_Jinsui_Invoice_Defaults___
--   Gets default value for the Junsui Invoice.
FUNCTION Get_Jinsui_Invoice_Defaults___ (
   company_     IN VARCHAR2,
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
   cust_no_         ORDER_QUOTATION_TAB.customer_no%TYPE;
   jinsui_invoice_  ORDER_QUOTATION_TAB.jinsui_invoice%TYPE;
BEGIN
   -- Get the default value for create jinsui info.
   $IF (Component_Jinsui_SYS.INSTALLED) $THEN   
      cust_no_        := NVL(Cust_Ord_Customer_API.Get_Customer_No_Pay(customer_no_),customer_no_);
      jinsui_invoice_ := Js_Customer_Info_API.Get_Create_Js_Invoice(company_, cust_no_);     
   $END            
   jinsui_invoice_ := NVL(jinsui_invoice_,db_false_);
   RETURN jinsui_invoice_;
END Get_Jinsui_Invoice_Defaults___;


-- Validate_Jinsui_Constraints___
--   Performs validation with the Junsi Invoice Constraints.
PROCEDURE Validate_Jinsui_Constraints___ (
   newrec_ IN ORDER_QUOTATION_TAB%ROWTYPE,
   oldrec_ IN ORDER_QUOTATION_TAB%ROWTYPE )
IS
   cust_no_                ORDER_QUOTATION_TAB.customer_no%TYPE;
   create_js_invoice_      VARCHAR2(20);
   company_                VARCHAR2(20);
   acc_currency_           VARCHAR2(3);
   order_currency_         VARCHAR2(3);
   rowstate_               ORDER_QUOTATION_TAB.rowstate%TYPE;
   company_max_jinsui_amt_ NUMBER := 0;
   
   CURSOR get_lines(quotation_no_ VARCHAR2) IS
      SELECT *
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no  = quotation_no_
      AND    rowstate NOT IN ('Cancelled', 'Lost', 'CO Created');
   
   CURSOR get_charge_lines(quotation_no_ VARCHAR2) IS
      SELECT quotation_charge_no, line_no, rel_no, line_item_no
      FROM   order_quotation_charge_tab
      WHERE  quotation_no  = quotation_no_;
BEGIN
   IF newrec_.jinsui_invoice = db_true_ THEN
      company_ := Site_API.Get_Company(newrec_.contract);
      Company_Finance_API.Get_Accounting_Currency(acc_currency_, company_);
      cust_no_ := NVL(newrec_.customer_no_pay,newrec_.customer_no);
      
      $IF (Component_Jinsui_SYS.INSTALLED) $THEN
         create_js_invoice_ := Js_Customer_Info_API.Get_Create_Js_Invoice(company_, cust_no_);
      $END   
      
      create_js_invoice_ := NVL(create_js_invoice_,db_false_);
      IF (Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no) = Customer_Category_API.DB_PROSPECT) THEN
         Error_SYS.Record_General(lu_name_, 'NOJINSUIPRO: Jinsui invoice cannot be selected for a prospective customer.');
      END IF;
      IF (create_js_invoice_ = db_false_) THEN
         Error_SYS.Record_General(lu_name_, 'NOJINSUI: You cannot have a Jinsui Order when :P1 is not Jinsui enabled.',cust_no_);
      END IF;
      order_currency_ := newrec_.currency_code;
      IF order_currency_ != acc_currency_ THEN
         Error_SYS.Record_General(lu_name_, 'NOJINSUINONCURR: You cannot have a Jinsui Order when order currency and accounting currency are not same.');
      END IF;
   END IF;
   rowstate_ := Get_Objstate(newrec_.quotation_no);
   IF rowstate_ IS NOT NULL THEN
      IF (rowstate_ ='Planned') OR (rowstate_ ='Released') THEN
         IF (oldrec_.jinsui_invoice != newrec_.jinsui_invoice) AND(newrec_.jinsui_invoice = db_true_) THEN
            
            $IF (Component_Jinsui_SYS.INSTALLED) $THEN
               company_max_jinsui_amt_ := Js_Company_Info_API.Get_Virtual_Inv_Max_Amount(company_);
            $END
            IF (Quotation_Lines_Exist(newrec_.quotation_no) != 0) THEN
               FOR quotation_lines_ IN get_lines(newrec_.quotation_no) LOOP
                  Order_Quotation_Line_API.Validate_Jinsui_Constraints__(quotation_lines_, company_max_jinsui_amt_, TRUE);  
               END LOOP;
            END IF;
            IF (Exist_Charges__(newrec_.quotation_no)!= 0) THEN
               FOR charge_line_ IN get_charge_lines(newrec_.quotation_no) LOOP
                  Order_Quotation_Charge_API.Validate_Jinsui_Constraints__(newrec_.quotation_no,
                                                                           charge_line_.quotation_charge_no,
                                                                           charge_line_.line_no,
                                                                           charge_line_.rel_no,
                                                                           charge_line_.line_item_no,
                                                                           company_max_jinsui_amt_,
                                                                           TRUE);  
               END LOOP;
            END IF;
         END IF;
      END IF;
   END IF;
END Validate_Jinsui_Constraints___;


-- Check_Customer_Quo_No___
--   Check whether the given customer_quo_no is already assigned to the given customer_no.
FUNCTION Check_Customer_Quo_No___ (
   customer_quo_no_ IN VARCHAR2,
   customer_no_     IN VARCHAR2) RETURN BOOLEAN
IS
   temp_ NUMBER;
   CURSOR get_attr IS
      SELECT 1
      FROM ORDER_QUOTATION_TAB
      WHERE customer_quo_no = customer_quo_no_
      AND   customer_no     = customer_no_
      AND   customer_quo_no IS NOT NULL;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF (get_attr%FOUND) THEN
      CLOSE get_attr;
      RETURN TRUE;
   END IF;
   CLOSE get_attr;
   RETURN FALSE;
END Check_Customer_Quo_No___;


-- Email_Quotation_Allowed___
--   Return TRUE if the Email Quotation operation is allowed
--   for a specified quotation.
FUNCTION Email_Quotation_Allowed___ (
   rec_ IN ORDER_QUOTATION_TAB%ROWTYPE ) RETURN BOOLEAN 
IS
   allowed_           BOOLEAN := FALSE;
   customer_category_ CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   IF (rec_.rowstate NOT IN ('Cancelled')) THEN
      customer_category_  := Customer_Info_API.Get_Customer_Category_Db(rec_.customer_no); 
      IF (Cust_Ord_Customer_Address_API.Get_Email(rec_.customer_no, rec_.cust_ref, rec_.bill_addr_no) IS NOT NULL) THEN
         allowed_ := TRUE;  
      END IF;   
   END IF;
   RETURN allowed_;   
END Email_Quotation_Allowed___;


-- Get_New_Quotation_No___
--   Out new quotation number.
PROCEDURE  Get_New_Quotation_No___ (
   quotation_no_ OUT VARCHAR2,
   coordinator_  IN  VARCHAR2,
   source_order_ IN  VARCHAR2)
IS
   authorize_group_ VARCHAR2(1) := NULL;
   exist_           BOOLEAN     := TRUE;
BEGIN
   authorize_group_ := Order_Coordinator_API.Get_Authorize_Group(coordinator_);
   WHILE exist_ LOOP 
      -- Note: Checks whether the quotation order is sourced from Incoming Customer Order (ICO) flow
      --       so that by using autonomous transaction system will release the order_coordinator_group_tab lock.
      IF source_order_ = 'ICO' THEN
         Order_Coordinator_Group_API.Incr_Quotation_No_Autonomous(quotation_no_, authorize_group_);
      ELSE
         Order_Coordinator_Group_API.Increase_Quotation_No(quotation_no_, authorize_group_);
      END IF;
      quotation_no_ := authorize_group_ || Order_Coordinator_Group_API.Get_Quotation_No(authorize_group_); 
      exist_        := Check_Exist___(quotation_no_);
   END LOOP;  
END Get_New_Quotation_No___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_       ORDER_QUOTATION_TAB.contract%TYPE := User_Default_API.Get_Contract;
   authorize_code_ ORDER_QUOTATION_TAB.authorize_code%TYPE := User_Default_API.Get_Authorize_Code;
   id_             PERSON_INFO_TAB.person_id%TYPE;
BEGIN
   super(attr_);
   IF (contract_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
      Client_SYS.Add_To_Attr('SUPPLY_COUNTRY', Company_Site_API.Get_Country(contract_), attr_);
      Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(contract_), attr_);
   END IF;
   IF (authorize_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('AUTHORIZE_CODE', authorize_code_, attr_);
   END IF;
   
   Client_SYS.Add_To_Attr('CALC_DISC_FLAG', db_false_, attr_ );
   Client_SYS.Add_To_Attr('PRINTED_DB', 'NOTPRINTED', attr_ );
   Client_SYS.Add_To_Attr('REVISION_NO', '1', attr_ );
   Client_SYS.Add_To_Attr('QUOTATION_PROBABILITY', '100', attr_);
   Client_SYS.Set_Item_Value('ADDITIONAL_DISCOUNT', '0', attr_);
   Client_SYS.Add_To_Attr('APPLY_FIX_DELIV_FREIGHT_DB', db_false_, attr_);
   Client_SYS.Add_To_Attr('SINGLE_OCC_ADDR_FLAG', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('SHIP_ADDR_IN_CITY', 'FALSE', attr_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      id_ := Person_Info_API.Get_Id_For_User(Fnd_Session_API.Get_Fnd_User());
      IF (Business_Representative_API.Exists(id_)) THEN
         Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', id_, attr_);
      END IF;
   $END
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ORDER_QUOTATION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   rounding_            NUMBER;
   quotation_no_        ORDER_QUOTATION_TAB.quotation_no%TYPE := NULL;
   message_             VARCHAR2(100);
   currency_rounding_   NUMBER;
   cust_calendar_id_    VARCHAR2(10);
   source_order_        VARCHAR2(5);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      representative_id_   bus_obj_representative_tab.representative_id%TYPE;
   $END
   old_note_id_         NUMBER;  
BEGIN
   newrec_.date_entered := Site_API.Get_Site_Date(newrec_.contract);
   Client_SYS.Add_To_Attr('DATE_ENTERED', newrec_.date_entered, attr_);
   old_note_id_         := newrec_.note_id;
   newrec_.note_id      := Document_Text_API.Get_Next_Note_Id;
   IF (old_note_id_ IS NOT NULL ) THEN
      Document_Text_API.Copy_All_Note_Texts(old_note_id_, newrec_.note_id);
   END IF;
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', newrec_.wanted_delivery_date, attr_);
   rounding_            := Currency_Code_API.Get_Currency_Rounding( newrec_.company, Company_Finance_API.Get_Currency_Code(newrec_.company));
   Client_SYS.Add_To_Attr('ROUNDING', rounding_, attr_);
   IF (Company_Finance_API.Get_Currency_Code(newrec_.company) != newrec_.currency_code) THEN
      currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(newrec_.company, newrec_.currency_code);
   ELSE
      currency_rounding_ := rounding_;
   END IF;
   Client_SYS.Add_To_Attr('CURRENCY_ROUNDING', currency_rounding_, attr_);
   source_order_ := Client_SYS.Get_Item_Value('SOURCE_ORDER', attr_); 
   IF (newrec_.quotation_no IS NULL) THEN
      -- Note: Move the logic to Get_New_Quotation_No___() method. 
      Get_New_Quotation_No___ (quotation_no_, newrec_.authorize_code, source_order_);
      newrec_.quotation_no := quotation_no_;
      Client_SYS.Add_To_Attr('QUOTATION_NO', newrec_.quotation_no, attr_);
   END IF;
   
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      IF (newrec_.main_representative_id IS NULL) THEN
         newrec_.main_representative_id := Rm_Acc_Representative_API.Get_Eligible_Representative(newrec_.customer_no);
      END IF;
      Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', newrec_.main_representative_id, attr_);
   $END
   
   IF (newrec_.customer_tax_usage_type IS NULL) THEN
      newrec_.customer_tax_usage_type := Customer_Info_API.Get_Customer_Tax_Usage_Type(newrec_.customer_no);
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      IF (newrec_.main_representative_id IS NOT NULL) THEN
         -- Insert main representative. 
         Bus_Obj_Representative_API.New_Bus_Obj_Representative(newrec_.quotation_no, Business_Object_Type_API.DB_SALES_QUOTATION, newrec_.main_representative_id, Fnd_Boolean_API.DB_TRUE);   
      END IF;
      -- If logged on user is not representative on the newly created object - add him or her
      -- If this is not done and the only privilege the user has for this object is a shared privilege, he or she will not have access to the created object
      -- Only if the user is a representative add as representative
      representative_id_ := Person_Info_API.Get_Id_For_User(Fnd_Session_API.Get_Fnd_User);
      IF Business_Representative_API.Exists(representative_id_) = FALSE THEN
         representative_id_ := NULL;
      END IF;
      IF representative_id_ IS NOT NULL AND Bus_Obj_Representative_API.Exists_Db(newrec_.quotation_no, Business_Object_Type_API.DB_SALES_QUOTATION, representative_id_) = FALSE THEN
         Bus_Obj_Representative_API.New_Bus_Obj_Representative(newrec_.quotation_no, Business_Object_Type_API.DB_SALES_QUOTATION, representative_id_, Fnd_Boolean_API.DB_FALSE);
      END IF;
   $END
   message_ := Language_SYS.Translate_Constant(lu_name_,'NEWQUOTE: New Quotation');
   IF (NVL(Client_SYS.Get_Item_Value('DEFAULT_CHARGES', attr_),'TRUE') = 'TRUE' ) THEN
      Order_Quotation_Charge_API.Copy_From_Customer_Charge(newrec_.customer_no, newrec_.contract, newrec_.quotation_no);
   END IF;
   Order_Quotation_History_API.New( newrec_.quotation_no,message_);
   
   $IF Component_Crm_SYS.INSTALLED $THEN
      Crm_Cust_Info_History_API.New_Event(customer_id_   => newrec_.customer_no, 
                                          event_type_db_ => Rmcom_Event_Type_API.DB_QUOTATION, 
                                          info_          => Language_SYS.Translate_Constant(lu_name_, 'QUOTATION_CREATED_CUSTOMER: Sales Quotation :P1 has been created for the account.', NULL, newrec_.quotation_no), 
                                          ref_id_        => newrec_.quotation_no, 
                                          ref_type_db_   => Business_Object_Type_API.DB_SALES_QUOTATION, 
                                          action_        => 'I');      
   $END
   
   IF (newrec_.wanted_delivery_date IS NOT NULL AND newrec_.customer_no IS NOT NULL) THEN
      cust_calendar_id_ := Cust_Ord_Customer_Address_API.Get_Cust_Calendar_Id(newrec_.customer_no, newrec_.ship_addr_no);
      Cust_Ord_Date_Calculation_API.Check_Date_On_Cust_Calendar_(newrec_.customer_no, cust_calendar_id_, newrec_.wanted_delivery_date, 'WANTED');
   END IF;
   
   IF (newrec_.ext_transport_calendar_id IS NOT NULL) THEN
      Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.ext_transport_calendar_id);
      
      IF (newrec_.wanted_delivery_date IS NOT NULL) THEN
         Cust_Ord_Date_Calculation_API.Chk_Date_On_Ext_Transport_Cal(newrec_.ext_transport_calendar_id, newrec_.wanted_delivery_date, 'WANTED');
      END IF;
   END IF;     
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     ORDER_QUOTATION_TAB%ROWTYPE,
   newrec_     IN OUT ORDER_QUOTATION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   change_                       BOOLEAN := FALSE;
   lineattr_                     VARCHAR2(2000);
   sale_unit_price_              NUMBER;
   unit_price_incl_tax_          NUMBER;
   base_sale_unit_price_         NUMBER;
   base_unit_price_incl_tax_     NUMBER;
   currency_rate_                NUMBER;
   discount_                     NUMBER;
   price_source_                 VARCHAR2(200);
   price_source_id_              VARCHAR2(25);
   part_price_                   NUMBER;
   part_price_incl_tax_          NUMBER;
   price_list_no_                VARCHAR2(10);
   line_no_                      VARCHAR2(4) := NULL;
   rel_no_                       VARCHAR2(4) := NULL;
   line_item_no_                 NUMBER := NULL;
   line_ship_via_code_           ORDER_QUOTATION_TAB.ship_via_code%TYPE;
   line_delivery_terms_          ORDER_QUOTATION_TAB.delivery_terms%TYPE;
   line_del_terms_location_      ORDER_QUOTATION_TAB.del_terms_location%TYPE := NULL;
   line_delivery_leadtime_       NUMBER;
   line_ext_transport_cal_id_    ORDER_QUOTATION_TAB.ext_transport_calendar_id%TYPE;
   line_default_addr_flag_       VARCHAR2(1);
   line_single_occ_addr_flag_    VARCHAR2(1);
   dummy_supp_ship_via_trans_    ORDER_QUOTATION_TAB.ship_via_code%TYPE;
   net_price_fetched_            VARCHAR2(20);
   freight_map_id_               VARCHAR2(15);
   zone_id_                      VARCHAR2(15);
   part_level_db_                VARCHAR2(30) := NULL;
   part_level_id_                VARCHAR2(200) := NULL;
   customer_level_db_            VARCHAR2(30) := NULL;
   customer_level_id_            VARCHAR2(200) := NULL;
   agreement_rec_                Customer_Agreement_API.Public_Rec;
   customer_rec_                 Cust_Ord_Customer_Address_API.Public_Rec;
   cust_calendar_id_             VARCHAR2(10);
   calendar_related_change_      BOOLEAN := FALSE;
   updated_from_wizard_          BOOLEAN := FALSE;
   dummy_route_id_               VARCHAR2(12);
   dummy_forward_agent_id_       ORDER_QUOTATION_TAB.forward_agent_id%TYPE;
   line_picking_leadtime_        NUMBER;
   dummy_shipment_type_          VARCHAR2(3);
   discount_freeze_db_           VARCHAR2(5);
   vendor_changed_               VARCHAR2(5) := 'FALSE';
   sales_price_type_db_          VARCHAR2(20);
   rental_chargeable_days_       NUMBER;
   refresh_vat_free_vat_code_    VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   current_info_                 VARCHAR2(32000);
   customer_changed_             BOOLEAN := FALSE;
   line_ship_addr_no_            ORDER_QUOTATION_TAB.ship_addr_no%TYPE;
   oldrec_tax_liability_type_db_ VARCHAR2(20);
   newrec_tax_liability_type_db_ VARCHAR2(20);
   copy_addr_to_line_            BOOLEAN := FALSE;
   so_matched_with_header_       BOOLEAN := FALSE;
   line_rec_                     ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   old_header_rec_               Order_Quotation_API.Public_Rec;
   single_occ_addr_changed_      BOOLEAN := FALSE;
   tax_method_                   VARCHAR2(50);
   part_desc_                    SALES_PART_CROSS_REFERENCE_TAB.catalog_desc%TYPE;  
   cust_part_no_                 SALES_PART_CROSS_REFERENCE_TAB.customer_part_no%TYPE;
   language_code_                CUSTOMER_INFO_TAB.default_language%TYPE;
   update_taxes_at_line_         BOOLEAN := TRUE;
   
   CURSOR get_quotation_lines(quotation_no_ IN VARCHAR2) IS
      SELECT *
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    buy_qty_due != 0
      AND    price_source != 'PRICE BREAKS'
      AND    rowstate NOT IN ('Cancelled', 'Lost', 'Won', 'CO Created');
   
   CURSOR get_charge_lines(quotation_no_ IN VARCHAR2) IS
      SELECT quotation_charge_no,
             charge_amount,
             base_charge_amount,
             charge_cost,
             charge_type,
             contract,
             currency_rate
      FROM   ORDER_QUOTATION_CHARGE_TAB
      WHERE  quotation_no = quotation_no_ ;
   
   CURSOR get_lines_with_no_default (quotation_no_ IN VARCHAR2, single_occ_addr_flag_ IN VARCHAR2) IS
      SELECT *
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    default_addr_flag = 'N'
      AND    line_item_no <= 0
      AND    rowstate NOT IN ('Cancelled', 'Lost', 'Won', 'CO Created');
   
BEGIN
   
   IF Client_SYS.Item_Exist('COPY_ADDR_TO_LINE', attr_) THEN 
      IF Client_SYS.Get_Item_Value('COPY_ADDR_TO_LINE', attr_)= 'TRUE' THEN
         copy_addr_to_line_ := TRUE;
      END IF;
   END IF; 
   
   --update additional discount in quotation line if additional discount is changed in quotatoin header.
   IF (oldrec_.additional_discount <> newrec_.additional_discount) THEN
      IF (Quotation_Lines_Exist(newrec_.quotation_no) = 1)  THEN
         Order_Quotation_Line_API.Modify_Additional_Discount__(newrec_.quotation_no,newrec_.additional_discount);
      END IF;
   END IF;
   
   old_header_rec_ := Order_Quotation_API.Get(oldrec_.quotation_no);
   
   --   -- When the header delivery address flag changes from OQ to Order Default, update default_addr_flag in appropriate order quotation lines
   --   -- so that the lines will get a copy of the header OQ address before the order values have been changed.
   --   IF (oldrec_.single_occ_addr_flag = 'TRUE' AND newrec_.single_occ_addr_flag = 'FALSE') THEN
   --      FOR addr_frozen_line_rec_ IN get_lines_with_frozen_address (newrec_.quotation_no) LOOP
   --         ORDER_QUOTATION_LINE_API.Modify_Default_Addr_Flag__ (newrec_.quotation_no, addr_frozen_line_rec_.line_no, addr_frozen_line_rec_.rel_no,
   --                                               addr_frozen_line_rec_.line_item_no, 'N');
   --      END LOOP;
   --   END IF;
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);
   
   oldrec_tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(oldrec_.tax_liability , oldrec_.ship_addr_country_code);
   newrec_tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, newrec_.ship_addr_country_code);
   
   IF (tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX ) THEN  
      update_taxes_at_line_ := FALSE;
   ELSIF ((NVL(newrec_.single_occ_addr_flag, 'FALSE') = 'FALSE') AND newrec_tax_liability_type_db_ = 'EXM'  AND (tax_method_ = External_Tax_Calc_Method_API.DB_NOT_USED)) THEN
      update_taxes_at_line_ := FALSE;
   END IF;
      
   IF ((newrec_tax_liability_type_db_ != oldrec_tax_liability_type_db_) OR
       (NVL(newrec_.ship_addr_no, string_null_) != NVL(oldrec_.ship_addr_no, string_null_)) OR
       (newrec_.supply_country != oldrec_.supply_country) OR
       (NVL(newrec_.ship_addr_country_code, string_null_) != NVL(oldrec_.ship_addr_country_code, string_null_)) OR
       (NVL(newrec_.vat_free_vat_code, string_null_) != NVL(oldrec_.vat_free_vat_code, string_null_))) THEN
      
      IF update_taxes_at_line_ THEN 
         Order_Quotation_Charge_API.Add_Transaction_Tax_Info(newrec_.quotation_no, line_no_, rel_no_, line_item_no_);
      END IF;
   END IF;
   
   -- Single Occurence Flag   
   IF (NVL(oldrec_.single_occ_addr_flag, 'FALSE') != NVL(newrec_.single_occ_addr_flag, 'FALSE')) THEN
      Order_Quotation_History_API.New(newrec_.quotation_no, 'SINGLE_OCC_ADDR_FLAG',
                                      oldrec_.single_occ_addr_flag, newrec_.single_occ_addr_flag,
                                      'QUOTATION', ' ', oldrec_.revision_no, ' ');
      change_ := TRUE;
   END IF;
   
   
   -- Single Occurence Address   
   IF (newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE) AND       
      (Validate_SYS.Is_Different(oldrec_.ship_addr_name, newrec_.ship_addr_name) OR            
       Validate_SYS.Is_Different(oldrec_.ship_address1, newrec_.ship_address1) OR
       Validate_SYS.Is_Different(oldrec_.ship_address2, newrec_.ship_address2) OR
       Validate_SYS.Is_Different(oldrec_.ship_address3, newrec_.ship_address3) OR
       Validate_SYS.Is_Different(oldrec_.ship_address4, newrec_.ship_address4) OR
       Validate_SYS.Is_Different(oldrec_.ship_address5, newrec_.ship_address5) OR
       Validate_SYS.Is_Different(oldrec_.ship_address6, newrec_.ship_address6) OR
       Validate_SYS.Is_Different(oldrec_.ship_addr_zip_code, newrec_.ship_addr_zip_code) OR
       Validate_SYS.Is_Different(oldrec_.ship_addr_country_code, newrec_.ship_addr_country_code) OR
       Validate_SYS.Is_Different(oldrec_.ship_addr_city, newrec_.ship_addr_city) OR
       Validate_SYS.Is_Different(oldrec_.ship_addr_state, newrec_.ship_addr_state) OR
       Validate_SYS.Is_Different(oldrec_.ship_addr_county, newrec_.ship_addr_county) OR
       Validate_SYS.Is_Different(oldrec_.ship_addr_in_city, newrec_.ship_addr_in_city)) THEN
      Order_Quotation_History_API.New(newrec_.quotation_no, 'SINGLE_OCC_ADDRESS',
                                      '', '', 'QUOTATION', ' ', oldrec_.revision_no, 
                                      Language_SYS.Translate_Constant(lu_name_, 'QUOT_SO_ADDR_CHANGED: Single Occurrence address changed'));
      
      IF (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) OR 
         ((tax_method_ = External_Tax_Calc_Method_API.DB_NOT_USED) AND (Validate_SYS.Is_Different(oldrec_.ship_addr_country_code, newrec_.ship_addr_country_code)))THEN
         -- Single occurrence ship address has been changed. Set the flag passed on to the quotation line.
         single_occ_addr_changed_ := TRUE;      
      END IF;
      change_ := TRUE;
   END IF;
   
   IF (NVL(oldrec_.ship_addr_no, '0') != NVL(newrec_.ship_addr_no, '0')) THEN
      Order_Quotation_History_API.New(newrec_.quotation_no, 'SHIP_ADDR_NO',
                                      oldrec_.ship_addr_no, newrec_.ship_addr_no,
                                      'QUOTATION', ' ', oldrec_.revision_no, ' ');
      change_ := TRUE;
   END IF;
   -- Add NVL
   IF (NVL(oldrec_.authorize_code, '0') != NVL(newrec_.authorize_code, '0')) THEN
      Order_Quotation_History_API.New(newrec_.quotation_no, 'AUTHORIZE_CODE',
                                      oldrec_.authorize_code, newrec_.authorize_code,
                                      'QUOTATION', ' ', oldrec_.revision_no, ' ');
      change_ := TRUE;
   END IF;
   IF (NVL(oldrec_.wanted_delivery_date, TO_DATE('01-01-1990','DD-MM-YYYY')) != NVL(newrec_.wanted_delivery_date, TO_DATE('01-01-1990','DD-MM-YYYY'))) THEN
      Order_Quotation_History_API.New(newrec_.quotation_no, 'WANTED_DELIVERY_DATE',
                                      oldrec_.wanted_delivery_date, newrec_.wanted_delivery_date,
                                      'QUOTATION', ' ', oldrec_.revision_no, ' ');
      change_ := TRUE;
   END IF;
   -- Add NVL
   IF (NVL(to_char(oldrec_.expiration_date), '0') != NVL(to_char(newrec_.expiration_date), '0')) THEN
      Order_Quotation_History_API.New(newrec_.quotation_no, 'EXPIRATION_DATE',
                                      oldrec_.expiration_date, newrec_.expiration_date,
                                      'QUOTATION', ' ', oldrec_.revision_no, ' ');
      change_ := TRUE;
   END IF;
   IF (oldrec_.delivery_terms != newrec_.delivery_terms) THEN
      Order_Quotation_History_API.New(newrec_.quotation_no, 'DELIVERY_TERMS',
                                      oldrec_.delivery_terms, newrec_.delivery_terms,
                                      'QUOTATION', ' ', oldrec_.revision_no, ' ');
      change_ := TRUE;
   END IF;
   IF (NVL(oldrec_.salesman_code,0) != newrec_.salesman_code) THEN
      Order_Quotation_History_API.New(newrec_.quotation_no, 'SALESMAN_CODE',
                                      oldrec_.salesman_code, newrec_.salesman_code,
                                      'QUOTATION', ' ', oldrec_.revision_no, ' ');
      change_ := TRUE;
   END IF;
   IF (oldrec_.ship_via_code != newrec_.ship_via_code) THEN
      Order_Quotation_History_API.New(newrec_.quotation_no, 'SHIP_VIA_CODE',
                                      oldrec_.ship_via_code, newrec_.ship_via_code,
                                      'QUOTATION', ' ', oldrec_.revision_no, ' ');
      change_ := TRUE;
   END IF;
   IF (oldrec_.pay_term_id != newrec_.pay_term_id) THEN
      Order_Quotation_History_API.New(newrec_.quotation_no, 'PAY_TERM_ID',
                                      oldrec_.pay_term_id, newrec_.pay_term_id,
                                      'QUOTATION', ' ', oldrec_.revision_no, ' ');
      change_ := TRUE;
   END IF;
   IF ((oldrec_.additional_discount != newrec_.additional_discount)) THEN
      Order_Quotation_History_API.New(newrec_.quotation_no, 'ADDITIONAL_DISCOUNT',
                                      TO_CHAR(oldrec_.additional_discount), TO_CHAR(newrec_.additional_discount),
                                      'QUOTATION', ' ', oldrec_.revision_no, ' ');
      change_ := TRUE;
   END IF;
   
   Client_SYS.Add_To_Attr('REVISION_NO', newrec_.revision_no, attr_);
   
   IF (Client_SYS.Get_Item_Value('UPDATED_FROM_WIZARD', attr_) = 'TRUE') THEN
      updated_from_wizard_ := TRUE;      
   END IF;
   
   IF (change_ AND NOT updated_from_wizard_) THEN
      -- Send QuotationChanged event (if not updating customer information via the wizard)
      Finite_State_Machine___(newrec_, 'QuotationChanged', attr_);
      Finite_State_Add_To_Attr___(newrec_, attr_);
   END IF;
   
   IF (((oldrec_.free_of_chg_tax_pay_party = Tax_Paying_Party_API.DB_NO_TAX) AND (newrec_.free_of_chg_tax_pay_party != Tax_Paying_Party_API.DB_NO_TAX)) OR 
       ((oldrec_.free_of_chg_tax_pay_party != Tax_Paying_Party_API.DB_NO_TAX) AND (newrec_.free_of_chg_tax_pay_party = Tax_Paying_Party_API.DB_NO_TAX))) THEN
      Tax_Paying_Party_Changed___(newrec_);
   END IF;
   
   -- Quotation promotion calculations should clear before modify quotation lines when changing the customer.
   IF (oldrec_.customer_no != newrec_.customer_no) THEN
      Sales_Promotion_Util_Api.Clear_Quote_Promotion(newrec_.quotation_no);
   END IF;
   
   -- IF agreement_id or price_effectivity_date has changed, prices and discounts are recalculated.
   IF (NVL(newrec_.agreement_id, '0') != NVL(oldrec_.agreement_id, '0')) OR (Validate_SYS.Is_Changed(oldrec_.vendor_no, newrec_.vendor_no)) OR
      (NVL(to_char(newrec_.price_effectivity_date), '0') != NVL(to_char(oldrec_.price_effectivity_date), '0') OR
       ((NVL(oldrec_.customer_no, string_null_) != NVL(newrec_.customer_no, string_null_)) OR (newrec_.currency_code != oldrec_.currency_code))) THEN
      FOR linerec_ IN get_quotation_lines(newrec_.quotation_no) LOOP
         
         -- Check whether a customer_no is changed.
         -- If customer change we want to reset the Delivery Address and single_occ_addr_flag to the header's address 
         -- and flag. Also default_addr_flag should be considered as set.
         IF NVL(oldrec_.customer_no, string_null_) != NVL(newrec_.customer_no, string_null_) THEN
            line_default_addr_flag_ := 'Y';
            line_ship_addr_no_ := newrec_.ship_addr_no;
            IF (newrec_.single_occ_addr_flag = 'TRUE') THEN
               line_single_occ_addr_flag_ := 'Y';
            ELSE
               line_single_occ_addr_flag_ := 'N';
            END IF;
         ELSE
            line_default_addr_flag_ := linerec_.default_addr_flag;
            line_ship_addr_no_ := linerec_.ship_addr_no;
            -- Convert the value to 'Y'/'N'
            IF (linerec_.single_occ_addr_flag = 'TRUE') THEN
               line_single_occ_addr_flag_ := 'Y';
            ELSE
               line_single_occ_addr_flag_ := 'N';
            END IF;
         END IF;
         
         IF (NVL(newrec_.agreement_id, '0') != NVL(oldrec_.agreement_id, '0')) OR
            (NVL(to_char(newrec_.price_effectivity_date), '0') != NVL(to_char(oldrec_.price_effectivity_date), '0') OR
             ((NVL(oldrec_.customer_no, string_null_) != NVL(newrec_.customer_no, string_null_)) OR (newrec_.currency_code != oldrec_.currency_code))) THEN
            -- Update price
            Client_SYS.Clear_Attr(lineattr_);
            IF (linerec_.rental = Fnd_Boolean_API.DB_FALSE) THEN
               sales_price_type_db_    := Sales_Price_Type_API.DB_SALES_PRICES;
               rental_chargeable_days_ := NULL;
            ELSE
               sales_price_type_db_    := Sales_Price_Type_API.DB_RENTAL_PRICES;
               rental_chargeable_days_ := Order_Quotation_Line_API.Get_Rental_Chargeable_Days(newrec_.quotation_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
            END IF;
            
            IF (newrec_.currency_code = oldrec_.currency_code) THEN
               price_list_no_ := linerec_.price_list_no;
            ELSE
               price_list_no_ := NULL;
            END IF;
            Sales_Price_List_API.Get_Valid_Price_List(customer_level_db_, customer_level_id_, price_list_no_, newrec_.contract, 
                                                      linerec_.catalog_no, newrec_.customer_no, newrec_.currency_code, newrec_.price_effectivity_date, NULL, sales_price_type_db_);
            Client_SYS.Add_To_Attr('PRICE_LIST_NO', price_list_no_, lineattr_);          
            
            part_price_          := NULL;
            part_price_incl_tax_ := NULL;
            
            Customer_Order_Pricing_API.Get_Quote_Line_Price_Info(part_price_, part_price_incl_tax_,
                                                                 base_sale_unit_price_, base_unit_price_incl_tax_,
                                                                 currency_rate_, discount_, price_source_, 
                                                                 price_source_id_, net_price_fetched_, 
                                                                 part_level_db_, part_level_id_, 
                                                                 customer_level_db_, customer_level_id_,
                                                                 newrec_.quotation_no, linerec_.catalog_no,
                                                                 linerec_.buy_qty_due, price_list_no_, 
                                                                 newrec_.price_effectivity_date, linerec_.condition_code,
                                                                 newrec_.use_price_incl_tax,
                                                                 rental_chargeable_days_);
            
            IF (NVL(linerec_.configuration_id, string_null_) != '*') THEN
               Client_SYS.Add_To_Attr('REFRESH_CONFIG_PRICE', 1, lineattr_);
               -- Calculate sale unit price and base sale unit price.
            ELSIF (linerec_.price_freeze = 'FREE') THEN
               IF (newrec_.use_price_incl_tax = 'TRUE') THEN
                  unit_price_incl_tax_ := part_price_incl_tax_ + NVL(linerec_.char_price, 0);
                  Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_unit_price_incl_tax_, currency_rate_,
                                                                        NVL(newrec_.customer_no_pay, newrec_.customer_no),
                                                                        newrec_.contract, newrec_.currency_code,
                                                                        unit_price_incl_tax_);
               ELSE
                  sale_unit_price_ := part_price_ + NVL(linerec_.char_price, 0);
                  Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_sale_unit_price_, currency_rate_,
                                                                        NVL(newrec_.customer_no_pay, newrec_.customer_no),
                                                                        newrec_.contract, newrec_.currency_code,
                                                                        sale_unit_price_);
               END IF;
               Order_Quotation_Line_API.Calculate_Prices(sale_unit_price_, unit_price_incl_tax_, base_sale_unit_price_, base_unit_price_incl_tax_, 
                                                         newrec_.quotation_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, currency_rate_);
               Client_SYS.Set_Item_Value('SALE_UNIT_PRICE',          sale_unit_price_,          lineattr_);
               Client_SYS.Set_Item_Value('BASE_SALE_UNIT_PRICE',     base_sale_unit_price_,     lineattr_);
               Client_SYS.Set_Item_Value('UNIT_PRICE_INCL_TAX',      unit_price_incl_tax_,      lineattr_);
               Client_SYS.Set_Item_Value('BASE_UNIT_PRICE_INCL_TAX', base_unit_price_incl_tax_, lineattr_);
            END IF;
            --This logic should run only if the agreement id has changed (mimicking customer order logic)
            IF (NVL(newrec_.agreement_id, '0') != NVL(oldrec_.agreement_id, '0')) THEN
               IF ((Pricing_Source_API.Encode(price_source_) = 'AGREEMENT') AND (price_source_id_ IS NOT NULL))THEN
                  Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Defaults(dummy_route_id_,
                                                                         dummy_forward_agent_id_,
                                                                         line_ship_via_code_,
                                                                         line_delivery_terms_,
                                                                         line_del_terms_location_,
                                                                         dummy_supp_ship_via_trans_,
                                                                         line_delivery_leadtime_,
                                                                         line_ext_transport_cal_id_,
                                                                         line_default_addr_flag_,
                                                                         freight_map_id_,
                                                                         zone_id_,
                                                                         line_picking_leadtime_,
                                                                         dummy_shipment_type_,
                                                                         linerec_.contract,
                                                                         newrec_.customer_no,
                                                                         line_ship_addr_no_,
                                                                         line_single_occ_addr_flag_,
                                                                         linerec_.part_no,
                                                                         linerec_.order_supply_type,
                                                                         linerec_.vendor_no,
                                                                         price_source_id_,
                                                                         newrec_.ship_via_code,
                                                                         newrec_.delivery_terms,
                                                                         newrec_.del_terms_location,
                                                                         newrec_.delivery_leadtime,
                                                                         newrec_.ext_transport_calendar_id, NULL, NULL, NULL, NULL,
                                                                         newrec_.vendor_no);
                  
                  Client_SYS.Add_To_Attr('SHIP_VIA_CODE', line_ship_via_code_, lineattr_);
                  Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', NVL(line_delivery_leadtime_, 0), lineattr_);
                  Client_SYS.Add_To_Attr('PICKING_LEADTIME', NVL(line_picking_leadtime_, 0), lineattr_);
                  Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', line_ext_transport_cal_id_, lineattr_);
                  
                  IF (price_source_id_ != linerec_.price_source_id) THEN
                     agreement_rec_ := Customer_Agreement_API.Get(price_source_id_);
                     IF (agreement_rec_.delivery_terms IS NOT NULL) THEN
                        -- IF the agreement has delivery terms get del_terms_location from agreement
                        -- if not retrieve delivery term and location from Order header.
                        IF (agreement_rec_.delivery_terms IS NOT NULL) THEN
                           line_delivery_terms_     := agreement_rec_.delivery_terms;
                           line_del_terms_location_ := agreement_rec_.del_terms_location;
                        ELSE
                           IF( line_delivery_terms_ IS NULL ) THEN
                              line_delivery_terms_     := newrec_.delivery_terms;
                              line_del_terms_location_ := newrec_.del_terms_location;
                           END IF;
                        END IF;
                     ELSE
                        IF( line_delivery_terms_ IS NULL ) THEN
                           customer_rec_            := Cust_Ord_Customer_Address_API.Get(newrec_.customer_no, line_ship_addr_no_);
                           line_delivery_terms_     := customer_rec_.delivery_terms;
                           line_del_terms_location_ := customer_rec_.del_terms_location;
                        END IF;
                     END IF;
                     Client_SYS.Add_To_Attr('DELIVERY_TERMS', line_delivery_terms_, lineattr_);      
                     Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', line_del_terms_location_, lineattr_);
                  END IF;
                  
                  Client_SYS.Add_To_Attr('DELIVERY_TERMS', line_delivery_terms_, lineattr_);
                  Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', line_del_terms_location_, lineattr_);
                  line_default_addr_flag_ := Order_Quotation_Line_API.Check_Default_Addr_Flag__(linerec_, newrec_.quotation_no, linerec_.default_addr_flag);
                  Client_SYS.Add_To_Attr('DEFAULT_ADDR_FLAG_DB', line_default_addr_flag_, lineattr_);
               ELSE
                  customer_rec_            := Cust_Ord_Customer_Address_API.Get(newrec_.customer_no, line_ship_addr_no_);
                  line_delivery_terms_     :=  customer_rec_.delivery_terms;
                  line_del_terms_location_ := customer_rec_.del_terms_location;
                  Client_SYS.Add_To_Attr('DELIVERY_TERMS', line_delivery_terms_, lineattr_);
                  Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', line_del_terms_location_, lineattr_);
               END IF;
            END IF;
            
            IF NVL(oldrec_.customer_no, string_null_) != NVL(newrec_.customer_no, string_null_) THEN    
               Client_SYS.Set_Item_Value('SINGLE_OCC_ADDR_FLAG', newrec_.single_occ_addr_flag, lineattr_);
               Client_SYS.Set_Item_Value('SHIP_ADDR_NO', newrec_.ship_addr_no, lineattr_);
               cust_part_no_    := Sales_Part_Cross_Reference_API.Get_Customer_Part_No(newrec_.customer_no, linerec_.contract, linerec_.catalog_no);
               part_desc_       := Sales_Part_Cross_Reference_API.Get_Catalog_Desc(newrec_.customer_no, linerec_.contract, cust_part_no_);
               language_code_   := Customer_Info_API.Get_Default_Language_Db(newrec_.customer_no);
               IF part_desc_ IS NULL THEN
                  part_desc_  := NVL(Sales_Part_Language_Desc_API.Get_Catalog_Desc(linerec_.contract, linerec_.catalog_no, language_code_),
                                     Sales_Part_API.Get_Catalog_Desc(linerec_.contract, linerec_.catalog_no, language_code_));
               END IF;            
               Client_SYS.Set_Item_Value('CUSTOMER_PART_NO', cust_part_no_ , lineattr_);
               Client_SYS.Add_To_Attr('CATALOG_DESC', NVL(part_desc_, linerec_.catalog_desc), lineattr_ );
            END IF;           
            Client_SYS.Add_To_Attr('CUSTOMER_NO', newrec_.customer_no, lineattr_);
            Client_SYS.Add_To_Attr('PART_PRICE', part_price_, lineattr_);
            Client_SYS.Add_To_Attr('CURRENCY_RATE', currency_rate_, lineattr_);
            Client_SYS.Add_To_Attr('DISCOUNT', discount_, lineattr_);
            Client_SYS.Add_To_Attr('PRICE_SOURCE', price_source_, lineattr_);
            Client_SYS.Add_To_Attr('PRICE_SOURCE_ID', price_source_id_, lineattr_);
            Client_SYS.Add_To_Attr('PRICE_SOURCE_NET_PRICE_DB', net_price_fetched_, lineattr_);
            Client_SYS.Add_To_Attr('PART_LEVEL_DB', part_level_db_,         lineattr_);
            Client_SYS.Add_To_Attr('PART_LEVEL_ID', part_level_id_,      lineattr_);
            Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_DB', customer_level_db_,     lineattr_);
            Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_ID', customer_level_id_,  lineattr_);
            Client_SYS.Set_Item_Value('SERVER_DATA_CHANGE', 1, lineattr_);
            
            IF (updated_from_wizard_) THEN
               Client_SYS.Add_To_Attr('UPDATED_FROM_WIZARD', 'TRUE',  lineattr_);
            END IF;
            
            Order_Quotation_Line_API.Modify(lineattr_, newrec_.quotation_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
            
            -- Update discounts
            discount_freeze_db_ := Site_Discom_Info_API.Get_Discount_Freeze_Db(newrec_.contract);
            IF NOT(linerec_.price_freeze = 'FROZEN' AND discount_freeze_db_ = 'TRUE') THEN
               Customer_Order_Pricing_API.Modify_Default_Qdiscount_Rec(newrec_.quotation_no, linerec_.line_no, linerec_.rel_no, 
                                                                       linerec_.line_item_no, newrec_.contract, newrec_.customer_no, 
                                                                       newrec_.currency_code, newrec_.agreement_id, linerec_.catalog_no, 
                                                                       linerec_.buy_qty_due, price_list_no_, newrec_.price_effectivity_date,
                                                                       customer_level_db_, customer_level_id_, rental_chargeable_days_);
               
               discount_ := NVL(Order_Quote_Line_Discount_API.Calculate_Discount__(newrec_.quotation_no, linerec_.line_no, 
                                                                                   linerec_.rel_no, linerec_.line_item_no), 0);
               
               Client_SYS.Clear_Attr(lineattr_);
               Client_SYS.Add_To_Attr('DISCOUNT', discount_, lineattr_);
               Order_Quotation_Line_API.Modify(lineattr_, newrec_.quotation_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
            END IF;
         END IF;
         IF Validate_SYS.Is_Changed(oldrec_.vendor_no, newrec_.vendor_no) THEN
            Order_Quotation_Line_API.Modify_Line_Default_Addr_Flag(linerec_, newrec_.quotation_no, linerec_.default_addr_flag); 
            vendor_changed_ := 'TRUE';
         END IF;
      END LOOP;
   END IF;
   
   -- Save the CLIENT_SYS.current_info_ to avoid loosing the info when calling Modify_Quote_Defaults__() method
   current_info_ := Fnd_Context_SYS.Find_Value('CLIENT_SYS.current_info_');
   current_info_ := LTRIM(current_info_, 'INFO');
   current_info_ := LTRIM(current_info_, chr(31));
   IF NVL(current_info_, string_null_) = string_null_ THEN 
      Client_SYS.Clear_Info;
   END IF; 
   IF (vendor_changed_ = 'FALSE') THEN
      -- Update all order lines' "header default data" where the default address flag is marked Yes
      -- using the order no to fetch the correct updated data.
      IF ((NVL(oldrec_.ship_addr_no, string_null_) != NVL(newrec_.ship_addr_no, string_null_)) OR
          (NVL(oldrec_.ship_via_code, string_null_) != NVL(newrec_.ship_via_code, string_null_)) OR
          (NVL(oldrec_.delivery_terms, string_null_) != NVL(newrec_.delivery_terms, string_null_)) OR
          (NVL(oldrec_.del_terms_location, string_null_) != NVL(newrec_.del_terms_location, string_null_)) OR
          (oldrec_.delivery_leadtime != newrec_.delivery_leadtime) OR
          (oldrec_.picking_leadtime != newrec_.picking_leadtime) OR
          (NVL(oldrec_.ext_transport_calendar_id, string_null_) != NVL(newrec_.ext_transport_calendar_id, string_null_)) OR
          (oldrec_.tax_liability != newrec_.tax_liability) OR
          (oldrec_.supply_country != newrec_.supply_country) OR
          (NVL(oldrec_.customer_no, string_null_) != NVL(newrec_.customer_no, string_null_)) OR
          (NVL(oldrec_.forward_agent_id, string_null_) != NVL(newrec_.forward_agent_id, string_null_)) OR
          (NVL(oldrec_.freight_map_id, string_null_) != NVL(newrec_.freight_map_id, string_null_)) OR
          (NVL(oldrec_.zone_id, string_null_) != NVL(newrec_.zone_id, string_null_)) OR
          (NVL(oldrec_.freight_price_list_no, string_null_) != NVL(newrec_.freight_price_list_no, string_null_)) OR
          (NVL(oldrec_.single_occ_addr_flag, string_null_) != NVL(newrec_.single_occ_addr_flag, string_null_)) OR
          (NVL(oldrec_.ship_addr_country_code, string_null_) != NVL(newrec_.ship_addr_country_code, string_null_)) OR
          ((newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE) AND single_occ_addr_changed_) OR
          (NVL(oldrec_.vat_free_vat_code, string_null_) != NVL(newrec_.vat_free_vat_code, string_null_))) THEN
         
         IF (newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE AND 
             ((Validate_SYS.Is_Different(oldrec_.vat_free_vat_code, newrec_.vat_free_vat_code) AND newrec_tax_liability_type_db_ = 'EXM') OR
              (newrec_tax_liability_type_db_ = 'EXM' AND oldrec_tax_liability_type_db_ = 'TAX'))) THEN
            refresh_vat_free_vat_code_ := Fnd_Boolean_API.DB_TRUE;
         END IF;
         
         IF NVL(oldrec_.customer_no, string_null_) != NVL(newrec_.customer_no, string_null_) THEN
            customer_changed_ := TRUE;
         END IF;
         
         IF (NVL(oldrec_.supply_country, ' ') != NVL(newrec_.supply_country, ' ')) THEN
            Order_Quotation_Line_API.Modify_Quote_Defaults__(newrec_.quotation_no, 'TRUE', single_occ_addr_changed_, customer_changed_, update_taxes_at_line_ );
         ELSE
            -- Need to pass on if the quotation header single occurrence country code has changed.
            Order_Quotation_Line_API.Modify_Quote_Defaults__(newrec_.quotation_no, refresh_vat_free_vat_code_, single_occ_addr_changed_, customer_changed_, update_taxes_at_line_ );
         END IF; 
      END IF;  
   END IF;
   
   --Update Lines with same address but no default-info set, if user choose to update those lines (copy_addr_to_line_ = 'TRUE').
   IF copy_addr_to_line_ AND 
      (Validate_SYS.Is_Changed(oldrec_.ship_addr_no, newrec_.ship_addr_no) OR 
       newrec_.single_occ_addr_flag = 'TRUE' OR
       Validate_SYS.Is_Changed(oldrec_.single_occ_addr_flag, newrec_.single_occ_addr_flag) ) THEN
      OPEN get_lines_with_no_default(oldrec_.quotation_no, oldrec_.single_occ_addr_flag);
   LOOP
      FETCH get_lines_with_no_default INTO line_rec_;
      EXIT WHEN get_lines_with_no_default%NOTFOUND;
      so_matched_with_header_ := FALSE;
      IF newrec_.single_occ_addr_flag = 'FALSE' AND oldrec_.single_occ_addr_flag = 'TRUE' OR 
         newrec_.single_occ_addr_flag = 'TRUE' AND oldrec_.single_occ_addr_flag = 'TRUE' THEN
         --single occurrence address to a delivery address OR --single occurrence address to single occurrence address
         Order_Quotation_Line_API.Single_Occ_Addr_Match__(line_rec_,
                                                          old_header_rec_, 
                                                          so_matched_with_header_) ;
         
      ELSIF Validate_SYS.Is_Equal(oldrec_.ship_addr_no, line_rec_.ship_addr_no) THEN
         --delivery address to single occurrence address OR -- delivery address to another
         so_matched_with_header_ := TRUE;
         
      END IF;   
      IF so_matched_with_header_ THEN
         Order_Quotation_Line_API.Modify_Delivery_Address__(newrec_.quotation_no, 
                                                            line_rec_.line_no, 
                                                            line_rec_.rel_no, 
                                                            line_rec_.line_item_no,
                                                            newrec_.ship_addr_no,
                                                            newrec_.single_occ_addr_flag,
                                                            update_taxes_at_line_);
      END IF;
   END LOOP; 
   CLOSE get_lines_with_no_default;
END IF;
IF NVL(current_info_, string_null_) != string_null_ THEN  
   IF NVL(Fnd_Context_SYS.Find_Value('CLIENT_SYS.current_info_'), string_null_) = string_null_  OR 
      (INSTR(Fnd_Context_SYS.Find_Value('CLIENT_SYS.current_info_'), current_info_) = 0) THEN 
      Client_SYS.Add_Info(lu_name_, current_info_);   
   END IF ; 
END IF ;

-- Skip the block if customer changes. The retrieval of charges is handled seperately.
IF ((NOT customer_changed_) AND (newrec_.currency_code != oldrec_.currency_code)) THEN
   FOR linerec_ IN get_charge_lines(newrec_.quotation_no) LOOP
      Client_SYS.Clear_Attr(lineattr_);
      Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(linerec_.charge_amount, linerec_.currency_rate,
                                                             newrec_.customer_no, newrec_.contract,
                                                             newrec_.currency_code, linerec_.base_charge_amount);
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT', linerec_.charge_amount, lineattr_);
      Client_SYS.Add_To_Attr('CURRENCY_RATE', linerec_.currency_rate, lineattr_);
      Order_Quotation_Charge_API.Modify(newrec_.quotation_no, linerec_.quotation_charge_no, lineattr_);
   END LOOP;
END IF;
IF (newrec_.wanted_delivery_date IS NOT NULL AND newrec_.customer_no IS NOT NULL) THEN
   IF (newrec_.wanted_delivery_date != NVL(oldrec_.wanted_delivery_date, Database_SYS.first_calendar_date_)
       OR NVL(newrec_.ship_addr_no, string_null_) != NVL(oldrec_.ship_addr_no, string_null_)) THEN
      calendar_related_change_ := TRUE;
   END IF;
   IF (calendar_related_change_ OR NVL(newrec_.customer_no, string_null_) != NVL(oldrec_.customer_no, string_null_)) THEN
      cust_calendar_id_ := Cust_Ord_Customer_Address_API.Get_Cust_Calendar_Id(newrec_.customer_no, newrec_.ship_addr_no);
      Cust_Ord_Date_Calculation_API.Check_Date_On_Cust_Calendar_(newrec_.customer_no, cust_calendar_id_, newrec_.wanted_delivery_date, 'WANTED');
   END IF;
   IF (calendar_related_change_ OR NVL(newrec_.ext_transport_calendar_id, string_null_) != NVL(oldrec_.ext_transport_calendar_id, string_null_)) THEN
      IF (NVL(newrec_.ext_transport_calendar_id, string_null_) != NVL(oldrec_.ext_transport_calendar_id, string_null_)) THEN
         Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.ext_transport_calendar_id);
      END IF;
      Cust_Ord_Date_Calculation_API.Chk_Date_On_Ext_Transport_Cal(newrec_.ext_transport_calendar_id, newrec_.wanted_delivery_date, 'WANTED');
   END IF;
END IF;

IF customer_changed_ THEN
   Add_Charges_On_Cust_Change___(newrec_);
END IF;

IF NOT update_taxes_at_line_ AND 
   (single_occ_addr_changed_ OR 
   (NVL(oldrec_.ship_addr_no, string_null_) != NVL(newrec_.ship_addr_no, string_null_)) OR
   (oldrec_.tax_liability != newrec_.tax_liability)) THEN 
   IF copy_addr_to_line_ THEN
      Fetch_External_Tax(newrec_.quotation_no);
   ELSE
      Fetch_External_Tax(newrec_.quotation_no, 'TRUE');
   END IF;
   
END IF;
   

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN order_quotation_tab%ROWTYPE )
IS
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      -- Remove the representatives
      Bus_Obj_Representative_API.Remove(remrec_.quotation_no, Business_Object_Type_API.DB_SALES_QUOTATION);
   $END   
   super(objid_, remrec_);  
   $IF Component_Crm_SYS.INSTALLED $THEN
      IF (remrec_.business_opportunity_no IS NOT NULL) THEN        
         -- Update the header status if all references have been deleted.        
         Business_Opportunity_API.Reference_Removed(remrec_.business_opportunity_no,Business_Object_Type_API.DB_SALES_QUOTATION,remrec_.quotation_no,NULL );  

      END IF;        
   $END
END Delete___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN            order_quotation_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY order_quotation_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   supplier_acquisition_site_ VARCHAR2(5) := NULL;
   supplier_category_         VARCHAR2(2);   
BEGIN
   IF (newrec_.company IS NULL) THEN
      newrec_.company := Site_API.Get_Company(Order_Quotation_API.Get_Contract(newrec_.quotation_no));
   END IF;
   IF (newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE AND newrec_.ship_addr_in_city IS NULL) THEN
      newrec_.ship_addr_in_city := 'FALSE';
   END IF;
   IF (newrec_.free_of_chg_tax_pay_party IS NULL) THEN
      newrec_.free_of_chg_tax_pay_party := Tax_Paying_Party_API.DB_NO_TAX;
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   $IF Component_Purch_SYS.INSTALLED $THEN
      supplier_acquisition_site_ := Supplier_API.Get_Acquisition_Site(newrec_.vendor_no);
      supplier_category_         := Supplier_API.Get_Category_Db(newrec_.vendor_no);
      IF (supplier_category_ = 'I') THEN
         IF ((Site_API.Get_Company(newrec_.contract) = Site_API.Get_Company(supplier_acquisition_site_)) AND (supplier_acquisition_site_ = newrec_.contract)) THEN
            Error_SYS.Record_General(lu_name_,'INTERNALSUPPLIER: The supplier :P1 is registered as the internal supplier of the site :P2 and cannot be entered as Deliver-from Supplier.', newrec_.vendor_no, newrec_.contract);
         END IF;
      END IF;
   $END
   
   IF (newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE) THEN
      IF (newrec_.ship_addr_country_code IS NOT NULL) THEN
         newrec_.country_code := newrec_.ship_addr_country_code;
      END IF;
      Address_Setup_API.Validate_Address(newrec_.ship_addr_country_code, newrec_.ship_addr_state, newrec_.ship_addr_county, newrec_.ship_addr_city);
      Tax_Handling_Order_Util_API.Validate_Tax_Free_Tax_Code(newrec_.company, 
                                                             'RESTRICTED', 
                                                             newrec_.vat_free_vat_code, 
                                                             newrec_.tax_liability,
                                                             Fnd_Boolean_API.DB_FALSE,
                                                             TRUNC(Site_API.Get_Site_Date(newrec_.contract)));              
   END IF ; 
   
   IF (TRUNC(Cust_Ord_Customer_API.Get_Date_Del(newrec_.customer_no)) <= TRUNC(Site_API.Get_Site_Date(newrec_.contract))) THEN
      Error_SYS.Record_General(lu_name_, 'DATE_EXP_ERROR_CUS: Customer has expired. Check expire date.');
   END IF;
END Check_Common___;


@Override
PROCEDURE Unpack___ (
   newrec_ IN OUT NOCOPY order_quotation_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   pricing_method_ VARCHAR2(20);
BEGIN
   IF (newrec_.rowstate IS NULL) THEN
      Get_Quote_Defaults___ (attr_);
   END IF;
   super(newrec_, indrec_, attr_);
   
   -- if order is B2B, make sure to keep PRICE_EFFECTIVITY_DATE in sync with WANTED_DELIVERY_DATE if pricing method is Delivery Date or Order Date (mimic CO logic)
   IF (newrec_.b2b_order = 'TRUE') THEN
      pricing_method_ := Site_Discom_Info_API.Get_Cust_Order_Pricing_Meth_Db(newrec_.contract);
      IF (pricing_method_ = Cust_Order_Pricing_Method_API.DB_DELIVERY_DATE OR pricing_method_ = Cust_Order_Pricing_Method_API.DB_ORDER_DATE) THEN
         IF (Site_Discom_Info_API.Get_Price_Effective_Date_Db(newrec_.contract) = Fnd_Boolean_API.DB_TRUE) THEN
            newrec_.price_effectivity_date := newrec_.wanted_delivery_date;
            Client_SYS.Add_To_Attr('PRICE_EFFECTIVITY_DATE', newrec_.price_effectivity_date, attr_);
         END IF;
      END IF;
   END IF;
END Unpack___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT order_quotation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   company_                VARCHAR2(20);
   delivery_country_code_  VARCHAR2(2);   
   customer_category_      CUSTOMER_INFO_TAB.customer_category%TYPE;
   acquisition_site_       VARCHAR2(5) := NULL;
   cust_ord_cust_category_ VARCHAR2(2);
   -- gelr:disc_price_rounded, begin
   true_                  VARCHAR2(5) := Fnd_Boolean_API.DB_TRUE;
   false_                 VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   -- gelr:disc_price_rounded, end
BEGIN  
   IF (newrec_.customer_no_pay IS NULL) THEN
      IF (newrec_.customer_no_pay_addr_no IS NOT NULL) THEN
         Error_SYS.Item_Insert(lu_name_, 'CUSTOMER_NO_PAY_ADDR_NO');
      END IF;
   ELSE
      Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_NO_PAY_ADDR_NO', newrec_.customer_no_pay_addr_no);
   END IF;  
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);     
   
   IF NOT(indrec_.single_occ_addr_flag) THEN
      newrec_.single_occ_addr_flag := 'FALSE';
   END IF;
   
   IF NOT(indrec_.ship_addr_in_city) THEN
      newrec_.ship_addr_in_city := 'FALSE';
   END IF;
   
   IF (newrec_.ship_addr_no IS NOT NULL AND indrec_.ship_addr_no) THEN
      IF (customer_category_ = Customer_Category_API.DB_CUSTOMER ) THEN
         Cust_Ord_Customer_Address_API.Exist(newrec_.customer_no, newrec_.ship_addr_no);
      ELSE
         Customer_Info_Address_API.Exist(newrec_.customer_no, newrec_.ship_addr_no);
      END IF;
   END IF;
   
   IF (newrec_.zone_id IS NOT NULL) THEN
      Freight_Zone_API.Exist(newrec_.freight_map_id, newrec_.zone_id);
   END IF;
   IF (newrec_.delivery_leadtime IS NULL) THEN
      newrec_.delivery_leadtime := 0;
   END IF;
   IF (newrec_.apply_fix_deliv_freight IS NULL) THEN
      newrec_.apply_fix_deliv_freight := db_false_;
   END IF;
   IF (customer_category_ = Customer_Category_API.DB_PROSPECT) THEN
      newrec_.picking_leadtime := Site_Invent_Info_API.Get_Picking_Leadtime(newrec_.contract);   
   END IF;
   IF (newrec_.picking_leadtime IS NULL) THEN
      newrec_.picking_leadtime := 0;
   END IF;   
   IF (newrec_.revision_no IS NULL) THEN
      newrec_.revision_no := 1;
   END IF;
   IF (newrec_.printed IS NULL) THEN
      newrec_.printed := 'NOTPRINTED';
   END IF;
   
   -- In case of a customer ( not prospect )
   IF (customer_category_ = Customer_Category_API.DB_CUSTOMER) THEN            
      IF (newrec_.ship_addr_no IS NULL OR newrec_.bill_addr_no IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOSHIPORBILLADDR: Delivery address and Document address should be defined when a customer is defined.');
      END IF;    
      Validate_Customer_Agreement___(newrec_.agreement_id, newrec_.contract, newrec_.customer_no, newrec_.currency_code);  
   END IF;

   -- gelr:disc_price_rounded, beginG
   company_ := Site_API.Get_Company(newrec_.contract);
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'DISC_PRICE_ROUNDED') = true_) THEN
      newrec_.disc_price_round := true_;
   ELSE
      newrec_.disc_price_round := false_;
   END IF;
   -- gelr:disc_price_rounded, end
   
   super(newrec_, indrec_, attr_);
   
   Error_SYS.Trim_Space_Validation(newrec_.quotation_no);
   
   IF (indrec_.pay_term_id) AND (customer_category_ = Customer_Category_API.DB_CUSTOMER) AND (newrec_.pay_term_id IS NULL) THEN
      -- Cannot enter a Normal customer with no payment terms.
      Error_SYS.Record_General(lu_name_, 'PAY_TERM_NULL: Payment Term must have a value for the paying customer :P1.',NVL(newrec_.customer_no_pay, newrec_.customer_no));
   END IF; 
   
   IF (indrec_.customer_no_pay) AND (newrec_.customer_no_pay IS NOT NULL) AND (TRUNC(Cust_Ord_Customer_API.Get_Date_Del(newrec_.customer_no_pay)) <= TRUNC(Site_API.Get_Site_Date(newrec_.contract))) THEN
      Error_SYS.Record_General(lu_name_, 'DATE_EXP_ERROR_PAY: Payer has expired. Check expire date.');
   END IF;
   
   IF (indrec_.customer_no_pay_addr_no) AND (newrec_.customer_no_pay_addr_no IS NOT NULL) AND
      (Cust_Ord_Customer_Address_API.Is_Bill_Location(newrec_.customer_no_pay, newrec_.customer_no_pay_addr_no) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'NOTDOCADDR: Invalid document address specified.');
   END IF;
   
   IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0) THEN
      Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'PICKVALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
   END IF;
   
   acquisition_site_       := Cust_Ord_Customer_API.Get_Acquisition_Site(newrec_.customer_no);
   cust_ord_cust_category_ := Cust_Ord_Customer_API.Get_Category_Db(newrec_.customer_no);
   IF (cust_ord_cust_category_ = 'I') THEN
      IF ((Site_API.Get_Company(newrec_.contract) = Site_API.Get_Company(acquisition_site_)) AND (acquisition_site_ =  newrec_.contract)) THEN
         Error_SYS.Record_General(lu_name_,'OQINTERNALCUST: The customer :P1 is registered as the internal customer of the site :P2. Therefore, you cannot create a sales quotation for the customer from this site.', newrec_.customer_no,  newrec_.contract);
      END IF;
   END IF; 
   
   IF (newrec_.quotation_no IS NOT NULL) AND Check_Exist___(newrec_.quotation_no) THEN
      Error_SYS.Record_Exist(lu_name_, p1_ => newrec_.quotation_no);
   END IF;
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   
   IF NOT (newrec_.tax_liability IS NOT NULL AND (newrec_.tax_liability = 'TAX' OR newrec_.tax_liability = 'EXEMPT')) THEN
      delivery_country_code_ := Cust_Ord_Customer_Address_API.Get_Country_Code(newrec_.customer_no, newrec_.ship_addr_no);
      Tax_Handling_Order_Util_API.Validate_Tax_Liability(newrec_.tax_liability, delivery_country_code_);
   END IF; 
   
   -- Check that customer no is defined
   IF (newrec_.customer_no IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'CUSTPROSPECT1: A customer must be defined.');
   END IF;
   IF (newrec_.ship_addr_no IS NOT NULL) THEN
      IF (Cust_Ord_Customer_Address_API.Is_Ship_Location(newrec_.customer_no, newrec_.ship_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTDELADDR: Invalid delivery address specified.');
      END IF;
      
      IF (Cust_Ord_Customer_Address_API.Is_Valid(newrec_.customer_no, newrec_.ship_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDDELADDR: Delivery address :P1 is invalid. Check the validity period.', newrec_.ship_addr_no);
      END IF;
   END IF;  
   -- Make sure the specified addresses for the order are valid.
   IF (newrec_.bill_addr_no IS NOT NULL) THEN
      IF (Cust_Ord_Customer_Address_API.Is_Bill_Location(newrec_.customer_no, newrec_.bill_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTDOCADDR: Invalid document address specified.');
      END IF;
      
      IF (Cust_Ord_Customer_Address_API.Is_Valid(newrec_.customer_no, newrec_.bill_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDDOCADDR: Document address :P1 is invalid. Check the validity period.', newrec_.bill_addr_no);
      END IF;
   END IF;
   IF (newrec_.customer_quo_no IS NOT NULL) THEN
      IF (Check_Customer_Quo_No___(newrec_.customer_quo_no, newrec_.customer_no)) THEN
         Client_SYS.Add_Warning(lu_name_, 'RFQEXISTS: Customer''s request for quotation number :P1 already exists for this customer. Do you want to save the sales quotation?',newrec_.customer_quo_no);
      END IF;
   END IF;
   
   --Return delivery_leadtime to client.
   Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', newrec_.delivery_leadtime, attr_);
   
   -- Check that percentage quotation_probability is between 0 % and 100 %.
   IF (newrec_.quotation_probability < 0) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_PROBABILITY1: The quotation probability can not be less than 0 %.');
   ELSIF NOT (newrec_.quotation_probability <= 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_PROBABILITY2: The quotation probability can not be more than 100 %.');
   END IF;
   
   -- Check that additional discount is between 0 % and 100 %.
   IF (newrec_.additional_discount < 0) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_DISCOUNT1: Additional Discount % should be greater than 0.');
   ELSIF NOT (newrec_.additional_discount <= 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_DISCOUNT2: Additional Discount should not exceed 100 %.');
   END IF;
   
   IF (newrec_.additional_discount IS NULL) THEN
      newrec_.additional_discount := 0;
   END IF;
   IF (newrec_.jinsui_invoice IS NULL) THEN
      newrec_.jinsui_invoice := Get_Jinsui_Invoice_Defaults___(company_, newrec_.customer_no);
   END IF;
   -- Validate Jinsui Invoice.
   $IF (Component_Jinsui_SYS.INSTALLED) $THEN
      Validate_Jinsui_Constraints___(newrec_, newrec_);
   $END
   IF (newrec_.use_price_incl_tax IS NULL) THEN
      newrec_.use_price_incl_tax := 'FALSE';
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'JINSUI_INVOICE', newrec_.jinsui_invoice);   
   Error_SYS.Check_Not_Null(lu_name_, 'USE_PRICE_INCL_TAX', newrec_.use_price_incl_tax);
   IF (newrec_.ext_transport_calendar_id IS NOT NULL) THEN
      Work_Time_Calendar_API.Check_Not_Generated(newrec_.ext_transport_calendar_id);
   END IF;
   
   -- Validate apply_fix_deliv_freight
   IF (newrec_.apply_fix_deliv_freight = db_true_) THEN
      IF (newrec_.delivery_terms IS NULL OR Order_Delivery_Term_API.Get_Calculate_Freight_Charge(newrec_.delivery_terms) = db_false_) THEN
         Error_SYS.Record_General(lu_name_, 'CANNOTUPDFIXDELFRE: In order to apply fixed delivery freight, there should be a delivery term where Calculate Freight Charge check box is selected.');
      END IF;
   END IF;
   -- Validate Customer tax information for customer type other than Prospect, since prospect customers can have NULL customer tax info.
   IF ((NOT Customer_Tax_Info_API.Exists(newrec_.customer_no, newrec_.ship_addr_no, company_)) AND (Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no) != Customer_Category_API.DB_PROSPECT)) THEN
      Error_SYS.Record_General(lu_name_, 'NOTAXFORADDR: Customer Tax Information has not been defined for the delivery address.');
   END IF;
   Tax_Handling_Order_Util_API.Validate_Calc_Base_In_Struct(company_, newrec_.customer_no, newrec_.ship_addr_no, newrec_.supply_country, newrec_.use_price_incl_tax, newrec_.tax_liability);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     order_quotation_tab%ROWTYPE,
   newrec_ IN OUT order_quotation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   picking_leadtime_           NUMBER;
   work_day_                   DATE := NULL;
   addr_flag_                  VARCHAR2(1) := 'N';
   pay_term_id_                ORDER_QUOTATION_TAB.pay_term_id%TYPE;
   order_exist_                NUMBER := 0;
   freight_map_id_             VARCHAR2(15);
   zone_id_                    VARCHAR2(15);  
   change_line_date_           VARCHAR2(20);
   new_wanted_delivery_date_   DATE;
   new_planned_delivery_date_  DATE;
   delivery_country_code_      VARCHAR2(2);
   dummy_                      NUMBER;
   route_id_                   VARCHAR2(12);
   forward_agent_id_           VARCHAR2(20);
   shipment_type_              VARCHAR2(3);
   ship_inventory_location_no_ VARCHAR2(35);
   updated_from_wizard_        VARCHAR2(5);  
   customer_category_          CUSTOMER_INFO_TAB.customer_category%TYPE;
   agreement_rec_              Customer_Agreement_API.Public_Rec;
   CURSOR find_orders(quotation_no_ IN VARCHAR2) IS
      SELECT COUNT(*)
      FROM   order_quotation_line_tab
      WHERE  quotation_no = quotation_no_
      AND    con_order_no IS NOT NULL;
   
   CURSOR find_quotation_lines(quotation_no_ IN VARCHAR2) IS
      SELECT 1
      FROM   order_quotation_line_tab
      WHERE  quotation_no = quotation_no_
      AND    rowstate IN ('Lost', 'Won', 'CO Created');
BEGIN 
   OPEN find_orders(newrec_.quotation_no );
   FETCH find_orders INTO order_exist_;
   CLOSE find_orders;
   
   IF newrec_.customer_no IS NULL THEN      
      newrec_.customer_no := Get_Customer_No(newrec_.quotation_no);
   END IF;
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);   
   
   IF (Customer_Info_API.Get_Customer_Category_Db(oldrec_.customer_no) = Customer_Category_API.DB_CUSTOMER) AND (customer_category_ = Customer_Category_API.DB_PROSPECT) AND (order_exist_ > 0) THEN
      Error_SYS.Record_General(lu_name_, 'ORDEXIST: Prospect type customer can not be selected since connected orders already exist.');
   END IF;
   
   -- Get new language if available   
   IF (newrec_.language_code IS NULL AND indrec_.language_code) THEN
      -- There is no new value
      newrec_.language_code := oldrec_.language_code;
   END IF;
   
   change_line_date_ := Client_SYS.Get_Item_Value('CHANGE_LINE_DATE', attr_);
   
   IF (change_line_date_ IS NOT NULL) THEN
      new_wanted_delivery_date_  := newrec_.wanted_delivery_date;
      new_planned_delivery_date_ := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('PLANNED_DELIVERY_DATE', attr_));
      Modify_Wanted_Delivery_Date__(newrec_.quotation_no, new_wanted_delivery_date_, new_planned_delivery_date_);
   END IF;
   
   updated_from_wizard_ := Client_SYS.Get_Item_Value('UPDATED_FROM_WIZARD', attr_);
   
   IF (oldrec_.rowstate = 'Closed') THEN
      IF (indrec_.customer_quo_no OR indrec_.cust_ref OR indrec_.delivery_leadtime OR indrec_.label_note OR indrec_.wanted_delivery_date OR indrec_.quotation_probability OR
          indrec_.expiration_date OR indrec_.follow_up_date OR indrec_.quotation_note OR indrec_.request_received_date OR indrec_.answering_date OR indrec_.price_effectivity_date OR
          indrec_.authorize_code OR indrec_.ship_via_code OR indrec_.delivery_terms OR indrec_.agreement_id OR indrec_.customer_no OR indrec_.pay_term_id OR indrec_.market_code OR indrec_.district_code OR
          indrec_.region_code OR indrec_.salesman_code OR indrec_.ship_addr_no OR indrec_.bill_addr_no OR indrec_.tax_liability OR indrec_.print_control_code OR indrec_.picking_leadtime OR indrec_.currency_code ) THEN     
         Error_SYS.Record_General(lu_name_, 'CLOSEDQUOTE: Closed quotation may not be changed.');       
      END IF;      
   END IF;
   
   IF (indrec_.pay_term_id) THEN
      pay_term_id_ := Identity_Invoice_Info_API.Get_Pay_Term_Id(newrec_.company, NVL(newrec_.customer_no_pay, newrec_.customer_no), Party_Type_API.Decode('CUSTOMER'));
      IF ((customer_category_ = Customer_Category_API.DB_CUSTOMER) AND (pay_term_id_ IS NULL))THEN
         -- Cannot enter a Normal customer with no payment terms defined for the customer or the payer.
         Error_SYS.Record_General(lu_name_, 'NO_PAY_TERMS: Payment terms have not been defined for the paying customer :P1.',NVL(newrec_.customer_no_pay, newrec_.customer_no));
      ELSE
         IF (newrec_.pay_term_id IS NOT NULL) THEN
            Payment_Term_API.Exist(newrec_.company, newrec_.pay_term_id);
         ELSIF (customer_category_ = Customer_Category_API.DB_CUSTOMER) THEN
            -- Cannot modify payment terms to null for a Normal customer.
            Error_SYS.Record_General(lu_name_, 'PAY_TERM_NULL: Payment Term must have a value for the paying customer :P1.',NVL(newrec_.customer_no_pay, newrec_.customer_no));
         END IF;
      END IF;   
   END IF;
   
   IF (NVL(newrec_.customer_no_pay, Database_SYS.string_null_) != NVL(oldrec_.customer_no_pay, Database_SYS.string_null_)) THEN
      IF(newrec_.customer_no_pay IS NOT NULL) THEN
         pay_term_id_ := Identity_Invoice_Info_API.Get_Pay_Term_Id(newrec_.company, NVL(newrec_.customer_no_pay, newrec_.customer_no), Party_Type_API.Decode('CUSTOMER'));
         IF (pay_term_id_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NO_PAY_TERMS: Payment terms have not been defined for the paying customer :P1.',NVL(newrec_.customer_no_pay, newrec_.customer_no));
         END IF;
      END IF;   
   END IF;
   
   IF(newrec_.ship_addr_no IS NOT NULL AND indrec_.ship_addr_no) THEN
      IF (customer_category_ = Customer_Category_API.DB_CUSTOMER ) THEN
         Cust_Ord_Customer_Address_API.Exist(newrec_.customer_no, newrec_.ship_addr_no);
      ELSE
         Customer_Info_Address_API.Exist(newrec_.customer_no, newrec_.ship_addr_no);
      END IF;
   END IF;
   
   IF (customer_category_ = Customer_Category_API.DB_CUSTOMER) THEN     
      IF (newrec_.ship_addr_no IS NULL OR newrec_.bill_addr_no IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOSHIPORBILLADDR: Delivery address and Document address should be defined when a customer is defined.');
      END IF;
   END IF;   
   
   IF (newrec_.zone_id IS NOT NULL) THEN
      Freight_Zone_API.Exist(newrec_.freight_map_id, newrec_.zone_id);
   END IF;
   IF (newrec_.apply_fix_deliv_freight IS NULL) THEN
      newrec_.apply_fix_deliv_freight := db_false_;
   END IF;
   
   IF (customer_category_ = Customer_Category_API.DB_PROSPECT) THEN
      IF (newrec_.picking_leadtime IS NULL) THEN
         newrec_.picking_leadtime := Site_Invent_Info_API.Get_Picking_Leadtime(newrec_.contract);
         Client_SYS.Add_To_Attr('PICKING_LEADTIME', newrec_.picking_leadtime, attr_);
      END IF;
      IF (newrec_.delivery_leadtime IS NULL) THEN
         newrec_.delivery_leadtime := 0;
      END IF;
   END IF;
   
   IF (oldrec_.rowstate IN ('Closed','Cancelled')) THEN
      IF (indrec_.customer_tax_usage_type ) THEN     
         Error_SYS.Record_General(lu_name_, 'CCLOSEDQUOTE: The customer tax usage type cannot be changed for a Closed or Cancelled quotation.');       
      END IF;      
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (indrec_.customer_no_pay) AND (newrec_.customer_no_pay IS NOT NULL) AND (TRUNC(Cust_Ord_Customer_API.Get_Date_Del(newrec_.customer_no_pay)) < TRUNC(Site_API.Get_Site_Date(newrec_.contract))) THEN
      Error_SYS.Record_General(lu_name_, 'DATE_EXP_ERROR_PAY: Payer has expired. Check expire date.');
   END IF;
   
   IF (indrec_.customer_no_pay_addr_no) AND (newrec_.customer_no_pay_addr_no IS NOT NULL) AND 
      (Cust_Ord_Customer_Address_API.Is_Bill_Location(newrec_.customer_no_pay, newrec_.customer_no_pay_addr_no) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'NOTDOCADDR: Invalid document address specified.');
   END IF; 
   
   IF ((NVL(oldrec_.vendor_no, ' ') != NVL(newrec_.vendor_no, ' ')) AND (newrec_.rowstate IN ('Cancelled', 'Closed'))) THEN
      Error_SYS.Record_General(lu_name_, 'CANNOTMODIFYSUPP2: The deliver-from supplier cannot be changed for a Closed or Cancelled quotation.');
   END IF;
   
   IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0) THEN
      Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'PICKVALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
   END IF;
   
   IF (customer_category_ = Customer_Category_API.DB_END_CUSTOMER) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDCUSTCATEGORY: Customer :P1 is not of category :P2 or :P3.', newrec_.customer_no, Customer_Category_API.Decode(Customer_Category_API.DB_CUSTOMER), Customer_Category_API.Decode(Customer_Category_API.DB_PROSPECT)); 
   END IF;
   
   Client_SYS.Add_To_Attr('UPDATED_FROM_WIZARD', updated_from_wizard_, attr_ );
   
   IF (oldrec_.rowstate IN ('Closed', 'Cancelled')) THEN
      IF (oldrec_.supply_country != newrec_.supply_country) THEN
         Error_SYS.Record_General(lu_name_, 'SUPCOUNTRYUPDATED1: Supply Country cannot be changed in Closed/Cancelled Quotations.');
      END IF;
   ELSE
      Iso_Country_API.Exist(newrec_.supply_country);
      
      IF (oldrec_.supply_country != newrec_.supply_country) THEN
         Client_SYS.Add_Info(lu_name_, 'SUPCOUNTRYUPDATED2: Changing Supply Country may affect tax information for lines using default information.');
      END IF;
   END IF;
   
   IF (NVL(newrec_.ext_transport_calendar_id, string_null_) != NVL(oldrec_.ext_transport_calendar_id, string_null_)) THEN
      Work_Time_Calendar_API.Check_Not_Generated(newrec_.ext_transport_calendar_id);
   END IF;
   
   -- Check that customer no is defined
   IF (newrec_.customer_no IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'CUSTPROSPECT1: A customer must be defined.');
   END IF;
   IF (newrec_.tax_liability IS NOT NULL AND NOT(newrec_.tax_liability = 'TAX' OR newrec_.tax_liability = 'EXEMPT')) THEN
      IF (newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_FALSE) THEN
         delivery_country_code_ := Cust_Ord_Customer_Address_API.Get_Country_Code(newrec_.customer_no, newrec_.ship_addr_no);
      ELSE 
         delivery_country_code_ := newrec_.ship_addr_country_code;
      END IF; 
      Tax_Handling_Order_Util_API.Validate_Tax_Liability(newrec_.tax_liability, delivery_country_code_);
   END IF; 
   -- Make sure the specified addresses for the order are valid.
   IF (newrec_.bill_addr_no IS NOT NULL) THEN
      IF (NVL(oldrec_.bill_addr_no, string_null_) != NVL(newrec_.bill_addr_no, string_null_)) THEN
         IF (Cust_Ord_Customer_Address_API.Is_Bill_Location(newrec_.customer_no, newrec_.bill_addr_no) = 0) THEN
            Error_SYS.Record_General(lu_name_, 'NOTDOCADDR: Invalid document address specified.');
         END IF;
         
         IF (Cust_Ord_Customer_Address_API.Is_Valid(newrec_.customer_no, newrec_.bill_addr_no) = 0) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDDOCADDR: Document address :P1 is invalid. Check the validity period.', newrec_.bill_addr_no);
         END IF;
      END IF;
   END IF;
   
   IF (newrec_.ship_addr_no IS NOT NULL) THEN
      IF ((NVL(newrec_.ship_addr_no, string_null_) != NVL(oldrec_.ship_addr_no, string_null_)) OR
          (NVL(newrec_.ship_addr_country_code, string_null_) != NVL(oldrec_.ship_addr_country_code, string_null_))) THEN
         IF (Cust_Ord_Customer_Address_API.Is_Ship_Location(newrec_.customer_no, newrec_.ship_addr_no) = 0) THEN
            Error_SYS.Record_General(lu_name_, 'NOTDELADDR: Invalid delivery address specified.');
         END IF;
         
         IF (Cust_Ord_Customer_Address_API.Is_Valid(newrec_.customer_no, newrec_.ship_addr_no) = 0) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDDELADDR: Delivery address :P1 is invalid. Check the validity period.', newrec_.ship_addr_no);
         END IF;
         IF (NVL(newrec_.ship_addr_country_code, string_null_) != NVL(oldrec_.ship_addr_country_code, string_null_) AND
             newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE) THEN
            newrec_.country_code := newrec_.ship_addr_country_code;
         ELSE
            newrec_.country_code := Cust_Ord_Customer_Address_API.Get_Country_Code(newrec_.customer_no, newrec_.ship_addr_no);
         END IF;
         Client_SYS.Set_Item_Value('COUNTRY_CODE', newrec_.country_code, attr_);
      END IF;
   END IF;
   
   IF (newrec_.customer_quo_no IS NOT NULL) AND (newrec_.customer_quo_no != NVL(oldrec_.customer_quo_no, ' ') OR newrec_.customer_no != NVL(oldrec_.customer_no, ' ')) THEN
      IF (Check_Customer_Quo_No___(newrec_.customer_quo_no, newrec_.customer_no)) THEN
         Client_SYS.Add_Warning(lu_name_, 'RFQEXISTS: Customer''s request for quotation number :P1 already exists for this customer. Do you want to save the sales quotation?',newrec_.customer_quo_no);
      END IF;
   END IF;
   -- In case of a customer ( not prospect )
   IF (customer_category_ = Customer_Category_API.DB_CUSTOMER) THEN     
      
      IF (newrec_.customer_no_pay IS NULL) THEN
         IF (newrec_.customer_no_pay_addr_no IS NOT NULL) THEN
            Error_SYS.Item_Update(lu_name_, 'CUSTOMER_NO_PAY_ADDR_NO');
         END IF;
      ELSE
         Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_NO_PAY_ADDR_NO', newrec_.customer_no_pay_addr_no);
      END IF;
      
      -- Checked if the customer_no is changed with the agreement_id. If so no need to fetch the default delivery information again
      -- IF agreement_id has changed, new values for price_list, delivery_terms, delivery_leadtime
      -- and wanted_delivery_date must be fetched.
      
      -- since it has already been fetched from the client validation.
      IF ( (oldrec_.customer_no = newrec_.customer_no) AND ((NVL(oldrec_.agreement_id, string_null_) != NVL(newrec_.agreement_id, string_null_))
                                                            AND (newrec_.agreement_id IS NOT NULL)) ) THEN
         Validate_Customer_Agreement___(newrec_.agreement_id, newrec_.contract, newrec_.customer_no, newrec_.currency_code);
         agreement_rec_ := Customer_Agreement_API.Get(newrec_.agreement_id);
         -- use customer address as single occurence if customer is a prospect
         IF (newrec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE) THEN
            addr_flag_ := 'Y';
         END IF;      
         -- Added IF condition to avoid the call when agreement's Exclude from auto pricing is checked and used by Order/Quotation header is unchecked.
         IF NOT(agreement_rec_.use_by_object_head = 'FALSE' AND agreement_rec_.use_explicit = 'Y') THEN
            Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults(newrec_.ship_via_code, newrec_.delivery_terms, newrec_.del_terms_location, freight_map_id_, zone_id_,
                                                                        newrec_.delivery_leadtime, newrec_.ext_transport_calendar_id, 
                                                                        route_id_, forward_agent_id_, newrec_.picking_leadtime, shipment_type_, ship_inventory_location_no_, newrec_.contract, newrec_.customer_no, 
                                                                        newrec_.ship_addr_no, addr_flag_, newrec_.agreement_id, newrec_.vendor_no);

            Client_SYS.Add_To_Attr('SHIP_VIA_CODE', newrec_.ship_via_code, attr_);
            Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', newrec_.delivery_leadtime, attr_);
            Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', newrec_.ext_transport_calendar_id, attr_);
            Client_SYS.Add_To_Attr('PICKING_LEADTIME', newrec_.picking_leadtime, attr_);
            newrec_.delivery_terms := Customer_Agreement_API.Get_Delivery_Terms(newrec_.agreement_id);
         END IF;

         IF (newrec_.delivery_terms IS NULL) THEN
            newrec_.delivery_terms     := Cust_Ord_Customer_Address_API.Get_Delivery_Terms(newrec_.customer_no, newrec_.ship_addr_no);
            newrec_.del_terms_location := Cust_Ord_Customer_Address_API.Get_Del_Terms_Location(newrec_.customer_no, newrec_.ship_addr_no);
         END IF;
         Client_SYS.Add_To_Attr('DELIVERY_TERMS', newrec_.delivery_terms, attr_);
         Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', newrec_.del_terms_location, attr_);
         
         work_day_ := Work_Time_Calendar_API.Get_End_Date(Site_API.Get_Dist_Calendar_Id(newrec_.contract), Site_API.Get_Site_Date(newrec_.contract), picking_leadtime_);
         -- Add default time from delivery address
         work_day_ := Construct_Delivery_Time___(work_day_, newrec_.customer_no, newrec_.ship_addr_no);
         Cust_Ord_Date_Calculation_API.Fetch_Calendar_End_Date(work_day_, newrec_.ext_transport_calendar_id, work_day_, newrec_.delivery_leadtime);
         newrec_.wanted_delivery_date := greatest(work_day_, newrec_.wanted_delivery_date);
         Client_SYS.Set_Item_Value('WANTED_DELIVERY_DATE', newrec_.wanted_delivery_date, attr_);
      END IF; 
   END IF;
   
   -- Check that percentage quotation_probability is between 0 % and 100 %.
   IF (newrec_.quotation_probability < 0) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_PROBABILITY1: The quotation probability can not be less than 0 %.');
   ELSIF NOT (newrec_.quotation_probability <= 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_PROBABILITY2: The quotation probability can not be more than 100 %.');
   END IF;
   
   -- Check that additional discount is between 0 % and 100 %.
   IF (newrec_.additional_discount < 0) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_DISCOUNT1: Additional Discount % should be greater than 0.');
   ELSIF NOT (newrec_.additional_discount <= 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_DISCOUNT2: Additional Discount should not exceed 100 %.');
   END IF;
   
   IF (newrec_.additional_discount IS NULL) THEN
      newrec_.additional_discount := 0;
      Client_SYS.Set_Item_Value('ADDITIONAL_DISCOUNT', '0', attr_);
   END IF;
   
   -- Check the line discount totals
   IF (newrec_.additional_discount > 0) THEN
      Order_Quotation_Line_API.Check_Line_Total_Discount_pct(newrec_.quotation_no,newrec_.additional_discount);
   END IF;
   
   -- Validate Jinsui Invoice.
   $IF (Component_Jinsui_SYS.INSTALLED) $THEN
      Validate_Jinsui_Constraints___(newrec_, oldrec_);
   $END
   
   IF (newrec_.use_price_incl_tax IS NULL) THEN
      newrec_.use_price_incl_tax := 'FALSE';
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'USE_PRICE_INCL_TAX', newrec_.use_price_incl_tax);
   -- Validate apply_fix_deliv_freight
   IF (newrec_.apply_fix_deliv_freight != oldrec_.apply_fix_deliv_freight) OR 
      (NVL(newrec_.delivery_terms, string_null_) != NVL(oldrec_.delivery_terms, string_null_)) THEN
      IF (newrec_.apply_fix_deliv_freight = db_true_) AND
         (newrec_.delivery_terms IS NULL OR Order_Delivery_Term_API.Get_Calculate_Freight_Charge(newrec_.delivery_terms) = db_false_) THEN
         Error_SYS.Record_General(lu_name_, 'CANNOTUPDFIXDELFRE: In order to apply fixed delivery freight, there should be a delivery term where Calculate Freight Charge check box is selected.');
      END IF;
   END IF;
   
   IF (NVL(oldrec_.customer_no, string_null_) != NVL(newrec_.customer_no, string_null_)) THEN
      OPEN find_quotation_lines(newrec_.quotation_no);
      FETCH find_quotation_lines INTO dummy_;
      IF (find_quotation_lines%FOUND) THEN
         CLOSE find_quotation_lines;
         Error_SYS.Record_General(lu_name_, 'QUOTELINENOTEXIST: The customer on the sales quotation cannot be changed when quotation line(s) exists in status CO Created or Won/Lost.');
      END IF;
      CLOSE find_quotation_lines;
   END IF;
   
   -- Check the customer reference is already used as a main contact and if so remove it
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      IF (NVL(newrec_.cust_ref, string_null_) != NVL(oldrec_.cust_ref, string_null_)) THEN
         IF Business_Object_Contact_API.Is_Main_Contact_for_Object(oldrec_.customer_no, Business_Object_Type_API.DB_CUSTOMER, oldrec_.cust_ref, oldrec_.quotation_no, 'SALES_QUOTATION') THEN
            Business_Object_Contact_API.Modify_Main_Contact(oldrec_.customer_no, Business_Object_Type_API.DB_CUSTOMER, NULL, NULL, oldrec_.quotation_no, 'SALES_QUOTATION', FALSE);
         END IF;
      END IF;  
   $END
END Check_Update___;


PROCEDURE Check_Customer_No_Ref___ (
   newrec_ IN OUT NOCOPY order_quotation_tab%ROWTYPE )
IS
   customer_category_ CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   IF (newrec_.customer_no IS NOT NULL) THEN
      customer_category_ := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);
      IF customer_category_ = Customer_Category_API.DB_CUSTOMER THEN
         Cust_Ord_Customer_API.Exist(newrec_.customer_no);
         IF (TRUNC(Cust_Ord_Customer_API.Get_Date_Del(newrec_.customer_no)) < TRUNC(Site_API.Get_Site_Date(newrec_.contract))) THEN
            Error_SYS.Record_General(lu_name_, 'DATE_EXP_ERROR_CUS: Customer has expired. Check expire date.');
         END IF;
      ELSIF (customer_category_ = Customer_Category_API.DB_END_CUSTOMER) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDCUSTCATEGORY: Customer :P1 is not of category :P2 or :P3.', newrec_.customer_no, Customer_Category_API.Decode(Customer_Category_API.DB_CUSTOMER), Customer_Category_API.Decode(Customer_Category_API.DB_PROSPECT)); 
      ELSE
         Customer_Info_API.Exist(newrec_.customer_no, customer_category_);
      END IF;
   END IF;
END Check_Customer_No_Ref___;


-- Check_Cancel_Reason_Ref___
--   Perform validation on the CancelReasonRef reference.
PROCEDURE Check_Cancel_Reason_Ref___ (
   newrec_ IN OUT order_quotation_tab%ROWTYPE )
IS
BEGIN
   Order_Cancel_Reason_API.Exist( newrec_.cancel_reason, Reason_Used_By_API.DB_SALES_QUOTATION );
END Check_Cancel_Reason_Ref___;

-- Check_Reason_Id_Ref___
--   Perform validation on the ReasonIdRef reference.
PROCEDURE Check_Reason_Id_Ref___ (
   newrec_ IN OUT order_quotation_tab%ROWTYPE )
IS
   lose_win_ VARCHAR2(20);
BEGIN
   IF ( newrec_.closed_status = Lost_Won_API.DB_LOST ) THEN
      lose_win_ := Lose_Win_API.DB_LOSE;
   ELSIF ( newrec_.closed_status = Lost_Won_API.DB_WON ) THEN
      lose_win_ := Lose_Win_API.DB_WIN;
   END IF;
   
   Lose_Win_Reason_API.Exist( newrec_.reason_id, Reason_Used_By_API.DB_SALES_QUOTATION, lose_win_ );
END Check_Reason_Id_Ref___;


PROCEDURE Update_Bo_Status___ (
   rec_  IN OUT order_quotation_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS    
BEGIN   
   $IF Component_Crm_SYS.INSTALLED $THEN       
      IF(Business_Opportunity_API.Check_Exist(rec_.business_opportunity_no)) THEN             
         -- Update BO status
         IF rec_.rowstate = 'Cancelled' THEN             
            Business_Opportunity_API.Reference_Cancelled(rec_.business_opportunity_no); 
         ELSIF rec_.rowstate = 'Lost' THEN             
            Business_Opportunity_API.Reference_Lost(rec_.business_opportunity_no);  
         END IF;      
      END IF;            
   $ELSE
      NULL;
   $END   
END Update_Bo_Status___;


-- Build_Attr_Copy_Quotation___ 
-- This method is used to build the attr_ which is used in method Copy_Quotation__.    
FUNCTION Build_Attr_Copy_Quotation___ (  
                                         copyrec_              IN ORDER_QUOTATION_TAB%ROWTYPE,
                                         to_quotation_no_      IN VARCHAR2,
                                         wanted_delivery_date_ IN DATE,
                                         request_receipt_date_ IN DATE,
                                         answering_date_       IN DATE,
                                         expiration_date_      IN DATE,   
                                         price_effective_date_ IN DATE,
                                         copy_general_         IN VARCHAR2,
                                         copy_adresses_        IN VARCHAR2,
                                         copy_delivery_info_   IN VARCHAR2,
                                         copy_misc_info_       IN VARCHAR2,
                                         copy_notes_           IN VARCHAR2,
                                         copy_pricing_         IN VARCHAR2) RETURN VARCHAR2
IS
   attr_         VARCHAR2(32000);
BEGIN
   Client_SYS.Add_To_Attr('QUOTATION_NO', to_quotation_no_, attr_);      
   Client_SYS.Add_To_Attr('CONTRACT', copyrec_.contract, attr_);
   Client_SYS.Add_To_Attr('COMPANY', copyrec_.company, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', copyrec_.customer_no, attr_);
   Client_SYS.Add_To_Attr('AUTHORIZE_CODE', copyrec_.authorize_code, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_CODE', copyrec_.currency_code, attr_);
   Client_SYS.Add_To_Attr('QUOTATION_PROBABILITY', copyrec_.quotation_probability, attr_); 
   Client_SYS.Add_To_Attr('CUST_REF', copyrec_.cust_ref, attr_); 
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX', Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Order(copyrec_.contract), attr_);
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', wanted_delivery_date_, attr_);
   Client_SYS.Add_To_Attr('REQUEST_RECEIVED_DATE', request_receipt_date_, attr_);
   Client_SYS.Add_To_Attr('ANSWERING_DATE', answering_date_, attr_);
   Client_SYS.Add_To_Attr('EXPIRATION_DATE', expiration_date_, attr_);
   Client_SYS.Add_To_Attr('PRICE_EFFECTIVITY_DATE', price_effective_date_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', copyrec_.customer_tax_usage_type, attr_);
   
   IF (copy_general_ = Fnd_Boolean_API.DB_TRUE) THEN
      Client_SYS.Add_To_Attr('LANGUAGE_CODE', copyrec_.language_code, attr_);                         
   END IF;
   
   IF (copy_adresses_ = Fnd_Boolean_API.DB_TRUE) THEN
      Client_SYS.Add_To_Attr('SHIP_ADDR_NO', copyrec_.ship_addr_no, attr_);
      Client_SYS.Add_To_Attr('BILL_ADDR_NO', copyrec_.bill_addr_no, attr_);
      Client_SYS.Add_To_Attr('SINGLE_OCC_ADDR_FLAG', copyrec_.single_occ_addr_flag, attr_);
      IF copyrec_.single_occ_addr_flag = 'TRUE' THEN 
         Client_SYS.Add_To_Attr('SHIP_ADDR_NAME', copyrec_.ship_addr_name, attr_);
         Client_SYS.Add_To_Attr('SHIP_ADDRESS1', copyrec_.ship_address1, attr_);
         Client_SYS.Add_To_Attr('SHIP_ADDRESS2', copyrec_.ship_address2, attr_);
         Client_SYS.Add_To_Attr('SHIP_ADDRESS3', copyrec_.ship_address3, attr_);
         Client_SYS.Add_To_Attr('SHIP_ADDRESS4', copyrec_.ship_address4, attr_);
         Client_SYS.Add_To_Attr('SHIP_ADDRESS5', copyrec_.ship_address5, attr_);
         Client_SYS.Add_To_Attr('SHIP_ADDRESS6', copyrec_.ship_address6, attr_);
         Client_SYS.Add_To_Attr('SHIP_ADDR_ZIP_CODE', copyrec_.ship_addr_zip_code, attr_);
         Client_SYS.Add_To_Attr('SHIP_ADDR_CITY', copyrec_.ship_addr_city, attr_);
         Client_SYS.Add_To_Attr('SHIP_ADDR_STATE', copyrec_.ship_addr_state, attr_);
         Client_SYS.Add_To_Attr('SHIP_ADDR_COUNTY', copyrec_.ship_addr_county, attr_);
         Client_SYS.Add_To_Attr('SHIP_ADDR_IN_CITY', copyrec_.ship_addr_in_city, attr_);
         Client_SYS.Add_To_Attr('SHIP_ADDR_COUNTRY_CODE', copyrec_.ship_addr_country_code, attr_);
         Client_SYS.Add_To_Attr('VAT_FREE_VAT_CODE', copyrec_.vat_free_vat_code, attr_);
      END IF;
   END IF;
   
   IF (copy_delivery_info_ = Fnd_Boolean_API.DB_TRUE) THEN
      Client_SYS.Add_To_Attr('SHIP_VIA_CODE', copyrec_.ship_via_code, attr_);
      Client_SYS.Add_To_Attr('DELIVERY_TERMS', copyrec_.delivery_terms, attr_);
      Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', copyrec_.del_terms_location, attr_);
      Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', copyrec_.forward_agent_id, attr_);
      Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', copyrec_.ext_transport_calendar_id, attr_);
      Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', copyrec_.delivery_leadtime, attr_);
      Client_SYS.Add_To_Attr('PICKING_LEADTIME', copyrec_.picking_leadtime, attr_);
      Client_SYS.Add_To_Attr('SALESMAN_CODE', copyrec_.salesman_code, attr_);
      Client_SYS.Add_To_Attr('VENDOR_NO', copyrec_.vendor_no, attr_);
   END IF;
   
   IF (copy_misc_info_ = Fnd_Boolean_API.DB_TRUE) THEN
      Client_SYS.Add_To_Attr('PAY_TERM_ID', copyrec_.pay_term_id, attr_);
      Client_SYS.Add_To_Attr('AGREEMENT_ID', copyrec_.agreement_id, attr_);
      Client_SYS.Add_To_Attr('SUPPLY_COUNTRY', Iso_Country_API.Decode(copyrec_.supply_country), attr_);
      Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', copyrec_.main_representative_id, attr_);         
      Client_SYS.Add_To_Attr('MARKET_CODE', copyrec_.market_code, attr_);
      Client_SYS.Add_To_Attr('REGION_CODE', copyrec_.region_code, attr_);
      Client_SYS.Add_To_Attr('DISTRICT_CODE', copyrec_.district_code, attr_);
      Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX', Fnd_Boolean_API.Decode(copyrec_.use_price_incl_tax), attr_);
      Client_SYS.Add_To_Attr('TAX_LIABILITY', copyrec_.tax_liability, attr_);
      Client_SYS.Add_To_Attr('JINSUI_INVOICE', Fnd_Boolean_API.Decode(copyrec_.jinsui_invoice), attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY', copyrec_.customer_no_pay, attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY_ADDR_NO', copyrec_.customer_no_pay_addr_no, attr_);
      Client_SYS.Add_To_Attr('CLASSIFICATION_STANDARD', copyrec_.classification_standard, attr_);
      Client_SYS.Add_To_Attr('REBATE_CUSTOMER', copyrec_.rebate_customer, attr_);
   END IF;
   
   IF (copy_notes_ = Fnd_Boolean_API.DB_TRUE) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', copyrec_.note_text, attr_);
      Client_SYS.Add_To_Attr('QUOTATION_NOTE', copyrec_.quotation_note, attr_);
   END IF;
   
   IF (copy_pricing_ = Fnd_Boolean_API.DB_TRUE) THEN
      Client_SYS.Add_To_Attr('ADDITIONAL_DISCOUNT', copyrec_.additional_discount, attr_);
   END IF;
   
   RETURN attr_;
END Build_Attr_Copy_Quotation___;


-- Build_Attr_For_New___ 
-- This method is used to build the attr_ which is used in method New. 
FUNCTION Build_Attr_For_New___ (
   attr_ IN VARCHAR2) RETURN VARCHAR2 
IS
   new_attr_                VARCHAR2(32000);
   ptr_                     NUMBER;
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(2000);
   supply_country_db_       VARCHAR2(2);
   supply_country_          VARCHAR2(200);
   contract_                VARCHAR2(5);
   customer_no_             VARCHAR2(20);
   customer_category_       CUSTOMER_INFO_TAB.customer_category%TYPE;
   use_price_incl_tax_db_   VARCHAR2(20);
BEGIN
   -- Retrieve the default attribute values.
   Prepare_Insert___(new_attr_);
   
   --Replace the default attribute values with the ones passed in the inparameterstring.
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
      IF (name_ = 'SUPPLY_COUNTRY_DB') THEN
         supply_country_db_ := value_;
      ELSIF (name_ = 'SUPPLY_COUNTRY') THEN
         supply_country_ := value_;
      ELSIF (name_ = 'CUSTOMER_NO') THEN
         customer_no_ := value_;
      ELSIF (name_ = 'USE_PRICE_INCL_TAX_DB') THEN
         use_price_incl_tax_db_ := value_;
      END IF;     
   END LOOP;
   
   contract_ := Client_SYS.Get_Item_Value('CONTRACT', new_attr_);
   
   IF ((supply_country_db_ IS NULL) AND (supply_country_ IS NULL)) THEN
      IF (contract_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('SUPPLY_COUNTRY', Company_Site_API.Get_Country(contract_), new_attr_);
      END IF;
   ELSE
      IF (supply_country_ IS NULL) THEN
         Client_SYS.Set_Item_Value('SUPPLY_COUNTRY', Iso_Country_API.Decode(supply_country_db_), new_attr_);
      END IF;
   END IF; 
   
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(customer_no_);
   
   IF use_price_incl_tax_db_ IS NULL THEN 
      IF customer_category_ = Customer_Category_API.DB_PROSPECT THEN
         Client_SYS.Set_Item_Value('USE_PRICE_INCL_TAX_DB', NVL(Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(customer_no_, Site_API.Get_Company(contract_)),Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(contract_)), new_attr_);
      ELSE
         Client_SYS.Set_Item_Value('USE_PRICE_INCL_TAX_DB', Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(customer_no_, Site_API.Get_Company(contract_)), new_attr_);
      END IF;
   END IF;
   
	RETURN new_attr_;
END Build_Attr_For_New___;


-- Build_Attr_Create_Ord_Head___ 
-- This method is used to build the attr_ which is used in method Create_Order_Head.
FUNCTION Build_Attr_Create_Ord_Head___ (
   rec_                          IN ORDER_QUOTATION_TAB%ROWTYPE,
   customer_po_no_             IN VARCHAR2,
   order_id_                   IN VARCHAR2,
   create_from_header_         IN VARCHAR2,
   wanted_del_date_            IN DATE,
   quotation_no_               IN VARCHAR2,
   limit_sales_to_assortments_ IN VARCHAR2) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   -- Create attribute string for creating header
   Client_SYS.Clear_Attr( attr_ );
   Client_SYS.Add_To_Attr( 'CONTRACT', rec_.contract, attr_ );
   Client_SYS.Add_To_Attr( 'LANGUAGE_CODE', rec_.language_code, attr_ );
   Client_SYS.Add_To_Attr( 'AUTHORIZE_CODE', rec_.authorize_code, attr_ );
   Client_SYS.Add_To_Attr( 'COUNTRY_CODE', rec_.country_code, attr_ );
   Client_SYS.Add_To_Attr( 'CURRENCY_CODE', rec_.currency_code, attr_ );
   Client_SYS.Add_To_Attr( 'CUSTOMER_NO', rec_.customer_no, attr_ );
   IF (rec_.delivery_terms IS NOT NULL) THEN
      Client_SYS.Add_To_Attr( 'DELIVERY_TERMS', rec_.delivery_terms, attr_ );
   END IF;
   Client_SYS.Add_To_Attr( 'DISTRICT_CODE', rec_.district_code, attr_ );
   Client_SYS.Add_To_Attr( 'MARKET_CODE', rec_.market_code, attr_ );
   Client_SYS.Add_To_Attr( 'NOTE_ID', rec_.note_id, attr_ );
   Client_SYS.Add_To_Attr( 'PAY_TERM_ID', rec_.pay_term_id, attr_ );
   Client_SYS.Add_To_Attr( 'REGION_CODE', rec_.region_code, attr_ );
   Client_SYS.Add_To_Attr( 'SALESMAN_CODE', rec_.salesman_code, attr_ );
   Client_SYS.Add_To_Attr( 'VENDOR_NO', rec_.vendor_no, attr_ );
   Client_SYS.Add_To_Attr( 'SHIP_VIA_CODE', rec_.ship_via_code, attr_ );
   Client_SYS.Add_To_Attr( 'EXT_TRANSPORT_CALENDAR_ID', rec_.ext_transport_calendar_id, attr_ );
   Client_SYS.Add_To_Attr( 'CUST_REF', rec_.cust_ref, attr_ );
   IF (rec_.del_terms_location IS NOT NULL) THEN
      Client_SYS.Add_To_Attr( 'DEL_TERMS_LOCATION', rec_.del_terms_location, attr_ );
   END IF;
   Client_SYS.Add_To_Attr( 'NOTE_TEXT', rec_.note_text, attr_ );
   Client_SYS.Add_To_Attr( 'WANTED_DELIVERY_DATE', wanted_del_date_, attr_ );
   IF (Customer_Agreement_API.Is_Valid(rec_.agreement_id, rec_.contract, rec_.customer_no, rec_.currency_code) = 1) THEN
      Client_SYS.Add_To_Attr( 'AGREEMENT_ID', rec_.agreement_id, attr_ );
   ELSE
      Client_SYS.Add_To_Attr( 'AGREEMENT_ID', to_char(NULL), attr_ );
   END IF;
   Client_SYS.Add_To_Attr( 'CUSTOMER_NO_PAY', rec_.customer_no_pay, attr_ );
   Client_SYS.Add_To_Attr( 'CUSTOMER_NO_PAY_ADDR_NO', rec_.customer_no_pay_addr_no, attr_ );
   Client_SYS.Add_To_Attr( 'CUSTOMER_PO_NO', customer_po_no_, attr_);
   Client_SYS.Add_To_Attr( 'EXTERNAL_REF', rec_.external_ref, attr_ );
   Client_SYS.Add_To_Attr( 'DATE_ENTERED', rec_.date_entered, attr_ );
   Client_SYS.Add_To_Attr( 'DELIVERY_LEADTIME', rec_.delivery_leadtime, attr_ );
   Client_SYS.Add_To_Attr( 'PICKING_LEADTIME', rec_.picking_leadtime, attr_ );
   Client_SYS.Add_To_Attr( 'PICKING_LEADTIME', rec_.picking_leadtime, attr_ );
   Client_SYS.Add_To_Attr( 'LABEL_NOTE', rec_.label_note, attr_ );
   Client_SYS.Add_To_Attr( 'ORDER_ID', order_id_, attr_ );
   Client_SYS.Add_To_Attr( 'BILL_ADDR_NO', rec_.bill_addr_no, attr_ );
   Client_SYS.Add_To_Attr( 'SHIP_ADDR_NO', rec_.ship_addr_no, attr_ );
   Client_SYS.Add_To_Attr( 'PRINT_CONTROL_CODE', rec_.print_control_code, attr_ );
   Client_SYS.Add_To_Attr( 'ADDITIONAL_DISCOUNT', rec_.additional_discount, attr_ );
   Client_SYS.Add_To_Attr( 'TAX_LIABILITY', rec_.tax_liability, attr_);   
   Client_SYS.Add_To_Attr( 'DEFAULT_CHARGES', db_false_, attr_);
   Client_SYS.Add_To_Attr( 'JINSUI_INVOICE_DB', rec_.jinsui_invoice, attr_);
   Client_SYS.Add_To_Attr( 'CLASSIFICATION_STANDARD', rec_.classification_standard, attr_);
   Client_SYS.Add_To_Attr( 'REBATE_CUSTOMER', rec_.rebate_customer, attr_);
   Client_SYS.Add_To_Attr( 'SUPPLY_COUNTRY_DB', rec_.supply_country, attr_);
   Client_SYS.Add_To_Attr( 'USE_PRICE_INCL_TAX_DB', rec_.use_price_incl_tax, attr_);
   Client_SYS.Add_To_Attr( 'FORWARD_AGENT_ID', rec_.forward_agent_id, attr_ );
   IF (create_from_header_ = db_true_) THEN      
      IF (rec_.apply_fix_deliv_freight = db_true_ AND (Co_Created_Line_Exist(quotation_no_) = 0)) THEN         
         Client_SYS.Add_To_Attr( 'APPLY_FIX_DELIV_FREIGHT_DB', rec_.apply_fix_deliv_freight, attr_);
         Client_SYS.Add_To_Attr( 'FIX_DELIV_FREIGHT', rec_.fix_deliv_freight, attr_);
      END IF;
   END IF;
   IF rec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE THEN 
      Client_SYS.Add_To_Attr( 'ADDR_FLAG_DB', 'Y', attr_ );
   ELSE 
      Client_SYS.Add_To_Attr( 'ADDR_FLAG_DB', 'N', attr_ );
   END IF ;
   
   Client_SYS.Add_To_Attr( 'SOURCE_ORDER', 'CQ', attr_ );
   Client_SYS.Add_To_Attr( 'QUOTATION_NO', rec_.quotation_no, attr_ );
   Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE',rec_.customer_tax_usage_type ,attr_);
   Client_SYS.Add_To_Attr( 'FREE_OF_CHG_TAX_PAY_PARTY_DB', rec_.free_of_chg_tax_pay_party, attr_ );
   Client_SYS.Add_To_Attr( 'B2B_ORDER_DB', rec_.b2b_order, attr_ );
   Client_SYS.Add_To_Attr( 'LIMIT_SALES_TO_ASSORTMENTS_DB', limit_sales_to_assortments_, attr_ );
   
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      IF (rec_.main_representative_id IS NOT NULL) THEN
         Client_SYS.Add_To_Attr( 'MAIN_REPRESENTATIVE_ID', rec_.main_representative_id, attr_ );
      END IF;
   $END
   
	RETURN attr_; 
END Build_Attr_Create_Ord_Head___;

---------------------------------------------------------------------
-- Tax_Paying_Party_Changed___
--    Calculates and modifies free_of_charge_tax_basis after changing
--    the free of charge tax paying party on the quotation header.
---------------------------------------------------------------------
PROCEDURE Tax_Paying_Party_Changed___ (
   newrec_ IN ORDER_QUOTATION_TAB%ROWTYPE)
IS
   free_of_charge_tax_basis_  NUMBER;
   CURSOR get_free_of_charge_lines IS
      SELECT *
      FROM  ORDER_QUOTATION_LINE_TAB
      WHERE quotation_no = newrec_.quotation_no
      AND   free_of_charge  = 'TRUE';
BEGIN
   FOR rec_ IN get_free_of_charge_lines LOOP
      Tax_Handling_Order_Util_API.Calc_And_Save_Foc_Tax_Basis(free_of_charge_tax_basis_,
                                                              Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                              newrec_.quotation_no,
                                                              rec_.line_no, 
                                                              rec_.rel_no, 
                                                              rec_.line_item_no,
                                                              '*',
                                                              rec_.cost,
                                                              rec_.part_price,
                                                              rec_.revised_qty_due, 
                                                              NVL(newrec_.customer_no_pay, rec_.customer_no),
                                                              rec_.contract,
                                                              newrec_.currency_code,
                                                              NULL,
                                                              'TRUE');
   END LOOP;
END Tax_Paying_Party_Changed___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
-- Set_Quotation_Lost__
--   Set lose information to quotation header and change state to closed.
PROCEDURE Set_Quotation_Lost__ (
   info_         OUT VARCHAR2,
   quotation_no_ IN  VARCHAR2,
   reason_id_    IN  VARCHAR2,
   lost_to_      IN  VARCHAR2,
   lost_note_    IN  VARCHAR2 )
IS
   attr_   VARCHAR2(32000);
   objid_  ORDER_QUOTATION.objid%TYPE;
   objver_ ORDER_QUOTATION.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objver_, quotation_no_);
   Client_SYS.Clear_Attr( attr_ );
   Client_SYS.Add_To_Attr('REASON_ID', reason_id_, attr_ );
   Client_SYS.Add_To_Attr('LOST_TO', lost_to_, attr_ );
   Client_SYS.Add_To_Attr('LOSE_WIN_REJECT_NOTE', lost_note_, attr_ );
   Client_SYS.Add_To_Attr('CLOSED_STATUS_DB', 'LOST', attr_ );
   Quotation_Lost__(info_, objid_, objver_, attr_, 'DO');
END Set_Quotation_Lost__;


-- Set_Quotation_Won__
--   Set won information to quotation header and change state to Won.
PROCEDURE Set_Quotation_Won__ (
   info_         OUT VARCHAR2,
   quotation_no_ IN  VARCHAR2,
   reason_id_    IN  VARCHAR2,
   won_note_     IN  VARCHAR2 )
IS
   attr_    VARCHAR2(32000);
   objid_   ORDER_QUOTATION.objid%TYPE;
   objver_  ORDER_QUOTATION.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objver_, quotation_no_);
   Client_SYS.Clear_Attr( attr_ );
   Client_SYS.Add_To_Attr('REASON_ID', reason_id_, attr_ );
   Client_SYS.Add_To_Attr('LOSE_WIN_REJECT_NOTE', won_note_, attr_ );
   Quotation_Won__(info_, objid_, objver_, attr_, 'DO');
END Set_Quotation_Won__;


-- Set_Quotation_Close__
--   Set close information in the quotation header and change state to Closed.
PROCEDURE Set_Quotation_Close__  (
   info_             OUT VARCHAR2,
   quotation_no_     IN  VARCHAR2,
   closed_status_db_ IN  VARCHAR2,
   reason_id_        IN  VARCHAR2,
   lose_win_note_    IN  VARCHAR2,
   lost_to_          IN  VARCHAR2)
IS
   attr_   VARCHAR2(32000);
   objid_  ORDER_QUOTATION.objid%TYPE;
   objver_ ORDER_QUOTATION.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objver_, quotation_no_);
   Client_SYS.Clear_Attr( attr_ );
   Client_SYS.Add_To_Attr('REASON_ID', reason_id_, attr_ );
   Client_SYS.Add_To_Attr('LOSE_WIN_REJECT_NOTE', lose_win_note_, attr_ );
   Client_SYS.Add_To_Attr('LOST_TO', lost_to_, attr_ );
   Client_SYS.Add_To_Attr('CLOSED_STATUS_DB', closed_status_db_, attr_ );
   Close__(info_, objid_, objver_, attr_, 'DO');
END Set_Quotation_Close__ ;


-- Calculate_Discount__
--   For not previos calculated quotation, calculate discount.
PROCEDURE Calculate_Discount__ (
   quotation_no_ IN VARCHAR2 )
IS
   objstate_ ORDER_QUOTATION_TAB.rowstate%TYPE;
   
   CURSOR get_attr IS
      SELECT rowstate
      FROM   ORDER_QUOTATION_TAB
      WHERE quotation_no = quotation_no_
      AND   calc_disc_flag = 'TRUE';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO objstate_;
   IF (get_attr%FOUND) THEN
      CLOSE get_attr;
      IF (objstate_ NOT IN ('Cancelled', 'Closed')) THEN
         Calculate_Line_Disc___(quotation_no_);
         Modify_Calc_Disc_Flag(quotation_no_, db_false_);
      END IF;
   ELSE
      CLOSE get_attr;
   END IF;
END Calculate_Discount__;


-- Check_Payment_Term__
--   Checks if the payment_term exists. If found, print an error message.
--   Used for restricted delete check when removing an payment_term (ACCRUL-module).
PROCEDURE Check_Payment_Term__ (
   key_list_ IN VARCHAR2 )
IS
   company_     VARCHAR2(20);
   pay_term_id_ ORDER_QUOTATION_TAB.pay_term_id%TYPE;
   found_       NUMBER;
   
   CURSOR exist_control IS
      SELECT 1
      FROM   ORDER_QUOTATION_TAB
      WHERE  Site_API.Get_Company(contract) = company_
      AND    pay_term_id = pay_term_id_;
BEGIN
   company_     := substr(key_list_, 1, instr(key_list_, '^') - 1);
   pay_term_id_ := substr(key_list_, instr(key_list_, '^') + 1, instr(key_list_, '^' , 1, 2) - (instr(key_list_, '^') + 1));
   
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   IF (found_ = 1) THEN
      Error_SYS.Record_General(lu_name_, 'NO_PAY_TERM: Payment Term :P1 exists on one or several Order Quotation(s)', pay_term_id_ );
   END IF;
END Check_Payment_Term__;


-- Exist_Charges__
--   Returns whether or not charges are used on a quotation.
@UncheckedAccess
FUNCTION Exist_Charges__ (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM ORDER_QUOTATION_CHARGE_TAB
      WHERE quotation_no = quotation_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN found_;
END Exist_Charges__;


-- Get_Customer_Defaults__
--   Called on validation of customer_no in OrderQuotation.apt customer order client
--   form. It retrieves the default data using customer number and customer's delivery
--   and document addresses.
--   Fields that has to added to the attr_ string before calling this method:
PROCEDURE Get_Customer_Defaults__ (
   attr_ IN OUT VARCHAR2)
IS
   customer_no_ ORDER_QUOTATION_TAB.customer_no%TYPE := Client_SYS.Get_Item_Value('CUSTOMER_NO', attr_);
BEGIN
   -- Check Access for the customer before it fetch all the defult values.
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      IF Rm_Acc_Usage_API.Possible_To_Insert('OrderQuotation', NULL, 'DO', NULL, customer_no_) = FALSE THEN
         Rm_Acc_Usage_API.Raise_No_Access('OrderQuotation', NULL, customer_no_);
      END IF;
   $END
   
   IF (Client_SYS.Get_Item_Value('SHIP_ADDR_NO', attr_) IS NULL) THEN
      Client_SYS.Set_Item_Value('SHIP_ADDR_NO', Cust_Ord_Customer_API.Get_Delivery_Address(customer_no_), attr_);      
   END IF;
   IF (Client_SYS.Get_Item_Value('BILL_ADDR_NO', attr_) IS NULL) THEN
      Client_SYS.Set_Item_Value('BILL_ADDR_NO', Cust_Ord_Customer_API.Get_Document_Address(customer_no_), attr_);
   END IF;
   
   Get_Quote_Defaults___(attr_);
   -- To avoid duplicate info messages in client, clear info string here.
   Client_SYS.Clear_Info;
END Get_Customer_Defaults__;


-- Get_Total_Base_Charge__
--   Get the total charge amount on the quotation in base currency.
@UncheckedAccess
FUNCTION Get_Total_Base_Charge__ (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_base_charge_ NUMBER := 0;
   CURSOR get_charges IS
      SELECT quotation_charge_no
        FROM  ORDER_QUOTATION_CHARGE_TAB     
       WHERE quotation_no = quotation_no_;
BEGIN
   FOR rec_ IN get_charges LOOP
      total_base_charge_ := Order_Quotation_Charge_API.Get_Total_Base_Charged_Amount(quotation_no_, rec_.quotation_charge_no) +  total_base_charge_;
   END LOOP;
   RETURN NVL(total_base_charge_, 0);
END Get_Total_Base_Charge__;


-- Get_Total_Qty__
--   Retrive the total line_total_qty for the specified quotation
@UncheckedAccess
FUNCTION Get_Total_Qty__ (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_qty_ NUMBER;
   
   CURSOR get_totals IS
      SELECT SUM(line_total_qty)
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  rowstate != 'Cancelled'
      AND    line_item_no <= 0
      AND    quotation_no = quotation_no_;
BEGIN
   OPEN get_totals;
   FETCH get_totals INTO total_qty_;
   CLOSE get_totals;
   
   RETURN total_qty_;
END Get_Total_Qty__;


-- Get_Total_Sale_Charge__
--   Get the total charge amount on the quotation in quotation currency.
@UncheckedAccess
FUNCTION Get_Total_Sale_Charge__ (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_sale_charge_ NUMBER := 0;
   CURSOR get_charges IS
      SELECT quotation_charge_no
        FROM  ORDER_QUOTATION_CHARGE_TAB     
       WHERE quotation_no = quotation_no_;
BEGIN
   FOR rec_ IN get_charges LOOP
      total_sale_charge_ := Order_Quotation_Charge_API.Get_Total_Charged_Amount(quotation_no_, rec_.quotation_charge_no) +  total_sale_charge_;
   END LOOP;   
   RETURN NVL(total_sale_charge_, 0);
END Get_Total_Sale_Charge__;


-- Get_Total_Sale_Charge_Gross__
--   Get the total charge amount incl tax on the quotation in quotation currency.
@UncheckedAccess
FUNCTION Get_Total_Sale_Charge_Gross__ (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_sale_charge_incl_tax_ NUMBER := 0;
   CURSOR get_charges IS
      SELECT quotation_charge_no
        FROM  ORDER_QUOTATION_CHARGE_TAB     
       WHERE quotation_no = quotation_no_;
BEGIN
   FOR rec_ IN get_charges LOOP
      total_sale_charge_incl_tax_ := Order_Quotation_Charge_API.Get_Total_Charge_Amnt_Incl_Tax(quotation_no_, rec_.quotation_charge_no) +  total_sale_charge_incl_tax_;
   END LOOP;   
   RETURN NVL(total_sale_charge_incl_tax_, 0);
END Get_Total_Sale_Charge_Gross__;


-- Get_Total_Sale_Price__
--   Retrive the total sale price for the specified quotation.
@UncheckedAccess
FUNCTION Get_Total_Sale_Price__ (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_quote_price_ NUMBER := 0;
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  rowstate != 'Cancelled'
      AND    line_item_no <= 0
      AND    quotation_no = quotation_no_;
BEGIN
   FOR rec_ IN get_lines LOOP
      total_quote_price_ := total_quote_price_ + Order_Quotation_Line_API.Get_Sale_Price_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no) ;
   END LOOP;
   
   RETURN NVL(total_quote_price_, 0);
END Get_Total_Sale_Price__;


-- Get_Tot_Sale_Price_Incl_Tax__
--   Retrive the total sale price including tax for the specified quotation.
@UncheckedAccess
FUNCTION Get_Tot_Sale_Price_Incl_Tax__ (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_quote_price_incl_tax_ NUMBER := 0;
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  rowstate != 'Cancelled'
      AND    line_item_no <= 0
      AND    quotation_no = quotation_no_;
BEGIN
   FOR rec_ IN get_lines LOOP
      total_quote_price_incl_tax_ := total_quote_price_incl_tax_ + Order_Quotation_Line_API.Get_Sale_Price_Incl_Tax_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no) ;
   END LOOP;
   
   RETURN NVL(total_quote_price_incl_tax_, 0);
END Get_Tot_Sale_Price_Incl_Tax__;

FUNCTION  Calculate_Totals (
   quotation_no_ IN VARCHAR2) RETURN Calculated_Totals_Arr PIPELINED
IS
   rec_                   Calculated_Totals_Rec; 
BEGIN 
   Order_Quotation_API.Get_Quote_Line_Totals__(rec_.quotation_total_base_, rec_.quotation_total_, rec_.tax_amount_, rec_.gross_amount_, rec_.additional_discount_amount_, quotation_no_); 
   rec_.quotation_weight_          := NVL(Order_Quotation_API.Get_Total_Weight__(quotation_no_), 0);                  
   rec_.quotation_volume_          := NVL(Order_Quotation_API.Get_Total_Qty__(quotation_no_), 0);
   rec_.total_contribution_amount_ := Order_Quotation_API.Get_Total_Contribution__(quotation_no_);
   rec_.total_cost_amount_         := Order_Quotation_API.Get_Total_Cost__(quotation_no_);
   rec_.total_charge_base_         := Order_Quotation_API.Get_Total_Base_Charge__(quotation_no_);
   rec_.total_charge_              := Order_Quotation_API.Get_Total_Sale_Charge__(quotation_no_);
   rec_.total_charge_gross_        := Order_Quotation_API.Get_Total_Sale_Charge_Gross__(quotation_no_);
   rec_.total_cha_tax_             := Order_Quotation_API.Get_Tot_Charge_Sale_Tax_Amt(quotation_no_);
   
   IF (rec_.total_contribution_amount_+ rec_.total_cost_amount_ != 0) THEN
      rec_.total_contribution_percent_ := (rec_.total_contribution_amount_ / (rec_.total_contribution_amount_ + rec_.total_cost_amount_)) * 100;
   ELSE
      rec_.total_contribution_percent_ := 0;
   END IF; 
   rec_.total_base_amt_ := rec_.quotation_total_base_ + rec_.total_charge_base_;
   rec_.total_amt_ := rec_.quotation_total_ + rec_.total_charge_;
   rec_.toatal_tax_amt_ := rec_.tax_amount_ + rec_.total_cha_tax_;
   IF (Order_Quotation_API.Get_Use_Price_Incl_Tax_Db(quotation_no_) = 'TRUE') THEN
      rec_.total_gross_amt_ := rec_.gross_amount_ + rec_.total_charge_gross_;
   ELSE
      rec_.total_gross_amt_ := rec_.gross_amount_  + rec_.total_charge_ + rec_.total_cha_tax_;
      rec_.total_charge_gross_ := rec_.total_charge_  + rec_.total_cha_tax_ ;
   END IF;
   PIPE ROW (rec_);                                                                                     
END Calculate_Totals;

@UncheckedAccess
PROCEDURE Get_Quote_Line_Totals__ (
   total_base_price_   OUT NUMBER,
   total_sale_price_   OUT NUMBER,
   total_tax_amount_   OUT NUMBER,
   total_gross_amount_ OUT NUMBER,
   total_add_disc_amt_ OUT NUMBER,
   quotation_no_       IN  VARCHAR2)
IS
   quoterec_                  ORDER_QUOTATION_TAB%ROWTYPE;
   rounding_                  NUMBER;
   currency_rounding_         NUMBER;
   net_amount_                NUMBER;
   gross_amount_              NUMBER;
   discount_                  NUMBER;
   add_discount_              NUMBER;
   line_discount_amount_      NUMBER;
   total_sale_price_incl_tax_ NUMBER;
   total_base_price_incl_tax_ NUMBER;
   total_tax_amount_base_     NUMBER;
   rental_chargeable_days_    NUMBER;
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no, 
             ROUND((cost * revised_qty_due), rounding_) total_cost,
             (buy_qty_due * price_conv_factor * sale_unit_price) net_amount,
             (buy_qty_due * price_conv_factor * unit_price_incl_tax) gross_amount,
             discount, additional_discount, buy_qty_due, price_conv_factor, rental
      FROM  ORDER_QUOTATION_LINE_TAB
      WHERE rowstate != 'Cancelled'
      AND   line_item_no <= 0
      AND   quotation_no = quotation_no_;
BEGIN
   quoterec_                  := Get_Object_By_Keys___(quotation_no_);
   currency_rounding_         := Currency_Code_API.Get_Currency_Rounding(quoterec_.company,quoterec_.currency_code);
   rounding_                  := Currency_Code_API.Get_Currency_Rounding(quoterec_.company, Company_Finance_API.Get_Currency_Code(quoterec_.company));
   total_base_price_          := 0;
   total_base_price_incl_tax_ := 0;
   total_sale_price_          := 0;
   total_sale_price_incl_tax_ := 0;
   total_tax_amount_          := 0;
   total_tax_amount_base_     := 0;
   total_gross_amount_        := 0;
   total_add_disc_amt_        := 0;
   net_amount_                := 0;
   gross_amount_              := 0;
   discount_                  := 0;
   add_discount_              := 0;
   
   FOR rec_ IN get_lines LOOP
      total_base_price_          := total_base_price_ + Order_Quotation_Line_API.Get_Base_Sale_Price_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      total_base_price_incl_tax_ := total_base_price_incl_tax_ + Order_Quotation_Line_API.Get_Base_Price_Incl_Tax_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      total_sale_price_          := total_sale_price_ +Order_Quotation_Line_API.Get_Sale_Price_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no) ;
      total_sale_price_incl_tax_ := total_sale_price_incl_tax_ + Order_Quotation_Line_API.Get_Sale_Price_Incl_Tax_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no) ;
      
      total_tax_amount_          := total_tax_amount_ + Order_Quotation_Line_API.Get_Total_Tax_Amount_Curr(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      total_tax_amount_base_     := total_tax_amount_base_ + Order_Quotation_Line_API.Get_Total_Tax_Amount(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      
      net_amount_                := NVL(rec_.net_amount, 0);
      gross_amount_              := NVL(rec_.gross_amount, 0);
      discount_                  := NVL(rec_.discount, 0);
      add_discount_              := NVL(rec_.additional_discount, 0);
      
      IF (rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
         $IF Component_Rental_SYS.INSTALLED $THEN
            rental_chargeable_days_ := Rental_Object_API.Get_Rental_Chargeable_Days(quotation_no_, 
                                                                                    rec_.line_no, 
                                                                                    rec_.rel_no, 
                                                                                    rec_.line_item_no, 
                                                                                    Rental_Type_API.DB_ORDER_QUOTATION);
            gross_amount_           := gross_amount_ * rental_chargeable_days_; 
            net_amount_             := net_amount_ * rental_chargeable_days_;            
         $ELSE
            NULL;
         $END
      END IF;
      
      line_discount_amount_      := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.buy_qty_due, rec_.price_conv_factor, currency_rounding_);
      
      IF (quoterec_.use_price_incl_tax = 'TRUE') THEN         
         total_add_disc_amt_ := total_add_disc_amt_ + ROUND(((gross_amount_ - line_discount_amount_) * NVL(add_discount_, 0)/100), currency_rounding_);
      ELSE
         total_add_disc_amt_ := total_add_disc_amt_ + ROUND(((net_amount_ - line_discount_amount_) * NVL(add_discount_, 0)/100), currency_rounding_);
      END IF;
   END LOOP;
   
   total_tax_amount_ := ROUND(total_tax_amount_, currency_rounding_);
   IF (quoterec_.use_price_incl_tax = 'TRUE') THEN
      total_gross_amount_ := total_sale_price_incl_tax_;
      total_sale_price_   := total_sale_price_incl_tax_ - total_tax_amount_;
      total_base_price_   := total_base_price_incl_tax_ - total_tax_amount_base_;
   ELSE
      total_gross_amount_ := total_sale_price_ + total_tax_amount_;
   END IF;
END Get_Quote_Line_Totals__;


-- Get_Total_Weight__
--   Retrive the total weight for the specified quotation
@UncheckedAccess
FUNCTION Get_Total_Weight__ (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_weight_ NUMBER;
   
   CURSOR get_totals IS
      SELECT SUM(line_total_weight)
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE rowstate != 'Cancelled'
      AND   line_item_no <= 0
      AND   quotation_no = quotation_no_;
BEGIN
   OPEN get_totals;
   FETCH get_totals INTO total_weight_;
   CLOSE get_totals;
   
   RETURN total_weight_;
END Get_Total_Weight__;


-- Get_Allowed_Operations__
--   Returns a string used to determine which operations should be allowed for
--   the specified quotation
@UncheckedAccess
FUNCTION Get_Allowed_Operations__ (
   quotation_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_          ORDER_QUOTATION_TAB%ROWTYPE;
   operations_   VARCHAR2(8);
   
   CURSOR get_all_lines( quotation_no_ IN VARCHAR2 ) IS
      SELECT line_no, rel_no, line_item_no, rowstate
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE rowstate != 'Cancelled'
        AND line_item_no <= 0
        AND quotation_no = quotation_no_;
   
   line_no_         ORDER_QUOTATION_LINE_TAB.line_no%TYPE;
   rel_no_          ORDER_QUOTATION_LINE_TAB.rel_no%TYPE;
   line_item_no_    ORDER_QUOTATION_LINE_TAB.line_item_no%TYPE;
   rowstate_        ORDER_QUOTATION_LINE_TAB.rowstate%TYPE;
   can_cancel_      BOOLEAN   := TRUE;
   can_release_     BOOLEAN   := TRUE;
   can_approve_     BOOLEAN   := TRUE;
   line_op_         VARCHAR2(6);
   anyrow_lost_     BOOLEAN   := FALSE;
   allrows_lost_    BOOLEAN   := FALSE;
   open_rows_exist_ BOOLEAN := FALSE;
   first_lap_       BOOLEAN := TRUE;
   anyrow_release_  BOOLEAN := FALSE;
   anyrow_planned_  BOOLEAN := FALSE;
   anyrow_won_      BOOLEAN := FALSE;
BEGIN
   rec_ := Get_Object_By_Keys___(quotation_no_);
   
   OPEN get_all_lines( quotation_no_ );
   FETCH get_all_lines INTO line_no_, rel_no_, line_item_no_, rowstate_;
   WHILE get_all_lines%FOUND LOOP
      line_op_     := Order_Quotation_Line_API.Get_Allowed_Operations__( quotation_no_, line_no_, rel_no_, line_item_no_ );
      can_cancel_  := can_cancel_ AND ( SUBSTR( line_op_, 1, 1) != '*' );
      can_release_ := can_release_ AND ( ( SUBSTR( line_op_, 2, 1) != '*' ) OR
                                         ( rowstate_ = 'Released' OR rowstate_ = 'Won' OR rowstate_ = 'Lost' OR  rowstate_ = 'CO Created') );
      can_approve_ := can_approve_ AND ( SUBSTR( line_op_, 5, 1) != '*' );
      
      -- Check for open rows (possible to Win or Loose)
      IF (rowstate_ NOT IN ('Won', 'Lost', 'CO Created')) THEN
         open_rows_exist_ := TRUE;
      END IF;
      
      IF ( rowstate_ = 'Lost' ) THEN
         anyrow_lost_ := TRUE;
      ELSIF (rowstate_ ='Released') THEN
         anyrow_release_ := TRUE;
      ELSIF (rowstate_ ='Planned') THEN
         anyrow_planned_ := TRUE;
      ELSIF (rowstate_ ='Won') THEN
         anyrow_won_ := TRUE;
      END IF;
      
      IF first_lap_ THEN
         allrows_lost_ := TRUE;
         first_lap_ := FALSE;
      END IF;
      allrows_lost_ := allrows_lost_ AND ( rowstate_ = 'Lost' );
      
      FETCH get_all_lines INTO line_no_, rel_no_, line_item_no_, rowstate_;
   END LOOP;
   CLOSE get_all_lines;
   
   -- 0 Cancel quotation
   IF ((rec_.rowstate IN('Planned' ,'Released', 'Revised', 'Rejected')) AND can_cancel_ ) THEN
      operations_ := 'C';
   ELSE
      operations_ := '*';
   END IF;
   
   -- 1 Release quotation
   IF ( ( rec_.rowstate = 'Planned' OR rec_.rowstate = 'Revised' OR rec_.rowstate = 'Rejected' OR anyrow_planned_ ) AND can_release_ ) THEN
      operations_ := operations_  || 'R';
   ELSE
      operations_ := operations_  || '*';
   END IF;
   
   -- 2 Lost quotation
   -- IF ( rec_.rowstate = 'Released' AND open_rows_exist_ ) THEN
   IF ((rec_.rowstate = 'Released' AND ( anyrow_release_  AND NOT allrows_lost_  )) OR rec_.rowstate = 'Rejected') THEN
      operations_ := operations_  || 'L';
   ELSE
      operations_ := operations_  || '*';
   END IF;
   
   -- 3 Create Order
   -- IF ( ( rec_.rowstate = 'Released' ) AND open_rows_exist_ ) AND
   IF ( ( rec_.rowstate = 'Released' ) AND (  NOT allrows_lost_ AND  (anyrow_release_ OR anyrow_won_)   ) AND
        ( ( (trunc(Site_API.Get_Site_Date( rec_.contract ))  <= rec_.expiration_date )) OR rec_.expiration_date IS NULL  )) THEN
      operations_ := operations_  || 'W';
   ELSE
      operations_ := operations_  || '*';
   END IF;
   
   -- 4 Approve
   IF (can_approve_ ) THEN
      operations_ := operations_  || 'A';
   ELSE
      operations_ := operations_  || '*';
   END IF;
   
   -- 5 Print Quotation
   IF ( rec_.rowstate != 'Cancelled') THEN 
      operations_ := operations_  || 'P';  
   ELSE
      operations_ := operations_  || '*';
   END IF;
   
   -- 6 Email Quotation
   IF (Email_Quotation_Allowed___(rec_)) THEN
      operations_ := operations_ || 'E';
   ELSE
      operations_ := operations_ || '*';
   END IF;
   
   -- 7 Reject Quotation
   IF ( rec_.rowstate = 'Released' AND anyrow_release_ AND (NOT anyrow_planned_)) THEN
      operations_ := operations_ || 'J';
   ELSE
      operations_ := operations_ || '*';
   END IF;
   
   RETURN operations_;
END Get_Allowed_Operations__;


-- Close_Quotation__
--   Sets status closed if all lines connected to the order quotation
--   are either lost or won.
PROCEDURE Close_Quotation__ (
   quotation_no_ IN VARCHAR2)
IS
   quoterec_ ORDER_QUOTATION_TAB%ROWTYPE;
   linerec_  ORDER_QUOTATION_LINE_TAB%ROWTYPE;
   
   CURSOR GetLines IS
      SELECT *
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE rowstate NOT IN ('Lost', 'Cancelled', 'CO Created')
      AND line_item_no <= 0
      AND quotation_no = quotation_no_;
BEGIN
   quoterec_ := Lock_By_Keys___(quotation_no_);
   OPEN GetLines;
   FETCH GetLines INTO linerec_;
   IF (GetLines%NOTFOUND) THEN
      Finite_State_Set___(quoterec_, 'Closed');
   END IF;
   CLOSE GetLines;
END Close_Quotation__;


-- Get_Total_Contribution__
--   Returns the contribution for a order
@UncheckedAccess
FUNCTION Get_Total_Contribution__ (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_base_price_ NUMBER;
   total_cost_       NUMBER;
   contribution_     NUMBER;
BEGIN
   IF (Get_Use_Price_Incl_Tax_Db(quotation_no_) = Fnd_Boolean_API.DB_TRUE) THEN
      total_base_price_ := Get_Total_Base_Price_Incl_Tax(quotation_no_) - Get_Total_Tax_Amount_Base(quotation_no_);
   ELSE
      total_base_price_ := Get_Total_Base_Price(quotation_no_);
   END IF;
   total_cost_   := Get_Total_Cost__(quotation_no_);
   contribution_ := total_base_price_ - total_cost_;
   RETURN contribution_;
END Get_Total_Contribution__;


-- Get_Total_Cost__
--   Retrieve the total cost for the specified order
@UncheckedAccess
FUNCTION Get_Total_Cost__ (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_cost_ NUMBER;
   company_    VARCHAR2(20);
   rounding_   NUMBER;
   
   CURSOR get_total_cost IS
      SELECT SUM(ROUND((cost * revised_qty_due), rounding_))
      FROM  ORDER_QUOTATION_LINE_TAB
      WHERE rowstate != 'Cancelled'
      AND   line_item_no <= 0
      AND   quotation_no = quotation_no_;
BEGIN
   company_  := Site_API.Get_Company(Get_Contract(quotation_no_));
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   OPEN get_total_cost;
   FETCH get_total_cost INTO total_cost_;
   IF (get_total_cost%NOTFOUND) THEN
      total_cost_ := 0;
   END IF;
   CLOSE get_total_cost;
   RETURN NVL(total_cost_, 0);
END Get_Total_Cost__;


-- Email_Sales_Quotation__
--   Send email to customer contact email address with attached pdf
--   file for customer order sales quotation.
PROCEDURE Email_Sales_Quotation__ (
   quotation_no_ IN VARCHAR2,
   contact_      IN VARCHAR2,
   contract_     IN VARCHAR2,
   email_        IN VARCHAR2,
   customer_no_  IN VARCHAR2,
   report_id_    IN VARCHAR2 )
IS
   fnd_user_            VARCHAR2(30)         := Fnd_Session_API.Get_Fnd_User;
   field_separator_     CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;   
   report_attr_         VARCHAR2(2000);
   parameter_attr_      VARCHAR2(2000);
   message_attr_        VARCHAR2(2000);
   archiving_attr_      VARCHAR2(2000);
   schedule_name_       VARCHAR2(200);
   schedule_id_         NUMBER;
   seq_no_              NUMBER;
   start_date_          DATE              := sysdate;
   next_execution_date_ DATE;
BEGIN
   Client_SYS.Clear_Attr(report_attr_);
   Client_SYS.Add_To_Attr('REPORT_ID', report_id_,  report_attr_);
   Client_SYS.Add_To_Attr('LU_NAME', 'OrderQuotation',  report_attr_);
   
   Client_SYS.Clear_Attr(parameter_attr_);
   
   Client_SYS.Add_To_Attr('QUOTATION_NO', quotation_no_, parameter_attr_);
   
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
                                db_true_,
                                'ASAP',
                                NULL,
                                NULL,
                                report_id_);
   
   -- Add the id of the created scheduled task to report attribute string.
   Client_SYS.Set_Item_Value('SCHEDULE_ID', schedule_id_, report_attr_);
   Client_SYS.Set_Item_Value('LAYOUT_NAME', Report_Layout_Definition_API.Get_Default_Layout(report_id_), report_attr_);
   -- Add the language code for this session to the report attribute string if no language has been choosen
   Client_SYS.Set_Item_Value('LANG_CODE', Fnd_Session_API.Get_Language, report_attr_);
   
   -- Creating the message attr
   Client_SYS.Clear_Attr(message_attr_);
   Client_SYS.Add_To_Attr('MESSAGE_TYPE', 'NONE', message_attr_);
   
   Generate_Pdf_Parameters(archiving_attr_, quotation_no_, contact_, contract_, email_, customer_no_, report_id_);
   
   -- Add the parameters
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'REPORT_ATTR', report_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'PARAMETER_ATTR', parameter_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'MESSAGE_ATTR', message_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'ARCHIVING_ATTR', archiving_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'DISTRIBUTION_LIST', fnd_user_|| field_separator_);
   
   -- Add a new entry to Customer Order Quotation History
   Order_Quotation_History_API.New(quotation_no_, Language_SYS.Translate_Constant(lu_name_, 'QUOTATION_EMAILED: Quotation E-mailed to :P1', NULL, email_));
END Email_Sales_Quotation__;


-- Modify_Wanted_Delivery_Date__
--   Modifies the wanted delivery date of all the updatable order quotation lines
--   of a given order quotation.
PROCEDURE Modify_Wanted_Delivery_Date__ (
   quotation_no_          IN VARCHAR2,
   wanted_delivery_date_  IN DATE,
   planned_delivery_date_ IN DATE )
IS
   revision_status_ VARCHAR2(20);
   date_changed_    BOOLEAN := FALSE;
   
   CURSOR get_all_lines IS
      SELECT line_no, rel_no, line_item_no, part_no, configuration_id
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    rowstate NOT IN ('Lost', 'Cancelled', 'CO Created')
      AND    line_item_no <= 0;
BEGIN
   FOR rec_ IN get_all_lines LOOP
      $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
         IF (NOT date_changed_) AND NVL(rec_.configuration_id, '*') != '*' THEN
            revision_status_ := Config_Manager_API.Validate_Effective_Revision(rec_.part_no, rec_.configuration_id, planned_delivery_date_);        
            IF (revision_status_ = 'INVALID') THEN
               date_changed_ := TRUE;
            END IF;
         END IF;
      $END
      Order_Quotation_Line_API.Modify_Wanted_Delivery_Date__(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, wanted_delivery_date_, planned_delivery_date_);
   END LOOP;
END Modify_Wanted_Delivery_Date__;

-- Check_Config_Revisions
--   This method checks whether the part configuration revisions used to create configurations
--   for each order quotation line is valid for each line's planned delivery date and returns
--   the number of lines with invalid configuration revisions.
PROCEDURE Check_Config_Revisions (
   invalid_       OUT NUMBER,
   quotation_no_  IN  VARCHAR2,
   delivery_date_ IN  DATE)
IS
   revision_status_    VARCHAR2(50);
   invalid_lines_      NUMBER := 0;
   
   CURSOR get_all_lines IS
      SELECT part_no, configuration_id
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    rowstate  IN ('Planned', 'Released', 'Revised');
BEGIN
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      FOR rec_ IN get_all_lines LOOP
         IF Nvl(rec_.configuration_id, '*') != '*' THEN
            revision_status_ := Config_Manager_API.Validate_Effective_Revision(rec_.part_no, rec_.configuration_id, delivery_date_);
            IF (revision_status_ = 'INVALID') THEN
               invalid_lines_ := invalid_lines_ + 1;
            END IF;
         END IF;
      END LOOP;
   $END
   invalid_ := invalid_lines_;
END Check_Config_Revisions;

-- Update_Config_Revisions
--   This method updates the part configuration revisions used to create configurations
--   for each order quotation line to revision valid for the new planned delivery date.
PROCEDURE Update_Config_Revisions (
   quotation_no_  IN VARCHAR2,
   delivery_date_ IN DATE)
IS   
   CURSOR get_all_lines IS
      SELECT part_no, configuration_id, configured_line_price_id
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    rowstate  IN ('Planned', 'Released', 'Revised');
   
   new_config_id_ VARCHAR2(50);
   spec_rev_no_   NUMBER;
BEGIN
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      FOR rec_ IN get_all_lines LOOP
         IF (Config_Manager_API.Validate_Effective_Revision(rec_.part_no, rec_.configuration_id, delivery_date_) = 'INVALID') THEN
            spec_rev_no_ := Config_Part_Spec_Rev_API.Get_Spec_Rev_For_Date(rec_.part_no, delivery_date_, 'FALSE');
            Configuration_Spec_API.Create_New_Config_Spec(new_config_id_, rec_.part_no, spec_rev_no_, rec_.configuration_id, rec_.configured_line_price_id, 'TRUE');
            Configuration_Spec_API.Manual_Park(new_config_id_, rec_.part_no);
            Configured_Line_Price_API.Update_Parent_Config_Id(rec_.configured_line_price_id, new_config_id_, 'TRUE');
         END IF;
      END LOOP;
   $ELSE
      NULL;
   $END
END Update_Config_Revisions;


-- Release_Customer_Order__
--   Releases the given customer order.
--   Intended to use in creation of customer order from quotation.
PROCEDURE Release_Customer_Order__(
   order_no_ IN VARCHAR2)
IS
   rel_attr_ VARCHAR2(32000);
BEGIN
   IF (order_no_ IS NOT NULL) THEN
      Client_SYS.Clear_Attr( rel_attr_ );
      Client_SYS.Add_To_Attr( 'START_EVENT', 20, rel_attr_ );
      Client_SYS.Add_To_Attr( 'ORDER_NO', order_no_, rel_attr_ );
      Client_SYS.Add_To_Attr( 'END', '', rel_attr_ );
      Customer_Order_Flow_API.Start_Release_Order__( rel_attr_ );
   END IF;
END Release_Customer_Order__;

-- Copy_Quotation__
--   Copy sales quotation from a quotation number to another.
PROCEDURE Copy_Quotation__ (
   to_quotation_no_      IN OUT VARCHAR2,
   from_quotation_no_    IN     VARCHAR2,   
   wanted_delivery_date_ IN     DATE,
   request_receipt_date_ IN     DATE,
   answering_date_       IN     DATE,
   expiration_date_      IN     DATE,   
   price_effective_date_ IN     DATE,
   copy_general_         IN     VARCHAR2,
   copy_lines_           IN     VARCHAR2,
   copy_rental_lines_    IN     VARCHAR2,
   copy_charges_         IN     VARCHAR2,
   copy_competitors_     IN     VARCHAR2,
   copy_adresses_        IN     VARCHAR2,
   copy_delivery_info_   IN     VARCHAR2,
   copy_misc_info_       IN     VARCHAR2,   
   copy_representatives_ IN     VARCHAR2,
   copy_pricing_         IN     VARCHAR2,
   copy_document_texts_  IN     VARCHAR2,
   copy_notes_           IN     VARCHAR2,
   copy_contacts_        IN     VARCHAR2 )
IS
   attr_         VARCHAR2(32000);
   source_order_ VARCHAR2(5) := NULL;
   newrec_       ORDER_QUOTATION_TAB%ROWTYPE;
   copyrec_      ORDER_QUOTATION_TAB%ROWTYPE;
   from_rowkey_  ORDER_QUOTATION_TAB.rowkey%TYPE;
   indrec_       Indicator_Rec;
   objid_                        VARCHAR2(20);
   objversion_                   VARCHAR2(100);
   
   CURSOR get_rec IS
      SELECT *
      FROM  order_quotation_tab
      WHERE quotation_no = from_quotation_no_
      AND   b2b_order    = 'FALSE';
BEGIN
   OPEN get_rec;
   FETCH get_rec INTO copyrec_;
   IF get_rec%NOTFOUND THEN
      Error_SYS.record_general(lu_name_, 'NOOPPORTUNITY: Quotation :P1 does not exist.', from_quotation_no_);
      CLOSE get_rec;
   ELSE
      CLOSE get_rec;
      
      from_rowkey_ := copyrec_.rowkey;
      IF to_quotation_no_ IS NULL THEN         
         Get_New_Quotation_No___ (to_quotation_no_, copyrec_.authorize_code, source_order_);
      END IF;       
      attr_ := Build_Attr_Copy_Quotation___(copyrec_, to_quotation_no_, wanted_delivery_date_, request_receipt_date_, answering_date_, expiration_date_, 
                                            price_effective_date_, copy_general_, copy_adresses_, copy_delivery_info_, copy_misc_info_, copy_notes_, copy_pricing_);
      Unpack___(newrec_, indrec_, attr_);
      IF (NVL(copy_charges_, 'FALSE') = 'TRUE') THEN
         Client_SYS.Add_To_Attr( 'DEFAULT_CHARGES', db_false_, attr_);   
      END IF;
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
      Order_Quotation_History_API.New(to_quotation_no_, 
                                      Language_SYS.Translate_Constant(lu_name_, 'COPIED_QUOTATION: Copy from the quotation :P1', NULL, from_quotation_no_));
      
      IF (copy_document_texts_ = Fnd_Boolean_API.DB_TRUE) THEN         
         Document_Text_API.Copy_All_Note_Texts(copyrec_.note_id, newrec_.note_id); 
      END IF;     
      
      -- Copy Sales Quotation Header Custom Field Values.
      Custom_Objects_SYS.Copy_Cf_Instance(lu_name_, from_rowkey_, newrec_.rowkey);
      
      IF (copy_lines_ = Fnd_Boolean_API.DB_TRUE) THEN
         Order_Quotation_Line_API.Copy_Quotation_Line(from_quotation_no_, to_quotation_no_, wanted_delivery_date_, copy_pricing_, copy_document_texts_, copy_notes_,copy_charges_);
      END IF;
      IF (copy_rental_lines_ = Fnd_Boolean_API.DB_TRUE) THEN
         Order_Quotation_Line_API.Copy_Quotation_Line(from_quotation_no_, to_quotation_no_, wanted_delivery_date_, copy_pricing_, copy_document_texts_, copy_notes_,copy_charges_, rental_db_ => 'TRUE'); 
      END IF;  
      IF (copy_charges_ = Fnd_Boolean_API.DB_TRUE) THEN
         Order_Quotation_Charge_API.Copy_Lines__(from_quotation_no_, to_quotation_no_, copy_pricing_, copy_lines_,copy_document_texts_);
      END IF;
      
      $IF Component_Rmcom_SYS.INSTALLED $THEN   
         IF (copy_representatives_ = Fnd_Boolean_API.DB_TRUE) THEN
            Bus_Obj_Representative_API.Copy_Representative(from_quotation_no_, 
                                                           to_quotation_no_, 
                                                           Business_Object_Type_API.DB_SALES_QUOTATION, 
                                                           Business_Object_Type_API.DB_SALES_QUOTATION,
                                                           Fnd_Boolean_API.DB_FALSE);
         END IF;
         IF (copy_contacts_ = Fnd_Boolean_API.DB_TRUE) THEN            
            Business_Object_Contact_API.Copy_Contact(from_quotation_no_, 
                                                     to_quotation_no_, 
                                                     Business_Object_Type_API.DB_SALES_QUOTATION, 
                                                     Business_Object_Type_API.DB_SALES_QUOTATION);  
         END IF;
      $END
      
      IF (copy_competitors_ = Fnd_Boolean_API.DB_TRUE) THEN
         Order_Quotation_Competitor_API.Copy_Competitors__(from_quotation_no_, to_quotation_no_ );
         NULL;
      END IF;
      
   END IF;
END Copy_Quotation__; 

-- Check_Before_Close__
--   Checks whether there is at least 1 quotation line in Released or Planned status.
PROCEDURE Check_Before_Close__ (
   info_         OUT VARCHAR2,
   quotation_no_ IN  VARCHAR2 )
IS
   found_ NUMBER;
   CURSOR released_quote_lines_exist IS
      SELECT 1
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    rowstate IN ('Released', 'Planned','Rejected');
BEGIN
   OPEN released_quote_lines_exist;
   FETCH released_quote_lines_exist INTO found_;
   IF (released_quote_lines_exist%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE released_quote_lines_exist;    
   IF (found_ = 1) THEN
      Client_SYS.Add_Warning(lu_name_,'RELEASEDPLANNEDLINESEXIST: Lines in Released, Rejected or Planned status exist. It will not be possible to process these lines once the sales quotation is closed.');
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Check_Before_Close__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Delivery_Information
--   Returns correct Ship Via Code, Delivery Terms and Delivery Terms
--   Description. If an agreement exists, the values are fetched from
--   the agreement. Otherwise, the values are fetched from the customer.
PROCEDURE Get_Delivery_Information (
   attr_          IN OUT VARCHAR2,
   language_code_ IN     VARCHAR2,
   agreement_id_  IN     VARCHAR2,
   customer_no_   IN     VARCHAR2,
   address_no_    IN     VARCHAR2 )
IS
   ship_via_code_              VARCHAR2(3);
   deliv_term_                 VARCHAR2(5);
   deliv_term_desc_            VARCHAR2(35);
   del_terms_location_         ORDER_QUOTATION_TAB.del_terms_location%TYPE := NULL;
   contract_                   ORDER_QUOTATION_TAB.contract%TYPE;
   addr_flag_                  VARCHAR2(1);
   leadtime_                   NUMBER;
   ext_transport_calendar_id_  ORDER_QUOTATION_TAB.ext_transport_calendar_id%TYPE;
   freight_map_id_             VARCHAR2(15);
   zone_id_                    VARCHAR2(15);
   agreement_rec_              Customer_Agreement_API.Public_Rec;
   customer_rec_               Cust_Ord_Customer_Address_API.Public_Rec;
   customer_category_          CUSTOMER_INFO_TAB.customer_category%TYPE;
   route_id_                   VARCHAR2(12);
   forward_agent_id_           ORDER_QUOTATION_TAB.forward_agent_id%TYPE;
   picking_leadtime_           NUMBER;
   shipment_type_              VARCHAR2(3);
   ship_inventory_location_no_ VARCHAR2(35);
   vendor_no_                  VARCHAR2(20);
   agreement_changed_          VARCHAR2(5);   
   agreement_deliv_term_       VARCHAR2(5);
   ship_addr_no_changed_       VARCHAR2(5);
BEGIN
   -- Retrieve extra parameters from attribute string!!
   contract_          := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   deliv_term_        := Client_SYS.Get_Item_Value('DELIVERY_TERMS', attr_);
   vendor_no_         := Client_SYS.Get_Item_Value('VENDOR_NO', attr_);      
   agreement_changed_         := Client_SYS.Get_Item_Value('AGREEEMENT_CHANGED', attr_);
   ship_addr_no_changed_      := NVL(Client_SYS.Get_Item_Value('ADDRESS_CHANGED', attr_), 'FALSE');
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(customer_no_);

   -- use customer address as single occurence if customer is a prospect
   IF (nvl(customer_category_, Customer_Category_API.DB_CUSTOMER) = Customer_Category_API.DB_CUSTOMER) THEN
      addr_flag_ := 'N';
   ELSE
      addr_flag_ := 'Y';
   END IF;
   
   IF ((agreement_id_ IS NOT NULL) OR (ship_addr_no_changed_ = 'TRUE')) THEN
      leadtime_         := Client_SYS.Get_Item_Value('DELIVERY_LEADTIME', attr_);
      picking_leadtime_ := Client_SYS.Get_Item_Value('PICKING_LEADTIME',  attr_);
   END IF;   

   IF (agreement_id_ IS NOT NULL) THEN
      IF (agreement_changed_='TRUE' )THEN
         agreement_rec_ := Customer_Agreement_API.Get(agreement_id_);
         ship_via_code_             := Client_SYS.Get_Item_Value('SHIP_VIA_CODE', attr_);
         deliv_term_desc_           := Client_SYS.Get_Item_Value('DELIVERY_TERMS_DESC', attr_);
         del_terms_location_        := Client_SYS.Get_Item_Value('DEL_TERMS_LOCATION', attr_);
         ext_transport_calendar_id_ := Client_SYS.Get_Item_Value('EXT_TRANSPORT_CALENDAR_ID', attr_);
         forward_agent_id_          := Client_SYS.Get_Item_Value('FORWARD_AGENT_ID', attr_);
         -- Get delivery_terms from agreement
         agreement_deliv_term_ := agreement_rec_.delivery_terms;
         IF ((agreement_deliv_term_ IS NOT NULL) AND NOT(agreement_rec_.use_by_object_head = 'FALSE' AND agreement_rec_.use_explicit = 'Y'))THEN
            del_terms_location_ := agreement_rec_.del_terms_location;     
         END IF;
      ELSE
         deliv_term_ := agreement_rec_.delivery_terms;
         route_id_ := Client_SYS.Get_Item_Value('ROUTE_ID', attr_);
         forward_agent_id_ := Client_SYS.Get_Item_Value('FORWARD_AGENT_ID', attr_);
         shipment_type_    := Client_SYS.Get_Item_Value('SHIPMENT_TYPE', attr_);
         -- If the agreement has delivery terms get del_terms_location from agreement
         -- if not retrieve delivery term and location from Customer.
         IF (deliv_term_ IS NOT NULL) THEN
            del_terms_location_ := agreement_rec_.del_terms_location;         
         END IF;
      END IF;
   ELSE
      customer_rec_       := Cust_Ord_Customer_Address_API.Get(customer_no_, address_no_);
      deliv_term_         := customer_rec_.delivery_terms;
      del_terms_location_ := customer_rec_.del_terms_location;
   END IF;
   
   -- Added IF condition to only call the method Get_Supply_Chain_Head_Defaults() and fetch values When the agreement is newly connected or changed and when existing agreement is removed from the header
   -- but avoid the call when agreement's Exclude from auto pricing is checked and used by Order/Quotation header is unchecked.
   IF((agreement_id_ IS NULL) OR (agreement_changed_ IS NULL) OR (agreement_changed_ = 'TRUE' AND NOT(agreement_rec_.use_by_object_head = 'FALSE' AND agreement_rec_.use_explicit = 'Y'))) THEN
      Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults(ship_via_code_,
                                                                  deliv_term_,
                                                                  del_terms_location_,
                                                                  freight_map_id_,
                                                                  zone_id_,
                                                                  leadtime_,
                                                                  ext_transport_calendar_id_,
                                                                  route_id_,
                                                                  forward_agent_id_,
                                                                  picking_leadtime_,
                                                                  shipment_type_,
                                                                  ship_inventory_location_no_,
                                                                  contract_,
                                                                  customer_no_,
                                                                  address_no_,
                                                                  addr_flag_,
                                                                  agreement_id_,
                                                                  vendor_no_,
                                                                  ship_addr_no_changed_ );     
   END IF;          

   IF (deliv_term_ IS NULL) THEN
      deliv_term_         := Cust_Ord_Customer_Address_API.Get_Delivery_Terms(customer_no_, address_no_);
      del_terms_location_ := Cust_Ord_Customer_Address_API.Get_Del_Terms_Location(customer_no_, address_no_);
   END IF;
   
   deliv_term_desc_ := Order_Delivery_Term_API.Get_Description(deliv_term_, language_code_);
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TERMS', deliv_term_, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TERMS_DESC', deliv_term_desc_, attr_);
   Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', del_terms_location_, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', leadtime_, attr_);
   Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', ext_transport_calendar_id_, attr_);
   Client_SYS.Add_To_Attr('PICKING_LEADTIME', picking_leadtime_, attr_);
   Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', forward_agent_id_, attr_);
END Get_Delivery_Information;


-- Get_Delivery_Time
--   Adds default time from the order's delivery address to the bypassed date.
FUNCTION Get_Delivery_Time (
   quotation_no_  IN VARCHAR2,
   delivery_date_ IN DATE ) RETURN DATE
IS
   CURSOR get_customer_info IS
      SELECT customer_no, ship_addr_no
      FROM   ORDER_QUOTATION_TAB
      WHERE  quotation_no = quotation_no_;
   rec_      get_customer_info%ROWTYPE;
   del_time_ DATE := NULL;
BEGIN
   OPEN get_customer_info;
   FETCH get_customer_info INTO rec_;
   IF (get_customer_info%FOUND) THEN
      CLOSE get_customer_info;
      del_time_ := Construct_Delivery_Time___(delivery_date_, rec_.customer_no, rec_.ship_addr_no);
   END IF;
   RETURN del_time_;
END Get_Delivery_Time;


-- Get_Next_Line_No
--   Retrieve new line_no, rel_no and line_item_no for a quotation line.
--   Called when registering a new quotation line.
PROCEDURE Get_Next_Line_No (
   line_no_      OUT VARCHAR2,
   rel_no_       OUT VARCHAR2,
   line_item_no_ OUT NUMBER,
   quotation_no_ IN  VARCHAR2,
   contract_     IN  VARCHAR2,
   catalog_no_   IN  VARCHAR2,
   supply_code_  IN  VARCHAR2 )
IS
   line_          VARCHAR2(4);
   rel_           VARCHAR2(4);
   line_no_count_ NUMBER;
   rel_no_count_  NUMBER;
   
   CURSOR get_line_no IS
      SELECT to_char(max(to_number(line_no)))
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  contract || '' = contract_
      AND    catalog_no || '' = catalog_no_
      AND    line_item_no <= 0
      AND    quotation_no = quotation_no_;
   
   CURSOR get_rel_no IS
      SELECT to_char(max(to_number(rel_no)))
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  contract || '' = contract_
      AND    catalog_no || '' = catalog_no_
      AND    line_item_no <= 0
      AND    line_no = line_
      AND    quotation_no = quotation_no_;
   
   CURSOR get_line IS
      SELECT to_char(max(to_number(line_no)))
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  line_item_no <= 0
      AND    quotation_no = quotation_no_;
   
   CURSOR count_line_no IS
      SELECT count(DISTINCT(to_number(line_no)))
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    contract || '' = contract_;
   
   CURSOR count_rel_no IS
      SELECT count(DISTINCT(to_number(rel_no)))
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_
      AND    contract || '' = contract_
      AND    catalog_no || '' = catalog_no_;   
BEGIN
   IF (catalog_no_ IS NULL) THEN
      OPEN get_line;
      FETCH get_line INTO line_;
      IF get_line%FOUND THEN
         line_ := to_char(to_number(line_) + 1);
      ELSE
         line_ := '1';
      END IF;
      rel_  := '1';
      CLOSE get_line;
   ELSE
      OPEN get_line_no;
      FETCH get_line_no INTO line_;
      CLOSE get_line_no;
      IF (line_ IS NOT NULL) THEN
         OPEN get_rel_no;
         FETCH get_rel_no INTO rel_;
         CLOSE get_rel_no;
         IF (to_Number(rel_) + 1 > 9999) THEN
            OPEN count_rel_no;
            FETCH count_rel_no INTO rel_no_count_;
            CLOSE count_rel_no;
            
            IF (rel_no_count_ < 9999) THEN              
               Error_SYS.Record_General(lu_name_,'RELNOMAX: The maximum limit of the delivery number has been reached. Enter a value less than 9999 in the Del No field manually.');
            ELSE
               Error_SYS.Record_General(lu_name_,'NOMORERELNO: The maximum limit of the delivery number has been reached.');
            END IF;
         END IF;
         rel_ := to_number(rel_) + 1;         
      ELSE
         OPEN get_line;
         FETCH get_line INTO line_;
         CLOSE get_line;
         IF (line_ IS NOT NULL) THEN
            IF (to_number(line_) + 1 > 9999) THEN
               OPEN count_line_no;
               FETCH count_line_no INTO line_no_count_;
               CLOSE count_line_no;
               
               IF (line_no_count_ < 9999) THEN
                  Error_SYS.Record_General(lu_name_,'LINENOMAX: The maximum limit of the line number has been reached. Enter a line number less than 9999 manually.');
               ELSE
                  Error_SYS.Record_General(lu_name_,'NOMORELINENO: The maximum limit of the line number has been reached.');
               END IF;    
            END IF;
            line_ := to_number(line_) + 1;
         ELSE
            line_ := '1';
         END IF;
         rel_ := '1';         
      END IF;      
   END IF;
   IF (line_ IS NULL) THEN
      line_ := '1';
      rel_  := '1';
   END IF;
   IF (rel_ IS NULL) THEN
      rel_ := '1';
   END IF;
   
   IF (supply_code_ = Order_Supply_Type_API.Decode('PKG')) THEN
      line_item_no_ := -1;
   ELSE
      line_item_no_ := 0;
   END IF;
   
   line_no_ := line_;
   rel_no_  := rel_;
END Get_Next_Line_No;



@UncheckedAccess
FUNCTION Get_Objid__ (
   quotation_no_ IN VARCHAR2) RETURN VARCHAR2
IS
   temp_objid_ VARCHAR2(100);
   CURSOR getobjid IS
      SELECT rowid
      FROM   ORDER_QUOTATION_TAB
      WHERE  quotation_no = quotation_no_;
BEGIN
   OPEN  getobjid;
   FETCH getobjid INTO temp_objid_;
   CLOSE getobjid;
   RETURN temp_objid_;
END Get_Objid__;

-- Get_Total_Base_Price
--   Retrive the total base price for the specified quotation.
@UncheckedAccess
FUNCTION Get_Total_Base_Price (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_base_price_ NUMBER := 0;
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM  ORDER_QUOTATION_LINE_TAB
      WHERE rowstate != 'Cancelled'
      AND   line_item_no <= 0
      AND   quotation_no = quotation_no_;   
BEGIN
   FOR rec_ IN get_lines LOOP
      total_base_price_ := total_base_price_ + Order_Quotation_Line_API.Get_Base_Sale_Price_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
   END LOOP;   
   RETURN NVL(total_base_price_, 0);
END Get_Total_Base_Price;


-- Get_Total_Base_Price_Incl_Tax
--   Retrive the total base price including tax for the specified quotation.
@UncheckedAccess
FUNCTION Get_Total_Base_Price_Incl_Tax (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_base_price_incl_tax_ NUMBER := 0;
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM  ORDER_QUOTATION_LINE_TAB
      WHERE rowstate != 'Cancelled'
      AND   line_item_no <= 0
      AND   quotation_no = quotation_no_;
BEGIN
   FOR rec_ IN get_lines LOOP
      total_base_price_incl_tax_ := total_base_price_incl_tax_ + Order_Quotation_Line_API.Get_Base_Price_Incl_Tax_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
   END LOOP;
   RETURN NVL(total_base_price_incl_tax_, 0);
END Get_Total_Base_Price_Incl_Tax;


-- Modify
--   Public interface for modification of quotation attributes.
--   The attributes to be modified should be passed in an attribute string.
PROCEDURE Modify (
   info_         OUT    VARCHAR2,
   attr_         IN OUT VARCHAR2,
   quotation_no_ IN     VARCHAR2 )
IS
   oldrec_     ORDER_QUOTATION_TAB%ROWTYPE;
   newrec_     ORDER_QUOTATION_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(quotation_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);      
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   info_ := Client_SYS.Get_All_Info;
END Modify;


-- Modify_Calc_Disc_Flag
--   Modify calc_disc_flag
PROCEDURE Modify_Calc_Disc_Flag (
   quotation_no_   IN VARCHAR2,
   calc_disc_flag_ IN VARCHAR2 )
IS
   oldrec_     ORDER_QUOTATION_TAB%ROWTYPE;
   newrec_     ORDER_QUOTATION_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(quotation_no_);
   IF (oldrec_.calc_disc_flag != calc_disc_flag_) THEN
      Client_SYS.Clear_Attr(attr_);
      newrec_ := oldrec_;
      Client_SYS.Add_To_Attr('CALC_DISC_FLAG', calc_disc_flag_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);      
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Modify_Calc_Disc_Flag;


-- Modify_Printed_Flag
--   Modify PRINTED flag when printing and after a new revision was set
PROCEDURE Modify_Printed_Flag (
   quotation_no_ IN VARCHAR2,
   printed_      IN VARCHAR2 )
IS
   oldrec_      ORDER_QUOTATION_TAB%ROWTYPE;
   newrec_      ORDER_QUOTATION_TAB%ROWTYPE;
   objid_       ROWID;
   objversion_  ORDER_QUOTATION.OBJVERSION%TYPE;
   attr_        VARCHAR2(32000);
   indrec_      Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___( quotation_no_ );
   IF (oldrec_.rowstate = 'Released') THEN
      Client_SYS.Clear_Attr(attr_);
      newrec_ := oldrec_;
      Client_SYS.Add_To_Attr('PRINTED_DB', printed_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);       
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Modify_Printed_Flag;


-- New
--   Public interface for creating a new customer quotation
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS  
   new_attr_            VARCHAR2(32000);
   newrec_              ORDER_QUOTATION_TAB%ROWTYPE;
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);   
   indrec_              Indicator_Rec;
BEGIN   
   new_attr_:= Build_Attr_For_New___(attr_);
   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);
   info_ := Client_SYS.Get_All_Info;
   attr_ := new_attr_;
END New;


-- Quotation_Changed
--   Called by OrderQuotationLine when a line is changed.
PROCEDURE Quotation_Changed (
   quotation_no_ IN VARCHAR2 )
IS
   rec_  ORDER_QUOTATION_TAB%ROWTYPE;
   attr_ VARCHAR2(32000);
BEGIN
   rec_ := Lock_By_Keys___( quotation_no_ );
   Finite_State_Machine___( rec_, 'QuotationChanged', attr_ );
END Quotation_Changed;

-- Create_Order
--   Create a customer order from a quotation, using all quoted lines.
--   Create a customer order head from a quotation head.
PROCEDURE Create_Order (
   quotation_no_       IN     VARCHAR2,
   info_               OUT    VARCHAR2,
   param_attr_         IN OUT VARCHAR2,
   check_status_       IN     VARCHAR2 DEFAULT NULL,
   skip_release_order_ IN     VARCHAR2 DEFAULT NULL,
   update_won_         IN     VARCHAR2 DEFAULT NULL)
IS
   rec_           ORDER_QUOTATION_TAB%ROWTYPE;
   order_no_      CUSTOMER_ORDER_TAB.order_no%TYPE;
   auth_group_    VARCHAR2(2);
   current_co_no_ NUMBER;
   external_tax_calc_method_  VARCHAR2(50);
BEGIN   
   rec_           := Lock_By_Keys___( quotation_no_ );
   auth_group_    := Order_Coordinator_API.Get_Authorize_Group(rec_.authorize_code);
   current_co_no_ := Order_Coordinator_Group_API.Get_Cust_Order_No(auth_group_);
   
   --If the update won reason check box is not selected no need to send the modified reason id in the attr_.
   IF (update_won_ = 'FALSE') THEN
      IF (rec_.reason_id IS NOT NULL) THEN
         -- Override the new reason id in attr_ with the previous one. 
         Client_SYS.Set_Item_Value( 'REASON_ID', rec_.reason_id, param_attr_ );
      END IF;            
      IF (rec_.lose_win_reject_note IS NOT NULL) THEN
         -- Override the lose win note in attr_ with the previous one. 
         Client_SYS.Set_Item_Value( 'LOSE_WIN_REJECT_NOTE', rec_.lose_win_reject_note, param_attr_ );
      END IF;
   END IF;
   
   Client_SYS.Add_To_Attr( 'CREATE_FROM_HEADER', db_true_, param_attr_ );
   
   IF (rec_.rowstate IN ('Cancelled', 'Closed')) THEN
      Error_SYS.Record_General( lu_name_, 'UPDNOTALLOWED: Cannot create a customer order for Cancelled or Closed quotation' );
   END IF;
   
   IF ((trunc(Site_API.Get_Site_Date( rec_.contract )) <= rec_.expiration_date) OR (rec_.expiration_date IS NULL)) THEN
      Finite_State_Machine___( rec_, 'QuotationOrderCreated', param_attr_ );
   ELSE
      Error_SYS.Record_General( lu_name_, 'EXPIRATIONDATE: Quotation :P1 has expired', p1_ => rec_.quotation_no );
   END IF;
   
   info_ := Client_SYS.Get_All_Info;
   
   IF skip_release_order_ = db_false_ THEN
      order_no_ := Client_SYS.Get_Item_Value('CREATED_ORDER_NO', param_attr_);
      
      IF (check_status_ =db_true_) THEN  
         Release_Customer_Order__(order_no_);
      ELSE
         external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(rec_.company);

         IF (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX ) THEN 
            Customer_Order_API.Fetch_External_Tax(order_no_);
         END IF;
       END IF;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      IF (current_co_no_ IS NOT NULL) THEN
         Order_Coordinator_Group_API.Reset_Cust_Order_No_Autonomous(auth_group_, current_co_no_);
      END IF;
      RAISE;
END Create_Order;


PROCEDURE Create_Order_Head (
   order_no_                   IN OUT VARCHAR2,
   quotation_no_               IN     VARCHAR2,
   order_id_                   IN     VARCHAR2,
   wanted_del_date_            IN     DATE,
   create_from_header_         IN     VARCHAR2,
   pre_accounting_id_          IN OUT NUMBER,
   customer_po_no_             IN     VARCHAR2,
   limit_sales_to_assortments_ IN     VARCHAR2,
   copy_all_rep_               IN     VARCHAR2,
   main_representative_        IN     VARCHAR2,
   copy_contacts_              IN     VARCHAR2)
IS
   rec_  ORDER_QUOTATION_TAB%ROWTYPE;
   attr_ VARCHAR2(32000);
   info_ VARCHAR2(2000);
   main_rep_ VARCHAR2(1000); 
   is_main_rep_ VARCHAR2(50);
BEGIN
   -- Get header data
   rec_ := Get_Object_By_Keys___( quotation_no_ );
   
   -- Check state
   IF (rec_.rowstate IN ('Cancelled','Closed')) THEN
      Error_SYS.Record_General(lu_name_, 'UPDNOTALLOWED: Cannot create a customer order for Cancelled or Closed quotation');
   END IF;
   
   IF (rec_.rowstate != 'Released') THEN
      Error_SYS.Record_General(lu_name_, 'CRTORDHDR: Quotation :P1 should be released for creating an order', rec_.quotation_no );
   END IF;
   
   -- Check customer from prospect
   IF (rec_.customer_no IS NULL) THEN
      -- We have a prospect
      -- Manage this here
      NULL;
   END IF;
   
   IF (rec_.ship_addr_no IS NULL) OR (rec_.bill_addr_no IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOTNULLSHIPNO: The Delivery Address and Document Address fields must have values.');
   END IF;
   
   attr_ := Build_Attr_Create_Ord_Head___(rec_, customer_po_no_, order_id_, create_from_header_, wanted_del_date_, quotation_no_, limit_sales_to_assortments_);
   
   -- Fetch missing values from the customer/prospect.
   Get_Quote_Defaults___(attr_);
   Client_SYS.Add_To_Attr( 'MAIN_REPRESENTATIVE_ID', main_representative_, attr_);
   
   Customer_Order_API.New(info_, attr_ );
   
   order_no_          := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
   pre_accounting_id_ := Client_SYS.Get_Item_Value('PRE_ACCOUNTING_ID', attr_);
   main_rep_          := Client_SYS.Get_Item_Value('MAIN_REPRESENTATIVE_ID', attr_);
   is_main_rep_       := Fnd_Boolean_API.DB_FALSE;
   
   $IF Component_Rmcom_SYS.INSTALLED $THEN   
      -- Copy all Contacts and Representatives for the Opportunity record.
      IF (order_no_ IS NOT NULL AND copy_all_rep_ = Fnd_Boolean_API.DB_TRUE) THEN
         IF main_rep_ IS NULL THEN
            is_main_rep_ := Fnd_Boolean_API.DB_TRUE;
         END IF;
         Bus_Obj_Representative_API.Copy_Representative(quotation_no_, 
                                                        order_no_, 
                                                        Business_Object_Type_API.DB_SALES_QUOTATION, 
                                                        Business_Object_Type_API.DB_CUSTOMER_ORDER, 
                                                        is_main_rep_ );
      END IF;
      Bus_Obj_Representative_API.Modify_Representative_Role(quotation_no_, 
                                                            order_no_, 
                                                            Business_Object_Type_API.DB_SALES_QUOTATION, 
                                                            Business_Object_Type_API.DB_CUSTOMER_ORDER);
      -- Copy Contact Info to Customer Order
      IF (order_no_ IS NOT NULL AND copy_contacts_ = Fnd_Boolean_API.DB_TRUE) THEN
         Business_Object_Contact_API.Copy_Contact(quotation_no_, 
                                                  order_no_, 
                                                  Business_Object_Type_API.DB_SALES_QUOTATION, 
                                                  Business_Object_Type_API.DB_CUSTOMER_ORDER);
      END IF;
   $END
   Order_Quotation_History_API.New(quotation_no_, 
                                   Language_SYS.Translate_Constant(lu_name_, 'CONVERTED_ORDER: Customer Order :P1 has been created.', NULL, order_no_));
   
   IF rec_.single_occ_addr_flag = Fnd_Boolean_API.DB_TRUE THEN 
      Customer_Order_Address_API.New(order_no_           => order_no_,
                                     addr_1_             => rec_.ship_addr_name,
                                     address1_           => rec_.ship_address1,
                                     address2_           => rec_.ship_address2,
                                     address3_           => rec_.ship_address3,
                                     address4_           => rec_.ship_address4,
                                     address5_           => rec_.ship_address5,
                                     address6_           => rec_.ship_address6,
                                     zip_code_           => rec_.ship_addr_zip_code,
                                     city_               => rec_.ship_addr_city,
                                     state_              => rec_.ship_addr_state,
                                     county_             => rec_.ship_addr_county,
                                     country_code_       => rec_.ship_addr_country_code,
                                     in_city_            => rec_.ship_addr_in_city,
                                     vat_free_vat_code_  => rec_.vat_free_vat_code);
   END IF;
   
   IF (info_ IS NOT NULL) THEN
      IF (SUBSTR(info_, 1, 5) = 'INFO' || Client_SYS.field_separator_) THEN
         Client_SYS.Add_Info(lu_name_, SUBSTR(info_, 6, LENGTH(info_) - 7));
      END IF;
   END IF;
END Create_Order_Head;


-- Get_Packed_Customer_Data
--   Return a string which is customer data for using it with quick customer
--   registration ( cMessage )
FUNCTION Get_Packed_Customer_Data (
   quotation_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_           ORDER_QUOTATION_TAB%ROWTYPE;
   msg_           VARCHAR2(32000);
   customer_no_   NUMBER := NULL;
   ean_location_  VARCHAR2(100);
BEGIN
   rec_ := Get_Object_By_Keys___( quotation_no_ );
   
   -- retrieve value for customer ID
   -- check whether customer ID exist.
   -- if exist, call Update_Next_Identity to increase the "customer identity value".
   -- exit from the loop if customer ID does not exist.
   
   customer_no_ := Customer_Info_API.Get_Next_Identity();
   msg_         := Message_SYS.Construct('ORDER_QUOTATION');
   
   Message_SYS.Add_Attribute(msg_, 'NEW_CUSTOMER_ID',   customer_no_);
   Message_SYS.Add_Attribute(msg_, 'CUST_REF',          rec_.cust_ref );
   IF rec_.ship_addr_no IS NOT NULL THEN
      Message_SYS.Add_Attribute(msg_, 'DEL_NAME',       nvl(Customer_Info_Address_API.Get_Name(rec_.customer_no,rec_.ship_addr_no),Customer_Info_API.Get_Name(rec_.customer_no)));
   ELSE
      Message_SYS.Add_Attribute(msg_, 'DEL_NAME',       '');
   END IF;      
   Message_SYS.Add_Attribute(msg_, 'DEL_ADDRESS1',      Cust_Ord_Customer_Address_API.Get_Address1(rec_.customer_no,rec_.ship_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DEL_ADDRESS2',      Cust_Ord_Customer_Address_API.Get_Address2(rec_.customer_no,rec_.ship_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DEL_ADDRESS3',      Cust_Ord_Customer_Address_API.Get_Address3(rec_.customer_no,rec_.ship_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DEL_ADDRESS4',      Cust_Ord_Customer_Address_API.Get_Address4(rec_.customer_no,rec_.ship_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DEL_ADDRESS5',      Cust_Ord_Customer_Address_API.Get_Address5(rec_.customer_no,rec_.ship_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DEL_ADDRESS6',      Cust_Ord_Customer_Address_API.Get_Address6(rec_.customer_no,rec_.ship_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DEL_ZIP_CODE',      Cust_Ord_Customer_Address_API.Get_Zip_Code(rec_.customer_no,rec_.ship_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DEL_CITY',          Cust_Ord_Customer_Address_API.Get_City(rec_.customer_no,rec_.ship_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DEL_STATE',         Cust_Ord_Customer_Address_API.Get_State(rec_.customer_no,rec_.ship_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DEL_COUNTY',        Cust_Ord_Customer_Address_API.Get_County(rec_.customer_no,rec_.ship_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DEL_COUNTRY',       Iso_Country_API.Decode(Cust_Ord_Customer_Address_API.Get_Country_Code(rec_.customer_no,rec_.ship_addr_no)));
   Message_SYS.Add_Attribute(msg_, 'DEL_EAN_LOCATION',  ean_location_);
   IF rec_.ship_addr_no IS NOT NULL THEN
      Message_SYS.Add_Attribute(msg_, 'DOC_NAME',       nvl(Customer_Info_Address_API.Get_Name(rec_.customer_no,rec_.bill_addr_no),Customer_Info_API.Get_Name(rec_.customer_no)));
   ELSE
      Message_SYS.Add_Attribute(msg_, 'DOC_NAME',       '');
   END IF;
   Message_SYS.Add_Attribute(msg_, 'DOC_ADDRESS1',      Cust_Ord_Customer_Address_API.Get_Address1(rec_.customer_no,rec_.bill_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DOC_ADDRESS2',      Cust_Ord_Customer_Address_API.Get_Address2(rec_.customer_no,rec_.bill_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DOC_ADDRESS3',      Cust_Ord_Customer_Address_API.Get_Address3(rec_.customer_no,rec_.bill_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DOC_ADDRESS4',      Cust_Ord_Customer_Address_API.Get_Address4(rec_.customer_no,rec_.bill_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DOC_ADDRESS5',      Cust_Ord_Customer_Address_API.Get_Address5(rec_.customer_no,rec_.bill_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DOC_ADDRESS6',      Cust_Ord_Customer_Address_API.Get_Address6(rec_.customer_no,rec_.bill_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DOC_ZIP_CODE',      Cust_Ord_Customer_Address_API.Get_Zip_Code(rec_.customer_no,rec_.bill_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DOC_CITY',          Cust_Ord_Customer_Address_API.Get_City(rec_.customer_no,rec_.bill_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DOC_STATE',         Cust_Ord_Customer_Address_API.Get_State(rec_.customer_no,rec_.bill_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DOC_COUNTY',        Cust_Ord_Customer_Address_API.Get_County(rec_.customer_no,rec_.bill_addr_no));
   Message_SYS.Add_Attribute(msg_, 'DOC_COUNTRY',       Iso_Country_API.Decode(Cust_Ord_Customer_Address_API.Get_Country_Code(rec_.customer_no,rec_.bill_addr_no)));
   Message_SYS.Add_Attribute(msg_, 'DOC_EAN_LOCATION',  ean_location_);
   Message_SYS.Add_Attribute(msg_, 'SALESMAN_CODE',     rec_.salesman_code);
   Message_SYS.Add_Attribute(msg_, 'SHIP_VIA_CODE',     rec_.ship_via_code);
   Message_SYS.Add_Attribute(msg_, 'DELIVERY_TERMS',    rec_.delivery_terms);
   Message_SYS.Add_Attribute(msg_, 'DEL_TERMS_LOCATION',rec_.del_terms_location);
   Message_SYS.Add_Attribute(msg_, 'PAY_TERM_ID',       rec_.pay_term_id);
   Message_SYS.Add_Attribute(msg_, 'TAX_LIABILITY',     rec_.tax_liability);
   Message_SYS.Add_Attribute(msg_, 'LANGUAGE_CODE',     rec_.language_code);
   Message_SYS.Add_Attribute(msg_, 'REGION_CODE',       rec_.region_code);
   Message_SYS.Add_Attribute(msg_, 'DISTRICT_CODE',     rec_.district_code);
   Message_SYS.Add_Attribute(msg_, 'MARKET_CODE',       rec_.market_code);
   RETURN msg_;
END Get_Packed_Customer_Data;


-- Set_Customer_No
--   Update customer no of a quotation when creating an order with a prospect
--   ( after quick customer registration was called )
PROCEDURE Set_Customer_No (
   quotation_no_ IN VARCHAR2,
   customer_no_  IN VARCHAR2 )
IS
   attr_     VARCHAR2(32000);
   rec_      ORDER_QUOTATION_TAB%ROWTYPE;
   newrec_   ORDER_QUOTATION_TAB%ROWTYPE;
   oldrec_   ORDER_QUOTATION_TAB%ROWTYPE;
   objid_    ORDER_QUOTATION.objid%TYPE;
   objver_   ORDER_QUOTATION.objversion%TYPE;
   company_  ORDER_QUOTATION_TAB.company%TYPE;
   contract_ ORDER_QUOTATION_TAB.contract%TYPE;
   indrec_   Indicator_Rec;
BEGIN
   
   Client_SYS.Clear_Attr( attr_ );
   Client_SYS.Add_To_Attr( 'CUSTOMER_NO', customer_no_, attr_ );
   company_  := Get_Company(quotation_no_);
   Client_SYS.Add_To_Attr( 'COMPANY', company_, attr_ );
   contract_ := Get_Contract(quotation_no_);
   Client_SYS.Add_To_Attr( 'CONTRACT', contract_, attr_ );
   Get_Customer_Defaults__(attr_);
   
   Client_SYS.Add_To_Attr( 'UPDATED_FROM_WIZARD', 'TRUE', attr_ );  
   
   rec_    := Lock_By_Keys___( quotation_no_ );
   newrec_ := rec_;      
   oldrec_ := newrec_;
   Client_SYS.Add_To_Attr( 'DELIVERY_LEADTIME', NVL(newrec_.delivery_leadtime,0), attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___( objid_, rec_, newrec_, attr_, objver_, TRUE );
END Set_Customer_No;


-- Set_Quotation_Date
--   Set the quotation date
PROCEDURE Set_Quotation_Date (
   quotation_no_ IN VARCHAR2 )
IS
   oldrec_  ORDER_QUOTATION_TAB%ROWTYPE;
   newrec_  ORDER_QUOTATION_TAB%ROWTYPE;
   objid_   ROWID;
   objver_  ORDER_QUOTATION.objversion%TYPE;
   attr_    VARCHAR2(32000);
BEGIN
   oldrec_ := Lock_By_Keys___( quotation_no_ );
   -- Update quotation date only if printed flag is unset
   IF (oldrec_.rowstate = 'Released') AND (oldrec_.printed = 'NOTPRINTED') THEN
      newrec_                := oldrec_;
      newrec_.quotation_date := Site_API.Get_Site_Date(newrec_.contract);
      Update___( objid_, oldrec_, newrec_, attr_, objver_, TRUE );
   END IF;
END Set_Quotation_Date;


-- Get_Latest_Quotation_No
--   Return the last quotation number for the specified customer.
@UncheckedAccess
FUNCTION Get_Latest_Quotation_No (
   quotation_no_ IN VARCHAR2,
   customer_no_  IN VARCHAR2,
   contract_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ ORDER_QUOTATION_TAB.quotation_no%TYPE;
   CURSOR get_latest IS
      SELECT quotation_no
      FROM   ORDER_QUOTATION_TAB
      WHERE  customer_no = customer_no_
      AND    contract = contract_
      AND    quotation_no != quotation_no_
      AND    date_entered = (SELECT max(date_entered)
                             FROM   ORDER_QUOTATION_TAB
                             WHERE  customer_no = customer_no_
                             AND    contract = contract_
                             AND    quotation_no != quotation_no_);
BEGIN
   OPEN  get_latest;
   FETCH get_latest INTO temp_;
   CLOSE get_latest;
   RETURN temp_;
END Get_Latest_Quotation_No;


-- Find_External_Ref_Quote
--   Check if a quotation has this external reference
FUNCTION Find_External_Ref_Quote (
   reference_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_quote IS
      SELECT quotation_no
      FROM   ORDER_QUOTATION_TAB
      WHERE  external_ref = reference_
      AND    rowstate != 'Cancelled';
   quotation_no_  ORDER_QUOTATION_TAB.quotation_no%TYPE;
BEGIN
   OPEN get_quote;
   FETCH get_quote INTO quotation_no_;
   IF get_quote%NOTFOUND THEN
      quotation_no_ := NULL;
   END IF;
   CLOSE get_quote;
   RETURN quotation_no_;
END Find_External_Ref_Quote;


-- Find_External_Ref_Quote
--   Check if a quotation has this external reference
FUNCTION Find_External_Ref_Quote (
   reference_   IN VARCHAR2,
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_quote IS
      SELECT quotation_no
      FROM   ORDER_QUOTATION_TAB
      WHERE  external_ref = reference_
      AND    customer_no = customer_no_
      AND    rowstate != 'Cancelled';
   quotation_no_  ORDER_QUOTATION_TAB.quotation_no%TYPE;
BEGIN
   OPEN get_quote;
   FETCH get_quote INTO quotation_no_;
   IF get_quote%NOTFOUND THEN
      quotation_no_ := NULL;
   END IF;
   CLOSE get_quote;
   RETURN quotation_no_;
END Find_External_Ref_Quote;


-- Transfer_Charge_To_Order
--   Transfer charges from quotation to customer order.
PROCEDURE Transfer_Charge_To_Order (
   quotation_no_ IN VARCHAR2,
   con_order_no_ IN VARCHAR2 )
IS
   CURSOR GetCharges( quotation_no_ IN VARCHAR2 ) IS
      SELECT DISTINCT quotation_charge_no
        FROM order_quotation_charge_tab qc, order_quotation_line_tab ql
        WHERE qc.quotation_no = quotation_no_
        AND (qc.line_no IS NULL OR ql.quotation_no = quotation_no_
                                AND ql.line_no = qc.line_no
                                AND ql.rel_no = qc.rel_no
                                AND ql.line_item_no = qc.line_item_no
                                AND ql.rowstate != 'Lost');
   quotation_charge_no_  ORDER_QUOTATION_CHARGE_TAB.quotation_charge_no%TYPE;
BEGIN
   -- Create charges and delete defaulted charge tax lines.
   OPEN GetCharges( quotation_no_ );
   FETCH GetCharges INTO quotation_charge_no_;
   WHILE GetCharges%FOUND LOOP
      Order_Quotation_Charge_API.Transfer_To_Order( quotation_no_, quotation_charge_no_, con_order_no_ );
      FETCH GetCharges INTO quotation_charge_no_;
   END LOOP;
   CLOSE GetCharges;
END Transfer_Charge_To_Order;


-- Check_Acquisition
--   Check if it exist any quotation line with supply code set to Not Decided.
PROCEDURE Check_Acquisition (
   info_         OUT VARCHAR2,
   quotation_no_ IN  VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE quotation_no = quotation_no_
      AND   rowstate NOT IN ('Planned', 'Cancelled', 'Closed')
      AND   order_supply_type = 'ND';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF exist_control%FOUND THEN
      Client_SYS.Add_Warning(lu_name_, 'ACQUISITION: Quotation Lines with supply code Not Decided exists. The created order will not be released. Proceed?');
   END IF;
   CLOSE exist_control;
   info_ := Client_SYS.Get_All_Info;
END Check_Acquisition;


-- Get_Total_Add_Discount_Amount
--   Retrives the total additional discount amount in base price for the
--   specified order quotation, in base currency rounding.
@UncheckedAccess
FUNCTION Get_Total_Add_Discount_Amount (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   quoterec_               ORDER_QUOTATION_TAB%ROWTYPE;
   add_discount_amt_       NUMBER;
   total_amount_           NUMBER;
   add_discount_           NUMBER;
   currency_rounding_      NUMBER;
   line_discount_amount_   NUMBER;
   rental_chargeable_days_ NUMBER;
   
   CURSOR get_add_disc_amt IS
      SELECT line_no, rel_no, line_item_no, buy_qty_due, price_conv_factor,
             (buy_qty_due * price_conv_factor * sale_unit_price) total_net_amount,
             (buy_qty_due * price_conv_factor * unit_price_incl_tax) total_gross_amount, 
             additional_discount, rental
      FROM  ORDER_QUOTATION_LINE_TAB
      WHERE rowstate != 'Cancelled'
      AND   line_item_no <= 0
      AND   quotation_no = quotation_no_;
BEGIN
   quoterec_          := Get_Object_By_Keys___(quotation_no_);
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(quoterec_.company, quoterec_.currency_code);
   add_discount_amt_  := 0;
   FOR rec_ IN get_add_disc_amt LOOP
      IF (quoterec_.use_price_incl_tax = Fnd_Boolean_API.DB_TRUE) THEN
         total_amount_ := NVL(rec_.total_gross_amount, 0);
      ELSE
         total_amount_ := NVL(rec_.total_net_amount, 0);
      END IF;
      IF (rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
         $IF Component_Rental_SYS.INSTALLED $THEN
            rental_chargeable_days_ := Rental_Object_API.Get_Rental_Chargeable_Days(quotation_no_, 
                                                                                    rec_.line_no, 
                                                                                    rec_.rel_no, 
                                                                                    rec_.line_item_no, 
                                                                                    Rental_Type_API.DB_ORDER_QUOTATION);
            total_amount_           := total_amount_ * rental_chargeable_days_;
         $ELSE
            NULL;
         $END
      END IF;
      
      add_discount_         := NVL(rec_.additional_discount, 0);
      -- Modified calculation logic of line_discount_amount_ 
      line_discount_amount_ := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.buy_qty_due, rec_.price_conv_factor, currency_rounding_);
      add_discount_amt_     := add_discount_amt_ + ROUND(((total_amount_ - line_discount_amount_) * NVL(add_discount_, 0)/100), currency_rounding_);
   END LOOP;
   RETURN NVL(add_discount_amt_, 0);
END Get_Total_Add_Discount_Amount;


-- Quotation_Lines_Exist
--   This function is true if there is a quotation line for a particular order quotation.
@UncheckedAccess
FUNCTION Quotation_Lines_Exist (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR quotation_lines_exist IS
      SELECT 1
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_;
BEGIN
   OPEN quotation_lines_exist;
   FETCH quotation_lines_exist INTO dummy_;
   IF (quotation_lines_exist%NOTFOUND) THEN
      dummy_ := 0;
   END IF;
   CLOSE quotation_lines_exist;
   RETURN dummy_;
END Quotation_Lines_Exist;


-- Set_Cancelled
--   Set Cancelled the Quotation.
PROCEDURE Set_Cancelled (
   quotation_no_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   info_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_);
   Cancel__(info_, objid_, objversion_, attr_, 'DO');
END Set_Cancelled;


-- Set_Released
--   Release the Quotation.
PROCEDURE Set_Released (
   quotation_no_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   info_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_);
   Release__(info_, objid_, objversion_, attr_, 'DO');
END Set_Released;

-- Set_Rejected
--   Reject the Quotation.
PROCEDURE Set_Rejected (
   quotation_no_    IN VARCHAR2,
   rejected_reason_ IN VARCHAR2 DEFAULT NULL )
IS
   attr_       VARCHAR2(32000);
   info_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('LOSE_WIN_REJECT_NOTE', rejected_reason_, attr_);
   
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_);
   Reject__(info_, objid_, objversion_, attr_, 'DO');
END Set_Rejected;

-- Finite_State_Decode
--   Returns the client value of the state.
@UncheckedAccess
FUNCTION Finite_State_Decode (
   db_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Finite_State_Decode__(db_state_);
END Finite_State_Decode;


-- Get_Total_Tax_Amount
--   Retrive the total tax amount for a quotation in order currency
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_tax_amount_  NUMBER := 0;
   next_line_tax_     NUMBER := 0;
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no, currency_rate
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE quotation_no = quotation_no_
      AND   line_item_no <= 0
      AND   rowstate != 'Cancelled';
BEGIN
   FOR next_line_ IN get_lines LOOP
      next_line_tax_ := Order_Quotation_Line_API.Get_Total_Tax_Amount_Curr(quotation_no_,
                                                                           next_line_.line_no,
                                                                           next_line_.rel_no,
                                                                           next_line_.line_item_no);
      
      
      total_tax_amount_ := total_tax_amount_ + next_line_tax_;
   END LOOP;
   RETURN total_tax_amount_;
END Get_Total_Tax_Amount;


-- Get_Total_Tax_Amount_Base
--   Retrive the total tax amount for a quotation in base currency
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount_Base (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_tax_amount_  NUMBER := 0;
   next_line_tax_     NUMBER := 0;
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no, currency_rate
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE quotation_no = quotation_no_
      AND   line_item_no <= 0
      AND   rowstate != 'Cancelled';
BEGIN
   FOR next_line_ IN get_lines LOOP
      next_line_tax_ := Order_Quotation_Line_API.Get_Total_Tax_Amount(quotation_no_,
                                                                      next_line_.line_no,
                                                                      next_line_.rel_no,
                                                                      next_line_.line_item_no);
      
      
      total_tax_amount_ := total_tax_amount_ + next_line_tax_;
   END LOOP;
   RETURN total_tax_amount_;
END Get_Total_Tax_Amount_Base;


-- Get_Gross_Amount
--   Retrive the total gross amount for all quotation lines on this quotation
--   in order currency.
@UncheckedAccess
FUNCTION Get_Gross_Amount (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_gross_amount_   NUMBER := 0;
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  rowstate != 'Cancelled'
      AND    line_item_no <= 0
      AND    quotation_no = quotation_no_;
BEGIN
   -- Modified the logic to consider price including tax.
   IF (Get_Use_Price_Incl_Tax_Db(quotation_no_) = 'TRUE') THEN
      FOR rec_ IN get_lines LOOP
         total_gross_amount_ := total_gross_amount_ + Order_Quotation_Line_API.Get_Sale_Price_Incl_Tax_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no) ;
      END LOOP;
   ELSE
      total_gross_amount_ := Get_Total_Sale_Price__(quotation_no_) + Get_Total_Tax_Amount(quotation_no_);
   END IF;
   
   RETURN NVL(total_gross_amount_, 0);
END Get_Gross_Amount;

-- Get_Net_Amount
--   Public interface to retrive the total net amount for all quotation lines on this quotation
--   in order currency.
@UncheckedAccess
FUNCTION Get_Net_Amount (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_net_amount_ NUMBER := 0;
BEGIN
   total_net_amount_ := Get_Total_Sale_Price__(quotation_no_);
   RETURN NVL(total_net_amount_, 0);
END Get_Net_Amount;

-- Get_Tot_Charge_Sale_Tax_Amt
--   Public function to return the sum of tax of all charge lines for a given Quotation.
@UncheckedAccess
FUNCTION Get_Tot_Charge_Sale_Tax_Amt (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_tax_amount_ NUMBER;
   
   CURSOR get_total_tax IS
      SELECT SUM(Order_Quotation_Charge_API.Get_Total_Tax_Amount(a.quotation_no, a.quotation_charge_no))
      FROM ORDER_QUOTATION_CHARGE_TAB a, ORDER_QUOTATION_TAB b
      WHERE b.quotation_no = quotation_no_
        AND b.rowstate != 'Cancelled'
        AND b.quotation_no = a.quotation_no;
BEGIN
   IF Exist_Charges__ (quotation_no_) = 0 THEN
      total_tax_amount_ := 0;
   ELSE
      OPEN get_total_tax;
      FETCH get_total_tax INTO total_tax_amount_;
      CLOSE get_total_tax;
   END IF;   
   RETURN NVL(total_tax_amount_,0) ;
END Get_Tot_Charge_Sale_Tax_Amt;


-- Set_Cancel_Reason
--   This method updates the cancel_reason column with the passed in value.
PROCEDURE Set_Cancel_Reason (
   quotation_no_  IN VARCHAR2,
   cancel_reason_ IN VARCHAR2 )
IS
   info_ VARCHAR2(32000);
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Set_Item_Value('CANCEL_REASON', cancel_reason_, attr_);
   Modify(info_, attr_, quotation_no_);
END Set_Cancel_Reason;

-- Updatable_Lines_Exist
--   Returns whether there are quotation lines for the given quotation which can be updated.
@UncheckedAccess
FUNCTION Updatable_Lines_Exist (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER;
   
   CURSOR quotation_lines_exist IS
      SELECT 1
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    rowstate NOT IN ('Cancelled', 'Lost', 'CO Created');
BEGIN
   OPEN quotation_lines_exist;
   FETCH quotation_lines_exist INTO found_;
   IF (quotation_lines_exist%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE quotation_lines_exist;
   RETURN found_;
END Updatable_Lines_Exist;

-- Rental_Order_Creatable
--   Returns 0 if there are quotation lines without planned rental start date that can be included for CO creation; 1 otherwise
@UncheckedAccess
FUNCTION Rental_Order_Creatable (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_   NUMBER := 1;
   -- Note: Both the modules are checked as the view is created in Order_Quotation_Line_API.Post_Installation_Object method
   $IF Component_Rental_SYS.INSTALLED AND Component_Order_SYS.INSTALLED $THEN
      CURSOR get_incomplete_rentals IS
      SELECT 0
      FROM   ORDER_QUOTATION_RENTAL_LINE
      WHERE  quotation_no = quotation_no_
      AND    planned_rental_start_date IS NULL
      AND    objstate IN  ('Released', 'Won');
   $END
   
BEGIN
   $IF Component_Rental_SYS.INSTALLED AND Component_Order_SYS.INSTALLED $THEN
      OPEN get_incomplete_rentals;
      FETCH get_incomplete_rentals INTO found_;
      IF (get_incomplete_rentals%NOTFOUND) THEN
         found_ := 1;
      END IF;
      CLOSE get_incomplete_rentals;
   $END
   RETURN found_;
END Rental_Order_Creatable;

-- Fetch_Delivery_Attributes
--   This method is used to retrieve delivery information based on the given delivery attributes.
--   If no Freight zone information is defined in supplier chain matrix, the delivery address is considered.
PROCEDURE Fetch_Delivery_Attributes (
   delivery_leadtime_         IN OUT NUMBER,
   ext_transport_calendar_id_ OUT    VARCHAR2,
   freight_map_id_            OUT    VARCHAR2,
   zone_id_                   OUT    VARCHAR2,
   freight_price_list_no_     OUT    VARCHAR2,
   picking_leadtime_          IN OUT NUMBER,
   delivery_terms_            IN OUT VARCHAR2,
   del_terms_location_        IN OUT VARCHAR2,
   forward_agent_id_          IN OUT VARCHAR2,
   quotation_no_              IN     VARCHAR2,
   contract_                  IN     VARCHAR2,
   customer_no_               IN     VARCHAR2,
   ship_addr_no_              IN     VARCHAR2,
   ship_via_code_             IN     VARCHAR2,
   vendor_no_                 IN     VARCHAR2,
   single_occ_addr_flag_      IN     VARCHAR2,
   ship_addr_zip_code_        IN     VARCHAR2,
   ship_addr_city_            IN     VARCHAR2,
   ship_addr_county_          IN     VARCHAR2,
   ship_addr_state_           IN     VARCHAR2,
   ship_addr_country_code_    IN     VARCHAR2,
   ship_via_code_changed_     IN     VARCHAR2 DEFAULT 'FALSE')
IS
   addr_flag_                  VARCHAR2(1) := 'N';
   customer_category_          CUSTOMER_INFO_TAB.customer_category%TYPE;
   route_id_                   VARCHAR2(12);   
   shipment_type_              VARCHAR2(3);
   ship_inventory_location_no_ VARCHAR2(35);
   use_price_incl_tax_db_      ORDER_QUOTATION_TAB.use_price_incl_tax%TYPE;
   zone_info_exist_   VARCHAR2(5) := 'FALSE';
BEGIN   
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(customer_no_);
   IF single_occ_addr_flag_ = 'TRUE' OR (customer_category_ = Customer_Category_API.DB_PROSPECT) THEN 
      addr_flag_ := 'Y';
   END IF;
   
   Cust_Order_Leadtime_Util_API.Fetch_Head_Delivery_Attributes(route_id_,
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
                                                               vendor_no_,
                                                               ship_via_code_changed_); 
   
   IF (single_occ_addr_flag_ = 'TRUE') THEN
      Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details(freight_map_id_,
                                                        zone_id_,
                                                        zone_info_exist_,
                                                        contract_,
                                                        ship_via_code_,
                                                        ship_addr_zip_code_,
                                                        ship_addr_city_,
                                                        ship_addr_county_,
                                                        ship_addr_state_,
                                                        ship_addr_country_code_);
   ELSIF (freight_map_id_ IS NULL) AND (zone_id_ IS NULL) THEN 
      Freight_Zone_Util_API.Fetch_Zone_For_Cust_Addr(freight_map_id_,
                                                     zone_id_,
                                                     customer_no_,
                                                     ship_addr_no_,
                                                     contract_,
                                                     ship_via_code_);
   END IF;
   
   IF (freight_map_id_ IS NOT NULL AND zone_id_ IS NOT NULL) THEN
      use_price_incl_tax_db_ := Get_Use_Price_Incl_Tax_Db(quotation_no_);
      IF (vendor_no_ IS NOT NULL) THEN
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


PROCEDURE Update_Freight_Free_On_Lines (
   quotation_no_ IN VARCHAR2 )
IS
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    (adjusted_weight_gross IS NOT NULL OR adjusted_volume IS NOT NULL)
      AND    rowstate NOT IN ('Cancelled', 'Lost', 'CO Created');
BEGIN
   FOR rec_ IN get_lines LOOP
      Order_Quotation_Line_API.Update_Freight_Free(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
   END LOOP;
END Update_Freight_Free_On_Lines;


@UncheckedAccess
FUNCTION Won_Line_Exist (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER;
   
   CURSOR won_quote_lines_exist IS
      SELECT 1
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    rowstate = 'Won';
BEGIN
   OPEN won_quote_lines_exist;
   FETCH won_quote_lines_exist INTO found_;
   IF (won_quote_lines_exist%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE won_quote_lines_exist;
   RETURN found_;
END Won_Line_Exist;

@UncheckedAccess
FUNCTION Co_Created_Line_Exist (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER;
   
   CURSOR co_created_quote_lines_exist IS
      SELECT 1
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    rowstate = 'CO Created';
BEGIN
   OPEN co_created_quote_lines_exist;
   FETCH co_created_quote_lines_exist INTO found_;
   IF (co_created_quote_lines_exist%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE co_created_quote_lines_exist;   
   RETURN found_;
END Co_Created_Line_Exist;

-- Get_Customer_Count
--   Get no of customers exist in quotations.
@UncheckedAccess
FUNCTION Get_Customer_Count (
   customer_no_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT count(*)
      FROM ORDER_QUOTATION_TAB
      WHERE customer_no = customer_no_;      
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Customer_Count;


-- Get_Ship_Address_Count
--   Get no of ship address exist in quotations.
@UncheckedAccess
FUNCTION Get_Ship_Address_Count (
   customer_no_ IN VARCHAR2,
   address_no_  IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT count(*)
      FROM ORDER_QUOTATION_TAB
      WHERE customer_no = customer_no_
      AND ship_addr_no = address_no_;      
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Ship_Address_Count;

PROCEDURE Modify_Main_Representative(
   quotation_no_ IN VARCHAR2,
   rep_id_       IN VARCHAR2,
   remove_main_  IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS
   oldrec_     ORDER_QUOTATION_TAB%ROWTYPE;
   newrec_     ORDER_QUOTATION_TAB%ROWTYPE;
   attr_       VARCHAR2(32000);
   objid_      ORDER_QUOTATION.objid%TYPE;
   objversion_ ORDER_QUOTATION.objversion%TYPE;
   found_      NUMBER;
   indrec_     Indicator_Rec;
   
   CURSOR check_main_rep IS
      SELECT count(*)
      FROM ORDER_QUOTATION_TAB
      WHERE quotation_no = quotation_no_
      AND main_representative_id = rep_id_ ;     
BEGIN   
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      oldrec_ := Lock_By_Keys___(quotation_no_);
      Client_SYS.Clear_Attr(attr_);      
      
      IF remove_main_ = Fnd_Boolean_API.DB_FALSE THEN
         Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', rep_id_, attr_);
      ELSE
         Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', '', attr_); 
      END IF;
      
      OPEN check_main_rep;
      FETCH check_main_rep INTO found_;
      CLOSE check_main_rep;
      IF (remove_main_ = Fnd_Boolean_API.DB_FALSE AND found_ = 0) OR (remove_main_ = Fnd_Boolean_API.DB_TRUE AND found_ = 1) THEN 
         newrec_ := oldrec_;
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);   
      END IF;
   $ELSE
      NULL;   
   $END
END Modify_Main_Representative;

FUNCTION Check_Exist (
   quotation_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Check_Exist___(quotation_no_));
END Check_Exist;

@UncheckedAccess
FUNCTION Get_Bo_Connected_Quote_No (
   business_opportunity_no_ IN VARCHAR2 ) RETURN VARCHAR2   
IS   
   quotation_no_ VARCHAR2(32000);
   CURSOR get_rec IS 
      SELECT quotation_no
      FROM   ORDER_QUOTATION_TAB
      WHERE  business_opportunity_no = business_opportunity_no_;               
BEGIN  
   FOR rec_ IN get_rec LOOP
      IF quotation_no_ IS NULL THEN
         quotation_no_ := rec_.quotation_no;
      ELSE
         quotation_no_ := quotation_no_ || ',' || rec_.quotation_no;
      END IF;
   END LOOP;
   RETURN quotation_no_;   
END Get_Bo_Connected_Quote_No;

-- Exist_Sales_Quotations
--   Return TRUE if sales quotations exists for the given customer.
--   Else return FALSE.
@UncheckedAccess
FUNCTION Exist_Sales_Quotations (
   customer_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   found_ NUMBER;
   CURSOR exist_quotations IS
      SELECT 1
      FROM   ORDER_QUOTATION_TAB
      WHERE  customer_no = customer_no_
      AND    rowstate != 'Cancelled';
BEGIN
   OPEN exist_quotations;
   FETCH exist_quotations INTO found_;
   IF (exist_quotations%FOUND) THEN
      CLOSE exist_quotations;
      RETURN TRUE;
   END IF;
   CLOSE exist_quotations;
   RETURN FALSE;
END Exist_Sales_Quotations;

PROCEDURE Check_Edit_Allowed(
   quotation_no_ IN VARCHAR2 ) 
IS
BEGIN
   IF (Get_Objstate(quotation_no_) = 'Closed') THEN
      Error_SYS.Record_General(lu_name_, 'CLOSEDQUOTE: Closed quotation may not be changed.');
   END IF;
END Check_Edit_Allowed;

-- Get_Tax_Liability_Type_Db
--   Returns tax liability type db value
@UncheckedAccess
FUNCTION Get_Tax_Liability_Type_Db (
   quotation_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Tax_Liability_API.Get_Tax_Liability_Type_Db(Get_Tax_Liability(quotation_no_), Get_Ship_Addr_Country_Code(quotation_no_));
END Get_Tax_Liability_Type_Db;


-- Remove
--   Public interface for removal of a quotation.
PROCEDURE Remove (
   quotation_no_ IN VARCHAR2 )
IS
   remrec_     ORDER_QUOTATION_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(quotation_no_);
   Check_Delete___(remrec_);
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_);
   Delete___(objid_, remrec_);
END Remove;

-- Released Quotation_Lines_Exist
--   This function is true if there are quotation lines with state released for a particular order quotation.
@UncheckedAccess
FUNCTION Released_Quotation_Lines_Exist (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR quotation_lines_exist IS
      SELECT 1
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  quotation_no = quotation_no_
      AND    rowstate = 'Released';
BEGIN
   OPEN quotation_lines_exist;
   FETCH quotation_lines_exist INTO dummy_;
   IF (quotation_lines_exist%NOTFOUND) THEN
      dummy_ := 0;
   END IF;
   CLOSE quotation_lines_exist;
   RETURN dummy_;
END Released_Quotation_Lines_Exist;

FUNCTION Check_Diff_Delivery_Info (
   quotation_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                NUMBER;
   diff_del_info_    VARCHAR2(5);
   CURSOR get_del_info IS
      SELECT 1
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE quotation_no = quotation_no_
      AND default_addr_flag = 'N';
BEGIN
   OPEN get_del_info;
   FETCH get_del_info INTO temp_;
   IF (get_del_info%FOUND) THEN
      diff_del_info_ := 'TRUE';
   ELSE
      diff_del_info_ := 'FALSE';
   END IF;
   CLOSE get_del_info;
   RETURN diff_del_info_;
END Check_Diff_Delivery_Info;

-- Has_Non_Def_Info_Lines
-- Checks whether there are order quotation lines with Default info flag unchecked
-- and same address as header.
@UncheckedAccess
FUNCTION Has_Non_Def_Info_Lines (
   quotation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER;
   CURSOR non_def_info_lines IS
      SELECT 1
      FROM   ORDER_QUOTATION_LINE_TAB oql, ORDER_QUOTATION_TAB oq
      WHERE  oq.quotation_no = quotation_no_
      AND    oql.quotation_no = oq.quotation_no
      AND    oql.single_occ_addr_flag = oq.single_occ_addr_flag
      AND    oql.default_addr_flag = 'N'
      AND    ((oq.single_occ_addr_flag = 'FALSE' AND oq.ship_addr_no = oql.ship_addr_no) OR 
              (oq.single_occ_addr_flag = 'TRUE'))
      AND oql.line_item_no <= 0
      AND    oql.rowstate NOT IN ('Cancelled', 'Lost', 'Won', 'CO Created');
BEGIN
   
   OPEN non_def_info_lines;
   FETCH non_def_info_lines INTO found_;
   IF (non_def_info_lines%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE non_def_info_lines;
   RETURN found_;
END Has_Non_Def_Info_Lines;

@UncheckedAccess
FUNCTION Get_Lose_Win_Reject_Note (
   quotation_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   lose_win_reject_note_   VARCHAR2(3200);
   CURSOR get_quotation_line IS
      SELECT lose_win_reject_note
      FROM   ORDER_QUOTATION_TAB
      WHERE  quotation_no = quotation_no_;
BEGIN
	OPEN get_quotation_line;
   FETCH get_quotation_line INTO lose_win_reject_note_;
   IF (get_quotation_line%NOTFOUND) THEN
      lose_win_reject_note_ := NULL;
   END IF;
   CLOSE get_quotation_line;
   
	RETURN lose_win_reject_note_;
END Get_Lose_Win_Reject_Note;

@UncheckedAccess
PROCEDURE Remove_Bo_Reference (
   quotation_no_ IN VARCHAR2 )
IS
   objid_                     VARCHAR2(2000);
   objversion_                VARCHAR2(2000);
   newrec_                    order_quotation_tab%ROWTYPE;
   oldrec_                    order_quotation_tab%ROWTYPE;
   attr_                      VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.business_opportunity_no := NULL;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Remove_Bo_Reference;

-- Added client_print_ parameter to identify printing through the client print dialog.
@UncheckedAccess
PROCEDURE Generate_Pdf_Parameters(
   archiving_attr_ OUT VARCHAR2,
   quotation_no_   IN  VARCHAR2,
   contact_        IN  VARCHAR2,
   contract_       IN  VARCHAR2,
   email_          IN  VARCHAR2,
   customer_no_    IN  VARCHAR2,
   report_id_      IN  VARCHAR2 DEFAULT NULL )
IS
   temp_contact_        VARCHAR2(200);
   local_contact_       VARCHAR2(100);
   local_email_         VARCHAR2(200);
   quot_rec_            Order_Quotation_API.Public_Rec;
   report_name_         VARCHAR2(200);
BEGIN  
   local_contact_ := contact_;
   local_email_ := email_;
   quot_rec_ := Get(quotation_no_);
   IF( local_contact_ IS NULL ) THEN
      local_contact_ := quot_rec_.cust_ref;
   END IF;
   
   IF local_contact_ IS NOT NULL THEN
      IF Comm_Method_API.Get_Default_Value('CUSTOMER', quot_rec_.customer_no,'E_MAIL', quot_rec_.bill_addr_no, NULL, local_contact_) IS NULL THEN
         temp_contact_ := Contact_Util_API.Get_Cust_Contact_Name(quot_rec_.customer_no, quot_rec_.bill_addr_no, local_contact_); 
      END IF;
   END IF;
   IF(local_email_ IS NULL AND local_contact_ IS NOT NULL) THEN
      local_email_ := Cust_Ord_Customer_Address_API.Get_Email(quot_rec_.customer_no, local_contact_, quot_rec_.bill_addr_no);
   END IF;
   
   report_name_ := Report_Definition_API.Get_Translated_Report_Title(report_id_);
   report_name_ := report_name_ || '_' || quotation_no_;
      
   IF (Fnd_Session_API.Is_Odp_Session) THEN
      archiving_attr_ := Message_SYS.Construct('PDF');
      Message_SYS.Add_Attribute(archiving_attr_, 'PDF_ARCHIVING', Fnd_Boolean_API.DB_TRUE);
      Message_SYS.Add_Attribute(archiving_attr_, 'PDF_EVENT_PARAM_1', local_email_);
      Message_SYS.Add_Attribute(archiving_attr_, 'PDF_EVENT_PARAM_2', customer_no_);
      Message_SYS.Add_Attribute(archiving_attr_, 'PDF_EVENT_PARAM_3', contract_);
      Message_SYS.Add_Attribute(archiving_attr_, 'PDF_EVENT_PARAM_4', local_contact_);
      Message_SYS.Add_Attribute(archiving_attr_, 'PDF_EVENT_PARAM_5', quotation_no_);
      Message_SYS.Add_Attribute(archiving_attr_, 'PDF_EVENT_PARAM_6', Get_Customer_Quo_No(quotation_no_));
      Message_SYS.Add_Attribute(archiving_attr_, 'PDF_FILE_NAME', report_name_);
      Message_SYS.Add_Attribute(archiving_attr_, 'PDF_EVENT_PARAM_8', NVL(temp_contact_, local_contact_));
      Message_SYS.Add_Attribute(archiving_attr_, 'PDF_EVENT_PARAM_11', Fnd_Boolean_API.DB_TRUE);
      Message_SYS.Add_Attribute(archiving_attr_, 'REPLY_TO_USER', Person_Info_API.Get_User_Id(Get_Authorize_Code(quotation_no_)));
   ELSE
      -- Creating the pdf archiving attr
      Client_SYS.Clear_Attr(archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_ARCHIVING', db_true_, archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_1', local_email_,   archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_2', customer_no_,   archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_3', contract_,      archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_4', local_contact_, archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_5', quotation_no_,  archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_6', Get_Customer_Quo_No(quotation_no_), archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_FILE_NAME', report_name_ , archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_8', NVL(temp_contact_, local_contact_), archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_11', Fnd_Boolean_API.DB_TRUE, archiving_attr_);
      Client_SYS.Add_To_Attr('REPLY_TO_USER', Person_Info_API.Get_User_Id(Get_Authorize_Code(quotation_no_)), archiving_attr_);
   END IF;
END Generate_Pdf_Parameters;

-- Remove all the charge lines from the charge tab.
-- Then add all the applicable charges for the customer and sales parts.
PROCEDURE Add_Charges_On_Cust_Change___ (
   newrec_     IN ORDER_QUOTATION_TAB%ROWTYPE)
IS
   CURSOR get_rec IS
      SELECT *
      FROM   order_quotation_line_tab
      WHERE  quotation_no = newrec_.quotation_no;
   CURSOR get_charges IS
      SELECT *
      FROM   Order_Quotation_Charge_Tab oqc
      WHERE  oqc.quotation_no = newrec_.quotation_no;
BEGIN
   --Remove all the charges with taxes
   FOR chargerec_ IN get_charges LOOP
      Order_Quotation_Charge_API.Remove(newrec_.quotation_no, chargerec_.quotation_charge_no, TRUE);
   END LOOP;
   
   --Add customer charge
   Order_Quotation_Charge_API.Copy_From_Customer_Charge(newrec_.customer_no, 
                                                        newrec_.contract, 
                                                        newrec_.quotation_no);
   
   FOR linerec_ IN get_rec LOOP
    --Add salespart charges
    Order_Quotation_Charge_API.Copy_From_Sales_Part_Charge(newrec_.quotation_no,
                                                           linerec_.line_no,
                                                           linerec_.rel_no,
                                                           linerec_.line_item_no);
    -- Add freight and pac size  charges
    Customer_Order_Charge_Util_API.New_Quotation_Charge_Line(linerec_);
   END LOOP;
  
 END Add_Charges_On_Cust_Change___;

-------------------------------------------------------------------
-- Fetch_External_Tax
--    Fetches tax information from external tax system.
--------------------------------------------------------------------
PROCEDURE Fetch_External_Tax (
   quotation_no_      IN VARCHAR2,
   address_changed_   IN VARCHAR2 DEFAULT 'FALSE',
   include_charges_   IN VARCHAR2 DEFAULT 'TRUE')
IS
   i_                      NUMBER := 1;
   company_                VARCHAR2(20);
   line_source_key_arr_    Tax_Handling_Util_API.source_key_arr;
   
   CURSOR get_quotation_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE rowstate NOT IN ('Cancelled', 'CO Created', 'Lost')
      AND   line_item_no <= 0
      AND   quotation_no = quotation_no_
      AND ( address_changed_ = 'FALSE'  OR default_addr_flag = 'Y' );
      
   CURSOR get_charge_lines IS
      SELECT quotation_charge_no
      FROM ORDER_QUOTATION_CHARGE_TAB 
      WHERE quotation_no = quotation_no_
      AND (quotation_no, line_no, rel_no, line_item_no) NOT IN (SELECT quotation_no, line_no, rel_no, line_item_no
                                                                  FROM   ORDER_QUOTATION_LINE_TAB line
                                                                  WHERE  line.quotation_no = quotation_no_
                                                                  AND   line.rowstate IN ('CO Created')
                                                                  AND ( address_changed_ = 'FALSE' OR default_addr_flag = 'N' ));
   
BEGIN
   company_                  := Site_API.Get_Company(Get_Contract(quotation_no_)); 
   line_source_key_arr_.DELETE;
   FOR rec_ IN get_quotation_lines LOOP
      line_source_key_arr_(i_) := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                                              quotation_no_, 
                                                                              rec_.line_no, 
                                                                              rec_.rel_no, 
                                                                              rec_.line_item_no, 
                                                                              '*',                                                                  
                                                                              attr_ => NULL);
     i_ := i_ + 1;
   END LOOP;
   
   IF include_charges_ = 'TRUE' THEN 
      FOR rec_ IN get_charge_lines LOOP
         line_source_key_arr_(i_) := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_ORDER_QUOTATION_CHARGE,
                                                                                 quotation_no_, 
                                                                                 rec_.quotation_charge_no, 
                                                                                 '*', 
                                                                                 '*', 
                                                                                 '*',                                                                  
                                                                                 attr_ => NULL);
        i_ := i_ + 1;
      END LOOP;
   END IF;
   
   IF line_source_key_arr_.COUNT >= 1 THEN 
      Tax_Handling_Order_Util_API.Fetch_External_Tax_Info(line_source_key_arr_,
                                                          company_);
   END IF;                                                    
   
   Order_Quotation_History_Api.New(quotation_no_, Language_Sys.Translate_Constant(lu_name_,'EXTAXBUNDLECALL: External Taxes Updated'));
END Fetch_External_Tax;

-- gelr:disc_price_rounded, begin
FUNCTION Get_Discounted_Price_Rounded (
   quotation_no_     IN VARCHAR2 ) RETURN BOOLEAN
IS
   disc_price_rounded_ BOOLEAN := FALSE;
   disc_price_round_   ORDER_QUOTATION_TAB.disc_price_round%TYPE;
   use_price_incl_tax_ ORDER_QUOTATION_TAB.use_price_incl_tax%TYPE;
   
   CURSOR get_disc_price_rounded IS
      SELECT disc_price_round, use_price_incl_tax
      FROM   ORDER_QUOTATION_TAB
      WHERE  quotation_no = quotation_no_;
BEGIN
   OPEN get_disc_price_rounded;
   FETCH get_disc_price_rounded INTO disc_price_round_, use_price_incl_tax_;
   CLOSE get_disc_price_rounded;
   IF (disc_price_round_ = Fnd_Boolean_API.DB_TRUE) AND (use_price_incl_tax_ = Fnd_Boolean_API.DB_FALSE) THEN
      disc_price_rounded_ := TRUE;   
   END IF;
   RETURN  disc_price_rounded_;
END Get_Discounted_Price_Rounded;   
-- gelr:disc_price_rounded, end

-- Remove interim order structures, reservations and ctp records created from capability check.
PROCEDURE Remove_Intrm_Order_Resrv___ (
   quotation_no_     IN VARCHAR2 )
IS
   ctp_run_id_       NUMBER;
   interim_ord_id_   VARCHAR2(12);
   dummy_            VARCHAR2(2000);
   
   CURSOR get_quotation_lines IS
      SELECT line_no, rel_no, line_item_no, order_supply_type, ctp_planned, configuration_id
      FROM   ORDER_QUOTATION_LINE_TAB
      WHERE  rowstate    != 'Cancelled'
      AND    quotation_no = quotation_no_;

BEGIN
   $IF (Component_Ordstr_SYS.INSTALLED) $THEN
      FOR rec_ IN get_quotation_lines LOOP

            interim_ord_id_:= Order_Quotation_Line_API.Get_Interim_Order_No(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.ctp_planned);

            -- cancel capability check reservations/allocations
            IF (rec_.ctp_planned = 'Y' OR (rec_.ctp_planned = 'N' AND interim_ord_id_ IS NOT NULL)) THEN
               Interim_Ctp_Manager_API.Cancel_Ctp(dummy_, quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, 'CUSTOMERQUOTE', rec_.order_supply_type);  
               Order_Quotation_Line_API.Clear_Ctp_Planned(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
            END IF;

            -- Remove interim order and configuration specification
            IF (rec_.configuration_id != '*' AND rec_.ctp_planned = 'N') THEN
               Interim_Demand_Head_API.Remove_Interim_Head_By_Usage('CUSTOMERQUOTE', quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
            END IF;

            -- Remove ctp record
            ctp_run_id_ := Interim_Ctp_Critical_Path_API.Get_Ctp_Run_Id('CUSTOMERQUOTE', quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
            IF (ctp_run_id_ IS NOT NULL AND ctp_run_id_ > 0) THEN
               Interim_Ctp_Critical_Path_API.Clear_Ctp_Data(ctp_run_id_);
            END IF;
      END LOOP;
   $ELSE
      NULL;
   $END  
 
END Remove_Intrm_Order_Resrv___;
