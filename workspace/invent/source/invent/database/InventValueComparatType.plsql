-----------------------------------------------------------------------------
--
--  Logical unit: InventValueComparatType
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120525  JeLise   Made description private.
--  120507  Matkse   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.
--  120507           Insert_Basic_Data_Translation in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507           was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  061106  KaDilk   Added view INVENT_VALUE_COMPARAT_TYPE_LOV.
--  060605  ChBalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
@UncheckedAccess
FUNCTION Get_Description (
   company_ IN VARCHAR2,
   comparator_type_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ invent_value_comparat_type_tab.description%TYPE;
BEGIN
   IF (company_ IS NULL OR comparator_type_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('INVENT', 'InventValueComparatType',
              company||'^'|| comparator_type_id), description), 1, 100)
      INTO  temp_
      FROM  invent_value_comparat_type_tab
      WHERE company = company_
      AND   comparator_type_id = comparator_type_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(company_, comparator_type_id_, 'Get_Description');
END Get_Description;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


