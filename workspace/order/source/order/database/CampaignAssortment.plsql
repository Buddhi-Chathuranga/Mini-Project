-----------------------------------------------------------------------------
--
--  Logical unit: CampaignAssortment
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130330  MaMalk  Made net_price mandatory and increased the length of discount_type to STRING(30).
--  111130  GanNlk  Modified the method Validate_Assort_Lines___ to avoid minus values for purchase price.
--  111118  GanNlk  Modified the method Validate_Assort_Lines___ to avoid minus values for sales price.
--  111116  ChJalk  Modified the view CAMPAIGN_ASSORTMENT to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111026  ChJalk  Modified the base view CAMPAIGN_ASSORTMENT to use the user allowed company filter.
--  100820  NaLrlk  Removed column purchase_price_incl_tax and sales_price_incl_tax.
--  100723  NaLrlk  Added function Check_Exist.
--  100721  NaLrlk  Modified the method Validate_Assort_Lines___.
--  100713  Chfolk  Modified Prepare_Insert___ to remove adding values for BONUS_VALUE_DB and BONUS_BASIS_DB as bonus functionality is obsoleted.
--  091228  MaHplk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Assort_Lines___ (
   newrec_ IN CAMPAIGN_ASSORTMENT_TAB%ROWTYPE )
IS
BEGIN
   IF (Assortment_Node_API.Get_Part_No(newrec_.assortment_id, newrec_.assortment_node_id) IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOTVALIDPARTNODE: The node entered is a part node in the assortment structure. Part nodes are not allowed on the Assortment tab.');
      
   END IF;
   IF (newrec_.sales_price IS NULL AND newrec_.discount_type IS NULL ) THEN
      Error_SYS.Record_General(lu_name_, 'NODISCANDSALEPRICE: Enter either the sales price or the discount type.');
   END IF;
   IF (newrec_.sales_discount IS NOT NULL AND newrec_.discount_type IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NODISCTYPE: IF a sales discount is used, a discount type must be specified.');
   END IF;
   IF (newrec_.sales_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'SAL_PRICE_LESS_THAN_ZERO: Sales price must be greater than zero.');
   END IF;
   IF (newrec_.purchase_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'PUR_PRICE_LESS_THAN_ZERO: Purchase price must be greater than zero');
   END IF;
END Validate_Assort_Lines___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('NET_PRICE_DB', 'FALSE', attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     campaign_assortment_tab%ROWTYPE,
   newrec_ IN OUT campaign_assortment_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Validate_Assort_Lines___(newrec_);
END Check_Common___;



@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT campaign_assortment_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   IF (newrec_.sales_discount IS NOT NULL AND newrec_.discount_type IS NULL)THEN
      Error_SYS.Check_Not_Null(lu_name_, 'DISCOUNT_TYPE', newrec_.discount_type);
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Get_Discount_Node (
   assortment_node_ OUT VARCHAR2,
   assortment_id_   IN  VARCHAR2,
   campaign_id_     IN  NUMBER,
   part_no_         IN  VARCHAR2,
	price_unit_meas_ IN  VARCHAR2 )
IS
   -- For performance reasons take an Active Assortment Structure.
   CURSOR get_node_in_campaign IS
          SELECT t.assortment_node_id
          FROM assortment_node_tab t
          WHERE EXISTS (SELECT 1 FROM campaign_assortment_tab et
                                 WHERE et.assortment_id = t.assortment_id
                                 AND et.assortment_node_id = t.assortment_node_id
                                 AND et.campaign_id = campaign_id_
                                 AND et.sales_price IS NULL
											AND et.price_unit_meas = price_unit_meas_
                                 AND et.sales_discount IS NOT NULL
                        )
          START WITH        t.assortment_id = assortment_id_
                 AND        t.assortment_node_id = part_no_
          CONNECT BY PRIOR  t.assortment_id = t.assortment_id
                 AND PRIOR  t.parent_node = t.assortment_node_id;
BEGIN
   FOR rec_ IN get_node_in_campaign LOOP
      IF (rec_.assortment_node_id IS NOT NULL) THEN
         assortment_node_ := rec_.assortment_node_id;
         EXIT;
      END IF;
   END LOOP;
END Get_Discount_Node;


-- Check_Exist
--   Public interface for checking if campaign assortment exist.
--   Returns 1 for true and 0 for false
@UncheckedAccess
FUNCTION Check_Exist (
   campaign_id_        IN NUMBER,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   price_unit_meas_    IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(campaign_id_, assortment_id_, assortment_node_id_, price_unit_meas_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_Exist;



