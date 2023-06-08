-----------------------------------------------------------------------------
--
--  Logical unit: CampaignPart
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210108  RavDlk  SC2020R1-11995, Modified Update_Purch_Part_Supplier___ by removing unnecessary packing and unpacking of attrubute string
--  131030  MaMalk  Made net_price mandatory.
--  130703  AwWelk  TIBE-946, Removed global variable inst_PurchasePartSupplier_, inst_PurchasePart_ and introduced 
--  130703          conditional compilation.
--  130212  HimRlk  Changed sales_price_incl_tax as mandatory.
--  120125  ChJalk  Modified the base view to correct the view comments for sales_price.
--  111118  Gannlk  Modified the method Validate_Part_Lines___ to avoid minus values for sales price and purchase price.
--  111116  ChJalk  Modified the view CAMPAIGN_PART to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111021  ChJalk  Modified the base view CAMPAIGN_PART to use the user allowed company filter.
--  100819  NaLrlk  Modified the method Update_Purch_Part_Supplier___.
--  100721  NaLrlk  Modified the method Validate_Part_Lines___.
--  100421  NaLrlk  Modified the method Validate_Part_Lines___.
--  100419  NaLrlk  Added new column purchase_currency_code.
--  091228  MaHplk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE part_rec IS RECORD
   (catalog_no CAMPAIGN_PART_TAB.CATALOG_NO%TYPE);

TYPE part_table IS TABLE OF part_rec;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Part_Lines___ (
   newrec_ IN OUT CAMPAIGN_PART_TAB%ROWTYPE,
   insert_ IN BOOLEAN DEFAULT TRUE )
IS
BEGIN

   IF (newrec_.sales_discount IS NOT NULL AND newrec_.discount_type IS NULL)THEN
      Error_SYS.Record_General(lu_name_, 'NODISCTYPE: IF a sales discount is used, a discount type must be specified.');
   END IF;
   IF (newrec_.sales_discount IS NULL AND newrec_.discount_type IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NODISCPERCENTAGE: You must specify a discount percentage when using a discount type.');
   END IF;
   IF (newrec_.sales_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'SAL_PRICE_LESS_THAN_ZERO: Sales price must be greater than zero.');
   END IF;  
   IF (newrec_.purchase_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'PUR_PRICE_LESS_THAN_ZERO: Purchase price must be greater than zero.');
   END IF;

   IF (newrec_.purchase_part_no IS NOT NULL) THEN
      IF (newrec_.supplier_id IS NULL) AND (newrec_.purchase_discount IS NOT NULL OR newrec_.purchase_price IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOSUPPDEFINE: There exists no supplier defined for the purchase part :P1.', newrec_.purchase_part_no);
      ELSIF (newrec_.purchase_discount IS NOT NULL AND newrec_.purchase_price IS NULL) THEN
         -- For the new record, update a purchase price from primary supplier on supply site.
         -- Otherwise raise the error message.
         IF (insert_) THEN
            $IF (Component_Purch_SYS.INSTALLED) $THEN 
               newrec_.purchase_price := Purchase_Part_Supplier_API.Get_List_Price(newrec_.supply_contract, newrec_.purchase_part_no, newrec_.supplier_id);
            $ELSE 
               NULL;
            $END
         ELSE
            Error_SYS.Record_General(lu_name_, 'PURCHPRICENEEDED: IF a purchase discount is used, a purchase price must be specified.');
         END IF;
      END IF;
   END IF;
END Validate_Part_Lines___;


PROCEDURE Update_Purch_Part_Supplier___ (
   campaign_id_     IN NUMBER )
IS
   supply_contract_     CAMPAIGN_PART_TAB.supply_contract%TYPE; 
   purchase_part_no_    CAMPAIGN_PART_TAB.purchase_part_no%TYPE;
   supplier_id_         CAMPAIGN_PART_TAB.supplier_id%TYPE;
   purchase_currency_code_ CAMPAIGN_PART_TAB.purchase_currency_code%TYPE;
   purchase_part_exist_ NUMBER;
   newrec_              CAMPAIGN_PART_TAB%ROWTYPE;
   sales_part_rec_      Sales_Part_API.Public_Rec;

   CURSOR get_lines IS
      SELECT contract, catalog_no, supply_contract
      FROM CAMPAIGN_PART_TAB
      WHERE campaign_id = campaign_id_;
BEGIN

   supply_contract_ := Campaign_API.Get_Supply_Site(campaign_id_);
   FOR line_rec_ in get_lines LOOP
      IF (line_rec_.supply_contract IS NULL) THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN 
            purchase_part_no_       := NULL;
            purchase_currency_code_ := NULL;
            supplier_id_            := NULL;
            sales_part_rec_         := Sales_Part_API.Get(line_rec_.contract, line_rec_.catalog_no);
            IF (sales_part_rec_.part_no IS NOT NULL) THEN
               purchase_part_no_  := Inventory_Part_API.Check_If_Purchased(supply_contract_, sales_part_rec_.part_no);
            ELSIF (sales_part_rec_.catalog_type = 'NON') THEN     
               purchase_part_exist_ := Purchase_Part_API.Check_Exist(supply_contract_, sales_part_rec_.purchase_part_no);       
               IF (purchase_part_exist_ = 1) THEN
                  purchase_part_no_ := sales_part_rec_.purchase_part_no;
               END IF;
            END IF;
            IF (purchase_part_no_ IS NOT NULL) THEN
               supplier_id_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(supply_contract_, purchase_part_no_);
               IF (supplier_id_ IS NOT NULL) THEN 
                  purchase_currency_code_ := Purchase_Part_Supplier_API.Get_Currency_Code(supply_contract_, purchase_part_no_, supplier_id_);
               END IF;
            END IF;
            newrec_ := Get_Object_By_Keys___(campaign_id_,line_rec_.contract, line_rec_.catalog_no);
            newrec_.supply_contract        := supply_contract_;
            newrec_.purchase_part_no       := purchase_part_no_;
            newrec_.supplier_id            := supplier_id_;
            newrec_.purchase_currency_code := purchase_currency_code_;
            Modify___(newrec_);
         $ELSE
            NULL;
         $END 
      END IF;
   END LOOP;
END Update_Purch_Part_Supplier___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('NET_PRICE_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT campaign_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   
   Validate_Part_Lines___(newrec_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     campaign_part_tab%ROWTYPE,
   newrec_ IN OUT campaign_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Validate_Part_Lines___(newrec_, FALSE);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   campaign_id_ IN NUMBER,
   contract_    IN VARCHAR2,
   catalog_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Check_Exist___(campaign_id_, contract_, catalog_no_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


@UncheckedAccess
FUNCTION Get_Connected_Parts (
   campaign_id_ IN NUMBER ) RETURN part_table
IS
   CURSOR get_parts IS
      SELECT catalog_no
      FROM   CAMPAIGN_PART_TAB
      WHERE  campaign_id = campaign_id_;

   parts_tab_     part_table;
BEGIN
   OPEN get_parts;
   FETCH get_parts BULK COLLECT INTO parts_tab_;
   CLOSE get_parts;
   RETURN parts_tab_;
END Get_Connected_Parts;


PROCEDURE Update_Purch_Part_Supplier (
   campaign_id_     IN NUMBER )
IS
BEGIN
   Update_Purch_Part_Supplier___(campaign_id_);
END Update_Purch_Part_Supplier;



