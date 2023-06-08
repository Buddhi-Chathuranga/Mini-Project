-----------------------------------------------------------------------------
--
--  Logical unit: TargetCompCurrRateType
--  Component:    ACCRUL
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@IgnoreUnitTest TrivialFunction
PROCEDURE Check_Target_Curr_Rate_Type_Ref___(
   newrec_ IN OUT NOCOPY target_comp_curr_rate_type_tab%ROWTYPE)
IS
BEGIN
   Currency_Type_API.Exist_Currency_Type(newrec_.target_company, newrec_.target_curr_rate_type);
END Check_Target_Curr_Rate_Type_Ref___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT target_comp_curr_rate_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   target_ref_currency_code_  currency_code_tab.currency_code%TYPE;
BEGIN
   IF ((newrec_.source_company = newrec_.target_company) AND ((newrec_.source_curr_rate_type = newrec_.target_curr_rate_type))) THEN 
      Error_SYS.Appl_General(lu_name_, 'SAMECOMPANY: Cannot use the combination of source company and source currency rate type in the target company information.');
   END IF;
   target_ref_currency_code_ := Currency_Type_API.Get_Ref_Currency_Code( newrec_.target_company, newrec_.target_curr_rate_type);
   IF (NOT Is_Target_Ref_Curr_In_Source(newrec_.source_company, newrec_.source_curr_rate_type, target_ref_currency_code_ )) THEN
      Client_SYS.Add_Warning(lu_name_, 'NOTRIANGULATIONRATEINSOURCE: To support triangulation of rates, Currency Rate Type :P1 in source company :P2 should have a rate defined for currency code :P3.' , newrec_.source_curr_rate_type, newrec_.source_company, target_ref_currency_code_);
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@IgnoreUnitTest TrivialFunction
FUNCTION Target_Company_Exists(
   source_company_         IN VARCHAR2,
   source_curr_rate_type_  IN VARCHAR2) RETURN VARCHAR2
IS
   CURSOR get_row IS
   SELECT 1
   FROM target_comp_curr_rate_type_tab
   WHERE source_company      = source_company_
   AND source_curr_rate_type = source_curr_rate_type_;
   ndummy_  NUMBER;
BEGIN
   OPEN get_row;
   FETCH get_row INTO ndummy_;
   IF get_row%FOUND THEN
      CLOSE get_row;
      RETURN 'TRUE';
   ELSE
      CLOSE get_row;
      RETURN 'FALSE';
   END IF;
END Target_Company_Exists;

@UncheckedAccess
FUNCTION Is_Target_Ref_Curr_In_Source(
   source_company_            IN VARCHAR2,
   source_curr_rate_type_     IN VARCHAR2,
   target_ref_currency_code_  IN VARCHAR2) RETURN BOOLEAN
IS
   ndummy_                    NUMBER;
   CURSOR get_currency_rate IS
   SELECT 1
   FROM currency_rate_tab
   WHERE company       = source_company_
   AND   currency_type = source_curr_rate_type_
   AND   currency_code = target_ref_currency_code_;
BEGIN
   OPEN get_currency_rate;
   FETCH get_currency_rate INTO ndummy_;
   IF get_currency_rate%FOUND THEN
      CLOSE get_currency_rate;
      RETURN TRUE;
   ELSE
      CLOSE get_currency_rate;
      RETURN FALSE;
   END IF;
END Is_Target_Ref_Curr_In_Source;