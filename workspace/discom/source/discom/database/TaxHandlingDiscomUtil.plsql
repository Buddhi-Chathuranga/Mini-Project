-----------------------------------------------------------------------------
--
--  Logical unit: TaxHandlingDiscomUtil
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220810  MaEelk  SCDEV-13090, Modified Calc_Taxs_And_Non_Ded_Taxs___, Transfer_Tax_lines and Field_Visible_Tax_Line_Assis,
--  220810          to calculate tax amounts and non deductible tax amounts according to the values defined in Receiver Type and Sender Type 
--  220810          and to make them visible or invisible in Tax Line Assistant
--  220731  MalLlk  SCDEV-12957, Added Fetch_Tax_Codes___ to hadnle tax fetching logic. Removed Fetch_Tax_Codes_On_Tax_Str___.
--  220729  MaEelk  SCDEV-12972, Added Tax Code to Tax Calculations
--  220729  MalLlk  SCDEV-12957, Added Get_Price_Incl_Tax. Added tax_code and fetch_saved_tax to tax_line_param_rec.
--  220729          Changed Create_Tax_Line_Param_Rec to a implementation method. Removed unused method Get_Amounts.
--  220728  MaEelk  SCDEV-12949, business_transaction_id was set to VARCHAR2(200) in avalara_brazil_specific_rec.
--  220727  MaEelk  SCDEV-12653, Modified Calc_Taxs_And_Non_Ded_Taxs___ to round non deductible tax amounts when fetching taxes from Avalara Integration
--  220725  MaEelk  SCDEV-12653, Modified Transfer_Tax_Lines to pass parallel amounts and Tax Limit Curr Amount to Source_Tax_Item_Discom_API.New
--  220719  MaEelk  SCDEV_12653, Added Field_Visible_Tax_Line_Assis to make non-deductible tax amounts visible for incoming tax documents.
--  220719          Modified Fetch_Source_Ref___ to calculate Taotal Tax for Non Deductible Tax Codes. Removed Modify_Source_Tax_Info___ since it is not used anymore.
--  220716  MaEelk  SCDEV-12651, Remoced Fetch_External_Tax_Info that used make the bundle call to fetch Brazil Tax Avalara.
--  220713  MaEelk  SCDEV-11672, Modified Add_Transaction_Tax_Info___ to support Brazil Avalara Tax Fetching and calculate non-deductible taxes.
--  220713          Added Fetch_External_Tax_Info___ to fetch Brazil Avalara Taxes. Modified Create_Ext_Tax_Param_In_Rec___ to correctly fetched the delivered quantity.
--  220610  MaEelk  SCDEV-6571, Added table type tax_line_param_arr and record type avalara_brazil_specific_rec.
--  220610          Added Create_Ext_Tax_Param_In_Rec___, Modify_Source_Tax_Info___ and Fetch_External_Tax_Info. 
--  220610          Create_Tax_Line_Param_Rec___ was converted to a public method.
--  220412  NiRalk  SCDEV-8136, Added Transfer_Tax_lines method.
--  220303  Hastlk  SCDEV-7872, Modified the Save_From_Tax_Line_Assistant method by calling Modify_Tax_Info method.
--  220302  MaEelk  SCDEV-5596, Added IgnoreUnitTest annotation to the methods and functions.
--  220201  HasTlk  SC21R2-7281, Added Save_From_Tax_Line_Assistant method.
--  220201  MaEelk  SC21R2-7368, Added Currency Code to the source_info_rec_.transaction_currency in Fetch_For_Tax_Line_Assistant
--  220120  HasTlk  SC21R2-7244, Modified the Fetch_Source_Ref___ to get the data for gross_amount, net_amount, tax_amount and tax_calc_structure_id.
--  220104  MalLlk  SC21R2-5593, Added methods Fetch_Tax_Codes_On_Tax_Str___, Calculate_Line_Totals___, Create_Tax_Line_Param_Rec___,
--  220104          Add_Transaction_Tax_Info___, Get_Amounts and Add_Transaction_Tax_Info to handle tax fetching, calculation and create tax lines.
--  211216  HasTlk  SC21R2-6456, Added Fetch_Source_Ref___ and Fetch_For_Tax_Line_Assistant functions.
--  211202  MalLlk  SC21R2-5583, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE tax_line_param_rec IS RECORD (   
   company                   VARCHAR2(20),
   tax_code                  VARCHAR2(20),
   tax_calc_structure_id     VARCHAR2(20),
   tax_document_no           NUMBER,
   tax_document_line_no      NUMBER,
   price                     NUMBER,
   quantity                  NUMBER,
   net_amount                NUMBER,
   date_applied              DATE,
   add_tax_lines             BOOLEAN,
   fetch_saved_tax           BOOLEAN);

TYPE tax_line_param_arr IS TABLE OF tax_line_param_rec INDEX BY BINARY_INTEGER;

TYPE avalara_brazil_specific_rec IS RECORD (
   source_ref1               VARCHAR2(50),
   source_ref2               VARCHAR2(50),
   ship_addr_no              VARCHAR2(50),
   doc_addr_no               VARCHAR2(50),
   document_code             NUMBER,
   part_no                   VARCHAR2(25),
   part_description          VARCHAR2(200),
   price                     NUMBER,
   external_use_type         VARCHAR2(25),
   business_transaction_id   VARCHAR2(200),
   statistical_code          VARCHAR2(15),
   cest_code                 VARCHAR2(7),
   unit_meas                 VARCHAR2(10),
   acquisition_origin        NUMBER,
   product_type_classif      VARCHAR2(35),
   object_type               VARCHAR2(50));

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@IgnoreUnitTest TrivialFunction
PROCEDURE Fetch_Tax_Codes___ (
   tax_info_table_           OUT Tax_Handling_Util_API.tax_information_table,
   source_key_rec_           IN  Tax_Handling_Util_API.source_key_rec,
   tax_line_param_rec_       IN  tax_line_param_rec,
   external_tax_calc_method_ IN  VARCHAR2)
IS
   validation_rec_           Tax_Handling_Util_API.validation_rec;
BEGIN
   validation_rec_ := Tax_Handling_Util_API.Create_Validation_Rec(calc_base_                   => 'NET_BASE',
                                                                  fetch_validate_action_       => 'FETCH_IF_VALID',
                                                                  validate_tax_from_tax_class_ => Fnd_Boolean_API.DB_FALSE,
                                                                  attr_                        => NULL);
                                                                     
   IF (tax_line_param_rec_.fetch_saved_tax = TRUE) THEN
      -- When taxes are already fetched and saved, using them for the calculation
      Tax_Handling_Util_API.Fetch_Saved_Tax_Codes (tax_info_table_        => tax_info_table_,
                                                   company_               => tax_line_param_rec_.company,
                                                   party_type_db_         => NULL,
                                                   tax_code_              => tax_line_param_rec_.tax_code,
                                                   tax_calc_structure_id_ => tax_line_param_rec_.tax_calc_structure_id,
                                                   tax_liability_date_    => tax_line_param_rec_.date_applied,
                                                   source_key_rec_        => source_key_rec_,
                                                   validation_rec_        => validation_rec_,
                                                   add_tax_curr_amount_   => NULL);
   ELSE
      IF (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_NOT_USED) THEN
         -- When no external tax caluculation method is used, consider entered tax structure or tax code.
         -- NOTE: In Tax Document, it's always entered tax structure and tax code is used and don't have any basic data setup to fetch.
         IF (tax_line_param_rec_.tax_calc_structure_id IS NOT NULL) THEN
            -- Used tax calculation structure if exist
            Tax_Handling_Util_API.Fetch_Tax_Codes_On_Tax_Str (tax_info_table_        => tax_info_table_,
                                                              company_               => tax_line_param_rec_.company,
                                                              party_type_db_         => NULL,
                                                              tax_calc_structure_id_ => tax_line_param_rec_.tax_calc_structure_id,
                                                              tax_liability_date_    =>  tax_line_param_rec_.date_applied,
                                                              validation_rec_        => validation_rec_);
                                                              
         ELSIF(tax_line_param_rec_.tax_code IS NOT NULL) THEN
            -- Then consider entered tax code
            Tax_Handling_Util_API.Add_Tax_Code_Info(tax_info_table_             => tax_info_table_, 
                                                    company_                    => tax_line_param_rec_.company, 
                                                    party_type_db_              => NULL, 
                                                    tax_code_                   => tax_line_param_rec_.tax_code, 
                                                    tax_calc_structure_id_      => NULL, 
                                                    tax_calc_structure_item_id_ => NULL, 
                                                    in_fetch_validate_action_   => 'FETCH_ALWAYS', 
                                                    in_tax_percentage_          => NULL, 
                                                    tax_liability_date_         => tax_line_param_rec_.date_applied, 
                                                    cst_code_                   => NULL, 
                                                    legal_tax_class_            => NULL);   
         END IF;
      ELSE
         -- When external tax calculation method is used. 
         Fetch_External_Tax_Info___ (tax_info_table_,
                                     source_key_rec_,
                                     tax_line_param_rec_,
                                     external_tax_calc_method_);
      END IF;
   END IF;
END Fetch_Tax_Codes___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Calculate_Line_Totals___ (
   line_amount_rec_       OUT Tax_Handling_Util_API.line_amount_rec, 
   tax_info_table_     IN OUT Tax_Handling_Util_API.tax_information_table,     
   tax_line_param_rec_ IN     tax_line_param_rec)
IS
   acc_curr_rec_              Tax_Handling_Util_API.acc_curr_rec;
   trans_curr_rec_            Tax_Handling_Util_API.trans_curr_rec;
   para_curr_rec_             Tax_Handling_Util_API.para_curr_rec;
   acc_currency_code_         VARCHAR2(3);
   currency_conv_factor_      NUMBER;
   currency_rate_             NUMBER;
   para_currency_conv_factor_ NUMBER;
   para_currency_rate_        NUMBER;
   para_curr_inverted_        VARCHAR2(5);
BEGIN
   -- Note: Here it is considered accounting currency as the transaction currency
   acc_currency_code_ :=  Company_Finance_API.Get_Currency_Code(tax_line_param_rec_.company);
   
   Currency_Rate_API.Get_Currency_Rate(currency_conv_factor_, 
                                       currency_rate_, 
                                       tax_line_param_rec_.company, 
                                       acc_currency_code_, 
                                       Currency_Type_API.Get_Default_Type(tax_line_param_rec_.company), 
                                       tax_line_param_rec_.date_applied);
                                       
   Currency_Rate_API.Get_Parallel_Currency_Rate(para_currency_rate_, 
                                                para_currency_conv_factor_,
                                                para_curr_inverted_,
                                                tax_line_param_rec_.company, 
                                                acc_currency_code_, 
                                                tax_line_param_rec_.date_applied);                                   

   line_amount_rec_ := Tax_Handling_Util_API.Create_Line_Amount_Rec(line_gross_curr_amount_ => NULL, 
                                                                    line_net_curr_amount_   => tax_line_param_rec_.net_amount, 
                                                                    tax_calc_base_amount_   => NULL, 
                                                                    calc_base_              => 'NET_BASE', 
                                                                    consider_use_tax_       => Fnd_Boolean_API.DB_FALSE, 
                                                                    attr_                   => NULL);
   
   trans_curr_rec_  := Tax_Handling_Util_API.Create_Trans_Curr_Rec(company_             => tax_line_param_rec_.company,
                                                                   identity_            => NULL,
                                                                   party_type_db_       => NULL, 
                                                                   currency_            => acc_currency_code_,
                                                                   delivery_address_id_ => NULL,
                                                                   attr_                => NULL,
                                                                   tax_rounding_        => NULL,
                                                                   curr_rounding_       => NULL);
   
   acc_curr_rec_    := Tax_Handling_Util_API.Create_Acc_Curr_Rec(company_           => tax_line_param_rec_.company,
                                                                 attr_              => NULL,
                                                                 curr_rate_         => currency_rate_,
                                                                 conv_factor_       => currency_conv_factor_,                                                                  
                                                                 acc_curr_rounding_ => NULL);
   
   para_curr_rec_   := Tax_Handling_Util_API.Create_Para_Curr_Rec(company_                => tax_line_param_rec_.company,
                                                                  currency_               => acc_currency_code_,
                                                                  calculate_para_amounts_ => Fnd_Boolean_API.DB_TRUE,
                                                                  attr_                   => NULL,
                                                                  para_curr_rate_         => para_currency_rate_,
                                                                  para_conv_factor_       => para_currency_conv_factor_,
                                                                  para_curr_rounding_     => NULL);

   -- Calculate tax line totals   
   Tax_Handling_Util_API.Calc_Line_Total_Amounts(tax_info_table_, 
                                                 line_amount_rec_,
                                                 tax_line_param_rec_.company,
                                                 trans_curr_rec_,
                                                 acc_curr_rec_,
                                                 para_curr_rec_);
END Calculate_Line_Totals___;

PROCEDURE Calc_Taxs_And_Non_Ded_Taxs___ (
   line_amount_rec_          IN OUT Tax_Handling_Util_API.line_amount_rec, 
   tax_info_table_           IN OUT Tax_Handling_Util_API.tax_information_table,     
   tax_line_param_rec_       IN     tax_line_param_rec,
   external_tax_calc_method_ IN     VARCHAR2)
IS
   tax_document_rec_            Tax_Document_API.Public_Rec;
   db_site_                     VARCHAR2(20)  := Sender_Receiver_Type_API.DB_SITE;
   tax_code_rec_                Statutory_Fee_API.Public_Rec; 
   tax_rounding_method_db_      VARCHAR2(20);
   acc_currency_code_           VARCHAR2(3);
   acc_currency_rounding_       NUMBER;
   currency_conv_factor_        NUMBER;
   currency_rate_               NUMBER;
BEGIN  
   IF (tax_info_table_.COUNT > 0) THEN
      tax_document_rec_ := Tax_Document_API.Get(tax_line_param_rec_.company, tax_line_param_rec_.tax_document_no);

      IF (tax_document_rec_.direction = Tax_Document_Direction_API.DB_OUTBOUND) THEN
         IF (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_NOT_USED) THEN
            line_amount_rec_.line_tax_curr_amount := line_amount_rec_.line_tax_curr_amount + line_amount_rec_.line_non_ded_tax_curr_amount;
            line_amount_rec_.line_tax_dom_amount  := line_amount_rec_.line_tax_dom_amount + line_amount_rec_.line_non_ded_tax_dom_amount;
            line_amount_rec_.line_tax_para_amount := line_amount_rec_.line_tax_para_amount + line_amount_rec_.line_non_ded_tax_para_amount;

            IF NOT((tax_document_rec_.sender_type = db_site_) AND (tax_document_rec_.receiver_type = db_site_)) THEN
               line_amount_rec_.line_non_ded_tax_curr_amount := 0;
               line_amount_rec_.line_non_ded_tax_dom_amount  := 0;
               line_amount_rec_.line_non_ded_tax_para_amount := 0;
            END IF;

            FOR i IN 1 .. tax_info_table_.COUNT LOOP
               tax_info_table_(i).tax_curr_amount := tax_info_table_(i).tax_curr_amount + tax_info_table_(i).non_ded_tax_curr_amount; 
               tax_info_table_(i).tax_dom_amount  := tax_info_table_(i).tax_dom_amount + tax_info_table_(i).non_ded_tax_dom_amount; 
               tax_info_table_(i).tax_para_amount := tax_info_table_(i).tax_para_amount + tax_info_table_(i).non_ded_tax_para_amount; 
               
               IF NOT((tax_document_rec_.sender_type = db_site_) AND (tax_document_rec_.receiver_type = db_site_)) THEN
                  tax_info_table_(i).non_ded_tax_curr_amount  := 0; 
                  tax_info_table_(i).non_ded_tax_dom_amount   := 0; 
                  tax_info_table_(i).non_ded_tax_para_amount  := 0;                  
               END IF;
            END LOOP;
         ELSIF (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN
            IF ((tax_document_rec_.sender_type = db_site_) AND (tax_document_rec_.receiver_type = db_site_)) THEN
               tax_rounding_method_db_   := Company_Tax_Control_API.Get_Tax_Rounding_Method_Db(tax_line_param_rec_.company);
               acc_currency_code_        := Company_Finance_API.Get_Currency_Code(tax_line_param_rec_.company);
               acc_currency_rounding_    := Currency_Code_API.Get_Currency_Rounding(tax_line_param_rec_.company, acc_currency_code_);

               Currency_Rate_API.Get_Currency_Rate(currency_conv_factor_, 
                                                   currency_rate_, 
                                                   tax_line_param_rec_.company, 
                                                   acc_currency_code_, 
                                                   Currency_Type_API.Get_Default_Type(tax_line_param_rec_.company), 
                                                   tax_line_param_rec_.date_applied);


               FOR i IN 1 .. tax_info_table_.COUNT LOOP
                  tax_code_rec_ := Statutory_Fee_API.Fetch_Validate_Tax_Code_Rec(tax_line_param_rec_.company, 
                                                                                 tax_info_table_(i).tax_code, 
                                                                                 tax_line_param_rec_.date_applied, 
                                                                                 Fnd_Boolean_API.DB_FALSE, 
                                                                                 Fnd_Boolean_API.DB_TRUE, 
                                                                                 'FETCH_ALWAYS');   
                  tax_info_table_(i).non_ded_tax_curr_amount := Currency_Amount_API.Round_Amount(tax_rounding_method_db_,
                                                                                                 tax_info_table_(i).tax_curr_amount*(1-tax_code_rec_.deductible/100),
                                                                                                 acc_currency_rounding_); 
                  -- Since transaction currency and accounting currency is same    
                  tax_info_table_(i).non_ded_tax_dom_amount  := tax_info_table_(i).non_ded_tax_curr_amount; 

                  tax_info_table_(i).non_ded_tax_para_amount := Currency_Amount_API.Calc_Parallel_Amt_Rate_Round(tax_line_param_rec_.company,
                                                                                                                 tax_info_table_(i).non_ded_tax_dom_amount,
                                                                                                                 tax_info_table_(i).non_ded_tax_curr_amount,
                                                                                                                 acc_currency_code_,
                                                                                                                 acc_currency_code_,
                                                                                                                 currency_rate_,
                                                                                                                 currency_conv_factor_,
                                                                                                                 'FALSE');               
               END LOOP; 
            END IF;
         END IF;
      END IF; 
   END IF;
END Calc_Taxs_And_Non_Ded_Taxs___;


@IgnoreUnitTest TrivialFunction
PROCEDURE Add_Transaction_Tax_Info___ (
   line_amount_rec_       OUT Tax_Handling_Util_API.line_amount_rec,  
   tax_line_param_rec_    IN  tax_line_param_rec )
IS
   tax_info_table_           Tax_Handling_Util_API.tax_information_table;
   source_key_rec_           Tax_Handling_Util_API.source_key_rec;
   external_tax_calc_method_ VARCHAR2(50);
BEGIN  
   external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(tax_line_param_rec_.company); 
   source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_ => Tax_Source_API.DB_TAX_DOCUMENT_LINE,      
                                                                  source_ref1_     => TO_CHAR(tax_line_param_rec_.tax_document_no),
                                                                  source_ref2_     => TO_CHAR(tax_line_param_rec_.tax_document_line_no),
                                                                  source_ref3_     => '*',
                                                                  source_ref4_     => '*',
                                                                  source_ref5_     => '*',
                                                                  attr_            => NULL);
   
   Fetch_Tax_Codes___(tax_info_table_,
                      source_key_rec_,
                      tax_line_param_rec_,
                      external_tax_calc_method_);
   
   IF (tax_info_table_.COUNT > 0) THEN
      Calculate_Line_Totals___(line_amount_rec_, 
                               tax_info_table_,  
                               tax_line_param_rec_);

      Calc_Taxs_And_Non_Ded_Taxs___(line_amount_rec_, 
                                    tax_info_table_,     
                                    tax_line_param_rec_,
                                    external_tax_calc_method_);

      IF (tax_line_param_rec_.add_tax_lines) THEN
         Source_Tax_Item_Discom_API.Remove_Tax_Items(source_key_rec_, 
                                                     tax_line_param_rec_.company);
                                                     
         Source_Tax_Item_Discom_API.Create_Tax_Items(tax_info_table_, 
                                                     source_key_rec_, 
                                                     tax_line_param_rec_.company);
      END IF;  
   END IF;
END Add_Transaction_Tax_Info___;


@IgnoreUnitTest TrivialFunction
FUNCTION Create_Tax_Line_Param_Rec___ (   
   company_                IN VARCHAR2,
   tax_code_               IN VARCHAR2,
   tax_calc_structure_id_  IN VARCHAR2,
   tax_document_no_        IN NUMBER,   
   tax_document_line_no_   IN NUMBER,
   price_                  IN NUMBER,
   quantity_               IN NUMBER,      
   net_amount_             IN NUMBER,
   date_applied_           IN DATE,
   add_tax_lines_          IN BOOLEAN,
   fetch_saved_tax_        IN BOOLEAN) RETURN tax_line_param_rec
IS 
   tax_line_param_rec_     tax_line_param_rec;
BEGIN  			
   tax_line_param_rec_.company                := company_;
   tax_line_param_rec_.tax_code               := tax_code_;   
   tax_line_param_rec_.tax_calc_structure_id  := tax_calc_structure_id_;
   tax_line_param_rec_.tax_document_no        := tax_document_no_;
   tax_line_param_rec_.tax_document_line_no   := tax_document_line_no_; 
   tax_line_param_rec_.price                  := price_;
   tax_line_param_rec_.quantity               := quantity_;   
   tax_line_param_rec_.net_amount             := net_amount_;
   tax_line_param_rec_.date_applied           := date_applied_;
   tax_line_param_rec_.add_tax_lines          := add_tax_lines_;
   tax_line_param_rec_.fetch_saved_tax        := fetch_saved_tax_;   
   
   RETURN tax_line_param_rec_;
END Create_Tax_Line_Param_Rec___;


PROCEDURE Create_Ext_Tax_Param_In_Rec___ (
   ext_tax_param_in_rec_     OUT External_Tax_System_Util_API.ext_tax_param_in_rec,
   tax_line_param_rec_       IN  tax_line_param_rec,
   source_key_rec_           IN  Tax_Handling_Util_API.source_key_rec,
   external_tax_calc_method_ IN  VARCHAR2)
IS
   source_ref1_                  VARCHAR2(50);
   source_ref2_                  VARCHAR2(50);
   source_ref3_                  VARCHAR2(50);
   source_ref4_                  VARCHAR2(50);
   object_id_                    VARCHAR2(25);
   quantity_                     NUMBER;
   tax_document_addr_rec_        Tax_Document_API.Tax_Document_Addr_Rec; 
   avalara_brazil_specific_rec_  Avalara_Brazil_Specific_Rec;
BEGIN
   source_ref1_ := source_key_rec_.source_ref1;
   source_ref2_ := source_key_rec_.source_ref2;
   source_ref3_ := source_key_rec_.source_ref3;
   source_ref4_ := source_key_rec_.source_ref4;         

   IF (source_key_rec_.source_ref_type = Tax_Source_API.DB_TAX_DOCUMENT_LINE) THEN
      tax_document_addr_rec_ := Tax_Document_API.Get_Address_Information(tax_line_param_rec_.company, source_ref1_);
      Tax_Document_Line_API.Get_External_Tax_Info(quantity_,
                                                  avalara_brazil_specific_rec_,
                                                  tax_line_param_rec_.company, 
                                                  source_ref1_, 
                                                  source_ref2_);
      ext_tax_param_in_rec_.source_type  := 'TAX_DOCUMENT_LINE';
   END IF;

   object_id_ := avalara_brazil_specific_rec_.part_no;

   IF (tax_document_addr_rec_.sender_addr_id IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOSENDERADDR: Please provide a Sender Address .');
   END IF;
   
   IF (tax_document_addr_rec_.document_addr_id IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NODOCADDR: Please provide a Document Address');
   END IF;

   IF (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN
      ext_tax_param_in_rec_.company               := tax_line_param_rec_.company;
      ext_tax_param_in_rec_.object_id             := object_id_;
      ext_tax_param_in_rec_.cust_del_address1     := tax_document_addr_rec_.receiver_address1;
      ext_tax_param_in_rec_.cust_del_address2     := tax_document_addr_rec_.receiver_address2;                 
      ext_tax_param_in_rec_.cust_del_zip_code     := tax_document_addr_rec_.receiver_zip_code;               
      ext_tax_param_in_rec_.cust_del_city         := tax_document_addr_rec_.receiver_city;               
      ext_tax_param_in_rec_.cust_del_state        := tax_document_addr_rec_.receiver_state;               
      ext_tax_param_in_rec_.cust_del_county       := tax_document_addr_rec_.receiver_county;
      ext_tax_param_in_rec_.cust_del_country      := tax_document_addr_rec_.receiver_country;
      ext_tax_param_in_rec_.comp_del_address1     := tax_document_addr_rec_.sender_address1;
      ext_tax_param_in_rec_.comp_del_address2     := tax_document_addr_rec_.sender_address2;                 
      ext_tax_param_in_rec_.comp_del_zip_code     := tax_document_addr_rec_.sender_zip_code;               
      ext_tax_param_in_rec_.comp_del_city         := tax_document_addr_rec_.sender_city;               
      ext_tax_param_in_rec_.comp_del_state        := tax_document_addr_rec_.sender_state;               
      ext_tax_param_in_rec_.comp_del_county       := tax_document_addr_rec_.sender_county;
      ext_tax_param_in_rec_.comp_del_country      := tax_document_addr_rec_.sender_country ;               
      ext_tax_param_in_rec_.comp_doc_address1     := tax_document_addr_rec_.document_address1;
      ext_tax_param_in_rec_.comp_doc_address2     := tax_document_addr_rec_.document_address2;                 
      ext_tax_param_in_rec_.comp_doc_zip_code     := tax_document_addr_rec_.document_zip_code;               
      ext_tax_param_in_rec_.comp_doc_city         := tax_document_addr_rec_.document_city;               
      ext_tax_param_in_rec_.comp_doc_state        := tax_document_addr_rec_.document_state;               
      ext_tax_param_in_rec_.comp_doc_county       := tax_document_addr_rec_.document_county;
      ext_tax_param_in_rec_.comp_doc_country      := tax_document_addr_rec_.document_country; 
      
      IF (source_key_rec_.source_ref_type = Tax_Source_API.DB_TAX_DOCUMENT_LINE) THEN
         ext_tax_param_in_rec_.object_desc :=  avalara_brazil_specific_rec_.part_description;  
      END IF;
      
      ext_tax_param_in_rec_.quantity                                        := tax_line_param_rec_.quantity;
      ext_tax_param_in_rec_.avalara_brazil_specific.ship_addr_no            := avalara_brazil_specific_rec_.ship_addr_no;
      ext_tax_param_in_rec_.avalara_brazil_specific.doc_addr_no             := avalara_brazil_specific_rec_.doc_addr_no;
      ext_tax_param_in_rec_.avalara_brazil_specific.document_code           := avalara_brazil_specific_rec_.document_code;
      ext_tax_param_in_rec_.avalara_brazil_specific.catalog_no              := object_id_;
      ext_tax_param_in_rec_.avalara_brazil_specific.sale_unit_price         := tax_line_param_rec_.price;
      ext_tax_param_in_rec_.avalara_brazil_specific.external_use_type       := avalara_brazil_specific_rec_.external_use_type;
      ext_tax_param_in_rec_.avalara_brazil_specific.business_transaction_id := avalara_brazil_specific_rec_.business_transaction_id;
      ext_tax_param_in_rec_.avalara_brazil_specific.order_no                := avalara_brazil_specific_rec_.source_ref1;
      ext_tax_param_in_rec_.avalara_brazil_specific.line_no                 := avalara_brazil_specific_rec_.source_ref2;
      ext_tax_param_in_rec_.avalara_brazil_specific.statistical_code        := avalara_brazil_specific_rec_.statistical_code;
      ext_tax_param_in_rec_.avalara_brazil_specific.cest_code               := avalara_brazil_specific_rec_.cest_code;
      ext_tax_param_in_rec_.avalara_brazil_specific.sales_unit_meas         := avalara_brazil_specific_rec_.unit_meas;
      ext_tax_param_in_rec_.avalara_brazil_specific.acquisition_origin      := avalara_brazil_specific_rec_.acquisition_origin;
      ext_tax_param_in_rec_.avalara_brazil_specific.product_type_classif    := avalara_brazil_specific_rec_.product_type_classif;
   END IF;  
END Create_Ext_Tax_Param_In_Rec___;

--------------------------------------------------------------------
-- Fetch_External_Tax_Info
--    Fetches and updates tax information from an external tax system
--------------------------------------------------------------------
@IgnoreUnitTest TrivialFunction
PROCEDURE Fetch_External_Tax_Info___ (
   tax_info_table_           OUT Tax_Handling_Util_API.tax_information_table,
   source_key_rec_           IN  Tax_Handling_Util_API.source_key_rec,
   tax_line_param_rec_       IN  tax_line_param_rec,
   external_tax_calc_method_ IN  VARCHAR2)
IS
   ext_tax_param_in_rec_         External_Tax_System_Util_API.ext_tax_param_in_rec;
   complementary_info_           VARCHAR2(2000);
   business_operation_arr_       External_Tax_System_Util_API.Business_Operation_Rec_Arr;
   citation_info_                VARCHAR2(2000);
   xml_trans_                    CLOB;
BEGIN
   IF (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN
      IF (source_key_rec_.source_ref_type IN (Tax_Source_API.DB_TAX_DOCUMENT_LINE)) THEN
         ext_tax_param_in_rec_ := NULL;
         Create_Ext_Tax_Param_In_Rec___(ext_tax_param_in_rec_, tax_line_param_rec_, source_key_rec_, external_tax_calc_method_);

         IF (ext_tax_param_in_rec_.company IS NOT NULL) THEN
            External_Tax_System_Util_API.Fetch_Tax_From_External_System(tax_info_table_, complementary_info_, citation_info_, business_operation_arr_, ext_tax_param_in_rec_, xml_trans_);
         END IF;
      END IF;

   END IF;
END Fetch_External_Tax_Info___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@IgnoreUnitTest TrivialFunction
PROCEDURE Add_Transaction_Tax_Info (  
   company_                IN  VARCHAR2,
   tax_code_               IN  VARCHAR2,
   tax_calc_structure_id_  IN  VARCHAR2,
   tax_document_no_        IN  NUMBER,   
   tax_document_line_no_   IN  NUMBER,
   price_                  IN  NUMBER,
   quantity_               IN  NUMBER,   
   net_amount_             IN  NUMBER,
   date_applied_           IN  DATE )
IS
   tax_line_param_rec_     tax_line_param_rec;
   line_amount_rec_        Tax_Handling_Util_API.line_amount_rec;
BEGIN 
   tax_line_param_rec_ := Create_Tax_Line_Param_Rec___(company_,
                                                       tax_code_,
                                                       tax_calc_structure_id_, 
                                                       tax_document_no_, 
                                                       tax_document_line_no_,
                                                       price_,
                                                       quantity_,
                                                       net_amount_, 
                                                       date_applied_, 
                                                       add_tax_lines_   => TRUE,
                                                       fetch_saved_tax_ => FALSE);   
   Add_Transaction_Tax_Info___(line_amount_rec_, tax_line_param_rec_);   
END Add_Transaction_Tax_Info;

--------------------------------------------------------------------
-- Get_Price_Incl_Tax
--    This fuction will calculate and return price including tax 
--    for a given price (net amount) using already fetched taxes.
--------------------------------------------------------------------
@IgnoreUnitTest TrivialFunction
@UncheckedAccess
FUNCTION Get_Price_Incl_Tax (
   company_                IN VARCHAR2,
   tax_document_no_        IN NUMBER,
   tax_document_line_no_   IN NUMBER,
   tax_code_               IN VARCHAR2,
   tax_calc_structure_id_  IN VARCHAR2,
   price_                  IN NUMBER) RETURN NUMBER
IS   
   tax_line_param_rec_     tax_line_param_rec;
   line_amount_rec_        Tax_Handling_Util_API.line_amount_rec;
BEGIN   
   -- Note: Here price is considered as the net amount for the tax calculations. 
   tax_line_param_rec_ := Create_Tax_Line_Param_Rec___(company_               => company_,
                                                       tax_code_              => tax_code_,
                                                       tax_calc_structure_id_ => tax_calc_structure_id_, 
                                                       tax_document_no_       => tax_document_no_, 
                                                       tax_document_line_no_  => tax_document_line_no_,
                                                       price_                 => NULL,
                                                       quantity_              => NULL,
                                                       net_amount_            => price_,   
                                                       date_applied_          => SYSDATE, 
                                                       add_tax_lines_         => FALSE,
                                                       fetch_saved_tax_       => TRUE);  
   Add_Transaction_Tax_Info___(line_amount_rec_, tax_line_param_rec_);
   RETURN line_amount_rec_.line_gross_curr_amount;
END Get_Price_Incl_Tax;

@IgnoreUnitTest TrivialFunction
PROCEDURE Transfer_Tax_Lines (
   company_                    IN  VARCHAR2,
   from_source_ref_type_       IN  VARCHAR2,
   from_source_ref1_           IN  VARCHAR2,
   from_source_ref2_           IN  VARCHAR2,
   from_source_ref3_           IN  VARCHAR2,
   from_source_ref4_           IN  VARCHAR2,
   from_source_ref5_           IN  VARCHAR2,
   to_source_ref1_             IN  VARCHAR2)
IS
   source_tax_table_             Source_Tax_Item_API.source_tax_table;
   from_tax_document_rec_        Tax_Document_API.Public_Rec;
   db_site_                      VARCHAR2(20)  := Sender_Receiver_Type_API.DB_SITE;
   handle_non_deductible_taxes_  BOOLEAN := FALSE;      
BEGIN
   -- Tranfer tax lines from outgoing tax document to incoming tax document
   source_tax_table_  := Source_Tax_Item_API.Get_Tax_Items(company_, from_source_ref_type_, from_source_ref1_, from_source_ref2_, from_source_ref3_, from_source_ref4_, from_source_ref5_);
   IF (source_tax_table_.COUNT > 0) THEN
      from_tax_document_rec_ := Tax_Document_API.Get(company_, from_source_ref1_);
     
      IF (from_tax_document_rec_.sender_type = db_site_) AND (from_tax_document_rec_.receiver_type = db_site_) THEN
         handle_non_deductible_taxes_  := TRUE;
      END IF;
      FOR i IN source_tax_table_.FIRST .. source_tax_table_.LAST LOOP
         IF (handle_non_deductible_taxes_) THEN
            source_tax_table_(i).tax_curr_amount      := source_tax_table_(i).tax_curr_amount - source_tax_table_(i).non_ded_tax_curr_amount; 
            source_tax_table_(i).tax_dom_amount       := source_tax_table_(i).tax_dom_amount - source_tax_table_(i).non_ded_tax_dom_amount; 
            source_tax_table_(i).tax_parallel_amount  := source_tax_table_(i).tax_parallel_amount - source_tax_table_(i).non_ded_tax_parallel_amount;
         END IF;

         -- from_source_ref values used for to_source_ref valuces since from_source_ref2_ ... from_source_ref5_ values are same as to_source_ref2_ ... to_source_ref5_
         Source_Tax_Item_Discom_API.New(company_, 
                                        from_source_ref_type_, 
                                        to_source_ref1_, 
                                        from_source_ref2_, 
                                        from_source_ref3_, 
                                        from_source_ref4_,
                                        from_source_ref5_, 
                                        source_tax_table_(i).tax_item_id, 
                                        source_tax_table_(i).tax_code,
                                        source_tax_table_(i).tax_calc_structure_id, 
                                        source_tax_table_(i).tax_calc_structure_item_id,
                                        source_tax_table_(i).tax_percentage, 
                                        source_tax_table_(i).tax_curr_amount, 
                                        source_tax_table_(i).tax_dom_amount, 
                                        source_tax_table_(i).tax_parallel_amount,
                                        source_tax_table_(i).tax_base_curr_amount, 
                                        source_tax_table_(i).tax_base_dom_amount,
                                        source_tax_table_(i).tax_base_parallel_amount,
                                        source_tax_table_(i).non_ded_tax_curr_amount,
                                        source_tax_table_(i).non_ded_tax_dom_amount,
                                        source_tax_table_(i).non_ded_tax_parallel_amount,
                                        source_tax_table_(i).tax_limit_curr_amount,                                        
                                        source_tax_table_(i).cst_code, 
                                        source_tax_table_(i).legal_tax_class,
                                        source_tax_table_(i).tax_category1, 
                                        source_tax_table_(i).tax_category2 );
      END LOOP;
   END IF;
END Transfer_Tax_Lines;

-------------------- METHODS FOR TAX LINE ASSISTANT IN AURENA ---------------

@IgnoreUnitTest TrivialFunction
FUNCTION Fetch_Source_Ref___ (
   attr_              IN VARCHAR2 ) RETURN Tax_Handling_Util_API.Source_Info_Rec
IS
   source_info_rec_                Tax_Handling_Util_API.Source_Info_Rec;
   tax_document_line_rec_          Tax_Document_Line_API.Public_Rec;
   dummy_                          NUMBER;
   direction_db_                   tax_document_tab.direction%TYPE;
BEGIN
   source_info_rec_.company               := Client_SYS.Get_Item_Value('COMPANY', attr_); 
   source_info_rec_.source_ref_type_db    := Tax_Source_API.DB_TAX_DOCUMENT_LINE;      
   source_info_rec_.source_ref1           := Client_SYS.Get_Item_Value('TAX_DOCUMENT_NO', attr_); 
   source_info_rec_.source_ref2           := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   source_info_rec_.source_ref3           := '*';
   source_info_rec_.source_ref4           := '*';
   source_info_rec_.source_ref5           := '*'; 
   tax_document_line_rec_                 := Tax_Document_Line_API.Get(
                                                               source_info_rec_.company, 
                                                               source_info_rec_.source_ref1, 
                                                               source_info_rec_.source_ref2); 
   source_info_rec_.gross_curr_amount     := tax_document_line_rec_.gross_amount;                                        
   source_info_rec_.net_curr_amount       := tax_document_line_rec_.net_amount;
   source_info_rec_.tax_calc_structure_id := tax_document_line_rec_.tax_calc_structure_id;

   direction_db_ := Tax_Document_API.Get_Direction_Db(source_info_rec_.company, 
                                                      source_info_rec_.source_ref1);
   IF (direction_db_ = Tax_Document_Direction_API.DB_OUTBOUND) THEN
      source_info_rec_.tax_curr_amount       := tax_document_line_rec_.tax_amount;
   ELSIF  (direction_db_ = Tax_Document_Direction_API.DB_INBOUND) THEN
      Source_Tax_Item_API.Get_Line_Tax_Code_Info ( dummy_, 
                                                   dummy_, 
                                                   source_info_rec_.tax_curr_amount, 
                                                   dummy_, 
                                                   dummy_, 
                                                   source_info_rec_.non_ded_tax_curr_amount, 
                                                   dummy_, 
                                                   dummy_, 
                                                   source_info_rec_.company, 
                                                   Tax_Source_API.DB_TAX_DOCUMENT_LINE,
                                                   source_info_rec_.source_ref1, 
                                                   source_info_rec_.source_ref2, 
                                                   '*', 
                                                   '*', 
                                                   '*');
      source_info_rec_.total_tax_curr_amount := source_info_rec_.tax_curr_amount + source_info_rec_.non_ded_tax_curr_amount;
   END IF;
   RETURN source_info_rec_;
END Fetch_Source_Ref___;

@IgnoreUnitTest TrivialFunction 
FUNCTION Fetch_For_Tax_Line_Assistant(    
   attr_                IN VARCHAR2) RETURN Tax_Handling_Util_API.source_info_rec
IS
   source_info_rec_     Tax_Handling_Util_API.source_info_rec;
BEGIN   
   source_info_rec_     := Fetch_Source_Ref___(attr_); 
   source_info_rec_.transaction_currency := Company_Finance_API.Get_Currency_Code(source_info_rec_.Company);
   RETURN source_info_rec_;
END Fetch_For_Tax_Line_Assistant;

@IgnoreUnitTest TrivialFunction
PROCEDURE Save_From_Tax_Line_Assistant (
   company_                      IN VARCHAR2,   
   source_key_rec_               IN Tax_Handling_Util_API.source_key_rec,
   tax_info_table_               IN Tax_Handling_Util_API.tax_information_table) 
IS
BEGIN   
   Source_Tax_Item_Discom_API.Remove_Tax_Items(source_key_rec_, company_);
   Source_Tax_Item_Discom_API.Create_Tax_Items(tax_info_table_, source_key_rec_, company_);
   Tax_Document_Line_API.Modify_Tax_Info(company_, source_key_rec_.source_ref1, source_key_rec_.source_ref2);
END Save_From_Tax_Line_Assistant;

@IgnoreUnitTest TrivialFunction
PROCEDURE Field_Visible_Tax_Line_Assis (
   field_visibility_rec_            IN OUT Tax_Handling_Util_API.tax_assis_field_visibility_rec,   
   package_name_                    IN     VARCHAR2,
   company_                         IN     VARCHAR2,
   source_key_rec_                  IN     Tax_Handling_Util_API.source_key_rec)
IS
   db_true_          VARCHAR2(5)   := Fnd_Boolean_API.DB_TRUE;
   db_site_          VARCHAR2(20)  := Sender_Receiver_Type_API.DB_SITE;
   tax_document_rec_ Tax_Document_API.Public_Rec;   
BEGIN
   IF (package_name_ IN ('TAX_DOCUMENT_LINE_API')) THEN 
      tax_document_rec_ := Tax_Document_API.Get(company_, source_key_rec_.source_ref1);
     
      IF ((tax_document_rec_.direction = Tax_Document_Direction_API.DB_INBOUND) AND
          (tax_document_rec_.sender_type = db_site_) AND
          (tax_document_rec_.receiver_type = db_site_))THEN
         field_visibility_rec_.non_ded_tax_curr_amt_visible := db_true_; 
         field_visibility_rec_.total_tax_curr_amount_visible := db_true_;
         field_visibility_rec_.deductible_percentage_visible := db_true_;
         field_visibility_rec_.sum_non_ded_curr_amt_visible := db_true_;
         field_visibility_rec_.sum_tot_tax_curr_amt_visible := db_true_;
      END IF;
   END IF; 

END Field_Visible_Tax_Line_Assis;


FUNCTION Allow_Edit_Tax_Information (
   company_         IN VARCHAR2,
   tax_document_no_ IN NUMBER,
   line_no_         IN NUMBER ) RETURN VARCHAR2
IS
   tax_document_rec_ Tax_Document_API.Public_Rec;
BEGIN
   IF (Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_) = 'NOT_USED') THEN
      tax_document_rec_ := Tax_Document_API.Get(company_, tax_document_no_);   
      IF ((tax_document_rec_.direction = 'OUTBOUND') AND 
          (tax_document_rec_.rowstate = 'Preliminary') AND
          (Source_Tax_Item_API.Tax_Items_Exist(company_, Tax_Source_API.DB_TAX_DOCUMENT_LINE, tax_document_no_, line_no_, '*', '*', '*') = 'FALSE' )) THEN
         RETURN 'TRUE';   
      END IF;
   END IF;
   RETURN 'FALSE';
END Allow_Edit_Tax_Information;
