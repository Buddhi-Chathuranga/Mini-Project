-----------------------------------------------------------------------------
--
--  Logical unit: FreeOfCharge
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200723  MalLlk  GESPRING20-4618, Created.
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
   Fnd_Boolean_API.Exist_Db(db_value_);
END Exist;

PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   description_ := Fnd_Boolean_API.Decode(value_);
END Get_Control_Type_Value_Desc;

-------------------- LU  NEW METHODS ----------------------------------------

