-----------------------------------------------------------------------------
--
--  Logical unit: CurrencyTypeBasicData
--  Component:    ACCRUL
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131116  Umdolk  Refactoring.
--  210529  Kagalk  FI21R2-1438, Add column tax_sell_curr_rate_base.
--  211021  Uppalk  FI21R2-4524, Modified Check_Insert___ and Prepare_Insert___ methods
--  211206  Uppalk  FI21R2-8071, Modified Check_Common___ method.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('USE_TAX_RATES','FALSE',attr_);
   -- gelr:out_inv_curr_rate_voucher_date, begin   
   Client_SYS.Add_To_Attr('TAX_SELL_CURR_RATE_BASE', Base_Date_API.Decode('INVOICE_DATE'), attr_);
   -- gelr:out_inv_curr_rate_voucher_date, end  
   -- gelr:curr_rate_date_incoming_inv, begin
   Client_SYS.Add_To_Attr('TAX_BUY_CURR_RATE_BASE', Base_Date_API.Decode('VOUCHER_DATE'), attr_);
   -- gelr:curr_rate_date_incoming_inv, end
END Prepare_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     currency_type_basic_data_tab%ROWTYPE,
   newrec_ IN OUT currency_type_basic_data_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2)
IS
   emu_currency_            VARCHAR2(6);
   ref_currency_code_       VARCHAR2(3);
   company_currency_code_   VARCHAR2(3);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF ( newrec_.use_tax_rates = 'TRUE') THEN
      Error_SYS.Check_Not_Null(lu_name_, 'TAX_SELL', newrec_.tax_sell);
      Error_SYS.Check_Not_Null(lu_name_, 'TAX_BUY', newrec_.tax_buy);
   END IF;
   company_currency_code_ := Company_Finance_API.Get_Currency_Code(newrec_.company);
   emu_currency_ := Currency_Code_API.Get_Emu(newrec_.company, company_currency_code_);

   IF (indrec_.buy) THEN 
      ref_currency_code_ := Currency_Type_API.Get_Ref_Currency_Code(newrec_.company, newrec_.buy);
      IF (newrec_.buy IS NOT NULL AND emu_currency_ != 'TRUE' AND ref_currency_code_ != 'EUR' AND ref_currency_code_ != company_currency_code_) THEN
         Client_SYS.Add_Info(lu_name_, 'CURRENCYTYPEMSGBUY: Buy currency rate type must have accounting currency as reference currency.');    
      END IF;   
   END IF;  
   IF (indrec_.tax_buy) THEN 
      ref_currency_code_ := Currency_Type_API.Get_Ref_Currency_Code(newrec_.company, newrec_.tax_buy);
      IF (newrec_.tax_buy IS NOT NULL AND emu_currency_ != 'TRUE' AND ref_currency_code_ != 'EUR' AND ref_currency_code_ != company_currency_code_) THEN
         Client_SYS.Add_Info(lu_name_, 'CURRENCYTYPEMSGTAXBUY: Tax Buy currency rate type must have accounting currency as reference currency.');    
      END IF;   
   END IF; 
   IF (indrec_.tax_sell) THEN 
      ref_currency_code_ := Currency_Type_API.Get_Ref_Currency_Code(newrec_.company, newrec_.tax_sell);
      IF (newrec_.tax_sell IS NOT NULL AND emu_currency_ != 'TRUE' AND ref_currency_code_ != 'EUR' AND ref_currency_code_ != company_currency_code_) THEN
         Client_SYS.Add_Info(lu_name_, 'CURRENCYTYPEMSGTAXSELL: Tax Sell currency rate type must have accounting currency as reference currency.');    
      END IF;   
   END IF; 
   IF (indrec_.sell) THEN 
      ref_currency_code_ := Currency_Type_API.Get_Ref_Currency_Code(newrec_.company, newrec_.sell);
      IF (newrec_.sell IS NOT NULL AND emu_currency_ != 'TRUE' AND ref_currency_code_ != 'EUR' AND ref_currency_code_ != company_currency_code_) THEN
         Client_SYS.Add_Info(lu_name_, 'CURRENCYTYPEMSGSELL: Sell currency rate type must have accounting currency as reference currency.');    
      END IF;   
   END IF;  
   -- gelr:out_inv_curr_rate_voucher_date, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(newrec_.company, 'OUT_INV_CURR_RATE_VOUCHER_DATE') = Fnd_Boolean_API.DB_FALSE OR 
      newrec_.use_tax_rates = 'FALSE' ) THEN
      newrec_.tax_sell_curr_rate_base := Base_Date_API.DB_INVOICE_DATE;
   END IF;   
   -- gelr:out_inv_curr_rate_voucher_date, end
   -- gelr:curr_rate_date_incoming_inv, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(newrec_.company, 'CURR_RATE_DATE_INCOMING_INV') = Fnd_Boolean_API.DB_FALSE OR 
      newrec_.use_tax_rates = 'FALSE' ) THEN
      newrec_.tax_buy_curr_rate_base := Base_Date_API.DB_VOUCHER_DATE;
   END IF;   
   -- gelr:curr_rate_date_incoming_inv, end
END Check_Common___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT currency_type_basic_data_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.use_tax_rates IS NULL) THEN
      newrec_.use_tax_rates := 'FALSE';
   END IF;
   -- gelr:out_inv_curr_rate_voucher_date, begin
   newrec_.tax_sell_curr_rate_base        := NVL(newrec_.tax_sell_curr_rate_base, Base_Date_API.DB_INVOICE_DATE); 
   -- gelr:out_inv_curr_rate_voucher_date, end
   -- gelr:curr_rate_date_incoming_inv, begin
   newrec_.tax_buy_curr_rate_base         := NVL(newrec_.tax_buy_curr_rate_base, Base_Date_API.DB_VOUCHER_DATE); 
   -- gelr:curr_rate_date_incoming_inv, end
   super(newrec_, indrec_, attr_);   
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

