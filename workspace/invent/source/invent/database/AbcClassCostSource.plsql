-----------------------------------------------------------------------------
--
--  Logical unit: AbcClassCostSource
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  051104  JoEd     Changed Get_Cost_Source_Id. Removed Get_Current_Cost_Source_Id.
--  051012  JOHESE   Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Cost_Source_Id (
   company_ IN VARCHAR2,
   abc_class_ IN VARCHAR2,
   valid_from_date_ IN DATE ) RETURN VARCHAR2
IS
   temp_ ABC_CLASS_COST_SOURCE_TAB.cost_source_id%TYPE;
   CURSOR get_attr IS
      SELECT cost_source_id
      FROM   ABC_CLASS_COST_SOURCE_TAB
      WHERE  company = company_
      AND   abc_class = abc_class_
      AND   valid_from_date <= valid_from_date_
      ORDER BY valid_from_date DESC;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Cost_Source_Id;



