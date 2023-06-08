-----------------------------------------------------------------------------
--
--  Logical unit: PromoDealGetOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  101215  NaLrlk  Renamed the method Delete_All_Records_For_Order to Delete_Promo_Get_For_Order.
--  100419  DaZase  Added Check_Exist_Any_Order.
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
FUNCTION Check_Exist_Any_Order (
   campaign_id_ IN NUMBER,
   deal_id_     IN NUMBER,
   get_id_      IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   PROMO_DEAL_GET_ORDER_TAB
      WHERE  campaign_id = campaign_id_
      AND    deal_id     = deal_id_
      AND    get_id      = get_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Exist_Any_Order;


-- New
--   Public interface for creating a new promotion deal get order.
PROCEDURE New (
   campaign_id_ IN NUMBER,
   deal_id_     IN NUMBER,
   get_id_      IN NUMBER,
   order_no_    IN VARCHAR2 )
IS
   attr_        VARCHAR2(2000) := NULL;
   objid_       PROMO_DEAL_GET_ORDER.objid%TYPE;
   objversion_  PROMO_DEAL_GET_ORDER.objversion%TYPE;
   newrec_      PROMO_DEAL_GET_ORDER_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('CAMPAIGN_ID', campaign_id_, attr_);
   Client_SYS.Add_To_Attr('DEAL_ID',     deal_id_,     attr_);
   Client_SYS.Add_To_Attr('GET_ID',      get_id_,      attr_);
   Client_SYS.Add_To_Attr('ORDER_NO',    order_no_,    attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Modify
--   Public interface for modifying a promotion deal buy order.
PROCEDURE Modify (
   campaign_id_          IN NUMBER,
   deal_id_              IN NUMBER,
   get_id_               IN NUMBER,
   order_no_             IN VARCHAR2,
   net_amount_           IN NUMBER,
   gross_amount_         IN NUMBER,
   price_qty_            IN NUMBER,
   price_unit_meas_      IN VARCHAR2,     
   times_deal_ordered_   IN NUMBER )
IS
   attr_        VARCHAR2(2000) := NULL;
   info_        VARCHAR2(2000);
   objid_       PROMO_DEAL_GET_ORDER.objid%TYPE;
   objversion_  PROMO_DEAL_GET_ORDER.objversion%TYPE;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'NET_AMOUNT',         net_amount_,         attr_ );
   Client_SYS.Add_To_Attr( 'GROSS_AMOUNT',       gross_amount_,       attr_ );
   Client_SYS.Add_To_Attr( 'PRICE_QTY',          price_qty_,          attr_ );
   Client_SYS.Add_To_Attr( 'PRICE_UNIT_MEAS',    price_unit_meas_,    attr_ );
   Client_SYS.Add_To_Attr( 'TIMES_DEAL_ORDERED', times_deal_ordered_, attr_ );
   Get_Id_Version_By_Keys___(objid_, objversion_, campaign_id_, deal_id_, get_id_, order_no_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Modify;


PROCEDURE Delete_Promo_Get_For_Order (
   order_no_    IN VARCHAR2 )
IS
   remrec_      PROMO_DEAL_GET_ORDER_TAB%ROWTYPE;
   objid_       PROMO_DEAL_GET_ORDER.objid%TYPE;
   objversion_  PROMO_DEAL_GET_ORDER.objversion%TYPE;

   CURSOR get_data IS
      SELECT campaign_id, deal_id, get_id
      FROM   PROMO_DEAL_GET_ORDER_TAB
      WHERE  order_no = order_no_;
BEGIN

   FOR rec_ IN  get_data LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.campaign_id, rec_.deal_id, rec_.get_id, order_no_);
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END LOOP;
END Delete_Promo_Get_For_Order;



