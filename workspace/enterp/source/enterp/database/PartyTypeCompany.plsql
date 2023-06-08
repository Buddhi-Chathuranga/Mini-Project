-----------------------------------------------------------------------------
--
--  Logical unit: PartyTypeCompany
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981026  Camk    Created.
--  981203  Camk    Get_Default_Address(), Get_Association_No() and Get_Country
--                  added
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Exist (
   identity_  IN VARCHAR2 )
IS
BEGIN
   Party_Type_Generic_API.Exist(Party_Type_API.Decode('COMPANY'), identity_);
END Exist;


@UncheckedAccess
FUNCTION Get_Name (
   identity_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Name(Party_Type_API.Decode('COMPANY'), identity_);
END Get_Name;


@UncheckedAccess
FUNCTION Get_Country (
   identity_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Country(Party_Type_API.Decode('COMPANY'), identity_);
END Get_Country;


