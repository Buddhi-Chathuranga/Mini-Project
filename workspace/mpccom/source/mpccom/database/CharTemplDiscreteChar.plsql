-----------------------------------------------------------------------------
--
--  Logical unit: CharTemplDiscreteChar
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  060112  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060112           and added UNDEFINE according to the new template.
--  --------------------------------- 13.3.0 --------------------------------
--  010103  PERK     Changed prompt on view
--  001128  PERK     Changed order of eng_attribute and characteristic_cod
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   temp_ VARCHAR2(2000);
BEGIN
   super(attr_);
   Characteristic_Templ_Char_API.New__(temp_, temp_, temp_, attr_, 'PREPARE');
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


