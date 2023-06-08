-----------------------------------------------------------------------------
--
--  Logical unit: CustWarrantyTypeTemp
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  060111  SeNslk  Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060111          and added UNDEFINE according to the new template.
--  040223  SaNalk  Removed SUBSTRB.
--  ------------------------------- 13.3.0 ----------------------------------
--  001124  PaLj  Changed Unpack_Check_Insert___
--  001113  PaLj  Added WARRANTY_CONDITION_RULE to prepare_insert___
--  001010  PaLj  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('MATERIAL_COST_TYPE_DB', 'NOT MATERIAL', attr_);
   Client_SYS.Add_To_Attr('EXPENSES_COST_TYPE_DB', 'NOT EXPENSES', attr_);
   Client_SYS.Add_To_Attr('FIXED_PRICE_COST_TYPE_DB', 'NOT FIXED PRICE', attr_);
   Client_SYS.Add_To_Attr('PERSONNEL_COST_TYPE_DB', 'NOT PERSONNEL', attr_);
   Client_SYS.Add_To_Attr('EXTERNAL_COST_TYPE_DB', 'NOT EXTERNAL', attr_);
   Client_SYS.Add_To_Attr('WARRANTY_CONDITION_RULE', Warranty_Condition_Rule_API.Decode('INCLUSIVE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_warranty_type_temp_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF newrec_.warranty_condition_rule IS NULL THEN
      newrec_.warranty_condition_rule := 'INCLUSIVE';
   END IF;
   
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


