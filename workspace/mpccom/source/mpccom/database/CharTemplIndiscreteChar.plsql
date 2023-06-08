-----------------------------------------------------------------------------
--
--  Logical unit: CharTemplIndiscreteChar
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  060112  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060112           and added UNDEFINE according to the new template.
--  --------------------------------- 13.3.0 --------------------------------
--  030911  MiKulk   Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  010103  PERK     Changed prompt on view
--  001128  PERK     Changed order of eng_attribute and characteristic_cod
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
FUNCTION Get_Object_By_Keys___ (
   characteristic_code_ IN VARCHAR2,
   eng_attribute_ IN VARCHAR2 ) RETURN CHARACTERISTIC_TEMPL_CHAR_TAB%ROWTYPE
IS
BEGIN
   RETURN super(eng_attribute_, characteristic_code_);
END Get_Object_By_Keys___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


