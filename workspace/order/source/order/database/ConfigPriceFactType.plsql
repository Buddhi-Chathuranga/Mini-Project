-----------------------------------------------------------------------------
--
--  Logical unit: ConfigPriceFactType
--  Component:    ORDER
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


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@IgnoreUnitTest NoOutParams
PROCEDURE Exist_Db_Factors (
   db_value_ IN VARCHAR2 )
IS
   fac_db_value_list_   VARCHAR2(32) := 'CHARVALUE^CHARQTY^';
BEGIN
   Domain_SYS.Exist_(lu_name_, fac_db_value_list_, db_value_);
END Exist_Db_Factors;

-------------------- LU  NEW METHODS -------------------------------------
