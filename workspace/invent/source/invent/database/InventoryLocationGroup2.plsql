-----------------------------------------------------------------------------
--
--  Logical unit: InventoryLocationGroup2
--  Component:    INVENT
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
-- Exist
--    This method is especially designed to be used from ACCRUL that needs
--    this method since location group is used for control type C86.
@UncheckedAccess
PROCEDURE Exist (
   location_group_ IN VARCHAR2 )
IS
BEGIN
   -- EBALL-37, Added 'PART EXCHANGE' to the location group list.
   IF location_group_ IN ('CONSIGNMENT','INT ORDER TRANSIT','DELIVERY CONFIRM', 'PART EXCHANGE') THEN
      NULL;
   ELSE
      Inventory_Location_Group_API.Exist(location_group_);
   END IF;
END Exist;

-- Get_Control_Type_Value_Desc
--    Procedure to get description for accounting rules.
PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;

-- Get_Inventory_Location_Type_Db
--    Returns the DB value of Invetory Location Type
@UncheckedAccess
FUNCTION Get_Inventory_Location_Type_Db (
   location_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   -- EBALL-37, Added 'PART EXCHANGE' to the location group list.
   IF (location_group_ IN ('CONSIGNMENT','INT ORDER TRANSIT','DELIVERY CONFIRM', 'PART EXCHANGE')) THEN
      RETURN location_group_;
   ELSE
      RETURN Inventory_Location_Group_API.Get_Inventory_Location_Type_Db(location_group_);
   END IF;
END Get_Inventory_Location_Type_Db;

@UncheckedAccess
FUNCTION Get_Description (
   location_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_ INVENTORY_LOCATION_GROUP_TAB.description%TYPE;
BEGIN
   IF (location_group_ = 'CONSIGNMENT') THEN
      description_ := Language_SYS.Translate_Constant('InventoryLocationGroup', 'CONSDESC: Consignment stock');
   ELSIF location_group_ = 'INT ORDER TRANSIT' THEN
      description_ := Language_SYS.Translate_Constant('InventoryLocationGroup', 'INTORDTDESC: Internal Order Transit');
   ELSIF location_group_ = 'DELIVERY CONFIRM' THEN
      description_ := Language_SYS.Translate_Constant('InventoryLocationGroup', 'DELCONDESC: Delivered Not Confirmed');
   -- EBALL-37, start
   ELSIF location_group_ = 'PART EXCHANGE' THEN
      description_ := Language_SYS.Translate_Constant('InventoryLocationGroup', 'PARTEXDESC: Part Exchange');
   -- EBALL-37, end
   ELSE
      description_ := Inventory_Location_Group_API.Get_Description(location_group_);      
   END IF;
   RETURN (description_);
END Get_Description;

