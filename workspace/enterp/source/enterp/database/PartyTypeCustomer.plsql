-----------------------------------------------------------------------------
--
--  Logical unit: PartyTypeCustomer
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981026  Camk    Created.
--  981120  Camk    Public method Get_Party() added
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Check_Exist(Party_Type_API.Decode('CUSTOMER'), identity_);
END Check_Exist;


@UncheckedAccess
PROCEDURE Exist (
   identity_  IN VARCHAR2 )
IS
BEGIN
   Party_Type_Generic_API.Exist(Party_Type_API.Decode('CUSTOMER'), identity_);
END Exist;


@UncheckedAccess
FUNCTION Get_Name (
   identity_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Name(Party_Type_API.Decode('CUSTOMER'), identity_);
END Get_Name;


@UncheckedAccess
FUNCTION Get_Party (
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Party(Party_Type_API.Decode('CUSTOMER'), identity_);
END Get_Party;



