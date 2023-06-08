-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentManufacturer
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  961001  JOSC    Recreated from Rose model using Developer's Workbench.
--  961017  ADBR    Increased outpar_ to 30 in Get_Description.
--  961005  TOWI    Recreated from Rose model using Developer's Workbench 1.2.2
--  970123  CAJO    Changed dynamic function Get_Description to Get_Name.
--  970401  TOWI    Adjusted to new templates in Foundation1 1.2.2c.
--  971017  ERJA    Changed MANUFACTURER_OF_PARTS_API to PARTY_TYPE_MANUFACTURER_API.
--  981124  MIBO    Changed PARTY_TYPE_MANUFACTURER_API to MANUFACTURER_Info_API.
--  991221  RECASE  Changed template due to performance improvement
--  131121  NEKOLK  Refactored and splitted.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   manufacturer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Manufacturer_Info_API.Get_name(manufacturer_no_);
END Get_Description;



@UncheckedAccess
PROCEDURE Exist (
   manufacturer_no_ IN VARCHAR2 )
IS
BEGIN
   Manufacturer_Info_API.Exist(manufacturer_no_);
END Exist;



