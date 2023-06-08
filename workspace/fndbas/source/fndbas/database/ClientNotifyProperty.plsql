-----------------------------------------------------------------------------
--
--  Logical unit: ClientNotifyProperty
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------
DB_IFS          CONSTANT VARCHAR2(20) := Jsf_Property_Group_API.DB_IFS;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Ifs_Property_Value(
   name_    IN VARCHAR2,
   default_ IN VARCHAR2) RETURN VARCHAR2
IS
   result_ VARCHAR2(4000) := NULL;
   rec_    client_notify_property_tab%ROWTYPE;
BEGIN
   SELECT property_value INTO result_ FROM client_notify_property_tab
    WHERE property_group = DB_IFS AND property_name = name_;
   RETURN result_;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      IF default_ IS NULL THEN
         RETURN NULL;
      END IF;
      rec_.property_group := DB_IFS;
      rec_.property_name := name_;
      rec_.property_value := default_;
      New___(rec_);
      RETURN default_;
END Get_Ifs_Property_Value;

PROCEDURE Remove_Ifs_Property(
   name_ IN VARCHAR2)
IS
BEGIN
   DELETE FROM client_notify_property_tab
    WHERE property_group = DB_IFS AND property_name = name_;
END Remove_Ifs_Property;