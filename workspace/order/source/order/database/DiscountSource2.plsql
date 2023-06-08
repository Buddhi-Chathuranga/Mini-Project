-----------------------------------------------------------------------------
--
--  Logical unit: DiscountSource2
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--  ---------------- VIEWS FOR SELECT
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Exist (
   db_value_ IN VARCHAR2 )
IS
BEGIN
   Discount_Source_API.Exist_Db(db_value_);
END Exist;

PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   description_ := Discount_Source_API.Decode(value_);
END Get_Control_Type_Value_Desc;

