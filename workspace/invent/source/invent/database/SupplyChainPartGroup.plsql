-----------------------------------------------------------------------------
--
--  Logical unit: SupplyChainPartGroup
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120507  Matkse   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.
--  120507           Insert_Basic_Data_Translation in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507           was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  060119  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060119           and added UNDEFINE according to the new template.
--  --------------------------------- 13.3.0 --------------------------------
--  030903  GaSolk  Performed CR Merge 2(CR Only).
--  030827  SeKalk  Added the purpose text
--  030326  WaJalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   supply_chain_part_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ supply_chain_part_group_tab.description%TYPE;
BEGIN
   IF (supply_chain_part_group_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      supply_chain_part_group_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  supply_chain_part_group_tab
      WHERE supply_chain_part_group = supply_chain_part_group_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(supply_chain_part_group_, 'Get_Description');
END Get_Description;



