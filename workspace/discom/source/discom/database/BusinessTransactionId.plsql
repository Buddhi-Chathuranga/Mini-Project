-----------------------------------------------------------------------------
--
--  Logical unit: BusinessTransactionId
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211014  cecobr  FI21R2-4615, Move Entity and associated clint/logic of BusinessTransactionCode from MPCCOM to DISCOM
--  210927  fiallk  Added method Get_Control_Type_Value_Desc.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- Method used for fetching the description for business transaction id when inserting control types.
@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(company_, value_);
END Get_Control_Type_Value_Desc;
