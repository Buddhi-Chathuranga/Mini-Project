-----------------------------------------------------------------------------
--
--  Logical unit: PriceBreakTemplateLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180119  CKumlk  STRSC-15930, Modified Check_Update___ by changing Get_State() to Get_Objstate(). 
--  130307  Vwloza  Added min_duration_ key.
--  110930  MaHplk  Modified Unpack_Check_Insert___,Prepare_Insert___ and Check_Delete___ to validate that a record with Min Qty equal to 0 exists.   
--  110906  MaMalk  Modified Unpack_Check_Insert___ to add a validation for avoid entering negative min quantities.
--  110204  RiLase  Removed Amount Offset.
--  110111  NaLrlk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   template_id_ PRICE_BREAK_TEMPLATE_LINE_TAB.template_id%TYPE;
BEGIN
   template_id_ := Client_SYS.Get_Item_Value('TEMPLATE_ID', attr_);
   super(attr_);
   Client_SYS.Add_To_Attr('MIN_QTY', 0, attr_);
   Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', 0, attr_);
   IF(Price_Break_Template_API.Get_Sales_Price_Type_Db(template_id_) = Sales_Price_Type_API.DB_SALES_PRICES) THEN
      Client_SYS.Add_To_Attr('MIN_DURATION', -1, attr_);
   ELSE
      Client_SYS.Add_To_Attr('MIN_DURATION', 0, attr_);
   END IF;
END Prepare_Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN PRICE_BREAK_TEMPLATE_LINE_TAB%ROWTYPE )
IS
   line_exist_  NUMBER;
   sales_price_type_db_ VARCHAR2(20);

   CURSOR check_line_exist(template_id_ VARCHAR2, sales_price_type_ VARCHAR2) IS
      SELECT 1
      FROM PRICE_BREAK_TEMPLATE_LINE_TAB
      WHERE template_id = template_id_
      AND  CASE WHEN (sales_price_type_ = Sales_Price_Type_API.DB_SALES_PRICES  AND  min_qty != 0 AND min_duration = -1) THEN 1 
                WHEN (sales_price_type_ = Sales_Price_Type_API.DB_RENTAL_PRICES AND  (min_qty != 0 OR min_duration != 0)) THEN 1
           END = 1;
BEGIN
   super(remrec_);
   sales_price_type_db_ := Price_Break_Template_API.Get_Sales_Price_Type_Db(remrec_.template_id);

   OPEN check_line_exist(remrec_.template_id, sales_price_type_db_);
   FETCH check_line_exist INTO line_exist_;
   IF (sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
      IF ((check_line_exist%FOUND) AND (remrec_.min_qty = 0))THEN
         Error_SYS.Record_General (lu_name_, 'LINE_DELETE: All other price break template lines should be removed before deleting the price break template line with minimum quantity zero.');   
      END IF;
   ELSIF (sales_price_type_db_ = Sales_Price_Type_API.DB_RENTAL_PRICES) THEN 
      IF ((check_line_exist%FOUND) AND (remrec_.min_qty = 0 AND remrec_.min_duration = 0))THEN
         Error_SYS.Record_General (lu_name_, 'LINE_DELETE_RENTAL: All other price break template lines should be removed before deleting the price break template line with minimum quantity zero and minimum duration zero.');   
      END IF;
   END IF;
   CLOSE check_line_exist; 
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT price_break_template_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   sales_price_type_db_ VARCHAR2(20);
BEGIN
   super(newrec_, indrec_, attr_);

   IF (newrec_.min_qty < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGATIVE_MIN_QTY: Minimum quantity cannot be negative.');
   END IF;
   sales_price_type_db_ := Price_Break_Template_API.Get_Sales_Price_Type_Db(newrec_.template_id);
   IF (sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
      newrec_.min_duration := -1;
      IF NOT ((newrec_.min_qty = 0) OR Check_Exist(newrec_.template_id, 0, -1)) THEN
         Error_SYS.Record_General (lu_name_, 'MIN_QTY_EXIST: The price break template must start from minimum quantity zero.');
      END IF;
   ELSIF (sales_price_type_db_ = Sales_Price_Type_API.DB_RENTAL_PRICES) THEN 
      IF newrec_.min_duration < 0 THEN
         Error_SYS.Record_General(lu_name_, 'NEGATIVE_MIN_DUR: The minimum duration can not be negative for rental prices.');
      END IF;
      IF NOT (((newrec_.min_qty = 0) AND (newrec_.min_duration = 0)) OR Check_Exist(newrec_.template_id, 0, 0)) THEN
         Error_SYS.Record_General (lu_name_, 'MIN_QTY_RENTAL: The price break template must start from minimum quantity zero and minimum duration zero.');
      END IF;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     price_break_template_line_tab%ROWTYPE,
   newrec_ IN OUT price_break_template_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   -- Don't allow update if price break template is in closed state
   IF (Price_Break_Template_API.Get_Objstate(newrec_.template_id) = 'Closed') THEN
      Error_SYS.Record_General(lu_name_, 'NOTALLOWUPDATELINE: Update not allowed when price break template is in closed state.');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist
--   Public interface for checking if price break template line exist.
@UncheckedAccess
FUNCTION Check_Exist (
   template_id_  IN VARCHAR2,
   min_qty_      IN NUMBER,
   min_duration_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(template_id_, min_qty_, min_duration_);
END Check_Exist;



