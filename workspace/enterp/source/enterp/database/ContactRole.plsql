-----------------------------------------------------------------------------
--
--  Logical unit: ContactRole
--  Component:    ENTERP
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

--This method to be used in Aurena
@UncheckedAccess
FUNCTION Get_Role_Db (
   role_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   role_db_ VARCHAR2(100);
BEGIN
	SELECT CONCAT(CONCAT('^', role_id_), '^') INTO role_db_ FROM dual;
	RETURN role_db_;
END Get_Role_Db;

