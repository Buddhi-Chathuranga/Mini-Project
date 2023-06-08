-----------------------------------------------------------------------------
--
--  Logical unit: TypeCustomerAddress
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981016  Camk    Created.
--  981126  Cami    Company removed from view
--  100402  Kanslk  EANE-591, modified view 'TYPE_CUSTOMER_ADDRESS
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
   identity_   IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
BEGIN
  Type_Generic_Address_API.Exist(Party_Type_API.Decode('CUSTOMER'), identity_, address_id_);
END Exist;


