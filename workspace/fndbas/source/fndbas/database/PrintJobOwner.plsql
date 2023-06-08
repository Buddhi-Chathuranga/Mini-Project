-----------------------------------------------------------------------------
--
--  Logical unit: PrintJobOwner
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
-------------------- PACKAGES FOR METHOD
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Enumerate2 (
   client_values_ OUT VARCHAR2 )
IS
BEGIN
   -- The same as the standard Enumerate method with the exception that the 'UNDEFINED'
   -- option is not included.
   client_values_ := Domain_SYS.Enumerate_(Decode('PRINTSRV')||'^'||Decode('AGENT'));
END Enumerate2;


