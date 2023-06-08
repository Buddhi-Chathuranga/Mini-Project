-----------------------------------------------------------------------------
--
--  Logical unit: InvPartTypeCostSource
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  051216  JoEd     Changed Get_Cost_Source_Id. Now uses DB value.
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
   type_code_ IN VARCHAR2,
   valid_from_date_ IN DATE ) RETURN VARCHAR2
IS
   temp_ inv_part_type_cost_source_tab.cost_source_id%TYPE;
   type_code_db_ inv_part_type_cost_source_tab.type_code%TYPE := Inventory_Part_Type_API.Encode(type_code_);
BEGIN
   IF (company_ IS NULL OR type_code_ IS NULL OR valid_from_date_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT cost_source_id
      INTO  temp_
      FROM  inv_part_type_cost_source_tab
      WHERE company = company_
      AND   type_code = type_code_db_
      AND   valid_from_date <= valid_from_date_
      ORDER BY valid_from_date DESC;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(company_, type_code_, valid_from_date_, 'Get_Cost_Source_Id');
END Get_Cost_Source_Id;

