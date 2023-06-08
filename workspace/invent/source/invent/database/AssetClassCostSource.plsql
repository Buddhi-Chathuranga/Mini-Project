-----------------------------------------------------------------------------
--
--  Logical unit: AssetClassCostSource
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  091022  DAYJLK   Replaced LU name Asset_ClassCostSource with AssetClassCostSource.
--  ----------------- PROJECT EAGLE -----------------------------------------
--  051104  JoEd     Changed Get_Cost_Source_Id. Removed Get_Current_Cost_Source_Id.
--  051010  JoEd     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Cost_Source_Id (
   company_ IN VARCHAR2,
   asset_class_ IN VARCHAR2,
   valid_from_date_ IN DATE ) RETURN VARCHAR2
IS
   temp_ ASSET_CLASS_COST_SOURCE_TAB.cost_source_id%TYPE;
   CURSOR get_attr IS
      SELECT cost_source_id
      FROM   ASSET_CLASS_COST_SOURCE_TAB
      WHERE  company = company_
      AND   asset_class = asset_class_
      AND   valid_from_date <= valid_from_date_
      ORDER BY valid_from_date DESC;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Cost_Source_Id;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------





