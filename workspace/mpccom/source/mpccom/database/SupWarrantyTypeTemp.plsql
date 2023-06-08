-----------------------------------------------------------------------------
--
--  Logical unit: SupWarrantyTypeTemp
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120525  JeLise  Made description private.
--  120507  JeLise  Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120507          in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507          was added. Get_Warranty_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040225  SaNalk  Removed SUBSTRB.
--  -----------------------Version 13.3.0-------------------------- ---------
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
   Client_SYS.Add_To_Attr('MATERIAL_COST_TYPE_DB', 'MATERIAL', attr_);
   Client_SYS.Add_To_Attr('EXPENSES_COST_TYPE_DB', 'EXPENSES', attr_);
   Client_SYS.Add_To_Attr('FIXED_PRICE_COST_TYPE_DB', 'FIXED PRICE', attr_);
   Client_SYS.Add_To_Attr('PERSONNEL_COST_TYPE_DB', 'PERSONNEL', attr_);
   Client_SYS.Add_To_Attr('EXTERNAL_COST_TYPE_DB', 'EXTERNAL', attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_ORDER_CONNECTION_DB', 'NOT CALCULATE', attr_);
   Client_SYS.Add_To_Attr('CONVERT_TO_CUST_ORD_DB', 'NOT CONVERT', attr_);
   Client_SYS.Add_To_Attr('WARRANTY_CONDITION_RULE', Warranty_Condition_Rule_API.Decode('INCLUSIVE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sup_warranty_type_temp_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   IF newrec_.warranty_condition_rule IS NULL THEN
      newrec_.warranty_condition_rule := 'INCLUSIVE';
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-- Get_Warranty_Description
--   Fetches the WarrantyDescription attribute for a record.
@UncheckedAccess
FUNCTION Get_Warranty_Description (
   template_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ sup_warranty_type_temp_tab.warranty_description%TYPE;
BEGIN
   IF (template_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      template_id_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT warranty_description
      INTO  temp_
      FROM  sup_warranty_type_temp_tab
      WHERE template_id = template_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(template_id_, 'Get_Warranty_Description');
END Get_Warranty_Description;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


