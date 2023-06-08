-----------------------------------------------------------------------------
--
--  Logical unit: SalesPromotionUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170722  MaEelk  SCUXXW4-20211, Cursor written in Check_Promo_Exist_For_Ord_Line was broken into 2 inorder to improve performance.
--  190722  BudKlk  Bug 148970 (SCZ-5620), Modified the methods Calculate_Order_Charges___() and  Calculate_Quote_Charges___() to round the values of the charge_price_ and charge_price_incl_tax_.
--  190722          Get the customer order currency rounding in order to to the correction.
--  170125  slkapl  FINHR-5388, Implement Tax Structures in Sales Promotions
--  160314  IsSalk  FINHR-686, Moved server logic of QuoteLineTaxLines to Source Tax Item Order.
--  160215  IsSalk  FINHR-722, Renamed attribute FEE_CODE to TAX_CODE in ORDER_QUOTATION_LINE_TAB.
--  151103  IsSalk  FINHR-316, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Line.
--  150629  Vwloza  RED-480, Excluded rentals from Calculate_Quote_Deal_Buy___(), Calculate_Quote_Deal_Buy___().
--  120818  JeeJlk  Bug 123949, Modified cursors, get_campaigns_for_quote, get_price_grp_camp_for_quote and get_possible_quote_lines in method Calculate_Quote_Deal_Buy___  
--  120818          to set price effective date to wanted delivery date when pricing method is DELIVERY_DATE.
--  150207  HimRlk  PRSC-5217, Modified Calculate_Quote_Charges___() to consider currency rate.
--  150102  SlKapl  PRFI-4296, Added new parameter of method call Cust_Ord_Charge_Tax_Lines_API.New
--  130301  HimRlk  Modified Calculate_Order_Deal_Get___ to consider value of use_price_incl_tax when fetching net_amount.
--  120228  HimRlk  Modified Calculate_Order_Charges___ to set prices incl tax values.
--  130228  JeeJlk  Modifed Calculate_Quote_Charges___ to set prices incl tax values.
--  130325  NaLrlk  Modified Calculate_Order_Deal_Buy___, Calculate_Order_Deal_Get___ to exclude rental lines.
--  120706  RuLiLk  Bug 103857, Modified ORDER BY clause in several cursors by adding Priority.
--  120215  DaZase  Removed methods Set_Unutilized_Deal_Order___/Set_Unutilized_Deal_Quote___ since they are now obsolete, this is now handled inside Calculate_Order_Deal_Buy___/Calculate_Order_Deal_Get___/Calculate_Order_Charges___ and the similar methods for quotation.
--  120209  DaZase  Added extra checks in cursor get_deals in method Get_Possible_Sales_Promo_Deal, to avoid notying user about possible deal when this deal already have been utilized in a sales promotion calculation earlier.
--  120130  DaZase  Added 'sum_price_qty_ > 0' check in the times_ordered evaluation in methods Calculate_Order_Deal_Get___/Calculate_Quote_Deal_Get___. 
--  120127  DaZase  Changed SYSDATE to site_date in pricing_method statements and for DATE ENTERED in charges creation.
--  120126  DaZase  Added method Get_Possible_Sales_Promo_Deal, coded it so it will work for both order and quotation.
--  111219  DaZase  Removed obsolete methods Clear_Calc_Data_If_No_Charge/Clear_Calc_Data_If_No_Qcharge.
--  111216  DaZase  Added methods Set_Unutilized_Deal_Order___/Set_Unutilized_Deal_Quote___ to handle unutilized_deal checkbox.
--  111214  DaZase  Removed check for least_times_deal_fulfilled >= 1 in cursor get_fulfilled_deals in methods Calculate_Order_Deal_Get___/Calculate_Quote_Deal_Get___ 
--  111214          because we now have clients to investigate sales promotions and its now better to show all lines even those that are not fulfilled completely.
--  111214  DaZase  Removed calls to Clear_Calc_Data_If_No_Charge because we now have clients to investigate sales promotions and its now better to show lines that didnt result in a charge.
--  110929  MaMalk  Added the condition for the part_ownership of CO Lines to consider only Company Owned lines
--  110929          when doing calculations for sales promotions.
--  110927  MatKse  Modified cursors get_campaigns_for_quote, get_price_grp_camp_for_quote in Calculate_Quote_Deal_Buy___ 
--                  and cursor get_possible_quote_lines in both Calculate_Quote_Deal_Buy___ and Calculate_Quote_Deal_Get___
--                  to use TRUNC(SYSDATE) when price_effectivity_date is NULL. 
--  110328  RiLase  Corrected charge calculation for order and quotation when useing gross amount in sales promotion deal.
--  110317  MatKse  Modified how tax amount was calculated when new tax lines where created in method Calculate_Order_Changes___
--  110103  ChFolk  Modified cursor get_possible_quote_lines in Calculate_Quote_Deal_Get___ to avoid calculating sales promotion for zero qty lines.
--  101223  ChFolk  Added Added methods Check_Promo_Exist_Ord_Line_Num and Check_Promo_Exist_Quo_Line_Num which returns number type for Check_Promo_Exist_For_Ord_Line
--  101223          and Check_Promo_Exist_For_Quo_Line respectively.
--  101216  NaLrlk  Added methods Clear_Order_Promotion___, Calculate_Order_Deal_Buy___, Calculate_Order_Deal_Get___, Calculate_Order_Charges___, 
--  101216          Create_Promo_Deal_Quote___, Clear_Quote_Promotion___, Calculate_Quote_Deal_Buy___, Calculate_Quote_Deal_Get___, Check_Promo_Exist_For_Quo_Line
--  101216          Calculate_Quote_Charges___, Calculate_Order_Promotion, Calculate_Quote_Promotion, Clear_Order_Promotion, Clear_Quote_Promotion 
--  101216          Clear_Calc_Data_If_No_Charge and Clear_Calc_Data_If_No_Qcharge. Removed methods Calculate_Sales_Promotion, Check_And_Remove_Old_Data,  
--  101216          Calculate_Sales_Promotion, Check_And_Calculate_Deal_Buy, Check_And_Calculate_Deal_Get, Create_And_Calculate_Charges and Remove_Calc_Data_If_No_Charge.
--  101116  NaLrlk  Added mathod Create_Promo_Deal_Order___ and modified method Check_And_Calculate_Deal_Buy for campaign 
--  101116          customer hierarchy and customer price group/hierarchy.
--  100830  RiLase  Added parental_fee_code to view reference_tax_lines and to charge tax lines creation in Create_And_Calculate_Charges.
--  100712  NaLrlk  Modified methods Check_And_Calculate_Deal_Buy, Check_And_Calculate_Deal_Get and Create_And_Calculate_Charges.
--  100701  ChFolk  Modified Create_And_Calculate_Charges to change the parameters of method call Cust_Ord_Charge_Tax_Lines_API.New.
--  100416  DaZase  Added method Remove_Calc_Data_If_No_Charge.
--  091208  RiLase  Added validation for tax lines in Check_And_Calculate_Deal_Buy and Check_And_Calculate_Deal_Get. Added method Tax_Lines_Match___.
--  091021  RiLase  Added filter in Check_And_Calculate_Deal... to only include rows with charged item checked and exchange item not checked.
--  090924  MiKulk  Modified the methods Create_And_Calculate_Charges, Check_And_Calculate_Deal_Get 
--  090924          and Check_And_Calculate_Deal_Buy to change the algorithm for calculating sales promotions
--  090924          when the part selection is overlapping on different deals.
--  090917  MiKulk  Modified the method Check_And_Remove_Old_Data with correct value comparision.
--  090820  HimRlk  Modified Create_And_Calculate_Charges() to assign TRUE to server_data_change when creating or modifying a customer order charge record.
--  0906xx  DaZase  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Create_Promo_Deal_Order___ (
   priority_    IN OUT NUMBER,
   campaign_id_ IN     NUMBER,
   order_no_    IN     VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR get_deals_for_campaign IS  
      SELECT deal_id
        FROM sales_promotion_deal_tab
       WHERE campaign_id = campaign_id_
       ORDER BY deal_id;

   CURSOR promo_order_exist IS
      SELECT 1
        FROM promo_deal_order_tab
       WHERE campaign_id = campaign_id_
         AND order_no = order_no_;
BEGIN

   OPEN promo_order_exist;
   FETCH promo_order_exist INTO dummy_;
   IF (promo_order_exist%NOTFOUND) THEN
      FOR deal_rec_ IN get_deals_for_campaign LOOP
         priority_ := priority_ + 1;
         Promo_Deal_Order_API.New(campaign_id_, 
                                  deal_rec_.deal_id, 
                                  order_no_,   
                                  priority_);
      END LOOP;
   END IF;
   CLOSE promo_order_exist;
END Create_Promo_Deal_Order___;


PROCEDURE Clear_Order_Promotion___ (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   -- Clear all deal orders.
   Promo_Deal_Order_API.Delete_Promo_Deal_For_Order(order_no_);
   -- Clear all buy deal orders.
   Promo_Deal_Buy_Order_API.Delete_Promo_Buy_For_Order(order_no_);
   -- Clear all buy deal order lines.
   Promo_Deal_Buy_Order_Line_API.Delete_Promo_Buy_Ln_For_Order(order_no_);
   -- Clear all get deal orders.
   Promo_Deal_Get_Order_API.Delete_Promo_Get_For_Order(order_no_);
   -- Clear all get deal order lines.
   Promo_Deal_Get_Order_Line_API.Delete_Promo_Get_Ln_For_Order(order_no_);
   -- Clear all customer order promotion charges.
   Customer_Order_Charge_Util_API.Remove_Order_Promo_Charges(order_no_);
END Clear_Order_Promotion___;


PROCEDURE Calculate_Order_Deal_Buy___ (
   order_no_ IN VARCHAR2 )
IS
   ordrec_                        Customer_Order_API.Public_Rec;
   prnt_cust_                     CUST_HIERARCHY_STRUCT_TAB.customer_parent%TYPE;
   hierarchy_id_                  CUST_HIERARCHY_STRUCT_TAB.hierarchy_id%TYPE;
   pricing_method_                VARCHAR2(20);
   contract_                      VARCHAR2(5);
   currency_code_                 VARCHAR2(3);
   cust_price_group_id_           VARCHAR2(10);
   prnt_cust_price_group_id_      VARCHAR2(10);
   old_uom_                       VARCHAR2(30);
   deal_buy_cond_order_uom_       VARCHAR2(30);
   matching_tax_lines_            BOOLEAN;
   same_uom_                      BOOLEAN;
   sum_net_amount_                NUMBER;
   sum_gross_amount_              NUMBER;
   sum_price_qty_                 NUMBER;
   buy_condition_fulfilled_       NUMBER;
   net_amount_                    NUMBER;
   gross_amount_                  NUMBER;
   least_times_buy_fulfilled_     NUMBER;
   max_least_times_buy_fulfilled_ NUMBER := 999999999999999999999;
   old_line_no_                   NUMBER;
   old_rel_no_                    NUMBER;
   priority_                      NUMBER;
   site_date_                     DATE;
   unutilized_deal_               VARCHAR2(5);
   company_                       VARCHAR2(20);

   -- changes in this cursor where statements could also affect cursor get_campaigns in method Get_Possible_Sales_Promo_Deal
   CURSOR get_campaigns_for_order(customer_no_ IN VARCHAR2, valid_for_all_customers_ IN VARCHAR2) IS
      SELECT campaign_id 
        FROM campaign_tab c
       WHERE rowstate = 'Active'
         AND currency_code = currency_code_
         AND (customer_no_ IN (SELECT customer_no                             
                                 FROM campaign_customer_tab
                                WHERE campaign_id = c.campaign_id) 
              OR (valid_for_all_customers_ = 'TRUE' AND c.valid_for_all_customers = valid_for_all_customers_))
         AND EXISTS (SELECT 1                             
                       FROM campaign_site_tab
                      WHERE campaign_id = c.campaign_id
                        AND contract = contract_)
         AND EXISTS (SELECT 1
                       FROM sales_promotion_deal_tab
                      WHERE campaign_id = c.campaign_id)
         AND EXISTS (SELECT 1
                       FROM customer_order_line_tab
                      WHERE DECODE(pricing_method_, 'SYSTEM_DATE', TRUNC(site_date_), price_effectivity_date) BETWEEN 
                            c.sales_start AND c.sales_end
                        AND order_no = order_no_)
         ORDER BY c.priority, campaign_id DESC;
   
   CURSOR get_price_grp_camp_for_order(cust_price_group_id_ IN VARCHAR2) IS
      SELECT campaign_id 
        FROM campaign_tab c
       WHERE rowstate = 'Active'
         AND currency_code = currency_code_
         AND (cust_price_group_id_ IN (SELECT cust_price_group_id                             
                                         FROM campaign_cust_price_group_tab
                                        WHERE campaign_id = c.campaign_id))
         AND EXISTS (SELECT 1                             
                       FROM campaign_site_tab
                      WHERE campaign_id = c.campaign_id
                        AND contract = contract_)
         AND EXISTS (SELECT 1
                       FROM sales_promotion_deal_tab
                      WHERE campaign_id = c.campaign_id)
         AND EXISTS (SELECT 1
                       FROM customer_order_line_tab
                      WHERE DECODE(pricing_method_, 'SYSTEM_DATE', TRUNC(site_date_), price_effectivity_date) BETWEEN 
                            c.sales_start AND c.sales_end
                        AND order_no = order_no_)
         ORDER BY c.priority, campaign_id DESC;


   CURSOR get_campaigns_from_deal_order IS
      SELECT pdo.campaign_id, pdo.deal_id, c.sales_start, c.sales_end
        FROM promo_deal_order_tab pdo, campaign_tab c 
       WHERE pdo.order_no = order_no_
         AND pdo.campaign_id = c.campaign_id
       ORDER BY pdo.priority;

   CURSOR get_buy_conditions_for_deal(campaign_id_ IN NUMBER, deal_id_ IN NUMBER) IS
      SELECT buy_id, catalog_no, assortment_id, assortment_node_id, min_qty, min_gross_amount, min_net_amount, price_unit_meas
        FROM sales_promotion_deal_buy_tab
       WHERE campaign_id = campaign_id_
         AND deal_id = deal_id_;

   ---------------------------------------------------------
   -- No component lines selected
   -- Dont include rows with net price checked
   -- Only include rows with charged item checked
   -- Only inlcude rows with exchange unchecked
   -- Only include rows with self billing unchecked
   -- Any changes to this cursor where statements could also affect method Customer_Order_Line_API.Get_Possible_Sales_Promo_Deal
   ---------------------------------------------------------
   CURSOR get_possible_order_lines(sales_start_ IN DATE, sales_end_ IN DATE) IS
      SELECT line_no, rel_no, line_item_no, catalog_no, tax_code, price_unit_meas, buy_qty_due * price_conv_factor price_qty
        FROM customer_order_line_tab
       WHERE order_no = order_no_
         AND line_item_no <= 0
         AND rowstate NOT IN ('Cancelled','Invoiced')
         AND price_source_net_price = 'FALSE'
         AND charged_item = 'CHARGED ITEM'
         AND exchange_item = 'ITEM NOT EXCHANGED'
         AND self_billing = 'NOT SELF BILLING'
         AND DECODE(pricing_method_, 'SYSTEM_DATE', TRUNC(site_date_), price_effectivity_date) BETWEEN sales_start_ AND sales_end_
         AND part_ownership = 'COMPANY OWNED'
         AND rental = Fnd_Boolean_API.DB_FALSE;
BEGIN

   ordrec_ := Customer_Order_API.Get(order_no_);
   contract_       := ordrec_.contract;
   site_date_      := Site_API.Get_Site_Date(contract_);
   currency_code_  := ordrec_.currency_code;
   pricing_method_ := Cust_Order_Pricing_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Pricing_Method(contract_));
   hierarchy_id_   := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(ordrec_.customer_no);
   company_        := Site_API.Get_Company(contract_);

   -- Get all possible campaigns without checking if any order lines 
   -- have the correct deal buy conditions.
   priority_ := 0;
   --------------------------------------------------------------------------------
   -- 1. Insert the possible campaigns connected to the given order header customer
   --------------------------------------------------------------------------------
   FOR camprec_ IN get_campaigns_for_order(ordrec_.customer_no, 'TRUE') LOOP
      Create_Promo_Deal_Order___(priority_, camprec_.campaign_id, order_no_);
   END LOOP;

   ---------------------------------------------------------------------------------
   -- 2. Insert the possible campaigns connected to a customer in customer hierarchy
   ---------------------------------------------------------------------------------
   IF (hierarchy_id_ IS NOT NULL) THEN
      prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, ordrec_.customer_no);
      -- Loop through the hierarchy
      WHILE (prnt_cust_ IS NOT NULL) LOOP
         -- Note: The cursor get_campaigns_for_order in the above which select campaigns for given customer and valid for all customer as well.
         -- Therefore campaigns for the hierarchy level customers dont need to select valid for all customers again.
         FOR camprec_ IN get_campaigns_for_order(prnt_cust_, 'FALSE') LOOP
            Create_Promo_Deal_Order___(priority_, camprec_.campaign_id, order_no_ );
         END LOOP;
         -- prnt_cust_ for next iteration of loop
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
      END LOOP;
   END IF;

   -------------------------------------------------------------------------------------------------------
   -- 3. Insert the possible campaigns connected to the customer price group of the order header customer.
   -------------------------------------------------------------------------------------------------------
   cust_price_group_id_ := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(ordrec_.customer_no);
   IF (cust_price_group_id_ IS NOT NULL) THEN
      FOR camprec_ IN get_price_grp_camp_for_order(cust_price_group_id_) LOOP
         Create_Promo_Deal_Order___(priority_, camprec_.campaign_id, order_no_ );
      END LOOP;
   END IF;

   --------------------------------------------------------------------------------------------------------------
   -- 4. Insert the possible campaigns connected to the customer price group of a customer in customer hierarchy.
   --------------------------------------------------------------------------------------------------------------
   IF (hierarchy_id_ IS NOT NULL) THEN
      prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, ordrec_.customer_no);
      WHILE (prnt_cust_ IS NOT NULL) LOOP
         prnt_cust_price_group_id_ := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(prnt_cust_);
         IF (prnt_cust_price_group_id_ IS NOT NULL) THEN
            FOR camprec_ IN get_price_grp_camp_for_order(prnt_cust_price_group_id_) LOOP
               Create_Promo_Deal_Order___(priority_, camprec_.campaign_id, order_no_);
            END LOOP;
         END IF;
         -- prnt_cust_ for next iteration of loop
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
      END LOOP;
   END IF;

   -- Get all campaigns and deals that are possible for this order
   FOR camprec_ IN get_campaigns_from_deal_order LOOP
      least_times_buy_fulfilled_ := max_least_times_buy_fulfilled_;
      matching_tax_lines_ := TRUE;
      old_line_no_        := NULL;
      old_rel_no_         := NULL;
      unutilized_deal_    := 'FALSE';

      Trace_SYS.Field('campaign_id : ',camprec_.campaign_id);
      Trace_SYS.Field('deal_id : ',camprec_.deal_id);
            
      -- Fetch all possible buy conditions for the current deal/campaign
      FOR buycondrec_ IN get_buy_conditions_for_deal(camprec_.campaign_id, camprec_.deal_id) LOOP 
         Trace_SYS.Field('buy_id : ', buycondrec_.buy_id);
         -- Store new record in Promo_Deal_Buy_Order
         Promo_Deal_Buy_Order_API.New(camprec_.campaign_id, 
                                      camprec_.deal_id, 
                                      buycondrec_.buy_id, 
                                      order_no_);

         -- Clear the amounts/qty sums and the uom is the same flag (to true)
         same_uom_         := TRUE;
         old_uom_          := NULL;
         sum_net_amount_   := 0;
         sum_gross_amount_ := 0;
         sum_price_qty_    := 0;
         buy_condition_fulfilled_ := 0;

         -- Fetch all possible order lines and evaluate them
         FOR ordlinerec_ IN get_possible_order_lines(camprec_.sales_start, camprec_.sales_end) LOOP
            Trace_SYS.Field('line_no : ',ordlinerec_.line_no);
            -- Evaluate current order line and current condition
            IF (ordlinerec_.catalog_no = buycondrec_.catalog_no OR Assortment_Node_API.Is_Part_Belongs_To_Node(buycondrec_.assortment_id, buycondrec_.assortment_node_id,ordlinerec_.catalog_no) <> 0) AND    
               (ordlinerec_.price_unit_meas = NVL(buycondrec_.price_unit_meas, ordlinerec_.price_unit_meas)) THEN
               
               unutilized_deal_ := 'TRUE';
               net_amount_   := Customer_Order_Line_API.Get_Sale_Price_Total(order_no_, ordlinerec_.line_no, ordlinerec_.rel_no, ordlinerec_.line_item_no);
               gross_amount_ := net_amount_ + Customer_Order_Line_API.Get_Total_Tax_Amount_Curr(order_no_, ordlinerec_.line_no, ordlinerec_.rel_no, ordlinerec_.line_item_no);
               
               -- Store new record in Promo_Deal_Buy_Order_Line table
               Promo_Deal_Buy_Order_Line_API.New(camprec_.campaign_id,  camprec_.deal_id,   buycondrec_.buy_id, order_no_,
                                                 ordlinerec_.line_no,   ordlinerec_.rel_no, ordlinerec_.line_item_no,
                                                 net_amount_,           gross_amount_,      ordlinerec_.price_qty,
                                                 ordlinerec_.price_unit_meas);
               -- Sum the amounts and qty
               sum_net_amount_   := sum_net_amount_ + net_amount_;
               sum_gross_amount_ := sum_gross_amount_ + gross_amount_;
               sum_price_qty_ := sum_price_qty_ + ordlinerec_.price_qty;
               -- Check if uom is the same as the old one, set the flag to false if its not the same
               IF (ordlinerec_.price_unit_meas != NVL(old_uom_,ordlinerec_.price_unit_meas)) THEN
                  same_uom_ := FALSE;
               END IF;
               old_uom_ := ordlinerec_.price_unit_meas;
               
               -- Check if the tax lines for current customer order line matches the reference tax lines.
               IF (old_line_no_ IS NOT NULL AND old_rel_no_ IS NOT NULL) THEN
                  matching_tax_lines_ := Source_Tax_Item_Order_API.Tax_Lines_Match(company_, Tax_Source_API.DB_CUSTOMER_ORDER_LINE, order_no_, old_line_no_, old_rel_no_, ordlinerec_.line_no, ordlinerec_.rel_no);
               ELSE
                  old_line_no_ := ordlinerec_.line_no;
                  old_rel_no_  := ordlinerec_.rel_no;
               END IF;
            END IF;
            EXIT WHEN matching_tax_lines_ = FALSE;
         END LOOP;

         IF (matching_tax_lines_) THEN
            IF (same_uom_) THEN
               deal_buy_cond_order_uom_ := old_uom_;
            ELSE
               deal_buy_cond_order_uom_ := NULL;
            END IF;
   
            -- No of times the condition is fulfilled
            IF (buycondrec_.min_qty IS NOT NULL AND buycondrec_.price_unit_meas = old_uom_) THEN
               buy_condition_fulfilled_ := sum_price_qty_/buycondrec_.min_qty;
            ELSIF (buycondrec_.min_gross_amount IS NOT NULL) THEN
               buy_condition_fulfilled_ := sum_gross_amount_ / buycondrec_.min_gross_amount;
            ELSIF (buycondrec_.min_net_amount IS NOT NULL) THEN
               buy_condition_fulfilled_ := sum_net_amount_ / buycondrec_.min_net_amount;
            END IF;
   
            Promo_Deal_Buy_Order_API.Modify(camprec_.campaign_id, camprec_.deal_id,         buycondrec_.buy_id, 
                                            order_no_,            sum_net_amount_,          sum_gross_amount_, 
                                            sum_price_qty_,       deal_buy_cond_order_uom_, buy_condition_fulfilled_);
   
            IF (buy_condition_fulfilled_ >= 0 AND buy_condition_fulfilled_ < least_times_buy_fulfilled_) THEN
               least_times_buy_fulfilled_ := buy_condition_fulfilled_; 
            END IF;
         ELSE
            -- When not the same tax code, then this deal is invalid, remove all records in Promo_Deal_Buy_Order_Line
            Promo_Deal_Buy_Order_Line_API.Remove_All_Lines_For_Deal(camprec_.campaign_id, camprec_.deal_id);
         END IF;
      END LOOP;

      IF (matching_tax_lines_) THEN
         -- Dont set least_times_buy_fulfilled_ if we didnt find any candidates
         IF (least_times_buy_fulfilled_ <> max_least_times_buy_fulfilled_) THEN
            Promo_Deal_Order_API.Modify(camprec_.campaign_id, camprec_.deal_id, order_no_, least_times_buy_fulfilled_, NULL, unutilized_deal_);
         END IF;
      END IF;
   END LOOP;
END Calculate_Order_Deal_Buy___;


PROCEDURE Calculate_Order_Deal_Get___ (
   order_no_ IN VARCHAR2 )
IS
   ordrec_                       Customer_Order_API.Public_Rec;
   pricing_method_               VARCHAR2(20);
   least_times_ordered_          NUMBER;
   max_least_times_ordered_      NUMBER := 999999999999999999999;
   matching_tax_lines_           BOOLEAN;
   same_uom_                     BOOLEAN;
   old_uom_                      VARCHAR2(30);
   sum_net_amount_               NUMBER;
   sum_gross_amount_             NUMBER;
   sum_price_qty_                NUMBER;
   times_ordered_                NUMBER;
   net_amount_                   NUMBER;
   gross_amount_                 NUMBER;
   deal_get_condition_order_uom_ NUMBER;
   net_price_                    NUMBER;
   gross_price_                  NUMBER;
   spdgrec_                      Sales_Promotion_Deal_Get_API.Public_Rec;
   old_line_no_                  NUMBER;
   old_rel_no_                   NUMBER;
   site_date_                    DATE;
   unutilized_deal_              VARCHAR2(5);
   tax_percentage_               NUMBER;
   company_                      VARCHAR2(20);

   --------------------------------------------------
   -- No component lines selected.
   -- Dont include rows with net price checked.
   -- Only include rows with charged item checked.
   -- Only inlcude rows with exchange unchecked.
   -- Only include rows with self billing unchecked.
   -- Any changes to this cursor where statements could also affect method Customer_Order_Line_API.Get_Possible_Sales_Promo_Deal
   --------------------------------------------------
   CURSOR get_possible_order_lines(sales_start_ IN DATE, sales_end_ IN DATE) IS
      SELECT line_no, rel_no, line_item_no, catalog_no, tax_code, price_unit_meas, buy_qty_due * price_conv_factor price_qty
      FROM customer_order_line_tab
      WHERE order_no = order_no_
      AND line_item_no <= 0              
      AND rowstate NOT IN ('Cancelled','Invoiced')
      AND price_source_net_price = 'FALSE'
      AND charged_item = 'CHARGED ITEM'
      AND exchange_item = 'ITEM NOT EXCHANGED'
      AND self_billing = 'NOT SELF BILLING'
      AND DECODE(pricing_method_, 'SYSTEM_DATE', TRUNC(site_date_), price_effectivity_date) BETWEEN sales_start_ AND sales_end_
      AND part_ownership = 'COMPANY OWNED'
      AND rental = Fnd_Boolean_API.DB_FALSE;

   CURSOR get_fulfilled_deals IS
      SELECT campaign_id, deal_id, unutilized_deal
      FROM promo_deal_order_tab  
      WHERE order_no = order_no_
      ORDER BY priority;

   CURSOR fetch_get_conditions_for_deal(campaign_id_ IN NUMBER, deal_id_ IN NUMBER) IS
      SELECT get_id
      FROM sales_promotion_deal_get_tab
      WHERE campaign_id = campaign_id_
      AND deal_id = deal_id_;


   CURSOR fetch_get_data_for_this_deal(campaign_id_ IN NUMBER, deal_id_ IN NUMBER) IS
      SELECT pdgo.get_id, spdg.catalog_no, spdg.assortment_id, spdg.assortment_node_id, spdg.price_unit_meas, c.sales_start, c.sales_end
      FROM promo_deal_get_order_tab pdgo, campaign_tab c, sales_promotion_deal_get_tab spdg
      WHERE pdgo.get_id = spdg.get_id
      AND pdgo.deal_id = spdg.deal_id
      AND pdgo.campaign_id = spdg.campaign_id
      AND pdgo.order_no = order_no_
      AND pdgo.campaign_id = campaign_id_
      AND pdgo.deal_id = deal_id_
      AND pdgo.campaign_id = c.campaign_id
      ORDER BY pdgo.get_id;
      
BEGIN

   ordrec_ := Customer_Order_API.Get(order_no_);
   site_date_      := Site_API.Get_Site_Date(ordrec_.contract);
   company_        := Site_API.Get_Company(ordrec_.contract);
   pricing_method_ := Cust_Order_Pricing_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Pricing_Method(ordrec_.contract));
   FOR dealrec_ IN get_fulfilled_deals LOOP
      FOR cond_rec_ IN fetch_get_conditions_for_deal(dealrec_.campaign_id, dealrec_.deal_id) LOOP
         Promo_Deal_Get_Order_API.New(dealrec_.campaign_id, 
                                      dealrec_.deal_id, 
                                      cond_rec_.get_id, 
                                      order_no_);  
      END LOOP;

      least_times_ordered_ := max_least_times_ordered_;
      matching_tax_lines_ := TRUE;
      old_line_no_     := NULL;
      old_rel_no_      := NULL;
      unutilized_deal_ := dealrec_.unutilized_deal;

      FOR getcondrec_ IN fetch_get_data_for_this_deal(dealrec_.campaign_id, dealrec_.deal_id) LOOP
         Trace_SYS.Field('get_id : ',getcondrec_.get_id);
         -- Clear the amounts/qty sums and the uom is the same flag (to true)
         same_uom_ := TRUE;
         old_uom_ := NULL;
         sum_net_amount_   := 0;
         sum_gross_amount_ := 0;
         sum_price_qty_ := 0;
         times_ordered_ := 0;

         FOR ordlinerec_ IN get_possible_order_lines(getcondrec_.sales_start, getcondrec_.sales_end) LOOP
            IF (ordlinerec_.price_qty != 0) THEN
               -- evaluate current order line and current get condition
               IF (ordlinerec_.catalog_no = getcondrec_.catalog_no OR Assortment_Node_API.Is_Part_Belongs_To_Node(getcondrec_.assortment_id, getcondrec_.assortment_node_id,ordlinerec_.catalog_no) <> 0) AND                    -- 5.1.1 assortments how?
                  (ordlinerec_.price_unit_meas = NVL(getcondrec_.price_unit_meas, ordlinerec_.price_unit_meas)) THEN
                     
                  IF (ordrec_.use_price_incl_tax = 'TRUE') THEN
                     tax_percentage_ := Source_Tax_Item_API.Get_Total_Tax_Percentage(company_, Tax_Source_API.DB_CUSTOMER_ORDER_LINE, order_no_, 
                                                                                     ordlinerec_.line_no, ordlinerec_.rel_no, TO_CHAR(ordlinerec_.line_item_no), '*');
                     
                     net_amount_ :=  Customer_Order_Line_API.Get_Sale_Price_Excl_Tax_Total(order_no_, ordlinerec_.line_no, ordlinerec_.rel_no, ordlinerec_.line_item_no, tax_percentage_);
                  ELSE
                     net_amount_   := Customer_Order_Line_API.Get_Sale_Price_Total(order_no_, ordlinerec_.line_no, ordlinerec_.rel_no, ordlinerec_.line_item_no);
                  END IF;
                                       
                  gross_amount_ := net_amount_ + Customer_Order_Line_API.Get_Total_Tax_Amount_Curr(order_no_, ordlinerec_.line_no, ordlinerec_.rel_no, ordlinerec_.line_item_no);
                  net_price_    := net_amount_ / ordlinerec_.price_qty;
                  gross_price_  := gross_amount_ / ordlinerec_.price_qty;
                  unutilized_deal_ := 'TRUE';
   
                  -- Create a new deal_utilization_no equals 0 record
                  Promo_Deal_Get_Order_Line_API.New(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, order_no_,
                                                  ordlinerec_.line_no, ordlinerec_.rel_no, ordlinerec_.line_item_no, 0,
                                                    net_amount_, gross_amount_, ordlinerec_.price_qty, 
                                                    ordlinerec_.price_unit_meas, net_price_, gross_price_);
   
                  -- sum the amounts and qty
                  sum_net_amount_   := sum_net_amount_ + net_amount_;
                  sum_gross_amount_ := sum_gross_amount_ + gross_amount_;
                  sum_price_qty_ := sum_price_qty_ + ordlinerec_.price_qty;
                  -- check if uom is the same as the old one, set the flag to false if its not the same
                  IF (ordlinerec_.price_unit_meas = NVL(old_uom_,ordlinerec_.price_unit_meas)) THEN
                     same_uom_ := FALSE;
                  END IF;
                  old_uom_ := ordlinerec_.price_unit_meas;
   
                  -- Check if the tax lines for current customer order line matches the reference tax lines.
                  IF (old_line_no_ IS NOT NULL AND old_rel_no_ IS NOT NULL) THEN
                     matching_tax_lines_ := Source_Tax_Item_Order_API.Tax_Lines_Match(company_, Tax_Source_API.DB_CUSTOMER_ORDER_LINE, order_no_, old_line_no_, old_rel_no_, ordlinerec_.line_no, ordlinerec_.rel_no);
                  ELSE
                     old_line_no_       := ordlinerec_.line_no;
                     old_rel_no_        := ordlinerec_.rel_no;
                  END IF;
               END IF;
            END IF;
            EXIT WHEN matching_tax_lines_ = FALSE;
         END LOOP;

         IF (matching_tax_lines_) THEN
            IF (same_uom_) THEN                                  -- 5.2 uom check
               deal_get_condition_order_uom_ := old_uom_;
            ELSE
               deal_get_condition_order_uom_ := NULL;
            END IF;
   
            spdgrec_ := Sales_Promotion_Deal_Get_API.Get(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id);
            -- times_ordered evaluation  -- 5.3
            IF (sum_price_qty_ > 0 AND spdgrec_.qty IS NULL AND spdgrec_.price_unit_meas IS NULL AND spdgrec_.net_amount IS NULL AND spdgrec_.gross_amount IS NULL) THEN
               times_ordered_ := 1;
            ELSIF (spdgrec_.qty IS NULL AND spdgrec_.price_unit_meas IS NOT NULL AND spdgrec_.net_amount IS NULL AND spdgrec_.gross_amount IS NULL) THEN
               times_ordered_ := sum_price_qty_;
            ELSIF (spdgrec_.qty IS NOT NULL AND spdgrec_.price_unit_meas IS NOT NULL AND spdgrec_.net_amount IS NULL AND spdgrec_.gross_amount IS NULL) THEN
               times_ordered_ := sum_price_qty_ / spdgrec_.qty;
            ELSIF (spdgrec_.qty IS NULL AND spdgrec_.net_amount IS NOT NULL AND spdgrec_.gross_amount IS NULL) THEN
               times_ordered_ := sum_net_amount_ / spdgrec_.net_amount;
            ELSIF (spdgrec_.qty IS NULL AND spdgrec_.net_amount IS NULL AND spdgrec_.gross_amount IS NOT NULL) THEN
               times_ordered_ := sum_gross_amount_ / spdgrec_.gross_amount;
            ELSE
               times_ordered_ := 0;
            END IF;
   
            Promo_Deal_Get_Order_API.Modify(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, order_no_, 
                                            sum_net_amount_, sum_gross_amount_, sum_price_qty_, deal_get_condition_order_uom_, times_ordered_);
   
            IF (times_ordered_ >= 0 AND times_ordered_ < least_times_ordered_) THEN
               least_times_ordered_ := times_ordered_;
            END IF;
         ELSE   
            -- Not the same tax code 
            Trace_SYS.Message('not same tax code remove all get order lines ');
            -- not the same tax code, then this deal is invalid, remove all records in Deal_Condition_Order_Line
            Promo_Deal_Get_Order_Line_API.Remove_All_Lines_For_Deal(dealrec_.campaign_id, dealrec_.deal_id);
         END IF;   
      END LOOP;

      IF (matching_tax_lines_) THEN
         -- Dont set least_times_ordered_ if we didnt find any candidates
         IF (least_times_ordered_ <> max_least_times_ordered_) THEN
            Promo_Deal_Order_API.Modify(dealrec_.campaign_id, dealrec_.deal_id, order_no_, NULL, least_times_ordered_, unutilized_deal_);
         END IF;
      END IF;
   END LOOP;
END Calculate_Order_Deal_Get___;


PROCEDURE Calculate_Order_Charges___ (
   order_no_ IN VARCHAR2 )
IS
   deal_utilization_no_           NUMBER := 1;
   spgetcondrec_                  Sales_Promotion_Deal_Get_API.Public_Rec;
   spdrec_                        Sales_Promotion_Deal_API.Public_Rec;
   ordlinerec_                    Customer_Order_Line_API.Public_Rec;
   chargetyperec_                 Sales_Charge_Type_API.Public_Rec;
   order_line_price_qty_          NUMBER;
   rest_qty_                      NUMBER;
   old_qty_                       NUMBER;
   charge_price_                  NUMBER;
   base_charge_price_             NUMBER;   
   charge_sequence_no_            NUMBER;
   info_                          VARCHAR2(2000);
   attr_                          VARCHAR2(2000);
   ordrec_                        Customer_Order_API.Public_Rec;
   order_line_net_amount_         NUMBER;
   rest_net_amount_               NUMBER;
   price_qty_for_utilization_no_  NUMBER;
   previous_get_id_               NUMBER;
   rest_flag_                     BOOLEAN;
   qty_to_save_                   NUMBER;
   qty_not_yet_consumed_          NUMBER;
   net_amount_to_save_            NUMBER;
   net_amount_not_yet_consumed_   NUMBER;
   rest_gross_amount_             NUMBER;
   gross_amount_to_save_          NUMBER;
   gross_amount_not_yet_consumed_ NUMBER;
   order_line_gross_amount_       NUMBER;
   line_no_                       VARCHAR2(4);
   rel_no_                        VARCHAR2(4);
   line_item_no_                  NUMBER;
   old_deal_id_                   NUMBER;
   old_campaign_id_               NUMBER;
   utilization_flag_              BOOLEAN := TRUE;
   charge_price_incl_tax_         NUMBER;
   base_charge_price_incl_tax_    NUMBER;   
   use_price_incl_tax_            VARCHAR2(20);
   rounding_                      NUMBER;
   company_                       VARCHAR2(20);
   currency_rate_                 NUMBER;
   curr_rounding_                 NUMBER;

   CURSOR get_all_possible_deals IS 
      SELECT campaign_id, deal_id, TRUNC(LEAST(least_times_deal_fulfilled, least_times_deal_ordered)) least_deal_utilization_no          
      FROM promo_deal_order_tab
      WHERE order_no = order_no_
      AND least_times_deal_fulfilled >= 1
      AND least_times_deal_ordered >= 1
      ORDER BY priority;

   CURSOR not_consumed_get_cond_ordline(campaign_id_ IN NUMBER, deal_id_ IN NUMBER) IS
      SELECT get_id, net_amount/price_qty price, order_no, line_no, rel_no, line_item_no, net_amount, 
             gross_amount, price_qty, price_unit_meas, price_excl_tax, price_incl_tax 
      FROM promo_deal_get_order_line_tab
      WHERE order_no = order_no_
      AND campaign_id = campaign_id_
      AND deal_id = deal_id_
      AND deal_utilization_no = 0        -- the not fully consumed qty is saved in the deal_utilization_no 0 record
      AND price_qty > 0   -- not fully consumed and to avoid divisor 0
      AND net_amount > 0
      AND gross_amount > 0
      ORDER BY get_id, price, line_no, rel_no;

   CURSOR consumed_get_cond_ordline(campaign_id_ IN NUMBER, deal_id_ IN NUMBER) IS
      SELECT deal_utilization_no, SUM(net_amount) net_amount, SUM(gross_amount) gross_amount
      FROM promo_deal_get_order_line_tab
      WHERE order_no = order_no_
      AND campaign_id = campaign_id_
      AND deal_id = deal_id_
      AND deal_utilization_no > 0 
      GROUP BY deal_utilization_no;

   -- This cursor will fetch several order lines but we will only take 1 line since this is used in vat calculation
   -- for charges and all order lines for the current deal must have the same tax code for sales promotions to work
   CURSOR get_order_line_keys(campaign_id_ IN NUMBER, deal_id_ IN NUMBER, deal_utilization_no_ IN NUMBER) IS
      SELECT line_no, rel_no, line_item_no
      FROM promo_deal_get_order_line_tab
      WHERE order_no = order_no_
      AND campaign_id = campaign_id_
      AND deal_id = deal_id_
      AND deal_utilization_no = deal_utilization_no_;


   CURSOR get_deal_ordlines_for_charge(campaign_id_ IN NUMBER, deal_id_ IN NUMBER, deal_utilization_no_ IN NUMBER) IS
      SELECT get_id, line_no, rel_no, line_item_no
      FROM   promo_deal_get_order_line_tab
      WHERE  campaign_id = campaign_id_
      AND    deal_id = deal_id_
      AND    order_no = order_no_
      AND    deal_utilization_no = deal_utilization_no_;
      
   -- This cursor will fetch order lines connected to combination of campaign_ID and deal_ID
   CURSOR ordlines_connected_to_deal(campaign_id_ IN NUMBER, deal_id_ IN NUMBER) IS
      SELECT DISTINCT order_no, line_no, rel_no, line_item_no
      FROM promo_deal_get_order_line_tab
      WHERE campaign_id = campaign_id_
      AND deal_id = deal_id_
      AND order_no = order_no_
      UNION 
      SELECT DISTINCT order_no, line_no, rel_no, line_item_no
      FROM promo_deal_buy_order_line_tab
      WHERE campaign_id = campaign_id_
      AND deal_id = deal_id_
      AND order_no = order_no_;

BEGIN
   use_price_incl_tax_ := Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_);
   -- Calculation loops
   FOR dealrec_ IN get_all_possible_deals LOOP
      Promo_Deal_Order_API.Modify(dealrec_.campaign_id, dealrec_.deal_id, order_no_, NULL, NULL, 'FALSE');
      -- restart the deal_utilization_no if new deal or new campaign
      IF (dealrec_.deal_id != old_deal_id_ AND old_deal_id_ IS NOT NULL AND dealrec_.campaign_id = old_campaign_id_ AND old_campaign_id_ IS NOT NULL) OR 
         (dealrec_.campaign_id != old_campaign_id_ AND old_campaign_id_ IS NOT NULL) THEN
         deal_utilization_no_ := 1;
         
         -- Check if orderlines connected to campaign/deal is part of other campaign/deal that has
         -- generated a sales promotion charge previously.
         utilization_flag_ := TRUE;
         FOR linesrec_ IN ordlines_connected_to_deal(dealrec_.campaign_id,dealrec_.deal_id) LOOP
            IF (Check_Promo_Exist_For_Ord_Line(linesrec_.order_no,linesrec_.line_no,linesrec_.rel_no,linesrec_.line_item_no)) THEN
               utilization_flag_ := FALSE;
            END IF;
         EXIT WHEN utilization_flag_ = FALSE; -- No need for running the loop anymore
         END LOOP;
      END IF;
      
      -- Do not utilize if any order line already part of campaign/deal that has 
      -- generated a sales promotion charge previously.
      IF (utilization_flag_ = TRUE) THEN
         LOOP
            Trace_SYS.Field('deal_utilization_no_ : ', deal_utilization_no_);
            previous_get_id_ := NULL;
            rest_qty_ := 0;
            rest_net_amount_ := 0;
            rest_flag_ := FALSE;
         
            -- Fetch all not fully consumed get conditions per order line records
            FOR getcondrec_ IN not_consumed_get_cond_ordline(dealrec_.campaign_id, dealrec_.deal_id) LOOP
               IF (getcondrec_.get_id = NVL(previous_get_id_, 0) AND rest_flag_ = FALSE) THEN
                  -- do nothing this get id is already consumed for this utilization no
                  -- only handle this record if the previous record for this get id resulted in a rest
                  NULL;
               ELSE -- regular consumation
                  -- fetch the get condition data
                  spgetcondrec_ := Sales_Promotion_Deal_Get_API.Get(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id);
                  spdrec_ := Sales_Promotion_Deal_API.Get(dealrec_.campaign_id, dealrec_.deal_id);
               
                  -- price quantity as the get condition
                  IF (spgetcondrec_.qty IS NOT NULL AND spgetcondrec_.qty > 0) THEN
                  
                     IF (rest_qty_ + getcondrec_.price_qty < spgetcondrec_.qty) THEN
                        -- cannot consume the whole target quantity with this record
                        -- save the whole record 0 qty in a new record and clear the deal_utilization_no 0 record
                        -- save current quantity in our rest qty variable for use by the next order line if they are connected to the same get_id
                        rest_qty_ := rest_qty_ + getcondrec_.price_qty;
                        rest_flag_ := TRUE;
                   
                        Promo_Deal_Get_Order_Line_API.New(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                          getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no, deal_utilization_no_, getcondrec_.net_amount, 
                                                          getcondrec_.gross_amount, getcondrec_.price_qty, getcondrec_.price_unit_meas, NULL, NULL);
                        -- set amounts and qty to zero for the deal_utilization_no 0 record
                        Promo_Deal_Get_Order_Line_API.Modify(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                             getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                             getcondrec_.line_item_no, 0, 0, 0, 0, NULL); 
                        Trace_SYS.Field('new rest_qty_ : ', rest_qty_);
                     ELSE
                        -- consume this record, either the whole or a part of it if we already have a rest qty from a 
                        -- previous order line that was connected to this get_id            
                        qty_to_save_ := spgetcondrec_.qty - NVL(rest_qty_,0);

                        Promo_Deal_Get_Order_Line_API.New(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                          getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no, deal_utilization_no_, getcondrec_.price_excl_tax * qty_to_save_, 
                                                          getcondrec_.price_incl_tax * qty_to_save_, qty_to_save_, getcondrec_.price_unit_meas, NULL, NULL);
                        -- save the not yet consumed qty in the deal utilization no 0 record
                        qty_not_yet_consumed_ := getcondrec_.price_qty - qty_to_save_; 
                        Promo_Deal_Get_Order_Line_API.Modify(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                             getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                             getcondrec_.line_item_no, 0, getcondrec_.price_excl_tax * qty_not_yet_consumed_, 
                                                             getcondrec_.price_incl_tax * qty_not_yet_consumed_, qty_not_yet_consumed_, NULL);
                        -- clear the rest variables
                        rest_flag_ := FALSE;
                        rest_qty_ := 0;
                        Trace_SYS.Field('qty_to_save_ : ', qty_to_save_);
                        Trace_SYS.Field('qty_not_yet_consumed_ : ', qty_not_yet_consumed_);
                     END IF;

                  -- gross amount as the get condition
                  ELSIF (spgetcondrec_.gross_amount IS NOT NULL AND spgetcondrec_.gross_amount > 0) THEN
                  
                     order_line_net_amount_   := Customer_Order_Line_API.Get_Sale_Price_Total(order_no_, 
                                                                                              getcondrec_.line_no, 
                                                                                              getcondrec_.rel_no, 
                                                                                              getcondrec_.line_item_no);
                     order_line_gross_amount_ := order_line_net_amount_ + Customer_Order_Line_API.Get_Total_Tax_Amount_Curr(order_no_,
                                                                                                                              getcondrec_.line_no,
                                                                                                                              getcondrec_.rel_no,
                                                                                                                              getcondrec_.line_item_no);

                     IF (rest_gross_amount_ + getcondrec_.gross_amount < spgetcondrec_.gross_amount) THEN
                        -- cannot consume the whole target gross amount with this record
                        -- save the whole record 0 gross amount in a new record and clear the deal_utilization_no 0 record
                        -- save current gross amount in our rest gross amount base variable for use by the next order line if they are connected to the same get_id
                        rest_gross_amount_ := rest_gross_amount_ + getcondrec_.gross_amount;
                        rest_flag_ := TRUE;
                        Promo_Deal_Get_Order_Line_API.New(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                          getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no, deal_utilization_no_, getcondrec_.net_amount, 
                                                          getcondrec_.gross_amount, getcondrec_.price_qty, getcondrec_.price_unit_meas, NULL, NULL);
                        -- set amounts and qty to zero for the deal_utilization_no 0 record
                        Promo_Deal_Get_Order_Line_API.Modify(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                             getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                             getcondrec_.line_item_no, 0, 0, 0, 0, NULL); 
                        Trace_SYS.Field('new rest_gross_amount_ : ', rest_gross_amount_);
                     ELSE
                        ordlinerec_ := Customer_Order_Line_API.Get(order_no_, getcondrec_.line_no, getcondrec_.rel_no, getcondrec_.line_item_no);
                        order_line_price_qty_  :=  ordlinerec_.buy_qty_due * ordlinerec_.price_conv_factor;
                        -- consume this record, either the whole or a part of it if we already have a rest gross amount from a 
                        -- previous order line that was connected to this get_id            
                        gross_amount_to_save_ := spgetcondrec_.gross_amount - NVL(rest_gross_amount_,0);
                        IF (order_line_gross_amount_ !=0) THEN
                           price_qty_for_utilization_no_ := (gross_amount_to_save_ / order_line_gross_amount_) * order_line_price_qty_;
                        END IF;
                        Promo_Deal_Get_Order_Line_API.New(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                          getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no, deal_utilization_no_, getcondrec_.price_excl_tax * price_qty_for_utilization_no_, 
                                                          gross_amount_to_save_, price_qty_for_utilization_no_, getcondrec_.price_unit_meas, NULL, NULL);
                        -- save the not yet consumed gross amount in the deal utilization no 0 record
                        gross_amount_not_yet_consumed_ := getcondrec_.gross_amount - gross_amount_to_save_;
                        IF (order_line_gross_amount_ != 0) THEN
                           qty_not_yet_consumed_ := (gross_amount_not_yet_consumed_ / order_line_gross_amount_) * order_line_price_qty_;
                        END IF;
                        Promo_Deal_Get_Order_Line_API.Modify(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                             getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                             getcondrec_.line_item_no, 0, getcondrec_.price_excl_tax * qty_not_yet_consumed_, 
                                                             gross_amount_not_yet_consumed_, qty_not_yet_consumed_, NULL);
                     -- clear the rest variables
                     rest_flag_ := FALSE;
                     rest_gross_amount_ := 0;
                  END IF;
               -- net amount as the get condition
               ELSIF (spgetcondrec_.net_amount IS NOT NULL AND spgetcondrec_.net_amount > 0) THEN
                     
                     order_line_net_amount_ := Customer_Order_Line_API.Get_Sale_Price_Total(order_no_, 
                                                                                            getcondrec_.line_no, 
                                                                                            getcondrec_.rel_no, 
                                                                                            getcondrec_.line_item_no);
                     IF (rest_net_amount_ + getcondrec_.net_amount < spgetcondrec_.net_amount) THEN
                        -- cannot consume the whole target net amount with this record
                        -- save the whole record 0 net amount in a new record and clear the deal_utilization_no 0 record
                        -- save current net amount in our rest net amount base variable for use by the next order line if they are connected to the same get_id
                        rest_net_amount_ := rest_net_amount_ + getcondrec_.net_amount;
                        rest_flag_ := TRUE;
                        Promo_Deal_Get_Order_Line_API.New(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                          getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no, deal_utilization_no_, getcondrec_.net_amount, 
                                                          getcondrec_.gross_amount, getcondrec_.price_qty, getcondrec_.price_unit_meas, NULL, NULL);
                        -- set amounts and qty to zero for the deal_utilization_no 0 record
                        Promo_Deal_Get_Order_Line_API.Modify(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                             getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                             getcondrec_.line_item_no, 0, 0, 0, 0, NULL); 
                     ELSE
                        ordlinerec_ := Customer_Order_Line_API.Get(order_no_, getcondrec_.line_no, getcondrec_.rel_no, getcondrec_.line_item_no);
                        order_line_price_qty_  :=  ordlinerec_.buy_qty_due * ordlinerec_.price_conv_factor;
                        -- consume this record, either the whole or a part of it if we already have a rest net amount from a 
                        -- previous order line that was connected to this get_id            
                        net_amount_to_save_ := spgetcondrec_.net_amount - NVL(rest_net_amount_,0);
                        IF (order_line_net_amount_ != 0) THEN
                           price_qty_for_utilization_no_ := (net_amount_to_save_ / order_line_net_amount_) * order_line_price_qty_;
                        END IF;
                        Promo_Deal_Get_Order_Line_API.New(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                          getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no, deal_utilization_no_, net_amount_to_save_, 
                                                          getcondrec_.price_incl_tax * price_qty_for_utilization_no_, price_qty_for_utilization_no_, getcondrec_.price_unit_meas, NULL, NULL);
                        -- save the not yet consumed net amount in the deal utilization no 0 record
                        net_amount_not_yet_consumed_ := getcondrec_.net_amount - net_amount_to_save_; 
                        IF (order_line_net_amount_ != 0) THEN
                           qty_not_yet_consumed_ := (net_amount_not_yet_consumed_ / order_line_net_amount_) * order_line_price_qty_;
                        END IF;
                        Promo_Deal_Get_Order_Line_API.Modify(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                             getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                             getcondrec_.line_item_no, 0, net_amount_not_yet_consumed_, 
                                                             getcondrec_.price_incl_tax * qty_not_yet_consumed_, qty_not_yet_consumed_, NULL);
                        -- Clear the rest variables
                        rest_flag_ := FALSE;
                        rest_net_amount_ := 0;
                     END IF;
                  -- handle cases where you use discount% without any qty/amount on the get condition
                  ELSIF (spgetcondrec_.net_amount IS NULL AND spgetcondrec_.gross_amount IS NULL AND 
                         spgetcondrec_.qty IS NULL AND spdrec_.discount IS NOT NULL) THEN
                     -- this case is simply handled by moving the values from the 0 record to this deal_utilization_no record (which will be 1 since in this case, the times_ordered is always = 1)
                      
                      
                     Promo_Deal_Get_Order_Line_API.New(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                       getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                       getcondrec_.line_item_no, deal_utilization_no_, getcondrec_.net_amount, 
                                                       getcondrec_.gross_amount, getcondrec_.price_qty, getcondrec_.price_unit_meas, NULL, NULL);
                     -- set amounts and qty to zero for the deal_utilization_no 0 record
                     Promo_Deal_Get_Order_Line_API.Modify(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id, 
                                                          getcondrec_.order_no, getcondrec_.line_no, getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no, 0, 0, 0, 0, NULL); 
                     -- set rest flag to TRUE because we could have more lines that should be handled this way if we use discount% only
                     rest_flag_ := TRUE;
                  END IF;
               END IF;

               previous_get_id_ := getcondrec_.get_id; 

            END LOOP;
            
            deal_utilization_no_ := deal_utilization_no_ + 1;
            EXIT WHEN deal_utilization_no_ > dealrec_.least_deal_utilization_no;
         END LOOP;
      END IF;   

      company_ := Site_API.Get_Company(Customer_Order_API.Get_Contract(order_no_));
      rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
      ordrec_        := Customer_Order_API.Get(order_no_);
      curr_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, ordrec_.currency_code);
      -- charge loop
      FOR getcondrec_ IN consumed_get_cond_ordline(dealrec_.campaign_id, dealrec_.deal_id) LOOP
         spdrec_ := Sales_Promotion_Deal_API.Get(dealrec_.campaign_id, 
                                                 dealrec_.deal_id);
         charge_price_ := 0;
         charge_price_incl_tax_ := 0;
         -- fetch order line keys, need to fetch tax code and maybe tax percent, any order line keys for this deal_utilization_no will do since all order lines needs to have the same tax code
         OPEN  get_order_line_keys(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.deal_utilization_no);
         FETCH get_order_line_keys INTO line_no_, rel_no_, line_item_no_;
         CLOSE get_order_line_keys;
         -- Charge Price calculations 
         IF (spdrec_.discount IS NOT NULL) THEN
            -- charge_price_ or charge_price_incl_tax_ will be recalculated in Customer_order_charge_api according to the use_price_incl_tax value
            -- using the tax code in the customer_order_charge line
            charge_price_incl_tax_ := (((spdrec_.discount/100) * getcondrec_.gross_amount) * -1);
            charge_price_ := (((spdrec_.discount/100) * getcondrec_.net_amount) * -1);              
         ELSIF (spdrec_.discount_gross_amount IS NOT NULL OR spdrec_.discount_net_amount IS NOT NULL) THEN
            charge_price_incl_tax_ := spdrec_.discount_gross_amount * -1;
            charge_price_ := spdrec_.discount_net_amount * -1; 
         ELSIF (spdrec_.price_incl_tax IS NOT NULL OR spdrec_.price_excl_tax IS NOT NULL) THEN
            charge_price_incl_tax_ := spdrec_.price_incl_tax - getcondrec_.gross_amount;
            charge_price_ := spdrec_.price_excl_tax  - getcondrec_.net_amount;
         END IF;
         charge_price_incl_tax_ := ROUND(charge_price_incl_tax_, curr_rounding_);
         charge_price_          := ROUND(charge_price_, curr_rounding_);
         
         currency_rate_ := Customer_Order_Line_API.Get_Currency_Rate(order_no_, line_no_, rel_no_, line_item_no_);        
         base_charge_price_incl_tax_ := ROUND(charge_price_incl_tax_ * currency_rate_, rounding_);
         base_charge_price_ := ROUND(charge_price_ * currency_rate_, rounding_);

         IF (charge_price_ < 0 OR charge_price_incl_tax_ <0) THEN
            -- create charge record if the same charge price does not exist before, in other case update the quantity on the existing record with 1
            Client_SYS.Clear_Attr(attr_);
            
            charge_sequence_no_ := NULL;
            charge_sequence_no_ := Customer_Order_Charge_Util_API.Exist_Charge_For_This_Price(order_no_, spdrec_.charge_type, charge_price_, charge_price_incl_tax_, dealrec_.campaign_id, dealrec_.deal_id);
            Trace_SYS.Field('charge_sequence_no_ : ', charge_sequence_no_);               

            IF charge_sequence_no_ IS NOT NULL THEN
               old_qty_ := Customer_Order_Charge_API.Get_Charged_Qty(order_no_, charge_sequence_no_);
               Client_SYS.Add_To_Attr('CHARGED_QTY', old_qty_ + 1, attr_);
               Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 'TRUE',  attr_);
               Customer_Order_Charge_API.Modify(order_no_, charge_sequence_no_, attr_);
            ELSE
               ordlinerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

               -- Fetch all charge default values from the charge type
               chargetyperec_ := Sales_Charge_Type_API.Get(ordrec_.contract, 
                                                           spdrec_.charge_type);
               
               Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);           
               Client_SYS.Add_To_Attr('CONTRACT', ordrec_.contract, attr_);
               Client_SYS.Add_To_Attr('CHARGE_TYPE', spdrec_.charge_type, attr_);
               Client_SYS.Add_To_Attr('SALES_UNIT_MEAS', chargetyperec_.sales_unit_meas, attr_);
               Client_SYS.Add_To_Attr('INVOICED_QTY', 0, attr_);            
               Client_SYS.Add_To_Attr('DATE_ENTERED', Site_API.Get_Site_Date(ordrec_.contract), attr_);
               Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB', chargetyperec_.print_charge_type, attr_);
               Client_SYS.Add_To_Attr('QTY_RETURNED', 0, attr_);
               Client_SYS.Add_To_Attr('CHARGE_COST', 0, attr_);
               Client_SYS.Add_To_Attr('COMPANY', chargetyperec_.company, attr_);
               Client_SYS.Add_To_Attr('PRINT_COLLECT_CHARGE_DB', chargetyperec_.print_collect_charge, attr_);
               Client_SYS.Add_To_Attr('COLLECT_DB', 'INVOICE', attr_);   
               Client_SYS.Add_To_Attr('UNIT_CHARGE_DB', chargetyperec_.unit_charge, attr_);
               Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB',  chargetyperec_.intrastat_exempt, attr_);
               Client_SYS.Add_To_Attr('CHARGED_QTY', 1, attr_);               
               -- tax code from order lines and charge price from previous calculation
               Client_SYS.Add_To_Attr('TAX_CODE', ordlinerec_.tax_code, attr_);
               Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT', base_charge_price_, attr_);            
               Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', base_charge_price_incl_tax_, attr_); 
               Client_SYS.Add_To_Attr('CHARGE_AMOUNT', charge_price_, attr_);
               Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', charge_price_incl_tax_, attr_);
               Client_SYS.Add_To_Attr('CAMPAIGN_ID', dealrec_.campaign_id, attr_);            
               Client_SYS.Add_To_Attr('DEAL_ID', dealrec_.deal_id, attr_);
               Client_SYS.Add_To_Attr('TAX_CLASS_ID', ordlinerec_.tax_class_id, attr_);
               Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 'TRUE',  attr_);
               Client_SYS.Add_To_Attr('TAX_CALC_STRUCTURE_ID', ordlinerec_.tax_calc_structure_id,  attr_);
               IF ordlinerec_.tax_code IS NULL AND ordlinerec_.tax_class_id IS NULL AND ordlinerec_.tax_calc_structure_id IS NULL THEN
                  -- no taxes calculated for the line or multiple tax items - in that case taxes for the charge line will be recalculated below in Customer_Order_Charge_API.Copy_Order_Line_Tax_Lines
                  Client_SYS.Add_To_Attr('FETCH_TAX_CODES', 'FALSE',  attr_);
                  Client_SYS.Add_To_Attr('ADD_TAX_LINES', 'FALSE',  attr_);                  
               END IF;
               Customer_Order_Charge_API.New(info_, attr_);
               charge_sequence_no_ := Client_SYS.Get_Item_Value('SEQUENCE_NO', attr_);
                                                                              
               IF (Source_Tax_Item_API.Multiple_Tax_Items_Exist(company_, Tax_Source_API.DB_CUSTOMER_ORDER_LINE, order_no_, line_no_, rel_no_, line_item_no_, '*') = 'TRUE')
                  AND (Sales_Charge_Type_API.Get_Taxable_Db(ordrec_.contract, spdrec_.charge_type) = Fnd_Boolean_API.DB_TRUE) THEN
                  Customer_Order_Charge_API.Copy_Order_Line_Tax_Lines(company_,
                                                                      order_no_, 
                                                                      line_no_, 
                                                                      rel_no_, 
                                                                      line_item_no_,
                                                                      charge_sequence_no_);
               END IF;
            END IF;
            -- Update the concerned records in Promo_Deal_Get_Order_Line with the charge sequence no
            FOR charge_ordline_rec_ IN get_deal_ordlines_for_charge(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.deal_utilization_no) LOOP
               Promo_Deal_Get_Order_Line_API.Set_Charge_Sequence_No(dealrec_.campaign_id, dealrec_.deal_id, charge_ordline_rec_.get_id,
                                                                    order_no_, charge_ordline_rec_.line_no, charge_ordline_rec_.rel_no, 
                                                                    charge_ordline_rec_.line_item_no, getcondrec_.deal_utilization_no, 
                                                                    charge_sequence_no_); 
            END LOOP;
         END IF;
      END LOOP;
      old_deal_id_ := dealrec_.deal_id;
      old_campaign_id_ := dealrec_.campaign_id;
   END LOOP;

   -- Please note that there are still a lot of problems connected to if you are going to try and 
   -- remove deal/deal_buy/deal_get records from basic data for the sales promotion since there 
   -- could be a lot of records in our sales promotion calculation tables left even if the campaign/deals/buy/get 
   -- didnt result in a promotion charge since another campaign/deal/buy/get could have resultet in 
   -- a promotion charge during this calculation so all possible records are still saved in these 
   -- sales promotion calculation tables.
END Calculate_Order_Charges___;


PROCEDURE Create_Promo_Deal_Quote___ (
   priority_     IN OUT NUMBER,
   campaign_id_  IN     NUMBER,
   quotation_no_ IN     VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR get_deals_for_campaign IS  
      SELECT deal_id
        FROM sales_promotion_deal_tab
       WHERE campaign_id = campaign_id_
       ORDER BY deal_id;

   CURSOR promo_quote_exist IS
      SELECT 1
        FROM promo_deal_quotation_tab
       WHERE campaign_id = campaign_id_
         AND quotation_no = quotation_no_;
BEGIN

   OPEN promo_quote_exist;
   FETCH promo_quote_exist INTO dummy_;
   IF (promo_quote_exist%NOTFOUND) THEN
      FOR deal_rec_ IN get_deals_for_campaign LOOP
         priority_ := priority_ + 1;
         Promo_Deal_Quotation_API.New(campaign_id_,
                                      deal_rec_.deal_id, 
                                      quotation_no_,   
                                      priority_);
      END LOOP;
   END IF;
   CLOSE promo_quote_exist;
END Create_Promo_Deal_Quote___;


PROCEDURE Clear_Quote_Promotion___ (
   quotation_no_ IN VARCHAR2 )
IS
BEGIN
   -- Clear all deal quotations.
   Promo_Deal_Quotation_API.Delete_Promo_Deal_For_Quote(quotation_no_);
   -- Clear all buy deal quotations.
   Promo_Deal_Buy_Quotation_API.Delete_Promo_Buy_For_Quote(quotation_no_);
   -- Clear all buy deal quotation lines.
   Promo_Deal_Buy_Quote_Line_API.Delete_Promo_Buy_Ln_For_Quote(quotation_no_);
   -- Clear all get deal quotations.
   Promo_Deal_Get_Quotation_API.Delete_Promo_Get_For_Quote(quotation_no_);
   -- Clear all get deal quotation lines.
   Promo_Deal_Get_Quote_Line_API.Delete_Promo_Get_Ln_For_Quote(quotation_no_);
   -- Clear all order quotation promotion charges.
   Customer_Order_Charge_Util_API.Remove_Quote_Promo_Charges(quotation_no_);
END Clear_Quote_Promotion___;


PROCEDURE Calculate_Quote_Deal_Buy___ (
   quotation_no_ IN VARCHAR2 )
IS
   quote_rec_                     Order_Quotation_API.Public_Rec;
   prnt_cust_                     CUST_HIERARCHY_STRUCT_TAB.customer_parent%TYPE;
   hierarchy_id_                  CUST_HIERARCHY_STRUCT_TAB.hierarchy_id%TYPE;
   pricing_method_                VARCHAR2(20);
   contract_                      VARCHAR2(5);
   currency_code_                 VARCHAR2(3);
   cust_price_group_id_           VARCHAR2(10);
   prnt_cust_price_group_id_      VARCHAR2(10);
   old_uom_                       VARCHAR2(30);
   deal_buy_cond_quote_uom_       VARCHAR2(30);
   matching_tax_lines_            BOOLEAN;
   same_uom_                      BOOLEAN;
   sum_net_amount_                NUMBER;
   sum_gross_amount_              NUMBER;
   sum_price_qty_                 NUMBER;
   buy_condition_fulfilled_       NUMBER;
   net_amount_                    NUMBER;
   gross_amount_                  NUMBER;
   least_times_buy_fulfilled_     NUMBER;
   max_least_times_buy_fulfilled_ NUMBER := 999999999999999999999;
   old_line_no_                   NUMBER;
   old_rel_no_                    NUMBER;
   priority_                      NUMBER;
   site_date_                     DATE;
   unutilized_deal_               VARCHAR2(5);

   -- changes in this cursor where statements could also affect cursor get_campaigns in method Get_Possible_Sales_Promo_Deal
   CURSOR get_campaigns_for_quote(customer_no_ IN VARCHAR2, valid_for_all_customers_ IN VARCHAR2) IS
      SELECT campaign_id 
        FROM campaign_tab c
       WHERE rowstate = 'Active'
         AND currency_code = currency_code_
         AND (customer_no_ IN (SELECT customer_no                             
                                 FROM campaign_customer_tab
                                WHERE campaign_id = c.campaign_id) 
              OR (valid_for_all_customers_ = 'TRUE' AND c.valid_for_all_customers = valid_for_all_customers_))
         AND EXISTS (SELECT 1                             
                       FROM campaign_site_tab
                      WHERE campaign_id = c.campaign_id
                        AND contract = contract_)
         AND EXISTS (SELECT 1
                       FROM sales_promotion_deal_tab
                      WHERE campaign_id = c.campaign_id)
         AND EXISTS (SELECT 1
                       FROM order_quotation_tab
                      WHERE DECODE(pricing_method_, 'SYSTEM_DATE', TRUNC(site_date_), 'DELIVERY_DATE', NVL(price_effectivity_date, wanted_delivery_date), NVL(price_effectivity_date, TRUNC(site_date_))) BETWEEN 
                            c.sales_start AND c.sales_end
                        AND quotation_no = quotation_no_)
         ORDER BY c.priority, campaign_id DESC;
   
   CURSOR get_price_grp_camp_for_quote(cust_price_group_id_ IN VARCHAR2) IS
      SELECT campaign_id 
        FROM campaign_tab c
       WHERE rowstate = 'Active'
         AND currency_code = currency_code_
         AND (cust_price_group_id_ IN (SELECT cust_price_group_id                             
                                         FROM campaign_cust_price_group_tab
                                        WHERE campaign_id = c.campaign_id))
         AND EXISTS (SELECT 1                             
                       FROM campaign_site_tab
                      WHERE campaign_id = c.campaign_id
                        AND contract = contract_)
         AND EXISTS (SELECT 1
                       FROM sales_promotion_deal_tab
                      WHERE campaign_id = c.campaign_id)
         AND EXISTS (SELECT 1
                       FROM order_quotation_tab
                      WHERE DECODE(pricing_method_, 'SYSTEM_DATE', TRUNC(site_date_), 'DELIVERY_DATE', NVL(price_effectivity_date, wanted_delivery_date), NVL(price_effectivity_date, TRUNC(site_date_))) BETWEEN 
                            c.sales_start AND c.sales_end
                        AND quotation_no = quotation_no_)
         ORDER BY c.priority, campaign_id DESC;


   CURSOR get_campaigns_from_deal_quote IS
      SELECT pdq.campaign_id, pdq.deal_id, c.sales_start, c.sales_end
        FROM promo_deal_quotation_tab pdq, campaign_tab c 
       WHERE pdq.quotation_no = quotation_no_
         AND pdq.campaign_id = c.campaign_id
       ORDER BY pdq.priority;

   CURSOR get_buy_conditions_for_deal(campaign_id_ IN NUMBER, deal_id_ IN NUMBER) IS
      SELECT buy_id, catalog_no, assortment_id, assortment_node_id, min_qty, min_gross_amount, min_net_amount, price_unit_meas
        FROM sales_promotion_deal_buy_tab
       WHERE campaign_id = campaign_id_
         AND deal_id = deal_id_;

   ---------------------------------------------------------
   -- No component lines selected
   -- Dont include rows with net price checked
   -- Only include rows with charged item checked 
   -- Only include rows with self billing unchecked
   -- Any changes to this cursor where statements could also affect method Order_Quotation_Line_API.Get_Possible_Sales_Promo_Deal
   ---------------------------------------------------------
   CURSOR get_possible_quote_lines(sales_start_ IN DATE, sales_end_ IN DATE) IS
      SELECT ql.line_no, ql.rel_no, ql.line_item_no, ql.catalog_no, ql.tax_code, ql.price_unit_meas, ql.buy_qty_due * ql.price_conv_factor price_qty
        FROM order_quotation_line_tab ql, order_quotation_tab q
       WHERE ql.quotation_no = quotation_no_
         AND ql.line_item_no <= 0
         AND ql.rowstate NOT IN ('Cancelled', 'Lost')
         AND ql.price_source_net_price = 'FALSE'
         AND ql.charged_item = 'CHARGED ITEM'
         AND ql.self_billing = 'NOT SELF BILLING'
         AND q.quotation_no = ql.quotation_no
         AND DECODE(pricing_method_, 'SYSTEM_DATE', TRUNC(site_date_), 'DELIVERY_DATE', NVL(q.price_effectivity_date, q.wanted_delivery_date), NVL(q.price_effectivity_date, TRUNC(site_date_))) BETWEEN 
             sales_start_ AND sales_end_
         AND rental = Fnd_Boolean_API.DB_FALSE;
BEGIN
   quote_rec_      := Order_Quotation_API.Get(quotation_no_);
   contract_       := quote_rec_.contract;
   site_date_      := Site_API.Get_Site_Date(contract_);
   currency_code_  := quote_rec_.currency_code;
   pricing_method_ := Cust_Order_Pricing_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Pricing_Method(contract_));
   hierarchy_id_   := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(quote_rec_.customer_no);

   -- Get all possible campaigns without checking if any quotation lines 
   -- have the correct deal buy conditions.
   priority_ := 0;
   --------------------------------------------------------------------------------
   -- 1. Insert the possible campaigns connected to the given quotation header customer
   --------------------------------------------------------------------------------
   FOR camprec_ IN get_campaigns_for_quote(quote_rec_.customer_no, 'TRUE') LOOP
      Create_Promo_Deal_Quote___(priority_, camprec_.campaign_id, quotation_no_);
   END LOOP;

   ---------------------------------------------------------------------------------
   -- 2. Insert the possible campaigns connected to a customer in customer hierarchy
   ---------------------------------------------------------------------------------
   IF (hierarchy_id_ IS NOT NULL) THEN
      prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, quote_rec_.customer_no);
      -- Loop through the hierarchy
      WHILE (prnt_cust_ IS NOT NULL) LOOP
         -- Note: The cursor get_campaigns_for_quote in the above which select campaigns for given customer and valid for all customer as well.
         -- Therefore campaigns for the hierarchy level customers do not need to select valid for all customers again.
         FOR camprec_ IN get_campaigns_for_quote(prnt_cust_, 'FALSE') LOOP
            Create_Promo_Deal_Quote___(priority_, camprec_.campaign_id, quotation_no_ );
         END LOOP;
         -- prnt_cust_ for next iteration of loop
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
      END LOOP;
   END IF;

   -------------------------------------------------------------------------------------------------------
   -- 3. Insert the possible campaigns connected to the customer price group of the quotation header customer.
   -------------------------------------------------------------------------------------------------------
   cust_price_group_id_ := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(quote_rec_.customer_no);
   IF (cust_price_group_id_ IS NOT NULL) THEN
      FOR camprec_ IN get_price_grp_camp_for_quote(cust_price_group_id_) LOOP
         Create_Promo_Deal_Quote___(priority_, camprec_.campaign_id, quotation_no_ );
      END LOOP;
   END IF;

   --------------------------------------------------------------------------------------------------------------
   -- 4. Insert the possible campaigns connected to the customer price group of a customer in customer hierarchy.
   --------------------------------------------------------------------------------------------------------------
   IF (hierarchy_id_ IS NOT NULL) THEN
      prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, quote_rec_.customer_no);
      WHILE (prnt_cust_ IS NOT NULL) LOOP
         prnt_cust_price_group_id_ := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(prnt_cust_);
         IF (prnt_cust_price_group_id_ IS NOT NULL) THEN
            FOR camprec_ IN get_price_grp_camp_for_quote(prnt_cust_price_group_id_) LOOP
               Create_Promo_Deal_Quote___(priority_, camprec_.campaign_id, quotation_no_);
            END LOOP;
         END IF;
         -- prnt_cust_ for next iteration of loop
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
      END LOOP;
   END IF;

   -- Get all campaigns and deals that are possible for this quotation
   FOR camprec_ IN get_campaigns_from_deal_quote LOOP
      least_times_buy_fulfilled_ := max_least_times_buy_fulfilled_;
      matching_tax_lines_ := TRUE;
      old_line_no_        := NULL;
      old_rel_no_         := NULL;
      unutilized_deal_    := 'FALSE';

      Trace_SYS.Field('campaign_id : ',camprec_.campaign_id);
      Trace_SYS.Field('deal_id : ',camprec_.deal_id);
      
      -- Fetch all possible buy conditions for the current deal/campaign
      FOR buycondrec_ IN get_buy_conditions_for_deal(camprec_.campaign_id, camprec_.deal_id) LOOP 
         Trace_SYS.Field('buy_id : ', buycondrec_.buy_id);
         -- Store new record in Promo_Deal_Buy_Quotation
         Promo_Deal_Buy_Quotation_API.New(camprec_.campaign_id, 
                                          camprec_.deal_id, 
                                          buycondrec_.buy_id, 
                                          quotation_no_);

         -- Clear the amounts/qty sums and the uom is the same flag (to true)
         same_uom_         := TRUE;
         old_uom_          := NULL;
         sum_net_amount_   := 0;
         sum_gross_amount_ := 0;
         sum_price_qty_    := 0;
         buy_condition_fulfilled_ := 0;

         -- Fetch all possible quotation lines and evaluate them
         FOR quote_line_rec_ IN get_possible_quote_lines(camprec_.sales_start, camprec_.sales_end) LOOP
            Trace_SYS.Field('line_no : ', quote_line_rec_.line_no);
            -- Evaluate current quotation line and current condition
            IF (quote_line_rec_.catalog_no = buycondrec_.catalog_no OR Assortment_Node_API.Is_Part_Belongs_To_Node(buycondrec_.assortment_id, buycondrec_.assortment_node_id, quote_line_rec_.catalog_no) <> 0) AND    
               (quote_line_rec_.price_unit_meas = NVL(buycondrec_.price_unit_meas, quote_line_rec_.price_unit_meas)) THEN
               
               unutilized_deal_ := 'TRUE';
               net_amount_   := Order_Quotation_Line_API.Get_Sale_Price_Total(quotation_no_, quote_line_rec_.line_no, quote_line_rec_.rel_no, quote_line_rec_.line_item_no);
               gross_amount_ := net_amount_ + Order_Quotation_Line_API.Get_Total_Tax_Amount_Curr(quotation_no_, quote_line_rec_.line_no, quote_line_rec_.rel_no, quote_line_rec_.line_item_no);
               
               -- Store new record in Promo_Deal_Buy_Quote_Line table
               Promo_Deal_Buy_Quote_Line_API.New(camprec_.campaign_id,
                                                 camprec_.deal_id,
                                                 buycondrec_.buy_id,
                                                 quotation_no_,
                                                 quote_line_rec_.line_no,
                                                 quote_line_rec_.rel_no,
                                                 quote_line_rec_.line_item_no,
                                                 net_amount_,
                                                 gross_amount_,
                                                 quote_line_rec_.price_qty,
                                                 quote_line_rec_.price_unit_meas);
               -- Sum the amounts and qty
               sum_net_amount_   := sum_net_amount_ + net_amount_;
               sum_gross_amount_ := sum_gross_amount_ + gross_amount_;
               sum_price_qty_ := sum_price_qty_ + quote_line_rec_.price_qty;
               -- Check if uom is the same as the old one, set the flag to false if its not the same
               IF (quote_line_rec_.price_unit_meas != NVL(old_uom_, quote_line_rec_.price_unit_meas)) THEN
                  same_uom_ := FALSE;
               END IF;
               old_uom_ := quote_line_rec_.price_unit_meas;
               
               -- Check if the tax lines for current quotation line matches the reference tax lines.
               IF (old_line_no_ IS NOT NULL AND old_rel_no_ IS NOT NULL) THEN
                  matching_tax_lines_ := Source_Tax_Item_Order_API.Tax_Lines_Match(quote_rec_.company, Tax_Source_API.DB_ORDER_QUOTATION_LINE, quotation_no_, old_line_no_, old_rel_no_, quote_line_rec_.line_no, quote_line_rec_.rel_no);
               ELSE
                  old_line_no_ := quote_line_rec_.line_no;
                  old_rel_no_  := quote_line_rec_.rel_no;
               END IF;
            END IF;
            EXIT WHEN matching_tax_lines_ = FALSE;
         END LOOP;

         IF (matching_tax_lines_) THEN
            IF (same_uom_) THEN
               deal_buy_cond_quote_uom_ := old_uom_;
            ELSE
               deal_buy_cond_quote_uom_ := NULL;
            END IF;
   
            -- No of times the condition is fulfilled
            IF (buycondrec_.min_qty IS NOT NULL AND buycondrec_.price_unit_meas = old_uom_) THEN
               buy_condition_fulfilled_ := sum_price_qty_/buycondrec_.min_qty;
            ELSIF (buycondrec_.min_gross_amount IS NOT NULL) THEN
               buy_condition_fulfilled_ := sum_gross_amount_ / buycondrec_.min_gross_amount;
            ELSIF (buycondrec_.min_net_amount IS NOT NULL) THEN
               buy_condition_fulfilled_ := sum_net_amount_ / buycondrec_.min_net_amount;
            END IF;
   
            Promo_Deal_Buy_Quotation_API.Modify(camprec_.campaign_id,
                                                camprec_.deal_id,
                                                buycondrec_.buy_id, 
                                                quotation_no_,
                                                sum_net_amount_,
                                                sum_gross_amount_, 
                                                sum_price_qty_,
                                                deal_buy_cond_quote_uom_,
                                                buy_condition_fulfilled_);
   
            IF (buy_condition_fulfilled_ >= 0 AND buy_condition_fulfilled_<least_times_buy_fulfilled_) THEN
               least_times_buy_fulfilled_ := buy_condition_fulfilled_; 
            END IF;
         ELSE
            -- When not the same tax code, then this deal is invalid, remove all records in Promo_Deal_Buy_Quote_Line
            Promo_Deal_Buy_Quote_Line_API.Remove_All_Lines_For_Deal(camprec_.campaign_id, camprec_.deal_id);
         END IF;
      END LOOP;

      IF (matching_tax_lines_) THEN
         -- Dont set least_times_buy_fulfilled_ if we didnt find any candidates
         IF (least_times_buy_fulfilled_ <> max_least_times_buy_fulfilled_) THEN
            Promo_Deal_Quotation_API.Modify(camprec_.campaign_id, camprec_.deal_id, quotation_no_, least_times_buy_fulfilled_, NULL, unutilized_deal_);
         END IF;
      END IF;
   END LOOP;
END Calculate_Quote_Deal_Buy___;


PROCEDURE Calculate_Quote_Deal_Get___ (
   quotation_no_ IN VARCHAR2 )
IS
   quote_rec_                    Order_Quotation_API.Public_Rec;
   pricing_method_               VARCHAR2(20);
   least_times_ordered_          NUMBER;
   max_least_times_ordered_      NUMBER := 999999999999999999999;
   matching_tax_lines_           BOOLEAN;
   same_uom_                     BOOLEAN;
   old_uom_                      VARCHAR2(30);
   sum_net_amount_               NUMBER;
   sum_gross_amount_             NUMBER;
   sum_price_qty_                NUMBER;
   times_ordered_                NUMBER;
   net_amount_                   NUMBER;
   gross_amount_                 NUMBER;
   deal_get_condition_quote_uom_ NUMBER;
   net_price_                    NUMBER;
   gross_price_                  NUMBER;
   spdgrec_                      Sales_Promotion_Deal_Get_API.Public_Rec;
   old_line_no_                  NUMBER;
   old_rel_no_                   NUMBER;
   site_date_                    DATE;
   unutilized_deal_              VARCHAR2(5);

   --------------------------------------------------
   -- No component lines selected.
   -- Dont include rows with net price checked.
   -- Only include rows with charged item checked.
   -- Only include rows with self billing unchecked.
   -- Any changes to this cursor where statements could also affect method Order_Quotation_Line_API.Get_Possible_Sales_Promo_Deal
   --------------------------------------------------
   CURSOR get_possible_quote_lines(sales_start_ IN DATE, sales_end_ IN DATE) IS
      SELECT ql.line_no, ql.rel_no, ql.line_item_no, ql.catalog_no, ql.tax_code, ql.price_unit_meas, ql.buy_qty_due * ql.price_conv_factor price_qty
      FROM order_quotation_line_tab ql, order_quotation_tab q
      WHERE ql.quotation_no = quotation_no_
      AND ql.line_item_no <= 0              
      AND ql.rowstate NOT IN ('Cancelled', 'Lost')
      AND ql.price_source_net_price = 'FALSE'
      AND ql.charged_item = 'CHARGED ITEM'
      AND ql.self_billing = 'NOT SELF BILLING'
      AND ql.quotation_no = q.quotation_no
      AND ql.buy_qty_due > 0
      AND DECODE(pricing_method_, 'SYSTEM_DATE', TRUNC(site_date_), nvl(q.price_effectivity_date,TRUNC(site_date_))) BETWEEN
                 sales_start_ AND sales_end_
      AND rental = Fnd_Boolean_API.DB_FALSE;

   CURSOR get_fulfilled_deals IS
      SELECT campaign_id, deal_id, unutilized_deal
      FROM promo_deal_quotation_tab  
      WHERE quotation_no = quotation_no_
      ORDER BY priority;

   CURSOR fetch_get_conditions_for_deal(campaign_id_ IN NUMBER, deal_id_ IN NUMBER) IS
      SELECT get_id
      FROM sales_promotion_deal_get_tab
      WHERE campaign_id = campaign_id_
      AND deal_id = deal_id_;


   CURSOR fetch_get_data_for_this_deal(campaign_id_ IN NUMBER, deal_id_ IN NUMBER) IS
      SELECT pdgq.get_id, spdg.catalog_no, spdg.assortment_id, spdg.assortment_node_id, spdg.price_unit_meas, c.sales_start, c.sales_end
      FROM promo_deal_get_quotation_tab pdgq, campaign_tab c, sales_promotion_deal_get_tab spdg
      WHERE pdgq.get_id = spdg.get_id
      AND pdgq.deal_id = spdg.deal_id
      AND pdgq.campaign_id = spdg.campaign_id
      AND pdgq.quotation_no = quotation_no_
      AND pdgq.campaign_id = campaign_id_
      AND pdgq.deal_id = deal_id_
      AND pdgq.campaign_id = c.campaign_id
      ORDER BY pdgq.get_id;
BEGIN

   quote_rec_      := Order_Quotation_API.Get(quotation_no_);
   site_date_      := Site_API.Get_Site_Date(quote_rec_.contract);
   pricing_method_ := Cust_Order_Pricing_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Pricing_Method(quote_rec_.contract));
   FOR dealrec_ IN get_fulfilled_deals LOOP
      FOR cond_rec_ IN fetch_get_conditions_for_deal(dealrec_.campaign_id, dealrec_.deal_id) LOOP
         Promo_Deal_Get_Quotation_API.New(dealrec_.campaign_id, 
                                          dealrec_.deal_id, 
                                          cond_rec_.get_id, 
                                          quotation_no_);  
      END LOOP;

      least_times_ordered_ := max_least_times_ordered_;
      matching_tax_lines_ := TRUE;
      old_line_no_     := NULL;
      old_rel_no_      := NULL;
      unutilized_deal_ := dealrec_.unutilized_deal;

      FOR getcondrec_ IN fetch_get_data_for_this_deal(dealrec_.campaign_id, dealrec_.deal_id) LOOP
         Trace_SYS.Field('get_id : ',getcondrec_.get_id);
         -- Clear the amounts/qty sums and the uom is the same flag (to true)
         same_uom_ := TRUE;
         old_uom_ := NULL;
         sum_net_amount_   := 0;
         sum_gross_amount_ := 0;
         sum_price_qty_ := 0;
         times_ordered_ := 0;

         FOR quote_line_rec_ IN get_possible_quote_lines(getcondrec_.sales_start, getcondrec_.sales_end) LOOP
            IF (quote_line_rec_.price_qty != 0) THEN
               -- evaluate current quotation line and current get condition
               IF (quote_line_rec_.catalog_no = getcondrec_.catalog_no OR Assortment_Node_API.Is_Part_Belongs_To_Node(getcondrec_.assortment_id, getcondrec_.assortment_node_id, quote_line_rec_.catalog_no) <> 0) AND                    -- 5.1.1 assortments how?
                  (quote_line_rec_.price_unit_meas = NVL(getcondrec_.price_unit_meas, quote_line_rec_.price_unit_meas)) THEN
                  
                  net_amount_   := Order_Quotation_Line_API.Get_Sale_Price_Total(quotation_no_, quote_line_rec_.line_no, quote_line_rec_.rel_no, quote_line_rec_.line_item_no);
                  gross_amount_ := net_amount_ + Order_Quotation_Line_API.Get_Total_Tax_Amount_Curr(quotation_no_, quote_line_rec_.line_no, quote_line_rec_.rel_no, quote_line_rec_.line_item_no);
                  net_price_    := net_amount_ / quote_line_rec_.price_qty;
                  gross_price_  := gross_amount_ / quote_line_rec_.price_qty;
                  unutilized_deal_ := 'TRUE';
   
                  -- Create a new deal_utilization_no equals 0 record
                  Promo_Deal_Get_Quote_Line_API.New(dealrec_.campaign_id,
                                                    dealrec_.deal_id,
                                                    getcondrec_.get_id,
                                                    quotation_no_,
                                                    quote_line_rec_.line_no,
                                                    quote_line_rec_.rel_no,
                                                    quote_line_rec_.line_item_no,
                                                    0,
                                                    net_amount_,
                                                    gross_amount_,
                                                    quote_line_rec_.price_qty, 
                                                    quote_line_rec_.price_unit_meas,
                                                    net_price_,
                                                    gross_price_);
   
                  -- sum the amounts and qty
                  sum_net_amount_   := sum_net_amount_ + net_amount_;
                  sum_gross_amount_ := sum_gross_amount_ + gross_amount_;
                  sum_price_qty_ := sum_price_qty_ + quote_line_rec_.price_qty;
                  -- check if uom is the same as the old one, set the flag to false if its not the same
                  IF (quote_line_rec_.price_unit_meas = NVL(old_uom_, quote_line_rec_.price_unit_meas)) THEN
                     same_uom_ := FALSE;
                  END IF;
                  old_uom_ := quote_line_rec_.price_unit_meas;
   
                  -- Check if the tax lines for current quotation line matches the reference tax lines.
                  IF (old_line_no_ IS NOT NULL AND old_rel_no_ IS NOT NULL) THEN
                     matching_tax_lines_ := Source_Tax_Item_Order_API.Tax_Lines_Match(quote_rec_.company, Tax_Source_API.DB_ORDER_QUOTATION_LINE, quotation_no_, old_line_no_, old_rel_no_, quote_line_rec_.line_no, quote_line_rec_.rel_no);
                  ELSE
                     old_line_no_       := quote_line_rec_.line_no;
                     old_rel_no_        := quote_line_rec_.rel_no;
                  END IF;
               END IF;
            END IF;
            EXIT WHEN matching_tax_lines_ = FALSE;
         END LOOP;

         IF (matching_tax_lines_) THEN
            IF (same_uom_) THEN
               deal_get_condition_quote_uom_ := old_uom_;
            ELSE
               deal_get_condition_quote_uom_ := NULL;
            END IF;
   
            spdgrec_ := Sales_Promotion_Deal_Get_API.Get(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id);
            -- times_ordered evaluation
            IF (sum_price_qty_ > 0 AND spdgrec_.qty IS NULL AND spdgrec_.price_unit_meas IS NULL AND spdgrec_.net_amount IS NULL AND spdgrec_.gross_amount IS NULL) THEN
               times_ordered_ := 1;
            ELSIF (spdgrec_.qty IS NULL AND spdgrec_.price_unit_meas IS NOT NULL AND spdgrec_.net_amount IS NULL AND spdgrec_.gross_amount IS NULL) THEN
               times_ordered_ := sum_price_qty_;
            ELSIF (spdgrec_.qty IS NOT NULL AND spdgrec_.price_unit_meas IS NOT NULL AND spdgrec_.net_amount IS NULL AND spdgrec_.gross_amount IS NULL) THEN
               times_ordered_ := sum_price_qty_ / spdgrec_.qty;
            ELSIF (spdgrec_.qty IS NULL AND spdgrec_.net_amount IS NOT NULL AND spdgrec_.gross_amount IS NULL) THEN
               times_ordered_ := sum_net_amount_ / spdgrec_.net_amount;
            ELSIF (spdgrec_.qty IS NULL AND spdgrec_.net_amount IS NULL AND spdgrec_.gross_amount IS NOT NULL) THEN
               times_ordered_ := sum_gross_amount_ / spdgrec_.gross_amount;
            ELSE
               times_ordered_ := 0;
            END IF;
   
            Promo_Deal_Get_Quotation_API.Modify(dealrec_.campaign_id,
                                                dealrec_.deal_id,
                                                getcondrec_.get_id,
                                                quotation_no_, 
                                                sum_net_amount_,
                                                sum_gross_amount_,
                                                sum_price_qty_,
                                                deal_get_condition_quote_uom_,
                                                times_ordered_);
   
            IF (times_ordered_ >= 0 AND times_ordered_ < least_times_ordered_) THEN
               least_times_ordered_ := times_ordered_;
            END IF;
         ELSE   
            -- Not the same tax code 
            Trace_SYS.Message('not same tax code remove all get quotation lines ');
            -- not the same tax code, then this deal is invalid, remove all records in Deal_Condition_Quote_Line
            Promo_Deal_Get_Quote_Line_API.Remove_All_Lines_For_Deal(dealrec_.campaign_id, dealrec_.deal_id);
         END IF;   
      END LOOP;

      IF (matching_tax_lines_) THEN
         -- Dont set least_times_ordered_ if we didnt find any candidates
         IF (least_times_ordered_ <> max_least_times_ordered_) THEN
            Promo_Deal_Quotation_API.Modify(dealrec_.campaign_id, dealrec_.deal_id, quotation_no_, NULL, least_times_ordered_, unutilized_deal_);
         END IF;
      END IF;  
   END LOOP;
END Calculate_Quote_Deal_Get___;


PROCEDURE Calculate_Quote_Charges___ (
   quotation_no_ IN VARCHAR2 )
IS
   deal_utilization_no_           NUMBER := 1;
   spgetcondrec_                  Sales_Promotion_Deal_Get_API.Public_Rec;
   spdrec_                        Sales_Promotion_Deal_API.Public_Rec;
   quote_line_rec_                Order_Quotation_Line_API.Public_Rec;
   chargetyperec_                 Sales_Charge_Type_API.Public_Rec;
   quote_line_price_qty_          NUMBER;
   rest_qty_                      NUMBER;
   old_qty_                       NUMBER;
   charge_price_                  NUMBER;
   quotation_charge_no_           NUMBER;
   info_                          VARCHAR2(2000);
   attr_                          VARCHAR2(2000);
   quote_rec_                     Order_Quotation_API.Public_Rec;
   quote_line_net_amount_         NUMBER;
   rest_net_amount_               NUMBER;
   price_qty_for_utilization_no_  NUMBER;
   previous_get_id_               NUMBER;
   rest_flag_                     BOOLEAN;
   qty_to_save_                   NUMBER;
   qty_not_yet_consumed_          NUMBER;
   net_amount_to_save_            NUMBER;
   net_amount_not_yet_consumed_   NUMBER;
   rest_gross_amount_             NUMBER;
   gross_amount_to_save_          NUMBER;
   gross_amount_not_yet_consumed_ NUMBER;
   quote_line_gross_amount_       NUMBER;
   line_no_                       VARCHAR2(4);
   rel_no_                        VARCHAR2(4);
   line_item_no_                  NUMBER;
   old_deal_id_                   NUMBER;
   old_campaign_id_               NUMBER;
   utilization_flag_              BOOLEAN := TRUE;
   charge_price_incl_tax_         NUMBER;
   currency_rate_                 NUMBER;
   base_charge_price_             NUMBER;
   base_charge_price_incl_tax_    NUMBER;
   rounding_                      NUMBER;
   company_                       VARCHAR2(20);
   tax_calc_structure_id_         VARCHAR2(20);
   curr_rounding_                 NUMBER;
                           
   CURSOR get_all_possible_deals IS 
      SELECT campaign_id, deal_id, TRUNC(LEAST(least_times_deal_fulfilled, least_times_deal_ordered)) least_deal_utilization_no          
      FROM promo_deal_quotation_tab
      WHERE quotation_no = quotation_no_
      AND least_times_deal_fulfilled >= 1
      AND least_times_deal_ordered >= 1
      ORDER BY priority;

   CURSOR un_consumed_get_cond_quoteline(campaign_id_ IN NUMBER, deal_id_ IN NUMBER) IS
      SELECT get_id, net_amount/price_qty price, quotation_no, line_no, rel_no, line_item_no, net_amount, 
             gross_amount, price_qty, price_unit_meas, price_excl_tax, price_incl_tax 
      FROM promo_deal_get_quote_line_tab
      WHERE quotation_no = quotation_no_
      AND campaign_id = campaign_id_
      AND deal_id = deal_id_
      AND deal_utilization_no = 0        -- the not fully consumed qty is saved in the deal_utilization_no 0 record
      AND price_qty > 0   -- not fully consumed and to avoid divisor 0
      AND net_amount > 0
      AND gross_amount > 0
      ORDER BY get_id, price, line_no, rel_no;

   CURSOR consumed_get_cond_quoteline(campaign_id_ IN NUMBER, deal_id_ IN NUMBER) IS
      SELECT deal_utilization_no, SUM(net_amount) net_amount, SUM(gross_amount) gross_amount
      FROM promo_deal_get_quote_line_tab
      WHERE quotation_no = quotation_no_
      AND campaign_id = campaign_id_
      AND deal_id = deal_id_
      AND deal_utilization_no > 0 
      GROUP BY deal_utilization_no;

   -- This cursor will fetch several quotation lines but we will only take 1 line since this is used in vat calculation
   -- for charges and all quote lines for the current deal must have the same tax code for sales promotions to work
   CURSOR get_quote_line_keys(campaign_id_ IN NUMBER, deal_id_ IN NUMBER, deal_utilization_no_ IN NUMBER) IS
      SELECT line_no, rel_no, line_item_no
      FROM promo_deal_get_quote_line_tab
      WHERE quotation_no = quotation_no_
      AND campaign_id = campaign_id_
      AND deal_id = deal_id_
      AND deal_utilization_no = deal_utilization_no_;


   CURSOR get_deal_quotelines_for_charge(campaign_id_ IN NUMBER, deal_id_ IN NUMBER, deal_utilization_no_ IN NUMBER) IS
      SELECT get_id, line_no, rel_no, line_item_no
      FROM   promo_deal_get_quote_line_tab
      WHERE  campaign_id = campaign_id_
      AND    deal_id = deal_id_
      AND    quotation_no = quotation_no_
      AND    deal_utilization_no = deal_utilization_no_;
      
   -- This cursor will fetch quotation lines connected to combination of campaign_ID and deal_ID
   CURSOR quotelines_connected_to_deal(campaign_id_ IN NUMBER, deal_id_ IN NUMBER) IS
      SELECT DISTINCT quotation_no, line_no, rel_no, line_item_no
      FROM promo_deal_get_quote_line_tab
      WHERE campaign_id = campaign_id_
      AND deal_id = deal_id_
      AND quotation_no = quotation_no_
      UNION 
      SELECT DISTINCT quotation_no, line_no, rel_no, line_item_no
      FROM promo_deal_buy_quote_line_tab
      WHERE campaign_id = campaign_id_
      AND deal_id = deal_id_
      AND quotation_no = quotation_no_;
BEGIN

   -- Calculation loops
   FOR dealrec_ IN get_all_possible_deals LOOP
      Promo_Deal_Quotation_API.Modify(dealrec_.campaign_id, dealrec_.deal_id, quotation_no_, NULL, NULL, 'FALSE');
      -- restart the deal_utilization_no if new deal or new campaign
      IF (dealrec_.deal_id != old_deal_id_ AND old_deal_id_ IS NOT NULL AND dealrec_.campaign_id = old_campaign_id_ AND old_campaign_id_ IS NOT NULL) OR 
         (dealrec_.campaign_id != old_campaign_id_ AND old_campaign_id_ IS NOT NULL) THEN
         deal_utilization_no_ := 1;
         
         -- Check if quote lines connected to campaign/deal is part of other campaign/deal that has
         -- generated a sales promotion charge previously.
         utilization_flag_ := TRUE;
         FOR linesrec_ IN quotelines_connected_to_deal(dealrec_.campaign_id, dealrec_.deal_id) LOOP
            IF (Check_Promo_Exist_For_Quo_Line(linesrec_.quotation_no, linesrec_.line_no, linesrec_.rel_no, linesrec_.line_item_no)) THEN
               utilization_flag_ := FALSE;
            END IF;
         EXIT WHEN utilization_flag_ = FALSE; -- No need for running the loop anymore
         END LOOP;
      END IF;
      
      -- Do not utilize if any quotation line already part of campaign/deal that has 
      -- generated a sales promotion charge previously.
      IF (utilization_flag_ = TRUE) THEN
         LOOP
            Trace_SYS.Field('deal_utilization_no_ : ', deal_utilization_no_);
            previous_get_id_ := NULL;
            rest_qty_ := 0;
            rest_net_amount_ := 0;
            rest_flag_ := FALSE;
         
            -- Fetch all not fully consumed get conditions per quotation line records
            FOR getcondrec_ IN un_consumed_get_cond_quoteline(dealrec_.campaign_id, dealrec_.deal_id) LOOP
               IF (getcondrec_.get_id = NVL(previous_get_id_, 0) AND rest_flag_ = FALSE) THEN
                  -- do nothing this get id is already consumed for this utilization no
                  -- only handle this record if the previous record for this get id resulted in a rest
                  NULL;
               ELSE -- regular consumation
                  -- fetch the get condition data
                  spgetcondrec_ := Sales_Promotion_Deal_Get_API.Get(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.get_id);
                  spdrec_ := Sales_Promotion_Deal_API.Get(dealrec_.campaign_id, dealrec_.deal_id);
               
                  -- price quantity as the get condition
                  IF (spgetcondrec_.qty IS NOT NULL AND spgetcondrec_.qty > 0) THEN
                  
                     IF (rest_qty_ + getcondrec_.price_qty < spgetcondrec_.qty) THEN
                        -- cannot consume the whole target quantity with this record
                        -- save the whole record 0 qty in a new record and clear the deal_utilization_no 0 record
                        -- save current quantity in our rest qty variable for use by the next quotation line if they are connected to the same get_id
                        rest_qty_ := rest_qty_ + getcondrec_.price_qty;
                        rest_flag_ := TRUE;
                   
                        Promo_Deal_Get_Quote_Line_API.New(dealrec_.campaign_id,
                                                          dealrec_.deal_id,
                                                          getcondrec_.get_id, 
                                                          getcondrec_.quotation_no,
                                                          getcondrec_.line_no,
                                                          getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no,
                                                          deal_utilization_no_,
                                                          getcondrec_.net_amount, 
                                                          getcondrec_.gross_amount,
                                                          getcondrec_.price_qty,
                                                          getcondrec_.price_unit_meas,
                                                          NULL,
                                                          NULL);
                        -- set amounts and qty to zero for the deal_utilization_no 0 record
                        Promo_Deal_Get_Quote_Line_API.Modify(dealrec_.campaign_id,
                                                             dealrec_.deal_id,
                                                             getcondrec_.get_id, 
                                                             getcondrec_.quotation_no,
                                                             getcondrec_.line_no,
                                                             getcondrec_.rel_no, 
                                                             getcondrec_.line_item_no,
                                                             0,
                                                             0,
                                                             0,
                                                             0,
                                                             NULL); 
                        Trace_SYS.Field('new rest_qty_ : ', rest_qty_);
                     ELSE
                        -- consume this record, either the whole or a part of it if we already have a rest qty from a 
                        -- previous quotation line that was connected to this get_id            
                        qty_to_save_ := spgetcondrec_.qty - NVL(rest_qty_,0);

                        Promo_Deal_Get_Quote_Line_API.New(dealrec_.campaign_id,
                                                          dealrec_.deal_id,
                                                          getcondrec_.get_id, 
                                                          getcondrec_.quotation_no,
                                                          getcondrec_.line_no,
                                                          getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no,
                                                          deal_utilization_no_,
                                                          getcondrec_.price_excl_tax * qty_to_save_, 
                                                          getcondrec_.price_incl_tax * qty_to_save_,
                                                          qty_to_save_,
                                                          getcondrec_.price_unit_meas,
                                                          NULL,
                                                          NULL);
                        -- save the not yet consumed qty in the deal utilization no 0 record
                        qty_not_yet_consumed_ := getcondrec_.price_qty - qty_to_save_; 
                        Promo_Deal_Get_Quote_Line_API.Modify(dealrec_.campaign_id,
                                                             dealrec_.deal_id,
                                                             getcondrec_.get_id, 
                                                             getcondrec_.quotation_no,
                                                             getcondrec_.line_no,
                                                             getcondrec_.rel_no, 
                                                             getcondrec_.line_item_no,
                                                             0,
                                                             getcondrec_.price_excl_tax * qty_not_yet_consumed_, 
                                                             getcondrec_.price_incl_tax * qty_not_yet_consumed_,
                                                             qty_not_yet_consumed_,
                                                             NULL);
                        -- clear the rest variables
                        rest_flag_ := FALSE;
                        rest_qty_ := 0;
                        Trace_SYS.Field('qty_to_save_ : ', qty_to_save_);
                        Trace_SYS.Field('qty_not_yet_consumed_ : ', qty_not_yet_consumed_);
                     END IF;

                  -- gross amount as the get condition
                  ELSIF (spgetcondrec_.gross_amount IS NOT NULL AND spgetcondrec_.gross_amount > 0) THEN
                  
                     quote_line_net_amount_   := Order_Quotation_Line_API.Get_Sale_Price_Total(quotation_no_, 
                                                                                               getcondrec_.line_no, 
                                                                                               getcondrec_.rel_no, 
                                                                                               getcondrec_.line_item_no);
                     quote_line_gross_amount_ := quote_line_net_amount_ + Order_Quotation_Line_API.Get_Total_Tax_Amount_Curr(quotation_no_,
                                                                                                                               getcondrec_.line_no, 
                                                                                                                               getcondrec_.rel_no, 
                                                                                                                               getcondrec_.line_item_no);

                     IF (rest_gross_amount_ + getcondrec_.gross_amount<spgetcondrec_.gross_amount) THEN
                        -- cannot consume the whole target gross amount with this record
                        -- save the whole record 0 gross amount in a new record and clear the deal_utilization_no 0 record
                        -- save current gross amount in our rest gross amount base variable for use by the next quotation line if they are connected to the same get_id
                        rest_gross_amount_ := rest_gross_amount_ + getcondrec_.gross_amount;
                        rest_flag_ := TRUE;
                        Promo_Deal_Get_Quote_Line_API.New(dealrec_.campaign_id,
                                                          dealrec_.deal_id,
                                                          getcondrec_.get_id, 
                                                          getcondrec_.quotation_no,
                                                          getcondrec_.line_no,
                                                          getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no,
                                                          deal_utilization_no_,
                                                          getcondrec_.net_amount, 
                                                          getcondrec_.gross_amount,
                                                          getcondrec_.price_qty,
                                                          getcondrec_.price_unit_meas,
                                                          NULL,
                                                          NULL);
                        -- set amounts and qty to zero for the deal_utilization_no 0 record
                        Promo_Deal_Get_Quote_Line_API.Modify(dealrec_.campaign_id,
                                                             dealrec_.deal_id,
                                                             getcondrec_.get_id, 
                                                             getcondrec_.quotation_no,
                                                             getcondrec_.line_no,
                                                             getcondrec_.rel_no, 
                                                             getcondrec_.line_item_no,
                                                             0,
                                                             0,
                                                             0,
                                                             0,
                                                             NULL); 
                        Trace_SYS.Field('new rest_gross_amount_ : ', rest_gross_amount_);
                     ELSE
                        quote_line_rec_ := Order_Quotation_Line_API.Get(quotation_no_, getcondrec_.line_no, getcondrec_.rel_no, getcondrec_.line_item_no);
                        quote_line_price_qty_  :=  quote_line_rec_.buy_qty_due * quote_line_rec_.price_conv_factor;
                        -- consume this record, either the whole or a part of it if we already have a rest gross amount from a 
                        -- previous quotation line that was connected to this get_id            
                        gross_amount_to_save_ := spgetcondrec_.gross_amount - NVL(rest_gross_amount_,0);
                        IF (quote_line_gross_amount_ != 0) THEN
                           price_qty_for_utilization_no_ := (gross_amount_to_save_ / quote_line_gross_amount_) * quote_line_price_qty_;
                        END IF;
                        Promo_Deal_Get_Quote_Line_API.New(dealrec_.campaign_id,
                                                          dealrec_.deal_id,
                                                          getcondrec_.get_id, 
                                                          getcondrec_.quotation_no,
                                                          getcondrec_.line_no,
                                                          getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no,
                                                          deal_utilization_no_,
                                                          getcondrec_.price_excl_tax * price_qty_for_utilization_no_, 
                                                          gross_amount_to_save_,
                                                          price_qty_for_utilization_no_,
                                                          getcondrec_.price_unit_meas,
                                                          NULL,
                                                          NULL);
                        -- save the not yet consumed gross amount in the deal utilization no 0 record
                        gross_amount_not_yet_consumed_ := getcondrec_.gross_amount - gross_amount_to_save_;
                        IF (quote_line_gross_amount_ != 0) THEN
                           qty_not_yet_consumed_ := (gross_amount_not_yet_consumed_ / quote_line_gross_amount_) * quote_line_price_qty_;
                        END IF;
                        Promo_Deal_Get_Quote_Line_API.Modify(dealrec_.campaign_id,
                                                             dealrec_.deal_id,
                                                             getcondrec_.get_id, 
                                                             getcondrec_.quotation_no,
                                                             getcondrec_.line_no,
                                                             getcondrec_.rel_no, 
                                                             getcondrec_.line_item_no,
                                                             0,
                                                             getcondrec_.price_excl_tax * qty_not_yet_consumed_, 
                                                             gross_amount_not_yet_consumed_,
                                                             qty_not_yet_consumed_,
                                                             NULL);
                     -- clear the rest variables
                     rest_flag_ := FALSE;
                     rest_gross_amount_ := 0;
                  END IF;
               -- net amount as the get condition
               ELSIF (spgetcondrec_.net_amount IS NOT NULL AND spgetcondrec_.net_amount > 0) THEN
                     
                     quote_line_net_amount_ := Order_Quotation_Line_API.Get_Sale_Price_Total(quotation_no_, 
                                                                                             getcondrec_.line_no, 
                                                                                             getcondrec_.rel_no, 
                                                                                             getcondrec_.line_item_no);
                     IF (rest_net_amount_ + getcondrec_.net_amount<spgetcondrec_.net_amount) THEN
                        -- cannot consume the whole target net amount with this record
                        -- save the whole record 0 net amount in a new record and clear the deal_utilization_no 0 record
                        -- save current net amount in our rest net amount base variable for use by the next quotation line if they are connected to the same get_id
                        rest_net_amount_ := rest_net_amount_ + getcondrec_.net_amount;
                        rest_flag_ := TRUE;
                        Promo_Deal_Get_quote_Line_API.New(dealrec_.campaign_id,
                                                          dealrec_.deal_id,
                                                          getcondrec_.get_id, 
                                                          getcondrec_.quotation_no,
                                                          getcondrec_.line_no,
                                                          getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no,
                                                          deal_utilization_no_,
                                                          getcondrec_.net_amount, 
                                                          getcondrec_.gross_amount,
                                                          getcondrec_.price_qty,
                                                          getcondrec_.price_unit_meas,
                                                          NULL,
                                                          NULL);
                        -- set amounts and qty to zero for the deal_utilization_no 0 record
                        Promo_Deal_Get_Quote_Line_API.Modify(dealrec_.campaign_id,
                                                             dealrec_.deal_id,
                                                             getcondrec_.get_id, 
                                                             getcondrec_.quotation_no,
                                                             getcondrec_.line_no,
                                                             getcondrec_.rel_no, 
                                                             getcondrec_.line_item_no,
                                                             0,
                                                             0,
                                                             0,
                                                             0,
                                                             NULL); 
                     ELSE
                        quote_line_rec_ := Order_Quotation_Line_API.Get(quotation_no_, getcondrec_.line_no, getcondrec_.rel_no, getcondrec_.line_item_no);
                        quote_line_price_qty_  :=  quote_line_rec_.buy_qty_due * quote_line_rec_.price_conv_factor;
                        -- consume this record, either the whole or a part of it if we already have a rest net amount from a 
                        -- previous quotation line that was connected to this get_id            
                        net_amount_to_save_ := spgetcondrec_.net_amount - NVL(rest_net_amount_,0);
                        IF (quote_line_net_amount_ != 0) THEN
                           price_qty_for_utilization_no_ := (net_amount_to_save_ / quote_line_net_amount_) * quote_line_price_qty_;
                        END IF; 
                        Promo_Deal_Get_Quote_Line_API.New(dealrec_.campaign_id,
                                                          dealrec_.deal_id,
                                                          getcondrec_.get_id, 
                                                          getcondrec_.quotation_no,
                                                          getcondrec_.line_no,
                                                          getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no,
                                                          deal_utilization_no_,
                                                          net_amount_to_save_, 
                                                          getcondrec_.price_incl_tax * price_qty_for_utilization_no_,
                                                          price_qty_for_utilization_no_,
                                                          getcondrec_.price_unit_meas,
                                                          NULL,
                                                          NULL);
                        -- save the not yet consumed net amount in the deal utilization no 0 record
                        net_amount_not_yet_consumed_ := getcondrec_.net_amount - net_amount_to_save_;
                        IF (quote_line_net_amount_ != 0) THEN
                           qty_not_yet_consumed_ := (net_amount_not_yet_consumed_ / quote_line_net_amount_) * quote_line_price_qty_;
                        END IF;
                        Promo_Deal_Get_Quote_Line_API.Modify(dealrec_.campaign_id,
                                                             dealrec_.deal_id,
                                                             getcondrec_.get_id, 
                                                             getcondrec_.quotation_no,
                                                             getcondrec_.line_no,
                                                             getcondrec_.rel_no, 
                                                             getcondrec_.line_item_no,
                                                             0,
                                                             net_amount_not_yet_consumed_, 
                                                             getcondrec_.price_incl_tax * qty_not_yet_consumed_,
                                                             qty_not_yet_consumed_,
                                                             NULL);
                        -- Clear the rest variables
                        rest_flag_ := FALSE;
                        rest_net_amount_ := 0;
                     END IF;
                  -- handle cases where you use discount% without any qty/amount on the get condition
                  ELSIF (spgetcondrec_.net_amount IS NULL AND spgetcondrec_.gross_amount IS NULL AND 
                         spgetcondrec_.qty IS NULL AND spdrec_.discount IS NOT NULL) THEN
                     -- this case is simply handled by moving the values from the 0 record to this deal_utilization_no record (which will be 1 since in this case, the times_ordered is always = 1)
                      
                      
                     Promo_Deal_Get_Quote_Line_API.New(dealrec_.campaign_id,
                                                       dealrec_.deal_id,
                                                       getcondrec_.get_id, 
                                                       getcondrec_.quotation_no,
                                                       getcondrec_.line_no,
                                                       getcondrec_.rel_no, 
                                                       getcondrec_.line_item_no,
                                                       deal_utilization_no_,
                                                       getcondrec_.net_amount, 
                                                       getcondrec_.gross_amount,
                                                       getcondrec_.price_qty,
                                                       getcondrec_.price_unit_meas,
                                                       NULL,
                                                       NULL);
                     -- set amounts and qty to zero for the deal_utilization_no 0 record
                     Promo_Deal_Get_Quote_Line_API.Modify(dealrec_.campaign_id,
                                                          dealrec_.deal_id,
                                                          getcondrec_.get_id, 
                                                          getcondrec_.quotation_no,
                                                          getcondrec_.line_no,
                                                          getcondrec_.rel_no, 
                                                          getcondrec_.line_item_no,
                                                          0,
                                                          0,
                                                          0,
                                                          0,
                                                          NULL); 
                     -- set rest flag to TRUE because we could have more lines that should be handled this way if we use discount% only
                     rest_flag_ := TRUE;
                  END IF;
               END IF;

               previous_get_id_ := getcondrec_.get_id; 

            END LOOP;
            
            deal_utilization_no_ := deal_utilization_no_ + 1;
            EXIT WHEN deal_utilization_no_ > dealrec_.least_deal_utilization_no;
         END LOOP;
      END IF;   

      company_ := Site_API.Get_Company(Order_Quotation_Api.Get_Contract(quotation_no_));
      rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
      quote_rec_ := Order_Quotation_API.Get(quotation_no_);
      curr_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, quote_rec_.currency_code);
      -- charge loop
      FOR getcondrec_ IN consumed_get_cond_quoteline(dealrec_.campaign_id, dealrec_.deal_id) LOOP
         spdrec_ := Sales_Promotion_Deal_API.Get(dealrec_.campaign_id, dealrec_.deal_id);
         
         charge_price_ := 0;
         charge_price_incl_tax_ := 0;
         -- fetch quotation line keys, need to fetch tax code and maybe tax percent, any quotation line keys for this deal_utilization_no will do since all quote lines needs to have the same tax code
         OPEN  get_quote_line_keys(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.deal_utilization_no);
         FETCH get_quote_line_keys INTO line_no_, rel_no_, line_item_no_;
         CLOSE get_quote_line_keys;
         -- Charge Price calculations 
         IF (spdrec_.discount IS NOT NULL) THEN
            charge_price_ := (((spdrec_.discount/100) * getcondrec_.net_amount) * -1);
            charge_price_incl_tax_ := (((spdrec_.discount/100) * getcondrec_.gross_amount) * -1);
         ELSIF (spdrec_.discount_gross_amount IS NOT NULL OR spdrec_.discount_net_amount IS NOT NULL) THEN
            charge_price_ :=  (spdrec_.discount_net_amount * -1);
            charge_price_incl_tax_ :=  (spdrec_.discount_gross_amount * -1);
         ELSIF (spdrec_.price_incl_tax IS NOT NULL OR spdrec_.price_excl_tax IS NOT NULL) THEN
            charge_price_ := spdrec_.price_excl_tax - getcondrec_.net_amount;
            charge_price_incl_tax_ :=  spdrec_.price_incl_tax - getcondrec_.gross_amount;
         END IF;
         charge_price_incl_tax_ := ROUND(charge_price_incl_tax_, curr_rounding_);
         charge_price_          := ROUND(charge_price_, curr_rounding_);
         
         currency_rate_ := Order_Quotation_Line_Api.Get_Currency_Rate(quotation_no_, line_no_, rel_no_, line_item_no_);
         base_charge_price_incl_tax_ := ROUND(charge_price_incl_tax_ * currency_rate_, rounding_);
         base_charge_price_ := ROUND(charge_price_ * currency_rate_, rounding_);
            
         IF (charge_price_ < 0 OR charge_price_incl_tax_ < 0 ) THEN
            -- create charge record if the same charge price does not exist before, in other case update the quantity on the existing record with 1
            Client_SYS.Clear_Attr(attr_);
            quotation_charge_no_ := Customer_Order_Charge_Util_API.Get_Matched_Quote_Charge_No(quotation_no_, spdrec_.charge_type, charge_price_, charge_price_incl_tax_, dealrec_.campaign_id, dealrec_.deal_id);
            Trace_SYS.Field('quotation_charge_no_ : ', quotation_charge_no_);               

            IF quotation_charge_no_ IS NOT NULL THEN
               old_qty_ := Order_Quotation_Charge_API.Get_Charged_Qty(quotation_no_, quotation_charge_no_);
               Client_SYS.Add_To_Attr('CHARGED_QTY', old_qty_ + 1, attr_);
               Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 'TRUE',  attr_);
               Order_Quotation_Charge_API.Modify(quotation_no_, quotation_charge_no_, attr_);
            ELSE
               quote_line_rec_ := Order_Quotation_Line_API.Get(quotation_no_, line_no_, rel_no_, line_item_no_);

               -- Fetch all charge default values from the charge type
               chargetyperec_ := Sales_Charge_Type_API.Get(quote_rec_.contract, spdrec_.charge_type);
               
               Client_SYS.Add_To_Attr('QUOTATION_NO', quotation_no_, attr_);           
               Client_SYS.Add_To_Attr('CONTRACT', quote_rec_.contract, attr_);
               Client_SYS.Add_To_Attr('CHARGE_TYPE', spdrec_.charge_type, attr_);
               Client_SYS.Add_To_Attr('SALES_UNIT_MEAS', chargetyperec_.sales_unit_meas, attr_);
               Client_SYS.Add_To_Attr('DATE_ENTERED', Site_API.Get_Site_Date(quote_rec_.contract), attr_);
               Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB', chargetyperec_.print_charge_type, attr_);
               Client_SYS.Add_To_Attr('CHARGE_COST', 0, attr_);
               Client_SYS.Add_To_Attr('COMPANY', chargetyperec_.company, attr_);
               Client_SYS.Add_To_Attr('UNIT_CHARGE_DB', chargetyperec_.unit_charge, attr_);
               Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB',  chargetyperec_.intrastat_exempt, attr_);
               Client_SYS.Add_To_Attr('CHARGED_QTY', 1, attr_);               
               -- tax code from quotation lines and charge price from previous calculation
               Client_SYS.Add_To_Attr('TAX_CODE', quote_line_rec_.tax_code, attr_);
               Client_SYS.Add_To_Attr('TAX_CLASS_ID', quote_line_rec_.tax_class_id, attr_);
               Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT', base_charge_price_, attr_);            
               Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', base_charge_price_incl_tax_, attr_);
               Client_SYS.Add_To_Attr('CHARGE_AMOUNT', charge_price_, attr_);
               Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', charge_price_incl_tax_, attr_);
               Client_SYS.Add_To_Attr('CAMPAIGN_ID', dealrec_.campaign_id, attr_);            
               Client_SYS.Add_To_Attr('DEAL_ID', dealrec_.deal_id, attr_);
               Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 'TRUE',  attr_);
               Client_SYS.Add_To_Attr('TAX_CALC_STRUCTURE_ID', quote_line_rec_.tax_calc_structure_id,  attr_);
               IF quote_line_rec_.tax_code IS NULL AND quote_line_rec_.tax_class_id IS NULL AND quote_line_rec_.tax_calc_structure_id IS NULL THEN
                  -- no taxes calculated for the line or multiple tax items - in that case taxes for the charge line will be recalculated below in Order_Quotation_Charge_API.Copy_Quote_Line_Tax_Lines
                  Client_SYS.Add_To_Attr('FETCH_TAX_CODES', 'FALSE',  attr_);
                  Client_SYS.Add_To_Attr('ADD_TAX_LINES', 'FALSE',  attr_);
               END IF;
  
               Order_Quotation_Charge_API.New(info_, attr_);
               quotation_charge_no_ := Client_SYS.Get_Item_Value('QUOTATION_CHARGE_NO', attr_);
               
               IF (Source_Tax_Item_API.Multiple_Tax_Items_Exist(company_, Tax_Source_API.DB_ORDER_QUOTATION_LINE, quotation_no_, line_no_, rel_no_, line_item_no_, '*') = 'TRUE')
                  AND (Sales_Charge_Type_API.Get_Taxable_Db(quote_rec_.contract, spdrec_.charge_type) = Fnd_Boolean_API.DB_TRUE) THEN
                  Order_Quotation_Charge_API.Copy_Quote_Line_Tax_Lines(company_,
                                                                       quotation_no_, 
                                                                       line_no_, 
                                                                       rel_no_, 
                                                                       line_item_no_,
                                                                       quotation_charge_no_);
               END IF;
  
            END IF;
            -- Update the concerned records in Promo_Deal_Get_Quote_Line with the charge sequence no
            FOR charge_quoteline_rec_ IN get_deal_quotelines_for_charge(dealrec_.campaign_id, dealrec_.deal_id, getcondrec_.deal_utilization_no) LOOP
               Promo_Deal_Get_Quote_Line_API.Set_Quotation_Charge_No(dealrec_.campaign_id,
                                                                     dealrec_.deal_id,
                                                                     charge_quoteline_rec_.get_id,
                                                                     quotation_no_,
                                                                     charge_quoteline_rec_.line_no,
                                                                     charge_quoteline_rec_.rel_no, 
                                                                     charge_quoteline_rec_.line_item_no,
                                                                     getcondrec_.deal_utilization_no, 
                                                                     quotation_charge_no_); 
            END LOOP;
         END IF;
      END LOOP;
      old_deal_id_ := dealrec_.deal_id;
      old_campaign_id_ := dealrec_.campaign_id;
   END LOOP;

   -- Please note that there are still a lot of problems connected to if you are going to try and 
   -- remove deal/deal_buy/deal_get records from basic data for the sales promotion since there 
   -- could be a lot of records in our sales promotion calculation tables left even if the campaign/deals/buy/get 
   -- didnt result in a promotion charge since another campaign/deal/buy/get could have resultet in 
   -- a promotion charge during this calculation so all possible records are still saved in these 
   -- sales promotion calculation tables.
END Calculate_Quote_Charges___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Calculate_Order_Promotion
--   Calculate sales promotions in customer order.
PROCEDURE Calculate_Order_Promotion (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   Clear_Order_Promotion___(order_no_);
   Calculate_Order_Deal_Buy___(order_no_);
   Calculate_Order_Deal_Get___(order_no_);
   Calculate_Order_Charges___(order_no_);
END Calculate_Order_Promotion;


-- Clear_Order_Promotion
--   Clear all sales promotion calculations in customer order.
PROCEDURE Clear_Order_Promotion (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   Clear_Order_Promotion___(order_no_);
END Clear_Order_Promotion;


-- Calculate_Quote_Promotion
--   Calculate sales promotions in sales quotation.
PROCEDURE Calculate_Quote_Promotion (
   quotation_no_ IN VARCHAR2 )
IS
BEGIN
   Clear_Quote_Promotion___(quotation_no_);
   Calculate_Quote_Deal_Buy___(quotation_no_);
   Calculate_Quote_Deal_Get___(quotation_no_);
   Calculate_Quote_Charges___(quotation_no_);
END Calculate_Quote_Promotion;


-- Clear_Quote_Promotion
--   Clear all sales promotion calculations in sales quotation.
PROCEDURE Clear_Quote_Promotion (
   quotation_no_ IN VARCHAR2 )
IS
BEGIN
   Clear_Quote_Promotion___(quotation_no_);
END Clear_Quote_Promotion;


-- Check_If_Approvable
--   Checks whether a given campaign id is approvable.
@UncheckedAccess
FUNCTION Check_If_Approvable (
   campaign_id_ IN NUMBER ) RETURN BOOLEAN
IS
   found_ NUMBER;
   CURSOR get_promotion IS
      SELECT 1
      FROM   sales_promotion_deal_tab spd, sales_promotion_deal_buy_tab spdb, sales_promotion_deal_get_tab spdg
      WHERE  spd.campaign_id = campaign_id_
      AND spd.deal_id = spdb.deal_id
      AND spd.deal_id = spdg.deal_id
      AND spdb.campaign_id = campaign_id_
      AND spdg.campaign_id = campaign_id_
      AND (spd.price_excl_tax IS NOT NULL
           OR spd.price_incl_tax IS NOT NULL
           OR spd.discount_gross_amount IS NOT NULL
           OR spd.discount_net_amount IS NOT NULL
           OR spd.discount IS NOT NULL);
BEGIN
   OPEN get_promotion;
   FETCH get_promotion INTO found_;
   IF (get_promotion%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE get_promotion;
   RETURN (found_ = 1);
END Check_If_Approvable;



-- Check_Promo_Exist_For_Ord_Line
--   This method is used for checking if it is possible to remove a specific order line
--   so it checks if the order line has any sales promotion calculations
--   that have resulted in a sales promotion charge beeing added.
@UncheckedAccess
FUNCTION Check_Promo_Exist_For_Ord_Line (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN BOOLEAN
IS
   found_ NUMBER;
   CURSOR check_promo_line_exist1 IS
      SELECT 1
      FROM promo_deal_buy_order_line_tab buy
      WHERE buy.order_no = order_no_
      AND buy.line_no = line_no_
      AND buy.rel_no = rel_no_  
      AND buy.line_item_no = line_item_no_
      AND EXISTS (SELECT 1
                  FROM promo_deal_get_order_line_tab get
                  WHERE get.order_no = buy.order_no 
                  AND get.deal_utilization_no > 0
                  AND get.campaign_id = buy.campaign_id 
                  AND get.deal_id = buy.deal_id);
                  
   CURSOR check_promo_line_exist2 IS
      SELECT 1
      FROM promo_deal_get_order_line_tab get
      WHERE get.order_no = order_no_
      AND get.line_no = line_no_
      AND get.rel_no = rel_no_
      AND get.line_item_no = line_item_no_
      AND get.deal_utilization_no > 0;
                  
BEGIN
   OPEN check_promo_line_exist1;
   FETCH check_promo_line_exist1 INTO found_;
   IF (check_promo_line_exist1%NOTFOUND) THEN
      found_ := 0;
      OPEN check_promo_line_exist2;
      FETCH check_promo_line_exist2 INTO found_;
      IF (check_promo_line_exist2%NOTFOUND) THEN
         found_ := 0;
      END IF;
      CLOSE check_promo_line_exist2;
   END IF;
   CLOSE check_promo_line_exist1;
   RETURN (found_ = 1);
END Check_Promo_Exist_For_Ord_Line;



-- Check_Promo_Exist_Ord_Line_Num
--   This method is returns number type Check_Promo_Exist_For_Ord_Line to be used in client.
@UncheckedAccess
FUNCTION Check_Promo_Exist_Ord_Line_Num (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_  NUMBER;
BEGIN
   IF (Check_Promo_Exist_For_Ord_Line(order_no_, line_no_, rel_no_, line_item_no_)) THEN
      temp_ := 1;
   ELSE
      temp_ := 0;
   END IF;

   RETURN temp_;
END Check_Promo_Exist_Ord_Line_Num;



-- Check_Promo_Exist_For_Quo_Line
--   This method is used for checking if it is possible to remove a specific quotation line
--   so it checks if the quotation line has any sales promotion calculations
--   that have resulted in a sales promotion charge beeing added.
--   This method is returns number type Check_Promo_Exist_For_Quo_Line to be used in client.
@UncheckedAccess
FUNCTION Check_Promo_Exist_For_Quo_Line (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN BOOLEAN
IS
   found_ NUMBER;
   CURSOR check_promo_line_exist IS
      SELECT 1
      FROM promo_deal_get_quote_line_tab get1
      WHERE get1.quotation_no = quotation_no_
      AND get1.line_no = line_no_
      AND get1.rel_no = rel_no_
      AND get1.line_item_no = line_item_no_
      AND get1.deal_utilization_no > 0
      UNION 
      SELECT 1
      FROM promo_deal_buy_quote_line_tab buy
      WHERE buy.quotation_no = quotation_no_
      AND buy.line_no = line_no_
      AND buy.rel_no = rel_no_  
      AND buy.line_item_no = line_item_no_
      AND EXISTS (SELECT 1
                  FROM promo_deal_get_quote_line_tab get2
                  WHERE get2.quotation_no = buy.quotation_no 
                  AND get2.deal_utilization_no > 0
                  AND get2.campaign_id = buy.campaign_id 
                  AND get2.deal_id = buy.deal_id);
BEGIN
   OPEN check_promo_line_exist;
   FETCH check_promo_line_exist INTO found_;
   IF (check_promo_line_exist%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE check_promo_line_exist;
   RETURN (found_ = 1);
END Check_Promo_Exist_For_Quo_Line;



@UncheckedAccess
FUNCTION Check_Promo_Exist_Quo_Line_Num (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_    NUMBER;

BEGIN
   IF (Check_Promo_Exist_For_Quo_Line(quotation_no_, line_no_, rel_no_, line_item_no_)) THEN
      temp_ := 1;
   ELSE
      temp_ := 0;
   END IF;

   RETURN temp_;
END Check_Promo_Exist_Quo_Line_Num;



@UncheckedAccess
FUNCTION Check_Unutilized_O_Deals_Exist (
   order_no_            IN VARCHAR2,
   ignore_notify_flag_  IN BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   temp_    NUMBER;
   -- without notify flag check
   CURSOR check_unutilized_lines_exist_1 IS
      SELECT 1
      FROM promo_deal_order_tab pdo
      WHERE pdo.order_no = order_no_
      AND   pdo.unutilized_deal = 'TRUE';

   -- with notify flag check
   CURSOR check_unutilized_lines_exist_2 IS
      SELECT 1
      FROM promo_deal_order_tab pdo, sales_promotion_deal_tab spd
      WHERE pdo.order_no = order_no_
      AND   pdo.campaign_id = spd.campaign_id
      AND   pdo.deal_id = spd.deal_id
      AND   spd.notify_unutilized_deal = 'TRUE'
      AND   pdo.unutilized_deal = 'TRUE';

BEGIN
   -- ignore_notify_flag_ = TRUE is when this method is called from ordflow to create an event if unutilized deals exist then we ignore the notify flag
   IF (ignore_notify_flag_) THEN
      OPEN check_unutilized_lines_exist_1;
      FETCH check_unutilized_lines_exist_1 INTO temp_;
      IF (check_unutilized_lines_exist_1%FOUND) THEN
         CLOSE check_unutilized_lines_exist_1;
         RETURN 'TRUE';
      END IF;
      CLOSE check_unutilized_lines_exist_1;
   ELSE
      OPEN check_unutilized_lines_exist_2;
      FETCH check_unutilized_lines_exist_2 INTO temp_;
      IF (check_unutilized_lines_exist_2%FOUND) THEN
         CLOSE check_unutilized_lines_exist_2;
         RETURN 'TRUE';
      END IF;
      CLOSE check_unutilized_lines_exist_2;
   END IF;

   RETURN 'FALSE';

END Check_Unutilized_O_Deals_Exist;



@UncheckedAccess
FUNCTION Check_Unutilized_Q_Deals_Exist (
   quotation_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_    NUMBER;
   CURSOR check_unutilized_lines_exist IS
      SELECT 1
      FROM promo_deal_quotation_tab pdq, sales_promotion_deal_tab spd
      WHERE pdq.quotation_no = quotation_no_
      AND   pdq.campaign_id = spd.campaign_id
      AND   pdq.deal_id = spd.deal_id
      AND   spd.notify_unutilized_deal = 'TRUE'
      AND   pdq.unutilized_deal = 'TRUE';
BEGIN
   OPEN check_unutilized_lines_exist;
   FETCH check_unutilized_lines_exist INTO temp_;
   IF (check_unutilized_lines_exist%FOUND) THEN
      CLOSE check_unutilized_lines_exist;
      RETURN 'TRUE';
   END IF;
   CLOSE check_unutilized_lines_exist;
   RETURN 'FALSE';
END Check_Unutilized_Q_Deals_Exist;



@UncheckedAccess
FUNCTION Get_Possible_Sales_Promo_Deal (
   orderquote_no_ IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   type_          IN VARCHAR2 DEFAULT 'ORDER'   ) RETURN VARCHAR2
IS
   ordrec_              Customer_Order_API.Public_Rec;
   ordline_rec_         Customer_Order_Line_API.Public_Rec;
   oqrec_               Order_Quotation_API.Public_Rec;
   oqline_rec_          Order_Quotation_Line_API.Public_Rec;
   pricing_method_      VARCHAR2(20);
   contract_            VARCHAR2(5);
   customer_no_         VARCHAR2(20);
   price_effectivity_date_ DATE;
   currency_code_       VARCHAR2(3);
   price_unit_meas_     VARCHAR2(10);
   catalog_no_          VARCHAR2(25);
   hierarchy_id_        CUST_HIERARCHY_STRUCT_TAB.hierarchy_id%TYPE;
   deal_description_    VARCHAR2(200);
   cust_price_group_id_ VARCHAR2(10);
   site_date_           DATE;

    -- Changes in this cursor where statements could also affect cursors get_campaigns_for_order/get_campaigns_for_quote in methods Calculate_Order_Deal_Buy___/Calculate_Order_Deal_Buy___
   CURSOR get_campaigns IS
      SELECT *
      FROM campaign_tab c
      WHERE rowstate = 'Active'
      AND   EXISTS (SELECT 1                             
                    FROM campaign_site_tab
                    WHERE campaign_id = c.campaign_id
                    AND contract = contract_)
      AND   DECODE(pricing_method_, 'SYSTEM_DATE', TRUNC(site_date_), price_effectivity_date_) BETWEEN c.sales_start AND c.sales_end
      AND   currency_code = currency_code_
      AND   EXISTS (SELECT 1
                    FROM sales_promotion_deal_tab spd
                    WHERE spd.campaign_id = c.campaign_id)
      AND   (c.valid_for_all_customers = 'TRUE'
             OR EXISTS (SELECT 1 FROM campaign_customer_tab cct
                        WHERE cct.campaign_id = c.campaign_id
                        AND   (cct.customer_no IN (SELECT customer_no
                                                  FROM CUST_HIERARCHY_STRUCT_TAB
                                                  WHERE HIERARCHY_ID = hierarchy_id_
                                                  START WITH CUSTOMER_NO = customer_no_
                                                  CONNECT BY PRIOR CUSTOMER_PARENT = CUSTOMER_NO)
                               OR cct.customer_no = customer_no_))
             OR EXISTS (SELECT 1 FROM campaign_cust_price_group_tab ccpgt
                        WHERE ccpgt.campaign_id = c.campaign_id
                        AND (ccpgt.cust_price_group_id IN (SELECT cust_price_group_id
                                                          FROM CUST_HIERARCHY_STRUCT_TAB chst, CUST_ORD_CUSTOMER_TAB coct
                                                          WHERE HIERARCHY_ID = hierarchy_id_
                                                          AND chst.customer_no = coct.customer_no
                                                          START WITH chst.CUSTOMER_NO = customer_no_
                                                          CONNECT BY PRIOR CUSTOMER_PARENT = chst.CUSTOMER_NO)
                             OR ccpgt.cust_price_group_id = cust_price_group_id_)));

   TYPE Campaign_Collection_Tab IS TABLE OF get_campaigns%ROWTYPE INDEX BY PLS_INTEGER;
   campaign_tab_        Campaign_Collection_Tab;

    CURSOR get_deals (campaign_id_ IN VARCHAR2) IS
       SELECT DISTINCT bgu.deal_id, bgu.catalog_no, bgu.assortment_id, bgu.assortment_node_id
       FROM (SELECT * FROM sales_promotion_deal_buy_tab WHERE campaign_id = campaign_id_ 
             UNION 
             SELECT * FROM sales_promotion_deal_get_tab WHERE campaign_id = campaign_id_) bgu, 
            sales_promotion_deal_tab spd
       WHERE (bgu.price_unit_meas = price_unit_meas_ OR bgu.price_unit_meas IS NULL)
       AND   spd.campaign_id = bgu.campaign_id
       AND   spd.deal_id = bgu.deal_id
       AND   spd.notify_unutilized_deal = 'TRUE'
       AND   NOT EXISTS (SELECT 1           -- Statement used to avoid the notifying when this deal has already been utilized by a sales promo calculation earlier
                         FROM promo_deal_order_tab pdo
                         WHERE pdo.campaign_id = bgu.campaign_id
                         AND   pdo.deal_id = bgu.deal_id
                         AND   pdo.order_no =  orderquote_no_
                         AND   type_ = 'ORDER'
                         AND   pdo.least_times_deal_fulfilled >= 1 
                         AND   pdo.least_times_deal_ordered >= 1
                         UNION
                         SELECT 1 
                         FROM promo_deal_quotation_tab pdq
                         WHERE pdq.campaign_id = bgu.campaign_id
                         AND   pdq.deal_id = bgu.deal_id
                         AND   pdq.quotation_no =  orderquote_no_
                         AND   type_ = 'QUOTATION'
                         AND   pdq.least_times_deal_fulfilled >= 1 
                         AND   pdq.least_times_deal_ordered >= 1);


BEGIN
   IF (type_ = 'ORDER') THEN
      ordrec_         := Customer_Order_API.Get(orderquote_no_);
      ordline_rec_    := Customer_Order_Line_API.Get(orderquote_no_, line_no_, rel_no_, line_item_no_);
      contract_       := ordrec_.contract;
      site_date_      := Site_API.Get_Site_Date(contract_);
      customer_no_    := ordrec_.customer_no;
      price_effectivity_date_ := ordline_rec_.price_effectivity_date;
      currency_code_   := ordrec_.currency_code;
      price_unit_meas_ := ordline_rec_.price_unit_meas;
      catalog_no_      := ordline_rec_.catalog_no;
   ELSE   -- QUOTATION
      oqrec_          := Order_Quotation_API.Get(orderquote_no_);
      oqline_rec_     := Order_Quotation_Line_API.Get(orderquote_no_, line_no_, rel_no_, line_item_no_);      
      contract_       := oqrec_.contract;
      site_date_      := Site_API.Get_Site_Date(contract_);
      customer_no_    := oqrec_.customer_no;
      price_effectivity_date_ := nvl(oqrec_.price_effectivity_date, TRUNC(site_date_));
      currency_code_   := oqrec_.currency_code;
      price_unit_meas_ := oqline_rec_.price_unit_meas;
      catalog_no_      := oqline_rec_.catalog_no;
   END IF;
   pricing_method_ := Cust_Order_Pricing_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Pricing_Method(contract_));
   hierarchy_id_   := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);
   cust_price_group_id_ := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(customer_no_);

   OPEN  get_campaigns;
   FETCH get_campaigns BULK COLLECT INTO campaign_tab_;
   CLOSE get_campaigns;
   IF (campaign_tab_.count = 0) THEN
      RETURN NULL;
   END IF;

   << campaigns_loop >>
   FOR i IN campaign_tab_.FIRST..campaign_tab_.LAST LOOP
      << deal_loop >>
      FOR dealrec_ IN get_deals(campaign_tab_(i).campaign_id) LOOP
         -- check if valid sales part/assortment
         IF (dealrec_.catalog_no = catalog_no_ OR Assortment_Node_API.Is_Part_Belongs_To_Node(dealrec_.assortment_id, dealrec_.assortment_node_id, catalog_no_) <> 0) THEN

            IF (deal_description_ IS NULL) THEN
               deal_description_ := Sales_Promotion_Deal_API.Get_Description(campaign_tab_(i).campaign_id, dealrec_.deal_id);
            ELSE
               deal_description_ := 'MULTIPLE_DEALS';
               EXIT campaigns_loop;
            END IF;
         END IF;
      END LOOP deal_loop;  
   END LOOP campaigns_loop;   

   RETURN deal_description_;

END Get_Possible_Sales_Promo_Deal;




