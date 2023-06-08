-----------------------------------------------------------------------------
--
--  Logical unit: PromoDealBuyOrderLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  101215  NaLrlk  Renamed the method Delete_All_Records_For_Order to Delete_Promo_Buy_Ln_For_Order.
--  101215          And rename the method Remove_All_Rows_For_This_Deal to Remove_All_Lines_For_Deal.
--  0906xx  DaZase  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist_Order_Line (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   PROMO_DEAL_BUY_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Exist_Order_Line;


-- New
--   Public interface for creating a new promotion deal buy order line.
PROCEDURE New (
   campaign_id_       IN NUMBER,
   deal_id_           IN NUMBER,
   buy_id_            IN NUMBER,
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   net_amount_        IN NUMBER,
   gross_amount_      IN NUMBER,
   price_qty_         IN NUMBER,
   price_unit_meas_   IN VARCHAR2 )
IS
   attr_        VARCHAR2(2000) := NULL;
   objid_       PROMO_DEAL_BUY_ORDER_LINE.objid%TYPE;
   objversion_  PROMO_DEAL_BUY_ORDER_LINE.objversion%TYPE;
   newrec_      PROMO_DEAL_BUY_ORDER_LINE_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('CAMPAIGN_ID',     campaign_id_,     attr_);
   Client_SYS.Add_To_Attr('DEAL_ID',         deal_id_,         attr_);
   Client_SYS.Add_To_Attr('BUY_ID',          buy_id_,          attr_);
   Client_SYS.Add_To_Attr('ORDER_NO',        order_no_,        attr_);
   Client_SYS.Add_To_Attr('LINE_NO',         line_no_,         attr_);
   Client_SYS.Add_To_Attr('REL_NO',          rel_no_,          attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO',    line_item_no_,    attr_);
   Client_SYS.Add_To_Attr('NET_AMOUNT',      net_amount_,      attr_);
   Client_SYS.Add_To_Attr('GROSS_AMOUNT',    gross_amount_,    attr_);
   Client_SYS.Add_To_Attr('PRICE_QTY',       price_qty_,       attr_);
   Client_SYS.Add_To_Attr('PRICE_UNIT_MEAS', price_unit_meas_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


PROCEDURE Delete_Promo_Buy_Ln_For_Order (
   order_no_    IN VARCHAR2 )
IS
   remrec_      PROMO_DEAL_BUY_ORDER_LINE_TAB%ROWTYPE;
   objid_       PROMO_DEAL_BUY_ORDER_LINE.objid%TYPE;
   objversion_  PROMO_DEAL_BUY_ORDER_LINE.objversion%TYPE;

   CURSOR get_data IS
      SELECT campaign_id, deal_id, buy_id, line_no, rel_no, line_item_no
      FROM   PROMO_DEAL_BUY_ORDER_LINE_TAB
      WHERE  order_no = order_no_;
BEGIN

   FOR rec_ IN  get_data LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.campaign_id, rec_.deal_id, rec_.buy_id, order_no_, 
                                rec_.line_no, rec_.rel_no, rec_.line_item_no);
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END LOOP;
END Delete_Promo_Buy_Ln_For_Order;


-- Remove_All_Lines_For_Deal
--   Remove all promotion buy deal lines for specified deal.
PROCEDURE Remove_All_Lines_For_Deal (
   campaign_id_  IN NUMBER,
   deal_id_      IN NUMBER )
IS
   remrec_      PROMO_DEAL_BUY_ORDER_LINE_TAB%ROWTYPE;
   objid_       PROMO_DEAL_BUY_ORDER_LINE.objid%TYPE;
   objversion_  PROMO_DEAL_BUY_ORDER_LINE.objversion%TYPE;

   CURSOR get_data IS
      SELECT buy_id, order_no, line_no, rel_no, line_item_no
      FROM   PROMO_DEAL_BUY_ORDER_LINE_TAB
      WHERE  campaign_id = campaign_id_
      AND    deal_id = deal_id_;
BEGIN

   FOR rec_ IN  get_data LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, campaign_id_, deal_id_, rec_.buy_id, 
                                rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END LOOP;
END Remove_All_Lines_For_Deal;



