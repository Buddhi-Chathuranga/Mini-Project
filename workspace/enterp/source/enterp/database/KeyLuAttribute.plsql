-----------------------------------------------------------------------------
--
--  Logical unit: KeyLuAttribute
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

@UncheckedAccess
FUNCTION Get_Attribute_Text__ (
   key_name_      IN VARCHAR2,
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ key_lu_attribute_tab.attribute_text%TYPE;
   CURSOR get_attr IS
      SELECT attribute_text
      FROM   key_lu_attribute_tab
      WHERE  key_name  = key_name_
      AND    key_value = key_value_
      AND    module    = module_
      AND    lu        = lu_
      AND    attribute_key = attribute_key_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Attribute_Text__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

