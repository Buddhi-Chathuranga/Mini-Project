-----------------------------------------------------------------------------
--
--  Logical unit: RebateTransAggUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210908  ThKrlk   Bug 160477(SC21R2-2544), Modified Calculate_Total_Sales() by adding new filter agreement_id_ to get_invoice_amount CURSOR
--  201108  RasDlk   SCZ-11661, Modified Add_Prd_Stlmt_All_Parts___() and Added new methods Prd_Stlmt_Excl_Sales_Parts___(), Prd_Stlmt_Incl_Sales_Parts___().
--  201015  ErRalk   Bug 155361(SCZ-11071), Modified Add_Fin_Stlmt_All_Parts___() and Add_Prd_Stlmt_All_Parts___() to behave like sales part.  Group By statement was changed to include part_no aswell.
--  200515  ErFelk   Bug 153558(SCZ-9917), Modified Add_Prd_Stlmt_Reb_Grp___(), Add_Prd_Stlmt_Assort___(), Add_Prd_Stlmt_Sales_Part___() and Add_Prd_Stlmt_All_Parts___() by getting the rates count from rebate transaction table   
--  200515           instead of relevant tables.
--  200402  ErFelk   Bug 152189(SCZ-8768), Modified Calculate_Total_Sales() by adding sales_part_rebate_group to the WHERE clause of get_invoice_amount_all_groups cursor. 
--  170626  ErRalk   Bug 135979, Changed the AGG_ERROR message in Aggregate_Final_Settlement__ to eliminate duplication of message constant.
--  170512  AmPalk   STRMF-11637, Valid_To_Date introduced in to Rebate Agreement deals level.
--  170405  AmPalk   STRMF-10698, Corrected Calculate_Total_Sales_Part___, Calculate_Total_Sales, Calculate_Total_All_Parts___, Calculate_Total_Assort_Sales to consider totals from the customer hierarchy levels involved.
--  170405           STRMF-10698, Added Hierarchy_level_Inv_Sums, Child_Has_Reb_Trans___, Get_Min_Value___, Get_Level_Inv_Sums___, Reset_Children_Sum_Vars___.
--  170327  NiAslk   VAULT-2629, Changed REBATE_AGREEMENT_RECEIVER_TAB in from clause to REBATE_AGREEMENT_RECEIVER view in get_customer cursor to apply CRM Access to AGGREGATE_FINAL_SETTLEMENT___.
--  170325  NiAslk   VAULT-2627, Changed REBATE_AGREEMENT_RECEIVER_TAB in from clause to REBATE_AGREEMENT_RECEIVER view in get_customer cursor to apply CRM Access to AGGREGATE_PERIOD_SETTLEMENT___.
--  170325  AmPalk   STRMF-10457, Used newly added Rebate_Trans_Invoice_Amounts when calculating total invoiced amounts weigh/volume values. Join between customer_order_inv_item, rebate_transaction_tab moved to the new view. 
--  170320  ThImlk   STRMF-10226, Modified Calculate_Total_Assort_Sales(), Calculate_Total_Sales() and Calculate_Total_Sales_Part___() methods to correct the final rebate calculation logic, 
--  170320           when the final rebate basis is defined as specific assortment node or specific rebate group or specific sales part. 
--  170317  ThImlk   STRMF-10222, Modified the method, Calculate_Total_Sales() to correct the final rebate logic, when the final rebate basis is all rebate sales groups. 
--  170307  AmPalk   STRMF-6615, Altered Aggregate_Period_Settlement__ and Aggregate_Final_Settlement__ to handle multiple valid agreement list instead of a single agreement.
--  170208  AmPalk   STRMF-6864, Passed in the line number to the Rebate_Periodic_Agg_Line_API.NEW and Rebate_Final_Agg_Line_API.NEW
--  170201  ThImlk   STRMF-9389, Modified Add_Prd_Stlmt_Sales_Part___(), Add_Prd_Stlmt_All_Parts___(), Add_Prd_Stlmt_Assort___(), Add_Prd_Stlmt_Reb_Grp___(), Calculate_Total_All_Parts___, 
--  170201           Calculate_Total_Assort_Sales, Calculate_Total_Sales and Calculate_Total_Sales_Part___() to handle when multiple currencies used in company, customer order and rebate agreement. 
--  170119  NiDalk   STRSC-3939, Removed use price including vat from rebate functionality.
--  170110  ThImlk   STRMF-8404, Modified Add_Prd_Stlmt_Sales_Part___(), Add_Prd_Stlmt_All_Parts___(), Add_Prd_Stlmt_Assort___() Add_Prd_Stlmt_Reb_Grp___() to pass the minimum sales qty value
--  170110           depending on the rebate criteria when generating final settlements.
--  170110  ThImlk   STRMF-8964, Modified Add_Prd_Stlmt_Sales_Part___(), Add_Prd_Stlmt_All_Parts___(), Add_Prd_Stlmt_Assort___() Add_Prd_Stlmt_Reb_Grp___() to consider,  
--  170110           invoiced_quantity, net_weight and net_volume values when generating periodic settlements.
--  170105  ThImlk   STRMF-8400, Modified Add_Prd_Stlmt_Sales_Part___(), Add_Prd_Stlmt_All_Parts___(), Add_Prd_Stlmt_Assort___() Add_Prd_Stlmt_Reb_Grp___() to consider, periodic_rebate_amount and 
--  170105           rebate_cost_amount values when generating periodic settlements.
--  161117  ThImlk   STRMF-7700, Added methods Add_Prd_Stlmt_Sales_Part___(), Add_Prd_Stlmt_All_Parts___() and Add_Prd_Aggrigate_Lines___()
--                   and modified Aggregate_Period_Settlement__() to support additional rebate types.
--  161116  RaKalk   STRMF-7712, Added methods Calculate_Total_All_Parts___, Calculate_Total_Sales_Part___, Calculate_Final_Settlelemt___, Add_Final_Aggrigate_Lines___
--                   and modified Aggregate_Final_Settlement__ to support additional rebate types.
--  160620  NiNilk   Bug 128541, Modified Add_Prd_Stlmt_Reb_Grp___,  Add_Prd_Stlmt_Assort___, Add_Fin_Stlmt_Reb_Grp___ and Add_Fin_Stlmt_Reb_Grp___ to not create 
--  160620           aggregate lines for negative amounts.
--  160329  NiDalk   Bug 127211, Modified Add_Fin_Stlmt_Reb_Grp___ and Add_Fin_Stlmt_Assort___ to rebate amount to be summed only when period settlement is run 
--  160329           as then only it is accounted. Also added remaining_cost to rebate_final_agg_line. 
--  150917  AyAmlk   Bug 124451, Modified Add_Fin_Stlmt_Assort___() and Add_Fin_Stlmt_Reb_Grp___() in order to fetch a correct final_rebate_rate_ for a set of rebate
--  150917           transactions in a certain period. Modified Add_Prd_Stlmt_Assort___() and Add_Prd_Stlmt_Reb_Grp___() in order to fetch a correct rebate_rate_
--  150917           for a set of rebate transactions in a certain period.
--  130411  AyAmlk   Bug 109396, Modified Aggregate_Period_Settlement__() and Aggregate_Final_Settlement__() so that the system can handle wildcard for Agreement ID and Customer No.
--  130213  ShKolk   Modified Aggregate_Period_Settlement__ and Aggregate_Final_Settlement__ to create seperate aggregates for each use_price_incl_tax setting.
--  130213  ShKolk   Modified Add_Prd_Stlmt_Assort___, Add_Prd_Stlmt_Reb_Grp___, Add_Fin_Stlmt_Reb_Grp___ and Add_Fin_Stlmt_Assort___  to consider gross amounts and use_price_incl_tax.
--  130213           Modified Calculate_Total_Sales and Calculate_Total_Assort_Sales to consider use_price_incl_tax.
--  121003  AyAmlk   Bug 105532, Modified REBATE_SETTLEMENT_HEADS by adding a WHERE clause to select records of all companies connected to user.
--  110823  NWeelk   Bug 96116, Modified methods Add_Prd_Stlmt_Reb_Grp___ and Add_Prd_Stlmt_Assort___ by setting null 
--  110823           to rebate_rate_ and rebate_cost_rate_ if there are multiple rates defined.  
--  110817  AmPalk   Bug 95443, Modified Add_Fin_Stlmt_Assort___ and Add_Fin_Stlmt_Reb_Grp___ by adding a condition 
--  110817           to check if a final rebate% defined for the transaction prior including a final rebate aggregation line.
--  110429  ChJalk   Modified Calculate_Total_Assort_Sales to get correct percentages when calculating the final settlement when using assortment based agreements. 
--  110427  ChJalk   Modified Calculate_Total_Sales to get correct percentages when calculating the final settlement. 
--  100526  NaLrlk   Changed the method call Ord_Process_Status_API to Rebate_Process_Status_API that it used.
--  100308  NaLrlk   Modified the method Calculate_Total_Sales and Calculate_Total_Assort_Sales to correct the db values for sales_rebate_basic and sales_rebate_basic_assort.
--  091228  AmPalk   Bug 85942, Valid From became a key on agreement lines.  Modified filtering logic in Calculate_Total_Sales and in Calculate_Total_Assort_Sales. 
--  091228           Modified Aggregate_Final_Settlement__ by rearranging logic to handle period start end dates, in a similar way done in Aggregate_Period_Settlement__ under 85817.
--  091104  AmPalk   Bug 85817, Rearranged code in Aggregate_Period_Settlement__ to correctly pick start .. end dates for settlements.
--  091104           Added Add_Prd_Stlmt_Reb_Grp___ and Add_Prd_Stlmt_Assort___.
--  091120  RiLase   Added agr_company_error_ exception to Aggregate_Final_Settlement__ and Aggregate_Periodic_Settlement__.
--  090731  HimRlk   Merged Bug 81245, restructured the Cursors get_invoice_amount, get_invoice_amount_children, get_invoice_amount_all_groups, 
--  090731           get_inv_amount_all_group_child, get_invoice_amount_all_sales and get_inv_amount_all_sales_child in 
--  090731           Methods Calculate_Total_Sales and Calculate_Total_Assort_Sales.
--  090731  HimRlk   Merged Bug 81261, Modified the CURSORS get_rebate_trans, get_rebate_trans_assort, get_rates and get_rates_assort 
--  090731           in Aggregate_Period_Settlement__ to consider the agreement_id when retrieving data.
--  090128  MiKulk   Modified the methods Aggregate_Final_Settlement__ and Aggregate_Period_Settlement__ by adding a condition to
--  090128           Exclude the rebate transactions being aggregated, if the customer doens't have valid transactions for the period.
--  081022  JeLise   Changed the order of the parameters in calls to Rebate_Agr_Assort_Final_API.Get_Final_Rebate in 
--  081022           Calculate_Total_Assort_Sales.
--  081021  JeLise   Changed cursors for calculation in Calculate_Total_Sales and Calculate_Total_Assort_Sales.
--  081021           Also added nvl's in calls to Rebate_Final_Agg_Line_API.New and Rebate_Periodic_Agg_Line_API.New.
--  081015  JeLise   Added check on aggregation_no in Aggregate_Period_Settlement__ and Aggregate_Final_Settlement__.
--  081014  JeLise   Added invoice_id and item_id in call to Rebate_Transaction_Util_API.Add_Final_Rebate in 
--  081014           Calculate_Total_Sales and Calculate_Total_Assort_Sales.
--  080623  AmPalk   Changed REBATE_SETTLEMENT_HEADS by adding invoiced_net_amount and total_rebate_cost_amount and unconsumed_rebate_costs.
--  080530  JeLise   Added FINAL_SETTLEMENT in Process_Rebate_Settlements__ and Get_Total_Amount_To_Invoice in view.
--  080529  JeLise   Added final_settlement_ in Process_Rebate_Settlements__ and added view REBATE_SETTLEMENT_HEADS.
--  080520  JeLise   Added method Calculate_Total_Assort_Sales and removed customer_order_inv_head from
--  080520           cursors in Calculate_Total_Sales.
--  080514  JeLise   Added code to handle 'Create and Print Invoice' in Start_Create_Rebate_Cre_Inv and
--  080514           Process_Rebate_Settlements__.
--  080430  ShVese   Changed the call to Process_Rebate_Settlements__.
--  080428  JeLise   Removed check on assortment_id in cursors get_invoice_amount_all_sales and get_inv_amount_all_sales_child
--  080428           in Calculate_Total_Sales.
--  080424  JeLise   Changed from incl_in_period_settlement to period_aggregation_no in Aggregate_Period_Settlement__
--  080424           and from incl_in_final_settlement to final_aggregation_no in Aggregate_Final_Settlement__.
--  080424  RiLase   Added PROCEDURE Process_Rebate_Settlements__ and PROCEDURE Start_Create_Rebate_Cre_Inv.
--  080423  JeLise   Added checks on if the agreement has lines for children in Calculate_Total_Sales.
--  080417  JeLise   Added methods Aggregate_Period_Settlement and Aggregate_Final_Settlement and made minor changes in Get_Date_From.
--  080414  JeLise   Added method Calculate_Total_Sales.
--  080409  JeLise   Added method Aggregate_Final_Settlement__ and renamed Get_Period_Date_From and Get_Period_Date_Until
--  080409           to Get_Date_From and Get_Date_Until.
--  080409  JeLise   Added savepoint in Aggregate_Period_Settlement__.
--  080404  JeLise   Added check on company and join with rebate_agreement_tab in cursor get_customers
--  080404           in Aggregate_Period_Settlement__.
--  080404  Mikulk   Corrected the method Aggregate_Period_Settlement__ to avoid compilation errors.
--  080403  JeLise   Added check on company in cursor get_customers in Aggregate_Period_Settlement__.
--  080331  JeLise   Changed some of the cursors and loops in Aggregate_Period_Settlement__.
--  080324  KiSalk   Renamed Aggregate_Periodic_Settlement__ as Aggregate_Period_Settlement__
--  080317  JeLise   Removed hierarchy_id, customer_level and from_date as "in parameters" to
--  080317           Aggregate_Periodic_Settlement__.
--  080226  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------
TYPE Level_Invoice_Sums IS RECORD (
child_level_         NUMBER,
inv_amount_child_    NUMBER, 
inv_qty_child_       NUMBER, 
net_weight_child_    NUMBER, 
net_volume_child_    NUMBER, 
inv_curr_amt_child_  NUMBER
);

TYPE Hierarchy_level_Inv_Sums IS TABLE OF Level_Invoice_Sums
  INDEX BY PLS_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Final_Aggr_Line_No___ (
   aggregation_no_ IN NUMBER ) RETURN NUMBER
IS
   last_line_no_ NUMBER;
   CURSOR get_last_line_no IS
      SELECT NVL(MAX(line_no), 0)
      FROM   REBATE_FINAL_AGG_LINE_TAB
      WHERE  aggregation_no = aggregation_no_;
BEGIN
   OPEN get_last_line_no;
   FETCH get_last_line_no INTO last_line_no_;
   CLOSE get_last_line_no;
   RETURN last_line_no_ + 1;
END Get_Final_Aggr_Line_No___;

FUNCTION Get_Periodic_Aggr_Line_No___ (
   aggregation_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   last_line_no_ NUMBER;
   CURSOR get_last_line_no IS
      SELECT NVL(MAX(line_no), 0)
      FROM   REBATE_PERIODIC_AGG_LINE_TAB
      WHERE  aggregation_no = aggregation_no_;
BEGIN
   OPEN get_last_line_no;
   FETCH get_last_line_no INTO last_line_no_;
   CLOSE get_last_line_no;
   RETURN last_line_no_ + 1;
END Get_Periodic_Aggr_Line_No___;

-- Add_Prd_Stlmt_Reb_Grp___
--   Group and create settlment lines for periodic aggregation lines from sales part rebate group
PROCEDURE Add_Prd_Stlmt_Reb_Grp___ (
   lines_created_      IN OUT BOOLEAN,
   aggr_ran_empty_     IN OUT BOOLEAN,
   company_            IN     VARCHAR2,
   cust_agreement_id_  IN     VARCHAR2,
   customer_no_        IN     VARCHAR2,
   aggregation_no_     IN     NUMBER,
   start_date_         IN     DATE,
   end_date_           IN     DATE )
IS
   rebate_rate_            NUMBER;
   rebate_cost_rate_       NUMBER;
   periodic_rebate_amount_ NUMBER;
   rebate_cost_amount_     NUMBER;   
   periodic_aggr_line_no_  NUMBER;
   rebate_rate_count_      NUMBER;
   rebate_cost_rate_count_ NUMBER;  
   periodic_rebate_amount_count_ NUMBER;
   rebate_cost_amount_count_     NUMBER;
      
   -- Group and sum the transactions for sales part rebate groups
   CURSOR get_rebate_trans IS
      SELECT rebate_type, sales_part_rebate_group, hierarchy_id, customer_level, tax_code,
            SUM(total_rebate_amount) rebate_amount_sum, SUM(total_rebate_cost_amount) rebate_cost_amount_sum,
            SUM(inv_line_sales_amount) inv_line_sales_amount_sum, SUM(inv_line_sales_gross_amount) inv_line_sales_gro_amount_sum,
            SUM(inv_line_sales_curr_amount) inv_line_sales_curr_amount_sum, SUM(inv_lin_sale_gros_curr_amt) inv_li_sale_gro_curr_amt_sum,
            SUM(invoiced_quantity) invoiced_quantity_sum, SUM(net_weight) net_weight_sum, SUM(net_volume) net_volume_sum
      FROM rebate_transaction_tab
      WHERE customer_no = customer_no_
      AND   company = company_
      AND   agreement_id = cust_agreement_id_
      AND   assortment_id IS NULL
      AND   agreement_type = Rebate_Agreement_Type_API.DB_REBATE_GROUP 
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL
      AND   rebate_type != '*'
      GROUP BY rebate_type, sales_part_rebate_group, hierarchy_id, customer_level, tax_code;

   -- Get the count of rebate rates for sales part rebate group.
   CURSOR get_rates_count (hierarchy_id_            IN VARCHAR2,
                           customer_level_          IN VARCHAR2,
                           sales_part_rebate_group_ IN VARCHAR2,
                           rebate_type_             IN VARCHAR2) IS
         SELECT count(distinct(rebate_rate)), count(distinct(rebate_cost_rate)), count(distinct(periodic_rebate_amount)),
                count(distinct(rebate_cost_amount))
         FROM rebate_transaction_tab
         WHERE company = company_
         AND   customer_no = customer_no_
         AND   agreement_id = cust_agreement_id_
         AND   hierarchy_id = hierarchy_id_
         AND   customer_level = customer_level_
         AND   sales_part_rebate_group = sales_part_rebate_group_
         AND   rebate_type = rebate_type_
         AND   transaction_date BETWEEN start_date_ AND end_date_
         AND   period_aggregation_no IS NULL
         AND   final_aggregation_no IS NULL;

   -- Get the rebate rates for sales part rebate group
   CURSOR get_rates (hierarchy_id_            IN VARCHAR2,
                     customer_level_          IN VARCHAR2,
                     sales_part_rebate_group_ IN VARCHAR2,
                     rebate_type_             IN VARCHAR2) IS
      SELECT rebate_rate, rebate_cost_rate, periodic_rebate_amount, rebate_cost_amount
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = cust_agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   sales_part_rebate_group = sales_part_rebate_group_
      AND   rebate_type = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL;
BEGIN
   FOR agg_rec_ IN get_rebate_trans() LOOP
      IF agg_rec_.rebate_amount_sum >= 0 THEN
         OPEN get_rates_count(agg_rec_.hierarchy_id, agg_rec_.customer_level,
                           agg_rec_.sales_part_rebate_group, agg_rec_.rebate_type);
         FETCH get_rates_count INTO rebate_rate_count_, rebate_cost_rate_count_, periodic_rebate_amount_count_, rebate_cost_amount_count_;
         CLOSE get_rates_count;
         IF (((NVL(rebate_rate_count_, 0) = 1) AND (NVL(rebate_cost_rate_count_, 0) = 1)) OR 
            ((NVL(periodic_rebate_amount_count_, 0) = 1) AND (NVL(rebate_cost_amount_count_, 0) = 1))) THEN
            -- Get rebate_rate and rebate_cost_rate
            OPEN get_rates(agg_rec_.hierarchy_id, agg_rec_.customer_level,
                        agg_rec_.sales_part_rebate_group, agg_rec_.rebate_type);
            FETCH get_rates INTO rebate_rate_, rebate_cost_rate_, periodic_rebate_amount_, rebate_cost_amount_;
            CLOSE get_rates;
         ELSE
            -- If there are multiple rates defined the rates will be set to NULL.
            rebate_rate_            := NULL;
            rebate_cost_rate_       := NULL;
            periodic_rebate_amount_ := NULL;
            rebate_cost_amount_     := NULL;
         END IF;
         periodic_aggr_line_no_ := Get_Periodic_Aggr_Line_No___(aggregation_no_);
         -- Create aggregation lines
         Rebate_Periodic_Agg_Line_API.NEW(aggregation_no_,
                                       periodic_aggr_line_no_,
                                       agg_rec_.hierarchy_id,
                                       agg_rec_.customer_level,
                                       agg_rec_.sales_part_rebate_group,
                                       NULL,    -- assortment_id
                                       NULL,    -- assortment_node_id
                                       NULL,    -- part_no
                                       agg_rec_.rebate_type,
                                       agg_rec_.tax_code,
                                       rebate_rate_,
                                       rebate_cost_rate_,
                                       agg_rec_.rebate_amount_sum,
                                       agg_rec_.rebate_cost_amount_sum,
                                       nvl(agg_rec_.inv_line_sales_amount_sum, 0),
                                       nvl(agg_rec_.inv_line_sales_gro_amount_sum, 0),
                                       periodic_rebate_amount_,
                                       rebate_cost_amount_,
                                       nvl(agg_rec_.invoiced_quantity_sum,0),
                                       nvl(agg_rec_.net_weight_sum,0),
                                       nvl(agg_rec_.net_volume_sum,0),
                                       nvl(agg_rec_.inv_line_sales_curr_amount_sum, 0),
                                       nvl(agg_rec_.inv_li_sale_gro_curr_amt_sum, 0));
         -- Set the transactions to 'included in periodic settlement'
         Rebate_Transaction_Util_API.Set_Incl_In_Period_Settlement(cust_agreement_id_,
                                                                customer_no_,
                                                                agg_rec_.hierarchy_id,
                                                                agg_rec_.customer_level,
                                                                agg_rec_.sales_part_rebate_group,
                                                                NULL,    -- assortment_id
                                                                NULL,    -- assortment_node_id
                                                                NULL,    --part_no
                                                                NULL,    --sales_unit_meas
                                                                agg_rec_.rebate_type,
                                                                agg_rec_.tax_code,
                                                                start_date_,
                                                                end_date_,
                                                                aggregation_no_,
                                                                periodic_aggr_line_no_);
                                                                
         lines_created_  := TRUE;
         aggr_ran_empty_ := FALSE;
      END IF;    
   END LOOP;
END Add_Prd_Stlmt_Reb_Grp___;


-- Add_Prd_Stlmt_Assort___
--   Group and create settlment lines for periodic aggregation lines from assortments
PROCEDURE Add_Prd_Stlmt_Assort___ (
   lines_created_      IN OUT BOOLEAN,
   aggr_ran_empty_     IN OUT BOOLEAN,
   company_            IN     VARCHAR2,
   cust_agreement_id_  IN     VARCHAR2,
   customer_no_        IN     VARCHAR2,
   aggregation_no_     IN     NUMBER,
   start_date_         IN     DATE,
   end_date_           IN     DATE )
IS
   rebate_rate_            NUMBER;
   rebate_cost_rate_       NUMBER;
   periodic_rebate_amount_ NUMBER;
   rebate_cost_amount_     NUMBER;   
   periodic_aggr_line_no_  NUMBER;
   rebate_rate_count_      NUMBER;
   rebate_cost_rate_count_ NUMBER;
   periodic_rebate_amount_count_ NUMBER;
   rebate_cost_amount_count_     NUMBER;
   
   -- Group and sum the transactions for assortments
   CURSOR get_rebate_trans_assort IS
      SELECT rebate_type, assortment_id, assortment_node_id, hierarchy_id, customer_level, tax_code,
            SUM(total_rebate_amount) rebate_amount_sum, SUM(total_rebate_cost_amount) rebate_cost_amount_sum,
            SUM(inv_line_sales_amount) inv_line_sales_amount_sum, SUM(inv_line_sales_gross_amount) inv_line_sales_gro_amount_sum,
            SUM(inv_line_sales_curr_amount) inv_line_sales_curr_amount_sum, SUM(inv_lin_sale_gros_curr_amt) inv_li_sale_gro_curr_amt_sum,
            SUM(invoiced_quantity) invoiced_quantity_sum, SUM(net_weight) net_weight_sum, SUM(net_volume) net_volume_sum
      FROM  rebate_transaction_tab
      WHERE customer_no = customer_no_
      AND   company = company_
      AND   agreement_id = cust_agreement_id_
      AND   assortment_id IS NOT NULL
      AND   agreement_type = Rebate_Agreement_Type_API.DB_ASSORTMENT 
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL
      AND   rebate_type != '*'
      GROUP BY rebate_type, assortment_id, assortment_node_id, hierarchy_id, customer_level, tax_code;

   -- Get the count of rebates rates for assortment.
   CURSOR get_rates_assort_count (hierarchy_id_       IN VARCHAR2,
                                  customer_level_     IN VARCHAR2,
                                  assortment_id_      IN VARCHAR2,
                                  assortment_node_id_ IN VARCHAR2,
                                  rebate_type_        IN VARCHAR2) IS
      SELECT count(distinct(rebate_rate)), count(distinct(rebate_cost_rate)), count(distinct(periodic_rebate_amount)), 
             count(distinct(rebate_cost_amount))
      FROM   rebate_transaction_tab
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = cust_agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_
      AND   rebate_type = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL;
   
   -- Get the rebate rates for assortment
   CURSOR get_rates_assort (hierarchy_id_       IN VARCHAR2,
                            customer_level_     IN VARCHAR2,
                            assortment_id_      IN VARCHAR2,
                            assortment_node_id_ IN VARCHAR2,
                            rebate_type_        IN VARCHAR2) IS
      SELECT rebate_rate, rebate_cost_rate, periodic_rebate_amount, rebate_cost_amount
      FROM   rebate_transaction_tab
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = cust_agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_
      AND   rebate_type = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL;
BEGIN
   FOR agg_assort_rec_ IN get_rebate_trans_assort() LOOP
      IF agg_assort_rec_.rebate_amount_sum >= 0 THEN
         OPEN get_rates_assort_count(agg_assort_rec_.hierarchy_id, agg_assort_rec_.customer_level,
                                  agg_assort_rec_.assortment_id, agg_assort_rec_.assortment_node_id, agg_assort_rec_.rebate_type);
         FETCH get_rates_assort_count INTO rebate_rate_count_, rebate_cost_rate_count_, periodic_rebate_amount_count_, rebate_cost_amount_count_;
         CLOSE get_rates_assort_count;
         
         IF (((NVL(rebate_rate_count_, 0) = 1) AND (NVL(rebate_cost_rate_count_, 0) = 1)) OR 
            ((NVL(periodic_rebate_amount_count_, 0) = 1) AND (NVL(rebate_cost_amount_count_, 0) = 1))) THEN
            -- Get rebate_rate and rebate_cost_rate
            OPEN get_rates_assort(agg_assort_rec_.hierarchy_id, agg_assort_rec_.customer_level,
                               agg_assort_rec_.assortment_id, agg_assort_rec_.assortment_node_id, agg_assort_rec_.rebate_type);
            FETCH get_rates_assort INTO rebate_rate_, rebate_cost_rate_, periodic_rebate_amount_, rebate_cost_amount_;
            CLOSE get_rates_assort;
         ELSE
            -- If there are multiple rates defined the rates will be set to NULL.
            rebate_rate_            := NULL;
            rebate_cost_rate_       := NULL;
            periodic_rebate_amount_ := NULL;
            rebate_cost_amount_     := NULL;
         END IF;
         periodic_aggr_line_no_ := Get_Periodic_Aggr_Line_No___(aggregation_no_);
         -- Create aggregation lines
         Rebate_Periodic_Agg_Line_API.New(aggregation_no_,
                                       periodic_aggr_line_no_,
                                       agg_assort_rec_.hierarchy_id,
                                       agg_assort_rec_.customer_level,
                                       NULL,    --sales_part_rebate_group
                                       agg_assort_rec_.assortment_id,
                                       agg_assort_rec_.assortment_node_id,
                                       NULL,    --part_no
                                       agg_assort_rec_.rebate_type,
                                       agg_assort_rec_.tax_code,
                                       rebate_rate_,
                                       rebate_cost_rate_,
                                       agg_assort_rec_.rebate_amount_sum,
                                       agg_assort_rec_.rebate_cost_amount_sum,
                                       nvl(agg_assort_rec_.inv_line_sales_amount_sum, 0),
                                       nvl(agg_assort_rec_.inv_line_sales_gro_amount_sum, 0),
                                       periodic_rebate_amount_,
                                       rebate_cost_amount_,
                                       nvl(agg_assort_rec_.invoiced_quantity_sum,0),
                                       nvl(agg_assort_rec_.net_weight_sum,0),
                                       nvl(agg_assort_rec_.net_volume_sum,0),
                                       nvl(agg_assort_rec_.inv_line_sales_curr_amount_sum, 0),
                                       nvl(agg_assort_rec_.inv_li_sale_gro_curr_amt_sum, 0));
 

         -- Set the transactions to 'included in periodic settlement'
         Rebate_Transaction_Util_API.Set_Incl_In_Period_Settlement(cust_agreement_id_,
                                                                customer_no_,
                                                                agg_assort_rec_.hierarchy_id,
                                                                agg_assort_rec_.customer_level,
                                                                NULL,    --sales_part_rebate_group
                                                                agg_assort_rec_.assortment_id,
                                                                agg_assort_rec_.assortment_node_id,
                                                                NULL,    --part_no
                                                                NULL,    --sales_unit_meas
                                                                agg_assort_rec_.rebate_type,
                                                                agg_assort_rec_.tax_code,
                                                                start_date_,
                                                                end_date_,
                                                                aggregation_no_,
                                                                periodic_aggr_line_no_);
         lines_created_  := TRUE;
         aggr_ran_empty_ := FALSE;
      END IF;   
   END LOOP;
END Add_Prd_Stlmt_Assort___;

-- Add_Prd_Stlmt_Sales_Part___
--   Group and create settlment lines for periodic aggregation lines from sales part
PROCEDURE Add_Prd_Stlmt_Sales_Part___ (
   lines_created_      IN OUT BOOLEAN,
   aggr_ran_empty_     IN OUT BOOLEAN,
   company_            IN     VARCHAR2,
   cust_agreement_id_  IN     VARCHAR2,
   customer_no_        IN     VARCHAR2,
   aggregation_no_     IN     NUMBER,
   start_date_         IN     DATE,
   end_date_           IN     DATE )
IS
   rebate_rate_            NUMBER;
   rebate_cost_rate_       NUMBER;
   periodic_rebate_amount_ NUMBER;
   rebate_cost_amount_     NUMBER;   
   periodic_aggr_line_no_  NUMBER;
   rebate_rate_count_      NUMBER;
   rebate_cost_rate_count_ NUMBER;
   periodic_rebate_amount_count_ NUMBER;
   rebate_cost_amount_count_     NUMBER;
   
   -- Group and sum the transactions for sales part
   CURSOR get_rebate_trans IS
      SELECT rebate_type, part_no, sales_unit_meas, hierarchy_id, customer_level, tax_code,
            SUM(total_rebate_amount) rebate_amount_sum, SUM(total_rebate_cost_amount) rebate_cost_amount_sum,
            SUM(inv_line_sales_amount) inv_line_sales_amount_sum, SUM(inv_line_sales_gross_amount) inv_line_sales_gro_amount_sum,
            SUM(inv_line_sales_curr_amount) inv_line_sales_curr_amount_sum, SUM(inv_lin_sale_gros_curr_amt) inv_li_sale_gro_curr_amt_sum,
            SUM(invoiced_quantity) invoiced_quantity_sum, SUM(net_weight) net_weight_sum, SUM(net_volume) net_volume_sum
      FROM rebate_transaction_tab
      WHERE customer_no = customer_no_
      AND   company = company_
      AND   agreement_id = cust_agreement_id_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_SALES_PART 
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL
      AND   rebate_type != '*'
      GROUP BY rebate_type, part_no, sales_unit_meas, hierarchy_id, customer_level, tax_code;
   
   -- Get the count of rebate rates for sales part.
   CURSOR get_rates_count (hierarchy_id_            IN VARCHAR2,
                           customer_level_          IN VARCHAR2,
                           part_no_                 IN VARCHAR2,
                           sales_unit_meas_         IN VARCHAR2,
                           rebate_type_             IN VARCHAR2) IS
      SELECT count(distinct(rebate_rate)), count(distinct(rebate_cost_rate)), count(distinct(periodic_rebate_amount)),
             count(distinct(rebate_cost_amount))  
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = cust_agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   part_no = part_no_
      AND   sales_unit_meas = sales_unit_meas_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_SALES_PART
      AND   rebate_type = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL;

   -- Get the rebate rates for sales part
   CURSOR get_rates (hierarchy_id_            IN VARCHAR2,
                     customer_level_          IN VARCHAR2,
                     part_no_                 IN VARCHAR2,
                     sales_unit_meas_         IN VARCHAR2,
                     rebate_type_             IN VARCHAR2) IS
      SELECT rebate_rate, rebate_cost_rate, periodic_rebate_amount, rebate_cost_amount  
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = cust_agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   part_no = part_no_
      AND   sales_unit_meas = sales_unit_meas_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_SALES_PART
      AND   rebate_type = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL;      

BEGIN
   FOR agg_rec_ IN get_rebate_trans() LOOP
      IF agg_rec_.rebate_amount_sum >= 0 THEN
         OPEN get_rates_count(agg_rec_.hierarchy_id, agg_rec_.customer_level,
                              agg_rec_.part_no, agg_rec_.sales_unit_meas, agg_rec_.rebate_type);
         FETCH get_rates_count INTO rebate_rate_count_, rebate_cost_rate_count_, periodic_rebate_amount_count_, rebate_cost_amount_count_;
         CLOSE get_rates_count;

         IF (((NVL(rebate_rate_count_, 0) = 1) AND (NVL(rebate_cost_rate_count_, 0) = 1)) OR 
            ((NVL(periodic_rebate_amount_count_, 0) = 1) AND (NVL(rebate_cost_amount_count_, 0) = 1))) THEN
            -- Get rebate_rate and rebate_cost_rate
            OPEN get_rates(agg_rec_.hierarchy_id, agg_rec_.customer_level,
                        agg_rec_.part_no, agg_rec_.sales_unit_meas, agg_rec_.rebate_type);
            FETCH get_rates INTO rebate_rate_, rebate_cost_rate_, periodic_rebate_amount_, rebate_cost_amount_;
            CLOSE get_rates;
         ELSE
            -- If there are multiple rates defined the rates will be set to NULL.
            rebate_rate_            := NULL;
            rebate_cost_rate_       := NULL;
            periodic_rebate_amount_ := NULL;
            rebate_cost_amount_     := NULL;
         END IF;
         periodic_aggr_line_no_ := Get_Periodic_Aggr_Line_No___(aggregation_no_);
         -- Create aggregation lines
         Rebate_Periodic_Agg_Line_API.NEW(aggregation_no_,
                                       periodic_aggr_line_no_,
                                       agg_rec_.hierarchy_id,
                                       agg_rec_.customer_level,
                                       NULL,    --sales_part_rebate_group
                                       NULL,    -- assortment_id
                                       NULL,    -- assortment_node_id
                                       agg_rec_.part_no,    
                                       agg_rec_.rebate_type,
                                       agg_rec_.tax_code,
                                       rebate_rate_,
                                       rebate_cost_rate_,
                                       agg_rec_.rebate_amount_sum,
                                       agg_rec_.rebate_cost_amount_sum,
                                       nvl(agg_rec_.inv_line_sales_amount_sum, 0),
                                       nvl(agg_rec_.inv_line_sales_gro_amount_sum, 0),
                                       periodic_rebate_amount_,
                                       rebate_cost_amount_,
                                       nvl(agg_rec_.invoiced_quantity_sum,0),
                                       nvl(agg_rec_.net_weight_sum,0),
                                       nvl(agg_rec_.net_volume_sum,0),
                                       nvl(agg_rec_.inv_line_sales_curr_amount_sum, 0),
                                       nvl(agg_rec_.inv_li_sale_gro_curr_amt_sum, 0));
                                       
         -- Set the transactions to 'included in periodic settlement'
         Rebate_Transaction_Util_API.Set_Incl_In_Period_Settlement(cust_agreement_id_,
                                                                customer_no_,
                                                                agg_rec_.hierarchy_id,
                                                                agg_rec_.customer_level,
                                                                NULL,    --sales_part_rebate_group
                                                                NULL,    -- assortment_id
                                                                NULL,    -- assortment_node_id
                                                                agg_rec_.part_no,
                                                                agg_rec_.sales_unit_meas,
                                                                agg_rec_.rebate_type,
                                                                agg_rec_.tax_code,
                                                                start_date_,
                                                                end_date_,
                                                                aggregation_no_,
                                                                periodic_aggr_line_no_);
         lines_created_  := TRUE;
         aggr_ran_empty_ := FALSE;
      END IF;   
   END LOOP;
END Add_Prd_Stlmt_Sales_Part___;

PROCEDURE Add_Prd_Stlmt_All_Parts___ (
   lines_created_             IN OUT BOOLEAN,
   aggregation_ran_empty_     IN OUT BOOLEAN,
   company_                   IN     VARCHAR2,
   agreement_id_              IN     VARCHAR2,
   customer_no_               IN     VARCHAR2,
   aggregation_no_            IN     NUMBER,
   start_date_                IN     DATE,
   end_date_                  IN     DATE )
IS
BEGIN
   -- Group and create aggregation lines When Including sales parts
   Prd_Stlmt_Incl_Sales_Parts___(lines_created_, aggregation_ran_empty_, company_, agreement_id_, customer_no_, aggregation_no_, start_date_, end_date_);
   -- Group and create aggregation lines when Excluding sales parts (create for all parts)
   Prd_Stlmt_Excl_Sales_Parts___(lines_created_, aggregation_ran_empty_, company_, agreement_id_, customer_no_, aggregation_no_, start_date_, end_date_); 
END Add_Prd_Stlmt_All_Parts___;

-- Prd_Stlmt_Incl_Sales_Parts___
--   Group and create settlment lines for periodic aggregation lines when Including sales parts.
PROCEDURE Prd_Stlmt_Incl_Sales_Parts___ (
   lines_created_      IN OUT BOOLEAN,
   aggr_ran_empty_     IN OUT BOOLEAN,
   company_            IN     VARCHAR2,
   cust_agreement_id_  IN     VARCHAR2,
   customer_no_        IN     VARCHAR2,
   aggregation_no_     IN     NUMBER,
   start_date_         IN     DATE,
   end_date_           IN     DATE )
IS
   rebate_rate_                  NUMBER;
   rebate_cost_rate_             NUMBER;
   periodic_rebate_amount_       NUMBER;
   rebate_cost_amount_           NUMBER;   
   periodic_aggr_line_no_        NUMBER;
   rebate_rate_count_            NUMBER;
   rebate_cost_rate_count_       NUMBER;
   periodic_rebate_amount_count_ NUMBER;
   rebate_cost_amount_count_     NUMBER;
   all_sales_part_level_         VARCHAR2(18);
   
   -- Group and sum the transactions for sales parts
   CURSOR get_rebate_trans IS
      SELECT rebate_type, part_no, hierarchy_id, customer_level, tax_code,
            SUM(total_rebate_amount) rebate_amount_sum, SUM(total_rebate_cost_amount) rebate_cost_amount_sum,
            SUM(inv_line_sales_amount) inv_line_sales_amount_sum, SUM(inv_line_sales_gross_amount) inv_line_sales_gro_amount_sum,
            SUM(inv_line_sales_curr_amount) inv_line_sales_curr_amount_sum, SUM(inv_lin_sale_gros_curr_amt) inv_li_sale_gro_curr_amt_sum,
            SUM(invoiced_quantity) invoiced_quantity_sum, SUM(net_weight) net_weight_sum, SUM(net_volume) net_volume_sum
      FROM rebate_transaction_tab
      WHERE customer_no = customer_no_
      AND   company = company_
      AND   agreement_id = cust_agreement_id_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_ALL
      AND   all_sales_part_level_ = Rebate_All_Sales_Level_API.DB_INCLUDE_SALES_PART
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL 
      AND   rebate_type != '*'
      GROUP BY rebate_type, part_no, hierarchy_id, customer_level, tax_code;
   
   -- Get the count of rebate rates for sales parts.
   CURSOR get_rates_count (hierarchy_id_            IN VARCHAR2,
                           customer_level_          IN VARCHAR2,
                           rebate_type_             IN VARCHAR2) IS
      SELECT count(distinct(rebate_rate)), count(distinct(rebate_cost_rate)), count(distinct(periodic_rebate_amount)),
             count(distinct(rebate_cost_amount))
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = cust_agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_ALL
      AND   all_sales_part_level_ = Rebate_All_Sales_Level_API.DB_INCLUDE_SALES_PART
      AND   rebate_type = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL;

   -- Get the rebate rates for sales parts
   CURSOR get_rates (hierarchy_id_            IN VARCHAR2,
                     customer_level_          IN VARCHAR2,
                     rebate_type_             IN VARCHAR2) IS
      SELECT rebate_rate, rebate_cost_rate, periodic_rebate_amount, rebate_cost_amount
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = cust_agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_ALL
      AND   all_sales_part_level_ = Rebate_All_Sales_Level_API.DB_INCLUDE_SALES_PART
      AND   rebate_type = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL;      

BEGIN
   all_sales_part_level_ := Rebate_Agreement_API.Get_All_Sales_Part_Level_Db(cust_agreement_id_);
   FOR agg_rec_ IN get_rebate_trans() LOOP
      IF agg_rec_.rebate_amount_sum >= 0 THEN
         OPEN get_rates_count(agg_rec_.hierarchy_id, agg_rec_.customer_level,
                              agg_rec_.rebate_type);
         FETCH get_rates_count INTO rebate_rate_count_, rebate_cost_rate_count_, periodic_rebate_amount_count_, rebate_cost_amount_count_;
         CLOSE get_rates_count;

         IF (((NVL(rebate_rate_count_, 0) = 1) AND (NVL(rebate_cost_rate_count_, 0) = 1)) OR 
            ((NVL(periodic_rebate_amount_count_, 0) = 1) AND (NVL(rebate_cost_amount_count_, 0) = 1))) THEN
            -- Get rebate_rate and rebate_cost_rate
            OPEN get_rates(agg_rec_.hierarchy_id, agg_rec_.customer_level, agg_rec_.rebate_type);
            FETCH get_rates INTO rebate_rate_, rebate_cost_rate_, periodic_rebate_amount_, rebate_cost_amount_;
            CLOSE get_rates;
         ELSE
            -- If there are multiple rates defined the rates will be set to NULL.
            rebate_rate_            := NULL;
            rebate_cost_rate_       := NULL;
            periodic_rebate_amount_ := NULL;
            rebate_cost_amount_     := NULL;
         END IF;
         periodic_aggr_line_no_ := Get_Periodic_Aggr_Line_No___(aggregation_no_);
         -- Create aggregation lines
         Rebate_Periodic_Agg_Line_API.NEW(aggregation_no_,
                                          periodic_aggr_line_no_,
                                          agg_rec_.hierarchy_id,
                                          agg_rec_.customer_level,
                                          NULL,    --sales_part_rebate_group
                                          NULL,    -- assortment_id
                                          NULL,    -- assortment_node_id
                                          agg_rec_.part_no,    
                                          agg_rec_.rebate_type,
                                          agg_rec_.tax_code,
                                          rebate_rate_,
                                          rebate_cost_rate_,
                                          agg_rec_.rebate_amount_sum,
                                          agg_rec_.rebate_cost_amount_sum,
                                          nvl(agg_rec_.inv_line_sales_amount_sum, 0),
                                          nvl(agg_rec_.inv_line_sales_gro_amount_sum, 0),
                                          periodic_rebate_amount_,
                                          rebate_cost_amount_,
                                          nvl(agg_rec_.invoiced_quantity_sum,0),
                                          nvl(agg_rec_.net_weight_sum,0),
                                          nvl(agg_rec_.net_volume_sum,0),
                                          nvl(agg_rec_.inv_line_sales_curr_amount_sum, 0),
                                          nvl(agg_rec_.inv_li_sale_gro_curr_amt_sum, 0));
    
                                       
         -- Set the transactions to 'included in periodic settlement'
         Rebate_Transaction_Util_API.Set_Incl_In_Period_Settlement(cust_agreement_id_,
                                                                customer_no_,
                                                                agg_rec_.hierarchy_id,
                                                                agg_rec_.customer_level,
                                                                NULL,    --sales_part_rebate_group
                                                                NULL,    -- assortment_id
                                                                NULL,    -- assortment_node_id
                                                                agg_rec_.part_no,
                                                                NULL,    -- sales_unit_meas                                                               
                                                                agg_rec_.rebate_type,
                                                                agg_rec_.tax_code,
                                                                start_date_,
                                                                end_date_,
                                                                aggregation_no_,
                                                                periodic_aggr_line_no_);
         lines_created_  := TRUE;
         aggr_ran_empty_ := FALSE;
      END IF;   
   END LOOP;
END Prd_Stlmt_Incl_Sales_Parts___;

-- Prd_Stlmt_Exc_Sales_Parts___
--   Group and create settlment lines for periodic aggregation lines when Excluding sales parts. Create for All parts.
PROCEDURE Prd_Stlmt_Excl_Sales_Parts___ (
   lines_created_      IN OUT BOOLEAN,
   aggr_ran_empty_     IN OUT BOOLEAN,
   company_            IN     VARCHAR2,
   cust_agreement_id_  IN     VARCHAR2,
   customer_no_        IN     VARCHAR2,
   aggregation_no_     IN     NUMBER,
   start_date_         IN     DATE,
   end_date_           IN     DATE )
IS
   rebate_rate_                  NUMBER;
   rebate_cost_rate_             NUMBER;
   periodic_rebate_amount_       NUMBER;
   rebate_cost_amount_           NUMBER;   
   periodic_aggr_line_no_        NUMBER;
   rebate_rate_count_            NUMBER;
   rebate_cost_rate_count_       NUMBER;
   periodic_rebate_amount_count_ NUMBER;
   rebate_cost_amount_count_     NUMBER;
   all_sales_part_level_         VARCHAR2(28);
   
   -- Group and sum the transactions for all sales parts
   CURSOR get_rebate_trans IS
      SELECT rebate_type, hierarchy_id, customer_level, tax_code,
            SUM(total_rebate_amount) rebate_amount_sum, SUM(total_rebate_cost_amount) rebate_cost_amount_sum,
            SUM(inv_line_sales_amount) inv_line_sales_amount_sum, SUM(inv_line_sales_gross_amount) inv_line_sales_gro_amount_sum,
            SUM(inv_line_sales_curr_amount) inv_line_sales_curr_amount_sum, SUM(inv_lin_sale_gros_curr_amt) inv_li_sale_gro_curr_amt_sum,
            SUM(invoiced_quantity) invoiced_quantity_sum, SUM(net_weight) net_weight_sum, SUM(net_volume) net_volume_sum
      FROM rebate_transaction_tab
      WHERE customer_no = customer_no_
      AND   company = company_
      AND   agreement_id = cust_agreement_id_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_ALL
      AND   all_sales_part_level_ = Rebate_All_Sales_Level_API.DB_EXCLUDE_SALES_PART
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL 
      AND   rebate_type != '*'
      GROUP BY rebate_type, hierarchy_id, customer_level, tax_code;      
   
   -- Get the count of rebate rates for all sales parts.
   CURSOR get_rates_count (hierarchy_id_            IN VARCHAR2,
                           customer_level_          IN VARCHAR2,
                           rebate_type_             IN VARCHAR2) IS
      SELECT count(distinct(rebate_rate)), count(distinct(rebate_cost_rate)), count(distinct(periodic_rebate_amount)),
             count(distinct(rebate_cost_amount))
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = cust_agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_ALL
      AND   all_sales_part_level_ = Rebate_All_Sales_Level_API.DB_EXCLUDE_SALES_PART
      AND   rebate_type = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL; 
 
   -- Get the rebate rates for all sales parts
   CURSOR get_rates (hierarchy_id_            IN VARCHAR2,
                     customer_level_          IN VARCHAR2,
                     rebate_type_             IN VARCHAR2) IS
      SELECT rebate_rate, rebate_cost_rate, periodic_rebate_amount, rebate_cost_amount
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = cust_agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_ALL
      AND   all_sales_part_level_ = Rebate_All_Sales_Level_API.DB_EXCLUDE_SALES_PART
      AND   rebate_type = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL;
BEGIN
   all_sales_part_level_ := Rebate_Agreement_API.Get_All_Sales_Part_Level_Db(cust_agreement_id_);
   
   FOR agg_rec_ IN get_rebate_trans() LOOP
      IF agg_rec_.rebate_amount_sum >= 0 THEN
         OPEN get_rates_count(agg_rec_.hierarchy_id, agg_rec_.customer_level,
                              agg_rec_.rebate_type);
         FETCH get_rates_count INTO rebate_rate_count_, rebate_cost_rate_count_, periodic_rebate_amount_count_, rebate_cost_amount_count_;
         CLOSE get_rates_count;
 
         IF (((NVL(rebate_rate_count_, 0) = 1) AND (NVL(rebate_cost_rate_count_, 0) = 1)) OR 
            ((NVL(periodic_rebate_amount_count_, 0) = 1) AND (NVL(rebate_cost_amount_count_, 0) = 1))) THEN
            -- Get rebate_rate and rebate_cost_rate
            OPEN get_rates(agg_rec_.hierarchy_id, agg_rec_.customer_level, agg_rec_.rebate_type);
            FETCH get_rates INTO rebate_rate_, rebate_cost_rate_, periodic_rebate_amount_, rebate_cost_amount_;
            CLOSE get_rates;
         ELSE
            -- If there are multiple rates defined the rates will be set to NULL.
            rebate_rate_            := NULL;
            rebate_cost_rate_       := NULL;
            periodic_rebate_amount_ := NULL;
            rebate_cost_amount_     := NULL;
         END IF;
         periodic_aggr_line_no_ := Get_Periodic_Aggr_Line_No___(aggregation_no_);
         -- Create aggregation lines
         
         Rebate_Periodic_Agg_Line_API.NEW(aggregation_no_,
                                       periodic_aggr_line_no_,
                                       agg_rec_.hierarchy_id,
                                       agg_rec_.customer_level,
                                       NULL,    --sales_part_rebate_group
                                       NULL,    -- assortment_id
                                       NULL,    -- assortment_node_id
                                       NULL,    -- part_no
                                       agg_rec_.rebate_type,
                                       agg_rec_.tax_code,
                                       rebate_rate_,
                                       rebate_cost_rate_,
                                       agg_rec_.rebate_amount_sum,
                                       agg_rec_.rebate_cost_amount_sum,
                                       nvl(agg_rec_.inv_line_sales_amount_sum, 0),
                                       nvl(agg_rec_.inv_line_sales_gro_amount_sum, 0),
                                       periodic_rebate_amount_,
                                       rebate_cost_amount_,
                                       nvl(agg_rec_.invoiced_quantity_sum,0),
                                       nvl(agg_rec_.net_weight_sum,0),
                                       nvl(agg_rec_.net_volume_sum,0),
                                       nvl(agg_rec_.inv_line_sales_curr_amount_sum, 0),
                                       nvl(agg_rec_.inv_li_sale_gro_curr_amt_sum, 0));
    
                                       
         -- Set the transactions to 'included in periodic settlement'
         Rebate_Transaction_Util_API.Set_Incl_In_Period_Settlement(cust_agreement_id_,
                                                                customer_no_,
                                                                agg_rec_.hierarchy_id,
                                                                agg_rec_.customer_level,
                                                                NULL,    --sales_part_rebate_group
                                                                NULL,    -- assortment_id
                                                                NULL,    -- assortment_node_id
                                                                NULL,    -- part_no
                                                                NULL,    -- sales_unit_meas                                                               
                                                                agg_rec_.rebate_type,
                                                                agg_rec_.tax_code,
                                                                start_date_,
                                                                end_date_,
                                                                aggregation_no_,
                                                                periodic_aggr_line_no_);
         lines_created_  := TRUE;
         aggr_ran_empty_ := FALSE;
      END IF;   
   END LOOP;
END Prd_Stlmt_Excl_Sales_Parts___;

PROCEDURE Add_Prd_Aggrigate_Lines___ (
   lines_created_             IN OUT BOOLEAN,
   aggregation_ran_empty_     IN OUT BOOLEAN,
   company_                   IN     VARCHAR2,
   agreement_id_              IN     VARCHAR2,
   customer_no_               IN     VARCHAR2,
   aggregation_no_            IN     NUMBER,
   start_date_                IN     DATE,
   end_date_                  IN     DATE )
IS
BEGIN
   lines_created_ := FALSE;
   
   -- Group and create aggregation lines for sales part rebate group
   Add_Prd_Stlmt_Reb_Grp___(lines_created_, aggregation_ran_empty_, company_, agreement_id_, customer_no_, aggregation_no_, start_date_, end_date_);
   -- Group and create aggregation lines for assortment
   Add_Prd_Stlmt_Assort___(lines_created_, aggregation_ran_empty_, company_, agreement_id_,customer_no_, aggregation_no_, start_date_, end_date_);
   -- Group and create aggregation lines for sales part
   Add_Prd_Stlmt_Sales_Part___(lines_created_, aggregation_ran_empty_, company_, agreement_id_, customer_no_, aggregation_no_, start_date_, end_date_);
   -- Group and create aggregation lines for all parts
   Add_Prd_Stlmt_All_Parts___(lines_created_, aggregation_ran_empty_, company_, agreement_id_, customer_no_, aggregation_no_, start_date_, end_date_);               
END Add_Prd_Aggrigate_Lines___;

-- Add_Fin_Stlmt_Reb_Grp___
--   Group and create settlment lines for final aggregation lines from sales part rebate group
PROCEDURE Add_Fin_Stlmt_Reb_Grp___ (
   lines_created_      IN OUT BOOLEAN,
   aggr_ran_empty_     IN OUT BOOLEAN,
   company_            IN     VARCHAR2,
   customer_no_        IN     VARCHAR2,
   agreement_id_       IN     VARCHAR2,
   aggregation_no_     IN     NUMBER,
   start_date_         IN     DATE,
   end_date_           IN     DATE )
IS
   final_rebate_rate_      NUMBER;
   amount_to_invoice_      NUMBER := 0;
   final_aggr_line_no_     NUMBER;
   -- Group and sum the transactions for sales part rebate groups
   CURSOR get_rebate_trans IS
      SELECT rebate_type, sales_part_rebate_group, hierarchy_id, customer_level, tax_code,
            SUM(DECODE(period_aggregation_no, NULL, 0, total_rebate_amount)) rebate_amount_sum, 
            SUM(final_rebate_amount) final_rebate_amount_sum,
            SUM(inv_line_sales_amount) inv_line_sales_amount_sum, 
            SUM(inv_line_sales_gross_amount) inv_line_sales_gro_amount_sum,
            SUM(inv_line_sales_curr_amount) inv_line_sales_curr_amount_sum, 
            SUM(inv_lin_sale_gros_curr_amt) inv_li_sale_gro_curr_amt_sum,
            SUM(DECODE(period_aggregation_no, NULL, total_rebate_cost_amount, 0)) remaining_cost
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = agreement_id_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_REBATE_GROUP
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no IS NULL
      GROUP BY rebate_type, sales_part_rebate_group, hierarchy_id, customer_level, tax_code;

   -- Get the rebate rates for sales part rebate group
   CURSOR get_rates (hierarchy_id_              IN VARCHAR2,
                     customer_level_            IN VARCHAR2,
                     sales_part_rebate_group_   IN VARCHAR2,
                     rebate_type_               IN VARCHAR2) IS
      SELECT final_rebate_rate
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   sales_part_rebate_group = sales_part_rebate_group_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_REBATE_GROUP
      AND   rebate_type = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no IS NULL;
BEGIN
   FOR agg_rec_ IN get_rebate_trans() LOOP
      -- Get final_rebate_rate
      OPEN get_rates(agg_rec_.hierarchy_id, agg_rec_.customer_level, agg_rec_.sales_part_rebate_group, agg_rec_.rebate_type);
      FETCH get_rates INTO final_rebate_rate_;
      CLOSE get_rates;

      -- Allow the creation of a new line only if final rebate rate defined.        
      IF (NVL(final_rebate_rate_,0) != 0) THEN
         -- Calculate the amount left to invoice
         amount_to_invoice_ := agg_rec_.final_rebate_amount_sum - agg_rec_.rebate_amount_sum;
         
         IF amount_to_invoice_ >= 0 THEN
            -- Create aggregation lines
            final_aggr_line_no_ := Get_Final_Aggr_Line_No___(aggregation_no_);
            Rebate_Final_Agg_Line_API.NEW(aggregation_no_,
                                       final_aggr_line_no_,
                                       agg_rec_.hierarchy_id,
                                       agg_rec_.customer_level,
                                       agg_rec_.sales_part_rebate_group,
                                       NULL,    -- assortment_id
                                       NULL,    -- assortment_node_id
                                       NULL,    -- Part No
                                       agg_rec_.rebate_type,
                                       agg_rec_.tax_code,
                                       nvl(final_rebate_rate_, 0),
                                       nvl(agg_rec_.final_rebate_amount_sum, 0),
                                       agg_rec_.rebate_amount_sum,
                                       agg_rec_.inv_line_sales_amount_sum,
                                       agg_rec_.inv_line_sales_gro_amount_sum,
                                       agg_rec_.inv_line_sales_curr_amount_sum, 
                                       agg_rec_.inv_li_sale_gro_curr_amt_sum,
                                       nvl(amount_to_invoice_, 0),
                                       nvl(agg_rec_.remaining_cost, 0));

            lines_created_ := TRUE;
         END IF; 
      END IF; 
      
      IF (NVL(final_rebate_rate_,0) = 0) OR (NVL(final_rebate_rate_,0) != 0 AND amount_to_invoice_ >= 0) THEN
         -- Set the transactions to 'included in final settlement'
         Rebate_Transaction_Util_API.Set_Incl_In_Final_Settlement(agreement_id_,
                                                               customer_no_,
                                                               agg_rec_.hierarchy_id,
                                                               agg_rec_.customer_level,
                                                               agg_rec_.sales_part_rebate_group,
                                                               NULL,    -- assortment_id
                                                               NULL,    -- assortment_node_id
                                                               NULL,    -- part_no
                                                               NULL,    -- sales_unit_meas
                                                               agg_rec_.rebate_type,
                                                               agg_rec_.tax_code,
                                                               start_date_,
                                                               end_date_,
                                                               aggregation_no_,
                                                               final_aggr_line_no_);
         
      END IF;
      aggr_ran_empty_ := FALSE;
     
   END LOOP;
END Add_Fin_Stlmt_Reb_Grp___;

-- Add_Fin_Stlmt_Sales_Part___
--   Group and create settlment lines for final aggregation lines from sales part rebate group
PROCEDURE Add_Fin_Stlmt_Sales_Part___ (
   lines_created_      IN OUT BOOLEAN,
   aggr_ran_empty_     IN OUT BOOLEAN,
   company_            IN     VARCHAR2,
   customer_no_        IN     VARCHAR2,
   agreement_id_       IN     VARCHAR2,
   aggregation_no_     IN     NUMBER,
   start_date_         IN     DATE,
   end_date_           IN     DATE )
IS
   final_rebate_rate_      NUMBER;
   amount_to_invoice_      NUMBER := 0;
   final_aggr_line_no_     NUMBER;
   -- Group and sum the transactions for sales part rebate groups
   CURSOR get_rebate_trans IS
      SELECT rebate_type, part_no, sales_unit_meas, hierarchy_id, customer_level, tax_code,
            SUM(DECODE(period_aggregation_no, NULL, 0, total_rebate_amount)) rebate_amount_sum, 
            SUM(final_rebate_amount) final_rebate_amount_sum,
            SUM(inv_line_sales_amount) inv_line_sales_amount_sum, 
            SUM(inv_line_sales_gross_amount) inv_line_sales_gro_amount_sum,
            SUM(inv_line_sales_curr_amount) inv_line_sales_curr_amount_sum, 
            SUM(inv_lin_sale_gros_curr_amt) inv_li_sale_gro_curr_amt_sum,
            SUM(DECODE(period_aggregation_no, NULL, total_rebate_cost_amount, 0)) remaining_cost
      FROM rebate_transaction_tab
      WHERE company                 = company_
      AND   customer_no             = customer_no_
      AND   agreement_id            = agreement_id_
      AND   agreement_type          = Rebate_Agreement_Type_API.DB_SALES_PART
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no    IS NULL
      GROUP BY rebate_type, part_no, sales_unit_meas, hierarchy_id, customer_level, tax_code;

   -- Get the rebate rates for sales part rebate group
   CURSOR get_rates (hierarchy_id_              IN VARCHAR2,
                     customer_level_            IN VARCHAR2,
                     part_no_                   IN VARCHAR2,
                     sales_unit_meas_           IN VARCHAR2,
                     rebate_type_               IN VARCHAR2) IS
      SELECT final_rebate_rate
      FROM rebate_transaction_tab
      WHERE company              = company_
      AND   customer_no          = customer_no_
      AND   agreement_id         = agreement_id_
      AND   hierarchy_id         = hierarchy_id_
      AND   customer_level       = customer_level_
      AND   part_no              = part_no_
      AND   sales_unit_meas      = sales_unit_meas_
      AND   agreement_type       = Rebate_Agreement_Type_API.DB_SALES_PART
      AND   rebate_type          = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no IS NULL;
BEGIN
   FOR agg_rec_ IN get_rebate_trans() LOOP
      -- Get final_rebate_rate
      OPEN get_rates(agg_rec_.hierarchy_id, agg_rec_.customer_level, agg_rec_.part_no, agg_rec_.sales_unit_meas, agg_rec_.rebate_type);
      FETCH get_rates INTO final_rebate_rate_;
      CLOSE get_rates;

      -- Allow the creation of a new line only if final rebate rate defined.        
      IF (NVL(final_rebate_rate_,0) != 0) THEN
         -- Calculate the amount left to invoice
         amount_to_invoice_ := agg_rec_.final_rebate_amount_sum - agg_rec_.rebate_amount_sum;
         
         IF amount_to_invoice_ >= 0 THEN
            final_aggr_line_no_ := Get_Final_Aggr_Line_No___(aggregation_no_);
            -- Create aggregation lines
            Rebate_Final_Agg_Line_API.NEW(aggregation_no_,
                                       final_aggr_line_no_,
                                       agg_rec_.hierarchy_id,
                                       agg_rec_.customer_level,
                                       NULL,    -- sales_part_rebate_group
                                       NULL,    -- assortment_id
                                       NULL,    -- assortment_node_id
                                       agg_rec_.part_no,
                                       agg_rec_.rebate_type,
                                       agg_rec_.tax_code,
                                       nvl(final_rebate_rate_, 0),
                                       nvl(agg_rec_.final_rebate_amount_sum, 0),
                                       agg_rec_.rebate_amount_sum,
                                       agg_rec_.inv_line_sales_amount_sum,
                                       agg_rec_.inv_line_sales_gro_amount_sum,
                                       agg_rec_.inv_line_sales_curr_amount_sum,
                                       agg_rec_.inv_li_sale_gro_curr_amt_sum,
                                       nvl(amount_to_invoice_, 0),
                                       nvl(agg_rec_.remaining_cost, 0));

            lines_created_ := TRUE;
         END IF; 
      END IF; 
      
      IF (NVL(final_rebate_rate_,0) = 0) OR (NVL(final_rebate_rate_,0) != 0 AND amount_to_invoice_ >= 0) THEN
         -- Set the transactions to 'included in final settlement'
         Rebate_Transaction_Util_API.Set_Incl_In_Final_Settlement(agreement_id_,
                                                               customer_no_,
                                                               agg_rec_.hierarchy_id,
                                                               agg_rec_.customer_level,
                                                               NULL,    -- sales_part_rebate_group
                                                               NULL,    -- assortment_id
                                                               NULL,    -- assortment_node_id
                                                               agg_rec_.part_no,
                                                               agg_rec_.sales_unit_meas,
                                                               agg_rec_.rebate_type,
                                                               agg_rec_.tax_code,
                                                               start_date_,
                                                               end_date_,
                                                               aggregation_no_,
                                                               final_aggr_line_no_);
      END IF;                                                         
      aggr_ran_empty_ := FALSE;
      
   END LOOP;
END Add_Fin_Stlmt_Sales_Part___;

PROCEDURE Add_Fin_Stlmt_All_Parts___ (
   lines_created_             IN OUT BOOLEAN,
   aggregation_ran_empty_     IN OUT BOOLEAN,
   company_                   IN     VARCHAR2,
   customer_no_               IN     VARCHAR2,
   agreement_id_              IN     VARCHAR2,
   aggregation_no_            IN     NUMBER,
   start_date_                IN     DATE,
   end_date_                  IN     DATE )
IS
BEGIN
   -- Group and create aggregation lines when Including sales parts.
   Final_Stlmt_Incl_Sales_Parts___(lines_created_, aggregation_ran_empty_, company_, customer_no_, agreement_id_, aggregation_no_, start_date_, end_date_);               
   -- Group and create aggregation lines when Excluding sales parts (create for all parts)
   Final_Stlmt_Excl_sales_Parts___(lines_created_, aggregation_ran_empty_, company_, customer_no_, agreement_id_, aggregation_no_, start_date_, end_date_);   
END Add_Fin_Stlmt_All_Parts___;

-- Final_Stlmt_Incl_Sales_Parts___
--   Group and create settlment lines for final aggregation lines from Including sales part.
PROCEDURE Final_Stlmt_Incl_Sales_Parts___ (
   lines_created_      IN OUT BOOLEAN,
   aggr_ran_empty_     IN OUT BOOLEAN,
   company_            IN     VARCHAR2,
   customer_no_        IN     VARCHAR2,
   agreement_id_       IN     VARCHAR2,
   aggregation_no_     IN     NUMBER,
   start_date_         IN     DATE,
   end_date_           IN     DATE )
IS
   final_rebate_rate_      NUMBER;
   amount_to_invoice_      NUMBER := 0;
   final_aggr_line_no_     NUMBER;
   all_sales_part_level_   VARCHAR2(28);
   -- Group and sum the transactions for Sales parts
   CURSOR get_rebate_trans IS
      SELECT rebate_type, part_no, hierarchy_id, customer_level, tax_code,
            SUM(DECODE(period_aggregation_no, NULL, 0, total_rebate_amount)) rebate_amount_sum, 
            SUM(final_rebate_amount) final_rebate_amount_sum,
            SUM(inv_line_sales_amount) inv_line_sales_amount_sum, 
            SUM(inv_line_sales_gross_amount) inv_line_sales_gro_amount_sum,
            SUM(inv_line_sales_curr_amount) inv_line_curr_amount_sum, 
            SUM(inv_lin_sale_gros_curr_amt) inv_li_sale_gro_curr_amt_sum,
            SUM(DECODE(period_aggregation_no, NULL, total_rebate_cost_amount, 0)) remaining_cost
      FROM rebate_transaction_tab
      WHERE company                 = company_
      AND   customer_no             = customer_no_
      AND   agreement_id            = agreement_id_
      AND   agreement_type          = Rebate_Agreement_Type_API.DB_ALL
      AND   all_sales_part_level_   = Rebate_All_Sales_Level_API.DB_INCLUDE_SALES_PART
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no    IS NULL
      GROUP BY rebate_type, part_no, hierarchy_id, customer_level, tax_code;

   -- Get the rebate rates for sales part rebate group
   CURSOR get_rates (hierarchy_id_              IN VARCHAR2,
                     customer_level_            IN VARCHAR2,                     
                     rebate_type_               IN VARCHAR2) IS
      SELECT final_rebate_rate
      FROM rebate_transaction_tab
      WHERE company                 = company_
      AND   customer_no             = customer_no_
      AND   agreement_id            = agreement_id_
      AND   hierarchy_id            = hierarchy_id_
      AND   customer_level          = customer_level_
      AND   agreement_type          = Rebate_Agreement_Type_API.DB_ALL
      AND   all_sales_part_level_   = Rebate_All_Sales_Level_API.DB_INCLUDE_SALES_PART
      AND   rebate_type             = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no    IS NULL;
BEGIN
   all_sales_part_level_ := Rebate_Agreement_API.Get_All_Sales_Part_Level_Db(agreement_id_);
   FOR agg_rec_ IN get_rebate_trans() LOOP
      -- Get final_rebate_rate
      OPEN get_rates(agg_rec_.hierarchy_id, agg_rec_.customer_level, agg_rec_.rebate_type);
      FETCH get_rates INTO final_rebate_rate_;
      CLOSE get_rates;

      -- Allow the creation of a new line only if final rebate rate defined.        
      IF (NVL(final_rebate_rate_,0) != 0) THEN
         -- Calculate the amount left to invoice
         amount_to_invoice_ := agg_rec_.final_rebate_amount_sum - agg_rec_.rebate_amount_sum;
         
         IF amount_to_invoice_ >= 0 THEN
            final_aggr_line_no_ := Get_Final_Aggr_Line_No___(aggregation_no_);
            -- Create aggregation lines
            Rebate_Final_Agg_Line_API.NEW(aggregation_no_,
                                       final_aggr_line_no_,
                                       agg_rec_.hierarchy_id,
                                       agg_rec_.customer_level,
                                       NULL,    -- sales_part_rebate_group
                                       NULL,    -- assortment_id
                                       NULL,    -- assortment_node_id
                                       agg_rec_.part_no,
                                       agg_rec_.rebate_type,
                                       agg_rec_.tax_code,
                                       nvl(final_rebate_rate_, 0),
                                       nvl(agg_rec_.final_rebate_amount_sum, 0),
                                       agg_rec_.rebate_amount_sum,
                                       agg_rec_.inv_line_sales_amount_sum,
                                       agg_rec_.inv_line_sales_gro_amount_sum,
                                       agg_rec_.inv_line_curr_amount_sum,
                                       agg_rec_.inv_li_sale_gro_curr_amt_sum,
                                       nvl(amount_to_invoice_, 0),
                                       nvl(agg_rec_.remaining_cost, 0));

            lines_created_ := TRUE;
         END IF; 
      END IF; 
      
      IF (NVL(final_rebate_rate_,0) = 0) OR (NVL(final_rebate_rate_,0) != 0 AND amount_to_invoice_ >= 0) THEN
         -- Set the transactions to 'included in final settlement'
         Rebate_Transaction_Util_API.Set_Incl_In_Final_Settlement(agreement_id_,
                                                               customer_no_,
                                                               agg_rec_.hierarchy_id,
                                                               agg_rec_.customer_level,
                                                               NULL,    -- sales_part_rebate_group
                                                               NULL,    -- assortment_id
                                                               NULL,    -- assortment_node_id
                                                               agg_rec_.part_no,
                                                               NULL,    -- sales_unit_meas                                                               
                                                               agg_rec_.rebate_type,
                                                               agg_rec_.tax_code,
                                                               start_date_,
                                                               end_date_,
                                                               aggregation_no_,
                                                               final_aggr_line_no_);
      END IF;                                                         
      aggr_ran_empty_ := FALSE;
    
   END LOOP;
END Final_Stlmt_Incl_Sales_Parts___;

-- Final_Stlmt_Excl_Sales_Parts___
--   Group and create settlment lines for final aggregation lines from Excluding sales part. Create for All parts.
PROCEDURE Final_Stlmt_Excl_Sales_Parts___ (
   lines_created_      IN OUT BOOLEAN,
   aggr_ran_empty_     IN OUT BOOLEAN,
   company_            IN     VARCHAR2,
   customer_no_        IN     VARCHAR2,
   agreement_id_       IN     VARCHAR2,
   aggregation_no_     IN     NUMBER,
   start_date_         IN     DATE,
   end_date_           IN     DATE )
IS
   final_rebate_rate_      NUMBER;
   amount_to_invoice_      NUMBER := 0;
   final_aggr_line_no_     NUMBER;
   all_sales_part_level_   VARCHAR2(18);
   -- Group and sum the transactions for all sales part 
   CURSOR get_rebate_trans IS
      SELECT rebate_type, hierarchy_id, customer_level, tax_code,
            SUM(DECODE(period_aggregation_no, NULL, 0, total_rebate_amount)) rebate_amount_sum, 
            SUM(final_rebate_amount) final_rebate_amount_sum,
            SUM(inv_line_sales_amount) inv_line_sales_amount_sum, 
            SUM(inv_line_sales_gross_amount) inv_line_sales_gro_amount_sum,
            SUM(inv_line_sales_curr_amount) inv_line_curr_amount_sum, 
            SUM(inv_lin_sale_gros_curr_amt) inv_li_sale_gro_curr_amt_sum,
            SUM(DECODE(period_aggregation_no, NULL, total_rebate_cost_amount, 0)) remaining_cost
      FROM rebate_transaction_tab
      WHERE company                 = company_
      AND   customer_no             = customer_no_
      AND   agreement_id            = agreement_id_
      AND   agreement_type          = Rebate_Agreement_Type_API.DB_ALL
      AND   all_sales_part_level_   = Rebate_All_Sales_Level_API.DB_EXCLUDE_SALES_PART
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no    IS NULL
      GROUP BY rebate_type, hierarchy_id, customer_level, tax_code;
 
   -- Get the rebate rates for sales part rebate group
   CURSOR get_rates (hierarchy_id_              IN VARCHAR2,
                     customer_level_            IN VARCHAR2,                     
                     rebate_type_               IN VARCHAR2) IS
      SELECT final_rebate_rate
      FROM rebate_transaction_tab
      WHERE company                 = company_
      AND   customer_no             = customer_no_
      AND   agreement_id            = agreement_id_
      AND   hierarchy_id            = hierarchy_id_
      AND   customer_level          = customer_level_
      AND   agreement_type          = Rebate_Agreement_Type_API.DB_ALL
      AND   all_sales_part_level_   = Rebate_All_Sales_Level_API.DB_EXCLUDE_SALES_PART
      AND   rebate_type             = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no    IS NULL;
BEGIN
   all_sales_part_level_ := Rebate_Agreement_API.Get_All_Sales_Part_Level_Db(agreement_id_);
   FOR agg_rec_ IN get_rebate_trans() LOOP
      -- Get final_rebate_rate
      OPEN get_rates(agg_rec_.hierarchy_id, agg_rec_.customer_level, agg_rec_.rebate_type);
      FETCH get_rates INTO final_rebate_rate_;
      CLOSE get_rates;
 
      -- Allow the creation of a new line only if final rebate rate defined.        
      IF (NVL(final_rebate_rate_,0) != 0) THEN
         -- Calculate the amount left to invoice
         amount_to_invoice_ := agg_rec_.final_rebate_amount_sum - agg_rec_.rebate_amount_sum;
         
         IF amount_to_invoice_ >= 0 THEN
            final_aggr_line_no_ := Get_Final_Aggr_Line_No___(aggregation_no_);
            -- Create aggregation lines
            Rebate_Final_Agg_Line_API.NEW(aggregation_no_,
                                       final_aggr_line_no_,
                                       agg_rec_.hierarchy_id,
                                       agg_rec_.customer_level,
                                       NULL,    -- sales_part_rebate_group
                                       NULL,    -- assortment_id
                                       NULL,    -- assortment_node_id
                                       NULL,    -- Part No
                                       agg_rec_.rebate_type,
                                       agg_rec_.tax_code,
                                       nvl(final_rebate_rate_, 0),
                                       nvl(agg_rec_.final_rebate_amount_sum, 0),
                                       agg_rec_.rebate_amount_sum,
                                       agg_rec_.inv_line_sales_amount_sum,
                                       agg_rec_.inv_line_sales_gro_amount_sum,
                                       agg_rec_.inv_line_curr_amount_sum,
                                       agg_rec_.inv_li_sale_gro_curr_amt_sum,
                                       nvl(amount_to_invoice_, 0),
                                       nvl(agg_rec_.remaining_cost, 0));
 
            lines_created_ := TRUE;
         END IF; 
      END IF; 
      
      IF (NVL(final_rebate_rate_,0) = 0) OR (NVL(final_rebate_rate_,0) != 0 AND amount_to_invoice_ >= 0) THEN
         -- Set the transactions to 'included in final settlement'
         Rebate_Transaction_Util_API.Set_Incl_In_Final_Settlement(agreement_id_,
                                                               customer_no_,
                                                               agg_rec_.hierarchy_id,
                                                               agg_rec_.customer_level,
                                                               NULL,    -- sales_part_rebate_group
                                                               NULL,    -- assortment_id
                                                               NULL,    -- assortment_node_id
                                                               NULL,    -- part_no
                                                               NULL,    -- sales_unit_meas                                                               
                                                               agg_rec_.rebate_type,
                                                               agg_rec_.tax_code,
                                                               start_date_,
                                                               end_date_,
                                                               aggregation_no_,
                                                               final_aggr_line_no_);
      END IF;                                                         
      aggr_ran_empty_ := FALSE;
    
   END LOOP;
END Final_Stlmt_Excl_Sales_Parts___;

PROCEDURE Add_Final_Aggrigate_Lines___ (
   lines_created_             IN OUT BOOLEAN,
   aggregation_ran_empty_     IN OUT BOOLEAN,
   company_                   IN     VARCHAR2,
   customer_no_               IN     VARCHAR2,
   agreement_id_              IN     VARCHAR2,
   aggregation_no_            IN     NUMBER,
   start_date_                IN     DATE,
   end_date_                  IN     DATE )
IS
BEGIN
   lines_created_ := FALSE;
   
   -- Group and create aggregation lines for sales part rebate group
   Add_Fin_Stlmt_Reb_Grp___(lines_created_, aggregation_ran_empty_, company_, customer_no_, agreement_id_, aggregation_no_, start_date_, end_date_);
   -- Group and create aggregation lines for assortment
   Add_Fin_Stlmt_Assort___(lines_created_, aggregation_ran_empty_, company_, customer_no_, agreement_id_, aggregation_no_, start_date_, end_date_);
   -- Group and create aggregation lines for sales part
   Add_Fin_Stlmt_Sales_Part___(lines_created_, aggregation_ran_empty_, company_, customer_no_, agreement_id_, aggregation_no_, start_date_, end_date_);
   -- Group and create aggregation lines for all parts
   Add_Fin_Stlmt_All_Parts___(lines_created_, aggregation_ran_empty_, company_, customer_no_, agreement_id_, aggregation_no_, start_date_, end_date_);               
END Add_Final_Aggrigate_Lines___;


-- Add_Fin_Stlmt_Assort___
--   Group and create settlment lines for final aggregation lines from assortments
PROCEDURE Add_Fin_Stlmt_Assort___ (
   lines_created_      IN OUT BOOLEAN,
   aggr_ran_empty_     IN OUT BOOLEAN,
   company_            IN     VARCHAR2,
   customer_no_        IN     VARCHAR2,
   agreement_id_       IN     VARCHAR2,
   aggregation_no_     IN     NUMBER,
   start_date_         IN     DATE,
   end_date_           IN     DATE )
IS
   final_rebate_rate_      NUMBER;
   amount_to_invoice_      NUMBER := 0;
   final_aggr_line_no_     NUMBER;
   -- Group and sum the transactions for assortments
    CURSOR get_rebate_trans_assort IS
      SELECT rebate_type, assortment_id, assortment_node_id, hierarchy_id, customer_level, tax_code,
            SUM(DECODE(period_aggregation_no, NULL, 0, total_rebate_amount)) rebate_amount_sum, 
            SUM(final_rebate_amount) final_rebate_amount_sum,
            SUM(inv_line_sales_amount) inv_line_sales_amount_sum, 
            SUM(inv_line_sales_gross_amount) inv_line_sales_gro_amount_sum,
            SUM(inv_line_sales_curr_amount) inv_line_sales_curr_amount_sum,
            SUM(inv_lin_sale_gros_curr_amt) inv_li_sale_gro_curr_amt_sum,
            SUM(DECODE(period_aggregation_no, NULL, total_rebate_cost_amount, 0)) remaining_cost
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = agreement_id_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_ASSORTMENT
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no IS NULL
      GROUP BY rebate_type, assortment_id, assortment_node_id, hierarchy_id, customer_level, tax_code;
  
   -- Get the rebate rates for assortment
   CURSOR get_rates_assort (hierarchy_id_       IN VARCHAR2,
                            customer_level_     IN VARCHAR2,
                            assortment_id_      IN VARCHAR2,
                            assortment_node_id_ IN VARCHAR2,
                            rebate_type_        IN VARCHAR2) IS
      SELECT final_rebate_rate
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_
      AND   rebate_type = rebate_type_
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no IS NULL;
BEGIN
   -- Group and create aggregation lines for assortment
   FOR agg_assort_rec_ IN get_rebate_trans_assort() LOOP
      -- Get final_rebate_rate
      OPEN get_rates_assort(agg_assort_rec_.hierarchy_id, agg_assort_rec_.customer_level, agg_assort_rec_.assortment_id,
                            agg_assort_rec_.assortment_node_id, agg_assort_rec_.rebate_type);
      FETCH get_rates_assort INTO final_rebate_rate_;
      CLOSE get_rates_assort;

      -- Allow the creation of a new line only if final rebate rate defined.        
      IF (NVL(final_rebate_rate_,0) != 0) THEN

         -- Calculate the amount left to invoice
         amount_to_invoice_ := agg_assort_rec_.final_rebate_amount_sum - agg_assort_rec_.rebate_amount_sum;
         
         IF amount_to_invoice_ >= 0 THEN
            final_aggr_line_no_ := Get_Final_Aggr_Line_No___(aggregation_no_);
            -- Create aggregation lines
            Rebate_Final_Agg_Line_API.NEW(aggregation_no_,
                                       final_aggr_line_no_,
                                       agg_assort_rec_.hierarchy_id,
                                       agg_assort_rec_.customer_level,
                                       NULL,    --sales_part_rebate_group
                                       agg_assort_rec_.assortment_id,
                                       agg_assort_rec_.assortment_node_id,
                                       NULL,    -- Part No
                                       agg_assort_rec_.rebate_type,
                                       agg_assort_rec_.tax_code,
                                       nvl(final_rebate_rate_, 0),
                                       nvl(agg_assort_rec_.final_rebate_amount_sum, 0),
                                       agg_assort_rec_.rebate_amount_sum,
                                       agg_assort_rec_.inv_line_sales_amount_sum,
                                       agg_assort_rec_.inv_line_sales_gro_amount_sum,
                                       agg_assort_rec_.inv_line_sales_curr_amount_sum,
                                       agg_assort_rec_.inv_li_sale_gro_curr_amt_sum,
                                       nvl(amount_to_invoice_, 0),
                                       nvl(agg_assort_rec_.remaining_cost, 0));
            lines_created_ := TRUE;
         END IF;   
      END IF;
      
      IF (NVL(final_rebate_rate_,0) = 0) OR (NVL(final_rebate_rate_,0) != 0 AND amount_to_invoice_ >= 0) THEN
         -- Set the transactions to 'included in final settlement'
         Rebate_Transaction_Util_API.Set_Incl_In_Final_Settlement(agreement_id_,
                                                               customer_no_,
                                                               agg_assort_rec_.hierarchy_id,
                                                               agg_assort_rec_.customer_level,
                                                               NULL,    --sales_part_rebate_group
                                                               agg_assort_rec_.assortment_id,
                                                               agg_assort_rec_.assortment_node_id,
                                                               NULL,    -- part_no
                                                               NULL,    -- sales_unit_meas                                                               
                                                               agg_assort_rec_.rebate_type,
                                                               agg_assort_rec_.tax_code,
                                                               start_date_,
                                                               end_date_,
                                                               aggregation_no_,
                                                               final_aggr_line_no_);
      END IF;                                                         
      aggr_ran_empty_ := FALSE;
            
   END LOOP;
END Add_Fin_Stlmt_Assort___;

PROCEDURE Calculate_Final_Settlelemt___ (
   company_             IN VARCHAR2,
   agreement_id_        IN VARCHAR2,
   customer_no_         IN VARCHAR2,
   agreement_rec_       IN Rebate_Agreement_API.Public_Rec,
   start_date_          IN DATE,
   end_date_            IN DATE,
   period_stop_on_      IN DATE )
IS
BEGIN
   IF agreement_rec_.agreement_type = Rebate_Agreement_Type_API.DB_REBATE_GROUP THEN
      Calculate_Total_Sales(company_,
                            agreement_id_,
                            customer_no_,
                            agreement_rec_.sales_rebate_basis,
                            start_date_,
                            end_date_,
                            period_stop_on_);
   ELSIF agreement_rec_.agreement_type = Rebate_Agreement_Type_API.DB_ASSORTMENT THEN
      Calculate_Total_Assort_Sales(company_,
                                   agreement_id_,
                                   customer_no_,
                                   agreement_rec_.sales_rebate_basis_assort,
                                   start_date_,
                                   end_date_,
                                   period_stop_on_);
   ELSIF agreement_rec_.agreement_type = Rebate_Agreement_Type_API.DB_SALES_PART THEN
      Calculate_Total_Sales_Part___(company_,
                                    agreement_id_,
                                    customer_no_,
                                    agreement_rec_.sales_rebate_part_basis,
                                    start_date_,
                                    end_date_,
                                    period_stop_on_);               
   ELSIF agreement_rec_.agreement_type = Rebate_Agreement_Type_API.DB_ALL THEN
      Calculate_Total_All_Parts___(company_,
                                   agreement_id_,
                                   customer_no_,
                                   start_date_,
                                   end_date_,
                                   period_stop_on_);                              
   END IF;   
END Calculate_Final_Settlelemt___;

PROCEDURE Calculate_Total_Sales_Part___ (
   company_             IN VARCHAR2,
   agreement_id_        IN VARCHAR2,
   customer_no_         IN VARCHAR2,
   sales_rebate_basis_  IN VARCHAR2,
   start_date_          IN DATE,
   end_date_            IN DATE,
   period_stop_on_      IN DATE )
IS
   customer_level_          NUMBER;
   children_                NUMBER;
   inv_amount_sum_          NUMBER;
   inv_amount_children_sum_ NUMBER;
   inv_qty_sum_             NUMBER;
   inv_qty_children_sum_    NUMBER;
   rebate_rate_             NUMBER;
   min_value_               NUMBER;
   net_weight_              NUMBER;
   net_volume_              NUMBER;
   net_weight_children_     NUMBER;
   net_volume_children_     NUMBER;
   rebate_criteria_db_      rebate_agreement_tab.rebate_criteria%TYPE;
   inv_curr_amount_sum_     NUMBER;
   inv_curr_amt_child_sum_  NUMBER;
   agreement_currency_code_ VARCHAR2(3);
   company_currency_code_   VARCHAR2(3);  
   agreement_rec_           Rebate_Agreement_API.Public_Rec;
   customer_no_tab_         Cust_Hierarchy_Struct_API.Customer_No_Tab;
   net_weight_child_        NUMBER;
   net_volume_child_        NUMBER;
   inv_curr_amt_child_      NUMBER;
   inv_qty_child_           NUMBER;
   inv_amount_child_        NUMBER;
   child_level_inv_sums_    Hierarchy_level_Inv_Sums;

   -- Check if there are any agreement lines for the customer's children
   CURSOR get_line_levels (agreement_id_ IN VARCHAR2, customer_no_ IN VARCHAR2, customer_level_ IN NUMBER) IS
      SELECT rag.customer_level customer_level
      FROM rebate_agr_sales_part_deal_tab rag, rebate_agreement_receiver_tab rar
      WHERE rag.agreement_id = rar.agreement_id
      AND   rag.agreement_id = agreement_id_
      AND   rar.customer_no = customer_no_
      AND   rag.customer_level > customer_level_
      AND   TRUNC(end_date_) BETWEEN TRUNC(rag.valid_from) AND TRUNC(NVL(rag.valid_to_date,Database_Sys.last_calendar_date_));
   
   TYPE child_line_levels IS TABLE OF get_line_levels%ROWTYPE INDEX BY PLS_INTEGER;  
   child_line_levels_   child_line_levels;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the invoice lines for a specific sales part rebate group
   CURSOR get_invoice_amount (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                              start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum, part_no
      FROM Rebate_Trans_Invoice_Amounts
      WHERE  company                 = company_
      AND    customer_no             = customer_no_
      AND    agreement_type          = Rebate_Agreement_Type_API.DB_SALES_PART
      AND    transaction_date BETWEEN start_date_ AND end_date_
      GROUP BY part_no;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the children's invoice lines for a specific sales part 
   CURSOR get_invoice_amount_child (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                       start_date_ IN DATE, end_date_ IN DATE, part_no_ IN VARCHAR2) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Rebate_Trans_Invoice_Amounts
      WHERE agreement_type          = Rebate_Agreement_Type_API.DB_SALES_PART
      AND   company                 = company_
      AND   customer_no             = customer_no_
      AND    part_no                = part_no_
      AND    transaction_date BETWEEN start_date_ AND end_date_;
      
   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the children's invoice lines for a specific sales part 
   CURSOR get_invoice_amount_child2 (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                       start_date_ IN DATE, end_date_ IN DATE, part_no_ IN VARCHAR2) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Order_Line_Invoice_Amounts
      WHERE company                 = company_
      AND   customer_no             = customer_no_
      AND    part_no                = part_no_
      AND    transaction_date BETWEEN start_date_ AND end_date_;   
   
   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the invoice lines for a customer
   CURSOR get_invoice_amount_all_sales (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                        start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Rebate_Trans_Invoice_Amounts
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   transaction_date BETWEEN start_date_ AND end_date_;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the children's invoice lines for a customer
   CURSOR get_inv_amount_all_sales_child (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                          start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Order_Line_Invoice_Amounts
      WHERE company                 = company_
      AND   customer_no             = customer_no_
      AND   transaction_date BETWEEN start_date_ AND end_date_; 

   CURSOR get_all_transactions (company_ IN VARCHAR2, agreement_id_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT rebate_type, part_no, sales_unit_meas, hierarchy_id, customer_level, tax_code, invoice_id, item_id
      FROM rebate_transaction_tab
      WHERE company                 = company_
      AND   agreement_id            = agreement_id_
      AND   customer_no             = customer_no_
      AND   agreement_type          = Rebate_Agreement_Type_API.DB_SALES_PART               
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no    IS NULL;
      
   CURSOR get_trans_per_part (company_ IN VARCHAR2, agreement_id_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                start_date_ IN DATE, end_date_ IN DATE, part_no_ IN VARCHAR2) IS
      SELECT rebate_type, part_no, sales_unit_meas, hierarchy_id, customer_level, tax_code, invoice_id, item_id
      FROM rebate_transaction_tab
      WHERE company                 = company_
      AND   agreement_id            = agreement_id_
      AND   customer_no             = customer_no_
      AND   agreement_type          = Rebate_Agreement_Type_API.DB_SALES_PART               
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   part_no                 = part_no_
      AND   final_aggregation_no    IS NULL;

BEGIN

   agreement_rec_             := Rebate_Agreement_API.Get(agreement_id_);
   customer_level_            := agreement_rec_.customer_level;  
   rebate_criteria_db_        := agreement_rec_.rebate_criteria;
   agreement_currency_code_   := agreement_rec_.currency_code;
   company_currency_code_     := Company_Finance_API.Get_Currency_Code(company_);
   
    -- Are there agreement lines for the customer's children (higher customer level)
   OPEN get_line_levels (agreement_id_, customer_no_, customer_level_);
   FETCH get_line_levels BULK COLLECT INTO child_line_levels_;
   CLOSE get_line_levels;
   children_ := child_line_levels_.COUNT;

   -- For a specific sales part rebate group
   IF sales_rebate_basis_ = Rebate_Sales_Part_Basis_API.DB_SPECIFIC_SALES_PART_SALES THEN
      -- Get total invoice amount for the sales part rebate group
      FOR inv_rec_ IN get_invoice_amount(company_, customer_no_, start_date_, end_date_) LOOP
         inv_amount_sum_         := NVL(inv_rec_.inv_amount_sum, 0);
         inv_qty_sum_            := NVL(inv_rec_.inv_qty_sum, 0);
         net_weight_             := NVL(inv_rec_.inv_net_weight, 0);
         net_volume_             := NVL(inv_rec_.inv_net_volume, 0);
         inv_curr_amount_sum_    := NVL(inv_rec_.inv_curr_amount_sum, 0);
         
         IF children_ > 0 THEN
            -- The agreement has deal lines defined from child levels. So need to consider sales from the children.
            FOR i_ IN 1 .. children_ LOOP
               customer_no_tab_ := CUST_HIERARCHY_STRUCT_API.Get_Customers_In_Level(agreement_rec_.hierarchy_id, child_line_levels_(i_).customer_level);
               -- Consider customers in child level for their total sales.
               IF (customer_no_tab_.COUNT > 0) THEN
                  -- Get the children's total invoice amount for the sales part rebate group
                  FOR c_ IN 1 .. customer_no_tab_.COUNT LOOP
                     OPEN get_invoice_amount_child(company_, customer_no_tab_(c_), start_date_, end_date_, inv_rec_.part_no);
                     FETCH get_invoice_amount_child INTO inv_amount_child_, inv_qty_child_, 
                                                         net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                     CLOSE get_invoice_amount_child;
                                          
                     IF (Child_Has_Reb_Trans___(rebate_criteria_db_, 
                                                agreement_currency_code_,
                                                company_currency_code_,
                                                inv_amount_child_,
                                                inv_curr_amt_child_,
                                                inv_qty_child_,
                                                net_weight_child_,
                                                net_volume_child_ ) = FALSE) THEN
                        -- Child customer might have sales even though there are no agreements valid for him
                        OPEN get_invoice_amount_child2(company_, customer_no_tab_(c_), start_date_, end_date_, inv_rec_.part_no);
                        FETCH get_invoice_amount_child2 INTO inv_amount_child_, inv_qty_child_, 
                                                             net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                        CLOSE get_invoice_amount_child2;
                     END IF;
                     
                     inv_amount_children_sum_   := NVL(inv_amount_children_sum_, 0) + NVL(inv_amount_child_, 0);
                     inv_qty_children_sum_      := NVL(inv_qty_children_sum_, 0)    + NVL(inv_qty_child_, 0);
                     net_weight_children_       := NVL(net_weight_children_, 0)     + NVL(net_weight_child_, 0);
                     net_volume_children_       := NVL(net_volume_children_, 0)     + NVL(net_volume_child_, 0);
                     inv_curr_amt_child_sum_    := NVL(inv_curr_amt_child_sum_, 0)  + NVL(inv_curr_amt_child_, 0);
                  END LOOP;
               END IF;
               -- Store under the level, so when rate calculates for the level the totals can be used
               child_level_inv_sums_(i_).child_level_       := child_line_levels_(i_).customer_level;
               child_level_inv_sums_(i_).inv_amount_child_  := NVL(inv_amount_children_sum_, 0);
               child_level_inv_sums_(i_).inv_qty_child_     := NVL(inv_qty_children_sum_, 0);
               child_level_inv_sums_(i_).net_weight_child_  := NVL(net_weight_children_, 0);
               child_level_inv_sums_(i_).net_volume_child_  := NVL(net_volume_children_, 0);
               child_level_inv_sums_(i_).inv_curr_amt_child_ := NVL(inv_curr_amt_child_sum_, 0);
               --Reset the commonly used variables
               Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                          net_volume_children_, inv_curr_amt_child_sum_);
            END LOOP; 
            --Reset the commonly used variables           
            Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                       net_volume_children_, inv_curr_amt_child_sum_);
         END IF;

         -- Get all transaction lines that should be updated
         FOR all_trans_rec_ IN get_trans_per_part(company_, agreement_id_, 
                                                   customer_no_, start_date_, 
                                                   end_date_, inv_rec_.part_no) LOOP
            
            min_value_ := Get_Min_Value___(rebate_criteria_db_, agreement_currency_code_, 
                                             company_currency_code_, inv_amount_sum_, inv_curr_amount_sum_, 
                                             inv_qty_sum_, net_weight_, net_volume_, all_trans_rec_.customer_level,
                                             child_level_inv_sums_);
                                        
            -- Get the corresponding final rebate percentage
            rebate_rate_ := REBATE_AGR_SP_DEAL_FINAL_API.Get_Final_Rebate(agreement_id_,
                                                                           all_trans_rec_.rebate_type,
                                                                           all_trans_rec_.part_no,
                                                                           all_trans_rec_.sales_unit_meas,
                                                                           all_trans_rec_.hierarchy_id,
                                                                           all_trans_rec_.customer_level,
                                                                           min_value_,
                                                                           period_stop_on_);

            -- Update the rebate transactions with the final rebate %
            Rebate_Transaction_Util_API.Add_Final_Rebate(agreement_id_,
                                                         company_,
                                                         customer_no_,
                                                         all_trans_rec_.hierarchy_id,
                                                         all_trans_rec_.customer_level,
                                                         NULL,    -- sales_part_rebate_group,
                                                         NULL,    -- assortment_id
                                                         NULL,    -- assortment_node_id
                                                         all_trans_rec_.part_no,
                                                         all_trans_rec_.sales_unit_meas,
                                                         all_trans_rec_.rebate_type,
                                                         all_trans_rec_.tax_code,
                                                         rebate_rate_,
                                                         all_trans_rec_.invoice_id, 
                                                         all_trans_rec_.item_id);
         END LOOP;
      END LOOP;
      
   -- For all customer purchases
   ELSIF sales_rebate_basis_ = Rebate_Sales_Part_Basis_API.DB_TOTAL_CUSTOMER_SALES THEN
      -- Get total invoice amount for all customers invoice lines
      OPEN get_invoice_amount_all_sales(company_, customer_no_, start_date_, end_date_);
      FETCH get_invoice_amount_all_sales INTO inv_amount_sum_, inv_qty_sum_, 
                                                net_weight_, net_volume_, inv_curr_amount_sum_;
      CLOSE get_invoice_amount_all_sales;

      IF children_ > 0 THEN
         -- The agreement has deal lines defined from child levels. So need to consider sales from the children.
         FOR i_ IN 1 .. children_ LOOP
            customer_no_tab_ := CUST_HIERARCHY_STRUCT_API.Get_Customers_In_Level(agreement_rec_.hierarchy_id, 
                                                                                 child_line_levels_(i_).customer_level);
            -- Consider customers in child level for their total sales.
            IF (customer_no_tab_.COUNT > 0) THEN
               -- Get the children's total invoice amount for the sales part rebate group
               FOR c_ IN 1 .. customer_no_tab_.COUNT LOOP
                  OPEN get_invoice_amount_all_sales(company_, customer_no_tab_(c_), start_date_, end_date_);
                  FETCH get_invoice_amount_all_sales INTO inv_amount_child_, inv_qty_child_, 
                                                            net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                  CLOSE get_invoice_amount_all_sales;

                  IF (Child_Has_Reb_Trans___(rebate_criteria_db_, 
                                             agreement_currency_code_,
                                             company_currency_code_,
                                             inv_amount_child_,
                                             inv_curr_amt_child_,
                                             inv_qty_child_,
                                             net_weight_child_,
                                             net_volume_child_ ) = FALSE) THEN 
                     -- Child customer might have sales even though there are no agreements valid for him
                     OPEN get_inv_amount_all_sales_child(company_, customer_no_tab_(c_), start_date_, end_date_);
                     FETCH get_inv_amount_all_sales_child INTO inv_amount_child_, inv_qty_child_, 
                                                              net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                     CLOSE get_inv_amount_all_sales_child;
                  END IF;

                  inv_amount_children_sum_   := NVL(inv_amount_children_sum_, 0) + NVL(inv_amount_child_, 0);
                  inv_qty_children_sum_      := NVL(inv_qty_children_sum_, 0)    + NVL(inv_qty_child_, 0);
                  net_weight_children_       := NVL(net_weight_children_, 0)     + NVL(net_weight_child_, 0);
                  net_volume_children_       := NVL(net_volume_children_, 0)     + NVL(net_volume_child_, 0);
                  inv_curr_amt_child_sum_    := NVL(inv_curr_amt_child_sum_, 0)  + NVL(inv_curr_amt_child_, 0);
               END LOOP;
            END IF;
            -- Store under the level, so when rate calculates for the level the totals can be used
            child_level_inv_sums_(i_).child_level_       := child_line_levels_(i_).customer_level;
            child_level_inv_sums_(i_).inv_amount_child_  := NVL(inv_amount_children_sum_, 0);
            child_level_inv_sums_(i_).inv_qty_child_     := NVL(inv_qty_children_sum_, 0);
            child_level_inv_sums_(i_).net_weight_child_  := NVL(net_weight_children_, 0);
            child_level_inv_sums_(i_).net_volume_child_  := NVL(net_volume_children_, 0);
            child_level_inv_sums_(i_).inv_curr_amt_child_ := NVL(inv_curr_amt_child_sum_, 0);
            --Reset the commonly used variables
            Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                          net_volume_children_, inv_curr_amt_child_sum_);
         END LOOP; 
         --Reset the commonly used variables           
         Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                    net_volume_children_, inv_curr_amt_child_sum_);
      END IF;

      -- Get all transaction lines that should be updated
      FOR all_trans_rec_ IN get_all_transactions(company_, agreement_id_, 
                                                   customer_no_, start_date_, end_date_) LOOP
         
         min_value_ := Get_Min_Value___(rebate_criteria_db_, agreement_currency_code_, 
                                        company_currency_code_, inv_amount_sum_, inv_curr_amount_sum_, 
                                        inv_qty_sum_, net_weight_, net_volume_, all_trans_rec_.customer_level,
                                        child_level_inv_sums_);

         -- Get the corresponding final rebate percentage
         rebate_rate_ := REBATE_AGR_SP_DEAL_FINAL_API.Get_Final_Rebate(agreement_id_,
                                                                        all_trans_rec_.rebate_type,
                                                                        all_trans_rec_.part_no,
                                                                        all_trans_rec_.sales_unit_meas,
                                                                        all_trans_rec_.hierarchy_id,
                                                                        all_trans_rec_.customer_level,
                                                                        min_value_,
                                                                        period_stop_on_);

         -- Update the rebate transactions with the final rebate %
         Rebate_Transaction_Util_API.Add_Final_Rebate(agreement_id_,
                                                      company_,   
                                                      customer_no_,
                                                      all_trans_rec_.hierarchy_id,
                                                      all_trans_rec_.customer_level,
                                                      NULL,    -- sales_part_rebate_group,
                                                      NULL,    -- assortment_id
                                                      NULL,    -- assortment_node_id
                                                      all_trans_rec_.part_no,
                                                      all_trans_rec_.sales_unit_meas,
                                                      all_trans_rec_.rebate_type,
                                                      all_trans_rec_.tax_code,
                                                      rebate_rate_,
                                                      all_trans_rec_.invoice_id, 
                                                      all_trans_rec_.item_id);
      END LOOP;
   END IF;
END Calculate_Total_Sales_Part___;

PROCEDURE Calculate_Total_All_Parts___ (
   company_             IN VARCHAR2,
   agreement_id_        IN VARCHAR2,
   customer_no_         IN VARCHAR2,   
   start_date_          IN DATE,
   end_date_            IN DATE,
   period_stop_on_      IN DATE )
IS
   customer_level_          NUMBER;
   children_                NUMBER;
   inv_amount_sum_          NUMBER;
   inv_amount_children_sum_ NUMBER;
   inv_curr_amount_sum_     NUMBER;
   inv_curr_amt_child_sum_  NUMBER;
   inv_qty_sum_             NUMBER;
   inv_qty_children_sum_    NUMBER;
   rebate_rate_             NUMBER;
   min_value_               NUMBER;
   net_weight_              NUMBER;
   net_volume_              NUMBER;
   net_weight_children_     NUMBER;
   net_volume_children_     NUMBER;
   rebate_criteria_db_      rebate_agreement_tab.rebate_criteria%TYPE;
   agreement_currency_code_ VARCHAR2(3);
   company_currency_code_   VARCHAR2(3);  
   agreement_rec_           Rebate_Agreement_API.Public_Rec;
   customer_no_tab_         Cust_Hierarchy_Struct_API.Customer_No_Tab;
   net_weight_child_        NUMBER;
   net_volume_child_        NUMBER;
   inv_curr_amt_child_      NUMBER;
   inv_qty_child_           NUMBER;
   inv_amount_child_        NUMBER;
   child_level_inv_sums_    Hierarchy_level_Inv_Sums;
   
   -- Check if there are any agreement lines for the customer's children
   CURSOR get_line_levels (agreement_id_ IN VARCHAR2, customer_no_ IN VARCHAR2, customer_level_ IN NUMBER) IS
      SELECT rag.customer_level customer_level
      FROM rebate_agr_all_deal_tab rag, rebate_agreement_receiver_tab rar
      WHERE rag.agreement_id = rar.agreement_id
      AND   rag.agreement_id = agreement_id_
      AND   rar.customer_no = customer_no_
      AND   rag.customer_level > customer_level_
      AND   TRUNC(end_date_) BETWEEN TRUNC(rag.valid_from) AND TRUNC(NVL(rag.valid_to_date,Database_Sys.last_calendar_date_));   
   
   TYPE child_line_levels IS TABLE OF get_line_levels%ROWTYPE INDEX BY PLS_INTEGER;  
   child_line_levels_   child_line_levels;
   
   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the invoice lines for a customer
   CURSOR get_invoice_amount_all_sales (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                        start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum_, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Rebate_Trans_Invoice_Amounts
      WHERE  company = company_
      AND    customer_no = customer_no_
      AND    agreement_type = Rebate_Agreement_Type_API.DB_ALL
      AND    transaction_date BETWEEN start_date_ AND end_date_;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the children's invoice lines for a customer 
   CURSOR get_inv_amount_all_sales_child (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                          start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Order_Line_Invoice_Amounts
      WHERE company                 = company_
      AND   customer_no             = customer_no_
      AND   transaction_date BETWEEN start_date_ AND end_date_;

   CURSOR get_all_transactions (company_ IN VARCHAR2, agreement_id_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT rebate_type, part_no, sales_unit_meas, hierarchy_id, customer_level, tax_code, invoice_id, item_id
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   agreement_id = agreement_id_
      AND   customer_no = customer_no_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_ALL
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no IS NULL;

BEGIN
   agreement_rec_             := Rebate_Agreement_API.Get(agreement_id_);
   customer_level_            := agreement_rec_.customer_level;  
   rebate_criteria_db_        := agreement_rec_.rebate_criteria;
   agreement_currency_code_   := agreement_rec_.currency_code;
   company_currency_code_     := Company_Finance_API.Get_Currency_Code(company_);
   
   -- Are there agreement lines for the customer's children (higher customer level)
   OPEN get_line_levels (agreement_id_, customer_no_, customer_level_);
   FETCH get_line_levels BULK COLLECT INTO child_line_levels_;
   CLOSE get_line_levels;
   children_ := child_line_levels_.COUNT;

   -- Get total invoice amount for all customers invoice lines
   OPEN get_invoice_amount_all_sales(company_, customer_no_, start_date_, end_date_);
   FETCH get_invoice_amount_all_sales INTO inv_amount_sum_, inv_qty_sum_, net_weight_, net_volume_, inv_curr_amount_sum_;
   CLOSE get_invoice_amount_all_sales;

   IF children_ > 0 THEN
      -- The agreement has deal lines defined from child levels. So need to consider sales from the children.
      FOR i_ IN 1 .. children_ LOOP
         customer_no_tab_ := CUST_HIERARCHY_STRUCT_API.Get_Customers_In_Level(agreement_rec_.hierarchy_id, child_line_levels_(i_).customer_level);
         -- Consider customers in child level for their total sales.
         IF (customer_no_tab_.COUNT > 0) THEN
            -- Get the children's total invoice amount for the sales part rebate group
            FOR c_ IN 1 .. customer_no_tab_.COUNT LOOP
               OPEN get_invoice_amount_all_sales(company_, customer_no_tab_(c_), start_date_, end_date_);
               FETCH get_invoice_amount_all_sales INTO inv_amount_child_, inv_qty_child_, 
                                                   net_weight_child_, net_volume_child_, inv_curr_amt_child_;
               CLOSE get_invoice_amount_all_sales;

               IF (Child_Has_Reb_Trans___(rebate_criteria_db_, 
                                          agreement_currency_code_,
                                          company_currency_code_,
                                          inv_amount_child_,
                                          inv_curr_amt_child_,
                                          inv_qty_child_,
                                          net_weight_child_,
                                          net_volume_child_ ) = FALSE) THEN
                  -- Child customer might have sales even though there are no agreements valid for him
                  OPEN get_inv_amount_all_sales_child(company_, customer_no_tab_(c_), start_date_, end_date_);
                  FETCH get_inv_amount_all_sales_child INTO inv_amount_child_, inv_qty_child_, 
                                                       net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                  CLOSE get_inv_amount_all_sales_child;
               END IF;

               inv_amount_children_sum_   := NVL(inv_amount_children_sum_, 0) + NVL(inv_amount_child_, 0);
               inv_qty_children_sum_      := NVL(inv_qty_children_sum_, 0)    + NVL(inv_qty_child_, 0);
               net_weight_children_       := NVL(net_weight_children_, 0)     + NVL(net_weight_child_, 0);
               net_volume_children_       := NVL(net_volume_children_, 0)     + NVL(net_volume_child_, 0);
               inv_curr_amt_child_sum_    := NVL(inv_curr_amt_child_sum_, 0)  + NVL(inv_curr_amt_child_, 0);
            END LOOP;
         END IF;
         -- Store under the level, so when rate calculates for the level the totals can be used
         child_level_inv_sums_(i_).child_level_       := child_line_levels_(i_).customer_level;
         child_level_inv_sums_(i_).inv_amount_child_  := NVL(inv_amount_children_sum_, 0);
         child_level_inv_sums_(i_).inv_qty_child_     := NVL(inv_qty_children_sum_, 0);
         child_level_inv_sums_(i_).net_weight_child_  := NVL(net_weight_children_, 0);
         child_level_inv_sums_(i_).net_volume_child_  := NVL(net_volume_children_, 0);
         child_level_inv_sums_(i_).inv_curr_amt_child_ := NVL(inv_curr_amt_child_sum_, 0);
         --Reset the commonly used variables
         Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                    net_volume_children_, inv_curr_amt_child_sum_);
      END LOOP; 
      --Reset the commonly used variables           
      Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                 net_volume_children_, inv_curr_amt_child_sum_);
   END IF;

   -- Get all transaction lines that should be updated
   FOR all_trans_rec_ IN get_all_transactions(company_, agreement_id_, customer_no_, start_date_, end_date_) LOOP

      min_value_ := Get_Min_Value___(rebate_criteria_db_, agreement_currency_code_, 
                                       company_currency_code_, inv_amount_sum_, inv_curr_amount_sum_, 
                                       inv_qty_sum_, net_weight_, net_volume_, all_trans_rec_.customer_level,
                                       child_level_inv_sums_);
      -- Get the corresponding final rebate percentage
      rebate_rate_ := REBATE_AGR_ALL_DEAL_FINAL_API.Get_Final_Rebate(agreement_id_,
                                                                     all_trans_rec_.rebate_type,
                                                                     all_trans_rec_.hierarchy_id,
                                                                     all_trans_rec_.customer_level,
                                                                     min_value_,
                                                                     period_stop_on_);

      -- Update the rebate transactions with the final rebate %
      Rebate_Transaction_Util_API.Add_Final_Rebate(agreement_id_,
                                                   company_,   
                                                   customer_no_,
                                                   all_trans_rec_.hierarchy_id,
                                                   all_trans_rec_.customer_level,
                                                   NULL,    -- sales_part_rebate_group,
                                                   NULL,    -- assortment_id
                                                   NULL,    -- assortment_node_id
                                                   NULL,    -- part_no
                                                   NULL,    -- sales_unit_meas                                                   
                                                   all_trans_rec_.rebate_type,
                                                   all_trans_rec_.tax_code,
                                                   rebate_rate_,
                                                   all_trans_rec_.invoice_id, 
                                                   all_trans_rec_.item_id);
   END LOOP;
END Calculate_Total_All_Parts___;

FUNCTION Child_Has_Reb_Trans___ ( 
rebate_criteria_db_        IN VARCHAR2,
agreement_currency_code_   IN VARCHAR2,
company_currency_code_     IN VARCHAR2,
inv_amount_child_          IN NUMBER,
inv_curr_amt_child_        IN NUMBER,
inv_qty_child_             IN NUMBER,
net_weight_child_          IN NUMBER,
net_volume_child_          IN NUMBER
   ) RETURN BOOLEAN 
IS
   child_has_reb_transactions_      BOOLEAN := FALSE;
BEGIN
   CASE rebate_criteria_db_
      WHEN 'PERCENTAGE' THEN
         IF (agreement_currency_code_ = company_currency_code_) THEN
            IF NVL(inv_amount_child_, 0) = 0 THEN
               child_has_reb_transactions_ := FALSE;
            ELSE
               child_has_reb_transactions_ := TRUE;
            END IF;
         ELSE
            IF NVL(inv_curr_amt_child_, 0) = 0 THEN
               child_has_reb_transactions_ := FALSE;
            ELSE
               child_has_reb_transactions_ := TRUE;
            END IF;
         END IF;   
      WHEN 'AMOUNT_PER_INVOICED_QTY' THEN
         IF NVL(inv_qty_child_, 0) = 0 THEN
            child_has_reb_transactions_ := FALSE;
         ELSE
            child_has_reb_transactions_ := TRUE;
         END IF;
      WHEN 'AMOUNT_PER_NET_WEIGHT' THEN
         IF NVL(net_weight_child_, 0) = 0 THEN
            child_has_reb_transactions_ := FALSE;
         ELSE
            child_has_reb_transactions_ := TRUE;
         END IF;
      WHEN 'AMOUNT_PER_NET_VOLUME' THEN  
         IF NVL(net_volume_child_, 0) = 0 THEN
            child_has_reb_transactions_ := FALSE;
         ELSE
            child_has_reb_transactions_ := TRUE;
         END IF;
   END CASE;

   RETURN child_has_reb_transactions_;
END Child_Has_Reb_Trans___;

FUNCTION Get_Min_Value___ ( 
rebate_criteria_db_        IN VARCHAR2,
agreement_currency_code_   IN VARCHAR2,
company_currency_code_     IN VARCHAR2,
inv_amount_sum_            IN NUMBER,
inv_curr_amount_sum_       IN NUMBER,
inv_qty_sum_               IN NUMBER,
net_weight_                IN NUMBER,
net_volume_                IN NUMBER,
customer_level_            IN NUMBER,
child_level_inv_sums_      IN Hierarchy_level_Inv_Sums
   ) RETURN NUMBER 
IS
   min_value_                 NUMBER := 0;
   inv_amount_children_sum_   NUMBER := 0;
   inv_curr_amt_child_sum_    NUMBER := 0;
   inv_qty_children_sum_      NUMBER := 0;
   net_weight_children_       NUMBER := 0;
   net_volume_children_       NUMBER := 0;
BEGIN
   
   Get_Level_Inv_Sums___ (inv_amount_children_sum_,
                           inv_qty_children_sum_,
                           net_weight_children_,
                           net_volume_children_,
                           inv_curr_amt_child_sum_,
                           customer_level_,
                           child_level_inv_sums_);
            
   CASE rebate_criteria_db_
      WHEN 'PERCENTAGE' THEN
         IF (agreement_currency_code_ = company_currency_code_) THEN
            min_value_ := NVL(inv_amount_sum_, 0) + NVL(inv_amount_children_sum_, 0);
         ELSE
            min_value_ := NVL(inv_curr_amount_sum_ , 0) + NVL(inv_curr_amt_child_sum_, 0);
         END IF;   
      WHEN 'AMOUNT_PER_INVOICED_QTY' THEN
         min_value_ := NVL(inv_qty_sum_ , 0) + NVL(inv_qty_children_sum_, 0);
      WHEN 'AMOUNT_PER_NET_WEIGHT' THEN
         min_value_ := NVL(net_weight_ , 0) + NVL(net_weight_children_, 0);
      WHEN 'AMOUNT_PER_NET_VOLUME' THEN  
         min_value_ := NVL(net_volume_ , 0) + NVL(net_volume_children_, 0);
   END CASE;
   RETURN min_value_;
END Get_Min_Value___;

PROCEDURE Get_Level_Inv_Sums___ (
   inv_amount_children_sum_      OUT NUMBER,
   inv_qty_children_sum_         OUT NUMBER,
   net_weight_children_          OUT NUMBER,
   net_volume_children_          OUT NUMBER,
   inv_curr_amt_child_sum_       OUT NUMBER,
   customer_level_               IN NUMBER,
   child_level_inv_sums_         IN Hierarchy_level_Inv_Sums) 
IS
BEGIN
   Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                 net_volume_children_, inv_curr_amt_child_sum_);
   IF child_level_inv_sums_.COUNT > 0 THEN
      FOR i_ IN 1 .. child_level_inv_sums_.COUNT LOOP
         -- Fetch the total child invoice amount sums for the level that the final rebate rate going to be fetched 
         IF customer_level_ = child_level_inv_sums_(i_).child_level_ THEN
            inv_amount_children_sum_   := child_level_inv_sums_(i_).inv_amount_child_;
            inv_qty_children_sum_      := child_level_inv_sums_(i_).inv_qty_child_;
            net_weight_children_       := child_level_inv_sums_(i_).net_weight_child_;
            net_volume_children_       := child_level_inv_sums_(i_).net_volume_child_;
            inv_curr_amt_child_sum_    := child_level_inv_sums_(i_).inv_curr_amt_child_;
         END IF;

         EXIT WHEN customer_level_ = child_level_inv_sums_(i_).child_level_;
      END LOOP; 
   END IF;
END Get_Level_Inv_Sums___;

PROCEDURE Reset_Children_Sum_Vars___(
   inv_amount_children_sum_ IN OUT NUMBER, 
   inv_qty_children_sum_    IN OUT NUMBER,
   net_weight_children_     IN OUT NUMBER,
   net_volume_children_     IN OUT NUMBER,
   inv_curr_amt_child_sum_  IN OUT NUMBER) 
IS
BEGIN
   inv_amount_children_sum_ := 0;
   inv_qty_children_sum_    := 0;
   net_weight_children_     := 0;
   net_volume_children_     := 0;
   inv_curr_amt_child_sum_  := 0;
END Reset_Children_Sum_Vars___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Aggregate_Period_Settlement__ (
   attr_ IN VARCHAR2 )
IS
   ptr_                        NUMBER;
   name_                       VARCHAR2(30);
   value_                      VARCHAR2(2000);
   company_                    VARCHAR2(20);
   agreement_id_               VARCHAR2(10);
   customer_no_                Rebate_Periodic_Agg_Head_Tab.customer_no%TYPE;
   to_date_                    DATE;
   cust_agreement_id_          VARCHAR2(10);
   agreement_rec_              Rebate_Agreement_API.Public_Rec;
   period_settlement_interval_ VARCHAR2(20);
   hierarchy_id_               VARCHAR2(10);
   customer_level_             NUMBER;
   active_process_             NUMBER;
   last_run_date_              DATE;
   transaction_date_           DATE;
   start_date_                 DATE;
   end_date_                   DATE;
   process_id_                 NUMBER;
   aggregation_no_             NUMBER;
   proc_attr_                  VARCHAR2(500);
   lines_created_              BOOLEAN := FALSE;
   agr_company_error_          EXCEPTION;
   period_stop_on_             DATE;
   aggregation_ran_empty_      BOOLEAN := TRUE;
   aggregation_no_to_log_      NUMBER;
   cust_agreement_list_        Rebate_Agreement_API.Agreement_Info_List;

   -- Get customers for the given agreement ID or the given customer
   CURSOR get_customers (company_ IN VARCHAR2, agreement_id_ IN VARCHAR2, customer_no_ IN VARCHAR2) IS
      SELECT customer_no
      FROM rebate_agreement_receiver rar, rebate_agreement_tab ra
      WHERE company = company_
      AND   ra.agreement_id = rar.agreement_id
      AND   rar.agreement_id LIKE NVL(agreement_id_, '%')
      AND   customer_no LIKE NVL(customer_no_, customer_no)
      AND   ra.period_settlement_interval != 'NOT_APPLICABLE';

   -- Check if any aggregation is ongoing for this customer
   CURSOR get_active_process (customer_no_ IN VARCHAR2, company_ IN VARCHAR2) IS
      SELECT 1
      FROM rebate_periodic_agg_log_tab
      WHERE customer_no = customer_no_
      AND   company = company_
      AND   status = 'EXECUTING';

   -- Get the earliest transaction_date that is not already aggregated
   CURSOR get_transaction_date (customer_no_ IN VARCHAR2, agreement_id_ IN VARCHAR2) IS
      SELECT MIN(transaction_date)
      FROM  rebate_transaction_tab
      WHERE customer_no = customer_no_
      AND   agreement_id = agreement_id_
      AND   period_aggregation_no IS NULL;

BEGIN
   -- In parameters are:  Agreement_id or %       OR
   --                     Customer_no
   --                     To_date - should only be used in special cases
   --                     Company - always included

   -- Unpack the in parameters
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'COMPANY') THEN
         company_ := value_;
      ELSIF (name_ = 'AGREEMENT_ID') THEN
         agreement_id_ := value_;
      ELSIF (name_ = 'CUSTOMER_NO') THEN
         customer_no_ := value_;
      ELSIF (name_ = 'TO_DATE') THEN
         to_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   -- If the agreement ID is given, read the agreement information to parameters
   IF agreement_id_ IS NOT NULL THEN
      -- Check that the agreement given is created for the correct company.
      IF company_ != Rebate_Agreement_API.Get_Company(agreement_id_) THEN
         RAISE agr_company_error_;
      END IF;

      cust_agreement_list_(1).agreement_id  := agreement_id_;
      agreement_rec_  := Rebate_Agreement_API.Get(agreement_id_);
      cust_agreement_list_(1).hierarchy_id := agreement_rec_.hierarchy_id;
      cust_agreement_list_(1).customer_level := agreement_rec_.customer_level;
   END IF;

   -- Get customers to be aggregated
   FOR customer_rec_ IN get_customers (company_, agreement_id_, customer_no_) LOOP

      -- Check whether the customer_no has any already executing aggregations
      OPEN get_active_process(customer_rec_.customer_no, company_);
      FETCH get_active_process INTO active_process_;
      CLOSE get_active_process;

      IF active_process_ = 1 THEN
         Error_SYS.Record_General(lu_name_, 'AGG_ERROR: An aggregation for customer :P1 is already running.', customer_rec_.customer_no);
      END IF;

      -- If the agreement ID is not given get the active agreement for the customers
      IF (agreement_id_ IS NULL) OR (agreement_id_ = '%') THEN
         -- Get the necessary information from the active agreement
         Rebate_Agreement_Receiver_API.Get_Active_Agreement(cust_agreement_list_, customer_rec_.customer_no, company_, SYSDATE);
      END IF;

      IF to_date_ IS NULL THEN
         period_stop_on_ := SYSDATE;
      ELSE
         period_stop_on_ := to_date_;
      END IF;
      
      IF cust_agreement_list_.COUNT > 0 THEN
         
         FOR agreement_ IN 1 .. cust_agreement_list_.COUNT LOOP
            
            cust_agreement_id_          := cust_agreement_list_(agreement_).agreement_id;
            agreement_rec_  := Rebate_Agreement_API.Get(cust_agreement_id_);
            period_settlement_interval_ := agreement_rec_.period_settlement_interval;
            hierarchy_id_               := cust_agreement_list_(agreement_).hierarchy_id;
            customer_level_             := cust_agreement_list_(agreement_).customer_level;
            
            -- Get the last date the aggregation was run, if its null then use the earliest transaction date
            last_run_date_ := Rebate_Periodic_Agg_Log_API.Get_Last_Run_Date(company_, customer_rec_.customer_no, cust_agreement_id_);

            IF (last_run_date_ IS NULL) THEN
               OPEN get_transaction_date(customer_rec_.customer_no, cust_agreement_id_);
               FETCH get_transaction_date INTO transaction_date_;
               CLOSE get_transaction_date;
               last_run_date_ := transaction_date_;
            END IF;

            -- The last_run_date_ will still be null if there are no rebate transactions for this customer.
            -- then exclude from aggregation process.
            IF last_run_date_ IS NOT NULL THEN

               -- Get the dates for the period (Month, Quarter, Half Year or Year)
               start_date_ := Get_Date_From(period_settlement_interval_, last_run_date_);
               end_date_   := Get_Date_Until(period_settlement_interval_, start_date_);

               -- Add info to log table
               Client_SYS.Add_To_Attr('COMPANY',  company_, proc_attr_);
               Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_rec_.customer_no, proc_attr_);
               Client_SYS.Add_To_Attr('LAST_RUN_DATE', trunc(period_stop_on_), proc_attr_);
               Client_SYS.Add_To_Attr('AGREEMENT_ID ', cust_agreement_id_, proc_attr_);
               Client_SYS.Add_To_Attr('STATUS', Rebate_Process_Status_API.Decode('EXECUTING'), proc_attr_);
               Rebate_Periodic_Agg_Log_API.New(proc_attr_, process_id_);

               -- Do the aggregation for one or several periods
               WHILE end_date_ < period_stop_on_ LOOP

                  @ApproveTransactionStatement(2012-01-24,GanNLK)
                  SAVEPOINT do_aggregation;

                  -- Create aggregation header
                  Rebate_Periodic_Agg_Head_API.NEW(aggregation_no_,
                                                   company_,
                                                   customer_rec_.customer_no,
                                                   cust_agreement_id_,
                                                   hierarchy_id_,
                                                   customer_level_,
                                                   start_date_,
                                                   end_date_);

                  -- Set lines_created_ to false for every new aggregation head
                  lines_created_ := FALSE;
                  Add_Prd_Aggrigate_Lines___(lines_created_, aggregation_ran_empty_, company_, cust_agreement_id_, customer_rec_.customer_no, aggregation_no_, start_date_, end_date_);

                  -- If no lines are created then no header should be created
                  IF NOT lines_created_ THEN
                     @ApproveTransactionStatement(2012-01-24,GanNLK)
                     ROLLBACK TO do_aggregation;
                  ELSE
                     aggregation_no_to_log_ := aggregation_no_;
                  END IF;

                  -- Recalculate the start date and end date to make sure that all periods are aggregated
                  start_date_ := end_date_ + 1;
                  end_date_   := Get_Date_Until(period_settlement_interval_, start_date_);
               END LOOP;

               IF (to_date_ IS NOT NULL) THEN
                  end_date_ := to_date_;

                  @ApproveTransactionStatement(2012-01-24,GanNLK)
                  SAVEPOINT do_to_date_aggr;

                  -- Create aggregation header
                  Rebate_Periodic_Agg_Head_API.NEW(aggregation_no_,
                                                   company_,
                                                   customer_rec_.customer_no,
                                                   cust_agreement_id_,
                                                   hierarchy_id_,
                                                   customer_level_,
                                                   start_date_,
                                                   end_date_);
                  -- Set lines_created_ to false for every new aggregation head
                  lines_created_ := FALSE;

                  Add_Prd_Aggrigate_Lines___(lines_created_, aggregation_ran_empty_, company_, cust_agreement_id_, customer_rec_.customer_no, aggregation_no_, start_date_, end_date_);

                  -- If no lines are created then no header should be created
                  IF NOT lines_created_ THEN
                     @ApproveTransactionStatement(2012-01-24,GanNLK)
                     ROLLBACK TO do_to_date_aggr;
                  ELSE
                     aggregation_no_to_log_ := aggregation_no_;
                  END IF;
               END IF;

               Client_SYS.Clear_Attr(proc_attr_);
               IF (aggregation_ran_empty_) THEN
                  Client_SYS.Add_To_Attr('STATUS', Rebate_Process_Status_API.Decode('ERROR'), proc_attr_);
               ELSE
                  Client_SYS.Add_To_Attr('AGGREGATION_NO', aggregation_no_to_log_, proc_attr_);
                  Client_SYS.Add_To_Attr('STATUS', Rebate_Process_Status_API.Decode('COMPLETE'), proc_attr_);
               END IF;
               Rebate_Periodic_Agg_Log_API.Modify(proc_attr_, process_id_);
            END IF;
         END LOOP;
         
      END IF;   
      
   END LOOP;
EXCEPTION
   WHEN agr_company_error_ THEN
      Error_SYS.Record_General(lu_name_, 'AGRCOMPANYERROR: The agreement :P1 is not created on company :P2 and cannot be processed', agreement_id_, company_);
   WHEN others THEN
     Client_SYS.Clear_Attr(proc_attr_);
     IF (aggregation_no_to_log_ IS NOT NULL) THEN
        Client_SYS.Add_To_Attr('AGGREGATION_NO', aggregation_no_to_log_, proc_attr_);        
     END IF;
     Client_SYS.Add_To_Attr('STATUS', Rebate_Process_Status_API.Decode('ERROR'), proc_attr_);
     Rebate_Periodic_Agg_Log_API.Modify(proc_attr_, process_id_);
     RAISE;
END Aggregate_Period_Settlement__;


PROCEDURE Aggregate_Final_Settlement__ (
   attr_ IN VARCHAR2 )
IS
   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);
   company_                   VARCHAR2(20);
   agreement_id_              VARCHAR2(10);
   customer_no_               Rebate_Final_Agg_Head_Tab.customer_no%TYPE;
   to_date_                   DATE;
   cust_agreement_id_         VARCHAR2(10);
   agreement_rec_             Rebate_Agreement_API.Public_Rec;
   final_settlement_interval_ VARCHAR2(20);
   hierarchy_id_              VARCHAR2(10);
   customer_level_            NUMBER;
   active_process_            NUMBER;
   last_run_date_             DATE;
   transaction_date_          DATE;
   start_date_                DATE;
   end_date_                  DATE;
   process_id_                NUMBER;
   aggregation_no_            NUMBER;
   proc_attr_                 VARCHAR2(500);
   lines_created_             BOOLEAN := FALSE;
   agr_company_error_         EXCEPTION;
   period_stop_on_            DATE;
   aggregation_ran_empty_     BOOLEAN := TRUE;
   aggregation_no_to_log_     NUMBER;
   temp_period_start_         DATE;
   temp_period_end_           DATE;
   actual_period_end_date_    DATE;
   cust_agreement_list_        Rebate_Agreement_API.Agreement_Info_List;
   
   -- Get customers for the given agreement ID or the given customer
   CURSOR get_customers (company_ IN VARCHAR2, agreement_id_ IN VARCHAR2, customer_no_ IN VARCHAR2) IS
      SELECT customer_no
      FROM   rebate_agreement_receiver rar, rebate_agreement_tab ra
      WHERE  company = company_
      AND    ra.agreement_id = rar.agreement_id
      AND    rar.agreement_id LIKE NVL(agreement_id_, '%')
      AND    customer_no LIKE NVL(customer_no_, customer_no)
      AND    ra.final_settlement_interval != 'NOT_APPLICABLE';

   -- Check if any aggregation is ongoing for this customer
   CURSOR get_active_process (customer_no_ IN VARCHAR2, company_ IN VARCHAR2) IS
      SELECT 1
      FROM   rebate_final_agg_log_tab
      WHERE  customer_no = customer_no_
      AND    company = company_
      AND    status = 'EXECUTING';

   -- Get the earliest transaction_date that is not already aggregated
   CURSOR get_transaction_date (customer_no_ IN VARCHAR2, agreement_id_ IN VARCHAR2) IS
      SELECT MIN(transaction_date)
      FROM   rebate_transaction_tab
      WHERE  customer_no = customer_no_
      AND    agreement_id = agreement_id_
      AND    final_aggregation_no IS NULL;

BEGIN
   -- In parameters are:  Agreement_id or %       OR
   --                     Customer_no
   --                     To_date - should only be used in special cases
   --                     Company - always included

   -- Unpack the in parameters
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'COMPANY') THEN
         company_ := value_;
      ELSIF (name_ = 'AGREEMENT_ID') THEN
         agreement_id_ := value_;
      ELSIF (name_ = 'CUSTOMER_NO') THEN
         customer_no_ := value_;
      ELSIF (name_ = 'TO_DATE') THEN
         to_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   -- If the agreement ID is given, read the agreement information to parameters
   IF agreement_id_ IS NOT NULL THEN
      -- Check that the agreement given is created for the correct company.
      IF company_ != Rebate_Agreement_API.Get_Company(agreement_id_) THEN
         RAISE agr_company_error_;
      END IF;
      
      cust_agreement_list_(1).agreement_id  := agreement_id_;
      agreement_rec_  := Rebate_Agreement_API.Get(agreement_id_);
      cust_agreement_list_(1).hierarchy_id := agreement_rec_.hierarchy_id;
      cust_agreement_list_(1).customer_level := agreement_rec_.customer_level;
   END IF;

   -- Get customers to be aggregated
   FOR customer_rec_ IN get_customers(company_, agreement_id_, customer_no_) LOOP
      -- Check whether the customer_no has any already executing aggregations
      OPEN get_active_process(customer_rec_.customer_no, company_);
      FETCH get_active_process INTO active_process_;
      CLOSE get_active_process;

      IF active_process_ = 1 THEN
         Error_SYS.Record_General(lu_name_, 'AGG_ERROR: An aggregation for customer :P1 is already running.', customer_rec_.customer_no);
      END IF;

      -- If the agreement ID is null get the active agreement for the customers
      IF (agreement_id_ IS NULL) OR (agreement_id_ = '%') THEN
         -- Get the necessary information from the active agreement
         Rebate_Agreement_Receiver_API.Get_Active_Agreement(cust_agreement_list_, customer_rec_.customer_no, company_, SYSDATE);
         
      END IF;
      
      
      IF cust_agreement_list_.COUNT > 0 THEN
         
         FOR agreement_ IN 1 .. cust_agreement_list_.COUNT LOOP
            
            cust_agreement_id_          := cust_agreement_list_(agreement_).agreement_id;
            agreement_rec_             := Rebate_Agreement_API.Get(cust_agreement_id_);
            final_settlement_interval_ := agreement_rec_.final_settlement_interval;
            hierarchy_id_               := cust_agreement_list_(agreement_).hierarchy_id;
            customer_level_             := cust_agreement_list_(agreement_).customer_level;
      
            -- Get the last date the aggregation was run, if its null then use the earliest transaction date
            last_run_date_ := Rebate_Final_Agg_Log_API.Get_Last_Run_Date(company_, customer_rec_.customer_no, cust_agreement_id_);
            IF (last_run_date_ IS NULL) THEN
               OPEN get_transaction_date(customer_rec_.customer_no, cust_agreement_id_);
               FETCH get_transaction_date INTO transaction_date_;
               CLOSE get_transaction_date;
               last_run_date_ := transaction_date_;
            END IF;

            -- The last_run_date_ will still be null if there are no rebate transactions for this customer.
            -- then exclude from aggregation process.
            IF last_run_date_ IS NOT NULL THEN

               -- Get the dates for the period (Month, Quarter, Half Year or Year)
               start_date_ := Get_Date_From(final_settlement_interval_, last_run_date_);
               end_date_   := Get_Date_Until(final_settlement_interval_, start_date_);
               IF to_date_ IS NULL THEN
                  period_stop_on_    := SYSDATE;
                  temp_period_start_ := start_date_;              
                  temp_period_end_   := end_date_;
                  -- If to_date is not given the rebate rate should pick from the latest valid line for the period that is aggregations made.
                  WHILE temp_period_end_ < period_stop_on_ LOOP
                     temp_period_start_ := temp_period_end_ + 1;
                     temp_period_end_   := Get_Date_Until(final_settlement_interval_, temp_period_start_);
                  END LOOP;
                  IF (temp_period_start_ = start_date_) THEN
                     actual_period_end_date_ := temp_period_end_;
                  ELSE
                     actual_period_end_date_ := temp_period_start_ - 1;
                  END IF;
               ELSE
                  period_stop_on_         := to_date_;
                  actual_period_end_date_ := to_date_;
               END IF;

               -- Add info to log table
               Client_SYS.Add_To_Attr('COMPANY',  company_, proc_attr_);
               Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_rec_.customer_no, proc_attr_);
               Client_SYS.Add_To_Attr('LAST_RUN_DATE', trunc(period_stop_on_), proc_attr_);
               Client_SYS.Add_To_Attr('AGREEMENT_ID ', cust_agreement_id_, proc_attr_);
               Client_SYS.Add_To_Attr('STATUS', Rebate_Process_Status_API.Decode('EXECUTING'), proc_attr_);
               Rebate_Final_Agg_Log_API.New(proc_attr_, process_id_);

               -- Do the aggregation for one or several periods
               WHILE end_date_ < period_stop_on_ LOOP

                  @ApproveTransactionStatement(2012-01-24,GanNLK)
                  SAVEPOINT do_aggregation;

                  Calculate_Final_Settlelemt___ (company_,
                                                 cust_agreement_id_,
                                                 customer_rec_.customer_no,
                                                 agreement_rec_,
                                                 start_date_,
                                                 end_date_,
                                                 actual_period_end_date_);            

                  -- Create aggregation header
                  Rebate_Final_Agg_Head_API.NEW(aggregation_no_,
                                                company_,
                                                customer_rec_.customer_no,
                                                cust_agreement_id_,
                                                hierarchy_id_,
                                                customer_level_,
                                                start_date_,
                                                end_date_);

                  -- Group and create aggregation lines
                  Add_Final_Aggrigate_Lines___(lines_created_, aggregation_ran_empty_, company_, customer_rec_.customer_no, cust_agreement_id_, aggregation_no_, start_date_, end_date_);

                  -- If no lines are created then no header should be created
                  IF NOT lines_created_ THEN
                     @ApproveTransactionStatement(2012-01-24,GanNLK)
                     ROLLBACK TO do_aggregation;
                  ELSE
                     aggregation_no_to_log_ := aggregation_no_;
                  END IF;

                  @ApproveTransactionStatement(2013-02-28,ShKolk)
                  SAVEPOINT do_aggregation;

                  Calculate_Final_Settlelemt___ (company_,
                                                 cust_agreement_id_,
                                                 customer_rec_.customer_no,
                                                 agreement_rec_,
                                                 start_date_,
                                                 end_date_,
                                                 actual_period_end_date_);

                  -- Create aggregation header
                  Rebate_Final_Agg_Head_API.NEW(aggregation_no_,
                                                company_,
                                                customer_rec_.customer_no,
                                                cust_agreement_id_,
                                                hierarchy_id_,
                                                customer_level_,
                                                start_date_,
                                                end_date_);

                  -- Set lines_created_ to false for every new aggregation head
                  lines_created_ := FALSE;

                  -- Group and create aggregation lines
                  Add_Final_Aggrigate_Lines___(lines_created_, aggregation_ran_empty_, company_, customer_rec_.customer_no, cust_agreement_id_, aggregation_no_, start_date_, end_date_);

                  -- If no lines are created then no header should be created
                  IF NOT lines_created_ THEN
                     @ApproveTransactionStatement(2013-02-28,ShKolk)
                     ROLLBACK TO do_aggregation;
                  ELSE
                     aggregation_no_to_log_ := aggregation_no_;
                  END IF;

                  -- Recalculate the start date and end date to make sure that all periods are aggregated
                  start_date_ := end_date_ + 1;
                  end_date_   := Get_Date_Until(final_settlement_interval_, start_date_);
               END LOOP;

               IF (to_date_ IS NOT NULL) THEN
                  end_date_ := to_date_;


                  @ApproveTransactionStatement(2012-01-24,GanNLK)
                  SAVEPOINT do_to_date_aggr;

                  Calculate_Final_Settlelemt___ (company_,
                                                 cust_agreement_id_,
                                                 customer_rec_.customer_no,
                                                 agreement_rec_,
                                                 start_date_,
                                                 end_date_,
                                                 actual_period_end_date_);

                  -- Create aggregation header
                  Rebate_Final_Agg_Head_API.NEW(aggregation_no_,
                                                company_,
                                                customer_rec_.customer_no,
                                                cust_agreement_id_,
                                                hierarchy_id_,
                                                customer_level_,
                                                start_date_,
                                                end_date_);
                  -- Group and create aggregation lines
                  Add_Final_Aggrigate_Lines___(lines_created_, aggregation_ran_empty_, company_, customer_rec_.customer_no, cust_agreement_id_, aggregation_no_, start_date_, end_date_);

                  -- If no lines are created then no header should be created            
                  IF NOT lines_created_ THEN
                     @ApproveTransactionStatement(2012-01-24,GanNLK)
                     ROLLBACK TO do_to_date_aggr;
                  ELSE
                     aggregation_no_to_log_ := aggregation_no_;
                  END IF;


                  @ApproveTransactionStatement(2013-02-28,ShKolk)
                  SAVEPOINT do_to_date_aggr;

                  Calculate_Final_Settlelemt___ (company_,
                                                 cust_agreement_id_,
                                                 customer_rec_.customer_no,
                                                 agreement_rec_,
                                                 start_date_,
                                                 end_date_,
                                                 actual_period_end_date_);

                  -- Create aggregation header
                  Rebate_Final_Agg_Head_API.NEW(aggregation_no_,
                                                company_,
                                                customer_rec_.customer_no,
                                                cust_agreement_id_,
                                                hierarchy_id_,
                                                customer_level_,
                                                start_date_,
                                                end_date_);
                  -- Group and create aggregation lines
                  Add_Final_Aggrigate_Lines___(lines_created_, aggregation_ran_empty_, company_, customer_rec_.customer_no, cust_agreement_id_, aggregation_no_, start_date_, end_date_);

                  -- If no lines are created then no header should be created
                  IF NOT lines_created_ THEN
                     @ApproveTransactionStatement(2013-02-28,ShKolk)
                     ROLLBACK TO do_to_date_aggr;
                  ELSE
                     aggregation_no_to_log_ := aggregation_no_;
                  END IF;
               END IF;
               Client_SYS.Clear_Attr(proc_attr_);
               IF (aggregation_ran_empty_) THEN
                  Client_SYS.Add_To_Attr('STATUS', Rebate_Process_Status_API.Decode('ERROR'), proc_attr_);
               ELSE
                  Client_SYS.Add_To_Attr('AGGREGATION_NO', aggregation_no_to_log_, proc_attr_);
                  Client_SYS.Add_To_Attr('STATUS', Rebate_Process_Status_API.Decode('COMPLETE'), proc_attr_);
               END IF;
               Rebate_Final_Agg_Log_API.Modify(proc_attr_, process_id_);
            END IF;
         END LOOP;
      END IF;   
   END LOOP;
EXCEPTION
   WHEN agr_company_error_ THEN
      Error_SYS.Record_General(lu_name_, 'AGRCOMPANYERROR: The agreement :P1 is not created on company :P2 and cannot be processed', agreement_id_, company_);
   WHEN others THEN
     Client_SYS.Clear_Attr(proc_attr_);
     IF (aggregation_no_to_log_ IS NOT NULL) THEN
        Client_SYS.Add_To_Attr('AGGREGATION_NO', aggregation_no_to_log_, proc_attr_);
     END IF;
     Client_SYS.Add_To_Attr('STATUS', Rebate_Process_Status_API.Decode('ERROR'), proc_attr_);
     Rebate_Final_Agg_Log_API.Modify(proc_attr_, process_id_);
     RAISE;
END Aggregate_Final_Settlement__;


PROCEDURE Process_Rebate_Settlements__ (
   attr_ IN VARCHAR2 )
IS
   ptr_              NUMBER;
   name_             VARCHAR2(30);
   value_            VARCHAR2(2000);
   aggregation_no_   NUMBER;
   print_invoice_    VARCHAR2(5) := 'FALSE';
   final_settlement_ VARCHAR2(5);
BEGIN
   -- Retrieve parameters from the attribute string
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'AGGREGATION_NO') THEN
         aggregation_no_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'PRINT_INVOICE') THEN
         print_invoice_ := value_;
      ELSIF (name_ = 'FINAL_SETTLEMENT') THEN
         final_settlement_ := value_;
      END IF;
   END LOOP;
   Invoice_Customer_Order_API.Create_Rebate_Credit_Invoice__(aggregation_no_, print_invoice_, final_settlement_);
END Process_Rebate_Settlements__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Date_From (
   settlement_interval_ IN VARCHAR2,
   date_                IN DATE ) RETURN DATE
IS
   quarter_   NUMBER;
   date_from_ DATE;
BEGIN
   -- date_from_ has to point to the first day of the month
   IF (settlement_interval_ = 'MONTH') THEN
      date_from_ := trunc(add_months(date_, -1), 'MON');
   ELSIF (settlement_interval_ = 'QUARTER') THEN
      quarter_ := to_number(to_char(date_, 'Q'));
      -- date_from_ should always be the first date of the earlier quarter
      IF (quarter_ = 1) THEN
         -- If quarter 1 the transactions should be aggregated for quarter 4 previous year
         date_from_ := to_date('0110' || (to_char(date_, 'YYYY') -1), 'DDMMYYYY');
      ELSIF (quarter_ = 2) THEN
         date_from_ := to_date('0101' || to_char(date_, 'YYYY'), 'DDMMYYYY');
      ELSIF (quarter_ = 3) THEN
         date_from_ := to_date('0104' || to_char(date_, 'YYYY'), 'DDMMYYYY');
      ELSIF (quarter_ = 4) THEN
         date_from_ := to_date('0107' || to_char(date_, 'YYYY'), 'DDMMYYYY');
      END IF;
   ELSIF (settlement_interval_ = 'HALF_YEAR') THEN
      quarter_ := to_number(to_char(date_, 'Q'));
      -- if quarter 1 or 2 the transactions should be aggregated for 2nd half of the year before
      IF ((quarter_ = 1) OR (quarter_ = 2)) THEN
         date_from_ := to_date('0107' || (to_char(date_, 'YYYY') -1), 'DDMMYYYY');
      ELSIF ((quarter_ = 3) OR (quarter_ = 4)) THEN
         date_from_ := to_date('0101' || to_char(date_, 'YYYY'), 'DDMMYYYY');
      END IF;
   ELSIF (settlement_interval_ = 'YEAR') THEN
      date_from_ := to_date('0101' || (to_char(date_, 'YYYY') -1), 'DDMMYYYY');
   END IF;
   RETURN date_from_;
END Get_Date_From;



@UncheckedAccess
FUNCTION Get_Date_Until (
   settlement_interval_ IN VARCHAR2,
   date_                IN DATE ) RETURN DATE
IS
   date_until_ DATE;
BEGIN
   IF (settlement_interval_ = 'MONTH') THEN
      -- If date_ is 2008-01-01 then date_until_ should be 2008-01-31
      date_until_ := add_months(date_, 1) -1;
   ELSIF (settlement_interval_ = 'QUARTER') THEN
      date_until_ := add_months(date_, 3) -1;
   ELSIF (settlement_interval_ = 'HALF_YEAR') THEN
      date_until_ := add_months(date_, 6) -1;
   ELSIF (settlement_interval_ = 'YEAR') THEN
      date_until_ := add_months(date_, 12) -1;
   END IF;
   RETURN date_until_;
END Get_Date_Until;

PROCEDURE Calculate_Total_Sales (
   company_             IN VARCHAR2,
   agreement_id_        IN VARCHAR2,
   customer_no_         IN VARCHAR2,
   sales_rebate_basis_  IN VARCHAR2,
   start_date_          IN DATE,
   end_date_            IN DATE,
   period_stop_on_      IN DATE )
IS
   customer_level_          NUMBER;
   children_                NUMBER;
   inv_amount_sum_          NUMBER;
   inv_amount_children_sum_ NUMBER;
   inv_qty_sum_             NUMBER;
   inv_qty_children_sum_    NUMBER;
   net_weight_              NUMBER;
   net_volume_              NUMBER;
   rebate_rate_             NUMBER;
   min_value_               NUMBER;
   net_weight_children_     NUMBER;
   net_volume_children_     NUMBER;
   rebate_criteria_db_      rebate_agreement_tab.rebate_criteria%TYPE;
   inv_curr_amount_sum_     NUMBER;
   inv_curr_amt_child_sum_  NUMBER;
   agreement_currency_code_ VARCHAR2(3);
   company_currency_code_   VARCHAR2(3);  
   agreement_rec_           Rebate_Agreement_API.Public_Rec;
   customer_no_tab_         Cust_Hierarchy_Struct_API.Customer_No_Tab;
   net_weight_child_        NUMBER;
   net_volume_child_        NUMBER;
   inv_curr_amt_child_      NUMBER;
   inv_qty_child_           NUMBER;
   inv_amount_child_        NUMBER;
   child_level_inv_sums_    Hierarchy_level_Inv_Sums;

   -- Check if there are any agreement lines for the customer's children
   CURSOR get_line_levels (agreement_id_ IN VARCHAR2, customer_no_ IN VARCHAR2, customer_level_ IN NUMBER) IS
      SELECT rag.customer_level customer_level
      FROM rebate_agreement_grp_deal_tab rag, rebate_agreement_receiver_tab rar
      WHERE rag.agreement_id = rar.agreement_id
      AND   rag.agreement_id = agreement_id_
      AND   rar.customer_no = customer_no_
      AND   rag.customer_level > customer_level_
      AND   TRUNC(end_date_) BETWEEN TRUNC(rag.valid_from) AND TRUNC(NVL(rag.valid_to_date,Database_Sys.last_calendar_date_));
      
   TYPE child_line_levels IS TABLE OF get_line_levels%ROWTYPE INDEX BY PLS_INTEGER;  
   child_line_levels_   child_line_levels;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the invoice lines for a specific sales part rebate group
   CURSOR get_invoice_amount (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                              start_date_ IN DATE, end_date_ IN DATE, agreement_id_ IN VARCHAR2) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum, sales_part_rebate_group
      FROM Rebate_Trans_Invoice_Amounts
      WHERE  agreement_type          = Rebate_Agreement_Type_API.DB_REBATE_GROUP
      AND    company                 = company_
      AND    customer_no             = customer_no_
      AND    agreement_id            = agreement_id_
      AND    transaction_date BETWEEN start_date_ AND end_date_
      GROUP BY sales_part_rebate_group;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the children's invoice lines for a specific sales part rebate group
   CURSOR get_invoice_amount_child (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                       start_date_ IN DATE, end_date_ IN DATE, rebate_group_ IN VARCHAR2) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Rebate_Trans_Invoice_Amounts
      WHERE  agreement_type          = Rebate_Agreement_Type_API.DB_REBATE_GROUP
      AND    company                 = company_
      AND    customer_no          = customer_no_ 
      AND    sales_part_rebate_group = rebate_group_
      AND    transaction_date BETWEEN start_date_ AND end_date_;
      
   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the children's invoice lines for a specific sales part rebate group 
   CURSOR get_invoice_amount_child2 (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                       start_date_ IN DATE, end_date_ IN DATE, rebate_group_ IN VARCHAR2) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Order_Line_Invoice_Amounts
      WHERE company                 = company_
      AND   customer_no             = customer_no_
      AND    sales_part_rebate_group = rebate_group_
      AND    transaction_date BETWEEN start_date_ AND end_date_;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the invoice lines for all sales part rebate groups
   CURSOR get_invoice_amount_all_groups (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                         start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Rebate_Trans_Invoice_Amounts
      WHERE  company           = company_
      AND    customer_no       = customer_no_
      AND    agreement_type    = Rebate_Agreement_Type_API.DB_REBATE_GROUP
      AND    sales_part_rebate_group IS NOT NULL
      AND    transaction_date BETWEEN start_date_ AND end_date_;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the children's invoice lines for all sales part rebate groups
   CURSOR get_inv_amount_all_group_child (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                       start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Order_Line_Invoice_Amounts
      WHERE company                 = company_
      AND   customer_no             = customer_no_
      AND   sales_part_rebate_group IS NOT NULL 
      AND   assortment_id  IS NULL
      AND   transaction_date BETWEEN start_date_ AND end_date_;   
   
   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the invoice lines for a customer
   CURSOR get_invoice_amount_all_sales (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                        start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Rebate_Trans_Invoice_Amounts
      WHERE  company           = company_
      AND    customer_no       = customer_no_
      AND    transaction_date  BETWEEN start_date_ AND end_date_;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the children's invoice lines for a customer
   CURSOR get_inv_amount_all_sales_child (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                          start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Order_Line_Invoice_Amounts
      WHERE company                 = company_
      AND   customer_no             = customer_no_
      AND   transaction_date BETWEEN start_date_ AND end_date_;
      
   CURSOR get_all_transactions (company_ IN VARCHAR2, agreement_id_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT rebate_type, sales_part_rebate_group, hierarchy_id, customer_level, tax_code, invoice_id, item_id
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   agreement_id = agreement_id_
      AND   customer_no = customer_no_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_REBATE_GROUP
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no IS NULL;
      
   CURSOR get_trans_per_grp (company_ IN VARCHAR2, agreement_id_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                start_date_ IN DATE, end_date_ IN DATE, rebate_group_ IN VARCHAR2) IS
      SELECT rebate_type, sales_part_rebate_group, hierarchy_id, customer_level, tax_code, invoice_id, item_id
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   agreement_id = agreement_id_
      AND   customer_no = customer_no_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_REBATE_GROUP
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   sales_part_rebate_group = rebate_group_
      AND   final_aggregation_no IS NULL;

BEGIN

   agreement_rec_             := Rebate_Agreement_API.Get(agreement_id_);
   customer_level_            := agreement_rec_.customer_level;  
   rebate_criteria_db_        := agreement_rec_.rebate_criteria;
   agreement_currency_code_   := agreement_rec_.currency_code;
   company_currency_code_     := Company_Finance_API.Get_Currency_Code(company_);
   
   -- Are there agreement lines for the customer's children (higher customer level)
   OPEN get_line_levels (agreement_id_, customer_no_, customer_level_);
   FETCH get_line_levels BULK COLLECT INTO child_line_levels_;
   CLOSE get_line_levels;
   children_ := child_line_levels_.COUNT;

   -- For a specific sales part rebate group
   IF sales_rebate_basis_ = 'SPECIFIC_REBATE_GROUP_SALES' THEN   
      FOR inv_rec_ IN get_invoice_amount(company_, customer_no_, start_date_, end_date_, agreement_id_)LOOP
         inv_amount_sum_      := NVL(inv_rec_.inv_amount_sum, 0);
         inv_qty_sum_         := NVL(inv_rec_.inv_qty_sum, 0);
         net_weight_          := NVL(inv_rec_.inv_net_weight, 0);
         net_volume_          := NVL(inv_rec_.inv_net_volume, 0);
         inv_curr_amount_sum_ := NVL(inv_rec_.inv_curr_amount_sum, 0);
         
         IF children_ > 0 THEN
            -- The agreement has deal lines defined from child levels. So need to consider sales from the children.
            FOR i_ IN 1 .. children_ LOOP
               customer_no_tab_ := CUST_HIERARCHY_STRUCT_API.Get_Customers_In_Level(agreement_rec_.hierarchy_id, child_line_levels_(i_).customer_level);
               -- Consider customers in child level for their total sales.
               IF (customer_no_tab_.COUNT > 0) THEN
                  -- Get the children's total invoice amount for the sales part rebate group
                  FOR c_ IN 1 .. customer_no_tab_.COUNT LOOP
                     OPEN get_invoice_amount_child(company_, customer_no_tab_(c_), start_date_, end_date_, inv_rec_.sales_part_rebate_group);
                     FETCH get_invoice_amount_child INTO inv_amount_child_, inv_qty_child_, 
                                                         net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                     CLOSE get_invoice_amount_child;
                                          
                     IF (Child_Has_Reb_Trans___(rebate_criteria_db_, 
                                                agreement_currency_code_,
                                                company_currency_code_,
                                                inv_amount_child_,
                                                inv_curr_amt_child_,
                                                inv_qty_child_,
                                                net_weight_child_,
                                                net_volume_child_ ) = FALSE) THEN
                        -- Child customer might have sales even though there are no agreements valid for him
                        OPEN get_invoice_amount_child2(company_, customer_no_tab_(c_), start_date_, end_date_, inv_rec_.sales_part_rebate_group);
                        FETCH get_invoice_amount_child2 INTO inv_amount_child_, inv_qty_child_, 
                                                             net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                        CLOSE get_invoice_amount_child2;
                     END IF;
                     
                     inv_amount_children_sum_   := NVL(inv_amount_children_sum_, 0) + NVL(inv_amount_child_, 0);
                     inv_qty_children_sum_      := NVL(inv_qty_children_sum_, 0)    + NVL(inv_qty_child_, 0);
                     net_weight_children_       := NVL(net_weight_children_, 0)     + NVL(net_weight_child_, 0);
                     net_volume_children_       := NVL(net_volume_children_, 0)     + NVL(net_volume_child_, 0);
                     inv_curr_amt_child_sum_    := NVL(inv_curr_amt_child_sum_, 0)  + NVL(inv_curr_amt_child_, 0);
                  END LOOP;
               END IF;
               -- Store under the level, so when rate calculates for the level the totals can be used
               child_level_inv_sums_(i_).child_level_       := child_line_levels_(i_).customer_level;
               child_level_inv_sums_(i_).inv_amount_child_  := NVL(inv_amount_children_sum_, 0);
               child_level_inv_sums_(i_).inv_qty_child_     := NVL(inv_qty_children_sum_, 0);
               child_level_inv_sums_(i_).net_weight_child_  := NVL(net_weight_children_, 0);
               child_level_inv_sums_(i_).net_volume_child_  := NVL(net_volume_children_, 0);
               child_level_inv_sums_(i_).inv_curr_amt_child_ := NVL(inv_curr_amt_child_sum_, 0);
               --Reset the commonly used variables
               Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                          net_volume_children_, inv_curr_amt_child_sum_);
            END LOOP; 
            --Reset the commonly used variables           
            Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                       net_volume_children_, inv_curr_amt_child_sum_);
         END IF;

         -- Get all transaction lines that should be updated
         FOR all_trans_rec_ IN get_trans_per_grp(company_, agreement_id_, customer_no_, start_date_, end_date_, inv_rec_.sales_part_rebate_group) LOOP
            
            min_value_ := Get_Min_Value___(rebate_criteria_db_, agreement_currency_code_, 
                                             company_currency_code_, inv_amount_sum_, inv_curr_amount_sum_, 
                                             inv_qty_sum_, net_weight_, net_volume_, all_trans_rec_.customer_level,
                                             child_level_inv_sums_);                                                                                       

            -- Get the corresponding final rebate percentage
            rebate_rate_ := Rebate_Agr_Grp_Deal_Final_API.Get_Final_Rebate(agreement_id_,
                                                                           all_trans_rec_.rebate_type,
                                                                           all_trans_rec_.sales_part_rebate_group,
                                                                           all_trans_rec_.hierarchy_id,
                                                                           all_trans_rec_.customer_level,
                                                                           min_value_,
                                                                           period_stop_on_);

            -- Update the rebate transactions with the final rebate %
            Rebate_Transaction_Util_API.Add_Final_Rebate(agreement_id_,
                                                         company_,
                                                         customer_no_,
                                                         all_trans_rec_.hierarchy_id,
                                                         all_trans_rec_.customer_level,
                                                         all_trans_rec_.sales_part_rebate_group,
                                                         NULL,    -- assortment_id
                                                         NULL,    -- assortment_node_id
                                                         NULL,    -- part_no
                                                         NULL,    -- sales_unit_meas                                                      
                                                         all_trans_rec_.rebate_type,
                                                         all_trans_rec_.tax_code,
                                                         rebate_rate_,
                                                         all_trans_rec_.invoice_id, 
                                                         all_trans_rec_.item_id);
         END LOOP;
      END LOOP;   
   
   -- For all sales part rebate groups
   ELSIF sales_rebate_basis_ = 'ALL_REBATE_GROUPS_SALES' THEN
      -- Get total invoice amount for all sales part rebate groups
      OPEN get_invoice_amount_all_groups(company_, customer_no_, start_date_, end_date_);
      FETCH get_invoice_amount_all_groups INTO inv_amount_sum_, inv_qty_sum_, net_weight_, net_volume_, inv_curr_amount_sum_;
      CLOSE get_invoice_amount_all_groups;

      IF children_ > 0 THEN
         -- The agreement has deal lines defined from child levels. So need to consider sales from the children.
         FOR i_ IN 1 .. children_ LOOP
            customer_no_tab_ := CUST_HIERARCHY_STRUCT_API.Get_Customers_In_Level(agreement_rec_.hierarchy_id, 
                                                                                 child_line_levels_(i_).customer_level);
            -- Consider customers in child level for their total sales.
            IF (customer_no_tab_.COUNT > 0) THEN
               -- Get the children's total invoice amount for the sales part rebate group
               FOR c_ IN 1 .. customer_no_tab_.COUNT LOOP
                  OPEN get_invoice_amount_all_groups(company_, customer_no_tab_(c_), start_date_, end_date_);
                  FETCH get_invoice_amount_all_groups INTO inv_amount_child_, inv_qty_child_, 
                                                            net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                  CLOSE get_invoice_amount_all_groups;

                  IF (Child_Has_Reb_Trans___(rebate_criteria_db_, 
                                             agreement_currency_code_,
                                             company_currency_code_,
                                             inv_amount_child_,
                                             inv_curr_amt_child_,
                                             inv_qty_child_,
                                             net_weight_child_,
                                             net_volume_child_ ) = FALSE) THEN 
                     -- Child customer might have sales even though there are no agreements valid for him
                     OPEN get_inv_amount_all_group_child(company_, customer_no_tab_(c_), start_date_, end_date_);
                     FETCH get_inv_amount_all_group_child INTO inv_amount_child_, inv_qty_child_, 
                                                              net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                     CLOSE get_inv_amount_all_group_child;
                  END IF;

                  inv_amount_children_sum_   := NVL(inv_amount_children_sum_, 0) + NVL(inv_amount_child_, 0);
                  inv_qty_children_sum_      := NVL(inv_qty_children_sum_, 0)    + NVL(inv_qty_child_, 0);
                  net_weight_children_       := NVL(net_weight_children_, 0)     + NVL(net_weight_child_, 0);
                  net_volume_children_       := NVL(net_volume_children_, 0)     + NVL(net_volume_child_, 0);
                  inv_curr_amt_child_sum_    := NVL(inv_curr_amt_child_sum_, 0)  + NVL(inv_curr_amt_child_, 0);
               END LOOP;
            END IF;
            -- Store under the level, so when rate calculates for the level the totals can be used
            child_level_inv_sums_(i_).child_level_       := child_line_levels_(i_).customer_level;
            child_level_inv_sums_(i_).inv_amount_child_  := NVL(inv_amount_children_sum_, 0);
            child_level_inv_sums_(i_).inv_qty_child_     := NVL(inv_qty_children_sum_, 0);
            child_level_inv_sums_(i_).net_weight_child_  := NVL(net_weight_children_, 0);
            child_level_inv_sums_(i_).net_volume_child_  := NVL(net_volume_children_, 0);
            child_level_inv_sums_(i_).inv_curr_amt_child_ := NVL(inv_curr_amt_child_sum_, 0);
            --Reset the commonly used variables
            Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                          net_volume_children_, inv_curr_amt_child_sum_);
         END LOOP; 
         --Reset the commonly used variables           
         Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                    net_volume_children_, inv_curr_amt_child_sum_);
      END IF;

      -- Get all transaction lines that should be updated
      FOR all_trans_rec_ IN get_all_transactions(company_, agreement_id_, customer_no_, start_date_, end_date_) LOOP
         
         min_value_ := Get_Min_Value___(rebate_criteria_db_, agreement_currency_code_, 
                                        company_currency_code_, inv_amount_sum_, inv_curr_amount_sum_, 
                                        inv_qty_sum_, net_weight_, net_volume_, all_trans_rec_.customer_level,
                                        child_level_inv_sums_);
         
         -- Get the corresponding final rebate percentage
         rebate_rate_ := Rebate_Agr_Grp_Deal_Final_API.Get_Final_Rebate(agreement_id_,
                                                                        all_trans_rec_.rebate_type,
                                                                        all_trans_rec_.sales_part_rebate_group,
                                                                        all_trans_rec_.hierarchy_id,
                                                                        all_trans_rec_.customer_level,
                                                                        min_value_,
                                                                        period_stop_on_);

         -- Update the rebate transactions with the final rebate %
         Rebate_Transaction_Util_API.Add_Final_Rebate(agreement_id_,
                                                      company_,
                                                      customer_no_,
                                                      all_trans_rec_.hierarchy_id,
                                                      all_trans_rec_.customer_level,
                                                      all_trans_rec_.sales_part_rebate_group,
                                                      NULL,    -- assortment_id
                                                      NULL,    -- assortment_node_id
                                                      NULL,    -- part_no
                                                      NULL,    -- sales_unit_meas                                                      
                                                      all_trans_rec_.rebate_type,
                                                      all_trans_rec_.tax_code,
                                                      rebate_rate_,
                                                      all_trans_rec_.invoice_id, 
                                                      all_trans_rec_.item_id);
      END LOOP;

   -- For all customer purchases
   ELSIF sales_rebate_basis_ = 'TOTAL_CUSTOMER_SALES' THEN
      -- Get total invoice amount for all customers invoice lines
      OPEN get_invoice_amount_all_sales(company_, customer_no_, start_date_, end_date_);
      FETCH get_invoice_amount_all_sales INTO inv_amount_sum_, inv_qty_sum_, net_weight_, net_volume_, inv_curr_amount_sum_;
      CLOSE get_invoice_amount_all_sales;

      IF children_ > 0 THEN
         -- The agreement has deal lines defined from child levels. So need to consider sales from the children.
         FOR i_ IN 1 .. children_ LOOP
            customer_no_tab_ := CUST_HIERARCHY_STRUCT_API.Get_Customers_In_Level(agreement_rec_.hierarchy_id, 
                                                                                 child_line_levels_(i_).customer_level);
            -- Consider customers in child level for their total sales.
            IF (customer_no_tab_.COUNT > 0) THEN
               -- Get the children's total invoice amount for the sales part rebate group
               FOR c_ IN 1 .. customer_no_tab_.COUNT LOOP
                  OPEN get_invoice_amount_all_sales(company_, customer_no_tab_(c_), start_date_, end_date_);
                  FETCH get_invoice_amount_all_sales INTO inv_amount_child_, inv_qty_child_, 
                                                            net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                  CLOSE get_invoice_amount_all_sales;

                  IF (Child_Has_Reb_Trans___(rebate_criteria_db_, 
                                             agreement_currency_code_,
                                             company_currency_code_,
                                             inv_amount_child_,
                                             inv_curr_amt_child_,
                                             inv_qty_child_,
                                             net_weight_child_,
                                             net_volume_child_ ) = FALSE) THEN 
                     -- Child customer might have sales even though there are no agreements valid for him
                     OPEN get_inv_amount_all_sales_child(company_, customer_no_tab_(c_), start_date_, end_date_);
                     FETCH get_inv_amount_all_sales_child INTO inv_amount_child_, inv_qty_child_, 
                                                              net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                     CLOSE get_inv_amount_all_sales_child;
                  END IF;

                  inv_amount_children_sum_   := NVL(inv_amount_children_sum_, 0) + NVL(inv_amount_child_, 0);
                  inv_qty_children_sum_      := NVL(inv_qty_children_sum_, 0)    + NVL(inv_qty_child_, 0);
                  net_weight_children_       := NVL(net_weight_children_, 0)     + NVL(net_weight_child_, 0);
                  net_volume_children_       := NVL(net_volume_children_, 0)     + NVL(net_volume_child_, 0);
                  inv_curr_amt_child_sum_    := NVL(inv_curr_amt_child_sum_, 0)  + NVL(inv_curr_amt_child_, 0);
               END LOOP;
            END IF;
            -- Store under the level, so when rate calculates for the level the totals can be used
            child_level_inv_sums_(i_).child_level_       := child_line_levels_(i_).customer_level;
            child_level_inv_sums_(i_).inv_amount_child_  := NVL(inv_amount_children_sum_, 0);
            child_level_inv_sums_(i_).inv_qty_child_     := NVL(inv_qty_children_sum_, 0);
            child_level_inv_sums_(i_).net_weight_child_  := NVL(net_weight_children_, 0);
            child_level_inv_sums_(i_).net_volume_child_  := NVL(net_volume_children_, 0);
            child_level_inv_sums_(i_).inv_curr_amt_child_ := NVL(inv_curr_amt_child_sum_, 0);
            --Reset the commonly used variables
            Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                          net_volume_children_, inv_curr_amt_child_sum_);
         END LOOP; 
         --Reset the commonly used variables           
         Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                    net_volume_children_, inv_curr_amt_child_sum_);
      END IF;

      -- Get all transaction lines that should be updated
      FOR all_trans_rec_ IN get_all_transactions(company_, agreement_id_, customer_no_, start_date_, end_date_) LOOP
         
         min_value_ := Get_Min_Value___(rebate_criteria_db_, agreement_currency_code_, 
                                        company_currency_code_, inv_amount_sum_, inv_curr_amount_sum_, 
                                        inv_qty_sum_, net_weight_, net_volume_, all_trans_rec_.customer_level,
                                        child_level_inv_sums_);
                     
         -- Get the corresponding final rebate percentage
         rebate_rate_ := Rebate_Agr_Grp_Deal_Final_API.Get_Final_Rebate(agreement_id_,
                                                                        all_trans_rec_.rebate_type,
                                                                        all_trans_rec_.sales_part_rebate_group,
                                                                        all_trans_rec_.hierarchy_id,
                                                                        all_trans_rec_.customer_level,
                                                                        min_value_,
                                                                        period_stop_on_);

         -- Update the rebate transactions with the final rebate %
         Rebate_Transaction_Util_API.Add_Final_Rebate(agreement_id_,
                                                      company_,
                                                      customer_no_,
                                                      all_trans_rec_.hierarchy_id,
                                                      all_trans_rec_.customer_level,
                                                      all_trans_rec_.sales_part_rebate_group,
                                                      NULL,    -- assortment_id
                                                      NULL,    -- assortment_node_id
                                                      NULL,    -- part_no
                                                      NULL,    -- sales_unit_meas                                                      
                                                      all_trans_rec_.rebate_type,
                                                      all_trans_rec_.tax_code,
                                                      rebate_rate_,
                                                      all_trans_rec_.invoice_id, 
                                                      all_trans_rec_.item_id);
      END LOOP;
   END IF;
END Calculate_Total_Sales;


PROCEDURE Calculate_Total_Assort_Sales (
   company_            IN VARCHAR2,
   agreement_id_       IN VARCHAR2,
   customer_no_        IN VARCHAR2,
   sales_rebate_basis_ IN VARCHAR2,
   start_date_         IN DATE,
   end_date_           IN DATE,
   period_stop_on_     IN DATE )
IS
   customer_level_          NUMBER;
   children_                NUMBER;
   inv_amount_sum_          NUMBER;
   inv_amount_children_sum_ NUMBER;
   inv_qty_sum_             NUMBER;
   inv_qty_children_sum_    NUMBER;
   rebate_rate_             NUMBER;
   min_value_               NUMBER;
   net_weight_              NUMBER;
   net_volume_              NUMBER;
   net_weight_children_     NUMBER;
   net_volume_children_     NUMBER;
   rebate_criteria_db_      rebate_agreement_tab.rebate_criteria%TYPE;
   inv_curr_amount_sum_     NUMBER;
   inv_curr_amt_child_sum_  NUMBER;
   agreement_currency_code_ VARCHAR2(3);
   company_currency_code_   VARCHAR2(3);  
   agreement_rec_           Rebate_Agreement_API.Public_Rec;
   customer_no_tab_         Cust_Hierarchy_Struct_API.Customer_No_Tab;
   net_weight_child_        NUMBER;
   net_volume_child_        NUMBER;
   inv_curr_amt_child_      NUMBER;
   inv_qty_child_           NUMBER;
   inv_amount_child_        NUMBER;
   child_level_inv_sums_    Hierarchy_level_Inv_Sums;
   
   -- Check if there are any agreement lines for the customer's children
   CURSOR get_line_levels (agreement_id_ IN VARCHAR2, customer_no_ IN VARCHAR2, customer_level_ IN NUMBER) IS
      SELECT rag.customer_level customer_level
      FROM rebate_agreement_assort_tab rag, rebate_agreement_receiver_tab rar
      WHERE rag.agreement_id = rar.agreement_id
      AND   rag.agreement_id = agreement_id_
      AND   rar.customer_no = customer_no_
      AND   rag.customer_level > customer_level_
      AND   TRUNC(end_date_) BETWEEN TRUNC(rag.valid_from) AND TRUNC(NVL(rag.valid_to_date,Database_Sys.last_calendar_date_));

   TYPE child_line_levels IS TABLE OF get_line_levels%ROWTYPE INDEX BY PLS_INTEGER;  
   child_line_levels_   child_line_levels;
   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the invoice lines for a specific assortment node
   CURSOR get_invoice_amount (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                              start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum, assortment_id, assortment_node_id
      FROM Rebate_Trans_Invoice_Amounts
      WHERE  company = company_
      AND    customer_no = customer_no_
      AND    agreement_type = Rebate_Agreement_Type_API.DB_ASSORTMENT
      AND    transaction_date BETWEEN start_date_ AND end_date_
      GROUP BY assortment_id, assortment_node_id;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the children's invoice lines for a specific assortment node
   CURSOR get_invoice_amount_child (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                       start_date_ IN DATE, end_date_ IN DATE, assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Rebate_Trans_Invoice_Amounts
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_ASSORTMENT
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   assortment_node_id = assortment_node_id_
      AND   assortment_id = assortment_id_;
      
   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the children's invoice lines for a specific assortment node 
   CURSOR get_invoice_amount_child2 (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                       start_date_ IN DATE, end_date_ IN DATE, assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Order_Line_Invoice_Amounts
      WHERE company                 = company_
      AND   customer_no             = customer_no_
      AND   assortment_node_id      = assortment_node_id_
      AND   assortment_id           = assortment_id_
      AND   transaction_date BETWEEN start_date_ AND end_date_;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the invoice lines for all assortments
   CURSOR get_invoice_amount_all_groups (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                         start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Rebate_Trans_Invoice_Amounts
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_ASSORTMENT
      AND   transaction_date BETWEEN start_date_ AND end_date_;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the children's invoice lines for all assortments
   CURSOR get_inv_amount_all_group_child (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                          start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Order_Line_Invoice_Amounts
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   assortment_id IS NOT NULL
      AND   transaction_date BETWEEN start_date_ AND end_date_;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the invoice lines for a customer
   CURSOR get_invoice_amount_all_sales (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                        start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Rebate_Trans_Invoice_Amounts
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   transaction_date BETWEEN start_date_ AND end_date_;

   -- Summarize the net_dom_amount, invoiced_qty, net_weight and net_volume on all the children's invoice lines  for a customer
   CURSOR get_inv_amount_all_sales_child (company_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                          start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT SUM(net_dom_amount) inv_amount_sum, SUM(invoiced_qty) inv_qty_sum, SUM(net_weight) inv_net_weight, 
             SUM(net_volume) inv_net_volume, SUM(inv_line_sales_curr_amount) inv_curr_amount_sum
      FROM Order_Line_Invoice_Amounts
      WHERE company                 = company_
      AND   customer_no             = customer_no_
      AND   transaction_date BETWEEN start_date_ AND end_date_;

   CURSOR get_all_transactions (company_ IN VARCHAR2, agreement_id_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                start_date_ IN DATE, end_date_ IN DATE) IS
      SELECT rebate_type, assortment_id, assortment_node_id, hierarchy_id, customer_level, tax_code, invoice_id, item_id
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   agreement_id = agreement_id_
      AND   customer_no = customer_no_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_ASSORTMENT
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no IS NULL;
      
   CURSOR get_trans_per_ass_node (company_ IN VARCHAR2, agreement_id_ IN VARCHAR2, customer_no_ IN VARCHAR2,
                                  start_date_ IN DATE, end_date_ IN DATE, assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2) IS
      SELECT rebate_type, assortment_id, assortment_node_id, hierarchy_id, customer_level, tax_code, invoice_id, item_id
      FROM rebate_transaction_tab
      WHERE company = company_
      AND   agreement_id = agreement_id_
      AND   customer_no = customer_no_
      AND   agreement_type = Rebate_Agreement_Type_API.DB_ASSORTMENT
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no IS NULL
      AND   assortment_node_id = assortment_node_id_
      AND   assortment_id = assortment_id_;

BEGIN
   agreement_rec_             := Rebate_Agreement_API.Get(agreement_id_);
   customer_level_            := agreement_rec_.customer_level;  
   rebate_criteria_db_        := agreement_rec_.rebate_criteria;
   agreement_currency_code_   := agreement_rec_.currency_code;
   company_currency_code_     := Company_Finance_API.Get_Currency_Code(company_);
   
   -- Are there agreement lines for the customer's children (higher customer level)
   OPEN get_line_levels (agreement_id_, customer_no_, customer_level_);
   FETCH get_line_levels BULK COLLECT INTO child_line_levels_;
   CLOSE get_line_levels;
   children_ := child_line_levels_.COUNT;
   
   -- For a specific assortment node
   IF (sales_rebate_basis_ = 'SPECIFIC_ASSORT_NODE_SALES') THEN
      -- Get total invoice amount for the assortment node
      FOR inv_rec_ IN get_invoice_amount(company_, customer_no_, start_date_, end_date_) LOOP
         inv_amount_sum_      := NVL(inv_rec_.inv_amount_sum, 0);
         inv_qty_sum_         := NVL(inv_rec_.inv_qty_sum, 0);
         net_weight_          := NVL(inv_rec_.inv_net_weight, 0);
         net_volume_          := NVL(inv_rec_.inv_net_volume, 0);
         inv_curr_amount_sum_ := NVL(inv_rec_.inv_curr_amount_sum, 0);
         
         IF children_ > 0 THEN
            -- The agreement has deal lines defined from child levels. So need to consider sales from the children.
            FOR i_ IN 1 .. children_ LOOP
               customer_no_tab_ := CUST_HIERARCHY_STRUCT_API.Get_Customers_In_Level(agreement_rec_.hierarchy_id, child_line_levels_(i_).customer_level);
               -- Consider customers in child level for their total sales.
               IF (customer_no_tab_.COUNT > 0) THEN
                  -- Get the children's total invoice amount for the sales part rebate group
                  FOR c_ IN 1 .. customer_no_tab_.COUNT LOOP
                     OPEN get_invoice_amount_child(company_, customer_no_tab_(c_), start_date_, end_date_, inv_rec_.assortment_id, inv_rec_.assortment_node_id);
                     FETCH get_invoice_amount_child INTO inv_amount_child_, inv_qty_child_, 
                                                         net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                     CLOSE get_invoice_amount_child;
                                          
                     IF (Child_Has_Reb_Trans___(rebate_criteria_db_, 
                                                agreement_currency_code_,
                                                company_currency_code_,
                                                inv_amount_child_,
                                                inv_curr_amt_child_,
                                                inv_qty_child_,
                                                net_weight_child_,
                                                net_volume_child_ ) = FALSE) THEN
                        -- Child customer might have sales even though there are no agreements valid for him
                        OPEN get_invoice_amount_child2(company_, customer_no_tab_(c_), start_date_, end_date_, inv_rec_.assortment_id, inv_rec_.assortment_node_id);
                        FETCH get_invoice_amount_child2 INTO inv_amount_child_, inv_qty_child_, 
                                                             net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                        CLOSE get_invoice_amount_child2;
                     END IF;
                     
                     inv_amount_children_sum_   := NVL(inv_amount_children_sum_, 0) + NVL(inv_amount_child_, 0);
                     inv_qty_children_sum_      := NVL(inv_qty_children_sum_, 0)    + NVL(inv_qty_child_, 0);
                     net_weight_children_       := NVL(net_weight_children_, 0)     + NVL(net_weight_child_, 0);
                     net_volume_children_       := NVL(net_volume_children_, 0)     + NVL(net_volume_child_, 0);
                     inv_curr_amt_child_sum_    := NVL(inv_curr_amt_child_sum_, 0)  + NVL(inv_curr_amt_child_, 0);
                  END LOOP;
               END IF;
               -- Store under the level, so when rate calculates for the level the totals can be used
               child_level_inv_sums_(i_).child_level_       := child_line_levels_(i_).customer_level;
               child_level_inv_sums_(i_).inv_amount_child_  := NVL(inv_amount_children_sum_, 0);
               child_level_inv_sums_(i_).inv_qty_child_     := NVL(inv_qty_children_sum_, 0);
               child_level_inv_sums_(i_).net_weight_child_  := NVL(net_weight_children_, 0);
               child_level_inv_sums_(i_).net_volume_child_  := NVL(net_volume_children_, 0);
               child_level_inv_sums_(i_).inv_curr_amt_child_ := NVL(inv_curr_amt_child_sum_, 0);
               --Reset the commonly used variables
               Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                          net_volume_children_, inv_curr_amt_child_sum_);
            END LOOP; 
            --Reset the commonly used variables           
            Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                       net_volume_children_, inv_curr_amt_child_sum_);
         END IF;

         -- Get all transaction lines that should be updated
         FOR all_trans_rec_ IN get_trans_per_ass_node(company_, agreement_id_, customer_no_, start_date_, end_date_, inv_rec_.assortment_id, inv_rec_.assortment_node_id) LOOP
            
            min_value_ := Get_Min_Value___(rebate_criteria_db_, agreement_currency_code_, 
                                             company_currency_code_, inv_amount_sum_, inv_curr_amount_sum_, 
                                             inv_qty_sum_, net_weight_, net_volume_, all_trans_rec_.customer_level,
                                             child_level_inv_sums_);

            -- Get the corresponding final rebate percentage                                                     
            rebate_rate_ := Rebate_Agr_Assort_Final_API.Get_Final_Rebate(agreement_id_,
                                                                         all_trans_rec_.hierarchy_id,
                                                                         all_trans_rec_.customer_level,
                                                                         all_trans_rec_.rebate_type,
                                                                         all_trans_rec_.assortment_id,
                                                                         all_trans_rec_.assortment_node_id,
                                                                         min_value_,
                                                                         period_stop_on_);

            -- Update the rebate transactions with the final rebate %
            Rebate_Transaction_Util_API.Add_Final_Rebate(agreement_id_,
                                                         company_,
                                                         customer_no_,
                                                         all_trans_rec_.hierarchy_id,
                                                         all_trans_rec_.customer_level,
                                                         NULL,          --- sales_part_rebate_group,
                                                         all_trans_rec_.assortment_id,
                                                         all_trans_rec_.assortment_node_id,
                                                         NULL,    -- part_no
                                                         NULL,    -- sales_unit_meas                                                      
                                                         all_trans_rec_.rebate_type,
                                                         all_trans_rec_.tax_code,
                                                         rebate_rate_,
                                                         all_trans_rec_.invoice_id, 
                                                         all_trans_rec_.item_id);
         END LOOP;
      END LOOP;   
   -- For all sales part rebate groups
   ELSIF sales_rebate_basis_ = 'TOTAL_ASSORTMENT_SALES' THEN
      -- Get total invoice amount for all assortments
      OPEN get_invoice_amount_all_groups(company_, customer_no_, start_date_, end_date_);
      FETCH get_invoice_amount_all_groups INTO inv_amount_sum_, inv_qty_sum_, net_weight_, net_volume_, inv_curr_amount_sum_;
      CLOSE get_invoice_amount_all_groups;

      IF children_ > 0 THEN
         -- The agreement has deal lines defined from child levels. So need to consider sales from the children.
         FOR i_ IN 1 .. children_ LOOP
            customer_no_tab_ := CUST_HIERARCHY_STRUCT_API.Get_Customers_In_Level(agreement_rec_.hierarchy_id, 
                                                                                 child_line_levels_(i_).customer_level);
            -- Consider customers in child level for their total sales.
            IF (customer_no_tab_.COUNT > 0) THEN
               -- Get the children's total invoice amount for the sales part rebate group
               FOR c_ IN 1 .. customer_no_tab_.COUNT LOOP
                  OPEN get_invoice_amount_all_groups(company_, customer_no_tab_(c_), start_date_, end_date_);
                  FETCH get_invoice_amount_all_groups INTO inv_amount_child_, inv_qty_child_, 
                                                            net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                  CLOSE get_invoice_amount_all_groups;

                  IF (Child_Has_Reb_Trans___(rebate_criteria_db_, 
                                             agreement_currency_code_,
                                             company_currency_code_,
                                             inv_amount_child_,
                                             inv_curr_amt_child_,
                                             inv_qty_child_,
                                             net_weight_child_,
                                             net_volume_child_ ) = FALSE) THEN 
                     -- Child customer might have sales even though there are no agreements valid for him
                     OPEN get_inv_amount_all_group_child(company_, customer_no_tab_(c_), start_date_, end_date_);
                     FETCH get_inv_amount_all_group_child INTO inv_amount_child_, inv_qty_child_, 
                                                              net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                     CLOSE get_inv_amount_all_group_child;
                  END IF;

                  inv_amount_children_sum_   := NVL(inv_amount_children_sum_, 0) + NVL(inv_amount_child_, 0);
                  inv_qty_children_sum_      := NVL(inv_qty_children_sum_, 0)    + NVL(inv_qty_child_, 0);
                  net_weight_children_       := NVL(net_weight_children_, 0)     + NVL(net_weight_child_, 0);
                  net_volume_children_       := NVL(net_volume_children_, 0)     + NVL(net_volume_child_, 0);
                  inv_curr_amt_child_sum_    := NVL(inv_curr_amt_child_sum_, 0)  + NVL(inv_curr_amt_child_, 0);
               END LOOP;
            END IF;
            -- Store under the level, so when rate calculates for the level the totals can be used
            child_level_inv_sums_(i_).child_level_       := child_line_levels_(i_).customer_level;
            child_level_inv_sums_(i_).inv_amount_child_  := NVL(inv_amount_children_sum_, 0);
            child_level_inv_sums_(i_).inv_qty_child_     := NVL(inv_qty_children_sum_, 0);
            child_level_inv_sums_(i_).net_weight_child_  := NVL(net_weight_children_, 0);
            child_level_inv_sums_(i_).net_volume_child_  := NVL(net_volume_children_, 0);
            child_level_inv_sums_(i_).inv_curr_amt_child_ := NVL(inv_curr_amt_child_sum_, 0);
            --Reset the commonly used variables
            Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                          net_volume_children_, inv_curr_amt_child_sum_);
         END LOOP; 
         --Reset the commonly used variables           
         Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                    net_volume_children_, inv_curr_amt_child_sum_);
      END IF;

      -- Get all transaction lines that should be updated
      FOR all_trans_rec_ IN get_all_transactions(company_, agreement_id_, customer_no_, start_date_, end_date_) LOOP
         
         min_value_ := Get_Min_Value___(rebate_criteria_db_, agreement_currency_code_, 
                                        company_currency_code_, inv_amount_sum_, inv_curr_amount_sum_, 
                                        inv_qty_sum_, net_weight_, net_volume_, all_trans_rec_.customer_level,
                                        child_level_inv_sums_);
         
         -- Get the corresponding final rebate percentage
         rebate_rate_ := Rebate_Agr_Assort_Final_API.Get_Final_Rebate(agreement_id_,
                                                                      all_trans_rec_.hierarchy_id,
                                                                      all_trans_rec_.customer_level,
                                                                      all_trans_rec_.rebate_type,
                                                                      all_trans_rec_.assortment_id,
                                                                      all_trans_rec_.assortment_node_id,
                                                                      min_value_,
                                                                      period_stop_on_);

         -- Update the rebate transactions with the final rebate %
         Rebate_Transaction_Util_API.Add_Final_Rebate(agreement_id_,
                                                      company_,
                                                      customer_no_,
                                                      all_trans_rec_.hierarchy_id,
                                                      all_trans_rec_.customer_level,
                                                      NULL,          --- sales_part_rebate_group,
                                                      all_trans_rec_.assortment_id,
                                                      all_trans_rec_.assortment_node_id,
                                                      NULL,    -- part_no
                                                      NULL,    -- sales_unit_meas                                                      
                                                      all_trans_rec_.rebate_type,
                                                      all_trans_rec_.tax_code,
                                                      rebate_rate_,
                                                      all_trans_rec_.invoice_id, 
                                                      all_trans_rec_.item_id);
      END LOOP;

   -- For all customer purchases
   ELSIF sales_rebate_basis_ = 'TOTAL_CUSTOMER_SALES' THEN
      -- Get total invoice amount for all customers invoice lines
      OPEN get_invoice_amount_all_sales(company_, customer_no_, start_date_, end_date_);
      FETCH get_invoice_amount_all_sales INTO inv_amount_sum_, inv_qty_sum_, net_weight_, net_volume_, inv_curr_amount_sum_;
      CLOSE get_invoice_amount_all_sales;

      IF children_ > 0 THEN
         -- The agreement has deal lines defined from child levels. So need to consider sales from the children.
         FOR i_ IN 1 .. children_ LOOP
            customer_no_tab_ := CUST_HIERARCHY_STRUCT_API.Get_Customers_In_Level(agreement_rec_.hierarchy_id, 
                                                                                 child_line_levels_(i_).customer_level);
            -- Consider customers in child level for their total sales.
            IF (customer_no_tab_.COUNT > 0) THEN
               -- Get the children's total invoice amount for the sales part rebate group
               FOR c_ IN 1 .. customer_no_tab_.COUNT LOOP
                  OPEN get_invoice_amount_all_sales(company_, customer_no_tab_(c_), start_date_, end_date_);
                  FETCH get_invoice_amount_all_sales INTO inv_amount_child_, inv_qty_child_, 
                                                            net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                  CLOSE get_invoice_amount_all_sales;

                  IF (Child_Has_Reb_Trans___(rebate_criteria_db_, 
                                             agreement_currency_code_,
                                             company_currency_code_,
                                             inv_amount_child_,
                                             inv_curr_amt_child_,
                                             inv_qty_child_,
                                             net_weight_child_,
                                             net_volume_child_ ) = FALSE) THEN 
                     -- Child customer might have sales even though there are no agreements valid for him
                     OPEN get_inv_amount_all_sales_child(company_, customer_no_tab_(c_), start_date_, end_date_);
                     FETCH get_inv_amount_all_sales_child INTO inv_amount_child_, inv_qty_child_, 
                                                              net_weight_child_, net_volume_child_, inv_curr_amt_child_;
                     CLOSE get_inv_amount_all_sales_child;
                  END IF;

                  inv_amount_children_sum_   := NVL(inv_amount_children_sum_, 0) + NVL(inv_amount_child_, 0);
                  inv_qty_children_sum_      := NVL(inv_qty_children_sum_, 0)    + NVL(inv_qty_child_, 0);
                  net_weight_children_       := NVL(net_weight_children_, 0)     + NVL(net_weight_child_, 0);
                  net_volume_children_       := NVL(net_volume_children_, 0)     + NVL(net_volume_child_, 0);
                  inv_curr_amt_child_sum_    := NVL(inv_curr_amt_child_sum_, 0)  + NVL(inv_curr_amt_child_, 0);
               END LOOP;
            END IF;
            -- Store under the level, so when rate calculates for the level the totals can be used
            child_level_inv_sums_(i_).child_level_       := child_line_levels_(i_).customer_level;
            child_level_inv_sums_(i_).inv_amount_child_  := NVL(inv_amount_children_sum_, 0);
            child_level_inv_sums_(i_).inv_qty_child_     := NVL(inv_qty_children_sum_, 0);
            child_level_inv_sums_(i_).net_weight_child_  := NVL(net_weight_children_, 0);
            child_level_inv_sums_(i_).net_volume_child_  := NVL(net_volume_children_, 0);
            child_level_inv_sums_(i_).inv_curr_amt_child_ := NVL(inv_curr_amt_child_sum_, 0);
            --Reset the commonly used variables
            Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                          net_volume_children_, inv_curr_amt_child_sum_);
         END LOOP; 
         --Reset the commonly used variables           
         Reset_Children_Sum_Vars___(inv_amount_children_sum_, inv_qty_children_sum_, net_weight_children_,
                                    net_volume_children_, inv_curr_amt_child_sum_);
      END IF;

      -- Get all transaction lines that should be updated
      FOR all_trans_rec_ IN get_all_transactions(company_, agreement_id_, customer_no_, start_date_, end_date_) LOOP
         
         min_value_ := Get_Min_Value___(rebate_criteria_db_, agreement_currency_code_, 
                                        company_currency_code_, inv_amount_sum_, inv_curr_amount_sum_, 
                                        inv_qty_sum_, net_weight_, net_volume_, all_trans_rec_.customer_level,
                                        child_level_inv_sums_);
        
         -- Get the corresponding final rebate percentage
         rebate_rate_ := Rebate_Agr_Assort_Final_API.Get_Final_Rebate(agreement_id_,
                                                                      all_trans_rec_.hierarchy_id,
                                                                      all_trans_rec_.customer_level,
                                                                      all_trans_rec_.rebate_type,
                                                                      all_trans_rec_.assortment_id,
                                                                      all_trans_rec_.assortment_node_id,
                                                                      min_value_,
                                                                      period_stop_on_);


         -- Update the rebate transactions with the final rebate %
         Rebate_Transaction_Util_API.Add_Final_Rebate(agreement_id_,
                                                      company_,
                                                      customer_no_,
                                                      all_trans_rec_.hierarchy_id,
                                                      all_trans_rec_.customer_level,
                                                      NULL,          --- sales_part_rebate_group,
                                                      all_trans_rec_.assortment_id,
                                                      all_trans_rec_.assortment_node_id,
                                                      NULL,    -- part_no
                                                      NULL,    -- sales_unit_meas                                                      
                                                      all_trans_rec_.rebate_type,
                                                      all_trans_rec_.tax_code,
                                                      rebate_rate_,
                                                      all_trans_rec_.invoice_id, 
                                                      all_trans_rec_.item_id);
      END LOOP;
   END IF;
END Calculate_Total_Assort_Sales;


PROCEDURE Aggregate_Period_Settlement (
   attr_ IN VARCHAR2 )
IS
   desc_ VARCHAR2(100);
BEGIN
   desc_ := Language_SYS.Translate_Constant(lu_name_, 'AGGPERIOD: Run Periodic Settlement');
   Transaction_SYS.Deferred_Call('REBATE_TRANS_AGG_UTIL_API.Aggregate_Period_Settlement__', attr_, desc_);
END Aggregate_Period_Settlement;


PROCEDURE Aggregate_Final_Settlement (
   attr_ IN VARCHAR2 )
IS
   desc_ VARCHAR2(100);
BEGIN
   desc_ := Language_SYS.Translate_Constant(lu_name_, 'AGGFINAL: Run Final Settlement');
   Transaction_SYS.Deferred_Call('REBATE_TRANS_AGG_UTIL_API.Aggregate_Final_Settlement__', attr_, desc_);   
END Aggregate_Final_Settlement;


PROCEDURE Validate_Params (
   attr_ IN VARCHAR2 )
IS
   ptr_          NUMBER;
   name_         VARCHAR2(30);
   value_        VARCHAR2(2000);
   company_      VARCHAR2(20);
   agreement_id_ VARCHAR2(10);
   customer_no_  REBATE_PERIODIC_AGG_HEAD_TAB.customer_no%TYPE;
   to_date_      DATE;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'COMPANY') THEN
         company_ := value_;
      ELSIF (name_ = 'AGREEMENT_ID') THEN
         agreement_id_ := value_;
      ELSIF (name_ = 'CUSTOMER_NO') THEN
         customer_no_ := value_;
      ELSIF (name_ = 'TO_DATE') THEN
         to_date_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   IF agreement_id_ IS NOT NULL THEN
      Rebate_Agreement_API.Exist(agreement_id_);
   END IF;
   IF customer_no_ IS NOT NULL THEN
      Cust_Ord_Customer_API.Exist(customer_no_);
   END IF;
END Validate_Params;


PROCEDURE Start_Create_Rebate_Cre_Inv (
   attr_ IN VARCHAR2 )
IS
   ptr_              NUMBER;
   name_             VARCHAR2(30);
   value_            VARCHAR2(2000);
   start_event_      NUMBER;
   settlement_attr_  VARCHAR2(2000);
   description_      VARCHAR2(200);
BEGIN

   Client_SYS.Clear_Attr(settlement_attr_);

   -- Loop passed settlements
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'START_EVENT') THEN
         start_event_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;
      -- 'END' should be the last parameter passed for each settlement
      IF (name_ = 'END') THEN
         IF (start_event_ = 500) THEN
            description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_CRE_REB_INV: Create Rebate Credit Invoice');
            Transaction_SYS.Deferred_Call('REBATE_TRANS_AGG_UTIL_API.Process_Rebate_Settlements__', settlement_attr_, description_);
         ELSIF (start_event_ = 600) THEN
            -- Create and Print the invoice
            Client_SYS.Add_To_Attr('PRINT_INVOICE', 'TRUE', settlement_attr_);
            description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_CRE_REB_INV_P: Create and Print Rebate Credit Invoice');
            Transaction_SYS.Deferred_Call('REBATE_TRANS_AGG_UTIL_API.Process_Rebate_Settlements__', settlement_attr_, description_);
         END IF;
         Client_SYS.Clear_Attr(settlement_attr_);
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, settlement_attr_);
      END IF;
   END LOOP;
END Start_Create_Rebate_Cre_Inv;






 
