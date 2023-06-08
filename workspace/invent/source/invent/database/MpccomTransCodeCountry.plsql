-----------------------------------------------------------------------------
--
--  Logical unit: MpccomTransCodeCountry
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200914  SBalLK  SC2020R1-9818, Added Check_Country_Code_Ref___() method for avoid fresh installation errors when country code not activated in appsrv.
--  200831  SBalLK  GESPRING20-537, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Check_Country_Code_Ref___ (
   newrec_ IN OUT NOCOPY mpccom_trans_code_country_tab%ROWTYPE )
IS
   
BEGIN
   -- Cannot use default Exists method since appsrv set the use_appl parameter 'FALSE' during the data insertion.
   -- Hence Exists method fails to return counties where use_appl parameter false due to implementation by overtaking the core code.
   Iso_Country_API.Exist_Db_All(newrec_.country_code);
END Check_Country_Code_Ref___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
PROCEDURE Insert_Or_Update__(
   transaction_code_       IN VARCHAR2,
   country_code_           IN VARCHAR2,
   included_db_            IN VARCHAR2,
   intrastat_direction_db_ IN VARCHAR2,
   notc_                   IN VARCHAR2,
   intrastat_amount_sign_  IN NUMBER)
IS
   newrec_ MPCCOM_TRANS_CODE_COUNTRY_TAB%ROWTYPE;
BEGIN
   IF(Check_Exist___(transaction_code_, country_code_)) THEN
      newrec_ := Lock_By_Keys___(transaction_code_, country_code_);
      newrec_.included              := included_db_;
      newrec_.intrastat_direction   := intrastat_direction_db_;
      newrec_.notc                  := notc_;
      newrec_.intrastat_amount_sign := intrastat_amount_sign_;
      Modify___(newrec_);
   ELSE
      newrec_.transaction_code      := transaction_code_;
      newrec_.country_code          := country_code_;
      newrec_.included              := included_db_;
      newrec_.intrastat_direction   := intrastat_direction_db_;
      newrec_.notc                  := notc_;
      newrec_.intrastat_amount_sign := intrastat_amount_sign_;
      New___(newrec_);
   END IF;
END Insert_Or_Update__;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

