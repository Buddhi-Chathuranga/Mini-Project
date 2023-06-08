-----------------------------------------------------------------------------
--
--  Logical unit: InvProdCodeCostSource
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  051104  JoEd     Changed Get_Cost_Source_Id. Removed Get_Current_Cost_Source_Id.
--  051011  JoEd     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Cost_Source_Id
--   Fetches the CostSourceId attribute for a record.
@UncheckedAccess
FUNCTION Get_Cost_Source_Id (
   company_ IN VARCHAR2,
   part_product_code_ IN VARCHAR2,
   valid_from_date_ IN DATE ) RETURN VARCHAR2
IS
   temp_ inv_prod_code_cost_source_tab.cost_source_id%TYPE;
BEGIN
   IF (company_ IS NULL OR part_product_code_ IS NULL OR valid_from_date_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT cost_source_id
      INTO  temp_
      FROM  inv_prod_code_cost_source_tab
      WHERE company = company_
      AND   part_product_code = part_product_code_
      AND   valid_from_date <= valid_from_date_
      ORDER BY valid_from_date DESC;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(company_, part_product_code_, valid_from_date_, 'Get_Cost_Source_Id');
END Get_Cost_Source_Id;

