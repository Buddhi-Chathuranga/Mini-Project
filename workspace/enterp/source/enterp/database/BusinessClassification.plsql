-----------------------------------------------------------------------------
--
--  Logical unit: BusinessClassification
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200909  misibr  GEFALL20-3013, created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   country_code_            IN VARCHAR2,
   business_classification_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'BUSINESSCLASSIFNOTEXIST: The Classification of Business :P1 is not defined for :P2.', business_classification_, Iso_Country_API.Decode(country_code_));   
   super(country_code_, business_classification_);
END Raise_Record_Not_Exist___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
