-----------------------------------------------------------------------------
--
--  Logical unit: SalesGroup
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140319  RoJalk   Added the method Insert_Lu_Data_Rec__.
--  120525  JeLise   Made description private.
--  120508  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120508           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120508           was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  050309  JoEd  Added column delivery_confirmation.
--  020109  JICE  Added public view for Sales Configurator.
--  981106  RaKu  Removed obsolete view SALES_GROUP_LOV.
--  980527  JOHW  Removed uppercase on COMMENT ON COLUMN &VIEW..description and
--                COMMENT ON COLUMN &LOV_VIEW..DESCRIPTION
--  971125  TOOS  Upgrade to F1 2.0
--  970509  JoAn  Added method Get_Control_Type_Value_Desc
--  970312  JOED  Changed table name.
--  970218  JOED  Changed objversion.
--  960206  JOED  Created
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
   Client_SYS.Add_To_Attr('DELIVERY_CONFIRMATION', Sales_Group_Delivery_Conf_API.Decode('OPTIONAL'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_group_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   newrec_.delivery_confirmation := 'OPTIONAL';
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_   IN sales_group_tab%ROWTYPE)
IS
   dummy_   NUMBER;
   CURSOR exist_control IS
      SELECT  1
        FROM  sales_group_tab
        WHERE catalog_group = newrec_.catalog_group;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%NOTFOUND) THEN
      INSERT
         INTO   sales_group_tab
         VALUES newrec_;
   ELSE
      UPDATE sales_group_tab
         SET description           = newrec_.description
         WHERE catalog_group       = newrec_.catalog_group;
   END IF;
   CLOSE exist_control;
   Basic_Data_Translation_API.Insert_Prog_Translation('ORDER', 
                                                      'SalesGroup',
                                                       newrec_.catalog_group,
                                                       newrec_.description);
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   catalog_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ SALES_GROUP_TAB.description%TYPE;
   CURSOR get_attr IS
      SELECT description
      FROM  SALES_GROUP_TAB
      WHERE catalog_group = catalog_group_;
BEGIN
   temp_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_,
                                                                         lu_name_,
                                                                         catalog_group_), 1, 35);
   
   IF (temp_ IS NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Description;

-- Get_Control_Type_Value_Desc
--   Returns the sales group description. Used by Accounting.
PROCEDURE Get_Control_Type_Value_Desc (
   desc_    OUT VARCHAR2,
   company_ IN  VARCHAR2,
   value_   IN  VARCHAR2 )
IS
BEGIN
   desc_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;



