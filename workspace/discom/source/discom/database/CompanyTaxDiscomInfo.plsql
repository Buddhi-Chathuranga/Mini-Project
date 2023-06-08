-----------------------------------------------------------------------------
--
--  Logical unit: CompanyTaxDiscomInfo
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211208  MaEelk  SC21R2-6474, CreateTaxDocument was modeled as a BOOLEAN so the 'FALSE' value was set to CREATE_TAX_DOCUMENT in Prepare_Insert___()
--  211129  HasTlk  SC21R2-5512, Modified Prepare_Insert___() to set 'FALSE' as the default value for CREATE_TAX_DOCUMENT_DB.
--  200608  MalLlk  GESPRING20-4617, Modified Prepare_Insert___() to set 'PART_COST' as the default value for TAX_BASIS_SOURCE.
--  200203  Thpelk  Bug 152017 - Modified Validate_Tax___() to use company valid from date set in APP_CONTEXT 'CreateCompany_Valid_From' in ENTERP for tax_code validations.
--  160406  NWeelk  STRLOC-342, Added method Calc_Threshold_Amount_Curr.
--  160202  SURBLK  Created. 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Tax___ (
   newrec_ IN OUT company_tax_discom_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec)
IS
   tax_types_event_  VARCHAR2(20):= 'COMMON';
   valid_date_       DATE;
BEGIN
   valid_date_ := App_Context_SYS.Find_Date_Value('CreateCompany_Valid_From', SYSDATE);
   -- Validate the tax code
   IF (indrec_.tax_code) THEN 
      Tax_Handling_Util_API.Validate_Tax_On_Basic_Data(newrec_.company, tax_types_event_, newrec_.tax_code, 'ALL', valid_date_);
   END IF;
   -- Validate the tax fee tax code
   IF (indrec_.tax_free_tax_code) THEN 
      Tax_Handling_Util_API.Validate_Tax_On_Basic_Data(newrec_.company, tax_types_event_, newrec_.tax_free_tax_code, 'EXEMPT', valid_date_);
   END IF;
END Validate_Tax___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ORDER_TAXABLE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('PURCH_TAXABLE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_ORD_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_PUR_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('TAX_BASIS_SOURCE_DB', 'PART_COST', attr_);
   Client_SYS.Add_To_Attr('CREATE_TAX_DOCUMENT', 'FALSE', attr_);
END Prepare_Insert___;

@Override
PROCEDURE Import_Assign___ (
   newrec_      IN OUT company_tax_discom_info_tab%ROWTYPE,
   crecomp_rec_ IN     Enterp_Comp_Connect_V170_API.Crecomp_Lu_Public_Rec,
   pub_rec_     IN     Create_Company_Template_Pub%ROWTYPE )
IS
BEGIN
   super(newrec_, crecomp_rec_, pub_rec_);
   $IF Component_Invoic_SYS.INSTALLED $THEN
      newrec_.tax_code := pub_rec_.c1 ;
   $ELSE
      newrec_.tax_code := NULL;
   $END 
END Import_Assign___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT company_tax_discom_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF NOT (indrec_.order_taxable) THEN 
      newrec_.order_taxable := 'FALSE';
   END IF;  

   IF NOT (indrec_.purch_taxable) THEN 
      newrec_.purch_taxable := 'FALSE';
   END IF;
   
   IF NOT (indrec_.use_price_incl_tax_pur) THEN 
      newrec_.use_price_incl_tax_pur := 'FALSE';
   END IF;  

   IF NOT (indrec_.use_price_incl_tax_ord) THEN 
      newrec_.use_price_incl_tax_ord := 'FALSE';
   END IF;
   
   super(newrec_, indrec_, attr_);
   Validate_Tax___(newrec_, indrec_);
   --Add post-processing code here
END Check_Insert___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     company_tax_discom_info_tab%ROWTYPE,
   newrec_ IN OUT company_tax_discom_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Validate_Tax___(newrec_, indrec_);
END Check_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-----------------------------------------------------
-- Calc_Threshold_Amount_Curr
-- Calculates and returns the free samples tax paying  
-- threshold amount in order currency.
-----------------------------------------------------
PROCEDURE Calc_Threshold_Amount_Curr (
   threshold_amt_curr_    OUT    NUMBER,
   company_               IN     VARCHAR2,
   customer_no_           IN     VARCHAR2,
   contract_              IN     VARCHAR2,
   curr_code_             IN     VARCHAR2 )   
IS
   threshold_amount_        NUMBER;
   site_date_               DATE;
   curr_type_               VARCHAR2(10);
   rate_                    NUMBER;
   conv_factor_             NUMBER;
BEGIN
   threshold_amount_ := Get_Tax_Paying_Threshold_Amt(company_);
   threshold_amt_curr_ := 0;
   IF (threshold_amount_ != 0) THEN 
      site_date_ := Site_API.Get_Site_Date(contract_);
      $IF Component_Invoic_SYS.INSTALLED $THEN
         Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, 
                                                        conv_factor_, 
                                                        rate_, 
                                                        company_, 
                                                        curr_code_,
                                                        site_date_, 
                                                        'CUSTOMER', 
                                                        customer_no_);
      $END
      rate_ := rate_ / conv_factor_;

      IF (Company_Finance_API.Get_Currency_Code(company_) = curr_code_) THEN
         threshold_amt_curr_ := threshold_amount_;
      ELSE
         IF (rate_ = 0) THEN
            threshold_amt_curr_ := 0;
         ELSE
            threshold_amt_curr_ := threshold_amount_ / rate_;
         END IF;
      END IF;      
   END IF;   
END Calc_Threshold_Amount_Curr;
