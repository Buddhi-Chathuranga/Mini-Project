-----------------------------------------------------------------------------
--
--  Logical unit: Branch
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171106  reanpl  CRUISE-521, Added validation for Company Address
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     branch_tab%ROWTYPE,
   newrec_ IN OUT branch_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.company_address_id IS NOT NULL) AND (indrec_.company_address_id) AND (Validate_SYS.Is_Changed(oldrec_.company_address_id, newrec_.company_address_id)) THEN      
      IF (Company_Address_Type_API.Check_Exist(newrec_.company, newrec_.company_address_id, Address_Type_Code_API.Decode(Address_Type_Code_API.DB_DOCUMENT)) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'COMPDOCTYPENOTEXIST: Address ID :P1 in company :P2 is not a document address.', newrec_.company_address_id, newrec_.company);
      END IF;
   END IF;
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

