-----------------------------------------------------------------------------
--
--  Logical unit: PricingContriMarginCtrl
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130708  MaIklk   TIBE-1011, Removed global constant inst_CostSet_ and used conditional compilation instead.
--  120124  ChJalk   Modified the base view to add ENUMERATE for the column use_inventory_value.
--  110713  ChJalk   Added user_allowed_site filter to the view PRICING_CONTRI_MARGIN_CTRL.
--  110419  RiLase   Added validation that either a cost set or use inventory value is set when doing insert and update.
--  110322  RiLase   Added Validate_Cost_Set___ to dynamically validate cost set in Unpack_Check... methods.
--  110302  RiLase   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Validate_Cost_Set___
--   Checks if COSTING is installed and in the case, validates the cost_set.
PROCEDURE Validate_Cost_Set___ (
  contract_ IN VARCHAR2,
  cost_set_ IN NUMBER )
IS  
BEGIN
   -- Check whether CostSet LU is installed.
   $IF (Component_Cost_SYS.INSTALLED) $THEN
      Cost_Set_API.Exist( contract_, cost_set_ ); 
   $ELSE
      NULL;
   $END
END Validate_Cost_Set___;


PROCEDURE Validate_Insert_Update___ (
   contract_            IN VARCHAR2,
	use_inventory_value_ IN VARCHAR2,
   cost_set_            IN VARCHAR2)
IS
BEGIN

    IF NVL(use_inventory_value_, 'FALSE') = 'FALSE' AND cost_set_ IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'SETUSEINVVALUEORCOSTSET: Use inventory value or cost set must be set.');
   END IF;
   --Validation done in Check_Common___
   --IF (cost_set_ IS NOT NULL) THEN
   --   Validate_Cost_Set___(contract_, cost_set_);
   --END IF;

END Validate_Insert_Update___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('USE_INVENTORY_VALUE_DB', Fnd_Boolean_API.db_true, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT pricing_contri_margin_ctrl_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   Validate_Insert_Update___(newrec_.contract, newrec_.use_inventory_value, newrec_.cost_set);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     pricing_contri_margin_ctrl_tab%ROWTYPE,
   newrec_ IN OUT pricing_contri_margin_ctrl_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   Validate_Insert_Update___(newrec_.contract, newrec_.use_inventory_value, newrec_.cost_set);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Valid_Cost_Set (
   contract_   VARCHAR2,
   valid_date_ DATE) RETURN VARCHAR2
IS
   temp_ PRICING_CONTRI_MARGIN_CTRL_TAB.cost_set%TYPE;
   CURSOR get_attr IS
      SELECT cost_set
      FROM PRICING_CONTRI_MARGIN_CTRL_TAB
      WHERE contract = contract_
      AND   valid_from IN (
                          SELECT max(valid_from) valid_from
                          FROM PRICING_CONTRI_MARGIN_CTRL_TAB pcmc
                          WHERE pcmc.contract = contract_
                          AND   pcmc.valid_from <= valid_date_
                          );
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Valid_Cost_Set;


@UncheckedAccess
FUNCTION Get_Valid_Use_Inv_Value_Db (
   contract_   VARCHAR2,
   valid_date_ DATE) RETURN VARCHAR2
IS
   temp_ PRICING_CONTRI_MARGIN_CTRL_TAB.use_inventory_value%TYPE;
   CURSOR get_attr IS
      SELECT use_inventory_value
      FROM PRICING_CONTRI_MARGIN_CTRL_TAB
      WHERE contract = contract_
      AND   valid_from IN (
                          SELECT max(valid_from) valid_from
                          FROM PRICING_CONTRI_MARGIN_CTRL_TAB pcmc
                          WHERE pcmc.contract = contract_
                          AND   pcmc.valid_from <= valid_date_
                          );
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Valid_Use_Inv_Value_Db;



