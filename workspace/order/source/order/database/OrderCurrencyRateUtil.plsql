-----------------------------------------------------------------------------
--
--  Logical unit: OrderCurrencyRateUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140703  ChBnlk   Bug 117704, Modified Get_Fin_Curr_Rate() to return 0 if curr_rate_ is 0.    
--  120306  Cpeilk   Bug 101586, Modified Get_Fin_Curr_Rate to Round the currency rate to the number of decimals specified for the currency code.
--  081211  SuJalk   Bug 79156, Removed the IF condition in Get_Fin_Curr_Rate Method.
--  080822  ChJalk   Bug 74597, Modified the method Get_Fin_Curr_Rate to change calculation of Currency Rate for non_inverted
--  080822           Quotation Currency Codes. 
--  080806  SuJalk   Created. Added method Get_Fin_Curr_Rate
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Fin_Curr_Rate (
   curr_rate_     IN NUMBER,
   company_       IN VARCHAR2,
   currency_code_ IN VARCHAR2 ) RETURN NUMBER
IS
   inverted_       VARCHAR2(5);
   conv_factor_    NUMBER;
   decimals_rate_  NUMBER;
BEGIN
   conv_factor_ := Currency_Code_API.Get_Conversion_Factor (company_,currency_code_);

   inverted_ := Currency_Code_API.Get_Inverted(company_,Currency_Code_API.Get_Currency_Code(company_));

   decimals_rate_ := Currency_Code_API.Get_No_Of_Decimals_In_Rate(company_, currency_code_);

   IF (inverted_ = 'TRUE') THEN
      IF (curr_rate_ = 0) THEN
         RETURN 0;
      ELSE 
         RETURN ROUND(conv_factor_/curr_rate_, decimals_rate_);
      END IF;
   ELSE
      RETURN ROUND(curr_rate_ * conv_factor_, decimals_rate_);
   END IF;
END Get_Fin_Curr_Rate;




