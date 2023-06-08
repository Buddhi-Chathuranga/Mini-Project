-----------------------------------------------------------------------------
--
--  Logical unit: ReturnCause
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Control_Type_Value_Desc
--   This method is used by **Finance** to build a method call dynamically by concatenating the package name that
--   is passed as a parameter to method Create_Control_Type with a hard coded method name.
PROCEDURE Get_Control_Type_Value_Desc (
   desc_    IN OUT VARCHAR2,
   company_ IN     VARCHAR2,
   value_   IN     VARCHAR2 )
IS
   temp_ RETURN_CAUSE_TAB.description%TYPE; 
BEGIN
   temp_ := Get_Description(value_);
   desc_ := temp_;
END Get_Control_Type_Value_Desc;

