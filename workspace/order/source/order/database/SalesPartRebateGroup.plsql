-----------------------------------------------------------------------------
--
--  Logical unit: SalesPartRebateGroup
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  080521  KiSalk  Added procedure Get_Control_Type_Value_Desc.
--  080124  RiLase  Created
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
   sales_part_rebate_group_ IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   temp_ sales_part_rebate_group_tab.description%TYPE;
BEGIN
   IF (sales_part_rebate_group_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER', 'SalesPartRebateGroup',
                                                                          sales_part_rebate_group_,
                                                                          language_code_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  sales_part_rebate_group_tab
      WHERE sales_part_rebate_group = sales_part_rebate_group_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(sales_part_rebate_group_, 'Get_Description');
END Get_Description;

@UncheckedAccess
FUNCTION Get_Description_Per_Language (
   sales_part_rebate_group_ IN VARCHAR2,
   language_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_      SALES_PART_REBATE_GROUP_TAB.description%TYPE;
BEGIN
   description_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER',
                                                                                'SalesPartRebateGroup',
                                                                                sales_part_rebate_group_,
                                                                                language_code_), 1, 35);
   RETURN description_;
END Get_Description_Per_Language;


PROCEDURE Get_Control_Type_Value_Desc (
   description_             IN OUT VARCHAR2,
   company_                 IN     VARCHAR2,
   sales_part_rebate_group_ IN     VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(sales_part_rebate_group_);
END Get_Control_Type_Value_Desc;



