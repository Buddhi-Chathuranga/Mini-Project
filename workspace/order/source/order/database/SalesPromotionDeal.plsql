-----------------------------------------------------------------------------
--
--  Logical unit: SalesPromotionDeal
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160920  NWeelk  FINHR-2043, Added method Calc_Promotion_Prices to calculate prices and discounts of the sales promotion.
--  140416  MaRalk  PBSC-8354, Modified message text of DISCOUNTGREATERTHANZERO in Check_Insert_And_Update___.
--  130606  TiRalk  Bug 110328, Modified Check_Insert_And_Update___ to validate column fee_code.
--  130226  HimRlk  Added new column fee_code.
--  111216  DaZase  Added notify_unutilized_deal.
--  111116  ChJalk  Modified the view SALES_PROMOTION_DEAL to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111026  ChJalk  Modified the base view SALES_PROMOTION_DEAL to use the user allowed company filter.
--  110922  ChJalk  Modified the method Check_Charge_Type_Exist to change the error messages INVCHARGE and INVCHARGE2. 
--  100419  DaZase  Added extra check in Check_Delete___ so user can get a better message when deal is used in a SP calc already.
--  090804  NaLrlk  Added dynamic call instead of direct server calls used from Escm module.
--  090611  RILASE  Added call to Sales_Promotion_Deal_Get_API.Deal_Is_Discount_Only to validate GET lines if price or discount amount is used.
--  090609  RILASE  Added Check_Charge_Type_Exist().
--  090602  RILASE  Added Has_Assortment_Based_Deal().
--  090529  RILASE  Added Campaign_Has_Sales_Promo_Deal().
--  090518  RILASE  Added Check_Insert_And_Update___().
--  090423  RILASE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Insert_And_Update___ (
   newrec_          IN SALES_PROMOTION_DEAL_TAB%ROWTYPE,
   validation_type_ IN VARCHAR2)
IS
   campaign_state_ VARCHAR2(30) := NULL;
   company_        VARCHAR2(20);
   tax_code_rec_   Statutory_Fee_API.Public_Rec;
BEGIN

   IF (validation_type_ = 'INSERT' OR validation_type_ = 'UPDATE') THEN
      IF (newrec_.fee_code IS NOT NULL) THEN
         Statutory_Fee_API.Exist(Campaign_API.Get_Company(newrec_.campaign_id), newrec_.fee_code);
      END IF;
      -- INSERT and UPDATE -> At least one of the five must be set if the campaign is in approved state Approved
      campaign_state_ := Campaign_API.Get_Objstate(newrec_.campaign_id);
      
      IF (campaign_state_ = 'Active') THEN
         IF (newrec_.price_excl_tax IS NULL AND newrec_.price_incl_tax IS NULL AND newrec_.discount_net_amount IS NULL AND newrec_.discount_gross_amount IS NULL AND newrec_.discount IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'ONEDEALTYPEMUSTBESET: A deal must have one of price including tax, price excluding tax, discount net amount, discount gross amount or discount set.');
         END IF;
      END IF;
   
      -- INSERT and UPDATE -> Value validation
      IF (newrec_.price_excl_tax < 0 OR newrec_.price_incl_tax < 0 ) THEN
         Error_SYS.Record_General(lu_name_, 'PRICEMUSTBEPOSITIVE: Prices has to be greater than zero.');
      END IF;
      IF (newrec_.discount_net_amount <= 0 OR newrec_.discount_gross_amount <= 0 ) THEN
         Error_SYS.Record_General(lu_name_, 'DISCAMTGREATERTHANZERO: Discount amounts must be greater than zero.');
      END IF;
      IF (newrec_.discount <= 0 OR newrec_.discount > 100) THEN
         Error_SYS.Record_General(lu_name_, 'DISCOUNTGREATERTHANZERO: Discount percentage should be greater than 0.');
      END IF;
   
      -- INSERT and UPDATE -> Check if charge type is defined on all target sites
      Campaign_Site_API.Check_Charge_Type_On_Targets(newrec_.campaign_id, newrec_.charge_type);
      
      -- INSERT and UPDATE -> Check that Chrage type uses the correct charge type category
      IF (Sales_Charge_Group_Api.Get_Sales_Chg_Type_Category_Db(Sales_Charge_Type_Api.Get_Charge_Group(newrec_.contract, newrec_.charge_type)) != 'PROMOTION') THEN
         Error_SYS.Record_General(lu_name_, 'CHGTYPECATEGORYPROMO: Charge type :P1 should be of charge type category Promotion.', newrec_.charge_type);
      END IF;
      
      company_       := Site_API.Get_Company(newrec_.contract);
      IF (newrec_.fee_code IS NOT NULL) THEN
         Statutory_Fee_API.Validate_Tax_Code(company_, newrec_.fee_code, SYSDATE);   
      END IF;
      Tax_Handling_Util_API.Validate_Tax_On_Basic_Data(company_, 'RESTRICTED', newrec_.fee_code, 'ALL', SYSDATE);            
   END IF;
   
   IF (validation_type_ = 'UPDATE') THEN
      -- Only on update -> Check if current deal has GET lines that have qty, gross amount AND net amount = NULL
      IF (Get_Discount(newrec_.campaign_id, newrec_.deal_id) IS NOT NULL AND newrec_.discount IS NULL AND Sales_Promotion_Deal_Get_API.Deal_Is_Discount_Only(newrec_.campaign_id, newrec_.deal_id)) THEN
         Error_SYS.Record_General(lu_name_, 'DEALISDISCOUNTONLY: Deal type cannot be changed from discount % when there are get lines without quantity, net amount or gross amount set.');
      END IF;
      -- IF a get line is of type discount % only then a price or discount amount can't be set
      IF (Sales_Promotion_Deal_Get_API.Deal_Is_Discount_Only(newrec_.campaign_id, newrec_.deal_id) AND 
          (newrec_.price_excl_tax IS NOT NULL OR newrec_.price_incl_tax IS NOT NULL OR newrec_.discount_net_amount IS NOT NULL OR newrec_.discount_gross_amount IS NOT NULL)) THEN
         Error_SYS.Record_General(lu_name_, 'DEALISDISCOUNTONLY2: Deal type must be discount % when there are get lines without quantity, net amount or gross amount set.');
      END IF;
      IF (campaign_state_ != 'Planned') THEN
         Error_SYS.Record_General(lu_name_, 'CHANGENOTALLOWSP: You are only allowed to edit a sales promotion, if the campaign is in status Planned.');
      END IF;
   END IF;
END Check_Insert_And_Update___;


PROCEDURE Get_Next_Deal_Id___ (
   deal_id_      IN OUT NUMBER,
   campaign_id_  IN     NUMBER)
IS
   CURSOR get_next_deal_id IS
      SELECT NVL(max(deal_id + 1), 1)
      FROM SALES_PROMOTION_DEAL_TAB
      WHERE campaign_id = campaign_id_;
BEGIN
   OPEN  get_next_deal_id;
   FETCH get_next_deal_id into deal_id_;
   CLOSE get_next_deal_id;
END Get_Next_Deal_Id___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_      VARCHAR2(5);
   campaign_id_   NUMBER;
   company_       VARCHAR2(20);
BEGIN
   campaign_id_   := Client_SYS.Get_Item_Value('CAMPAIGN_ID', attr_);
   contract_      := Campaign_API.Get_Reference_Site(campaign_id_);
   company_       := Site_API.Get_Company(contract_);  
   super(attr_);
   Client_SYS.Add_To_Attr('FEE_CODE' , Company_Tax_Discom_Info_API.Get_Tax_Code(company_), attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('NOTIFY_UNUTILIZED_DEAL_DB', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SALES_PROMOTION_DEAL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Get_Next_Deal_Id___(newrec_.deal_id, newrec_.campaign_id);
   Client_SYS.Add_To_Attr('DEAL_ID', newrec_.deal_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN SALES_PROMOTION_DEAL_TAB%ROWTYPE )
IS
BEGIN
   IF (Promo_Deal_Order_API.Check_Exist_Any_Order(remrec_.campaign_id, remrec_.deal_id)) THEN
      Error_SYS.Record_General(lu_name_, 'DEALBUYORDUSED: This deal buy line has already been used in sales promotion calculations on one or more customer orders.');
   END IF;
   IF (Promo_Deal_Quotation_API.Check_Exist_Any_Quotation(remrec_.campaign_id, remrec_.deal_id)) THEN
      Error_SYS.Record_General(lu_name_, 'DEALBUYQUOTEUSED: This deal buy line has already been used in sales promotion calculations on one or more sales quotations.');
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_promotion_deal_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.notify_unutilized_deal := 'TRUE';
   super(newrec_, indrec_, attr_);
   Check_Insert_And_Update___(newrec_, 'INSERT');
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sales_promotion_deal_tab%ROWTYPE,
   newrec_ IN OUT sales_promotion_deal_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Check_Insert_And_Update___(newrec_, 'UPDATE');
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Campaign_Has_Sales_Promo_Deal(
   campaign_id_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR deal_exist_control IS
      SELECT 1
      FROM SALES_PROMOTION_DEAL_TAB
      WHERE campaign_id = campaign_id_;
BEGIN
   OPEN deal_exist_control;
   FETCH deal_exist_control INTO dummy_;
   IF (deal_exist_control%FOUND) THEN
      CLOSE deal_exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE deal_exist_control;
   RETURN(FALSE);
END Campaign_Has_Sales_Promo_Deal;


@UncheckedAccess
FUNCTION Has_Assortment_Based_Deal(
   campaign_id_ IN NUMBER,
   deal_id_     IN NUMBER DEFAULT NULL) RETURN BOOLEAN
IS
BEGIN
   IF (Sales_Promotion_Deal_Buy_API.Has_Assortment_Based_Lines(campaign_id_, deal_id_) OR 
       Sales_Promotion_Deal_Get_API.Has_Assortment_Based_Lines(campaign_id_, deal_id_)) THEN
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Has_Assortment_Based_Deal;


PROCEDURE Check_Charge_Type_Exist(
   campaign_id_ IN NUMBER,
   contract_    IN VARCHAR2)
IS
   CURSOR get_all_charge_types IS
      SELECT DISTINCT charge_type, deal_id
      FROM SALES_PROMOTION_DEAL_TAB
      WHERE campaign_id = campaign_id_;
BEGIN
   FOR rec_ IN get_all_charge_types LOOP
      IF (Sales_Charge_Type_API.Check_Exist(contract_, rec_.charge_type) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'INVCHARGE: Charge type :P1 in deal :P2 is not defined for the target site :P3.', rec_.charge_type, rec_.deal_id, contract_);
      ELSIF (Sales_Charge_Group_Api.Get_Sales_Chg_Type_Category_Db(Sales_Charge_Type_Api.Get_Charge_Group(contract_, rec_.charge_type)) != 'PROMOTION') THEN
         Error_SYS.Record_General(lu_name_, 'INVCHARGE2: Charge type :P1 on target site :P2 is not of charge type category promotion.', rec_.charge_type, contract_);
      END IF;
   END LOOP;
END Check_Charge_Type_Exist;


PROCEDURE Copy_Buy_To_Get(
   campaign_id_ IN NUMBER,
   deal_id_     IN NUMBER)
IS
BEGIN
   Sales_Promotion_Deal_Buy_API.Copy_Buy_To_Get(campaign_id_, deal_id_);
END Copy_Buy_To_Get;

-- Calc_Promotion_Prices
-- This is called from sales promotions to calculate prices and discounts.
PROCEDURE Calc_Promotion_Prices (
   value_               IN OUT NUMBER,
   value_incl_tax_      IN OUT NUMBER,
   calc_base_           IN     VARCHAR2,  
   reference_site_      IN     VARCHAR2,
   fee_code_            IN     VARCHAR2,
   ifs_curr_rounding_   IN     NUMBER )
IS
   tax_percentage_ NUMBER;
BEGIN
   tax_percentage_ := Statutory_Fee_API.Get_Fee_Rate(Site_API.Get_Company(reference_site_), fee_code_);
   Tax_Handling_Util_API.Calculate_Prices(value_, 
                                          value_incl_tax_, 
                                          calc_base_, 
                                          tax_percentage_, 
                                          ifs_curr_rounding_);     
END Calc_Promotion_Prices;

