-----------------------------------------------------------------------------
--
--  Logical unit: SalesPriceGroup
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
--  120508           was added. Get_Description and the views were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  060118  JaJalk   Added the returning clause in Insert___ according to the new F1 template.
--  040226  IsWilk   Removed the SUBSTRB from the view for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes---------------------
--  990419  RaKu  Y.Cleanup.
--  981130  RaKu  Changes to match Design.
--  981119  RaKu  Added views SALES_PRICE_GROUP_PART_LOV and SALES_PRICE_GROUP_UNIT_LOV.
--  981112  RaKu  Modifyed "unit"-checks on Unpack_Check_Insert___.
--  981104  RaKu  Modifyed comments for sales_price_group_id.
--  981028  RaKu  Added function Get_Sales_Price_Group_Type_Db. Removed modify-option
--                for sales_price_group_type andsales_price_group_unit.
--  981007  RaKu  Created
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
   Client_SYS.Add_To_Attr('SALES_PRICE_GROUP_TYPE', Sales_Price_Group_Type_API.Decode('PART BASED'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_price_group_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   IF (newrec_.sales_price_group_type = 'PART BASED') THEN
      -- Part Based
      IF (newrec_.sales_price_group_unit IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'UNIT_ENTERED: Price Group Unit can not be entered when Price Group Type is Part Based');
      END IF;
   ELSE
      -- Unit Based
      IF (newrec_.sales_price_group_unit IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'UNIT_NOT_ENTERED: Price Group Unit must be entered when Price Group Type is Unit Based');
      END IF;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_   IN sales_price_group_tab%ROWTYPE)
IS
   dummy_   NUMBER;
   CURSOR exist_control IS
      SELECT  1
        FROM  sales_price_group_tab
        WHERE sales_price_group_id = newrec_.sales_price_group_id;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%NOTFOUND) THEN
      INSERT
         INTO   sales_price_group_tab
         VALUES newrec_;
   ELSE
      UPDATE sales_price_group_tab
         SET description = newrec_.description
         WHERE sales_price_group_id = newrec_.sales_price_group_id;
   END IF;
   CLOSE exist_control;
   Basic_Data_Translation_API.Insert_Prog_Translation('ORDER', 
                                                      'SalesPriceGroup',
                                                       newrec_.sales_price_group_id,
                                                       newrec_.description);
END Insert_Lu_Data_Rec__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   sales_price_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ sales_price_group_tab.description%TYPE;
BEGIN
   IF (sales_price_group_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      sales_price_group_id_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  sales_price_group_tab
      WHERE sales_price_group_id = sales_price_group_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(sales_price_group_id_, 'Get_Description');
END Get_Description;


