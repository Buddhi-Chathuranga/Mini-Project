-----------------------------------------------------------------------------
--
--  Logical unit: ExternalTaxCodesMapping
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
PROCEDURE Check_Common___ (
   oldrec_ IN     external_tax_codes_mapping_tab%ROWTYPE,
   newrec_ IN OUT external_tax_codes_mapping_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Validate_Tax_Code___(newrec_, indrec_);  
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

PROCEDURE Validate_Tax_Code___ (
   newrec_ IN OUT external_tax_codes_mapping_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec )
IS
   tax_types_event_  VARCHAR2(20):= 'RESTRICTED';
   taxable_event_    VARCHAR2(20):= 'ALL';
   tax_rec_          Statutory_Fee_API.Public_Rec;
BEGIN 
   IF (newrec_.tax_code IS NOT NULL AND indrec_.tax_code) THEN 
      Tax_Handling_Util_API.Validate_Tax_On_Basic_Data(newrec_.company, tax_types_event_, newrec_.tax_code, taxable_event_, SYSDATE);   
      tax_rec_ := Statutory_Fee_API.Fetch_Validate_Tax_Code_Rec(newrec_.company, newrec_.tax_code, sysdate, Fnd_Boolean_API.DB_FALSE, Fnd_Boolean_API.DB_TRUE, 'FETCH_AND_VALIDATE');
      IF (tax_rec_.fee_type NOT IN (Fee_Type_API.DB_TAX) OR tax_rec_.fee_rate != 0) THEN
         Error_SYS.Record_General(lu_name_, 'ONLYALLOWEDZEROTAX: You are only allowed to use Tax Codes of type :P1 with 0% percentage.', Fee_Type_API.Decode(Fee_Type_API.DB_TAX));
      END IF;
   END IF;
END Validate_Tax_Code___;  

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

