-----------------------------------------------------------------------------
--
--  Logical unit: OrderFooterConnection
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120820  ovjose   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Make_Company (
   attr_       IN VARCHAR2 )
IS 
BEGIN
   -- Call the general footer connection make company method
   Footer_Connection_API.Make_Company_Gen( 'ORDER', lu_name_, 'ORDER_FOOTER_CONNECTION_API', attr_ );
END Make_Company;   



