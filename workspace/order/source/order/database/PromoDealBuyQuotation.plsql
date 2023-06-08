-----------------------------------------------------------------------------
--
--  Logical unit: PromoDealBuyQuotation
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  101215  NaLrlk  Added procedure Delete_Promo_Buy_For_Quote, New, Modify.
--  101215          Check_Exist_Any_Quotation.
--  101210  ChFolk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Delete_Promo_Buy_For_Quote
--   Remove all promotion buy deals for specified quotation.
PROCEDURE Delete_Promo_Buy_For_Quote (
   quotation_no_ IN VARCHAR2 )
IS
   objid_       PROMO_DEAL_BUY_QUOTATION.objid%TYPE;
   objversion_  PROMO_DEAL_BUY_QUOTATION.objversion%TYPE;
   remrec_      PROMO_DEAL_BUY_QUOTATION_TAB%ROWTYPE;

   CURSOR get_rec IS
      SELECT campaign_id, deal_id, buy_id
        FROM PROMO_DEAL_BUY_QUOTATION_TAB
       WHERE quotation_no = quotation_no_;
BEGIN
   FOR rec_ IN get_rec LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.campaign_id, rec_.deal_id, rec_.buy_id, quotation_no_);
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END LOOP;
END Delete_Promo_Buy_For_Quote;


-- New
--   Public interface for creating a new promotion deal buy quotation.
PROCEDURE New (
   campaign_id_  IN NUMBER,
   deal_id_      IN NUMBER,
   buy_id_       IN NUMBER,
   quotation_no_ IN VARCHAR2 )
IS
   attr_        VARCHAR2(2000);
   objid_       PROMO_DEAL_BUY_QUOTATION.objid%TYPE;
   objversion_  PROMO_DEAL_BUY_QUOTATION.objversion%TYPE;
   newrec_      PROMO_DEAL_BUY_QUOTATION_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CAMPAIGN_ID',  campaign_id_,  attr_);
   Client_SYS.Add_To_Attr('DEAL_ID',      deal_id_,      attr_);
   Client_SYS.Add_To_Attr('BUY_ID',       buy_id_,       attr_);
   Client_SYS.Add_To_Attr('QUOTATION_NO', quotation_no_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Modify
--   Public interface for modifying a promotion deal buy quotation.
PROCEDURE Modify (
   campaign_id_          IN NUMBER,
   deal_id_              IN NUMBER,
   buy_id_               IN NUMBER,
   quotation_no_         IN VARCHAR2,
   net_amount_           IN NUMBER,
   gross_amount_         IN NUMBER,
   price_qty_            IN NUMBER,
   price_unit_meas_      IN VARCHAR2,     
   times_deal_fulfilled_ IN NUMBER )
IS
   attr_        VARCHAR2(2000);
   info_        VARCHAR2(2000);
   objid_       PROMO_DEAL_BUY_QUOTATION.objid%TYPE;
   objversion_  PROMO_DEAL_BUY_QUOTATION.objversion%TYPE;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'NET_AMOUNT',           net_amount_,           attr_ );
   Client_SYS.Add_To_Attr( 'GROSS_AMOUNT',         gross_amount_,         attr_ );
   Client_SYS.Add_To_Attr( 'PRICE_QTY',            price_qty_,            attr_ );
   Client_SYS.Add_To_Attr( 'PRICE_UNIT_MEAS',      price_unit_meas_,      attr_ );
   Client_SYS.Add_To_Attr( 'TIMES_DEAL_FULFILLED', times_deal_fulfilled_, attr_ );
   Get_Id_Version_By_Keys___(objid_, objversion_, campaign_id_, deal_id_, buy_id_, quotation_no_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Modify;


@UncheckedAccess
FUNCTION Check_Exist_Any_Quotation (
   campaign_id_ IN NUMBER,
   deal_id_     IN NUMBER,
   buy_id_      IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   PROMO_DEAL_BUY_QUOTATION_TAB
      WHERE  campaign_id = campaign_id_
      AND    deal_id = deal_id_
      AND    buy_id = buy_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Exist_Any_Quotation;



