-----------------------------------------------------------------------------
--
--  Logical unit: SourceCompCurrRateType
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

@Override
PROCEDURE Raise_Record_Exist___ (
   rec_ IN source_comp_curr_rate_type_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Record_General(lu_name_,'ALREADYEXISTCOMPANY: The Source Company and Currency Rate Type already exists.');
   super(rec_);
END Raise_Record_Exist___;


@IgnoreUnitTest TrivialFunction
FUNCTION Active_Allowed___ (
   rec_  IN     source_comp_curr_rate_type_tab%ROWTYPE ) RETURN BOOLEAN
IS
   target_ref_currency_code_ currency_code_Tab.currency_code%TYPE;
   
   CURSOR target_companies IS
   SELECT target_company, target_curr_rate_type
   FROM target_comp_curr_rate_type_tab
   WHERE source_company        = rec_.source_company
   AND   source_curr_rate_type = rec_.source_curr_rate_type;  
   
BEGIN
   IF Target_Comp_Curr_Rate_Type_API.Target_Company_Exists(rec_.source_company, rec_.source_curr_rate_type) = 'FALSE' THEN
      Error_SYS.Record_General(lu_name_, 'NOTTARGETCOMPANY: Target Company Currency Rate Types not defined.');
   END IF;
   FOR target_ IN target_companies LOOP
      target_ref_currency_code_ := Currency_Type_API.Get_Ref_Currency_Code( target_.target_company, target_.target_curr_rate_type);
      IF (NOT Target_Comp_Curr_Rate_Type_API.Is_Target_Ref_Curr_In_Source(rec_.source_company, rec_.source_curr_rate_type, target_ref_currency_code_ )) THEN
         Client_SYS.Add_Warning(lu_name_, 'NOTRIANGULATIONRATEINSOURCE: To support triangulation of rates, Currency Rate Type :P1 in source company :P2 should have a rate defined for currency code :P3.' , rec_.source_curr_rate_type, rec_.source_company, target_ref_currency_code_);
      END IF;
   END LOOP;
   RETURN TRUE;
END Active_Allowed___;


@IgnoreUnitTest TrivialFunction
PROCEDURE Check_Source_Curr_Rate_Type_Ref___(
   newrec_ IN OUT NOCOPY source_comp_curr_rate_type_tab%ROWTYPE)
IS
BEGIN
   Currency_Type_API.Exist_Currency_Type(newrec_.source_company, newrec_.source_curr_rate_type);
END Check_Source_Curr_Rate_Type_Ref___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@IgnoreUnitTest DMLOperation
PROCEDURE Update_Last_Updated(
   source_company_         IN VARCHAR2,
   source_curr_rate_type_  IN VARCHAR2)
IS
BEGIN
   UPDATE source_comp_curr_rate_type_tab
   SET last_updated = SYSDATE
   WHERE source_company      = source_company_
   AND source_curr_rate_type = source_curr_rate_type_;
END Update_Last_Updated;