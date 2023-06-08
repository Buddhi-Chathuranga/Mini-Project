-----------------------------------------------------------------------------
--
--  Logical unit: SalesDiscountGroup
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140519  SURBLK  Added discount_code_ as additional parameter in Get_Amount_Discount().
--  140423  ShKolk  Modified Get_Amount_Discount() to consider use_price_incl_tax setting and return relevant discount percentage.
--  120525  JeLise  Made description private.
--  120509  JeLise  Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120509          in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120509          was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  060117  MaHplk  Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  040224  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  ----------------------13.3.0---------------------------------------------
--  980527  JOHW  Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  971125  TOOS  Upgrade to F1 2.0
--  970521  JOED  Rebuild Get_.. methods calling Get_Instance___.
--                Added .._db columns in the view for all IID columns.
--  970312  NABE  Changed Table Name OE_DISCOUNT_GROUP_TAB to
--                SALES_DISCOUNT_GROUP_TAB
--  970218  RaKu  Changed rowversion (10.3 Project).
--  960212  JOED  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Amount_Discount
--   Returns right discount for current order_value
@UncheckedAccess
FUNCTION Get_Amount_Discount (
   discount_group_     IN VARCHAR2,
   order_total_value_  IN NUMBER,
   discount_code_      IN VARCHAR2,
   use_price_incl_tax_ IN VARCHAR2 ) RETURN NUMBER
IS
   discount_ SALES_DISCOUNT_GROUP_BREAK_TAB.discount%TYPE := 0;

   CURSOR get_discount IS
      SELECT discount
      FROM   SALES_DISCOUNT_GROUP_BREAK_TAB
      WHERE  discount_group = discount_group_
      AND    order_total = (SELECT MAX(order_total)
                            FROM   SALES_DISCOUNT_GROUP_BREAK_TAB
                            WHERE  discount_group = discount_group_
                            AND    order_total < order_total_value_);

   CURSOR get_discount_incl_tax IS
      SELECT discount
      FROM   SALES_DISCOUNT_GROUP_BREAK_TAB
      WHERE  discount_group = discount_group_
      AND    order_total_incl_tax = (SELECT MAX(order_total_incl_tax)
                                     FROM   SALES_DISCOUNT_GROUP_BREAK_TAB
                                     WHERE  discount_group = discount_group_
                                     AND    order_total_incl_tax < order_total_value_);
BEGIN
   IF (use_price_incl_tax_ = 'TRUE' AND discount_code_ = 'V') THEN
      OPEN  get_discount_incl_tax;
      FETCH get_discount_incl_tax INTO discount_;
      CLOSE get_discount_incl_tax;
   ELSE
      OPEN  get_discount;
      FETCH get_discount INTO discount_;
      CLOSE get_discount;
   END IF;
   RETURN discount_;
END Get_Amount_Discount;

@UncheckedAccess
FUNCTION Get_Description (
   discount_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ sales_discount_group_tab.description%TYPE;
BEGIN
   IF (discount_group_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      discount_group_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
   INTO   temp_
   FROM   sales_discount_group_tab
   WHERE  discount_group = discount_group_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(discount_group_, 'Get_Description');
END Get_Description;
