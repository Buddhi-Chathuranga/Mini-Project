-----------------------------------------------------------------------------
--
--  Logical unit: SalesCostUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140710  AndDse  PRMF-591, Modified Get_Cost_Incl_Sales_Overhead to consider different Part Cost Level types.
--  130709  MaRalk  TIBE-1019, Removed unused global LU constant inst_StandardCostBucket_.
--  130508  KiSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  111207  MaMalk  Modified method Get_Sales_Overhead_Cost___ and Get_Cost_Incl_Sales_Overhead in order to
--  111207          add pragma for method Get_Cost_Incl_Sales_Overhead.
--  100514  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  070417  NiDalk  Corrected method name in General_SYS.Init_Method in Modify_Cost_Incl_Sales_Oh.
--  070417          and added General_SYS.Init_Method to Get_Cost_Incl_Sales_Overhead.
--  070102  RaKalk  Correct to name of the method Modify_Cost_Incl_Sales_Oh
--  070102          Added sales_qty_ parameter to Get_Cost_Incl_Sales_Overhead method
--  061226  RaKalk  Added Method Get_Sales_Overhead_Cost___
--  061226          Modified Modify_Cost_Cost_Incl_Sales_Oh and Get_Cost_Incl_Sales_Overhead
--  061226          to use the new method to fetch the sales overhead cost from costing module.
--  061219  RaKalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_If_Sales_Oh_Required___ (
   contract_          IN VARCHAR2,
   charged_item_      IN VARCHAR2,
   order_supply_type_ IN VARCHAR2,
   customer_no_       IN VARCHAR2,
   part_ownership_    IN VARCHAR2 ) RETURN BOOLEAN
IS
   acquisition_site_    VARCHAR2(10);
BEGIN
   IF (charged_item_ != 'CHARGED ITEM') THEN
      RETURN FALSE;
   END IF;

   IF (order_supply_type_ = 'NO') THEN
      RETURN FALSE;
   END IF;

   acquisition_site_ := Cust_Ord_Customer_API.Get_Acquisition_Site(customer_no_);

   IF (acquisition_site_ IS NOT NULL) THEN
      IF (Site_API.Get_Company(contract_) = Site_API.Get_Company(acquisition_site_)) THEN
         RETURN FALSE;
      END IF;
   END IF;

   IF (part_ownership_ IN ('CUSTOMER OWNED','SUPPLIER LOANED')) THEN
      RETURN FALSE;
   END IF;

   RETURN TRUE;
END Check_If_Sales_Oh_Required___;


-- Get_Sales_Overhead_Cost___
--   Invoke the Standard_Cost_Bocket_API.Get_Sales_Overhead_Cost dynamicaly
PROCEDURE Get_Sales_Overhead_Cost___ (
   cost_             OUT NUMBER,
   contract_         IN  VARCHAR2,
   part_no_          IN  VARCHAR2,
   actual_unit_cost_ IN  NUMBER,
   sales_qty_        IN  NUMBER,
   net_weight_       IN  NUMBER )
IS
BEGIN
   $IF Component_Cost_SYS.INSTALLED $THEN
       Standard_Cost_Bucket_API.Get_Sales_Overhead_Cost(cost_,
                                                        contract_,
                                                        part_no_,
                                                        actual_unit_cost_,
                                                        sales_qty_,
                                                        net_weight_);
   $ELSE
      cost_ := 0;
   $END
END Get_Sales_Overhead_Cost___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Cost_Incl_Sales_Overhead (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   configuration_id_  IN VARCHAR2,
   condition_code_    IN VARCHAR2,
   sales_qty_         IN NUMBER,
   charged_item_      IN VARCHAR2,
   order_supply_type_ IN VARCHAR2,
   customer_no_       IN VARCHAR2,
   part_ownership_    IN VARCHAR2 ) RETURN NUMBER
IS
   part_cost_                 NUMBER;
   sales_overhead_required_   BOOLEAN;
   sales_overhead_cost_       NUMBER;
   net_weight_                NUMBER;
   part_cost_level_           VARCHAR2(50);
BEGIN
   part_cost_level_ := Inventory_Part_API.Get_Inventory_Part_Cost_Lev_Db(contract_, part_no_);
   
   IF (part_cost_level_ = Inventory_Part_Cost_Level_API.DB_COST_PER_CONFIGURATION AND configuration_id_ = '*') THEN
      part_cost_ := 0;
      sales_overhead_required_ := FALSE;
   ELSE
      part_cost_ := Inventory_Part_Cost_API.Get_Cost(contract_,
                                                     part_no_,
                                                     configuration_id_,
                                                     condition_code_);
      IF (part_cost_ = 0 AND part_cost_level_ != Inventory_Part_Cost_Level_API.DB_COST_PER_PART) THEN
         sales_overhead_required_ := FALSE;
      ELSE
         sales_overhead_required_ := Check_If_Sales_Oh_Required___(contract_,
                                                                   charged_item_,
                                                                   order_supply_type_,
                                                                   customer_no_,
                                                                   part_ownership_);
      END IF;
   END IF;
   
   IF (sales_overhead_required_) THEN
      net_weight_ := Inventory_Part_API.Get_Weight_Net(contract_,part_no_);

      Get_Sales_Overhead_Cost___(sales_overhead_cost_,
                                 contract_,
                                 part_no_,
                                 part_cost_,
                                 sales_qty_,
                                 net_weight_);

      part_cost_ := part_cost_ + NVL(sales_overhead_cost_,0);
   END IF;

   RETURN part_cost_;
END Get_Cost_Incl_Sales_Overhead;



PROCEDURE Modify_Cost_Incl_Sales_Oh (
   identity_no_    IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,
   cost_           IN NUMBER,
   source_         IN VARCHAR2 )
IS
   cost_incl_sales_oh_  NUMBER;

   contract_          Customer_Order_Line_Tab.contract%TYPE;
   part_no_           Customer_Order_Line_Tab.part_no%TYPE;
   charged_item_      Customer_Order_Line_Tab.charged_item%TYPE;
   order_supply_type_ Customer_Order_Line_Tab.demand_code%TYPE;
   customer_no_       Customer_Order_Line_Tab.customer_no%TYPE;
   part_ownership_    Customer_Order_Line_Tab.part_ownership%TYPE;

   quotation_line_rec_  Order_Quotation_Line_API.Public_Rec;
   order_line_rec_      Customer_Order_Line_API.Public_Rec;

   sales_overhead_required_   BOOLEAN;
   sales_overhead_cost_       NUMBER;
   sales_qty_                 NUMBER;
   net_weight_                NUMBER;
BEGIN

   cost_incl_sales_oh_ := cost_;

   IF (source_ = 'ORDER') THEN

      order_line_rec_ := Customer_Order_Line_API.Get(identity_no_,
                                                     line_no_,
                                                     rel_no_,
                                                     line_item_no_);

      contract_            := order_line_rec_.contract;
      part_no_             := order_line_rec_.part_no;
      charged_item_        := order_line_rec_.charged_item;
      order_supply_type_   := order_line_rec_.demand_code;
      customer_no_         := order_line_rec_.customer_no;
      part_ownership_      := order_line_rec_.part_ownership;
      sales_qty_           := order_line_rec_.buy_qty_due;
   ELSIF (source_ = 'QUOTATION') THEN

      quotation_line_rec_ := Order_Quotation_Line_API.Get(identity_no_,
                                                          line_no_,
                                                          rel_no_,
                                                          line_item_no_);

      contract_            := quotation_line_rec_.contract;
      part_no_             := quotation_line_rec_.part_no;
      charged_item_        := quotation_line_rec_.charged_item;
      order_supply_type_   := quotation_line_rec_.order_supply_type;
      customer_no_         := quotation_line_rec_.customer_no;
      part_ownership_      := NULL;
      sales_qty_           := quotation_line_rec_.buy_qty_due;
   END IF;

   sales_overhead_required_ := Check_If_Sales_Oh_Required___(contract_,
                                                             charged_item_,
                                                             order_supply_type_,
                                                             customer_no_,
                                                             part_ownership_);

   IF (sales_overhead_required_) THEN
      net_weight_ := Inventory_Part_API.Get_Weight_Net(contract_,part_no_);

      Get_Sales_Overhead_Cost___(sales_overhead_cost_,
                                 contract_,
                                 part_no_,
                                 cost_,
                                 sales_qty_,
                                 net_weight_);

      cost_incl_sales_oh_ := cost_incl_sales_oh_ + NVL(sales_overhead_cost_,0);
   END IF;

   IF (source_ = 'ORDER') THEN
      Customer_Order_Line_API.Modify_Cost(identity_no_,
                                          line_no_,
                                          rel_no_,
                                          line_item_no_,
                                          cost_incl_sales_oh_);
   ELSIF (source_ = 'QUOTATION') THEN
      Order_Quotation_Line_API.Modify_Cost(identity_no_,
                                           line_no_,
                                           rel_no_,
                                           line_item_no_,
                                           cost_incl_sales_oh_);
   END IF;
END Modify_Cost_Incl_Sales_Oh;



