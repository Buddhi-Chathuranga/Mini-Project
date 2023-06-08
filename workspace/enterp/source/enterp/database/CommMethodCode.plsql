-----------------------------------------------------------------------------
--
--  Logical unit: CommMethodCode
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120105  Janblk  EDEL-214, Added new value Fax Server to Enumeration 
--  120910  Chhulk  Bug 105107, Modified Encode().
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
@UncheckedAccess
FUNCTION Encode (
   client_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (INSTR(Get_Db_Values___, client_value_ ||'^') != 0) THEN
      RETURN client_value_;
   ELSE
      RETURN super(client_value_);
   END IF;
END Encode;

