-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseHuCapacity
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180206  LEPESE  STRSC-16027, Added call to method Warehouse_Bin_Hu_Capacity_API.Validate_Bin_Hu_Type_Capacity.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     warehouse_hu_capacity_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY warehouse_hu_capacity_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Warehouse_Bin_Hu_Capacity_API.Validate_Bin_Hu_Type_Capacity(newrec_.bin_hu_type_capacity); 
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

