-----------------------------------------------------------------------------
--
--  Logical unit: AdditionalShippingDesc
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  090518  KiSalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
-- Get_Additional_Shipping_Desc
--   Fetches the AdditionalShippingDesc attribute for a record.
@UncheckedAccess
FUNCTION Get_Additional_Shipping_Desc (
   additional_shipping_desc_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ additional_shipping_desc_tab.additional_shipping_desc%TYPE;
BEGIN
   IF (additional_shipping_desc_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      additional_shipping_desc_id_), 1, 200);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT additional_shipping_desc
      INTO  temp_
      FROM  additional_shipping_desc_tab
      WHERE additional_shipping_desc_id = additional_shipping_desc_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(additional_shipping_desc_id_, 'Get_Additional_Shipping_Desc');
END Get_Additional_Shipping_Desc;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

