-----------------------------------------------------------------------------
--
--  Logical unit: CapacityGrpHandlingUnit
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120911  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT capacity_grp_handling_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   
   Check_Quantity(newrec_.max_quantity_capacity, newrec_.unit_code);

END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     capacity_grp_handling_unit_tab%ROWTYPE,
   newrec_ IN OUT capacity_grp_handling_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.max_quantity_capacity != oldrec_.max_quantity_capacity) THEN
      Check_Quantity(newrec_.max_quantity_capacity, newrec_.unit_code);
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Check_Quantity (
   quantity_  IN NUMBER,
   unit_code_ IN VARCHAR2 )
IS
   unit_type_ VARCHAR2(200);
BEGIN

   unit_type_ := Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(unit_code_));
   
   IF (unit_type_ = 'DISCRETE') AND (MOD(quantity_, 1) != 0) THEN 
      Error_SYS.Record_General(lu_name_, 'DISCRETEQUANTITY: It is not allowed to enter a quantity with decimals when the unit of measure is defined as being discrete.');
   END IF;
   
   IF (quantity_ <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'QUANTITY: Quantity must be greater than zero.');
   END IF;
END Check_Quantity;



