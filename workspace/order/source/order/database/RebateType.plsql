-----------------------------------------------------------------------------
--
--  Logical unit: RebateType
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170209  NiNilk   Bug 132647, Added an error message to avoid entering '*' as a rebate type when entering rebate type basic data
--  170209           as it is used when creating transactions for group rebates.  
--  080521  KiSalk   Added procedure Get_Control_Type_Value_Desc
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT rebate_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF (newrec_.rebate_type = '*') THEN
      Error_SYS.Record_General(lu_name_, 'NOTALLOWEDREBATETYPE: Character "*" is reserved as a default rebate type.');
   END IF;
END Check_Insert___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   rebate_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ rebate_type_tab.description%TYPE;
BEGIN
   IF (rebate_type_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      rebate_type_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
   INTO   temp_
   FROM   rebate_type_tab
   WHERE  rebate_type = rebate_type_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rebate_type_, 'Get_Description');
END Get_Description;

@UncheckedAccess
FUNCTION Get_Description_Per_Language (
   rebate_type_ IN VARCHAR2,
   language_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_      REBATE_TYPE_TAB.description%TYPE;
BEGIN
   description_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER',
                                                                                'RebateType',
                                                                                rebate_type_,
                                                                                language_code_), 1, 35);
   RETURN description_;
END Get_Description_Per_Language;


PROCEDURE Get_Control_Type_Value_Desc (
   description_ IN OUT VARCHAR2,
   company_     IN     VARCHAR2,
   rebate_type_ IN     VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(rebate_type_);
END Get_Control_Type_Value_Desc;



