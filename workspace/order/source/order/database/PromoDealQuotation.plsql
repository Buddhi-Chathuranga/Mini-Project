-----------------------------------------------------------------------------
--
--  Logical unit: PromoDealQuotation
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120802  RuLiLk  Bug 103857, Modified view CALC_PROMO_PER_QUOTATION Added column priority to order by campaign priority. 
--  120113  DaZase  Added more fields from order_quotation/sales_promotion_deal_tab to CALC_PROMO_PER_QUOTATION.
--  111216  DaZase  Added attribute unutilized_deal and method Get_Unutilized_Deal_Db.
--  111212  DaZase  Added joined views CALC_PROMO_PER_QUOTATION/CALC_PROMO_PER_QUOTATION_DEAL for use by new client.
--  101215  NaLrlk  Added procedure Delete_Promo_Deal_For_Quote, New, Modify
--  101215          Check_Exist_For_Quotation and Check_Exist_Any_Quotation.
--  101210  ChFolk  Create
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
   Client_SYS.Add_To_Attr('UNUTILIZED_DEAL_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT promo_deal_quotation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (NOT indrec_.unutilized_deal) THEN
      newrec_.unutilized_deal := 'FALSE';
   END IF; 

   super(newrec_, indrec_, attr_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist_For_Quotation (
   quotation_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   PROMO_DEAL_QUOTATION_TAB
      WHERE  quotation_no = quotation_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_control;
   RETURN 'FALSE';
END Check_Exist_For_Quotation;


@UncheckedAccess
FUNCTION Check_Exist_Any_Quotation (
   campaign_id_ IN NUMBER,
   deal_id_     IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   PROMO_DEAL_QUOTATION_TAB
      WHERE  campaign_id = campaign_id_
      AND    deal_id = deal_id_;
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


-- Delete_Promo_Deal_For_Quote
--   Remove all promotion deals for specified quotation.
PROCEDURE Delete_Promo_Deal_For_Quote (
   quotation_no_ IN VARCHAR2 )
IS
   objid_       PROMO_DEAL_QUOTATION.objid%TYPE;
   objversion_  PROMO_DEAL_QUOTATION.objversion%TYPE;
   remrec_      PROMO_DEAL_QUOTATION_TAB%ROWTYPE;

   CURSOR get_rec IS
      SELECT campaign_id, deal_id
        FROM PROMO_DEAL_QUOTATION_TAB
       WHERE quotation_no = quotation_no_;
BEGIN
   FOR rec_ IN get_rec LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.campaign_id, rec_.deal_id, quotation_no_);
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END LOOP;
END Delete_Promo_Deal_For_Quote;


-- New
--   Public interface for creating a new promotion deal quotation.
PROCEDURE New (
   campaign_id_  IN NUMBER,
   deal_id_      IN NUMBER,
   quotation_no_ IN VARCHAR2,
   priority_     IN NUMBER )
IS
   attr_        VARCHAR2(2000) := NULL;
   objid_       PROMO_DEAL_QUOTATION.objid%TYPE;
   objversion_  PROMO_DEAL_QUOTATION.objversion%TYPE;
   newrec_      PROMO_DEAL_QUOTATION_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('CAMPAIGN_ID',  campaign_id_,  attr_);
   Client_SYS.Add_To_Attr('DEAL_ID',      deal_id_,      attr_);
   Client_SYS.Add_To_Attr('QUOTATION_NO', quotation_no_, attr_);
   Client_SYS.Add_To_Attr('PRIORITY',     priority_,     attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Modify
--   Public interface for modifying a promotion deal quotation.
PROCEDURE Modify (
   campaign_id_                IN NUMBER,
   deal_id_                    IN NUMBER,
   quotation_no_               IN VARCHAR2,
   least_times_deal_fulfilled_ IN NUMBER,
   least_times_deal_ordered_   IN NUMBER,
   unutilized_deal_db_         IN VARCHAR2 DEFAULT NULL )
IS
   attr_        VARCHAR2(2000);
   objid_       PROMO_DEAL_QUOTATION.objid%TYPE;
   objversion_  PROMO_DEAL_QUOTATION.objversion%TYPE;
   info_        VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (least_times_deal_fulfilled_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr( 'LEAST_TIMES_DEAL_FULFILLED', least_times_deal_fulfilled_, attr_ );
   END IF;
   IF (least_times_deal_ordered_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr( 'LEAST_TIMES_DEAL_ORDERED', least_times_deal_ordered_, attr_ );
   END IF;
   IF (unutilized_deal_db_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr( 'UNUTILIZED_DEAL_DB', unutilized_deal_db_, attr_ );
   END IF;
   Get_Id_Version_By_Keys___(objid_, objversion_, campaign_id_, deal_id_, quotation_no_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Modify;



