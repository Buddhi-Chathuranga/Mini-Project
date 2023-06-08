-----------------------------------------------------------------------------
--
--  Logical unit: SourceRulePerCustAddr
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110607  MaMalk  Added user allowed site filteration on the base view.
--  100513  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060516  MiErlk  Enlarge Identity - Changed view comment
--  060417  RoJalk  Enlarge Identity - Changed view comments.
--  -------------------- 13.4.0 ----------------------------------------------
--  060112  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  --------------------------------13.3.0------------------------------------
--  030902  GaSolk Performed CR Merge 2.
--  030828  NaWa   Performed Code Review.
--  030514  DaZa   Added method Exist_Any_Rules_For_Sales_Part.
--  030512  DaZa   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Exist_Any_Rules_For_Sales_Part
--   Used in a validation on Sales Part when changing sourcing option.
@UncheckedAccess
FUNCTION Exist_Any_Rules_For_Sales_Part (
   contract_    IN VARCHAR2,
   catalog_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_rules_for_sales_part IS
      SELECT 1
      FROM   SOURCE_RULE_PER_CUST_ADDR_TAB
      WHERE contract = contract_
      AND   catalog_no = catalog_no_;
BEGIN
   OPEN exist_rules_for_sales_part;
   FETCH exist_rules_for_sales_part INTO dummy_;
   IF (exist_rules_for_sales_part%FOUND) THEN
      CLOSE exist_rules_for_sales_part;
      RETURN(1);
   END IF;
   CLOSE exist_rules_for_sales_part;
   RETURN(0);
   
END Exist_Any_Rules_For_Sales_Part; 



