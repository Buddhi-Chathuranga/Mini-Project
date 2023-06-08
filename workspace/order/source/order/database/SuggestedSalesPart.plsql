-----------------------------------------------------------------------------
--
--  Logical unit: SuggestedSalesPart
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110131  Nekolk EANE-3744  added where clause to View SUGGESTED_SALES_PART.
--  100513  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060112  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  -----------------------Version 13.3.0------------------------------------
--  991007  JoEd  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  ---------------------- 11.1 ---------------------------------------------
--  9812xx  PaLj  Created
--  990203  PaLj  Added User_Allowed_Site_API.Exist() in Unpack_check_Inser
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
   Client_SYS.Add_To_Attr('CONTRACT', User_Default_API.Get_Contract, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT suggested_sales_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
BEGIN
   super(newrec_, indrec_, attr_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Suggested_Sales_Part_Exists
--   This method checks if a specific sales part has any suggested sales part
--   connected to it.
@UncheckedAccess
FUNCTION Suggested_Sales_Part_Exists (
   contract_       IN VARCHAR2,
   parent_part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR check_exists IS
      SELECT 1
      FROM   SUGGESTED_SALES_PART_TAB
      WHERE  contract = contract_
      AND    parent_part_no = parent_part_no_;
BEGIN
   OPEN check_exists;
   FETCH check_exists INTO dummy_;
   IF (check_exists%NOTFOUND) THEN
      dummy_ := 0;
   END IF;
   CLOSE check_exists;
   RETURN dummy_;
END Suggested_Sales_Part_Exists;


-- Limit_Suggest_Part_Exists
--   This method checks if a specific sales part has any suggested sales part
--   connected to it when limit sales to assorortment enabled.
@UncheckedAccess
FUNCTION Limit_Suggest_Part_Exists (
   contract_       IN VARCHAR2,
   parent_part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR check_exists IS
      SELECT 1
      FROM   SUGGESTED_SALES_PART_TAB
      WHERE  contract = contract_
      AND    parent_part_no = parent_part_no_
      AND EXISTS (SELECT 1 
                     FROM Limit_To_Assort_Sales_Part_Lov 
                     WHERE suggested_part_no = catalog_no);
BEGIN
   OPEN check_exists;
   FETCH check_exists INTO dummy_;
   IF (check_exists%NOTFOUND) THEN
      dummy_ := 0;
   END IF;
   CLOSE check_exists;
   RETURN dummy_;
END Limit_Suggest_Part_Exists;
