-----------------------------------------------------------------------------
--
--  Logical unit: ConnectorInstanceType
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  -----------------------------------------------------
--  2019-12-02  madrse  PACZDATA-1881: Validation of mandatory attributes
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

--
-- Get DB value for specified attribute name from an attribute string
--
FUNCTION Get_Db_Value_From_Attr (
   name_ IN VARCHAR2,
   attr_ IN VARCHAR2) RETURN VARCHAR2
IS
   value_ VARCHAR2(32000);
BEGIN
   value_ := Client_SYS.Get_Item_Value(name_, attr_);
   IF value_ IS NOT NULL THEN
      value_ := Encode(value_);
   ELSE
      value_ := Client_SYS.Get_Item_Value(name_ || '_DB', attr_);
   END IF;
   RETURN value_;
END Get_Db_Value_From_Attr;

-------------------- LU  NEW METHODS -------------------------------------
