-----------------------------------------------------------------------------
--
--  Logical unit: SalesPromotionDealBuy
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170626  ErRalk  Bug 135979, Changed the error message constant from ONLYONEMINAMOUNT to ONEOFMINAMOUNT in Check_Before_Ins_And_Upd___ to eliminate message constant duplication.
--  131029  RoJalk  Modified the view comments of contract to be mandatory and included NOT NULL checks.
--  111116  ChJalk  Modified the view SALES_PROMOTION_DEAL_BUY to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111026  ChJalk  Modified the base view SALES_PROMOTION_DEAL_BUY to use the user allowed company filter.
--  101215  NaLrlk  Renamed the method Check_Insert_And_Update___ to Check_Before_Ins_And_Upd___.
--  101215          Added Exist_Catalog_No___ and Exist_Assortment_Node_Id___.
--  100419  DaZase  Added extra check in Check_Delete___ so user can get a better message when deal is used in a SP calc already.
--  090804  NaLrlk  Added dynamic call instead of direct server calls used from Escm module.
--  090602  RILASE  Added Has_Assortment_Based_Lines.
--  090518  RILASE  Added Check_Insert_And_Update___.
--  090514  RILASE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Before_Ins_And_Upd___(
   newrec_ IN SALES_PROMOTION_DEAL_BUY_TAB%ROWTYPE )
IS
BEGIN

   IF (newrec_.assortment_node_id IS NULL AND newrec_.catalog_no IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'MUSTHAVEASSORTORPART: An assortment node or a sales part must be entered on each line.');
   END IF;

   IF (newrec_.assortment_node_id IS NOT NULL AND newrec_.catalog_no IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ONLYASSORTORPART: Only one of assortment node or sales part can be used on each a line.');
   END IF;

   IF ((newrec_.min_net_amount IS NOT NULL AND (newrec_.min_gross_amount IS NOT NULL OR newrec_.min_qty IS NOT NULL))
   OR (newrec_.min_gross_amount IS NOT NULL AND (newrec_.min_net_amount IS NOT NULL OR newrec_.min_qty IS NOT NULL))
   OR (newrec_.min_qty IS NOT NULL AND (newrec_.min_net_amount IS NOT NULL OR newrec_.min_gross_amount IS NOT NULL))) THEN
      Error_SYS.Record_General(lu_name_, 'ONLYONEMINAMOUNT: Only one of minimum quantity, minimum net amount or minimum gross amount can be set.');
   END IF;

   IF (newrec_.min_net_amount IS NULL AND newrec_.min_gross_amount IS NULL AND newrec_.min_qty IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ONEOFMINAMOUNT: One of minimum quantity, minimum net amount or minimum gross amount must be set.');
   END IF;

   IF (newrec_.min_qty IS NOT NULL AND newrec_.price_unit_meas IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'UNITMEASMUSTBESET: Price unit of measure must be set if minimum quantity is used.');
   END IF;

   IF (newrec_.catalog_no IS NOT NULL AND newrec_.price_unit_meas != Sales_Part_API.Get_Price_Unit_Meas(newrec_.contract, newrec_.catalog_no)) THEN
      Error_SYS.Record_General(lu_name_, 'UNITMEASFROMSALESPART: Price unit of measure must be the same as the price unit of measure on the selected sales part.');
   END IF;
   
   IF (newrec_.min_qty <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'MINQTYLARGERTHANZERO: The minimum quantity must be greater than zero.');
   END IF;
   
   IF (newrec_.min_gross_amount <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'MINGROSSMTLARGERTHANZERO: The minimum gross amount must be greater than zero.');
   END IF;
   
   IF (newrec_.min_net_amount <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'MINNETAMTLARGERTHANZERO: The minimum net amount must be greater than zero.');
   END IF;
END Check_Before_Ins_And_Upd___;


PROCEDURE Get_Next_Buy_Id___ (
   buy_id_       IN OUT NUMBER,
   campaign_id_  IN     NUMBER,
   deal_id_      IN     NUMBER )
IS
   CURSOR get_next_buy_id IS
      SELECT NVL(max(buy_id + 1), 1)
      FROM   SALES_PROMOTION_DEAL_BUY_TAB
      WHERE  campaign_id = campaign_id_
      AND    deal_id = deal_id_;
BEGIN
   OPEN  get_next_buy_id;
   FETCH get_next_buy_id into buy_id_;
   CLOSE get_next_buy_id;
END Get_Next_Buy_Id___;


-- Exist_Catalog_No___
--   Returns whether or not a specific catalog no already connected to a
--   sales promotion deal buy line.
PROCEDURE Exist_Catalog_No___(
   campaign_id_ IN NUMBER,
   deal_id_     IN NUMBER,
   catalog_no_  IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_records IS
      SELECT 1
      FROM  SALES_PROMOTION_DEAL_BUY_TAB
      WHERE campaign_id = campaign_id_
      AND   deal_id = deal_id_
      AND   catalog_no = catalog_no_;
BEGIN
   OPEN  exist_records;
   FETCH exist_records INTO dummy_;
   IF (exist_records%FOUND) THEN
      Error_SYS.Record_General(lu_name_, 'PARTSPEXIST: The sales part number :P1 is already used.', catalog_no_);
   END IF;
   CLOSE exist_records;
END Exist_Catalog_No___;


-- Exist_Assortment_Node_Id___
--   Returns whether or not a specific assortment node already connected to a
--   sales promotion deal buy line.
PROCEDURE Exist_Assortment_Node_Id___(
   campaign_id_        IN NUMBER,
   deal_id_            IN NUMBER,
   assortment_node_id_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_records IS
      SELECT 1
      FROM  SALES_PROMOTION_DEAL_BUY_TAB
      WHERE campaign_id = campaign_id_
      AND   deal_id = deal_id_
      AND   assortment_node_id = assortment_node_id_;
BEGIN
   OPEN  exist_records;
   FETCH exist_records INTO dummy_;
   IF (exist_records%FOUND) THEN
      Error_SYS.Record_General(lu_name_, 'ASSORTSPEXIST: The assortment node ID :P1 is already used.', assortment_node_id_);
   END IF;
   CLOSE exist_records;
END Exist_Assortment_Node_Id___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_      VARCHAR2(5);
   deal_id_       NUMBER;
   campaign_id_   NUMBER;
   assortment_id_ VARCHAR2(50);
BEGIN
   campaign_id_ := Client_SYS.Get_Item_Value('CAMPAIGN_ID', attr_);
   deal_id_  := Client_SYS.Get_Item_Value('DEAL_ID', attr_);
   contract_ := Sales_Promotion_Deal_API.Get_Contract(campaign_id_, deal_id_);
   assortment_id_ := Campaign_API.Get_Assortment_Id(campaign_id_);
   super(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_ID', assortment_id_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SALES_PROMOTION_DEAL_BUY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Get_Next_Buy_Id___(newrec_.buy_id, newrec_.campaign_id, newrec_.deal_id);
   Client_SYS.Add_To_Attr('BUY_ID', newrec_.buy_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN SALES_PROMOTION_DEAL_BUY_TAB%ROWTYPE )
IS
BEGIN
   IF (Promo_Deal_Buy_Order_API.Check_Exist_Any_Order(remrec_.campaign_id, remrec_.deal_id, remrec_.buy_id)) THEN
      Error_SYS.Record_General(lu_name_, 'DEALBUYORDUSED: This deal buy line has already been used in sales promotion calculations on one or more customer orders.');
   END IF;
   IF (Promo_Deal_Buy_Quotation_API.Check_Exist_Any_Quotation(remrec_.campaign_id, remrec_.deal_id, remrec_.buy_id)) THEN
      Error_SYS.Record_General(lu_name_, 'DEALBUYQUOTEUSED: This deal buy line has already been used in sales promotion calculations on one or more sales quotations.');
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_promotion_deal_buy_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   -- Only insert assortment_id if buy deal is assortment based.
   IF (NOT indrec_.assortment_id) THEN
      newrec_.assortment_id    := ''; 
   END IF;   
   super(newrec_, indrec_, attr_);
   Check_Before_Ins_And_Upd___(newrec_);
   IF newrec_.catalog_no IS NOT NULL THEN
      Exist_Catalog_No___(newrec_.campaign_id, newrec_.deal_id, newrec_.catalog_no);
   ELSIF newrec_.assortment_node_id IS NOT NULL THEN
      Exist_Assortment_Node_Id___(newrec_.campaign_id, newrec_.deal_id, newrec_.assortment_node_id);
   END IF;  
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sales_promotion_deal_buy_tab%ROWTYPE,
   newrec_ IN OUT sales_promotion_deal_buy_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (Campaign_API.Get_Objstate(newrec_.campaign_id) != 'Planned') THEN
      Error_SYS.Record_General(lu_name_, 'CHANGENOTALLOWSP: You are only allowed to edit a sales promotion, if the campaign is in status Planned.');
   END IF;
   Check_Before_Ins_And_Upd___(newrec_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Has_Assortment_Based_Lines (
   campaign_id_ IN NUMBER,
   deal_id_     IN NUMBER DEFAULT NULL) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR assort_exist_control IS
      SELECT 1
      FROM   SALES_PROMOTION_DEAL_BUY_TAB
      WHERE campaign_id = campaign_id_
      AND   deal_id = deal_id_
      AND   assortment_id IS NOT NULL;

   CURSOR assort_exist_control_no_deal IS
      SELECT 1
      FROM   SALES_PROMOTION_DEAL_BUY_TAB
      WHERE campaign_id = campaign_id_
      AND   assortment_id IS NOT NULL;

BEGIN
   IF deal_id_ IS NULL THEN
      OPEN assort_exist_control_no_deal;
      FETCH assort_exist_control_no_deal INTO dummy_;
      IF (assort_exist_control_no_deal%FOUND) THEN
         CLOSE assort_exist_control_no_deal;
         RETURN(TRUE);
      END IF;
      CLOSE assort_exist_control_no_deal;
      RETURN(FALSE);
   ELSE
      OPEN assort_exist_control;
      FETCH assort_exist_control INTO dummy_;
      IF (assort_exist_control%FOUND) THEN
         CLOSE assort_exist_control;
         RETURN(TRUE);
      END IF;
      CLOSE assort_exist_control;
      RETURN(FALSE);
   END IF;
END Has_Assortment_Based_Lines;


PROCEDURE Copy_Buy_To_Get (
   campaign_id_  IN NUMBER,
   deal_id_      IN NUMBER)
IS
   CURSOR get_all_buy_lines IS
   SELECT *
   FROM   SALES_PROMOTION_DEAL_BUY_TAB
   WHERE  campaign_id = campaign_id_
   AND    deal_id = deal_id_;
BEGIN
   -- Check if the campaign is in state planned
   IF(Campaign_API.Get_Objstate(campaign_id_) != 'Planned') THEN
      Error_SYS.Record_General(lu_name_, 'NOCOPYBUYGETINSTATE: Buy lines cannot be copied when the campaign is in state :P1.', Campaign_API.Get_State(campaign_id_));
   END IF;

   FOR rec_ IN get_all_buy_lines LOOP
      Sales_Promotion_Deal_Get_API.New(rec_.campaign_id,
                                       rec_.deal_id,
                                       rec_.description,
                                       rec_.min_qty,
                                       rec_.min_gross_amount,
                                       rec_.min_net_amount,
                                       rec_.assortment_id,
                                       rec_.assortment_node_id,
                                       rec_.price_unit_meas,
                                       rec_.catalog_no,
                                       rec_.contract);
   END LOOP;
END Copy_Buy_To_Get;



