-----------------------------------------------------------------------------
--
--  Logical unit: SalesChargeGroup
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100514  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  181117  IzShlk   SCUXXW4-9382, Added Get_Lang_Description() method to fetch language sales group description.
--  081105  MaHplk   Added sales_chg_type_category.
--  060118  JaJalk   Added the returning clause in Insert___ according to the new F1 template.
--  991021  DaZa     Added method Get_Control_Type_Value_Desc (used by accrul).
--  990929  DaZa     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('SALES_CHG_TYPE_CATEGORY', Sales_Chg_Type_Category_API.Decode('OTHER'), attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Control_Type_Value_Desc
--   Method that is used by ACCRUL.
PROCEDURE Get_Control_Type_Value_Desc (
   desc_    OUT VARCHAR2,
   company_ IN  VARCHAR2,
   value_   IN  VARCHAR2 )
IS
BEGIN
   desc_ := Get_Charge_Group_Desc(value_);
END Get_Control_Type_Value_Desc;

@UncheckedAccess
FUNCTION Get_Lang_Description (
   charge_group_  IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   temp_ SALES_CHARGE_GROUP_TAB.charge_group_desc%TYPE;
   CURSOR get_attr IS
      SELECT charge_group_desc
      FROM   SALES_CHARGE_GROUP_TAB
      WHERE  charge_group = charge_group_;
BEGIN
   temp_ := Sales_Charge_Group_Desc_API.Get_Charge_Group_Desc(NVL(language_code_, Fnd_Session_API.Get_Language), charge_group_);
   IF (temp_ IS NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Lang_Description;


