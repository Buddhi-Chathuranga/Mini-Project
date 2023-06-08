-----------------------------------------------------------------------------
--
--  Logical unit: TaxHandlingOrderUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------
--  220103  Paralk  FI21R2-7654, Handled visibility of Tax Category 1 and Tax Category 2
--  211223  Skanlk  Bug 161134(SC21R2-6825), Added Fetch_And_Validate_Tax_Id() to validate Tax ID other than EU countires.
--  211220  Kgamlk  FI21R2-7201, Added tax_category1 and tax_category2 to Source Tax Item.
--  211202  KiSalk  Bug 161716(SC21R2-6242), Handled exception in Get_First_Tax_Code to ignore numeric conversion error when * passed for parameter local_source_ref4_.
--  210923  PraWlk  FI21R2-4180, Modified Fetch_And_Calc_Tax_From_Msg() by passing null for cst_code and legal_tax_class when calling 
--  210923          Tax_Handling_Util_API.Add_Tax_Code_Info().
--  210923  NiRalk  SC21R2-2601, Modified Calc_And_Save_Foc_Tax_Basis to calculate and return the tax basis for free of charge goods.
--  210928  NiRalk  SC21R2-2601, Modified Calc_And_Save_Foc_Tax_Basis to calculate and return the tax basis for free of charge goods when it is calculated base on part cost.
--  210910  MalLlk  SC21R2-1980, Modified Fetch_Tax_Codes___ to add a parameter value when calling Tax_Handling_Util_API.Create_Fetch_Default_Key_Rec.
--  210814  PraWlk  FI21R2-3746, Added Update_Warning_Summary___() and calld it from Fetch_External_Tax_Info() and Fetch_External_Tax_Info___().
--  210812  PraWlk  FI21R2-3666, Modified Recalc_And_Save_Tax_lines___() to set cst_code and legal tax class values from CO when transfering tax to CO invoice.
--  210801  MiKulk  SC21R2-2177-Added Unit Test Annotations for Get_Amounts, Get_External_Tax_Info
--  210725  PraWlk  FI21R2-3250, Added business operation to Fetch_External_Tax_Info(), Fetch_External_Tax_Info___() and Transfer_Ext_Tax_Lines(). Passed it 
--  210725          when calling External_Tax_System_Util_API.Fetch_Tax_From_External_System(). Called Invoice_Customer_Order_API.Update_Business_Operation()
--  211725          to update business operation in CO invoice lines.
--  210723  PraWlk  FI21R2-1489, Added Update_Citation_Information___() and used it in Fetch_External_Tax_Info().
--  210717  PraWlk  FI21R2-3084, Modified Update_Tax_Table_For_Copy_To_Rec___() by increasing the length of external_tax_info_attr_ to 2000.
--  210714  Utbalk  FI21R2-1566, Update Complimentary Information from Fetch_External_Tax_Info___ and Transfer_Ext_Tax_Lines.
--  210706  PraWlk  FI21R2-925, Passed cst_code and legal_tax_class when calling Source_Tax_Item_API.Assign_Param_To_Record().
--  210602  NiDalk  Bug 159565(SCZ-14909), Modified Calculate_Line_Totals___ to calculate tax amount correctly when RMA line has a different quantity than the copy from source quantity. Introduced Update_Tax_Table_For_Copy_To_Rec___ 
--  210602          to do necessarry calculations for tax table when copying taxes from different sources.
--  210519  Kagalk  FI21R2-1438, Replace method calls to Inv_Curr_Rate_Base_API with Base_Date_API.
--  210506  NiDalk  Bug 158933(SCZ-14121), Modified Create_Ext_Tax_Param_In_Rec___ to consider orginal invoice date as tax date for credit lines. Also Modified Write_To_Ext_Tax_Register
--  210506          not to modify taxes for credit invoice lines.
--  210222  ApWilk  Bug 157765(SCZ-13560), Modified tax_line_param_rec to increase the variable length of the object_id.
--  210215  NiDalk  Bug 157456 (SCZ-13280), Modified Write_To_Ext_Avalara_Tax_Regis, Transfer_Ext_Tax_Lines and Save_Tax_Lines___to remove tax items when the item is not taxable.
--  210129  Skanlk  SCZ-13274, Modified Fetch_Tax_Codes___() to update the tax code for customer order and sales quotation charge lines when the tax liability type is EXM, addr_flag_ is N and copy_addr_to_line_ is TRUE and
--  210129          also added a condition to prevent fetching the tax_free_tax_code_ when either the sales part or sales charge type is not taxable.
--  210119  MalLlk  SC2020R1-12113, Modified Calc_And_Save_Foc_Tax_Basis to remove the code section, where currency rate is unnecessary applied to free_of_charge_tax_basis/curr. 
--  210106  MalLlk  GESPRING20-5707, Modified Create_Line_Amount_Rec___, Create_Ext_Tax_Param_In_Rec___ and Get_Amounts to consider free_of_charge_tax_basis value correctly. 
--  201014  ChBnlk  Bug 155624(SCZ-11614), Modified Calculate_Line_Totals___ with added parameter copy_from_source_key_rec_, to distribute external tax amounts saved for package header among components when RMA is created from CO.
--  201014          Passed the new parameter from Fetch_And_Recalc_Tax_Lines___ to Calculate_Line_Totals___ and passed null from rest of the calls.
--  200710  NiDalk  SCXTEND-4446, Implemented Transfer_Ext_Tax_Lines to support External tax bundle call when creating invoices.
--  200703  NiDalk  SCXTEND-4444, Added new method Fetch_External_Tax_Info to fetch external taxes from a bundled call. Restructured code to support new bundled call.
--  200608  MalLlk  GESPRING20-4617, Added Calc_And_Save_Foc_Tax_Basis() to calculates and returns the tax basis for free of charge goods. Also allows to update the value in source line.
--  200527  KiSalk  Bug 153996(SCZ-10047), In Fetch_Tax_Info___, added NVL to company_def_invoice_type_rec_.def_co_cor_inv_type and company_def_invoice_type_rec_.def_col_cor_inv_type as the default invoice type 
--                  for customer order correction invoices and customer order collective correction invoices can be null in the company.
--  200526  Sacnlk  Bug 153287(FIZ-7377), Modified to calculate tax_parallel_amount in Fetch_Tax_Info___ When creating credit invoice using currency rates from debit invoice.
--  200417  KiSalk  Bug 152994(SCZ-9592), In Fetch_And_Calc_Tax_From_Msg, currency_rate devided by conv_factor before passed as in_currency_rate_ to Get_Curr_Rate_And_Conv_Fact___  
--  200417  Nudilk  Bug 152777, Added new overloaded method Validate_Tax_Code and moved existing code to the newly added method.
--  200331  KiSalk  Bug 152909(SCZ-9505), In Recalc_And_Save_Tax_lines___, called Calculate_Line_Totals___ to calculate tax amounts with latest tax rate if selected so in client. Added parameter set_use_specific_rate_
--  200331          to Update_Tax_Info_Table___ and Calculate_Line_Totals___. It is used not to set tax_info_table_.use_specific_rate as 'TRUE' when clling Tax_Handling_Util_API.Calc_Line_Total_Amounts 
--  200331          while creating credit invoice from debit invoice, not to recalculate tax amount from tax percentage overriding manually changed amounts.
--  200224  MaRalk  SCXTEND-3453, Modified method Field_Editable_Tax_Line_Assis by adding parameters tax_type_db_, taxable_db_ and tax_liability_type_db_ 
--  200224          in order to evaluate tax percentage editable in the Tax Lines Assistant. 
--  200210  DhAplk  Bug 152341(SCZ-8906), Corrected modifications which was done in 152216 to get tax_free_tax_code_ by making reliable for any source_ref_type_.
--  200207  DhAplk  Bug 152216(SCZ-8809), Modified Get_Single_Occ_Data to get tax_free_tax_code_ from customer defaults when it gets NULL value.
--  200127  KiSalk  Bug 151959(SCZ-8572), Modified Set_Negative_Vertex_Tax_Values___ to change the tax amount sign when creating credit invoice for negative invoice amounts.
--  191204  SBalLK  Bug 151212 (SCZ-7780), Modified Get_First_Tax_Code() method to fetch package header tax code when package component tax code request since both share the same tax codes.
--  191112  Hairlk  SCXTEND-1481, Modified Fetch_External_Tax_Info___, Added object description for each type. This will be used as the description field in the request xml to avalara.
--  191003  Hairlk  SCXTEND-876, Avalara integration, Added Get_Connected_Cust_Usage_Type, Write_To_Ext_Avalara_Tax_Regis and modified Fetch_External_Tax_Info___, Write_To_Ext_Tax_Register.
--  191003  Hairlk  SCXTEND-876, Avalara integration, Added Get_Cust_Tax_Usage_Type under avalara tax handling section.
--  190828  KiSalk  Bug 149695(SCZ-6583), In Fetch_Tax_Info___, stopped assigning all tax_info_table_ values with a single source_tax_table_ record in a loop.
--  190319  MaRalk  FIUXX-7198, Modified method Fetch_For_Tax_Line_Assistant to return source_info_rec instead of several OUT parameters.
--  190319          Added method Do_Additional_Validations with different signature.
--  190308  KHVESE  SCUXXW4-8985, Added pipelined method Get_Amounts.
--  190214  KHVESE  SCUXXW4-764, Added method Fetch_For_Tax_Line_Assistant.
--  190122  DilMlk  Bug 143413(SCZ-746), Modified methods Validate_Tax_Code and Transfer_Tax_lines to copy values from debit invoice to credit 
--  190122          invoice without recalculating tax amounts when user manually edit tax amounts in debit invoice tax lines.
--  180608  ChBnlk  Bug 140805, Modified Update_Tax_Info_Table___() in order to get the curr_rate when a specific tax rate is not used, to get proper values
--  180608          to tax/amount base.
--  180521  AsZelk  Bug 141237, Used source_tax_item_base_pub view instead of source_tax_item_pub and source_tax_item_order.
--  180425  reanpl  Bug 141485, Free of Charge enhancement - Modified Recalc_And_Save_Tax_lines___
--  180312  MAHPLK  STRSC-17505, Added new parameter adj_curr_rate_on_calc_total_ to Calculate_Line_Totals___ to control the execution of Get_Curr_Rate_And_Conv_Fact___.
--  180228  MaEelk  STRSC-17365, Modified Recalc_And_Save_Tax_lines___ to fetch correct currency rates for tax lines.
--  180222  IzShlk  STRSC-17321, Removed unnessary/usges TO_CHAR() within cursors.
--  180214  IzShlk  STRSC-17007, Modified Fetch_External_Tax_Info___ method to send '*' value to customer group if the customer is prospect and does not contain a value to customer group.
--  180209  KoDelk  STRSC-15901, Modified Recalc_And_Save_Tax_lines___ so that it will calculate the tax amount based on the date specified in out_inv_curr_rate_base
--  171222  MaEelk  STRSC-15390, Modified Recalc_And_Save_Tax_lines___ and check the soure_ref_type is of DB_INVOICE before the validation over Invoice_API.Is_Rate_Correction_Invoice
--  171220  KiSalk  STRSC-14887 (Bug 139039), Added method Get_First_Tax_Code to be used in Mpccom_Accounting_Api to fetch value for Control type C59 when multiple tax lines exist.--  171024  MalLlk  STRSC-12754, Modified methods Get_Tax_From_Vertex, Fetch_Vertex_Tax_Info___, Calculate_Line_Totals___ and Update_Tax_Info_Table___ to get Tax/curr
--  171215  MaEelk  STRSC-14742, Modified Recalc_And_Save_Tax_lines___. Added validation over Invoice_API.Is_Rate_Correction_Invoice when assigning values 
--  171215          source_ref1_, source_ref2_, source_ref3_ and source_ref4_
--  171024  MalLlk  STRSC-12754, Modified methods Get_Tax_From_Vertex, Fetch_Vertex_Tax_Info___, Calculate_Line_Totals___ and Update_Tax_Info_Table___ to get Tax/curr
--  171024          amount using Net/curr instead of dom amounts. Added method Set_Negative_Vertex_Tax_Values___. Removed unused method Get_Tax_Line_Details.
--  171016  IzShlk  STRSC-12445, Introduced Is_Jurisdic_Code_Fetched___() and Get_Adjusted_Ext_Tax_Calc_Method___() methods to restructure code to fetch vertex tax and
--  171016          vertex tax should be fetch only if there is a Jurisdiction code generated. Otherwise (foreign orders) tax will be fetched from IFS tax fetching machanisum.
--  171009  IzShlk  Bug 138004, Modified Fetch_Vertex_Tax_Info___() method to fetch vertex tax only if the tax liability is TAX. 
--  171006  MalLlk  STRSC-12644, Modified Get_Tax_From_Vertex to execute only if the country is set as fetch Jurisdiction code.
--  170507  ChJalk  Bug 134873, Modified Get_Ipd_Tax_Info to get the tax free tax code of the country of the supply site.
--  170118  NWeelk  FINHR-5776, Added tax_class_id to the tax_line_param_rec and set the correct value to it. 
--  161228  MalLlk  FINHR-5040, Introduced Tax Calculation Structures.
--  160804  NWeelk  FINHR-1301, Added method Calc_Price_Source_Prices to use from prices sources to calculate prices.
--  160624  MalLlk  FINHR-1817, Added methods Get_Tax_From_Vertex, Fetch_Vertex_Tax_Info___ and Update_Tax_Info_Table___ to handle Vertex tax handling.
--  160623  SudJlk  STRSC-2598, Replaced Cust_Order_Line_Address_API.Public_Rec with Cust_Order_Line_Address_API.Co_Line_Addr_Rec and 
--  160623          Cust_Order_Line_Address_API.Get() with Cust_Order_Line_Address_API.Get_Co_Line_Addr()
--  160607  NWeelk  FINHR-2068, Added method Validate_Tax_Free_Tax_Code.
--  160520  NWeelk  STRLOC-358, Modified Create_Line_Amount_Rec___ to set free_of_charge_tax_basis correctly for correction and credit invoice lines.
--  160419  DipeLK  FINHR-1686, Added new methods (Copy_And_Recalc_Tax_Lines___,Recalc_And_Save_Tax_lines) on order to recalculate and save exsisting tax lines as new lines.
--  160324  NWeelk  STRLOC-283, Added parameter free_of_charge_tax_basis to tax_line_param_rec, added free_of_charge_tax_basis_ 
--  160324          to Create_Tax_Line_Param_Rec, Get_Amounts and Get_Line_Amount_Rec___.
--  160324  MalLlk  FINHR-624, Added method Get_Amounts, Get_Prices and Get_Line_Amount_Rec___.
--  160316  MalLlk  FINHR-624, Added method Add_Tax_Info_To_Rec___.
--  160315  MalLlk  FINHR-624, Added method Create_Line_Amount_Rec___.
--  160309  MalLlk  FINHR-624, Added method Get_Total_Tax_Percentage.
--  160308  NWeelk  STRLOC-234, Modified Calculate_Line_Totals___ to consider threshold_amount 
--  160308          when setting line_net_curr_amount_ for free of charge lines. 
--  160307  MaIklk  STRSC-1432, Removed INVOIC conditional compilation check since invoic is static to order.
--  160229  NWeelk  STRLOC-191, Modified Calculate_Line_Totals___ to set tax calculation basis for free of charge lines.
--  160205  MalLlk  FINHR-625, Added methods Add_Transaction_Tax_Info, Get_Total_Tax_Amount, Fetch_Tax_Codes_On_Object,  
--  160205          Modify_Src_Pkg_Tax_Details, Create_Tax_Line_Param_Rec, Get_Sales_Object_Type___, Fetch_Tax_Codes___, 
--  160205          Calculate_Line_Totals___ and Add_Source_Tax_Lines___ to facilitate tax code fetching,
--  160205          calculation and adding tax lines.
--  150203  IsSalk  FINHR-647, Added method Get_Ipd_Tax_Info().
--  160201  IsSalk  FINHR-647, Redirect method calls to new utility LU TaxHandlingOrderUtil.
--  151230  IsSalk  FINHR-429, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE tax_line_param_rec IS RECORD (   
   company                   VARCHAR2(20),
   contract                  VARCHAR2(5),
   customer_no               VARCHAR2(20),
   ship_addr_no              VARCHAR2(50),
   planned_ship_date         DATE,
   supply_country_db         VARCHAR2(2),
   delivery_type             VARCHAR2(20),
   object_id                 VARCHAR2(2000),  
   use_price_incl_tax        VARCHAR2(20),
   currency_code             VARCHAR2(3),
   currency_rate             NUMBER,   
   conv_factor               NUMBER, 
   from_defaults             BOOLEAN,
   tax_code                  VARCHAR2(20),
   tax_calc_structure_id     VARCHAR2(20),
   tax_class_id              VARCHAR2(20),
   tax_liability             VARCHAR2(20),
   tax_liability_type_db     VARCHAR2(20),
   delivery_country_db       VARCHAR2(2),
   add_tax_lines             BOOLEAN,
   net_curr_amount           NUMBER,
   gross_curr_amount         NUMBER,
   ifs_curr_rounding         NUMBER,   
   free_of_charge_tax_basis  NUMBER,
   -- parallel currency specific values
   calculate_para_amount     VARCHAR2(5),
   para_curr_rate            NUMBER,
   para_conv_factor          NUMBER,
   para_curr_rounding        NUMBER,
   -- use when fetch taxes from external system 
   write_to_ext_tax_register VARCHAR2(5),
   quantity                  NUMBER,
   add_tax_curr_amount       VARCHAR2(5),
   free_of_charge            VARCHAR2(5),
   -- use in Aurena Client 
   taxable                   VARCHAR2(5),
   advance_invoice           VARCHAR2(5),
   tax_curr_rate             NUMBER,   
   tax_curr_amount           NUMBER);
        
TYPE Amounts_Rec IS RECORD (
   tax_curr_amount   NUMBER,
   net_curr_amount   NUMBER,
   gross_curr_amount NUMBER,
   tax_dom_amount    NUMBER,
   net_dom_amount    NUMBER,
   gross_dom_amount  NUMBER);

TYPE Amounts_Arr IS TABLE OF Amounts_Rec;

TYPE tax_line_param_arr IS TABLE OF tax_line_param_rec INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- IMPLEMENTATION METHODS FOR FETCHING TAX CODE INFO ------

PROCEDURE Fetch_Tax_Codes___ (
   multiple_tax_             OUT VARCHAR2,
   tax_info_table_           OUT Tax_Handling_Util_API.tax_information_table,
   tax_line_param_rec_    IN OUT tax_line_param_rec,
   source_key_rec_        IN     Tax_Handling_Util_API.source_key_rec,   
   sales_object_type_     IN     VARCHAR2,
   add_tax_curr_amount_   IN     VARCHAR2,
   attr_                  IN     VARCHAR2,
   copy_addr_to_line_     IN     VARCHAR2 DEFAULT 'FALSE')
IS
   tax_source_object_rec_   Tax_Handling_Util_API.tax_source_object_rec;
   identity_rec_            Tax_Handling_Util_API.identity_rec;
   validation_rec_          Tax_Handling_Util_API.validation_rec;
   fetch_default_key_rec_   Tax_Handling_Util_API.fetch_default_key_rec;
   modified_source_key_rec_ Tax_Handling_Util_API.source_key_rec;
   action_                  VARCHAR2(20);
   tax_method_              VARCHAR2(20);
   tax_method_db_           VARCHAR2(20);
   calc_base_               VARCHAR2(20);
   tax_type_db_             VARCHAR2(10);      
   tax_percentage_          NUMBER;   
   planned_ship_date_       DATE;
   addr_flag_               VARCHAR2(20);
   tax_free_tax_code_       VARCHAR2(20);
   fee_rate_                NUMBER;
   taxable_                 VARCHAR2(20) := 'TRUE';
BEGIN
   modified_source_key_rec_ := source_key_rec_;
   
   IF (modified_source_key_rec_.source_ref_type IN (Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                    Tax_Source_API.DB_ORDER_QUOTATION_LINE)) 
      AND (NVL(modified_source_key_rec_.source_ref4, '*') != '*') THEN 
      -- Package compoments should fetch tax info from package header.
      IF (modified_source_key_rec_.source_ref4 > 0 ) AND 
         (Sales_Part_API.Get_Taxable_Db(tax_line_param_rec_.contract, tax_line_param_rec_.object_id) = 'TRUE') THEN         
         modified_source_key_rec_.source_ref4 := TO_CHAR(-1);  
      END IF;  
   END IF; 
   
   tax_source_object_rec_ := Tax_Handling_Util_API.Create_Tax_Source_Object_Rec(tax_line_param_rec_.object_id, sales_object_type_, NULL, attr_);
   identity_rec_          := Tax_Handling_Util_API.Create_Identity_Rec(tax_line_param_rec_.customer_no,
                                                                       Party_Type_API.DB_CUSTOMER,
                                                                       tax_line_param_rec_.supply_country_db, 
                                                                       tax_line_param_rec_.delivery_country_db, 
                                                                       tax_line_param_rec_.tax_liability, 
                                                                       tax_line_param_rec_.tax_liability_type_db, 
                                                                       tax_line_param_rec_.ship_addr_no, 
                                                                       tax_line_param_rec_.delivery_type,
                                                                       NULL,
                                                                       NULL,
                                                                       NULL,
                                                                       attr_);
   
   IF (tax_line_param_rec_.from_defaults) THEN
      action_   := 'FETCH_DEFAULT_TAX';
   END IF;
   IF (tax_line_param_rec_.tax_calc_structure_id IS NOT NULL) THEN
      tax_line_param_rec_.tax_code := NULL;
   END IF;
   IF (tax_line_param_rec_.tax_class_id IS NOT NULL) AND (tax_line_param_rec_.tax_liability_type_db != 'EXM') THEN 
      tax_source_object_rec_.object_tax_class_id := tax_line_param_rec_.tax_class_id;
   END IF;
   IF (tax_line_param_rec_.use_price_incl_tax = 'TRUE') THEN
      calc_base_   := 'GROSS_BASE';
   ELSE
      calc_base_   := 'NET_BASE';
   END IF;
   planned_ship_date_     := NVL(tax_line_param_rec_.planned_ship_date, TRUNC(Site_API.Get_Site_Date(tax_line_param_rec_.contract)));
   fetch_default_key_rec_ := Tax_Handling_Util_API.Create_Fetch_Default_Key_Rec(tax_line_param_rec_.contract, NULL, NULL, NULL, NULL, NULL,NULL);
   validation_rec_        := Tax_Handling_Util_API.Create_Validation_Rec(calc_base_, 'FETCH_ALWAYS', 'TRUE', NULL);
   
   IF (source_key_rec_.source_ref_type IN (Tax_Source_API.DB_CUSTOMER_ORDER_LINE, Tax_Source_API.DB_ORDER_QUOTATION_LINE)) THEN
      taxable_ := Sales_Part_API.Get_Taxable_Db(tax_line_param_rec_.contract, tax_line_param_rec_.object_id);      
   ELSIF (source_key_rec_.source_ref_type IN (Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, Tax_Source_API.DB_ORDER_QUOTATION_CHARGE)) THEN
      taxable_ := Sales_Charge_Type_API.Get_Taxable_Db(tax_line_param_rec_.contract, tax_line_param_rec_.object_id);
   END IF;
   
   -- For single occurrence address in customer order and sales quotation, if the tax_liability_type_db is EXM, 
   -- we need to fetch the tax free tax code set in the respective headers.
   IF (taxable_ = 'TRUE') THEN
      Get_Single_Occ_Data(addr_flag_,
                          tax_free_tax_code_,
                          modified_source_key_rec_.source_ref1, 
                          modified_source_key_rec_.source_ref2, 
                          modified_source_key_rec_.source_ref3, 
                          modified_source_key_rec_.source_ref4, 
                          modified_source_key_rec_.source_ref_type,
                          identity_rec_);
   END IF;
   IF (source_key_rec_.source_ref_type IN (Tax_Source_API.DB_CUSTOMER_ORDER_LINE, Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, 
                                           Tax_Source_API.DB_ORDER_QUOTATION_LINE, Tax_Source_API.DB_ORDER_QUOTATION_CHARGE)) AND
      (tax_line_param_rec_.tax_liability_type_db = 'EXM') AND (addr_flag_ = 'Y') THEN 
      fee_rate_ := Statutory_Fee_API.Get_Fee_Rate(tax_line_param_rec_.company, tax_line_param_rec_.tax_code);
      IF (tax_line_param_rec_.tax_code IS NULL) AND (tax_free_tax_code_ IS NOT NULL) THEN 
         tax_line_param_rec_.tax_code := tax_free_tax_code_;  
      ELSIF (tax_line_param_rec_.tax_code IS NOT NULL) AND (fee_rate_ != 0) THEN 
         tax_line_param_rec_.tax_code := tax_free_tax_code_;  
      END IF;      
      Tax_Handling_Util_API.Add_Saved_Tax_Code_Info(tax_info_table_, 
                                                    tax_line_param_rec_.tax_code, 
                                                    NULL, 
                                                    NULL, 
                                                    NULL, 
                                                    NULL, 
                                                    NULL, 
                                                    NULL, 
                                                    tax_line_param_rec_.company, 
                                                    identity_rec_.party_type_db, 
                                                    planned_ship_date_, 
                                                    validation_rec_);
      Tax_Handling_Util_API.Set_Tax_Code_Info(multiple_tax_, 
                                              tax_line_param_rec_.tax_calc_structure_id,
                                              tax_line_param_rec_.tax_class_id,
                                              tax_line_param_rec_.tax_code, 
                                              tax_method_, 
                                              tax_method_db_, 
                                              tax_type_db_, 
                                              tax_percentage_, 
                                              tax_source_object_rec_, 
                                              tax_info_table_);
   ELSE
      Tax_Handling_Util_API.Fetch_Tax_Codes(multiple_tax_,
                                            tax_line_param_rec_.tax_class_id,
                                            tax_method_,
                                            tax_method_db_,
                                            tax_type_db_,
                                            tax_percentage_,    
                                            tax_info_table_,
                                            tax_source_object_rec_,
                                            tax_line_param_rec_.tax_code,
                                            tax_line_param_rec_.tax_calc_structure_id,
                                            tax_line_param_rec_.company,
                                            action_,
                                            planned_ship_date_,
                                            identity_rec_,
                                            fetch_default_key_rec_,
                                            modified_source_key_rec_,
                                            validation_rec_,
                                            add_tax_curr_amount_);
      IF (source_key_rec_.source_ref_type IN (Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, Tax_Source_API.DB_ORDER_QUOTATION_CHARGE)) AND
         (tax_line_param_rec_.tax_liability_type_db = 'EXM') AND (addr_flag_ = 'N' AND copy_addr_to_line_ = 'TRUE') THEN 
         tax_line_param_rec_.tax_code := Customer_Order_Address_API.Get_Vat_Free_Vat_Code(modified_source_key_rec_.source_ref1);
      END IF;
   END IF;
END Fetch_Tax_Codes___;

PROCEDURE Fetch_Free_Of_Charge_Info___ (
   line_net_curr_amount_ IN OUT NUMBER,
   price_type_           IN OUT VARCHAR2,
   source_key_rec_       IN Tax_Handling_Util_API.source_key_rec,
   tax_line_param_rec_   IN tax_line_param_rec,
   attr_                 IN VARCHAR2)   
IS
   threshold_amount_         NUMBER;
   cor_inv_type_             VARCHAR2(20);
   col_inv_type_             VARCHAR2(20);
   prel_update_allowed_      VARCHAR2(5);
   buy_qty_due_              NUMBER;
   invoiced_qty_             NUMBER;
   free_of_charge_tax_basis_ NUMBER;
   invoice_head_rec_         Customer_Order_Inv_Head_API.Public_Rec;
   order_no_                 VARCHAR2(12);
   line_no_                  VARCHAR2(4);
   rel_no_                   VARCHAR2(4);
   line_item_no_             NUMBER;
   item_sign_                NUMBER := 1;
BEGIN   
   free_of_charge_tax_basis_ := tax_line_param_rec_.free_of_charge_tax_basis;
   Company_Tax_Discom_Info_API.Calc_Threshold_Amount_Curr(threshold_amount_, 
                                                          tax_line_param_rec_.company,
                                                          tax_line_param_rec_.customer_no,
                                                          tax_line_param_rec_.contract,
                                                          tax_line_param_rec_.currency_code);
   IF (source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE) THEN
      cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(tax_line_param_rec_.company);
      col_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(tax_line_param_rec_.company);
      invoice_head_rec_ := Customer_Order_Inv_Head_API.Get(tax_line_param_rec_.company, source_key_rec_.source_ref1);
      prel_update_allowed_ := Customer_Order_Inv_Item_API.Get_Prel_Update_Allowed(tax_line_param_rec_.company, source_key_rec_.source_ref1, source_key_rec_.source_ref2);      

      IF ((invoice_head_rec_.invoice_type IN (cor_inv_type_, col_inv_type_)) AND (prel_update_allowed_ = Fnd_Boolean_API.DB_FALSE))  OR 
         (SUBSTR(invoice_head_rec_.invoice_type, -3, 3) = 'CRE') THEN
         IF (free_of_charge_tax_basis_ > 0) THEN
            item_sign_ := -1;
         END IF;
      END IF;
      -- Need to set free_of_charge_tax_basis_ for the debit line of the RMA correction invoice, because need to 
      -- consider invoiced_qty_ of the current invoice line when transferring tax lines from a source.
      IF ((invoice_head_rec_.invoice_type IN (cor_inv_type_, col_inv_type_)) AND (prel_update_allowed_ = Fnd_Boolean_API.DB_TRUE))  
         AND (invoice_head_rec_.rma_no IS NOT NULL) THEN
         Customer_Order_Inv_Item_API.Fetch_Order_Keys(order_no_, line_no_, rel_no_, line_item_no_, source_key_rec_.source_ref1, source_key_rec_.source_ref2);
         buy_qty_due_  := Customer_Order_Line_API.Get_Buy_Qty_Due(order_no_, line_no_, rel_no_, line_item_no_);
         invoiced_qty_ := NVL(tax_line_param_rec_.quantity, Customer_Order_Inv_Item_API.Get_Invoiced_Qty(source_key_rec_.source_ref1, order_no_, line_no_, rel_no_, line_item_no_));
         free_of_charge_tax_basis_ := (free_of_charge_tax_basis_/buy_qty_due_) * invoiced_qty_;
      END IF;
   END IF;

   IF (ABS(free_of_charge_tax_basis_) >= threshold_amount_) THEN
      line_net_curr_amount_ := free_of_charge_tax_basis_ * item_sign_;
      price_type_           := 'NET_BASE';
   ELSE
      line_net_curr_amount_ := 0;
   END IF;
END Fetch_Free_Of_Charge_Info___;

-------------------- IMPLEMENTATION METHODS FOR VERTEX TAX HANDLING ---------

PROCEDURE Fetch_External_Tax_Info___(
   multiple_tax_             OUT VARCHAR2,
   tax_info_table_           OUT Tax_Handling_Util_API.tax_information_table,
   tax_line_param_rec_    IN OUT tax_line_param_rec,
   source_key_rec_        IN     Tax_Handling_Util_API.source_key_rec,
   sales_object_type_     IN     VARCHAR2,
   add_tax_curr_amount_   IN     VARCHAR2,
   attr_                  IN     VARCHAR2,
   xml_trans_             IN     CLOB DEFAULT NULL,
   counter_               IN     NUMBER DEFAULT NULL)
IS
   ext_tax_param_in_rec_   External_Tax_System_Util_API.ext_tax_param_in_rec;   
   fetch_jurisdiction_code_ VARCHAR2(5);  
   invoice_type_           VARCHAR2(20);
   reb_cre_inv_type_       VARCHAR2(20);
   is_rebate_invoice_      BOOLEAN :=FALSE;
   -- gelr:br_external_tax_integration, begin
   complementary_info_     VARCHAR2(2000);
   citation_info_          VARCHAR2(2000);
   business_operation_arr_ External_Tax_System_Util_API.Business_Operation_Rec_Arr;
   -- gelr:br_external_tax_integration, end
BEGIN
      IF (source_key_rec_.source_ref_type IN (Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                              Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                              Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                              Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                              Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                              Tax_Source_API.DB_INVOICE,
                                              Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                              Tax_Source_API.DB_ORDER_QUOTATION_CHARGE)) THEN                                           
         IF (tax_line_param_rec_.use_price_incl_tax = 'FALSE') THEN
            IF (source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE)THEN
               invoice_type_ := Customer_Order_Inv_Head_API.Get_Invoice_Type(tax_line_param_rec_.company,source_key_rec_.source_ref1);
               reb_cre_inv_type_ := Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(tax_line_param_rec_.company);
               
               IF (invoice_type_ = reb_cre_inv_type_) THEN
                  is_rebate_invoice_ := TRUE;
               END IF;
            END IF;
            IF (NOT tax_line_param_rec_.from_defaults) OR (is_rebate_invoice_)THEN                    
               Fetch_Tax_Codes___(multiple_tax_,
                                  tax_info_table_,
                                  tax_line_param_rec_,
                                  source_key_rec_,
                                  sales_object_type_,
                                  add_tax_curr_amount_,
                                  attr_);
            ELSE       
               ext_tax_param_in_rec_ := NULL;
               Create_Ext_Tax_Param_In_Rec___(ext_tax_param_in_rec_, tax_line_param_rec_, source_key_rec_, sales_object_type_, counter_, attr_);
               
               IF ext_tax_param_in_rec_.company IS NOT NULL  THEN 
                  -- Fetches all the tax codes, tax percentages and tax curr amounts from the external tax system.
                  External_Tax_System_Util_API.Fetch_Tax_From_External_System(tax_info_table_, complementary_info_, citation_info_, business_operation_arr_, ext_tax_param_in_rec_, xml_trans_);
                  -- gelr:br_external_tax_integration, begin
                  IF (Company_Localization_Info_API.Get_Parameter_Value_Db(ext_tax_param_in_rec_.company, 'BR_EXTERNAL_TAX_INTEGRATION') = Fnd_Boolean_API.DB_TRUE) THEN
                     IF complementary_info_ IS NOT NULL AND source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE THEN
                        Customer_Order_Inv_Head_API.Update_Complimentary_Info(ext_tax_param_in_rec_.company, source_key_rec_.source_ref1, complementary_info_);
                     END IF;
                     IF citation_info_ IS NOT NULL AND source_key_rec_.source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_LINE THEN
                        Update_Citation_Information___ (source_key_rec_, citation_info_); 
                     END IF;
                     IF business_operation_arr_(1).warning_summary IS NOT NULL AND source_key_rec_.source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_LINE THEN
                        Update_Warning_Summary___ (source_key_rec_.source_ref1, business_operation_arr_(1).warning_summary); 
                     END IF;
                     IF business_operation_arr_(1).business_operation IS NOT NULL AND source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE THEN
                        Invoice_Customer_Order_API.Update_Business_Operation(ext_tax_param_in_rec_.company, source_key_rec_.source_ref1, source_key_rec_.source_ref2, business_operation_arr_(1).business_operation);
                     END IF;                     
                  END IF;
                  -- gelr:br_external_tax_integration, end
               END IF;
               
               IF (tax_info_table_.COUNT >0 ) AND (fetch_jurisdiction_code_ = 'FALSE' AND ext_tax_param_in_rec_.write_to_ext_tax_register = 'TRUE' ) THEN
                  -- the customer does not expecting any tax codes for an international customer. 
                  -- When using 770000000 we get NO_TAX in return from Vertex so we don't get any values for STATE, COUNTY, CITY and DISTRICT.
                  -- The tax lines dialog should be empty.
                  tax_info_table_.DELETE;
               END IF;
            END IF;                                             
         END IF;
      END IF;
      IF (tax_info_table_.COUNT >0 ) THEN
         IF (tax_info_table_.COUNT = 1) THEN
            tax_line_param_rec_.tax_code := tax_info_table_(1).tax_code;
            multiple_tax_                := 'FALSE';
         ELSE
            tax_line_param_rec_.tax_code := '';
            multiple_tax_                := 'TRUE';
         END IF;
      ELSE
         tax_line_param_rec_.tax_code := '';
         multiple_tax_                := 'FALSE';
      END IF;
 
END Fetch_External_Tax_Info___;

   
-- Set_Negative_Vertex_Tax_Values___
--    If the Net amounts are negative, the Tax amounts return from Vertex also need to be converted to negative value. 
--    Ex. This occurs when transferring tax information from RMA to credit invoice.
PROCEDURE Set_Negative_Vertex_Tax_Values___(
   line_amount_rec_  IN OUT Tax_Handling_Util_API.line_amount_rec, 
   tax_info_table_   IN OUT Tax_Handling_Util_API.tax_information_table)
IS
BEGIN
   -- When creating credit invoice for positive or negative invoice amount, the tax amount need to be changed to the same sign
   IF ((line_amount_rec_.line_net_curr_amount < 0 AND line_amount_rec_.line_tax_curr_amount > 0) OR 
       (line_amount_rec_.line_net_curr_amount > 0 AND line_amount_rec_.line_tax_curr_amount < 0))THEN
      line_amount_rec_.line_tax_curr_amount := -line_amount_rec_.line_tax_curr_amount;
      line_amount_rec_.line_tax_dom_amount  := -line_amount_rec_.line_tax_dom_amount;

      FOR i IN 1 .. tax_info_table_.COUNT LOOP
         IF (tax_info_table_(i).tax_base_curr_amount < 0 AND tax_info_table_(i).tax_curr_amount  > 0 ) THEN
            tax_info_table_(i).tax_curr_amount       :=  -tax_info_table_(i).tax_curr_amount;
            tax_info_table_(i).tax_dom_amount        :=  -tax_info_table_(i).tax_dom_amount;
            tax_info_table_(i).tax_para_amount       :=  -tax_info_table_(i).tax_para_amount;
            tax_info_table_(i).total_tax_curr_amount :=  -tax_info_table_(i).total_tax_curr_amount;
            tax_info_table_(i).total_tax_dom_amount  :=  -tax_info_table_(i).total_tax_dom_amount;
            tax_info_table_(i).total_tax_para_amount :=  -tax_info_table_(i).total_tax_para_amount;
          END IF;  
      END LOOP;         
   END IF;
END Set_Negative_Vertex_Tax_Values___;

-------------------- IMPLEMENTATION METHODS FOR CALCULATIONS ----------------
PROCEDURE Calculate_Line_Totals___ (
   line_amount_rec_             OUT    Tax_Handling_Util_API.line_amount_rec,
   tax_info_table_              IN OUT Tax_Handling_Util_API.tax_information_table,
   source_key_rec_              IN     Tax_Handling_Util_API.source_key_rec,
   copy_from_source_key_rec_    IN     Tax_Handling_Util_API.source_key_rec,
   tax_line_param_rec_          IN     tax_line_param_rec,
   external_tax_calc_method_    IN     VARCHAR2,
   from_get_price_info_         IN     BOOLEAN,
   set_use_specific_rate_       IN     BOOLEAN,
   attr_                        IN     VARCHAR2 )
IS
   acc_curr_rec_                 Tax_Handling_Util_API.acc_curr_rec;
   trans_curr_rec_               Tax_Handling_Util_API.trans_curr_rec;
   para_curr_rec_                Tax_Handling_Util_API.para_curr_rec;
   modified_currency_rate_       NUMBER;
   currency_conv_factor_         NUMBER;
BEGIN  
   -- Currency rate and Conversion factor returned from Customer_Order_Inv_Item_API.Fetch_Tax_Line_Param 
   -- used as it is, when print the invoice (report taxes to external tax system). 
   IF (NVL(tax_line_param_rec_.write_to_ext_tax_register, 'FALSE') = 'FALSE') THEN     
      Get_Curr_Rate_And_Conv_Fact___(modified_currency_rate_,
                                     currency_conv_factor_,
                                     tax_line_param_rec_.company,
                                     tax_line_param_rec_.currency_code,
                                     tax_line_param_rec_.currency_rate,
                                     tax_line_param_rec_.customer_no);
   ELSE
      modified_currency_rate_  := NVL(modified_currency_rate_, tax_line_param_rec_.currency_rate);
      currency_conv_factor_ := NVL(tax_line_param_rec_.conv_factor, 
                                   Currency_Code_API.Get_Conversion_Factor(tax_line_param_rec_.company, tax_line_param_rec_.currency_code));
   END IF;
   
   line_amount_rec_  := Create_Line_Amount_Rec___(source_key_rec_, 
                                                  tax_line_param_rec_,
                                                  from_get_price_info_,
                                                  attr_);
  
   trans_curr_rec_   := Tax_Handling_Util_API.Create_Trans_Curr_Rec(tax_line_param_rec_.company,
                                                                    tax_line_param_rec_.customer_no,
                                                                    Party_Type_API.DB_CUSTOMER,
                                                                    tax_line_param_rec_.currency_code,
                                                                    tax_line_param_rec_.ship_addr_no,
                                                                    attr_,
                                                                    NULL,
                                                                    tax_line_param_rec_.ifs_curr_rounding);
                                                                    
   acc_curr_rec_     := Tax_Handling_Util_API.Create_Acc_Curr_Rec(tax_line_param_rec_.company,
                                                                  attr_,
                                                                  modified_currency_rate_,
                                                                  currency_conv_factor_,                                                                  
                                                                  tax_line_param_rec_.ifs_curr_rounding);
                                                                  
   -- tax_line_param_rec_.calculate_para_amount parameeter will be null except customer order invoices.                                                               
   para_curr_rec_ := Tax_Handling_Util_API.Create_Para_Curr_Rec(tax_line_param_rec_.company,
                                                                tax_line_param_rec_.currency_code,
                                                                NVL(tax_line_param_rec_.calculate_para_amount,'FALSE'),
                                                                attr_,
                                                                tax_line_param_rec_.para_curr_rate,
                                                                tax_line_param_rec_.para_conv_factor,
                                                                tax_line_param_rec_.para_curr_rounding);
                                                                
   IF copy_from_source_key_rec_.source_ref_type IS NOT NULL AND external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED THEN
      Update_Tax_Table_For_Copy_To_Rec___(tax_info_table_, source_key_rec_, copy_from_source_key_rec_, tax_line_param_rec_, trans_curr_rec_);
   END IF;
       
   Update_Tax_Info_Table___(tax_info_table_,
                            tax_line_param_rec_.company,
                            external_tax_calc_method_,
                            source_key_rec_.source_ref_type,
                            source_key_rec_.source_ref1,
                            modified_currency_rate_,
                            set_use_specific_rate_); 

   -- Calculate line totals
   Tax_Handling_Util_API.Calc_Line_Total_Amounts(tax_info_table_, 
                                                 line_amount_rec_, 
                                                 tax_line_param_rec_.company,
                                                 trans_curr_rec_,
                                                 acc_curr_rec_,
                                                 para_curr_rec_);
   IF (external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED AND set_use_specific_rate_) THEN
      Set_Negative_Vertex_Tax_Values___(line_amount_rec_, tax_info_table_);
   END IF;                                                
END Calculate_Line_Totals___;

PROCEDURE Update_Tax_Table_For_Copy_To_Rec___ (
   tax_info_table_              IN OUT Tax_Handling_Util_API.tax_information_table,
   copy_to_source_key_rec_      IN     Tax_Handling_Util_API.source_key_rec,
   copy_from_source_key_rec_    IN     Tax_Handling_Util_API.source_key_rec,
   tax_line_param_rec_          IN     tax_line_param_rec,
   trans_curr_rec_              IN     Tax_Handling_Util_API.trans_curr_rec)
IS
   
   copy_from_qty_                NUMBER;
   --FI21R2-3084, Increased the length to 2000.
   external_tax_info_attr_       VARCHAR2(2000);
   new_qty_                      NUMBER;
   rma_line_rec_                 Return_Material_Line_API.Public_Rec;
   comp_line_rec_                Customer_Order_Line_API.Public_Rec;
   package_line_rec_             Customer_Order_Line_API.Public_Rec;
   component_tax_portion_        NUMBER := 1;
BEGIN
   IF copy_to_source_key_rec_.source_ref_type IN (Tax_Source_API.DB_RETURN_MATERIAL_LINE, Tax_Source_API.DB_RETURN_MATERIAL_CHARGE) THEN 
      Get_External_Tax_Info___(external_tax_info_attr_, copy_from_source_key_rec_.source_ref1, copy_from_source_key_rec_.source_ref2, copy_from_source_key_rec_.source_ref3, copy_from_source_key_rec_.source_ref4, copy_from_source_key_rec_.source_ref_type, tax_line_param_rec_.company);
      copy_from_qty_ := Client_SYS.Get_Item_Value_To_Number('QUANTITY', external_tax_info_attr_, lu_name_);  

      IF copy_to_source_key_rec_.source_ref_type = Tax_Source_API.DB_RETURN_MATERIAL_LINE THEN
         rma_line_rec_ := Return_Material_Line_API.Get(TO_NUMBER(copy_to_source_key_rec_.source_ref1), TO_NUMBER(copy_to_source_key_rec_.source_ref2));
         
         IF NVL(rma_line_rec_.qty_to_return_inv_uom, 0 ) = 0 THEN 
            new_qty_ := rma_line_rec_.qty_to_return;
         ELSE
            new_qty_ := NVL(rma_line_rec_.qty_to_return_inv_uom, 0 );
         END IF;
      ELSIF copy_to_source_key_rec_.source_ref_type = Tax_Source_API.DB_RETURN_MATERIAL_CHARGE THEN 
         new_qty_ := Return_Material_Charge_API.Get_Charged_Qty(TO_NUMBER(copy_to_source_key_rec_.source_ref1), TO_NUMBER(copy_to_source_key_rec_.source_ref2));
      END IF;

      IF copy_from_qty_ IS NOT NULL AND copy_from_qty_ <> new_qty_ THEN
         FOR i IN 1 .. tax_info_table_.COUNT LOOP
            tax_info_table_(i).tax_curr_amount := Currency_Amount_API.Round_Amount(trans_curr_rec_.tax_rounding_method, (tax_info_table_(i).tax_curr_amount /copy_from_qty_) * new_qty_, trans_curr_rec_.curr_rounding); 
         END LOOP;
      END IF;
   END IF;
   
   IF copy_to_source_key_rec_.source_ref_type = Tax_Source_API.DB_RETURN_MATERIAL_LINE
         AND copy_from_source_key_rec_.source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_LINE THEN
      IF (tax_info_table_.COUNT > 0 AND TO_NUMBER(copy_from_source_key_rec_.source_ref4) > 0) THEN
         -- Customer Order reference cannot be manually added to Package Component RMA line. When RMA  is created from CO
         -- external tax amounts saved for package header need to be distributed among the component lines.
         package_line_rec_      := Customer_Order_Line_API.Get(copy_from_source_key_rec_.source_ref1, copy_from_source_key_rec_.source_ref2, copy_from_source_key_rec_.source_ref3, -1);
         comp_line_rec_         := Customer_Order_Line_API.Get(copy_from_source_key_rec_.source_ref1, copy_from_source_key_rec_.source_ref2, copy_from_source_key_rec_.source_ref3, to_number(copy_from_source_key_rec_.source_ref4));
         rma_line_rec_          := Return_Material_Line_API.Get(TO_NUMBER(copy_to_source_key_rec_.source_ref1), TO_NUMBER(copy_to_source_key_rec_.source_ref2));
         -- Calculate the ratio (cost of total return component quantity) to (cost of total package quantity) 
         component_tax_portion_ := (comp_line_rec_.cost * NVL(rma_line_rec_.qty_to_return_inv_uom, rma_line_rec_.qty_to_return)  / package_line_rec_.cost / NVL(package_line_rec_.revised_qty_due, package_line_rec_.buy_qty_due));
         -- Calculate tax_curr_amounts and be round according to transaction currency
         FOR i IN 1 .. tax_info_table_.COUNT LOOP
            tax_info_table_(i).tax_curr_amount := Currency_Amount_API.Round_Amount(trans_curr_rec_.tax_rounding_method, tax_info_table_(i).tax_curr_amount * component_tax_portion_, trans_curr_rec_.curr_rounding); 
         END LOOP;
      END IF;
   END IF;
END Update_Tax_Table_For_Copy_To_Rec___;

-------------------- IMPLEMENTATION METHODS FOR COMMON LOGIC ----------------

PROCEDURE Add_Transaction_Tax_Info___ (
   line_amount_rec_          OUT Tax_Handling_Util_API.line_amount_rec,   
   multiple_tax_             OUT VARCHAR2,  
   tax_info_table_        IN OUT Tax_Handling_Util_API.tax_information_table,
   tax_line_param_rec_    IN OUT tax_line_param_rec,
   source_key_rec_        IN     Tax_Handling_Util_API.source_key_rec,
   from_get_price_info_   IN     BOOLEAN,   
   attr_                  IN     VARCHAR2,
   xml_trans_             IN     CLOB DEFAULT NULL,
   counter_               IN     NUMBER DEFAULT NULL,
   fetch_tax_info_        IN     BOOLEAN DEFAULT TRUE,
   copy_addr_to_line_     IN     VARCHAR2 DEFAULT 'FALSE')
IS   
   external_tax_calc_method_     VARCHAR2(50);
   sales_object_type_            VARCHAR2(30); 
BEGIN
   sales_object_type_            := Get_Sales_Object_Type___(tax_line_param_rec_.company, source_key_rec_);
   Add_Tax_Info_To_Rec___(tax_line_param_rec_, source_key_rec_, attr_);
   external_tax_calc_method_     := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(tax_line_param_rec_.company);
   -- gelr:br_external_tax_integration, begin
   IF (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN
      IF (source_key_rec_.source_ref_type NOT IN (Tax_Source_API.DB_CUSTOMER_ORDER_LINE, Tax_Source_API.DB_INVOICE)) THEN
         -- Avalara Brazil only supports Customer Order lines and Invoice lines in initial release
         external_tax_calc_method_ := External_Tax_Calc_Method_API.DB_NOT_USED;
      END IF;
   END IF;
   -- gelr:br_external_tax_integration, end
   
   IF (external_tax_calc_method_ = 'NOT_USED') THEN
      Fetch_Tax_Codes___(multiple_tax_,
                         tax_info_table_,
                         tax_line_param_rec_,
                         source_key_rec_,
                         sales_object_type_,
                         'FALSE',
                         attr_,
                         copy_addr_to_line_);
   ELSIF (external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
      IF fetch_tax_info_ THEN
         -- Fetch External Tax information
         Fetch_External_Tax_Info___(multiple_tax_,
                                  tax_info_table_,
                                  tax_line_param_rec_,
                                  source_key_rec_,
                                  sales_object_type_,
                                  NVL(tax_line_param_rec_.add_tax_curr_amount, 'TRUE'),
                                  attr_,
                                  xml_trans_,
                                  counter_);
      END IF;
   END IF;
   Calculate_Line_Totals___(line_amount_rec_, 
                            tax_info_table_,
                            source_key_rec_,
                            NULL,
                            tax_line_param_rec_,
                            external_tax_calc_method_,
                            from_get_price_info_,
                            TRUE,
                            attr_);

   IF (tax_line_param_rec_.add_tax_lines) THEN   
      IF (tax_info_table_.COUNT = 0) THEN 
         Tax_Handling_Util_API.Validate_Tax_Code_Mandatory(tax_line_param_rec_.company, 'CUSTOMER_TAX');        
      END IF;
      IF (source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE) THEN
         Source_Tax_Item_Invoic_API.Remove_Tax_Items( tax_line_param_rec_.company,
                                                      source_key_rec_.source_ref_type,
                                                      source_key_rec_.source_ref1,
                                                      source_key_rec_.source_ref2,
                                                      source_key_rec_.source_ref3,
                                                      source_key_rec_.source_ref4,
                                                      source_key_rec_.source_ref5);
         Source_Tax_Item_Invoic_API.Create_Tax_Items(tax_line_param_rec_.company, 'FALSE',  'TRUE', source_key_rec_, tax_info_table_);                                                                                            
      ELSE
         Source_Tax_Item_Order_API.Remove_Tax_Items( tax_line_param_rec_.company,
                                                     source_key_rec_.source_ref_type,
                                                     source_key_rec_.source_ref1,
                                                     source_key_rec_.source_ref2,
                                                     source_key_rec_.source_ref3,
                                                     source_key_rec_.source_ref4,
                                                     source_key_rec_.source_ref5);

         Source_Tax_Item_Order_API.Create_Tax_Items(tax_info_table_, 
                                                    source_key_rec_, 
                                                    tax_line_param_rec_.company);         

         Modify_Source_Tax_Info___(source_key_rec_,
                                   tax_line_param_rec_.tax_code, 
                                   tax_line_param_rec_.tax_class_id,
                                   tax_line_param_rec_.tax_calc_structure_id);
      END IF;
   END IF;
END Add_Transaction_Tax_Info___;


--Fetch_And_Recalc_Tax_Lines___
--fetch tax lines from specific source and calculate them.
PROCEDURE Fetch_And_Recalc_Tax_Lines___ (
   tax_info_table_              OUT Tax_Handling_Util_API.tax_information_table,
   multiple_tax_                OUT VARCHAR2,
   tax_line_param_rec_       IN OUT tax_line_param_rec,
   copy_from_source_key_rec_ IN     Tax_Handling_Util_API.source_key_rec,
   copy_to_source_key_rec_   IN     Tax_Handling_Util_API.source_key_rec,
   is_rebate_invoice_        IN BOOLEAN)   
IS
   line_amount_rec_              Tax_Handling_Util_API.line_amount_rec;
   external_tax_calc_method_     VARCHAR2(50);
   sales_object_type_            VARCHAR2(30);   
   attr_                         VARCHAR2(2000);
   reset_tax_curr_amount_        BOOLEAN := FALSE;
   temp_from_source_key_rec_     Tax_Handling_Util_API.source_key_rec;
BEGIN
   sales_object_type_            := Get_Sales_Object_Type___(tax_line_param_rec_.company, copy_from_source_key_rec_);  
   Add_Tax_Info_To_Rec___(tax_line_param_rec_, copy_from_source_key_rec_, attr_);
   external_tax_calc_method_     := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(tax_line_param_rec_.company);
   
   IF (external_tax_calc_method_ = 'NOT_USED') THEN
      Fetch_Tax_Codes___(multiple_tax_, 
                         tax_info_table_,
                         tax_line_param_rec_,
                         copy_from_source_key_rec_,
                         sales_object_type_,
                         'FALSE',
                         attr_);
                         
      reset_tax_curr_amount_ := TRUE;
      
   ELSIF (external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
      temp_from_source_key_rec_         := copy_from_source_key_rec_;
      tax_line_param_rec_.from_defaults := FALSE;
      
      IF (copy_from_source_key_rec_.source_ref_type IN(Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                       Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                       Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE)) AND
         (copy_to_source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE AND (NOT is_rebate_invoice_))THEN
         
         tax_line_param_rec_.from_defaults := TRUE;
         temp_from_source_key_rec_ := copy_to_source_key_rec_;
      END IF;
      
      Fetch_External_Tax_Info___(multiple_tax_,
                               tax_info_table_,
                               tax_line_param_rec_,
                               temp_from_source_key_rec_,
                               sales_object_type_,
                               'TRUE',
                               attr_);
   END IF;
   
   -- Reset tax_curr_amount return according to copy_from_source_key_rec_ for recalculate tax amounts. 
   -- When tax_curr_amount return from external tax system, that amount should use without recalculating 
   IF reset_tax_curr_amount_ THEN
      FOR i IN 1 .. tax_info_table_.COUNT LOOP
         tax_info_table_(i).tax_curr_amount := NULL;
      END LOOP;
   END IF;
   
   Calculate_Line_Totals___(line_amount_rec_, 
                            tax_info_table_,
                            copy_to_source_key_rec_,
                            copy_from_source_key_rec_,
                            tax_line_param_rec_,
                            external_tax_calc_method_,
                            FALSE,
                            TRUE,
                            attr_);
                            
END Fetch_And_Recalc_Tax_Lines___;

-- Fetch_Tax_Info___
 -- Fetch tax lines from specific source and copy them without recalculating.
PROCEDURE Fetch_Tax_Info___(
   tax_info_table_             IN OUT Tax_Handling_Util_API.tax_information_table,
   company_                    IN  VARCHAR2,
   from_source_ref_type_       IN  VARCHAR2,
   from_source_ref1_           IN  VARCHAR2,
   from_source_ref2_           IN  VARCHAR2,
   from_source_ref3_           IN  VARCHAR2,
   from_source_ref4_           IN  VARCHAR2,
   from_source_ref5_           IN  VARCHAR2,
   to_source_ref_type_         IN  VARCHAR2,
   to_source_ref1_             IN  VARCHAR2,
   to_source_ref2_             IN  VARCHAR2,
   to_source_ref3_             IN  VARCHAR2,
   to_source_ref4_             IN  VARCHAR2,
   to_source_ref5_             IN  VARCHAR2)
IS
   source_tax_table_             Source_Tax_Item_API.source_tax_table;
   in_newrec_                    source_tax_item_tab%ROWTYPE;
   creator_                      VARCHAR2(30);
   calc_base_                    VARCHAR2(20);
   credit_head_rec_              Customer_Order_Inv_Head_API.Public_Rec;
   company_def_invoice_type_rec_ Company_Def_Invoice_Type_API.Public_Rec;
   
   CURSOR get_item IS
   SELECT prel_update_allowed
   FROM   cust_invoice_pub_util_item
   WHERE  invoice_id = to_source_ref1_
   AND    item_id = to_source_ref2_
   AND    company = company_;
   
BEGIN
   source_tax_table_  := Source_Tax_Item_API.Get_Tax_Items(company_, from_source_ref_type_, from_source_ref1_, from_source_ref2_, from_source_ref3_, from_source_ref4_, from_source_ref5_);
   credit_head_rec_ := Customer_Order_Inv_Head_API.Get(company_, to_source_ref1_);
   IF (source_tax_table_.COUNT > 0) THEN
      company_def_invoice_type_rec_    := Company_Def_Invoice_Type_API.Get(company_);
      FOR i IN source_tax_table_.FIRST .. source_tax_table_.LAST LOOP
         IF (to_source_ref_type_ = 'INVOICE') THEN
            IF (credit_head_rec_.invoice_type NOT IN (NVL(company_def_invoice_type_rec_.def_co_cor_inv_type, Database_SYS.string_null_), NVL(company_def_invoice_type_rec_.def_col_cor_inv_type, Database_SYS.string_null_))) THEN
               Source_Tax_Item_API.Assign_Param_To_Record(in_newrec_, 
                                                          company_,
                                                          to_source_ref_type_,
                                                          to_source_ref1_,
                                                          to_source_ref2_,
                                                          to_source_ref3_,
                                                          to_source_ref4_,
                                                          to_source_ref5_,
                                                          source_tax_table_(i).tax_code,
                                                          source_tax_table_(i).tax_calc_structure_id,
                                                          source_tax_table_(i).tax_calc_structure_item_id,
                                                          'FALSE',
                                                          source_tax_table_(i).tax_item_id,
                                                          source_tax_table_(i).tax_percentage,
                                                          -source_tax_table_(i).tax_curr_amount,
                                                          -source_tax_table_(i).tax_dom_amount,
                                                          -source_tax_table_(i).tax_parallel_amount,
                                                          -source_tax_table_(i).non_ded_tax_curr_amount,
                                                          -source_tax_table_(i).non_ded_tax_dom_amount,
                                                          -source_tax_table_(i).non_ded_tax_parallel_amount,      
                                                          -source_tax_table_(i).tax_base_curr_amount,
                                                          -source_tax_table_(i).tax_base_dom_amount,
                                                          -source_tax_table_(i).tax_base_parallel_amount,
                                                          NULL,
                                                          -- gelr:br_external_tax_integration, begin
                                                          source_tax_table_(i).cst_code,
                                                          source_tax_table_(i).legal_tax_class,
                                                          -- gelr:br_external_tax_integration, end
                                                          source_tax_table_(i).tax_category1,
                                                          source_tax_table_(i).tax_category2);

               Source_Tax_Item_Invoic_API.New(in_newrec_);           
               creator_   := Invoice_API.Get_Creator(company_, TO_NUMBER(to_source_ref1_));
               calc_base_ := Tax_Handling_Invoic_Util_API.Get_Calc_Base_On_Invoice(company_, NULL, creator_, TO_NUMBER(to_source_ref1_));  
               Invoice_Item_API.Modify_Line_Level_Tax_Info(company_, calc_base_, creator_, NULL, TO_NUMBER(to_source_ref1_), TO_NUMBER(to_source_ref2_)); 

               tax_info_table_(i).tax_curr_amount := -source_tax_table_(i).tax_curr_amount;
               tax_info_table_(i).tax_dom_amount := -source_tax_table_(i).tax_dom_amount;
               tax_info_table_(i).tax_base_curr_amount := -source_tax_table_(i).tax_base_curr_amount;
               tax_info_table_(i).tax_base_dom_amount := -source_tax_table_(i).tax_base_dom_amount;
               tax_info_table_(i).non_ded_tax_curr_amount := -source_tax_table_(i).non_ded_tax_curr_amount;
               tax_info_table_(i).non_ded_tax_dom_amount := -source_tax_table_(i).non_ded_tax_dom_amount;
               tax_info_table_(i).tax_para_amount := -source_tax_table_(i).tax_parallel_amount;
               tax_info_table_(i).tax_base_para_amount := -source_tax_table_(i).tax_base_parallel_amount;
            ELSE           
               -- Copying tax information for Correction Invoice
               FOR itemrec_ IN get_item LOOP
                  -- Sending negative values for credit line in correction invoice
                  IF itemrec_.prel_update_allowed = 'FALSE' THEN
                     source_tax_table_(i).tax_curr_amount := source_tax_table_(i).tax_curr_amount * (-1);
                     source_tax_table_(i).tax_dom_amount := source_tax_table_(i).tax_dom_amount * (-1);
                     source_tax_table_(i).tax_base_curr_amount := source_tax_table_(i).tax_base_curr_amount * (-1);
                     source_tax_table_(i).tax_base_dom_amount := source_tax_table_(i).tax_base_dom_amount * (-1);
                     source_tax_table_(i).tax_parallel_amount := -source_tax_table_(i).tax_parallel_amount* (-1);
                     source_tax_table_(i).tax_base_parallel_amount := -source_tax_table_(i).tax_base_parallel_amount* (-1);
                  END IF;   
                  Source_Tax_Item_API.Assign_Param_To_Record(in_newrec_, 
                                                             company_,
                                                             to_source_ref_type_,
                                                             to_source_ref1_,
                                                             to_source_ref2_,
                                                             to_source_ref3_,
                                                             to_source_ref4_,
                                                             to_source_ref5_,
                                                             source_tax_table_(i).tax_code,
                                                             source_tax_table_(i).tax_calc_structure_id,
                                                             source_tax_table_(i).tax_calc_structure_item_id,
                                                             'FALSE',
                                                             source_tax_table_(i).tax_item_id,
                                                             source_tax_table_(i).tax_percentage,
                                                             source_tax_table_(i).tax_curr_amount,
                                                             source_tax_table_(i).tax_dom_amount,
                                                             source_tax_table_(i).tax_parallel_amount,
                                                             source_tax_table_(i).non_ded_tax_curr_amount,
                                                             source_tax_table_(i).non_ded_tax_dom_amount,
                                                             source_tax_table_(i).non_ded_tax_parallel_amount,     
                                                             source_tax_table_(i).tax_base_curr_amount,
                                                             source_tax_table_(i).tax_base_dom_amount,
                                                             source_tax_table_(i).tax_base_parallel_amount,
                                                             NULL,
                                                             -- gelr:br_external_tax_integration, begin
                                                             source_tax_table_(i).cst_code,
                                                             source_tax_table_(i).legal_tax_class,
                                                             -- gelr:br_external_tax_integration, end
                                                             source_tax_table_(i).tax_category1,
                                                             source_tax_table_(i).tax_category2);
                  Source_Tax_Item_Invoic_API.New(in_newrec_);               
                  creator_   := Invoice_API.Get_Creator(company_, TO_NUMBER(to_source_ref1_));
                  calc_base_ := Tax_Handling_Invoic_Util_API.Get_Calc_Base_On_Invoice(company_, NULL, creator_, TO_NUMBER(to_source_ref1_));  
                  Invoice_Item_API.Modify_Line_Level_Tax_Info(company_, calc_base_, creator_, NULL, TO_NUMBER(to_source_ref1_), TO_NUMBER(to_source_ref2_)); 
                  
                  tax_info_table_(i).tax_curr_amount := source_tax_table_(i).tax_curr_amount;
                  tax_info_table_(i).tax_dom_amount := source_tax_table_(i).tax_dom_amount;
                  tax_info_table_(i).tax_base_curr_amount := source_tax_table_(i).tax_base_curr_amount;
                  tax_info_table_(i).tax_base_dom_amount := source_tax_table_(i).tax_base_dom_amount;
                  tax_info_table_(i).non_ded_tax_curr_amount := source_tax_table_(i).non_ded_tax_curr_amount;
                  tax_info_table_(i).non_ded_tax_dom_amount := source_tax_table_(i).non_ded_tax_dom_amount;
                  tax_info_table_(i).tax_para_amount := source_tax_table_(i).tax_parallel_amount;
                  tax_info_table_(i).tax_base_para_amount := source_tax_table_(i).tax_base_parallel_amount;
               END LOOP;
            END IF;          
         END IF;                          
      END LOOP;
   END IF;
END Fetch_Tax_Info___;    

-- Recalc_And_Save_Tax_lines___
-- Recalculate tax lines using tax information fetched from specific source and insert them to a destination tax source
PROCEDURE Recalc_And_Save_Tax_lines___(
   company_                    IN  VARCHAR2,
   copy_from_source_key_rec_   IN  Tax_Handling_Util_API.source_key_rec,
   copy_to_source_key_rec_     IN  Tax_Handling_Util_API.source_key_rec,
   recalc_amounts_             IN  VARCHAR2,
   refetch_curr_rate_          IN VARCHAR2)
IS
   tax_info_table_      Tax_Handling_Util_API.tax_information_table;
   compfin_rec_         Company_Finance_API.Public_Rec;
   tax_line_param_rec_  tax_line_param_rec;
   source_pkg_          VARCHAR2(30);
   stmt_                VARCHAR2(2000);
   para_curr_rounding_  NUMBER;
   parallel_curr_rate_  NUMBER;
   para_conv_factor_    NUMBER;
   multiple_tax_        VARCHAR2(20);
   is_rebate_invoice_   BOOLEAN := FALSE;
   invoice_type_        VARCHAR2(20);
   reb_cre_inv_type_    VARCHAR2(20);
   creator_             VARCHAR2(30);
   calc_base_           VARCHAR2(20); 
   company_bearing_tax_amnt_  NUMBER;

   ivc_id_              NUMBER;
   db_invoice_          VARCHAR2(7) := Tax_Source_API.DB_INVOICE;
   db_return_material_line_   VARCHAR2(20) := Tax_Source_API.DB_RETURN_MATERIAL_LINE;
   inv_item_rec_        Customer_Order_Inv_Item_API.Public_Rec;
   attr_                      VARCHAR2(2000);
   sales_object_type_         VARCHAR2(30);
   external_tax_calc_method_  VARCHAR2(50);
   temp_from_source_key_rec_  Tax_Handling_Util_API.source_key_rec;
   line_amount_rec_              Tax_Handling_Util_API.line_amount_rec;   
   -- gelr:br_outgoing_fiscal_note, begin
   br_tax_table_              Source_Tax_Item_API.source_tax_table;
   -- gelr:br_outgoing_fiscal_note, begin
BEGIN  
   
   Create_Recal_Tax_Line_Param_Rec___(tax_line_param_rec_ ,
                                       is_rebate_invoice_,           
                                       company_,
                                       copy_from_source_key_rec_,
                                       copy_to_source_key_rec_,
                                       refetch_curr_rate_);
   
    
   IF (recalc_amounts_ = 'FALSE') THEN
      external_tax_calc_method_     := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(tax_line_param_rec_.company);
      sales_object_type_            := Get_Sales_Object_Type___(tax_line_param_rec_.company, copy_from_source_key_rec_);  
      Add_Tax_Info_To_Rec___(tax_line_param_rec_, copy_from_source_key_rec_, attr_);
                              
      IF (external_tax_calc_method_ = 'NOT_USED') THEN
         Fetch_Tax_Codes___(multiple_tax_, 
                            tax_info_table_,
                            tax_line_param_rec_,
                            copy_from_source_key_rec_,
                            sales_object_type_,
                            'FALSE',
                            attr_);      
      ELSIF (external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
         temp_from_source_key_rec_         := copy_from_source_key_rec_;
         tax_line_param_rec_.from_defaults := FALSE;

         IF (copy_from_source_key_rec_.source_ref_type IN(Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                          Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                          Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE)) AND
            (copy_to_source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE AND (NOT is_rebate_invoice_))THEN

            tax_line_param_rec_.from_defaults := TRUE;
            temp_from_source_key_rec_ := copy_to_source_key_rec_;
         END IF;

         Fetch_External_Tax_Info___(multiple_tax_,
                                    tax_info_table_,
                                    tax_line_param_rec_,
                                    temp_from_source_key_rec_,
                                    sales_object_type_,
                                    'TRUE',
                                    attr_);
      END IF; 
                             
      Fetch_Tax_Info___(tax_info_table_,
                         company_, 
                         copy_from_source_key_rec_.source_ref_type,
                         copy_from_source_key_rec_.source_ref1,
                         copy_from_source_key_rec_.source_ref2,
                         copy_from_source_key_rec_.source_ref3,
                         copy_from_source_key_rec_.source_ref4,
                         copy_from_source_key_rec_.source_ref5,
                         copy_to_source_key_rec_.source_ref_type,
                         copy_to_source_key_rec_.source_ref1,
                         copy_to_source_key_rec_.source_ref2,
                         copy_to_source_key_rec_.source_ref3,
                         copy_to_source_key_rec_.source_ref4,
                         copy_to_source_key_rec_.source_ref5 );  
                         
      IF (refetch_curr_rate_ = 'TRUE') THEN
         FOR i IN 1 .. tax_info_table_.COUNT LOOP
            tax_info_table_(i).tax_dom_amount := NULL;
            tax_info_table_(i).tax_base_dom_amount := NULL;  
         END LOOP;

         -- The parameter set_use_specific_rate_ is passed as FALSE not to set tax_info_table_.use_specific_rate as 'TRUE' when clling Tax_Handling_Util_API.Calc_Line_Total_Amounts
         -- while creating credit invoice from debit invoice, not to recalculate tax amount from tax percentage overriding manually changed amounts.
         Calculate_Line_Totals___(line_amount_rec_, 
                                  tax_info_table_,
                                  copy_to_source_key_rec_,
                                  NULL,
                                  tax_line_param_rec_,
                                  external_tax_calc_method_,
                                  FALSE,
                                  FALSE,
                                  attr_);
      END IF;
   ELSE

      Fetch_And_Recalc_Tax_Lines___(tax_info_table_, multiple_tax_, tax_line_param_rec_,  
                                    copy_from_source_key_rec_, copy_to_source_key_rec_, is_rebate_invoice_);
   END IF; 
   
   -- gelr:br_outgoing_fiscal_note, begin
   IF ((Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'OUTGOING_FISCAL_NOTE')) = 'TRUE' AND 
      (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'BR_EXTERNAL_TAX_INTEGRATION') = 'FALSE'))THEN
      br_tax_table_ := Source_Tax_Item_API.Get_Tax_Items(company_, 
                                                      copy_from_source_key_rec_.source_ref_type, 
                                                      copy_from_source_key_rec_.source_ref1, 
                                                      copy_from_source_key_rec_.source_ref2, 
                                                      copy_from_source_key_rec_.source_ref3, 
                                                      copy_from_source_key_rec_.source_ref4, 
                                                      copy_from_source_key_rec_.source_ref5);  
      FOR i IN 1 .. tax_info_table_.COUNT LOOP
         tax_info_table_(i).cst_code := br_tax_table_(i).cst_code;
         tax_info_table_(i).legal_tax_class := br_tax_table_(i).legal_tax_class;
      END LOOP;
   END IF; 
   -- gelr:br_outgoing_fiscal_note, end
   
   Save_Tax_Lines___ (  tax_info_table_,
                        copy_from_source_key_rec_,
                        copy_to_source_key_rec_,
                        tax_line_param_rec_ ,
                        company_,
                        is_rebate_invoice_ );

END Recalc_And_Save_Tax_lines___;


PROCEDURE Modify_Source_Tax_Lines___ (
   tax_info_table_      IN Tax_Handling_Util_API.tax_information_table,
   source_key_rec_      IN Tax_Handling_Util_API.source_key_rec,
   company_             IN VARCHAR2)
IS   
BEGIN
   Source_Tax_Item_Order_API.Modify_Tax_Items(tax_info_table_,
                                              source_key_rec_,
                                              company_);     
END Modify_Source_Tax_Lines___;


PROCEDURE Modify_Source_Tax_Info___ (
   source_key_rec_        IN Tax_Handling_Util_API.source_key_rec,
   tax_code_              IN VARCHAR2,
   tax_class_id_          IN VARCHAR2,
   tax_calc_structure_id_ IN VARCHAR2)
IS
   stmt_           VARCHAR2(2000);
   attr_           VARCHAR2(2000);
   source_pkg_     VARCHAR2(30);
BEGIN   
   source_pkg_  := Get_Source_Pkg___(source_key_rec_.source_ref_type);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('TAX_CODE', tax_code_, attr_);
   Client_SYS.Add_To_Attr('TAX_CLASS_ID', tax_class_id_, attr_);
   Client_SYS.Add_To_Attr('TAX_CALC_STRUCTURE_ID', tax_calc_structure_id_, attr_);
   
   Assert_Sys.Assert_Is_Package(source_pkg_);
   stmt_  := 'BEGIN '||source_pkg_||'.Modify_Tax_Info(:attr, :source_ref1, :source_ref2, :source_ref3, :source_ref4); END;';
   @ApproveDynamicStatement(2015-01-20,MalLlk) 
   EXECUTE IMMEDIATE stmt_
           USING IN OUT attr_,
                 IN  source_key_rec_.source_ref1,
                 IN  source_key_rec_.source_ref2,
                 IN  source_key_rec_.source_ref3,
                 IN  source_key_rec_.source_ref4;

END Modify_Source_Tax_Info___;


FUNCTION Get_Source_Pkg___ (
   source_ref_type_   IN VARCHAR2) RETURN VARCHAR2
IS
   source_pkg_  VARCHAR2(30);
BEGIN
   CASE source_ref_type_
      WHEN Tax_Source_API.DB_CUSTOMER_ORDER_LINE      THEN source_pkg_ := 'Customer_Order_Line_API';
      WHEN Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE    THEN source_pkg_ := 'Customer_Order_Charge_API';
      WHEN Tax_Source_API.DB_ORDER_QUOTATION_LINE     THEN source_pkg_ := 'Order_Quotation_Line_API';
      WHEN Tax_Source_API.DB_ORDER_QUOTATION_CHARGE   THEN source_pkg_ := 'Order_Quotation_Charge_API';
      WHEN Tax_Source_API.DB_RETURN_MATERIAL_LINE     THEN source_pkg_ := 'Return_Material_Line_API';
      WHEN Tax_Source_API.DB_RETURN_MATERIAL_CHARGE   THEN source_pkg_ := 'Return_Material_Charge_API';
      WHEN Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE  THEN source_pkg_ := 'Shipment_Freight_Charge_API';
      WHEN Tax_Source_API.DB_INVOICE                  THEN source_pkg_ := 'Customer_Order_Inv_Item_API';
      ELSE source_pkg_ := NULL;
      END CASE;
   RETURN source_pkg_;
END Get_Source_Pkg___;
  
   
FUNCTION Get_Sales_Object_Type___ (
   company_        IN VARCHAR2,
   source_key_rec_ IN Tax_Handling_Util_API.source_key_rec) RETURN VARCHAR2
IS
   sales_object_type_   VARCHAR2(30);
   reb_cre_inv_type_    VARCHAR2(20);
   is_charge_type_      VARCHAR2(5);
BEGIN
   IF (source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE)THEN
      reb_cre_inv_type_ := Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(company_);
      is_charge_type_   := Customer_Order_Inv_Item_API.Is_Co_Charge_Connected(company_, source_key_rec_.source_ref1, source_key_rec_.source_ref2);
      IF (Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, source_key_rec_.source_ref1) = reb_cre_inv_type_) THEN
         sales_object_type_ := 'REBATE_TYPE';
      ELSIF (is_charge_type_ = 'TRUE') THEN
         sales_object_type_ := 'CHARGE_TYPE';
      ELSE
         sales_object_type_ := 'SALES_PART';
      END IF;
   ELSE
      CASE source_key_rec_.source_ref_type
      WHEN Tax_Source_API.DB_CUSTOMER_ORDER_LINE     THEN sales_object_type_ := 'SALES_PART';
      WHEN Tax_Source_API.DB_ORDER_QUOTATION_LINE    THEN sales_object_type_ := 'SALES_PART';
      WHEN Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE   THEN sales_object_type_ := 'CHARGE_TYPE';  
      WHEN Tax_Source_API.DB_ORDER_QUOTATION_CHARGE  THEN sales_object_type_ := 'CHARGE_TYPE'; 
      WHEN Tax_Source_API.DB_RETURN_MATERIAL_LINE    THEN sales_object_type_ := 'SALES_PART';
      WHEN Tax_Source_API.DB_RETURN_MATERIAL_CHARGE  THEN sales_object_type_ := 'CHARGE_TYPE';
      WHEN Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE THEN sales_object_type_ := 'CHARGE_TYPE';
      ELSE sales_object_type_ := NULL;
      END CASE;   
   END IF; 
   RETURN sales_object_type_;
END Get_Sales_Object_Type___;


FUNCTION Create_Line_Amount_Rec___ (
   source_key_rec_       IN Tax_Handling_Util_API.source_key_rec,
   tax_line_param_rec_   IN tax_line_param_rec,
   from_get_price_info_  IN BOOLEAN,
   attr_                 IN VARCHAR2) RETURN Tax_Handling_Util_API.line_amount_rec
IS
   line_gross_curr_amount_   NUMBER;
   line_net_curr_amount_     NUMBER;
   price_type_               VARCHAR2(20);
   stmt_                     VARCHAR2(2000);   
   source_ref1_              VARCHAR2(50);
   source_ref2_              VARCHAR2(50);
   source_ref3_              VARCHAR2(50);
   source_ref4_              VARCHAR2(50);
   source_ref5_              VARCHAR2(50);   
   source_pkg_               VARCHAR2(30);   
BEGIN
   IF (tax_line_param_rec_.free_of_charge_tax_basis IS NOT NULL AND tax_line_param_rec_.free_of_charge_tax_basis > 0) THEN
      Fetch_Free_Of_Charge_Info___(line_net_curr_amount_,
                                            price_type_,
                                            source_key_rec_,
                                            tax_line_param_rec_,
                                            attr_);      
   ELSIF (source_key_rec_.source_ref2 IS NOT NULL) AND (tax_line_param_rec_.gross_curr_amount IS NULL) 
      AND (tax_line_param_rec_.net_curr_amount IS NULL) AND (NOT from_get_price_info_)THEN 
      
      IF (source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE) THEN
         source_ref1_ := tax_line_param_rec_.company;
         source_ref2_ := source_key_rec_.source_ref1;
         source_ref3_ := source_key_rec_.source_ref2;
         source_ref4_ := '*';         
      ELSE
         source_ref1_ := source_key_rec_.source_ref1;
         source_ref2_ := source_key_rec_.source_ref2;
         source_ref3_ := source_key_rec_.source_ref3;
         source_ref4_ := source_key_rec_.source_ref4;         
      END IF;
      source_ref5_ := '*';
      source_pkg_  := Get_Source_Pkg___(source_key_rec_.source_ref_type);
      Assert_Sys.Assert_Is_Package(source_pkg_);
      -- Get Net or Gross amount based on PIV setting   
      IF (tax_line_param_rec_.use_price_incl_tax = 'TRUE') THEN
         stmt_  := 'BEGIN :line_gross_curr_amount := ' ||source_pkg_||'.Get_Price_Incl_Tax_Total(:source_ref1, 
                                                      :source_ref2, :source_ref3, :source_ref4); END;';
         @ApproveDynamicStatement(2016-01-12,MalLlk) 
         EXECUTE IMMEDIATE stmt_
                 USING OUT line_gross_curr_amount_,
                       IN  source_ref1_,
                       IN  source_ref2_,
                       IN  source_ref3_,
                       IN  source_ref4_;
         price_type_ := 'GROSS_BASE';
      ELSE
         stmt_ := 'BEGIN :line_net_curr_amount := ' ||source_pkg_||'.Get_Price_Total(:source_ref1, 
                                                   :source_ref2, :source_ref3, :source_ref4); END;';
         @ApproveDynamicStatement(2016-01-12,MalLlk) 
         EXECUTE IMMEDIATE stmt_
                 USING OUT line_net_curr_amount_,
                       IN  source_ref1_,
                       IN  source_ref2_,
                       IN  source_ref3_,
                       IN  source_ref4_;
         price_type_ := 'NET_BASE';
      END IF;
   ELSE
      IF (tax_line_param_rec_.use_price_incl_tax = 'TRUE') THEN
         line_gross_curr_amount_ := tax_line_param_rec_.gross_curr_amount;
         price_type_             := 'GROSS_BASE';
      ELSE
         line_net_curr_amount_   := tax_line_param_rec_.net_curr_amount;
         price_type_             := 'NET_BASE';
      END IF;   
   END IF;
   
   RETURN Tax_Handling_Util_API.Create_Line_Amount_Rec(line_gross_curr_amount_, 
                                                       line_net_curr_amount_,
                                                       NULL, 
                                                       price_type_,
                                                       'FALSE',
                                                       attr_);
                                                                  
END Create_Line_Amount_Rec___;


PROCEDURE Get_Line_Amount_Rec___ (
   line_amount_rec_           IN OUT Tax_Handling_Util_API.line_amount_rec,
   multiple_tax_              IN OUT VARCHAR2,
   line_tax_code_             IN OUT VARCHAR2,
   tax_calc_structure_id_     IN OUT VARCHAR2,
   tax_class_id_              IN OUT VARCHAR2,
   source_ref1_               IN     VARCHAR2,
   source_ref2_               IN     VARCHAR2,
   source_ref3_               IN     VARCHAR2,
   source_ref4_               IN     VARCHAR2,
   source_ref5_               IN     VARCHAR2,
   source_ref_type_           IN     VARCHAR2,
   company_                   IN     VARCHAR2,
   contract_                  IN     VARCHAR2,
   customer_no_               IN     VARCHAR2,
   ship_addr_no_              IN     VARCHAR2,
   planned_ship_date_         IN     DATE,
   supply_country_db_         IN     VARCHAR2,
   delivery_type_             IN     VARCHAR2,
   object_id_                 IN     VARCHAR2,
   use_price_incl_tax_        IN     VARCHAR2,
   currency_code_             IN     VARCHAR2,
   currency_rate_             IN     NUMBER,
   from_defaults_             IN     VARCHAR2,  
   tax_liability_             IN     VARCHAR2,
   tax_liability_type_db_     IN     VARCHAR2,
   delivery_country_db_       IN     VARCHAR2,
   ifs_curr_rounding_         IN     NUMBER,
   free_of_charge_tax_basis_  IN     NUMBER,
   add_tax_curr_amount_       IN     VARCHAR2,
   quantity_                  IN     NUMBER,
   from_get_price_info_       IN     BOOLEAN,
   attr_                      IN     VARCHAR2)
IS   
   source_key_rec_        Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_    tax_line_param_rec;
   modified_company_      VARCHAR2(20);
   fetch_from_defaults_   BOOLEAN := FALSE;
   tax_info_table_        Tax_Handling_Util_API.tax_information_table;
BEGIN
   
   IF (from_defaults_ = 'TRUE') THEN
      fetch_from_defaults_ := TRUE;   
   END IF;

   modified_company_ := NVL(company_, Site_API.Get_Company(contract_));   
   source_key_rec_   := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_,
                                                                    source_ref1_, 
                                                                    source_ref2_, 
                                                                    source_ref3_, 
                                                                    source_ref4_,
                                                                    source_ref5_,
                                                                    NULL);

   -- Note: Pass FALSE to add_tax_lines_ parameter.
   tax_line_param_rec_ := Create_Tax_Line_Param_Rec(modified_company_,
                                                    contract_,
                                                    customer_no_,
                                                    ship_addr_no_,
                                                    planned_ship_date_,
                                                    supply_country_db_,
                                                    delivery_type_,
                                                    object_id_,
                                                    use_price_incl_tax_,
                                                    currency_code_,
                                                    currency_rate_,                                                                                       
                                                    NULL,
                                                    fetch_from_defaults_,
                                                    line_tax_code_,
                                                    tax_calc_structure_id_,
                                                    tax_class_id_,
                                                    tax_liability_,
                                                    tax_liability_type_db_,
                                                    delivery_country_db_,
                                                    FALSE,
                                                    line_amount_rec_.line_net_curr_amount,
                                                    line_amount_rec_.line_gross_curr_amount,
                                                    ifs_curr_rounding_,
                                                    free_of_charge_tax_basis_,
                                                    attr_);
   
   tax_line_param_rec_.add_tax_curr_amount := add_tax_curr_amount_;
   tax_line_param_rec_.quantity            := quantity_;
   
   Add_Transaction_Tax_Info___(line_amount_rec_,
                              multiple_tax_,
                              tax_info_table_,
                              tax_line_param_rec_,
                              source_key_rec_, 
                              from_get_price_info_,
                              attr_);
                            
  line_tax_code_         := tax_line_param_rec_.tax_code;
  tax_calc_structure_id_ := tax_line_param_rec_.tax_calc_structure_id; 
  tax_class_id_          := tax_line_param_rec_.tax_class_id; 
  
END Get_Line_Amount_Rec___;


PROCEDURE Add_Tax_Info_To_Rec___ (
   tax_line_param_rec_ IN OUT tax_line_param_rec,
   source_key_rec_     IN     Tax_Handling_Util_API.source_key_rec,
   attr_               IN     VARCHAR2)
IS
   source_pkg_              VARCHAR2(30);   
   delivery_country_db_     VARCHAR2(2);
   tax_liability_           VARCHAR2(20);
   tax_liability_type_db_   VARCHAR2(20);    
   ship_addr_no_            VARCHAR2(50);
   stmt_                    VARCHAR2(2000);
   source_tax_info_attr_    VARCHAR2(2000);
   source_ref1_             VARCHAR2(50);
   source_ref2_             VARCHAR2(50);
   source_ref3_             VARCHAR2(50);
   source_ref4_             VARCHAR2(50);
   source_ref5_             VARCHAR2(50);
BEGIN
   IF (tax_line_param_rec_.delivery_country_db IS NULL OR tax_line_param_rec_.tax_liability IS NULL OR tax_line_param_rec_.tax_liability_type_db IS NULL) THEN
      IF (source_key_rec_.source_ref2 IS NOT NULL AND source_key_rec_.source_ref2 != '*') THEN
         source_pkg_ := Get_Source_Pkg___(source_key_rec_.source_ref_type);
         IF(source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE) THEN
            source_ref1_ := tax_line_param_rec_.company;
            source_ref2_ := source_key_rec_.source_ref1;
            source_ref3_ := source_key_rec_.source_ref2;
            source_ref4_ := '*';            
         ELSE
            source_ref1_ := source_key_rec_.source_ref1;
            source_ref2_ := source_key_rec_.source_ref2;
            source_ref3_ := source_key_rec_.source_ref3;
            source_ref4_ := source_key_rec_.source_ref4;            
         END IF;
         source_ref5_ := '*';
         Assert_Sys.Assert_Is_Package(source_pkg_);
         stmt_       := 'BEGIN '||source_pkg_||'.Get_Tax_Info(:attr, :source_ref1, :source_ref2, :source_ref3, :source_ref4); END;';
         @ApproveDynamicStatement(2015-03-16,MalLlk) 
         EXECUTE IMMEDIATE stmt_
                 USING OUT source_tax_info_attr_,
                       IN  source_ref1_,
                       IN  source_ref2_,
                       IN  source_ref3_,
                       IN  source_ref4_;       

         delivery_country_db_   := Client_SYS.Get_Item_Value('DELIVERY_COUNTRY_DB', source_tax_info_attr_);
         tax_liability_         := Client_SYS.Get_Item_Value('TAX_LIABILITY', source_tax_info_attr_);
         tax_liability_type_db_ := Client_SYS.Get_Item_Value('TAX_LIABILITY_TYPE_DB', source_tax_info_attr_);
      ELSE         
         ship_addr_no_          := NVL(tax_line_param_rec_.ship_addr_no, 
                                       Customer_Info_Address_API.Get_Default_Address(tax_line_param_rec_.customer_no, Address_Type_Code_API.Decode('DELIVERY')));
         delivery_country_db_   := Customer_Info_Address_API.Get_Country_Code(tax_line_param_rec_.customer_no, 
                                                                              ship_addr_no_);
         tax_liability_         := Tax_Handling_Util_API.Get_Customer_Tax_Liability(tax_line_param_rec_.customer_no , 
                                                                                    ship_addr_no_, 
                                                                                    tax_line_param_rec_.company,
                                                                                    NVL(tax_line_param_rec_.supply_country_db, Company_API.Get_Country_Db(tax_line_param_rec_.company)));
         tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(NVL(tax_line_param_rec_.tax_liability, tax_liability_), 
                                                                               NVL(tax_line_param_rec_.delivery_country_db, delivery_country_db_));
      END IF;

      tax_line_param_rec_.delivery_country_db   := NVL(tax_line_param_rec_.delivery_country_db, delivery_country_db_);
      tax_line_param_rec_.tax_liability         := NVL(tax_line_param_rec_.tax_liability, tax_liability_);
      tax_line_param_rec_.tax_liability_type_db := NVL(tax_line_param_rec_.tax_liability_type_db, tax_liability_type_db_);
   END IF;   
END Add_Tax_Info_To_Rec___;

PROCEDURE Update_Tax_Info_Table___(
   tax_info_table_            IN OUT Tax_Handling_Util_API.tax_information_table,
   company_                   IN     VARCHAR2,
   external_tax_calc_method_  IN     VARCHAR2,
   source_ref_type_db_        IN     VARCHAR2,
   source_ref1_               IN     VARCHAR2,
   curr_rate_                 IN     NUMBER,
   set_use_specific_rate_     IN     BOOLEAN )
IS
   use_specific_rate_         VARCHAR2(5):= 'FALSE';
   tax_curr_rate_             NUMBER;
BEGIN
   IF (external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED AND company_ IS NOT NULL) THEN
      FOR i IN 1 .. tax_info_table_.COUNT LOOP
         tax_info_table_(i).tax_type_db             := Statutory_Fee_API.Get_Fee_Type_Db(company_, tax_info_table_(i).tax_code);            
         tax_info_table_(i).deductible_factor       := 1;
         tax_info_table_(i).non_ded_tax_curr_amount := 0;
      END LOOP;
   END IF;
   IF (company_ IS NOT NULL AND source_ref_type_db_ = Tax_Source_API.DB_INVOICE) THEN
      use_specific_rate_ := Invoice_API.Get_Specific_Rate_On_Invoice(company_, TO_NUMBER(source_ref1_));             
      tax_curr_rate_     := Invoice_API.Get_Tax_Curr_Rate(company_, TO_NUMBER(source_ref1_));
      
      FOR i IN 1 .. tax_info_table_.COUNT LOOP
         IF (use_specific_rate_ = 'TRUE') THEN
            IF (tax_info_table_(i).tax_method_db IN (Vat_Method_API.DB_INVOICE_ENTRY, Vat_Method_API.DB_FINAL_POSTING)) THEN
               IF set_use_specific_rate_ THEN
                  tax_info_table_(i).use_specific_rate := 'TRUE';
               END IF;
               tax_info_table_(i).curr_rate         := NVL(tax_curr_rate_, curr_rate_);        
            END IF;
         ELSE            
            tax_info_table_(i).curr_rate         := NVL(tax_curr_rate_, curr_rate_);
         END IF;
      END LOOP;
   END IF;
END Update_Tax_Info_Table___;


---- This method return actual currency rate and price conversion factor, from saved (calculated) currency rate.
PROCEDURE Get_Curr_Rate_And_Conv_Fact___ (
   currency_rate_           OUT NUMBER,
   currency_conv_factor_    OUT NUMBER,
   company_                 IN VARCHAR2,
   currency_code_           IN VARCHAR2,
   in_currency_rate_        IN NUMBER,
   customer_no_             IN VARCHAR2)
IS 
   currency_type_       VARCHAR2(10);
   ref_currency_code_   VARCHAR2(3);
   inverted_            VARCHAR2(5);
BEGIN
   IF (in_currency_rate_ IS NOT NULL) AND (in_currency_rate_ != 0) THEN
      currency_conv_factor_ := Currency_Code_API.Get_Conversion_Factor(company_, currency_code_);
      currency_type_        := Invoice_Library_API.Get_Default_Currency_Type(company_, 'CUSTOMER', customer_no_);
      ref_currency_code_    := Currency_Type_API.Get_Ref_Currency_Code(company_, currency_type_);
      inverted_             := Currency_Code_API.Get_Inverted(company_, ref_currency_code_);
      
      IF (inverted_ = Fnd_Boolean_API.DB_FALSE) THEN 
         -- Actual currency rate value should be currency_rate * currency_conv_factor, 
         -- since the saved currency rate values is the currency_rate/currency_conv_factor 
         currency_rate_ := in_currency_rate_ * currency_conv_factor_;
      ELSE
         --When 'Inverted Quotation' is TRUE of the currency rate type, 
         --the saved currency rate values is currency_conv_factor / currency_rate.  
         --To get the actual currency rate, price conversion factor should divide by saved currency rate. 
         currency_rate_ := currency_conv_factor_ / in_currency_rate_;
      END IF;
   END IF;
END Get_Curr_Rate_And_Conv_Fact___;

PROCEDURE Create_Ext_Tax_Param_In_Rec___ (
   ext_tax_param_in_rec_   OUT      External_Tax_System_Util_API.ext_tax_param_in_rec,
   tax_line_param_rec_     IN OUT   tax_line_param_rec,
   source_key_rec_         IN       Tax_Handling_Util_API.source_key_rec,
   sales_object_type_      IN       VARCHAR2,
   counter_                IN       NUMBER,
   attr_                   IN       VARCHAR2) 
IS
   source_pkg_             VARCHAR2(30);
   stmt_                   VARCHAR2(2000);
   source_ref1_            VARCHAR2(50);
   source_ref2_            VARCHAR2(50);
   source_ref3_            VARCHAR2(50);
   source_ref4_            VARCHAR2(50);   
   invoice_no_             NUMBER;
   line_total_curr_amount_ NUMBER;
   address1_               VARCHAR2(35);
   address2_               VARCHAR2(35);
   country_code_           VARCHAR2(2);
   city_                   VARCHAR2(35);
   state_                  VARCHAR2(35);
   zip_code_               VARCHAR2(35);
   county_                 VARCHAR2(35);
   in_city_                VARCHAR2(5);
   external_tax_info_attr_ VARCHAR2(2000);
   price_type_             VARCHAR2(20);  
   line_net_curr_amount_   NUMBER;
   customer_taxable_       VARCHAR2(5);
   tax_liability_type_db_  VARCHAR2(20);
   tax_source_object_rec_  Tax_Handling_Util_API.tax_source_object_rec;
   doc_address_id_         company_address_tab.address_id%TYPE;
   del_address_id_         company_address_tab.address_id%TYPE;
   comp_del_addr_          Company_Address_API.Public_Rec;
   comp_doc_addr_          Company_Address_API.Public_Rec;
   company_def_invoice_type_rec_ Company_Def_Invoice_Type_API.Public_Rec;
   inv_item_rec_           Customer_Order_Inv_Item_API.Public_Rec;
   invoice_id_             NUMBER;
   cust_tax_usage_type_    VARCHAR2(5);
   fetch_jurisdiction_code_      VARCHAR2(5);
   external_tax_calc_method_     VARCHAR2(50);
   -- gelr:br_external_tax_integration, begin
   acquisition_origin_     NUMBER;
   statistical_code_       VARCHAR2(15);
   -- gelr:br_external_tax_integration, end
   
BEGIN
   IF (source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE) THEN
      source_ref1_ := tax_line_param_rec_.company;
      source_ref2_ := source_key_rec_.source_ref1;
      source_ref3_ := source_key_rec_.source_ref2;
      source_ref4_ := '*'; 
      invoice_no_  := Invoice_API.Get_Invoice_No(tax_line_param_rec_.company,source_key_rec_.source_ref1);
   ELSE
      source_ref1_ := source_key_rec_.source_ref1;
      source_ref2_ := source_key_rec_.source_ref2;
      source_ref3_ := source_key_rec_.source_ref3;
      source_ref4_ := source_key_rec_.source_ref4;         
   END IF;

   source_pkg_  := Get_Source_Pkg___(source_key_rec_.source_ref_type);
   Assert_Sys.Assert_Is_Package(source_pkg_);
   -- Get the line address information and total net amount in base currency.
   stmt_  := 'BEGIN
                 '||source_pkg_||'.Get_Line_Address_Info(:address1, :address2, :country_code, :city, :state, :zip_code, :county, :in_city,
                                                         :rec_source_ref1, :rec_source_ref2, :rec_source_ref3, :rec_source_ref4, :company);
                  :line_total_curr_amount := '||source_pkg_||'.Get_Price_Total(:source_ref1, :source_ref2, :source_ref3, :source_ref4);
                  '||source_pkg_||'.Get_External_Tax_Info(:attr, :rec_source_ref1, :rec_source_ref2, :rec_source_ref3, :rec_source_ref4, :company);
              END;';
   @ApproveDynamicStatement(2020-07-09, NiDalk) 
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
                 IN  tax_line_param_rec_.company,
                 OUT line_total_curr_amount_,
                 IN  source_ref1_,
                 IN  source_ref2_,
                 IN  source_ref3_,
                 IN  source_ref4_,
                 OUT external_tax_info_attr_;

   IF (tax_line_param_rec_.free_of_charge_tax_basis IS NOT NULL AND tax_line_param_rec_.free_of_charge_tax_basis > 0) THEN
      Fetch_Free_Of_Charge_Info___(line_net_curr_amount_,
                                   price_type_,
                                   source_key_rec_,
                                   tax_line_param_rec_,
                                   attr_);
   END IF;

   tax_liability_type_db_ := NVL(tax_line_param_rec_.tax_liability_type_db, Client_SYS.Get_Item_Value('TAX_LIABILITY_TYPE_DB', external_tax_info_attr_)); 
   IF tax_liability_type_db_ IS NULL THEN
      tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_line_param_rec_.tax_liability, country_code_);
   END IF;
   IF tax_liability_type_db_ = Tax_Liability_Type_API.DB_TAXABLE THEN
      customer_taxable_:= 'TRUE';
   ELSE
      customer_taxable_:= 'FALSE';
   END IF;

   fetch_jurisdiction_code_ := Iso_Country_API.Get_Fetch_Jurisdiction_Code_Db(country_code_);
   tax_source_object_rec_ := Tax_Handling_Util_API.Create_Tax_Source_Object_Rec(tax_line_param_rec_.object_id, sales_object_type_, NULL, attr_);
   Fetch_Tax_Code_On_Object (tax_source_object_rec_, tax_line_param_rec_.contract);
 
   del_address_id_    := Site_API.Get_Delivery_Address(tax_line_param_rec_.contract);               
   IF (del_address_id_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOCODELAQTE: Please provide a delivery address for site :P1 in Company :P2', tax_line_param_rec_.contract, tax_line_param_rec_.company);
   END IF; 
   comp_del_addr_ := Company_Address_API.Get(tax_line_param_rec_.company, del_address_id_);               

   doc_address_id_    := Company_Address_Type_API.Get_Document_Address(tax_line_param_rec_.company);   
   IF (doc_address_id_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NODOCADRQTE: Please provide a default document address for Company :P1', tax_line_param_rec_.company);
   END IF;
   comp_doc_addr_ := Company_Address_API.Get(tax_line_param_rec_.company, doc_address_id_);

   external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(tax_line_param_rec_.company);
   -- gelr:br_external_tax_integration, Modified condition to include Avalara Brazil
   IF (tax_source_object_rec_.is_taxable_db = 'TRUE' AND customer_taxable_ = 'TRUE') AND (fetch_jurisdiction_code_ = 'TRUE'
      OR (fetch_jurisdiction_code_ = 'FALSE' AND tax_line_param_rec_.write_to_ext_tax_register = 'TRUE')
      OR (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL)) THEN

      ext_tax_param_in_rec_.contract              := tax_line_param_rec_.contract;
      ext_tax_param_in_rec_.company               := tax_line_param_rec_.company;
      ext_tax_param_in_rec_.identity              := tax_line_param_rec_.customer_no;
      ext_tax_param_in_rec_.identity_taxable      := customer_taxable_;              
      -- If the Prospect customer's customer group is empty, then we send '*' (no value) to Vertex
      IF (Customer_Info_API.Get_Customer_Category_Db(ext_tax_param_in_rec_.identity) = Customer_Category_API.DB_PROSPECT) THEN
         ext_tax_param_in_rec_.customer_group     := NVL(Cust_Ord_Customer_API.Get_Cust_Grp(tax_line_param_rec_.customer_no),'*');  
      ELSE
         ext_tax_param_in_rec_.customer_group     := Cust_Ord_Customer_API.Get_Cust_Grp(tax_line_param_rec_.customer_no);  
      END IF;
      ext_tax_param_in_rec_.object_id             := tax_line_param_rec_.object_id;
      ext_tax_param_in_rec_.object_taxable        := tax_source_object_rec_.is_taxable_db;
      ext_tax_param_in_rec_.object_group          := tax_source_object_rec_.object_group;                
      ext_tax_param_in_rec_.cust_del_address1     := address1_;
      ext_tax_param_in_rec_.cust_del_address2     := address2_;                 
      ext_tax_param_in_rec_.cust_del_zip_code     := zip_code_;               
      ext_tax_param_in_rec_.cust_del_city         := city_;               
      ext_tax_param_in_rec_.cust_del_state        := state_;               
      ext_tax_param_in_rec_.cust_del_county       := county_;
      ext_tax_param_in_rec_.cust_del_country      := country_code_;
      ext_tax_param_in_rec_.cust_del_addr_in_city := in_city_;
      ext_tax_param_in_rec_.comp_del_address1     := comp_del_addr_.address1;
      ext_tax_param_in_rec_.comp_del_address2     := comp_del_addr_.address2;                 
      ext_tax_param_in_rec_.comp_del_zip_code     := comp_del_addr_.zip_code;               
      ext_tax_param_in_rec_.comp_del_city         := comp_del_addr_.city;               
      ext_tax_param_in_rec_.comp_del_state        := comp_del_addr_.state;               
      ext_tax_param_in_rec_.comp_del_county       := comp_del_addr_.county;
      ext_tax_param_in_rec_.comp_del_country      := comp_del_addr_.country ;               
      ext_tax_param_in_rec_.comp_del_addr_in_city := comp_del_addr_.within_city_limit;               
      ext_tax_param_in_rec_.comp_doc_address1     := comp_doc_addr_.address1;
      ext_tax_param_in_rec_.comp_doc_address2     := comp_doc_addr_.address2;                 
      ext_tax_param_in_rec_.comp_doc_zip_code     := comp_doc_addr_.zip_code;               
      ext_tax_param_in_rec_.comp_doc_city         := comp_doc_addr_.city;               
      ext_tax_param_in_rec_.comp_doc_state        := comp_doc_addr_.state;               
      ext_tax_param_in_rec_.comp_doc_county       := comp_doc_addr_.county;
      ext_tax_param_in_rec_.comp_doc_country      := comp_doc_addr_.country; 
      ext_tax_param_in_rec_.comp_doc_addr_in_city := comp_doc_addr_.within_city_limit;               
      ext_tax_param_in_rec_.write_to_ext_tax_register := NVL(tax_line_param_rec_.write_to_ext_tax_register, 'FALSE');
      IF (source_key_rec_.source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_LINE) THEN
         ext_tax_param_in_rec_.object_desc     := Customer_Order_Line_API.Get_Catalog_Desc(source_key_rec_.source_ref1,source_key_rec_.source_ref2,source_key_rec_.source_ref3,source_key_rec_.source_ref4);
      ELSIF (source_key_rec_.source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE) THEN
         ext_tax_param_in_rec_.object_desc     := Customer_Order_Charge_API.Get_Charge_Type_Desc(ext_tax_param_in_rec_.contract, source_key_rec_.source_ref1, ext_tax_param_in_rec_.object_id);
      ELSIF (source_key_rec_.source_ref_type = Tax_Source_API.DB_ORDER_QUOTATION_LINE) THEN
         ext_tax_param_in_rec_.object_desc     := Order_Quotation_Line_API.Get_Catalog_Desc(source_key_rec_.source_ref1, source_key_rec_.source_ref2, source_key_rec_.source_ref3, source_key_rec_.source_ref4);
      ELSIF (source_key_rec_.source_ref_type = Tax_Source_API.DB_ORDER_QUOTATION_CHARGE) THEN
         ext_tax_param_in_rec_.object_desc     := Order_Quotation_Charge_API.Get_Charge_Type_Desc(ext_tax_param_in_rec_.contract, source_key_rec_.source_ref1, ext_tax_param_in_rec_.object_id);
      ELSIF (source_key_rec_.source_ref_type = Tax_Source_API.DB_RETURN_MATERIAL_LINE) THEN
         ext_tax_param_in_rec_.object_desc     := Return_Material_Line_API.Get_Catalog_Desc(source_key_rec_.source_ref1, source_key_rec_.source_ref2);
      ELSIF (source_key_rec_.source_ref_type = Tax_Source_API.DB_RETURN_MATERIAL_CHARGE) THEN
         ext_tax_param_in_rec_.object_desc     := Return_Material_Charge_API.Get_Charge_Type_Desc(ext_tax_param_in_rec_.contract, source_key_rec_.source_ref1, ext_tax_param_in_rec_.object_id);
      ELSIF (source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE) THEN
         inv_item_rec_ := Customer_Order_Inv_Item_API.Get(ext_tax_param_in_rec_.company, TO_NUMBER(source_key_rec_.source_ref1), TO_NUMBER(source_key_rec_.source_ref2));
         ext_tax_param_in_rec_.object_desc     := inv_item_rec_.description;
      END IF;

      cust_tax_usage_type_ := Client_SYS.Get_Item_Value('CUSTOMER_TAX_USAGE_TYPE',attr_);
      ext_tax_param_in_rec_.cust_usage_type := NVL(cust_tax_usage_type_,Get_Cust_Tax_Usage_Type(source_key_rec_,ext_tax_param_in_rec_.identity,ext_tax_param_in_rec_.company));

      IF (tax_line_param_rec_.free_of_charge_tax_basis IS NOT NULL AND tax_line_param_rec_.free_of_charge_tax_basis > 0) THEN
         ext_tax_param_in_rec_.taxable_amount := NVL(line_net_curr_amount_, line_total_curr_amount_);
      ELSE
         ext_tax_param_in_rec_.taxable_amount := NVL(tax_line_param_rec_.net_curr_amount, line_total_curr_amount_);
      END IF;
      ext_tax_param_in_rec_.quantity              := NVL(NVL(tax_line_param_rec_.quantity, Client_SYS.Get_Item_Value('QUANTITY', external_tax_info_attr_)), 1);

      IF (source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE) THEN
         ext_tax_param_in_rec_.invoice_no       := invoice_no_||'-'||Client_SYS.Get_Item_Value('POS', external_tax_info_attr_); 
         ext_tax_param_in_rec_.invoice_date     := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('INVOICE_DATE', external_tax_info_attr_));

         ext_tax_param_in_rec_.invoice_id     := source_key_rec_.source_ref1;  
         ext_tax_param_in_rec_.item_id        := source_key_rec_.source_ref2;
         ext_tax_param_in_rec_.counter        := counter_;
      END IF; 

      ext_tax_param_in_rec_.avalara_tax_code := Sales_Part_Ext_Tax_Params_API.Get_Avalara_Tax_Code(ext_tax_param_in_rec_.contract, ext_tax_param_in_rec_.object_id);
      IF (source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE) THEN
         Customer_Order_Inv_Head_Api.Get_Debit_Invoice_Info(ext_tax_param_in_rec_.invoice_type, ext_tax_param_in_rec_.number_ref, ext_tax_param_in_rec_.series_ref, ext_tax_param_in_rec_.company, ext_tax_param_in_rec_.invoice_id);
         company_def_invoice_type_rec_    := Company_Def_Invoice_Type_API.Get(ext_tax_param_in_rec_.company);

         IF (ext_tax_param_in_rec_.number_ref IS NOT NULL AND ext_tax_param_in_rec_.invoice_type IN ('CUSTORDCRE', 'CUSTCOLCRE', company_def_invoice_type_rec_.def_co_cor_inv_type, company_def_invoice_type_rec_.def_col_cor_inv_type)) THEN
            invoice_id_                               := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(ext_tax_param_in_rec_.company, ext_tax_param_in_rec_.number_ref, ext_tax_param_in_rec_.series_ref);
            ext_tax_param_in_rec_.org_invoice_date    := Customer_Order_Inv_Head_API.Get_Invoice_Date(ext_tax_param_in_rec_.company, invoice_id_);
            ext_tax_param_in_rec_.corr_credit_invoice := TRUE;
            IF (Client_SYS.Get_Item_Value('PREL_UPDATE_ALLOWED', external_tax_info_attr_) = 'FALSE') THEN 
               ext_tax_param_in_rec_.tax_date := ext_tax_param_in_rec_.org_invoice_date;
            END IF;
         END IF;
      END IF;

      -- gelr:br_external_tax_integration, begin
      IF (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN
         acquisition_origin_ := Client_SYS.Get_Item_Value('ACQUISITION_ORIGIN', attr_);
         statistical_code_   := Client_SYS.Get_Item_Value('STATISTICAL_CODE',   attr_);
         
         ext_tax_param_in_rec_.avalara_brazil_specific.ship_addr_no            := Client_SYS.Get_Item_Value('SHIP_ADDR_NO',            external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.doc_addr_no             := Client_SYS.Get_Item_Value('DOC_ADDR_NO',             external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.invoice_number          := Client_SYS.Get_Item_Value('INVOICE_NUMBER',          external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.invoice_serial          := Client_SYS.Get_Item_Value('INVOICE_SERIAL',          external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.document_code           := Client_SYS.Get_Item_Value('DOCUMENT_CODE',           external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.catalog_no              := Client_SYS.Get_Item_Value('CATALOG_NO',              external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.sale_unit_price         := Client_SYS.Get_Item_Value('SALE_UNIT_PRICE',         external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.line_taxed_discount     := Client_SYS.Get_Item_Value('LINE_TAXED_DISCOUNT',     external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.external_use_type       := Client_SYS.Get_Item_Value('EXTERNAL_USE_TYPE',       external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.business_transaction_id := Client_SYS.Get_Item_Value('BUSINESS_TRANSACTION_ID', external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.order_no                := Client_SYS.Get_Item_Value('ORDER_NO',                external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.line_no                 := Client_SYS.Get_Item_Value('LINE_NO',                 external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.avalara_tax_code        := Client_SYS.Get_Item_Value('AVALARA_TAX_CODE',        external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.statistical_code        := NVL(statistical_code_, Client_SYS.Get_Item_Value('STATISTICAL_CODE', external_tax_info_attr_));
         ext_tax_param_in_rec_.avalara_brazil_specific.cest_code               := Client_SYS.Get_Item_Value('CEST_CODE',               external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.sales_unit_meas         := Client_SYS.Get_Item_Value('SALES_UNIT_MEAS',         external_tax_info_attr_);
         ext_tax_param_in_rec_.avalara_brazil_specific.acquisition_origin      := NVL(acquisition_origin_, Client_SYS.Get_Item_Value('ACQUISITION_ORIGIN', external_tax_info_attr_));
         ext_tax_param_in_rec_.avalara_brazil_specific.product_type_classif    := Client_SYS.Get_Item_Value('PRODUCT_TYPE_CLASSIF',    external_tax_info_attr_);
      END IF;
      -- gelr:br_external_tax_integration, end
   END IF;
   
   
END Create_Ext_Tax_Param_In_Rec___;

PROCEDURE Create_Recal_Tax_Line_Param_Rec___(
   tax_line_param_rec_         OUT tax_line_param_rec,
   is_rebate_invoice_          OUT BOOLEAN, 
   company_                    IN  VARCHAR2,
   copy_from_source_key_rec_   IN  Tax_Handling_Util_API.source_key_rec,
   copy_to_source_key_rec_     IN  Tax_Handling_Util_API.source_key_rec,
   refetch_curr_rate_          IN  VARCHAR2) 
IS
   source_pkg_          VARCHAR2(30);
   stmt_                VARCHAR2(2000);
   source_ref1_         VARCHAR2(20);
   source_ref2_         VARCHAR2(20);
   source_ref3_         VARCHAR2(20);
   source_ref4_         VARCHAR2(20); 
   db_invoice_          VARCHAR2(7) := Tax_Source_API.DB_INVOICE;
   db_return_material_line_   VARCHAR2(20) := Tax_Source_API.DB_RETURN_MATERIAL_LINE;
   db_return_material_charge_ VARCHAR2(22) := Tax_Source_API.DB_RETURN_MATERIAL_CHARGE;
   curr_rate_calc_date_ DATE;
   inv_head_rec_        Customer_Order_Inv_Head_API.Public_Rec; 
   rma_line_rec_        Return_Material_Line_API.Public_Rec;
   rma_charge_rec_      Return_Material_Charge_API.Public_Rec;
   ivc_id_              NUMBER;
   para_curr_rounding_  NUMBER;
   parallel_curr_rate_  NUMBER;
   para_conv_factor_    NUMBER;
   invoice_type_        VARCHAR2(20);
   reb_cre_inv_type_    VARCHAR2(20);
   compfin_rec_         Company_Finance_API.Public_Rec;
   
   CURSOR get_charge_debit_invoice(company_ VARCHAR2, order_no_ VARCHAR2, charge_seq_no_ NUMBER)  IS   
      SELECT invoice_id
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company       = company_
      AND    order_no      = order_no_
      AND    charge_seq_no = charge_seq_no_
      AND    invoice_type  = 'CUSTORDDEB';
BEGIN
   source_pkg_    := Get_Source_Pkg___(copy_from_source_key_rec_.source_ref_type); 
   Assert_Sys.Assert_Is_Package(source_pkg_);
   stmt_  := 'BEGIN :tax_line_param_rec := '||source_pkg_||'.Fetch_Tax_Line_Param(:company, :source_ref1,
                                           :source_ref2, :source_ref3, :source_ref4); END;';

   IF ((copy_to_source_key_rec_.source_ref_type = db_invoice_) AND     
       (Invoice_API.Is_Rate_Correction_Invoice(company_, copy_to_source_key_rec_.source_ref1) = 'CORRECTION_INV')) THEN
      source_ref1_ := copy_to_source_key_rec_.source_ref1;
      source_ref2_ := copy_to_source_key_rec_.source_ref2;
      source_ref3_ := copy_to_source_key_rec_.source_ref3;
      source_ref4_ := copy_to_source_key_rec_.source_ref4;
   ELSE
      source_ref1_ := copy_from_source_key_rec_.source_ref1;
      source_ref2_ := copy_from_source_key_rec_.source_ref2;
      source_ref3_ := copy_from_source_key_rec_.source_ref3;
      source_ref4_ := copy_from_source_key_rec_.source_ref4;               
   END IF;      
   
   @ApproveDynamicStatement(2020-07-08,NiDalk) 
   EXECUTE IMMEDIATE stmt_
      USING  OUT tax_line_param_rec_,
             IN  company_,
             IN  source_ref1_,
             IN  source_ref2_,
             IN  source_ref3_,
             IN  source_ref4_;
   
   IF refetch_curr_rate_ = 'TRUE' AND tax_line_param_rec_.currency_code != Company_Finance_API.Get_Currency_Code(company_) THEN
      IF copy_to_source_key_rec_.source_ref_type = db_invoice_ THEN
         IF Company_Invoice_Info_API.Get_Out_Inv_Curr_Rate_Base_Db(company_) = Base_Date_API.DB_DELIVERY_DATE AND copy_from_source_key_rec_.source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_LINE THEN
            Customer_Order_Inv_Head_API.Get_Max_Deliv_Date(curr_rate_calc_date_, company_, copy_to_source_key_rec_.source_ref1);
         END IF;
         IF curr_rate_calc_date_ IS NULL THEN
            curr_rate_calc_date_ := Customer_Order_Inv_Head_API.Get_Invoice_Date(company_, copy_to_source_key_rec_.source_ref1);
         END IF;
      ELSE
         curr_rate_calc_date_ := tax_line_param_rec_.planned_ship_date;
      END IF;

      Currency_Rate_API.Get_Currency_Rate(tax_line_param_rec_.conv_factor, 
                                          tax_line_param_rec_.currency_rate,
                                          company_,
                                          tax_line_param_rec_.currency_code,
                                          Invoice_Library_API.Get_Default_Currency_Type(company_, 'CUSTOMER', tax_line_param_rec_.customer_no),
                                          curr_rate_calc_date_);

      -- Assign currency_rateconversion_factor as currency rate to get the correct currency rate and 
      -- conversion factor by Get_Curr_Rate_And_Conv_Fact___.                                    
      tax_line_param_rec_.currency_rate := tax_line_param_rec_.currency_rate / tax_line_param_rec_.conv_factor;

   ELSIF (refetch_curr_rate_ = 'FALSE') THEN 
      IF (copy_from_source_key_rec_.source_ref_type = db_invoice_) THEN
         IF (copy_to_source_key_rec_.source_ref_type = db_return_material_line_)THEN
            rma_line_rec_ := Return_Material_Line_API.Get(copy_to_source_key_rec_.source_ref1,
                                                                      copy_to_source_key_rec_.source_ref2);
            tax_line_param_rec_.currency_rate := rma_line_rec_.currency_rate;
         ELSIF (copy_to_source_key_rec_.source_ref_type = db_return_material_charge_)THEN
            rma_charge_rec_ := Return_Material_Charge_API.Get(copy_to_source_key_rec_.source_ref1,
                                                                      copy_to_source_key_rec_.source_ref2);
            tax_line_param_rec_.currency_rate := rma_charge_rec_.currency_rate;
         END IF;
      ELSIF (copy_from_source_key_rec_.source_ref_type = db_return_material_line_) THEN 
         rma_line_rec_ := Return_Material_Line_API.Get(copy_from_source_key_rec_.source_ref1,
                                                                   copy_from_source_key_rec_.source_ref2);
         IF (rma_line_rec_.debit_invoice_no IS NOT NULL) THEN
            ivc_id_ := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, rma_line_rec_.debit_invoice_no, rma_line_rec_.debit_invoice_series_id);
            inv_head_rec_ := Customer_Order_Inv_Head_API.Get(company_, ivc_id_);
            tax_line_param_rec_.currency_rate := inv_head_rec_.curr_rate;
         END IF;
      ELSIF (copy_from_source_key_rec_.source_ref_type = db_return_material_charge_) THEN 
         rma_charge_rec_ := Return_Material_Charge_API.Get(copy_from_source_key_rec_.source_ref1,
                                                                       copy_from_source_key_rec_.source_ref2);
         IF (rma_charge_rec_.order_no IS NOT NULL) THEN         
            OPEN  get_charge_debit_invoice(company_, rma_charge_rec_.order_no, rma_charge_rec_.sequence_no);
            FETCH get_charge_debit_invoice INTO ivc_id_;
            CLOSE get_charge_debit_invoice;

            IF (ivc_id_ IS NOT NULL) THEN
               inv_head_rec_ := Customer_Order_Inv_Head_API.Get(company_, ivc_id_);
               tax_line_param_rec_.currency_rate := inv_head_rec_.curr_rate;
            END IF;               
         END IF;                                                                         
      END IF;
   END IF;

   is_rebate_invoice_ := FALSE;
   
   IF (copy_to_source_key_rec_.source_ref_type = db_invoice_)THEN
      --fetch parallel currency specific values
      invoice_type_ := Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, copy_to_source_key_rec_.source_ref1);
      reb_cre_inv_type_ := Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(company_);
      IF (invoice_type_ = reb_cre_inv_type_) THEN
         is_rebate_invoice_ := TRUE;
      END IF;
      compfin_rec_ := Company_Finance_API.Get(company_);
      IF compfin_rec_.parallel_acc_currency IS NOT NULL THEN 
         para_curr_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, compfin_rec_.parallel_acc_currency);
         parallel_curr_rate_ := Invoice_API.Get_Parallel_Curr_Rate(company_, copy_to_source_key_rec_.source_ref1);
         para_conv_factor_   := Invoice_API.Get_Parallel_Div_Factor(company_,copy_to_source_key_rec_.source_ref1);
         tax_line_param_rec_.calculate_para_amount := 'TRUE';
         tax_line_param_rec_.para_curr_rate        := parallel_curr_rate_;
         tax_line_param_rec_.para_conv_factor      := para_conv_factor_;
         tax_line_param_rec_.para_curr_rounding    := para_curr_rounding_;
      ELSE
         tax_line_param_rec_.calculate_para_amount := 'FALSE';
      END IF;
   END IF;
      
END Create_Recal_Tax_Line_Param_Rec___;

PROCEDURE Save_Tax_Lines___ (
   tax_info_table_            IN  Tax_Handling_Util_API.tax_information_table,
   copy_from_source_key_rec_  IN  Tax_Handling_Util_API.source_key_rec,
   copy_to_source_key_rec_    IN  Tax_Handling_Util_API.source_key_rec,
   tax_line_param_rec_        IN  tax_line_param_rec,
   company_                   IN  VARCHAR2,
   is_rebate_invoice_         IN  BOOLEAN)
IS
   creator_                   VARCHAR2(30);
   calc_base_                 VARCHAR2(20);
   company_bearing_tax_amnt_  NUMBER;
   ivc_id_                    NUMBER;
   inv_item_rec_              Customer_Order_Inv_Item_API.Public_Rec;
   db_invoice_                VARCHAR2(7) := Tax_Source_API.DB_INVOICE;
   db_return_material_line_   VARCHAR2(20) := Tax_Source_API.DB_RETURN_MATERIAL_LINE;
   rma_line_rec_              Return_Material_Line_API.Public_Rec;
   external_tax_calc_method_  VARCHAR2(50);
BEGIN
   -- Exclude tax code mandatory validation for rebate credit invoice.
   IF (tax_info_table_.COUNT = 0) AND (NOT is_rebate_invoice_) THEN 
      IF ((copy_from_source_key_rec_.source_ref4 IN ('*', '0', '-1')) AND 
         (Sales_Part_API.Get_Taxable_Db(tax_line_param_rec_.contract, tax_line_param_rec_.object_id) = 'TRUE')) THEN 
         Tax_Handling_Util_API.Validate_Tax_Code_Mandatory(tax_line_param_rec_.company, 'CUSTOMER_TAX'); 
      END IF;
   END IF;
   
   IF (tax_info_table_.COUNT > 0) THEN
      IF (copy_to_source_key_rec_.source_ref_type = db_invoice_) THEN
         Source_Tax_Item_Invoic_API.Remove_Tax_Items( tax_line_param_rec_.company,
                                                      copy_to_source_key_rec_.source_ref_type,
                                                      copy_to_source_key_rec_.source_ref1,
                                                      copy_to_source_key_rec_.source_ref2,
                                                      copy_to_source_key_rec_.source_ref3,
                                                      copy_to_source_key_rec_.source_ref4,
                                                      copy_to_source_key_rec_.source_ref5);
         Source_Tax_Item_Invoic_API.Create_Tax_Items(tax_line_param_rec_.company, 'FALSE', 'TRUE', copy_to_source_key_rec_, tax_info_table_); 
         creator_   := Invoice_API.Get_Creator(tax_line_param_rec_.company, TO_NUMBER(copy_to_source_key_rec_.source_ref1));
         calc_base_ := Tax_Handling_Invoic_Util_API.Get_Calc_Base_On_Invoice(tax_line_param_rec_.company, NULL, creator_, TO_NUMBER(copy_to_source_key_rec_.source_ref1));
         IF (copy_from_source_key_rec_.source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_LINE) THEN
            company_bearing_tax_amnt_ := Customer_Order_Line_API.Get_Comp_Bearing_Tax_Amount(copy_from_source_key_rec_.source_ref1,
                                                                                 copy_from_source_key_rec_.source_ref2,
                                                                                 copy_from_source_key_rec_.source_ref3,
                                                                                 TO_NUMBER(copy_from_source_key_rec_.source_ref4));
         END IF;
         -- case for creating correction/credit invoice from debit invoice or from RMA
         IF (copy_from_source_key_rec_.source_ref_type = db_invoice_) THEN
            inv_item_rec_ := Customer_Order_Inv_Item_API.Get(company_, TO_NUMBER(copy_to_source_key_rec_.source_ref1), TO_NUMBER(copy_to_source_key_rec_.source_ref2));
            company_bearing_tax_amnt_ := inv_item_rec_.base_comp_bearing_tax_amt;
         END IF;         
         IF (copy_from_source_key_rec_.source_ref_type = db_return_material_line_) THEN
            rma_line_rec_ := Return_Material_Line_API.Get(copy_from_source_key_rec_.source_ref1, copy_from_source_key_rec_.source_ref2);
            IF (rma_line_rec_.debit_invoice_no IS NOT NULL) THEN
               ivc_id_ := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, rma_line_rec_.debit_invoice_no, rma_line_rec_.debit_invoice_series_id);
               inv_item_rec_ := Customer_Order_Inv_Item_API.Get(company_, ivc_id_, rma_line_rec_.debit_invoice_item_id);
               company_bearing_tax_amnt_ := inv_item_rec_.base_comp_bearing_tax_amt;
            ELSE
               company_bearing_tax_amnt_ := Customer_Order_Line_API.Get_Comp_Bearing_Tax_Amount(rma_line_rec_.order_no,
                                                                                                rma_line_rec_.line_no,
                                                                                                rma_line_rec_.rel_no,
                                                                                                rma_line_rec_.line_item_no);
            END IF;
         END IF;         
         -- In company paying tax scenario for FOC goods, no need to modify the invoice line tax info.
         IF (company_bearing_tax_amnt_ IS NULL) THEN 
            Invoice_Item_API.Modify_Line_Level_Tax_Info(tax_line_param_rec_.company, calc_base_, creator_, NULL, TO_NUMBER(copy_to_source_key_rec_.source_ref1), TO_NUMBER(copy_to_source_key_rec_.source_ref2));                      
         END IF;
      ELSE
         Source_Tax_Item_Order_API.Remove_Tax_Items( tax_line_param_rec_.company,
                                                     copy_to_source_key_rec_.source_ref_type,
                                                     copy_to_source_key_rec_.source_ref1,
                                                     copy_to_source_key_rec_.source_ref2,
                                                     copy_to_source_key_rec_.source_ref3,
                                                     copy_to_source_key_rec_.source_ref4,
                                                     copy_to_source_key_rec_.source_ref5);

         Source_Tax_Item_Order_API.Create_Tax_Items(tax_info_table_, 
                                                    copy_to_source_key_rec_, 
                                                    tax_line_param_rec_.company);         

         IF (copy_to_source_key_rec_.source_ref_type != db_invoice_) THEN                               
            Modify_Source_Tax_Info___(copy_to_source_key_rec_,
                                      tax_line_param_rec_.tax_code, 
                                      tax_line_param_rec_.tax_class_id,
                                      tax_line_param_rec_.tax_calc_structure_id);
         END IF;
      END IF;
   ELSE
      external_tax_calc_method_     := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(tax_line_param_rec_.company);
      
      -- Update tax values line when the tax items are removed when updating
      IF (copy_to_source_key_rec_.source_ref_type = db_invoice_) AND external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED  AND 
         NVL(Invoice_Item_API.Get_Vat_Curr_Amount(tax_line_param_rec_.company, TO_NUMBER(copy_to_source_key_rec_.source_ref1), TO_NUMBER(copy_to_source_key_rec_.source_ref2)), 0)  > 0 THEN 
         creator_   := Invoice_API.Get_Creator(tax_line_param_rec_.company, TO_NUMBER(copy_to_source_key_rec_.source_ref1));
         calc_base_ := Tax_Handling_Invoic_Util_API.Get_Calc_Base_On_Invoice(tax_line_param_rec_.company, NULL, creator_, TO_NUMBER(copy_to_source_key_rec_.source_ref1));
         Invoice_Item_API.Modify_Line_Level_Tax_Info(tax_line_param_rec_.company, calc_base_, creator_, NULL, TO_NUMBER(copy_to_source_key_rec_.source_ref1), TO_NUMBER(copy_to_source_key_rec_.source_ref2));
      END IF;
   END IF;
END Save_Tax_Lines___;

-------------------- IMPLEMENTATION METHODS FOR AVALARA TAX BRAZIL ----------------

-- gelr:br_external_tax_integration, begin
@IgnoreUnitTest DMLOperation
PROCEDURE Update_Citation_Information___ (
   source_key_rec_     IN Tax_Handling_Util_API.source_key_rec,
   citation_info_      IN VARCHAR2)
IS
   attr_               VARCHAR2(4000);
BEGIN 
   attr_ := NULL;
   Client_SYS.Add_To_Attr('NOTE_TEXT', citation_info_, attr_);
   Customer_Order_Line_API.Modify(attr_, source_key_rec_.source_ref1, source_key_rec_.source_ref2, source_key_rec_.source_ref3, source_key_rec_.source_ref4);
   
END Update_Citation_Information___;

@IgnoreUnitTest DMLOperation
PROCEDURE Update_Warning_Summary___ (
   order_no_             IN VARCHAR2,
   warning_summary_      IN VARCHAR2)
IS
   attr_               VARCHAR2(2000);
   info_               VARCHAR2(2000);
BEGIN 
   attr_ := NULL;
   Client_SYS.Add_To_Attr('NOTE_TEXT', warning_summary_, attr_);
   Customer_Order_API.Modify(info_, attr_, order_no_);   
END Update_Warning_Summary___;
-- gelr:br_external_tax_integration, end

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------------------------------------------------------------------
-- Check_Eu_Country__
--    This method returns Y, if the country code is EL or it is a Europian
--    union member country.
--    Corresponding tax id number for Greece starts with EL.
--------------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Check_Eu_Country__(
   country_code_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   --For Greece tax id number starts with EL. For other countries it starts with country code.
   IF (country_code_ = 'EL') THEN
      RETURN 'Y';
   ELSE
      RETURN Eu_Member_API.Encode(Iso_Country_API.Get_Eu_Member(country_code_));
   END IF;
END Check_Eu_Country__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-------------------- PUBLIC METHODS FOR FETCHING TAX CODE INFO --------------

-- Get_Tax_Info_For_Sales_Object
--   Fetch default tax code and taxable attributes for sales objects.
PROCEDURE Get_Tax_Info_For_Sales_Object(
   tax_code_   OUT VARCHAR2,
   taxable_db_ OUT VARCHAR2,
   company_    IN  VARCHAR2 )
IS
BEGIN
   taxable_db_ := Company_Tax_Discom_Info_API.Get_Order_Taxable_Db(company_);  
   
   IF (taxable_db_ = 'TRUE') THEN
      tax_code_ := Company_Tax_Discom_Info_API.Get_Tax_Code(company_);
   ELSE
      tax_code_ := Company_Tax_Discom_Info_API.Get_Tax_Free_Tax_Code(company_);
   END IF;
END Get_Tax_Info_For_Sales_Object;


-- Fetch_Tax_Code_On_Object
--    Fetch tax codes from sales part or Charge type.
PROCEDURE Fetch_Tax_Code_On_Object (
   tax_source_object_rec_  IN OUT Tax_Handling_Util_API.tax_source_object_rec,  
   contract_               IN VARCHAR2)
IS
   sales_part_rec_            Sales_Part_API.Public_Rec;
   sales_charge_type_rec_     Sales_Charge_Type_API.Public_Rec;
BEGIN
   IF (tax_source_object_rec_.object_id IS NOT NULL) THEN
      IF (tax_source_object_rec_.object_type = 'SALES_PART') THEN
         sales_part_rec_                        := Sales_Part_API.Get(contract_, tax_source_object_rec_.object_id);         
         tax_source_object_rec_.is_taxable_db   := sales_part_rec_.taxable;
         tax_source_object_rec_.object_tax_code := sales_part_rec_.tax_code;
         tax_source_object_rec_.object_group    := sales_part_rec_.catalog_group;
         IF (tax_source_object_rec_.object_tax_code IS NULL) THEN
            tax_source_object_rec_.object_tax_class_id := sales_part_rec_.tax_class_id;       
         END IF;  
      END IF;
      
      IF (tax_source_object_rec_.object_type = 'CHARGE_TYPE') THEN
         sales_charge_type_rec_                 := Sales_Charge_Type_API.Get(contract_, tax_source_object_rec_.object_id);         
         tax_source_object_rec_.is_taxable_db   := sales_charge_type_rec_.taxable;
         tax_source_object_rec_.object_tax_code := sales_charge_type_rec_.tax_code;
         tax_source_object_rec_.object_group    := sales_charge_type_rec_.charge_group;
         IF (tax_source_object_rec_.object_tax_code IS NULL) THEN
            tax_source_object_rec_.object_tax_class_id := sales_charge_type_rec_.tax_class_id;       
         END IF;  
      END IF;
      IF (tax_source_object_rec_.object_type = 'REBATE_TYPE') THEN        
         tax_source_object_rec_.is_taxable_db   := 'TRUE';
      END IF;
   END IF;
END Fetch_Tax_Code_On_Object;

-------------------- PUBLIC METHODS FOR FETCHING TAX RELATED INFO -----------

--Get_Saved_Tax_Detail
-- Returns all the saved tax information related to the correspond source ref type.
FUNCTION Get_Saved_Tax_Detail (
   source_ref_type_    IN VARCHAR2,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref5_        IN VARCHAR2,
   tax_line_param_rec_ IN tax_line_param_rec)RETURN Tax_Handling_Util_API.tax_information_table
IS
   source_key_rec_              Tax_Handling_Util_API.source_key_rec;             
   tax_info_table_              Tax_Handling_Util_API.tax_information_table;
   modified_tax_line_param_rec_ tax_line_param_rec;
   external_tax_calc_method_    VARCHAR2(50);
   sales_object_type_           VARCHAR2(30);
   multiple_tax_                VARCHAR2(20);
   attr_                        VARCHAR2(2000);      
BEGIN
   source_key_rec_  := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_,
                                                                   source_ref1_, 
                                                                   source_ref2_, 
                                                                   source_ref3_, 
                                                                   source_ref4_,
                                                                   source_ref5_,
                                                                   NULL);
   modified_tax_line_param_rec_ := tax_line_param_rec_;
   sales_object_type_ := Get_Sales_Object_Type___(modified_tax_line_param_rec_.company, source_key_rec_);
   Add_Tax_Info_To_Rec___(modified_tax_line_param_rec_, source_key_rec_, attr_);
   external_tax_calc_method_    := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(modified_tax_line_param_rec_.company);
   IF (external_tax_calc_method_ = 'NOT_USED') THEN      
      Fetch_Tax_Codes___(multiple_tax_,
                         tax_info_table_,
                         modified_tax_line_param_rec_,
                         source_key_rec_ ,
                         sales_object_type_ ,
                         'FALSE',
                         attr_);
   END IF;
   RETURN tax_info_table_;
END Get_Saved_Tax_Detail;


-- Get_Taxes_With_No_Liab_Date
--   Return all tax codes defined with Tax Liability Date type 'Manual'.
--   but no tax liability date(s) are specified for the invoice lines.
@UncheckedAccess
FUNCTION Get_Taxes_With_No_Liab_Date (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   source_ref_type_db_    CONSTANT VARCHAR2(100) := Tax_Source_API.DB_INVOICE;
   
   CURSOR get_all_tax_codes IS
      SELECT DISTINCT t.tax_code, i.invoice_type
         FROM  SOURCE_TAX_ITEM_BASE_PUB t, CUSTOMER_ORDER_INV_ITEM i
         WHERE i.invoice_id = invoice_id_
         AND   i.company    = company_
         AND   i.man_tax_liability_date IS NULL
         AND   t.company    = i.company
         AND   t.source_ref1 = TO_CHAR(i.invoice_id)
         AND   t.source_ref2 = TO_CHAR(i.item_id)
         AND   t.source_ref3 = '*'
         AND   t.source_ref4 = '*'
         AND   t.source_ref5 = '*'
         AND   t.source_ref_type_db = source_ref_type_db_;

   tax_codes_line_ VARCHAR2(2000);
BEGIN
   FOR tax_code_rec_ IN get_all_tax_codes LOOP
      IF (Customer_Order_Inv_Item_API.Is_Manual_Liablty_Taxcode(company_, tax_code_rec_.tax_code,tax_code_rec_.invoice_type) = 'TRUE') THEN
         tax_codes_line_ := tax_codes_line_ || tax_code_rec_.tax_code||', ';
      END IF;
   END LOOP;
   IF tax_codes_line_ IS NOT NULL THEN
      tax_codes_line_ := RTRIM(tax_codes_line_,', ');
   END IF;
   RETURN tax_codes_line_;
END Get_Taxes_With_No_Liab_Date;


-- Get_Single_Occ_Data
--    Returns the address flag and the tax free tax code specified
--    in the customer order address and quotation address tab.
PROCEDURE  Get_Single_Occ_Data (
   addr_flag_         OUT VARCHAR2,
   tax_free_tax_code_ OUT VARCHAR2,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_    IN VARCHAR2,
   identity_rec_       IN Tax_Handling_Util_API.identity_rec)
IS
   contract_           VARCHAR2(5);
BEGIN  
   IF (source_ref_type_ IN (Tax_Source_API.DB_CUSTOMER_ORDER_LINE, Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE)) THEN
      contract_ := Customer_Order_API.Get_Contract(source_ref1_);
      IF (source_ref2_ IS NULL) THEN 
         addr_flag_ := Customer_Order_API.Get_Addr_Flag_Db(source_ref1_);
      ELSE
         IF (source_ref_type_ = Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE) THEN
            addr_flag_ := Customer_Order_Charge_API.Get_Connected_Addr_Flag(source_ref1_, source_ref2_);
         ELSE
            addr_flag_ := Customer_Order_Line_API.Get_Addr_Flag_Db(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
         END IF;
      END IF; 
      IF (addr_flag_ = 'Y') THEN 
         tax_free_tax_code_ := Customer_Order_Address_API.Get_Vat_Free_Vat_Code(source_ref1_);   
      END IF;
   ELSIF (source_ref_type_ IN (Tax_Source_API.DB_ORDER_QUOTATION_LINE, Tax_Source_API.DB_ORDER_QUOTATION_CHARGE)) THEN 
      contract_ := Order_Quotation_API.Get_Contract(source_ref1_);
      IF (source_ref2_ IS NULL) THEN 
         addr_flag_ := Order_Quotation_API.Get_Single_Occ_Addr_Flag(source_ref1_);
      ELSE
         IF (source_ref_type_ = Tax_Source_API.DB_ORDER_QUOTATION_CHARGE) THEN
            addr_flag_ := Order_Quotation_Charge_API.Get_Connected_Addr_Flag(source_ref1_, source_ref2_);
         ELSE
            addr_flag_ := Order_Quotation_Line_API.Get_Single_Occ_Addr_Flag(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
         END IF;
      END IF; 
      IF (addr_flag_ = 'TRUE') THEN
         addr_flag_ := 'Y';
      END IF;
      IF (addr_flag_ = 'Y') THEN 
         tax_free_tax_code_ := Order_Quotation_API.Get_Vat_Free_Vat_Code(source_ref1_);   
      END IF;
   ELSIF (source_ref_type_ IN (Tax_Source_API.DB_RETURN_MATERIAL_LINE, Tax_Source_API.DB_RETURN_MATERIAL_CHARGE)) THEN
      contract_ := Return_Material_API.Get_Contract(source_ref1_);
   ELSIF (source_ref_type_ IN (Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE)) THEN
      contract_ := Shipment_API.Get_Contract(source_ref1_);
   END IF;
   -- Get tax_free_tax_code_ from defaults when there is NULL
   IF(tax_free_tax_code_ IS NULL) THEN
      tax_free_tax_code_ := Customer_Tax_Free_Tax_Code_API.Get_Tax_Free_Tax_Code(identity_rec_.identity, identity_rec_.delivery_address_id, Site_API.Get_Company(contract_), identity_rec_.supply_country_db, identity_rec_.delivery_type);
   END IF;   
END Get_Single_Occ_Data;


-------------------- PUBLIC METHODS FOR CALCULATIONS ------------------------

PROCEDURE Get_Amounts (   
   line_tax_dom_amount_          OUT NUMBER,
   line_net_dom_amount_          OUT NUMBER,
   line_gross_dom_amount_        OUT NUMBER,
   line_tax_curr_amount_         OUT NUMBER,
   line_net_curr_amount_      IN OUT NUMBER,
   line_gross_curr_amount_    IN OUT NUMBER,
   tax_calc_structure_id_     IN OUT VARCHAR2,
   source_ref1_               IN     VARCHAR2,
   source_ref2_               IN     VARCHAR2,
   source_ref3_               IN     VARCHAR2,
   source_ref4_               IN     VARCHAR2,
   source_ref5_               IN     VARCHAR2,
   source_ref_type_           IN     VARCHAR2,
   company_                   IN     VARCHAR2,
   contract_                  IN     VARCHAR2,
   customer_no_               IN     VARCHAR2,
   ship_addr_no_              IN     VARCHAR2,
   planned_ship_date_         IN     DATE,
   supply_country_db_         IN     VARCHAR2,
   delivery_type_             IN     VARCHAR2,
   object_id_                 IN     VARCHAR2,
   use_price_incl_tax_        IN     VARCHAR2,
   currency_code_             IN     VARCHAR2,
   currency_rate_             IN     NUMBER,   
   from_defaults_             IN     VARCHAR2,   
   entered_tax_code_          IN     VARCHAR2,
   tax_liability_             IN     VARCHAR2,
   tax_liability_type_db_     IN     VARCHAR2,
   delivery_country_db_       IN     VARCHAR2,   
   free_of_charge_tax_basis_  IN     NUMBER,
   tax_from_diff_source_      IN     VARCHAR2,
   add_tax_curr_amount_       IN     VARCHAR2,
   quantity_                  IN     NUMBER,
   attr_                      IN     VARCHAR2)
IS
   line_amount_rec_             Tax_Handling_Util_API.line_amount_rec;
   source_tax_info_attr_        VARCHAR2(2000);
   stmt_                        VARCHAR2(2000);
   source_pkg_                  VARCHAR2(30);
   source_ship_addr_no_         VARCHAR2(50);
   source_planned_ship_date_    DATE;
   source_supply_country_db_    VARCHAR2(2);
   source_delivery_type_        VARCHAR2(20);
   source_delivery_country_db_  VARCHAR2(2);
   tax_source_ref1_             VARCHAR2(50);
   tax_source_ref2_             VARCHAR2(50);
   tax_source_ref3_             VARCHAR2(50);
   tax_source_ref4_             VARCHAR2(50);
   tax_source_ref5_             VARCHAR2(50);
   tax_code_                    VARCHAR2(20);
   multiple_tax_                VARCHAR2(20);
   tax_class_id_                VARCHAR2(20);
BEGIN
   line_amount_rec_.line_net_curr_amount   := line_net_curr_amount_;
   line_amount_rec_.line_gross_curr_amount := line_gross_curr_amount_;  
   
   -- In the RMA line, if the invoice id or order no is specified, need to fetch tax info from invoice or order line respectively.
   IF ((tax_from_diff_source_ = 'TRUE') AND (source_ref_type_ IN (Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                             Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, Tax_Source_API.DB_INVOICE))) THEN
      source_pkg_        := Get_Source_Pkg___(source_ref_type_); 
      IF(source_ref_type_ = Tax_Source_API.DB_INVOICE) THEN
         tax_source_ref1_ := Site_API.Get_Company(contract_);
         tax_source_ref2_ := source_ref1_;
         tax_source_ref3_ := source_ref2_;
         tax_source_ref4_ := '*';
      ELSE
         tax_source_ref1_ := source_ref1_;
         tax_source_ref2_ := source_ref2_;
         tax_source_ref3_ := source_ref3_;
         tax_source_ref4_ := source_ref4_;
      END IF;
      tax_source_ref5_ := '*';
      Assert_Sys.Assert_Is_Package(source_pkg_);
      stmt_  := 'BEGIN '||source_pkg_||'.Get_Tax_Info(:attr, :source_ref1, :source_ref2, :source_ref3, :source_ref4); END;';
      @ApproveDynamicStatement(2016-04-28,IsSalk) 
      EXECUTE IMMEDIATE stmt_
              USING OUT source_tax_info_attr_,
                    IN  tax_source_ref1_,
                    IN  tax_source_ref2_,
                    IN  tax_source_ref3_,
                    IN  tax_source_ref4_;  

      source_ship_addr_no_        := Client_SYS.Get_Item_Value('SHIP_ADDR_NO', source_tax_info_attr_);
      source_planned_ship_date_   := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('PLANNED_SHIP_DATE', source_tax_info_attr_));
      source_supply_country_db_   := Client_SYS.Get_Item_Value('SUPPLY_COUNTRY_DB', source_tax_info_attr_);
      source_delivery_type_       := Client_SYS.Get_Item_Value('DELIVERY_TYPE', source_tax_info_attr_);
      source_delivery_country_db_ := Client_SYS.Get_Item_Value('DELIVERY_COUNTRY_DB', source_tax_info_attr_);
      
      IF tax_calc_structure_id_ IS NULL THEN
         tax_calc_structure_id_      := Source_Tax_Item_API.Get_Line_Tax_Calc_Structure_Id(company_, source_ref_type_, tax_source_ref1_, 
                                                tax_source_ref2_, tax_source_ref3_, tax_source_ref4_, tax_source_ref5_);
      END IF;
      
   ELSE
      source_ship_addr_no_        := ship_addr_no_;
      source_planned_ship_date_   := planned_ship_date_;
      source_supply_country_db_   := supply_country_db_;
      source_delivery_type_       := delivery_type_;
      source_delivery_country_db_ := delivery_country_db_;
   END IF;
   
   tax_code_ := entered_tax_code_;
   -- Note: Pass NULL to ifs_curr_rounding_, since for amounts, currency rounding is used.
   Get_Line_Amount_Rec___(line_amount_rec_,
                          multiple_tax_,
                          tax_code_,
                          tax_calc_structure_id_,
                          tax_class_id_,
                          source_ref1_,
                          source_ref2_,
                          source_ref3_,
                          source_ref4_,
                          source_ref5_,
                          source_ref_type_,
                          company_,
                          contract_,
                          customer_no_,
                          source_ship_addr_no_,
                          source_planned_ship_date_,
                          source_supply_country_db_,
                          source_delivery_type_,
                          object_id_,
                          use_price_incl_tax_,
                          currency_code_,
                          currency_rate_,
                          from_defaults_,
                          tax_liability_,
                          tax_liability_type_db_,
                          source_delivery_country_db_,
                          NULL,
                          free_of_charge_tax_basis_,
                          add_tax_curr_amount_,
                          quantity_,
                          FALSE,
                          attr_);
   
   line_tax_curr_amount_   := line_amount_rec_.line_tax_curr_amount;
   line_tax_dom_amount_    := line_amount_rec_.line_tax_dom_amount;
   line_net_curr_amount_   := line_amount_rec_.line_net_curr_amount;
   line_net_dom_amount_    := line_amount_rec_.line_net_dom_amount;
   line_gross_curr_amount_ := line_amount_rec_.line_gross_curr_amount;   
   line_gross_dom_amount_  := line_amount_rec_.line_gross_dom_amount;
   
   IF (free_of_charge_tax_basis_ IS NOT NULL and free_of_charge_tax_basis_ > 0) THEN
      line_net_curr_amount_   := 0;
      line_net_dom_amount_    := 0;
      line_gross_curr_amount_ := line_tax_curr_amount_;   
      line_gross_dom_amount_  := line_tax_dom_amount_;
   END IF;   
END Get_Amounts;


-- Get_Amounts
--    This method should use only when source package tax information saved.
--    e.g.:- In RMB options in customer order line. It would not be an issue to 
--           fetch tax information from customer order line, since it is saved 
--           before RMB and goes to another dialog or window.  
PROCEDURE Get_Amounts (
   line_tax_dom_amount_          OUT NUMBER,
   line_net_dom_amount_          OUT NUMBER,
   line_gross_dom_amount_        OUT NUMBER,
   line_tax_curr_amount_         OUT NUMBER,
   line_net_curr_amount_      IN OUT NUMBER,
   line_gross_curr_amount_    IN OUT NUMBER,
   company_                   IN     VARCHAR2,
   source_ref_type_           IN     VARCHAR2,
   source_ref1_               IN     VARCHAR2,
   source_ref2_               IN     VARCHAR2,
   source_ref3_               IN     VARCHAR2,
   source_ref4_               IN     VARCHAR2,
   source_ref5_               IN     VARCHAR2)
IS
   source_key_rec_              Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_          tax_line_param_rec;
   stmt_                        VARCHAR2(32000);
   source_pkg_                  VARCHAR2(30);
BEGIN
   source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_,
                                                                  source_ref1_, 
                                                                  source_ref2_, 
                                                                  source_ref3_, 
                                                                  source_ref4_,
                                                                  source_ref5_,
                                                                  attr_ => NULL);
                                                                  
   source_pkg_    := Get_Source_Pkg___(source_ref_type_); 
   Assert_Sys.Assert_Is_Package(source_pkg_);                                                                      
   stmt_  := 'BEGIN :tax_line_param_rec := '||source_pkg_||'.Fetch_Tax_Line_Param(:company, :source_ref1, :source_ref2,
                                                            :source_ref3, :source_ref4); END;';
      @ApproveDynamicStatement(2016-02-29,MAHPLK) 
      EXECUTE IMMEDIATE stmt_
              USING  OUT tax_line_param_rec_,
                     IN  company_,
                     IN  source_key_rec_.source_ref1,
                     IN  source_key_rec_.source_ref2,
                     IN  source_key_rec_.source_ref3,
                     IN  source_key_rec_.source_ref4;

   Get_Amounts(line_tax_dom_amount_,
               line_net_dom_amount_,
               line_gross_dom_amount_,
               line_tax_curr_amount_,
               line_net_curr_amount_,
               line_gross_curr_amount_,
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
               tax_line_param_rec_.use_price_incl_tax,
               tax_line_param_rec_.currency_code,
               tax_line_param_rec_.currency_rate,  
               'FALSE',   
               tax_line_param_rec_.tax_code,
               tax_line_param_rec_.tax_liability,
               tax_line_param_rec_.tax_liability_type_db,
               delivery_country_db_ => NULL,                
               free_of_charge_tax_basis_ => NULL,
               tax_from_diff_source_  => NULL,
               add_tax_curr_amount_ => Fnd_Boolean_API.DB_FALSE,
               quantity_ => NULL,
               attr_ => NULL);
END Get_Amounts;

@IgnoreUnitTest PipelinedFunction
@UncheckedAccess
FUNCTION Get_Amounts(
   net_curr_amount_        IN NUMBER,
   gross_curr_amount_      IN NUMBER,
   company_                IN VARCHAR2,
   source_ref_type_        IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2,
   source_ref5_            IN VARCHAR2) RETURN Amounts_Arr PIPELINED
IS
   rec_                    Amounts_Rec;
   line_tax_curr_amount_   NUMBER;
   line_tax_dom_amount_    NUMBER;
   line_net_dom_amount_    NUMBER;
   line_gross_dom_amount_  NUMBER;
   line_net_curr_amount_   NUMBER := net_curr_amount_;
   line_gross_curr_amount_ NUMBER := gross_curr_amount_;
BEGIN
   Get_Amounts(line_tax_dom_amount_,
               line_net_dom_amount_,
               line_gross_dom_amount_,
               line_tax_curr_amount_,
               line_net_curr_amount_,
               line_gross_curr_amount_,
               company_,
               source_ref_type_,
               source_ref1_,
               source_ref2_,
               source_ref3_,
               source_ref4_,
               source_ref5_);

   rec_.tax_curr_amount   := line_tax_curr_amount_;
   rec_.net_curr_amount    := line_net_curr_amount_;
   rec_.gross_curr_amount := line_gross_curr_amount_;
   rec_.tax_dom_amount  := line_tax_dom_amount_;
   rec_.net_dom_amount   := line_net_dom_amount_;
   rec_.gross_dom_amount   := line_gross_dom_amount_;

   PIPE ROW(rec_);
END Get_Amounts;



PROCEDURE Get_Prices (
   net_dom_price_            OUT NUMBER,
   gross_dom_price_          OUT NUMBER,   
   net_curr_price_        IN OUT NUMBER,
   gross_curr_price_      IN OUT NUMBER,
   multiple_tax_          IN OUT VARCHAR2,
   line_tax_code_         IN OUT VARCHAR2,
   tax_calc_structure_id_ IN OUT VARCHAR2,
   tax_class_id_          IN OUT VARCHAR2,
   source_ref1_           IN     VARCHAR2,
   source_ref2_           IN     VARCHAR2,
   source_ref3_           IN     VARCHAR2,
   source_ref4_           IN     VARCHAR2,
   source_ref5_           IN     VARCHAR2,
   source_ref_type_       IN     VARCHAR2,
   contract_              IN     VARCHAR2,
   customer_no_           IN     VARCHAR2,
   ship_addr_no_          IN     VARCHAR2,
   planned_ship_date_     IN     DATE,
   supply_country_db_     IN     VARCHAR2,
   delivery_type_         IN     VARCHAR2,
   object_id_             IN     VARCHAR2,
   use_price_incl_tax_    IN     VARCHAR2,
   currency_code_         IN     VARCHAR2,
   currency_rate_         IN     NUMBER,  
   from_defaults_         IN     VARCHAR2,
   tax_liability_         IN     VARCHAR2,
   tax_liability_type_db_ IN     VARCHAR2,
   delivery_country_db_   IN     VARCHAR2,
   ifs_curr_rounding_     IN     NUMBER,
   tax_from_diff_source_  IN     VARCHAR2,
   attr_                  IN     VARCHAR2)
IS
   line_amount_rec_             Tax_Handling_Util_API.line_amount_rec;
   rounding_                    NUMBER;
   source_tax_info_attr_        VARCHAR2(2000);
   stmt_                        VARCHAR2(2000);
   source_pkg_                  VARCHAR2(30);
   source_ship_addr_no_         VARCHAR2(50);
   source_planned_ship_date_    DATE;
   source_supply_country_db_    VARCHAR2(2);
   source_delivery_type_        VARCHAR2(20);
   source_delivery_country_db_  VARCHAR2(2);
   tax_source_ref1_             VARCHAR2(50);
   tax_source_ref2_             VARCHAR2(50);
   tax_source_ref3_             VARCHAR2(50);
   tax_source_ref4_             VARCHAR2(50);
   tax_source_ref5_             VARCHAR2(50);
   company_                     VARCHAR2(20);
BEGIN
   rounding_ := NVL(ifs_curr_rounding_, 2);
   company_  := Site_API.Get_Company(contract_);
   
   IF company_ IS NULL THEN
      -- This will execute during Rebate invoice.
      company_  := Client_SYS.Get_Item_Value('COMPANY', attr_);
   END IF;
   
   IF (line_tax_code_ IS NOT NULL) THEN
      Statutory_Fee_API.Validate_Tax_Code(company_, line_tax_code_, planned_ship_date_);      
   END IF;
   
   line_amount_rec_.line_net_curr_amount   := ROUND(net_curr_price_, rounding_);
   line_amount_rec_.line_gross_curr_amount := ROUND(gross_curr_price_, rounding_);  
   
   -- In the RMA line and RMA charge line, if the invoice id or order no is specified, need to fetch tax info from invoice or order line respectively.
   IF ((tax_from_diff_source_ = 'TRUE') AND (source_ref_type_ IN (Tax_Source_API.DB_CUSTOMER_ORDER_LINE, Tax_Source_API.DB_INVOICE, Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE)))  THEN
      source_pkg_        := Get_Source_Pkg___(source_ref_type_);
      IF(source_ref_type_ = Tax_Source_API.DB_INVOICE) THEN
         tax_source_ref1_ := company_;
         tax_source_ref2_ := source_ref1_;
         tax_source_ref3_ := source_ref2_;
         tax_source_ref4_ := '*';
      ELSE
         tax_source_ref1_ := source_ref1_;
         tax_source_ref2_ := source_ref2_;
         tax_source_ref3_ := source_ref3_;
         tax_source_ref4_ := source_ref4_;
      END IF;
      tax_source_ref5_ := '*';
      Assert_Sys.Assert_Is_Package(source_pkg_);
      stmt_  := 'BEGIN '||source_pkg_||'.Get_Tax_Info(:attr, :source_ref1, :source_ref2, :source_ref3, :source_ref4); END;';
      @ApproveDynamicStatement(2016-04-28,IsSalk) 
      EXECUTE IMMEDIATE stmt_
              USING OUT source_tax_info_attr_,
                    IN  tax_source_ref1_,
                    IN  tax_source_ref2_,
                    IN  tax_source_ref3_,
                    IN  tax_source_ref4_;

      source_ship_addr_no_        := Client_SYS.Get_Item_Value('SHIP_ADDR_NO', source_tax_info_attr_);
      source_planned_ship_date_   := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('PLANNED_SHIP_DATE', source_tax_info_attr_));
      source_supply_country_db_   := Client_SYS.Get_Item_Value('SUPPLY_COUNTRY_DB', source_tax_info_attr_);
      source_delivery_type_       := Client_SYS.Get_Item_Value('DELIVERY_TYPE', source_tax_info_attr_);
      source_delivery_country_db_ := Client_SYS.Get_Item_Value('DELIVERY_COUNTRY_DB', source_tax_info_attr_);
      
      IF tax_calc_structure_id_ IS NULL THEN
         tax_calc_structure_id_      := Source_Tax_Item_API.Get_Line_Tax_Calc_Structure_Id(company_, source_ref_type_, tax_source_ref1_, 
                                                tax_source_ref2_, tax_source_ref3_, tax_source_ref4_, tax_source_ref5_);
      END IF;
   ELSE
      source_ship_addr_no_        := ship_addr_no_;
      source_planned_ship_date_   := planned_ship_date_;
      source_supply_country_db_   := supply_country_db_;
      source_delivery_type_       := delivery_type_;
      source_delivery_country_db_ := delivery_country_db_;
   END IF;
   
   -- Note: Use ifs_curr_rounding_, which is passed from client to round prices.
   Get_Line_Amount_Rec___(line_amount_rec_,
                          multiple_tax_,
                          line_tax_code_,
                          tax_calc_structure_id_,
                          tax_class_id_,
                          source_ref1_,
                          source_ref2_,
                          source_ref3_,
                          source_ref4_,
                          source_ref5_,
                          source_ref_type_,
                          NULL,
                          contract_,
                          customer_no_,
                          source_ship_addr_no_,
                          source_planned_ship_date_,
                          source_supply_country_db_,
                          source_delivery_type_,
                          object_id_,
                          use_price_incl_tax_,
                          currency_code_,
                          currency_rate_,
                          from_defaults_,
                          tax_liability_,
                          tax_liability_type_db_,
                          source_delivery_country_db_,
                          rounding_,
                          NULL,
                          Fnd_Boolean_API.DB_FALSE,
                          NULL,
                          TRUE,
                          attr_);
      
   net_curr_price_   := line_amount_rec_.line_net_curr_amount;
   net_dom_price_    := line_amount_rec_.line_net_dom_amount;
   gross_curr_price_ := line_amount_rec_.line_gross_curr_amount;   
   gross_dom_price_  := line_amount_rec_.line_gross_dom_amount;
END Get_Prices;


-- Get_Prices
--    This method should use only when source package tax information saved.
--    e.g.:- In RMB options in customer order line. It would not be an issue to 
--           fetch tax information from customer order line, since it is saved 
--           before RMB and goes to another dialog or window.  
PROCEDURE Get_Prices (
   net_dom_price_            OUT NUMBER,
   gross_dom_price_          OUT NUMBER,   
   net_curr_price_        IN OUT NUMBER,
   gross_curr_price_      IN OUT NUMBER,
   company_               IN     VARCHAR2,
   source_ref_type_       IN     VARCHAR2,
   source_ref1_           IN     VARCHAR2,
   source_ref2_           IN     VARCHAR2,
   source_ref3_           IN     VARCHAR2,
   source_ref4_           IN     VARCHAR2,
   source_ref5_           IN     VARCHAR2,
   ifs_curr_rounding_     IN     NUMBER)
IS
   source_key_rec_              Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_          tax_line_param_rec;
   stmt_                        VARCHAR2(32000);
   source_pkg_                  VARCHAR2(30);   
   multiple_tax_                VARCHAR2(20);
   attr_                        VARCHAR2(2000);
BEGIN
   source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_,
                                                                  source_ref1_, 
                                                                  source_ref2_, 
                                                                  source_ref3_, 
                                                                  source_ref4_,
                                                                  source_ref5_,
                                                                  attr_ => NULL);
                                                                  
   source_pkg_    := Get_Source_Pkg___(source_ref_type_); 
   
   Client_SYS.Set_Item_Value('COMPANY', company_, attr_);
   
   Assert_Sys.Assert_Is_Package(source_pkg_);                                                  
   stmt_  := 'BEGIN :tax_line_param_rec := '||source_pkg_||'.Fetch_Tax_Line_Param(:company, :source_ref1, :source_ref2,
                                                            :source_ref3, :source_ref4); END;';
      @ApproveDynamicStatement(2016-02-29,MAHPLK) 
      EXECUTE IMMEDIATE stmt_
              USING  OUT tax_line_param_rec_,
                     IN  company_,
                     IN  source_key_rec_.source_ref1,
                     IN  source_key_rec_.source_ref2,
                     IN  source_key_rec_.source_ref3,
                     IN  source_key_rec_.source_ref4;
     
   Get_Prices (net_dom_price_,
               gross_dom_price_,   
               net_curr_price_,
               gross_curr_price_,
               multiple_tax_,
               tax_line_param_rec_.tax_code,
               tax_line_param_rec_.tax_calc_structure_id,
               tax_line_param_rec_.tax_class_id,
               source_ref1_,
               source_ref2_,
               source_ref3_,
               source_ref4_,
               source_ref5_,
               source_ref_type_,
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
               ifs_curr_rounding_ => NVL(ifs_curr_rounding_, 16),
               tax_from_diff_source_ => NULL,               
               attr_ => attr_ );
END Get_Prices;

-- Calc_Price_Source_Prices
-- This method is used from price sources to calculate gross and net prices.
-- Using this can avoid retrieval of tax percentage from the client.
@UncheckedAccess
PROCEDURE Calc_Price_Source_Prices(
   net_price_           IN OUT NUMBER,
   gross_price_         IN OUT NUMBER,
   contract_            IN     VARCHAR2,
   catalog_no_          IN     VARCHAR2,
   calc_base_           IN     VARCHAR2,
   ifs_curr_rounding_   IN     NUMBER)
IS
   company_        VARCHAR2(20);
   tax_percentage_ NUMBER; 
BEGIN
   
   company_        := Site_API.Get_Company(contract_);
   tax_percentage_ := Statutory_Fee_API.Get_Fee_Rate(company_, Sales_Part_API.Get_Tax_Code(contract_, catalog_no_));
   Tax_Handling_Util_API.Calculate_Prices(net_price_, 
                                          gross_price_, 
                                          calc_base_, 
                                          NVL(tax_percentage_, 0), 
                                          ifs_curr_rounding_); 
   
END Calc_Price_Source_Prices;


PROCEDURE Recalculate_Tax_Lines (
   source_key_rec_        IN  Tax_Handling_Util_API.source_key_rec,
   tax_line_param_rec_    IN  tax_line_param_rec,
   attr_                  IN  VARCHAR2 )
IS
   tax_info_table_               Tax_Handling_Util_API.tax_information_table;
   line_amount_rec_              Tax_Handling_Util_API.line_amount_rec;
   modified_tax_line_param_rec_  tax_line_param_rec;
   sales_object_type_            VARCHAR2(30);
   external_tax_calc_method_     VARCHAR2(50);
   multiple_tax_                 VARCHAR2(20);
BEGIN
   modified_tax_line_param_rec_ := tax_line_param_rec_;   

   sales_object_type_            := Get_Sales_Object_Type___(modified_tax_line_param_rec_.company, source_key_rec_);
   Add_Tax_Info_To_Rec___(modified_tax_line_param_rec_, source_key_rec_, attr_);
   external_tax_calc_method_     := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(modified_tax_line_param_rec_.company);
   
   IF (external_tax_calc_method_ = 'NOT_USED') THEN
      -- Do not fetch from defaults, use already saved tax info
      modified_tax_line_param_rec_.from_defaults  := FALSE;
                  
      Fetch_Tax_Codes___(multiple_tax_, 
                         tax_info_table_,
                         modified_tax_line_param_rec_,
                         source_key_rec_,
                         sales_object_type_,
                         'FALSE',
                         attr_);
   ELSIF (external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
      -- Fetch External Tax information
      Fetch_External_Tax_Info___(multiple_tax_,
                               tax_info_table_,
                               modified_tax_line_param_rec_,
                               source_key_rec_,
                               sales_object_type_,
                               'TRUE',
                               attr_);
   END IF;

   Calculate_Line_Totals___(line_amount_rec_, 
                            tax_info_table_,
                            source_key_rec_,
                            NULL,
                            modified_tax_line_param_rec_,
                            external_tax_calc_method_,
                            FALSE,
                            TRUE,
                            attr_);
                            
   Modify_Source_Tax_Lines___(tax_info_table_, 
                              source_key_rec_, 
                              modified_tax_line_param_rec_.company);                      
      
END Recalculate_Tax_Lines;


PROCEDURE Fetch_And_Calc_Tax_From_Msg (
   line_amount_rec_           OUT Tax_Handling_Util_API.line_amount_rec,
   tax_info_table_         IN OUT Tax_Handling_Util_API.tax_information_table,
   attr_                   IN OUT VARCHAR2,
   tax_msg_                IN     VARCHAR2,
   company_                IN     VARCHAR2,
   line_gross_curr_amount_ IN     NUMBER,
   line_net_curr_amount_   IN     NUMBER,
   price_type_             IN     VARCHAR2,
   calc_tax_amounts_       IN     VARCHAR2,
   tax_liability_date_     IN     DATE,
   currency_rate_          IN     NUMBER,
   source_ref_type_        IN     VARCHAR2,
   source_ref1_            IN     VARCHAR2,
   source_ref2_            IN     VARCHAR2,
   source_ref3_            IN     VARCHAR2,
   source_ref4_            IN     VARCHAR2,
   source_ref5_            IN     VARCHAR2,
   identity_               IN     VARCHAR2,
   currency_code_          IN     VARCHAR2 ,
   ship_addr_no_           IN     VARCHAR2,
   ifs_curr_rounding_      IN     NUMBER)
IS 
   stmt_                        VARCHAR2(2000);
   source_pkg_                  VARCHAR2(30);
   tax_code_                    VARCHAR2(20);
   use_specific_rate_           VARCHAR2(5) := 'FALSE';
   tax_percentage_              NUMBER;
   count_                       NUMBER;
   tax_curr_amount_             NUMBER;
   modified_currency_rate_      NUMBER;
   currency_conv_factor_        NUMBER;
   tax_curr_rate_               NUMBER;
   index_                       NUMBER := 0;
   tax_calc_structure_id_       VARCHAR2(20);
   tax_calc_structure_item_id_  VARCHAR2(20);
   tax_line_param_rec_          tax_line_param_rec;
   m_s_names_                   Message_SYS.name_table;
   m_s_values_                  Message_SYS.line_table; 
   acc_curr_rec_                Tax_Handling_Util_API.acc_curr_rec;
   trans_curr_rec_              Tax_Handling_Util_API.trans_curr_rec;
   para_curr_rec_               Tax_Handling_Util_API.para_curr_rec;
BEGIN
   source_pkg_    := Get_Source_Pkg___(source_ref_type_); 
      
   Assert_Sys.Assert_Is_Package(source_pkg_);
   stmt_  := 'BEGIN :tax_line_param_rec := '||source_pkg_||'.Fetch_Tax_Line_Param(:company, :source_ref1,
                                           :source_ref2, :source_ref3, :source_ref4); END;';
   @ApproveDynamicStatement(2016-06-28,DIPELK) 
   EXECUTE IMMEDIATE stmt_
      USING  OUT tax_line_param_rec_,
             IN  company_,
             IN  source_ref1_,
             IN  source_ref2_,
             IN  source_ref3_,
             IN  source_ref4_;
   line_amount_rec_ := Tax_Handling_Util_API.Create_Line_Amount_Rec(line_gross_curr_amount_, 
                                                                    line_net_curr_amount_, 
                                                                    NULL, 
                                                                    price_type_,
                                                                    'FALSE',
                                                                    attr_);
                                                
   IF (tax_info_table_.COUNT = 0) AND (Message_SYS.Get_Name(tax_msg_) = 'TAX_INFORMATION') THEN
      Message_SYS.Get_Attributes(tax_msg_, count_, m_s_names_, m_s_values_);
      FOR i IN 1..count_  LOOP
         IF (m_s_names_(i) = 'TAX_CALC_STRUCTURE_ID') THEN
            tax_calc_structure_id_ := m_s_values_(i);
         ELSIF (m_s_names_(i) = 'TAX_CALC_STRUCTURE_ITEM_ID') THEN
            tax_calc_structure_item_id_ := m_s_values_(i);
         ELSIF (m_s_names_(i) = 'TAX_CODE') THEN
            tax_code_ := m_s_values_(i);                 
            Tax_Handling_Util_API.Add_Tax_Code_Info(tax_info_table_, company_, Party_Type_API.DB_CUSTOMER, tax_code_, tax_calc_structure_id_, tax_calc_structure_item_id_, 'FETCH_ALWAYS', tax_percentage_, tax_liability_date_, NULL, NULL); 
            index_ := tax_info_table_.LAST;
         ELSIF (m_s_names_(i) = 'TAX_PERCENTAGE') THEN
            tax_info_table_(index_).tax_percentage := m_s_values_(i);
         END IF;
         IF (m_s_names_(i) = 'TAX_CURR_AMOUNT') THEN
            tax_curr_amount_ := m_s_values_(i);
            tax_info_table_(index_).total_tax_curr_amount   := tax_curr_amount_;
            tax_info_table_(index_).tax_curr_amount         := tax_curr_amount_;
            tax_info_table_(index_).non_ded_tax_curr_amount := 0;
         END IF;
         IF (m_s_names_(i) = 'TAX_BASE_CURR_AMOUNT') THEN
            tax_info_table_(index_).tax_base_curr_amount := m_s_values_(i);
         END IF;
      END LOOP;
   END IF;
   trans_curr_rec_   := Tax_Handling_Util_API.Create_Trans_Curr_Rec(company_,
                                                                    identity_,
                                                                    Party_Type_API.DB_CUSTOMER,
                                                                    currency_code_,
                                                                    ship_addr_no_,
                                                                    attr_,
                                                                    NULL,
                                                                    ifs_curr_rounding_);
   IF (calc_tax_amounts_ = 'TRUE') THEN     
      Tax_Handling_Util_API.Calc_Tax_Curr_Amounts (tax_info_table_, line_amount_rec_, company_, trans_curr_rec_);                                                                   
   ELSE
      -- Currency rate and Conversion factor returned from Customer_Order_Inv_Item_API.Fetch_Tax_Line_Param 
      -- used as it is, when print the invoice (report taxes to external tax system).
      IF (NVL(tax_line_param_rec_.write_to_ext_tax_register, 'FALSE') = 'FALSE') THEN
         Get_Curr_Rate_And_Conv_Fact___(modified_currency_rate_,
                                        currency_conv_factor_,
                                        tax_line_param_rec_.company,
                                        tax_line_param_rec_.currency_code,
                                        tax_line_param_rec_.currency_rate / tax_line_param_rec_.conv_factor,
                                        tax_line_param_rec_.customer_no); 
      END IF;
      acc_curr_rec_     := Tax_Handling_Util_API.Create_Acc_Curr_Rec(tax_line_param_rec_.company,
                                                                     attr_,
                                                                     modified_currency_rate_,
                                                                     currency_conv_factor_,                                                                  
                                                                     ifs_curr_rounding_);
                                                                  
      -- tax_line_param_rec_.calculate_para_amount parameeter will be null except customer order invoices.                                                               
      para_curr_rec_ := Tax_Handling_Util_API.Create_Para_Curr_Rec(tax_line_param_rec_.company,
                                                                   tax_line_param_rec_.currency_code,
                                                                   NVL(tax_line_param_rec_.calculate_para_amount,'FALSE'),
                                                                   attr_,
                                                                   tax_line_param_rec_.para_curr_rate,
                                                                   tax_line_param_rec_.para_conv_factor,
                                                                   tax_line_param_rec_.para_curr_rounding);
      IF (source_ref_type_ = Tax_Source_API.DB_INVOICE) THEN                                                                   
         use_specific_rate_ := Invoice_API.Get_Specific_Rate_On_Invoice(tax_line_param_rec_.company, TO_NUMBER(source_ref1_));   
         tax_curr_rate_     := Invoice_API.Get_Tax_Curr_Rate(tax_line_param_rec_.company, TO_NUMBER(source_ref1_));
         FOR i IN 1 .. tax_info_table_.COUNT LOOP
            IF (use_specific_rate_ = 'TRUE' AND tax_info_table_(i).tax_method_db IN (Vat_Method_API.DB_INVOICE_ENTRY, Vat_Method_API.DB_FINAL_POSTING)) THEN
               tax_info_table_(i).use_specific_rate := 'TRUE';
               tax_info_table_(i).curr_rate         := NVL(tax_curr_rate_, modified_currency_rate_);   
            END IF;
         END LOOP;  
      END IF;                                                                   
     Tax_Handling_Util_API.Calc_Line_Total_Amounts(tax_info_table_,
                                                   line_amount_rec_,
                                                   tax_line_param_rec_.company,
                                                   trans_curr_rec_,
                                                   acc_curr_rec_,
                                                   para_curr_rec_);
                                                   
   END IF;
   
END Fetch_And_Calc_Tax_From_Msg;


--Calc_Total_Net_Gross_curr_Amt
-- Returns total net gross and tax information in transaction currency related to the correspond source ref type.
-- Idea behind this method is to avoid multiple tax fetching as tax information (tax_info_table_) passed as a parameeter.
PROCEDURE Calc_Total_Net_Gross_curr_Amt (
   gross_amount_       IN OUT NUMBER,
   net_amount_         IN OUT NUMBER,
   tax_info_table_     IN OUT Tax_Handling_Util_API.tax_information_table,
   tax_line_param_rec_ IN     tax_line_param_rec,
   source_ref_type_    IN     VARCHAR2,
   source_ref1_        IN     VARCHAR2,
   source_ref2_        IN     VARCHAR2,
   source_ref3_        IN     VARCHAR2,
   source_ref4_        IN     VARCHAR2,
   source_ref5_        IN     VARCHAR2)
IS 
   source_key_rec_      Tax_Handling_Util_API.source_key_rec; 
   line_amount_rec_     Tax_Handling_Util_API.line_amount_rec;
   trans_curr_rec_      Tax_Handling_Util_API.trans_curr_rec;   
   attr_                VARCHAR2(2000);
   source_pkg_          VARCHAR2(30);
   modified_tax_line_param_rec_ tax_line_param_rec;
   external_tax_calc_method_    VARCHAR2(50);
   sales_object_type_           VARCHAR2(30); 
BEGIN
   source_key_rec_   := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_,
                                                                    source_ref1_, 
                                                                    source_ref2_, 
                                                                    source_ref3_, 
                                                                    source_ref4_,
                                                                    source_ref5_,
                                                                    NULL);
   sales_object_type_         := Get_Sales_Object_Type___(tax_line_param_rec_.company, source_key_rec_);
   external_tax_calc_method_  := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(tax_line_param_rec_.company);
   IF (external_tax_calc_method_ = 'NOT_USED') THEN
      
      modified_tax_line_param_rec_                   := tax_line_param_rec_;
      modified_tax_line_param_rec_.gross_curr_amount := gross_amount_;
      modified_tax_line_param_rec_.net_curr_amount   := net_amount_;
      source_pkg_       := Get_Source_Pkg___(source_key_rec_.source_ref_type); 
      line_amount_rec_  := Create_Line_Amount_Rec___(source_key_rec_, 
                                                     modified_tax_line_param_rec_,
                                                     FALSE,
                                                     attr_);

      trans_curr_rec_   := Tax_Handling_Util_API.Create_Trans_Curr_Rec(tax_line_param_rec_.company,
                                                                       tax_line_param_rec_.customer_no,
                                                                       Party_Type_API.DB_CUSTOMER,
                                                                       tax_line_param_rec_.currency_code,
                                                                       tax_line_param_rec_.ship_addr_no,
                                                                       attr_,
                                                                       NULL,
                                                                       tax_line_param_rec_.ifs_curr_rounding);
     Tax_Handling_Util_API.Calc_Tax_Curr_Amounts (tax_info_table_, line_amount_rec_, tax_line_param_rec_.company, trans_curr_rec_);
     
     gross_amount_ := line_amount_rec_.line_gross_curr_amount;
     net_amount_   := line_amount_rec_.line_net_curr_amount ;    
   END IF;                                                               
END Calc_Total_Net_Gross_curr_Amt;


-----------------------------------------------------------------
-- Calc_And_Save_Foc_Tax_Basis
-- Calculates and returns the tax basis for free of charge goods.
-- Allows to update free_of_charge_tax_basis in the source line.
-----------------------------------------------------------------
PROCEDURE Calc_And_Save_Foc_Tax_Basis (
   free_of_charge_tax_basis_ IN OUT NUMBER,
   source_ref_type_          IN     VARCHAR2,
   source_ref1_              IN     VARCHAR2,
   source_ref2_              IN     VARCHAR2,
   source_ref3_              IN     VARCHAR2,
   source_ref4_              IN     VARCHAR2,
   source_ref5_              IN     VARCHAR2,   
   cost_                     IN     NUMBER,
   part_price_               IN     NUMBER,
   revised_qty_due_          IN     NUMBER,
   customer_no_              IN     VARCHAR2,
   contract_                 IN     VARCHAR2,
   curr_code_                IN     VARCHAR2,
   currency_rate_type_       IN     VARCHAR2,
   modify_source_line_       IN     VARCHAR2)   
IS
   tax_paying_party_  VARCHAR2(20);   
   company_           VARCHAR2(20);
   source_pkg_        VARCHAR2(30);
   stmt_              VARCHAR2(2000);  
   curr_type_         VARCHAR2(10);
   conv_factor_       NUMBER;
   rate_              NUMBER;
   site_date_         DATE;  
BEGIN
   IF (source_ref_type_ = Tax_Source_API.DB_CUSTOMER_ORDER_LINE) THEN
      tax_paying_party_ := Customer_Order_API.Get_Free_Of_Chg_Tax_Pay_Par_Db(source_ref1_);
   ELSIF (source_ref_type_ = Tax_Source_API.DB_ORDER_QUOTATION_LINE) THEN
      tax_paying_party_ := Order_Quotation_API.Get_Free_Of_Chg_Tax_Pay_Par_Db(source_ref1_);
   END IF;      
 
   IF (tax_paying_party_ = Tax_Paying_Party_API.DB_NO_TAX) THEN
      free_of_charge_tax_basis_ := 0;
   ELSIF (tax_paying_party_ IN (Tax_Paying_Party_API.DB_CUSTOMER, Tax_Paying_Party_API.DB_COMPANY)) THEN
      company_   := Site_API.Get_Company(contract_);
      IF (Company_Tax_Discom_Info_API.Get_Tax_Basis_Source_Db(company_) = Tax_Basis_Source_API.DB_PART_COST) THEN
         free_of_charge_tax_basis_ := cost_ * revised_qty_due_;
         IF (free_of_charge_tax_basis_ != 0) THEN
            site_date_ := Site_API.Get_Site_Date(contract_);  
            curr_type_ := currency_rate_type_;
            Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, conv_factor_, rate_, company_, curr_code_,
                                                              site_date_, 'CUSTOMER', customer_no_);
            rate_      := rate_ / conv_factor_;
            IF (Company_Finance_API.Get_Currency_Code(company_) != curr_code_) THEN
               IF (rate_ = 0) THEN
                  free_of_charge_tax_basis_ := 0;
               ELSE
                  free_of_charge_tax_basis_ := free_of_charge_tax_basis_ / rate_;
               END IF;
            END IF;
         END IF;
      ELSE
         free_of_charge_tax_basis_ := part_price_ * revised_qty_due_;
      END IF;
   END IF;
   
   -- Update the free_of_charge_tax_basis in source line. Here it is only applicable for CO lines and SQ lines.
   IF (modify_source_line_ = 'TRUE') THEN            
      source_pkg_ := Get_Source_Pkg___(source_ref_type_);      
      Assert_Sys.Assert_Is_Package(source_pkg_);                                               
      stmt_  := 'BEGIN '||source_pkg_||'.Modify_Foc_Tax_Basis(:source_ref1, :source_ref2, :source_ref3, :source_ref4, :foc_tax_basis); END;';
      @ApproveDynamicStatement(2020-06-12,MalLlk) 
      EXECUTE IMMEDIATE stmt_
           USING IN  source_ref1_,
                 IN  source_ref2_,
                 IN  source_ref3_,
                 IN  source_ref4_,
                 IN  free_of_charge_tax_basis_;      
   END IF;
END Calc_And_Save_Foc_Tax_Basis;

-------------------- PUBLIC METHODS FOR VALIDATIONS -------------------------
-- Added new overloaded methoed with tax_percentage_ parameter.
--                    Existing method was not removed due to support directive.
-- Note: This method will be removed. Please use the overloaded method instead.
@UncheckedAccess
PROCEDURE Validate_Tax_Code(
   company_           IN VARCHAR2,
   source_key_rec_    IN  Tax_Handling_Util_API.source_key_rec,
   tax_code_          IN VARCHAR2)
IS   
BEGIN
   Validate_Tax_Code(company_, source_key_rec_,tax_code_, NULL, FALSE, FALSE);
END Validate_Tax_Code;
      
  
-- Validate_Tax_Code
-- Validate the Tax code 
-- Customer Order Line / Charge
@UncheckedAccess
PROCEDURE Validate_Tax_Code(
   company_                 IN VARCHAR2,
   source_key_rec_          IN Tax_Handling_Util_API.source_key_rec,
   tax_code_                IN VARCHAR2,
   tax_percentage_          IN NUMBER,
   tax_code_modified_       IN BOOLEAN,
   tax_percentage_modified_ IN BOOLEAN)
IS 
   source_pkg_             VARCHAR2(30);
   stmt_                   VARCHAR2(2000);
   source_tax_info_attr_   VARCHAR2(2000);
   tax_liability_type_db_  VARCHAR2(20);
   is_taxable_db_          VARCHAR2(20);
   tax_types_event_        VARCHAR2(20):= 'RESTRICTED';
   tax_liability_date_     DATE;
   source_ref1_            VARCHAR2(50);
   source_ref2_            VARCHAR2(50);
   source_ref3_            VARCHAR2(50);
   source_ref4_            VARCHAR2(50);
BEGIN   
   source_pkg_        := Get_Source_Pkg___(source_key_rec_.source_ref_type); 
   Assert_Sys.Assert_Is_Package(source_pkg_);
   source_ref1_ := source_key_rec_.source_ref1;
   source_ref2_ := source_key_rec_.source_ref2;
   source_ref3_ := source_key_rec_.source_ref3;
   source_ref4_ := source_key_rec_.source_ref4;
   
   IF(source_pkg_ = 'Customer_Order_Inv_Item_API') THEN   
      source_ref1_ := company_;
      source_ref2_ := source_key_rec_.source_ref1;
      source_ref3_ := source_key_rec_.source_ref2;
   END IF;
   IF (tax_percentage_ IS NOT NULL AND
      (tax_code_modified_ OR tax_percentage_modified_)) THEN
      Source_Tax_Item_API.Same_Tax_Code_Percentage_Exist(company_, 
                                                         source_key_rec_.source_ref_type,
                                                         source_key_rec_.source_ref1,
                                                         source_key_rec_.source_ref2,
                                                         source_key_rec_.source_ref3,
                                                         source_key_rec_.source_ref4,
                                                         source_key_rec_.source_ref5,
                                                         tax_code_, 
                                                         tax_percentage_);
   END IF;
   
   stmt_  := 'BEGIN '||source_pkg_||'.Get_Tax_Info(:attr, :source_ref1, :source_ref2, :source_ref3, :source_ref4); END;';
   @ApproveDynamicStatement(2016-03-10,SURBLK) 
   EXECUTE IMMEDIATE stmt_
           USING OUT source_tax_info_attr_,
                 IN  source_ref1_,
                 IN  source_ref2_,
                 IN  source_ref3_,
                 IN  source_ref4_;  

   tax_liability_type_db_ := Client_SYS.Get_Item_Value('TAX_LIABILITY_TYPE_DB', source_tax_info_attr_);
   is_taxable_db_         := Client_SYS.Get_Item_Value('IS_TAXABLE_DB', source_tax_info_attr_);
   tax_liability_date_    := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('TAX_LIABILITY_DATE', source_tax_info_attr_));

   Tax_Handling_Util_API.Validate_Tax_On_Transaction(company_, tax_types_event_, tax_code_, tax_liability_type_db_, is_taxable_db_, tax_liability_date_);     

END Validate_Tax_Code;

PROCEDURE Validate_Tax_For_Charge_Type(
   company_                  IN VARCHAR2,
   tax_code_                 IN VARCHAR2,
   sales_chg_type_category_  IN VARCHAR2)
IS
   tax_rate_  NUMBER;
BEGIN
   tax_rate_ := Statutory_Fee_API.Get_Fee_Rate(company_, tax_code_); 
   IF (tax_rate_ != 0) THEN
      IF (sales_chg_type_category_ = 'PACK_SIZE') THEN
         Error_SYS.Record_General(lu_name_, 'INVTAXCODE3: Only 0% Tax Code is allowed, if the Charge Type Category is Pack Size.');
      END IF;
      IF (sales_chg_type_category_ = 'PROMOTION') THEN
         Error_SYS.Record_General(lu_name_, 'PROMOTAXCODE: Only 0% Tax Code is allowed, if the Charge Type Category is Promotion.');
      END IF;
   END IF;
END Validate_Tax_For_Charge_Type;

@UncheckedAccess
FUNCTION Get_Tax_Id_Validated_Date (
   invoice_customer_no_         IN VARCHAR2,
   invoice_cust_doc_addr_no_    IN VARCHAR2,
   customer_no_                 IN VARCHAR2,
   customer_doc_addr_no_        IN VARCHAR2,
   company_                     IN VARCHAR2,
   supply_country_              IN VARCHAR2,
   delivery_country_            IN VARCHAR2)  RETURN DATE
IS
  validated_date_               DATE;
BEGIN
   IF invoice_customer_no_ IS NOT NULL THEN
      validated_date_ := Customer_Document_Tax_Info_API.Get_Validated_Date_Db(invoice_customer_no_, 
                                                                              invoice_cust_doc_addr_no_,
                                                                              company_,
                                                                              supply_country_ , 
                                                                              delivery_country_ );
   ELSE
      validated_date_ := Customer_Document_Tax_Info_API.Get_Validated_Date_Db(customer_no_,
                                                                              customer_doc_addr_no_, 
                                                                              company_, 
                                                                              supply_country_ ,
                                                                              delivery_country_ );
   END IF;

   RETURN validated_date_ ;
END Get_Tax_Id_Validated_Date;


PROCEDURE Validate_Source_Pkg_Info (   
   source_key_rec_    IN  Tax_Handling_Util_API.source_key_rec,
   attr_              IN VARCHAR2)
IS
   source_pkg_   VARCHAR2(30);
   stmt_         VARCHAR2(2000);
BEGIN 
   source_pkg_ :=  Get_Source_Pkg___(source_key_rec_.source_ref_type);
   Assert_Sys.Assert_Is_Package(source_pkg_);
   stmt_  := 'BEGIN '||source_pkg_||'.Validate_Source_Pkg_Info(:source_ref1, :source_ref2, :source_ref3, :source_ref4, :attr); END;';
   @ApproveDynamicStatement(2015-11-11,MAHPLK) 
   EXECUTE IMMEDIATE stmt_
            USING IN  source_key_rec_.source_ref1,
                  IN  source_key_rec_.source_ref2,
                  IN  source_key_rec_.source_ref3,
                  IN  source_key_rec_.source_ref4,
                  IN  attr_;    
END Validate_Source_Pkg_Info;


PROCEDURE Do_Additional_Validations(
   source_ref_type_  IN VARCHAR2,
   source_ref1_      IN VARCHAR2,
   source_ref2_      IN VARCHAR2,
   source_ref3_      IN VARCHAR2,
   source_ref4_      IN VARCHAR2,
   source_ref5_      IN VARCHAR2,
   attr_             IN VARCHAR2 )
IS
   source_key_rec_   Tax_Handling_Util_API.source_key_rec;
BEGIN
   source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_,
                                                                  source_ref1_, 
                                                                  source_ref2_, 
                                                                  source_ref3_, 
                                                                  source_ref4_,
                                                                  source_ref5_,
                                                                  attr_ => attr_);
   
   Validate_Source_Pkg_Info(source_key_rec_,attr_ );                                                                  
END Do_Additional_Validations;

-- Validate_Tax_Free_Tax_Code.
-- Use to validate tax free tax code from order address/ quotation address.
PROCEDURE Validate_Tax_Free_Tax_Code(
   company_                IN VARCHAR2,
   tax_types_event_        IN VARCHAR2,
   tax_code_               IN VARCHAR2,
   tax_liability_type_db_  IN VARCHAR2,
   is_taxable_db_          IN VARCHAR2,
   tax_liability_date_     IN DATE)
IS  
BEGIN   
   IF (tax_code_ IS NOT NULL) THEN
      Statutory_Fee_API.Exist(company_, tax_code_); 
      Tax_Handling_Util_API.Validate_Tax_On_Transaction(company_, 
                                                        tax_types_event_, 
                                                        tax_code_, 
                                                        tax_liability_type_db_, 
                                                        is_taxable_db_, 
                                                        tax_liability_date_);
   END IF;
   IF (tax_code_ IS NULL) AND (tax_liability_type_db_ IN (Tax_Liability_Type_API.DB_EXEMPT, 'EXEMPT')) THEN 
      Client_SYS.Add_Info(lu_name_, 'NOTAXFREECODE: A tax liability with Exempt liability type is used but Tax Free Tax Code is missing.');
   END IF;
END Validate_Tax_Free_Tax_Code;


@UncheckedAccess
PROCEDURE Validate_Tax_Liability(
   tax_liability_    IN VARCHAR2,
   country_code_     IN VARCHAR2)
IS
BEGIN   
   IF NOT (Tax_Liability_API.Check_Exist(tax_liability_, country_code_)) THEN
      Error_SYS.Record_General(lu_name_, 'LIABILITYNOTEXIST: Tax liability does not exist for the delivery address country specified.');
   END IF;
END Validate_Tax_Liability;


PROCEDURE Validate_Calc_Base_In_Struct(
   company_             IN VARCHAR2,
   identity_            IN VARCHAR2,
   delivery_address_id_ IN VARCHAR2,
   supply_country_db_   IN VARCHAR2,
   use_price_incl_tax_  IN VARCHAR2,
   tax_liability_       IN VARCHAR2)
IS
   tax_calc_structure_id_  VARCHAR2(20);
   tax_liability_type_db_  VARCHAR2(20);
BEGIN   
   tax_calc_structure_id_ := Customer_Delivery_Tax_Info_API.Get_Tax_Calc_Structure_Id(identity_, delivery_address_id_, company_, supply_country_db_);
   tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_liability_,
                                                                         supply_country_db_);
   IF (tax_calc_structure_id_ IS NOT NULL) AND (use_price_incl_tax_ = 'TRUE') AND (tax_liability_type_db_ NOT IN (Tax_Liability_Type_API.DB_EXEMPT)) THEN
      Tax_Handling_Util_API.Validate_Calc_Base_In_Struct();
   END IF;
END Validate_Calc_Base_In_Struct;


-------------------- PUBLIC METHODS FOR RECORD CREATION ---------------------

FUNCTION Create_Tax_Line_Param_Rec (   
   company_                   IN VARCHAR2,
   contract_                  IN VARCHAR2,
   customer_no_               IN VARCHAR2,
   ship_addr_no_              IN VARCHAR2,
   planned_ship_date_         IN DATE,
   supply_country_db_         IN VARCHAR2,
   delivery_type_             IN VARCHAR2,
   object_id_                 IN VARCHAR2,
   use_price_incl_tax_        IN VARCHAR2,
   currency_code_             IN VARCHAR2,
   currency_rate_             IN NUMBER,   
   conv_factor_               IN NUMBER,
   from_defaults_             IN BOOLEAN,
   tax_code_                  IN VARCHAR2,
   tax_calc_structure_id_     IN VARCHAR2,
   tax_class_id_              IN VARCHAR2,
   tax_liability_             IN VARCHAR2,
   tax_liability_type_db_     IN VARCHAR2,
   delivery_country_db_       IN VARCHAR2,
   add_tax_lines_             IN BOOLEAN,
   net_curr_amount_           IN NUMBER,
   gross_curr_amount_         IN NUMBER,
   ifs_curr_rounding_         IN NUMBER,
   free_of_charge_tax_basis_  IN NUMBER,
   attr_                      IN VARCHAR2) RETURN tax_line_param_rec
IS 
   tax_line_param_rec_        tax_line_param_rec;
BEGIN  			
   tax_line_param_rec_.company                  := company_;
   tax_line_param_rec_.contract                 := contract_;
   tax_line_param_rec_.customer_no              := customer_no_;
   tax_line_param_rec_.ship_addr_no             := ship_addr_no_; 
   tax_line_param_rec_.planned_ship_date        := planned_ship_date_;
   tax_line_param_rec_.supply_country_db        := supply_country_db_;
   tax_line_param_rec_.delivery_type            := delivery_type_;
   tax_line_param_rec_.object_id                := object_id_;
   tax_line_param_rec_.use_price_incl_tax       := use_price_incl_tax_;
   tax_line_param_rec_.currency_code            := currency_code_;
   tax_line_param_rec_.currency_rate            := currency_rate_;   
   tax_line_param_rec_.conv_factor              := conv_factor_;
   tax_line_param_rec_.from_defaults            := from_defaults_;
   tax_line_param_rec_.tax_code                 := tax_code_;
   tax_line_param_rec_.tax_calc_structure_id    := tax_calc_structure_id_;
   tax_line_param_rec_.tax_class_id             := tax_class_id_;
   tax_line_param_rec_.tax_liability            := tax_liability_;
   tax_line_param_rec_.tax_liability_type_db    := tax_liability_type_db_;
   tax_line_param_rec_.delivery_country_db      := delivery_country_db_;
   tax_line_param_rec_.add_tax_lines            := add_tax_lines_;
   tax_line_param_rec_.net_curr_amount          := net_curr_amount_;
   tax_line_param_rec_.gross_curr_amount        := gross_curr_amount_;
   tax_line_param_rec_.ifs_curr_rounding        := ifs_curr_rounding_;  
   tax_line_param_rec_.free_of_charge_tax_basis := free_of_charge_tax_basis_;
   
   RETURN tax_line_param_rec_;
END Create_Tax_Line_Param_Rec;

-------------------- PUBLIC METHODS FOR COMMON LOGIC ------------------------

PROCEDURE Add_Transaction_Tax_Info (
   line_amount_rec_          OUT Tax_Handling_Util_API.line_amount_rec,   
   multiple_tax_             OUT VARCHAR2,  
   tax_info_table_           OUT Tax_Handling_Util_API.tax_information_table,
   tax_line_param_rec_    IN OUT tax_line_param_rec,
   source_key_rec_        IN     Tax_Handling_Util_API.source_key_rec,   
   attr_                  IN     VARCHAR2)
IS 
BEGIN
   Add_Transaction_Tax_Info___(line_amount_rec_,
                               multiple_tax_,
                               tax_info_table_,
                               tax_line_param_rec_,
                               source_key_rec_,
                               FALSE,
                               attr_);
END Add_Transaction_Tax_Info;
   

-- Modify_Source_Tax_Info
--    Calls from the tax lines dialog when pressing Ok/Apply.
PROCEDURE Modify_Source_Tax_Info (
   company_          IN VARCHAR2,
   source_ref_type_  IN VARCHAR2,
   source_ref1_      IN VARCHAR2,
   source_ref2_      IN VARCHAR2,
   source_ref3_      IN VARCHAR2,
   source_ref4_      IN VARCHAR2,
   source_ref5_      IN VARCHAR2)
IS
   source_key_rec_        Tax_Handling_Util_API.source_key_rec;
   tax_code_on_line_      VARCHAR2(20);
   source_pkg_            VARCHAR2(30);
   tax_calc_structure_id_ VARCHAR2(20);
   tax_code_msg_          VARCHAR2(32000);
   tax_percentage_        NUMBER;
   tax_base_curr_amount_  NUMBER;
BEGIN
   source_pkg_     := Get_Source_Pkg___(source_ref_type_);
   source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_,
                                                                  source_ref1_, 
                                                                  source_ref2_, 
                                                                  source_ref3_, 
                                                                  source_ref4_,
                                                                  source_ref5_,
                                                                  NULL);
                                              
   Source_Tax_Item_API.Get_Tax_Codes(tax_code_msg_,
                                     tax_code_on_line_,
                                     tax_calc_structure_id_,
                                     tax_percentage_, 
                                     tax_base_curr_amount_,
                                     company_, 
                                     source_ref_type_,                                              
                                     source_ref1_, 
                                     source_ref2_, 
                                     source_ref3_,
                                     source_ref4_,
                                     source_ref5_,
                                     'FALSE');                                           
                                                        
   Modify_Source_Tax_Info___(source_key_rec_,
                             tax_code_on_line_, 
                             '',
                             tax_calc_structure_id_);
END Modify_Source_Tax_Info;


-- Get_Source_Pkg
--    Public wrapper method around Get_Source_Pkg___
FUNCTION Get_Source_Pkg (
   source_ref_type_   IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   
   RETURN Get_Source_Pkg___(source_ref_type_);  
END Get_Source_Pkg;


-- Set_To_Default
--   Revert tax lines to default for an order line.
PROCEDURE Set_To_Default (
   tax_calc_structure_id_  OUT VARCHAR2,
   company_                IN  VARCHAR2,
   source_ref_type_        IN  VARCHAR2,
   source_ref1_            IN  VARCHAR2,
   source_ref2_            IN  VARCHAR2,
   source_ref3_            IN  VARCHAR2,
   source_ref4_            IN  VARCHAR2,
   source_ref5_            IN  VARCHAR2,
   copy_addr_to_line_      IN  VARCHAR2 DEFAULT 'FALSE')
IS
   line_amount_rec_       Tax_Handling_Util_API.line_amount_rec;   
   source_key_rec_        Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_    tax_line_param_rec;
   tax_info_table_        Tax_Handling_Util_API.tax_information_table;
   stmt_                  VARCHAR2(2000);
   source_pkg_            VARCHAR2(30);
   multiple_tax_          VARCHAR2(20);
BEGIN                                                        
   source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_,
                                                                  source_ref1_, 
                                                                  source_ref2_, 
                                                                  source_ref3_, 
                                                                  source_ref4_,
                                                                  source_ref5_,                                                                  
                                                                  attr_ => NULL);
                                                                  
   source_pkg_    := Get_Source_Pkg___(source_ref_type_); 
                       
   Assert_Sys.Assert_Is_Package(source_pkg_);                                               
   stmt_  := 'BEGIN :tax_line_param_rec := '||source_pkg_||'.Fetch_Tax_Line_Param(:company, :source_ref1, :source_ref2,
                                                            :source_ref3, :source_ref4); END;';
      @ApproveDynamicStatement(2016-02-29,MAHPLK) 
      EXECUTE IMMEDIATE stmt_
              USING  OUT tax_line_param_rec_,
                     IN  company_,
                     IN  source_key_rec_.source_ref1,
                     IN  source_key_rec_.source_ref2,
                     IN  source_key_rec_.source_ref3,
                     IN  source_key_rec_.source_ref4;
                                                                   
   tax_line_param_rec_.from_defaults         := TRUE;
   tax_line_param_rec_.tax_code              := NULL;
   tax_line_param_rec_.tax_calc_structure_id := NULL;
   tax_line_param_rec_.add_tax_lines         := TRUE;

   
   Add_Transaction_Tax_Info___(line_amount_rec_,
                               multiple_tax_,
                               tax_info_table_,
                               tax_line_param_rec_,
                               source_key_rec_,
                               FALSE,
                               attr_ => NULL,
                               copy_addr_to_line_ => copy_addr_to_line_);
   tax_calc_structure_id_ := tax_line_param_rec_.tax_calc_structure_id;
END Set_To_Default;

--This method is to be used by Aurena
PROCEDURE Tax_Line_Assis_Set_To_Default (   
   tax_info_table_         OUT Tax_Handling_Util_API.tax_information_table,
   line_amount_rec_        OUT Tax_Handling_Util_API.line_amount_rec, 
   tax_calc_structure_id_  OUT VARCHAR2,
   tax_class_id_           OUT VARCHAR2,
   company_                IN  VARCHAR2, 
   package_name_           IN  VARCHAR2,
   source_ref_type_db_     IN  VARCHAR2,
   source_ref1_            IN  VARCHAR2,
   source_ref2_            IN  VARCHAR2,   
   source_ref3_            IN  VARCHAR2, 
   source_ref4_            IN  VARCHAR2, 
   source_ref5_            IN  VARCHAR2, 
   calc_base_              IN  VARCHAR2 )
IS
   --line_amount_rec_       Tax_Handling_Util_API.line_amount_rec;   
   source_key_rec_        Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_    tax_line_param_rec;
   stmt_                  VARCHAR2(2000);
   source_pkg_            VARCHAR2(30);
   multiple_tax_          VARCHAR2(20);  
BEGIN
   IF (Fnd_Session_API.Is_Odp_Session) THEN
      source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_db_,
                                                                     source_ref1_, 
                                                                     source_ref2_, 
                                                                     source_ref3_, 
                                                                     source_ref4_,
                                                                     source_ref5_,                                                                  
                                                                     attr_ => NULL);

      source_pkg_    := Get_Source_Pkg___(source_ref_type_db_); 

      Assert_Sys.Assert_Is_Package(source_pkg_);                                               
      stmt_  := 'BEGIN :tax_line_param_rec := '||source_pkg_||'.Fetch_Tax_Line_Param(:company, :source_ref1, :source_ref2,
                                                               :source_ref3, :source_ref4); END;';
         @ApproveDynamicStatement(2016-02-29,MAHPLK) 
         EXECUTE IMMEDIATE stmt_
                 USING  OUT tax_line_param_rec_,
                        IN  company_,
                        IN  source_key_rec_.source_ref1,
                        IN  source_key_rec_.source_ref2,
                        IN  source_key_rec_.source_ref3,
                        IN  source_key_rec_.source_ref4;

      tax_line_param_rec_.from_defaults         := TRUE;
      tax_line_param_rec_.tax_code              := NULL;
      tax_line_param_rec_.tax_calc_structure_id := NULL;
      tax_line_param_rec_.add_tax_lines         := FALSE;


      Add_Transaction_Tax_Info___(line_amount_rec_,
                                 multiple_tax_,
                                 tax_info_table_,
                                 tax_line_param_rec_,
                                 source_key_rec_,
                                 FALSE,
                                 attr_ => NULL);
                           
      tax_calc_structure_id_ := tax_line_param_rec_.tax_calc_structure_id; 
      tax_class_id_ := tax_line_param_rec_.tax_class_id;
   END IF;
END Tax_Line_Assis_Set_To_Default;

PROCEDURE Add_Source_Tax_Invoic_Lines (
   tax_info_table_  IN Tax_Handling_Util_API.tax_information_table,
   company_         IN VARCHAR2,
   source_ref1_     IN VARCHAR2,
   source_ref2_     IN VARCHAR2,
   source_ref3_     IN  VARCHAR2,
   source_ref4_     IN  VARCHAR2,
   source_ref5_     IN  VARCHAR2,
   source_ref_type_ IN  VARCHAR2)
IS
   source_key_rec_  Tax_Handling_Util_API.source_key_rec;
   attr_                      VARCHAR2(2000);
BEGIN
   source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_,
                                                                  source_ref1_, 
                                                                  source_ref2_, 
                                                                  source_ref3_, 
                                                                  source_ref4_,
                                                                  source_ref5_,
                                                                  attr_);
   Source_Tax_Item_Invoic_API.Create_Tax_Items(company_, 'FALSE', 'TRUE', source_key_rec_, tax_info_table_); 
END Add_Source_Tax_Invoic_Lines;


PROCEDURE Transfer_Tax_lines (
   company_                    IN  VARCHAR2,
   from_source_ref_type_       IN  VARCHAR2,
   from_source_ref1_           IN  VARCHAR2,
   from_source_ref2_           IN  VARCHAR2,
   from_source_ref3_           IN  VARCHAR2,
   from_source_ref4_           IN  VARCHAR2,
   from_source_ref5_           IN  VARCHAR2,
   to_source_ref_type_         IN  VARCHAR2,
   to_source_ref1_             IN  VARCHAR2,
   to_source_ref2_             IN  VARCHAR2,
   to_source_ref3_             IN  VARCHAR2,
   to_source_ref4_             IN  VARCHAR2,
   to_source_ref5_             IN  VARCHAR2)
IS
   source_tax_table_ Source_Tax_Item_API.source_tax_table;
BEGIN
   source_tax_table_  := Source_Tax_Item_API.Get_Tax_Items(company_, from_source_ref_type_, from_source_ref1_, from_source_ref2_, from_source_ref3_, from_source_ref4_, from_source_ref5_);
   -- Create tax lines from from source
   IF (source_tax_table_.COUNT > 0) THEN
      FOR i IN source_tax_table_.FIRST .. source_tax_table_.LAST LOOP
         -- gelr:br_external_tax_integration, added cst_code and legal_tax_class
         Source_Tax_Item_Order_API.New(company_, to_source_ref_type_, to_source_ref1_, to_source_ref2_, to_source_ref3_, to_source_ref4_,
                                       to_source_ref5_, source_tax_table_(i).tax_item_id, source_tax_table_(i).tax_code,
                                       source_tax_table_(i).tax_calc_structure_id, source_tax_table_(i).tax_calc_structure_item_id,
                                       source_tax_table_(i).tax_percentage, source_tax_table_(i).tax_curr_amount, 
                                       source_tax_table_(i).tax_dom_amount, source_tax_table_(i).tax_base_curr_amount, source_tax_table_(i).tax_base_dom_amount,
                                       source_tax_table_(i).cst_code, source_tax_table_(i).legal_tax_class,
                                       source_tax_table_(i).tax_category1, source_tax_table_(i).tax_category2);
      END LOOP;
   END IF;
END Transfer_Tax_lines;


PROCEDURE Transfer_Tax_lines (
   company_                   IN VARCHAR2,
   copy_from_source_ref_type_ IN VARCHAR2, 
   copy_from_source_ref1_     IN VARCHAR2,
   copy_from_source_ref2_     IN VARCHAR2,
   copy_from_source_ref3_     IN VARCHAR2,
   copy_from_source_ref4_     IN VARCHAR2,
   copy_from_source_ref5_     IN VARCHAR2,
   copy_to_source_ref_type_   IN VARCHAR2, 
   copy_to_source_ref1_       IN VARCHAR2,
   copy_to_source_ref2_       IN VARCHAR2,
   copy_to_source_ref3_       IN VARCHAR2,
   copy_to_source_ref4_       IN VARCHAR2,
   copy_to_source_ref5_       IN VARCHAR2,
   recalc_amounts_            IN VARCHAR2,
   refetch_curr_rate_         IN VARCHAR2)
IS
   copy_from_source_key_rec_  Tax_Handling_Util_API.source_key_rec;
   copy_to_source_key_rec_    Tax_Handling_Util_API.source_key_rec;
   attr_                      VARCHAR2(2000);
BEGIN
   copy_from_source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(copy_from_source_ref_type_,
                                                                            copy_from_source_ref1_, 
                                                                            copy_from_source_ref2_, 
                                                                            copy_from_source_ref3_, 
                                                                            copy_from_source_ref4_,
                                                                            copy_from_source_ref5_,
                                                                            attr_); 
   copy_to_source_key_rec_   := Tax_Handling_Util_API.Create_Source_Key_Rec(copy_to_source_ref_type_,
                                                                            copy_to_source_ref1_, 
                                                                            copy_to_source_ref2_, 
                                                                            copy_to_source_ref3_, 
                                                                            copy_to_source_ref4_,
                                                                            copy_to_source_ref5_,
                                                                            attr_);
                                                                            
   Recalc_And_Save_Tax_lines___(company_, 
                                copy_from_source_key_rec_, 
                                copy_to_source_key_rec_, 
                                recalc_amounts_,
                                refetch_curr_rate_);
END Transfer_Tax_lines;

-- Get_First_Tax_Code
--   Returns the first tax code of the min tax_item_id.
@UncheckedAccess
FUNCTION Get_First_Tax_Code (
   company_            IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2) RETURN VARCHAR2
IS
   temp_  source_tax_item_tab.tax_code%TYPE;
   local_source_ref4_ source_tax_item_tab.source_ref4%TYPE := source_ref4_;

   CURSOR get_attr IS
      SELECT tax_code
      FROM source_tax_item_base_pub
      WHERE company = company_
      AND   source_ref_type_db = source_ref_type_db_
      AND   source_ref1 = source_ref1_
      AND   source_ref2 = source_ref2_
      AND   source_ref3 = source_ref3_
      AND   source_ref4 = local_source_ref4_
      AND   tax_item_id IN (
            SELECT MIN(tax_item_id)
               FROM source_tax_item_base_pub
               WHERE company = company_
               AND   source_ref_type_db = source_ref_type_db_
               AND   source_ref1 = source_ref1_
               AND   source_ref2 = source_ref2_
               AND   source_ref3 = source_ref3_
               AND   source_ref4 = local_source_ref4_);
BEGIN
   BEGIN
      IF to_number(local_source_ref4_) > 0 THEN
	      local_source_ref4_ := '-1';
	   END IF;
   EXCEPTION
   -- If * passed, just ignore the conversion error
      WHEN OTHERS THEN NULL;
   END;
   
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_First_Tax_Code;

@IgnoreUnitTest DynamicStatement
PROCEDURE Get_External_Tax_Info___ (
   attr_            OUT VARCHAR2,
   source_ref1_     IN VARCHAR2,
   source_ref2_     IN VARCHAR2,
   source_ref3_     IN VARCHAR2,
   source_ref4_     IN VARCHAR2,
   source_ref_type_ IN VARCHAR2,
   company_         IN VARCHAR2)
IS
   source_pkg_                   VARCHAR2(30);
   stmt_                         VARCHAR2(2000);    
BEGIN
   source_pkg_  := Get_Source_Pkg___(source_ref_type_);
   Assert_Sys.Assert_Is_Package(source_pkg_);

   -- Get the line original qty
   stmt_  := 'BEGIN
                 '||source_pkg_||'.Get_External_Tax_Info(:attr, :rec_source_ref1, :rec_source_ref2, :rec_source_ref3, :rec_source_ref4, :company);
              END;';

   @ApproveDynamicStatement(2021-06-02, NiDalk) 
   EXECUTE IMMEDIATE stmt_
     USING OUT attr_,
           IN  source_ref1_,
           IN  source_ref2_,
           IN  source_ref3_,
           IN  source_ref4_,
           IN  company_; 
           
END Get_External_Tax_Info___;

-------------------- PUBLIC METHODS FOR IPD TAX HANDLING --------------------

-- Check_Ipd_Tax_Registration
--    This method returns TRUE, if the delivery address country on the CO line
--    is different than the supply_country_db_, and the company_ has a tax
--    registration in the delivery_country_db_, when supply_code_db_ is IPD.
@UncheckedAccess
FUNCTION Check_Ipd_Tax_Registration (
   company_             IN VARCHAR2,
   contract_            IN VARCHAR2,
   supply_code_db_      IN VARCHAR2,
   supply_country_db_   IN VARCHAR2,
   delivery_country_db_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   show_info_    BOOLEAN := FALSE;
BEGIN
   IF (supply_code_db_ = 'IPD') AND (supply_country_db_ != delivery_country_db_) THEN
      IF (Tax_Liability_Countries_API.Check_Valid_Info_Exist(company_, delivery_country_db_, Site_API.Get_Site_Date(contract_)) = 'TRUE') THEN
         show_info_ := TRUE;
      END IF;
   END IF;
   RETURN show_info_;
END Check_Ipd_Tax_Registration;


-- Get_Ipd_Tax_Info
--    Returns IPD tax liability, tax number, validate date and IPD tax free tax code 
--    by retrieval of IPD tax info. This method is called in the IPD flow (from ORDER and PURCH).
PROCEDURE Get_Ipd_Tax_Info (
   ipd_tax_liability_         OUT VARCHAR2,
   ipd_tax_no_                OUT VARCHAR2,
   ipd_validated_date_        OUT DATE,
   ipd_tax_free_tax_code_     OUT VARCHAR2,
   customer_no_               IN  VARCHAR2,
   contract_                  IN  VARCHAR2,
   delivery_address_id_       IN  VARCHAR2,
   single_occ_address_        IN  VARCHAR2,   
   addr_country_code_         IN  VARCHAR2,
   supply_site_               IN  VARCHAR2,
   delivery_type_             IN  VARCHAR2 )
IS
   supply_country_             VARCHAR2(740);
   company_                    VARCHAR2(20);
   supplier_company_           VARCHAR2(20);   
   ipd_addr_info_exist_        VARCHAR2(5);
   ipd_addr_tax_free_exist_    VARCHAR2(5);
   supply_country_db_          VARCHAR2(2);
   cust_ipd_tax_info_addr_rec_ customer_ipd_tax_info_addr_tab%ROWTYPE;
   cust_ipd_tax_info_inv_rec_  customer_ipd_tax_info_inv_tab%ROWTYPE;
   sup_site_rec_               Site_API.Public_Rec;
   supp_site_del_addr_         VARCHAR2(200);
   tax_liability_type_db_      VARCHAR2(20); 
BEGIN   
   sup_site_rec_         := Site_API.Get(supply_site_);
   supp_site_del_addr_   := sup_site_rec_.delivery_address;
   supplier_company_     := sup_site_rec_.company;   
   supply_country_       := Company_Address_API.Get_Country(supplier_company_, supp_site_del_addr_); 
   supply_country_db_    := Company_Address_API.Get_Country_Db(supplier_company_, supp_site_del_addr_);      
   company_             := Site_API.Get_Company(contract_);    
   ipd_addr_info_exist_ := Customer_Ipd_Tax_Info_Addr_API.Check_Exist(customer_no_, delivery_address_id_, company_, supplier_company_, supply_country_db_);
   IF (single_occ_address_ != 'Y' AND ipd_addr_info_exist_ = 'TRUE') THEN
      cust_ipd_tax_info_addr_rec_ := Customer_Ipd_Tax_Info_Addr_API.Fetch_Ipd_Tax_Info(customer_no_, delivery_address_id_, company_, supplier_company_, supply_country_db_);
      ipd_tax_liability_  := cust_ipd_tax_info_addr_rec_.tax_liability;
      ipd_tax_no_         := cust_ipd_tax_info_addr_rec_.vat_no;
      ipd_validated_date_ := cust_ipd_tax_info_addr_rec_.validated_date;
      tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(ipd_tax_liability_,Customer_Info_Address_API.Get_Country_Db(customer_no_, delivery_address_id_ ));
   ELSE
      cust_ipd_tax_info_inv_rec_ := Customer_Ipd_Tax_Info_Inv_API.Fetch_Ipd_Tax_Info(company_, customer_no_, 'CUSTOMER', supplier_company_, supply_country_db_, addr_country_code_);
      ipd_tax_liability_  := cust_ipd_tax_info_inv_rec_.tax_liability;
      ipd_tax_no_         := cust_ipd_tax_info_inv_rec_.vat_no;
      ipd_validated_date_ := cust_ipd_tax_info_inv_rec_.validated_date;
      tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(ipd_tax_liability_, addr_country_code_);
   END IF;
   -- Fetch IPD tax free tax code.
   IF (tax_liability_type_db_ = Tax_Liability_Type_API.DB_EXEMPT) THEN
      ipd_addr_tax_free_exist_ := Ipd_Addr_Tax_Free_Tax_Code_API.Check_Exist(customer_no_, delivery_address_id_, company_, supplier_company_, supply_country_db_, delivery_type_);
      IF (single_occ_address_ != 'Y' AND ipd_addr_tax_free_exist_ = 'TRUE') THEN
         ipd_tax_free_tax_code_ := Ipd_Addr_Tax_Free_Tax_Code_API.Get_Tax_Free_Tax_Code(customer_no_, delivery_address_id_, company_, supplier_company_, supply_country_db_, delivery_type_);
      ELSE
         ipd_tax_free_tax_code_ := Ipd_Inv_Tax_Free_Tax_Code_API.Get_Tax_Free_Tax_Code(company_, customer_no_, 'CUSTOMER', supplier_company_, ISO_Country_API.Encode(supply_country_), addr_country_code_, delivery_type_);
      END IF;
   END IF;
END Get_Ipd_Tax_Info;

-------------------- PUBLIC METHODS FOR ADVANCE INVOICE TAX HANDLING --------


FUNCTION Calculate_Adv_Inv_Tax_To_Msg (  
   tax_msg_                IN     VARCHAR2,
   tax_calc_structure_id_  IN     VARCHAR2,
   company_                IN     VARCHAR2,
   line_gross_curr_amount_ IN     NUMBER,
   line_net_curr_amount_   IN     NUMBER,
   price_type_             IN     VARCHAR2,
   tax_liability_date_     IN     DATE,
   source_ref_type_        IN     VARCHAR2,
   identity_               IN     VARCHAR2,
   currency_code_          IN     VARCHAR2 ,
   ship_addr_no_           IN     VARCHAR2,
   ifs_curr_rounding_      IN     NUMBER) RETURN VARCHAR2
   
IS
   line_amount_rec_      Tax_Handling_Util_API.line_amount_rec;
   tax_info_table_       Tax_Handling_Util_API.tax_information_table;
   validation_rec_       Tax_Handling_Util_API.validation_rec;
   attr_                 VARCHAR2(2000);
   out_tax_msg_          VARCHAR2(32000);
   dummy_currency_type_  VARCHAR2(10);
   dummy_conv_factor_    NUMBER;
   currency_rate_        NUMBER;
BEGIN 
   Invoice_Library_API.Get_Currency_Rate_Defaults(dummy_currency_type_, dummy_conv_factor_, currency_rate_,
                                                  company_,currency_code_, tax_liability_date_, Party_Type_API.DB_CUSTOMER,
                                                  identity_);
   IF (tax_calc_structure_id_ IS NOT NULL) AND (tax_msg_ IS NULL) THEN
      validation_rec_ := Tax_Handling_Util_API.Create_Validation_Rec(price_type_, 'FETCH_ALWAYS', 'TRUE', NULL);
      Tax_Handling_Util_API.Fetch_Tax_Codes_On_Tax_Str (tax_info_table_,
                                                        company_,
                                                        Party_Type_API.DB_CUSTOMER,
                                                        tax_calc_structure_id_,
                                                        tax_liability_date_,
                                                        validation_rec_);   
   END IF;
   Fetch_And_Calc_Tax_From_Msg (line_amount_rec_, tax_info_table_, attr_, tax_msg_, company_, line_gross_curr_amount_, line_net_curr_amount_,
                                price_type_, 'TRUE', tax_liability_date_, currency_rate_, source_ref_type_, NULL, NULL, NULL, NULL, NULL,
                                identity_, currency_code_, ship_addr_no_, ifs_curr_rounding_);
   
   IF (tax_info_table_.COUNT > 0) THEN
      out_tax_msg_ := Message_SYS.Construct('TAX_INFORMATION');
      FOR i IN 1..tax_info_table_.COUNT LOOP
         IF (Message_SYS.Get_Name(out_tax_msg_) = 'TAX_INFORMATION') THEN
            Message_SYS.Add_Attribute(out_tax_msg_, 'TAX_CODE',        tax_info_table_(i).tax_code);
            Message_SYS.Add_Attribute(out_tax_msg_, 'TAX_PERCENTAGE',  tax_info_table_(i).tax_percentage); 
            Message_SYS.Add_Attribute(out_tax_msg_, 'TAX_CALC_STRUCTURE_ID', tax_info_table_(i).tax_calc_structure_id);
            Message_SYS.Add_Attribute(out_tax_msg_, 'TAX_CALC_STRU_DESC', Tax_Calc_Structure_API.Get_Description(company_,tax_info_table_(i).tax_calc_structure_id));
            Message_SYS.Add_Attribute(out_tax_msg_, 'TAX_CALC_STRUCTURE_ITEM_ID', tax_info_table_(i).tax_calc_structure_item_id);
            Message_SYS.Add_Attribute(out_tax_msg_, 'TAX_CURR_AMOUNT', tax_info_table_(i).tax_curr_amount);
            Message_SYS.Add_Attribute(out_tax_msg_, 'TAX_BASE_CURR_AMOUNT', tax_info_table_(i).tax_base_curr_amount);
         END IF;
      END LOOP;
   END IF;
   RETURN out_tax_msg_;   
END Calculate_Adv_Inv_Tax_To_Msg;


FUNCTION Populate_Initial_Adv_Inv_Tax(
   line_gross_curr_amount_ IN NUMBER,
   line_net_curr_amount_   IN NUMBER,
   price_type_             IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   company_                IN VARCHAR2,
   tax_liability_date_     IN DATE,
   pay_tax_                IN VARCHAR2,
   with_charges_           IN VARCHAR2,
   identity_               IN VARCHAR2,
   currency_               IN VARCHAR2,
   ifs_curr_rounding_      IN NUMBER,
   address_id_             IN VARCHAR2,
   supply_country_db_      IN VARCHAR2,
   delivery_type_          IN VARCHAR2) RETURN VARCHAR2

IS
   CURSOR get_info_from_first_line (with_charges_ IN VARCHAR2,
                                     company_      IN VARCHAR2,
                                     source_ref1_  IN VARCHAR2)IS
      SELECT sto.source_ref2,
             sto.source_ref3,
             sto.source_ref4,
             sto.source_ref5,
             sto.source_ref_type_db
      FROM   source_tax_item_base_pub sto
      WHERE  sto.company     = company_
      AND    sto.source_ref1 = source_ref1_
      AND    sto.source_ref_type_db IN (SELECT 'CUSTOMER_ORDER_LINE'  
                                        FROM   customer_order_line_tab col 
                                        WHERE  sto.source_ref1 = col.order_no
                                        AND    sto.source_ref2 = col.line_no
                                        AND    sto.source_ref3 = col.rel_no
                                        AND    sto.source_ref4 = col.line_item_no
                                        AND    col.rowstate != 'Cancelled' 
                                    UNION ALL 
                                       SELECT 'CUSTOMER_ORDER_CHARGE'
                                       FROM   customer_order_charge_tab coc
                                       WHERE  with_charges_   = 'TRUE'
                                       AND    sto.source_ref1 = coc.order_no
                                       AND    sto.source_ref2 = coc.sequence_no);
      
   CURSOR get_tax_free_tax_prop (company_  IN VARCHAR2,
                                 fee_code_ IN VARCHAR2) IS
      SELECT fee_code    tax_code,
             Statutory_Fee_API.Get_Percentage(company, fee_code) tax_percentage,
             0 tax_amount
      FROM  tax_code_restricted
      WHERE company  = company_ 
      AND   fee_code = fee_code_;   
      
   tax_free_tax_code_   VARCHAR2(20);
   source_ref2_         VARCHAR2(50);
   source_ref3_         VARCHAR2(50);
   source_ref4_         VARCHAR2(50);
   source_ref5_         VARCHAR2(50);
   source_ref_type_db_  VARCHAR2(50);
   out_tax_msg_         VARCHAR2(32000);
   in_tax_msg_          VARCHAR2(32000);
   m_s_names_           Message_SYS.name_table;
   m_s_values_          Message_SYS.line_table;
   count_               NUMBER;
BEGIN
   IF pay_tax_= 'TRUE' THEN
      OPEN get_info_from_first_line(with_charges_, company_, source_ref1_);
      FETCH get_info_from_first_line INTO source_ref2_, source_ref3_, source_ref4_, source_ref5_, source_ref_type_db_;
      CLOSE get_info_from_first_line;
      Source_Tax_Item_API.Get_Tax_Item_Msg(in_tax_msg_, company_, source_ref_type_db_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref5_);
      IF (Message_SYS.Get_Name(in_tax_msg_) = 'TAX_INFORMATION') THEN
         Message_SYS.Get_Attributes(in_tax_msg_, count_, m_s_names_, m_s_values_);
         FOR i IN 1..count_  LOOP
            IF (m_s_names_(i) = 'TAX_CURR_AMOUNT') THEN
               Message_SYS.Remove_Attribute(in_tax_msg_, 'TAX_CURR_AMOUNT');
            END IF;
         END LOOP;
      END IF; 
   ELSE
      tax_free_tax_code_ := Customer_Tax_Free_Tax_Code_API.Get_Tax_Free_Tax_Code(identity_,address_id_,company_,supply_country_db_,delivery_type_);
      in_tax_msg_ := Message_SYS.Construct('TAX_INFORMATION');
      IF (Message_SYS.Get_Name(in_tax_msg_) = 'TAX_INFORMATION') THEN
         FOR tax_free_rec_ IN get_tax_free_tax_prop (company_,tax_free_tax_code_)LOOP
            Message_SYS.Add_Attribute(in_tax_msg_, 'TAX_CODE',        tax_free_rec_.tax_code);
            Message_SYS.Add_Attribute(in_tax_msg_, 'TAX_PERCENTAGE',  tax_free_rec_.tax_percentage);
            Message_SYS.Add_Attribute(in_tax_msg_, 'TAX_CURR_AMOUNT', tax_free_rec_.tax_amount);
         END LOOP;
      END IF; 
   END IF;
   out_tax_msg_ := Calculate_Adv_Inv_Tax_To_Msg (in_tax_msg_ ,
                                                 NULL,
                                                 company_,
                                                 line_gross_curr_amount_,
                                                 line_net_curr_amount_ ,
                                                 price_type_ ,
                                                 tax_liability_date_,
                                                 NVL(source_ref_type_db_,Tax_source_API.DB_CUSTOMER_ORDER_LINE),
                                                 identity_,
                                                 currency_,
                                                 address_id_,
                                                 ifs_curr_rounding_);
   RETURN out_tax_msg_;
END Populate_Initial_Adv_Inv_Tax;


-------------------- PUBLIC METHODS FOR VERTEX TAX HANDLING -----------------
   

PROCEDURE Write_To_Ext_Tax_Register(
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER,
   item_id_       IN NUMBER,
   xml_trans_     IN CLOB DEFAULT NULL,
   counter_       IN NUMBER DEFAULT NULL,
   add_tax_lines_ IN VARCHAR2 DEFAULT 'TRUE')
IS 
   line_amount_rec_       Tax_Handling_Util_API.line_amount_rec;   
   source_key_rec_        Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_    tax_line_param_rec;   
   multiple_tax_          VARCHAR2(20);
   tax_info_table_        Tax_Handling_Util_API.tax_information_table;
BEGIN
   source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_INVOICE,
                                                                  invoice_id_, 
                                                                  item_id_, 
                                                                  '*', 
                                                                  '*',
                                                                  '*',                                                                  
                                                                  attr_ => NULL);
                     
   tax_line_param_rec_ := Customer_Order_Inv_Item_API.Fetch_Tax_Line_Param(company_, invoice_id_, item_id_, '*', '*');                                              
              
   tax_line_param_rec_.from_defaults         := TRUE;
   tax_line_param_rec_.tax_code              := NULL;
   tax_line_param_rec_.tax_calc_structure_id := NULL;
   tax_line_param_rec_.add_tax_lines         := TRUE; 
   tax_line_param_rec_.write_to_ext_tax_register := 'TRUE'; 
   
   IF add_tax_lines_ = 'TRUE' THEN 
      tax_line_param_rec_.add_tax_lines         := TRUE; 
   ELSE
      tax_line_param_rec_.add_tax_lines         := FALSE;
   END IF;
   
   Add_Transaction_Tax_Info___(line_amount_rec_,
                              multiple_tax_,
                              tax_info_table_,
                              tax_line_param_rec_,
                              source_key_rec_,
                              FALSE,
                              attr_ => NULL,
                              xml_trans_ => xml_trans_,
                              counter_   => counter_);
   
END Write_To_Ext_Tax_Register;

PROCEDURE Fetch_External_Tax_Info (
   tax_msg_                      OUT VARCHAR2,
   line_net_curr_amount_      IN  NUMBER,
   source_ref1_               IN     VARCHAR2,
   source_ref2_               IN     VARCHAR2,
   source_ref3_               IN     VARCHAR2,
   source_ref4_               IN     VARCHAR2,
   source_ref5_               IN     VARCHAR2,
   source_ref_type_           IN     VARCHAR2,
   company_                   IN     VARCHAR2,
   contract_                  IN     VARCHAR2,
   customer_no_               IN     VARCHAR2,   
   object_id_                 IN     VARCHAR2,
   quantity_                  IN     NUMBER,
   tax_liability_             IN     VARCHAR2,
   tax_liability_type_db_     IN     VARCHAR2,
   attr_                      IN     VARCHAR2)   
IS
   tax_info_table_         Tax_Handling_Util_API.tax_information_table;   
   sales_object_type_      VARCHAR2(30);
   multiple_tax_           VARCHAR2(20);
   source_key_rec_         Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_     tax_line_param_rec;
BEGIN
   source_key_rec_   := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_,
                                                                    source_ref1_, 
                                                                    source_ref2_, 
                                                                    source_ref3_, 
                                                                    source_ref4_,
                                                                    source_ref5_,
                                                                    attr_);
      

   tax_line_param_rec_.company         := company_;
   tax_line_param_rec_.contract        := contract_;
   tax_line_param_rec_.customer_no     := customer_no_;
   tax_line_param_rec_.object_id       := object_id_;
   tax_line_param_rec_.use_price_incl_tax := 'FALSE';
   tax_line_param_rec_.from_defaults   := TRUE;
   tax_line_param_rec_.tax_liability   := tax_liability_;
   tax_line_param_rec_.tax_liability_type_db := tax_liability_type_db_;
   tax_line_param_rec_.add_tax_lines   := FALSE;
   tax_line_param_rec_.net_curr_amount := line_net_curr_amount_;   
   tax_line_param_rec_.quantity        := quantity_;
   
   sales_object_type_  := Get_Sales_Object_Type___(tax_line_param_rec_.company, source_key_rec_);
   
   Fetch_External_Tax_Info___(multiple_tax_,
                              tax_info_table_,
                              tax_line_param_rec_,
                              source_key_rec_,
                              sales_object_type_,
                              'TRUE',
                              attr_);
   
   IF (tax_info_table_.COUNT > 0) THEN
      Tax_Handling_Util_API.Create_Tax_Message(tax_msg_, tax_line_param_rec_.company, 'FALSE', tax_info_table_);
   END IF;
END Fetch_External_Tax_Info;

-------------------- PUBLIC METHODS FOR AVALARA TAX HANDLING ----------------
FUNCTION Get_Cust_Tax_Usage_Type(
   source_key_rec_      IN     Tax_Handling_Util_API.source_key_rec,
   identity_            IN     VARCHAR2,
   company_             IN     VARCHAR2) RETURN VARCHAR2
IS
   cust_usage_type_ Customer_Order_Tab.Customer_Tax_Usage_Type%TYPE;
BEGIN
   IF (source_key_rec_.source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_LINE) THEN
      cust_usage_type_ := Customer_Order_Line_API.Get_Customer_Tax_Usage_Type(source_key_rec_.source_ref1,source_key_rec_.source_ref2,source_key_rec_.source_ref3,source_key_rec_.source_ref4);
   ELSIF (source_key_rec_.source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE) THEN
      cust_usage_type_ := Customer_Order_Charge_API.Get_Customer_Tax_Usage_Type(source_key_rec_.source_ref1,source_key_rec_.source_ref2);
   ELSIF (source_key_rec_.source_ref_type = Tax_Source_API.DB_ORDER_QUOTATION_LINE) THEN
      cust_usage_type_ := order_quotation_Line_API.Get_Customer_Tax_Usage_Type(source_key_rec_.source_ref1,source_key_rec_.source_ref2,source_key_rec_.source_ref3,source_key_rec_.source_ref4);
   ELSIF (source_key_rec_.source_ref_type = Tax_Source_API.DB_ORDER_QUOTATION_CHARGE) THEN  
      cust_usage_type_ := order_quotation_Charge_API.Get_Customer_Tax_Usage_Type(source_key_rec_.source_ref1,source_key_rec_.source_ref2);
   ELSIF (source_key_rec_.source_ref_type = Tax_Source_API.DB_RETURN_MATERIAL_LINE) THEN  
      cust_usage_type_ := Return_Material_Line_API.Get_Customer_Tax_Usage_Type(source_key_rec_.source_ref1,source_key_rec_.source_ref2);
   ELSIF (source_key_rec_.source_ref_type = Tax_Source_API.DB_RETURN_MATERIAL_CHARGE) THEN  
      cust_usage_type_ := Return_Material_Charge_API.Get_Customer_Tax_Usage_Type(source_key_rec_.source_ref1,source_key_rec_.source_ref2);   
   ELSIF (source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE) THEN  
      cust_usage_type_ := Invoice_Item_API.Get_Customer_Tax_Usage_Type( company_,source_key_rec_.source_ref1,source_key_rec_.source_ref2);
   END IF;
   RETURN cust_usage_type_;
END Get_Cust_Tax_Usage_Type;

FUNCTION Get_Connected_Cust_Usage_Type(
            company_    IN VARCHAR2,
            invoice_id_ IN NUMBER,
            item_id_    IN NUMBER,
            identity_   IN VARCHAR2) RETURN VARCHAR2
IS
   order_no_                  CUSTOMER_ORDER_INV_ITEM.order_no%TYPE;
   line_no_                   CUSTOMER_ORDER_INV_ITEM.line_no%TYPE;
   line_item_no_              CUSTOMER_ORDER_INV_ITEM.line_item_no%TYPE;
   rel_no_                    CUSTOMER_ORDER_INV_ITEM.release_no%TYPE;
   rma_no_                    CUSTOMER_ORDER_INV_ITEM.rma_no%TYPE;
   rma_line_no_               CUSTOMER_ORDER_INV_ITEM.rma_line_no%TYPE;
   charge_seq_no_             CUSTOMER_ORDER_INV_ITEM.charge_seq_no%TYPE;
   cust_usage_tax_type_       VARCHAR2(25);
   
   CURSOR get_connected_line_info IS
      SELECT order_no,line_no,release_no,line_item_no,rma_no,rma_line_no,charge_seq_no
      FROM   CUSTOMER_ORDER_INV_ITEM t
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
BEGIN
   OPEN get_connected_line_info;
   FETCH get_connected_line_info INTO order_no_,line_no_,rel_no_,line_item_no_,rma_no_,rma_line_no_,charge_seq_no_;
   CLOSE get_connected_line_info;
   
   IF (rma_no_ IS NOT NULL AND rma_line_no_ IS NOT NULL ) THEN
      order_no_     := Return_Material_Line_API.Get_Order_No(rma_no_,rma_line_no_);
      line_no_      := Return_Material_Line_API.Get_Line_No(rma_no_,rma_line_no_);
      IF (line_no_ IS NOT NULL) THEN
         rel_no_       := Return_Material_Line_API.Get_Rel_No(rma_no_,rma_line_no_);
         line_item_no_ := Return_Material_Line_API.Get_Line_Item_No(rma_no_,rma_line_no_); 
         cust_usage_tax_type_ := Customer_Order_Line_API.Get_Customer_Tax_Usage_Type(order_no_,line_no_,rel_no_,line_item_no_);
      END IF;
   ELSIF (line_no_ IS NOT NULL) THEN
      cust_usage_tax_type_ := Customer_Order_Line_API.Get_Customer_Tax_Usage_Type(order_no_,line_no_,rel_no_,line_item_no_);
   ELSIF (charge_seq_no_ IS NOT NULL) THEN
      cust_usage_tax_type_ := Customer_Order_Charge_API.Get_Co_Line_Cust_Tax_Usg_Type(order_no_,charge_seq_no_);
   END IF;
   RETURN NVL(cust_usage_tax_type_,Customer_Info_API.Get_Customer_Tax_Usage_Type(identity_));
END Get_Connected_Cust_Usage_Type;


PROCEDURE Write_To_Ext_Avalara_Tax_Regis(
                  company_    IN VARCHAR2,
                  invoice_id_ IN NUMBER,
                  xml_trans_  IN CLOB)
IS
   counter_       NUMBER := 1;
   inv_rec_       Invoice_API.Public_Rec; 
   tax_line_param_rec_     tax_line_param_rec;
   tax_source_object_rec_  Tax_Handling_Util_API.tax_source_object_rec;
   tax_liability_type_db_  VARCHAR2(20);
   attr_                   VARCHAR2(2000);
   address1_               VARCHAR2(35);
   address2_               VARCHAR2(35);
   country_code_           VARCHAR2(2);
   city_                   VARCHAR2(35);
   state_                  VARCHAR2(35);
   zip_code_               VARCHAR2(35);
   county_                 VARCHAR2(35);
   in_city_                VARCHAR2(5);
   customer_taxable_       VARCHAR2(5); 
   source_key_rec_         Tax_Handling_Util_API.source_key_rec;
   sales_object_type_      VARCHAR2(30); 

CURSOR get_co_inv_item IS
      SELECT item_id
      FROM   customer_order_inv_item
      WHERE  invoice_id = invoice_id_
      AND    company    = company_
      AND    prel_update_allowed = 'TRUE';
BEGIN
   inv_rec_ := Invoice_API.Get(company_, invoice_id_);
   
   FOR inv_item_rec_ IN get_co_inv_item LOOP 
        source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_INVOICE,
                                                                       invoice_id_, 
                                                                       inv_item_rec_.item_id, 
                                                                       '*', 
                                                                       '*',
                                                                       '*',                                                                  
                                                                       attr_ => NULL);
                                                                    
         Customer_Order_Inv_Item_API.Get_Line_Address_Info(address1_,
                                                           address2_,
                                                           country_code_, 
                                                           city_, 
                                                           state_, 
                                                           zip_code_, 
                                                           county_, 
                                                           in_city_,
                                                           invoice_id_, 
                                                           inv_item_rec_.item_id, 
                                                           '*', 
                                                           '*', 
                                                           company_);
         
         tax_line_param_rec_    := Customer_Order_Inv_Item_API.Fetch_Tax_Line_Param(company_, invoice_id_, inv_item_rec_.item_id, '*', '*'); 
         sales_object_type_     := Get_Sales_Object_Type___(company_, source_key_rec_);                                                                                                               
         tax_source_object_rec_ := Tax_Handling_Util_API.Create_Tax_Source_Object_Rec(tax_line_param_rec_.object_id, sales_object_type_, NULL, attr_);
         Fetch_Tax_Code_On_Object (tax_source_object_rec_, tax_line_param_rec_.contract);      
         Customer_Order_Inv_Item_API.Get_External_Tax_Info(attr_,invoice_id_,inv_item_rec_.item_id,'*','*','*');
         tax_liability_type_db_ := NVL(tax_line_param_rec_.tax_liability_type_db, Client_SYS.Get_Item_Value('TAX_LIABILITY_TYPE_DB', attr_)); 
         
         IF tax_liability_type_db_ IS NULL THEN
            tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_line_param_rec_.tax_liability, country_code_);
         END IF;
         IF tax_liability_type_db_ = Tax_Liability_Type_API.DB_TAXABLE THEN
            customer_taxable_:= 'TRUE';
         ELSE
            customer_taxable_:= 'FALSE';
         END IF;         
         
         IF (tax_source_object_rec_.is_taxable_db = 'TRUE' AND customer_taxable_ = 'TRUE' ) THEN
            Write_To_Ext_Tax_Register(company_,invoice_id_,inv_item_rec_.item_id,xml_trans_,counter_);
            Invoice_Item_API.Modify_Line_Level_Tax_Info(company_, 'NET_BASE', inv_rec_.creator, NULL, invoice_id_, inv_item_rec_.item_id);      
            counter_ := counter_ + 1;
         ELSE   
            IF Source_Tax_Item_API.Tax_Items_Exist(company_, Tax_Source_API.DB_INVOICE, invoice_id_, inv_item_rec_.item_id, '*', '*', '*') = Fnd_Boolean_API.DB_TRUE THEN 
               Source_Tax_Item_Invoic_API.Remove_Tax_Items( company_,
                                                            Tax_Source_API.DB_INVOICE,
                                                            invoice_id_,
                                                            inv_item_rec_.item_id,
                                                            '*',
                                                            '*',
                                                            '*');
            END IF;                                             
            Invoice_Item_API.Modify_Line_Level_Tax_Info(company_, 'NET_BASE', inv_rec_.creator, NULL, invoice_id_, inv_item_rec_.item_id); 
         END IF; 
   END LOOP;      
END  Write_To_Ext_Avalara_Tax_Regis;


--This method should be restructured in future when extending the Avalara functionality.
FUNCTION Get_Line_Tax_Liability (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   charge_seq_no_    IN NUMBER,
   rma_no_           IN NUMBER,
   rma_line_no_      IN NUMBER,
   rma_charge_no_    IN NUMBER) RETURN VARCHAR2
IS
   temp_ customer_order_line_tab.tax_liability%TYPE := 'EXEMPT';
BEGIN
   IF (order_no_ IS NOT NULL AND line_no_ IS NOT NULL) THEN
      temp_ :=  Customer_Order_Line_API.Get_Tax_Liability(order_no_, line_no_, rel_no_, line_item_no_);
   ELSIF (order_no_ IS NOT NULL AND charge_seq_no_ IS NOT NULL) THEN
      temp_ :=  Customer_Order_Charge_API.Get_Connected_Tax_Liability(order_no_, charge_seq_no_);
   ELSIF (rma_no_ IS NOT NULL AND rma_charge_no_ IS NOT NULL) THEN
      temp_:= Return_Material_Charge_Api.Get_Tax_Liability(rma_no_, rma_charge_no_);
   ELSIF (rma_no_ IS NOT NULL AND rma_line_no_ IS NOT NULL) THEN
      temp_:= Return_Material_Line_API.Get_Tax_Liability(rma_no_, rma_line_no_);
   END IF;
   RETURN temp_;
END Get_Line_Tax_Liability;


--This method should be restructured in future when extending the Avalara functionality.
PROCEDURE Get_Tax_Liability_Info(
   taxable_part_       OUT VARCHAR2,
   taxable_customer_   OUT VARCHAR2,
   contract_            IN VARCHAR2, 
   object_id_           IN VARCHAR2,
   order_no_            IN VARCHAR2, 
   line_no_             IN VARCHAR2, 
   release_no_          IN VARCHAR2, 
   line_item_no_        IN VARCHAR2,
   rma_no_              IN VARCHAR2, 
   rma_line_no_         IN VARCHAR2,
   charge_seq_no_       IN VARCHAR2, 
   rma_charge_no_       IN VARCHAR2 )
IS
BEGIN
   IF (charge_seq_no_ IS NOT NULL OR rma_charge_no_ IS NOT NULL) THEN   
      IF (Sales_Charge_Type_API.Get_Taxable_Db(contract_, object_id_) = 'TRUE') THEN
         taxable_part_ := 'Y';
      END IF;
   ELSE   
      IF (Sales_Part_API.Get_Taxable_Db(contract_, object_id_) = 'TRUE') THEN
         taxable_part_ := 'Y';
      END IF;         
   END IF;
   IF (rma_charge_no_ IS NOT NULL) THEN
      IF Return_Material_Charge_API.Get_Tax_Liability_Type_Db( rma_no_,
                                                               rma_charge_no_) != 'EXM' THEN
         taxable_customer_ := 'Y'; 
      END IF;
   ELSIF (rma_line_no_ IS NOT NULL) THEN
      IF Return_Material_Line_API.Get_Tax_Liability_Type_Db(rma_no_,
                                                            rma_line_no_) != 'EXM' THEN
         taxable_customer_ := 'Y'; 
      END IF;         
   ELSIF (line_no_ IS NOT NULL) THEN  
      IF Customer_Order_Line_API.Get_Tax_Liability_Type_Db( order_no_,
                                                            line_no_,
                                                            release_no_,
                                                            line_item_no_) != 'EXM' THEN
         taxable_customer_ := 'Y'; 
      END IF;
   ELSIF (charge_seq_no_ IS NOT NULL) THEN
      IF Customer_Order_Charge_API.Get_Conn_Tax_Liability_Type_Db( order_no_,
                                                                   charge_seq_no_) != 'EXM' THEN
         taxable_customer_ := 'Y'; 
      END IF;         
   END IF;
   
   taxable_customer_ := NVL(taxable_customer_,'N');
   taxable_part_     := NVL(taxable_part_, 'N');
END Get_Tax_Liability_Info;


PROCEDURE Get_Ship_From_Addr(
   add_attr_   OUT VARCHAR2, 
   contract_   IN  VARCHAR2,
   company_    IN  VARCHAR2 )
IS
   site_from_address_rec_     Company_Address_API.Public_Rec;
   site_del_address_id_       VARCHAR2(50);
BEGIN
   -- Get from Address
   site_del_address_id_    := Site_API.Get_Delivery_Address(contract_);
   IF (site_del_address_id_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOCODELA: Please provide site :P1 delivery address for company :P2', contract_, company_);
   END IF;
   site_from_address_rec_  := Company_Address_API.Get(company_, site_del_address_id_);

   Client_SYS.Add_To_Attr('ADDRESS_CODE'    , '001'      , add_attr_);
   Client_SYS.Add_To_Attr('LINE1', NVL(Avalara_Tax_Util_API.Rem_Special_Char(site_from_address_rec_.address1), '*'), add_attr_);
   Client_SYS.Add_To_Attr('LINE2', Avalara_Tax_Util_API.Rem_Special_Char(site_from_address_rec_.address2), add_attr_);
   Client_SYS.Add_To_Attr('CITY'            , site_from_address_rec_.city         , add_attr_);
   Client_SYS.Add_To_Attr('REGION'           , site_from_address_rec_.state       , add_attr_);
   Client_SYS.Add_To_Attr('POSTAL_CODE'        , site_from_address_rec_.zip_code    , add_attr_);      
   Client_SYS.Add_To_Attr('COUNTRY'    , site_from_address_rec_.country      , add_attr_);
   Client_SYS.Add_To_Attr('TAX_REGION_ID'    , '0'      , add_attr_);
   Client_SYS.Add_To_Attr('TAX_INCLUDED'    , 'true'      , add_attr_);
END Get_Ship_From_Addr;


PROCEDURE Get_Ship_To_Addr(add_attr_   OUT VARCHAR2,
                           item_id_    IN NUMBER,
                           invoice_id_ IN NUMBER,
                           company_    IN VARCHAR2)
IS
   address1_               VARCHAR2(35);
   address2_               VARCHAR2(35);
   country_code_           VARCHAR2(2);
   city_                   VARCHAR2(35);
   state_                  VARCHAR2(35);
   zip_code_               VARCHAR2(35);
   county_                 VARCHAR2(35);
   in_city_                VARCHAR2(5);
BEGIN
   Customer_Order_Inv_Item_API.Get_Line_Address_Info(address1_,
                                                     address2_,
                                                     country_code_,
                                                     city_,
                                                     state_,
                                                     zip_code_,
                                                     county_,
                                                     in_city_,
                                                     invoice_id_,
                                                     item_id_,
                                                     NULL,
                                                     NULL,
                                                     company_);                                                
   Client_SYS.Add_To_Attr('ADDRESS_CODE', '002', add_attr_);
   Client_SYS.Add_To_Attr('LINE1', Avalara_Tax_Util_API.Rem_Special_Char(address1_), add_attr_);
   Client_SYS.Add_To_Attr('LINE2', Avalara_Tax_Util_API.Rem_Special_Char(address2_), add_attr_);
   Client_SYS.Add_To_Attr('CITY', city_, add_attr_);
   Client_SYS.Add_To_Attr('REGION', state_, add_attr_);
   Client_SYS.Add_To_Attr('POSTAL_CODE', zip_code_, add_attr_);
   Client_SYS.Add_To_Attr('COUNTY', county_, add_attr_);
   Client_SYS.Add_To_Attr('COUNTRY', country_code_, add_attr_);
   Client_SYS.Add_To_Attr('TAX_REGION_ID', '0', add_attr_);
   Client_SYS.Add_To_Attr('TAX_INCLUDED', 'true', add_attr_);
END Get_Ship_To_Addr;

-------------------- METHODS FOR TAX LINE ASSISTANT IN AURENA ---------------

FUNCTION Get_Source_Objversion___ (
   company_         IN VARCHAR2,
   source_key_rec_  IN  Tax_Handling_Util_API.source_key_rec) RETURN VARCHAR2
IS
   source_objversion_  VARCHAR2(20);
BEGIN
   
   CASE source_key_rec_.source_ref_type
      WHEN Tax_Source_API.DB_CUSTOMER_ORDER_LINE THEN 
         source_objversion_ := Customer_Order_Line_API.Get_Objversion(source_key_rec_.source_ref1, source_key_rec_.source_ref2,
                                                                      source_key_rec_.source_ref3, source_key_rec_.source_ref4);
      WHEN Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE THEN 
         source_objversion_ := Customer_Order_Charge_API.Get_Objversion(source_key_rec_.source_ref1, source_key_rec_.source_ref2);
         
      WHEN Tax_Source_API.DB_ORDER_QUOTATION_LINE THEN 
         source_objversion_ := Order_Quotation_Line_API.Get_Objversion(source_key_rec_.source_ref1, source_key_rec_.source_ref2,
                                                                       source_key_rec_.source_ref3, source_key_rec_.source_ref4);
      WHEN Tax_Source_API.DB_ORDER_QUOTATION_CHARGE THEN 
         source_objversion_ := Order_Quotation_Charge_API.Get_Objversion(source_key_rec_.source_ref1, source_key_rec_.source_ref2);
         
      WHEN Tax_Source_API.DB_RETURN_MATERIAL_LINE THEN 
         source_objversion_ := Return_Material_Line_API.Get_Objversion(source_key_rec_.source_ref1, source_key_rec_.source_ref2);
         
      WHEN Tax_Source_API.DB_RETURN_MATERIAL_CHARGE THEN 
         source_objversion_ := Return_Material_Charge_API.Get_Objversion(source_key_rec_.source_ref1, source_key_rec_.source_ref2);
         
      WHEN Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE THEN 
         source_objversion_ := Shipment_Freight_Charge_API.Get_Objversion(source_key_rec_.source_ref1, source_key_rec_.source_ref2);
         
      WHEN Tax_Source_API.DB_INVOICE THEN 
         source_objversion_ := Customer_Order_Inv_Item_API.Get_Objversion(company_, source_key_rec_.source_ref1, source_key_rec_.source_ref2);
         
      ELSE 
         source_objversion_ := NULL;
      END CASE;
   RETURN source_objversion_;
END Get_Source_Objversion___;
   
   
FUNCTION Fetch_Source_Ref___ (
   package_name_    IN   VARCHAR2,
   attr_            IN   VARCHAR2 ) RETURN Tax_Handling_Util_API.Source_Info_Rec
IS
   source_info_rec_              Tax_Handling_Util_API.Source_Info_Rec;
BEGIN
   
   CASE package_name_
   WHEN 'CUSTOMER_ORDER_LINE_API' THEN
      source_info_rec_.source_ref_type_db := Tax_Source_API.DB_CUSTOMER_ORDER_LINE;
      source_info_rec_.source_ref1 := Client_SYS.Get_Item_Value('ORDER_NO', attr_); 
      source_info_rec_.source_ref2 := Client_SYS.Get_Item_Value('LINE_NO', attr_); 
      source_info_rec_.source_ref3 := Client_SYS.Get_Item_Value('REL_NO', attr_);
      source_info_rec_.source_ref4 := Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_);
      source_info_rec_.source_ref5 := '*'; 
      
   WHEN 'CUSTOMER_ORDER_CHARGE_API' THEN
      source_info_rec_.source_ref_type_db := Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE;
      source_info_rec_.source_ref1 := Client_SYS.Get_Item_Value('ORDER_NO', attr_); 
      source_info_rec_.source_ref2 := Client_SYS.Get_Item_Value('SEQUENCE_NO', attr_); 
      source_info_rec_.source_ref3 := '*';
      source_info_rec_.source_ref4 := '*';
      source_info_rec_.source_ref5 := '*';

   WHEN 'ORDER_QUOTATION_LINE_API' THEN
      source_info_rec_.source_ref_type_db := Tax_Source_API.DB_ORDER_QUOTATION_LINE;
      source_info_rec_.source_ref1 := Client_SYS.Get_Item_Value('QUOTATION_NO', attr_); 
      source_info_rec_.source_ref2 := Client_SYS.Get_Item_Value('LINE_NO', attr_); 
      source_info_rec_.source_ref3 := Client_SYS.Get_Item_Value('REL_NO', attr_);
      source_info_rec_.source_ref4 := Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_);
      source_info_rec_.source_ref5 := '*';
      
   WHEN 'ORDER_QUOTATION_CHARGE_API' THEN
      source_info_rec_.source_ref_type_db := Tax_Source_API.DB_ORDER_QUOTATION_CHARGE;
      source_info_rec_.source_ref1 := Client_SYS.Get_Item_Value('QUOTATION_NO', attr_); 
      source_info_rec_.source_ref2 := Client_SYS.Get_Item_Value('QUOTATION_CHARGE_NO', attr_); 
      source_info_rec_.source_ref3 := '*';
      source_info_rec_.source_ref4 := '*';
      source_info_rec_.source_ref5 := '*';
      
   WHEN 'RETURN_MATERIAL_LINE_API' THEN 
      source_info_rec_.source_ref_type_db := Tax_Source_API.DB_RETURN_MATERIAL_LINE;
      source_info_rec_.source_ref1 := Client_SYS.Get_Item_Value('RMA_NO', attr_); 
      source_info_rec_.source_ref2 := Client_SYS.Get_Item_Value('RMA_LINE_NO', attr_); 
      source_info_rec_.source_ref3 := '*';
      source_info_rec_.source_ref4 := '*';
      source_info_rec_.source_ref5 := '*';
      
   WHEN 'RETURN_MATERIAL_CHARGE_API' THEN 
      source_info_rec_.source_ref_type_db := Tax_Source_API.DB_RETURN_MATERIAL_CHARGE;
      source_info_rec_.source_ref1 := Client_SYS.Get_Item_Value('RMA_NO', attr_); 
      source_info_rec_.source_ref2 := Client_SYS.Get_Item_Value('RMA_CHARGE_NO', attr_); 
      source_info_rec_.source_ref3 := '*';
      source_info_rec_.source_ref4 := '*';
      source_info_rec_.source_ref5 := '*';

   WHEN 'SHIPMENT_FREIGHT_CHARGE_API' THEN
      source_info_rec_.source_ref_type_db := Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE;
      source_info_rec_.source_ref1 := Client_SYS.Get_Item_Value('SHIPMENT_ID', attr_); 
      source_info_rec_.source_ref2 := Client_SYS.Get_Item_Value('SEQUENCE_NO', attr_); 
      source_info_rec_.source_ref3 := '*';
      source_info_rec_.source_ref4 := '*';
      source_info_rec_.source_ref5 := '*';
      
   WHEN 'CUSTOMER_ORDER_INV_ITEM_API' THEN 
      source_info_rec_.source_ref_type_db := Tax_Source_API.DB_INVOICE;
      source_info_rec_.source_ref1 := Client_SYS.Get_Item_Value('INVOICE_ID', attr_); 
      source_info_rec_.source_ref2 := Client_SYS.Get_Item_Value('ITEM_ID', attr_); 
      source_info_rec_.source_ref3 := '*';
      source_info_rec_.source_ref4 := '*';
      source_info_rec_.source_ref5 := '*';

   ELSE 
      source_info_rec_ := NULL;
   END CASE;
   RETURN source_info_rec_;
END Fetch_Source_Ref___;

FUNCTION Get_Source_Ref_Type_Db___ (
   package_name_    IN   VARCHAR2) RETURN VARCHAR2
IS
   source_ref_type_db_    VARCHAR2(50);
BEGIN
   
   CASE package_name_
      WHEN 'CUSTOMER_ORDER_LINE_API' THEN  source_ref_type_db_ := Tax_Source_API.DB_CUSTOMER_ORDER_LINE;
      WHEN 'CUSTOMER_ORDER_CHARGE_API' THEN source_ref_type_db_ := Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE;
      WHEN 'ORDER_QUOTATION_LINE_API' THEN source_ref_type_db_ := Tax_Source_API.DB_ORDER_QUOTATION_LINE;
      WHEN 'ORDER_QUOTATION_CHARGE_API' THEN source_ref_type_db_ := Tax_Source_API.DB_ORDER_QUOTATION_CHARGE;
      WHEN 'RETURN_MATERIAL_LINE_API' THEN source_ref_type_db_ := Tax_Source_API.DB_RETURN_MATERIAL_LINE;
      WHEN 'RETURN_MATERIAL_CHARGE_API' THEN source_ref_type_db_ := Tax_Source_API.DB_RETURN_MATERIAL_CHARGE;
      WHEN 'SHIPMENT_FREIGHT_CHARGE_API' THEN source_ref_type_db_ := Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE;
      WHEN 'CUSTOMER_ORDER_INV_ITEM_API' THEN source_ref_type_db_ := Tax_Source_API.DB_INVOICE;
      ELSE source_ref_type_db_ := NULL;
   END CASE;
   RETURN source_ref_type_db_;
END Get_Source_Ref_Type_Db___;


--This method is to be used by Aurena
PROCEDURE Save_From_Tax_Line_Assistant (
   company_                      IN VARCHAR2,   
   source_key_rec_               IN Tax_Handling_Util_API.source_key_rec,
   previous_source_objversion_   IN VARCHAR2, 
   tax_info_table_               IN Tax_Handling_Util_API.tax_information_table,
   calc_base_                    IN VARCHAR2,
   tax_class_id_                 IN  VARCHAR2,   
   creator_                      IN VARCHAR2 ) 
IS
   current_source_objversion_   VARCHAR2(20);   
   tax_code_on_line_      VARCHAR2(20);   
   tax_calc_structure_id_ VARCHAR2(20);
   tax_code_msg_          VARCHAR2(32000);
   tax_percentage_        NUMBER;
   tax_base_curr_amount_  NUMBER;
BEGIN   
   IF (Fnd_Session_API.Is_Odp_Session) THEN
      current_source_objversion_ := Get_Source_Objversion___(company_, source_key_rec_);
      
      IF (current_source_objversion_ != previous_source_objversion_) THEN
         Error_SYS.Record_General(lu_name_, 'LINEMODIFIED: The line tax information has already been changed. Please refresh the record and reenter your changes.'); 
      END IF;
      
      IF (tax_info_table_.COUNT = 0) THEN 
         Tax_Handling_Util_API.Validate_Tax_Code_Mandatory(company_, 'CUSTOMER_TAX');        
      END IF;
      IF (source_key_rec_.source_ref_type = Tax_Source_API.DB_INVOICE) THEN
         Source_Tax_Item_Invoic_API.Remove_Tax_Items( company_,
                                                      source_key_rec_.source_ref_type,
                                                      source_key_rec_.source_ref1,
                                                      source_key_rec_.source_ref2,
                                                      source_key_rec_.source_ref3,
                                                      source_key_rec_.source_ref4,
                                                      source_key_rec_.source_ref5);
         Source_Tax_Item_Invoic_API.Create_Tax_Items(company_, 'FALSE',  'TRUE', source_key_rec_, tax_info_table_);
         
         Tax_Handling_Invoic_Util_API.Modify_Transaction_Tax_Info(company_, source_key_rec_.source_ref_type, source_key_rec_.source_ref1, 
                                                                  source_key_rec_.source_ref2, source_key_rec_.source_ref3, 
                                                                  source_key_rec_.source_ref4, source_key_rec_.source_ref5, 
                                                                  calc_base_, creator_);
      ELSE
         Source_Tax_Item_Order_API.Remove_Tax_Items( company_,
                                                     source_key_rec_.source_ref_type,
                                                     source_key_rec_.source_ref1,
                                                     source_key_rec_.source_ref2,
                                                     source_key_rec_.source_ref3,
                                                     source_key_rec_.source_ref4,
                                                     source_key_rec_.source_ref5);

         Source_Tax_Item_Order_API.Create_Tax_Items(tax_info_table_, 
                                                    source_key_rec_, 
                                                    company_);         

         Source_Tax_Item_API.Get_Tax_Codes(tax_code_msg_,
                                           tax_code_on_line_,
                                           tax_calc_structure_id_,
                                           tax_percentage_, 
                                           tax_base_curr_amount_,
                                           company_, 
                                           source_key_rec_.source_ref_type,
                                           source_key_rec_.source_ref1,
                                           source_key_rec_.source_ref2,
                                           source_key_rec_.source_ref3,
                                           source_key_rec_.source_ref4,
                                           source_key_rec_.source_ref5,
                                           'FALSE');                                           

         Modify_Source_Tax_Info___(source_key_rec_,
                                   tax_code_on_line_, 
                                   tax_class_id_,
                                   tax_calc_structure_id_);
                                                    
      END IF;
   END IF;
   NULL;
END Save_From_Tax_Line_Assistant;  


--This method is to be used by Aurena 
FUNCTION Fetch_For_Tax_Line_Assistant ( 
   package_name_                 IN   VARCHAR2,
   attr_                         IN   VARCHAR2 ) RETURN Tax_Handling_Util_API.source_info_rec
IS 
   source_key_rec_         Tax_Handling_Util_API.Source_Key_Rec;
   source_info_rec_        Tax_Handling_Util_API.Source_Info_Rec;
   tax_line_param_rec_     tax_line_param_rec;   
   stmt_                   VARCHAR2(2000);
   modified_currency_rate_  NUMBER;
   currency_conv_factor_    NUMBER;
BEGIN   
   IF (Fnd_Session_API.Is_Odp_Session) THEN 
      source_info_rec_ := Fetch_Source_Ref___(package_name_, attr_);      
            
      source_key_rec_.source_ref_type  := source_info_rec_.source_ref_type_db;
      source_key_rec_.source_ref1      := source_info_rec_.source_ref1;
      source_key_rec_.source_ref2      := source_info_rec_.source_ref2;
      source_key_rec_.source_ref3      := source_info_rec_.source_ref3;		
      source_key_rec_.source_ref4      := source_info_rec_.source_ref4;
      source_key_rec_.source_ref5      := source_info_rec_.source_ref5;
      
      IF source_info_rec_.source_ref_type_db = Tax_Source_API.DB_INVOICE THEN
         source_info_rec_.company := Client_SYS.Get_Item_Value('COMPANY', attr_);
      END IF;
      
      Assert_Sys.Assert_Is_Package(package_name_);
      stmt_  := 'BEGIN :tax_line_param_rec := '||package_name_||'.Fetch_Tax_Line_Param(:company, :source_ref1,
                                           :source_ref2, :source_ref3, :source_ref4); END;';
                                           
      @ApproveDynamicStatement(2019-03-30,mahplk)
      EXECUTE IMMEDIATE stmt_
         USING  OUT tax_line_param_rec_,
                IN  source_info_rec_.company,
                IN  source_info_rec_.source_ref1,
                IN  source_info_rec_.source_ref2,
                IN  source_info_rec_.source_ref3,
                IN  source_info_rec_.source_ref4;
      
      IF source_info_rec_.source_ref_type_db != Tax_Source_API.DB_INVOICE THEN
         source_info_rec_.company := Site_API.Get_Company(tax_line_param_rec_.contract);
      END IF;
      
      source_info_rec_.source_objversion := Get_Source_Objversion___(source_info_rec_.company, source_key_rec_);
      
      IF (NVL(tax_line_param_rec_.write_to_ext_tax_register, 'FALSE') = 'FALSE') THEN     
         Get_Curr_Rate_And_Conv_Fact___(modified_currency_rate_,
                                        currency_conv_factor_,
                                        source_info_rec_.company,
                                        tax_line_param_rec_.currency_code,
                                        tax_line_param_rec_.currency_rate,
                                        tax_line_param_rec_.customer_no);
      ELSE
         modified_currency_rate_  := NVL(modified_currency_rate_, tax_line_param_rec_.currency_rate);
         currency_conv_factor_ := NVL(tax_line_param_rec_.conv_factor, 
                                      Currency_Code_API.Get_Conversion_Factor(tax_line_param_rec_.company, tax_line_param_rec_.currency_code));
      END IF;
         
      source_info_rec_.party_type_db        := Party_Type_API.DB_CUSTOMER;
      source_info_rec_.identity             := tax_line_param_rec_.customer_no;
      source_info_rec_.transaction_date     := tax_line_param_rec_.planned_ship_date;
      source_info_rec_.transaction_currency := tax_line_param_rec_.currency_code;
      source_info_rec_.delivery_address_id  := tax_line_param_rec_.ship_addr_no;       
      source_info_rec_.tax_validation_type  := 'CUSTOMER_TAX'; 
      source_info_rec_.taxable              := tax_line_param_rec_.taxable; 
      source_info_rec_.liability_type       := tax_line_param_rec_.tax_liability_type_db;
      source_info_rec_.tax_calc_structure_id := tax_line_param_rec_.tax_calc_structure_id;
      
      source_info_rec_.curr_rate            := modified_currency_rate_;
      source_info_rec_.tax_curr_rate        := tax_line_param_rec_.tax_curr_rate;
      source_info_rec_.parallel_curr_rate   := tax_line_param_rec_.para_curr_rate;
      source_info_rec_.div_factor           := currency_conv_factor_;  
      source_info_rec_.parallel_div_factor  := tax_line_param_rec_.para_conv_factor;
           
      source_info_rec_.advance_invoice      := tax_line_param_rec_.advance_invoice;
      
      Assert_Sys.Assert_Is_Package(package_name_);
      stmt_  := 'BEGIN '||package_name_||'.Fetch_Gross_Net_Tax_Amounts(:source_info_rec_.gross_curr_amount, 
                                                                       :source_info_rec_.net_curr_amount,
                                                                       :source_info_rec_.tax_curr_amount,
                                                                       :company, 
                                                                       :source_ref1,
                                                                       :source_ref2, 
                                                                       :source_ref3, 
                                                                       :source_ref4); END;';
                                           
      @ApproveDynamicStatement(2019-03-30,mahplk)
      EXECUTE IMMEDIATE stmt_
         USING  OUT source_info_rec_.gross_curr_amount,
                OUT source_info_rec_.net_curr_amount,
                OUT source_info_rec_.tax_curr_amount,
                IN  source_info_rec_.company,
                IN  source_info_rec_.source_ref1,
                IN  source_info_rec_.source_ref2,
                IN  source_info_rec_.source_ref3,
                IN  source_info_rec_.source_ref4;
       
      RETURN source_info_rec_;
   END IF; 
   NULL;
END Fetch_For_Tax_Line_Assistant;
   

--This method is to be used by Aurena
PROCEDURE Set_Tax_Line_Assis_Colm_Labels (
   label_rec_            IN OUT Tax_Handling_Util_API.tax_assistant_label_rec,   
   package_name_         IN     VARCHAR2 )
IS
BEGIN
   IF (Fnd_Session_API.Is_Odp_Session) THEN
      IF (package_name_ IN ('CUSTOMER_ORDER_LINE_API', 'CUSTOMER_ORDER_CHARGE_API', 'ORDER_QUOTATION_LINE_API', 'ORDER_QUOTATION_CHARGE_API',
                              'RETURN_MATERIAL_LINE_API', 'RETURN_MATERIAL_CHARGE_API', 'SHIPMENT_FREIGHT_CHARGE_API')) THEN 
         label_rec_.tax_lines_label := Language_SYS.Translate_Constant(lu_name_, 'TAX_LINES_LABEL:  ');
         
         label_rec_.list_tax_amount_label := Language_SYS.Translate_Constant(lu_name_, 'LIST_TAX_AMOUNT_LABEL: Tax Amount/Curr');
         label_rec_.list_tax_dom_amount_label := Language_SYS.Translate_Constant(lu_name_, 'LIST_TAX_DOM_AMOUNT_LABEL: Tax Amount/Base');         
         label_rec_.group_gross_curr_amount_label := Language_SYS.Translate_Constant(lu_name_, 'GROUP_GROSS_CURR_AMOUNT_LABEL: Gross Amount');
         label_rec_.group_net_curr_amount_label := Language_SYS.Translate_Constant(lu_name_, 'GROUP_NET_CURR_AMOUNT_LABEL: Net Amount');    
         label_rec_.group_vat_curr_amount_label := Language_SYS.Translate_Constant(lu_name_, 'GROUP_VAT_CURR_AMOUNT_LABEL: Tax Amount');
     
      END IF; 
   END IF; 
   NULL;
END Set_Tax_Line_Assis_Colm_Labels;


--This method is to be used by Aurena
PROCEDURE Field_Editable_Tax_Line_Assis (
   field_editable_rec_        IN OUT Tax_Handling_Util_API.tax_assis_field_editable_rec,   
   package_name_              IN     VARCHAR2,
   company_                   IN     VARCHAR2,
   tax_type_db_               IN     VARCHAR2,
   taxable_db_                IN     VARCHAR2,
   tax_liability_type_db_     IN     VARCHAR2,
   tax_calc_structure_id_     IN     VARCHAR2)
IS
   modify_tax_percentage_db_    VARCHAR2(5);
BEGIN
   IF (Fnd_Session_API.Is_Odp_Session) THEN
      IF (package_name_ IN ('CUSTOMER_ORDER_LINE_API', 'CUSTOMER_ORDER_CHARGE_API', 'ORDER_QUOTATION_LINE_API', 'ORDER_QUOTATION_CHARGE_API',
                              'RETURN_MATERIAL_LINE_API', 'RETURN_MATERIAL_CHARGE_API', 'SHIPMENT_FREIGHT_CHARGE_API')) THEN
                              
         modify_tax_percentage_db_ := Company_Tax_Discom_Info_API.Get_Modify_Tax_Percentage_Db(company_);
         
         IF ((modify_tax_percentage_db_ = 'TRUE') AND (tax_calc_structure_id_ IS NULL) AND (tax_type_db_ NOT IN ('NOTAX', 'CALCTAX')) AND (tax_liability_type_db_ != 'EXM') AND (taxable_db_ = 'TRUE')) THEN
            field_editable_rec_.tax_percentage_editable := Fnd_Boolean_API.DB_TRUE;
         ELSE
            field_editable_rec_.tax_percentage_editable := Fnd_Boolean_API.DB_FALSE;
         END IF;
         
         field_editable_rec_.tax_curr_amount_editable := Fnd_Boolean_API.DB_FALSE;
         field_editable_rec_.tax_base_curr_amount_editable := Fnd_Boolean_API.DB_FALSE;
         field_editable_rec_.non_ded_tax_curr_amt_editable := Fnd_Boolean_API.DB_FALSE;
         field_editable_rec_.total_tax_curr_amount_editable := Fnd_Boolean_API.DB_FALSE;
      END IF; 
   END IF;             
   NULL;
END Field_Editable_Tax_Line_Assis; 


--This method is to be used by Aurena
PROCEDURE Field_Visible_Tax_Line_Assis (
   field_visibility_rec_            IN OUT Tax_Handling_Util_API.tax_assis_field_visibility_rec,   
   package_name_                    IN     VARCHAR2 )
IS
BEGIN
   IF (Fnd_Session_API.Is_Odp_Session) THEN
      IF (package_name_ IN ('CUSTOMER_ORDER_LINE_API', 'CUSTOMER_ORDER_CHARGE_API', 'ORDER_QUOTATION_LINE_API', 'ORDER_QUOTATION_CHARGE_API',
                              'RETURN_MATERIAL_LINE_API', 'RETURN_MATERIAL_CHARGE_API', 'SHIPMENT_FREIGHT_CHARGE_API')) THEN 
         field_visibility_rec_.tax_parallel_amount_visible := Fnd_Boolean_API.DB_FALSE;
      ELSIF (package_name_ IN ('CUSTOMER_ORDER_INV_ITEM_API')) THEN          
         field_visibility_rec_.tax_category_visible := Fnd_Boolean_API.DB_TRUE;
      END IF; 
   END IF; 
   NULL;
END Field_Visible_Tax_Line_Assis;
 
--This method is to be used by Aurena 
PROCEDURE Update_Tax_Info_Table(
   tax_info_table_         IN OUT Tax_Handling_Util_API.tax_information_table,
   company_                IN     VARCHAR2,
   package_name_           IN     VARCHAR2,
   source_ref1_            IN     VARCHAR2,
   curr_rate_              IN     NUMBER)
IS
   external_tax_calc_method_    VARCHAR2(50);
   source_ref_type_db_          VARCHAR2(50);
BEGIN
   source_ref_type_db_          := Get_Source_Ref_Type_Db___(package_name_);
   external_tax_calc_method_    := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);
   
   Update_Tax_Info_Table___(tax_info_table_,
                            company_,
                            external_tax_calc_method_,
                            source_ref_type_db_,
                            source_ref1_,
                            curr_rate_,
                            TRUE);
END Update_Tax_Info_Table; 


--This method is to be used by Aurena 
PROCEDURE Do_Additional_Validations(
   source_ref_type_db_  IN VARCHAR2,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   validate_rec_        IN Tax_Handling_Util_API.tax_assistant_validation_rec )
IS
   attr_             VARCHAR2(400);   
BEGIN
   IF (Fnd_Session_API.Is_Odp_Session) THEN
      Client_SYS.Set_Item_Value('DO_ADDITIONAL_VALIDATE', 'TRUE', attr_); 
      Client_SYS.Set_Item_Value('TAX_LINES_COUNT', validate_rec_.tax_lines_count, attr_);
      Do_Additional_Validations(source_ref_type_db_,
                                source_ref1_,
                                source_ref2_,
                                source_ref3_,
                                source_ref4_,
                                source_ref5_,
                                attr_);  
   END IF;
END Do_Additional_Validations;

--------------------------------------------------------------------
-- Fetch_External_Tax_Info
--    Fetches and updates tax information as a bundle call from an external tax system
--------------------------------------------------------------------
PROCEDURE Fetch_External_Tax_Info (
   source_key_arr_        IN  Tax_Handling_Util_API.source_key_arr,
   company_               IN  VARCHAR2)
IS
   ext_tax_param_in_rec_         External_Tax_System_Util_API.ext_tax_param_in_rec;
   ext_tax_param_in_arr_         External_Tax_System_Util_API.ext_tax_param_in_arr;
   ext_tax_param_out_arr_        External_Tax_System_Util_API.ext_tax_param_out_arr;
   -- gelr:br_external_tax_integration, begin
   ext_tax_param_br_out_arr_     External_Tax_System_Util_API.ext_tax_param_br_out_arr;
   complementary_info_           VARCHAR2(2000);
   business_operation_arr_       External_Tax_System_Util_API.Business_Operation_Rec_Arr;
   -- gelr:br_external_tax_integration, end
   external_tax_cal_method_      VARCHAR2(50);
   stmt_                         VARCHAR2(2000);
   tax_info_table_               Tax_Handling_Util_API.tax_information_table;
   rec_count_                    NUMBER := 0;
   source_pkg_                   VARCHAR2(30);
   tax_line_param_arr_           tax_line_param_arr;
   tax_line_param_rec_           tax_line_param_rec;
   line_amount_rec_              Tax_Handling_Util_API.line_amount_rec;
   multiple_tax_                 VARCHAR2(20);
   sales_object_type_            VARCHAR2(30);
   tax_code_city_                VARCHAR2(20);
   tax_code_state_               VARCHAR2(20);   
   tax_code_county_              VARCHAR2(20);   
   tax_code_district_            VARCHAR2(20); 
   valid_source_key_arr_         Tax_Handling_Util_API.source_key_arr;
   fetch_jurisdiction_code_      VARCHAR2(5);
   citation_info_                VARCHAR2(2000);
BEGIN
   external_tax_cal_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);

   -- gelr:br_external_tax_integration, Modified condition to include Avalara Brazil
   IF external_tax_cal_method_ IN (External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX, External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN

      FOR i_ IN 1..source_key_arr_.COUNT LOOP
         source_pkg_    := Get_Source_Pkg___(source_key_arr_(i_).source_ref_type);
         
         Assert_Sys.Assert_Is_Package(source_pkg_);                                               
         stmt_  := 'BEGIN :tax_line_param_rec := '||source_pkg_||'.Fetch_Tax_Line_Param(:company, :source_ref1, :source_ref2,
                                                                  :source_ref3, :source_ref4); END;';
            @ApproveDynamicStatement(2020-06-26,NIDALK) 
            EXECUTE IMMEDIATE stmt_
                    USING  OUT tax_line_param_rec_,
                           IN  company_,
                           IN  source_key_arr_(i_).source_ref1,
                           IN  source_key_arr_(i_).source_ref2,
                           IN  source_key_arr_(i_).source_ref3,
                           IN  source_key_arr_(i_).source_ref4;

         tax_line_param_rec_.tax_code              := NULL;
         tax_line_param_rec_.tax_calc_structure_id := NULL;
         tax_line_param_rec_.add_tax_lines         := TRUE;
         sales_object_type_    := Get_Sales_Object_Type___(tax_line_param_rec_.company, source_key_arr_(i_));
         
         IF (source_key_arr_(i_).source_ref_type IN (Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                      Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                      Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                                      Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                                      Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                                      Tax_Source_API.DB_INVOICE,
                                                      Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                      Tax_Source_API.DB_ORDER_QUOTATION_CHARGE)) THEN
            ext_tax_param_in_rec_ := NULL;
            Add_Tax_Info_To_Rec___(tax_line_param_rec_, source_key_arr_(i_), null);
            Create_Ext_Tax_Param_In_Rec___(ext_tax_param_in_rec_, tax_line_param_rec_, source_key_arr_(i_), sales_object_type_, NULL, NULL);
            
            IF ext_tax_param_in_rec_.company IS NOT NULL  THEN
               rec_count_ := rec_count_ + 1;
               valid_source_key_arr_(rec_count_) := source_key_arr_(i_);
               tax_line_param_arr_(rec_count_)   := tax_line_param_rec_;
               ext_tax_param_in_arr_(rec_count_) := ext_tax_param_in_rec_;
            ELSE
               Add_Transaction_Tax_Info___(line_amount_rec_,
                                           multiple_tax_,
                                           tax_info_table_,
                                           tax_line_param_rec_,
                                           source_key_arr_(i_),
                                           FALSE,
                                           attr_ => NULL,
                                           fetch_tax_info_ => FALSE);  
            END IF;
         END IF;
      END LOOP;

      IF rec_count_ > 0 THEN
         IF external_tax_cal_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX THEN
            External_Tax_System_Util_API.Fetch_Tax_From_External_System(tax_code_city_, tax_code_state_, tax_code_county_, tax_code_district_, ext_tax_param_out_arr_, ext_tax_param_in_arr_, company_);
         -- gelr:br_external_tax_integration, begin
         ELSIF external_tax_cal_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL THEN
            External_Tax_System_Util_API.Fetch_Tax_From_External_System(ext_tax_param_br_out_arr_, complementary_info_, business_operation_arr_, ext_tax_param_in_arr_);
         -- gelr:br_external_tax_integration, end
         END IF;

         FOR i_ IN 1 .. rec_count_ LOOP
            IF (source_key_arr_(i_).source_ref_type IN (Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                         Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                         Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                                         Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                                         Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                                         Tax_Source_API.DB_INVOICE,
                                                         Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                         Tax_Source_API.DB_ORDER_QUOTATION_CHARGE)) THEN
               IF external_tax_cal_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX THEN
                  tax_info_table_ := External_Tax_System_Util_API.Set_Tax_From_External_System(tax_code_city_, tax_code_state_, tax_code_county_, tax_code_district_, ext_tax_param_out_arr_(i_), ext_tax_param_in_arr_(i_), external_tax_cal_method_);
                  fetch_jurisdiction_code_ := Iso_Country_API.Get_Fetch_Jurisdiction_Code_Db(ext_tax_param_in_rec_.cust_del_country);
               -- gelr:br_external_tax_integration, begin
               ELSIF external_tax_cal_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL THEN
                  IF ext_tax_param_br_out_arr_.COUNT > 0 THEN
                     External_Tax_System_Util_API.Set_Tax_From_External_System(tax_info_table_, citation_info_, ext_tax_param_br_out_arr_(i_), external_tax_cal_method_);
                     Update_Citation_Information___ (valid_source_key_arr_(i_), citation_info_);
                     Update_Warning_Summary___ (valid_source_key_arr_(i_).source_ref1, business_operation_arr_(i_).warning_summary); 
                  END IF;
               -- gelr:br_external_tax_integration, end
               END IF;

               IF (tax_info_table_.COUNT >0 ) AND (fetch_jurisdiction_code_ = 'FALSE' AND  ext_tax_param_in_arr_(i_).write_to_ext_tax_register = 'TRUE' ) THEN
                  -- the customer does not expecting any tax codes for an international customer. 
                  -- When using 770000000 we get NO_TAX in return from Vertex so we don't get any values for STATE, COUNTY, CITY and DISTRICT.
                  -- The tax lines dialog should be empty.
                  tax_info_table_.DELETE;
               END IF;
               
               IF (tax_info_table_.COUNT >0 ) THEN
                  IF (tax_info_table_.COUNT = 1) THEN
                     tax_line_param_rec_.tax_code := tax_info_table_(1).tax_code;
                     multiple_tax_                := 'FALSE';
                  ELSE
                     tax_line_param_rec_.tax_code := '';
                     multiple_tax_                := 'TRUE';
                  END IF;
               ELSE
                  tax_line_param_rec_.tax_code := '';
                  multiple_tax_                := 'FALSE';
               END IF;

               Add_Transaction_Tax_Info___(line_amount_rec_,
                                           multiple_tax_,
                                           tax_info_table_,
                                           tax_line_param_arr_(i_),
                                           valid_source_key_arr_(i_),
                                           FALSE,
                                           attr_ => NULL,
                                           fetch_tax_info_ => FALSE);  
            END IF;                            
         END LOOP;
      END IF;
   END IF;
  
END Fetch_External_Tax_Info;

PROCEDURE Transfer_Ext_Tax_Lines(
   copy_from_source_arr_        IN  Tax_Handling_Util_API.source_key_arr,
   copy_to_source_arr_          IN  Tax_Handling_Util_API.source_key_arr,
   company_                     IN  VARCHAR2,
   refetch_curr_rate_           IN  VARCHAR2)
IS
   external_tax_cal_method_      VARCHAR2(50);
   tax_line_param_rec_           tax_line_param_rec;
   tax_line_param_arr_           tax_line_param_arr;
   is_rebate_invoice_            BOOLEAN := FALSE;
   ext_tax_param_in_rec_         External_Tax_System_Util_API.ext_tax_param_in_rec;
   ext_tax_param_in_arr_         External_Tax_System_Util_API.ext_tax_param_in_arr;
   ext_tax_param_out_arr_        External_Tax_System_Util_API.ext_tax_param_out_arr;
   -- gelr:br_external_tax_integration, begin
   ext_tax_param_br_out_arr_     External_Tax_System_Util_API.ext_tax_param_br_out_arr;
   complementary_info_           VARCHAR2(2000);
   business_operation_arr_       External_Tax_System_Util_API.Business_Operation_Rec_Arr;
   -- gelr:br_external_tax_integration, end
   rec_count_                    INTEGER := 0;
   temp_from_source_key_rec_     Tax_Handling_Util_API.source_key_rec;
   sales_object_type_            VARCHAR2(30);
   tax_code_city_                VARCHAR2(20);
   tax_code_state_               VARCHAR2(20);   
   tax_code_county_              VARCHAR2(20);   
   tax_code_district_            VARCHAR2(20); 
   valid_copy_from_source_arr_   Tax_Handling_Util_API.source_key_arr;
   valid_copy_to_source_arr_     Tax_Handling_Util_API.source_key_arr;
   tax_info_table_               Tax_Handling_Util_API.tax_information_table;
   line_amount_rec_              Tax_Handling_Util_API.line_amount_rec;
   fetch_jurisdiction_code_      VARCHAR2(5);
   multiple_tax_                 VARCHAR2(20);
   citation_info_                VARCHAR2(2000);
BEGIN
   external_tax_cal_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);

   -- gelr:br_external_tax_integration, Modified condition to include Avalara Brazil
   IF external_tax_cal_method_ IN (External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX, External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN
      FOR i_ IN 1..copy_from_source_arr_.COUNT LOOP
         Create_Recal_Tax_Line_Param_Rec___( tax_line_param_rec_,
                                             is_rebate_invoice_, 
                                             company_,
                                             copy_from_source_arr_(i_),
                                             copy_to_source_arr_ (i_),
                                             refetch_curr_rate_);
                                             
         IF NOT is_rebate_invoice_ THEN                                    
            sales_object_type_    := Get_Sales_Object_Type___(tax_line_param_rec_.company, copy_from_source_arr_(i_));

            temp_from_source_key_rec_         := copy_from_source_arr_(i_);

            IF (copy_from_source_arr_(i_).source_ref_type IN(Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                             Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                             Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE)) THEN
               temp_from_source_key_rec_ := copy_to_source_arr_ (i_);
            END IF;
            
            IF (temp_from_source_key_rec_.source_ref_type IN (Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                            Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                            Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                                            Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                                            Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                                            Tax_Source_API.DB_INVOICE,
                                                            Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                            Tax_Source_API.DB_ORDER_QUOTATION_CHARGE)) THEN  
               Add_Tax_Info_To_Rec___(tax_line_param_rec_, temp_from_source_key_rec_, null);
               ext_tax_param_in_rec_ := NULL;
               Create_Ext_Tax_Param_In_Rec___(ext_tax_param_in_rec_, tax_line_param_rec_, temp_from_source_key_rec_, sales_object_type_, NULL, NULL);

               IF ext_tax_param_in_rec_.company IS NOT NULL  THEN
                  rec_count_ := rec_count_ + 1;
                  valid_copy_from_source_arr_(rec_count_) := copy_from_source_arr_(i_);
                  valid_copy_to_source_arr_(rec_count_) := copy_to_source_arr_(i_);
                  tax_line_param_arr_(rec_count_)   := tax_line_param_rec_;
                  ext_tax_param_in_arr_(rec_count_) := ext_tax_param_in_rec_;
               ELSE   
                  -- Need to remove tax info on line if already existing.
                  Save_Tax_Lines___ ( tax_info_table_,
                                       copy_from_source_arr_(i_),
                                       copy_to_source_arr_(i_),
                                       tax_line_param_rec_,
                                       company_,
                                       FALSE); 
               END IF;
            END IF;
         END IF;
      END LOOP;
      
      IF rec_count_ > 0 THEN
         IF external_tax_cal_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX THEN
            External_Tax_System_Util_API.Fetch_Tax_From_External_System(tax_code_city_, tax_code_state_, tax_code_county_, tax_code_district_, ext_tax_param_out_arr_, ext_tax_param_in_arr_, company_);
         -- gelr:br_external_tax_integration, begin
         ELSIF external_tax_cal_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL THEN
            External_Tax_System_Util_API.Fetch_Tax_From_External_System(ext_tax_param_br_out_arr_, complementary_info_, business_operation_arr_, ext_tax_param_in_arr_);
            IF complementary_info_ IS NOT NULL AND copy_to_source_arr_(1).source_ref_type = Tax_Source_API.DB_INVOICE THEN
               Customer_Order_Inv_Head_API.Update_Complimentary_Info(company_, copy_to_source_arr_(1).source_ref1, complementary_info_);
            END IF;
         -- gelr:br_external_tax_integration, end
         END IF;
         
         FOR i_ IN 1 .. rec_count_ LOOP
            IF external_tax_cal_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX THEN
               tax_info_table_ := External_Tax_System_Util_API.Set_Tax_From_External_System(tax_code_city_, tax_code_state_, tax_code_county_, tax_code_district_, ext_tax_param_out_arr_(i_), ext_tax_param_in_arr_(i_), external_tax_cal_method_);
               fetch_jurisdiction_code_ := Iso_Country_API.Get_Fetch_Jurisdiction_Code_Db(ext_tax_param_in_rec_.cust_del_country);
            -- gelr:br_external_tax_integration, begin
            ELSIF external_tax_cal_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL THEN
               IF ext_tax_param_br_out_arr_.COUNT > 0 THEN
                  External_Tax_System_Util_API.Set_Tax_From_External_System(tax_info_table_, citation_info_, ext_tax_param_br_out_arr_(i_), external_tax_cal_method_);
               END IF;
               IF business_operation_arr_(i_).business_operation IS NOT NULL AND copy_to_source_arr_(i_).source_ref_type = Tax_Source_API.DB_INVOICE THEN
                  Invoice_Customer_Order_API.Update_Business_Operation(company_, copy_to_source_arr_(i_).source_ref1, copy_to_source_arr_(i_).source_ref2, business_operation_arr_(i_).business_operation);
               END IF;
            -- gelr:br_external_tax_integration, end
            END IF;
            
            IF (tax_info_table_.COUNT >0 ) AND (fetch_jurisdiction_code_ = 'FALSE' AND  ext_tax_param_in_arr_(i_).write_to_ext_tax_register = 'TRUE' ) THEN
               -- the customer does not expecting any tax codes for an international customer. 
               -- When using 770000000 we get NO_TAX in return from Vertex so we don't get any values for STATE, COUNTY, CITY and DISTRICT.
               -- The tax lines dialog should be empty.
               tax_info_table_.DELETE;
            END IF;

            IF (tax_info_table_.COUNT >0 ) THEN
               IF (tax_info_table_.COUNT = 1) THEN
                  tax_line_param_rec_.tax_code := tax_info_table_(1).tax_code;
                  multiple_tax_                := 'FALSE';
               ELSE
                  tax_line_param_rec_.tax_code := '';
                  multiple_tax_                := 'TRUE';
               END IF;
            ELSE
               tax_line_param_rec_.tax_code := '';
               multiple_tax_                := 'FALSE';
            END IF;
            
            Calculate_Line_Totals___(line_amount_rec_, 
                                       tax_info_table_,
                                       valid_copy_from_source_arr_(i_),
                                       NULL,
                                       tax_line_param_rec_,
                                       external_tax_cal_method_,
                                       FALSE,
                                       TRUE,
                                       NULL );
                               
            Save_Tax_Lines___ ( tax_info_table_,
                                valid_copy_from_source_arr_(i_),
                                valid_copy_to_source_arr_(i_),
                                tax_line_param_rec_,
                                company_,
                                FALSE);                   
         END LOOP;
      END IF;
   END IF;
END Transfer_Ext_Tax_Lines;

@IgnoreUnitTest TrivialFunction
FUNCTION Fetch_And_Validate_Tax_Id (
   customer_no_       IN VARCHAR2,
   bill_addr_no_      IN VARCHAR2,
   company_           IN VARCHAR2,   
   supply_country_    IN VARCHAR2,
   delivery_country_  IN VARCHAR2) RETURN VARCHAR2
IS
   tax_id_type_       VARCHAR2(10);
BEGIN    
   tax_id_type_      := Customer_Document_Tax_Info_API.Get_Tax_Id_Type_Db(customer_no_,
                                                                        bill_addr_no_,
                                                                        company_,
                                                                        supply_country_,
                                                                        delivery_country_);  
   RETURN tax_id_type_;                                                                     
END Fetch_And_Validate_Tax_Id;

