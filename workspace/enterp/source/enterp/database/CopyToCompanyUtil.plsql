-----------------------------------------------------------------------------
--
--  Logical unit: CopyToCompanyUtil
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180823  Nudilk  Bug XXX, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Next_Record_Sep_Val (
   value_ IN OUT VARCHAR2,
   ptr_   IN OUT NUMBER,  
   attr_  IN     VARCHAR2 ) RETURN BOOLEAN
IS
   from_             NUMBER;
   to_               NUMBER;
   field_separator_  VARCHAR2(1) := Client_SYS.field_separator_;
BEGIN
   from_ := NVL(ptr_, 1);
   to_   := INSTR(attr_, field_separator_, from_);
   IF (to_ > 0) THEN
      value_ := SUBSTR(attr_, from_, to_-from_);
      ptr_   := to_+1;
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Get_Next_Record_Sep_Val;
