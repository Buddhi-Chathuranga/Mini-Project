-----------------------------------------------------------------------------
--
--  Logical unit: ReturnMaterialCharge
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign   History
--  ------  ------ ---------------------------------------------------------
--  210525  ApWilk Bug 159381(SCZ-14933), Modified Check_Update___() to increase the variable length of new_tax_code_.
--  220711  NiDalk SCXTEND-4446, Modified Update___ and Modify_Rma_Defaults__ to handle UPDATE_TAX in attr. UPDATE_TAX is set to faulse when taxes are fetched from a bundle call and not necessary to add at line level.
--  200715  NiDalk SCXTEND-4441, Modified Update___ to avoid duplicate tax requests being sent to external tax systems when updationg charge lines.
--  191022  Hairlk SCXTEND-941, Modified Prepare_Insert___, added code to fetch CUSTOMER_TAX_USAGE_TYPE from the header and added it to the attr.
--  191008  Hairlk SCXTEND-941, Avalara integration, Modified Insert___, Added code to fetch customer_tax_usage_type from customer if its not available in the attr. 
--                 Modified Update___, added customer_tax_usage_type to the condition which check if the tax should be recalculated or not. Modified Get_Co_Charge_Info to include customer_tax_usage_type. 
--  190923  SBalLK  Bug 150098 (SCZ-6857), Added Get_Del_Country_Code___() method and modified Get_Del_Country_Code(), Check_Update___(), Check_Insert___() and Transfer_Tax_Lines___() method
--  190923          for get connected delivery country to fetch relevant tax information.
--  180209  KoDelk STRSC-15901, When creating tax lines for invoice use the current currency rate rather than using the source line currency rate.
--  171024  MalLlk STRSC-12754, Removed the methods Get_Line_Total_Base_Amount().
--  171016  DiKuLk Bug 138039, Modified message constant in Check_Update___() from RMA_CANCELLED to RMACANNOTALTERED in order to avoid overriding of language translations.
--  161214  MeAblk Bug 133021, Modified Unpack_Check_Insert___() to recalculate the base_charge_amount when it's not passed when creating the RMA charge line.
--  160712  SudJlk STRSC-1959, Modified Check_Insert___ to handle data validity of coordinator.
--  160628  MalLlk FINHR-1818, Added methods Get_Line_Total_Base_Amount and Get_Line_Address_Info.
--  160524  IsSalk FINHR-1774, Added Update_Line___() and removed Validate_Fee_Code___().
--  160211  IsSalk FINHR-685, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Charge.
--  160118  IsSalk FINHR-657, Used FndBoolean in taxable attribute in Sales Charge Type.
--  160111  IsSalk FINHR-581, Renamed column FEE_CODE to TAX_CODE in SALES_CHARGE_TYPE_TAB.
--  151103  SURBLK FINHR-317, Modified fee_code_changed_ in to tax_code_changed_.
--  150206  SlKapl PRSC-5901, Modified Update___ to avoid problem with tax calculation for percentage charges, added procedure Recalc_Percentage_Charge_Taxes
--  141028  SlKapl PRFI-3039, Corrections in Check_Update___, Update___, Tax_Check___, renamed Get_Total_Tax_Amount to Get_Total_Tax_Amount_Curr, changed 
--                 Get_Total_Tax_Amount_Base and Get_Total_Tax_Amount_Curr in order to retrieve tax amount directly from rma_charge_tax_lines_tab without calculation
--  140320  NiDalk Bug 112499, Added function Get_Total_Tax_Amount_Base to calculate the total tax amount per return material charge line in base currency.
--  131203  MaRalk PBSC-3788, Replaced Get_Ship_Addr_Flag with Get_Ship_Addr_Flag_Db.
--  131031  RoJalk Modified CHARGE_TYPE, CONTRACT and COMPANY mandatory in the base view and included not null checks.
--  130709  MaRalk TIBE-1016, Removed global LU constant inst_Jinsui_ and modified Insert___, Update___, Validate_Jinsui_Constraints___ accordingly.
--  130808  IsSalk Bug 107531, Added column STATISTICAL_CHARGE_DIFF and modified Unpack_Check_Insert__, Unpack_Check_Update__, Insert___ 
--  130808         and Update___methods to store the sending country freight charges which is using when collecting intrastat.
--  130508  IsSalk Bug 109597, Modified Unpack_Check_Update___() to restrict the changing of charge quantity of approved RMA charge lines to 0.
--  130508         Also modified Get_Allowed_Operations__() to restrict the approve for credit of charge lines with charge quantity 0.
--  130307  SudJlk Bug 108372, Modified Release__ and Deny__ to reflect length change in RETURN_MATERIAL_HISTORY_TAB.message_text.
--  130130  ChFolk Replaced usages of customer_no with return_from_customer_no in rma header when getting the delivery informations.
--  121121  GaNnlk Modified Valid_Customer_Order_Charge___ to validate order number.
--  121003  ChFolk Modified Unpack_Check_Insert___, Unpack_Check_Update___ and Validate_Fee_Code___ to get the delivery address country code for single occurence delivery address.
--  120806  ChFolk Modified Unpack_Check_Update___ to avoid modifying charge information in cancelled RMA.
--  120925  SURBLK Modified Get_Total_Charged_Amount, Get_Total_Charged_Amount and Get_Total_Charged_Amt_Incl_Tax
--  120925         added new methods Get_Charge_Percent_Basis added Get_Gross_Charge_Percent_Basis.
--  120924  JeeJlk Modified Modify___ to calculate prices baseed on use price incl tax. Modified Get_Total_Tax_Amount to return correct tax amount
--  120924         based on use price incl tax.
--  120912  SURBLK Added columns base_charge_amt_incl_tax and charge_amount_incl_tax.
--  120130  ChJalk Modified Finite_State_Events___ to add event 'InvoiceRemoved' to the state 'Credited'.
--  111215  MaMalk Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  110712  ChJalk Modified usage of view CUSTOMER_ORDER_CHARGE to CUSTOMER_ORDER_CHARGE_TAB in cursors.
--  110526  ShKolk Removed General_SYS from Get_Total_Base_Charged_Amount().
--  110525  MaMalk Modified Validate_Fee_Code___ to fetch the fee_code from the tax class for the supply country when no entry found for the delivery country.
--  110419  MaMalk Added attibute Delivery_Type.
--  110207  MaMalk Added methods Modify_Tax_Class_Id, Get_Delivery_Country_Code and Modified Validate_Fee_Code___ to consider the tax_class_id.
--  110131  Nekolk EANE-3744  added where clause to View RETURN_MATERIAL_CHARGE
--  110131  MaMalk Added Tax_Class_Id and Tax_Liability as public attributes.
--  100901  JuMalk Bug 92678, Added return material history record when a charge line is approved or removed for credit. 
--  100727  AmPalk Bug 92006, Removed Is_Co_Charge_Line_Invoiced from Unpack_Check_Insert___ and Unpack_Check_Update___. 
--  100901         Modified methods Approve_For_Credit() and Remove_Credit_Approval().
--  100715  KiSalk Message text of 'NONTAXABLE' changed to 'Tax code should be of ...' from 'Tax code be of ...'.
--  100604  ShVese Added methods Modify_Qty_Returned___ and Refresh_State___ and called it from Finite_State_Machine___.
--  100727  AmPalk Bug 92006, Removed Is_Co_Charge_Line_Invoiced from Unpack_Check_Insert___ and Unpack_Check_Update___. 
--  100215  AmPalk Bug 87931, Added currency_rate as a public attribute. Update of the column is with the changes to prices (charge amounts),
--  100215         charge quantity or connected order line on client windows. Removed Invoice_Library_API.Get_Currency_Rate_Defaults calls from data populates. Instead used saved value as the currency rate.
--  100517  KRPELK Merge Rose Method Documentation.
--  100401  KiSalk Corrected REF to SALES_CHARGE_TYPE of the base view and Sales_Charge_Type_API.Exist moved to Valid_Customer_Order_Charge___.
--  091230  MaRalk Modified the state machine according to the new developer studio template - 2.5.
--  090930  MaMalk Removed constant state_separator_. Removed unused code in Validate_Fee_Code___, Finite_State_Init___, Modify_Rma_Defaults__ and New.
--  ------------------------- 14.0.0 -----------------------------------------
--  090922  AmPalk Bug 70316, Modified Get_Total_Base_Charged_Amount to calculate the base amount using curr amount as in the invoice.
--  090731  ChJalk Bug 80025, Added method New.
--  090415  SaJjlk Bug 81673, Increased length of variable message_ to 2000 in method Modify_Cr_Invoice_Fields.
--  090319  SudJlk Bug 77435, Modified method Unpack_Check_Update___ to allow passing FALSE to Order_Coordinator_API.Exist.
--  090128  MaRalk Bug 76921, Modified the function Create_Credit___ to handle the use_debit_inv_rate_ parameter.
--  090128         Modified the methods Unpack_Check_Insert___ and Unpack_Check_Update___ to validate the order_no.
--  081215  ChJalk Bug 77014, Modified and added General_SYS.Init_Method to Get_Total_Base_Charged_Amount.
--  080723  RoJalk Bug 75666, Included the event InvoiceRemoved to suport the situation where credit invoice is removed.
--  080723         Modified Modify_Cr_Invoice_Fields to handle the state change.
--  080716  RoJalk Bug 75666, Modify_Cr_Invoice_Fields to handle the state change when credit invoice is removed.
--  090512  KiSalk Modified Validate_Charge_And_Cost___ to allow multiple quantity for connected Unit order charge lines .
--  090325  KiSalk Modified Get_Total_Base_Charged_Amount, Get_Total_Charged_Amount, Get_Co_Charge_Info and Get.
--  090325         Added Get_Charge_Percent_Basis, Get_Charge, Get_Charge_Cost_Percent and Get_Total_Base_Charged_Cost.
--  090319  KiSalk Added attributes charge and charge_cost_percent and made charge_cost, base_charge_amount and charge_amount nullable; added validations.
--  071224  MaRalk Bug 64486, Modified procedure Get_Co_charge_Info to consider currency rate type in CO when calculate price in currency.
--  071019  LaBolk Bug 67369, Modified method Update___ to call Rma_Charge_Tax_Lines_API.Recalculate_Tax_Lines when amount or qty has changed.
--  070816  MaJalk Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to validate ORDER_NO.
--  070716  ChBalk Bug 65135, Replaced UNISTR with new constant in Database_SYS.
--  070626  MaJalk Bug 65917, Modified the cursor get_attr in the method Get_Total_Charged_Amount.
--  060602  MaMalk Modified Modify_Cr_Invoice_Fields to include RMA history when the credit invoice is removed. Modified
--  060602         Unpack_Check_Update___ to change the condition used to raise the error message given by constant CHARGECREDITED.
--  060602         Modified the error messages given by constants CHARGECREDITED, CHGCHARGEDENIED, CHARGECREDDEL, REMDENRMA to correct some spelling mistakes.
--  060522  NuFilk Bug 57771, Added function Get_Total_Tax_Amount and modified Tax_Check___.
--  060516  SaRalk Removed unused variable address_id_ in procedure Validate_Fee_Code___.
--  060424  NuFilk Bug 54676,Added a derived attribute update_tax_from_ship_addr.
--  060424         Also added procedure Modify_Rma_Defaults__. Added a new parameter ship_addr_changed_
--  060424         to procedure Tax_Check___ . Modified Tax_Check___, Unpack_Check_Update___ and Update___.
--  060421  MaJalk Bug 56506, Added DEFAULT FALSE to correct the condition in Valid_Customer_Order_Charge___.
--  060421         Removed unnecessary Error_SYS.Check_Not_Null. Added condition newrec_.vat = 'Y' to call
--  060421         Rma_Charge_Tax_Lines_API.Add_Tax_Lines_From_Addr() at Tax_Check___().
--  060420  SaRalk Enlarge Customer - Changed variable definitions.
--  --------------------------------- 13.4.0 --------------------------------
--  060328  SuJalk Modified the total_tax_pct_ variable to be assgned zero if no tax lines are connected by using the nvl function in function Validate_Jinsui_Constraints___.
--  060310  MiKulk Bug 51197, Rewrote Validate_Fee_Code__ as Validate_Fee_Code___.
--  060310         Also modified Unpack_Check_Insert___ and Unpack_Check_Update___.
--  060124  JaJalk Added Assert safe annotation.
--  060119  SaJjlk Added the returning clause to method Insert___.
--  051227  MaRalk Bug 55121, Modified Delete___ to refresh the RMA status.
--  051031  MaEelk Corrected inGet_Virtual_Inv_Max_Amount as Get_Virtual_Inv_Max_Amount
--  051031         in Validate_Jinsui_Constraints___.
--  051013  IsAnlk Modified Get_Co_Charge_Info.
--  050919  MaEelk Removed unused variables from the code.
--  050909  SaMelk Replace 'Get_Max_Amt_Js_Trans_Batch' with 'Get_Virtual_Inv_Max_Amount'.
--  050803  SaMelk Modified the method Validate_Jinsui_Constraints___.
--  050711  SaMelk Added New method Validate_Jinsui_Constraints___. Modified Insert___ and Update___ methods.
--  050623  MaJalk Bug 52006, Modified Language_SYS.Translate_Constant lines to create the translations.
--  041025  NaWalk Added the function Get_Total_Charge_Tax_Pct.
--  040224  IsWilk Removed SUBSTRB from the views for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes----------------------
--  040209  GeKalk Convert  CHR() to UNISTR() for UNICODE modifications.
--  031013  PrJalk Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  030526  GaJalk Code review changes.
--  030513  ChFolk Modified an error message in Validate_Fee_Code__.
--  030506  ChFolk Call ID 96789. Modified the inconsistent error messages.
--  030505  GaJalk Modified the procedure Modify__.
--  030502  JaJaLk Modified the Validation of the FEE_CODE in Unpack_Check_Update___.
--  030429  GaJalk Modified the procedure Modify__.
--  030424  GaJalk Modified the procedures Validate_Fee_Code__, Tax_Check___, Modify__ and Get_Co_Charge_Info.
--  030403  GaJalk Modified procedure Tax_Check___.
--  030402  GaJalk Changed Modify_Fee_Code to Modify_Fee_Code__.
--  030401  GaJalk Modified Unpack_Check_Insert___, Unpack_Check_Update___ and Validate_Fee_Code__.
--  030331  GaJalk Modified the procedures Modify__ and Tax_Check___.
--  030327  GaJalk Modified the procedure Tax_Check___.
--  030326  GaJalk Modified procedures Validate_Fee_Code__,Modify_Fee_Code, Modify_Charge__,Valid_Customer_Order_Charge___,
--                 Unpack_Check_Update___, Unpack_Check_Insert___, Tax_Check___, Remove__ and Modify__.
--  030325  GaJalk Added procedures Validate_Fee_Code__,Modify_Fee_Code, Modify_Charge__.
--  000608  PaLj  Changed Get_Co_Charge_Info to fetch Sequence_no.
--  000605  PaLj  Removed mandatory restrictions on credited_qty. This field is not used.
--  000531  PaLj  Changed Insert, Update, Delete, Valid_Customer_Order_Charge to handle qty_returned
--  000419  PaLj  Corrected Init_Method Errors
--  000322  JakH  Rewrote logic for checking tax, adding sales tax lines also
--                from delivery address of RMA when charge is unconnected.
--  000229  JakH  The state of the Charge is set to credited when the
--                credit invoice keys are set.
--  000229  JakH  Constraints added for credited charge lines
--  000223  JakH  Added NOTE_ID to attr_ in insert___
--  000222  DaZa  Made note_id public.
--  000216  JakH  Added validation procedures for VAT and Sales Tax
--  000204  JakH  Added sales tax when specifying order charge connections.
--  991228  JakH  Added entries in RMA history.
--  991216  JakH  Added Modify_Cr_Invoice_Fields
--  991207  JakH  Added Aprove_For_Credit__
--  991126  JakH  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Charge_Amounts_Rec IS RECORD (
   charge_type_description     VARCHAR2(2000),
   charge_group_description    VARCHAR2(2000),
   charge_basis_curr           NUMBER,
   total_currency              NUMBER,
   total_base                  NUMBER,
   gross_total_currency        NUMBER,
   gross_total_base            NUMBER,
   tax_liability_type          VARCHAR2(100),   
   total_charge_cost           NUMBER,
   cred_invoice_no             VARCHAR2(50),
   condition                   VARCHAR2(2000),
   total_tax_percentage        NUMBER,
   tax_amount                  NUMBER,
   customer_no                 VARCHAR2(20),
   currency_code               VARCHAR2(3),
   multiple_tax_lines          VARCHAR2(5));
   
TYPE Charge_Amounts_Arr IS TABLE OF Charge_Amounts_Rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Tax_Calc_Struct_Ref___ (
   newrec_ IN OUT NOCOPY RETURN_MATERIAL_CHARGE_TAB%ROWTYPE )
IS
BEGIN
   Tax_Calc_Structure_API.Validate_Tax_Structure_State(newrec_.company, newrec_.tax_calc_structure_id);
END Check_Tax_Calc_Struct_Ref___;

-- Valid_Customer_Order_Charge___
--   This method checks if the customer order charge is valid for use on
--   the RMA charge.
PROCEDURE Valid_Customer_Order_Charge___ (
   newrec_      IN OUT RETURN_MATERIAL_CHARGE_TAB%ROWTYPE,
   oldrec_      IN     RETURN_MATERIAL_CHARGE_TAB%ROWTYPE,
   insert_flag_ IN     BOOLEAN,
   attr_        IN OUT VARCHAR2 )
IS
   ordcharge_rec_              Customer_Order_Charge_API.public_rec;
   rma_rec_                    Return_Material_API.public_rec;
   ord_rec_                    Customer_Order_API.public_rec;
   max_qty_to_return_          NUMBER;
   order_is_changed_           BOOLEAN;
   order_exists_               BOOLEAN;

BEGIN

   rma_rec_       := Return_Material_API.Get(newrec_.rma_no);

   order_exists_ := newrec_.order_no IS NOT NULL;

   Sales_Charge_Type_API.Exist(newrec_.contract, newrec_.charge_type);

   IF order_exists_ THEN
      ord_rec_ := Customer_Order_API.Get(newrec_.order_no);
      
      IF rma_rec_.use_price_incl_tax  != ord_rec_.use_price_incl_tax  THEN
         Error_SYS.Record_General(lu_name_, 'UNMATCHUSEPRICEINCL: The specified customer order does not match the price including tax information of the RMA.');
      END IF ; 
      
      order_is_changed_ := (str_diff___(oldrec_.order_no, newrec_.order_no) OR
                            nvl(oldrec_.sequence_no,0) != nvl(newrec_.sequence_no,0)) OR insert_flag_;
      -- get order charge record
      ordcharge_rec_ := Customer_Order_Charge_API.get (newrec_.order_no, newrec_.sequence_no);
      -- check if amount to return is larger than amount sold
      max_qty_to_return_ := ordcharge_rec_.charged_qty - ordcharge_rec_.qty_returned;
      IF (NOT insert_flag_) AND (NOT order_is_changed_) THEN
         max_qty_to_return_ := max_qty_to_return_ + oldrec_.charged_qty;
      END IF;
      IF newrec_.charged_qty > max_qty_to_return_ THEN
         Error_SYS.Record_General(lu_name_, 'TOMUCHTORET: The quantity to return exceeds the maximum quantity to return = :P1',
                                     max_qty_to_return_);
      END IF ;

      IF order_is_changed_ THEN
         -- check that the order charge matches the rma charge
         -- this is only needed  when order is changed
         IF NOT
           ((ordcharge_rec_.contract = newrec_.contract) AND
            (ord_rec_.customer_no = rma_rec_.customer_no) AND
            (substr(ord_rec_.currency_code,1,3) = rma_rec_.currency_code))
         THEN
            Error_SYS.Record_General('ReturnMaterialCharge', 'ORDCHARGENOTVALID: This customer order charge is not valid for use on this RMA charge.');
         END IF;
         
         -- we have an order connection
         newrec_.tax_liability := Customer_Order_Charge_API.Get_Connected_Tax_Liability(newrec_.order_no, newrec_.sequence_no);
         newrec_.fee_code := ordcharge_rec_.tax_code;
         newrec_.tax_class_id := ordcharge_rec_.tax_class_id;
         newrec_.delivery_type := ordcharge_rec_.delivery_type;
         Client_SYS.Add_To_Attr('TAX_LIABILITY', newrec_.tax_liability, attr_);
         Client_SYS.Add_To_Attr('FEE_CODE', newrec_.fee_code, attr_);
         Client_SYS.Add_To_Attr('TAX_CLASS_ID', newrec_.tax_class_id, attr_);
         Client_SYS.Add_To_Attr('DELIVERY_TYPE', newrec_.delivery_type, attr_);
      END IF;

      IF (return_material_api.Get_Order_No(newrec_.rma_no) != newrec_.order_no) THEN
         Error_SYS.Record_General(lu_name_, 'INVALID_CHARGE_LINE: Customer order number defined in the RMA header must be same as the one connected to the RMA charge line.');
   END IF;

   END IF;
END Valid_Customer_Order_Charge___;


-- Tax_Check___
--   This method checks for updates of tax lines
PROCEDURE Tax_Check___ (
   newrec_            IN OUT RETURN_MATERIAL_CHARGE_TAB%ROWTYPE,
   oldrec_            IN     RETURN_MATERIAL_CHARGE_TAB%ROWTYPE,
   insert_flag_       IN     BOOLEAN,
   ship_addr_changed_ IN     BOOLEAN,
   reset_tax_code_    IN     BOOLEAN )
IS
   order_exists_               BOOLEAN;
BEGIN
   order_exists_ := newrec_.order_no IS NOT NULL;

   IF (order_exists_) THEN
      Transfer_Tax_lines___(newrec_ , oldrec_, insert_flag_, reset_tax_code_);
   ELSIF (insert_flag_) THEN
      Add_Transaction_Tax_Info___ (newrec_,                                  
                                   tax_from_defaults_ => reset_tax_code_,                                      
                                   add_tax_lines_     => TRUE,
                                   attr_              => NULL);                                  
   ELSIF (ship_addr_changed_ OR reset_tax_code_) THEN
      IF (newrec_.order_no IS NULL AND newrec_.credit_invoice_no IS NULL ) THEN
         Add_Transaction_Tax_Info___ (newrec_,                                
                                      tax_from_defaults_ => TRUE,                                      
                                      add_tax_lines_     => TRUE,
                                      attr_              => NULL);   
      END IF;
   END IF;
END Tax_Check___;


-- Str_Diff___
--   Compares two strings and takes care of possible NULL conditions.
FUNCTION Str_Diff___ (
   str1_ IN VARCHAR2,
   str2_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN nvl(str1_, ' ') != nvl(str2_, ' ');
END Str_Diff___;


-- Add_Transaction_Tax_Info___
--    Fetch and calculate taxes and add tax lines to source_tax_item_tab.
PROCEDURE Add_Transaction_Tax_Info___ (
   newrec_              IN RETURN_MATERIAL_CHARGE_TAB%ROWTYPE, 
   tax_from_defaults_   IN BOOLEAN,
   add_tax_lines_       IN BOOLEAN,
   attr_                IN VARCHAR2)
IS
   line_amount_rec_       Tax_Handling_Util_API.line_amount_rec;
   source_key_rec_        Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_    Tax_Handling_Order_Util_API.tax_line_param_rec;   
   rma_rec_               Return_Material_API.Public_Rec;
   multiple_tax_          VARCHAR2(20);
   tax_info_table_        Tax_Handling_Util_API.tax_information_table;
BEGIN
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                                                      TO_CHAR(newrec_.rma_no), 
                                                                      TO_CHAR(newrec_.rma_charge_no), 
                                                                      '*', 
                                                                      '*',
                                                                      '*',
                                                                      attr_); 
                                      
   rma_rec_  := Return_Material_API.Get(newrec_.rma_no);
   
   tax_line_param_rec_.company               := newrec_.company;
   tax_line_param_rec_.contract              := newrec_.contract;
   tax_line_param_rec_.customer_no           := rma_rec_.customer_no;
   tax_line_param_rec_.ship_addr_no          := rma_rec_.ship_addr_no;
   tax_line_param_rec_.planned_ship_date     := TRUNC(Site_API.Get_Site_Date(rma_rec_.contract));
   tax_line_param_rec_.supply_country_db     := rma_rec_.supply_country;
   tax_line_param_rec_.delivery_type         := NVL(newrec_.delivery_type, '*');
   tax_line_param_rec_.object_id             := newrec_.charge_type;
   tax_line_param_rec_.use_price_incl_tax    := rma_rec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code         := rma_rec_.currency_code;
   tax_line_param_rec_.currency_rate         := newrec_.currency_rate;
   tax_line_param_rec_.tax_liability         := newrec_.tax_liability;
   tax_line_param_rec_.tax_code              := newrec_.fee_code;
   tax_line_param_rec_.tax_calc_structure_id := newrec_.tax_calc_structure_id;
   tax_line_param_rec_.tax_liability_type_db := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, Get_Delivery_Country_Code(newrec_.rma_no, newrec_.rma_charge_no));   
   tax_line_param_rec_.from_defaults         := tax_from_defaults_;
   tax_line_param_rec_.add_tax_lines         := add_tax_lines_;

   Tax_Handling_Order_Util_API.Add_Transaction_Tax_Info (line_amount_rec_,
                                                         multiple_tax_,
                                                         tax_info_table_,
                                                         tax_line_param_rec_,
                                                         source_key_rec_,
                                                         attr_);
END Add_Transaction_Tax_Info___;


PROCEDURE Transfer_Tax_Lines___(
   newrec_         IN RETURN_MATERIAL_CHARGE_TAB%ROWTYPE,
   oldrec_         IN RETURN_MATERIAL_CHARGE_TAB%ROWTYPE,
   insert_flag_    IN BOOLEAN,
   reset_tax_code_ IN BOOLEAN)
IS
   order_is_changed_           BOOLEAN;
   order_exists_               BOOLEAN;
   rma_rec_                    Return_Material_API.Public_Rec;
   old_tax_liability_type_db_  VARCHAR2(20);
   new_tax_liability_type_db_  VARCHAR2(20);
   delivery_country_code_      RETURN_MATERIAL_LINE.delivery_country_code%TYPE;
   saved_tax_code_msg_         VARCHAR2(32000);
   saved_tax_code_             VARCHAR2(20);
   saved_tax_calc_struct_id_   VARCHAR2(20);
   saved_tax_percentage_       NUMBER;
   saved_tax_base_curr_amount_ NUMBER;
BEGIN
   order_exists_   := newrec_.order_no IS NOT NULL;
   
   order_is_changed_ := (Str_Diff___(oldrec_.order_no, newrec_.order_no) OR
                         Str_Diff___(oldrec_.sequence_no, newrec_.sequence_no));

   IF (order_is_changed_ OR (insert_flag_ AND reset_tax_code_)) THEN
      IF (order_exists_) THEN
         Tax_Handling_Order_Util_API.Transfer_Tax_lines(newrec_.company,
                                                        Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                        newrec_.order_no,
                                                        newrec_.sequence_no,
                                                        '*',
                                                        '*',
                                                        '*',
                                                        Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                                        newrec_.rma_no,
                                                        newrec_.rma_charge_no,
                                                        '*',
                                                        '*',
                                                        '*',
                                                        'TRUE',
                                                        'FALSE');
                                                         
         Source_Tax_Item_API.Get_Tax_Codes(saved_tax_code_msg_, 
                                     saved_tax_code_, 
                                     saved_tax_calc_struct_id_, 
                                     saved_tax_percentage_, 
                                     saved_tax_base_curr_amount_, 
                                     newrec_.company, 
                                     Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                     newrec_.rma_no,
                                     newrec_.rma_charge_no,
                                     '*',
                                     '*',
                                     '*',
									 'FALSE');
                                     
         IF (saved_tax_code_msg_ IS NULL) AND (saved_tax_code_ IS NULL) AND (saved_tax_calc_struct_id_ IS NULL) THEN
            Tax_Handling_Util_API.Validate_Tax_Code_Mandatory(newrec_.company, 'CUSTOMER_TAX');   
         END IF;                                                
                                                         
      END IF;
   ELSIF (newrec_.tax_liability != oldrec_.tax_liability) THEN
      rma_rec_ := Return_Material_API.Get(newrec_.rma_no);
      delivery_country_code_     := Get_Del_Country_Code___(newrec_);
      old_tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(oldrec_.tax_liability, delivery_country_code_);
      new_tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, delivery_country_code_);
      
      IF (old_tax_liability_type_db_ != new_tax_liability_type_db_) THEN
         Add_Transaction_Tax_Info___(newrec_,                                   
                                     tax_from_defaults_ => TRUE,
                                     add_tax_lines_     => TRUE,
                                     attr_              => NULL);         
      END IF;
   END IF;
     
END Transfer_Tax_Lines___;


PROCEDURE Recalculate_Tax_Lines___ (
   newrec_        IN OUT RETURN_MATERIAL_CHARGE_TAB%ROWTYPE,
   from_defaults_ IN BOOLEAN,
   attr_          IN     VARCHAR2)
IS
   source_key_rec_         Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_     Tax_Handling_Order_Util_API.tax_line_param_rec;
   rma_rec_                Return_Material_API.Public_Rec;
BEGIN
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                                                      newrec_.rma_no, 
                                                                      TO_CHAR(newrec_.rma_charge_no), 
                                                                      '*', 
                                                                      '*',
                                                                      '*',
                                                                      attr_); 
                                      
   rma_rec_  := Return_Material_API.Get(newrec_.rma_no);
   
   tax_line_param_rec_.company               := newrec_.company;
   tax_line_param_rec_.contract              := newrec_.contract;
   tax_line_param_rec_.customer_no           := rma_rec_.customer_no;
   tax_line_param_rec_.ship_addr_no          := rma_rec_.ship_addr_no;
   tax_line_param_rec_.planned_ship_date     := TRUNC(Site_API.Get_Site_Date(rma_rec_.contract));
   tax_line_param_rec_.supply_country_db     := rma_rec_.supply_country;
   tax_line_param_rec_.delivery_type         := NVL(newrec_.delivery_type, '*');
   tax_line_param_rec_.object_id             := newrec_.charge_type;
   tax_line_param_rec_.use_price_incl_tax    := rma_rec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code         := rma_rec_.currency_code;
   tax_line_param_rec_.currency_rate         := newrec_.currency_rate;
   tax_line_param_rec_.tax_liability         := newrec_.tax_liability;
   tax_line_param_rec_.tax_code              := newrec_.fee_code;
   tax_line_param_rec_.tax_calc_structure_id := newrec_.tax_calc_structure_id;
   tax_line_param_rec_.tax_liability_type_db := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, Get_Delivery_Country_Code(newrec_.rma_no, newrec_.rma_charge_no));   
   tax_line_param_rec_.from_defaults         := from_defaults_;
   tax_line_param_rec_.add_tax_lines         := FALSE;

   Tax_Handling_Order_Util_API.Recalculate_Tax_Lines (source_key_rec_,
                                                      tax_line_param_rec_,
                                                      attr_);
END Recalculate_Tax_Lines___;


-- Validate_Charge_And_Cost___
--   Validates the use of charge and cost in amount and percentage forms.
PROCEDURE Validate_Charge_And_Cost___ (
   newrec_ IN RETURN_MATERIAL_CHARGE_TAB%ROWTYPE )
IS
   is_unit_charge_ BOOLEAN := FALSE;
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
   IF (newrec_.charged_qty != 1) THEN
      IF (NVL(newrec_.charge, 0) != 0 OR NVL(newrec_.charge_cost_percent, 0) != 0) THEN
         IF (newrec_.sequence_no IS NOT NULL) THEN
            is_unit_charge_ := (Fnd_Boolean_API.Encode(Customer_Order_Charge_API.Get_Unit_Charge(newrec_.order_no, newrec_.sequence_no)) = 'TRUE');
         END IF;
         IF NOT is_unit_charge_ THEN
            Error_SYS.Record_General(lu_name_, 'MULTIPERCENTERR: Charged quantity should be 1 when charge cost or charge price is entered as a percentage.');
         END IF;
      END IF;
   END IF;

END Validate_Charge_And_Cost___;


FUNCTION Approved___ (
   rec_  IN     RETURN_MATERIAL_CHARGE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN (rec_.credit_approver_id IS NOT NULL);
END Approved___;


PROCEDURE Create_Credit___ (
   rec_  IN OUT RETURN_MATERIAL_CHARGE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   use_debit_inv_rate_ NUMBER;
BEGIN
   use_debit_inv_rate_ := NVL(Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('USE_INV_DEBIT_RATE', attr_)), 0);
   Invoice_Customer_Order_API.Create_Invoice_From_Return__(rec_.rma_no, NULL, rec_.rma_charge_no, use_debit_inv_rate_ );
   Return_Material_API.Refresh_State(rec_.rma_no);
END Create_Credit___;


PROCEDURE Modify_Qty_Returned___ (
   rec_  IN OUT RETURN_MATERIAL_CHARGE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   old_qty_returned_ NUMBER;
BEGIN
   IF rec_.order_no IS NOT NULL THEN
      old_qty_returned_ := Customer_Order_Charge_API.Get_Qty_Returned(rec_.order_no, rec_.sequence_no);
      Customer_Order_Charge_API.Modify_Qty_Returned(rec_.order_no, rec_.sequence_no, old_qty_returned_ - rec_.charged_qty);
   END IF;
END Modify_Qty_Returned___;


PROCEDURE Refresh_State___ (
   rec_  IN OUT RETURN_MATERIAL_CHARGE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Return_Material_API.Refresh_State(rec_.rma_no);
END Refresh_State___;


PROCEDURE Validate_Jinsui_Constraints___(
   newrec_ IN RETURN_MATERIAL_CHARGE_TAB%ROWTYPE)
IS
   company_maximum_amt_    NUMBER;
   company_                VARCHAR2(20);
   net_amount_             NUMBER;
   total_tax_pct_          NUMBER;
   gross_line_total_       NUMBER;
   cust_ord_rec_           Customer_Order_API.Public_Rec;
   return_material_rec_    Return_Material_API.Public_Rec;
BEGIN
   company_ := Site_API.Get_Company(newrec_.contract);

   $IF Component_Jinsui_SYS.INSTALLED $THEN
      company_maximum_amt_ := Js_Company_Info_API.Get_Virtual_Inv_Max_Amount(company_);
   $END

   net_amount_       := Get_Total_Charged_Amount(newrec_.rma_no, newrec_.rma_charge_no);
   total_tax_pct_    := NVL(Get_Total_Charge_Tax_Pct(newrec_.rma_no, newrec_.rma_charge_no),0);
   gross_line_total_ := net_amount_ * (1+total_tax_pct_/100);

   IF gross_line_total_>company_maximum_amt_ THEN
      Error_SYS.Record_General(lu_name_, 'AMTEXCEEDED: Charge Total Amount cannot be greater than the Maximum Amount for Jinsui Transfer Batch :P1 for the Company :P2.',company_maximum_amt_,company_);
   END IF;

   IF newrec_.order_no IS NOT NULL THEN
   --check if the connected order is jinsui or not
      cust_ord_rec_         := Customer_Order_API.Get(newrec_.order_no);
      return_material_rec_  := Return_Material_API.Get(newrec_.rma_no);

      IF (return_material_rec_.jinsui_invoice ='TRUE') THEN
         IF (cust_ord_rec_.jinsui_invoice='FALSE') THEN
            Error_SYS.Record_General(lu_name_, 'JINSUINOTCONNECT: Connected order or invoice should be enabled for jinsui.');
         END IF;
      ELSE
         IF (cust_ord_rec_.jinsui_invoice='TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'JINSUICONNECT: Connected order or invoice should not be enabled for jinsui.');
         END IF;
      END IF;
   END IF;

END Validate_Jinsui_Constraints___;


-- Calculate_Prices___
--   Calculates Base/Sale price or price incl tax depending on use_price_incl_tax_ value.
PROCEDURE Calculate_Prices___ (
   newrec_  IN OUT RETURN_MATERIAL_CHARGE_TAB%ROWTYPE )
IS
   rma_rec_               Return_Material_API.Public_Rec;
   tax_liability_type_db_ VARCHAR2(20);
   multiple_tax_          VARCHAR2(20);
BEGIN
   rma_rec_        := Return_Material_API.Get(newrec_.rma_no);
   
   tax_liability_type_db_  := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, 
                                                   Get_Delivery_Country_Code(newrec_.rma_no, newrec_.rma_charge_no));
   Tax_Handling_Order_Util_API.Get_Prices(newrec_.base_charge_amount,
                                          newrec_.base_charge_amt_incl_tax,
                                          newrec_.charge_amount,
                                          newrec_.charge_amount_incl_tax,
                                          multiple_tax_,
										            newrec_.fee_code,
                                          newrec_.tax_calc_structure_id,
                                          newrec_.tax_class_id,
                                          newrec_.rma_no, 
                                          newrec_.rma_charge_no, 
                                          '*',
                                          '*',
                                          '*',
                                          Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                          newrec_.contract,
                                          rma_rec_.customer_no,
                                          rma_rec_.ship_addr_no,
                                          TRUNC(Site_API.Get_Site_Date(rma_rec_.contract)),
                                          rma_rec_.supply_country,
                                          NVL(newrec_.delivery_type, '*'),
                                          newrec_.charge_type,
                                          rma_rec_.use_price_incl_tax,
                                          rma_rec_.currency_code,
                                          newrec_.currency_rate,
                                          'FALSE',                                          
                                          newrec_.tax_liability,
                                          tax_liability_type_db_,
                                          delivery_country_db_ => NULL,
                                          ifs_curr_rounding_ => 16,
                                          tax_from_diff_source_ => 'FALSE',
                                          attr_ => NULL);
END Calculate_Prices___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_ VARCHAR2(5);
   rma_no_   NUMBER;
BEGIN
   trace_sys.field('preparing insert on', attr_);
   contract_ := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   rma_no_ := Client_SYS.Get_Item_Value('RMA_NO', attr_);
   super(attr_);
   Client_SYS.Add_To_Attr('CHARGED_QTY', 1, attr_);
   Client_SYS.Add_To_Attr('CREDITED_QTY', 0, attr_);
   Client_SYS.Add_To_Attr('DATE_ENTERED',
                          Site_API.Get_Site_Date(contract_), attr_);
   Client_SYS.Add_To_Attr('STATISTICAL_CHARGE_DIFF', 0, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', Return_Material_API.Get_Customer_Tax_Usage_Type(rma_no_), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT RETURN_MATERIAL_CHARGE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   total_returned_      NUMBER;
   rma_rec_             Return_Material_API.Public_Rec;
   reset_tax_code_      BOOLEAN;
   tax_class_id_        VARCHAR2(20);
   original_rma_no_     VARCHAR2(50);
   original_charge_no_  VARCHAR2(50);
   tax_method_          VARCHAR2(50);
   tax_from_external_system_  BOOLEAN := FALSE;
BEGIN
   rma_rec_ := Return_Material_API.Get(newrec_.rma_no);
   newrec_.note_id := Document_Text_API.get_next_note_id;
   Client_SYS.Add_To_Attr('NOTE_ID',newrec_.note_id, attr_);
   
   IF (newrec_.customer_tax_usage_type IS NULL) THEN
      newrec_.customer_tax_usage_type := Return_Material_API.Get_Customer_Tax_Usage_Type(newrec_.rma_no);
      Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE',newrec_.customer_tax_usage_type, attr_);
   END IF;
   
   original_rma_no_     := Client_SYS.Get_Item_Value('ORIGINAL_RMA_NO', attr_);
   original_charge_no_  := Client_SYS.Get_Item_Value('ORIGINAL_CHARGE_NO', attr_);
   IF (Client_SYS.Get_Item_Value('SET_TAX_FROM_ORIGINAL', attr_) = 'TRUE') AND 
      (Return_Material_API.Get_Customer_No(original_rma_no_) = Return_Material_API.Get_Customer_No(newrec_.rma_no)) THEN
      newrec_.tax_class_id := Get_Tax_Class_Id(original_rma_no_, 
                                               original_charge_no_); 
   END IF;
   super(objid_, objversion_, newrec_, attr_);
   
   $IF Component_Jinsui_SYS.INSTALLED $THEN
      IF rma_rec_.jinsui_invoice ='TRUE' THEN
         Validate_Jinsui_Constraints___(newrec_);
      END IF;
   $END
   
   tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);
   IF (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
      reset_tax_code_ := TRUE;
      tax_from_external_system_ := TRUE;
   ELSE
      IF (NVL(Client_SYS.Get_Item_Value('FETCH_TAX_CODES', attr_), 'TRUE') = 'TRUE') THEN
         IF (newrec_.tax_calc_structure_id IS NOT NULL) THEN
            reset_tax_code_ := FALSE;       
         ELSIF((newrec_.order_no IS NOT NULL) OR (newrec_.fee_code IS NULL)) THEN
            reset_tax_code_ := TRUE;                 
         ELSE
            reset_tax_code_ := FALSE;
         END IF;
      END IF; 
   END IF;
   -- If the line is copied or duplicated, taxes should be copied from the original line.
   IF (Client_SYS.Get_Item_Value('SET_TAX_FROM_ORIGINAL', attr_) = 'TRUE') AND 
      (Return_Material_API.Get_Customer_No(original_rma_no_) = Return_Material_API.Get_Customer_No(newrec_.rma_no)) AND
      (NOT tax_from_external_system_) THEN
      Tax_Handling_Order_Util_API.Transfer_Tax_lines(newrec_.company, 
                                                     Tax_Source_API.DB_RETURN_MATERIAL_CHARGE, 
                                                     original_rma_no_, 
                                                     original_charge_no_, 
                                                     '*', 
                                                     '*', 
                                                     '*',
                                                     Tax_Source_API.DB_RETURN_MATERIAL_CHARGE, 
                                                     newrec_.rma_no, 
                                                     newrec_.rma_charge_no, 
                                                     '*', 
                                                     '*', 
                                                     '*',
                                                     'TRUE',
                                                     'FALSE');
   ELSE
      Tax_Check___ ( newrec_, NULL, TRUE, FALSE, reset_tax_code_);
   END IF;
   
   IF(newrec_.order_no IS NOT NULL) THEN
      tax_class_id_ := Customer_Order_Charge_API.Get_Tax_Class_Id(newrec_.order_no, newrec_.sequence_no); 
      IF (tax_class_id_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('TAX_CLASS_ID', tax_class_id_, attr_);
         Modify_Tax_Class_Id(attr_, newrec_.rma_no, newrec_.rma_charge_no);
      END IF;
   END IF;

   IF (newrec_.order_no IS NOT NULL) THEN
     total_returned_ := Customer_Order_Charge_API.Get_Qty_Returned(newrec_.order_no, newrec_.sequence_no);
     total_returned_ := total_returned_ + newrec_.charged_qty;
     Customer_Order_Charge_API.Modify_Qty_Returned(newrec_.order_no, newrec_.sequence_no, total_returned_);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     RETURN_MATERIAL_CHARGE_TAB%ROWTYPE,
   newrec_     IN OUT RETURN_MATERIAL_CHARGE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   total_returned_            NUMBER;
   rma_rec_                   Return_Material_API.Public_Rec;
   update_tax_from_ship_addr_ VARCHAR2(5);
   ship_addr_changed_         BOOLEAN := FALSE;
   refresh_tax_code_          BOOLEAN := FALSE;
   tax_from_defaults_         BOOLEAN;
   tax_code_changed_          VARCHAR2(5) := 'FALSE';
   tax_liability_type_db_     VARCHAR2(20);
   rowid_                     VARCHAR2(2000);
   multiple_tax_lines_        VARCHAR2(20);
   tax_item_removed_          VARCHAR2(5) := 'FALSE';
   tax_method_                VARCHAR2(50);
   update_tax_                VARCHAR2(5) := 'TRUE';
BEGIN
   rma_rec_    := Return_Material_API.Get(newrec_.rma_no);
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   $IF Component_Jinsui_SYS.INSTALLED $THEN
      IF rma_rec_.jinsui_invoice ='TRUE' THEN
         Validate_Jinsui_Constraints___(newrec_);
      END IF;
   $END
   
   IF by_keys_ THEN
      Get_Id_Version_By_Keys___(rowid_, objversion_, newrec_.rma_no, newrec_.rma_charge_no);
   ELSE
      rowid_ := objid_;
   END IF; 
   
   update_tax_ := NVL(Client_SYS.Get_Item_Value('UPDATE_TAX', attr_), 'TRUE');
   update_tax_from_ship_addr_  := Client_SYS.Get_Item_Value('UPDATE_TAX_FROM_SHIP_ADDR', attr_);
   IF (update_tax_from_ship_addr_ IS NOT NULL) THEN
      ship_addr_changed_ := TRUE;
   END IF;
   
   refresh_tax_code_      := (NVL(Client_SYS.Get_Item_Value('REFRESH_FEE_CODE', attr_), '0') = '1');
   tax_liability_type_db_ := Get_Tax_Liability_Type_Db(newrec_.rma_no, newrec_.rma_charge_no);
     
   IF(newrec_.charge_type != oldrec_.charge_type) THEN
      refresh_tax_code_ := TRUE;
   END IF;
   
   IF (refresh_tax_code_) THEN
      multiple_tax_lines_  := Client_SYS.Get_Item_Value('MULTIPLE_TAX_LINES', attr_);      
      IF ((newrec_.fee_code IS NULL) AND (newrec_.tax_calc_structure_id IS NULL) 
         AND (multiple_tax_lines_ IS NOT NULL) AND (multiple_tax_lines_ = 'FALSE')) THEN

         tax_item_removed_ := 'TRUE';

         Source_Tax_Item_Order_API.Remove_Tax_Items(newrec_.company, 
                                                   Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                                   TO_CHAR(newrec_.rma_no), 
                                                   TO_CHAR(newrec_.rma_charge_no), 
                                                   '*', 
                                                   '*',
                                                   '*');
         Tax_Handling_Util_API.Validate_Tax_Code_Mandatory(newrec_.company, 'CUSTOMER_TAX');      
      END IF;
      
      IF ((tax_item_removed_ != 'TRUE') AND (update_tax_ = 'TRUE') AND ((newrec_.order_no IS NULL) OR Str_Diff___(oldrec_.tax_liability, newrec_.tax_liability) 
         OR Str_Diff___(newrec_.fee_code, oldrec_.fee_code) OR Str_Diff___(newrec_.tax_calc_structure_id, oldrec_.tax_calc_structure_id))) THEN
         IF (Str_Diff___(oldrec_.order_no, newrec_.order_no) OR Str_Diff___(oldrec_.tax_liability, newrec_.tax_liability) OR (newrec_.charge_type != oldrec_.charge_type)) THEN
            tax_from_defaults_ := TRUE;
         ELSE
            tax_from_defaults_ := FALSE;
         END IF;
         Add_Transaction_Tax_Info___ (newrec_,                                  
                                      tax_from_defaults_ => tax_from_defaults_,                                      
                                      add_tax_lines_     => TRUE,
                                      attr_              => NULL);
      END IF;
      IF (Source_Tax_Item_API.Multiple_Tax_Items_Exist(newrec_.company, Tax_Source_API.DB_RETURN_MATERIAL_CHARGE, TO_CHAR(newrec_.rma_no), TO_CHAR(newrec_.rma_charge_no), '*', '*', '*') = 'TRUE') THEN
         newrec_.fee_code := NULL;
      END IF;
   END IF;

   tax_code_changed_ := Client_Sys.Get_Item_Value('TAX_CODE_CHANGED', attr_);
   IF ((tax_code_changed_ = 'TRUE') AND (newrec_.charge IS NULL)) THEN
      Calculate_Prices___(newrec_);
      Update_Line___(rowid_, newrec_);
   END IF;
   
   IF (tax_item_removed_ != 'TRUE' AND update_tax_ = 'TRUE') THEN
      Tax_Check___( newrec_, oldrec_, FALSE, ship_addr_changed_, FALSE);
   END IF;
   
   IF (newrec_.order_no IS NOT NULL) THEN
      total_returned_ := Customer_Order_Charge_API.Get_Qty_Returned(newrec_.order_no, newrec_.sequence_no);
      IF oldrec_.order_no IS NULL THEN
         total_returned_ := total_returned_ + newrec_.charged_qty;
      ELSE
         total_returned_ := total_returned_ + (newrec_.charged_qty - oldrec_.charged_qty);
      END IF;
      Customer_Order_Charge_API.Modify_Qty_Returned(newrec_.order_no, newrec_.sequence_no, total_returned_);
   ELSIF (newrec_.order_no IS NULL) THEN
      IF oldrec_.order_no IS NOT NULL THEN
         total_returned_ := Customer_Order_Charge_API.Get_Qty_Returned(oldrec_.order_no, oldrec_.sequence_no);
         total_returned_ := total_returned_ - oldrec_.charged_qty;
         Customer_Order_Charge_API.Modify_Qty_Returned(oldrec_.order_no, oldrec_.sequence_no, total_returned_);
      END IF;
   END IF;

   IF ((((newrec_.base_charge_amount != oldrec_.base_charge_amount) OR (newrec_.charge_amount != oldrec_.charge_amount)) AND rma_rec_.use_price_incl_tax = 'FALSE') OR
       (((newrec_.base_charge_amt_incl_tax != oldrec_.base_charge_amt_incl_tax) OR (newrec_.charge_amount_incl_tax != oldrec_.charge_amount_incl_tax))  AND rma_rec_.use_price_incl_tax = 'TRUE') OR
       (newrec_.charge_percent_basis != oldrec_.charge_percent_basis) OR (newrec_.base_charge_percent_basis != oldrec_.base_charge_percent_basis) OR
       (NVL(oldrec_.customer_tax_usage_type,' ') != NVL(newrec_.customer_tax_usage_type,' ')) OR 
       (newrec_.charge_type != oldrec_.charge_type) OR (newrec_.charged_qty != oldrec_.charged_qty) OR
       (NVL(newrec_.charge, -9999999999999) != NVL(oldrec_.charge, -9999999999999))) THEN 
       
      tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);
      IF (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
         tax_from_defaults_ := TRUE;
         IF update_tax_ = 'TRUE' THEN 
            Add_Transaction_Tax_Info___ (newrec_,                                  
                                         tax_from_defaults_ => tax_from_defaults_,                                      
                                         add_tax_lines_     => TRUE,
                                         attr_              => NULL);
         END IF;
      ELSE
         tax_from_defaults_ := FALSE;
         Recalculate_Tax_Lines___(newrec_, tax_from_defaults_, attr_);
      END IF;      
   END IF;

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN RETURN_MATERIAL_CHARGE_TAB%ROWTYPE )
IS
   header_state_  VARCHAR2(20);

BEGIN
   IF remrec_.credit_invoice_no IS NOT NULL THEN
      Error_SYS.Record_General(lu_name_, 'CHARGECREDDEL: Credited RMA charge cannot be deleted.');
   END IF;
   IF  remrec_.rowstate = 'Denied' THEN
      Error_SYS.Record_General(lu_name_, 'REMDENRMA: Denied RMA charge cannot be deleted.');
   END IF;
   header_state_ := Return_Material_API.Get_Objstate(remrec_.rma_no);
   IF  header_state_ = 'Cancelled' THEN
      Error_SYS.Record_General(lu_name_, 'RMA_CANCELLED: Charges cannot be deleted from a canceled RMA.');
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN RETURN_MATERIAL_CHARGE_TAB%ROWTYPE )
IS
   old_qty_returned_ NUMBER;
BEGIN
   super(objid_, remrec_);
   IF remrec_.order_no IS NOT NULL THEN
      old_qty_returned_ := Customer_Order_Charge_API.Get_Qty_Returned(remrec_.order_no, remrec_.sequence_no);
      Customer_Order_Charge_API.Modify_Qty_Returned(remrec_.order_no, remrec_.sequence_no, old_qty_returned_ - remrec_.charged_qty);
   END IF;
   Return_Material_API.Refresh_State(remrec_.rma_no);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT return_material_charge_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   rmarec_                Return_Material_API.Public_Rec;
   identity_              VARCHAR2(20);
   delivery_country_code_ VARCHAR2(2);
   base_currency_rate_ NUMBER;
   
   CURSOR get_next_charge_no(rma_no_ NUMBER) IS
      SELECT max(rma_charge_no) + 1
      FROM   RETURN_MATERIAL_CHARGE_TAB
      WHERE  rma_no = rma_no_;
BEGIN  
   IF NOT(indrec_.tax_liability) THEN
      newrec_.tax_liability := 'EXEMPT';
   END IF;
   
   rmarec_  := Return_Material_API.Get(newrec_.rma_no);

   IF (Client_SYS.Item_Exist('UPDATE_TAX_FROM_SHIP_ADDR', attr_)) THEN
      Error_SYS.Item_Insert(lu_name_, 'UPDATE_TAX_FROM_SHIP_ADDR');
   END IF;   
   
   IF newrec_.currency_rate IS NULL THEN
      identity_    := rmarec_.customer_no_credit;
      IF identity_ IS NULL THEN
         identity_ := rmarec_.customer_no;
      END IF;
      Customer_Order_Pricing_API.Get_Sales_Price_In_Currency (newrec_.charge_amount, newrec_.currency_rate, identity_, rmarec_.contract,
                                                              rmarec_.currency_code,  newrec_.base_charge_amount, Customer_order_API.Get_Currency_Rate_Type(newrec_.order_no));
   END IF;

   IF (newrec_.base_charge_amount IS NULL) THEN
      Customer_Order_Pricing_API.Get_Base_Price_In_Currency(newrec_.base_charge_amount, base_currency_rate_, identity_,
                                                            newrec_.contract, rmarec_.currency_code, newrec_.charge_amount, Customer_order_API.Get_Currency_Rate_Type(newrec_.order_no));  
   END IF;
   
   IF newrec_.statistical_charge_diff IS NULL THEN
      newrec_.statistical_charge_diff := 0;
   END IF;
   
   IF newrec_.rma_charge_no IS NULL THEN
      OPEN get_next_charge_no(newrec_.rma_no);
      FETCH get_next_charge_no INTO newrec_.rma_charge_no ;
      IF newrec_.rma_charge_no IS NULL THEN
         newrec_.rma_charge_no := 1;
      END IF;
      CLOSE get_next_charge_no;
      Client_SYS.Add_To_Attr('RMA_CHARGE_NO', newrec_.rma_charge_no, attr_);
   END IF;
   trace_sys.field('Return Charge line:',  newrec_.rma_charge_no);
     
   IF (indrec_.credit_approver_id AND (newrec_.credit_approver_id IS NOT NULL)) THEN
      Order_Coordinator_API.Exist(newrec_.credit_approver_id, true);
   END IF;   
   
   super(newrec_, indrec_, attr_);
   
   IF NOT (newrec_.tax_liability = 'TAX' OR newrec_.tax_liability = 'EXEMPT') THEN
      delivery_country_code_ := Get_Del_Country_Code___(newrec_);      
      Tax_Handling_Order_Util_API.Validate_Tax_Liability(newrec_.tax_liability, delivery_country_code_);
   END IF;

   Valid_Customer_Order_Charge___ ( newrec_, newrec_, TRUE , attr_);
   Validate_Charge_And_Cost___(newrec_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     return_material_charge_tab%ROWTYPE,
   newrec_ IN OUT return_material_charge_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   refresh_tax_code_          BOOLEAN := FALSE;
   tax_code_changed_          BOOLEAN := FALSE;
   rma_rec_                   Return_Material_API.Public_Rec;
   new_tax_code_              VARCHAR2(20);
   update_tax_from_ship_addr_ VARCHAR2(5);
   delivery_country_code_     VARCHAR2(2);
   delivery_type_changed_     BOOLEAN := FALSE;
   only_stat_diff_changed_    VARCHAR2(5);
   rma_state_                 VARCHAR2(20);
   tax_liability_type_        VARCHAR2(20);

BEGIN   
   -- It should be allowed to update statistical charge diff though the CO lines invoiced or cancelled.
   only_stat_diff_changed_ := Client_SYS.Get_Item_Value('ONLY_STAT_DIFF_CHANGED', attr_);

   rma_rec_ := Return_Material_API.Get(newrec_.rma_no);
   rma_state_ := Return_Material_API.Get_Objstate(newrec_.rma_no);
   tax_liability_type_ := Get_Tax_Liability_Type_Db(newrec_.rma_no, newrec_.rma_charge_no);
   
   IF (indrec_.fee_code OR indrec_.order_no OR indrec_.sequence_no OR indrec_.charge_type 
                        OR indrec_.tax_liability OR indrec_.delivery_type OR indrec_.tax_calc_structure_id)THEN
      refresh_tax_code_ := TRUE;
   END IF;
    
   IF (indrec_.fee_code) THEN
      tax_code_changed_ := TRUE;
      new_tax_code_ := newrec_.fee_code; 
   END IF;  

   IF (indrec_.delivery_type) THEN   
      delivery_type_changed_ := TRUE; 
   END IF;
   
   IF (indrec_.credit_approver_id AND (newrec_.credit_approver_id IS NOT NULL)) THEN
      Order_Coordinator_API.Exist(newrec_.credit_approver_id, FALSE);
   END IF;  
   
   IF (rma_state_ = 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_, 'RMACANNOTALTERED: A charge cannot be altered when the RMA is in the Canceled state.');
   END IF;

   IF (newrec_.order_no IS NULL) THEN
      newrec_.sequence_no := NULL;
   END IF;
   
   IF (Client_SYS.Item_Exist('UPDATE_TAX_FROM_SHIP_ADDR', attr_)) THEN
      update_tax_from_ship_addr_ := Client_SYS.Get_Item_Value('UPDATE_TAX_FROM_SHIP_ADDR', attr_);
   END IF; 
   
   super(oldrec_, newrec_, indrec_, attr_); 
   
   -- because for statistical charge diff is independent of invoice also this value is used only for intrastat functionality
   --IF (oldrec_.credit_invoice_no IS NOT NULL) AND (newrec_.credit_invoice_no IS NOT NULL) AND NOT(only_stat_diff_changed_) THEN
   IF (oldrec_.credit_invoice_no IS NOT NULL) AND (newrec_.credit_invoice_no IS NOT NULL) AND (only_stat_diff_changed_ = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'CHARGECREDITED: Credited RMA charge cannot be changed.');
   END IF;

   IF NOT (newrec_.tax_liability = 'TAX' OR newrec_.tax_liability = 'EXEMPT') THEN
      delivery_country_code_ := Get_Del_Country_Code___(newrec_);
      Tax_Handling_Order_Util_API.Validate_Tax_Liability(newrec_.tax_liability, delivery_country_code_);
   END IF;

   IF (newrec_.rowstate = 'Denied')  THEN
      Error_SYS.Record_General(lu_name_, 'CHGCHARGEDENIED: Denied RMA charge cannot be changed.');
   END IF;
   
   IF ((newrec_.charged_qty = 0) AND (newrec_.credit_approver_id IS NOT NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'CHGQTYNOZERO: Credit charge line :P1-:P2 has been approved for credit. Therefore, you are not allowed to update the charged quantity to zero.', newrec_.rma_no, newrec_.rma_charge_no);
   END IF;

   Valid_Customer_Order_Charge___ ( newrec_, oldrec_, FALSE , attr_);
   Validate_Charge_And_Cost___(newrec_);

   IF refresh_tax_code_ THEN
      -- IF tax code is NOT changed, then we are only passing a NULL value to the new_fee_code,
      -- But we could have already saved a valid tax free code before uncheking the pay tax.
      IF (NOT tax_code_changed_) AND (NOT delivery_type_changed_) AND (tax_liability_type_ = 'EXM') AND (Statutory_Fee_API.Get_Percentage(newrec_.company, newrec_.fee_code) = 0) THEN
         IF (update_tax_from_ship_addr_ = 'TRUE') THEN
            new_tax_code_ := NULL;
         ELSE
            new_tax_code_ := newrec_.fee_code;
         END IF;
      END IF;
      Client_SYS.Add_To_Attr('REFRESH_FEE_CODE', 1, attr_);
   ELSE
      Client_SYS.Add_To_Attr('REFRESH_FEE_CODE', 0, attr_);
   END IF;
END Check_Update___;

@Override
PROCEDURE Unpack___ (
   newrec_   IN OUT return_material_charge_tab%ROWTYPE,
   indrec_   IN OUT Indicator_Rec,
   attr_     IN OUT VARCHAR2 )
IS
   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);
   only_stat_diff_changed_    VARCHAR2(5) := 'TRUE';
BEGIN   
   -- It should be allowed to update statistical charge diff though the CO lines invoiced or cancelled.
   IF (newrec_.rowstate IS NOT NULL) THEN
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ NOT IN ('STATISTICAL_CHARGE_DIFF')) THEN
            only_stat_diff_changed_ := 'FALSE';
            EXIT;
         END IF;
      END LOOP;
      Client_SYS.Add_To_Attr('ONLY_STAT_DIFF_CHANGED', only_stat_diff_changed_, attr_);
   END IF;
   
   super(newrec_, indrec_, attr_);
   
END Unpack___;

-- Update_Line___
--   Method that simply updates the LU table.
PROCEDURE Update_Line___ (
   objid_  IN VARCHAR2,
   newrec_ IN RETURN_MATERIAL_CHARGE_TAB%ROWTYPE )
IS
BEGIN
   UPDATE return_material_charge_tab
   SET rma_no                     = newrec_.rma_no,                                      
       rma_charge_no              = newrec_.rma_charge_no,                                      
       charge_amount              = newrec_.charge_amount,                            
       charged_qty                = newrec_.charged_qty,                     
       sales_unit_meas            = newrec_.sales_unit_meas,                 
       credited_qty               = newrec_.credited_qty,                                   
       base_charge_amount         = newrec_.base_charge_amount,                           
       charge_cost                = newrec_.charge_cost,                        
       fee_code                   = newrec_.fee_code,                     
       date_entered               = newrec_.date_entered,                         
       rma_line_no                = newrec_.rma_line_no,   
       order_no                   = newrec_.order_no,    
       sequence_no                = newrec_.sequence_no,                            
       charge_type                = newrec_.charge_type,                     
       contract                   = newrec_.contract,                           
       note_text                  = newrec_.note_text,                           
       note_id                    = newrec_.note_id,          
       credit_approver_id         = newrec_.credit_approver_id,           
       credit_invoice_no          = newrec_.credit_invoice_no,
       credit_invoice_item_id     = newrec_.credit_invoice_item_id,                  
       company                    = newrec_.company,                                        
       currency_rate              = newrec_.currency_rate,                     
       tax_liability              = newrec_.tax_liability,                                      
       charge                     = newrec_.charge,                                             
       charge_cost_percent        = newrec_.charge_cost_percent,                                       
       charge_percent_basis       = newrec_.charge_percent_basis,                                 
       base_charge_percent_basis  = newrec_.base_charge_percent_basis,                                 
       tax_class_id               = newrec_.tax_class_id,                           
       delivery_type              = newrec_.delivery_type,                                
       statistical_charge_diff    = newrec_.statistical_charge_diff,                                      
       charge_amount_incl_tax     = newrec_.charge_amount_incl_tax,                                      
       base_charge_amt_incl_tax   = newrec_.base_charge_amt_incl_tax, 
       rowversion                 = newrec_.rowversion
   WHERE rowid = objid_;
END Update_Line___;

FUNCTION Get_Del_Country_Code___(
   newrec_  IN RETURN_MATERIAL_CHARGE_TAB%ROWTYPE ) RETURN VARCHAR2
IS
   delivery_country_code_  VARCHAR2(20);
   rmarec_                 Return_Material_API.Public_Rec;
BEGIN
   IF (newrec_.order_no IS NOT NULL) THEN
      delivery_country_code_ := Customer_Order_Charge_API.Get_Connected_Deliv_Country(newrec_.order_no, newrec_.sequence_no);
   ELSE
      rmarec_  := Return_Material_API.Get(newrec_.rma_no); 
      IF (rmarec_.ship_addr_flag = 'N') THEN
         delivery_country_code_ := Return_Material_API.Get_Ship_Addr_Country(newrec_.rma_no);
      ELSE
         delivery_country_code_ := rmarec_.ship_addr_country_code;
      END IF;
   END IF;      
   RETURN delivery_country_code_;
END Get_Del_Country_Code___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Allowed_Operations__
--   Returns a string used to determine which RMB operations should be allowed
--   for the specified return charge.
@UncheckedAccess
FUNCTION Get_Allowed_Operations__ (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN VARCHAR2
IS
   operations_ VARCHAR2(20);
   rec_        RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   headrec_    Return_Material_API.Public_Rec;
BEGIN
   rec_ := get_object_by_keys___(rma_no_,rma_charge_no_);
   headrec_ := Return_Material_API.Get(rma_no_);

   -- 0 Release RMA charge
   IF (rec_.rowstate = 'Planned') AND (headrec_.return_approver_id IS NOT NULL) THEN
      operations_ := 'R';
   ELSE
      operations_ := '*';
   END IF;

   -- 1 Deny RMA charge
   IF (rec_.rowstate ='Planned') THEN
      operations_ := operations_||'D';
   ELSE
      operations_ := operations_||'*';
   END IF;

   -- 2 Create Credit Invoice
   IF (rec_.rowstate NOT IN ('Denied', 'Planned'))
     AND (rec_.credit_approver_id IS NOT NULL)
--     AND (rec_.order_no IS NOT NULL)
     AND (rec_.credit_invoice_no IS NULL)
   THEN
      operations_ := operations_||'I';
   ELSE
      operations_ := operations_||'*';
   END IF;

   -- 3 View Credit Invoice
   IF (rec_.rowstate NOT IN ('Denied', 'Planned'))
     AND (rec_.credit_invoice_no IS NOT NULL) THEN
      operations_ := operations_||'V';
   ELSE
      operations_ := operations_||'*';
   END IF;

   -- 4 Approve Credit
   IF (rec_.rowstate NOT IN ('Denied', 'Planned'))
     AND (rec_.credit_approver_id IS NULL) AND (rec_.charged_qty != 0) THEN
      operations_ := operations_||'A';
   ELSE
      operations_ := operations_||'*';
   END IF;

   -- 5 Remove Approval Credit
   IF (rec_.rowstate NOT IN ('Denied', 'Planned'))
     AND (rec_.credit_invoice_no IS NULL)
     AND (rec_.credit_approver_id IS NOT NULL) THEN
      operations_ := operations_||'R';
   ELSE
      operations_ := operations_||'*';
   END IF;

   RETURN operations_;
END Get_Allowed_Operations__;


-- Approve_For_Credit__
--   Called from client to approve a charge for crediting. Sets the credit
--   approver to the user id of the user if he is a credit approver.
PROCEDURE Approve_For_Credit__ (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER )
IS
   message_    VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___ ( objid_ , objversion_, rma_no_, rma_charge_no_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CREDIT_APPROVER_ID',
                          person_info_api.get_id_for_user(Fnd_Session_API.get_fnd_user),
                          attr_);
   Modify__(info_, objid_ , objversion_, attr_, 'DO');
   message_ := Language_SYS.Translate_Constant(lu_name_, 'RMACHGCREAPP: Charge :P1 approved for credit.', p1_ => rma_charge_no_);
   Return_Material_History_API.New(rma_no_, message_);
END Approve_For_Credit__;


-- Remove_Credit_Approval__
--   Called from client to remove credit apporval for a charge. Resets the
--   apporver ID. If not allowed the procedure will fail.
PROCEDURE Remove_Credit_Approval__ (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER )
IS
   message_    VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___ ( objid_ , objversion_, rma_no_, rma_charge_no_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CREDIT_APPROVER_ID', '', attr_);
   Modify__(info_, objid_ , objversion_, attr_, 'DO');
   message_ := Language_SYS.Translate_Constant(lu_name_, 'RMAREMCHGCREAPP: Removed credit approval for RMA charge :P1.', p1_ => rma_charge_no_);
   Return_Material_History_API.New(rma_no_, message_);
END Remove_Credit_Approval__;


-- Modify_Charge__
--   Modifies the Return Material Charge line.
PROCEDURE Modify_Charge__ (
   attr_          IN OUT VARCHAR2,
   rma_no_        IN     NUMBER,
   rma_charge_no_ IN     NUMBER )
IS
   objid_   RETURN_MATERIAL_CHARGE.objid%type;
   objver_  RETURN_MATERIAL_CHARGE.objversion%type;
   info_    VARCHAR2(32000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objver_, rma_no_, rma_charge_no_);
   Modify__(info_, objid_, objver_, attr_, 'DO');
   Client_SYS.Clear_Info;
END Modify_Charge__;


-- Modify_Fee_Code__
--   Updates the Return Material Charge line.
PROCEDURE Modify_Fee_Code__ (
   attr_          IN OUT VARCHAR2,
   rma_no_        IN     NUMBER,
   rma_charge_no_ IN     NUMBER )
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   oldrec_           RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   newrec_           RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   tax_code_         RETURN_MATERIAL_CHARGE_TAB.fee_code%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, rma_no_, rma_charge_no_);
   oldrec_          := Lock_By_Id___(objid_, objversion_);
   newrec_          := oldrec_;
   tax_code_        := Client_SYS.Get_Item_Value('FEE_CODE',attr_);
   newrec_.fee_code := tax_code_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Fee_Code__;


-- Modify_Rma_Defaults__
--   Modify RMAS header specific delivery information for all RMA charge lines
--   having pay tax set to Yes.
PROCEDURE Modify_Rma_Defaults__ (
   rma_no_                    IN NUMBER,
   rma_charge_no_             IN NUMBER,
   pay_tax_                   IN BOOLEAN,
   update_tax_from_ship_addr_ IN BOOLEAN,
   update_tax_                IN BOOLEAN DEFAULT TRUE)
IS
   attr_         VARCHAR2(2000);
   oldrec_       RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   newrec_       RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;   
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   indrec_       Indicator_Rec;
BEGIN
   oldrec_ := Get_Object_By_Keys___(rma_no_, rma_charge_no_);
   newrec_ := oldrec_;
   IF (update_tax_from_ship_addr_) THEN
      Client_SYS.Add_To_Attr('UPDATE_TAX_FROM_SHIP_ADDR', 'TRUE', attr_);
   END IF;
   
   IF NOT update_tax_ THEN
      Client_SYS.Add_To_Attr('UPDATE_TAX', 'FALSE', attr_);
   END IF;
   
   IF newrec_.rowstate NOT IN ('Credited','Denied') THEN
      Client_SYS.Add_To_Attr('TAX_LIABILITY', Return_Material_API.Get_Tax_Liability(rma_no_), attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);  
   END IF;
END Modify_Rma_Defaults__;


@Override
PROCEDURE Release__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   message_ RETURN_MATERIAL_HISTORY_TAB.message_text%TYPE;
BEGIN
   IF (action_ = 'DO') THEN
      rec_ := Get_Object_By_Id___(objid_);
   END IF;   
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN      
      message_ := Language_SYS.Translate_Constant(lu_name_, 'RMACHARGEREL: Charge :P1 released.', p1_ => rec_.rma_charge_no);
      Return_Material_History_API.New(rec_.rma_no, message_);
   END IF;
END Release__;


@Override
PROCEDURE Deny__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   message_ RETURN_MATERIAL_HISTORY_TAB.message_text%TYPE;
BEGIN
   IF (action_ = 'DO') THEN
      rec_ := Get_Object_By_Id___(objid_);
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN      
      message_ := Language_SYS.Translate_Constant(lu_name_, 'RMACHARGEDEN: Charge :P1 denied.', p1_ => rec_.rma_charge_no);
      Return_Material_History_API.New(rec_.rma_no, message_);
   END IF;
END Deny__;

@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
BEGIN 
   IF (action_ = 'DO') THEN
      remrec_ := Get_Object_By_Id___(objid_);
   END IF;  
   super(info_, objid_, objversion_, action_);
   IF (action_ = 'DO') THEN
      Source_Tax_Item_Order_API.Remove_Tax_Items(remrec_.company,
                                                 Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                                 TO_CHAR(remrec_.rma_no),
                                                 TO_CHAR(remrec_.rma_charge_no),
                                                 '*',
                                                 '*',
                                                 '*');
   END IF;
END Remove__;

-- This is a wrapper method to Credit__, which is used in Aurena to get objid and objversion
PROCEDURE Credit_Invoice__(
   info_       OUT   VARCHAR2,
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER,
   attr_          IN OUT NOCOPY VARCHAR2,
   action_        IN VARCHAR2 )
IS
   objid_               VARCHAR2(32000);
   objversion_          VARCHAR2(32000);
BEGIN
   Return_Material_Charge_API.Get_Id_Version_By_Keys___(objid_, objversion_, rma_no_, rma_charge_no_);
   Return_Material_Charge_API.Credit__(info_, objid_, objversion_, attr_, action_);
END Credit_Invoice__;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Base_Charge_Percent_Basis
--   Calculate and returns the  base value (in base curr) which is used to apply charge percentage on.
@UncheckedAccess
FUNCTION Get_Base_Charge_Percent_Basis (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ RETURN_MATERIAL_CHARGE_TAB.base_charge_percent_basis%TYPE;
   rec_  RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(rma_no_, rma_charge_no_);

   IF (rec_.charge_amount IS NULL) THEN
      IF (rec_.base_charge_percent_basis IS NULL) THEN
         temp_ := Return_Material_API.Get_Total_Base_Line__(rma_no_);
      ELSE
         temp_ := rec_.base_charge_percent_basis;
      END IF;
   END IF;

   RETURN temp_;
END Get_Base_Charge_Percent_Basis;


-- Get_Charge_Group_Desc
--   Gets charge group description in order language if possible
@UncheckedAccess
FUNCTION Get_Charge_Group_Desc (
   contract_    IN VARCHAR2,
   rma_no_      IN NUMBER,
   charge_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   language_code_     VARCHAR2(2);
   charge_desc_lang_  VARCHAR2(35);
   charge_group_      VARCHAR2(25);
BEGIN
   charge_group_ := Sales_Charge_Type_API.Get_Charge_Group (contract_, charge_type_);
   language_code_ := Return_Material_API.Get_Language_Code(rma_no_);
   charge_desc_lang_ := Sales_Charge_Group_Desc_API.Get_Charge_Group_Desc
   (language_code_, charge_group_);
   -- show language specific description if possible
   IF (charge_desc_lang_ IS NOT NULL) THEN
      RETURN charge_desc_lang_;
   ELSE
      RETURN Sales_Charge_Group_API.Get_Charge_Group_Desc(charge_group_);
   END IF;
END Get_Charge_Group_Desc;


-- Get_Charge_Type_Desc
--   Gets charge type description in order language if possible
@UncheckedAccess
FUNCTION Get_Charge_Type_Desc (
   contract_    IN VARCHAR2,
   rma_no_      IN NUMBER,
   charge_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   language_code_     VARCHAR2(2);
   charge_desc_lang_  VARCHAR2(35);
BEGIN
   language_code_    := Return_Material_API.Get_Language_Code(rma_no_);
   charge_desc_lang_ := Sales_Charge_Type_Desc_API.Get_Charge_Type_Desc
   (contract_, charge_type_, language_code_);
   -- show language specific description if possible
   IF (charge_desc_lang_ IS NOT NULL) THEN
      RETURN charge_desc_lang_;
   ELSE
      RETURN Sales_Charge_Type_API.Get_Charge_Type_Desc(contract_, charge_type_);
   END IF;
END Get_Charge_Type_Desc;


-- Get_Co_Charge_Info
--   Gets the information related to the Customer Order Charge. Called from client.
PROCEDURE Get_Co_Charge_Info (
   attr_               IN OUT VARCHAR2,
   contract_           IN     VARCHAR2,
   charge_type_        IN     VARCHAR2,
   order_no_           IN     VARCHAR2,
   sequence_no_        IN     NUMBER,
   use_price_incl_tax_ IN     VARCHAR2)
IS
   sctrec_   Sales_Charge_Type_API.Public_Rec;
   ochrec_   Customer_Order_Charge_API.Public_Rec;

   base_charge_amount_        NUMBER;
   base_charge_amt_incl_tax_  NUMBER;   
   charge_amount_             NUMBER;
   charge_amount_incl_tax_    NUMBER;
   charge_cost_               NUMBER;
   charge_                    NUMBER;
   charge_cost_percent_       NUMBER;
   charge_percent_basis_      NUMBER;
   base_charge_percent_basis_ NUMBER;
   
   sales_unit_meas_           VARCHAR2(30);
   local_charge_type_         VARCHAR2(25) := charge_type_;
   tax_liability_             VARCHAR2(20);
   currency_code_             VARCHAR2(20);
   seq_                       NUMBER;
   currency_rate_type_        VARCHAR2(10);
   currency_rate_             NUMBER;
   delivery_type_             VARCHAR2(20);
   cust_tax_usage_type_       VARCHAR2(5);

   CURSOR get_sequence_no_ IS
      SELECT sequence_no
      FROM Customer_Order_Charge_tab
      WHERE order_no = order_no_
      AND charge_type = charge_type_;

BEGIN
   -- fetch the Currency Code from the attribute string
   seq_ := sequence_no_;

   currency_rate_type_ := Customer_order_API.Get_Currency_Rate_Type(order_no_);

   IF order_no_ IS NULL THEN
      sctrec_ := Sales_Charge_Type_API.Get(contract_, charge_type_);
      sales_unit_meas_     := sctrec_.Sales_Unit_Meas;
      charge_cost_         := sctrec_.Charge_Cost;
      charge_              := sctrec_.charge;
      charge_cost_percent_ := sctrec_.charge_cost_percent;
      delivery_type_       := sctrec_.delivery_type; 
      currency_code_   := Client_SYS.Get_Item_Value('CURRENCY_CODE', attr_);
      tax_liability_   := Client_SYS.Get_Item_Value('TAX_LIABILITY',attr_);

      IF use_price_incl_tax_ = 'TRUE' THEN
         base_charge_amt_incl_tax_ := sctrec_.Charge_Amount_Incl_Tax;
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amount_incl_tax_, currency_rate_, Client_SYS.Get_Item_Value('CREDIT_CUSTOMER_NO',attr_), contract_,
         currency_code_,  base_charge_amt_incl_tax_, currency_rate_type_ );
      ELSE
         base_charge_amount_       := sctrec_.Charge_Amount;
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amount_, currency_rate_, Client_SYS.Get_Item_Value('CREDIT_CUSTOMER_NO',attr_), contract_,
         currency_code_,  base_charge_amount_, currency_rate_type_ );
      END IF;   

   ELSE
      -- Get Sequence_no
      IF (sequence_no_ IS NULL) AND (charge_type_ IS NOT NULL) THEN
         OPEN get_sequence_no_;
         FETCH get_sequence_no_ INTO seq_;
         CLOSE get_sequence_no_;
      END IF;

      -- order connection exists. Fetch the data from customer order charge.
      ochrec_ := Customer_Order_Charge_API.Get(order_no_, seq_);

      sales_unit_meas_           := ochrec_.sales_unit_meas;
      charge_cost_               := ochrec_.charge_cost;
      base_charge_amount_        := ochrec_.base_charge_amount;
      base_charge_amt_incl_tax_  := ochrec_.base_charge_amt_incl_tax;
      charge_amount_             := ochrec_.charge_amount;
      charge_amount_incl_tax_    := ochrec_.charge_amount_incl_tax;
      currency_rate_             := ochrec_.currency_rate;
      charge_                    := ochrec_.charge;
      charge_cost_percent_       := ochrec_.charge_cost_percent;
      charge_percent_basis_      := Customer_Order_Charge_API.Get_Charge_Percent_Basis(order_no_, seq_);
      base_charge_percent_basis_ := Customer_Order_Charge_API.Get_Base_Charge_Percent_Basis(order_no_, seq_);
      delivery_type_             := ochrec_.delivery_type;
      cust_tax_usage_type_       := ochrec_.customer_tax_usage_type;

      local_charge_type_ := NVL(charge_type_, ochrec_.charge_type);
      IF ochrec_.charge_type != local_charge_type_ THEN
         Error_SYS.Record_General(lu_name_,'NOMATCHCHARGT: The charge type of the connected order does not match.');
      END IF;
      tax_liability_ := Customer_Order_Charge_API.Get_Connected_Tax_Liability(order_no_, seq_);

   END IF ;

   -- empty the attribute string
   Client_SYS.Clear_Attr(attr_);

   IF ( order_no_ IS NOT NULL ) THEN
      Client_SYS.Add_To_Attr('FEE_CODE', ochrec_.tax_code, attr_);
      Client_SYS.Add_To_Attr('TAX_CLASS_ID', ochrec_.tax_class_id, attr_);
   END IF;

   -- fill it with new values.
   Client_SYS.Add_To_Attr('CHARGE_TYPE',               local_charge_type_,         attr_);
   Client_SYS.Add_To_Attr('TAX_LIABILITY',             tax_liability_,             attr_);
   Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT',        base_charge_amount_,        attr_);
   Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX',  base_charge_amt_incl_tax_,  attr_);
   Client_SYS.Add_To_Attr('CHARGE',                    charge_,                    attr_);
   Client_SYS.Add_To_Attr('CHARGE_COST_PERCENT',       charge_cost_percent_,       attr_);
   Client_SYS.Add_To_Attr('CHARGE_PERCENT_BASIS',      charge_percent_basis_,      attr_);
   Client_SYS.Add_To_Attr('BASE_CHARGE_PERCENT_BASIS', base_charge_percent_basis_, attr_);
   Client_SYS.Add_To_Attr('CHARGE_COST',               charge_cost_,               attr_);
   Client_SYS.Add_To_Attr('CHARGE_AMOUNT',             charge_amount_,             attr_);
   Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',    charge_amount_incl_tax_,    attr_);   
   Client_SYS.Add_To_Attr('SALES_UNIT_MEAS',           sales_unit_meas_,           attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE',   cust_tax_usage_type_,       attr_);
   
   IF sequence_no_ IS NULL THEN
      Client_SYS.Add_To_Attr('SEQUENCE_NO',            seq_,                       attr_);
   END IF;
   Client_SYS.Add_To_Attr('CURRENCY_RATE',      currency_rate_,       attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TYPE',      delivery_type_,       attr_);
   Client_SYS.Add_To_Attr('STATISTICAL_CHARGE_DIFF',  0,                    attr_);

END Get_Co_Charge_Info;


-- Get_Total_Base_Charged_Amount
--   Calculates the total charged amount in base currency
--   If Price Including Tax setup is used then amount is calculated as Total Charged Amount Including Tax in base currency - Tax Amount in base currency
--   If Price Including Tax setup is not used then amount is calculated as Total Charged Amount Without Tax in rma currency * currency rate
@UncheckedAccess
FUNCTION Get_Total_Base_Charged_Amount (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN NUMBER
IS   
   rec_                 RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   rounding_            NUMBER;
   charged_amount_base_ NUMBER;
BEGIN
   IF (Return_Material_API.Get_Use_Price_Incl_Tax_Db(rma_no_) = 'TRUE') THEN
      charged_amount_base_ := Get_Tot_Charged_Amt_Incl_Tax(rma_no_, rma_charge_no_) - Get_Total_Tax_Amount_Base(rma_no_, rma_charge_no_);
   ELSE
      rec_      := Get_Object_By_Keys___(rma_no_,rma_charge_no_);
      rounding_ := Currency_Code_API.Get_Currency_Rounding(rec_.company, Company_Finance_API.Get_Currency_Code(rec_.company));      
      charged_amount_base_ := ROUND(Get_Total_Charged_Amount(rma_no_, rma_charge_no_) * rec_.currency_rate, rounding_);
   END IF;

   RETURN charged_amount_base_;
END Get_Total_Base_Charged_Amount;


-- Get_Total_Charged_Amount
--   Calculates the total charged amount in rma currency 
--   If Price Including Tax setup is used then amount is calculated as Total Charged Amount Including Tax in rma currency - Tax Amount in rma currency
--   If Price Including Tax setup is not used then amount is calculated using charged amount and charged quantity.
@UncheckedAccess
FUNCTION Get_Total_Charged_Amount (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN NUMBER
IS   
   rec_                 RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   rounding_            NUMBER;
   charged_amount_curr_ NUMBER;
BEGIN      
   IF (Return_Material_API.Get_Use_Price_Incl_Tax_Db(rma_no_) = 'TRUE') THEN
      charged_amount_curr_ := Get_Total_Charged_Amt_Incl_Tax(rma_no_, rma_charge_no_) - Get_Total_Tax_Amount_Curr(rma_no_, rma_charge_no_);
   ELSE
      rec_      := Get_Object_By_Keys___(rma_no_,rma_charge_no_);
      rounding_ := Currency_Code_API.Get_Currency_Rounding(rec_.company, Return_Material_API.Get_Currency_Code(rma_no_));
      IF (rec_.charge_amount IS NULL) THEN
         charged_amount_curr_ := Get_Net_Charge_Percent_Basis(rma_no_, rma_charge_no_) * rec_.charged_qty * rec_.charge / 100;
      ELSE
         charged_amount_curr_ := rec_.charge_amount * rec_.charged_qty;
      END IF;
      charged_amount_curr_ := ROUND(charged_amount_curr_, rounding_);
   END IF;

   RETURN charged_amount_curr_;
END Get_Total_Charged_Amount;


-- Get_Tot_Charged_Amt_Incl_Tax
--   Calculates the total charged amount incl tax in base currency
--   If Price Including Tax setup is used then amount is calculated as Total Charged Amount Including Tax in order rma * currency rate
--   If Price Including Tax setup is not used then amount is calculated as Total Charged Amount Without Tax in base currency + Tax Amount in base currency
@UncheckedAccess
FUNCTION Get_Tot_Charged_Amt_Incl_Tax (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN NUMBER
IS   
   rec_                       RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   rounding_                  NUMBER;
   charged_amt_incl_tax_base_ NUMBER;
BEGIN
   IF (Return_Material_API.Get_Use_Price_Incl_Tax_Db(rma_no_) = 'TRUE') THEN
      rec_                       := Get_Object_By_Keys___(rma_no_,rma_charge_no_);
      rounding_                  := Currency_Code_API.Get_Currency_Rounding(rec_.company, Company_Finance_API.Get_Currency_Code(rec_.company));
      charged_amt_incl_tax_base_ := ROUND(Get_Total_Charged_Amt_Incl_Tax(rma_no_, rma_charge_no_) * rec_.currency_rate, rounding_);
   ELSE
      charged_amt_incl_tax_base_ := Get_Total_Base_Charged_Amount(rma_no_, rma_charge_no_) + Get_Total_Tax_Amount_Base(rma_no_, rma_charge_no_);
   END IF;

   RETURN charged_amt_incl_tax_base_;
END Get_Tot_Charged_Amt_Incl_Tax;


-- Get_Total_Charged_Amt_Incl_Tax
--   Calculates the total charged amount incl tax in rma currency
--   If Price Including Tax setup is used then amount is calculated using charged amount incl tax and charged quantity.
--   If Price Including Tax setup is not used then amount is calculated as Total Charged Amount Without Tax + Tax Amount in rma currency
@UncheckedAccess
FUNCTION Get_Total_Charged_Amt_Incl_Tax (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   rec_                       RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   rounding_                  NUMBER;
   charged_amt_incl_tax_curr_ NUMBER;
BEGIN   
   IF (Return_Material_API.Get_Use_Price_Incl_Tax_Db(rma_no_) = 'TRUE') THEN
      rec_      := Get_Object_By_Keys___(rma_no_,rma_charge_no_);
      rounding_ := Currency_Code_API.Get_Currency_Rounding(rec_.company, Return_Material_API.Get_Currency_Code(rma_no_));
      IF (rec_.charge_amount_incl_tax IS NULL) THEN
         charged_amt_incl_tax_curr_ := Get_Gross_Charge_Percent_Basis(rma_no_, rma_charge_no_) * rec_.charged_qty * rec_.charge / 100;
      ELSE
         charged_amt_incl_tax_curr_ := rec_.charge_amount_incl_tax * rec_.charged_qty;
      END IF;
      charged_amt_incl_tax_curr_ := ROUND(charged_amt_incl_tax_curr_, rounding_);
   ELSE
      charged_amt_incl_tax_curr_ := Get_Total_Charged_Amount(rma_no_, rma_charge_no_) + Get_Total_Tax_Amount_Curr(rma_no_, rma_charge_no_);
   END IF;

   RETURN charged_amt_incl_tax_curr_;
END Get_Total_Charged_Amt_Incl_Tax;


-- Modify_Credited_Qty
--   This method should only be used when invoicing the order. We do not use
--   unpack_check_update___ here, because we do not want to make all the
--   unpack checks in this case (only time the data could be invalid is if
--   someone have change them via SQLPLUS), we also gain some performance by
--   bypassing unpack
PROCEDURE Modify_Credited_Qty (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER,
   invoiced_qty_  IN NUMBER )
IS
   objid_      RETURN_MATERIAL_CHARGE.objid%TYPE;
   objversion_ RETURN_MATERIAL_CHARGE.objversion%TYPE;
   newrec_     RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   oldrec_     RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(rma_no_, rma_charge_no_);
   newrec_ := oldrec_;
   newrec_.credited_qty := invoiced_qty_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Credited_Qty;


-- Modify_Cr_Invoice_Fields
--   Modifies the credit invoice fields on the charge.
PROCEDURE Modify_Cr_Invoice_Fields (
   rma_no_             IN NUMBER,
   rma_charge_no_      IN NUMBER,
   cr_invoice_no_      IN NUMBER,
   cr_invoice_item_no_ IN NUMBER )
IS
   oldrec_             RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   newrec_             RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   attr_               VARCHAR2(2000);
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
   message_            VARCHAR2(2000);
   indrec_             Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CREDIT_INVOICE_NO', cr_invoice_no_, attr_);
   Client_SYS.Add_To_Attr('CREDIT_INVOICE_ITEM_ID', cr_invoice_item_no_, attr_);
   oldrec_ := lock_by_keys___(rma_no_, rma_charge_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE );

   IF (cr_invoice_no_ IS NOT NULL) THEN
      Finite_State_Set___(newrec_, 'Credited');
      message_ := Language_SYS.Translate_Constant (lu_name_, 'RMACHARGECRED: Credit invoice :P1 item :P2 created for charge :P3.',
                  p1_ =>  cr_invoice_no_, p2_ =>  cr_invoice_item_no_, p3_ =>  rma_charge_no_);
   ELSE
      Finite_State_Machine___(newrec_, 'InvoiceRemoved', attr_);
      message_ := Language_SYS.Translate_Constant (lu_name_, 'RMACHGCRERMD: Credit invoice :P1 item :P2 was removed from charge :P3.',
                  p1_ =>  oldrec_.credit_invoice_no, p2_ =>  oldrec_.credit_invoice_item_id, p3_ =>  rma_charge_no_);
   END IF;

   Return_Material_History_API.New(rma_no_, message_);

END Modify_Cr_Invoice_Fields;


@UncheckedAccess
FUNCTION Get_Total_Charge_Tax_Pct (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   tax_percentage_  NUMBER;
   company_         VARCHAR2(20);
BEGIN
   company_ := Get_Company(rma_no_, rma_charge_no_);
   
   tax_percentage_ := Source_Tax_Item_API.Get_Total_Tax_Percentage(company_,
                                                                   Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                                                   TO_CHAR(rma_no_),
                                                                   TO_CHAR(rma_charge_no_),
                                                                   '*',
                                                                   '*',
                                                                   '*');

   RETURN tax_percentage_;
END Get_Total_Charge_Tax_Pct;


-- Get_Total_Tax_Amount_Curr
--   To Get the Total Tax Amount in RMA currency
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount_Curr (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   line_rec_   RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   tax_amount_ NUMBER := 0;
   rounding_   NUMBER;
BEGIN
   line_rec_ := Get_Object_By_Keys___(rma_no_, rma_charge_no_);

   IF (Get_Tax_Liability_Type_Db(rma_no_, rma_charge_no_) = 'EXM') THEN
      -- No tax paid for this order line
      tax_amount_ := 0;
   ELSE
      tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Curr_Amount(line_rec_.company,
                                                                   Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                                                   TO_CHAR(rma_no_),
                                                                   TO_CHAR(rma_charge_no_),
                                                                   '*',
                                                                   '*',
                                                                   '*');

      rounding_   := Currency_Code_API.Get_Currency_Rounding(line_rec_.company, Return_Material_API.Get_Currency_Code(rma_no_));
      tax_amount_ := ROUND(tax_amount_, rounding_);
   END IF;

   RETURN NVL(tax_amount_, 0);
END Get_Total_Tax_Amount_Curr;


-- Get_Total_Tax_Amount_Base
--   To Get the Total Tax Amount in base currency
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount_Base (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   line_rec_   RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   tax_amount_ NUMBER := 0;
   rounding_   NUMBER;
BEGIN
   line_rec_ := Get_Object_By_Keys___(rma_no_, rma_charge_no_);

   IF (Get_Tax_Liability_Type_Db(rma_no_, rma_charge_no_) = 'EXM') THEN
      -- No tax paid for this order line
      tax_amount_ := 0;
   ELSE
      tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Dom_Amount(line_rec_.company,
                                                                  Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                                                  TO_CHAR(rma_no_),
                                                                  TO_CHAR(rma_charge_no_),
                                                                  '*',
                                                                  '*',
                                                                  '*');

      rounding_   := Currency_Code_API.Get_Currency_Rounding(line_rec_.company, Company_Finance_API.Get_Currency_Code(line_rec_.company));
      tax_amount_ := ROUND(tax_amount_, rounding_);
   END IF;

   RETURN NVL(tax_amount_, 0);
END Get_Total_Tax_Amount_Base;

-- Get_Total_Base_Charged_Cost
--   Calculate and returns the effective charge cost in base currency
--   depending on the charge cost or percentage and line connection.
@UncheckedAccess
FUNCTION Get_Total_Base_Charged_Cost (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   total_base_charge_cost_ NUMBER;
   rec_                    RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   rounding_               NUMBER;
   currency_code_          VARCHAR2(3);
BEGIN
   rec_           := Get_Object_By_Keys___(rma_no_, rma_charge_no_);
   currency_code_ := Company_Finance_API.Get_Currency_Code(rec_.company);
   rounding_      := Currency_Code_API.Get_Currency_Rounding(rec_.company, currency_code_);

   IF (rec_.charge_cost IS NULL) THEN
      total_base_charge_cost_ := rec_.charge_cost_percent * Return_Material_API.Get_Total_Base_Line__(rma_no_) / 100;
   ELSE
      total_base_charge_cost_ := rec_.charge_cost * rec_.charged_qty;
   END IF;
   RETURN ROUND(total_base_charge_cost_, rounding_);
END Get_Total_Base_Charged_Cost;


-- Get_Net_Charge_Percent_Basis
--   Calculate and returns the  base value (in RMA curr) which is used to apply Net charge percentage on.
@UncheckedAccess
FUNCTION Get_Net_Charge_Percent_Basis (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ RETURN_MATERIAL_CHARGE_TAB.charge_percent_basis%TYPE;
   rec_  RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(rma_no_, rma_charge_no_);

   IF (rec_.charge_amount IS NULL) THEN
      IF (rec_.charge_percent_basis IS NULL) THEN
         temp_ := Return_Material_API.Get_Total_Sale_Line__(rma_no_);
         IF (rec_.sequence_no IS NOT NULL) THEN
            IF (Fnd_Boolean_API.Encode(Customer_Order_Charge_API.Get_Unit_Charge(rec_.order_no, rec_.sequence_no)) = 'TRUE') THEN
               temp_ := temp_ / rec_.charged_qty;
            END IF;
         END IF;         
      ELSE
         temp_ := rec_.charge_percent_basis;
      END IF;
   END IF;
   RETURN temp_;
END Get_Net_Charge_Percent_Basis;


-- Get_Gross_Charge_Percent_Basis
--   Calculate and returns the  base value (in RMA curr) which is used to apply Gross charge percentage on.
@UncheckedAccess
FUNCTION Get_Gross_Charge_Percent_Basis (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ RETURN_MATERIAL_CHARGE_TAB.charge_percent_basis%TYPE;
   rec_  RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(rma_no_, rma_charge_no_);

   IF (rec_.charge_amount_incl_tax IS NULL) THEN
      IF (rec_.charge_percent_basis IS NULL) THEN
         temp_ := Return_Material_API.Get_Total_Sale_Line_Gross__(rma_no_);
         IF (rec_.sequence_no IS NOT NULL) THEN
            IF (Fnd_Boolean_API.Encode(Customer_Order_Charge_API.Get_Unit_Charge(rec_.order_no, rec_.sequence_no)) = 'TRUE') THEN
               temp_ := temp_ / rec_.charged_qty;
            END IF;
         END IF;     
      ELSE
         temp_ := rec_.charge_percent_basis;
      END IF;
   END IF;
   RETURN temp_;
END Get_Gross_Charge_Percent_Basis;


@UncheckedAccess
FUNCTION Get_Delivery_Country_Code (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_  RETURN_MATERIAL_CHARGE.delivery_country_code%TYPE;

   CURSOR get_attr IS
      SELECT delivery_country_code
      FROM   RETURN_MATERIAL_CHARGE
      WHERE  rma_no = rma_no_
      AND    rma_charge_no = rma_charge_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Delivery_Country_Code;


-- Modify_Tax_Class_Id
--   Modifies the tax class id when the tax code is changed from the
--   RMA Charge Tax Lines dialog
PROCEDURE Modify_Tax_Class_Id (
   attr_          IN OUT VARCHAR2,
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER  )
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   oldrec_           RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   newrec_           RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, rma_no_, rma_charge_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.tax_class_id := Client_Sys.Get_Item_Value('TAX_CLASS_ID', attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Tax_Class_Id;


-- New
--   The public method to create Return Material Charges.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   newrec_     RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;        
BEGIN
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);   
   Insert___(objid_, objversion_, newrec_, attr_);
   info_ := Client_SYS.Get_All_Info;
END New;


-----------------------------------------------------------------------------
-- Get_Charge_Percent_Basis
--    Calculate and returns the  base value (in RMA curr) which is used to apply charge percentage on. 
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_Charge_Percent_Basis (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_               RETURN_MATERIAL_CHARGE_TAB.charge_percent_basis%TYPE;
   rec_                RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   use_price_incl_tax_ VARCHAR2(20);
BEGIN
   rec_ := Get_Object_By_Keys___(rma_no_, rma_charge_no_);
      use_price_incl_tax_ := Return_Material_Api.Get_Use_Price_Incl_Tax_Db(rma_no_);
      IF use_price_incl_tax_ = 'TRUE' THEN
         temp_ := Get_Gross_Charge_Percent_Basis(rma_no_, rma_charge_no_);
      ELSE
         temp_ := Get_Net_Charge_Percent_Basis(rma_no_, rma_charge_no_);
      END IF;
   RETURN temp_;
END Get_Charge_Percent_Basis;

-- Recalc_Percentage_Charge_Taxes
--   Recalculate taxes for all percentage charges entered manually and not connected to RMA/CO lines
@UncheckedAccess
PROCEDURE Recalc_Percentage_Charge_Taxes (
   rma_no_              IN NUMBER,
   tax_from_defaults_   IN BOOLEAN)   
IS
   attr_      VARCHAR2(2000);
   line_rec_  RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   
   CURSOR get_charge IS
      SELECT rma_charge_no
      FROM  RETURN_MATERIAL_CHARGE_TAB
      WHERE  rma_no = rma_no_
      AND    charge IS NOT NULL
      AND    rma_line_no IS NULL
      AND    order_no IS NULL
      AND    sequence_no IS NULL;
BEGIN
   FOR rec_ IN get_charge LOOP
      line_rec_ := Get_Object_By_Keys___(rma_no_, rec_.rma_charge_no);
      Recalculate_Tax_Lines___(line_rec_, tax_from_defaults_, attr_);
   END LOOP;
END Recalc_Percentage_Charge_Taxes;

@UncheckedAccess
FUNCTION Get_Del_Country_Code (
   rma_no_        IN NUMBER,
   rma_charge_no_ IN NUMBER ) RETURN VARCHAR2
IS
   rec_                    RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   rmarec_                 Return_Material_API.Public_Rec;
   delivery_country_code_  VARCHAR2(20);
BEGIN
   rec_     := Get_Object_By_Keys___(rma_no_, rma_charge_no_);
   --             If there is not charge line exists, then RMA connected country code will fetched.
   IF rec_.rma_no IS NULL THEN
      rec_.rma_no := rma_no_;
   END IF;
   RETURN Get_Del_Country_Code___(rec_);
END Get_Del_Country_Code;

-- Get_Tax_Liability_Type_Db
--   Returns tax liability type db value
@UncheckedAccess
FUNCTION Get_Tax_Liability_Type_Db (
   rma_no_     IN VARCHAR2,
   rma_charge_no_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN      
   RETURN Tax_Liability_API.Get_Tax_Liability_Type_Db(Get_Tax_Liability(rma_no_, rma_charge_no_), Get_Delivery_Country_Code(rma_no_, rma_charge_no_));
END Get_Tax_Liability_Type_Db;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Fetch_Tax_Line_Param(   
   company_                IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2) RETURN Tax_Handling_Order_Util_API.tax_line_param_rec
IS
   rma_no_              NUMBER;
   rma_charge_no_       NUMBER;
   rma_rec_             Return_Material_API.Public_Rec;
   charge_rec_          Return_Material_Charge_API.Public_Rec;
   tax_line_param_rec_  Tax_Handling_Order_Util_API.tax_line_param_rec;
BEGIN
   rma_no_        := TO_NUMBER(source_ref1_);
   rma_charge_no_ := TO_NUMBER(source_ref2_);
   
   rma_rec_        := Return_Material_API.Get(rma_no_);  
   charge_rec_     := Return_Material_Charge_API.Get(rma_no_, rma_charge_no_);
   
   tax_line_param_rec_.company               := company_;
   tax_line_param_rec_.contract              := charge_rec_.contract;
   tax_line_param_rec_.customer_no           := rma_rec_.customer_no;
   tax_line_param_rec_.ship_addr_no          := rma_rec_.ship_addr_no;
   tax_line_param_rec_.planned_ship_date     := TRUNC(Site_API.Get_Site_Date(rma_rec_.contract));
   tax_line_param_rec_.supply_country_db     := rma_rec_.supply_country;
   tax_line_param_rec_.delivery_type         := NVL(charge_rec_.delivery_type, '*');
   tax_line_param_rec_.object_id             := charge_rec_.charge_type;
   tax_line_param_rec_.use_price_incl_tax    := rma_rec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code         := rma_rec_.currency_code;
   tax_line_param_rec_.currency_rate         := charge_rec_.currency_rate;
   tax_line_param_rec_.tax_liability         := charge_rec_.tax_liability;
   tax_line_param_rec_.tax_code              := charge_rec_.fee_code;
   tax_line_param_rec_.tax_calc_structure_id := charge_rec_.tax_calc_structure_id;
   tax_line_param_rec_.tax_class_id          := charge_rec_.tax_class_id;
   tax_line_param_rec_.tax_liability_type_db := Tax_Liability_API.Get_Tax_Liability_Type_Db(charge_rec_.tax_liability, 
                                                   Get_Delivery_Country_Code(rma_no_, rma_charge_no_));
   tax_line_param_rec_.taxable               := Sales_Charge_Type_API.Get_Taxable_Db(charge_rec_.contract, charge_rec_.charge_type);
                                                     
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
   rma_no_              NUMBER;
   rma_charge_no_       NUMBER;
BEGIN
   rma_no_        := TO_NUMBER(source_ref1_);
   rma_charge_no_ := TO_NUMBER(source_ref2_);
   
   gross_curr_amount_ := Return_Material_Charge_API.Get_Total_Charged_Amt_Incl_Tax(rma_no_, rma_charge_no_);
   net_curr_amount_  := Return_Material_Charge_API.Get_Total_Charged_Amount(rma_no_, rma_charge_no_);
   tax_curr_amount_  := Return_Material_Charge_API.Get_Total_Tax_Amount_Curr(rma_no_, rma_charge_no_);  
END Fetch_Gross_Net_Tax_Amounts;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Validate_Source_Pkg_Info (
   source_ref1_  IN VARCHAR2,
   source_ref2_  IN VARCHAR2,
   source_ref3_  IN VARCHAR2,
   source_ref4_  IN VARCHAR2,
   attr_         IN VARCHAR2 )
IS
BEGIN
   NULL;
END Validate_Source_Pkg_Info;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_Tax_Info (
   attr_          OUT VARCHAR2,
   source_ref1_   IN  VARCHAR2,
   source_ref2_   IN  VARCHAR2,
   source_ref3_   IN  VARCHAR2,
   source_ref4_   IN  VARCHAR2)
IS
   rma_line_rec_           RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;   
   tax_liability_type_db_  VARCHAR2(20);
   delivery_country_db_    VARCHAR2(2);
   rma_no_                 NUMBER;
   rma_line_no_            NUMBER;
BEGIN
   rma_no_       := TO_NUMBER(source_ref1_);
   rma_line_no_  := TO_NUMBER(source_ref2_);
   rma_line_rec_ := Get_Object_By_Keys___(rma_no_, rma_line_no_);
   delivery_country_db_ := Return_Material_API.Get_Ship_Addr_Country_Code(rma_no_);
      
   Client_SYS.Set_Item_Value('TAX_CODE', rma_line_rec_.fee_code, attr_);
   Client_SYS.Set_Item_Value('TAX_CLASS_ID', rma_line_rec_.tax_class_id, attr_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY', rma_line_rec_.tax_liability, attr_);
   tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(rma_line_rec_.tax_liability, delivery_country_db_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', tax_liability_type_db_, attr_);
   Client_SYS.Set_Item_Value('DELIVERY_COUNTRY_DB', delivery_country_db_, attr_);
   Client_SYS.Set_Item_Value('IS_TAXABLE_DB', Sales_Charge_Type_API.Get_Taxable_Db(rma_line_rec_.contract, rma_line_rec_.charge_type), attr_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY_DATE', TRUNC(Site_API.Get_Site_Date(rma_line_rec_.contract)), attr_);

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
   linerec_  RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
BEGIN
   linerec_ := Get_Object_By_Keys___(TO_NUMBER(source_ref1_), TO_NUMBER(source_ref2_));
   Client_SYS.Set_Item_Value('QUANTITY', linerec_.charged_qty, attr_);   
END Get_External_Tax_Info;


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
   oldrec_           RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;
   newrec_           RETURN_MATERIAL_CHARGE_TAB%ROWTYPE;   
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, source_ref1_, source_ref2_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.fee_code     := Client_Sys.Get_Item_Value('TAX_CODE', attr_);   
   newrec_.tax_class_id := Client_Sys.Get_Item_Value('TAX_CLASS_ID', attr_); 
   newrec_.tax_calc_structure_id  := Client_Sys.Get_Item_Value('TAX_CALC_STRUCTURE_ID', attr_);      
   Client_SYS.Set_Item_Value('TAX_CODE_CHANGED', 'TRUE', attr_);   
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Tax_Info;

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
   RETURN Get_Total_Charged_Amt_Incl_Tax (source_ref1_, source_ref2_);
END Get_Price_Incl_Tax_Total ;

-- Get_Line_Address_Info
--   Returns RMA charge line Address information.
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
   rma_rec_        Return_Material_API.Public_Rec;
   rma_charge_rec_ Return_Material_Charge_API.Public_Rec;
   cust_addr_rec_  Customer_Info_Address_API.Public_Rec;
BEGIN 
   rma_charge_rec_ := Return_Material_Charge_API.Get(source_ref1_, source_ref2_);
   
   IF (rma_charge_rec_.order_no IS NOT NULL) AND (rma_charge_rec_.sequence_no IS NOT NULL) THEN      
      Customer_Order_Charge_API.Get_Line_Address_Info(address1_,
                                                      address2_,
                                                      country_code_, 
                                                      city_, 
                                                      state_, 
                                                      zip_code_, 
                                                      county_, 
                                                      in_city_, 
                                                      rma_charge_rec_.order_no, 
                                                      rma_charge_rec_.sequence_no, 
                                                      '*', 
                                                      '*', 
                                                      company_);
   ELSE
      rma_rec_  := Return_Material_API.Get(source_ref1_);
      
      IF (rma_rec_.ship_addr_flag = 'N') THEN      
         cust_addr_rec_ := Customer_Info_Address_API.Get(rma_rec_.customer_no, rma_rec_.ship_addr_no);
         address1_      := cust_addr_rec_.address1;
         address2_      := cust_addr_rec_.address2;
         country_code_  := cust_addr_rec_.country;
         city_          := cust_addr_rec_.city;
         state_         := cust_addr_rec_.state;
         zip_code_      := cust_addr_rec_.zip_code;
         county_        := cust_addr_rec_.county;
         in_city_       := cust_addr_rec_.in_city;
      ELSE
         address1_      := rma_rec_.ship_address1;
         address2_      := rma_rec_.ship_address2;
         country_code_  := rma_rec_.ship_addr_country_code;
         city_          := rma_rec_.ship_addr_city;
         state_         := rma_rec_.ship_addr_state;
         zip_code_      := rma_rec_.ship_addr_zip_code;
         county_        := rma_rec_.ship_addr_county;
         in_city_       := NULL;
      END IF;
   END IF;
END Get_Line_Address_Info;

-- This method will return Return material charge related details which can be get through Get methods
-- This will be used to get rid of Get methods in Aurena to fetch information for Return Material Charge.
@UncheckedAccess
FUNCTION  Calculate_Charge_Amounts (
   contract_          IN VARCHAR2,
   charge_type_       IN VARCHAR2,
   rma_no_            IN NUMBER,
   rma_charge_no_     IN NUMBER,
   credit_invoice_no_ IN NUMBER) RETURN Charge_Amounts_Arr PIPELINED
IS
   rec_                Charge_Amounts_Rec;
BEGIN
   rec_.charge_type_description     := Get_Charge_Type_Desc(contract_, rma_no_, charge_type_);
   rec_.charge_group_description    := Get_Charge_Group_Desc(contract_, rma_no_, charge_type_);
   rec_.charge_basis_curr           := Get_Charge_Percent_Basis(rma_no_, rma_charge_no_);
   rec_.total_currency              := Get_Total_Charged_Amount(rma_no_, rma_charge_no_);
   rec_.total_base                  := Get_Total_Base_Charged_Amount(rma_no_, rma_charge_no_);
   rec_.gross_total_currency        := Get_Total_Charged_Amt_Incl_Tax(rma_no_, rma_charge_no_);
   rec_.gross_total_base            := Get_Tot_Charged_Amt_Incl_Tax(rma_no_, rma_charge_no_);
   rec_.tax_liability_type          := Get_Tax_Liability_Type_Db(rma_no_, rma_charge_no_);
   rec_.total_charge_cost           := Get_Total_Base_Charged_Cost(rma_no_, rma_charge_no_);
   rec_.cred_invoice_no             := Customer_Order_Inv_Head_API.Get_Invoice_No_By_Id(credit_invoice_no_);
   rec_.condition                   := Get_Allowed_Operations__(rma_no_, rma_charge_no_);
   rec_.total_tax_percentage        := Get_Total_Charge_Tax_Pct(rma_no_, rma_charge_no_);
   rec_.tax_amount                  := Get_Total_Tax_Amount_Curr(rma_no_, rma_charge_no_);
   rec_.customer_no                 := Return_Material_API.Get_Customer_No(rma_no_);
   rec_.currency_code               := Return_Material_API.Get_Currency_Code(rma_no_);
   rec_.multiple_tax_lines          := Source_Tax_Item_API.Multiple_Tax_Items_Exist(Site_API.Get_Company(contract_), 'RETURN_MATERIAL_CHARGE', rma_no_, rma_charge_no_, '*', '*', '*');
   
   PIPE ROW (rec_);                                                                                     
END Calculate_Charge_Amounts;


-- Get_Objversion
--   Return the current objversion for line.
@UncheckedAccess
FUNCTION Get_Objversion (
   rma_no_          IN VARCHAR2,
   rma_charge_no_   IN VARCHAR2) RETURN VARCHAR2
IS
   temp_  RETURN_MATERIAL_CHARGE_TAB.rowversion%TYPE;
   CURSOR get_attr IS
      SELECT rowversion
      FROM   RETURN_MATERIAL_CHARGE_TAB
      WHERE  rma_no = rma_no_
      AND    rma_charge_no = rma_charge_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN TO_CHAR(temp_, 'YYYYMMDDHH24MISS');
END Get_Objversion;
