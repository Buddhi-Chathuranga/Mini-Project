-----------------------------------------------------------------------------
--
--  Logical unit: TaxOfficeInfo
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  030128  Machlk  Created.
--  030320  MGUTSE  Bug 95408 corrected. Added TAX_OFFICE_INFO_LOV.
--  131024  Isuklk  PBFI-1221 Refactoring in TaxOfficeInfo.entity
--  210325  kugnlk  FI21R2-451, Get rid of string manipulations in db - Modified New method.
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
   Client_SYS.Add_To_Attr('CREATION_DATE', TRUNC(SYSDATE), attr_);
END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   tax_office_id_    IN VARCHAR2,
   name_             IN VARCHAR2,
   country_          IN VARCHAR2 DEFAULT NULL,
   default_language_ IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       tax_office_info_tab%ROWTYPE;
BEGIN
   newrec_.tax_office_id    := tax_office_id_;
   newrec_.name             := name_;
   newrec_.creation_date    := trunc(SYSDATE);
   newrec_.country          := Iso_Country_API.Encode(country_);
   newrec_.default_language := Iso_Language_API.Encode(default_language_);
   New___(newrec_);
END New;

